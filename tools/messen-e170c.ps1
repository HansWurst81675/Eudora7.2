# messen-e170c.ps1 - Huelle um tools\messen-e184.ps1 fuer Befund E-170
# (PRUEFER-89 K1, K3): das Kopieren scheitert, danach kommt eine gleich
# aussehende fremde Mail im Ziel an.
#
# Lage wie messen-e170g.ps1 (Label 6 auf UID 3, nach Ablage, fremde Mail mit
# Datum, Absender und Betreff der verschobenen), aber der Pruefserver
# beantwortet das COPY mit NO (--copy-scheitert) und kopiert nichts - die
# fremde Mail ist danach die einzige passende im Ziel. Server MIT UIDPLUS:
# PRUEFER-89 K1 fand, dass auch dort vorgemerkt wurde.
# Vor der Behebung von K1 merkte Eudora trotzdem vor (grund=keine-neuen-uids),
# und der Abgleich gab der fremden Mail das Label. Danach: grund=fehlgeschlagen,
# nichts vorgemerkt, kein Label.
#
# Ergebniszeile (zusaetzlich zur E170- und E170F-Zeile):
#   E170C ERGEBNIS abgelehnt=<n> fremde-gelegt=<n> fremd-label=<n> eintraege=<n> vorgemerkt=<n> log-grund=<..> lebt=<0|1>
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
    & $skript -Pfadfilter $Pfadfilter -Label 6 -FremdeBeiCopy gleich -CopyScheitert
}
exit $LASTEXITCODE
