param([string] $Eml, [int] $Anzahl = 3, [string] $Kennung = 'serie', [string] $Verzeichnis = 'C:\Temp\E118', [switch] $OhneZielFenster, [int] $GrussVerzoegerung = 0, [switch] $AppendAblehnen, [switch] $OhneAppendUid)
# Mehrere Messlaeufe E-118 hintereinander, je mit frischem Posteingang und frischen Pruefservern.
$repo = 'C:\Users\Gregor\Documents\github\Eudora7.2'
$sp   = $PSScriptRoot   # messen-e118.ps1 liegt daneben (tools/)
$perl = 'C:\Program Files\Git\usr\bin\perl.exe'
$m    = Join-Path $Verzeichnis 'Mailverzeichnis'
$abl  = Join-Path $Verzeichnis 'ablage'
for ($i = 1; $i -le $Anzahl; $i++) {
    Remove-Item -Recurse -Force $abl -ErrorAction SilentlyContinue; New-Item -ItemType Directory $abl | Out-Null
    foreach ($f in 'In.mbx','In.toc','OWNER.LOK') { Remove-Item (Join-Path $m $f) -Force -ErrorAction SilentlyContinue }
    if ($OhneZielFenster) { $ini = Join-Path $m 'Eudora.ini'; $z = Get-Content $ini; $z | Where-Object { $_ -notmatch '^OpenWindow[0-9]+=.*Ablage' } | Set-Content $ini -Encoding Default }
    # Ordnerliste des Pruefkontos auf den Ausgangsstand (Ablage waehlbar)
    foreach ($f in 'Ablage\Ablage.mbx','Ablage\Ablage.toc','Ablage\Ablage.inf','Ablage\tmp_Ablage.tbx','INBOX\INBOX.mbx','INBOX\INBOX.toc','INBOX\INBOX.inf') { Remove-Item (Join-Path $m "Imap\pruefimap\$f") -Force -ErrorAction SilentlyContinue }
    [IO.File]::WriteAllText((Join-Path $m 'Imap\pruefimap\actionqueue.dat'), "<IMAPQueueData>`r`n`t<DataFormatVersion>1</DataFormatVersion>`r`n</IMAPQueueData>`r`n")
    $ml = Join-Path $m 'Imap\pruefimap\mboxlist.lst'; if (Test-Path $ml) { [IO.File]::WriteAllText($ml, "INBOX,INBOX,M,/,0,0,0,0,Y,0`r`nAblage,Ablage,M,/,0,0,0,0,Y,0`r`n") }
    Get-ChildItem $m -Filter 'lmos.dat*' -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem (Join-Path $m 'spool') -Filter 'lmos.dat*' -ErrorAction SilentlyContinue | Remove-Item -Force
    if (Test-Path (Join-Path $m 'eudora.log')) { Move-Item (Join-Path $m 'eudora.log') (Join-Path $m "eudora-$Kennung-$i-vorher.log") -Force }
    $imapArgs = @("$repo\tools\imap-pruefserver.pl", '--port', '1143', '--ablage', $abl, '--protokoll', (Join-Path $Verzeichnis "imap-$Kennung-$i.log"), '--zeitschranke', '200', '--gruss-verzoegerung', "$GrussVerzoegerung")
    if ($AppendAblehnen) { $imapArgs += '--append-ablehnen' }
    if ($OhneAppendUid) { $imapArgs += '--ohne-appenduid' }
    $imap = Start-Process $perl -ArgumentList $imapArgs -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    $pop  = Start-Process $perl -ArgumentList @("$repo\tools\anhang-pruefdaten.pl", '--pop', '--nur-eml', '--eml', $Eml) -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Start-Sleep -Seconds 2
    $env:E118_ABLAGE = $abl
    & powershell -NoProfile -ExecutionPolicy Bypass -File "$repo\tools\testlauf.ps1" -Verzeichnis $Verzeichnis -Freigabe "Gregor am 14.10.2026: 'ich mache gar nichts, du testest.' - E-118 $Kennung Lauf $i" -Sekunden 60 -MessenSkript "$sp\messen-e118.ps1" | Out-Null
    foreach ($p in $imap, $pop) { if (-not $p.HasExited) { Stop-Process -Id $p.Id -Force } }
    $n = @(Get-ChildItem $abl -ErrorAction SilentlyContinue).Count
    Write-Host "== Lauf ${i}: ablage=$n"
    Select-String -Path (Join-Path $m 'eudora.log') -Pattern 'E-118 (Ziel|Ueber|Hoch|Bild)' | ForEach-Object { '  ' + $_.Line.Substring([Math]::Min(17, $_.Line.Length)) } | ForEach-Object { $_.Substring(0, [Math]::Min(200, $_.Length)) }
    Copy-Item (Join-Path $m 'eudora.log') (Join-Path $m "eudora-$Kennung-$i.log") -Force
    if ($n -gt 0) { Copy-Item (Join-Path $abl '*') (Join-Path $Verzeichnis "ablage-$Kennung-$i-") -ErrorAction SilentlyContinue }
}
