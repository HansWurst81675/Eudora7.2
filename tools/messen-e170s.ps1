# messen-e170s.ps1 - Huelle um tools\messen-e184.ps1 fuer Befund E-170
# (PRUEFER-89 K3): im Ziel steht schon eine gleich aussehende Mail.
#
# Lage wie messen-e170o.ps1 (Label 6 auf UID 3, ohne UIDPLUS nach Ablage),
# aber in Ablage liegt schon VOR dem Lauf eine Mail mit Datum, Absender und
# Betreff von UID 3 (--gleiche-im-ziel 3, dort UID 1; die Kopie bekommt
# UID 2). E170LabelsVormerken muss sie sehen und nicht vormerken
# (schon-da=1) - sonst koennte spaeter eine fremde die einzige passende
# sein. Keine der beiden bekommt ein Label (lieber keins als ein falsches).
#
# Ergebniszeile (zusaetzlich zur E170-Zeile):
#   E170S ERGEBNIS vorhanden=<n> kopie=<n> vorhanden-label=<n> kopie-label=<n> schon-da=<n> vorgemerkt=<n> log-grund=<..> lebt=<0|1>
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$skript = Join-Path $PSScriptRoot 'messen-e184.ps1'
if ($Vorbereiten) {
    & $skript -Pfadfilter $Pfadfilter -Vorbereiten
} else {
    & $skript -Pfadfilter $Pfadfilter -Label 6 -OhneCopyuid -GleicheImZiel
}
exit $LASTEXITCODE
