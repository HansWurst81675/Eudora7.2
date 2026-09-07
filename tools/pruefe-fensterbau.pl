#!/usr/bin/perl
#
# Prueft die Schranken, die das Verfassen-Fenster am Leben halten.
#
#   perl tools/pruefe-fensterbau.pl [--wurzel PFAD]
#
# Rueckgabe 0 = alle Schranken stehen, 1 = eine fehlt, 2 = Aufruffehler.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 07.09.2026 kam nach Strg-N kein Verfassen-Fenster. Zwei Ursachen, beide
# so gebaut, dass sie jederzeit wiederkehren koennen:
#
#   E-33  Die Meldungen der Ersatzschicht waren MODALE Dialoge. Ein modaler
#         Dialog verteilt Windows-Nachrichten weiter - dadurch geriet ein
#         zweiter Strg-N mitten in den Fensterbau des ersten. Eine Meldung
#         ueber fehlendes Beiwerk darf das Programm nicht anhalten.
#
#   E-34  QCChildToolBar::GetButton warf eine MFC-Ausnahme ("Encountered an
#         improper argument", Index 24 von 27). Sie wickelte OnCreateClient
#         ab, MFC liess LoadFrame fehlschlagen, CreateNewFrame gab NULL -
#         kein Fenster, ohne Meldung und ohne Absturz.
#
# Beide Behebungen sind eine einzelne Zeile weit davon entfernt, versehentlich
# zurueckgenommen zu werden: ein AfxMessageBox in der Ersatzschicht, ein
# entfernter CATCH_ALL. Deshalb diese Schranken.

use strict;
use warnings;

my $wurzel = '.';
for (my $i = 0; $i < @ARGV; $i++) {
    if ($ARGV[$i] eq '--wurzel') { $wurzel = $ARGV[$i+1]; $i++ }
    elsif ($ARGV[$i] eq '--hilfe') {
        print "  perl tools/pruefe-fensterbau.pl [--wurzel PFAD]\n";
        exit 0;
    }
    else { print "  Unbekannter Schalter: $ARGV[$i]\n"; exit 2 }
}

sub lies {
    my ($rel) = @_;
    my $pfad = "$wurzel/$rel";
    return undef unless -f $pfad;
    open(my $h, '<:raw', $pfad) or return undef;
    local $/;
    my $t = <$h>;
    close $h;
    return $t;
}

# Kommentare entfernen, ABER die Zeilenzahl erhalten - sonst verschieben sich
# alle Zeilennummern in der Meldung. Am 07.09.2026 meldete das Werkzeug 1697,
# gemeint war 1714.
#
# Die Reihenfolge ist wesentlich: ZUERST Zeilenkommentare, DANN Blockkommentare.
# Umgekehrt frisst ein "/*" innerhalb eines Zeilenkommentars alles bis zum
# naechsten echten "*/". Gemessen an OTShim.cpp:99 - dort steht im Kommentar
# "dlg.Create in Eudora/*.cpp", und die Gegenprobe zu E-33 blieb dadurch
# gruen, obwohl die modale Meldung wieder eingebaut war. Eine Schranke, die
# eine Regression nicht meldet, ist schlimmer als keine.
sub ohne_kommentare {
    my ($t) = @_;
    $t =~ s{//[^\n]*}{}g;
    $t =~ s{/\*(.*?)\*/}{ my $x = $1; $x =~ tr/\n//cd; $x }gse;
    return $t;
}

sub nurname {
    my ($pfad) = @_;
    my $bs = chr(92);
    $pfad =~ s/\Q$bs\E/\//g;
    my @teile = split m{/}, $pfad;
    return $teile[-1];
}

my @mangel;
my @geprueft;

# --- 1. E-33: keine modale Meldung in der Ersatzschicht ----------------------
{
    my @dateien = glob("$wurzel/Eudora71/OTShim/*.cpp");
    if (!@dateien) {
        push @mangel, "E-33: Eudora71/OTShim/*.cpp nicht gefunden - nichts geprueft";
    }
    else {
        my @treffer;
        for my $d (@dateien) {
            open(my $h, '<:raw', $d) or next;
            local $/;
            my $t = ohne_kommentare(<$h>);
            close $h;
            my @zeilen = split /\n/, $t;
            for my $i (0 .. $#zeilen) {
                next unless $zeilen[$i] =~ /\b(?:Afx)?MessageBox\s*\(/;
                push @treffer, sprintf("%s:%d", nurname($d), $i + 1);
            }
        }
        push @geprueft, sprintf("E-33  modale Meldungen in der Ersatzschicht: %d", scalar @treffer);
        push @mangel, "E-33: modale Meldung in der Ersatzschicht - " . join(", ", @treffer)
            if @treffer;
    }
}

# --- 2. E-34: GetButton faengt Ausnahmen ------------------------------------
{
    my $t = lies('Eudora71/Eudora/QCChildToolBar.cpp');
    if (!defined $t) {
        push @mangel, "E-34: QCChildToolBar.cpp nicht gefunden - nichts geprueft";
    }
    else {
        my ($rumpf) = $t =~ /void\*\s+QCChildToolBar::GetButton\s*\([^)]*\)\s*\{(.*?)\n\}/s;
        if (!defined $rumpf) {
            push @mangel, "E-34: QCChildToolBar::GetButton nicht gefunden";
        }
        else {
            my $sauber = ohne_kommentare($rumpf);
            my $hat_schranke = ($sauber =~ /\bif\s*\(\s*iIndex\s*<\s*0/);
            my $hat_fang     = ($sauber =~ /\bTRY\b/ && $sauber =~ /\bCATCH(?:_ALL)?\b/);
            push @geprueft, "E-34  GetButton: Indexschranke " .
                            ($hat_schranke ? "ja" : "NEIN") .
                            ", Ausnahmefang " . ($hat_fang ? "ja" : "NEIN");
            push @mangel, "E-16/E-34: QCChildToolBar::GetButton prueft den Index nicht mehr"
                unless $hat_schranke;
            push @mangel, "E-34: QCChildToolBar::GetButton faengt keine Ausnahme mehr - " .
                          "eine Ausnahme dort verhindert das ganze Verfassen-Fenster"
                unless $hat_fang;
        }
    }
}

# --- 3. Jeder GetButton-Aufruf prueft das Ergebnis --------------------------
{
    my @dateien = qw(
        Eudora71/Eudora/CompMessageFrame.cpp
        Eudora71/Eudora/ReadMessageFrame.cpp
        Eudora71/Eudora/PgDocumentFrame.cpp
    );
    my $aufrufe = 0;
    my @ungeprueft;
    for my $rel (@dateien) {
        my $t = lies($rel);
        next unless defined $t;
        my @zeilen = split /\n/, ohne_kommentare($t);
        for my $i (0 .. $#zeilen) {
            next unless $zeilen[$i] =~ /->GetButton\s*\(/;
            $aufrufe++;

            # Den Namen der Variablen holen, in die das Ergebnis geht. Ohne
            # ihn muesste das Werkzeug Namen raten - am 07.09.2026 hat es
            # deshalb eine korrekt abgesicherte Stelle gemeldet, weil die
            # Variable nicht "...Button" hiess (pSendeKnopf).
            my $name;
            for my $j (($i >= 2 ? $i - 2 : 0) .. $i) {
                if ($zeilen[$j] =~ /(\w+)\s*=\s*$/ || $zeilen[$j] =~ /(\w+)\s*=[^=]/) {
                    $name = $1;
                }
            }

            # Sonderfall: der Rueckgabewert wird direkt dereferenziert, ohne
            # ihn irgendwo abzulegen. Das ist immer ein Mangel.
            if ($zeilen[$i] =~ /GetButton\s*\([^;]*\)\s*\)?\s*->/) {
                push @ungeprueft, sprintf("%s:%d (direkt dereferenziert)",
                                          nurname($rel), $i + 1);
                next;
            }

            next unless defined $name;

            # In den naechsten sechs Zeilen muss dieser Name auf NULL
            # geprueft werden.
            my $bis = ($i + 6 > $#zeilen) ? $#zeilen : $i + 6;
            my $fenster = join("\n", @zeilen[$i .. $bis]);
            next if $fenster =~ /\bif\s*\([^)]*\b\Q$name\E\b/;
            next if $fenster =~ /\bif\s*\(\s*!\s*\Q$name\E\b/;

            push @ungeprueft, sprintf("%s:%d (%s ungeprueft)",
                                      nurname($rel), $i + 1, $name);
        }
    }
    push @geprueft, sprintf("E-34  GetButton-Aufrufe: %d, davon ohne NULL-Pruefung: %d",
                            $aufrufe, scalar @ungeprueft);
    push @mangel, "E-34: GetButton-Ergebnis ungeprueft benutzt - " . join(", ", @ungeprueft)
        if @ungeprueft;
}


# --- Bilanz -----------------------------------------------------------------
print "\n  Schranken des Fensterbaus\n";
print "  ", "-" x 62, "\n";
print "  $_\n" for @geprueft;
print "  ", "-" x 62, "\n";
if (@mangel) {
    print "\n  MANGEL:\n\n";
    print "    - $_\n" for @mangel;
    print "\n";
    exit 1;
}
print "\n  Alle Schranken stehen.\n\n";
exit 0;
