#!/usr/bin/perl
# sitzungsbeginn.pl - SessionStart-Haken von Claude Code (.claude/settings.json).
# Faehrt die Schritte aus CLAUDE.md, Abschnitte 1 und 3, und gibt eine kurze
# Lage aus, die Claude Code zu Beginn jeder Sitzung in den Kontext legt.
#
# WARUM ES DAS GIBT. Gregor am 25.10.2026: "ich habe den eindruck, du hast
# deine eigenen tools nicht wirklich im griff! verbessere es!" - die Werkzeuge
# gab es, aber ob sie liefen, hing daran, dass ich mich an sie erinnerte
# (offene Befunde lesen, faellige Rollen, Ungesichertes). Ein Haken laeuft
# ohne mein Gedaechtnis (Arbeitsweise/schranke-gehoert-in-den-haken.md).
#
# Gibt nur die Zeilen aus, die eine Handlung verlangen; weist nie ab.
# Kodierung: reines ASCII.
use strict;
use warnings;
use FindBin;

# Wurzel vom Ort des Skripts, nicht vom Arbeitsverzeichnis (gemessen 25.10.2026
# an haken-pr-lektor.pl: aus Eudora71/ heraus lief der Haken ins Leere).
my $w = "$FindBin::Bin/..";
chdir $w;
sub lauf { my ($c) = @_; my $a = `$c 2>&1`; return $a // '' }

print "Lage zu Sitzungsbeginn (tools/sitzungsbeginn.pl, CLAUDE.md Abschnitte 1 und 3):\n";

my $zweig = lauf("git -C \"$w\" status -sb");
my ($kopf) = split /\n/, $zweig;
print "  Zweig: ", ($kopf // '?'), "\n";

my $ob = lauf("perl \"$w/tools/offene-befunde.pl\"");
for my $z (split /\n/, $ob) {
    print "  $1\n" if $z =~ /^\s*(offen laut Intern\/BEFUNDE\.md\s+\d+.*|davon NIE gemessen\s+\d+.*|\d+ offene Befunde, in beiden Listen.*|MANGEL.*)$/;
}

# Die Kennungen selbst, nicht nur die Zahl (LEKTOR-57 L-57.1: der Schritt, der
# eine Wiederholung von E-85 verhindern soll, nannte keine einzige Kennung).
# Quelle ist der erzeugte Block in Intern/WEITERMACHEN.md - offene-befunde.pl
# hat ihn eben gegen Intern/BEFUNDE.md gehalten.
if (open my $h, '<:encoding(UTF-8)', "$w/Intern/WEITERMACHEN.md") {
    binmode STDOUT, ':encoding(UTF-8)';
    my $drin = 0;
    while (my $z = <$h>) {
        if ($z =~ /offene-befunde: Anfang/) { $drin = 1; next }
        last if $z =~ /offene-befunde: Ende/;
        next unless $drin and $z =~ /^\|\s*\*\*\[([A-Z0-9]+-[\w.]+)\]\([^)]*\)\*\*\s*\|\s*([^|]*?)\s*\|\s*([^|]*?)\s*\|/;
        my ($k, $was, $gem) = ($1, $2, $3);
        $was =~ s/\[([^\]]*)\]\([^)]*\)/$1/g;
        $was =~ s/[*`]//g;
        $was = substr($was, 0, 100) . "\x{2026}" if length $was > 100;
        printf "    %-7s %s%s\n", $k, $was, ($gem =~ /nie gemessen/ ? ' [nie gemessen]' : '');
    }
    close $h;
}

my $rf = lauf("perl \"$w/tools/rollen-faellig.pl\" --nur-melden");
my @faellig = $rf =~ /^\s*-\s*((?:LEKTOR|PRUEFER|CHRONIST) ist faellig[^\n]*)/mg;
if (@faellig) { print "  FAELLIG: $_\n" for @faellig }
else          { print "  Rollen: keine faellig\n" }

my $ge = lauf("perl \"$w/tools/gesichert.pl\"");
if ($ge =~ /NICHT GESICHERT:\s*\n(.*?)(?:\n\s*\n|\z)/s) {
    for my $z (split /\n/, $1) { print "  UNGESICHERT: $1\n" if $z =~ /^\s*-\s*(.+)$/ }
} else {
    print "  Gesichert: alles committet und gepusht\n";
}

# Eingetragene Agentenlaeufe direkt aus der Tabelle - steht dort einer, ist er
# entweder noch unterwegs oder wurde nie abgemeldet; beides gehoert geklaert.
if (open my $h, '<', "$w/tools/AGENTEN-LAUFEN.md") {
    while (my $z = <$h>) { print "  AGENT EINGETRAGEN: $1 seit $2\n" if $z =~ /^\|\s*(LEKTOR|PRUEFER|CHRONIST)\s*\|\s*([^|]+?)\s*\|/ }
    close $h;
}

print "  Vor jedem neuen Befund: perl tools/befund-suchen.pl <Ort>. Vor jedem PR laeuft der LEKTOR (Haken).\n";
exit 0;
