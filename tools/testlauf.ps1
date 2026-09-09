# testlauf.ps1 - der EINZIGE erlaubte Weg, Eudora zum Messen zu starten.
#
# WARUM ES DAS GIBT
#
# Gregor am 05.09.2026: "das solltest du mit mir absprechen. ich kann nicht
# testen, wenn dauernd etwas startet und fehler dialoge auftauchen."
# Am 07.09.2026: "waere nett, wenn du waehrend deines tests nicht meine windows
# explorer fenster schliesst."
# Am 08.09.2026, nach vier unangekuendigten Starts: "hast du was gestartet?"
# und "absprache?"
#
# Die Lehre (Arbeitsweise/nichts-auf-gregors-bildschirm-starten.md) stand seit
# dem 05.09.2026 da und hat dreimal nicht gewirkt. Eine Lehre ist Text; Text
# wird nicht gelesen, wenn es eilig ist. Dieses Skript ist der Moment, in dem
# die Regel geprueft wird.
#
# WAS ES ERZWINGT
#
#   1. -Freigabe <Text> ist PFLICHT. Ohne den Satz, mit dem Gregor den Lauf
#      erlaubt hat, startet nichts. Der Text landet im Protokoll.
#   2. Das Verzeichnis muss unter einem erlaubten Pfad liegen (Standard:
#      C:\Temp). Gregors eigene Verzeichnisse sind ausgeschlossen - dort
#      testet er selbst.
#   3. Eudora.exe und EudoraRes.dll muessen DIESELBE Dateiversion tragen.
#      Sonst kommt der Dialog "Eudora has loaded a Resource DLL that does not
#      match this version of Eudora" - genau der Fehler vom 08.09.2026, der
#      eine Messung wertlos gemacht und Gregor einen Dialog auf den Schirm
#      gestellt hat. Geprueft wird VOR dem Start.
#   4. Der Lauf hat eine Hoechstdauer und beendet sich selbst - per
#      WM_CLOSE an ein GEMESSENES Fensterhandle, nie per Tastendruck
#      (Arbeitsweise/keine-tastendruecke-verschicken.md).
#   5. Beim Aufraeumen wird IMMER nach Pfad gefiltert. Ein pauschales
#      Stop-Process auf "Eudora" wuerde Gregors eigene Sitzung treffen.
#   6. Jeder Lauf wird in tools/TESTLAEUFE.md angehaengt: Zeit, Verzeichnis,
#      Freigabetext, Ergebnis. Damit ist hinterher nachweisbar, was gestartet
#      wurde und mit welcher Erlaubnis.
#
# Aufruf:
#   powershell -NoProfile -ExecutionPolicy Bypass -File tools\testlauf.ps1 `
#              -Verzeichnis C:\Temp\E44-layout `
#              -Freigabe "Gregor am 08.09.2026: 'ja, starte einmal'" `
#              -Sekunden 25
#
#   -NurPruefen        prueft alles und startet NICHT (fuer Gegentests)
#   -ErlaubtePfade     Standard C:\Temp
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string]   $Verzeichnis,
    [Parameter(Mandatory = $true)] [string]   $Freigabe,
    [int]      $Sekunden      = 25,
    # Wie lange nach WM_CLOSE auf das Ende gewartet wird, bevor abgeschossen
    # wird. 30 s waren am 08.09.2026 zu kurz, um die Frage zu entscheiden, ob
    # das Beenden haengt oder nur laenger dauert.
    [int]      $SchliessSekunden = 30,
    # Skript, das gefahren wird, SOLANGE das Fenster steht - bekommt
    # -Pfadfilter <Verzeichnis> mit. So gehoert Messen und Aufraeumen in
    # denselben Lauf und die Instanz bleibt nicht aus Versehen stehen.
    [string]   $MessenSkript  = '',
    [string[]] $ErlaubtePfade = @('C:\Temp'),
    [switch]   $NurPruefen
)

$ErrorActionPreference = 'Stop'
$mangel = New-Object System.Collections.ArrayList

function Melde-Mangel([string] $text) { [void] $mangel.Add($text) }

# --- 1. Freigabe -----------------------------------------------------------

if ([string]::IsNullOrWhiteSpace($Freigabe) -or $Freigabe.Trim().Length -lt 10) {
    Melde-Mangel ('Keine tragfaehige Freigabe. -Freigabe muss den Satz nennen, mit dem ' +
                  'Gregor diesen Lauf erlaubt hat (mindestens 10 Zeichen). ' +
                  'Ohne Absprache wird nichts gestartet.')
}

# --- 2. Pfad ---------------------------------------------------------------

$voll = ''
try { $voll = (Resolve-Path -LiteralPath $Verzeichnis -ErrorAction Stop).Path }
catch { Melde-Mangel ('Verzeichnis nicht gefunden: ' + $Verzeichnis) }

if ($voll -ne '') {
    $erlaubt = $false
    foreach ($e in $ErlaubtePfade) {
        if ($voll.StartsWith($e, [System.StringComparison]::OrdinalIgnoreCase)) { $erlaubt = $true }
    }
    if (-not $erlaubt) {
        Melde-Mangel ('Verzeichnis liegt nicht unter einem erlaubten Pfad (' +
                      ($ErlaubtePfade -join ', ') + '): ' + $voll +
                      '. Gregors eigene Release-Verzeichnisse sind ausgeschlossen - ' +
                      'dort testet er selbst ("da hast du nichts zu suchen").')
    }
}

# --- 3. Versionen von Eudora.exe und EudoraRes.dll -------------------------

$exe = ''
if ($voll -ne '') {
    $exe = Join-Path $voll 'Eudora.exe'
    $res = Join-Path $voll 'EudoraRes.dll'

    if (-not (Test-Path -LiteralPath $exe)) { Melde-Mangel ('Eudora.exe fehlt: ' + $exe) }
    if (-not (Test-Path -LiteralPath $res)) { Melde-Mangel ('EudoraRes.dll fehlt: ' + $res) }

    if ((Test-Path -LiteralPath $exe) -and (Test-Path -LiteralPath $res)) {
        $vExe = (Get-Item -LiteralPath $exe).VersionInfo.FileVersion
        $vRes = (Get-Item -LiteralPath $res).VersionInfo.FileVersion
        Write-Host ('  Eudora.exe     ' + $vExe)
        Write-Host ('  EudoraRes.dll  ' + $vRes)
        if ($vExe -ne $vRes) {
            Melde-Mangel ('Versionen passen nicht zusammen: Eudora.exe ' + $vExe +
                          ' gegen EudoraRes.dll ' + $vRes + '. Eudora bringt dann den ' +
                          'Dialog "Eudora has loaded a Resource DLL that does not match ' +
                          'this version of Eudora" und die Messung ist wertlos. ' +
                          'Beide Dateien aus DEMSELBEN Bau kopieren.')
        }
    }

    $ini = Join-Path (Join-Path $voll 'Mailverzeichnis') 'Eudora.ini'
    if (-not (Test-Path -LiteralPath $ini)) {
        Melde-Mangel ('Mailverzeichnis\Eudora.ini fehlt: ' + $ini +
                      '. Ohne Parameter legt Eudora eine leere Einrichtung an (Befund E-6).')
    }
}

# --- 4. Laeuft schon eine fremde Instanz? ----------------------------------

foreach ($p in (Get-Process -Name 'Eudora' -ErrorAction SilentlyContinue)) {
    $pf = '(Pfad nicht lesbar)'
    try { $pf = $p.MainModule.FileName } catch { }
    if ($voll -ne '' -and $pf.StartsWith($voll, [System.StringComparison]::OrdinalIgnoreCase)) {
        Melde-Mangel ('Aus diesem Verzeichnis laeuft schon eine Instanz (PID ' + $p.Id +
                      '). Erst beenden, sonst uebergibt die neue an die alte und ' +
                      'beendet sich sofort - die Messung waere wertlos.')
    } else {
        Write-Host ('  Fremde Instanz laeuft und wird NICHT angefasst: PID ' + $p.Id + '  ' + $pf)
    }
}

# --- Abbruch bei Maengeln ---------------------------------------------------

if ($mangel.Count -gt 0) {
    Write-Host ''
    Write-Host '  TESTLAUF ABGEWIESEN:'
    Write-Host ''
    foreach ($m in $mangel) { Write-Host ('    - ' + $m) }
    Write-Host ''
    exit 1
}

Write-Host ''
Write-Host '  Alle Voraussetzungen erfuellt.'
Write-Host ('  Freigabe: ' + $Freigabe)

if ($NurPruefen) {
    Write-Host '  -NurPruefen: es wird nichts gestartet.'
    Write-Host ''
    exit 0
}

# --- 5. Starten, messen, beenden -------------------------------------------

$hilfe = @'
using System; using System.Text; using System.Collections.Generic; using System.Runtime.InteropServices;
public class TL {
  public delegate bool EP(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP p, IntPtr l);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetClassName(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern IntPtr PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);

  public static IntPtr Haupt(uint ziel) {
    IntPtr gefunden = IntPtr.Zero;
    EnumWindows(delegate(IntPtr h, IntPtr l) {
      uint pid; GetWindowThreadProcessId(h, out pid);
      if (pid == ziel) {
        StringBuilder c = new StringBuilder(256); GetClassName(h, c, 256);
        if (c.ToString() == "EudoraMainWindow") { gefunden = h; return false; }
      }
      return true; }, IntPtr.Zero);
    return gefunden;
  }

  public static List<string> Sichtbare(uint ziel) {
    List<string> r = new List<string>();
    EnumWindows(delegate(IntPtr h, IntPtr l) {
      uint pid; GetWindowThreadProcessId(h, out pid);
      if (pid == ziel) {
        StringBuilder c = new StringBuilder(256); GetClassName(h, c, 256);
        StringBuilder t = new StringBuilder(512); GetWindowText(h, t, 512);
        r.Add(c.ToString() + "  [" + t.ToString() + "]");
      }
      return true; }, IntPtr.Zero);
    return r;
  }

  public static string Titel(IntPtr h) { StringBuilder s = new StringBuilder(512); GetWindowText(h, s, 512); return s.ToString(); }
}
'@
if (-not ([System.Management.Automation.PSTypeName]'TL').Type) {
    Add-Type -TypeDefinition $hilfe -Language CSharp
}

$daten = Join-Path $voll 'Mailverzeichnis'
Write-Host ''
Write-Host ('  Starte  ' + $exe + '  "' + $daten + '"')
$proz = Start-Process -FilePath $exe -ArgumentList $daten -WorkingDirectory $voll -PassThru

$ergebnis = ''
$hHaupt = [IntPtr]::Zero
$frist = (Get-Date).AddSeconds($Sekunden)
while ((Get-Date) -lt $frist -and $hHaupt -eq [IntPtr]::Zero) {
    Start-Sleep -Milliseconds 1000
    if ($proz.HasExited) { break }
    $hHaupt = [TL]::Haupt([uint32] $proz.Id)
}

if ($proz.HasExited) {
    $ergebnis = 'Prozess hat sich von selbst beendet, Exitcode ' + $proz.ExitCode +
                ' - kein Hauptfenster erschienen.'
    Write-Host ('  ' + $ergebnis)
} elseif ($hHaupt -eq [IntPtr]::Zero) {
    $ergebnis = 'Kein Hauptfenster (EudoraMainWindow) innerhalb von ' + $Sekunden + ' s.'
    Write-Host ('  ' + $ergebnis)
    Write-Host '  Sichtbare Fenster des Prozesses:'
    foreach ($z in [TL]::Sichtbare([uint32] $proz.Id)) { Write-Host ('    ' + $z) }
} else {
    $ergebnis = 'Hauptfenster ' + $hHaupt + ' - ' + [TL]::Titel($hHaupt)
    Write-Host ('  ' + $ergebnis)
}

# Messen, solange das Fenster steht.
if ($MessenSkript -ne '' -and -not $proz.HasExited) {
    Write-Host ''
    Write-Host ('  --- ' + $MessenSkript + ' ---')
    & powershell -NoProfile -ExecutionPolicy Bypass -File $MessenSkript -Pfadfilter $voll 2>&1 |
        ForEach-Object { Write-Host ('  ' + $_) }
    Write-Host '  --- Ende der Messung ---'
    Write-Host ''
}

# Beenden: WM_CLOSE an das gemessene Handle, danach nach Pfad gefiltert nachsehen.
if (-not $proz.HasExited) {
    if ($hHaupt -ne [IntPtr]::Zero) {
        Write-Host '  Beende per WM_CLOSE an das gemessene Handle.'
        $uhr = [System.Diagnostics.Stopwatch]::StartNew()
        [void][TL]::PostMessage($hHaupt, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
    }
    $frist = (Get-Date).AddSeconds($SchliessSekunden)
    while (-not $proz.HasExited -and (Get-Date) -lt $frist) { Start-Sleep -Milliseconds 1000 }
    if (-not $proz.HasExited) {
        Write-Host '  Beendet sich nicht - wird nach Pfadpruefung abgeschossen.'
        $pf = ''
        try { $pf = $proz.MainModule.FileName } catch { }
        if ($pf.StartsWith($voll, [System.StringComparison]::OrdinalIgnoreCase)) {
            $proz.Kill()
            $ergebnis = $ergebnis + '  ABER: musste abgeschossen werden.'
        } else {
            Write-Host '  ABGEBROCHEN: Pfad passt nicht, dieser Prozess wird nicht angefasst.'
        }
    }
}

if ($null -ne $uhr) {
    $uhr.Stop()
    Write-Host ('  Zeit vom WM_CLOSE bis zum Ende: ' + [math]::Round($uhr.Elapsed.TotalSeconds, 1) + ' s')
    $ergebnis = $ergebnis + '  Schliesszeit ' + [math]::Round($uhr.Elapsed.TotalSeconds, 1) + ' s.'
}
Write-Host ('  Beendet: ' + $proz.HasExited)

# --- 6. Protokoll -----------------------------------------------------------

# Zeilenenden und BOM, gemessen am 09.09.2026 (LEKTOR, Befund L-11.2):
# Set-Content/Add-Content schreiben unter Windows PowerShell 5.1 CRLF, und
# -Encoding utf8 setzt eine BOM davor. tools/TESTLAEUFE.md war dadurch die
# EINZIGE MD-Datei im Repo mit CRLF - 17 Zeilen, alle CRLF, plus BOM. Genau
# dieselbe Fehlerklasse war am 08.09.2026 als L-9.15 an
# Pruefung/PRUEFUNG-ZEIGER.md schon einmal von Hand berichtigt worden; von
# Hand nachbessern hilft hier nichts, weil dieses Werkzeug die Datei bei jedem
# Lauf weiterschreibt. Deshalb schreibt es jetzt ueber .NET: LF, kein BOM.
$ohneBom = New-Object System.Text.UTF8Encoding($false)
$wurzel = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$buch = Join-Path (Join-Path $wurzel 'tools') 'TESTLAEUFE.md'
if (-not (Test-Path -LiteralPath $buch)) {
    $kopf = @(
        '# Testlaeufe',
        '',
        'Jede Zeile ist ein Start von Eudora durch mich, mit der Freigabe, auf die er',
        'sich stuetzt. Angelegt und gefuellt von `tools/testlauf.ps1` - siehe dort, warum.',
        '',
        'Diese Datei ist ein Protokoll vergangener Laeufe. Sie nennt absichtlich alte',
        'Fassungsnummern und wird von `tools/doku-pruefen.pl` deshalb als Zeitdokument',
        'behandelt.',
        '',
        '| Zeit | Verzeichnis | Freigabe | Ergebnis |',
        '|---|---|---|---|'
    ) -join "`n"
    [System.IO.File]::WriteAllText($buch, $kopf + "`n", $ohneBom)
}
$zeile = '| ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' | `' + $voll + '` | ' +
         ($Freigabe -replace '\|', '/') + ' | ' + ($ergebnis -replace '\|', '/') + ' |'
[System.IO.File]::AppendAllText($buch, $zeile + "`n", $ohneBom)
Write-Host ('  Protokolliert in ' + $buch)
Write-Host ''
