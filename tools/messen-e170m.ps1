# messen-e170m.ps1 - Huelle um tools\messen-e184.ps1 fuer Befund E-170: bleibt
# das Label beim Verschieben innerhalb eines IMAP-Kontos erhalten?
# ohne UIDPLUS (COPY ohne COPYUID) - mehrere Mails, je ein eigenes Label
#
# Lage: INBOX mit drei Nachrichten (Datum absteigend nach UID, Liste nach
# Datum sortiert also 3,2,1), Ablage leer. Zeile 1 bekommt Label 1, Zeile 2
# Label 2, Zeile 3 Label 3; dann alle nach Ablage. Jede Kopie muss das Label
# ihrer eigenen Quelle tragen (Zuordnung ueber Betreff, Datum, Absender).
#
# Ergebniszeile:
#   E170M ERGEBNIS labels-quelle=<n> richtig=<n> falsch=<n> ohne=<n> eintraege=<n> log-grund=<..> lebt=<0|1>
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
    & $skript -Pfadfilter $Pfadfilter -MehrereLabels -OhneCopyuid
}
exit $LASTEXITCODE
