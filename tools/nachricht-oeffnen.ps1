# nachricht-oeffnen.ps1 - eine Nachricht in einem laufenden Eudora oeffnen,
# ohne Maus und ohne Tastendruecke ins Leere.
#
# WARUM ES DAS GIBT
#
# BEFUND E-80 (Kopfzeilen lassen sich nicht ausblenden) zeigt sich nur in
# einem echten Nachrichtenfenster. Die Vorschau benutzt eine andere Klasse:
# PgReadMsgPreview und PgReadMsgView erben beide von PgMsgView, aber nicht
# voneinander - die Spurmarke in PgReadMsgView schriebe bei der Vorschau
# gar nichts.
#
# Ein Nachrichtenfenster entsteht durch einen Doppelklick. Den kann dieses
# Projekt nicht erzeugen: SendKeys trifft das Fenster im Vordergrund und
# nicht unbedingt das gemeinte (siehe
# Arbeitsweise/keine-tastendruecke-verschicken.md, Gregors Bitte vom
# 06.09.2026, seine Explorer-Fenster in Ruhe zu lassen).
#
# Was erlaubt und verlaesslich ist: eine Fensterbotschaft an ein GEMESSENES
# Handle. Genau das tut dieses Werkzeug - es sucht die Nachrichtenliste
# eines Postfachfensters und schickt ihr WM_KEYDOWN/WM_KEYUP mit VK_RETURN.
# Die Eingabetaste oeffnet in Eudora die markierte Nachricht.
#
# Es werden ausschliesslich Fenster von Eudora-Prozessen bedient, deren
# Programmpfad im angegebenen Verzeichnis liegt - dieselbe Vorsichtsregel
# wie in befehl-schicken.ps1 und testlauf.ps1.
#
# Aufruf:
#   powershell -ExecutionPolicy Bypass -File tools\nachricht-oeffnen.ps1 `
#       -Pfadfilter C:\Temp\E80 [-Sekunden 20]

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [int] $Sekunden = 20
)

$ErrorActionPreference = 'Stop'

Add-Type -TypeDefinition @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public class Fenster {
  public delegate bool EnumProc(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EnumProc f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Auto)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr SendMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr SetFocus(IntPtr h);
}
'@ -ErrorAction SilentlyContinue

# --- Nur Prozesse aus dem angegebenen Verzeichnis --------------------------
$pids = @(Get-Process -Name 'Eudora' -ErrorAction Ignore |
          Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') } |
          ForEach-Object { [uint32] $_.Id })

if ($pids.Count -eq 0) {
    Write-Host "  Kein Eudora aus $Pfadfilter gefunden."
    exit 1
}
Write-Host ("  Eudora-Prozess(e): {0}" -f ($pids -join ', '))

# --- Alle Fenster dieser Prozesse einsammeln ------------------------------
$script:gefunden = @()

$sammeln = [Fenster+EnumProc] {
    param($h, $p)
    $pid2 = [uint32] 0
    [void][Fenster]::GetWindowThreadProcessId($h, [ref] $pid2)
    if ($pids -notcontains $pid2) { return $true }

    $k = New-Object System.Text.StringBuilder 256
    [void][Fenster]::GetClassName($h, $k, 256)
    $tt = New-Object System.Text.StringBuilder 256
    [void][Fenster]::GetWindowText($h, $tt, 256)

    $script:gefunden += [pscustomobject]@{
        Handle = $h
        Klasse = $k.ToString()
        Titel  = $tt.ToString()
        Sicht  = [Fenster]::IsWindowVisible($h)
    }

    $kind = [Fenster+EnumProc] {
        param($hk, $pk)
        $kk = New-Object System.Text.StringBuilder 256
        [void][Fenster]::GetClassName($hk, $kk, 256)
        $tk = New-Object System.Text.StringBuilder 256
        [void][Fenster]::GetWindowText($hk, $tk, 256)
        $script:gefunden += [pscustomobject]@{
            Handle = $hk
            Klasse = $kk.ToString()
            Titel  = $tk.ToString()
            Sicht  = [Fenster]::IsWindowVisible($hk)
        }
        return $true
    }
    [void][Fenster]::EnumChildWindows($h, $kind, [IntPtr]::Zero)
    return $true
}

# Dem Start Zeit lassen: die Postfachfenster aus [Settings] OpenWindow*
# erscheinen erst, wenn das Hauptfenster steht. Der erste Anlauf hat zu
# frueh gemessen und gar kein Postfachfenster gefunden.
$warten = 0
do {
    $script:gefunden = @()
    [void][Fenster]::EnumWindows($sammeln, [IntPtr]::Zero)
    $da = @($script:gefunden | Where-Object { $_.Sicht -and $_.Titel -match '^(In|Out|Junk|Trash|GMX|HW_Bxo|WaipuTV)$' })
    if ($da.Count -gt 0) { break }
    Start-Sleep -Milliseconds 700
    $warten++
} while ($warten -lt 12)

Write-Host ("  Fenster insgesamt: {0} (nach {1} Durchgaengen)" -f $script:gefunden.Count, ($warten + 1))
Write-Host '  Alle sichtbaren mit Titel:'
$script:gefunden | Where-Object { $_.Sicht -and $_.Titel } |
    Select-Object -First 20 |
    ForEach-Object { Write-Host ("    {0,-46} {1}" -f $_.Klasse, ($_.Titel -replace '\s+',' ')) }

# --- Die Nachrichtenliste suchen ------------------------------------------
# Eudoras Nachrichtenliste ist ein eigenes Steuerelement; erkennbar ist sie
# daran, dass sie sichtbar ist und in einem MDI-Kindfenster sitzt. Zur
# Sicherheit werden alle sichtbaren Kandidaten gemeldet, bevor einer
# bedient wird.
$kandidaten = @($script:gefunden | Where-Object { $_.Sicht -and $_.Klasse -match 'ListBox|SumListBox|Afx' })

Write-Host '  Sichtbare Kandidaten:'
$kandidaten | Select-Object -First 12 | ForEach-Object {
    Write-Host ("    {0,-46} {1}" -f $_.Klasse, ($_.Titel -replace '\s+', ' '))
}

$VK_RETURN = 0x0D
$WM_KEYDOWN = 0x0100
$WM_KEYUP   = 0x0101
$WM_LBUTTONDBLCLK = 0x0203

# Die Nachrichtenliste ist ein Kind des MDI-Kindfensters, dessen Titel der
# Postfachname ist. Der erste Anlauf hat stattdessen die Werkzeugleiste
# erwischt (AfxControlBar140) - deshalb wird jetzt vom Postfachfenster aus
# gesucht statt ueber den Klassennamen.
$postfach = @($script:gefunden | Where-Object {
    $_.Sicht -and $_.Klasse -match '^Afx:' -and
    $_.Titel -match '^(In|Out|Junk|Trash|GMX|HW_Bxo|WaipuTV)$'
}) | Select-Object -First 1

$ziel = $null
if ($postfach) {
    Write-Host ("  Postfachfenster: {0} ({1})" -f $postfach.Titel, $postfach.Handle)
    $kinder = @()
    $sammelKind = [Fenster+EnumProc] {
        param($hk, $pk)
        $kk = New-Object System.Text.StringBuilder 256
        [void][Fenster]::GetClassName($hk, $kk, 256)
        $script:kinderListe += [pscustomobject]@{ Handle = $hk; Klasse = $kk.ToString() }
        return $true
    }
    $script:kinderListe = @()
    [void][Fenster]::EnumChildWindows($postfach.Handle, $sammelKind, [IntPtr]::Zero)
    Write-Host '  Kinder des Postfachfensters:'
    $script:kinderListe | ForEach-Object { Write-Host ("    {0}  {1}" -f $_.Handle, $_.Klasse) }
    # Die Nachrichtenliste ist eine ListBox. Gemessen am 11.09.2026: das
    # Postfachfenster "In" hat vier Kinder - AfxMDIFrame140 (Rahmen),
    # #32770 (Dialog), ListBox (die Nachrichten) und Button (die
    # Groessenanzeige unten links). Der erste Anlauf hat den Rahmen
    # erwischt, weil er nur Rahmen und Rollbalken ausschloss.
    $ziel = $script:kinderListe | Where-Object { $_.Klasse -eq 'ListBox' } | Select-Object -First 1
    if (-not $ziel) {
        $ziel = $script:kinderListe |
                Where-Object { $_.Klasse -notmatch 'ControlBar|ScrollBar|MDIFrame|^#32770$|^Button$' } |
                Select-Object -First 1
    }
}

if (-not $ziel) {
    Write-Host '  Kein Postfachfenster mit Nachrichtenliste gefunden.'
    exit 1
}

Write-Host ("  Ziel: {0} ({1})" -f $ziel.Klasse, $ziel.Handle)

[void][Fenster]::SetFocus($ziel.Handle)
[void][Fenster]::PostMessage($ziel.Handle, $WM_KEYDOWN, [IntPtr]$VK_RETURN, [IntPtr]0)
[void][Fenster]::PostMessage($ziel.Handle, $WM_KEYUP,   [IntPtr]$VK_RETURN, [IntPtr]0)
Write-Host '  VK_RETURN geschickt.'

Start-Sleep -Seconds 3

# --- Was danach dasteht ----------------------------------------------------
$script:gefunden = @()
[void][Fenster]::EnumWindows($sammeln, [IntPtr]::Zero)
$neue = @($script:gefunden | Where-Object { $_.Sicht -and $_.Titel -and $_.Titel.Length -gt 3 })
Write-Host '  Sichtbare Fenster mit Titel danach:'
$neue | Select-Object -First 10 | ForEach-Object { Write-Host ("    {0}" -f ($_.Titel -replace '\s+', ' ')) }

exit 0
