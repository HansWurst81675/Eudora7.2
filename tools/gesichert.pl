#!/usr/bin/perl
#
# Beantwortet EINE Frage: kann Gregor jetzt zusammenfuehren und abschalten,
# ohne dass etwas verlorengeht?
#
#   perl tools/gesichert.pl
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
#
# Es PRUEFT nur und aendert nichts. Zum Erzwingen dient tools/pruefe-branch.pl
# im pre-commit-Hook.
#
use strict;
use warnings;

sub git {
    my $a = `git @_ 2>/dev/null`;
    chomp $a if defined $a;
    return defined $a ? $a : '';
}

my @mangel;
my @hinweis;

print "\n";
print "  Ist alles gesichert?\n";
print "  " . ("-" x 68) . "\n\n";

# --- 0. Ueberhaupt ein Repo? --------------------------------------------------

my $wurzel = git('rev-parse', '--show-toplevel');
if (!length $wurzel) {
    print "  Kein git-Verzeichnis.\n\n";
    exit 1;
}

# --- 1. Auf welchem Branch? ---------------------------------------------------

my $branch = git('rev-parse', '--abbrev-ref', 'HEAD');
my $kopf   = git('rev-parse', '--short', 'HEAD');

printf("  %-28s %s\n", "Branch", ($branch eq 'HEAD' ? "ABGELOESTER HEAD ($kopf)" : "$branch ($kopf)"));
push @mangel, "abgeloester HEAD - der Commit haengt an keinem Branch" if $branch eq 'HEAD';

# --- 2. Server-Stand holen ----------------------------------------------------
#
# Ohne --prune bleibt ein geloeschtes Gegenstueck als lebend stehen, und genau
# darum geht es hier.

system('git fetch --prune --quiet origin >/dev/null 2>&1');

# --- 3. Nicht committet? ------------------------------------------------------

my @offen = grep { length && !/^\?\?/ } split /\n/, git('status', '--porcelain');
my @neu   = grep { /^\?\?/ }            split /\n/, git('status', '--porcelain');

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

# --- 4. Nicht gepusht? --------------------------------------------------------

my $upstream = git('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}');

if (!length $upstream) {
    printf("  %-28s %s\n", "Gegenstueck auf dem Server", "KEINS");
    push @mangel, "der Branch '$branch' ist nirgends gepusht - er lebt nur hier";
}
else {
    # Die Klammern in --format muessen vor der Shell geschuetzt werden, sonst
    # bricht sh mit "syntax error near unexpected token `('" ab.
    my $zeile = git('branch', "--format='%(refname:short) %(upstream:track)'", '--list', $branch);
    if ($zeile =~ /\[gone\]/) {
        printf("  %-28s %s\n", "Gegenstueck auf dem Server", "GELOESCHT ($upstream)");
        push @mangel, "'$upstream' ist geloescht - alles hier ist nur noch lokal";
    }
    else {
        my $vor = git('rev-list', '--count', "$upstream..HEAD");
        printf("  %-28s %s\n", "nicht gepusht", ($vor ? "$vor Commit(s)" : "0"));
        push @mangel, "$vor Commit(s) sind nicht gepusht" if $vor;
    }
}

# --- 5. Steckt der Stand schon in origin/main? --------------------------------

my $hat_main = git('rev-parse', '--verify', '--quiet', 'origin/main');

if (length $hat_main and $branch ne 'main' and $branch ne 'HEAD') {
    my $drin = (system('git merge-base --is-ancestor HEAD origin/main >/dev/null 2>&1') == 0);
    if ($drin) {
        printf("  %-28s %s\n", "in origin/main enthalten", "JA - der Branch ist zusammengefuehrt");
        push @hinweis, "'$branch' ist bereits in origin/main - hier gehoert nicht mehr gearbeitet";
    }
    else {
        my $eigen = git('rev-list', '--count', 'origin/main..HEAD');
        printf("  %-28s %s\n", "in origin/main enthalten", "nein, $eigen eigene(r) Commit(s)");
    }
}

# --- 6. Andere Arbeitsbaeume ---------------------------------------------------
#
# Ein Agent in einem eigenen Worktree kann uncommittete Arbeit halten, die beim
# Abschalten verlorengeht. Sie erscheint NICHT in "git status" dieses Baums.

my @wt;
my $akt;
for my $z (split /\n/, git('worktree', 'list', '--porcelain')) {
    $akt = $1 if $z =~ /^worktree (.+)$/;
    push @wt, $akt if $z =~ /^branch / and defined $akt and $akt ne $wurzel;
}

if (@wt) {
    printf("  %-28s %d\n", "weitere Arbeitsbaeume", scalar @wt);
    for my $p (@wt) {
        my $n = `git -C "$p" status --porcelain 2>/dev/null | grep -vc '^??'`;
        chomp $n; $n = 0 unless $n =~ /^\d+$/;
        my $b = `git -C "$p" rev-parse --abbrev-ref HEAD 2>/dev/null`; chomp $b;
        printf("      %-52s %s\n", $p, ($n ? "$n nicht committet" : "sauber"));
        push @mangel, "Arbeitsbaum $p hat $n nicht committete Datei(en)" if $n;
    }
}

# --- Urteil -------------------------------------------------------------------

print "\n  " . ("-" x 68) . "\n\n";

if (@mangel) {
    print "  NICHT GESICHERT:\n\n";
    print "    - $_\n" for @mangel;
    print "\n";
    if (@hinweis) { print "  Ausserdem:\n\n"; print "    - $_\n" for @hinweis; print "\n"; }
    exit 1;
}

print "  GESICHERT. Committet, gepusht, keine offenen Arbeitsbaeume.\n";
if (@hinweis) { print "\n  Zur Kenntnis:\n\n"; print "    - $_\n" for @hinweis; }
print "\n";
exit 0;
