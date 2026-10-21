# messen-k9.ps1 - waehlt ein Rechtsklick im Adressbuch den getroffenen
# Eintrag aus? (PRUEFER-43 K9, gleiche Ursache wie E-134.)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript und bekommt -Pfadfilter.
# Die Zeilenhoehe des Baums ist ueber TVM_GETITEMHEIGHT quer ueber die
# Prozessgrenze nicht verlaesslich zu holen (gemessen 21.10.2026: 16777215).
# Deshalb wird an mehreren Hoehen geklickt und nach jedem Klick der Zustand
# TVIS_SELECTED aller Kinder gelesen.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter
)
$ErrorActionPreference = 'Stop'
Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class K9 {
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint fl, uint ms, out IntPtr r);
  public delegate bool EP(IntPtr h, IntPtr p);
}
"@
function Kl($h){ $s=New-Object Text.StringBuilder 256; [void][K9]::GetClassName($h,$s,256); $s.ToString() }
function Snd($h,$m,$w,$l){ $r=[IntPtr]::Zero; [void][K9]::SendMessageTimeoutA($h,$m,$w,$l,0x0002,3000,[ref]$r); return $r }
function Alle($pp){ $r=New-Object System.Collections.ArrayList
  $cb=[K9+EP]{ param($h,$p); $o=0;[void][K9]::GetWindowThreadProcessId($h,[ref]$o)
    if($o -eq $pp){ $cc=[K9+EP]{ param($k,$q)
        if([K9]::IsWindowVisible($k)){[void]$r.Add([pscustomobject]@{H=$k;Id=[K9]::GetDlgCtrlID($k);Klasse=(Kl $k)})}
        return $true }; [void][K9]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
      [void]$r.Add([pscustomobject]@{H=$h;Id=[K9]::GetDlgCtrlID($h);Klasse=(Kl $h)}) }
    return $true }
  [void][K9]::EnumWindows($cb,[IntPtr]::Zero); return $r }

$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter,'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "K9 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
$haupt = Alle $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' } | Select-Object -First 1
if (-not $haupt) { Write-Host 'K9 FEHLER: kein Hauptfenster'; exit 1 }

# Kontenassistenten wegraeumen, er haelt sonst die Botschaften auf
foreach ($a in (Alle $pp | Where-Object { $_.Klasse -eq '#32770' })) {
    [void][K9]::PostMessageA($a.H, 0x0010, [IntPtr]0, [IntPtr]0) }
Start-Sleep -Seconds 2

[void][K9]::PostMessageA($haupt.H, 0x0111, [IntPtr]32828, [IntPtr]::Zero)   # ID_WINDOW_NICKNAMES
Start-Sleep -Seconds 4
$baum = (Alle $pp | Where-Object { $_.Klasse -eq 'SysTreeView32' -and $_.Id -eq 436 } | Select-Object -First 1)
if (-not $baum) { Write-Host 'K9 FEHLER: Adressbuchbaum nicht gefunden'; exit 1 }

$GETNEXT=0x110A; $GETSTATE=0x1127; $ROOT=0x0000; $CHILD=0x0004; $NEXT=0x0001
function Zustand {
    $w = Snd $baum.H $GETNEXT ([IntPtr]$ROOT) ([IntPtr]0)
    $aus = @()
    while ($w -ne [IntPtr]::Zero) {
        $k = Snd $baum.H $GETNEXT ([IntPtr]$CHILD) $w
        while ($k -ne [IntPtr]::Zero) {
            $s = [int](Snd $baum.H $GETSTATE $k ([IntPtr]0x0002))
            if ($s -band 0x0002) { $aus += $k }
            $k = Snd $baum.H $GETNEXT ([IntPtr]$NEXT) $k
        }
        $w = Snd $baum.H $GETNEXT ([IntPtr]$NEXT) $w
    }
    return $aus
}

Write-Host ("K9 ausgewaehlte Kinder vor dem Klick: {0}" -f (Zustand).Count)
foreach ($y in 10,26,42,58,74) {
    $lp = ($y -shl 16) -bor 60
    [void][K9]::PostMessageA($baum.H, 0x0204, [IntPtr]2, [IntPtr]$lp)   # WM_RBUTTONDOWN
    [void][K9]::PostMessageA($baum.H, 0x0205, [IntPtr]0, [IntPtr]$lp)   # WM_RBUTTONUP
    Start-Sleep -Milliseconds 900
    foreach ($m in (Alle $pp | Where-Object { $_.Klasse -eq '#32768' })) {
        [void][K9]::PostMessageA($m.H, 0x0100, [IntPtr]0x1B, [IntPtr]1) }   # Menue mit ESC schliessen
    Start-Sleep -Milliseconds 400
    Write-Host ("K9 Rechtsklick y={0,-3} -> ausgewaehlte Kinder {1}" -f $y, (Zustand).Count)
}
Write-Host 'K9 fertig'
