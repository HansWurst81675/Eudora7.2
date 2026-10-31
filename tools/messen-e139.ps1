# messen-e139.ps1 - Befund E-139: laesst sich der Hinweis "Rechtschreibpruefung
# nicht verfuegbar" dauerhaft abschalten?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# Pruefstand C:\Temp\E139. Nur Botschaften an gemessene Fensterhandles, kein
# Tastendruck.
#
# WARUM ES DAS GIBT. Gregor am 23.10.2026: die Meldung kommt nach jedem
# Programmstart wieder, es fehlt ein Kaestchen "nicht mehr anzeigen". Seit
# der Behebung zeigt spell.cpp sie ueber NoteDialog mit dem INI-Schalter
# WarnSpellUnavailable (Vorgabe 1); das Kaestchen setzt ihn auf 0.
#
# ZWEI LAEUFE, der Zustand steht in der Eudora.ini:
#   Lauf 1 (WarnSpellUnavailable fehlt oder ist 1): Nachricht oeffnen,
#     Antwort anlegen - der Hinweis MUSS kommen, MIT Kaestchen. Das Skript
#     kreuzt es an (BM_SETCHECK) und drueckt OK.
#   Lauf 2 (WarnSpellUnavailable=0, vom Lauf 1 geschrieben): dasselbe - der
#     Hinweis darf NICHT kommen.
# -Vorbereiten nimmt den Schalter aus der INI, also beginnt es bei Lauf 1.
#
# Ausgabe:
#   E139 ERGEBNIS lauf=<1|2> erschienen=<0|1> kaestchen=<0|1> angekreuzt=<0|1> lebt=<0|1>
# Erwartet nach der Behebung: Lauf 1 "erschienen=1 kaestchen=1 angekreuzt=1",
# Lauf 2 "erschienen=0". 7.2.1.128 zeigt in Lauf 1 "kaestchen=0" und - weil
# nichts abschaltbar ist - in Lauf 2 wieder "erschienen=1".
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E139 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md  = Join-Path $voll 'Mailverzeichnis'
$ini = Join-Path $md 'Eudora.ini'

function SchalterAus() {
    if (-not (Test-Path -LiteralPath $ini)) { return $false }
    return [bool](Select-String -LiteralPath $ini -Pattern '^\s*WarnSpellUnavailable\s*=\s*0\s*$' -Quiet)
}

if ($Vorbereiten) {
    if (-not (Test-Path -LiteralPath $ini)) { Write-Host "E139 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    $b = [IO.File]::ReadAllBytes($ini)
    $t = [Text.Encoding]::GetEncoding(28591).GetString($b)
    $t2 = [regex]::Replace($t, '(?m)^[ \t]*WarnSpellUnavailable[ \t]*=.*\r?\n', '')
    if ($t2 -ne $t) { [IO.File]::WriteAllBytes($ini, [Text.Encoding]::GetEncoding(28591).GetBytes($t2)) }
    $eml = Join-Path (Split-Path -Parent $PSScriptRoot) 'Testdaten\e118-euro-in-imap-ordner.eml'
    $b = [IO.File]::ReadAllBytes($eml)
    $kopf = [Text.Encoding]::ASCII.GetBytes("From ???@??? Fri Oct 30 10:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopf + $b + $ende))
    Write-Host ("E139 vorbereitet: {0} (Schalter entfernt: {1})" -f $md, [int]($t2 -ne $t))
    exit 0
}

$lauf = if (SchalterAus) { 2 } else { 1 }

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E139 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Ansi, EntryPoint="SendMessageA")] public static extern IntPtr SendText(IntPtr h, uint m, IntPtr w, string l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E139]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E139]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object E139+R; [void][E139]::GetWindowRect($h,[ref]$r); $r.T }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E139+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E139]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E139+EP]{ param($h,$p)
        $o = 0; [void][E139]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E139]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E139]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E139]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
# Der Dateidialog am Merkmal: Explorer-Teil der Klasse DUIViewWndClassName.
function Dateidialog($pp) {
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        if (Kinder $d.H | Where-Object { (Kl $_) -eq 'DUIViewWndClassName' }) { return $d.H }
    }
    return $null
}
function WarteAufDialog($pp, [int] $Sekunden = 15) {
    for ($i = 0; $i -lt $Sekunden * 4; $i++) {
        if (-not (Lebt $pp)) { return 'tot' }
        $d = Dateidialog $pp
        if ($d) { return $d }
        Start-Sleep -Milliseconds 250
    }
    return $null
}
# Andere Dialoge mit Text ausgeben; ohne passenden Knopf ABBRECHEN, nie blind OK.
function Dialoge($pp, [string] $Knopf = '^(OK)$') {
    $n = 0
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        if (Kinder $d.H | Where-Object { (Kl $_) -eq 'DUIViewWndClassName' }) { continue }
        $texte = @(); $knoepfe = @()
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button')         { $knoepfe += [pscustomobject]@{H=$c; T=$t} }
        }
        Write-Host ("E139 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E139]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E139]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E139]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E139]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E139]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E139]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E139]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][E139]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][E139]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][E139]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
}
# Postfach In nach vorn holen und warten, bis seine Liste da ist. Kein
# Namensvergleich: mit Vorschau traegt das Fenster den Namen der Vorschaudatei.
function InListe() {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt 32792                       # ID_MAILBOX_IN
        $k = Aktiv $mdi; $lb = Liste $k
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    Write-Host 'E139 FEHLER: Postfach In kam nicht nach vorn'; exit 1
}


# Den Rechtschreibhinweis suchen: ein #32770 mit "Rechtschreib" im Text.
function Hinweis($pp) {
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        foreach ($c in (Kinder $d.H)) {
            if ((Kl $c) -eq 'Static' -and (Tx $c) -match 'Rechtschreib') { return $d }
        }
    }
    return $null
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E139 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E139 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E139 Prozess $pp Hauptfenster $haupt MDI $mdi Lauf $lauf"
[void](Dialoge $pp)

# --- Nachricht oeffnen und beantworten -------------------------------------
$in, $lbIn = InListe
if ((Anzahl $lbIn) -lt 1) { Write-Host 'E139 FEHLER: In ist leer - die Vorbereitung hat nicht gegriffen'; exit 1 }
[void](Waehle $lbIn 0)
[void][E139]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN an die Liste
[void][E139]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
Start-Sleep -Seconds 3
$lesen = Aktiv $mdi
if ($lesen -eq $in) { Write-Host 'E139 FEHLER: die Nachricht liess sich nicht oeffnen'; exit 1 }
Befehl $haupt 32855                               # ID_MESSAGE_REPLY

# Bis zu 10 s auf den Hinweis warten.
$erschienen = 0; $kaestchen = 0; $angekreuzt = 0
for ($i = 0; $i -lt 40 -and (Lebt $pp); $i++) {
    $d = Hinweis $pp
    if ($d) {
        $erschienen = 1
        $texte = @(); $box = $null; $ok = $null
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button' -and [E139]::IsWindowVisible($c)) {
                if ($t -match 'show this again|nicht mehr') { $box = $c }
                elseif ($t -match '^OK$') { $ok = $c }
            }
        }
        Write-Host ("E139 HINWEIS [{0}] {1}" -f $d.Text, ($texte -join ' '))
        if ($box) {
            $kaestchen = 1
            Write-Host ("E139 KAESTCHEN [{0}]" -f (Tx $box))
            [void][E139]::SendMessageA($box, 0x00F1, [IntPtr]1, [IntPtr]::Zero)      # BM_SETCHECK
            $angekreuzt = [int]([E139]::SendMessageA($box, 0x00F0, [IntPtr]::Zero, [IntPtr]::Zero) -eq 1)   # BM_GETCHECK
        }
        if ($ok) { [void][E139]::PostMessageA($ok, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else     { [void][E139]::PostMessageA($d.H, 0x0111, [IntPtr]1, [IntPtr]::Zero) }      # IDOK
        Start-Sleep -Milliseconds 800
        break
    }
    Start-Sleep -Milliseconds 250
}
if (-not $erschienen) { Write-Host 'E139 kein Rechtschreibhinweis in 10 s' }

# Aufraeumen: Antwort ohne Speichern schliessen, Nachricht schliessen.
$verfassen = Aktiv $mdi
if ($verfassen -ne $lesen -and $verfassen -ne $in) {
    [void][E139]::PostMessageA($verfassen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
    Start-Sleep -Milliseconds 1200
    for ($r = 0; $r -lt 4; $r++) { if ((Dialoge $pp '^(No|Nein|Don.t Save|OK)$') -eq 0) { break }; Start-Sleep -Milliseconds 600 }
}
[void][E139]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
Start-Sleep -Milliseconds 1000
[void](Dialoge $pp)

Write-Host ("E139 ERGEBNIS lauf={0} erschienen={1} kaestchen={2} angekreuzt={3} lebt={4}" -f $lauf, $erschienen, $kaestchen, $angekreuzt, [int](Lebt $pp))
