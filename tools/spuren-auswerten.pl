#!/usr/bin/perl
use strict;
use warnings;
use File::Find;

# spuren-auswerten.pl - eine Spurmarke, die niemand ausliest, ist keine
# Messung.
#
# WARUM ES DAS GIBT
#
# Befund E-70 (Fenstergroessen ueberleben keinen Neustart) war vom 10.09.2026
# an offen. Die Spurmarken dazu lagen seit Paket 1.0.37 im Bau. Ausgewertet
# wurden sie zum ersten Mal an Paket 1.0.40 - drei Pakete spaeter. Sie sagten
# dann in zwei Zeilen alles:
#
#     E-70 gesichert:  40 Zeilen
#     E-70 geladen:     0 Zeilen
#
# In der Zwischenzeit sind 1.0.38, 1.0.39 und 1.0.40 gebaut und ausgeliefert
# worden, jedes mit der Bitte an Gregor, etwas anderes zu pruefen. Die Marke
# hat drei Pakete lang mitgeschrieben und niemand hat hingesehen.
#
# Der Einbau einer Marke kostet einen Bau; ihr Nutzen entsteht erst beim
# Auslesen. Dazwischen liegt ein Moment, an den sich niemand von selbst
# erinnert - also gehoert er an das Ereignis, das ihn erzwingt: das naechste
# Paket.
#
# WAS DIESES WERKZEUG PRUEFT
#
#   1. Jeder Befund, zu dem im Quelltext eine SPURMARKE steht, hat eine Zeile
#      in Befunde/SPURMARKEN.md.
#   2. Eine Marke, die in einem FRUEHEREN Paket als dem gerade zu bauenden
#      eingebaut wurde und noch nicht ausgewertet ist, weist ab. Wer sie
#      bewusst mitlaufen lassen will, traegt in der Spalte "ausgewertet"
#      "entfaellt: <Begruendung>" ein - dann steht die Luecke schriftlich da,
#      statt vergessen zu sein.
#   3. Eine Zeile ohne zugehoerige Marke im Quelltext wird gemeldet, weist
#      aber nicht ab: die Marke ist ausgebaut, die Zeile darf weg.
#
# Aufruf:
#   perl tools/spuren-auswerten.pl                 # prueft, weist ab
#   perl tools/spuren-auswerten.pl --nur-melden    # exit 0, nur Bericht
#   perl tools/spuren-auswerten.pl --fassung 1.0.42  # gegen diese Fassung
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

my $nur_melden = 0;
my $fassung_arg = '';
while (@ARGV) {
    my $a = shift @ARGV;
    if    ($a eq '--nur-melden') { $nur_melden = 1; }
    elsif ($a eq '--fassung')    { $fassung_arg = shift(@ARGV) || ''; }
    elsif ($a =~ /^--fassung=(.+)$/) { $fassung_arg = $1; }
    else { die "spuren-auswerten.pl: unbekannter Schalter '$a'\n"; }
}

my $wurzel = '.';
$wurzel = $1 if defined $0 and $0 =~ m{^(.*)/tools/[^/]+$};
$wurzel = $1 if defined $0 and $0 =~ m{^(.*)\\tools\\[^\\]+$};

sub lies {
    my ($p) = @_;
    open my $h, '<:raw', $p or return undef;
    local $/;
    my $d = <$h>;
    close $h;
    return $d;
}

# --- Die Fassung, gegen die geprueft wird -----------------------------------

my $fassung = $fassung_arg;
unless (length $fassung) {
    my $v = lies("$wurzel/VERSION");
    $v = '' unless defined $v;
    $v =~ s/\s+//g;
    $fassung = $v;
}
unless ($fassung =~ /^\d+\.\d+\.\d+$/) {
    print "\n  spuren-auswerten.pl: keine brauchbare Fassung gefunden";
    print " ('$fassung').\n";
    print "  Erwartet wird sie in VERSION oder ueber --fassung.\n\n";
    exit($nur_melden ? 0 : 1);
}

sub zahl {
    my ($v) = @_;
    return -1 unless defined $v and $v =~ /^(\d+)\.(\d+)\.(\d+)$/;
    return $1 * 1000000 + $2 * 1000 + $3;
}

# --- Die Marken im Quelltext ------------------------------------------------
#
# Gesucht wird das Wort SPURMARKE und in derselben Zeile eine Befundnummer.
# Nur Kommentarzeilen: eine Marke steht immer in einem // - oder /* -Kommentar
# ueber der Ausgabe, nie im Protokolltext selbst. Das ist derselbe Grund wie
# in schranke-liest-nur-code, nur andersherum - hier ist der Kommentar das
# Gesuchte und der Zeichenkettentext das Rauschen.

my %marke;   # E-nn => [ "datei:zeile", ... ]

my @quellen;
find(
    {
        no_chdir => 1,
        wanted   => sub {
            my $p = $File::Find::name;
            return unless -f $p;
            return unless $p =~ /\.(?:cpp|h)$/i;
            return if $p =~ m{[/\\](?:Bin|obj|Debug|Release)[/\\]}i;
            push @quellen, $p;
        },
    },
    "$wurzel/Eudora71"
) if -d "$wurzel/Eudora71";

for my $p (@quellen) {
    my $d = lies($p) or next;
    my $nr = 0;
    for my $z (split /\n/, $d) {
        $nr++;
        next unless $z =~ /SPURMARKE/;
        next unless $z =~ m{^\s*(?://|/\*|\*)};   # nur Kommentarzeilen
        my ($id) = $z =~ /\b(E-\d+)\b/;
        next unless defined $id;
        my $kurz = $p;
        $kurz =~ s{^\Q$wurzel\E[/\\]}{};
        $kurz =~ s{\\}{/}g;
        push @{ $marke{$id} }, "$kurz:$nr";
    }
}

# --- Das Verzeichnis der Marken ---------------------------------------------
#
# Befunde/SPURMARKEN.md, eine Tabellenzeile je Befund:
#
#   | E-70 | 1.0.37 | 1.0.40 | ... |
#   | E-76 | 1.0.41 |        | ... |
#   | E-64 | 1.0.29 | entfaellt: Dauerbeobachtung, siehe ... | ... |

my $verz_datei = "$wurzel/Befunde/SPURMARKEN.md";
my $verz = lies($verz_datei);

unless (defined $verz) {
    print "\n  spuren-auswerten.pl: Befunde/SPURMARKEN.md gibt es nicht.\n";
    print "  Dort gehoert je Spurmarke eine Zeile hin:\n\n";
    print "    | E-70 | 1.0.37 | 1.0.40 | kurz, was sie gesagt hat |\n\n";
    exit($nur_melden ? 0 : 1);
}

my %zeile;   # E-nn => { eingebaut, ausgewertet }
for my $z (split /\n/, $verz) {
    next unless $z =~ /^\s*\|/;
    my @s = split /\|/, $z;
    shift @s;                      # das Leere vor dem ersten Strich
    next unless @s >= 3;
    for (@s) { s/^\s+//; s/\s+$//; }
    next unless $s[0] =~ /^(E-\d+)$/;
    my $id = $1;
    $zeile{$id} = { eingebaut => $s[1], ausgewertet => $s[2] };
}

# --- Bewerten ---------------------------------------------------------------

my (@ohne_zeile, @nie_ausgewertet, @verwaist, @in_ordnung, @bewusst_offen);

for my $id (sort { zahl_id($a) <=> zahl_id($b) } keys %marke) {
    my $stellen = join ', ', @{ $marke{$id} };
    unless (exists $zeile{$id}) {
        push @ohne_zeile, "$id hat Spurmarken ($stellen), aber keine Zeile in Befunde/SPURMARKEN.md";
        next;
    }
    my $ein = $zeile{$id}{eingebaut};
    my $aus = $zeile{$id}{ausgewertet};

    unless (defined $ein and $ein =~ /^\d+\.\d+\.\d+$/) {
        push @ohne_zeile, "$id: Spalte 'eingebaut' ist keine Fassung ('"
            . (defined $ein ? $ein : '') . "')";
        next;
    }

    if (defined $aus and $aus =~ /^entfaellt\s*:\s*(.+)$/i) {
        my $grund = $1;
        if (length($grund) < 15) {
            push @ohne_zeile, "$id: 'entfaellt' ohne tragfaehige Begruendung ('$aus')";
        } else {
            push @bewusst_offen, "$id (seit $ein) - $grund";
        }
        next;
    }

    if (defined $aus and $aus =~ /^\d+\.\d+\.\d+$/) {
        push @in_ordnung, sprintf('%-6s eingebaut %-8s ausgewertet %s', $id, $ein, $aus);
        next;
    }

    # Nicht ausgewertet. Solange die Marke in der Fassung sitzt, die gerade
    # gebaut wird, ist das richtig so - sie soll ja erst noch mitlaufen.
    if (zahl($ein) >= zahl($fassung)) {
        push @in_ordnung, sprintf('%-6s eingebaut %-8s laeuft mit dieser Fassung mit', $id, $ein);
        next;
    }

    push @nie_ausgewertet,
        "$id: Marke seit $ein im Bau, jetzt $fassung - nie ausgewertet ($stellen)";
}

for my $id (sort { zahl_id($a) <=> zahl_id($b) } keys %zeile) {
    next if exists $marke{$id};
    push @verwaist, "$id steht in Befunde/SPURMARKEN.md, im Quelltext gibt es dazu keine Marke mehr";
}

sub zahl_id { my ($i) = @_; $i =~ /(\d+)/ ? $1 : 0 }

# --- Bericht ----------------------------------------------------------------

print "\n  Spurmarken und ihre Auswertung (Fassung $fassung)\n";
print '  ' . ('-' x 70) . "\n";
printf "  %-46s %s\n", 'Befunde mit Spurmarken im Quelltext', scalar(keys %marke);
printf "  %-46s %s\n", 'davon ausgewertet oder frisch eingebaut', scalar(@in_ordnung);
printf "  %-46s %s\n", 'davon bewusst offen (entfaellt)', scalar(@bewusst_offen);
printf "  %-46s %s\n", 'davon nie ausgewertet', scalar(@nie_ausgewertet);
print '  ' . ('-' x 70) . "\n";

print "  $_\n" for @in_ordnung;
print "\n  Bewusst offen:\n" if @bewusst_offen;
print "    - $_\n" for @bewusst_offen;

if (@verwaist) {
    print "\n  HINWEIS (weist nicht ab):\n\n";
    print "    - $_\n" for @verwaist;
}

my @mangel = (@ohne_zeile, @nie_ausgewertet);

if (@mangel) {
    print "\n  MANGEL:\n\n";
    print "    - $_\n" for @mangel;
    print "\n  Eine eingebaute Messung, die niemand ausliest, ist keine\n";
    print "  Messung. E-70 hat drei Pakete lang mitgeschrieben, waehrend ich\n";
    print "  die Ursache geraten habe; die Antwort stand die ganze Zeit im\n";
    print "  Protokoll. Also: Protokoll der letzten Fassung auswerten, das\n";
    print "  Ergebnis in Befunde/SPURMARKEN.md eintragen - oder die Marke\n";
    print "  ausbauen. Wer sie bewusst weiterlaufen lassen will, schreibt in\n";
    print "  die Spalte 'ausgewertet':\n\n";
    print "      entfaellt: <warum sie ohne Auswertung mitlaufen soll>\n\n";
    exit 1 unless $nur_melden;
    exit 0;
}

print "\n  Jede Spurmarke ist ausgewertet, frisch eingebaut oder bewusst offen.\n\n";
exit 0;
