#!/usr/bin/perl
# startzeilen-sammeln.pl - fehlende Startzeilen aus anderen Arbeitsbaeumen und
# Zweigen in die eigene tools/TESTLAEUFE.md uebernehmen (nur ergaenzen).
#
# Warum: pruefe-startwege.pl weist einen Commit ab, sobald irgendein Eudora-Start
# unter C:\Temp keine Zeile in TESTLAEUFE.md hat - auch wenn ein ANDERER Agent
# ihn in seinem Arbeitsbaum schon protokolliert hat. Am 02.11.2026 hielt das acht
# Commits auf (PRUEFER-82, LEKTOR-125, PRUEFER-85, LEKTOR-132, CHRONIST, LEKTOR-133,
# PRUEFER-87, e203); jedes Mal wurde von Hand ein Perl-Einzeiler gebaut.
#
# Aufruf:  perl tools/startzeilen-sammeln.pl [--tage N] [--nur-zeigen]
#   (aus dem Wurzelverzeichnis des Baums; der Pfad tools/TESTLAEUFE.md ist relativ)
#   Quellen: tools/TESTLAEUFE.md jedes Arbeitsbaums aus `git worktree list`
#            und jedes origin-Zweigs mit einem Commit in den letzten N Tagen (Vorgabe 2).
#   Uebernommen werden nur Tabellenzeilen "| JJJJ-MM-TT hh:mm:ss | ...", die hier
#   fehlen. Exakt gleiche Zeilen nie. Eine Zeile mit derselben Zeit und demselben
#   Verzeichnis wie eine vorhandene, aber anderem Text (anderswo berichtigt oder
#   noch unberichtigt) wird NICHT uebernommen, sondern gemeldet.
#   Die uebernommenen Zeilen werden nach Datum und Uhrzeit zwischen die
#   vorhandenen einsortiert (vor die erste spaetere); vorhandene Zeilen bleiben,
#   wo sie sind - nichts wird entfernt oder umgestellt. Danach wird gezaehlt:
#   alte Zeilen in alter Reihenfolge plus die neuen, sonst wird nicht geschrieben.
#   Zeilenenden der Zieldatei bleiben (LF).
#
# PRUEFER-88 K6 (02.11.2026): vorher wurde unsortiert ans Ende gehaengt - jeder
# Zweig hing einen anderen Block an, und beim Zusammenfuehren gab es Konflikte am
# Dateiende; und origin/HEAD heisst bei refname:short "origin", der Ausschluss
# griff nie.
#
# GRENZE: pruefe-startwege.pl deckt einen Start mit IRGENDEINER Zeile im Fenster
# von +-600 s, ohne aufs Verzeichnis zu sehen. Fremde Zeilen im eigenen Protokoll
# decken deshalb auch einen eigenen Start ohne Zeile, wenn beide in dieselben zehn
# Minuten fallen. Nur benutzen, wenn pruefe-startwege.pl abweist - und die eigenen
# Starts kommen weiter ueber testlauf.ps1 ins Protokoll.
use strict; use warnings;

my $tage = 2; my $nurzeigen = 0;
while (@ARGV) { my $a = shift; if ($a eq '--tage') { $tage = shift } elsif ($a eq '--nur-zeigen') { $nurzeigen = 1 } else { die "unbekannt: $a\n" } }

my $ziel = 'tools/TESTLAEUFE.md';
open my $f, '<:raw', $ziel or die "$ziel: $!\n";
my @eigen = <$f>; close $f;
my %da = map { (my $z = $_) =~ s/\r?\n\z//; ($z => 1) } @eigen;
sub schluessel { my ($z) = @_; return $z =~ /^\| (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d) \| ([^|]*)\|/ ? "$1|$2" : undef }
my %schl;
for (@eigen) { (my $z = $_) =~ s/\r?\n\z//; my $k = schluessel($z); $schl{$k} = $z if defined $k }

my (@neu, %quelle, @abweichend);
sub aufnehmen {
    my ($text, $woher) = @_;
    for my $z (split /\r?\n/, $text) {
        next unless $z =~ /^\| \d{4}-\d\d-\d\d /;
        next if $da{$z};
        my $k = schluessel($z);
        if (defined $k && exists $schl{$k}) {
            push @abweichend, "$woher: $z" unless $schl{$k} eq $z;
            next;
        }
        $da{$z} = 1; $schl{$k} = $z if defined $k;
        push @neu, $z; $quelle{$woher}++;
    }
}

for my $zeile (split /\n/, `git worktree list --porcelain`) {
    next unless $zeile =~ /^worktree (.+)$/;
    my $p = "$1/$ziel";
    next unless -f $p;
    open my $g, '<:raw', $p or next; local $/; my $t = <$g>; close $g;
    aufnehmen($t, "Baum $1");
}
my $seit = time - $tage * 86400;
for my $z (split /\n/, `git for-each-ref --format="%(committerdate:unix) %(refname:short)" refs/remotes/origin`) {
    my ($zeit, $ref) = split / /, $z, 2;
    # refname:short nennt origin/HEAD schlicht "origin" (gemessen, PRUEFER-88 K6)
    next unless $zeit && $zeit >= $seit && $ref ne 'origin/HEAD' && $ref ne 'origin';
    my $t = `git show "$ref:$ziel" 2>/dev/null`;
    aufnehmen($t, "Zweig $ref") if defined $t && length $t;
}

printf "  %-40s %d\n", $_, $quelle{$_} for sort keys %quelle;
if (@abweichend) {
    print "  NICHT uebernommen - gleiche Zeit und gleiches Verzeichnis, anderer Text:\n";
    print "    $_\n" for @abweichend;
}
printf "startzeilen-sammeln: %d Zeile(n) fehlen hier%s\n", scalar(@neu), $nurzeigen ? ' (nur gezeigt)' : '';
exit 0 if $nurzeigen || !@neu;

# Einsortieren: jede neue Zeile vor die erste vorhandene Datenzeile mit spaeterer
# Zeit; gibt es keine, hinter die letzte Datenzeile.
sub zeit { my ($z) = @_; return $z =~ /^\| (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d) / ? $1 : undef }
my @aus = map { my $z = $_; $z =~ s/\r?\n\z//; { z => $z, alt => 1 } } @eigen;
my $letzte = -1;
for my $i (0 .. $#aus) { $letzte = $i if defined zeit($aus[$i]{z}) }
for my $n (sort { zeit($a) cmp zeit($b) } @neu) {
    my $t = zeit($n);
    my $pos;
    for my $i (0 .. $#aus) {
        my $ti = zeit($aus[$i]{z});
        if (defined $ti && $ti gt $t) { $pos = $i; last }
    }
    if (!defined $pos) { $letzte = -1; for my $i (0 .. $#aus) { $letzte = $i if defined zeit($aus[$i]{z}) } $pos = $letzte + 1 }
    splice @aus, $pos, 0, { z => $n, alt => 0 };
}
# Zaehlen: die alten Zeilen in alter Reihenfolge, plus genau die neuen
my @altWieder = map { $_->{z} } grep { $_->{alt} } @aus;
my @altVorher = map { (my $z = $_) =~ s/\r?\n\z//; $z } @eigen;
die "startzeilen-sammeln: Reihenfolge der vorhandenen Zeilen waere veraendert - nichts geschrieben\n"
    unless "@altWieder" eq "@altVorher" && @aus == @eigen + @neu;
open my $o, '>:raw', $ziel or die "$ziel: $!\n";
print $o map { "$_->{z}\n" } @aus;
close $o;
print "  einsortiert in $ziel (" . scalar(@eigen) . " + " . scalar(@neu) . " Zeilen) - mitstagen: git add $ziel\n";
