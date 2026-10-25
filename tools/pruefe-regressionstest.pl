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
# NUR CODE ZAEHLT, KEIN KOMMENTAR (25.10.2026, PRUEFER-50 K4). Bis hierher
# wurde der ganze Text der Testdateien durchsucht - eine Kennung, die nur in
# einem Kommentar stand ("siehe auch E-108"), galt als getestet. Gemessen:
# sieben Kennungen waren so "gedeckt", darunter E-108 (kritisch, Absturz beim
# Antworten) ohne jeden Test. Zeichenketten bleiben stehen: Testnamen
# (TT_BeginTest("E-27 ...")) und Pruefmeldungen sind Teil des Tests.
sub ohne_kommentare {
    my ($t) = @_;
    my $aus = '';
    while (length $t) {
        if    ($t =~ s/^("(?:[^"\\\n]|\\.)*")//s)  { $aus .= $1 }        # Zeichenkette
        elsif ($t =~ s/^('(?:[^'\\\n]|\\.)*')//s)  { $aus .= $1 }        # Zeichen
        elsif ($t =~ s{^//[^\n]*}{}s)             { }                    # Zeilenkommentar
        elsif ($t =~ s{^/\*.*?\*/}{ }s)           { }                    # Blockkommentar
        elsif ($t =~ s{^([^"'/]+|/)}{}s)          { $aus .= $1 }
        else  { $aus .= substr($t, 0, 1, '') }
    }
    return $aus;
}
my $tests = '';
for my $f (glob("$wurzel/Eudora71/Tests/*.cpp")) {
    my $t = lies($f);
    $tests .= ohne_kommentare($t) if defined $t;
}

# DIE OBERFLAECHENFAELLE ZAEHLEN AUCH (22.10.2026, PRUEFER Fund 5).
#
# Bis hierher wurde die Deckung AUSSCHLIESSLICH aus Eudora71/Tests/*.cpp
# gelesen. tools/pruefstand-faelle.txt - die Datei, die Gregors
# Regressionstests ueber die Oberflaeche traegt - wurde nicht gelesen.
# Folge: E-121 stand in der Liste "OHNE jede Pruefung", obwohl dafuer ein
# gruener Fall existiert, und diese Zahl ging unveraendert in den
# Pruefbericht. Gezaehlt werden nur die FALLZEILEN, nicht die Kommentare:
# E-14 und E-132 stehen dort als Begruendung, warum sie NICHT automatisiert
# sind - wer sie mitzaehlte, machte aus einer Absage eine Deckung.
{
    my $f = lies("$wurzel/tools/pruefstand-faelle.txt");
    if (defined $f) {
        for my $z (split /\n/, $f) {
            next if $z =~ /^\s*(#|$)/;
            my @sp = split /\|/, $z, -1;
            next unless @sp >= 8;
            my $k = $sp[0];
            $k =~ s/^\s+|\s+$//g;
            $tests .= " $k ";
        }
    }
}

# SCHRANKEN IM PRE-COMMIT ZAEHLEN AUCH (24.10.2026). Eine Schranke, die den
# Quelltext bewacht und beim Rueckfall abweist, ist ein Regressionstest - sie
# laeuft sogar bei jedem Commit. Gezaehlt wird aber nur, was in
# tools/regression-schranken.txt steht (dort nur nach einer ROTEN
# Rueckfallprobe mit tools/schranken-gegenprobe.pl) UND im pre-commit
# eingehaengt ist. Eine Schranke, die nur im Verzeichnis liegt, prueft nichts
# (Arbeitsweise/schranke-gehoert-in-den-haken.md).
{
    my $liste = lies("$wurzel/tools/regression-schranken.txt");
    my $haken = lies("$wurzel/tools/hooks-einrichten.sh") // '';
    if (defined $liste) {
        for my $z (split /\n/, $liste) {
            next if $z =~ /^\s*(#|$)/;
            my ($k, $s) = map { s/^\s+|\s+$//gr } (split /\|/, $z)[0, 1];
            next unless defined $s and $haken =~ /^schranke \Q$s\E\b/m;
            $tests .= " $k ";
        }
    }
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
my (@ohne_stufe, @krit_ohne, @krit_ueber_ok, @krit_ueber_offen,@datenverlust_nicht_kritisch, %stufen, $krit, $krit_test, $krit_man, $man_gesamt);
my %gesehen;
$_ = 0 for ($gesamt, $mit, $manuell, $krit, $krit_test, $krit_man, $man_gesamt);
for my $zeile (split /\n/, $befunde) {
    next unless $zeile =~ /^\|\s*<a id="([a-z]+[0-9]*-[0-9.]+[a-z]?)"><\/a>/;
    my $id = $1;
    next if $gesehen{$id}++;
    $gesamt++;

    # Einstufung lesen - sie steht im Befund selbst, nicht in einer
    # zweiten Liste (Gregor: "single point of truth").
    my ($stufe) = $zeile =~ /\*\*Stufe: ([a-z]+)\*\*/;
    if (defined $stufe) { $stufen{$stufe}++ }
    else                { push @ohne_stufe, uc $id; }

    # WER DATENVERLUST SAGT, IST KRITISCH (22.10.2026, PRUEFER).
    #
    # E-64 ("ein Filterlauf verschob ALLE Nachrichten - DATENVERLUST") und
    # E-72 ("schreibt den leeren Zustand in den Filter - DATENVERLUST ueber
    # E-64 und E-73") standen als UNKRITISCH da. Der Grund war eine
    # Verwechslung beim Einstufen: beide Urteile beginnen mit einem
    # Bestaetigungsvermerk ("BESTAETIGT von Gregor am 10.09.2026"), und ich
    # habe die Klammer danach beschrieben statt den Schaden. E-72 ist sogar
    # die URSACHE von E-73, das kritisch steht - eine Ursache kann nicht
    # harmloser sein als ihre Wirkung.
    #
    # Folge waere gewesen: die Filter-Datenverlustkette muss vor keinem
    # Release geprueft werden. Deshalb hier eine Regel, die kein Urteil
    # braucht: steht DATENVERLUST in Grossbuchstaben in der Zeile, ist die
    # Stufe kritisch - oder die Zeile erklaert, warum nicht.
    if ($zeile =~ /DATENVERLUST/ and defined $stufe and $stufe ne 'kritisch') {
        push @datenverlust_nicht_kritisch, uc $id;
    }

    my @s = split /(?<!\\)\|/, $zeile, -1;
    my $urteil = $s[3] // '';
    my $hat    = hat_test($id);
    my $man    = ist_manuell($id, $urteil);

    # Ein Befund kann BEIDES haben: einen automatischen Testfall UND einen
    # manuellen Fall im Testplan. E-132 ist so einer - TestE132.cpp deckt
    # den Quelltextteil, der Dialogweg steht als Teil M1 im Testplan.
    # Bis zum 22.10.2026 verschwand der manuelle Fall hinter dem
    # automatischen, und der Pruefbericht sagte "0 manuelle Faelle",
    # waehrend der Testplan einen fuehrte, der vor dem Release zu fahren
    # ist (LEKTOR, L-50.9). Gezaehlt wird deshalb unabhaengig.
    $man_gesamt++ if $man;

    # UEBERHOLT HEISST: KEIN EIGENER TEST (Gregor 24.10.2026: "die
    # ueberholten muessen ja nicht extra getestet werden, nicht wahr?").
    # Ein Befund mit dem Urteil "**ueberholt** durch E-6/E-8" hatte nie eine
    # eigene Ursache. Er gilt als gedeckt, wenn EINE der genannten Ursachen
    # gedeckt ist - sonst steht er in einer eigenen Liste mit der Ursache,
    # deren Test fehlt. Doppelte Tests fuer dieselbe Ursache gibt es nicht
    # ("doppelte tests machen keinen sinn").
    my @ursachen;
    if ($urteil =~ /\*\*\s*(?:\xc3\xbc|ue)berholt\s*\*\*\s*durch\s+((?:E-\d+)(?:\s*\/\s*E-\d+)*)/i) {
        @ursachen = map { uc } ($1 =~ /(E-\d+)/gi);
    }
    my $ueber_gedeckt = grep { hat_test($_) } @ursachen;

    if (defined $stufe and $stufe eq 'kritisch') {
        $krit++;
        $krit_man++ if $man;
        if    ($hat) { $krit_test++ }
        elsif ($man) { }
        elsif (@ursachen and $ueber_gedeckt) { $krit_test++; push @krit_ueber_ok, uc($id) . '->' . join('/', @ursachen) }
        elsif (@ursachen) { push @krit_ueber_offen, uc($id) . '->' . join('/', @ursachen) }
        else         { push @krit_ohne, uc $id }
    }

    if ($hat) { $mit++; next }
    if ($man) { $manuell++; next }
    my ($fett) = $urteil =~ /\*\*([^*]{1,90})\*\*/;
    next unless defined $fett;
    push @ohne_behoben, uc $id if $fett =~ /^\s*behoben/i;
}

# --- Was ist in DIESEM Commit neu auf "behoben" gegangen? -----------------
my $diff = `git -C "$wurzel" diff --cached -M --unified=0 -- "$DATEI" "$ALT" 2>&1`;
# WAS "NEU" HEISST (22.10.2026 berichtigt). Bis hierher galt jede
# HINZUGEFUEGTE Zeile mit "behoben" als neu behoben. Das stimmt nur, solange
# niemand alle Zeilen auf einmal anfasst. Als die Marke **Stufe:** in alle
# 190 Urteile kam, stand jede Zeile als + und als - im Diff - die Schranke
# meldete 88 angeblich neu behobene Befunde und haette den Commit zu Recht
# aussehenden Gruenden verweigert, die es nicht gab.
# Verglichen wird deshalb der Status VORHER gegen den Status NACHHER
# derselben Zeile. Nur ein echter Wechsel zaehlt.
sub status_von {
    my ($z) = @_;
    my @s = split /(?<!\\)\|/, $z, -1;
    my $urteil = $s[3] // '';
    my ($fett) = $urteil =~ /\*\*([^*]{1,90})\*\*/;
    return '' unless defined $fett;
    return $fett =~ /^\s*behoben/i ? 'behoben' : 'sonst';
}

my (%vorher, %nachher);
for my $z (split /\n/, $diff) {
    if ($z =~ /^-\|\s*<a id="([a-z]+[0-9]*-[0-9.]+[a-z]?)"><\/a>/) { $vorher{$1}  = status_von($z); next }
    if ($z =~ /^\+\|\s*<a id="([a-z]+[0-9]*-[0-9.]+[a-z]?)"><\/a>/) { $nachher{$1} = status_von($z); next }
}

my @neu;
for my $id (sort keys %nachher) {
    next unless $nachher{$id} eq 'behoben';
    # War die Zeile vorher schon "behoben", ist nichts neu geworden.
    next if exists $vorher{$id} and $vorher{$id} eq 'behoben';
    next if hat_test($id);
    push @neu, uc $id;
}

printf "  ------------------------------------------------------------\n";
printf "  Regressionstests je Befund\n";
printf "  ------------------------------------------------------------\n";
printf "    Befunde insgesamt            %3d\n", $gesamt // 0;
printf "    davon mit Testfall           %3d\n", $mit // 0;
printf "    davon manuell im Testplan    %3d   (Marke im Urteil UND Eintrag im Plan)\n", $man_gesamt;
printf "    behoben und OHNE Testfall    %3d   <- Rueckstand\n", scalar @ohne_behoben;
printf "  ------------------------------------------------------------\n";
printf "  Einstufung (Gregor am 22.10.2026: \"markiere diejenigen, die du\n";
printf "  als kritisch betrachtest, so dass sie auf jeden fall vor einem\n";
printf "  release ausgefuehrt werden\")\n";
printf "  ------------------------------------------------------------\n";
printf "    kritisch   %3d   Verlust, Schaden, Absturz, Fremdschaden\n", $stufen{kritisch}   // 0;
printf "    wichtig    %3d   Funktion unbrauchbar, nichts geht verloren\n", $stufen{wichtig} // 0;
printf "    unkritisch %3d   Aussehen, Reste, Bequemlichkeit\n",           $stufen{unkritisch} // 0;
printf "    werkzeug   %3d   betrifft Bau und Werkzeuge, nicht das Programm\n", $stufen{werkzeug} // 0;
printf "    OHNE Stufe %3d\n", scalar @ohne_stufe;
printf "  ------------------------------------------------------------\n";
printf "  Die kritischen - sie muessen VOR JEDEM Release laufen\n";
printf "  ------------------------------------------------------------\n";
printf "    mit Testfall im Pruefstand   %3d von %d\n", $krit_test, $krit;
printf "    zusaetzlich manuell im Plan  %3d   (kann sich mit der Zeile\n", $krit_man;
printf "                                       darueber ueberschneiden)\n";
printf "    OHNE jede Pruefung           %3d   <- Rueckstand\n", scalar @krit_ohne;
if (@krit_ohne) {
    my @a = @krit_ohne;
    while (@a) { printf "      %s\n", join(' ', splice(@a, 0, 10)) }
}
if (@krit_ueber_ok) {
    printf "    davon ueber die Ursache gedeckt %d (\"ueberholt durch\", kein eigener Test)\n", scalar @krit_ueber_ok;
    printf "      %s\n", join(' ', @krit_ueber_ok);
}
if (@krit_ueber_offen) {
    printf "    ueberholt, Ursache ohne Test %3d   <- der Test gehoert zur Ursache\n", scalar @krit_ueber_offen;
    printf "      %s\n", join(' ', @krit_ueber_offen);
}
printf "  ------------------------------------------------------------\n";

if (@datenverlust_nicht_kritisch) {
    printf "\n  MANGEL - DATENVERLUST, aber nicht als kritisch eingestuft:\n";
    printf "    %s\n", $_ for @datenverlust_nicht_kritisch;
    print <<'ENDE';

  Steht DATENVERLUST in Grossbuchstaben in einer Befundzeile, ist der
  Befund kritisch. E-64 und E-72 standen am 22.10.2026 als unkritisch da,
  obwohl beide das Wort im eigenen Titel tragen und E-72 die URSACHE von
  E-73 ist, das kritisch steht. Eine Ursache kann nicht harmloser sein
  als ihre Wirkung.

  Folge waere gewesen: die Filter-Datenverlustkette muss vor keinem
  Release geprueft werden.

ENDE
    exit($hinweis ? 0 : 1);
}

if (@ohne_stufe) {
    printf "\n  MANGEL - Befunde ohne Einstufung:\n";
    my @a = @ohne_stufe;
    while (@a) { printf "    %s\n", join(' ', splice(@a, 0, 10)) }
    print <<'ENDE';

  Jeder Befund traegt am Ende seines Urteils eine Marke:

      **Stufe: kritisch**   (Grund)

  Erlaubt sind kritisch, wichtig, unkritisch, werkzeug. Die Stufe
  entscheidet, ob der Befund vor einem Release geprueft werden MUSS -
  sie steht deshalb im Befund selbst und nicht in einer zweiten Liste.

  kritisch   Post oder Einstellungen gehen verloren oder werden still
             beschaedigt; eine fremde Installation nimmt Schaden; das
             Programm stuerzt ab, startet nicht oder haengt; eine
             Nachricht geht falsch hinaus oder kommt falsch an;
             Sicherheit.
  wichtig    eine Funktion ist unbrauchbar, aber nichts geht verloren
             und der Anwender merkt es sofort.
  unkritisch Aussehen, Reste, Bequemlichkeit. Gregor am 22.10.2026:
             "ob da bei der kachel darstellung ein rest vom schliessen
             zu sehen ist, ist z.b. unkritisch."
  werkzeug   betrifft Bau, Schranken oder Werkzeuge, nicht das Programm.

ENDE
    exit($hinweis ? 0 : 1);
}

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
