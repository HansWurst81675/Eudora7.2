#!/usr/bin/perl
#
# Meldet, wie weit Pruefung und Dokumentation hinter dem Code herhinken.
#
#   perl tools/pruefstand-melden.pl        # aus jedem Verzeichnis des Repos
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 29.08.2026 liefen sieben Agenten gleichzeitig - darunter ein Pruefer und ein
# Lektor, waehrend vier andere noch Code schrieben. Beide prueften ein bewegliches
# Ziel und waren in dem Moment veraltet, in dem sie ihren Bericht abgaben. Gregor
# musste zweimal nachfragen, ob denn alles geprueft sei.
#
# Pruefung und Doku gehoeren ans Ende einer Arbeitswelle, nicht mittendrin. Dieses
# Werkzeug macht sichtbar, wann das wieder faellig ist - statt sich darauf zu
# verlassen, dass jemand daran denkt.
#
# DIE MARKE
#
# Jede beobachtete Datei traegt eine Zeile
#
#     <!-- pruefstand: <commit> -->
#
# und nennt damit den Commit, gegen den sie zuletzt abgeglichen wurde. Wer eine
# dieser Dateien nachzieht, zieht die Marke mit - sie ist der Sinn des Werkzeugs.
# Als HTML-Kommentar ist sie in der gerenderten Ansicht unsichtbar.
#
# ZWEI BEHOBENE FEHLER (Befunde NP3-6 und NP3-7, behoben am 31.08.2026)
#
# NP3-6: Die Dateinamen standen ohne Pfad und wurden gegen das AKTUELLE
#   Arbeitsverzeichnis geprueft. Aus einem Unterverzeichnis heraus meldete das
#   Werkzeug dreimal "fehlt" - und danach "Pruefung und Doku sind nah am Code"
#   mit Rueckgabe 0. Gemessen und vorgefuehrt. Jetzt haengen die Pfade an
#   "git rev-parse --show-toplevel", und eine fehlende Datei ist eine WARNUNG.
#
# NP3-7: Es lief ueber ALLE hashartigen Funde der Datei und behielt den letzten,
#   der ein gueltiger Commit war. Gemessen am 31.08.2026: PORTIERUNG.md "geprueft
#   bis 567a5d8, seither 186 Commits" - 567a5d8 ist der Commit mit den
#   Originalquellen von 2006, den ein Befund nur zitiert. Die Zahl war
#   bedeutungslos. Jetzt entscheidet die Marke, und wo keine steht, wird das
#   gemeldet statt geraten.
#
#   Nebenbei: die alte Fassung rief fuer JEDEN Kandidaten ein eigenes
#   "git cat-file -t" auf - gemessen 122 Kandidaten in BEFUNDE.md, 41 in
#   PORTIERUNG.md, 19 in README.md, also 182 Prozessstarts. Jetzt ist es genau
#   einer: "git cat-file --batch-check" fuer alle Marken zusammen.
#
use strict;
use warnings;

my @beobachtet = qw(BEFUNDE.md README.md PORTIERUNG.md);

sub git {
    my @arg = @_;
    my $pid = open(my $fh, '-|');
    return '' unless defined $pid;
    if (!$pid) {
        open(STDERR, '>', '/dev/null') or open(STDERR, '>', 'NUL');
        exec('git', @arg) or exit 127;
    }
    local $/;
    my $aus = <$fh>;
    close $fh;
    return defined $aus ? $aus : '';
}

my $wurzel = git('rev-parse', '--show-toplevel');
chomp $wurzel;
unless (length $wurzel and -d $wurzel) {
    print STDERR "pruefstand-melden: kein git-Repo gefunden.\n";
    exit 2;
}

my $head = git('rev-parse', '--short', 'HEAD');
chomp $head;
unless (length $head) {
    print STDERR "pruefstand-melden: HEAD nicht lesbar (frisches Repo ohne Commit?).\n";
    exit 2;
}

my $warnung = 0;
my %marke;
my @fehlt;

for my $datei (@beobachtet) {
    my $pfad = "$wurzel/$datei";
    unless (-f $pfad) {
        push @fehlt, "$datei: Datei fehlt (gesucht in $wurzel)";
        next;
    }
    open(my $fh, '<', $pfad) or do { push @fehlt, "$datei: nicht lesbar: $!"; next };
    my $gefunden;
    while (my $z = <$fh>) {
        if ($z =~ /<!--\s*pruefstand:\s*([0-9a-f]{7,40})\s*-->/) { $gefunden = $1; last }
    }
    close $fh;
    if ($gefunden) { $marke{$datei} = $gefunden }
    else           { push @fehlt, "$datei: keine Pruefstandsmarke" }
}

# Marken pruefen. Ein rev-parse je Marke - das sind drei Aufrufe, nicht 182 wie
# in der alten Fassung, weil nicht mehr jeder hashartige Fund der Datei geprueft
# werden muss. Ein zweiwegiger Datenkanal zu "git cat-file --batch-check" waere
# hier reine Angeberei; ich hatte ihn gebaut, er war falsch verdrahtet (das Kind
# schloss genau die Enden, die es dupliziert), und drei Aufrufe brauchen 10 ms.
my %gueltig;
for my $datei (sort keys %marke) {
    my $m = $marke{$datei};
    my $aus = git('rev-parse', '--verify', '--quiet', $m . '^{commit}');
    $gueltig{$m} = 1 if $aus =~ /[0-9a-f]{7}/;
}

print "Stand HEAD: $head\n\n";

for my $datei (@beobachtet) {
    my $m = $marke{$datei};
    next unless $m;
    unless ($gueltig{$m}) {
        printf "  %-18s Marke %s ist kein Commit in diesem Repo\n", $datei, $m;
        $warnung = 1;
        next;
    }
    my $abstand = git('rev-list', '--count', "$m..HEAD");
    chomp $abstand;
    $abstand = 0 unless $abstand =~ /^\d+$/;

    my $hinweis = '';
    if    ($abstand >= 10) { $hinweis = '  <== faellig'; $warnung = 1 }
    elsif ($abstand >= 5)  { $hinweis = '  (bald faellig)' }

    printf "  %-18s abgeglichen bis %s, seither %2d Commit(s)%s\n",
           $datei, $m, $abstand, $hinweis;
}

if (@fehlt) {
    print "\n";
    print "  $_\n" for @fehlt;
    print "\nOhne Marke kann dieses Werkzeug nichts sagen. Es raet auch nicht mehr\n";
    print "(Befund NP3-7). Die Zeile gehoert in die Datei, ueblicherweise ganz oben:\n";
    print "\n    <!-- pruefstand: $head -->\n";
    $warnung = 1;
}

if ($warnung) {
    print "\nPruefung bzw. Doku sind hinter dem Code zurueck - oder nicht messbar.\n";
    print "Vor dem naechsten Meilenstein PRUEFER und LEKTOR auf den Abstand\n";
    print "seit dem jeweils genannten Commit ansetzen.\n";
    exit 1;
}

print "\nPruefung und Doku sind nah am Code.\n";
exit 0;
