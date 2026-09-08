# leisten-messen.ps1 - misst die Lage der Wazoo-Leisten eines laufenden Eudora.
#
# Zweck: Anforderung A-2 und Kriterium 8 aus ZIEL.md pruefbar machen. Ein
# Bildschirmfoto ist kein Messwert; hier kommen Andockseite, Sichtbarkeit,
# Groesse und Lage jeder Leiste als Zahlen heraus.
#
# Aufruf:
#   powershell -NoProfile -ExecutionPolicy Bypass -File tools\leisten-messen.ps1
#   powershell ... -File tools\leisten-messen.ps1 -Pfadfilter 'C:\Temp\E44'
#
# -Pfadfilter ist eine Vorsichtsmassnahme, keine Bequemlichkeit: auf Gregors
# Rechner laeuft sein eigenes Eudora. Ohne Filter wird JEDER Prozess gemessen
# und der Pfad mit ausgegeben, damit man sieht, welchen man vor sich hat.
# Gemessen wird nur - dieses Skript schickt keine Nachricht und beendet nichts.
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

[CmdletBinding()]
param(
    # Nur Prozesse, deren Programmpfad hiermit anfaengt.
    [string] $Pfadfilter = '',
    # Kennungen der Wazoo-Leisten. 318/319/320 = IDC_WAZOOBAR_BASE + 0..2
    # (Eudora71/Eudora/resource.h:225), 316 = IDC_AD_WAZOO_BAR.
    [int[]] $Kennungen = @(316, 318, 319, 320)
)

$ErrorActionPreference = 'Stop'

$quelle = @'
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public class Leisten
{
    public delegate bool EnumProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EnumProc p, IntPtr l);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc p, IntPtr l);
    [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetClassName(IntPtr h, StringBuilder s, int max);
    [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int max);
    [DllImport("user32.dll")] public static extern int GetWindowLong(IntPtr h, int i);
    [DllImport("user32.dll")] public static extern IntPtr GetParent(IntPtr h);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT { public int left, top, right, bottom; }

    public const int GWL_ID = -12;
    public const int GWL_STYLE = -16;

    public static List<IntPtr> Kinder(IntPtr eltern)
    {
        List<IntPtr> l = new List<IntPtr>();
        EnumChildWindows(eltern, delegate(IntPtr h, IntPtr p) { l.Add(h); return true; }, IntPtr.Zero);
        return l;
    }

    public static List<IntPtr> OberFenster()
    {
        List<IntPtr> l = new List<IntPtr>();
        EnumWindows(delegate(IntPtr h, IntPtr p) { l.Add(h); return true; }, IntPtr.Zero);
        return l;
    }

    public static string Klasse(IntPtr h)
    {
        StringBuilder s = new StringBuilder(256);
        GetClassName(h, s, s.Capacity);
        return s.ToString();
    }

    public static string Titel(IntPtr h)
    {
        StringBuilder s = new StringBuilder(512);
        GetWindowText(h, s, s.Capacity);
        return s.ToString();
    }

    public static uint Prozess(IntPtr h)
    {
        uint pid = 0;
        GetWindowThreadProcessId(h, out pid);
        return pid;
    }
}
'@

if (-not ([System.Management.Automation.PSTypeName]'Leisten').Type) {
    Add-Type -TypeDefinition $quelle -Language CSharp
}

# MFC-Andockleisten: AFX_IDW_DOCKBAR_TOP..BOTTOM, afxres.h.
$Seiten = @{
    0xE81B = 'oben'
    0xE81C = 'links'
    0xE81D = 'rechts'
    0xE81E = 'unten'
}

# --- 1. Die Hauptfenster finden ---------------------------------------------

$prozesse = @{}
foreach ($p in (Get-Process -Name 'Eudora' -ErrorAction SilentlyContinue)) {
    $pfad = ''
    try { $pfad = $p.MainModule.FileName } catch { $pfad = '(Pfad nicht lesbar)' }
    if ($Pfadfilter -ne '' -and -not $pfad.StartsWith($Pfadfilter, [System.StringComparison]::OrdinalIgnoreCase)) {
        continue
    }
    $prozesse[[uint32]$p.Id] = $pfad
}

if ($prozesse.Count -eq 0) {
    if ($Pfadfilter -ne '') {
        Write-Host ('Kein Eudora-Prozess unter ' + $Pfadfilter + ' gefunden.')
    } else {
        Write-Host 'Kein Eudora-Prozess gefunden.'
    }
    exit 1
}

$rahmen = @()
foreach ($h in [Leisten]::OberFenster()) {
    $pid2 = [Leisten]::Prozess($h)
    if (-not $prozesse.ContainsKey($pid2)) { continue }
    # Gemessen am 08.09.2026: die Fensterklasse heisst EudoraMainWindow
    # (gesetzt ueber AfxRegisterClass; QCWorkbook ist nur der C++-Klassenname).
    # Beide Namen werden akzeptiert, damit das Skript einen kuenftigen
    # Wechsel nicht stillschweigend als "kein Fenster" meldet.
    $klasse = [Leisten]::Klasse($h)
    if ($klasse -ne 'EudoraMainWindow' -and $klasse -ne 'QCWorkbook') { continue }
    $rahmen += ,@($h, $pid2)
}

if ($rahmen.Count -eq 0) {
    Write-Host 'Prozess laeuft, aber kein Hauptfenster der Klasse EudoraMainWindow gefunden.'
    Write-Host 'Das ist selbst ein Messwert: Fenster weg, Prozess da (siehe Befund E-45).'
    exit 2
}

# --- 2. Je Rahmen die Leisten messen ----------------------------------------

foreach ($eintrag in $rahmen) {
    $hRahmen = $eintrag[0]
    $pidRahmen = $eintrag[1]

    $r = New-Object Leisten+RECT
    [void][Leisten]::GetWindowRect($hRahmen, [ref] $r)

    Write-Host ''
    Write-Host ('Hauptfenster  ' + $hRahmen + '   Prozess ' + $pidRahmen)
    Write-Host ('Programm      ' + $prozesse[[uint32]$pidRahmen])
    Write-Host ('Titel         ' + [Leisten]::Titel($hRahmen))
    Write-Host ('Rahmen        ' + ($r.right - $r.left) + ' x ' + ($r.bottom - $r.top) +
                ' bei ' + $r.left + ',' + $r.top)
    Write-Host ''

    $zeilen = @()
    foreach ($hKind in [Leisten]::Kinder($hRahmen)) {
        $id = [Leisten]::GetWindowLong($hKind, [Leisten]::GWL_ID)
        if ($Kennungen -notcontains $id) { continue }

        $rk = New-Object Leisten+RECT
        [void][Leisten]::GetWindowRect($hKind, [ref] $rk)

        $hEltern = [Leisten]::GetParent($hKind)
        $idEltern = [Leisten]::GetWindowLong($hEltern, [Leisten]::GWL_ID)
        $seite = '(nicht angedockt)'
        if ($Seiten.ContainsKey($idEltern)) { $seite = $Seiten[$idEltern] }
        elseif ($hEltern -eq $hRahmen) { $seite = '(direkt am Rahmen)' }
        else { $seite = ('(Eltern-ID 0x' + $idEltern.ToString('X') + ')') }

        $zeilen += New-Object PSObject -Property ([ordered]@{
            Kennung   = $id
            Klasse    = [Leisten]::Klasse($hKind)
            Andockung = $seite
            Sichtbar  = [Leisten]::IsWindowVisible($hKind)
            B         = $rk.right - $rk.left
            H         = $rk.bottom - $rk.top
            X         = $rk.left
            Y         = $rk.top
        })
    }

    if ($zeilen.Count -eq 0) {
        Write-Host 'Keine Leiste mit einer der gesuchten Kennungen gefunden:'
        Write-Host ('  ' + ($Kennungen -join ', '))
    } else {
        $zeilen | Sort-Object Kennung | Format-Table -AutoSize | Out-String -Width 160 | Write-Host
    }

    # --- 3. Das Urteil zu A-2 ausdruecklich hinschreiben --------------------
    $status = $zeilen | Where-Object { $_.Kennung -eq 320 }
    if ($null -eq $status) {
        Write-Host 'A-2: KEIN URTEIL - Leiste 320 (Aufgabenstatus/Aufgabenfehler) nicht gefunden.'
    } elseif ($status.Andockung -eq 'unten' -and $status.Sichtbar) {
        Write-Host ('A-2 ERFUELLT: Leiste 320 ist unten angedockt und sichtbar, ' +
                    $status.B + ' x ' + $status.H + '.')
    } else {
        Write-Host ('A-2 NICHT ERFUELLT: Leiste 320 ist ' + $status.Andockung +
                    ', Sichtbar=' + $status.Sichtbar + ', ' + $status.B + ' x ' + $status.H + '.')
    }
}
