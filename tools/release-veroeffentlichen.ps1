# release-veroeffentlichen.ps1 - der EINZIGE erlaubte Weg zu einem Release.
#
# WARUM ES DAS GIBT
#
# Gregor am 09.09.2026: "fuer die zukunft: erst teste ich hier lokal, wenn ich
# es fuer gut befunden habe, kannst du ein github release bauen. sonst haben
# wir eine situation wie jetzt: 0.27 released, aber bug drin"
#
# Genau so war es: ich habe v1.0.27 veroeffentlicht, und DANACH kam sein
# Befund E-53. Die Fassung war released und fehlerhaft zugleich. Ein Release
# laesst sich nicht sauber zuruecknehmen - geblieben ist, es als Vorabfassung
# zu kennzeichnen, was GitHubs "Latest" auf ein altes Release zurueckstellte.
#
# Die Lehre dazu: Arbeitsweise/release-erst-nach-gregors-test.md
#
# WAS ES ERZWINGT
#
#   1. -Freigabe <Text> ist PFLICHT: der Satz, mit dem Gregor die Fassung fuer
#      gut befunden hat. Landet im Protokoll tools/RELEASES.md.
#   2. Im CHANGELOG-Abschnitt dieser Fassung muss eine Bestaetigung stehen.
#      Steht dort "noch nicht bestaetigt", weist das Werkzeug ab - eine
#      Fassung, deren eigene Dokumentation sie fuer ungeprueft erklaert, wird
#      nicht veroeffentlicht.
#   3. Quellstand und Paketnummer muessen zur verlangten Fassung passen
#      (Version.h mit seinen DREI Makros, und VERSION).
#   4. Das ZIP muss vorhanden sein; Groesse und Pruefsumme werden ausgegeben.
#
# Aufruf:
#   powershell -NoProfile -ExecutionPolicy Bypass `
#     -File tools\release-veroeffentlichen.ps1 `
#     -Fassung 1.0.28 `
#     -Freigabe "Gregor am 10.09.2026: 'passt, kannst releasen'" `
#     -Titel "7.2.0.28 / Paket 1.0.28 - ..." -Notizen pfad\zur\datei.md
#
#   -NurPruefen   prueft alles und veroeffentlicht NICHT (fuer Gegentests)
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $Fassung,
    [Parameter(Mandatory = $true)] [string] $Freigabe,
    [string] $Titel   = '',
    [string] $Notizen = '',
    [switch] $NurPruefen
)

$ErrorActionPreference = 'Stop'
$mangel = New-Object System.Collections.ArrayList
function Melde([string] $t) { [void] $mangel.Add($t) }

$wurzel = Split-Path -Parent (Split-Path -Parent $PSCommandPath)

# --- 1. Freigabe -----------------------------------------------------------

if ([string]::IsNullOrWhiteSpace($Freigabe) -or $Freigabe.Trim().Length -lt 10) {
    Melde ('Keine tragfaehige Freigabe. -Freigabe muss den Satz nennen, mit dem ' +
           'Gregor diese Fassung fuer gut befunden hat. Ohne seinen Test ' +
           'entsteht kein Release - das ist der ganze Zweck dieses Werkzeugs.')
}

# --- 2. Fassung gegen Version.h und VERSION --------------------------------

if ($Fassung -notmatch '^\d+\.\d+\.\d+$') {
    Melde ('Fassung muss die Form 1.0.28 haben, war: ' + $Fassung)
} else {
    $paketDatei = Join-Path $wurzel 'VERSION'
    $paket = ''
    if (Test-Path $paketDatei) { $paket = (Get-Content -Raw $paketDatei).Trim() }
    if ($paket -ne $Fassung) {
        Melde ('VERSION sagt ' + $paket + ', verlangt ist ' + $Fassung +
               '. Erst die Nummern hochsetzen, dann veroeffentlichen (Befund V-1).')
    }

    $klein = $Fassung.Split('.')[-1]
    $vh = Join-Path $wurzel 'Eudora71\Version.h'
    if (Test-Path $vh) {
        $inhalt = Get-Content -Raw $vh
        foreach ($muster in @(
            ('EUDORA_VERSION4 ' + $klein),
            ('7,2,0,' + $klein),
            ('"7.2.0.' + $klein + '"'))) {
            if ($inhalt -notlike ('*' + $muster + '*')) {
                Melde ('Version.h enthaelt nicht "' + $muster +
                       '" - dort stehen DREI Makros, alle drei muessen passen.')
            }
        }
    } else {
        Melde ('Version.h nicht gefunden: ' + $vh)
    }
}

# --- 3. Der CHANGELOG-Abschnitt muss eine Bestaetigung tragen --------------

$cl = Join-Path $wurzel 'CHANGELOG.md'
if (-not (Test-Path $cl)) {
    Melde ('CHANGELOG.md nicht gefunden: ' + $cl)
} else {
    $zeilen = Get-Content -Encoding UTF8 $cl
    $klein = $Fassung.Split('.')[-1]
    $anfang = -1
    for ($i = 0; $i -lt $zeilen.Count; $i++) {
        if ($zeilen[$i] -match ('^## 7\.2\.0\.' + $klein + '\b')) { $anfang = $i; break }
    }
    if ($anfang -lt 0) {
        Melde ('CHANGELOG.md hat keinen Abschnitt "## 7.2.0.' + $klein +
               '" - ohne ihn weiss niemand, was in dieser Fassung steckt.')
    } else {
        $ende = $zeilen.Count
        for ($i = $anfang + 1; $i -lt $zeilen.Count; $i++) {
            if ($zeilen[$i] -match '^## ') { $ende = $i; break }
        }
        $text = ($zeilen[$anfang..($ende - 1)] -join "`n")

        if ($text -match 'noch nicht best') {
            Melde ('Der CHANGELOG-Abschnitt zu 7.2.0.' + $klein +
                   ' sagt selbst "noch nicht bestaetigt". Eine Fassung, deren ' +
                   'eigene Dokumentation sie fuer ungeprueft erklaert, wird ' +
                   'nicht veroeffentlicht.')
        }
        # \u00e4 ist das a-Umlaut. Diese Datei bleibt reines ASCII (eigene
        # Regel), das Muster muss den Umlaut aber treffen: die MD-Dateien sind
        # UTF-8 und schreiben "bestaetigt" richtig als "bestaetigt".
        #
        # Am 09.09.2026 hat genau das ein fertiges, freigegebenes Release
        # abgewiesen - die Bestaetigung STAND im CHANGELOG, nur mit Umlaut.
        # Eine Schranke, die das Richtige abweist, wird umgangen statt
        # befolgt (Lehre schranke-gegentesten).
        if ($text -notmatch 'best(\u00e4|ae|a)tigt') {
            Melde ('Im CHANGELOG-Abschnitt zu 7.2.0.' + $klein +
                   ' steht keine Bestaetigung. Erst Gregors Rueckmeldung ' +
                   'eintragen, dann veroeffentlichen.')
        }
    }
}

# --- 4. Das ZIP ------------------------------------------------------------

$zip = Join-Path $wurzel ('Releases\Eudora72-' + $Fassung + '-release.zip')
if (-not (Test-Path $zip)) {
    Melde ('Das Paket fehlt: ' + $zip)
} else {
    Write-Host ('  Paket           ' + $zip)
    Write-Host ('  Groesse         ' + (Get-Item $zip).Length + ' B')
    Write-Host ('  SHA256          ' + (Get-FileHash $zip -Algorithm SHA256).Hash.ToLower())
}

# --- Abbruch ---------------------------------------------------------------

if ($mangel.Count -gt 0) {
    Write-Host ''
    Write-Host '  RELEASE ABGEWIESEN:'
    Write-Host ''
    foreach ($m in $mangel) { Write-Host ('    - ' + $m) }
    Write-Host ''
    Write-Host '  Siehe Arbeitsweise/release-erst-nach-gregors-test.md.'
    Write-Host ''
    exit 1
}

Write-Host ''
Write-Host '  Alle Voraussetzungen erfuellt.'
Write-Host ('  Freigabe: ' + $Freigabe)

if ($NurPruefen) {
    Write-Host '  -NurPruefen: es wird nichts veroeffentlicht.'
    Write-Host ''
    exit 0
}

# --- 5. Veroeffentlichen ---------------------------------------------------

$marke = 'v' + $Fassung
if ($Titel -eq '') { $Titel = ('7.2.0.' + $Fassung.Split('.')[-1] + ' / Paket ' + $Fassung) }

# --target ist PFLICHT, nicht Beiwerk.
#
# Ohne ihn legt "gh release create" die Marke auf den Kopf des VORGABEZWEIGS
# an - also auf main. Bei diesem Projekt merged Gregor selbst, main hinkt dem
# Arbeitszweig also regelmaessig hinterher. Die Marke haette dann auf einen
# Stand gezeigt, der die veroeffentlichte Fassung gar nicht enthaelt: das ZIP
# 7.2.0.29, die Marke aber auf 7.2.0.24. Genau das macht einen Fehlerbericht
# von aussen unzuordenbar (Befund V-1, Gregors Regel "version muss eindeutig
# sein").
#
# Genommen wird der Commit, auf dem dieser Lauf steht - und er muss auf dem
# Server liegen, sonst kennt GitHub ihn nicht.
$commit = (& git rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or $commit -notmatch '^[0-9a-f]{40}$') {
    Write-Host ''
    Write-Host '  ABBRUCH: git rev-parse HEAD hat keinen Commit geliefert.'
    Write-Host ''
    exit 1
}
& git branch -r --contains $commit *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host ''
    Write-Host ('  ABBRUCH: der Commit ' + $commit.Substring(0,7) + ' liegt in keinem Zweig auf dem Server.')
    Write-Host '  Erst pushen, dann veroeffentlichen - sonst zeigt die Marke ins Leere.'
    Write-Host ''
    exit 1
}
Write-Host ('  Marke zeigt auf ' + $commit)

# --- Schranke V-1: ein veroeffentlichtes Paket wird NICHT ersetzt ----------
#
# Gregor am 31.08.2026: "Eigentlich illegal, weil die gleiche Vers.nr. Aber
# anderes zip" - unter v1.0.3 hingen zwei verschiedene ZIPs, und der einzige
# Unterschied war die Behebung eines Absturzes (E-11). Wer sagt "ich habe
# 1.0.3 getestet", meint dann moeglicherweise das eine oder das andere.
#
# Derselbe Fehler wie bei der QCSSL.dll, wo zwei Binaerdateien dieselbe
# Kennung "QCSSL 1.0.0" tragen - nachzulesen in Releases/1.0/AUSLIEFERUNGEN.md.
# Die Regel war aufgeschrieben und hat nicht getragen, weil sie in der Datei
# ueber die DLL stand, nicht in der ueber die Pakete, und weil NICHTS sie
# durchgesetzt hat.
#
# Gregor am 14.09.2026, auf den Befund V-1 zeigend: "was ist damit?"
$vorhanden = & gh release view $marke --json tagName 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host ''
    Write-Host ('  KEIN RELEASE: die Marke ' + $marke + ' gibt es schon.')
    Write-Host ''
    Write-Host '  Ein veroeffentlichtes Paket wird nicht ersetzt - es bekommt die'
    Write-Host '  naechste Nummer. Sonst tragen zwei verschiedene ZIPs dieselbe'
    Write-Host '  Fassung, und "ich habe 1.0.x getestet" sagt nicht mehr, welches.'
    Write-Host '  Genau das ist am 31.08.2026 unter v1.0.3 passiert (Befund V-1).'
    Write-Host ''
    Write-Host '  Also: VERSION und Eudora71/Version.h hochzaehlen, neu bauen,'
    Write-Host '  neu packen, und unter der neuen Nummer veroeffentlichen.'
    Write-Host ''
    exit 1
}

$argumente = @('release', 'create', $marke,
    ($zip + '#Eudora72-' + $Fassung + '-release.zip (auspacken, Eudora starten.cmd doppelklicken)'),
    '--title', $Titel, '--latest', '--target', $commit)
if ($Notizen -ne '' -and (Test-Path $Notizen)) { $argumente += @('--notes-file', $Notizen) }

Write-Host ''
Write-Host ('  gh ' + ($argumente -join ' '))
& gh @argumente
$rc = $LASTEXITCODE

# --- 6. Protokoll ----------------------------------------------------------

# Zeilenenden und BOM, gemessen am 14.09.2026 (LEKTOR): dieselbe Fehlerklasse
# wie L-11.2 in tools/testlauf.ps1 und L-9.15 in Pruefung/PRUEFUNG-ZEIGER.md.
# Set-Content/Add-Content schreiben unter Windows PowerShell 5.1 CRLF, und
# -Encoding utf8 setzt eine BOM davor. tools/RELEASES.md trug dadurch BOM und
# 27 CRLF-Zeilen. Bei testlauf.ps1 wurde das am 09.09.2026 abgestellt, hier
# nicht - das Nachbarskript blieb stehen, und beim naechsten Release waere der
# Schaden zurueckgekommen. Deshalb auch hier ueber .NET: LF, kein BOM.
$ohneBom = New-Object System.Text.UTF8Encoding($false)
$buch = Join-Path (Join-Path $wurzel 'tools') 'RELEASES.md'
if (-not (Test-Path -LiteralPath $buch)) {
    $kopf = @(
        '# Veroeffentlichte Releases',
        '',
        'Jede Zeile ist ein Release, das ich veroeffentlicht habe, mit der Freigabe,',
        'auf die es sich stuetzt. Angelegt und gefuellt von',
        '`tools/release-veroeffentlichen.ps1` - siehe dort, warum.',
        '',
        'Diese Datei ist ein Protokoll vergangener Releases. Sie nennt absichtlich',
        'alte Fassungsnummern und wird von `tools/doku-pruefen.pl` deshalb als',
        'Zeitdokument behandelt.',
        '',
        '| Zeit | Fassung | Freigabe | Ergebnis |',
        '|---|---|---|---|'
    ) -join "`n"
    [System.IO.File]::WriteAllText($buch, $kopf + "`n", $ohneBom)
}
$zeile = '| ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' | ' + $marke + ' | ' +
         ($Freigabe -replace '\|', '/') + ' | ' +
         $(if ($rc -eq 0) { 'veroeffentlicht' } else { 'gh lieferte ' + $rc }) + ' |'
[System.IO.File]::AppendAllText($buch, $zeile + "`n", $ohneBom)
Write-Host ('  Protokolliert in ' + $buch)
Write-Host ''
exit $rc
