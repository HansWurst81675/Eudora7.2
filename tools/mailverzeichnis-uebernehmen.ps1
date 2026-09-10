# mailverzeichnis-uebernehmen.ps1 - das Mailverzeichnis einer Fassung
# vollstaendig in die naechste uebernehmen.
#
# WARUM ES DAS GIBT
#
# Gregor kopiert das Mailverzeichnis von der alten Fassung zur neuen, damit
# er nicht jedes Mal ein Konto einrichten und Mail neu abrufen muss. Am
# 10.09.2026 habe ich ihm dafuer einen Befehl gegeben, der nur die *.mbx
# nahm. Seine Antwort: "meine inhalte (screenshots) sind in den mails weg."
#
# Bei Eudora stehen Anhaenge NICHT in der .mbx. Dort steht nur eine Zeile
#
#     Attachment Converted: "<pfad>"
#
# Die Dateien selbst liegen in "attach", eingebettete Bilder in "Embedded".
# Wer nur die Postfaecher kopiert, kopiert leere Huellen.
#
# Deshalb nimmt dieses Werkzeug das GANZE Verzeichnis - alle Dateien, alle
# Unterverzeichnisse, ohne Auswahl.
#
# WAS ES TUT
#
#   1. Bricht ab, wenn eine Eudora.exe aus der Quelle oder dem Ziel laeuft.
#      Ein laufendes Eudora haelt seine Postfaecher offen.
#   2. Kopiert das Mailverzeichnis der Quelle ueber das des Ziels -
#      ERGAENZEND, nicht ersetzend: was das Paket mitbringt und die Quelle
#      nicht hat (Vorlagen, Rufnamen), bleibt stehen.
#   3. Entfernt die eudora.log im Ziel, damit die naechste Messung nur den
#      neuen Lauf enthaelt. Die alte bleibt in der Quelle liegen.
#   4. Setzt CtrlJMapping=2, damit Strg+J filtert und nicht junkt
#      (BEFUND E-75). Ein bestehendes Mailverzeichnis traegt den Wert
#      bereits, und der Code aendert ihn dann nicht mehr.
#   5. Zaehlt am Ende nach: Postfaecher mit Groesse, attach und Embedded
#      mit Dateizahl - Quelle gegen Ziel.
#
# Aufruf (PowerShell):
#   powershell -ExecutionPolicy Bypass -File tools\mailverzeichnis-uebernehmen.ps1
#   ... -Quelle "C:\Users\Gregor\Eudora72-1.0.39-release"
#   ... -Ziel   "C:\Users\Gregor\Eudora72-1.0.40-release"
#   ... -NurZeigen                                    nichts schreiben
#
# Kodierung: reines ASCII, kein BOM.

[CmdletBinding()]
param(
    [string] $Quelle = 'C:\Users\Gregor\Eudora72-1.0.39-release',
    [string] $Ziel   = 'C:\Users\Gregor\Eudora72-1.0.40-release',
    [switch] $NurZeigen,
    # Kopiert NICHTS und setzt nur CtrlJMapping=2 im Ziel. Fuer den Fall,
    # dass das Mailverzeichnis schon uebernommen ist und nur Strg+J noch
    # auf "Junk" liegt. Wer schon mit der neuen Fassung Mail abgerufen hat,
    # darf NICHT mehr kopieren - sonst ist das Neue wieder weg.
    [switch] $NurCtrlJ
)

$ErrorActionPreference = 'Stop'

$mQuelle = Join-Path $Quelle 'Mailverzeichnis'
$mZiel   = Join-Path $Ziel   'Mailverzeichnis'

# --- Erst pruefen, dann anfassen ------------------------------------------
$fehlt = @()
if (-not (Test-Path -LiteralPath $mQuelle)) { $fehlt += "Quelle fehlt: $mQuelle" }
if (-not (Test-Path -LiteralPath $Ziel))    { $fehlt += "Zielfassung fehlt: $Ziel" }

if ($fehlt.Count -gt 0) {
    Write-Host ''
    Write-Host '  ABBRUCH - es wurde nichts angefasst:'
    foreach ($f in $fehlt) { Write-Host ("    " + $f) }
    Write-Host ''
    exit 1
}

# --- Laeuft Eudora? Nur nach PFAD filtern, nie nach Namen -----------------
$laufend = @(Get-Process -Name 'Eudora' -ErrorAction Ignore | Where-Object {
    $_.Path -and ($_.Path.StartsWith($Quelle, 'OrdinalIgnoreCase') -or
                  $_.Path.StartsWith($Ziel,   'OrdinalIgnoreCase'))
})
if ($laufend.Count -gt 0) {
    Write-Host ''
    Write-Host '  ABBRUCH - Eudora laeuft und haelt seine Postfaecher offen:'
    foreach ($p in $laufend) { Write-Host ("    PID {0}  {1}" -f $p.Id, $p.Path) }
    Write-Host ''
    Write-Host '  Bitte Eudora beenden und noch einmal starten.'
    Write-Host ''
    exit 1
}

# --- Was da ist -----------------------------------------------------------
function Bestand([string]$pfad) {
    $o = [ordered]@{}
    if (-not (Test-Path -LiteralPath $pfad)) { return $o }
    foreach ($f in (Get-ChildItem -LiteralPath $pfad -Filter *.mbx -ErrorAction Ignore | Sort-Object Name)) {
        $o[$f.Name] = $f.Length
    }
    foreach ($u in @('attach', 'Embedded')) {
        $p = Join-Path $pfad $u
        $o[$u + '\'] = if (Test-Path -LiteralPath $p) { @(Get-ChildItem -LiteralPath $p -File).Count } else { 0 }
    }
    $o['(Dateien gesamt)'] = @(Get-ChildItem -LiteralPath $pfad -Recurse -File).Count
    return $o
}

$vorher = Bestand $mQuelle

if ($NurCtrlJ) {
    Write-Host ''
    Write-Host '  Nur CtrlJMapping setzen - es wird nichts kopiert.'
    Write-Host  ('  ' + ('-' * 68))
    Write-Host  ('  ' + $mZiel)
    Write-Host  ('  ' + ('-' * 68))
}

Write-Host ''
if (-not $NurCtrlJ) {
Write-Host '  Mailverzeichnis uebernehmen'
Write-Host  ('  ' + ('-' * 68))
Write-Host  ('  von   ' + $mQuelle)
Write-Host  ('  nach  ' + $mZiel)
Write-Host  ('  ' + ('-' * 68))
foreach ($k in $vorher.Keys) {
    if ($k -like '*\') { Write-Host ('    {0,-18} {1,10} Dateien' -f $k, $vorher[$k]) }
    elseif ($k -like '(*') { Write-Host ('    {0,-18} {1,10}' -f $k, $vorher[$k]) }
    else { Write-Host ('    {0,-18} {1,10:N0} B' -f $k, $vorher[$k]) }
}
Write-Host  ('  ' + ('-' * 68))
}

if ($NurZeigen) {
    Write-Host '  -NurZeigen: es wird nichts geschrieben.'
    Write-Host ''
    exit 0
}

if (-not $NurCtrlJ) {
    # --- 1. Alles hinueber, ergaenzend ------------------------------------
    # Das Ziel wird NICHT vorher geleert: was das Paket mitbringt und die
    # Quelle nicht hat, soll stehenbleiben. Alles aus der Quelle gewinnt.
    if (-not (Test-Path -LiteralPath $mZiel)) {
        New-Item -ItemType Directory -Path $mZiel | Out-Null
    }
    # -Path, NICHT -LiteralPath: das * muss ein Platzhalter sein. Mit
    # -LiteralPath wird es woertlich genommen und es wird NICHTS kopiert -
    # der Gegentest hat genau das gefangen.
    Copy-Item -Path (Join-Path $mQuelle '*') -Destination $mZiel -Recurse -Force

    # --- 2. Altes Protokoll weg -------------------------------------------
    $log = Join-Path $mZiel 'eudora.log'
    if (Test-Path -LiteralPath $log) {
        Remove-Item -LiteralPath $log -Force
        Write-Host '  eudora.log entfernt - die naechste Messung faengt sauber an'
    }
}

# --- 3. Strg+J filtert, es junkt nicht (E-75) -----------------------------
$ini = Join-Path $mZiel 'Eudora.ini'
if (-not (Test-Path -LiteralPath $ini)) {
    Write-Host '  ACHTUNG: keine Eudora.ini im Ziel'
} else {
    # Byte-erhaltend lesen und schreiben. Die Eudora.ini ist Latin-1 und
    # enthaelt Namen mit Umlauten; Set-Content -Encoding Ascii wuerde sie zu
    # Fragezeichen machen. Latin-1 bildet jedes Byte auf genau ein Zeichen
    # ab und wieder zurueck, der Rest der Datei bleibt also unberuehrt.
    $l1 = [System.Text.Encoding]::GetEncoding(28591)
    $t  = $l1.GetString([System.IO.File]::ReadAllBytes($ini))
    $vorherBytes = (Get-Item -LiteralPath $ini).Length

    if ($t -match '(?m)^CtrlJMapping=(\d+)\s*$') {
        $alt = $Matches[1]
        if ($alt -eq '2') {
            Write-Host '  CtrlJMapping steht schon auf 2 - Strg+J filtert'
        } else {
            $t = $t -replace '(?m)^CtrlJMapping=\d+', 'CtrlJMapping=2'
            [System.IO.File]::WriteAllBytes($ini, $l1.GetBytes($t))
            Write-Host ('  CtrlJMapping {0} -> 2 gesetzt - Strg+J filtert wieder (E-75)' -f $alt)
        }
    } elseif ($t -match '(?m)^\[Settings\]') {
        $t = $t -replace '(?m)^\[Settings\]', "[Settings]`r`nCtrlJMapping=2"
        [System.IO.File]::WriteAllBytes($ini, $l1.GetBytes($t))
        Write-Host ('  CtrlJMapping=2 in [Settings] eingetragen (E-75), {0} -> {1} B' -f
                    $vorherBytes, (Get-Item -LiteralPath $ini).Length)
    } else {
        Write-Host '  ACHTUNG: kein [Settings] in der Eudora.ini -'
        Write-Host '  CtrlJMapping=2 bitte von Hand eintragen.'
    }
}

if ($NurCtrlJ) {
    Write-Host ''
    exit 0
}

# --- Nachmessen ------------------------------------------------------------
$nachher = Bestand $mZiel

Write-Host ''
Write-Host '  Ergebnis - Quelle gegen Ziel:'
Write-Host ''
Write-Host  ('    {0,-18} {1,14} {2,14}   {3}' -f 'was', 'Quelle', 'Ziel', '')
$fehler = 0
foreach ($k in $vorher.Keys) {
    $a = $vorher[$k]
    $b = if ($nachher.Contains($k)) { $nachher[$k] } else { 0 }
    # Im Ziel duerfen es MEHR Dateien sein - die Paketvorlagen bleiben stehen.
    $urteil = if ($b -ge $a) { 'ok' } else { 'FEHLT'; }
    if ($b -lt $a) { $fehler++ }
    if ($k -like '*\')      { Write-Host ('    {0,-18} {1,14} {2,14}   {3}' -f $k, $a, $b, $urteil) }
    elseif ($k -like '(*')  { Write-Host ('    {0,-18} {1,14} {2,14}   {3}' -f $k, $a, $b, $urteil) }
    else                    { Write-Host ('    {0,-18} {1,14:N0} {2,14:N0}   {3}' -f $k, $a, $b, $urteil) }
}

Write-Host ''
if ($fehler -gt 0) {
    Write-Host ("  {0} Posten sind im Ziel kleiner als in der Quelle - bitte ansehen." -f $fehler)
    Write-Host ''
    exit 1
}

Write-Host '  Alles uebernommen - Postfaecher, Anhaenge und eingebettete Bilder.'
Write-Host ''
exit 0
