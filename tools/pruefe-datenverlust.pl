#!/usr/bin/perl
use strict;
use warnings;

# pruefe-datenverlust.pl - kein Paket, solange ein Weg offen ist, auf dem
# Gregor Daten verliert.
#
# WARUM ES DAS GIBT
#
# Am 10.09.2026 ist Gregors Postfach auf dem Server geleert worden. Eudora
# kennt DREI Wege, Post auf dem Server zu loeschen:
#
#   1. kein "Leave mail on server"   - Vorgabe im Original: loeschen
#   2. "Delete fetched junk"         - Vorgabe im Original: AN
#   3. Filteraktion "Server Options" - sticht sogar Weg 1
#
# Ich hatte Weg 3 gefunden und in 1.0.38 gesperrt. Weg 2 hatte ich am
# SELBEN VORMITTAG gefunden, beschrieben - und NICHT gesperrt. Dann habe ich
# 1.0.38 ausgeliefert und zum Testen aufgefordert. Weg 2 hat die Post
# geloescht.
#
# Der Fehler war nicht die Analyse. Der Fehler war, ein Paket auszuliefern,
# waehrend ein BEKANNTER Datenverlustweg offen stand - und dabei zum Testen
# aufzufordern, was den Verlust erst ausloest.
#
# WAS ES PRUEFT
#
# In BEFUNDE.md gilt: eine Zeile, die das Wort DATENVERLUST traegt,
# beschreibt einen Weg, auf dem Daten des Anwenders verlorengehen. Solange
# eine solche Zeile nicht ALS BEHOBEN gekennzeichnet ist, wird kein Paket
# gebaut.
#
# Die Kennzeichnung ist bewusst grob: lieber ein Paket zu viel abgewiesen als
# eines zu wenig. Wer wirklich muss, nimmt -Trotzdem in paket-bauen.ps1 und
# begruendet es dort.
#
# Rueckgabe: 0 = kein offener Weg, 1 = mindestens einer.

my $wurzel = $0;
$wurzel =~ s{[\\/]tools[\\/][^\\/]+$}{};
$wurzel = '.' if $wurzel eq $0 || $wurzel eq '';

my $datei = "$wurzel/BEFUNDE.md";
open my $h, '<:raw', $datei or die "$datei: $!\n";
my $t;
{ local $/; $t = <$h>; }
close $h;

my @zeilen = split /\n/, $t;
my (@offen, @behoben);

for my $z (@zeilen) {
    next unless $z =~ /DATENVERLUST/;
    next unless $z =~ /^\|/;              # nur Tabellenzeilen

    my ($kennung) = $z =~ /^\|\s*(\S+)\s*\|/;
    $kennung = '?' unless defined $kennung;

    # "behoben" muss FETT dastehen - "nicht behoben" oder "teilweise behoben"
    # zaehlt nicht. Die Zeile wird dafuer auf das erste Urteil hin gelesen.
    my ($urteil) = $z =~ /\*\*(behoben|offen|in Arbeit|kein eigener Fehler)[^*]*\*\*/i;
    $urteil = '(kein Urteil)' unless defined $urteil;

    if (lc($urteil) eq 'behoben') {
        push @behoben, "$kennung";
    }
    else {
        push @offen, "$kennung - Urteil in BEFUNDE.md: $urteil";
    }
}

print "\n  Wege, auf denen Daten verlorengehen\n";
print '  ', '-' x 68, "\n";
printf "  in BEFUNDE.md gekennzeichnet   %d\n", scalar(@offen) + scalar(@behoben);
printf "  davon behoben                  %d\n", scalar @behoben;
printf "  davon OFFEN                    %d\n", scalar @offen;
print '  ', '-' x 68, "\n";

if (@behoben) {
    print "\n  behoben: ", join(', ', @behoben), "\n";
}

if (@offen) {
    print "\n  KEIN PAKET - diese Wege stehen offen:\n\n";
    print "    - $_\n" for @offen;
    print "\n  Ein Paket, das ausgeliefert und getestet wird, waehrend ein\n";
    print "  bekannter Datenverlustweg offen ist, loest den Verlust erst aus.\n";
    print "  Genau so ist am 10.09.2026 Gregors Postfach geleert worden.\n";
    print "  Siehe Arbeitsweise/kein-paket-mit-offenem-datenverlust.md.\n\n";
    exit 1;
}

print "\n  Kein offener Weg. Ein Paket darf gebaut werden.\n\n";
exit 0;
