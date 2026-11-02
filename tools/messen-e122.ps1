# messen-e122.ps1 - ist das Eingangsdatum (INTERNALDATE) einer LOKALEN
# Nachricht, die in einen IMAP-Ordner uebertragen wird, um die Zeitzone des
# Rechners verschoben? (Befund E-122)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, bekommt von dort
# -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem Pfad.
#
#   powershell -ExecutionPolicy Bypass -File tools\testlauf.ps1 `
#       -Verzeichnis C:\Temp\E122 -Freigabe "<Gregors Satz von heute>" `
#       -MessenSkript tools\messen-e122.ps1 -Sekunden 20
#
# WARUM ES DAS GIBT. Gemessen am 14.10.2026 (MESSSTAND, PRUEFER-27) am
# IMAP-Pruefserver: "Date: 09:10:00 +0200" kam als INTERNALDATE
# "07:10:00 +0200" an. CSummary::m_Seconds ist fuer eine Nachricht mit
# Date:-Kopf nicht UTC, sondern UTC minus die Ortszone des Rechners, und
# append_date (Imapdll/src/osdep.cpp) erwartet echtes UTC. Die Behebung
# (Zweig e122_imap_datum, CImapAppend::ReformatHeader / E122DatumAlsUtc)
# berechnet das Datum aus dem Date:-Kopf selbst.
#
# Lage (-Vorbereiten): lokales "In" mit genau zwei Nachrichten aus Testdaten/
#   e122-datum-mit-zone.eml   Date: Mon, 02 Nov 2026 09:10:00 +0200
#   e122-datum-zone-minus.eml Date: Mon, 02 Nov 2026 09:10:00 -0500
# Zwei Zonen, damit "passt" nicht zufaellig aus gleicher Absender- und
# Rechnerzone entsteht (die alte auskommentierte Korrektur stimmte nur dann).
#
# Ablauf, ohne Tastendruck, nur Botschaften an gemessene Fensterhandles:
#   1. Pruefserver starten (Port 1143, --ablage <Pruefstand>\ablage-e122)
#   2. lokales In oeffnen (ID_MAILBOX_IN), beide Zeilen waehlen
#   3. Menue Transfer -> pruef-imap -> Ablage (Befehlsnummer zur Laufzeit)
#   4. warten, Fenster schliessen
#   5. Serverprotokoll: das Datum aus jeder "APPEND"-Befehlszeile; Ablage:
#      der Date:-Kopf der hochgeladenen Nachricht in derselben Reihenfolge
#
# Ausgabe: Zeilen "E122 ...", darunter
#   E122 ZONE id=<Zeitzone> versatz-min=<Ortszone am Nachrichtentag>
#   E122 NACHRICHT date="<kopf>" internaldate="<server>" differenz-min=<n>
#   E122 ERGEBNIS nachrichten=<n> passt=<n> verschoben=<n> lebt=<0|1>
# Erwartet mit der Behebung: nachrichten=2 passt=2 verschoben=0 lebt=1;
# ohne (alter Bau): verschoben=2, differenz-min = minus Ortszone.
#
# Vorbereiten (vor dem Start, von pruefstand-lauf.ps1 gerufen):
#   tools\messen-e122.ps1 -Vorbereiten -Pfadfilter C:\Temp\E122
#
# Jede Ausnahme wird hier abgefangen und als "E122 FEHLER" gemeldet - eine
# durchgereichte Ausnahme bricht testlauf.ps1 vor dem Protokoll ab.
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [int] $Warten = 15
)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
$md = Join-Path $voll 'Mailverzeichnis'
$konto = Join-Path $md 'Imap\pruefimap'
$srvlog = Join-Path $voll 'imap-e122.log'
$ablage = Join-Path $voll 'ablage-e122'
$repo = Split-Path -Parent $PSScriptRoot
$proben = @('e122-datum-mit-zone.eml', 'e122-datum-zone-minus.eml')

# --- -Vorbereiten: Ausgangslage, VOR dem Start ------------------------------
# Die Pfadschranke steht vor jeder Wirkung (Arbeitsweise/tor-gehoert-zum-schritt.md).
if ($Vorbereiten) {
    try {
        if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E122 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
        if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E122 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
        if (-not (Test-Path $konto)) { Write-Host "E122 FEHLER: kein IMAP-Konto pruefimap in $voll"; exit 1 }
        # lokales In: genau die zwei Pruefnachrichten (ohne In.toc baut Eudora
        # das Inhaltsverzeichnis neu und liest das Datum aus dem Date:-Kopf)
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^In\.(mbx|toc)(\.\d{3})?$' } | Remove-Item -Force
        $inhalt = New-Object System.Collections.Generic.List[byte]
        foreach ($p in $proben) {
            $inhalt.AddRange([Text.Encoding]::ASCII.GetBytes("From ???@??? Mon Nov 02 10:00:00 2026`r`n"))
            $inhalt.AddRange([IO.File]::ReadAllBytes((Join-Path $repo "Testdaten\$p")))
            $inhalt.AddRange([Text.Encoding]::ASCII.GetBytes("`r`n"))
        }
        [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), $inhalt.ToArray())
        # IMAP-Konto wie in messen-e184.ps1: Zwischenspeicher leer, feste Ordnerliste
        $bleiben = @('INBOX', 'Ablage', 'Entw&APw-rfe', 'Gel&APY-scht')
        Get-ChildItem -LiteralPath $konto -Directory | Where-Object { $bleiben -notcontains $_.Name } | Remove-Item -Recurse -Force
        foreach ($d in $bleiben) {
            $p = Join-Path $konto $d
            if (Test-Path $p) { Get-ChildItem -LiteralPath $p -Force | Remove-Item -Recurse -Force }
            New-Item -ItemType Directory -Force -Path $p | Out-Null
        }
        $zeilen = @('INBOX,INBOX,M,/,0,0,0,0,Y,0', 'Ablage,Ablage,M,/,0,0,0,0,N,0',
                    'Entw&APw-rfe,Entw&APw-rfe,M,/,0,0,0,0,N,0', 'Gel&APY-scht,Gel&APY-scht,M,/,0,0,0,0,N,0')
        [IO.File]::WriteAllText((Join-Path $konto 'mboxlist.lst'), (($zeilen -join "`r`n") + "`r`n"))
        [IO.File]::WriteAllText((Join-Path $konto 'actionqueue.dat'), "<IMAPQueueData>`r`n`t<DataFormatVersion>1</DataFormatVersion>`r`n</IMAPQueueData>`r`n")
        Remove-Item -LiteralPath $srvlog -Force -ErrorAction SilentlyContinue
        if (Test-Path $ablage) { Remove-Item -LiteralPath $ablage -Recurse -Force }
        $ini = Join-Path $md 'Eudora.ini'
        $z = [IO.File]::ReadAllLines($ini, [Text.Encoding]::GetEncoding(1252))
        [IO.File]::WriteAllLines($ini, [string[]]($z | Where-Object { $_ -notmatch '^OpenWindow[0-9]+=.*Imap.pruefimap' }), [Text.Encoding]::GetEncoding(1252))
        Write-Host ("E122 vorbereitet: {0} (In.mbx {1} Byte, {2} Nachrichten)" -f $md, $inhalt.Count, $proben.Count)
        exit 0
    } catch {
        Write-Host ('E122 FEHLER beim Vorbereiten: ' + $_.Exception.Message); exit 1
    }
}

# --- Datumsangaben in UTC ---------------------------------------------------
$monate = @{ Jan = 1; Feb = 2; Mar = 3; Apr = 4; May = 5; Jun = 6; Jul = 7; Aug = 8; Sep = 9; Oct = 10; Nov = 11; Dec = 12 }
# "Mon, 02 Nov 2026 09:10:00 +0200" (Date:) und "02-Nov-2026 08:10:00 +0100"
# (IMAP date-time, RFC 3501) - beide mit numerischer Zone.
function AlsZeit([string] $s) {
    if ($s -notmatch '(\d{1,2})[ -]([A-Za-z]{3})[ -](\d{4}) (\d\d):(\d\d):(\d\d) ([+-])(\d\d)(\d\d)') { return $null }
    $vz = 1; if ($Matches[7] -eq '-') { $vz = -1 }
    $zone = New-Object TimeSpan ($vz * [int]$Matches[8]), ($vz * [int]$Matches[9]), 0
    return New-Object DateTimeOffset ([int]$Matches[3]), $monate[$Matches[2]], ([int]$Matches[1]), ([int]$Matches[4]), ([int]$Matches[5]), ([int]$Matches[6]), $zone
}

$nachrichten = 0; $passt = 0; $verschoben = 0; $lebt = 0
$srv = $null; $hp = [IntPtr]::Zero; $fern = [IntPtr]::Zero
try {
    $tz = [TimeZoneInfo]::Local
    $tag = New-Object DateTime 2026, 11, 2, 9, 10, 0
    Write-Host ("E122 ZONE id={0} versatz-min={1} (am 02.11.2026; jetzt {2})" -f $tz.Id, $tz.GetUtcOffset($tag).TotalMinutes, (Get-Date).ToString('zzz'))

    Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E122 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
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
}
"@
    function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E122]::GetClassName($h, $s, 256); $s.ToString() }
    function Txt($h) { $s = New-Object Text.StringBuilder 256; [void][E122]::GetWindowTextA($h, $s, 256); $s.ToString() }
    function Snd($h, $m, $w, $l, $ms = 5000) { $r = [IntPtr]::Zero; [void][E122]::SendMessageTimeoutA($h, $m, $w, $l, 0x0002, $ms, [ref]$r); return $r }
    function Alle($pp) {
        $r = New-Object System.Collections.ArrayList
        $cb = [E122+EP]{ param($h, $p); $o = 0; [void][E122]::GetWindowThreadProcessId($h, [ref]$o)
            if ($o -eq $pp) {
                $cc = [E122+EP]{ param($k, $q)
                    [void]$r.Add([pscustomobject]@{ H = $k; Klasse = (Kl $k); Vis = [E122]::IsWindowVisible($k) })
                    return $true }
                [void][E122]::EnumChildWindows($h, $cc, [IntPtr]::Zero)
                [void]$r.Add([pscustomobject]@{ H = $h; Klasse = (Kl $h); Vis = [E122]::IsWindowVisible($h) })
            }
            return $true }
        [void][E122]::EnumWindows($cb, [IntPtr]::Zero); return $r
    }
    function Dialoge($pp) {
        foreach ($d in (Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' -and ([E122]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) {
            $script:inhalt = @(); $cc = [E122+EP]{ param($k, $q); $t = Txt $k; if ($t) { $script:inhalt += $t }; return $true }
            [void][E122]::EnumChildWindows($d.H, $cc, [IntPtr]::Zero)
            Write-Host ("E122 DIALOG '{0}': {1}" -f (Txt $d.H), ($script:inhalt -join ' | '))
            [void][E122]::PostMessageA($d.H, 0x0010, [IntPtr]0, [IntPtr]0)
        }
    }
    # Befehlsnummer von Transfer -> ... -> $Ziel; Postfacheintraege fuellt
    # Eudora erst beim Aufklappen (WM_INITMENUPOPUP), auch in Untermenues.
    function MenueSuche($haupt, $sub, [string] $Ziel, [int] $tiefe) {
        if ($tiefe -gt 3) { return 0 }
        [void](Snd $haupt 0x0117 $sub ([IntPtr]0))
        for ($j = 0; $j -lt [E122]::GetMenuItemCount($sub); $j++) {
            $t = New-Object Text.StringBuilder 128
            [void][E122]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
            $name = $t.ToString() -replace '&', ''
            $unter = [E122]::GetSubMenu($sub, $j)
            if ($unter -ne [IntPtr]::Zero) { $id = MenueSuche $haupt $unter $Ziel ($tiefe + 1); if ($id) { return $id } }
            elseif ($name -eq $Ziel) { return [int][E122]::GetMenuItemID($sub, $j) }
        }
        return 0
    }
    function TransferNach($haupt, [string] $Ziel) {
        $m = [E122]::GetMenu($haupt)
        for ($i = 0; $i -lt [E122]::GetMenuItemCount($m); $i++) {
            $s = New-Object Text.StringBuilder 128
            [void][E122]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
            if (($s.ToString() -replace '&', '') -ne 'Transfer') { continue }
            return (MenueSuche $haupt ([E122]::GetSubMenu($m, $i)) $Ziel 0)
        }
        return 0
    }

    $proz = Get-Process Eudora -ErrorAction SilentlyContinue |
            Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
    if (-not $proz) { throw "keine Eudora aus $voll" }
    $pp = $proz[0].Id
    $haupt = Alle $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' } | Select-Object -First 1
    if (-not $haupt) { throw 'kein Hauptfenster' }
    $mdi = Alle $pp | Where-Object { $_.Klasse -eq 'MDIClient' } | Select-Object -First 1
    if (-not $mdi) { throw 'kein MDIClient' }

    # 1. Pruefserver
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $belegt = @(Get-NetTCPConnection -LocalPort 1143 -State Listen -ErrorAction SilentlyContinue)
    if ($belegt.Count -gt 0) { throw ('Port 1143 belegt von Prozess ' + (($belegt | ForEach-Object { $_.OwningProcess }) -join ',')) }
    $srvArgs = @("$repo\tools\imap-pruefserver.pl", '--port', '1143', '--protokoll', $srvlog, '--zeitschranke', [string](60 + 4 * $Warten),
                 '--nachrichten', '1', '--ablage', $ablage)
    $srv = Start-Process $perl -ArgumentList $srvArgs -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Start-Sleep -Seconds 2
    Dialoge $pp
    Start-Sleep -Seconds 1

    # 2. lokales In
    [void][E122]::PostMessageA($haupt.H, 0x0111, [IntPtr]32792, [IntPtr]::Zero)        # ID_MAILBOX_IN
    Start-Sleep -Seconds 3
    Dialoge $pp
    $aktiv = Snd $mdi.H 0x0229 ([IntPtr]::Zero) ([IntPtr]::Zero)                       # WM_MDIGETACTIVE
    Write-Host ('E122 aktives Fenster: "' + (Txt $aktiv) + '"')
    $script:lb = [IntPtr]::Zero
    $cc = [E122+EP]{ param($k, $q); if ($script:lb -eq [IntPtr]::Zero -and (Kl $k) -eq 'ListBox' -and [E122]::IsWindowVisible($k)) { $script:lb = $k }; return $true }
    [void][E122]::EnumChildWindows($aktiv, $cc, [IntPtr]::Zero)
    if ($script:lb -eq [IntPtr]::Zero) { throw 'keine Liste im In-Fenster' }
    $anzahl = [int](Snd $script:lb 0x018B ([IntPtr]0) ([IntPtr]0))                      # LB_GETCOUNT
    Write-Host "E122 In-Zeilen: $anzahl"
    if ($anzahl -ne $proben.Count) { throw ("In sollte genau {0} Zeilen haben" -f $proben.Count) }
    [void](Snd $script:lb 0x0185 ([IntPtr]1) ([IntPtr](-1)))                            # LB_SETSEL TRUE, alle
    Write-Host ('E122 markiert: ' + [int](Snd $script:lb 0x0190 ([IntPtr]0) ([IntPtr]0)))   # LB_GETSELCOUNT

    # 3. Transfer -> Ablage (IMAP-Konto)
    $id = TransferNach $haupt.H 'Ablage'
    if (-not $id) { throw 'Eintrag "Ablage" im Menue Transfer nicht gefunden' }
    Write-Host "E122 Transfer-Befehl $id"
    [void][E122]::PostMessageA($aktiv, 0x0111, [IntPtr]$id, [IntPtr]::Zero)
    Start-Sleep -Seconds $Warten
    Dialoge $pp
    Start-Sleep -Seconds $Warten

    # 4. Fenster schliessen, lebt Eudora noch?
    foreach ($k in @(Alle $pp | Where-Object { $_.Vis -and [E122]::GetParent($_.H) -eq $mdi.H })) {
        Write-Host ('E122 schliesse "' + (Txt $k.H) + '"'); [void][E122]::PostMessageA($k.H, 0x0010, [IntPtr]0, [IntPtr]0)
    }
    Start-Sleep -Seconds 3
    Dialoge $pp
    $r = [IntPtr]::Zero
    $antwortet = [E122]::SendMessageTimeoutA($haupt.H, 0x0000, [IntPtr]0, [IntPtr]0, 0x0002, 5000, [ref]$r)   # WM_NULL
    $p2 = Get-Process -Id $pp -ErrorAction SilentlyContinue
    if ($p2 -and -not $p2.HasExited -and $antwortet -ne [IntPtr]::Zero) { $lebt = 1 }
}
catch {
    Write-Host ('E122 FEHLER: ' + $_.Exception.Message)
}
finally {
    try { Start-Sleep -Seconds 1; if ($srv -and -not $srv.HasExited) { Stop-Process -Id $srv.Id -Force } } catch { Write-Host ('E122 FEHLER beim Beenden des Servers: ' + $_.Exception.Message) }
}

# 5. Auswerten
try {
    $prot = @(); if (Test-Path $srvlog) { $prot = @(Get-Content -LiteralPath $srvlog) }
    $appends = @($prot | Where-Object { $_ -match '<- \S+ APPEND ' })
    foreach ($z in $appends) { Write-Host ('E122 SERVER ' + $z) }
    $dateien = @(); if (Test-Path $ablage) { $dateien = @(Get-ChildItem -LiteralPath $ablage -Filter 'append-*.eml' | Sort-Object Name) }
    for ($i = 0; $i -lt [Math]::Max($appends.Count, $dateien.Count); $i++) {
        $kopf = '(keiner)'; $intern = '(keines)'
        if ($i -lt $dateien.Count) {
            $dz = [IO.File]::ReadAllLines($dateien[$i].FullName, [Text.Encoding]::GetEncoding(28591)) | Where-Object { $_ -match '^Date:\s*(.*)$' } | Select-Object -First 1
            if ($dz -and $dz -match '^Date:\s*(.*)$') { $kopf = $Matches[1].Trim() }
        }
        if ($i -lt $appends.Count -and $appends[$i] -match '"(\s?\d{1,2}-[A-Za-z]{3}-\d{4} \d\d:\d\d:\d\d [+-]\d{4})"') { $intern = $Matches[1].Trim() }
        $nachrichten++
        $a = AlsZeit $kopf; $b = AlsZeit $intern
        $diff = '?'
        if ($a -and $b) {
            $diff = [int]($b.UtcDateTime - $a.UtcDateTime).TotalMinutes
            if ($diff -eq 0) { $passt++ } else { $verschoben++ }
        }
        Write-Host ('E122 NACHRICHT date="{0}" internaldate="{1}" differenz-min={2}' -f $kopf, $intern, $diff)
    }
    $log = Join-Path $md 'eudora.log'
    if (Test-Path $log) {
        foreach ($z in (Get-Content -LiteralPath $log | Where-Object { $_ -match 'E-122' })) { Write-Host ('E122 LOG ' + $z) }
    }
}
catch {
    Write-Host ('E122 FEHLER beim Auswerten: ' + $_.Exception.Message)
}
Write-Host ("E122 ERGEBNIS nachrichten={0} passt={1} verschoben={2} lebt={3}" -f $nachrichten, $passt, $verschoben, $lebt)
exit 0
