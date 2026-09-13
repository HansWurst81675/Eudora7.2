#!/usr/bin/perl
use strict;
use warnings;

# testmail-bauen.pl - erzeugt eine Testnachricht, die E-85 gezielt trifft.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 13.09.2026: "du kannst mir dann bestimmt eine test mail erstellen,
# die ich dann abschicke und ueber imap abrufe, ja?"
#
# Eine beliebige Mail mit Umlauten reicht dafuer NICHT. E-85 hatte drei
# Maengel, und nur der erste faellt bei jeder Nachricht auf:
#
#   (0) "charset=utf-8" wurde im IMAP-Weg gar nicht erkannt, weil
#       FindRStringIndexI bis IDS_MIME_ISO_LATIN9 (3613) suchte und
#       IDS_MIME_UTF_8 (3614) dahinter liegt. -> JEDER Umlaut zeigt das.
#
#   (1) Der Rueckgabewert von ISOTranslate wurde verworfen, also wurde die
#       Laenge VOR der Uebersetzung geschrieben. -> Sichtbar als Bytesalat am
#       Ende eines Lesestuecks, nicht bei jeder Nachricht.
#
#   (2) Der Uebertrag ueber die Stueckgrenze fehlte. Der IMAP-Weg liest
#       text/plain ZEILENWEISE, text/html aber in Bloecken von BUFLEN = 8192
#       Bytes. Nur wenn ein Mehrbytezeichen genau auf so einer Grenze liegt,
#       zeigt sich der Mangel. -> Braucht eine HTML-Nachricht, die deutlich
#       laenger als 8192 Bytes ist und dicht mit Mehrbytezeichen besetzt.
#
# Diese Nachricht ist so gebaut, dass (2) mit Sicherheit getroffen wird: der
# Rumpf ist ueber 24 KB lang, also fallen mindestens zwei Blockgrenzen hinein,
# und an jeder Position steht in kurzem Abstand ein Zeichen aus zwei, drei
# oder vier Bytes. Die Zeilen sind durchnummeriert, damit sich eine kaputte
# Stelle benennen laesst statt "irgendwo in der Mitte".
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/testmail-bauen.pl <Zielverzeichnis>
#
# Erzeugt dort:
#   E-85-test.eml    vollstaendige Nachricht mit Kopfzeilen (zum Importieren)
#   E-85-test.html   nur der Rumpf (zum Einfuegen in ein Webmail)
#   E-85-PRUEFEN.txt die Anleitung: was zu sehen sein muss und was nicht
#
# Rueckgabe: 0 = erzeugt, 2 = Aufrufproblem.

my $ziel = shift @ARGV;
unless (defined $ziel and -d $ziel) {
    print "  Aufruf: perl tools/testmail-bauen.pl <Zielverzeichnis>\n";
    print "  Das Verzeichnis muss es geben.\n";
    exit 2;
}
$ziel =~ s{\\}{/}g;
$ziel =~ s{/$}{};

# --- Die Zeichen, um die es geht -------------------------------------------
#
# Als Bytefolgen geschrieben, nicht als Literale: diese Datei bleibt damit in
# jeder Kodierung dieselbe, und es ist an jeder Stelle sichtbar, wie viele
# Bytes ein Zeichen belegt.
my $ae  = "\xC3\xA4";               # a-Umlaut          2 Bytes
my $oe  = "\xC3\xB6";               # o-Umlaut          2
my $ue  = "\xC3\xBC";               # u-Umlaut          2
my $AE  = "\xC3\x84";               # A-Umlaut          2
my $sz  = "\xC3\x9F";               # scharfes s        2
my $eur = "\xE2\x82\xAC";           # Eurozeichen       3
my $dsh = "\xE2\x80\x94";           # Gedankenstrich    3
my $emo = "\xF0\x9F\x98\x80";       # lachendes Gesicht 4

# --- Der Rumpf -------------------------------------------------------------
my @zeilen;
push @zeilen, '<html><head><meta charset="utf-8"></head><body>';
push @zeilen, '<h2>Testnachricht zu E-85 ' . $dsh . ' Umlaute ' . $ue . 'ber IMAP</h2>';
push @zeilen, '<p>Jede Zeile ist nummeriert. Wenn eine Zeile Zeichensalat zeigt,';
push @zeilen, 'nenne ihre Nummer ' . $dsh . ' dann ist die Stelle im Bytestrom bekannt.</p>';
push @zeilen, '<hr>';

# Genug Zeilen, damit der Rumpf sicher ueber mehrere 8192-Byte-Bloecke geht.
# Die Fuellbreite wandert absichtlich: so verschiebt sich die Lage der
# Mehrbytezeichen gegen die Blockgrenze von Zeile zu Zeile, und eine Grenze
# MUSS irgendwann mitten in ein Zeichen fallen.
my @muster = (
    "Gr${ue}${sz}e aus M${ue}nchen",
    "${AE}pfel, ${oe}l und ${ue}bung",
    "Preis: 12,50 ${eur} ${dsh} g${ue}nstig",
    "sch${oe}n, gr${ue}n, wei${sz}",
    "L${ae}nge, H${oe}he, Breite",
    "Stra${sz}e ${dsh} Caf${ae} ${dsh} Men${ue}",
    "Emoji als Vierbytezeichen: ${emo}",
    "${ue}${oe}${ae}${AE}${sz}${eur}${dsh} dicht an dicht",
);

# 900 Zeilen ergeben rund 50 KB, also sechs Blockgrenzen. Je mehr Grenzen,
# desto mehr Gelegenheiten, eine davon in ein Zeichen fallen zu lassen.
for my $i (1 .. 900) {
    my $m = $muster[$i % scalar @muster];
    my $fuell = 'x' x ($i % 37);     # wandernde Breite
    push @zeilen, sprintf('<p>%03d %s %s</p>', $i, $m, $fuell);
}

push @zeilen, '<hr>';
push @zeilen, '<p><b>Ende der Testnachricht.</b> Wenn bis hierher jede Zeile';
push @zeilen, 'lesbar war, sind alle drei M' . $ae . 'ngel aus E-85 behoben.</p>';
push @zeilen, '</body></html>';

# --- Die Blockgrenze GEZIELT in ein Zeichen legen --------------------------
#
# Eine Testnachricht, die zu kurz ist oder deren Grenzen zufaellig zwischen
# zwei Zeichen fallen, sieht aus wie ein Test und ist keiner. Der erste
# Entwurf hatte genau dieses Problem: 13946 Bytes, eine Grenze, null Treffer.
#
# Also wird nicht gehofft, sondern konstruiert. Ein zusaetzliches Fuellbyte
# ganz vorne verschiebt ALLES dahinter um eine Stelle; nach hoechstens vier
# Verschiebungen liegt eine Grenze zwangslaeufig auf einem Folgebyte, denn
# laenger als vier Bytes ist kein UTF-8-Zeichen.

sub zaehle_treffer {
    my ($text) = @_;
    my $n = 0;
    my $b = int(length($text) / 8192);
    for my $g (1 .. $b) {
        my $byte = ord(substr($text, $g * 8192, 1));
        $n++ if ($byte & 0xC0) == 0x80;
    }
    return ($n, $b);
}

my $rumpf;
my ($getroffen, $bloecke) = (0, 0);
my $schub = 0;

for my $versuch (0 .. 7) {
    my @dies = @zeilen;
    # Der Schub geht in eine unsichtbare Stelle: HTML-Kommentar im Kopf.
    $dies[0] = '<html><head><meta charset="utf-8">'
             . '<!--' . ('.' x $versuch) . '--></head><body>';
    $rumpf = join("\r\n", @dies) . "\r\n";
    ($getroffen, $bloecke) = zaehle_treffer($rumpf);
    if ($getroffen > 0) { $schub = $versuch; last; }
}

my $laenge = length $rumpf;

# Welche nummerierte Zeile traegt die kritische Grenze? Ohne diese Angabe
# muesste Gregor 900 Zeilen absuchen; mit ihr schaut er auf eine.
my @kritisch;
for my $g (1 .. $bloecke) {
    my $pos = $g * 8192;
    my $byte = ord(substr($rumpf, $pos, 1));
    next unless ($byte & 0xC0) == 0x80;

    # Die letzte Zeilennummer VOR dieser Stelle - so, wie sie im Text steht.
    my $davor = substr($rumpf, 0, $pos);
    my @treffer = $davor =~ /<p>(\d{3}) /g;
    push @kritisch, {
        block  => $g,
        byte   => $pos,
        zeile  => (@treffer ? $treffer[-1] : '(vor der ersten Zeile)'),
    };
}
my $kritischtext = @kritisch
    ? join("\n", map {
          sprintf('    Zeile %s  (Blockgrenze bei Byte %d)', $_->{zeile}, $_->{byte})
      } @kritisch)
    : '    (keine - diese Nachricht prueft den dritten Mangel NICHT)';

# --- Schreiben -------------------------------------------------------------
sub schreib {
    my ($d, $inhalt) = @_;
    open my $o, '>:raw', $d or die "$d: $!\n";
    print $o $inhalt;
    close $o;
}

my @z = localtime;
my @tage = qw(Sun Mon Tue Wed Thu Fri Sat);
my @mon  = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my $datum = sprintf('%s, %02d %s %04d %02d:%02d:%02d +0200',
                    $tage[$z[6]], $z[3], $mon[$z[4]], $z[5] + 1900,
                    $z[2], $z[1], $z[0]);

my $eml = join("\r\n",
    'From: Eudora-Test <test@example.invalid>',
    'To: Eudora-Test <test@example.invalid>',
    # Der Betreff sagt, worum es geht - Gregor am 13.09.2026: "schreib es im
    # subject, worum es geht". Bewusst reines ASCII: ein Umlaut im Betreff
    # nimmt einen ANDEREN Weg durch den Code (Fix2047 / Translate2047 in
    # lex822.cpp) als der Rumpf. Stuende er hier, liesse sich bei einem
    # Fehlschlag nicht mehr sagen, welcher der beiden Wege ihn verursacht hat.
    # Gefaltet nach RFC 5322: Fortsetzungszeilen beginnen mit einem
    # Leerzeichen, keine Zeile ueber 78 Zeichen. Ungefaltet waere der Betreff
    # 155 Zeichen lang - und ein Server, der ihn selbst umbricht, koennte
    # dabei etwas anrichten, das hinterher wie E-85 aussieht, aber keins ist.
    # Die Testnachricht darf nicht selbst zur Fehlerquelle werden.
    'Subject: Testmail fuer die drei Faelle aus E-85:',
    ' (0) charset=utf-8 wird ueberhaupt erkannt,',
    ' (1) Laenge nach der Uebersetzung wird uebernommen,',
    ' (2) Umlaut auf der 8192-Byte-Blockgrenze bleibt heil',
    "Date: $datum",
    'MIME-Version: 1.0',
    'Content-Type: text/html; charset=utf-8',
    'Content-Transfer-Encoding: 8bit',
    '',
) . $rumpf;

schreib("$ziel/E-85-test.eml", $eml);
schreib("$ziel/E-85-test.html", $rumpf);

my $anleitung = <<"ENDE";
E-85 pruefen: Umlaute in per IMAP abgerufenen Nachrichten
=========================================================

Gemessen beim Erzeugen dieser Nachricht:

    Rumpflaenge          $laenge Bytes
    8192-Byte-Bloecke    $bloecke
    davon Grenzen, die mitten in einem Zeichen liegen: $getroffen

DIE KRITISCHEN ZEILEN - hier schaut man zuerst hin:

$kritischtext

An genau diesen Stellen faellt eine 8192-Byte-Blockgrenze mitten in ein
Zeichen. Ist dort etwas kaputt und sonst nichts, ist Mangel (2) zurueck.

Die letzte Zahl ist der Grund, warum diese Nachricht so lang ist. Der
IMAP-Weg liest text/html in Bloecken von 8192 Bytes. Faellt keine Grenze in
ein Mehrbytezeichen, wird der dritte der drei Maengel aus E-85 gar nicht
beruehrt - dann sieht der Test gut aus und hat nichts geprueft.

ZUERST, SONST IST DER TEST WERTLOS
----------------------------------

    EINE SCHON ABGERUFENE NACHRICHT BLEIBT KAPUTT.

Die Uebersetzung passiert beim ABRUF, nicht beim Anzeigen:
CImapDownloader::Write uebersetzt und schreibt das Ergebnis mit
m_mbxFile.Put() in die lokale Mailboxdatei. Was dort einmal falsch steht,
steht falsch - die Anzeige liest nur noch, was schon da liegt.

Eudora holt den Rumpf auch nicht von selbst noch einmal: das Flag
IsIMAPMessageBodyDownloaded() entscheidet an sechs Stellen, ob geladen wird.
Ist der Rumpf da, bleibt er.

Also: NEUE Nachricht schicken und abrufen. Eine vorhandene zu oeffnen zeigt
den alten Schaden und sagt ueber den Patch gar nichts.

SO WIRD GETESTET
----------------

1. E-85-test.html oeffnen, den Inhalt in eine Mail an dich selbst einfuegen
   (HTML-Modus, nicht als Anhang) und ueber IRGENDEINEN Weg abschicken -
   Webmail des Anbieters ist am einfachsten, denn dann ist der Sendeweg
   sicher nicht Teil des Tests.

   Alternativ: E-85-test.eml ist eine vollstaendige Nachricht mit
   Kopfzeilen; wer sie direkt in ein IMAP-Postfach legen kann, spart den
   Umweg.

2. In Eudora 7.2.0.51 ueber IMAP abrufen und die Nachricht oeffnen.

WAS ZU SEHEN SEIN MUSS
----------------------

    240 nummerierte Zeilen, JEDE lesbar:

        001 Graussee aus Muenchen ...     (mit echten Umlauten)
        003 Preis: 12,50 EUR - guenstig   (mit echtem Eurozeichen)
        007 Emoji als Vierbytezeichen: ?  (Fragezeichen ist RICHTIG -
                                           CP1252 kennt kein Emoji)

WAS EIN FEHLSCHLAG WAERE
------------------------

    * Zeichensalat statt Umlauten, z.B. zwei Zeichen statt einem
      -> Mangel (0) ist zurueck: charset=utf-8 wird nicht erkannt

    * EINZELNE Zeilen kaputt, die meisten richtig
      -> Mangel (2) ist zurueck: der Uebertrag ueber die Blockgrenze fehlt.
         BITTE DIE ZEILENNUMMER NENNEN - daraus laesst sich die Stelle im
         Bytestrom ausrechnen.

    * Reste oder doppelte Zeichen am Zeilenende
      -> Mangel (1) ist zurueck: die Laenge nach der Uebersetzung wird nicht
         uebernommen

    * Die Nachricht bricht mittendrin ab
      -> etwas anderes; bitte die letzte lesbare Zeilennummer nennen

GEGENPROBE
----------

Dieselbe Nachricht ueber POP3 abrufen, falls ein POP3-Konto da ist: dort war
E-85 nie, also muss sie schon vorher richtig ausgesehen haben. Sieht sie
ueber POP3 auch falsch aus, liegt es NICHT an E-85.
ENDE

schreib("$ziel/E-85-PRUEFEN.txt", $anleitung);

printf "  erzeugt in %s:\n", $ziel;
printf "    E-85-test.eml     %6d Bytes\n", length $eml;
printf "    E-85-test.html    %6d Bytes\n", length $rumpf;
printf "    E-85-PRUEFEN.txt  %6d Bytes\n", length $anleitung;
printf "\n  Rumpf %d Bytes = %d Block(e) zu 8192.\n", $laenge, $bloecke;
printf "  Blockgrenzen mitten in einem Zeichen: %d\n", $getroffen;

if ($getroffen < 1) {
    print "\n  ACHTUNG: keine einzige Grenze faellt in ein Zeichen. Diese\n";
    print "  Nachricht prueft den dritten Mangel NICHT. Fuellbreiten aendern.\n";
    exit 1;
}
print "\n  Der dritte Mangel wird getroffen.\n";
exit 0;
