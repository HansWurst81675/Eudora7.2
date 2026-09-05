#!/usr/bin/perl
#
# Schranke: verhindert Commits auf einen Branch, der schon zusammengefuehrt
# oder dessen Gegenstueck auf dem Server geloescht ist.
#
#   perl tools/pruefe-branch.pl            # als pre-commit-Schritt
#   perl tools/pruefe-branch.pl --melden   # nur berichten, nie abbrechen
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
#    es sollte also alles commited und gepushed sein, klar?"
#
# Die Ansage war da. Ausgewertet wurde sie nicht: ich habe nach dem Merge nicht
# nachgesehen, auf welchem Branch ich stehe, sondern weitergearbeitet wie vorher.
# Eine Ansage, die niemand prueft, ist keine Sicherung. Deshalb prueft es jetzt
# git bei jedem Commit.
#
# ZWEI FAELLE, BEIDE HART
#
#   1. Der aktuelle Branch ist bereits vollstaendig in origin/main enthalten.
#      Dann ist er zusammengefuehrt; jeder weitere Commit landet auf einem
#      toten Zweig.
#
#   2. Der Branch hatte ein Gegenstueck auf dem Server, und das ist weg.
#      Dann ist er geloescht worden, waehrend hier weitergearbeitet wurde.
#
# In beiden Faellen bricht die Schranke ab und nennt den Ausweg. Wer den Commit
# trotzdem will, nimmt --no-verify - dann aber mit Wissen, nicht aus Versehen.
#
use strict;
use warnings;

my $nur_melden = grep { $_ eq '--melden' } @ARGV;

sub git {
    my $b = join(' ', @_);
    my $a = `git $b 2>/dev/null`;
    chomp $a if defined $a;
    return defined $a ? $a : '';
}

# --- Wo stehen wir? -----------------------------------------------------------

my $branch = git('rev-parse', '--abbrev-ref', 'HEAD');

if (!length $branch) {
    print "pruefe-branch: kein git-Verzeichnis - uebersprungen\n" if $nur_melden;
    exit 0;
}

if ($branch eq 'HEAD') {
    print "\n";
    print "  ACHTUNG: abgeloester HEAD (detached HEAD).\n";
    print "  Ein Commit hier haengt an keinem Branch und ist nach dem naechsten\n";
    print "  Wechsel nur noch ueber die Reflog-Nummer zu finden.\n";
    print "\n";
    print "  Ausweg:  git switch -c <name>\n";
    print "\n";
    exit($nur_melden ? 0 : 1);
}

# main selbst ist nie das Problem.
if ($branch eq 'main' or $branch eq 'master') {
    print "pruefe-branch: auf $branch - in Ordnung\n" if $nur_melden;
    exit 0;
}

# --- Fall 1: schon zusammengefuehrt? ------------------------------------------
#
# Gemessen wird gegen origin/main, nicht gegen das lokale main - das lokale kann
# alt sein. Ist origin/main nicht da, faellt die Pruefung aus; dann ist sie
# gegenstandslos, nicht stillschweigend gruen.

my $hat_origin_main = git('rev-parse', '--verify', '--quiet', 'origin/main');

if (length $hat_origin_main) {
    my $rc = system('git merge-base --is-ancestor HEAD origin/main >/dev/null 2>&1');
    if ($rc == 0) {
        my $kurz = git('rev-parse', '--short', 'HEAD');
        print "\n";
        print "  ABBRUCH: der Branch '$branch' ist bereits in origin/main enthalten.\n";
        print "\n";
        print "  HEAD steht auf $kurz, und origin/main enthaelt diesen Stand schon.\n";
        print "  Der Branch ist also zusammengefuehrt. Ein Commit hier landet auf\n";
        print "  einem Zweig, der geloescht wird - genau der Fehler vom 31.08.2026,\n";
        print "  09:06 Uhr.\n";
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
        print "      git switch -c <neuer-name> main\n";
        print "\n";
        print "  (Bewusst trotzdem committen: git commit --no-verify)\n";
        print "\n";
        exit($nur_melden ? 0 : 1);
    }
}

# --- Fall 2: Gegenstueck auf dem Server geloescht? ----------------------------
#
# "gone" steht in der Kurzuebersicht, sobald das verfolgte Gegenstueck fehlt.
# Das setzt voraus, dass jemand vorher "git fetch --prune" gelaufen ist -
# deshalb wird der Hinweis mitgegeben, statt Entwarnung zu geben.

my $upstream = git('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}');

if (length $upstream) {
    # Klammern vor der Shell schuetzen - sonst bricht sh mit
    # "syntax error near unexpected token `('" ab und die Pruefung faellt aus.
    my $zeile = git('branch', "--format='%(refname:short) %(upstream:track)'", '--list', $branch);
    if ($zeile =~ /\[gone\]/) {
        print "\n";
        print "  ABBRUCH: das Gegenstueck '$upstream' gibt es auf dem Server nicht mehr.\n";
        print "\n";
        print "  Der Branch ist geloescht worden, waehrend hier weitergearbeitet wurde.\n";
        print "  Alles, was jetzt hier committet wird, ist nur noch lokal.\n";
        print "\n";
        print "  Erst nachsehen, ob die eigenen Commits schon anderswo stecken:\n";
        print "\n";
        print "      git log --oneline origin/main..HEAD\n";
        print "\n";
        print "  Ist die Liste leer, ist nichts verloren - dann auf main wechseln.\n";
        print "  Steht etwas darin, gehoert es nach main uebertragen:\n";
        print "\n";
        print "      git rebase --onto origin/main $upstream $branch\n";
        print "\n";
        print "  (Bewusst trotzdem committen: git commit --no-verify)\n";
        print "\n";
        exit($nur_melden ? 0 : 1);
    }
}

print "pruefe-branch: '$branch' ist eigenstaendig und lebt - in Ordnung\n" if $nur_melden;
exit 0;
