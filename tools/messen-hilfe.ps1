# messen-hilfe.ps1 - Anforderung A-5: oeffnen Help -> Keyboard Shortcuts
# (ID_HELP_KEYBOARD_SHORTCUTS 33270) und Help -> Settings Reference
# (ID_HELP_SETTINGS_REFERENCE 33271) die Seiten Hilfe\Tastenkuerzel.html und
# Hilfe\Einstellungen.html, und meldet Eudora, wenn eine fehlt?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript bzw. als messen= im
# Pruefstandsfall A-5p, Pruefstand C:\Temp\EHILFE (Kopie von C:\Temp\E140,
# Hilfe\ erzeugt mit tools\hilfe-html.pl). Nur Botschaften an gemessene
# Fensterhandles, kein Tastendruck.
#
# Zwei Betriebsarten:
#   ohne Schalter (Pruefstandsfall A-5p): Menue lesen und die Gegenprobe mit
#     umbenanntem Ordner Hilfe - es oeffnet sich KEIN Browser. kuerzel= und
#     einstellungen= stehen dann auf "ausgelassen".
#   HILFE_BROWSER=1 (Umgebungsvariable; testlauf.ps1 reicht keine Schalter
#     an das Messskript durch): zusaetzlich WM_COMMAND 33270 und 33271 mit
#     vorhandenen Seiten. Das oeffnet den Standard-Browser - bei laufendem
#     Browser eine Registerkarte in DESSEN Fenster. Deshalb nicht im
#     Regressionslauf: das Urteil haengt am Browser des Rechners, und jeder
#     Lauf stellte zwei Registerkarten auf den Bildschirm.
#
# Ablauf:
#   (1) Menue: GetMenu am Hauptfenster, Popup "Help" (ohne &), darin die
#       Eintraege mit den Kennungen 33270/33271, Text roh "&Keyboard
#       Shortcuts" und "Settings Re&ference", beide NACH "Tip of the Day"
#       (ID_TIP_OF_THE_DAY aus resource.h). Nach WM_INITMENUPOPUP: nicht grau.
#   (2) nur mit HILFE_BROWSER=1: Browserprozesse (Name, Startzeit,
#       Kommandozeile) und Titel ihrer Fenster vorher; WM_COMMAND an das
#       Hauptfenster; nach der Logzeile "Hilfe: <datei> ..." sehen
#       (bis 5 s) und alle 100 ms neue Browserprozesse samt Kommandozeile
#       erfassen (der Startprozess eines schon laufenden Chrome lebt nur
#       Bruchteile einer Sekunde). Danach: neue Prozesse, neue/geaenderte
#       Fenstertitel. Geschlossen wird NUR ein Fenster eines Prozesses, der
#       nach dem Befehl entstand UND den Pfad der HTML-Datei in der
#       Kommandozeile traegt (WM_CLOSE an sein Fenster). Eine Registerkarte
#       in einem schon laufenden Browser wird NICHT geschlossen - WM_CLOSE an
#       dessen Fenster schloesse alle Registerkarten des Anwenders.
#   (3) Gegenprobe: Hilfe -> Hilfe.messen-weg umbenennen, WM_COMMAND 33270
#       und danach 33271 (PRUEFER-84 K4); je das Meldungsfenster des
#       Prozesses lesen (Titel, Text) und mit OK schliessen; Ordner zurueck.
#       fehlt-meldung=1 nur, wenn fuer BEIDE Seiten Text und Pfad stimmen,
#       das Fenster mit OK zuging, danach keine zweite Meldung kam und dabei
#       kein Browserprozess entstand. Die Logzeile "Hilfe: Tastenkuerzel.html fehlt" prueft der
#       Fall A-5p-log nach dem Beenden.
#   (4) lebt: Prozess und Hauptfenster da, kein offenes Meldungsfenster.
#       Das Beenden ohne Fehlerdialog sieht testlauf.ps1 (Schliesszeit).
#
# DIE LOGZEILEN "Hilfe: ..." stehen waehrend des Laufs NICHT in der Datei:
# gemessen am 02.11.2026 (Lauf 14:37), keine der drei Zeilen war nach 8 s
# bzw. 3 s zu lesen, nach dem Beenden standen alle drei da - Eudora schreibt
# die eudora.log gepuffert. Das Skript nennt sie, wenn es sie sieht; geurteilt
# wird ueber sie im Pruefstandsfall (Quelle log, nach dem Beenden). Das
# Urteil kuerzel=/einstellungen=geoeffnet stuetzt sich deshalb auf das
# Browserfenster mit dem Seitentitel bzw. einen Prozess mit dem Pfad,
# fehlt-meldung=1 auf Text und Pfad im Meldungsfenster.
#
# Ausgabe:
#   HILFE ERGEBNIS menue=<0|1> kuerzel=<geoeffnet|fehlt|fehler=n|kein-browser|ausgelassen>
#                  einstellungen=<..> fehlt-meldung=<0|1> lebt=<0|1>
#   HILFE BROWSER <datei> neu-prozesse=<n> mit-pfad=<n> titel=<..> geschlossen=<n>
# Erwartet ohne Schalter:
#   menue=1 kuerzel=ausgelassen einstellungen=ausgelassen fehlt-meldung=1 lebt=1
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch ('^' + [regex]::Escape($(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp' })) + '\\[^\\]+$')) { Write-Host "HILFE ABGEWIESEN: $voll liegt nicht direkt unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$hilfeOrdner = Join-Path $voll 'Hilfe'
$hilfeWeg = Join-Path $voll 'Hilfe.messen-weg'
$seiten = @('Tastenkuerzel.html', 'Einstellungen.html')
$lat = [Text.Encoding]::GetEncoding(28591)
$mitBrowser = ($env:HILFE_BROWSER -eq '1')

# Ein abgebrochener Lauf hinterlaesst den Ordner umbenannt - zuerst zurueck.
function OrdnerZurueck() {
    if ((Test-Path -LiteralPath $hilfeWeg) -and -not (Test-Path -LiteralPath $hilfeOrdner)) {
        Rename-Item -LiteralPath $hilfeWeg -NewName 'Hilfe'
        Write-Host "HILFE Ordner Hilfe aus Hilfe.messen-weg zurueckbenannt"
    }
}

if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "HILFE FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    $laeuft = Get-Process Eudora -ErrorAction SilentlyContinue |
              Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', 'OrdinalIgnoreCase') }
    if ($laeuft) { Write-Host "HILFE FEHLER: Eudora aus $voll laeuft noch (PID $($laeuft[0].Id))"; exit 1 }
    OrdnerZurueck
    foreach ($s in $seiten) {
        if (-not (Test-Path -LiteralPath (Join-Path $hilfeOrdner $s))) {
            Write-Host "HILFE FEHLER: $hilfeOrdner\$s fehlt - vorher perl tools/hilfe-html.pl $hilfeOrdner"
            exit 1
        }
    }
    Write-Host "HILFE vorbereitet: $hilfeOrdner mit $($seiten -join ', ')"
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class HLF {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetClassNameW(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowTextW(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr GetWindow(IntPtr h, uint c);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageW(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageW(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetMenuItemCount(IntPtr m);
  [DllImport("user32.dll")] public static extern uint GetMenuItemID(IntPtr m, int i);
  [DllImport("user32.dll")] public static extern uint GetMenuState(IntPtr m, uint id, uint f);
  [DllImport("user32.dll")] public static extern IntPtr GetSubMenu(IntPtr m, int i);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetMenuStringW(IntPtr m, uint id, StringBuilder s, int n, uint f);
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][HLF]::GetClassNameW($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 2048; [void][HLF]::GetWindowTextW($h,$s,2048); $s.ToString() }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [HLF+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][HLF]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
# Sichtbare oberste Fenster einer Menge von Prozessnummern.
function Oberste($pids) {
    $r = New-Object System.Collections.ArrayList
    $cb = [HLF+EP]{ param($h,$p)
        $o = 0; [void][HLF]::GetWindowThreadProcessId($h,[ref]$o)
        if ($pids -contains [int]$o -and [HLF]::IsWindowVisible($h)) { [void]$r.Add($h) }
        return $true }
    [void][HLF]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }

# Meldungsfenster (#32770) des Prozesses: Titel, Text, OK-Knopf.
function DialogLesen($h) {
    $texte = @(); $ok = $null; $knoepfe = @()
    foreach ($c in (Kinder $h)) {
        $k = Kl $c; $t = Tx $c
        if ($k -eq 'Static' -and $t) { $texte += $t }
        if ($k -eq 'Button') { $knoepfe += ($t -replace '&',''); if (($t -replace '&','') -eq 'OK') { $ok = $c } }
    }
    return [pscustomobject]@{ H = $h; Titel = (Tx $h); Text = ($texte -join "`n"); Knoepfe = ($knoepfe -join ', '); OK = $ok }
}
function OffeneDialoge($pp) {
    return @(Oberste @([int]$pp) | Where-Object { (Kl $_) -eq '#32770' } | ForEach-Object { DialogLesen $_ })
}
function Schliessen($d) {
    if ($d.OK) { [void][HLF]::PostMessageW($d.OK, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
    else       { [void][HLF]::PostMessageW($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }         # IDCANCEL
    for ($i = 0; $i -lt 20; $i++) {
        if (-not [HLF]::IsWindow($d.H) -or -not [HLF]::IsWindowVisible($d.H)) { return $true }
        Start-Sleep -Milliseconds 150
    }
    return $false
}
function Aufraeumen($pp) {
    foreach ($d in (OffeneDialoge $pp)) {
        Write-Host ("HILFE VORAB-DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Titel, ($d.Text -replace "`r?`n",' / '), $d.Knoepfe)
        [void](Schliessen $d)
    }
}

$logPfad = Join-Path $md 'eudora.log'
function LogZeilen() {
    if (-not (Test-Path -LiteralPath $logPfad)) { return @() }
    $fs = [IO.File]::Open($logPfad, 'Open', 'Read', 'ReadWrite')
    try { $b = New-Object byte[] $fs.Length; [void]$fs.Read($b, 0, $b.Length) } finally { $fs.Close() }
    return @($lat.GetString($b) -split "`r?`n")
}
# Wartet bis $sek Sekunden auf eine neue Logzeile "Hilfe: <datei> ...".
function HilfeZeile([string] $datei, [int] $ab, [int] $sek, [scriptblock] $nebenbei) {
    for ($i = 0; $i -lt ($sek * 10); $i++) {
        if ($nebenbei) { & $nebenbei }
        $z = @(LogZeilen | Select-Object -Skip $ab | Where-Object { $_ -match ('Hilfe: ' + [regex]::Escape($datei) + ' ') })
        if ($z) { return $z[-1] }
        Start-Sleep -Milliseconds 100
    }
    return ''
}

$browserNamen = @('chrome.exe','msedge.exe','firefox.exe','iexplore.exe','opera.exe','brave.exe','vivaldi.exe')
function BrowserProzesse() {
    $f = ($browserNamen | ForEach-Object { "Name='$_'" }) -join ' OR '
    return @(Get-CimInstance Win32_Process -Filter $f -ErrorAction SilentlyContinue |
             Select-Object ProcessId, Name, CreationDate, CommandLine)
}
function BrowserTitel($pids) {
    $t = @{}
    foreach ($h in (Oberste $pids)) {
        $x = Tx $h
        if ($x) { $t[[string]$h] = $x }
    }
    return $t
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "HILFE FEHLER: keine Eudora aus $voll"; exit 1 }
$pp = $proz[0].Id
$haupt = Oberste @([int]$pp) | Where-Object { (Kl $_) -eq 'EudoraMainWindow' } | Select-Object -First 1
if (-not $haupt) { Write-Host 'HILFE FEHLER: kein Hauptfenster'; exit 1 }
Write-Host "HILFE Prozess $pp Hauptfenster $haupt [$(Tx $haupt)] Browser-Teil: $(if ($mitBrowser) { 'ja (HILFE_BROWSER=1)' } else { 'nein' })"
Start-Sleep -Milliseconds 1500
Aufraeumen $pp

# --- (1) Menue -------------------------------------------------------------
$ID_TIP = 0
$resH = Join-Path (Split-Path -Parent $PSScriptRoot) 'Eudora71\Eudora\resource.h'
if (Test-Path -LiteralPath $resH) {
    $m = [regex]::Match([IO.File]::ReadAllText($resH), '(?m)^#define\s+ID_TIP_OF_THE_DAY\s+(\d+)')
    if ($m.Success) { $ID_TIP = [int]$m.Groups[1].Value }
}
$menue = 0
$hm = [HLF]::GetMenu($haupt)
$hilfeSub = [IntPtr]::Zero; $hilfeIdx = -1
for ($i = 0; $i -lt [HLF]::GetMenuItemCount($hm); $i++) {
    $s = New-Object Text.StringBuilder 128
    [void][HLF]::GetMenuStringW($hm, [uint32]$i, $s, 128, 0x400)
    if (($s.ToString() -replace '&','') -eq 'Help') { $hilfeSub = [HLF]::GetSubMenu($hm, $i); $hilfeIdx = $i }
}
if ($hilfeSub -eq [IntPtr]::Zero) {
    Write-Host 'HILFE MENUE kein Popup "Help" im Hauptmenue'
} else {
    [void][HLF]::SendMessageW($haupt, 0x0117, $hilfeSub, [IntPtr]$hilfeIdx)   # WM_INITMENUPOPUP
    $posTip = -1; $pos1 = -1; $pos2 = -1; $txt1 = ''; $txt2 = ''; $grau = @()
    $eintraege = @()
    for ($j = 0; $j -lt [HLF]::GetMenuItemCount($hilfeSub); $j++) {
        $t = New-Object Text.StringBuilder 128
        [void][HLF]::GetMenuStringW($hilfeSub, [uint32]$j, $t, 128, 0x400)
        $id = [int][HLF]::GetMenuItemID($hilfeSub, $j)
        $eintraege += ('{0}:{1}={2}' -f $j, $t.ToString(), $id)
        if ($ID_TIP -and $id -eq $ID_TIP) { $posTip = $j }
        if ($id -eq 33270) { $pos1 = $j; $txt1 = $t.ToString() }
        if ($id -eq 33271) { $pos2 = $j; $txt2 = $t.ToString() }
    }
    foreach ($id in 33270, 33271) {
        $st = [HLF]::GetMenuState($hilfeSub, [uint32]$id, 0)   # MF_BYCOMMAND
        if ($st -ne [uint32]::MaxValue -and ($st -band 3)) { $grau += $id }
    }
    Write-Host ("HILFE MENUE Help: {0}" -f ($eintraege -join ' | '))
    Write-Host ("HILFE MENUE Tip-of-the-Day ID {0} an {1}; 33270 [{2}] an {3}; 33271 [{4}] an {5}; grau: {6}" -f `
        $ID_TIP, $posTip, $txt1, $pos1, $txt2, $pos2, $(if ($grau) { $grau -join ',' } else { 'keiner' }))
    if ($txt1 -eq '&Keyboard Shortcuts' -and $txt2 -eq 'Settings Re&ference' -and $posTip -ge 0 -and
        $pos1 -gt $posTip -and $pos2 -gt $pos1 -and -not $grau) { $menue = 1 }
}

# --- (2) Seiten oeffnen (nur HILFE_BROWSER=1) ------------------------------
$urteil = @{ 'Tastenkuerzel.html' = 'ausgelassen'; 'Einstellungen.html' = 'ausgelassen' }
if ($mitBrowser) {
    $befehle = @(@(33270, 'Tastenkuerzel.html'), @(33271, 'Einstellungen.html'))
    foreach ($b in $befehle) {
        $id = $b[0]; $datei = $b[1]
        $htmlPfad = Join-Path $hilfeOrdner $datei
        $vorher = BrowserProzesse
        $vorPids = @($vorher | ForEach-Object { [int]$_.ProcessId })
        $vorTitel = BrowserTitel $vorPids
        $gesehen = @{}
        $t0 = Get-Date
        $ab = (LogZeilen).Count
        [void][HLF]::PostMessageW($haupt, 0x0111, [IntPtr]$id, [IntPtr]::Zero)
        $erfassen = {
            foreach ($p in (BrowserProzesse)) {
                if ($vorPids -notcontains [int]$p.ProcessId -and -not $gesehen.ContainsKey([string]$p.ProcessId)) {
                    $gesehen[[string]$p.ProcessId] = $p
                }
            }
        }
        $zeile = HilfeZeile $datei $ab 5 $erfassen
        for ($i = 0; $i -lt 30; $i++) { & $erfassen; Start-Sleep -Milliseconds 100 }   # 3 s Nachlauf
        Write-Host ("HILFE LOG {0}" -f $(if ($zeile) { $zeile } else { "(Zeile 'Hilfe: $datei' noch nicht in der Datei - Eudora schreibt sie gepuffert, spaetestens beim Beenden)" }))
        $neu = @($gesehen.Values)
        $mitPfad = @($neu | Where-Object { $_.CommandLine -and $_.CommandLine.IndexOf($htmlPfad, [StringComparison]::OrdinalIgnoreCase) -ge 0 })
        foreach ($p in $neu) {
            $lebtP = [bool](Get-Process -Id $p.ProcessId -ErrorAction SilentlyContinue)
            Write-Host ("HILFE NEUER-PROZESS {0} PID {1} start {2:HH:mm:ss.fff} lebt={3} cmd: {4}" -f $p.Name, $p.ProcessId, $p.CreationDate, [int]$lebtP, $p.CommandLine)
        }
        $alleP = @(BrowserProzesse | ForEach-Object { [int]$_.ProcessId })
        $nachTitel = BrowserTitel $alleP
        $titelNeu = @()
        foreach ($k in $nachTitel.Keys) {
            if (-not $vorTitel.ContainsKey($k) -or $vorTitel[$k] -ne $nachTitel[$k]) { $titelNeu += ('{0}=[{1}]' -f $k, $nachTitel[$k]) }
        }
        # Urteil aus dem, was am Bildschirm entstand: ein Browserfenster mit
        # dem Titel der Seite oder ein Prozess mit ihrem Pfad. Die Logzeile
        # allein genuegt nicht (ShellExecute > 32 heisst nur "uebergeben"),
        # und sie steht waehrend des Laufs meist noch nicht in der Datei.
        $titelWort = @{ 'Tastenkuerzel.html' = 'Tastenk'; 'Einstellungen.html' = 'Einstellungen und Eudora.ini' }[$datei]
        $gesehenB = ($mitPfad.Count -gt 0) -or [bool]($titelNeu | Where-Object { $_.Contains('Eudora ') -and $_.Contains($titelWort) })
        if ($zeile -match ('Hilfe: ' + [regex]::Escape($datei) + ' (fehlt|fehler=\S+)')) { $urteil[$datei] = $Matches[1] }
        elseif ($gesehenB) { $urteil[$datei] = 'geoeffnet' }
        else { $urteil[$datei] = 'kein-browser' }
        # Schliessen: nur Fenster eines Prozesses, der nach dem Befehl entstand
        # und den Pfad der Seite in der Kommandozeile traegt.
        $geschlossen = 0
        foreach ($p in $mitPfad) {
            if ($p.CreationDate -lt $t0) { continue }
            if (-not (Get-Process -Id $p.ProcessId -ErrorAction SilentlyContinue)) { continue }
            foreach ($h in (Oberste @([int]$p.ProcessId))) {
                Write-Host ("HILFE SCHLIESSE Fenster {0} [{1}] von PID {2}" -f $h, (Tx $h), $p.ProcessId)
                [void][HLF]::PostMessageW($h, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
                $geschlossen++
            }
        }
        Write-Host ("HILFE BROWSER {0} neu-prozesse={1} mit-pfad={2} titel={3} geschlossen={4}" -f `
            $datei, $neu.Count, $mitPfad.Count, $(if ($titelNeu) { $titelNeu -join ';' } else { '-' }), $geschlossen)
        Aufraeumen $pp
    }
}

# --- (3) Gegenprobe: Ordner Hilfe weg ------------------------------------
# Fuer BEIDE Eintraege (PRUEFER-84 K4): vorher nur Keyboard Shortcuts, Settings
# Reference -> Einstellungen.html war am Programm nur im Browserlauf gemessen.
# fehlt-meldung=1 nur, wenn beide Meldungen stimmen.
$fehltMeldung = 0
$umbenannt = $false
try {
    Rename-Item -LiteralPath $hilfeOrdner -NewName 'Hilfe.messen-weg'
    $umbenannt = $true
} catch { Write-Host "HILFE FEHLER: Ordner Hilfe liess sich nicht umbenennen: $($_.Exception.Message)" }
if ($umbenannt) {
    try {
        $gut = 0
        foreach ($fall in @(@(33270, 'Tastenkuerzel.html'), @(33271, 'Einstellungen.html'))) {
            $befehl = $fall[0]; $datei = $fall[1]
            $vorPids = @(BrowserProzesse | ForEach-Object { [int]$_.ProcessId })
            $ab = (LogZeilen).Count
            [void][HLF]::PostMessageW($haupt, 0x0111, [IntPtr]$befehl, [IntPtr]::Zero)
            $dlg = $null
            for ($i = 0; $i -lt 50 -and -not $dlg; $i++) {
                Start-Sleep -Milliseconds 100
                $dlg = OffeneDialoge $pp | Where-Object { $_.Text } | Select-Object -First 1
            }
            $zeile = HilfeZeile $datei $ab 3 $null
            $neuB = @(BrowserProzesse | Where-Object { $vorPids -notcontains [int]$_.ProcessId })
            Write-Host ("HILFE LOG {0}" -f $(if ($zeile) { $zeile } else { "(Zeile 'Hilfe: $datei' noch nicht in der Datei - gepuffert)" }))
            if ($dlg) {
                Write-Host ("HILFE MELDUNG {0} Titel [{1}] Knoepfe [{2}]" -f $datei, $dlg.Titel, $dlg.Knoepfe)
                foreach ($z in ($dlg.Text -split "`r?`n")) { Write-Host "HILFE MELDUNG | $z" }
                $erwPfad = Join-Path $hilfeOrdner $datei
                $textOk = ($dlg.Text -match ('The help page ' + [regex]::Escape($datei) + ' could not be found')) -and
                          ($dlg.Text.IndexOf($erwPfad, [StringComparison]::OrdinalIgnoreCase) -ge 0)
                $zu = Schliessen $dlg
                Write-Host ("HILFE MELDUNG {0} text-passt={1} pfad={2} geschlossen={3} neue-browserprozesse={4}" -f $datei, [int]$textOk, $erwPfad, [int]$zu, $neuB.Count)
                # Die Logzeile "Hilfe: <datei> fehlt" prueft der Fall
                # A-5p-log nach dem Beenden (gepuffert, siehe oben).
                if ($textOk -and $zu -and $neuB.Count -eq 0) { $gut++ }
                # Ein zweites Meldungsfenster nach OK hiesse: der Fehlt-Zweig
                # faellt zu ShellExecute durch (PRUEFER-84 K1, G2).
                Start-Sleep -Milliseconds 500
                $nach = @(OffeneDialoge $pp | Where-Object { $_.Text })
                if ($nach.Count -gt 0) {
                    Write-Host ("HILFE MELDUNG {0} ZWEITE Meldung nach OK: {1}" -f $datei, ($nach[0].Text -replace "`r?`n", ' / '))
                    $gut = -99
                    foreach ($d in $nach) { [void](Schliessen $d) }
                }
            } else {
                Write-Host "HILFE MELDUNG $datei keine innerhalb von 5 s"
            }
        }
        if ($gut -eq 2) { $fehltMeldung = 1 }
    } finally {
        OrdnerZurueck
    }
}

# --- (4) lebt --------------------------------------------------------------
Start-Sleep -Milliseconds 500
$offen = @(OffeneDialoge $pp)
foreach ($d in $offen) { Write-Host ("HILFE NOCH-OFFEN [{0}] {1}" -f $d.Titel, ($d.Text -replace "`r?`n",' / ')) }
$lebt = [int]((Lebt $pp) -and [HLF]::IsWindow($haupt) -and $offen.Count -eq 0)
Aufraeumen $pp

Write-Host ("HILFE ERGEBNIS menue={0} kuerzel={1} einstellungen={2} fehlt-meldung={3} lebt={4}" -f `
    $menue, $urteil['Tastenkuerzel.html'], $urteil['Einstellungen.html'], $fehltMeldung, $lebt)
