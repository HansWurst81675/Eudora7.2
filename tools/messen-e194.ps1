# messen-e194.ps1 - Befunde E-194, E-195, E-196: was schreibt "Speichern
# unter" bei einer Mail im Format format=flowed, und was bietet der Dialog an?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# Pruefstaende C:\Temp\E194 (IncludeHeaders=0) und C:\Temp\E194K
# (IncludeHeaders=1; ein K am Ende des Namens, auch vor "-alt", schaltet es - die
# beiden Kaestchen des Speicherdialogs gibt es unter Windows 10 nicht, E-98,
# es gilt der Wert aus der Eudora.ini). Beide sind Kopien von C:\Temp\E177
# (POP-Konto auf den Pruefserver 127.0.0.1:11110). Nur Botschaften an
# gemessene Fensterhandles, kein Tastendruck.
#
# WARUM ES DAS GIBT. Gregor hat am 01.11.2026 an 7.2.1.130 drei Dinge
# gefunden, die der Pruefstand nie gesehen hatte:
#   E-194  Speichern unter aus der POSTFACHLISTE schreibt Eudoras interne
#          Klammern <x-flowed> und </x-flowed> in die Textdatei
#          (E101SpeicherfassungAufbereiten, msgutils.cpp, nahm nur <x-html> ab).
#   E-195  der Dialog bietet "Rtf Files (*.rtf)" an und liefert Klartext.
#   E-196  als .htm gespeichert steht keine Zeichensatzangabe in der Datei.
# Die Nachricht muss ueber POP kommen: die Klammern setzt erst der
# Empfangsweg (TextReader.cpp), roh in In.mbx gelegt gibt es sie nicht.
#
#   -Vorbereiten: Postfaecher leeren, Konto auf den POP-Pruefserver,
#     IncludeHeaders setzen, POP-Pruefserver mit
#     Testdaten\e194-flowed-umlaute.eml (utf-8, format=flowed) starten.
#   Messen: Post holen; In.mbx lesen (Positivprobe: <x-flowed> muss dort
#     stehen, sonst misst der Lauf nichts); dann Speichern unter
#       1. Postfachliste            -> e194-liste.txt
#       2. Nachrichtenfenster        -> e194-lesen.txt  (Gegenprobe E-194)
#       3. Nachrichtenfenster        -> e194-lesen.htm  (E-196)
#       4. Verfassen-Fenster (Reply) -> e194-verfassen.htm (E-196)
#     und bei jedem Dialog die Liste "Dateityp" lesen (CB_GETLBTEXT an die
#     ComboBox des Dialogs, E-195).
#
# Ausgabe:
#   E194 MBX xflowed=<n>
#   E194 FILTER <weg>: <eintrag> | <eintrag> | ...
#   E194 DATEI <weg> bytes=<n> xflowed=<n> ct=<0|1> flowed=<0|1> charset=<w|-> meta=<w|-> euro=<..> umlaute=<n> umbruch=<weich|zusammen|fehlt>
#   E194 ERGEBNIS kopf=<0|1> mbx=<0|1> dateien=<0..4> filter=<0..4> liste-xflowed=<n> liste-flowed=<0|1> lesen-xflowed=<n> htm-meta=<0..2> rtf=<n> lebt=<0|1>
#   mbx            1 = die Pruefnachricht liegt mit <x-flowed> im Postfach
#   liste-xflowed  Zahl der Klammern in e194-liste.txt (vor der Behebung 2)
#   liste-flowed   1 = Content-Type der Datei traegt format=flowed
#   htm-meta       Zahl der .htm-Dateien mit <meta ... charset=windows-1252>
#   rtf            Zahl der Dialoge, deren Dateityp-Liste .rtf anbietet
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E194 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$repo = Split-Path -Parent $PSScriptRoot
$lat = [Text.Encoding]::GetEncoding(28591)
$pidDatei = Join-Path $voll 'pop-pruefserver.pid'
$kopf = [int]($voll -match 'K(-alt)?$')
$WEGE = [ordered]@{ 'liste' = 'e194-liste.txt'; 'lesen' = 'e194-lesen.txt'; 'lesenhtm' = 'e194-lesen.htm'; 'verfassen' = 'e194-verfassen.htm' }
function Ziel([string] $weg) { return (Join-Path $md $WEGE[$weg]) }

function PopBeenden {
    if (-not (Test-Path -LiteralPath $pidDatei)) { return }
    $alt = [int](Get-Content -LiteralPath $pidDatei)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "E194 POP-Pruefserver $alt beendet" }
    Remove-Item -LiteralPath $pidDatei -Force
}

if ($Vorbereiten) {
    $ini = Join-Path $md 'Eudora.ini'
    if (-not (Test-Path $ini)) { Write-Host "E194 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    PopBeenden
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^(e194-.*|e177-.*|lmos\.dat.*)$' } | Remove-Item -Force
    foreach ($d in 'spool','Embedded') { $p = Join-Path $md $d; if (Test-Path $p) { Get-ChildItem -LiteralPath $p -File | Remove-Item -Force } }
    # Filters.pce aus dem kopierten E-177-Stand wuerde jede Nachricht an ein
    # Programm geben - hier nicht gewollt.
    $fp = Join-Path $md 'Filters.pce'; if (Test-Path $fp) { Remove-Item -LiteralPath $fp -Force }

    # Konto auf den POP-Pruefserver, Kopfzeilen nach Verzeichnisname.
    $t = $lat.GetString([IO.File]::ReadAllBytes($ini))
    foreach ($kv in @(@('POPPort','11110'), @('SSLReceiveUse','0'), @('SavePassword','1'), @('SavePasswordText','eA=='),
                      @('IncludeHeaders', [string]$kopf), @('GuessParagraphs','0'))) {
        $k = $kv[0]; $v = $kv[1]
        if ($t -match ('(?m)^' + $k + '=')) { $t = [regex]::Replace($t, ('(?m)^' + $k + '=[^\r\n]*'), ($k + '=' + $v)) }
        else { $t = $t -replace '(?m)^\[Settings\]\r?\n', ("[Settings]`r`n" + $k + '=' + $v + "`r`n") }
    }
    [IO.File]::WriteAllBytes($ini, $lat.GetBytes($t))

    $belegt = Get-NetTCPConnection -LocalPort 11110 -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Host "E194 FEHLER: Port 11110 ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $post = Join-Path $voll 'post'
    if (Test-Path $post) { Get-ChildItem -LiteralPath $post -File | Remove-Item -Force } else { New-Item -ItemType Directory $post | Out-Null }
    $popEml = Join-Path $post 'e194-pop.eml'
    Copy-Item -LiteralPath (Join-Path $repo 'Testdaten\e194-flowed-umlaute.eml') -Destination $popEml -Force
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $p = Start-Process $perl -ArgumentList @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml', '--eml', $popEml) `
                       -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("E194 vorbereitet: {0}; IncludeHeaders={1}; POP-Pruefserver PID {2}" -f $md, $kopf, $p.Id)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E194 {
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

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E194]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E194]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object E194+R; [void][E194]::GetWindowRect($h,[ref]$r); $r.T }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E194+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E194]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E194+EP]{ param($h,$p)
        $o = 0; [void][E194]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E194]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E194]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E194]::EnumWindows($cb,[IntPtr]::Zero)
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
        Write-Host ("E194 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E194]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E194]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E194]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E194]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E194]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E194]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E194]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][E194]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][E194]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][E194]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
}
function InListe() {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt 32792                       # ID_MAILBOX_IN
        $k = Aktiv $mdi; $lb = Liste $k
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    Write-Host 'E194 FEHLER: Postfach In kam nicht nach vorn'; PopBeenden; exit 1
}

# Die Dateityp-Liste des Dialogs: jede ComboBox lesen, die Eintraege der Form
# "... (*.xyz)" traegt. CB_GETLBTEXT wird von Windows ueber Prozessgrenzen
# hinweg uebertragen (Standardsteuerelement, Botschaft unter WM_USER).
function DateitypListe($d) {
    foreach ($c in (Kinder $d | Where-Object { (Kl $_) -eq 'ComboBox' })) {
        $n = [int][E194]::SendMessageA($c, 0x0146, [IntPtr]::Zero, [IntPtr]::Zero)   # CB_GETCOUNT
        $eintraege = @()
        for ($i = 0; $i -lt $n -and $i -lt 30; $i++) {
            $len = [int][E194]::SendMessageA($c, 0x0149, [IntPtr]$i, [IntPtr]::Zero)  # CB_GETLBTEXTLEN
            if ($len -lt 0 -or $len -gt 1000) { continue }
            $sb = New-Object Text.StringBuilder ($len + 2)
            [void][E194]::SendHole($c, 0x0148, [IntPtr]$i, $sb)                      # CB_GETLBTEXT
            $eintraege += $sb.ToString()
        }
        if ($eintraege | Where-Object { $_ -match '\(\*\.' }) { return ,$eintraege }
    }
    return $null
}

$script:filter = 0; $script:rtf = 0
function SpeichernUnter([string] $weg) {
    $ziel = Ziel $weg
    [void][E194]::PostMessageA($haupt, 0x0111, [IntPtr]57604, [IntPtr]::Zero)   # ID_FILE_SAVE_AS
    $d = WarteAufDialog $pp
    if ($d -eq 'tot') { Write-Host "E194 $weg ABGESTUERZT beim Aufbau des Dateidialogs"; PopBeenden; exit 1 }
    if (-not $d) { Write-Host "E194 $weg kein Dateidialog erschienen"; [void](Dialoge $pp); return 0 }
    $typen = DateitypListe $d
    if ($typen) {
        $script:filter++
        if ($typen | Where-Object { $_ -match '(?i)\.rtf\b|\brtf\b' }) { $script:rtf++ }
        Write-Host ("E194 FILTER {0}: {1}" -f $weg, ($typen -join ' | '))
    } else { Write-Host ("E194 FILTER {0}: nicht gefunden" -f $weg) }
    $edits = Kinder $d | Where-Object { (Kl $_) -eq 'Edit' -and [E194]::IsWindowVisible($_) }
    $feld = $edits | Where-Object { (Tx $_) } | Select-Object -First 1
    if (-not $feld) { $feld = $edits | Sort-Object { Oben $_ } | Select-Object -First 1 }
    [void][E194]::SendText($feld, 0x000C, [IntPtr]::Zero, $ziel)       # WM_SETTEXT
    Start-Sleep -Milliseconds 500
    [void][E194]::PostMessageA($d, 0x0111, [IntPtr]1, [IntPtr]::Zero)  # IDOK
    for ($i = 0; $i -lt 40 -and (Lebt $pp) -and -not (Test-Path -LiteralPath $ziel); $i++) { Start-Sleep -Milliseconds 250 }
    Start-Sleep -Milliseconds 800
    if ((Lebt $pp) -and (Dateidialog $pp)) {
        Write-Host "E194 $weg Dateidialog steht noch - wird abgebrochen"
        [void][E194]::PostMessageA((Dateidialog $pp), 0x0111, [IntPtr]2, [IntPtr]::Zero)   # IDCANCEL
        Start-Sleep -Milliseconds 800
    }
    [void](Dialoge $pp)
    return [int](Test-Path -LiteralPath $ziel)
}

$script:dateien = 0; $script:htmMeta = 0
$script:werte = @{}
function Auswerten([string] $weg) {
    $ziel = Ziel $weg
    if (-not (Test-Path -LiteralPath $ziel)) { Write-Host ("E194 DATEI {0} fehlt" -f $weg); return }
    $script:dateien++
    $b = [IO.File]::ReadAllBytes($ziel)
    $t = $lat.GetString($b)
    $xf = ([regex]::Matches($t, '(?i)</?x-flowed>')).Count
    $ctm = [regex]::Match($t, '(?im)^Content-Type:[^\r\n]*(\r?\n[ \t][^\r\n]*)*')
    $ct = [int]$ctm.Success
    $flowed = [int]($ctm.Success -and $ctm.Value -match '(?i)format\s*=\s*"?flowed')
    $cs = '-'
    if ($ctm.Success -and $ctm.Value -match '(?i)charset\s*=\s*"?([A-Za-z0-9._-]+)') { $cs = $Matches[1] }
    $meta = '-'
    $mm = [regex]::Matches($t, '(?i)<meta[^>]*charset\s*=\s*"?([A-Za-z0-9._-]+)')
    if ($mm.Count -gt 0) { $meta = (($mm | ForEach-Object { $_.Groups[1].Value }) -join ',') }
    if ($weg -like '*htm' -or $weg -eq 'verfassen') {
        if ($mm.Count -eq 1 -and $mm[0].Groups[1].Value -ieq 'windows-1252') { $script:htmMeta++ }
    }
    $euro = 'fehlt'
    if ($t.Contains([string][char]0x80)) { $euro = 'cp1252' }
    elseif ($t.Contains(([string][char]0xE2) + [char]0x82 + [char]0xAC)) { $euro = 'utf8' }
    elseif ($t -match 'Preis 5 &euro;|Preis 5 &#8364;') { $euro = 'html-entitaet' }
    elseif ($t -match 'Preis 5 \?') { $euro = 'fragezeichen' }
    $uml = ([regex]::Matches($t, '[\xE4\xF6\xFC\xDF\xC4\xD6\xDC]')).Count
    $umbruch = 'fehlt'
    if ($t -match 'so lang, \r?\n') { $umbruch = 'weich' }
    elseif ($t -match 'so lang,\s*(<[^>]*>\s*)*dass') { $umbruch = 'zusammen' }
    $script:werte[$weg] = @{ xf = $xf; flowed = $flowed }
    Write-Host ("E194 DATEI {0} bytes={1} xflowed={2} ct={3} flowed={4} charset={5} meta={6} euro={7} umlaute={8} umbruch={9}" -f $weg, $b.Length, $xf, $ct, $flowed, $cs, $meta, $euro, $uml, $umbruch)
    $erste = ($t -split "`r?`n" | Select-Object -First 4) -join ' | '
    Write-Host ("E194 ANFANG {0}: {1}" -f $weg, $erste)
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E194 FEHLER: keine Eudora aus $voll"; PopBeenden; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E194 FEHLER: kein Hauptfenster'; PopBeenden; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E194 Prozess $pp Hauptfenster $haupt MDI $mdi kopf=$kopf"
[void](Dialoge $pp)

# --- Post holen -------------------------------------------------------------
$in, $lbIn = InListe
$vorher = Anzahl $lbIn
[void][E194]::PostMessageA($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)   # ID_FILE_CHECKMAIL
for ($i = 0; $i -lt 40 -and (Anzahl $lbIn) -le $vorher; $i++) { Start-Sleep -Milliseconds 500; if (($i % 6) -eq 5) { [void](Dialoge $pp) } }
Start-Sleep -Seconds 2
[void](Dialoge $pp)
PopBeenden
$in, $lbIn = InListe
Write-Host ("E194 In: vorher={0} nachher={1}" -f $vorher, (Anzahl $lbIn))
$mbxPfad = Join-Path $md 'In.mbx'
$mbxXf = 0
if (Test-Path -LiteralPath $mbxPfad) { $mbxXf = ([regex]::Matches($lat.GetString([IO.File]::ReadAllBytes($mbxPfad)), '(?i)<x-flowed>')).Count }
Write-Host "E194 MBX xflowed=$mbxXf"
if ((Anzahl $lbIn) -lt 1) { Write-Host 'E194 FEHLER: In ist leer - der POP-Abruf hat nicht gegriffen' }

$ok = @{}
if ((Anzahl $lbIn) -ge 1) {
    # --- 1. Postfachliste ------------------------------------------------------
    [void](Waehle $lbIn 0)
    $ok['liste'] = SpeichernUnter 'liste'

    # --- 2./3. Nachrichtenfenster ---------------------------------------------
    $in, $lbIn = InListe
    [void](Waehle $lbIn 0)
    [void][E194]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN an die Liste
    [void][E194]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
    Start-Sleep -Seconds 3
    $lesen = Aktiv $mdi
    if ($lesen -eq $in) { Write-Host 'E194 FEHLER: die Nachricht liess sich nicht oeffnen' }
    else {
        Write-Host ("E194 Nachrichtenfenster {0} [{1}]" -f $lesen, (Tx $lesen))
        $ok['lesen'] = SpeichernUnter 'lesen'
        $ok['lesenhtm'] = SpeichernUnter 'lesenhtm'

        # --- 4. Verfassen-Fenster ---------------------------------------------
        Befehl $haupt 32855                           # ID_MESSAGE_REPLY
        Start-Sleep -Seconds 2
        [void](Dialoge $pp)
        $verfassen = Aktiv $mdi
        if ($verfassen -eq $lesen) { Write-Host 'E194 FEHLER: Reply hat kein Verfassen-Fenster geoeffnet' }
        else {
            Write-Host ("E194 Verfassen-Fenster {0} [{1}]" -f $verfassen, (Tx $verfassen))
            $ok['verfassen'] = SpeichernUnter 'verfassen'
            [void][E194]::PostMessageA($verfassen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
            Start-Sleep -Milliseconds 1200
            for ($r = 0; $r -lt 4; $r++) { if ((Dialoge $pp '^(No|Nein|Don.t Save|OK)$') -eq 0) { break }; Start-Sleep -Milliseconds 600 }
        }
        [void][E194]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
        Start-Sleep -Milliseconds 1000
        [void](Dialoge $pp)
    }
}

# --- Auswertung -------------------------------------------------------------
foreach ($w in $WEGE.Keys) { Auswerten $w }
function Wert([string] $weg, [string] $k) { if ($script:werte.ContainsKey($weg)) { return $script:werte[$weg][$k] } else { return '-' } }
Write-Host ("E194 ERGEBNIS kopf={0} mbx={1} dateien={2} filter={3} liste-xflowed={4} liste-flowed={5} lesen-xflowed={6} htm-meta={7} rtf={8} lebt={9}" -f `
    $kopf, [int]($mbxXf -ge 1), $script:dateien, $script:filter, (Wert 'liste' 'xf'), (Wert 'liste' 'flowed'),
    (Wert 'lesen' 'xf'), $script:htmMeta, $script:rtf, [int](Lebt $pp))
