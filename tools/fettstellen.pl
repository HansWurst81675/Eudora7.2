# fettstellen.pl - die fettgedruckten Stellen eines Urteils aus
# Intern/BEFUNDE.md, auch wenn darin etwas kursiv steht.
#
#   require "$FindBin::Bin/fettstellen.pl";
#   my @fett = fettstellen($urteil);      # ohne leere Stellen
#
#   perl tools/fettstellen.pl --selbsttest
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE DATEI GIBT
# ---------------------------------------------------------------------------
#
# Am 31.10.2026 fiel E-136 - offener Datenverlust - aus der Liste der
# offenen Befunde. Sein Urteil begann mit
#
#     **offen - ... beim Speichern *ohne* Kopfzeilen ...**
#
# und drei Werkzeuge (offene-befunde.pl, pruefe-befundurteile.pl,
# ziel-stand.pl) suchten das Fettgedruckte mit /\*\*([^*]+?)\*\*/. Das
# Muster darf keinen einzelnen Stern enthalten: der Kopf mit dem kursiven
# Wort passte nicht, das Werkzeug nahm die NAECHSTE fette Stelle als Kopf
# und las dort kein Offen-Wort. Gleicher Bau, harmlos, bei E-89, E-137,
# E-138, E-158. Die Berichtigung am Abend war, das Kursiv aus E-136 zu
# nehmen - das ist die Daten passend zum Werkzeug gemacht, nicht das
# Werkzeug berichtigt.
#
# Die Regel jetzt: eine Fettstelle reicht vom oeffnenden ** bis zum
# naechsten **, dem KEIN weiterer Stern folgt. Ein Kursiv darin, auch eines
# am Ende ("... *kursiv***"), bleibt Teil der Stelle.
#
# Eine Stelle fuer alle drei Werkzeuge - sie hatten dasselbe Muster dreimal
# von Hand, und es ist dreimal gleich falsch gewesen.

use strict;
use warnings;

sub fettstellen {
    my ($t) = @_;
    return () unless defined $t;
    # LEERE FETTSTELLEN WEGWERFEN (22.10.2026, LEKTOR): in "*** **" kann
    # sonst ein Leerzeichen als erste Fettstelle erscheinen (E-89).
    return grep { /\S/ } ($t =~ /\*\*(.+?)\*\*(?!\*)/g);
}

# --- Selbsttest -----------------------------------------------------------
# Nur, wenn die Datei selbst aufgerufen wird, nicht beim require.
if (!caller() and grep { $_ eq '--selbsttest' } @ARGV) {
    my @faelle = (
        # [Urteil, erwartete erste Fettstelle, Beschreibung]
        ['**offen - Text** dann **behoben**', 'offen - Text', 'ohne Kursiv'],
        ['**offen - beim *Speichern* zerstoert** **Zuletzt gemessen: x**',
         'offen - beim *Speichern* zerstoert', 'Kursiv mitten im Kopf (E-136, 31.10.2026)'],
        ['**offen - Ende *kursiv*** und **behoben**',
         'offen - Ende *kursiv*', 'Kursiv am Ende des Kopfs (***)'],
        ['**behoben - *„keine ueberlappung."*** **Die Ursache**',
         'behoben - *„keine ueberlappung."*', 'E-89: "*** **" gibt keine leere Stelle'],
        ['ohne Fett *kursiv*', undef, 'kein Fett, nur Kursiv'],
        ['Fliesstext **offen** mehr', 'offen', 'Fett nach Fliesstext'],
    );
    my $fehl = 0;
    for my $f (@faelle) {
        my ($t, $soll, $was) = @$f;
        my @ist = fettstellen($t);
        my $ist = $ist[0];
        my $ok = (!defined $soll && !defined $ist)
              || (defined $soll && defined $ist && $soll eq $ist);
        printf "  [%s] %s\n", $ok ? 'ok  ' : 'FEHL', $was;
        printf "         soll: %s\n         ist:  %s\n", $soll // '(nichts)', $ist // '(nichts)' unless $ok;
        $fehl++ unless $ok;
    }
    # GEGENPROBE: das alte Muster muss am E-136-Fall scheitern, sonst
    # beweist der Test nichts.
    my ($alt) = ('**offen - beim *Speichern* zerstoert** **Zuletzt gemessen: x**' =~ /\*\*([^*]+?)\*\*/g);
    my $gegen = defined $alt && $alt !~ /^offen/;
    printf "  [%s] Gegenprobe: altes Muster liest bei E-136 \"%s\"\n", $gegen ? 'ok  ' : 'FEHL', $alt // '';
    $fehl++ unless $gegen;
    printf "  fettstellen: %d Fehlschlag/Fehlschlaege\n", $fehl;
    exit($fehl ? 1 : 0);
}

1;
