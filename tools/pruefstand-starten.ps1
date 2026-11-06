# pruefstand-starten.ps1 - der ganze Pruefstand in einem Zug, fuer jeden Klon
# und Fork (E-151). Aufgerufen von "Pruefstand starten.cmd" im Wurzelordner.
#
# -------------------------------------------------------------------------
# WARUM ES DAS GIBT
# -------------------------------------------------------------------------
#
# Gregor am 05.11.2026: "ich moechte separat von hier (oder auch jemand, der
# die repo forkt oder clonet) die tests nach eigenen aenderungen durchfuehren.
# um zu sehen, dass die neue implementierung nichts kaputt gemacht hat."
# Und zum Ablauf: "auspacken, bat starten und zuschauen".
#
# -------------------------------------------------------------------------
# ABLAUF
# -------------------------------------------------------------------------
#
#   1. Voraussetzungen pruefen: Perl (aus Git fuer Windows), eigener Bau,
#      keine Eudora aus der Wurzel offen, Ports der Pruefserver frei.
#   2. Fragen (Gregor 05.11.2026: "die abfrage ist ok. macht sinn."): der
#      Pruefstand oeffnet etwa eine Stunde lang immer wieder Eudora-Fenster und
#      aendert voruebergehend die Eudora-Eintraege der Windows-Registry. Das Ja
#      der Person am Rechner ist die Freigabe und steht im Protokoll. -Ja
#      beantwortet die Frage ohne Tastatur (auch das steht im Protokoll).
#   3. Pruefverzeichnisse frisch einrichten (tools\pruefstand-einrichten.ps1).
#   4. Alle Faelle fahren (tools\pruefstand-lauf.ps1), mit Fortschritt.
#   5. Ergebnis: Ergebniszeile, Liste je Fall, Datei <Wurzel>\pruefstand-ergebnis.txt.
#
# Auf der Entwicklermaschine des Projekts aendert sich nichts: die Agenten
# fahren tools\pruefstand-lauf.ps1 weiter mit Gregors Freigabe des Tages und
# in C:\Temp; dieser Starter nimmt eine eigene Wurzel.
#
# Aufruf:
#   Pruefstand starten.cmd
#   powershell -NoProfile -ExecutionPolicy Bypass -File tools\pruefstand-starten.ps1
#       [-Wurzel C:\Temp] [-Grundlage <release.zip>]
#       [-ZusatzDlls <ordner>] [-Nur <Kennung>] [-Bau <ordner>] [-Ja]
#
# Kodierung: reines ASCII, nur LF.

[CmdletBinding()]
param(
    # Vorgabe C:\Temp: nur dort stimmen die erwarteten Zeilen der Faelle, die
    # den Pfad selbst pruefen (E-133 Registry mit 8.3-Kurznamen, E-216l langer
    # Pfad) - gemessen an der Klonprobe vom 05.11.2026 mit tieferer Wurzel.
    # Gibt es dort schon ein Verzeichnis gleichen Namens, das nicht vom
    # Einrichter stammt, wird es nicht angefasst und sein Fall uebersprungen.
    [string] $Wurzel     = 'C:\Temp\Eudora72-Pruefstand',
    [string] $Grundlage  = '',
    [string] $ZusatzDlls = '',
    [string] $Nur        = '',
    [string] $Bau        = '',
    [switch] $Ja
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$heute = (Get-Date).ToString('dd.MM.yyyy')
. (Join-Path $PSScriptRoot 'pruefserver-aufraeumen.ps1')

function Zeile([string] $t) { Write-Host $t }
Zeile ''
Zeile '  ============================================================'
Zeile '  Eudora 7.2 - Pruefstand (Regressionstests ueber die Oberflaeche)'
Zeile '  ============================================================'
Zeile ("  Repo:   {0}" -f $repo)
Zeile ("  Wurzel: {0}" -f $Wurzel)

# --- 1. Voraussetzungen ----------------------------------------------------
$mangel = @()
$perl = 'C:\Program Files\Git\usr\bin\perl.exe'
if (-not (Test-Path -LiteralPath $perl)) { $mangel += "Perl fehlt: $perl - Git fuer Windows installieren (https://git-scm.com), es bringt Perl mit." }
$binRel = if ($Bau) { $Bau } else { Join-Path $repo 'Eudora71\Bin\Release' }
if (-not (Test-Path -LiteralPath (Join-Path $binRel 'Eudora.exe'))) {
    Zeile ''
    Zeile '  HINWEIS: Kein eigener Bau gefunden (Eudora71\Bin\Release\Eudora.exe).'
    Zeile '  Geprueft wird dann das letzte Release, NICHT eine eigene Aenderung.'
    Zeile '  Eigene Aenderungen erst bauen: powershell -File tools\bauen.ps1'
}
$offen = @(Get-Process Eudora -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith($Wurzel + '\', 'OrdinalIgnoreCase') })
if ($offen.Count -gt 0) { $mangel += ("In {0} laeuft noch Eudora (PID {1}) - erst schliessen." -f $Wurzel, (($offen.Id) -join ', ')) }
[void](Pruefserver-Aufraeumen $repo)
foreach ($b in @(Pruefports-Belegt)) { $mangel += ("Belegt: {0}" -f $b) }
if ($mangel.Count -gt 0) {
    Zeile ''
    Zeile '  NICHT GESTARTET - erst beheben:'
    foreach ($m in $mangel) { Zeile ("    - {0}" -f $m) }
    exit 2
}

# --- 2. Fragen -------------------------------------------------------------
# Erwartete Dauer aus der letzten Messung (Gregor 05.11.2026: die Dauer
# "sollte ... auf jeden fall in die beschreibung rein") - gelesen, nicht von
# Hand geschaetzt: Intern\pruefstand-dauer.txt schreibt pruefstand-lauf.ps1
# nach jedem vollen Lauf auf der Entwicklermaschine.
$erwartet = 'etwa eine bis eineinhalb Stunden'
$dauerDatei = Join-Path $repo 'Intern\pruefstand-dauer.txt'
if (Test-Path -LiteralPath $dauerDatei) {
    $d = @{}
    foreach ($z in [IO.File]::ReadAllLines($dauerDatei)) { if ($z -match '^(\w+)\t(.+)$') { $d[$Matches[1]] = $Matches[2] } }
    if ($d['sekunden'] -match '^\d+$') {
        $min = [int][math]::Round([int]$d['sekunden'] / 60)
        $erwartet = ("etwa {0} min (letzter voller Lauf {1}: {2} Faelle, {3} Eudora-Starts)" -f $min, $d['ende'], $d['faelle'], $d['starts'])
        if ($Nur) { $erwartet = "weniger - nur die Faelle zu $Nur (ganzer Lauf: $erwartet)" }
    }
}
Zeile ''
Zeile ("  Erwartete Dauer: {0}" -f $erwartet)
Zeile '  Was jetzt passiert:'
Zeile '    - Die ganze Zeit gehen immer wieder Eudora-Fenster auf'
Zeile '      und zu. Den Rechner in der Zeit nicht benutzen, nichts anklicken.'
Zeile '    - Eudora schreibt waehrenddessen in die Windows-Registry'
Zeile '      (HKCU\Software\Qualcomm\Eudora); der Pruefstand setzt das danach'
Zeile '      zurueck. Wer eine echte Eudora-Einrichtung hat: besser ein eigenes'
Zeile '      Windows-Konto oder eine virtuelle Maschine nehmen.'
Zeile '    - Die Pruefserver laufen nur lokal (127.0.0.1), es geht nichts ins Internet.'
if ($Ja) {
    $antwort = 'j'
    Zeile '  Fortfahren? (j/n) j   (per -Ja)'
} else {
    $antwort = Read-Host '  Fortfahren? (j/n)'
}
if ($antwort -notmatch '^\s*[jJyY]') { Zeile '  Abgebrochen - nichts gestartet.'; exit 1 }
$wer = [Environment]::UserName
$freigabe = ("Anwender {0} am {1} per Pruefstand starten: '{2}'{3}" -f $wer, $heute, $antwort.Trim(), $(if ($Ja) { ' (-Ja)' } else { '' }))
Zeile ("  Freigabe: {0}" -f $freigabe)

# --- 3. Einrichten ---------------------------------------------------------
$uhr = [Diagnostics.Stopwatch]::StartNew()
$ea = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', (Join-Path $PSScriptRoot 'pruefstand-einrichten.ps1'), '-Wurzel', $Wurzel, '-Erneuern')
if ($Grundlage)  { $ea += @('-Grundlage', $Grundlage) }
if ($ZusatzDlls) { $ea += @('-ZusatzDlls', $ZusatzDlls) }
if ($Bau)        { $ea += @('-Bau', $Bau) }
& powershell @ea
if ($LASTEXITCODE -ne 0) { Zeile '  Einrichten gescheitert - siehe oben.'; exit 2 }

# --- 4. Lauf ---------------------------------------------------------------
$ergebnis = Join-Path $Wurzel 'pruefstand-ergebnis.txt'
$la = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', (Join-Path $PSScriptRoot 'pruefstand-lauf.ps1'),
        '-Freigabe', $freigabe, '-Wurzel', $Wurzel, '-OhneBuch', '-ErgebnisDatei', $ergebnis)
if ($Nur) { $la += @('-Nur', $Nur) }
& powershell @la
$rc = $LASTEXITCODE
[void](Pruefserver-Aufraeumen $repo -Still)

# --- 5. Ergebnis -----------------------------------------------------------
$uhr.Stop()
Zeile ''
Zeile '  ============================================================'
if ($rc -eq 0) { Zeile '  ERGEBNIS: alle Faelle bestanden.' }
elseif ($rc -gt 0 -and $rc -lt 200) { Zeile ("  ERGEBNIS: {0} Fall/Faelle fehlgeschlagen - Liste oben ([FEHL])." -f $rc) }
else { Zeile ("  ERGEBNIS: Lauf nicht vollstaendig (Rueckgabe {0}) - siehe oben." -f $rc) }
Zeile ("  Tatsaechliche Dauer: {0} min {1:00} s (Einrichten und Lauf; erwartet war {2})" -f [int][math]::Floor($uhr.Elapsed.TotalMinutes), $uhr.Elapsed.Seconds, $erwartet)
Zeile ("  Ergebnisdatei: {0}" -f $ergebnis)
Zeile '  Was ein roter Fall bedeutet, steht in Doku\PRUEFSTAND.md.'
Zeile '  ============================================================'
exit $rc
