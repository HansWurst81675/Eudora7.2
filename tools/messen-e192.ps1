# messen-e192.ps1 - wie messen-e184m.ps1 (drei Mails, Liste nach Datum
# 3,2,1, alle markiert), aber GELOESCHT mit "in den Papierkorb verschieben"
# statt per Transfer verschoben (Befund E-192). Weg: CTocDoc::ImapMoveMsgsToTrash
# -> CImapMailbox::MoveMsgsToTrash -> XferMessagesOnServer, direkt, ohne
# Warteschlange. Papierkorb ist "Ablage" (leer), der Pruefserver vergibt dort
# 1,2,3 in UID-Folge der Quelle und meldet "[COPYUID 1 1:3 1:3]". Ordnet
# Eudora nach der Reihenfolge der eigenen Liste zu, tragen die Eintraege im
# Papierkorb die UIDs ueber Kreuz (Kopf der einen, Text der anderen Mail).
# Erwartet ohne Fehler:
#   E192 ERGEBNIS richtig=3 falsch=0 eintraege=3 anfrage=3,2,1 copyuid=1:3/1:3
# -Vorbereiten stellt im Pruefstand den Papierkorb auf "Ablage" ein und
# schaltet die Rueckfrage vor dem Loeschen ungelesener Mails ab; ein
# -Vorbereiten von messen-e184.ps1 ohne -Papierkorb stellt es zurueck.
# Laeuft unter tools\testlauf.ps1 -MessenSkript (nur -Pfadfilter wird
# durchgereicht), eigener Pruefstand (Kopie von C:\Temp\E184).
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$skript = Join-Path $PSScriptRoot 'messen-e184.ps1'
if ($Vorbereiten) {
    & $skript -Pfadfilter $Pfadfilter -Vorbereiten -Papierkorb
} else {
    & $skript -Pfadfilter $Pfadfilter -Papierkorb
}
exit $LASTEXITCODE
