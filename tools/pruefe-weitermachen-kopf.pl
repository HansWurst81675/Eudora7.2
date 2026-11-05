#!/usr/bin/perl
use strict;
use warnings;

# pruefe-weitermachen-kopf.pl - steht oben in Intern/WEITERMACHEN.md genau
# EIN kurzer Stand, und keine Zeile, die niemand mehr lesen kann?
#
#   perl tools/pruefe-weitermachen-kopf.pl               # Intern/WEITERMACHEN.md
#   perl tools/pruefe-weitermachen-kopf.pl <datei>       # eine andere Datei
#   perl tools/pruefe-weitermachen-kopf.pl --selbsttest  # beide Richtungen
#
# Rueckgabe: 0 = Kopf in Ordnung, 1 = MANGEL, 2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DAS GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 05.11.2026, beim Blick auf Intern/WEITERMACHEN.md auf GitHub:
#
#     "hier ist die formattierung am anfang wuest."
#
# Gemessen am Stand 0dfce844: zwischen "# Hier weitermachen" und der ersten
# Ueberschrift "## " standen FUENF Absaetze, die mit "**Stand " begannen
# (05.11., 04.11. zweimal, 03.11. zweimal), jeder eine einzige Zeile von 457
# bis 13 032 Zeichen. Jeder neue Stand wurde oben davorgesetzt, keiner der
# alten ersetzt; zwei endeten mitten im Satz, und der Rest des einen stand
# als abgerissenes Bruchstueck darunter. Aufgeraeumt auf dem Zweig
# doku_weitermachen_kopf: oben ein Stand als Liste, die alten Staende
# gekuerzt unter "Fruehere Staende" am Ende der Datei.
#
# DIE REGEL
#
# Im Kopf (von "# Hier weitermachen" bis zur ersten Zeile "## "):
#   * hoechstens EIN Absatz beginnt mit "**Stand ";
#   * keine Zeile ist laenger als 400 Zeichen.
# Ein neuer Stand ERSETZT den alten; der alte wandert gekuerzt nach unten.
#
# BEKANNTE GRENZEN
#
# * Gezaehlt werden Zeichen (UTF-8 dekodiert), nicht die Breite am Schirm.
# * Ein Stand, der anders anfaengt ("Stand:" ohne Fettdruck), wird nicht
#   gezaehlt; die Laengengrenze faengt ihn aber, sobald er wuchert.

my $GRENZE = 400;

my @dateien;
for my $a (@ARGV) {
    if    ($a eq '--selbsttest') { exit selbsttest() }
    elsif ($a =~ /^-/)           { print "  pruefe-weitermachen-kopf: unbekannt: $a\n"; exit 2 }
    else                         { push @dateien, $a }
}
unless (@dateien) {
    my $wurzel = -f 'VERSION' ? '.' : '..';
    @dateien = ("$wurzel/Intern/WEITERMACHEN.md");
}

my @mangel;
for my $d (@dateien) {
    open my $h, '<:encoding(UTF-8)', $d
        or do { print "  pruefe-weitermachen-kopf: $d nicht lesbar\n"; exit 2 };
    my $t = do { local $/; <$h> };
    close $h;
    push @mangel, map { "$d: $_" } pruefe($t);
}

if (@mangel) {
    print "  pruefe-weitermachen-kopf: MANGEL\n";
    print "    - $_\n" for @mangel;
    print "  Ein neuer Stand ersetzt den alten; der alte wandert gekuerzt nach\n";
    print "  \"Fruehere Staende\" am Ende der Datei (Gregor 05.11.2026).\n";
    exit 1;
}
print "  pruefe-weitermachen-kopf: Kopf mit hoechstens einem Stand, keine Zeile ueber $GRENZE Zeichen.\n";
exit 0;

sub pruefe {
    my ($t) = @_;
    my @m;
    my @z = split /\n/, $t, -1;
    my ($anfang) = grep { $z[$_] =~ /^# Hier weitermachen/ } 0 .. $#z;
    return ("keine Zeile '# Hier weitermachen'") unless defined $anfang;
    my $staende = 0;
    my $vorher_leer = 1;
    for my $i ($anfang + 1 .. $#z) {
        my $l = $z[$i];
        last if $l =~ /^## /;
        $l =~ s/\r\z//;
        if ($vorher_leer and $l =~ /^\*\*Stand /) { $staende++ }
        if (length($l) > $GRENZE) {
            push @m, sprintf('Zeile %d im Kopf hat %d Zeichen (Grenze %d)', $i + 1, length($l), $GRENZE);
        }
        $vorher_leer = ($l =~ /^\s*\z/) ? 1 : 0;
    }
    push @m, "$staende Absaetze beginnen im Kopf mit '**Stand ' (erlaubt: 1)" if $staende > 1;
    return @m;
}

sub selbsttest {
    my $fehler = 0;
    my $gut = "# Hier weitermachen\n\n**Stand 05.11.2026 abends.**\n\n- eins\n- zwei\n\n## Liste\n\n**Stand 01.01.2020** darf unten stehen\n";
    my $zwei = "# Hier weitermachen\n\n**Stand 05.11.2026.** a\n\n**Stand 04.11.2026.** b\n\n## Liste\n";
    my $lang = "# Hier weitermachen\n\n**Stand 05.11.2026.** " . ('x' x 500) . "\n\n## Liste\n";
    my @f = (
        [ 'erlaubter Kopf ist gruen',          $gut,  0 ],
        [ 'zwei Staende sind rot',             $zwei, 1 ],
        [ 'Zeile ueber 400 Zeichen ist rot',   $lang, 1 ],
    );
    for my $c (@f) {
        my ($name, $text, $soll_rot) = @$c;
        my $ist_rot = pruefe($text) ? 1 : 0;
        my $ok = $ist_rot == $soll_rot;
        printf "  [%s] %s\n", ($ok ? 'ok  ' : 'FEHL'), $name;
        $fehler++ unless $ok;
    }
    print $fehler ? "  selbsttest: $fehler Fehler\n" : "  selbsttest: alle gruen\n";
    return $fehler ? 1 : 0;
}
