#!/usr/bin/perl
#
# Prueft die Dokumentation gegen sich selbst und gegen den Quellstand.
#
#   perl tools/doku-pruefen.pl              prueft und meldet
#   perl tools/doku-pruefen.pl --leise      nur Rueckgabewert, keine Ausgabe
#
# Rueckgabe 0 = kein Mangel, 1 = Mangel gefunden, 2 = Aufruffehler.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 06.09.2026 hat Gregor drei Widersprueche gefunden, die alle drei aus
# meiner eigenen Feder stammten und die kein Mensch haette finden muessen:
#
#   1. CHANGELOG.md behauptete "Alle vier Kriterien sind erfuellt", waehrend
#      ZIEL.md "drei von vier belegt, eines fast" sagte. Dieselbe falsche
#      Behauptung stand in README.md und WEITERMACHEN.md; PORTIERUNG.md stand
#      noch auf "zwei von vier".
#   2. ZIEL.md fuehrte vier Kriterien in der Tabelle, obwohl sieben verabredet
#      waren - drei standen in einem eigenen Abschnitt weiter unten.
#   3. Die Offen-Tabelle im CHANGELOG vergab die Kennung E-31 ZWEIMAL: einmal
#      fuer "File -> Exit", obwohl E-31 die behobene pg_time_t-Sache ist.
#
# Seine Worte: "ich traue dir nicht ganz, jemand soll dich immer wieder
# ueberpruefen - das bin aber nicht ich!"
#
# WAS AM 07.09.2026 GEAENDERT WURDE (Befund L-7)
#
# Der erste Anlauf hat acht Widersprueche gemeldet, und VIER davon waren
# Fehlalarme - alle aus derselben Wurzel: die Statuspruefung nahm JEDES Wort
# "offen" oder "behoben" IRGENDWO in derselben Zeile als Status der Kennung.
# Gemeldet wurde dadurch:
#
#   E-7   "die Bau-Kennung fehlt, solange kein Postfach OFFEN ist"
#         - "offen" heisst hier: das Postfach ist aufgeklappt.
#   E-11  "| R-1 | die Fehlerklasse hinter E-11 ausgezaehlt | **offen** ..."
#         - der Status gehoert R-1, E-11 wird nur erwaehnt.
#   E-14, E-16
#         "**Z-3** stand auf offen, ist aber behoben; **E-14**, **E-16**, ...
#          fehlten im Verzeichnis"  - der Status gehoert Z-3.
#
# Eine Schranke, die umsonst warnt, wird ignoriert (Befund X-1). Deshalb gilt
# jetzt: ein Status zaehlt nur, wenn die Kennung ihn BESITZT - sie steht allein
# in der ERSTEN Spalte einer Verzeichniszeile, und der Status steht **fett**.
# Alles andere ist Prosa und wird nicht gelesen. Dafuer sind drei scharfe
# Pruefungen dazugekommen: doppelte Ueberschrift, CHANGELOG gegen das
# Verzeichnis, Version.h gegen sich selbst.

use strict;
use warnings;
use File::Spec;

my $leise = grep { $_ eq '--leise' } @ARGV;
my @mangel;
my @zutun;
my @hinweis;

sub lies {
    my ($pfad) = @_;
    return undef unless -f $pfad;
    open(my $h, '<:raw', $pfad) or return undef;
    local $/;
    my $inhalt = <$h>;
    close $h;
    return $inhalt;
}

# Ein Zustandswort auf einen von vier Werten bringen. Alles andere liefert
# undef - damit zaehlen nur Woerter, die wirklich einen Zustand nennen, und
# eine Auszeichnung wie **Kriterium 7** oder *File -> Exit* wird ignoriert.
# "nicht erfuellt" MUSS vor "erfuellt" geprueft werden, sonst schluckt der
# Teilstring die Verneinung.
sub normzustand {
    my ($wort) = @_;
    return undef unless defined $wort;
    my $w = lc $wort;
    $w =~ s/\x{c3}\x{bc}/ue/g;   # UTF-8 u-Umlaut
    $w =~ s/^\s+|\s+$//g;
    return 'nicht erfuellt' if $w =~ /^nicht\s+erfuellt$/;
    return 'erfuellt'       if $w =~ /^erfuellt$/;
    return 'fast'           if $w =~ /^fast$/;
    return 'halb'           if $w =~ /^halb$/;
    return undef;
}

# --- 1. Quellstand ------------------------------------------------------------
my $version_h = lies('Eudora71/Version.h') || '';
my $paket     = lies('VERSION') || '';
$paket =~ s/\s+\z//;
my ($quellstand) = $version_h =~ /EUDORA_BUILD_VERSION\s+"([0-9.]+)"/;
$quellstand = '' unless defined $quellstand;

unless (length $quellstand && length $paket) {
    print "doku-pruefen: Version.h oder VERSION nicht lesbar - nichts geprueft.\n" unless $leise;
    exit 2;
}

# --- 2. Die Dateien, die den AKTUELLEN Stand behaupten ------------------------
# Bis zum 07.09.2026 stand hier eine Liste von fuenf Dateinamen, von Hand
# gepflegt. Gregor fand daraufhin selbst drei Widersprueche und sagte: "ich
# moechte dir nicht jede einzelne MD datei nennen, es betrifft ALLE!" - eine
# Schranke, der man ihren Umfang von Hand nennen muss, prueft genau die Dateien
# nicht, an die niemand gedacht hat. Gemessen an jenem Tag: 47 MD-Dateien im
# Repo, davon kamen 16 in LEKTORAT.md nie vor.
#
# Deshalb holt sich das Werkzeug die Liste jetzt selbst aus git. Ausgenommen
# sind nur zwei Gruppen, und zwar mit Begruendung:
#   - Arbeitsweise/  ist ein Spiegel des Gedaechtnisses (tools/lehren-spiegeln.pl);
#     eine Aenderung dort geht beim naechsten Spiegeln verloren. Die Quelle liegt
#     im Gedaechtnisverzeichnis und wird dort nachgezogen (Befund NP3-4).
#   - Zeitdokumente (Befunde/, Pruefung/, BEFUNDE.md, LEKTORAT.md, PRUEFUNG-*.md,
#     Releases/PAKETE.md, Releases/1.0/) beschreiben einen Zustand von damals und
#     DUERFEN alte Zahlen nennen. Sie werden nur auf Widersprueche in Befund-IDs
#     geprueft, nicht auf Aktualitaet.
# 2>NUL legt unter Git Bash eine DATEI namens NUL an - am 07.09.2026 im
# Arbeitsbaum aufgeschlagen. File::Spec->devnull() liefert den richtigen
# Namen fuer die jeweilige Umgebung.
my $nirgendwo = File::Spec->devnull();
my @alle_md = grep { length } split /
/, (qx{git ls-files "*.md" 2>$nirgendwo} || '');
@alle_md = grep { !m{^Arbeitsweise/} } @alle_md;

# tools/TESTLAEUFE.md ist am 09.09.2026 dazugekommen (Befund L-11.2): die
# Datei ist ein von tools/testlauf.ps1 fortgeschriebenes PROTOKOLL vergangener
# Laeufe. Sie nennt zwangslaeufig die Fassung, mit der damals getestet wurde,
# und wurde deshalb bei jedem Lauf unter "Zur Kenntnis" gemeldet, ohne dass
# jemand etwas daran tun konnte. Eine Schranke, die umsonst warnt, wird
# ignoriert (Befund X-1).
my $zeitdokument = qr{^(?:Befunde/|Pruefung/|Releases/1\.0/|BEFUNDE\.md$|LEKTORAT\.md$|PRUEFUNG-|ABRUF-PRUEFEN\.md$|Releases/PAKETE\.md$|tools/TESTLAEUFE\.md$)};
my @aktuell   = grep { $_ !~ $zeitdokument } @alle_md;
my @zeitdok   = grep { $_ =~ $zeitdokument } @alle_md;

unless (@aktuell) {
    print "doku-pruefen: git ls-files liefert keine MD-Dateien - nichts geprueft.\n" unless $leise;
    exit 2;
}

# --- 3. Kriterienzahl: ZIEL.md ist die Quelle --------------------------------
my $ziel = lies('ZIEL.md');
my $anzahl_kriterien = 0;
if (defined $ziel) {
    my %gesehen;
    while ($ziel =~ /^\|\s*(\d+)\s*\|/gm) { $gesehen{$1} = 1 }
    $anzahl_kriterien = scalar keys %gesehen;
}

if ($anzahl_kriterien == 0) {
    push @mangel, "ZIEL.md: keine Kriterientabelle gefunden - ohne sie ist nichts pruefbar";
}

# Wortzahlen, die jemand hinschreibt, gegen die tatsaechliche Zahl
#
# WAS AM 08.09.2026 GEAENDERT WURDE (Befund L-10.1)
#
# In dieser Tabelle fehlten "neun" und "zehn" - und ZIEL.md fuehrt NEUN
# Kriterien. Damit war die Kriterienpruefung fuer den tatsaechlichen Umfang des
# Projekts BLIND: "$gesamt = $wort{'neun'}" lieferte undef, und beide Pruefungen
# (Wortzahl gegen ZIEL.md, Summe der Teile) brachen mit "next unless defined"
# ab. Gemessen an ZIEL.md:39, wo bis zum 08.09.2026 stand:
#
#   "Sechs von neun Kriterien sind belegt (0, 1, 3, 5, 6, 7), zwei fast oder
#    halb (2, 4), eines nicht (8 - die Reiterleiste)."
#
# Das widersprach der eigenen Tabelle DREI Zeilen darueber, die fuer Kriterium 8
# "halb" sagt - und die Schranke hat es nie gemeldet.
my %wort = (
    zwei => 2, drei => 3, vier => 4, fuenf => 5, sechs => 6, sieben => 7,
    acht => 8, neun => 9, zehn => 10,
);
for my $datei (@aktuell) {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    my @zeilen = split /\n/, $inhalt;
    for my $i (0 .. $#zeilen) {
        my $z = $zeilen[$i];
        # "vier Kriterien", "alle vier Kriterien", "sieben Kriterien"
        # Das \*{0,2} ist am 08.09.2026 dazugekommen (Befund L-10.1): in
        # PORTIERUNG.md:38 steht "von **neun** Kriterien" - die Auszeichnung
        # zwischen Zahlwort und Wort liess das Muster ins Leere laufen, und die
        # Zahl wurde nie gegen ZIEL.md gehalten.
        while ($z =~ /(zwei|drei|vier|fuenf|sechs|sieben|acht|neun|zehn)\*{0,2}\s+Kriterien/gi) {
            my $genannt = $wort{ lc $1 };
            next unless defined $genannt;
            # "die ersten vier Kriterien" ist eine Aussage ueber eine Teilmenge
            next if $z =~ /ersten\s+(zwei|drei|vier|fuenf|sechs|sieben|acht)\s+Kriterien/i;
            if ($genannt != $anzahl_kriterien) {
                push @mangel, sprintf("%s:%d nennt %d Kriterien, ZIEL.md fuehrt %d",
                                      $datei, $i + 1, $genannt, $anzahl_kriterien);
            }
        }
    }
}

# Zusaetzlich: die SUMME der genannten Teile muss zur Kriterienzahl passen.
# Am 07.09.2026 stand in README.md und WEITERMACHEN.md "Neun Kriterien ... drei
# belegt, eines fast, vier nicht" - das sind acht. Das Werkzeug hatte nur das
# Wort vor "Kriterien" geprueft und die Summe uebersehen.
for my $datei (@aktuell) {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    # Zahlwoerter im Satz nach "N Kriterien" bis zum Satzende sammeln.
    my @zeilen = split /\n/, $inhalt;
    for my $i (0 .. $#zeilen) {
        my $satz = $zeilen[$i];
        $satz .= " " . $zeilen[$i+1] if $i < $#zeilen;
        next unless $satz =~ /(zwei|drei|vier|fuenf|sechs|sieben|acht|neun|zehn)\s+Kriterien\s*(?:stehen|sind)?/i;
        my $gesamt = $wort{ lc $1 };
        next unless defined $gesamt;
        # Achtung: der Satz enthaelt Punkte im Verweis "[ZIEL.md](ZIEL.md)".
        # Ein Muster mit [^.] scheitert daran - am 07.09.2026 blieb die
        # Summenpruefung deshalb stumm, obwohl die Summe falsch war.
        my ($rest) = $satz =~ /Kriterien\b(.*?)\.\*\*/;
        next unless defined $rest;
        my $summe = 0;
        while ($rest =~ /\b(zwei|drei|vier|fuenf|sechs|sieben|acht|neun|zehn)\b/gi) {
            $summe += $wort{ lc $1 };
        }
        next unless $summe;
        if ($summe != $gesamt) {
            push @mangel, sprintf("%s:%d nennt %d Kriterien, die Aufteilung ergibt aber %d",
                                  $datei, $i + 1, $gesamt, $summe);
        }
    }
}


# --- 3b. Der ZUSTAND jedes einzelnen Kriteriums ------------------------------
#
# Gregor am 08.09.2026, nachdem ich gemeldet hatte, ich muesse zwei
# Falschaussagen in main berichtigen: "per anweisung ist sowas nicht erlaubt
# und nicht moeglich."
#
# Er hat recht, und die Schranke hier ist schuld. Sie prueft seit dem
# 07.09.2026 die ANZAHL der Kriterien und die Summe der Aufteilung - aber
# nicht, was ueber ein EINZELNES Kriterium behauptet wird. Deshalb stand in
# CHANGELOG.md ueber den Merge hinweg
#
#     | **Kriterium 7** (Beenden) | **nicht erfuellt** - der einzige
#       verbliebene Fehler der zweiten Stufe |
#
# waehrend ZIEL.md Kriterium 7 als **erfuellt** fuehrt, von Gregor bestaetigt.
# Zwei Tage lang, in main, unbemerkt.
#
# ZIEL.md ist die Quelle. Wer anderswo einen Zustand behauptet, muss denselben
# behaupten.
#
# NICHT gemeldet wird:
#   - eine Zeile unter einer Ueberschrift, die eine Fassung nennt (die
#     CHANGELOG-Abschnitte sind Zeitdokumente: "## 7.2.0.21 ..." darf sagen,
#     was damals galt)
#   - eine Zeile mit einem Datum darin
#   - eine Zeile, die sich selbst als Rueckschau kennzeichnet (war, damals,
#     frueher, ueberholt, Behauptung)
# Dieselben Ausschluesse benutzt Pruefung 5c.

my %kriterium_zustand;   # Nummer -> Zustand aus ZIEL.md
{
    my $ziel = lies('ZIEL.md');
    if (defined $ziel) {
        for my $z (split /\n/, $ziel) {
            next unless $z =~ /^\|\s*([0-8])\s*\|/;
            my $nr = $1;
            # letzte fett- oder kursivgesetzte Auszeichnung der Zeile ist der Zustand
            my @aus = ($z =~ /\*\*([^*]+)\*\*|\*([^*]+)\*/g);
            my $zustand;
            for my $a (@aus) {
                next unless defined $a;
                my $k = normzustand($a);
                $zustand = $k if defined $k;
                last if defined $zustand;
            }
            $kriterium_zustand{$nr} = $zustand if defined $zustand;
        }
    }
}

if (!keys %kriterium_zustand) {
    push @mangel, 'ZIEL.md: aus der Kriterientabelle laesst sich kein einziger '
                . 'Zustand lesen - dann ist der Zustand nirgends pruefbar';
}

for my $datei (@alle_md) {
    next if $datei eq 'ZIEL.md';
    # Zeitdokumente sagen, was AN JENEM TAG galt, und duerfen dem heutigen
    # Stand widersprechen - dieselbe Liste wie in Pruefung 4 und 9.
    # Ohne das meldete die Schranke Befunde/LEKTOR-5.md:112, wo der Lektor am
    # 08.09.2026 gerade BEANSTANDET, dass Kriterium 7 falsch gefuehrt wird.
    next if $datei =~ $zeitdokument;
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    my @z = split /\n/, $inhalt;
    my $ueberschrift = '';

    for my $i (0 .. $#z) {
        my $zeile = $z[$i];
        $ueberschrift = $zeile if $zeile =~ /^\#{1,6}\s/;

        # Zeitdokument-Abschnitt? Ueberschrift nennt eine Fassung.
        next if $ueberschrift =~ /\b\d+\.\d+\.\d+\.\d+\b/;
        next if $ueberschrift =~ /\b1\.0\.\d+\b/;

        next if $zeile =~ /\d{2}\.\d{2}\.20\d\d/;
        next if $zeile =~ /\bwar\b|damals|frueher|ueberholt|\x{c3}\x{bc}berholt|Behauptung|behauptete/i;

        # Die Zustandswoerter EINMAL pro Zeile sammeln, aus einer KOPIE.
        #
        # Hier lag am 09.09.2026 eine Endlosschleife: die innere Suche lief
        # mit /g im Listenkontext auf derselben Zeichenkette wie die aeussere
        # while-Schleife. Das setzt pos($zeile) zurueck, die aeussere Suche
        # faengt wieder von vorn an und kommt nie ans Ende. Gemessen: 1939 ms
        # ohne diese Pruefung, ueber 200000 ms mit ihr.
        # Die Auszeichnungen der Zeile EINMAL sammeln, aus einer KOPIE, und zu
        # jeder mitschreiben, ob unmittelbar davor ein "nicht" steht.
        #
        # Hier lag am 09.09.2026 eine Endlosschleife: die innere Suche lief
        # mit /g im Listenkontext auf derselben Zeichenkette wie die aeussere
        # while-Schleife. Das setzt pos($zeile) zurueck, die aeussere Suche
        # faengt wieder von vorn an und kommt nie ans Ende. Gemessen: 1939 ms
        # ohne diese Pruefung, ueber 200000 ms mit ihr. Die Suche laeuft
        # deshalb weiter nur auf $kopie.
        my $kopie = $zeile;
        my @aus;                       # [Wort, verneint?]
        while ($kopie =~ /\*\*([^*]+)\*\*|\*([^*]+)\*/g) {
            my $wort = defined $1 ? $1 : $2;
            next unless defined $wort;
            my $vor = substr($kopie, 0, $-[0]);
            push @aus, [ $wort, ($vor =~ /\bnicht\s+$/i) ? 1 : 0 ];
        }

        # VON WELCHEM Kriterium handelt die Zeile?
        #
        # Erste Falle, gemessen am 08.09.2026: CHANGELOG.md:27 ist die Zeile
        # ueber Kriterium 4 (Zustand "fast", richtig) und erwaehnt im Text
        # nebenbei "Kriterium 7". Die erste Fassung dieser Pruefung hat das
        # "fast" dem Kriterium 7 zugeordnet und Alarm geschlagen. Der Zustand
        # in einer Zeile gehoert dem Kriterium, VON DEM die Zeile handelt -
        # und das ist das ZUERST genannte.
        #
        # Zweite Falle, gemessen am 09.09.2026 (Befund L-11.1, Fehlalarm):
        #
        #   AUFGABEN.md:19  "| 4 | **Keine Abstuerze** | *fast* - ... das
        #                    Beenden ist erledigt (Kriterium 7) ..."
        #
        # Diese Zeile handelt von Kriterium 4 - und das steht in der ERSTEN
        # SPALTE einer Tabelle, nicht als Wort "Kriterium 4". Die Suche fand
        # "Kriterium 7" und ordnete ihm "fast" zu. Deshalb gilt jetzt: traegt
        # die erste Spalte einer Tabellenzeile nur eine Ziffer 0-8, ist DAS
        # der Gegenstand der Zeile. Es ist dieselbe Form, in der die
        # Kriterientabelle in ZIEL.md selbst gelesen wird: "| 4 | ... | ... |".
        my $nr;
        if    ($zeile =~ /^\|\s*([0-8])\s*\|/)                { $nr = $1 }
        elsif ($zeile =~ /Kriterium\s+\*{0,2}([0-8])\*{0,2}/) { $nr = $1 }

        if (defined $nr) {
            my $soll = exists $kriterium_zustand{$nr} ? $kriterium_zustand{$nr} : undef;
            if (defined $soll) {

                for my $a (@aus) {
                    my $ist = normzustand($a->[0]);
                    next unless defined $ist;

                    # Dritte Falle, gemessen am 09.09.2026 (Befund L-11.1,
                    # Fehlalarm):
                    #
                    #   AUFGABEN.md:53  "... der einzige Grund, warum
                    #                    Kriterium 2 und Kriterium 4 nicht
                    #                    *erfuellt* heissen."
                    #
                    # Die Verneinung stand AUSSERHALB der Auszeichnung und
                    # wurde nicht gesehen - die Schranke meldete das genaue
                    # Gegenteil der Aussage. Eine verneinte Auszeichnung sagt
                    # nur "NICHT erfuellt"; das widerspricht ZIEL.md genau
                    # dann, wenn ZIEL.md "erfuellt" sagt, und ist mit "fast"
                    # oder "halb" vertraeglich.
                    if ($a->[1]) {
                        next unless $ist eq 'erfuellt';
                        next unless $soll eq 'erfuellt';
                        push @mangel, sprintf(
                            "%s:%d fuehrt Kriterium %s als 'nicht erfuellt', ZIEL.md sagt '%s'",
                            $datei, $i + 1, $nr, $soll);
                        last;
                    }

                    next if $ist eq $soll;
                    push @mangel, sprintf(
                        "%s:%d fuehrt Kriterium %s als '%s', ZIEL.md sagt '%s'",
                        $datei, $i + 1, $nr, $ist, $soll);
                    last;
                }
            }
        }
    }
}
# --- 4. Befundkennungen ------------------------------------------------------
#
# Ein Status zaehlt nur dort, wo die Kennung ihn BESITZT:
#
#   Verzeichniszeile   | E-30 | worum es geht | **behoben** ... |
#                        ^ erste Spalte, nur die Kennung  ^ fett
#   Ueberschrift       ## E-7 - ... (31.08.2026 - BEHOBEN ...)
#
# Ueberschriften sind Zeitdokumente: "## E-5 ... (31.08.2026, OFFEN)" sagt, was
# an jenem Tag galt, und darf dem heutigen Verzeichnis widersprechen. Verglichen
# wird deshalb NUR innerhalb des Verzeichnisses.

my @statuswort = qw(behoben erledigt offen teilweise ueberholt);

# Findet den Status in einer Verzeichniszeile: der erste FETTE Abschnitt, der
# mit einem Statuswort beginnt. "**24-Bit**" oder "**137**" sind keine.
sub status_aus_zeile {
    my ($zeile) = @_;
    while ($zeile =~ /\*\*([^*]{1,80})\*\*/g) {
        my $t = $1;
        return 'offen' if $t =~ /^\s*nicht\s+behoben/i;
        for my $w (@statuswort) {
            next unless $t =~ /^\s*\Q$w\E/i;
            return 'behoben' if $w eq 'behoben' or $w eq 'erledigt';
            return 'offen'   if $w eq 'offen';
            return $w;
        }
    }
    return undef;
}

my $befunde = lies('BEFUNDE.md');
my (%verzeichnis, %ueberschrift);
if (defined $befunde) {
    my @zeilen = split /\n/, $befunde;
    for my $i (0 .. $#zeilen) {
        my $z = $zeilen[$i];
        # Verzeichniszeile: die Kennung steht ALLEIN in der ersten Spalte
        if ($z =~ /^\|\s*\*{0,2}(E-\d+)\*{0,2}\s*\|/) {
            my $kennung = $1;
            push @{ $verzeichnis{$kennung} },
                 { zeile => $i + 1, status => status_aus_zeile($z) };
        }
        # Ueberschrift zweiter Ebene, Kennung als Gegenstand des Abschnitts
        # Gelesen wird mit :raw, also byteweise - ein Gedankenstrich "\x{2014}"
        # im Muster wuerde die drei Bytes E2 80 94 NIE treffen. Am 07.09.2026
        # genau so schiefgegangen: die Pruefung 4a lief ins Leere und meldete
        # eine doppelte Ueberschrift auch dann nicht, wenn es eine gab.
        if ($z =~ /^##\s+\*{0,2}(E-\d+)\*{0,2}\s/) {
            push @{ $ueberschrift{$1} }, $i + 1;
        }
    }
}

# 4a. Eine Kennung, zwei Abschnitte - das ist eine doppelt vergebene Nummer.
for my $k (sort keys %ueberschrift) {
    next unless @{ $ueberschrift{$k} } > 1;
    push @mangel, sprintf("%s hat in BEFUNDE.md zwei Abschnitte (Zeilen %s) - eine Kennung, eine Bedeutung",
                          $k, join(', ', @{ $ueberschrift{$k} }));
}

# 4b. Zwei Verzeichniszeilen zur selben Kennung mit widersprechendem Status.
for my $k (sort keys %verzeichnis) {
    my @mit = grep { defined $_->{status} } @{ $verzeichnis{$k} };
    next unless @mit > 1;
    my %verschieden = map { $_->{status} => $_->{zeile} } @mit;
    next unless keys %verschieden > 1;
    push @mangel, sprintf("%s steht im Verzeichnis von BEFUNDE.md mit verschiedenem Status: %s",
                          $k,
                          join('; ', map { "$_ (Zeile $verschieden{$_})" } sort keys %verschieden));
}

# 4c. Was im CHANGELOG unter "Noch offen" steht, darf im Verzeichnis nicht als
#     behoben stehen - und muss dort ueberhaupt stehen.
my $changelog = lies('CHANGELOG.md');
if (defined $changelog && defined $befunde) {
    my @zeilen = split /\n/, $changelog;
    my $im_abschnitt = 0;
    for my $i (0 .. $#zeilen) {
        my $z = $zeilen[$i];
        if ($z =~ /^##\s/) { $im_abschnitt = ($z =~ /Noch\s+offen/i) ? 1 : 0; next }
        next unless $im_abschnitt;
        next unless $z =~ /^\|\s*\*{0,2}(E-\d+)\*{0,2}\s*\|/;
        my $k = $1;
        if (!exists $verzeichnis{$k}) {
            push @mangel, sprintf("%s steht in CHANGELOG.md:%d unter 'Noch offen', fehlt aber im Verzeichnis von BEFUNDE.md",
                                  $k, $i + 1);
            next;
        }
        my @behoben = grep { defined $_->{status} && $_->{status} eq 'behoben' }
                      @{ $verzeichnis{$k} };
        next unless @behoben;
        push @mangel, sprintf("%s steht in CHANGELOG.md:%d unter 'Noch offen', im Verzeichnis von BEFUNDE.md aber als behoben (Zeile %d)",
                              $k, $i + 1, $behoben[0]->{zeile});
    }
}

# --- 5. Verweise, die ins Leere zeigen ---------------------------------------
# Ein Verweis in einer MD-Datei ist RELATIV ZU IHREM Verzeichnis zu lesen, nicht
# zur Repo-Wurzel. Bis zum 07.09.2026 loeste das Werkzeug gegen die Wurzel auf
# und meldete deshalb Eudora71/OTShim/INVENTAR.md -> 'PLAN.md' als fehlend,
# obwohl die Datei direkt daneben liegt. Zwei Fehlalarme in einem Lauf - und
# eine Schranke, die zweimal umsonst warnt, wird beim dritten Mal nicht mehr
# geglaubt.
for my $datei (@aktuell) {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    (my $verzeichnis = $datei) =~ s{/[^/]+\z}{};
    $verzeichnis = '.' if $verzeichnis eq $datei;
    my @zeilen = split /\n/, $inhalt;
    for my $i (0 .. $#zeilen) {
        while ($zeilen[$i] =~ /\[[^\]]*\]\(([^)#]+?)\)/g) {
            my $ziel_pfad = $1;
            next if $ziel_pfad =~ m{^[a-z]+://};       # Netzadresse
            next if $ziel_pfad =~ /^mailto:/;
            $ziel_pfad =~ s/\s+\z//;
            next if $ziel_pfad =~ /^#/;               # Sprungmarke in derselben Datei
            next if -e $ziel_pfad;                    # von der Wurzel aus
            next if -e "$verzeichnis/$ziel_pfad";     # neben der Datei
            push @mangel, sprintf("%s:%d verweist auf '%s' - gibt es nicht",
                                  $datei, $i + 1, $ziel_pfad);
        }
    }
}

# --- 5b. Genannte Auslieferungspakete, die es nicht mehr gibt -----------------
# Am 07.09.2026 verwies README.md auf Releases/Eudora72-1.0.18-release.zip; das
# ZIP war beim Aufraeumen entfernt worden (104 MB auf 16 MB). Ein entferntes ZIP
# darf genannt werden - aber nur, wenn Releases/PAKETE.md es mit Pruefsumme und
# Netzadresse fuehrt. Gregor: "wenn ein verweis auf ziel.md drin enthalten ist,
# dann sollten die zahlen zueinander passen."
my $pakete_md = lies('Releases/PAKETE.md') || '';
for my $datei (@aktuell) {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    my @zeilen = split /\n/, $inhalt;
    for my $i (0 .. $#zeilen) {
        while ($zeilen[$i] =~ /(Eudora72-[0-9.]+-[a-z]+\.zip)/g) {
            my $zip = $1;
            next if -e "Releases/$zip";
            next if index($pakete_md, $zip) >= 0;
            push @mangel, sprintf("%s:%d nennt '%s' - liegt nicht in Releases/ und steht auch nicht in Releases/PAKETE.md",
                                  $datei, $i + 1, $zip);
        }
    }
}

# --- 5c. Eine alte Paketnummer als HEUTIGER Stand ----------------------------
# Genau der Fehler, den Gregor am 07.09.2026 selbst fand: README.md nannte
# Paketnummer 1.0.18, waehrend VERSION 1.0.21 sagte. Geprueft wird nur, wo eine
# Nummer als der gueltige Stand behauptet wird - eine Nummer in einem datierten
# Rueckblick ist richtig und wird nicht gemeldet.
#
# ACHTUNG, das war der erste Anlauf und er blieb stumm: die Pruefung lief
# ZEILENWEISE, der Satz in README.md geht aber ueber zwei Zeilen ("Die
# Paketnummer steht in der Datei VERSION und lautet / **1.0.21**;"). Deshalb
# wird jetzt ueber den ganzen Text gesucht und ein Fenster von 200 Zeichen
# hinter dem Stichwort abgesucht; die Zeilennummer wird aus dem Zeichenversatz
# zurueckgerechnet.
my ($paket_haupt) = $paket =~ /^([0-9]+\.[0-9]+)\./;
$paket_haupt = '' unless defined $paket_haupt;
if (length $paket_haupt) {
    for my $datei (@aktuell) {
        my $inhalt = lies($datei);
        next unless defined $inhalt;
        while ($inhalt =~ /(Paketnummer|Paket:|Paketnummer lautet|aktuelle[sr]? Paket|Zuletzt ver(?:ö|oe)ffentlicht)/g) {
            my $ab = pos($inhalt);
            my $fenster = substr($inhalt, $ab, 200);
            # nur bis zum Ende des Absatzes schauen
            $fenster =~ s/\r?\n\r?\n.*\z//s;
            # ... und in einer Tabelle nur bis zum Ende der ZEILE. Jede
            # Tabellenzeile ist eine eigene Aussage; eine Tabelle hat aber
            # keine Leerzeilen, deshalb lief das Fenster bisher in die
            # naechste Zeile hinein. Gemeldet wurde am 09.09.2026
            # WEITERMACHEN.md:10 ("Paket 1.0.25") wegen der Zahl 1.0.24 in
            # Zeile 12 - und die steht dort zu Recht, als datierte
            # Rueckschau "Zuletzt von Gregor bestaetigt".
            $fenster =~ s/\r?\n\|.*\z//s;
            while ($fenster =~ /\b([0-9]+\.[0-9]+\.[0-9]+)\b/g) {
                my $nr = $1;
                next unless $nr =~ /^\Q$paket_haupt\E\./;
                next if $nr eq $paket;

                # L-9-Klasse, 08.09.2026: die Pruefung war kontextblind. In
                # einem Abschnitt UEBER Paket 1.0.22 ist die Zeile
                # "Paket: Releases/Eudora72-1.0.22-release.zip" richtig und
                # muss dort auch stehen bleiben - der CHANGELOG ist nach
                # Fassungen gegliedert. Gemeldet wurden CHANGELOG.md:205 und
                # :339, beide innerhalb von "## 7.2.0.22 / Paket 1.0.22" bzw.
                # "### Was an 1.0.22 zu pruefen ist".
                #
                # Deshalb: die naechste Ueberschrift OBERHALB der Fundstelle
                # heranziehen. Nennt sie dieselbe Nummer, ist die Aussage auf
                # ihren Abschnitt bezogen und keine Behauptung ueber heute.
                my $davor = substr($inhalt, 0, $ab);
                my @alle_u = ($davor =~ /^\#{1,6} [^\n]*$/mg);
                my $ueberschrift = @alle_u ? $alle_u[-1] : '';
                if (length $ueberschrift) {
                    my ($klein) = $nr =~ /\.([0-9]+)$/;
                    next if index($ueberschrift, $nr) >= 0;
                    next if defined $klein
                        and $ueberschrift =~ /\b7\.2\.0\.\Q$klein\E\b/;
                }

                my $zeile = 1 + (() = $davor =~ /\n/g);
                push @mangel, sprintf("%s:%d nennt Paketnummer %s als Stand, VERSION sagt %s",
                                      $datei, $zeile, $nr, $paket);
            }
        }
    }
}
# --- 6. Fassungsstand --------------------------------------------------------
# Eine Datei ist aktuell, wenn sie den Quellstand ODER die Paketnummer nennt.
# Sie darf daneben aeltere Fassungen erwaehnen - "die sieben Vermutungen stehen
# unter 7.2.0.17" ist eine Fundstelle, kein veralteter Stand. Der erste Anlauf
# hat genau das gemeldet und AUFGABEN.md damit zu Unrecht angeschwaerzt.
#
# Ausgenommen ist ausserdem, wer sich im Kopf SELBST datiert: eine Datei, die in
# den ersten zwoelf Zeilen "Stand: <Datum>", "gemessen an <commit>" oder
# "Geprueft ... am <Datum>" sagt, ist ein Zeitdokument und darf alt sein. Am
# 07.09.2026 meldete das Werkzeug drei solche Dateien (VC71Bruecke/BEFUND.md,
# PRUEFBERICHT.md, STARTUMGEBUNG.md) - alle drei nennen ihr Datum in Zeile 3.
# Das Merkmal ist besser als eine Ausnahmeliste von Hand: eine Liste vergisst
# die naechste Datei, das Merkmal nicht.
for my $datei (@aktuell) {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    my @kopf = (split /\n/, $inhalt)[0 .. 11];
    my $kopf = join "\n", grep { defined } @kopf;
    next if $kopf =~ /Stand:?\s*\d{2}\.\d{2}\.20\d\d/i;
    next if $kopf =~ /gemessen an [`']?[0-9a-f]{7}/i;
    next if $kopf =~ /Geprueft|Gepr(ü|ue)ft.*\bam\b/i;
    next if $kopf =~ /Vorarbeit vom \d{2}\.\d{2}\.20\d\d/i;
    next unless $inhalt =~ /\b7\.2\.0\.\d+\b/ or $inhalt =~ /\b1\.0\.\d+\b/;
    next if index($inhalt, $quellstand) >= 0;
    next if index($inhalt, $paket)      >= 0;
    my @gefunden = ($inhalt =~ /\b7\.2\.0\.(\d+)\b/g);
    my ($hoechste) = sort { $b <=> $a } @gefunden;
    push @hinweis, sprintf("%s nennt weder den Quellstand %s noch die Paketnummer %s%s",
                           $datei, $quellstand, $paket,
                           defined $hoechste ? " (hoechste genannte Fassung: 7.2.0.$hoechste)" : "");
}

# --- 7. Version.h gegen sich selbst und gegen VERSION ------------------------
# Am 07.09.2026 gefunden (Befund L-7): EUDORA_BUILD_NUMBER stand auf 7,2,0,12,
# waehrend die drei anderen Angaben auf 18 standen - seit 7.2.0.13 nicht
# mitgezogen. Weder "ausliefern.pl --pruefen" noch "kennung-erzeugen.pl" haben
# es gemeldet; die vergleichen nur EUDORA_BUILD_VERSION gegen VERSION.
#
# Das ist KEIN Doku-Mangel, sondern eine Aufgabe am Quellstand. Es steht deshalb
# unter "Zu tun" und laesst die Rueckgabe auf 0 - sonst blockiert diese Schranke
# jeden Commit an einer Sache, die sie nicht verantwortet.
{
    my @teil;
    for my $n (1 .. 4) {
        my ($v) = $version_h =~ /EUDORA_VERSION$n\s+(\d+)/;
        push @teil, defined $v ? $v : '?';
    }
    my $aus_teilen = join('.', @teil);
    my ($nummer) = $version_h =~ /EUDORA_BUILD_NUMBER\s+([0-9]+(?:\s*,\s*[0-9]+){3})/;
    my $aus_nummer;
    if (defined $nummer) { $aus_nummer = $nummer; $aus_nummer =~ s/\s//g; $aus_nummer =~ s/,/./g }
    my ($desc) = $version_h =~ /EUDORA_BUILD_DESC\s+"Version\s+([0-9.]+)/;

    my %quelle = (
        'EUDORA_VERSION1..4'  => $aus_teilen,
        'EUDORA_BUILD_NUMBER' => $aus_nummer,
        'EUDORA_BUILD_DESC'   => $desc,
    );
    for my $name (sort keys %quelle) {
        my $wert = $quelle{$name};
        next unless defined $wert;
        next if $wert eq $quellstand;
        push @zutun, sprintf("Eudora71/Version.h: %s sagt %s, EUDORA_BUILD_VERSION sagt %s",
                             $name, $wert, $quellstand);
    }
    my ($paket_letzte)      = $paket      =~ /\.(\d+)\z/;
    my ($quellstand_letzte) = $quellstand =~ /\.(\d+)\z/;
    if (defined $paket_letzte && defined $quellstand_letzte
        && $paket_letzte ne $quellstand_letzte) {
        push @zutun, sprintf("VERSION sagt %s, Quellstand ist %s - die letzte Stelle soll gleich sein (Releases/PAKETE.md)",
                             $paket, $quellstand);
    }
}

# --- 8. Marken: keine Veroeffentlichung ankuendigen, die es nicht gibt -------
# Befund W-0 (L-8, 07.09.2026): README.md, WEITERMACHEN.md und PAKETE.md nannten
# v1.0.21 mit Adresse, waehrend die Marke noch nicht gesetzt war. Sie wurde es
# eine halbe Stunde spaeter - der Text war also nicht falsch gemeint, aber eine
# Weile lang schlicht unwahr. Zuerst gegen origin fragen; ohne Netz gegen die
# oertlichen Marken.
my %marke_da;
{
    my $fern = qx{git ls-remote --tags origin 2>$nirgendwo} || '';
    $marke_da{$1} = 1 while $fern =~ m{refs/tags/(v[0-9][0-9.]*?)(?:\^\{\})?$}gm;
    unless (keys %marke_da) {
        my $ort = qx{git tag 2>$nirgendwo} || '';
        $marke_da{$1} = 1 while $ort =~ /^(v[0-9][0-9.]*)$/gm;
    }
}
if (keys %marke_da) {
    for my $datei (@alle_md) {
        my $inhalt = lies($datei);
        next unless defined $inhalt;
        my @zeilen = split /\n/, $inhalt;
        for my $i (0 .. $#zeilen) {
            while ($zeilen[$i] =~ m{releases/tag/(v[0-9][0-9.]*)}g) {
                my $m = $1;
                next if $marke_da{$m};
                push @mangel, sprintf("%s:%d nennt die Veroeffentlichung %s - diese Marke gibt es nicht",
                                      $datei, $i + 1, $m);
            }
        }
    }
}

# --- 9. Eine alte Fassungsnummer als HEUTIGER Stand, auch in Zeitdokumenten --
# Befund W-3 und W-17 (L-8): CHANGELOG.md sagte "Version.h und VERSION stehen
# weiter auf 7.2.0.18 / 1.0.18", PRUEFUNG-BAU.md "der Quellstand ist seit dem
# 06.09.2026 7.2.0.12". Beide Dateien waren von der Zeitdokument-Ausnahme
# gedeckt - deshalb hier ALLE Dateien.
#
# Der erste Anlauf warf sieben Fehlalarme: zitierte Behauptungen, die
# Geschichte von EUDORA_BUILD_NUMBER und datierte Messungen. Eine Schranke, die
# zweimal umsonst warnt, wird beim dritten Mal nicht mehr geglaubt - deshalb
# ist die Prueffrage eng gestellt, und die Ausschluesse gelten fuer das GANZE
# Fenster: der zweite Anlauf prueft nur die erste Zeile und meldete eine
# Ueberschrift, deren FOLGEzeile mit "**Behauptung** (README)" beginnt.
my %stand_gemeldet;   # ein Satz wird nur einmal gemeldet, auch wenn das
                      # Fenster zweier Zeilen ihn zweimal sieht
my $behauptet_stand = qr{(?:Quellstand\s+ist|steht\s+auf|stehen\s+(?:weiter\s+)?auf|ist\s+seit)};
for my $datei (@alle_md) {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    my @zeilen = split /\n/, $inhalt;
    for my $i (0 .. $#zeilen) {
        my $z = $zeilen[$i];
        next if $z =~ /^\s*[>|#]/;
        # L-9-Klasse, 08.09.2026: das Zwei-Zeilen-Fenster nahm die FOLGEzeile
        # auch dann mit, wenn sie ein Blockzitat war. Damit meldete die
        # Schranke Befunde/LEKTOR-5.md:318 - dort steht eine LEERZEILE, und
        # die Zeile danach ist das Zitat, mit dem der Lektor den Mangel in
        # Releases/PAKETE.md gerade BELEGT. Ein Zitat ist keine Behauptung;
        # geprueft wird nur, was die Datei selbst sagt.
        my $fenster = join(' ', grep { defined && !/^\s*[>|#]/ } @zeilen[$i .. $i + 1]);
        next if $fenster =~ /EUDORA_BUILD_NUMBER/;
        next if $fenster =~ /\d{2}\.\d{2}\.20\d\d/;
        next if $fenster =~ /Behauptung|behauptet|\bwar\b|damals|frueher|ueberholt/i;
        next unless $fenster =~ /$behauptet_stand/;
        next unless $fenster =~ /\bVERSION\b|Version\.h|Quellstand|Paketnummer/;
        my %schon;
        # L-9-Klasse, 08.09.2026, zweiter Teil: eine Versionsnummer INNERHALB
        # deutscher Anfuehrungszeichen ist ein Zitat und keine Behauptung der
        # Datei. Gemeldet hatte die Schranke Befunde/LEKTOR-5.md:651 - dort
        # zitiert der Lektor den Kopfkasten von Releases/PAKETE.md, um dessen
        # Mangel zu belegen. Gearbeitet wird auf Rohbytes, weil die MDs UTF-8
        # sind und die Zeichen sonst nicht zuverlaessig treffen:
        #   E2 80 9E = "  (oeffnend)      E2 80 9C = "  (schliessend)
        my $zitiert = '';
        {
            my $rest = $fenster;
            while ($rest =~ /\xe2\x80\x9e(.*?)(?:\xe2\x80\x9c|$)/gs) {
                $zitiert .= $1 . ' ';
            }
        }
        while ($fenster =~ /\b(7\.2\.0\.\d+)\b/g) {
            next if $1 eq $quellstand or $schon{$1}++;
            next if index($zitiert, $1) >= 0;
            next if $stand_gemeldet{"$datei|$1"}++;
            push @mangel, sprintf("%s:%d behauptet %s als gueltigen Quellstand, Version.h sagt %s",
                                  $datei, $i + 1, $1, $quellstand);
        }
    }
}

# --- 10. Befundkennungen quer, in beide Richtungen ---------------------------
# Befund W-8, W-10, W-11, W-24 (L-8), und von PRUEFER schon am 07.09.2026
# gefordert (Befunde/PRUEFER-3.md:266). Zwei Richtungen:
#   a) eine Kennung mit eigenem Abschnitt im CHANGELOG muss im Verzeichnis von
#      BEFUNDE.md vorkommen. E-34, E-35 und E-36 fehlten dort vollstaendig -
#      und ZIEL.md belegte Kriterium 4 mit genau diesen drei.
#   b) eine Kennung, die irgendwo als "behoben" steht, darf im Verzeichnis
#      nicht "offen" heissen (E-16, E-22).
my $changelog_inhalt = lies('CHANGELOG.md') || '';
my %im_changelog;
$im_changelog{$1} = 1 while $changelog_inhalt =~ /^###\s+(E-\d+)\b/gm;
for my $k (sort keys %im_changelog) {
    next if exists $verzeichnis{$k};
    push @mangel, sprintf("%s hat einen eigenen Abschnitt in CHANGELOG.md, fehlt aber im Verzeichnis von BEFUNDE.md", $k);
}

# --- 11. Anforderung A-1 gegen das Gebaute -----------------------------------
# Gregor am 07.09.2026: "wo ist das requirement aufgeschrieben, welche default
# werte bei neuem konto gesetzt werden sollen?" - Antwort damals: nirgends. Die
# vier Werte standen nur in tools/DEudora.ini selbst, in README.md als
# Beschreibung und in tools/paket-pruefen.ps1 als Pruefung. Damit behauptete das
# Werkzeug etwas ueber sich selbst, und niemand konnte pruefen, ob es dem
# entspricht, was gefordert war.
#
# Jetzt steht die Anforderung als A-1 in ZIEL.md, und diese Pruefung haelt die
# Werkzeugdatei dagegen. Die Tabelle in ZIEL.md ist die QUELLE, tools/DEudora.ini
# die Umsetzung - laufen sie auseinander, ist es ein Mangel, ganz gleich welche
# Seite falsch ist.
my $ziel_inhalt = lies('ZIEL.md') || '';
my $deudora     = lies('tools/DEudora.ini');
if ($ziel_inhalt =~ /###\s+A-1\b/) {
    my ($abschnitt) = $ziel_inhalt =~ /###\s+A-1\b(.*?)(?=\n###\s|\n##\s|\z)/s;
    $abschnitt = '' unless defined $abschnitt;
    my %gefordert;
    # Tabellenzeilen der Form  | `Schluessel` | `Wert` | ... |
    while ($abschnitt =~ /^\|\s*`([A-Za-z][A-Za-z0-9_]*)`\s*\|\s*`(\d+)`\s*\|/gm) {
        $gefordert{$1} = $2;
    }
    if (!keys %gefordert) {
        push @mangel, "ZIEL.md: Abschnitt A-1 hat keine lesbare Wertetabelle - die Anforderung ist nicht pruefbar";
    }
    elsif (!defined $deudora) {
        push @mangel, "ZIEL.md fordert in A-1 " . scalar(keys %gefordert) . " Vorgaben, tools/DEudora.ini fehlt";
    }
    else {
        for my $k (sort keys %gefordert) {
            my $soll = $gefordert{$k};
            if ($deudora =~ /^\s*\Q$k\E\s*=\s*(\S+)\s*$/m) {
                my $ist = $1;
                push @mangel, sprintf("tools/DEudora.ini setzt %s=%s, ZIEL.md fordert in A-1 %s",
                                      $k, $ist, $soll) if $ist ne $soll;
            }
            else {
                push @mangel, sprintf("tools/DEudora.ini setzt %s nicht, ZIEL.md fordert in A-1 %s=%s",
                                      $k, $k, $soll);
            }
        }
        # Die Zuordnungen von QUALCOMM muessen drin bleiben - eine Fassung mit nur
        # [Settings] haette sie beim Auspacken ueber eine Installation geloescht.
        my $original = lies('InstallersForEudora/Eudora7.1/Data/INIfiles/deudora.ini');
        if (defined $original) {
            my $n_orig = () = $original =~ /^(?:both|in|out)=/gm;
            my $n_neu  = () = $deudora  =~ /^(?:both|in|out)=/gm;
            push @mangel, sprintf("tools/DEudora.ini hat %d Dateizuordnungen, die Originaldatei von QUALCOMM %d - eine Fassung mit nur [Settings] loescht sie beim Auspacken",
                                  $n_neu, $n_orig) if $n_neu < $n_orig;
        }
    }
}

# --- Bilanz ------------------------------------------------------------------
unless ($leise) {
    print "\n";
    print "  Dokumentation pruefen\n";
    print "  ", "-" x 60, "\n";
    printf("  %-28s %s\n", "Quellstand",   $quellstand);
    printf("  %-28s %s\n", "Paketnummer",  $paket);
    printf("  %-28s %d\n", "Kriterien in ZIEL.md", $anzahl_kriterien);
    printf("  %-28s %d\n", "gepruefte Dateien", scalar @aktuell);
    printf("  %-28s %d\n", "Kennungen im Verzeichnis", scalar keys %verzeichnis);
    printf("  %-28s %d\n", "Abschnitte in BEFUNDE.md", scalar keys %ueberschrift);
    print "  ", "-" x 60, "\n";
    if (@mangel) {
        print "\n  MANGEL:\n\n";
        print "    - $_\n" for @mangel;
    } else {
        print "\n  Kein Widerspruch gefunden.\n";
    }
    if (@zutun) {
        print "\n  ZU TUN am Quellstand (kein Doku-Mangel, blockiert nichts):\n\n";
        print "    - $_\n" for @zutun;
    }
    if (@hinweis) {
        print "\n  Zur Kenntnis:\n\n";
        print "    - $_\n" for @hinweis;
    }
    print "\n";
}

exit(@mangel ? 1 : 0);
