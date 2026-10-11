#!/usr/bin/perl
use strict;
use warnings;

# pruefe-befund-verbreitung.pl - steht jeder Befund der neuesten Fassung
# ueberall, wo er hingehoert?
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE SCHRANKE GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 17.09.2026, nachdem alle sieben vorhandenen Doku-Schranken gruen
# gemeldet hatten:
#
#     "ist auch changelog und readme usw. (alle MD) aktualiert?"
#
# Von Hand nachgezaehlt war die Antwort NEIN. E-103 fehlte in WEITERMACHEN.md,
# AUFGABEN.md und ZIEL.md; E-104 in README.md, AUFGABEN.md und ZIEL.md. Sechs
# Luecken - und beide Befunde waren in CHANGELOG.md und BEFUNDE.md
# ausfuehrlich beschrieben. Der Eindruck war also "ist dokumentiert".
#
# Danach, unmissverstaendlich:
#
#     "nein, keine luegen auf main"
#
# WARUM KEINE DER SIEBEN SCHRANKEN DAS FING: sie pruefen Fassungsnummern,
# Staende, Belege, Zitate und Zeilenenden - jede misst, ob das DASTEHENDE
# stimmt. Keine misst, ob etwas FEHLT. Eine Datei, die einen Befund gar nicht
# erwaehnt, widerspricht niemandem; sie schweigt. Und Schweigen liest sich
# beim naechsten Mal wie "gibt es nicht".
#
# Die Lehre dazu heisst Arbeitsweise/doku-parallel-nicht-hinterher.md: ein
# Wert, der mehrfach vorkommt, wird im SELBEN Arbeitsschritt ueberall
# berichtigt. Sie stand seit Tagen da und hat nicht gewirkt, weil ihr der
# Ausloeser fehlte - genau das, was
# Arbeitsweise/lehren-anwenden-nicht-nur-schreiben.md beschreibt.
#
# ---------------------------------------------------------------------------
# WAS SIE PRUEFT
# ---------------------------------------------------------------------------
#
# Umfang aus der Quelle, nicht von Hand
# (Arbeitsweise/pruefumfang-nicht-von-hand.md): die Befundkennungen des
# JUENGSTEN CHANGELOG-Abschnitts. Was dort steht, ist das, was gerade
# ausgeliefert wird - und muss in den fuehrenden Dokumenten vorkommen.
#
# Geprueft wird nur auf VORKOMMEN, nicht auf Wortlaut. Eine Schranke, die den
# Text vorschreibt, erzieht zu Textbausteinen; eine, die das Schweigen findet,
# reicht.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-befund-verbreitung.pl            prueft
#   perl tools/pruefe-befund-verbreitung.pl --tests    Selbsttest
#
# Rueckgabe: 0 = vollstaendig, 1 = eine Datei schweigt, 2 = Aufrufproblem.

# ---------------------------------------------------------------------------
# WAS AM 18.09.2026 DARAN BERICHTIGT WURDE (PRUEFER-17, Befund E-109)
# ---------------------------------------------------------------------------
#
# Diese Schranke war BEIM ERSTEN ECHTEN LAUF BLIND. Nachgemessen am
# 18.09.2026 gegen die Fassung, um die es ging:
#
#   Der Abschnitt "## 7.2.0.70" hat genau drei Ueberschriften -
#     "## 7.2.0.70 - ein vollstaendiger Stand zum Testen, und die Paketliste
#      wieder geradegezogen"
#     "### Warum es zwei Fassungsnummern 1.0.68 gab"
#     "### Was in welchem Paket steckt"
#   KEINE davon nennt eine Kennung. Im Fliesstext desselben Abschnitts stehen
#   E-101, E-103, E-104 und E-106.
#
#   Umfang also 0 -> Ausgabe "nennt keinen Befund - nichts zu pruefen",
#   Rueckgabe 0. Gruen, ohne eine einzige Pruefung.
#
# Zwei Aenderungen, beide aus E-109:
#
#   1. UMFANG 0 IST KEIN FREISPRUCH. Findet die Schranke keinen Befund, sagt
#      sie das und gibt 1 zurueck. E-109, Punkt 4: "geprueft und frei" und
#      "nichts gefunden zu pruefen" duerfen nicht gleich aussehen. Aufloesbar
#      ist der Zustand in einem Schritt: die Befunde in die Ueberschrift des
#      CHANGELOG-Abschnitts schreiben, wo sie ohnehin hingehoeren.
#
#   2. ZWEITE QUELLE FUER DEN UMFANG: BEFUNDE.md. Was dort als
#      "behoben in 7.2.0.NN" mit der AKTUELLEN Fassungsnummer steht, gehoert
#      in die fuehrenden Dokumente - unabhaengig davon, wie der CHANGELOG
#      seine Ueberschriften formuliert. Die Fassungsnummer kommt aus
#      Eudora71/Version.h, nicht von Hand
#      (Arbeitsweise/pruefumfang-nicht-von-hand.md).
#
#      Der Fliesstext bleibt AUSSEN VOR - er hat am 17.09.2026 drei Fehlalarme
#      erzeugt (Querverweise auf E-89, E-95, E-96, E-98, E-100 im .67-Abschnitt).
#      Die zweite Quelle ist schaerfer als der Fliesstext und trifft dieselben
#      Faelle.
#
# ---------------------------------------------------------------------------

my $wurzel = -f 'VERSION' ? '.' : '..';

# Die Dateien, die einen ausgelieferten Befund nennen muessen. Bewusst kurz:
# jede weitere Datei macht die Schranke lauter, ohne sie besser zu machen.
my @PFLICHT = qw(
    BEFUNDE.md
    README.md
    WEITERMACHEN.md
    AUFGABEN.md
    ZIEL.md
);

# ---------------------------------------------------------------------------
sub lies {
    my ($pfad) = @_;
    open my $h, '<:raw', $pfad or return undef;
    my $t = do { local $/; <$h> };
    close $h;
    return $t;
}

# Die Kennungen aus dem juengsten CHANGELOG-Abschnitt.
#
# Der Abschnitt reicht von der ersten "## "-Zeile bis zur naechsten. Gesucht
# werden Kennungen der Form E-NN, NP-NN, PR-NN - dieselbe Form, die
# BEFUNDE.md in der ersten Spalte fuehrt.
#
# P-NN, M-NN, L-NN und S-NN sind Punkte INNERHALB eines Berichts von PRUEFER
# oder LEKTOR, keine eigenen Befunde. Sie gehoeren in den Bericht, nicht in
# die fuehrenden Dokumente, und werden deshalb uebergangen.
sub kennungen_der_neuesten_fassung {
    my ($changelog) = @_;

    #
    # NUR ein Fassungsabschnitt zaehlt - "## 7.2.0.NN ...".
    #
    # Der erste Entwurf nahm den ERSTEN "## "-Abschnitt. Das war im echten
    # CHANGELOG der Abschnitt "Noch offen (Stand ...)", der jeden offenen
    # Befund des Projekts auffuehrt - 29 Kennungen, 54 Fehlalarme. Eine
    # Schranke, die so laut ist, wird abgeschaltet und ist dann so wertlos
    # wie eine stumme (Arbeitsweise/schranke-gegentesten.md).
    #
    my ($abschnitt) = $changelog =~ /^(## \d+\.\d+\.\d+\.\d+ .*?)(?=^## |\z)/ms;
    return () unless defined $abschnitt;

    my ($ueberschrift) = $abschnitt =~ /^## ([^\n]*)/;
    $ueberschrift = '' unless defined $ueberschrift;

    #
    # Gezaehlt werden nur die Kennungen in den UEBERSCHRIFTEN des Abschnitts -
    # "## 7.2.0.67 ... (E-103)" und "### ... (E-104)".
    #
    # Der zweite Entwurf nahm jede Kennung aus dem Fliesstext. Damit zaehlten
    # auch QUERVERWEISE mit: der .67-Abschnitt erwaehnt E-89, E-95, E-96, E-98
    # und E-100, um den Zusammenhang zu erklaeren - Gegenstand der Fassung
    # sind sie nicht. Drei weitere Fehlalarme.
    #
    # In der Ueberschrift steht, worum es geht. Das ist scharf genug: beim
    # Fall vom 17.09.2026 standen dort genau E-103 und E-104 - die beiden,
    # die fehlten.
    #
    my %gesehen;
    for my $zeile (split /\n/, $abschnitt) {
        next unless $zeile =~ /^#{2,3}\s/;

        while ($zeile =~ /\b([A-Z]{1,3}\d*-\d+)\b/g) {
            my $k = $1;

            # Punkte aus einem Bericht von PRUEFER oder LEKTOR, keine Befunde.
            next if $k =~ /^[PMLS]-\d+$/;

            # UTF-7 und UTF-8 sind Zeichensaetze, keine Kennungen.
            next if $k =~ /^UTF-\d+$/;

            $gesehen{$k} = 1;
        }
    }
    return ($ueberschrift, sort keys %gesehen);
}

# Die Fassungsnummer, gegen die gemessen wird - aus Eudora71/Version.h, nicht
# von Hand (Arbeitsweise/pruefumfang-nicht-von-hand.md).
sub quellstand {
    my ($versionh) = @_;
    return undef unless defined $versionh;
    return $versionh =~ /EUDORA_BUILD_VERSION\s+"(\d+\.\d+\.\d+\.\d+)"/ ? $1 : undef;
}

# Zweite Quelle fuer den Umfang: die Befunde, die BEFUNDE.md fuer GENAU diese
# Fassung als behoben fuehrt.
#
# BEFUNDE.md ist eine Tabelle; die Kennung steht in der ersten Spalte, das
# Urteil in der letzten. Gesucht wird die Zeile, deren Urteil "behoben in
# <Fassung>" sagt - dieselbe Wendung, die pruefe-behoben-belegt.pl prueft.
sub behoben_in_fassung {
    my ($befunde, $fassung) = @_;
    return () unless defined $befunde && defined $fassung;
    my %gesehen;
    for my $zeile (split /\n/, $befunde) {
        next unless $zeile =~ /^\s*\|\s*\**\s*([A-Z]{1,3}\d*-\d+)\b/;
        my $kennung = $1;
        next if $kennung =~ /^[PMLS]-\d+$/;
        # "behoben in 7.2.0.72", auch "Behoben in", auch mit Fettdruck davor.
        next unless $zeile =~ /behoben\s+in\s+\**\s*\Q$fassung\E\b/i;
        $gesehen{$kennung} = 1;
    }
    return sort keys %gesehen;
}

# ---------------------------------------------------------------------------
# Selbsttest: gegen den echten Fehler UND gegen den erlaubten Fall
# (Arbeitsweise/schranke-gegentesten.md).
# ---------------------------------------------------------------------------
if (grep { $_ eq '--tests' } @ARGV) {
    my $fehler = 0;

    # Der Abschnitt "Noch offen" steht im echten CHANGELOG VOR den
    # Fassungen. Er darf nicht gewaehlt werden - sonst verlangt die
    # Schranke jeden offenen Befund des Projekts in jeder Datei.
    my $cl = "## Noch offen (Stand 17.09.2026)\n\n"
           . "E-90, E-91, E-94, UTF-7, UTF-8\n\n"
           . "## 7.2.0.67 - Bilder (E-103)\n\n"
           . "Querverweis auf E-96 im Fliesstext, dazu P-28 und M-1.\n\n"
           . "### Kopfzeilen (E-104)\n\nText.\n\n"
           . "## 7.2.0.66 - alt (E-101)\n";

    my ($ueber, @k) = kennungen_der_neuesten_fassung($cl);

    unless (join(' ', @k) eq 'E-103 E-104') {
        print "  FEHLER Selbsttest 1: erwartet 'E-103 E-104', bekommen '"
            . join(' ', @k) . "'\n";
        $fehler++;
    }
    unless ($ueber =~ /7\.2\.0\.67/) {
        print "  FEHLER Selbsttest 2: Ueberschrift nicht erkannt ($ueber)\n";
        $fehler++;
    }

    # Der Fall, um dessentwillen es die Schranke gibt: eine Datei schweigt.
    my %dateien = (
        'A.md' => 'hier steht E-103 und E-104',
        'B.md' => 'hier steht nur E-103',
    );

    my @mangel;
    for my $k (@k) {
        for my $d (sort keys %dateien) {
            push @mangel, "$d nennt $k nicht" unless $dateien{$d} =~ /\Q$k\E/;
        }
    }
    unless (@mangel == 1 && $mangel[0] eq 'B.md nennt E-104 nicht') {
        print "  FEHLER Selbsttest 3: erwartet genau einen Mangel, bekommen: "
            . join(' | ', @mangel) . "\n";
        $fehler++;
    }

    # Und der erlaubte Fall muss durchlaufen, ohne Fehlalarm.
    $dateien{'B.md'} .= ' und E-104';
    my @keine;
    for my $k (@k) {
        for my $d (sort keys %dateien) {
            push @keine, "$d/$k" unless $dateien{$d} =~ /\Q$k\E/;
        }
    }
    if (@keine) {
        print "  FEHLER Selbsttest 4: Fehlalarm bei vollstaendigen Dateien ("
            . join(' ', @keine) . ")\n";
        $fehler++;
    }

    # --- 5. DER ECHTE FALL 7.2.0.70, an dem sie blind war ------------------
    #
    # Woertlich nachgestellt: drei Ueberschriften ohne jede Kennung, die
    # Befunde nur im Fliesstext.
    my $cl70 = "## 7.2.0.70 - ein vollstaendiger Stand zum Testen, und die Paketliste wieder geradegezogen\n\n"
             . "Enthaelt E-101 in beiden Teilen, E-103, E-104 und E-106.\n\n"
             . "### Warum es zwei Fassungsnummern 1.0.68 gab\n\nText.\n\n"
             . "### Was in welchem Paket steckt\n\nText.\n\n"
             . "## 7.2.0.69 - alt\n";
    my ($u70, @k70) = kennungen_der_neuesten_fassung($cl70);
    unless (@k70 == 0) {
        print "  FEHLER Selbsttest 5: erwartet 0 Kennungen aus den Ueberschriften, bekommen '"
            . join(' ', @k70) . "'\n";
        $fehler++;
    }

    # --- 6. Die zweite Quelle faengt, was die Ueberschrift verschweigt -----
    my $befunde = "| Nr | Sache | Urteil |\n"
                . "|---|---|---|\n"
                . "| E-106 | Bilder liegen ueber dem Text | **behoben in 7.2.0.68**, von Gregor bestaetigt |\n"
                . "| E-108 | Absturz beim Antworten | **behoben in 7.2.0.72**, von Gregor bestaetigt |\n"
                . "| E-98 | Etwas Offenes | offen |\n"
                . "| P-39 | Punkt aus einem Bericht | behoben in 7.2.0.72 |\n";
    my @b72 = behoben_in_fassung($befunde, '7.2.0.72');
    unless (join(' ', @b72) eq 'E-108') {
        print "  FEHLER Selbsttest 6: erwartet 'E-108', bekommen '" . join(' ', @b72) . "'\n";
        $fehler++;
    }

    # Erlaubter Fall: eine ANDERE Fassung darf nicht mitgezaehlt werden.
    my @b68 = behoben_in_fassung($befunde, '7.2.0.68');
    unless (join(' ', @b68) eq 'E-106') {
        print "  FEHLER Selbsttest 7: erwartet 'E-106', bekommen '" . join(' ', @b68) . "'\n";
        $fehler++;
    }

    # --- 8. Die Fassungsnummer kommt aus Version.h ------------------------
    my $vh = "#define EUDORA_BUILD_DESC      \"Version 7.2.0.72\\0\"\n"
           . "#define EUDORA_BUILD_VERSION   \"7.2.0.72\"\n";
    unless ((quellstand($vh) // '') eq '7.2.0.72') {
        print "  FEHLER Selbsttest 8: Quellstand nicht gelesen ("
            . (quellstand($vh) // 'undef') . ")\n";
        $fehler++;
    }

    # --- 9. Umfang 0 ist kein Freispruch ----------------------------------
    #
    # Genau das war der Zustand am 17.09.2026: keine Kennung in den
    # Ueberschriften, keine in BEFUNDE.md fuer diese Fassung - und gruen.
    my @umfang0 = do {
        my %u;
        $u{$_} = 1 for (@k70, behoben_in_fassung($befunde, '7.2.0.70'));
        sort keys %u;
    };
    unless (@umfang0 == 0) {
        print "  FEHLER Selbsttest 9: erwartet Umfang 0 fuer 7.2.0.70, bekommen '"
            . join(' ', @umfang0) . "'\n";
        $fehler++;
    }

    if ($fehler) {
        printf "\n  %d Selbsttest(s) fehlgeschlagen.\n\n", $fehler;
        exit 1;
    }
    print "\n  Selbsttest: 9 von 9 bestanden - darunter die beiden Fehlalarme,\n"
        . "  die der erste und der zweite Entwurf geworfen haben, und der echte\n"
        . "  Fall 7.2.0.70, an dem diese Schranke am 17.09.2026 blind war.\n\n";
    exit 0;
}

# ---------------------------------------------------------------------------
my $changelog = lies("$wurzel/CHANGELOG.md");
unless (defined $changelog) {
    print "  pruefe-befund-verbreitung: CHANGELOG.md nicht gefunden - bitte\n";
    print "  aus dem Wurzelverzeichnis aufrufen.\n";
    exit 2;
}

my ($ueberschrift, @aus_ueberschrift) = kennungen_der_neuesten_fassung($changelog);

# Zweite Quelle: BEFUNDE.md, gegen die Fassung aus Version.h.
my $fassung = quellstand(lies("$wurzel/Eudora71/Version.h"));
my @aus_befunden = behoben_in_fassung(lies("$wurzel/BEFUNDE.md"), $fassung);

my @kennungen = do {
    my %u;
    $u{$_} = 1 for (@aus_ueberschrift, @aus_befunden);
    sort keys %u;
};

printf "\n  %s\n  Befunde der neuesten Fassung in allen fuehrenden Dokumenten\n  %s\n",
    '-' x 60, '-' x 60;
printf "    Abschnitt                      %s\n", $ueberschrift;
printf "    Fassung (Version.h)            %s\n", $fassung // '(nicht gelesen)';
printf "    aus den Ueberschriften         %s\n",
    @aus_ueberschrift ? join(', ', @aus_ueberschrift) : '(keine)';
printf "    aus BEFUNDE.md (behoben in %s)  %s\n", $fassung // '?',
    @aus_befunden ? join(', ', @aus_befunden) : '(keine)';
printf "    Geprueft in                    %d Datei(en)\n", scalar @PFLICHT;

# UMFANG 0 IST KEIN FREISPRUCH (E-109, Punkt 4).
#
# Genau hier war die Schranke am 17.09.2026 blind: der Abschnitt 7.2.0.70
# nannte seine vier Befunde nur im Fliesstext, die Ueberschriften keinen -
# Umfang 0, Meldung "nichts zu pruefen", Rueckgabe 0.
unless (@kennungen) {
    print <<"ENDE";

  NICHTS GEPRUEFT - das ist kein gruenes Ergebnis.

  Weder eine Ueberschrift des Abschnitts noch BEFUNDE.md nennt einen Befund
  fuer diese Fassung. Damit hat diese Schranke NICHTS angesehen, und das darf
  nicht aussehen wie "alles in Ordnung" (E-109, Punkt 4).

  Genau dieser Zustand lag am 17.09.2026 bei 7.2.0.70 vor: die Befunde E-101,
  E-103, E-104 und E-106 standen im Fliesstext des Abschnitts, in keiner
  Ueberschrift - und die Schranke meldete gruen.

  Aufzuloesen in einem Schritt: die Kennungen in die Ueberschrift des
  CHANGELOG-Abschnitts schreiben, z. B.

      ## $fassung - ... (E-101, E-103, E-104, E-106)

  Dort gehoeren sie ohnehin hin; in der Ueberschrift steht, worum es geht.
  Bringt die Fassung wirklich keinen Befund mit, gehoert das ebenso in die
  Ueberschrift - dann ist es eine Aussage und keine Luecke.

ENDE
    exit 1;
}

my @mangel;
for my $k (@kennungen) {
    for my $d (@PFLICHT) {
        my $inhalt = lies("$wurzel/$d");
        unless (defined $inhalt) {
            push @mangel, "$d fehlt ganz";
            next;
        }
        push @mangel, "$d nennt $k nicht" unless $inhalt =~ /\Q$k\E/;
    }
}

unless (@mangel) {
    print "\n  Jeder Befund der neuesten Fassung steht in allen fuehrenden\n";
    print "  Dokumenten.\n\n";
    exit 0;
}

printf "\n  MANGEL - %d Stelle(n) schweigen:\n\n", scalar @mangel;
print "    - $_\n" for @mangel;

print <<'ENDE';

  Eine Datei, die einen Befund gar nicht erwaehnt, widerspricht niemandem -
  sie schweigt. Und Schweigen liest sich beim naechsten Mal wie "gibt es
  nicht". Genau deshalb haben am 17.09.2026 alle sieben anderen Schranken
  gruen gemeldet, waehrend E-103 in drei und E-104 in drei Dateien fehlte.

  Gregor dazu: "nein, keine luegen auf main".

  Also: den Befund dort nachtragen, wo er hingehoert - im SELBEN
  Arbeitsschritt, nicht spaeter
  (Arbeitsweise/doku-parallel-nicht-hinterher.md).

ENDE
exit 1;
