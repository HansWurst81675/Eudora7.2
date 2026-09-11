#!/usr/bin/perl
use strict;
use warnings;

# offene-befunde.pl - die Liste der offenen Befunde aus BEFUNDE.md erzeugen
# und in WEITERMACHEN.md setzen.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 11.09.2026, nachdem ich ihm die offenen Punkte im Chat
# aufgezaehlt hatte:
#
#   "mir ging es darum, wo das alles an einer stelle steht"
#
# Und davor: "welche aufgaben sind noch mir zugewiesen und noch nicht
# erledigt?" - eine Frage, die KEINE Datei direkt beantwortet hat. Die Liste
# musste ich mir aus BEFUNDE.md zusammenrechnen; im Chat steht sie jetzt und
# ist morgen weg.
#
# EINE VON HAND GEFUEHRTE LISTE WAERE DER FALSCHE WEG. Am selben Tag hat sich
# dreimal gezeigt, wohin das fuehrt: AUFGABEN.md nannte vier wartende
# Behebungen, von denen drei laengst bestaetigt waren; die Lehrentabelle
# fuehrte 27 von 56; tools/RELEASES.md kannte ein Release von elf. Deshalb
# wird diese Liste ERZEUGT.
#
# ---------------------------------------------------------------------------
# WAS ES TUT
# ---------------------------------------------------------------------------
#
# Es liest die Urteile aus BEFUNDE.md - dieselbe Quelle und dieselbe Regel
# wie pruefe-befundurteile.pl: die dritte Spalte, darin das erste
# Fettgedruckte - und setzt daraus die Tabelle zwischen zwei Marken in
# WEITERMACHEN.md.
#
# Die Spalte "was als Naechstes zu tun ist" kann kein Skript erzeugen; sie
# bleibt Handarbeit und steht in WEITERMACHEN.md. Was das Werkzeug
# sicherstellt: dass KEIN offener Befund fehlt und KEIN erledigter darin
# steht. Ohne Schalter prueft es nur und weist ab.
#
#   perl tools/offene-befunde.pl             pruefen, Rueckgabe 1 bei Abweichung
#   perl tools/offene-befunde.pl -schreiben  Tabelle neu setzen
#
# Rueckgabe: 0 = deckungsgleich, 1 = Abweichung, 2 = Aufrufproblem.

my $schreiben = grep { $_ eq '-schreiben' } @ARGV;

my $wurzel = -f 'VERSION' ? '.' : '..';
my $quelle = "$wurzel/BEFUNDE.md";
my $ziel   = "$wurzel/WEITERMACHEN.md";

unless (-f $quelle and -f $ziel) {
    print "  offene-befunde: BEFUNDE.md oder WEITERMACHEN.md nicht gefunden -\n";
    print "  bitte aus dem Wurzelverzeichnis aufrufen.\n";
    exit 2;
}

sub lies {
    my ($d) = @_;
    open my $h, '<:raw', $d or return undef;
    local $/;
    my $t = <$h>;
    close $h;
    return $t;
}

# --- Die Urteile aus BEFUNDE.md -------------------------------------------
# Dieselbe Regel wie pruefe-befundurteile.pl: dritte Spalte, erstes
# Fettgedrucktes. Wer sie hier anders liest, bekommt zwei Wahrheiten.
my @offen_wort = ('offen', 'in arbeit', 'zurueckgestellt', "zur\xc3\xbcckgestellt");
my @erledigt_wort = ('behoben', 'kein eigener fehler', 'erledigt', 'nicht mehr auf', 'widerlegt');

my $befunde = lies($quelle);
my (@offene, %beschreibung);

for my $zeile (split /\n/, $befunde) {
    next unless $zeile =~ /^\|\s*\**\s*(E-\d+)\s*\**\s*\|/;
    my $k = $1;
    next if exists $beschreibung{$k};      # erste Zeile gewinnt

    my @s = split /\|/, $zeile, -1;
    next unless @s >= 4;

    my $urteil = $s[3];
    my ($fett) = $urteil =~ /\*\*([^*]{1,60})\*\*/;
    next unless defined $fett;
    my $w = lc $fett;

    # "behoben" schlaegt "offen" - eine Zeile "behoben ... war offen"
    # beschreibt einen erledigten Befund.
    next if grep { index($w, $_) >= 0 } @erledigt_wort;
    next unless grep { index($w, $_) >= 0 } @offen_wort;

    # Die Kurzbeschreibung ist die zweite Spalte, ohne Auszeichnung.
    my $b = $s[2];
    $b =~ s/\*\*//g;
    $b =~ s/`//g;
    $b =~ s/^\s+|\s+$//g;
    $b =~ s/\s+/ /g;
    $b = substr($b, 0, 90) . '…' if length($b) > 90;

    push @offene, $k;
    $beschreibung{$k} = $b;
}

unless (@offene) {
    print "  offene-befunde: BEFUNDE.md fuehrt keinen offenen Befund.\n";
    exit 2;
}

# Nach Nummer sortieren, die juengsten zuerst - was zuletzt gefunden wurde,
# ist meist das, was als Naechstes drankommt.
@offene = sort { my ($x) = $a =~ /(\d+)/; my ($y) = $b =~ /(\d+)/; $y <=> $x } @offene;

my $soll = '';
for my $k (@offene) {
    $soll .= "| **$k** | $beschreibung{$k} |\n";
}

# --- Gegen WEITERMACHEN.md halten -----------------------------------------
my $t = lies($ziel);
my $anfang = '<!-- offene-befunde: Anfang -->';
my $ende   = '<!-- offene-befunde: Ende -->';

unless ($t =~ /\Q$anfang\E(.*?)\Q$ende\E/s) {
    if ($schreiben) {
        print "  offene-befunde: die Marken fehlen in WEITERMACHEN.md.\n";
        print "  Bitte einmal von Hand einsetzen:\n\n";
        print "    $anfang\n    | Kennung | worum es geht |\n    |---|---|\n    $ende\n\n";
        exit 2;
    }
    print "\n  offene-befunde: WEITERMACHEN.md hat keinen erzeugten Abschnitt.\n";
    print "  Einmal einsetzen, dann haelt das Werkzeug ihn aktuell.\n\n";
    exit 1;
}

my $ist = $1;
my %im_ist;
while ($ist =~ /\*\*(E-\d+)\*\*/g) { $im_ist{$1} = 1; }

my @fehlen = grep { not $im_ist{$_} } @offene;
my @zuviel = grep { my $n = $_; not grep { $_ eq $n } @offene } sort keys %im_ist;

print "\n  ------------------------------------------------------------\n";
print "  offene-befunde\n";
print "  ------------------------------------------------------------\n";
printf "    offen laut BEFUNDE.md      %2d\n", scalar @offene;
printf "    in WEITERMACHEN.md         %2d\n", scalar keys %im_ist;

if (not @fehlen and not @zuviel) {
    print "\n  Die Liste deckt die offenen Befunde.\n\n";
    exit 0;
}

printf "\n  FEHLEN (%d): %s\n", scalar @fehlen, join(', ', @fehlen) if @fehlen;
printf "\n  ZU VIEL (%d, laut BEFUNDE.md erledigt): %s\n",
       scalar @zuviel, join(', ', @zuviel) if @zuviel;

unless ($schreiben) {
    print <<'ENDE';

  Gregor am 11.09.2026: "mir ging es darum, wo das alles an einer
  stelle steht". Eine Liste, die von Hand gepflegt wird, steht
  spaetestens nach dem naechsten behobenen Befund falsch da.

  Neu setzen mit:   perl tools/offene-befunde.pl -schreiben

ENDE
    exit 1;
}

my $neu = "$anfang\n\n| Kennung | worum es geht |\n|---|---|\n$soll\n$ende";
$t =~ s/\Q$anfang\E.*?\Q$ende\E/$neu/s;

my $c0 = () = lies($ziel) =~ /\r\n/g;
my $c  = () = $t =~ /\r\n/g;
if ($c != $c0) { printf "  ABBRUCH - CRLF %d statt %d\n", $c, $c0; exit 1; }

open my $o, '>:raw', $ziel or die "$ziel: $!\n";
print $o $t;
close $o;
printf "\n  Tabelle neu gesetzt: %d offene Befunde.\n\n", scalar @offene;
exit 0;
