# messen-e220.ps1 - Befund E-220: laesst sich der Dateiname, den "Speichern
# unter" vorschlaegt, ohne Aenderung speichern?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1).
# Pruefstaende (Kopien von C:\Temp\E128 bzw. E128-alt, POP-Konto auf den
# Pruefserver 127.0.0.1:11110):
#   C:\Temp\E220      neuer Bau
#   C:\Temp\E220-alt  Gegenprobe, Bau 7.2.1.131
# Pruefmail: Testdaten\e220-dateiname-betreff.eml - HTML, Betreff mit
# Umlauten, "|", Apostroph, einer Versionsnummer mit Punkten, 107 Zeichen;
# das 63. Zeichen ist der Apostroph
# (63 Zeichen fasst die Zusammenfassung m_Subject - wie in Gregors Fall
# endet der gekuerzte Name auf den Apostroph).
#
# WARUM ES DAS GIBT. Gregor am 03.11.2026 an 7.2.2.132: "dateinamen so
# vorgeben, dass man auf speichern klicken kann, ohne den namen zu aendern."
# Aus der Postfachliste stand der ganze Pfad mit doppeltem Rueckstrich im
# Feld, Windows meldete "Der Dateiname ist ungueltig"; auf beiden Wegen
# fehlten die Umlaute.
#
# Gemessen wird, was der Anwender sieht und bekommt:
#   1. der Text im Feld "Dateiname" - die Edit im ComboBox-Steuerelement
#      1148 (cmb13) des Dialogs, per WM_GETTEXT (GetWindowText liest ueber
#      Prozessgrenzen keine Steuerelemente - darum kam in messen-e128.ps1
#      name= leer heraus). Positivprobe: ein Probetext wird gesetzt und
#      zurueckgelesen, danach der Vorschlag wieder eingesetzt;
#   2. die Datei: steht im Feld ein Pfad, wird OHNE Aenderung OK gedrueckt;
#      steht nur ein Name da, wird das Mailverzeichnis davorgesetzt (der
#      Ordner des Dialogs ist der zuletzt benutzte und kann "Dokumente"
#      sein - dorthin schreibt der Pruefstand nicht) und OK gedrueckt.
#      Gespeichert heisst: eine NEUE Datei liegt danach im Mailverzeichnis.
# Wege: Postfachliste, Nachrichtenfenster. Nur Botschaften an gemessene
# Fensterhandles, kein Tastendruck.
#
# Ausgabe:
#   E220 WEG <weg> feld=<text> ordner=<Ordner des Dialogs> laenge=<n> pfad= umlaute= doppelleer= ende= gespeichert= datei=<name>
#   E220 ERGEBNIS mbx=<0|1> probe=<0|1> je Weg (liste, lesen, liste2) pfad= umlaute=
#        doppelleer= ende= gespeichert= voll= (voll: Name laenger als die 63
#        Zeichen der Zusammenfassung) punkte= (die Versionsnummer steht mit
#        Punkten im Feld) endung= (Endung der gespeicherten Datei) ... lebt=
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch ('^' + [regex]::Escape($(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp' })) + '\\[^\\]+')) { Write-Host "E220 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$repo = Split-Path -Parent $PSScriptRoot
$lat = [Text.Encoding]::GetEncoding(28591)
$pidDatei = Join-Path $voll 'pop-pruefserver.pid'
$eml = 'Testdaten\e220-dateiname-betreff.eml'

function PopBeenden {
    if (-not (Test-Path -LiteralPath $pidDatei)) { return }
    $alt = [int](Get-Content -LiteralPath $pidDatei)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "E220 POP-Pruefserver $alt beendet" }
    Remove-Item -LiteralPath $pidDatei -Force
}

if ($Vorbereiten) {
    $ini = Join-Path $md 'Eudora.ini'
    if (-not (Test-Path $ini)) { Write-Host "E220 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    PopBeenden
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '(?i)^(e128-.*|e194-.*|e177-.*|e220-.*|lmos\.dat.*|.*Testmail E-220.*)$' } | Remove-Item -Force
    foreach ($d in 'spool','Embedded','ablage') { $p = Join-Path $md $d; if (Test-Path $p) { Get-ChildItem -LiteralPath $p -File | Remove-Item -Force } }
    New-Item -ItemType Directory -Force (Join-Path $md 'ablage') | Out-Null
    $fp = Join-Path $md 'Filters.pce'; if (Test-Path $fp) { Remove-Item -LiteralPath $fp -Force }

    $t = $lat.GetString([IO.File]::ReadAllBytes($ini))
    foreach ($kv in @(@('POPPort','11110'), @('SSLReceiveUse','0'), @('SavePassword','1'), @('SavePasswordText','eA=='),
                      @('IncludeHeaders', '0'), @('GuessParagraphs','0'))) {
        $k = $kv[0]; $v = $kv[1]
        if ($t -match ('(?m)^' + $k + '=')) { $t = [regex]::Replace($t, ('(?m)^' + $k + '=[^\r\n]*'), ($k + '=' + $v)) }
        else { $t = $t -replace '(?m)^\[Settings\]\r?\n', ("[Settings]`r`n" + $k + '=' + $v + "`r`n") }
    }
    [IO.File]::WriteAllBytes($ini, $lat.GetBytes($t))

    $belegt = Get-NetTCPConnection -LocalPort 11110 -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Host "E220 FEHLER: Port 11110 ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $post = Join-Path $voll 'post'
    if (Test-Path $post) { Get-ChildItem -LiteralPath $post -File | Remove-Item -Force } else { New-Item -ItemType Directory $post | Out-Null }
    $popEml = Join-Path $post 'e220-pop.eml'
    Copy-Item -LiteralPath (Join-Path $repo $eml) -Destination $popEml -Force
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $p = Start-Process $perl -ArgumentList @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml', '--eml', $popEml) `
                       -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("E220 vorbereitet: {0}; POP-Pruefserver PID {1}" -f $md, $p.Id)
    exit 0
}

try { Start-Transcript -Path (Join-Path $voll 'messen-e220.txt') -Force | Out-Null } catch { }

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E220 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr GetParent(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Ansi, EntryPoint="SendMessageA")] public static extern IntPtr SendText(IntPtr h, uint m, IntPtr w, string l);
  [DllImport("user32.dll", CharSet=CharSet.Ansi, EntryPoint="SendMessageA")] public static extern IntPtr SendHole(IntPtr h, uint m, IntPtr w, StringBuilder l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E220]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E220]::GetWindowTextA($h,$s,512); $s.ToString() }
# WM_GETTEXT: liest auch Steuerelemente eines anderen Prozesses.
function Gt($h) {
    $n = [int][E220]::SendMessageA($h, 0x000E, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_GETTEXTLENGTH
    if ($n -lt 0 -or $n -gt 4000) { return '' }
    $s = New-Object Text.StringBuilder ($n + 2)
    [void][E220]::SendHole($h, 0x000D, [IntPtr]($n + 1), $s)                         # WM_GETTEXT
    return $s.ToString()
}
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E220+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E220]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E220+EP]{ param($h,$p)
        $o = 0; [void][E220]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) { [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E220]::IsWindowVisible($h)}) }
        return $true }
    [void][E220]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
function Dateidialog($pp) {
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' })) {
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
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' })) {
        if (Kinder $d.H | Where-Object { (Kl $_) -eq 'DUIViewWndClassName' }) { continue }
        $texte = @(); $knoepfe = @()
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button')         { $knoepfe += [pscustomobject]@{H=$c; T=$t} }
        }
        Write-Host ("E220 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E220]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E220]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E220]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E220]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) { return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E220]::IsWindowVisible($_) } | Select-Object -First 1) }
function Anzahl($lb) { return [int][E220]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E220]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))
    [void][E220]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)
    [void][E220]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)
}
function InListe() {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt 32792                       # ID_MAILBOX_IN
        $k = Aktiv $mdi; $lb = Liste $k
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    Write-Host 'E220 FEHLER: Postfach In kam nicht nach vorn'; PopBeenden; exit 1
}

# Das Feld "Dateiname": die Edit in der ComboBox mit der Kennung 1148
# (cmb13, dlgs.h) - so baut der Vista-Dialog sein Namensfeld fuer
# Altanwendungen nach. Fehlt sie, die Edit, deren Elternteil eine ComboBox
# ist (die Dateityp-Liste ist eine Drop-List ohne Edit).
function Namensfeld($d) {
    $kandidaten = @()
    foreach ($c in (Kinder $d | Where-Object { (Kl $_) -eq 'Edit' -and [E220]::IsWindowVisible($_) })) {
        $p = [E220]::GetParent($c)
        $kandidaten += [pscustomobject]@{ H = $c; PKlasse = (Kl $p); PId = [E220]::GetDlgCtrlID($p); Id = [E220]::GetDlgCtrlID($c) }
    }
    foreach ($k in $kandidaten) { Write-Host ("E220 EDIT id={0} eltern={1}/{2}" -f $k.Id, $k.PKlasse, $k.PId) }
    $f = $kandidaten | Where-Object { $_.PId -eq 1148 } | Select-Object -First 1
    if (-not $f) { $f = $kandidaten | Where-Object { $_.PKlasse -eq 'ComboBox' } | Select-Object -First 1 }
    if ($f) { return $f.H } else { return $null }
}
# Letzter Teil des Ordners, den der Dialog zeigt (Adressleiste
# "Adresse: ..." / "Address: ...").
function Ordner($d) {
    foreach ($c in (Kinder $d | Where-Object { (Kl $_) -eq 'ToolbarWindow32' })) {
        $t = Gt $c
        if ($t -match '^(Adresse|Address):\s*(.*)$') { return $Matches[2] }
    }
    return '-'
}

$script:erg = [ordered]@{}; $script:probe = 1
function SpeichernUnter([string] $weg, [string] $ziel = $md) {
    [void][E220]::PostMessageA($haupt, 0x0111, [IntPtr]57604, [IntPtr]::Zero)   # ID_FILE_SAVE_AS
    $d = WarteAufDialog $pp
    if ($d -eq 'tot') { Write-Host "E220 $weg ABGESTUERZT beim Aufbau des Dateidialogs"; PopBeenden; exit 1 }
    if (-not $d) { Write-Host "E220 $weg kein Dateidialog erschienen"; [void](Dialoge $pp); return }
    Start-Sleep -Milliseconds 800
    $feld = Namensfeld $d
    if (-not $feld) { Write-Host "E220 $weg FEHLER: kein Namensfeld gefunden"; $script:probe = 0
        [void][E220]::PostMessageA($d, 0x0111, [IntPtr]2, [IntPtr]::Zero); Start-Sleep -Milliseconds 800; return }
    $text = Gt $feld
    # Positivprobe: setzen, zuruecklesen, Vorschlag wieder einsetzen.
    [void][E220]::SendText($feld, 0x000C, [IntPtr]::Zero, 'E220-PROBE')
    if ((Gt $feld) -ne 'E220-PROBE') { $script:probe = 0; Write-Host "E220 $weg PROBE gescheitert" }
    [void][E220]::SendText($feld, 0x000C, [IntPtr]::Zero, $text)
    if ((Gt $feld) -ne $text) { $script:probe = 0; Write-Host "E220 $weg PROBE: Vorschlag nicht wieder eingesetzt" }
    $ordner = Ordner $d

    $pfad = [int]($text -match '[\\/:]')
    $stamm = [IO.Path]::GetFileNameWithoutExtension(($text -replace '[\\/:]', '_'))
    $name = $(if ($pfad) { $text } else { $text })
    $umlaute = [int]($text.Contains([string][char]0xC4) -and $text.Contains([string][char]0xFC))   # Ae, ue aus dem Betreff
    $doppel = [int]($text.Contains('  '))
    $ende = [int]($stamm.Length -gt 0 -and $stamm -notmatch '[ .]$')

    $vorher = @(Get-ChildItem -LiteralPath $ziel -File | ForEach-Object { $_.Name })
    if (-not $pfad) { [void][E220]::SendText($feld, 0x000C, [IntPtr]::Zero, (Join-Path $ziel $text)); Start-Sleep -Milliseconds 300 }
    [void][E220]::PostMessageA($d, 0x0111, [IntPtr]1, [IntPtr]::Zero)   # IDOK
    $neu = $null
    for ($i = 0; $i -lt 24 -and (Lebt $pp) -and -not $neu; $i++) {
        Start-Sleep -Milliseconds 250
        $neu = Get-ChildItem -LiteralPath $ziel -File | Where-Object { $vorher -notcontains $_.Name } | Select-Object -First 1
    }
    Start-Sleep -Milliseconds 800
    [void](Dialoge $pp)
    if ((Lebt $pp) -and (Dateidialog $pp)) {
        Write-Host "E220 $weg Dateidialog steht noch - wird abgebrochen"
        [void][E220]::PostMessageA((Dateidialog $pp), 0x0111, [IntPtr]2, [IntPtr]::Zero)
        Start-Sleep -Milliseconds 800
    }
    [void](Dialoge $pp)
    $gesp = [int]([bool]$neu)
    $dn = $(if ($neu) { $neu.Name } else { '-' })
    if ($weg -eq 'liste' -and $neu) { $script:liDatei = $neu.Name }
    Write-Host ("E220 WEG {0} feld=[{1}] ordner={2} laenge={3} pfad={4} umlaute={5} doppelleer={6} ende={7} gespeichert={8} datei=[{9}]" -f `
        $weg, $text, $ordner, $stamm.Length, $pfad, $umlaute, $doppel, $ende, $gesp, $dn)
    $script:erg["$weg-pfad"] = $pfad; $script:erg["$weg-umlaute"] = $umlaute; $script:erg["$weg-doppelleer"] = $doppel
    $script:erg["$weg-ende"] = $ende; $script:erg["$weg-gespeichert"] = $gesp; $script:erg["$weg-voll"] = [int]($stamm.Length -gt 63); $script:erg["$weg-endung"] = $(if ($neu) { $neu.Extension.TrimStart('.').ToLower() } else { '-' }); $script:erg["$weg-punkte"] = [int]($text.Contains('7.2.1.128R'))
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E220 FEHLER: keine Eudora aus $voll"; PopBeenden; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E220 FEHLER: kein Hauptfenster'; PopBeenden; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E220 Prozess $pp Hauptfenster $haupt MDI $mdi"
[void](Dialoge $pp)

# --- Post holen -------------------------------------------------------------
$in, $lbIn = InListe
$vorherN = Anzahl $lbIn
[void][E220]::PostMessageA($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)   # ID_FILE_CHECKMAIL
for ($i = 0; $i -lt 40 -and (Anzahl $lbIn) -le $vorherN; $i++) { Start-Sleep -Milliseconds 500; if (($i % 6) -eq 5) { [void](Dialoge $pp) } }
Start-Sleep -Seconds 2
[void](Dialoge $pp)
PopBeenden
$in, $lbIn = InListe
$nIn = Anzahl $lbIn
Write-Host ("E220 In: vorher={0} nachher={1}" -f $vorherN, $nIn)
$mbxPfad = Join-Path $md 'In.mbx'
$mbx = 0
if (Test-Path -LiteralPath $mbxPfad) {
    $m = $lat.GetString([IO.File]::ReadAllBytes($mbxPfad))
    $mbx = [int]($m -match 'E-220 Pruefnachricht')
}
Write-Host "E220 MBX passt=$mbx"

if ($nIn -ge 1) {
    Waehle $lbIn 0
    SpeichernUnter 'liste'
    # Die Datei der Liste wieder entfernen: der alte Bau schlaegt auf beiden
    # Wegen denselben Namen vor, die Rueckfrage "ersetzen?" truebte sonst den
    # zweiten Weg.
    if ($script:liDatei) { Remove-Item -LiteralPath (Join-Path $md $script:liDatei) -Force -ErrorAction SilentlyContinue }

    $in, $lbIn = InListe
    Waehle $lbIn 0
    [void][E220]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN an die Liste
    [void][E220]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
    Start-Sleep -Seconds 3
    $lesen = Aktiv $mdi
    if ($lesen -eq $in) { Write-Host 'E220 FEHLER: die Nachricht liess sich nicht oeffnen' }
    else {
        SpeichernUnter 'lesen' (Join-Path $md 'ablage')
        [void][E220]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
        Start-Sleep -Milliseconds 1000
        [void](Dialoge $pp)
        # Gregors Fall (A): der zuletzt benutzte Ordner ist NICHT das
        # Mailverzeichnis. Der Weg "lesen" hat eben nach ablage gespeichert;
        # Und dann den Ordner wegnehmen: Gregors Pakete liegen je Fassung in
        # einem neuen Verzeichnis, der zuletzt benutzte Ordner gibt es dann
        # oft nicht mehr.
        if ($env:E220_ABLAGE_WEG -eq '1') { Remove-Item -LiteralPath (Join-Path $md 'ablage') -Recurse -Force; Write-Host 'E220 ablage entfernt' }
        # jetzt noch einmal aus der Postfachliste.
        $in, $lbIn = InListe
        Waehle $lbIn 0
        SpeichernUnter 'liste2'
    }
}

function W([string] $k) { if ($script:erg.Contains($k)) { return $script:erg[$k] } else { return '-' } }
$teile = @()
foreach ($w in 'liste','lesen','liste2') { foreach ($a in 'pfad','umlaute','doppelleer','ende','gespeichert','voll','punkte','endung') { $teile += ("{0}-{1}={2}" -f $w, $a, (W "$w-$a")) } }
Write-Host ("E220 ERGEBNIS mbx={0} probe={1} {2} lebt={3}" -f $mbx, $script:probe, ($teile -join ' '), [int](Lebt $pp))
