# messen-e141.ps1 - stoesst eine Uebertragung aus einem IMAP-Ordner nach Out
# die IMAP-Nachbearbeitung an, obwohl sie nichts bewegt hat? (Befund E-141)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, bekommt von dort
# -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem Pfad.
#
# WARUM ES DAS GIBT. In CTocDoc::Xfer (tocdoc.cpp) bleibt sumlist bei jeder
# Uebertragung nach Out leer; die alte Bedingung "IsImapToc() || (Ziel IMAP
# && sumlist > 0)" rief ImapXfer trotzdem, und ImapXferMessages meldete
# "No messages were transferred!" (IDS_ERR_IMAP_NO_MSGS_XFERRED,
# ImapToc.cpp) - dazu Serververbindung und gegebenenfalls EXPUNGE. Seit
# 30.10.2026 (ca1b455b) gilt die Anzahlpruefung fuer beide Seiten.
#
# DER WEG, DER DAS TRIFFT. Empfangene Post aus IMAP nach Out lehnt schon
# E-125 ab (dann laeuft die Nachbearbeitung gar nicht). Getroffen wird der
# Fehler nur mit einem ENTWURF im IMAP-Ordner, der noch als Entwurf gilt
# (Gregors Weg vom 23.10.2026, E-142): Entwurf aus Out in den IMAP-Ordner
# "Ablage" uebertragen, von dort zurueck nach Out, die E-142-Rueckfrage mit
# Yes beantworten (BM_CLICK an den gemessenen Knopf, kein Tastendruck).
#
# GEGENPROBE (BEFUNDE E-141 "MUSS"): IMAP -> lokal und Loeschen aus einem
# IMAP-Ordner muessen unveraendert laufen. Dazu im selben Lauf: INBOX (zwei
# Nachrichten vom Pruefserver) oeffnen, die erste nach dem lokalen "In"
# uebertragen, die zweite loeschen (ID_MESSAGE_DELETE, die Warnung "You
# haven't read all those messages" mit OK). Gemessen: das lokale In (In.toc)
# hat danach einen Eintrag, der Server sah \Deleted fuer beide (bis E-188; seit
# E-188, #220, nur fuer die zweite - die erste kam ohne Rumpf an und bleibt
# in der Quelle stehen, "E-188 Text nicht geladen, Quelle bleibt").
# lokal-mbx-byte ist die Groesse von In.mbx: der Pruefserver beantwortet
# "UID FETCH n (UID BODYSTRUCTURE)" ohne Daten, der Rumpf kommt also nicht
# an (Grenze des Pruefservers, gemessen 02.11.2026 an beiden Bauten gleich -
# siehe Befund).
#
# Ausgabe: Zeilen "E141 ...", darunter
#   E141 ERGEBNIS hochgeladen=<n> rueckfrage=<n> nicht-uebertragen=<n> expunge=<n> lokal=<n> lokal-mbx-byte=<n> geloescht=<n> lebt=<0|1>
# Erwartet mit der Behebung: hochgeladen=1 rueckfrage=1 nicht-uebertragen=0
# lokal=1 geloescht=1 lebt=1; am alten Bau nicht-uebertragen=1.
# hochgeladen und rueckfrage sind die Positivprobe: ohne sie ist
# nicht-uebertragen=0 kein Befund (Arbeitsweise/ausbleiben-ist-kein-befund.md).
#
# Vorbereiten (vor dem Start):
#   tools\messen-e141.ps1 -Vorbereiten -Pfadfilter C:\Temp\EM141
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [int] $Warten = 12
)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
$md = Join-Path $voll 'Mailverzeichnis'
$konto = Join-Path $md 'Imap\pruefimap'
$srvlog = Join-Path $voll 'imap-e141.log'
$ablage = Join-Path $voll 'ablage-e141'
$repo = Split-Path -Parent $PSScriptRoot

if ($Vorbereiten) {
    try {
        if ($voll -notmatch ('^' + [regex]::Escape($(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp' })) + '\\[^\\]+')) { Write-Host "E141 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
        if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E141 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
        if (-not (Test-Path $konto)) { Write-Host "E141 FEHLER: kein IMAP-Konto pruefimap in $voll"; exit 1 }
        # Out: genau ein Entwurf; In: leer. Ohne .toc baut Eudora neu auf.
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^(In|Out)\.(mbx|toc)(\.\d{3})?$' } | Remove-Item -Force
        $entwurf = "From ???@??? Mon Nov 02 18:00:00 2026`r`nTo: empfaenger@e141.invalid`r`nFrom: pruef@127.0.0.1`r`nSubject: E-141 Entwurf`r`nX-Attachments: `r`n`r`nE-141 Entwurfstext.`r`n`r`n"
        [IO.File]::WriteAllBytes((Join-Path $md 'Out.mbx'), [Text.Encoding]::ASCII.GetBytes($entwurf))
        [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]@())
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
        [IO.File]::WriteAllLines($ini, [string[]]($z | Where-Object { $_ -notmatch '^OpenWindow[0-9]+=' }), [Text.Encoding]::GetEncoding(1252))
        Write-Host "E141 vorbereitet: $md (Out.mbx mit einem Entwurf, In.mbx leer)"
        exit 0
    } catch { Write-Host ('E141 FEHLER beim Vorbereiten: ' + $_.Exception.Message); exit 1 }
}

$hochgeladen = 0; $rueckfrage = 0; $nichtUebertragen = 0; $expunge = 0; $lokal = 0; $geloescht = 0; $lebt = 0; $lokalMbx = -1
$srv = $null; $hp = [IntPtr]::Zero; $fern = [IntPtr]::Zero
$dialogTexte = New-Object System.Collections.ArrayList
try {
    Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E141 {
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
    function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E141]::GetClassName($h, $s, 256); $s.ToString() }
    function Txt($h) { $s = New-Object Text.StringBuilder 512; [void][E141]::GetWindowTextA($h, $s, 512); $s.ToString() }
    function Snd($h, $m, $w, $l, $ms = 5000) { $r = [IntPtr]::Zero; [void][E141]::SendMessageTimeoutA($h, $m, $w, $l, 0x0002, $ms, [ref]$r); return $r }
    function Alle($pp) {
        $r = New-Object System.Collections.ArrayList
        $cb = [E141+EP]{ param($h, $p); $o = 0; [void][E141]::GetWindowThreadProcessId($h, [ref]$o)
            if ($o -eq $pp) {
                $cc = [E141+EP]{ param($k, $q)
                    [void]$r.Add([pscustomobject]@{ H = $k; Id = [E141]::GetDlgCtrlID($k); Klasse = (Kl $k); Vis = [E141]::IsWindowVisible($k) })
                    return $true }
                [void][E141]::EnumChildWindows($h, $cc, [IntPtr]::Zero)
                [void]$r.Add([pscustomobject]@{ H = $h; Id = [E141]::GetDlgCtrlID($h); Klasse = (Kl $h); Vis = [E141]::IsWindowVisible($h) })
            }
            return $true }
        [void][E141]::EnumWindows($cb, [IntPtr]::Zero); return $r
    }
    # Jeder sichtbare Dialog wird mitgeschrieben. Die E-142-Rueckfrage
    # ("Transfer anyway?") bekommt BM_CLICK auf ihren Knopf "Yes", alle
    # anderen WM_CLOSE.
    function Dialoge($pp) {
        foreach ($d in (Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' -and ([E141]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) {
            $script:inhalt = @(); $script:ja = [IntPtr]::Zero
            $cc = [E141+EP]{ param($k, $q); $t = Txt $k; if ($t) { $script:inhalt += $t }; if (@('Yes', 'OK') -contains ($t -replace '&', '')) { if ($script:ja -eq [IntPtr]::Zero -or ($t -replace '&', '') -eq 'Yes') { $script:ja = $k } }; return $true }
            [void][E141]::EnumChildWindows($d.H, $cc, [IntPtr]::Zero)
            $text = ($script:inhalt -join ' | ')
            [void]$dialogTexte.Add($text)
            Write-Host ("E141 DIALOG '{0}': {1}" -f (Txt $d.H), $text)
            if (($text -match 'Transfer anyway' -or $text -match 'read all those messages') -and $script:ja -ne [IntPtr]::Zero) {
                Write-Host ('E141 bestaetigt: ' + (Txt $script:ja))
                [void][E141]::PostMessageA($script:ja, 0x00F5, [IntPtr]0, [IntPtr]0)       # BM_CLICK
            } else {
                [void][E141]::PostMessageA($d.H, 0x0010, [IntPtr]0, [IntPtr]0)
            }
        }
    }
    function Warte([int] $s) { for ($i = 0; $i -lt $s; $i++) { Start-Sleep -Seconds 1; Dialoge $script:pp } }

    $proz = Get-Process Eudora -ErrorAction SilentlyContinue |
            Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
    if (-not $proz) { throw "keine Eudora aus $voll" }
    $script:pp = $proz[0].Id; $pp = $script:pp
    $haupt = Alle $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' } | Select-Object -First 1
    if (-not $haupt) { throw 'kein Hauptfenster' }
    $mdi = Alle $pp | Where-Object { $_.Klasse -eq 'MDIClient' } | Select-Object -First 1
    if (-not $mdi) { throw 'kein MDIClient' }

    # Pruefserver: INBOX mit zwei Nachrichten, APPEND in die Ablage
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $belegt = @(Get-NetTCPConnection -LocalPort 1143 -State Listen -ErrorAction SilentlyContinue)
    if ($belegt.Count -gt 0) { throw ('Port 1143 belegt von Prozess ' + (($belegt | ForEach-Object { $_.OwningProcess }) -join ',')) }
    $srvArgs = @("$repo\tools\imap-pruefserver.pl", '--port', '1143', '--protokoll', $srvlog, '--zeitschranke', [string](90 + 8 * $Warten),
                 '--nachrichten', '2', '--ablage', $ablage)
    $srv = Start-Process $perl -ArgumentList $srvArgs -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Warte 3

    function MenueSuche($sub, [string] $Ziel, [int] $tiefe) {
        if ($tiefe -gt 3) { return 0 }
        [void](Snd $haupt.H 0x0117 $sub ([IntPtr]0))
        for ($j = 0; $j -lt [E141]::GetMenuItemCount($sub); $j++) {
            $t = New-Object Text.StringBuilder 128
            [void][E141]::GetMenuStringA($sub, [uint32]$j, $t, 128, 0x400)
            $name = $t.ToString() -replace '&', ''
            $unter = [E141]::GetSubMenu($sub, $j)
            if ($unter -ne [IntPtr]::Zero) { $id = MenueSuche $unter $Ziel ($tiefe + 1); if ($id) { return $id } }
            elseif ($name -eq $Ziel) { return [int][E141]::GetMenuItemID($sub, $j) }
        }
        return 0
    }
    function TransferNach([string] $Ziel) {
        $m = [E141]::GetMenu($haupt.H)
        for ($i = 0; $i -lt [E141]::GetMenuItemCount($m); $i++) {
            $s = New-Object Text.StringBuilder 128
            [void][E141]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
            if (($s.ToString() -replace '&', '') -ne 'Transfer') { continue }
            return (MenueSuche ([E141]::GetSubMenu($m, $i)) $Ziel 0)
        }
        return 0
    }
    function Liste($fenster) {
        $script:lb = [IntPtr]::Zero
        $cc = [E141+EP]{ param($k, $q); if ($script:lb -eq [IntPtr]::Zero -and (Kl $k) -eq 'ListBox' -and [E141]::IsWindowVisible($k)) { $script:lb = $k }; return $true }
        [void][E141]::EnumChildWindows($fenster, $cc, [IntPtr]::Zero)
        return $script:lb
    }
    function ErsteWaehlen($fenster, [string] $wo) {
        $lb = Liste $fenster
        if ($lb -eq [IntPtr]::Zero) { throw "keine Liste im Fenster $wo" }
        $n = [int](Snd $lb 0x018B ([IntPtr]0) ([IntPtr]0))
        [void](Snd $lb 0x0185 ([IntPtr]0) ([IntPtr](-1)))
        [void](Snd $lb 0x0185 ([IntPtr]1) ([IntPtr]0))
        [void](Snd $lb 0x019E ([IntPtr]0) ([IntPtr]0))
        Write-Host ("E141 {0}: {1} Zeile(n), markiert {2}" -f $wo, $n, [int](Snd $lb 0x0190 ([IntPtr]0) ([IntPtr]0)))
        return $n
    }
    function Aktiv() { return (Snd $mdi.H 0x0229 ([IntPtr]::Zero) ([IntPtr]::Zero)) }
    function AlleSchliessen() {
        foreach ($k in @(Alle $pp | Where-Object { $_.Vis -and [E141]::GetParent($_.H) -eq $mdi.H })) {
            Write-Host ('E141 schliesse "' + (Txt $k.H) + '"'); [void][E141]::PostMessageA($k.H, 0x0010, [IntPtr]0, [IntPtr]0)
        }
        Warte 4
    }

    # Postfachbaum, um IMAP-Ordner zu oeffnen (wie messen-e184.ps1)
    $TVM_EXPAND = 0x1102; $TVM_GETNEXT = 0x110A; $TVM_SELECT = 0x110B; $TVM_GETITEM = 0x110C
    $hp = [E141]::OpenProcess(0x0438, $false, [uint32]$pp)
    $fern = [E141]::VirtualAllocEx($hp, [IntPtr]::Zero, 4096, 0x3000, 0x04)
    function Text($baum, $item) {
        $tv = New-Object byte[] 40
        [BitConverter]::GetBytes([int]0x11).CopyTo($tv, 0)
        [BitConverter]::GetBytes([int]$item.ToInt64()).CopyTo($tv, 4)
        [BitConverter]::GetBytes([int]($fern.ToInt64() + 64)).CopyTo($tv, 16)
        [BitConverter]::GetBytes([int]256).CopyTo($tv, 20)
        $w = [IntPtr]::Zero
        [void][E141]::WriteProcessMemory($hp, $fern, $tv, 40, [ref]$w)
        [void](Snd $baum $TVM_GETITEM ([IntPtr]0) $fern)
        $b = New-Object byte[] 256
        [void][E141]::ReadProcessMemory($hp, [IntPtr]($fern.ToInt64() + 64), $b, 256, [ref]$w)
        $n = [Array]::IndexOf($b, [byte]0); if ($n -lt 0) { $n = 256 }
        return [Text.Encoding]::GetEncoding(1252).GetString($b, 0, $n)
    }
    function Kinder($baum, $item) {
        $aus = @(); $k = Snd $baum $TVM_GETNEXT ([IntPtr]4) $item
        while ($k -ne [IntPtr]::Zero) { $aus += $k; $k = Snd $baum $TVM_GETNEXT ([IntPtr]1) $k }
        return $aus
    }
    function AlleKnoten($baum, $item, [int] $tiefe) {
        $aus = @(); if ($tiefe -gt 4) { return $aus }
        [void](Snd $baum $TVM_EXPAND ([IntPtr]2) $item)
        foreach ($k in (Kinder $baum $item)) { $aus += $k; $aus += AlleKnoten $baum $k ($tiefe + 1) }
        return $aus
    }
    $baum = Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq 'SysTreeView32' -and ($_.Id -eq 1016 -or $_.Id -eq 1042) } | Select-Object -First 1
    if (-not $baum) {
        [void][E141]::PostMessageA($haupt.H, 0x0111, [IntPtr]32827, [IntPtr]::Zero)   # ID_WINDOW_MAILBOXES
        Warte 3
        $baum = Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq 'SysTreeView32' -and ($_.Id -eq 1016 -or $_.Id -eq 1042) } | Select-Object -First 1
    }
    if (-not $baum) { throw 'Postfachbaum nicht gefunden' }
    $knoten = @(); $w = Snd $baum.H $TVM_GETNEXT ([IntPtr]0) ([IntPtr]0)
    while ($w -ne [IntPtr]::Zero) { $knoten += $w; $knoten += AlleKnoten $baum.H $w 0; $w = Snd $baum.H $TVM_GETNEXT ([IntPtr]1) $w }
    $script:kontoKnoten = [IntPtr]::Zero
    foreach ($k in $knoten) {
        if ((Text $baum.H $k) -ne 'Ablage') { continue }
        $eltern = Snd $baum.H $TVM_GETNEXT ([IntPtr]3) $k
        if ($eltern -ne [IntPtr]::Zero -and (Text $baum.H $eltern) -ne 'Recent') { $script:kontoKnoten = $eltern; break }
    }
    if ($script:kontoKnoten -eq [IntPtr]::Zero) { throw 'Kontoknoten von "Ablage" nicht gefunden' }
    function KontoOeffnen([string[]] $wer) {
        $z = @(Kinder $baum.H $script:kontoKnoten | Where-Object { $wer -contains (Text $baum.H $_) }) | Select-Object -First 1
        if (-not $z) { throw ('Ordner ' + ($wer -join '/') + ' nicht unter dem Konto') }
        Write-Host ('E141 oeffne "' + (Text $baum.H $z) + '" im Konto')
        [void](Snd $baum.H $TVM_SELECT ([IntPtr]9) $z)
        [void][E141]::PostMessageA($baum.H, 0x0111, [IntPtr]32914, [IntPtr]::Zero)      # ID_MBOXTREE_OPEN
        Warte $Warten
        return (Aktiv)
    }

    # 1. Entwurf aus Out in den IMAP-Ordner Ablage
    [void][E141]::PostMessageA($haupt.H, 0x0111, [IntPtr]32793, [IntPtr]::Zero)          # ID_MAILBOX_OUT
    Warte 3
    $out = Aktiv
    Write-Host ('E141 aktives Fenster: "' + (Txt $out) + '"')
    if ((ErsteWaehlen $out 'Out') -ne 1) { throw 'Out sollte genau einen Entwurf haben' }
    $id = TransferNach 'Ablage'
    if (-not $id) { throw 'Eintrag "Ablage" im Menue Transfer nicht gefunden' }
    [void][E141]::PostMessageA($out, 0x0111, [IntPtr]$id, [IntPtr]::Zero)
    Warte $Warten
    AlleSchliessen

    # 2. Ablage oeffnen, den Entwurf zurueck nach Out
    $abl = KontoOeffnen @('Ablage')
    if ((ErsteWaehlen $abl 'Ablage') -lt 1) { throw 'Ablage ist leer - der Entwurf kam nicht an' }
    $script:vorRueck = $dialogTexte.Count
    $id = TransferNach 'Out'
    if (-not $id) { throw 'Eintrag "Out" im Menue Transfer nicht gefunden' }
    Write-Host "E141 Transfer nach Out, Befehl $id"
    [void][E141]::PostMessageA($abl, 0x0111, [IntPtr]$id, [IntPtr]::Zero)
    Warte (2 * $Warten)
    $script:nachRueck = $dialogTexte.Count
    AlleSchliessen

    # 3. Gegenprobe: INBOX -> lokales In, dann loeschen
    $inbox = KontoOeffnen @('INBOX', 'Inbox', 'In')
    if ((ErsteWaehlen $inbox 'INBOX') -ne 2) { throw 'INBOX sollte genau zwei Nachrichten haben' }
    $id = TransferNach 'In'
    if (-not $id) { throw 'Eintrag "In" im Menue Transfer nicht gefunden' }
    [void][E141]::PostMessageA($inbox, 0x0111, [IntPtr]$id, [IntPtr]::Zero)
    Warte $Warten
    $inbox = Aktiv
    [void](ErsteWaehlen $inbox 'INBOX nach dem Verschieben')
    [void][E141]::PostMessageA($inbox, 0x0111, [IntPtr]32805, [IntPtr]::Zero)            # ID_MESSAGE_DELETE
    Warte $Warten
    AlleSchliessen

    $r = [IntPtr]::Zero
    $antwortet = [E141]::SendMessageTimeoutA($haupt.H, 0x0000, [IntPtr]0, [IntPtr]0, 0x0002, 5000, [ref]$r)
    $p2 = Get-Process -Id $pp -ErrorAction SilentlyContinue
    if ($p2 -and -not $p2.HasExited -and $antwortet -ne [IntPtr]::Zero) { $lebt = 1 }
}
catch { Write-Host ('E141 FEHLER: ' + $_.Exception.Message) }
finally {
    try { if ($fern -ne [IntPtr]::Zero) { [void][E141]::VirtualFreeEx($hp, $fern, 0, 0x8000) }; if ($hp -ne [IntPtr]::Zero) { [void][E141]::CloseHandle($hp) } } catch {}
    try { Start-Sleep -Seconds 1; if ($srv -and -not $srv.HasExited) { Stop-Process -Id $srv.Id -Force } } catch { Write-Host ('E141 FEHLER beim Beenden des Servers: ' + $_.Exception.Message) }
}

# Auswerten
try {
    $prot = @(); if (Test-Path $srvlog) { $prot = @(Get-Content -LiteralPath $srvlog) }
    foreach ($z in ($prot | Where-Object { $_ -match 'APPEND|COPY|EXPUNGE|!!|STORE' })) { Write-Host ('E141 SERVER ' + $z) }
    $hochgeladen = @($prot | Where-Object { $_ -match '<- \S+ APPEND ' }).Count
    $expunge = @($prot | Where-Object { $_ -match 'EXPUNGE VERLANGT' }).Count
    $geloescht = @($prot | Where-Object { $_ -match 'LOESCHEN VERLANGT' }).Count
    $rueckfrage = @($dialogTexte | Where-Object { $_ -match 'Transfer anyway' }).Count
    $nichtUebertragen = @($dialogTexte | Where-Object { $_ -match 'No messages were transferred' }).Count
    $lokalMbx = -1
    $intoc = Join-Path $md 'In.toc'
    if (Test-Path $intoc) { $g = (Get-Item -LiteralPath $intoc).Length; if ($g -ge 104 -and (($g - 104) % 218) -eq 0) { $lokal = ($g - 104) / 218 } }
    $in = Join-Path $md 'In.mbx'
    if (Test-Path $in) { $lokalMbx = (Get-Item -LiteralPath $in).Length }
    $log = Join-Path $md 'eudora.log'
    if (Test-Path $log) { foreach ($z in (Get-Content -LiteralPath $log | Where-Object { $_ -match 'E-142|E-125|E-121|No messages were transferred' })) { Write-Host ('E141 LOG ' + $z) } }
} catch { Write-Host ('E141 FEHLER beim Auswerten: ' + $_.Exception.Message) }
Write-Host ("E141 ERGEBNIS hochgeladen={0} rueckfrage={1} nicht-uebertragen={2} expunge={3} lokal={4} lokal-mbx-byte={7} geloescht={5} lebt={6}" -f $hochgeladen, $rueckfrage, $nichtUebertragen, $expunge, $lokal, $geloescht, $lebt, $lokalMbx)
exit 0
