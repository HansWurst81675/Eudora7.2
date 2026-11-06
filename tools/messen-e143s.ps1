# messen-e143s.ps1 - Befund E-143, Teil Suchfenster: wie viele Hinweise
# "Transfer to Out mailbox" bringt es, wenn man mehrere EMPFANGENE Treffer
# aus "Find Messages" nach Out uebertraegt?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1,
# Fall E-143s), Pruefstand C:\Temp\E143S (Kopie von C:\Temp\E171). Nur
# Botschaften an gemessene Fensterhandles, kein Tastendruck.
#
# Vor der Behebung (bis a7e05aef) rief CSearchView::OnDynamicCommand je
# Treffer CTocDoc::Xfer auf, und Xfer lehnte jede empfangene Nachricht nach
# Out mit einem eigenen AlertDialog(IDD_XFER_TO_OUT_REFUSED) ab (tocdoc.cpp,
# Logzeile "E-125 Xfer nach Out abgelehnt"): m Treffer, m Hinweise. Nach der
# Behebung zaehlt die Schleife die empfangenen Treffer, ueberspringt sie und
# zeigt den Hinweis EINMAL; Logzeile
#   E-143 Suchfenster nach Out: <n> von <m> Treffern abgelehnt (empfangen), ein Hinweis
#
# Ablauf:
#   -Vorbereiten: Out/In/Trash weg, Testdaten\e143s-suchwort.eml dreimal
#     (Nummer 1..3) roh nach In.mbx; UseIndexedSearch=0 und
#     FindMsgsCriteria1=Anywhere;contains; in [Settings], damit die Suche
#     ohne X1-Index laeuft.
#   Messen: In nach vorn (ID_MAILBOX_IN, baut die TOC), Out zaehlen
#     (ID_MAILBOX_OUT); aus In heraus ID_EDIT_FIND_FINDMSG (32778) - die
#     Postfachansicht oeffnet das Suchfenster auf In. Suchwort per WM_SETTEXT
#     in IDC_CRITERIA_TEXT_EDIT_1 (7645), Suche ueber WM_COMMAND BN_CLICKED
#     IDC_SEARCHWND_BEGIN_BTN (1017) an die Suchansicht. Treffer zaehlen
#     (LVM_GETITEMCOUNT an IDC_SEARCHWND_RESULTS_LIST 8172), alle waehlen
#     (ID_EDIT_SELECT_ALL an die Suchansicht, LVM_GETSELECTEDCOUNT pruefen).
#   Transfer nach Out: die Befehlsnummer vergibt Eudora zur Laufzeit
#     (g_theCommandStack, QC_FIRST_COMMAND_ID..QC_LAST_COMMAND_ID). Sie wird
#     wie in messen-e125.ps1 aus dem Hauptmenue gelesen: Eintrag "Transfer"
#     suchen, WM_INITMENUPOPUP an das Hauptfenster (erst dann fuellt Eudora
#     die Postfacheintraege), im Untermenue den Eintrag "Out" suchen,
#     GetMenuItemID. Diese Nummer geht als WM_COMMAND an die Suchansicht -
#     dort faengt sie ON_COMMAND_EX_RANGE(QC_FIRST..QC_LAST, OnDynamicCommand)
#     ab, genau wie der Klick im Menue Transfer bei aktivem Suchfenster.
#   Danach jeden erscheinenden Dialog des Prozesses zaehlen und mit OK
#     schliessen, bis 8 s lang keiner mehr kommt; Hinweise = Dialoge mit
#     Titel "Transfer to Out mailbox" oder Text "transferred to the Out".
#   eudora.log: Zeilen ab dem Stand vor dem Transfer.
#
# Ausgabe:
#   E143S ERGEBNIS treffer=<m> hinweise=<n> abgelehnt-log=<n|-> e125-zeilen=<n> out-neu=<n> lebt=<0|1>
# Erwartet nach der Behebung (3 Pruefnachrichten):
#   treffer=3 hinweise=1 abgelehnt-log=3 e125-zeilen=0 out-neu=0 lebt=1
# Vor der Behebung: hinweise=3 abgelehnt-log=- e125-zeilen=3.
# Ungetestet bei der Anlage (02.11.2026) - erster Lauf durch den Hauptagenten.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [string] $Suchwort = 'Zebrafink143',
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch ('^' + [regex]::Escape($(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp' })) + '\\[^\\]+')) { Write-Host "E143S ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$repo = Split-Path -Parent $PSScriptRoot
$lat = [Text.Encoding]::GetEncoding(28591)
$ANZAHL = 3

if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E143S FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    $laeuft = Get-Process Eudora -ErrorAction SilentlyContinue |
              Where-Object { $_.Path -and $_.Path.StartsWith($voll, 'OrdinalIgnoreCase') }
    if ($laeuft) { Write-Host "E143S FEHLER: Eudora aus $voll laeuft noch (PID $($laeuft[0].Id))"; exit 1 }
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    # [Settings]: Suche ohne X1-Index, ein Kriterium "Anywhere contains".
    $ini = Join-Path $md 'Eudora.ini'
    $t = $lat.GetString([IO.File]::ReadAllBytes($ini))
    foreach ($kv in @(@('UseIndexedSearch','0'), @('FindMsgsCriteriaCount','1'), @('FindMsgsCriteria1','Anywhere;contains;'))) {
        $k = $kv[0]; $v = $kv[1]
        if ($t -match ('(?m)^' + $k + '=')) { $t = [regex]::Replace($t, ('(?m)^' + $k + '=[^\r\n]*'), ($k + '=' + $v)) }
        else { $t = $t -replace '(?m)^\[Settings\]\r?\n', ("[Settings]`r`n" + $k + '=' + $v + "`r`n") }
    }
    [IO.File]::WriteAllBytes($ini, $lat.GetBytes($t))

    $vorlage = $lat.GetString([IO.File]::ReadAllBytes((Join-Path $repo 'Testdaten\e143s-suchwort.eml')))
    if ($vorlage -notmatch [regex]::Escape($Suchwort)) { Write-Host "E143S FEHLER: Suchwort $Suchwort fehlt in der Pruefnachricht"; exit 1 }
    $mbx = ''
    for ($i = 1; $i -le $ANZAHL; $i++) {
        $mbx += ("From ???@??? Mon Nov 02 10:0{0}:00 2026`r`n" -f $i) + $vorlage.Replace('#N#', [string]$i) + "`r`n"
    }
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), $lat.GetBytes($mbx))
    Write-Host ("E143S vorbereitet: {0} ({1} Nachrichten mit {2} in In.mbx)" -f $md, $ANZAHL, $Suchwort)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E143S {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindowEnabled(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr GetParent(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Ansi, EntryPoint="SendMessageA")] public static extern IntPtr SendText(IntPtr h, uint m, IntPtr w, string l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetMenuItemCount(IntPtr m);
  [DllImport("user32.dll")] public static extern uint GetMenuItemID(IntPtr m, int i);
  [DllImport("user32.dll")] public static extern IntPtr GetSubMenu(IntPtr m, int i);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetMenuStringA(IntPtr m, uint id, StringBuilder s, int n, uint f);
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E143S]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E143S]::GetWindowTextA($h,$s,512); $s.ToString() }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E143S+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E143S]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function Oberste($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E143S+EP]{ param($h,$p)
        $o = 0; [void][E143S]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) { [void]$r.Add($h) }
        return $true }
    [void][E143S]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
function Befehl($h, [int] $id) { [void][E143S]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E143S]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E143S]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E143S]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function NachID($wurzel, [int] $id) {
    return (Kinder $wurzel | Where-Object { [E143S]::GetDlgCtrlID($_) -eq $id } | Select-Object -First 1)
}
function Postfach([int] $befehl, [string] $name) {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt $befehl
        $k = Aktiv $mdi; $lb = Liste $k
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    Write-Host "E143S FEHLER: Postfach $name kam nicht nach vorn"; exit 1
}

# Ein Dialog des Prozesses: Titel, Texte, OK-Knopf. Nur sichtbare #32770.
function DialogLesen($h) {
    $texte = @(); $ok = $null; $knoepfe = @()
    foreach ($c in (Kinder $h)) {
        $k = Kl $c; $t = (Tx $c) -replace '&',''
        if ($k -eq 'Static' -and $t) { $texte += $t }
        if ($k -eq 'Button') { $knoepfe += $t; if ($t -match '^OK$') { $ok = $c } }
    }
    return [pscustomobject]@{ H = $h; Titel = (Tx $h); Text = ($texte -join ' '); Knoepfe = ($knoepfe -join ', '); OK = $ok }
}
function OffeneDialoge($pp) {
    return @(Oberste $pp | Where-Object { [E143S]::IsWindowVisible($_) -and (Kl $_) -eq '#32770' } | ForEach-Object { DialogLesen $_ })
}
# Schliessen und warten, bis das Fenster wirklich weg ist - sonst wird ein
# und derselbe Hinweis zweimal gezaehlt.
function Schliessen($d) {
    if ($d.OK) { [void][E143S]::PostMessageA($d.OK, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }      # BM_CLICK
    else       { [void][E143S]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }            # IDCANCEL
    for ($i = 0; $i -lt 20; $i++) {
        if (-not [E143S]::IsWindow($d.H) -or -not [E143S]::IsWindowVisible($d.H)) { return $true }
        Start-Sleep -Milliseconds 150
    }
    return $false
}
# Startdialoge (Junk-Frage, Tipps ...) wegraeumen, ohne sie zu zaehlen.
function Aufraeumen($pp) {
    foreach ($d in (OffeneDialoge $pp)) {
        Write-Host ("E143S VORAB-DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Titel, $d.Text, $d.Knoepfe)
        [void](Schliessen $d)
    }
}
# Befehlsnummer des Eintrags $Ziel im Menue "Transfer" (wie messen-e125.ps1).
function TransferNach($haupt, [string] $Ziel) {
    $m = [E143S]::GetMenu($haupt)
    for ($i = 0; $i -lt [E143S]::GetMenuItemCount($m); $i++) {
        $s = New-Object Text.StringBuilder 128
        [void][E143S]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
        if (($s.ToString() -replace '&','') -ne 'Transfer') { continue }
        $sub = [E143S]::GetSubMenu($m, $i)
        [void][E143S]::SendMessageA($haupt, 0x0117, $sub, [IntPtr]$i)   # WM_INITMENUPOPUP
        for ($j = 0; $j -lt [E143S]::GetMenuItemCount($sub); $j++) {
            $t = New-Object Text.StringBuilder 128
            [void][E143S]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
            if (($t.ToString() -replace '&','') -eq $Ziel) { return [int][E143S]::GetMenuItemID($sub, $j) }
        }
    }
    return 0
}
function MenueZeigen($haupt) {
    $m = [E143S]::GetMenu($haupt)
    for ($i = 0; $i -lt [E143S]::GetMenuItemCount($m); $i++) {
        $s = New-Object Text.StringBuilder 128
        [void][E143S]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
        $sub = [E143S]::GetSubMenu($m, $i); $teile = @()
        if ($sub -ne [IntPtr]::Zero) {
            [void][E143S]::SendMessageA($haupt, 0x0117, $sub, [IntPtr]$i)
            for ($j = 0; $j -lt [E143S]::GetMenuItemCount($sub); $j++) {
                $t = New-Object Text.StringBuilder 128
                [void][E143S]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
                $teile += ("{0}={1}" -f ($t.ToString() -replace '&',''), [E143S]::GetMenuItemID($sub, $j))
            }
        }
        Write-Host ("E143S MENUE [{0}] {1}" -f ($s.ToString() -replace '&',''), ($teile -join '; '))
    }
}
# eudora.log mit Freigabe lesen - Eudora haelt die Datei offen.
$logPfad = Join-Path $md 'eudora.log'
function LogZeilen() {
    if (-not (Test-Path -LiteralPath $logPfad)) { return @() }
    $fs = [IO.File]::Open($logPfad, 'Open', 'Read', 'ReadWrite')
    try { $b = New-Object byte[] $fs.Length; [void]$fs.Read($b, 0, $b.Length) } finally { $fs.Close() }
    return @($lat.GetString($b) -split "`r?`n")
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($voll, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E143S FEHLER: keine Eudora aus $voll"; exit 1 }
$pp = $proz[0].Id
$haupt = Oberste $pp | Where-Object { (Kl $_) -eq 'EudoraMainWindow' -and [E143S]::IsWindowVisible($_) } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E143S FEHLER: kein Hauptfenster'; exit 1 }
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E143S Prozess $pp Hauptfenster $haupt MDI $mdi"
Aufraeumen $pp

# --- Out vorher, In nach vorn --------------------------------------------
$out, $lbOut = Postfach 32793 'Out'                       # ID_MAILBOX_OUT
$outVorher = Anzahl $lbOut
$in, $lbIn = Postfach 32792 'In'                          # ID_MAILBOX_IN
$nIn = Anzahl $lbIn
Write-Host ("E143S Out vorher {0}, In {1}" -f $outVorher, $nIn)
if ($nIn -lt $ANZAHL) { Write-Host "E143S FEHLER: In hat $nIn statt $ANZAHL Nachrichten - die Vorbereitung hat nicht gegriffen"; exit 1 }
Aufraeumen $pp

# --- Suchfenster ------------------------------------------------------------
Befehl $haupt 32778                                       # ID_EDIT_FIND_FINDMSG, aus In heraus
$such = $null; $knopf = $null
for ($i = 0; $i -lt 20 -and -not $knopf; $i++) {
    Start-Sleep -Milliseconds 500
    $such = Aktiv $mdi
    if ($such -ne $in) { $knopf = NachID $such 1017 }     # IDC_SEARCHWND_BEGIN_BTN
}
if (-not $knopf) { Write-Host ("E143S FEHLER: kein Suchfenster (aktiv {0} [{1}])" -f $such, (Tx $such)); exit 1 }
$ansicht = [E143S]::GetParent($knopf)                     # CSearchView
$feld  = NachID $such 7645                                # IDC_CRITERIA_TEXT_EDIT_1
$liste = NachID $such 8172                                # IDC_SEARCHWND_RESULTS_LIST
Write-Host ("E143S Suchfenster {0} [{1}] Ansicht {2} [{3}] Feld {4} Liste {5} [{6}]" -f `
    $such, (Tx $such), $ansicht, (Kl $ansicht), $feld, $liste, $(if ($liste) { Kl $liste } else { '-' }))
if (-not $feld -or -not $liste) { Write-Host 'E143S FEHLER: Suchfeld oder Ergebnisliste nicht gefunden'; exit 1 }

[void][E143S]::SendText($feld, 0x000C, [IntPtr]::Zero, $Suchwort)   # WM_SETTEXT -> EN_CHANGE
Start-Sleep -Milliseconds 500
Write-Host ("E143S Suchfeld [{0}] Knopf frei={1}" -f (Tx $feld), [int][E143S]::IsWindowEnabled($knopf))
[void][E143S]::PostMessageA($ansicht, 0x0111, [IntPtr]1017, $knopf)  # WM_COMMAND BN_CLICKED
# Suche laeuft im Oberflaechenfaden; der Knopf ist waehrenddessen gesperrt.
$treffer = 0; $gleich = 0
for ($i = 0; $i -lt 60 -and $gleich -lt 4; $i++) {
    Start-Sleep -Milliseconds 500
    $n = [int][E143S]::SendMessageA($liste, 0x1004, [IntPtr]::Zero, [IntPtr]::Zero)   # LVM_GETITEMCOUNT
    if ($n -eq $treffer -and $n -gt 0 -and [E143S]::IsWindowEnabled($knopf)) { $gleich++ } else { $gleich = 0 }
    $treffer = $n
}
Write-Host "E143S Treffer $treffer"
Aufraeumen $pp
if ($treffer -lt 1) { Write-Host "E143S ERGEBNIS treffer=0 hinweise=- abgelehnt-log=- e125-zeilen=- out-neu=- lebt=$([int](Lebt $pp))"; exit 1 }

Befehl $ansicht 57642                                     # ID_EDIT_SELECT_ALL an CSearchView
$gewaehlt = [int][E143S]::SendMessageA($liste, 0x1032, [IntPtr]::Zero, [IntPtr]::Zero)  # LVM_GETSELECTEDCOUNT
Write-Host "E143S gewaehlt $gewaehlt von $treffer"
if ($gewaehlt -ne $treffer) { Write-Host 'E143S FEHLER: nicht alle Treffer gewaehlt'; exit 1 }

# --- Transfer nach Out --------------------------------------------------------
$idOut = TransferNach $haupt 'Out'
Write-Host "E143S Transfer->Out Befehl $idOut"
if (-not $idOut) { MenueZeigen $haupt; Write-Host 'E143S FEHLER: kein Eintrag Out im Menue Transfer'; exit 1 }
$logVorher = (LogZeilen).Count
[void][E143S]::PostMessageA($ansicht, 0x0111, [IntPtr]$idOut, [IntPtr]::Zero)

# Jeden Dialog zaehlen und mit OK schliessen, bis 8 s Ruhe (max. 90 s).
$hinweise = 0; $andere = 0; $ruhe = 0
for ($i = 0; $i -lt 360 -and $ruhe -lt 32 -and (Lebt $pp); $i++) {
    $ds = OffeneDialoge $pp | Where-Object { $_.OK -or $_.Text }
    if (-not $ds) { $ruhe++; Start-Sleep -Milliseconds 250; continue }
    $ruhe = 0
    foreach ($d in $ds) {
        $istHinweis = ($d.Titel -match 'Transfer to Out') -or ($d.Text -match 'transferred to the Out')
        if ($istHinweis) { $hinweise++ } else { $andere++ }
        Write-Host ("E143S DIALOG {0} [{1}] {2} | Knoepfe: {3}" -f $(if ($istHinweis) { "hinweis-$hinweise" } else { 'anderer' }), $d.Titel, $d.Text, $d.Knoepfe)
        if (-not (Schliessen $d)) { Write-Host ("E143S WARNUNG: Dialog {0} ging nicht zu" -f $d.H) }
    }
}
$lebt = [int](Lebt $pp)

# --- Out nachher, Log ---------------------------------------------------------
$outNeu = '-'
if ($lebt) {
    $out2, $lbOut2 = Postfach 32793 'Out'
    $outNeu = (Anzahl $lbOut2) - $outVorher
}
Start-Sleep -Milliseconds 500
$neu = @(LogZeilen | Select-Object -Skip $logVorher)
$e143 = @($neu | Where-Object { $_ -match 'E-143 Suchfenster nach Out: (\d+) von (\d+) Treffern' })
$abgelehnt = '-'
if ($e143) {
    [void]($e143[-1] -match 'E-143 Suchfenster nach Out: (\d+) von (\d+) Treffern')
    $abgelehnt = $Matches[1]
    foreach ($z in $e143) { Write-Host "E143S LOG $z" }
}
$e125 = @($neu | Where-Object { $_ -match 'E-125 Xfer nach Out abgelehnt' })
foreach ($z in $e125) { Write-Host "E143S LOG $z" }
Write-Host ("E143S andere Dialoge {0}, neue Logzeilen {1}" -f $andere, $neu.Count)

# Aufraeumen: Suchfenster schliessen.
if ($lebt -and [E143S]::IsWindow($such)) { [void][E143S]::PostMessageA($such, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); Start-Sleep -Milliseconds 800; Aufraeumen $pp }

Write-Host ("E143S ERGEBNIS treffer={0} hinweise={1} abgelehnt-log={2} e125-zeilen={3} out-neu={4} lebt={5}" -f `
    $treffer, $hinweise, $abgelehnt, $e125.Count, $outNeu, $lebt)
