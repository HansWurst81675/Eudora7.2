# messen-e177.ps1 - Befund E-177: welche Zeichensatzangabe traegt die Datei,
# die die Filteraktion "Notify Application" mit dem Platzhalter %6 einem
# Programm uebergibt?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, Pruefstand C:\Temp\E177
# (Kopie von C:\Temp\E140, POP-Konto auf den Pruefserver 127.0.0.1:11110).
# Nur Botschaften an gemessene Fensterhandles, kein Tastendruck.
#
# WARUM ES DAS GIBT. CFilter::SetupCommandLine (filtersd.cpp) schreibt fuer
# eine empfangene Nachricht mit IncludeHeaders=1 ueber
# CReadMessageDoc::SaveAs - an E101SpeicherfassungAufbereiten/E140TextFuerDatei
# (msgutils.cpp) vorbei. Ungemessen war, was dann in der Datei steht: die
# Original-Kopfzeile "charset=utf-8" ueber einem Rumpf, den Eudora beim
# Empfang schon nach windows-1252 uebersetzt hat (falsche Angabe), oder etwas
# anderes.
#
#   -Vorbereiten: In.mbx bekommt roh zwei Nachrichten
#       Testdaten\e118-euro-in-imap-ordner.eml   (windows-1252, Betreff E-118)
#       Testdaten\e177-utf8-umlaute.eml           (utf-8, Betreff "... [roh]")
#     und der POP-Pruefserver liefert dieselbe UTF-8-Nachricht ein drittes Mal
#     ueber den echten Empfangsweg aus (Betreff "... [pop]"). Filters.pce
#     bekommt eine Regel "manual", From: enthaelt .invalid, Aktion notifyApp
#     mit wscript und e177-kopieren.vbs "%6"; das Skript kopiert die Datei
#     nach Mailverzeichnis\e177-<lfd>.txt und loescht das Original in TEMP.
#   Messen: Post holen (ID_FILE_CHECKMAIL), In.mbx lesen (wie liegt die
#     Nachricht im Postfach?), alle Nachrichten in In waehlen,
#     ID_SPECIAL_FILTERMESSAGES (32816), auf die Dateien warten, auswerten.
#
# Ausgabe:
#   E177 MBX <nachricht> charset=<wert|-> rumpf=<cp1252|utf8|ascii|beide>
#   E177 DATEI <n> bytes=<n> ct=<Content-Type-Zeile|-> charset=<wert|-> euro=<cp1252|utf8|fragezeichen|fehlt> umlaute=<n> nachricht=<..> rumpf=<..> urteil=<passt|falsch|fehlt>
#   E177 ERGEBNIS dateien=<n> pop=<urteil> e118=<urteil> roh=<urteil> falsche-angabe=<n> fehlende-angabe=<n> lebt=<0|1>
#   "falsch" = charset sagt utf-8, die Bytes sind windows-1252 (oder umgekehrt).
#   falsche-angabe/fehlende-angabe zaehlen nur [pop] und e118. [pop] kommt
#   ueber den echten Empfangsweg. e118 liegt ebenso roh im Postfach wie
#   [roh] (PRUEFER-81 K4), aber windows-* uebersetzt Eudora beim Empfang
#   nicht (FindMIMECharset liefert 0) - roh und empfangen sind dort gleich.
#   [roh] steht nur zur Auskunft da: "charset=utf-8" (mit Bindestrich)
#   uebersetzt Eudora beim Empfang immer, roh eingelegt gibt es das nach
#   einem Empfang nicht. Fuer "utf8" OHNE Bindestrich gilt das nicht - die
#   Schreibweise bleibt unuebersetzt, und der Kern laesst ihre Angabe seit
#   PRUEFER-81 K1 stehen (msgutils.cpp, bRumpfIstCp1252).
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E177 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$repo = Split-Path -Parent $PSScriptRoot
$lat = [Text.Encoding]::GetEncoding(28591)
$pidDatei = Join-Path $voll 'pop-pruefserver.pid'
$vbs = Join-Path $voll 'e177-kopieren.vbs'

function PopBeenden {
    if (-not (Test-Path -LiteralPath $pidDatei)) { return }
    $alt = [int](Get-Content -LiteralPath $pidDatei)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "E177 POP-Pruefserver $alt beendet" }
    Remove-Item -LiteralPath $pidDatei -Force
}
# Betreff einer Nachricht um eine Marke ergaenzen (Bytes bleiben sonst gleich).
function MitMarke([byte[]] $b, [string] $marke) {
    $t = $lat.GetString($b)
    $t = [regex]::Replace($t, '(?m)^(Subject: [^\r\n]*)', ('$1 [' + $marke + ']'), 'None')
    return $lat.GetBytes($t)
}

if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E177 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    PopBeenden
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^(e177-.*\.(txt|log)|lmos\.dat.*)$' } | Remove-Item -Force
    foreach ($d in 'spool','Embedded') { $p = Join-Path $md $d; if (Test-Path $p) { Get-ChildItem -LiteralPath $p -File | Remove-Item -Force } }

    # Konto auf den POP-Pruefserver (Kennwort "x"), nur in [Settings].
    $ini = Join-Path $md 'Eudora.ini'
    $t = $lat.GetString([IO.File]::ReadAllBytes($ini))
    foreach ($kv in @(@('POPPort','11110'), @('SSLReceiveUse','0'), @('SavePassword','1'), @('SavePasswordText','eA=='))) {
        $k = $kv[0]; $v = $kv[1]
        if ($t -match ('(?m)^' + $k + '=')) { $t = [regex]::Replace($t, ('(?m)^' + $k + '=[^\r\n]*'), ($k + '=' + $v)) }
        else { $t = $t -replace '(?m)^\[Settings\]\r?\n', ("[Settings]`r`n" + $k + '=' + $v + "`r`n") }
    }
    [IO.File]::WriteAllBytes($ini, $lat.GetBytes($t))

    # In.mbx roh: e118 (windows-1252) und e177 (utf-8).
    $e118 = [IO.File]::ReadAllBytes((Join-Path $repo 'Testdaten\e118-euro-in-imap-ordner.eml'))
    $e177 = [IO.File]::ReadAllBytes((Join-Path $repo 'Testdaten\e177-utf8-umlaute.eml'))
    $kopf = [Text.Encoding]::ASCII.GetBytes("From ???@??? Mon Nov 02 10:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopf + $e118 + $ende + $kopf + (MitMarke $e177 'roh') + $ende))

    # Filters.pce: Latin-1, CRLF (Muster messen-e67.ps1).
    $zeilen = @('3', 'rule E-177 Programm',
                ('notifyApp C:\Windows\System32\wscript.exe //B //Nologo ' + $vbs + ' "%6"'),
                'manual', 'header From:', 'verb contains', 'value .invalid',
                'conjunction ignore', 'header ', 'verb contains', 'value ')
    [IO.File]::WriteAllText((Join-Path $md 'Filters.pce'), (($zeilen -join "`r`n") + "`r`n"), $lat)

    # Kopierer: legt e177-<lfd>.txt exklusiv an (mehrere Aufrufe laufen
    # gleichzeitig), kopiert die %6-Datei hinein und loescht sie in TEMP.
    $v = @(
        'Option Explicit',
        'Dim fso, quelle, md, n, ziel, f',
        'Set fso = CreateObject("Scripting.FileSystemObject")',
        ('md = "' + $md + '\"'),
        'If WScript.Arguments.Count < 1 Then WScript.Quit 1',
        'quelle = WScript.Arguments(0)',
        'On Error Resume Next',
        'n = 1',
        'Do',
        '  Err.Clear',
        '  ziel = md & "e177-" & n & ".txt"',
        '  Set f = fso.CreateTextFile(ziel, False)',
        '  If Err.Number = 0 Then Exit Do',
        '  n = n + 1',
        '  If n > 50 Then WScript.Quit 2',
        'Loop',
        'f.Close',
        'Err.Clear',
        'fso.CopyFile quelle, ziel, True',
        'Dim ok : ok = Err.Number',
        'Set f = fso.OpenTextFile(md & "e177-aufrufe-" & n & ".log", 2, True)',
        'f.WriteLine quelle & " -> " & ziel & " kopiert=" & ok',
        'f.Close',
        'If ok = 0 Then fso.DeleteFile quelle, True'
    )
    [IO.File]::WriteAllText($vbs, (($v -join "`r`n") + "`r`n"), [Text.Encoding]::ASCII)

    # POP-Pruefserver mit der UTF-8-Nachricht, Betreff "[pop]".
    $belegt = Get-NetTCPConnection -LocalPort 11110 -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Host "E177 FEHLER: Port 11110 ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $post = Join-Path $voll 'post'
    if (Test-Path $post) { Get-ChildItem -LiteralPath $post -File | Remove-Item -Force } else { New-Item -ItemType Directory $post | Out-Null }
    $popEml = Join-Path $post 'e177-pop.eml'
    [IO.File]::WriteAllBytes($popEml, (MitMarke $e177 'pop'))
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $p = Start-Process $perl -ArgumentList @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml', '--eml', $popEml) `
                       -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("E177 vorbereitet: {0}; POP-Pruefserver PID {1}" -f $md, $p.Id)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E177 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E177]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E177]::GetWindowTextA($h,$s,512); $s.ToString() }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E177+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E177]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E177+EP]{ param($h,$p)
        $o = 0; [void][E177]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E177]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E177]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E177]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
# Dialoge mit Text ausgeben; ohne passenden Knopf ABBRECHEN, nie blind OK.
function Dialoge($pp, [string] $Knopf = '^(OK)$') {
    $n = 0
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        $texte = @(); $knoepfe = @()
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button')         { $knoepfe += [pscustomobject]@{H=$c; T=$t} }
        }
        Write-Host ("E177 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E177]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E177]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E177]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E177]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E177]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E177]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function InListe() {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt 32792                       # ID_MAILBOX_IN
        $k = Aktiv $mdi; $lb = Liste $k
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    Write-Host 'E177 FEHLER: Postfach In kam nicht nach vorn'; PopBeenden; exit 1
}

# --- Bytes einordnen -----------------------------------------------------------
# UTF-8-Folgen zaehlen und herausnehmen; was danach >127 bleibt, ist ein
# Einzelbyte-Zeichensatz (windows-1252).
$UTF8 = '[\xC2-\xDF][\x80-\xBF]|[\xE0-\xEF][\x80-\xBF]{2}|[\xF0-\xF4][\x80-\xBF]{3}'
function Rumpfart([string] $t) {
    $u = ([regex]::Matches($t, $UTF8)).Count
    $rest = [regex]::Replace($t, $UTF8, '')
    $c = ([regex]::Matches($rest, '[\x80-\xFF]')).Count
    if ($u -gt 0 -and $c -gt 0) { return 'beide' }
    if ($u -gt 0) { return 'utf8' }
    if ($c -gt 0) { return 'cp1252' }
    return 'ascii'
}
function Teile([string] $t) {
    $m = [regex]::Match($t, '\r?\n\r?\n')
    if (-not $m.Success) { return @($t, '') }
    return @($t.Substring(0, $m.Index), $t.Substring($m.Index + $m.Length))
}
function Charset([string] $kopf) {
    $m = [regex]::Match($kopf, '(?im)^Content-Type:[^\r\n]*(\r?\n[ \t][^\r\n]*)*')
    if (-not $m.Success) { return @('-', '-') }
    $cs = '-'
    $c = [regex]::Match($m.Value, '(?i)charset\s*=\s*"?([A-Za-z0-9._-]+)')
    if ($c.Success) { $cs = $c.Groups[1].Value }
    return @(($m.Value -replace '\s+', ' ').Trim(), $cs)
}
function Nachricht([string] $t) {
    if ($t -match 'E-177[^\r\n]*\[pop\]') { return 'e177-pop' }
    if ($t -match 'E-177[^\r\n]*\[roh\]') { return 'e177-roh' }
    if ($t -match 'E-177') { return 'e177' }
    if ($t -match 'E-118') { return 'e118' }
    return 'unbekannt'
}
function Urteil([string] $cs, [string] $art) {
    $l = $cs.ToLower()
    if ($art -eq 'ascii') { return 'passt' }
    if ($l -eq '-') { return 'fehlt' }
    if ($l -eq 'utf-8' -or $l -eq 'utf8') { if ($art -eq 'utf8') { return 'passt' } else { return 'falsch' } }
    if ($l -match '^(windows-1252|iso-8859-1|iso-8859-15|latin1)$') { if ($art -eq 'cp1252') { return 'passt' } else { return 'falsch' } }
    return 'falsch'   # us-ascii o.ae. ueber Bytes > 127
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E177 FEHLER: keine Eudora aus $voll"; PopBeenden; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E177 FEHLER: kein Hauptfenster'; PopBeenden; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E177 Prozess $pp Hauptfenster $haupt MDI $mdi"
[void](Dialoge $pp)

# --- 1. Post holen ------------------------------------------------------------
$in, $lbIn = InListe
$vorher = Anzahl $lbIn
[void][E177]::PostMessageA($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)   # ID_FILE_CHECKMAIL
for ($i = 0; $i -lt 40 -and (Anzahl $lbIn) -le $vorher; $i++) { Start-Sleep -Milliseconds 500; if (($i % 6) -eq 5) { [void](Dialoge $pp) } }
Start-Sleep -Seconds 2
[void](Dialoge $pp)
PopBeenden
$in, $lbIn = InListe
$zahl = Anzahl $lbIn
Write-Host ("E177 In: vorher={0} nachher={1}" -f $vorher, $zahl)

# --- 2. Wie liegen die Nachrichten im Postfach? ---------------------------------
$mbx = $lat.GetString([IO.File]::ReadAllBytes((Join-Path $md 'In.mbx')))
foreach ($teil in ([regex]::Split($mbx, '(?m)^From \?\?\?@\?\?\? [^\r\n]*\r?\n') | Where-Object { $_.Trim() })) {
    $kopf, $rumpf = Teile $teil
    $ctz, $cs = Charset $kopf
    Write-Host ("E177 MBX {0} charset={1} rumpf={2}" -f (Nachricht $kopf), $cs, (Rumpfart $rumpf))
}

# --- 3. Alle waehlen, Filter Messages -------------------------------------------
[void][E177]::SendMessageA($lbIn, 0x0185, [IntPtr]1, [IntPtr](-1))      # LB_SETSEL TRUE, alle
$gew = [int][E177]::SendMessageA($lbIn, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
Write-Host "E177 gewaehlt=$gew"
[void][E177]::PostMessageA($haupt, 0x0111, [IntPtr]32816, [IntPtr]::Zero)   # ID_SPECIAL_FILTERMESSAGES
$alt = -1
for ($i = 0; $i -lt 40; $i++) {
    Start-Sleep -Milliseconds 500
    $n = @(Get-ChildItem -LiteralPath $md -File -Filter 'e177-aufrufe-*.log').Count
    if ($n -ge $zahl) { break }
    if (($i % 6) -eq 5) { [void](Dialoge $pp) }
}
Start-Sleep -Seconds 1
[void](Dialoge $pp)

# --- 4. Auswertung -----------------------------------------------------------
$falsch = 0; $fehlt = 0
$weg = @{ 'e177-pop' = '-'; 'e118' = '-'; 'e177-roh' = '-' }
$dateien = @(Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^e177-(\d+)\.txt$' } |
             Sort-Object { [int]([regex]::Match($_.Name, '^e177-(\d+)').Groups[1].Value) })
foreach ($f in (Get-ChildItem -LiteralPath $md -File -Filter 'e177-aufrufe-*.log')) {
    Write-Host ("E177 AUFRUF " + ((Get-Content -LiteralPath $f.FullName) -join ' '))
}
foreach ($f in $dateien) {
    $b = [IO.File]::ReadAllBytes($f.FullName)
    $t = $lat.GetString($b)
    $kopf, $rumpf = Teile $t
    $ctz, $cs = Charset $kopf
    $art = Rumpfart $rumpf
    $ohne8 = [regex]::Replace($t, $UTF8, '')
    $euro = 'fehlt'
    if ($t.Contains(([string][char]0xE2) + [char]0x82 + [char]0xAC)) { $euro = 'utf8' }
    elseif ($ohne8.Contains([string][char]0x80)) { $euro = 'cp1252' }
    elseif ($t -match 'Preis 5 \?') { $euro = 'fragezeichen' }
    $uml = ([regex]::Matches($ohne8, '[\xE4\xF6\xFC\xDF\xC4\xD6\xDC]')).Count +
           ([regex]::Matches($t, '\xC3[\xA4\xB6\xBC\x9F\x84\x96\x9C]')).Count
    $u = Urteil $cs $art
    $wer = Nachricht $t
    $weg[$wer] = $u
    # [roh] zaehlt NICHT mit: so liegt eine Nachricht nie im Postfach, wenn
    # Eudora sie empfangen hat (der Rumpf wird beim Empfang nach
    # windows-1252 uebersetzt, msgutils.cpp Abschnitt 4a, PRUEFER-37 F3).
    # Am 02.11.2026 meldete der Fall nach der Behebung weiter
    # falsche-angabe=1 - jetzt von [roh] statt von [pop], und die alte
    # Erwartung hiess genau so: "bestanden" aus falschem Grund.
    if ($wer -ne 'e177-roh') {
        if ($u -eq 'falsch') { $falsch++ }
        if ($u -eq 'fehlt')  { $fehlt++ }
    }
    $nr = [regex]::Match($f.Name, '^e177-(\d+)').Groups[1].Value
    Write-Host ("E177 DATEI {0} bytes={1} ct={2} charset={3} euro={4} umlaute={5} nachricht={6} rumpf={7} urteil={8}" -f `
                $nr, $b.Length, $ctz, $cs, $euro, $uml, (Nachricht $t), $art, $u)
    $erste = ($t -split "`r?`n" | Select-Object -First 12) -join ' | '
    Write-Host ("E177 KOPF {0}: {1}" -f $nr, $erste)
}
Write-Host ("E177 ERGEBNIS dateien={0} pop={1} e118={2} roh={3} falsche-angabe={4} fehlende-angabe={5} lebt={6}" -f $dateien.Count, $weg['e177-pop'], $weg['e118'], $weg['e177-roh'], $falsch, $fehlt, [int](Lebt $pp))
