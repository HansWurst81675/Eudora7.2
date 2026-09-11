#!/usr/bin/perl
use strict;
use warnings;

# pruefe-doku-takt.pl - kein Paket ohne beschriebene Fassung.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 11.09.2026, nachdem Release v1.0.47 gebaut, gemergt und
# veroeffentlicht war und er DANACH nach dem Lektor fragen musste:
#
#   "nein, lektor sollte vor dem commit und merge fertig sein, nicht
#    hinterher laufen - vor allem nicht auf meine nachfrage!"
#
# und kurz darauf:
#
#   "jedes mal das gleiche chaos bei dir."
#
# Er hat recht, und die Ursache ist keine Nachlaessigkeit im Einzelfall,
# sondern ein fehlender AUSLOESER. Lektor, Pruefer und Chronist liefen bisher,
# weil Gregor fragte. Eine Rolle, die auf Nachfrage anlaeuft, ist nicht
# eingerichtet - das steht seit Tagen in
# Arbeitsweise/daueraufgaben-brauchen-einen-takt.md und hat trotzdem nicht
# gewirkt, weil die Lehre nur Text war.
#
# Dieses Werkzeug ist der Moment, in dem die Lehre geprueft wird. Es haengt
# in paket-bauen.ps1, an derselben Stelle wie spuren-auswerten.pl - die
# Schranke, die HEUTE zweimal gegriffen und mich zweimal zurueckgeschickt hat.
# Das ist der Beleg, dass diese Bauart wirkt und eine Lehre allein nicht.
#
# ---------------------------------------------------------------------------
# WAS ES PRUEFT
# ---------------------------------------------------------------------------
#
# 1. CHANGELOG.md hat einen Abschnitt fuer den Quellstand aus
#    Eudora71/Version.h. Wer eine Fassung baut, die niemand beschrieben hat,
#    liefert eine Blackbox aus.
#
# 2. Der Abschnitt "## Noch offen (Stand TT.MM.JJJJ)" ist nicht aelter als
#    der juengste CHANGELOG-Abschnitt. Ein veralteter "Noch offen"-Abschnitt
#    ist die gefaehrlichste Sorte Doku, weil er behauptet, vollstaendig zu
#    sein. Genau daran ist Gregor haengengeblieben: "Noch offen (Stand
#    10.09.2026) / changelog / ???"
#
# 3. VERSION und Eudora71/Version.h nennen dieselbe Nummer. Am 11.09.2026
#    standen EUDORA_BUILD_* auf 7.2.0.47 und EUDORA_VERSION1..4 noch auf
#    7.2.0.44 - die vier Makros gehen in die Ressourcen der EXE, das Paket
#    haette in einem Feld eine andere Nummer getragen als im anderen.
#
# Was es NICHT prueft: ob der Inhalt des Abschnitts stimmt. Das kann kein
# Skript. Es prueft nur, dass jemand ueberhaupt hingesehen hat.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-doku-takt.pl            aus dem Wurzelverzeichnis
#   perl tools/pruefe-doku-takt.pl -leise     nur im Fehlerfall etwas sagen
#
# Rueckgabe: 0 = in Ordnung, 1 = Mangel, 2 = Aufrufproblem.

my $leise = grep { $_ eq '-leise' } @ARGV;

# --- Wurzel finden ---------------------------------------------------------
my $wurzel = '.';
$wurzel = '..' unless -f "$wurzel/VERSION";
unless (-f "$wurzel/VERSION" and -f "$wurzel/CHANGELOG.md") {
    print "  pruefe-doku-takt: VERSION oder CHANGELOG.md nicht gefunden -\n";
    print "  bitte aus dem Wurzelverzeichnis aufrufen.\n";
    exit 2;
}

sub lies {
    my ($d) = @_;
    open my $h, '<:raw', $d or return undef;
    local $/;
    my $t = <$h>;
    close $h;
    return $t;
}

my @mangel;
my @gut;

# --- 1. Quellstand aus Version.h -------------------------------------------
my $vh = lies("$wurzel/Eudora71/Version.h");
unless (defined $vh) {
    print "  pruefe-doku-takt: Eudora71/Version.h nicht lesbar.\n";
    exit 2;
}

my ($quellstand) = $vh =~ /EUDORA_BUILD_VERSION\s+"([0-9.]+)"/;
unless ($quellstand) {
    push @mangel, 'Eudora71/Version.h: EUDORA_BUILD_VERSION nicht gefunden';
    $quellstand = '';
}

# --- 3. (zuerst, weil billig) Version.h in sich stimmig ---------------------
if ($quellstand) {
    my ($v1) = $vh =~ /EUDORA_VERSION1\s+(\d+)/;
    my ($v2) = $vh =~ /EUDORA_VERSION2\s+(\d+)/;
    my ($v3) = $vh =~ /EUDORA_VERSION3\s+(\d+)/;
    my ($v4) = $vh =~ /EUDORA_VERSION4\s+(\d+)/;
    if (defined $v1 and defined $v2 and defined $v3 and defined $v4) {
        my $aus_makros = "$v1.$v2.$v3.$v4";
        if ($aus_makros ne $quellstand) {
            push @mangel,
              "Eudora71/Version.h widerspricht sich: EUDORA_VERSION1..4 sagt "
            . "$aus_makros, EUDORA_BUILD_VERSION sagt $quellstand. Die vier "
            . "Makros gehen in die Ressourcen der EXE - das Paket traegt sonst "
            . "in einem Feld eine andere Nummer als im anderen";
        } else {
            push @gut, "Version.h ist in sich stimmig ($quellstand)";
        }
    }

    my $version = lies("$wurzel/VERSION");
    if (defined $version) {
        $version =~ s/\s+$//;
        my ($paket_nr) = $version =~ /(\d+)$/;
        my ($quell_nr) = $quellstand =~ /(\d+)$/;
        if (defined $paket_nr and defined $quell_nr and $paket_nr != $quell_nr) {
            push @mangel,
              "VERSION sagt Paket $version, Version.h sagt Quellstand "
            . "$quellstand - die letzte Stelle muss uebereinstimmen";
        } else {
            push @gut, "VERSION ($version) passt zum Quellstand";
        }
    }
}

# --- 2. CHANGELOG-Abschnitt fuer diesen Quellstand --------------------------
my $cl = lies("$wurzel/CHANGELOG.md");
unless (defined $cl) {
    print "  pruefe-doku-takt: CHANGELOG.md nicht lesbar.\n";
    exit 2;
}

if ($quellstand) {
    if ($cl =~ /^##\s+\Q$quellstand\E(\s|$|\s*[^\d])/m) {
        push @gut, "CHANGELOG.md hat einen Abschnitt fuer $quellstand";
    } else {
        push @mangel,
          "CHANGELOG.md hat keinen Abschnitt '## $quellstand'. Wer eine "
        . "Fassung baut, die niemand beschrieben hat, liefert eine Blackbox "
        . "aus - und der Lektor laeuft dann erst, wenn Gregor fragt";
    }
}

# --- 4. "Noch offen" nicht aelter als der juengste Abschnitt ----------------
my ($offen_tag, $offen_monat, $offen_jahr) =
    $cl =~ /^##\s+Noch offen\s*\(Stand\s+(\d{2})\.(\d{2})\.(\d{4})\)/m;

if (defined $offen_jahr) {
    # Das juengste Datum, das irgendein anderer Abschnitt nennt. Die
    # Abschnitte selbst tragen keine Daten, wohl aber ihre Texte - deshalb
    # wird das juengste Datum im GANZEN CHANGELOG gesucht und dagegen
    # verglichen. Das ist absichtlich grob: es soll nur auffallen, wenn der
    # Abschnitt einen ganzen Arbeitstag hinterherhinkt.
    my $offen = sprintf('%04d%02d%02d', $offen_jahr, $offen_monat, $offen_tag);
    my $juengstes = '';
    while ($cl =~ /(\d{2})\.(\d{2})\.(\d{4})/g) {
        my $d = sprintf('%04d%02d%02d', $3, $2, $1);
        $juengstes = $d if $d gt $juengstes;
    }
    if ($juengstes gt $offen) {
        my ($jj, $jm, $jt) = $juengstes =~ /^(\d{4})(\d{2})(\d{2})$/;
        push @mangel,
          "'## Noch offen (Stand $offen_tag.$offen_monat.$offen_jahr)' ist "
        . "aelter als der juengste Vorgang im CHANGELOG ($jt.$jm.$jj). Ein "
        . "veralteter 'Noch offen'-Abschnitt ist die gefaehrlichste Sorte "
        . "Doku, weil er behauptet, vollstaendig zu sein";
    } else {
        push @gut, "'Noch offen' ist auf dem Stand $offen_tag.$offen_monat.$offen_jahr";
    }
} else {
    push @mangel, "CHANGELOG.md hat keinen Abschnitt '## Noch offen (Stand TT.MM.JJJJ)'";
}

# --- Ausgabe ---------------------------------------------------------------
unless ($leise and not @mangel) {
    print "\n  ------------------------------------------------------------\n";
    print "  pruefe-doku-takt\n";
    print "  ------------------------------------------------------------\n";
    print "    $_\n" for @gut;
}

if (@mangel) {
    print "\n  MANGEL:\n\n";
    print "    - $_\n\n" for @mangel;
    print <<'ENDE';
  Eine Fassung, die niemand beschrieben hat, ist keine Fassung,
  sondern eine Blackbox. Gregor am 11.09.2026, nachdem er nach
  dem Lektor fragen musste: "nein, lektor sollte vor dem commit
  und merge fertig sein, nicht hinterher laufen - vor allem
  nicht auf meine nachfrage!"

  Also: CHANGELOG-Abschnitt fuer diese Fassung schreiben und
  den "Noch offen"-Abschnitt nachziehen - VOR dem Paket.

ENDE
    exit 1;
}

print "\n  Die Fassung ist beschrieben.\n\n" unless $leise;
exit 0;
