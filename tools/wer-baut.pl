#!/usr/bin/perl
use strict;
use warnings;

# wer-baut.pl - nennt zu einer Quelldatei das Projekt der Mappe, das sie baut.
#
# WARUM ES DAS GIBT
#
# Am 13.10.2026 um 11:20 wurde die Behebung E-112 F1 in
# Eudora71/PaigeDLL/PGSOURCE/PGEMBED.C eingebaut (dae6727). Paige32.dll wird
# aber nicht aus dem Quelltext gebaut: PaigeDLL/PAIGE32/Paige32.vcproj steht
# in keiner Projektmappe, die DLL wird fertig uebernommen. Der Bau lief
# fehlerfrei, die Aenderung kam nirgends an. Erst die Messung am laufenden
# Programm (11:38: dasselbe Logo als 70x70 kam weiter als 35x35) zeigte das -
# ein Bau, eine Messung und 18 Minuten spaeter. Ein grep ueber die
# Projektdateien haette es vor dem ersten Handgriff gesagt.
# Lehre: Arbeitsweise/quelle-muss-im-bau-stehen.md
#
# WAS GEPRUEFT WIRD
#
# Fuer jede genannte .c/.cpp/.cxx/.rc-Datei: welches .vcxproj aus
# Eudora71/Eudora.sln (dazu Eudora71/Tests/Tests.vcxproj) fuehrt sie als
# Include="..."? Pfade werden relativ zum Projektverzeichnis aufgeloest,
# Gross-/Kleinschreibung zaehlt nicht (Windows). Header (.h) werden nicht
# geprueft: sie stehen oft in keinem Projekt und kommen ueber #include.
#
# Aufruf:
#   perl tools/wer-baut.pl <datei> [...]   # Rueckgabe 1, wenn eine ungebaut ist
#   perl tools/wer-baut.pl --staged        # vorgemerkte Dateien, nur MELDEN, exit 0
#   perl tools/wer-baut.pl --selbsttest    # Gegenprobe in beide Richtungen
#
# Kodierung: reines ASCII, kein BOM.

use File::Basename qw(dirname);
use File::Spec;

my $wurzel = `git rev-parse --show-toplevel`;
chomp $wurzel;
die "wer-baut.pl: kein git-Arbeitsbaum\n" unless $wurzel;

sub normal {
    my ($p) = @_;
    $p =~ s{\\}{/}g;
    my @teile;
    for my $t (split m{/}, $p) {
        next if $t eq '' or $t eq '.';
        if ($t eq '..') { pop @teile; next; }
        push @teile, $t;
    }
    return lc join('/', @teile);
}

sub projekte {
    my @p;
    my $sln = "$wurzel/Eudora71/Eudora.sln";
    if (open my $fh, '<', $sln) {
        while (<$fh>) {
            push @p, "Eudora71/$1" while /"([^"]+\.vcxproj)"/g;
        }
        close $fh;
    }
    push @p, 'Eudora71/Tests/Tests.vcxproj';
    my %s; return grep { !$s{$_}++ } map { my $x = $_; $x =~ s{\\}{/}g; $x } @p;
}

# Datei (normalisiert) -> [Projekte]
my %gebaut;
my @makefile;
for my $proj (projekte()) {
    open my $fh, '<', "$wurzel/$proj" or next;
    local $/; my $t = <$fh>; close $fh;
    my $dir = dirname($proj);
    if ($t =~ m{<ConfigurationType>Makefile</ConfigurationType>}) {
        # nmake-Projekt (OpenSSL, OT501): was es baut, steht im Makefile,
        # nicht in der Projektdatei. Nur melden, nicht als ungebaut zaehlen.
        push @makefile, [lc(normal($dir)) . "/", $proj];
    }
    while ($t =~ /<(?:ClCompile|ResourceCompile)\s+Include="([^"]+)"/g) {
        my $inc = $1;
        next if $inc =~ /\$\(/;
        push @{ $gebaut{ normal("$dir/$inc") } }, $proj;
    }
}

sub pruefe {
    my ($datei) = @_;
    my $rel = $datei;
    $rel =~ s{\\}{/}g;
    my $w = $wurzel; $w =~ s{\\}{/}g;
    $rel =~ s{^\Q$w\E/}{}i;
    return ('skip', $rel) unless $rel =~ m{^Eudora71/}i and $rel =~ /\.(?:c|cpp|cxx|rc)$/i;
    my $p = $gebaut{ normal($rel) };
    return ('ja', $rel, @$p) if $p;
    for my $m (@makefile) {
        return ('make', $rel, $m->[1]) if index(normal($rel), $m->[0]) == 0;
    }
    return ('nein', $rel);
}

if (@ARGV and $ARGV[0] eq '--selbsttest') {
    my @faelle = (
        ['Eudora71/PaigeDLL/PGSOURCE/PGEMBED.C', 'nein'],   # der echte Fall vom 13.10.
        ['Eudora71/Eudora/PGHTMIMP.CPP',         'ja'],     # die richtige Stelle
        ['Eudora71/Eudora/pghtmimp.cpp',         'ja'],     # Schreibweise egal
        ['Eudora71/Tests/TestE89.cpp',           'ja'],     # Testprojekt zaehlt
        ['Eudora71/Eudora/PgEmbeddedImage.cpp',  'ja'],
        ['Eudora71/OpenSSL/ssl/s3_lib.c',         'make'],   # nmake-Projekt
    );
    my $fehler = 0;
    for my $f (@faelle) {
        my ($ist) = pruefe($f->[0]);
        my $ok = $ist eq $f->[1];
        $fehler++ unless $ok;
        printf "  %-4s %-42s erwartet %-4s ist %s\n", ($ok ? 'ok' : 'FEHL'), $f->[0], $f->[1], $ist;
    }
    print $fehler ? "  selbsttest: $fehler Fehler\n" : "  selbsttest: alle Faelle richtig\n";
    exit($fehler ? 1 : 0);
}

my $nur_melden = 0;
my @dateien;
if (@ARGV and $ARGV[0] eq '--staged') {
    $nur_melden = 1;
    @dateien = grep { length } split /\n/, `git diff --cached --name-only --diff-filter=AM`;
} else {
    @dateien = @ARGV;
}
die "Aufruf: perl tools/wer-baut.pl <datei> [...] | --staged | --selbsttest\n"
    unless @dateien or $nur_melden;

my $ungebaut = 0;
for my $d (@dateien) {
    my ($stand, $rel, @p) = pruefe($d);
    next if $stand eq 'skip' and $nur_melden;
    if    ($stand eq 'skip') { print "  --    $rel (keine .c/.cpp/.rc unter Eudora71/, nicht geprueft)\n"; }
    elsif ($stand eq 'ja')   { print "  ja    $rel <- ", join(', ', @p), "\n" unless $nur_melden; }
    elsif ($stand eq 'make') { print "  make  $rel <- $p[0] (Makefile-Projekt, Inhalt nicht geprueft)
" unless $nur_melden; }
    else {
        $ungebaut++;
        print "  NEIN  $rel steht in KEINEM Projekt der Mappe - eine Aenderung hier wird nicht gebaut.\n";
    }
}
if ($ungebaut) {
    print "        Wer ruft den Code wirklich? Die Behebung gehoert an eine gebaute Stelle\n"
        . "        (Arbeitsweise/quelle-muss-im-bau-stehen.md).\n";
}
exit(($ungebaut and !$nur_melden) ? 1 : 0);
