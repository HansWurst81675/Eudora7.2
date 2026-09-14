# e86-messen.ps1 - Befund E-86: wirkt der <body> der Mail noch, wenn Eudora
# sie in sein eigenes HTML-Dokument einwickelt?
#
# Misst nicht die Einschaetzung, sondern MSHTML selbst: dieselbe Mail wird
# zweimal geladen - einmal allein (so zeigt sie der Webbrowser, das ist die
# Referenz) und einmal in genau der Fassung, die CTridentView::WriteTempFile
# (TridentView.cpp 1282-1481) auf die Platte schreibt. Gemessen wird der
# berechnete Stil aus dem DOM, nicht der Quelltext.
#
# Kein Fenster: das WebBrowser-Steuerelement wird nie auf ein Formular gesetzt.
# Jede Warteschleife hat eine Zeitschranke.
#
# Aufruf:  powershell -File tools\e86-messen.ps1
#          powershell -File tools\e86-messen.ps1 -Ablage <verzeichnis>

param(
    [string] $Ablage = (Join-Path $env:TEMP ("e86-" + [System.Guid]::NewGuid().ToString("N").Substring(0,8)))
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $Ablage)) { New-Item -ItemType Directory -Path $Ablage -Force | Out-Null }

# --- ein echtes Bild, damit der Rahmen ueberhaupt entstehen kann ---------
$bmp = New-Object System.Drawing.Bitmap 120, 40
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::FromArgb(255, 220, 30, 30))
$g.Dispose()
$bmp.Save((Join-Path $Ablage 'logo.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

# --- die Mail: ein vollstaendiges HTML-Dokument, wie ein Newsletter es ist
$mail = @'
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Newsletter</title>
<style type="text/css">
img { border: 0; }
body { background-color: #000000; color: #ffffff; }
</style>
</head>
<body bgcolor="#000000" style="background-color:#000000; color:#ffffff;">
<a href="https://example.invalid/"><img src="logo.png" width="120" height="40" alt="Logo"></a>
<p>Newsletter-Text</p>
</body>
</html>
'@

# --- Eudoras Rahmen: Zeichensatzzeile, Stylesheet, Kopfzeilen, <div> ------
# wortgleich zu TridentView.cpp (szCharsetMeta, IDS_INI_READMESSAGE_STYLE_SHEET
# nach CString::Format, WriteHeaders, szDivStart/szDivEnd, LoadMessage)
$stil = @'
<HTML><HEAD><STYLE>
BODY {font-family="Arial"}
TT {font-family="Courier New"}
BLOCKQUOTE.CITE {padding-left:0.5em; margin-left:0; margin-right:0; margin-top:0; margin-bottom:0; border-left:"solid blue";}
SPAN.EUDORAHEADER {color:black; background-color:white; color:windowtext; background-color:window;}
</STYLE></HEAD>
<BODY>
'@

$eudora = "<meta http-equiv=`"Content-Type`" content=`"text/html; charset=windows-1252`">`r`n" +
          $stil +
          "<SPAN CLASS=EUDORAHEADER>From: Newsletter &lt;news@example.invalid&gt;</SPAN><BR>`r`n" +
          "<div>`r`n" + $mail + "`r`n</div>" +
          "</body></html>"

$dateiMail   = Join-Path $Ablage 'mail-allein.htm'
$dateiEudora = Join-Path $Ablage 'eudora-fassung.htm'
[System.IO.File]::WriteAllText($dateiMail,   $mail,   [System.Text.Encoding]::GetEncoding(1252))
[System.IO.File]::WriteAllText($dateiEudora, $eudora, [System.Text.Encoding]::GetEncoding(1252))

function Messen([string] $pfad, [string] $name) {
    $wb = New-Object System.Windows.Forms.WebBrowser
    $wb.ScriptErrorsSuppressed = $true
    $wb.AllowNavigation = $true
    $wb.Navigate(([System.Uri] $pfad).AbsoluteUri)

    $ende = (Get-Date).AddSeconds(20)
    while ($wb.ReadyState -ne [System.Windows.Forms.WebBrowserReadyState]::Complete -and (Get-Date) -lt $ende) {
        [System.Windows.Forms.Application]::DoEvents()
        Start-Sleep -Milliseconds 50
    }
    if ($wb.ReadyState -ne [System.Windows.Forms.WebBrowserReadyState]::Complete) {
        Write-Output "$name : ZEITSCHRANKE - nicht fertig geladen"
        $wb.Dispose()
        return
    }
    # Das Bild wird erst nach ReadyState gerechnet; kurz nachlaufen lassen.
    $ende2 = (Get-Date).AddSeconds(3)
    while ((Get-Date) -lt $ende2) { [System.Windows.Forms.Application]::DoEvents(); Start-Sleep -Milliseconds 50 }

    $doc = $wb.Document.DomDocument
    $body = $doc.body

    $hg    = $body.currentStyle.backgroundColor
    $vg    = $body.currentStyle.color
    $bgcol = $body.bgColor
    $blaetter = $doc.styleSheets.length

    $bildHG = '(kein Bild)'; $rahmenB = '(kein Bild)'; $rahmenF = ''
    if ($doc.images.length -gt 0) {
        $img = $doc.images.item(0)
        $rahmenB = $img.currentStyle.borderTopWidth
        $rahmenF = $img.currentStyle.borderTopColor
        $bildHG  = $img.offsetWidth
    }

    # Modus, damit der Vergleich belastbar ist
    $modus = $doc.documentMode
    $compat = $doc.compatMode

    Write-Output ("{0,-16} Dokumentmodus={1} compatMode={2} Stylesheets={3} body.bgColor={4} body-Hintergrund={5} body-Vordergrund={6} img-Rahmen={7}/{8} img-Breite={9}" -f `
        $name, $modus, $compat, $blaetter, $bgcol, $hg, $vg, $rahmenB, $rahmenF, $bildHG)

    $wb.Dispose()
}

Write-Output "Ablage: $Ablage"
Messen $dateiMail   'MAIL-ALLEIN'
Messen $dateiEudora 'EUDORA-FASSUNG'
