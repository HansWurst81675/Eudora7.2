# messen-e166-konto.ps1 - Regressionsfall zu E-166 fuer tools\pruefstand-lauf.ps1
# (Schalter messen=tools\messen-e166-konto.ps1 in tools\pruefstand-faelle.txt).
#
# E-166: CPersonality::Modify leerte den INI-Zwischenspeicher ohne ihn vorher
# zu schreiben. Wer die Junk-Frage beantwortete und danach Konto ->
# Eigenschaften mit OK schloss, verlor die Antwort (AskedAboutJunk), und die
# Frage kam beim naechsten Start wieder. Gemessen am 28.10.2026: rot am
# Paket 1.0.127, gruen nach der Behebung in persona.cpp.
#
#   -Vorbereiten (vor dem Start): AskedAboutJunk und UseJunkMailbox aus der
#       Eudora.ini nehmen - sonst kommt die Frage nicht und der Fall misst
#       nichts. Die Persoenlichkeiten-Leiste aus dem Vordergrund nehmen
#       (Reiterindex am Ende von WazooBar318) - sonst entsteht ihre Liste
#       nicht neu und messen-e166-assistent.ps1 findet sie nicht (am
#       28.10.2026 so geschehen). Ohne Konto in [Settings] bricht es ab.
#   ohne Schalter: messen-e166-assistent.ps1 mit E166_KONTO=1 - Junk-Frage
#       mit No beantworten, danach Konto -> Eigenschaften mit OK schliessen.
#
# Behauptungen stehen in pruefstand-faelle.txt: die Messung muss
# "reihenfolge=junk-no,konto-ok" melden (sonst lief der Weg nicht), die INI
# nach dem Beenden muss "AskedAboutJunk=6" tragen.
#
# Voraussetzung, die NICHT im Repo liegt: MFC71.DLL und msvcp71.dll neben der
# Eudora.exe im Pruefstand - ohne sie laden die Junk-Zusaetze nicht und die
# Frage kommt nie (E-166, S-3c). Sie sind nicht zur Weitergabe freigegeben
# (Intern/FILTER.md); am 28.10.2026 von Gregors Rechner, nur fuer C:\Temp\E166.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'

if ($Vorbereiten) {
    foreach ($dll in 'MFC71.DLL', 'msvcp71.dll') {
        if (-not (Test-Path -LiteralPath (Join-Path $Pfadfilter $dll))) {
            Write-Output ('E166K FEHLER: ' + $dll + ' fehlt in ' + $Pfadfilter + ' - die Junk-Frage kaeme nie')
            exit 1
        }
    }
    $ini = Join-Path $Pfadfilter 'Mailverzeichnis\Eudora.ini'
    $zeilen = @(Get-Content -LiteralPath $ini)
    if (-not ($zeilen -match '^ReturnAddress=.+')) {
        Write-Output ('E166K FEHLER: kein Konto in ' + $ini + ' - es kaeme der Konto-Assistent')
        exit 1
    }
    $neu = $zeilen | Where-Object { $_ -notmatch '^(AskedAboutJunk|UseJunkMailbox)=' } |
           ForEach-Object { if ($_ -match '^WazooBar318=') { $_ -replace ',\d+$', '' } else { $_ } }
    Set-Content -LiteralPath $ini -Value $neu -Encoding ascii
    Write-Output 'E166K vorbereitet: AskedAboutJunk und UseJunkMailbox entfernt'
    exit 0
}

$env:E166_ERKUNDEN = '0'
$env:E166_FERTIG   = '0'
$env:E166_KONTO    = '1'
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'messen-e166-assistent.ps1') -Pfadfilter $Pfadfilter
exit $LASTEXITCODE
