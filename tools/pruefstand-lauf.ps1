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
    [switch] $NurPruefen,
    # E-151 (05.11.2026): fuer den Lauf aus einem fremden Klon ueber
    # "Pruefstand starten.cmd" - schreibt Ergebnis, Buch und Dauer NICHT nach
    # Intern\ (die gehoeren zur Buchfuehrung dieses Projekts, nicht zu einem
    # Fork), sondern nur auf den Bildschirm und nach -ErgebnisDatei.
    [switch] $OhneBuch,
    [string] $ErgebnisDatei = '',
    # E-151: Wurzel der Pruefverzeichnisse. Die Fallliste nennt C:\Temp\<Name>;
    # mit -Wurzel C:\Temp\Andere laeuft jeder Fall in C:\Temp\Andere\<Name>.
    # Nur C:\Temp oder darunter: dort setzt die Sperre die Registry zurueck
    # (tools\pruefstand-sperre.ps1, Reg-Unterschluessel). An die Messskripte
    # geht die Wurzel als Umgebungsvariable EUDORA72_PRUEFSTAND.
    [string] $Wurzel = $(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp' })
)
$Wurzel = [IO.Path]::GetFullPath($Wurzel).TrimEnd('\')
if ($Wurzel -notmatch '^C:\\Temp(\\[^\\]+)*$') { Write-Host "  ABGEWIESEN: -Wurzel muss C:\Temp oder ein Ordner darunter sein: $Wurzel"; exit 2 }
$env:EUDORA72_PRUEFSTAND = $Wurzel

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
        Verzeichnis = $(if ($f[1].Trim() -match '^C:\\Temp\\(.+)$') { Join-Path $Wurzel $Matches[1] } else { $f[1].Trim() })
        Sekunden    = [int]$f[2].Trim()
        Quelle      = $f[3].Trim().ToLower()
        Muss        = $f[4].Trim()
        DarfNicht   = $f[5].Trim()
        Nachricht   = $f[6].Trim()
        Schalter    = $f[7].Trim().ToLower()
    }
    # E-133 (02.11.2026): beide Schalter zusammen, "ohne-argument,messen=..." -
    # die Rueckfrage zum fehlenden Mailverzeichnis kommt nur ohne Argument,
    # und beantworten muss sie ein Messskript.
    if ($fall.Schalter -ne '' -and $fall.Schalter -notmatch '^(ohne-argument|messen=tools[\\/]messen-[a-z0-9-]+\.ps1|ohne-argument,messen=tools[\\/]messen-[a-z0-9-]+\.ps1)$') {
        Write-Host ("  Zeile {0}: Schalter '{1}' - erlaubt sind ohne-argument, messen=tools\messen-<name>.ps1 und ohne-argument,messen=tools\messen-<name>.ps1" -f $zeilennr, $fall.Schalter)
        exit 2
    }
    if ($fall.Schalter -ne '' -and $fall.Nachricht -ne '') {
        Write-Host ("  Zeile {0}: {1} - Schalter und Testnachricht gehen nicht zusammen" -f $zeilennr, $fall.Kennung)
        exit 2
    }
    if ($fall.Quelle -notin @('log', 'ini', 'ablage', 'messung')) {
        Write-Host ("  Zeile {0}: Quelle '{1}' - erlaubt sind log, ini, ablage und messung" -f $zeilennr, $fall.Quelle)
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

# --- E-151: Faelle, die sich auf diesem Rechner nicht einrichten liessen ---
# tools\pruefstand-einrichten.ps1 schreibt sie hierher (Kennung TAB Grund),
# etwa E-222w ohne MFC71.DLL/msvcp71.dll (Gregor 05.11.2026: "ja,
# ueberspringen"). Sie zaehlen als UEBERSPRUNGEN, nicht als rot und nicht
# als gruen. Auf der Entwicklermaschine gibt es die Datei nicht.
$uebersprungen = @()
$nichtEinrichtbar = Join-Path $Wurzel 'Eudora72-Pruefstand-nicht-einrichtbar.txt'
if (Test-Path -LiteralPath $nichtEinrichtbar) {
    $grund = @{}
    foreach ($z in [IO.File]::ReadAllLines($nichtEinrichtbar)) {
        if ($z -match '^\s*(#|$)') { continue }
        $t2 = $z.Split("`t")
        $grund[$t2[0].Trim()] = $(if ($t2.Count -gt 1) { $t2[1].Trim() } else { 'nicht einrichtbar' })
    }
    $behalten = @()
    foreach ($f in $liste) {
        if ($grund.ContainsKey($f.Kennung)) {
            $uebersprungen += ("    [UEBR] {0,-8} {1}" -f $f.Kennung, $grund[$f.Kennung])
        } else { $behalten += $f }
    }
    $liste = $behalten
    if ($liste.Count -eq 0) { Write-Host '  Alle ausgewaehlten Faelle sind hier nicht einrichtbar.'; foreach ($u in $uebersprungen) { Write-Host $u }; exit 2 }
}

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
# Die Dauer gehoert in den Pruefbericht (Gregor am 25.10.2026: "miss auch,
# wie lange der test in etwa dauert, das tragen wir bei den pruefberichten
# ein"). Gemessen wird der ganze Lauf; geschrieben nach
# Intern/pruefstand-dauer.txt, eine eigene Datei, damit sich das Format des
# Ergebnisbuchs nicht aendert (Arbeitsweise/datenformat-aendern-heisst-alle-leser-messen.md).

# --- E-157: Gregors Registry vor dem Lauf festhalten, danach zurueck ------
# Jeder Eudora-Start schreibt nach HKCU\Software\Qualcomm\Eudora - auch der
# des Pruefstands, unter Gregors Konto. Am 26.10.2026 zeigte deshalb
# CommandLine\Current auf C:\Temp\E67 (die M1-Rueckfrage nannte meinen
# Pruefstand), und LaunchManager\DLLPath auf eine EuShlExt.dll in einem
# Scratchpad, die danach JEDES Eudora auf dem Rechner lud. Festgehalten
# werden beide Schluessel mit Namen, Wert und Art; nach dem Lauf werden neue
# Werte entfernt und geaenderte zurueckgeschrieben - auch bei Abbruch
#
# Seit 02.11.2026 (PRUEFER-87 K1): Festhalten und Zuruecksetzen stehen in
# tools\pruefstand-sperre.ps1, zusammen mit der Sperre, die gleichzeitige
# Laeufe aus anderen Arbeitsbaeumen ausschliesst. Zurueckgesetzt werden nur
# noch EIGENE Werte (die jetzt auf einen Pruefstand zeigen); fremde bleiben
# stehen und werden gemeldet. Die Sperre wird VOR dem Festhalten genommen
# und erst NACH dem Zuruecksetzen freigegeben; testlauf.ps1 und die
# -Vorbereiten-Laeufe erben sie. Genommen wird sie unmittelbar vor dem try
# unten (PRUEFER-87 N4), damit zwischen Nehmen und finally nichts liegt.
. (Join-Path $PSScriptRoot 'pruefstand-sperre.ps1')
# E-151 (Gregor 05.11.2026): Pruefserver-Reste eines abgebrochenen Laufs
# beenden, bevor ein neuer startet - nur die aus DIESEM Repo.
. (Join-Path $PSScriptRoot 'pruefserver-aufraeumen.ps1')

# --- E-157: Abstuerze aus dem Windows-Ereignisprotokoll -------------------
# Ein Fall, dessen Protokollzeile vor einem Absturz geschrieben wurde, blieb
# gruen; das Ereignisprotokoll verzeichnete seit 30.08.2026 dreissig
# Abstuerze unter C:\Temp, keiner machte einen Fall rot. Gelesen wird
# Ereignis 1000 (Application Error) seit dem Start dieses Laufs; Pfad der
# Anwendung ist Properties[10], Modul [3], Code [6] - sprachunabhaengig.
function AbstuerzeSeit([datetime] $seit, [string] $verz) {
    $voll = [IO.Path]::GetFullPath($verz).TrimEnd('\') + '\'
    $ev = @(Get-WinEvent -FilterHashtable @{ LogName = 'Application'; Id = 1000; StartTime = $seit } -ErrorAction SilentlyContinue)
    $treffer = @()
    foreach ($e in $ev) {
        $p = $e.Properties
        if ($p.Count -gt 10 -and "$($p[10].Value)".StartsWith($voll, [StringComparison]::OrdinalIgnoreCase)) {
            $treffer += ("{0} in {1} ({2}) um {3}" -f $p[0].Value, $p[3].Value, $p[6].Value, $e.TimeCreated.ToString('HH:mm:ss'))
        }
    }
    return $treffer
}

$uhr = [Diagnostics.Stopwatch]::StartNew()
$starts = 0
$bestanden = 0
$fehl      = 0
$meldungen = @()

# Gruppiert wird nach Verzeichnis UND Testnachricht: zwei Faelle mit
# verschiedenen Nachrichten brauchen zwei Laeufe, auch im selben Pruefstand.
$gruppen = $liste | Group-Object { $_.Verzeichnis + "`t" + $_.Nachricht + "`t" + $_.Schalter }

if (-not (Sperre-Nehmen 'pruefstand-lauf.ps1' 15)) {
    Write-Host '  ABGEWIESEN: die Pruefstandssperre ist belegt (siehe oben). Nichts gestartet.'
    exit 2
}
$regVorher = $null
$gruppeNr = 0
$gruppenZahl = @($gruppen).Count
$fallNr = 0
try {
[void](Pruefserver-Aufraeumen $wurzel)
$belegt = @(Pruefports-Belegt)
if ($belegt.Count -gt 0) {
    Write-Host '  ABGEWIESEN: Ports des Pruefstands sind belegt - nichts gestartet:'
    foreach ($b in $belegt) { Write-Host ("    {0}" -f $b) }
    Write-Host '  Laeuft ein anderer Pruefstand oder ein fremder Mailserver? Beenden und neu starten.'
    exit 2
}
$regVorher = Registry-Festhalten
$gedruckt = 0
foreach ($g in $gruppen) {
    # Ergebnisse der vorigen Gruppe gleich zeigen (Fortschritt, E-151)
    while ($gedruckt -lt $meldungen.Count) { Write-Host $meldungen[$gedruckt]; $gedruckt++ }
    $gruppeNr++
    # Reste des vorigen Laufs (etwa nach einem Absturz im Messskript)
    [void](Pruefserver-Aufraeumen $wurzel -Still)
    Write-Host ("  [{0}/{1}] Faelle {2}-{3} von {4}: {5}" -f $gruppeNr, $gruppenZahl, ($fallNr + 1), ($fallNr + @($g.Group).Count), $liste.Count, ((@($g.Group) | ForEach-Object { $_.Kennung }) -join ', '))
    $fallNr += @($g.Group).Count

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
    $messtext = ''

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
        $starts++
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
        $ohneArg = ($sch -eq 'ohne-argument' -or $sch -like 'ohne-argument,*')
        $messenTeil = ''
        if ($sch -like 'messen=*') { $messenTeil = $sch }
        elseif ($sch -like 'ohne-argument,messen=*') { $messenTeil = $sch.Substring(14) }
        if ($ohneArg) { $tlArgs += '-OhneArgument' }
        # messen=<skript>: ein Messskript bedient das Fenster, solange es
        # steht (E-125, 23.10.2026). Seine Ausgabe wird als Quelle "messung"
        # geprueft. Vor dem Start legt das Skript mit -Vorbereiten die Lage
        # im Pruefstand frisch an - sonst misst der zweite Lauf, was der
        # erste hinterlassen hat.
        if ($messenTeil -ne '') {
            $skript = Join-Path $wurzel ($messenTeil.Substring(7))
            & powershell -NoProfile -ExecutionPolicy Bypass -File $skript -Vorbereiten -Pfadfilter $verz | Out-Null
            if ($LASTEXITCODE -ne 0) {
                foreach ($f in $hier) {
                    $meldungen += ("    [FEHL] {0,-8} Vorbereiten mit {1} gescheitert" -f $f.Kennung, $skript); $fehl++
                }
                continue
            }
            $tlArgs += @('-MessenSkript', $skript)
        }
        $starts++
        Write-Host ("    starte {0} ({1} s, {2} Faelle{3})" -f $verz, $sek, $hier.Count, $(if ($sch) { ", $sch" } else { '' }))
        $messtext = (& powershell -NoProfile -ExecutionPolicy Bypass -File $testlauf $tlArgs) -join "`n"
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
    if (($sch -eq 'ohne-argument' -or $sch -like 'ohne-argument,*') -and -not (Test-Path $log)) {
        $neueste = Get-ChildItem $Wurzel -Recurse -Depth 2 -Filter 'eudora.log' -ErrorAction SilentlyContinue |
                   Where-Object { $_.LastWriteTime -gt $beginn } |
                   Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($neueste) {
            Write-Host ("      Protokoll gefunden in {0}" -f $neueste.DirectoryName)
            $log = $neueste.FullName
            $ini = Join-Path $neueste.DirectoryName 'Eudora.ini'
        }
    }

    # Mit geteiltem Zugriff lesen: wird Eudora abgeschossen, haelt der
    # sterbende Prozess die Datei noch einen Moment offen, und ReadAllText
    # brach den ganzen Lauf mit einer Ausnahme ab (gemessen 25.10.2026, E-100).
    function LiesGeteilt([string] $pfad) {
        for ($v = 0; $v -lt 10; $v++) {
            try {
                $fs = New-Object IO.FileStream($pfad, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
                try { return (New-Object IO.StreamReader($fs)).ReadToEnd() } finally { $fs.Dispose() }
            } catch { Start-Sleep -Milliseconds 500 }
        }
        return ''
    }
    if (Test-Path $log) { $logtext = LiesGeteilt $log }
    if (Test-Path $ini) { $initext = LiesGeteilt $ini }

    if ($logtext -eq '') {
        # Positivprobe: ohne Protokoll hat nichts gemessen, und ein Fall,
        # der nur ein "darf nicht" hat, waere sonst faelschlich gruen.
        foreach ($f in $hier) {
            $meldungen += ("    [FEHL] {0,-8} kein Protokoll nach dem Lauf (testlauf rc={1})" -f $f.Kennung, $rc)
            $fehl++
        }
        continue
    }

    # E-157: ist Eudora in diesem Lauf abgestuerzt? Dann ist jeder Fall rot,
    # auch wenn seine Zeile schon im Protokoll stand.
    Start-Sleep -Seconds 2
    $abstuerze = @(AbstuerzeSeit $beginn $verz)

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
            'ini'     { $initext }
            'messung' { $messtext }
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
            # Was das Messskript STATT der erwarteten Zeile meldete - sonst
            # sagt ein rotes Ergebnis nicht, ob Eudora abstuerzte oder der
            # Messweg nicht griff (gemessen 25.10.2026 an der E-97-Gegenprobe:
            # nur "fehlt in messung", der Absturz stand erst in Exception.log).
            if ($f.Quelle -eq 'messung' -and $messtext) {
                # Dazu die Zeilen, die mit denselben zwei Woertern beginnen wie
                # die erwartete (etwa "E133 ERGEBNIS") - am 02.11.2026 stand die
                # abweichende Ergebniszeile vor den letzten vier und fehlte im
                # Bericht.
                $kopf = (($f.Muss -split ' ') | Select-Object -First 2) -join ' '
                $gleicherKopf = @($messtext -split "`n" | Where-Object { $_.Trim().StartsWith($kopf) } | ForEach-Object { $_.Trim() })
                $letzte = @($gleicherKopf + @($messtext -split "`n" | Where-Object { $_.Trim() } | Select-Object -Last 4))
                $was += "`n             gemeldet: " + ($letzte -join "`n                       ")
            }
        }
        if ($ok -and $f.DarfNicht -ne '' -and $text.IndexOf($f.DarfNicht, [StringComparison]::Ordinal) -ge 0) {
            $ok = $false; $was = "steht in {0}, darf nicht: {1}" -f $f.Quelle, $f.DarfNicht
        }

        if ($ok -and $abstuerze.Count -gt 0) {
            $ok = $false; $was = "Eudora ist in diesem Lauf abgestuerzt (Windows-Ereignisprotokoll): " + ($abstuerze -join '; ')
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
while ($gedruckt -lt $meldungen.Count) { Write-Host $meldungen[$gedruckt]; $gedruckt++ }
} finally {
    # E-151: keine Pruefserver stehen lassen - auch nicht bei Abbruch
    try { [void](Pruefserver-Aufraeumen $wurzel -Still) } catch { }
    # PRUEFER-87 N4: die Freigabe auch, wenn das Zuruecksetzen wirft
    try {
        if ($null -ne $regVorher) { [void](Registry-Zurueck $regVorher) }
    } finally {
        Sperre-Freigeben
    }
}

Write-Host '  ------------------------------------------------------------'
foreach ($m in $meldungen) { Write-Host $m }
Write-Host '  ------------------------------------------------------------'
Write-Host ("  Ergebnis: {0} Faelle, {1} bestanden, {2} fehlgeschlagen" -f $liste.Count, $bestanden, $fehl)
if ($uebersprungen.Count -gt 0) {
    Write-Host ("  Uebersprungen (auf diesem Rechner nicht einrichtbar): {0}" -f $uebersprungen.Count)
    foreach ($u in $uebersprungen) { Write-Host $u }
}

# E-151: Lauf aus einem fremden Klon - nichts in Intern\ schreiben.
if ($OhneBuch) {
    if ($ErgebnisDatei) {
        $z = @("zeit=" + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), "freigabe=" + $Freigabe,
               "faelle=" + $liste.Count, "bestanden=" + $bestanden, "fehlgeschlagen=" + $fehl,
               "uebersprungen=" + $uebersprungen.Count)
        $z += ($meldungen + $uebersprungen | ForEach-Object { "fall=" + $_.Trim() })
        [IO.File]::WriteAllLines($ErgebnisDatei, [string[]]$z, (New-Object Text.UTF8Encoding $false))
        Write-Host ("  Ergebnis abgelegt: {0}" -f $ErgebnisDatei)
    }
    $uhr.Stop()
    $dauer = [int]$uhr.Elapsed.TotalSeconds
    Write-Host ("  Dauer: {0} min {1:00} s fuer {2} Faelle, {3} Eudora-Starts" -f [int][math]::Floor($dauer / 60), ($dauer % 60), $liste.Count, $starts)
    exit $fehl
}

# Ergebnis des LETZTEN Laufs ablegen. Gedacht war es fuer tools/pruefbericht.pl;
# der liest seit dem 25.10.2026 das Buch weiter unten und diese Datei nicht
# mehr - einen Leser hat sie derzeit nicht (LEKTOR-90 L-90.17, gemessen mit
# git grep am 29.10.2026). Ein Teillauf mit -Nur traegt eine Zeile "nur=",
# damit niemand "faelle=2" fuer den Gesamtstand haelt.
$ergebnisdatei = Join-Path $wurzel 'Intern\pruefstand-ergebnis.txt'
$zeilen = @()
$zeilen += "# Erzeugt von tools/pruefstand-lauf.ps1 - nicht von Hand aendern."
$zeilen += "zeit=" + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
$zeilen += "freigabe=" + $Freigabe
if ($Nur) { $zeilen += "nur=" + $Nur + "   (Teillauf, nicht der Gesamtstand)" }
$zeilen += "faelle=" + $liste.Count
$zeilen += "bestanden=" + $bestanden
$zeilen += "fehlgeschlagen=" + $fehl
foreach ($m in $meldungen) { $zeilen += "fall=" + $m.Trim() }
[IO.File]::WriteAllLines($ergebnisdatei, $zeilen, (New-Object Text.UTF8Encoding $false))

# ERGEBNISBUCH JE FALL (25.10.2026). Gregor am 24.10.2026: "ich wollte im
# pruefbericht etwas mehr details sehen: welcher test ist wann mit welchem
# build gelaufen." pruefstand-ergebnis.txt kennt nur den LETZTEN Lauf als
# Ganzes - ein Teillauf mit -Nur ueberschreibt ihn (PRUEFER Fund 4a,
# 22.10.2026). Das Buch fuehrt dagegen jeden Fall einzeln: ein Lauf ersetzt
# nur die Zeilen der Faelle, die er gefahren hat, und jede Zeile nennt den
# Bau, gelesen aus der Eudora.exe des Pruefstands (EUDORA_BAU_KENNUNG aus
# BuildKennung.h - Fassung, Paket, Commit; ein Sternchen heisst: mit
# uncommitteten Aenderungen gebaut). Gelesen von tools/pruefbericht.pl.
function BauKennung([string] $verz) {
    $exe = Join-Path $verz 'Eudora.exe'
    if (-not (Test-Path -LiteralPath $exe)) { return '(keine Eudora.exe)' }
    $text = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes($exe))
    $m = [regex]::Match($text, 'Eudora \d+\.\d+\.\d+\.\d+(?: / Paket [0-9.]+)?\+[0-9a-f]+\*? \d{4}-\d\d-\d\d \d\d:\d\d')
    if ($m.Success) { return $m.Value } else { return '(Baukennung nicht gefunden)' }
}
$buchdatei = Join-Path $wurzel 'Intern\pruefstand-buch.tsv'
$buch = @{}
if (Test-Path -LiteralPath $buchdatei) {
    foreach ($z in [IO.File]::ReadAllLines($buchdatei)) {
        if ($z -eq '' -or $z.StartsWith('#')) { continue }
        $buch[$z.Split("`t")[0]] = $z
    }
}
$bauJeVerz = @{}
$buchZeit = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
foreach ($m in $meldungen) {
    if ($m -notmatch '\[\s*(ok|FEHL)\s*\]\s+(\S+)\s*(.*)$') { continue }
    $erg = $Matches[1]; $k = $Matches[2]; $text = $Matches[3].Trim() -replace "`t", ' '
    $f = $liste | Where-Object { $_.Kennung -eq $k } | Select-Object -First 1
    if (-not $f) { continue }
    if (-not $bauJeVerz.ContainsKey($f.Verzeichnis)) { $bauJeVerz[$f.Verzeichnis] = BauKennung $f.Verzeichnis }
    $buch[$k] = (@($k, $erg, $buchZeit, $f.Verzeichnis, $bauJeVerz[$f.Verzeichnis], $text) -join "`t")
}
$buchZeilen = @('# Erzeugt von tools/pruefstand-lauf.ps1 - nicht von Hand aendern. Je Fall der letzte Lauf.',
                "# kennung`tergebnis`tzeit`tpruefstand`tbau`tgemessen")
$buchZeilen += ($buch.Keys | Sort-Object | ForEach-Object { $buch[$_] })
[IO.File]::WriteAllLines($buchdatei, [string[]]$buchZeilen, (New-Object Text.UTF8Encoding $false))
Write-Host ("  Ergebnisbuch: {0} Faelle in Intern\pruefstand-buch.tsv ({1} in diesem Lauf)" -f $buch.Count, $liste.Count)

$uhr.Stop()
$dauer = [int]$uhr.Elapsed.TotalSeconds
Write-Host ("  Dauer: {0} min {1:00} s fuer {2} Faelle, {3} Eudora-Starts" -f [int][math]::Floor($dauer / 60), ($dauer % 60), $liste.Count, $starts)
# Nur ein VOLLER Lauf (ohne -Nur) ist die Dauer, die im Pruefbericht steht.
if (-not $Nur) {
    $dauerdatei = Join-Path (Split-Path -Parent $PSScriptRoot) 'Intern\pruefstand-dauer.txt'
    $z = @('# Erzeugt von tools/pruefstand-lauf.ps1 - Dauer des letzten vollen Laufs.',
           ("ende`t{0}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')),
           ("sekunden`t{0}" -f $dauer),
           ("faelle`t{0}" -f $liste.Count),
           ("starts`t{0}" -f $starts))
    # Nur LF, wie die anderen Dateien in Intern/ (die erste Fassung schrieb
    # CRLF, pruefe-bytes.pl sah danach eine komplett neu geschriebene Datei).
    [IO.File]::WriteAllText($dauerdatei, (($z -join "`n") + "`n"), (New-Object Text.UTF8Encoding $false))
}

exit $fehl
