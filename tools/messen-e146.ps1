# messen-e146.ps1 - lehnt der Server das Umbenennen eines IMAP-Ordners ab,
# fuehrt Eudora den Ordner danach wieder unter seinem alten Namen?
# (Befund E-146, PRUEFER-50 K9)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, bekommt von dort
# -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem Pfad.
#
# WARUM ES DAS GIBT. CImapAccount::RenameMailbox benennt das lokale
# Verzeichnis und den Baumeintrag um, BEVOR der Server gefragt wird. Lehnte
# der Server ab, wurde die Aktion nur verworfen - Eudora fuehrte den Ordner
# unter einem Namen weiter, den es am Server nicht gibt. Seit 26.10.2026
# liest Eudora danach die Ordnerliste neu (CImapRenameMailboxAction::
# DoPostProcessing).
#
# Der Ablauf ist derselbe wie bei E-77d (tools\messen-e77-umbenennen.ps1),
# nur startet der Pruefserver mit --rename-ablehnen. pruefstand-lauf.ps1
# erlaubt je Fall nur ein Skript ohne Argumente, deshalb dieser Umschlag.
#
# Ausgabe: Zeilen "E77U ..." und am Ende
#   E146 ERGEBNIS rename=abgelehnt baum-neu=weg baum-alt=da liste=(kein Eintrag)
# Vor der Behebung erwartet: baum-neu=da und der neue Name in mboxlist.lst.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$skript = Join-Path $PSScriptRoot 'messen-e77-umbenennen.ps1'
if ($Vorbereiten) {
    & $skript -Pfadfilter $Pfadfilter -Vorbereiten
} else {
    & $skript -Pfadfilter $Pfadfilter -ServerLehntAb
}
exit $LASTEXITCODE
