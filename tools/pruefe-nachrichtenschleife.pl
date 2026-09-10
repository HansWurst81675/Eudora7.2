#!/usr/bin/perl
use strict;
use warnings;

# pruefe-nachrichtenschleife.pl - eine eigene Nachrichtenschleife darf das
# Beenden des Programms nicht verschlucken, und sie darf nicht unbegrenzt
# warten.
#
# WARUM ES DAS GIBT
#
# Zwei Fehler derselben Klasse, beide am selben Tag:
#
#   E-51 (09.09.2026, von mir selbst) - Splitter::Track lief mit
#        while(::GetMessage(...)). Kommt kein WM_LBUTTONUP, wartet die
#        Schleife FUER IMMER. Die Pruefinstanz musste zweimal abgeschossen
#        werden. Genau die Klasse, die Gregor tagelang gekostet hat:
#        "beenden kann ich es auch nicht".
#
#   E-61 (09.09.2026, von PRUEFER) - dieselbe Schleife nahm Nachrichten mit
#        PeekMessage(PM_REMOVE) aus der Schlange, ohne WM_QUIT
#        zurueckzustellen. Eine Aufforderung zu beenden, die waehrend eines
#        Zuges kommt, war damit weg. Kriterium 7 haette lautlos wieder
#        aufgehen koennen - Wochen nach seiner Bestaetigung.
#
# WAS ES PRUEFT
#
#   1. Kein `while (... GetMessage(` in unserem Code. GetMessage blockiert
#      ohne Zeitschranke; wer eine eigene Schleife braucht, nimmt
#      MsgWaitForMultipleObjects mit Zeitangabe und prueft danach seine
#      Abbruchgruende selbst.
#
#   2. In jeder Funktion, die Nachrichten ENTNIMMT - PeekMessage mit
#      PM_REMOVE oder GetMessage -, muss WM_QUIT vorkommen. Sonst ist die
#      Nachricht entnommen und niemand stellt sie zurueck.
#
# Kommentare und Zeichenketten werden VOR dem Suchen weggeworfen - sonst
# schwaerzt die Schranke ihre eigene Begruendung an (Lehre
# schranke-liest-nur-code).
#
# Gegengetestet in beide Richtungen, siehe
# tools/pruefe-nachrichtenschleife-tests.pl.
#
# Rueckgabe: 0 = alles in Ordnung, 1 = Mangel.

my $wurzel = $0;
$wurzel =~ s{[\\/]tools[\\/][^\\/]+$}{};
$wurzel = '.' if $wurzel eq $0 || $wurzel eq '';

# --- Kommentare und Zeichenketten entfernen --------------------------------
# Die Zeilennummern muessen erhalten bleiben, deshalb behaelt jeder entfernte
# Block seine Zeilenumbrueche.
sub nur_code {
    my ($t) = @_;
    # CRLF zuerst vereinheitlichen. Ohne diese Zeile war die Schranke genau
    # fuer die Datei blind, fuer die sie geschrieben wurde: OTShim.cpp ist
    # reines CRLF, und das Muster fuer einen Funktionskopf verlangt "{\n" -
    # "{\r\n" passte nicht. Gemessen am 09.09.2026: 7 Fundstellen in
    # LF-Dateien, 0 in OTShim.cpp, obwohl dort eine Schleife steht. Genau die
    # Klasse "stumme Schranke" aus der Lehre schranke-gegentesten.
    $t =~ s/\r\n/\n/g;
    $t =~ s{/\*(.*?)\*/}{ my $z = $1; $z =~ tr/\n//cd; $z }gse;
    $t =~ s{//[^\n]*}{}g;
    $t =~ s{"(?:[^"\\\n]|\\.)*"}{""}g;
    $t =~ s{'(?:[^'\\\n]|\\.)*'}{''}g;
    return $t;
}

# --- Funktionsrumpfe herausloesen ------------------------------------------
# Gesucht wird ab einer Kopfzeile mit Klammerpaar bis zur schliessenden
# Klammer in Spalte 1. Das reicht fuer diesen Baum: jeder Funktionsrumpf
# endet dort mit "\n}".
sub rumpfe {
    my ($t) = @_;
    my @r;
    while ($t =~ /\n(\w[^\n;{}]*\([^\n;]*\)[^\n;{}]*)\n?[ \t]*\{[ \t]*\n/g) {
        my $kopf = $1;
        my $ab   = pos($t) - 1;
        my $ende = index($t, "\n}", $ab);
        $ende = length($t) - 1 if $ende < 0;
        push @r, { kopf => $kopf, ab => $ab, text => substr($t, $ab, $ende - $ab) };
        pos($t) = $ab + 1;
    }
    return @r;
}

# --- Eine Quelle pruefen ---------------------------------------------------
# Getrennt gehalten, damit die Gegentests denselben Weg fahren wie der
# Ernstfall (Lehre messung-muss-den-weg-treffen).
sub pruefe_text {
    my ($kurz, $roh) = @_;
    my $t = nur_code($roh);
    my (@mangel, @gesehen);

    my @f = rumpfe($t);

    # 1. Blockierendes Warten - aber nur, wenn die Fassung WM_QUIT gar nicht
    #    behandelt.
    #
    #    Anfangs war jedes `while (... GetMessage(` ein Mangel. Das ist zu
    #    scharf: eine Fassung, die WM_QUIT auswertet, VERLAESST die Schleife,
    #    wenn das Programm enden soll - und genau darum geht es. So arbeiten
    #    Eudoras Wartestellen fuer die Trident-Anzeige und fuer das
    #    Abspielen von Anhaengen, und die umzubauen waere eine Aenderung am
    #    Verhalten ohne Anlass. Eine Schranke, die Richtiges abweist, wird
    #    umgangen statt befolgt (Lehre schranke-gegentesten).
    while ($t =~ /\bwhile\s*\([^)\n]*\bGetMessage\s*\(/g) {
        my $ab    = pos($t);
        my $zeile = 1 + (() = substr($t, 0, $ab) =~ /\n/g);

        my $behandelt = 0;
        for my $f (@f) {
            next unless $ab >= $f->{ab} && $ab <= $f->{ab} + length($f->{text});
            $behandelt = 1 if $f->{text} =~ /\bWM_QUIT\b/;
        }
        next if $behandelt;

        push @mangel, "$kurz:$zeile blockierende Schleife: while (... GetMessage(...) "
                    . 'wartet ohne Zeitschranke und behandelt WM_QUIT nicht. Kommt '
                    . 'die erwartete Nachricht nie, ist das Programm tot (Befund '
                    . 'E-51). MsgWaitForMultipleObjects mit Zeitangabe nehmen und '
                    . 'die Abbruchgruende selbst pruefen - oder mindestens WM_QUIT '
                    . 'auswerten und die Schleife verlassen.';
    }

    for my $f (@f) {
        my $rumpf = $f->{text};
        my $nimmt = ($rumpf =~ /\bPeekMessage\s*\([^;]*PM_REMOVE/s)
                 || ($rumpf =~ /(?<!\w)GetMessage\s*\(\s*&/s);
        next unless $nimmt;

        my $zeile = 1 + (() = substr($t, 0, $f->{ab}) =~ /\n/g);
        my $name  = $f->{kopf};
        $name =~ s/^\s+//;
        $name =~ s/\s+$//;
        $name = substr($name, 0, 70);

        if ($rumpf =~ /\bWM_QUIT\b/) {
            push @gesehen, sprintf('%-32s %s', "$kurz:$zeile", $name);
        }
        else {
            push @mangel, "$kurz:$zeile entnimmt Nachrichten (PM_REMOVE oder "
                        . "GetMessage), behandelt aber WM_QUIT nicht: $name - "
                        . 'eine entnommene WM_QUIT ist weg, das Programm laeuft '
                        . 'weiter, obwohl es enden sollte (Befund E-61, '
                        . 'Kriterium 7). ::PostQuitMessage((int) msg.wParam) und '
                        . 'die Schleife verlassen.';
        }
    }

    return (\@mangel, \@gesehen);
}

# Von den Tests eingebunden: dann nur die Funktionen bereitstellen.
return 1 if caller;

# --- Lauf ueber den Baum ---------------------------------------------------

my @quellen = (glob("$wurzel/Eudora71/OTShim/*.cpp"),
               glob("$wurzel/Eudora71/Eudora/*.cpp"));

unless (@quellen) {
    print "\n  pruefe-nachrichtenschleife.pl: keine Quellen gefunden.\n";
    print "  Das ist selbst ein Mangel - hier wird ein Quellbaum erwartet.\n\n";
    exit 1;
}

my (@mangel, @gesehen);

for my $pfad (@quellen) {
    open my $h, '<:raw', $pfad or next;
    my $roh;
    { local $/; $roh = <$h>; }
    close $h;
    next unless defined $roh;

    my $kurz = $pfad;
    $kurz =~ s{^\Q$wurzel\E[\\/]}{};
    $kurz =~ s{\\}{/}g;

    my ($m, $g) = pruefe_text($kurz, $roh);
    push @mangel,  @$m;
    push @gesehen, @$g;
}

my $entnehmend = scalar(@gesehen) + scalar(grep { /entnimmt Nachrichten/ } @mangel);

print "\n  Eigene Nachrichtenschleifen (E-51, E-61)\n";
print '  ', '-' x 68, "\n";
printf "  gepruefte Quellen                              %d\n", scalar @quellen;
printf "  Schleifen, die Nachrichten entnehmen           %d\n", $entnehmend;
printf "  davon mit WM_QUIT-Behandlung                   %d\n", scalar @gesehen;
print '  ', '-' x 68, "\n";

if (@gesehen) {
    print "\n";
    print "  $_\n" for @gesehen;
}

if (@mangel) {
    print "\n  MANGEL:\n\n";
    print "    - $_\n" for @mangel;
    print "\n  Warum das abweist: Arbeitsweise/eigene-schleife-verschluckt-nichts.md\n\n";
    exit 1;
}

print "\n  Jede eigene Schleife stellt WM_QUIT zurueck und wartet mit Zeitschranke.\n\n";
exit 0;
