# messen-e189.ps1 - wie messen-e184.ps1, aber der Pruefserver meldet beim
# COPY KEINE neuen UIDs (kein COPYUID, wie ein Server ohne UIDPLUS).
# Befund E-189 (PRUEFER-75 K2): die Vorab-Kopie aus CTocDoc::Xfer behaelt
# dann die alte UID; liegt im Ziel eine fremde Mail mit derselben UID,
# ueberlebt die Kopie vermutlich den Abgleich (CUidMap fuehrt gleiche UIDs
# nur einmal). Erwartet ohne Fehler:
#   E189 ERGEBNIS fremd=1 kopie-neu=1 kopie-mit-alter-uid=0 eintraege=2
# GEMESSEN am 01.11.2026: rot an 7.2.1.130 (Quellstand 4593ab89*: zwei
# Eintraege mit uid=1, kopie-neu=0), gruen mit der Behebung (Bau 8c904144*).
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
    & $skript -Pfadfilter $Pfadfilter -OhneCopyuid
}
exit $LASTEXITCODE
