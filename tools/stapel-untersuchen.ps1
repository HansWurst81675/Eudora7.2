# Findet die Ursache eines toedlichen Absturzes: Aufrufstapel und Endlosrekursion.
#
#   C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass `
#       -File tools\stapel-untersuchen.ps1 -Exe <pfad\zur.exe> [-Argumente "..."] [-Sekunden 60]
#
# MUSS in der 32-Bit-PowerShell laufen - Eudora ist ein 32-Bit-Programm, und
# DEBUG_EVENT sowie CONTEXT haben dort das passende Format.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Beim ersten Startversuch am 30.08.2026 starb Eudora mit
# EXCEPTION_STACK_OVERFLOW beim Erzeugen des Hauptfensters. Eudoras eigener
# Absturzbehandler (BugslayerUtil/CrashHandler.cpp:286) gibt dabei bewusst nur
# eine Zeile aus - auf einem vollen Stapel kann er nichts mehr tun. Auf der
# Maschine ist kein Debugger installiert. Also beobachtet dieses Werkzeug von
# aussen: es startet das Programm als Debuggee, wartet auf die toedliche
# Ausnahme, laeuft die EBP-Kette ab und symbolisiert mit dbghelp.dll.
#
# Bei einer Endlosrekursion sind fast alle Rahmen identisch. Deshalb werden die
# haeufigsten Adressen als "Zyklus" ausgewiesen und nur die uebrigen Rahmen
# gedruckt - dort steht, WER die Rekursion ausgeloest hat.
#
# VORAUSSETZUNG: die .pdb muss neben der .exe liegen.

param(
  [Parameter(Mandatory=$true)][string]$Exe,
  [string]$Argumente = "",
  [int]$Sekunden = 90
)

if ([IntPtr]::Size -ne 4) {
  Write-Error "Muss in der 32-Bit-PowerShell laufen: C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
  exit 2
}

Add-Type @"
using System;using System.Text;using System.Runtime.InteropServices;
public class Dbg {
  [StructLayout(LayoutKind.Sequential)] public struct STARTUPINFO {
    public uint cb; public string a,b,c; public uint dx,dy,xs,ys,xc,yc,fill,flags;
    public ushort showWindow, cbReserved2; public IntPtr lpReserved2, hStdIn, hStdOut, hStdErr; }
  [StructLayout(LayoutKind.Sequential)] public struct PROCESS_INFORMATION {
    public IntPtr hProcess, hThread; public uint dwProcessId, dwThreadId; }
  [DllImport("kernel32.dll",CharSet=CharSet.Ansi,SetLastError=true)] public static extern bool CreateProcess(
    string app,string cmd,IntPtr pa,IntPtr ta,bool inherit,uint flags,IntPtr env,string dir,
    ref STARTUPINFO si, out PROCESS_INFORMATION pi);
  [DllImport("kernel32.dll")] public static extern bool WaitForDebugEvent(byte[] ev,uint ms);
  [DllImport("kernel32.dll")] public static extern bool ContinueDebugEvent(uint pid,uint tid,uint status);
  [DllImport("kernel32.dll")] public static extern IntPtr OpenThread(uint acc,bool inh,uint tid);
  [DllImport("kernel32.dll")] public static extern bool GetThreadContext(IntPtr h,byte[] ctx);
  [DllImport("kernel32.dll")] public static extern bool ReadProcessMemory(IntPtr h,IntPtr adr,byte[] buf,int n,out int gelesen);
  [DllImport("kernel32.dll")] public static extern bool TerminateProcess(IntPtr h,uint code);
  [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
  [DllImport("kernel32.dll",CharSet=CharSet.Ansi)] public static extern int lstrlenA(IntPtr p);
  [DllImport("dbghelp.dll",CharSet=CharSet.Ansi,SetLastError=true)] public static extern bool SymInitialize(IntPtr h,string pfad,bool invade);
  [DllImport("dbghelp.dll")] public static extern uint SymSetOptions(uint o);
  [DllImport("dbghelp.dll",CharSet=CharSet.Ansi,SetLastError=true)] public static extern bool SymFromAddr(IntPtr h,ulong adr,out ulong versatz,byte[] sym);
  [DllImport("dbghelp.dll",CharSet=CharSet.Ansi,SetLastError=true)] public static extern bool SymGetLineFromAddr64(IntPtr h,ulong adr,out uint versatz,byte[] zeile);
  [DllImport("psapi.dll",CharSet=CharSet.Ansi)] public static extern uint GetModuleFileNameEx(IntPtr h,IntPtr mod,StringBuilder s,uint n);
  [DllImport("psapi.dll")] public static extern bool EnumProcessModules(IntPtr h,[Out] IntPtr[] mods,uint cb,out uint benoetigt);
  [DllImport("psapi.dll")] public static extern bool GetModuleInformation(IntPtr h,IntPtr mod,byte[] info,uint cb);
}
"@

$DEBUG_ONLY_THIS_PROCESS    = 2
$DBG_EXCEPTION_NOT_HANDLED  = [uint32]2147549185   # 0x80010001
$DBG_CONTINUE               = [uint32]65538        # 0x00010002
$STATUS_STACK_OVERFLOW      = [uint32]3221225725   # 0xC00000FD
$STATUS_BREAKPOINT          = [uint32]2147483651   # 0x80000003
$CONTEXT_CONTROL            = 65537                # 0x00010001
$THREAD_ALL                 = 2032639              # 0x001F03FF

$script:module = @()
function Modul($a) {
  foreach ($m in $script:module) {
    if ($a -ge $m.Basis -and $a -lt $m.Basis + $m.Groesse) { return $m.Name }
  }
  return "-"
}

$si = New-Object Dbg+STARTUPINFO
$si.cb = [Runtime.InteropServices.Marshal]::SizeOf($si)
$pi = New-Object Dbg+PROCESS_INFORMATION
if ($Argumente) { $cmd = '"' + $Exe + '" ' + $Argumente } else { $cmd = '"' + $Exe + '"' }
if (-not [Dbg]::CreateProcess($Exe,$cmd,[IntPtr]::Zero,[IntPtr]::Zero,$false,$DEBUG_ONLY_THIS_PROCESS,[IntPtr]::Zero,(Split-Path $Exe),[ref]$si,[ref]$pi)) {
  Write-Error ("CreateProcess fehlgeschlagen: " + [Runtime.InteropServices.Marshal]::GetLastWin32Error())
  exit 2
}
Write-Host ("Gestartet als Debuggee, PID " + $pi.dwProcessId + ".")

function Beschreibe($adr) {
  $sym = New-Object byte[] 600
  [BitConverter]::GetBytes([uint32]88).CopyTo($sym,0)
  [BitConverter]::GetBytes([uint32]500).CopyTo($sym,80)
  $vs = [uint64]0
  $nm = "?"
  if ([Dbg]::SymFromAddr($pi.hProcess,[uint64]$adr,[ref]$vs,$sym)) {
    $ln = [BitConverter]::ToUInt32($sym,76)
    if ($ln -gt 0 -and $ln -lt 500) { $nm = [Text.Encoding]::ASCII.GetString($sym,84,$ln) + " + " + $vs }
  }
  $q = ""
  $zl = New-Object byte[] 24
  [BitConverter]::GetBytes([uint32]24).CopyTo($zl,0)
  $vz = 0
  if ([Dbg]::SymGetLineFromAddr64($pi.hProcess,[uint64]$adr,[ref]$vz,$zl)) {
    $nr = [BitConverter]::ToUInt32($zl,8)
    $pz = [IntPtr][BitConverter]::ToInt32($zl,12)
    if ($pz -ne [IntPtr]::Zero) {
      $dn = [Runtime.InteropServices.Marshal]::PtrToStringAnsi($pz,[Dbg]::lstrlenA($pz))
      $q = "   " + (Split-Path $dn -Leaf) + ":" + $nr
    }
  }
  return ("{0,-14} {1}{2}" -f (Modul $adr), $nm, $q)
}

$ev = New-Object byte[] 256
$ende = (Get-Date).AddSeconds($Sekunden)
$gefunden = $false

while ((Get-Date) -lt $ende) {
  if (-not [Dbg]::WaitForDebugEvent($ev,500)) { continue }
  $code = [BitConverter]::ToUInt32($ev,0)
  $pidD = [BitConverter]::ToUInt32($ev,4)
  $tid  = [BitConverter]::ToUInt32($ev,8)
  $weiter = $DBG_CONTINUE

  if ($code -eq 1) {
    $exc  = [BitConverter]::ToUInt32($ev,12)
    $erst = [BitConverter]::ToUInt32($ev,92)
    $weiter = $DBG_EXCEPTION_NOT_HANDLED

    # Melden bei Stapelueberlauf (immer toedlich) oder bei jeder Ausnahme in
    # zweiter Gelegenheit - dann hat das Programm sie nicht behandelt.
    if ($exc -eq $STATUS_STACK_OVERFLOW -or ($erst -eq 0 -and $exc -ne $STATUS_BREAKPOINT)) {
      Write-Host ""
      Write-Host ("AUSNAHME 0x{0:X8} in Thread {1} (erste Gelegenheit: {2})" -f $exc,$tid,$erst)
      $hT = [Dbg]::OpenThread($THREAD_ALL,$false,$tid)
      $ctx = New-Object byte[] 1024
      [BitConverter]::GetBytes([uint32]$CONTEXT_CONTROL).CopyTo($ctx,0)
      if ([Dbg]::GetThreadContext($hT,$ctx)) {
        $eip = [BitConverter]::ToUInt32($ctx,184)
        $ebp = [BitConverter]::ToUInt32($ctx,180)
        $esp = [BitConverter]::ToUInt32($ctx,196)

        [void][Dbg]::SymSetOptions(18)                 # UNDNAME | LOAD_LINES
        [void][Dbg]::SymInitialize($pi.hProcess,(Split-Path $Exe),$true)

        $mods = New-Object IntPtr[] 512
        $noetig = 0
        if ([Dbg]::EnumProcessModules($pi.hProcess,$mods,2048,[ref]$noetig)) {
          $anz = [Math]::Min(512,[int]($noetig/4))
          for ($m = 0; $m -lt $anz; $m++) {
            $sb = New-Object Text.StringBuilder 260
            [void][Dbg]::GetModuleFileNameEx($pi.hProcess,$mods[$m],$sb,260)
            $mi = New-Object byte[] 12
            if ([Dbg]::GetModuleInformation($pi.hProcess,$mods[$m],$mi,12)) {
              $script:module += [PSCustomObject]@{
                Name    = (Split-Path $sb.ToString() -Leaf)
                Basis   = [BitConverter]::ToUInt32($mi,0)
                Groesse = [BitConverter]::ToUInt32($mi,4)
              }
            }
          }
        }

        Write-Host ("EIP 0x{0:X8}  {1}" -f $eip,(Beschreibe $eip))
        Write-Host ("ESP 0x{0:X8}   EBP 0x{1:X8}" -f $esp,$ebp)

        # EBP-Kette ganz ablaufen
        $rahmen = New-Object Collections.ArrayList
        $wort = New-Object byte[] 8
        for ($f = 0; $f -lt 40000 -and $ebp -gt 4096; $f++) {
          $gl = 0
          if (-not [Dbg]::ReadProcessMemory($pi.hProcess,[IntPtr][int]$ebp,$wort,8,[ref]$gl)) { break }
          $neuEbp = [BitConverter]::ToUInt32($wort,0)
          $rueck  = [BitConverter]::ToUInt32($wort,4)
          if ($rueck -eq 0) { break }
          [void]$rahmen.Add($rueck)
          if ($neuEbp -le $ebp) { break }
          $ebp = $neuEbp
        }
        Write-Host ""
        Write-Host ("" + $rahmen.Count + " Rahmen abgelaufen.")

        if ($rahmen.Count -gt 100) {
          $gr = $rahmen | Group-Object | Sort-Object Count -Descending
          Write-Host ""
          Write-Host "Der Zyklus (haeufigste Rahmen):"
          foreach ($g in ($gr | Select-Object -First 4)) {
            $a = [uint32]$g.Name
            Write-Host ("  {0,7} x  0x{1:X8}  {2}" -f $g.Count,$a,(Beschreibe $a))
          }
          $zyklus = @($gr | Select-Object -First 2 | ForEach-Object { [uint32]$_.Name })
          Write-Host ""
          Write-Host "Rahmen ausserhalb des Zyklus - hier steht der Ausloeser:"
          $andere = 0
          for ($i = 0; $i -lt $rahmen.Count; $i++) {
            if ($zyklus -notcontains $rahmen[$i]) {
              Write-Host ("  {0,6}  0x{1:X8}  {2}" -f $i,$rahmen[$i],(Beschreibe $rahmen[$i]))
              $andere++
              if ($andere -ge 40) { Write-Host "  ... weitere unterdrueckt"; break }
            }
          }
        } else {
          Write-Host ""
          Write-Host "Aufrufstapel:"
          for ($i = 0; $i -lt $rahmen.Count; $i++) {
            Write-Host ("  {0,4}  0x{1:X8}  {2}" -f $i,$rahmen[$i],(Beschreibe $rahmen[$i]))
          }
        }
        $gefunden = $true
      } else {
        Write-Host "GetThreadContext fehlgeschlagen."
      }
      [void][Dbg]::CloseHandle($hT)
      [void][Dbg]::TerminateProcess($pi.hProcess,1)
      [void][Dbg]::ContinueDebugEvent($pidD,$tid,$weiter)
      break
    }
  }
  elseif ($code -eq 5) {
    [void][Dbg]::ContinueDebugEvent($pidD,$tid,$weiter)
    break
  }

  [void][Dbg]::ContinueDebugEvent($pidD,$tid,$weiter)
}

if (-not $gefunden) {
  Write-Host "Keine toedliche Ausnahme beobachtet."
  [void][Dbg]::TerminateProcess($pi.hProcess,1)
  exit 1
}
exit 0
