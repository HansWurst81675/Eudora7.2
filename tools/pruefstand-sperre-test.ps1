# pruefstand-sperre-test.ps1 - Gegentest der Pruefstandssperre und des
# Zuruecksetzens, OHNE Eudora zu starten.
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File tools\pruefstand-sperre-test.ps1
#
# Faelle, alle in beide Richtungen:
#   1. A haelt die Sperre 8 s, B will sie nach 1 s: B wartet nachweislich und
#      bekommt sie erst NACH As Freigabe (Zeitstempel in derselben Zeile).
#   2. A haelt die Sperre und wird abgeschossen: B bekommt sie trotzdem
#      ("verlassen vorgefunden"), ohne die 15 Minuten abzuwarten.
#   3. Zeitschranke: A haelt 20 s, B wartet hoechstens 0.1 min: B bekommt sie
#      NICHT und nennt den Halter.
#   4. Erben: der Halter startet ein Kind; das Kind nimmt sie nicht ein
#      zweites Mal (sonst wartete es auf sich selbst). Gegenprobe: ein Kind
#      mit einer gefaelschten pid in EUDORA72_SPERRE erbt nicht.
#   5. Zuruecksetzen nur eigener Werte, an einem eigenen Probeschluessel
#      HKCU\Software\Eudora72Probe (danach entfernt): eigene Werte zurueck,
#      eigene Path#/Unterschluessel weg, fremde Werte stehen gelassen.
#
# Die Sperre ist systemweit. Laeuft gerade ein echter Pruefstand, wartet
# Fall 1 auf ihn - deshalb prueft der Test vorher, dass sie frei ist.
#
# Rueckgabe = Zahl der fehlgeschlagenen Pruefungen. Kodierung: reines ASCII.

$ErrorActionPreference = 'Stop'
$modul = Join-Path $PSScriptRoot 'pruefstand-sperre.ps1'
$fehl = 0; $gut = 0
function Pruefe([bool] $ok, [string] $was) {
    if ($ok) { $script:gut++; Write-Host ('  [ ok ] ' + $was) } else { $script:fehl++; Write-Host ('  [FEHL] ' + $was) }
}

# Zwischendateien unter C:\Temp (Pruefstandsbereich), nicht im Repo, nicht in %TEMP%.
$tmp = 'C:\Temp\Eudora72-Sperre-Test-' + $PID
New-Item -ItemType Directory -Force $tmp | Out-Null

function Kind([string] $name, [string] $koerper) {
    $datei = Join-Path $tmp ($name + '.ps1')
    $text = ". '" + $modul + "'`r`n" + $koerper
    [IO.File]::WriteAllText($datei, $text)
    return Start-Process powershell -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $datei) `
        -RedirectStandardOutput (Join-Path $tmp ($name + '.out')) -WindowStyle Hidden -PassThru
}
function Aus([string] $name) { Get-Content (Join-Path $tmp ($name + '.out')) -ErrorAction SilentlyContinue }
function Zeit([string] $name, [string] $marke) {
    foreach ($z in (Aus $name)) { if ($z -match ('^' + $marke + ' (\d+)$')) { return [long]$Matches[1] } }
    return -1
}
$jetzt = '[DateTimeOffset]::Now.ToUnixTimeMilliseconds()'

try {
    # Vorbedingung: Sperre frei
    . $modul
    $frei = Sperre-Nehmen 'pruefstand-sperre-test Vorbedingung' 0.05
    if ($frei) { Sperre-Freigeben }
    Pruefe $frei 'Vorbedingung: die Sperre ist frei (kein echter Pruefstand laeuft)'
    if (-not $frei) { throw 'Sperre belegt - Test abgebrochen, nichts gemessen' }

    # --- 1. B wartet auf A --------------------------------------------------
    $a = Kind 'a1' ("if (Sperre-Nehmen 'A1' 1) { 'A-HAT ' + $jetzt; Start-Sleep 8; 'A-FREI ' + $jetzt; Sperre-Freigeben }")
    Start-Sleep -Seconds 2
    $b = Kind 'b1' ("'B-WILL ' + $jetzt; if (Sperre-Nehmen 'B1' 1) { 'B-HAT ' + $jetzt; Sperre-Freigeben }")
    $a.WaitForExit(30000) | Out-Null; $b.WaitForExit(30000) | Out-Null
    $aFrei = Zeit 'a1' 'A-FREI'; $bWill = Zeit 'b1' 'B-WILL'; $bHat = Zeit 'b1' 'B-HAT'; $aHat = Zeit 'a1' 'A-HAT'
    Write-Host ("    A hat {0}, B will {1}, A frei {2}, B hat {3} (ms; B wartete {4} ms)" -f $aHat, $bWill, $aFrei, $bHat, ($bHat - $bWill))
    Pruefe ($aHat -gt 0 -and $bWill -gt $aHat) 'Fall 1: A haelt die Sperre, bevor B sie will'
    Pruefe ($bHat -ge $aFrei -and $aFrei -gt 0) 'Fall 1: B bekommt sie erst nach As Freigabe'
    Pruefe (($bHat - $bWill) -ge 4000) 'Fall 1: B hat nachweislich gewartet (mindestens 4 s)'
    Pruefe (@(Aus 'b1' | Where-Object { $_ -match 'Sperre belegt, warte' -and $_ -match 'A1' }).Count -eq 1) 'Fall 1: B nennt beim Warten den Halter (A1 aus der Halterdatei)'

    # --- 2. abgeschossener Halter gibt frei ----------------------------------
    $a = Kind 'a2' ("if (Sperre-Nehmen 'A2' 1) { 'A-HAT ' + $jetzt; Start-Sleep 60 }")
    Start-Sleep -Seconds 3
    $b = Kind 'b2' ("'B-WILL ' + $jetzt; if (Sperre-Nehmen 'B2' 1) { 'B-HAT ' + $jetzt; Sperre-Freigeben }")
    Start-Sleep -Seconds 3
    Stop-Process -Id $a.Id -Force
    $tot = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
    $b.WaitForExit(30000) | Out-Null
    $bHat = Zeit 'b2' 'B-HAT'
    Write-Host ("    A abgeschossen {0}, B hat {1} (ms)" -f $tot, $bHat)
    Pruefe ($bHat -ge $tot -and ($bHat - $tot) -lt 10000) 'Fall 2: nach dem Abschuss des Halters bekommt B die Sperre binnen 10 s'
    Pruefe (@(Aus 'b2' | Where-Object { $_ -match 'verlassen vorgefunden' }).Count -eq 1) 'Fall 2: B meldet die verlassene Sperre'

    # --- 3. Zeitschranke -----------------------------------------------------
    $a = Kind 'a3' ("if (Sperre-Nehmen 'A3' 1) { Start-Sleep 20; Sperre-Freigeben }")
    Start-Sleep -Seconds 3
    $b = Kind 'b3' ("if (Sperre-Nehmen 'B3' 0.1) { 'B-HAT' ; Sperre-Freigeben } else { 'B-ABGEWIESEN' }")
    $b.WaitForExit(30000) | Out-Null
    Pruefe (@(Aus 'b3' | Where-Object { $_ -eq 'B-ABGEWIESEN' }).Count -eq 1) 'Fall 3: nach der Zeitschranke gibt B auf'
    Pruefe (@(Aus 'b3' | Where-Object { $_ -match 'NICHT ERHALTEN' -and $_ -match 'A3' }).Count -eq 1) 'Fall 3: B nennt den Halter'
    Pruefe (@(Aus 'b3' | Where-Object { $_ -eq 'B-HAT' }).Count -eq 0) 'Fall 3 (Gegenprobe): B bekommt sie nicht'
    $a.WaitForExit(30000) | Out-Null

    # --- 4. Erben ------------------------------------------------------------
    $kindDatei = Join-Path $tmp 'kind4.ps1'
    [IO.File]::WriteAllText($kindDatei, ". '" + $modul + "'`r`nif (Sperre-Nehmen 'K4' 0.05) { if (`$script:SperreGeerbt) { 'GEERBT' } else { 'SELBST'; Sperre-Freigeben } } else { 'WARTET-VERGEBLICH' }")
    $a = Kind 'a4' ("if (Sperre-Nehmen 'A4' 1) { & powershell -NoProfile -ExecutionPolicy Bypass -File '" + $kindDatei + "'; `$env:EUDORA72_SPERRE = '4'; & powershell -NoProfile -ExecutionPolicy Bypass -File '" + $kindDatei + "'; Sperre-Freigeben }")
    $a.WaitForExit(60000) | Out-Null
    $aus4 = @(Aus 'a4')
    Pruefe ($aus4 -contains 'GEERBT') 'Fall 4: das Kind des Halters erbt die Sperre'
    Pruefe ($aus4 -contains 'WARTET-VERGEBLICH') 'Fall 4 (Gegenprobe): eine gefaelschte pid in EUDORA72_SPERRE erbt nicht, das Kind wartet'

    # nach allem: frei, Halterdatei weg
    $frei = Sperre-Nehmen 'pruefstand-sperre-test Nachbedingung' 0.1
    if ($frei) { Sperre-Freigeben }
    Pruefe $frei 'Nachher: die Sperre ist wieder frei'

    # --- 5. Zuruecksetzen nur eigener Werte ----------------------------------
    $basis = 'HKCU:\Software\Eudora72Probe'
    $roh = 'HKCU\Software\Eudora72Probe'
    if (Test-Path $basis) { Remove-Item $basis -Recurse -Force }
    New-Item -Path "$basis\CommandLine" -Force | Out-Null
    New-Item -Path "$basis\LaunchManager" -Force | Out-Null
    New-ItemProperty "$basis\CommandLine" -Name Current -Value 'C:\Users\X\Eudora72-7.2.1.131-release\Eudora.exe C:\Users\X\Eudora72-7.2.1.131-release\MAILVE~1' -PropertyType String | Out-Null
    New-ItemProperty "$basis\CommandLine" -Name Zweit -Value 'C:\Users\X\alt' -PropertyType String | Out-Null
    New-ItemProperty "$basis\LaunchManager" -Name PathCount -Value 1 -PropertyType DWord | Out-Null
    New-ItemProperty "$basis\LaunchManager" -Name 'Path#0' -Value 'c:\users\x\attach' -PropertyType String | Out-Null
    cmd.exe /c ('reg.exe add "' + $roh + '\C:\Temp\Alt" /f >nul 2>nul')
    $bild = Registry-Festhalten $basis

    # der "Lauf": eigene Werte
    Set-ItemProperty "$basis\CommandLine" -Name Current -Value 'C:\Temp\E133\Eudora.exe C:\Temp\E133-gibt-es-nicht'
    Set-ItemProperty "$basis\LaunchManager" -Name PathCount -Value 2
    New-ItemProperty "$basis\LaunchManager" -Name 'Path#1' -Value 'c:\temp\e133\mailverzeichnis\attach' -PropertyType String | Out-Null
    New-ItemProperty "$basis\LaunchManager" -Name 'WarnExtensions#1' -Value 'exe|' -PropertyType String | Out-Null
    cmd.exe /c ('reg.exe add "' + $roh + '\C:\Temp\E133\Mailverzeichnis" /f >nul 2>nul')
    # gleichzeitig fremd (etwa Gregor selbst)
    Set-ItemProperty "$basis\CommandLine" -Name Zweit -Value 'C:\Users\X\neu'
    New-ItemProperty "$basis\CommandLine" -Name FremdNeu -Value 'C:\Users\X\fremd' -PropertyType String | Out-Null

    [void](Registry-Zurueck $bild)
    $cl = Get-ItemProperty "$basis\CommandLine"
    $lm = Get-Item "$basis\LaunchManager"
    Pruefe ($cl.Current -like 'C:\Users\X\Eudora72-7.2.1.131-release\*') 'Fall 5: eigenes Current (Pruefstand) auf den Stand vorher zurueck'
    Pruefe ($cl.Zweit -eq 'C:\Users\X\neu') 'Fall 5 (Gegenprobe): ein fremd geaenderter Wert bleibt stehen'
    Pruefe ($cl.FremdNeu -eq 'C:\Users\X\fremd') 'Fall 5 (Gegenprobe): ein fremd neu angelegter Wert bleibt stehen'
    Pruefe ($null -eq $lm.GetValue('Path#1') -and $null -eq $lm.GetValue('WarnExtensions#1')) 'Fall 5: eigener Path#1 samt Begleitwert entfernt'
    Pruefe ($lm.GetValue('PathCount') -eq 1) 'Fall 5: PathCount zurueck, weil alle neuen Path# eigene waren'
    cmd.exe /c ('reg.exe query "' + $roh + '\C:\Temp\E133" >nul 2>nul'); $e133da = ($LASTEXITCODE -eq 0)
    cmd.exe /c ('reg.exe query "' + $roh + '\C:\Temp\Alt" >nul 2>nul'); $altda = ($LASTEXITCODE -eq 0)
    Pruefe (-not $e133da) 'Fall 5: neuer Unterschluessel C:\Temp\E133 entfernt'
    Pruefe $altda 'Fall 5 (Gegenprobe): vorhandener Unterschluessel C:\Temp\Alt bleibt'

    # fremder Path#: PathCount bleibt
    $bild = Registry-Festhalten $basis
    Set-ItemProperty "$basis\LaunchManager" -Name PathCount -Value 3
    New-ItemProperty "$basis\LaunchManager" -Name 'Path#1' -Value 'c:\temp\e133\x' -PropertyType String | Out-Null
    New-ItemProperty "$basis\LaunchManager" -Name 'Path#2' -Value 'c:\users\x\fremd' -PropertyType String | Out-Null
    [void](Registry-Zurueck $bild)
    $lm = Get-Item "$basis\LaunchManager"
    Pruefe ($lm.GetValue('PathCount') -eq 3 -and $lm.GetValue('Path#2') -eq 'c:\users\x\fremd') 'Fall 5 (Gegenprobe): mit fremdem Path# bleiben PathCount und der fremde Eintrag stehen'
    Pruefe ($null -eq $lm.GetValue('Path#1')) 'Fall 5: der eigene Path#1 geht trotzdem weg'
} catch {
    $fehl++
    Write-Host ('  [FEHL] Ausnahme: ' + $_.Exception.Message)
} finally {
    if (Test-Path 'HKCU:\Software\Eudora72Probe') { Remove-Item 'HKCU:\Software\Eudora72Probe' -Recurse -Force }
    foreach ($p in (Get-CimInstance Win32_Process -Filter "Name='powershell.exe'")) {
        if ($p.CommandLine -and $p.CommandLine.Contains($tmp)) { Stop-Process -Id $p.ProcessId -Force -ErrorAction SilentlyContinue }
    }
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
Write-Host ("  Ergebnis: {0} Pruefungen, {1} bestanden, {2} fehlgeschlagen" -f ($gut + $fehl), $gut, $fehl)
exit $fehl
