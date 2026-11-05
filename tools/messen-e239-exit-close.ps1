# messen-e239-exit-close.ps1 - Pruefstandsfall E-239p: tools\messen-e239.ps1
# in der Betriebsart, die den Absturz traf (File > Exit gleich nach dem Abruf,
# bei offenem Hinweis dann WM_CLOSE).
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
    & powershell -NoProfile -ExecutionPolicy Bypass -File $skript -Pfadfilter $Pfadfilter -Vorbereiten -Weg 'exit-close'
} else {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $skript -Pfadfilter $Pfadfilter -Weg 'exit-close'
}
exit $LASTEXITCODE
