# messen-e193.ps1 - Befund E-193: welche Suche liegt bei Umlauten und Euro
# falsch - "Find Messages" (Suchfenster, mit und ohne Suchindex X1) oder
# "Edit -> Find" im Nachrichtenfenster?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1,
# Fall E-193p), Pruefstand C:\Temp\E193 (Kopie von C:\Temp\E128, 7.2.2.132,
# POP-Konto auf 127.0.0.1:11110). Nur Botschaften an gemessene Handles, kein
# Tastendruck (das VK_RETURN an die Postfachliste ist eine Botschaft an ein
# gemessenes Handle, wie in messen-e194.ps1).
#
# WARUM ES DAS GIBT. Gregor am 01.11.2026 an 7.2.1.130: Find Messages fand
# fuer "EUR-Zeichen" und fuer "ae" (je als ein Zeichen) dieselben 110 Mails,
# fuer "oeft" (mit o-Umlaut) 4 - und in der jeweils ersten fand Edit -> Find
# das Wort nicht. Welche Suche falsch ist, war offen. Gregor am 03.11.2026:
# "erst nachstellen, dann entscheiden".
#
# TESTDATEN (Testdaten/e193-m0..m7-*.eml, anonym, Adressen auf .invalid),
# je Mail ein eigenes Wort, damit jeder Treffer zuzuordnen ist:
#   m0 nur ASCII ("Zebrafink")                 - Gegenprobe
#   m1 text/plain ISO-8859-1 8bit ("Gruesse", "Kraeuterkueche")
#   m2 text/plain UTF-8 quoted-printable ("Kaese", EUR, "Stueck")
#   m3 text/plain UTF-8 8bit ("Moehre", "oefter", "suess")
#   m4 Umlaut NUR im Betreff, UTF-8 encoded-word ("Zwiebeloel")
#   m5 text/html, Umlaute und EUR NUR als Entitaeten (&auml; &uuml; &euro;)
#   m6 text/html UTF-8 quoted-printable ("Bruehe")
#   m7 text/plain windows-1252 8bit (EUR als 0x80, "Aepfel" gross)
#   m8 nur ASCII mit "oft" - findet die Suche nach "oe"+"ft" auch "oft"?
#      (Gregors 4 Treffer fuer "oeft", in deren erstem das Wort fehlte)
# (Umlaute hier als ae/oe/ue, das Skript ist reines ASCII; die Suchwoerter
# baut es aus Zeichencodes.)
#
# ABLAUF
#   -Vorbereiten: Postfaecher In/Out/Trash weg, UseIndexedSearch=1,
#     FindMsgsCriteria1=Anywhere;contains;, POP-Pruefserver
#     (tools/anhang-pruefdaten.pl --pop --nur-eml) mit den acht Mails.
#   Messen:
#     1. Post holen (32772), POP-Server beenden, In.mbx lesen: in welcher
#        Form steht jedes Wort dort (latin1 / utf8 / qp / entitaet / fehlt)?
#     2. warten, bis eudora.log nach dem Abruf "Stopping search indexing"
#        meldet (der Index hat die neuen Mails aufgenommen).
#     3. Find Messages: Suchfenster aus In (32778), je Suchwort WM_SETTEXT in
#        IDC_CRITERIA_TEXT_EDIT_1 (7645), BN_CLICKED 1017, Treffer aus der
#        Ergebnisliste (8172) per LVM_GETITEMTEXTA im Speicher von Eudora
#        gelesen und den Mails m0..m7 zugeordnet. Einmal mit Index (Vorgabe),
#        dann mit WM_COMMAND 4900 (ID_SEARCH_OPTIONS_BTNMENU_USE_INDEXED_SEARCH)
#        ohne Index. Positivprobe: "Powered by X1" (8175) sichtbar.
#     4. Edit -> Find: je Mail das Nachrichtenfenster oeffnen (In nach Datum
#        sortiert, Zeile i = Mail mi, gegengeprueft am Fenstertitel) und
#        WM_FINDREPLACE (RegisterWindowMessage "commdlg_FindReplace") mit
#        einer FINDREPLACE im Speicher von Eudora an das Nachrichtenfenster
#        schicken - derselbe Handler, den der Dialog ueber QCFindMgr erreicht
#        (CReadMessageFrame::OnFindReplace). Rueckgabe EuFIND_OK=0,
#        EuFIND_ERROR=1, EuFIND_NOTFOUND=2 (QCFindMgr.h). Der Dialog "not
#        found" entfaellt so; je Wort ein frisches Fenster.
#
# AUSGABE
#   E193 MBX m<i> <wort>=<form>
#   E193 SUCHE index|ohne <wort> soll=<mails> ist=<mails> -> richtig|FALSCH
#   E193 FENSTER m<i> <wort> soll=ja|nein ist=gefunden|nicht|fehler -> richtig|FALSCH
#   E193 ERGEBNIS index-falsch=<n>/<m> ohne-falsch=<n>/<m> fenster-falsch=<n>/<m> x1=<0|1> mails=<n> lebt=<0|1>
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E193 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$repo = Split-Path -Parent $PSScriptRoot
$cp = [Text.Encoding]::GetEncoding(1252)
$pidDatei = Join-Path $voll 'pop-pruefserver.pid'
$MAILS = @('m0-ascii', 'm1-latin1-8bit', 'm2-utf8-qp', 'm3-utf8-8bit', 'm4-betreff-utf8', 'm5-html-entitaet', 'm6-html-utf8-qp', 'm7-cp1252-euro', 'm8-oft-ohne-umlaut')

function C([int[]] $codes) { return -join ($codes | ForEach-Object { [char]$_ }) }
$ae = C 0xE4; $oe = C 0xF6; $ue = C 0xFC; $sz = C 0xDF; $EUR = C 0x20AC
# Suchwort -> Mails, die es (ohne Gross/klein) enthalten. Von Hand aus den Testdaten.
$WOERTER = [ordered]@{
    'Zebrafink'                  = @(0)
    ('Gr' + $ue + $sz + 'e')     = @(1)
    ('K' + $ae + 'se')           = @(2)
    $EUR                         = @(2, 5, 7)
    $ae                          = @(1, 2, 5, 7)
    ('M' + $oe + 'hre')          = @(3)
    ($oe + 'ft')                 = @(3)
    ('Zwiebel' + $oe + 'l')      = @(4)
    ('Sp' + $ae + 'tzle')        = @(5)
    ('Br' + $ue + 'he')          = @(6)
    ((C 0xC4) + 'pfel')               = @(7)
}
# Edit -> Find je Mail: ihre eigenen Woerter, dazu Zebrafink als Gegenprobe.
function Sichtbar([string] $s) { return -join ($s.ToCharArray() | ForEach-Object { if ([int]$_ -lt 128) { $_ } else { '<' + ('{0:X}' -f [int]$_) + '>' } }) }

function PopBeenden {
    if (-not (Test-Path -LiteralPath $pidDatei)) { return }
    $alt = [int](Get-Content -LiteralPath $pidDatei)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "E193 POP-Pruefserver $alt beendet" }
    Remove-Item -LiteralPath $pidDatei -Force
}

if ($Vorbereiten) {
    $ini = Join-Path $md 'Eudora.ini'
    if (-not (Test-Path $ini)) { Write-Host "E193 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    PopBeenden
    foreach ($n in 'Out','In','Trash','Junk') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } | Remove-Item -Force
    }
    Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^(lmos\.dat.*|E86-Anzeige\.htm)$' } | Remove-Item -Force
    # Sonst kennt das POP-Konto die Mails vom vorigen Lauf (spool\lmos.dat) und holt
    # nur neue - gemessen 03.11.2026: der zweite Lauf holte 1 von 9.
    $sp = Join-Path $md 'spool'; if (Test-Path $sp) { Get-ChildItem -LiteralPath $sp -File -Recurse | Remove-Item -Force }
    $fp = Join-Path $md 'Filters.pce'; if (Test-Path $fp) { Remove-Item -LiteralPath $fp -Force }
    $t = $cp.GetString([IO.File]::ReadAllBytes($ini))
    foreach ($kv in @(@('POPPort','11110'), @('SSLReceiveUse','0'), @('SavePassword','1'), @('SavePasswordText','eA=='),
                      @('UseIndexedSearch','1'), @('FindMsgsCriteriaCount','1'), @('FindMsgsCriteria1','Anywhere;contains;'),
                      @('IncludeHeaders','0'), @('GuessParagraphs','0'))) {
        $k = $kv[0]; $v = $kv[1]
        if ($t -match ('(?m)^' + $k + '=')) { $t = [regex]::Replace($t, ('(?m)^' + $k + '=[^\r\n]*'), ($k + '=' + $v)) }
        else { $t = $t -replace '(?m)^\[Settings\]\r?\n', ("[Settings]`r`n" + $k + '=' + $v + "`r`n") }
    }
    [IO.File]::WriteAllBytes($ini, $cp.GetBytes($t))
    $belegt = Get-NetTCPConnection -LocalPort 11110 -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Host "E193 FEHLER: Port 11110 ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $a = @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml')
    foreach ($m in $MAILS) { $a += @('--eml', (Join-Path $repo ('Testdaten\e193-' + $m + '.eml'))) }
    $p = Start-Process $perl -ArgumentList $a -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("E193 vorbereitet: {0}; POP-Pruefserver PID {1} mit {2} Mails" -f $md, $p.Id, $MAILS.Count)
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

$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E193 FEHLER: keine Eudora aus $voll"; PopBeenden; exit 1 }
try { Start-Transcript -LiteralPath (Join-Path $voll 'messen-e193.txt') -Force | Out-Null } catch { }
$pp = $proz[0].Id
$haupt = Oberste $pp | Where-Object { (Kl $_) -eq 'EudoraMainWindow' -and [E193]::IsWindowVisible($_) } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E193 FEHLER: kein Hauptfenster'; PopBeenden; exit 1 }
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
[void](Dialoge $pp)
$hp = [E193]::OpenProcess(0x0438, $false, [uint32]$pp)
$fern = [E193]::VirtualAllocEx($hp, [IntPtr]::Zero, 8192, 0x3000, 0x04)
$WM_FINDREPLACE = [E193]::RegisterWindowMessageA('commdlg_FindReplace')
function Schreibe([int] $versatz, [byte[]] $b) { $w = [IntPtr]::Zero; [void][E193]::WriteProcessMemory($hp, [IntPtr]($fern.ToInt64() + $versatz), $b, [uint32]$b.Length, [ref]$w) }
function Lies([int] $versatz, [int] $n) { $b = New-Object byte[] $n; $w = [IntPtr]::Zero; [void][E193]::ReadProcessMemory($hp, [IntPtr]($fern.ToInt64() + $versatz), $b, [uint32]$n, [ref]$w); return ,$b }
function I32([int] $v) { return [BitConverter]::GetBytes([int32]$v) }

$lebt = 1
$x1 = 0
$falsch = @{ 'index' = 0; 'ohne' = 0; 'fenster' = 0 }; $gesamt = @{ 'index' = 0; 'ohne' = 0; 'fenster' = 0 }
try {
    # --- 1. Post holen ----------------------------------------------------------
    Befehl $haupt 32792                                   # ID_MAILBOX_IN
    $in = Aktiv $mdi; $lbIn = Liste $in
    $vorher = Anzahl $lbIn
    $zeitAbruf = Get-Date
    [void][E193]::PostMessageA($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)   # ID_FILE_CHECKMAIL
    for ($i = 0; $i -lt 60 -and (Anzahl $lbIn) -lt ($vorher + $MAILS.Count); $i++) { Start-Sleep -Milliseconds 500; if (($i % 6) -eq 5) { [void](Dialoge $pp) } }
    Start-Sleep -Seconds 2
    [void](Dialoge $pp)
    PopBeenden
    $nIn = Anzahl $lbIn
    Write-Host ("E193 In: vorher={0} nachher={1}" -f $vorher, $nIn)
    if ($nIn -lt $MAILS.Count) { Write-Host 'E193 FEHLER: nicht alle Mails abgeholt' }

    # In.mbx: in welcher Form steht jedes Wort?
    $mbx = ''; $mp = Join-Path $md 'In.mbx'; if (Test-Path $mp) { $mbx = $cp.GetString([IO.File]::ReadAllBytes($mp)) }
    $teile = [regex]::Split($mbx, '(?m)^From \?\?\?@\?\?\? ')
    function Form([string] $teil, [string] $wort) {
        $lat = $cp.GetString($cp.GetBytes($wort))
        $utf = $cp.GetString([Text.Encoding]::UTF8.GetBytes($wort))
        $qp = -join ([Text.Encoding]::UTF8.GetBytes($wort) | ForEach-Object { if ($_ -lt 128) { [char]$_ } else { '={0:X2}' -f $_ } })
        $ent = $wort.Replace($ae, '&auml;').Replace($ue, '&uuml;').Replace($oe, '&ouml;').Replace($EUR, '&euro;')
        $f = @()
        if ($teil.IndexOf($lat, [StringComparison]::OrdinalIgnoreCase) -ge 0) { $f += 'latin1' }
        if ($utf -ne $lat -and $teil.IndexOf($utf, [StringComparison]::OrdinalIgnoreCase) -ge 0) { $f += 'utf8' }
        if ($qp -ne $lat -and $teil.IndexOf($qp, [StringComparison]::OrdinalIgnoreCase) -ge 0) { $f += 'qp' }
        if ($ent -ne $lat -and $teil.IndexOf($ent, [StringComparison]::OrdinalIgnoreCase) -ge 0) { $f += 'entitaet' }
        if ($f.Count -eq 0) { return 'fehlt' }
        return ($f -join '+')
    }
    foreach ($t in $teile) {
        if ($t -notmatch 'e193-m(\d)@') { continue }
        $i = [int]$Matches[1]
        foreach ($w in $WOERTER.Keys) { if ($WOERTER[$w] -contains $i) { Write-Host ("E193 MBX m{0} {1}={2}" -f $i, (Sichtbar $w), (Form $t $w)) } }
    }

    # --- 2. Index abwarten ------------------------------------------------------
    $start = (LogZeilen).Count
    $indexFertig = 0
    for ($i = 0; $i -lt 60; $i++) {
        Start-Sleep -Seconds 2
        $neu = @(LogZeilen | Select-Object -Skip $start)
        if (@($neu | Where-Object { $_ -match 'Stopping search indexing' }).Count -gt 0) { $indexFertig = 1; Start-Sleep -Seconds 3; break }
    }
    Write-Host "E193 Index nach dem Abruf fertig=$indexFertig"

    # --- 3. Find Messages ---------------------------------------------------------
    Befehl $haupt 32792
    $in = Aktiv $mdi
    Befehl $haupt 32778                                      # ID_EDIT_FIND_FINDMSG aus In
    $such = $null; $knopf = $null
    for ($i = 0; $i -lt 20 -and -not $knopf; $i++) { Start-Sleep -Milliseconds 500; $such = Aktiv $mdi; if ($such -ne $in) { $knopf = NachID $such 1017 } }
    if (-not $knopf) { Write-Host 'E193 FEHLER: kein Suchfenster'; throw 'kein Suchfenster' }
    $ansicht = [E193]::GetParent($knopf)
    $feld = NachID $such 7645; $liste = NachID $such 8172
    $x1st = NachID $such 8175
    function TrefferLesen() {
        $n = [int][E193]::SendMessageA($liste, 0x1004, [IntPtr]::Zero, [IntPtr]::Zero)   # LVM_GETITEMCOUNT
        $gef = @()
        for ($r = 0; $r -lt $n; $r++) {
            $txt = ''
            for ($s = 0; $s -lt 6; $s++) {
                $lv = New-Object byte[] 60
                [Array]::Copy((I32 1), 0, $lv, 0, 4)                       # LVIF_TEXT
                [Array]::Copy((I32 $r), 0, $lv, 4, 4)
                [Array]::Copy((I32 $s), 0, $lv, 8, 4)
                [Array]::Copy((I32 ([int]($fern.ToInt64() + 512))), 0, $lv, 20, 4)
                [Array]::Copy((I32 500), 0, $lv, 24, 4)
                Schreibe 0 $lv
                Schreibe 512 (New-Object byte[] 500)
                $res = [IntPtr]::Zero
                [void][E193]::SendMessageTimeoutA($liste, 0x102D, [IntPtr]$r, $fern, 2, 3000, [ref]$res)   # LVM_GETITEMTEXTA
                $b = Lies 512 500; $e = [Array]::IndexOf($b, [byte]0); if ($e -lt 0) { $e = 500 }
                $txt += ' | ' + $cp.GetString($b, 0, $e)
            }
            if ($txt -match 'E193 M(\d)') { $gef += [int]$Matches[1] } else { $gef += -1 }
        }
        return ,$gef
    }
    function Suche([string] $art, [string] $wort) {
        $bytes = $cp.GetBytes($wort + [char]0)
        [void][E193]::SendText($feld, 0x000C, [IntPtr]::Zero, $bytes)   # WM_SETTEXT
        Start-Sleep -Milliseconds 400
        [void][E193]::PostMessageA($ansicht, 0x0111, [IntPtr]1017, $knopf)
        $treffer = -1; $gleich = 0
        for ($i = 0; $i -lt 40 -and $gleich -lt 4; $i++) {
            Start-Sleep -Milliseconds 400
            $n = [int][E193]::SendMessageA($liste, 0x1004, [IntPtr]::Zero, [IntPtr]::Zero)
            if ($n -eq $treffer -and [E193]::IsWindowEnabled($knopf)) { $gleich++ } else { $gleich = 0 }
            $treffer = $n
        }
        [void](Dialoge $pp)
        $gef = TrefferLesen
        $ist = @($gef | Where-Object { $_ -ge 0 } | Sort-Object -Unique)
        $fremd = @($gef | Where-Object { $_ -lt 0 }).Count
        $soll = @($WOERTER[$wort] | Sort-Object)
        $ok = (($ist -join ',') -eq ($soll -join ',')) -and $fremd -eq 0
        $script:gesamt[$art]++; if (-not $ok) { $script:falsch[$art]++ }
        Write-Host ("E193 SUCHE {0} {1} soll={2} ist={3} andere={4} treffer={5} -> {6}" -f $art, (Sichtbar $wort), ($soll -join ','), ($(if ($ist.Count) { $ist -join ',' } else { '-' })), $fremd, $gef.Count, $(if ($ok) { 'richtig' } else { 'FALSCH' }))
    }
    $x1 = [int]($x1st -and [E193]::IsWindowVisible($x1st))
    Write-Host "E193 Suchfenster: X1 sichtbar=$x1"
    foreach ($w in $WOERTER.Keys) { Suche 'index' $w }
    [void][E193]::PostMessageA($ansicht, 0x0111, [IntPtr]4900, [IntPtr]::Zero)   # Indexsuche aus
    Start-Sleep -Seconds 1
    $x1b = [int]($x1st -and [E193]::IsWindowVisible($x1st))
    Write-Host "E193 Suchfenster ohne Index: X1 sichtbar=$x1b"
    foreach ($w in $WOERTER.Keys) { Suche 'ohne' $w }
    [void][E193]::PostMessageA($such, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
    Start-Sleep -Seconds 1
    [void](Dialoge $pp)

    # --- 4. Edit -> Find im Nachrichtenfenster -------------------------------------
    Befehl $haupt 32792
    $in = Aktiv $mdi; $lbIn = Liste $in
    Befehl $haupt 33247                                      # ID_EDIT_SORT_SORTBYDATE
    $n = Anzahl $lbIn
    for ($z = 0; $z -lt $n; $z++) {
        # Nach Datum aufsteigend ist Zeile z = Mail mz (Datum 10:00 + z Stunden);
        # gegengeprueft wird an jedem Fenstertitel. Je Zeile ihre eigenen Woerter,
        # dazu Zebrafink an jeder (soll nur an m0).
        $tests = @($WOERTER.Keys | Where-Object { $WOERTER[$_] -contains $z })
        if ($tests -notcontains 'Zebrafink') { $tests += 'Zebrafink' }
        foreach ($w in $tests) {
            $in = Aktiv $mdi
            [void][E193]::SendMessageA($lbIn, 0x0185, [IntPtr]0, [IntPtr](-1))
            [void][E193]::SendMessageA($lbIn, 0x0185, [IntPtr]1, [IntPtr]$z)
            [void][E193]::SendMessageA($lbIn, 0x019E, [IntPtr]$z, [IntPtr]0)
            [void][E193]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)
            [void][E193]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
            Start-Sleep -Milliseconds 1800
            $lesen = Aktiv $mdi
            if ($lesen -eq $in) { Write-Host "E193 FEHLER: Zeile $z liess sich nicht oeffnen"; break }
            $titel = Tx $lesen
            $mi = -1; if ($titel -match 'E193 M(\d)') { $mi = [int]$Matches[1] }
            $soll = ($WOERTER.Contains($w) -and $WOERTER[$w] -contains $mi)
            if ($mi -ne $z) { Write-Host "E193 HINWEIS: Zeile $z zeigt m$mi (Titel '$titel')" }
            if ($mi -ge 0) {
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
                $ok = ($soll -and $ist -eq 'gefunden') -or (-not $soll -and $ist -eq 'nicht')
                $gesamt['fenster']++; if (-not $ok) { $falsch['fenster']++ }
                Write-Host ("E193 FENSTER m{0} {1} soll={2} ist={3} -> {4}" -f $mi, (Sichtbar $w), $(if ($soll) { 'ja' } else { 'nein' }), $ist, $(if ($ok) { 'richtig' } else { 'FALSCH' }))
            }
            [void][E193]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
            Start-Sleep -Milliseconds 700
            [void](Dialoge $pp)
        }
    }
}
catch { Write-Host ('E193 ABBRUCH: ' + $_.Exception.Message) }
finally {
    PopBeenden
    [void][E193]::VirtualFreeEx($hp, $fern, 0, 0x8000)
    [void][E193]::CloseHandle($hp)
    $lebt = [int](Lebt $pp)
}
Write-Host ("E193 ERGEBNIS index-falsch={0}/{1} ohne-falsch={2}/{3} fenster-falsch={4}/{5} x1={6} mails={7} lebt={8}" -f `
    $falsch['index'], $gesamt['index'], $falsch['ohne'], $gesamt['ohne'], $falsch['fenster'], $gesamt['fenster'], $x1, $nIn, $lebt)
try { Stop-Transcript | Out-Null } catch { }
