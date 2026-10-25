#!/usr/bin/perl
# schranken-gegenprobe.pl - weist eine Quelltext-Schranke ab, wenn die
# Behebung zurueckgenommen wird?
#
# ---------------------------------------------------------------------------
# WARUM ES DAS GIBT
# ---------------------------------------------------------------------------
#
# Am 24.10.2026 zaehlte tools/pruefe-regressionstest.pl 50 kritische Befunde
# "OHNE jede Pruefung". Fuer mehrere davon gab es aber laengst eine Schranke
# im pre-commit, die den Quelltext bewacht (Beenden, Nachrichtenschleifen,
# GetButton, Include-Waechter). Gezaehlt wurden sie nicht - und vier der
# sechs hatten keine eingebaute Gegenprobe. Eine Schranke, von der niemand
# gezeigt hat, dass sie beim Rueckfall abweist, ist kein Regressionstest
# (Arbeitsweise/schranke-gegentesten.md).
#
# Dieses Werkzeug nimmt je Fall eine Behebung VORUEBERGEHEND zurueck (eine
# woertliche Ersetzung, genau ein Treffer), faehrt die Schranke, stellt die
# Datei BYTE-GENAU wieder her und prueft das an der Pruefsumme. Erwartet:
# vorher Rueckgabe 0, mit Rueckfall ungleich 0, danach wieder 0.
#
# Die Faelle stehen in tools/regression-schranken.txt. Nur was dort steht und
# hier rot wird, zaehlt pruefe-regressionstest.pl als Regressionstest.
#
#   perl tools/schranken-gegenprobe.pl            alle Faelle
#   perl tools/schranken-gegenprobe.pl E-42       nur diese Kennung
#
# Rueckgabe: 0 = jede Schranke weist den Rueckfall ab, 1 = mindestens eine
# nicht, 2 = Aufrufproblem (Datei fehlt, Ersetzung trifft nicht genau einmal,
# Wiederherstellung misslungen).

use strict;
use warnings;
use Digest::SHA qw(sha1_hex);
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use File::Spec;

my $wurzel = abs_path(dirname(abs_path($0)) . '/..');
chdir $wurzel or die "$wurzel: $!\n";
my $nur = shift @ARGV;

sub lies { my $f = shift; open my $h, '<:raw', $f or return undef; local $/; my $t = <$h>; close $h; return $t }
sub schreib { my ($f, $t) = @_; open my $h, '>:raw', $f or die "$f: $!\n"; print $h $t; close $h }

# Schranke fahren, Ausgabe verwerfen, Rueckgabewert liefern. Mit Liste statt
# Zeichenkette: keine Shell dazwischen, die Umleitungen deuten muesste.
sub schranke {
    my $s = shift;
    open(my $alt_out, '>&', \*STDOUT) or die; open(my $alt_err, '>&', \*STDERR) or die;
    open(STDOUT, '>', File::Spec->devnull) or die; open(STDERR, '>', File::Spec->devnull) or die;
    my $rc = system($^X, "tools/$s") >> 8;
    open(STDOUT, '>&', $alt_out) or die; open(STDERR, '>&', $alt_err) or die;
    return $rc;
}

# Format: Kennung | Schranke | Datei | Rueckfall alt ==> neu
# "\t" in alt/neu steht fuer einen Tabulator.
my $liste = lies('tools/regression-schranken.txt');
die "tools/regression-schranken.txt fehlt\n" unless defined $liste;

my ($ok, $fehl, $kaputt) = (0, 0, 0);
print "  ------------------------------------------------------------\n";
print "  schranken-gegenprobe: weist die Schranke den Rueckfall ab?\n";
print "  ------------------------------------------------------------\n";
for my $z (split /\n/, $liste) {
    $z =~ s/\r$//;
    next if $z =~ /^\s*(#|$)/;
    my ($k, $schranke, $datei, $rueck) = map { s/^\s+|\s+$//gr } split /\|/, $z, 4;
    next if defined $nur and $k !~ /^\Q$nur\E\b/;
    my ($alt, $neu) = split /\s*==>\s*/, $rueck // '', 2;
    unless (defined $neu and -f $datei and -f "tools/$schranke") {
        printf "    [????] %-6s Zeile unvollstaendig oder Datei fehlt: %s\n", $k, $z; $kaputt++; next;
    }
    s/\\t/\t/g for $alt, $neu;
    s/\\n/\n/g for $alt, $neu;
    my $vorher = lies($datei);
    my $sha = sha1_hex($vorher);
    my $treffer = () = $vorher =~ /\Q$alt\E/g;
    if ($treffer != 1) {
        printf "    [????] %-6s Rueckfall trifft %d-mal statt einmal in %s\n", $k, $treffer, $datei; $kaputt++; next;
    }
    my $rc0 = schranke($schranke);
    (my $mutiert = $vorher) =~ s/\Q$alt\E/$neu/;
    schreib($datei, $mutiert);
    my $rc1 = schranke($schranke);
    schreib($datei, $vorher);
    my $zurueck = sha1_hex(lies($datei));
    if ($zurueck ne $sha) {
        printf "    [!!!!] %-6s %s NICHT byte-gleich wiederhergestellt - sofort pruefen!\n", $k, $datei;
        exit 2;
    }
    my $rc2 = schranke($schranke);
    # Nur Rueckgabe 1 ist eine Abweisung. Bis zum 25.10.2026 galt jeder Wert
    # ungleich 0 - auch 2 (Aufruffehler) oder ein Perl-Abbruch; eine Schranke,
    # die am Rueckfall abstuerzt, sah aus wie eine, die ihn findet
    # (PRUEFER-50 K12).
    my $gut = ($rc0 == 0 && $rc1 == 1 && $rc2 == 0);
    $gut ? $ok++ : $fehl++;
    printf "    [%s] %-6s %-34s vorher=%d rueckfall=%d danach=%d\n",
        ($gut ? ' ok ' : 'FEHL'), $k, $schranke, $rc0, $rc1, $rc2;
}
print "  ------------------------------------------------------------\n";
printf "  Ergebnis: %d Faelle, %d weisen den Rueckfall ab, %d nicht, %d unbrauchbar\n",
    $ok + $fehl + $kaputt, $ok, $fehl, $kaputt;
exit($kaputt ? 2 : ($fehl ? 1 : 0));
