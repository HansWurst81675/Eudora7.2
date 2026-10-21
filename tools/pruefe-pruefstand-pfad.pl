#!/usr/bin/perl
use strict;
use warnings;

# pruefe-pruefstand-pfad.pl - ist der Pruefstand bequemer gebaut als die
# Wirklichkeit?
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE PRUEFUNG GIBT
# ---------------------------------------------------------------------------
#
# E-132: Eudora soll fragen, bevor es das Mailverzeichnis einer FREMDEN
# Installation uebernimmt. Am 20.10.2026 abends wurde die Behebung auf allen
# drei Wegen (Ja / Nein / Abbrechen) am laufenden Programm gemessen - gruen.
#
# Am 21.10.2026 vormittags hat Gregor die Fassung zwei Minuten nach dem ersten
# Start widerlegt: sie fragt bei JEDEM Start, auch wenn das eigene
# Mailverzeichnis laengst angelegt ist.
#
# Die Ursache ist der Pruefstand, nicht der Code. GEMESSEN mit
# Win32::GetShortPathName:
#
#   Pruefstand      C:\Temp\E132          -> C:\Temp\E132          (gleich)
#   Wirklichkeit    C:\Users\Gregor\Eudora72-1.0.114-release
#                                         -> C:\Users\Gregor\EUDORA~1.114
#
# Die Registry liefert den Aufruf in der KURZFORM. Am Pruefstand ist die
# Kurzform mit der Langform identisch, der Vergleich "eigenes Verzeichnis?"
# geht auf, und die Messung meldet gruen. Beim Anwender sind es zwei
# verschiedene Zeichenketten, und Eudora haelt sein eigenes Verzeichnis fuer
# fremd. Im Protokoll von 1.0.114 steht es woertlich:
#
#   E-132 Startverzeichnis: gefunden="C:\Users\Gregor\EUDORA~1.114\MAILVE~1"
#         eigenes="C:\Users\Gregor\Eudora72-1.0.114-release\" fremd=1
#
# Ein Pruefstand, der bequemer gebaut ist als die Wirklichkeit, misst den
# Fehler weg (Arbeitsweise/pruefstand-nicht-bequemer-als-die-wirklichkeit.md).
#
# ---------------------------------------------------------------------------
# WAS GEPRUEFT WIRD
# ---------------------------------------------------------------------------
#
# Drei Eigenschaften, die der Pfad beim Anwender hat und ein bequemer
# Pruefpfad nicht:
#
#   1. 8.3-Alias     hat der Pfad eine von sich selbst verschiedene Kurzform?
#   2. Leerzeichen   enthaelt er eines? (Anfuehrungszeichen, Zerlegung von
#                    Befehlszeilen, GetDirs)
#   3. Benutzerprofil liegt er unter C:\Users\<Name>, nicht unter C:\Temp?
#
# Vorhandene Pfade werden mit Win32::GetShortPathName GEMESSEN; fuer noch
# nicht angelegte wird die Kurzform aus den Namensregeln abgeleitet
# (Stamm laenger als 8, Leerzeichen, mehr als ein Punkt, Endung laenger als 3).
#
# Aufruf:
#   perl tools/pruefe-pruefstand-pfad.pl <pruefpfad> [<pruefpfad> ...]
#   perl tools/pruefe-pruefstand-pfad.pl --selbsttest
#
# Rueckgabe 1, sobald ein Pfad eine der drei Eigenschaften nicht hat. Das ist
# kein Verbot - es ist die Aufforderung, den Unterschied zur Wirklichkeit
# entweder zu beseitigen oder ihn im Messprotokoll zu nennen.
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

# --- Kurzform aus den Namensregeln ableiten (fuer Pfade, die es nicht gibt) --
sub braucht_alias {
    my ($teil) = @_;
    return 1 if $teil =~ / /;
    my @punkte = ($teil =~ /[.]/g);
    return 1 if @punkte > 1;
    my ($stamm, $endung) = $teil =~ /^([^.]*)(?:[.](.*))?$/;
    $stamm = '' unless defined $stamm;
    $endung = '' unless defined $endung;
    return 1 if length($stamm) > 8;
    return 1 if length($endung) > 3;
    return 0;
}

sub hat_alias_abgeleitet {
    my ($pfad) = @_;
    for my $teil (split m{[\\/]}, $pfad) {
        next unless length $teil;
        next if $teil =~ /^[A-Za-z]:$/;
        return 1 if braucht_alias($teil);
    }
    return 0;
}

# Gibt (hat_alias, Kurzform oder undef, gemessen?) zurueck.
sub alias_pruefen {
    my ($pfad) = @_;
    if (-e $pfad) {
        my $kurz = eval { require Win32; Win32::GetShortPathName($pfad) };
        if (defined $kurz && length $kurz) {
            my ($a, $b) = ($kurz, $pfad);
            s{/}{\\}g for ($a, $b);
            return ((lc($a) ne lc($b)) ? 1 : 0, $kurz, 1);
        }
    }
    return (hat_alias_abgeleitet($pfad), undef, 0);
}

sub beurteile {
    my ($pfad) = @_;
    my ($alias, $kurz, $gemessen) = alias_pruefen($pfad);
    my %e = (
        alias      => $alias,
        leerstelle => ($pfad =~ / /) ? 1 : 0,
        profil     => ($pfad =~ m{^[A-Za-z]:[\\/]Users[\\/][^\\/]+[\\/]}i) ? 1 : 0,
    );
    return (\%e, $kurz, $gemessen);
}

# ---------------------------------------------------------------------------
sub selbsttest {
    my @faelle = (
        # Pfad, alias, leerstelle, profil
        [ 'C:\Temp\E132',                                    0, 0, 0 ],
        [ 'C:\Temp\E132\Mailverzeichnis',                    1, 0, 0 ],
        [ 'C:\Users\Gregor\Eudora72-1.0.114-release',        1, 0, 1 ],
        [ 'C:\Program Files\Eudora',                         1, 1, 0 ],
        [ 'C:\Users\Gregor\Eudora',                          0, 0, 1 ],
        [ 'D:\kurz\acht1234',                                0, 0, 0 ],
        [ 'D:\kurz\neun12345',                               1, 0, 0 ],
        [ 'C:\a b\c',                                        1, 1, 0 ],
    );
    my ($gut, $schlecht) = (0, 0);
    for my $f (@faelle) {
        my ($pfad, $sa, $sl, $sp) = @$f;
        # Im Selbsttest wird NUR die Ableitung geprueft, nie das Dateisystem -
        # sonst misst der Test die Maschine, auf der er laeuft.
        my %e = (
            alias      => hat_alias_abgeleitet($pfad),
            leerstelle => ($pfad =~ / /) ? 1 : 0,
            profil     => ($pfad =~ m{^[A-Za-z]:[\\/]Users[\\/][^\\/]+[\\/]}i) ? 1 : 0,
        );
        my @fehler;
        push @fehler, "alias $e{alias} statt $sa"           if $e{alias} != $sa;
        push @fehler, "leerstelle $e{leerstelle} statt $sl" if $e{leerstelle} != $sl;
        push @fehler, "profil $e{profil} statt $sp"         if $e{profil} != $sp;
        if (@fehler) { $schlecht++; print "  FEHLT: $pfad - ", join('; ', @fehler), "\n"; }
        else { $gut++; }
    }
    printf "  Selbsttest pruefe-pruefstand-pfad: %d von %d\n", $gut, $gut + $schlecht;
    return $schlecht ? 3 : 0;
}

# ---------------------------------------------------------------------------
if (@ARGV == 1 && $ARGV[0] eq '--selbsttest') { exit selbsttest(); }

unless (@ARGV) {
    print "Aufruf: perl tools/pruefe-pruefstand-pfad.pl <pruefpfad> [...]\n";
    print "        perl tools/pruefe-pruefstand-pfad.pl --selbsttest\n";
    exit 2;
}

my $mangel = 0;
for my $pfad (@ARGV) {
    my ($e, $kurz, $gemessen) = beurteile($pfad);
    my $herkunft = $gemessen ? 'gemessen' : 'abgeleitet';
    print "  $pfad   ($herkunft)\n";
    printf "      8.3-Alias      %s%s\n",
        ($e->{alias} ? 'ja' : 'NEIN - der Pfad ist sein eigener Kurzname'),
        (defined $kurz ? "   ($kurz)" : '');
    printf "      Leerzeichen    %s\n", ($e->{leerstelle} ? 'ja' : 'NEIN');
    printf "      Benutzerprofil %s\n", ($e->{profil} ? 'ja' : 'NEIN - liegt nicht unter C:\\Users\\<Name>');
    my $fehlt = 3 - ($e->{alias} + $e->{leerstelle} + $e->{profil});
    if ($fehlt) {
        $mangel++;
        print "      -> dieser Pfad deckt $fehlt von 3 Lagen NICHT ab, die beim\n";
        print "         Anwender vorkommen. Wer nur hier misst, misst sie weg.\n";
    }
}

print "\n  Nicht aus dem Pfad ablesbar, aber zu jeder Messung dazu:\n";
print "      * Start durch DOPPELKLICK (leere Befehlszeile), nicht ueber ein\n";
print "        Startskript mit Argument - das ist ein anderer Weg im Code.\n";
print "      * eine zweite, fremde Installation daneben, mit eigenem\n";
print "        Mailverzeichnis und eigener Eudora.ini.\n";
print "      * die Registry so, wie ein Setup sie hinterlaesst, nicht wie ich\n";
print "        sie geschrieben habe.\n";

if ($mangel) {
    print "\n  $mangel Pfad(e) decken nicht jede Lage ab. Entweder einen zweiten\n";
    print "  Pruefpfad dazunehmen, der die fehlende Lage hat, oder die Luecke\n";
    print "  in die Zeile \"Gemessen\" schreiben\n";
    print "  (Arbeitsweise/pruefstand-nicht-bequemer-als-die-wirklichkeit.md).\n";
    exit 1;
}
print "\n  Kein Pfad ist bequemer als die Wirklichkeit.\n";
exit 0;
