# messen-e207.ps1 - Befund E-207: schreibt "Speichern unter" aus dem
# Signaturfenster eine leere Datei, und gilt das Fenster danach als gesichert?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# Pruefstand C:\Temp\E207 (Kopie von C:\Temp\E205). Nur Botschaften an
# gemessene Fensterhandles, kein Tastendruck ueber die Eingabewarteschlange.
#
# WARUM ES DAS GIBT. PRUEFER-86 N1 (02.11.2026) am Quelltext:
# CSignatureDoc::Serialize ruft bei Speichern unter pView->CPaigeEdtView::
# Serialize(ar). Diese Funktion ist seit dem Originalstand auskommentiert
# (PaigeEdtView.cpp, "03-17-2000 Commented this function"), der Aufruf landet
# in CObject::Serialize und schreibt nichts. CDocument::OnSaveDocument legt
# die Datei trotzdem an und setzt das Geaendert-Kennzeichen zurueck.
#
# Ablauf:
#   Vorbereiten: Sigs\Standard.txt bekommt einen bekannten Text mit
#      Umlauten (Latin-1), e207-*.* werden geloescht.
#   1. Signaturen-Fenster (ID_TOOLS_VIEW_SIGNATURES), im Baum den Eintrag
#      "Standard" waehlen und mit WM_CHAR VK_RETURN an den Baum oeffnen
#      (CSignatureTree::OnChar -> CA_OPEN).
#   2. Eine Marke "Q7Z" per WM_CHAR an die Ansicht - das Fenster ist dann
#      geaendert.
#   3. Speichern unter -> e207-sig.txt, dann -> e207-sig.htm
#   4. Fenster schliessen; kommt die Frage "Aenderungen sichern?", wird sie
#      mit Nein beantwortet (die Signatur selbst bleibt, wie sie war).
#   5. Signaturdatei vor und nach dem Lauf vergleichen.
#
# Ausgabe:
#   E207 DATEI <weg> bytes=<n> text=<0|1> marke=<0|1> umlaute=<0|1> html=<0|1>
#   E207 ERGEBNIS fenster=<0|1> geaendert=<0|1> txt=<passt|leer|fehlt|...> htm=<...> frage=<0|1> sig=<unveraendert|veraendert> lebt=<0|1>
#   Erwartet nach der Behebung: fenster=1 geaendert=1 txt=passt htm=passt sig=unveraendert lebt=1
#   Vor der Behebung (Vermutung PRUEFER-86 N1): txt=leer htm=leer
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch ('^' + [regex]::Escape($(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp' })) + '\\[^\\]+')) { Write-Host "E207 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$sig = Join-Path $md 'Sigs\Standard.txt'
$lat = [Text.Encoding]::GetEncoding(28591)
# Bekannter Signaturtext: zwei Zeilen, Umlaute als Latin-1-Bytes.
$SIGTEXT = "E207 Signatur Zeile eins`r`nGr" + [char]0xFC + [char]0xDF + "e " + [char]0xE4 + [char]0xF6 + [char]0xFC + " Ende"
$MARKE = 'Q7Z'
function Ziel([string] $weg) { return (Join-Path $md ("e207-sig.{0}" -f $weg)) }

if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E207 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    if (-not (Test-Path (Join-Path $md 'Sigs'))) { New-Item -ItemType Directory (Join-Path $md 'Sigs') | Out-Null }
    Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^e20[57]-' } | Remove-Item -Force
    Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^Out.(mbx|toc)$' } | Remove-Item -Force
    [IO.File]::WriteAllBytes($sig, $lat.GetBytes($SIGTEXT))
    Write-Host ("E207 vorbereitet: {0}" -f $md)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E207 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr GetParent(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Ansi, EntryPoint="SendMessageA")] public static extern IntPtr SendText(IntPtr h, uint m, IntPtr w, string l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E207]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E207]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object E207+R; [void][E207]::GetWindowRect($h,[ref]$r); $r.T }
function Flaeche($h) { $r = New-Object E207+R; [void][E207]::GetWindowRect($h,[ref]$r); ($r.Ri - $r.L) * ($r.B - $r.T) }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E207+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E207]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E207+EP]{ param($h,$p)
        $o = 0; [void][E207]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E207]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E207]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E207]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
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
        Write-Host ("E207 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E207]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E207]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E207]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E207]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Baeume($pp) { return @(AlleFenster $pp | Where-Object { $_.Klasse -eq 'SysTreeView32' -and $_.Vis } | ForEach-Object { $_.H }) }
function Vorfahren($h) {
    $t = @(); $p = [E207]::GetParent($h)
    for ($i = 0; $i -lt 8 -and $p -ne [IntPtr]::Zero; $i++) { $t += (Tx $p); $p = [E207]::GetParent($p) }
    return ($t -join ' < ')
}

function SpeichernUnter([string] $weg) {
    $ziel = Ziel $weg
    [void][E207]::PostMessageA($haupt, 0x0111, [IntPtr]57604, [IntPtr]::Zero)   # ID_FILE_SAVE_AS
    $d = WarteAufDialog $pp
    if ($d -eq 'tot') { Write-Host "E207 $weg ABGESTUERZT beim Aufbau des Dateidialogs"; exit 1 }
    if (-not $d) { Write-Host "E207 $weg kein Dateidialog erschienen"; [void](Dialoge $pp); return 0 }
    $edits = Kinder $d | Where-Object { (Kl $_) -eq 'Edit' -and [E207]::IsWindowVisible($_) }
    $feld = $edits | Where-Object { (Tx $_) } | Select-Object -First 1
    if (-not $feld) { $feld = $edits | Sort-Object { Oben $_ } | Select-Object -First 1 }
    [void][E207]::SendText($feld, 0x000C, [IntPtr]::Zero, $ziel)       # WM_SETTEXT
    Start-Sleep -Milliseconds 500
    [void][E207]::PostMessageA($d, 0x0111, [IntPtr]1, [IntPtr]::Zero)  # IDOK
    for ($i = 0; $i -lt 40 -and (Lebt $pp) -and -not (Test-Path -LiteralPath $ziel); $i++) { Start-Sleep -Milliseconds 250 }
    Start-Sleep -Milliseconds 1000
    if ((Lebt $pp) -and (Dateidialog $pp)) {
        Write-Host "E207 $weg Dateidialog steht noch - wird abgebrochen"
        [void][E207]::PostMessageA((Dateidialog $pp), 0x0111, [IntPtr]2, [IntPtr]::Zero)   # IDCANCEL
        Start-Sleep -Milliseconds 800
    }
    [void](Dialoge $pp)
    return [int](Test-Path -LiteralPath $ziel)
}

$script:urteil = @{}
function Auswerten([string] $weg) {
    $ziel = Ziel $weg
    if (-not (Test-Path -LiteralPath $ziel)) { Write-Host ("E207 DATEI {0} fehlt" -f $weg); $script:urteil[$weg] = 'fehlt'; return }
    $b = [IO.File]::ReadAllBytes($ziel)
    $t = $lat.GetString($b)
    $text = [int]($t.Contains('E207 Signatur Zeile eins'))
    $marke = [int]($t.Contains($MARKE))
    $uml = [int]($t.Contains([string][char]0xE4 + [char]0xF6 + [char]0xFC) -or $t.Contains('&auml;&ouml;&uuml;') -or $t.Contains('&#228;&#246;&#252;'))
    $html = [int]($t -match '(?i)<html|<body|<div|<p[ >]|<br')
    Write-Host ("E207 DATEI {0} bytes={1} text={2} marke={3} umlaute={4} html={5}" -f $weg, $b.Length, $text, $marke, $uml, $html)
    if ($b.Length -eq 0) { $script:urteil[$weg] = 'leer'; return }
    $soll_html = [int]($weg -eq 'htm')
    if ($text -and $marke -and $uml -and $html -eq $soll_html) { $script:urteil[$weg] = 'passt' }
    else { $script:urteil[$weg] = ("text{0}-marke{1}-umlaute{2}-html{3}" -f $text, $marke, $uml, $html) }
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E207 FEHLER: keine Eudora aus $voll"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E207 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E207 Prozess $pp Hauptfenster $haupt MDI $mdi"
[void](Dialoge $pp)
$sigVorher = [BitConverter]::ToString([Security.Cryptography.SHA1]::Create().ComputeHash([IO.File]::ReadAllBytes($sig)))
$fenster = 0; $geaendert = 0; $frage = 0

# --- 1. Signaturen-Fenster und Eintrag oeffnen -----------------------------
$vorher = Baeume $pp
Befehl $haupt 32965                               # ID_TOOLS_VIEW_SIGNATURES
Start-Sleep -Seconds 1
$nachher = Baeume $pp
# Welcher Baum der Signaturbaum ist, entscheidet das Fenster, das aufgeht:
# neu sichtbare Baeume zuerst, dann die uebrigen (die Leiste merkt sich ihren
# Zustand in der Eudora.ini - ab dem zweiten Lauf steht der Baum schon da).
$kandidaten = @($nachher | Where-Object { $vorher -notcontains $_ }) + @($nachher | Where-Object { $vorher -contains $_ })
foreach ($b in $nachher) { Write-Host ("E207 BAUM {0} n={1}" -f $b, [int][E207]::SendMessageA($b, 0x1105, [IntPtr]::Zero, [IntPtr]::Zero)) }   # TVM_GETCOUNT
$sigKind = $null
foreach ($baum in $kandidaten) {
    if ($sigKind) { break }
    $item = [E207]::SendMessageA($baum, 0x110A, [IntPtr]0, [IntPtr]::Zero)              # TVM_GETNEXTITEM TVGN_ROOT
    for ($v = 0; $v -lt 10 -and $item -ne [IntPtr]::Zero -and -not $sigKind; $v++) {
        $vor = Aktiv $mdi
        [void][E207]::SendMessageA($baum, 0x110B, [IntPtr]9, $item)                    # TVM_SELECTITEM TVGN_CARET
        [void][E207]::PostMessageA($baum, 0x0102, [IntPtr]0x0D, [IntPtr]0)             # WM_CHAR VK_RETURN an den Baum
        Start-Sleep -Seconds 2
        [void](Dialoge $pp)
        $k = Aktiv $mdi
        Write-Host ("E207 Baum {0} Eintrag {1}: aktiv {2} [{3}]" -f $baum, $item, $k, (Tx $k))
        if ($k -ne $vor -and (Tx $k) -match '^Standard') { $sigKind = $k }
        $item = [E207]::SendMessageA($baum, 0x110A, [IntPtr]1, $item)                  # TVGN_NEXT
    }
}
if (-not $kandidaten) { Write-Host 'E207 FEHLER: kein Baum sichtbar' }

if ($sigKind) {
    $fenster = 1
    # --- 2. Marke eintippen: WM_CHAR an die groesste sichtbare Ansicht ---
    $ansicht = Kinder $sigKind | Where-Object { [E207]::IsWindowVisible($_) -and (Kl $_) -notmatch '^(ScrollBar|Static|Button|ComboBox|Edit|ToolbarWindow32)$' } |
               Sort-Object { -(Flaeche $_) } | Select-Object -First 1
    Write-Host ("E207 Ansicht {0} Klasse {1}" -f $ansicht, (Kl $ansicht))
    foreach ($c in $MARKE.ToCharArray()) {
        [void][E207]::SendMessageA($ansicht, 0x0102, [IntPtr][int]$c, [IntPtr]1)        # WM_CHAR
    }
    Start-Sleep -Milliseconds 800
    # Geaendert? WM_CLOSE und die Frage "sichern?" mit Abbrechen beantworten -
    # das Fenster bleibt offen und geaendert. Kommt keine Frage, hat die Marke
    # nicht gewirkt, und die Messung sagt nichts ueber das Kennzeichen.
    [void][E207]::PostMessageA($sigKind, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
    Start-Sleep -Milliseconds 1500
    if ((Dialoge $pp '^(Cancel|Abbrechen)$') -gt 0) { $geaendert = 1 }
    Write-Host ("E207 Frage vor Speichern unter: {0}, Fenster steht: {1}" -f $geaendert, [int][E207]::IsWindow($sigKind))
    Write-Host ("E207 nach der Marke: Titel [{0}]" -f (Tx $sigKind))

    # --- 3. Speichern unter, zweimal ------------------------------------
    [void][E207]::SendMessageA($mdi, 0x0222, $sigKind, [IntPtr]::Zero)   # WM_MDIACTIVATE
    [void](SpeichernUnter 'txt'); Start-Sleep -Seconds 1
    [void][E207]::SendMessageA($mdi, 0x0222, $sigKind, [IntPtr]::Zero)
    [void](SpeichernUnter 'htm')
    Write-Host ("E207 nach Speichern unter: Titel [{0}]" -f (Tx $sigKind))

    # --- 4. schliessen; Frage nach dem Sichern mit Nein beantworten ------
    [void][E207]::PostMessageA($sigKind, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
    Start-Sleep -Milliseconds 1500
    for ($r = 0; $r -lt 4; $r++) {
        $n = Dialoge $pp '^(No|Nein|Don.t Save)$'
        if ($n -eq 0) { break }
        $frage = 1; Start-Sleep -Milliseconds 600
    }
    Write-Host ("E207 nach dem Schliessen: Fenster steht: {0}" -f [int][E207]::IsWindow($sigKind))
} else { Write-Host 'E207 FEHLER: Signaturfenster liess sich nicht oeffnen' }

# --- Auswertung ---------------------------------------------------------------
Start-Sleep -Milliseconds 500
foreach ($w in 'txt','htm') { Auswerten $w }
$sigNachher = [BitConverter]::ToString([Security.Cryptography.SHA1]::Create().ComputeHash([IO.File]::ReadAllBytes($sig)))
$sigUrteil = if ($sigVorher -eq $sigNachher) { 'unveraendert' } else { 'veraendert' }
function U([string] $w) { if ($script:urteil.ContainsKey($w)) { return $script:urteil[$w] } else { return '-' } }
Write-Host ("E207 ERGEBNIS fenster={0} geaendert={1} txt={2} htm={3} frage={4} sig={5} lebt={6}" -f `
    $fenster, $geaendert, (U 'txt'), (U 'htm'), $frage, $sigUrteil, [int](Lebt $pp))
