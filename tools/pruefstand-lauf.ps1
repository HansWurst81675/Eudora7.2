# pruefstand-lauf.ps1 - Regressionstests ueber die Oberflaeche.
#
# Startet Eudora je Pruefverzeichnis EINMAL ueber tools\testlauf.ps1 und
# prueft danach Protokoll und Eudora.ini gegen die erwarteten Zeilen aus
# tools\pruefstand-faelle.txt.
#
# -------------------------------------------------------------------------
# WARUM ES DAS GIBT
# -------------------------------------------------------------------------
#
# Gregor am 22.10.2026: "wir sollten auch regression tests haben fuer
# kritische fehler, die man ueber die oberflaeche (eudora fenster) selbst
# ueberpruefen kann" - und: "wenn es schon alles gibt, dann werden wir es ab
# jetzt nutzen, um zu pruefen, dass nichts kaputt ging."
#
# Es gab acht messen-*.ps1. Sie stellen eine Lage her und behaupten nichts;
# gelesen hat das Protokoll danach ein Mensch. Dieses Skript faellt das
# Urteil selbst und gibt dieselbe Ergebniszeile aus wie EudoraTests.exe:
#
#     Ergebnis: N Faelle, M bestanden, K fehlgeschlagen
#
# Rueckgabe = Anzahl der fehlgeschlagenen Faelle.
#
# -------------------------------------------------------------------------
# WAS ES NICHT SELBST ENTSCHEIDET
# -------------------------------------------------------------------------
#
# -Freigabe ist Pflicht und wird unveraendert an testlauf.ps1 durchgereicht.
# Dort wird geprueft, dass der Satz das HEUTIGE Datum nennt. Ohne Gregors
# Erlaubnis startet hier nichts - dieses Skript lockert die Regel nicht,
# es benutzt sie (Arbeitsweise/nichts-auf-gregors-bildschirm-starten.md).
#
# Aufruf:
#   powershell -NoProfile -ExecutionPolicy Bypass -File tools\pruefstand-lauf.ps1 `
#              -Freigabe "Gregor am 22.10.2026: 'ja, fahr die Regressionstests'"
#
#   -Nur E-131        nur Faelle, deren Kennung so beginnt
#   -NurPruefen       liest die Faelle, startet NICHTS (Gegentest)
#   -Faelle <Datei>   andere Fallliste
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $Freigabe,
    [string] $Faelle = '',
    [string] $Nur    = '',
    [switch] $NurPruefen
)

$ErrorActionPreference = 'Stop'
$wurzel = Split-Path -Parent $PSScriptRoot
if (-not $Faelle) { $Faelle = Join-Path $PSScriptRoot 'pruefstand-faelle.txt' }
$testlauf = Join-Path $PSScriptRoot 'testlauf.ps1'

if (-not (Test-Path $Faelle))   { Write-Host "  Fallliste fehlt: $Faelle"; exit 2 }
if (-not (Test-Path $testlauf)) { Write-Host "  testlauf.ps1 fehlt: $testlauf"; exit 2 }

# --- Faelle lesen ---------------------------------------------------------
$liste = @()
$zeilennr = 0
foreach ($zeile in (Get-Content -LiteralPath $Faelle)) {
    $zeilennr++
    $t = $zeile.Trim()
    if ($t -eq '' -or $t.StartsWith('#')) { continue }
    $f = $t -split '\|'
    if ($f.Count -ne 8) {
        Write-Host ("  Zeile {0}: {1} Felder statt 8 - {2}" -f $zeilennr, $f.Count, $t)
        exit 2
    }
    $fall = [pscustomobject]@{
        Kennung     = $f[0].Trim()
        Verzeichnis = $f[1].Trim()
        Sekunden    = [int]$f[2].Trim()
        Quelle      = $f[3].Trim().ToLower()
        Muss        = $f[4].Trim()
        DarfNicht   = $f[5].Trim()
        Nachricht   = $f[6].Trim()
        Schalter    = $f[7].Trim().ToLower()
    }
    if ($fall.Schalter -ne '' -and $fall.Schalter -ne 'ohne-argument') {
        Write-Host ("  Zeile {0}: Schalter '{1}' - erlaubt ist nur ohne-argument" -f $zeilennr, $fall.Schalter)
        exit 2
    }
    if ($fall.Schalter -ne '' -and $fall.Nachricht -ne '') {
        Write-Host ("  Zeile {0}: {1} - Schalter und Testnachricht gehen nicht zusammen" -f $zeilennr, $fall.Kennung)
        exit 2
    }
    if ($fall.Quelle -notin @('log', 'ini', 'ablage')) {
        Write-Host ("  Zeile {0}: Quelle '{1}' - erlaubt sind log, ini und ablage" -f $zeilennr, $fall.Quelle)
        exit 2
    }
    if ($fall.Nachricht -ne '') {
        $eml = Join-Path $wurzel $fall.Nachricht
        if (-not (Test-Path $eml)) {
            Write-Host ("  Zeile {0}: Testnachricht fehlt: {1}" -f $zeilennr, $eml)
            exit 2
        }
        $fall.Nachricht = $eml
    }
    if ($fall.Muss -eq '' -and $fall.DarfNicht -eq '') {
        Write-Host ("  Zeile {0}: {1} behauptet nichts - dann ist es kein Test" -f $zeilennr, $fall.Kennung)
        exit 2
    }
    if ($Nur -and -not $fall.Kennung.StartsWith($Nur)) { continue }
    $liste += $fall
}

if ($liste.Count -eq 0) { Write-Host '  Keine Faelle ausgewaehlt.'; exit 2 }

Write-Host '  ------------------------------------------------------------'
Write-Host '  Regressionstests ueber die Oberflaeche'
Write-Host '  ------------------------------------------------------------'
Write-Host ("    {0} Faelle in {1} Pruefverzeichnissen" -f $liste.Count, ($liste.Verzeichnis | Sort-Object -Unique).Count)

if ($NurPruefen) {
    foreach ($f in $liste) {
        Write-Host ("    [prf] {0,-8} {1,-18} {2}" -f $f.Kennung, $f.Quelle, $(if ($f.Muss) { "muss: " + $f.Muss } else { "darf nicht: " + $f.DarfNicht }))
    }
    Write-Host '  ------------------------------------------------------------'
    Write-Host ("  Ergebnis: {0} Faelle, 0 bestanden, 0 fehlgeschlagen (nur geprueft, nichts gestartet)" -f $liste.Count)
    exit 0
}

# --- je Verzeichnis EIN Lauf ---------------------------------------------
$bestanden = 0
$fehl      = 0
$meldungen = @()

# Gruppiert wird nach Verzeichnis UND Testnachricht: zwei Faelle mit
# verschiedenen Nachrichten brauchen zwei Laeufe, auch im selben Pruefstand.
$gruppen = $liste | Group-Object { $_.Verzeichnis + "`t" + $_.Nachricht + "`t" + $_.Schalter }

foreach ($g in $gruppen) {

    $hier = @($g.Group)
    $verz = $hier[0].Verzeichnis
    $eml  = $hier[0].Nachricht
    $sch  = $hier[0].Schalter
    $sek  = ($hier.Sekunden | Measure-Object -Maximum).Maximum

    $maildir = Join-Path $verz 'Mailverzeichnis'
    $log     = Join-Path $maildir 'eudora.log'
    $ini     = Join-Path $maildir 'Eudora.ini'

    if (-not (Test-Path $maildir)) {
        foreach ($f in $hier) {
            $meldungen += ("    [FEHL] {0,-8} Pruefverzeichnis fehlt: {1}" -f $f.Kennung, $maildir)
            $fehl++
        }
        continue
    }

    # Das alte Protokoll weg - sonst wird eine Zeile vom VORIGEN Lauf
    # gelesen und der Test ist gruen, ohne etwas gemessen zu haben
    # (Arbeitsweise/ausbleiben-ist-kein-befund.md).
    if (Test-Path $log) { Remove-Item -LiteralPath $log -Force }
    $beginn = Get-Date

    $ablage = Join-Path $verz 'ablage'

    if ($eml -ne '') {
        # Mit Testnachricht: ueber e118-serie.ps1, das POP- und IMAP-
        # Pruefserver frisch hochzieht, den Posteingang zuruecksetzt und
        # Eudora dann ueber testlauf.ps1 startet. Nicht nachgebaut -
        # es gibt den Weg schon (Arbeitsweise/werkzeug-vor-eigenbau.md).
        $serie = Join-Path $PSScriptRoot 'e118-serie.ps1'
        if (-not (Test-Path $serie)) {
            foreach ($f in $hier) {
                $meldungen += ("    [FEHL] {0,-8} e118-serie.ps1 fehlt" -f $f.Kennung); $fehl++
            }
            continue
        }
        Write-Host ("    starte {0} mit {1} ({2} s, {3} Faelle)" -f $verz, (Split-Path -Leaf $eml), $sek, $hier.Count)
        & powershell -NoProfile -ExecutionPolicy Bypass -File $serie `
            -Freigabe $Freigabe -Eml $eml -Anzahl 1 -Verzeichnis $verz `
            -Kennung 'regression' -SchliessSekunden 30 | Out-Null
        $rc = $LASTEXITCODE
    } else {
        # -OhneArgument: nur so sucht Eudora sich das Mailverzeichnis selbst
        # ueber die Registry - und nur auf diesem Weg laeuft
        # StartEudoraWithDefaultLocation, in der die E-132-Spurmarke steht
        # (eudora.cpp:4171). Mit Verzeichnis auf der Befehlszeile wird die
        # Funktion nie erreicht; ein Fall ohne diesen Schalter misst dort
        # nichts (Arbeitsweise/messung-muss-den-weg-treffen.md).
        $tlArgs = @('-Verzeichnis', $verz, '-Freigabe', $Freigabe, '-Sekunden', $sek)
        if ($sch -eq 'ohne-argument') { $tlArgs += '-OhneArgument' }
        Write-Host ("    starte {0} ({1} s, {2} Faelle{3})" -f $verz, $sek, $hier.Count, $(if ($sch) { ", $sch" } else { '' }))
        & powershell -NoProfile -ExecutionPolicy Bypass -File $testlauf $tlArgs | Out-Null
        $rc = $LASTEXITCODE
    }

    $logtext = ''
    $initext = ''

    # Bei -OhneArgument sucht Eudora sich das Mailverzeichnis SELBST. Das
    # Protokoll liegt dann dort, wohin es gegangen ist - am 22.10.2026
    # gemessen: Start aus C:\Temp\E132, Protokoll in C:\Temp\E131. Genau
    # das ist der Gegenstand von E-132, also wird es dort gesucht, wo es
    # wirklich ist, statt den Fall an der falschen Stelle gruen oder rot
    # zu melden.
    if ($sch -eq 'ohne-argument' -and -not (Test-Path $log)) {
        $neueste = Get-ChildItem 'C:\Temp' -Recurse -Depth 2 -Filter 'eudora.log' -ErrorAction SilentlyContinue |
                   Where-Object { $_.LastWriteTime -gt $beginn } |
                   Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($neueste) {
            Write-Host ("      Protokoll gefunden in {0}" -f $neueste.DirectoryName)
            $log = $neueste.FullName
            $ini = Join-Path $neueste.DirectoryName 'Eudora.ini'
        }
    }

    if (Test-Path $log) { $logtext = [IO.File]::ReadAllText($log) }
    if (Test-Path $ini) { $initext = [IO.File]::ReadAllText($ini) }

    if ($logtext -eq '') {
        # Positivprobe: ohne Protokoll hat nichts gemessen, und ein Fall,
        # der nur ein "darf nicht" hat, waere sonst faelschlich gruen.
        foreach ($f in $hier) {
            $meldungen += ("    [FEHL] {0,-8} kein Protokoll nach dem Lauf (testlauf rc={1})" -f $f.Kennung, $rc)
            $fehl++
        }
        continue
    }

    # Quelle "ablage": was im IMAP-Zielordner angekommen ist, als Text, damit
    # dieselbe Vergleichsmaschine greift. e118-serie.ps1 legt das Verzeichnis
    # je Lauf frisch an; was darin liegt, hat der IMAP-Pruefserver empfangen.
    $ablagetext = ''
    if (Test-Path $ablage) {
        $dateien = @(Get-ChildItem -LiteralPath $ablage -File -ErrorAction SilentlyContinue)
        $ablagetext = "ablage-dateien=" + $dateien.Count + "`n" + (($dateien.Name) -join "`n") + "`n"
    } else {
        $ablagetext = "ablage-dateien=0`n"
    }

    foreach ($f in $hier) {
        $text = switch ($f.Quelle) {
            'ini'    { $initext }
            'ablage' { $ablagetext }
            default  { $logtext }
        }
        if ($f.Quelle -eq 'ini' -and $initext -eq '') {
            $meldungen += ("    [FEHL] {0,-8} keine Eudora.ini nach dem Lauf" -f $f.Kennung)
            $fehl++
            continue
        }

        $ok  = $true
        $was = ''
        if ($f.Muss -ne '' -and $text.IndexOf($f.Muss, [StringComparison]::Ordinal) -lt 0) {
            $ok = $false; $was = "fehlt in {0}: {1}" -f $f.Quelle, $f.Muss
        }
        if ($ok -and $f.DarfNicht -ne '' -and $text.IndexOf($f.DarfNicht, [StringComparison]::Ordinal) -ge 0) {
            $ok = $false; $was = "steht in {0}, darf nicht: {1}" -f $f.Quelle, $f.DarfNicht
        }

        if ($ok) {
            $bestanden++
            $meldungen += ("    [ ok ] {0,-8} {1}" -f $f.Kennung, $(if ($f.Muss) { $f.Muss } else { "ohne " + $f.DarfNicht }))
        } else {
            $fehl++
            $meldungen += ("    [FEHL] {0,-8} {1}" -f $f.Kennung, $was)
        }
    }
}

Write-Host '  ------------------------------------------------------------'
foreach ($m in $meldungen) { Write-Host $m }
Write-Host '  ------------------------------------------------------------'
Write-Host ("  Ergebnis: {0} Faelle, {1} bestanden, {2} fehlgeschlagen" -f $liste.Count, $bestanden, $fehl)

# Ergebnis ablegen, damit tools/pruefbericht.pl es LESEN kann statt es zu
# behaupten. Der Bericht kann diesen Lauf nicht selbst ausloesen - er oeffnet
# Fenster und braucht Gregors Freigabe. Die Zeitmarke steht mit drin, damit
# der Bericht merkt, wenn das Ergebnis aelter ist als der Bau.
$ergebnisdatei = Join-Path $wurzel 'Intern\pruefstand-ergebnis.txt'
$zeilen = @()
$zeilen += "# Erzeugt von tools/pruefstand-lauf.ps1 - nicht von Hand aendern."
$zeilen += "zeit=" + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
$zeilen += "freigabe=" + $Freigabe
$zeilen += "faelle=" + $liste.Count
$zeilen += "bestanden=" + $bestanden
$zeilen += "fehlgeschlagen=" + $fehl
foreach ($m in $meldungen) { $zeilen += "fall=" + $m.Trim() }
[IO.File]::WriteAllLines($ergebnisdatei, $zeilen, (New-Object Text.UTF8Encoding $false))

exit $fehl
