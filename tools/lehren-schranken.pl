#!/usr/bin/perl
use strict;
use warnings;

# lehren-schranken.pl - jede Lehre braucht eine Schranke, die greift.
#
# WARUM ES DAS GIBT
#
# Gregor am 08.09.2026: "mach dir aus lessons leared alles schranken, die dann
# greifen." Davor: "du fällst immer wieder ins gleiche muster, obwohl mir das
# jedes mal mehrfach geklärt und ausgemacht haben."
#
# Der Befund dahinter ist gemessen und nicht angenehm: es liegen 50 Lehren in
# Arbeitsweise/, und ich habe gegen mehrere davon am Tag nach ihrer Entstehung
# wieder verstossen. Eine Lehre ist Text; Text wird nicht gelesen, wenn es
# eilig ist. Eine Schranke wird ausgefuehrt.
#
# WAS DIESES WERKZEUG PRUEFT
#
# Jede Lehre in Arbeitsweise/ muss genau eine Zeile tragen, die sagt, WAS sie
# durchsetzt und WANN:
#
#   Schranke: tools/pruefe-bytes.pl (pre-commit, pre-push)
#   Schranke: keine - <Begruendung, warum sie sich nicht pruefen laesst>
#
# Geprueft wird dreierlei:
#   1. Die Zeile ist da.
#   2. Das genannte Werkzeug existiert wirklich.
#   3. Es haengt am genannten Ausloeser - also in tools/hooks-einrichten.sh,
#      wenn der Ausloeser pre-commit oder pre-push ist.
#
# "keine" ist erlaubt, aber nur mit Begruendung. Damit ist die Luecke
# sichtbar und zaehlbar, statt vergessen: das Werkzeug nennt am Ende, wieviele
# Lehren ohne Schranke auskommen und warum.
#
# Aufruf:
#   perl tools/lehren-schranken.pl                # prueft, weist ab
#   perl tools/lehren-schranken.pl --nur-melden   # exit 0, nur Bericht
#   perl tools/lehren-schranken.pl --offen        # nur die ohne Schranke
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

my $nur_melden = 0;
my $nur_offen  = 0;
for my $a (@ARGV) {
    if    ($a eq '--nur-melden') { $nur_melden = 1; }
    elsif ($a eq '--offen')      { $nur_offen = 1; }
    else { die "lehren-schranken.pl: unbekannter Schalter '$a'\n"; }
}

my $wurzel = '.';
$wurzel = $1 if defined $0 and $0 =~ m{^(.*)/tools/[^/]+$};

sub lies {
    my ($p) = @_;
    open my $h, '<:raw', $p or return undef;
    local $/;
    my $d = <$h>;
    close $h;
    return $d;
}

# --- Die Lehren einsammeln --------------------------------------------------

my @lehren = sort glob("$wurzel/Arbeitsweise/*.md");

# Drei Dateien in Arbeitsweise/ sind KEINE Lehren und brauchen deshalb auch
# keine Schranke-Zeile:
#   MEMORY.md               das Verzeichnis der Lehren, eine Zeile je Lehre
#   README.md               erklaert, was dieses Verzeichnis ist
#   LEHREN-AUS-DEM-CHAT.md  die Rohauswertung, aus der Lehren erst entstehen
#
# Bis zum 08.09.2026 stand hier nur MEMORY.md. Die beiden anderen wurden
# mitgezaehlt und als Mangel gemeldet - und eine Schranke, die umsonst warnt,
# wird ignoriert (Befund X-1).
my %keine_lehre = map { $_ => 1 } qw(MEMORY.md README.md LEHREN-AUS-DEM-CHAT.md);
@lehren = grep { my $n = $_; $n =~ s{^.*/}{}; !$keine_lehre{$n} } @lehren;

if (!@lehren) {
    print "\n  lehren-schranken.pl: keine Lehren in Arbeitsweise/ gefunden.\n";
    print "  Das ist selbst ein Mangel - dort gehoeren sie hin.\n\n";
    exit 1;
}

my $haken = lies("$wurzel/tools/hooks-einrichten.sh");
$haken = '' unless defined $haken;

my (@ohne_zeile, @werkzeug_fehlt, @nicht_verdrahtet, @ohne_schranke, @mit);

for my $datei (@lehren) {
    my $inhalt = lies($datei);
    unless (defined $inhalt) { push @ohne_zeile, "$datei (nicht lesbar)"; next; }

    my $kurz = $datei;
    $kurz =~ s{^\Q$wurzel\E/}{};

    # Die Zeile suchen. Fett, kursiv und Listenpunkt sind erlaubt.
    # Der Doppelpunkt steht mal INNERHALB der Fettschrift ("**Schranke:**"),
    # mal davor ("**Schranke**:"). Beides kommt im Verzeichnis vor. Am
    # 09.09.2026 hat die alte Fassung "**Schranke:** keine - ..." als
    # "** keine - ..." gelesen und die Begruendung deshalb verworfen: der
    # keine-Zweig prueft auf /^keine/, und davor standen zwei Sterne.
    my ($zeile) = $inhalt =~ /^[\s>*\-]*\**Schranke\**\s*:\**\s*([^\n]+)$/m;

    unless (defined $zeile) {
        push @ohne_zeile, $kurz;
        next;
    }
    $zeile =~ s/\s+$//;

    # Gedankenstriche in BYTES, nicht als Zeichen. Gelesen wird mit
    # <:raw, ein Gedankenstrich ist also die Bytefolge e2 80 94 (bzw. 93 fuer
    # den kurzen) und NICHT \x{2014}. Am 09.09.2026 hat die alte Fassung
    # deshalb "keine - <Begruendung>" mit Gedankenstrich nicht als
    # Begruendung erkannt und eine tragfaehige Ausnahme abgewiesen. Dieselbe
    # Klasse wie in doku-pruefen.pl: eine Musterpruefung, die auf einer
    # anderen Kodierungsebene sucht als die Datei liegt.
    $zeile =~ s/\xe2\x80[\x93\x94]/-/g;

    if ($zeile =~ /^keine\b/i) {
        my ($grund) = $zeile =~ /^keine\s*[-\x{2014}:]\s*(.+)$/i;
        if (!defined $grund or length($grund) < 15) {
            push @ohne_zeile, "$kurz (Schranke 'keine' ohne tragfaehige Begruendung: '$zeile')";
        } else {
            push @ohne_schranke, "$kurz - $grund";
        }
        next;
    }

    # Werkzeug und Ausloeser herausloesen.
    my ($werkzeug) = $zeile =~ m{((?:tools|Arbeitsweise)/[\w.\-]+)};
    my ($ausloeser) = $zeile =~ /\(([^)]*)\)/;

    unless (defined $werkzeug) {
        push @ohne_zeile, "$kurz (Schranke nennt kein Werkzeug unter tools/: '$zeile')";
        next;
    }

    unless (-e "$wurzel/$werkzeug") {
        push @werkzeug_fehlt, "$kurz nennt $werkzeug - die Datei gibt es nicht";
        next;
    }

    # Am Ausloeser verdrahtet?
    if (defined $ausloeser and $ausloeser =~ /pre-(?:commit|push)/) {
        my $q = quotemeta $werkzeug;
        unless ($haken =~ /$q/) {
            push @nicht_verdrahtet,
                 "$kurz nennt $werkzeug ($ausloeser) - es steht aber nicht in "
               . 'tools/hooks-einrichten.sh und laeuft damit nie von selbst';
            next;
        }
    }

    push @mit, sprintf('%-46s %s', $kurz, $zeile);
}

# --- Bericht ---------------------------------------------------------------

if ($nur_offen) {
    print "\n  Lehren ohne Schranke (" . scalar(@ohne_schranke) . " von "
        . scalar(@lehren) . "):\n";
    print '  ' . ('-' x 70) . "\n";
    print "  $_\n" for @ohne_schranke;
    if (@ohne_zeile) {
        print "\n  Lehren ohne Schranke-Zeile (" . scalar(@ohne_zeile) . "):\n";
        print "  $_\n" for @ohne_zeile;
    }
    print "\n";
    exit 0;
}

print "\n  Lehren und ihre Schranken\n";
print '  ' . ('-' x 70) . "\n";
printf "  %-46s %s\n", 'Lehren in Arbeitsweise/', scalar(@lehren);
printf "  %-46s %s\n", 'davon mit greifender Schranke', scalar(@mit);
printf "  %-46s %s\n", 'davon mit begruendeter Ausnahme', scalar(@ohne_schranke);
print '  ' . ('-' x 70) . "\n";

my @mangel = (@ohne_zeile, @werkzeug_fehlt, @nicht_verdrahtet);

if (@mangel) {
    print "\n  MANGEL:\n\n";
    print "    - $_\n" for @mangel;
    print "\n  Jede Lehre braucht eine Zeile in dieser Form:\n\n";
    print "      Schranke: tools/pruefe-bytes.pl (pre-commit, pre-push)\n";
    print "      Schranke: keine - <warum sie sich nicht mechanisch pruefen laesst>\n\n";
    print "  Warum das abweist: Gregor am 08.09.2026 - \"mach dir aus lessons\n";
    print "  leared alles schranken, die dann greifen.\" Eine Lehre ohne\n";
    print "  Ausloeser wirkt nicht; sie braucht einen Moment, in dem sie\n";
    print "  geprueft wird.\n\n";
    exit 1 unless $nur_melden;
    exit 0;
}

print "\n  Jede Lehre hat ihre Schranke oder eine begruendete Ausnahme.\n\n";
exit 0;
