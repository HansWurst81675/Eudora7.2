#!/usr/bin/perl
use strict;
use warnings;

# stand.pl - Gregors Standardfrage, vollstaendig und in einem Lauf.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor stellt regelmaessig dieselbe Frage, Wort fuer Wort:
#
#     "standard frage: alles gesichert? alles commited? readme updated?
#      changelog auch? findings eingepflegt? vom lektor, prüfer, chronist?
#      neue tests?"
#
# Sieben Teile. Am 14.09.2026 habe ich sie zum zweiten Mal an einem Tag
# beantwortet, drei Pruefungen gefahren - doku-pruefen, pruefe-doku-takt,
# pruefe-stand-md - und daraus "alles" gemacht. Geantwortet habe ich:
#
#     "Findings eingepflegt? - ja, E-89, E-90, E-93, E-94 stehen in
#      BEFUNDE.md und CHANGELOG.md.  Alles gesichert, nichts offen."
#
# WEITERMACHEN.md fuehrte zu diesem Zeitpunkt 8 offene Befunde, BEFUNDE.md
# aber 10: E-94 und E-95 fehlten, also genau die beiden des Abends. Gefunden
# hat es am naechsten Morgen tools/offene-befunde.pl - ein Werkzeug, das es
# seit Tagen gibt und das ich bei der Schlusspruefung nicht gefahren habe.
#
# Gregor am 15.09.2026: "lies mal nach, was du mir gestern auf 'alles
# gespeichert?' geantwortet hast!"
#
# DAS IST DIE KLASSE, nicht der Einzelfall: eine Frage mit sieben Teilen,
# beantwortet aus dem Gedaechtnis, bei der jedes Mal ein anderer Teil
# durchfaellt. Die Lehre dazu heisst Arbeitsweise/pruefumfang-nicht-von-hand.md
# und sagt: Prueflisten holen ihren Umfang aus der Quelle.
#
# ---------------------------------------------------------------------------
# WAS ES PRUEFT - UND WOHER ES DIE LISTE NIMMT
# ---------------------------------------------------------------------------
#
# Die Werkzeugliste wird NICHT hier gefuehrt, sondern aus tools/ gelesen:
# jede Datei, die auf pruefe-*.pl passt oder namentlich zu einem Teil der
# Frage gehoert. Kommt ein Pruefer dazu, faehrt dieses Werkzeug ihn ohne
# Zutun mit. Eine von Hand gefuehrte zweite Liste waere in dem Moment
# veraltet, in dem jemand ein Werkzeug anlegt.
#
# Ausgenommen sind nur die *-tests.pl (Selbsttests der Pruefer, die gehoeren
# in den pre-commit) und die Werkzeuge, die etwas TUN statt zu messen.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/stand.pl           vor jeder Antwort auf die Standardfrage
#   perl tools/stand.pl -knapp    nur die Mangelliste
#
# Rueckgabe: 0 = alles frei, 1 = mindestens ein Teil hat einen Mangel,
#            2 = Aufrufproblem.

my $knapp = grep { $_ eq '-knapp' } @ARGV;

my $wurzel = -f 'VERSION' ? '.' : '..';
unless (-d "$wurzel/tools") {
    print "  stand: tools/ nicht gefunden - bitte aus dem Wurzelverzeichnis\n";
    print "  aufrufen.\n";
    exit 2;
}

# --- Die sieben Teile der Frage, jeder mit seinen Werkzeugen ---------------
#
# Der zweite Eintrag ist ein MUSTER auf den Dateinamen, kein fester Name.
# Damit faehrt ein neuer Pruefer automatisch mit.
my @teile = (
    [ 'alles gesichert / committet',
      qr/^(gesichert|ungesichertes-melden)\.pl$/ ],

    [ 'Dokumentation gegen den Bestand',
      qr/^(doku-pruefen|pruefe-doku-takt|pruefe-stand-md)\.pl$/ ],

    [ 'Befunde eingepflegt',
      qr/^(offene-befunde|pruefe-befundurteile|pruefe-behoben-belegt|pruefe-anzeigetext)\.pl$/ ],

    [ 'Lektor, Pruefer, Chronist im Takt',
      qr/^(rollen-faellig|agenten-laufen|pruefe-rollen-doku)\.pl$/ ],

    [ 'Lehren und ihre Schranken',
      qr/^(lehren-schranken|lehren-uebersicht)\.pl$/ ],

    [ 'Tests',
      qr/^(pruefe-testbau)\.pl$/ ],

    [ 'Bytes und Zweig',
      qr/^(pruefe-bytes|pruefe-branch)\.pl$/ ],
);

# --- Werkzeuge einsammeln --------------------------------------------------
opendir my $dh, "$wurzel/tools" or die "tools/: $!\n";
my @vorhanden = grep { /\.pl$/ && !/-tests\.pl$/ } readdir $dh;
closedir $dh;

my $perl = $^X;

unless ($knapp) {
    print "\n  ------------------------------------------------------------\n";
    print "  stand - Gregors Standardfrage, in einem Lauf\n";
    print "  ------------------------------------------------------------\n";
}

my (@mangel, @frei);
my %gefahren;

for my $t (@teile) {
    my ($name, $muster) = @$t;
    my @werkzeuge = sort grep { $_ =~ $muster } @vorhanden;

    unless (@werkzeuge) {
        push @mangel, { teil => $name, werkzeug => '(keins)',
                        kern => [ 'fuer diesen Teil gibt es kein Werkzeug' ] };
        next;
    }

    for my $w (@werkzeuge) {
        next if $gefahren{$w}++;

        my $ausgabe = `"$perl" "$wurzel/tools/$w" 2>&1`;
        my $rc = $? >> 8;

        if ($rc == 0) {
            push @frei, "$name: $w";
            next;
        }

        # Die Kernaussage herausziehen: die Zeilen unter MANGEL/FEHLEN/OFFEN.
        my @zeilen = grep { /\S/ } split /\n/, $ausgabe;
        my (@kern, $im);
        for my $z (@zeilen) {
            if ($z =~ /^\s*(MANGEL|FEHLEN|FEHLT|OFFEN|FAELLIG|ABBRUCH|NICHT GESICHERT)/) {
                $im = 1;
                push @kern, ($z =~ s/^\s+|\s+$//gr) if $z =~ /FEHLEN|ABBRUCH/;
                next;
            }
            next unless $im;
            last if $z =~ /^\s*(Eine|Also|Warum|Ein Agent|Hat er|Gregor am|Neu setzen)/;
            $z =~ s/^\s+//; $z =~ s/\s+$//;
            push @kern, $z if length $z;
            last if @kern >= 4;
        }
        @kern = ( $zeilen[-1] // "(Rueckgabe $rc)" ) unless @kern;

        push @mangel, { teil => $name, werkzeug => $w, kern => \@kern };
    }
}

# --- Ausgabe ---------------------------------------------------------------
unless ($knapp) {
    printf "  %d Werkzeug(e) gefahren, aus tools/ gelesen\n\n", scalar keys %gefahren;
    print "  FREI:\n";
    print "    $_\n" for @frei;
    print "\n";
}

unless (@mangel) {
    print "  Alle sieben Teile der Standardfrage sind frei.\n\n";
    exit 0;
}

printf "  MANGEL in %d von %d Pruefungen:\n\n", scalar @mangel, scalar keys %gefahren;
for my $m (@mangel) {
    printf "  * %s  (%s)\n", $m->{teil}, $m->{werkzeug};
    printf "      %s\n", $_ for @{ $m->{kern} };
    print "\n";
}

print <<'ENDE';
  Erst beheben, dann antworten. Am 14.09.2026 wurde "alles gesichert,
  nichts offen" gemeldet, waehrend WEITERMACHEN.md zwei Befunde weniger
  fuehrte als BEFUNDE.md - offene-befunde.pl haette es gesagt, es wurde
  nur nicht gefahren.

ENDE
exit 1;
