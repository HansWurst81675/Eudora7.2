#!/usr/bin/perl
use strict;
use warnings;

# pruefe-befundurteile.pl - kein Dokument darf einen Befund fuer erledigt
# erklaeren, den BEFUNDE.md offen fuehrt.
#
# WARUM ES DAS GIBT
#
# Am 10.09.2026 las Gregor den Abschnitt "Der Filterbericht" in FILTER.md:
#
#     Ein leerer Bericht nach einem Lauf, bei dem sichtbar etwas passiert
#     ist, war Befund E-71 - kein eigener Fehler, sondern Folge von E-72.
#
# Sein Urteil: "das ist noch eine luege, das stimmt ja nicht." Er hatte
# recht. E-72 war behoben, die Filter griffen nachweislich, und der Bericht
# blieb leer - E-71 stand in BEFUNDE.md laengst wieder als OFFEN. Die
# Einstufung "kein eigener Fehler" war meine eigene, widerlegte Behauptung;
# sie war in BEFUNDE.md berichtigt worden und in FILTER.md stehengeblieben.
#
# Das ist die Klasse: ein Urteil steht an zwei Stellen, und nur eine wird
# berichtigt. Der Leser trifft zuerst auf die falsche.
#
# WAS GEPRUEFT WIRD
#
# BEFUNDE.md ist die Quelle. Fuer jede Kennung wird dort das erste
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
#   - AUFGABEN.md mit "vier Behebungen warten auf Gregors Urteil", waehrend
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
#   abweisen    FILTER.md im Stand vor der Berichtigung ("E-71 - kein
#               eigener Fehler") gegen BEFUNDE.md mit E-71 offen
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
    }
    return join("\n", @zeilen);
}

# --- 1. Die Urteile aus BEFUNDE.md ----------------------------------------
my $befunde = lesen("$wurzel/BEFUNDE.md");
unless (defined $befunde) {
    print "\n  BEFUNDE.md nicht lesbar - nichts zu pruefen.\n\n";
    exit 0;
}

my %urteil;      # Kennung -> 'offen' | 'erledigt'
for my $zeile (split /\n/, $befunde) {
    next unless $zeile =~ /^\|\s*(E-\d+)\s*\|/;
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

    # Im Urteilstext zaehlt das ERSTE Fettgedruckte.
    my $ist_offen = 0;
    my $ist_erledigt = 0;
    if ($urteilstext =~ /\*\*([^*]{1,60})\*\*/) {
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

# Die Gegenrichtung, seit 11.09.2026: was BEFUNDE.md als behoben fuehrt.
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
#   LEKTORAT.md    ein Verzeichnis vergangener Falschaussagen; es MUSS die
#                  alten Worte enthalten, sonst haette es keinen Inhalt
#   Arbeitsweise/  Lehren, die aus Fehlern entstanden sind und diese
#                  Fehler beschreiben
#
# Wer ein weiteres Anwenderdokument anlegt, traegt es hier ein. Eine
# Schranke, die aus Vorsicht alles prueft und dann an Fehlalarmen
# abgeschaltet wird, prueft am Ende nichts.
my @dateien = grep { -f $_ } map { "$wurzel/$_" } qw(
    README.md
    FILTER.md
    PORTIERUNG.md
    ZIEL.md
    CHANGELOG.md
    WEITERMACHEN.md
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
        return if grep { index(lc $text, lc $_) >= 0 } @ausnahme;
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
                    next unless index($umfeld, lc $w) >= 0;
                    my $kurz = $text;
                    $kurz =~ s/\s+/ /g;
                    $kurz = substr($kurz, 0, 100) . '…' if length($kurz) > 100;
                    push @mangel, sprintf(
                        "%s:%d nennt %s als '%s' - BEFUNDE.md fuehrt ihn BEHOBEN\n        %s",
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
                my $umfeld = lc substr($text, $i, length($k) + 40);
                $nahe = 1 if grep { index($umfeld, lc $_) >= 0 } @offen;
                $pos = $i + 1;
            }
            next if $nahe;

            for my $w (@erledigt) {
                next unless index(lc $text, lc $w) >= 0;
                my $kurz = $text;
                $kurz =~ s/\s+/ /g;
                $kurz = substr($kurz, 0, 100) . '…' if length($kurz) > 100;
                push @mangel, sprintf(
                    "%s:%d nennt %s als '%s' - BEFUNDE.md fuehrt ihn OFFEN\n        %s",
                    $datei, $zeile, $k, $w, $kurz);
                last;
            }
        }
    };

    # Tabellen- und Aufzaehlungszeilen sind ihr EIGENER Pruefblock. Sonst
    # faellt eine ganze Tabelle in einen Topf, und ein "behoben" in Zeile 5
    # schlaegt gegen eine Kennung in Zeile 2 an. Genau diese Fehlalarme hat
    # der erste Anlauf produziert: die Tabelle der offenen Befunde in
    # FILTER.md nennt bei E-68 zu Recht, dass die andere Haelfte behoben
    # ist - und wurde deshalb fuer E-47, E-67 und E-69 angeschwaerzt.
    for my $z (@zeilen) {
        $nr++;
        if ($z =~ /^\s*[|*+-]|^\s*\d+\./) {
            $pruefe->(join(' ', @absatz), $start) if @absatz;
            @absatz = ();
            $pruefe->($z, $nr);          # die Zeile fuer sich
            $start = $nr + 1;
            next;
        }
        if ($z =~ /^\s*$/) {
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
print "\n  Befundurteile gegen BEFUNDE.md\n";
print '  ', '-' x 68, "\n";
printf "  Kennungen in BEFUNDE.md        %d\n", scalar keys %urteil;
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
