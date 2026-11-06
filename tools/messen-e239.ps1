# messen-e239.ps1 - Befund E-239: Absturz beim Beenden, waehrend der Hinweis
# nach dem Mailabruf ("keine neue Post" / "neue Post") offen ist.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (mit -MitVorbereiten),
# Pruefstand C:\Temp\E239 (Kopie von C:\Temp\E223).
#
# WARUM ES DAS GIBT. Am 05.11.2026 stuerzte Eudora im Pruefstand zweimal ab
# (09:51:14 und 17:33:21, Exception.log in C:\Temp\E223): main loop ->
# CTaskStatusView::OnMsgDeleteInfo -> ~CPOPSession -> NotifyMailCheckResults
# -> AlertDialog (modal) -> in dessen Schleife WM_CLOSE -> CMainFrame::OnClose
# -> CloseDown -> g_Nicknames->CanCloseFrame mit g_Nicknames == NULL.
# Ausgeloest von ZWEI Schliesswuenschen (messen-e223.ps1 File > Exit, danach
# WM_CLOSE von testlauf.ps1). Dieser Lauf trennt die Wege.
#
# Die Betriebsart steht in <Pruefstand>\modus.txt (eine Zeile):
#   <weg> [mitpost]
#   weg = einfach     ein WM_CLOSE ans Hauptfenster bei offenem Hinweis
#         syscmd      WM_SYSCOMMAND SC_CLOSE ans Hauptfenster (Taskleiste
#                     "Fenster schliessen", Kreuz der Titelleiste)
#         endsession  WM_QUERYENDSESSION, bei Zustimmung WM_ENDSESSION(TRUE)
#                     (Windows-Abmeldung)
#         exit-close  File > Exit gleich nach dem QUIT (vor dem Hinweis), bei
#                     offenem Hinweis dann WM_CLOSE (der Pruefstandsfall)
#         exit-exit   wie exit-close, aber zweimal File > Exit
#         hinweis-exit  bei offenem Hinweis nur Exit (ID_APP_EXIT) - so kommt
#                     Exit aus dem Menue des Infobereich-Symbols an
#                     (IDR_SYSTEM_TRAY_MENU); Gregors Schritt 3 an 7.2.2.136
#         hinweis-exit-close  erst warten, bis der Hinweis offen ist, dann
#                     File > Exit und 0,8 s spaeter WM_CLOSE. Seit 06.11.2026
#                     der Pruefstandsfall: exit-close ist ein Wettlauf - an
#                     7.2.2.135 am 05.11. 3/3 Absturz, am 06.11. 3/3 kein
#                     Hinweis (Exit kam vor ihm an, PROBE FEHL), Fall gruen.
#         ohne        Hinweis mit OK schliessen, dann File > Exit (Gegenprobe)
#   mitpost = der POP-Pruefserver liefert eine Mail (Testdaten/e193-f8.eml);
#             danach wird geprueft, ob sie in In.mbx steht.
#
# VORAUSSETZUNG-HANDTEST: Alert=1
#   (Use an alert dialog box; ohne den Hinweis nach dem Abruf kein Weg in den
#   Fehler. Konto, Port und SavePassword=0 sind nur fuer den Pruefserver.)
#
# Nur Botschaften an gemessene Handles, kein Tastendruck. Das Kennwort ist
# erfunden und geht nur an 127.0.0.1. Ein Prozess, der nach einem Absturz
# noch lebt, wird nach Pfadpruefung beendet.
#
# Ausgabe:
#   E239 ERGEBNIS weg=<weg> post=<0|1> hinweis=<0|1> (der Hinweis nach dem Abruf war offen) haupt-aktiv=<0|1|-> absturz=<0|1> beendet=<0|1> mail-in-mbx=<0|1|-> toc-aktuell=<0|1|->
#   E239 PROBE ok  - wenn der Hinweis wirklich offen war, als geschlossen wurde
#   E239 SPUR <E-239-Zeile aus eudora.log>   - welcher Teil der Behebung lief
#   E239 URTEIL gruen|rot|ungueltig  - gruen nur mit hinweis=1 absturz=0 beendet=1
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [int] $WarteSekunden = 25,
    # Betriebsart (PRUEFER-102 K2): kommt aus dem Aufruf - im Pruefstandsfall
    # ueber tools\messen-e239-exit-close.ps1. Nur ohne -Weg gilt
    # <Pruefstand>\modus.txt (Handbetrieb); fehlt beides, ist das ein Fehler.
    # Vorher galt still "einfach", und mit "einfach" stuerzte auch der alte
    # Bau nicht ab - ein frischer Pruefstand pruefte den Absturz nicht mehr.
    [string] $Weg = '',
    [switch] $MitPost
)
$ErrorActionPreference = 'Stop'
$KENNWORT = 'e239-kennwort'
$PORT     = 11110
$repo     = Split-Path -Parent $PSScriptRoot
$POSTDATEI = Join-Path $repo 'Testdaten\e193-f8.eml'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\E239[^\\]*$') { Write-Output "E239 ABGEWIESEN: $voll ist kein Pruefstand C:\Temp\E239*"; exit 2 }
$md  = Join-Path $voll 'Mailverzeichnis'
$ini = Join-Path $md 'Eudora.ini'
if (-not (Test-Path -LiteralPath $ini)) { Write-Output "E239 FEHLER: keine Eudora.ini in $md"; exit 1 }
$ansi = [Text.Encoding]::Default
$pidDatei  = Join-Path $voll 'pop-pruefserver.pid'
$protokoll = Join-Path $voll 'pop-protokoll.txt'
$modusDatei = Join-Path $voll 'modus.txt'
$mitPost = [bool]$MitPost
if ($Weg -ne '') {
    $weg = $Weg
} elseif (Test-Path -LiteralPath $modusDatei) {
    $teile = @(((Get-Content -LiteralPath $modusDatei | Select-Object -First 1) -split '\s+') | Where-Object { $_ -ne '' })
    $weg = if ($teile.Count -ge 1) { $teile[0] } else { '' }
    $mitPost = ($teile -contains 'mitpost')
} else {
    Write-Output "E239 FEHLER: keine Betriebsart - weder -Weg noch $modusDatei"; exit 1
}
if (@('einfach','syscmd','endsession','exit-close','exit-exit','hinweis-exit','hinweis-exit-close','ohne') -notcontains $weg) { Write-Output "E239 FEHLER: unbekannter Weg $weg"; exit 1 }

function PopBeenden {
    if (-not (Test-Path -LiteralPath $pidDatei)) { return }
    $altPid = [int](Get-Content -LiteralPath $pidDatei)
    $pp = Get-Process -Id $altPid -ErrorAction SilentlyContinue
    if ($pp -and $pp.ProcessName -eq 'perl') { $pp.Kill(); Write-Output "E239 POP-Pruefserver $altPid beendet" }
    Remove-Item -LiteralPath $pidDatei -Force
}

if ($Vorbereiten) {
    PopBeenden
    $text = [IO.File]::ReadAllText($ini, $ansi)
    $sb = New-Object Text.StringBuilder
    $abschnitt = ''
    $wegRx = '^(Alert|SavePassword|SavePasswordText|CheckMailByDefault|POPPort|POPAccount|LoginName|PopServer|UsesPOP|UsesIMAP|SSLReceiveUse|SSLSendUse)='
    foreach ($z in ($text -split "`r?`n")) {
        if ($z -match '^\[(.+)\]\s*$') {
            $abschnitt = $Matches[1]
            if ($abschnitt -ieq 'Personalities' -or $abschnitt -like 'Persona-*') { continue }
            [void]$sb.Append($z + "`r`n")
            if ($abschnitt -ieq 'Settings') {
                [void]$sb.Append("POPAccount=e239@127.0.0.1`r`nLoginName=e239`r`nPopServer=127.0.0.1`r`n" +
                                 "POPPort=$PORT`r`nSavePassword=0`r`nCheckMailByDefault=1`r`nAlert=1`r`n" +
                                 "UsesPOP=1`r`nUsesIMAP=0`r`nSSLReceiveUse=0`r`nSSLSendUse=0`r`n")
            }
            continue
        }
        if ($abschnitt -ieq 'Personalities' -or $abschnitt -like 'Persona-*') { continue }
        if ($z -eq '') { continue }
        if ($abschnitt -ieq 'Settings' -and $z -match $wegRx) { continue }
        [void]$sb.Append($z + "`r`n")
    }
    [IO.File]::WriteAllText($ini, $sb.ToString(), $ansi)
    foreach ($f in @($protokoll, ($protokoll + '.err'))) { if (Test-Path -LiteralPath $f) { Remove-Item -LiteralPath $f -Force } }
    # Posteingang leeren: sonst stand die Mail eines frueheren Laufs noch in
    # In.mbx, und mail-in-mbx=1 sagte nichts ueber diesen Lauf (gemessen
    # 05.11.2026: retr=0, trotzdem mail-in-mbx=1).
    foreach ($f in @('In.mbx', 'In.toc')) { $p = Join-Path $md $f; if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force } }
    $belegt = Get-NetTCPConnection -LocalPort $PORT -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Output "E239 FEHLER: Port $PORT ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $arg = @("$repo\tools\anhang-pruefdaten.pl", '--pop', "$PORT", '--nur-eml', '--protokoll', $protokoll)
    if ($mitPost) { $arg += @('--eml', $POSTDATEI) }
    $sp = Start-Process $perl -ArgumentList $arg -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $sp.Id -Encoding ascii
    $frist = (Get-Date).AddSeconds(10)
    while ((Get-Date) -lt $frist -and -not (Get-NetTCPConnection -LocalPort $PORT -State Listen -ErrorAction SilentlyContinue)) { Start-Sleep -Milliseconds 300 }
    if (-not (Get-NetTCPConnection -LocalPort $PORT -State Listen -ErrorAction SilentlyContinue)) { Write-Output "E239 FEHLER: POP-Pruefserver lauscht nicht"; PopBeenden; exit 1 }
    Write-Output "E239 vorbereitet: weg=$weg mitpost=$(if ($mitPost) { 1 } else { 0 }), POP-Pruefserver PID $($sp.Id)"
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Collections.Generic; using System.Runtime.InteropServices;
public class E239W {
  public delegate bool EP(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP p, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr w, EP p, IntPtr l);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetClassName(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindowEnabled(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern IntPtr SendMessage(IntPtr h, uint m, IntPtr w, string l);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint fl, uint ms, out IntPtr r);
  public static IntPtr Senden(IntPtr h, uint m, IntPtr w, IntPtr l) { IntPtr r; SendMessageTimeoutA(h, m, w, l, 2, 5000, out r); return r; }
  public static List<IntPtr> Fenster(uint ziel) {
    List<IntPtr> r = new List<IntPtr>();
    EnumWindows(delegate(IntPtr h, IntPtr l) { uint pid; GetWindowThreadProcessId(h, out pid); if (pid == ziel && IsWindowVisible(h)) r.Add(h); return true; }, IntPtr.Zero);
    return r;
  }
  public static List<IntPtr> Kinder(IntPtr w) {
    List<IntPtr> r = new List<IntPtr>();
    EnumChildWindows(w, delegate(IntPtr h, IntPtr l) { r.Add(h); return true; }, IntPtr.Zero);
    return r;
  }
  public static string Klasse(IntPtr h) { StringBuilder s = new StringBuilder(256); GetClassName(h, s, 256); return s.ToString(); }
  public static string Titel(IntPtr h)  { StringBuilder s = new StringBuilder(1024); GetWindowText(h, s, 1024); return s.ToString(); }
}
"@

$excLog = Join-Path $md 'Exception.log'
function ExcLaenge { if (Test-Path -LiteralPath $excLog) { (Get-Item -LiteralPath $excLog).Length } else { 0 } }
$excVorher = ExcLaenge
# eudora.log ab hier: die E-239-Zeilen dieses Laufs zeigen, welcher Teil der
# Behebung gewirkt hat (aufgeschoben / nachgeholt / laeuft schon / DestroyWindow).
$eudLog = Join-Path $md 'eudora.log'
$logVorher = if (Test-Path -LiteralPath $eudLog) { (Get-Item -LiteralPath $eudLog).Length } else { 0 }

$proz = @(Get-Process -Name Eudora -ErrorAction SilentlyContinue |
          Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', [StringComparison]::OrdinalIgnoreCase) })
if ($proz.Count -ne 1) { Write-Output ('E239 FEHLER: ' + $proz.Count + ' Eudora-Prozesse unter ' + $voll); PopBeenden; exit 1 }
$p = $proz[0]
$pid32 = [uint32]$p.Id
$haupt = [IntPtr]::Zero
foreach ($h in [E239W]::Fenster($pid32)) { if ([E239W]::Klasse($h) -eq 'EudoraMainWindow') { $haupt = $h } }
if ($haupt -eq [IntPtr]::Zero) { Write-Output 'E239 FEHLER: kein EudoraMainWindow'; PopBeenden; exit 1 }

function Kind([IntPtr] $d, [int] $id) { foreach ($k in [E239W]::Kinder($d)) { if ([E239W]::GetDlgCtrlID($k) -eq $id) { return $k } }; return [IntPtr]::Zero }
function Dialoge { @([E239W]::Fenster($pid32) | Where-Object { [E239W]::Klasse($_) -eq '#32770' }) }
function DialogText([IntPtr] $d) {
    $t = @([E239W]::Kinder($d) | Where-Object { [E239W]::Klasse($_) -eq 'Static' } | ForEach-Object { [E239W]::Titel($_) } | Where-Object { $_ -ne '' }) -join ' / '
    ([E239W]::Titel($d) + ': ' + $t) -replace "`r?`n", ' '
}
function Protokoll {
    if (-not (Test-Path -LiteralPath $protokoll)) { return @() }
    $fs = [IO.File]::Open($protokoll, 'Open', 'Read', 'ReadWrite')
    try { $t = (New-Object IO.StreamReader($fs, $ansi)).ReadToEnd() } finally { $fs.Close() }
    return @($t -split "`r?`n" | Where-Object { $_ -ne '' })
}
function Lebt { $p.Refresh(); return (-not $p.HasExited) }

$hinweis = 0; $sichtbar = 0; $hauptAktiv = '-'; $quit = 0; $hinweisText = ''; $absturz = 0; $beendet = 0
try {
    $bekannt = @(Dialoge)
    [void][E239W]::PostMessage($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)      # ID_FILE_CHECKMAIL
    $frist = (Get-Date).AddSeconds($WarteSekunden)
    $hinweisHandle = [IntPtr]::Zero
    while ((Get-Date) -lt $frist -and (Lebt)) {
        Start-Sleep -Milliseconds 200
        if ($quit -eq 0 -and @(Protokoll | Where-Object { $_ -match '> QUIT' }).Count -gt 0) {
            $quit = 1
            if ($weg -like 'exit-*') {
                # Pruefstandsfall: File > Exit, bevor der Hinweis kommt
                [void][E239W]::PostMessage($haupt, 0x0111, [IntPtr]57665, [IntPtr]::Zero)
                Write-Output 'E239 File > Exit nach dem QUIT geschickt'
            }
        }
        foreach ($d in (Dialoge)) {
            if ($bekannt -contains $d) { continue }
            $bekannt += $d
            $feld = Kind $d 1188
            if ($feld -ne [IntPtr]::Zero) {
                [void][E239W]::SendMessage($feld, 0x000C, [IntPtr]::Zero, $KENNWORT)
                [void][E239W]::PostMessage($d, 0x0111, [IntPtr]1, (Kind $d 1))
                Write-Output 'E239 Kennwortfrage beantwortet'
                continue
            }
            # PRUEFER-102 K2: als Hinweis zaehlt nur DER Hinweis nach dem Abruf
            # (GetMail.cpp, AlertDialog) - Titel "No New Mail" bzw. "New Mail!"
            # und Text mit "new mail", gemessen am 05.11.2026. Vorher galt jeder
            # Dialog nach dem QUIT, etwa auch die Rueckfrage "task(s) running".
            if ($quit -eq 1) {
                $titel = [E239W]::Titel($d); $text = DialogText $d
                if (($titel -eq 'No New Mail' -or $titel -eq 'New Mail!') -and $text -match 'new mail') {
                    $hinweisHandle = $d; $hinweisText = $text; break
                }
                Write-Output ('E239 anderer Dialog nach dem QUIT [' + $text + '] - kein Hinweis, bleibt stehen')
                continue
            }
            Write-Output ('E239 andere Meldung vor dem QUIT [' + (DialogText $d) + '] - mit OK geschlossen')
            [void][E239W]::PostMessage($d, 0x0111, [IntPtr]1, (Kind $d 1))
        }
        if ($hinweisHandle -ne [IntPtr]::Zero) { break }
    }
    if ($hinweisHandle -ne [IntPtr]::Zero) {
        Start-Sleep -Milliseconds 500
        $hinweis = 1   # PRUEFER-102 K2: der Hinweis war offen (gesehen), sichtbar oder nicht
        $sichtbar = [int][E239W]::IsWindowVisible($hinweisHandle)
        $hauptAktiv = [int][E239W]::IsWindowEnabled($haupt)
        Write-Output ('E239 Hinweis offen [' + $hinweisText + '] sichtbar=' + $sichtbar + ' Hauptfenster aktiviert=' + $hauptAktiv)
        switch ($weg) {
            'einfach'    { [void][E239W]::PostMessage($haupt, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); Write-Output 'E239 WM_CLOSE geschickt' }
            'syscmd'     { [void][E239W]::PostMessage($haupt, 0x0112, [IntPtr]0xF060, [IntPtr]::Zero); Write-Output 'E239 WM_SYSCOMMAND SC_CLOSE geschickt' }
            'endsession' {
                $r = [E239W]::Senden($haupt, 0x0011, [IntPtr]::Zero, [IntPtr]::Zero)
                Write-Output ('E239 WM_QUERYENDSESSION -> ' + $r)
                if ($r -ne [IntPtr]::Zero) { [void][E239W]::Senden($haupt, 0x0016, [IntPtr]1, [IntPtr]::Zero); Write-Output 'E239 WM_ENDSESSION(TRUE) geschickt' }
            }
            'exit-close' { [void][E239W]::PostMessage($haupt, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); Write-Output 'E239 WM_CLOSE geschickt (zweiter Schliesswunsch)' }
            'exit-exit'  { [void][E239W]::PostMessage($haupt, 0x0111, [IntPtr]57665, [IntPtr]::Zero); Write-Output 'E239 File > Exit geschickt (zweiter Schliesswunsch)' }
            'hinweis-exit' { [void][E239W]::PostMessage($haupt, 0x0111, [IntPtr]57665, [IntPtr]::Zero); Write-Output 'E239 Exit (ID_APP_EXIT, wie aus dem Menue des Infobereich-Symbols) bei offenem Hinweis geschickt' }
            'hinweis-exit-close' {
                [void][E239W]::PostMessage($haupt, 0x0111, [IntPtr]57665, [IntPtr]::Zero); Write-Output 'E239 File > Exit bei offenem Hinweis geschickt'
                Start-Sleep -Milliseconds 800
                [void][E239W]::PostMessage($haupt, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); Write-Output 'E239 WM_CLOSE geschickt (zweiter Schliesswunsch)'
            }
            'ohne'       { [void][E239W]::PostMessage($hinweisHandle, 0x0111, [IntPtr]1, (Kind $hinweisHandle 1)); Start-Sleep -Milliseconds 800; [void][E239W]::PostMessage($haupt, 0x0111, [IntPtr]57665, [IntPtr]::Zero); Write-Output 'E239 Hinweis OK, dann File > Exit' }
        }
    } else {
        Write-Output ('E239 kein Hinweis gesehen (quit=' + $quit + ', lebt=' + [int](Lebt) + ')')
    }
    # Beobachten: Absturz? Ende? Weitere Dialoge?
    $frist = (Get-Date).AddSeconds(15)
    while ((Get-Date) -lt $frist -and (Lebt)) {
        Start-Sleep -Milliseconds 500
        if ((ExcLaenge) -gt $excVorher) { break }
        foreach ($d in (Dialoge)) {
            if ($bekannt -contains $d) { continue }
            $bekannt += $d
            Write-Output ('E239 Meldung danach [' + (DialogText $d) + ']')
        }
    }
    if ((ExcLaenge) -le $excVorher -and (Lebt)) {
        # Kein Absturz und noch da: offene Dialoge mit OK schliessen, dann warten
        foreach ($d in (Dialoge)) { Write-Output ('E239 noch offen [' + (DialogText $d) + '] - OK'); [void][E239W]::PostMessage($d, 0x0111, [IntPtr]1, (Kind $d 1)) }
        $frist = (Get-Date).AddSeconds(10)
        while ((Get-Date) -lt $frist -and (Lebt)) { Start-Sleep -Milliseconds 500; if ((ExcLaenge) -gt $excVorher) { break } }
        if ((Lebt) -and (ExcLaenge) -le $excVorher) { Write-Output 'E239 nach dem OK laeuft Eudora weiter (testlauf.ps1 beendet es)' }
    }
    Start-Sleep -Seconds 2
    $absturz = [int]((ExcLaenge) -gt $excVorher)
    $beendet = [int](-not (Lebt))
    if ($absturz -and (Lebt)) {
        Write-Output 'E239 Absturz protokolliert, Prozess lebt noch - wird nach Pfadpruefung beendet'
        if ($p.MainModule.FileName.StartsWith($voll + '\', [StringComparison]::OrdinalIgnoreCase)) { $p.Kill(); Start-Sleep -Seconds 1 }
    }
    if ($absturz) {
        $kopf = @(Get-Content -LiteralPath $excLog | Select-Object -Last 400 | Where-Object { $_ -match 'Eudora\.exe, ' } | Select-Object -First 5)
        foreach ($k in $kopf) { Write-Output ('E239 Stapel ' + (($k -replace '^.*Eudora\.exe, ', '') -replace ',.*$', '')) }
    }
} finally {
    PopBeenden
}

# POP-Protokoll DIESES Laufs sichern (der naechste Lauf ueberschreibt
# pop-protokoll.txt) und auswerten: kam DELE an den Server? Zusammen mit
# mail-in-mbx beantwortet das, ob eine Mail verloren gehen kann - DELE und
# nicht in In.mbx hiesse: auf dem Server geloescht, lokal nicht da.
$popRetr = 0; $popDele = 0; $popQuit = 0; $popDatei = '-'
if (Test-Path -LiteralPath $protokoll) {
    $popDatei = 'pop-protokoll-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + $weg + $(if ($mitPost) { '-post' } else { '' }) + '.txt'
    Copy-Item -LiteralPath $protokoll -Destination (Join-Path $voll $popDatei) -Force
    foreach ($z in @(Get-Content -LiteralPath $protokoll)) {
        if ($z -match '> RETR ') { $popRetr++ }
        if ($z -match '> DELE ') { $popDele++ }
        if ($z -match '> QUIT') { $popQuit = 1 }
    }
}
Write-Output ('E239 POP retr=' + $popRetr + ' dele=' + $popDele + ' quit=' + $popQuit + ' datei=' + $popDatei)

# Daten: steht die gelieferte Mail in In.mbx, ist In.toc so neu wie In.mbx?
$mailIn = '-'; $tocAktuell = '-'
$mbx = Join-Path $md 'In.mbx'; $toc = Join-Path $md 'In.toc'
if ($mitPost -and (Test-Path -LiteralPath $mbx)) {
    $betreff = (Get-Content -LiteralPath $POSTDATEI | Where-Object { $_ -match '^Subject: ' } | Select-Object -First 1) -replace '^Subject: ', ''
    $mailIn = [int]([IO.File]::ReadAllText($mbx, $ansi).Contains($betreff))
}
if ((Test-Path -LiteralPath $mbx) -and (Test-Path -LiteralPath $toc)) {
    $tocAktuell = [int]((Get-Item -LiteralPath $toc).LastWriteTime -ge (Get-Item -LiteralPath $mbx).LastWriteTime)
}
if ($hinweis -eq 1) { Write-Output 'E239 PROBE ok' } else { Write-Output 'E239 PROBE FEHL: Hinweis war nicht offen' }
Write-Output ('E239 ERGEBNIS weg=' + $weg + ' post=' + $(if ($mitPost) { '1' } else { '0' }) + ' hinweis=' + $hinweis + ' haupt-aktiv=' + $hauptAktiv + ' absturz=' + $absturz + ' beendet=' + $beendet + ' mail-in-mbx=' + $mailIn + ' toc-aktuell=' + $tocAktuell)
# E-239-Zeilen aus eudora.log seit Beginn der Messung
if (Test-Path -LiteralPath $eudLog) {
    $fs = [IO.File]::Open($eudLog, 'Open', 'Read', 'ReadWrite')
    try { if ($fs.Length -ge $logVorher) { [void]$fs.Seek($logVorher, 'Begin') }; $neu = (New-Object IO.StreamReader($fs, $ansi)).ReadToEnd() } finally { $fs.Close() }
    foreach ($z in @($neu -split "`r?`n" | Where-Object { $_ -match 'E-239 ' })) { Write-Output ('E239 SPUR ' + ($z -replace '^.*?(E-239 )', '$1')) }
}
# PRUEFER-102 K2: ein Gesamturteil. Gruen nur, wenn DER Hinweis offen war
# (sonst ist der Fehlerweg nicht getroffen) und Eudora ohne Absturz endete.
$urteil = if ($absturz -eq 1 -or ($hinweis -eq 1 -and $beendet -eq 0)) { 'rot' } elseif ($hinweis -eq 1 -and $beendet -eq 1) { 'gruen' } else { 'ungueltig' }
Write-Output ('E239 URTEIL ' + $urteil)
exit 0
