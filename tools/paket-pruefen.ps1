# Prueft ein fertig ausgepacktes Eudora-Auslieferungspaket, BEVOR es jemand
# startet.
#
#   powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket "C:\Pfad\zum\ausgepackten\Paket"
#
#   -Ausfuehrlich   listet zusaetzlich jede Datei einzeln auf
#
# Rueckgabe: 0 = alles in Ordnung, 1 = FEHLER gefunden, 2 = Aufrufproblem.
# Warnungen allein aendern die Rueckgabe nicht.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 31.08.2026 scheiterte der Start von Paket 1.0.2 auf Gregors Maschine mit
#
#     0xc000007b - Die Anwendung konnte nicht korrekt gestartet werden
#
# Grund: die vier VS2022-Debug-Laufzeiten lagen nicht im Paket, und die
# ersatzweise von einer DLL-Sammelseite geholten Dateien waren 64 Bit. Beides
# haette dieses Werkzeug vor der Auslieferung gemeldet.
#
# Geprueft werden vier Dinge:
#
#   1. Architektur   - jede EXE und DLL im Paket muss x86 sein (PE-Kopf gelesen,
#                      dasselbe Verfahren wie in tools\laufzeit-holen.ps1).
#   2. Importe       - jede DLL, die eine Paketdatei laut ihrer Import- und
#                      Verzoegerungstabelle braucht, muss im Paket oder im
#                      System liegen.
#   3. Laufzeiten    - die vier VS2022-Debug-Laufzeiten muessen dabei sein.
#   4. Eudora.ini    - ohne vorhandene INI bricht Eudora beim Start ab
#                      (VERIFY in eudora.cpp:3542, Befund S-1).
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
    if ($br.ReadUInt32() -ne 0x00004550) { return $null }    # "PE\0\0"

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

$sysWow = Join-Path $env:SystemRoot 'SysWOW64'    # 32-Bit-DLLs, trotz des Namens
$sys32  = Join-Path $env:SystemRoot 'System32'
$downlevel = Join-Path $sysWow 'downlevel'

Write-Host ''
Write-Host "Paket:  $Paket"
Write-Host ''

$binaer = Get-ChildItem -LiteralPath $Paket -Recurse -File |
          Where-Object { $_.Extension -match '^\.(dll|exe|ocx)$' } |
          Sort-Object FullName

if ($binaer.Count -eq 0) {
  Melde-Fehler "Im Paket liegt keine einzige EXE oder DLL."
}

# Namen aller Binaerdateien im Paketwurzelverzeichnis. Der Lader sucht im
# Verzeichnis der EXE, nicht in Unterverzeichnissen - Plugins\ zaehlt also
# nicht als Fundort fuer Abhaengigkeiten.
$imPaket = @{}
foreach ($f in (Get-ChildItem -LiteralPath $Paket -File)) {
  $imPaket[$f.Name.ToLowerInvariant()] = $true
}

# --------------------------------------------------- 1. Architekturpruefung --

Write-Host '1. ARCHITEKTUR (jede EXE und DLL muss x86 sein)'
Write-Host '   --------------------------------------------'

$keinPE = @()
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

if ($falscheArch -eq 0) {
  Write-Host ("   {0} Binaerdateien geprueft, alle x86." -f $peInfo.Count) -ForegroundColor Green
}
Write-Host ''

# ------------------------------------------------------- 2. Importe loesen --

Write-Host '2. IMPORTE (loest jede benoetigte DLL auf?)'
Write-Host '   ---------------------------------------'

function Finde-DLL([string]$name) {
  $n = $name.ToLowerInvariant()
  if ($imPaket.ContainsKey($n)) { return 'Paket' }
  # Fuer einen 32-Bit-Prozess ist SysWOW64 das, was das Programm "System32"
  # nennt. Deshalb dort zuerst nachsehen.
  if (Test-Path -LiteralPath (Join-Path $sysWow $name)) { return 'SysWOW64' }
  if (Test-Path -LiteralPath (Join-Path $sys32  $name)) { return 'System32' }
  if ($n -like 'api-ms-win-*' -or $n -like 'ext-ms-*') {
    if (Test-Path -LiteralPath (Join-Path $downlevel $name)) { return 'downlevel' }
    return 'ApiSet'   # vom System aufgeloest, keine Datei noetig
  }
  return $null
}

$fehlend = @{}          # DLL-Name -> Liste der Module, die sie brauchen
$fehlendVerz = @{}      # dasselbe, aber nur verzoegert geladen

foreach ($rel in ($peInfo.Keys | Sort-Object)) {
  foreach ($n in $peInfo[$rel].Noetig) {
    $verz = $n.EndsWith(' (verzoegert)')
    $name = if ($verz) { $n.Substring(0, $n.Length - 13) } else { $n }
    $wo = Finde-DLL $name
    if ($wo) {
      if ($Ausfuehrlich) {
        Write-Host ("   {0,-30} <- {1,-34} {2}" -f $name, $rel, $wo) -ForegroundColor DarkGray
      }
      continue
    }
    $ziel = if ($verz) { $fehlendVerz } else { $fehlend }
    if (-not $ziel.ContainsKey($name)) { $ziel[$name] = @() }
    $ziel[$name] += $rel
  }
}

if ($fehlend.Count -eq 0 -and $fehlendVerz.Count -eq 0) {
  Write-Host '   Alle Importe loesen auf.' -ForegroundColor Green
}

foreach ($n in ($fehlend.Keys | Sort-Object)) {
  $wer = ($fehlend[$n] | Sort-Object -Unique) -join ', '
  Write-Host ("   FEHLT: {0,-24} gebraucht von {1}" -f $n, $wer) -ForegroundColor Red
  Melde-Fehler ("$n fehlt - gebraucht von: $wer")
}
foreach ($n in ($fehlendVerz.Keys | Sort-Object)) {
  $wer = ($fehlendVerz[$n] | Sort-Object -Unique) -join ', '
  Write-Host ("   fehlt (verzoegert): {0,-18} {1}" -f $n, $wer) -ForegroundColor Yellow
  Melde-Warnung ("$n fehlt, wird aber erst bei Benutzung geladen - gebraucht von: $wer")
}
Write-Host ''

# ------------------------------------------------- 3. VS2022-Debuglaufzeit --

Write-Host '3. VS2022-DEBUG-LAUFZEITEN'
Write-Host '   -----------------------'

$laufzeiten = @('mfc140d.dll','msvcp140d.dll','vcruntime140d.dll','ucrtbased.dll')
$lzFehlt = @()
foreach ($d in $laufzeiten) {
  if ($imPaket.ContainsKey($d)) {
    Write-Host ("   {0,-22} im Paket" -f $d) -ForegroundColor Green
  } elseif (Test-Path -LiteralPath (Join-Path $sysWow $d)) {
    Write-Host ("   {0,-22} nicht im Paket, aber in SysWOW64 vorhanden" -f $d) -ForegroundColor Yellow
    Melde-Warnung ("$d liegt nicht im Paket. Auf dieser Maschine steht sie in SysWOW64, auf einer Maschine ohne Visual Studio 2022 nicht - dort scheitert der Start.")
    $lzFehlt += $d
  } else {
    Write-Host ("   {0,-22} FEHLT" -f $d) -ForegroundColor Red
    Melde-Fehler ("$d fehlt im Paket und auf dieser Maschine. Ohne sie startet Eudora nicht.")
    $lzFehlt += $d
  }
}
if ($lzFehlt.Count -gt 0) {
  Write-Host ''
  Write-Host '   Abhilfe:  powershell -ExecutionPolicy Bypass -File tools\laufzeit-holen.ps1 -Ziel "<Paketverzeichnis>"'
}
Write-Host ''

# -------------------------------------------------------- 4. Eudora.ini    --

Write-Host '4. EUDORA.INI ALS VORLAGE'
Write-Host '   ----------------------'

$ini = Get-ChildItem -LiteralPath $Paket -Recurse -File -Filter 'Eudora.ini' -ErrorAction Ignore
if ($ini) {
  foreach ($i in $ini) {
    $rel = $i.FullName.Substring($Paket.Length).TrimStart('\')
    Write-Host ("   {0}  ({1} Byte)" -f $rel, $i.Length) -ForegroundColor Green
  }
} else {
  Write-Host '   FEHLT' -ForegroundColor Red
  Melde-Fehler 'Keine Eudora.ini im Paket. Ohne vorhandene INI bricht Eudora beim Start ab (eudora.cpp:3542, Befund S-1).'
}
Write-Host ''

# --------------------------------------------------------- 5. Beifang      --
#
# Kein Fehler, aber der Hinweis spart der naechsten Fassung Ballast.

$ballast = @('msvcr71d.dll','msvcp71d.dll','mfc71d.dll')
foreach ($d in $ballast) {
  if ($imPaket.ContainsKey($d)) {
    $braucht = @()
    foreach ($rel in $peInfo.Keys) {
      foreach ($n in $peInfo[$rel].Noetig) {
        if ($n.ToLowerInvariant().StartsWith($d)) { $braucht += $rel }
      }
    }
    if ($braucht.Count -eq 0) {
      Melde-Warnung ("$d liegt im Paket, wird aber von keiner Paketdatei gebraucht - totes Gewicht (Befund B-1).")
    }
  }
}

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
Write-Host '========================================================'

if ($fehler.Count -gt 0) { exit 1 }
exit 0
