#!/usr/bin/perl
use strict;
use warnings;

# pruefe-tests-gruen.pl - laufen die Tests, und sind sie alle gruen?
#
#   perl tools/pruefe-tests-gruen.pl               bauen, ausfuehren, urteilen
#   perl tools/pruefe-tests-gruen.pl --selbsttest  9 Faelle, beide Richtungen
#   perl tools/pruefe-tests-gruen.pl --hinweis     meldet, weist nie ab
#   perl tools/pruefe-tests-gruen.pl --ohne-bau    nur ausfuehren, nicht bauen
#
# Rueckgabe: 0 = alle gruen, 1 = mindestens einer rot, 2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 22.10.2026:
#
#     "ich habe gefragt, ob wir dazu jeweils einen test haben und angenommen,
#      dass er auch immer wieder ausgefuehrt wird (sonst macht ja ein test
#      keinen sinn!)."
#
# Er hat angenommen, was selbstverstaendlich scheint - und es stimmte nicht.
# Gemessen am 22.10.2026: KEIN Haken rief EudoraTests.exe je AUS. Die einzige
# test-bezogene Schranke, pruefe-testbau.pl, prueft in ihren eigenen Worten
# nur, "laesst sich die Testsammlung ueberhaupt noch BAUEN?" - und ihr
# Selbsttest schrieb rote Tests ausdruecklich als erlaubt fest:
#
#     "Ergebnis: 120 Tests, 118 bestanden, 2 fehlgeschlagen"  -> DURCHLASSEN
#     Kommentar: "sauberer Bau MIT roten Tests - darf NICHT abweisen"
#
# Die Sammlung wurde also bei jedem Push uebersetzt und danach weggeworfen.
# Ausgefuehrt wurde sie nur von Hand. Zwei Tests waren seit dem 10.09.2026
# bekannt rot; das stand im CHANGELOG und hat nie jemanden aufgehalten.
#
# ARBEITSTEILUNG. pruefe-testbau.pl behaelt seine Frage (baut es ueberhaupt?)
# und bleibt im pre-push - ein Bau, der nicht durchgeht, soll eine eigene,
# schnelle Meldung bekommen. DIESE Schranke beantwortet die andere Frage:
# sind sie gruen? Sie gehoert in den pre-push und vor jedes Release.
#
# Gregors Anordnung vom selben Tag: "wir fuehren vor jedem release alle
# regression tests aus, soll alles PASSED sein."

my ($hinweis, $ohne_bau) = (0, 0);
for my $a (@ARGV) {
    if    ($a eq '--selbsttest') { exit selbsttest() }
    elsif ($a eq '--hinweis')    { $hinweis = 1 }
    elsif ($a eq '--ohne-bau')   { $ohne_bau = 1 }
    elsif ($a =~ /^-/)           { print "  pruefe-tests-gruen: unbekannt: $a\n"; exit 2 }
}

my $wurzel = -f 'VERSION' ? '.' : '..';
my $exe    = "$wurzel/Eudora71/Tests/Build/Debug/EudoraTests.exe";

# --- 1. Bauen, wenn noetig ------------------------------------------------
unless ($ohne_bau) {
    my $bau = system("perl \"$wurzel/tools/pruefe-testbau.pl\" > " . devnull() . " 2>&1");
    if ($bau != 0) {
        print "  pruefe-tests-gruen: die Testsammlung laesst sich nicht bauen.\n";
        print "  Das meldet pruefe-testbau.pl im Einzelnen - erst den Bau in Ordnung bringen.\n";
        exit($hinweis ? 0 : 1);
    }
}

unless (-f $exe) {
    print "  pruefe-tests-gruen: $exe fehlt - MSBuild ist hier vermutlich nicht\n";
    print "  vorhanden. Nicht geprueft (das ist KEIN gruenes Urteil).\n";
    exit 0;
}

# --- 2. Ausfuehren --------------------------------------------------------
my @aus = `"$exe" 2>&1`;
my $rc  = $? >> 8;
my $txt = join '', @aus;

my ($gesamt, $gut, $rot) = urteil($txt, $rc);

print "  ------------------------------------------------------------\n";
print "  Regressionstests ausgefuehrt\n";
print "  ------------------------------------------------------------\n";
if (defined $gesamt) {
    printf "    Tests            %4d\n", $gesamt;
    printf "    bestanden        %4d\n", $gut;
    printf "    fehlgeschlagen   %4d\n", $rot;
}
printf "    Rueckgabewert    %4d   (TT_Summary: rote Tests plus Geruestfehler)\n", $rc;
print "  ------------------------------------------------------------\n";

if (!defined $gesamt) {
    print "\n  MANGEL - keine Ergebniszeile gefunden. Die Sammlung hat nicht\n";
    print "  durchgelaufen; ein stummer Lauf ist kein gruener Lauf\n";
    print "  (Arbeitsweise/ausbleiben-ist-kein-befund.md).\n\n";
    exit($hinweis ? 0 : 1);
}

if ($rot > 0 || $rc != 0) {
    print "\n  MANGEL - diese Tests sind rot:\n";
    for my $z (@aus) { print "    $z" if $z =~ /^\[FEHL\]/ }
    print "\n  Gregor am 22.10.2026: \"wir fuehren vor jedem release alle\n";
    print "  regression tests aus, soll alles PASSED sein.\"\n\n";
    exit($hinweis ? 0 : 1);
}

print "\n  Alle $gesamt Tests bestanden.\n\n";
exit 0;

# ---------------------------------------------------------------------------

sub devnull { return $^O =~ /MSWin/i ? 'NUL' : '/dev/null' }

# Liest die Ergebniszeile. Getrennt, damit der Selbsttest sie ohne Bau
# pruefen kann - die Schranke selbst muss gegentestbar sein
# (Arbeitsweise/schranke-gegentesten.md).
sub urteil {
    my ($txt, $rc) = @_;
    return (undef, undef, undef)
        unless $txt =~ /Ergebnis:\s*(\d+)\s*Tests?,\s*(\d+)\s*bestanden,\s*(\d+)\s*fehlgeschlagen/;
    return ($1, $2, $3);
}

sub selbsttest {
    my @faelle = (
        [ 'alles gruen',                "Ergebnis: 246 Tests, 246 bestanden, 0 fehlgeschlagen\n", 0, 0 ],
        [ 'ein roter Test',             "[FEHL] irgendwas\nErgebnis: 246 Tests, 245 bestanden, 1 fehlgeschlagen\n", 1, 1 ],
        [ 'zwei rote Tests',            "Ergebnis: 120 Tests, 118 bestanden, 2 fehlgeschlagen\n", 2, 1 ],
        [ 'gruen, aber Rueckgabe != 0', "Ergebnis: 246 Tests, 246 bestanden, 0 fehlgeschlagen\n", 3, 1 ],
        [ 'keine Ergebniszeile',        "Der Buildvorgang wurde erfolgreich ausgefuehrt.\n", 0, 1 ],
        [ 'leere Ausgabe',              "", 0, 1 ],
        [ 'Ergebniszeile mit Einzahl',  "Ergebnis: 1 Test, 1 bestanden, 0 fehlgeschlagen\n", 0, 0 ],
        [ 'Zahlen mit Leerraum',        "Ergebnis:  7 Tests,  7 bestanden,  0 fehlgeschlagen\n", 0, 0 ],
        [ 'rot UND Rueckgabe 0',        "Ergebnis: 10 Tests, 9 bestanden, 1 fehlgeschlagen\n", 0, 1 ],
    );
    my ($gut, $schlecht) = (0, 0);
    print "  ------------------------------------------------------------\n";
    print "  pruefe-tests-gruen --selbsttest\n";
    print "  ------------------------------------------------------------\n";
    for my $f (@faelle) {
        my ($name, $txt, $rc, $soll) = @$f;
        my ($gesamt, $g, $rot) = urteil($txt, $rc);
        my $ist = (!defined $gesamt || $rot > 0 || $rc != 0) ? 1 : 0;
        my $ok = $ist == $soll;
        $ok ? $gut++ : $schlecht++;
        printf "    [%s] %-30s soll %d, ist %d\n", ($ok ? ' ok ' : 'FEHL'), $name, $soll, $ist;
    }
    print "  ------------------------------------------------------------\n";
    printf "    %d Faelle, %d richtig, %d falsch\n", $gut + $schlecht, $gut, $schlecht;
    print "    (3 muessen durchgehen, 6 muessen abweisen)\n";
    return $schlecht ? 1 : 0;
}
