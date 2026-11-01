# messen-e184.ps1 - ueberschreibt Eudora beim Verschieben innerhalb eines
# IMAP-Kontos die Zusammenfassung einer FREMDEN Mail im Ziel? (Befund E-184)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, bekommt von dort
# -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem Pfad.
#
# WARUM ES DAS GIBT. PRUEFER-71 fand am Quelltext: nach dem Verschieben sucht
# CTocDoc::ImapTransferSummaryData (EuImap/src/ImapToc.cpp:1538ff, Aufruf mit
# bFindNew=true aus CImapTransferMsgAction::DoPostProcessing) die
# Zusammenfassung im ZIELordner unter der ALTEN UID. UIDs gelten je Ordner;
# traegt eine fremde Mail im Ziel dieselbe Nummer, wird ihr Eintrag mit den
# Daten der verschobenen ueberschrieben. Nie gemessen.
#
# Lage (vom Pruefserver hergestellt, tools\imap-pruefserver.pl):
#   INBOX  : genau eine Nachricht, UID 1, "Pruefnachricht 1 von ..."
#   Ablage : eine fremde Nachricht, UID 1, "Fremde Nachricht mit UID 1"
# Der Server kann UID COPY und antwortet mit COPYUID (UIDPLUS).
#
# Ablauf, ohne Tastendruck, nur Botschaften an gemessene Fensterhandles:
#   1. Pruefserver starten (Port 1143, --nachrichten 1 --fremde-uid 1)
#   2. "Ablage" oeffnen - Eudora gleicht ab und kennt danach die fremde Mail
#   3. "INBOX" oeffnen, die einzige Zeile waehlen
#   4. Menue Transfer -> pruef-imap -> Ablage (Befehlsnummer zur Laufzeit gelesen)
#   5. warten (Kopie, Nachbearbeitung, Abgleich), beide Fenster schliessen -
#      dabei schreibt Eudora Ablage.toc
#   6. Ablage.toc auslesen (Datensatz 218 Byte, CSummary::Write, summary.cpp)
#
# Ausgabe: Zeilen "E184 ...". Erwartet, wenn nichts ueberschrieben wird:
#   E184 ERGEBNIS fremd=1 kopie=1 eintraege=2
# (fremd = Eintraege mit dem Betreff der fremden Mail und UID 1, kopie =
# Eintraege mit dem Betreff der verschobenen Mail und UID 2).
#
# Vorbereiten (vor dem Start, von pruefstand-lauf.ps1 gerufen):
#   tools\messen-e184.ps1 -Vorbereiten -Pfadfilter C:\Temp\E184
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [int] $Warten = 15
)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
$konto = Join-Path $voll 'Mailverzeichnis\Imap\pruefimap'
$srvlog = Join-Path $voll 'imap-e184.log'

# --- -Vorbereiten: Ausgangslage, VOR dem Start ------------------------------
# Die Pfadschranke steht vor jeder Wirkung (Arbeitsweise/tor-gehoert-zum-schritt.md).
if ($Vorbereiten) {
    if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E184 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
    if (-not (Test-Path $konto)) { Write-Host "E184 FEHLER: kein IMAP-Konto pruefimap in $voll"; exit 1 }
    $bleiben = @('INBOX', 'Ablage', 'Entw&APw-rfe', 'Gel&APY-scht')
    Get-ChildItem -LiteralPath $konto -Directory | Where-Object { $bleiben -notcontains $_.Name } |
        Remove-Item -Recurse -Force
    foreach ($d in $bleiben) {
        $p = Join-Path $konto $d
        # Zwischenspeicher leeren: Eudora soll beide Ordner frisch vom Server lesen.
        if (Test-Path $p) { Get-ChildItem -LiteralPath $p -Force | Remove-Item -Recurse -Force }
        New-Item -ItemType Directory -Force -Path $p | Out-Null
    }
    $zeilen = @('INBOX,INBOX,M,/,0,0,0,0,Y,0', 'Ablage,Ablage,M,/,0,0,0,0,N,0',
                'Entw&APw-rfe,Entw&APw-rfe,M,/,0,0,0,0,N,0', 'Gel&APY-scht,Gel&APY-scht,M,/,0,0,0,0,N,0')
    [IO.File]::WriteAllText((Join-Path $konto 'mboxlist.lst'), (($zeilen -join "`r`n") + "`r`n"))
    [IO.File]::WriteAllText((Join-Path $konto 'actionqueue.dat'), "<IMAPQueueData>`r`n`t<DataFormatVersion>1</DataFormatVersion>`r`n</IMAPQueueData>`r`n")
    Remove-Item -LiteralPath $srvlog -Force -ErrorAction SilentlyContinue
    $ini = Join-Path $voll 'Mailverzeichnis\Eudora.ini'
    $z = [IO.File]::ReadAllLines($ini, [Text.Encoding]::GetEncoding(1252))
    [IO.File]::WriteAllLines($ini, [string[]]($z | Where-Object { $_ -notmatch '^OpenWindow[0-9]+=.*Imap.pruefimap' }), [Text.Encoding]::GetEncoding(1252))
    Write-Host "E184 vorbereitet: $konto"
    exit 0
}

# --- Auslesen von Ablage.toc (ohne Eudora) ----------------------------------
# CSummary::Write (Eudora71/Eudora/summary.cpp): 218 Byte je Datensatz.
#   0 m_Offset(4)  4 m_Length(4)  50 m_From[64]  114 m_Subject[64]
#   186 m_Label(2) 188 m_Hash(4) = UID
# Vor den Datensaetzen steht der Kopf, dessen letzte zwei Byte die Anzahl
# sind (CTocDoc::Write, tocdoc.cpp) - die Kopflaenge wird daran erkannt.
function TocLesen([string] $pfad) {
    $aus = @()
    if (-not (Test-Path -LiteralPath $pfad)) { return ,$aus }
    $b = [IO.File]::ReadAllBytes($pfad)
    $cp = [Text.Encoding]::GetEncoding(1252)
    # Ab n=1 suchen: bei n=0 passt die Probe zufaellig, weil die letzten zwei
    # Byte eines Datensatzes unbenutzt und null sind (gemessen 01.11.2026).
    # Leer ist die Liste nur, wenn die Datei genau einen Kopf lang ist (104).
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
                Von = (& $str ($o + 50) 64)
                Offset = [BitConverter]::ToInt32($b, $o)
                Laenge = [BitConverter]::ToInt32($b, $o + 4)
                Label = [BitConverter]::ToInt16($b, $o + 186)
            }
        }
        return ,$aus
    }
    Write-Host "E184 WARNUNG: $pfad hat kein erkennbares TOC-Format ($($b.Length) Byte)"
    return ,$aus
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E184 {
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
function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E184]::GetClassName($h, $s, 256); $s.ToString() }
function Txt($h) { $s = New-Object Text.StringBuilder 256; [void][E184]::GetWindowTextA($h, $s, 256); $s.ToString() }
function Snd($h, $m, $w, $l, $ms = 5000) { $r = [IntPtr]::Zero; [void][E184]::SendMessageTimeoutA($h, $m, $w, $l, 0x0002, $ms, [ref]$r); return $r }
function Alle($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E184+EP]{ param($h, $p); $o = 0; [void][E184]::GetWindowThreadProcessId($h, [ref]$o)
        if ($o -eq $pp) {
            $cc = [E184+EP]{ param($k, $q)
                [void]$r.Add([pscustomobject]@{ H = $k; Id = [E184]::GetDlgCtrlID($k); Klasse = (Kl $k); Vis = [E184]::IsWindowVisible($k) })
                return $true }
            [void][E184]::EnumChildWindows($h, $cc, [IntPtr]::Zero)
            [void]$r.Add([pscustomobject]@{ H = $h; Id = [E184]::GetDlgCtrlID($h); Klasse = (Kl $h); Vis = [E184]::IsWindowVisible($h) })
        }
        return $true }
    [void][E184]::EnumWindows($cb, [IntPtr]::Zero); return $r
}
function Dialoge($pp, [switch] $Schliessen) {
    foreach ($d in (Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' -and ([E184]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) {
        $script:inhalt = @(); $cc = [E184+EP]{ param($k, $q); $t = Txt $k; if ($t) { $script:inhalt += $t }; return $true }
        [void][E184]::EnumChildWindows($d.H, $cc, [IntPtr]::Zero)
        Write-Host ("E184 DIALOG '{0}': {1}" -f (Txt $d.H), ($script:inhalt -join ' | '))
        if ($Schliessen) { [void][E184]::PostMessageA($d.H, 0x0010, [IntPtr]0, [IntPtr]0) }
    }
}

$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E184 FEHLER: keine Eudora aus $voll"; exit 1 }
$pp = $proz[0].Id
$haupt = Alle $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E184 FEHLER: kein Hauptfenster'; exit 1 }
$mdi = Alle $pp | Where-Object { $_.Klasse -eq 'MDIClient' } | Select-Object -First 1

# 1. Pruefserver
$repo = Split-Path -Parent $PSScriptRoot
$perl = 'C:\Program Files\Git\usr\bin\perl.exe'
$belegt = @(Get-NetTCPConnection -LocalPort 1143 -State Listen -ErrorAction SilentlyContinue)
if ($belegt.Count -gt 0) { Write-Host ('E184 FEHLER: Port 1143 belegt von Prozess ' + (($belegt | ForEach-Object { $_.OwningProcess }) -join ',')); exit 1 }
$srvArgs = @("$repo\tools\imap-pruefserver.pl", '--port', '1143', '--protokoll', $srvlog, '--zeitschranke', [string](60 + 3 * $Warten),
             '--nachrichten', '1', '--fremde-uid', '1')
$srv = Start-Process $perl -ArgumentList $srvArgs -WorkingDirectory $repo -WindowStyle Hidden -PassThru
Start-Sleep -Seconds 2

$TVM_EXPAND = 0x1102; $TVM_GETNEXT = 0x110A; $TVM_SELECT = 0x110B; $TVM_GETITEM = 0x110C
$hp = [E184]::OpenProcess(0x0438, $false, [uint32]$pp)
$fern = [E184]::VirtualAllocEx($hp, [IntPtr]::Zero, 4096, 0x3000, 0x04)
$ablageToc = Join-Path $konto 'Ablage\Ablage.toc'
try {
    function Text($baum, $item) {
        $tv = New-Object byte[] 40
        [BitConverter]::GetBytes([int]0x11).CopyTo($tv, 0)
        [BitConverter]::GetBytes([int]$item.ToInt64()).CopyTo($tv, 4)
        [BitConverter]::GetBytes([int]($fern.ToInt64() + 64)).CopyTo($tv, 16)
        [BitConverter]::GetBytes([int]256).CopyTo($tv, 20)
        $w = [IntPtr]::Zero
        [void][E184]::WriteProcessMemory($hp, $fern, $tv, 40, [ref]$w)
        [void](Snd $baum $TVM_GETITEM ([IntPtr]0) $fern)
        $b = New-Object byte[] 256
        [void][E184]::ReadProcessMemory($hp, [IntPtr]($fern.ToInt64() + 64), $b, 256, [ref]$w)
        $n = [Array]::IndexOf($b, [byte]0); if ($n -lt 0) { $n = 256 }
        return [Text.Encoding]::GetEncoding(1252).GetString($b, 0, $n)
    }
    function Kinder($baum, $item) {
        $aus = @()
        $k = Snd $baum $TVM_GETNEXT ([IntPtr]4) $item
        while ($k -ne [IntPtr]::Zero) { $aus += $k; $k = Snd $baum $TVM_GETNEXT ([IntPtr]1) $k }
        return $aus
    }
    function Suche($baum, $item, [string[]] $namen, [int] $tiefe) {
        if ($tiefe -gt 4) { return [IntPtr]::Zero }
        [void](Snd $baum $TVM_EXPAND ([IntPtr]2) $item)
        foreach ($k in (Kinder $baum $item)) {
            if ($namen -contains (Text $baum $k)) { return $k }
            $f = Suche $baum $k $namen ($tiefe + 1)
            if ($f -ne [IntPtr]::Zero) { return $f }
        }
        return [IntPtr]::Zero
    }
    function Oeffnen($baum, [string[]] $namen) {
        $w = Snd $baum $TVM_GETNEXT ([IntPtr]0) ([IntPtr]0)
        while ($w -ne [IntPtr]::Zero) {
            $f = Suche $baum $w $namen 0
            if ($f -ne [IntPtr]::Zero) {
                Write-Host ('E184 oeffne "' + (Text $baum $f) + '"')
                [void](Snd $baum $TVM_SELECT ([IntPtr]9) $f)
                [void][E184]::PostMessageA($baum, 0x0111, [IntPtr]32914, [IntPtr]::Zero)   # ID_MBOXTREE_OPEN
                return $true
            }
            $w = Snd $baum $TVM_GETNEXT ([IntPtr]1) $w
        }
        return $false
    }
    # Befehlsnummer von Transfer -> ... -> $Ziel; die Postfacheintraege fuellt
    # Eudora erst beim Aufklappen (WM_INITMENUPOPUP), auch in Untermenues.
    function MenueSuche($sub, [string] $Ziel, [int] $tiefe) {
        if ($tiefe -gt 3) { return 0 }
        [void](Snd $haupt.H 0x0117 $sub ([IntPtr]0))
        for ($j = 0; $j -lt [E184]::GetMenuItemCount($sub); $j++) {
            $t = New-Object Text.StringBuilder 128
            [void][E184]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
            $name = $t.ToString() -replace '&', ''
            $unter = [E184]::GetSubMenu($sub, $j)
            if ($unter -ne [IntPtr]::Zero) { $id = MenueSuche $unter $Ziel ($tiefe + 1); if ($id) { return $id } }
            elseif ($name -eq $Ziel) { return [int][E184]::GetMenuItemID($sub, $j) }
        }
        return 0
    }
    function TransferNach([string] $Ziel) {
        $m = [E184]::GetMenu($haupt.H)
        for ($i = 0; $i -lt [E184]::GetMenuItemCount($m); $i++) {
            $s = New-Object Text.StringBuilder 128
            [void][E184]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
            if (($s.ToString() -replace '&', '') -ne 'Transfer') { continue }
            return (MenueSuche ([E184]::GetSubMenu($m, $i)) $Ziel 0)
        }
        return 0
    }
    function MdiKinder() { return @(Alle $pp | Where-Object { $_.Vis -and $mdi -and [E184]::GetParent($_.H) -eq $mdi.H }) }

    Dialoge $pp -Schliessen
    Start-Sleep -Seconds 1

    # Postfachbaum
    $baum = Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq 'SysTreeView32' -and ($_.Id -eq 1016 -or $_.Id -eq 1042) } | Select-Object -First 1
    if (-not $baum) {
        [void][E184]::PostMessageA($haupt.H, 0x0111, [IntPtr]32827, [IntPtr]::Zero)   # ID_WINDOW_MAILBOXES
        Start-Sleep -Seconds 3
        $baum = Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq 'SysTreeView32' -and ($_.Id -eq 1016 -or $_.Id -eq 1042) } | Select-Object -First 1
    }
    if (-not $baum) { Write-Host 'E184 FEHLER: Postfachbaum nicht gefunden'; exit 1 }

    # 2. Ablage oeffnen und abgleichen lassen
    if (-not (Oeffnen $baum.H @('Ablage'))) { Write-Host 'E184 FEHLER: "Ablage" nicht im Baum'; exit 1 }
    Start-Sleep -Seconds $Warten
    Dialoge $pp -Schliessen

    # 3. INBOX oeffnen - NUR unter dem Kontoknoten, der auch "Ablage" traegt;
    #    sonst greift das lokale Postfach "In" (erster Lauf 01.11.2026 17:25).
    $script:kontoKnoten = [IntPtr]::Zero
    $w = Snd $baum.H $TVM_GETNEXT ([IntPtr]0) ([IntPtr]0)
    while ($w -ne [IntPtr]::Zero -and $script:kontoKnoten -eq [IntPtr]::Zero) {
        $f = Suche $baum.H $w @('Ablage') 0
        if ($f -ne [IntPtr]::Zero) { $script:kontoKnoten = Snd $baum.H $TVM_GETNEXT ([IntPtr]3) $f }   # TVGN_PARENT
        $w = Snd $baum.H $TVM_GETNEXT ([IntPtr]1) $w
    }
    if ($script:kontoKnoten -eq [IntPtr]::Zero) { Write-Host 'E184 FEHLER: Kontoknoten von "Ablage" nicht gefunden'; exit 1 }
    $namen = @(Kinder $baum.H $script:kontoKnoten | ForEach-Object { Text $baum.H $_ })
    Write-Host ('E184 Konto "' + (Text $baum.H $script:kontoKnoten) + '": ' + ($namen -join ', '))
    $inbox = @(Kinder $baum.H $script:kontoKnoten | Where-Object { @('INBOX', 'Inbox', 'In') -contains (Text $baum.H $_) }) | Select-Object -First 1
    if (-not $inbox) { Write-Host 'E184 FEHLER: INBOX nicht unter dem Konto'; exit 1 }
    Write-Host ('E184 oeffne "' + (Text $baum.H $inbox) + '" im Konto')
    [void](Snd $baum.H $TVM_SELECT ([IntPtr]9) $inbox)
    [void][E184]::PostMessageA($baum.H, 0x0111, [IntPtr]32914, [IntPtr]::Zero)          # ID_MBOXTREE_OPEN
    Start-Sleep -Seconds $Warten
    Dialoge $pp -Schliessen
    $aktiv = Snd $mdi.H 0x0229 ([IntPtr]::Zero) ([IntPtr]::Zero)                    # WM_MDIGETACTIVE
    Write-Host ('E184 aktives Fenster: "' + (Txt $aktiv) + '"')
    $script:lb = [IntPtr]::Zero
    $cc = [E184+EP]{ param($k, $q); if ($script:lb -eq [IntPtr]::Zero -and (Kl $k) -eq 'ListBox' -and [E184]::IsWindowVisible($k)) { $script:lb = $k }; return $true }
    [void][E184]::EnumChildWindows($aktiv, $cc, [IntPtr]::Zero)
    if ($script:lb -eq [IntPtr]::Zero) { Write-Host 'E184 FEHLER: keine Liste im INBOX-Fenster'; exit 1 }
    $anzahl = [int](Snd $script:lb 0x018B ([IntPtr]0) ([IntPtr]0))                   # LB_GETCOUNT
    Write-Host "E184 INBOX-Zeilen: $anzahl"
    if ($anzahl -ne 1) { Write-Host 'E184 FEHLER: INBOX sollte genau eine Zeile haben'; exit 1 }
    [void](Snd $script:lb 0x0185 ([IntPtr]0) ([IntPtr](-1)))                         # LB_SETSEL FALSE, alle
    [void](Snd $script:lb 0x0185 ([IntPtr]1) ([IntPtr]0))                            # LB_SETSEL TRUE, 0
    [void](Snd $script:lb 0x019E ([IntPtr]0) ([IntPtr]0))                            # LB_SETCARETINDEX

    $vorher = TocLesen $ablageToc
    Write-Host ('E184 Ablage.toc vor dem Verschieben: ' + (($vorher | ForEach-Object { 'uid=' + $_.Uid + ' "' + $_.Betreff + '"' }) -join ' ; '))

    # 4. Transfer -> Ablage
    $id = TransferNach 'Ablage'
    if (-not $id) { Write-Host 'E184 FEHLER: Eintrag "Ablage" im Menue Transfer nicht gefunden'; exit 1 }
    Write-Host "E184 Transfer-Befehl $id"
    [void][E184]::PostMessageA($aktiv, 0x0111, [IntPtr]$id, [IntPtr]::Zero)
    Start-Sleep -Seconds $Warten
    Dialoge $pp -Schliessen
    Start-Sleep -Seconds $Warten

    # 5. alle Postfachfenster schliessen - dabei wird Ablage.toc geschrieben
    foreach ($k in (MdiKinder)) { Write-Host ('E184 schliesse "' + (Txt $k.H) + '"'); [void][E184]::PostMessageA($k.H, 0x0010, [IntPtr]0, [IntPtr]0) }
    Start-Sleep -Seconds 4
    Dialoge $pp -Schliessen
}
finally {
    [void][E184]::VirtualFreeEx($hp, $fern, 0, 0x8000)
    [void][E184]::CloseHandle($hp)
    Start-Sleep -Seconds 1
    if (-not $srv.HasExited) { Stop-Process -Id $srv.Id -Force }
}

# 6. Auswerten
$prot = @(); if (Test-Path $srvlog) { $prot = Get-Content -LiteralPath $srvlog }
foreach ($z in ($prot | Where-Object { $_ -match 'COPY|SELECT|EXPUNGE|!!' })) { Write-Host ('E184 SERVER ' + $z.Substring([Math]::Min(10, $z.Length))) }
$nachher = TocLesen $ablageToc
foreach ($e in $nachher) { Write-Host ('E184 TOC uid={0} label={1} offset={2} laenge={3} von="{4}" betreff="{5}"' -f $e.Uid, $e.Label, $e.Offset, $e.Laenge, $e.Von, $e.Betreff) }
$fremd = @($nachher | Where-Object { $_.Uid -eq 1 -and $_.Betreff -like 'Fremde Nachricht*' }).Count
$kopie = @($nachher | Where-Object { $_.Uid -eq 2 -and $_.Betreff -like 'Pruefnachricht 1*' }).Count
Write-Host ("E184 ERGEBNIS fremd={0} kopie={1} eintraege={2}" -f $fremd, $kopie, $nachher.Count)
