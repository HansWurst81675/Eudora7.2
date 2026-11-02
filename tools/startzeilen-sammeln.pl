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
#   Quellen: tools/TESTLAEUFE.md jedes Arbeitsbaums aus `git worktree list`
#            und jedes origin-Zweigs mit einem Commit in den letzten N Tagen (Vorgabe 2).
#   Uebernommen werden nur Tabellenzeilen "| JJJJ-MM-TT ...", die hier fehlen;
#   nichts wird entfernt oder umgestellt. Zeilenenden der Zieldatei bleiben (LF).
use strict; use warnings;

my $tage = 2; my $nurzeigen = 0;
while (@ARGV) { my $a = shift; if ($a eq '--tage') { $tage = shift } elsif ($a eq '--nur-zeigen') { $nurzeigen = 1 } else { die "unbekannt: $a\n" } }

my $ziel = 'tools/TESTLAEUFE.md';
open my $f, '<:raw', $ziel or die "$ziel: $!\n";
my @eigen = <$f>; close $f;
my %da = map { (my $z = $_) =~ s/\r?\n\z//; ($z => 1) } @eigen;

my (@neu, %quelle);
sub aufnehmen {
    my ($text, $woher) = @_;
    for my $z (split /\r?\n/, $text) {
        next unless $z =~ /^\| \d{4}-\d\d-\d\d /;
        next if $da{$z}++;
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
    next unless $zeit && $zeit >= $seit && $ref ne 'origin/HEAD';
    my $t = `git show "$ref:$ziel" 2>/dev/null`;
    aufnehmen($t, "Zweig $ref") if defined $t && length $t;
}

printf "  %-40s %d\n", $_, $quelle{$_} for sort keys %quelle;
printf "startzeilen-sammeln: %d Zeile(n) fehlen hier%s\n", scalar(@neu), $nurzeigen ? ' (nur gezeigt)' : '';
exit 0 if $nurzeigen || !@neu;
my $nl = (@eigen && $eigen[-1] =~ /\n\z/) ? '' : "\n";
open my $o, '>>:raw', $ziel or die "$ziel: $!\n";
print $o $nl, map { "$_\n" } @neu;
close $o;
print "  angehaengt an $ziel - mitstagen: git add $ziel\n";
