#!/usr/bin/perl
# haken-pr-lektor.pl - PreToolUse-Haken von Claude Code (.claude/settings.json):
# kein "gh pr create", solange der LEKTOR faellig ist.
#
# WARUM ES DAS GIBT. Die Regel steht seit dem 06.09.2026 in der Lehre
# Arbeitsweise/daueraufgaben-brauchen-einen-takt.md: "LEKTOR vor jedem Push
# eines Zweigs, den Gregor mergen soll". Am 24./25.10.2026 gingen trotzdem die
# PRs #170, #171 und #172 ohne LEKTOR-Lauf hinaus, und auf Gregors Frage habe
# ich die Regel als neuen Vorschlag angeboten. Gregor: "was hilft mir, dass du
# den fehler bestaetigst, wenn du ihn jedes mal erneut wiederholst?" - eine
# Lehre ohne Ausloeser wirkt nicht (Arbeitsweise/schranke-gehoert-in-den-haken.md).
# Der Paketbau prueft die Rollen schon (paket-bauen.ps1); das Anlegen eines PRs,
# also der Moment, in dem Gregor mergen soll, tat es nicht.
#
# WIE. Liest den Werkzeugaufruf als JSON von stdin. Nur ein Kommando, das
# "gh pr create" AUSFUEHRT, wird geprueft: tools/rollen-faellig.pl --nur-melden,
# und steht dort "LEKTOR ist faellig", Rueckgabe 2 mit Begruendung auf stderr -
# Claude Code blockiert den Aufruf dann und zeigt die Begruendung.
#
# Ausweg: den LEKTOR ueber den Zweig laufen lassen und seinen Bericht in den
# Zweig holen. Danach ist er nicht mehr faellig.
#
# Gegenprobe: perl tools/haken-pr-lektor.pl --selbsttest (13 Faelle, beide Richtungen).
#
# Kodierung: reines ASCII.
use strict;
use warnings;
use JSON::PP;
use FindBin;

selbsttest() if ($ARGV[0] // '') eq '--selbsttest';

local $/;
my $ein = <STDIN> // '';
my $j = eval { decode_json($ein) } || {};
# Unlesbares JSON darf die Schranke nicht oeffnen (gemessen 25.10.2026: ein
# Testaufruf mit verdorbenen Rueckstrichen lief durch). Dann wird der Rohtext
# ungefiltert durchsucht.
my $roh = !defined $j->{tool_input}{command};
my $kommando = $roh ? $ein : nur_befehle($j->{tool_input}{command});
exit 0 unless $kommando =~ /\bgh[ \t]+pr[ \t]+create\b/;

# Die Wurzel kommt vom Ort dieses Skripts, nicht aus dem Arbeitsverzeichnis.
# Gemessen 25.10.2026: aus Eudora71/ heraus fand der Haken rollen-faellig.pl
# nicht, las eine leere Antwort als "nicht faellig" und liess ein PR-Anlegen
# durch. Und nur die Zeile "LEKTOR aktuell" laesst durch - "faellig, aber
# beauftragt" heisst: sein Bericht liegt noch nicht im Zweig. Was sich nicht
# lesen laesst, haelt auf.
my $wurzel = "$FindBin::Bin/..";
my $aus = `cd "$wurzel" && perl tools/rollen-faellig.pl --nur-melden 2>&1`;
# Zwei Formen: in der Tabelle ("LEKTOR    aktuell ..." / "faellig, aber
# beauftragt ...") oder als Punkt unter FAELLIG ("- LEKTOR ist faellig: ...").
my ($lektor) = $aus =~ /^\s*LEKTOR\s+(\S[^\n]*)/m;
($lektor) = $aus =~ /^\s*-\s*LEKTOR (ist faellig[^\n]*)/m unless defined $lektor;
# Ein eingetragener LEKTOR laeuft noch. Sein frueh gesichertes Geruest macht
# ihn fuer rollen-faellig.pl schon "aktuell" (LEKTOR-57 L-57.2, gemessen am
# eigenen Lauf) - der Bericht ist dann aber leer. Erst nach --fertig frei.
# Die Tabelle als Ganzes lesen ($/ ist oben fuer stdin abgeschaltet) und je
# Zeile mit /m suchen - die erste Fassung las sie als eine Zeile und fand nie
# etwas (gemessen 25.10.2026 mit einer eingetragenen Probezeile).
my $laufen = lies_datei("$wurzel/tools/AGENTEN-LAUFEN.md");
if ($laufen =~ /^\|\s*LEKTOR\s*\|\s*([^|]+?)\s*\|/m) {
    $lektor = "laeuft noch (eingetragen seit $1, tools/AGENTEN-LAUFEN.md) - erst den Bericht einholen und --fertig LEKTOR";
}
if (!defined $lektor or $lektor !~ /^aktuell\b/) {
    print STDERR "KEIN PR: LEKTOR " . ($lektor // "- Stand nicht lesbar:\n$aus") . "\n\n"
               . "Regel seit 06.09.2026 (Arbeitsweise/daueraufgaben-brauchen-einen-takt.md):\n"
               . "LEKTOR laeuft VOR jedem PR, den Gregor mergen soll. Erst den LEKTOR ueber den\n"
               . "Zweig laufen lassen und seinen Bericht in den Zweig holen, dann den PR anlegen.\n";
    exit 2;
}
exit 0;

# Nur der ausgefuehrte Befehl zaehlt, nicht der Text, den er mitnimmt.
# Gemessen 25.10.2026: der Commit, der diesen Haken einfuehrte, wurde von ihm
# selbst abgewiesen - die Commit-Nachricht im Heredoc enthielt "gh pr" und am
# Zeilenanfang danach "create". Danach wies er auch die eigene Berichtigung ab,
# weil deren Ersatztext die Wortfolge enthielt. Heredoc-Ruempfe,
# PowerShell-Here-Strings und Zeichenketten in Anfuehrungszeichen fallen
# deshalb vor der Suche weg, und zwischen den drei Woertern zaehlen nur
# Leerzeichen und Tabulatoren.
sub nur_befehle {
    my ($t) = @_;
    $t =~ s/<<-?[ \t]*(['"]?)(\w+)\1([^\n]*)\n.*?^[ \t]*\2[ \t]*$/$3/msg;
    $t =~ s/@(['"])[ \t]*\n.*?^\1@//msg;
    # Was hinter -c, -Command oder eval in Anfuehrungszeichen steht, wird
    # AUSGEFUEHRT, nicht mitgenommen (LEKTOR-57 L-57.2: bash -c "..." ging
    # durch). Diese Zeichenketten bleiben stehen, ohne ihre Anfuehrungszeichen.
    my @ausgefuehrt;
    while ($t =~ /(?:^|[\s;&|(])(?:-c|-Command|eval)\s+(?:'([^']*)'|"((?:\\.|[^"\\])*)")/g) {
        push @ausgefuehrt, defined $1 ? $1 : $2;
    }
    $t =~ s/'[^']*'//g;
    $t =~ s/"(?:\\.|[^"\\])*"//g;
    return join("\n", $t, @ausgefuehrt);
}

sub lies_datei {
    my ($d) = @_;
    open my $h, '<:raw', $d or return '';
    local $/;
    my $t = <$h>;
    close $h;
    return $t // '';
}

sub selbsttest {
    my $w = join ' ', 'gh', 'pr', 'create';
    my @f = (
        [1, "$w --title x --base main"],
        [1, "cd /c/x && $w --title y --body \"\$(cat <<'EOF'\nText\nEOF\n)\""],
        [1, "$w --body \@'\nZeile mit $w\n'\@"],
        [1, "gh  pr\tcreate"],
        [0, "git commit -q -F - <<'EOF'\nHaken: gh pr\n  create wird abgewiesen\nEOF\ngit push"],
        [0, "cat > x.txt <<'P'\n$w\nP\nperl -c x"],
        [0, "echo \"...$w\""],
        [0, "git commit -m '$w spaeter'"],
        [0, "\$m = \@'\n$w\n'\@; git commit -m \$m"],
        [0, "gh pr list"],
        [1, "bash -c \"$w --title x\""],
        [1, "powershell -Command '$w'"],
        [0, "git commit -m \"bash -c spaeter\""],
    );
    my $rot = 0;
    for my $i (0 .. $#f) {
        my ($soll, $k) = @{ $f[$i] };
        my $ist = nur_befehle($k) =~ /\bgh[ \t]+pr[ \t]+create\b/ ? 1 : 0;
        $rot++ if $ist != $soll;
        printf "  %s Fall %d: soll %s, ist %s\n", ($ist == $soll ? 'ok ' : 'ROT'), $i + 1,
               ($soll ? 'pruefen' : 'durchlassen'), ($ist ? 'pruefen' : 'durchlassen');
    }
    printf "  Selbsttest: %d Faelle, %d rot.\n", scalar @f, $rot;
    exit($rot ? 1 : 0);
}
