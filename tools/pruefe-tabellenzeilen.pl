#!/usr/bin/perl
use strict;
use warnings;

# pruefe-tabellenzeilen.pl - steht jede Markdown-Tabellenzeile auf EINER Zeile?
#
#   perl tools/pruefe-tabellenzeilen.pl                 # Bestand: alle .md
#   perl tools/pruefe-tabellenzeilen.pl <datei> ...     # nur diese Dateien
#   perl tools/pruefe-tabellenzeilen.pl --selbsttest    # 12 Faelle, beide Richtungen
#   perl tools/pruefe-tabellenzeilen.pl --hinweis       # meldet, weist nie ab
#
# Rueckgabe: 0 = keine gebrochene Zeile, 1 = MANGEL, 2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 22.10.2026 meldete Gregor zu WEITERMACHEN.md auf GitHub: "hat ein
# darstellungsproblem: der text ist links, nicht rechts." Gemessen: zwei
# Tabellenzeilen waren ueber zwei physische Zeilen gebrochen - Zeile 9/10
# ("...Uebertragungsart. Davor" + "7.2.0.110 auf Zweig") und Zeile 46/47
# ("...PR #117" + ", ZIP Eudora72-1.0.113-release.zip").
#
# WARUM DAS NICHT NUR HAESSLICH IST, SONDERN DEN INHALT VERSCHIEBT
#
# GFM kennt die "lazy continuation": eine Textzeile, die OHNE Leerzeile direkt
# hinter einer Tabellenzeile steht, wird als EIGENE Tabellenzeile gelesen. Weil
# der abgerissenen Haelfte das fuehrende "|" fehlt, faellt ihr Text in
# Spalte 1 - er steht also unter der Kennung statt unter der Beschreibung.
# Genau das hat Gregor gesehen. Der Leser bekommt eine Tabelle, in der
# Zeilen ohne Kennung dastehen und Saetze mittendrin abbrechen.
#
# DIE REGEL
#
# Innerhalb einer Tabelle ist jede nicht-leere Zeile, die nicht mit "|"
# beginnt, ein Mangel. Eine echte Tabelle endet mit einer Leerzeile; wer
# danach Fliesstext schreibt, setzt die Leerzeile. Damit gibt es keinen
# erlaubten Fall, den diese Regel trifft (Arbeitsweise/schranke-gegentesten.md).
#
# Ein fehlender ABSCHLUSS-Pipe ("| a | b | c" ohne das letzte "|") ist KEIN
# Mangel - GFM erlaubt ihn, und BEFUNDE.md:255 nutzt ihn. Die Schranke, die
# den Fehler zuerst fand, hat genau hier Fehlalarm gegeben.

my $hinweis = 0;
my @dateien;

for my $a (@ARGV) {
    if    ($a eq '--selbsttest') { exit selbsttest() }
    elsif ($a eq '--hinweis')    { $hinweis = 1 }
    elsif ($a =~ /^-/)           { print "  pruefe-tabellenzeilen: unbekannt: $a\n"; exit 2 }
    else                         { push @dateien, $a }
}

unless (@dateien) {
    @dateien = sort glob('*.md');
    push @dateien, sort glob('Befunde/*.md');
    push @dateien, sort glob('tools/*.md');
    push @dateien, sort glob('Arbeitsweise/*.md');
    push @dateien, sort glob('Releases/*.md');
}

my @mangel;
for my $d (@dateien) {
    next unless -f $d;
    open my $fh, '<', $d or do { print "  pruefe-tabellenzeilen: $d nicht lesbar\n"; exit 2 };
    push @mangel, pruefe_text($d, [<$fh>]);
    close $fh;
}

if (@mangel) {
    print "  ------------------------------------------------------------\n";
    print "  pruefe-tabellenzeilen: GEBROCHENE TABELLENZEILE\n";
    print "  ------------------------------------------------------------\n";
    for my $m (@mangel) {
        printf "    %s:%d\n", $m->{datei}, $m->{zeile};
        printf "      Tabellenzeile davor : %.70s...\n", $m->{davor};
        printf "      steht allein da     : %.70s...\n", $m->{text};
        printf "      %s\n\n", $m->{grund};
    }
    print "  Eine Tabellenzeile steht auf EINER Zeile. Die beiden\n";
    print "  zusammenziehen - oder, wenn es Fliesstext sein soll, eine\n";
    print "  Leerzeile vor die Tabelle setzen.\n";
    exit($hinweis ? 0 : 1);
}

printf "  pruefe-tabellenzeilen: %d Dateien, keine gebrochene Tabellenzeile.\n", scalar @dateien;
exit 0;

# ---------------------------------------------------------------------------

sub pruefe_text {
    my ($datei, $zeilen) = @_;
    my (@funde, $im_code, $in_tabelle, $letzte_zeile, $letzte_nr);

    for my $i (0 .. $#$zeilen) {
        my $z = $zeilen->[$i];
        $z =~ s/\r?\n\z//;
        my $nr = $i + 1;

        if ($z =~ /^\s*(?:```|~~~)/) { $im_code = !$im_code; $in_tabelle = 0; next }
        next if $im_code;

        if ($z =~ /^\s*$/) { $in_tabelle = 0; next }

        if ($z =~ /^\s*\|/) {
            # Kopfzeile wird erst durch die Trennzeile darunter zur Tabelle.
            if (!$in_tabelle) {
                my $next = $i + 1 <= $#$zeilen ? $zeilen->[$i + 1] : '';
                $in_tabelle = 1 if $next =~ /^\s*\|[\s:|-]+\|?\s*$/;
            }
            $letzte_zeile = $z;
            $letzte_nr    = $nr;
            next;
        }

        next unless $in_tabelle;

        # GFM beendet eine Tabelle an jedem BLOCKANFANG - Ueberschrift,
        # Zitat, Liste, Trennstrich, HTML. Nur gewoehnlicher Fliesstext
        # wird als "lazy continuation" zur naechsten Tabellenzeile, und
        # genau der ist der Mangel. Ohne diese Ausnahme meldete die
        # Schranke Befunde/LEKTOR-6.md:882 an, wo eine Ueberschrift
        # "## L-11.4" ohne Leerzeile hinter einer Tabelle steht: dort
        # bricht die Tabelle richtig ab (Arbeitsweise/schranke-gegentesten.md).
        if ($z =~ m{^\s{0,3}(?:\#{1,6}\s|>|[-*+]\s|\d{1,9}[.)]\s|<)}
            || $z =~ m{^\s{0,3}(?:-{3,}|\*{3,}|_{3,})\s*$}) {
            $in_tabelle = 0;
            next;
        }

        my $grund = $letzte_zeile =~ /\|\s*$/
            ? 'Die Zeile davor ist vollstaendig - hier fehlt eine Leerzeile.'
            : 'Die Zeile davor endet NICHT mit "|" - der Satz ist mittendrin abgerissen.';

        push @funde, {
            datei => $datei, zeile => $nr, text => $z,
            davor => $letzte_zeile, grund => $grund,
        };
        $in_tabelle = 0;
    }
    return @funde;
}

sub selbsttest {
    my @faelle = (
        # [ Name, Text, erwartete Zahl der Funde ]
        [ 'heile Tabelle',                "| a | b |\n|---|---|\n| 1 | 2 |\n", 0 ],
        [ 'heile Tabelle, dann Absatz',   "| a | b |\n|---|---|\n| 1 | 2 |\n\nFliesstext.\n", 0 ],
        [ 'ohne Abschluss-Pipe (GFM ok)', "| a | b |\n|---|---|\n| 1 | 2\n| 3 | 4 |\n", 0 ],
        [ 'Pipes im Code-Block',          "```\n| a | b |\nkein Pipe hier\n```\n", 0 ],
        [ 'Pipes im Tilde-Block',         "~~~\n| a | b |\n|---|---|\nabgerissen\n~~~\n", 0 ],
        [ 'Pipe-Zeile ohne Trennzeile',   "| nur so ein Strich |\nnormaler Text\n", 0 ],
        [ 'Tabelle am Dateiende',         "| a | b |\n|---|---|\n| 1 | 2 |\n", 0 ],

        [ 'DER ECHTE FEHLER (WM:9/10)',   "| a | b |\n|---|---|\n| x | ...Davor\n7.2.0.110 auf Zweig\n", 1 ],
        [ 'Abriss vor Komma (WM:46/47)',  "| a | b |\n|---|---|\n| x | ...PR #117\n, ZIP Eudora72\n", 1 ],
        [ 'Absatz ohne Leerzeile',        "| a | b |\n|---|---|\n| 1 | 2 |\nFliesstext direkt dahinter.\n", 1 ],
        [ 'zwei Brueche in einer Datei',  "| a | b |\n|---|---|\n| 1 | x\nrest eins\n\n| c | d |\n|---|---|\n| 2 | y\nrest zwei\n", 2 ],
        [ 'Ueberschrift beendet Tabelle',  "| a | b |\n|---|---|\n| 1 | 2 |\n## L-11.4 Titel\n", 0 ],
        [ 'Liste beendet Tabelle',         "| a | b |\n|---|---|\n| 1 | 2 |\n* Punkt\n", 0 ],
        [ 'Zitat beendet Tabelle',         "| a | b |\n|---|---|\n| 1 | 2 |\n> Zitat\n", 0 ],
        [ 'Trennstrich beendet Tabelle',   "| a | b |\n|---|---|\n| 1 | 2 |\n---\n", 0 ],
        [ 'HTML beendet Tabelle',          "| a | b |\n|---|---|\n| 1 | 2 |\n<a id=\"x\"></a>\n", 0 ],
        [ 'Zahlenliste beendet Tabelle',   "| a | b |\n|---|---|\n| 1 | 2 |\n1. Punkt\n", 0 ],
        [ 'Bruch nach dem Code-Block',    "```\nirgendwas\n```\n\n| a | b |\n|---|---|\n| 1 | x\nrest\n", 1 ],
    );

    my ($gut, $schlecht) = (0, 0);
    print "  ------------------------------------------------------------\n";
    print "  pruefe-tabellenzeilen --selbsttest\n";
    print "  ------------------------------------------------------------\n";
    for my $f (@faelle) {
        my ($name, $text, $soll) = @$f;
        my @zeilen = map { "$_\n" } split /\n/, $text, -1;
        pop @zeilen if $zeilen[-1] eq "\n";
        my @ist = pruefe_text('selbsttest', \@zeilen);
        my $ok = (scalar @ist) == $soll;
        $ok ? $gut++ : $schlecht++;
        printf "    [%s] %-32s soll %d, ist %d\n", ($ok ? ' ok ' : 'FEHL'), $name, $soll, scalar @ist;
    }
    print "  ------------------------------------------------------------\n";
    printf "    %d Faelle, %d richtig, %d falsch\n", $gut + $schlecht, $gut, $schlecht;
    print "    (13 muessen durchgehen, 5 muessen abweisen)\n";
    return $schlecht ? 1 : 0;
}
