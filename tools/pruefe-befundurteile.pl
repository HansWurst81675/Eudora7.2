#!/usr/bin/perl
use strict;
use warnings;

# Liefert verweise_text() - macht eine verlinkte Zeile wieder zu der
# Zeile, die vor dem Verlinken dastand.
use FindBin;
require "$FindBin::Bin/verweise-filtern.pl";


# Die Urteilstabelle in Intern/BEFUNDE.md traegt seit dem 12.10.2026 vor jeder
# Kennung einen Anker (tools/befunde-verlinken.pl). Wer die erste Zelle
# liest, muss ihn ueberspringen - sonst sieht er die Tabelle leer.
my $ANKER = qr/(?:<a\s+id="[^"]*"><\/a>)?/;

# pruefe-befundurteile.pl - kein Dokument darf einen Befund fuer erledigt
# erklaeren, den Intern/BEFUNDE.md offen fuehrt.
#
# WARUM ES DAS GIBT
#
# Am 10.09.2026 las Gregor den Abschnitt "Der Filterbericht" in Intern/FILTER.md:
#
#     Ein leerer Bericht nach einem Lauf, bei dem sichtbar etwas passiert
#     ist, war Befund E-71 - kein eigener Fehler, sondern Folge von E-72.
#
# Sein Urteil: "das ist noch eine luege, das stimmt ja nicht." Er hatte
# recht. E-72 war behoben, die Filter griffen nachweislich, und der Bericht
# blieb leer - E-71 stand in Intern/BEFUNDE.md laengst wieder als OFFEN. Die
# Einstufung "kein eigener Fehler" war meine eigene, widerlegte Behauptung;
# sie war in Intern/BEFUNDE.md berichtigt worden und in Intern/FILTER.md stehengeblieben.
#
# Das ist die Klasse: ein Urteil steht an zwei Stellen, und nur eine wird
# berichtigt. Der Leser trifft zuerst auf die falsche.
#
# WAS GEPRUEFT WIRD
#
# Intern/BEFUNDE.md ist die Quelle. Fuer jede Kennung wird dort das erste
# fettgedruckte Urteil gelesen. Fuehrt es den Befund als OFFEN, dann darf
# keine andere MD-Datei im Repo dieselbe Kennung in einem Absatz nennen,
# der eines der Erledigt-Woerter enthaelt.
#
# DIE UMGEKEHRTE RICHTUNG - AM 11.09.2026 NACHGETRAGEN.
#
# Hier stand bis dahin: "Umgekehrt wird NICHT geprueft: dass ein behobener
# Befund anderswo als offen steht, ist unschoen, aber ungefaehrlich - der
# Leser wird dann vorsichtiger als noetig, nicht sorgloser."
#
# Das ist widerlegt. Gregor am 11.09.2026: "wir hatten eine absprache: keine
# luegen auf main, ja? was ist daraus geworden?" An dem Tag stand auf main:
#
#   - der Zertifikats-Patch als "nicht angewandt", waehrend er seit b3be298
#     im Code war und Gregor die Fassung bereits getestet hatte
#   - Intern/AUFGABEN.md mit "vier Behebungen warten auf Gregors Urteil", waehrend
#     drei davon (E-49, E-50, E-52) laengst von ihm bestaetigt waren
#
# Wer dem glaubt, prueft Dinge nach, die durch sind, oder laesst eine
# Aenderung ungetestet liegen, weil sie angeblich gar nicht drin ist. Beides
# kostet GREGORS Zeit - und genau darueber hat er sich an dem Tag mehrfach
# beschwert: "deine nacharbeiten dauern mir immer zu lange!"
#
# "Vorsichtiger als noetig" ist kein harmloser Zustand, wenn die Vorsicht
# Arbeit ausloest. Deshalb wird jetzt BEIDE Richtungen geprueft.
#
# WAS BEWUSST DURCHGELASSEN WIRD
#
# Ein Absatz, der die Berichtigung SELBST beschreibt, muss die alten Worte
# zitieren duerfen. Solche Absaetze werden an den Woertern "Berichtigung",
# "widerlegt", "hier stand" und "galt als" erkannt und uebersprungen.
#
# Kommentare gibt es in Markdown nicht, wohl aber Code-Bloecke - die werden
# vorher weggeworfen, damit ein Protokollauszug nicht als Behauptung zaehlt
# (dieselbe Vorsicht wie in pruefe-beenden.pl).
#
# GEGENGETESTET, beide Richtungen, am 10.09.2026:
#
#   abweisen    Intern/FILTER.md im Stand vor der Berichtigung ("E-71 - kein
#               eigener Fehler") gegen Intern/BEFUNDE.md mit E-71 offen
#               -> Rueckgabe 1, die Stelle wird mit Datei und Zeile genannt
#   durchlassen derselbe Baum nach der Berichtigung
#               -> Rueckgabe 0
#
# Rueckgabe: 0 = kein Widerspruch, 1 = mindestens einer.

my $wurzel = $0;
$wurzel =~ s{[\\/]tools[\\/][^\\/]+$}{};
$wurzel = '.' if $wurzel eq $0 || $wurzel eq '';

# --- Woerter, die ein Urteil ausdruecken ----------------------------------
my @erledigt = (
    'behoben',
    'kein eigener Fehler',
    'erledigt',
    'nicht mehr auf',
);

my @offen = (
    'offen',
    'in Arbeit',
    'zurueckgestellt',
    "zur\xc3\xbcckgestellt",     # UTF-8, zurückgestellt
    # Am 12.10.2026 dazu: "aufgeschrieben" heisst in diesem Projekt, dass ein
    # Befund ERFASST ist - nicht, dass er behoben waere. Intern/WEITERMACHEN.md und
    # ZIEL.md sagen "E-105, E-111, E-112, E-113 aufgeschrieben" in demselben
    # Satz, in dem E-110 als behoben steht; ohne dieses Wort schlug die
    # Schranke dort viermal an, obwohl der Text richtig ist.
    'aufgeschrieben',
);

# --- Absaetze, die eine Berichtigung beschreiben, duerfen zitieren -------
my @ausnahme = (
    'Berichtigung',
    'widerlegt',
    'hier stand',
    'galt als',
    'fruehere Einstufung',
    "fr\xc3\xbchere Einstufung",
);

# TEILBEFUNDE (22.10.2026). "F1, F3 und F4 ... sind behoben; offen bleibt F2"
# ist KEIN Widerspruch zu einem offenen E-101 - behoben sind die TEILE, nicht
# der Befund. Als E-101 am 22.10.2026 in Intern/BEFUNDE.md von "behoben" auf "offen"
# berichtigt wurde, meldete diese Schranke genau deshalb fuenf Fehlalarme
# (README.md:106, Intern/PORTIERUNG.md:54, ZIEL.md:28, CHANGELOG.md:31,
# Intern/WEITERMACHEN.md:9) - alle fuenf Saetze waren richtig.
#
# Eng gehalten: es muss eine TEILKENNUNG (F3, N2, P1, B5.7, K1 ...) kurz vor
# dem "behoben" stehen. Ein blosses "offen bleibt" irgendwo im Absatz reicht
# NICHT, sonst entwaffnet ein beliebiger Nebensatz die Schranke
# (Arbeitsweise/schranke-gegentesten.md).
my $teilbefund = qr/\b(?:F|N|P|R|K|M|B5\.)\d+(?:[\s,;]+(?:und\s+)?(?:F|N|P|R|K|M|B5\.)?\d+)*(?:(?!\.\s+[A-ZÄÖÜ])[^|]){0,110}behoben/i;

sub lesen {
    my ($datei) = @_;
    open my $h, '<:raw', $datei or return undef;
    local $/;
    my $t = <$h>;
    close $h;
    return $t;
}

# Code-Bloecke wegwerfen, damit ein Protokollauszug nicht als Behauptung
# gilt. Zeilenzahl bleibt erhalten, damit die Fundstelle stimmt.
sub ohne_code {
    my ($t) = @_;
    my @zeilen = split /\n/, $t, -1;
    my $drin = 0;
    for my $z (@zeilen) {
        if ($z =~ /^\s*```/) { $drin = !$drin; $z = ''; next; }
        $z = '' if $drin;

        # Seit dem 12.10.2026 ist jede Kennung ein Link (befunde-verlinken.pl).
        # Das Linkziel traegt die Kennung ein zweites Mal - und zwar als
        # #e-112 mitten im Text. Diese Schranke liest ein Umfeld von 40
        # Zeichen um jede Kennung; ohne das Folgende meldet sie
        # "README.md nennt E-112 als behoben", weil vierzig Zeichen weiter
        # ein ganz anderer Befund als behoben bezeichnet wird. Gemessen:
        # fuenf solche Fehlalarme. Der Linktext bleibt stehen, nur das
        # Ziel faellt weg - die Zeilenzahl aendert sich dadurch nicht.
        # Auch die eckigen Klammern fallen weg: bleiben sie stehen, ist die
        # Zeile zwei Zeichen laenger als vor dem Verlinken, das Umfeld
        # verschiebt sich um zwei Zeichen - und zwei weitere Fehlalarme
        # standen da. Gemessen: 5 -> 2 -> 0.
        $z = verweise_text($z);
    }
    return join("\n", @zeilen);
}

# --- 1. Die Urteile aus Intern/BEFUNDE.md ----------------------------------------
my $befunde = lesen("$wurzel/Intern/BEFUNDE.md");
unless (defined $befunde) {
    print "\n  Intern/BEFUNDE.md nicht lesbar - nichts zu pruefen.\n\n";
    exit 0;
}

my %urteil;      # Kennung -> 'offen' | 'erledigt'
for my $zeile (split /\n/, $befunde) {
    next unless $zeile =~ /^\|\s*$ANKER\s*(E-\d+)\s*\|/;
    my $kennung = $1;
    next if exists $urteil{$kennung};    # erste Zeile gewinnt

    # Das Urteil steht in der DRITTEN Spalte, nicht im ersten Fettdruck der
    # Zeile. Der erste Fettdruck gehoert fast immer zur Beschreibung -
    # "| E-71 | der **Filterbericht** ist leer | **offen** ...". Genau daran
    # ist der erste Anlauf dieser Pruefung gescheitert: sie hielt
    # "Filterbericht" fuer das Urteil, erkannte E-71 nicht als offen und
    # liess die Gegenprobe durch.
    my @spalten = split /\|/, $zeile, -1;
    next unless @spalten >= 4;
    my $urteilstext = $spalten[3];

    # Im Urteilstext zaehlt das ERSTE Fettgedruckte - OHNE Laengengrenze.
    # Bis zum 15.09.2026 stand hier {1,60}. Ein Urteil von 62 oder 67 Zeichen
    # (E-90, E-92) fiel damit lautlos durch beide Werkzeuge; offene-befunde.pl
    # traegt dieselbe Berichtigung.
    my $ist_offen = 0;
    my $ist_erledigt = 0;
    if ($urteilstext =~ /\*\*([^*]+?)\*\*/) {
        my $wort = lc $1;
        $ist_offen    = 1 if grep { index($wort, lc $_) >= 0 } @offen;
        $ist_erledigt = 1 if grep { index($wort, lc $_) >= 0 } @erledigt;
    }
    # "behoben" schlaegt "offen": eine Zeile wie "behoben ... war offen"
    # beschreibt einen erledigten Befund.
    if ($ist_erledigt)     { $urteil{$kennung} = 'erledigt'; }
    elsif ($ist_offen)     { $urteil{$kennung} = 'offen'; }
}

my @offene = sort grep { $urteil{$_} eq 'offen' } keys %urteil;

# Die Gegenrichtung, seit 11.09.2026: was Intern/BEFUNDE.md als behoben fuehrt.
my @behobene = sort grep { $urteil{$_} eq 'erledigt' } keys %urteil;

# Statusworte, die einen Befund als NICHT erledigt ausgeben. Bewusst eng:
# "offen" allein steht zu haeufig in Nebensaetzen. Ein CHANGELOG-Abschnitt
# darf beschreiben, wie ein Befund WAR - das ist Fassungsgeschichte, keine
# Luege. Angeschlagen wird nur bei einem dieser Worte dicht hinter der
# Kennung.
#
# "zurueckgestellt" steht hier bewusst NICHT, obwohl es nach einem
# Befundstatus klingt. Es ist mehrdeutig: im CHANGELOG-Abschnitt zu E-61
# heisst es "WM_QUIT wird zurueckgestellt und das Ziehen abgebrochen" - eine
# technische Beschreibung, kein Urteil. Die Gegenprobe im Bestand hat genau
# daran angeschlagen, bevor die Schranke ausgeliefert wurde. Ein Wort, das in
# zwei Bedeutungen vorkommt, taugt nicht als Merkmal.
my @unerledigt = (
    'nicht angewandt', 'nicht begonnen',
    'liegt bereit', 'liegt nur bereit',
    'bleibt liegen', 'bleibt unangewendet', 'wartet auf',
    'noch nicht beurteilt',
);

# --- 2. Die Dokumente, die ein LESER trifft ------------------------------
#
# Bewusst eine feste Liste und kein Verzeichnisdurchlauf. Geprueft werden
# die Dokumente, auf die jemand stoesst, der wissen will, wie das Programm
# sich verhaelt. NICHT geprueft werden:
#
#   Befunde/       Berichte der Agenten - Momentaufnahmen, die alte
#                  Einstufungen zu Recht zitieren
#   Intern/LEKTORAT.md    ein Verzeichnis vergangener Falschaussagen; es MUSS die
#                  alten Worte enthalten, sonst haette es keinen Inhalt
#   Arbeitsweise/  Lehren, die aus Fehlern entstanden sind und diese
#                  Fehler beschreiben
#
# Wer ein weiteres Anwenderdokument anlegt, traegt es hier ein. Eine
# Schranke, die aus Vorsicht alles prueft und dann an Fehlalarmen
# abgeschaltet wird, prueft am Ende nichts.
my @dateien = grep { -f $_ } map { "$wurzel/$_" } qw(
    README.md
    Doku/ANWENDER.md
    Doku/BAUEN.md
    Doku/MITARBEITEN.md
    Doku/HINTERGRUND.md
    Intern/FILTER.md
    Intern/PORTIERUNG.md
    ZIEL.md
    CHANGELOG.md
    Intern/WEITERMACHEN.md
    Releases/1.0.3/LIESMICH.txt
);

my @mangel;
my $geprueft = 0;

for my $datei (@dateien) {
    my $t = lesen($datei) or next;
    $t = ohne_code($t);
    $geprueft++;

    # Absatzweise, damit "Kennung und Urteil im selben Gedanken" gilt.
    my @zeilen = split /\n/, $t, -1;
    my ($start, @absatz) = (1);
    my $nr = 0;

    my $pruefe = sub {
        my ($text, $zeile) = @_;
        return unless length $text;
        # LINKZIELE AUS DEM UMFELD WERFEN (22.10.2026). Die Naehe wird in
        # einem 40-Zeichen-Fenster gemessen - "im selben Gedanken". Ein
        # Linkziel ist aber kein Gedanke, sondern ein Pfad. Als die Dokumente
        # nach Intern/ zogen, wurde jedes Ziel um sieben Zeichen laenger, und
        # zwei Absaetze in CHANGELOG.md schlugen auf einmal an, deren Text
        # unveraendert richtig war (Zeile 1662 und 1929 - letztere sagt
        # woertlich "seit 13.10.2026 wieder offen"). Gemessen wird deshalb auf
        # dem SICHTBAREN Text.
        $text =~ s/\]\([^)]*\)/]/g;
        return if grep { index(lc $text, lc $_) >= 0 } @ausnahme;
        # Teilbefunde (F3, N2, B5.7 ...) behoben heisst nicht: Befund behoben.
        return if $text =~ $teilbefund;
        # --- Gegenrichtung: behoben, aber als unerledigt gefuehrt ------
        for my $k (@behobene) {
            next unless $text =~ /\Q$k\E(?!\d)/;   # E-7 darf nicht in E-71 treffen
            my $pos = 0;
            while ((my $i = index($text, $k, $pos)) >= 0) {
                # Dieselbe Grenze wie oben: steht hinter der Kennung eine
                # Ziffer, ist es eine andere (E-7 in E-71).
                if (substr($text, $i + length($k), 1) =~ /\d/) { $pos = $i + 1; next; }
                # In einer TABELLENZEILE zaehlt die ganze Zeile als Umfeld:
                # sie beschreibt genau einen Befund, und sein Urteil steht in
                # der dritten Spalte, also weit hinter der Kennung. Mit einem
                # 40-Zeichen-Fenster ging die Gegenprobe durch, obwohl in
                # derselben Zeile "nicht angewandt" stand - gemessen am
                # 11.09.2026, bevor die Schranke ausgeliefert wurde.
                my $umfeld = ($text =~ /^\s*\|/)
                           ? lc $text
                           : lc substr($text, $i, length($k) + 40);
                for my $w (@unerledigt) {
                    next unless $umfeld =~ /\b\Q$w\E/i;   # Wortgrenze: "mitbehoben" ist kein "behoben"
                    my $kurz = $text;
                    $kurz =~ s/\s+/ /g;
                    $kurz = substr($kurz, 0, 100) . '…' if length($kurz) > 100;
                    push @mangel, sprintf(
                        "%s:%d nennt %s als '%s' - Intern/BEFUNDE.md fuehrt ihn BEHOBEN\n        %s",
                        $datei, $zeile, $k, $w, $kurz);
                    last;
                }
                $pos = $i + 1;
            }
        }

        for my $k (@offene) {
            next unless $text =~ /\Q$k\E(?!\d)/;   # E-7 darf nicht in E-71 treffen

            # Steht die Kennung selbst als offen da - "(E-67, offen)" -,
            # ist sie richtig eingestuft, auch wenn im selben Absatz von
            # etwas anderem gesagt wird, es sei behoben. Ein Aufzaehlungs-
            # punkt darf zwei Befunde mit verschiedenen Urteilen nennen.
            my $nahe = 0;
            my $pos = 0;
            while ((my $i = index($text, $k, $pos)) >= 0) {
                # Dieselbe Grenze wie oben: steht hinter der Kennung eine
                # Ziffer, ist es eine andere (E-7 in E-71).
                if (substr($text, $i + length($k), 1) =~ /\d/) { $pos = $i + 1; next; }
                # Das Umfeld reicht nach BEIDEN Seiten. Bis zum 12.10.2026
                # sah es nur nach vorn - damit schlug "Weiter offen ist
                # E-113" an, obwohl die Kennung dort richtig eingestuft ist.
                # Vier der elf Beanstandungen an jenem Tag waren von dieser
                # Sorte; sie haben die Schranke unglaubwuerdig gemacht und
                # damit die sieben echten mit begraben.
                my $von = $i - 40; $von = 0 if $von < 0;
                my $umfeld = lc substr($text, $von, ($i - $von) + length($k) + 40);
                $nahe = 1 if grep { index($umfeld, lc $_) >= 0 } @offen;
                $pos = $i + 1;
            }
            next if $nahe;

            for my $w (@erledigt) {
                next unless lc($text) =~ /\b\Q$w\E/i;   # dito
                my $kurz = $text;
                $kurz =~ s/\s+/ /g;
                $kurz = substr($kurz, 0, 100) . '…' if length($kurz) > 100;
                push @mangel, sprintf(
                    "%s:%d nennt %s als '%s' - Intern/BEFUNDE.md fuehrt ihn OFFEN\n        %s",
                    $datei, $zeile, $k, $w, $kurz);
                last;
            }
        }
    };

    # Tabellen- und Aufzaehlungszeilen sind ihr EIGENER Pruefblock. Sonst
    # faellt eine ganze Tabelle in einen Topf, und ein "behoben" in Zeile 5
    # schlaegt gegen eine Kennung in Zeile 2 an. Genau diese Fehlalarme hat
    # der erste Anlauf produziert: die Tabelle der offenen Befunde in
    # Intern/FILTER.md nennt bei E-68 zu Recht, dass die andere Haelfte behoben
    # ist - und wurde deshalb fuer E-47, E-67 und E-69 angeschwaerzt.
    # Am 12.10.2026 dazu: dasselbe gilt INNERHALB eines Zitatblocks. Der
    # Abschnitt "Der naechste Schritt" in Intern/WEITERMACHEN.md ist ein einziger
    # Block aus "> "-Zeilen und zaehlt darin numerierte Schritte auf. Ein
    # "- erledigt." in Schritt 1 schlug damit gegen jede Kennung in Schritt
    # 2 bis 5 an: fuenf Fehlalarme aus einem einzigen Absatz. Ein Schritt
    # ist eine Aufzaehlung, auch wenn ein "> " davor steht.
    my $zitat_punkt = qr/^\s*>\s*(?:\*\*)?\d+\./;

    for my $z (@zeilen) {
        $nr++;
        if ($z =~ $zitat_punkt) {
            $pruefe->(join(' ', @absatz), $start) if @absatz;
            @absatz = ($z);              # der Schritt beginnt hier
            $start = $nr;
            next;
        }
        if ($z =~ /^\s*[|*+-]|^\s*\d+\./) {
            $pruefe->(join(' ', @absatz), $start) if @absatz;
            @absatz = ();
            $pruefe->($z, $nr);          # die Zeile fuer sich
            $start = $nr + 1;
            next;
        }
        # Eine Zeile aus nichts als "> " ist der Absatzwechsel INNERHALB
        # eines Zitatblocks - genauso trennend wie eine Leerzeile. Ohne das
        # lag in Intern/WEITERMACHEN.md "E-110 behoben" im selben Topf wie
        # "E-105, E-111, E-112, E-113 aufgeschrieben", vier Zeilen weiter.
        if ($z =~ /^\s*$/ || $z =~ /^\s*>\s*$/) {
            $pruefe->(join(' ', @absatz), $start);
            @absatz = ();
            $start = $nr + 1;
            next;
        }
        push @absatz, $z;
    }
    $pruefe->(join(' ', @absatz), $start);
}

# --- 3. Bericht ------------------------------------------------------------
print "\n  Befundurteile gegen Intern/BEFUNDE.md\n";
print '  ', '-' x 68, "\n";
printf "  Kennungen in Intern/BEFUNDE.md        %d\n", scalar keys %urteil;
printf "  davon offen                    %d\n", scalar @offene;
printf "  davon behoben                  %d\n", scalar @behobene;
printf "  gepruefte Dokumente            %d\n", $geprueft;
print '  ', '-' x 68, "\n";

if (@mangel) {
    print "\n  MANGEL:\n\n";
    print "    - $_\n" for @mangel;
    print "\n  Ein Urteil steht an zwei Stellen, und nur eine wurde\n";
    print "  berichtigt. Der Leser trifft zuerst auf die falsche - genau\n";
    print "  so ist Gregor am 10.09.2026 auf die Aussage gestossen, der\n";
    print "  leere Filterbericht sei \"kein eigener Fehler\". Sein Urteil:\n";
    print "  \"das ist noch eine luege, das stimmt ja nicht.\"\n";
    print "\n  Wer die alte Einstufung ZITIEREN will, schreibt in denselben\n";
    print "  Absatz das Wort \"Berichtigung\" oder \"widerlegt\".\n\n";
    exit 1;
}

print "\n  Kein Dokument erklaert einen offenen Befund fuer erledigt -\n"
    . "  und keinen behobenen fuer unerledigt.\n\n";
exit 0;
