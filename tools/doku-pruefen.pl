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
# Zeitdokumente (Pruefberichte, Befundsammlungen) sind ausdruecklich nicht
# dabei: sie beschreiben einen Zustand von damals und duerfen alt sein.
my @aktuell = qw(README.md ZIEL.md WEITERMACHEN.md AUFGABEN.md CHANGELOG.md);

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
for my $datei (@aktuell) {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    my @zeilen = split /\n/, $inhalt;
    for my $i (0 .. $#zeilen) {
        while ($zeilen[$i] =~ /\[[^\]]*\]\(([^)#]+?)\)/g) {
            my $ziel_pfad = $1;
            next if $ziel_pfad =~ m{^[a-z]+://};       # Netzadresse
            next if $ziel_pfad =~ /^mailto:/;
            $ziel_pfad =~ s/\s+\z//;
            next if -e $ziel_pfad;
            push @mangel, sprintf("%s:%d verweist auf '%s' - gibt es nicht",
                                  $datei, $i + 1, $ziel_pfad);
        }
    }
}

# --- 6. Fassungsstand --------------------------------------------------------
# Eine Datei ist aktuell, wenn sie den Quellstand ODER die Paketnummer nennt.
# Sie darf daneben aeltere Fassungen erwaehnen - "die sieben Vermutungen stehen
# unter 7.2.0.17" ist eine Fundstelle, kein veralteter Stand. Der erste Anlauf
# hat genau das gemeldet und AUFGABEN.md damit zu Unrecht angeschwaerzt.
for my $datei (@aktuell) {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
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
