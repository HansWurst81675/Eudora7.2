#!/usr/bin/perl
# pruefe-namen-gestaget.pl - kein Name aus Gregors lokaler Namensliste in
# einer hinzugefuegten Zeile, in JEDER Datei des Repos.
#
#   perl tools/pruefe-namen-gestaget.pl                # gestagte Zeilen (pre-commit)
#   perl tools/pruefe-namen-gestaget.pl --seit-main    # alle Commits origin/main..HEAD (pre-push)
#   perl tools/pruefe-namen-gestaget.pl --commit <rev> # ein Commit (Gegenprobe)
#   perl tools/pruefe-namen-gestaget.pl --selbsttest
#
# WARUM ES DAS GIBT. Am 05.11.2026 schrieb ein Agent zwei Familiennamen aus
# Gregors lokaler Namensliste als Suchmuster in tools/pruefstand-vorlage-
# erfassen.ps1 (Commit vom 05.11.2026, umgeschrieben, Zweig e151_pruefstand_klon, gepusht ins
# oeffentliche Repo). Die einzige Namensschranke, pruefe-testdaten-anonym.pl,
# prueft nur Testdaten/ - fuer tools/ war sie blind. Gefunden hat es PRUEFER-104
# einen Tag spaeter. Gregor am 06.11.2026: "haben wir es nicht schon
# ausgemacht, dass sowas nicht passieren soll? warum also doch? wer hat
# gepennt?" (Lehre: Arbeitsweise/gedaechtnis-ist-oeffentlich.md).
#
# WAS ES PRUEFT. Die Muster aus tools/anonym-begriffe.lokal (nie im Repo,
# .gitignore; Zeile: <Regex><TAB><Klartext>), gesucht wird im Hauptbaum und im
# eigenen Arbeitsbaum. Ausgenommen ist das Muster "Vorname des Anwenders" -
# der Vorname steht mit Gregors Zustimmung in tausenden Zeilen. Geprueft
# werden nur HINZUGEFUEGTE Zeilen, damit der Altbestand (QUALCOMM-Originale)
# nicht jeden Commit abweist. Ausgegeben werden Datei, Zeile und der
# Klartext der Liste - nie der Name selbst.
#
# Fehlt die Liste (fremder Klon), meldet das Werkzeug "ungeprueft" und laesst
# durch: dort gibt es Gregors Namen nicht zu schuetzen.
#
# Rueckgabe: 0 frei oder ungeprueft, 1 Treffer, 2 Aufrufproblem.
# Kodierung: reines ASCII.
use strict;
use warnings;

my $modus = 'gestaget'; my $rev;
for (my $i = 0; $i < @ARGV; $i++) {
    if    ($ARGV[$i] eq '--seit-main')  { $modus = 'seit-main'; }
    elsif ($ARGV[$i] eq '--commit')     { $modus = 'commit'; $rev = $ARGV[++$i]; }
    elsif ($ARGV[$i] eq '--selbsttest') { $modus = 'selbsttest'; }
    else { print "  pruefe-namen-gestaget: unbekannt: $ARGV[$i]\n"; exit 2; }
}

sub liste_finden {
    my @orte = ('tools/anonym-begriffe.lokal');
    my $common = `git rev-parse --git-common-dir 2>/dev/null`; chomp $common;
    if ($common ne '') { (my $haupt = $common) =~ s{[\\/]\.git$}{}; push @orte, "$haupt/tools/anonym-begriffe.lokal"; }
    for my $o (@orte) { return $o if -f $o; }
    return undef;
}

sub muster_laden {
    my ($datei) = @_;
    open my $h, '<:raw', $datei or return ();
    my @m;
    while (my $z = <$h>) {
        $z =~ s/\r?\n$//;
        next if $z =~ /^\s*(#|$)/;
        my ($p, $was) = split /\t/, $z, 2;
        $was = 'Begriff aus der lokalen Liste' unless defined $was && length $was;
        next if $was =~ /^Vorname des Anwenders/i;
        push @m, [ qr/$p/i, $was, $p ];
    }
    close $h;
    return @m;
}

# Liest einen Diff (-U0) und liefert [datei, zeile, text] je hinzugefuegter Zeile.
sub hinzugefuegt {
    my ($diff) = @_;
    my @z; my ($f, $n);
    for my $l (split /\n/, $diff) {
        if    ($l =~ m{^\+\+\+ b/(.*)$})            { $f = $1; next; }
        elsif ($l =~ m{^\+\+\+ /dev/null})          { $f = undef; next; }
        elsif ($l =~ /^@@ -\S+ \+(\d+)/)            { $n = $1; next; }
        elsif ($l =~ /^\+(.*)$/ && defined $f)      { push @z, [ $f, $n, $1 ]; $n++; }
    }
    return @z;
}

sub pruefen {
    my ($muster, @zeilen) = @_;
    my @funde;
    for my $z (@zeilen) {
        next if $z->[0] =~ /anonym-begriffe\.lokal$/;
        for my $m (@$muster) { push @funde, "$z->[0]:$z->[1]  ($m->[1])" if $z->[2] =~ $m->[0]; }
    }
    return @funde;
}

my $liste = liste_finden();
my @muster = defined $liste ? muster_laden($liste) : ();

if ($modus eq 'selbsttest') {
    unless (@muster) { print "  pruefe-namen-gestaget --selbsttest: keine lokale Liste - nichts zu testen (ungeprueft)\n"; exit 0; }
    my $f = 0; my $i = 0;
    for my $m (@muster) {
        $i++;
        (my $probe = $m->[2]) =~ s/\\b|\(\?i\)|\^|\$//g;
        my @t = pruefen(\@muster, [ 'tools/x.ps1', 1, "x $probe y" ]);
        my $ok = @t ? 1 : 0; $f++ unless $ok;
        printf "  [%s] Muster %d (%s) wird gefunden\n", $ok ? ' ok ' : 'FEHL', $i, $m->[1];
    }
    my @leer = pruefen(\@muster, [ 'tools/x.ps1', 1, 'Nichts Privates, nur 127.0.0.1 und Eudora' ]);
    printf "  [%s] harmlose Zeile bleibt frei\n", @leer ? 'FEHL' : ' ok '; $f++ if @leer;
    my @alt = pruefen(\@muster, hinzugefuegt("--- a/x\n+++ b/x\n@@ -1 +1 @@\n-alte Zeile\n"));
    printf "  [%s] entfernte Zeile zaehlt nicht\n", @alt ? 'FEHL' : ' ok '; $f++ if @alt;
    print "  Selbsttest: ", scalar(@muster) + 2, " Faelle, $f fehlgeschlagen\n";
    exit($f ? 1 : 0);
}

unless (defined $liste) { print "  pruefe-namen-gestaget: ungeprueft - tools/anonym-begriffe.lokal fehlt (fremder Klon?)\n"; exit 0; }
unless (@muster)        { print "  pruefe-namen-gestaget: ungeprueft - $liste enthaelt kein Muster\n"; exit 0; }

my $diff;
if    ($modus eq 'gestaget')  { $diff = `git diff --cached -U0 --no-color --no-ext-diff`; }
elsif ($modus eq 'seit-main') { $diff = `git log -p -U0 --no-color --format=tformat:COMMIT origin/main..HEAD`; }
else                          { $diff = `git show -U0 --no-color --format=tformat:COMMIT $rev`; }
# Scheitert git, ist der Diff leer und alles waere "frei" - genau so lief die
# erste Fassung am 06.11.2026 blind gruen (--format=COMMIT ist kein gueltiges
# Format). Deshalb: git-Fehler ist ein Aufrufproblem, kein Freispruch.
if ($? != 0) { print "  pruefe-namen-gestaget: git ist gescheitert ($modus) - NICHT geprueft\n"; exit 2; }

my @funde = pruefen(\@muster, hinzugefuegt($diff));
my %seen; @funde = grep { !$seen{$_}++ } @funde;
if (@funde) {
    print "\n  pruefe-namen-gestaget: NAME AUS DER LOKALEN LISTE in hinzugefuegten Zeilen ($modus):\n";
    print "    $_\n" for @funde;
    print "\n  Das Repo ist oeffentlich. Muster aus der Liste laden statt sie hinzuschreiben\n";
    print "  (wie pruefe-testdaten-anonym.pl), oder den Namen entfernen.\n\n";
    exit 1;
}
print "  pruefe-namen-gestaget: kein Name aus der lokalen Liste ($modus, " . scalar(@muster) . " Muster).\n";
exit 0;
