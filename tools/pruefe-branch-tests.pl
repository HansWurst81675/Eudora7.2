#!/usr/bin/perl
#
# Testsammlung fuer die pre-commit-Schranke tools/pruefe-branch.pl.
#
#   perl tools/pruefe-branch-tests.pl        # alle Faelle
#   perl tools/pruefe-branch-tests.pl -v     # zusaetzlich die Meldung der Schranke
#
# WARUM ES DIESE SAMMLUNG GIBT
#
# Die erste Fassung der Schranke war beim ersten Nachmessen falsch: sie brach
# den ERSTEN Commit jedes frisch abgezweigten Branches ab, weil ein frischer
# Zweig genauso "in origin/main enthalten" ist wie ein zusammengefuehrter. Eine
# Schranke, die grundlos anschlaegt, wird umgangen - dann ist sie schlechter als
# keine (dieselbe Lehre wie bei X-1/PR-1 fuer pruefe-bytes.pl). Der Fehler wuchs
# in einer Zeile und waere bei der ersten Ausfuehrung dieser Sammlung
# aufgefallen. Wer die Schranke anfasst, laesst diese Sammlung laufen -
# sonst nicht committen.
#
# WIE SIE ARBEITET
#
# Jeder Fall baut zwei Wegwerf-Repos unter dem Temp-Verzeichnis: einen "Server"
# (bare) und einen Klon davon. Im Klon wird die Lage hergestellt, die der Fall
# beschreibt, und die Schranke darin aufgerufen. Geprueft wird ausschliesslich
# der Rueckgabewert:
#
#   0 = durchgelassen        1 = COMMIT ABGEBROCHEN
#
# Jeder Fall laeuft ZWEIMAL: einmal hart (so laeuft die Schranke im Hook - hier
# zaehlt der Rueckgabewert) und einmal mit --melden (dort steht die Begruendung,
# und abgebrochen werden darf NIE). Die Begruendung wird gegen "muster" geprueft.
# Damit faellt auf, wenn die Schranke aus dem RICHTIGEN Ergebnis den FALSCHEN
# Grund macht.
#
# Es wird nichts im Projektbaum angelegt. Das Verzeichnis kommt aus TMPDIR
# (oder $ENV{SCHRANKE_TMP}) und wird am Ende geloescht.
#
use strict;
use warnings;
use FindBin;
use File::Temp qw(tempdir);
use File::Path qw(make_path);
use Cwd qw(getcwd abs_path);

my $laut = grep { $_ eq '-v' } @ARGV;

my $SCHRANKE = "$FindBin::Bin/pruefe-branch.pl";
-f $SCHRANKE or die "Schranke nicht gefunden: $SCHRANKE\n";
$SCHRANKE = abs_path($SCHRANKE);

# Kein Aufruf darf auf eine Eingabe warten - auch nicht in den Wegwerf-Repos.
$ENV{GIT_TERMINAL_PROMPT} = '0';
$ENV{GIT_ASKPASS}         = 'echo';
$ENV{SSH_ASKPASS}         = 'echo';
$ENV{GIT_SSH_COMMAND}     = 'ssh -oBatchMode=yes';
$ENV{GCM_INTERACTIVE}     = 'never';
# Der Hook des ECHTEN Projekts darf in den Wegwerf-Repos nicht mitlaufen.
delete $ENV{GIT_DIR};
delete $ENV{GIT_WORK_TREE};

# --- git ohne Shell ------------------------------------------------------------

sub git {
    my @arg = @_;
    my $pid = open(my $fh, '-|');
    die "fork: $!\n" unless defined $pid;
    if (!$pid) {
        open(STDERR, '>', '/dev/null') or open(STDERR, '>', 'NUL');
        exec('git', @arg) or exit 127;
    }
    local $/;
    my $aus = <$fh>;
    close $fh;
    return defined $aus ? $aus : '';
}

sub schreib {
    my ($pfad, $text) = @_;
    open(my $f, '>:raw', $pfad) or die "schreiben $pfad: $!\n";
    print $f $text;
    close $f;
}

# Ein Commit im aktuellen Verzeichnis. --no-verify, damit der Hook des
# Projekts hier nichts zu sagen hat.
sub commit {
    my ($datei, $text, $nachricht) = @_;
    schreib($datei, $text);
    git('add', '--', $datei);
    git('commit', '-q', '--no-verify', '-m', $nachricht);
}

# Ruft die Schranke im aktuellen Verzeichnis auf -> ($rueckgabewert, $meldung).
sub schranke_lauf {
    my @arg = @_;
    my $pid = open(my $fh, '-|');
    die "fork: $!\n" unless defined $pid;
    if (!$pid) { exec($^X, $SCHRANKE, @arg) or exit 127; }
    local $/;
    my $aus = <$fh>;
    close $fh;
    return (($? >> 8), (defined $aus ? $aus : ''));
}

sub grundeinstellung {
    git('config', 'user.email', 'test@example.invalid');
    git('config', 'user.name',  'Testsammlung');
    git('config', 'core.autocrlf', 'false');
    git('config', 'commit.gpgsign', 'false');
}

# --------------------------------------------------------------- die Faelle
#
# Jeder Fall bekommt ein frisches Paar (Server, Klon), baut darin seine Lage und
# gibt zurueck, in welchem Verzeichnis die Schranke laufen soll.
#
#   erwartet : 0 durchlassen, 1 abbrechen
#   muster   : Regexp, die in der Meldung stehen MUSS (optional)

my @faelle = (

{ schl => 'a', erwartet => 0,
  name => 'Branch ist eigenstaendig und lebt',
  muster => qr/eigenstaendig und lebt/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'arbeit');
      commit('a.txt', "eigene Arbeit\n", 'eigener Commit');
      git('push', '-q', '-u', 'origin', 'arbeit');
      return $klon;
  } },

{ schl => 'b', erwartet => 1,
  name => 'Branch ist bereits in origin/main enthalten (zusammengefuehrt)',
  muster => qr/bereits in origin\/main enthalten/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'arbeit');
      commit('b.txt', "Arbeit\n", 'Arbeit auf dem Zweig');
      git('push', '-q', '-u', 'origin', 'arbeit');
      # Gregor fuehrt zusammen: main nimmt den Zweig auf und geht weiter.
      git('switch', '-q', 'main');
      git('merge', '-q', '--no-ff', '--no-verify', '-m', 'Zusammenfuehrung', 'arbeit');
      git('push', '-q', 'origin', 'main');
      git('switch', '-q', 'arbeit');            # ... und hier wird weitergearbeitet
      git('fetch', '-q', '--prune', 'origin');
      return $klon;
  } },

{ schl => 'c', erwartet => 1,
  name => 'Gegenstueck auf dem Server geloescht ([gone])',
  muster => qr/gibt es auf dem Server nicht mehr/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'arbeit');
      commit('c.txt', "eigene Arbeit\n", 'eigener Commit');
      git('push', '-q', '-u', 'origin', 'arbeit');
      # Gregor loescht den Zweig auf dem Server, ohne ihn aufzunehmen.
      git('-C', $server, 'branch', '-q', '-D', 'arbeit');
      git('fetch', '-q', '--prune', 'origin');
      return $klon;
  } },

{ schl => 'd', erwartet => 0,
  name => 'auf main selbst',
  muster => qr/auf main - in Ordnung/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      commit('d.txt', "Arbeit auf main\n", 'auf main');
      return $klon;
  } },

{ schl => 'e', erwartet => 1,
  name => 'abgeloester HEAD',
  muster => qr/abgeloester HEAD/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      commit('e.txt', "eins\n", 'einer mehr');
      my $sha = git('rev-parse', 'HEAD'); $sha =~ s/\s+\z//;
      git('checkout', '-q', '--detach', $sha);
      return $klon;
  } },

{ schl => 'f', erwartet => 0,
  name => 'kein origin vorhanden - durchlassen, aber melden',
  muster => qr/kein origin\/main/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'arbeit');
      commit('f.txt', "Arbeit\n", 'eigener Commit');
      git('remote', 'remove', 'origin');
      git('update-ref', '-d', 'refs/remotes/origin/main');
      return $klon;
  } },

# --- Randfaelle, die beim Nachmessen aufgefallen sind -------------------------

{ schl => 'g', erwartet => 0,
  name => 'FRISCH abgezweigt, noch kein eigener Commit (der Fehler der ersten Fassung)',
  muster => qr/frisch abgezweigt/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'neu', 'origin/main');
      return $klon;
  } },

{ schl => 'h', erwartet => 1,
  name => 'zusammengefuehrt UND auf dem Server geloescht (die Lage vom 31.08., 09:06)',
  muster => qr/bereits in origin\/main enthalten/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'arbeit');
      commit('h.txt', "Arbeit\n", 'Arbeit auf dem Zweig');
      git('push', '-q', '-u', 'origin', 'arbeit');
      git('switch', '-q', 'main');
      git('merge', '-q', '--no-ff', '--no-verify', '-m', 'Zusammenfuehrung', 'arbeit');
      git('push', '-q', 'origin', 'main');
      git('-C', $server, 'branch', '-q', '-D', 'arbeit');
      git('switch', '-q', 'arbeit');
      git('fetch', '-q', '--prune', 'origin');
      return $klon;
  } },

{ schl => 'i', erwartet => 1,
  name => 'Zweig ist veraltet: main ist weiter, der Zweig hat nichts Eigenes',
  muster => qr/bereits in origin\/main enthalten/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'alt');          # steht auf der alten Spitze
      git('switch', '-q', 'main');
      commit('i.txt', "main geht weiter\n", 'main weiter');
      git('push', '-q', 'origin', 'main');
      git('switch', '-q', 'alt');
      git('fetch', '-q', '--prune', 'origin');
      return $klon;
  } },

{ schl => 'j', erwartet => 0,
  name => 'Branch mit runden und geschweiften Klammern im Namen (Shell-Falle)',
  muster => qr/eigenstaendig und lebt/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'zweig(1){a}');
      commit('j.txt', "Arbeit\n", 'eigener Commit');
      git('push', '-q', '-u', 'origin', 'zweig(1){a}');
      return $klon;
  } },

{ schl => 'k', erwartet => 0,
  name => 'noch gar kein Commit (leeres Repo, erster Commit steht an)',
  muster => qr/noch keinen Commit/,
  bauen => sub {
      my ($server, $klon, $leer) = @_;
      chdir $leer;
      git('init', '-q', '-b', 'arbeit', '.');
      grundeinstellung();
      return $leer;
  } },

{ schl => 'l', erwartet => 0,
  name => 'eigener Arbeitsbaum (worktree) auf einem lebenden Zweig',
  muster => qr/eigenstaendig und lebt/,
  bauen => sub {
      my ($server, $klon, $leer) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'arbeit');
      commit('l.txt', "Arbeit\n", 'eigener Commit');
      git('push', '-q', '-u', 'origin', 'arbeit');
      git('switch', '-q', 'main');
      git('worktree', 'add', '-q', $leer, 'arbeit');
      return $leer;
  } },

{ schl => 'm', erwartet => 1,
  name => 'eigener Arbeitsbaum auf einem zusammengefuehrten Zweig',
  muster => qr/bereits in origin\/main enthalten/,
  bauen => sub {
      my ($server, $klon, $leer) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'arbeit');
      commit('m.txt', "Arbeit\n", 'eigener Commit');
      git('push', '-q', '-u', 'origin', 'arbeit');
      git('switch', '-q', 'main');
      git('merge', '-q', '--no-ff', '--no-verify', '-m', 'Zusammenfuehrung', 'arbeit');
      git('push', '-q', 'origin', 'main');
      git('fetch', '-q', '--prune', 'origin');
      git('worktree', 'add', '-q', $leer, 'arbeit');
      return $leer;
  } },

{ schl => 'o', erwartet => 0,
  name => 'Rebase mit Konflikt laeuft - abgeloester HEAD ist hier normal',
  muster => qr{Rebase/Cherry-Pick laeuft},
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      commit('streit.txt', "urstand\n", 'Urstand');
      git('switch', '-q', '-c', 'arbeit');
      commit('streit.txt', "vom Zweig\n", 'Zweig aendert');
      git('switch', '-q', 'main');
      commit('streit.txt', "von main\n", 'main aendert');
      git('switch', '-q', 'arbeit');
      git('rebase', 'main');            # bleibt im Konflikt stehen, HEAD abgeloest
      return $klon;
  } },

{ schl => 'n', erwartet => 1,
  name => 'Zweig ohne Gegenstueck, zusammengefuehrt (nie gepusht, dann von Hand nach main)',
  muster => qr/bereits in origin\/main enthalten/,
  bauen => sub {
      my ($server, $klon) = @_;
      chdir $klon;
      git('switch', '-q', '-c', 'arbeit');       # kein push, also kein Gegenstueck
      commit('n.txt', "Arbeit\n", 'Arbeit auf dem Zweig');
      git('switch', '-q', 'main');
      git('merge', '-q', '--no-ff', '--no-verify', '-m', 'Zusammenfuehrung', 'arbeit');
      git('push', '-q', 'origin', 'main');
      git('switch', '-q', 'arbeit');
      git('fetch', '-q', '--prune', 'origin');
      return $klon;
  } },

);

# ------------------------------------------------------------- Durchlauf

my $wurzel = exists $ENV{SCHRANKE_TMP}
           ? do { make_path($ENV{SCHRANKE_TMP}); tempdir("pruefebranch_XXXXXX", DIR => $ENV{SCHRANKE_TMP}, CLEANUP => 1) }
           : tempdir("pruefebranch_XXXXXX", TMPDIR => 1, CLEANUP => 1);
my $zurueck = getcwd();

my ($gruen, $rot) = (0, 0);
my @rote;

printf("%-4s %-6s %-70s %s\n", 'Fall', 'Ergeb', 'Beschreibung', 'erwartet');
print '-' x 100, "\n";

for my $f (@faelle) {
    my $server = "$wurzel/$f->{schl}/server.git";
    my $klon   = "$wurzel/$f->{schl}/klon";
    my $leer   = "$wurzel/$f->{schl}/zweiter";
    make_path($server, $klon, $leer);

    # Server: ein bares Repo mit einem Grundstand auf main.
    chdir($server) or die "chdir $server: $!\n";
    git('init', '-q', '--bare', '-b', 'main', '.');

    chdir($klon) or die "chdir $klon: $!\n";
    git('init', '-q', '-b', 'main', '.');
    grundeinstellung();
    git('remote', 'add', 'origin', $server);
    commit('grund.txt', "Grundstand\n", 'Grundstand');
    git('push', '-q', '-u', 'origin', 'main');

    my $ort = $f->{bauen}->($server, $klon, $leer);

    # Jeder Fall wird ZWEIMAL gefahren:
    #   hart      - so laeuft die Schranke im Hook; hier zaehlt der Rueckgabewert.
    #   --melden  - hier steht die Begruendung, und abgebrochen werden darf NIE.
    # Die Begruendung mitzupruefen faengt den Fall ab, dass die Schranke aus dem
    # richtigen Ergebnis den falschen Grund macht.
    chdir($ort) or die "chdir $ort: $!\n";

    my ($rueck,  $stumm)   = schranke_lauf();
    my ($rueck_m, $meldung) = schranke_lauf('--melden');

    my $ok    = ($rueck == $f->{erwartet});
    my $grund = $ok ? '' : "Rueckgabe $rueck, erwartet $f->{erwartet}";

    if ($ok and $rueck_m != 0) {
        $ok = 0;
        $grund = "--melden hat mit $rueck_m abgebrochen - es darf nie abbrechen";
    }
    if ($ok and $f->{muster} and $meldung !~ $f->{muster}) {
        $ok = 0;
        $grund = "Rueckgabe stimmt, aber die Begruendung passt nicht zu $f->{muster}";
    }
    $ok ? $gruen++ : ($rot++, push @rote, $f);

    printf("%-4s %-6s %-70s %s\n",
           $f->{schl}, ($ok ? 'GRUEN' : 'ROT'), $f->{name},
           ($f->{erwartet} ? 'abbrechen' : 'durchlassen'));

    if (!$ok or $laut) {
        my $t = $meldung;
        $t =~ s/^\s+|\s+$//g;
        $t =~ s/\n/\n       /g;
        print "       $grund\n" if length $grund;
        print "       Rueckgabe $rueck\n" if $laut and !length $grund;
        print "       $t\n" if length $t;
    }

    chdir($zurueck) or die "chdir zurueck: $!\n";
}

print '-' x 100, "\n";
printf("%d Faelle: %d gruen, %d rot\n", scalar(@faelle), $gruen, $rot);

if ($rot) {
    print "\nROT: ", join(', ', map { $_->{schl} } @rote), "\n";
    print "Die Schranke entscheidet in diesen Faellen falsch. NICHT committen,\n";
    print "bevor das behoben ist - eine Schranke, die grundlos anschlaegt, wird\n";
    print "umgangen; eine, die schweigt, ist wertlos.\n";
    exit 1;
}
print "Die Schranke entscheidet in allen Faellen richtig.\n";
exit 0;
