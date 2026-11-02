# messen-e133.ps1 - startet Eudora, wenn die Registry auf ein Mailverzeichnis
# zeigt, das es nicht mehr gibt? (Befund E-133)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript -OhneArgument, bekommt von
# dort -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem
# Pfad.
#
#   powershell -ExecutionPolicy Bypass -File tools\messen-e133.ps1 -Vorbereiten -Pfadfilter C:\Temp\E133
#   powershell -ExecutionPolicy Bypass -File tools\testlauf.ps1 -OhneArgument `
#       -Verzeichnis C:\Temp\E133 -Freigabe "<Gregors Satz von heute>" `
#       -MessenSkript tools\messen-e133.ps1 -Sekunden 5
#
# ACHTUNG REGISTRY. -Vorbereiten setzt
# HKCU\Software\Qualcomm\Eudora\CommandLine\Current - denselben Wert, den
# Gregors eigene Eudora liest (Befund E-157). Zurueckgesetzt wird er NICHT
# hier, sondern vom Aufrufer: tools\pruefstand-lauf.ps1 haelt CommandLine und
# LaunchManager vor dem Lauf fest und setzt sie im finally zurueck. Wer dieses
# Skript von Hand faehrt, muss den Schluessel vorher sichern und danach
# zuruecksetzen; testlauf.ps1 allein tut das NICHT.
#
# WARUM ES DAS GIBT. Gregor am 21.10.2026: Doppelklick auf Eudora.exe, dann
# "The directory specified in the command line: C:\Temp\SICHER~1 doesn't
# exist or is not writable." - danach startete Eudora nicht. Der Zeiger kam
# von einem meiner Pruefstaende, dessen Verzeichnis ich geloescht hatte. Die
# Behebung (Zweig e133_mailverzeichnis_fehlt, eudora.cpp
# StartEudoraWithDefaultLocation / E133VerzeichnisFehlt) fragt statt dessen.
#
# Lage (-Vorbereiten): Current = "<Eudora.exe> <fehlt> <fehlt>\Eudora.ini"
# mit <fehlt> = C:\Temp\E133-gibt-es-nicht (wird geloescht, falls vorhanden).
# Neben der EXE liegt keine Eudora.ini - sonst wuerde die Registry gar nicht
# gelesen (eudora.cpp InitInstance, leere Befehlszeile).
#
# Ablauf, ohne Tastendruck, nur Botschaften an gemessene Fensterhandles:
#   1. jeden Dialog des Prozesses lesen (Titel, Text der Kinder)
#   2. die E-133-Rueckfrage mit -Antwort beantworten (Vorgabe Nein = Ordner
#      neben dem Programm, WM_COMMAND IDNO), jede andere Meldung mit IDOK
#   3. warten auf Hauptfenster oder Prozessende
#   4. Hauptfenster: Registry lesen, WM_CLOSE, Ende abwarten, Registry erneut
#
# Ausgabe:
#   E133 DIALOG titel="..." text="..."
#   E133 ERGEBNIS meldung=<rueckfrage|fehlermeldung|-> gestartet=<0|1> registry-danach=<wert> lebt=<0|1>
# Erwartet mit der Behebung: meldung=rueckfrage gestartet=1
#   registry-danach=<...>\Mailverzeichnis... lebt=1
# Ohne (alter Bau): meldung=fehlermeldung gestartet=0 registry-danach=<fehlt> lebt=0
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [ValidateSet('Nein', 'Abbrechen')] [string] $Antwort = 'Nein',
    [int] $Warten = 40
)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
$fehlt = 'C:\Temp\E133-gibt-es-nicht'
$regPfad = 'HKCU:\Software\Qualcomm\Eudora\CommandLine'

if ($voll -notmatch '^C:\\Temp\\E133') { Write-Host "E133 ABGEWIESEN: $voll liegt nicht unter C:\Temp\E133*"; exit 2 }

if ($Vorbereiten) {
    try {
        $exe = Join-Path $voll 'Eudora.exe'
        if (-not (Test-Path $exe)) { Write-Host "E133 FEHLER: keine Eudora.exe in $voll"; exit 1 }
        if (Test-Path (Join-Path $voll 'Eudora.ini')) { Write-Host "E133 FEHLER: Eudora.ini neben der EXE - dann liest Eudora die Registry nicht"; exit 1 }
        if (Test-Path $fehlt) { Remove-Item -LiteralPath $fehlt -Recurse -Force }
        $log = Join-Path (Join-Path $voll 'Mailverzeichnis') 'eudora.log'
        if (Test-Path $log) { Remove-Item -LiteralPath $log -Force }
        $wert = $exe + ' ' + $fehlt + ' ' + $fehlt + '\Eudora.ini'
        if (-not (Test-Path $regPfad)) { New-Item -Path $regPfad -Force | Out-Null }
        New-ItemProperty -LiteralPath $regPfad -Name 'Current' -Value $wert -PropertyType String -Force | Out-Null
        Write-Host ("E133 vorbereitet: Current=""{0}""" -f (Get-ItemProperty -LiteralPath $regPfad).Current)
        exit 0
    } catch {
        Write-Host ('E133 FEHLER beim Vorbereiten: ' + $_.Exception.Message); exit 1
    }
}

Add-Type @"
using System; using System.Text; using System.Collections.Generic; using System.Runtime.InteropServices;
public class E133 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassNameA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  public static string Kl(IntPtr h) { StringBuilder s = new StringBuilder(256); GetClassNameA(h, s, 256); return s.ToString(); }
  public static string Tx(IntPtr h) { StringBuilder s = new StringBuilder(4096); GetWindowTextA(h, s, 4096); return s.ToString(); }
  public static List<IntPtr> Oben(uint pid) {
    List<IntPtr> r = new List<IntPtr>();
    EnumWindows(delegate(IntPtr h, IntPtr p) { uint o; GetWindowThreadProcessId(h, out o); if (o == pid && IsWindowVisible(h)) r.Add(h); return true; }, IntPtr.Zero);
    return r;
  }
  public static string Kinder(IntPtr h) {
    StringBuilder r = new StringBuilder();
    EnumChildWindows(h, delegate(IntPtr k, IntPtr p) { string t = Tx(k); if (t.Length > 0) { if (r.Length > 0) r.Append(" / "); r.Append(t); } return true; }, IntPtr.Zero);
    return r.ToString();
  }
}
"@

function RegJetzt {
    try { return [string](Get-ItemProperty -LiteralPath $regPfad -ErrorAction Stop).Current } catch { return '(kein Wert)' }
}

$meldung = '-'; $gestartet = 0; $lebt = 0; $regDanach = ''
try {
    $proz = $null
    foreach ($p in (Get-Process -Name 'Eudora' -ErrorAction SilentlyContinue)) {
        $pf = ''; try { $pf = $p.MainModule.FileName } catch { }
        if ($pf.StartsWith($voll + '\', [StringComparison]::OrdinalIgnoreCase)) { $proz = $p }
    }
    if (-not $proz) { Write-Host "E133 kein Eudora-Prozess unter $voll (schon beendet?)" }

    $frist = (Get-Date).AddSeconds($Warten)
    $gesehen = @{}
    while ($proz -and -not $proz.HasExited -and (Get-Date) -lt $frist) {
        $haupt = [IntPtr]::Zero
        foreach ($h in [E133]::Oben([uint32]$proz.Id)) {
            $kl = [E133]::Kl($h)
            if ($kl -eq 'EudoraMainWindow') { $haupt = $h; continue }
            if ($kl -ne '#32770') { continue }
            if ($gesehen.ContainsKey([string]$h)) { continue }
            $gesehen[[string]$h] = 1
            $titel = [E133]::Tx($h)
            $text = [E133]::Kinder($h) -replace "[\r\n\t]+", ' '
            Write-Host ("E133 DIALOG titel=""{0}"" text=""{1}""" -f $titel, $text)
            if ($text -match 'does not exist any more') {
                $meldung = 'rueckfrage'
                $id = 7; if ($Antwort -eq 'Abbrechen') { $id = 2 }
                Write-Host ("E133 antworte {0} (WM_COMMAND {1}) an {2}" -f $Antwort, $id, $h)
                [void][E133]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero)
            } else {
                if ($meldung -eq '-') { $meldung = 'fehlermeldung' }
                Write-Host ("E133 bestaetige mit IDOK an {0}" -f $h)
                [void][E133]::PostMessageA($h, 0x0111, [IntPtr]1, [IntPtr]::Zero)
            }
        }
        if ($haupt -ne [IntPtr]::Zero) {
            $gestartet = 1; $lebt = 1
            Write-Host ("E133 Hauptfenster {0}, Registry jetzt: {1}" -f $haupt, (RegJetzt))
            Start-Sleep -Seconds 3
            [void][E133]::PostMessageA($haupt, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
            # Beim Beenden kann ein Dialog warten - lesen und nennen, damit ein
            # Abschuss durch testlauf.ps1 nicht ohne Grund dasteht.
            $ende = (Get-Date).AddSeconds(30)
            while (-not $proz.HasExited -and (Get-Date) -lt $ende) {
                Start-Sleep -Milliseconds 500
                foreach ($h in [E133]::Oben([uint32]$proz.Id)) {
                    if ([E133]::Kl($h) -ne '#32770' -or $gesehen.ContainsKey([string]$h)) { continue }
                    $gesehen[[string]$h] = 1
                    Write-Host ("E133 DIALOG BEIM BEENDEN titel=""{0}"" text=""{1}""" -f [E133]::Tx($h), ([E133]::Kinder($h) -replace "[\r\n\t]+", ' '))
                }
            }
            Write-Host ("E133 beendet nach WM_CLOSE: {0}" -f $proz.HasExited)
            if (-not $proz.HasExited) {
                foreach ($h in [E133]::Oben([uint32]$proz.Id)) { Write-Host ("E133 offen: {0} [{1}]" -f [E133]::Kl($h), [E133]::Tx($h)) }
            }
            break
        }
        Start-Sleep -Milliseconds 500
    }
    if ($proz -and -not $proz.HasExited -and $gestartet -eq 0) { Write-Host 'E133 nach der Frist weder Hauptfenster noch Ende' }
    $regDanach = RegJetzt
} catch {
    Write-Host ('E133 FEHLER: ' + $_.Exception.Message)
}
Write-Host ("E133 ERGEBNIS meldung={0} gestartet={1} registry-danach={2} lebt={3}" -f $meldung, $gestartet, $regDanach, $lebt)
