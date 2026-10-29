# messen-assistent-wiedereintritt.ps1 - Absturz im Konto-Assistenten vom
# 28.10.2026 13:35:16 (LEKTOR-90 L-90.12): erreicht ein zweites "Weiter" die
# Namensseite, waehrend deren Fehlermeldung "kein Name" offen ist?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (bekommt -Pfadfilter) auf einem
# Pruefstand, dessen Eudora.ini KEIN Konto enthaelt - dann startet Eudora den
# Assistenten von selbst.
#
# Ablauf: zweimal "Weiter" (WM_COMMAND ID_WIZNEXT 12324 an das gemessene
# Handle) bis zur Namensseite, Namensfeld leer lassen, drittes "Weiter" ->
# Fehlermeldung. Dann wird gemessen, was ein Anwender in diesem Moment bedienen
# kann: IsWindowEnabled von Assistent und Weiter-Knopf, Besitzer der Meldung.
# Mit E166W_EINSCHLEUSEN=<n> werden danach n weitere "Weiter" per PostMessage
# eingeschleust (am 28.10. waren es zwei), mit E166W_ABBRUCH_BEI_MELDUNG=1
# danach "Abbrechen" an den Assistenten - so lief der Erkundungslauf, der abstuerzte.
# Kein Tastendruck (Arbeitsweise/keine-tastendruecke-verschicken.md).
#
# Ausgabe: "E166W ERGEBNIS meldung=<0|1> assistent_bedienbar=<0|1>
#           weiter_bedienbar=<0|1> eingeschleust=<n> lebt=<0|1>".
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [int] $WarteSekunden = 30
)
$ErrorActionPreference = 'Stop'

Add-Type @"
using System; using System.Text; using System.Collections.Generic; using System.Runtime.InteropServices;
public class E166W {
  public delegate bool EP(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP p, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr w, EP p, IntPtr l);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetClassName(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindowEnabled(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr GetWindow(IntPtr h, uint cmd);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  public static List<IntPtr> Fenster(uint ziel) {
    List<IntPtr> r = new List<IntPtr>();
    EnumWindows(delegate(IntPtr h, IntPtr l) {
      uint pid; GetWindowThreadProcessId(h, out pid);
      if (pid == ziel && IsWindowVisible(h)) r.Add(h);
      return true; }, IntPtr.Zero);
    return r;
  }
  public static IntPtr Kind(IntPtr w, int id) {
    IntPtr r = IntPtr.Zero;
    EnumChildWindows(w, delegate(IntPtr h, IntPtr l) { if (GetDlgCtrlID(h) == id && IsWindowVisible(h)) { r = h; return false; } return true; }, IntPtr.Zero);
    return r;
  }
  public static string Klasse(IntPtr h) { StringBuilder s = new StringBuilder(256); GetClassName(h, s, 256); return s.ToString(); }
  public static string Titel(IntPtr h)  { StringBuilder s = new StringBuilder(512); GetWindowText(h, s, 512); return s.ToString(); }
}
"@

$titelJunk = 'Automatically put junk mail in the Junk mailbox?'
$titelAssi = 'New Account Wizard'
$voll  = (Resolve-Path -LiteralPath $Pfadfilter).Path.TrimEnd('\')
$proz  = @(Get-Process -Name Eudora -ErrorAction SilentlyContinue |
           Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', [StringComparison]::OrdinalIgnoreCase) })
if ($proz.Count -ne 1) {
    Write-Output ('E166W FEHLER: ' + $proz.Count + ' Eudora-Prozesse unter ' + $voll + ', erwartet 1')
    exit 1
}
$p = $proz[0]

function Dialoge { @([E166W]::Fenster([uint32] $p.Id) | Where-Object { [E166W]::Klasse($_) -eq '#32770' }) }

$junk = [IntPtr]::Zero; $assi = [IntPtr]::Zero
$frist = (Get-Date).AddSeconds($WarteSekunden)
while ((Get-Date) -lt $frist -and $assi -eq [IntPtr]::Zero) {
    foreach ($h in Dialoge) {
        $t = [E166W]::Titel($h)
        if ($t -eq $titelJunk) { $junk = $h } elseif ($t -eq $titelAssi) { $assi = $h }
    }
    Start-Sleep -Milliseconds 500
}
Write-Output ('E166W Junk-Frage ' + $junk + ', Assistent ' + $assi)
if ($assi -eq [IntPtr]::Zero) { Write-Output 'E166W FEHLER: kein Assistent'; exit 1 }

foreach ($i in 1..3) {
    [void][E166W]::PostMessage($assi, 0x0111, [IntPtr]12324, [IntPtr]::Zero)
    Start-Sleep -Seconds 2
    $feld = [E166W]::Kind($assi, 26102)   # IDC_EDIT_YOURNAME
    Write-Output ('E166W Weiter ' + $i + ': Namensfeld sichtbar=' + [int]($feld -ne [IntPtr]::Zero) + ' Text=[' + $(if ($feld -ne [IntPtr]::Zero) { [E166W]::Titel($feld) } else { '' }) + ']')
}

$meldung = [IntPtr]::Zero
foreach ($h in Dialoge) { if ($h -ne $assi -and $h -ne $junk) { $meldung = $h } }
$weiter = [E166W]::Kind($assi, 12324)
$besitzer = if ($meldung -ne [IntPtr]::Zero) { [E166W]::GetWindow($meldung, 4) } else { [IntPtr]::Zero }   # GW_OWNER
$aBed = [int][E166W]::IsWindowEnabled($assi)
$wBed = if ($weiter -ne [IntPtr]::Zero) { [int][E166W]::IsWindowEnabled($weiter) } else { -1 }
Write-Output ('E166W Meldung ' + $meldung + ' [' + [E166W]::Titel($meldung) + '] Besitzer ' + $besitzer + ' (Assistent ' + $assi + ', Junk ' + $junk + ')')
Write-Output ('E166W bedienbar: Assistent=' + $aBed + ' Weiter=' + $wBed + ' Junk=' + [int][E166W]::IsWindowEnabled($junk))

$einge = 0
$anzahl = [int]$env:E166W_EINSCHLEUSEN
for ($i = 1; $i -le $anzahl -and $meldung -ne [IntPtr]::Zero; $i++) {
    $p.Refresh(); if ($p.HasExited) { break }
    [void][E166W]::PostMessage($assi, 0x0111, [IntPtr]12324, [IntPtr]::Zero)
    $einge++
    Start-Sleep -Seconds 2
    $p.Refresh()
    if ($p.HasExited) { Write-Output ('E166W eingeschleustes Weiter ' + $i + ': Prozess beendet'); break }
    $offen = @(Dialoge | ForEach-Object { [string]$_ + '[' + [E166W]::Titel($_) + ']' }) -join ' '
    Write-Output ('E166W eingeschleustes Weiter ' + $i + ': Dialoge ' + $offen)
}
if ($env:E166W_ABBRUCH_BEI_MELDUNG -eq '1') {
    $p.Refresh()
    if (-not $p.HasExited) {
        [void][E166W]::PostMessage($assi, 0x0111, [IntPtr]2, [IntPtr]::Zero)
        Write-Output 'E166W Abbrechen an den Assistenten bei offener Meldung'
        Start-Sleep -Seconds 3
    }
}
$p.Refresh()
$lebt = [int](-not $p.HasExited)
Write-Output ('E166W ERGEBNIS meldung=' + [int]($meldung -ne [IntPtr]::Zero) + ' assistent_bedienbar=' + $aBed + ' weiter_bedienbar=' + $wBed + ' eingeschleust=' + $einge + ' lebt=' + $lebt)

# Aufraeumen: Meldung bestaetigen, Assistent abbrechen, Junk-Frage mit No.
if ($lebt -eq 1) {
    foreach ($h in Dialoge) { if ($h -ne $assi -and $h -ne $junk) { [void][E166W]::PostMessage($h, 0x0111, [IntPtr]1, [IntPtr]::Zero) } }
    Start-Sleep -Seconds 1
    if ([E166W]::IsWindow($assi)) { [void][E166W]::PostMessage($assi, 0x0111, [IntPtr]2, [IntPtr]::Zero) }
    Start-Sleep -Seconds 1
    if ([E166W]::IsWindow($junk)) { [void][E166W]::PostMessage($junk, 0x0111, [IntPtr]2, [IntPtr]::Zero) }
}
