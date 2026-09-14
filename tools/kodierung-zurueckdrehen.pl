#!/usr/bin/perl
use strict;
use warnings;
use Encode qw(decode encode);

# kodierung-zurueckdrehen.pl - doppelt kodierte Zeilen zurueckdrehen, Zeile fuer
# Zeile, und nur dort, wo die Umkehr nachweislich sicher ist.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 14.09.2026 hat der CHRONIST beim Nachmessen von E-83 gefunden, dass
# BEFUNDE.md - die zentrale Wissensdatei dieses Projekts - zu 19 Prozent
# doppelt kodiert ist: 1517 von 7829 Zeilen. Aus dem Wort "laesst" wurde die
# Bytefolge 6c c3 83 c2 a4 73 73 74 - wo c3 a4 stehen muesste, stand c3 83 c2 a4:
# das "ae" einmal zuviel durch UTF-8 gedreht. Angezeigt wird das als ein A mit
# Tilde, gefolgt von einem unsichtbaren Steuerzeichen.
#
# Eingebracht wurde der Schaden in zwei Schritten, beide gemessen:
#
#     Merge  569b074 (origin/wt/pruefer)                    3 -> 1098 Zeilen
#     Commit 4904761 ("E-87: die Formatierung geht ...")  1098 -> 1544 Zeilen
#
# WARUM DIE SCHRANKE NICHT GEFEUERT HAT: tools/pruefe-bytes.pl prueft genau
# diesen Schaden und ist seit dem 05.09.2026 im pre-commit. Sie vergleicht aber
# den INDEX-Blob gegen den HEAD-Blob - also den DIFF. Ist der Schaden einmal
# committet, sieht sie ihn nie wieder. Das ist woertlich die Lehre
# Arbeitsweise/review-sieht-nur-den-diff.md, angewendet auf Bytes.
#
# ---------------------------------------------------------------------------
# WARUM ZEILENWEISE UND NICHT AUF DIE GANZE DATEI
# ---------------------------------------------------------------------------
#
# Die naheliegende Umkehr - die ganze Datei als UTF-8 lesen und als Latin-1
# schreiben - macht aus jedem KORREKT kodierten Umlaut ein kaputtes Byte. In
# einer Datei, in der 19 Prozent der Zeilen beschaedigt und 81 Prozent in
# Ordnung sind, waere das ein groesserer Schaden als der, den es behebt.
#
# Deshalb wird jede Zeile einzeln behandelt, und die Umkehr gilt nur dann als
# sicher, wenn BEIDE Proben bestehen:
#
#   1. decode('UTF-8') gelingt ohne Ersatzzeichen, und
#   2. das Ergebnis, wieder als Latin-1 geschrieben, ist selbst gueltiges UTF-8.
#
# Probe 2 ist die eigentliche Sicherung. Eine gemischte Zeile - ein korrektes
# "ae" neben einem doppelt kodierten - faellt genau daran durch: aus dem
# korrekten c3 a4 wuerde das nackte Byte e4, und das ist fuer sich kein
# gueltiges UTF-8 mehr. Solche Zeilen bleiben unangetastet und werden GEMELDET,
# statt still uebergangen zu werden.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/kodierung-zurueckdrehen.pl BEFUNDE.md            # nur messen
#   perl tools/kodierung-zurueckdrehen.pl -schreiben BEFUNDE.md # und aendern
#
# Ohne -schreiben wird nichts angefasst; das ist die Vorgabe. Zeilenenden
# bleiben unberuehrt, weil die Datei roh gelesen und roh geschrieben wird.
#
# Rueckgabe: 0 = nichts zu tun oder alles zurueckgedreht,
#            1 = es bleiben Zeilen uebrig, die von Hand angesehen werden muessen,
#            2 = Aufrufproblem.

my $schreiben = 0;
my @dateien;
for my $arg (@ARGV) {
    if    ($arg eq '-schreiben') { $schreiben = 1; }
    elsif ($arg =~ /^-/)         { print "  unbekannter Schalter: $arg\n"; exit 2; }
    else                         { push @dateien, $arg; }
}

unless (@dateien) {
    print <<'ENDE';
  Aufruf: perl tools/kodierung-zurueckdrehen.pl [-schreiben] <Datei> [<Datei> ...]

  Dreht doppelt kodierte Zeilen zurueck - aber nur, wo die Umkehr
  nachweislich sicher ist. Ohne -schreiben wird nur gemessen.

  Beispiel:
      perl tools/kodierung-zurueckdrehen.pl BEFUNDE.md
      perl tools/kodierung-zurueckdrehen.pl -schreiben BEFUNDE.md
ENDE
    exit 2;
}

# Das Muster fuer doppelt kodiert: "Ã" gefolgt von einem C1-Rest, bzw. die
# doppelte Fassung eines Drei-Byte-Zeichens (Gedankenstrich, Anfuehrungszeichen).
my $doppelt = qr/\xc3\x83\xc2[\x80-\xbf]|\xc3\x82\xc2[\x80-\xbf]|\xc3\xa2\xc2[\x80-\xbf]\xc2[\x80-\xbf]/;

my $mangel = 0;

for my $datei (@dateien) {
    unless (-f $datei) {
        print "  $datei: nicht gefunden\n";
        $mangel = 1;
        next;
    }

    open my $h, '<:raw', $datei or die "$datei: $!\n";
    my @zeilen = <$h>;
    close $h;

    my ($betroffen, $gedreht, $stehengeblieben) = (0, 0, 0);
    my @unsicher;

    for my $i (0 .. $#zeilen) {
        my $z = $zeilen[$i];
        next unless $z =~ $doppelt;
        $betroffen++;

        # Das Zeilenende wird VOR der Umkehr abgetrennt und danach wieder
        # angehaengt.
        #
        # WARUM: decode() und encode() mit FB_CROAK LEEREN ihren Eingabepuffer
        # als Seiteneffekt ("the $octets argument is consumed"). Bei
        # verschachtelten Aufrufen trifft das ein Temporaer-Lvalue, und die
        # erste Fassung dieses Werkzeugs hat dabei jeder gedrehten Zeile das
        # \n abgeschnitten. Gemessen am 14.09.2026 an BEFUNDE.md: 1516 Zeilen
        # gedreht, und danach hatte die Datei 6313 statt 7829 Zeilen - jede
        # gedrehte Zeile war mit der folgenden verschmolzen. Der Schaden fiel
        # nur auf, weil das Werkzeug die Zeilenzahl NACH dem Schreiben an der
        # Datei nachmisst und nicht seinen eigenen Kontrollfluss meldet
        # (Arbeitsweise/erfolgsmeldung-aus-dem-ergebnis.md). Zurueckgenommen
        # wurde er aus einer Sicherungskopie, die vor dem ersten Schreibzugriff
        # angelegt worden war.
        my $ende = '';
        my $rumpf = $z;
        if ($rumpf =~ s/(\r?\n)\z//) { $ende = $1; }

        # Mehrfach kodierte Zeilen brauchen mehrere Umdrehungen. Die Schleife
        # hoert auf, sobald eine Umdrehung nicht mehr sicher ist - sie dreht
        # also nie eine Runde zuviel.
        my $jetzt = $rumpf;
        my $runden = 0;
        while ($jetzt =~ $doppelt and $runden < 5) {
            my $eingabe = $jetzt;   # eigene Kopie, weil decode sie leert
            my $versuch = eval {
                my $text = decode('UTF-8', $eingabe, Encode::FB_CROAK);
                encode('ISO-8859-1', $text, Encode::FB_CROAK);
            };
            last unless defined $versuch;

            # Probe 2: ist das Ergebnis selbst gueltiges UTF-8? Nur dann war
            # die Zeile durchgehend doppelt kodiert und nicht gemischt.
            #
            # Die Probe laeuft auf einer KOPIE. decode() mit FB_CROAK leert
            # seinen Eingabepuffer, und die zweite Fassung dieses Werkzeugs
            # hat genau hier $versuch geleert - danach stand $jetzt auf "",
            # die Zeile wurde zur Leerzeile, und 1516 Befunde in BEFUNDE.md
            # waren weg. Die Zeilenzahl stimmte dabei weiter, weil das
            # abgetrennte \n ordentlich wieder angehaengt wurde; aufgefallen
            # ist es erst an der Kennungszahl (155 -> 62) und an der
            # Dateigroesse (526181 -> 306380 Byte).
            my $probe = $versuch;
            my $gueltig = eval { decode('UTF-8', $probe, Encode::FB_CROAK); 1 };
            last unless $gueltig;

            $jetzt = $versuch;
            $runden++;
        }

        # ZWEITER WEG - fuer GEMISCHTE Zeilen, in denen korrekt und doppelt
        # kodierte Zeichen nebeneinander stehen.
        #
        # Die Umkehr oben kann diese Zeilen nicht anfassen: sie wuerde die
        # korrekten Zeichen mitdrehen und damit kaputtmachen. Gemessen am
        # 14.09.2026 an BEFUNDE.md Zeile 248 (Befund E-87), die beides
        # nebeneinander trug:
        #
        #     c3 a4              x3   korrektes "ae"
        #     c3 83 c2 a4        x6   doppelt kodiertes "ae"
        #     e2 80 94           x5   korrekter Gedankenstrich
        #     c3 a2 c2 80 c2 94  x3   doppelt kodierter Gedankenstrich
        #
        # Hier hilft nur die gezielte Ersetzung genau der Doppelmuster. Sie ist
        # eng genug, um kein korrektes Zeichen zu treffen: "c3 83" ist die
        # UTF-8-Fassung von "A-Tilde", und die kommt in deutschem Text nicht
        # allein vor - wohl aber als erste Haelfte jedes doppelt kodierten
        # Umlauts.
        if ($runden == 0) {
            my $versuch = $jetzt;
            $versuch =~ s/\xc3\xa2\xc2([\x80-\xbf])\xc2([\x80-\xbf])/"\xe2$1$2"/ge;
            $versuch =~ s/\xc3\x83\xc2([\x80-\xbf])/"\xc3$1"/ge;
            $versuch =~ s/\xc3\x82\xc2([\x80-\xbf])/"\xc2$1"/ge;

            # Dieselbe Probe wie oben: das Ergebnis muss gueltiges UTF-8 sein.
            if ($versuch ne $jetzt
                and eval { decode('UTF-8', my $k = $versuch, Encode::FB_CROAK); 1 }) {
                $jetzt  = $versuch;
                $runden = 1;
            }
        }

        if ($runden > 0) {
            my $fertig = $jetzt . $ende;

            # DIE EIGENTLICHE SICHERUNG: das ASCII-GERUEST muss Zeichen fuer
            # Zeichen dasselbe bleiben. Eine Umkodierung darf ausschliesslich
            # Bytes ab 0x80 anfassen - jeder Buchstabe, jede Ziffer, jeder
            # Strich und jedes Tabellenzeichen steht vorher wie nachher da.
            #
            # Diese Probe haette beide Unfaelle dieses Werkzeugs am
            # 14.09.2026 sofort gefangen: das verschluckte \n (Geruest
            # kuerzer) und die geleerte Zeile (Geruest leer). Gefunden wurden
            # sie stattdessen erst beim Vergleich gegen die Sicherungskopie -
            # und die gibt es nur, weil sie VOR dem ersten Schreibzugriff
            # angelegt wurde.
            my ($g_alt, $g_neu) = ($z, $fertig);
            s/[\x80-\xff]//g for ($g_alt, $g_neu);
            if ($g_alt ne $g_neu) {
                print "    ABBRUCH: Zeile ", $i + 1,
                      " haette ihr ASCII-Geruest veraendert (", length($g_alt),
                      " -> ", length($g_neu), " Zeichen) - nichts geschrieben.\n";
                exit 1;
            }

            $zeilen[$i] = $fertig;
            $gedreht++;
        }

        if ($jetzt =~ $doppelt) {
            $stehengeblieben++;
            push @unsicher, $i + 1 if @unsicher < 12;
        }
    }

    printf "\n  %s\n", $datei;
    printf "    Zeilen gesamt                 %d\n", scalar @zeilen;
    printf "    davon doppelt kodiert         %d\n", $betroffen;
    printf "    sicher zurueckgedreht         %d\n", $gedreht;
    printf "    stehengeblieben (gemischt)    %d\n", $stehengeblieben;

    if (@unsicher) {
        printf "    Zeilennummern zum Ansehen:    %s%s\n",
            join(', ', @unsicher), ($stehengeblieben > @unsicher ? ' ...' : '');
        $mangel = 1;
    }

    next unless $gedreht;

    if ($schreiben) {
        open my $o, '>:raw', $datei or die "$datei: $!\n";
        print $o @zeilen;
        close $o;

        # Nachmessen statt melden: die Datei wird neu gelesen und gezaehlt.
        open my $p, '<:raw', $datei or die "$datei: $!\n";
        my @neu = <$p>;
        close $p;
        my $rest = grep { $_ =~ $doppelt } @neu;
        printf "    GESCHRIEBEN. Nachgemessen an der Datei: %d Zeilen noch doppelt kodiert,\n", $rest;
        printf "    Zeilenzahl %d (vorher %d).\n", scalar @neu, scalar @zeilen;
    }
    else {
        print "    (nur gemessen - mit -schreiben wird geaendert)\n";
    }
}

print "\n";
exit($mangel ? 1 : 0);
