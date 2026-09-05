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

my $ohne_holen = grep { $_ eq '--ohne-holen' } @ARGV;

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

# --- 3. Nicht committet? -------------------------------------------------------

my @zeilen = grep { length } split /\n/, git('status', '--porcelain');
my @offen  = grep { !/^\?\?/ } @zeilen;
my @neu    = grep {  /^\?\?/ } @zeilen;

printf("  %-28s %d\n", "nicht committet", scalar @offen);
if (@offen) {
    push @mangel, sprintf("%d Datei(en) sind geaendert, aber nicht committet", scalar @offen);
    print "      $_\n" for @offen[0 .. ($#offen > 7 ? 7 : $#offen)];
    print "      ... und " . (@offen - 8) . " weitere\n" if @offen > 8;
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

my $haupt;
for my $k ('origin/main', 'origin/master') {
    if (length git('rev-parse', '--verify', '--quiet', $k)) { $haupt = $k; last; }
}

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

        my @z = grep { length } split /\n/, git_in($p, 'status', '--porcelain');
        my $n = grep { !/^\?\?/ } @z;
        my @sagen;
        push @sagen,  "$n nicht committet" if $n;
        push @mangel, "Arbeitsbaum $p hat $n nicht committete Datei(en)" if $n;

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
                    push @hinweis, "Arbeitsbaum $p steht auf '$bn', und der ist bereits in $haupt - dort gehoert auf main gewechselt";
                }
            }

            if (!length $up) {
                # Kein Gegenstueck. Hat der Zweig eigene Commits gegenueber main?
                my $eigen = defined $haupt
                          ? git_in($p, 'rev-list', '--count', "$haupt..refs/heads/$bn") : '';
                $eigen = 0 unless $eigen =~ /^\d+$/;
                if ($eigen) {
                    push @sagen,  "'$bn': $eigen Commit(s) nirgends gepusht";
                    push @mangel, "Arbeitsbaum $p ('$bn') hat $eigen Commit(s), die nirgends gepusht sind";
                }
                elsif (!$verschmolzen) {
                    push @sagen, "'$bn': kein Gegenstueck, aber nichts Eigenes";
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
