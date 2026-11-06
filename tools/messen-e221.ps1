# messen-e221.ps1 - Befund E-221: der Betreff verliert in der Postfachliste
# seine ersten sieben Zeichen, wenn die Kopfzeile direkt hinter "Subject:"
# gefaltet ist.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# bekommt -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem
# Pfad. Pruefstaende: C:\Temp\E221 (Kopie von C:\Temp\E128) und
# C:\Temp\E221-alt (Kopie von C:\Temp\E128-alt); POP-Konto auf
# 127.0.0.1:11110, SMTP auf 127.0.0.1:1025.
#
# DIE ZWEI HAELFTEN, die beide gemessen werden:
#   1. SENDEN. Encode2047 (sendmail.cpp) faltet einen Betreff mit Umlauten so,
#      dass die erste Zeile nur "Subject: " traegt, wenn das erste kodierte
#      Wort die Zeile genau fuellt (Pruefung ">=" gegen ">"). Gesendet wird ein
#      Entwurf aus Out ueber tools\smtp-pruefserver.pl; gelesen werden die
#      Bytes, die ankommen.
#   2. EMPFANGEN. CSummary::Build (summary.cpp) liest bei leerer erster Zeile
#      die Folgezeile, schneidet aber auch dort 8 Zeichen ab - die Laenge von
#      "Subject:". Aus " test mit kopfzeile ..." wird "t kopfzeile ...".
#      Empfangen werden ueber den POP-Pruefserver drei Nachrichten:
#        kurz      ein kurzer Betreff mit Umlauten in einer Zeile (Positivprobe)
#        gefaltet  eine fertige Nachricht: "Subject:" + Zeilenumbruch +
#                  " =?iso-8859-1?Q?...?=" (so falten auch andere Programme)
#        gesendet  genau die Bytes, die Eudora unter 1. gesendet hat
#      Gelesen wird der Betreff, wie er in der Zusammenfassung (In.toc) steht.
#
# Ausgabe:
#   E221 GESENDET zeile1="<erste Zeile der Subject-Kopfzeile>" folgezeilen=<n>
#   E221 MBX <name> "<Subject-Zeilen in In.mbx, Nicht-ASCII als <xx>>"
#   E221 PROBE <name> betreff="<aus In.toc>" urteil=<heil|fehlen<n>|anders|fehlt>
#   E221 ERGEBNIS gesendet=<0|1> faltung=<doppelpunkt|wort|keine|-> kurz=<..> gefaltet=<..> gesendet-betreff=<..> lebt=<0|1>
# faltung=doppelpunkt heisst: die gesendete Subject-Zeile endet direkt hinter
# dem Doppelpunkt. Erwartet mit der Behebung: faltung=wort (oder keine),
# kurz=heil gefaltet=heil gesendet-betreff=heil.
#
# Testdaten sind erfunden (Gregor 03.11.2026: "keine daten aus den test ins
# github repo").
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [int] $Warten = 15
)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch ('^' + [regex]::Escape($(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp' })) + '\\[^\\]+')) { Write-Host "E221 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'
$ablage = Join-Path $voll 'ablage-e221'
$post = Join-Path $voll 'post'
$srvlog = Join-Path $voll 'smtp-e221.log'
$popPid = Join-Path $voll 'pop-pruefserver.pid'
$repo = Split-Path -Parent $PSScriptRoot
$lat = [Text.Encoding]::GetEncoding(28591)
$perl = 'C:\Program Files\Git\usr\bin\perl.exe'

# Umlaute im Quelltext als Platzhalter, damit die Datei ASCII bleibt.
function L([string] $s) {
    return $s.Replace('{a}', [string][char]0xE4).Replace('{o}', [string][char]0xF6).Replace('{u}', [string][char]0xFC).Replace('{s}', [string][char]0xDF)
}
# Der gesendete Betreff: 44 Zeichen, mehrere Woerter mit Umlauten und ss,
# ein " - ". Mit der alten Pruefung (">=") faltet Encode2047 ihn direkt
# hinter "Subject: " (am herausgezogenen Encode2047 gemessen, 03.11.2026).
$betreffGesendet = L 'test mit kopfzeile - {o}fter {u}ber gr{o}{s}e {a}u{s}ern'
$betreffGefaltet = L 'probe einer zeile - s{u}{s}e gr{u}{s}e sch{o}ne st{a}dte'
$betreffKurz     = L 'Re: kurz mit Umlauten {a}{o}{u}'

function Sichtbar([string] $s) {
    $aus = ''
    foreach ($ch in $s.ToCharArray()) { $c = [int]$ch; if ($c -ge 0x20 -and $c -lt 0x7F) { $aus += $ch } else { $aus += ('<{0:x2}>' -f $c) } }
    return $aus
}
function PopBeenden {
    if (-not (Test-Path -LiteralPath $popPid)) { return }
    $alt = [int](Get-Content -LiteralPath $popPid)
    $p = Get-Process -Id $alt -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Host "E221 POP-Pruefserver $alt beendet" }
    Remove-Item -LiteralPath $popPid -Force
}

if ($Vorbereiten) {
    try {
        $ini = Join-Path $md 'Eudora.ini'
        if (-not (Test-Path $ini)) { Write-Host "E221 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
        PopBeenden
        foreach ($n in 'Out', 'In', 'Trash', 'Junk') {
            Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } | Remove-Item -Force
        }
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^(e128-.*|e194-.*|e177-.*|lmos\.dat.*)$' } | Remove-Item -Force
        foreach ($d in 'spool', 'Embedded') { $p = Join-Path $md $d; if (Test-Path $p) { Get-ChildItem -LiteralPath $p -File | Remove-Item -Force } }
        $fp = Join-Path $md 'Filters.pce'; if (Test-Path $fp) { Remove-Item -LiteralPath $fp -Force }

        # Out mit EINEM Entwurf (Klartext), queued ueber eine Out.toc-Vorlage
        # wie in messen-e179.ps1: eine aus Out.mbx neu aufgebaute
        # Zusammenfassung waere "unsendable". Die Vorlage hat Eudora 7.2.1.131
        # am 02.11.2026 geschrieben (messen-e179.ps1); hier werden Laenge,
        # alte Mailboxgroesse, Empfaenger (gleich lang) und Betreff ersetzt.
        $entwurf = "From ???@??? Mon Nov 02 18:00:00 2026`r`nTo: empfaenger@e221.invalid`r`nFrom: e125@127.0.0.1`r`nSubject: " + $betreffGesendet + "`r`nX-Attachments: `r`n`r`nE-221 Pruefnachricht.`r`n`r`n"
        $mbxBytes = $lat.GetBytes($entwurf)
        [IO.File]::WriteAllBytes((Join-Path $md 'Out.mbx'), $mbxBytes)
        $toc = [Convert]::FromBase64String('MQAAAAAAAABPdXQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAIAAAAFAAUAA1Ap8B/////////////////////wIAAQAAAAAAAAAAAAAAjAAAAAAAAAAAAAAASgEAAAAAAQAAAAAASQEAAICz6GoHALwhAwAxODowMCAwMi4xMS4yMDI2AAAAAAAAAAAAAAAAkMHoamVtcGZhZW5nZXJAZTE3OS5pbnZhbGlkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABFLTE3OSBaZWljaGVuYW5nYWJlbgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//////////8AAAAAAAABAAAAAgABAAAAPAAAAAAAAQABAAAAAAAAAA==')
        if ($toc.Length -ne 322) { Write-Host "E221 FEHLER: TOC-Vorlage hat $($toc.Length) Byte statt 322"; exit 1 }
        $lang = $mbxBytes.Length
        [BitConverter]::GetBytes([int]($lang + 1)).CopyTo($toc, 96)     # OldMbxSize (Vorlage: Laenge + 1)
        [BitConverter]::GetBytes([int]$lang).CopyTo($toc, 108)          # m_Length des einzigen Datensatzes
        $an = $lat.GetBytes('empfaenger@e221.invalid')
        if ($lat.GetString($toc, 154, $an.Length) -ne 'empfaenger@e179.invalid') { Write-Host 'E221 FEHLER: TOC-Vorlage, Empfaengerfeld nicht an Byte 154'; exit 1 }
        $an.CopyTo($toc, 154)
        if ($lat.GetString($toc, 218, 20) -ne 'E-179 Zeichenangaben') { Write-Host 'E221 FEHLER: TOC-Vorlage, Betreffeld nicht an Byte 218'; exit 1 }
        for ($i = 0; $i -lt 64; $i++) { $toc[218 + $i] = 0 }
        $b = $lat.GetBytes($betreffGesendet); [Array]::Copy($b, 0, $toc, 218, [Math]::Min(63, $b.Length))
        Start-Sleep -Milliseconds 1100
        [IO.File]::WriteAllBytes((Join-Path $md 'Out.toc'), $toc)

        # Eudora.ini: SMTP auf den Pruefserver (wie messen-e179.ps1), POP wie messen-e128.ps1.
        $t = $lat.GetString([IO.File]::ReadAllBytes($ini))
        $t = [regex]::Replace($t, '(?m)^(SMTPPort|SSLSendUse|OpenWindow[0-9]+)=[^\r\n]*\r?\n', '')
        $t = [regex]::Replace($t, '(?m)^SMTPServer=[^\r\n]*', "SMTPServer=127.0.0.1`r`nSMTPPort=1025`r`nSSLSendUse=0")
        foreach ($kv in @(@('POPPort', '11110'), @('SSLReceiveUse', '0'), @('SavePassword', '1'), @('SavePasswordText', 'eA=='))) {
            $k = $kv[0]; $v = $kv[1]
            if ($t -match ('(?m)^' + $k + '=')) { $t = [regex]::Replace($t, ('(?m)^' + $k + '=[^\r\n]*'), ($k + '=' + $v)) }
            else { $t = $t -replace '(?m)^\[Settings\]\r?\n', ("[Settings]`r`n" + $k + '=' + $v + "`r`n") }
        }
        [IO.File]::WriteAllBytes($ini, $lat.GetBytes($t))

        # Die beiden fertigen Nachrichten fuer den POP-Pruefserver.
        if (Test-Path $post) { Get-ChildItem -LiteralPath $post -File | Remove-Item -Force } else { New-Item -ItemType Directory $post | Out-Null }
        $rumpf = "From: absender@e221.invalid`r`nTo: e125@127.0.0.1`r`nDate: Tue, 03 Nov 2026 15:00:00 +0100`r`nMIME-Version: 1.0`r`nContent-Type: text/plain; charset=us-ascii`r`n"
        $kurz = "Message-ID: <e221-kurz@e221.invalid>`r`n" + $rumpf + "Subject: Re: kurz mit =?iso-8859-1?Q?Umlauten_=E4=F6=FC?=`r`n`r`nE-221 Pruefnachricht (kurz).`r`n"
        $gef  = "Message-ID: <e221-gefaltet@e221.invalid>`r`n" + $rumpf + "Subject:`r`n =?iso-8859-1?Q?probe_einer_zeile_-_s=FC=DFe_gr=FC=DFe_sch=F6ne_st=E4dte?=`r`n`r`nE-221 Pruefnachricht (gefaltet).`r`n"
        [IO.File]::WriteAllBytes((Join-Path $post 'e221-1-kurz.eml'), $lat.GetBytes($kurz))
        [IO.File]::WriteAllBytes((Join-Path $post 'e221-2-gefaltet.eml'), $lat.GetBytes($gef))
        Remove-Item -LiteralPath $srvlog -Force -ErrorAction SilentlyContinue
        if (Test-Path $ablage) { Remove-Item -LiteralPath $ablage -Recurse -Force }
        foreach ($port in 1025, 11110) {
            if (Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue) { Write-Host "E221 FEHLER: Port $port ist belegt"; exit 1 }
        }
        Write-Host ("E221 vorbereitet: Out.mbx {0} Byte, SMTPPort=1025, POPPort=11110, zwei Nachrichten in {1}" -f $lang, $post)
        exit 0
    } catch { Write-Host ('E221 FEHLER beim Vorbereiten: ' + $_.Exception.Message); exit 1 }
}

try { Start-Transcript -Path (Join-Path $voll 'messen-e221.txt') -Force | Out-Null } catch { }

$gesendet = 0; $faltung = '-'; $lebt = 0
$urteil = [ordered]@{ kurz = 'fehlt'; gefaltet = 'fehlt'; gesendet = 'fehlt' }
$soll = @{ kurz = $betreffKurz; gefaltet = $betreffGefaltet; gesendet = $betreffGesendet }
$srv = $null
try {
    Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E221 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetWindowLongA(IntPtr h, int i);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint fl, uint ms, out IntPtr r);
}
"@
    function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E221]::GetClassName($h, $s, 256); $s.ToString() }
    function Txt($h) { $s = New-Object Text.StringBuilder 512; [void][E221]::GetWindowTextA($h, $s, 512); $s.ToString() }
    function Snd($h, $m, $w, $l, $ms = 5000) { $r = [IntPtr]::Zero; [void][E221]::SendMessageTimeoutA($h, $m, $w, $l, 0x0002, $ms, [ref]$r); return $r }
    function Alle($pp) {
        $r = New-Object System.Collections.ArrayList
        $cb = [E221+EP]{ param($h, $p); $o = 0; [void][E221]::GetWindowThreadProcessId($h, [ref]$o)
            if ($o -eq $pp) {
                $cc = [E221+EP]{ param($k, $q); [void]$r.Add([pscustomobject]@{ H = $k; Klasse = (Kl $k); Vis = [E221]::IsWindowVisible($k) }); return $true }
                [void][E221]::EnumChildWindows($h, $cc, [IntPtr]::Zero)
                [void]$r.Add([pscustomobject]@{ H = $h; Klasse = (Kl $h); Vis = [E221]::IsWindowVisible($h) })
            }
            return $true }
        [void][E221]::EnumWindows($cb, [IntPtr]::Zero); return $r
    }
    function Dialoge($pp) {
        foreach ($d in (Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' -and ([E221]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) {
            $script:inhalt = @(); $cc = [E221+EP]{ param($k, $q); $t = Txt $k; if ($t) { $script:inhalt += $t }; return $true }
            [void][E221]::EnumChildWindows($d.H, $cc, [IntPtr]::Zero)
            Write-Host ("E221 DIALOG '{0}': {1}" -f (Txt $d.H), ($script:inhalt -join ' | '))
            [void][E221]::PostMessageA($d.H, 0x0010, [IntPtr]0, [IntPtr]0)
        }
    }
    function Warte([int] $s) { for ($i = 0; $i -lt $s; $i++) { Start-Sleep -Seconds 1; Dialoge $script:pp } }
    function Liste($fenster) {
        $script:lb = [IntPtr]::Zero
        $cc = [E221+EP]{ param($k, $q); if ($script:lb -eq [IntPtr]::Zero -and (Kl $k) -eq 'ListBox' -and [E221]::IsWindowVisible($k)) { $script:lb = $k }; return $true }
        [void][E221]::EnumChildWindows($fenster, $cc, [IntPtr]::Zero)
        return $script:lb
    }

    $proz = Get-Process Eudora -ErrorAction SilentlyContinue |
            Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
    if (-not $proz) { throw "keine Eudora aus $voll" }
    $script:pp = $proz[0].Id; $pp = $script:pp
    $haupt = Alle $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' } | Select-Object -First 1
    if (-not $haupt) { throw 'kein Hauptfenster' }
    $mdi = Alle $pp | Where-Object { $_.Klasse -eq 'MDIClient' } | Select-Object -First 1
    if (-not $mdi) { throw 'kein MDIClient' }
    Write-Host "E221 Prozess $pp Hauptfenster $($haupt.H)"

    # --- 1. Senden ----------------------------------------------------------
    $srv = Start-Process $perl -ArgumentList @("$repo\tools\smtp-pruefserver.pl", '--port', '1025', '--ablage', $ablage, '--protokoll', $srvlog, '--zeitschranke', [string](60 + 4 * $Warten)) -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Warte 3
    [void][E221]::PostMessageA($haupt.H, 0x0111, [IntPtr]32793, [IntPtr]::Zero)          # ID_MAILBOX_OUT
    Warte 3
    $out = Snd $mdi.H 0x0229 ([IntPtr]::Zero) ([IntPtr]::Zero)                         # WM_MDIGETACTIVE
    $lb = Liste $out
    if ($lb -eq [IntPtr]::Zero) { throw 'keine Liste im Out-Fenster' }
    $n = [int](Snd $lb 0x018B ([IntPtr]0) ([IntPtr]0))
    if ($n -ne 1) { throw "Out hat $n Zeilen statt 1" }
    [void][E221]::PostMessageA($haupt.H, 0x0111, [IntPtr]32771, [IntPtr]::Zero)         # ID_FILE_SENDQUEUEDMESSAGES
    $datei = $null
    for ($i = 0; $i -lt $Warten -and -not $datei; $i++) {
        Warte 1
        if (Test-Path $ablage) { $datei = Get-ChildItem -LiteralPath $ablage -Filter 'smtp-*.eml' | Sort-Object Name | Select-Object -First 1 }
    }
    Warte 2
    [void][E221]::PostMessageA($out, 0x0010, [IntPtr]0, [IntPtr]0)
    Warte 2
    if ($srv -and -not $srv.HasExited) { Stop-Process -Id $srv.Id -Force; $srv = $null }

    $mails = @((Join-Path $post 'e221-1-kurz.eml'), (Join-Path $post 'e221-2-gefaltet.eml'))
    if ($datei) {
        $gesendet = 1
        $roh = $lat.GetString([IO.File]::ReadAllBytes($datei.FullName))
        $m = [regex]::Match($roh, '(?m)^Subject:([^\r\n]*)\r?\n((?:[ \t][^\r\n]*\r?\n)*)')
        if ($m.Success) {
            $z1 = $m.Groups[1].Value; $folge = @($m.Groups[2].Value -split "\r?\n" | Where-Object { $_ }).Count
            Write-Host ('E221 GESENDET zeile1="Subject:{0}" folgezeilen={1}' -f (Sichtbar $z1), $folge)
            foreach ($f in @($m.Groups[2].Value -split "\r?\n" | Where-Object { $_ })) { Write-Host ('E221 GESENDET folge="{0}"' -f (Sichtbar $f)) }
            if ($z1.Trim() -eq '' -and $folge -gt 0) { $faltung = 'doppelpunkt' } elseif ($folge -gt 0) { $faltung = 'wort' } else { $faltung = 'keine' }
        } else { Write-Host 'E221 GESENDET keine Subject-Zeile' }
        $ziel = Join-Path $post 'e221-3-gesendet.eml'
        Copy-Item -LiteralPath $datei.FullName -Destination $ziel -Force
        $mails += $ziel
    } else { Write-Host 'E221 GESENDET nichts angekommen' }

    # --- 2. Empfangen -------------------------------------------------------
    $arg = @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml')
    foreach ($e in $mails) { $arg += '--eml'; $arg += $e }
    $pop = Start-Process $perl -ArgumentList $arg -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $popPid -Value $pop.Id -Encoding ascii
    Warte 2
    [void][E221]::PostMessageA($haupt.H, 0x0111, [IntPtr]32792, [IntPtr]::Zero)         # ID_MAILBOX_IN
    Warte 2
    $in = Snd $mdi.H 0x0229 ([IntPtr]::Zero) ([IntPtr]::Zero)
    $lbIn = Liste $in
    [void][E221]::PostMessageA($haupt.H, 0x0111, [IntPtr]32772, [IntPtr]::Zero)         # ID_FILE_CHECKMAIL
    for ($i = 0; $i -lt 30; $i++) {
        Warte 1
        if ($lbIn -ne [IntPtr]::Zero -and [int](Snd $lbIn 0x018B ([IntPtr]0) ([IntPtr]0)) -ge $mails.Count) { break }
    }
    Warte 2
    PopBeenden
    if ($lbIn -ne [IntPtr]::Zero) { Write-Host ('E221 In-Liste: {0} Zeilen' -f [int](Snd $lbIn 0x018B ([IntPtr]0) ([IntPtr]0))) }
    # Das Postfachfenster schliessen, damit Eudora In.toc schreibt.
    [void][E221]::PostMessageA($in, 0x0010, [IntPtr]0, [IntPtr]0)
    Warte 3
    $r = [IntPtr]::Zero
    $antwortet = [E221]::SendMessageTimeoutA($haupt.H, 0x0000, [IntPtr]0, [IntPtr]0, 0x0002, 5000, [ref]$r)
    $p2 = Get-Process -Id $pp -ErrorAction SilentlyContinue
    if ($p2 -and -not $p2.HasExited -and $antwortet -ne [IntPtr]::Zero) { $lebt = 1 }
}
catch { Write-Host ('E221 FEHLER: ' + $_.Exception.Message) }
finally {
    try { if ($srv -and -not $srv.HasExited) { Stop-Process -Id $srv.Id -Force } } catch { }
    try { PopBeenden } catch { }
}

# --- Auswerten: Subject-Zeilen in In.mbx, Betreff in In.toc -----------------
try {
    $mbxPfad = Join-Path $md 'In.mbx'
    if (Test-Path -LiteralPath $mbxPfad) {
        $mbx = $lat.GetString([IO.File]::ReadAllBytes($mbxPfad))
        foreach ($m in [regex]::Matches($mbx, '(?m)^Subject:[^\r\n]*\r?\n(?:[ \t][^\r\n]*\r?\n)*')) {
            Write-Host ('E221 MBX "{0}"' -f (Sichtbar ($m.Value -replace "\r?\n", ' / ')))
        }
    } else { Write-Host 'E221 MBX In.mbx fehlt' }
    $betreffs = @()
    foreach ($tn in 'In.toc', 'Junk.toc') {
        $tp = Join-Path $md $tn
        if (-not (Test-Path -LiteralPath $tp)) { continue }
        $tb = [IO.File]::ReadAllBytes($tp)
        # Kopf 104 Byte, je Zusammenfassung 218 Byte, Betreff an Byte 114 (64 Byte)
        # - gemessen an der Out.toc-Vorlage aus messen-e179.ps1.
        for ($o = 104; $o + 218 -le $tb.Length; $o += 218) {
            $s = $lat.GetString($tb, $o + 114, 64); $nul = $s.IndexOf([char]0); if ($nul -ge 0) { $s = $s.Substring(0, $nul) }
            $betreffs += [pscustomobject]@{ Toc = $tn; Text = $s }
            Write-Host ('E221 TOC {0} "{1}"' -f $tn, (Sichtbar $s))
        }
    }
    foreach ($k in @($urteil.Keys)) {
        $sollText = $soll[$k]; if ($sollText.Length -gt 63) { $sollText = $sollText.Substring(0, 63) }
        $gef = $null
        foreach ($b in $betreffs) {
            if ($b.Text -eq $sollText) { $gef = $b; $urteil[$k] = 'heil'; break }
        }
        if (-not $gef) {
            foreach ($b in $betreffs) {
                if ($b.Text.Length -gt 3 -and $sollText.EndsWith($b.Text)) { $gef = $b; $urteil[$k] = 'fehlen' + ($sollText.Length - $b.Text.Length); break }
            }
        }
        $ist = $(if ($gef) { Sichtbar $gef.Text } else { '-' })
        Write-Host ('E221 PROBE {0} betreff="{1}" urteil={2}' -f $k, $ist, $urteil[$k])
    }
} catch { Write-Host ('E221 FEHLER beim Auswerten: ' + $_.Exception.Message) }
Write-Host ("E221 ERGEBNIS gesendet={0} faltung={1} kurz={2} gefaltet={3} gesendet-betreff={4} lebt={5}" -f $gesendet, $faltung, $urteil['kurz'], $urteil['gefaltet'], $urteil['gesendet'], $lebt)
try { Stop-Transcript | Out-Null } catch { }
exit 0
