#!/usr/bin/perl
use strict;
use warnings;

# spur-lesen.pl - ein leeres Protokoll ist kein Messergebnis.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 20.10.2026 abends wurde E-132 nachgestellt: Eudora soll fragen, bevor es
# das Mailverzeichnis einer fremden Installation uebernimmt. Die Rueckfrage
# war eingebaut, die Spurmarke war eingebaut - im Protokoll stand nichts.
#
# Die erste Deutung war "die Stelle wird nicht erreicht". Sie war falsch, und
# zwar zweimal hintereinander:
#
#   1. Die Registry liefert nicht ein Verzeichnis, sondern den ganzen Aufruf.
#      Nach dem Abschneiden des Programmnamens standen ZWEI Pfade in einer
#      Zeichenkette. Die Entscheidung lief, nur gegen den falschen Wert.
#   2. Nach der Behebung blieb es stumm. Ursache gemessen:
#      StartEudoraWithDefaultLocation laeuft, BEVOR QCLogFileMT::InitDebug das
#      Protokoll oeffnet - und das muss so sein, denn das Protokoll liegt in
#      dem Mailverzeichnis, das dort erst gesucht wird. PutDebugLog kehrt ohne
#      s_pLogFile stumm zurueck (QCUtils/src/debug.cpp:141).
#
# Beide Male sah das Protokoll gleich aus: leer. "Marke fehlt" und "Kanal ist
# zu" sind aber verschiedene Befunde, und nur der erste ist ueberhaupt ein
# Messergebnis. Dieses Werkzeug trennt sie, damit die Unterscheidung nicht von
# meiner Tagesform abhaengt.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/spur-lesen.pl <protokoll> <marke>      z.B. ... eudora.log E-132
#   perl tools/spur-lesen.pl --selbsttest
#
# Rueckgabe:
#   0  die Marke steht im Protokoll            -> Messergebnis: erreicht
#   1  die Marke fehlt, ANDERE Marken stehen drin, also ist der Kanal offen
#                                              -> Messergebnis: nicht erreicht
#   2  kein Protokoll, leeres Protokoll, keine einzige Marke, oder LogLevel
#      ohne 32768                              -> KEIN Messergebnis
#
# Der Unterschied zwischen 1 und 2 ist der ganze Zweck. Wer 2 als "nicht
# erreicht" liest, sucht den Fehler an der falschen Stelle - am 20.10.2026
# hat genau das zwei Anlaeufe gekostet.
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

my $MARKE = qr/\b([EZXPRNV]|NP|PR)-\d+[a-z]?\b/;

sub lies {
    my ($p) = @_;
    open my $h, '<:raw', $p or return undef;
    local $/;
    my $d = <$h>;
    close $h;
    return $d;
}

# Gibt zurueck: (Urteil, Text). Urteil ist 0, 1 oder 2 wie oben.
sub beurteile {
    my ($inhalt, $marke, $pfad) = @_;
    $pfad = defined $pfad ? $pfad : '(Text)';

    return (2, "KEIN MESSERGEBNIS: $pfad gibt es nicht oder es ist nicht lesbar.")
        unless defined $inhalt;
    return (2, "KEIN MESSERGEBNIS: $pfad ist leer - das Protokoll wurde nie geschrieben.")
        unless $inhalt =~ /\S/;

    # LogLevel steht im Protokollkopf und im Ueber-Dialog. Ohne Bit 32768
    # schreibt keine einzige E-nn-Marke, egal was im Quelltext steht.
    if ($inhalt =~ /LogLevel[^0-9]{0,12}(\d+)/i) {
        my $stufe = $1;
        unless ($stufe & 32768) {
            return (2, "KEIN MESSERGEBNIS: LogLevel=$stufe, Bit 32768 fehlt - "
                     . "in diesem Lauf kann keine Marke entstehen.");
        }
    }

    my $treffer = 0;
    my @zeilen;
    for my $z (split /\r?\n/, $inhalt) {
        next unless index($z, $marke) >= 0;
        $treffer++;
        push @zeilen, $z if @zeilen < 5;
    }
    if ($treffer) {
        my $t = "GEFUNDEN: $marke steht $treffer mal in $pfad.";
        $t .= "\n    $_" for @zeilen;
        return (0, $t);
    }

    my %andere;
    while ($inhalt =~ /$MARKE/g) {
        my $k = $&;
        $andere{$k}++ unless $k eq $marke;
    }
    if (%andere) {
        my $liste = join(', ', map { "$_ ($andere{$_})" } sort keys %andere);
        return (1, "MARKE FEHLT: $marke steht nicht in $pfad, aber der Kanal "
                 . "ist offen - andere Marken sind da: $liste.\n"
                 . "    Das ist ein Messergebnis: die Stelle wurde nicht erreicht.");
    }

    return (2, "KEIN MESSERGEBNIS: in $pfad steht keine einzige Marke. "
             . "Stummer Kanal - erst den Weg der Ausgabe pruefen (LogLevel, "
             . "Zeitpunkt gegenueber InitDebug), dann wieder messen.");
}

# ---------------------------------------------------------------------------
# Selbsttest - beide Richtungen, nicht nur die gewuenschte
# (Arbeitsweise/schranke-gegentesten.md).
# ---------------------------------------------------------------------------
sub selbsttest {
    my @faelle = (
        [ "Marke da",
          "irgendwas\nE-132 fremd=1 ini=C:/Temp/E131/Eudora.ini\nende\n",
          'E-132', 0 ],
        [ "Marke fehlt, Kanal offen",
          "E-131 Leiste gelesen\nE-69 Filter\n", 'E-132', 1 ],
        [ "stummer Kanal - gar keine Marke",
          "Eudora gestartet\nMailverzeichnis gesucht\n", 'E-132', 2 ],
        [ "leeres Protokoll",            "", 'E-132', 2 ],
        [ "Protokoll fehlt",             undef, 'E-132', 2 ],
        [ "LogLevel ohne 32768",
          "LogLevel=7\nE-131 etwas\n", 'E-132', 2 ],
        [ "LogLevel mit 32768, Marke da",
          "LogLevel=32775\nE-132 fremd=0\n", 'E-132', 0 ],
        [ "LogLevel mit 32768, Marke fehlt, andere da",
          "LogLevel=32768\nE-131 etwas\n", 'E-132', 1 ],
    );
    my ($gut, $schlecht) = (0, 0);
    for my $f (@faelle) {
        my ($name, $inhalt, $marke, $soll) = @$f;
        my ($ist, $text) = beurteile($inhalt, $marke, '(Selbsttest)');
        if ($ist == $soll) { $gut++; }
        else {
            $schlecht++;
            print "  FEHLT: $name - erwartet $soll, bekommen $ist\n    $text\n";
        }
    }
    printf "  Selbsttest spur-lesen: %d von %d\n", $gut, $gut + $schlecht;
    return $schlecht ? 3 : 0;
}

# ---------------------------------------------------------------------------
if (@ARGV == 1 && $ARGV[0] eq '--selbsttest') { exit selbsttest(); }

unless (@ARGV == 2) {
    print "Aufruf: perl tools/spur-lesen.pl <protokoll> <marke>\n";
    print "        perl tools/spur-lesen.pl --selbsttest\n";
    exit 2;
}
my ($pfad, $marke) = @ARGV;
my ($urteil, $text) = beurteile(lies($pfad), $marke, $pfad);
print "  $text\n";
exit $urteil;
