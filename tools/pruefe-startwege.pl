#!/usr/bin/perl
use strict;
use warnings;
use Time::Local ();

# pruefe-startwege.pl - jeder eigene Eudora-Start gehoert ins Protokoll.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# tools/WERKZEUGE.md, Zeile zu tools/testlauf.ps1:
#
#     "der EINZIGE erlaubte Weg, Eudora zum Messen zu starten.
#      Oeffnet ein Fenster - nur nach Absprache."
#
# Am 21.10.2026, waehrend der Arbeit an E-134 (Adressbuch), lief kein
# einziger Start ueber dieses Werkzeug. Gemessen am 21.10.2026 im Zweig
# wt/chronist-20261021:
#
#     Pruefstaende unter C:\Temp\E134-*                       15
#     Eudora-Starts darin (eigene, nach dem Kopieren der exe)  15
#     Zeilen in tools/TESTLAEUFE.md mit dem Datum 2026-10-21    0
#     letzte Zeile in TESTLAEUFE.md                 2026-10-20 19:45:51
#
# Gregor hat die Fenster gesehen und gefragt. Die Schranke in testlauf.ps1
# (seit 15.10.2026: -Freigabe muss das heutige Datum nennen) hat nichts
# gemeldet - sie wurde nicht umgangen, sie wurde NICHT AUFGERUFEN. Eine
# Schranke, die in einem Werkzeug sitzt, prueft nur die, die das Werkzeug
# benutzen.
#
# Diese hier prueft von der anderen Seite: nicht den Aufruf, sondern die
# SPUR. Jeder Eudora-Start schreibt in sein Mailverzeichnis eine eudora.log
# mit Startzeit und Fassung. Wer startet, hinterlaesst sie - unabhaengig
# davon, womit er gestartet hat.
#
# Lehre: Arbeitsweise/jeder-start-ins-protokoll.md
#
# ---------------------------------------------------------------------------
# WIE EIN EIGENER START ERKANNT WIRD - UND WARUM DIE EXE-ZEIT DAZUGEHOERT
# ---------------------------------------------------------------------------
#
# Ein Pruefstand entsteht durch Kopieren. Mitkopiert wird das
# Mailverzeichnis - und darin eine eudora.log, die schon Startzeilen eines
# FREMDEN Laufs enthaelt. Am 21.10.2026 trugen alle 15 E134-Pruefstaende
# dieselbe Zeile:
#
#     Wed Oct 21 10:37:39 2026 / Version 7.2.0.118
#     MAIN ... E-132 Startverzeichnis:
#         gefunden="C:\Users\Gregor\Eudora72-1.0.118-release\Mailverzeichnis"
#
# Das war Gregors eigener Lauf, fuenfzehnmal mitkopiert. Wer ihn mitzaehlt,
# schlaegt fuenfzehnmal fuer einen fremden Start Alarm.
#
# Deshalb zaehlt nur, was NACH der Eudora.exe dieses Verzeichnisses liegt:
# die exe wird beim Aufbau des Pruefstands hineinkopiert, der eigene Lauf
# kommt danach. Gemessen an denselben 15 Verzeichnissen: die kopierte Zeile
# liegt zwischen 26 Minuten und 89 Minuten VOR der exe, jeder eigene Lauf
# 2 bis 37 Sekunden DANACH. Die Regel trennt beides sauber.
#
# Sie zaehlt im Zweifel zu WENIG (ein eigener Lauf aus einem Pruefstand, der
# zwischendurch keine neue exe bekommen hat, faellt heraus). Das ist die
# richtige Richtung: eine Schranke, die zu oft umsonst warnt, wird
# abgeschaltet (Arbeitsweise/schranke-gehoert-in-den-haken.md).
#
# ---------------------------------------------------------------------------
# WAS BEWUSST NICHT GEPRUEFT WIRD
# ---------------------------------------------------------------------------
#
# Gesucht wird NUR unter C:\Temp - dort liegen meine Pruefstaende. Gregors
# eigene Verzeichnisse (C:\Users\Gregor\Eudora72-*) werden nicht angefasst;
# seine Laeufe sind keine, die ich protokollieren muesste, und sein
# Verzeichnis geht mich nichts an (CLAUDE.md, Punkt 4).
#
# Geprueft wird nur EIN Tag, voreingestellt heute. Ein Lauf von gestern, der
# heute committet wird, loest nichts aus.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-startwege.pl                 heute, weist ab
#   perl tools/pruefe-startwege.pl --tag 2026-10-21
#   perl tools/pruefe-startwege.pl --alle          jeder Tag, nur Bericht
#   perl tools/pruefe-startwege.pl --nurmelden     Rueckgabe immer 0
#   perl tools/pruefe-startwege.pl --verzeichnis <pfad>
#   perl tools/pruefe-startwege.pl --selbsttest
#
# Rueckgabe 0 = in Ordnung, 1 = Mangel, 2 = Aufrufproblem.

my $WURZEL   = -f 'VERSION' ? '.' : '..';
my $PROTOKOLL = "$WURZEL/tools/TESTLAEUFE.md";
my $SUCHORT  = 'C:/Temp';

# Wieviele Sekunden darf eine Protokollzeile vom Start abweichen?
# testlauf.ps1 schreibt die Zeile, NACHDEM das Fenster zu ist. Gemessen an
# den echten Paaren vom 20.10.2026: 31 s, 33 s, 30 s. Zehn Minuten ist
# grosszuegig und trennt trotzdem - der naechste nicht protokollierte Start
# vom 20.10. lag 28 Minuten hinter der letzten Zeile.
my $FENSTER = 600;

my %MONAT = (Jan=>1, Feb=>2, Mar=>3, Apr=>4, May=>5, Jun=>6,
             Jul=>7, Aug=>8, Sep=>9, Oct=>10, Nov=>11, Dec=>12);

# ---------------------------------------------------------------------------
# Kern 1: die Startzeilen einer eudora.log, ohne die mitkopierten
# ---------------------------------------------------------------------------
#
# $zeilen  - der Inhalt der eudora.log als Liste
# $exezeit - Unix-Zeit der Eudora.exe daneben, oder undef (dann alles)
#
# Rueckgabe: Liste von [Unix-Zeit, "YYYY-MM-DD hh:mm:ss"]
sub starts_aus_log {
    my ($zeilen, $exezeit) = @_;
    my @start;
    for my $i (0 .. $#$zeilen - 1) {
        next unless $zeilen->[$i]
            =~ /^\w{3}\s+(\w{3})\s+(\d+)\s+(\d\d):(\d\d):(\d\d)\s+(\d{4})/;
        # Die Gruppen MUESSEN hier heraus. Das naechste =~ setzt $1..$6 neu,
        # auch wenn es nur auf "Version " prueft - genau diesen Fehler hatte
        # der erste Entwurf, und er lieferte lauter leere Zeitstempel.
        my ($mon, $tag, $std, $min, $sek, $jahr) = ($1, $2, $3, $4, $5, $6);
        next unless exists $MONAT{$mon};
        # Direkt unter der Datumszeile steht die Fassung. Ohne sie ist es
        # keine Startzeile, sondern irgendein Datum im Fliesstext.
        next unless $zeilen->[$i+1] =~ /^Version\s/;

        my $ep = eval {
            Time::Local::timelocal($sek, $min, $std, $tag,
                                   $MONAT{$mon} - 1, $jahr);
        };
        next unless defined $ep;
        # 5 Sekunden Luft: die exe wird kopiert, dann gestartet; auf
        # langsamen Platten kann der Zeitstempel knapp hinterherhinken.
        next if defined($exezeit) && $ep < $exezeit - 5;
        push @start, [$ep, sprintf('%04d-%02d-%02d %02d:%02d:%02d',
                                   $jahr, $MONAT{$mon}, $tag, $std, $min, $sek)];
    }
    return @start;
}

# ---------------------------------------------------------------------------
# Kern 2: die Zeiten aus tools/TESTLAEUFE.md
# ---------------------------------------------------------------------------
sub zeiten_aus_protokoll {
    my ($zeilen) = @_;
    my @zeit;
    for my $z (@$zeilen) {
        next unless $z =~ /^\|\s*(\d{4})-(\d\d)-(\d\d)\s+(\d\d):(\d\d):(\d\d)\s*\|/;
        my ($j, $mo, $t, $h, $mi, $s) = ($1, $2, $3, $4, $5, $6);
        my $ep = eval { Time::Local::timelocal($s, $mi, $h, $t, $mo - 1, $j) };
        next unless defined $ep;
        push @zeit, [$ep, "$j-$mo-$t"];
    }
    return @zeit;
}

# ---------------------------------------------------------------------------
# Kern 3: welche Starts hat keine Protokollzeile gedeckt?
# ---------------------------------------------------------------------------
sub ungedeckt {
    my ($starts, $zeiten) = @_;
    my @offen;
    for my $s (@$starts) {
        my $gedeckt = 0;
        for my $z (@$zeiten) {
            if (abs($z->[0] - $s->[0]) <= $FENSTER) { $gedeckt = 1; last; }
        }
        push @offen, $s unless $gedeckt;
    }
    return @offen;
}

# ---------------------------------------------------------------------------
# Selbsttest - in beide Richtungen
# ---------------------------------------------------------------------------
sub selbsttest {
    my $fehler = 0;
    my $gefahren = 0;
    my $melde = sub {
        my ($ok, $name, $erw, $ist) = @_;
        $gefahren++;
        $fehler++ unless $ok;
        printf "    %-4s %s\n", ($ok ? 'ok' : 'FEHL'), $name;
        printf "         erwartet %s, bekommen %s\n", $erw, $ist unless $ok;
    };

    # --- starts_aus_log ----------------------------------------------------
    my @log_echt = (
        "\r\n",
        "Wed Oct 21 10:37:39 2026\r\n",   # mitkopiert, vor der exe
        "Version 7.2.0.118\r\n",
        "MAIN 32768: 0.00 irgendwas\r\n",
        "\r\n",
        "Wed Oct 21 12:03:40 2026\r\n",   # eigener Lauf, nach der exe
        "Version 7.2.0.118\r\n",
    );
    # exe am 21.10.2026 12:03:38
    my $exe = Time::Local::timelocal(38, 3, 12, 21, 9, 2026);

    my @mit = starts_aus_log(\@log_echt, $exe);
    $melde->(scalar(@mit) == 1 && $mit[0][1] eq '2026-10-21 12:03:40',
             'echte Log: die mitkopierte Startzeile faellt heraus',
             '1 Start 12:03:40', scalar(@mit) . ' Start(s)');

    my @ohne = starts_aus_log(\@log_echt, undef);
    $melde->(scalar(@ohne) == 2,
             'ohne exe-Zeit zaehlen beide Zeilen (Gegenprobe zur Filterregel)',
             '2 Starts', scalar(@ohne) . ' Start(s)');

    # Ein Datum OHNE "Version" darunter ist keine Startzeile.
    my @log_falsch = ("Wed Oct 21 12:03:40 2026\r\n", "irgendwas\r\n");
    $melde->(scalar(starts_aus_log(\@log_falsch, undef)) == 0,
             'Datumszeile ohne "Version" zaehlt nicht',
             '0 Starts', scalar(starts_aus_log(\@log_falsch, undef)) . ' Start(s)');

    # Die Gruppen-Falle: zwei Startzeilen hintereinander muessen BEIDE mit
    # ihrer eigenen Zeit herauskommen, nicht mit der letzten.
    my @log_zwei = (
        "Wed Oct 21 11:00:00 2026\r\n", "Version 7.2.0.118\r\n",
        "Wed Oct 21 12:00:00 2026\r\n", "Version 7.2.0.119\r\n",
    );
    my @zwei = starts_aus_log(\@log_zwei, undef);
    $melde->(scalar(@zwei) == 2
             && $zwei[0][1] eq '2026-10-21 11:00:00'
             && $zwei[1][1] eq '2026-10-21 12:00:00',
             'zwei Startzeilen behalten jede ihre eigene Zeit',
             '11:00:00 und 12:00:00',
             join(' / ', map { $_->[1] } @zwei));

    my @log_leer = ();
    $melde->(scalar(starts_aus_log(\@log_leer, undef)) == 0,
             'leere Log liefert nichts', '0 Starts', '0 Starts');

    # --- zeiten_aus_protokoll ---------------------------------------------
    my @prot = zeiten_aus_protokoll([
        "# Testlaeufe\n",
        "| Zeit | Verzeichnis | Freigabe | Ergebnis |\n",
        "|---|---|---|---|\n",
        "| 2026-10-21 12:04:11 | `C:\\Temp\\E134-F1` | Gregor: 'ja' | Fenster |\n",
        "| kein Datum | x | y | z |\n",
    ]);
    $melde->(scalar(@prot) == 1 && $prot[0][1] eq '2026-10-21',
             'Protokoll: Kopfzeilen und Zeilen ohne Datum zaehlen nicht',
             '1 Zeit', scalar(@prot) . ' Zeit(en)');

    # --- ungedeckt ---------------------------------------------------------
    my $t0 = Time::Local::timelocal(0, 0, 12, 21, 9, 2026);
    my @s = ([$t0, 'A'], [$t0 + 3600, 'B']);

    $melde->(scalar(ungedeckt(\@s, [[$t0 + 31, 'x']])) == 1,
             'eine Zeile 31 s nach dem Start deckt genau diesen Start',
             '1 offen', scalar(ungedeckt(\@s, [[$t0 + 31, 'x']])) . ' offen');

    $melde->(scalar(ungedeckt(\@s, [[$t0 + 31, 'x'], [$t0 + 3630, 'y']])) == 0,
             'zwei Zeilen decken zwei Starts',
             '0 offen',
             scalar(ungedeckt(\@s, [[$t0+31,'x'], [$t0+3630,'y']])) . ' offen');

    $melde->(scalar(ungedeckt(\@s, [])) == 2,
             'kein Protokoll - beide Starts offen (der Fall vom 21.10.2026)',
             '2 offen', scalar(ungedeckt(\@s, [])) . ' offen');

    $melde->(scalar(ungedeckt(\@s, [[$t0 + 1681, 'z']])) == 2,
             'eine Zeile 28 min daneben deckt nichts (der Fall vom 20.10.2026)',
             '2 offen', scalar(ungedeckt(\@s, [[$t0+1681,'z']])) . ' offen');

    $melde->(scalar(ungedeckt([], [[$t0, 'x']])) == 0,
             'kein Start - nichts offen, auch wenn Zeilen dastehen',
             '0 offen', scalar(ungedeckt([], [[$t0,'x']])) . ' offen');

    # Die Zahl kommt aus dem Lauf, nicht aus dem Kopf. Hier stand "12 - $fehler, 12"
    # fest eingetragen, waehrend elf Faelle liefen - der Selbsttest meldete
    # "12 von 12 Faellen bestanden" und hat damit einen Fall behauptet, den es
    # nicht gab (Arbeitsweise/erfolgsmeldung-aus-dem-ergebnis.md, gemessen am
    # 21.10.2026 beim Bau dieser Schranke).
    printf "\n    %d von %d Faellen bestanden.\n\n", $gefahren - $fehler, $gefahren;
    return $fehler ? 1 : 0;
}

# ---------------------------------------------------------------------------
# Hauptlauf
# ---------------------------------------------------------------------------
my ($tag, $alle, $nurmelden) = (undef, 0, 0);
for (my $i = 0; $i < @ARGV; $i++) {
    if    ($ARGV[$i] eq '--selbsttest')   { exit selbsttest(); }
    elsif ($ARGV[$i] eq '--alle')         { $alle = 1; }
    elsif ($ARGV[$i] eq '--nurmelden')    { $nurmelden = 1; }
    elsif ($ARGV[$i] eq '--tag')          { $tag = $ARGV[++$i]; }
    elsif ($ARGV[$i] eq '--verzeichnis')  { $SUCHORT = $ARGV[++$i]; }
    else { print "  unbekanntes Argument: $ARGV[$i]\n"; exit 2; }
}

unless (defined $tag) {
    my @n = localtime(time);
    $tag = sprintf('%04d-%02d-%02d', $n[5] + 1900, $n[4] + 1, $n[3]);
}

# --- alle Starts einsammeln ------------------------------------------------
my (@starts, %woher);
my $verzeichnisse = 0;
if (-d $SUCHORT) {
    for my $d (sort glob("$SUCHORT/*")) {
        next unless -d $d;
        my $log = "$d/Mailverzeichnis/eudora.log";
        my $exe = "$d/Eudora.exe";
        next unless -f $log;
        $verzeichnisse++;
        my $exezeit = (-f $exe) ? (stat($exe))[9] : undef;
        open my $F, '<:raw', $log or next;
        my @z = <$F>;
        close $F;
        for my $s (starts_aus_log(\@z, $exezeit)) {
            push @starts, $s;
            $woher{ $s->[1] } = $d;
        }
    }
}

# --- Protokoll lesen -------------------------------------------------------
my @zeiten;
if (-f $PROTOKOLL) {
    open my $P, '<:raw', $PROTOKOLL or die "kann $PROTOKOLL nicht lesen: $!\n";
    my @z = <$P>;
    close $P;
    @zeiten = zeiten_aus_protokoll(\@z);
} else {
    print "\n  pruefe-startwege: $PROTOKOLL nicht gefunden -\n";
    print "  bitte aus dem Wurzelverzeichnis aufrufen.\n\n";
    exit 2;
}

printf "\n  %s\n  Startwege: jeder eigene Eudora-Start im Protokoll?\n  %s\n",
       '-' x 60, '-' x 60;
printf "    durchsuchtes Verzeichnis       %s\n", $SUCHORT;
printf "    Pruefstaende mit eudora.log    %d\n", $verzeichnisse;
printf "    Zeilen in TESTLAEUFE.md        %d\n", scalar @zeiten;

# UMFANG 0 IST KEIN GRUENES ERGEBNIS. Findet die Schranke gar keinen Start,
# dann ist entweder wirklich keiner gelaufen - oder das Suchmuster passt
# nicht mehr (Arbeitsweise/ausbleiben-ist-kein-befund.md). Deshalb steht die
# Zahl der Pruefstaende daneben: 0 Pruefstaende und 0 Starts ist etwas
# anderes als 15 Pruefstaende und 0 Starts.
if ($verzeichnisse > 0 && !@starts) {
    printf "\n  WARNUNG: %d Verzeichnis(se) mit eudora.log, aber keine\n",
           $verzeichnisse;
    print  "  einzige Startzeile erkannt. Entweder hat das Programm das\n";
    print  "  Format der Log geaendert, oder jede Log ist aelter als ihre\n";
    print  "  Eudora.exe. Das ist kein gruenes Ergebnis.\n";
}

my @tage = $alle
         ? do { my %t; $t{ substr($_->[1], 0, 10) } = 1 for @starts; sort keys %t }
         : ($tag);

my $mangel = 0;
for my $t (@tage) {
    my @s_tag = grep { substr($_->[1], 0, 10) eq $t } @starts;
    my @z_tag = grep { $_->[1] eq $t } @zeiten;
    my @offen = ungedeckt(\@s_tag, \@zeiten);
    printf "\n    %s   Starts %2d   Protokollzeilen %2d   ohne Zeile %2d\n",
           $t, scalar @s_tag, scalar @z_tag, scalar @offen;
    next unless @offen;
    $mangel = 1 unless $alle;
    for my $o (@offen) {
        printf "        %s   %s\n", $o->[1], ($woher{ $o->[1] } // '?');
    }
}

if ($alle) {
    print "\n  --alle ist ein Bericht, kein Urteil.\n\n";
    exit 0;
}

if (!$mangel) {
    printf "\n  Jeder eigene Eudora-Start am %s steht im Protokoll.\n\n", $tag;
    exit 0;
}

print <<"ENDE";

  MANGEL: Eudora lief heute, ohne dass tools/TESTLAEUFE.md es weiss.

  tools/testlauf.ps1 ist der EINZIGE erlaubte Weg, Eudora zum Messen zu
  starten (tools/WERKZEUGE.md). Es verlangt -Freigabe mit dem heutigen
  Datum und schreibt jede Zeile selbst. Wer daneben startet, umgeht nicht
  die Pruefung - er ruft sie gar nicht erst auf.

  Am 21.10.2026 waren es 15 Starts und 0 Zeilen. Gregor hat die Fenster
  gesehen und gefragt.

  Was jetzt zu tun ist:

    - kuenftige Messungen ueber tools/testlauf.ps1 -Freigabe "<Gregors
      Satz von heute, mit Datum>" fahren, oder ein eigenes Serienskript
      bauen, das -Freigabe durchreicht (Muster: tools/e118-serie.ps1);
    - die bereits gelaufenen Starts von Hand in tools/TESTLAEUFE.md
      nachtragen, mit der Freigabe, auf die sie sich stuetzten.

  Arbeitsweise/jeder-start-ins-protokoll.md
  Arbeitsweise/nichts-auf-gregors-bildschirm-starten.md

ENDE

exit($nurmelden ? 0 : 1);
