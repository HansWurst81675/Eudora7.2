# messen-bild.ps1 - Regressionsfaelle zur Bilddarstellung am Pruefstand.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript bzw. als Schalter
# messen=tools\messen-bild.ps1 in tools\pruefstand-faelle.txt.
#
# WARUM ES DAS GIBT. Gregor am 23.10.2026: "ich denke, wir sollen zuminstest
# die regression tests haben, die mit der darstellung der bilder zu tun haben.
# so koennen wir sie dann alle ausfuehren, nachdem du mit E-113 und E-119
# fertig bist. um zu pruefen, dass nichts kaputt ging." Bis dahin gab es zu
# den Bildbefunden NUR Testsuite-Faelle, die einzelne Funktionen pruefen -
# keinen einzigen Lauf, in dem Eudora eine echte Nachricht zeichnet.
#
# WAS ES TUT
#   -Vorbereiten (vor dem Start): Postfaecher leeren, POP-Pruefserver
#     (tools\anhang-pruefdaten.pl --pop) mit den Pruefnachrichten aus
#     Testdaten\ starten. Die Nachrichten muessen ueber POP kommen - roh in
#     In.mbx gelegt laeuft der Empfangsweg nicht, und eingebettete Bilder
#     landen nie in Embedded\ (anhang-pruefdaten.pl, Kopf).
#   Messen (Eudora laeuft): Post abholen, jede Nachricht in In oeffnen (die
#     Spurmarken E-103/E-106/E-112 entstehen beim Zeichnen), weiterleiten
#     (E-110: kommen die Bilder ins Verfassen-Fenster?), Verfassen-Fenster
#     ohne Speichern und Lesefenster schliessen, am Ende den POP-Server
#     beenden.
#
# Ausgabe: "BILD ERGEBNIS abgeholt=<n> geoeffnet=<n> weitergeleitet=<n>".
# Die eigentlichen Pruefwerte stehen im eudora.log (Quelle "log").
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$NACHRICHTEN = @(
    'Testdaten\e112-bilder-groesser-als-angegeben.eml',
    'Testdaten\e116-breite-mit-einheit.eml',
    'Testdaten\e118-eingebettetes-bild.eml',
    'Testdaten\e103-bild-ohne-groessenangabe.eml',
    'Testdaten\e105-handyfassung-versteckt.eml',
    'Testdaten\e119-data-bild.eml',
    'Testdaten\e113-breites-bild.eml'
)

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
$pidDatei = Join-Path $voll 'pop-pruefserver.pid'

function PopBeenden {
    if (-not (Test-Path $pidDatei)) { return }
    $alt = [int](Get-Content $pidDatei)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "BILD POP-Pruefserver $alt beendet" }
    Remove-Item $pidDatei -Force
}

# --- -Vorbereiten: Lage frisch anlegen, VOR dem Start ----------------------
# Pfadschranke vor jeder Wirkung (Arbeitsweise/tor-gehoert-zum-schritt.md).
if ($Vorbereiten) {
    if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "BILD ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
    $md = Join-Path $voll 'Mailverzeichnis'
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "BILD FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    PopBeenden
    foreach ($n in 'In','Out','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } | Remove-Item -Force
    }
    Get-ChildItem -LiteralPath $md -File -Filter 'lmos.dat*' | Remove-Item -Force
    foreach ($d in 'spool','Embedded') { $p = Join-Path $md $d; if (Test-Path $p) { Get-ChildItem -LiteralPath $p -File | Remove-Item -Force } }
    $belegt = Get-NetTCPConnection -LocalPort 11110 -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Host "BILD FEHLER: Port 11110 ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $arg = @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml')
    foreach ($e in $NACHRICHTEN) { $arg += @('--eml', (Join-Path $repo $e)) }
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $p = Start-Process $perl -ArgumentList $arg -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("BILD vorbereitet: POP-Pruefserver PID {0} mit {1} Nachrichten" -f $p.Id, $NACHRICHTEN.Count)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class WinBild {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetMenuItemCount(IntPtr m);
  [DllImport("user32.dll")] public static extern uint GetMenuItemID(IntPtr m, int i);
  [DllImport("user32.dll")] public static extern IntPtr GetSubMenu(IntPtr m, int i);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetMenuStringA(IntPtr m, uint id, StringBuilder s, int n, uint f);
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][WinBild]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][WinBild]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object WinBild+R; [void][WinBild]::GetWindowRect($h,[ref]$r); $r.T }

function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [WinBild+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][WinBild]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}

function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [WinBild+EP]{ param($h,$p)
        $o = 0; [void][WinBild]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[WinBild]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[WinBild]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][WinBild]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}

# Jeder Dialog, der auftaucht, wird mit seinem Text ausgegeben und GEZAEHLT -
# in der Gegenprobe darf keiner erscheinen. Geschlossen wird er mit dem
# Knopf, dessen Text $Knopf trifft, sonst mit IDOK an den Dialog.
$script:dialoge = 0
function Dialoge($pp, [string] $Knopf = '^(OK)$') {
    $n = 0
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        $texte = @(); $knoepfe = @()
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button')         { $knoepfe += [pscustomobject]@{H=$c; T=$t} }
        }
        Write-Host ("BILD DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][WinBild]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][WinBild]::PostMessageA($d.H, 0x0111, [IntPtr]1, [IntPtr]::Zero) }       # IDOK
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}

function Befehl($h, [int] $id) { [void][WinBild]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }

# Das aktive MDI-Kind und seine Postfachliste (CTocListBox ist ein CListBox).
function Aktiv($mdi) { return [WinBild]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [WinBild]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][WinBild]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][WinBild]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][WinBild]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][WinBild]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][WinBild]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
}

# Befehlsnummer des Eintrags $Ziel im Menue "Transfer". Die Nummern der
# Postfaecher vergibt Eudora zur Laufzeit, deshalb wird gelesen, nicht
# festgeschrieben.
function TransferNach($haupt, [string] $Ziel) {
    $m = [WinBild]::GetMenu($haupt)
    for ($i = 0; $i -lt [WinBild]::GetMenuItemCount($m); $i++) {
        $s = New-Object Text.StringBuilder 128
        [void][WinBild]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
        if (($s.ToString() -replace '&','') -ne 'Transfer') { continue }
        $sub = [WinBild]::GetSubMenu($m, $i)
        # Die Postfacheintraege fuellt Eudora erst beim Aufklappen (gemessen
        # 23.10.2026: Mailbox und Transfer hatten vorher 0 Eintraege).
        [void][WinBild]::SendMessageA($haupt, 0x0117, $sub, [IntPtr]$i)   # WM_INITMENUPOPUP
        for ($j = 0; $j -lt [WinBild]::GetMenuItemCount($sub); $j++) {
            $t = New-Object Text.StringBuilder 128
            [void][WinBild]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
            if (($t.ToString() -replace '&','') -eq $Ziel) { return [int][WinBild]::GetMenuItemID($sub, $j) }
        }
    }
    return 0
}

# --- Prozess und Hauptfenster ----------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "BILD FEHLER: keine Eudora aus $voll"; PopBeenden; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'BILD FEHLER: kein Hauptfenster'; PopBeenden; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
$null = Dialoge $pp

# --- Post abholen -------------------------------------------------------------
Befehl $haupt 32772                               # ID_FILE_CHECKMAIL
$soll = $NACHRICHTEN.Count
$n = 0
for ($t = 0; $t -lt 30 -and $n -lt $soll; $t++) {
    Start-Sleep -Seconds 2
    $null = Dialoge $pp
    Befehl $haupt 32792                           # ID_MAILBOX_IN
    $lb = Liste (Aktiv $mdi)
    if ($lb) { $n = Anzahl $lb }
}
Write-Host "BILD abgeholt $n von $soll"

# --- jede Nachricht oeffnen und weiterleiten ----------------------------------
$geoeffnet = 0; $weiter = 0
for ($i = 0; $i -lt $n; $i++) {
    Befehl $haupt 32792
    $in = Aktiv $mdi; $lb = Liste $in
    $null = Waehle $lb $i
    [void][WinBild]::PostMessageA($lb, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN
    [void][WinBild]::PostMessageA($lb, 0x0101, [IntPtr]0x0D, [IntPtr]0)
    Start-Sleep -Seconds 4
    $lesen = Aktiv $mdi
    if ($lesen -eq $in) { Write-Host "BILD Nachricht $i liess sich nicht oeffnen"; continue }
    $geoeffnet++
    Write-Host ("BILD geoeffnet {0}: [{1}]" -f $i, (Tx $lesen))
    Befehl $haupt 32799                           # ID_MESSAGE_FORWARD
    Start-Sleep -Seconds 3
    $verfassen = Aktiv $mdi
    if ($verfassen -ne $lesen) {
        $weiter++
        [void][WinBild]::PostMessageA($verfassen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
        Start-Sleep -Milliseconds 1500
        $null = Dialoge $pp '^(No|Nein)$'        # "Save changes?" -> Nein
    }
    [void][WinBild]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
    Start-Sleep -Milliseconds 1200
    $null = Dialoge $pp
}
Write-Host ("BILD ERGEBNIS abgeholt={0} geoeffnet={1} weitergeleitet={2}" -f $n, $geoeffnet, $weiter)
PopBeenden
