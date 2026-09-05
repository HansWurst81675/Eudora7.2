# Baut die Eudora-Projektmappe - und meldet Erfolg NUR dann, wenn auch
# wirklich gebaut worden ist.
#
#   powershell -ExecutionPolicy Bypass -File tools\bauen.ps1
#   powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Debug -Ziel Rebuild
#   powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -NurPruefen
#
#   -Konfiguration <Name>   Vorgabe Release. Geprueft wird gegen die .sln,
#                           nicht gegen eine Liste in diesem Skript.
#   -Plattform     <Name>   Vorgabe: die Plattform, die die .sln fuer diese
#                           Konfiguration kennt (in diesem Baum: x86).
#   -Ziel          Build | Rebuild | Clean     Vorgabe Build
#   -Protokoll     <Pfad>   Vorgabe Eudora71\Bin\bauen-<Konfiguration>.log
#   -NurPruefen             baut nicht, prueft nur die vorhandenen Artefakte
#   -Ausfuehrlich           listet jede gepruefte PE-Datei einzeln auf
#   -OhneZweitenGang        laesst den zweiten Gang weg (siehe unten)
#   -JedenFehlerZaehlen     auch die bekannten OT501-Fehler zaehlen mit
#   -BekannteFehlerAus <Projekt[]>
#                           Vorgabe OT501.vcxproj, Begruendung unten
#
# Rueckgabe: 0 = gebaut UND geprueft, 1 = FEHLER, 2 = Aufrufproblem.
# Warnungen allein aendern die Rueckgabe nicht.
#
# ACHTUNG beim Ablesen des Rueckgabewerts: in einer Pipe (etwa
# "... | tail -35") meldet die Shell den Wert des LETZTEN Glieds, nicht den
# des Skripts. Genau daran ist der Vorfall unten haengengeblieben. Also
# ohne Pipe aufrufen, oder in PowerShell $LASTEXITCODE unmittelbar danach
# lesen.
#
# Das Werkzeug startet nichts mit einem Fenster - kein devenv, kein Eudora.exe.
# Es ruft ausschliesslich MSBuild.exe ohne eigenes Fenster auf.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 05.09.2026 gingen in EINEM Bau-Lauf zwei Dinge schief, und beide haetten
# um ein Haar ein falsches Paket in die Auslieferung gebracht.
#
#   1. GERATENE PLATTFORM. Der Aufruf lautete -p:Platform=Win32. Die
#      Projektmappe kennt auf ihrer Ebene aber nur Debug|x86 und Release|x86 -
#      "Win32" steht erst eine Ebene tiefer, in den Projekten
#      (Eudora.sln, GlobalSection(ProjectConfigurationPlatforms):
#      "Release|x86.ActiveCfg = Release|Win32"). MSBuild brach ab mit
#
#          MSB4126: Die angegebene Projektmappenkonfiguration "Release|Win32"
#                   ist ungueltig.
#
#      Deshalb raet dieses Werkzeug NICHTS. Es liest beide Abbildungen aus der
#      .sln: die gueltigen Paare aus GlobalSection(SolutionConfigurationPlatforms)
#      und, fuer den zweiten Gang, die Zuordnung Projekt -> Projektkonfiguration
#      aus GlobalSection(ProjectConfigurationPlatforms). Verlangt jemand eine
#      Kombination, die dort nicht steht, wird sie aufgezaehlt und abgebrochen.
#
#   2. ERFOLG OHNE BAU - der schlimmere Fehler. Der Shell-Aufruf lieferte
#      EXITCODE 0 zurueck, obwohl MSBuild einen Fehler gemeldet und NICHTS
#      gebaut hatte. Nur eine zusaetzliche Handpruefung hat es aufgedeckt: in
#      der Eudora.exe stand noch 7.2.0.3, waehrend Version.h schon 7.2.0.4
#      sagte. Ein Bau-Werkzeug, das Erfolg meldet, ohne gebaut zu haben, ist
#      schlimmer als gar keines.
#
#      Dagegen stehen hier VIER voneinander unabhaengige Pruefungen, und jede
#      einzelne kann den Lauf zum Fehlschlag erklaeren:
#
#        a) Rueckgabewert. MSBuild wird ueber Start-Process -PassThru -Wait
#           gestartet und der Wert an $p.ExitCode abgelesen, nicht an
#           $LASTEXITCODE. $LASTEXITCODE gehoert der Pipeline, nicht dem
#           Programm - steht ein natives Programm hinter einer Umleitung oder
#           in einer Pipe, wird der Wert des letzten Glieds gemeldet. Das ist
#           die Stelle, an der der Wert am 05.09. verlorenging.
#
#        b) Fehlerprotokoll. MSBuild kann mit 0 zurueckkommen und trotzdem
#           Fehler gemeldet haben (das Metaprojekt einer Projektmappe
#           verschluckt sie gelegentlich). Deshalb laeuft neben dem
#           Hauptprotokoll ein zweiter Dateilogger mit ErrorsOnly und ein
#           dritter mit WarningsOnly. Gezaehlt werden Zeilen in diesen Dateien -
#           das ist sprachunabhaengig und braucht kein Suchmuster auf "error"
#           oder "Fehler", das an einer deutschen Visual-Studio-Installation
#           vorbeigeht. Die Ausgabe hier IST deutsch, das ist nachgemessen
#           ("2815 Warnung(en) / 0 Fehler").
#
#        c) Zeitstempel. Vor dem Bau wird eine Marke gesetzt (eine Datei, die
#           angelegt und sofort wieder geloescht wird - so kommt die Uhrzeit
#           vom Dateisystem und nicht aus einer anderen Quelle). Jedes
#           Artefakt, das danach nicht neuer ist als diese Marke, ist nicht
#           gebaut worden. Bei -Ziel Rebuild ist das immer ein Fehlschlag.
#           Bei -Ziel Build waere es ein Fehlalarm, wenn sich seit dem letzten
#           Bau nichts geaendert hat; deshalb wird dort zusaetzlich gegen den
#           juengsten Quelltext gemessen: ist eine Quelldatei neuer als das
#           Artefakt, ist es ein Fehlschlag, sonst eine ausdrueckliche Meldung
#           "unveraendert".
#
#        d) Versionsressource. Die FileVersion der gebauten Eudora.exe muss
#           EUDORA_BUILD_VERSION aus Eudora71\Version.h entsprechen, und die
#           Zahlen im festen Teil der Ressource muessen zu EUDORA_BUILD_NUMBER
#           passen. Genau diese Pruefung hat den Vorfall am 05.09. aufgedeckt -
#           und sie hat noch am selben Abend ein zweites Mal angeschlagen, als
#           waehrend eines laufenden Baus in einem geteilten Arbeitsbaum die
#           Version.h von 7.2.0.3 auf 7.2.0.4 wechselte. Die Meldung lautete:
#
#             Versionsressource der Eudora.exe ist "7.2.0.3",
#             Version.h sagt "7.2.0.4".
#
# ---------------------------------------------------------------------------
# DER ZWEITE GANG - warum ein einziger Projektmappen-Bau nicht reicht
# ---------------------------------------------------------------------------
#
# Gemessen am 05.09.2026, Release|x86: Der Bau der ganzen Projektmappe liefert
# 3 Fehler, alle aus OT501 (zweimal NMAKE U1073, einmal MSB3073) - der
# dokumentierte Blocker, PORTIERUNG.md, Abschnitt "Blocker: OT501". Sieben der
# neun ueberwachten Artefakte entstehen, aber Eudora.exe und EudoraRes.dll
# NICHT: beide Projekte fuehren OT501.vcxproj als Projektverweis
# (Eudora.vcxproj und EudoraRes.vcxproj), und MSBuild laesst ein Projekt aus,
# dessen Verweis gescheitert ist. Ohne Gegenmassnahme kommt aus einem
# Projektmappen-Bau also NIE eine Eudora.exe heraus.
#
# Die eingespielte Abhilfe steht seit Wochen in AUFGABEN.md ("Einzelprojekte
# brauchen /p:BuildProjectReferences=false") und musste bisher von Hand
# ausgefuehrt werden - eine Handarbeit, die genau dann vergessen wird, wenn es
# eilt. Deshalb macht dieses Werkzeug sie selbst: fehlt nach dem ersten Gang
# die Eudora.exe und sind ALLE Fehler bekannte OT501-Fehler, baut ein zweiter
# Gang EudoraRes.vcxproj und Eudora.vcxproj einzeln, mit
# /p:BuildProjectReferences=false und mit der PROJEKTkonfiguration
# (Release|Win32), die dafuer aus der .sln abgelesen wird. Gemessen am
# 05.09.2026: 5:02 Minuten, 0 Fehler, Eudora.exe 2 933 760 Byte.
# Abschalten mit -OhneZweitenGang.
#
# Die bekannten OT501-Fehler werden vollstaendig ausgegeben und in der Bilanz
# gezaehlt, machen den Lauf aber nicht allein zum Fehlschlag - sonst meldete
# das Werkzeug bei JEDEM Lauf Fehlschlag und waere als Freigabekriterium
# wertlos. Das ist derselbe Vorwurf, den Befund X-1 gegen Werkzeuge erhebt,
# die nur Fehlalarm liefern. Wer es streng will: -JedenFehlerZaehlen.
#
# ---------------------------------------------------------------------------
# NACHKONTROLLE DER ARTEFAKTE (eingebaut, kein getrenntes Werkzeug)
# ---------------------------------------------------------------------------
#
#   - Architektur: jede EXE, DLL, OCX und .eif im Ausgabeverzeichnis muss x86
#     sein.
#   - Debug-Laufzeiten: bei -Konfiguration Release darf keine Datei
#     mfc140d.dll, msvcp140d.dll, vcruntime140d.dll, vcruntime140_1d.dll oder
#     ucrtbased.dll importieren. Diese Dateien liegen bei Visual Studio unter
#     "debug_nonredist" und duerfen nicht weiterverteilt werden; an ihnen ist
#     Paket 1.0.2 mit 0xc000007b gescheitert (Befunde F-1 und S-8).
#
#     Gelesen wird dafuer die IMPORTTABELLE aus dem PE-Kopf, nicht die Datei
#     als Ganzes. Ein grep ueber die Bytes liefert Bruchstuecke wie "s.dll"
#     und "ts.dll" und damit Fehlalarme - dieser Fehler ist am 05.09. genau so
#     passiert. Der PE-Leser hier ist derselbe wie in
#     tools\paket-pruefen.ps1 und tools\laufzeit-holen.ps1.
#
#   - Versionsressource gegen Eudora71\Version.h, siehe d) oben.
#
# ---------------------------------------------------------------------------
# WARUM POWERSHELL UND NICHT PERL
# ---------------------------------------------------------------------------
#
# Die Werkzeuge in tools\ sind gemischt: was Text bearbeitet, ist Perl
# (aendere-zeile.pl, zeilenenden-angleichen.pl), was mit Windows redet, ist
# PowerShell (paket-pruefen.ps1, laufzeit-holen.ps1, paket-bauen.ps1). Dieses
# Werkzeug redet fast nur mit Windows: es startet einen Prozess und braucht
# dessen Rueckgabewert zuverlaessig, es liest Zeitstempel und Dateigroessen,
# es liest Versionsressourcen (System.Diagnostics.FileVersionInfo) und
# PE-Koepfe. Das ist alles ohne eine einzige zusaetzliche Abhaengigkeit da.
# Dazu kommt der ausschlaggebende Grund: der fertige, im Baum bereits
# bewaehrte PE-Leser aus paket-pruefen.ps1 laesst sich uebernehmen, statt ihn
# in Perl ein zweites Mal zu schreiben - ein zweiter PE-Leser waere eine
# zweite Fehlerquelle.
#
# ---------------------------------------------------------------------------
# KEINE RUECKFRAGEN
# ---------------------------------------------------------------------------
#
# Der Lauf darf nirgends auf eine Eingabe warten. Deshalb: kein Read-Host,
# kein pause, MSBuild mit /nologo /noautoresponse /nr:false, und die
# Standardeingabe jedes MSBuild-Laufs wird auf eine leere Datei gelegt. Wer
# dort etwas liest, bekommt sofort das Dateiende statt zu warten.

param(
  [string]$Konfiguration = 'Release',
  [string]$Plattform,
  [ValidateSet('Build','Rebuild','Clean')][string]$Ziel = 'Build',
  [string]$Protokoll,
  [switch]$NurPruefen,
  [switch]$Ausfuehrlich,
  [switch]$OhneZweitenGang,
  [switch]$JedenFehlerZaehlen,
  [string[]]$BekannteFehlerAus = @('OT501.vcxproj')
)

$ErrorActionPreference = 'Stop'

$wurzel = Split-Path -Parent $PSScriptRoot
$sln    = Join-Path $wurzel 'Eudora71\Eudora.sln'
$verH   = Join-Path $wurzel 'Eudora71\Version.h'

$fehler  = New-Object System.Collections.ArrayList
$warnung = New-Object System.Collections.ArrayList
function Melde-Fehler([string]$t)  { [void]$fehler.Add($t);  Write-Host ('  FEHLER   ' + $t) -ForegroundColor Red }
function Melde-Warnung([string]$t) { [void]$warnung.Add($t); Write-Host ('  Warnung  ' + $t) -ForegroundColor Yellow }
function Melde-Gut([string]$t)     { Write-Host ('  ok       ' + $t) -ForegroundColor Green }

# =========================================================== PE-Kopf lesen ==
#
# Uebernommen aus tools\paket-pruefen.ps1. Liefert Architektur und die Liste
# der importierten Module, oder $null, wenn die Datei kein PE ist.

function Lies-PE([string]$pfad) {
  $fs = $null
  try {
    $fs = [IO.File]::OpenRead($pfad)
    $br = New-Object IO.BinaryReader $fs
    if ($fs.Length -lt 64) { return $null }

    $fs.Position = 0
    if ($br.ReadUInt16() -ne 0x5A4D) { return $null }        # "MZ"

    $fs.Position = 60
    $peOff = $br.ReadInt32()
    if ($peOff -le 0 -or ($peOff + 24) -ge $fs.Length) { return $null }

    $fs.Position = $peOff
    if ($br.ReadUInt32() -ne 0x00004550) { return $null }    # "PE\0\0"

    $machine    = $br.ReadUInt16()
    $anzAbschn  = $br.ReadUInt16()
    $null       = $br.ReadUInt32()                           # TimeDateStamp
    $null       = $br.ReadUInt32()                           # PointerToSymbolTable
    $null       = $br.ReadUInt32()                           # NumberOfSymbols
    $groesseOpt = $br.ReadUInt16()
    $merkmale   = $br.ReadUInt16()

    $arch = switch ($machine) {
      0x014C  { 'x86' }
      0x8664  { 'x64' }
      0x01C4  { 'ARM' }
      0xAA64  { 'ARM64' }
      default { ('0x{0:X4}' -f $machine) }
    }

    $optOff = $peOff + 24
    $fs.Position = $optOff
    $magic = $br.ReadUInt16()
    # Datenverzeichnisse: PE32 ab Byte 96 des optionalen Kopfes, PE32+ ab 112.
    $ddOff = $optOff + 96
    if ($magic -eq 0x20B) { $ddOff = $optOff + 112 }

    # Abschnittstabelle, damit sich RVA in Dateioffsets umrechnen laesst.
    $abschnitte = @()
    $secOff = $optOff + $groesseOpt
    for ($i = 0; $i -lt $anzAbschn; $i++) {
      $p = $secOff + ($i * 40)
      if (($p + 40) -gt $fs.Length) { break }
      $fs.Position = $p + 8
      $vgroesse = $br.ReadUInt32()
      $vadr     = $br.ReadUInt32()
      $rgroesse = $br.ReadUInt32()
      $radr     = $br.ReadUInt32()
      $abschnitte += [pscustomobject]@{ VA=$vadr; VGroesse=$vgroesse; RGroesse=$rgroesse; RAdr=$radr }
    }

    function RvaZuOffset([uint32]$rva) {
      foreach ($a in $abschnitte) {
        $spanne = [Math]::Max($a.VGroesse, $a.RGroesse)
        if ($rva -ge $a.VA -and $rva -lt ($a.VA + $spanne)) {
          return [int64]($a.RAdr + ($rva - $a.VA))
        }
      }
      return -1
    }

    function Lies-Name([int64]$off) {
      if ($off -lt 0 -or $off -ge $fs.Length) { return $null }
      $fs.Position = $off
      $sb = New-Object System.Text.StringBuilder
      for ($k = 0; $k -lt 260; $k++) {
        if ($fs.Position -ge $fs.Length) { break }
        $b = $br.ReadByte()
        if ($b -eq 0) { break }
        [void]$sb.Append([char]$b)
      }
      if ($sb.Length -eq 0) { return $null }
      return $sb.ToString()
    }

    $noetig = New-Object System.Collections.ArrayList

    # --- gewoehnliche Importtabelle (Datenverzeichnis 1) ---
    $fs.Position = $ddOff + (1 * 8)
    $impRva = $br.ReadUInt32()
    $null   = $br.ReadUInt32()
    if ($impRva -ne 0) {
      $o = RvaZuOffset $impRva
      if ($o -ge 0) {
        for ($i = 0; $i -lt 2048; $i++) {
          $d = $o + ($i * 20)
          if (($d + 20) -gt $fs.Length) { break }
          $fs.Position = $d
          $oft = $br.ReadUInt32(); $null = $br.ReadUInt32(); $null = $br.ReadUInt32()
          $nameRva = $br.ReadUInt32(); $ft = $br.ReadUInt32()
          if ($oft -eq 0 -and $nameRva -eq 0 -and $ft -eq 0) { break }
          $n = Lies-Name (RvaZuOffset $nameRva)
          if ($n) { [void]$noetig.Add($n) }
        }
      }
    }

    # --- Verzoegerungstabelle (Datenverzeichnis 13) ---
    $fs.Position = $ddOff + (13 * 8)
    $delRva = $br.ReadUInt32()
    $null   = $br.ReadUInt32()
    if ($delRva -ne 0) {
      $o = RvaZuOffset $delRva
      if ($o -ge 0) {
        for ($i = 0; $i -lt 2048; $i++) {
          $d = $o + ($i * 32)
          if (($d + 32) -gt $fs.Length) { break }
          $fs.Position = $d
          $attr    = $br.ReadUInt32()
          $nameRva = $br.ReadUInt32()
          $modul   = $br.ReadUInt32()
          if ($attr -eq 0 -and $nameRva -eq 0 -and $modul -eq 0) { break }
          if (($attr -band 1) -eq 0) { continue }
          $n = Lies-Name (RvaZuOffset $nameRva)
          if ($n) { [void]$noetig.Add($n) }
        }
      }
    }

    return [pscustomobject]@{
      Arch   = $arch
      IstDll = (($merkmale -band 0x2000) -ne 0)
      Noetig = @($noetig)
    }
  } catch {
    return $null
  } finally {
    if ($fs) { $fs.Close() }
  }
}

# =============================================== A. Nichts raten, alles lesen

if (-not (Test-Path -LiteralPath $sln)) {
  Write-Host ('Projektmappe nicht gefunden: ' + $sln) -ForegroundColor Red
  exit 2
}
$sln = (Resolve-Path -LiteralPath $sln).Path
$slnOrdner = Split-Path -Parent $sln

# Drei Dinge werden aus der .sln gelesen, keines davon geraten:
#
#   1. GlobalSection(SolutionConfigurationPlatforms) - die gueltigen Paare
#          Release|x86 = Release|x86
#   2. Project(...) = "Name", "Pfad.vcxproj", "{GUID}"
#   3. GlobalSection(ProjectConfigurationPlatforms) - die Abbildung
#          {GUID}.Release|x86.Build.0 = Release|Win32
#      Erst daraus weiss der zweite Gang, dass ein EINZELNES Projekt
#      "Release|Win32" heisst, waehrend die Projektmappe "Release|x86" heisst.

$gueltig   = New-Object System.Collections.ArrayList
$projekte  = @{}   # GUID -> @{ Name; Pfad }
$projKonf  = @{}   # GUID + '|' + 'Release|x86' -> 'Release|Win32'

$abschnitt = ''
foreach ($z in (Get-Content -LiteralPath $sln)) {
  $t = $z.Trim()

  if ($t -match 'GlobalSection\(SolutionConfigurationPlatforms\)') { $abschnitt = 'konf'; continue }
  if ($t -match 'GlobalSection\(ProjectConfigurationPlatforms\)')  { $abschnitt = 'proj'; continue }
  if ($t -match '^EndGlobalSection') { $abschnitt = ''; continue }

  if ($t -match '^Project\(".*"\)\s*=\s*"([^"]*)"\s*,\s*"([^"]*)"\s*,\s*"(\{[^}]*\})"') {
    $projekte[$Matches[3].ToUpperInvariant()] = @{ Name = $Matches[1]; Pfad = $Matches[2] }
    continue
  }

  if ($abschnitt -eq 'konf') {
    $gleich = $t.IndexOf('=')
    if ($gleich -lt 1) { continue }
    $links  = $t.Substring(0, $gleich).Trim()
    $strich = $links.LastIndexOf('|')
    if ($strich -lt 1) { continue }
    [void]$gueltig.Add([pscustomobject]@{
      Konfiguration = $links.Substring(0, $strich)
      Plattform     = $links.Substring($strich + 1)
    })
    continue
  }

  if ($abschnitt -eq 'proj') {
    if ($t -match '^(\{[^}]*\})\.(.+)\.(ActiveCfg|Build\.0)\s*=\s*(.+)$') {
      $g = $Matches[1].ToUpperInvariant()
      $projKonf[($g + '|' + $Matches[2])] = $Matches[4].Trim()
    }
    continue
  }
}

if ($gueltig.Count -eq 0) {
  Write-Host 'In der .sln steht kein Abschnitt SolutionConfigurationPlatforms.' -ForegroundColor Red
  Write-Host ('  ' + $sln)
  exit 2
}

function Zeige-Gueltige {
  Write-Host ''
  Write-Host ('Gueltig sind laut ' + $sln + ' nur:')
  foreach ($g in $gueltig) { Write-Host ('    -Konfiguration ' + $g.Konfiguration + ' -Plattform ' + $g.Plattform) }
  Write-Host ''
  Write-Host 'Hinweis: "Win32" ist KEINE Plattform der Projektmappe. Win32 steht'
  Write-Host 'eine Ebene tiefer in den Projekten; die Projektmappe bildet x86'
  Write-Host 'darauf ab (GlobalSection(ProjectConfigurationPlatforms)).'
}

$passendeKonf = @($gueltig | Where-Object { $_.Konfiguration -eq $Konfiguration })
if ($passendeKonf.Count -eq 0) {
  Write-Host ('Unbekannte Konfiguration: "' + $Konfiguration + '"') -ForegroundColor Red
  Zeige-Gueltige
  exit 2
}

if (-not $Plattform) {
  if ($passendeKonf.Count -gt 1) {
    Write-Host ('Fuer "' + $Konfiguration + '" kennt die .sln mehrere Plattformen - bitte -Plattform angeben.') -ForegroundColor Red
    Zeige-Gueltige
    exit 2
  }
  $Plattform = $passendeKonf[0].Plattform
}

$treffer = @($gueltig | Where-Object { $_.Konfiguration -eq $Konfiguration -and $_.Plattform -eq $Plattform })
if ($treffer.Count -eq 0) {
  Write-Host ('Unbekannte Projektmappenkonfiguration: "' + $Konfiguration + '|' + $Plattform + '"') -ForegroundColor Red
  Write-Host 'Genau daran ist der Bau am 05.09.2026 gescheitert (MSB4126).' -ForegroundColor Red
  Zeige-Gueltige
  exit 2
}

$slnKonf = $Konfiguration + '|' + $Plattform
$ausgabe = Join-Path $wurzel ('Eudora71\Bin\' + $Konfiguration)

if (-not $Protokoll) {
  $Protokoll = Join-Path $wurzel ('Eudora71\Bin\bauen-' + $Konfiguration + '.log')
}
$protoOrdner = Split-Path -Parent $Protokoll
if ($protoOrdner -and -not (Test-Path -LiteralPath $protoOrdner)) {
  New-Item -ItemType Directory -Force -Path $protoOrdner | Out-Null
}

# Liefert Pfad und Projektkonfiguration eines Projekts, beides aus der .sln.
function Hole-Projekt([string]$name) {
  foreach ($g in $projekte.Keys) {
    if ($projekte[$g].Name -ne $name) { continue }
    $schluessel = $g + '|' + $slnKonf
    if (-not $projKonf.ContainsKey($schluessel)) { return $null }
    $pk = $projKonf[$schluessel]
    $strich = $pk.LastIndexOf('|')
    if ($strich -lt 1) { return $null }
    return [pscustomobject]@{
      Name          = $name
      Pfad          = (Join-Path $slnOrdner $projekte[$g].Pfad)
      Konfiguration = $pk.Substring(0, $strich)
      Plattform     = $pk.Substring($strich + 1)
    }
  }
  return $null
}

Write-Host ''
Write-Host '====================================================================='
Write-Host (' Eudora bauen   ' + $slnKonf + '   Ziel ' + $Ziel)
Write-Host '====================================================================='
Write-Host (' Projektmappe   ' + $sln)
Write-Host (' Ausgabe        ' + $ausgabe)
Write-Host (' Protokoll      ' + $Protokoll)
if ($NurPruefen) { Write-Host ' Modus          -NurPruefen: es wird NICHT gebaut' }
Write-Host ''

# --- MSBuild ueber vswhere finden -------------------------------------------

function Finde-MSBuild {
  $vswhereKandidaten = @(
    (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'),
    (Join-Path $env:ProgramFiles        'Microsoft Visual Studio\Installer\vswhere.exe'),
    (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Installer\vswhere.exe')
  )
  foreach ($vw in $vswhereKandidaten) {
    if (-not $vw) { continue }
    if (-not (Test-Path -LiteralPath $vw)) { continue }
    $pfade = @()
    try {
      $pfade = @(& $vw -latest -products '*' -requires 'Microsoft.Component.MSBuild' -property installationPath)
    } catch {
      $pfade = @()
    }
    foreach ($vs in $pfade) {
      if (-not $vs) { continue }
      foreach ($rel in @('MSBuild\Current\Bin\MSBuild.exe', 'MSBuild\15.0\Bin\MSBuild.exe')) {
        $m = Join-Path $vs $rel
        if (Test-Path -LiteralPath $m) {
          return [pscustomobject]@{ Pfad = $m; Quelle = ('vswhere: ' + $vw) }
        }
      }
    }
  }

  # Rueckfallebene - erst jetzt, und ausdruecklich als solche gemeldet.
  $festeListe = @()
  foreach ($basis in @($env:ProgramFiles, ${env:ProgramFiles(x86)})) {
    if (-not $basis) { continue }
    foreach ($jahr in @('2022','2019')) {
      foreach ($aus in @('Enterprise','Professional','Community','BuildTools','Preview')) {
        $festeListe += (Join-Path $basis ('Microsoft Visual Studio\' + $jahr + '\' + $aus + '\MSBuild\Current\Bin\MSBuild.exe'))
      }
    }
  }
  foreach ($m in $festeListe) {
    if (Test-Path -LiteralPath $m) {
      return [pscustomobject]@{ Pfad = $m; Quelle = 'Rueckfallebene: feste Pfadliste (vswhere hat nichts geliefert)' }
    }
  }
  return $null
}

$msbuild = $null
if (-not $NurPruefen) {
  $gefunden = Finde-MSBuild
  if (-not $gefunden) {
    Write-Host 'MSBuild.exe nicht gefunden - weder ueber vswhere noch in der Pfadliste.' -ForegroundColor Red
    exit 2
  }
  $msbuild = $gefunden.Pfad
  Write-Host (' MSBuild        ' + $msbuild)
  Write-Host (' gefunden ueber ' + $gefunden.Quelle)
  Write-Host ''
}

# ================================================================ B. Bauen ==

# Ein MSBuild-Lauf mit eigenem Protokolldreier. Liefert Rueckgabewert,
# Fehlerzeilen, Warnungszahl und Dauer - und wartet nie auf eine Eingabe.
function Starte-MSBuild([string[]]$eigeneArgumente, [string]$logBasis) {
  $logFehler = $logBasis + '.fehler'
  $logWarn   = $logBasis + '.warnungen'
  foreach ($alt in @($logBasis, $logFehler, $logWarn)) {
    if (Test-Path -LiteralPath $alt) { Remove-Item -LiteralPath $alt -Force }
  }

  $leereEingabe = Join-Path ([IO.Path]::GetTempPath()) ('bauen-stdin-' + [guid]::NewGuid().ToString('N') + '.tmp')
  Set-Content -LiteralPath $leereEingabe -Value '' -Encoding Ascii

  $env:MSBUILDDISABLENODEREUSE = '1'

  $alle = $eigeneArgumente + @(
    '/m', '/nologo', '/nr:false', '/noautoresponse', '/v:minimal', '/clp:Summary',
    '/fl',  ('"/flp:LogFile='   + $logBasis  + ';Verbosity=normal;Encoding=UTF-8"'),
    '/fl2', ('"/flp2:LogFile='  + $logFehler + ';ErrorsOnly;Encoding=UTF-8"'),
    '/fl3', ('"/flp3:LogFile='  + $logWarn   + ';WarningsOnly;Encoding=UTF-8"')
  )

  Write-Host ('Aufruf: MSBuild ' + ($alle -join ' '))
  Write-Host '---------------------------------------------------------------------'

  $uhr = [Diagnostics.Stopwatch]::StartNew()
  $p = Start-Process -FilePath $msbuild -ArgumentList $alle `
                     -NoNewWindow -PassThru -Wait `
                     -RedirectStandardInput $leereEingabe `
                     -WorkingDirectory $slnOrdner
  $p.WaitForExit()
  $uhr.Stop()

  Remove-Item -LiteralPath $leereEingabe -Force -ErrorAction Ignore
  Write-Host '---------------------------------------------------------------------'

  $fz = @()
  if (Test-Path -LiteralPath $logFehler) {
    $fz = @(Get-Content -LiteralPath $logFehler | Where-Object { $_.Trim().Length -gt 0 })
  }
  $wz = 0
  if (Test-Path -LiteralPath $logWarn) {
    $wz = @(Get-Content -LiteralPath $logWarn | Where-Object { $_.Trim().Length -gt 0 }).Count
  }

  return [pscustomobject]@{
    Rueck        = $p.ExitCode
    Fehlerzeilen = $fz
    Warnungen    = $wz
    Dauer        = $uhr.Elapsed
    Protokoll    = $logBasis
    Fehlerdatei  = $logFehler
    ProtokollDa  = (Test-Path -LiteralPath $logBasis)
  }
}

# Trennt bekannte von neuen Fehlern. Ausgegeben werden BEIDE Gruppen
# vollstaendig - verschwiegen wird nichts, nur die Bewertung ist verschieden.
function Werte-Lauf([object]$lauf, [string]$titel) {
  Write-Host ''
  Write-Host ('Auswertung: ' + $titel)

  if ($null -eq $lauf.Rueck) {
    Melde-Fehler ($titel + ': MSBuild hat keinen Rueckgabewert geliefert - der Lauf gilt als gescheitert.')
  } elseif ($lauf.Rueck -ne 0) {
    Write-Host ('  Hinweis  MSBuild-Rueckgabewert ' + $lauf.Rueck + ' - was das bedeutet, entscheiden die Zeilen darunter.')
  } else {
    Melde-Gut ($titel + ': MSBuild-Rueckgabewert 0')
  }

  if (-not $lauf.ProtokollDa) {
    Melde-Fehler ($titel + ': kein Protokoll geschrieben (' + $lauf.Protokoll + ') - MSBuild ist nicht bis zum Bauen gekommen.')
  }

  $neu = @()
  $alt = @()
  foreach ($f in $lauf.Fehlerzeilen) {
    $istBekannt = $false
    if (-not $JedenFehlerZaehlen) {
      foreach ($b in $BekannteFehlerAus) {
        if ($b -and $f.ToLowerInvariant().Contains($b.ToLowerInvariant())) { $istBekannt = $true }
      }
    }
    if ($istBekannt) { $alt += $f } else { $neu += $f }
  }

  if ($neu.Count -gt 0) {
    Melde-Fehler ($titel + ': ' + $neu.Count + ' Fehlermeldung(en) im Protokoll - unabhaengig vom Rueckgabewert')
    $zeige = $neu
    if ($zeige.Count -gt 20) { $zeige = $zeige[0..19] }
    foreach ($f in $zeige) { Write-Host ('             ' + $f) -ForegroundColor Red }
    if ($neu.Count -gt 20) {
      Write-Host ('             ... ' + ($neu.Count - 20) + ' weitere, siehe ' + $lauf.Fehlerdatei) -ForegroundColor Red
    }
  } else {
    Melde-Gut ($titel + ': keine unbekannte Fehlermeldung im Protokoll')
  }

  if ($alt.Count -gt 0) {
    Melde-Warnung ($titel + ': ' + $alt.Count + ' BEKANNTE Fehlermeldung(en) aus ' + ($BekannteFehlerAus -join ', ') +
                   ' - dokumentiert in PORTIERUNG.md, Abschnitt "Blocker: OT501". Mit -JedenFehlerZaehlen zaehlen sie mit.')
    foreach ($f in $alt) { Write-Host ('             ' + $f) -ForegroundColor Yellow }
  }

  # Wenn der Rueckgabewert ungleich 0 ist, aber KEINE Fehlerzeile dazu passt,
  # dann ist etwas geschehen, das der Logger nicht gesehen hat. Das darf nicht
  # durchrutschen.
  if ($null -ne $lauf.Rueck -and $lauf.Rueck -ne 0 -and $lauf.Fehlerzeilen.Count -eq 0) {
    Melde-Fehler ($titel + ': Rueckgabewert ' + $lauf.Rueck + ', aber keine einzige Fehlerzeile im Protokoll - unerklaert.')
  }

  Write-Host ('  Hinweis  ' + $lauf.Warnungen + ' Warnung(en), siehe ' + $lauf.Protokoll + '.warnungen')

  return [pscustomobject]@{ Neu = $neu.Count; Bekannt = $alt.Count }
}

$anzFehlerNeu = 0
$anzFehlerAlt = 0
$anzWarnung   = 0
$rueckMsb     = $null
$dauer        = [TimeSpan]::Zero
$bauBeginn    = Get-Date
$zweiterGang  = 'nicht noetig'

if (-not $NurPruefen) {

  # Bau-Beginn als Marke im Dateisystem festhalten. Absichtlich ueber eine
  # angelegte Datei und nicht ueber Get-Date: so kommt der Zeitstempel aus
  # derselben Quelle wie die Zeitstempel der Artefakte, gegen die spaeter
  # verglichen wird.
  $markeDatei = Join-Path ([IO.Path]::GetTempPath()) ('bauen-marke-' + [guid]::NewGuid().ToString('N') + '.tmp')
  Set-Content -LiteralPath $markeDatei -Value 'Marke' -Encoding Ascii
  $bauBeginn = (Get-Item -LiteralPath $markeDatei).LastWriteTime
  Remove-Item -LiteralPath $markeDatei -Force

  # ---------------------------------------------------- erster Gang --------
  $lauf1 = Starte-MSBuild @(
    ('"' + $sln + '"'),
    ('/t:' + $Ziel),
    ('/p:Configuration=' + $Konfiguration),
    ('/p:Platform=' + $Plattform)
  ) $Protokoll

  $bilanz1 = Werte-Lauf $lauf1 'Projektmappe'
  $rueckMsb      = $lauf1.Rueck
  $dauer         = $lauf1.Dauer
  $anzWarnung   += $lauf1.Warnungen
  $anzFehlerNeu += $bilanz1.Neu
  $anzFehlerAlt += $bilanz1.Bekannt

  # ---------------------------------------------------- zweiter Gang -------
  #
  # Nur wenn die Eudora.exe fehlt oder alt ist UND alle Fehler bekannte
  # OT501-Fehler sind. Bei einem echten Fehler waere ein zweiter Gang
  # Schoenrechnerei.
  $exe = Join-Path $ausgabe 'Eudora.exe'
  $exeFehlt = $true
  if (Test-Path -LiteralPath $exe) {
    $exeFehlt = ((Get-Item -LiteralPath $exe).LastWriteTime -lt $bauBeginn)
  }

  if ($Ziel -eq 'Clean') {
    $zweiterGang = 'entfaellt (Ziel Clean)'
  } elseif (-not $exeFehlt) {
    $zweiterGang = 'nicht noetig'
  } elseif ($OhneZweitenGang) {
    $zweiterGang = 'abgeschaltet (-OhneZweitenGang)'
    Melde-Warnung 'Eudora.exe ist nach dem ersten Gang nicht neu, der zweite Gang ist abgeschaltet.'
  } elseif ($bilanz1.Neu -gt 0) {
    $zweiterGang = 'ausgelassen (es gab unbekannte Fehler)'
    Melde-Warnung 'Zweiter Gang ausgelassen: der erste Gang hatte Fehler, die nicht bekannt sind. Die zuerst beheben.'
  } else {
    Write-Host ''
    Write-Host '====================================================================='
    Write-Host ' ZWEITER GANG'
    Write-Host '---------------------------------------------------------------------'
    Write-Host ' Eudora.exe ist nach dem Projektmappen-Bau nicht neu. Das ist der'
    Write-Host ' bekannte Fall: Eudora.vcxproj und EudoraRes.vcxproj fuehren'
    Write-Host ' OT501.vcxproj als Projektverweis, und MSBuild laesst ein Projekt'
    Write-Host ' aus, dessen Verweis gescheitert ist. Beide werden deshalb einzeln'
    Write-Host ' gebaut, mit /p:BuildProjectReferences=false.'
    Write-Host '====================================================================='

    $ok = $true
    $n = 0
    foreach ($pname in @('EudoraRes', 'Eudora')) {
      $pr = Hole-Projekt $pname
      if (-not $pr) {
        Melde-Fehler ('Projekt "' + $pname + '" steht nicht in der .sln oder hat keine Zuordnung fuer ' + $slnKonf + '.')
        $ok = $false
        continue
      }
      if (-not (Test-Path -LiteralPath $pr.Pfad)) {
        Melde-Fehler ('Projektdatei fehlt: ' + $pr.Pfad)
        $ok = $false
        continue
      }
      $n++
      $logN = Join-Path (Split-Path -Parent $Protokoll) (
                [IO.Path]::GetFileNameWithoutExtension($Protokoll) + '-gang2-' + $pname + [IO.Path]::GetExtension($Protokoll))
      Write-Host ''
      Write-Host (' ' + $pname + ': ' + $pr.Konfiguration + '|' + $pr.Plattform + '  (aus der .sln abgelesen, nicht geraten)')
      $lauf2 = Starte-MSBuild @(
        ('"' + $pr.Pfad + '"'),
        ('/t:' + $Ziel),
        ('/p:Configuration=' + $pr.Konfiguration),
        ('/p:Platform=' + $pr.Plattform),
        '/p:BuildProjectReferences=false'
      ) $logN
      $b2 = Werte-Lauf $lauf2 ('Zweiter Gang, ' + $pname)
      $dauer         = $dauer + $lauf2.Dauer
      $anzWarnung   += $lauf2.Warnungen
      $anzFehlerNeu += $b2.Neu
      $anzFehlerAlt += $b2.Bekannt
      if ($b2.Neu -gt 0) { $ok = $false }
    }
    if ($ok) { $zweiterGang = ('gelaufen, ' + $n + ' Projekte, ohne neue Fehler') }
    else     { $zweiterGang = ('gelaufen, ' + $n + ' Projekte, MIT Fehlern') }
  }
}

# ==================================================== C. Nachkontrolle =====

$artefakte = @()
$neuesteQuelleZwischen = $null

# Juengste Quelldatei unter Eudora71 - nur berechnen, wenn wirklich gebraucht.
function Hole-NeuesteQuelle {
  if ($null -ne $script:neuesteQuelleZwischen) { return $script:neuesteQuelleZwischen }
  $endungen = @('.c','.cpp','.cxx','.h','.hpp','.inc','.rc','.rc2','.idl','.def','.vcxproj','.props','.sln')
  $max = [datetime]'1990-01-01'
  $basis = Join-Path $wurzel 'Eudora71'
  Get-ChildItem -LiteralPath $basis -Recurse -File -ErrorAction Ignore |
    Where-Object {
      ($endungen -contains $_.Extension.ToLowerInvariant()) -and
      ($_.FullName -notmatch '\\(Bin|Lib|Build|ResBuild|\.vs|OT501__4|OT501___)\\')
    } |
    ForEach-Object { if ($_.LastWriteTime -gt $max) { $max = $_.LastWriteTime } }
  $script:neuesteQuelleZwischen = $max
  return $max
}

if ($Ziel -eq 'Clean' -and -not $NurPruefen) {
  Write-Host ''
  Write-Host 'Ziel Clean - eine Artefaktpruefung waere sinnlos und wird uebersprungen.'
} else {

  Write-Host ''
  Write-Host 'Artefakte'

  if (-not (Test-Path -LiteralPath $ausgabe -PathType Container)) {
    Melde-Fehler ('Ausgabeverzeichnis fehlt: ' + $ausgabe)
  } else {
    $ausgabe = (Resolve-Path -LiteralPath $ausgabe).Path

    # Pflichtstueck zuerst, danach die wichtigsten mitgebauten DLLs. Die Liste
    # deckt sich mit tools\paket-bauen.ps1 ("eigene"), ergaenzt um QCSSL.dll
    # und die Laufzeitbruecke msvcr71.dll aus VC71Bruecke.
    $sollDateien = @(
      'Eudora.exe', 'EudoraRes.dll', 'EuLang.dll', 'Imap.dll',
      'QCSocket.dll', 'QCUtils.dll', 'QCSSL.dll', 'plstclnt.dll', 'msvcr71.dll'
    )

    foreach ($d in $sollDateien) {
      $pfad = Join-Path $ausgabe $d
      if (-not (Test-Path -LiteralPath $pfad)) {
        if ($d -eq 'Eudora.exe') {
          Melde-Fehler ($d + ' fehlt im Ausgabeverzeichnis - es ist nichts gebaut worden.')
        } else {
          Melde-Fehler ($d + ' fehlt im Ausgabeverzeichnis.')
        }
        $artefakte += [pscustomobject]@{ Name=$d; Groesse=$null; Zeit=$null; Stand='FEHLT' }
        continue
      }
      $fi = Get-Item -LiteralPath $pfad
      $stand = ''
      if ($NurPruefen) {
        $stand = 'vorhanden'
      } elseif ($fi.LastWriteTime -ge $bauBeginn) {
        $stand = 'neu'
      } elseif ($Ziel -eq 'Rebuild') {
        $stand = 'NICHT NEU'
        Melde-Fehler ($d + ' ist trotz -Ziel Rebuild aelter als der Bau-Beginn (' +
                      $fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss') + ' < ' +
                      $bauBeginn.ToString('yyyy-MM-dd HH:mm:ss') + ') - es wurde nicht gebaut.')
      } else {
        $nq = Hole-NeuesteQuelle
        if ($fi.LastWriteTime -lt $nq) {
          $stand = 'VERALTET'
          Melde-Fehler ($d + ' ist aelter als der juengste Quelltext (' +
                        $fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss') + ' < ' +
                        $nq.ToString('yyyy-MM-dd HH:mm:ss') + ') - der Bau hat es nicht erneuert.')
        } else {
          $stand = 'unveraendert'
          Melde-Warnung ($d + ' wurde nicht neu geschrieben - es gab nichts zu tun (Zeitstempel ' +
                         $fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss') + ').')
        }
      }
      $artefakte += [pscustomobject]@{ Name=$d; Groesse=$fi.Length; Zeit=$fi.LastWriteTime; Stand=$stand }
    }

    # ----------------------------------------------- Architektur und Importe
    Write-Host ''
    Write-Host 'Nachkontrolle'

    $debugLaufzeiten = @('mfc140d.dll','msvcp140d.dll','vcruntime140d.dll','vcruntime140_1d.dll','ucrtbased.dll')

    $peDateien = @(Get-ChildItem -LiteralPath $ausgabe -Recurse -File -ErrorAction Ignore |
                   Where-Object { $_.Extension -match '^\.(dll|exe|ocx|eif)$' } |
                   Sort-Object FullName)

    $anzPE    = 0
    $nichtX86 = @()
    $mitDebug = @()
    foreach ($f in $peDateien) {
      $pe = Lies-PE $f.FullName
      if (-not $pe) { continue }
      $anzPE++
      if ($pe.Arch -ne 'x86') { $nichtX86 += ($f.Name + ' (' + $pe.Arch + ')') }
      if ($Konfiguration -eq 'Release') {
        foreach ($m in $pe.Noetig) {
          if ($debugLaufzeiten -contains $m.ToLowerInvariant()) {
            $mitDebug += ($f.Name + ' importiert ' + $m)
          }
        }
      }
      if ($Ausfuehrlich) {
        Write-Host ('             ' + $f.Name.PadRight(28) + ' ' + $pe.Arch + '  ' + $pe.Noetig.Count + ' Importe')
      }
    }

    if ($anzPE -eq 0) {
      Melde-Fehler ('Im Ausgabeverzeichnis liegt keine einzige lesbare PE-Datei: ' + $ausgabe)
    } elseif ($nichtX86.Count -gt 0) {
      Melde-Fehler ('nicht x86: ' + ($nichtX86 -join ', '))
    } else {
      Melde-Gut ('Architektur: ' + $anzPE + ' PE-Dateien, alle x86')
    }

    if ($Konfiguration -eq 'Release') {
      if ($mitDebug.Count -gt 0) {
        Melde-Fehler ('Debug-Laufzeit im Release-Bau: ' + ($mitDebug -join '; '))
      } elseif ($anzPE -gt 0) {
        Melde-Gut ('Debug-Laufzeiten: keine der ' + $anzPE + ' PE-Dateien importiert eine (Importtabelle gelesen, nicht gegrept)')
      }
    } else {
      Write-Host '  Hinweis  Debug-Laufzeiten werden nur bei -Konfiguration Release geprueft.'
    }

    # ------------------------------------------------ Versionsressource -----
    $exeP = Join-Path $ausgabe 'Eudora.exe'
    if (Test-Path -LiteralPath $exeP) {
      $sollVersion = $null
      $sollZahlen  = $null
      if (Test-Path -LiteralPath $verH) {
        foreach ($z in (Get-Content -LiteralPath $verH)) {
          if ($z -match '^\s*#define\s+EUDORA_BUILD_VERSION\s+"([^"]+)"') { $sollVersion = $Matches[1] }
          if ($z -match '^\s*#define\s+EUDORA_BUILD_NUMBER\s+(.+)$')      { $sollZahlen  = ($Matches[1].Trim() -replace '\s','') }
        }
      }
      if (-not $sollVersion) {
        Melde-Warnung ('EUDORA_BUILD_VERSION nicht aus ' + $verH + ' zu lesen - Versionsvergleich entfaellt.')
      } else {
        $vi = [Diagnostics.FileVersionInfo]::GetVersionInfo($exeP)
        $istVersion = ''
        if ($vi.FileVersion) { $istVersion = $vi.FileVersion.Trim([char]0).Trim() }
        $istZahlen = ('' + $vi.FileMajorPart + ',' + $vi.FileMinorPart + ',' + $vi.FileBuildPart + ',' + $vi.FilePrivatePart)

        if ($istVersion -ne $sollVersion) {
          Melde-Fehler ('Versionsressource der Eudora.exe ist "' + $istVersion + '", Version.h sagt "' + $sollVersion +
                        '". Entweder wurde nicht neu gebaut oder die Ressource nicht neu uebersetzt - beides ein Fehlschlag.')
        } else {
          Melde-Gut ('Version: Eudora.exe ' + $istVersion + ' = Version.h ' + $sollVersion)
        }
        if ($sollZahlen -and $istZahlen -ne $sollZahlen) {
          Melde-Fehler ('Fester Teil der Versionsressource ist ' + $istZahlen + ', EUDORA_BUILD_NUMBER sagt ' + $sollZahlen + '.')
        }
      }
    }
  }
}

# ================================================================= Bilanz ===

Write-Host ''
Write-Host '====================================================================='
Write-Host ' BILANZ'
Write-Host '---------------------------------------------------------------------'
Write-Host (' Konfiguration    ' + $slnKonf + '    Ziel ' + $Ziel)
if ($NurPruefen) {
  Write-Host ' Bau              uebersprungen (-NurPruefen)'
} else {
  Write-Host (' MSBuild          ' + $msbuild)
  Write-Host (' Rueckgabewert    ' + $rueckMsb + '  (erster Gang)')
  Write-Host (' Fehler           ' + $anzFehlerNeu + ' neu, ' + $anzFehlerAlt + ' bekannt (OT501)')
  Write-Host (' Warnungen        ' + $anzWarnung)
  Write-Host (' Dauer            ' + ('{0:00}:{1:00}:{2:00}' -f $dauer.Hours, $dauer.Minutes, $dauer.Seconds))
  Write-Host (' Zweiter Gang     ' + $zweiterGang)
  Write-Host (' Protokoll        ' + $Protokoll)
  Write-Host (' Fehlerliste      ' + $Protokoll + '.fehler')
}
if ($artefakte.Count -gt 0) {
  Write-Host '---------------------------------------------------------------------'
  Write-Host (' ' + 'Artefakt'.PadRight(16) + 'Groesse'.PadLeft(14) + '   ' + 'Zeitstempel'.PadRight(21) + 'Stand')
  foreach ($a in $artefakte) {
    $g = 'fehlt'
    $t = '-'
    if ($null -ne $a.Groesse) { $g = ('{0:N0} B' -f $a.Groesse) }
    if ($null -ne $a.Zeit)    { $t = $a.Zeit.ToString('yyyy-MM-dd HH:mm:ss') }
    Write-Host (' ' + $a.Name.PadRight(16) + $g.PadLeft(14) + '   ' + $t.PadRight(21) + $a.Stand)
  }
}
Write-Host '---------------------------------------------------------------------'
if ($fehler.Count -gt 0) {
  Write-Host (' ERGEBNIS: FEHLSCHLAG - ' + $fehler.Count + ' Fehler, ' + $warnung.Count + ' Warnungen') -ForegroundColor Red
  foreach ($f in $fehler) { Write-Host ('   - ' + $f) -ForegroundColor Red }
  Write-Host '====================================================================='
  Write-Host ''
  exit 1
}
Write-Host (' ERGEBNIS: ERFOLG - 0 Fehler, ' + $warnung.Count + ' Warnungen') -ForegroundColor Green
foreach ($w in $warnung) { Write-Host ('   - ' + $w) -ForegroundColor Yellow }
Write-Host '====================================================================='
Write-Host ''
exit 0
