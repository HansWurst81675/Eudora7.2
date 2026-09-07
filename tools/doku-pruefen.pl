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
# Deshalb dieses Werkzeug. Es prueft mechanisch, was ein Mensch nur muehsam
# nachhalten kann, und es laeuft im pre-commit-Hook mit.

use strict;
use warnings;

my $leise = grep { $_ eq '--leise' } @ARGV;
my @mangel;
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

# --- 4. Befundkennungen: keine darf zwei Bedeutungen haben -------------------
# Gesammelt wird je Kennung der Text der Zeile. Steht dieselbe Kennung in zwei
# Dateien mit klar verschiedenen Stichworten, ist das ein Kollisionsverdacht.
my %kennung;
for my $datei (@aktuell, 'BEFUNDE.md') {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    my @zeilen = split /\n/, $inhalt;
    for my $i (0 .. $#zeilen) {
        while ($zeilen[$i] =~ /\bE-(\d+)\b/g) {
            push @{ $kennung{$1} }, { datei => $datei, zeile => $i + 1, text => $zeilen[$i] };
        }
    }
}

# Eine Kennung, die in EINER Datei sowohl als behoben als auch als offen
# auftaucht, ist ein Widerspruch.
for my $nr (sort { $a <=> $b } keys %kennung) {
    my (%behoben, %offen);
    for my $t (@{ $kennung{$nr} }) {
        $behoben{ $t->{datei} } = $t->{zeile} if $t->{text} =~ /behoben|erledigt/i;
        $offen{   $t->{datei} } = $t->{zeile} if $t->{text} =~ /\boffen\b|nicht behoben|in Arbeit/i;
    }
    for my $datei (sort keys %behoben) {
        next unless exists $offen{$datei};
        push @mangel, sprintf("E-%s steht in %s sowohl als behoben (Zeile %d) als auch als offen (Zeile %d)",
                              $nr, $datei, $behoben{$datei}, $offen{$datei});
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

# --- 6. Fassungsstand: nennt jede Datei die aktuelle Fassung? ----------------
for my $datei (@aktuell) {
    my $inhalt = lies($datei);
    next unless defined $inhalt;
    my @gefunden = ($inhalt =~ /\b7\.2\.0\.(\d+)\b/g);
    next unless @gefunden;
    my ($hoechste) = sort { $b <=> $a } @gefunden;
    my ($soll) = $quellstand =~ /\.(\d+)\z/;
    next unless defined $soll;
    if ($hoechste < $soll) {
        push @hinweis, sprintf("%s nennt als neueste Fassung 7.2.0.%d, der Quellstand ist %s",
                               $datei, $hoechste, $quellstand);
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
    print "  ", "-" x 60, "\n";
    if (@mangel) {
        print "\n  MANGEL:\n\n";
        print "    - $_\n" for @mangel;
    } else {
        print "\n  Kein Widerspruch gefunden.\n";
    }
    if (@hinweis) {
        print "\n  Zur Kenntnis:\n\n";
        print "    - $_\n" for @hinweis;
    }
    print "\n";
}

exit(@mangel ? 1 : 0);
