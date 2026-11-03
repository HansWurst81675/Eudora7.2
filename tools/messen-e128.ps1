# messen-e128.ps1 - Befund E-128: welche Endung schlaegt "Speichern unter"
# vor, und welche Endung bekommt die Datei, wenn man nur den Namen tippt?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1).
# Pruefstaende (Kopien von C:\Temp\E194, POP-Konto auf den Pruefserver
# 127.0.0.1:11110):
#   C:\Temp\E128    HTML-Mail (Testdaten\e118-html-in-imap-ordner.eml), ohne Kopfzeilen
#   C:\Temp\E128K   HTML-Mail, mit Kopfzeilen (K am Ende, auch vor "-alt")
#   C:\Temp\E128T   reiner ASCII-Text (Testdaten\e128-text-ascii.eml), ohne Kopfzeilen
# Die Kaestchen des Speicherdialogs gibt es unter Windows 10 nicht (E-98), es
# gilt IncludeHeaders aus der Eudora.ini. Nur Botschaften an gemessene
# Fensterhandles, kein Tastendruck.
#
# WARUM ES DAS GIBT. Bis 7.2.1.131 bot der Dialog auf allen Wegen "txt" an,
# gleich was danach in der Datei stand (Gregor 20.10.2026: "allerdings fehlt
# der hinweis fuer den benutzer, dass es keine TXT datei ist!"). Die Behebung
# (Gregor 03.11.2026: "ja") leitet die Vorgabe aus dem Inhalt ab. Gemessen
# wird nicht die Logzeile, sondern was der Anwender bekommt:
#   1. der Zustand des Dialogs: gewaehlter Dateityp (CB_GETCURSEL und Text
#      des Eintrags) und der vorgeschlagene Name;
#   2. die Datei: der Name wird OHNE Endung eingesetzt ("e128-<weg>"), dann
#      OK - welche Endung haengt der Dialog an?
# Wege: Postfachliste, Nachrichtenfenster, Antwort (Verfassen-Fenster).
#
# Ausgabe:
#   E128 WEG <weg> typ-index=<n> typ=<eintrag> name=<text> datei=<endung|fehlt>
#   E128 SPUR <zeile aus eudora.log>
#   E128 ERGEBNIS kopf=<0|1> mail=<html|text> mbx=<0|1> liste=<endung> lesen=<endung> verfassen=<endung> spur=<n> rtf=<n> lebt=<0|1>
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E128 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$repo = Split-Path -Parent $PSScriptRoot
$lat = [Text.Encoding]::GetEncoding(28591)
$pidDatei = Join-Path $voll 'pop-pruefserver.pid'
# Kennbuchstabe am Ende des Namens, "-alt" vorher abgeschnitten, und mit
# -cmatch: -match vergleicht ohne Gross/Klein, und das t von "-alt" galt am
# 03.11.2026 als T - beide HTML-Gegenproben bekamen die Textmail.
$basis = (Split-Path $voll -Leaf) -creplace '-alt$', ''
$kopf = [int]($basis -cmatch 'K$')
$text = [bool]($basis -cmatch 'T$')
$mail = $(if ($text) { 'text' } else { 'html' })
$eml = $(if ($text) { 'Testdaten\e128-text-ascii.eml' } else { 'Testdaten\e118-html-in-imap-ordner.eml' })

function PopBeenden {
    if (-not (Test-Path -LiteralPath $pidDatei)) { return }
    $alt = [int](Get-Content -LiteralPath $pidDatei)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "E128 POP-Pruefserver $alt beendet" }
    Remove-Item -LiteralPath $pidDatei -Force
}

if ($Vorbereiten) {
    $ini = Join-Path $md 'Eudora.ini'
    if (-not (Test-Path $ini)) { Write-Host "E128 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    PopBeenden
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^(e128-.*|e194-.*|e177-.*|lmos\.dat.*)$' } | Remove-Item -Force
    foreach ($d in 'spool','Embedded') { $p = Join-Path $md $d; if (Test-Path $p) { Get-ChildItem -LiteralPath $p -File | Remove-Item -Force } }
    $fp = Join-Path $md 'Filters.pce'; if (Test-Path $fp) { Remove-Item -LiteralPath $fp -Force }

    $t = $lat.GetString([IO.File]::ReadAllBytes($ini))
    foreach ($kv in @(@('POPPort','11110'), @('SSLReceiveUse','0'), @('SavePassword','1'), @('SavePasswordText','eA=='),
                      @('IncludeHeaders', [string]$kopf), @('GuessParagraphs','0'))) {
        $k = $kv[0]; $v = $kv[1]
        if ($t -match ('(?m)^' + $k + '=')) { $t = [regex]::Replace($t, ('(?m)^' + $k + '=[^\r\n]*'), ($k + '=' + $v)) }
        else { $t = $t -replace '(?m)^\[Settings\]\r?\n', ("[Settings]`r`n" + $k + '=' + $v + "`r`n") }
    }
    [IO.File]::WriteAllBytes($ini, $lat.GetBytes($t))

    $belegt = Get-NetTCPConnection -LocalPort 11110 -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Host "E128 FEHLER: Port 11110 ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $post = Join-Path $voll 'post'
    if (Test-Path $post) { Get-ChildItem -LiteralPath $post -File | Remove-Item -Force } else { New-Item -ItemType Directory $post | Out-Null }
    $popEml = Join-Path $post 'e128-pop.eml'
    Copy-Item -LiteralPath (Join-Path $repo $eml) -Destination $popEml -Force
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $p = Start-Process $perl -ArgumentList @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml', '--eml', $popEml) `
                       -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("E128 vorbereitet: {0}; IncludeHeaders={1}; Mail={2}; POP-Pruefserver PID {3}" -f $md, $kopf, $mail, $p.Id)
    exit 0
}

# Die Ausgabe zusaetzlich in den Pruefstand schreiben: pruefstand-lauf.ps1
# zeigt bei einem roten Fall nur die letzten Zeilen (03.11.2026: zwei Faelle
# stiegen frueh aus, und der Grund war nicht zu sehen).
try { Start-Transcript -Path (Join-Path $voll 'messen-e128.txt') -Force | Out-Null } catch { }

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E128 {
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

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E128]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E128]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object E128+R; [void][E128]::GetWindowRect($h,[ref]$r); $r.T }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E128+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E128]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E128+EP]{ param($h,$p)
        $o = 0; [void][E128]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E128]::IsWindowVisible($h); Oben=$true})
        }
        return $true }
    [void][E128]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
function Dateidialog($pp) {
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' })) {
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
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' })) {
        if (Kinder $d.H | Where-Object { (Kl $_) -eq 'DUIViewWndClassName' }) { continue }
        $texte = @(); $knoepfe = @()
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button')         { $knoepfe += [pscustomobject]@{H=$c; T=$t} }
        }
        Write-Host ("E128 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E128]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E128]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E128]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E128]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E128]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E128]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E128]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][E128]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][E128]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][E128]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
}
function InListe() {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt 32792                       # ID_MAILBOX_IN
        $k = Aktiv $mdi; $lb = Liste $k
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    Write-Host 'E128 FEHLER: Postfach In kam nicht nach vorn'; PopBeenden; exit 1
}

# Die ComboBox "Dateityp": die, deren Eintraege die Form "... (*.xyz)" haben.
# Liefert Handle, gewaehlten Index (0-basiert) und Eintraege.
function DateitypBox($d) {
    foreach ($c in (Kinder $d | Where-Object { (Kl $_) -eq 'ComboBox' })) {
        $n = [int][E128]::SendMessageA($c, 0x0146, [IntPtr]::Zero, [IntPtr]::Zero)   # CB_GETCOUNT
        $eintraege = @()
        for ($i = 0; $i -lt $n -and $i -lt 30; $i++) {
            $len = [int][E128]::SendMessageA($c, 0x0149, [IntPtr]$i, [IntPtr]::Zero)  # CB_GETLBTEXTLEN
            if ($len -lt 0 -or $len -gt 1000) { $eintraege += ''; continue }
            $sb = New-Object Text.StringBuilder ($len + 2)
            [void][E128]::SendHole($c, 0x0148, [IntPtr]$i, $sb)                      # CB_GETLBTEXT
            $eintraege += $sb.ToString()
        }
        if ($eintraege | Where-Object { $_ -match '\(\*\.' }) {
            $sel = [int][E128]::SendMessageA($c, 0x0147, [IntPtr]::Zero, [IntPtr]::Zero)   # CB_GETCURSEL
            return [pscustomobject]@{ H = $c; Sel = $sel; Eintraege = $eintraege }
        }
    }
    return $null
}

$script:ext = @{}; $script:rtf = 0
function SpeichernUnter([string] $weg) {
    $stamm = Join-Path $md ("e128-" + $weg)
    [void][E128]::PostMessageA($haupt, 0x0111, [IntPtr]57604, [IntPtr]::Zero)   # ID_FILE_SAVE_AS
    $d = WarteAufDialog $pp
    if ($d -eq 'tot') { Write-Host "E128 $weg ABGESTUERZT beim Aufbau des Dateidialogs"; PopBeenden; exit 1 }
    if (-not $d) { Write-Host "E128 $weg kein Dateidialog erschienen"; [void](Dialoge $pp); $script:ext[$weg] = 'kein-dialog'; return }
    Start-Sleep -Milliseconds 600
    $box = DateitypBox $d
    $typ = '-'; $sel = -1
    if ($box) {
        $sel = $box.Sel
        if ($sel -ge 0 -and $sel -lt $box.Eintraege.Count) { $typ = $box.Eintraege[$sel] }
        if ($box.Eintraege | Where-Object { $_ -match '(?i)\.rtf\b' }) { $script:rtf++ }
        Write-Host ("E128 LISTE {0}: {1}" -f $weg, ($box.Eintraege -join ' | '))
    }
    $edits = Kinder $d | Where-Object { (Kl $_) -eq 'Edit' -and [E128]::IsWindowVisible($_) }
    $feld = $edits | Where-Object { (Tx $_) } | Select-Object -First 1
    if (-not $feld) { $feld = $edits | Sort-Object { Oben $_ } | Select-Object -First 1 }
    $name = $(if ($feld) { Tx $feld } else { '-' })
    # Den Namen OHNE Endung einsetzen - die Endung haengt der Dialog an.
    [void][E128]::SendText($feld, 0x000C, [IntPtr]::Zero, $stamm)       # WM_SETTEXT
    Start-Sleep -Milliseconds 500
    [void][E128]::PostMessageA($d, 0x0111, [IntPtr]1, [IntPtr]::Zero)   # IDOK
    $datei = $null
    for ($i = 0; $i -lt 40 -and (Lebt $pp) -and -not $datei; $i++) {
        Start-Sleep -Milliseconds 250
        $datei = Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -like ("e128-" + $weg + "*") } | Select-Object -First 1
    }
    Start-Sleep -Milliseconds 800
    if ((Lebt $pp) -and (Dateidialog $pp)) {
        Write-Host "E128 $weg Dateidialog steht noch - wird abgebrochen"
        [void][E128]::PostMessageA((Dateidialog $pp), 0x0111, [IntPtr]2, [IntPtr]::Zero)   # IDCANCEL
        Start-Sleep -Milliseconds 800
    }
    [void](Dialoge $pp)
    $e = 'fehlt'
    if ($datei) { $e = $(if ($datei.Extension) { $datei.Extension.TrimStart('.').ToLower() } else { '(keine)' }) }
    $script:ext[$weg] = $e
    Write-Host ("E128 WEG {0} typ-index={1} typ={2} name={3} datei={4}" -f $weg, $sel, $typ, $name, $e)
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E128 FEHLER: keine Eudora aus $voll"; PopBeenden; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E128 FEHLER: kein Hauptfenster'; PopBeenden; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E128 Prozess $pp Hauptfenster $haupt MDI $mdi kopf=$kopf mail=$mail"
[void](Dialoge $pp)

# --- Post holen -------------------------------------------------------------
$in, $lbIn = InListe
$vorher = Anzahl $lbIn
[void][E128]::PostMessageA($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)   # ID_FILE_CHECKMAIL
for ($i = 0; $i -lt 40 -and (Anzahl $lbIn) -le $vorher; $i++) { Start-Sleep -Milliseconds 500; if (($i % 6) -eq 5) { [void](Dialoge $pp) } }
Start-Sleep -Seconds 2
[void](Dialoge $pp)
PopBeenden
$in, $lbIn = InListe
$nIn = Anzahl $lbIn
Write-Host ("E128 In: vorher={0} nachher={1}" -f $vorher, $nIn)
# Positivprobe: die Pruefnachricht liegt im Postfach, in der erwarteten Form.
$mbxPfad = Join-Path $md 'In.mbx'
$mbx = 0
if (Test-Path -LiteralPath $mbxPfad) {
    $m = $lat.GetString([IO.File]::ReadAllBytes($mbxPfad))
    if ($text) { $mbx = [int]($m -match 'E-128 Pruefnachricht' -and $m -notmatch '(?i)<x-html') }
    else       { $mbx = [int]($m -match 'E-118 Pruefnachricht' -and $m -match '(?i)<x-html') }
}
Write-Host "E128 MBX passt=$mbx"

if ($nIn -ge 1) {
    [void](Waehle $lbIn 0)
    SpeichernUnter 'liste'

    $in, $lbIn = InListe
    [void](Waehle $lbIn 0)
    [void][E128]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN an die Liste
    [void][E128]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
    Start-Sleep -Seconds 3
    $lesen = Aktiv $mdi
    if ($lesen -eq $in) { Write-Host 'E128 FEHLER: die Nachricht liess sich nicht oeffnen' }
    else {
        SpeichernUnter 'lesen'
        Befehl $haupt 32855                           # ID_MESSAGE_REPLY
        Start-Sleep -Seconds 2
        [void](Dialoge $pp)
        $verfassen = Aktiv $mdi
        if ($verfassen -eq $lesen) { Write-Host 'E128 FEHLER: Reply hat kein Verfassen-Fenster geoeffnet' }
        else {
            SpeichernUnter 'verfassen'
            [void][E128]::PostMessageA($verfassen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
            Start-Sleep -Milliseconds 1200
            for ($r = 0; $r -lt 4; $r++) { if ((Dialoge $pp '^(No|Nein|Don.t Save|OK)$') -eq 0) { break }; Start-Sleep -Milliseconds 600 }
        }
        [void][E128]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
        Start-Sleep -Milliseconds 1000
        [void](Dialoge $pp)
    }
}

# --- Spur aus dem Protokoll (nur zur Kenntnis; das Urteil steht in den Dateien)
$spur = 0
$log = Join-Path $md 'eudora.log'
if (Test-Path -LiteralPath $log) {
    # Eudora haelt die Datei offen - ReadAllBytes bricht dann ab (gemessen am
    # 03.11.2026: die Ergebniszeile fehlte). Darum mit FileShare.ReadWrite.
    $logText = ''
    try {
        $fs = [IO.File]::Open($log, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
        $ms = New-Object IO.MemoryStream; $fs.CopyTo($ms); $fs.Close()
        $logText = $lat.GetString($ms.ToArray())
    } catch { Write-Host ("E128 SPUR nicht lesbar: {0}" -f $_.Exception.Message) }
    # Nur ab dem letzten Programmstart zaehlen: der Pruefstand behaelt seine
    # eudora.log, ein zweiter Lauf saehe sonst die Zeilen des ersten mit.
    $abStart = $logText.LastIndexOf("`nVersion 7.")
    if ($abStart -ge 0) { $logText = $logText.Substring($abStart) }
    foreach ($z in ($logText -split "`r?`n" | Where-Object { $_ -match 'E-128 (Vorgabeendung|gespeichert)' })) {
        Write-Host ("E128 SPUR {0}" -f $z.Trim()); $spur++
    }
}
function Ext([string] $w) { if ($script:ext.ContainsKey($w)) { return $script:ext[$w] } else { return '-' } }
Write-Host ("E128 ERGEBNIS kopf={0} mail={1} mbx={2} liste={3} lesen={4} verfassen={5} spur={6} rtf={7} lebt={8}" -f `
    $kopf, $mail, $mbx, (Ext 'liste'), (Ext 'lesen'), (Ext 'verfassen'), $spur, $script:rtf, [int](Lebt $pp))
