# messen-e77-umbenennen.ps1 - fuehrt Eudora einen umbenannten IMAP-Ordner
# unter demselben Namen wie der Server? (Befund E-77, PRUEFER-49 K1)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, bekommt von dort
# -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem Pfad.
#
# WARUM ES DAS GIBT. E-77 kodiert den Namen beim Umbenennen fuer den Server
# (RENAME "Ablage" "Ablage-&AOQ-"), PRUEFER-49 K1 fand am Quelltext, dass
# Eudora den Ordner danach trotzdem unter dem UNKODIERTEN Namen fuehrt
# (UpdateAfterRename, QCImapMailboxDirector.cpp). Jeder spaetere Zugriff geht
# dann mit einem Namen an den Server, den es dort nicht gibt.
#
# Ablauf, ohne Tastendruck, nur Botschaften an gemessene Fensterhandles:
#   1. IMAP-Pruefserver starten (tools\imap-pruefserver.pl, Port 1143) -
#      er fuehrt eine Ordnerliste, nimmt RENAME an, lehnt rohe 8-Bit-Namen ab
#      und beantwortet SELECT/STATUS auf unbekannte Namen mit NO
#   2. Postfachfenster sichtbar machen, im Baum das Konto pruef-imap
#      aufklappen, "Ablage" waehlen
#   3. TVM_EDITLABEL, WM_SETTEXT "Ablage-<ae>", TVM_ENDEDITLABELNOW - derselbe
#      Weg wie Umbenennen von Hand (CMboxTreeCtrl::OnEndLabelEdit)
#   4. den umbenannten Ordner oeffnen (ID_MBOXTREE_OPEN) - das ist der
#      naechste Zugriff, der den gefuehrten Namen an den Server schickt
#   5. Serverprotokoll und mboxlist.lst lesen
#
# Ausgabe: Zeilen "E77U ...". Erwartet nach der Behebung:
#   E77U ERGEBNIS rename=ok liste=Ablage-&AOQ- unbekannt=0
# Vor der Behebung (gemessen 24.10.2026 an 7.2.0.122+3d7bb9fd):
#   siehe Intern/BEFUNDE.md#e-77.
#
# Vorbereiten (vor dem Start, von pruefstand-lauf.ps1 gerufen):
#   tools\messen-e77-umbenennen.ps1 -Vorbereiten -Pfadfilter C:\Temp\E77U
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    # E-146 (PRUEFER-50 K9), gerufen von tools\messen-e146.ps1: der
    # Pruefserver lehnt RENAME ab. Erwartet: Eudora liest danach die
    # Ordnerliste neu und fuehrt "Ablage" wieder unter seinem alten Namen.
    [switch] $ServerLehntAb
)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
$konto = Join-Path $voll 'Mailverzeichnis\Imap\pruefimap'
$srvlog = Join-Path $voll 'imap-umbenennen.log'

# --- -Vorbereiten: Ordnerliste auf den Ausgangsstand, VOR dem Start ---------
# Die Pfadschranke steht vor jeder Wirkung (Arbeitsweise/tor-gehoert-zum-schritt.md).
if ($Vorbereiten) {
    if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E77U ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
    if (-not (Test-Path $konto)) { Write-Host "E77U FEHLER: kein IMAP-Konto pruefimap in $voll"; exit 1 }
    $bleiben = @('INBOX', 'Ablage', 'Entw&APw-rfe', 'Gel&APY-scht')
    # Ordner aus einem frueheren Lauf (der umbenannte) wegraeumen.
    Get-ChildItem -LiteralPath $konto -Directory | Where-Object { $bleiben -notcontains $_.Name } |
        Remove-Item -Recurse -Force
    foreach ($d in $bleiben) { New-Item -ItemType Directory -Force -Path (Join-Path $konto $d) | Out-Null }
    $zeilen = @('INBOX,INBOX,M,/,0,0,0,0,Y,0', 'Ablage,Ablage,M,/,0,0,0,0,N,0',
                'Entw&APw-rfe,Entw&APw-rfe,M,/,0,0,0,0,N,0', 'Gel&APY-scht,Gel&APY-scht,M,/,0,0,0,0,N,0')
    [IO.File]::WriteAllText((Join-Path $konto 'mboxlist.lst'), (($zeilen -join "`r`n") + "`r`n"))
    [IO.File]::WriteAllText((Join-Path $konto 'actionqueue.dat'), "<IMAPQueueData>`r`n`t<DataFormatVersion>1</DataFormatVersion>`r`n</IMAPQueueData>`r`n")
    Remove-Item -LiteralPath $srvlog -Force -ErrorAction SilentlyContinue
    # Kein IMAP-Fenster beim Start oeffnen: ein offenes "Ablage" waehlt sich vor
    # dem Umbenennen am Server an und verschiebt, was gemessen wird.
    $ini = Join-Path $voll 'Mailverzeichnis\Eudora.ini'
    $z = [IO.File]::ReadAllLines($ini, [Text.Encoding]::GetEncoding(1252))
    [IO.File]::WriteAllLines($ini, [string[]]($z | Where-Object { $_ -notmatch '^OpenWindow[0-9]+=.*Imap.pruefimap' }), [Text.Encoding]::GetEncoding(1252))
    Write-Host "E77U vorbereitet: $konto"
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E77U {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetWindowLongA(IntPtr h, int i);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint fl, uint ms, out IntPtr r);
  [DllImport("kernel32.dll")] public static extern IntPtr OpenProcess(uint a, bool i, uint pid);
  [DllImport("kernel32.dll")] public static extern IntPtr VirtualAllocEx(IntPtr p, IntPtr a, uint n, uint t, uint pr);
  [DllImport("kernel32.dll")] public static extern bool VirtualFreeEx(IntPtr p, IntPtr a, uint n, uint t);
  [DllImport("kernel32.dll")] public static extern bool WriteProcessMemory(IntPtr p, IntPtr a, byte[] b, uint n, out IntPtr w);
  [DllImport("kernel32.dll")] public static extern bool ReadProcessMemory(IntPtr p, IntPtr a, byte[] b, uint n, out IntPtr r);
  [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
}
"@
function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E77U]::GetClassName($h, $s, 256); $s.ToString() }
function Txt($h) { $s = New-Object Text.StringBuilder 256; [void][E77U]::GetWindowTextA($h, $s, 256); $s.ToString() }
function Snd($h, $m, $w, $l, $ms = 5000) { $r = [IntPtr]::Zero; [void][E77U]::SendMessageTimeoutA($h, $m, $w, $l, 0x0002, $ms, [ref]$r); return $r }
function Alle($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E77U+EP]{ param($h, $p); $o = 0; [void][E77U]::GetWindowThreadProcessId($h, [ref]$o)
        if ($o -eq $pp) {
            $cc = [E77U+EP]{ param($k, $q)
                if ([E77U]::IsWindowVisible($k)) { [void]$r.Add([pscustomobject]@{ H = $k; Id = [E77U]::GetDlgCtrlID($k); Klasse = (Kl $k) }) }
                return $true }
            [void][E77U]::EnumChildWindows($h, $cc, [IntPtr]::Zero)
            if ([E77U]::IsWindowVisible($h)) { [void]$r.Add([pscustomobject]@{ H = $h; Id = [E77U]::GetDlgCtrlID($h); Klasse = (Kl $h) }) }
        }
        return $true }
    [void][E77U]::EnumWindows($cb, [IntPtr]::Zero); return $r
}
function Dialoge($pp) {
    foreach ($d in (Alle $pp | Where-Object { $_.Klasse -eq '#32770' -and ([E77U]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) {
        $inhalt = @(); $cc = [E77U+EP]{ param($k, $q); $t = Txt $k; if ($t) { $script:inhalt += $t }; return $true }
        $script:inhalt = @(); [void][E77U]::EnumChildWindows($d.H, $cc, [IntPtr]::Zero)
        Write-Host ("E77U DIALOG '{0}': {1}" -f (Txt $d.H), ($script:inhalt -join ' | '))
    }
}

$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E77U FEHLER: keine Eudora aus $voll"; exit 1 }
$pp = $proz[0].Id
$haupt = Alle $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E77U FEHLER: kein Hauptfenster'; exit 1 }

# 1. Pruefserver
$repo = Split-Path -Parent $PSScriptRoot
$perl = 'C:\Program Files\Git\usr\bin\perl.exe'
$belegt = @(Get-NetTCPConnection -LocalPort 1143 -State Listen -ErrorAction SilentlyContinue)
if ($belegt.Count -gt 0) { Write-Host ('E77U FEHLER: Port 1143 belegt von Prozess ' + (($belegt | ForEach-Object { $_.OwningProcess }) -join ',')); exit 1 }
$srvArgs = @("$repo\tools\imap-pruefserver.pl", '--port', '1143', '--protokoll', $srvlog, '--zeitschranke', '90')
if ($ServerLehntAb) { $srvArgs += '--rename-ablehnen' }
$srv = Start-Process $perl -ArgumentList $srvArgs -WorkingDirectory $repo -WindowStyle Hidden -PassThru
Start-Sleep -Seconds 2

$TVM_EXPAND = 0x1102; $TVM_GETNEXT = 0x110A; $TVM_SELECT = 0x110B; $TVM_GETITEM = 0x110C
$TVM_EDITLABEL = 0x110E; $TVM_ENDEDIT = 0x1116
$hp = [E77U]::OpenProcess(0x0438, $false, [uint32]$pp)   # VM_OPERATION|VM_READ|VM_WRITE|QUERY_INFORMATION
$fern = [E77U]::VirtualAllocEx($hp, [IntPtr]::Zero, 4096, 0x3000, 0x04)
try {
    # Text eines Baumeintrags ueber die Prozessgrenze: TVITEMA in 32-Bit-Form
    # (Eudora ist ein 32-Bit-Prozess) im fremden Speicher, Text dahinter.
    function Text($baum, $item) {
        $tv = New-Object byte[] 40
        [BitConverter]::GetBytes([int]0x11).CopyTo($tv, 0)                          # TVIF_TEXT|TVIF_HANDLE
        [BitConverter]::GetBytes([int]$item.ToInt64()).CopyTo($tv, 4)
        [BitConverter]::GetBytes([int]($fern.ToInt64() + 64)).CopyTo($tv, 16)      # pszText
        [BitConverter]::GetBytes([int]256).CopyTo($tv, 20)
        $w = [IntPtr]::Zero
        [void][E77U]::WriteProcessMemory($hp, $fern, $tv, 40, [ref]$w)
        [void](Snd $baum $TVM_GETITEM ([IntPtr]0) $fern)
        $b = New-Object byte[] 256
        [void][E77U]::ReadProcessMemory($hp, [IntPtr]($fern.ToInt64() + 64), $b, 256, [ref]$w)
        $n = [Array]::IndexOf($b, [byte]0); if ($n -lt 0) { $n = 256 }
        return [Text.Encoding]::GetEncoding(1252).GetString($b, 0, $n)
    }
    function Kinder($baum, $item) {
        $aus = @()
        $k = Snd $baum $TVM_GETNEXT ([IntPtr]4) $item          # TVGN_CHILD
        while ($k -ne [IntPtr]::Zero) { $aus += $k; $k = Snd $baum $TVM_GETNEXT ([IntPtr]1) $k }
        return $aus
    }
    function Suche($baum, $item, [string] $name, [int] $tiefe) {
        if ($tiefe -gt 4) { return [IntPtr]::Zero }
        [void](Snd $baum $TVM_EXPAND ([IntPtr]2) $item)
        foreach ($k in (Kinder $baum $item)) {
            $t = Text $baum $k
            if ($t -eq $name) { return $k }
            $f = Suche $baum $k $name ($tiefe + 1)
            if ($f -ne [IntPtr]::Zero) { return $f }
        }
        return [IntPtr]::Zero
    }

    # Kontenassistent o. ae. wegraeumen, er haelt sonst die Botschaften auf
    foreach ($a in (Alle $pp | Where-Object { $_.Klasse -eq '#32770' -and ([E77U]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) { [void][E77U]::PostMessageA($a.H, 0x0010, [IntPtr]0, [IntPtr]0) }
    Start-Sleep -Seconds 1

    # 2. Postfachbaum
    $baum = Alle $pp | Where-Object { $_.Klasse -eq 'SysTreeView32' -and ($_.Id -eq 1016 -or $_.Id -eq 1042) } | Select-Object -First 1
    if (-not $baum) {
        [void][E77U]::PostMessageA($haupt.H, 0x0111, [IntPtr]32827, [IntPtr]::Zero)   # ID_WINDOW_MAILBOXES
        Start-Sleep -Seconds 3
        $baum = Alle $pp | Where-Object { $_.Klasse -eq 'SysTreeView32' -and ($_.Id -eq 1016 -or $_.Id -eq 1042) } | Select-Object -First 1
    }
    if (-not $baum) {
        Write-Host 'E77U FEHLER: Postfachbaum (IDC_MBOX_TREE) nicht gefunden. Baumansichten im Prozess:'
        $cb = [E77U+EP]{ param($h, $p); $o = 0; [void][E77U]::GetWindowThreadProcessId($h, [ref]$o)
            if ($o -eq $pp) { $cc = [E77U+EP]{ param($k, $q)
                    if ((Kl $k) -eq 'SysTreeView32') { Write-Host ('E77U   Baum id={0} sichtbar={1}' -f [E77U]::GetDlgCtrlID($k), [E77U]::IsWindowVisible($k)) }
                    return $true }; [void][E77U]::EnumChildWindows($h, $cc, [IntPtr]::Zero) }
            return $true }
        [void][E77U]::EnumWindows($cb, [IntPtr]::Zero)
        exit 1
    }
    $b = $baum.H
    $wurzel = Snd $b $TVM_GETNEXT ([IntPtr]0) ([IntPtr]0)      # TVGN_ROOT
    $alle = @(); $w = $wurzel
    while ($w -ne [IntPtr]::Zero) { $alle += $w; $w = Snd $b $TVM_GETNEXT ([IntPtr]1) $w }
    $ziel = [IntPtr]::Zero
    foreach ($w in $alle) { $ziel = Suche $b $w 'Ablage' 0; if ($ziel -ne [IntPtr]::Zero) { break } }
    if ($ziel -eq [IntPtr]::Zero) { Write-Host 'E77U FEHLER: Eintrag "Ablage" im Baum nicht gefunden'; exit 1 }
    Write-Host ('E77U gefunden: "' + (Text $b $ziel) + '"')
    [void](Snd $b $TVM_SELECT ([IntPtr]9) $ziel)                # TVGN_CARET

    # Eudora laesst nur bearbeiten, wenn der Baum den Eingabefokus hat
    # (CMboxTreeCtrl::OnBeginLabelEdit, "GetFocus() == this"). Den Fokus holt
    # sich der Baum beim Klick selbst, im eigenen Thread - also ein Klick per
    # Botschaft auf die Mitte des Eintrags (TVM_GETITEMRECT, Textbereich).
    $rb = New-Object byte[] 16
    [BitConverter]::GetBytes([int]$ziel.ToInt64()).CopyTo($rb, 0)
    $w = [IntPtr]::Zero
    [void][E77U]::WriteProcessMemory($hp, $fern, $rb, 16, [ref]$w)
    [void](Snd $b 0x1104 ([IntPtr]1) $fern)                     # TVM_GETITEMRECT
    [void][E77U]::ReadProcessMemory($hp, $fern, $rb, 16, [ref]$w)
    $x = ([BitConverter]::ToInt32($rb, 0) + [BitConverter]::ToInt32($rb, 8)) / 2
    $y = ([BitConverter]::ToInt32($rb, 4) + [BitConverter]::ToInt32($rb, 12)) / 2
    $lp = ([int]$y -shl 16) -bor [int]$x
    [void][E77U]::PostMessageA($b, 0x0201, [IntPtr]1, [IntPtr]$lp)   # WM_LBUTTONDOWN
    [void][E77U]::PostMessageA($b, 0x0202, [IntPtr]0, [IntPtr]$lp)   # WM_LBUTTONUP
    Start-Sleep -Milliseconds 800
    Write-Host ("E77U Klick auf x={0} y={1}" -f [int]$x, [int]$y)

    # 3. Umbenennen
    $neu = 'Ablage-' + [char]0xE4
    $edit = Snd $b $TVM_EDITLABEL ([IntPtr]0) $ziel
    if ($edit -eq [IntPtr]::Zero) { Write-Host 'E77U FEHLER: TVM_EDITLABEL lieferte kein Eingabefeld'; exit 1 }
    $bytes = [Text.Encoding]::GetEncoding(1252).GetBytes($neu + [char]0)
    $lok = [Runtime.InteropServices.Marshal]::AllocHGlobal($bytes.Length)
    [Runtime.InteropServices.Marshal]::Copy($bytes, 0, $lok, $bytes.Length)
    [void](Snd $edit 0x000C ([IntPtr]0) $lok)                   # WM_SETTEXT (wird vom System uebertragen)
    [Runtime.InteropServices.Marshal]::FreeHGlobal($lok)
    [void](Snd $b $TVM_ENDEDIT ([IntPtr]0) ([IntPtr]0) 20000)   # FALSE: uebernehmen
    Start-Sleep -Seconds 4
    Dialoge $pp
    $nachher = Suche $b $wurzel $neu 0
    if ($nachher -eq [IntPtr]::Zero) { foreach ($w in $alle) { $nachher = Suche $b $w $neu 0; if ($nachher -ne [IntPtr]::Zero) { break } } }
    Write-Host ('E77U Baum nach dem Umbenennen: ' + $(if ($nachher -ne [IntPtr]::Zero) { 'Eintrag "' + (Text $b $nachher) + '" da' } else { 'kein Eintrag "' + $neu + '"' }))

    # 4b. E-146: der Server hat abgelehnt. Fehlermeldung wegklicken, dann
    # warten, bis Eudora die Ordnerliste neu gelesen hat, und den Baum noch
    # einmal ab der Wurzel absuchen - die alten Eintraege sind danach ungueltig.
    if ($ServerLehntAb) {
        foreach ($a in (Alle $pp | Where-Object { $_.Klasse -eq '#32770' -and ([E77U]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) { [void][E77U]::PostMessageA($a.H, 0x0010, [IntPtr]0, [IntPtr]0) }
        Start-Sleep -Seconds 8
        Dialoge $pp
        foreach ($a in (Alle $pp | Where-Object { $_.Klasse -eq '#32770' -and ([E77U]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) { [void][E77U]::PostMessageA($a.H, 0x0010, [IntPtr]0, [IntPtr]0) }
        Start-Sleep -Seconds 2
        $wurzel = Snd $b $TVM_GETNEXT ([IntPtr]0) ([IntPtr]0)
        $alle = @(); $w = $wurzel
        while ($w -ne [IntPtr]::Zero) { $alle += $w; $w = Snd $b $TVM_GETNEXT ([IntPtr]1) $w }
        $script:baumNeu = 'weg'; $script:baumAlt = 'weg'
        foreach ($w in $alle) {
            if ((Suche $b $w $neu 0) -ne [IntPtr]::Zero) { $script:baumNeu = 'da' }
            if ((Suche $b $w 'Ablage' 0) -ne [IntPtr]::Zero) { $script:baumAlt = 'da' }
        }
        Write-Host ('E77U Baum nach der Ablehnung: neu=' + $script:baumNeu + ' alt=' + $script:baumAlt)
        $nachher = [IntPtr]::Zero    # nicht oeffnen: der Name gilt am Server nicht
    }

    # 4. Oeffnen - der naechste Zugriff mit dem gefuehrten Namen
    if ($nachher -ne [IntPtr]::Zero) {
        [void](Snd $b $TVM_SELECT ([IntPtr]9) $nachher)
        [void][E77U]::PostMessageA($b, 0x0111, [IntPtr]32914, [IntPtr]::Zero)   # ID_MBOXTREE_OPEN
        Start-Sleep -Seconds 5
        Dialoge $pp
        foreach ($a in (Alle $pp | Where-Object { $_.Klasse -eq '#32770' -and ([E77U]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) { [void][E77U]::PostMessageA($a.H, 0x0010, [IntPtr]0, [IntPtr]0) }
    }
}
finally {
    [void][E77U]::VirtualFreeEx($hp, $fern, 0, 0x8000)
    [void][E77U]::CloseHandle($hp)
    Start-Sleep -Seconds 1
    if (-not $srv.HasExited) { Stop-Process -Id $srv.Id -Force }
}

# 5. Auswerten - Serverprotokoll und gespeicherte Ordnerliste
$prot = @(); if (Test-Path $srvlog) { $prot = Get-Content -LiteralPath $srvlog }
foreach ($z in ($prot | Where-Object { $_ -match 'RENAME|SELECT|EXAMINE|STATUS|!!' })) { Write-Host ('E77U SERVER ' + $z.Substring([Math]::Min(10, $z.Length))) }
$rename = 'fehlt'
if ($prot | Where-Object { $_ -match '-> \S+ OK RENAME' }) { $rename = 'ok' }
elseif ($prot | Where-Object { $_ -match '-> \S+ (NO|BAD) RENAME' }) { $rename = 'abgelehnt' }
$unbekannt = @($prot | Where-Object { $_ -match '!! (UNBEKANNTES POSTFACH|8-BIT)' }).Count
$liste = '(kein Eintrag)'
$ml = Join-Path $konto 'mboxlist.lst'
if (Test-Path $ml) {
    $roh = [IO.File]::ReadAllBytes($ml)
    $text = [Text.Encoding]::GetEncoding(1252).GetString($roh)
    foreach ($z in ($text -split "`r?`n")) {
        if ($z -match '^Ablage[^,]') {
            $n = $z.Split(',')[0]
            $liste = (($n.ToCharArray() | ForEach-Object { if ([int]$_ -gt 127) { '\x{0:X2}' -f [int]$_ } else { [string]$_ } }) -join '')
        }
    }
    Write-Host ('E77U mboxlist.lst: ' + (($text -split "`r?`n" | Where-Object { $_ }) -join ' ; ').Replace([string][char]0xE4, '\xE4'))
}
Write-Host ("E77U ERGEBNIS rename={0} liste={1} unbekannt={2}" -f $rename, $liste, $unbekannt)
if ($ServerLehntAb) {
    Write-Host ("E146 ERGEBNIS rename={0} baum-neu={1} baum-alt={2} liste={3}" -f $rename, $script:baumNeu, $script:baumAlt, $liste)
}
