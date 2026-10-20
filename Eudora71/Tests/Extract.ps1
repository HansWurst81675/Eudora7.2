#
# Extract.ps1 - schneidet die zu pruefenden Code-Inseln aus dem Produktivcode heraus
#
# Warum ueberhaupt schneiden: utils.cpp und hexbin.cpp ziehen ueber stdafx.h die
# komplette Eudora-Welt herein (eudora.h, rs.h, guiutils.h, Ressourcen ...) und sind
# darum nicht einzeln uebersetzbar. Statt den Code abzutippen (Kopie veraltet sofort)
# wird er bei JEDEM Build frisch aus den Originaldateien geschnitten. Die Testdateien
# selbst enthalten keinen Produktivcode.
#
# Die Originaldateien werden nur GELESEN, niemals veraendert.
#
# Gelesen wird byteweise ueber Latin-1 (ISO-8859-1). Diese Kodierung bildet jedes Byte
# 0x00..0xFF auf genau einen Codepunkt ab, der Rueckweg beim Schreiben ist damit
# verlustfrei. Das ist wichtig, weil in der Tabelle CP1252-Zeichenliterale wie
# (UCHAR)'<80>' stehen, die kein gueltiges UTF-8 sind.
#

param(
    [Parameter(Mandatory=$true)][string]$SrcDir,
    [Parameter(Mandatory=$true)][string]$OutDir
)

$ErrorActionPreference = "Stop"
$latin1 = [System.Text.Encoding]::GetEncoding(28591)

function Read-Lines([string]$path) {
    if (-not (Test-Path $path)) { throw "Quelldatei nicht gefunden: $path" }
    $text = [System.IO.File]::ReadAllText($path, $latin1)
    return ($text -split "`r`n|`n")
}

# Sucht ab $from die erste Zeile, die auf $pattern passt. Liefert den Index.
function Find-Line($lines, [string]$pattern, [int]$from) {
    for ($i = $from; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match $pattern) { return $i }
    }
    throw "Muster nicht gefunden ab Zeile $($from + 1): $pattern"
}

function Write-Region($lines, [int]$first, [int]$last, [string]$outFile, [string]$srcName) {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("// Automatisch erzeugt von Extract.ps1 - NICHT von Hand aendern.")
    [void]$sb.AppendLine("// Quelle: $srcName, Zeilen $($first + 1) bis $($last + 1)")
    [void]$sb.AppendLine("#line $($first + 1) `"$($srcName -replace '\\','/')`"")
    for ($i = $first; $i -le $last; $i++) {
        [void]$sb.AppendLine($lines[$i])
    }
    [System.IO.File]::WriteAllText($outFile, $sb.ToString(), $latin1)
    Write-Host ("Extract: {0,-28} <- {1} Zeilen {2}..{3}" -f (Split-Path $outFile -Leaf), (Split-Path $srcName -Leaf), ($first + 1), ($last + 1))
}

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

# ---------------------------------------------------------------- utils.cpp
$utilsPath = Join-Path $SrcDir "utils.cpp"
$u = Read-Lines $utilsPath

# Region A: Makros + Uebersetzungstabelle pcXlateTable
$aStart = Find-Line $u '^\s*#define\s+XLATE_CHARS\b' 0
$tabLine = Find-Line $u '^\s*unsigned char\s+pcXlateTable\b' $aStart
$aEnd = Find-Line $u '^\};\s*$' $tabLine
Write-Region $u $aStart $aEnd (Join-Path $OutDir "utils_table.inc") $utilsPath

# Region A2: die beiden UTF-8-Helfer, die vor ISOTranslate stehen
$a2Start = Find-Line $u '^\s*BOOL\s+ISOIsUTF8Charset\s*\(' 0
$a2Line = Find-Line $u '^\s*LONG\s+ISOIncompleteUTF8Tail\s*\(' $a2Start
$a2End = Find-Line $u '^\}\s*$' $a2Line
Write-Region $u $a2Start $a2End (Join-Path $OutDir "utils_utf8tail.inc") $utilsPath

# Region B: die Funktion ISOTranslate
$bStart = Find-Line $u '^\s*LONG\s+ISOTranslate\s*\(' 0
$bEnd = Find-Line $u '^\}\s*$' $bStart
Write-Region $u $bStart $bEnd (Join-Path $OutDir "utils_isotranslate.inc") $utilsPath

# Region B2: ISOTranslateChunk - der Uebertrag ueber die Stueckgrenze (E-85).
# Steht in utils.cpp zwischen ISOIncompleteUTF8Tail und ISOTranslate, faellt
# also weder in Region A2 noch in Region B.
$b2Start = Find-Line $u '^\s*LONG\s+ISOTranslateChunk\s*\(' 0
$b2End = Find-Line $u '^\}\s*$' $b2Start
Write-Region $u $b2Start $b2End (Join-Path $OutDir "utils_chunk.inc") $utilsPath

# ---------------------------------------------------------------- hexbin.cpp
$hexPath = Join-Path $SrcDir "hexbin.cpp"
$h = Read-Lines $hexPath

# Region C: Sonderwerte + BinHex-Dekodiertabelle
$cStart = Find-Line $h '^\s*const BYTE\s+RUNCHAR\b' 0
$hexTab = Find-Line $h '^\s*static const BYTE\s+HexBinTable\b' $cStart
$cEnd = Find-Line $h '^\};\s*$' $hexTab
Write-Region $h $cStart $cEnd (Join-Path $OutDir "hexbin_table.inc") $hexPath

# ---------------------------------------------------------------- Decode.h
# Die Basisklasse Decoder. Base64Decoder leitet davon ab.
$decHPath = Join-Path $SrcDir "Decode.h"
$dh = Read-Lines $decHPath
$dStart = Find-Line $dh '^\s*class\s+Decoder\b' 0
$dEnd = Find-Line $dh '^\};\s*$' $dStart
Write-Region $dh $dStart $dEnd (Join-Path $OutDir "decode_klasse.inc") $decHPath

# ---------------------------------------------------------------- Base64.h
$b64HPath = Join-Path $SrcDir "Base64.h"
$bh = Read-Lines $b64HPath
$eStart = Find-Line $bh '^\s*class\s+Base64Decoder\b' 0
$eEnd = Find-Line $bh '^\};\s*$' $eStart
Write-Region $bh $eStart $eEnd (Join-Path $OutDir "base64_klasse.inc") $b64HPath

# ---------------------------------------------------------------- Base64.cpp
$b64Path = Join-Path $SrcDir "Base64.cpp"
$b = Read-Lines $b64Path

# Region D: Sonderwerte, die Dekodiertabelle g_Decode und die sechs Bitschieber.
# Die Schieber (Bot2 ... Top6) stehen hinter der Tabelle und werden von
# Base64Decoder::Decode gebraucht, deshalb reicht die Region bis zum letzten davon.
$dTabStart = Find-Line $b '^\s*const BYTE\s+SKIP\b' 0
$dTabLine = Find-Line $b '^\s*static const BYTE\s+g_Decode\b' $dTabStart
$dTabEnd = Find-Line $b '^\};\s*$' $dTabLine
$dTabEnd = Find-Line $b '^\s*/\*inline\*/\s*BYTE\s+Top6\b' $dTabEnd
Write-Region $b $dTabStart $dTabEnd (Join-Path $OutDir "base64_table.inc") $b64Path

# Region E: Base64Decoder::Init und Base64Decoder::Decode
$dFunStart = Find-Line $b '^int\s+Base64Decoder::Init\b' 0
$dFunLine = Find-Line $b '^int\s+Base64Decoder::Decode\b' $dFunStart
$dFunEnd = Find-Line $b '^\}\s*$' $dFunLine
Write-Region $b $dFunStart $dFunEnd (Join-Path $OutDir "base64_decoder.inc") $b64Path

# ---------------------------------------------------------------- mime.cpp
$mimePath = Join-Path $SrcDir "mime.cpp"
$m = Read-Lines $mimePath

# Region F: FindMIMECharset - bildet den Zeichensatznamen auf den Tabellenindex ab
$fStart = Find-Line $m '^int\s+FindMIMECharset\s*\(' 0
$fEnd = Find-Line $m '^\}\s*$' $fStart
Write-Region $m $fStart $fEnd (Join-Path $OutDir "mime_findcharset.inc") $mimePath

# Region G: HEX und HexToString - von PseudoQP gebraucht
$gStart = Find-Line $m '^inline char HEX\s*\(' 0
$gLine = Find-Line $m '^void HexToString\s*\(' $gStart
$gEnd = Find-Line $m '^\}\s*$' $gLine
Write-Region $m $gStart $gEnd (Join-Path $OutDir "mime_hextostring.inc") $mimePath

# ---------------------------------------------------------------- lex822.cpp
$lexPath = Join-Path $SrcDir "lex822.cpp"
$l = Read-Lines $lexPath

# Region H: PseudoQP, DecodeB64String, Translate2047 und Fix2047 am Stueck.
# Das ist der Kopfzeilenpfad: aus "=?utf-8?B?...?=" wird lesbarer Text.
$hStart = Find-Line $l '^void\s+PseudoQP\s*\(' 0
$hLine = Find-Line $l '^BOOL\s+Fix2047\s*\(' $hStart
$hEnd = Find-Line $l '^\}\s*$' $hLine
Write-Region $l $hStart $hEnd (Join-Path $OutDir "lex822_2047.inc") $lexPath

# ------------------------------------------------- EuImap/src/ImapLex822.cpp
# Region H2: dieselbe Kette in der IMAP-Abschrift (Befund E-94). ImapFix2047
# bekommt ueber IMAP die GANZE Kopfzeile mit allen Faltungen
# (ImapDownload.cpp:2276), POP dagegen zeilenweise - deshalb wird die
# IMAP-Fassung eigens geprueft und nicht stellvertretend durch Fix2047.
# Translate2047, PseudoQP und DecodeB64String sind dort static und heissen wie
# im POP-Weg; darum eine eigene Uebersetzungseinheit (UnderTestImap2047.cpp).
# Gesucht wird die DEFINITION (Zeile ohne Semikolon), nicht die Vorab-
# Deklaration am Dateianfang.
$imapLexPath = Join-Path (Split-Path -Parent $SrcDir) "EuImap\src\ImapLex822.cpp"
$il = Read-Lines $imapLexPath
$h2Start = Find-Line $il '^static BOOL Translate2047\s*\([^;]*$' 0
$h2Line  = Find-Line $il '^static int DecodeB64String\s*\([^;]*$' $h2Start
$h2End   = Find-Line $il '^\}\s*$' $h2Line
$null    = Find-Line $il '^BOOL ImapFix2047\s*\(' $h2Start   # muss im Bereich liegen
Write-Region $il $h2Start $h2End (Join-Path $OutDir "imaplex822_2047.inc") $imapLexPath


# ---------------------------------------------------------------- msgutils.cpp
# Region I: E88NurText und E88OriginalEinsetzen am Stueck (Befund E-88).
# Das ist die Entscheidung, ob die Original-Fassung oder die Editor-Fassung
# hinausgeht. Sie muss gepruefbar sein, ohne Eudora zu starten - eine falsche
# Entscheidung sieht vor dem Absenden niemand.
$msgPath = Join-Path $SrcDir "msgutils.cpp"
$mu = Read-Lines $msgPath
$iStart = Find-Line $mu '^static void E88NurText\s*\(' 0
$iLine = Find-Line $mu '^bool E88OriginalEinsetzen\s*\(' $iStart
$iEnd = Find-Line $mu '^\}\s*$' $iLine
Write-Region $mu $iStart $iEnd (Join-Path $OutDir "msgutils_e88.inc") $msgPath

# ---------------------------------------------------------------- utils.cpp (IsFancy)
# E88OriginalEinsetzen ruft IsFancy. Wieder geschnitten statt abgeschrieben.
$jStart = Find-Line $u '^int IsFancy\s*\(' 0
$jEnd = Find-Line $u '^\}\s*$' $jStart
Write-Region $u $jStart $jEnd (Join-Path $OutDir "utils_isfancy.inc") $utilsPath

# ---------------------------------------------------------------- msgutils.cpp (E-89)
# Region K: die vier Funktionen, die aus einem <img> ohne auswertbare Groesse
# eines mit Groesse machen (Befund E-89). Reine Textverarbeitung, HTML rein und
# HTML raus - genau die Sorte Code, die sich ohne Fenster und ohne Paige pruefen
# laesst. Die Region beginnt bei den Deckel-Konstanten, weil der geschnittene
# Code sie braucht.
$kStart = Find-Line $mu '^#define\s+E89_MAX_BREITE\b' 0
$kLine = Find-Line $mu '^bool E89BilderMessbarMachen\s*\(' $kStart
$kEnd = Find-Line $mu '^\}\s*$' $kLine
Write-Region $mu $kStart $kEnd (Join-Path $OutDir "msgutils_e89.inc") $msgPath


# ---------------------------------------------------------------- msgutils.cpp (E-101)
# Region L: E101SpeicherfassungAufbereiten (Befund E-101). Entscheidet, was in
# der Datei steht, die der Anwender aus der Hand gibt. Reine Textverarbeitung,
# Text rein und Text raus - ohne INI, ohne Ressourcen, ohne Fenster, also ohne
# Eudora pruefbar. Gregor am 17.09.2026: "datei gespeichert, aber unbrauchbar".
$lStart = Find-Line $mu '^bool E101SpeicherfassungAufbereiten\s*\(' 0
$lEnd = Find-Line $mu '^\}\s*$' $lStart
Write-Region $mu $lStart $lEnd (Join-Path $OutDir "msgutils_e101.inc") $msgPath


# ---------------------------------------------------------------- HTMLUtils.cpp (E-110)
# Region M: resolve_URL und translate_hex (Befund E-110). resolve_URL baut aus
# dem src-Attribut eines <img> die Adresse, unter der Eudora das Bild holt.
# Bis zum 18.09.2026 warf es jede Prozent-Sequenz weg, statt sie zu
# entschluesseln - "en%20aktuellen%20Verlust.png" wurde zu
# "enaktuellenVerlust.png", der Server antwortete mit 404, und der Anwender sah
# einen grauen Kasten. Zehn von zwanzig Bildern in Gregors Nachricht.
#
# Reine Zeichenkettenarbeit, Adresse rein und Adresse raus - ohne Paige, ohne
# Netz, ohne ein einziges Bild pruefbar. Genau deshalb faellt dieser Befund in
# die Zustaendigkeit des Pruefstands und nicht in Gregors Lauf.
#
# Die Region umfasst ALLE VIER Funktionen der Datei: resolve_URL ruft
# translate_hex, unescape_url ruft x2c. unescape_url loest DIESELBE Aufgabe wie
# resolve_URL - und loeste sie schon immer richtig. Sie ist damit die beste
# Gegenprobe, die es gibt: zwei Funktionen desselben Autors in derselben Datei,
# zwanzig Zeilen auseinander, und nur eine war kaputt.
$htmlPath = Join-Path $SrcDir "HTMLUtils.cpp"
$hu = Read-Lines $htmlPath
$mStart = Find-Line $hu '^void resolve_URL\s*\(' 0
$mX2c = Find-Line $hu '^char x2c\s*\(' $mStart
$mEnd = Find-Line $hu '^\}\s*$' $mX2c
Write-Region $hu $mStart $mEnd (Join-Path $OutDir "htmlutils_resolveurl.inc") $htmlPath


# ------------------------------------------------- PgEmbeddedImage.cpp (E-112)
# Region N: E112Zielrechteck - welches Rechteck bekommt ein Bild? Die Regel
# steht bewusst in einer eigenen Funktion, damit sie OHNE Paige, ohne Fenster
# und ohne ein einziges Bild pruefbar ist.
#
# Bei E-106 fehlte genau das: die Regel stand mitten im Ladeweg, war nur an
# Gregors Rechner messbar - und dass sie falsch herum war (Zeile vergroessern
# statt Bild verkleinern), kam erst heraus, als E-110 die Bilder ueberhaupt
# ankommen liess. Das WhatsApp-Symbol fuellte danach das halbe Fenster.
$embPath = Join-Path $SrcDir "PgEmbeddedImage.cpp"
$em = Read-Lines $embPath
$nStart = Find-Line $em '^void E112Zielrechteck\s*\(' 0
$nEnd = Find-Line $em '^\}\s*$' $nStart
Write-Region $em $nStart $nEnd (Join-Path $OutDir "pgembedded_e112.inc") $embPath

# Region O: E112MetadateiAusDIB - in welcher Groesse wird das Bild GEZEICHNET?
# Region N prueft nur die Regel. Die stimmte seit 7.2.0.76, und trotzdem lag
# bei Gregor an 1.0.76 und 1.0.84 das Logo ueber dem Text: Paige spielt die
# Metadatei als MM_TEXT ab, gemalt wird also, was IN ihr steht.
$qcgPath = Join-Path $SrcDir "QCGraphics.cpp"
$qg = Read-Lines $qcgPath
$nStart = Find-Line $qg '^HMETAFILE E112MetadateiAusDIB\s*\(' 0
$nEnd = Find-Line $qg '^\}\s*$' $nStart
Write-Region $qg $nStart $nEnd (Join-Path $OutDir "qcgraphics_e112.inc") $qcgPath

# ------------------------------------------------------- PGHTMIMP.CPP (E-105)
# Region P: E105Schritt - wird ein Tag samt Inhalt ausgeblendet, weil sein
# style display:none sagt? Newsletter verstecken so die Handyfassung; Eudora
# zeigte beide, jedes Bild doppelt. Die Region beginnt bei der ersten
# Hilfsfunktion und endet mit E105Schritt.
$imPath = Join-Path $SrcDir "PGHTMIMP.CPP"
$im = Read-Lines $imPath
$pStart = Find-Line $im '^static int E105GleichKlein\s*\(' 0
$pFn = Find-Line $im '^int E105Schritt\s*\(' $pStart
$pEnd = Find-Line $im '^\}\s*$' $pFn
Write-Region $im $pStart $pEnd (Join-Path $OutDir "pghtmimp_e105.inc") $imPath

# ------------------------------------------------- ImapAppend.cpp (E-118)
# Region Q: E118Huelle und E118Achtbit - erkennt Eudoras lokale HTML-Huelle
# <x-html>...</x-html> beim Hochladen in einen IMAP-Ordner. Ohne sie ging
# eine HTML-Mail als text/plain an den Server und erschien dort als Quelltext.
$iaPath = Join-Path $SrcDir "..\EuImap\src\ImapAppend.cpp"
$ia = Read-Lines $iaPath
$qStart = Find-Line $ia '^static int E118Gleich\s*\(' 0
$qFn = Find-Line $ia '^int E118Achtbit\s*\(' $qStart
$qEnd = Find-Line $ia '^\}\s*$' $qFn
Write-Region $ia $qStart $qEnd (Join-Path $OutDir "imapappend_e118.inc") $iaPath


# ----------------------------------------------------------- filtersd.cpp (E-69)
# Region O: CE69Sammlung - wer bekommt einen eigenen Eintrag in "Task Errors"
# und wer wird nur gezaehlt (Befund E-69, P3 aus PRUEFER-36). Reine
# Buchhaltung, ohne Task Errors, ohne Fenster, ohne CSummary - genau deshalb
# steht sie in einer eigenen Struktur und nicht im Meldeweg.
$filtPath = Join-Path $SrcDir "filtersd.cpp"
$fi = Read-Lines $filtPath
$oStart = Find-Line $fi '^struct CE69Sammlung' 0
$oEnd = Find-Line $fi '^\};\s*$' $oStart
Write-Region $fi $oStart $oEnd (Join-Path $OutDir "filtersd_e69.inc") $filtPath

# ------------------------------------------------------- TaskErrorView.cpp (E-69)
# Region P: E69LautErlaubt - darf dieser Fehler piepen und das Fenster nach
# vorn holen? Die Zeitregel gegen den Schwall (P3/B).
$tevPath = Join-Path $SrcDir "TaskErrorView.cpp"
$te = Read-Lines $tevPath
$pStart = Find-Line $te '^bool E69LautErlaubt' 0
$pEnd = Find-Line $te '^\}\s*$' $pStart
Write-Region $te $pStart $pEnd (Join-Path $OutDir "taskerror_e69.inc") $tevPath

# ------------------------------------------------------------ mainfrm.cpp (E-131)
# Region Q: E131PositionIstBrauchbar - liegt eine gemerkte Schwebeposition
# noch auf dem Bildschirm? Reine Rechnung, ohne Fenster und ohne INI, damit
# sie ohne Oberflaeche geprueft werden kann (Befund E-131, Issue #102).
$mfPath = Join-Path $SrcDir "mainfrm.cpp"
$mf = Read-Lines $mfPath
$qStart = Find-Line $mf '^bool E131PositionIstBrauchbar' 0
$qEnd = Find-Line $mf '^\}\s*$' $qStart
Write-Region $mf $qStart $qEnd (Join-Path $OutDir "mainfrm_e131.inc") $mfPath

# ------------------------------------------------------------- eudora.cpp (E-132)
# Region R: E132IstFremdesVerzeichnis - gehoert das gefundene Mailverzeichnis
# einer anderen Installation? Reine Pfadrechnung, ohne Registry und ohne
# Fenster, damit sie ohne Oberflaeche geprueft werden kann (Befund E-132,
# Issue #102).
$euPath = Join-Path $SrcDir "eudora.cpp"
$eu = Read-Lines $euPath
$rStart = Find-Line $eu '^bool E132IstFremdesVerzeichnis' 0
$rEnd = Find-Line $eu '^\}\s*$' $rStart
Write-Region $eu $rStart $rEnd (Join-Path $OutDir "eudora_e132.inc") $euPath


# Region R2: E132AufrufZerlegen - die Registry nennt eine ganze Befehlszeile,
# nicht nur ein Verzeichnis. Ohne diese Trennung blieb die Rueckfrage aus
# Region R stumm: die Pruefung auf eine vorhandene Eudora.ini lief gegen einen
# Pfad, der aus ZWEI Pfaden zusammengesetzt war (gemessen am 20.10.2026).
$r2Start = Find-Line $eu '^void E132AufrufZerlegen' 0
$r2End = Find-Line $eu '^\}\s*$' $r2Start
Write-Region $eu $r2Start $r2End (Join-Path $OutDir "eudora_e132_zerlegen.inc") $euPath

Write-Host "Extract.ps1: fertig."
