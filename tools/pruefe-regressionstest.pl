#!/usr/bin/perl
use strict;
use warnings;

# pruefe-regressionstest.pl - hat jeder Befund einen Regressionstest?
#
#   perl tools/pruefe-regressionstest.pl             Bestand zaehlen
#   perl tools/pruefe-regressionstest.pl --selbsttest  8 Faelle, beide Richtungen
#   perl tools/pruefe-regressionstest.pl --hinweis     meldet, weist nie ab
#
# Rueckgabe: 0 = kein NEUES "behoben" ohne Test, 1 = MANGEL, 2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 22.10.2026, als Anordnung:
#
#     "das zauberwort heisst regression tests - schon mal was davon gehoert?
#      ich habe angenommen, die machen wir jedes mal vor dem release? jetzt
#      ordne ich es an: wir fuehren vor jedem release alle regression tests
#      aus, soll alles PASSED sein. und zu jedem befund brauchen wir ein
#      regression test, damit wir sehen, dass eine neue aenderung nichts
#      altes kaputt macht."
#
# Gemessen an dem Tag: 186 Befunde, 29 mit Testfall, 157 ohne. Unter den
# BEHOBENEN ohne Test stehen E-121 (Nachricht verschwindet beim Verschieben),
# E-83, E-97, E-104, E-115, E-134 und E-135. Nichts hindert eine neue
# Aenderung daran, sie wieder kaputtzumachen.
#
# WARUM DIE SCHRANKE NICHT SOFORT ALLE 157 VERLANGT
#
# Eine Schranke, die vom ersten Tag an jeden Commit abweist, wird am zweiten
# Tag ausgebaut (Arbeitsweise/schranke-gehoert-in-den-haken.md). Sie weist
# deshalb nur ab, wenn in DIESEM Commit ein Befund NEU auf "behoben" gesetzt
# wird, ohne dass ein Test ihn nennt. Der Rueckstand wird gezaehlt und
# gemeldet - er kann dadurch nur sinken.

my $hinweis = 0;
for my $a (@ARGV) {
    if    ($a eq '--selbsttest') { exit selbsttest() }
    elsif ($a eq '--hinweis')    { $hinweis = 1 }
    elsif ($a =~ /^-/)           { print "  pruefe-regressionstest: unbekannt: $a\n"; exit 2 }
}

my $wurzel = -f 'VERSION' ? '.' : '..';
my $DATEI  = "$wurzel/Intern/BEFUNDE.md";
my $ALT    = 'BEFUNDE.md';

sub lies { my ($d) = @_; open my $h,'<:raw',$d or return undef; local $/; my $t=<$h>; close $h; $t }

my $befunde = lies($DATEI);
unless (defined $befunde) {
    print "  pruefe-regressionstest: $DATEI nicht lesbar - aus der Wurzel aufrufen.\n";
    exit 2;
}

# --- Welche Kennungen nennt der Pruefstand? -------------------------------
my $tests = '';
for my $f (glob("$wurzel/Eudora71/Tests/*.cpp")) {
    my $t = lies($f);
    $tests .= $t if defined $t;
}

sub hat_test {
    my ($id) = @_;
    my $gross = uc $id;
    return $tests =~ /\Q$gross\E\b/ ? 1 : 0;
}

# --- Was manuell geprueft wird, zaehlt auch -------------------------------
#
# Gregor am 22.10.2026: "vermutlich kann man nicht alle findings per
# automatisierten tests pruefen. manche muss man wohl manuell testen, diese
# werden dann als solche markiert und vor 7.2.1.0 release ausgefuehrt. dazu
# wie immer eine liste / tabelle mit schritten und zu erwarteten ergebnissen
# (= testplan)."
#
# Ein Befund gilt deshalb als gedeckt, wenn ENTWEDER ein Testfall ihn nennt
# ODER sein Urteil "Pruefung: manuell" traegt UND er im Testplan steht. Die
# Marke allein reicht nicht - ohne Schritte im Testplan ist "manuell" nur
# ein Wort, das die Schranke abschaltet.
my $testplan = lies("$wurzel/Intern/TESTPLAN.md") // '';

sub ist_manuell {
    my ($id, $urteil) = @_;
    return 0 unless $urteil =~ /\*\*[^*]*fung:\s*manuell[^*]*\*\*/i;
    my $gross = uc $id;
    return $testplan =~ /\Q$gross\E\b/ ? 1 : 0;
}

# --- Bestand zaehlen ------------------------------------------------------
my (@ohne_behoben, $gesamt, $mit, $manuell);
my %gesehen;
for my $zeile (split /\n/, $befunde) {
    next unless $zeile =~ /^\|\s*<a id="([a-z]+[0-9]*-\d+[a-z]?)"><\/a>/;
    my $id = $1;
    next if $gesehen{$id}++;
    $gesamt++;
    if (hat_test($id)) { $mit++; next }
    my @s = split /(?<!\\)\|/, $zeile, -1;
    my $urteil = $s[3] // '';
    if (ist_manuell($id, $urteil)) { $manuell++; next }
    my ($fett) = $urteil =~ /\*\*([^*]{1,90})\*\*/;
    next unless defined $fett;
    push @ohne_behoben, uc $id if $fett =~ /^\s*behoben/i;
}

# --- Was ist in DIESEM Commit neu auf "behoben" gegangen? -----------------
my $diff = `git -C "$wurzel" diff --cached -M --unified=0 -- "$DATEI" "$ALT" 2>&1`;
my @neu;
for my $z (split /\n/, $diff) {
    next unless $z =~ /^\+\|\s*<a id="([a-z]+[0-9]*-\d+[a-z]?)"><\/a>/;
    my $id = $1;
    my @s = split /(?<!\\)\|/, $z, -1;
    my $urteil = $s[3] // '';
    my ($fett) = $urteil =~ /\*\*([^*]{1,90})\*\*/;
    next unless defined $fett and $fett =~ /^\s*behoben/i;
    next if hat_test($id);
    push @neu, uc $id;
}

printf "  ------------------------------------------------------------\n";
printf "  Regressionstests je Befund\n";
printf "  ------------------------------------------------------------\n";
printf "    Befunde insgesamt            %3d\n", $gesamt // 0;
printf "    davon mit Testfall           %3d\n", $mit // 0;
printf "    davon manuell im Testplan    %3d\n", $manuell // 0;
printf "    behoben und OHNE Testfall    %3d   <- Rueckstand\n", scalar @ohne_behoben;
printf "  ------------------------------------------------------------\n";

if (@neu) {
    printf "\n  MANGEL - in diesem Commit neu auf \"behoben\" gesetzt, ohne Test:\n";
    printf "    %s\n", $_ for @neu;
    print <<'ENDE';

  Gregor am 22.10.2026: "zu jedem befund brauchen wir ein regression
  test, damit wir sehen, dass eine neue aenderung nichts altes kaputt
  macht."

  Ein "behoben" ohne Test haelt genau so lange, bis jemand daneben
  etwas aendert. Der Test gehoert in denselben Commit wie die Behebung.

ENDE
    exit($hinweis ? 0 : 1);
}

print "\n  Kein neues \"behoben\" ohne Regressionstest.\n\n";
exit 0;

# ---------------------------------------------------------------------------

sub selbsttest {
    my @faelle = (
        [ 'behoben MIT Test im Pruefstand', 'E-111', '**behoben in 7.2.0.121**', 1, 0 ],
        [ 'behoben OHNE Test',              'E-999', '**behoben in 7.2.0.121**', 0, 1 ],
        [ 'offen ohne Test - kein Mangel',  'E-999', '**offen, nicht angefasst**', 0, 0 ],
        [ 'offen mit Test - kein Mangel',   'E-111', '**offen**', 1, 0 ],
        [ 'teilweise ohne Test',            'E-999', '**teilweise behoben**', 0, 0 ],
        [ 'behoben klein geschrieben',      'E-999', '**behoben**', 0, 1 ],
        [ 'Urteil ohne Fettdruck',          'E-999', 'behoben in 7.2.0.121', 0, 0 ],
        [ 'behoben, Test vorhanden',        'E-131', '**behoben in 7.2.0.113**', 1, 0 ],
    );
    my ($gut, $schlecht) = (0, 0);
    print "  ------------------------------------------------------------\n";
    print "  pruefe-regressionstest --selbsttest\n";
    print "  ------------------------------------------------------------\n";
    for my $f (@faelle) {
        my ($name, $id, $urteil, $hat, $soll) = @$f;
        my ($fett) = $urteil =~ /\*\*([^*]{1,90})\*\*/;
        my $ist = (defined $fett and $fett =~ /^\s*behoben/i and !$hat) ? 1 : 0;
        my $ok = $ist == $soll;
        $ok ? $gut++ : $schlecht++;
        printf "    [%s] %-34s soll %d, ist %d\n", ($ok ? ' ok ' : 'FEHL'), $name, $soll, $ist;
    }
    print "  ------------------------------------------------------------\n";
    printf "    %d Faelle, %d richtig, %d falsch\n", $gut + $schlecht, $gut, $schlecht;
    print "    (6 muessen durchgehen, 2 muessen abweisen)\n";
    return $schlecht ? 1 : 0;
}
