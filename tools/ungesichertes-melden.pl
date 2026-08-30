#!/usr/bin/perl
#
# Meldet Arbeit, die im Arbeitsverzeichnis liegt und nicht committet ist.
#
#   perl tools/ungesichertes-melden.pl
#
# Rueckgabe 1, wenn etwas ungesichert ist - sonst 0.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Gregor hat mehrfach darauf bestehen muessen, dass Zwischenstaende laufend
# gesichert werden. Der Grund ist nicht Pedanterie: Agenten laufen im Prozess und
# ueberleben ein Abschalten der Maschine nicht. Was nicht committet ist, ist weg -
# und zwar ohne Vorwarnung. Am 28.08.2026 hat das echte Arbeit gekostet.
#
# Ermahnungen wirken dagegen nicht zuverlaessig; ein Werkzeug, das nachsieht,
# schon. Vor jedem Abschalten und in laengeren Arbeitsphasen aufrufen.
#
use strict;
use warnings;

# Dateien, die bei jedem Bau neu geschrieben werden und nie committet gehoeren.
my @rauschen = (
    qr/_i\.c$/, qr/_p\.c$/, qr/dlldata\.c$/, qr/\.tlb$/,
);

my @zeilen = `git status --porcelain 2>/dev/null`;
exit 0 unless @zeilen;

my (@geaendert, @neu);

ZEILE: for my $z (@zeilen) {
    chomp $z;
    next unless length $z > 3;
    my $status = substr($z, 0, 2);
    my $datei  = substr($z, 3);
    $datei =~ s/^"//; $datei =~ s/"$//;

    for my $r (@rauschen) { next ZEILE if $datei =~ $r; }

    if ($status =~ /\?\?/) { push @neu, $datei; }
    else                   { push @geaendert, $datei; }
}

unless (@geaendert || @neu) {
    print "Alles gesichert.\n";
    exit 0;
}

print "UNGESICHERT im Arbeitsverzeichnis:\n\n";

if (@geaendert) {
    print "  Geaendert (" . scalar(@geaendert) . "):\n";
    print "    $_\n" for @geaendert;
}
if (@neu) {
    print "  Neu und noch nicht verfolgt (" . scalar(@neu) . "):\n";
    print "    $_\n" for @neu;
}

print "\nAgenten ueberleben ein Abschalten nicht. Was hier steht, ist verloren,\n";
print "wenn die Maschine ausgeht. Committen und pushen.\n";

exit 1;
