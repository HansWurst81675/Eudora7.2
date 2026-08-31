# Holt die Debug-Laufzeiten von Visual Studio 2022 in ein Eudora-Verzeichnis.
#
#   powershell -ExecutionPolicy Bypass -File tools\laufzeit-holen.ps1 -Ziel "C:\Pfad\zu\Eudora"
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 30.08.2026 scheiterte der Start mit
#
#     0xc000007b - Die Anwendung konnte nicht korrekt gestartet werden
#
# Dieser Fehlercode heisst STATUS_INVALID_IMAGE_FORMAT und bedeutet fast immer
# BITNESS-KONFLIKT: eine 64-Bit-DLL in einem 32-Bit-Prozess oder umgekehrt.
# Eudora.exe ist ein 32-BIT-Programm (Debug|Win32).
#
# Die Falle: DLL-Sammelseiten wie dll-files.com liefern haeufig die
# 64-Bit-Fassung, ohne es deutlich zu machen. Und der 32-Bit-Systemordner heisst
# unter Windows ausgerechnet SysWOW64 - der Name legt das Gegenteil nahe.
#
#     C:\Windows\System32    -> 64-Bit-DLLs
#     C:\Windows\SysWOW64    -> 32-BIT-DLLs   <- die brauchen wir
#
# Auf einem Rechner mit installiertem Visual Studio 2022 liegen die passenden
# Debug-Laufzeiten dort bereits. Dieses Werkzeug kopiert sie und prueft jede
# Datei einzeln auf ihre Architektur nach - kopiert wird nur, was wirklich x86
# ist.

param(
  [Parameter(Mandatory=$true)][string]$Ziel,
  [switch]$NurPruefen
)

$noetig = @(
  'mfc140d.dll',        # MFC, Debug
  'msvcp140d.dll',      # C++-Standardbibliothek, Debug
  'vcruntime140d.dll',  # C-Laufzeit, Debug
  'ucrtbased.dll'       # Universal CRT, Debug
)
$freiwillig = @(
  'mfc140deu.dll',      # deutsche MFC-Zeichenketten
  'concrt140d.dll',     # Concurrency Runtime, von manchen Bauten gebraucht
  'vcruntime140_1d.dll' # zusaetzliche Entwirrungsdaten
)

function Architektur([string]$pfad) {
  try {
    $fs = [IO.File]::OpenRead($pfad)
    $br = New-Object IO.BinaryReader $fs
    $fs.Position = 0x3C
    $pe = $br.ReadInt32()
    $fs.Position = $pe + 4
    $m = $br.ReadUInt16()
    $br.Close(); $fs.Close()
    switch ($m) { 0x014c { 'x86' } 0x8664 { 'x64' } default { ('0x{0:X}' -f $m) } }
  } catch { 'unlesbar' }
}

if (-not (Test-Path -LiteralPath $Ziel)) {
  Write-Error "Zielverzeichnis nicht gefunden: $Ziel"
  exit 2
}

# Ist im Ziel ueberhaupt eine Eudora.exe, und welcher Bitness?
$exe = Join-Path $Ziel 'Eudora.exe'
if (Test-Path -LiteralPath $exe) {
  $a = Architektur $exe
  Write-Host ("Eudora.exe im Ziel: {0}" -f $a)
  if ($a -ne 'x86') {
    Write-Warning "Eudora.exe ist nicht x86 - dieses Werkzeug ist fuer den 32-Bit-Bau gedacht."
  }
} else {
  Write-Warning "Keine Eudora.exe in $Ziel - kopiere trotzdem."
}

$quelle = 'C:\Windows\SysWOW64'      # der 32-Bit-Ordner, trotz des Namens
Write-Host ("Quelle: {0}`n" -f $quelle)

$fehlend = @()
$kopiert = 0

foreach ($d in ($noetig + $freiwillig)) {
  $pflicht = $noetig -contains $d
  $q = Join-Path $quelle $d

  if (-not (Test-Path -LiteralPath $q)) {
    if ($pflicht) {
      Write-Host ("  {0,-22} FEHLT in {1}" -f $d, $quelle) -ForegroundColor Red
      $fehlend += $d
    } else {
      Write-Host ("  {0,-22} nicht vorhanden (freiwillig, kein Problem)" -f $d) -ForegroundColor DarkGray
    }
    continue
  }

  $arch = Architektur $q
  if ($arch -ne 'x86') {
    Write-Host ("  {0,-22} ist {1} - NICHT kopiert" -f $d, $arch) -ForegroundColor Red
    $fehlend += $d
    continue
  }

  $v = (Get-Item -LiteralPath $q).VersionInfo.FileVersion
  if ($NurPruefen) {
    Write-Host ("  {0,-22} x86  {1}" -f $d, $v) -ForegroundColor Green
  } else {
    Copy-Item -LiteralPath $q -Destination (Join-Path $Ziel $d) -Force
    $kopiert++
    Write-Host ("  {0,-22} x86  {1}  kopiert" -f $d, $v) -ForegroundColor Green
  }
}

Write-Host ''

if ($fehlend.Count -gt 0) {
  Write-Host 'NICHT VOLLSTAENDIG. Es fehlen:' -ForegroundColor Red
  $fehlend | ForEach-Object { Write-Host "  $_" }
  Write-Host ''
  Write-Host 'Diese Dateien gehoeren zu Visual Studio 2022 und liegen nur auf einem'
  Write-Host 'Rechner, auf dem es installiert ist (mit den C++-Werkzeugen und MFC/ATL).'
  Write-Host ''
  Write-Host 'NICHT von DLL-Sammelseiten herunterladen. Von dort kommen haeufig'
  Write-Host '64-Bit-Fassungen, und der Start scheitert dann mit 0xc000007b.'
  exit 1
}

if ($NurPruefen) {
  Write-Host 'Alle benoetigten Laufzeiten sind vorhanden und x86.' -ForegroundColor Green
} else {
  Write-Host ("Fertig: {0} Datei(en) nach {1} kopiert." -f $kopiert, $Ziel) -ForegroundColor Green
}
exit 0
