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
    # BEFUND E-36: Hier stand eine FESTE Dateiliste (CompMessageFrame,
    # ReadMessageFrame, PgDocumentFrame). PgCompMsgView.cpp fehlte darin - und
    # genau dort lagen zwei weitere blinde Zugriffe, die erst Eudoras eigener
    # Absturzbericht am 07.09.2026 zutage brachte (CMoodMailStatic::GetScore
    # aus PgCompMsgView::OnTimer). Eine Schranke mit handgepflegter Dateiliste
    # hat immer genau die Luecke, die man nicht bedacht hat.
    my @dateien = map { my $x = $_; $x =~ s{^\Q$wurzel\E/}{}; $x }
                  glob("$wurzel/Eudora71/Eudora/*.cpp");
    my $aufrufe = 0;
    my @ungeprueft;
    # JE ANWEISUNG, NICHT JE ZEILE (25.10.2026, PRUEFER-50 K2). Die alte Regel
    # arbeitete zeilenweise: den Namen suchte sie nur zwei Zeilen zurueck und
    # uebersprang den Aufruf OHNE MELDUNG, wenn sie keinen fand; "->" erkannte
    # sie nur auf derselben Zeile; und eine Pruefung NACH dem Zugriff zaehlte
    # auch. Drei Rueckfaelle kamen so durch, darunter das QUALCOMM-Original,
    # nur umbrochen (tools/regression-schranken.txt, E-35 R1 bis R3). Jetzt:
    #   1. die ganze Anweisung um den Aufruf herum (bis ";") wird gelesen;
    #   2. folgt auf "GetButton(...)" samt Typumwandlung ein "->", ist das
    #      ein Zugriff ohne Pruefung - gleich, auf welcher Zeile;
    #   3. ohne Namen, dem das Ergebnis zugewiesen wird, wird GEMELDET;
    #   4. mit Namen muss eine Pruefung auf NULL VOR dem ersten "name->"
    #      stehen (gesucht bis zum Ende der Funktion).
    for my $rel (@dateien) {
        my $t = lies($rel);
        next unless defined $t;
        my $c = ohne_kommentare($t);
        while ($c =~ /->GetButton\s*\(/g) {
            my $p = $-[0];
            my $auf = $+[0] - 1;             # Position der oeffnenden Klammer
            $aufrufe++;
            my $zeile = 1 + (() = substr($c, 0, $p) =~ /\n/g);

            # Anweisungsbeginn: letztes ; { } davor. Anweisungsende: ";"
            # auf Klammertiefe null danach.
            my $vorne = substr($c, 0, $p);
            my $anf = 0;
            $anf = $+[0] while $vorne =~ /[;{}]/g;
            my ($tiefe, $ende, $zu) = (0, undef, undef);
            for my $i ($auf .. length($c) - 1) {
                my $z = substr($c, $i, 1);
                if    ($z eq '(') { $tiefe++ }
                elsif ($z eq ')') { $tiefe--; $zu = $i if !defined $zu and $tiefe == 0 }
                elsif ($z eq ';' and $tiefe <= 0) { $ende = $i; last }
            }
            $ende //= length($c) - 1;
            my $anw = substr($c, $anf, $ende - $anf);

            # 2. Direkt dereferenziert? Nach der schliessenden Klammer des
            #    Aufrufs duerfen nur Leerraum und weitere ")" stehen, dann "->".
            if (defined $zu and substr($c, $zu + 1, $ende - $zu) =~ /^[\s)]*->/) {
                push @ungeprueft, sprintf("%s:%d (direkt dereferenziert)", nurname($rel), $zeile);
                next;
            }

            # 3. Name der Variablen, der das Ergebnis zugewiesen wird.
            my ($name) = $anw =~ /(\w+)\s*=(?!=)[^;]*->GetButton\s*\(/s;
            if (!defined $name) {
                push @ungeprueft, sprintf("%s:%d (Ergebnis keiner Variablen zugewiesen - nicht pruefbar)",
                                          nurname($rel), $zeile);
                next;
            }

            # 4. Pruefung vor dem ersten Zugriff, gesucht bis zum Ende der
            #    Funktion (erste Zeile, die mit "}" beginnt).
            my $rest = substr($c, $ende);
            my $fe = index($rest, "\n}");
            $rest = substr($rest, 0, $fe) if $fe >= 0;
            my $zugriff = $rest =~ /\b\Q$name\E\s*->/ ? $-[0] : -1;
            my $pruef = -1;
            # Als Pruefung zaehlt nur der Name ALLEIN in der Bedingung oder mit
            # &&, ||, != NULL, == NULL verknuepft - NICHT "name->..." (E-36,
            # 24.10.2026: "if (pStimmung->GetScore() != nScore)" ist ein
            # Zugriff, keine Pruefung).
            if ($rest =~ /\bif\s*\([^;{]*?(?<![\w>.])\Q$name\E\s*(?:&&|\|\||\)|[!=]=\s*(?:NULL|0|nullptr)\b)/
             || $rest =~ /\bif\s*\(\s*!\s*\Q$name\E\b/) {
                $pruef = $-[0];
            }
            next if $zugriff < 0;                          # nie benutzt: harmlos
            next if $pruef >= 0 and $pruef < $zugriff;     # erst geprueft, dann benutzt
            push @ungeprueft, sprintf("%s:%d (%s %s)", nurname($rel), $zeile, $name,
                                      $pruef < 0 ? 'ungeprueft' : 'erst benutzt, dann geprueft');
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
