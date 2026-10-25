# messen-e97.ps1 - Regressionstest zu Befund E-97 und E-100: "Speichern
# unter" darf Eudora nicht abstuerzen lassen.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# bekommt -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus
# diesem Pfad. Nur Botschaften an gemessene Fensterhandles, kein Tastendruck
# (Arbeitsweise/keine-tastendruecke-verschicken.md).
#
# WARUM ES DAS GIBT. E-97: Eudora stuerzte ab, sobald eine Nachricht ueber
# File -> Save As gesichert werden sollte - der Windows-Dateidialog rief
# waehrend seines Aufbaus CSaveAsDialog::OnTypeChange, GetParent() lieferte
# NULL, und der Zugriff darauf war nur durch ein ASSERT "abgesichert". E-100:
# dieselbe Luecke an drei weiteren Stellen, darunter GetFileNameFromDialog,
# das beim OK im laufenden Speichervorgang laeuft, und zwei uninitialisierte
# Werte, die nach dem Dialog in die Eudora.ini geschrieben wurden. Beide
# kritisch, beide bis zum 25.10.2026 ohne Regressionstest.
#
#   1. aus dem Postfach In: Nachricht waehlen, Save As, Dateinamen setzen,
#      OK - der Dialog muss erscheinen, Eudora muss leben, die Datei muss
#      geschrieben sein (E-97, und GetFileNameFromDialog aus E-100)
#   2. aus einem Verfassen-Fenster: Save As, Abbrechen - Dialog und Leben
#      (E-100, der zweite Aufrufweg compmsgd.cpp)
#   3. IncludeHeaders und GuessParagraphs in der Eudora.ini: nur 0 oder 1
#      oder gar nicht da (E-100 Teil 2). "Gar nicht da" ist der Normalfall
#      und KEIN leeres Ergebnis: Eudora schreibt nur Werte, die vom
#      Vorgabewert 0 abweichen - ein uninitialisierter Wert stuende genau
#      dann als fremde Zahl in der Datei (gemessen 25.10.2026: beide fehlen).
#
# Ausgabe: Zeilen "E97 ..." und "E100 ...". Erwartet:
#   E97 ERGEBNIS dialog=1 lebt=1 datei=1
#   E100 ERGEBNIS dialog=1 lebt=1 ini=ok
#
# Vorbereiten (vor dem Start, von pruefstand-lauf.ps1 gerufen):
#   tools\messen-e97.ps1 -Vorbereiten -Pfadfilter C:\Temp\E97
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [string] $An = 'e97@127.0.0.1',
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E97 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$ziel = Join-Path $md 'e97-gespeichert.txt'

# --- -Vorbereiten: In mit einer Nachricht, alte Ergebnisdatei weg -----------
# Die Pfadschranke steht vor jeder Wirkung (Arbeitsweise/tor-gehoert-zum-schritt.md).
if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E97 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    foreach ($n in 'Out','In') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    if (Test-Path -LiteralPath $ziel) { Remove-Item -LiteralPath $ziel -Force }
    $eml = Join-Path (Split-Path -Parent $PSScriptRoot) 'Testdaten\e118-html-in-imap-ordner.eml'
    $b = [IO.File]::ReadAllBytes($eml)
    $kopf = [Text.Encoding]::ASCII.GetBytes("From ???@??? Sun Oct 25 10:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopf + $b + $ende))
    Write-Host ("E97 vorbereitet: {0}" -f $md)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E97 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Ansi, EntryPoint="SendMessageA")] public static extern IntPtr SendText(IntPtr h, uint m, IntPtr w, string l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E97]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E97]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object E97+R; [void][E97]::GetWindowRect($h,[ref]$r); $r.T }

function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E97+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E97]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}

function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E97+EP]{ param($h,$p)
        $o = 0; [void][E97]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E97]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E97]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E97]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}

function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }

# Der Dateidialog wird an einem MERKMAL erkannt, nicht an der Klasse #32770
# allein (Arbeitsweise/messziel-am-merkmal-erkennen.md): der Explorer-Teil
# des Vista-Dialogs ist ein Kind der Klasse DUIViewWndClassName.
function Dateidialog($pp) {
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        if (Kinder $d.H | Where-Object { (Kl $_) -eq 'DUIViewWndClassName' }) { return $d.H }
    }
    return $null
}

function WarteAufDialog($pp, [int] $Sekunden = 15) {
    for ($i = 0; $i -lt $Sekunden * 4; $i++) {
        if (-not (Lebt $pp)) { return 'tot' }
        $d = Dateidialog $pp
        if ($d) { return $d }
        Start-Sleep -Milliseconds 250
    }
    return $null
}

# Andere Dialoge (Hinweise beim Start, "Aenderungen speichern?") werden mit
# Text ausgegeben und mit dem Knopf geschlossen, der $Knopf trifft.
function Dialoge($pp, [string] $Knopf = '^(OK)$') {
    $n = 0
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        if (Kinder $d.H | Where-Object { (Kl $_) -eq 'DUIViewWndClassName' }) { continue }
        $texte = @(); $knoepfe = @()
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button')         { $knoepfe += [pscustomobject]@{H=$c; T=$t} }
        }
        Write-Host ("E97 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E97]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        # Kein passender Knopf: ABBRECHEN, nie blind OK - bei "Send Queued
        # Messages" hiesse OK "Send them, then quit" (mainfrm.cpp:5396-5398),
        # also echte Post verschicken (PRUEFER-54 K2).
        else    { [void][E97]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}

function Befehl($h, [int] $id) { [void][E97]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E97]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E97]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E97]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E97]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][E97]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][E97]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][E97]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E97 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E97 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E97 Prozess $pp Hauptfenster $haupt MDI $mdi"
$start = Dialoge $pp
if ($start) { Write-Host "E97 beim Start $start Dialog(e)" }

# --- 1. Aus dem Postfach In speichern (E-97, E-100 GetFileNameFromDialog) ---
Befehl $haupt 32792                               # ID_MAILBOX_IN
$in = Aktiv $mdi; $lbIn = Liste $in
$nIn = Anzahl $lbIn
Write-Host ("E97 In [{0}] Eintraege {1}" -f (Tx $in), $nIn)
if ($nIn -lt 1) { Write-Host 'E97 FEHLER: In ist leer - die Vorbereitung hat nicht gegriffen'; exit 1 }
Write-Host ("E97 gewaehlt in In: {0}" -f (Waehle $lbIn 0))
[void][E97]::PostMessageA($haupt, 0x0111, [IntPtr]57604, [IntPtr]::Zero)   # ID_FILE_SAVE_AS
$d = WarteAufDialog $pp
$dialog = 0; $datei = 0
if ($d -eq 'tot') {
    Write-Host 'E97 ABGESTUERZT beim Aufbau des Dateidialogs'
} elseif (-not $d) {
    Write-Host 'E97 kein Dateidialog erschienen'
} else {
    $dialog = 1
    # Das Feld fuer den Dateinamen: das Edit-Kind, das den Vorschlag traegt -
    # sonst das oberste sichtbare Edit des Dialogs.
    $edits = Kinder $d | Where-Object { (Kl $_) -eq 'Edit' -and [E97]::IsWindowVisible($_) }
    $feld = $edits | Where-Object { (Tx $_) } | Select-Object -First 1
    if (-not $feld) { $feld = $edits | Sort-Object { Oben $_ } | Select-Object -First 1 }
    Write-Host ("E97 Dateidialog {0} [{1}], Namensfeld {2} [{3}]" -f $d, (Tx $d), $feld, (Tx $feld))
    [void][E97]::SendText($feld, 0x000C, [IntPtr]::Zero, $ziel)       # WM_SETTEXT
    Start-Sleep -Milliseconds 500
    [void][E97]::PostMessageA($d, 0x0111, [IntPtr]1, [IntPtr]::Zero)  # IDOK
    for ($i = 0; $i -lt 40 -and (Lebt $pp) -and -not (Test-Path -LiteralPath $ziel); $i++) { Start-Sleep -Milliseconds 250 }
    Start-Sleep -Milliseconds 800
    if (Test-Path -LiteralPath $ziel) { $datei = 1; Write-Host ("E97 Datei {0} ({1} Byte)" -f $ziel, (Get-Item -LiteralPath $ziel).Length) }
    if ((Lebt $pp) -and (Dateidialog $pp)) {
        Write-Host 'E97 Dateidialog steht noch - wird abgebrochen'
        [void][E97]::PostMessageA((Dateidialog $pp), 0x0111, [IntPtr]2, [IntPtr]::Zero)   # IDCANCEL
        Start-Sleep -Milliseconds 800
    }
}
$lebt = [int](Lebt $pp)
Write-Host ("E97 ERGEBNIS dialog={0} lebt={1} datei={2}" -f $dialog, $lebt, $datei)
if (-not $lebt) { Write-Host 'E100 ERGEBNIS nicht gefahren - Eudora lebt nicht mehr'; exit 1 }
[void](Dialoge $pp)

# --- 2. Aus einem Verfassen-Fenster (E-100, compmsgd.cpp) -------------------
$vorher = (AlleFenster $pp | Where-Object { $_.Vis }).H
Befehl $haupt 32797                               # ID_MESSAGE_NEWMESSAGE
Start-Sleep -Seconds 2
$felder = AlleFenster $pp | Where-Object { $_.Vis -and ($_.Klasse -match 'RICHEDIT|Edit') -and ($vorher -notcontains $_.H) }
if ($felder) {
    $to = $felder | Sort-Object { Oben $_.H } | Select-Object -First 1
    foreach ($ch in $An.ToCharArray()) { [void][E97]::PostMessageA($to.H, 0x0102, [IntPtr][int]$ch, [IntPtr]1); Start-Sleep -Milliseconds 60 }
}
$verfassen = Aktiv $mdi
Write-Host ("E100 Verfassen-Fenster {0} [{1}]" -f $verfassen, (Tx $verfassen))
[void][E97]::PostMessageA($haupt, 0x0111, [IntPtr]57604, [IntPtr]::Zero)   # ID_FILE_SAVE_AS
$d = WarteAufDialog $pp
$dialog2 = 0
if ($d -eq 'tot') { Write-Host 'E100 ABGESTUERZT beim Aufbau des Dateidialogs' }
elseif (-not $d)  { Write-Host 'E100 kein Dateidialog erschienen' }
else {
    $dialog2 = 1
    [void][E97]::PostMessageA($d, 0x0111, [IntPtr]2, [IntPtr]::Zero)   # IDCANCEL
    Start-Sleep -Milliseconds 1000
}
$lebt2 = [int](Lebt $pp)
if ($lebt2) {
    [void][E97]::PostMessageA($verfassen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
    Start-Sleep -Milliseconds 1200
    # "Save changes?" mit Nein, danach kann der Hinweis zur Rechtschreib-
    # pruefung folgen (E-139). Bleibt einer stehen, laesst sich Eudora am
    # Ende nicht mehr per WM_CLOSE beenden und wird abgeschossen - gemessen
    # 25.10.2026, das Protokoll war dann beim Auslesen noch gesperrt.
    for ($r = 0; $r -lt 4; $r++) {
        if ((Dialoge $pp '^(No|Nein|Don.t Save|OK)$') -eq 0) { break }
        Start-Sleep -Milliseconds 600
    }
}

# --- 3. Die beiden INI-Werte aus E-100 Teil 2 --------------------------------
# ERST NACH DEM BEENDEN lesen (PRUEFER-53 K4): SetIniShort setzt nur den
# Zwischenspeicher (rs.cpp:643-646), auf die Platte kommt es mit
# FlushINIFile beim Beenden. Bis zum 25.10.2026 las dieses Skript die Datei,
# waehrend Eudora noch lief, und meldete "ini=ok" ueber Werte, die noch gar
# nicht geschrieben waren. Jetzt beendet das Skript Eudora selbst
# (testlauf.ps1:343 ueberspringt dann sein eigenes Beenden) und liest danach.
# Endet Eudora nicht, heisst das Ergebnis "ungemessen", nie "ok".
# PRUEFER-54 K1: ein ABSTURZ beim Beenden ist kein Schreiben - der Prozess
# ist dann auch weg. Gezaehlt wird deshalb nur, wenn die Eudora.ini nach dem
# Schliessbefehl NEU geschrieben wurde (Zeitstempel spaeter als vorher).
$iniOk = 'ungemessen'
$ini = Join-Path $md 'Eudora.ini'
$vorher = (Get-Item -LiteralPath $ini).LastWriteTimeUtc
if ($lebt2) {
    Start-Sleep -Milliseconds 1100      # Zeitstempelaufloesung: "neu" muss unterscheidbar sein
    [void][E97]::PostMessageA($haupt, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
    for ($i = 0; $i -lt 60 -and (Lebt $pp); $i++) {
        if ($i % 4 -eq 3) { [void](Dialoge $pp '^(No|Nein|Don.t Save|Just quit|OK)$') }
        Start-Sleep -Milliseconds 500
    }
}
$neu = (Get-Item -LiteralPath $ini).LastWriteTimeUtc -gt $vorher
if ((Lebt $pp) -or -not $neu) {
    Write-Host ("E100 Eudora endet nicht oder schrieb die Eudora.ini nicht neu (lebt={0} neu={1}) - INI-Teil NICHT gemessen" -f [int](Lebt $pp), [int]$neu)
} else {
    $iniOk = 'ok'
    foreach ($z in (Get-Content -LiteralPath $ini)) {
        if ($z -match '^(IncludeHeaders|GuessParagraphs)=(.*)$' -and $Matches[2] -notmatch '^[01]$') {
            $iniOk = "falsch($($Matches[1])=$($Matches[2]))"
        }
    }
    Write-Host 'E100 Eudora beendet, Eudora.ini nach dem Schreiben gelesen'
}
Write-Host ("E100 ERGEBNIS dialog={0} lebt={1} ini={2}" -f $dialog2, $lebt2, $iniOk)
