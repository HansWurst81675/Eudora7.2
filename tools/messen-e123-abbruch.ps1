# messen-e123-abbruch.ps1 - laeuft unter testlauf.ps1 (-MessenSkript).
#
# WAS ES TUT
#
#   1. Abruf ausloesen (Befehl 32772) - damit beginnt die Uebertragung
#      lokal -> IMAP.
#   2. Ein paar Sekunden warten, waehrend der Pruefserver die Antwort
#      verzoegert (e118-serie.ps1 -GrussVerzoegerung).
#   3. Eudora ABSCHIESSEN, waehrend die Uebertragung noch aussteht.
#
# WARUM ES DAS GIBT
#
# Befund E-123. Das ORDENTLICHE Beenden ist seit 7.2.0.102 abgedeckt und
# wird von messen-e123.ps1 gemessen: "E-123 Beenden wartet", danach das
# Hochladen, danach "Warten zu Ende ... offen=0". Der Befund sagt aber
# ausdruecklich, was noch fehlt:
#
#     "der Verlust eingebetteter Bilder nach Absturz, Defender,
#      Stromausfall oder erzwungenem Herunterfahren. Abgearbeitet ist nur
#      der ordentliche Weg."
#
# Genau diesen Fall stellt dieses Skript her. Ein abgeschossener Prozess
# hat keine Gelegenheit zu warten - was dann mit den Schutzvermerken der
# eingebetteten Bilder geschieht, ist die offene Frage.
#
# NACH DEM PFAD GEFILTERT
#
# Abgeschossen wird NUR ein Prozess, dessen Programmdatei unter dem
# uebergebenen Pruefverzeichnis liegt. Ein pauschales Stop-Process auf
# "Eudora" wuerde Gregors eigene Sitzung treffen
# (Arbeitsweise/nichts-auf-gregors-bildschirm-starten.md). Dieselbe
# Pruefung wie in testlauf.ps1:154-163.
#
# Kodierung: reines ASCII, kein BOM.

param(
    [string] $Pfadfilter,
    [int]    $Sekunden = 5
)

$t = $PSScriptRoot

Write-Host '  messen-e123-abbruch: Abruf ausloesen'
& powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" `
    -Verzeichnis $Pfadfilter -Befehl 32772 -Sekunden 2 | Out-Null

Write-Host ("  messen-e123-abbruch: {0} s warten, dann abschiessen" -f $Sekunden)
Start-Sleep -Seconds $Sekunden

# Vollstaendiger Pfad des Pruefverzeichnisses, mit abschliessendem Trenner -
# sonst wuerde C:\Temp\E118x auch auf C:\Temp\E118 passen.
$voll = ''
try {
    $voll = (Resolve-Path -LiteralPath $Pfadfilter -ErrorAction Stop).Path
    if (-not $voll.EndsWith('\')) { $voll += '\' }
} catch {
    Write-Host '  messen-e123-abbruch: Pruefverzeichnis nicht aufloesbar - es wird NICHTS abgeschossen'
    return
}

$getroffen = 0
foreach ($p in (Get-Process -Name 'Eudora' -ErrorAction SilentlyContinue)) {
    $pf = ''
    try { $pf = $p.MainModule.FileName } catch { }
    if ($pf -ne '' -and $pf.StartsWith($voll, [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-Host ('  messen-e123-abbruch: ABSCHUSS PID ' + $p.Id + '  ' + $pf)
        Stop-Process -Id $p.Id -Force
        $getroffen++
    } else {
        Write-Host ('  messen-e123-abbruch: fremde Instanz bleibt unangetastet: PID ' + $p.Id)
    }
}

if ($getroffen -eq 0) {
    Write-Host '  messen-e123-abbruch: KEIN Prozess unter dem Pruefverzeichnis gefunden.'
    Write-Host '  Das ist KEIN Erfolg - dann hat die Messung nichts hergestellt.'
} else {
    Write-Host ("  messen-e123-abbruch: {0} Prozess(e) abgeschossen, Uebertragung stand noch aus" -f $getroffen)
}
