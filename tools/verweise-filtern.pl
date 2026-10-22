# verweise-filtern.pl - eine Zeile, die sich nur im Verweis geaendert hat,
# ist kein Zuwachs.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE DATEI GIBT
# ---------------------------------------------------------------------------
#
# Am 12.10.2026 hat tools/befunde-verlinken.pl in neun Dokumenten 1046
# Zeilen angefasst - aus E-108 wurde [E-108](Intern/BEFUNDE.md#e-108), sonst
# nichts. Fuer git ist jede dieser Zeilen neu. Die Schranken, die ihren
# Umfang aus dem Zuwachs nehmen (pruefe-anzeigetext.pl,
# pruefe-behoben-belegt.pl), sahen damit auf einen Schlag die GANZE
# Urteilstabelle als frisch an und wiesen Altlasten ab, die mit der
# Aenderung nichts zu tun haben.
#
# Das ist derselbe Fall wie entmojibake_nur_kodierung_gefiltert() in
# entmojibaken.pl: eine rein umkodierte Zeile ist auch kein Zuwachs. Hier
# ist es eine rein verlinkte.
#
# Gefiltert wird NICHT grosszuegig: verglichen wird die Zeile, nachdem
# Ankermarken und Linkhuellen entfernt sind. Steht im Linktext etwas
# anderes als vorher im Fliesstext, bleibt die Zeile Zuwachs.

use strict;
use warnings;

# Macht aus "| <a id="e-1"></a>E-1 | ... [**E-2**](Intern/BEFUNDE.md#e-2) ..."
# wieder "| E-1 | ... **E-2** ...".
sub verweise_text {
    my ($t) = @_;
    $t =~ s{<a\s+id="[^"]*"></a>\s*}{}g;
    # Nur Verweise auf eine Befundkennung aufloesen, keine beliebigen Links:
    # ein neu gesetzter Link auf eine Webseite IST eine Aenderung.
    $t =~ s{\[([^\]]*)\]\((?:[A-Za-z0-9_.-]*\.md)?#[A-Za-z][A-Za-z0-9]{0,8}-\d+[a-z]?\)}{$1}g;
    return $t;
}

sub verweise_nur_links_gefiltert {
    my ($alt, $neu) = @_;
    return @$neu unless @$alt && @$neu;
    my %war_schon;
    $war_schon{ verweise_text($_) } = 1 for @$alt;
    return grep { !$war_schon{ verweise_text($_) } } @$neu;
}

# ---------------------------------------------------------------------------
# Selbsttest - perl tools/verweise-filtern.pl
# ---------------------------------------------------------------------------
unless (caller) {
    my @faelle = (
        # [ alt, neu, bleibt Zuwachs? ]
        [ '| E-1 | der Rahmen | behoben |',
          '| <a id="e-1"></a>E-1 | der Rahmen | behoben |', 0 ],
        [ 'siehe E-108 und AN-1',
          'siehe [E-108](Intern/BEFUNDE.md#e-108) und [AN-1](Intern/BEFUNDE.md#an-1)', 0 ],
        [ 'siehe **E-108**',
          'siehe [**E-108**](Intern/BEFUNDE.md#e-108)', 0 ],
        [ 'siehe E-108',
          'siehe [E-108](#e-108)', 0 ],
        # echte Aenderung darf NICHT durchrutschen
        [ 'siehe E-108',
          'siehe [E-108](Intern/BEFUNDE.md#e-108), jetzt behoben', 1 ],
        [ 'siehe E-108',
          'siehe [E-109](Intern/BEFUNDE.md#e-109)', 1 ],
        [ 'Handbuch',
          '[Handbuch](https://example.invalid/)', 1 ],
        [ 'Handbuch',
          '[Handbuch](ZIEL.md)', 1 ],
    );
    my ($n, $schlecht) = (0, 0);
    for my $f (@faelle) {
        my ($alt, $neu, $soll) = @$f;
        my @uebrig = verweise_nur_links_gefiltert([$alt], [$neu]);
        my $ist = scalar(@uebrig) ? 1 : 0;
        $n++;
        next if $ist == $soll;
        $schlecht++;
        print "  ABWEICHUNG: '$neu'\n    erwartet Zuwachs=$soll, bekommen $ist\n";
    }
    printf "  verweise-filtern: %d Faelle, %d Abweichung(en)\n", $n, $schlecht;
    exit($schlecht ? 1 : 0);
}

1;

# DIE STUFENMARKE IST KEINE NEUE AUSSAGE (22.10.2026). Als die Marke
# **Stufe: ...** in alle 190 Urteile kam, stand jede Befundzeile im Diff.
# Drei Schranken, die nur den ZUWACHS pruefen, warfen daraufhin den ganzen
# Altbestand hoch: pruefe-regressionstest (88 angeblich neu behobene),
# pruefe-behoben-belegt (62 ohne Beleg) und pruefe-anzeigetext (3 Zitate
# ohne Herkunft). Der Rueckstand ist echt - aber er ist kein Zuwachs, und
# eine Schranke, die bei einer Massenaenderung so etwas tut, wird beim
# naechsten Mal mit --no-verify umgangen.
#
# Deshalb steht der Filter HIER und nicht dreimal einzeln
# (Arbeitsweise/fehlerklassen-abstellen.md: beim zweiten Auftreten ein
# Werkzeug bauen, nicht einzeln nachbessern).
sub stufenmarke_nur_gefiltert {
    my ($alt, $neu) = @_;
    my $ohne = sub {
        my ($z) = @_;
        $z =~ s/\s*\*\*Stufe: [a-z]+\*\* \([^)]*\)//g;
        # Leerraum angleichen: die Marke wurde VOR dem letzten | eingesetzt,
        # aus "**behoben** |" wurde "**behoben**  **Stufe: ...)|".
        $z =~ s/\s+/ /g;
        $z =~ s/\s*\|/|/g;
        return $z;
    };
    my %altohne = map { $ohne->($_) => 1 } @$alt;
    return grep { !$altohne{ $ohne->($_) } } @$neu;
}

1;
