#!/usr/bin/perl
use strict;
use warnings;

# pruefe-waechter.pl - die Schranke zur Lehre "Teilweise ersetzte Header".
#
# WARUM ES DAS GIBT
#
# Die Lehre Arbeitsweise/teilweise-ersetzte-header.md steht seit dem
# 30.08.2026 im Gedaechtnis. Am 08.09.2026 hat genau dieser Fehler den Befund
# E-43 verursacht - neun Tage lang unentdeckt, weil die Lehre nur Text war.
#
# Der gemessene Fall: OTShim_Werkzeugleiste.h bindet unter
#
#     #ifndef __SBARCORE_H__
#     #include "sbarcore.h"        // OT501-ORIGINAL
#     #endif
#
# den Originalheader ein. Denselben Waechter __SBARCORE_H__ setzt aber
# OTShim.h:984, weil OTShim.h die Klasse SECControlBar ERSETZT. Ob das
# Original gezogen wird, haengt damit allein an der Reihenfolge:
#
#   QCCustomToolBar.cpp    stdafx.h -> OTShimAll.h -> OTShim.h zuerst
#                          => Waechter gesetzt => ERSATZ-SECControlBar
#   OTShim_Werkzeugleiste.cpp  bindet nur den eigenen Header ein
#                          => Waechter NICHT gesetzt => ORIGINAL-SECControlBar
#
# Der Ersatz hat ein Feld mehr als das Original (int m_nRowExtent,
# OTShim.h:533). Damit liegt jedes nachfolgende Feld in den beiden
# Uebersetzungseinheiten an verschiedenen Stellen. Der Binder nimmt eine
# Fassung, die andere liest daneben - gemessen an Gregors eudora.log:
#
#   Versatz=488  GetBtnCount=24/24  m_btns.GetSize=0/0  roh[0..4]=24,25,0,0,0
#
# 24 und 25 sind Anzahl und Kapazitaet des Knopffeldes - acht Byte VOR der
# Stelle, an der der Eudora-Code sie sucht.
#
# DIE REGEL
#
# Bindet eine Datei der Ersatzschicht einen OT501-Originalheader ein, dessen
# Waechter irgendeine Datei der Ersatzschicht SETZT, dann muss sichergestellt
# sein, dass der Waechter zu diesem Zeitpunkt IMMER schon steht. Erlaubt ist
# das nur, wenn
#
#   a) dieselbe Datei den Waechter weiter oben selbst setzt, oder
#   b) die Datei die setzende Ersatzdatei vorher einbindet, oder
#   c) die Datei mit #error abbricht, wenn die setzende Datei fehlt.
#
# Sonst haengt die Klassenaufteilung an der Einbindereihenfolge, und das ist
# ein ODR-Verstoss, den weder Uebersetzer noch Binder melden.
#
# Aufruf:
#   perl tools/pruefe-waechter.pl
#   perl tools/pruefe-waechter.pl --nur-melden    # exit 0, nur Bericht
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

my $nur_melden = 0;
for my $a (@ARGV) {
    if ($a eq '--nur-melden') { $nur_melden = 1; }
    else { die "pruefe-waechter.pl: unbekannter Schalter '$a'\n"; }
}

my $wurzel = '.';
$wurzel = $1 if defined $0 and $0 =~ m{^(.*)/tools/[^/]+$};

my $shim_verz = "$wurzel/Eudora71/OTShim";
my $orig_verz = "$wurzel/Eudora71/OT501/Include";

sub lies {
    my ($p) = @_;
    open my $h, '<:raw', $p or return undef;
    local $/;
    my $d = <$h>;
    close $h;
    return $d;
}

# Kommentare weg, sonst zaehlt die Erklaerung im Kopf als Fund.
# Zeilenkommentare ZUERST - ein /* in einem // wuerde sonst den Rest
# verschlucken. Zeilenzahl bleibt erhalten, weil nur ersetzt wird.
sub ohne_kommentare {
    my ($t) = @_;
    return '' unless defined $t;
    $t =~ s{//[^\n]*}{}g;
    $t =~ s{/\*(.*?)\*/}{ my $x = $1; $x =~ s/[^\n]//g; $x }ges;
    return $t;
}

my @shim = sort glob("$shim_verz/*.h");
unless (@shim) {
    print "\n  pruefe-waechter.pl: keine Header in $shim_verz gefunden.\n\n";
    exit 1;
}

# --- 1. Welche Waechter setzt die Ersatzschicht, und wo? --------------------

my %setzt;   # Waechter -> [ Datei, Zeile ]
for my $datei (@shim) {
    my $rein = ohne_kommentare(lies($datei));
    my @z = split /\n/, $rein, -1;
    for my $i (0 .. $#z) {
        next unless $z[$i] =~ /^\s*#\s*define\s+(__[A-Z0-9_]+_H__)\s*$/;
        my $w = $1;
        # Den eigenen Einbindewaechter nicht mitzaehlen: der steht immer
        # direkt hinter einem #ifndef desselben Namens.
        next if $i > 0 and $z[$i-1] =~ /^\s*#\s*ifndef\s+\Q$w\E\s*$/;
        $setzt{$w} = [ $datei, $i + 1 ] unless exists $setzt{$w};
    }
}

# --- 2. Welche Originalheader bindet die Ersatzschicht ein? -----------------

my @mangel;
my @gesehen;
my $geprueft = 0;

for my $datei (@shim) {
    my $roh  = lies($datei);
    my $rein = ohne_kommentare($roh);
    my @z = split /\n/, $rein, -1;

    # Bindet diese Datei eine andere Ersatzdatei ein? Dann gelten deren
    # Waechter ab dieser Zeile als gesetzt.
    my %ab_zeile;   # Waechter -> ab welcher Zeile dieser Datei gesetzt
    for my $i (0 .. $#z) {
        next unless $z[$i] =~ /^\s*#\s*include\s+"([^"]+)"/;
        my $eingebunden = $1;
        next unless $eingebunden =~ /^OTShim/i;
        my $pfad = "$shim_verz/$eingebunden";
        next unless -f $pfad;
        my $fremd = ohne_kommentare(lies($pfad));
        while ($fremd =~ /^\s*#\s*define\s+(__[A-Z0-9_]+_H__)\s*$/mg) {
            $ab_zeile{$1} = $i + 1 unless exists $ab_zeile{$1};
        }
    }
    # Und die Waechter, die sie selbst setzt.
    for my $i (0 .. $#z) {
        next unless $z[$i] =~ /^\s*#\s*define\s+(__[A-Z0-9_]+_H__)\s*$/;
        $ab_zeile{$1} = $i + 1 if !exists $ab_zeile{$1} or $ab_zeile{$1} > $i + 1;
    }

    # Bricht die Datei ab, wenn eine Ersatzdatei fehlt?
    my %verlangt;
    while ($rein =~ /#\s*if\s+!\s*defined\s*\(\s*(__[A-Z0-9_]+_H__)\s*\)[^\n]*\n\s*#\s*error/g) {
        $verlangt{$1} = 1;
    }
    while ($rein =~ /#\s*ifndef\s+(__[A-Z0-9_]+_H__)\s*\n\s*#\s*error/g) {
        $verlangt{$1} = 1;
    }

    for my $i (0 .. $#z) {
        next unless $z[$i] =~ /^\s*#\s*include\s+"([^"]+)"/;
        my $eingebunden = $1;
        next if $eingebunden =~ /^OTShim/i;
        next unless -f "$orig_verz/$eingebunden";

        $geprueft++;

        # Der Waechter, den dieser Originalheader benutzt.
        my $orein = ohne_kommentare(lies("$orig_verz/$eingebunden"));
        my ($w) = $orein =~ /^\s*#\s*ifndef\s+(__[A-Z0-9_]+_H__)\s*$/m;
        next unless defined $w;

        # Setzt die Ersatzschicht diesen Waechter ueberhaupt? Wenn nicht,
        # wird hier bewusst und dauerhaft das Original benutzt - erlaubt.
        next unless exists $setzt{$w};

        my ($sdatei, $szeile) = @{ $setzt{$w} };
        my $kurz  = $datei;        $kurz  =~ s{^\Q$wurzel\E/}{};
        my $skurz = $sdatei;       $skurz =~ s{^\Q$wurzel\E/}{};

        if ($verlangt{ waechter_von($sdatei) }) {
            push @gesehen, sprintf('%s:%d bindet %s ein - abgesichert per #error',
                                   $kurz, $i + 1, $eingebunden);
            next;
        }
        if (exists $ab_zeile{$w} and $ab_zeile{$w} < $i + 1) {
            push @gesehen, sprintf('%s:%d bindet %s ein - Waechter %s steht ab Zeile %d',
                                   $kurz, $i + 1, $eingebunden, $w, $ab_zeile{$w});
            next;
        }

        push @mangel,
              "$kurz:" . ($i + 1) . " bindet den OT501-Originalheader $eingebunden ein,\n"
            . "      aber $skurz:$szeile setzt dessen Waechter $w - ersetzt also,\n"
            . "      was hier eingebunden wird. Welche Fassung eine Uebersetzungseinheit\n"
            . "      sieht, haengt damit an der Einbindereihenfolge. Das ist ein\n"
            . "      ODR-Verstoss; Uebersetzer und Binder melden ihn nicht (BEFUND E-43).\n"
            . "      Abhilfe: in $kurz VOR dieser Zeile #include \"" . dateiname($sdatei) . "\"\n"
            . "      aufnehmen, oder mit #error abbrechen, wenn dessen Waechter fehlt.";
    }
}

sub dateiname { my ($p) = @_; $p =~ s{^.*/}{}; return $p; }

sub waechter_von {
    my ($p) = @_;
    my $rein = ohne_kommentare(lies($p));
    my ($w) = $rein =~ /^\s*#\s*ifndef\s+(__[A-Z0-9_]+_H__)\s*$/m;
    return defined $w ? $w : '(keiner)';
}

# --- Bericht ---------------------------------------------------------------

print "\n  Include-Waechter der Ersatzschicht (Lehre: teilweise-ersetzte-header)\n";
print '  ' . ('-' x 66) . "\n";
printf "  %-46s %s\n", 'Header der Ersatzschicht', scalar(@shim);
printf "  %-46s %s\n", 'Waechter, die sie setzt', scalar(keys %setzt);
printf "  %-46s %s\n", 'eingebundene OT501-Originale', $geprueft;
print '  ' . ('-' x 66) . "\n";
print "  $_\n" for @gesehen;

if (@mangel) {
    print "\n  MANGEL:\n\n";
    print "    - $_\n\n" for @mangel;
    exit 1 unless $nur_melden;
    exit 0;
}

print "\n  Kein Header haengt an der Einbindereihenfolge.\n\n";
exit 0;
