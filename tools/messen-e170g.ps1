# messen-e170g.ps1 - Huelle um tools\messen-e184.ps1 fuer Befund E-170: bleibt
# das Label beim Verschieben innerhalb eines IMAP-Kontos erhalten?
# ohne UIDPLUS (COPY ohne COPYUID) - fremde neue Mail, die genau so aussieht
#
# Lage wie messen-e170f.ps1, aber die fremde neue Mail traegt Datum,
# Absender und Betreff der verschobenen (nur Message-ID und Text anders).
# Eudora kann die beiden nicht unterscheiden und darf KEINER ein Label
# geben (lieber keins als ein falsches, vgl. E-184). Kein Gegenstueck am
# alten Bau: der setzt ohnehin nichts.
#
# Ergebniszeile (zusaetzlich zur E170-Zeile):
#   E170F ERGEBNIS art=gleich fremde-gelegt=<n> kopie-betreff-passt=<0|1> fremd-label=<n> kopie-label=<n> eintraege=<n> log-grund=<..> lebt=<0|1>
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
    & $skript -Pfadfilter $Pfadfilter -Label 6 -OhneCopyuid -FremdeBeiCopy gleich
}
exit $LASTEXITCODE
