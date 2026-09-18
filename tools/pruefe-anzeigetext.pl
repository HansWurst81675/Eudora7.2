#!/usr/bin/perl
use strict;
use warnings;

# Liefert entmojibake_nur_kodierung_gefiltert().
use FindBin;
require "$FindBin::Bin/entmojibaken.pl";

# pruefe-anzeigetext.pl - ein zitierter Oberflaechentext ist eine Behauptung
# des Programms ueber sich selbst, kein Messwert.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# E-83 stand vom 11.09.2026 bis zum 14.09.2026 unter der Ueberschrift
#
#   "eine IMAP-Aufgabe bleibt in der Warteschlange stehen und WIRD NIE
#    GESTARTET"
#
# Die drei Woerter "wird nie gestartet" standen nicht im Bild. Sie waren die
# Schlussfolgerung aus dem Wort "waiting" in
#
#   "Waiting in the task queue to be started ..."
#
# Damit war die Ursachenliste festgelegt: CanScheduleTask, DelayTasks/
# StartTasks, MaxConcurrentTasks, StartWorkerThread - alle vier liegen im
# STARTWEG. Keiner lag dort, wo der Fehler war. Die Spurmarke sagte es am
# 14.09.2026 in einer Zeile:
#
#   E-83 liegengeblieben: uid=35 zustand=FERTIG(5) m_pThread=gesetzt
#
# Die Aufgabe wartete nicht. Sie war fertig. Der Text stammt aus Register()
# und wird nie ueberschrieben - eine laufende, eine haengende und eine
# laengst fertige Aufgabe sehen in diesem Fenster IDENTISCH aus.
#
# Das war ein grep. Er kostet einen Werkzeugaufruf.
#
# Lehre: Arbeitsweise/anzeige-ist-kein-zustand.md
#
# ---------------------------------------------------------------------------
# WAS VERLANGT WIRD
# ---------------------------------------------------------------------------
#
# Zitiert eine Befundzeile einen ENGLISCHEN Oberflaechentext, muss dieselbe
# Zeile sagen, WOHER er kommt: eine Fundstelle (datei.cpp:NNN) und eine
# Aussage darueber, wer ihn setzt bzw. dass ihn niemand ueberschreibt.
#
#   gut:  "Waiting in the task queue ..." - stammt aus Register()
#         (QCTaskManager.cpp:186), wird nie ueberschrieben
#   schlecht: "Waiting in the task queue ..." - die Aufgabe wird nie gestartet
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-anzeigetext.pl              # gestagte Aenderung
#   perl tools/pruefe-anzeigetext.pl --commit ABC
#   perl tools/pruefe-anzeigetext.pl --datei BEFUNDE.md   # ganzer Bestand
#   perl tools/pruefe-anzeigetext.pl --selbsttest
#
# Rueckgabe 0 = in Ordnung, 1 = Mangel.

my $DATEI = 'BEFUNDE.md';

# --- Woerter, an denen ein englischer Oberflaechentext erkannt wird --------
#
# BEWUSST GEKUERZT. Der erste Entwurf hatte "in" und "mailbox" dabei und hat
# damit E-64 angeschwaerzt - ein DEUTSCHES Gregor-Zitat ("... in die falsche
# mailbox ..."). Ein Erkennungswort, das es in beiden Sprachen gibt, erkennt
# keine Sprache.
my @englisch = qw(
    the you your currently waiting running unavailable cannot
    encountered improper during queue started have been this
    message could would should please select folder
);

my $MINDEST_TREFFER = 2;    # so viele Woerter muessen zusammenkommen
my $MAX_LAENGE      = 120;  # laengeres Zitat ist ein Absatz, keine Anzeige

# --- Angaben, die die Herkunft belegen ------------------------------------
my $FUNDSTELLE = qr/\b[A-Za-z_][A-Za-z_0-9]*\.(?:cpp|h|rc)\s*:\s*\d+/;
my @herkunft = (
    'stammt aus', 'gesetzt in', 'setzt ihn', 'setzt den text',
    'wird nie', 'nie ' . "\xc3\xbc" . 'berschrieben', 'nie ueberschrieben',
    'geschrieben in', 'einmal beim', 'wird gesetzt',
);

# ---------------------------------------------------------------------------
# Zitate aus einer Zeile holen
# ---------------------------------------------------------------------------
#
# BEFUNDE.md benutzt deutsche typografische Anfuehrungszeichen (UTF-8
# E2 80 9E ... E2 80 9C), gelegentlich aber auch gerade. Beide Formen werden
# gelesen - der erste Selbsttest war gruen, waehrend die Schranke am echten
# Eintrag stumm blieb, weil mein Testfall typografisch schloss und
# BEFUNDE.md gerade.
sub zitate {
    my ($zeile) = @_;
    my @z;
    while ($zeile =~ /\xe2\x80\x9e(.{3,400}?)(?:\xe2\x80\x9c|\xe2\x80\x9d|")/gs) {
        push @z, $1;
    }
    while ($zeile =~ /"([^"|]{3,400}?)"/g) {
        push @z, $1;
    }
    return @z;
}

sub ist_anzeigetext {
    my ($z) = @_;

    # Ein Quelltextkommentar ist keine Oberflaeche. E-85 zitiert einen
    # Kommentar mit "TextReader::ReadIt is now making sure ..." - englisch,
    # aber niemand sieht ihn im Programm.
    return 0 if $z =~ /::/;

    # Ein langes Zitat ist ein Absatz, kein Meldungstext.
    return 0 if length($z) > $MAX_LAENGE;

    my $l = lc $z;
    my $treffer = 0;
    for my $w (@englisch) {
        $treffer++ if $l =~ /(?:^|[^a-z])\Q$w\E(?:[^a-z]|$)/;
    }
    return $treffer >= $MINDEST_TREFFER ? 1 : 0;
}

sub hat_herkunft {
    my ($zeile) = @_;
    return 0 unless $zeile =~ $FUNDSTELLE;
    my $l = lc $zeile;
    for my $h (@herkunft) {
        return 1 if index($l, lc $h) >= 0;
    }
    return 0;
}

# Rueckgabe: (Kennung, Zitat) wenn ein Mangel vorliegt, sonst ()
sub beurteile {
    my ($zeile) = @_;
    return () unless $zeile =~ /^\|\s*\*{0,2}([A-Za-z]{1,3}\d*-[0-9a-z]+)\*{0,2}\s*\|/;
    my $kennung = $1;

    for my $z (zitate($zeile)) {
        next unless ist_anzeigetext($z);
        return ($kennung, $z) unless hat_herkunft($zeile);
        return ();   # ein belegtes Zitat deckt die Zeile
    }
    return ();
}

# ---------------------------------------------------------------------------
# Selbsttest - sieben Faelle, in beide Richtungen
# ---------------------------------------------------------------------------
sub selbsttest {
    my $Z = "\xe2\x80\x9e";   # oeffnendes deutsches Anfuehrungszeichen
    my $E = "\xe2\x80\x9c";   # schliessendes

    my @faelle = (
        ['E-83 wie es dastand - Zitat ohne Herkunft, muss abweisen',
         '| E-83 | eine IMAP-Aufgabe bleibt stehen - *' . $Z . 'Waiting in the task queue to be started ...' . $E . '* | **offen**, wird nie gestartet |',
         1],

        ['E-83 mit Herkunft - laeuft durch',
         '| E-83 | *' . $Z . 'Waiting in the task queue to be started ...' . $E . '* | **behoben** - der Text stammt aus `Register()` (`QCTaskManager.cpp:186`) und wird nie ueberschrieben |',
         0],

        ['gerade schliessendes Anfuehrungszeichen wird auch erkannt',
         '| E-83 | *' . $Z . 'You currently have 1 task(s) running"* | **offen** |',
         1],

        ['Fehlalarm E-64: deutsches Gregor-Zitat',
         '| E-64 | ein Filterlauf verschob alle Nachrichten | **behoben** - Gregor: *' . $Z . 'der filter hat alles in die falsche mailbox geschoben, das war ein fehler in der schleife' . $E . '* |',
         0],

        ['Fehlalarm E-85: Quelltextkommentar mit ::',
         '| E-85 | Umlaute | **behoben** - der Kommentar sagt es woertlich: *' . $Z . 'TextReader::ReadIt is now making sure that it leaves space at the end' . $E . '* |',
         0],

        ['langes englisches Zitat ist ein Absatz, keine Anzeige',
         '| E-99 | irgendwas | **offen** - aus der Vorlage: *' . $Z . 'the message you have selected could not be displayed because the folder you have selected is currently unavailable and this would have been reported' . $E . '* |',
         0],

        ['keine Befundzeile',
         '| Kriterium | *' . $Z . 'You currently have 1 task(s) running' . $E . '* | offen |',
         0],
    );

    my $fehler = 0;
    printf "\n  %s\n  %s\n  %s\n", '-' x 66, 'pruefe-anzeigetext --selbsttest', '-' x 66;
    for my $f (@faelle) {
        my ($name, $zeile, $soll) = @$f;
        my @m  = beurteile($zeile);
        my $ist = @m ? 1 : 0;
        my $ok = ($ist == $soll);
        $fehler++ unless $ok;
        printf "    %-4s %s\n", ($ok ? 'ok' : 'FEHL'), $name;
        printf "         erwartet %s, bekommen %s%s\n",
            ($soll ? 'MANGEL' : 'in Ordnung'), ($ist ? 'MANGEL' : 'in Ordnung'),
            (@m ? " (Zitat: $m[1])" : '') unless $ok;
    }
    printf "\n    %d von %d Faellen bestanden.\n\n", scalar(@faelle) - $fehler, scalar(@faelle);
    return $fehler ? 1 : 0;
}

# ---------------------------------------------------------------------------
sub zeilen_aus_diff {
    my ($bereich) = @_;
    my $cmd = defined $bereich
            ? "git show $bereich --format= --unified=0 -- $DATEI 2>&1"
            : "git diff --cached --unified=0 -- $DATEI 2>&1";
    my (@neu, @alt);
    for my $z (`$cmd`) {
        if ($z =~ /^\+[^+]/) {
            (my $t = $z) =~ s/^\+//; $t =~ s/\r?\n$//; push @neu, $t;
        }
        elsif ($z =~ /^-[^-]/) {
            (my $t = $z) =~ s/^-//;  $t =~ s/\r?\n$//; push @alt, $t;
        }
    }
    # Eine rein umkodierte Zeile ist kein Zuwachs - siehe Kommentar bei
    # entmojibake_nur_kodierung_gefiltert() in entmojibaken.pl.
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

my (@mangel, %gesehen);
my ($befundzeilen, $zitatzeilen) = (0, 0);
for my $z (@zeilen) {
    $befundzeilen++ if $z =~ /^\|\s*\*{0,2}([A-Za-z]{1,3}\d*-[0-9a-z]+)\*{0,2}\s*\|/;
    $zitatzeilen++  if zitate($z);
    my @m = beurteile($z);
    next unless @m;
    next if $gesehen{$m[0]}++;
    push @mangel, \@m;
}

# DER PRUEFUMFANG GEHOERT IN DIE AUSGABE (E-109, Punkt 4).
#
# Bis zum 18.09.2026 stand hier nur "gepruefte Zeilen 0 / Zitate ohne
# Herkunftsangabe 0" und darunter der Erfolgssatz "Jeder zitierte
# Oberflaechentext nennt seine Herkunft." Ein Lauf, der NICHTS angesehen hat,
# sah damit genauso aus wie einer, der alles geprueft und nichts gefunden hat.
printf "\n  %s\n  Zitierte Oberflaechentexte mit Herkunft\n  %s\n", '-' x 60, '-' x 60;
printf "    Betriebsart                    %s\n", $modus;
printf "    angesehene Zeilen              %d\n", scalar @zeilen;
printf "    davon Befundzeilen             %d\n", $befundzeilen;
printf "    davon mit einem Zitat          %d\n", $zitatzeilen;
printf "    Zitate ohne Herkunftsangabe    %d\n", scalar @mangel;

# Im Bestandsbetrieb (--datei) wird die ganze Datei vorgelegt. Findet die
# Schranke darin keine einzige Befundzeile, passt ihr Muster nicht mehr zum
# Format - sie ist blind. Im Diff-Betrieb ist 0 dagegen der Normalfall und
# darf nicht abweisen; er bekommt nur einen eigenen Satz statt des
# Erfolgssatzes.
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

if (@mangel) {
    print "\n  MANGEL:\n\n";
    for my $m (@mangel) {
        printf "    - %s zitiert einen Oberflaechentext, ohne zu sagen, woher er kommt\n", $m->[0];
        printf "      \"%s\"\n\n", $m->[1];
    }
    print <<'ENDE';
  Ein zitierter Oberflaechentext braucht in derselben Zeile eine
  Fundstelle (datei.cpp:NNN) und eine Aussage darueber, wer ihn setzt -
  zum Beispiel:

      stammt aus `Register()` (`QCTaskManager.cpp:186`), wird nie
      ueberschrieben

  Warum: "Waiting in the task queue to be started ..." stand drei Tage
  lang in der Ueberschrift von E-83 und hat vier Verdaechte im STARTWEG
  erzeugt. Die Aufgabe wartete nie - sie war fertig. Der Text wird
  einmal beim Eintragen gesetzt und nie wieder angefasst; eine laufende,
  eine haengende und eine fertige Aufgabe sehen identisch aus.

  Was gefolgert ist, gehoert in die Ursachenliste, wo es widerlegt
  werden kann - nicht in die Ueberschrift, wo es zur Voraussetzung wird.

ENDE
    exit 1;
}

print "\n  Jeder zitierte Oberflaechentext nennt seine Herkunft.\n\n";
exit 0;
