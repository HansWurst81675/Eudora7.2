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
    [int[]] $Kennungen = @(316, 318, 319, 320),
    # Wohin ein Abbild des Fensters geschrieben wird (PNG). Leer = keins.
    # Gebraucht fuer A-3: der Registerkartenstreifen ist kein Fenster, er wird
    # gemalt - ob dort Karten stehen, sieht man nur am Bild.
    [string] $Abbild = ''
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

    [DllImport("user32.dll")] public static extern bool GetClientRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] public static extern bool ScreenToClient(IntPtr h, ref POINT p);
    [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern IntPtr FindWindowEx(IntPtr parent, IntPtr after, string cls, string title);
    // Laesst das Fenster sich SELBST in einen Geraetekontext zeichnen. Anders
    // als CopyFromScreen nimmt das keine fremden Fenster mit, die davor
    // liegen - am 09.09.2026 hatte ein Dialog eines anderen Programms die
    // Messung unbrauchbar gemacht.
    [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint flags);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT { public int left, top, right, bottom; }

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT { public int x, y; }

    // Der MDI-Bereich ist ein direktes Kind des Rahmens mit der Klasse
    // MDIClient. Eudora unterklasst ihn (mainfrm.cpp:1317), die Fensterklasse
    // bleibt aber MDIClient.
    public static IntPtr MDIBereich(IntPtr rahmen)
    {
        return FindWindowEx(rahmen, IntPtr.Zero, "MDIClient", null);
    }

    // Die offenen Fenster sind die direkten Kinder des MDI-Bereichs.
    public static List<string> MDIKinder(IntPtr mdi)
    {
        List<string> r = new List<string>();
        IntPtr h = IntPtr.Zero;
        while ((h = FindWindowEx(mdi, h, null, null)) != IntPtr.Zero)
        {
            StringBuilder c = new StringBuilder(256); GetClassName(h, c, 256);
            StringBuilder t = new StringBuilder(512); GetWindowText(h, t, 512);
            if (!IsWindowVisible(h)) continue;
            r.Add(t.ToString() + "   [" + c.ToString() + "]");
        }
        return r;
    }

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

    # --- 3. Der Streifen fuer die offenen Fenster (Anforderung A-3) ---------
    #
    # Der Streifen ist KEIN Fenster - er wird auf den Rahmen gemalt
    # (SECWorkbook::OnPaint). Messbar ist er trotzdem: ist der
    # Registerkartenbetrieb an, reserviert SetWorkbookMode einen Rand, und der
    # MDI-Bereich endet entsprechend hoeher als der Rahmen. Die Differenz IST
    # der Streifen.
    $hMDI = [Leisten]::MDIBereich($hRahmen)
    if ($hMDI -eq [IntPtr]::Zero) {
        Write-Host 'A-3: KEIN URTEIL - kein MDIClient-Fenster gefunden.'
    } else {
        $rc = New-Object Leisten+RECT   # Rahmen, Client
        $rm = New-Object Leisten+RECT   # MDI-Bereich
        [void][Leisten]::GetClientRect($hRahmen, [ref] $rc)
        [void][Leisten]::GetWindowRect($hMDI, [ref] $rm)
        $pt = New-Object Leisten+POINT
        $pt.x = $rm.left; $pt.y = $rm.bottom
        [void][Leisten]::ScreenToClient($hRahmen, [ref] $pt)
        $streifen = $rc.bottom - $pt.y

        Write-Host ('Rahmen-Client   Hoehe ' + ($rc.bottom - $rc.top))
        Write-Host ('MDI-Bereich     Unterkante bei ' + $pt.y + ' (im Rahmen-Client)')
        Write-Host ('Streifen        ' + $streifen + ' Pixel hoch, ' +
                    ($rc.right - $rc.left) + ' breit')

        # Zaehlen, wieviele MDI-Kindfenster es gibt - so viele Karten muessen
        # es sein. Verglichen wird gegen das, was das Menue "Window" listet.
        $kinder = [Leisten]::MDIKinder($hMDI)
        Write-Host ('Offene Fenster  ' + $kinder.Count)
        foreach ($k in $kinder) { Write-Host ('                  ' + $k) }

        if ($streifen -ge 20) {
            Write-Host ('A-3 STREIFEN DA: ' + $streifen + ' Pixel unter dem MDI-Bereich reserviert.')
            Write-Host '     Ob dort auch Karten GEZEICHNET sind, sagt nur ein Abbild -'
            Write-Host '     dafuer ist -Abbild da.'
        } else {
            Write-Host ('A-3 NICHT ERFUELLT: nur ' + $streifen + ' Pixel unter dem MDI-Bereich, ' +
                        'der Registerkartenbetrieb laeuft nicht.')
        }
    }

    # --- 4. Abbild des Fensters, wenn verlangt ------------------------------
    if ($Abbild -ne '') {
        Add-Type -AssemblyName System.Drawing
        $rw = New-Object Leisten+RECT
        [void][Leisten]::GetWindowRect($hRahmen, [ref] $rw)
        $b = New-Object System.Drawing.Bitmap(($rw.right - $rw.left), ($rw.bottom - $rw.top))
        $g = [System.Drawing.Graphics]::FromImage($b)
        $hdc = $g.GetHdc()
        # 2 = PW_RENDERFULLCONTENT, noetig fuer Fenster mit eigenem Zeichencode.
        $ok = [Leisten]::PrintWindow($hRahmen, $hdc, 2)
        $g.ReleaseHdc($hdc)
        if (-not $ok) { $g.CopyFromScreen($rw.left, $rw.top, 0, 0, $b.Size) }
        $g.Dispose()
        Write-Host ('Abbild-Weg      ' + $(if ($ok) { 'PrintWindow (fremde Fenster stoeren nicht)' } else { 'Bildschirmabzug - PrintWindow hat versagt' }))
        $b.Save($Abbild, [System.Drawing.Imaging.ImageFormat]::Png)
        $b.Dispose()
        Write-Host ('Abbild          ' + $Abbild)
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
