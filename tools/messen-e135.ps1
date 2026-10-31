# messen-e135.ps1 - misst die Hoehe der Vervollstaendigungsbox ueber mehrere
# Cursor-Schritte (Befund E-135).
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, bekommt von dort
# -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem Pfad.
#
#   powershell -ExecutionPolicy Bypass -File tools\testlauf.ps1 `
#       -Verzeichnis "C:\Temp\E135-box" -Freigabe "<Gregors Satz von heute>" `
#       -MessenSkript tools\messen-e135.ps1 -Sekunden 60
#
# Das Mailverzeichnis des Pruefstands muss mehrere Kurznamen mit gleichem
# Anfang enthalten (NNdbase.txt), sonst erscheint keine Auswahlbox.
#
# Ausgabe: je eine Zeile "E135 Schritt <n> Hoehe <px> Breite <px>". Schrumpft
# die Hoehe von Schritt zu Schritt, ist der Fehler da.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [string] $Tippen   = 'ha',
    [int]    $Schritte = 5,
    # PRUEFER-44: so viele Entf-Taste-Schritte nach den Cursor-Schritten
    [int]    $Entfernen = 3
)
$ErrorActionPreference = 'Stop'

# testlauf.ps1 reicht nur -Pfadfilter durch. Damit sich Tippfolge und Zahl der
# Entf-Schritte trotzdem von aussen setzen lassen, gelten zusaetzlich die
# Umgebungsvariablen E135_TIPPEN und E135_ENTFERNEN.
if ($env:E135_TIPPEN)    { $Tippen    = $env:E135_TIPPEN }
if ($env:E135_ENTFERNEN) { $Entfernen = [int] $env:E135_ENTFERNEN }

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E135 {
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern bool GetClientRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern IntPtr GetParent(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetWindowLongA(IntPtr h, int i);
  [DllImport("user32.dll")] public static extern bool ClientToScreen(IntPtr h, ref P p);
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
  [StructLayout(LayoutKind.Sequential)] public struct P { public int X, Y; }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E135]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E135]::GetWindowTextA($h,$s,512); $s.ToString() }
function Rechteck($h) { $r = New-Object E135+R; [void][E135]::GetWindowRect($h,[ref]$r); return $r }
function Innen($h)    { $r = New-Object E135+R; [void][E135]::GetClientRect($h,[ref]$r); return $r }

function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E135+EP]{ param($h,$p)
        $o = 0; [void][E135]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Id=[E135]::GetDlgCtrlID($h); Klasse=(Kl $h); Text=(Tx $h); Vis=[E135]::IsWindowVisible($h)})
            $cc = [E135+EP]{ param($k,$q)
                [void]$r.Add([pscustomobject]@{H=$k; Id=[E135]::GetDlgCtrlID($k); Klasse=(Kl $k); Text=(Tx $k); Vis=[E135]::IsWindowVisible($k)})
                return $true }
            [void][E135]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
        }
        return $true }
    [void][E135]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}

# --- Prozess aus dem Pruefstand finden ------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E135 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
Write-Host "E135 Prozess $pp aus $Pfadfilter"

$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E135 FEHLER: kein Hauptfenster'; exit 1 }

# --- Verfassen-Fenster oeffnen --------------------------------------------
$vorher = (AlleFenster $pp | Where-Object { $_.Vis }).H
[void][E135]::PostMessageA($haupt.H, 0x0111, [IntPtr]32797, [IntPtr]::Zero)   # ID_MESSAGE_NEWMESSAGE
Start-Sleep -Seconds 4

# To:-Feld: das erste sichtbare Eingabefeld im neuen Fenster
$felder = AlleFenster $pp | Where-Object {
    $_.Vis -and ($_.Klasse -match 'RICHEDIT|Edit') -and ($vorher -notcontains $_.H) }
if (-not $felder) { Write-Host 'E135 FEHLER: kein Eingabefeld im Verfassen-Fenster'; exit 1 }
$to = $felder | Sort-Object { (Rechteck $_.H).T } | Select-Object -First 1
Write-Host ("E135 To-Feld {0} [{1}] id={2}" -f $to.H, $to.Klasse, $to.Id)

# --- tippen ----------------------------------------------------------------
foreach ($ch in $Tippen.ToCharArray()) {
    [void][E135]::PostMessageA($to.H, 0x0102, [IntPtr][int]$ch, [IntPtr]1)    # WM_CHAR
    Start-Sleep -Milliseconds 250
}
Start-Sleep -Milliseconds 1800     # Vorgabe ist 500 ms, mit Luft

# --- Box finden -------------------------------------------------------------
# Die Box ist der Dialog, der eine SysListView32 mit Eintraegen enthaelt.
# Nach Klasse allein zu suchen trifft den Kontenassistenten (gemessen
# 21.10.2026: 453x341, unveraendert ueber alle Schritte - und nicht die Box).
$kandidaten = AlleFenster $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' }
Write-Host ("E135 {0} sichtbare Dialoge" -f $kandidaten.Count)
$box = $null
$boxliste = $null
foreach ($k in $kandidaten) {
    $kinder = New-Object System.Collections.ArrayList
    $cc = [E135+EP]{ param($x,$q) [void]$kinder.Add($x); return $true }
    [void][E135]::EnumChildWindows($k.H,$cc,[IntPtr]::Zero)
    $liste = $kinder | Where-Object { (Kl $_) -eq 'SysListView32' } | Select-Object -First 1
    $r = Rechteck $k.H
    Write-Host ("E135   Dialog {0} [{1}] {2}x{3} Kinder {4} Liste {5}" -f `
        $k.H, $k.Text, ($r.Ri-$r.L), ($r.B-$r.T), $kinder.Count, $(if($liste){"ja"}else{"nein"}))
    if ($liste -and -not $box) { $box = $k; $boxliste = $liste }
}
if (-not $box) {
    Write-Host 'E135 KEINE BOX - erscheint die Auswahlbox? NNdbase.txt mit mehreren'
    Write-Host 'E135 Kurznamen gleichen Anfangs gefuellt? Auto-completion eingeschaltet?'
    exit 1
}
Write-Host ("E135 Box {0}  Liste {1}" -f $box.H, $boxliste)

# --- messen, Schritt fuer Schritt ------------------------------------------
# PRUEFER-44: zusaetzlich zur Groesse werden LINKS/OBEN auf dem Bildschirm und
# die Zahl der Listeneintraege ausgegeben. Die Position beantwortet, ob das
# fehlende ScreenToClient in InitList() wirkt; die Zahl der Eintraege
# beantwortet, ob die Box nach dem Entfernen eines Eintrags zu gross bleibt.
function Anzahl($h) { return [int][E135]::SendMessageA($h, 0x1004, [IntPtr]::Zero, [IntPtr]::Zero) }
# E-165: dazu die LISTE selbst - Aussen-/Innenmass, wie viele Zeilen ganz
# hineinpassen (LVM_GETCOUNTPERPAGE; 0 heisst: nicht einmal eine) und ob sie
# Bildlaufleisten traegt (WS_HSCROLL 0x00100000, WS_VSCROLL 0x00200000).
function ListenZeile($nr, $lh) {
    $a = Rechteck $lh; $k = Innen $lh
    $st = [E135]::GetWindowLongA($lh, -16)
    $pro = [int][E135]::SendMessageA($lh, 0x1028, [IntPtr]::Zero, [IntPtr]::Zero)
    Write-Host ("E135 {0,-10} Liste aussen {1}x{2} innen {3}x{4} proSeite {5} hscroll {6} vscroll {7}" -f `
        $nr, ($a.Ri-$a.L), ($a.B-$a.T), ($k.Ri-$k.L), ($k.B-$k.T), $pro, [int](($st -band 0x00100000) -ne 0), [int](($st -band 0x00200000) -ne 0))
}
function Zeile($nr, $h, $lh) {
    $a = Rechteck $h
    $k = Innen    $h
    Write-Host ("E135 {0,-10} Hoehe {1,4} Breite {2,4} (innen {3,4} x {4,4})  links {5,5} oben {6,5}  Eintraege {7}" -f `
        $nr, ($a.B-$a.T), ($a.Ri-$a.L), ($k.B-$k.T), ($k.Ri-$k.L), $a.L, $a.T, (Anzahl $lh))
}

for ($i = 0; $i -le $Schritte; $i++) {
    Zeile "Schritt $i" $box.H $boxliste
    ListenZeile "Schritt $i" $boxliste
    if ($i -lt $Schritte) {
        [void][E135]::PostMessageA($to.H, 0x0100, [IntPtr]0x28, [IntPtr]1)    # WM_KEYDOWN VK_DOWN
        [void][E135]::PostMessageA($to.H, 0x0101, [IntPtr]0x28, [IntPtr]1)    # WM_KEYUP
        Start-Sleep -Milliseconds 600
    }
}

# --- Wo liegt der Nullpunkt des Elternfensters? ----------------------------
# PRUEFER-44: InitList() (AutoCompleteSearcher.cpp:618) gibt MoveWindow die
# Koordinaten aus GetWindowRect, also BILDSCHIRMkoordinaten, obwohl
# IDD_AUTOCOMP WS_CHILD ist und MoveWindow dort ELTERNkoordinaten erwartet.
# DoACListBox (:516) und ReCalcACListBoxPos (:530) rechnen mit ScreenToClient
# um. Der Unterschied ist genau der Nullpunkt des Elternfensters - ist der
# (0,0), fallen beide Rechnungen zusammen und der Mangel bleibt unsichtbar.
$pt = New-Object E135+P; $pt.X = 0; $pt.Y = 0
$eltern = [E135]::GetParent($box.H)
[void][E135]::ClientToScreen($eltern, [ref]$pt)
Write-Host ("E135 Elternfenster {0} [{1}] Nullpunkt auf dem Bildschirm {2},{3}" -f `
            $eltern, (Kl $eltern), $pt.X, $pt.Y)

# --- Entf: nimmt einen Eintrag weg und ruft ReCalcACListBoxPos -------------
# AutoCompleteSearcher.cpp:1160 OnDeleteKey. Fuer einen Adressbucheintrag
# (Bild 1) fragt die Funktion erst mit WarnYesNoDialog(0, IDS_DELETE_AB_ADDRESS)
# nach - der Dialog wird hier beantwortet, sonst wird nichts entfernt und der
# Schritt misst nichts (gemessen 21.10.2026: ohne Antwort bleibt es bei 5
# Eintraegen). Danach ruft OnDeleteKey ReCalcACListBoxPos; InitList wird auf
# diesem Weg NICHT gerufen, die Hoehe kann also nicht nachgezogen werden.
function AntworteWarnung($pp, $bekannt) {
    $neu = AlleFenster $pp | Where-Object {
        $_.Vis -and $_.Klasse -eq '#32770' -and ($bekannt -notcontains $_.H) }
    foreach ($d in $neu) {
        $kn = New-Object System.Collections.ArrayList
        $cc = [E135+EP]{ param($x,$q) [void]$kn.Add($x); return $true }
        [void][E135]::EnumChildWindows($d.H,$cc,[IntPtr]::Zero)
        foreach ($b in $kn) {
            if ((Kl $b) -eq 'Button') {
                $t = (Tx $b) -replace '&',''
                if ($t -match '^(Yes|Ja|OK)$') {
                    Write-Host ("E135   Dialog [{0}] mit Knopf [{1}] beantwortet" -f $d.Text, $t)
                    [void][E135]::PostMessageA($b, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero)   # BM_CLICK
                    Start-Sleep -Milliseconds 800
                    return $true
                }
            }
        }
    }
    return $false
}

if ($Entfernen) {
    $bekannt = (AlleFenster $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' }).H
    for ($d = 1; $d -le $Entfernen; $d++) {
        [void][E135]::PostMessageA($to.H, 0x0100, [IntPtr]0x2E, [IntPtr]1)    # WM_KEYDOWN VK_DELETE
        [void][E135]::PostMessageA($to.H, 0x0101, [IntPtr]0x2E, [IntPtr]1)    # WM_KEYUP
        Start-Sleep -Milliseconds 900
        if (-not (AntworteWarnung $pp $bekannt)) {
            Write-Host "E135   Entf $d - KEIN neuer Dialog, Taste kam nicht an oder Bild 0"
        }
        Start-Sleep -Milliseconds 700
        Zeile "Entf $d" $box.H $boxliste
    }
}
Write-Host 'E135 fertig'
