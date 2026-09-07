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
my @alle_md = grep { length } split /\n/, (qx{git ls-files "*.md" 2>NUL} || '');
@alle_md = grep { !m{^Arbeitsweise/} } @alle_md;

my $zeitdokument = qr{^(?:Befunde/|Pruefung/|Releases/1\.0/|BEFUNDE\.md$|LEKTORAT\.md$|PRUEFUNG-|ABRUF-PRUEFEN\.md$|Releases/PAKETE\.md$)};
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
my %wort = (
    zwei => 2, drei => 3, vier => 4, fuenf => 5, sechs => 6, sieben => 7, acht => 8,
);
for my $datei (@aktuell) {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    my @zeilen = split /\n/, $inhalt;
    for my $i (0 .. $#zeilen) {
        my $z = $zeilen[$i];
        # "vier Kriterien", "alle vier Kriterien", "sieben Kriterien"
        while ($z =~ /(zwei|drei|vier|fuenf|sechs|sieben|acht)\s+Kriterien/gi) {
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
            while ($fenster =~ /\b([0-9]+\.[0-9]+\.[0-9]+)\b/g) {
                my $nr = $1;
                next unless $nr =~ /^\Q$paket_haupt\E\./;
                next if $nr eq $paket;
                my $zeile = 1 + (() = substr($inhalt, 0, $ab) =~ /\n/g);
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
