# messen-e125.ps1 - Gegenprobe zu Befund E-125: eine VERFASSTE Nachricht
# muss sich weiterhin nach "Out" verschieben lassen.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, bekommt von dort
# -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem Pfad.
#
#   powershell -ExecutionPolicy Bypass -File tools\testlauf.ps1 `
#       -Verzeichnis "C:\Temp\E125" -Freigabe "<Gregors Satz von heute>" `
#       -MessenSkript tools\messen-e125.ps1 -Sekunden 90
#
# WARUM ES DAS GIBT. Gregor hat den Schritt 4 aus Intern/TESTPLAN.md#m3-e125
# am 23.10.2026 abgelehnt: "das stand so nicht in der beschreibung". Eine
# verfasste Nachricht ausserhalb von Out gibt es erst, wenn man sie selbst
# aus Out herausschiebt - der Plan sagte das nicht. Dieses Skript tut genau
# das, ohne Tastendruck, nur mit Botschaften an gemessene Fensterhandles:
#
#   1. neue Nachricht (ID_MESSAGE_NEWMESSAGE), An-Feld fuellen, speichern
#      (ID_FILE_SAVE) und schliessen - sie liegt jetzt in Out
#   2. Out oeffnen, die Nachricht waehlen, ueber das Menue Transfer nach
#      Trash verschieben
#   3. Trash oeffnen, die Nachricht waehlen, ueber Transfer nach Out
#      verschieben - DAS ist die Gegenprobe; derselbe Weg wie das Ziehen
#      (CTocDoc::Xfer, tocdoc.cpp:2753 prueft Sum->IsComp())
#   4. Out und Trash zaehlen
#   5. Umkehrprobe: eine empfangene Nachricht aus In nach Out - muss
#      abgelehnt werden, sonst hat der Lauf die Sperre gar nicht erreicht
#
# Ausgabe: Zeilen "E125 ...". Erwartet (gemessen 23.10.2026 an 7.2.0.122):
#   E125 ERGEBNIS out=1 trash=0 (vorher 1) dialoge-gegenprobe=0 ...
#   E125 UMKEHR in=1 (vorher 1) out=1 (vorher 1) dialoge=1
# und im eudora.log genau eine Zeile "E-125 Xfer nach Out abgelehnt" mit
# quelle=In, keine mit quelle=Trash. "dialoge-gesamt" zaehlt den Hinweis der
# Rechtschreibpruefung beim Speichern mit (E-139) und ist kein Pruefwert.
#
# Vorbereiten (vor dem Start, von pruefstand-lauf.ps1 gerufen):
#   tools\messen-e125.ps1 -Vorbereiten -Pfadfilter C:\Temp\E125
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [string] $An = 'e125@127.0.0.1',
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

# --- -Vorbereiten: die Lage frisch anlegen, VOR dem Start --------------------
# Aufgerufen von tools\pruefstand-lauf.ps1 (Schalter messen=...). Out, Trash
# und In werden geleert, In bekommt eine empfangene Nachricht aus Testdaten/.
# Die Pfadschranke steht vor jeder Wirkung: geloescht wird nur unter C:\Temp
# (Arbeitsweise/tor-gehoert-zum-schritt.md).
if ($Vorbereiten) {
    $voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
    if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E125 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
    $md = Join-Path $voll 'Mailverzeichnis'
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E125 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    foreach ($n in 'Out','Trash','In') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    $eml = Join-Path (Split-Path -Parent $PSScriptRoot) 'Testdaten\e118-html-in-imap-ordner.eml'
    $b = [IO.File]::ReadAllBytes($eml)
    $kopf = [Text.Encoding]::ASCII.GetBytes("From ???@??? Fri Oct 23 10:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopf + $b + $ende))
    Write-Host ("E125 vorbereitet: {0} (In.mbx {1} Byte)" -f $md, ($kopf.Length + $b.Length + $ende.Length))
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E125 {
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

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E125]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E125]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object E125+R; [void][E125]::GetWindowRect($h,[ref]$r); $r.T }

function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E125+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E125]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}

function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E125+EP]{ param($h,$p)
        $o = 0; [void][E125]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E125]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E125]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E125]::EnumWindows($cb,[IntPtr]::Zero)
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
        Write-Host ("E125 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E125]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E125]::PostMessageA($d.H, 0x0111, [IntPtr]1, [IntPtr]::Zero) }       # IDOK
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}

function Befehl($h, [int] $id) { [void][E125]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }

# Das aktive MDI-Kind und seine Postfachliste (CTocListBox ist ein CListBox).
function Aktiv($mdi) { return [E125]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E125]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E125]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E125]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][E125]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][E125]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][E125]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
}

# Befehlsnummer des Eintrags $Ziel im Menue "Transfer". Die Nummern der
# Postfaecher vergibt Eudora zur Laufzeit, deshalb wird gelesen, nicht
# festgeschrieben.
function TransferNach($haupt, [string] $Ziel) {
    $m = [E125]::GetMenu($haupt)
    for ($i = 0; $i -lt [E125]::GetMenuItemCount($m); $i++) {
        $s = New-Object Text.StringBuilder 128
        [void][E125]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
        if (($s.ToString() -replace '&','') -ne 'Transfer') { continue }
        $sub = [E125]::GetSubMenu($m, $i)
        # Die Postfacheintraege fuellt Eudora erst beim Aufklappen (gemessen
        # 23.10.2026: Mailbox und Transfer hatten vorher 0 Eintraege).
        [void][E125]::SendMessageA($haupt, 0x0117, $sub, [IntPtr]$i)   # WM_INITMENUPOPUP
        for ($j = 0; $j -lt [E125]::GetMenuItemCount($sub); $j++) {
            $t = New-Object Text.StringBuilder 128
            [void][E125]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
            if (($t.ToString() -replace '&','') -eq $Ziel) { return [int][E125]::GetMenuItemID($sub, $j) }
        }
    }
    return 0
}

function MenueZeigen($haupt) {
    $m = [E125]::GetMenu($haupt)
    for ($i = 0; $i -lt [E125]::GetMenuItemCount($m); $i++) {
        $s = New-Object Text.StringBuilder 128
        [void][E125]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
        $sub = [E125]::GetSubMenu($m, $i)
        $teile = @()
        if ($sub -ne [IntPtr]::Zero) {
            for ($j = 0; $j -lt [E125]::GetMenuItemCount($sub); $j++) {
                $t = New-Object Text.StringBuilder 128
                [void][E125]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
                $teile += ("{0}={1}" -f ($t.ToString() -replace '&',''), [E125]::GetMenuItemID($sub, $j))
            }
        }
        Write-Host ("E125 MENUE [{0}] {1}" -f ($s.ToString() -replace '&',''), ($teile -join '; '))
    }
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E125 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E125 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E125 Prozess $pp Hauptfenster $haupt MDI $mdi"
$start = Dialoge $pp
if ($start) { Write-Host "E125 beim Start $start Dialog(e) - zaehlen nicht zur Gegenprobe" }

# --- 1. Nachricht verfassen und speichern ---------------------------------
$vorher = (AlleFenster $pp | Where-Object { $_.Vis }).H
Befehl $haupt 32797                               # ID_MESSAGE_NEWMESSAGE
Start-Sleep -Seconds 2
$felder = AlleFenster $pp | Where-Object { $_.Vis -and ($_.Klasse -match 'RICHEDIT|Edit') -and ($vorher -notcontains $_.H) }
if (-not $felder) { Write-Host 'E125 FEHLER: kein Eingabefeld im Verfassen-Fenster'; exit 1 }
$to = $felder | Sort-Object { Oben $_.H } | Select-Object -First 1
foreach ($ch in $An.ToCharArray()) { [void][E125]::PostMessageA($to.H, 0x0102, [IntPtr][int]$ch, [IntPtr]1); Start-Sleep -Milliseconds 60 }
Start-Sleep -Milliseconds 800
$verfassen = Aktiv $mdi
Write-Host ("E125 Verfassen-Fenster {0} [{1}]" -f $verfassen, (Tx $verfassen))
Befehl $haupt 57603                               # ID_FILE_SAVE
$script:dialoge += Dialoge $pp
[void][E125]::PostMessageA($verfassen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
Start-Sleep -Milliseconds 1500
$script:dialoge += Dialoge $pp

# --- 2. Out -> Trash -------------------------------------------------------
Befehl $haupt 32793                               # ID_MAILBOX_OUT
$out = Aktiv $mdi; $lbOut = Liste $out
Write-Host ("E125 Out [{0}] Eintraege {1}" -f (Tx $out), (Anzahl $lbOut))
if ((Anzahl $lbOut) -lt 1) { Write-Host 'E125 FEHLER: Out ist leer - der Entwurf wurde nicht gespeichert'; exit 1 }
$i = (Anzahl $lbOut) - 1
Write-Host ("E125 gewaehlt in Out: {0}" -f (Waehle $lbOut $i))
$idTrash = TransferNach $haupt 'Trash'
Write-Host "E125 Transfer->Trash Befehl $idTrash"
if (-not $idTrash) { MenueZeigen $haupt; Write-Host 'E125 FEHLER: kein Eintrag Trash im Menue Transfer'; exit 1 }
Befehl $haupt $idTrash
$script:dialoge += Dialoge $pp
Write-Host ("E125 nach dem Verschieben: Out {0}" -f (Anzahl $lbOut))

# --- 3. Trash -> Out: die Gegenprobe ----------------------------------------
Befehl $haupt 32794                               # ID_MAILBOX_TRASH
$trash = Aktiv $mdi; $lbTrash = Liste $trash
$nTrash = Anzahl $lbTrash
Write-Host ("E125 Trash [{0}] Eintraege {1}" -f (Tx $trash), $nTrash)
if ($nTrash -lt 1) { Write-Host 'E125 FEHLER: Trash ist leer - Schritt 2 hat nichts verschoben'; exit 1 }
Write-Host ("E125 gewaehlt in Trash: {0}" -f (Waehle $lbTrash ($nTrash - 1)))
$idOut = TransferNach $haupt 'Out'
Write-Host "E125 Transfer->Out Befehl $idOut"
if (-not $idOut) { Write-Host 'E125 FEHLER: kein Eintrag Out im Menue Transfer'; exit 1 }
$gegenprobe = 0
Befehl $haupt $idOut
$gegenprobe = Dialoge $pp
$script:dialoge += $gegenprobe

# --- 4. zaehlen --------------------------------------------------------------
$nTrashDanach = Anzahl $lbTrash
Befehl $haupt 32793
$nOut = Anzahl (Liste (Aktiv $mdi))
Write-Host ("E125 ERGEBNIS out={0} trash={1} (vorher {2}) dialoge-gegenprobe={3} dialoge-gesamt={4}" -f `
            $nOut, $nTrashDanach, $nTrash, $gegenprobe, $script:dialoge)

# --- 5. Umkehrprobe: eine EMPFANGENE Nachricht aus In nach Out --------------
# Ohne sie beweist die Gegenprobe nichts: sie waere auch gruen, wenn der Lauf
# die Sperre gar nicht erreicht. Der Pruefstand legt dazu eine Nachricht aus
# Testdaten/ in In.mbx (ohne In.toc, Eudora baut das Inhaltsverzeichnis neu
# und fuehrt sie als empfangen). Erwartet: genau ein Dialog mit dem Text
# "can't be transferred to the Out mailbox", In behaelt die Nachricht, Out
# bleibt bei $nOut.
Befehl $haupt 32792                               # ID_MAILBOX_IN
$in = Aktiv $mdi; $lbIn = Liste $in
$nIn = Anzahl $lbIn
Write-Host ("E125 In [{0}] Eintraege {1}" -f (Tx $in), $nIn)
if ($nIn -lt 1) { Write-Host 'E125 UMKEHR NICHT GEFAHREN: In ist leer'; exit 1 }
Write-Host ("E125 gewaehlt in In: {0}" -f (Waehle $lbIn ($nIn - 1)))
Befehl $haupt (TransferNach $haupt 'Out')
$umkehr = Dialoge $pp
$nInDanach = Anzahl $lbIn
Befehl $haupt 32793
$nOutDanach = Anzahl (Liste (Aktiv $mdi))
Write-Host ("E125 UMKEHR in={0} (vorher {1}) out={2} (vorher {3}) dialoge={4}" -f `
            $nInDanach, $nIn, $nOutDanach, $nOut, $umkehr)
