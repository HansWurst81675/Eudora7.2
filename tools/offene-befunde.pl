#!/usr/bin/perl
use strict;
use warnings;

# Die Urteilstabelle in Intern/BEFUNDE.md traegt seit dem 12.10.2026 vor jeder
# Kennung einen Anker (tools/befunde-verlinken.pl). Wer die erste Zelle
# liest, muss ihn ueberspringen - sonst sieht er die Tabelle leer.
my $ANKER = qr/(?:<a\s+id="[^"]*"><\/a>)?/;

# offene-befunde.pl - die Liste der offenen Befunde aus Intern/BEFUNDE.md erzeugen
# und in Intern/WEITERMACHEN.md setzen.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 11.09.2026, nachdem ich ihm die offenen Punkte im Chat
# aufgezaehlt hatte:
#
#   "mir ging es darum, wo das alles an einer stelle steht"
#
# Und davor: "welche aufgaben sind noch mir zugewiesen und noch nicht
# erledigt?" - eine Frage, die KEINE Datei direkt beantwortet hat. Die Liste
# musste ich mir aus Intern/BEFUNDE.md zusammenrechnen; im Chat steht sie jetzt und
# ist morgen weg.
#
# EINE VON HAND GEFUEHRTE LISTE WAERE DER FALSCHE WEG. Am selben Tag hat sich
# dreimal gezeigt, wohin das fuehrt: Intern/AUFGABEN.md nannte vier wartende
# Behebungen, von denen drei laengst bestaetigt waren; die Lehrentabelle
# fuehrte 27 von 56; tools/RELEASES.md kannte ein Release von elf. Deshalb
# wird diese Liste ERZEUGT.
#
# ---------------------------------------------------------------------------
# WAS ES TUT
# ---------------------------------------------------------------------------
#
# Es liest die Urteile aus Intern/BEFUNDE.md - dieselbe Quelle und dieselbe Regel
# wie pruefe-befundurteile.pl: die dritte Spalte, darin das erste
# Fettgedruckte - und setzt daraus die Tabelle zwischen zwei Marken in
# Intern/WEITERMACHEN.md.
#
# Die Spalte "was als Naechstes zu tun ist" kann kein Skript erzeugen; sie
# bleibt Handarbeit und steht in Intern/WEITERMACHEN.md. Was das Werkzeug
# sicherstellt: dass KEIN offener Befund fehlt und KEIN erledigter darin
# steht. Ohne Schalter prueft es nur und weist ab.
#
#   perl tools/offene-befunde.pl             pruefen, Rueckgabe 1 bei Abweichung
#   perl tools/offene-befunde.pl -schreiben  Tabelle neu setzen
#
# Rueckgabe: 0 = deckungsgleich, 1 = Abweichung, 2 = Aufrufproblem.

my $schreiben = grep { $_ eq '-schreiben' } @ARGV;

my $wurzel = -f 'VERSION' ? '.' : '..';
my $quelle = "$wurzel/Intern/BEFUNDE.md";
my $ziel   = "$wurzel/Intern/WEITERMACHEN.md";
my $ziel2  = "$wurzel/CHANGELOG.md";

unless (-f $quelle and -f $ziel) {
    print "  offene-befunde: Intern/BEFUNDE.md oder Intern/WEITERMACHEN.md nicht gefunden -\n";
    print "  bitte aus dem Wurzelverzeichnis aufrufen.\n";
    exit 2;
}

sub lies {
    my ($d) = @_;
    open my $h, '<:raw', $d or return undef;
    local $/;
    my $t = <$h>;
    close $h;
    return $t;
}

# --- Die Urteile aus Intern/BEFUNDE.md -------------------------------------------
# Dieselbe Regel wie pruefe-befundurteile.pl: dritte Spalte, erstes
# Fettgedrucktes. Wer sie hier anders liest, bekommt zwei Wahrheiten.
# "beobachtet" und "nicht gemessen" gehoeren dazu (22.10.2026). E-91 stand
# als "beobachtet, Ursache NICHT gemessen." da - weder behoben noch eines
# der Offen-Woerter, und fiel damit aus BEIDEN Zaehlungen heraus. Ein
# Befund, den niemand gemessen hat, ist nicht erledigt.
my @offen_wort = ('offen', 'in arbeit', 'zurueckgestellt', "zur\xc3\xbcckgestellt", 'teilweise',
                  'beobachtet', 'nicht gemessen');
my @erledigt_wort = ('behoben', 'kein eigener fehler', 'erledigt', 'nicht mehr auf', 'widerlegt',
                     'ueberholt', "\xc3\xbcberholt");

# KENNUNGEN ALLER FAMILIEN (LEKTOR-16, L-16.1, 12.10.2026). Bis dahin stand
# hier E-\d+. Intern/BEFUNDE.md fuehrt aber auch AN-, NP-, P-, A-, R- ... - das
# Werkzeug meldete "16 offen, Liste deckt" und sah AN-1 und AN-2 gar nicht,
# ausgerechnet die beiden Befunde, an denen an dem Tag gearbeitet wurde.
# Die Schranke aus CLAUDE.md Schritt 1 war damit fuer jeden Nicht-E-Befund
# blind. Unterkennungen wie B-2.2 bleiben aussen vor: das sind Zeilen in
# Messtabellen, keine Befunde.
my $kennung = qr/[A-Z]{1,3}\d?-\d+[a-z]?/;

my $befunde = lies($quelle);
my (@offene, %beschreibung, %fehlt, %gesehen);

for my $zeile (split /\n/, $befunde) {
    next unless $zeile =~ /^\|\s*$ANKER\s*\**\s*($kennung)\s*\**\s*\|/;
    my $k = $1;

    # MASKIERTE PIPES (22.10.2026, von LEKTOR gemessen). "split /\|/" zerlegt
    # auch an einem \| mitten im Urteilstext. Vier Urteile enthalten eines -
    # E-128 ("Text Files (*.txt)\|*.txt"), E-116 ("digit < '0' \|\| digit >
    # '9'"), E-105 (ein zitierter Betreff mit \|) und NP3-1 ("WS_CHILD \|
    # WS_VISIBLE"). Ihre Zeilen zerfielen in 6 bis 9 statt 5 Spalten, $s[3]
    # endete vor dem Ende des Urteils, und die Marke "Was noch fehlt" dahinter
    # war fuer das Werkzeug nicht vorhanden - die Tabelle schrieb bei allen
    # vieren "nicht aufgeschrieben", obwohl der Text dastand.
    my @s = split /(?<!\\)\|/, $zeile, -1;
    next unless @s >= 4;

    # Erste Zeile gewinnt - und zwar die erste Zeile UEBERHAUPT. Bis zum
    # 12.10.2026 galt das nur fuer schon angenommene Zeilen: eine erste
    # Zeile OHNE Urteilswort liess die naechste Zeile derselben Kennung
    # zum Zug kommen, und die steht meist in einer Teiltabelle weit unten.
    # A-1 zum Beispiel steht oben in der Uebersicht mit "teilweise"
    # (Intern/BEFUNDE.md:147) und unten mit "heute ueberholt" (:5020) - gelten
    # soll die Uebersicht. (LEKTOR-21 hat den ersten Wortlaut dieses
    # Kommentars berichtigt: er hatte oben und unten vertauscht.)
    next if $gesehen{$k}++;

    my $urteil = $s[3];
    # KEINE Laengengrenze. Bis zum 15.09.2026 stand hier {1,60}, und das war
    # eine stille Luecke: E-90 ("gemessene Grenze, kein Fehler dieser Fassung
    # - zurueckgestellt.", 62 Zeichen) und E-92 ("beobachtet, unsere Seite
    # NICHT gemessen - Kosmetik, zurueckgestellt.", 67 Zeichen) fielen aus der
    # Zaehlung, ohne dass irgendetwas meldete. Das Werkzeug sagte "Die Liste
    # deckt die offenen Befunde" und meinte 9, wo 11 stehen. Gegengetestet:
    # ohne Grenze kommen genau E-90 und E-92 dazu, kein behobener Befund.
    my @fett_alle = $urteil =~ /\*\*([^*]+?)\*\*/g;
    # LEERE FETTSTELLEN WEGWERFEN (22.10.2026, von LEKTOR gemessen). E-89
    # endet mit >>...*„keine ueberlappung."*** **Die Ursache...<<. In der
    # Folge "*** **" greift das Muster und liefert als erstes Fettwort ein
    # LEERZEICHEN - E-89 galt damit weder als offen noch als behoben und
    # wurde stillschweigend uebergangen. Dass das folgenlos blieb, lag nur
    # daran, dass er wirklich behoben ist. Es ist die einzige Zeile der
    # Datei mit diesem Muster - gemessen, nicht vermutet.
    @fett_alle = grep { /\S/ } @fett_alle;
    next unless @fett_alle;
    my $w     = lc $fett_alle[0];
    my $alle  = lc join ' || ', @fett_alle;

    # "behoben" schlaegt "offen" - eine Zeile "behoben ... war offen"
    # beschreibt einen erledigten Befund. AUSSER "wieder offen": E-112 steht
    # als "WIEDER OFFEN. ... widerlegt" da, und bis zum 12.10.2026 fiel er
    # deshalb aus der Liste (LEKTOR-16, L-16.1).
    # Ebenso "teilweise": AN-1 steht als "teilweise behoben - ... B5.7 offen"
    # da, und "behoben" haette ihn hinausgeworfen. Teilweise erledigt ist
    # nicht erledigt.
    # "bleibt offen" IRGENDWO im Fettgedruckten schlaegt jedes "behoben"
    # davor (22.10.2026). Bis dahin zaehlte nur das ERSTE Fettgedruckte, und
    # E-123 begann mit "Der Beenden-Weg ist ... bestaetigt - auf beiden
    # Wegen." Vier Saetze weiter stand, ebenfalls fett: "Der Befund selbst
    # bleibt offen:". Das Werkzeug las den ersten Satz und schloss ihn.
    # Ein Urteil, das seinen eigenen Befund offen nennt, ist offen.
    my $bleibt_offen = index($alle, 'bleibt offen') >= 0;
    my $wieder = index($w, 'wieder offen') >= 0 || index($w, 'teilweise') >= 0 || $bleibt_offen;
    next if !$wieder and grep { index($w, $_) >= 0 } @erledigt_wort;
    next unless $bleibt_offen or grep { index($w, $_) >= 0 } @offen_wort;

    # Die Kurzbeschreibung ist die zweite Spalte, ohne Auszeichnung.
    my $b = $s[2];
    $b =~ s/\*\*//g;
    $b =~ s/`//g;
    $b =~ s/^\s+|\s+$//g;
    $b =~ s/\s+/ /g;
    $b = substr($b, 0, 90) . '…' if length($b) > 90;


    # --- DRITTE SPALTE: was noch fehlt (22.10.2026) -----------------------
    # Gregor, nachdem er sich A-1 angesehen hatte: "Erscheinungsbild: fuenf
    # Punkte umgesetzt | teilweise, Wirkung belegt (E-1/E-2), was heisst es?
    # was fehlt hier?" - und gleich danach: "mir geht es nicht nur um A-1,
    # sondern um alle punkte!"
    #
    # Gemessen am 22.10.2026: 23 von 40 offenen Befunden sagten nur, WIE sie
    # eingestuft sind ("offen", "teilweise"), nicht WAS noch aussteht. Acht
    # davon mit einem einzigen Wort. Eine Liste offener Punkte, die den
    # erledigten Teil nennt und den offenen verschweigt, ist verkehrt herum.
    #
    # Die Marke steht am ENDE der Urteilsspalte und laeuft bis zum Zellenende:
    #
    #     **Was noch fehlt:** der IMAP-Weg ruft SetExtension nicht auf (B5.7).
    #
    # Fehlt sie, schreibt die Tabelle "— nicht aufgeschrieben". Das ist
    # Absicht: die Luecke soll sichtbar und zaehlbar sein, nicht hinter
    # einem "teilweise" verschwinden (Arbeitsweise/ausbleiben-ist-kein-befund.md).
    if ($urteil =~ /\*\*Was noch fehlt:\*\*\s*(.+?)(?=\s*\*\*Wie zu pruefen:\*\*|\z)/s) {
        my $f = $1;
        $f =~ s/\s+/ /g;
        $f =~ s/\s+\z//;
        $f = substr($f, 0, 150) . '…' if length($f) > 150;
        $fehlt{$k} = $f;
    }
    push @offene, $k;
    $beschreibung{$k} = $b;
}

unless (@offene) {
    print "  offene-befunde: Intern/BEFUNDE.md fuehrt keinen offenen Befund.\n";
    exit 2;
}

# Nach Nummer sortieren, die juengsten zuerst - was zuletzt gefunden wurde,
# ist meist das, was als Naechstes drankommt.
# Die laufende Nummer ist die LETZTE Zahl: bei NP3-1 ist es die 1, nicht die 3.
@offene = sort { my ($x) = $a =~ /(\d+)[a-z]?$/; my ($y) = $b =~ /(\d+)[a-z]?$/; $y <=> $x or $a cmp $b } @offene;

my $soll = '';
for my $k (@offene) {
    my $f = $fehlt{$k} // '— **nicht aufgeschrieben**';
    $soll .= "| **$k** | $beschreibung{$k} | $f |\n";
}

# --- Gegen Intern/WEITERMACHEN.md halten -----------------------------------------
my $t = lies($ziel);
my $anfang = '<!-- offene-befunde: Anfang -->';
my $ende   = '<!-- offene-befunde: Ende -->';

unless ($t =~ /\Q$anfang\E(.*?)\Q$ende\E/s) {
    if ($schreiben) {
        print "  offene-befunde: die Marken fehlen in Intern/WEITERMACHEN.md.\n";
        print "  Bitte einmal von Hand einsetzen:\n\n";
        print "    $anfang\n    | Kennung | worum es geht |\n    |---|---|\n    $ende\n\n";
        exit 2;
    }
    print "\n  offene-befunde: Intern/WEITERMACHEN.md hat keinen erzeugten Abschnitt.\n";
    print "  Einmal einsetzen, dann haelt das Werkzeug ihn aktuell.\n\n";
    exit 1;
}

my $ist = $1;
my %im_ist;
# VERLINKTE FORM (LEKTOR-27, L-27.1, 13.10.2026). Seit eb5815d steht die
# Tabelle nach "-schreiben" plus "befunde-verlinken.pl --verlinken" als
# **[E-115](Intern/BEFUNDE.md#e-115)** da. Bis dahin las diese Zeile nur **E-115**
# und meldete "in Intern/WEITERMACHEN.md 0, FEHLEN 30" - bei inhaltlich deckender
# Liste. Der Haken zeigt die Ausgabe nur an, also fiel es niemandem auf.
# NUR DIE ERSTE SPALTE (22.10.2026, von LEKTOR gemessen). Bis die Tabelle
# eine dritte Spalte bekam, war der ganze Block eine sichere Quelle fuer
# Kennungen. Jetzt nicht mehr: LEKTORs erste Fassung der S-3-Marke schrieb
# "**S-3c**" in "was noch fehlt", und der naechste Lauf meldete
# "ZU VIEL (1, laut Intern/BEFUNDE.md erledigt): S-3c" - eine Kennung, die gar
# keine Tabellenzeile war. Gezaehlt wird deshalb nur noch, was in der
# KENNUNGSSPALTE steht. Damit darf eine Marke eine Kennung auch fett
# nennen, ohne das Werkzeug zu verwirren.
for my $zeile (split /\n/, $ist) {
    next unless $zeile =~ /^\s*\|/;
    my @c = split /(?<!\\)\|/, $zeile, -1;
    next unless @c >= 2;
    $im_ist{$1} = 1 if $c[1] =~ /\*\*\[?($kennung)\]?(?:\([^)]*\))?\*\*/;
}

my @fehlen = grep { not $im_ist{$_} } @offene;
my @zuviel = grep { my $n = $_; not grep { $_ eq $n } @offene } sort keys %im_ist;

print "\n  ------------------------------------------------------------\n";
print "  offene-befunde\n";
print "  ------------------------------------------------------------\n";
printf "    offen laut Intern/BEFUNDE.md      %2d\n", scalar @offene;
printf "    in Intern/WEITERMACHEN.md         %2d\n", scalar keys %im_ist;

# ABWEISEN, WENN EIN OFFENER BEFUND NICHT SAGT, WAS NOCH FEHLT (22.10.2026).
# Gregor, nachdem er sich A-1 angesehen hatte: "was heisst es? was fehlt
# hier?" - und gleich darauf: "mir geht es nicht nur um A-1, sondern um alle
# punkte!" Am selben Tag gemessen: 23 von 40 Urteilen sagten nur, WIE ein
# Befund eingestuft ist, nicht WAS aussteht.
#
# Die Schranke weist erst ab, seit alle 40 gefuellt sind. Haette sie vorher
# abgewiesen, waere jeder Commit blockiert gewesen und sie waere wieder
# ausgebaut worden (Arbeitsweise/schranke-gehoert-in-den-haken.md). Jetzt
# haelt sie den Stand: ein NEUER Befund kommt ohne die Marke nicht durch.
my @ohne = grep { not defined $fehlt{$_} } @offene;
if (@ohne) {
    printf "    ohne \"Was noch fehlt\"      %2d\n", scalar @ohne;
    print "\n  MANGEL - diese offenen Befunde sagen nicht, was noch aussteht:\n";
    print "    $_\n" for @ohne;
    print <<'ENDE';

  Ein offener Punkt, der nur seine Einstufung nennt ("offen", "teilweise"),
  ist fuer den naechsten Leser wertlos - er muss das ganze Urteil lesen, um
  zu erfahren, wo er anfangen soll. Ans ENDE der Urteilsspalte gehoert:

      **Was noch fehlt:** <ein bis drei Saetze, mit Datei und Zeile>

ENDE
    exit 1;
}

# Hier war bis zum 22.10.2026 Schluss, wenn die Kennungslisten deckungsgleich
# waren. Das war zweimal zu frueh: die dritte Spalte ("was noch fehlt") kann
# sich aendern, ohne dass eine Kennung dazukommt, und seit CHANGELOG.md als
# zweites Ziel dazugekommen ist, muss auch DESSEN Abschnitt verglichen werden.
# Die Gegenprobe (eine Kennung im CHANGELOG verfaelschen) kam mit dem alten
# Ausstieg gruen zurueck - die Schranke war an dieser Stelle blind.
printf "\n  FEHLEN (%d): %s\n", scalar @fehlen, join(', ', @fehlen) if @fehlen;
printf "\n  ZU VIEL (%d, laut Intern/BEFUNDE.md erledigt): %s\n",
       scalar @zuviel, join(', ', @zuviel) if @zuviel;

if ((@fehlen or @zuviel) and not $schreiben) {
    print <<'ENDE';

  Gregor am 11.09.2026: "mir ging es darum, wo das alles an einer
  stelle steht". Eine Liste, die von Hand gepflegt wird, steht
  spaetestens nach dem naechsten behobenen Befund falsch da.

  Neu setzen mit:   perl tools/offene-befunde.pl -schreiben

ENDE
    exit 1;
}

# LINKS JE ZIEL UMRECHNEN (22.10.2026). Die Beschreibungen stammen aus
# Intern/BEFUNDE.md, ihre relativen Links gelten also ab Intern/. Derselbe
# Block geht aber in zwei Verzeichnisebenen: Intern/WEITERMACHEN.md und
# CHANGELOG.md in der Wurzel. Ohne Umrechnung landete "../Befunde/PRUEFER-33.md"
# unveraendert im CHANGELOG und zeigte ins Leere - gemessen von doku-pruefen.pl
# direkt nach dem Umzug.
sub block_fuer {
    my ($roh, $datei) = @_;
    return $roh if $datei =~ m{/Intern/};      # schon richtig
    $roh =~ s{\]\(([^)#][^)]*)\)}{
        my $z = $1;
        if ($z =~ m{^(?:https?:|mailto:|/|Intern/)}) { "]($z)" }
        else {
            my @t;
            for my $s (split m{/}, "Intern/$z") {
                next if $s eq '.' or $s eq '';
                if ($s eq '..') { pop @t if @t && $t[-1] ne '..'; next }
                push @t, $s;
            }
            '](' . join('/', @t) . ')';
        }
    }ge;
    return $roh;
}

my $block = "$anfang\n\n| Kennung | worum es geht | was noch fehlt |\n|---|---|---|\n$soll\n$ende";

# ZWEI ZIELE (22.10.2026). Bis dahin pflegte CHANGELOG.md eine EIGENE Liste
# "Noch offen" von Hand. Gregor am 22.10.2026: "alles, was als 'offen'
# markiert ist, ist wahr? die direktive 'keine luegen auf main' gilt immer
# noch ... im moment sehe ich es nicht!" Gemessen: die Liste nannte fuenf
# Befunde als offen, die in ihrer eigenen Statusspalte "Behoben" sagten
# (E-112, E-115, E-117, E-118, E-68), und zehn offene fehlten ganz.
#
# Eine zweite handgepflegte Liste derselben Sache war in diesem Projekt noch
# jedes Mal falsch. Beide kommen jetzt aus derselben Quelle.
my @ziele = ($ziel, $ziel2);
my $abweichung = 0;

for my $datei (@ziele) {
    my $inhalt = lies($datei);
    unless (defined $inhalt and $inhalt =~ /\Q$anfang\E(.*?)\Q$ende\E/s) {
        print "  offene-befunde: $datei hat keinen erzeugten Abschnitt.\n";
        $abweichung = 1;
        next;
    }
    my $ist_block = $anfang . $1 . $ende;
    my $soll_block = block_fuer($block, $datei);
    # LINKSCHREIBWEISE IGNORIEREN. Der Erzeuger schreibt "**E-133**",
    # befunde-verlinken.pl macht daraus "**[E-133](Intern/BEFUNDE.md#e-133)**".
    # Beides ist derselbe Stand; verglichen wird der sichtbare Text.
    my $ohne = sub { my $s = shift; $s =~ s/\]\([^)]*\)//g; $s =~ s/[\[\]]//g; $s };
    # Der Vergleich ignoriert die Linkschreibweise (siehe oben) - ein reiner
    # PFAD-Unterschied faellt ihm deshalb nicht auf. Mit "-schreiben" wird
    # darum immer gesetzt, sonst blieb "../Befunde/..." im CHANGELOG stehen.
    next if !$schreiben && $ohne->($ist_block) eq $ohne->($soll_block);

    unless ($schreiben) {
        print "  offene-befunde: der Abschnitt in $datei ist nicht auf dem Stand.\n";
        $abweichung = 1;
        next;
    }

    my $neu_inhalt = $inhalt;
    $neu_inhalt =~ s{\Q$anfang\E.*?\Q$ende\E}{$soll_block}s;

    my $c0 = () = $inhalt =~ /\r\n/g;
    my $c  = () = $neu_inhalt =~ /\r\n/g;
    if ($c != $c0) { printf "  ABBRUCH - %s: CRLF %d statt %d\n", $datei, $c, $c0; exit 1; }

    open my $o, '>:raw', $datei or die "$datei: $!\n";
    print $o $neu_inhalt;
    close $o;
    printf "  neu gesetzt: %s\n", $datei;
}

exit 1 if $abweichung and not $schreiben;
printf "\n  %d offene Befunde, in beiden Listen gleich.\n\n", scalar @offene;
exit 0;
