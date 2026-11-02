# messen-e170f.ps1 - Huelle um tools\messen-e184.ps1 fuer Befund E-170: bleibt
# das Label beim Verschieben innerhalb eines IMAP-Kontos erhalten?
# ohne UIDPLUS (COPY ohne COPYUID) - gleichzeitig eine fremde neue Mail im Ziel
#
# Lage wie messen-e170o.ps1 (Label 6 auf UID 3, nach Ablage), aber der
# Pruefserver legt beim COPY VOR der Kopie eine fremde neue Mail mit
# anderem Absender und Betreff in Ablage (UID 1; die Kopie bekommt UID 2).
# Das Label gehoert auf UID 2, nie auf UID 1.
#
# Ergebniszeile (zusaetzlich zur E170-Zeile):
#   E170F ERGEBNIS art=anders fremde-gelegt=<n> kopie-betreff-passt=<0|1> fremd-label=<n> kopie-label=<n> eintraege=<n> log-grund=<..> lebt=<0|1>
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
    & $skript -Pfadfilter $Pfadfilter -Label 6 -OhneCopyuid -FremdeBeiCopy anders
}
exit $LASTEXITCODE
