# strg-n-pruefen.ps1
#
# Startet Eudora aus einem Testverzeichnis, schliesst auftauchende
# Meldungsfenster, schickt "Neue Nachricht" (Strg-N) bzw. "Weiterleiten"
# per WM_COMMAND und meldet, ob das Verfassen-Fenster entsteht und ob
# der Prozess ueberlebt.
#
# BEFUND E-31. Bedient Eudora ohne Maus, weil niemand danebensitzt.
#
#   powershell -NonInteractive -ExecutionPolicy Bypass -File tools\strg-n-pruefen.ps1 `
#       -Verzeichnis <Testverzeichnis> [-Befehl 32797] [-Sekunden 40]
#
# Beendet werden ausschliesslich Eudora-Prozesse, deren Pfad im
# angegebenen Verzeichnis liegt.

param(
    [Parameter(Mandatory=$true)][string]$Verzeichnis,
    [int]$Befehl = 32797,          # ID_MESSAGE_NEW; 32799 = ID_MESSAGE_FORWARD
    [int]$Sekunden = 40,
    [int]$Nachlauf = 20          # Beobachtungszeit nach dem Befehl
)

$ErrorActionPreference = "Stop"

$Verzeichnis = (Resolve-Path $Verzeichnis).Path
$exe = Join-Path $Verzeichnis "Eudora.exe"
$mail = Join-Path $Verzeichnis "Mailverzeichnis"
$log = Join-Path $mail "eudora.log"

if (-not (Test-Path $exe))  { throw "Eudora.exe fehlt in $Verzeichnis" }
if (-not (Test-Path $mail)) { throw "Mailverzeichnis fehlt in $Verzeichnis" }

Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public class Fenster {
    public delegate bool EnumProc(IntPtr h, IntPtr l);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
    [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EnumProc cb, IntPtr l);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)]
    public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)]
    public static extern IntPtr SendMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)]
    public static extern bool PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
}
"@

function Hole-Fenster([int]$pid_) {
    $liste = New-Object System.Collections.ArrayList
    $cb = [Fenster+EnumProc]{
        param($h, $l)
        $p = 0
        [void][Fenster]::GetWindowThreadProcessId($h, [ref]$p)
        if ($p -eq $pid_) {
            $k = New-Object System.Text.StringBuilder 256
            [void][Fenster]::GetClassName($h, $k, 256)
            $t = New-Object System.Text.StringBuilder 512
            [void][Fenster]::GetWindowText($h, $t, 512)
            [void]$liste.Add([pscustomobject]@{
                H = $h; Klasse = $k.ToString(); Titel = $t.ToString()
                Sichtbar = [Fenster]::IsWindowVisible($h) })
        }
        return $true
    }
    [void][Fenster]::EnumWindows($cb, [IntPtr]::Zero)
    return $liste
}

function Hole-Meldungstext([IntPtr]$h) {
    $texte = New-Object System.Collections.ArrayList
    $cb = [Fenster+EnumProc]{
        param($k, $l)
        $t = New-Object System.Text.StringBuilder 512
        [void][Fenster]::GetWindowText($k, $t, 512)
        $s = $t.ToString().Trim()
        if ($s.Length -gt 0) { [void]$texte.Add($s) }
        return $true
    }
    [void][Fenster]::EnumChildWindows($h, $cb, [IntPtr]::Zero)
    return ($texte -join " | ")
}

function Schliesse-Meldungen([int]$pid_) {
    $n = 0
    foreach ($f in (Hole-Fenster $pid_)) {
        if ($f.Klasse -eq "#32770" -and $f.Sichtbar) {
            Write-Host ("  Meldung: '" + $f.Titel + "' -> " + (Hole-Meldungstext $f.H))
            # PostMessage, nicht SendMessage: ein modaler Dialog haengt in
            # seiner eigenen Nachrichtenschleife und nimmt ein SendMessage
            # aus einem fremden Prozess nicht zuverlaessig an.
            [void][Fenster]::PostMessage($f.H, 0x0111, [IntPtr]1, [IntPtr]::Zero)
            $n++
        }
    }
    return $n
}

if (Test-Path $log) { Remove-Item $log -Force }

Write-Host "Starte $exe"
$p = Start-Process -FilePath $exe -ArgumentList "`"$mail`"" -WorkingDirectory $Verzeichnis -PassThru
$pid_ = $p.Id
Write-Host "  PID $pid_"

$haupt = [IntPtr]::Zero
$ende = (Get-Date).AddSeconds($Sekunden)
while ((Get-Date) -lt $ende) {
    Start-Sleep -Milliseconds 700
    if ($p.HasExited) { break }
    [void](Schliesse-Meldungen $pid_)
    foreach ($f in (Hole-Fenster $pid_)) {
        if ($f.Klasse -eq "EudoraMainWindow") { $haupt = $f.H }
    }
    if ($haupt -ne [IntPtr]::Zero) { break }
}

if ($p.HasExited) {
    Write-Host "ERGEBNIS: Eudora ist schon vor dem Befehl beendet (Code $($p.ExitCode))."
    exit 2
}
if ($haupt -eq [IntPtr]::Zero) {
    Write-Host "ERGEBNIS: kein EudoraMainWindow gefunden."
    Stop-Process -Id $pid_ -Force -ErrorAction SilentlyContinue
    exit 3
}

Write-Host "Hauptfenster gefunden. Fenster vor dem Befehl:"
$vorher = Hole-Fenster $pid_
foreach ($f in $vorher) { Write-Host ("  [" + $f.Klasse + "] " + $f.Titel) }

Write-Host "Schicke WM_COMMAND $Befehl"
[void][Fenster]::PostMessage($haupt, 0x0111, [IntPtr]$Befehl, [IntPtr]::Zero)

$ende = (Get-Date).AddSeconds($Nachlauf)
while ((Get-Date) -lt $ende) {
    Start-Sleep -Milliseconds 700
    if ($p.HasExited) { break }
    [void](Schliesse-Meldungen $pid_)
}

if ($p.HasExited) {
    Write-Host "ERGEBNIS: ABGESTUERZT - Eudora beendet mit Code $($p.ExitCode) (0x$('{0:X8}' -f $p.ExitCode))"
    $code = 1
} else {
    Write-Host "ERGEBNIS: Eudora laeuft noch. Fenster nach dem Befehl:"
    $nachher = Hole-Fenster $pid_
    $alt = @($vorher | ForEach-Object { $_.H })
    $neu = @($nachher | Where-Object { $alt -notcontains $_.H })
    foreach ($f in $nachher) { Write-Host ("  [" + $f.Klasse + "] " + $f.Titel) }
    if ($neu.Count -gt 0) {
        Write-Host "NEUE FENSTER:"
        foreach ($f in $neu) { Write-Host ("  [" + $f.Klasse + "] " + $f.Titel) }
        $code = 0
    } else {
        Write-Host "Kein neues Fenster entstanden."
        $code = 4
    }
}

# Nur Eudora-Prozesse aus genau diesem Verzeichnis beenden.
foreach ($q in (Get-Process -Name Eudora -ErrorAction SilentlyContinue)) {
    try { $pfad = $q.Path } catch { $pfad = $null }
    if ($pfad -and $pfad.StartsWith($Verzeichnis, [StringComparison]::OrdinalIgnoreCase)) {
        Write-Host "Beende PID $($q.Id) ($pfad)"
        Stop-Process -Id $q.Id -Force -ErrorAction SilentlyContinue
    }
}

if (Test-Path $log) {
    Write-Host "--- letzte Spurmarken aus eudora.log ---"
    Get-Content $log -Tail 25 | ForEach-Object { Write-Host "  $_" }
}
exit $code
