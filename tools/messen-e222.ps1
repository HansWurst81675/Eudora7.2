# messen-e222.ps1 - Befund E-222: ein Klick auf das Symbol einer
# S/MIME-signierten Mail meldet "Plugin Error: %3C5335.0002%3E - Plugin no
# longer available", obwohl das Plugin geladen ist.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# Pruefstand C:\Temp\E222 (Kopie von C:\Temp\E178). Nur Botschaften an
# gemessene Fensterhandles, KEIN Tastendruck.
#
# WARUM ES DAS GIBT. Gregor meldete E-222 am 04.11.2026 an 7.2.2.133. Die
# Ursache stand nur am Quelltext: Eudora schreibt fuer eine signierte Mail die
# Zeile 'Run Plugin:"<pfad>.ems <5335.0002>"' in die Nachricht; die Anzeige
# macht daraus <a href="file://<pfad>.ems <5335.0002>" EUDORA=PLUGIN>
# (msgutils.cpp). Beim Klick liefert Trident den Verweis prozentkodiert
# zurueck, CTridentView::DoSpecialAttachment (TridentView.cpp) wandelte nur
# %20 zurueck; aus <5335.0002> wurde %3C5335.0002%3E, und
# CTranslatorManager::InterpretFile (Trnslate.cpp) erkannte keine
# Plugin-Kennung.
#
# WAS GEMESSEN WERDEN KANN. Am Pruefstand fehlt MFC71.DLL, das S/MIME-Plugin
# laedt nicht. Die Meldung kommt deshalb auch nach der Behebung - aber mit
# der Kennung, die Eudora erkannt hat: rot "%3C5335.0002%3E", gruen
# "<5335.0002>". Gemessen ist damit der Weg bis zur Plugin-Kennung; ob das
# Plugin danach den Inhalt zeigt, kann nur Gregors System zeigen.
#
# WIE DER WEG GETROFFEN WIRD
#   * -Vorbereiten legt In.mbx mit einer Klartext-Nachricht an, deren Rumpf
#     die Zeile 'Run Plugin:"<Mailverzeichnis>\attach\e222.ems <5335.0002>"'
#     traegt (Format wie in mime.cpp / msgutils.cpp), und die Datei e222.ems.
#   * Nachricht aus In oeffnen, das Dokument der Anzeige ueber
#     WM_HTML_GETOBJECT holen, den Anker mit dem Attribut EUDORA=PLUGIN
#     suchen, seine Mitte per getBoundingClientRect bestimmen.
#   * WM_LBUTTONDOWN/UP an das Fenster "Internet Explorer_Server" an diesen
#     Punkt (CTridentView::PreTranslateMessage -> HandleLeftMouseClick ->
#     LaunchURL(pt) -> elementFromPoint -> DoSpecialAttachment) - genau der
#     Weg des Mausklicks. Ein click() im Dokument liefe an Eudora vorbei.
#   * Die Fehlermeldung lesen (statische Texte des Dialogs) und mit OK
#     schliessen.
#
# Ausgabe:
#   E222 ANKER href=<...> mitte=<x>,<y>
#   E222 DIALOG [<titel>] <texte>
#   E222 ERGEBNIS kennung=<erkannt|kodiert|anderes|keine> lebt=<0|1>
#     erkannt = die Meldung nennt "<5335.0002>"; kodiert = "%3C5335.0002%3E"
#   E222 PROBE ok - Anker gefunden, Klickpunkt traf ihn (elementFromPoint),
#     ein Dialog mit "Plugin Error" kam.
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'
trap { Write-Host ("E222 AUSNAHME " + $_.Exception.Message + " | " + ($_.InvocationInfo.PositionMessage -replace '\s+', ' ')); Write-Host "E222 ERGEBNIS abgebrochen"; exit 1 }

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch ('^' + [regex]::Escape($(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp' })) + '\\E222[^\\]*$')) { Write-Host "E222 ABGEWIESEN: $voll ist kein Pruefstand C:\Temp\E222*"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$BETREFF = 'Pruefung E-222 signiert'
$PLUGINKENNUNG = '<5335.0002>'

if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E222 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    $attach = Join-Path $md 'attach'
    if (-not (Test-Path -LiteralPath $attach)) { [void](New-Item -ItemType Directory -Path $attach) }
    $ems = Join-Path $attach 'e222.ems'
    # Liegt im Pruefstand eine Datei e222-quelle.ems (ein echter signierter
    # Teil, etwa aus Gregors Bestand - nie ins Repo), wird sie genommen;
    # sonst eine Pruefdatei, an der das Plugin nur ablehnen kann.
    $quelle = Join-Path $voll 'e222-quelle.ems'
    if (Test-Path -LiteralPath $quelle) { Copy-Item -LiteralPath $quelle -Destination $ems -Force; Write-Host 'E222 signierter Teil: e222-quelle.ems (echt)' }
    else { [IO.File]::WriteAllText($ems, "E-222 Pruefdatei, kein echter signierter Teil`r`n", [Text.Encoding]::ASCII); Write-Host 'E222 signierter Teil: Pruefdatei (unecht)' }
    $mail = "From ???@??? Thu Nov 05 10:00:00 2026`r`n" +
            "From: E222 Pruefung <e222@127.0.0.1>`r`n" +
            "To: e222@127.0.0.1`r`n" +
            "Subject: $BETREFF`r`n" +
            "Date: Thu, 05 Nov 2026 10:00:00 +0100`r`n" +
            "Message-ID: <e222-signiert@127.0.0.1>`r`n" +
            "MIME-Version: 1.0`r`n" +
            "Content-Type: text/plain; charset=us-ascii`r`n" +
            "`r`n" +
            "Vor dem Plugin-Symbol.`r`n" +
            "`r`n" +
            "Run Plugin:`"$ems $PLUGINKENNUNG`"`r`n" +
            "`r`n" +
            "Nach dem Plugin-Symbol.`r`n" +
            "`r`n"
    [IO.File]::WriteAllText((Join-Path $md 'In.mbx'), $mail, [Text.Encoding]::ASCII)
    Write-Host ("E222 vorbereitet: {0}, {1}" -f $md, $ems)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E222 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern uint RegisterWindowMessageW(string s);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint f, uint t, out IntPtr r);
  [DllImport("oleacc.dll", PreserveSig=false)] [return: MarshalAs(UnmanagedType.Interface)]
  public static extern object ObjectFromLresult(IntPtr lr, [MarshalAs(UnmanagedType.LPStruct)] Guid iid, IntPtr w);
  public static object Dokument(IntPtr h) {
    uint m = RegisterWindowMessageW("WM_HTML_GETOBJECT");
    IntPtr r;
    SendMessageTimeoutA(h, m, IntPtr.Zero, IntPtr.Zero, 2, 5000, out r);
    if (r == IntPtr.Zero) return null;
    return ObjectFromLresult(r, new Guid("332C4425-26CB-11D0-B483-00C04FD90119"), IntPtr.Zero);  // IHTMLDocument2
  }
  const System.Reflection.BindingFlags GP = System.Reflection.BindingFlags.GetProperty;
  public static object Get(object o, string n) { try { return o.GetType().InvokeMember(n, GP, null, o, null); } catch (Exception e) { throw new Exception("Get " + n + ": " + (e.InnerException ?? e).Message); } }
  public static object Call(object o, string n, object[] a) { try { return o.GetType().InvokeMember(n, System.Reflection.BindingFlags.InvokeMethod, null, o, a); } catch (Exception e) { throw new Exception("Call " + n + ": " + (e.InnerException ?? e).Message); } }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E222]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E222]::GetWindowTextA($h,$s,512); $s.ToString() }
function G($o, [string] $n) { return ,([E222]::Get($o, $n)) }
function C($o, [string] $n) { return ,([E222]::Call($o, $n, [object[]]$args)) }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E222+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E222]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function Oben($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E222+EP]{ param($h,$p)
        $o = 0; [void][E222]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp -and [E222]::IsWindowVisible($h)) { [void]$r.Add($h) }
        return $true }
    [void][E222]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
function Befehl($h, [int] $id) { [void][E222]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E222]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) { return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E222]::IsWindowVisible($_) } | Select-Object -First 1) }
function Anzahl($lb) { return [int][E222]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }
function Waehle($lb, [int] $i) {
    [void][E222]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))
    [void][E222]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)
    [void][E222]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)
}
# Dialoge (#32770): Texte zurueckgeben, mit OK schliessen (sonst Abbrechen)
function DialogeLesen($pp) {
    $alle = @()
    foreach ($d in (Oben $pp | Where-Object { (Kl $_) -eq '#32770' })) {
        $texte = @(); $ok = $null
        foreach ($c in (Kinder $d)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += ($t -replace "`r?`n", ' ') }
            if ($k -eq 'Button' -and $t -match '^OK$') { $ok = $c }
        }
        $zeile = ("[{0}] {1}" -f (Tx $d), ($texte -join ' / '))
        $zeile = $zeile -replace '[\w.+-]+@[\w-]+(\.[\w-]+)+', '<adresse>'   # nichts aus echten Mails ins Protokoll
        Write-Host ("E222 DIALOG " + $zeile)
        $alle += $zeile
        if ($ok) { [void][E222]::PostMessageA($ok, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else     { [void][E222]::PostMessageA($d, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
    }
    # Ohne Komma: der Aufrufer faengt mit @() auf. Mit ",$alle" kam eine
    # Liste in der Liste an, und .Contains pruefte die Liste statt des Texts
    # (gemessen 05.11.2026: "<5335.0002>" stand da, Urteil war "anderes").
    return $alle
}

$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', [StringComparison]::OrdinalIgnoreCase) }
if (@($proz).Count -ne 1) { Write-Host ("E222 FEHLER: {0} Eudora-Prozesse unter {1}, erwartet 1" -f @($proz).Count, $voll); exit 1 }
$pp = $proz[0].Id
$haupt = Oben $pp | Where-Object { (Kl $_) -eq 'EudoraMainWindow' } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E222 FEHLER: kein Hauptfenster'; exit 1 }
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
[void](DialogeLesen $pp)

# --- Welche Plugins sind geladen? ---------------------------------------------
# E-222 hat zwei Ursachen: die Kodierung der Kennung (oben im Kopf) und, bei
# Gregor, dass SMIME.dll gar nicht laedt (Special > Message Plug-ins Settings
# zeigte am 05.11.2026 nur EudoraUnicodeFix). SMIME.dll braucht MFC71.DLL,
# MSVCP71.dll und MSVCR71.dll. Gemessen wird zweierlei: welche dieser Module
# im Prozess stehen (32-Bit-PowerShell, siehe unten) und wie viele
# Eintraege die Plugin-Liste hat (ID_ABOUT_EMS_PLUGINS 32874, Liste
# IDC_PLUGINS 1285, eigengezeichnet - nur die Anzahl ist lesbar).
# tasklist /m sieht von einem 32-Bit-Prozess nur ntdll und wow64*.dll (am
# 05.11.2026 gemessen) - die Module liest deshalb eine 32-Bit-PowerShell.
$ps32 = Join-Path $env:WINDIR 'SysWOW64\WindowsPowerShell\v1.0\powershell.exe'
$mods = @(& $ps32 -NoProfile -Command "(Get-Process -Id $pp).Modules | ForEach-Object { `$_.ModuleName }" 2>$null | ForEach-Object { $_.Trim() })
if (-not ($mods -icontains 'Eudora.exe')) { Write-Host ('E222 MODULE ungelesen (' + $mods.Count + ' Zeilen, Eudora.exe nicht darunter)') }
$geladen = @('SMIME.dll','SpamWatch.dll','SpamHeaders.dll','EudoraUnicodeFix.dll','MFC71.DLL','msvcp71.dll','msvcr71.dll' | ForEach-Object { '{0}={1}' -f $_, [int]($mods -icontains $_) })
Write-Host ('E222 MODULE ' + ($geladen -join ' '))
$vorher = @(Oben $pp)
[void][E222]::PostMessageA($haupt, 0x0111, [IntPtr]32874, [IntPtr]::Zero)   # ID_ABOUT_EMS_PLUGINS
$eintraege = -1
$frist = (Get-Date).AddSeconds(10)
while ((Get-Date) -lt $frist -and $eintraege -lt 0) {
    Start-Sleep -Milliseconds 500
    foreach ($d in (Oben $pp | Where-Object { (Kl $_) -eq '#32770' -and $vorher -notcontains $_ })) {
        $lb = Kinder $d | Where-Object { (Kl $_) -eq 'ListBox' } | Select-Object -First 1
        if ($lb) {
            $eintraege = Anzahl $lb
            [void][E222]::PostMessageA($d, 0x0111, [IntPtr]2, [IntPtr]::Zero)   # IDCANCEL
            Start-Sleep -Milliseconds 800
        }
    }
}
Write-Host ('E222 PLUGINLISTE eintraege=' + $eintraege)

# --- Nachricht oeffnen ------------------------------------------------------
$lesen = $null
for ($v = 0; $v -lt 10 -and -not $lesen; $v++) {
    Befehl $haupt 32792                                   # ID_MAILBOX_IN
    $in = Aktiv $mdi; $lb = Liste $in
    if (-not $lb) { Start-Sleep -Milliseconds 500; continue }
    $n = Anzahl $lb
    for ($i = 0; $i -lt $n -and -not $lesen; $i++) {
        Waehle $lb $i
        [void][E222]::PostMessageA($lb, 0x0100, [IntPtr]0x0D, [IntPtr]0)   # WM_KEYDOWN VK_RETURN an die Liste
        [void][E222]::PostMessageA($lb, 0x0101, [IntPtr]0x0D, [IntPtr]0)
        Start-Sleep -Seconds 3
        $l = Aktiv $mdi
        if ($l -ne $in -and (Tx $l).Contains($BETREFF)) { $lesen = $l }
        elseif ($l -ne $in) { [void][E222]::PostMessageA($l, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); Start-Sleep -Milliseconds 1000 }
    }
}
if (-not $lesen) { Write-Host ("E222 FEHLER: keine Nachricht [{0}] in In" -f $BETREFF); Write-Host 'E222 ERGEBNIS kennung=keine lebt=1'; exit 1 }
Write-Host ("E222 Nachrichtenfenster {0} [{1}]" -f $lesen, (Tx $lesen))
$ie = Kinder $lesen | Where-Object { (Kl $_) -eq 'Internet Explorer_Server' -and [E222]::IsWindowVisible($_) } | Select-Object -First 1
if (-not $ie) { Write-Host 'E222 FEHLER: keine Trident-Anzeige im Nachrichtenfenster'; exit 1 }
$doc = [E222]::Dokument($ie)
if (-not $doc) { Write-Host 'E222 FEHLER: WM_HTML_GETOBJECT lieferte kein Dokument'; exit 1 }

# --- Anker mit EUDORA=PLUGIN --------------------------------------------------
$anker = $null
$as = C (G $doc 'all') 'tags' 'A'
$na = [int](G $as 'length')
for ($i = 0; $i -lt $na -and -not $anker; $i++) {
    $a = C $as 'item' $i
    $wert = C $a 'getAttribute' 'EUDORA' 0
    if ($wert -and ([string]$wert) -ieq 'PLUGIN') { $anker = $a }
}
if (-not $anker) {
    $html = [string](G (G $doc 'body') 'innerHTML')
    Write-Host ('E222 FEHLER: kein Anker mit EUDORA=PLUGIN; Rumpf: ' + ($html -replace "[`r`n]+", ' ').Substring(0, [Math]::Min(400, $html.Length)))
    Write-Host 'E222 ERGEBNIS kennung=keine lebt=1'; exit 1
}
$href = [string](G $anker 'href')
$r = C $anker 'getBoundingClientRect'
$x = [int](([int](G $r 'left') + [int](G $r 'right')) / 2)
$y = [int](([int](G $r 'top') + [int](G $r 'bottom')) / 2)
Write-Host ("E222 ANKER href={0} mitte={1},{2}" -f $href, $x, $y)
$getroffen = C $doc 'elementFromPoint' $x $y
$trifft = 0
$e = $getroffen
while ($e) { if ([string](G $e 'tagName') -eq 'A') { $trifft = [int]([string](C $e 'getAttribute' 'EUDORA' 0) -ieq 'PLUGIN'); break }; $e = G $e 'parentElement' }
Write-Host ("E222 Klickpunkt trifft den Anker: {0}" -f $trifft)

# --- Klick wie die Maus ----------------------------------------------------
$textVorher = ([string](G (G $doc 'body') 'innerText')).Length
$lp = [IntPtr](($y -shl 16) -bor ($x -band 0xFFFF))
[void][E222]::PostMessageA($ie, 0x0201, [IntPtr]1, $lp)    # WM_LBUTTONDOWN MK_LBUTTON
[void][E222]::PostMessageA($ie, 0x0202, [IntPtr]0, $lp)    # WM_LBUTTONUP
$dialoge = @()
$frist = (Get-Date).AddSeconds(20)
while ((Get-Date) -lt $frist) {
    Start-Sleep -Milliseconds 700
    $neu = @(DialogeLesen $pp)
    $dialoge += $neu
    # Nach dem ersten Dialog noch kurz weiterlesen: das Plugin kann einen
    # zweiten zeigen (Zertifikat, Ergebnis der Pruefung).
    if ($dialoge.Count -gt 0 -and $neu.Count -eq 0) { break }
}
# Hat sich die Anzeige veraendert? Ein Plugin, das laeuft, setzt sein
# Ergebnis in die Nachricht (XLateDisplay). Gemessen wird nur die Laenge
# des Texts und ob der Plugin-Anker noch da ist - kein Inhalt, denn die echte
# signierte Mail stammt aus Gregors Bestand.
$textNachher = -1; $ankerNachher = -1
try {
    $doc2 = [E222]::Dokument($ie)
    if ($doc2) {
        $textNachher = ([string](G (G $doc2 'body') 'innerText')).Length
        $ankerNachher = 0
        $as2 = C (G $doc2 'all') 'tags' 'A'
        for ($i = 0; $i -lt [int](G $as2 'length'); $i++) {
            if (([string](C (C $as2 'item' $i) 'getAttribute' 'EUDORA' 0)) -ieq 'PLUGIN') { $ankerNachher++ }
        }
    }
} catch { Write-Host ('E222 Anzeige nach dem Klick nicht lesbar: ' + $_.Exception.Message) }
Write-Host ("E222 ANZEIGE text-vorher={0} text-nachher={1} plugin-anker-nachher={2}" -f $textVorher, $textNachher, $ankerNachher)

$fehler = @($dialoge | Where-Object { $_ -match 'Plugin Error' })
# kodiert  = die Kennung kam prozentkodiert an (E-222 rot)
# erkannt  = Kennung erkannt, Plugin nicht geladen ("no longer available")
# plugin   = Kennung erkannt, das Plugin lief und meldete selbst einen Fehler
# kein-fehler = keine Fehlermeldung von Eudora
$kennung = 'kein-fehler'
if ($fehler.Count -gt 0) {
    if ($fehler[0] -match '%3C5335\.0002%3E') { $kennung = 'kodiert' }
    elseif ($fehler[0].Contains($PLUGINKENNUNG)) { $kennung = 'erkannt' }
    else { $kennung = 'plugin' }
}
[void][E222]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # Nachrichtenfenster schliessen
Start-Sleep -Seconds 1
[void](DialogeLesen $pp)
# Positivprobe: der Klick traf den Anker, und es geschah sichtbar etwas
# (ein Dialog oder eine veraenderte Anzeige). Ohne beides hat der Lauf den
# Weg nicht getroffen, und "kein-fehler" waere nichts wert.
$geschah = ($dialoge.Count -gt 0) -or ($textNachher -ge 0 -and $textNachher -ne $textVorher) -or ($ankerNachher -eq 0)
if ($trifft -eq 1 -and $geschah) { Write-Host 'E222 PROBE ok' }
else { Write-Host ("E222 PROBE FEHL: trifft={0} dialoge={1} anzeige-veraendert={2}" -f $trifft, $dialoge.Count, [int]$geschah) }
Write-Host ("E222 ERGEBNIS kennung={0} lebt={1}" -f $kennung, [int](Lebt $pp))
exit 0
