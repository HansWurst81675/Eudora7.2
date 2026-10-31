# messen-e171.ps1 - Befund E-171: bringt "Search Mailfolder" aus einer
# geoeffneten Mail ohne markierten Text die Meldung "There has been an
# internal error during the search"?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# Pruefstand C:\Temp\E171. Nur Botschaften an gemessene Fensterhandles, kein
# Tastendruck.
#
# Ablauf: Nachricht aus In oeffnen (HTML, also die Trident-Ansicht), ohne
# Auswahl den Befehl ID_SEARCH_MAILFOLDER_FOR_SEL (26816) an das Hauptfenster
# - MFC reicht ihn an die aktive Ansicht weiter, genau wie das
# Rechtsklickmenue. Danach 5 s auf Dialoge achten.
#
# Ausgabe:
#   E171 ERGEBNIS fehlermeldung=<0|1> suchfenster=<0|1> lebt=<0|1>
# Erwartet nach der Behebung: fehlermeldung=0 suchfenster=1.
# 7.2.1.128: fehlermeldung=1 (Gregors eudora.log vom 29.10.2026).
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E171 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'

if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E171 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    $eml = Join-Path (Split-Path -Parent $PSScriptRoot) 'Testdaten\e118-euro-in-imap-ordner.eml'
    $b = [IO.File]::ReadAllBytes($eml)
    $kopf = [Text.Encoding]::ASCII.GetBytes("From ???@??? Fri Oct 30 10:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopf + $b + $ende))
    Write-Host ("E171 vorbereitet: {0}" -f $md)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E171 {
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

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E171]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E171]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object E171+R; [void][E171]::GetWindowRect($h,[ref]$r); $r.T }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E171+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E171]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E171+EP]{ param($h,$p)
        $o = 0; [void][E171]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E171]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E171]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E171]::EnumWindows($cb,[IntPtr]::Zero)
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
        Write-Host ("E171 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E171]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E171]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E171]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E171]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E171]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E171]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E171]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][E171]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][E171]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][E171]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
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
    Write-Host 'E171 FEHLER: Postfach In kam nicht nach vorn'; exit 1
}


# Dialoge mit Text sammeln, mit OK schliessen; liefert die Texte.
function DialogTexte($pp) {
    $alle = @()
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        $texte = @(); $ok = $null
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button' -and $t -match '^OK$') { $ok = $c }
        }
        if (-not $texte) { continue }
        $s = ($texte -join ' ')
        Write-Host ("E171 DIALOG [{0}] {1}" -f $d.Text, $s)
        $alle += $s
        if ($ok) { [void][E171]::PostMessageA($ok, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }
        else     { [void][E171]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }
        Start-Sleep -Milliseconds 600
    }
    return $alle
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E171 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E171 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E171 Prozess $pp Hauptfenster $haupt MDI $mdi"
[void](Dialoge $pp)

# --- Nachricht oeffnen -------------------------------------------------------
$in, $lbIn = InListe
if ((Anzahl $lbIn) -lt 1) { Write-Host 'E171 FEHLER: In ist leer - die Vorbereitung hat nicht gegriffen'; exit 1 }
[void](Waehle $lbIn 0)
[void][E171]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN an die Liste
[void][E171]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
Start-Sleep -Seconds 3
$lesen = Aktiv $mdi
if ($lesen -eq $in) { Write-Host 'E171 FEHLER: die Nachricht liess sich nicht oeffnen'; exit 1 }
Write-Host ("E171 Nachrichtenfenster {0} [{1}]" -f $lesen, (Tx $lesen))

# --- Search Mailfolder ohne Auswahl -----------------------------------------
Befehl $haupt 26816                               # ID_SEARCH_MAILFOLDER_FOR_SEL
$fehler = 0
for ($i = 0; $i -lt 10 -and (Lebt $pp); $i++) {
    foreach ($s in (DialogTexte $pp)) { if ($s -match 'internal error') { $fehler = 1 } }
    Start-Sleep -Milliseconds 500
}
$such = Aktiv $mdi
$suchfenster = [int]($such -ne $lesen -and $such -ne $in -and (Tx $such) -match 'Find|Such|Search')
Write-Host ("E171 aktives Fenster danach {0} [{1}]" -f $such, (Tx $such))

# Aufraeumen
if ($suchfenster) { [void][E171]::PostMessageA($such, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); Start-Sleep -Milliseconds 800 }
[void][E171]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
Start-Sleep -Milliseconds 800
[void](Dialoge $pp)

Write-Host ("E171 ERGEBNIS fehlermeldung={0} suchfenster={1} lebt={2}" -f $fehler, $suchfenster, [int](Lebt $pp))
