#!/usr/bin/perl
use strict;
use warnings;

# paket-bereit.pl - alle Schranken vor dem Paket auf EINMAL, mit einer Liste.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 13.09.2026, nachdem paket-bauen.ps1 mich viermal hintereinander
# abgewiesen hatte - jedes Mal wegen eines anderen Mangels:
#
#     "du hast nach mind. 51 releases noch keine funktionierende tool chain,
#      auf die du dich verlassen kannst?"
#
# Die Abweisungen waren INHALTLICH richtig, jede einzelne. Falsch war ihre
# Form: paket-bauen.ps1 faehrt sieben Schranken nacheinander und steigt bei
# der ersten mit "exit 1" aus. Wer vier Maengel hat, braucht vier Anlaeufe und
# sieht nie, was noch kommt. Das ist keine Pruefung, das ist ein Minenfeld.
#
# Dieses Werkzeug faehrt DIESELBEN Schranken, bricht aber nicht ab, und gibt
# am Ende eine Liste. Ein Anlauf, alle Maengel.
#
# ---------------------------------------------------------------------------
# WIE ES SICH MIT paket-bauen.ps1 EINIG HAELT
# ---------------------------------------------------------------------------
#
# Es liest die Liste der Pruefer AUS paket-bauen.ps1 heraus, statt sie
# danebenzulegen. Kommt dort eine Schranke dazu, faehrt dieses Werkzeug sie
# ohne Zutun mit; verschwindet eine, faellt sie hier weg. Eine von Hand
# gefuehrte zweite Liste waere in dem Moment veraltet, in dem jemand
# paket-bauen.ps1 anfasst - siehe Arbeitsweise/pruefumfang-nicht-von-hand.md.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/paket-bereit.pl          aus dem Wurzelverzeichnis
#   perl tools/paket-bereit.pl -knapp   nur die Mangelliste, keine Ausgaben
#
# Rueckgabe: 0 = alle Schranken frei, 1 = mindestens eine weist ab,
#            2 = Aufrufproblem.

my $knapp = grep { $_ eq '-knapp' } @ARGV;

my $wurzel = -f 'VERSION' ? '.' : '..';
my $bauer  = "$wurzel/tools/paket-bauen.ps1";

unless (-f $bauer) {
    print "  paket-bereit: tools/paket-bauen.ps1 nicht gefunden - bitte aus dem\n";
    print "  Wurzelverzeichnis aufrufen.\n";
    exit 2;
}

# --- Die Pruefliste aus paket-bauen.ps1 lesen ------------------------------
open my $h, '<:raw', $bauer or die "$bauer: $!\n";
my $ps = do { local $/; <$h> };
close $h;

my @pruefer;
my %gesehen;
while ($ps =~ /Join-Path \(Split-Path -Parent \$PSCommandPath\) '([a-z0-9-]+\.pl)'/g) {
    next if $gesehen{$1}++;
    push @pruefer, $1;
}

unless (@pruefer) {
    print "  paket-bereit: in paket-bauen.ps1 steht kein einziger Pruefer -\n";
    print "  entweder hat sich die Schreibweise geaendert oder die Schranken\n";
    print "  sind verschwunden. Beides ist ein Befund.\n";
    exit 2;
}

# --- perl finden, so wie paket-bauen.ps1 es tut ----------------------------
my $perl = $^X;

# --- Fahren ----------------------------------------------------------------
unless ($knapp) {
    print "\n  ------------------------------------------------------------\n";
    print "  paket-bereit - alle Schranken vor dem Paket\n";
    print "  ------------------------------------------------------------\n";
    printf "  %d Schranke(n), gelesen aus paket-bauen.ps1\n\n", scalar @pruefer;
}

my (@mangel, @frei, @fehlt);

for my $p (@pruefer) {
    my $pfad = "$wurzel/tools/$p";
    unless (-f $pfad) {
        push @fehlt, $p;
        next;
    }

    my $ausgabe = `"$perl" "$pfad" 2>&1`;
    my $rc = $? >> 8;

    if ($rc == 0) {
        push @frei, $p;
        next;
    }

    # Die erste Zeile, die wie eine Aussage aussieht - nicht der ganze Bericht.
    my @zeilen = grep { /\S/ } split /\n/, $ausgabe;
    my @kern;
    my $imMangel = 0;
    for my $z (@zeilen) {
        if ($z =~ /^\s*(MANGEL|FEHLT|OFFEN|FAELLIG)/) { $imMangel = 1; next; }
        next unless $imMangel;
        last if $z =~ /^\s*(Eine|Also|Warum|Ein Agent|Hat er)/;
        $z =~ s/^\s+//;
        $z =~ s/\s+$//;
        push @kern, $z if $z =~ /^[-*]/ or $z =~ /^\w/;
        last if @kern >= 4;
    }
    unless (@kern) {
        # Kein MANGEL-Block: die letzte Zeile mit Inhalt tut es auch.
        @kern = ($zeilen[-1] || "(Rueckgabe $rc, keine Meldung)");
        $kern[0] =~ s/^\s+//;
    }

    push @mangel, { werkzeug => $p, rc => $rc, kern => \@kern };
}

# --- Ausgabe ---------------------------------------------------------------
unless ($knapp) {
    print "  FREI:\n";
    print "    $_\n" for @frei;
    print "\n";
}

if (@fehlt) {
    print "  NICHT VORHANDEN (paket-bauen.ps1 nennt sie, die Datei fehlt):\n";
    print "    $_\n" for @fehlt;
    print "\n";
}

unless (@mangel) {
    print "  Alle Schranken frei - das Paket kann gebaut werden.\n\n";
    exit 0;
}

printf "  WEIST AB (%d von %d):\n\n", scalar @mangel, scalar @pruefer;
for my $m (@mangel) {
    printf "  * %s\n", $m->{werkzeug};
    printf "      %s\n", $_ for @{ $m->{kern} };
    print "\n";
}

print <<'ENDE';
  Alle Maengel auf einmal, nicht einer nach dem anderen: paket-bauen.ps1
  steigt bei der ersten Schranke aus, und wer vier Maengel hat, braucht
  sonst vier Anlaeufe. Gregor am 13.09.2026: "du hast nach mind. 51
  releases noch keine funktionierende tool chain, auf die du dich
  verlassen kannst?"

ENDE
exit 1;
