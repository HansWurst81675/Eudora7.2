# befehl-schicken.ps1
#
# Schickt einem laufenden Eudora einen Menuebefehl per WM_COMMAND und
# schliesst dabei auftauchende Meldungsfenster. Gedacht als Gegenstueck zu
# tools\stapel-untersuchen.ps1: das Werkzeug dort startet Eudora als
# Debuggee, dieses hier bedient es von aussen.
#
#   powershell -NonInteractive -ExecutionPolicy Bypass -File tools\befehl-schicken.ps1 `
#       -Verzeichnis <Testverzeichnis> [-Befehl 32797] [-Sekunden 60]
#
# Es werden ausschliesslich Fenster von Eudora-Prozessen bedient, deren
# Programmpfad im angegebenen Verzeichnis liegt.

param(
    [Parameter(Mandatory=$true)][string]$Verzeichnis,
    [int]$Befehl = 32797,
    [int]$Sekunden = 60
)

$ErrorActionPreference = "Stop"
$Verzeichnis = (Resolve-Path $Verzeichnis).Path

Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public class Fn {
    public delegate bool EnumProc(IntPtr h, IntPtr l);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)]
    public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)]
    public static extern bool PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
}
"@

function Eudora-Prozesse {
    Get-Process -Name Eudora -ErrorAction SilentlyContinue | Where-Object {
        $p = $null
        try { $p = $_.Path } catch { }
        $p -and $p.StartsWith($Verzeichnis, [StringComparison]::OrdinalIgnoreCase)
    }
}

function Fenster-Von([int[]]$pids) {
    $liste = New-Object System.Collections.ArrayList
    $cb = [Fn+EnumProc]{
        param($h, $l)
        $p = 0
        [void][Fn]::GetWindowThreadProcessId($h, [ref]$p)
        if ($pids -contains $p) {
            $k = New-Object System.Text.StringBuilder 256
            [void][Fn]::GetClassName($h, $k, 256)
            [void]$liste.Add([pscustomobject]@{
                H = $h; Klasse = $k.ToString(); Sichtbar = [Fn]::IsWindowVisible($h) })
        }
        return $true
    }
    [void][Fn]::EnumWindows($cb, [IntPtr]::Zero)
    return $liste
}

$geschickt = $false
$ende = (Get-Date).AddSeconds($Sekunden)
while ((Get-Date) -lt $ende) {
    Start-Sleep -Milliseconds 700
    $pids = @(Eudora-Prozesse | ForEach-Object { $_.Id })
    if ($pids.Count -eq 0) {
        if ($geschickt) { Write-Host "Eudora ist beendet."; break }
        continue
    }
    $fenster = Fenster-Von $pids
    foreach ($f in $fenster) {
        if ($f.Klasse -eq "#32770" -and $f.Sichtbar) {
            [void][Fn]::PostMessage($f.H, 0x0111, [IntPtr]1, [IntPtr]::Zero)
        }
    }
    if (-not $geschickt) {
        $haupt = $fenster | Where-Object { $_.Klasse -eq "EudoraMainWindow" } | Select-Object -First 1
        if ($haupt) {
            Write-Host "Schicke WM_COMMAND $Befehl an EudoraMainWindow"
            [void][Fn]::PostMessage($haupt.H, 0x0111, [IntPtr]$Befehl, [IntPtr]::Zero)
            $geschickt = $true
        }
    }
}

if (-not $geschickt) { Write-Host "Kein EudoraMainWindow gefunden - nichts geschickt." ; exit 1 }
exit 0
