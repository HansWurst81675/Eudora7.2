#!/usr/bin/perl
use strict;
use warnings;

# pruefe-original-belegt.pl - "Originalfehler" ist eine Aussage ueber ein
# Verhalten. Wer sie schreibt, nennt die Messung am Verhalten.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 21.10.2026 stand im ersten Entwurf zu E-134 (ein neuer
# Adressbucheintrag nimmt den eingetippten Kurznamen nicht an), der Fehler
# sei ORIGINALVERHALTEN. Gemessen war dafuer nichts. Belegt war nur, dass
# die //FORNOW-Kommentare in nickview.cpp aus dem initial commit stammen -
# eine Aussage ueber den KOMMENTAR.
#
# Gregor hat das mit einer Frage umgeworfen:
#
#     "was ist denn hier neu? in der alten hermes implementierung hat es ja
#      funktioniert."
#
# Erst danach wurde nachgesehen. Das Ergebnis steht jetzt in Intern/BEFUNDE.md:
#
#     "nickview.cpp, nickview.h, nicktree.cpp, nicktree.h und
#      Eudora.manifest sind seit 567a5d87 von uns nie angefasst worden
#      (git log leer, git diff leer). Der Entwurf QUALCOMMs waehlt den neuen
#      Eintrag sehr wohl aus ... Also: Quelltext original, Verhalten
#      veraendert - eine Portierungsfolge, obwohl keine Zeile dieser Dateien
#      von uns stammt."
#
# Nachgemessen am 21.10.2026 im Zweig wt/chronist-20261021: jede der vier
# Dateien hat genau EINEN Commit vor 14786286, naemlich den initial commit.
# Der Quelltextbefund war also richtig. Falsch war der Schluss daraus.
#
# In einer Portierung ist die unveraenderte Quelle gerade der Ort, an dem
# sich Verhalten lautlos aendert: Compiler, MFC, Common Controls und
# Manifest sind mitgewandert, der Quelltext nicht.
#
# Lehre: Arbeitsweise/original-ist-eine-messung.md
#
# ---------------------------------------------------------------------------
# WAS GEPRUEFT WIRD - UND WAS BEWUSST NICHT
# ---------------------------------------------------------------------------
#
# Geprueft wird NUR der Zuwachs an Intern/BEFUNDE.md, aus demselben Grund wie bei
# pruefe-behoben-belegt.pl: im Bestand stehen 19 Zeilen mit einem
# Original-Urteil, und eine Schranke, die bei jedem Commit neunzehnmal
# meckert, wird abgeschaltet (Arbeitsweise/schranke-gehoert-in-den-haken.md).
#
# Nicht geprueft wird, OB die Einordnung stimmt. Das kann kein Muster.
# Geprueft wird, ob daneben steht, woran sie haengt - oder ausdruecklich,
# dass sie nicht gemessen ist. Beides ist in Ordnung; nur die ungedeckte
# Behauptung nicht.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-original-belegt.pl              # gestagte Aenderung
#   perl tools/pruefe-original-belegt.pl --commit ABC
#   perl tools/pruefe-original-belegt.pl --datei Intern/BEFUNDE.md
#   perl tools/pruefe-original-belegt.pl --selbsttest
#
# Rueckgabe 0 = in Ordnung, 1 = Mangel, 2 = Aufrufproblem.

my $ANKER = qr/(?:<a\s+id="[^"]*"><\/a>)?/;
my $DATEI = 'Intern/BEFUNDE.md';

# UMZUG ERKENNEN (22.10.2026). Am 22.10.2026 zogen 16 Dokumente von der
# Wurzel nach Intern/. Mit nur dem NEUEN Pfad im Pathspec kann git die
# Umbenennung nicht paaren und meldet die ganze Datei als neu: 8703
# hinzugefuegte Zeilen statt 35. Diese Schranke haette daraufhin 68
# Urteile angemahnt, die seit Wochen unveraendert dastehen. Mit beiden
# Pfaden und -M erkennt git die Umbenennung.
my $ALTPFAD = ($DATEI =~ m{^Intern/(.+)$}) ? $1 : '';

# --- Was als Original-Urteil gilt ------------------------------------------
#
# "Originalfehler", "Originalverhalten", "Originalmangel", "schon im
# Original", "Fehler des Originals", "war in 7.1 schon so".
my @urteil = (
    ['Originalfehler',    qr/\bOriginalfehler\b/i],
    ['Originalverhalten', qr/\bOriginalverhalten\b/i],
    ['Originalmangel',    qr/\bOriginalmangel\b/i],
    ['im Original',       qr/\b(?:schon|bereits|so)\s+im\s+Original\b/i],
    ['Fehler des Originals', qr/\bFehler\s+des\s+Originals\b/i],
);

# --- Was als Beleg am VERHALTEN zaehlt -------------------------------------
#
# Drei Formen, und eine ausdrueckliche Einschraenkung.
my @belege = (
    # 1. An einer aelteren eigenen Fassung gemessen und gleich vorgefunden.
    #    Das schliesst einen frischen Rueckfall aus - nicht die Portierung
    #    selbst, denn 7.2.0.88 ist auch schon unsere. Siehe die Luecke unten.
    #    Das Wort, das die Gleichheit ausdrueckt, kann VOR oder HINTER der
    #    Fassungsnummer stehen. Der erste Entwurf suchte nur dahinter und
    #    liess die echte E-69-Zeile durchfallen: "auch an 7.2.0.88
    #    (C:\Temp\E118-0088), also ein Originalfehler von QUALCOMM".
    ['an einer aelteren Fassung gemessen',
     qr/\b(?:an|in)\s+(?:7\.2\.[01]\.|1\.0\.)\d+[^|]{0,120}?(?:gleich|ebenso|genauso|auch|gemessen|nachgestellt|belegt|gezeigt|reproduziert)/i],
    ['an einer aelteren Fassung gemessen',
     qr/\b(?:auch|ebenso|genauso|gleich|schon|bereits)\s+(?:an|in)\s+(?:7\.2\.[01]\.|1\.0\.)\d+/i],

    # 2. Am Original gemessen: Hermes, Eudora 7.1, der Originalbau, der
    #    Entwurf QUALCOMMs im Quelltext.
    ['am Original gemessen',
     qr/\b(?:Hermes|Eudora\s*7\.1|7\.1er?|Original(?:bau|fassung|programm|stand)|QUALCOMMs?\s+(?:Entwurf|Fassung|Code))\b[^|]{0,140}?(?:gemessen|gelaufen|getestet|verglichen|best(?:\xc3\xa4|ae)tigt|funktioniert|zeigt|zeigte|liefert|w(?:\xc3\xa4|ae)hlt|tut|hat\s+es)/i],

    # 3. Gregor hat es am alten Programm gesehen.
    ['von Gregor am alten Programm',
     qr/\bGregor\b[^|]{0,120}?\b(?:Hermes|7\.1)\b[^|]{0,80}?(?:best(?:\xc3\xa4|ae)tigt|gemeldet|funktioniert|lief|ging)/i],

);

# Die ausdrueckliche Einschraenkung - der Satz, der in E-134 gefehlt hat.
# Wer so schreibt, behauptet nichts Ungedecktes mehr.
#
# Diese Liste wird VOR @belege gefahren ([L-48.7](../Befunde/LEKTOR-48.md#l-48.7)).
# Grund: E-133 traegt beides - die Einschraenkung "Quelltext original,
# Verhalten nicht gemessen" UND den Satz "Ob ein Hermes 7.1 ... ebenfalls
# den Start verweigert, ist nicht gemessen". Der zweite traf Beleg 2 und
# wurde als "am Original gemessen" ausgegeben, also als das Gegenteil
# dessen, was dort steht. Steht die Einschraenkung zuerst, nennt die
# Ausgabe den richtigen Grund.
my @grenzen = (
    ['Einschraenkung: Quelltext original, Verhalten nicht gemessen',
     qr/Quelltext\s+original[^|]{0,60}?Verhalten/i],
    ['Einschraenkung: Verhalten nicht gemessen',
     qr/Verhalten\s+(?:ist\s+)?(?:nicht|nie)\s+(?:am\s+Original\s+)?(?:gemessen|gepr(?:\xc3\xbc|ue)ft|verglichen)/i],
    ['Einschraenkung: nur am Quelltext belegt',
     qr/nur\s+(?:am|im)\s+Quelltext\s+(?:belegt|gelesen|gesehen)/i],
);

# Eine Verneinung IM Treffer macht aus dem Beleg sein Gegenteil
# ([L-48.7](../Befunde/LEKTOR-48.md#l-48.7)). Gemessen am 21.10.2026: die
# Zeile "das ist ein Originalfehler. Ob ein Hermes 7.1 sich ebenso
# verhielt, ist nicht gemessen" kam gruen heraus, mit dem Grund "am
# Original gemessen". Geprueft wird nur der Treffer selbst, nicht die
# ganze Zelle - ein "kein Rueckfall" am Satzende soll weiter durchgehen.
my $VERNEINT = qr/\b(?:nicht|nie|niemals|kaum)\b/i;

# ---------------------------------------------------------------------------
# Kern: eine Zeile beurteilen
# ---------------------------------------------------------------------------
#
# Rueckgabe: (Kennung, Urteilsname oder undef, Belegname oder undef)
sub beurteile {
    my ($zeile) = @_;

    return (undef, undef, undef)
        unless $zeile =~ /^\|\s*$ANKER\s*\*{0,2}([A-Za-z]{1,3}\d*-[0-9a-z]+)\*{0,2}\s*\|/;
    my $kennung = $1;

    # Ein "\|" im Text ist ein geschuetzter Strich, kein Spaltentrenner -
    # dieselbe Falle wie in pruefe-behoben-belegt.pl.
    my $SCHUTZ = chr(1);
    (my $sicher = $zeile) =~ s/\Q${\ chr(92)}\E\|/$SCHUTZ/g;
    my @spalten = split /\|/, $sicher, -1;
    return ($kennung, undef, undef) unless @spalten >= 4;
    my $text = $spalten[3];

    my $name;
    for my $u (@urteil) {
        if ($text =~ $u->[1]) { $name = $u->[0]; last; }
    }
    return ($kennung, undef, undef) unless defined $name;

    # Erst die Einschraenkung: wer sie schreibt, behauptet nichts.
    for my $g (@grenzen) {
        return ($kennung, $name, $g->[0]) if $text =~ $g->[1];
    }
    # Dann die Belege - aber ein Treffer, der selbst eine Verneinung
    # enthaelt, belegt nichts.
    for my $b (@belege) {
        next unless $text =~ $b->[1];
        next if $& =~ $VERNEINT;
        return ($kennung, $name, $b->[0]);
    }
    return ($kennung, $name, undef);
}

# ---------------------------------------------------------------------------
# Selbsttest - in beide Richtungen
# ---------------------------------------------------------------------------
sub selbsttest {
    my $fehler = 0;
    my @faelle = (
        # [Name, Zeile, Urteil erwartet?, Beleg erwartet?]

        # DER ECHTE FEHLER. Nachgebaut aus dem, was Intern/BEFUNDE.md ueber den
        # ersten Entwurf sagt ("Die Einordnung Originalverhalten, die hier
        # zuerst stand, war falsch; belegt war nur, dass die //FORNOW-
        # Kommentare original sind"). Der Entwurf selbst wurde nie
        # committet, es gibt also keinen Commit zum Gegenfahren.
        ['E-134 erster Entwurf: Originalverhalten, belegt am Kommentar',
         '| E-134 | Adressbuch nimmt den Kurznamen nicht an | **offen** - '
         . 'Originalverhalten: die `//FORNOW`-Kommentare in `nickview.cpp` '
         . 'stammen aus dem initial commit |',
         1, 0],

        # DIE BERICHTIGTE FASSUNG, wie sie jetzt dasteht.
        ['E-134 berichtigt: Quelltext original, Verhalten veraendert',
         '| E-134 | Adressbuch | **behoben in 7.2.0.119** - Also: Quelltext '
         . 'original, Verhalten ver' . "\xc3\xa4" . 'ndert, eine '
         . 'Portierungsfolge. Die Einordnung *"Originalverhalten"*, die hier '
         . 'zuerst stand, war falsch |',
         1, 1],

        # ECHTE ZEILEN AUS DEM BESTAND, sinngemaess gekuerzt - sie muessen
        # durchlaufen, sonst ist die Schranke ein Dauerfehlalarm.
        ['E-69 Bestand: an 7.2.0.88 gleich vorgefunden',
         '| E-69 | Nachricht bleibt liegen | **offen** - auch an 7.2.0.88 '
         . '(`C:\\Temp\\E118-0088`), also ein Originalfehler von QUALCOMM, '
         . 'kein R' . "\xc3\xbc" . 'ckfall durch E-118 |',
         1, 1],

        ['PRUEFER-27 Bestand: an 7.2.0.88 und 7.2.0.89 gleich',
         '| E-120 | Zeitzone | **offen** - am 14.10.2026 am IMAP-Pr'
         . "\xc3\xbc" . 'fserver, an 7.2.0.88 und 7.2.0.89 gleich - '
         . 'Originalfehler |',
         1, 1],

        ['am Entwurf QUALCOMMs im Quelltext belegt',
         '| E-134 | Adressbuch | **offen** - der Entwurf QUALCOMMs w'
         . "\xc3\xa4" . 'hlt den neuen Eintrag sehr wohl aus |',
         0, 0],

        ['Hermes gemessen',
         '| E-99 | irgendwas | **offen** - in Hermes 7.1 gemessen, dort '
         . 'genauso: Originalfehler |',
         1, 1],

        ['von Gregor in Hermes bestaetigt',
         '| E-98 | irgendwas | **offen** - Originalfehler; Gregor hat es in '
         . 'Hermes best' . "\xc3\xa4" . 'tigt |',
         1, 1],

        ['Originalfehler ganz ohne Beleg - muss abgewiesen werden',
         '| E-97 | irgendwas | **offen** - Originalfehler von QUALCOMM |',
         1, 0],

        ['Originalmangel ohne Beleg - muss abgewiesen werden',
         '| E-96 | irgendwas | **offen**, ein Originalmangel |',
         1, 0],

        ['"schon im Original" ohne Beleg - muss abgewiesen werden',
         '| E-95 | irgendwas | **offen** - das war schon im Original so |',
         1, 0],

        ['Einschraenkung "Verhalten nicht gemessen" reicht',
         '| E-94 | irgendwas | **offen** - Originalfehler; Quelltext '
         . 'unver' . "\xc3\xa4" . 'ndert, das Verhalten ist nicht gemessen |',
         1, 1],

        ['Einschraenkung "nur am Quelltext belegt" reicht',
         '| E-93 | irgendwas | **offen** - Originalverhalten, nur am '
         . 'Quelltext belegt |',
         1, 1],

        # L-48.7, gemessen am 21.10.2026: diese Zeile kam vorher GRUEN
        # heraus, mit dem Grund "am Original gemessen" - also mit dem
        # Gegenteil dessen, was sie sagt.
        ['Verneinung im Treffer belegt nichts - muss abgewiesen werden',
         '| E-91 | irgendwas | **offen** - das ist ein Originalfehler. Ob '
         . 'ein Hermes 7.1 sich ebenso verhielt, ist nicht gemessen |',
         1, 0],

        # Die Gegenprobe dazu: dieselbe Form OHNE Verneinung muss weiter
        # durchgehen, sonst ist die Schranke ein Dauerfehlalarm.
        ['dieselbe Form ohne Verneinung - muss weiter durchgehen',
         '| E-90 | irgendwas | **offen** - das ist ein Originalfehler. Ein '
         . 'Hermes 7.1 hat sich ebenso verhalten, am 21.10.2026 gemessen |',
         1, 1],

        ['ganz ohne Original-Wort - wird nicht geprueft',
         '| E-92 | irgendwas | **offen**, Umlaute kommen falsch an |',
         0, 0],

        ['keine Befundzeile',
         'Das Wort Originalfehler steht hier im Fliesstext.',
         0, 0],
    );

    my $gefahren = 0;
    for my $f (@faelle) {
        my ($name, $zeile, $soll_urteil, $soll_beleg) = @$f;
        my ($k, $urteil, $beleg) = beurteile($zeile);
        my $ist_u = defined($urteil) ? 1 : 0;
        my $ist_b = defined($beleg)  ? 1 : 0;
        my $ok = ($ist_u == $soll_urteil) && ($ist_b == $soll_beleg);
        $gefahren++;
        $fehler++ unless $ok;
        printf "    %-4s %s\n", ($ok ? 'ok' : 'FEHL'), $name;
        printf "         erwartet Urteil=%d Beleg=%d, bekommen Urteil=%d Beleg=%d%s\n",
            $soll_urteil, $soll_beleg, $ist_u, $ist_b,
            (defined $beleg ? " ($beleg)" : '')
            unless $ok;
    }
    printf "\n    %d von %d Faellen bestanden.\n\n", $gefahren - $fehler, $gefahren;
    return $fehler ? 1 : 0;
}

# ---------------------------------------------------------------------------
# Zeilen beschaffen
# ---------------------------------------------------------------------------
use FindBin;
require "$FindBin::Bin/entmojibaken.pl";
require "$FindBin::Bin/verweise-filtern.pl";

sub zeilen_aus_diff {
    my ($bereich) = @_;
    my $cmd = defined $bereich
            ? "git show $bereich --format= --unified=0 -- $DATEI 2>&1"
            : "git diff --cached -M --unified=0 -- $DATEI $ALTPFAD 2>&1";
    my @aus = `$cmd`;
    my (@neu, @alt);
    for my $z (@aus) {
        if    ($z =~ /^\+[^+]/) { (my $t=$z) =~ s/^\+//; $t =~ s/\r?\n$//; push @neu, $t; }
        elsif ($z =~ /^-[^-]/)  { (my $t=$z) =~ s/^-//;  $t =~ s/\r?\n$//; push @alt, $t; }
    }
    my @zuwachs = entmojibake_nur_kodierung_gefiltert(\@alt, \@neu);
    return verweise_nur_links_gefiltert(\@alt, \@zuwachs);
}

sub zeilen_aus_datei {
    my ($pfad) = @_;
    open my $F, '<:raw', $pfad or die "kann $pfad nicht lesen: $!\n";
    local $/;
    my $d = <$F>;
    close $F;
    return split /\n/, $d, -1;
}

# ---------------------------------------------------------------------------
# Hauptlauf
# ---------------------------------------------------------------------------
my ($modus, $wert) = ('gestaget', undef);
for (my $i = 0; $i < @ARGV; $i++) {
    if    ($ARGV[$i] eq '--selbsttest') { exit selbsttest(); }
    elsif ($ARGV[$i] eq '--commit')     { $modus = 'commit'; $wert = $ARGV[++$i]; }
    elsif ($ARGV[$i] eq '--datei')      { $modus = 'datei';  $wert = $ARGV[++$i]; }
    else { print "  unbekanntes Argument: $ARGV[$i]\n"; exit 2; }
}

my @zeilen = $modus eq 'datei'  ? zeilen_aus_datei($wert)
           : $modus eq 'commit' ? zeilen_aus_diff($wert)
           :                      zeilen_aus_diff(undef);

my (@ohne, @mit);
my $befundzeilen = 0;
for my $z (@zeilen) {
    my ($kennung, $urteil, $beleg) = beurteile($z);
    $befundzeilen++ if defined $kennung;
    next unless defined $urteil;
    if (defined $beleg) { push @mit,  [$kennung, $urteil, $beleg]; }
    else                { push @ohne, [$kennung, $urteil, $z];     }
}

printf "\n  %s\n  \"Original\"-Urteile mit Messung am Verhalten\n  %s\n",
       '-' x 60, '-' x 60;
printf "    Betriebsart                    %s\n", $modus;
printf "    angesehene Zeilen              %d\n", scalar @zeilen;
printf "    davon Befundzeilen             %d\n", $befundzeilen;
printf "    mit Original-Urteil            %d\n", scalar(@mit) + scalar(@ohne);
printf "    davon mit Beleg                %d\n", scalar @mit;
printf "    davon ohne Beleg               %d\n", scalar @ohne;

# Umfang 0 im Bestandsbetrieb heisst: das Muster trifft die Datei nicht mehr.
if ($modus eq 'datei' && $befundzeilen == 0) {
    print "\n  NICHTS GEPRUEFT - das ist kein gruenes Ergebnis. Keine einzige\n";
    print "  der vorgelegten Zeilen wurde als Befundzeile erkannt.\n\n";
    exit 1;
}

if (!@zeilen) {
    print "\n  Nichts zu pruefen: dieser Zuwachs enthaelt keine Zeile aus\n";
    print "  Intern/BEFUNDE.md. Das ist kein Urteil ueber die Datei.\n\n";
    exit 0;
}

for my $m (@mit) {
    printf "      %-8s %-20s %s\n", $m->[0], $m->[1], $m->[2];
}

if (@ohne) {
    print "\n  MANGEL:\n\n";
    for my $o (@ohne) {
        my $kurz = $o->[2];
        $kurz = substr($kurz, 0, 150) . ' ...' if length($kurz) > 150;
        printf "    - %s nennt \"%s\", ohne eine Messung am VERHALTEN\n",
               $o->[0], $o->[1];
        printf "      %s\n\n", $kurz;
    }
    print <<'ENDE';
  "Originalfehler" ist eine Aussage darueber, wie sich ein ANDERES
  Programm verhaelt. Der Quelltext allein belegt sie nicht: in einer
  Portierung ist die unveraenderte Quelle gerade der Ort, an dem sich
  Verhalten lautlos aendert - Compiler, MFC, Common Controls und
  Manifest sind mitgewandert, der Quelltext nicht.

  In dieselbe Spalte gehoert eines davon:

    - an einer aelteren eigenen Fassung gemessen und gleich vorgefunden
      ("auch an 7.2.0.88, C:\Temp\E118-0088, also ein Originalfehler")
    - am Original gemessen: Hermes, Eudora 7.1, der Originalbau
    - von Gregor am alten Programm bestaetigt
    - oder die Einschraenkung, die nichts Ungedecktes behauptet:
      "Quelltext original, Verhalten nicht gemessen"

  Am 21.10.2026 stand E-134 als "Originalverhalten" da. Belegt war,
  dass die //FORNOW-Kommentare aus dem initial commit stammen - eine
  Aussage ueber den Kommentar. Gregor: "was ist denn hier neu? in der
  alten hermes implementierung hat es ja funktioniert."

  Arbeitsweise/original-ist-eine-messung.md

ENDE
    exit 1;
}

print "\n  Jedes neue \"Original\"-Urteil nennt seine Messung.\n\n";
exit 0;
