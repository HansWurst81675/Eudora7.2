#!/usr/bin/perl
#
# Schranke: verhindert Commits auf einen Branch, der schon zusammengefuehrt
# oder dessen Gegenstueck auf dem Server geloescht ist.
#
#   perl tools/pruefe-branch.pl            # als erster Schritt im pre-commit
#   perl tools/pruefe-branch.pl --melden   # nur berichten, nie abbrechen
#
# Rueckgabewert 0 = durchgelassen.  1 = COMMIT ABGEBROCHEN.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 31.08.2026 hat Gregor um 09:03 den Branch darstellung-und-menue nach main
# zusammengefuehrt und angekuendigt, ihn zu loeschen. Um 09:06 - drei Minuten
# spaeter - habe ich einen weiteren Commit auf genau diesen Branch gelegt und
# gepusht. Der Commit stand damit auf einem Zweig, den es kurz darauf nicht mehr
# gab. Inhaltlich ging nichts verloren, weil eine spaetere Sitzung dieselbe
# Aussage unabhaengig nachgezogen hat - aber das war Glueck, nicht Sorgfalt.
#
# Gregors Worte am 05.09.2026:
#
#   "ich kuendige ja immer an, wenn ich einen branch merge und loesche.
#    es sollte also alles commited und gepusht sein, klar?"
#
# Die Ansage war da. Ausgewertet wurde sie nicht: ich habe nach dem Merge nicht
# nachgesehen, auf welchem Branch ich stehe, sondern weitergearbeitet wie vorher.
# Eine Ansage, die niemand prueft, ist keine Sicherung. Deshalb prueft es jetzt
# git bei jedem Commit (Befund X-5).
#
# DREI FAELLE, ALLE HART
#
#   1. Abgeloester HEAD. Der Commit haengt an keinem Branch.
#
#   2. Der aktuelle Branch ist ECHT in origin/main enthalten - also enthalten
#      UND nicht dessen Spitze. Dann ist er entweder zusammengefuehrt oder
#      veraltet; in beiden Faellen zaehlt git ihn zu den erledigten, und beim
#      naechsten Aufraeumen faellt er weg.
#
#   3. Der Branch hatte ein Gegenstueck auf dem Server, und das ist weg.
#      Dann ist er geloescht worden, waehrend hier weitergearbeitet wurde.
#
# WARUM "ECHT ENTHALTEN" UND NICHT NUR "ENTHALTEN"
#
# Die erste Fassung fragte bloss "ist HEAD ein Vorfahr von origin/main". Das
# trifft auch auf jeden FRISCH abgezweigten Branch zu: unmittelbar nach
# "git switch -c neu origin/main" ist HEAD gleich origin/main, also Vorfahr.
# Die Schranke haette damit den ERSTEN Commit jedes neuen Branches abgebrochen -
# nachgemessen am 05.09.2026, sie tat es. Eine Schranke, die grundlos anschlaegt,
# wird umgangen und ist dann wertlos; das ist in diesem Projekt schon einmal
# passiert (X-1/PR-1). Deshalb ist die Spitze ausgenommen: gleichauf ist
# harmlos, dahinter ist der Fehler.
#
# KEIN SHELL-AUFRUF
#
# git wird ohne Shell gestartet (fork + exec, wie in tools/pruefe-bytes.pl).
# Damit bekommt die Shell die Klammern in "--format=%(upstream:track)" gar nicht
# erst zu sehen, und kein Branchname kann als Sonderzeichen wirken. Ausserdem
# darf kein Aufruf auf eine Eingabe warten - dafuer sorgen die Umgebungswerte
# unten. Vom Server geholt wird hier nichts: ein Hook haengt nicht am Netz.
#
use strict;
use warnings;

my $nur_melden = grep { $_ eq '--melden' } @ARGV;

# Nichts darf auf eine Eingabe warten. Ein Hook, der auf eine Passwortfrage
# wartet, blockiert den Commit ohne sichtbaren Grund.
$ENV{GIT_TERMINAL_PROMPT} = '0';
$ENV{GIT_ASKPASS}         = 'echo';
$ENV{SSH_ASKPASS}         = 'echo';
$ENV{GIT_SSH_COMMAND}     = 'ssh -oBatchMode=yes';
$ENV{GCM_INTERACTIVE}     = 'never';
# Nur lesen: nicht an der Index-Sperre ruetteln, waehrend andere Baeume arbeiten.
$ENV{GIT_OPTIONAL_LOCKS}  = '0';

# --- git ohne Shell ------------------------------------------------------------

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

sub git {                            # Ausgabe, hinten beschnitten
    my ($a) = git_lauf(@_);
    $a =~ s/\s+\z//;
    return $a;
}

sub git_rc {                         # nur der Rueckgabewert
    my (undef, $rc) = git_lauf(@_);
    return $rc;
}

sub melde { print $_[0] if $nur_melden; }

# --- Ueberhaupt ein Arbeitsbaum? -----------------------------------------------

if (git('rev-parse', '--is-inside-work-tree') ne 'true') {
    melde("pruefe-branch: kein git-Arbeitsbaum - uebersprungen\n");
    exit 0;
}

# --- Fall 1: abgeloester HEAD? -------------------------------------------------
#
# symbolic-ref statt "rev-parse --abbrev-ref HEAD": es liefert auch auf einem
# noch leeren Branch (vor dem allerersten Commit) den Namen, waehrend rev-parse
# dort mit einem Fehler aussteigt - die Pruefung fiele dann stillschweigend aus.

my ($branch, $rc_branch) = git_lauf('symbolic-ref', '--quiet', '--short', 'HEAD');
$branch =~ s/\s+\z//;

# Waehrend eines Rebase, Cherry-Pick oder einer Halbierung ist der HEAD von git
# selbst abgeloest. Wer dort committet, tut es innerhalb eines Vorgangs, der den
# Commit hinterher an einen Zweig haengt - da anzuschlagen waere ein Fehlalarm,
# und eine Schranke, die grundlos anschlaegt, wird umgangen.
sub vorgang_laeuft {
    my $g = git('rev-parse', '--git-dir');
    return 0 unless length $g;
    return 1 if -d "$g/rebase-merge" or -d "$g/rebase-apply";
    return 1 if -f "$g/CHERRY_PICK_HEAD" or -f "$g/REVERT_HEAD" or -f "$g/BISECT_LOG";
    return 0;
}

if (($rc_branch != 0 or !length $branch) and vorgang_laeuft()) {
    melde("pruefe-branch: Rebase/Cherry-Pick laeuft - abgeloester HEAD ist hier normal\n");
    exit 0;
}

if ($rc_branch != 0 or !length $branch) {
    my $kurz = git('rev-parse', '--short', 'HEAD');
    print "\n";
    print "  ABBRUCH: abgeloester HEAD (detached HEAD)" . (length $kurz ? " auf $kurz" : "") . ".\n";
    print "\n";
    print "  Ein Commit hier haengt an keinem Branch und ist nach dem naechsten\n";
    print "  Wechsel nur noch ueber die Reflog-Nummer zu finden.\n";
    print "\n";
    print "  Ausweg:  git switch -c <name>\n";
    print "\n";
    print "  (Bewusst trotzdem committen: git commit --no-verify)\n";
    print "\n";
    exit($nur_melden ? 0 : 1);
}

# --- Noch gar kein Commit? -----------------------------------------------------

my $kopf = git('rev-parse', '--verify', '--quiet', 'HEAD');
if (!length $kopf) {
    melde("pruefe-branch: '$branch' hat noch keinen Commit - nichts zu pruefen\n");
    exit 0;
}

# --- Fall 4: der Zweig IST main ------------------------------------------------
#
# Diese Stelle hiess bis zum 14.09.2026 "main selbst ist nie das Problem" und
# liess einen Commit auf main mit "in Ordnung" durch. Gemeint war: wer AUF main
# steht, kann nicht auf einem erledigten Zweig stehen. Das stimmt - uebersehen
# war nur, dass das Committen auf main selbst verboten ist:
#
#   Gregor am 05.09.2026: "keine direkten aenderungen am main branch. ich werde
#   ihn sperren, damit du das nicht dauernd machen kannst."
#
# Die Sperre bei GitHub greift, aber erst beim PUSH. Am 14.09.2026 ist genau das
# eingetreten: ein Commit ging lokal durch, der Push wurde abgewiesen, und die
# Arbeit musste nachtraeglich auf einen Zweig verschoben werden. Der lokale Hook
# hatte dazu nichts gesagt - er hatte "in Ordnung" gemeldet.
#
# Eine Schranke, die den haeufigsten Fall ihrer eigenen Regel durchlaesst, ist
# keine Schranke. Deshalb bricht sie hier ab.
#
# Der Ausweg steht in der Meldung: wer bewusst auf main committen will - Gregor
# beim Zusammenfuehren von Hand - nimmt --no-verify. Das ist eine Entscheidung,
# kein Versehen, und genau der Unterschied, um den es geht.

if ($branch eq 'main' or $branch eq 'master') {
    print "\n";
    print "  COMMIT ABGEBROCHEN - '$branch' nimmt keine direkten Commits\n";
    print "\n";
    print "  Gregor am 05.09.2026: \"keine direkten aenderungen am main\n";
    print "  branch. ich werde ihn sperren, damit du das nicht dauernd\n";
    print "  machen kannst.\"\n";
    print "\n";
    print "  Jede Aenderung geht ueber einen eigenen Zweig, dessen NAME\n";
    print "  vorher abgestimmt ist (tools/ZWEIGE.md). Gregor merged.\n";
    print "\n";
    print "      git switch -c <abgestimmter-name> origin/main\n";
    print "      git commit ...\n";
    print "\n";
    print "  Die Aenderungen bleiben dabei erhalten - switch nimmt sie mit.\n";
    print "\n";
    print "  (Bewusst trotzdem committen: git commit --no-verify)\n";
    print "\n";
    exit($nur_melden ? 0 : 1);
}

# --- Fall 2: schon zusammengefuehrt? -------------------------------------------
#
# Gemessen wird gegen origin/main, nicht gegen das lokale main - das lokale kann
# alt sein. Ist origin/main nicht da (frischer Klon ohne Gegenstelle, reines
# Arbeitsrepo), faellt diese Pruefung aus. Das wird GEMELDET, nicht als
# Entwarnung ausgegeben: eine Pruefung, die nicht stattgefunden hat, darf nicht
# aussehen wie eine bestandene.

my $haupt;
for my $k ('origin/main', 'origin/master') {
    if (length git('rev-parse', '--verify', '--quiet', $k)) { $haupt = $k; last; }
}

if (!defined $haupt) {
    print "  Hinweis: kein origin/main - ob '$branch' zusammengefuehrt ist, laesst\n";
    print "           sich hier nicht feststellen. Die Schranke laesst durch.\n";
    exit 0;
}

my $kopf_voll  = git('rev-parse', 'HEAD');
my $haupt_voll = git('rev-parse', $haupt);

# --is-ancestor: 0 = Vorfahr, 1 = nicht, alles andere = Fehler. Ein Fehler darf
# weder als "Vorfahr" durchgehen noch als Entwarnung.
my $rc_vorfahr = git_rc('merge-base', '--is-ancestor', 'HEAD', $haupt);

if ($rc_vorfahr != 0 and $rc_vorfahr != 1) {
    print "  Hinweis: 'git merge-base --is-ancestor' scheiterte (Rueckgabe $rc_vorfahr).\n";
    print "           Ob '$branch' zusammengefuehrt ist, bleibt ungeklaert.\n";
}
elsif ($rc_vorfahr == 0 and $kopf_voll eq $haupt_voll) {
    # Gleichstand: frisch abgezweigt, noch kein eigener Commit. Harmlos.
    melde("pruefe-branch: '$branch' steht auf der Spitze von $haupt - frisch abgezweigt\n");
}
elsif ($rc_vorfahr == 0) {
    my $kurz   = git('rev-parse', '--short', 'HEAD');
    my $hinter = git('rev-list', '--count', "HEAD..$haupt");
    print "\n";
    print "  ABBRUCH: der Branch '$branch' ist bereits in $haupt enthalten.\n";
    print "\n";
    print "  HEAD steht auf $kurz; $haupt enthaelt diesen Stand schon und ist\n";
    print "  $hinter Commit(s) weiter. Der Branch ist also zusammengefuehrt - oder\n";
    print "  nie abgezweigt und bloss veraltet. In beiden Faellen zaehlt git ihn zu\n";
    print "  den erledigten: ein Commit hier landet auf einem Zweig, der beim\n";
    print "  naechsten Aufraeumen weggeht. Genau der Fehler vom 31.08.2026, 09:06.\n";
    print "\n";
    print "  Ausweg - auf main wechseln und dort committen:\n";
    print "\n";
    print "      git stash\n";
    print "      git checkout main\n";
    print "      git pull\n";
    print "      git stash pop\n";
    print "\n";
    print "  Wenn es doch ein eigener neuer Branch werden soll:\n";
    print "\n";
    print "      git switch -c <neuer-name> $haupt\n";
    print "\n";
    print "  (Bewusst trotzdem committen: git commit --no-verify)\n";
    print "\n";
    exit($nur_melden ? 0 : 1);
}

# --- Fall 3: Gegenstueck auf dem Server geloescht? -----------------------------
#
# "[gone]" steht in %(upstream:track), sobald das verfolgte Gegenstueck fehlt.
# Das setzt voraus, dass vorher "git fetch --prune" gelaufen ist; ein Hook holt
# nicht selbst vom Server - das haengte jeden Commit ans Netz und koennte ihn
# minutenlang aufhalten. Deshalb steht der Hinweis in der Meldung, und
# tools/gesichert.pl holt vorher.
#
# Gefragt wird mit for-each-ref auf den vollen Refnamen: "branch --list" nimmt
# ein Muster, ein Refname ist keins.

my $upstream = git('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}');

if (length $upstream) {
    my $spur = git('for-each-ref', '--format=%(upstream:track)', "refs/heads/$branch");
    if ($spur =~ /\[gone\]/) {
        print "\n";
        print "  ABBRUCH: das Gegenstueck '$upstream' gibt es auf dem Server nicht mehr.\n";
        print "\n";
        print "  Der Branch ist geloescht worden, waehrend hier weitergearbeitet wurde.\n";
        print "  Alles, was jetzt hier committet wird, ist nur noch lokal.\n";
        print "\n";
        print "  Erst nachsehen, ob die eigenen Commits schon anderswo stecken:\n";
        print "\n";
        print "      git log --oneline $haupt..HEAD\n";
        print "\n";
        print "  Ist die Liste leer, ist nichts verloren - dann auf main wechseln.\n";
        print "  Steht etwas darin, gehoert es nach main uebertragen:\n";
        print "\n";
        print "      git rebase --onto $haupt $upstream $branch\n";
        print "\n";
        print "  (Bewusst trotzdem committen: git commit --no-verify)\n";
        print "\n";
        exit($nur_melden ? 0 : 1);
    }
}

# ---------------------------------------------------------------------------
# Ein Arbeitsbaum-Zweig muss SEINEN EIGENEN Upstream haben.
# ---------------------------------------------------------------------------
#
# Gregor am 13.09.2026 um 19:22:58: "was spielt ihr da fuer ein ping-pong?"
# Arbeitsbaeume sind dafuer da, dass drei Agenten sich nicht in die Quere
# kommen. Verfolgt der Zweig eines Agenten den Zweig eines ANDEREN, ist genau
# diese Trennung aufgehoben: sein "git push" landet auf fremdem Gebiet.
#
# Im Wegwerf-Repo gemessen, vier Faelle:
#
#   git checkout -B wt/x fix-imap_utf8          -> KEIN Upstream
#   git worktree add -b wt/x <pfad> <lokal>     -> KEIN Upstream
#   git push -u origin wt/x                     -> origin/wt/x          RICHTIG
#   git checkout -B wt/x origin/fix-imap_utf8   -> origin/fix-imap_utf8 FALSCH
#
# Eine LOKALE Basis vererbt nichts; eine REMOTE-Basis (mit "origin/" davor)
# setzt den Upstream auf sich selbst. Das ist der Weg, auf dem ein
# Agentenzweig an einem fremden Gegenstueck haengt.
#
# Die Faelle ganz ohne Upstream faengt die Pruefung weiter oben ab. Hier geht
# es um den Zweig, der einen HAT, aber den falschen.
if ($branch =~ m{^wt/(.+)$}) {
    my $eigen = "origin/wt/$1";
    if (length($upstream) && $upstream ne $eigen) {
        print "\n";
        print "  ABBRUCH: '$branch' verfolgt '$upstream' statt '$eigen'.\n";
        print "\n";
        print "  Ein Arbeitsbaum-Zweig, der ein FREMDES Gegenstueck verfolgt, hebt\n";
        print "  die Trennung auf, fuer die es Arbeitsbaeume ueberhaupt gibt: ein\n";
        print "  'git push' ohne Argumente landet auf dem fremden Zweig. Gregor am\n";
        print "  13.09.2026: \"was spielt ihr da fuer ein ping-pong?\"\n";
        print "\n";
        print "  Richtigstellen - eigenes Gegenstueck anlegen und daran binden:\n";
        print "\n";
        print "      git push -u origin $branch\n";
        print "\n";
        print "  Ursache ist fast immer eine Basis mit 'origin/' davor beim\n";
        print "  Anlegen (git checkout -B $branch origin/<basis>). Eine LOKALE\n";
        print "  Basis vererbt nichts - siehe den Messblock ueber dieser Pruefung.\n";
        print "\n";
        print "  (Bewusst trotzdem committen: git commit --no-verify)\n";
        print "\n";
        exit($nur_melden ? 0 : 1);
    }
}

# ---------------------------------------------------------------------------
# Ist der Zweigname mit Gregor abgestimmt? MELDET NUR, weist nicht ab.
# ---------------------------------------------------------------------------
#
# Gregor am 07.09.2026: "ziele-berichtigen - der branch ist illegal und wird
# geloescht. den haben wir gar nicht vereinbart." Die Lehre dazu steht seit
# dem 11.09.2026 in Arbeitsweise/zweig-vorher-abstimmen.md und hatte bis zum
# 13.09.2026 die Zeile "Schranke: keine". An diesem einen Tag habe ich dann
# DREI Zweige selbst benannt: release-050-protokoll, lehre-erfolgsmeldung und
# ziel-kriterium-2. Dass eine aufgeschriebene Regel dreimal an einem Tag
# gebrochen wird, belegt den fehlenden Ausloeser, nicht die fehlende Einsicht.
#
# Bewusst nur MELDEND: eine Schranke, die jeden Commit auf einem neuen Zweig
# blockiert, wird umgangen - und faengt dann auch die Faelle nicht mehr, fuer
# die es sie gibt (Arbeitsweise/pruefstand-kann-blind-sein.md). Der erste
# Commit kommt frueh genug, um noch umzubenennen.
{
    my $wurzel = git('rev-parse', '--show-toplevel');
    $wurzel =~ s/\Q${\ chr(92)}\E/\//g if length $wurzel;
    my $liste = length($wurzel) ? "$wurzel/tools/ZWEIGE.md" : "";
    if (length($branch) && $branch !~ m{^wt/} && length($liste) && -f $liste) {
        my $inhalt = "";
        if (open(my $h, "<:raw", $liste)) { local $/; $inhalt = <$h>; close $h; }
        unless ($inhalt =~ /`\Q$branch\E`/) {
            print "\n";
            print "  HINWEIS: '$branch' steht nicht in tools/ZWEIGE.md.\n";
            print "\n";
            print "  Ein Zweig wird erst angelegt, wenn Gregor den NAMEN bestaetigt hat\n";
            print "  (07.09.2026: \"den haben wir gar nicht vereinbart\"). Am 13.09.2026\n";
            print "  sind drei Zweige an einem Tag an dieser Regel vorbeigegangen.\n";
            print "\n";
            print "  Ist der Name abgestimmt? Dann eintragen:  tools/ZWEIGE.md\n";
            print "  Ist er es nicht? Dann jetzt fragen - der erste Commit ist frueh\n";
            print "  genug zum Umbenennen.\n";
            print "\n";
        }
    }
}

melde("pruefe-branch: '$branch' ist eigenstaendig und lebt - in Ordnung\n");
exit 0;
