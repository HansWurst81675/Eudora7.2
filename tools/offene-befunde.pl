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
my @offen_wort = ('offen', 'in arbeit', 'zurueckgestellt', "zur\xc3\xbcckgestellt", 'teilweise');
my @erledigt_wort = ('behoben', 'kein eigener fehler', 'erledigt', 'nicht mehr auf', 'widerlegt',
                     'ueberholt', "\xc3\xbcberholt");

# KENNUNGEN ALLER FAMILIEN (LEKTOR-16, L-16.1, 12.10.2026). Bis dahin stand
# hier E-\d+. BEFUNDE.md fuehrt aber auch AN-, NP-, P-, A-, R- ... - das
# Werkzeug meldete "16 offen, Liste deckt" und sah AN-1 und AN-2 gar nicht,
# ausgerechnet die beiden Befunde, an denen an dem Tag gearbeitet wurde.
# Die Schranke aus CLAUDE.md Schritt 1 war damit fuer jeden Nicht-E-Befund
# blind. Unterkennungen wie B-2.2 bleiben aussen vor: das sind Zeilen in
# Messtabellen, keine Befunde.
my $kennung = qr/[A-Z]{1,3}\d?-\d+[a-z]?/;

my $befunde = lies($quelle);
my (@offene, %beschreibung, %gesehen);

for my $zeile (split /\n/, $befunde) {
    next unless $zeile =~ /^\|\s*\**\s*($kennung)\s*\**\s*\|/;
    my $k = $1;

    my @s = split /\|/, $zeile, -1;
    next unless @s >= 4;

    # Erste Zeile gewinnt - und zwar die erste Zeile UEBERHAUPT. Bis zum
    # 12.10.2026 galt das nur fuer schon angenommene Zeilen: eine erste
    # Zeile OHNE Urteilswort liess die naechste Zeile derselben Kennung
    # zum Zug kommen, und die steht meist in einer Teiltabelle weit unten.
    # A-1 zum Beispiel steht oben in der Uebersicht mit "teilweise"
    # (BEFUNDE.md:147) und unten mit "heute ueberholt" (:5020) - gelten
    # soll die Uebersicht. (LEKTOR-21 hat den ersten Wortlaut dieses
    # Kommentars berichtigt: er hatte oben und unten vertauscht.)
    next if $gesehen{$k}++;

    my $urteil = $s[3];
    # KEINE Laengengrenze. Bis zum 15.09.2026 stand hier {1,60}, und das war
    # eine stille Luecke: E-90 ("gemessene Grenze, kein Fehler dieser Fassung
    # - zurueckgestellt.", 62 Zeichen) und E-92 ("beobachtet, unsere Seite
    # NICHT gemessen - Kosmetik, zurueckgestellt.", 67 Zeichen) fielen aus der
    # Zaehlung, ohne dass irgendetwas meldete. Das Werkzeug sagte "Die Liste
    # deckt die offenen Befunde" und meinte 9, wo 11 stehen. Gegengetestet:
    # ohne Grenze kommen genau E-90 und E-92 dazu, kein behobener Befund.
    my ($fett) = $urteil =~ /\*\*([^*]+?)\*\*/;
    next unless defined $fett;
    my $w = lc $fett;

    # "behoben" schlaegt "offen" - eine Zeile "behoben ... war offen"
    # beschreibt einen erledigten Befund. AUSSER "wieder offen": E-112 steht
    # als "WIEDER OFFEN. ... widerlegt" da, und bis zum 12.10.2026 fiel er
    # deshalb aus der Liste (LEKTOR-16, L-16.1).
    # Ebenso "teilweise": AN-1 steht als "teilweise behoben - ... B5.7 offen"
    # da, und "behoben" haette ihn hinausgeworfen. Teilweise erledigt ist
    # nicht erledigt.
    my $wieder = index($w, 'wieder offen') >= 0 || index($w, 'teilweise') >= 0;
    next if !$wieder and grep { index($w, $_) >= 0 } @erledigt_wort;
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
# Die laufende Nummer ist die LETZTE Zahl: bei NP3-1 ist es die 1, nicht die 3.
@offene = sort { my ($x) = $a =~ /(\d+)[a-z]?$/; my ($y) = $b =~ /(\d+)[a-z]?$/; $y <=> $x or $a cmp $b } @offene;

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
while ($ist =~ /\*\*($kennung)\*\*/g) { $im_ist{$1} = 1; }

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
