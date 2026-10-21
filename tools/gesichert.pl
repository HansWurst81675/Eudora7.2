#!/usr/bin/perl
#
# Beantwortet EINE Frage: kann Gregor jetzt zusammenfuehren und abschalten,
# ohne dass etwas verlorengeht?
#
#   perl tools/gesichert.pl                # mit Blick auf den Server
#   perl tools/gesichert.pl --ohne-holen   # ohne Netz, dafuer mit altem Stand
#
# Rueckgabewert 0 = alles gesichert.  1 = es fehlt etwas.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Gregor kuendigt jedes Mal an, wenn er einen Branch zusammenfuehrt und loescht.
# Die Ansage ist eindeutig; trotzdem ist am 31.08.2026 ein Commit drei Minuten
# NACH dem Merge auf den schon gemergten Branch gelegt worden. Am 05.09.2026
# dazu Gregors Satz:
#
#   "und fuer solche pruefungen haben wir genau extra agenten, die es
#    feststellen und verhindern sollen. die arbeiten also nicht sauber!"
#
# Er hat recht, und der Entwurf war falsch. Die Regel stand als Prosa in
# AUFGABEN.md und hing daran, dass ein Agent daran denkt. Eine Regel, die nur
# im Text lebt, wird uebersehen - beim zweiten Mal baut man ein Werkzeug
# (Lehre "Fehlerklassen abstellen"). Dieses hier beantwortet die Frage in einem
# Aufruf, statt sie auf fuenf git-Befehle und ein gutes Gedaechtnis zu verteilen.
# Zum Erzwingen dient tools/pruefe-branch.pl im pre-commit-Hook (Befund X-5).
#
# DARF EIN PRUEFWERKZEUG DEN ZUSTAND AENDERN?
#
# Es holt "git fetch --prune". Die Frage ist berechtigt, die Antwort lautet ja,
# und zwar aus einem einzigen Grund: die zentrale Frage dieses Werkzeugs - "gibt
# es das Gegenstueck auf dem Server noch?" - ist ohne frischen Serverstand nicht
# zu beantworten. Ohne --prune bleibt ein geloeschter Zweig als lebend stehen,
# und das Werkzeug gaebe genau in dem Fall Entwarnung, fuer den es gebaut wurde.
# Eine Auskunft aus einem veralteten Spiegel ist schlimmer als keine.
#
# Was dabei geaendert wird, ist eng begrenzt: NUR die Kopien der Serverzweige
# unter refs/remotes/origin. Kein Arbeitsbaum, kein lokaler Branch, kein Index,
# keine Datei. Wer selbst das nicht will, nimmt --ohne-holen; dann sagt der
# Bericht ausdruecklich, dass der Serverstand alt sein kann.
#
# Und: das Holen darf nicht haengen. Die Umgebungswerte unten schalten jede
# Rueckfrage ab; scheitert es trotzdem (kein Netz), wird das GEMELDET und nicht
# verschluckt.
#
use strict;
use warnings;

# WAS HEISST "NICHT COMMITTET"? (Nachtrag 21.10.2026, CHRONIST)
#
# Am 21.10.2026 abends meldete dieses Werkzeug 11 nicht committete Dateien im
# Arbeitsbaum des PRUEFER und damit NICHT GESICHERT. Nachgemessen war nichts
# ungesichert: die vier Textdateien waren Byte fuer Byte die aus origin/main,
# die sieben DLLs unterschieden sich um 7-8 Byte im PE-Zeitstempel. Der Zweig
# dort hing 16 Commits zurueck - dadurch sah NEUERER Inhalt wie eine lokale
# Aenderung aus. Am selben Abend wieder nachgemessen, jetzt 21 Commits
# zurueck und 6 Dateien, alle 6 mit demselben Blob-Hash wie origin/main.
#
# "git status" beantwortet die Frage "weicht das von MEINEM HEAD ab?". Die
# Frage dieses Werkzeugs ist aber eine andere: "geht etwas verloren, wenn
# Gregor jetzt abschaltet?" - und die heisst "liegt dieser Inhalt schon auf
# dem SERVER?". Beides faellt nur zusammen, solange der Zweig vorne steht.
#
# Also wird seither unterschieden. Eine geaenderte Datei, deren Inhalt in
# origin/main (oder im eigenen Gegenstueck) steht, ist kein Verlust, sondern
# ein zurueckhaengender Zweig; sie wird als Hinweis genannt, nicht als
# Mangel. Eine stumme Schranke und ein Fehlalarm kosten dasselbe
# (Arbeitsweise/schranke-gegentesten.md), und ein Werkzeug, das zweimal
# umsonst warnt, wird beim dritten Mal nicht mehr geglaubt - das steht
# weiter unten in diesem Quelltext schon einmal, fuer die ungepushten
# Commits vom 06.09.2026.
#
#   perl tools/gesichert.pl --selbsttest   # 9 Faelle, beide Richtungen

my $ohne_holen = grep { $_ eq '--ohne-holen' } @ARGV;
my $selbsttest = grep { $_ eq '--selbsttest' } @ARGV;

$ENV{GIT_TERMINAL_PROMPT} = '0';
$ENV{GIT_ASKPASS}         = 'echo';
$ENV{SSH_ASKPASS}         = 'echo';
$ENV{GIT_SSH_COMMAND}     = 'ssh -oBatchMode=yes';
$ENV{GCM_INTERACTIVE}     = 'never';
$ENV{GIT_OPTIONAL_LOCKS}  = '0';

# --- git ohne Shell ------------------------------------------------------------
#
# Ohne Shell heisst: die Klammern in "--format=%(upstream:track)" koennen nicht
# zerrissen werden, und kein Pfad mit Leerzeichen braucht Anfuehrungszeichen.

sub git_lauf {                       # (@arg) -> ($ausgabe, $rueckgabewert)
    my @arg = @_;
    my $pid = open(my $fh, '-|');
    return ('', -1) unless defined $pid;
    if (!$pid) {
        open(STDERR, '>', '/dev/null') or open(STDERR, '>', 'NUL');
        exec('git', @arg) or exit 127;
    }
    local $/;
    my $aus = <$fh>;
    close $fh;
    my $rc = ($? == -1) ? -1 : ($? >> 8);
    $aus = '' unless defined $aus;
    return ($aus, $rc);
}

sub git    { my ($a) = git_lauf(@_); $a =~ s/\s+\z//; return $a; }
sub git_rc { my (undef, $rc) = git_lauf(@_); return $rc; }

# Dasselbe in einem anderen Arbeitsbaum.
sub git_in { my $p = shift; return git('-C', $p, @_); }

# --- Geaendert gegenueber HEAD, aber liegt der Inhalt schon auf dem Server? ---
#
# Liefert ($alle, $verloren): die Pfade aus "git status --porcelain" ohne die
# unverfolgten, und davon die, deren Inhalt in KEINEM der genannten Refs
# steht. Nur die zweiten sind ein Verlust.
#
# Gemessen wird mit "git diff --name-only <ref>": das vergleicht den
# Arbeitsbaum (samt Index) gegen den Ref. Eine Datei, die dort NICHT
# auftaucht, ist dort Byte fuer Byte vorhanden. Pfadnamen mit Sonderzeichen
# gibt git in Anfuehrungszeichen aus - deshalb wird mit -z gelesen, dann
# gibt es keine.
sub was_ist_wirklich_offen {
    my ($baum, @refs) = @_;

    my $roh = git('-C', $baum, 'status', '--porcelain', '-z');
    my @stuecke = split /\0/, $roh;
    my @alle;
    while (@stuecke) {
        my $e = shift @stuecke;
        next unless length $e;
        my $lage = substr($e, 0, 2);
        my $pfad = length($e) > 3 ? substr($e, 3) : '';
        if ($lage =~ /R|C/) { shift @stuecke; }   # Quelle folgt als eigenes Stueck
        next if $lage eq '??';
        next unless length $pfad;
        push @alle, $pfad;
    }
    return (\@alle, []) unless @alle;

    # Fuer jeden Ref: was weicht davon ab? Was in KEINER dieser Listen steht,
    # liegt irgendwo auf dem Server.
    my @verloren = @alle;
    for my $r (@refs) {
        next unless length $r;
        next unless length git('-C', $baum, 'rev-parse', '--verify', '--quiet', "$r^{commit}");
        my %weicht_ab = map { $_ => 1 }
                        grep { length }
                        split /\0/, git('-C', $baum, 'diff', '--name-only', '-z', $r, '--');
        @verloren = grep { $weicht_ab{$_} } @verloren;
        last unless @verloren;
    }
    return (\@alle, \@verloren);
}

# ---------------------------------------------------------------------------
# SELBSTTEST - neun Faelle, beide Richtungen
# ---------------------------------------------------------------------------
#
# Gebaut wird ein Wegwerf-Repo im Temp-Verzeichnis: ein "Server" (bare), ein
# Arbeitsbaum, ein Zweig, der zurueckhaengt. Genau die Lage vom 21.10.2026.
# Nichts Ausfuehrbares wird abgelegt, nur Textdateien, und am Ende wird
# geloescht (Arbeitsweise/pruefung-legt-nichts-ab.md).

if ($selbsttest) {
    require File::Path;
    require File::Spec;

    my $t = File::Spec->catdir(($ENV{TEMP} || $ENV{TMP} || '/tmp'),
                               "gesichert-selbsttest-$$");
    File::Path::remove_tree($t) if -d $t;
    File::Path::make_path($t);

    my $server = File::Spec->catdir($t, 'server.git');
    my $baum   = File::Spec->catdir($t, 'arbeit');

    sub schreib { my ($p, $i) = @_; open my $h, '>', $p or die "$p: $!"; print $h $i; close $h; }
    sub g { my @a = @_; my (undef, $rc) = git_lauf(@a); return $rc; }

    g('init', '--quiet', '--bare', $server);
    g('init', '--quiet', '-b', 'main', $baum);
    g('-C', $baum, 'config', 'user.email', 'selbsttest@example.invalid');
    g('-C', $baum, 'config', 'user.name',  'Selbsttest');
    g('-C', $baum, 'config', 'core.hooksPath', File::Spec->catdir($t, 'keine-haken'));

    schreib(File::Spec->catfile($baum, 'a.txt'), "eins\n");
    schreib(File::Spec->catfile($baum, 'b.txt'), "zwei\n");
    schreib(File::Spec->catfile($baum, 'd.txt'), "vier\n");
    g('-C', $baum, 'add', '-A');
    g('-C', $baum, 'commit', '--quiet', '-m', 'M1');
    g('-C', $baum, 'remote', 'add', 'origin', $server);
    g('-C', $baum, 'push', '--quiet', 'origin', 'main');
    g('-C', $baum, 'branch', 'alt');

    # main geht weiter: a.txt geaendert, b.txt geloescht, c.txt dazu.
    schreib(File::Spec->catfile($baum, 'a.txt'), "eins-neu\n");
    unlink File::Spec->catfile($baum, 'b.txt');
    schreib(File::Spec->catfile($baum, 'c.txt'), "drei\n");
    g('-C', $baum, 'add', '-A');
    g('-C', $baum, 'commit', '--quiet', '-m', 'M2');
    g('-C', $baum, 'push', '--quiet', 'origin', 'main');

    # Ein eigenes Gegenstueck mit einem Inhalt, den main NICHT hat.
    g('-C', $baum, 'checkout', '--quiet', '-b', 'eigen');
    schreib(File::Spec->catfile($baum, 'e.txt'), "fuenf\n");
    g('-C', $baum, 'add', '-A');
    g('-C', $baum, 'commit', '--quiet', '-m', 'E1');
    g('-C', $baum, 'push', '--quiet', 'origin', 'eigen');

    # Und jetzt auf den zurueckhaengenden Zweig.
    g('-C', $baum, 'checkout', '--quiet', '--force', 'alt');
    g('-C', $baum, 'clean', '--quiet', '-fd');

    my @haupt = ('origin/main');
    my @beide = ('origin/main', 'origin/eigen');
    my ($gut, $schlecht) = (0, 0);

    my $pruefe = sub {
        my ($name, $refs, $e_alle, $e_verloren) = @_;
        my ($alle, $verloren) = was_ist_wirklich_offen($baum, @$refs);
        my $ok = (@$alle == $e_alle and @$verloren == $e_verloren);
        printf "  [%s] %s\n", ($ok ? 'ok ' : 'ROT'), $name;
        printf "        erwartet geaendert=%d verloren=%d, bekommen %d / %d (%s)\n",
            $e_alle, $e_verloren, scalar @$alle, scalar @$verloren,
            join(', ', @$verloren) unless $ok;
        $ok ? $gut++ : $schlecht++;
    };

    $pruefe->('sauberer Baum: nichts geaendert, nichts verloren', \@haupt, 0, 0);

    # Der Zweig haengt zurueck, der Inhalt ist der von origin/main.
    schreib(File::Spec->catfile($baum, 'a.txt'), "eins-neu\n");
    $pruefe->('Inhalt gleich origin/main, Zweig haengt zurueck (der Fall vom 21.10.)',
              \@haupt, 1, 0);

    unlink File::Spec->catfile($baum, 'b.txt');
    $pruefe->('Loeschung, die origin/main schon kennt, ist kein Verlust', \@haupt, 2, 0);

    schreib(File::Spec->catfile($baum, 'c.txt'), "drei\n");
    g('-C', $baum, 'add', 'c.txt');
    $pruefe->('gestagte neue Datei, die in origin/main identisch liegt', \@haupt, 3, 0);

    schreib(File::Spec->catfile($baum, 'x.txt'), "unverfolgt\n");
    $pruefe->('unverfolgte Datei zaehlt gar nicht mit', \@haupt, 3, 0);
    unlink File::Spec->catfile($baum, 'x.txt');

    # Gegenrichtung: eine Aenderung, die es nirgends gibt.
    schreib(File::Spec->catfile($baum, 'a.txt'), "eins-neu-UND-MEINS\n");
    $pruefe->('echte eigene Aenderung wird als Verlust gemeldet', \@haupt, 3, 1);
    schreib(File::Spec->catfile($baum, 'a.txt'), "eins-neu\n");

    unlink File::Spec->catfile($baum, 'd.txt');
    $pruefe->('Loeschung einer Datei, die origin/main noch hat, ist ein Verlust',
              \@haupt, 4, 1);
    schreib(File::Spec->catfile($baum, 'd.txt'), "vier\n");

    # Inhalt, den NUR das eigene Gegenstueck kennt.
    schreib(File::Spec->catfile($baum, 'e.txt'), "fuenf\n");
    g('-C', $baum, 'add', 'e.txt');
    $pruefe->('nur gegen origin/main gemessen: der Inhalt sieht verloren aus',
              \@haupt, 4, 1);
    $pruefe->('gegen origin/main UND das eigene Gegenstueck: nichts verloren',
              \@beide, 4, 0);

    File::Path::remove_tree($t);

    printf "\n  Selbsttest: %d von %d Faellen, %d rot.\n", $gut, $gut + $schlecht, $schlecht;
    print "  Beide Richtungen: der zurueckhaengende Zweig meldet nichts,\n";
    print "  die echte Aenderung und die echte Loeschung melden.\n\n";
    exit($schlecht ? 1 : 0);
}

my @mangel;
my @hinweis;

print "\n";
print "  Ist alles gesichert?\n";
print "  " . ("-" x 68) . "\n\n";

# --- 0. Ueberhaupt ein Arbeitsbaum? --------------------------------------------

my $wurzel = git('rev-parse', '--show-toplevel');
if (!length $wurzel) {
    print "  Kein git-Arbeitsbaum.\n\n";
    exit 1;
}

# --- 1. Auf welchem Branch? ----------------------------------------------------

my ($branch, $rc_branch) = git_lauf('symbolic-ref', '--quiet', '--short', 'HEAD');
$branch =~ s/\s+\z//;
my $abgeloest = ($rc_branch != 0 or !length $branch);
my $kopf = git('rev-parse', '--short', 'HEAD');

printf("  %-28s %s\n", "Branch",
       $abgeloest ? "ABGELOESTER HEAD ($kopf)" : "$branch ($kopf)");
push @mangel, "abgeloester HEAD - was hier committet wird, haengt an keinem Branch"
    if $abgeloest;

# --- 2. Serverstand holen ------------------------------------------------------

my $server_frisch = 0;
if ($ohne_holen) {
    push @hinweis, "nicht geholt (--ohne-holen): der Serverstand unten kann alt sein";
}
elsif (!length git('remote')) {
    printf("  %-28s %s\n", "Gegenstelle", "KEINE (kein origin)");
    push @hinweis, "kein origin eingerichtet - alles hier lebt nur auf dieser Platte";
}
else {
    my $rc = git_rc('fetch', '--prune', '--quiet', 'origin');
    if ($rc == 0) { $server_frisch = 1; }
    else {
        printf("  %-28s %s\n", "Serverstand holen", "FEHLGESCHLAGEN (Rueckgabe $rc)");
        push @hinweis, "'git fetch --prune' scheiterte - der Serverstand unten ist alt";
    }
}

# --- 2b. Welcher Zweig ist "der Server"? ---------------------------------------
#
# Steht hier oben, weil schon die Frage "ist etwas nicht committet?" ihn
# braucht: geaendert gegenueber HEAD und verloren sind zweierlei.

my $haupt;
for my $k ('origin/main', 'origin/master') {
    if (length git('rev-parse', '--verify', '--quiet', $k)) { $haupt = $k; last; }
}

# --- 3. Nicht committet? -------------------------------------------------------

my @zeilen = grep { length } split /\n/, git('status', '--porcelain');
my @neu    = grep {  /^\?\?/ } @zeilen;

my $eigen_up = $abgeloest ? ''
             : git('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}');
my ($offen_ref, $verloren_ref) =
    was_ist_wirklich_offen($wurzel, grep { length } ($haupt, $eigen_up));
my @offen    = @$offen_ref;
my @verloren = @$verloren_ref;

printf("  %-28s %d%s\n", "nicht committet", scalar @offen,
       (@offen && !@verloren) ? "  (Inhalt liegt auf dem Server)" : "");
if (@verloren) {
    push @mangel, sprintf("%d Datei(en) sind geaendert und liegen nirgends auf dem Server",
                          scalar @verloren);
    print "      $_\n" for @verloren[0 .. ($#verloren > 7 ? 7 : $#verloren)];
    print "      ... und " . (@verloren - 8) . " weitere\n" if @verloren > 8;
}
elsif (@offen) {
    push @hinweis, sprintf("%d geaenderte Datei(en) - ihr Inhalt steht Byte fuer Byte "
                         . "schon auf dem Server; der Zweig hier haengt nur zurueck. "
                         . "Es geht nichts verloren", scalar @offen);
}

printf("  %-28s %d\n", "unverfolgt", scalar @neu);
if (@neu) {
    push @hinweis, sprintf("%d unverfolgte Datei(en) - absichtlich draussen?", scalar @neu);
    print "      $_\n" for @neu[0 .. ($#neu > 5 ? 5 : $#neu)];
    print "      ... und " . (@neu - 6) . " weitere\n" if @neu > 6;
}

# --- 4. Nicht gepusht? ---------------------------------------------------------

my $upstream = $abgeloest ? '' : git('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}');

if (!$abgeloest) {
    if (!length $upstream) {
        printf("  %-28s %s\n", "Gegenstueck auf dem Server", "KEINS");
        push @mangel, "der Branch '$branch' ist nirgends gepusht - er lebt nur hier";
    }
    else {
        my $spur = git('for-each-ref', '--format=%(upstream:track)', "refs/heads/$branch");
        if ($spur =~ /\[gone\]/) {
            printf("  %-28s %s\n", "Gegenstueck auf dem Server", "GELOESCHT ($upstream)");
            push @mangel, "'$upstream' ist geloescht - alles hier ist nur noch lokal";
        }
        else {
            my $vor = git('rev-list', '--count', "$upstream..HEAD");
            $vor = 0 unless $vor =~ /^\d+$/;
            printf("  %-28s %s\n", "nicht gepusht", ($vor ? "$vor Commit(s)" : "0"));
            push @mangel, "$vor Commit(s) sind nicht gepusht" if $vor;
        }
    }
}

# --- 5. Steckt der Stand schon in origin/main? ---------------------------------
#
# "enthalten" allein reicht nicht: ein frisch abgezweigter Branch ist gleich der
# Spitze von origin/main und damit auch enthalten. Gemeint ist ECHT enthalten -
# enthalten UND dahinter. Dieselbe Unterscheidung wie in pruefe-branch.pl.

if (defined $haupt and !$abgeloest and $branch ne 'main' and $branch ne 'master') {
    my $gleich = (git('rev-parse', 'HEAD') eq git('rev-parse', $haupt));
    my $rc     = git_rc('merge-base', '--is-ancestor', 'HEAD', $haupt);

    if ($rc == 0 and $gleich) {
        printf("  %-28s %s\n", "in $haupt", "gleichauf - frisch abgezweigt");
    }
    elsif ($rc == 0) {
        printf("  %-28s %s\n", "in $haupt", "JA - der Branch ist zusammengefuehrt");
        push @hinweis, "'$branch' ist bereits in $haupt - hier gehoert nicht mehr gearbeitet, sondern auf main";
    }
    elsif ($rc == 1) {
        my $eigen = git('rev-list', '--count', "$haupt..HEAD");
        printf("  %-28s %s\n", "in $haupt", "nein, $eigen eigene(r) Commit(s)");
    }
    else {
        printf("  %-28s %s\n", "in $haupt", "ungeklaert (Rueckgabe $rc)");
        push @hinweis, "'merge-base --is-ancestor' scheiterte - ungeklaert, ob '$branch' zusammengefuehrt ist";
    }
}

# --- 6. Andere Arbeitsbaeume ----------------------------------------------------
#
# Ein Agent in einem eigenen Arbeitsbaum kann uncommittete ODER ungepushte Arbeit
# halten; beides geht beim Abschalten verloren und erscheint NICHT im
# "git status" dieses Baums. Die erste Fassung fragte nur nach uncommitteten
# Dateien und nannte einen Baum mit drei ungepushten Commits "sauber" - gemessen
# am 05.09.2026 an wt/paket und wt/zeiger.
#
# Gelesen wird "worktree list --porcelain" ueber die worktree-Zeile, nicht ueber
# die branch-Zeile: ein Baum mit abgeloestem HEAD hat gar keine branch-Zeile und
# fiele sonst aus der Liste heraus.

sub gleicher_pfad {                  # Windows: Gross/Klein und Schraegstriche
    my ($a, $b) = @_;
    for ($a, $b) { s{\\}{/}g; $_ = lc $_; s{/+$}{}; }
    return $a eq $b;
}

my @baeume;
my $akt;
for my $z (split /\n/, git('worktree', 'list', '--porcelain')) {
    if ($z =~ /^worktree (.+)$/) {
        $akt = { pfad => $1, branch => '', abgeloest => 0, weg => 0 };
        push @baeume, $akt unless gleicher_pfad($1, $wurzel);
        next;
    }
    next unless $akt;
    $akt->{branch}    = $1 if $z =~ m{^branch refs/heads/(.+)$};
    $akt->{abgeloest} = 1  if $z =~ /^detached\b/;
    $akt->{weg}       = 1  if $z =~ /^prunable\b/;
}

if (@baeume) {
    printf("  %-28s %d\n", "weitere Arbeitsbaeume", scalar @baeume);
    for my $b (@baeume) {
        my $p = $b->{pfad};

        if ($b->{weg} or !-d $p) {
            printf("      %-52s %s\n", $p, "Verzeichnis fehlt");
            push @hinweis, "Arbeitsbaum $p ist nicht mehr da (git worktree prune)";
            next;
        }

        my $fremd_up = git_in($p, 'rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}');
        my ($f_alle, $f_verloren) =
            was_ist_wirklich_offen($p, grep { length } ($haupt, $fremd_up));
        my $n = scalar @$f_alle;
        my $v = scalar @$f_verloren;
        my @sagen;
        if ($v) {
            push @sagen,  "$v nicht gesichert";
            push @mangel, "Arbeitsbaum $p hat $v geaenderte Datei(en), die nirgends "
                        . "auf dem Server liegen: " . join(', ', @$f_verloren[0 .. ($v > 4 ? 4 : $v - 1)])
                        . ($v > 5 ? " ..." : "");
        }
        elsif ($n) {
            # Der Fall vom 21.10.2026: 11 Dateien gemeldet, 0 verloren.
            push @sagen,  "$n geaendert, Inhalt liegt auf dem Server";
            push @hinweis, "Arbeitsbaum $p zeigt $n geaenderte Datei(en) - ihr Inhalt steht "
                         . "schon auf dem Server, der Zweig dort haengt nur zurueck. "
                         . "Es geht nichts verloren";
        }

        if ($b->{abgeloest}) {
            push @sagen,  "abgeloester HEAD";
            push @mangel, "Arbeitsbaum $p steht auf abgeloestem HEAD";
        }
        elsif (length $b->{branch}) {
            my $bn = $b->{branch};
            my $up = git_in($p, 'rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}');

            # Sitzt der fremde Baum auf einem schon zusammengefuehrten Zweig?
            # Das ist genau die Lage vom 31.08.2026, 09:06 - nur in einem Baum,
            # den man von hier aus nicht sieht.
            my $verschmolzen = 0;
            if (defined $haupt and $bn ne 'main' and $bn ne 'master') {
                my $spitze = git_in($p, 'rev-parse', $haupt);
                my $eigen  = git_in($p, 'rev-parse', "refs/heads/$bn");
                if ($spitze ne $eigen
                    and git_rc('-C', $p, 'merge-base', '--is-ancestor', "refs/heads/$bn", $haupt) == 0) {
                    $verschmolzen = 1;
                    push @sagen,   "'$bn' ist zusammengefuehrt";
                    # ACHTUNG, der Rat muss ausfuehrbar sein: ein Arbeitsbaum
                    # kann NICHT auf main wechseln, solange der Hauptbaum darauf
                    # steht - git sagt "'main' is already used by worktree at
                    # ...". Bis zum 07.09.2026 stand hier genau dieser Rat, und
                    # er scheiterte in allen drei Baeumen. Ein Hinweis, dem man
                    # nicht folgen kann, ist so schlecht wie ein Fehlalarm.
                    push @hinweis, "Arbeitsbaum $p steht auf '$bn', und der ist bereits in $haupt - "
                                 . "dort nachziehen mit  git -C $p merge --ff-only $haupt  "
                                 . "(nicht 'checkout main': das sperrt der Hauptbaum)";
                }
            }

            if (!length $up) {
                # Kein eigenes Gegenstueck auf dem Server. Das heisst NICHT, dass
                # die Commits verloren sind: sie koennen laengst unter einem
                # anderen Zweignamen dort liegen - genau so ist es, wenn ein
                # Agent von unserem Arbeitszweig abzweigt.
                #
                # Die erste Fassung verglich gegen origin/main und meldete
                # deshalb am 06.09.2026 fuer wt/chronist und wt/paige je "36
                # Commit(s), die nirgends gepusht sind", obwohl alle 36 in
                # origin/strg-n-diagnose lagen. Nachgemessen mit
                # "rev-list --count origin/strg-n-diagnose..wt/chronist": 0.
                #
                # Eine Schranke, die zweimal umsonst warnt, wird beim dritten Mal
                # nicht mehr geglaubt. Deshalb wird jetzt gegen ALLE Zweige des
                # Servers geprueft (--not --remotes=origin) und nicht nur gegen
                # einen.
                my $eigen = git_in($p, 'rev-list', '--count', "refs/heads/$bn",
                                       '--not', '--remotes=origin');
                $eigen = 0 unless $eigen =~ /^\d+$/;
                if ($eigen) {
                    push @sagen,  "'$bn': $eigen Commit(s) nirgends gepusht";
                    push @mangel, "Arbeitsbaum $p ('$bn') hat $eigen Commit(s), die auf keinem Server-Zweig liegen";
                }
                elsif (!$verschmolzen) {
                    push @sagen, "'$bn': kein eigenes Gegenstueck, aber alles liegt auf dem Server";
                }
            }
            else {
                my $spur = git_in($p, 'for-each-ref', '--format=%(upstream:track)', "refs/heads/$bn");
                if ($spur =~ /\[gone\]/) {
                    push @sagen,  "'$bn': Gegenstueck geloescht";
                    push @mangel, "Arbeitsbaum $p ('$bn'): das Gegenstueck '$up' ist geloescht";
                }
                else {
                    my $vor = git_in($p, 'rev-list', '--count', "$up..refs/heads/$bn");
                    $vor = 0 unless $vor =~ /^\d+$/;
                    if ($vor) {
                        push @sagen,  "'$bn': $vor nicht gepusht";
                        push @mangel, "Arbeitsbaum $p ('$bn') hat $vor nicht gepushte Commit(s)";
                    }
                }
            }
        }

        printf("      %-52s %s\n", $p, (@sagen ? join(', ', @sagen) : "sauber"));
    }
}

# --- Urteil --------------------------------------------------------------------

print "\n  " . ("-" x 68) . "\n\n";

if (@mangel) {
    print "  NICHT GESICHERT:\n\n";
    print "    - $_\n" for @mangel;
    print "\n";
    if (@hinweis) { print "  Ausserdem:\n\n"; print "    - $_\n" for @hinweis; print "\n"; }
    exit 1;
}

print "  GESICHERT. Committet, gepusht, keine offenen Arbeitsbaeume.\n";
print "  (Serverstand frisch geholt.)\n" if $server_frisch;
if (@hinweis) { print "\n  Zur Kenntnis:\n\n"; print "    - $_\n" for @hinweis; }
print "\n";
exit 0;
