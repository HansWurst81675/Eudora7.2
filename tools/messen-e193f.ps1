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
# geleiteten Rundmail meldet Edit -> Find "not found" fuer ein Wort mit
# u-Umlaut, das in ihrer Fusszeile steht. Vermutet waren Emoji ausserhalb der
# BMP, ein inneres meta charset=utf-8 und weiche Trennstriche (0xAD) - alle
# am 05.11.2026 widerlegt (Runden direkt/dialog: alles gefunden). Gemessen
# ist (Runde suchweg): wird die Mail per Doppelklick aus dem Ergebnis von
# Find Messages geoeffnet, markiert Eudora den Treffer schon
# (SearchView.cpp DoFindFirst nach pSum->Display, Original), setzt das
# Lesezeichen dahinter (TridentView.cpp DoFindFirst getBookmark), und
# Edit -> Find sucht ueber DoFindNext AB dort - kommt das Wort nur einmal
# vor, meldet es "not found". Gregor 05.11.2026, Variante A: dann einmal von
# oben weitersuchen und den Treffer markieren und sichtbar machen.
#
# TESTDATEN (Testdaten/e193-f1..f14.eml, synthetisch, windows-1252 8bit,
# Adressen auf .invalid). "Amsel" vorn, "Geschaeftsfuehrung" (mit Umlauten)
# und dahinter "Kolibri" in der Fusszeile:
#   f1 Outlook-Aufbau, Emoji (&#128205; &#128197;) VOR der Fusszeile, inneres meta
#   f2 Outlook, nur Emoji          f3 Outlook, nur inneres meta
#   f4 Outlook, ohne beides        f5 Outlook, Emoji NACH dem Wort, inneres meta
#   f6 Outlook, BMP-Zeichen (&#9733; &#9742;) statt Emoji, inneres meta
#   f7 einfach, Emoji vor          f8 einfach, ohne Emoji
#   f9 0xAD roh vor dem Wort       f10 &shy; vor dem Wort
#   f11 0xAD hinter dem Wort       f12 zwei 0xAD vor dem Wort
#   f13 0xAD, Fusszeile ohne Umlautwort (Kolibri/Gesch/Amsel)
#   f14 Wort ZWEIMAL, oben und unten (Gegenprobe zum Suchweg)
# Nur am Pruefstand: <Pruefstand>\privat\e193-g*.eml (echte Anzeigedatei).
#
# RUNDEN (<Pruefstand>\runden.txt, Vorgabe "suchweg,direkt,dialog,klick"):
#   suchweg  Find Messages mit dem Umlautwort, jede Ergebniszeile per
#            Doppelklick oeffnen (Botschaften an die Liste), Edit -> Find
#            (32776) mit demselben Wort, Weitersuchen. Faelle ohne, klick
#            (WM_LBUTTONDOWN/UP in die Anzeige), scroll (dazu WM_MOUSEWHEEL).
#            Bei "not found" ein zweites Weitersuchen (zweiter=).
#   direkt   Mail aus In oeffnen, WM_FINDREPLACE ans Nachrichtenfenster.
#   dialog   Mail aus In oeffnen, Edit -> Find, Weitersuchen.
#   klick    wie dialog, vorher Klick in die Anzeige.
#
# AUSGABE
#   E193F SUCHWEG <fall> <mail> ist=gefunden|nicht zweiter=<..> nach-oeffnen:fokus=.. vor-suche:fokus=..
#   E193F ERGEBNIS suchweg-<fall> f1=<0|1> ... (1 = beim ERSTEN Weitersuchen gefunden)
#   E193F <runde> <mail> <wort> ist=.. -> richtig|FALSCH
#   E193F ERGEBNIS <runde> f1=<0|1> ... negativ-falsch=<n>
#   E193F ENDE mails=<n> lebt=<0|1>
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
$MAILS = @(1..14 | ForEach-Object { 'f' + $_ })
# Nur am Pruefstand, nie im Repo: <Pruefstand>\privat\e193-g*.eml (etwa eine
# echte Anzeigedatei als Mail verpackt). Fehlt der Ordner, laeuft alles ohne.
$privat = @(Get-ChildItem -LiteralPath (Join-Path $voll 'privat') -Filter 'e193-g*.eml' -File -ErrorAction SilentlyContinue)
$script:anzahlMails = $MAILS.Count + $privat.Count
# Runden: direkt (WM_FINDREPLACE), dialog (Edit -> Find), klick (Dialog nach
# Klick in die Anzeige), voll (direkt mit allen fuenf Woertern). Vorgabe aus
# <Pruefstand>\runden.txt, sonst "suchweg,direkt,dialog,klick" (suchweg = Gregors Weg ueber Find Messages).
$Runden = 'suchweg,direkt,dialog,klick'
$rd = Join-Path $voll 'runden.txt'; if (Test-Path -LiteralPath $rd) { $Runden = (Get-Content -LiteralPath $rd -TotalCount 1).Trim() }
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
    foreach ($g in $privat) { $a += @('--eml', $g.FullName) }
    $p = Start-Process $perl -ArgumentList $a -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("E193F vorbereitet: {0}; POP-Pruefserver PID {1} mit {2} Mails" -f $md, $p.Id, $script:anzahlMails)
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


# --- Gregors Weg: Mail per Doppelklick aus dem Ergebnis von Find Messages ----
# Gregor am 05.11.2026 an 7.2.2.134: Mail per Doppelklick aus Find Messages
# geoeffnet, ohne Klick Ctrl+Shift+F (ID_EDIT_FIND_FINDTEXT) -> not found;
# "wenn ich in die mail klicke und nach unten scrolle, dann findet er
# 'fuehrung' ploetzlich". Je Ergebniszeile drei Faelle: ohne Klick, mit Klick
# in die Anzeige, mit Klick und Scrollen. Vor dem Suchen wird der Fokus des
# Eudora-Threads protokolliert (GetGUIThreadInfo), weil der Suchdialog sein
# Ziel beim Aktivieren ueber GetFocus waehlt (QCFindMgr::UpdateFindFocus).
Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E193G {
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L, T, R, B; }
  [StructLayout(LayoutKind.Sequential)] public struct GUITHREADINFO {
    public int cbSize; public int flags; public IntPtr hwndActive; public IntPtr hwndFocus; public IntPtr hwndCapture;
    public IntPtr hwndMenuOwner; public IntPtr hwndMoveSize; public IntPtr hwndCaret; public RECT rcCaret; }
  [DllImport("user32.dll")] public static extern bool GetGUIThreadInfo(uint tid, ref GUITHREADINFO g);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  public static string Fokus(IntPtr anyWnd) {
    uint pid; uint tid = GetWindowThreadProcessId(anyWnd, out pid);
    GUITHREADINFO g = new GUITHREADINFO(); g.cbSize = Marshal.SizeOf(typeof(GUITHREADINFO));
    if (!GetGUIThreadInfo(tid, ref g)) return "?";
    return g.hwndFocus.ToInt64().ToString() + "|" + g.hwndActive.ToInt64().ToString();
  }
}
"@
function FokusKette() {
    $f = [E193G]::Fokus($haupt)
    if ($f -eq '?') { return 'fokus=?' }
    $teile = $f.Split('|'); $h = [IntPtr][long]$teile[0]
    if ($h -eq [IntPtr]::Zero) { return 'fokus=keiner' }
    $kette = @(); $x = $h
    for ($i = 0; $i -lt 5 -and $x -ne [IntPtr]::Zero; $i++) {
        $t = Tx $x; if ($t.Length -gt 24) { $t = $t.Substring(0, 24) }
        $kette += ('{0}#{1}' -f (Kl $x), [E193]::GetDlgCtrlID($x)) + $(if ($t) { "'" + $t + "'" } else { '' })
        $x = [E193]::GetParent($x)
    }
    return ('fokus=' + ($kette -join ' < '))
}
function SuchfensterRunde([string] $wort) {
    Befehl $haupt 32792
    $in = Aktiv $mdi
    Befehl $haupt 32778                                      # ID_EDIT_FIND_FINDMSG aus In
    $such = $null; $knopf = $null
    for ($i = 0; $i -lt 20 -and -not $knopf; $i++) { Start-Sleep -Milliseconds 500; $such = Aktiv $mdi; if ($such -ne $in) { $knopf = NachID $such 1017 } }
    if (-not $knopf) { Write-Host 'E193F FEHLER: kein Suchfenster'; return }
    $ansicht = [E193]::GetParent($knopf)
    $feld = NachID $such 7645; $liste = NachID $such 8172
    [void][E193]::SendText($feld, 0x000C, [IntPtr]::Zero, $cp.GetBytes($wort + [char]0))
    Start-Sleep -Milliseconds 400
    [void][E193]::PostMessageA($ansicht, 0x0111, [IntPtr]1017, $knopf)
    $treffer = -1; $gleich = 0
    for ($i = 0; $i -lt 60 -and $gleich -lt 4; $i++) {
        Start-Sleep -Milliseconds 400
        $n = [int][E193]::SendMessageA($liste, 0x1004, [IntPtr]::Zero, [IntPtr]::Zero)
        if ($n -eq $treffer -and [E193]::IsWindowEnabled($knopf)) { $gleich++ } else { $gleich = 0 }
        $treffer = $n
    }
    [void](Dialoge $pp)
    Write-Host ("E193F SUCHFENSTER {0} treffer={1}" -f (Sichtbar $wort), $treffer)
    $erg = [ordered]@{}
    for ($r = 0; $r -lt $treffer; $r++) {
        foreach ($fall in @('ohne', 'klick', 'scroll')) {
            # Zeile r markieren und per Doppelklick oeffnen (Botschaften an die Liste)
            $lv = New-Object byte[] 60
            [Array]::Copy((I32 8), 0, $lv, 0, 4)                      # LVIF_STATE
            [Array]::Copy((I32 $r), 0, $lv, 4, 4)
            [Array]::Copy((I32 3), 0, $lv, 12, 4)                     # LVIS_FOCUSED|LVIS_SELECTED
            [Array]::Copy((I32 3), 0, $lv, 16, 4)
            Schreibe 0 $lv
            $lv0 = New-Object byte[] 60; [Array]::Copy((I32 8), 0, $lv0, 0, 4); [Array]::Copy((I32 3), 0, $lv0, 16, 4)   # LVIF_STATE, Maske 3, Zustand 0
            Schreibe 0 $lv0
            [void][E193]::SendMessageA($liste, 0x102B, [IntPtr](-1), $fern)              # alle abwaehlen
            Schreibe 0 $lv
            [void][E193]::SendMessageA($liste, 0x102B, [IntPtr]$r, $fern)              # LVM_SETITEMSTATE
            $rc = New-Object byte[] 16; Schreibe 4096 $rc
            [void][E193]::SendMessageA($liste, 0x100E, [IntPtr]$r, [IntPtr]($fern.ToInt64() + 4096))   # LVM_GETITEMRECT (LVIR_BOUNDS=0)
            $b = New-Object byte[] 16; $w0 = [IntPtr]::Zero; [void][E193]::ReadProcessMemory($hp, [IntPtr]($fern.ToInt64() + 4096), $b, 16, [ref]$w0)
            $x = [BitConverter]::ToInt32($b, 0) + 40; $y = ([BitConverter]::ToInt32($b, 4) + [BitConverter]::ToInt32($b, 12)) / 2
            $lp = [IntPtr](([int]$y -shl 16) -bor [int]$x)
            $vorher = Aktiv $mdi
            [void][E193G]::PostMessageA($liste, 0x0201, [IntPtr]1, $lp)
            [void][E193G]::PostMessageA($liste, 0x0202, [IntPtr]0, $lp)
            [void][E193G]::PostMessageA($liste, 0x0203, [IntPtr]1, $lp)
            [void][E193G]::PostMessageA($liste, 0x0202, [IntPtr]0, $lp)
            $lesen = $null
            for ($i = 0; $i -lt 15; $i++) { Start-Sleep -Milliseconds 400; $a = Aktiv $mdi; if ($a -ne $vorher -and $a -ne $such) { $lesen = $a; break } }
            if (-not $lesen) { Write-Host "E193F FEHLER: Ergebniszeile $r oeffnete kein Fenster ($fall)"; [void](Dialoge $pp); break }
            Start-Sleep -Milliseconds 1500
            $titel = Tx $lesen
            $mi = ''; if ($titel -match 'E193F ([FG]\d+)') { $mi = $Matches[1].ToLower() }
            $f0 = FokusKette
            if ($fall -ne 'ohne') {
                $ie = Kinder $lesen | Where-Object { (Kl $_) -eq 'Internet Explorer_Server' -and [E193]::IsWindowVisible($_) } | Select-Object -First 1
                if ($ie) {
                    $lpk = [IntPtr]((120 -shl 16) -bor 200)
                    [void][E193G]::PostMessageA($ie, 0x0201, [IntPtr]1, $lpk)
                    [void][E193G]::PostMessageA($ie, 0x0202, [IntPtr]0, $lpk)
                    Start-Sleep -Milliseconds 500
                    if ($fall -eq 'scroll') {
                        $rr = New-Object E193G+RECT; [void][E193G]::GetWindowRect($ie, [ref]$rr)
                        $sp = [IntPtr]((([int](($rr.T + $rr.B) / 2)) -shl 16) -bor [int](($rr.L + $rr.R) / 2))
                        for ($k = 0; $k -lt 25; $k++) { [void][E193G]::PostMessageA($ie, 0x020A, [IntPtr]((-120) -shl 16), $sp); Start-Sleep -Milliseconds 60 }
                        Start-Sleep -Milliseconds 500
                    }
                } else { Write-Host "E193F HINWEIS: kein Internet Explorer_Server in $mi" }
            }
            $f1 = FokusKette
            Befehl $haupt 32776                                  # ID_EDIT_FIND_FINDTEXT (Ctrl+Shift+F)
            $dlg = $null; $edt = $null
            foreach ($d in @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) -and (Kl $_) -eq '#32770' })) { $e = NachID $d 1152; if ($e) { $dlg = $d; $edt = $e; break } }
            $ist = 'fehler-keindialog'
            if ($dlg) {
                [void][E193]::SendText($edt, 0x000C, [IntPtr]::Zero, $cp.GetBytes($wort + [char]0))
                Start-Sleep -Milliseconds 300
                [void][E193]::PostMessageA($dlg, 0x0111, [IntPtr]1, (NachID $dlg 1))
                Start-Sleep -Milliseconds 1500
                $nf = 0
                foreach ($d in @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) -and (Kl $_) -eq '#32770' -and $_ -ne $dlg })) {
                    $texte = @(Kinder $d | ForEach-Object { Tx $_ } | Where-Object { $_ })
                    if (($texte -join ' ') -match 'not found') { $nf = 1 } else { Write-Host ("E193F DIALOG [{0}] {1}" -f (Tx $d), ($texte -join ' | ')) }
                    [void][E193]::PostMessageA($d, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
                }
                Start-Sleep -Milliseconds 400
                $ist = $(if ($nf) { 'nicht' } else { 'gefunden' })
                # Ein zweites Weitersuchen im selben Dialog: nach "not found" ist das
                # Lesezeichen geloescht (TridentView.cpp DoFindNext), die Suche beginnt
                # wieder oben. So zeigt sich, ob nur die Startposition schuld ist.
                $zweiter = '-'
                if ($nf) {
                    [void][E193]::PostMessageA($dlg, 0x0111, [IntPtr]1, (NachID $dlg 1))
                    Start-Sleep -Milliseconds 1500
                    $nf2 = 0
                    foreach ($d in @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) -and (Kl $_) -eq '#32770' -and $_ -ne $dlg })) {
                        $texte = @(Kinder $d | ForEach-Object { Tx $_ } | Where-Object { $_ })
                        if (($texte -join ' ') -match 'not found') { $nf2 = 1 }
                        [void][E193]::PostMessageA($d, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
                    }
                    Start-Sleep -Milliseconds 400
                    $zweiter = $(if ($nf2) { 'nicht' } else { 'gefunden' })
                }
                [void][E193]::PostMessageA($dlg, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
                Start-Sleep -Milliseconds 400
            }
            Write-Host ("E193F SUCHWEG {0} {1} ist={2} zweiter={5} nach-oeffnen:{3} vor-suche:{4}" -f $fall, $mi, $ist, $f0, $f1, $zweiter)
            if ($mi) { $erg["$fall|$mi"] = [int]($ist -eq 'gefunden') }
            [void][E193]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
            Start-Sleep -Milliseconds 800
            [void](Dialoge $pp)
        }
    }
    foreach ($fall in @('ohne', 'klick', 'scroll')) {
        $t = @($erg.Keys | Where-Object { $_ -like "$fall|*" } | ForEach-Object { '{0}={1}' -f $_.Split('|')[1], $erg[$_] })
        Write-Host ("E193F ERGEBNIS suchweg-{0} {1}" -f $fall, ($t -join ' '))
    }
    [void][E193]::PostMessageA($such, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
    Start-Sleep -Milliseconds 800
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

# Soll je Mail und Wort: f13 hat keine Fusszeile mit Umlautwort.
function Soll([string] $mi, [string] $w) {
    if ($w -eq $NEGATIV) { return $false }
    if ($mi -eq 'f13' -and $w -ne 'Kolibri' -and $w -ne 'Amsel' -and $w -ne 'Gesch') { return $false }
    if ($mi -like 'g*' -and ($w -eq 'Kolibri' -or $w -eq 'Amsel')) { return $null }   # Gregors Datei: nur das Umlautwort zaehlt
    return $true
}

# Eine Runde: je Zeile und Wort ein frisches Nachrichtenfenster.
#   art 'direkt' = WM_FINDREPLACE an das Nachrichtenfenster (wie messen-e193.ps1)
#   art 'dialog' = Edit -> Find (32776), Wort in edt1 (1152), Weitersuchen (IDOK)
#   klick 1      = vorher WM_LBUTTONDOWN/UP mitten in die Anzeige (Internet
#                  Explorer_Server des Fensters) - Botschaft an gemessenes Handle
function Runde([string] $art, [int] $klick, [string[]] $woerter) {
    $ergebnis = [ordered]@{}
    $negativFalsch = 0
    for ($z = 0; $z -lt $script:nIn; $z++) {
        foreach ($w in $woerter) {
            $in = Aktiv $mdi
            [void][E193]::SendMessageA($lbIn, 0x0185, [IntPtr]0, [IntPtr](-1))
            [void][E193]::SendMessageA($lbIn, 0x0185, [IntPtr]1, [IntPtr]$z)
            [void][E193]::SendMessageA($lbIn, 0x019E, [IntPtr]$z, [IntPtr]0)
            [void][E193]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)
            [void][E193]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
            Start-Sleep -Milliseconds 2000
            $lesen = Aktiv $mdi
            if ($lesen -eq $in) { Write-Host "E193F FEHLER: Zeile $z liess sich nicht oeffnen ($art)"; break }
            $titel = Tx $lesen
            $mi = ''; if ($titel -match 'E193F ([FG]\d+)') { $mi = $Matches[1].ToLower() }
            if (-not $mi) { Write-Host "E193F HINWEIS: Zeile $z Titel '$titel' ist keine Testmail"; [void][E193]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); Start-Sleep -Milliseconds 700; continue }
            if ($klick) {
                $ie = Kinder $lesen | Where-Object { (Kl $_) -eq 'Internet Explorer_Server' -and [E193]::IsWindowVisible($_) } | Select-Object -First 1
                if ($ie) {
                    $lp = [IntPtr]((120 -shl 16) -bor 200)
                    [void][E193]::SendMessageA($ie, 0x0201, [IntPtr]1, $lp)    # WM_LBUTTONDOWN
                    [void][E193]::SendMessageA($ie, 0x0202, [IntPtr]0, $lp)    # WM_LBUTTONUP
                    Start-Sleep -Milliseconds 400
                } else { Write-Host "E193F HINWEIS: $mi kein Internet Explorer_Server fuer den Klick" }
            }
            $ist = ''
            if ($art -eq 'direkt') {
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
                $ist = switch ([int]$res) { 0 { 'gefunden' } 2 { 'nicht' } default { "fehler$([int]$res)" } }
            } else {
                Befehl $haupt 32776                                  # ID_EDIT_FIND_FINDTEXT
                $dlg = $null; $edt = $null
                foreach ($d in @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) -and (Kl $_) -eq '#32770' })) {
                    $e = NachID $d 1152
                    if ($e) { $dlg = $d; $edt = $e; break }
                }
                if (-not $dlg) { $ist = 'fehler-keindialog' }
                else {
                    [void][E193]::SendText($edt, 0x000C, [IntPtr]::Zero, $cp.GetBytes($w + [char]0))
                    Start-Sleep -Milliseconds 300
                    [void][E193]::PostMessageA($dlg, 0x0111, [IntPtr]1, (NachID $dlg 1))    # IDOK, BN_CLICKED
                    Start-Sleep -Milliseconds 1500
                    $nf = 0
                    foreach ($d in @(Oberste $pp | Where-Object { [E193]::IsWindowVisible($_) -and (Kl $_) -eq '#32770' -and $_ -ne $dlg })) {
                        $texte = @(Kinder $d | ForEach-Object { Tx $_ } | Where-Object { $_ })
                        if (($texte -join ' ') -match 'not found') { $nf = 1 } else { Write-Host ("E193F DIALOG [{0}] {1}" -f (Tx $d), ($texte -join ' | ')) }
                        [void][E193]::PostMessageA($d, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
                    }
                    Start-Sleep -Milliseconds 400
                    $ist = $(if ($nf) { 'nicht' } else { 'gefunden' })
                    [void][E193]::PostMessageA($dlg, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
                    Start-Sleep -Milliseconds 400
                }
            }
            $soll = Soll $mi $w
            $ok = $(if ($null -eq $soll) { 'egal' } elseif (($soll -and $ist -eq 'gefunden') -or (-not $soll -and $ist -eq 'nicht')) { 'richtig' } else { 'FALSCH' })
            Write-Host ("E193F {0}{1} {2} {3} ist={4} -> {5}" -f $art, $(if ($klick) { '+klick' } else { '' }), $mi, (Sichtbar $w), $ist, $ok)
            if ($w -eq $NEGATIV) { if ($ist -ne 'nicht') { $negativFalsch++ } }
            elseif ($ok -ne 'egal') {
                $r = [int]($ok -eq 'richtig')
                if (-not $ergebnis.Contains($mi)) { $ergebnis[$mi] = $r } else { $ergebnis[$mi] = [int]($ergebnis[$mi] -and $r) }
            }
            [void][E193]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
            Start-Sleep -Milliseconds 700
            [void](Dialoge $pp)
        }
    }
    $teile = @($ergebnis.Keys | Sort-Object { if ($_ -match '\d+') { ([int]$Matches[0]) + $(if ($_ -like 'g*') { 100 } else { 0 }) } } | ForEach-Object { '{0}={1}' -f $_, $ergebnis[$_] })
    Write-Host ("E193F ERGEBNIS {0}{1} {2} negativ-falsch={3}" -f $art, $(if ($klick) { '+klick' } else { '' }), ($teile -join ' '), $negativFalsch)
}

$lebt = 1; $script:nIn = 0
try {
    Befehl $haupt 32792                                   # ID_MAILBOX_IN
    $in = Aktiv $mdi; $lbIn = Liste $in
    $vorher = Anzahl $lbIn
    [void][E193]::PostMessageA($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)   # ID_FILE_CHECKMAIL
    for ($i = 0; $i -lt 80 -and (Anzahl $lbIn) -lt ($vorher + $script:anzahlMails); $i++) { Start-Sleep -Milliseconds 500; if (($i % 6) -eq 5) { [void](Dialoge $pp) } }
    Start-Sleep -Seconds 2
    [void](Dialoge $pp)
    PopBeenden
    $script:nIn = Anzahl $lbIn
    Write-Host ("E193F In: vorher={0} nachher={1} erwartet={2}" -f $vorher, $script:nIn, $script:anzahlMails)
    Befehl $haupt 33247                                   # ID_EDIT_SORT_SORTBYDATE

    $kurz = @($WOERTER[0], 'Kolibri', $NEGATIV)
    if ($Runden -match 'suchweg') { SuchfensterRunde $WOERTER[0] }
    if ($Runden -match 'voll') { Runde 'direkt' 0 @($WOERTER + $NEGATIV) }
    if ($Runden -match 'direkt') { Runde 'direkt' 0 $kurz }
    if ($Runden -match 'dialog') { Runde 'dialog' 0 $kurz }
    if ($Runden -match 'klick') { Runde 'dialog' 1 $kurz }
}
catch { Write-Host ('E193F ABBRUCH: ' + $_.Exception.Message) }
finally {
    PopBeenden
    [void][E193]::VirtualFreeEx($hp, $fern, 0, 0x8000)
    [void][E193]::CloseHandle($hp)
    $lebt = [int](Lebt $pp)
}
Write-Host ("E193F ENDE mails={0} lebt={1}" -f $script:nIn, $lebt)
try { Stop-Transcript | Out-Null } catch { }
