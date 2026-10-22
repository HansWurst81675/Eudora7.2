#!/usr/bin/perl
use strict;
use warnings;

# pruefe-rueckstrich.pl - kein Windows-Pfad ohne Rueckstrich in einer .md
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Arbeitsweise/text-nicht-durch-schichten-schicken.md zaehlt bis zum
# 14.10.2026 achtzehn Faelle, in denen ein Rueckstrich auf dem Weg durch
# Bash, Perl oder PowerShell verloren ging. Drei Beispiele aus der Doku:
#
#   C:\Temp\AN5          ->  C:TempAN5         (12.10.2026, im Commit)
#   C:\Temp\E94-nachher  ->  C:Temp94-nachher  (13.10.2026, im TESTPLAN)
#   C:\Temp\E105         ->  C:Temp105         (14.10.2026, WEITERMACHEN
#                                                und PAKETE, vor dem Commit
#                                                von Hand gefunden)
#
# In einem Perl-String in doppelten Anfuehrungszeichen ist \E das Ende einer
# Gross-/Kleinschreibungs-Umschaltung und verschwindet, \T wird zu T, \U und
# \L schalten die Schreibung um ("C:\Users\Gregor\AppData\Local" wird zu
# "C:SERSGREGORAPPDATAocal..."). Perl warnt dabei ("Unrecognized escape
# \T", "Useless use of \E") - am 14.10.2026 wurde genau diese Warnung im
# naechsten Aufruf mit grep -v weggefiltert.
#
# Die Lehre hat seit dem 13.10.2026 als "Offen" vermerkt: eine
# pre-commit-Pruefung auf HINZUGEFUEGTE Zeilen. Das ist sie.
#
# ---------------------------------------------------------------------------
# WAS GEPRUEFT WIRD
# ---------------------------------------------------------------------------
#
#   1. Laufwerksbuchstabe, Doppelpunkt, dann sofort ein Buchstabe oder eine
#      Ziffer: C:Temp105, C:SERSGREGOR. Ein echter Pfad hat dort \ oder /.
#   2. ein woertliches \x5c - das ist ein Escape, das nicht gedeutet wurde
#      (13.10.2026: printf '%s' deutet nichts, also auch kein \x5c).
#
# Nur der ZUWACHS in *.md (git diff --cached). Im Bestand steht der Fehler
# nur in den Zeilen, die ihn beschreiben.
#
# Ausgenommen (dort wird der Fehler absichtlich zitiert):
#   - Arbeitsweise/  (die Lehren selbst)
#   - Befunde/LEKTOR-*, Befunde/PRUEFER-*, Befunde/CHRONIST-*  (Berichte)
#   - fuer Regel 1 jede Zeile mit dem Wort "laufwerksrelativ" - C:Ordner
#     OHNE Rueckstrich ist unter Windows ein gueltiger, relativer Pfad, und
#     Intern/BEFUNDE.md beschreibt genau so einen Fehler (C:Mailverzeichnis).
#
# Aufruf:
#   perl tools/pruefe-rueckstrich.pl              gestagete Zeilen (pre-commit)
#   perl tools/pruefe-rueckstrich.pl --commit X   Zuwachs eines Commits (Gegenprobe)
#   perl tools/pruefe-rueckstrich.pl --selbsttest Faelle in beide Richtungen
#
# Rueckgabe 0 = sauber, 1 = Maengel.

my $BS = chr(92);    # der Rueckstrich, ohne dass er im Quelltext steht

sub ausgenommen {
    my ($datei) = @_;
    return 1 if $datei =~ m{^Arbeitsweise/};
    return 1 if $datei =~ m{^Befunde/(?:LEKTOR|PRUEFER|CHRONIST)-};
    return 0;
}

# Liefert die Maengel einer Zeile als Liste von Texten.
sub pruefe_zeile {
    my ($datei, $z) = @_;
    return () if ausgenommen($datei);
    my @m;
    unless ($z =~ /laufwerksrelativ/i) {
        while ($z =~ /(?:^|[\s`"'(\[|*=])([A-Z]:[A-Za-z0-9][^\s`"')|]*)/g) {
            push @m, "Laufwerk ohne Rueckstrich: $1";
        }
    }
    my $x5c = $BS . 'x5c';
    if (index($z, $x5c) >= 0) {
        push @m, "woertliches ${x5c} (ein Escape, das niemand gedeutet hat)";
    }
    return @m;
}

# Zuwachs aus einer diff-Ausgabe: (datei, zeile) Paare.
sub zuwachs {
    my ($diff) = @_;
    my @paare;
    my $datei = '';
    for my $z (split /\n/, $diff) {
        if ($z =~ m{^\+\+\+ b/(.*)$}) { $datei = $1; next; }
        next if $z =~ /^\+\+\+/;
        if ($z =~ /^\+(.*)$/) {
            my $inhalt = $1;
            $inhalt =~ s/\r$//;
            push @paare, [$datei, $inhalt] if $datei =~ /\.md$/i;
        }
    }
    return @paare;
}

sub selbsttest {
    my @melden = (
        ['Intern/WEITERMACHEN.md',    'Messverzeichnis `C:Temp105`'],
        ['Intern/WEITERMACHEN.md',    'Pfad `C:TempAN5` im Messlauf'],
        ['Intern/TESTPLAN.md',        'Verzeichnis C:Temp94-nachher anlegen'],
        ['README.md',          '$fotoDir = "C:SERSGREGORAPPDATAocaltemp"'],
        ['Intern/BEFUNDE.md',         'liegt in `spool' . $BS . 'x5clmos.dat`'],
        ['Releases/PAKETE.md', '| Testverzeichnis | C:Temp |'],
    );
    my @still = (
        ['Intern/WEITERMACHEN.md',      'Messverzeichnis `C:' . $BS . 'Temp' . $BS . 'E105`'],
        ['README.md',            'unter C:/Users/Gregor/Documents'],
        ['Intern/BEFUNDE.md',           '`C:Mailverzeichnis` ist laufwerksrelativ, nicht absolut'],
        ['Arbeitsweise/x.md',    'stand `C:Temp105` in WEITERMACHEN'],
        ['Befunde/LEKTOR-33.md', 'Fund: `C:Temp105` in PAKETE.md'],
        ['README.md',            'Teil C: Bilder beim Antworten'],
        ['README.md',            'Bildserver auf http://127.0.0.1:8080/bild'],
        ['README.md',            'Stand: 14.10.2026, Zeit 06:10:43'],
        ['README.md',            'Langpfad `' . $BS x 2 . '?' . $BS . 'C:' . $BS . 'Temp`'],
        ['README.md',            'Kopfzeile `Content-Type: text/html`'],
    );
    my $fehler = 0;
    for my $f (@melden) {
        my @m = pruefe_zeile(@$f);
        if (@m) { print "  [ok ] meldet:  $f->[0]: $f->[1]\n"; }
        else    { print "  [ROT] STUMM:   $f->[0]: $f->[1]\n"; $fehler++; }
    }
    for my $f (@still) {
        my @m = pruefe_zeile(@$f);
        if (!@m) { print "  [ok ] still:   $f->[0]: $f->[1]\n"; }
        else     { print "  [ROT] FEHLALARM: $f->[0]: $f->[1] -> $m[0]\n"; $fehler++; }
    }
    my $n = @melden + @still;
    print "  pruefe-rueckstrich --selbsttest: $n Faelle, $fehler falsch\n";
    return $fehler ? 1 : 0;
}

my $modus = shift(@ARGV) // '';
exit selbsttest() if $modus eq '--selbsttest';

my $diff;
if ($modus eq '--commit') {
    my $rev = shift(@ARGV) // die "Aufruf: $0 --commit <rev>\n";
    $diff = `git show -U0 --no-color --format= $rev -- "*.md"`;
} else {
    $diff = `git diff --cached -U0 --no-color --diff-filter=AM -- "*.md"`;
}
$diff = '' unless defined $diff;

my @maengel;
for my $p (zuwachs($diff)) {
    my ($datei, $z) = @$p;
    for my $m (pruefe_zeile($datei, $z)) {
        my $kurz = length($z) > 120 ? substr($z, 0, 117) . '...' : $z;
        push @maengel, "  $datei: $m\n      $kurz\n";
    }
}

if (@maengel) {
    print "pruefe-rueckstrich: Windows-Pfad ohne Rueckstrich im Zuwachs:\n";
    print @maengel;
    print "  Ursache fast immer: Pfad in einem Perl-String in doppelten\n";
    print "  Anfuehrungszeichen (\\T, \\E, \\U, \\L werden gedeutet) oder ein\n";
    print "  Hier-Dokument/printf mit \\x5c. Abhilfe: Text mit dem Edit- oder\n";
    print "  Write-Werkzeug schreiben (Arbeitsweise/text-nicht-durch-schichten-schicken.md).\n";
    exit 1;
}
exit 0;
