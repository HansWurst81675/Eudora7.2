# messen-e239-exit-close.ps1 - Pruefstandsfall E-239p: tools\messen-e239.ps1
# in der Betriebsart hinweis-exit-close (seit 06.11.2026, PRUEFER-103 K2: erst
# auf den Hinweis warten, dann File > Exit und WM_CLOSE; exit-close war ein
# Wettlauf und am alten Bau mal rot, mal blind gruen).
#
# WARUM ES DAS GIBT (PRUEFER-102 K2). Die Betriebsart stand in
# <Pruefstand>\modus.txt, ausserhalb des Repos, mit stiller Vorgabe "einfach" -
# mit "einfach" stuerzte auch der alte Bau nicht ab. tools\pruefstand-lauf.ps1
# kennt als Schalter nur messen=<skript>; deshalb legt dieses Skript die
# Betriebsart fest und reicht alles andere unveraendert durch.
#
# Kodierung: reines ASCII, kein BOM.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$skript = Join-Path $PSScriptRoot 'messen-e239.ps1'
if ($Vorbereiten) {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $skript -Pfadfilter $Pfadfilter -Vorbereiten -Weg 'hinweis-exit-close'
} else {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $skript -Pfadfilter $Pfadfilter -Weg 'hinweis-exit-close'
}
exit $LASTEXITCODE
