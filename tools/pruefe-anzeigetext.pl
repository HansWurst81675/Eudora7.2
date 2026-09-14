#!/usr/bin/perl
use strict;
use warnings;

# pruefe-anzeigetext.pl - ein angezeigter Text ist kein gemessener Zustand.
#
# WARUM ES DAS GIBT
#
# Befund E-83 stand vom 11.09.2026 bis zum 14.09.2026 offen. Seine
# Ueberschrift kam aus Eudoras eigenem Aufgabenfenster:
#
#   "eine IMAP-Aufgabe bleibt in der Warteschlange stehen und wird nie
#    gestartet - 'Waiting in the task queue to be started ...'"
#
# Danach wurde drei Tage lang ein STARTPROBLEM gesucht: CanScheduleTask,
# DelayTasks/StartTasks, MaxConcurrentTasks, ein NULL-Faden in
# StartWorkerThread. Eine der drei "ausgeschlossenen Ursachen" war dabei
# falsch ausgeschlossen.
#
# Am 14.09.2026 sagte die Spurmarke in einer Zeile:
#
#   E-83 liegengeblieben: uid=35 zustand=FERTIG(5) m_pThread=gesetzt aktiv=1/10
#
# Die Aufgabe wartete gar nicht. Sie war FERTIG. Der Text wird in Register()
# EINMAL beim Eintragen gesetzt und danach von niemandem ueberschrieben - er
# ist ein Etikett aus der Vergangenheit, keine Zustandsanzeige. Das Startthema
# hat es nie gegeben.
#
# WAS GEPRUEFT WIRD
#
# Zitiert eine Befundzeile einen Text aus der Programmoberflaeche, muss
# dieselbe Zeile sagen, WO er gesetzt wird und OB ihn jemand ueberschreibt.
# Anerkannt sind:
#
#   "gesetzt in", "stammt aus", "wird gesetzt", "nie ueberschrieben",
#   "nie ueberschrieben" mit Umlaut, "beweist nichts", "Anzeigetext geprueft"
#
# Ohne diese Angabe ist der zitierte Text eine Behauptung des Programms ueber
# sich selbst, und die Suchrichtung steht auf einer ungeprueften Quelle.
#
# GEPRUEFT WIRD NUR, WAS NEU GESCHRIEBEN WIRD - aus demselben Grund wie bei
# tools/pruefe-behoben-belegt.pl: eine Schranke, die den Altbestand meldet,
# wird abgeschaltet (Arbeitsweise/schranke-gegentesten.md).
#
# Aufruf:
#   perl tools/pruefe-anzeigetext.pl              # nur neue Zeilen, weist ab
#   perl tools/pruefe-anzeigetext.pl --nur-melden # exit 0, nur Bericht
#   perl tools/pruefe-anzeigetext.pl --alle       # der ganze Bestand
#   perl tools/pruefe-anzeigetext.pl --datei X    # eine andere Datei
#   perl tools/pruefe-anzeigetext.pl --selbsttest # Gegenproben
#
# Kodierung: reines ASCII, kein BOM, reine LF.

my $nur_melden = 0;
my $selbsttest = 0;
my $alle       = 0;
my $datei;
my @rest = @ARGV;
while (@rest) {
    my $a = shift @rest;
    if    ($a eq '--nur-melden') { $nur_melden = 1; }
    elsif ($a eq '--selbsttest') { $selbsttest = 1; }
    elsif ($a eq '--alle')       { $alle = 1; }
    elsif ($a eq '--datei')      { $datei = shift @rest; }
    else { die "pruefe-anzeigetext.pl: unbekannter Schalter '$a'\n"; }
}

# Woerter, an denen ein englischer Oberflaechentext zu erkennen ist. Gregors
# eigene Zitate sind deutsch und fallen nicht darunter - das ist der Zweck.
# Woerter, an denen ein englischer Oberflaechentext zu erkennen ist. Gregors
# eigene Zitate sind deutsch und fallen nicht darunter - das ist der Zweck.
#
# Bewusst NICHT in der Liste: in, of, for, from, with, no, now, man, file,
# server, start, status, mailbox. Sie kommen auch in deutschen Saetzen vor.
# Gemessen am Bestand: mit ihnen schlug die Schranke bei E-64 an, einem
# deutschen Gregor-Zitat ("... dann werden ALLE (!) mails verschoben.").
my @ENGLISCH = qw(
    the to be is are was were you your currently have has had cannot could
    please waiting running started task tasks message messages
    error failed unable exception occurred downloading download
    queue updating checking sending receiving connection
    there this that does doesn't didn't will would should
);
my %ENGLISCH = map { $_ => 1 } @ENGLISCH;

# Angaben, die einen zitierten Oberflaechentext auf seine Quelle zurueckfuehren.
my @QUELLE = (
    qr/gesetzt\s+in/i,
    qr/stammt\s+aus/i,
    qr/wird\s+gesetzt/i,
    qr/nie\s+.{0,3}berschrieben/i,
    qr/nicht\s+.{0,3}berschrieben/i,
    qr/beweist\s+nichts/i,
    qr/Anzeigetext\s+gepr.{0,3}ft/i,
);

# Zitate herausloesen.
#
# ACHTUNG, das hat die Schranke beim ersten Anlauf stumm gemacht: in
# BEFUNDE.md wird typografisch GEOEFFNET und gerade GESCHLOSSEN -
# U+201E ... ASCII 0x22. Der echte E-83-Eintrag vom 11.09.2026 sieht so aus:
#
#   E2 80 9E "Waiting in the task queue to be started" E2 80 A6 22
#
# Eine Regel, die beide Seiten typografisch verlangt, findet dort nichts und
# meldet "alles in Ordnung". Deshalb ist jede Seite eine Alternative.
# (Arbeitsweise/messung-muss-den-weg-treffen.md)
my $AUF = qr/(?:\xe2\x80\x9e|\xe2\x80\x9c|")/;
my $ZU  = qr/(?:\xe2\x80\x9c|\xe2\x80\x9d|")/;

sub zitate {
    my ($zeile) = @_;
    my @z;
    while ($zeile =~ /$AUF(.{5,200}?)$ZU/g) { push @z, $1; }
    return @z;
}

sub ist_oberflaechentext {
    my ($t) = @_;
    # Typografische Auslassungspunkte und Gedankenstriche gehoeren zur
    # Zitierweise, nicht zum Text. Ohne diesen Schritt fiel E-83 durch:
    # sein Zitat endet mit U+2026 und ist damit nicht mehr reines ASCII.
    $t =~ s/\xe2\x80\xa6//g;
    $t =~ s/\xe2\x80[\x93\x94]/-/g;
    $t =~ s/^\s+//;
    $t =~ s/\s+$//;
    return 0 if $t =~ /[^\x00-\x7f]/;
    # Ein Quelltextkommentar ist kein Oberflaechentext. Gemessen am
    # Bestand: E-85 zitiert einen Kommentar aus utils.cpp, der
    # "TextReader::ReadIt" enthaelt - ein Oberflaechentext hat kein "::".
    return 0 if $t =~ /::/;
    # Ein Oberflaechentext ist kurz. Ein Absatz ist ein Zitat aus einer
    # Mail oder aus Gregors Bericht (E-64: 155 Zeichen).
    return 0 if length($t) > 120;          # Umlaute: dann deutsch
    return 0 unless $t =~ /^[A-Za-z0-9 ,.'()\-:;\/\[\]!?%]+$/;
    my @w = grep { length } split /[^A-Za-z]+/, lc $t;
    return 0 if @w < 3;
    my $treffer = 0;
    for my $w (@w) { $treffer++ if $ENGLISCH{$w}; }
    return $treffer >= 2 ? 1 : 0;
}

sub quelle_genannt {
    my ($zeile) = @_;
    for my $m (@QUELLE) { return 1 if $zeile =~ /$m/; }
    return 0;
}

sub pruefe_text {
    my ($inhalt, $name) = @_;
    my @gefunden;
    for my $zeile (split /\n/, $inhalt) {
        next unless $zeile =~ /^\|\s*([A-Z]+-\d+)\s*\|/;
        my $kennung = $1;
        my @z = grep { ist_oberflaechentext($_) } zitate($zeile);
        next unless @z;
        next if quelle_genannt($zeile);
        push @gefunden, { kennung => $kennung, datei => $name, zitat => $z[0] };
    }
    return @gefunden;
}

if ($selbsttest) {
    my $E83_alt = '| E-83 | eine **IMAP-Aufgabe bleibt in der Warteschlange stehen** und wird nie '
        . "gestartet \x{e2}\x{80}\x{94} *\x{e2}\x{80}\x{9e}Waiting in the task queue to be started \x{e2}\x{80}\x{a6}\x{e2}\x{80}\x{9c}* | "
        . '**offen**, von Gregor am 11.09.2026 an 1.0.48 gemeldet. Drei Ursachen am Quelltext '
        . 'ausgeschlossen: CanScheduleTask blockiert nur POP-Empfang; DelayTasks und StartTasks '
        . 'ruft niemand auf; MaxConcurrentTasks steht auf 10 |';
    my $E83_neu = '| E-83 | **Eudora laesst sich nicht beenden** '
        . "\x{e2}\x{80}\x{94} *\x{e2}\x{80}\x{9e}Waiting in the task queue to be started \x{e2}\x{80}\x{a6}\x{e2}\x{80}\x{9c}* | "
        . '**behoben** in 7.2.0.53. Der Zustand war FERTIG(5); der Text stammt aus Register() '
        . 'und wird nie ueberschrieben |';
    my $deutsch = '| E-76 | Filterfenster laesst sich nicht vergroessern | Gregor am 10.09.2026: '
        . "*\x{e2}\x{80}\x{9e}filter fenster laesst sich nicht nach unten vergroessern, nur zur seite\x{e2}\x{80}\x{9c}* |";
    my $kurz = '| E-90 | irgendwas | kein Zitat, nur Text |';
    my $engl_mit_quelle = '| E-91 | Meldung beim Start '
        . "*\x{e2}\x{80}\x{9e}An unhandled exception has occurred\x{e2}\x{80}\x{9c}* | gesetzt in OTShim.cpp, "
        . 'einmal beim Aufbau |';

    # Die beiden folgenden waren FEHLALARME beim ersten Lauf gegen den
    # Bestand - sie stehen hier, damit sie nicht wiederkommen.
    my $gregor_lang = '| E-64 | Filter verschieben zu viel | Gregor am 10.09.2026: '
        . "*\x{e2}\x{80}\x{9e}filter greifen (z.b. verschieben nach spam), aber wenn man es z.b. auf die "
        . "ganze in-mailbox anwendet, dann werden ALLE (!) mails verschoben.\x{e2}\x{80}\x{9c}* |";
    my $kommentar = '| E-85 | Umlaute ueber IMAP | der Kommentar sagt es woertlich: '
        . "\x{e2}\x{80}\x{9e}TextReader::ReadIt is now making sure that it leaves space at the end of "
        . "its buffer for us to NULL terminate it\x{e2}\x{80}\x{9c} |";

    my @faelle = (
        [ 'erlaubt: langes deutsches Gregor-Zitat (war Fehlalarm)', $gregor_lang, 0 ],
        [ 'erlaubt: Quelltextkommentar mit :: (war Fehlalarm)',     $kommentar,   0 ],
        [ 'echter Fehler: E-83 vom 11.09.2026, Text ohne Quelle', $E83_alt,         1 ],
        [ 'erlaubt: E-83 vom 14.09.2026, Quelle genannt',         $E83_neu,         0 ],
        [ 'erlaubt: deutsches Gregor-Zitat ist kein Programmtext', $deutsch,        0 ],
        [ 'erlaubt: Zeile ohne Zitat',                            $kurz,            0 ],
        [ 'erlaubt: englischer Text mit genannter Quelle',        $engl_mit_quelle, 0 ],
    );
    my $fehl = 0;
    for my $f (@faelle) {
        my ($name, $zeile, $soll) = @$f;
        my @m = pruefe_text($zeile, '<selbsttest>');
        my $ist = @m ? 1 : 0;
        my $ok = ($ist == $soll) ? 'ok  ' : 'FEHL';
        $fehl++ if $ist != $soll;
        printf "[%s] %-52s soll=%-6s ist=%s\n", $ok, $name,
               ($soll ? 'melden' : 'still'), ($ist ? 'melden' : 'still');
    }
    if ($fehl) {
        print "\n$fehl von " . scalar(@faelle) . " Gegenproben fehlgeschlagen.\n";
        exit 1;
    }
    print "\nAlle " . scalar(@faelle) . " Gegenproben halten.\n";
    exit 0;
}

my $wurzel = '.';
$wurzel = $1 if defined $0 and $0 =~ m{^(.*)/tools/[^/]+$};

my @maengel;
my $umfang;
if ($datei or $alle) {
    my $d = $datei ? $datei : "$wurzel/BEFUNDE.md";
    $umfang = "$d (ganzer Bestand)";
    my $h;
    if (open $h, '<:raw', $d) {
        local $/;
        my $inhalt = <$h>;
        close $h;
        @maengel = pruefe_text($inhalt, $d);
    }
    else {
        print "pruefe-anzeigetext: $d nicht lesbar\n";
        exit 0;
    }
}
else {
    $umfang = 'BEFUNDE.md, neu in diesem Commit';
    my $diff = qx{git diff --cached -U0 -- BEFUNDE.md 2>/dev/null};
    $diff = qx{git diff -U0 HEAD -- BEFUNDE.md 2>/dev/null} if !defined $diff or $diff !~ /\S/;
    my @neu;
    for my $z (split /\n/, (defined $diff ? $diff : '')) {
        next unless $z =~ /^\+/;
        next if $z =~ /^\+\+\+/;
        push @neu, substr($z, 1);
    }
    @maengel = pruefe_text(join("\n", @neu), $umfang);
}

if (!@maengel) {
    print "pruefe-anzeigetext: jeder zitierte Oberflaechentext nennt seine Quelle ($umfang).\n";
    exit 0;
}

print "pruefe-anzeigetext: " . scalar(@maengel) . " Befund(e) zitieren einen Programmtext,\n";
print "ohne zu sagen, wo er gesetzt wird und ob ihn jemand ueberschreibt:\n\n";
for my $m (@maengel) {
    print "  $m->{kennung}  ($m->{datei})\n";
    print "      zitiert: $m->{zitat}\n";
}
print "\nEin angezeigter Text ist eine Behauptung des Programms ueber sich selbst.\n";
print "Zwei Fragen, bevor er die Suchrichtung bestimmt:\n";
print "  1. Wo wird er gesetzt?\n";
print "  2. Schreibt ihn spaeter jemand um?\n";
print "Lautet die zweite Antwort nein, sagt er nichts ueber den JETZIGEN Zustand.\n";
print "Genau das war E-83: der Zustand war FERTIG, die Anzeige sagte 'Waiting'.\n";
print "Siehe Arbeitsweise/anzeige-ist-kein-zustand.md.\n";

exit($nur_melden ? 0 : 1);
