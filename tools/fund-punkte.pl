#!/usr/bin/perl
use strict;
use warnings;

# fund-punkte.pl - zerlegt einen Fund aus einem Bericht (PRUEFER-, LEKTOR-,
# BEFUNDE.md) in die Punkte, die eine Behebung abdecken muss.
#
# WARUM ES DAS GIBT
#
# Am 13.10.2026 hat die Behebung zu PRUEFER-23 N1 (9f5142b, 12:09) nur den
# Breitendeckel repariert. Der Abschnitt nannte die Gegenrichtung ausdruecklich
# ("Gegenrichtung :3663-3669 ... width=\"1\" height=\"600\"", dazu im Vorschlag
# "Ebenso fuer die Breite"). Gefunden hat die zweite Haelfte erst LEKTOR-29,
# 13 Minuten spaeter; ein zweiter Test, ein zweiter Bau, eine zweite Messung.
# Am selben Vormittag dasselbe bei PRUEFER-22 F2: die Zeile nannte die
# Ladestelle PgEmbeddedImage.cpp, getestet wurde nur die Regel.
# Zweimal dieselbe Klasse: der Fund wird gelesen, aber nicht abgehakt.
# Lehre: Arbeitsweise/fund-ganz-abhaken.md
#
# WAS AUSGEGEBEN WIRD
#
# Aus dem Abschnitt ab <a id="ANKER"> bis zur naechsten Ueberschrift gleicher
# oder hoeherer Ebene:
#   ORT    jede Angabe Datei:Zeile oder :Zeile (an einem eigenen Ort gehoert ein
#          eigener Test oder eine eigene Messung)
#   ZWEITE jeder Satz mit Gegenrichtung, umgekehrt, ebenso, ebenfalls, beide,
#          auch fuer/bei, Gegenprobe, symmetrisch (ein zweiter Fall im selben Fund)
# Die Liste ist der Prueffaden fuer den Commit: jeder Punkt erledigt oder
# begruendet verworfen.
#
# Aufruf:
#   perl tools/fund-punkte.pl Befunde/PRUEFER-23.md n1
#   perl tools/fund-punkte.pl --selbsttest

binmode STDOUT, ':utf8';

my $ZWEIT = qr/Gegenrichtung|umgekehrt|[Ee]benso|ebenfalls|\bbeide[n]?\b|auch (?:f\x{fc}r|fuer|bei)|Gegenprobe|symmetrisch/;

sub punkte {
    my ($text, $anker) = @_;
    my @z = split /\n/, $text;
    my ($beg, $ebene);
    for my $i (0 .. $#z) {
        if ($z[$i] =~ /^(#+)\s.*<a id="\Q$anker\E">/i || $z[$i] =~ /^(#+)\s+\Q$anker\E\b/i) { $beg = $i; $ebene = length $1; last }
    }
    return undef unless defined $beg;
    my $end = $#z;
    for my $i ($beg + 1 .. $#z) {
        if ($z[$i] =~ /^(#+)\s/ && length($1) <= $ebene) { $end = $i - 1; last }
    }
    my $abschnitt = join "\n", @z[$beg + 1 .. $end];
    $abschnitt =~ s/```.*?```//gs;              # Codebloecke sind Beleg, keine Punkte
    my (%gesehen, @orte, @zweit);
    while ($abschnitt =~ /((?:[\w.\/-]+\.(?:cpp|c|h|rc|pl|ps1))?:\d+(?:-\d+)?)/g) {
        push @orte, $1 unless $gesehen{$1}++;
    }
    (my $fluss = $abschnitt) =~ s/\s*\n\s*/ /g;
    for my $satz (split /(?<=[.!?])\s+(?=[A-Z\x{c4}\x{d6}\x{dc}*`(])/, $fluss) {
        push @zweit, $satz if $satz =~ $ZWEIT;
    }
    return { titel => $z[$beg], orte => \@orte, zweit => \@zweit };
}

sub ausgeben {
    my ($r) = @_;
    (my $t = $r->{titel}) =~ s/<a id="[^"]*"><\/a>//;
    print "$t\n\n";
    my $n = 0;
    printf "  [ ] %2d ORT    %s\n", ++$n, $_ for @{ $r->{orte} };
    printf "  [ ] %2d ZWEITE %s\n", ++$n, $_ for @{ $r->{zweit} };
    print "\n  Jeder Punkt: Test oder Messung im selben Commit, sonst im Commit begruenden.\n";
    print "  Kein ZWEITE-Punkt gefunden. Trotzdem fragen: gibt es die Gegenrichtung?\n"
        unless @{ $r->{zweit} };
}

if (@ARGV && $ARGV[0] eq '--selbsttest') {
    my $mit = "### <a id=\"n1\"></a>N1 Titel\n\nDer Deckel `:3654-3661` setzt 1.\nGegenrichtung `:3663-3669`: aus 0 wird 1.\n\n### <a id=\"n2\"></a>N2\nebenso hier\n";
    my $ohne = "## <a id=\"f9\"></a>F9\n\nNur `a.cpp:12` ist falsch.\n";
    my $f = 0;
    my $r = punkte($mit, 'n1');
    $f++, print "FEHL: Gegenrichtung nicht gefunden\n" unless $r && @{ $r->{zweit} } == 1;
    $f++, print "FEHL: zwei Orte erwartet\n" unless $r && @{ $r->{orte} } == 2;
    $f++, print "FEHL: N2 in N1 hineingelesen\n" if $r && grep { /ebenso hier/ } @{ $r->{zweit} };
    $r = punkte($ohne, 'f9');
    $f++, print "FEHL: Fehlalarm ohne zweiten Fall\n" unless $r && !@{ $r->{zweit} } && @{ $r->{orte} } == 1;
    $f++, print "FEHL: fehlender Anker nicht erkannt\n" if defined punkte($ohne, 'x1');
    print $f ? "Selbsttest: $f Fehler\n" : "Selbsttest: 5 Faelle richtig\n";
    exit($f ? 1 : 0);
}

die "Aufruf: perl tools/fund-punkte.pl <Bericht.md> <anker> | --selbsttest\n" unless @ARGV == 2;
my ($datei, $anker) = @ARGV;
open my $fh, '<:encoding(UTF-8)', $datei or die "$datei: $!\n";
my $text = do { local $/; <$fh> };
my $r = punkte($text, $anker) or die "Anker \"$anker\" nicht in $datei\n";
ausgeben($r);
exit 0;
