#!/usr/bin/perl
# e86-fassung-bauen.pl - Befund E-86: aus einer echten Nachricht die beiden
# Fassungen bauen, die verglichen werden muessen.
#
#   mail-allein.htm    der HTML-Teil so, wie ein Webbrowser ihn bekommt
#   eudora-fassung.htm derselbe Teil in dem Rahmen, den
#                      CTridentView::WriteTempFile darum schreibt
#
# Nachgebildet werden genau die Schritte des laufenden Programms:
#   * AddBodyPart (msgutils.cpp 2365-2395) nimmt den Bereich zwischen
#     <x-html> und </x-html> und gibt ihn als IS_HTML weiter - die Marken
#     selbst kommen nicht in den Rumpf.
#   * AddToBody (msgutils.cpp 1364-1855) entfernt bei RunHtmlCode=0
#     (Vorgabewert, EudoraRes.rc:8637) <script>, <applet>, <object>,
#     <embed> und <marquee> samt Inhalt. <html>, <head>, <style> und
#     <body> bleiben stehen, weil bStripDocumentLevelTags nur bei
#     MEHREREN Nachrichten gesetzt wird (TridentView.cpp:1409).
#   * WriteTempFile schreibt Zeichensatzzeile, Stylesheet, Kopfzeile,
#     <div>, Rumpf, </div>; LoadMessage haengt </body></html> an.
#
# Bild-Adressen nach aussen werden in BEIDEN Fassungen gleich durch eine
# oertliche Datei ersetzt: die Messung soll keine Zaehlpixel abrufen.
#
# Aufruf: perl tools/e86-fassung-bauen.pl <mbx-datei> <ablage> [nummer]

use strict;
use warnings;

my ($mbx, $ablage, $nummer, $bildart) = @ARGV;
die "Aufruf: perl $0 <mbx-datei> <ablage> [nummer] [oertlich|platzhalter]\n" unless $mbx && $ablage;
$nummer = 1 unless defined $nummer;
$bildart = 'oertlich' unless defined $bildart;
# oertlich    - Bilder zeigen auf eine kleine Datei daneben (Bild ist da)
# platzhalter - Bilder zeigen ins Leere: so sieht es aus, wenn die Anzeige
#               fremde Inhalte nicht holt. Es wird nichts abgerufen, die
#               Adresse endet auf .invalid und kann gar nicht aufgeloest werden.
my $bildziel = ($bildart eq 'platzhalter') ? 'https://nicht.vorhanden.invalid/bild.png' : 'logo.png';

mkdir $ablage unless -d $ablage;

open(my $fh, '<:raw', $mbx) or die "$mbx: $!\n";
my $alles = do { local $/; <$fh> };
close $fh;

# Nachrichten trennen: Eudora setzt "From ???@???" an den Anfang jeder
my @teile = split /(?m)^From \?\?\?\@\?\?\?/, $alles;
shift @teile if @teile && $teile[0] !~ /\S/;
die "keine Nachricht gefunden\n" unless @teile >= $nummer;
my $mail = $teile[$nummer - 1];

# den HTML-Teil herausnehmen - wie AddBodyPart
my ($rumpf) = $mail =~ /<x-html>(.*?)<\/x-html>/is;
die "kein <x-html>-Bereich in Nachricht $nummer\n" unless defined $rumpf;

# Betreff nur zur Kennzeichnung
my ($betreff) = $mail =~ /(?m)^Subject:[ \t]*(.*)$/;
$betreff = '(ohne Betreff)' unless defined $betreff;

# Zaehlung vor dem Entfernen
my $vorher = length $rumpf;

# AddToBody bei RunHtmlCode=0: gefaehrliche Bereiche entfernen
my $entfernt = 0;
for my $tag (qw(script applet object embed marquee)) {
    $entfernt += ($rumpf =~ s/<$tag\b.*?<\/$tag\s*>//gis);
}

# Bilder nach aussen durch eine oertliche Datei ersetzen - in beiden
# Fassungen gleich, damit die Messung nichts abruft
my $bilder = ($rumpf =~ s/(<img\b[^>]*?\bsrc\s*=\s*)(["'])[^"']*\2/$1$2$bildziel$2/gis);
$rumpf =~ s/(background\s*=\s*)(["'])https?:[^"']*\2/$1$2$bildziel$2/gis;
# Hintergrundbilder und Schriftarten aus dem CSS: nur die Adresse stumpf setzen
$rumpf =~ s/url\(\s*['"]?https?:[^)]*\)/url($bildziel)/gis;

# --- Fassung 1: die Mail allein -----------------------------------------
open(my $a, '>:raw', "$ablage/mail-allein.htm") or die $!;
print $a $rumpf;
close $a;

# --- Fassung 2: Eudoras Rahmen ------------------------------------------
# wortgleich zu TridentView.cpp (szCharsetMeta, IDS_INI_READMESSAGE_STYLE_SHEET
# nach CString::Format mit Arial/Courier New/solid blue, WriteHeaders,
# szDivStart "<div>\r\n", szDivEnd "\r\n</div>", LoadMessage "</body></html>")
my $meta = qq{<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">\r\n};
my $stil = <<'ENDE';
<HTML><HEAD><STYLE>
BODY {font-family="Arial"}
TT {font-family="Courier New"}
BLOCKQUOTE.CITE {padding-left:0.5em; margin-left:0; margin-right:0; margin-top:0; margin-bottom:0; border-left:"solid blue";}
SPAN.EUDORAHEADER {color:black; background-color:white; color:windowtext; background-color:window;}
</STYLE></HEAD>
<BODY>
ENDE
my $kopf = qq{<SPAN CLASS=EUDORAHEADER>Subject: $betreff</SPAN><BR>\r\n};

open(my $b, '>:raw', "$ablage/eudora-fassung.htm") or die $!;
print $b $meta, $stil, $kopf, "<div>\r\n", $rumpf, "\r\n</div>", "</body></html>";
close $b;

printf "Nachricht %d: %s\n", $nummer, $betreff;
printf "Rumpf %d Bytes, nach dem Entfernen %d Bytes (%d Bereiche), %d Bild-Adressen ersetzt\n",
    $vorher, length($rumpf), $entfernt, $bilder;
printf "geschrieben: %s/mail-allein.htm und %s/eudora-fassung.htm\n", $ablage, $ablage;
