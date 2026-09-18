#!/usr/bin/perl
use strict;
use warnings;

# pruefe-release-buchfuehrung.pl - stimmt das, was die Dokumente ueber das
# neueste Release sagen, mit dem ueberein, was wirklich veroeffentlicht ist?
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE SCHRANKE GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 18.09.2026:
#
#     "dein commit gestern fuer 0.72 war unvollstaendig. nachdem ich gemerged
#     habe, wolltest du noch daten nachschieben. [...] es scheinen einige MDs
#     veraltet zu sein, was falsch ist: keine luegen auf dem main. [...]
#     repariere deine schranken, so dass VOR dem commit und merge alles auf
#     github vorhanden ist."
#
# Der Anlassfall, nachgemessen am Stand 8da72c8 (dem Merge, den Gregor
# ausgefuehrt hat):
#
#   * `git tag` nannte **v1.0.72** als neuestes Tag - das Release war drauSSen.
#   * README.md, AUFGABEN.md, WEITERMACHEN.md, Releases/PAKETE.md und
#     tools/RELEASES.md nannten alle fuenf weiterhin **v1.0.64** als das
#     neueste Release.
#
# Der Commit, der das haette berichtigen sollen, kam ERST NACH dem Merge, auf
# einem Zweig, den Gregor nicht vereinbart hatte. Damit stand die veraltete
# Fassung auf main.
#
# WARUM KEINE DER VORHANDENEN SCHRANKEN DAS FING:
#
#   * doku-pruefen.pl haelt die Dokumente GEGENEINANDER. Als alle fuenf
#     einhellig "v1.0.64" sagten, war das widerspruchsfrei - und falsch.
#     Einigkeit ist kein Wahrheitsbeweis.
#   * release-pruefen.pl vergleicht die QCSSL-DLL mit ihrer Quelle. Es sagt
#     nichts ueber Releases des Programms - und hing im pre-commit mit
#     "|| true", konnte also ohnehin nie abweisen.
#   * pruefe-befund-verbreitung.pl fragt, ob ein Befund ERWAEHNT wird, nicht,
#     ob die Aussage darueber stimmt.
#
# Es fehlte die eine Frage, die von auSSen kommt: WAS IST WIRKLICH
# VEROEFFENTLICHT? Die Antwort steht nicht in den Dokumenten, sondern im
# Tag-Bestand. Deshalb holt sich diese Schranke ihren MaSSstab von dort
# (Arbeitsweise/pruefumfang-nicht-von-hand.md) und misst die Dokumente daran,
# statt sie miteinander zu vergleichen.
#
# ---------------------------------------------------------------------------
# WAS SIE PRUEFT
# ---------------------------------------------------------------------------
#
# MaSSstab: das hoechste Tag der Form vN.N.NN. Seine letzte Zahl ist die
# Paketnummer - Tag v1.0.72 und Fassung 7.2.0.72 tragen dieselbe.
#
#   A. Jedes der fuehrenden Dokumente MUSS die Paketnummer des neuesten Tags
#      irgendwo nennen. Das ist ein GROBFILTER, kein Beweis fuer Aktualitaet -
#      siehe die Warnung bei Pruefung A weiter unten.
#
#   B. Kein ABSATZ, der eine Aussage ueber den aktuellen Stand macht, darf
#      ohne die neueste Nummer auskommen.
#
# ---------------------------------------------------------------------------
# WAS AM 18.09.2026 DARAN BERICHTIGT WURDE (PRUEFER-17)
# ---------------------------------------------------------------------------
#
# Die erste Fassung vom 18.09.2026 hatte "--tests" mit 10 von 10 gruen und war
# trotzdem an drei Stellen falsch. Gefunden hat das erst der Lauf gegen die
# ECHTEN Dateien - nicht der Selbsttest mit den erfundenen.
#
#   1. SIE PRUEFTE ZEILENWEISE. In Releases/PAKETE.md steht bis heute:
#
#          Zeile 322:  ## 1.0.29 - veroeffentlicht am 09.09.2026
#          Zeile 323:  **Die aktuelle Fassung, und die einzige, die als Paket
#                        im Repo liegt.**
#
#      Das ist eine Standaussage ueber 1.0.29, waehrend v1.0.72 drauSSen ist -
#      also genau die Luege, gegen die es diese Schranke gibt. Die Nummer steht
#      in der Ueberschrift, die Aussage in der Zeile darunter; zeilenweise
#      sieht man beide nie zusammen, und die Schranke meldete zu PAKETE.md
#      NULL Maengel. Arbeitsweise/schranke-gegentesten.md sagt das seit dem
#      07.09.2026: "Zeilenweise ist eine Annahme. Ein Satz in einer MD-Datei
#      umbricht."
#
#      Berichtigt: geprueft wird der ABSATZ (siehe sub bloecke). Ein Absatz
#      ohne eigene Nummer erbt die Nummer seiner naechsten Ueberschrift.
#
#   2. SIE WARF BEI JEDER AUFZAEHLUNG FEHLALARM. Gegen den Arbeitsbaum vom
#      18.09.2026 meldete sie 7 Maengel, und ALLE SIEBEN waren falsch. Sechs
#      davon aus einer einzigen Zeile - WEITERMACHEN.md:27:
#
#          | **Zuletzt gebaut und veroeffentlicht** | Quellstand **7.2.0.72** /
#          `VERSION` **1.0.72**, ... **Sie enthaelt** [1.0.65, .67, .68, .69,
#          .70, .71] ...
#
#      Die Zeile nennt die RICHTIGE Nummer und zaehlt danach auf, was seit
#      1.0.65 darin steckt. Das ist die normale Schreibweise dieses Projekts,
#      kein Sonderfall.
#
#      Berichtigt: nennt ein Absatz die aktuelle Nummer, ist er auf Stand -
#      die uebrigen Nummern darin sind eine Aufzaehlung, keine Behauptung.
#      Beanstandet wird nur ein Absatz, der die aktuelle Nummer NICHT nennt.
#
#      Gegenprobe, dass das nichts verdeckt: am Stand 8da72c8 nennt KEINER der
#      beanstandeten Absaetze die 72 (nachgemessen, siehe --tests Fall 3).
#
#   3. DIE RUECKBLICK-LISTE WAR ZU WEIT. Ausgeschlossen wurde jede Zeile mit
#      "Vorgaenger|damals|bis dahin|stand hier|zuvor|ehemals" - irgendwo in der
#      Zeile. Eine Luege, in der zufaellig "zuvor" vorkommt, kam damit durch,
#      und das Wort ist haeufig: tools/RELEASES.md benutzt es in der Zeile zu
#      v1.0.50. Derselbe Mechanismus wie im Nachtrag vom 17.09.2026 zu
#      Arbeitsweise/schranke-gegentesten.md - ein Wort im Umfeld entscheidet,
#      nicht die Aussage.
#
#      Berichtigt: die Wortliste ist weg. Was bleibt, sind zwei Ausnahmen, die
#      sich an der FORM festmachen und einzeln gegengetestet sind:
#        - Zitatbloecke (">") - dort steht der berichtigte Wortlaut des LEKTOR;
#        - Protokollzeilen einer Tabelle, deren erste Spalte ein Datum ist
#          (tools/RELEASES.md fuehrt so Buch). Eine Protokollzeile haelt fest,
#          was DAMALS galt; sie wird nie wieder wahr oder falsch.
#
#   4. UMFANG 0 IST KEIN FREISPRUCH. Sieht die Schranke keine einzige
#      Standaussage, meldet sie das und gibt 1 zurueck - nicht 0. E-109
#      Punkt (4): der zweite Zustand darf nicht wie der erste aussehen.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-release-buchfuehrung.pl            prueft
#   perl tools/pruefe-release-buchfuehrung.pl --tests    Selbsttest
#
# Rueckgabe: 0 = stimmt, 1 = ein Dokument luegt oder schweigt, 2 = Aufrufproblem.

my $wurzel = -f 'VERSION' ? '.' : '..';

# Die Dokumente, die den Stand nach auSSen vertreten. Bewusst diese fuenf:
# genau sie nannten am 17.09.2026 alle v1.0.64.
my @PFLICHT = qw(
    README.md
    AUFGABEN.md
    WEITERMACHEN.md
    Releases/PAKETE.md
    tools/RELEASES.md
);

# ---------------------------------------------------------------------------
sub lies {
    my ($pfad) = @_;
    open my $h, '<:raw', $pfad or return undef;
    my $t = do { local $/; <$h> };
    close $h;
    return $t;
}

# Die Paketnummer des neuesten Tags. v1.0.72 -> 72.
#
# Sortiert wird numerisch nach allen drei Teilen, nicht als Text: als Text
# steht "v1.0.9" hinter "v1.0.72".
sub neueste_paketnummer {
    my (@tags) = @_;
    my @n;
    for my $t (@tags) {
        next unless $t =~ /^v(\d+)\.(\d+)\.(\d+)$/;
        push @n, [ $1, $2, $3, $t ];
    }
    return (undef, undef) unless @n;
    my ($hoechstes) = sort { $b->[0] <=> $a->[0]
                          || $b->[1] <=> $a->[1]
                          || $b->[2] <=> $a->[2] } @n;
    return ($hoechstes->[2], $hoechstes->[3]);
}

# Alle Paketnummern, die ein Stueck Text nennt.
#
# Erkannt werden NUR die beiden Schreibweisen, die das Projekt fuer Fassungen
# benutzt: "v1.0.72" (Tag) und "7.2.0.72" (Programmfassung), dazu "1.0.72" in
# Verzeichnis- und Paketnamen. Datumsangaben wie 17.09.2026 sehen einer
# Fassungsnummer zum Verwechseln aehnlich und werden dadurch nicht getroffen -
# ein erster Entwurf mit einem allgemeinen \d+\.\d+\.\d+ hielt jedes Datum fuer
# eine Fassung.
sub nummern_im_text {
    my ($text) = @_;
    my %n;
    $n{$1} = 1 while $text =~ /\bv?1\.0\.(\d+)\b/g;
    $n{$1} = 1 while $text =~ /\b7\.2\.0\.(\d+)\b/g;
    return sort { $a <=> $b } keys %n;
}

# Macht diese Zeile eine Aussage ueber den AKTUELLEN Stand?
#
# Nur vier Wendungen, und alle vier kommen aus dem echten Bestand. Eine
# laengere Liste faengt nicht mehr, sondern nur lauter
# (Arbeitsweise/schranke-gegentesten.md).
sub ist_standaussage {
    my ($zeile) = @_;
    return 1 if $zeile =~ /neueste[sn]?\s+(?:Release|Fassung|Paket)/i;
    return 1 if $zeile =~ /aktuelle[sn]?\s+(?:Release|Fassung|Paket)/i;
    return 1 if $zeile =~ /als\s+\*?Latest\*?/i;
    return 1 if $zeile =~ /Zuletzt\s+(?:gebaut|ver(?:oe|ö)ffentlicht)/i;
    return 0;
}

# Zerlegt eine MD-Datei in Absaetze.
#
# WARUM NICHT ZEILENWEISE: siehe Punkt 1 im Kopf. Ein Satz in einer MD-Datei
# umbricht; die Nummer steht dann in einer anderen Zeile als die Aussage.
#
# Die Einheiten, und warum genau diese:
#
#   Ueberschrift ("# ")   eigener Block UND Bezugspunkt fuer alles danach.
#                         Ein Absatz ohne eigene Nummer erbt ihre Nummern -
#                         das ist der Fall Releases/PAKETE.md:322-323.
#   Tabellenzeile ("|")   eigener Block. Eine Tabelle hat keine Leerzeilen
#                         zwischen den Zeilen; ohne diese Regel waere die
#                         ganze Tabelle EIN Absatz, und eine veraltete Zeile
#                         wuerde von der Nummer einer beliebigen anderen Zeile
#                         gedeckt. Gemessen an WEITERMACHEN.md, dessen
#                         Kopftabelle 20 Zeilen hat.
#   Zitat (">")           eigener Block, wird nicht geprueft.
#   Listenpunkt ("* ")    eigener Block; eingerueckte Folgezeilen gehoeren
#                         dazu. README.md fuehrt den Stand als Listenpunkt
#                         ueber vier Zeilen.
#   Fliesstext            Block bis zur naechsten Leerzeile.
#
# Rueckgabe: Liste von { zeile, art, text, ueberschrift }.
sub bloecke {
    my ($inhalt) = @_;
    my @zeilen = split /\n/, $inhalt, -1;
    my (@bl, $cur, $ueberschrift);
    $ueberschrift = '';

    my $flush = sub { push @bl, $cur if $cur; $cur = undef; };

    for my $i (0 .. $#zeilen) {
        my $z = $zeilen[$i];

        if ($z =~ /^\s*$/) { $flush->(); next; }

        my $art = 'text';
        $art = 'ueberschrift' if $z =~ /^\s{0,3}#{1,6}\s/;
        $art = 'tabelle'      if $z =~ /^\s{0,3}\|/;
        $art = 'zitat'        if $z =~ /^\s*>/;
        $art = 'liste'        if $z =~ /^\s*(?:[-*+]|\d+\.)\s/;

        # Jede dieser Arten beginnt einen neuen Block; nur 'text' setzt einen
        # laufenden fort.
        if ($art ne 'text' || !$cur) {
            $flush->();
            $cur = { zeile => $i + 1, art => $art, text => '',
                     ueberschrift => $ueberschrift };
        }
        $cur->{text} .= "$z\n";

        # Ueberschrift, Tabellenzeile und Zitat stehen fuer sich allein.
        if ($art eq 'ueberschrift') { $ueberschrift = $z; $flush->(); }
        elsif ($art eq 'tabelle' || $art eq 'zitat') { $flush->(); }
    }
    $flush->();
    return @bl;
}

# Eine Protokollzeile haelt fest, was DAMALS galt - sie wird nie wieder wahr
# oder falsch. tools/RELEASES.md fuehrt so Buch: die erste Spalte ist der
# Zeitstempel der Veroeffentlichung. Ohne diese Ausnahme meldet die Schranke
# jede jemals veroeffentlichte Fassung als Luege, weil in der Zeile
# "auf GitHub als *Latest* markiert" steht.
# Zerlegt einen Absatz in Saetze.
#
# WARUM DAS NOETIG IST - gemessen am 18.09.2026, und zwar erst vom Gegentest:
# Der Absatz war zuerst die Pruefeinheit. Damit kam der ANLASSFALL wieder
# durch. In README.md des Standes 8da72c8 ist der Stand ein Listenpunkt ueber
# 23 Zeilen:
#
#     * **Noch nicht im Download enthalten:** das neueste Release ist
#       **`v1.0.64`** ...            <- Zeile 72, die Luege
#     ... 21 Zeilen Aufzaehlung ...
#       (**E-107** war die falsche Erklaerung ...; **E-108** in 7.2.0.72
#                                    <- Zeile 94, ein QUERVERWEIS
#
# Die 72 steht also im selben Absatz - 22 Zeilen unter der Aussage und ohne
# jeden Bezug zu ihr. Die Regel "nennt der Absatz die aktuelle Nummer, ist er
# auf Stand" hat die Luege damit gedeckt. Der Absatz ist zu grob.
#
# Der Satz ist die richtige Einheit: er ist gross genug, um den Zeilenumbruch
# zu ueberstehen (das war Punkt 1 im Kopf), und klein genug, dass eine
# Aufzaehlung weiter hinten nicht mehr hineinreicht.
#
# Zeilenumbrueche werden vorher zu Leerzeichen - ein Satz in einer MD-Datei
# umbricht mitten im Wortlaut.
sub saetze {
    my ($text) = @_;
    $text =~ s/\s*\n\s*/ /g;
    # Getrennt wird nach Satzzeichen, wenn danach ein neuer Satz beginnt -
    # also Leerzeichen und dann ein GroSSbuchstabe oder ein Auszeichnungs-
    # zeichen. "17.09.2026" und "z. B." bleiben dadurch heil, weil auf den
    # Punkt kein Leerzeichen bzw. kein Satzanfang folgt.
    my @s = split /(?<=[.!?:;])\s+(?=[*_`\[(\-A-Z\xc0-\xde]|\xc3)/, $text;
    return grep { /\S/ } @s;
}

sub ist_protokollzeile {
    my ($block) = @_;
    return 0 unless $block->{art} eq 'tabelle';
    return $block->{text} =~ /^\s*\|\s*\d{4}-\d{2}-\d{2}/ ? 1 : 0;
}

# Der Kern, absichtlich ohne Dateizugriff - damit der Selbsttest ihn mit
# erfundenen Dateien fahren kann.
sub pruefe {
    my ($dateien, $nr) = @_;      # { Pfad => Inhalt }, Paketnummer
    my @mangel;
    my $geprueft = 0;             # Absaetze mit einer Standaussage

    for my $d (sort keys %$dateien) {
        my $inhalt = $dateien->{$d};
        unless (defined $inhalt) {
            push @mangel, "$d fehlt ganz";
            next;
        }

        # A. GROBFILTER: kommt die neueste Nummer in der Datei ueberhaupt vor?
        #
        # ACHTUNG, das ist schwaecher, als es klingt: am echten Stand 8da72c8
        # hat README.md diese Pruefung bestanden - ueber die Zeile
        # "| **Paketnummer**, z. B. `1.0.72` | die Datei `VERSION` |", also
        # ueber ein BEISPIEL in einer Begriffstabelle, waehrend die
        # Standaussage derselben Datei v1.0.64 nannte. A faengt nur den
        # Extremfall "kommt nirgends vor". Die Arbeit macht B.
        push @mangel, "$d nennt die Fassung $nr an keiner Stelle"
            unless grep { $_ == $nr } nummern_im_text($inhalt);

        # B. Macht ein Absatz eine Aussage ueber den aktuellen Stand, ohne die
        #    neueste Nummer zu nennen?
        for my $b (bloecke($inhalt)) {
            next if $b->{art} eq 'zitat';
            next if ist_protokollzeile($b);

            for my $satz (saetze($b->{text})) {
                next unless ist_standaussage($satz);

                $geprueft++;

                # 1. Was der Satz selbst nennt.
                my @n = nummern_im_text($satz);
                my $woher = '';

                # 2. Sonst: die Nummer der Ueberschrift, unter der er steht -
                #    der Fall Releases/PAKETE.md:322-323.
                unless (@n) {
                    @n = nummern_im_text($b->{ueberschrift});
                    $woher = ' (Nummer aus der Ueberschrift)' if @n;
                }

                # 3. Sonst: was sonst im Absatz steht.
                unless (@n) {
                    @n = nummern_im_text($b->{text});
                    $woher = ' (Nummer aus dem Absatz)' if @n;
                }

                next unless @n;                    # gar keine Nummer: nichts zu messen
                next if grep { $_ == $nr } @n;     # nennt die aktuelle: auf Stand

                push @mangel, sprintf
                    "%s:%d gibt %s als aktuellen Stand aus, veroeffentlicht ist 1.0.%d%s",
                    $d, $b->{zeile}, join(', ', map { "1.0.$_" } @n), $nr, $woher;
            }
        }
    }

    return (\@mangel, $geprueft);
}

# ---------------------------------------------------------------------------
# Selbsttest: gegen den echten Fehler UND gegen den erlaubten Fall
# (Arbeitsweise/schranke-gegentesten.md).
# ---------------------------------------------------------------------------
if (grep { $_ eq '--tests' } @ARGV) {
    my $fehler = 0;
    my $nr = 0;

    my $pruef = sub {
        my ($name, $ist, $soll) = @_;
        $nr++;
        return if $ist eq $soll;
        print "  FEHLER Selbsttest $nr ($name):\n    erwartet: $soll\n    bekommen: $ist\n";
        $fehler++;
    };

    # --- 1. Der MaSSstab kommt aus dem Tag-Bestand -------------------------
    my ($n, $tag) = neueste_paketnummer(qw(v1.0.9 v1.0.64 v1.0.72 v1.0.50));
    $pruef->('hoechstes Tag', "$tag/$n", 'v1.0.72/72');

    # Als Text sortiert stuende v1.0.9 hinter v1.0.72.
    my ($n2) = neueste_paketnummer(qw(v1.0.8 v1.0.9));
    $pruef->('numerisch, nicht als Text', $n2, '9');

    # --- 2. Datumsangaben sind keine Fassungen ----------------------------
    $pruef->('Datum wird nicht fuer eine Fassung gehalten',
             join(',', nummern_im_text('veroeffentlicht am 17.09.2026 um 20:07 Uhr')),
             '');
    $pruef->('alle drei Schreibweisen',
             join(',', nummern_im_text('v1.0.72 bzw. Fassung 7.2.0.72, Paket 1.0.72')),
             '72');

    # --- 3. DER ANLASSFALL: der Stand von main am 17.09.2026 --------------
    #
    # Die Absaetze sind WOERTLICH aus 8da72c8 uebernommen, nicht nachgebaut -
    # Arbeitsweise/testdaten-muessen-durchkommen.md.
    my %main_alt = (
        'README.md'       => "* **Noch nicht im Download enthalten:** das neueste Release ist **`v1.0.64`**\n"
                           . "  vom 17.09.2026.\n",
        'AUFGABEN.md'     => "**Veroeffentlicht ist `v1.0.64`** - am 17.09.2026 um 10:23 Uhr UTC auf GitHub\n"
                           . "herausgegangen und dort als *Latest* markiert; **1.0.65 bis 1.0.70 sind nicht\n"
                           . "freigegeben**.\n",
        'WEITERMACHEN.md' => "| **Zuletzt gebaut** | Quellstand **7.2.0.70** / `VERSION` **1.0.70** |\n",
    );
    my ($m_alt) = pruefe(\%main_alt, 72);
    $pruef->('Anlassfall: jede der drei Dateien wird beanstandet',
             (grep { /^README\.md:/ } @$m_alt) && (grep { /^AUFGABEN\.md:/ } @$m_alt)
                 && (grep { /^WEITERMACHEN\.md:/ } @$m_alt) ? 'ja'
                 : 'nein (' . join(' | ', @$m_alt) . ')', 'ja');
    $pruef->('und zwar mit der richtigen Begruendung',
             (grep { /^README\.md:1 gibt 1\.0\.64 als aktuellen Stand aus, veroeffentlicht ist 1\.0\.72/ } @$m_alt) ? 'ja' : 'nein',
             'ja');

    # Der AUFGABEN-Absatz nennt 64, 65 und 70; beanstandet wird die 64, weil
    # sie im SATZ mit der Standaussage steht - die Aufzaehlung dahinter ist ein
    # eigener Satz und entlastet nicht.
    $pruef->('Aufzaehlung ohne die aktuelle Nummer entlastet nicht',
             (grep { /^AUFGABEN\.md:1 gibt 1\.0\.64 als aktuellen Stand aus/ } @$m_alt) ? 'ja' : 'nein',
             'ja');

    # DIE REGRESSION VOM 18.09.2026, gefunden vom Gegentest gegen 8da72c8:
    # Solange der ABSATZ die Einheit war, deckte ein Querverweis 22 Zeilen
    # weiter unten die Luege in Zeile 1. Woertlich aus README.md des Standes
    # 8da72c8 (Zeile 72 und Zeile 94 desselben Listenpunkts).
    my %langer_punkt = (
        'README.md' => "* **Noch nicht im Download enthalten:** das neueste Release ist **`v1.0.64`**\n"
                     . "  (veroeffentlicht am 17.09.2026, auf GitHub als *Latest*). **Darin enthalten**\n"
                     . "  sind: Zeichensalat beim IMAP-Abruf (7.2.0.52), das Beenden (7.2.0.53),\n"
                     . "  der Formatverlust beim Weiterleiten (7.2.0.56) und der Absturz beim\n"
                     . "  Speichern (7.2.0.64, **E-97**). **Noch nicht im Download** sind: dieselbe\n"
                     . "  Absturzstelle an drei weiteren Orten\n"
                     . "  (**E-107** war die falsche Erklaerung und ist widerlegt; **E-108** in 7.2.0.72\n"
                     . "  ist der zweite Anlauf).\n",
    );
    my ($m_lang) = pruefe(\%langer_punkt, 72);
    $pruef->('ein Querverweis weiter unten im Absatz deckt die Luege NICHT',
             (grep { /^README\.md:1 gibt 1\.0\.64 als aktuellen Stand aus/ } @$m_lang) ? 'ja'
             : 'nein (' . join(' | ', @$m_lang) . ')', 'ja');

    # --- 4. Der berichtigte Stand muss durchlaufen ------------------------
    my %main_neu = (
        'README.md'       => "* **Das neueste Release ist `v1.0.72`** (17.09.2026, als *Latest*).\n",
        'AUFGABEN.md'     => "**Veroeffentlicht ist `v1.0.72`** - am 17.09.2026 auf GitHub\n"
                           . "herausgegangen und dort als *Latest* markiert; **1.0.65 bis 1.0.71 sind nicht\n"
                           . "freigegeben**.\n",
        'WEITERMACHEN.md' => "| **Zuletzt gebaut und veroeffentlicht** | Quellstand **7.2.0.72** / `VERSION` **1.0.72**, enthaelt 1.0.65, 1.0.67 bis 1.0.71 |\n",
    );
    my ($m_neu, $gezaehlt) = pruefe(\%main_neu, 72);
    $pruef->('berichtigter Stand laeuft durch', join(' | ', @$m_neu), '');
    $pruef->('es wurden ueberhaupt Absaetze geprueft',
             $gezaehlt >= 3 ? 'ja' : "nein ($gezaehlt)", 'ja');

    # --- 5. DER FEHLALARM, DER AM 18.09.2026 GEMESSEN WURDE ---------------
    #
    # WEITERMACHEN.md:27 im Arbeitsbaum - richtige Nummer plus Aufzaehlung der
    # Vorgaenger. Die erste Fassung warf hier SECHS Maengel.
    my %aufzaehlung = (
        'WEITERMACHEN.md' => "| **Zuletzt gebaut und veroeffentlicht** | Quellstand **7.2.0.72** / `VERSION` **1.0.72**, gebaut am 17.09.2026. **Sie enthaelt** alles aus 1.0.65, 1.0.67, 1.0.68, 1.0.69, 1.0.70 und 1.0.71. |\n",
    );
    my ($m_auf) = pruefe(\%aufzaehlung, 72);
    $pruef->('Aufzaehlung der Vorgaenger ist kein Mangel',
             join(' | ', @$m_auf), '');

    # --- 6. DAS LOCH, DAS AM 18.09.2026 GEMESSEN WURDE --------------------
    #
    # Releases/PAKETE.md:322-323, woertlich. Zeilenweise unsichtbar.
    my %umbruch = (
        'Releases/PAKETE.md' => "## 1.0.72 - veroeffentlicht am 17.09.2026\n\nText.\n\n"
                              . "## 1.0.29 - veroeffentlicht am 09.09.2026\n\n"
                              . "**Die aktuelle Fassung, und die einzige, die als Paket im Repo liegt.** Sie\n"
                              . "bringt gegenueber 1.0.28 fuenfzehn Behebungen.\n",
    );
    my ($m_um) = pruefe(\%umbruch, 72);
    $pruef->('der echte Absatz aus PAKETE.md wird beanstandet',
             (grep { /Releases\/PAKETE\.md:\d+ gibt 1\.0\.28 als aktuellen Stand aus/ } @$m_um)
             ? 'ja' : 'nein (' . join(' | ', @$m_um) . ')', 'ja');

    # Derselbe Absatz OHNE jede eigene Nummer - jetzt muss die Ueberschrift
    # einspringen, sonst ist er unpruefbar. Das ist der eigentliche
    # Erbschaftsfall.
    my %erbe = (
        'Releases/PAKETE.md' => "## 1.0.29 - veroeffentlicht am 09.09.2026\n\n"
                              . "**Die aktuelle Fassung, und die einzige, die als Paket im Repo liegt.**\n",
    );
    my ($m_erbe) = pruefe(\%erbe, 72);
    $pruef->('Absatz ohne eigene Nummer erbt die der Ueberschrift',
             (grep { /Releases\/PAKETE\.md:3 gibt 1\.0\.29 als aktuellen Stand aus.*Ueberschrift/ } @$m_erbe)
             ? 'ja' : 'nein (' . join(' | ', @$m_erbe) . ')', 'ja');

    # Und die Gegenrichtung: derselbe Satz unter der RICHTIGEN Ueberschrift
    # darf nicht anschlagen.
    my %umbruch_ok = (
        'Releases/PAKETE.md' => "## 1.0.72 - veroeffentlicht am 17.09.2026\n\n"
                              . "**Die aktuelle Fassung, und die einzige, die als Paket im Repo liegt.**\n",
    );
    my ($m_um_ok) = pruefe(\%umbruch_ok, 72);
    $pruef->('dieselbe Aussage unter der richtigen Ueberschrift laeuft durch',
             join(' | ', @$m_um_ok), '');

    # --- 7. DIE RUECKBLICK-LISTE, DIE ENTFERNT WURDE ----------------------
    #
    # Vorher: jede Zeile mit "zuvor" wurde ueberhaupt nicht angesehen. Eine
    # Luege, die das Wort enthaelt, kam durch. Jetzt nicht mehr.
    my %zuvor = (
        'README.md' => "Das neueste Release ist `v1.0.64`, wie zuvor auch.\n",
    );
    my ($m_zuvor) = pruefe(\%zuvor, 72);
    $pruef->('Luege mit dem Wort "zuvor" kommt NICHT mehr durch',
             (grep { /README\.md:1 gibt 1\.0\.64 als aktuellen Stand aus/ } @$m_zuvor) ? 'ja' : 'nein',
             'ja');

    # --- 8. Zitat und Protokollzeile duerfen nicht anschlagen -------------
    #
    # Der teurere Fehler waere der Fehlalarm: eine Schranke, die bei jedem
    # LEKTOR-Vermerk meckert, wird abgeschaltet und faengt dann gar nichts
    # mehr (Arbeitsweise/schranke-gegentesten.md).
    my %rueckblick = (
        'README.md' => "Das neueste Release ist `v1.0.72`.\n"
                     . "> **Berichtigt am 17.09.2026 (LEKTOR).** Hier stand `v1.0.50` als neuestes Release.\n",
        'tools/RELEASES.md' => "| 2026-09-17 10:23:08 | v1.0.64 | Gregor: 'funktioniert.' | veroeffentlicht, auf GitHub als *Latest* markiert |\n"
                             . "| 2026-09-17 20:07:49 | v1.0.72 | Gregor: 'kein crash' | veroeffentlicht |\n",
    );
    my ($m_rueck) = pruefe(\%rueckblick, 72);
    $pruef->('Zitat und Protokollzeile loesen keinen Fehlalarm aus',
             join(' | ', @$m_rueck), '');

    # Aber eine Tabellenzeile OHNE Datum in der ersten Spalte ist keine
    # Protokollzeile - sonst waere die Ausnahme ein Scheunentor.
    my %tab_ohne_datum = (
        'WEITERMACHEN.md' => "| **Zuletzt gebaut** | 1.0.64 |\n",
    );
    my ($m_tod) = pruefe(\%tab_ohne_datum, 72);
    $pruef->('Tabellenzeile ohne Datum bleibt pruefbar',
             (grep { /WEITERMACHEN\.md:1 gibt 1\.0\.64/ } @$m_tod) ? 'ja' : 'nein',
             'ja');

    # --- 9. Eine Datei, die den Stand gar nicht kennt ---------------------
    my ($m_stumm) = pruefe({ 'ZIEL.md' => "Text ohne jede Fassungsnummer.\n" }, 72);
    $pruef->('schweigende Datei wird gefunden',
             (grep { /nennt die Fassung 72 an keiner Stelle/ } @$m_stumm) ? 'ja' : 'nein',
             'ja');

    # --- 10. Umfang 0 ist kein Freispruch ---------------------------------
    my (undef, $g0) = pruefe({ 'X.md' => "Ein Text ueber 1.0.72 ohne jede Standaussage.\n" }, 72);
    $pruef->('Umfang wird gezaehlt und ist hier 0', $g0, '0');

    if ($fehler) {
        printf "\n  %d von %d Selbsttests fehlgeschlagen.\n\n", $fehler, $nr;
        exit 1;
    }
    printf "\n  Selbsttest: %d von %d bestanden - darunter der Anlassfall vom\n"
         . "  17.09.2026 (woertlich aus 8da72c8), die beiden am 18.09.2026\n"
         . "  gemessenen Fehler dieser Schranke selbst (Zeilenumbruch und\n"
         . "  Aufzaehlung) und die erlaubten Faelle.\n\n", $nr, $nr;
    exit 0;
}

# ---------------------------------------------------------------------------
my @tags = grep { length } split /\n/, `git -C "$wurzel" tag 2>/dev/null`;
chomp @tags;

my ($nr, $tag) = neueste_paketnummer(@tags);

unless (defined $nr) {
    print "\n  pruefe-release-buchfuehrung: kein Tag der Form vN.N.NN gefunden -\n";
    print "  es gibt noch kein Release, also auch keine Buchfuehrung darueber.\n\n";
    exit 0;
}

my %dateien = map { $_ => lies("$wurzel/$_") } @PFLICHT;
my ($mangel, $geprueft) = pruefe(\%dateien, $nr);

printf "\n  %s\n  Release-Buchfuehrung gegen den Tag-Bestand\n  %s\n",
    '-' x 60, '-' x 60;
printf "    Neuestes Tag                   %s  (Paketnummer %d)\n", $tag, $nr;
printf "    Geprueft                       %d Datei(en), %d Standaussage(n)\n",
    scalar @PFLICHT, $geprueft;

# UMFANG 0 IST KEIN FREISPRUCH (E-109, Punkt 4).
#
# Findet die Schranke keine einzige Standaussage, hat sie NICHTS geprueft -
# und das sieht sonst genauso aus wie "alles in Ordnung". Der wahrscheinlichste
# Grund ist, dass jemand die Formulierungen in den Dokumenten geaendert hat und
# ist_standaussage sie nicht mehr trifft; dann ist die Schranke blind, und das
# muss auffallen.
unless ($geprueft) {
    print <<"ENDE";

  NICHTS GEPRUEFT - das ist kein gruenes Ergebnis.

  In keinem der $#{[ @PFLICHT ]} Pflichtdokumente steht ein Absatz, den
  ist_standaussage() als Aussage ueber den aktuellen Stand erkennt. Entweder
  nennt kein Dokument mehr den Stand - dann fehlt die Angabe -, oder die
  Formulierungen haben sich geaendert und die Schranke trifft sie nicht mehr.
  In beiden Faellen ist etwas zu tun.

  E-109, Punkt 4: "geprueft und frei" und "nichts gefunden zu pruefen" duerfen
  nicht gleich aussehen.

ENDE
    exit 1;
}

unless (@$mangel) {
    print "\n  Jedes fuehrende Dokument kennt $tag, und keiner der $geprueft\n";
    print "  geprueften Absaetze gibt eine aeltere Fassung als aktuellen Stand aus.\n\n";
    exit 0;
}

printf "\n  MANGEL - %d Stelle(n):\n\n", scalar @$mangel;
print "    - $_\n" for @$mangel;

print <<'ENDE';

  Was wirklich veroeffentlicht ist, steht im Tag-Bestand - nicht in den
  Dokumenten. Am 17.09.2026 waren sich fuenf Dokumente einig, dass v1.0.64
  das neueste Release sei; das Tag v1.0.72 war da schon gesetzt. Einigkeit
  ist kein Wahrheitsbeweis, deshalb misst diese Schranke von auSSen.

  Gregor dazu: "keine luegen auf dem main" - und: "repariere deine schranken,
  so dass VOR dem commit und merge alles auf github vorhanden ist."

  Also: die Buchfuehrung JETZT nachziehen, im selben Arbeitsschritt
  (Arbeitsweise/doku-parallel-nicht-hinterher.md), nicht nach dem Merge.

ENDE
exit 1;
