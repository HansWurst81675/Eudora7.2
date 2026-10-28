# messen-e166.ps1 - beantwortet die Junk-Frage beim Start und meldet, ob sie
# kam (Befund E-166: "Automatically put junk mail in the Junk mailbox?" kam
# bei Gregor mehrmals statt einmal).
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, bekommt von dort
# -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem Pfad.
#
#   powershell -ExecutionPolicy Bypass -File tools\testlauf.ps1 `
#       -Verzeichnis "C:\Temp\E166" -Freigabe "<Gregors Satz mit Datum>" `
#       -MessenSkript tools\messen-e166.ps1 -Sekunden 60
#
# Beantwortet wird mit WM_COMMAND IDOK an das gemessene Dialoghandle, nie per
# Tastendruck (Arbeitsweise/keine-tastendruecke-verschicken.md). Erkannt wird
# der Dialog an seinem Titel UND am Prozess aus dem Pfad, nicht an der
# Klasse #32770 allein (Arbeitsweise/messziel-am-merkmal-erkennen.md).
#
# Umgebungsvariable E166_HART=1: nach der Antwort wird der Eudora-Prozess aus
# dem Pfad abgeschossen statt regulaer beendet - der Fall "Defender beendet
# Eudora" aus Gregors Protokoll vom 27.10.2026.
#
# Ausgabe: eine Zeile "E166 ERGEBNIS frage=<0|1> beantwortet=<0|1> ende=<regulaer|hart>".
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [int] $WarteSekunden = 20
)
$ErrorActionPreference = 'Stop'

Add-Type @"
using System; using System.Text; using System.Collections.Generic; using System.Runtime.InteropServices;
public class E166 {
  public delegate bool EP(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP p, IntPtr l);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetClassName(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  public static List<IntPtr> Fenster(uint ziel) {
    List<IntPtr> r = new List<IntPtr>();
    EnumWindows(delegate(IntPtr h, IntPtr l) {
      uint pid; GetWindowThreadProcessId(h, out pid);
      if (pid == ziel && IsWindowVisible(h)) r.Add(h);
      return true; }, IntPtr.Zero);
    return r;
  }
  public static string Klasse(IntPtr h) { StringBuilder s = new StringBuilder(256); GetClassName(h, s, 256); return s.ToString(); }
  public static string Titel(IntPtr h)  { StringBuilder s = new StringBuilder(512); GetWindowText(h, s, 512); return s.ToString(); }
}
"@

$titel = 'Automatically put junk mail in the Junk mailbox?'
$voll  = (Resolve-Path -LiteralPath $Pfadfilter).Path.TrimEnd('\')
$proz  = @(Get-Process -Name Eudora -ErrorAction SilentlyContinue |
           Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', [StringComparison]::OrdinalIgnoreCase) })
if ($proz.Count -ne 1) {
    Write-Output ('E166 FEHLER: ' + $proz.Count + ' Eudora-Prozesse unter ' + $voll + ', erwartet 1')
    exit 1
}
$p = $proz[0]

$frage = 0; $beantwortet = 0
$frist = (Get-Date).AddSeconds($WarteSekunden)
while ((Get-Date) -lt $frist) {
    foreach ($h in [E166]::Fenster([uint32] $p.Id)) {
        if ([E166]::Klasse($h) -eq '#32770' -and [E166]::Titel($h) -eq $titel) {
            $frage = 1
            Write-Output ('E166 Dialog gefunden: Handle ' + $h)
            # WM_COMMAND = 0x0111, IDOK = 1 ("Yes")
            [void][E166]::PostMessage($h, 0x0111, [IntPtr]1, [IntPtr]::Zero)
            $beantwortet = 1
            break
        }
    }
    if ($frage) { break }
    Start-Sleep -Milliseconds 500
}
if (-not $frage) {
    Write-Output ('E166 kein Junk-Dialog innerhalb von ' + $WarteSekunden + ' s. Sichtbare Fenster:')
    foreach ($h in [E166]::Fenster([uint32] $p.Id)) {
        Write-Output ('E166   ' + [E166]::Klasse($h) + '  [' + [E166]::Titel($h) + ']')
    }
}
Start-Sleep -Seconds 3

$ende = 'regulaer'
if ($env:E166_HART -eq '1') {
    $ende = 'hart'
    $p.Kill()
    $p.WaitForExit(10000) | Out-Null
}
Write-Output ('E166 ERGEBNIS frage=' + $frage + ' beantwortet=' + $beantwortet + ' ende=' + $ende)
