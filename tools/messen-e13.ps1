# messen-e13.ps1 - zeigt Eudora beim Mailabruf einen Fortschritt? (Befund E-13)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, Pruefstand C:\Temp\E13
# (Kopie von C:\Temp\EBILD: Konto auf den POP-Pruefserver 127.0.0.1:11110).
#
# WARUM ES DAS GIBT. E-13 stand seit dem 05.09.2026 als "offen, nicht
# gemessen": die Behebung steckt im Stand, aber niemand hat je nachgesehen,
# ob waehrend eines Abrufs etwas zu sehen ist. Gregor am 30.10.2026: die
# "nie gemessen" muessen alle fertig werden.
#
# WAS ES TUT
#   -Vorbereiten (vor dem Start): Postfaecher leeren, $Anzahl Kopien einer
#     grossen Pruefnachricht (je ~108 KB) unter eigenem Namen ablegen und den
#     POP-Pruefserver (tools\anhang-pruefdaten.pl --pop) damit starten. Viele
#     und grosse Nachrichten, damit der Abruf lange genug dauert, um ueberhaupt
#     etwas sehen zu koennen - mit einer kleinen Nachricht dauerte er 0,02 s.
#   Messen (Eudora laeuft): Post abholen und waehrenddessen alle 25 ms jedes
#     Fenster des Prozesses lesen. Festgehalten wird jede NEUE Beobachtung:
#     Statusleisten-Felder (SB_GETTEXT), Fortschrittsbalken (PBM_GETPOS/
#     PBM_GETRANGE) und sichtbare Fenstertexte, die waehrend des Abrufs
#     auftauchen. Danach: wie viele Nachrichten in In stehen.
#
# Ausgabe: "E13 ERGEBNIS abgeholt=<n> dauer_ms=<n> statustexte=<n>
#           fortschritt_werte=<n> fortschritt_max=<n>" und als Urteil
#          "E13 FORTSCHRITT sichtbar=1 ... vollstaendig=1".
# Ergebnis am 30.10.2026 an 7.2.1.128: 40 Nachrichten in 4,6 s, die
# Aufgabenanzeige zaehlt sichtbar mit (5/385K ... 40/3085K) - sieben
# Zwischenstaende. Die Statusleiste selbst und ein Fortschrittsbalken zeigen
# nichts; der Fortschritt steht im Knopf der Aufgabenanzeige.
# Positivprobe: statustexte=0 UND fortschritt_werte=0 heisst nicht "kein
# Fortschritt", wenn die Messung nichts lesen konnte - deshalb steht die Zahl
# der GELESENEN Statusleisten mit in der Zeile (statusleisten=<n>).
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [int] $Anzahl = 40
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$VORLAGE = Join-Path $repo 'Testdaten\e119-grosses-data-bild.eml'

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
$pidDatei = Join-Path $voll 'pop-pruefserver.pid'

function PopBeenden {
    if (-not (Test-Path $pidDatei)) { return }
    $alt = [int](Get-Content $pidDatei)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "E13 POP-Pruefserver $alt beendet" }
    Remove-Item $pidDatei -Force
}

if ($Vorbereiten) {
    if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E13 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
    $md = Join-Path $voll 'Mailverzeichnis'
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E13 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    PopBeenden
    foreach ($n in 'In','Out','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } | Remove-Item -Force
    }
    Get-ChildItem -LiteralPath $md -File -Filter 'lmos.dat*' | Remove-Item -Force
    foreach ($d in 'spool','Embedded') { $p = Join-Path $md $d; if (Test-Path $p) { Get-ChildItem -LiteralPath $p -File | Remove-Item -Force } }
    $belegt = Get-NetTCPConnection -LocalPort 11110 -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Host "E13 FEHLER: Port 11110 ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    # Eigene Dateinamen je Kopie: der Pruefserver bildet die UIDL aus dem Namen.
    $post = Join-Path $voll 'post'
    if (Test-Path $post) { Get-ChildItem -LiteralPath $post -File | Remove-Item -Force } else { New-Item -ItemType Directory $post | Out-Null }
    $arg = @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml')
    for ($i = 1; $i -le $Anzahl; $i++) {
        $ziel = Join-Path $post ('e13-{0:D3}.eml' -f $i)
        Copy-Item -LiteralPath $VORLAGE -Destination $ziel
        $arg += @('--eml', $ziel)
    }
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $p = Start-Process $perl -ArgumentList $arg -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    Start-Sleep -Seconds 2
    Write-Host ("E13 vorbereitet: POP-Pruefserver PID {0} mit {1} Nachrichten zu je {2} Byte" -f $p.Id, $Anzahl, (Get-Item $VORLAGE).Length)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class WinE13 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint f, uint t, out IntPtr r);
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][WinE13]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][WinE13]::GetWindowTextA($h,$s,512); $s.ToString() }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [WinE13+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][WinE13]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [WinE13+EP]{ param($h,$p)
        $o = 0; [void][WinE13]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add($h)
            foreach ($c in (Kinder $h)) { [void]$r.Add($c) }
        }
        return $true }
    [void][WinE13]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
# Nachricht mit Zeitschranke: haengt Eudora, haengt die Messung nicht mit.
function Frag($h, [uint32] $m, $w, $l) {
    $r = [IntPtr]::Zero
    $ok = [WinE13]::SendMessageTimeoutA($h, $m, [IntPtr]$w, [IntPtr]$l, 2, 200, [ref]$r)   # SMTO_ABORTIFHUNG
    if ($ok -eq [IntPtr]::Zero) { return $null }
    return [int64]$r
}
# Statusleistenfeld lesen: SB_GETTEXTLENGTHA/SB_GETTEXTA brauchen einen Puffer
# im Zielprozess - statt dessen WM_GETTEXT fuer Feld 0 und, falls vorhanden,
# die Zahl der Felder (SB_GETPARTS) als Positivprobe.
function Statusleiste($h) {
    $teile = Frag $h 0x0406 0 0          # SB_GETPARTS
    return [pscustomobject]@{ Teile = $teile; Text = (Tx $h) }
}

$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E13 FEHLER: keine Eudora aus $voll"; PopBeenden; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { (Kl $_) -eq 'EudoraMainWindow' -and [WinE13]::IsWindowVisible($_) } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E13 FEHLER: kein Hauptfenster'; PopBeenden; exit 1 }

# Bestand VOR dem Abruf: welche Fenster und Texte gibt es schon? Nur was
# danach NEU auftaucht oder sich aendert, gehoert zum Abruf.
$vorher = @{}
foreach ($h in (AlleFenster $pp)) { $vorher["$h|" + (Kl $h) + '|' + (Tx $h)] = 1 }
$leisten = @(AlleFenster $pp | Where-Object { (Kl $_) -match 'statusbar' })
Write-Host ("E13 Statusleisten vor dem Abruf: {0}" -f $leisten.Count)
foreach ($l in $leisten) { $s = Statusleiste $l; Write-Host ("E13   Leiste {0} Teile={1} Text=[{2}]" -f $l, $s.Teile, $s.Text) }

$gesehen = @{}
$statustexte = 0; $fwerte = @{}; $fmax = 0; $zaehler = 0
$uhr = [Diagnostics.Stopwatch]::StartNew()
[void][WinE13]::PostMessageA($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)   # ID_FILE_CHECKMAIL
$ruhig = 0; $letzteAenderung = 0
while ($uhr.ElapsedMilliseconds -lt 60000) {
    $neu = $false
    foreach ($h in (AlleFenster $pp)) {
        if (-not [WinE13]::IsWindowVisible($h)) { continue }
        $k = Kl $h; $t = Tx $h
        $schl = "$h|$k|$t"
        if ($k -eq 'msctls_progress32') {
            $pos = Frag $h 0x0408 0 0            # PBM_GETPOS
            $max = Frag $h 0x0407 0 0            # PBM_GETRANGE(FALSE) = Obergrenze
            $schl = "$h|$k|pos=$pos/max=$max"
            if ($pos -ne $null -and -not $fwerte.ContainsKey("$pos")) { $fwerte["$pos"] = 1 }
            if ($max -gt $fmax) { $fmax = $max }
        }
        if ($vorher.ContainsKey($schl) -or $gesehen.ContainsKey($schl)) { continue }
        $gesehen[$schl] = 1; $neu = $true
        if ($k -match 'statusbar' -and $t) { $statustexte++ }
        # Die Aufgabenanzeige in der Statusleiste ist ein Knopf mit dem Text
        # "<Anzahl>&/<Kilobyte>K/<Kilobyte>K" (gemessen 30.10.2026 an 7.2.1.128).
        if ($k -eq 'Button' -and $t -match '^\d+&?/\d+K/\d+K$') { $zaehler++ }
        Write-Host ("E13 +{0,6} ms  {1,-22} {2}" -f $uhr.ElapsedMilliseconds, $k, ($schl -split '\|',3)[2])
    }
    if ($neu) { $letzteAenderung = $uhr.ElapsedMilliseconds }
    # Ende: 5 s lang nichts Neues, nachdem schon etwas kam - oder 60 s.
    if ($gesehen.Count -gt 0 -and ($uhr.ElapsedMilliseconds - $letzteAenderung) -gt 5000) { break }
    Start-Sleep -Milliseconds 25
}
$dauer = $letzteAenderung

# Wie viele Nachrichten sind angekommen? In.toc ist erst nach dem Schliessen
# sicher geschrieben - gezaehlt wird deshalb in In.mbx die Trennzeile.
Start-Sleep -Seconds 2
$inMbx = Join-Path $voll 'Mailverzeichnis\In.mbx'
$abgeholt = 0
if (Test-Path $inMbx) { $abgeholt = @(Select-String -LiteralPath $inMbx -Pattern '^From \?\?\?@\?\?\? ' -ErrorAction SilentlyContinue).Count }
Write-Host ("E13 ERGEBNIS abgeholt={0} dauer_ms={1} statusleisten={2} statustexte={3} fortschritt_werte={4} fortschritt_max={5}" -f
    $abgeholt, $dauer, $leisten.Count, $statustexte, $fwerte.Count, $fmax)
# Urteilszeile fuer tools\pruefstand-faelle.txt: mindestens drei verschiedene
# Zwischenstaende der Aufgabenanzeige, und alles angekommen.
$sichtbar = if ($zaehler -ge 3) { 1 } else { 0 }
Write-Host ("E13 FORTSCHRITT sichtbar={0} zwischenstaende={1} vollstaendig={2}" -f $sichtbar, $zaehler, $(if ($abgeholt -eq $Anzahl) { 1 } else { 0 }))
PopBeenden
