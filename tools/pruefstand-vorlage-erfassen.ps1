# pruefstand-vorlage-erfassen.ps1 - die Grundstaende der Pruefverzeichnisse
# aus C:\Temp ins Repo uebernehmen (nur auf der Entwicklermaschine).
#
# -------------------------------------------------------------------------
# WARUM ES DAS GIBT
# -------------------------------------------------------------------------
#
# E-151: die Pruefstandsfaelle liefen nur auf der Entwicklermaschine. Jedes
# der Pruefverzeichnisse unter C:\Temp ist von Hand gewachsen: eine Kopie des
# Pakets plus ein Mailverzeichnis mit Pruef-Persoenlichkeit, Ports der
# Pruefserver (127.0.0.1:11110/1143) und IMAP-Konto "pruefimap". Das Paket
# entsteht aus dem Bau; das Mailverzeichnis lag nirgends im Repo.
# Gregor am 05.11.2026: "ich moechte separat von hier (oder auch jemand, der
# die repo forkt oder clonet) die tests nach eigenen aenderungen durchfuehren.
# um zu sehen, dass die neue implementierung nichts kaputt gemacht hat."
#
# Dieses Skript nimmt aus jedem Pruefverzeichnis der Fallliste NUR den
# Grundstand - Einstellungen, Filter, IMAP-Konten, Signaturen, leere eigene
# Postfaecher - und legt ihn unter Testdaten\pruefstand\<Name>\ ab. Was ein
# Lauf erzeugt (Protokolle, Postfachinhalte, Ablagen), bleibt draussen; die
# Messskripte stellen ihre Lage mit -Vorbereiten selbst her.
#
# PRIVATES BLEIBT DRAUSSEN: E222\e222-quelle.ems (eine echte signierte Mail)
# und E193f\privat\ werden nie erfasst. Danach wird jede erfasste Datei auf
# Namen, Benutzerpfade und fremde Mailadressen geprueft; ein Treffer bricht ab
# (Arbeitsweise/gedaechtnis-ist-oeffentlich.md).
#
# Aufruf:  powershell -NoProfile -ExecutionPolicy Bypass -File tools\pruefstand-vorlage-erfassen.ps1 [-NurZeigen]
#
# Kodierung: reines ASCII, nur LF.

[CmdletBinding()]
param([switch] $NurZeigen)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$ziel = Join-Path $repo 'Testdaten\pruefstand'
$lat  = [Text.Encoding]::GetEncoding(28591)

$verz = @()
foreach ($z in [IO.File]::ReadAllLines((Join-Path $PSScriptRoot 'pruefstand-faelle.txt'))) {
    if ($z -match '^\s*(#|$)') { continue }
    $f = $z.Split('|'); if ($f.Count -lt 8) { continue }
    $verz += $f[1].Trim()
}
$verz = @($verz | Sort-Object -Unique)

# Zeilen der Eudora.ini, die nur einen Bildschirmzustand oder einen Pfad
# ausserhalb des Pruefstands tragen.
$iniWeg = '^(OpenWindow\d+|Mailbox\d+|LastAttachDir|LastSaveAsDir|SaveAsDirectory|AttachDir)='

# Was auf Gregor oder seinen Rechner zurueckfuehren koennte.
$privat = '(?i)gregor|NAME-ENTFERNT|NAME-ENTFERNT|C:\\Users\\|@(?!127\.0\.0\.1|localhost)[a-z0-9-]+\.(de|com|net|org)\b'

$anzahl = 0
foreach ($v in $verz) {
    $name = Split-Path -Leaf $v
    $md = Join-Path $v 'Mailverzeichnis'
    if (-not (Test-Path -LiteralPath (Join-Path $md 'Eudora.ini'))) { Write-Host "  FEHLT: $md\Eudora.ini"; exit 1 }
    $dz = Join-Path (Join-Path $ziel $name) 'Mailverzeichnis'
    $teile = @()
    $teile += 'Eudora.ini'
    if (Test-Path -LiteralPath (Join-Path $md 'Filters.pce')) { $teile += 'Filters.pce' }
    foreach ($ordner in 'Imap', 'Sigs') {
        $o = Join-Path $md $ordner
        if (Test-Path -LiteralPath $o) {
            foreach ($d in Get-ChildItem -LiteralPath $o -Recurse -File) { $teile += $d.FullName.Substring($md.Length + 1) }
        }
    }
    $leer = @(Get-ChildItem -LiteralPath $md -Filter '*.mbx' -File | Where-Object { $_.Name -notin 'In.mbx', 'Out.mbx', 'Trash.mbx', 'Junk.mbx' } | ForEach-Object { $_.Name })
    Write-Host ("  {0,-42} {1} Dateien{2}" -f $name, $teile.Count, $(if ($leer) { ', leere Postfaecher: ' + ($leer -join ' ') } else { '' }))
    if ($NurZeigen) { continue }
    if (Test-Path -LiteralPath (Join-Path $ziel $name)) { Remove-Item -LiteralPath (Join-Path $ziel $name) -Recurse -Force }
    New-Item -ItemType Directory -Force -Path $dz | Out-Null
    foreach ($t in $teile) {
        $q = Join-Path $md $t
        $zd = Join-Path $dz $t
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $zd) | Out-Null
        if ($t -eq 'Eudora.ini') {
            $zeilen = $lat.GetString([IO.File]::ReadAllBytes($q)) -split "`r?`n"
            # LogLevel ausserhalb von [Debug] liest Eudora nie (GetSectionID,
            # rs.cpp:89-97; tools/pruefe-ini-abschnitte.pl weist es ab) - die
            # wirksame Zeile steht in [Debug] und bleibt.
            $abschnitt = ''
            $rein = @(foreach ($zz in $zeilen) {
                if ($zz -match '^\[(.+)\]\s*$') { $abschnitt = $Matches[1] }
                if ($zz -match $iniWeg) { continue }
                if ($zz -match '^LogLevel=' -and $abschnitt -ne 'Debug') { continue }
                $zz
            })
            while ($rein.Count -gt 0 -and $rein[-1] -eq '') { $rein = $rein[0..($rein.Count - 2)] }
            [IO.File]::WriteAllBytes($zd, $lat.GetBytes(($rein -join "`r`n") + "`r`n"))
        } else {
            Copy-Item -LiteralPath $q -Destination $zd -Force
        }
        $text = $lat.GetString([IO.File]::ReadAllBytes($zd))
        $m = [regex]::Match($text, $privat)
        if ($m.Success) { Write-Host ("  ABBRUCH: {0} enthaelt '{1}' - nichts Privates ins Repo" -f $zd, $m.Value); exit 1 }
        $anzahl++
    }
    foreach ($l in $leer) { [IO.File]::WriteAllBytes((Join-Path $dz $l), [byte[]]@()) }
}
Write-Host ("  {0} Pruefverzeichnisse, {1} Dateien nach {2}" -f $verz.Count, $anzahl, $ziel)
