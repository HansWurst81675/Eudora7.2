#!/usr/bin/perl
#
# Erzeugt Eudora71/Eudora/BuildKennung.h mit der Kennung des aktuellen Baus.
#
#   perl tools/kennung-erzeugen.pl
#
# Wird vor jedem Bau von Eudora.exe aufgerufen (PreBuildEvent in
# Eudora71/Eudora/Eudora.vcxproj). Die Kennung landet in der Titelleiste des
# Hauptfensters.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 30.08.2026 meldete Gregor, die Menues haetten "kurzfristig funktioniert" -
# konnte aber nicht sagen, in welchem Bau, weil die Eudora.exe keine Kennung
# trug. Damit war die Beobachtung wertlos: es liess sich nicht feststellen,
# welche Aenderung das Verhalten umgeworfen hat.
#
# Genau derselbe Fehler war zwei Tage zuvor schon bei der QCSSL.dll passiert -
# zwei verschiedene Binaerdateien mit derselben Kennung "1.0.0". Dafuer gibt es
# seitdem Releases/1.0/AUSLIEFERUNGEN.md und tools/release-pruefen.pl. Fuer die
# ausfuehrbare Datei selbst wurde es versaeumt. Das holt dieses Werkzeug nach.
#
# Die Kennung besteht aus:
#   - der Paketversion aus der Datei VERSION im Wurzelverzeichnis
#   - dem Commit, auf dem der Bau steht (kurz)
#   - einem Pluszeichen, falls das Arbeitsverzeichnis Aenderungen enthaelt,
#     die noch nicht committet sind - dann ist der Bau NICHT reproduzierbar
#   - dem Zeitpunkt des Baus
#
# Beispiel:  1.0.3+31810e2* 2026-08-30 20:37
#            Das Sternchen sagt: es lagen uncommittete Aenderungen vor.
#
use strict;
use warnings;

my $wurzel = $ARGV[0] || '.';
chdir $wurzel or die "Kann nicht nach $wurzel wechseln: $!\n";

# --- Paketversion -------------------------------------------------------------

my $version = 'unbekannt';
if (open(my $v, '<', 'VERSION')) {
    my $z = <$v>;
    close $v;
    chomp $z if defined $z;
    $z =~ s/\s+//g if defined $z;
    $version = $z if defined $z and length $z;
}

# --- Commit und Sauberkeit ----------------------------------------------------

my $commit = `git rev-parse --short HEAD 2>/dev/null`;
chomp $commit;
$commit = 'ohne-git' unless length $commit;

my $schmutzig = `git status --porcelain 2>/dev/null`;
# Unverfolgte Dateien zaehlen nicht - die landen nicht im Bau.
# BuildKennung.h zaehlt ebenfalls nicht: sie wird von diesem Werkzeug selbst
# geschrieben. Sonst waere die Marke instabil - nach einem Commit ist der Baum
# sauber, der naechste Bau schriebe die Datei ohne Sternchen neu, damit waere
# der Baum wieder schmutzig, und der uebernaechste Bau setzte das Sternchen
# wieder. Die Kennung wuerde bei jedem Bau zwischen zwei Werten springen.
my @geaendert = grep { !/^\?\?/ and !/BuildKennung\.h$/ }
                grep { length }
                split /\n/, ($schmutzig || '');
my $marke = @geaendert ? '*' : '';

# --- Zeitpunkt ----------------------------------------------------------------

my @t = localtime();
my $zeit = sprintf("%04d-%02d-%02d %02d:%02d",
                   $t[5] + 1900, $t[4] + 1, $t[3], $t[2], $t[1]);

my $kennung = "$version+$commit$marke $zeit";

# --- Schreiben ----------------------------------------------------------------
#
# Nur schreiben, wenn sich etwas geaendert hat. Sonst wird die Datei bei jedem
# Bau neu angefasst und zieht eine Neuuebersetzung aller Dateien nach sich, die
# sie einbinden.

my $ziel = 'Eudora71/Eudora/BuildKennung.h';

my $neu = <<"ENDE";
// BuildKennung.h - ERZEUGT, NICHT VON HAND AENDERN
//
// Wird vor jedem Bau von tools/kennung-erzeugen.pl neu geschrieben
// (PreBuildEvent in Eudora.vcxproj). Die Kennung steht in der Titelleiste des
// Hauptfensters, damit ein Bildschirmfoto eindeutig einem Bau zuzuordnen ist.
//
// Ein Sternchen hinter dem Commit heisst: beim Bau lagen Aenderungen vor, die
// noch nicht committet waren. Ein solcher Bau ist nicht reproduzierbar.

#ifndef __BUILDKENNUNG_H__
#define __BUILDKENNUNG_H__

#define EUDORA_BAU_KENNUNG "$kennung"

#endif // __BUILDKENNUNG_H__
ENDE

my $alt = '';
if (open(my $a, '<:raw', $ziel)) { local $/; $alt = <$a>; close $a; $alt = '' unless defined $alt; }

# Nur der Zeitstempel unterscheidet sich bei sonst gleichem Stand - dann nicht
# neu schreiben, sonst uebersetzt jeder Bau alles neu.
(my $alt_ohne_zeit = $alt) =~ s/\d{4}-\d{2}-\d{2} \d{2}:\d{2}//;
(my $neu_ohne_zeit = $neu) =~ s/\d{4}-\d{2}-\d{2} \d{2}:\d{2}//;

if ($alt_ohne_zeit eq $neu_ohne_zeit) {
    print "kennung-erzeugen: unveraendert ($kennung)\n";
    exit 0;
}

open(my $o, '>:raw', $ziel) or die "Kann $ziel nicht schreiben: $!\n";
print $o $neu;
close $o;

print "kennung-erzeugen: $kennung\n";
exit 0;
