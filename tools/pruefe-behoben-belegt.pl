#!/usr/bin/perl
use strict;
use warnings;

# pruefe-behoben-belegt.pl - "behoben" braucht einen Beleg, kein Argument.
#
# WARUM ES DAS GIBT
#
# Am 13.09.2026 wurde E-85 (Umlaute ueber IMAP) zweimal als behoben gemeldet,
# bevor die Ursache gefunden war:
#
#   18:45  Commit 881d5c4  "E-85 behoben: IMAP benutzt jetzt dieselbe
#                           Zeichensatzsuche wie POP3"
#   19:00  an Gregor       "E-85 ist behoben, und der Kern war nicht ..."
#   20:29  Gregor          "das ist auf jeden fall eine frische mail,
#                           ist aber falsch dargestellt!"
#
# Beide Male gab es keine Messung im Programm, die gesagt haette, ob der
# geaenderte Weg ueberhaupt genommen wird. Der erste Fix reparierte den
# Suchbereich, der zweite die Quelle; erst mit der Spurmarke war es in einer
# Minute entschieden:
#
#   E-85 imap: teil-charset=utf-8 tl-charset=(keiner) idx=4 uebersetzt=ja
#
# WAS GEPRUEFT WIRD
#
# Jede Befundzeile, deren Urteil "behoben" sagt, muss einen BELEG nennen -
# eine Aussage darueber, dass der geaenderte Weg EINMAL gelaufen ist:
#
#   - "von Gregor ... bestaetigt"
#   - "am laufenden Programm gemessen" / "... bestaetigt"
#   - eine Spurmarke mit ihrem Messwert
#   - "im Protokoll belegt"
#
# Ein Beleg, in dem oder vor dem eine Verneinung steht ("von Gregor ist
# nichts davon am laufenden Programm bestaetigt"), zaehlt NICHT. Genau so
# stand E-85 da. Wer keinen Beleg hat, schreibt kein "behoben", sondern
# "geaendert, nicht durchlaufen" - Arbeitsweise/erfolg-aus-anwendersicht.md.
#
# GEPRUEFT WIRD NUR, WAS NEU GESCHRIEBEN WIRD.
#
# BEFUNDE.md fuehrt ueber 70 alte Zeilen, die "behoben" ohne Beleg sagen -
# aus der Zeit vor dieser Schranke. Wer sie alle meldet, erzeugt Rauschen,
# und eine Schranke, die dauernd meckert, wird abgeschaltet
# (Arbeitsweise/schranke-gegentesten.md). Deshalb liest die Schranke im
# Regelfall nur die Zeilen, die dieser Commit HINZUFUEGT. Der Fehler
# passiert genau dort: in dem Moment, in dem das Urteil geschrieben wird.
#
# Aufruf:
#   perl tools/pruefe-behoben-belegt.pl              # nur neue Zeilen, weist ab
#   perl tools/pruefe-behoben-belegt.pl --nur-melden # exit 0, nur Bericht
#   perl tools/pruefe-behoben-belegt.pl --alle       # der ganze Bestand
#   perl tools/pruefe-behoben-belegt.pl --datei X    # eine andere Datei
#   perl tools/pruefe-behoben-belegt.pl --selbsttest # Gegenproben
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
    else { die "pruefe-behoben-belegt.pl: unbekannter Schalter '$a'\n"; }
}

# Ein Beleg ist eine Aussage, dass der Weg einmal gelaufen ist.
# Die Muster kommen ohne Umlaute im Quelltext aus: best.{0,3}tigt trifft
# "bestaetigt" ebenso wie das UTF-8-kodierte Wort mit ae-Umlaut.
my @BELEG = (
    qr/von\s+Gregor[^|]{0,120}?best.{0,3}tigt/i,
    qr/am\s+laufenden\s+Programm\s+(?:gemessen|best.{0,3}tigt|gepr.{0,3}ft)/i,
    qr/Spurmarke[^|]{0,200}?=/i,
    qr/im\s+Protokoll\s+belegt/i,
);

# Woerter, die einen Beleg umkehren.
my $VERNEINT = qr/\b(?:nicht|nichts|kein|keine|keinen|ohne)\b/i;

sub beleg_haelt {
    my ($text) = @_;
    for my $m (@BELEG) {
        while ($text =~ /$m/g) {
            my $start  = $-[0];
            my $laenge = $start > 90 ? 90 : $start;
            my $vorlauf = substr($text, $start - $laenge, $laenge);
            my $treffer = substr($text, $start, $+[0] - $start);
            # Die Verneinung kann VOR dem Beleg stehen oder MITTEN darin:
            # "von Gregor ist nichts davon am laufenden Programm bestaetigt".
            next if "$vorlauf $treffer" =~ /$VERNEINT/;
            return 1;
        }
    }
    return 0;
}

# Das Urteil steht am Anfang der Statusspalte. "behoben" darin ist die
# Behauptung, um die es geht; "nicht behoben" ist ehrlich und keine.
sub urteilt_behoben {
    my ($status) = @_;
    my $kopf = substr($status, 0, 160);
    return 0 unless $kopf =~ /behoben/i;
    return 0 if $kopf =~ /(?:noch\s+)?nicht\s+behoben/i;
    return 1;
}

sub pruefe_text {
    my ($inhalt, $name) = @_;
    my @gefunden;
    my $nr = 0;
    for my $zeile (split /\n/, $inhalt) {
        $nr++;
        next unless $zeile =~ /^\|\s*([A-Z]+-\d+)\s*\|/;
        my $kennung = $1;
        my @f = split /\s*\|\s*/, $zeile;
        next unless @f >= 4;
        my $was    = defined $f[2] ? $f[2] : '';
        my $status = defined $f[3] ? $f[3] : '';
        next unless urteilt_behoben($status);
        next if beleg_haelt($status);
        push @gefunden, {
            kennung => $kennung,
            zeile   => $nr,
            datei   => $name,
            was     => substr($was, 0, 70),
        };
    }
    return @gefunden;
}

if ($selbsttest) {
    my @faelle = (
        [ 'echter Fehler: E-85 am 13.09.2026, Stand 20f4820^',
          '| E-85 | **Umlaute in per IMAP abgerufenen Nachrichten kommen falsch an** | **Alle drei '
          . 'Maengel behoben in 7.2.0.51**, 13.09.2026, von Gregor am selben Tag gemeldet. Die ersten '
          . 'drei Punkte sind am Quelltext belegt; von Gregor ist nichts davon am laufenden Programm '
          . 'bestaetigt |', 1 ],
        [ 'erlaubt: E-84, von Gregor bestaetigt',
          '| E-84 | die Groesse eines losgerissenen Fensters ueberlebt den Neustart nicht | '
          . '**behoben** in 7.2.0.50, **von Gregor am 11.09.2026 bestaetigt** - belegt an beiden Enden |', 0 ],
        [ 'erlaubt: E-83, am laufenden Programm gemessen',
          '| E-83 | **Eudora laesst sich nicht beenden** | **behoben** in 7.2.0.53, '
          . '**am laufenden Programm gemessen** (14.09.2026) |', 0 ],
        [ 'erlaubt: Spurmarke mit Messwert',
          '| E-99 | irgendwas | **behoben** in 7.2.0.60. Die Spurmarke sagt uebersetzt=ja |', 0 ],
        [ 'erlaubt: ehrlich als nicht behoben gefuehrt',
          '| E-98 | irgendwas | **noch nicht behoben**, Ursache am Quelltext gefunden |', 0 ],
        [ 'echter Fehler: behoben, gebaut, aber nie gelaufen',
          '| E-97 | irgendwas | **behoben** in 7.2.0.55, uebersetzt und alle Schranken gruen |', 1 ],
        [ 'echter Fehler: Beleg verneint',
          '| E-96 | irgendwas | **behoben** in 7.2.0.56, aber nicht am laufenden Programm gemessen |', 1 ],
        [ 'erlaubt: offener Befund ohne Urteil',
          '| E-95 | irgendwas | **Verdacht am Quelltext, nicht bewiesen** |', 0 ],
        [ 'erlaubt: Zeile ohne Befundkennung',
          '| - | irgendwas behoben | irgendwas |', 0 ],
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
        print "pruefe-behoben-belegt: $d nicht lesbar\n";
        exit 0;
    }
}
else {
    # Nur die Zeilen, die dieser Commit HINZUFUEGT. Liegt nichts im Index,
    # faellt die Schranke auf den Arbeitsbaum gegen HEAD zurueck.
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
    print "pruefe-behoben-belegt: kein unbelegtes 'behoben' ($umfang).\n";
    exit 0;
}

print "pruefe-behoben-belegt: " . scalar(@maengel) . " Befund(e) sagen 'behoben' ohne Beleg:\n\n";
for my $m (@maengel) {
    print "  $m->{kennung}  ($m->{datei})\n";
    print "      $m->{was}\n";
}
print "\nEin Beleg ist eine Aussage, dass der Weg EINMAL gelaufen ist:\n";
print "  - von Gregor am <Datum> bestaetigt\n";
print "  - am laufenden Programm gemessen\n";
print "  - eine Spurmarke mit ihrem Messwert aus dem Protokoll\n";
print "Ohne Beleg heisst es nicht behoben, sondern: geaendert, nicht durchlaufen.\n";
print "Siehe Arbeitsweise/erfolg-aus-anwendersicht.md und\n";
print "Arbeitsweise/eingebaute-messung-auslesen.md.\n";

exit($nur_melden ? 0 : 1);
