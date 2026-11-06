# messen-e179.ps1 - behaelt der Textteil einer gesendeten HTML-Mail
# numerische Zeichenangaben (&#128293;, &#1046;, &#x1F525;) vollstaendig?
# (Befund E-179)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript, bekommt von dort
# -Pfadfilter <Verzeichnis> und arbeitet nur auf Prozessen aus diesem Pfad.
#
# WARUM ES DAS GIBT. Html2Text (html2text.cpp, AddText) nahm von einer
# numerischen Zeichenangabe nur das unterste Byte: &#128293; -> "%",
# &#1046; -> 0x16, jede hexadezimale Angabe -> Nullbyte und Rest als Text.
# Die Behebung (E179ZeichenAusNummer, 01.11.2026) laesst eine Angabe, die
# die Codepage nicht kennt, stehen, wie sie war. Gemessen war bis heute nur
# die herausgezogene Funktion (TestE179.cpp), nicht der Weg.
#
# DER WEG (BEFUNDE E-179 "Wo der Anwender es trifft"): Textteil einer
# gesendeten HTML-Mail - sendmail.cpp SendStyled baut bei "Send both plain
# and styled" (Vorgabe SendPlainAndStyled=1) ein multipart/alternative und
# ruft fuer den text/plain-Teil Html2Text.
#
# Lage (-Vorbereiten): lokales Out mit EINEM HTML-Entwurf (gespeichert wie
# Eudora ihn speichert, <x-html>), SMTPPort=1025 in der Eudora.ini (unter
# [Settings] und in jeder Persoenlichkeit, hinter SMTPServer=).
# Ablauf, ohne Tastendruck: tools\smtp-pruefserver.pl auf 127.0.0.1:1025,
# Out oeffnen (ID_MAILBOX_OUT), die Zeile waehlen, ID_FILE_SENDQUEUEDMESSAGES
# an das Hauptfenster (der Entwurf steht per Out.toc-Vorlage als queued da,
# siehe -Vorbereiten; SMTPServer=127.0.0.1, SSLSendUse=0). Der Entwurf wird
# NICHT geoeffnet - sonst liefe der Text
# durch den Editor, und gemessen waere der Editor, nicht Html2Text.
#
# Ausgabe: Zeilen "E179 ...", darunter je Probe
#   E179 PROBE <name> text="<was im Textteil zwischen Doppelpunkt und Ende steht, Nicht-ASCII als <xx>>"
#   E179 ERGEBNIS gesendet=<n> form=<plain|alternative|-> emoji=<..> kyr=<..> hex=<..> euro=<..> umlaut=<..> lebt=<0|1>
# Je Probe: entitaet = die Angabe steht unveraendert da; zeichen = das
# Windows-1252-Zeichen (fuer Euro und Umlaut richtig); kaputt = etwas
# anderes (Text daneben in der PROBE-Zeile); fehlt = Zeile nicht gefunden.
# Erwartet mit der Behebung: emoji=entitaet kyr=entitaet hex=entitaet
# euro=zeichen umlaut=zeichen. gesendet=1 und je Probe eine gefundene Zeile
# sind die Positivprobe (ohne Textteil kein Befund).
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
$ablage = Join-Path $voll 'ablage-e179'
$srvlog = Join-Path $voll 'smtp-e179.log'
$repo = Split-Path -Parent $PSScriptRoot
$cp = [Text.Encoding]::GetEncoding(1252)
$proben = [ordered]@{ emoji = '&#128293;'; kyr = '&#1046;'; hex = '&#x1F525;'; euro = '&#8364;'; umlaut = '&#252;' }
$zeichen = @{ euro = [string][char]0x20AC; umlaut = [string][char]0xFC }

if ($Vorbereiten) {
    try {
        if ($voll -notmatch ('^' + [regex]::Escape($(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp' })) + '\\[^\\]+')) { Write-Host "E179 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
        $ini = Join-Path $md 'Eudora.ini'
        if (-not (Test-Path $ini)) { Write-Host "E179 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match '^Out\.(mbx|toc)(\.\d{3})?$' } | Remove-Item -Force
        $html = ''
        foreach ($k in $proben.Keys) { $html += "<p>${k}: $($proben[$k]) Ende</p>`r`n" }
        $entwurf = "From ???@??? Mon Nov 02 18:00:00 2026`r`nTo: empfaenger@e179.invalid`r`nFrom: pruef@127.0.0.1`r`nSubject: E-179 Zeichenangaben`r`nX-Attachments: `r`n`r`n<x-html><html><body>`r`n" + $html + "</body></html></x-html>`r`n`r`n"
        [IO.File]::WriteAllBytes((Join-Path $md 'Out.mbx'), [Text.Encoding]::ASCII.GetBytes($entwurf))
        # Out.toc dazu, mit m_State 7 (queued): eine aus Out.mbx NEU aufgebaute
        # Zusammenfassung ist "unsendable" (Zustand 5, gemessen 02.11.2026), und
        # die laesst sich weder senden noch per Status umstellen (OnUpdateSendable
        # verlangt IsSendable). Die Vorlage hat Eudora 7.2.1.131 am 02.11.2026 fuer
        # genau dieses Out.mbx geschrieben; nur Byte 116 (m_State des einzigen
        # Datensatzes) ist von 5 auf 7 gesetzt. Passt die Groesse nicht, Abbruch.
        $mbxLaenge = (Get-Item -LiteralPath (Join-Path $md 'Out.mbx')).Length
        if ($mbxLaenge -ne 329) { Write-Host "E179 FEHLER: Out.mbx hat $mbxLaenge Byte, die TOC-Vorlage gilt fuer 329"; exit 1 }
        $toc = [Convert]::FromBase64String('MQAAAAAAAABPdXQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAIAAAAFAAUAA1Ap8B/////////////////////wIAAQAAAAAAAAAAAAAAjAAAAAAAAAAAAAAASgEAAAAAAQAAAAAASQEAAICz6GoHALwhAwAxODowMCAwMi4xMS4yMDI2AAAAAAAAAAAAAAAAkMHoamVtcGZhZW5nZXJAZTE3OS5pbnZhbGlkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABFLTE3OSBaZWljaGVuYW5nYWJlbgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//////////8AAAAAAAABAAAAAgABAAAAPAAAAAAAAQABAAAAAAAAAA==')
        Start-Sleep -Milliseconds 1100
        [IO.File]::WriteAllBytes((Join-Path $md 'Out.toc'), $toc)
        $z = [IO.File]::ReadAllLines($ini, $cp)
        $neu = New-Object System.Collections.Generic.List[string]
        foreach ($l in $z) {
            if ($l -match '^SMTPPort=' -or $l -match '^SSLSendUse=' -or $l -match '^OpenWindow[0-9]+=') { continue }
            $neu.Add($l)
            # localhost lief am 02.11.2026 ins Leere ("connection refused") - der
            # Pruefserver hoert nur auf 127.0.0.1.
            # Und ohne SSLSendUse=0 nahm die Dominante Port 465 ("Open 127.0.0.1:465",
            # eudora.log 02.11.2026) - Vorgabe 1 in EudoraRes.rc, und unter [Settings]
            # stand nichts.
            if ($l -match '^SMTPServer=') { $neu[$neu.Count - 1] = 'SMTPServer=127.0.0.1'; $neu.Add('SMTPPort=1025'); $neu.Add('SSLSendUse=0') }
        }
        [IO.File]::WriteAllLines($ini, [string[]]$neu, $cp)
        Remove-Item -LiteralPath $srvlog -Force -ErrorAction SilentlyContinue
        if (Test-Path $ablage) { Remove-Item -LiteralPath $ablage -Recurse -Force }
        Write-Host ("E179 vorbereitet: Out.mbx mit einem HTML-Entwurf, SMTPPort=1025 {0}-mal gesetzt" -f @($neu | Where-Object { $_ -eq 'SMTPPort=1025' }).Count)
        exit 0
    } catch { Write-Host ('E179 FEHLER beim Vorbereiten: ' + $_.Exception.Message); exit 1 }
}

$gesendet = 0; $alternative = 0; $lebt = 0; $urteil = [ordered]@{}
foreach ($k in $proben.Keys) { $urteil[$k] = 'fehlt' }
$srv = $null
try {
    Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E179 {
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
    function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E179]::GetClassName($h, $s, 256); $s.ToString() }
    function Txt($h) { $s = New-Object Text.StringBuilder 512; [void][E179]::GetWindowTextA($h, $s, 512); $s.ToString() }
    function Snd($h, $m, $w, $l, $ms = 5000) { $r = [IntPtr]::Zero; [void][E179]::SendMessageTimeoutA($h, $m, $w, $l, 0x0002, $ms, [ref]$r); return $r }
    function Alle($pp) {
        $r = New-Object System.Collections.ArrayList
        $cb = [E179+EP]{ param($h, $p); $o = 0; [void][E179]::GetWindowThreadProcessId($h, [ref]$o)
            if ($o -eq $pp) {
                $cc = [E179+EP]{ param($k, $q); [void]$r.Add([pscustomobject]@{ H = $k; Klasse = (Kl $k); Vis = [E179]::IsWindowVisible($k) }); return $true }
                [void][E179]::EnumChildWindows($h, $cc, [IntPtr]::Zero)
                [void]$r.Add([pscustomobject]@{ H = $h; Klasse = (Kl $h); Vis = [E179]::IsWindowVisible($h) })
            }
            return $true }
        [void][E179]::EnumWindows($cb, [IntPtr]::Zero); return $r
    }
    function Dialoge($pp) {
        foreach ($d in (Alle $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' -and ([E179]::GetWindowLongA($_.H, -16) -band 0x40000000) -eq 0 })) {
            $script:inhalt = @(); $cc = [E179+EP]{ param($k, $q); $t = Txt $k; if ($t) { $script:inhalt += $t }; return $true }
            [void][E179]::EnumChildWindows($d.H, $cc, [IntPtr]::Zero)
            Write-Host ("E179 DIALOG '{0}': {1}" -f (Txt $d.H), ($script:inhalt -join ' | '))
            [void][E179]::PostMessageA($d.H, 0x0010, [IntPtr]0, [IntPtr]0)
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

    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    $belegt = @(Get-NetTCPConnection -LocalPort 1025 -State Listen -ErrorAction SilentlyContinue)
    if ($belegt.Count -gt 0) { throw ('Port 1025 belegt von Prozess ' + (($belegt | ForEach-Object { $_.OwningProcess }) -join ',')) }
    $srv = Start-Process $perl -ArgumentList @("$repo\tools\smtp-pruefserver.pl", '--port', '1025', '--ablage', $ablage, '--protokoll', $srvlog, '--zeitschranke', [string](60 + 4 * $Warten)) -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Warte 3

    [void][E179]::PostMessageA($haupt.H, 0x0111, [IntPtr]32793, [IntPtr]::Zero)          # ID_MAILBOX_OUT
    Warte 3
    $out = Snd $mdi.H 0x0229 ([IntPtr]::Zero) ([IntPtr]::Zero)
    Write-Host ('E179 aktives Fenster: "' + (Txt $out) + '"')
    $script:lb = [IntPtr]::Zero
    $cc = [E179+EP]{ param($k, $q); if ($script:lb -eq [IntPtr]::Zero -and (Kl $k) -eq 'ListBox' -and [E179]::IsWindowVisible($k)) { $script:lb = $k }; return $true }
    [void][E179]::EnumChildWindows($out, $cc, [IntPtr]::Zero)
    if ($script:lb -eq [IntPtr]::Zero) { throw 'keine Liste im Out-Fenster' }
    $n = [int](Snd $script:lb 0x018B ([IntPtr]0) ([IntPtr]0))
    if ($n -ne 1) { throw "Out hat $n Zeilen statt 1" }
    [void](Snd $script:lb 0x0185 ([IntPtr]1) ([IntPtr]0))
    [void](Snd $script:lb 0x019E ([IntPtr]0) ([IntPtr]0))
    # Der Entwurf ist per Out.toc-Vorlage schon queued (-Vorbereiten). Der
    # Statusbefehl ist dann ohne Wirkung; er bleibt, falls die Vorlage einmal
    # sendable statt queued traegt. Danach Send Queued Messages.
    [void][E179]::PostMessageA($out, 0x0111, [IntPtr]32866, [IntPtr]::Zero)              # ID_MESSAGE_STATUS_QUEUED
    Warte 2
    [void][E179]::PostMessageA($haupt.H, 0x0111, [IntPtr]32771, [IntPtr]::Zero)         # ID_FILE_SENDQUEUEDMESSAGES
    Warte $Warten
    [void][E179]::PostMessageA($out, 0x0010, [IntPtr]0, [IntPtr]0)
    Warte 3
    $r = [IntPtr]::Zero
    $antwortet = [E179]::SendMessageTimeoutA($haupt.H, 0x0000, [IntPtr]0, [IntPtr]0, 0x0002, 5000, [ref]$r)
    $p2 = Get-Process -Id $pp -ErrorAction SilentlyContinue
    if ($p2 -and -not $p2.HasExited -and $antwortet -ne [IntPtr]::Zero) { $lebt = 1 }
}
catch { Write-Host ('E179 FEHLER: ' + $_.Exception.Message) }
finally {
    try { Start-Sleep -Seconds 1; if ($srv -and -not $srv.HasExited) { Stop-Process -Id $srv.Id -Force } } catch { Write-Host ('E179 FEHLER beim Beenden des Servers: ' + $_.Exception.Message) }
}

# Auswerten: text/plain-Teil der ersten gesendeten Nachricht
function Sichtbar([string] $s) {
    $aus = ''
    foreach ($ch in $s.ToCharArray()) { $c = [int]$ch; if ($c -ge 0x20 -and $c -lt 0x7F) { $aus += $ch } else { $aus += ('<{0:x2}>' -f $c) } }
    return $aus
}
try {
    if (Test-Path $srvlog) { foreach ($z in (Get-Content -LiteralPath $srvlog | Where-Object { $_ -match 'NACHRICHT|!!|DATA|MAIL' })) { Write-Host ('E179 SERVER ' + $z) } }
    $dateien = @(); if (Test-Path $ablage) { $dateien = @(Get-ChildItem -LiteralPath $ablage -Filter 'smtp-*.eml' | Sort-Object Name) }
    $gesendet = $dateien.Count
    if ($gesendet -gt 0) {
        $roh = [IO.File]::ReadAllText($dateien[0].FullName, [Text.Encoding]::GetEncoding(28591))
        if ($roh -match '(?i)multipart/alternative') { $alternative = 1 }
        # erster Teil mit text/plain
        $teil = ''
        # Zwei Formen: multipart/alternative (Teil bis zur naechsten Grenze)
        # oder - wenn die Zusammenfassung "plain only" traegt, wie hier
        # (eudora.log "E-88 ... SendPlainOnly=1") - eine einzige text/plain-
        # Nachricht; beide Wege rufen Html2Text (sendmail.cpp SendStyled bzw.
        # SendTextContext).
        if ($alternative) { $muster = '(?is)Content-Type:\s*text/plain[^\r\n]*(?:\r?\n[ \t][^\r\n]*)*(.*?)\r?\n\r?\n(.*?)(?=\r?\n--)' }
        else              { $muster = '(?is)Content-Type:\s*text/plain[^\r\n]*(.*?)\r?\n\r?\n(.*)$' }
        $m = [regex]::Match($roh, $muster)
        if ($m.Success) {
            $kopf = $m.Groups[1].Value; $teil = $m.Groups[2].Value
            if ($kopf -match '(?i)quoted-printable' -or $roh -match '(?is)text/plain.{0,200}quoted-printable') {
                $teil = [regex]::Replace(($teil -replace "=\r?\n", ''), '=([0-9A-Fa-f]{2})', { param($x) [string][char][Convert]::ToInt32($x.Groups[1].Value, 16) })
            }
        }
        Write-Host ('E179 TEXTTEIL ' + (Sichtbar ($teil -replace "\r?\n", ' / ')))
        $bytes = [Text.Encoding]::GetEncoding(28591).GetBytes($teil)
        $text = $cp.GetString($bytes)
        foreach ($k in $proben.Keys) {
            $mm = [regex]::Match($text, [regex]::Escape($k) + ': (.*?) Ende')
            if (-not $mm.Success) { Write-Host ("E179 PROBE {0} (keine Zeile)" -f $k); continue }
            $wert = $mm.Groups[1].Value
            Write-Host ('E179 PROBE {0} text="{1}"' -f $k, (Sichtbar $wert))
            if ($wert -eq $proben[$k]) { $urteil[$k] = 'entitaet' }
            elseif ($zeichen.ContainsKey($k) -and $wert -eq $zeichen[$k]) { $urteil[$k] = 'zeichen' }
            else { $urteil[$k] = 'kaputt' }
        }
    }
} catch { Write-Host ('E179 FEHLER beim Auswerten: ' + $_.Exception.Message) }
Write-Host ("E179 ERGEBNIS gesendet={0} form={1} emoji={2} kyr={3} hex={4} euro={5} umlaut={6} lebt={7}" -f $gesendet, $(if ($gesendet -eq 0) { '-' } elseif ($alternative) { 'alternative' } else { 'plain' }), $urteil['emoji'], $urteil['kyr'], $urteil['hex'], $urteil['euro'], $urteil['umlaut'], $lebt)
exit 0
