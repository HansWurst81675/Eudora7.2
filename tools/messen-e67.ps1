# Laeuft unter testlauf.ps1 (-MessenSkript): oeffnet das Filterfenster
# (ID_WINDOW_FILTERS = 32826) und laesst es einige Sekunden stehen.
#
# WARUM ES DAS GIBT: Befund E-67 - eine Regel "Junk Score is less than N"
# wurde durch blosses Ansehen im Filterfenster zu "matches regexp N" und
# gespeichert. Die Behebung (">" -> ">=" in filtersv.cpp) steht seit
# 09.09.2026 im Code, war aber nie am laufenden Programm gemessen. Gemessen
# wird von aussen: vorher steht in Filters.pce als erste Regel "verb less",
# nachher muss es dort noch stehen (Auswertung im Aufrufer).
#
# Aufruf ueber testlauf.ps1:
#   tools\testlauf.ps1 -Verzeichnis C:\Temp\E118 -Freigabe "Gregor am <Datum>: ..." `
#       -MessenSkript tools\messen-e67.ps1
param([string] $Pfadfilter)
$t = $PSScriptRoot
& powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 32826 -Sekunden 8 | Select-Object -Last 3
Start-Sleep -Seconds 6
