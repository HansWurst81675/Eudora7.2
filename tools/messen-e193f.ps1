# messen-e193f.ps1 - Befund E-193 (Rest nach Gregors Test an 7.2.2.133):
# Edit -> Find im Nachrichtenfenster findet in einer weitergeleiteten
# Outlook-HTML-Rundmail ein sichtbares Wort mit Umlaut nicht.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript -MitVorbereiten, Pruefstand
# C:\Temp\E193f (Kopie von C:\Temp\E193 mit dem Bau, der gemessen wird),
# POP-Konto auf 127.0.0.1:11110. Nur Botschaften an gemessene Handles, kein
# Tastendruck (das VK_RETURN an die Postfachliste ist eine Botschaft an ein
# gemessenes Handle, wie in messen-e193.ps1).
#
# WARUM ES DAS GIBT. Gregor am 04.11.2026 an 7.2.2.133: in einer weiter-
# geleiteten Rundmail meldet Edit -> Find fuenfmal "not found" fuer ein
# Wort mit u-Umlaut, das sichtbar in ihrer Fusszeile steht; in einer
# einfachen HTML-Mail findet es dasselbe Wort. Die Mail hat zwei Emoji als
# Zeichenreferenz ausserhalb der BMP VOR der Fusszeile und ein eigenes
# inneres meta charset=utf-8. Welches Merkmal stoert, war Vermutung.
#
# TESTDATEN (Testdaten/e193-f1..f8.eml, synthetisch, windows-1252 8bit,
# Adressen auf .invalid). In jeder Mail: "Amsel" ganz vorn, in der Fusszeile
# "Geschaeftsfuehrung" (mit Umlauten) und dahinter "Kolibri" (ASCII).
#   f1 Outlook-Aufbau, Emoji (&#128205; &#128197;) VOR der Fusszeile, inneres meta
#   f2 Outlook, nur Emoji          f3 Outlook, nur inneres meta
#   f4 Outlook, ohne beides        f5 Outlook, Emoji NACH dem Wort, inneres meta
#   f6 Outlook, BMP-Zeichen (&#9733; &#9742;) statt Emoji, inneres meta
#   f7 einfach, Emoji vor          f8 einfach, ohne Emoji
#
# MESSEN: Post holen, je Mail und je Suchwort ein frisches Nachrichtenfenster,
# WM_FINDREPLACE (commdlg_FindReplace) mit FR_DOWN wie in messen-e193.ps1;
# Rueckgabe EuFIND_OK=0, EuFIND_NOTFOUND=2. "Zebrafink" steht in keiner Mail
# (Gegenprobe: muss "nicht" liefern).
#
# AUSGABE
#   E193F <fN> <wort> ist=gefunden|nicht|fehler<n>
#   E193F <fN> gefunden=<0|1>      (1 = alle fuenf Woerter dieser Mail gefunden)
#   E193F ERGEBNIS f1=<0|1> ... f8=<0|1> negativ-falsch=<n> mails=<n> lebt=<0|1>
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E193F ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$repo = Split-Path -Parent $PSScriptRoot
$cp = [Text.Encoding]::GetEncoding(1252)
$pidDatei = Join-Path $voll 'pop-pruefserver.pid'
$MAILS = @('f1','f2','f3','f4','f5','f6','f7','f8')
function C([int[]] $codes) { return -join ($codes | ForEach-Object { [char]$_ }) }
$ae = C 0xE4; $ue = C 0xFC
$WOERTER = @(('f' + $ue + 'hrung'), ('Gesch' + $ae + 'ftsf' + $ue + 'hrung'), 'Gesch', 'Kolibri', 'Amsel')
$NEGATIV = 'Zebrafink'
function Sichtbar([string] $s) { return -join ($s.ToCharArray() | ForEach-Object { if ([int]$_ -lt 128) { $_ } else { '<' + ('{0:X}' -f [int]$_) + '>' } }) }

function PopBeenden {
    if (-not (Test-Path -LiteralPath $pidDatei)) { return }
    $alt = [int](Get-Content -LiteralPath $pidDatei)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "E193F POP-Pruefserver $alt beendet" }
    Remove-Item -LiteralPath $pidDatei -Force
}

if ($Vorbereiten) {
    $ini = Join-Path $md 'Eudora.ini'
    if (-not (Test-Path $ini)) { Write-Host "E193F FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    PopBeenden
    foreach ($n in 'Out','In','Trash','Junk') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } | Remove-Item -Force
    }
    $sp = Join-Path $md 'spool'; if (Test-Path $sp) { Get-ChildItem -LiteralPath $sp -File -Recurse | Remove-Item -Force }
    $fp = Join-Path $md 'Filters.pce'; if (Test-Path $fp) { Remove-Item -LiteralPath $fp -Force }
    $t = $cp.GetString([IO.File]::ReadAllBytes($ini))
    foreach ($kv in @(@('POPPort','11110'), @('SSLReceiveUse','0'), @('SavePassword','1'), @('SavePasswordText','eA=='),
                      @('IncludeHeaders','0'), @('GuessParagraphs','0'))) {
        $k = $kv[0]; $v = $kv[1]
        if ($t -match ('(?m)^' + $k + '=')) { $t = [regex]::Replace($t, ('(?m)^' + $k + '=[^\r\n]*'), ($k + '=' + $v)) }
        else { $t = $t -replace '(?m)^\[Settings\]\r?\n', ("[Settings]`r`n" + $k + '=' + $v + "`r`n") }
    }
    [IO.File]::WriteAllBytes($ini, $cp.GetBytes($t))
    $belegt = Get-NetTCPConnection -LocalPort 11110 -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Host "E193F FEHLER: Port 11110 ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $a = @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml')
    foreach ($m in $MAILS) { $a += @('--eml', (Join-Path $repo ('Testdaten\e193-' + $m + '.eml'))) }
    $p = Start-Process $perl -ArgumentList $a -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("E193F vorbereitet: {0}; POP-Pruefserver PID {1} mit {2} Mails" -f $md, $p.Id, $MAILS.Count)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E193 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindowEnabled(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr GetParent(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint fl, uint ms, out IntPtr r);
  [DllImport("user32.dll", CharSet=CharSet.Ansi, EntryPoint="SendMessageA")] public static extern IntPtr SendText(IntPtr h, uint m, IntPtr w, byte[] l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern uint RegisterWindowMessageA(string s);
  [DllImport("kernel32.dll")] public static extern IntPtr OpenProcess(uint a, bool i, uint pid);
  [DllImport("kernel32.dll")] public static extern IntPtr VirtualAllocEx(IntPtr p, IntPtr a, uint n, uint t, uint pr);
  [DllImport("kernel32.dll")] public static extern bool VirtualFreeEx(IntPtr p, IntPtr a, uint n, uint t);
  [DllImport("kernel32.dll")] public static extern bool WriteProcessMemory(IntPtr p, IntPtr a, byte[] b, uint n, out IntPtr w);
  [DllImport("kernel32.dll")] public static extern bool ReadProcessMemory(IntPtr p, IntPtr a, byte[] b, uint n, out IntPtr r);
  [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
}
"@
function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E193]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E193]::GetWindowTextA($h,$s,512); $s.ToString() }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E193+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E193]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function Oberste($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E193+EP]{ param($h,$p); $o = 0; [void][E193]::GetWindowThreadProcessId($h,[ref]$o); if ($o -eq $pp) { [void]$r.Add($h) }; return $true }
    [void][E193]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
function Befehl($h, [int] $id) { [void][E193]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E193]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }
function Liste($kind) { return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E193]::IsWindowVisible($_) } | Select-Object -First 1) }
function Anzahl($lb) { return [int][E193]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }
function NachID($wurzel, [int] $id) { return (Kinder $wurzel | Where-Object { [E193]::GetDlgCtrlID($_) -eq $id } | Select-Object -First 1) }
function Dialoge($pp) {
    $n = 0
    foreach ($d in @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) -and (Kl $_) -eq '#32770' })) {
        $texte = @(Kinder $d | ForEach-Object { Tx $_ } | Where-Object { $_ })
        Write-Host ("E193F DIALOG [{0}] {1}" -f (Tx $d), ($texte -join ' | '))
        [void][E193]::PostMessageA($d, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
        $n++
    }
    if ($n) { Start-Sleep -Milliseconds 800 }
    return $n
}
$logPfad = Join-Path $md 'eudora.log'
function LogZeilen() {
    if (-not (Test-Path -LiteralPath $logPfad)) { return @() }
    $fs = [IO.File]::Open($logPfad, 'Open', 'Read', 'ReadWrite')
    try { $b = New-Object byte[] $fs.Length; [void]$fs.Read($b, 0, $b.Length) } finally { $fs.Close() }
    return @($cp.GetString($b) -split "`r?`n")
}

$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E193F FEHLER: keine Eudora aus $voll"; PopBeenden; exit 1 }
try { Start-Transcript -LiteralPath (Join-Path $voll 'messen-e193f.txt') -Force | Out-Null } catch { }
$pp = $proz[0].Id
$haupt = Oberste $pp | Where-Object { (Kl $_) -eq 'EudoraMainWindow' -and [E193]::IsWindowVisible($_) } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E193F FEHLER: kein Hauptfenster'; PopBeenden; exit 1 }
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
[void](Dialoge $pp)
$hp = [E193]::OpenProcess(0x0438, $false, [uint32]$pp)
$fern = [E193]::VirtualAllocEx($hp, [IntPtr]::Zero, 8192, 0x3000, 0x04)
$WM_FINDREPLACE = [E193]::RegisterWindowMessageA('commdlg_FindReplace')
function Schreibe([int] $versatz, [byte[]] $b) { $w = [IntPtr]::Zero; [void][E193]::WriteProcessMemory($hp, [IntPtr]($fern.ToInt64() + $versatz), $b, [uint32]$b.Length, [ref]$w) }
function I32([int] $v) { return [BitConverter]::GetBytes([int32]$v) }

$lebt = 1; $nIn = 0; $negFalsch = 0
$je = [ordered]@{}; foreach ($m in $MAILS) { $je[$m] = $null }
$jeB = [ordered]@{}; foreach ($m in $MAILS) { $jeB[$m] = $null }; $negFalschB = 0
try {
    Befehl $haupt 32792                                   # ID_MAILBOX_IN
    $in = Aktiv $mdi; $lbIn = Liste $in
    $vorher = Anzahl $lbIn
    [void][E193]::PostMessageA($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)   # ID_FILE_CHECKMAIL
    for ($i = 0; $i -lt 60 -and (Anzahl $lbIn) -lt ($vorher + $MAILS.Count); $i++) { Start-Sleep -Milliseconds 500; if (($i % 6) -eq 5) { [void](Dialoge $pp) } }
    Start-Sleep -Seconds 2
    [void](Dialoge $pp)
    PopBeenden
    $nIn = Anzahl $lbIn
    Write-Host ("E193F In: vorher={0} nachher={1}" -f $vorher, $nIn)

    Befehl $haupt 33247                                   # ID_EDIT_SORT_SORTBYDATE
    for ($z = 0; $z -lt $nIn; $z++) {
        foreach ($w in @($WOERTER + $NEGATIV)) {
            $in = Aktiv $mdi
            [void][E193]::SendMessageA($lbIn, 0x0185, [IntPtr]0, [IntPtr](-1))
            [void][E193]::SendMessageA($lbIn, 0x0185, [IntPtr]1, [IntPtr]$z)
            [void][E193]::SendMessageA($lbIn, 0x019E, [IntPtr]$z, [IntPtr]0)
            [void][E193]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)
            [void][E193]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
            Start-Sleep -Milliseconds 1800
            $lesen = Aktiv $mdi
            if ($lesen -eq $in) { Write-Host "E193F FEHLER: Zeile $z liess sich nicht oeffnen"; break }
            $titel = Tx $lesen
            $mi = ''; if ($titel -match 'E193F (F\d)') { $mi = $Matches[1].ToLower() }
            if ($mi) {
                $wb = $cp.GetBytes($w); $wz = New-Object byte[] ($wb.Length + 1); [Array]::Copy($wb, $wz, $wb.Length)
                Schreibe 256 $wz
                $fr = New-Object byte[] 40
                [Array]::Copy((I32 40), 0, $fr, 0, 4)
                [Array]::Copy((I32 1), 0, $fr, 12, 4)                                   # FR_DOWN
                [Array]::Copy((I32 ([int]($fern.ToInt64() + 256))), 0, $fr, 16, 4)
                [Array]::Copy([BitConverter]::GetBytes([uint16]$wb.Length), 0, $fr, 24, 2)
                Schreibe 0 $fr
                $res = [IntPtr]::Zero
                [void][E193]::SendMessageTimeoutA($lesen, $WM_FINDREPLACE, [IntPtr]0, $fern, 2, 5000, [ref]$res)
                $rc = [int]$res
                $ist = switch ($rc) { 0 { 'gefunden' } 2 { 'nicht' } default { "fehler$rc" } }
                Write-Host ("E193F {0} {1} ist={2}" -f $mi, (Sichtbar $w), $ist)
                if ($w -eq $NEGATIV) { if ($ist -ne 'nicht') { $negFalsch++ } }
                else {
                    $ok = [int]($ist -eq 'gefunden')
                    if ($null -eq $je[$mi]) { $je[$mi] = $ok } else { $je[$mi] = [int]($je[$mi] -and $ok) }
                }
            } else { Write-Host "E193F HINWEIS: Zeile $z Titel '$titel' ist keine Testmail" }
            [void][E193]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
            Start-Sleep -Milliseconds 700
            [void](Dialoge $pp)
        }
    }

    # --- Weg B: der echte Suchdialog (Edit -> Find, 32776), Weitersuchen ------
    # Wie Gregor: Nachrichtenfenster offen, Edit -> Find, Wort ins Feld (edt1,
    # 1152), "Weitersuchen" (IDOK) - die Suche geht ueber FINDMSGSTRING an das
    # Hauptfenster und QCFindMgr an das Fenster, das UpdateFindFocus gewaehlt
    # hat. "not found" ist dann ein eigener Dialog (ErrorDialog). Nur fuer das
    # Wort mit Umlaut und fuer "Kolibri"; Positivprobe ist f8.
    foreach ($z in 0..($nIn - 1)) {
        foreach ($w in @($WOERTER[0], 'Kolibri', $NEGATIV)) {
            $in = Aktiv $mdi
            [void][E193]::SendMessageA($lbIn, 0x0185, [IntPtr]0, [IntPtr](-1))
            [void][E193]::SendMessageA($lbIn, 0x0185, [IntPtr]1, [IntPtr]$z)
            [void][E193]::SendMessageA($lbIn, 0x019E, [IntPtr]$z, [IntPtr]0)
            [void][E193]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)
            [void][E193]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
            Start-Sleep -Milliseconds 1800
            $lesen = Aktiv $mdi
            if ($lesen -eq $in) { Write-Host "E193F FEHLER: Zeile $z liess sich nicht oeffnen (Weg B)"; break }
            $titel = Tx $lesen
            $mi = ''; if ($titel -match 'E193F (F\d)') { $mi = $Matches[1].ToLower() }
            Befehl $haupt 32776                                  # ID_EDIT_FIND_FINDTEXT
            $dlg = $null; $edt = $null
            foreach ($d in @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) -and (Kl $_) -eq '#32770' })) {
                $e = NachID $d 1152
                if ($e) { $dlg = $d; $edt = $e; break }
            }
            if (-not $dlg) { Write-Host "E193F B $mi FEHLER: kein Suchdialog"; [void][E193]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); Start-Sleep -Milliseconds 700; continue }
            $bytes = $cp.GetBytes($w + [char]0)
            [void][E193]::SendText($edt, 0x000C, [IntPtr]::Zero, $bytes)
            Start-Sleep -Milliseconds 300
            $ok1 = NachID $dlg 1
            [void][E193]::PostMessageA($dlg, 0x0111, [IntPtr]1, $ok1)     # IDOK, BN_CLICKED
            Start-Sleep -Milliseconds 1500
            $nf = 0
            foreach ($d in @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) -and (Kl $_) -eq '#32770' -and $_ -ne $dlg })) {
                $texte = @(Kinder $d | ForEach-Object { Tx $_ } | Where-Object { $_ })
                if (($texte -join ' ') -match 'not found') { $nf = 1 }
                Write-Host ("E193F B DIALOG [{0}] {1}" -f (Tx $d), ($texte -join ' | '))
                [void][E193]::PostMessageA($d, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
            }
            Start-Sleep -Milliseconds 500
            Write-Host ("E193F B {0} {1} ist={2}" -f $mi, (Sichtbar $w), $(if ($nf) { 'nicht' } else { 'gefunden' }))
            if ($mi) {
                if ($w -eq $NEGATIV) { if (-not $nf) { $negFalschB++ } }
                else { $okb = [int](-not $nf); if ($null -eq $jeB[$mi]) { $jeB[$mi] = $okb } else { $jeB[$mi] = [int]($jeB[$mi] -and $okb) } }
            }
            [void][E193]::PostMessageA($dlg, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
            Start-Sleep -Milliseconds 500
            [void][E193]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
            Start-Sleep -Milliseconds 700
            [void](Dialoge $pp)
        }
    }
}
catch { Write-Host ('E193F ABBRUCH: ' + $_.Exception.Message) }
finally {
    PopBeenden
    [void][E193]::VirtualFreeEx($hp, $fern, 0, 0x8000)
    [void][E193]::CloseHandle($hp)
    $lebt = [int](Lebt $pp)
}
foreach ($m in $MAILS) { Write-Host ("E193F {0} gefunden={1}" -f $m, $(if ($null -eq $je[$m]) { '-' } else { $je[$m] })) }
$teile = @($MAILS | ForEach-Object { '{0}={1}' -f $_, $(if ($null -eq $je[$_]) { '-' } else { $je[$_] }) })
Write-Host ("E193F ERGEBNIS {0} negativ-falsch={1} mails={2} lebt={3}" -f ($teile -join ' '), $negFalsch, $nIn, $lebt)
$teileB = @($MAILS | ForEach-Object { '{0}={1}' -f $_, $(if ($null -eq $jeB[$_]) { '-' } else { $jeB[$_] }) })
Write-Host ("E193F ERGEBNIS-DIALOG {0} negativ-falsch={1}" -f ($teileB -join ' '), $negFalschB)
try { Stop-Transcript | Out-Null } catch { }
