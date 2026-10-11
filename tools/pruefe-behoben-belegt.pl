#!/usr/bin/perl
use strict;
use warnings;

# Liefert entmojibake_text() - siehe Kommentar in zeilen_aus_diff().
use FindBin;
require "$FindBin::Bin/entmojibaken.pl";

# pruefe-behoben-belegt.pl - ein neues "behoben" ohne Beleg wird abgewiesen.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 14.09.2026:
#
#   "wenn eine aufgabe erledigt ist, dann sollte diese auch als solche
#    gekennzeichnet werden."
#
# Und davor, am 13.09.2026, nachdem zweimal "behoben" gemeldet und Paket
# 1.0.51 ausgeliefert worden war, das den Fehler NICHT behob:
#
#   "das ist auf jeden fall eine frische mail, ist aber falsch dargestellt!"
#
# Der Wortlaut, der in BEFUNDE.md stand, waehrend das Paket unterwegs war:
#
#   "Alle drei Maengel behoben in 7.2.0.51 - aber die Behebung hat eine
#    Regression eingefuehrt, die noch offen ist ... Die ersten drei Punkte
#    sind am Quelltext belegt; von Gregor ist nichts davon am laufenden
#    Programm bestaetigt"
#
# Das Wort "bestaetigt" steht darin. VERNEINT. Eine Schranke, die nur nach
# dem Wort sucht, laesst genau diese Zeile durch - deshalb prueft diese hier
# das Umfeld vor dem Fund auf Verneinung.
#
# Lehre: Arbeitsweise/unterschied-im-selben-bild.md
#
# ---------------------------------------------------------------------------
# WAS GEPRUEFT WIRD - UND WAS BEWUSST NICHT
# ---------------------------------------------------------------------------
#
# Geprueft wird NUR der Zuwachs: die Zeilen, die dieser Commit in BEFUNDE.md
# neu einbringt oder aendert. Im Bestand stehen Dutzende alter Zeilen ohne
# Beleg; eine Schranke, die bei jedem Commit siebzigmal meckert, wird nach
# dem dritten Mal abgeschaltet (Lehre: schranke-gegentesten).
#
# Ein "offen"-Urteil wird nicht geprueft. Wer einen Befund oeffnet, schuldet
# keinen Beleg - wer ihn schliesst, schon.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-behoben-belegt.pl              # gestagte Aenderung
#   perl tools/pruefe-behoben-belegt.pl --commit ABC # ein Commit
#   perl tools/pruefe-behoben-belegt.pl --datei X.md # eine ganze Datei
#   perl tools/pruefe-behoben-belegt.pl --selbsttest
#
# Rueckgabe 0 = in Ordnung, 1 = Mangel.

my $DATEI = 'BEFUNDE.md';

# --- Woerter, die ein Urteil "erledigt" ausdruecken ------------------------
my @erledigt = ('behoben', 'erledigt', 'geschlossen');

# --- Belege, die zaehlen ---------------------------------------------------
#
# Jeder Eintrag: [Name fuer die Meldung, Muster].
my @belege = (
    ['von Gregor bestaetigt',
     qr/von\s+(?:Gregor|ihm)\b[^|]{0,70}?best(?:\xc3\xa4|ae)tigt/i],
    ['am laufenden Programm',
     qr/am\s+laufenden\s+Programm\s+(?:gemessen|belegt|best(?:\xc3\xa4|ae)tigt|gepr(?:\xc3\xbc|ue)ft)/i],
    # Protokoll oder Spurmarke - und dahinter entweder ein messendes Verb
    # oder ein abgelesener Wert in Ruecklaufform (`uebersetzt=ja`).
    #
    # WARUM DER WERT NICHT ALLEIN ZAEHLT: der erste Entwurf hatte
    # `[A-Za-z_]+=\S+` als eigenstaendigen Beleg. Damit lief ausgerechnet
    # 48c1ee2 durch - die E-85-Zeile, um derentwillen es diese Schranke
    # gibt. Sie nennt `charset=utf-8`, einen MIME-Parameter im Fliesstext,
    # der wie eine Protokollzeile aussieht. Ein Wert ist erst ein Messwert,
    # wenn danebensteht, dass jemand ihn abgelesen hat.
    ['im Protokoll belegt',
     qr/(?:im\s+Protokoll|Protokollzeile|Spurmarke|Gregors\s+Lauf)\b[^|]{0,120}?(?:belegt|gemessen|zeigt|nennt|meldet|`[^`|]*[A-Za-z_][A-Za-z_0-9-]*=[^`|\s()]+[^`|]*`)/i],
    ['Testlauf mit Zahlen',
     qr/\b\d+\s+Tests?\b[^.|]{0,40}?\b\d+\s+bestanden/i],
);

# --- Verneinungen, die einen Beleg entwerten -------------------------------
#
# Sie werden im Umfeld VOR dem Fund gesucht. "von Gregor ist nichts davon am
# laufenden Programm bestaetigt" enthaelt den Beleg woertlich - und ist das
# Gegenteil einer Bestaetigung.
my @verneinung = (
    'nicht', 'nichts', 'kein', 'keine', 'keiner', 'keinerlei',
    'ohne', 'steht aus', 'ausstehend', 'fehlt',
);

my $UMFELD = 45;   # Zeichen vor dem Fund, in denen eine Verneinung zaehlt

# ---------------------------------------------------------------------------
# Kern: eine einzelne Zeile beurteilen
# ---------------------------------------------------------------------------
#
# Rueckgabe: (Kennung, Urteil, Belegname oder undef)
#   Urteil: 'erledigt' | 'offen' | 'keins'
sub beurteile {
    my ($zeile) = @_;

    return (undef, 'keins', undef)
        unless $zeile =~ /^\|\s*\*{0,2}([A-Za-z]{1,3}\d*-[0-9a-z]+)\*{0,2}\s*\|/;
    my $kennung = $1;

    my @spalten = split /\|/, $zeile, -1;
    return ($kennung, 'keins', undef) unless @spalten >= 4;
    my $urteilstext = $spalten[3];

    # Das Urteil steht im ERSTEN Fettdruck der dritten Spalte - dieselbe
    # Regel wie in pruefe-befundurteile.pl. Ohne Fettdruck: der Anfang.
    #
    # BERICHTIGT AM 18.09.2026 (PRUEFER-17, Befund E-109): hier stand
    #
    #     /\*\*([^*]{1,80})\*\*/
    #
    # Die Laengengrenze macht das Muster nicht enger, sondern VERSCHIEBT es.
    # Ist der erste Fettdruck laenger als 80 Zeichen, passt er nicht - und
    # der Regexmotor sucht weiter, bis er IRGENDEINEN kuerzeren findet.
    # Gelesen wird dann ein ganz anderes Stueck Text, meistens weiter hinten
    # und ohne das Urteilswort. Folge: ein behobener Befund gilt als offen
    # und wird gar nicht mehr auf seinen Beleg geprueft - und die Schranke
    # meldet trotzdem gruen, weil sie ihn nur in der anderen Spalte zaehlt.
    # Gemessen an E-108, dessen Urteilskopf 96 Zeichen hat.
    #
    # Jetzt: der erste Fettdruck, wie lang er auch ist. Wo keiner steht,
    # weiterhin der Anfang der Spalte.
    my $kopf = ($urteilstext =~ /\*\*([^*]+)\*\*/)
             ? $1
             : substr($urteilstext, 0, 80);

    my $ist_erledigt = 0;
    for my $w (@erledigt) {
        $ist_erledigt = 1 if index(lc $kopf, $w) >= 0;
    }
    return ($kennung, 'offen', undef) unless $ist_erledigt;

    # Der Beleg darf irgendwo in der Urteilsspalte stehen, nicht nur im Kopf.
    for my $b (@belege) {
        my ($name, $muster) = @$b;
        while ($urteilstext =~ /$muster/g) {
            my $start   = $-[0];
            my $ende    = $+[0];
            my $treffer = substr($urteilstext, $start, $ende - $start);
            my $vor     = substr($urteilstext, ($start > $UMFELD ? $start - $UMFELD : 0),
                                 ($start > $UMFELD ? $UMFELD : $start));
            # Die Verneinung steht meistens IM Fund, nicht davor:
            # "von Gregor ist nichts davon am laufenden Programm bestaetigt"
            # und "von Gregor noch nicht bestaetigt" sind beide vollstaendige
            # Treffer des Musters. Deshalb wird Umfeld UND Fund geprueft.
            next if verneint($vor . ' ' . $treffer);
            return ($kennung, 'erledigt', $name);
        }
    }

    return ($kennung, 'erledigt', undef);
}

sub verneint {
    my ($vor) = @_;
    my $v = lc $vor;
    for my $w (@verneinung) {
        # Wortgrenze, damit "keine" nicht in "Bekeine" trifft und
        # "nicht" nicht in "vernichtet".
        return 1 if $v =~ /(?:^|[^a-z\xc3\xa4\xc3\xb6\xc3\xbc])\Q$w\E(?:[^a-z]|$)/;
    }
    return 0;
}

# ---------------------------------------------------------------------------
# Selbsttest - zehn Faelle, in beide Richtungen
# ---------------------------------------------------------------------------
sub selbsttest {
    my @faelle = (
        # [Name, Zeile, erwartetes Urteil, Beleg erwartet?]
        ['E-85 wie es dastand: "von Gregor ist nichts ... bestaetigt"',
         '| E-85 | Umlaute | **Alle drei M' . "\xc3\xa4" . 'ngel behoben in 7.2.0.51** - die ersten drei Punkte sind am Quelltext belegt; von Gregor ist nichts davon am laufenden Programm best' . "\xc3\xa4" . 'tigt |',
         'erledigt', 0],

        ['E-83 wie es jetzt dasteht: am laufenden Programm gemessen',
         '| E-83 | Beenden | **behoben** in 7.2.0.53, **am laufenden Programm gemessen** (14.09.2026) |',
         'erledigt', 1],

        ['behoben mit Spurmarken-Messwert',
         '| E-85 | Umlaute | **behoben in 7.2.0.52**, Spurmarke: `uebersetzt=ja` |',
         'erledigt', 1],

        ['behoben, von Gregor bestaetigt',
         '| E-76 | Fenster | **behoben** - von Gregor am 12.09.2026 best' . "\xc3\xa4" . 'tigt |',
         'erledigt', 1],

        ['behoben ohne jeden Beleg - muss abgewiesen werden',
         '| E-99 | irgendwas | **behoben** in 7.2.0.60 |',
         'erledigt', 0],

        ['behoben, aber Bestaetigung steht noch aus',
         '| E-98 | irgendwas | **behoben** in 7.2.0.60, von Gregor noch nicht best' . "\xc3\xa4" . 'tigt |',
         'erledigt', 0],

        ['offen - wird gar nicht geprueft',
         '| E-77 | Postfachnamen | **offen**, modifiziertes UTF-7 |',
         'offen', 0],

        ['keine Befundzeile',
         '| Kriterium | Stand | **behoben** |',
         'keins', 0],

        ['behoben mit Testlauf',
         '| NP3-8 | Zeichensatz | **behoben** in 7.2.0.52, Testlauf: 121 Tests, 121 bestanden |',
         'erledigt', 1],

        # Der Fehlalarm, den der Gegentest an 48c1ee2 gefunden hat: ein
        # MIME-Parameter im Fliesstext sieht aus wie eine Protokollzeile.
        ['behoben, dazu `charset=utf-8` im Fliesstext - KEIN Messwert',
         '| E-85 | Umlaute | **behoben in 7.2.0.51** - die Stelle erkannte `charset=utf-8` gar nicht; am Quelltext belegt |',
         'erledigt', 0],

        # DER FEHLER, DER AM 18.09.2026 GEMESSEN WURDE (E-109, PRUEFER-17).
        #
        # Der erste Fettdruck ist 104 Zeichen lang. Das alte Muster
        # \*\*([^*]{1,80})\*\* passte darauf nicht und sprang zum NAECHSTEN
        # Fettdruck weiter - hier "**Bilder**". Der gelesene Urteilskopf war
        # damit "Bilder", das Wort "behoben" kam darin nicht vor, und der
        # Befund galt als OFFEN. Ein behobener Befund wurde also nie auf
        # seinen Beleg geprueft, und die Schranke meldete gruen.
        ['Urteilskopf laenger als 80 Zeichen, danach ein kurzer Fettdruck',
         '| E-108 | Absturz | **behoben in 7.2.0.72, von Gregor am laufenden Programm best'
         . "\xc3\xa4" . 'tigt am 17.09.2026 um 21:40 Uhr** - siehe **Bilder** im Anhang |',
         'erledigt', 1],

        # Gegenrichtung: ein langer erster Fettdruck, der OFFEN sagt, darf
        # nicht ploetzlich als erledigt gelten, nur weil weiter hinten ein
        # kurzer Fettdruck mit "behoben" steht.
        ['langer Urteilskopf sagt OFFEN, spaeter steht **behoben**',
         '| E-98 | Etwas | **offen, und zwar seit dem 12.09.2026 - die Ursache liegt nicht dort, wo sie zuerst vermutet wurde** - anders als **behoben** |',
         'offen', 0],
    );

    my $fehler = 0;
    printf "\n  %s\n  %s\n  %s\n", '-' x 66, 'pruefe-behoben-belegt --selbsttest', '-' x 66;
    for my $f (@faelle) {
        my ($name, $zeile, $soll_urteil, $soll_beleg) = @$f;
        my ($k, $urteil, $beleg) = beurteile($zeile);
        my $ist_beleg = defined($beleg) ? 1 : 0;
        my $ok = ($urteil eq $soll_urteil) && ($ist_beleg == $soll_beleg);
        $fehler++ unless $ok;
        printf "    %-4s %s\n", ($ok ? 'ok' : 'FEHL'), $name;
        printf "         erwartet %s/%s, bekommen %s/%s%s\n",
            $soll_urteil, ($soll_beleg ? 'Beleg' : 'ohne'),
            $urteil, ($ist_beleg ? 'Beleg' : 'ohne'),
            (defined $beleg ? " ($beleg)" : '')
            unless $ok;
    }
    printf "\n    %d von %d Faellen bestanden.\n\n", scalar(@faelle) - $fehler, scalar(@faelle);
    return $fehler ? 1 : 0;
}

# ---------------------------------------------------------------------------
# Zeilen beschaffen
# ---------------------------------------------------------------------------
sub zeilen_aus_diff {
    my ($bereich) = @_;
    my $cmd = defined $bereich
            ? "git show --format= --unified=0 -- $DATEI $bereich 2>&1"
            : "git diff --cached --unified=0 -- $DATEI 2>&1";
    # git show braucht den Commit VOR dem Pfadtrenner
    if (defined $bereich) {
        $cmd = "git show $bereich --format= --unified=0 -- $DATEI 2>&1";
    }
    my @aus = `$cmd`;
    my (@neu, @alt);
    for my $z (@aus) {
        if ($z =~ /^\+[^+]/) {
            (my $t = $z) =~ s/^\+//; $t =~ s/\r?\n$//; push @neu, $t;
        }
        elsif ($z =~ /^-[^-]/) {
            (my $t = $z) =~ s/^-//;  $t =~ s/\r?\n$//; push @alt, $t;
        }
    }

    # Eine Zeile, die sich NUR in der Kodierung geaendert hat, ist kein
    # Zuwachs. Am 14.09.2026 hat die Berichtigung von 1517 doppelt
    # umkodierten Zeilen in BEFUNDE.md diese Schranke 46-mal ausgeloest,
    # obwohl kein einziges Urteil neu geschrieben wurde - es waren die
    # alten Zeilen aus dem Bestand, die der Kommentar oben ausdruecklich
    # in Ruhe lassen will. Darum wird jede entfernte Zeile entmojibakt
    # und gegen die hinzugefuegten gehalten.
    return entmojibake_nur_kodierung_gefiltert(\@alt, \@neu);
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
    else { die "unbekanntes Argument: $ARGV[$i]\n"; }
}

my @zeilen = $modus eq 'datei'  ? zeilen_aus_datei($wert)
           : $modus eq 'commit' ? zeilen_aus_diff($wert)
           :                      zeilen_aus_diff(undef);

my (@ohne_beleg, @mit_beleg);
my $befundzeilen = 0;
for my $z (@zeilen) {
    my ($kennung, $urteil, $beleg) = beurteile($z);
    $befundzeilen++ if $urteil ne 'keins';
    next unless $urteil eq 'erledigt';
    if (defined $beleg) { push @mit_beleg,  [$kennung, $beleg]; }
    else                { push @ohne_beleg, [$kennung, $z];     }
}

# DER PRUEFUMFANG GEHOERT IN DIE AUSGABE (E-109, Punkt 4).
#
# Bis zum 18.09.2026 stand hier nur "geprueft (neu oder geaendert)", und das
# zaehlte NICHT den Umfang, sondern nur die Teilmenge der erledigt-Urteile.
# Ein Lauf ueber 0 Zeilen und ein Lauf ueber 7800 Zeilen ohne Fund sahen
# identisch aus - beide meldeten "Jedes neue behoben nennt seinen Beleg."
printf "\n  %s\n  behoben-Urteile mit Beleg\n  %s\n", '-' x 60, '-' x 60;
printf "    Betriebsart                    %s\n", $modus;
printf "    angesehene Zeilen              %d\n", scalar @zeilen;
printf "    davon Befundzeilen             %d\n", $befundzeilen;
printf "    mit Urteil \"behoben\"           %d\n", scalar(@mit_beleg) + scalar(@ohne_beleg);
printf "    mit Beleg                      %d\n", scalar @mit_beleg;
printf "    ohne Beleg                     %d\n", scalar @ohne_beleg;

# UMFANG 0 - und was das je nach Betriebsart bedeutet.
#
# Im Diff-Betrieb ist 0 der NORMALFALL: die meisten Commits fassen BEFUNDE.md
# nicht an. Das darf nicht abweisen, sonst ist jeder Commit blockiert. Es darf
# aber auch nicht wie ein bestandenes Urteil klingen - deshalb ein eigener
# Satz statt des Erfolgssatzes.
#
# Im Bestandsbetrieb (--datei) ist 0 ein FEHLER: dort wird die ganze Datei
# vorgelegt. Findet die Schranke darin keine einzige Befundzeile, dann passt
# ihr Muster nicht mehr zum Format der Datei - sie ist blind, und genau das
# beschreibt E-109, Punkt (4): ein Freispruch ueber die leere Menge.
if ($modus eq 'datei' && $befundzeilen == 0) {
    printf <<"ENDE", scalar @zeilen;
\n  NICHTS GEPRUEFT - das ist kein gruenes Ergebnis.

  Vorgelegt wurden %d Zeile(n), und keine einzige davon hat die Schranke als
  Befundzeile erkannt. Entweder ist die Datei leer, oder das Format hat sich
  geaendert und das Muster in beurteile() trifft es nicht mehr.

  E-109, Punkt 4: "geprueft und frei" und "nichts gefunden zu pruefen"
  duerfen nicht gleich aussehen.

ENDE
    exit 1;
}

if (!@zeilen) {
    print "\n  Nichts zu pruefen: dieser Zuwachs enthaelt keine Zeile aus\n";
    print "  BEFUNDE.md. Das ist kein Urteil ueber die Datei.\n\n";
    exit 0;
}

for my $m (@mit_beleg) {
    printf "      %-8s %s\n", $m->[0], $m->[1];
}

if (@ohne_beleg) {
    print "\n  MANGEL:\n\n";
    for my $o (@ohne_beleg) {
        my $kurz = $o->[1];
        $kurz = substr($kurz, 0, 150) . ' ...' if length($kurz) > 150;
        printf "    - %s erklaert sich fuer behoben, ohne zu sagen, WORAN\n", $o->[0];
        printf "      %s\n\n", $kurz;
    }
    print <<'ENDE';
  Ein "behoben" braucht eine der folgenden Angaben in derselben Spalte:

    - von Gregor ... bestaetigt
    - am laufenden Programm gemessen / belegt / geprueft
    - im Protokoll belegt, oder eine Spurmarke, die es zeigt
    - ein Messwert in Ruecklaufform, etwa `uebersetzt=ja`
    - ein Testlauf mit Zahlen, etwa "121 Tests, 121 bestanden"

  VERNEINT zaehlt nicht. "von Gregor ist nichts davon am laufenden
  Programm bestaetigt" - genau der Wortlaut, mit dem E-85 einen Tag lang
  als behoben dastand, waehrend Paket 1.0.51 den Fehler noch hatte.

  Gregor am 14.09.2026: "wenn eine aufgabe erledigt ist, dann sollte
  diese auch als solche gekennzeichnet werden." Das gilt in beide
  Richtungen: was nicht belegt erledigt ist, wird nicht so gekennzeichnet.

ENDE
    exit 1;
}

print "\n  Jedes neue \"behoben\" nennt seinen Beleg.\n\n";
exit 0;
