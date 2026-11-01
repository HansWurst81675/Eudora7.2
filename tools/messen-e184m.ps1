# messen-e184m.ps1 - wie messen-e184.ps1, aber mit DREI Mails in nicht
# aufsteigender Reihenfolge (Befund E-184, Rest K3 aus PRUEFER-75).
# Der Pruefserver liefert drei Nachrichten, UID 1 ist die juengste
# (--datum-absteigend); das Skript sortiert die INBOX nach Datum, die Liste
# steht dann 3,2,1, markiert alle und verschiebt sie nach "Ablage" (leer).
# Der Server vergibt dort 1,2,3 in UID-Reihenfolge der Quelle und meldet
# wie echte Server Bereiche "[COPYUID 1 1:3 1:3]". Ordnet Eudora nach der Reihenfolge der eigenen
# Liste zu, tragen die Eintraege die UIDs ueber Kreuz.
# Erwartet ohne Fehler:
#   E184M ERGEBNIS richtig=3 falsch=0 eintraege=3 anfrage=3,2,1 copyuid=1:3/1:3
# GEMESSEN am 01.11.2026: rot am Bau 6e9a43ba (E-184/E-189 behoben, K3
# nicht: richtig=1 falsch=2, anfrage=3,2,1), gruen mit der Behebung
# (Bau 83908112*). Die erste Gegenprobe mit Listen "1,2,3" (richtig=2
# falsch=1) mass nur den alten Leser (PRUEFER-78 K7).
# Laeuft unter tools\testlauf.ps1 -MessenSkript (nur -Pfadfilter wird
# durchgereicht), Pruefstand wie E-184.
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$skript = Join-Path $PSScriptRoot 'messen-e184.ps1'
if ($Vorbereiten) {
    & $skript -Pfadfilter $Pfadfilter -Vorbereiten
} else {
    & $skript -Pfadfilter $Pfadfilter -Mehrere
}
exit $LASTEXITCODE
