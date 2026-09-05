#!/usr/bin/perl
#
# Sammelt die Befunddateien der Agenten ein und haengt sie an BEFUNDE.md an.
#
#   perl tools/befunde-einsammeln.pl              zeigt, was anliegt
#   perl tools/befunde-einsammeln.pl --anhaengen  haengt an BEFUNDE.md an
#   perl tools/befunde-einsammeln.pl --naechste E nennt die naechste freie Kennung
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 05.09.2026 liefen bis zu acht Agenten gleichzeitig. Jeder hat seinen Befund
# ans ENDE von BEFUNDE.md angehaengt - und genau deshalb endete JEDE einzelne
# Zusammenfuehrung im Konflikt, viermal derselbe Handgriff an derselben Stelle.
# Zweimal wurde ausserdem dieselbe Kennung (E-12) vergeben, weil zwei Agenten
# unabhaengig "die naechste freie Nummer" suchten, waehrend der jeweils andere
# schon schrieb.
#
# Beides sind keine Fehler der Agenten, sondern der Zuteilung. Die Antwort ist
# nicht "besser aufpassen", sondern: NIEMAND SCHREIBT IN EINE GEMEINSAME DATEI.
#
#   Befunde/KONTO.md
#   Befunde/ZEICHEN.md
#   Befunde/BEENDEN.md
#
# Zwei Agenten fassen damit nie dieselbe Datei an - ein Konflikt ist strukturell
# unmoeglich, nicht nur unwahrscheinlich. Dieses Werkzeug fuehrt am Ende
# zusammen, und zwar nachdem alle fertig sind.
#
# Das Verfahren steht vollstaendig in AGENTEN.md.
#
use strict;
use warnings;

my $anhaengen = grep { $_ eq '--anhaengen' } @ARGV;
my $naechste;
for my $i (0 .. $#ARGV) { $naechste = $ARGV[$i+1] if $ARGV[$i] eq '--naechste' }

my $ZIEL  = 'BEFUNDE.md';
my $ORDNER = 'Befunde';

sub roh {
    my ($p) = @_;
    open(my $f, '<:raw', $p) or return undef;
    local $/;
    my $d = <$f>;
    close $f;
    return defined $d ? $d : '';
}

# --- Kennungen, die es schon gibt ---------------------------------------------
#
# Gesucht wird in BEFUNDE.md UND in den noch nicht eingesammelten Dateien -
# sonst waere die Antwort schon veraltet, sobald zwei Agenten laufen.

sub belegte_kennungen {
    my %k;
    my $d = roh($ZIEL);
    if (defined $d) {
        $k{$1} = 1 while $d =~ /^#+\s+([A-Z]+[0-9]*-\d+)\b/gm;
        $k{$1} = 1 while $d =~ /^\|\s*([A-Z]+[0-9]*-\d+)\s*\|/gm;
    }
    if (opendir(my $dh, $ORDNER)) {
        for my $n (grep { /\.md$/ } readdir $dh) {
            my $t = roh("$ORDNER/$n");
            next unless defined $t;
            $k{$1} = 1 while $t =~ /^#+\s+([A-Z]+[0-9]*-\d+)\b/gm;
        }
        closedir $dh;
    }
    return %k;
}

# --- naechste freie Kennung ---------------------------------------------------

if (defined $naechste and length $naechste) {
    (my $reihe = $naechste) =~ s/[^A-Za-z0-9]//g;
    $reihe = uc $reihe;
    my %k = belegte_kennungen();

    # HOECHSTE plus eins, NICHT die erste Luecke. In dieser Sammlung fehlt
    # zum Beispiel E-10 - die Kennung ist nie vergeben worden, und das ist
    # ausdruecklich dokumentiert. Wer eine Luecke nachtraeglich fuellt, macht
    # aus einer harmlosen Auslassung eine Verwechslungsgefahr: aeltere Notizen,
    # die "E-10 gibt es nicht" sagen, waeren dann falsch.
    my $hoechste = 0;
    for my $kk (keys %k) {
        next unless $kk =~ /^\Q$reihe\E-(\d+)$/;
        $hoechste = $1 if $1 > $hoechste;
    }
    my $n = $hoechste + 1;

    my @belegt = sort { ($a =~ /-(\d+)$/)[0] <=> ($b =~ /-(\d+)$/)[0] }
                 grep { /^\Q$reihe\E-\d+$/ } keys %k;

    print "\n  Naechste freie Kennung der Reihe $reihe: $reihe-$n\n\n";
    print "  Belegt sind: " . join(', ', @belegt) . "\n\n";

    # Luecken benennen, damit niemand sie fuer einen Fehler haelt.
    my @luecken = grep { !$k{"$reihe-$_"} } (1 .. $hoechste);
    print "  Luecken (bewusst nicht gefuellt): "
        . join(', ', map { "$reihe-$_" } @luecken) . "\n\n" if @luecken;
    print "  Diese Kennung gehoert WOERTLICH in den Auftrag des Agenten. Wer\n";
    print "  mehrere gleichzeitig startet, vergibt einen Block und nennt jedem\n";
    print "  seine eigene - ein Agent kann nicht wissen, was frei ist, weil der\n";
    print "  Nachbar gleichzeitig schreibt (das ist am 05.09.2026 passiert).\n\n";
    exit 0;
}

# --- Was liegt an? ------------------------------------------------------------

unless (-d $ORDNER) {
    print "\n  Kein Ordner $ORDNER/ - nichts einzusammeln.\n\n";
    print "  Agenten schreiben ihren Befund nach $ORDNER/<AGENTENNAME>.md,\n";
    print "  nicht nach $ZIEL. Siehe AGENTEN.md.\n\n";
    exit 0;
}

opendir(my $dh, $ORDNER) or die "Kann $ORDNER nicht lesen: $!\n";
my @dateien = sort grep { /\.md$/ } readdir $dh;
closedir $dh;

unless (@dateien) {
    print "\n  $ORDNER/ ist leer - nichts einzusammeln.\n\n";
    exit 0;
}

print "\n  Anliegende Befunddateien:\n\n";

my @kennungen_gesamt;
my %doppelt;

for my $n (@dateien) {
    my $d = roh("$ORDNER/$n");
    next unless defined $d;
    my @k;
    push @k, $1 while $d =~ /^#+\s+([A-Z]+[0-9]*-\d+)\b/gm;
    my $zeilen = () = $d =~ /\n/g;
    printf("    %-24s %5d Zeilen   %s\n", $n, $zeilen,
           (@k ? join(', ', @k) : 'KEINE Kennung gefunden'));
    for my $kk (@k) {
        $doppelt{$kk}++;
        push @kennungen_gesamt, $kk;
    }
}

# --- Kollisionen melden, bevor irgendetwas angehaengt wird --------------------

my @kollision = sort grep { $doppelt{$_} > 1 } keys %doppelt;

my %in_ziel;
{
    my $d = roh($ZIEL);
    if (defined $d) {
        $in_ziel{$1} = 1 while $d =~ /^#+\s+([A-Z]+[0-9]*-\d+)\b/gm;
    }
}
my @schon_drin = sort grep { $in_ziel{$_} } @kennungen_gesamt;

if (@kollision or @schon_drin) {
    print "\n  KENNUNGSKOLLISION - nicht angehaengt:\n\n";
    print "    doppelt vergeben:   " . join(', ', @kollision)   . "\n" if @kollision;
    print "    steht schon in $ZIEL: " . join(', ', @schon_drin) . "\n" if @schon_drin;
    print "\n  Erst umnumerieren, dann erneut. Wer umnumeriert, schreibt in den\n";
    print "  Abschnitt eine Zeile, unter welcher Kennung er vorher lief - sonst\n";
    print "  sucht spaeter jemand einen Befund, den es nicht mehr gibt.\n\n";
    exit 1;
}

unless ($anhaengen) {
    print "\n  Nichts geaendert. Zum Anhaengen:\n\n";
    print "    perl tools/befunde-einsammeln.pl --anhaengen\n\n";
    exit 0;
}

# --- Anhaengen ----------------------------------------------------------------
#
# Byte-erhaltend: BEFUNDE.md ist UTF-8 mit LF. Die Befunddateien werden woertlich
# uebernommen; nur ein Trenner kommt dazwischen.

my $ziel = roh($ZIEL);
die "$ZIEL nicht lesbar\n" unless defined $ziel;
my $cr_vorher = () = $ziel =~ /\r/g;

$ziel .= "\n" unless $ziel =~ /\n\z/;

for my $n (@dateien) {
    my $d = roh("$ORDNER/$n");
    next unless defined $d;
    (my $agent = $n) =~ s/\.md$//;
    $d =~ s/\r\n/\n/g;                 # die Sammeldatei ist durchgehend LF
    $d .= "\n" unless $d =~ /\n\z/;
    $ziel .= "\n---\n\n" . $d;
    print "    angehaengt: $n (Agent $agent)\n";
}

open(my $o, '>:raw', $ZIEL) or die "Kann $ZIEL nicht schreiben: $!\n";
print $o $ziel;
close $o;

my $cr_nachher = () = $ziel =~ /\r/g;
printf("\n  %s: CR %d -> %d, %d Zeilen\n", $ZIEL, $cr_vorher, $cr_nachher,
       scalar(() = $ziel =~ /\n/g));

print "\n  Die Dateien in $ORDNER/ sind NICHT geloescht - erst pruefen, dann\n";
print "  entfernen. Danach fehlen noch die Verzeichniseintraege oben in\n";
print "  $ZIEL; das ist Aufgabe von LEKTOR und laeuft allein.\n\n";
exit 0;
