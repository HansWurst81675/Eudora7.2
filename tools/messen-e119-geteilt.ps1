# messen-e119-geteilt.ps1 - geht beim endgueltigen Loeschen EINER Nachricht
# das Bild einer ANDEREN verloren? (Befund E-119, PRUEFER-49 K5)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript bzw. als Schalter
# messen=tools\messen-e119-geteilt.ps1 in tools\pruefstand-faelle.txt.
# Pruefstand C:\Temp\E119K (Kopie von C:\Temp\EBILD).
#
# WARUM ES DAS GIBT. E-119 legt ein Bild, das als data:-Adresse im HTML
# steckt, als Datei Embedded\data-<Pruefsumme>.<endung> ab - EINE Datei je
# Bildinhalt. Beim Speichern einer Weiterleitung traegt Eudora diese Datei
# als Teil der Nachricht ein, ohne sie zu kopieren (make_new_part_from_file,
# PgEmbeddedImage.cpp). Beim endgueltigen Loeschen loescht DeleteEmbeddedObjects
# jede Datei der Nachricht unter Embedded - auch eine, die eine zweite
# Nachricht noch braucht. Gregor am 24.10.2026: "ja, vorher beheben, wenn
# daten verloren gehen koennen."
#
# Ablauf, ohne Tastendruck, nur Botschaften an gemessene Fensterhandles:
#   1. Pruefnachricht Testdaten\e119-data-bild.eml per POP abholen
#   2. zweimal: oeffnen, weiterleiten, speichern (ID_FILE_SAVE), schliessen -
#      in Out liegen danach zwei Entwuerfe mit demselben Bild
#   3. den ersten Entwurf nach Trash, Papierkorb leeren (ID_SPECIAL_EMPTYTRASH)
#   4. nachsehen, ob jede Bilddatei, auf die der verbliebene Entwurf in
#      Out.mbx verweist, noch auf der Platte liegt
#
# Ausgabe: "K5 ERGEBNIS out=<n> (vorher <n>) vollstaendig=<n> probe=<ok|LEER>".
# vollstaendig = Nachrichten in Out.mbx, deren Bilder ALLE noch da sind.
# Gemessen am 24.10.2026: alter Bau vollstaendig=0, Behebung vollstaendig=1.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$NACHRICHTEN = @('Testdaten\e119-data-bild.eml')

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
$pidDatei = Join-Path $voll 'pop-pruefserver.pid'
$md = Join-Path $voll 'Mailverzeichnis'

function PopBeenden {
    if (-not (Test-Path $pidDatei)) { return }
    $alt = [int](Get-Content $pidDatei)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "K5 POP-Pruefserver $alt beendet" }
    Remove-Item $pidDatei -Force
}

# --- -Vorbereiten: Lage frisch anlegen, VOR dem Start ----------------------
# Pfadschranke vor jeder Wirkung (Arbeitsweise/tor-gehoert-zum-schritt.md).
if ($Vorbereiten) {
    if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "K5 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "K5 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    PopBeenden
    foreach ($n in 'In','Out','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } | Remove-Item -Force
    }
    Get-ChildItem -LiteralPath $md -File -Filter 'lmos.dat*' | Remove-Item -Force
    foreach ($d in 'spool','Embedded') { $p = Join-Path $md $d; if (Test-Path $p) { Get-ChildItem -LiteralPath $p -File | Remove-Item -Force } }
    $belegt = Get-NetTCPConnection -LocalPort 11110 -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Host "K5 FEHLER: Port 11110 ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $arg = @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml')
    foreach ($e in $NACHRICHTEN) { $arg += @('--eml', (Join-Path $repo $e)) }
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $p = Start-Process $perl -ArgumentList $arg -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("K5 vorbereitet: POP-Pruefserver PID {0} mit {1} Nachricht" -f $p.Id, $NACHRICHTEN.Count)
    exit 0
}

# Fensterhilfen unveraendert aus tools\messen-bild.ps1 (dort beschrieben).
Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class WinBild {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr nach, int x, int y, int cx, int cy, uint f);
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

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][WinBild]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][WinBild]::GetWindowTextA($h,$s,512); $s.ToString() }
function Oben($h) { $r = New-Object WinBild+R; [void][WinBild]::GetWindowRect($h,[ref]$r); $r.T }

function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [WinBild+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][WinBild]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}

function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [WinBild+EP]{ param($h,$p)
        $o = 0; [void][WinBild]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[WinBild]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[WinBild]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][WinBild]::EnumWindows($cb,[IntPtr]::Zero)
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
        Write-Host ("K5 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][WinBild]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][WinBild]::PostMessageA($d.H, 0x0111, [IntPtr]1, [IntPtr]::Zero) }       # IDOK
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}

function Befehl($h, [int] $id) { [void][WinBild]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }

# Das aktive MDI-Kind und seine Postfachliste (CTocListBox ist ein CListBox).
function Aktiv($mdi) { return [WinBild]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [WinBild]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][WinBild]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][WinBild]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][WinBild]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][WinBild]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
    return [int][WinBild]::SendMessageA($lb, 0x0190, [IntPtr]::Zero, [IntPtr]::Zero)   # LB_GETSELCOUNT
}

# Befehlsnummer des Eintrags $Ziel im Menue "Transfer". Die Nummern der
# Postfaecher vergibt Eudora zur Laufzeit, deshalb wird gelesen, nicht
# festgeschrieben.
function TransferNach($haupt, [string] $Ziel) {
    $m = [WinBild]::GetMenu($haupt)
    for ($i = 0; $i -lt [WinBild]::GetMenuItemCount($m); $i++) {
        $s = New-Object Text.StringBuilder 128
        [void][WinBild]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
        if (($s.ToString() -replace '&','') -ne 'Transfer') { continue }
        $sub = [WinBild]::GetSubMenu($m, $i)
        # Die Postfacheintraege fuellt Eudora erst beim Aufklappen (gemessen
        # 23.10.2026: Mailbox und Transfer hatten vorher 0 Eintraege).
        [void][WinBild]::SendMessageA($haupt, 0x0117, $sub, [IntPtr]$i)   # WM_INITMENUPOPUP
        for ($j = 0; $j -lt [WinBild]::GetMenuItemCount($sub); $j++) {
            $t = New-Object Text.StringBuilder 128
            [void][WinBild]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
            if (($t.ToString() -replace '&','') -eq $Ziel) { return [int][WinBild]::GetMenuItemID($sub, $j) }
        }
    }
    return 0
}

# --- Prozess und Hauptfenster ----------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "K5 FEHLER: keine Eudora aus $voll"; PopBeenden; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'K5 FEHLER: kein Hauptfenster'; PopBeenden; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
$null = Dialoge $pp

# Verweise auf Bilddateien unter Embedded in einer Postfachdatei, als Pfade.
function Verweise([string] $mbx) {
    if (-not (Test-Path -LiteralPath $mbx)) { return @() }
    $t = [Text.Encoding]::GetEncoding(1252).GetString([IO.File]::ReadAllBytes($mbx))
    $muster = '[A-Za-z]:\\[^\r\n"<>|*?]*?\\Embedded\\[^\r\n"<>|*?\\]+?\.(?:png|jpe?g|gif|bmp)'
    return @([regex]::Matches($t, $muster, 'IgnoreCase') | ForEach-Object { $_.Value } | Sort-Object -Unique)
}
function Bilddateien { return @(Get-ChildItem -LiteralPath (Join-Path $md 'Embedded') -File -ErrorAction SilentlyContinue | ForEach-Object { $_.Name }) }

# --- 1. Post abholen ----------------------------------------------------------
Befehl $haupt 32772                               # ID_FILE_CHECKMAIL
$n = 0
for ($t = 0; $t -lt 20 -and $n -lt 1; $t++) {
    Start-Sleep -Seconds 2
    $null = Dialoge $pp
    Befehl $haupt 32792                           # ID_MAILBOX_IN
    $lb = Liste (Aktiv $mdi)
    if ($lb) { $n = Anzahl $lb }
}
Write-Host "K5 abgeholt $n"
if ($n -lt 1) { Write-Host 'K5 FEHLER: nichts abgeholt'; PopBeenden; exit 1 }

# --- 2. zweimal weiterleiten und speichern -------------------------------------
$gespeichert = 0
for ($k = 1; $k -le 2; $k++) {
    Befehl $haupt 32792
    $in = Aktiv $mdi; $lb = Liste $in
    $null = Waehle $lb 0
    [void][WinBild]::PostMessageA($lb, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN
    [void][WinBild]::PostMessageA($lb, 0x0101, [IntPtr]0x0D, [IntPtr]0)
    Start-Sleep -Seconds 4
    $lesen = Aktiv $mdi
    if ($lesen -eq $in) { Write-Host "K5 Nachricht liess sich nicht oeffnen ($k)"; continue }
    Befehl $haupt 32799                           # ID_MESSAGE_FORWARD
    Start-Sleep -Seconds 3
    $verfassen = Aktiv $mdi
    if ($verfassen -eq $lesen) { Write-Host "K5 kein Verfassen-Fenster ($k)"; continue }
    # Eine unveraenderte Weiterleitung laesst sich nicht speichern: MFC
    # verwirft WM_COMMAND fuer einen Befehl, den die Oberflaeche gerade
    # ausgegraut hat (gemessen 24.10.2026: zweimal ID_FILE_SAVE, Out.mbx 0 Byte).
    # Deshalb wie in messen-e125.ps1 einen Empfaenger eintippen - per WM_CHAR an
    # das oberste Eingabefeld des Verfassen-Fensters, kein Tastendruck.
    $felder = Kinder $verfassen | Where-Object { (Kl $_) -match 'RICHEDIT|Edit' -and [WinBild]::IsWindowVisible($_) }
    $an = $felder | Sort-Object { Oben $_ } | Select-Object -First 1
    if ($an) { foreach ($ch in 'k5@127.0.0.1'.ToCharArray()) { [void][WinBild]::PostMessageA($an, 0x0102, [IntPtr][int]$ch, [IntPtr]1); Start-Sleep -Milliseconds 40 } }
    else { Write-Host "K5 kein Eingabefeld im Verfassen-Fenster ($k)" }
    Start-Sleep -Milliseconds 800
    # ID_FILE_SAVE an das Verfassen-Fenster selbst: ans Hauptfenster geschickt
    # blieb Out.mbx am 24.10.2026 leer (0 Byte nach zwei "Speichern").
    Befehl $verfassen 57603                       # ID_FILE_SAVE
    Start-Sleep -Seconds 2
    $null = Dialoge $pp
    $groesse = 0; $o = Join-Path $md 'Out.mbx'; if (Test-Path $o) { $groesse = (Get-Item $o).Length }
    Write-Host ("K5 nach Speichern {0}: Out.mbx {1} Byte" -f $k, $groesse)
    [void][WinBild]::PostMessageA($verfassen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
    Start-Sleep -Milliseconds 1500
    $null = Dialoge $pp '^(No|Nein)$'
    [void][WinBild]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
    Start-Sleep -Milliseconds 1200
    $null = Dialoge $pp
    $gespeichert++
}
$outMbx = Join-Path $md 'Out.mbx'
$vorher = Verweise $outMbx
Write-Host ("K5 gespeichert {0}; Bilddateien in Embedded: {1}" -f $gespeichert, ((Bilddateien) -join ', '))
Write-Host ("K5 Verweise in Out.mbx vor dem Loeschen: {0}" -f ($vorher -join ' | '))

# --- 3. ersten Entwurf nach Trash, Papierkorb leeren ----------------------------
Befehl $haupt 32793                               # ID_MAILBOX_OUT
$out = Aktiv $mdi; $lbOut = Liste $out
$nOutVorher = Anzahl $lbOut
$null = Waehle $lbOut 0
$idTrash = TransferNach $haupt 'Trash'
if (-not $idTrash) { Write-Host 'K5 FEHLER: kein Eintrag Trash im Menue Transfer'; PopBeenden; exit 1 }
Befehl $haupt $idTrash
$null = Dialoge $pp
Befehl $haupt 32819                               # ID_SPECIAL_EMPTYTRASH
Start-Sleep -Seconds 2
$null = Dialoge $pp '^(Yes|Ja|OK|Empty|Leeren)$'
Start-Sleep -Seconds 2

# --- 4. auswerten ----------------------------------------------------------------
Befehl $haupt 32793
$nOut = Anzahl (Liste (Aktiv $mdi))
# Je NACHRICHT auswerten, nicht ueber die ganze Datei: Out.mbx wird nach dem
# Loeschen nicht sofort verdichtet, die Bytes des geloeschten Entwurfs stehen
# noch darin (gemessen 24.10.2026: seine zwei Verweise zaehlten als "fehlend",
# obwohl der verbliebene Entwurf alle Bilder hatte). Gezaehlt wird, wie viele
# Nachrichten ALLE ihre Bilder noch haben. Alter Bau: 0 (die geteilte Datei
# ist fuer beide weg). Behoben: 1 (der verbliebene Entwurf).
$text = ''
if (Test-Path -LiteralPath $outMbx) { $text = [Text.Encoding]::GetEncoding(1252).GetString([IO.File]::ReadAllBytes($outMbx)) }
$muster = '[A-Za-z]:\\[^\r\n"<>|*?]*?\\Embedded\\[^\r\n"<>|*?\\]+?\.(?:png|jpe?g|gif|bmp)'
$vollstaendig = 0; $nr = 0
foreach ($teil in ($text -split '(?m)^From ')) {
    $refs = @([regex]::Matches($teil, $muster, 'IgnoreCase') | ForEach-Object { $_.Value } | Sort-Object -Unique)
    if ($refs.Count -eq 0) { continue }
    $nr++
    $da = @($refs | Where-Object { Test-Path -LiteralPath $_ }).Count
    Write-Host ("K5 NACHRICHT {0}: {1} von {2} Bildern da ({3})" -f $nr, $da, $refs.Count, (($refs | ForEach-Object { Split-Path $_ -Leaf }) -join ', '))
    if ($da -eq $refs.Count) { $vollstaendig++ }
}
Write-Host ("K5 Bilddateien in Embedded danach: {0}" -f ((Bilddateien) -join ', '))
$probe = if ($nOutVorher -ge 2 -and $vorher.Count -ge 1) { 'ok' } else { 'LEER' }
Write-Host ("K5 ERGEBNIS out={0} (vorher {1}) vollstaendig={2} probe={3}" -f $nOut, $nOutVorher, $vollstaendig, $probe)
PopBeenden
