# messen-e140.ps1 - Befund E-140: schreiben "Speichern unter" aus dem
# Nachrichten- und aus dem Verfassen-Fenster eine Zeichensatzangabe?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# Pruefstand C:\Temp\E140 (Kopie von C:\Temp\E97). Nur Botschaften an
# gemessene Fensterhandles, kein Tastendruck.
#
# WARUM ES DAS GIBT. E-140 stand seit dem 23.10.2026 als "am Quelltext
# belegt, nie gemessen": E101SpeicherfassungAufbereiten - die Ergaenzung von
# MIME-Version/Content-Type/charset - hat genau einen Aufrufer, File -> Save As
# aus der POSTFACHLISTE (tocview.cpp). Aus dem Nachrichtenfenster
# (ReadMessageDoc.cpp) und aus dem Verfassen-Fenster (compmsgd.cpp) schreibt
# Eudora ohne sie. Niemand hat diese beiden Wege je gefahren.
#
#   1. Postfachliste In: Nachricht waehlen, Save As -> e140-liste.txt
#      (GEGENPROBE: hier muss die Zeichensatzzeile stehen, E-101)
#   2. Nachricht oeffnen, Save As aus dem Nachrichtenfenster -> e140-lesen.txt
#   3. Antwort darauf (Verfassen-Fenster, der zitierte Text traegt dieselben
#      Zeichen), Save As -> e140-verfassen.txt
#   4. jede Datei: Content-Type-Zeile ja/nein, charset, wie das Euro-Zeichen
#      dasteht (0x80 = windows-1252, E2 82 AC = UTF-8, ? = verloren)
#
# Ausgabe je Datei:
#   E140 DATEI <weg> bytes=<n> ct=<0|1> charset=<wert|-> euro=<cp1252|utf8|fragezeichen|fehlt> umlaute=<n>
#   E140 ERGEBNIS liste=<0|1> lesen=<0|1> verfassen=<0|1> lebt=<0|1> zeichensatz=<0..3>
#   zeichensatz = Zahl der Dateien mit Content-Type, charset und Euro als 0x80;
#   vor der Behebung 1 (nur die Liste), danach 3.
# Die Pruefnachricht ist Testdaten\e118-euro-in-imap-ordner.eml (windows-1252,
# "Preis 5 EUR", Anfuehrungszeichen, Gedankenstrich, Umlaute).
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E140 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$WEGE = @('liste', 'lesen', 'verfassen')
function Ziel([string] $weg) { return (Join-Path $md ("e140-{0}.txt" -f $weg)) }

if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E140 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    foreach ($w in $WEGE) { $z = Ziel $w; if (Test-Path -LiteralPath $z) { Remove-Item -LiteralPath $z -Force } }
    $eml = Join-Path (Split-Path -Parent $PSScriptRoot) 'Testdaten\e118-euro-in-imap-ordner.eml'
    $b = [IO.File]::ReadAllBytes($eml)
    $kopf = [Text.Encoding]::ASCII.GetBytes("From ???@??? Fri Oct 30 10:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopf + $b + $ende))
    Write-Host ("E140 vorbereitet: {0}" -f $md)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E140 {
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

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E140]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E140]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object E140+R; [void][E140]::GetWindowRect($h,[ref]$r); $r.T }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E140+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E140]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E140+EP]{ param($h,$p)
        $o = 0; [void][E140]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E140]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E140]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E140]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
# Der Dateidialog am Merkmal: Explorer-Teil der Klasse DUIViewWndClassName.
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
# Andere Dialoge mit Text ausgeben; ohne passenden Knopf ABBRECHEN, nie blind OK.
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
        Write-Host ("E140 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E140]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E140]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E140]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E140]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E140]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E140]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E140]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][E140]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][E140]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][E140]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
}
# Postfach In nach vorn holen und warten, bis seine Liste da ist. Kein
# Namensvergleich: mit Vorschau traegt das Fenster den Namen der Vorschaudatei.
function InListe() {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt 32792                       # ID_MAILBOX_IN
        $k = Aktiv $mdi; $lb = Liste $k
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    Write-Host 'E140 FEHLER: Postfach In kam nicht nach vorn'; exit 1
}

# Save As an das aktive Fenster, Dateinamen setzen, OK. Liefert 1, wenn die
# Datei danach existiert.
function SpeichernUnter([string] $weg) {
    $ziel = Ziel $weg
    [void][E140]::PostMessageA($haupt, 0x0111, [IntPtr]57604, [IntPtr]::Zero)   # ID_FILE_SAVE_AS
    $d = WarteAufDialog $pp
    if ($d -eq 'tot') { Write-Host "E140 $weg ABGESTUERZT beim Aufbau des Dateidialogs"; exit 1 }
    if (-not $d) { Write-Host "E140 $weg kein Dateidialog erschienen"; [void](Dialoge $pp); return 0 }
    $edits = Kinder $d | Where-Object { (Kl $_) -eq 'Edit' -and [E140]::IsWindowVisible($_) }
    $feld = $edits | Where-Object { (Tx $_) } | Select-Object -First 1
    if (-not $feld) { $feld = $edits | Sort-Object { Oben $_ } | Select-Object -First 1 }
    Write-Host ("E140 {0}: Dateidialog [{1}], Vorschlag [{2}]" -f $weg, (Tx $d), (Tx $feld))
    [void][E140]::SendText($feld, 0x000C, [IntPtr]::Zero, $ziel)       # WM_SETTEXT
    Start-Sleep -Milliseconds 500
    [void][E140]::PostMessageA($d, 0x0111, [IntPtr]1, [IntPtr]::Zero)  # IDOK
    for ($i = 0; $i -lt 40 -and (Lebt $pp) -and -not (Test-Path -LiteralPath $ziel); $i++) { Start-Sleep -Milliseconds 250 }
    Start-Sleep -Milliseconds 800
    if ((Lebt $pp) -and (Dateidialog $pp)) {
        Write-Host "E140 $weg Dateidialog steht noch - wird abgebrochen"
        [void][E140]::PostMessageA((Dateidialog $pp), 0x0111, [IntPtr]2, [IntPtr]::Zero)   # IDCANCEL
        Start-Sleep -Milliseconds 800
    }
    [void](Dialoge $pp)
    return [int](Test-Path -LiteralPath $ziel)
}

# Eine gespeicherte Datei auswerten.
function Auswerten([string] $weg) {
    $ziel = Ziel $weg
    if (-not (Test-Path -LiteralPath $ziel)) { Write-Host ("E140 DATEI {0} fehlt" -f $weg); return }
    $b = [IO.File]::ReadAllBytes($ziel)
    $t = [Text.Encoding]::GetEncoding(28591).GetString($b)
    $ct = if ($t -match '(?im)^Content-Type:') { 1 } else { 0 }
    $cs = '-'
    if ($t -match '(?i)charset\s*=\s*"?([A-Za-z0-9._-]+)') { $cs = $Matches[1] }
    $euro = 'fehlt'
    if ($t.Contains([string][char]0x80)) { $euro = 'cp1252' }
    elseif ($t.Contains(([string][char]0xE2) + [char]0x82 + [char]0xAC)) { $euro = 'utf8' }
    elseif ($t -match 'Preis 5 \?') { $euro = 'fragezeichen' }
    elseif ($t -match 'Preis 5 &euro;|Preis 5 &#8364;') { $euro = 'html-entitaet' }
    $uml = ([regex]::Matches($t, '[\xE4\xF6\xFC\xDF\xC4\xD6\xDC]')).Count
    # Gezaehlt fuer das Urteil: Content-Type UND charset UND das Euro-Zeichen als 0x80.
    if ($ct -eq 1 -and $cs -ne '-' -and $euro -eq 'cp1252') { $script:zeichensatz++ }
    Write-Host ("E140 DATEI {0} bytes={1} ct={2} charset={3} euro={4} umlaute={5}" -f $weg, $b.Length, $ct, $cs, $euro, $uml)
    $erste = ($t -split "`r?`n" | Select-Object -First 6) -join ' | '
    Write-Host ("E140 KOPF {0}: {1}" -f $weg, $erste)
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E140 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E140 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E140 Prozess $pp Hauptfenster $haupt MDI $mdi"
[void](Dialoge $pp)

# --- 1. Postfachliste (Gegenprobe) -------------------------------------------
$in, $lbIn = InListe
if ((Anzahl $lbIn) -lt 1) { Write-Host 'E140 FEHLER: In ist leer - die Vorbereitung hat nicht gegriffen'; exit 1 }
[void](Waehle $lbIn 0)
$ok1 = SpeichernUnter 'liste'

# --- 2. Nachrichtenfenster ---------------------------------------------------
$in, $lbIn = InListe
[void](Waehle $lbIn 0)
[void][E140]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN an die Liste
[void][E140]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
Start-Sleep -Seconds 3
$lesen = Aktiv $mdi
if ($lesen -eq $in) { Write-Host 'E140 FEHLER: die Nachricht liess sich nicht oeffnen'; $ok2 = 0 }
else {
    Write-Host ("E140 Nachrichtenfenster {0} [{1}]" -f $lesen, (Tx $lesen))
    $ok2 = SpeichernUnter 'lesen'
}

# --- 3. Verfassen-Fenster (Antwort auf dieselbe Nachricht) -------------------
if ($lesen -ne $in) {
    Befehl $haupt 32855                           # ID_MESSAGE_REPLY
    Start-Sleep -Seconds 2
    [void](Dialoge $pp)
    $verfassen = Aktiv $mdi
    if ($verfassen -eq $lesen) { Write-Host 'E140 FEHLER: Reply hat kein Verfassen-Fenster geoeffnet'; $ok3 = 0 }
    else {
        Write-Host ("E140 Verfassen-Fenster {0} [{1}]" -f $verfassen, (Tx $verfassen))
        $ok3 = SpeichernUnter 'verfassen'
        [void][E140]::PostMessageA($verfassen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
        Start-Sleep -Milliseconds 1200
        for ($r = 0; $r -lt 4; $r++) { if ((Dialoge $pp '^(No|Nein|Don.t Save|OK)$') -eq 0) { break }; Start-Sleep -Milliseconds 600 }
    }
    [void][E140]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
    Start-Sleep -Milliseconds 1000
    [void](Dialoge $pp)
} else { $ok3 = 0 }

# --- 4. Auswertung -------------------------------------------------------------
$script:zeichensatz = 0
foreach ($w in $WEGE) { Auswerten $w }
Write-Host ("E140 ERGEBNIS liste={0} lesen={1} verfassen={2} lebt={3} zeichensatz={4}" -f $ok1, $ok2, $ok3, [int](Lebt $pp), $script:zeichensatz)
