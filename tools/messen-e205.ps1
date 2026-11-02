# messen-e205.ps1 - Befund E-205: schreibt "Speichern unter" mit Kopfzeilen
# ein falsches Datum, und verschiebt es dabei die Uhrzeit der Nachricht?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# Pruefstand C:\Temp\E205 (Kopie von C:\Temp\E194K-alt, IncludeHeaders=1).
# Nur Botschaften an gemessene Fensterhandles, kein Tastendruck.
#
# WARUM ES DAS GIBT. Beim Messen von E-194/E-196 stand in der Datei aus dem
# Verfassen-Fenster "Date: Thu, 05 Nov 2026 03:04:32 +6000" - 59 Stunden in
# der Zukunft. PRUEFER-86 K1 hat die Kette am Quelltext belegt:
# CCompMessageDoc::InitializeNew legt m_TimeZoneMinutes in SEKUNDEN an
# (compmsgd.cpp), und ComposeDate(buf, m_Sum) schreibt m_Seconds der
# Zusammenfassung um (sendmail.cpp). Die Vermutung von K1, jedes weitere
# Speichern verschiebe bei einer eingereihten Nachricht den Zeitpunkt, den
# Send Later mit der Uhr vergleicht, ist WIDERLEGT (PRUEFER-86 Nachtrag, am
# alten Bau q1=q2=0h): FormatDate liest die Zone zurueck und gleicht bei
# gueltiger Zone aus; nur +6000 bleibt stehen.
#
# Ablauf:
#   1. In: Nachricht oeffnen, Antwort anlegen (neue, ungesicherte Nachricht)
#      Save As zweimal -> e205-neu1.txt, e205-neu2.txt
#   2. Antwort einreihen (ID_MESSAGE_SENDIMMEDIATELY bei ImmediateSend=0)
#   3. Out: die eingereihte Nachricht oeffnen, Save As zweimal
#      -> e205-q1.txt, e205-q2.txt; Fenster schliessen
#   4. Out-Liste: dieselbe Nachricht markieren, Save As zweimal
#      -> e205-liste1.txt, e205-liste2.txt
# Je Datei wird die Date:-Zeile gegen die Dateizeit gehalten (beide
# Ortszeit), gerundet auf Stunden. Das zweite Speichern zeigt, ob das erste
# die Zusammenfassung verschoben hat.
#
# Ausgabe:
#   E205 DATEI <weg> date=<Date:-Zeile> zone=<+hhmm> soll=<+hhmm> abweichung=<h>h
#   E205 ERGEBNIS neu1=<h>h neu2=<h>h q1=<h>h q2=<h>h liste1=<h>h liste2=<h>h zone=<passt|ist-statt-soll> lebt=<0|1>
#   Erwartet nach der Behebung: alle 0h, zone=passt.
#   Vor der Behebung (7.2.1.131): neu1=59h neu2=119h, zone=+6000-statt-+0100; q2 > q1.
#   "soll" ist die Zone des Rechners zum Zeitpunkt der Datei (Sommer-/Winterzeit,
#   PRUEFER-86 N2) - vorher stand +0100 fest im Fall, rot ab der Sommerzeit.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E205 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$repo = Split-Path -Parent $PSScriptRoot
$lat = [Text.Encoding]::GetEncoding(28591)
$WEGE = @('neu1','neu2','q1','q2','liste1','liste2')
function Ziel([string] $weg) { return (Join-Path $md ("e205-{0}.txt" -f $weg)) }
function PopBeenden { }

if ($Vorbereiten) {
    $ini = Join-Path $md 'Eudora.ini'
    if (-not (Test-Path $ini)) { Write-Host "E205 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^(e194-.*|e205-.*|e177-.*|lmos\.dat.*)$' } | Remove-Item -Force
    foreach ($d in 'spool','Embedded') { $p = Join-Path $md $d; if (Test-Path $p) { Get-ChildItem -LiteralPath $p -File | Remove-Item -Force } }
    $fp = Join-Path $md 'Filters.pce'; if (Test-Path $fp) { Remove-Item -LiteralPath $fp -Force }
    $t = $lat.GetString([IO.File]::ReadAllBytes($ini))
    foreach ($kv in @(@('IncludeHeaders','1'), @('GuessParagraphs','0'), @('ImmediateSend','0'), @('SpellOnQueue','0'), @('CheckForMail','0'))) {
        $k = $kv[0]; $v = $kv[1]
        if ($t -match ('(?m)^' + $k + '=')) { $t = [regex]::Replace($t, ('(?m)^' + $k + '=[^\r\n]*'), ($k + '=' + $v)) }
        else { $t = $t -replace '(?m)^\[Settings\]\r?\n', ("[Settings]`r`n" + $k + '=' + $v + "`r`n") }
    }
    [IO.File]::WriteAllBytes($ini, $lat.GetBytes($t))
    # Die Pruefnachricht roh nach In - hier zaehlt nur, dass es eine Antwort gibt.
    $eml = [IO.File]::ReadAllBytes((Join-Path $repo 'Testdaten\e194-flowed-umlaute.eml'))
    $kopfz = [Text.Encoding]::ASCII.GetBytes("From ???@??? Mon Nov 02 11:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopfz + $eml + $ende))
    Write-Host ("E205 vorbereitet: {0}" -f $md)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E205 {
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
  [DllImport("user32.dll", CharSet=CharSet.Ansi, EntryPoint="SendMessageA")] public static extern IntPtr SendHole(IntPtr h, uint m, IntPtr w, StringBuilder l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E205]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E205]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object E205+R; [void][E205]::GetWindowRect($h,[ref]$r); $r.T }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E205+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E205]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E205+EP]{ param($h,$p)
        $o = 0; [void][E205]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E205]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E205]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E205]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
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
        Write-Host ("E205 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E205]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E205]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E205]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E205]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E205]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E205]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E205]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][E205]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][E205]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][E205]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
}
function InListe() {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt 32792                       # ID_MAILBOX_IN
        $k = Aktiv $mdi; $lb = Liste $k
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    Write-Host 'E205 FEHLER: Postfach In kam nicht nach vorn'; PopBeenden; exit 1
}

# Die Dateityp-Liste des Dialogs: jede ComboBox lesen, die Eintraege der Form
# "... (*.xyz)" traegt. CB_GETLBTEXT wird von Windows ueber Prozessgrenzen
# hinweg uebertragen (Standardsteuerelement, Botschaft unter WM_USER).
function DateitypListe($d) {
    foreach ($c in (Kinder $d | Where-Object { (Kl $_) -eq 'ComboBox' })) {
        $n = [int][E205]::SendMessageA($c, 0x0146, [IntPtr]::Zero, [IntPtr]::Zero)   # CB_GETCOUNT
        $eintraege = @()
        for ($i = 0; $i -lt $n -and $i -lt 30; $i++) {
            $len = [int][E205]::SendMessageA($c, 0x0149, [IntPtr]$i, [IntPtr]::Zero)  # CB_GETLBTEXTLEN
            if ($len -lt 0 -or $len -gt 1000) { continue }
            $sb = New-Object Text.StringBuilder ($len + 2)
            [void][E205]::SendHole($c, 0x0148, [IntPtr]$i, $sb)                      # CB_GETLBTEXT
            $eintraege += $sb.ToString()
        }
        if ($eintraege | Where-Object { $_ -match '\(\*\.' }) { return ,$eintraege }
    }
    return $null
}

$script:filter = 0; $script:rtf = 0
function SpeichernUnter([string] $weg) {
    $ziel = Ziel $weg
    [void][E205]::PostMessageA($haupt, 0x0111, [IntPtr]57604, [IntPtr]::Zero)   # ID_FILE_SAVE_AS
    $d = WarteAufDialog $pp
    if ($d -eq 'tot') { Write-Host "E205 $weg ABGESTUERZT beim Aufbau des Dateidialogs"; PopBeenden; exit 1 }
    if (-not $d) { Write-Host "E205 $weg kein Dateidialog erschienen"; [void](Dialoge $pp); return 0 }
    $typen = DateitypListe $d
    if ($typen) {
        $script:filter++
        if ($typen | Where-Object { $_ -match '(?i)\.rtf\b|\brtf\b' }) { $script:rtf++ }
        Write-Host ("E205 FILTER {0}: {1}" -f $weg, ($typen -join ' | '))
    } else { Write-Host ("E205 FILTER {0}: nicht gefunden" -f $weg) }
    $edits = Kinder $d | Where-Object { (Kl $_) -eq 'Edit' -and [E205]::IsWindowVisible($_) }
    $feld = $edits | Where-Object { (Tx $_) } | Select-Object -First 1
    if (-not $feld) { $feld = $edits | Sort-Object { Oben $_ } | Select-Object -First 1 }
    [void][E205]::SendText($feld, 0x000C, [IntPtr]::Zero, $ziel)       # WM_SETTEXT
    Start-Sleep -Milliseconds 500
    [void][E205]::PostMessageA($d, 0x0111, [IntPtr]1, [IntPtr]::Zero)  # IDOK
    for ($i = 0; $i -lt 40 -and (Lebt $pp) -and -not (Test-Path -LiteralPath $ziel); $i++) { Start-Sleep -Milliseconds 250 }
    Start-Sleep -Milliseconds 800
    if ((Lebt $pp) -and (Dateidialog $pp)) {
        Write-Host "E205 $weg Dateidialog steht noch - wird abgebrochen"
        [void][E205]::PostMessageA((Dateidialog $pp), 0x0111, [IntPtr]2, [IntPtr]::Zero)   # IDCANCEL
        Start-Sleep -Milliseconds 800
    }
    [void](Dialoge $pp)
    return [int](Test-Path -LiteralPath $ziel)
}


$script:abw = @{}; $script:zone = '-'
$monate = @{ Jan=1; Feb=2; Mar=3; Apr=4; May=5; Jun=6; Jul=7; Aug=8; Sep=9; Oct=10; Nov=11; Dec=12 }
function Auswerten([string] $weg) {
    $ziel = Ziel $weg
    if (-not (Test-Path -LiteralPath $ziel)) { Write-Host ("E205 DATEI {0} fehlt" -f $weg); $script:abw[$weg] = 'fehlt'; return }
    $t = $lat.GetString([IO.File]::ReadAllBytes($ziel))
    $m = [regex]::Match($t, '(?m)^Date:\s*\w{3},\s*(\d{1,2})\s+(\w{3})\s+(\d{4})\s+(\d\d):(\d\d):(\d\d)\s+([+-]\d{4})')
    if (-not $m.Success) { Write-Host ("E205 DATEI {0} ohne Date:-Zeile" -f $weg); $script:abw[$weg] = 'ohne-date'; return }
    $d = New-Object DateTime ([int]$m.Groups[3].Value), $monate[$m.Groups[2].Value], ([int]$m.Groups[1].Value), ([int]$m.Groups[4].Value), ([int]$m.Groups[5].Value), ([int]$m.Groups[6].Value)
    $datei = (Get-Item -LiteralPath $ziel).LastWriteTime
    $h = [int][Math]::Round(($d - $datei).TotalHours)
    $script:abw[$weg] = ('{0}h' -f $h)
    $off = [TimeZoneInfo]::Local.GetUtcOffset($datei)
    $soll = '{0}{1:00}{2:00}' -f $(if ($off.Ticks -lt 0) { '-' } else { '+' }), [Math]::Abs($off.Hours), [Math]::Abs($off.Minutes)
    $ist = $m.Groups[7].Value
    if ($ist -ne $soll) { if ($script:zone -eq '-' -or $script:zone -eq 'passt') { $script:zone = ('{0}-statt-{1}' -f $ist, $soll) } }
    elseif ($script:zone -eq '-') { $script:zone = 'passt' }
    Write-Host ("E205 DATEI {0} date=[{1}] zone={2} soll={3} abweichung={4}h datei={5:yyyy-MM-dd HH:mm:ss}" -f $weg, $m.Value.Trim(), $ist, $soll, $h, $datei)
}
function Schliessen($h) {
    [void][E205]::PostMessageA($h, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
    Start-Sleep -Milliseconds 1200
    for ($r = 0; $r -lt 4; $r++) { if ((Dialoge $pp '^(No|Nein|Don.t Save|OK)$') -eq 0) { break }; Start-Sleep -Milliseconds 600 }
}
function OeffneErste($lb) {
    [void](Waehle $lb 0)
    [void][E205]::PostMessageA($lb, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN an die Liste
    [void][E205]::PostMessageA($lb, 0x0101, [IntPtr]0x0D, [IntPtr]0)
    Start-Sleep -Seconds 3
    [void](Dialoge $pp)
    return (Aktiv $mdi)
}
function OutListe() {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt 32793                       # ID_MAILBOX_OUT
        $k = Aktiv $mdi; $lb = Liste $k
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    Write-Host 'E205 FEHLER: Postfach Out kam nicht nach vorn'; return @($null, $null)
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E205 FEHLER: keine Eudora aus $voll"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E205 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E205 Prozess $pp Hauptfenster $haupt MDI $mdi"
[void](Dialoge $pp)

# --- 1. neue Antwort, zweimal speichern ------------------------------------
$in, $lbIn = InListe
if ((Anzahl $lbIn) -lt 1) { Write-Host 'E205 FEHLER: In ist leer' }
$lesen = OeffneErste $lbIn
if ($lesen -eq $in) { Write-Host 'E205 FEHLER: die Nachricht liess sich nicht oeffnen' }
else {
    Befehl $haupt 32855                           # ID_MESSAGE_REPLY
    Start-Sleep -Seconds 2
    [void](Dialoge $pp)
    $verf = Aktiv $mdi
    if ($verf -eq $lesen) { Write-Host 'E205 FEHLER: kein Verfassen-Fenster' }
    else {
        Write-Host ("E205 Verfassen-Fenster {0} [{1}]" -f $verf, (Tx $verf))
        [void](SpeichernUnter 'neu1'); Start-Sleep -Seconds 1
        [void](SpeichernUnter 'neu2')
        # --- 2. einreihen ----------------------------------------------------
        [void][E205]::SendMessageA($mdi, 0x0222, $verf, [IntPtr]::Zero)   # WM_MDIACTIVATE
        Befehl $haupt 32802                       # ID_MESSAGE_SENDIMMEDIATELY (ImmediateSend=0: Queue)
        Start-Sleep -Seconds 2
        [void](Dialoge $pp)
        if ((Aktiv $mdi) -eq $verf) { Write-Host 'E205 Verfassen-Fenster steht noch nach dem Einreihen'; Schliessen $verf }
    }
    Schliessen $lesen
}

# --- 3. eingereihte Nachricht aus Out oeffnen, zweimal speichern -----------
$out, $lbOut = OutListe
Write-Host ("E205 Out: {0} Nachricht(en)" -f $(if ($lbOut) { Anzahl $lbOut } else { 0 }))
if ($lbOut -and (Anzahl $lbOut) -ge 1) {
    $q = OeffneErste $lbOut
    if ($q -eq $out) { Write-Host 'E205 FEHLER: eingereihte Nachricht liess sich nicht oeffnen' }
    else {
        Write-Host ("E205 eingereiht offen {0} [{1}]" -f $q, (Tx $q))
        [void](SpeichernUnter 'q1'); Start-Sleep -Seconds 1
        [void](SpeichernUnter 'q2')
        Schliessen $q
    }
    # --- 4. aus der Out-Liste, zweimal -------------------------------------
    $out, $lbOut = OutListe
    [void](Waehle $lbOut 0)
    [void](SpeichernUnter 'liste1'); Start-Sleep -Seconds 1
    $out, $lbOut = OutListe
    [void](Waehle $lbOut 0)
    [void](SpeichernUnter 'liste2')
}

# --- Auswertung ---------------------------------------------------------------
foreach ($w in $WEGE) { Auswerten $w }
function A([string] $w) { if ($script:abw.ContainsKey($w)) { return $script:abw[$w] } else { return '-' } }
Write-Host ("E205 ERGEBNIS neu1={0} neu2={1} q1={2} q2={3} liste1={4} liste2={5} zone={6} lebt={7}" -f `
    (A 'neu1'), (A 'neu2'), (A 'q1'), (A 'q2'), (A 'liste1'), (A 'liste2'), $script:zone, [int](Lebt $pp))
