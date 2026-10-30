#!/usr/bin/perl
# auftrag-rolle.pl - richtet einen Lauf von LEKTOR oder PRUEFER ein und gibt
# den fertigen Agentenauftrag aus.
#
#   perl tools/auftrag-rolle.pl PRUEFER --basis <zweig> --seit <commit> [--schwerpunkt "<text>"]
#   perl tools/auftrag-rolle.pl LEKTOR  --basis <zweig> --seit <commit> [--schwerpunkt "<text>"]
#   perl tools/auftrag-rolle.pl ... --nur-zeigen     nichts einrichten, nur den Text ausgeben
#
# WARUM ES DAS GIBT. Gregor am 25.10.2026: "ich habe den eindruck, du hast
# deine eigenen tools nicht wirklich im griff! verbessere es!" Gemessen am
# Vortag: in BEIDEN Agentenauftraegen stand "bash tools/arbeitsbaum-angleichen.sh
# . origin/main" - das Werkzeug erwartet "main" und setzt "origin/" selbst
# davor. Beide Agenten konnten ihre Berichte deshalb nicht selbst sichern.
# Jeder Auftrag wurde von Hand neu getippt; jeder Tippfehler darin war neu.
# Jetzt stehen die Auftraege einmal in tools/auftraege/<ROLLE>.txt, und
# dieses Werkzeug erledigt, was sonst von Hand geschah:
#   1. Arbeitsbaum .wt/<rolle> im Projektordner pruefen (sauber) oder anlegen
#      - NICHT mehr ../Eudora7.2-wt-<rolle>: jeder Zugriff ausserhalb des
#      Projektordners legt Gregor eine Freigabe-Abfrage vor (30.10.2026, sechs
#      Abfragen an einem Vormittag; Arbeitsweise/keine-unverstaendlichen-abfragen.md).
#      .wt/ steht in .gitignore.
#   2. frischen Zweig wt/<rolle>-<datum>[b..] von origin/<basis>, mit eigenem
#      Gegenstueck auf dem Server (Arbeitsweise/arbeitsbaum-braucht-eigenes-gegenstueck.md)
#   3. Berichtsnummer und - fuer PRUEFER - zwei freie E-Kennungen vergeben
#   4. den Lauf in tools/AGENTEN-LAUFEN.md eintragen
#   5. den Auftrag mit allen Werten ausgeben
#
# Kodierung: reines ASCII.
use strict;
use warnings;
use Cwd qw(abs_path);

my ($rolle, $basis, $seit, $schwer, $nur_zeigen) = ('', '', '', '', 0);
my @a = @ARGV;
$rolle = uc(shift @a // '');
while (@a) {
    my $x = shift @a;
    if    ($x eq '--basis')       { $basis  = shift @a // '' }
    elsif ($x eq '--seit')        { $seit   = shift @a // '' }
    elsif ($x eq '--schwerpunkt') { $schwer = shift @a // '' }
    elsif ($x eq '--nur-zeigen')  { $nur_zeigen = 1 }
    else { print STDERR "unbekannt: $x\n"; exit 2 }
}
unless ($rolle =~ /^(LEKTOR|PRUEFER)$/ and $basis and $seit) {
    print STDERR "Aufruf: perl tools/auftrag-rolle.pl LEKTOR|PRUEFER --basis <zweig> --seit <commit> [--schwerpunkt \"<text>\"] [--nur-zeigen]\n";
    exit 2;
}
-f 'VERSION' or do { print STDERR "aus der Wurzel aufrufen\n"; exit 2 };
my $repo = abs_path('.');
(my $repo_win = $repo) =~ s{/}{\\}g;
$repo_win =~ s{^\\([a-z])\\}{\U$1\E:\\};
my $baum = "$repo/.wt/" . lc $rolle;
(my $baum_win = $baum) =~ s{/}{\\}g;
$baum_win =~ s{^\\([a-z])\\}{\U$1\E:\\};

sub lauf { my $c = join ' ', map { "\"$_\"" } @_; my $a = `$c 2>&1`; chomp $a; return ($a, $? >> 8) }
sub git { return lauf('git', @_) }
sub lies { my ($d) = @_; open my $h, '<:raw', $d or return ''; local $/; my $t = <$h>; close $h; $t }

git('fetch', '-q', 'origin');
my (undef, $rc_b) = git('rev-parse', '--verify', '-q', "origin/$basis");
$rc_b == 0 or do { print STDERR "origin/$basis gibt es nicht\n"; exit 2 };
my (undef, $rc_s) = git('rev-parse', '--verify', '-q', $seit);
$rc_s == 0 or do { print STDERR "Commit $seit gibt es nicht\n"; exit 2 };

# --- Berichtsnummer: hoechste vorhandene + 1, auch auf den Rollenzweigen ---
my $max = 0;
for my $f (glob("Befunde/$rolle-*.md")) { $max = $1 if $f =~ /$rolle-(\d+)\.md$/ and $1 > $max }
my ($zweige) = git('branch', '-r', '--list', "origin/wt/*");
for my $z (split /\n/, $zweige) {
    $z =~ s/^\s+//;
    my ($l) = git('ls-tree', '--name-only', $z, 'Befunde/');
    for (split /\n/, $l) { $max = $1 if /$rolle-(\d+)\.md$/ and $1 > $max }
}
my $vorbild = "$rolle-$max.md";
my $bericht = "$rolle-" . ($max + 1) . ".md";

# --- Freie E-Kennungen (PRUEFER): ueber BEFUNDE.md UND alle Berichte -------
my $kennungen = '';
if ($rolle eq 'PRUEFER') {
    # Massstab sind die Anker der Urteilstabelle. Berichte - auch die auf den
    # Rollenzweigen, die noch nicht eingearbeitet sind - heben die Zahl nur im
    # lueckenlosen Anschluss (hoechstens 5 weiter): LEKTOR-9 und LEKTOR-48
    # nennen "E-999" als erfundenes Beispiel, und der erste Stand schlug
    # deshalb E-1000 vor (gemessen 25.10.2026). Vergebene, aber noch nicht
    # berichtete Kennungen stehen in tools/AGENTEN-LAUFEN.md und zaehlen mit.
    my $emax = 0;
    my $tab = lies('Intern/BEFUNDE.md');
    while ($tab =~ /<a id="e-(\d+)"><\/a>/g) { $emax = $1 if $1 > $emax }
    my %genannt;
    for my $t (lies("tools/AGENTEN-LAUFEN.md"), map({ lies($_) } glob(q{Befunde/*.md})),
               map { (git('grep', '-h', '-o', '-E', 'E-[0-9]+', $_, '--', 'Befunde/'))[0] } split /\n/, $zweige) {
        $genannt{$1} = 1 while $t =~ /\bE-(\d+)\b/g;
    }
    for (my $weiter = 1; $weiter; ) {
        $weiter = 0;
        for my $n ($emax + 1 .. $emax + 5) { if ($genannt{$n}) { $emax = $n; $weiter = 1 } }
    }
    $kennungen = 'E-' . ($emax + 1) . ' und E-' . ($emax + 2);
}

# --- Zweigname: wt/<rolle>-<datum>, bei Bedarf b, c, ... -------------------
my @t = localtime;
my $datum = sprintf('%04d%02d%02d', $t[5] + 1900, $t[4] + 1, $t[3]);
my $zweig = 'wt/' . lc($rolle) . "-$datum";
for my $s ('', 'b' .. 'z') {
    my $k = "wt/" . lc($rolle) . "-$datum$s";
    my (undef, $l) = git('rev-parse', '--verify', '-q', $k);
    my (undef, $r) = git('rev-parse', '--verify', '-q', "origin/$k");
    if ($l != 0 and $r != 0) { $zweig = $k; last }
}

my $sichern = join "\n",
  "- FRUEH SICHERN: sobald der Bericht ein Geruest hat und nach jedem groesseren Abschnitt: `git add` (nur deine Dateien), `git commit -m \"...\"`, `git push`.",
  "  Weist der Commit-Haken ab mit \"bereits in origin/main enthalten\": zuerst `bash tools/arbeitsbaum-angleichen.sh . $basis` (OHNE \"origin/\" davor - das Werkzeug setzt es selbst), dann erneut committen.",
  "  Fehlen Links: `perl tools/befunde-verlinken.pl --anker --verlinken`, dann nur deine Dateien stagen.",
  "  Weist pruefe-startwege.pl ab (fremder Eudora-Start ohne Protokollzeile): NICHT umgehen, sondern melden und den Bericht ungestaget liegen lassen.",
  "  Niemals `git reset --hard`, niemals `--no-verify`. Commit-Nachrichten enden mit:",
  "  Co-Authored-By: Claude Opus 5.5 <noreply\@anthropic.com>";

my $vorlage = lies("tools/auftraege/$rolle.txt");
length $vorlage or do { print STDERR "Vorlage tools/auftraege/$rolle.txt fehlt\n"; exit 2 };
my %w = (REPO => $repo_win, BAUM => $baum_win, ZWEIG => $zweig, BASIS => $basis, SEIT => $seit,
         BERICHT => $bericht, VORBILD => $vorbild, KENNUNGEN => $kennungen,
         SCHWERPUNKT => ($schwer ? "Schwerpunkte:\n$schwer" : ''), SICHERN => $sichern,
         FUNDKUERZEL => 'L-' . ($max + 1));
$vorlage =~ s/\{(\w+)\}/exists $w{$1} ? $w{$1} : "{$1}"/ge;
if ($vorlage =~ /\{\w+\}/) { print STDERR "Platzhalter ohne Wert: $&\n"; exit 2 }

unless ($nur_zeigen) {
    if (-d $baum) {
        my ($st) = git('-C', $baum, 'status', '--porcelain');
        length $st and do { print STDERR "Arbeitsbaum $baum ist nicht sauber:\n$st\n"; exit 1 };
        my ($sw, $rc1) = git('-C', $baum, 'switch', '-q', '--no-track', '-c', $zweig, "origin/$basis");
        $rc1 == 0 or do { print STDERR "Zweig anlegen gescheitert: $sw\n"; exit 1 };
    } else {
        my ($wa, $rc0) = git('worktree', 'add', '-q', '--no-track', '-b', $zweig, $baum, "origin/$basis");
        $rc0 == 0 or do { print STDERR "Arbeitsbaum $baum anlegen gescheitert: $wa\n"; exit 1 };
    }
    my ($pu, $rc2) = git('-C', $baum, 'push', '-q', '-u', 'origin', $zweig);
    $rc2 == 0 or do { print STDERR "Push gescheitert: $pu\n"; exit 1 };
    my $kurz = ($rolle eq 'PRUEFER' ? "$bericht: Aenderungen seit $seit gegen die Quelle, Kennungen $kennungen" : "$bericht: alle MDs gegen den Bestand, seit $seit");
    # Ausgabe nach stderr: stdout ist der Auftrag (gemessen beim ersten
    # Ernstlauf 25.10.2026 - "LEKTOR eingetragen" stand als erste Zeile darin).
    my ($ein) = lauf('perl', 'tools/agenten-laufen.pl', '--start', $rolle, $kurz);
    print STDERR "$ein\n";
    print STDERR "  eingerichtet: $baum auf $zweig, Bericht $bericht" . ($kennungen ? ", Kennungen $kennungen" : '') . "\n\n";
}
print $vorlage;
exit 0;
