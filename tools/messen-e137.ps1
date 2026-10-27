# messen-e137.ps1 - Regressionstest zu Befund E-137: Strg-W nach einem Klick
# auf Titelzeile oder Rand des SCHWEBENDEN Filterfensters muss das
# Filterfenster verstecken, nicht das Fenster dahinter schliessen.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# bekommt -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus
# diesem Pfad. Nur Botschaften an gemessene Fensterhandles, kein Tastendruck
# (Arbeitsweise/keine-tastendruecke-verschicken.md).
#
# WARUM ES DAS GIBT. Gregor an Paket 1.0.125 (26.10.2026, Kurztest U1):
# Filterfenster schwebend, erst in die Mail geklickt, dann auf die
# Titelzeile des Filterfensters, dann Strg+W - die Mail ging zu. Die
# Behebung aus 7.2.0.125 sass in QCMiniDockFrameWnd und lief nie, weil
# CFrameWnd::EnableDocking die Rahmenklasse ueberschreibt (PRUEFER-61 K1).
# Die Unit-Tests lasen nur den Quelltext und waren gruen. Dieser Fall misst
# am laufenden Programm (Gregor 27.10.2026: "ja, bau auch den test dafuer").
#
# DER WEG, nachgestellt mit Fensterbotschaften:
#   1. Postfach In oeffnen (ID_MAILBOX_IN) - das ist "die Mail": das aktive
#      MDI-Fenster, das Strg-W faelschlich schloss.
#   2. Filterfenster zeigen (ID_WINDOW_FILTERS); ist es angedockt, ueber
#      ID_SEC_ALLOWDOCKING an die Leiste schwebend machen.
#   3. Je Durchgang: in die Liste von In klicken (WM_LBUTTONDOWN/UP), dann
#      WM_NCLBUTTONDOWN an den Rahmen der schwebenden Leiste - Durchgang
#      "titel" mit HTCAPTION (Gregors U1), Durchgang "rand" mit HTLEFT (U2) -,
#      WM_LBUTTONUP hinterher, damit die Zieh-/Groessenschleife endet.
#   4. ID_FILE_CLOSE an das Hauptfenster - genau das, was die Tastentabelle
#      aus Strg-W macht (EudoraRes.rc: "W", ID_FILE_CLOSE, VIRTKEY, CONTROL).
#   5. Gemessen: ist In noch da, ist die Leiste versteckt?
#
# Ausgabe: Zeilen "E137 ...". Erwartet:
#   E137 ERGEBNIS titel: mail-offen=1 leiste-versteckt=1
#   E137 ERGEBNIS rand: mail-offen=1 leiste-versteckt=1
# Am Bau 1.0.125 (ohne Behebung) muss "mail-offen=0" herauskommen.
#
# Vorbereiten (vor dem Start, von pruefstand-lauf.ps1 gerufen):
#   tools\messen-e137.ps1 -Vorbereiten -Pfadfilter C:\Temp\E137
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E137 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$ini = Join-Path $md 'Eudora.ini'
$vorlage = Join-Path $md 'Eudora.ini.e137-vorlage'

# --- -Vorbereiten: gleiche Eudora.ini wie beim ersten Lauf, In mit einer Nachricht
# Die Pfadschranke steht vor jeder Wirkung (Arbeitsweise/tor-gehoert-zum-schritt.md).
# Die Leistenanordnung steht in der Eudora.ini; ohne Vorlage wuerde jeder
# Lauf die Lage des vorigen erben (schwebend, versteckt).
if ($Vorbereiten) {
    if (-not (Test-Path -LiteralPath $ini)) { Write-Host "E137 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    if (-not (Test-Path -LiteralPath $vorlage)) { Copy-Item -LiteralPath $ini -Destination $vorlage }
    Copy-Item -LiteralPath $vorlage -Destination $ini -Force
    # Das Protokoll des vorigen Laufs muss weg: sonst findet der Fall E-137c
    # die Zeile des LETZTEN Laufs (gemessen 27.10.2026 an der Gegenprobe mit
    # 1.0.125 - die Zeilen stammten aus dem Lauf mit 1.0.126 davor).
    Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^eudora\.log' } | Remove-Item -Force
    Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^In\.(mbx|toc)(\.\d{3})?$' } | Remove-Item -Force
    $eml = Join-Path (Split-Path -Parent $PSScriptRoot) 'Testdaten\e118-html-in-imap-ordner.eml'
    $b = [IO.File]::ReadAllBytes($eml)
    $kopf = [Text.Encoding]::ASCII.GetBytes("From ???@??? Mon Oct 27 10:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopf + $b + $ende))
    Write-Host ("E137 vorbereitet: {0}" -f $md)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E137 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr GetParent(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr GetAncestor(IntPtr h, uint f);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E137]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E137]::GetWindowTextA($h,$s,512); $s.ToString() }
function Rechteck($h) { $r = New-Object E137+R; [void][E137]::GetWindowRect($h,[ref]$r); return $r }
# Nicht "Lp" nennen: das ist in PowerShell der Alias fuer Out-Printer
# (gemessen 27.10.2026 - der erste Lauf brach genau hier ab).
function Mauspunkt([int] $x, [int] $y) { return [IntPtr](($y -shl 16) -bor ($x -band 0xFFFF)) }

function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E137+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E137]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}

function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E137+EP]{ param($h,$p)
        $o = 0; [void][E137]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E137]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E137]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E137]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}

function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }

function Dialoge($pp) {
    $n = 0
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        $texte = @(); $knoepfe = @()
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button')         { $knoepfe += [pscustomobject]@{H=$c; T=$t} }
        }
        Write-Host ("E137 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match '^(OK)$' } | Select-Object -First 1
        if ($b) { [void][E137]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E137]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL, nie blind OK
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}

function Befehl($h, [int] $id) { [void][E137]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E137]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE

# Die Filterleiste wird an einem MERKMAL erkannt (Arbeitsweise/messziel-am-
# merkmal-erkennen.md): an ihrem Gruppenfeld "Match" (IDC_MATCH, EudoraRes.rc).
# Die Leiste selbst ist der Vorfahr, dessen Elternfenster eine Andockleiste
# ist - MFC gibt ihnen die Kennungen AFX_IDW_DOCKBAR_TOP bis _FLOAT
# (0xE81B..0xE81F, afxres.h).
function Filterleiste($pp) {
    $m = AlleFenster $pp | Where-Object { -not $_.Oben -and $_.Klasse -eq 'Button' -and $_.Text -eq 'Match' } | Select-Object -First 1
    if (-not $m) { return $null }
    $h = $m.H
    while ($h -ne [IntPtr]::Zero) {
        $p = [E137]::GetParent($h)
        if ($p -eq [IntPtr]::Zero) { return $null }
        $id = [E137]::GetDlgCtrlID($p)
        if ($id -ge 0xE81B -and $id -le 0xE81F) { return $h }
        $h = $p
    }
    return $null
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E137 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E137 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E137 Prozess $pp Hauptfenster $haupt MDI $mdi"
$start = Dialoge $pp
if ($start) { Write-Host "E137 beim Start $start Dialog(e)" }

foreach ($lauf in @(@{Name='titel'; Zone=2}, @{Name='rand'; Zone=10})) {    # HTCAPTION, HTLEFT
    if (-not (Lebt $pp)) { Write-Host ("E137 ERGEBNIS {0}: Eudora lebt nicht mehr" -f $lauf.Name); continue }

    # 1. In oeffnen (bleibt offen, wenn es schon offen ist)
    Befehl $haupt 32792                                 # ID_MAILBOX_IN
    $in = Aktiv $mdi
    Write-Host ("E137 {0}: aktives MDI-Fenster {1} [{2}]" -f $lauf.Name, $in, (Tx $in))
    # Kein Namensvergleich: der Titel des aktiven Fensters ist hier der Name
    # der HTML-Vorschaudatei (gemessen 27.10.2026: "...\eud2.htm"). Gemessen
    # wird nur, ob DIESES Fenster das Strg-W ueberlebt.
    if ($in -eq [IntPtr]::Zero) {
        Write-Host ("E137 ERGEBNIS {0}: ungemessen - kein aktives MDI-Fenster" -f $lauf.Name); continue
    }

    # 2. Filterfenster zeigen und schwebend machen
    Befehl $haupt 32826                                 # ID_WINDOW_FILTERS
    $leiste = Filterleiste $pp
    if (-not $leiste) { Write-Host ("E137 ERGEBNIS {0}: ungemessen - Filterleiste nicht gefunden" -f $lauf.Name); continue }
    $rahmen = [E137]::GetAncestor($leiste, 2)           # GA_ROOT
    if ($rahmen -eq $haupt) {
        Write-Host ("E137 {0}: Filterleiste {1} ist angedockt - wird schwebend gemacht" -f $lauf.Name, $leiste)
        [void][E137]::PostMessageA($leiste, 0x0111, [IntPtr]53288, [IntPtr]::Zero)   # ID_SEC_ALLOWDOCKING
        Start-Sleep -Milliseconds 1500
        $leiste = Filterleiste $pp
        $rahmen = if ($leiste) { [E137]::GetAncestor($leiste, 2) } else { $haupt }
    }
    if ($rahmen -eq $haupt -or -not [E137]::IsWindowVisible($leiste)) {
        Write-Host ("E137 ERGEBNIS {0}: ungemessen - Filterleiste schwebt nicht oder ist nicht sichtbar" -f $lauf.Name); continue
    }
    Write-Host ("E137 {0}: Filterleiste {1} schwebt im Rahmen {2} [{3}] Klasse {4}" -f $lauf.Name, $leiste, $rahmen, (Tx $rahmen), (Kl $rahmen))

    # 3. erst in die Liste von In klicken (Gregor: "erst in die Mail klicken"),
    #    dann auf den Rahmen der schwebenden Leiste
    $liste = Kinder $in | Where-Object { (Kl $_) -eq 'ListBox' -and [E137]::IsWindowVisible($_) } | Select-Object -First 1
    if ($liste) {
        [void][E137]::PostMessageA($liste, 0x0201, [IntPtr]1, (Mauspunkt 5 5))          # WM_LBUTTONDOWN
        [void][E137]::PostMessageA($liste, 0x0202, [IntPtr]0, (Mauspunkt 5 5))          # WM_LBUTTONUP
        Start-Sleep -Milliseconds 800
    }
    $r = Rechteck $rahmen
    if ($lauf.Zone -eq 2) { $x = [int](($r.L + $r.Ri) / 2); $y = $r.T + 8 } else { $x = $r.L + 2; $y = [int](($r.T + $r.B) / 2) }
    [void][E137]::PostMessageA($rahmen, 0x00A1, [IntPtr]$lauf.Zone, (Mauspunkt $x $y))   # WM_NCLBUTTONDOWN
    Start-Sleep -Milliseconds 400
    [void][E137]::PostMessageA($rahmen, 0x0202, [IntPtr]0, (Mauspunkt 4 4))             # WM_LBUTTONUP, beendet die Schleife
    Start-Sleep -Milliseconds 800

    # 4. Strg-W, wie es aus der Tastentabelle kommt
    Befehl $haupt 57602                                 # ID_FILE_CLOSE
    [void](Dialoge $pp)

    # 5. messen
    $offen = [int]([E137]::IsWindow($in) -and [E137]::IsWindowVisible($in))
    $versteckt = [int](-not ([E137]::IsWindow($leiste) -and [E137]::IsWindowVisible($leiste)))
    Write-Host ("E137 ERGEBNIS {0}: mail-offen={1} leiste-versteckt={2}" -f $lauf.Name, $offen, $versteckt)
}
