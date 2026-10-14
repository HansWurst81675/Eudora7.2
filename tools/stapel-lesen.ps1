# stapel-lesen.ps1 - liest den Stapel des Threads, dem ein offenes
# Meldungsfenster (#32770) eines LAUFENDEN Eudora gehoert - ohne Debugger:
# Thread kurz anhalten, Register lesen, sofort weiterlaufen lassen, dann den
# Stapelspeicher abtasten und mit der PDB symbolisieren.
#
#   C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -NoProfile `
#       -ExecutionPolicy Bypass -File tools\stapel-lesen.ps1 `
#       -Pfadfilter C:\Users\Gregor\Eudora72-1.0.85-release `
#       -Symbole    <Verzeichnis mit der passenden Eudora.pdb> `
#       -Freigabe   "<Gregors Satz>"
#
# MUSS in der 32-Bit-PowerShell laufen.
#
# WARUM ES DAS GIBT
#
# E-115 ("Encountered an improper argument" nach Ctrl+F) trat bei Gregor nur
# sporadisch auf; drei Nachstelllaeufe brachten nichts. Am 13.10.2026 stand
# die Meldung wieder offen, Gregor: "schau es dir an. ich fasse solange nichts
# an." Dieses Werkzeug las in 70 Sekunden den Stapel: CxxThrowException <-
# CMBoxTreeCtrlCheck::FindCheck (MBoxTreeCtrlCheck.cpp:938/942). Die Ursache
# stand zwei Minuten spaeter fest (Arbeitsweise/fehlerbild-ist-ein-messfenster.md).
# Bis zum CHRONIST-Lauf vom 13.10.2026 lag es nur im Scratchpad der Sitzung.
#
# GRENZEN
#
# - Es greift in Gregors Prozess ein (SuspendThread fuer wenige
#   Millisekunden). Deshalb -Freigabe als Pflicht, und der Prozess wird
#   ausschliesslich ueber -Pfadfilter gesucht, nie ueber den Namen allein.
# - Der Stapel wird ABGETASTET, nicht abgewickelt: jedes Wort, das in ein
#   Modul zeigt, wird gedruckt. Darunter sind alte Ruecksprungadressen
#   (Rauschen, z.B. "MIMEMap::GetMaps" ganz oben im E-115-Lauf). Die Kette
#   liest man von CxxThrowException nach unten.
# - Fuer mfc140.dll gibt es keine Symbole. Bis zum 13.10.2026 wurden solche
#   Worte NICHT gedruckt - der Rahmen CTreeCtrl::GetItemData, der in E-115
#   tatsaechlich warf, fehlte deshalb in der Ausgabe; bestaetigt wurde er erst
#   mit dumpbin /disasm an der Ruecksprungadresse FindCheck+68. Jetzt stehen
#   mfc-Worte ohne Symbol als "ohne Symbol 0xADRESSE" in der Ausgabe.
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.
param(
  [Parameter(Mandatory=$true)][string]$Pfadfilter,
  [Parameter(Mandatory=$true)][string]$Symbole,
  [Parameter(Mandatory=$true)][string]$Freigabe
)
if ($Freigabe.Trim().Length -lt 10) { Write-Host 'Keine tragfaehige Freigabe (mindestens 10 Zeichen, Gregors Satz).'; exit 1 }
Write-Host ('Freigabe: ' + $Freigabe)
if ([IntPtr]::Size -ne 4) { Write-Host '32-Bit-PowerShell noetig'; exit 2 }
Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class SL {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc f, IntPtr l);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("kernel32.dll")] public static extern IntPtr OpenThread(uint a, bool i, uint id);
  [DllImport("kernel32.dll")] public static extern IntPtr OpenProcess(uint a, bool i, uint id);
  [DllImport("kernel32.dll")] public static extern uint SuspendThread(IntPtr h);
  [DllImport("kernel32.dll")] public static extern uint ResumeThread(IntPtr h);
  [DllImport("kernel32.dll")] public static extern bool GetThreadContext(IntPtr h, byte[] c);
  [DllImport("kernel32.dll")] public static extern bool ReadProcessMemory(IntPtr h, IntPtr a, byte[] b, int n, out int g);
  [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
  [DllImport("kernel32.dll",CharSet=CharSet.Ansi)] public static extern int lstrlenA(IntPtr p);
  [DllImport("psapi.dll")] public static extern bool EnumProcessModules(IntPtr h, [Out] IntPtr[] m, uint cb, out uint n);
  [DllImport("psapi.dll",CharSet=CharSet.Ansi)] public static extern uint GetModuleFileNameEx(IntPtr h, IntPtr m, StringBuilder s, uint n);
  [DllImport("psapi.dll")] public static extern bool GetModuleInformation(IntPtr h, IntPtr m, byte[] i, uint cb);
  [DllImport("dbghelp.dll",CharSet=CharSet.Ansi)] public static extern bool SymInitialize(IntPtr h, string p, bool inv);
  [DllImport("dbghelp.dll")] public static extern uint SymSetOptions(uint o);
  [DllImport("dbghelp.dll")] public static extern bool SymFromAddr(IntPtr h, ulong a, out ulong v, byte[] s);
  [DllImport("dbghelp.dll")] public static extern bool SymGetLineFromAddr64(IntPtr h, ulong a, out uint v, byte[] l);
}
"@
$proz = @(Get-Process Eudora -ErrorAction SilentlyContinue | Where-Object { $_.Path -like ($Pfadfilter.TrimEnd('\') + '\*') })
if ($proz.Count -ne 1) { Write-Host ('Eudora unter ' + $Pfadfilter + ': ' + $proz.Count + ' Prozesse'); exit 1 }
$procId = [uint32]$proz[0].Id
$tid = 0; $titel = ''
[SL]::EnumWindows({ param($h,$l) $p = 0; $t = [SL]::GetWindowThreadProcessId($h, [ref]$p)
  if ($p -eq $procId -and [SL]::IsWindowVisible($h)) { $k = New-Object Text.StringBuilder 64; [void][SL]::GetClassName($h,$k,64)
    if ($k.ToString() -eq '#32770') { $w = New-Object Text.StringBuilder 128; [void][SL]::GetWindowText($h,$w,128); $script:tid = $t; $script:titel = $w.ToString() } }
  return $true }, [IntPtr]::Zero) | Out-Null
if (-not $tid) { Write-Host 'kein offenes Meldungsfenster'; exit 1 }
Write-Host ("Prozess " + $procId + ", Meldungsfenster '" + $titel + "' gehoert Thread " + $tid)
$hT = [SL]::OpenThread(0x0058, $false, [uint32]$tid)    # GET_CONTEXT | SUSPEND_RESUME | QUERY_INFORMATION
$ctx = New-Object byte[] 1024; [BitConverter]::GetBytes([uint32]0x10001).CopyTo($ctx, 0)
[void][SL]::SuspendThread($hT); $ok = [SL]::GetThreadContext($hT, $ctx); [void][SL]::ResumeThread($hT); [void][SL]::CloseHandle($hT)
if (-not $ok) { Write-Host 'GetThreadContext fehlgeschlagen'; exit 1 }
$esp = [BitConverter]::ToUInt32($ctx, 196); Write-Host ("ESP 0x{0:X8} (Thread lief nach dem Lesen sofort weiter)" -f $esp)
$hP = [SL]::OpenProcess(0x0410, $false, $procId)          # QUERY_INFORMATION | VM_READ
[void][SL]::SymSetOptions(0x12); [void][SL]::SymInitialize($hP, ($Symbole + ';' + $Pfadfilter), $true)
$mods = New-Object IntPtr[] 512; $n = 0; [void][SL]::EnumProcessModules($hP, $mods, 2048, [ref]$n)
$liste = @(); for ($i = 0; $i -lt [Math]::Min(512, [int]($n/4)); $i++) { $sb = New-Object Text.StringBuilder 260; [void][SL]::GetModuleFileNameEx($hP, $mods[$i], $sb, 260)
  $mi = New-Object byte[] 12; if ([SL]::GetModuleInformation($hP, $mods[$i], $mi, 12)) { $liste += [PSCustomObject]@{ Name = (Split-Path $sb.ToString() -Leaf); Basis = [BitConverter]::ToUInt32($mi,0); Groesse = [BitConverter]::ToUInt32($mi,4) } } }
function Modul($a) { foreach ($m in $liste) { if ($a -ge $m.Basis -and $a -lt $m.Basis + $m.Groesse) { return $m.Name } } return $null }
function Name($a) { $s = New-Object byte[] 600; [BitConverter]::GetBytes([uint32]88).CopyTo($s,0); [BitConverter]::GetBytes([uint32]500).CopyTo($s,80); $v = [uint64]0; $r = ''
  if ([SL]::SymFromAddr($hP, [uint64]$a, [ref]$v, $s)) { $l = [BitConverter]::ToUInt32($s,76); if ($l -gt 0 -and $l -lt 500) { $r = [Text.Encoding]::ASCII.GetString($s,84,$l) + '+' + $v } }
  $z = New-Object byte[] 24; [BitConverter]::GetBytes([uint32]24).CopyTo($z,0); $w = 0
  if ([SL]::SymGetLineFromAddr64($hP, [uint64]$a, [ref]$w, $z)) { $pz = [IntPtr][BitConverter]::ToInt32($z,12); if ($pz -ne [IntPtr]::Zero) { $r += '   ' + (Split-Path ([Runtime.InteropServices.Marshal]::PtrToStringAnsi($pz, [SL]::lstrlenA($pz))) -Leaf) + ':' + [BitConverter]::ToUInt32($z,8) } }
  return $r }
$groesse = 0x30000; $buf = New-Object byte[] $groesse; $g = 0
$basis = [IntPtr]([BitConverter]::ToInt32([BitConverter]::GetBytes($esp), 0))
while (-not [SL]::ReadProcessMemory($hP, $basis, $buf, $groesse, [ref]$g) -and $groesse -gt 0x1000) { $groesse -= 0x1000; $buf = New-Object byte[] $groesse }
Write-Host ("{0} Bytes Stapel gelesen" -f $groesse)
$gezeigt = 0
for ($o = 0; $o -lt $groesse - 4 -and $gezeigt -lt 120; $o += 4) { $w = [BitConverter]::ToUInt32($buf, $o); $m = Modul $w
  if ($m -and ($m -like 'Eudora*' -or $m -like 'mfc*' -or $m -like 'KERNELBASE*' -or $m -like 'vcruntime*' -or $m -like 'ucrtbase*')) { $nm = Name $w
    if (-not $nm -and $m -like 'mfc*') { $nm = ('ohne Symbol 0x{0:X8}' -f $w) }
    if ($nm -or $m -like 'Eudora*') { Write-Host ("  +0x{0:X5}  {1,-14} {2}" -f $o, $m, $nm); $gezeigt++ } } }
