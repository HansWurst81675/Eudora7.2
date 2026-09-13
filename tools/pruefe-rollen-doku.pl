#!/usr/bin/perl
use strict;
use warnings;

# pruefe-rollen-doku.pl - jede Rolle, die eine Schranke kennt, muss in
# AGENTEN.md nachschlagbar sein.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 13.09.2026 um 19:33:42:
#
#   "lass mal waehrend dessen den lektor ueber unser chat laufen, er soll mal
#    lessons leared aktualisieren."
#
# Ich habe LEKTOR beauftragt. 59 Sekunden spaeter bemerkte er es selbst:
#
#   "halt: das war der chronist, ja?"
#
# Beim Nachmessen am 13.09.2026 stellte sich heraus: AGENTEN.md - die Datei,
# die die Rollen beschreibt - enthaelt das Wort CHRONIST KEIN EINZIGES MAL.
# Sie stammt vom 07.09.2026 und kennt die Rolle nicht. Die einzige Stelle, an
# der CHRONIST definiert ist ("die Lehren aus dem Verlauf", Auftrag: "Den Chat
# seit dem letzten Lauf auswerten"), steht im QUELLTEXT von
# tools/rollen-faellig.pl.
#
# Weder Gregor noch ich konnten die Zuordnung also nachschlagen. Das ist keine
# Unaufmerksamkeit, sondern eine fehlende Quelle - und deshalb ist die Abhilfe
# eine Schranke und keine Ermahnung.
#
# ---------------------------------------------------------------------------
# WAS GEPRUEFT WIRD
# ---------------------------------------------------------------------------
#
# Die Rollenliste wird AUS tools/rollen-faellig.pl gelesen, nicht danebengelegt
# (Arbeitsweise/pruefumfang-nicht-von-hand.md). Fuer jede dort definierte Rolle
# muss AGENTEN.md
#   - den Namen nennen und
#   - den Zustaendigkeitssatz ("was") nennen,
# damit die Zuordnung nachschlagbar ist und nicht nur im Code steht.
#
# Aufruf:
#   perl tools/pruefe-rollen-doku.pl
#   perl tools/pruefe-rollen-doku.pl --selbsttest
#
# Rueckgabe: 0 = jede Rolle ist nachschlagbar, 1 = mindestens eine fehlt.

my $selbsttest = grep { $_ eq '--selbsttest' } @ARGV;

my $trenner = chr(92);
my $wurzel = `git rev-parse --show-toplevel 2>/dev/null`;
$wurzel = "" unless defined $wurzel;
$wurzel =~ s/\s+\z//;
$wurzel =~ s/\Q$trenner\E/\//g;
unless (length $wurzel) {
    print "  pruefe-rollen-doku: keine Repo-Wurzel - uebersprungen.\n";
    exit 0;
}

sub lies {
    my $p = shift;
    open(my $h, "<:raw", $p) or return undef;
    local $/;
    my $d = <$h>;
    close $h;
    return $d;
}

# --- Rollen aus der Schranke holen ------------------------------------------
sub rollen_aus {
    my $quelle = shift;
    my @r;
    # name => 'LEKTOR', ... was => 'die Dokumentation gegen den Bestand',
    while ($quelle =~ /name\s*=>\s*'([A-Z]+)'\s*,\s*was\s*=>\s*'([^']*)'/g) {
        push @r, { name => $1, was => $2 };
    }
    return @r;
}

# --- Urteil ------------------------------------------------------------------
sub fehlende {
    my ($doku, @rollen) = @_;
    my @fehlt;
    for my $r (@rollen) {
        my $hat_namen = ($doku =~ /\b\Q$r->{name}\E\b/) ? 1 : 0;
        my $hat_was   = (index($doku, $r->{was}) >= 0) ? 1 : 0;
        next if $hat_namen && $hat_was;
        push @fehlt, {
            name => $r->{name},
            was  => $r->{was},
            grund => (!$hat_namen ? "Name kommt in AGENTEN.md nicht vor"
                                  : "Zustaendigkeit fehlt: '$r->{was}'"),
        };
    }
    return @fehlt;
}

if ($selbsttest) {
    my @rollen = (
        { name => 'LEKTOR',   was => 'die Dokumentation gegen den Bestand' },
        { name => 'CHRONIST', was => 'die Lehren aus dem Verlauf' },
    );
    my @faelle = (
        [ "LEKTOR prueft die Dokumentation gegen den Bestand. CHRONIST holt die Lehren aus dem Verlauf.",
          0, "beide Rollen vollstaendig beschrieben" ],
        [ "LEKTOR prueft die Dokumentation gegen den Bestand.",
          1, "CHRONIST fehlt ganz - der echte Zustand vom 13.09.2026" ],
        [ "LEKTOR prueft die Dokumentation gegen den Bestand. CHRONIST macht irgendwas.",
          1, "CHRONIST genannt, aber ohne Zustaendigkeit" ],
        [ "Hier steht nichts ueber Rollen.",
          2, "beide fehlen" ],
    );
    my $fehler = 0;
    print "\n  pruefe-rollen-doku --selbsttest\n  " . ("-" x 66) . "\n";
    for my $f (@faelle) {
        my ($doku, $erwartet, $was) = @$f;
        my @fehlt = fehlende($doku, @rollen);
        my $ok = (scalar(@fehlt) == $erwartet);
        $fehler++ unless $ok;
        printf "  [%s] %-52s fehlend=%d\n", ($ok ? "ok  " : "FEHL"), $was, scalar(@fehlt);
    }
    print "  " . ("-" x 66) . "\n";
    if ($fehler) { print "  $fehler Faelle falsch beurteilt.\n\n"; exit 1; }
    print "  Alle " . scalar(@faelle) . " Faelle richtig beurteilt.\n\n";
    exit 0;
}

my $quelle = lies("$wurzel/tools/rollen-faellig.pl");
unless (defined $quelle) {
    print "  pruefe-rollen-doku: tools/rollen-faellig.pl gibt es hier nicht - uebersprungen.\n";
    exit 0;
}
my $doku = lies("$wurzel/AGENTEN.md");
unless (defined $doku) {
    print "  pruefe-rollen-doku: AGENTEN.md gibt es hier nicht - uebersprungen.\n";
    exit 0;
}

my @rollen = rollen_aus($quelle);
unless (@rollen) {
    print "  pruefe-rollen-doku: keine Rolle in rollen-faellig.pl gefunden -\n";
    print "  die Ausleseform passt nicht mehr. Das ist ein Mangel, kein Freibrief.\n";
    exit 1;
}

my @fehlt = fehlende($doku, @rollen);

unless (@fehlt) {
    printf "  Rollen: alle %d in AGENTEN.md nachschlagbar (%s).\n",
           scalar(@rollen), join(", ", map { $_->{name} } @rollen);
    exit 0;
}

print "\n";
print "  ABBRUCH: " . scalar(@fehlt) . " von " . scalar(@rollen)
    . " Rollen sind in AGENTEN.md nicht nachschlagbar:\n\n";
for my $f (@fehlt) {
    print "  * $f->{name}: $f->{grund}\n";
}
print "\n";
print "  Eine Rolle, die nur im Quelltext einer Schranke definiert ist, kann\n";
print "  niemand nachschlagen - auch Gregor nicht. Am 13.09.2026 hat er\n";
print "  deshalb \"den lektor\" beauftragt, wo CHRONIST zustaendig war, und\n";
print "  musste es 59 Sekunden spaeter selbst berichtigen:\n";
print "  \"halt: das war der chronist, ja?\"\n";
print "\n";
print "  Abhilfe: die Rolle mit Namen UND Zustaendigkeitssatz in AGENTEN.md\n";
print "  eintragen. Die Saetze stehen in tools/rollen-faellig.pl.\n";
print "\n";
exit 1;
