# messen-e170.ps1 - Huelle um tools\messen-e184.ps1 fuer Befund E-170: bleibt
# das Label einer Mail beim Verschieben innerhalb eines IMAP-Kontos erhalten?
# Server mit UIDPLUS (COPY mit COPYUID).
#
# Lage: INBOX mit drei Nachrichten, Ablage leer; die LETZTE Zeile bekommt
# Label 6 (damit die neue UID im Ziel nicht zufaellig gleich der alten ist
# - gemessen 02.11.2026: mit UID 1 -> 1 "bestand" auch der alte Bau). Liste
# nach Datum sortiert, dann per
# WM_COMMAND ID_MESSAGE_LABEL_6 gesetzt, Positivprobe in INBOX.toc
# (label-quelle=1), dann Transfer -> Ablage; gemessen wird das Label der
# Kopie in Ablage.toc und die Logzeile "E-170 Labels beim Verschieben im
# Konto" (Protokollbereich Misc, 0x8000).
#
# Ergebniszeile:
#   E170 ERGEBNIS copyuid=<ja|nein> label-quelle=<n> uid-alt=<n> uid-kopiert=<n> quelle-passt=<0|1> uid-ziel=<n> kopie-mit-label=<n> log-grund=<..> lebt=<0|1>
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
    & $skript -Pfadfilter $Pfadfilter -Label 6 
}
exit $LASTEXITCODE
