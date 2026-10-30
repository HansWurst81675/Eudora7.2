#!/usr/bin/perl
use strict;
use warnings;

# pruefe-nach-dem-release.pl - steht jede Aufgabe "nach dem Release" in der
# EINEN Liste von Intern/WEITERMACHEN.md?
#
#   perl tools/pruefe-nach-dem-release.pl                # Intern/WEITERMACHEN.md
#   perl tools/pruefe-nach-dem-release.pl <datei>        # eine andere Datei
#   perl tools/pruefe-nach-dem-release.pl --selbsttest   # beide Richtungen
#
# Rueckgabe: 0 = alles in der Liste, 1 = MANGEL, 2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE SCHRANKE GIBT
# ---------------------------------------------------------------------------
#
# Am 29.10.2026 standen die Aufgaben "nach dem Release 7.2.1" an drei Stellen
# in Intern/WEITERMACHEN.md (548 Zeilen) und eine davon nur im Gedaechtnis des
# Assistenten (CHRONIST-2026-10-29b, Nachtrag zu eine-stelle-dann-verlinken).
# Gregor dazu: "wichtig ist, dass es nicht wieder ueberall etwas verstreut ist".
# Vereinbart wurde: eine Liste "Nach dem Release 7.2.1" mit dem Anker
# #nach-dem-release, alles andere nur als Verweis darauf - und eine Schranke
# im Commit-Haken (Arbeitsweise/schranke-gehoert-in-den-haken.md).
#
# DIE REGEL
#
# Ausserhalb des Abschnitts mit dem Anker nach-dem-release darf ein Absatz
# (oder eine Tabellenzeile) "nach dem Release" oder "nach 7.2.1" nur nennen,
# wenn er auf die Liste verweist: "#nach-dem-release)" am Ende eines Links.
# Zitate in deutschen Anfuehrungszeichen und Codespannen zaehlen nicht - ein
# Zitat Gregors ist Geschichte, keine Aufgabe. "nach 7.2.1.128" (eine
# Fassung) zaehlt ebenfalls nicht. In Intern/WEITERMACHEN.md muss der
# Abschnitt selbst stehen; Intern/AUFGABEN.md (seit dem 30.10.2026 nur zum
# Nachschlagen) darf nur verweisen.
#
# BEKANNTE GRENZEN (LEKTOR-100, L-100.9)
#
# * Ein Absatz mit Link auf die Liste geht durch, auch wenn die Aufgabe dort
#   gar nicht steht. Ob sie dort steht, prueft das Werkzeug nicht.
# * Andere Wendungen ("spaeter", "beim naechsten Mal") faengt es nicht.
# * Geprueft werden nur WEITERMACHEN.md und AUFGABEN.md.

my $ANKER = 'nach-dem-release';

my @dateien;
for my $a (@ARGV) {
    if    ($a eq '--selbsttest') { exit selbsttest() }
    elsif ($a =~ /^-/)           { print "  pruefe-nach-dem-release: unbekannt: $a\n"; exit 2 }
    else                         { push @dateien, $a }
}
unless (@dateien) {
    my $wurzel = -f 'VERSION' ? '.' : '..';
    @dateien = ("$wurzel/Intern/WEITERMACHEN.md", "$wurzel/Intern/AUFGABEN.md");
}

my @mangel;
for my $d (@dateien) {
    open my $h, '<:encoding(UTF-8)', $d or do { print "  pruefe-nach-dem-release: $d nicht lesbar\n"; exit 2 };
    my $t = do { local $/; <$h> };
    close $h;
    # Nur WEITERMACHEN.md muss die Liste selbst tragen.
    my $pflicht = $d =~ m{(?:^|[\\/])WEITERMACHEN\.md\z} ? 1 : 0;
    push @mangel, map { "$d:$_" } pruefe_text($t, $pflicht);
}

if (@mangel) {
    binmode STDOUT, ':encoding(UTF-8)';
    print "  ------------------------------------------------------------\n";
    print "  pruefe-nach-dem-release: AUFGABE AUSSERHALB DER LISTE\n";
    print "  ------------------------------------------------------------\n";
    print "    $_\n" for @mangel;
    print "\n  Aufgaben nach dem Release gehoeren in die Liste unter\n";
    print "  #$ANKER (Intern/WEITERMACHEN.md); anderswo nur ein Verweis\n";
    print "  dorthin: [Nach dem Release 7.2.1](#$ANKER).\n";
    exit 1;
}
exit 0;

# Gibt die Maengel als "Zeile: Anfang des Absatzes" zurueck.
sub pruefe_text {
    my ($t, $pflicht) = @_;
    $pflicht = 1 unless defined $pflicht;
    my @z = split /\n/, $t, -1;
    my (@maengel, @einheit);
    my ($innen, $gesehen, $code, $start) = (0, 0, 0, 0);

    my $abschliessen = sub {
        return unless @einheit;
        my $text = join "\n", @einheit;
        @einheit = ();
        return if $innen;
        my $ohne = $text;
        $ohne =~ s/\x{201E}[^\x{201C}]*\x{201C}//g;
        $ohne =~ s/`[^`]*`//g;
        return unless $ohne =~ /nach\s+(?:dem\s+Release|v?7\.2\.1(?![.\d]\d))/i;
        return if $text =~ /#\Q$ANKER\E\)/;
        (my $kurz = $text) =~ s/\s+/ /g;
        push @maengel, sprintf "%d: %s", $start, substr($kurz, 0, 90);
    };

    for my $i (0 .. $#z) {
        my $l = $z[$i];
        if ($l =~ /^\s*```/) { $abschliessen->(); $code = !$code; next }
        next if $code;
        if ($l =~ /^##\s/ && $l !~ /^###/) {
            $abschliessen->();
            if ($l =~ /id="\Q$ANKER\E"/) { $innen = 1; $gesehen = 1 }
            else                         { $innen = 0 }
            next;
        }
        if ($l =~ /^\s*$/) { $abschliessen->(); next }
        # Jede Tabellenzeile ist eine eigene Einheit.
        if ($l =~ /^\|/) { $abschliessen->(); $start = $i + 1; @einheit = ($l); $abschliessen->(); next }
        $start = $i + 1 unless @einheit;
        push @einheit, $l;
    }
    $abschliessen->();
    unshift @maengel, "0: der Abschnitt mit dem Anker $ANKER fehlt" if $pflicht and !$gesehen;
    return @maengel;
}

sub selbsttest {
    my $kopf  = "# T\n\nSiehe [Liste](#nach-dem-release).\n\n";
    my $liste = "## <a id=\"nach-dem-release\"></a>Nach dem Release 7.2.1\n\n| Was | Warum |\n|---|---|\n| E-170 erst nach dem Release | Gregor |\n\n### Offene Befunde\n\nerst nach dem Release messen\n\n";
    my @faelle = (
        # [Name, Text, erwartete Maengelzahl]
        ['Liste allein',                       $kopf . $liste,                                   0],
        ['Aufgabe nach der Liste',             $kopf . $liste . "## Mehr\n\nDas machen wir nach dem Release.\n", 1],
        ['Aufgabe vor der Liste',              "# T\n\nNach dem Release noch X bauen.\n\n" . $liste, 1],
        ['ueber zwei Zeilen',                  $kopf . $liste . "## Mehr\n\nDas machen wir nach dem\nRelease.\n", 1],
        ['Tabellenzeile ausserhalb',           $kopf . $liste . "## Mehr\n\n| a | nach dem Release |\n", 1],
        ['mit Verweis erlaubt',                $kopf . $liste . "## Mehr\n\nX kommt nach dem Release, siehe [Liste](#nach-dem-release).\n", 0],
        ['Zitat Gregors erlaubt',              $kopf . $liste . "## Mehr\n\nGregor: *\x{201E}erst nach dem release\x{201C}*.\n", 0],
        ['Zitat mit Aufgabe daneben',          $kopf . $liste . "## Mehr\n\nGregor: *\x{201E}ok\x{201C}*, also nach dem Release.\n", 1],
        ['Codespanne erlaubt',                 $kopf . $liste . "## Mehr\n\n`nach dem Release`\n", 0],
        ['Codeblock erlaubt',                  $kopf . $liste . "## Mehr\n\n```\nnach dem Release\n```\n", 0],
        ['Unterabschnitt bleibt innen',        $kopf . $liste,                                   0],
        ['Liste fehlt',                        "# T\n\nnichts\n",                                1],
        ['Liste fehlt, Aufgabe da',            "# T\n\nnach dem Release X\n",                    2],
        # Seit LEKTOR-100 (L-100.9): die zweite Wendung und Verweise aus AUFGABEN.md
        ['nach 7.2.1 ausserhalb',              $kopf . $liste . "## Mehr\n\nDas machen wir erst nach 7.2.1.\n", 1],
        ['nach 7.2.1.128 ist eine Fassung',    $kopf . $liste . "## Mehr\n\nGeaendert nach 7.2.1.128.\n", 0],
        ['AUFGABEN: ohne Liste, mit Verweis',  "# A\n\nX nach 7.2.1, siehe [L](WEITERMACHEN.md#nach-dem-release).\n", 0, 0],
        ['AUFGABEN: ohne Liste, ohne Verweis', "# A\n\nX machen wir nach dem Release.\n",   1, 0],
        ['AUFGABEN: ohne Liste, nichts dazu',  "# A\n\nnichts\n",                           0, 0],
    );
    my $fehler = 0;
    binmode STDOUT, ':encoding(UTF-8)';
    for my $f (@faelle) {
        my $n = () = pruefe_text($f->[1], $f->[3]);
        my $ok = $n == $f->[2];
        $fehler++ unless $ok;
        printf "  %-4s %-32s %d Maengel (erwartet %d)\n", $ok ? 'ok' : 'FEHL', $f->[0], $n, $f->[2];
    }
    printf "  pruefe-nach-dem-release --selbsttest: %d von %d Faellen richtig\n", @faelle - $fehler, scalar @faelle;
    return $fehler ? 1 : 0;
}
