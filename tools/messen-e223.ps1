# messen-e223.ps1 - Befund E-223: "Remember password" wirkt erst beim zweiten
# Mal. Setzt der Anwender das Haekchen im Kennwortdialog zum ERSTEN Mal,
# speichert Eudora nur das Haekchen (SavePassword=1), nicht das Kennwort
# (SavePasswordText); beim naechsten Start fragt es deshalb noch einmal.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript bzw. als Schalter
# messen=tools\messen-e223.ps1 in tools\pruefstand-faelle.txt, Pruefstand
# C:\Temp\E223 (Kopie von C:\Temp\E204).
#
# WARUM ES DAS GIBT. Gregor meldete E-223 am 04.11.2026 an 7.2.2.133 (POP,
# Persoenlichkeit <Dominant>). Die Ursache stand nur am Quelltext:
# CPOPSession::GetPOPPassword_ (POPSession.cpp) liest SavePass aus
# QCPOPSettings, das VOR dem Dialog angelegt wurde; der Dialog
# (password.cpp, GetPassword) schreibt SavePassword erst danach. Mit dem alten
# Wert 0 wird das Kennwort nicht geschrieben. Dieser Lauf nimmt den Weg des
# Anwenders und liest danach die Eudora.ini.
#
#   -Vorbereiten  [Settings]: <Dominant> mit Konto e223@127.0.0.1 auf dem
#                 POP-Pruefserver (Port 11110), SavePassword=0, kein
#                 SavePasswordText, keine weiteren Persoenlichkeiten. Startet
#                 den POP-Pruefserver (tools\anhang-pruefdaten.pl --pop
#                 --nur-eml, leeres Postfach), Protokoll nach
#                 <Pruefstand>\pop-protokoll.txt.
#   Messen        1. File > Check Mail (32772): Kennwortfrage; Kennwort per
#                    WM_SETTEXT ins Feld IDC_PASSWORD (1188), Haekchen
#                    IDC_PASSWORD_REMEMBER (1187) per BM_SETCHECK, Zustand per
#                    BM_GETCHECK zurueckgelesen, dann IDOK.
#                 2. File > Exit (57665), warten bis der Prozess endet.
#                 3. Eudora.ini lesen: SavePassword und SavePasswordText in
#                    [Settings]. Fehlt SavePasswordText, fragt Eudora beim
#                    naechsten Start wieder (POPSession.cpp GetPOPPassword_:
#                    mit SavePass=1 wird nur der gespeicherte Text gelesen).
#
# Nur Botschaften an gemessene Handles, kein Tastendruck
# (Arbeitsweise/keine-tastendruecke-verschicken.md). Das Kennwort ist
# erfunden und geht nur an 127.0.0.1.
#
# Ausgabe:
#   E223 ERGEBNIS savepassword=<0|1|-> ini-kennwort=<0|1> beendet=<0|1>
#   E223 PROBE ok   - wenn der Weg getroffen wurde: Kennwortfrage kam,
#                     Haekchen war gesetzt, PASS kam am Pruefserver an.
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [int] $WarteSekunden = 20
)
$ErrorActionPreference = 'Stop'
$KENNWORT = 'e223-kennwort'
$PORT     = 11110
$repo     = Split-Path -Parent $PSScriptRoot

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch ('^' + [regex]::Escape($(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp' })) + '\\E223[^\\]*$')) { Write-Output "E223 ABGEWIESEN: $voll ist kein Pruefstand C:\Temp\E223*"; exit 2 }
$md  = Join-Path $voll 'Mailverzeichnis'
$ini = Join-Path $md 'Eudora.ini'
if (-not (Test-Path -LiteralPath $ini)) { Write-Output "E223 FEHLER: keine Eudora.ini in $md"; exit 1 }
$ansi = [Text.Encoding]::Default
$pidDatei  = Join-Path $voll 'pop-pruefserver.pid'
$protokoll = Join-Path $voll 'pop-protokoll.txt'

function PopBeenden {
    if (-not (Test-Path -LiteralPath $pidDatei)) { return }
    $altPid = [int](Get-Content -LiteralPath $pidDatei)
    $p = Get-Process -Id $altPid -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Output "E223 POP-Pruefserver $altPid beendet" }
    Remove-Item -LiteralPath $pidDatei -Force
}

# [Settings] einer INI als Liste von Zeilen; $null, wenn es den Abschnitt nicht gibt
function Settings-Zeilen([string] $text) {
    $in = $false; $r = New-Object System.Collections.ArrayList; $gefunden = $false
    foreach ($z in ($text -split "`r?`n")) {
        if ($z -match '^\[(.+)\]\s*$') { $in = ($Matches[1] -ieq 'Settings'); if ($in) { $gefunden = $true }; continue }
        if ($in -and $z -ne '') { [void]$r.Add($z) }
    }
    if (-not $gefunden) { return $null }
    return ,$r
}
function Wert($zeilen, [string] $schluessel) {
    if ($null -eq $zeilen) { return $null }
    foreach ($z in $zeilen) { if ($z -match ('^' + [regex]::Escape($schluessel) + '=(.*)$')) { return $Matches[1] } }
    return $null
}

if ($Vorbereiten) {
    PopBeenden
    $text = [IO.File]::ReadAllText($ini, $ansi)
    $sb = New-Object Text.StringBuilder
    $abschnitt = ''
    $weg = '^(SavePassword|SavePasswordText|CheckMailByDefault|POPPort|POPAccount|LoginName|PopServer|UsesPOP|UsesIMAP|SSLReceiveUse|SSLSendUse)='
    foreach ($z in ($text -split "`r?`n")) {
        if ($z -match '^\[(.+)\]\s*$') {
            $abschnitt = $Matches[1]
            if ($abschnitt -ieq 'Personalities' -or $abschnitt -like 'Persona-*') { continue }
            [void]$sb.Append($z + "`r`n")
            if ($abschnitt -ieq 'Settings') {
                [void]$sb.Append("POPAccount=e223@127.0.0.1`r`nLoginName=e223`r`nPopServer=127.0.0.1`r`n" +
                                 "POPPort=$PORT`r`nSavePassword=0`r`nCheckMailByDefault=1`r`n" +
                                 "UsesPOP=1`r`nUsesIMAP=0`r`nSSLReceiveUse=0`r`nSSLSendUse=0`r`n")
            }
            continue
        }
        if ($abschnitt -ieq 'Personalities' -or $abschnitt -like 'Persona-*') { continue }
        if ($z -eq '') { continue }
        if ($abschnitt -ieq 'Settings' -and $z -match $weg) { continue }
        [void]$sb.Append($z + "`r`n")
    }
    [IO.File]::WriteAllText($ini, $sb.ToString(), $ansi)
    $kontrolle = Settings-Zeilen ([IO.File]::ReadAllText($ini, $ansi))
    if ((Wert $kontrolle 'SavePassword') -ne '0' -or $null -ne (Wert $kontrolle 'SavePasswordText')) {
        Write-Output 'E223 FEHLER: Vorbereiten hat SavePassword/SavePasswordText nicht gesetzt'; exit 1
    }
    foreach ($f in @($protokoll, ($protokoll + '.err'))) { if (Test-Path -LiteralPath $f) { Remove-Item -LiteralPath $f -Force } }
    $belegt = Get-NetTCPConnection -LocalPort $PORT -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Output "E223 FEHLER: Port $PORT ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    # Ohne -RedirectStandardOutput, wie messen-e204.ps1: sonst erbt der Server
    # die Ausgabe-Pipe, und pruefstand-lauf.ps1 wartet auf sein Ende.
    $p = Start-Process $perl -ArgumentList @("$repo\tools\anhang-pruefdaten.pl", '--pop', "$PORT", '--nur-eml', '--protokoll', $protokoll) `
         -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    $frist = (Get-Date).AddSeconds(10)
    while ((Get-Date) -lt $frist -and -not (Get-NetTCPConnection -LocalPort $PORT -State Listen -ErrorAction SilentlyContinue)) { Start-Sleep -Milliseconds 300 }
    if (-not (Get-NetTCPConnection -LocalPort $PORT -State Listen -ErrorAction SilentlyContinue)) { Write-Output "E223 FEHLER: POP-Pruefserver lauscht nicht auf $PORT"; PopBeenden; exit 1 }
    Write-Output "E223 vorbereitet: <Dominant> mit e223@127.0.0.1, SavePassword=0, POP-Pruefserver PID $($p.Id) auf Port $PORT"
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Collections.Generic; using System.Runtime.InteropServices;
public class E223W {
  public delegate bool EP(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP p, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr w, EP p, IntPtr l);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetClassName(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern IntPtr SendMessage(IntPtr h, uint m, IntPtr w, string l);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint fl, uint ms, out IntPtr r);
  public static IntPtr Senden(IntPtr h, uint m, IntPtr w, IntPtr l) { IntPtr r; SendMessageTimeoutA(h, m, w, l, 2, 3000, out r); return r; }
  public static List<IntPtr> Fenster(uint ziel) {
    List<IntPtr> r = new List<IntPtr>();
    EnumWindows(delegate(IntPtr h, IntPtr l) {
      uint pid; GetWindowThreadProcessId(h, out pid);
      if (pid == ziel && IsWindowVisible(h)) r.Add(h);
      return true; }, IntPtr.Zero);
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

$proz = @(Get-Process -Name Eudora -ErrorAction SilentlyContinue |
          Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', [StringComparison]::OrdinalIgnoreCase) })
if ($proz.Count -ne 1) { Write-Output ('E223 FEHLER: ' + $proz.Count + ' Eudora-Prozesse unter ' + $voll + ', erwartet 1'); PopBeenden; exit 1 }
$p = $proz[0]
$pid32 = [uint32]$p.Id

$haupt = [IntPtr]::Zero
foreach ($h in [E223W]::Fenster($pid32)) { if ([E223W]::Klasse($h) -eq 'EudoraMainWindow') { $haupt = $h } }
if ($haupt -eq [IntPtr]::Zero) { Write-Output 'E223 FEHLER: kein EudoraMainWindow'; PopBeenden; exit 1 }

function Kind([IntPtr] $d, [int] $id) {
    foreach ($k in [E223W]::Kinder($d)) { if ([E223W]::GetDlgCtrlID($k) -eq $id) { return $k } }
    return [IntPtr]::Zero
}
function Dialoge { @([E223W]::Fenster($pid32) | Where-Object { [E223W]::Klasse($_) -eq '#32770' }) }
function DialogText([IntPtr] $d) {
    (@([E223W]::Kinder($d) | Where-Object { [E223W]::Klasse($_) -eq 'Static' } | ForEach-Object { [E223W]::Titel($_) } | Where-Object { $_ -ne '' }) -join ' / ') -replace "`r?`n", ' '
}
function Protokoll {
    if (-not (Test-Path -LiteralPath $protokoll)) { return @() }
    $fs = [IO.File]::Open($protokoll, 'Open', 'Read', 'ReadWrite')
    try { $t = (New-Object IO.StreamReader($fs, $ansi)).ReadToEnd() } finally { $fs.Close() }
    return @($t -split "`r?`n" | Where-Object { $_ -ne '' })
}

$frage = 0; $haken = -1; $pass = $null; $fertig = 0; $beendet = 0
try {
    # 1. Abruf mit Kennwortfrage, Haekchen gesetzt
    $vorher = (Protokoll).Count
    $bekannt = Dialoge
    [void][E223W]::PostMessage($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)      # ID_FILE_CHECKMAIL
    $frist = (Get-Date).AddSeconds($WarteSekunden)
    while ((Get-Date) -lt $frist) {
        Start-Sleep -Milliseconds 400
        foreach ($d in (Dialoge)) {
            if ($bekannt -contains $d) { continue }
            $feld = Kind $d 1188
            if ($feld -ne [IntPtr]::Zero) {
                $frage = 1
                $kasten = Kind $d 1187
                Write-Output ('E223 Kennwortfrage fuer [' + [E223W]::Titel((Kind $d 1189)) + '] Benutzer [' + [E223W]::Titel((Kind $d 1190)) + '], Haekchen vorher ' + [int][E223W]::Senden($kasten, 0x00F0, [IntPtr]::Zero, [IntPtr]::Zero))
                [void][E223W]::SendMessage($feld, 0x000C, [IntPtr]::Zero, $KENNWORT)        # WM_SETTEXT
                if ($kasten -ne [IntPtr]::Zero) {
                    [void][E223W]::Senden($kasten, 0x00F1, [IntPtr]1, [IntPtr]::Zero)          # BM_SETCHECK BST_CHECKED
                    $haken = [int][E223W]::Senden($kasten, 0x00F0, [IntPtr]::Zero, [IntPtr]::Zero) # BM_GETCHECK
                }
                [void][E223W]::PostMessage($d, 0x0111, [IntPtr]1, (Kind $d 1))              # IDOK
            } else {
                Write-Output ('E223 Meldung [' + (DialogText $d) + ']')
                [void][E223W]::PostMessage($d, 0x0111, [IntPtr]1, (Kind $d 1))
            }
            $bekannt += $d
        }
        $neu = @(Protokoll | Select-Object -Skip $vorher)
        if (@($neu | Where-Object { $_ -match '> QUIT' -or $_ -match '\] getrennt' }).Count -gt 0) { $fertig = 1; break }
    }
    foreach ($z in @(Protokoll | Select-Object -Skip $vorher)) { if ($z -match '> PASS ?(.*)$') { $pass = $Matches[1] } }
    Write-Output ('E223 Abruf: frage=' + $frage + ' haken=' + $haken + ' pass=' + $(if ($null -eq $pass) { 'keins' } elseif ($pass -eq $KENNWORT) { 'richtig' } else { 'anderes' }) + ' fertig=' + $fertig)
    Start-Sleep -Seconds 1

    # 2. File > Exit, warten bis der Prozess endet
    [void][E223W]::PostMessage($haupt, 0x0111, [IntPtr]57665, [IntPtr]::Zero)      # ID_APP_EXIT
    $frist = (Get-Date).AddSeconds($WarteSekunden)
    while ((Get-Date) -lt $frist) {
        Start-Sleep -Milliseconds 500
        $p.Refresh()
        if ($p.HasExited) { $beendet = 1; break }
        foreach ($d in (Dialoge)) {
            if ($bekannt -contains $d) { continue }
            # Die Meldung "keine neue Post" kann nach dem QUIT erst kommen und
            # haelt dann das Beenden auf (gemessen 05.11.2026, beendet=0):
            # mit OK schliessen und File > Exit noch einmal schicken.
            Write-Output ('E223 Meldung beim Beenden [' + (DialogText $d) + ']')
            [void][E223W]::PostMessage($d, 0x0111, [IntPtr]1, (Kind $d 1))
            $bekannt += $d
            Start-Sleep -Milliseconds 500
            [void][E223W]::PostMessage($haupt, 0x0111, [IntPtr]57665, [IntPtr]::Zero)
        }
    }
} finally {
    PopBeenden
}

# 3. Eudora.ini lesen
$s = Settings-Zeilen ([IO.File]::ReadAllText($ini, $ansi))
$sp = Wert $s 'SavePassword'
$spt = Wert $s 'SavePasswordText'
$iniKennwort = [int]($null -ne $spt -and $spt -ne '')
Write-Output ('E223 ini: SavePassword=' + $(if ($null -eq $sp) { '-' } else { $sp }) + ' SavePasswordText=' + $(if ($null -eq $spt) { 'fehlt' } elseif ($spt -eq '') { 'leer' } else { 'gesetzt' }))
if ($frage -eq 1 -and $haken -eq 1 -and $pass -eq $KENNWORT) { Write-Output 'E223 PROBE ok' }
else { Write-Output ('E223 PROBE FEHL: frage=' + $frage + ' haken=' + $haken + ' pass-angekommen=' + [int]($pass -eq $KENNWORT)) }
Write-Output ('E223 ERGEBNIS savepassword=' + $(if ($null -eq $sp) { '-' } else { $sp }) + ' ini-kennwort=' + $iniKennwort + ' beendet=' + $beendet)
exit 0
