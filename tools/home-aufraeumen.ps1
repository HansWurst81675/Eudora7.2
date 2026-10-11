# home-aufraeumen.ps1 - raeumt weg, was am 10.09.2026 versehentlich in
# C:\Users\Gregor selbst gelandet ist.
#
# WARUM ES DAS GIBT
#
# Beim Ablegen von Paket 1.0.40 habe ich das ZIP nach C:\Users\Gregor
# entpackt statt in ein Unterverzeichnis. Das Paket-ZIP hat KEINE eigene
# Wurzelebene - die 157 Dateien sind dadurch direkt ins Benutzerverzeichnis
# gelaufen.
#
# Gemessen an der ERSTELLZEIT im Dateisystem (nicht am Zeitstempel, den
# Expand-Archive aus dem ZIP uebernimmt): 156 der 157 Dateien wurden um
# 12:05 NEU angelegt. Es lag dort vorher keine Eudora-Installation.
# Die einzige Ausnahme ist Mailverzeichnis\Eudora.ini - die gab es seit
# 09:21, und sie ist von der leeren Paketvorlage ueberschrieben worden.
#
# WAS ES TUT
#
#   1. Entfernt jede Datei, die im Paket-ZIP steht UND in Groesse und
#      Zeitstempel exakt damit uebereinstimmt. Weicht auch nur eines ab,
#      bleibt die Datei stehen und wird gemeldet.
#   2. Entfernt danach die Ordner Emoticons, Emoticons24, Emoticons32 und
#      Plugins - aber nur, wenn sie wirklich leer sind.
#   3. Mailverzeichnis\Eudora.ini wird NICHT geloescht, sondern durch die
#      Fassung aus Eudora72-1.0.36-release ersetzt. Dass genau die dorthin
#      gehoert, ist an den uebrigen Dateien nachgemessen: Junk.mbx
#      492 875 B, GMX.mbx 37 604 B und Filters.pce 404 B stimmen mit dem
#      Stand von 1.0.36 ueberein und mit keinem anderen.
#   4. Der Ordner Mailverzeichnis selbst und alles andere darin bleiben
#      unangetastet.
#
# Aufruf:
#   powershell -ExecutionPolicy Bypass -File tools\home-aufraeumen.ps1
#   ... -NurZeigen        zeigt nur an, aendert nichts
#
# Kodierung: reines ASCII, kein BOM.

[CmdletBinding()]
param(
    [string] $Heim  = 'C:\Users\Gregor',
    [string] $Zip   = 'C:\Users\Gregor\Documents\github\Eudora7.2\Releases\Eudora72-1.0.40-release.zip',
    [string] $IniQuelle = 'C:\Users\Gregor\Eudora72-1.0.36-release\Mailverzeichnis\Eudora.ini',
    [switch] $NurZeigen
)

$ErrorActionPreference = 'Stop'

# --- Erst pruefen, dann anfassen ------------------------------------------
$fehlt = @()
if (-not (Test-Path -LiteralPath $Heim)) { $fehlt += "Benutzerverzeichnis fehlt: $Heim" }
if (-not (Test-Path -LiteralPath $Zip))  { $fehlt += "Paket-ZIP fehlt: $Zip" }
if ($fehlt.Count -gt 0) {
    Write-Host ''
    Write-Host '  ABBRUCH - es wurde nichts angefasst:'
    foreach ($f in $fehlt) { Write-Host ("    " + $f) }
    Write-Host ''
    exit 1
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$archiv = [System.IO.Compression.ZipFile]::OpenRead($Zip)

# Die eine Datei, die NICHT geloescht, sondern ersetzt wird.
$dieIni = 'Mailverzeichnis\Eudora.ini'

$zumLoeschen = @()
$stehenLassen = @()
$nichtDa = 0

foreach ($e in $archiv.Entries) {
    if ($e.Name -eq '') { continue }
    if ($e.FullName -eq $dieIni) { continue }

    $p = Join-Path $Heim $e.FullName
    if (-not (Test-Path -LiteralPath $p)) { $nichtDa++; continue }

    $f  = Get-Item -LiteralPath $p -Force
    $dt = $e.LastWriteTime.DateTime

    if ($f.Length -eq $e.Length -and
        [math]::Abs(($f.LastWriteTime - $dt).TotalSeconds) -lt 3) {
        $zumLoeschen += $p
    } else {
        $stehenLassen += ("{0}  -  Paket {1} B {2:dd.MM. HH:mm}, vorhanden {3} B {4:dd.MM. HH:mm}" -f
                          $e.FullName, $e.Length, $dt, $f.Length, $f.LastWriteTime)
    }
}
$archiv.Dispose()

Write-Host ''
Write-Host '  Aufraeumen in ' -NoNewline; Write-Host $Heim
Write-Host  ('  ' + ('-' * 68))
Write-Host  ('  aus dem Paket, unveraendert - wird entfernt   {0,4}' -f $zumLoeschen.Count)
Write-Host  ('  weicht ab - bleibt stehen                     {0,4}' -f $stehenLassen.Count)
Write-Host  ('  gar nicht vorhanden                           {0,4}' -f $nichtDa)
Write-Host  ('  ' + ('-' * 68))

if ($stehenLassen.Count -gt 0) {
    Write-Host ''
    Write-Host '  BLEIBT STEHEN (weicht vom Paket ab - bitte selbst ansehen):'
    foreach ($s in $stehenLassen) { Write-Host ("    " + $s) }
}

if ($NurZeigen) {
    Write-Host ''
    Write-Host '  -NurZeigen: es wird nichts geaendert.'
    Write-Host ''
    exit 0
}

# --- 1. Dateien weg --------------------------------------------------------
$weg = 0
foreach ($p in $zumLoeschen) {
    Remove-Item -LiteralPath $p -Force
    $weg++
}
Write-Host ''
Write-Host ('  {0} Dateien entfernt' -f $weg)

# --- 2. Ordner weg, aber nur wenn leer ------------------------------------
foreach ($o in @('Emoticons', 'Emoticons24', 'Emoticons32', 'Plugins')) {
    $p = Join-Path $Heim $o
    if (-not (Test-Path -LiteralPath $p)) { continue }
    $rest = @(Get-ChildItem -LiteralPath $p -Force)
    if ($rest.Count -eq 0) {
        Remove-Item -LiteralPath $p -Force
        Write-Host ('  Ordner entfernt: {0}' -f $o)
    } else {
        Write-Host ('  Ordner BLEIBT (noch {0} Eintraege drin): {1}' -f $rest.Count, $o)
    }
}

# --- 3. Die ueberschriebene Eudora.ini zurueckstellen ---------------------
Write-Host ''
$ziel = Join-Path $Heim $dieIni
if (-not (Test-Path -LiteralPath $IniQuelle)) {
    Write-Host '  ACHTUNG: die Ersatzfassung fehlt -'
    Write-Host ('    ' + $IniQuelle)
    Write-Host '  Mailverzeichnis\Eudora.ini bleibt die leere Paketvorlage.'
} else {
    Copy-Item -LiteralPath $IniQuelle -Destination $ziel -Force
    $i = Get-Item -LiteralPath $ziel
    Write-Host ('  Mailverzeichnis\Eudora.ini zurueckgestellt aus 1.0.36 ({0} B)' -f $i.Length)
}

# --- Nachmessen ------------------------------------------------------------
Write-Host ''
Write-Host '  Was im Mailverzeichnis steht (unangetastet):'
$m = Join-Path $Heim 'Mailverzeichnis'
if (Test-Path -LiteralPath $m) {
    Get-ChildItem -LiteralPath $m -Filter *.mbx | Sort-Object Name | ForEach-Object {
        Write-Host ('    {0,-14} {1,10:N0} B' -f $_.Name, $_.Length)
    }
    foreach ($u in @('attach', 'Embedded')) {
        $p = Join-Path $m $u
        if (Test-Path -LiteralPath $p) {
            $n = @(Get-ChildItem -LiteralPath $p -File).Count
            Write-Host ('    {0,-14} {1,10} Dateien' -f $u, $n)
        }
    }
}
Write-Host ''
exit 0
