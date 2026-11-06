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
# DER ABGESCHOSSENE HALTER (PRUEFER-87 N2, 02.11.2026). Wird der Halter von
# aussen beendet, laeuft sein finally nicht; seine Pruefstandswerte bleiben
# stehen, und der naechste hielte sie als "Stand vorher" fest. Darum legt
# Registry-Festhalten den gesicherten Stand als Datei neben die Halterdatei
# (C:\Temp\Eudora72-Pruefstand.reg.xml), Registry-Zurueck loescht sie nach
# getaner Arbeit. Findet Sperre-Nehmen beim Uebernehmen eine solche Datei
# eines ANDEREN Prozesses, setzt es zuerst danach zurueck - erst dann haelt
# der neue Laeufer seinen eigenen Stand fest.
#
# Kodierung: reines ASCII, kein BOM.

$script:SperreDatei   = 'C:\Temp\Eudora72-Pruefstand.lock'
$script:StandDatei    = 'C:\Temp\Eudora72-Pruefstand.reg.xml'
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

    # PRUEFER-87 N2: hat ein frueherer Halter seinen Stand hinterlassen
    # (abgeschossen, finally nie gelaufen), zuerst danach zuruecksetzen.
    if (Test-Path -LiteralPath $script:StandDatei) {
        try {
            $alt = Import-Clixml -LiteralPath $script:StandDatei
            if ($alt.Pid -ne $PID) {
                Write-Host ('  Sperre: Stand eines abgebrochenen Halters gefunden (pid=' + $alt.Pid + ', ' + $alt.Zeit + ') - setze zuerst danach zurueck')
                [void](Registry-Zurueck $alt)
            }
        } catch {
            Write-Host ('  Sperre: hinterlassener Stand nicht lesbar: ' + $_.Exception.Message)
        }
        Remove-Item -LiteralPath $script:StandDatei -Force -ErrorAction SilentlyContinue
    }
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
    # E-243 / Entscheidung 39: ein Wert gehoert nur dann zu einem Pruefstand,
    # wenn er auf ein Verzeichnis mit der Marke .eudora72-pruefstand zeigt
    # (oder ins Scratchpad). Bis 06.11.2026 galt jeder Pfad unter X:\Temp -
    # dort koennen Eudora-Instanzen mit echten Mails liegen, deren
    # Registry-Werte waeren als "eigene" zurueckgesetzt worden (PRUEFER-104 K2).
    $t = '' + $wert
    if ($t -match '(?i)\\appdata\\local\\temp\\claude\\') { return $true }
    # Jeden Pfad einzeln: Eudora schreibt CommandLine\Current ohne
    # Anfuehrungszeichen, mehrere Pfade durch Leerzeichen getrennt, mit
    # 8.3-Kurznamen ("C:\Temp\EUDORA~2\E133\Eudora.exe C:\Temp\EUDORA~2\E133\MAILVE~1 ...").
    # Die erste Fassung las das als EINEN Pfad, kam nicht bis zur Marke und
    # meldete den eigenen Pruefstand als FREMD (gemessen 06.11.2026, Klonprobe).
    foreach ($m in [regex]::Matches($t, '(?i)[a-z]:\\[^"\r\n]*?(?=\s+[a-z]:\\|"|$)')) {
        $p = $m.Value.Trim()
        for ($i = 0; $i -lt 6 -and $p -match '\\'; $i++) {
            if (Test-Path -LiteralPath (Join-Path $p '.eudora72-pruefstand') -ErrorAction SilentlyContinue) { return $true }
            $p = $p -replace '\\[^\\]*$', ''
        }
    }
    return $false
}

function Reg-Unterschluessel([string] $Basis) {
    # <Basis>\C:\Temp ueber reg.exe; Basis in PowerShell-Form "HKCU:\..."
    $roh = ($Basis -replace '^HKCU:\\', 'HKCU\') + '\C:\Temp'
    return @(cmd.exe /c ('reg.exe query "' + $roh + '" 2>nul') | Where-Object { $_ -match '^HKEY_' })
}

function Registry-Festhalten([string] $Basis = 'HKCU:\Software\Qualcomm\Eudora') {
    $bild = @{ Basis = $Basis; Werte = @{}; Unter = @(Reg-Unterschluessel $Basis); Pid = $PID; Zeit = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    foreach ($teil in @('CommandLine', 'LaunchManager')) {
        $s = Join-Path $Basis $teil
        $k = Get-Item -LiteralPath $s -ErrorAction SilentlyContinue
        if (-not $k) { $bild.Werte[$s] = $null; continue }
        $w = @{}
        # Art als Text: uebersteht Export-Clixml/Import-Clixml unveraendert
        foreach ($n in $k.GetValueNames()) { $w[$n] = @($k.GetValue($n, $null, 'DoNotExpandEnvironmentNames'), [string]$k.GetValueKind($n)) }
        $bild.Werte[$s] = $w
    }
    # N2: nur der Halter selbst legt seinen Stand ab (geerbt: der Aufrufer).
    if ($null -ne $script:SperreMutex -and -not $script:SperreGeerbt) {
        try { $bild | Export-Clixml -LiteralPath $script:StandDatei } catch { Write-Host ('  Sperre: Stand nicht abgelegt: ' + $_.Exception.Message) }
    }
    return $bild
}

# Rueckgabe: Zahl der zurueckgesetzten eigenen Werte; fremde werden gemeldet.
function Registry-Zurueck($bild) {
    $eigen = 0
    $fremd = @()
    $fehler = @()
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
            # PRUEFER-87 N7: AlreadyWarned#N gehoert dazu (EuShlExt/RegDefines.h:11)
            $istBegleit = $n -match '^(?:Path|WarnExtensions|DoNotWarnExtensions|AlreadyWarned)#(\d+)$'
            $nr = if ($istBegleit) { $Matches[1] } else { '' }
            # PRUEFER-87 N4: jeder Wert fuer sich - eine Ausnahme bei einem
            # darf die uebrigen und die Freigabe nicht ueberspringen.
            try {
                if ($istBegleit -and $eigeneNr -contains $nr) {
                    Remove-ItemProperty -LiteralPath $s -Name $n -ErrorAction Stop; $eigen++
                } elseif (-not $istBegleit -and (Ist-Pruefstandswert ($k.GetValue($n)))) {
                    Remove-ItemProperty -LiteralPath $s -Name $n -ErrorAction Stop; $eigen++
                } else {
                    $fremd += ($s + '\' + $n + ' (neu)')
                }
            } catch { $fehler += ($s + '\' + $n + ': ' + $_.Exception.Message) }
        }

        foreach ($n in @($vorher.Keys)) {
            $alt = $vorher[$n]
            $jetzt = $k.GetValue($n, $null, 'DoNotExpandEnvironmentNames')
            if ($null -ne $jetzt -and "$jetzt" -eq "$($alt[0])") { continue }
            try {
                if ($n -eq 'PathCount') {
                    if ($fremdeNr.Count -eq 0) {
                        New-ItemProperty -LiteralPath $s -Name $n -Value $alt[0] -PropertyType $alt[1] -Force -ErrorAction Stop | Out-Null; $eigen++
                    } else { $fremd += ($s + '\PathCount (fremde Path#: ' + ($fremdeNr -join ',') + ')') }
                    continue
                }
                if ($null -eq $jetzt -or (Ist-Pruefstandswert $jetzt)) {
                    New-ItemProperty -LiteralPath $s -Name $n -Value $alt[0] -PropertyType $alt[1] -Force -ErrorAction Stop | Out-Null; $eigen++
                } else {
                    $fremd += ($s + '\' + $n + ' = ' + $jetzt)
                }
            } catch { $fehler += ($s + '\' + $n + ': ' + $_.Exception.Message) }
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
    foreach ($f in $fehler) { Write-Host ('  Registry: FEHLER beim Zuruecksetzen: ' + $f) }
    # N2: der abgelegte Stand ist erledigt - nur der eigene
    if ($bild.Pid -eq $PID -and (Test-Path -LiteralPath $script:StandDatei)) {
        Remove-Item -LiteralPath $script:StandDatei -Force -ErrorAction SilentlyContinue
    }
    return $eigen
}
