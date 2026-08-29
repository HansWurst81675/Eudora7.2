#!/usr/bin/perl
#
# Meldet, wie weit Pruefung und Dokumentation hinter dem Code herhinken.
#
#   perl tools/pruefstand-melden.pl
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 29.08.2026 liefen sieben Agenten gleichzeitig - darunter ein Pruefer und ein
# Lektor, waehrend vier andere noch Code schrieben. Beide prueften ein bewegliches
# Ziel und waren in dem Moment veraltet, in dem sie ihren Bericht abgaben. Gregor
# musste zweimal nachfragen, ob denn alles geprueft sei.
#
# Pruefung und Doku gehoeren ans Ende einer Arbeitswelle, nicht mittendrin. Dieses
# Werkzeug macht sichtbar, wann das wieder faellig ist - statt sich darauf zu
# verlassen, dass jemand daran denkt.
#
use strict;
use warnings;

# Wo steht der jeweils gepruefte Stand?
#   Datei                  => Regex, die den Commit-Hash aus der Datei zieht
my %quellen = (
    'BEFUNDE.md'           => qr/\b([0-9a-f]{7,40})\b/,
    'README.md'            => qr/\b([0-9a-f]{7,40})\b/,
    'PORTIERUNG.md'        => qr/\b([0-9a-f]{7,40})\b/,
);

my $head = `git rev-parse --short HEAD 2>/dev/null`;
chomp $head;
exit 0 unless $head;

my $gesamt = `git rev-list --count HEAD 2>/dev/null`;
chomp $gesamt;

my $warnung = 0;

print "Stand HEAD: $head\n\n";

for my $datei (sort keys %quellen) {
    unless (-f $datei) {
        printf "  %-18s fehlt\n", $datei;
        next;
    }

    # Den zuletzt genannten Commit-Hash aus der Datei holen, der auch existiert.
    open(my $fh, '<', $datei) or next;
    my $gefunden;
    while (my $z = <$fh>) {
        while ($z =~ /$quellen{$datei}/g) {
            my $kandidat = $1;
            next if length($kandidat) < 7;
            my $pruef = `git cat-file -t $kandidat 2>/dev/null`;
            chomp $pruef;
            $gefunden = $kandidat if $pruef eq 'commit';
        }
    }
    close $fh;

    unless ($gefunden) {
        printf "  %-18s nennt keinen Commit - Stand unbekannt\n", $datei;
        $warnung = 1;
        next;
    }

    my $abstand = `git rev-list --count $gefunden..HEAD 2>/dev/null`;
    chomp $abstand;
    $abstand = 0 unless defined $abstand && $abstand =~ /^\d+$/;

    my $hinweis = '';
    if ($abstand >= 10) { $hinweis = '  <== faellig'; $warnung = 1; }
    elsif ($abstand >= 5) { $hinweis = '  (bald faellig)'; }

    printf "  %-18s geprueft bis %s, seither %2d Commit(s)%s\n",
           $datei, $gefunden, $abstand, $hinweis;
}

if ($warnung) {
    print "\nPruefung bzw. Doku sind hinter dem Code zurueck.\n";
    print "Vor dem naechsten Meilenstein PRUEFER und LEKTOR auf den Abstand\n";
    print "seit dem jeweils genannten Commit ansetzen.\n";
    exit 1;
}

print "\nPruefung und Doku sind nah am Code.\n";
exit 0;
