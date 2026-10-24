#!/usr/bin/perl
# pruefe-befund-anfang.pl - beginnt jede neu geschriebene Befundzeile mit
# ihrem Urteil?
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 23.10.2026 habe ich die Statusspalte einiger Zeilen in Intern/BEFUNDE.md
# mit "**Kurz: ...**" begonnen, damit Gregor sie versteht. Die Werkzeuge
# (offene-befunde.pl, pruefe-regressionstest.pl, pruefe-behoben-belegt.pl)
# lesen aber genau das ERSTE Fettgedruckte als Urteil. Folge, gemessen von
# LEKTOR-54 (L-54.1): E-142 und E-144 - beide am selben Abend von Gregor am
# Programm bestaetigt - fielen still aus den Listen der offenen Befunde, und
# offene-befunde.pl meldete trotzdem "in beiden Listen gleich". E-130 ging
# auf "behoben", ohne dass die Regressionsschranke es sah (L-54.2).
#
# Gregor am 23.10.2026: "stelle sicher, dass neu geschriebene ziele nicht
# uebersehen werden. also fang mit 'behoben in...' oder offen, ja".
#
# ---------------------------------------------------------------------------
# WAS GEPRUEFT WIRD
# ---------------------------------------------------------------------------
#
# Jede Befundzeile, die in diesem Commit NEU ist oder deren Statusspalte
# sich am Anfang geaendert hat, muss mit einem fetten Urteil beginnen:
# **offen ...**, **behoben ...**, **erledigt ...** und die Formen, die der
# Bestand schon kennt (siehe @ERLAUBT). Alte Zeilen, die niemand anfasst,
# bleiben in Ruhe - sie zu pruefen hiesse, heute 40 Zeilen umzuschreiben,
# bevor irgendetwas committet werden kann.
#
#   perl tools/pruefe-befund-anfang.pl              gestagte Aenderungen
#   perl tools/pruefe-befund-anfang.pl --bestand    alle Zeilen, meldet nur
#   perl tools/pruefe-befund-anfang.pl --selbsttest Faelle in beide Richtungen
#
# Rueckgabe: 0 = in Ordnung, 1 = Mangel, 2 = Aufrufproblem.

use strict;
use warnings;

my $DATEI = 'Intern/BEFUNDE.md';

# Erste Woerter, die ein Urteil sind. Ausgezaehlt am 24.10.2026 am Bestand:
# behoben 113, offen 31, ueberholt 5, teilweise 5, kein (eigener Fehler) 4,
# erledigt 3, bestaetigt 3, beobachtet 2, widerlegt 2. Klein geschrieben
# verglichen; Umlaute als UTF-8.
my @ERLAUBT = (
    'offen', 'wieder offen', 'behoben', 'erledigt', 'teilweise',
    "best\xc3\xa4tigt", 'bestaetigt', 'eingebaut', 'beobachtet', 'widerlegt',
    "zur\xc3\xbcckgestellt", 'zurueckgestellt', "\xc3\xbcberholt", 'ueberholt',
    'kein eigener fehler',
);

sub urteil_am_anfang {
    # Liefert (kennung, ok, anfang) fuer eine Tabellenzeile, sonst ().
    my ($zeile) = @_;
    return () unless $zeile =~ /^\|\s*<a id="[^"]+"><\/a>(\S+)\s*\|/;
    my $kennung = $1;
    # Spalten trennen; "\|" ist ein maskierter Strich im Text.
    (my $t = $zeile) =~ s/\\\|/\x00/g;
    my @sp = split /\|/, $t, -1;
    return () unless @sp >= 4;
    my $status = $sp[3];
    $status =~ s/\x00/\\|/g;
    $status =~ s/^\s+//;
    my $anfang = substr($status, 0, 60);
    return ($kennung, 0, $anfang) unless $status =~ /^\*\*(.{1,40})/;
    my $fett = lc $1;
    for my $w (@ERLAUBT) {
        return ($kennung, 1, $anfang) if index($fett, $w) == 0;
    }
    # Grossschreibung "BEHOBEN IN" / "BESTAETIGT" - lc deckt ASCII, nicht
    # das grosse UE/AE; die stehen im Bestand nur als "BESTÄTIGT".
    return ($kennung, 1, $anfang) if $status =~ /^\*\*BEST\xc3\x84TIGT/;
    return ($kennung, 0, $anfang);
}

sub selbsttest {
    my @f = (
        ['Kurzform zuerst - der Fall vom 23.10.2026',
         '| <a id="e-144"></a>E-144 | **Titel** | **Kurz: Ein Entwurf verliert ...** **Von Gregor bestaetigt** |', 0],
        ['Urteil zuerst, dann Kurzform',
         '| <a id="e-144"></a>E-144 | **Titel** | **offen, von Gregor bestaetigt.** **Kurz: ...** |', 1],
        ['behoben in',
         '| <a id="e-116"></a>E-116 | **Titel** | **behoben in 7.2.0.123**, Testsuite 280/280 |', 1],
        ['GROSS: BEHOBEN IN',
         '| <a id="e-103"></a>E-103 | **Titel** | **BEHOBEN IN 7.2.0.85 zusammen mit E-112** |', 1],
        ["GROSS mit Umlaut: BEST\xc3\x84TIGT",
         "| <a id=\"e-95\"></a>E-95 | **Titel** | **BEST\xc3\x84TIGT von Gregor** |", 1],
        ['ohne Fettdruck am Anfang',
         '| <a id="e-1"></a>E-1 | **Titel** | Beleg: siehe unten **behoben** |', 0],
        ['maskierter Strich im Titel verschiebt keine Spalte',
         '| <a id="e-9"></a>E-9 | **a \| b** | **offen, am Quelltext belegt** |', 1],
        ['anderes Fettwort zuerst',
         '| <a id="e-123"></a>E-123 | **Titel** | **Der Beenden-Weg ist bestaetigt** |', 0],
    );
    my $fehl = 0;
    print "\n  pruefe-befund-anfang --selbsttest\n";
    for my $c (@f) {
        my ($name, $z, $soll) = @$c;
        my (undef, $ok) = urteil_am_anfang($z);
        my $gut = (($ok // -1) == $soll);
        $fehl++ unless $gut;
        printf "    %-4s %s\n", ($gut ? 'ok' : 'FEHL'), $name;
    }
    printf "\n    %d von %d Faellen bestanden.\n\n", @f - $fehl, scalar @f;
    return $fehl ? 1 : 0;
}

if (@ARGV and $ARGV[0] eq '--selbsttest') { exit selbsttest(); }

my $bestand = (@ARGV and $ARGV[0] eq '--bestand');
if (@ARGV and !$bestand) {
    print "  Aufruf: pruefe-befund-anfang.pl [--bestand | --selbsttest]\n";
    exit 2;
}

my (@pruefen, %alt_anfang);
if ($bestand) {
    open my $h, '<:raw', $DATEI or do { print "  $DATEI nicht gefunden\n"; exit 2 };
    @pruefen = grep { /^\|\s*<a id=/ } map { s/\r?\n$//r } <$h>;
} else {
    my @aus = `git diff --cached --unified=0 -- $DATEI 2>&1`;
    for my $z (@aus) {
        if ($z =~ /^-(\|\s*<a id=.*)$/) {
            my ($k, $ok, $anf) = urteil_am_anfang($1);
            $alt_anfang{$k} = $anf if defined $k;
        } elsif ($z =~ /^\+(\|\s*<a id=.*?)\r?$/) {
            push @pruefen, $1;
        }
    }
}

my @mangel;
for my $z (@pruefen) {
    my ($k, $ok, $anf) = urteil_am_anfang($z);
    next unless defined $k;
    next if $ok;
    # Unveraenderter Anfang einer alten Zeile: nicht neu geschrieben.
    next if !$bestand and defined $alt_anfang{$k} and $alt_anfang{$k} eq $anf;
    push @mangel, [$k, $anf];
}

print "  ------------------------------------------------------------\n";
print "  pruefe-befund-anfang: beginnt jede Befundzeile mit dem Urteil?\n";
print "  ------------------------------------------------------------\n";
printf "    Betriebsart          %s\n", $bestand ? 'Bestand (meldet nur)' : 'gestaget';
printf "    gepruefte Zeilen     %d\n", scalar @pruefen;
printf "    ohne Urteil vorn     %d\n", scalar @mangel;
if (!@mangel) {
    print "\n  Jede gepruefte Befundzeile beginnt mit ihrem Urteil.\n\n";
    exit 0;
}
print "\n  MANGEL:\n" unless $bestand;
printf "    - %-8s beginnt mit: %s\n", $_->[0], $_->[1] for @mangel;
print <<'ENDE';

  Die Statusspalte beginnt mit dem fetten Urteil: **offen, ...**,
  **behoben in 7.2.0.NNN, ...** oder **erledigt, ...** - erst DANACH der
  Kurzsatz fuer Gregor und die Herleitung. Die Werkzeuge lesen das erste
  Fettgedruckte; am 23.10.2026 fielen E-142 und E-144 so still aus den
  Listen der offenen Befunde (LEKTOR-54, L-54.1). Regel: Intern/BEFUNDE.md,
  Abschnitt "Wie eine Befundzeile beginnt".

ENDE
exit($bestand ? 0 : 1);
