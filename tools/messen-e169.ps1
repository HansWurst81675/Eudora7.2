# messen-e169.ps1 - Befund E-169: die Druckvorschau einer HTML-Mail zeigt
# keine Bilder und keine farbigen Flaechen, das Lesefenster schon.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript -MitVorbereiten, Pruefstand
# C:\Temp\E169 (Kopie von C:\Temp\E193f mit dem Bau, der gemessen wird),
# POP-Konto auf 127.0.0.1:11110. Nur Botschaften an gemessene Handles, kein
# Tastendruck (VK_RETURN an die Postfachliste wie in messen-e193.ps1).
#
# WARUM ES DAS GIBT. Gregor am 29.10.2026 an 1.0.127: in File -> Print
# Preview fehlen bei manchen HTML-Mails alle Bilder, farbige Knoepfe sind nur
# Text; im Lesefenster ist dieselbe Mail vollstaendig. Ursache nie gemessen.
#
# TESTDATEN (synthetisch, Adressen auf .invalid), je Merkmal eine Farbe:
#   Testdaten/e169-p1.eml (multipart/related)
#     A cid-Bild rot (#E00000)        B data:-Bild blau (#0040E0)
#     C td bgcolor orange (#FF8000)   D div style background-color gruen (#00A000)
#     E <style>-Klasse gelb (#FFE000) F Textfarbe rot (#C00000, Kontrolle)
#     G table bgcolor lila (#8000C0)
#   Testdaten/e169-p2.eml  H Bild vom Server (cyan, http://127.0.0.1:18169),
#     C Knopf mit CSS-Hintergrund orange
#   Testdaten/e169-p3.eml  H td background= und CSS background-image (cyan,
#     vom Server) - Hintergrundbilder, wie in Werbemails ueblich
#   Bildserver: tools/e169-bildserver.pl liefert Testdaten/e169-cyan.png und
#   protokolliert jede Anfrage nach <Pruefstand>\bildserver.txt.
#
# MESSEN je Mail: oeffnen, maximieren, Lesefenster per PrintWindow als PNG
#   (<Pruefstand>\e169-lesen-<mail>.png), Anzeigedatei E86-Anzeige.htm nach
#   e169-anzeige-<mail>.htm kopieren, File -> Print Preview (0xE109 ans
#   Nachrichtenfenster), Vorschaufenster als PNG (e169-vorschau-<mail>-0.png),
#   WM_CLOSE. Je PNG werden die Farbpixel gezaehlt (Abstand je Kanal <= 40);
#   ein Merkmal gilt als sichtbar ab 1000 Pixeln (Textfarbe F ab 20).
#   Die IE-Einstellung HKCU\...\Internet Explorer\PageSetup\Print_Background
#   liest das Skript nur - vor dem Lauf, WAEHREND die Vorschau offen ist und
#   danach (setzt Eudora sie nur fuer den Druck, muss sie danach wieder so
#   stehen wie vorher). Den Eudora-Schalter PrintBackground (E-169) setzt
#   -Vorbereiten aus <Pruefstand>\e169-schalter.txt (0 oder 1), sonst 0.
#   Faelle: E-169p (C:\Temp\E169, Schalter 0), E-169b (C:\Temp\E169B, 1).
#
# AUSGABE
#   E169 BILD <name> <b>x<h> rot=<n> blau=<n> orange=<n> gruen=<n> gelb=<n> textrot=<n> lila=<n> cyan=<n>
#   E169 ERGEBNIS <mail> lesen=<ABCDEFGH> vorschau=<..> print_background=<wert|fehlt>
#     (Grossbuchstabe = sichtbar, klein = fehlt)
#   E169 ENDE lebt=<0|1>
#
# Kodierung: reines ASCII, kein BOM.
# VORAUSSETZUNG-HANDTEST: keine
#   (POPPort, SSLReceiveUse, SavePassword/Text sind nur fuer den Pruefserver;
#   PrintBackground ist der Gegenstand des Handtests - Gregor stellt ihn im
#   Schritt selbst um, er ist keine Voraussetzung.)
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E169 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$repo = Split-Path -Parent $PSScriptRoot
$cp = [Text.Encoding]::GetEncoding(1252)
$pidDatei = Join-Path $voll 'pop-pruefserver.pid'
$MAILS = @('p1', 'p2', 'p3')
$bildPid = Join-Path $voll 'bildserver.pid'

function PopBeenden {
    if (-not (Test-Path -LiteralPath $pidDatei)) { return }
    $alt = [int](Get-Content -LiteralPath $pidDatei)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "E169 POP-Pruefserver $alt beendet" }
    Remove-Item -LiteralPath $pidDatei -Force
}

if ($Vorbereiten) {
    $ini = Join-Path $md 'Eudora.ini'
    if (-not (Test-Path $ini)) { Write-Host "E169 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    PopBeenden
    foreach ($n in 'Out','In','Trash','Junk') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } | Remove-Item -Force
    }
    $sp = Join-Path $md 'spool'; if (Test-Path $sp) { Get-ChildItem -LiteralPath $sp -File -Recurse | Remove-Item -Force }
    $fp = Join-Path $md 'Filters.pce'; if (Test-Path $fp) { Remove-Item -LiteralPath $fp -Force }
    # E-169: PrintBackground aus <Pruefstand>\e169-schalter.txt (0 oder 1), sonst 0
    $schalter = '0'; $sd = Join-Path $voll 'e169-schalter.txt'; if (Test-Path -LiteralPath $sd) { $schalter = (Get-Content -LiteralPath $sd -TotalCount 1).Trim() }
    Write-Host "E169 Schalter PrintBackground=$schalter"
    $t = $cp.GetString([IO.File]::ReadAllBytes($ini))
    foreach ($kv in @(@('POPPort','11110'), @('SSLReceiveUse','0'), @('SavePassword','1'), @('SavePasswordText','eA=='), @('PrintBackground', $schalter))) {
        $k = $kv[0]; $v = $kv[1]
        if ($t -match ('(?m)^' + $k + '=')) { $t = [regex]::Replace($t, ('(?m)^' + $k + '=[^\r\n]*'), ($k + '=' + $v)) }
        else { $t = $t -replace '(?m)^\[Settings\]\r?\n', ("[Settings]`r`n" + $k + '=' + $v + "`r`n") }
    }
    [IO.File]::WriteAllBytes($ini, $cp.GetBytes($t))
    $belegt = Get-NetTCPConnection -LocalPort 11110 -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Host "E169 FEHLER: Port 11110 ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $a = @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml')
    foreach ($m in $MAILS) { $a += @('--eml', (Join-Path $repo ('Testdaten\e169-' + $m + '.eml'))) }
    $p = Start-Process $perl -ArgumentList $a -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    $alt = $null; if (Test-Path -LiteralPath $bildPid) { $alt = [int](Get-Content -LiteralPath $bildPid) }
    if ($alt) { $q = Get-Process -Id $alt -ErrorAction SilentlyContinue; if ($q -and $q.ProcessName -eq 'perl') { $q.Kill() }; Remove-Item -LiteralPath $bildPid -Force }
    $q = Start-Process $perl -ArgumentList @("$repo\tools\e169-bildserver.pl", '18169', (Join-Path $voll 'bildserver.txt')) -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $bildPid -Value $q.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("E169 vorbereitet: {0}; POP-Pruefserver PID {1} mit {2} Mails" -f $md, $p.Id, $MAILS.Count)
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
        Write-Host ("E193 DIALOG [{0}] {1}" -f (Tx $d), ($texte -join ' | '))
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

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System; using System.Runtime.InteropServices;
public class E169 {
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L, T, R, B; }
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint f);
}
"@
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E169 FEHLER: keine Eudora aus $voll"; PopBeenden; exit 1 }
try { Start-Transcript -LiteralPath (Join-Path $voll 'messen-e169.txt') -Force | Out-Null } catch { }
$pp = $proz[0].Id
$haupt = Oberste $pp | Where-Object { (Kl $_) -eq 'EudoraMainWindow' -and [E193]::IsWindowVisible($_) } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E169 FEHLER: kein Hauptfenster'; PopBeenden; exit 1 }
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
[void](Dialoge $pp)

$FARBEN = [ordered]@{ rot = @(0xE0,0,0); blau = @(0,0x40,0xE0); orange = @(0xFF,0x80,0); gruen = @(0,0xA0,0); gelb = @(0xFF,0xE0,0); textrot = @(0xC0,0,0); lila = @(0x80,0,0xC0); cyan = @(0,0xC0,0xC0) }
$MERKMAL = [ordered]@{ A = 'rot'; B = 'blau'; C = 'orange'; D = 'gruen'; E = 'gelb'; F = 'textrot'; G = 'lila'; H = 'cyan' }   # H steht in p2 fuer das Bild vom Server, in p3 fuer beide Hintergrundbilder (I, J)
function Abbild($h, [string] $name) {
    $r = New-Object E169+RECT; [void][E169]::GetWindowRect($h, [ref]$r)
    $b = $r.R - $r.L; $hh = $r.B - $r.T
    if ($b -le 0 -or $hh -le 0) { Write-Host "E169 BILD $name leer"; return $null }
    $bmp = New-Object System.Drawing.Bitmap $b, $hh
    $g = [System.Drawing.Graphics]::FromImage($bmp); $hdc = $g.GetHdc()
    [void][E169]::PrintWindow($h, $hdc, 2)                      # PW_RENDERFULLCONTENT
    $g.ReleaseHdc($hdc); $g.Dispose()
    $pfad = Join-Path $voll ("e169-$name.png"); $bmp.Save($pfad, [System.Drawing.Imaging.ImageFormat]::Png)
    $zahl = [ordered]@{}; foreach ($k in $FARBEN.Keys) { $zahl[$k] = 0 }
    $daten = $bmp.LockBits((New-Object System.Drawing.Rectangle 0, 0, $b, $hh), 'ReadOnly', 'Format32bppArgb')
    $n = $daten.Stride * $hh; $px = New-Object byte[] $n
    [Runtime.InteropServices.Marshal]::Copy($daten.Scan0, $px, 0, $n); $bmp.UnlockBits($daten); $bmp.Dispose()
    for ($i = 0; $i -lt $n; $i += 4) {
        $bb = $px[$i]; $gg = $px[$i + 1]; $rr = $px[$i + 2]
        foreach ($k in $FARBEN.Keys) { $f = $FARBEN[$k]; if ([Math]::Abs($rr - $f[0]) -le 40 -and [Math]::Abs($gg - $f[1]) -le 40 -and [Math]::Abs($bb - $f[2]) -le 40) { $zahl[$k]++; break } }
    }
    Write-Host ("E169 BILD {0} {1}x{2} {3}" -f $name, $b, $hh, (($zahl.Keys | ForEach-Object { '{0}={1}' -f $_, $zahl[$_] }) -join ' '))
    return $zahl
}
function Merkmale($zahl) {
    if (-not $zahl) { return '-' }
    return -join ($MERKMAL.Keys | ForEach-Object { if ($zahl[$MERKMAL[$_]] -ge $(if ($_ -eq 'F') { 20 } else { 1000 })) { $_ } else { $_.ToLower() } })
}
$REGSETUP = 'HKCU:\Software\Microsoft\Internet Explorer\PageSetup'
function PB() { $v = (Get-ItemProperty -LiteralPath $REGSETUP -Name 'Print_Background' -ErrorAction SilentlyContinue).Print_Background; if ($null -eq $v) { return 'fehlt' } else { return [string]$v } }
function Vorschau($lesen, [string] $name) {
    $vorher = @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) })
    [void][E193]::PostMessageA($lesen, 0x0111, [IntPtr]0xE109, [IntPtr]::Zero)   # ID_FILE_PRINT_PREVIEW
    $neu = @()
    for ($i = 0; $i -lt 20 -and $neu.Count -eq 0; $i++) { Start-Sleep -Milliseconds 500; $neu = @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) -and $vorher -notcontains $_ }) }
    Start-Sleep -Seconds 4
    Write-Host ("E169 WAEHREND-VORSCHAU {0} PageSetup\Print_Background={1}" -f $name, (PB))
    $neu = @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) -and $vorher -notcontains $_ })
    if ($neu.Count -eq 0) { Write-Host "E169 FEHLER: keine Vorschau ($name)"; return $null }
    $zahl = $null; $k = 0
    foreach ($w in $neu) {
        Write-Host ("E169 VORSCHAU-FENSTER {0} klasse={1} titel='{2}'" -f $name, (Kl $w), (Tx $w))
        $z = Abbild $w ("$name-$k"); if ($k -eq 0) { $zahl = $z }; $k++
    }
    foreach ($w in $neu) { [void][E193]::PostMessageA($w, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero) }
    Start-Sleep -Seconds 2
    [void](Dialoge $pp)
    return $zahl
}

$lebt = 1; $erg = [ordered]@{}
$pbVorLauf = PB
Write-Host ("E169 REGISTRY Print_Background={0}" -f (PB))
try {
    Befehl $haupt 32792                                   # ID_MAILBOX_IN
    $in = Aktiv $mdi; $lbIn = Liste $in
    [void][E193]::PostMessageA($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)   # ID_FILE_CHECKMAIL
    for ($i = 0; $i -lt 40 -and (Anzahl $lbIn) -lt $MAILS.Count; $i++) { Start-Sleep -Milliseconds 500 }
    Start-Sleep -Seconds 2; [void](Dialoge $pp); PopBeenden
    $nIn = Anzahl $lbIn
    Write-Host ("E169 In: {0} Mail(s)" -f $nIn)
    Befehl $haupt 33247                                   # ID_EDIT_SORT_SORTBYDATE
    for ($z = 0; $z -lt $nIn; $z++) {
        $in = Aktiv $mdi
        [void][E193]::SendMessageA($lbIn, 0x0185, [IntPtr]0, [IntPtr](-1))
        [void][E193]::SendMessageA($lbIn, 0x0185, [IntPtr]1, [IntPtr]$z)
        [void][E193]::SendMessageA($lbIn, 0x019E, [IntPtr]$z, [IntPtr]0)
        [void][E193]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)
        [void][E193]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
        Start-Sleep -Seconds 4
        $lesen = Aktiv $mdi
        if ($lesen -eq $in) { Write-Host "E169 FEHLER: Zeile $z liess sich nicht oeffnen"; continue }
        $titel = Tx $lesen
        $mi = 'z' + $z; if ($titel -match 'E169 (P\d+)') { $mi = $Matches[1].ToLower() }
        Write-Host ("E169 Lesefenster {0} '{1}'" -f $mi, $titel)
        [void][E193]::SendMessageA($mdi, 0x0225, $lesen, [IntPtr]::Zero)          # WM_MDIMAXIMIZE
        Start-Sleep -Seconds 2
        $l = Merkmale (Abbild $lesen "lesen-$mi")
        $anz = Join-Path $md 'E86-Anzeige.htm'
        if (Test-Path -LiteralPath $anz) { Copy-Item -LiteralPath $anz -Destination (Join-Path $voll "e169-anzeige-$mi.htm") -Force }
        $v = Merkmale (Vorschau $lesen "vorschau-$mi")
        $erg[$mi] = "lesen=$l vorschau=$v"
        [void][E193]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
        Start-Sleep -Seconds 1
        [void](Dialoge $pp)
    }
}
catch { Write-Host ('E169 ABBRUCH: ' + $_.Exception.Message) }
finally {
    PopBeenden
    if (Test-Path -LiteralPath $bildPid) { $q = Get-Process -Id ([int](Get-Content -LiteralPath $bildPid)) -ErrorAction SilentlyContinue; if ($q -and $q.ProcessName -eq 'perl') { $q.Kill() }; Remove-Item -LiteralPath $bildPid -Force }
    foreach ($z in @(Get-Content -LiteralPath (Join-Path $voll 'bildserver.txt') -ErrorAction SilentlyContinue)) { Write-Host $z }
    $lebt = [int](Lebt $pp)
}
foreach ($k in $erg.Keys) { Write-Host ("E169 ERGEBNIS {0} {1} print_background={2}" -f $k, $erg[$k], (PB)) }
$pbNachLauf = PB
Write-Host ("E169 REGISTRY unveraendert={0} vorher={1} nachher={2}" -f [int]($pbVorLauf -eq $pbNachLauf), $pbVorLauf, $pbNachLauf)
Write-Host ("E169 ENDE lebt={0}" -f $lebt)
try { Stop-Transcript | Out-Null } catch { }
