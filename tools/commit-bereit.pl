#!/usr/bin/perl
use strict;
use warnings;

# commit-bereit.pl - alle Schranken des pre-commit (und auf Wunsch des
# pre-push) auf EINMAL, mit einer Mangelliste.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 13.10.2026 hat der pre-commit beim Versionssprung auf 7.2.0.85 fuenf
# Commit-Versuche in zwei Minuten abgewiesen (08:57:39 bis 08:59:39 UTC),
# jedes Mal wegen eines ANDEREN Mangels: Stand-Zeile AUFGABEN/PAKETE, dann
# Testplan-Kopf (dreimal), dann der fehlende Abschnitt 1.0.85 in PAKETE.md.
# Eine Viertelstunde vorher dasselbe auf `mailadressen-raus`: E-103 als
# "behoben", fehlender Link, Zweig nicht in ZWEIGE.md, wieder ein Link -
# vier Anlaeufe. Gregor in derselben Viertelstunde: "viel bla, bla, wenig
# fortschritt".
#
# Die Ursache ist dieselbe wie am 13.09.2026 bei paket-bauen.ps1 (siehe
# tools/paket-bereit.pl): der Haken faehrt seine Schranken nacheinander mit
# "|| exit $?" und steigt bei der ERSTEN aus. Wer fuenf Maengel hat, braucht
# fuenf Anlaeufe. paket-bereit.pl hat das fuer das Paket geloest, fuer den
# Commit gab es nichts Gleiches.
#
# ---------------------------------------------------------------------------
# WIE ES SICH MIT DEM HAKEN EINIG HAELT
# ---------------------------------------------------------------------------
#
# Die Liste wird aus tools/hooks-einrichten.sh GELESEN, nicht danebengelegt
# (Arbeitsweise/pruefumfang-nicht-von-hand.md): jede Zeile "schranke X.pl"
# im Block des pre-commit (bzw. pre-push), dazu die beiden Sonderfaelle mit
# eigenem Aufruf (pruefe-branch.pl --streng, release-pruefen.pl mit
# Rueckgabe 3 = Hinweis).
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/commit-bereit.pl          pre-commit-Schranken, Liste am Ende
#   perl tools/commit-bereit.pl -push    zusaetzlich die des pre-push
#                                        (ohne pruefe-testbau.pl, das baut)
#   perl tools/commit-bereit.pl -knapp   nur die Mangelliste
#
# Vor dem ERSTEN Commit-Versuch aufrufen, wenn sich VERSION, Version.h,
# BEFUNDE.md-Urteile oder ein Zweig geaendert haben.
#
# Rueckgabe: 0 = alle frei, 1 = mindestens eine weist ab, 2 = Aufrufproblem.

my $knapp = grep { $_ eq '-knapp' } @ARGV;
my $push  = grep { $_ eq '-push' }  @ARGV;

my $wurzel = -f 'VERSION' ? '.' : '..';
my $haken  = "$wurzel/tools/hooks-einrichten.sh";
unless (-f $haken) {
    print "  commit-bereit: tools/hooks-einrichten.sh nicht gefunden - bitte aus\n";
    print "  dem Wurzelverzeichnis aufrufen.\n";
    exit 2;
}

open my $h, '<:raw', $haken or die "$haken: $!\n";
my $sh = do { local $/; <$h> };
close $h;

sub block {
    my ($marke) = @_;
    return $1 if $sh =~ /<<'\Q$marke\E'\n(.*?)\n\Q$marke\E\n/s;
    return undef;
}

my @teile = (['pre-commit', block('HOOKENDE')]);
push @teile, ['pre-push', block('HOOKPUSHENDE')] if $push;

my (@liste, %schon);
for my $t (@teile) {
    my ($name, $text) = @$t;
    unless (defined $text) {
        print "  commit-bereit: Block des $name in hooks-einrichten.sh nicht gefunden.\n";
        exit 2;
    }
    for my $z (split /\n/, $text) {
        next if $z =~ /^\s*#/;
        my ($werk, @arg);
        if ($z =~ /^\s*schranke\s+(\S+\.pl)\b/) {
            $werk = $1;
        } elsif ($z =~ m{perl\s+"\$WURZEL/tools/(pruefe-branch\.pl)"\s+(--\S+)\s*\|\|\s*exit}) {
            ($werk, @arg) = ($1, $2);
        } elsif ($z =~ m{^\s*perl\s+"\$WURZEL/tools/(release-pruefen\.pl)"\s*$}) {
            $werk = $1;
        } else {
            next;
        }
        next if $werk eq 'pruefe-testbau.pl';    # baut die Testsuite, 18 s
        my $schluessel = join ' ', $werk, @arg;
        next if $schon{$schluessel}++;
        push @liste, [$name, $werk, @arg];
    }
}

my (@mangel, @hinweis, $gefahren);
for my $e (@liste) {
    my ($teil, $werk, @arg) = @$e;
    my $pfad = "$wurzel/tools/$werk";
    unless (-f $pfad) {
        push @hinweis, "$werk fehlt in diesem Arbeitsbaum (uebersprungen)";
        next;
    }
    my $aus = qx{perl "$pfad" @arg 2>&1};
    my $rc  = $? >> 8;
    $gefahren++;
    my $abweisend = $werk eq 'release-pruefen.pl' ? ($rc != 0 && $rc != 3) : ($rc != 0);
    if ($abweisend) {
        my @z = grep { /\S/ } split /\n/, $aus;
        my @kern = grep { /MANGEL|ABGEWIESEN|^\s*-\s|nennt|fehlt|kein Link/i } @z;
        @kern = @z[-3 .. -1] if !@kern && @z >= 3;
        @kern = @z if !@kern;
        @kern = @kern[0 .. 7] if @kern > 8;
        push @mangel, [$teil, $werk, $rc, @kern];
    }
    print "  [", ($abweisend ? 'ROT' : 'ok '), "] $teil  $werk @arg\n" unless $knapp;
}

# --- Kennt der INSTALLIERTE Haken diese Schranken ueberhaupt? --------------
#
# Hier und nicht im Haken selbst: ein veralteter Haken kann die Pruefung, die
# ihn veraltet nennt, nicht enthalten. Dieses Werkzeug liest seine Liste aus
# dem Quelltext und ist deshalb der richtige Ort
# (Arbeitsweise/schranke-teilt-nicht-die-annahme.md).
#
# Am 21.10.2026 fehlten dem installierten pre-commit VIER Schranken; der
# Bericht desselben Tages hatte von Hand nach DREIEN gesucht und genau die
# drei gefunden (Arbeitsweise/pruefumfang-nicht-von-hand.md).
{
    my $w = "$wurzel/tools/pruefe-haken-aktuell.pl";
    if (-f $w) {
        my $aus = qx{perl "$w" --knapp 2>&1};
        my $rc  = $? >> 8;
        if ($rc == 1) {
            for my $z (split /\n/, $aus) {
                next unless $z =~ /kennt \d+ Schranke/;
                $z =~ s/^\s*-\s*//;
                $z =~ s/^\s+//;
                $z =~ s/\s+$//;
                push @hinweis, "der INSTALLIERTE Haken ist nicht auf dem Stand - $z"
                             . "  (einrichten: sh tools/hooks-einrichten.sh)";
            }
        }
    }
}

print "\n" unless $knapp;
print "  Hinweis: $_\n" for @hinweis;
if (!@mangel) {
    printf "  commit-bereit: %d Schranken gefahren, keine weist ab.\n", $gefahren // 0;
    exit 0;
}
printf "  commit-bereit: %d von %d Schranken weisen ab - alle auf einmal:\n\n",
    scalar @mangel, $gefahren;
for my $m (@mangel) {
    my ($teil, $werk, $rc, @kern) = @$m;
    print "  $werk ($teil, Rueckgabe $rc)\n";
    print "      $_\n" for @kern;
    print "\n";
}
exit 1;
