# pruefserver-aufraeumen.ps1 - Pruefserver-Reste dieses Repos beenden, Ports pruefen.
#
# -------------------------------------------------------------------------
# WARUM ES DAS GIBT
# -------------------------------------------------------------------------
#
# Gregor am 05.11.2026, zum Pruefstand aus einem frischen Klon (E-151):
# "beim absturz muss er aufgeraeumt werden, so dass nicht bei 3x starten auch
# 3 mail server im hintergrund laufen [und] sich gegenseitig stoeren."
#
# Die Messskripte starten ihre Pruefserver (perl tools\anhang-pruefdaten.pl
# fuer POP, tools\imap-pruefserver.pl fuer IMAP, tools\smtp-pruefserver.pl
# fuer SMTP) und beenden sie am Ende selbst. Wird ein Lauf hart abgebrochen
# (Fenster zu, Strg+C, Absturz), bleibt der Server stehen und haelt seinen
# Port. Der naechste Lauf startet einen zweiten, der den Port nicht bekommt -
# oder, schlimmer, Eudora spricht mit dem alten Server und dessen alter Post.
#
# -------------------------------------------------------------------------
# WAS ES TUT
# -------------------------------------------------------------------------
#
# Beendet NUR perl-Prozesse, deren Befehlszeile auf einen Pruefserver in
# DIESEM Repo zeigt (<repo>\tools\<server>.pl). Fremde perl.exe und die
# Pruefserver anderer Arbeitsbaeume werden nie angefasst
# (Arbeitsweise/nichts-auf-gregors-bildschirm-starten.md: nach Pfad filtern).
# Danach prueft es, ob die Pruefstand-Ports frei sind, und nennt den Prozess,
# der einen Port haelt.
#
# Einbinden (dot-source):  . (Join-Path $PSScriptRoot 'pruefserver-aufraeumen.ps1')
#                          Pruefserver-Aufraeumen -Repo $wurzel   -> Anzahl beendet
#                          Pruefports-Belegt -> Liste "Port 1143: perl.exe (PID 123) ..."
# Allein:                  powershell -File tools\pruefserver-aufraeumen.ps1 [-NurZeigen]
#
# Kodierung: reines ASCII, nur LF.

$script:PruefServerSkripte = @('anhang-pruefdaten.pl', 'imap-pruefserver.pl', 'smtp-pruefserver.pl', 'e169-bildserver.pl')
# 11110 POP (anhang-pruefdaten.pl), 1143/1144 IMAP (zwei Konten bei E-188),
# 1025 SMTP (smtp-pruefserver.pl), 18169 Bilder fuer E-169 (e169-bildserver.pl,
# seit 06.11.2026 - LEKTOR-156 L-156.2: bricht ein Lauf waehrend E-169 ab,
# blieb er sonst stehen).
$script:PruefPorts = @(11110, 1143, 1144, 1025, 18169)

function Pruefserver-Finden([string] $Repo) {
    $tools = ([IO.Path]::GetFullPath((Join-Path $Repo 'tools'))).TrimEnd('\') + '\'
    $liste = @()
    $procs = @(Get-CimInstance Win32_Process -Filter "Name='perl.exe'" -ErrorAction SilentlyContinue)
    foreach ($p in $procs) {
        $cl = [string]$p.CommandLine
        if ($cl -eq '') { continue }
        foreach ($s in $script:PruefServerSkripte) {
            if ($cl.IndexOf($tools + $s, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
                $liste += [pscustomobject]@{ Id = [int]$p.ProcessId; Skript = $s; Befehl = $cl }
                break
            }
        }
    }
    return $liste
}

function Pruefserver-Aufraeumen([string] $Repo, [switch] $Still) {
    $n = 0
    foreach ($s in @(Pruefserver-Finden $Repo)) {
        try {
            Stop-Process -Id $s.Id -Force -ErrorAction Stop
            $n++
            if (-not $Still) { Write-Host ("    Pruefserver-Rest beendet: {0} (PID {1})" -f $s.Skript, $s.Id) }
        } catch { }
    }
    if ($n -gt 0) { Start-Sleep -Milliseconds 500 }
    return $n
}

function Pruefports-Belegt {
    $belegt = @()
    foreach ($port in $script:PruefPorts) {
        $c = @(Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue)
        foreach ($x in $c) {
            $pr = Get-CimInstance Win32_Process -Filter ("ProcessId=" + $x.OwningProcess) -ErrorAction SilentlyContinue
            $name = if ($pr) { $pr.Name } else { '?' }
            $cl = if ($pr) { [string]$pr.CommandLine } else { '' }
            $belegt += ("Port {0}: {1} (PID {2}) {3}" -f $port, $name, $x.OwningProcess, $cl)
        }
    }
    return $belegt
}

# --- allein aufgerufen -----------------------------------------------------
if ($MyInvocation.InvocationName -ne '.') {
    $nurZeigen = $args -contains '-NurZeigen'
    $repo = Split-Path -Parent $PSScriptRoot
    $gef = @(Pruefserver-Finden $repo)
    Write-Host ("  Pruefserver dieses Repos: {0}" -f $gef.Count)
    foreach ($g in $gef) { Write-Host ("    PID {0}  {1}" -f $g.Id, $g.Skript) }
    if (-not $nurZeigen -and $gef.Count -gt 0) { [void](Pruefserver-Aufraeumen $repo) }
    $b = @(Pruefports-Belegt)
    if ($b.Count -eq 0) { Write-Host '  Ports 11110, 1143, 1144, 1025: frei' }
    else { foreach ($x in $b) { Write-Host ("  BELEGT: {0}" -f $x) } }
    exit $(if ($b.Count -gt 0) { 1 } else { 0 })
}
