# Laeuft unter testlauf.ps1 (-MessenSkript): Abruf ausloesen (32772) und nach
# wenigen Sekunden zurueckkehren - testlauf.ps1 schickt danach WM_CLOSE, waehrend
# die Uebertragung des Filters nach IMAP noch aussteht.
#
# WARUM ES DAS GIBT: Befund E-123 - beim Beenden wurden ausstehende
# Uebertragungen lokal -> IMAP nur gespeichert und nach dem naechsten Start
# fortgesetzt; ueber den Neustart gingen Schutzvermerke der Bilder verloren.
# Seit 7.2.0.102 wartet das Beenden. Gemessen wird: "E-123 Beenden wartet",
# danach das Hochladen, danach "Warten zu Ende ... offen=0" und ExitInstance.
# Zusammen mit e118-serie.ps1 -GrussVerzoegerung <s>, damit die Uebertragung
# beim WM_CLOSE noch nicht durch ist.
param([string] $Pfadfilter)
$t = $PSScriptRoot
& powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 32772 -Sekunden 15 | Select-Object -Last 2
Start-Sleep -Seconds 4
