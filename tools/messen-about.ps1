# messen-about.ps1 - Befund E-216: Help -> About. Ueberlappen sich Knoepfe,
# ist der Knopf "Latest Release" da, und hat die Zeile "Mail folder from"
# Platz fuer mehr als eine Zeile?
#
# Gregor am 03.11.2026 (Bild an 7.2.1.130): "Copy i" halb verdeckt von
# "Visit Web Site", die Herkunftszeile abgeschnitten, und: "was fehlt, ist
# unser github repo".
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript bzw. als messen= im
# Pruefstandsfall E-216p, Pruefstand C:\Temp\EABOUT (Kopie von C:\Temp\E128,
# neuer Bau hinein); Gegenprobe C:\Temp\EABOUT-alt (Kopie von
# C:\Temp\E128-alt, Bau 7.2.1.131 ohne die Behebung). Nur Botschaften an
# gemessene Fensterhandles, kein Tastendruck.
#
# Ablauf:
#   (1) Hauptfenster des Prozesses aus dem Pfad; WM_COMMAND ID_APP_ABOUT
#       (0xE140, MFC afxres.h) an das Hauptfenster.
#   (2) Das About-Fenster ist das #32770 des Prozesses, das ein Kind mit
#       der Kennung IDC_CREDITS (1390) hat. Alle sichtbaren Kinder der
#       Klasse Button: Kennung, Text, Rechteck (GetWindowRect). Zwei
#       Rechtecke, die sich schneiden -> ueberlappt=1. Ein Knopf, der aus
#       dem Clientbereich ragt, steht in der Zeile ABOUT RAND.
#   (3) github=1, wenn ein sichtbarer Knopf mit der Kennung
#       IDC_ABOUT_LATEST_RELEASE (aus resource.h dieses Baums) den Text
#       "Latest Release" traegt. Der Knopf wird NICHT gedrueckt - das
#       oeffnete den Browser auf Gregors Bildschirm.
#   (4) Pfadzeilen (PRUEFER-91 K1/K3): je Zeile Data, Application, INI,
#       Default INI, Log, Mail folder from Breite und Hoehe, die Zeilenhoehe
#       ihrer Schrift (WM_GETFONT; CenterControl setzt ANSI_VAR_FONT, ein
#       Systemobjekt - der Griff gilt auch in diesem Prozess) und die noetige
#       Hoehe aus DrawText mit DT_CALCRECT | DT_WORDBREAK in ihrer Breite.
#       passt=1 nur, wenn JEDE Zeile ihren Text fasst und die Dialogbreite
#       (Client minus 2 x 7) hat. herkunft-zeilen und log-zeilen: Hoehe
#       durch Zeilenhoehe, also wie viele Zeilen Platz haben. Die Texte
#       werden nicht ausgegeben (Pfade, Herkunft).
#   (5) Schliessen mit BM_CLICK an den Knopf IDOK (Close), dann lebt:
#       Prozess und Hauptfenster da, kein offenes Meldungsfenster.
#
# Ausgabe:
#   ABOUT KNOPF <id> [<text>] l,o,r,u
#   ABOUT RAND ausserhalb=<n> client=<b>x<h>
#   ABOUT ZEILE <kennung> laenge= breite= soll= hoehe= zeile= platz= noetig= passt=
#   ABOUT ERGEBNIS knoepfe=<n> ueberlappt=<0|1> github=<0|1> herkunft-zeilen=<n>
#                  log-zeilen=<n> passt=<0|1> rand=<n> lebt=<0|1>
# Erwartet am Bau mit der Behebung:
#   knoepfe=5 ueberlappt=0 github=1 herkunft-zeilen=2 log-zeilen=2 passt=1 rand=0 lebt=1
# Am Bau 7.2.1.131 ohne Behebung (Gegenprobe):
#   knoepfe=4 ueberlappt=1 github=0 herkunft-zeilen=1 log-zeilen=1 passt=0 rand=0 lebt=1
#   (passt=0 schon, weil die Zeilen 420 statt 482 Pixel breit sind; dass
#   der Text von "Log:" nicht passt, zeigt erst ein Pruefstand mit langem
#   Pfad und LogLevel ohne 32768, siehe Fall E-216l)
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+$') { Write-Host "ABOUT ABGEWIESEN: $voll liegt nicht direkt unter C:\Temp"; exit 2 }

if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $voll 'Mailverzeichnis\Eudora.ini'))) { Write-Host "ABOUT FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    Write-Host "ABOUT vorbereitet: $voll"
    exit 0
}

# Kennungen aus resource.h dieses Baums (nicht von Hand).
$resH = Join-Path (Split-Path -Parent $PSScriptRoot) 'Eudora71\Eudora\resource.h'
$resText = [IO.File]::ReadAllText($resH)
function Kennung([string] $name) {
    $m = [regex]::Match($resText, '(?m)^#define\s+' + $name + '\s+(0x[0-9A-Fa-f]+|\d+)')
    if (-not $m.Success) { return -1 }
    $v = $m.Groups[1].Value
    if ($v -like '0x*') { return [Convert]::ToInt32($v.Substring(2), 16) }
    return [int]$v
}
# ID_APP_ABOUT steht nicht in resource.h, sondern in MFC (afxres.h: 0xE140).
$ID_APP_ABOUT = 0xE140
$ID_CREDITS   = Kennung 'IDC_CREDITS'
$ID_LATEST    = Kennung 'IDC_ABOUT_LATEST_RELEASE'
$ID_HERKUNFT  = Kennung 'IDC_ABOUT_MAILDIR_FROM'
$ID_LOG       = Kennung 'IDC_ABOUT_LOG_PATH'
$pfadZeilen = @()
foreach ($n in 'IDC_ABOUT_DATA_DIRECTORY', 'IDC_ABOUT_APP_DIRECTORY', 'IDC_ABOUT_INI_PATH',
               'IDC_ABOUT_DEFAULT_INI', 'IDC_ABOUT_LOG_PATH', 'IDC_ABOUT_MAILDIR_FROM') {
    $v = Kennung $n
    if ($v -le 0) { Write-Host "ABOUT FEHLER: $n nicht in resource.h"; exit 1 }
    $pfadZeilen += [pscustomobject]@{ Name = $n; Id = $v }
}
if ($ID_APP_ABOUT -le 0 -or $ID_CREDITS -le 0 -or $ID_LATEST -le 0 -or $ID_HERKUNFT -le 0) {
    Write-Host "ABOUT FEHLER: Kennungen nicht aus resource.h: about=$ID_APP_ABOUT credits=$ID_CREDITS latest=$ID_LATEST herkunft=$ID_HERKUNFT"
    exit 1
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class ABT {
  public delegate bool EP(IntPtr h, IntPtr p);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L, T, R, B; }
  [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)] public struct TEXTMETRIC {
    public int tmHeight, tmAscent, tmDescent, tmInternalLeading, tmExternalLeading, tmAveCharWidth,
      tmMaxCharWidth, tmWeight, tmOverhang, tmDigitizedAspectX, tmDigitizedAspectY;
    public char tmFirstChar, tmLastChar, tmDefaultChar, tmBreakChar;
    public byte tmItalic, tmUnderlined, tmStruckOut, tmPitchAndFamily, tmCharSet; }
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetClassNameW(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowTextW(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool GetClientRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool ScreenToClient(IntPtr h, ref RECT r);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageW(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageW(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr GetDC(IntPtr h);
  [DllImport("user32.dll")] public static extern int ReleaseDC(IntPtr h, IntPtr dc);
  [DllImport("gdi32.dll")] public static extern IntPtr SelectObject(IntPtr dc, IntPtr o);
  [DllImport("gdi32.dll")] public static extern IntPtr GetStockObject(int i);
  [DllImport("gdi32.dll", CharSet=CharSet.Unicode)] public static extern bool GetTextMetricsW(IntPtr dc, out TEXTMETRIC tm);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int DrawTextW(IntPtr dc, string s, int n, ref RECT r, uint f);
  // Wie in tools\messen-hilfe.ps1: Clientkoordinaten eines Kindes im Dialog.
  public static RECT ImDialog(IntPtr dlg, IntPtr kind) {
    RECT r; GetWindowRect(kind, out r);
    RECT a = new RECT(); a.L = r.L; a.T = r.T; ScreenToClient(dlg, ref a);
    RECT b = new RECT(); b.L = r.R; b.T = r.B; ScreenToClient(dlg, ref b);
    RECT e = new RECT(); e.L = a.L; e.T = a.T; e.R = b.L; e.B = b.T; return e;
  }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][ABT]::GetClassNameW($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 4096; [void][ABT]::GetWindowTextW($h,$s,4096); $s.ToString() }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [ABT+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][ABT]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function Oberste($pids) {
    $r = New-Object System.Collections.ArrayList
    $cb = [ABT+EP]{ param($h,$p)
        $o = 0; [void][ABT]::GetWindowThreadProcessId($h,[ref]$o)
        if ($pids -contains [int]$o -and [ABT]::IsWindowVisible($h)) { [void]$r.Add($h) }
        return $true }
    [void][ABT]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Dialoge($pp) { return @(Oberste @([int]$pp) | Where-Object { (Kl $_) -eq '#32770' }) }
function IstAbout($h) { return [bool](Kinder $h | Where-Object { [ABT]::GetDlgCtrlID($_) -eq $ID_CREDITS }) }

# --- (1) Prozess, Hauptfenster, About oeffnen ------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "ABOUT FEHLER: keine Eudora aus $voll"; exit 1 }
$pp = $proz[0].Id
$haupt = Oberste @([int]$pp) | Where-Object { (Kl $_) -eq 'EudoraMainWindow' } | Select-Object -First 1
if (-not $haupt) { Write-Host 'ABOUT FEHLER: kein Hauptfenster'; exit 1 }
Write-Host "ABOUT Prozess $pp $($proz[0].Path) Fassung $($proz[0].MainModule.FileVersionInfo.FileVersion) Hauptfenster $haupt"
Start-Sleep -Milliseconds 1500

$vorher = @(Dialoge $pp)
foreach ($d in $vorher) { Write-Host ("ABOUT VORAB-DIALOG [{0}] about={1}" -f (Tx $d), [int](IstAbout $d)) }

[void][ABT]::PostMessageW($haupt, 0x0111, [IntPtr]$ID_APP_ABOUT, [IntPtr]::Zero)   # WM_COMMAND
$about = $null
for ($i = 0; $i -lt 50 -and -not $about; $i++) {
    Start-Sleep -Milliseconds 100
    $about = Dialoge $pp | Where-Object { IstAbout $_ } | Select-Object -First 1
}
$knoepfe = 0; $ueber = 0; $github = 0; $zeilen = 0; $logZeilen = 0; $passtAlle = 0; $rand = -1; $lebt = 0
if (-not $about) {
    Write-Host 'ABOUT FEHLER: kein About-Fenster innerhalb von 5 s'
} else {
    Start-Sleep -Milliseconds 500
    $cr = New-Object ABT+RECT
    [void][ABT]::GetClientRect($about, [ref]$cr)
    # --- (2) Knoepfe -------------------------------------------------------
    $liste = @()
    $okKnopf = $null
    foreach ($c in (Kinder $about)) {
        if ((Kl $c) -ne 'Button' -or -not [ABT]::IsWindowVisible($c)) { continue }
        $id = [ABT]::GetDlgCtrlID($c)
        $r = [ABT]::ImDialog($about, $c)
        $t = (Tx $c) -replace '&',''
        $liste += [pscustomobject]@{ Id = $id; Text = $t; L = $r.L; T = $r.T; R = $r.R; B = $r.B }
        if ($id -eq 1) { $okKnopf = $c }
        if ($id -eq $ID_LATEST -and $t -eq 'Latest Release') { $github = 1 }
        Write-Host ("ABOUT KNOPF {0} [{1}] {2},{3},{4},{5}" -f $id, $t, $r.L, $r.T, $r.R, $r.B)
    }
    $knoepfe = $liste.Count
    for ($i = 0; $i -lt $liste.Count; $i++) {
        for ($j = $i + 1; $j -lt $liste.Count; $j++) {
            $a = $liste[$i]; $b = $liste[$j]
            if ($a.L -lt $b.R -and $b.L -lt $a.R -and $a.T -lt $b.B -and $b.T -lt $a.B) {
                $ueber = 1
                Write-Host ("ABOUT UEBERLAPPT [{0}] und [{1}]" -f $a.Text, $b.Text)
            }
        }
    }
    $raus = @($liste | Where-Object { $_.L -lt 0 -or $_.T -lt 0 -or $_.R -gt $cr.R -or $_.B -gt $cr.B })
    Write-Host ("ABOUT RAND ausserhalb={0} client={1}x{2}" -f $raus.Count, $cr.R, $cr.B)
    $rand = $raus.Count

    # --- (4) Pfadzeilen ----------------------------------------------------
    # Je Zeile: Breite, Hoehe, Zeilenhoehe ihrer Schrift (WM_GETFONT,
    # GetTextMetrics) und die noetige Hoehe aus DrawText mit DT_CALCRECT |
    # DT_WORDBREAK in ihrer Breite (PRUEFER-91 K1/K3). Passt eine Zeile, wenn
    # der Text in ihr Rechteck passt UND sie die Dialogbreite hat (Client
    # minus 2 x 7 Pixel, wie OnInitDialog sie setzt). Den Text NICHT
    # ausgeben: er nennt Pfade und die Herkunft des Mailverzeichnisses, und
    # die Ausgabe landet in TESTLAEUFE.md (Gregor 03.11.2026: keine internen
    # Angaben ins Repo).
    $sollBreite = $cr.R - 2 * 7
    $alleGut = $true
    foreach ($z in $pfadZeilen) {
        $hz = Kinder $about | Where-Object { [ABT]::GetDlgCtrlID($_) -eq $z.Id } | Select-Object -First 1
        if (-not $hz) { Write-Host ("ABOUT ZEILE {0} nicht gefunden" -f $z.Name); $alleGut = $false; continue }
        $r = [ABT]::ImDialog($about, $hz)
        $hoehe = $r.B - $r.T; $breite = $r.R - $r.L
        $text = Tx $hz
        $font = [ABT]::SendMessageW($hz, 0x0031, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_GETFONT
        if ($font -eq [IntPtr]::Zero) { $font = [ABT]::GetStockObject(17) }       # DEFAULT_GUI_FONT
        $dc = [ABT]::GetDC([IntPtr]::Zero)
        try {
            $alt = [ABT]::SelectObject($dc, $font)
            $tm = New-Object ABT+TEXTMETRIC
            [void][ABT]::GetTextMetricsW($dc, [ref]$tm)
            $zeile = $tm.tmHeight
            $calc = New-Object ABT+RECT
            $calc.R = $breite
            # DT_CENTER 1 | DT_WORDBREAK 0x10 | DT_CALCRECT 0x400 | DT_NOPREFIX 0x800
            [void][ABT]::DrawTextW($dc, $text, -1, [ref]$calc, 0x0C11)
            $noetig = $calc.B - $calc.T
            [void][ABT]::SelectObject($dc, $alt)
        } finally { [void][ABT]::ReleaseDC([IntPtr]::Zero, $dc) }
        $platz = 0
        if ($zeile -gt 0) { $platz = [int][Math]::Floor($hoehe / $zeile) }
        $gut = ($noetig -le $hoehe) -and ($breite -ge $sollBreite)
        if (-not $gut) { $alleGut = $false }
        if ($z.Id -eq $ID_HERKUNFT) { $zeilen = $platz }
        if ($z.Id -eq $ID_LOG) { $logZeilen = $platz }
        Write-Host ("ABOUT ZEILE {0} laenge={1} breite={2} soll={3} hoehe={4} zeile={5} platz={6} noetig={7} passt={8}" -f `
            $z.Name, $text.Length, $breite, $sollBreite, $hoehe, $zeile, $platz, $noetig, [int]$gut)
    }
    $passtAlle = [int]$alleGut

    # --- (5) Schliessen ----------------------------------------------------
    if ($okKnopf) { [void][ABT]::PostMessageW($okKnopf, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
    else          { [void][ABT]::PostMessageW($about, 0x0111, [IntPtr]2, [IntPtr]::Zero) }          # IDCANCEL
    for ($i = 0; $i -lt 20 -and [ABT]::IsWindow($about) -and [ABT]::IsWindowVisible($about); $i++) { Start-Sleep -Milliseconds 150 }
    if ([ABT]::IsWindow($about) -and [ABT]::IsWindowVisible($about)) { Write-Host 'ABOUT FEHLER: About-Fenster ging mit Close nicht zu' }
}

Start-Sleep -Milliseconds 500
$offen = @(Dialoge $pp)
foreach ($d in $offen) {
    Write-Host ("ABOUT NOCH-OFFEN [{0}]" -f (Tx $d))
    [void][ABT]::PostMessageW($d, 0x0111, [IntPtr]2, [IntPtr]::Zero)
}
$lebt = [int]([bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) -and [ABT]::IsWindow($haupt) -and $offen.Count -eq 0)

Write-Host ("ABOUT ERGEBNIS knoepfe={0} ueberlappt={1} github={2} herkunft-zeilen={3} log-zeilen={4} passt={5} rand={6} lebt={7}" -f `
    $knoepfe, $ueber, $github, $zeilen, $logZeilen, $passtAlle, $rand, $lebt)
