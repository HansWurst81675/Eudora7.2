#!/usr/bin/perl
use strict;
use warnings;

# rollen-faellig.pl - weist einen Push ab, wenn eine Daueraufgabe faellig ist.
#
# WARUM ES DAS GIBT
#
# Gregor am 08.09.2026: "du fällst immer wieder ins gleiche muster, obwohl mir
# das jedes mal mehrfach geklärt und ausgemacht haben." Gemeint war, dass ich
# die Dokumentationsarbeit selbst anfange, statt sie LEKTOR zu geben - und dass
# er nach LEKTOR, PRUEFER und CHRONIST fragen muss, statt dass sie von selbst
# laufen.
#
# Die Lehre dazu (Arbeitsweise/daueraufgaben-brauchen-einen-takt.md) stand
# schon da und hat nicht gewirkt. Eine Lehre ohne Ausloeser wirkt nicht; sie
# braucht einen Moment, in dem sie geprueft wird. Das ist dieser Moment: der
# Push. Ab hier kann ich die Regel nicht mehr vergessen, weil sie mich abweist.
#
# WAS GEPRUEFT WIRD
#
# Fuer jede Rolle: gab es seit dem letzten Bericht dieser Rolle Commits, die
# ihren Zustaendigkeitsbereich beruehren? Wenn ja, ist sie faellig.
#
#   LEKTOR    zustaendig fuer *.md            -> Bericht Befunde/LEKTOR-N.md
#   PRUEFER   zustaendig fuer Eudora71/**     -> Bericht Befunde/PRUEFER-N.md
#   CHRONIST  zustaendig fuer Arbeitsweise/   -> Bericht Arbeitsweise/*.md
#
# Der "letzte Bericht" ist der juengste Commit, der die hoechste vorhandene
# Berichtsdatei der Rolle angelegt oder geaendert hat. Damit braucht es keine
# Zustandsdatei, die man vergessen kann - die Buchfuehrung ist der git-Verlauf
# selbst.
#
# NICHT ABWEISEN, SONDERN MELDEN, wenn die Rolle GERADE laeuft: dafuer gibt es
# den Schalter --laufend mit den Rollennamen, den ich setze, wenn ich eine
# Rolle beauftragt habe und ihren Ruecklauf noch abwarte.
#
# Aufruf:
#   perl tools/rollen-faellig.pl                    # prueft und weist ab
#   perl tools/rollen-faellig.pl --laufend LEKTOR   # LEKTOR ist beauftragt
#   perl tools/rollen-faellig.pl --nur-melden       # exit 0, nur Bericht
#   perl tools/rollen-faellig.pl --gegen COMMIT     # Vergleichsstand von Hand
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

my %laufend;
my $nur_melden = 0;
my $gegen;

while (@ARGV) {
    my $a = shift @ARGV;
    if    ($a eq '--laufend')    { my $n = shift @ARGV; $laufend{uc $n} = 1 if defined $n; }
    elsif ($a eq '--nur-melden') { $nur_melden = 1; }
    elsif ($a eq '--gegen')      { $gegen = shift @ARGV; }
    else { die "rollen-faellig.pl: unbekannter Schalter '$a'\n"; }
}

sub git {
    my (@arg) = @_;
    my @aus = `git @arg 2>&1`;
    chomp @aus;
    return @aus;
}

# Die Rollen. 'muster' ist ein Perl-Muster gegen den Pfad eines geaenderten
# Dateinamens; 'bericht' findet die Berichtsdateien der Rolle.
my @rollen = (
    {
        name    => 'LEKTOR',
        was     => 'die Dokumentation gegen den Bestand',
        muster  => qr{\.md$},
        # Die eigenen Berichte zaehlen NICHT als Aenderung, sonst ist die Rolle
        # nach ihrem eigenen Bericht sofort wieder faellig.
        ausser  => qr{^(?:Befunde/(?:LEKTOR|PRUEFER)-\d+\.md|Arbeitsweise/)},
        bericht => 'Befunde/LEKTOR-*.md',
        auftrag => 'Alle MDs gegen den Bestand pruefen, nicht gegen den Diff.',
    },
    {
        name    => 'PRUEFER',
        was     => 'die Behebungen im Quelltext',
        muster  => qr{^Eudora71/.*\.(?:cpp|h|rc|rc2)$},
        ausser  => undef,
        bericht => 'Befunde/PRUEFER-*.md',
        auftrag => 'Jede Behebung gegen die MFC-Quelle nachrechnen, Gegenvermutungen aufstellen.',
    },
    {
        name    => 'CHRONIST',
        was     => 'die Lehren aus dem Verlauf',
        muster  => qr{^(?:Eudora71/|tools/)},
        ausser  => undef,
        bericht => 'Arbeitsweise/*.md',
        auftrag => 'Den Chat seit dem letzten Lauf auswerten, Lehren anlegen und ergaenzen.',
    },
);

my @mangel;
my @melde;

for my $r (@rollen) {
    my $name = $r->{name};

    # Juengster Commit, der eine Berichtsdatei dieser Rolle beruehrt hat.
    my ($stand) = git('log', '-1', '--format=%H', '--', $r->{bericht});
    if (!defined $stand or $stand !~ /^[0-9a-f]{7,40}$/) {
        push @melde, "$name: kein Bericht im Verlauf gefunden ($r->{bericht}) - "
                   . "die Rolle hat noch nie gelaufen";
        next;
    }

    my $bezug = defined($gegen) ? $gegen : $stand;

    # Welche Dateien haben sich seither geaendert?
    my @dateien = git('diff', '--name-only', "$bezug..HEAD");
    my @betroffen;
    for my $d (@dateien) {
        next unless $d =~ $r->{muster};
        next if defined $r->{ausser} and $d =~ $r->{ausser};
        push @betroffen, $d;
    }

    if (!@betroffen) {
        push @melde, sprintf('%-9s aktuell (Bericht %s, seither 0 Dateien in seinem Bereich)',
                             $name, substr($stand, 0, 7));
        next;
    }

    my $wieviel = scalar @betroffen;
    my @beispiel = @betroffen[0 .. ($wieviel > 3 ? 2 : $wieviel - 1)];
    my $liste = join(', ', @beispiel);
    $liste .= sprintf(' und %d weitere', $wieviel - 3) if $wieviel > 3;

    if ($laufend{$name}) {
        push @melde, sprintf('%-9s faellig, aber beauftragt (%d Datei(en): %s)',
                             $name, $wieviel, $liste);
        next;
    }

    push @mangel, "$name ist faellig: seit seinem Bericht (" . substr($stand, 0, 7)
                . ") haben sich $wieviel Datei(en) in seinem Bereich geaendert - $liste.\n"
                . "      Zustaendig fuer: $r->{was}.\n"
                . "      Auftrag: $r->{auftrag}\n"
                . "      Laeuft die Rolle schon? Dann: perl tools/rollen-faellig.pl --laufend $name";
}

print "\n  Daueraufgaben: laufen Lektor, Pruefer und Chronist im Takt?\n";
print '  ' . ('-' x 60) . "\n";
print "  $_\n" for @melde;

if (@mangel) {
    print "\n  FAELLIG:\n\n";
    print "    - $_\n\n" for @mangel;
    print "  Warum das abweist: Gregor soll nicht nach den Rollen fragen muessen.\n";
    print "  Wenn er fragt, ist die Rolle nicht eingerichtet - siehe\n";
    print "  Arbeitsweise/daueraufgaben-brauchen-einen-takt.md.\n\n";
    exit 1 if !$nur_melden;
    exit 0;
}

print "\n  Alle Rollen sind im Takt.\n\n";
exit 0;
