# e80-messen.ps1 - ein Lauf, drei Schritte: starten, Nachricht oeffnen, die
# angezeigte HTML-Fassung einsammeln.
#
# Trident baut die Anzeige als temporaere Datei eud*.htm auf
# (TridentView.cpp:1499-1522) und loescht sie beim naechsten Aufbau. Wer
# wissen will, WELCHE Kopfzeilen der Anwender wirklich sieht, muss sie
# waehrend des Laufs abgreifen - das tut dieses Skript.
#
# ZWEI FEHLSCHLAEGE STECKEN IN DER BAUART, beide am 11.09.2026 gemessen:
#
#  1. Der erste Entwurf rief testlauf.ps1 per Start-Process auf. PowerShell
#     5.1 setzt bei -ArgumentList als Array keine Anfuehrungszeichen um
#     Argumente mit Leerzeichen - der Freigabetext ist ein ganzer Satz.
#     testlauf.ps1 bekam zerlegte Parameter und beendete sich sofort;
#     sichtbar nur daran, dass kein Eintrag in TESTLAEUFE.md entstand.
#     Jetzt laeuft testlauf.ps1 im Vordergrund, die Parameter gehen direkt.
#
#  2. Der zweite Entwurf rief nachricht-oeffnen.ps1 per "powershell -File".
#     Der Job SAH Eudora (PID 3576), der von ihm gestartete Unterprozess
#     meldete "Kein Eudora aus C:\Temp\E80b gefunden". Die Grenze liegt
#     beim Starten eines neuen Prozesses, nicht beim Lesen der
#     Prozessliste. Jetzt wird das Skript im selben Prozess aufgerufen.
param(
    [string] $Verzeichnis = 'C:\Temp\E80b',
    [string] $Ablage      = 'C:\Temp\E80-htm'
)
$ErrorActionPreference = 'Continue'
$wz = 'C:\Users\Gregor\Documents\github\Eudora7.2\tools'

if (-not (Test-Path $Ablage)) { New-Item -ItemType Directory $Ablage | Out-Null }
Get-ChildItem $Ablage -File -ErrorAction Ignore | Remove-Item -Force

$log = Join-Path $Verzeichnis 'Mailverzeichnis\eudora.log'
if (Test-Path $log) { Remove-Item $log -Force }

$job = Start-Job -ArgumentList $Verzeichnis, $Ablage, $wz -ScriptBlock {
    param($v, $ab, $wz)
    $da = $null
    for ($i = 0; $i -lt 50 -and -not $da; $i++) {
        Start-Sleep -Milliseconds 700
        $da = Get-Process -Name Eudora -ErrorAction Ignore |
              Where-Object { $_.Path -and $_.Path.StartsWith($v, 'OrdinalIgnoreCase') }
    }
    if (-not $da) { 'JOB: Eudora ist nicht erschienen'; return }
    "JOB: Eudora laeuft, PID $($da.Id)"
    Start-Sleep -Seconds 6

    & (Join-Path $wz 'nachricht-oeffnen.ps1') -Pfadfilter $v 2>&1 |
        Select-Object -Last 10 | ForEach-Object { "JOB:   $_" }

    Start-Sleep -Seconds 5

    # Wohin Trident schreibt, sagt die globale TempDir (TridentView.cpp:1503).
    # Statt sie zu raten, wird breit gesucht.
    $n = 0
    $orte = @($env:TEMP, $env:TMP, 'C:\Windows\Temp') | Where-Object { $_ } | Select-Object -Unique
    foreach ($o in $orte) {
        if (-not (Test-Path $o)) { continue }
        Get-ChildItem $o -Filter 'eud*.htm' -File -ErrorAction Ignore | ForEach-Object {
            Copy-Item $_.FullName (Join-Path $ab $_.Name) -Force -ErrorAction Ignore
            $n++
            "JOB: eingesammelt {0}  {1} B  aus {2}" -f $_.Name, $_.Length, $o
        }
    }
    Get-ChildItem $v -Filter 'eud*.htm' -File -Recurse -ErrorAction Ignore | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $ab $_.Name) -Force -ErrorAction Ignore
        $n++
        "JOB: eingesammelt {0}  {1} B  aus {2}" -f $_.Name, $_.Length, $_.DirectoryName
    }
    "JOB: $n HTML-Datei(en)"
}

& (Join-Path $wz 'testlauf.ps1') `
    -Verzeichnis $Verzeichnis `
    -Freigabe "Gregor am 11.09.2026: 'du kannst programm ausfuehren, wenn du es fuer deine test brauchst' - E-80 Anzeige belegen" `
    -Sekunden 60 | Select-Object -Last 5

Wait-Job $job -Timeout 40 | Out-Null
Receive-Job $job
Remove-Job $job -Force -ErrorAction Ignore
exit 0
