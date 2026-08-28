# ---------------------------------------------------------------------------
#  messen.ps1 - fuehrt den kompletten Komponententest der TLS-Schicht aus.
#
#  Ablauf:
#    1. Testzertifikate erzeugen (Test-CA, gueltig, abgelaufen, falscher
#       Hostname, selbstsigniert) und rootcerts.p7b schreiben
#    2. lokale TLS-Server auf 127.0.0.1:14431..14438 starten
#    3. tlstest.exe    - Messung auf OpenSSL-Ebene (Weg a)
#    4. qcsslprobe.exe - Messung ueber die echte QCSSL.dll (Weg b)
#    5. Server beenden
#
#  Vorher einmal bauen:   .\bauen.bat
#
#  Aufruf:
#    powershell -ExecutionPolicy Bypass -File .\messen.ps1
#    powershell -ExecutionPolicy Bypass -File .\messen.ps1 -Badssl
#
#  -Badssl nimmt zusaetzlich Netzverbindungen zu badssl.com auf. Es werden
#  ausschliesslich TLS-Handshakes durchgefuehrt, keine Nutzdaten uebertragen.
# ---------------------------------------------------------------------------

param(
    [switch]$Badssl,
    [string]$Dll = "",
    [string]$EudoraCertDir = ""
)

$ErrorActionPreference = "Stop"

$Test = Split-Path -Parent $MyInvocation.MyCommand.Path
$Repo = Resolve-Path (Join-Path $Test "..\..\..")
$Bin  = Join-Path $Test "bin"
$Work = Join-Path $Test "work"

if ($Dll -eq "") { $Dll = Join-Path $Repo "Releases\1.0\QCSSL.dll" }
if ($EudoraCertDir -eq "") { $EudoraCertDir = Join-Path $Repo "Eudora71\Bin\Release" }

if (-not (Test-Path (Join-Path $Bin "tlstest.exe"))) {
    Write-Host "FEHLER: bin\tlstest.exe fehlt. Zuerst bauen.bat aufrufen."
    exit 1
}
if (-not (Test-Path $Work)) { New-Item -ItemType Directory $Work | Out-Null }

Write-Host "=== 1. Testzertifikate erzeugen ==="
& (Join-Path $Bin "tlstest.exe") gen $Work

Write-Host ""
Write-Host "=== 2. Lokale TLS-Server starten ==="
$srv = Start-Process -FilePath (Join-Path $Bin "tlstest.exe") `
                     -ArgumentList @("servers", $Work) `
                     -PassThru -WindowStyle Hidden `
                     -RedirectStandardOutput (Join-Path $Work "servers.log")
Start-Sleep -Seconds 2
Write-Host "  PID $($srv.Id)"

try
{
    Write-Host ""
    Write-Host "=== 3. Weg a: Messung direkt auf OpenSSL-Ebene ==="
    & (Join-Path $Bin "tlstest.exe") client $Work --local |
        Tee-Object -FilePath (Join-Path $Work "ergebnis_openssl_lokal.txt")

    Write-Host ""
    Write-Host "=== 4. Weg b: Messung ueber die echte QCSSL.dll ==="
    Write-Host "  DLL: $Dll"

    $faelle = @(
        @(14431, 0, "1a gueltiges Zertifikat (Erwartung ERFOLG)"),
        @(14432, 0, "1b abgelaufenes Zertifikat (Erwartung FEHLSCHLAG)"),
        @(14433, 0, "1c falscher Hostname (Erwartung FEHLSCHLAG)"),
        @(14434, 0, "1d selbstsigniert (Erwartung FEHLSCHLAG)"),
        @(14435, 0, "2a Server nur TLS 1.0 (Erwartung FEHLSCHLAG)"),
        @(14436, 0, "2b Server nur TLS 1.1 (Erwartung FEHLSCHLAG)"),
        @(14437, 0, "2c Server nur TLS 1.2 (Erwartung ERFOLG)"),
        @(14438, 0, "2d Server nur TLS 1.3 (Erwartung ERFOLG)"),
        @(14435, 3, "2e ProtocolVersion=3 gegen Server nur TLS 1.0")
    )

    $ausgabe = @()
    foreach ($f in $faelle)
    {
        $ausgabe += (& (Join-Path $Bin "qcsslprobe.exe") $Dll $Work "localhost" $f[0] $f[1] $f[2] 2>&1)
    }
    $ausgabe | Tee-Object -FilePath (Join-Path $Work "ergebnis_qcssl_lokal.txt")

    if ($Badssl)
    {
        Write-Host ""
        Write-Host "=== 5. Gegenprobe im Netz (badssl.com), Wurzelspeicher von Eudora ==="
        & (Join-Path $Bin "tlstest.exe") client $EudoraCertDir --badssl |
            Tee-Object -FilePath (Join-Path $Work "ergebnis_badssl_eudora_roots.txt")

        $netz = @()
        foreach ($f in @(@("badssl.com",443,"N1 badssl.com"),
                         @("self-signed.badssl.com",443,"N2 selbstsigniert"),
                         @("tls-v1-0.badssl.com",1010,"N3 Server TLS 1.0"),
                         @("tls-v1-2.badssl.com",1012,"N4 Server TLS 1.2")))
        {
            $netz += (& (Join-Path $Bin "qcsslprobe.exe") $Dll $EudoraCertDir $f[0] $f[1] 0 $f[2] 2>&1)
        }
        $netz | Tee-Object -FilePath (Join-Path $Work "ergebnis_qcssl_badssl.txt")
    }
}
finally
{
    Write-Host ""
    Write-Host "=== Server beenden ==="
    Stop-Process -Id $srv.Id -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Fertig. Protokolle liegen in $Work"
