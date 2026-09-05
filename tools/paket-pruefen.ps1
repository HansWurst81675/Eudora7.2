# Prueft ein fertig ausgepacktes Eudora-Auslieferungspaket, BEVOR es jemand
# startet.
#
#   powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket "C:\Pfad\zum\ausgepackten\Paket"
#
#   -Ausfuehrlich   listet zusaetzlich jede Datei und jeden Import einzeln auf
#
# Rueckgabe: 0 = das Paket ist aus sich heraus startfaehig,
#            1 = FEHLER gefunden,
#            2 = Aufrufproblem.
# Warnungen allein aendern die Rueckgabe nicht.
#
# WELCHE FRAGE DIESES WERKZEUG BEANTWORTET
#
# Kriterium 0 aus ZIEL.md lautet woertlich:
#
#     "zip runterladen, entpacken, starten - laeuft. keine fehlenden DLLs,
#      keine fehlermeldungen, dass etwas nicht gefunden werden kann oder
#      nachinstalliert werden muss."
#
# Die Frage ist also NICHT "liegt Datei X irgendwo auf dieser Maschine", sondern
#
#     Kann dieses Paket auf einem Windows starten, auf dem nichts
#     nachinstalliert ist?
#
# Der Unterschied ist der ganze Sinn des Werkzeugs. Wer auf einem Rechner mit
# Visual Studio prueft, findet die Laufzeiten immer - dort liegen sie ohnehin
# herum. Ein Lauf auf so einer Maschine beweist gar nichts. Deshalb sieht dieses
# Werkzeug bewusst NICHT in SysWOW64 oder System32 nach: ein Treffer dort zaehlt
# nicht als "vorhanden", solange der Name nicht auf der Liste dessen steht, was
# jedes Windows von Haus aus mitbringt.
#
# Damit ersetzt der Lauf den zweiten Rechner - und ist der bessere Nachweis,
# weil er wiederholbar ist.
#
# WIE ES DAS MACHT
#
#   1. Architektur   - jede EXE, DLL und OCX im Paket muss x86 sein (PE-Kopf
#                      gelesen, dasselbe Verfahren wie in tools\laufzeit-holen.ps1).
#   2. Abhaengigkeiten - aus der Import- und der Verzoegerungstabelle im PE-Kopf
#                      jeder Paketdatei, transitiv weiterverfolgt: eine
#                      importierte DLL, die im Paket liegt, hat selbst wieder
#                      Importe. Jeder Name landet in genau einem von drei
#                      Toepfen: liegt im Paket / bringt Windows mit / FEHLT.
#                      Der dritte Topf ist die Antwort.
#   3. Debug-Laufzeiten - importiert eine Paketdatei mfc140d, msvcp140d,
#                      vcruntime140d, vcruntime140_1d, ucrtbased oder concrt140d,
#                      dann ist es ein Debug-Bau. Der darf nicht ausgeliefert
#                      werden: diese DLLs sind nicht weiterverteilbar
#                      (Befund S-8/E-8). Das ist ein FEHLER, keine Luecke, die
#                      man durch Mitliefern schliesst.
#   4. Pakethygiene  - keine .pdb im Release-Paket, Mailverzeichnis\Eudora.ini
#                      vorhanden (ohne INI bricht Eudora beim Start ab,
#                      eudora.cpp:3542, Befund S-1), "Eudora starten.cmd"
#                      vorhanden (Befund E-6).
#
# WAS FRUEHER FALSCH WAR (Befund PR-2.0)
#
#   - Die alte Fassung akzeptierte einen Treffer in SysWOW64/System32 kommentar-
#     los als "vorhanden". Gegenprobe eines Agenten: aus einer Paketkopie
#     mfc140.dll, msvcp140.dll und vcruntime140.dll geloescht -> "keine Fehler,
#     EXITCODE=0". Sie winkte genau den Fehler durch, an dem der Start am
#     31.08.2026 scheiterte.
#   - Die Laufzeitliste war fest verdrahtet und nannte die DEBUG-Laufzeiten. Bei
#     einem Release-Paket gab das vier Falschwarnungen, und die Abhilfe
#     (laufzeit-holen.ps1) holte die nicht verteilbaren Debug-DLLs ins Paket -
#     das Werkzeug leitete zu dem an, was es verhindern sollte.
#
# Das Werkzeug startet NICHTS. Es liest ausschliesslich Dateien.

param(
  [Parameter(Mandatory=$true)][string]$Paket,
  [switch]$Ausfuehrlich
)

$ErrorActionPreference = 'Continue'

if (-not (Test-Path -LiteralPath $Paket -PathType Container)) {
  Write-Error "Paketverzeichnis nicht gefunden: $Paket"
  exit 2
}
$Paket = (Resolve-Path -LiteralPath $Paket).Path

$fehler   = New-Object System.Collections.ArrayList
$warnung  = New-Object System.Collections.ArrayList

function Melde-Fehler([string]$t)  { [void]$fehler.Add($t) }
function Melde-Warnung([string]$t) { [void]$warnung.Add($t) }

# ---------------------------------------------------------------- PE lesen --
#
# Liefert ein Objekt mit Architektur und der Liste der benoetigten DLLs, oder
# $null, wenn die Datei kein PE ist.
#
# Gelesen wird der PE-Kopf, nicht der Dateiinhalt. Ein grep ueber die Datei
# waere falsch: es liefert Bruchstuecke wie "s.dll" oder "ts.dll", weil in der
# Zeichenkettentabelle Namen ohne Trennung aneinanderstossen. dumpbin scheidet
# ebenfalls aus - in der Git-Bash wird das Argument /imports zu einem Pfad
# verhunzt.

function Lies-PE([string]$pfad) {
  $fs = $null
  try {
    $fs = [IO.File]::OpenRead($pfad)
    $br = New-Object IO.BinaryReader $fs
    if ($fs.Length -lt 0x40) { return $null }

    $fs.Position = 0
    if ($br.ReadUInt16() -ne 0x5A4D) { return $null }        # "MZ"

    $fs.Position = 0x3C
    $peOff = $br.ReadInt32()
    if ($peOff -le 0 -or ($peOff + 24) -ge $fs.Length) { return $null }

    $fs.Position = $peOff
    $sig = $br.ReadUInt16()
    if ($sig -ne 0x4550) {                                   # nicht "PE"
      # Altlasten aus der Zeit vor Win32. Sie sind auf einem 64-Bit-Windows
      # ueberhaupt nicht ladbar - NTVDM gibt es dort nicht.
      if ($sig -eq 0x454E) {                                 # "NE"
        return [pscustomobject]@{ Arch='NE16'; IstDll=$true; Noetig=@() }
      }
      if ($sig -eq 0x454C -or $sig -eq 0x584C) {             # "LE" / "LX"
        return [pscustomobject]@{ Arch='LE16'; IstDll=$true; Noetig=@() }
      }
      return $null
    }
    $null = $br.ReadUInt16()                                 # "\0\0"

    $machine     = $br.ReadUInt16()
    $anzAbschn   = $br.ReadUInt16()
    $null        = $br.ReadUInt32()                          # TimeDateStamp
    $null        = $br.ReadUInt32()                          # PointerToSymbolTable
    $null        = $br.ReadUInt32()                          # NumberOfSymbols
    $groesseOpt  = $br.ReadUInt16()
    $merkmale    = $br.ReadUInt16()

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
    $ddOff = if ($magic -eq 0x20B) { $optOff + 112 } else { $optOff + 96 }

    # Abschnittstabelle einlesen, damit sich RVA in Dateioffsets umrechnen laesst.
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
          $attr = $br.ReadUInt32()
          $nameRva = $br.ReadUInt32()
          $modul = $br.ReadUInt32()
          if ($attr -eq 0 -and $nameRva -eq 0 -and $modul -eq 0) { break }
          # Bit 0 gesetzt: die Felder sind RVAs. Sonst absolute Adressen aus
          # der alten Fassung des Formats - die kann dieses Werkzeug nicht
          # umrechnen, sie kommen bei v143-Bauten aber nicht vor.
          if (($attr -band 1) -eq 0) { continue }
          $n = Lies-Name (RvaZuOffset $nameRva)
          if ($n) { [void]$noetig.Add("$n (verzoegert)") }
        }
      }
    }

    return [pscustomobject]@{
      Arch    = $arch
      IstDll  = (($merkmale -band 0x2000) -ne 0)
      Noetig  = @($noetig)
    }
  } catch {
    return $null
  } finally {
    if ($fs) { $fs.Close() }
  }
}

# ------------------------------------------------------------ Vorbereitung --

# NUR fuer den erklaerenden Nebensatz "liegt zwar auf DIESER Maschine". Auf das
# Urteil hat das keinen Einfluss - genau darin bestand der alte Fehler.
$sysWow = Join-Path $env:SystemRoot 'SysWOW64'
$sys32  = Join-Path $env:SystemRoot 'System32'

function Auf-Dieser-Maschine([string]$name) {
  if (Test-Path -LiteralPath (Join-Path $sysWow $name)) { return 'SysWOW64' }
  if (Test-Path -LiteralPath (Join-Path $sys32  $name)) { return 'System32' }
  return $null
}

# Was jedes Windows von Haus aus mitbringt. Nur Namen, die auf einer frisch
# aufgesetzten Maschine ohne jede Nachinstallation da sind.
#
# Verglichen wird der Name OHNE Endung, deshalb deckt 'winspool' auch
# winspool.drv ab. 'msvcrt' gehoert zu Windows; die numerierten Geschwister
# msvcr71, msvcr100, msvcr120 ... dagegen NICHT - die kommen mit Visual Studio
# und sind hier absichtlich nicht aufgefuehrt.
$windowsEigen = @(
  'kernel32','kernelbase','user32','gdi32','gdi32full','advapi32','shell32',
  'shlwapi','ole32','oleaut32','comctl32','comdlg32','ws2_32','wsock32',
  'wininet','version','winspool','imm32','msimg32','rpcrt4','crypt32',
  'secur32','netapi32','mpr','uxtheme','dbghelp','psapi','userenv','wtsapi32',
  'iphlpapi','dnsapi','winmm','mshtml','urlmon','oleacc','olepro32','rasapi32',
  'rasdlg','msvfw32','pdh','setupapi','riched20','riched32','odbc32','winhttp',
  'dwmapi','powrprof','mapi32','ntdll','msvcrt',
  # Die folgenden drei tauchten beim ersten Lauf gegen 1.0.12 auf und wurden
  # einzeln nachgewiesen, statt sie zu vermuten:
  #   gdiplus  - WinSxS-Paket microsoft.windows.gdiplus.systemcopy,
  #              Fassung 10.0.19041.6456, Hersteller Microsoft Windows.
  #   oledlg   - ProductName "Microsoft Windows Operating System",
  #              Fassung 10.0.19041.5794, also mit dem Windows-Bau versioniert.
  #   mfc42    - WinSxS-Paket microsoft-windows-mfc42x mit dem
  #              Windows-Herausgeberschluessel 31bf3856ad364e35, dazu
  #              wow64_microsoft-windows-mfc42x fuer die 32-Bit-Fassung.
  #              Windows liefert MFC 4.2 aus Ruecksicht auf alte Programme
  #              weiterhin mit - anders als MFC 7.1, siehe $bekannteLuecken.
  'gdiplus','oledlg','mfc42','mfc42u'
)
$windowsEigenNachschlag = @{}
foreach ($w in $windowsEigen) { $windowsEigenNachschlag[$w] = $true }

# Debug-Laufzeiten von Visual Studio. Nicht weiterverteilbar - ihr Auftauchen
# ist ein FEHLER, nicht eine Luecke, die man durch Mitliefern schliesst.
$debugLaufzeiten = @(
  'mfc140d','mfc140ud','msvcp140d','msvcp140_1d','msvcp140_2d','vcruntime140d',
  'vcruntime140_1d','ucrtbased','concrt140d','mfcm140d','mfc140chs','msvcr140d'
)
$debugNachschlag = @{}
foreach ($d in $debugLaufzeiten) { $debugNachschlag[$d] = $true }

# Bekannte, erwartete Luecken: die C-Laufzeit von Visual Studio .NET 2003.
# Microsoft hat MFC71.DLL und MSVCP71.dll nie als Redistributable
# veroeffentlicht. Sie kosten Adressbuch, LDAP, Ph und S/MIME - NICHT den Start.
# Deshalb werden sie gesondert gemeldet und nicht mit echten Startfehlern
# vermischt.
$bekannteLuecken = @{
  'mfc71'   = 'MFC 7.1 (VS.NET 2003) - von Microsoft nie als Redistributable veroeffentlicht'
  'msvcp71' = 'C++-Standardbibliothek 7.1 (VS.NET 2003) - dito'
  'mfc71u'  = 'MFC 7.1 Unicode (VS.NET 2003) - dito'
}

Write-Host ''
Write-Host "Paket:  $Paket"
Write-Host ''
Write-Host 'Frage:  Kann dieses Paket auf einem Windows starten, auf dem'
Write-Host '        NICHTS nachinstalliert ist? (Kriterium 0 aus ZIEL.md)'
Write-Host ''
Write-Host 'Hinweis: Ein Treffer in SysWOW64 oder System32 zaehlt hier NICHT'
Write-Host '        als "vorhanden". Deshalb ist dieser Lauf unabhaengig davon,'
Write-Host '        was auf der pruefenden Maschine installiert ist.'
Write-Host ''

$binaer = Get-ChildItem -LiteralPath $Paket -Recurse -File |
          Where-Object { $_.Extension -match '^\.(dll|exe|ocx|drv|vxd)$' } |
          Sort-Object FullName

if ($binaer.Count -eq 0) {
  Melde-Fehler "Im Paket liegt keine einzige EXE oder DLL."
}

# Namen aller Binaerdateien im Paketwurzelverzeichnis. Der Lader sucht beim
# Aufloesen eines Importnamens im Verzeichnis der EXE, nicht in
# Unterverzeichnissen - Plugins\ zaehlt also nicht als Fundort. (Die Plugins
# selbst laedt Eudora mit vollem Pfad; ihre EIGENEN Importe werden aber wieder
# im Verzeichnis der EXE gesucht, deshalb werden sie hier mitgeprueft.)
$imPaket = @{}
foreach ($f in (Get-ChildItem -LiteralPath $Paket -File)) {
  $imPaket[$f.Name.ToLowerInvariant()] = $true
}
# Binaerdateien in Unterverzeichnissen - fuer den Hinweis "liegt zwar im Paket,
# aber an einer Stelle, an der der Lader nicht sucht".
$imUnterverzeichnis = @{}
foreach ($f in $binaer) {
  $rel = $f.FullName.Substring($Paket.Length).TrimStart('\')
  if ($rel -match '\\') { $imUnterverzeichnis[$f.Name.ToLowerInvariant()] = $rel }
}

# --------------------------------------------------- 1. Architekturpruefung --

Write-Host '1. ARCHITEKTUR (jede EXE, DLL und OCX muss x86 sein)'
Write-Host '   ------------------------------------------------'

$keinPE = @()
$sechzehnBit = @()
$peInfo = @{}
$falscheArch = 0

foreach ($f in $binaer) {
  $rel = $f.FullName.Substring($Paket.Length).TrimStart('\')
  $pe = Lies-PE $f.FullName
  if (-not $pe) {
    $keinPE += $rel
    continue
  }
  $peInfo[$rel] = $pe
  if ($pe.Arch -eq 'NE16' -or $pe.Arch -eq 'LE16') {
    $sechzehnBit += $rel
    Write-Host ("   {0,-38} 16 Bit ({1})" -f $rel, $pe.Arch) -ForegroundColor Yellow
    continue
  }
  if ($pe.Arch -ne 'x86') {
    Melde-Fehler ("{0} ist {1}, erwartet x86 - das gibt beim Start 0xc000007b" -f $rel, $pe.Arch)
    Write-Host ("   {0,-38} {1}   FALSCH" -f $rel, $pe.Arch) -ForegroundColor Red
    $falscheArch++
  } elseif ($Ausfuehrlich) {
    Write-Host ("   {0,-38} x86" -f $rel) -ForegroundColor DarkGray
  }
}

foreach ($k in $keinPE) {
  Melde-Warnung ("$k ist keine gueltige PE-Datei (Kopf nicht lesbar).")
}

# 16-Bit-Altlasten aus der Zeit vor Win32. Auf einem 64-Bit-Windows laesst sich
# so eine Datei nicht laden - es gibt dort kein NTVDM. Sie schaden nur, wenn sie
# jemand braucht; sonst sind sie totes Gewicht.
foreach ($k in $sechzehnBit) {
  $name = [IO.Path]::GetFileName($k).ToLowerInvariant()
  $braucht = @()
  foreach ($rel in $peInfo.Keys) {
    foreach ($n in $peInfo[$rel].Noetig) {
      $bn = $n
      if ($bn.EndsWith(' (verzoegert)')) { $bn = $bn.Substring(0, $bn.Length - 13) }
      if ($bn.ToLowerInvariant() -eq $name) { $braucht += $rel }
    }
  }
  if ($braucht.Count -eq 0) {
    Melde-Warnung ("$k ist eine 16-Bit-Datei aus der Zeit vor Win32 und laesst sich auf einem 64-Bit-Windows nicht laden. Keine Paketdatei importiert sie - totes Gewicht.")
  } else {
    $wer = ($braucht | Sort-Object -Unique) -join ', '
    Write-Host ("   {0} ist 16 Bit und wird gebraucht von {1}" -f $k, $wer) -ForegroundColor Red
    Melde-Fehler ("$k ist 16 Bit und laesst sich auf einem 64-Bit-Windows nicht laden, wird aber importiert von: $wer")
  }
}

if ($falscheArch -eq 0) {
  $anzX86 = $peInfo.Count - $sechzehnBit.Count
  Write-Host ("   {0} von {1} Binaerdateien sind x86, keine falsche Architektur." -f $anzX86, $peInfo.Count) -ForegroundColor Green
}
Write-Host ''

# --------------------------------------- 2. Abhaengigkeitshuelle einsortieren --

Write-Host '2. ABHAENGIGKEITEN (transitiv, aus den PE-Importtabellen)'
Write-Host '   -----------------------------------------------------'

# Jeder Importname landet in genau einem Topf:
#   Paket    - die Datei liegt im Wurzelverzeichnis des Pakets
#   Windows  - der Name steht auf der Liste dessen, was jedes Windows mitbringt
#   Fehlt    - weder noch. DAS ist die Antwort auf Kriterium 0.
function Klassifiziere([string]$name) {
  $n = $name.ToLowerInvariant()
  if ($imPaket.ContainsKey($n)) { return 'Paket' }
  if ($n -like 'api-ms-win-*' -or $n -like 'ext-ms-*') { return 'Windows' }
  $basis = [IO.Path]::GetFileNameWithoutExtension($n)
  if ($windowsEigenNachschlag.ContainsKey($basis)) { return 'Windows' }
  return 'Fehlt'
}

# Namen der Paketdateien im Wurzelverzeichnis auf ihren relativen Pfad abbilden.
$relVonName = @{}
foreach ($rel in $peInfo.Keys) {
  if ($rel -notmatch '\\') { $relVonName[$rel.ToLowerInvariant()] = $rel }
}

# DIE STARTKETTE - die transitive Huelle dessen, was der Lader anfassen MUSS,
# bevor die erste Zeile eigener Code laeuft.
#
# Wurzel ist die EXE, die "Eudora starten.cmd" aufruft: Eudora.exe. Von dort aus
# wird jedem GEWOEHNLICHEN (nicht verzoegerten) Import gefolgt, der auf eine
# Datei im Paket zeigt; die hat selbst wieder Importe. Alles ausserhalb dieser
# Huelle laedt Eudora erst bei Benutzung ueber LoadLibrary oder COM - ein dort
# fehlendes Stueck legt eine Funktion lahm, aber nicht den Start.
#
# Das ist der Unterschied zwischen "startet nicht" und "eine Zusatzfunktion
# fehlt", und er entscheidet ueber FEHLER oder Warnung.
$startWurzeln = @()
foreach ($rel in $peInfo.Keys) {
  if ($rel -eq 'Eudora.exe') { $startWurzeln += $rel }
}
if ($startWurzeln.Count -eq 0) {
  # Kein Eudora.exe? Dann ist jede EXE im Wurzelverzeichnis eine moegliche Wurzel.
  foreach ($rel in $peInfo.Keys) {
    if ($rel -notmatch '\\' -and $rel -match '\.exe$') { $startWurzeln += $rel }
  }
}

$startkette = @{}
$rand = New-Object System.Collections.Queue
foreach ($rel in $startWurzeln) {
  $startkette[$rel] = $true
  $rand.Enqueue($rel)
}
while ($rand.Count -gt 0) {
  $rel = $rand.Dequeue()
  foreach ($n in $peInfo[$rel].Noetig) {
    if ($n.EndsWith(' (verzoegert)')) { continue }
    $k = $n.ToLowerInvariant()
    if ($relVonName.ContainsKey($k)) {
      $ziel = $relVonName[$k]
      if (-not $startkette.ContainsKey($ziel)) {
        $startkette[$ziel] = $true
        $rand.Enqueue($ziel)
      }
    }
  }
}

$fehlend      = @{}   # fehlt in der Startkette              -> FEHLER
$fehlendSpaet = @{}   # fehlt erst bei Benutzung             -> Warnung
$luecken      = @{}   # bekannte, erwartete Luecke           -> gesonderte Meldung
$debugTreffer = @{}   # Import auf eine Debug-Laufzeit       -> FEHLER
$ausPaket     = 0
$ausWindows   = 0
$nameAusPaket   = @{}   # verschiedene Namen, nicht Nennungen
$nameAusWindows = @{}

foreach ($rel in ($peInfo.Keys | Sort-Object)) {
  foreach ($n in $peInfo[$rel].Noetig) {
    $verz = $n.EndsWith(' (verzoegert)')
    $name = if ($verz) { $n.Substring(0, $n.Length - 13) } else { $n }
    $basis = [IO.Path]::GetFileNameWithoutExtension($name.ToLowerInvariant())

    if ($debugNachschlag.ContainsKey($basis)) {
      if (-not $debugTreffer.ContainsKey($name)) { $debugTreffer[$name] = @() }
      $debugTreffer[$name] += $rel
      continue
    }

    $topf = Klassifiziere $name
    if ($topf -eq 'Paket')   { $ausPaket++;   $nameAusPaket[$name.ToLowerInvariant()]   = $true }
    if ($topf -eq 'Windows') { $ausWindows++; $nameAusWindows[$name.ToLowerInvariant()] = $true }
    if ($topf -ne 'Fehlt') {
      if ($Ausfuehrlich) {
        Write-Host ("   {0,-30} <- {1,-34} {2}" -f $name, $rel, $topf) -ForegroundColor DarkGray
      }
      continue
    }

    if ($bekannteLuecken.ContainsKey($basis)) {
      if (-not $luecken.ContainsKey($name)) { $luecken[$name] = @() }
      $luecken[$name] += $rel
      continue
    }

    $imStart = $startkette.ContainsKey($rel) -and (-not $verz)
    $topfZiel = if ($imStart) { $fehlend } else { $fehlendSpaet }
    if (-not $topfZiel.ContainsKey($name)) { $topfZiel[$name] = @() }
    $topfZiel[$name] += $rel
  }
}

Write-Host ("   {0} Binaerdatei(en) im Paket, davon {1} in der Startkette." -f $peInfo.Count, $startkette.Count)
Write-Host ("   Importe aufgeloest: {0} aus dem Paket ({1} verschiedene), {2} von Windows ({3} verschiedene)." -f $ausPaket, $nameAusPaket.Count, $ausWindows, $nameAusWindows.Count)
if ($Ausfuehrlich) {
  Write-Host '   Startkette:'
  ($startkette.Keys | Sort-Object) | ForEach-Object { Write-Host "     $_" -ForegroundColor DarkGray }
  # Diese Liste gehoert nachgelesen: jeder Name hier ist eine Behauptung, dass
  # Windows die Datei von Haus aus mitbringt. Steht etwas Falsches darin, faellt
  # das Urteil zu guenstig aus.
  Write-Host '   Als "bringt Windows mit" eingestuft:'
  ($nameAusWindows.Keys | Sort-Object) | ForEach-Object { Write-Host "     $_" -ForegroundColor DarkGray }
}

if ($fehlend.Count -eq 0) {
  Write-Host '   In der Startkette fehlt nichts.' -ForegroundColor Green
}

foreach ($n in ($fehlend.Keys | Sort-Object)) {
  $wer = ($fehlend[$n] | Sort-Object -Unique) -join ', '
  Write-Host ("   FEHLT BEIM START: {0,-22} gebraucht von {1}" -f $n, $wer) -ForegroundColor Red
  $zusatz = ''
  $wo = Auf-Dieser-Maschine $n
  if ($wo) {
    $zusatz = " (liegt zwar im $wo DIESER Maschine - das zaehlt nicht, auf einem frischen Windows ist sie nicht da)"
    Write-Host ("                     liegt zwar in {0} dieser Maschine - zaehlt nicht." -f $wo) -ForegroundColor DarkYellow
  }
  if ($imUnterverzeichnis.ContainsKey($n.ToLowerInvariant())) {
    $zusatz += (" (liegt im Paket unter {0} - dort sucht der Lader nicht)" -f $imUnterverzeichnis[$n.ToLowerInvariant()])
  }
  Melde-Fehler ("$n fehlt im Paket und gehoert nicht zu Windows; der Lader braucht sie VOR dem ersten Befehl - von: $wer$zusatz")
}
foreach ($n in ($fehlendSpaet.Keys | Sort-Object)) {
  $wer = ($fehlendSpaet[$n] | Sort-Object -Unique) -join ', '
  Write-Host ("   fehlt, erst bei Benutzung: {0,-13} {1}" -f $n, $wer) -ForegroundColor Yellow
  Melde-Warnung ("$n fehlt im Paket und gehoert nicht zu Windows. Der Start ist davon nicht betroffen; ausfallen wird: $wer")
}
Write-Host ''

# ------------------------------------------------ 3. Debug-Laufzeiten       --

Write-Host '3. DEBUG-LAUFZEITEN (duerfen nicht ausgeliefert werden)'
Write-Host '   ---------------------------------------------------'

$istDebugBau = ($debugTreffer.Count -gt 0)
if (-not $istDebugBau) {
  Write-Host '   Keine Paketdatei importiert eine Debug-Laufzeit - Release-Bau.' -ForegroundColor Green
} else {
  foreach ($n in ($debugTreffer.Keys | Sort-Object)) {
    $wer = ($debugTreffer[$n] | Sort-Object -Unique) -join ', '
    Write-Host ("   DEBUG-LAUFZEIT: {0,-22} importiert von {1}" -f $n, $wer) -ForegroundColor Red
  }
  Melde-Fehler ("Debug-Bau: {0} Debug-Laufzeit(en) werden importiert ({1}). Diese DLLs sind nicht weiterverteilbar (Befund S-8/E-8) - das Paket darf so nicht ausgeliefert werden. Abhilfe ist ein Release-Bau, NICHT das Mitliefern der Debug-DLLs." -f $debugTreffer.Count, (($debugTreffer.Keys | Sort-Object) -join ', '))
  Write-Host ''
  Write-Host '   Abhilfe: Release-Bau. Die Debug-DLLs mitzuliefern waere ein' -ForegroundColor Yellow
  Write-Host '   Lizenzverstoss - tools\laufzeit-holen.ps1 ist hier NICHT die' -ForegroundColor Yellow
  Write-Host '   Loesung.' -ForegroundColor Yellow
}
Write-Host ''

# ------------------------------------------------ 4. Pakethygiene           --

Write-Host '4. PAKETHYGIENE'
Write-Host '   ------------'

$pdb = @(Get-ChildItem -LiteralPath $Paket -Recurse -File -Filter '*.pdb' -ErrorAction Ignore)
if ($pdb.Count -eq 0) {
  Write-Host '   keine .pdb im Paket' -ForegroundColor Green
} elseif ($istDebugBau) {
  Write-Host ("   {0} .pdb im Paket - bei einem Debug-Bau erwartet" -f $pdb.Count) -ForegroundColor Yellow
  Melde-Warnung ("{0} .pdb-Datei(en) im Paket. Bei diesem Debug-Bau erwartet; in einem Release-Paket haben sie nichts zu suchen." -f $pdb.Count)
} else {
  foreach ($p in $pdb) {
    $rel = $p.FullName.Substring($Paket.Length).TrimStart('\')
    Write-Host ("   .pdb im Release-Paket: {0}" -f $rel) -ForegroundColor Red
  }
  Melde-Fehler ("{0} .pdb-Datei(en) in einem Release-Paket: {1}" -f $pdb.Count, (($pdb | ForEach-Object { $_.Name }) -join ', '))
}

$iniPfad = Join-Path (Join-Path $Paket 'Mailverzeichnis') 'Eudora.ini'
if (Test-Path -LiteralPath $iniPfad -PathType Leaf) {
  $iniLaenge = (Get-Item -LiteralPath $iniPfad).Length
  Write-Host ("   Mailverzeichnis\Eudora.ini  ({0} Byte)" -f $iniLaenge) -ForegroundColor Green
} else {
  Write-Host '   Mailverzeichnis\Eudora.ini  FEHLT' -ForegroundColor Red
  Melde-Fehler 'Keine Mailverzeichnis\Eudora.ini im Paket. Ohne vorhandene INI bricht Eudora beim Start ab (eudora.cpp:3542, Befund S-1), und "Eudora starten.cmd" bricht vorher mit einer Meldung ab.'
}

$starter = Join-Path $Paket 'Eudora starten.cmd'
if (Test-Path -LiteralPath $starter -PathType Leaf) {
  Write-Host '   Eudora starten.cmd' -ForegroundColor Green
} else {
  Write-Host '   Eudora starten.cmd  FEHLT' -ForegroundColor Red
  Melde-Fehler 'Keine "Eudora starten.cmd" im Paket. Ohne sie bekommt Eudora beim ersten Start das Mailverzeichnis nicht uebergeben und legt eine leere Einrichtung an (Befund E-6).'
}
Write-Host ''

# ------------------------------------------------ 5. Bekannte Luecken       --

Write-Host '5. BEKANNTE, ERWARTETE LUECKEN'
Write-Host '   ---------------------------'

if ($luecken.Count -eq 0) {
  Write-Host '   keine' -ForegroundColor Green
} else {
  foreach ($n in ($luecken.Keys | Sort-Object)) {
    $basis = [IO.Path]::GetFileNameWithoutExtension($n.ToLowerInvariant())
    $wer = ($luecken[$n] | Sort-Object -Unique) -join ', '
    $imStart = $false
    foreach ($r in $luecken[$n]) { if ($startkette.ContainsKey($r)) { $imStart = $true } }
    Write-Host ("   {0,-14} {1}" -f $n, $bekannteLuecken[$basis]) -ForegroundColor Yellow
    Write-Host ("                  gebraucht von: {0}" -f $wer) -ForegroundColor DarkYellow
    if ($imStart) {
      # Wenn eine bekannte Luecke doch in der Startkette haengt, ist sie KEINE
      # blosse Funktionsluecke mehr - dann startet das Paket nicht.
      Write-Host '                  ACHTUNG: liegt in der Startkette - das verhindert den Start!' -ForegroundColor Red
      Melde-Fehler ("$n liegt in der Startkette ($wer) und fehlt - damit startet Eudora nicht.")
    } else {
      Melde-Warnung ("$n fehlt (" + $bekannteLuecken[$basis] + "). Der Start ist davon NICHT betroffen; ausfallen werden die Funktionen in: $wer")
    }
  }
  Write-Host ''
  Write-Host '   Diese Luecken kosten einzelne Zusatzfunktionen (Adressbuch, LDAP,'
  Write-Host '   Ph, S/MIME), nicht den Start. Sie sind kein Fehlschlag von'
  Write-Host '   Kriterium 0.'
}
Write-Host ''

# ------------------------------------------------------------- Zusammenzug --

Write-Host '========================================================'
if ($fehler.Count -eq 0) {
  Write-Host 'ERGEBNIS: keine Fehler.' -ForegroundColor Green
} else {
  Write-Host ("ERGEBNIS: {0} FEHLER" -f $fehler.Count) -ForegroundColor Red
  $fehler | ForEach-Object { Write-Host "  - $_" }
}
if ($warnung.Count -gt 0) {
  Write-Host ''
  Write-Host ("{0} Warnung(en):" -f $warnung.Count) -ForegroundColor Yellow
  $warnung | ForEach-Object { Write-Host "  - $_" }
}
Write-Host ''
Write-Host 'KRITERIUM 0 - startet dieses Paket auf einem Windows ohne'
Write-Host 'Nachinstallation?'
if ($fehler.Count -eq 0) {
  Write-Host '   JA - nach dem PE-Kopf jeder Paketdatei fehlt nichts, was der' -ForegroundColor Green
  Write-Host '   Lader vor dem ersten Befehl braucht.' -ForegroundColor Green
} else {
  Write-Host '   NEIN - siehe die Fehler oben.' -ForegroundColor Red
}
Write-Host '========================================================'

if ($fehler.Count -gt 0) { exit 1 }
exit 0
