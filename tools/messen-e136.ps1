# messen-e136.ps1 - Befund E-136: zerstoert Strg-S in einer geoeffneten
# HTML-Nachricht Zeichen, die windows-1252 nicht kennt?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# Pruefstand C:\Temp\E136. Nur Botschaften an gemessene Fensterhandles, kein
# Tastendruck.
#
# Pruefnachricht Testdaten\e136-zeichen-als-entitaet.eml: HTML, windows-1252,
# mit &#128293; (Emoji, ausserhalb der BMP), &#1046; (kyrillisch) und dem
# Euro-Zeichen als Byte 0x80. Ablauf: Nachricht aus In oeffnen, ID_FILE_SAVE
# (57603) ans Hauptfenster - nach einem Zeichen im Bearbeiten-Modus; ReadMessageDoc.cpp:349
# ruft dann SaveInfo -, Fenster schliessen, In.mbx lesen.
#
# Ausgabe:
#   E136 ERGEBNIS gespeichert=<0|1> fragezeichen=<n> vierbyte=<0|1> kyrillisch=<0|1> euro=<0|1> lebt=<0|1>
# fragezeichen = Zahl der "?" in der Zeile mit "Vierbyte-Zeichen" und
# "Kyrillisch"; vierbyte/kyrillisch = die Entitaet (oder das Zeichen) steht
# noch da. Erwartet nach der Behebung: fragezeichen=0 vierbyte=1
# kyrillisch=1 euro=1. 7.2.0.120 hinterliess "??" (Gregor, 22.10.2026).
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E136 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'

if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E136 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    $eml = Join-Path (Split-Path -Parent $PSScriptRoot) 'Testdaten\e136-zeichen-als-entitaet.eml'
    $b = [IO.File]::ReadAllBytes($eml)
    $kopf = [Text.Encoding]::ASCII.GetBytes("From ???@??? Sat Oct 31 20:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopf + $b + $ende))
    Write-Host ("E136 vorbereitet: {0}" -f $md)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E136 {
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

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E136]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E136]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object E136+R; [void][E136]::GetWindowRect($h,[ref]$r); $r.T }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E136+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E136]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E136+EP]{ param($h,$p)
        $o = 0; [void][E136]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E136]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E136]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E136]::EnumWindows($cb,[IntPtr]::Zero)
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
        Write-Host ("E136 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E136]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E136]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E136]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E136]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E136]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E136]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E136]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][E136]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][E136]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][E136]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
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
    Write-Host 'E136 FEHLER: Postfach In kam nicht nach vorn'; exit 1
}


# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E136 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E136 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E136 Prozess $pp Hauptfenster $haupt MDI $mdi"
[void](Dialoge $pp)

# --- Nachricht oeffnen, Strg-S ------------------------------------------------
$in, $lbIn = InListe
if ((Anzahl $lbIn) -lt 1) { Write-Host 'E136 FEHLER: In ist leer - die Vorbereitung hat nicht gegriffen'; exit 1 }
[void](Waehle $lbIn 0)
[void][E136]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN an die Liste
[void][E136]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
Start-Sleep -Seconds 3
$lesen = Aktiv $mdi
if ($lesen -eq $in) { Write-Host 'E136 FEHLER: die Nachricht liess sich nicht oeffnen'; exit 1 }
Write-Host ("E136 Nachrichtenfenster {0} [{1}]" -f $lesen, (Tx $lesen))
$mbx = Join-Path $md 'In.mbx'
$vorher = (Get-Item -LiteralPath $mbx).LastWriteTimeUtc
# Strg-S auf einer UNVERAENDERTEN Nachricht schreibt nichts (am 31.10.2026
# gemessen: 7.2.1.128 und neuer Bau gleich, keine SaveInfo-Spur). Gregors Fall
# war eine geaenderte: Bearbeiten-Modus ein (ID_EDIT_MESSAGE), ein Zeichen an
# die Anzeige (WM_CHAR an das gemessene Handle), dann speichern.
Befehl $haupt 32996                               # ID_EDIT_MESSAGE
$ie = Kinder $lesen | Where-Object { (Kl $_) -eq 'Internet Explorer_Server' } | Select-Object -First 1
if ($ie) {
    [void][E136]::PostMessageA($ie, 0x0102, [IntPtr][int][char]'x', [IntPtr]1)   # WM_CHAR
    Start-Sleep -Milliseconds 800
} else { Write-Host 'E136 kein Internet Explorer_Server im Nachrichtenfenster' }
Befehl $haupt 57603                               # ID_FILE_SAVE
Start-Sleep -Seconds 2
[void](Dialoge $pp)
[void][E136]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
Start-Sleep -Milliseconds 1500
for ($r = 0; $r -lt 3; $r++) { if ((Dialoge $pp '^(No|Nein|Don.t Save|OK)$') -eq 0) { break }; Start-Sleep -Milliseconds 600 }
Start-Sleep -Seconds 1

# --- Auswertung -----------------------------------------------------------------
$gespeichert = [int]((Get-Item -LiteralPath $mbx).LastWriteTimeUtc -ne $vorher)
$t = [Text.Encoding]::GetEncoding(28591).GetString([IO.File]::ReadAllBytes($mbx))
$zeilen = $t -split "`r?`n" | Where-Object { $_ -match 'Vierbyte-Zeichen|Kyrillisch|Euro:' }
foreach ($z in $zeilen) { Write-Host ("E136 ZEILE {0}" -f $z) }
$frage = 0
foreach ($z in ($zeilen | Where-Object { $_ -match 'Vierbyte-Zeichen|Kyrillisch' })) { $frage += ([regex]::Matches($z, '\?')).Count }
$vier = [int]($t.Contains('&#128293;') -or $t.Contains(([string][char]0xF0) + [char]0x9F + [char]0x94 + [char]0xA5))
$kyr  = [int]($t.Contains('&#1046;'))
$euro = [int](($zeilen | Where-Object { $_ -match 'Euro:' } | Select-Object -First 1) -match ([string][char]0x80 + '|&euro;|&#8364;'))
Write-Host ("E136 ERGEBNIS gespeichert={5} fragezeichen={0} vierbyte={1} kyrillisch={2} euro={3} lebt={4}" -f $frage, $vier, $kyr, $euro, [int](Lebt $pp), $gespeichert)
