#!/usr/bin/perl
#
# pruefe-testdaten-anonym.pl - Schranke fuer das Verzeichnis Testdaten/
#
# Weist ab, wenn unter Testdaten/ noch etwas Persoenliches steht:
#   * eine E-Mail-Adresse, deren Wirtsteil nicht auf .invalid endet
#   * ein Muster aus der Ausschlussliste weiter unten (Namen, Rufnummern,
#     Anschriften, Kunden- und Vorgangsnummern, IP-Adressen ausserhalb der
#     Dokumentationsbereiche nach RFC 5737)
#
# Aufruf:
#   perl tools/pruefe-testdaten-anonym.pl            # prueft Testdaten/
#   perl tools/pruefe-testdaten-anonym.pl --tests    # Selbsttest der Schranke
#
# Warum der Pruefumfang mit ausgegeben wird: in diesem Projekt haben
# Schranken schon zweimal gruen gemeldet, weil sie nichts zu pruefen fanden
# (E-109). Ein Freispruch ueber die leere Menge sieht sonst aus wie ein
# Freispruch nach Pruefung. Diese Schranke meldet bei 0 geprueften Dateien
# ROT, nicht gruen.
#
# Byte-Erhaltung: die Schranke liest nur, sie schreibt nie.

use strict;
use warnings;

my $VERZ = 'Testdaten';

# ---------------------------------------------------------------------------
# Ausschlussliste. Jeder Eintrag: [Regex, Klartextname, optionale Nachpruefung]
# Die Nachpruefung bekommt den Fund und liefert 1, wenn er zaehlt. Sie ist
# dafuer da, dass ein eingesetzter Platzhalter nicht als der Wert gemeldet
# wird, den er ersetzt hat - sonst faengt die Schranke ihre eigene Arbeit.
# Die Regeln laufen ohne /i nur dort, wo Grossschreibung bedeutsam ist.
# ---------------------------------------------------------------------------

# Eine Ziffernfolge, die nur aus einer einzigen Ziffer besteht, ist ein
# Platzhalter (0000-0000-...), keine Rufnummer.
sub keine_einheitsziffer {
    my ($fund) = @_;
    (my $ziffern = $fund) =~ s/\D//g;
    return 0 if $ziffern =~ /^(\d)\1*$/;
    return 1;
}
my @MUSTER = (
    # --- Namen, die in diesem Projekt vorkommen --------------------------
    [ qr/gregor/i,                      'Vorname des Anwenders'                 ],
    [ qr/czempik/i,                     'Nachname des Anwenders'                ],
    [ qr/markus/i,                      'Vorname aus den Originalnachrichten'   ],
    [ qr/bakus/i,                       'Nachname aus den Originalnachrichten'  ],
    [ qr/noname007/i,                   'Kontoname des Anwenders'               ],
    [ qr/heimann/i,                     'Personenname aus einem Impressum'      ],
    [ qr/doctolib/i,                    'Name des Terminportals'                ],
    [ qr/dernburgstrasse/i,             'Strassenname aus einem Impressum'      ],
    [ qr/albert-einstein-ring/i,        'Strassenname aus einem Impressum'      ],

    # --- Postfachanbieter der Originalnachrichten -------------------------
    [ qr/\bweb\.de\b/i,                 'Wirtsname des Absenderpostfachs'       ],
    [ qr/\bgmx\.(?:de|net)\b/i,         'Wirtsname des Empfaengerpostfachs'     ],

    # --- Anschriften ------------------------------------------------------
    # Fuenfstellige Postleitzahl vor einem grossgeschriebenen Ortsnamen.
    # "12345 Musterstadt" ist ausdruecklich erlaubt.
    [ qr/\b(?!12345\b)\d{5}\s+(?!Musterstadt)[A-Z\xC0-\xDE][a-z\xDF-\xFF]{3,}/,
                                        'Postleitzahl mit Ortsnamen'            ],

    # --- Rufnummern -------------------------------------------------------
    [ qr/(?:\+49|\b0)[\s\/().-]?\d{2,5}[\s\/().-]?\d{3,}[\s\/().-]?\d{2,}/,
                                        'Rufnummer', \&keine_einheitsziffer     ],

    # --- IP-Adressen ausserhalb der Dokumentationsbereiche ----------------
    # Erlaubt sind nur 192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24
    # (RFC 5737) sowie 0.x und 127.x.
    [ qr/\b(?!192\.0\.2\.)(?!198\.51\.100\.)(?!203\.0\.113\.)(?!127\.)(?!0\.)
         (?:\d{1,3}\.){3}\d{1,3}\b/x,   'IP-Adresse ausserhalb RFC 5737'        ],

    # --- Vorgangs- und Kundennummern --------------------------------------
    [ qr/HRB-Nr\.:\s*(?!0+\s*B)\d/i,    'Handelsregisternummer'                 ],
    [ qr/\bbu=(?!10000000000\b)\d{6,}/, 'Kontonummer in einer Verfolgungsadresse'],
    [ qr/\bupn=u\d{3}\./,               'Empfaengertoken in einem Zaehlpixel'   ],
);

# E-Mail-Adresse. Bewusst weit gefasst, damit nichts durchrutscht.
my $ADRESSE = qr/[A-Za-z0-9._%+\-]+\@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}/;

# ---------------------------------------------------------------------------
sub pruefe_inhalt {
    my ($name, $daten) = @_;
    my @fehler;

    # 1) Adressen: der Wirtsteil muss auf .invalid enden.
    my %gesehen;
    while ($daten =~ /($ADRESSE)/g) {
        my $adr = $1;
        next if $gesehen{$adr}++;
        next if $adr =~ /\.invalid$/i;
        push @fehler, "$name: Adresse ohne .invalid: $adr";
    }

    # 2) Ausschlussliste.
    for my $m (@MUSTER) {
        my ($regex, $was, $nachpruefung) = @$m;
        while ($daten =~ /$regex/g) {
            my $fund = $&;
            next if $nachpruefung && !$nachpruefung->($fund);
            $fund =~ s/[\r\n]/ /g;
            push @fehler, "$name: $was: '$fund'";
            last;                       # ein Fund je Muster genuegt
        }
    }
    return @fehler;
}

sub lies_roh {
    my ($pfad) = @_;
    open(my $fh, '<:raw', $pfad) or die "$pfad: $!\n";
    local $/;
    my $d = <$fh>;
    close($fh);
    return defined($d) ? $d : '';
}

# ---------------------------------------------------------------------------
# Selbsttest: gegen den echten Fehler UND gegen den erlaubten Fall.
# ---------------------------------------------------------------------------
sub tests {
    my @faelle = (
        # [ Name, Inhalt, erwartet_abgewiesen, Begruendung ]
        [ 'echte Adresse',
          "From: gregor.czempik\@web.de\r\n", 1,
          'eine echte Adresse muss abgewiesen werden' ],
        [ 'Platzhalteradresse',
          "From: absender\@beispiel.invalid\r\n", 0,
          'absender@beispiel.invalid muss durchgehen' ],
        [ 'zweite Platzhalteradresse',
          "To: empfaenger\@beispiel.invalid\r\nCc: noreply\@kleinanzeigen.invalid\r\n", 0,
          'mehrere .invalid-Adressen muessen durchgehen' ],
        [ 'Adresse mit fremdem Wirt',
          "Reply-To: service\@example.com\r\n", 1,
          'jede Adresse ohne .invalid muss abgewiesen werden' ],
        [ 'Adresse im Rumpf',
          "<a href=\"mailto:kunde\@firma.de\">schreiben</a>", 1,
          'auch im Rumpf, nicht nur in Kopfzeilen' ],
        [ 'Adresse in einer Empfangszeile',
          "Received: from a by b for <markus.bakus\@gmx.de>;\r\n", 1,
          'auch in Received-Zeilen' ],
        [ 'Personenname ohne Adresse',
          "Geschaeftsfuehrer: Paul Heimann\r\n", 1,
          'ein Name allein reicht zur Abweisung' ],
        [ 'Anschrift',
          "Musterfirma GmbH, Irgendweg 3, 14057 Berlin\r\n", 1,
          'Postleitzahl mit Ortsnamen wird abgewiesen' ],
        [ 'erlaubte Musteranschrift',
          "Beispiel GmbH, Musterweg 1, 12345 Musterstadt\r\n", 0,
          '12345 Musterstadt ist der erlaubte Platzhalter' ],
        [ 'Rufnummer',
          "Telefon: 030 123456 78\r\n", 1,
          'Rufnummern werden abgewiesen' ],
        [ 'echte IP-Adresse',
          "Received: from [91.59.234.223]\r\n", 1,
          'eine IP ausserhalb RFC 5737 wird abgewiesen' ],
        [ 'erlaubte IP-Adresse',
          "Received: from [203.0.113.223] by [192.0.2.12]\r\n", 0,
          'RFC-5737-Adressen muessen durchgehen' ],
        [ 'Zaehlpixel mit Token',
          "<img src=\"https://x.invalid/wf/open?upn=u001.IH14UgVtC\">", 1,
          'Empfaengertoken im Zaehlpixel wird abgewiesen' ],
        [ 'Kontonummer in der Adresse',
          "<a href=\"https://x.invalid/s?bu=45288717465\">shop</a>", 1,
          'Kontonummer wird abgewiesen' ],
        [ 'anonymisierte Kontonummer',
          "<a href=\"https://x.invalid/s?bu=10000000000\">shop</a>", 0,
          'der Platzhalter muss durchgehen' ],
        [ 'Platzhalterkennung aus Nullen',
          "trkId=00000000-0000-4000-8000-000000000000", 0,
          'die eingesetzte Nullkennung ist keine Rufnummer' ],
        [ 'Rufnummer mit Bindestrich',
          "Tel. 030-123456-78", 1,
          'eine Rufnummer mit Bindestrich wird trotzdem abgewiesen' ],
        [ 'harmloser Rumpf mit Umlauten und Hochbytes',
          "<x-html>\r\n<html><body>Gr\xFC\xDFe, viele Gef\xE4\xDFe</body></html>\r\n", 0,
          'Latin-1-Hochbytes duerfen nicht stoeren' ],
        [ 'Aufrufstapel',
          "  0  0x001FE3FF  Eudora.exe  CSaveAsDialog::OnTypeChange + 45  SaveAsDialog.cpp:425\n", 0,
          'ein Aufrufstapel enthaelt nichts Persoenliches' ],
    );

    my ($gut, $schlecht) = (0, 0);
    for my $f (@faelle) {
        my ($name, $inhalt, $soll, $warum) = @$f;
        my @fehler = pruefe_inhalt('<test>', $inhalt);
        my $ist = @fehler ? 1 : 0;
        if ($ist == $soll) {
            $gut++;
            printf "  [ok  ] %-34s %s\n", $name, $warum;
        } else {
            $schlecht++;
            printf "  [FEHL] %-34s %s\n", $name, $warum;
            printf "         erwartet %s, bekommen %s\n",
                   $soll ? 'abgewiesen' : 'durchgelassen',
                   $ist  ? 'abgewiesen' : 'durchgelassen';
            printf "         %s\n", $_ for @fehler;
        }
    }
    print "\n";
    printf "Selbsttest: %d Faelle, %d bestanden, %d gescheitert\n",
           scalar(@faelle), $gut, $schlecht;
    return $schlecht ? 1 : 0;
}

# ---------------------------------------------------------------------------
# Hauptlauf
# ---------------------------------------------------------------------------
if (grep { $_ eq '--tests' } @ARGV) {
    print "pruefe-testdaten-anonym.pl - Selbsttest\n";
    print "  Gegentest in beide Richtungen: gegen den echten Fehler und\n";
    print "  gegen den erlaubten Fall (Arbeitsweise/schranke-gegentesten.md)\n\n";
    exit(tests());
}

unless (-d $VERZ) {
    print "pruefe-testdaten-anonym.pl: ROT\n";
    print "  Verzeichnis '$VERZ' gibt es nicht. Vom Wurzelverzeichnis des\n";
    print "  Repos aufrufen: perl tools/pruefe-testdaten-anonym.pl\n";
    exit 2;
}

my @dateien;
opendir(my $dh, $VERZ) or die "$VERZ: $!\n";
for my $e (sort readdir($dh)) {
    next if $e =~ /^\./;
    my $p = "$VERZ/$e";
    next unless -f $p;
    next if $e =~ /\.md$/;          # die Beschreibung nennt die Muster selbst
    push @dateien, $p;
}
closedir($dh);

print "pruefe-testdaten-anonym.pl\n";
print "Pruefumfang: " . scalar(@dateien) . " Datei(en) unter $VERZ/\n";

if (!@dateien) {
    print "\nROT: 0 Dateien geprueft.\n";
    print "  Das ist KEIN Freispruch, sondern ein fehlender Pruefgegenstand.\n";
    print "  Entweder ist $VERZ/ leer, oder die Schranke sieht am falschen Ort\n";
    print "  nach. Beides muss ein Mensch entscheiden (Befund E-109).\n";
    exit 2;
}

my @fehler;
my $bytes = 0;
for my $p (@dateien) {
    my $d = lies_roh($p);
    $bytes += length($d);
    my @f = pruefe_inhalt($p, $d);
    printf "  %-52s %8d Byte  %s\n", $p, length($d),
           @f ? scalar(@f) . ' Beanstandung(en)' : 'sauber';
    push @fehler, @f;
}
printf "Gelesen: %d Byte in %d Datei(en)\n\n", $bytes, scalar(@dateien);

if (@fehler) {
    print "ROT: " . scalar(@fehler) . " Beanstandung(en)\n";
    print "  $_\n" for @fehler;
    print "\n  Nichts davon gehoert nach GitHub. Anonymisieren und erneut\n";
    print "  laufen lassen. Zur Erinnerung: die Dateien duerfen nur mit Perl\n";
    print "  im :raw-Modus angefasst werden, sonst sind die Zeilenenden hin\n";
    print "  und der Testfall ist zerstoert.\n";
    exit 1;
}

print "GRUEN: " . scalar(@dateien) . " Datei(en) geprueft, nichts beanstandet.\n";
print "  Geprueft wurde: jede E-Mail-Adresse endet auf .invalid; keines der\n";
print "  " . scalar(@MUSTER) . " Ausschlussmuster kommt vor.\n";
print "  Was die Schranke NICHT prueft: ob ein Text sinngemaess auf eine\n";
print "  Person zurueckfuehrt. Das bleibt Handarbeit.\n";
exit 0;
