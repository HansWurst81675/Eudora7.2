# messen-e144.ps1 - Befund E-144: ein Antwortentwurf, der aus Trash zurueck
# nach Out geschoben wird, muss In-Reply-To und References behalten.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript bzw. als Schalter
# messen=tools\messen-e144.ps1 in tools\pruefstand-faelle.txt, Pruefstand
# C:\Temp\E144 (Kopie von C:\Temp\E125, ohne Netz).
#
# WARUM ES DAS GIBT. Gregor hat den Fehler am 23.10.2026 an Paket 1.0.122
# bestaetigt (Out.mbx mit seiner Erlaubnis gelesen: nach Trash -> Out waren
# beide Kopfzeilen leer). Die Behebung vom 30.10.2026 steht in
# CSummary::SendAgain; dieser Lauf misst sie am Programm.
#
#   1. In oeffnen, die empfangene Nachricht waehlen, Reply (ID_MESSAGE_REPLY),
#      speichern (ID_FILE_SAVE), schliessen - der Entwurf liegt in Out
#   2. Out.mbx lesen: In-Reply-To des Entwurfs (vorher)
#   3. Out -> Trash -> Out ueber das Menue Transfer (CTocDoc::Xfer ->
#      CSummary::SendAgain(FALSE) - der Weg aus E-144)
#   4. Out.mbx lesen: In-Reply-To und References des neu angelegten Entwurfs
#
# Ausgabe: "E144 ERGEBNIS vorher=<id> nachher=<id> references=<0|1> gleich=<0|1>".
# Positivprobe: vorher muss die Message-ID der beantworteten Nachricht
# tragen - sonst hat Schritt 1 keinen Antwortentwurf erzeugt und gleich=1
# waere nichts wert.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'
$ERWARTET = '<e118-pruefung@e118.invalid>'

if ($Vorbereiten) {
    $voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
    if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E144 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
    $md = Join-Path $voll 'Mailverzeichnis'
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E144 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    foreach ($n in 'Out','Trash','In') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    $eml = Join-Path (Split-Path -Parent $PSScriptRoot) 'Testdaten\e118-html-in-imap-ordner.eml'
    $b = [IO.File]::ReadAllBytes($eml)
    $kopf = [Text.Encoding]::ASCII.GetBytes("From ???@??? Fri Oct 30 10:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopf + $b + $ende))
    Write-Host ("E144 vorbereitet: {0}" -f $md)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class WinE144 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetMenuItemCount(IntPtr m);
  [DllImport("user32.dll")] public static extern uint GetMenuItemID(IntPtr m, int i);
  [DllImport("user32.dll")] public static extern IntPtr GetSubMenu(IntPtr m, int i);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetMenuStringA(IntPtr m, uint id, StringBuilder s, int n, uint f);
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][WinE144]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][WinE144]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object WinE144+R; [void][WinE144]::GetWindowRect($h,[ref]$r); $r.T }

function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [WinE144+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][WinE144]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}

function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [WinE144+EP]{ param($h,$p)
        $o = 0; [void][WinE144]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[WinE144]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[WinE144]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][WinE144]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}

# Jeder Dialog, der auftaucht, wird mit seinem Text ausgegeben und GEZAEHLT -
# in der Gegenprobe darf keiner erscheinen. Geschlossen wird er mit dem
# Knopf, dessen Text $Knopf trifft, sonst mit IDOK an den Dialog.
$script:dialoge = 0
function Dialoge($pp, [string] $Knopf = '^(OK)$') {
    $n = 0
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        $texte = @(); $knoepfe = @()
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button')         { $knoepfe += [pscustomobject]@{H=$c; T=$t} }
        }
        Write-Host ("E144 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][WinE144]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][WinE144]::PostMessageA($d.H, 0x0111, [IntPtr]1, [IntPtr]::Zero) }       # IDOK
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}

function Befehl($h, [int] $id) { [void][WinE144]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }

# Das aktive MDI-Kind und seine Postfachliste (CTocListBox ist ein CListBox).
function Aktiv($mdi) { return [WinE144]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [WinE144]::IsWindowVisible($_) } | Select-Object -First 1)
}
# Postfach nach vorn holen und warten, bis seine Liste sichtbar ist - direkt
# nach dem Befehl ist sie es nicht immer (30.10.2026: "Argument h mit dem
# Wert ''" bei SendMessageA, als die Liste noch fehlte).
function PostfachListe([int] $befehl, [string] $name) {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt $befehl
        $k = Aktiv $mdi
        $lb = Liste $k
        # Kein Namensvergleich: mit Vorschau traegt das Postfachfenster den
        # Namen der Vorschaudatei (gemessen 30.10.2026: "...\Temp\eud3.htm").
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    $kl = (Kinder $k | ForEach-Object { Kl $_ }) -join ','
    Write-Host ("E144 FEHLER: Postfach {0} kam nicht nach vorn - vorn steht [{1}], Liste={2}, Kinder: {3}" -f $name, (Tx $k), $lb, $kl); exit 1
}
function Anzahl($lb) { return [int][WinE144]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][WinE144]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][WinE144]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][WinE144]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][WinE144]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
}

# Befehlsnummer des Eintrags $Ziel im Menue "Transfer". Die Nummern der
# Postfaecher vergibt Eudora zur Laufzeit, deshalb wird gelesen, nicht
# festgeschrieben.
function TransferNach($haupt, [string] $Ziel) {
    $m = [WinE144]::GetMenu($haupt)
    for ($i = 0; $i -lt [WinE144]::GetMenuItemCount($m); $i++) {
        $s = New-Object Text.StringBuilder 128
        [void][WinE144]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
        if (($s.ToString() -replace '&','') -ne 'Transfer') { continue }
        $sub = [WinE144]::GetSubMenu($m, $i)
        # Die Postfacheintraege fuellt Eudora erst beim Aufklappen (gemessen
        # 23.10.2026: Mailbox und Transfer hatten vorher 0 Eintraege).
        [void][WinE144]::SendMessageA($haupt, 0x0117, $sub, [IntPtr]$i)   # WM_INITMENUPOPUP
        for ($j = 0; $j -lt [WinE144]::GetMenuItemCount($sub); $j++) {
            $t = New-Object Text.StringBuilder 128
            [void][WinE144]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
            if (($t.ToString() -replace '&','') -eq $Ziel) { return [int][WinE144]::GetMenuItemID($sub, $j) }
        }
    }
    return 0
}

function MenueZeigen($haupt) {
    $m = [WinE144]::GetMenu($haupt)
    for ($i = 0; $i -lt [WinE144]::GetMenuItemCount($m); $i++) {
        $s = New-Object Text.StringBuilder 128
        [void][WinE144]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
        $sub = [WinE144]::GetSubMenu($m, $i)
        $teile = @()
        if ($sub -ne [IntPtr]::Zero) {
            for ($j = 0; $j -lt [WinE144]::GetMenuItemCount($sub); $j++) {
                $t = New-Object Text.StringBuilder 128
                [void][WinE144]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
                $teile += ("{0}={1}" -f ($t.ToString() -replace '&',''), [WinE144]::GetMenuItemID($sub, $j))
            }
        }
        Write-Host ("E144 MENUE [{0}] {1}" -f ($s.ToString() -replace '&',''), ($teile -join '; '))
    }
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E144 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E144 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E144 Prozess $pp Hauptfenster $haupt MDI $mdi"
$start = Dialoge $pp
if ($start) { Write-Host "E144 beim Start $start Dialog(e) - zaehlen nicht zur Gegenprobe" }


# Kopfzeile des LETZTEN Entwurfs in Out.mbx lesen (geteilt geoeffnet, Eudora
# haelt die Datei offen).
function OutKopf([string] $Name) {
    $p = Join-Path $Pfadfilter 'Mailverzeichnis\Out.mbx'
    if (-not (Test-Path $p)) { return '' }
    $fs = New-Object IO.FileStream($p, 'Open', 'Read', 'ReadWrite')
    $sr = New-Object IO.StreamReader($fs, [Text.Encoding]::GetEncoding(28591))
    $t = $sr.ReadToEnd(); $sr.Close()
    $treffer = [regex]::Matches($t, '(?im)^' + [regex]::Escape($Name) + ':[ \t]*(.*)$')
    if ($treffer.Count -eq 0) { return '' }
    return $treffer[$treffer.Count - 1].Groups[1].Value.Trim()
}

# --- 1. Antwortentwurf anlegen ---------------------------------------------
$in, $lbIn = PostfachListe 32792 "In"          # ID_MAILBOX_IN
Write-Host ("E144 In [{0}] Eintraege {1}" -f (Tx $in), (Anzahl $lbIn))
if ((Anzahl $lbIn) -lt 1) { Write-Host 'E144 FEHLER: In ist leer'; exit 1 }
Write-Host ("E144 gewaehlt in In: {0}" -f (Waehle $lbIn 0))
Befehl $haupt 32855                               # ID_MESSAGE_REPLY
Start-Sleep -Seconds 2
$null = Dialoge $pp
$verfassen = Aktiv $mdi
if ($verfassen -eq $in) { Write-Host 'E144 FEHLER: Reply hat kein Verfassen-Fenster geoeffnet'; exit 1 }
Write-Host ("E144 Verfassen-Fenster {0} [{1}]" -f $verfassen, (Tx $verfassen))
# Eine unveraenderte Antwort gilt nicht als geaendert - ID_FILE_SAVE tut dann
# nichts, und WM_CLOSE verwirft sie (gemessen 30.10.2026: Out blieb leer).
# Deshalb ein Wort in das unterste Eingabefeld (den Text) - per WM_CHAR an das
# gemessene Handle, kein Tastendruck.
$felder = Kinder $verfassen | Where-Object { [WinE144]::IsWindowVisible($_) -and ((Kl $_) -match 'RICHEDIT|Edit|Afx.*View|PgEdit') }
$text = $felder | Sort-Object { Oben $_ } | Select-Object -Last 1
if (-not $text) { Write-Host ("E144 FEHLER: kein Textfeld im Verfassen-Fenster - Klassen: {0}" -f ((Kinder $verfassen | ForEach-Object { Kl $_ }) -join ',')); exit 1 }
foreach ($ch in 'Antwort'.ToCharArray()) { [void][WinE144]::PostMessageA($text, 0x0102, [IntPtr][int]$ch, [IntPtr]1); Start-Sleep -Milliseconds 60 }
Start-Sleep -Milliseconds 800
Befehl $haupt 57603                               # ID_FILE_SAVE
$null = Dialoge $pp
[void][WinE144]::PostMessageA($verfassen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
Start-Sleep -Milliseconds 1500
$null = Dialoge $pp '^(Yes|Ja)$'

$vorher = OutKopf 'In-Reply-To'
Write-Host ("E144 vorher In-Reply-To=[{0}] References=[{1}]" -f $vorher, (OutKopf 'References'))

# --- 2. Out -> Trash -> Out ------------------------------------------------
$out, $lbOut = PostfachListe 32793 "Out"      # ID_MAILBOX_OUT
if ((Anzahl $lbOut) -lt 1) { Write-Host 'E144 FEHLER: Out ist leer - der Entwurf wurde nicht gespeichert'; exit 1 }
$null = Waehle $lbOut ((Anzahl $lbOut) - 1)
Befehl $haupt (TransferNach $haupt 'Trash')
$null = Dialoge $pp
$trash, $lbTrash = PostfachListe 32794 "Trash"  # ID_MAILBOX_TRASH
if ((Anzahl $lbTrash) -lt 1) { Write-Host 'E144 FEHLER: Trash ist leer'; exit 1 }
$null = Waehle $lbTrash ((Anzahl $lbTrash) - 1)
Befehl $haupt (TransferNach $haupt 'Out')
$null = Dialoge $pp
Start-Sleep -Seconds 2

# --- 3. nachher ------------------------------------------------------------
$nachher = OutKopf 'In-Reply-To'
$ref = OutKopf 'References'
Write-Host ("E144 nachher In-Reply-To=[{0}] References=[{1}]" -f $nachher, $ref)
$probe = if ($vorher -eq $ERWARTET) { 'ok' } else { 'LEER' }
$gleich = if ($probe -eq 'ok' -and $nachher -eq $vorher) { 1 } else { 0 }
$hatRef = if ($ref -match [regex]::Escape($ERWARTET)) { 1 } else { 0 }
Write-Host ("E144 ERGEBNIS probe={0} gleich={1} references={2}" -f $probe, $gleich, $hatRef)
