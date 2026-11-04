# messen-e188.ps1 - Verschieben zwischen ZWEI IMAP-Konten und von IMAP nach
# lokal: trifft Eudora im Ziel eine FREMDE Zusammenfassung unter der alten
# Nummer, und kann dabei auf dem SERVER etwas verloren gehen? (Befund E-188)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, bekommt von dort
# -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem Pfad.
# Huellen fuer die Faelle in tools\pruefstand-faelle.txt: messen-e188k.ps1,
# messen-e188a.ps1, messen-e188u.ps1, messen-e188l.ps1, messen-e188f.ps1.
#
# WARUM ES DAS GIBT. PRUEFER-75 K1 fand am Quelltext zwei Stellen mit
# derselben Suche wie E-184 - die Vorab-Kopie im Ziel unter der ALTEN UID,
# GetSummaryFromUID liefert den ersten Treffer:
#   EuImap/src/ImapToc.cpp ImapCopyMsgBetweenAccounts (zwischen Konten)
#   EuImap/src/ImapToc.cpp ImapCopyMsgFromImapToLocal (nicht ganz geladene
#                          IMAP-Mail nach lokal)
# Gregor am 03.11.2026: "zuerst nur messen, ob auf dem Server etwas verloren
# gehen kann; wenn nicht, nach hinten". Deshalb misst dieses Skript neben
# der Anzeige den SERVERBESTAND, am Protokoll des Pruefservers (--zustand),
# nicht an der Anzeige (Arbeitsweise/anzeige-ist-kein-zustand.md).
#
# WEGE (-Weg):
#   konten   Konto A (Port 1143, INBOX: eine Mail UID 1) -> Konto B (Port
#            1144, Postfach "Ziel": fremde Mail UID 1). Erst "Ziel" oeffnen
#            (Eudora kennt dann die fremde), dann INBOX, verschieben ueber
#            Transfer -> Ziel. B meldet APPENDUID.
#   append   wie konten, aber B lehnt das APPEND ab (--append-ablehnen):
#            darf A die Mail trotzdem loeschen?
#   ohneuid  wie konten, B meldet keine APPENDUID (Server ohne UIDPLUS).
#   loeschen wie konten, danach im Zielfenster JEDEN Eintrag mit dem Betreff der
#            verschobenen Mail loeschen (ID_MESSAGE_DELETE) - so, wie ein
#            Anwender die verschobene Mail samt ihren scheinbaren Doppeln
#            wegraeumt. Wie viele es sind, steht vorher in Ziel.toc (N); geloescht
#            wird N-mal die LETZTE Zeile. Trifft das \Deleted auf dem Server die
#            FREMDE Mail (UID 1 in "Ziel")? Bis 7.2.2.132 trugen alle drei
#            Eintraege den Betreff der verschobenen Mail (die fremde war
#            ueberschrieben), also traf es sie. Bis 04.11.2026 loeschte der Fall
#            fest die ersten zwei Zeilen; nach der Behebung von E-188 gab es keine
#            Doppel mehr, und er loeschte die fremde Mail absichtlich mit.
#            Stimmt die Anzeigereihenfolge nicht mit Ziel.toc, wird der Fall rot.
#   kontentext wie konten, aber A liefert den Text der Mail nicht
#            (--fetch-text-scheitert; die Mail ist nur als Kopf geladen,
#            IMAPMinDownload=1): Eudora kann nicht hochladen - und loescht?
#            So lief der erste Lauf am 03.11.2026 ungewollt (der Pruefserver
#            konnte noch kein BODYSTRUCTURE); seither beide Server mit
#            --bodystructure, und dieser Weg stellt den Fall gezielt her.
#   lokal    nur Konto A, INBOX UID 1 und "Ablage" mit fremder UID 1, beide
#            nur als Kopf geladen (IMAPMinDownload=1). Erst Ablage UID 1, dann
#            INBOX UID 1 ins lokale Postfach "Lokal" - die zweite Suche unter
#            UID 1 findet die erste Mail.
#   lokaleins Gegenprobe zu lokal und fetch: nur die INBOX-Mail ins leere
#            "Lokal", ohne fremde Mail mit gleicher UID, Text kommt.
#   fetch    wie lokal mit nur der INBOX-Mail, der Server verweigert den Text
#            (--fetch-text-scheitert): wird die Mail auf dem Server trotzdem
#            geloescht, obwohl lokal nur der Kopf ankam?
#
# Ausgabe: Zeilen "E188 ...", am Ende
#   E188 ERGEBNIS weg=<w> anzeige=<richtig|FALSCH|-> ... verloren=<n> fremd-geloescht=<n>
# verloren = Message-IDs, die zu Beginn auf einem der Server lagen und am Ende
# auf KEINEM ohne \Deleted stehen; fremd-geloescht = \Deleted auf einer Mail,
# die niemand verschieben wollte. Beides liest das Skript aus dem letzten
# "ZUSTAND"-Block der Serverprotokolle.
#
# Vorbereiten (vor dem Start, von pruefstand-lauf.ps1 gerufen):
#   tools\messen-e188.ps1 -Vorbereiten -Pfadfilter C:\Temp\E188
# legt das zweite Konto (Persona pruef-imap2, Port 1144, AccountDir
# pruefimap2) und das lokale Postfach "Lokal" an und leert die
# Zwischenspeicher - es schreibt nur unter C:\Temp.
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [ValidateSet('konten', 'append', 'ohneuid', 'kontentext', 'loeschen', 'lokal', 'lokaleins', 'fetch')] [string] $Weg = 'konten',
    [int] $Warten = 15
)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
$md = Join-Path $voll 'Mailverzeichnis'
$kontoA = Join-Path $md 'Imap\pruefimap'
$kontoB = Join-Path $md 'Imap\pruefimap2'
# Je Weg eigene Protokolle: ein Lauf ueberschreibt nur seine eigenen.
$logA = Join-Path $voll ('imap-e188-' + $Weg + '-a.log')
$logB = Join-Path $voll ('imap-e188-' + $Weg + '-b.log')
$cp = [Text.Encoding]::GetEncoding(1252)

function KontoLeeren([string] $konto, [string[]] $bleiben) {
    New-Item -ItemType Directory -Force -Path $konto | Out-Null
    Get-ChildItem -LiteralPath $konto -Directory | Where-Object { $bleiben -notcontains $_.Name } | Remove-Item -Recurse -Force
    foreach ($d in $bleiben) {
        $p = Join-Path $konto $d
        if (Test-Path $p) { Get-ChildItem -LiteralPath $p -Force | Remove-Item -Recurse -Force }
        New-Item -ItemType Directory -Force -Path $p | Out-Null
    }
    $zeilen = @()
    foreach ($d in $bleiben) { $sel = 'N'; if ($d -eq 'INBOX') { $sel = 'Y' }; $zeilen += "$d,$d,M,/,0,0,0,0,$sel,0" }
    [IO.File]::WriteAllText((Join-Path $konto 'mboxlist.lst'), (($zeilen -join "`r`n") + "`r`n"))
    [IO.File]::WriteAllText((Join-Path $konto 'actionqueue.dat'), "<IMAPQueueData>`r`n`t<DataFormatVersion>1</DataFormatVersion>`r`n</IMAPQueueData>`r`n")
}

# --- -Vorbereiten: Ausgangslage, VOR dem Start ------------------------------
if ($Vorbereiten) {
    if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E188 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
    if (-not (Test-Path $kontoA)) { Write-Host "E188 FEHLER: kein IMAP-Konto pruefimap in $voll"; exit 1 }
    KontoLeeren $kontoA @('INBOX', 'Ablage', 'Entw&APw-rfe', 'Gel&APY-scht')
    KontoLeeren $kontoB @('INBOX', 'Ziel', 'Entw&APw-rfe', 'Gel&APY-scht')
    # Lokales Postfach "Lokal", leer.
    $desc = Join-Path $md 'descmap.pce'
    $dz = @([IO.File]::ReadAllLines($desc, $cp) | Where-Object { $_ -notmatch '^Lokal,' })
    [IO.File]::WriteAllLines($desc, [string[]]($dz + 'Lokal,Lokal.mbx,M,N'), $cp)
    [IO.File]::WriteAllBytes((Join-Path $md 'Lokal.mbx'), [byte[]]@())
    Remove-Item -LiteralPath (Join-Path $md 'Lokal.toc') -Force -ErrorAction SilentlyContinue
    # Zweite Persona: Abschnitt der ersten kopiert, Port/Anmeldung/Verzeichnis eigen.
    $ini = Join-Path $md 'Eudora.ini'
    $z = [IO.File]::ReadAllLines($ini, $cp)
    $aus = New-Object System.Collections.ArrayList
    $abschnitt = ''; $erste = New-Object System.Collections.ArrayList
    foreach ($l in $z) {
        if ($l -match '^\[(.+)\]$') { $abschnitt = $Matches[1] }
        if ($abschnitt -eq 'Persona-pruef-imap2') { continue }
        if ($l -match '^OpenWindow[0-9]+=.*Imap.pruefimap') { continue }
        if ($abschnitt -eq 'Personalities' -and $l -match '^Persona1=') { continue }
        [void]$aus.Add($l)
        if ($abschnitt -eq 'Persona-pruef-imap' -and $l -notmatch '^\[') { [void]$erste.Add($l) }
        if ($abschnitt -eq 'Personalities' -and $l -match '^Persona0=') { [void]$aus.Add('Persona1=Persona-pruef-imap2') }
    }
    if ($erste.Count -eq 0) { Write-Host 'E188 FEHLER: kein Abschnitt [Persona-pruef-imap]'; exit 1 }
    [void]$aus.Add('[Persona-pruef-imap2]')
    foreach ($l in $erste) {
        if ($l -match '^IMAPPort=') { $l = 'IMAPPort=1144' }
        elseif ($l -match '^LoginName=') { $l = 'LoginName=pruef2' }
        elseif ($l -match '^POPAccount=') { $l = 'POPAccount=pruef2@127.0.0.1' }
        elseif ($l -match '^ReturnAddress=') { $l = 'ReturnAddress=pruef2@127.0.0.1' }
        elseif ($l -match '^RealName=') { $l = 'RealName=Pruefstand IMAP zwei' }
        elseif ($l -match '^AccountDir=') { $l = 'AccountDir=pruefimap2' }
        if ($l -ne '') { [void]$aus.Add($l) }
    }
    [IO.File]::WriteAllLines($ini, [string[]]$aus, $cp)
    Write-Host "E188 vorbereitet: $kontoA, $kontoB, Lokal.mbx"
    exit 0
}

# --- TOC lesen (CSummary::Write, summary.cpp: 218 Byte je Datensatz) ---------
function TocLesen([string] $pfad) {
    $aus = @()
    if (-not (Test-Path -LiteralPath $pfad)) { return ,$aus }
    $b = [IO.File]::ReadAllBytes($pfad)
    if ($b.Length -eq 104) { return ,$aus }
    for ($n = 1; $n -le 500; $n++) {
        $kopf = $b.Length - $n * 218
        if ($kopf -lt 2) { break }
        if ([BitConverter]::ToUInt16($b, $kopf - 2) -ne $n) { continue }
        for ($i = 0; $i -lt $n; $i++) {
            $o = $kopf + $i * 218
            $str = { param($von, $len) $e = [Array]::IndexOf($b, [byte]0, $von, $len); if ($e -lt 0) { $e = $von + $len }; $cp.GetString($b, $von, $e - $von) }
            $aus += [pscustomobject]@{
                Uid = [BitConverter]::ToUInt32($b, $o + 188)
                Betreff = (& $str ($o + 114) 64)
                Offset = [BitConverter]::ToInt32($b, $o)
                Laenge = [BitConverter]::ToInt32($b, $o + 4)
            }
        }
        return ,$aus
    }
    Write-Host "E188 WARNUNG: $pfad hat kein erkennbares TOC-Format ($($b.Length) Byte)"
    return ,$aus
}
# Text eines Eintrags aus der .mbx (Offset/Laenge aus der TOC).
function MbxText([string] $mbx, $e) {
    if (-not (Test-Path -LiteralPath $mbx)) { return '' }
    $b = [IO.File]::ReadAllBytes($mbx)
    if ($e.Offset -lt 0 -or $e.Laenge -le 0 -or $e.Offset + $e.Laenge -gt $b.Length) { return '' }
    return $cp.GetString($b, $e.Offset, $e.Laenge)
}
# Letzter ZUSTAND-Block eines Serverprotokolls (und der erste).
function Zustand([string] $log, [switch] $Erster) {
    $aus = @(); $block = @()
    if (-not (Test-Path -LiteralPath $log)) { return ,$aus }
    foreach ($z in (Get-Content -LiteralPath $log)) {
        if ($z -match 'ZUSTAND ENDE') { $aus = $block; $block = @(); if ($Erster) { break }; continue }
        if ($z -match 'ZUSTAND (\S+) uid=(\d+) del=(\d) weg=(\d) rumpf=(\d+) mid=(\S+) betreff=(.*)$') {
            $block += [pscustomobject]@{ Ordner = $Matches[1]; Uid = [int]$Matches[2]; Del = [int]$Matches[3]; Weg = [int]$Matches[4]; Rumpf = [int]$Matches[5]; Mid = $Matches[6]; Betreff = $Matches[7] }
        }
    }
    return ,$aus
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E188 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetWindowLongA(IntPtr h, int i);
  [DllImport("user32.dll")] public static extern IntPtr GetParent(IntPtr h);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint fl, uint ms, out IntPtr r);
  [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetMenuItemCount(IntPtr m);
  [DllImport("user32.dll")] public static extern uint GetMenuItemID(IntPtr m, int i);
  [DllImport("user32.dll")] public static extern IntPtr GetSubMenu(IntPtr m, int i);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetMenuStringA(IntPtr m, uint id, StringBuilder s, int n, uint f);
  [DllImport("kernel32.dll")] public static extern IntPtr OpenProcess(uint a, bool i, uint pid);
  [DllImport("kernel32.dll")] public static extern IntPtr VirtualAllocEx(IntPtr p, IntPtr a, uint n, uint t, uint pr);
  [DllImport("kernel32.dll")] public static extern bool VirtualFreeEx(IntPtr p, IntPtr a, uint n, uint t);
  [DllImport("kernel32.dll")] public static extern bool WriteProcessMemory(IntPtr p, IntPtr a, byte[] b, uint n, out IntPtr w);
  [DllImport("kernel32.dll")] public static extern bool ReadProcessMemory(IntPtr p, IntPtr a, byte[] b, uint n, out IntPtr r);
  [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
}
"@
function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E188]::GetClassName($h, $s, 256); $s.ToString() }
function Txt($h) { $s = New-Object Text.StringBuilder 256; [void][E188]::GetWindowTextA($h, $s, 256); $s.ToString() }
function Snd($h, $m, $w, $l, $ms = 5000) { $r = [IntPtr]::Zero; [void][E188]::SendMessageTimeoutA($h, $m, $w, $l, 0x0002, $ms, [ref]$r); return $r }
function Alle($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E188+EP]{ param($h, $p); $o = 0; [void][E188]::GetWindowThreadProcessId($h, [ref]$o)
        if ($o -eq $pp) {
            $cc = [E188+EP]{ param($k, $q)
                [void]$r.Add([pscustomobject]@{ H = $k; Id = [E188]::GetDlgCtrlID($k); Klasse = (Kl $k); Vis = [E188]::IsWindowVisible($k) })
                return $true }
            [void][E188]::EnumChildWindows($h, $cc, [IntPtr]::Zero)
            [void]$r.Add([pscustomobject]@{ H = $h; Id = [E188]::GetDlgCtrlID($h); Klasse = (Kl $h); Vis = [E188]::IsWindowVisible($h) })
        }
        return $true }
    [void][E188]::EnumWindows($cb, [IntPtr]::Zero); return $r
}
$script:dialoge = @()
$script:loeschenUngemessen = $false
$script:geloescht = 0
$script:geloeschtAlle = $false
function Dialoge($pp) {
    foreach ($d in (Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' -and ([E188]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) {
        $script:inhalt = @(); $cc = [E188+EP]{ param($k, $q); $t = Txt $k; if ($t) { $script:inhalt += $t }; return $true }
        [void][E188]::EnumChildWindows($d.H, $cc, [IntPtr]::Zero)
        $zeile = ("'{0}': {1}" -f (Txt $d.H), ($script:inhalt -join ' | '))
        Write-Host ('E188 DIALOG ' + $zeile)
        $script:dialoge += $zeile
        [void][E188]::PostMessageA($d.H, 0x0010, [IntPtr]0, [IntPtr]0)
    }
}

$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E188 FEHLER: keine Eudora aus $voll"; exit 1 }
# Die ganze Ausgabe auch nach <Pruefstand>\messen-e188-<weg>.txt - pruefstand-lauf.ps1
# behaelt nur die Ergebniszeile.
try { Start-Transcript -LiteralPath (Join-Path $voll ('messen-e188-' + $Weg + '.txt')) -Force | Out-Null } catch { }
$pp = $proz[0].Id
$haupt = Alle $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E188 FEHLER: kein Hauptfenster'; exit 1 }
$mdi = Alle $pp | Where-Object { $_.Klasse -eq 'MDIClient' } | Select-Object -First 1

# 1. Pruefserver - A immer, B nur fuer die Wege zwischen Konten.
$repo = Split-Path -Parent $PSScriptRoot
$perl = 'C:\Program Files\Git\usr\bin\perl.exe'
$zwei = @('konten', 'append', 'ohneuid', 'kontentext', 'loeschen') -contains $Weg
$ports = @(1143); if ($zwei) { $ports += 1144 }
foreach ($p in $ports) {
    $belegt = @(Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue)
    if ($belegt.Count -gt 0) { Write-Host ("E188 FEHLER: Port $p belegt von Prozess " + (($belegt | ForEach-Object { $_.OwningProcess }) -join ',')); exit 1 }
}
$zs = [string](120 + 8 * $Warten)
$argsA = @("$repo\tools\imap-pruefserver.pl", '--port', '1143', '--protokoll', $logA, '--zeitschranke', $zs, '--zustand', '--bodystructure', '--nachrichten', '1')
if ($Weg -eq 'lokal') { $argsA += @('--fremde-uid', '1') }
if ($Weg -eq 'fetch' -or $Weg -eq 'kontentext') { $argsA += '--fetch-text-scheitert' }
$srvA = Start-Process $perl -ArgumentList $argsA -WorkingDirectory $repo -WindowStyle Hidden -PassThru
$srvB = $null
if ($zwei) {
    $argsB = @("$repo\tools\imap-pruefserver.pl", '--port', '1144', '--protokoll', $logB, '--zeitschranke', $zs, '--zustand', '--bodystructure',
               '--nachrichten', '0', '--ablage-name', 'Ziel', '--fremde-uid', '1')
    if ($Weg -eq 'append')  { $argsB += '--append-ablehnen' }
    if ($Weg -eq 'ohneuid') { $argsB += '--ohne-appenduid' }
    $srvB = Start-Process $perl -ArgumentList $argsB -WorkingDirectory $repo -WindowStyle Hidden -PassThru
}
Start-Sleep -Seconds 2
$startA = Zustand $logA -Erster; $startB = @(); if ($zwei) { $startB = Zustand $logB -Erster }
Write-Host ('E188 SERVER-VORHER A: ' + (($startA | ForEach-Object { "$($_.Ordner)/$($_.Uid) del=$($_.Del) $($_.Mid)" }) -join ' ; '))
if ($zwei) { Write-Host ('E188 SERVER-VORHER B: ' + (($startB | ForEach-Object { "$($_.Ordner)/$($_.Uid) del=$($_.Del) $($_.Mid)" }) -join ' ; ')) }

$TVM_EXPAND = 0x1102; $TVM_GETNEXT = 0x110A; $TVM_SELECT = 0x110B; $TVM_GETITEM = 0x110C
$hp = [E188]::OpenProcess(0x0438, $false, [uint32]$pp)
$fern = [E188]::VirtualAllocEx($hp, [IntPtr]::Zero, 4096, 0x3000, 0x04)
$vorTransfer = @{}
try {
    function Text($baum, $item) {
        $tv = New-Object byte[] 40
        [BitConverter]::GetBytes([int]0x11).CopyTo($tv, 0)
        [BitConverter]::GetBytes([int]$item.ToInt64()).CopyTo($tv, 4)
        [BitConverter]::GetBytes([int]($fern.ToInt64() + 64)).CopyTo($tv, 16)
        [BitConverter]::GetBytes([int]256).CopyTo($tv, 20)
        $w = [IntPtr]::Zero
        [void][E188]::WriteProcessMemory($hp, $fern, $tv, 40, [ref]$w)
        [void](Snd $baum $TVM_GETITEM ([IntPtr]0) $fern)
        $b = New-Object byte[] 256
        [void][E188]::ReadProcessMemory($hp, [IntPtr]($fern.ToInt64() + 64), $b, 256, [ref]$w)
        $n = [Array]::IndexOf($b, [byte]0); if ($n -lt 0) { $n = 256 }
        return $cp.GetString($b, 0, $n)
    }
    function Kinder($baum, $item) {
        $aus = @()
        $k = Snd $baum $TVM_GETNEXT ([IntPtr]4) $item
        while ($k -ne [IntPtr]::Zero) { $aus += $k; $k = Snd $baum $TVM_GETNEXT ([IntPtr]1) $k }
        return $aus
    }
    function AlleKnoten($baum, $item, [int] $tiefe) {
        $aus = @()
        if ($tiefe -gt 4) { return $aus }
        [void](Snd $baum $TVM_EXPAND ([IntPtr]2) $item)
        foreach ($k in (Kinder $baum $item)) { $aus += $k; $aus += AlleKnoten $baum $k ($tiefe + 1) }
        return $aus
    }
    function MenueSuche($sub, [string] $Ziel, [int] $tiefe) {
        if ($tiefe -gt 3) { return 0 }
        [void](Snd $haupt.H 0x0117 $sub ([IntPtr]0))
        for ($j = 0; $j -lt [E188]::GetMenuItemCount($sub); $j++) {
            $t = New-Object Text.StringBuilder 128
            [void][E188]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
            $name = $t.ToString() -replace '&', ''
            $unter = [E188]::GetSubMenu($sub, $j)
            if ($unter -ne [IntPtr]::Zero) { $id = MenueSuche $unter $Ziel ($tiefe + 1); if ($id) { return $id } }
            elseif ($name -eq $Ziel) { return [int][E188]::GetMenuItemID($sub, $j) }
        }
        return 0
    }
    function TransferNach([string] $Ziel) {
        $m = [E188]::GetMenu($haupt.H)
        for ($i = 0; $i -lt [E188]::GetMenuItemCount($m); $i++) {
            $s = New-Object Text.StringBuilder 128
            [void][E188]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
            if (($s.ToString() -replace '&', '') -ne 'Transfer') { continue }
            return (MenueSuche ([E188]::GetSubMenu($m, $i)) $Ziel 0)
        }
        return 0
    }
    function MdiKinder() { return @(Alle $pp | Where-Object { $_.Vis -and $mdi -and [E188]::GetParent($_.H) -eq $mdi.H }) }
    function AlleSchliessen() {
        foreach ($k in (MdiKinder)) { Write-Host ('E188 schliesse "' + (Txt $k.H) + '"'); [void][E188]::PostMessageA($k.H, 0x0010, [IntPtr]0, [IntPtr]0) }
        Start-Sleep -Seconds 4
        Dialoge $pp
    }

    Dialoge $pp
    Start-Sleep -Seconds 1
    $baum = Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq 'SysTreeView32' -and ($_.Id -eq 1016 -or $_.Id -eq 1042) } | Select-Object -First 1
    if (-not $baum) {
        [void][E188]::PostMessageA($haupt.H, 0x0111, [IntPtr]32827, [IntPtr]::Zero)   # ID_WINDOW_MAILBOXES
        Start-Sleep -Seconds 3
        $baum = Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq 'SysTreeView32' -and ($_.Id -eq 1016 -or $_.Id -eq 1042) } | Select-Object -First 1
    }
    if (-not $baum) { Write-Host 'E188 FEHLER: Postfachbaum nicht gefunden'; exit 1 }

    # Kontoknoten: Eltern eines Ordners mit dem Kennnamen, nicht "Recent".
    $knoten = @(); $w = Snd $baum.H $TVM_GETNEXT ([IntPtr]0) ([IntPtr]0)
    while ($w -ne [IntPtr]::Zero) { $knoten += $w; $knoten += AlleKnoten $baum.H $w 0; $w = Snd $baum.H $TVM_GETNEXT ([IntPtr]1) $w }
    function KontoVon([string] $kenn) {
        foreach ($k in $knoten) {
            if ((Text $baum.H $k) -ne $kenn) { continue }
            $e = Snd $baum.H $TVM_GETNEXT ([IntPtr]3) $k
            if ($e -ne [IntPtr]::Zero -and (Text $baum.H $e) -ne 'Recent') { return $e }
        }
        return [IntPtr]::Zero
    }
    $kA = KontoVon 'Ablage'
    if ($kA -eq [IntPtr]::Zero) { Write-Host 'E188 FEHLER: Konto A (Ordner "Ablage") nicht im Baum'; exit 1 }
    Write-Host ('E188 Konto A "' + (Text $baum.H $kA) + '"')
    $kB = [IntPtr]::Zero
    if ($zwei) {
        $kB = KontoVon 'Ziel'
        if ($kB -eq [IntPtr]::Zero) {
            # Ordnerliste von B noch nicht gelesen: den Kontoknoten aufklappen.
            foreach ($k in $knoten) { if ((Text $baum.H $k) -like '*imap2*') { [void](Snd $baum.H $TVM_EXPAND ([IntPtr]2) $k) } }
            Start-Sleep -Seconds $Warten
            $knoten = @(); $w = Snd $baum.H $TVM_GETNEXT ([IntPtr]0) ([IntPtr]0)
            while ($w -ne [IntPtr]::Zero) { $knoten += $w; $knoten += AlleKnoten $baum.H $w 0; $w = Snd $baum.H $TVM_GETNEXT ([IntPtr]1) $w }
            $kB = KontoVon 'Ziel'
        }
        if ($kB -eq [IntPtr]::Zero) { Write-Host 'E188 FEHLER: Konto B (Ordner "Ziel") nicht im Baum'; exit 1 }
        Write-Host ('E188 Konto B "' + (Text $baum.H $kB) + '"')
    }
    function Oeffnen($konto, [string[]] $wer) {
        $z = @(Kinder $baum.H $konto | Where-Object { $wer -contains (Text $baum.H $_) }) | Select-Object -First 1
        if (-not $z) { return $false }
        Write-Host ('E188 oeffne "' + (Text $baum.H $z) + '" unter "' + (Text $baum.H $konto) + '"')
        [void](Snd $baum.H $TVM_SELECT ([IntPtr]9) $z)
        [void][E188]::PostMessageA($baum.H, 0x0111, [IntPtr]32914, [IntPtr]::Zero)      # ID_MBOXTREE_OPEN
        Start-Sleep -Seconds $Warten
        Dialoge $pp
        return $true
    }
    function LokalOeffnen() {
        foreach ($k in $knoten) {
            if ((Text $baum.H $k) -ne 'Lokal') { continue }
            [void](Snd $baum.H $TVM_SELECT ([IntPtr]9) $k)
            [void][E188]::PostMessageA($baum.H, 0x0111, [IntPtr]32914, [IntPtr]::Zero)
            Start-Sleep -Seconds 4; Dialoge $pp; return $true
        }
        return $false
    }
    # Aktives Postfachfenster: einzige Zeile waehlen und nach $ziel verschieben.
    function ZeileVerschieben([string] $ziel, [string] $was) {
        $aktiv = Snd $mdi.H 0x0229 ([IntPtr]::Zero) ([IntPtr]::Zero)                  # WM_MDIGETACTIVE
        Write-Host ('E188 aktives Fenster: "' + (Txt $aktiv) + '"')
        $script:lb = [IntPtr]::Zero
        $cc = [E188+EP]{ param($k, $q); if ($script:lb -eq [IntPtr]::Zero -and (Kl $k) -eq 'ListBox' -and [E188]::IsWindowVisible($k)) { $script:lb = $k }; return $true }
        [void][E188]::EnumChildWindows($aktiv, $cc, [IntPtr]::Zero)
        if ($script:lb -eq [IntPtr]::Zero) { Write-Host "E188 FEHLER: keine Liste im Fenster ($was)"; return $false }
        $anzahl = [int](Snd $script:lb 0x018B ([IntPtr]0) ([IntPtr]0))                 # LB_GETCOUNT
        Write-Host "E188 Zeilen ($was): $anzahl"
        if ($anzahl -ne 1) { Write-Host "E188 FEHLER: $was sollte genau eine Zeile haben"; return $false }
        [void](Snd $script:lb 0x0185 ([IntPtr]0) ([IntPtr](-1)))
        [void](Snd $script:lb 0x0185 ([IntPtr]1) ([IntPtr]0))
        [void](Snd $script:lb 0x019E ([IntPtr]0) ([IntPtr]0))
        $id = TransferNach $ziel
        if (-not $id) { Write-Host "E188 FEHLER: Eintrag ""$ziel"" im Menue Transfer nicht gefunden"; return $false }
        # Positivprobe "nur Kopf geladen": Textanfragen bis hierher zaehlen.
        $script:vorTransfer[$was] = @(Get-Content -LiteralPath $logA | Where-Object { $_ -match '<- .*FETCH.*(BODY(\.PEEK)?\[(TEXT|\d[^\]]*)?\]|RFC822(?!\.SIZE|\.HEADER))' }).Count
        Write-Host "E188 Transfer-Befehl $id nach ""$ziel"" ($was)"
        [void][E188]::PostMessageA($aktiv, 0x0111, [IntPtr]$id, [IntPtr]::Zero)
        Start-Sleep -Seconds $Warten
        Dialoge $pp
        Start-Sleep -Seconds $Warten
        Dialoge $pp
        return $true
    }

    $ok = $true
    if ($zwei) {
        if (-not (Oeffnen $kB @('Ziel'))) { Write-Host 'E188 FEHLER: "Ziel" nicht unter Konto B'; exit 1 }
        if (-not (Oeffnen $kA @('INBOX', 'Inbox', 'In'))) { Write-Host 'E188 FEHLER: INBOX nicht unter Konto A'; exit 1 }
        $ok = ZeileVerschieben 'Ziel' 'INBOX'
        AlleSchliessen
        [void](Oeffnen $kB @('Ziel'))           # Endstand nach Abgleich
        if ($Weg -eq 'loeschen') {
            # Jeden Eintrag der verschobenen Mail loeschen, je die letzte Zeile der
            # Liste; Rueckfragen mit OK. N aus Ziel.toc (beim Schliessen geschrieben).
            $vorToc = TocLesen (Join-Path $kontoB 'Ziel\Ziel.toc')	# gibt die Liste schon als Ganzes zurueck (return ,$aus) - kein @() darum
            $nLoeschen = @($vorToc | Where-Object { $_.Betreff -like 'Pruefnachricht 1*' }).Count
            Write-Host ("E188 vor dem Loeschen: {0} Eintraege, davon {1} mit dem Betreff der verschobenen Mail" -f $vorToc.Count, $nLoeschen)
            foreach ($e in $vorToc) { Write-Host ('E188 VOR-TOC Ziel uid={0} offset={1} laenge={2} betreff="{3}"' -f $e.Uid, $e.Offset, $e.Laenge, $e.Betreff) }
            for ($r = 0; $r -lt $nLoeschen; $r++) {
                $aktiv = Snd $mdi.H 0x0229 ([IntPtr]::Zero) ([IntPtr]::Zero)
                $script:lb = [IntPtr]::Zero
                $cc = [E188+EP]{ param($k, $q); if ($script:lb -eq [IntPtr]::Zero -and (Kl $k) -eq 'ListBox' -and [E188]::IsWindowVisible($k)) { $script:lb = $k }; return $true }
                [void][E188]::EnumChildWindows($aktiv, $cc, [IntPtr]::Zero)
                if ($script:lb -eq [IntPtr]::Zero) { Write-Host 'E188 FEHLER: keine Liste im Zielfenster'; break }
                # Welche Listen hat das Fenster? (zur Pruefung, ob die gefundene die Nachrichtenliste ist)
                $alleLb = [E188+EP]{ param($k, $q); $kk = Kl $k; if ($kk -like '*List*') { Write-Host ('E188 LISTE {0} klasse={1} sichtbar={2} zeilen={3}' -f $k, $kk, [E188]::IsWindowVisible($k), [int](Snd $k 0x018B ([IntPtr]0) ([IntPtr]0))) }; return $true }
                [void][E188]::EnumChildWindows($aktiv, $alleLb, [IntPtr]::Zero)
                Write-Host ('E188 gewaehlt: {0}' -f $script:lb)
                $anz = [int](Snd $script:lb 0x018B ([IntPtr]0) ([IntPtr]0))
                # Die Liste muss so viele Zeilen haben wie Ziel.toc (minus schon
                # geloeschte) - kurz nach dem Oeffnen ist sie noch nicht aufgebaut
                # (gemessen 04.11.2026: "Zeile 1 von 1" bei 2 Eintraegen in Ziel.toc;
                # geloescht wurde so die fremde Mail, ein Fehler dieses Skripts).
                $sollZeilen = $vorToc.Count - $r
                for ($w = 0; $w -lt 60 -and $anz -ne $sollZeilen; $w++) {
                    if ($w % 5 -eq 0) { Write-Host ("E188 warte auf Liste: {0} s, {1} Zeilen, soll {2}" -f $w, $anz, $sollZeilen) }
                    Start-Sleep -Seconds 1; $anz = [int](Snd $script:lb 0x018B ([IntPtr]0) ([IntPtr]0))
                }
                if ($anz -ne $sollZeilen) {
                    Write-Host ("E188 FEHLER: Liste hat {0} Zeilen, Ziel.toc {1} - nicht geloescht" -f $anz, $sollZeilen)
                    # Welche Mail ist die eine sichtbare Zeile? Doppelklick an das gemessene
                    # Handle der Liste (CTocListBox::OnLButtonDblClk -> OpenMessages), Titel des
                    # neuen Fensters lesen, Fenster schliessen.
                    [void](Snd $script:lb 0x0185 ([IntPtr]0) ([IntPtr](-1)))
                    [void](Snd $script:lb 0x0185 ([IntPtr]1) ([IntPtr]0))
                    [void][E188]::PostMessageA($script:lb, 0x0203, [IntPtr]1, [IntPtr]((8 -shl 16) -bor 10))
                    Start-Sleep -Seconds 3
                    $offen = Snd $mdi.H 0x0229 ([IntPtr]::Zero) ([IntPtr]::Zero)
                    Write-Host ('E188 SICHTBARE ZEILE oeffnet: "{0}"' -f (Txt $offen))
                    if ($offen -ne $aktiv) { [void][E188]::PostMessageA($offen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); Start-Sleep -Seconds 2 }
                    $script:loeschenUngemessen = $true; break
                }
                Write-Host ("E188 loesche Zeile {0} von {0} in ""{1}""" -f $anz, (Txt $aktiv))
                [void](Snd $script:lb 0x0185 ([IntPtr]0) ([IntPtr](-1)))
                [void](Snd $script:lb 0x0185 ([IntPtr]1) ([IntPtr]($anz - 1)))
                [void](Snd $script:lb 0x019E ([IntPtr]($anz - 1)) ([IntPtr]0))
                [void][E188]::PostMessageA($aktiv, 0x0111, [IntPtr]32805, [IntPtr]::Zero)   # ID_MESSAGE_DELETE
                Start-Sleep -Seconds 3
                foreach ($d in (Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' -and ([E188]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) {
                    Write-Host ('E188 RUECKFRAGE "' + (Txt $d.H) + '" -> OK')
                    [void][E188]::PostMessageA($d.H, 0x0111, [IntPtr]1, [IntPtr]::Zero)      # IDOK
                    Start-Sleep -Seconds 2
                }
                Start-Sleep -Seconds $Warten
                Dialoge $pp
                $script:geloescht++
            }
            # Nur wer alles geloescht hat, was er loeschen sollte, hat gemessen.
            if (-not $script:loeschenUngemessen -and $nLoeschen -gt 0 -and $script:geloescht -eq $nLoeschen) { $script:geloeschtAlle = $true; Write-Host ("E188 GELOESCHT ALLE ({0})" -f $nLoeschen) }
        }
        AlleSchliessen
        if ($Weg -eq 'loeschen') { [void](Oeffnen $kB @('Ziel')); AlleSchliessen }
    }
    else {
        if ($Weg -eq 'lokal') {
            if (-not (Oeffnen $kA @('Ablage'))) { Write-Host 'E188 FEHLER: "Ablage" nicht unter Konto A'; exit 1 }
            $ok = ZeileVerschieben 'Lokal' 'Ablage'
            AlleSchliessen
        }
        if ($ok) {
            if (-not (Oeffnen $kA @('INBOX', 'Inbox', 'In'))) { Write-Host 'E188 FEHLER: INBOX nicht unter Konto A'; exit 1 }
            $ok = ZeileVerschieben 'Lokal' 'INBOX'
            AlleSchliessen
        }
        if (LokalOeffnen) { AlleSchliessen }    # Lokal.toc schreiben lassen
    }
}
finally {
    [void][E188]::VirtualFreeEx($hp, $fern, 0, 0x8000)
    [void][E188]::CloseHandle($hp)
    Start-Sleep -Seconds 1
    foreach ($s in @($srvA, $srvB)) { if ($s -and -not $s.HasExited) { Stop-Process -Id $s.Id -Force } }
}

# --- Auswerten ----------------------------------------------------------------
foreach ($pr in @(@('A', $logA), @('B', $logB))) {
    if (-not (Test-Path $pr[1])) { continue }
    foreach ($z in (Get-Content -LiteralPath $pr[1] | Where-Object { $_ -match '<- .*(APPEND|COPY|STORE|EXPUNGE|SELECT)|!!|-> \S+ (OK|NO) \[?(APPENDUID|TRYCREATE)' })) {
        Write-Host ('E188 SERVER-' + $pr[0] + ' ' + $z.Substring([Math]::Min(10, $z.Length)))
    }
}
$endA = Zustand $logA; $endB = @(); if ($zwei) { $endB = Zustand $logB }
Write-Host ('E188 SERVER-NACHHER A: ' + (($endA | ForEach-Object { "$($_.Ordner)/$($_.Uid) del=$($_.Del) weg=$($_.Weg) rumpf=$($_.Rumpf) $($_.Mid)" }) -join ' ; '))
if ($zwei) { Write-Host ('E188 SERVER-NACHHER B: ' + (($endB | ForEach-Object { "$($_.Ordner)/$($_.Uid) del=$($_.Del) weg=$($_.Weg) rumpf=$($_.Rumpf) $($_.Mid)" }) -join ' ; ')) }
$vorher = @($startA) + @($startB); $nachher = @($endA) + @($endB)
$verloren = 0; $fremdDel = 0
if ($zwei) {
    # Zwischen Konten: verloren ist, was am Ende auf KEINEM Server ohne \Deleted steht.
    # Und: lebt sie nur als Kopie OHNE Text (Rumpf leer, die Quelle hatte einen),
    # ist ihr Text verloren (gemessen 03.11.2026, Weg kontentext: APPEND mit 300
    # statt 427 Byte, nur der Kopf).
    foreach ($mid in ($vorher | ForEach-Object { $_.Mid } | Sort-Object -Unique)) {
        $lebt = @($nachher | Where-Object { $_.Mid -eq $mid -and $_.Del -eq 0 })
        $rumpfVorher = (@($vorher | Where-Object { $_.Mid -eq $mid }) | Measure-Object -Property Rumpf -Maximum).Maximum
        $mitText = @($lebt | Where-Object { $_.Rumpf -ge [Math]::Min(10, $rumpfVorher) })
        if ($lebt.Count -eq 0) { $verloren++; Write-Host "E188 SERVER VERLOREN (nirgends ohne \Deleted): $mid" }
        elseif ($mitText.Count -eq 0) { $verloren++; Write-Host ("E188 SERVER VERLOREN (nur ohne Text, Rumpf {0} statt {1} Byte): {2}" -f (($lebt | ForEach-Object { $_.Rumpf }) -join ','), $rumpfVorher, $mid) }
    }
    foreach ($e in @($nachher | Where-Object { $_.Del -eq 1 -and $_.Mid -like '<fremd*' })) { $fremdDel++; Write-Host "E188 SERVER FREMDE GELOESCHT: $($e.Ordner)/$($e.Uid) $($e.Mid)" }
    # PRUEFER-94 K8: "GELOESCHT ALLE" stand VOR der Serverauswertung - lieferte
    # Server B keinen Endstand, fehlte die fremde Mail in $nachher, das zaehlte
    # als "VERLOREN", nicht als "FREMDE GELOESCHT", und der Fall war gruen ohne
    # Messung. Jetzt erst hier, und nur mit Endstand B und lebender fremder Mail.
    if ($Weg -eq 'loeschen' -and $script:geloeschtAlle -and @($endB).Count -gt 0) {
        $fremdLebt = @($endB | Where-Object { $_.Mid -like '<fremd*' -and $_.Del -eq 0 }).Count
        Write-Host ("E188 LOESCHEN GEMESSEN fremd-lebt={0} endstand-b={1}" -f $fremdLebt, @($endB).Count)
    }
}
else {
    # Nach lokal: verloren ist, was auf dem Server \Deleted traegt, dessen TEXT
    # aber nicht in Lokal.mbx steht (nur der Kopf kam an).
    $alles = ''; $mb = Join-Path $md 'Lokal.mbx'; if (Test-Path $mb) { $alles = $cp.GetString([IO.File]::ReadAllBytes($mb)) }
    foreach ($e in @($nachher | Where-Object { $_.Del -eq 1 })) {
        $marke = 'Dies ist Pruefnachricht ' + $e.Uid; if ($e.Mid -like '<fremd*') { $marke = 'lag schon vor dem Verschieben' }
        if (-not $alles.Contains($marke)) { $verloren++; Write-Host "E188 SERVER VERLOREN (auf dem Server geloescht, Text nicht lokal): $($e.Ordner)/$($e.Uid) $($e.Mid)" }
    }
}
$quelleDel = @($endA | Where-Object { $_.Ordner -eq 'INBOX' -and $_.Del -eq 1 }).Count
$quelleWeg = @($endA | Where-Object { $_.Ordner -eq 'INBOX' -and $_.Weg -eq 1 }).Count

if ($zwei) {
    $toc = TocLesen (Join-Path $kontoB 'Ziel\Ziel.toc')
    foreach ($e in $toc) { Write-Host ('E188 TOC Ziel uid={0} offset={1} laenge={2} betreff="{3}"' -f $e.Uid, $e.Offset, $e.Laenge, $e.Betreff) }
    $fremd = @($toc | Where-Object { $_.Uid -eq 1 -and $_.Betreff -like 'Fremde Nachricht*' }).Count
    $kopie = @($toc | Where-Object { $_.Uid -eq 2 -and $_.Betreff -like 'Pruefnachricht 1*' }).Count
    $kopieServer = @($endB | Where-Object { $_.Ordner -eq 'Ziel' -and $_.Mid -eq '<pruef-1@pruefserver.invalid>' -and $_.Del -eq 0 }).Count
    $anzeige = 'FALSCH'
    if ($Weg -eq 'append' -or $Weg -eq 'kontentext') { if ($fremd -eq 1 -and $toc.Count -eq 1) { $anzeige = 'richtig' } }
    elseif ($fremd -eq 1 -and $kopie -eq 1 -and $toc.Count -eq 2) { $anzeige = 'richtig' }
    # Nichts geloescht heisst nichts gemessen - sonst waere der Fall blind gruen
    # (gemessen 04.11.2026: abgebrochen, "fremd-geloescht=0", bestanden).
    if ($script:loeschenUngemessen) { $anzeige = 'UNGEMESSEN' }
    Write-Host ("E188 ERGEBNIS weg={0} anzeige={1} ziel-fremd={2} ziel-kopie={3} eintraege={4} | server quelle-del={5} quelle-weg={6} kopie-im-ziel={7} verloren={8} fremd-geloescht={9} dialoge={10}" -f `
        $Weg, $anzeige, $fremd, $kopie, $toc.Count, $quelleDel, $quelleWeg, $kopieServer, $verloren, $fremdDel, $script:dialoge.Count)
}
else {
    $mbx = Join-Path $md 'Lokal.mbx'
    $toc = TocLesen (Join-Path $md 'Lokal.toc')
    $richtig = 0; $falsch = 0; $nurKopf = 0
    foreach ($e in $toc) {
        $t = MbxText $mbx $e
        $art = '?'
        $erwartet = ''
        if ($e.Betreff -like 'Fremde Nachricht*') { $erwartet = 'lag schon vor dem Verschieben' }
        elseif ($e.Betreff -like 'Pruefnachricht 1*') { $erwartet = 'Dies ist Pruefnachricht 1' }
        if ($erwartet -and $t.Contains($erwartet)) { $art = 'eigener-text'; $richtig++ }
        elseif ($t.Contains('lag schon vor dem Verschieben') -or $t.Contains('Dies ist Pruefnachricht')) { $art = 'FREMDER-TEXT'; $falsch++ }
        else { $art = 'ohne-text'; $nurKopf++ }
        Write-Host ('E188 TOC Lokal uid={0} offset={1} laenge={2} betreff="{3}" inhalt={4}' -f $e.Uid, $e.Offset, $e.Laenge, $e.Betreff, $art)
    }
    $soll = 1; if ($Weg -eq 'lokal') { $soll = 2 }
    $anzeige = 'FALSCH'; if ($richtig -eq $soll -and $toc.Count -eq $soll) { $anzeige = 'richtig' }
    $mbxLaenge = 0; if (Test-Path $mbx) { $mbxLaenge = (Get-Item $mbx).Length }
    $vt = (($script:vorTransfer.Keys | Sort-Object | ForEach-Object { "$_=$($script:vorTransfer[$_])" }) -join ',')
    Write-Host ("E188 ERGEBNIS weg={0} anzeige={1} eigener-text={2} fremder-text={3} ohne-text={4} eintraege={5} mbx={6} textanfragen-vor-transfer={7} | server quelle-del={8} quelle-weg={9} verloren={10} fremd-geloescht={11} dialoge={12}" -f `
        $Weg, $anzeige, $richtig, $falsch, $nurKopf, $toc.Count, $mbxLaenge, $vt, $quelleDel, $quelleWeg, $verloren, $fremdDel, $script:dialoge.Count)
}
try { Stop-Transcript | Out-Null } catch { }
