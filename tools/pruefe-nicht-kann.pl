#!/usr/bin/perl
use strict;
use warnings;

# pruefe-nicht-kann.pl - steht unter "Was es nicht kann" nur, was HEUTE fehlt?
#
#   perl tools/pruefe-nicht-kann.pl                 # Bestand
#   perl tools/pruefe-nicht-kann.pl <datei> ...     # nur diese Dateien
#   perl tools/pruefe-nicht-kann.pl --selbsttest    # 10 Faelle, beide Richtungen
#   perl tools/pruefe-nicht-kann.pl --hinweis       # meldet, weist nie ab
#
# Rueckgabe: 0 = sauber, 1 = MANGEL, 2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 22.10.2026 ueber den Abschnitt "Was es nicht kann":
#
#     "Das neueste Release ist v1.0.120 (veroeffentlicht am 21.10.202... oder
#      Beim Antworten und Weiterleiten fehlten Bilder im Verfassenfenster
#      (E-110, behoben. das ist doch bullshit! hier steht unter der
#      ueberschrift 'was es nicht kann', entsteht also der eindruck, all das
#      kann unser eudora nicht!"
#
# Gemessen am selben Tag: der Abschnitt hatte 224 Zeilen, davon sprachen 37
# von Behebungen, Bestaetigungen und Veroeffentlichungen - darunter eine
# vollstaendige Fassungsgeschichte (v1.0.120, v1.0.87, v1.0.84, v1.0.83) und
# acht behobene Befunde. Nach dem Aufraeumen: 86 Zeilen, 11 Punkte.
#
# DIE REGEL - eng gehalten
#
# Geprueft wird nur der FETTE KOPF eines Aufzaehlungspunktes, also das, was
# der Leser als Aussage des Punktes liest. Er darf nicht
#
#   (a) eine Fassungsnummer nennen (v1.0.87)  -> Fassungsgeschichte,
#   (b) das Wort "Release" tragen,
#   (c) im Praeteritum von einem Mangel sprechen ("fehlten", "erschien",
#       "blieb", "wurde unbrauchbar") -> das ist ein behobener Fehler.
#
# Und direkt hinter dem fetten Kopf darf keine Klammer stehen, die den
# Befund fuer behoben erklaert, ohne "offen" zu nennen.
#
# Was die Schranke BEWUSST durchlaesst: ein "behoben" MITTEN im Fliesstext
# eines Punktes. Der Punkt zu E-47 sagt zu Recht, das eigene Adressbuch sei
# nicht gemeint und zwei Fehler darin seien behoben - das verhindert eine
# Fehllesung und gehoert dorthin (Arbeitsweise/schranke-gegentesten.md).

my $hinweis = 0;
my @dateien;

for my $a (@ARGV) {
    if    ($a eq '--selbsttest') { exit selbsttest() }
    elsif ($a eq '--hinweis')    { $hinweis = 1 }
    elsif ($a =~ /^-/)           { print "  pruefe-nicht-kann: unbekannt: $a\n"; exit 2 }
    else                         { push @dateien, $a }
}

unless (@dateien) {
    @dateien = grep { -f $_ } ('README.md', glob('Doku/*.md'));
}

my @mangel;
for my $d (@dateien) {
    open my $fh, '<:raw', $d or next;
    local $/;
    my $t = <$fh>;
    close $fh;
    push @mangel, pruefe_text($d, $t);
}

if (@mangel) {
    print "  ------------------------------------------------------------\n";
    print "  pruefe-nicht-kann: GEHOERT NICHT UNTER \"Was es nicht kann\"\n";
    print "  ------------------------------------------------------------\n";
    printf "    %s:%d  (%s)\n      %.90s\n\n", $_->{datei}, $_->{zeile}, $_->{grund}, $_->{text}
        for @mangel;
    print "  Behobene Fehler und die Fassungsgeschichte gehoeren in\n";
    print "  CHANGELOG.md. Unter dieser Ueberschrift steht, was HEUTE fehlt -\n";
    print "  sonst liest sich die Liste wie lauter Maengel, die laengst\n";
    print "  keine mehr sind.\n";
    exit($hinweis ? 0 : 1);
}

printf "  pruefe-nicht-kann: %d Datei(en), kein behobener Fehler unter \"Was es nicht kann\".\n",
       scalar @dateien;
exit 0;

# ---------------------------------------------------------------------------

sub pruefe_text {
    my ($datei, $t) = @_;
    my @funde;
    my @zeilen = split /\n/, $t, -1;

    my ($drin, $start) = (0, 0);
    for my $i (0 .. $#zeilen) {
        my $z = $zeilen[$i];

        if ($z =~ /^#{2,4}\s/) {
            $drin = ($z =~ /Was es nicht kann/i) ? 1 : 0;
            next;
        }
        next unless $drin;
        next unless $z =~ /^\*\s+\*\*(.+?)\*\*(.*)$/;
        my ($kopf, $rest) = ($1, $2);

        my $grund;
        if    ($kopf =~ /v\d+\.\d+\.\d+/)         { $grund = 'Fassungsnummer im Kopf' }
        elsif ($kopf =~ /\bRelease\b/i)           { $grund = 'Release im Kopf' }
        elsif ($kopf =~ /\b(?:fehlten|erschien|blieb|wurden?\s+unbrauchbar|stuerzte|kam\s+nicht\s+an)\b/i)
                                                  { $grund = 'Praeteritum - das ist behoben' }
        elsif ($rest =~ /^\s*\(/ && substr($rest, 0, 170) =~ /behoben/i && $rest !~ /offen/i)
                                                  { $grund = 'als behoben erklaert' }

        push @funde, { datei => $datei, zeile => $i + 1, text => $z, grund => $grund } if $grund;
    }
    return @funde;
}

sub selbsttest {
    my $K = "## Was es nicht kann\n\n";
    my @faelle = (
        [ 'echte Einschraenkung',        $K . "* **Nur 32 Bit.** Keine 64-Bit-Fassung.\n", 0 ],
        [ 'offener Befund mit Kennung',  $K . "* **Umlaute roh** ([E-77](x), offen): Entw&APw-rfe.\n", 0 ],
        [ 'behoben MITTEN im Text (E-47)', $K . "* **S/MIME faellt aus.** Nicht gemeint ist das Adressbuch; zwei Fehler darin sind behoben.\n", 0 ],
        [ 'Teilbehebung, Punkt offen',   $K . "* **Vorschautext** ([E-105](x), offen; Behebung eingebaut): steht da.\n", 0 ],
        [ 'ausserhalb des Abschnitts',   "## Was es kann\n\n* **Das neueste Release ist v1.0.120** erschien.\n", 0 ],
        [ 'Punkt ohne Fettkopf',         $K . "* schlichter Text ohne Auszeichnung\n", 0 ],

        [ 'Fassungsnummer im Kopf',      $K . "* **`v1.0.87`** (veroeffentlicht am 14.10.2026).\n", 1 ],
        [ 'neueste Release',             $K . "* **Das neueste Release ist `v1.0.120`** (veroeffentlicht).\n", 1 ],
        [ 'Praeteritum: fehlten',        $K . "* **Beim Antworten fehlten Bilder im Verfassenfenster** ([E-110](x)).\n", 1 ],
        [ 'direkt als behoben erklaert', $K . "* **Betreffzeile wird umbrochen** ([E-94](x), behoben in 7.2.0.83).\n", 1 ],
    );

    my ($gut, $schlecht) = (0, 0);
    print "  ------------------------------------------------------------\n";
    print "  pruefe-nicht-kann --selbsttest\n";
    print "  ------------------------------------------------------------\n";
    for my $f (@faelle) {
        my ($name, $text, $soll) = @$f;
        my @ist = pruefe_text('selbsttest', $text);
        my $ok = (scalar @ist) == $soll;
        $ok ? $gut++ : $schlecht++;
        printf "    [%s] %-34s soll %d, ist %d\n", ($ok ? ' ok ' : 'FEHL'), $name, $soll, scalar @ist;
    }
    print "  ------------------------------------------------------------\n";
    printf "    %d Faelle, %d richtig, %d falsch\n", $gut + $schlecht, $gut, $schlecht;
    print "    (6 muessen durchgehen, 4 muessen abweisen)\n";
    return $schlecht ? 1 : 0;
}
