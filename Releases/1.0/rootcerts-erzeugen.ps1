# rootcerts-erzeugen.ps1
#
# Erzeugt aus einem PEM-Buendel (Mozilla-CA-Liste) eine Datei "rootcerts.p7b"
# im selben Format, das Eudoras QCSSL erwartet: PKCS#7, DER-kodiert, ohne
# Signatur, nur die Zertifikate.
#
# Warum genau dieser Weg:
#   QCSSL laedt den Speicher ueber die Windows-CryptoAPI
#   (CertificateStore::LoadFromFile -> CERT_STORE_PROV_FILENAME_A,
#    Eudora71/QCSSL/src/certstore.cpp:82) und schreibt ihn ueber
#   CertSaveStore(..., CERT_STORE_SAVE_AS_PKCS7, ...) zurueck
#   (certstore.cpp:124-129). X509Certificate2Collection.Export(Pkcs7) ruft
#   intern denselben CertSaveStore-Pfad auf. Das Ergebnis ist damit
#   formatgleich zu dem, was Eudora selbst erzeugen wuerde -- es wird nicht
#   nachgebaut, sondern von derselben Systemfunktion geschrieben.
#
# Aufruf:
#   powershell -ExecutionPolicy Bypass -File rootcerts-erzeugen.ps1
#   powershell -ExecutionPolicy Bypass -File rootcerts-erzeugen.ps1 `
#       -Quelle "C:\Pfad\cacert.pem" -Ziel "C:\Pfad\rootcerts.p7b"
#
# Standardquelle ist das CA-Buendel, das Git fuer Windows mitliefert. Das ist
# die Mozilla-CA-Liste in der Aufbereitung des curl-Projekts (cacert.pem).
# Alternativ direkt von https://curl.se/ca/cacert.pem beziehen.

[CmdletBinding()]
param(
    [string]$Quelle = "$env:ProgramFiles\Git\mingw64\etc\ssl\certs\ca-bundle.crt",
    [string]$Ziel   = ''
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrEmpty($Ziel)) {
    $hier = Split-Path -Parent $MyInvocation.MyCommand.Path
    $Ziel = Join-Path $hier 'rootcerts.p7b'
}

if (-not (Test-Path -LiteralPath $Quelle)) {
    throw "Quelldatei nicht gefunden: $Quelle"
}

Write-Host "Quelle : $Quelle"
Write-Host "SHA256 : $((Get-FileHash -LiteralPath $Quelle -Algorithm SHA256).Hash.ToLower())"

$text = Get-Content -LiteralPath $Quelle -Raw

# PEM-Bloecke herausschneiden.
$treffer = [regex]::Matches(
    $text,
    '-----BEGIN CERTIFICATE-----(?<b64>[\s\S]*?)-----END CERTIFICATE-----')

Write-Host "PEM-Bloecke in der Quelle: $($treffer.Count)"

$jetzt      = [DateTime]::UtcNow
$sammlung   = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$uebersprungen = New-Object System.Collections.ArrayList
$zeilen     = New-Object System.Collections.ArrayList

foreach ($t in $treffer) {
    $roh = [Convert]::FromBase64String(($t.Groups['b64'].Value -replace '\s',''))
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 (,$roh)

    # Abgelaufene und noch nicht gueltige Zertifikate bleiben draussen.
    if ($cert.NotAfter.ToUniversalTime() -lt $jetzt -or
        $cert.NotBefore.ToUniversalTime() -gt $jetzt) {
        [void]$uebersprungen.Add("$($cert.Subject) (gueltig bis $($cert.NotAfter.ToUniversalTime().ToString('yyyy-MM-dd')))")
        continue
    }

    [void]$zeilen.Add([PSCustomObject]@{
        Thumbprint = $cert.Thumbprint
        Cert       = $cert
    })
}

# Nach Fingerabdruck sortieren, damit das Ergebnis reproduzierbar ist.
foreach ($z in ($zeilen | Sort-Object Thumbprint)) {
    [void]$sammlung.Add($z.Cert)
}

Write-Host "Uebernommen  : $($sammlung.Count)"
Write-Host "Uebersprungen: $($uebersprungen.Count)"
foreach ($u in $uebersprungen) { Write-Host "  - $u" }

if ($sammlung.Count -eq 0) { throw 'Kein einziges gueltiges Zertifikat uebernommen.' }

$bytes = $sammlung.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs7)
[System.IO.File]::WriteAllBytes($Ziel, $bytes)

Write-Host ''
Write-Host "Ziel   : $Ziel"
Write-Host "Groesse: $($bytes.Length) Bytes"
Write-Host "SHA256 : $((Get-FileHash -LiteralPath $Ziel -Algorithm SHA256).Hash.ToLower())"

# Gegenprobe: die Datei wieder einlesen und zaehlen.
$probe = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$probe.Import($Ziel)
Write-Host "Gegenprobe (wieder eingelesen): $($probe.Count) Zertifikate"
