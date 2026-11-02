# pruefstand-sperre.ps1 - EINE Sperre ueber alle Eudora-Starts aus tools/ und
# das Sichern/Zuruecksetzen der Registry, das zu ihr gehoert.
#
# Einbinden (dot-source):   . (Join-Path $PSScriptRoot 'pruefstand-sperre.ps1')
# Benutzt von tools\testlauf.ps1 und tools\pruefstand-lauf.ps1.
# Selbsttest ohne Eudora-Start: tools\pruefstand-sperre-test.ps1
#
# WARUM ES DAS GIBT. Befund E-157, PRUEFER-87 K1, am 02.11.2026 beobachtet:
# mehrere Arbeitsbaeume fuhren gleichzeitig Pruefstaende. pruefstand-lauf.ps1
# hielt CommandLine und LaunchManager vor dem Lauf fest und schrieb diesen
# Stand danach zurueck - der zweite Lauf hielt dabei den Wert fest, den der
# erste gerade gesetzt hatte, und schrieb ihn am Ende zurueck. Danach zeigte
# CommandLine\Current dauerhaft auf einen Pruefstand (an diesem Nachmittag
# nacheinander E194-140, E194-177, E205, E207-alt, EM141, EM170, EM179),
# im schlimmsten Fall auf C:\Temp\E133-gibt-es-nicht - dann startet Gregors
# Paket per Doppelklick nicht (E-133). testlauf.ps1 allein sicherte gar nichts.
# Zweites Auftreten derselben Klasse nach dem 26.10.2026 (E67, DLLPath):
# Arbeitsweise/fehlerklassen-abstellen.md - Werkzeug und Schranke.
#
# DIE SPERRE. Ein benannter Mutex (Global\Eudora72-Pruefstand, ohne
# Adminrechte anlegbar; sonst Local\). Wer ihn haelt, schreibt pid, Aufrufer
# und Zeit nach C:\Temp\Eudora72-Pruefstand.lock - so kann ein Wartender
# sagen, auf wen er wartet. Gewartet wird hoechstens -Minuten (Vorgabe 15).
# Bricht der Halter ab oder wird abgeschossen, gibt Windows den Mutex als
# "verlassen" frei; der naechste uebernimmt ihn (AbandonedMutexException).
# Kinder erben die Sperre: der Halter setzt EUDORA72_SPERRE=<pid> in seiner
# Prozessumgebung, und ein Kind (pruefstand-lauf -> testlauf, -> messen-*
# -Vorbereiten) nimmt sie nicht ein zweites Mal - sonst wartete es auf
# seinen eigenen Elternprozess. Geerbt gilt nur, wenn die Halterdatei
# dieselbe pid nennt.
#
# DAS ZURUECKSETZEN. Nur eigene Werte: zurueckgesetzt oder entfernt wird ein
# Wert nur, wenn er JETZT auf einen Pruefstand zeigt (Pfad unter <LW>:\Temp\
# oder im Scratchpad ...\AppData\Local\Temp\claude\). Ein Wert, den waehrend
# des Laufs jemand anderes auf etwas anderes gesetzt hat - Gregor selbst
# etwa -, bleibt stehen und wird gemeldet. PathCount wird nur zurueckgesetzt,
# wenn alle neuen Path#-Eintraege eigene waren. Neue Unterschluessel je
# Mailverzeichnis unter <Basis>\C:\Temp\ werden entfernt (PRUEFER-59 K10,
# nur fuer neue). Die Werkzeuge der Registry scheitern am "C:" im
# Schluesselnamen; dafuer reg.exe.
#
# Kodierung: reines ASCII, kein BOM.

$script:SperreDatei   = 'C:\Temp\Eudora72-Pruefstand.lock'
$script:SperreMutex   = $null
$script:SperreGeerbt  = $false
$script:SperreUmgebung = 'EUDORA72_SPERRE'

function Sperre-Halter {
    if (Test-Path -LiteralPath $script:SperreDatei) {
        try { return ((Get-Content -LiteralPath $script:SperreDatei) -join ' ') } catch { }
    }
    return '(keine Halterdatei)'
}

function Sperre-HalterPid {
    if (-not (Test-Path -LiteralPath $script:SperreDatei)) { return 0 }
    foreach ($z in (Get-Content -LiteralPath $script:SperreDatei -ErrorAction SilentlyContinue)) {
        if ($z -match '^pid=(\d+)') { return [int]$Matches[1] }
    }
    return 0
}

# Rueckgabe $true = gehalten (selbst oder geerbt), $false = Zeitschranke.
function Sperre-Nehmen([string] $Wer, [double] $Minuten = 15) {
    $erbe = [Environment]::GetEnvironmentVariable($script:SperreUmgebung)
    if ($erbe -and ($erbe -as [int]) -and (Sperre-HalterPid) -eq [int]$erbe -and
        (Get-Process -Id ([int]$erbe) -ErrorAction SilentlyContinue)) {
        $script:SperreGeerbt = $true
        Write-Host ('  Sperre: gehalten vom aufrufenden Prozess ' + $erbe + ' (geerbt)')
        return $true
    }

    $m = $null
    foreach ($name in @('Global\Eudora72-Pruefstand', 'Local\Eudora72-Pruefstand')) {
        try { $m = New-Object System.Threading.Mutex($false, $name); break } catch { $m = $null }
    }
    if (-not $m) { Write-Host '  SPERRE: Mutex nicht anlegbar'; return $false }

    $frist = (Get-Date).AddMinutes($Minuten)
    $gemeldet = $false
    while ($true) {
        $hab = $false
        try {
            $hab = $m.WaitOne(2000)
        } catch {
            $ex = $_.Exception
            while ($ex -and -not ($ex -is [System.Threading.AbandonedMutexException])) { $ex = $ex.InnerException }
            if ($ex) {
                $hab = $true
                Write-Host ('  Sperre: verlassen vorgefunden (Halter abgebrochen: ' + (Sperre-Halter) + ') - uebernommen')
            } else { throw }
        }
        if ($hab) { break }
        if (-not $gemeldet) {
            Write-Host ('  Sperre belegt, warte hoechstens {0} min - Halter: {1}' -f $Minuten, (Sperre-Halter))
            $gemeldet = $true
        }
        if ((Get-Date) -gt $frist) {
            $m.Dispose()
            Write-Host ('  SPERRE NICHT ERHALTEN nach {0} min - Halter: {1}' -f $Minuten, (Sperre-Halter))
            return $false
        }
    }
    $script:SperreMutex = $m
    $text = 'pid=' + $PID + "`r`n" + 'wer=' + $Wer + "`r`n" + 'seit=' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + "`r`n"
    try { [IO.File]::WriteAllText($script:SperreDatei, $text) } catch { }
    [Environment]::SetEnvironmentVariable($script:SperreUmgebung, [string]$PID)
    Write-Host ('  Sperre genommen: pid=' + $PID + ' wer=' + $Wer)
    return $true
}

function Sperre-Freigeben {
    if ($script:SperreGeerbt) { return }
    if ($null -eq $script:SperreMutex) { return }
    if ((Sperre-HalterPid) -eq $PID) { Remove-Item -LiteralPath $script:SperreDatei -Force -ErrorAction SilentlyContinue }
    try { $script:SperreMutex.ReleaseMutex() } catch { }
    $script:SperreMutex.Dispose()
    $script:SperreMutex = $null
    [Environment]::SetEnvironmentVariable($script:SperreUmgebung, $null)
    Write-Host ('  Sperre freigegeben: pid=' + $PID)
}

# --- Registry ---------------------------------------------------------------

function Ist-Pruefstandswert($wert) {
    $t = '' + $wert
    return ($t -match '(?i)(^|[^a-z])[a-z]:\\temp\\' -or $t -match '(?i)\\appdata\\local\\temp\\claude\\')
}

function Reg-Unterschluessel([string] $Basis) {
    # <Basis>\C:\Temp ueber reg.exe; Basis in PowerShell-Form "HKCU:\..."
    $roh = ($Basis -replace '^HKCU:\\', 'HKCU\') + '\C:\Temp'
    return @(cmd.exe /c ('reg.exe query "' + $roh + '" 2>nul') | Where-Object { $_ -match '^HKEY_' })
}

function Registry-Festhalten([string] $Basis = 'HKCU:\Software\Qualcomm\Eudora') {
    $bild = @{ Basis = $Basis; Werte = @{}; Unter = @(Reg-Unterschluessel $Basis) }
    foreach ($teil in @('CommandLine', 'LaunchManager')) {
        $s = Join-Path $Basis $teil
        $k = Get-Item -LiteralPath $s -ErrorAction SilentlyContinue
        if (-not $k) { $bild.Werte[$s] = $null; continue }
        $w = @{}
        foreach ($n in $k.GetValueNames()) { $w[$n] = @($k.GetValue($n, $null, 'DoNotExpandEnvironmentNames'), $k.GetValueKind($n)) }
        $bild.Werte[$s] = $w
    }
    return $bild
}

# Rueckgabe: Zahl der zurueckgesetzten eigenen Werte; fremde werden gemeldet.
function Registry-Zurueck($bild) {
    $eigen = 0
    $fremd = @()
    foreach ($s in @($bild.Werte.Keys)) {
        $vorher = $bild.Werte[$s]
        $k = Get-Item -LiteralPath $s -ErrorAction SilentlyContinue
        if ($null -eq $vorher) {
            if ($k) {
                $alle = @($k.GetValueNames() | ForEach-Object { $k.GetValue($_) })
                if (@($alle | Where-Object { -not (Ist-Pruefstandswert $_) }).Count -eq 0) { Remove-Item -LiteralPath $s -Recurse -Force; $eigen++ }
                else { $fremd += ($s + ' (neu, mit fremden Werten)') }
            }
            continue
        }
        if (-not $k) { $k = New-Item -Path $s -Force }

        $namen = @($k.GetValueNames())
        $neu = @($namen | Where-Object { -not $vorher.ContainsKey($_) })

        # neue Path#N: eigene samt ihren Begleitwerten weg
        $eigeneNr = @()
        $fremdeNr = @()
        foreach ($n in $neu) {
            if ($n -match '^Path#(\d+)$') {
                $nr = $Matches[1]
                if (Ist-Pruefstandswert ($k.GetValue($n))) { $eigeneNr += $nr } else { $fremdeNr += $nr }
            }
        }
        foreach ($n in $neu) {
            $istBegleit = $n -match '^(?:Path|WarnExtensions|DoNotWarnExtensions)#(\d+)$'
            $nr = if ($istBegleit) { $Matches[1] } else { '' }
            if ($istBegleit -and $eigeneNr -contains $nr) {
                Remove-ItemProperty -LiteralPath $s -Name $n; $eigen++
            } elseif (-not $istBegleit -and (Ist-Pruefstandswert ($k.GetValue($n)))) {
                Remove-ItemProperty -LiteralPath $s -Name $n; $eigen++
            } else {
                $fremd += ($s + '\' + $n + ' (neu)')
            }
        }

        foreach ($n in @($vorher.Keys)) {
            $alt = $vorher[$n]
            $jetzt = $k.GetValue($n, $null, 'DoNotExpandEnvironmentNames')
            if ($null -ne $jetzt -and "$jetzt" -eq "$($alt[0])") { continue }
            if ($n -eq 'PathCount') {
                if ($fremdeNr.Count -eq 0) {
                    New-ItemProperty -LiteralPath $s -Name $n -Value $alt[0] -PropertyType $alt[1] -Force | Out-Null; $eigen++
                } else { $fremd += ($s + '\PathCount (fremde Path#: ' + ($fremdeNr -join ',') + ')') }
                continue
            }
            if ($null -eq $jetzt -or (Ist-Pruefstandswert $jetzt)) {
                New-ItemProperty -LiteralPath $s -Name $n -Value $alt[0] -PropertyType $alt[1] -Force | Out-Null; $eigen++
            } else {
                $fremd += ($s + '\' + $n + ' = ' + $jetzt)
            }
        }
    }

    foreach ($u in (Reg-Unterschluessel $bild.Basis)) {
        if ($bild.Unter -notcontains $u) {
            cmd.exe /c ('reg.exe delete "' + $u + '" /f >nul 2>nul')
            $eigen++
        }
    }

    Write-Host ('  Registry: {0} eigene(r) Wert(e)/Schluessel auf den Stand vor dem Lauf zurueckgesetzt' -f $eigen)
    foreach ($f in $fremd) { Write-Host ('  Registry: FREMD, nicht angefasst: ' + $f) }
    return $eigen
}
