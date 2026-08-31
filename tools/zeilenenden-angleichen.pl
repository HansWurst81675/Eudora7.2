#!/usr/bin/perl
#
# Gleicht die Zeilenenden im Arbeitsverzeichnis an den committeten Stand an.
#
#   perl tools/zeilenenden-angleichen.pl            # nur messen, nichts aendern
#   perl tools/zeilenenden-angleichen.pl --aendern  # angleichen
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 30.08.2026 gemessen: 4616 von 5563 verfolgten Quell- und Textdateien
# unterschieden sich von HEAD AUSSCHLIESSLICH in den Zeilenenden. Im
# Arbeitsverzeichnis standen sie als CRLF, im Commit als LF.
#
# Diese Zahl ist eine EINMALIGE Messung des damaligen Arbeitsbaums und laesst
# sich nicht wiederholen - der Baum ist seither angeglichen. Nachpruefbar ist
# nur die Grundgesamtheit, und die waechst mit jedem Commit, der Dateien
# hinzufuegt - und sie haengt an der Endungsliste:
#
#   5563  30.08.2026 vormittags, alte Liste
#   5568  30.08.2026 abends, alte Liste (PRUEFER)
#   5589  31.08.2026, alte Liste (c cpp h hpp inl rc idl def mak txt md)
#   6385  31.08.2026, neue gemeinsame Liste aus tools/dateiendungen.pl
#   6444  31.08.2026 abends, um ih rgs mc user hh hpj erweitert (X-1, D4)
#
# Auch die 6444 enthalten 0 Dateien, die sich nur in den Zeilenenden
# unterscheiden - die erweiterte Liste deckt keinen neuen Schaden auf, sie
# schliesst eine Luecke fuer die Zukunft. Von den 49 neu erfassten Dateien war
# jede einzelne byteidentisch zu HEAD (nachgemessen, bevor die Liste erweitert
# wurde). Wer nachzaehlen will:
#
#   perl tools/zeilenenden-angleichen.pl        # letzte Zeile: Grundgesamtheit
#
# Eine frueher hier genannte Zahl 4426 von 5336 stammte aus einem Durchlauf mit
# kuerzerer Endungsliste und wurde nicht nachgezogen; sie ist ersatzlos weg.
#
# Ursache: das Repo wurde seinerzeit mit core.autocrlf=true ausgecheckt. Git
# hat beim Auschecken LF nach CRLF gewandelt und die Datei trotzdem als sauber
# vermerkt. Spaeter wurde autocrlf auf false gesetzt und .gitattributes mit
# "* -text" angelegt - seitdem vergleicht git woertlich. Die Dateien gelten
# aber weiter als unveraendert, weil git den stat-Zwischenspeicher benutzt und
# gar nicht erst hineinsieht.
#
# Die Falle: sobald irgendein Werkzeug so eine Datei anfasst, aendert sich ihr
# Zeitstempel, git liest sie neu ein - und meldet die GANZE Datei als geaendert.
# Ein Commit nimmt dann Tausende von Zeilen mit, die niemand angefasst hat, und
# die pre-commit-Schranke schlaegt Alarm. Genau das ist in diesem Projekt
# mehrfach passiert und wurde jedes Mal einzeln von Hand nachgebessert.
#
# Dieses Werkzeug beseitigt die Ursache: es macht die Arbeitskopie byteidentisch
# zum Commit. Danach ist "git status" sauber, und jede spaetere Aenderung
# erzeugt einen Unterschied, der nur die tatsaechlich geaenderten Zeilen zeigt.
#
# SICHERHEIT: geaendert wird NUR, wenn die Datei nach dem Angleichen
# byteidentisch zum HEAD-Stand ist. Dateien mit echten inhaltlichen Aenderungen
# bleiben unangetastet und werden aufgezaehlt.
#
# DREI SICHERUNGEN MEHR (Befund X-1, D4 - eingebaut am 31.08.2026)
#
# X-1 hat dem Werkzeug vorgehalten, es drehe "absichtliche Arbeit richtungslos
# zurueck": wer im Arbeitsbaum absichtlich LF nach CRLF korrigiert - etwa eine
# .bat, die CRLF braucht -, verliert das durch --aendern kommentarlos. Das
# stimmt, und byteweise ist dieser Fall von dem Schaden, gegen den das Werkzeug
# gebaut wurde, NICHT zu unterscheiden. Beides sieht gleich aus: Arbeitskopie
# CRLF, HEAD LF. Also drei Sicherungen statt eines Ratespiels:
#
# 1. JEDE Datei, die angefasst wird, wird NAMENTLICH genannt (bis zu 20, dann
#    die Zahl). Vorher stand dort nur eine Zahl - man konnte hinterher nicht
#    sagen, was das Werkzeug getan hat.
# 2. VORGEMERKTE Dateien werden NICHT angefasst. Wer eine Aenderung an den
#    Zeilenenden schon "git add" gegeben hat, hat sie absichtlich gemacht; sie
#    zurueckzuschreiben wuerde vorgemerkte Arbeit still verwerfen. Solche
#    Dateien werden getrennt aufgezaehlt.
# 3. DIE GEGENRICHTUNG hat ihre eigene Zeile. Arbeitskopie LF, HEAD CRLF ist
#    NICHT der Schaden dieses Projekts; solche Dateien bleiben unangetastet und
#    werden gezaehlt (vorher landeten sie unter "inhaltlich verschieden" - eine
#    falsche Beschriftung). Mit --auch-umgekehrt werden auch sie angeglichen.
#
use strict;
use warnings;
use IPC::Open2;
use IO::Handle;
use FindBin;

# Gemeinsame Endungsliste mit tools/pruefe-bytes.pl. Zwei getrennte Listen sind
# am 30.08.2026 auseinandergelaufen und haben ganze Dateiarten ungeprueft
# gelassen (Befund PR-3).
my $D = do "$FindBin::Bin/dateiendungen.pl";
die "tools/dateiendungen.pl laesst sich nicht laden: " . ($@ ? $@ : $!) . "\n"
    unless ref($D) eq 'HASH' and $D->{muster};

my $aendern   = grep { $_ eq '--aendern' } @ARGV;
my $umgekehrt = grep { $_ eq '--auch-umgekehrt' } @ARGV;

# Vorgemerkte Dateien: was im Index anders steht als in HEAD, hat jemand
# absichtlich vorgemerkt. Sicherung 2.
my %vorgemerkt;
{
    open(my $d, '-|', 'git diff-index --cached --name-only -z HEAD') or last;
    local $/ = "\0";
    while (my $p = <$d>) { chomp $p; $vorgemerkt{$p} = 1 if length $p }
    close $d;
}

sub roh {
    my ($p) = @_;
    open(my $f, '<:raw', $p) or return undef;
    local $/;
    my $d = <$f>;
    close $f;
    return defined $d ? $d : '';
}

# HEAD-Staende holen. Ein einziger "git cat-file --batch" bedient alle Dateien;
# ein Prozess je Datei dauerte auf dieser Maschine ueber zehn Minuten.
my ($batch_ein, $batch_aus);
sub batch_start {
    my $pid = open2($batch_aus, $batch_ein, 'git', 'cat-file', '--batch');
    binmode($batch_ein);
    binmode($batch_aus);
    return $pid;
}
sub blob {
    my ($p) = @_;
    print { $batch_ein } "HEAD:$p\n";
    $batch_ein->flush();
    my $kopf = readline($batch_aus);
    return undef unless defined $kopf;
    return undef if $kopf =~ /(missing|ambiguous)\s*$/;
    my ($sha, $typ, $laenge) = $kopf =~ /^(\S+)\s+(\S+)\s+(\d+)/ or return undef;
    my $d = '';
    while (length($d) < $laenge) {
        my $n = read($batch_aus, my $stueck, $laenge - length($d));
        last unless $n;
        $d .= $stueck;
    }
    read($batch_aus, my $nl, 1);        # das abschliessende Zeilenende
    return $d;
}

batch_start();

my @dateien;
open(my $ls, '-|', 'git ls-files -z') or die "git ls-files: $!\n";
{
    local $/ = "\0";
    while (my $p = <$ls>) {
        chomp $p;
        next unless length $p;
        next unless $p =~ $D->{muster};
        next unless -f $p;
        push @dateien, $p;
    }
}
close $ls;

my ($gleich, $angeglichen, $echt, $unlesbar, $gegen, $geschont) = (0, 0, 0, 0, 0, 0);
my (@echte, @angefasst, @gegenrichtung, @geschonte);

for my $p (@dateien) {
    my $arbeit = roh($p);
    next unless defined $arbeit;
    my $head = blob($p);
    if (!defined $head) { $unlesbar++; next; }

    if ($arbeit eq $head) { $gleich++; next; }

    (my $ohne      = $arbeit) =~ s/\r\n/\n/g;
    (my $ohne_head = $head)   =~ s/\r\n/\n/g;

    # Der Schaden dieses Projekts: Arbeitskopie CRLF, HEAD LF.
    if ($ohne eq $head) {
        if ($vorgemerkt{$p}) {          # Sicherung 2
            $geschont++;
            push @geschonte, $p if @geschonte < 20;
            next;
        }
        $angeglichen++;
        push @angefasst, $p if @angefasst < 20;
        if ($aendern) {
            open(my $o, '>:raw', $p) or die "$p: $!\n";
            print $o $head;             # den HEAD-Stand woertlich schreiben
            close $o;
            my $nach = roh($p);
            die "$p: Angleichen fehlgeschlagen\n" unless defined $nach and $nach eq $head;
        }
    }
    # Sicherung 3: die Gegenrichtung. Arbeitskopie LF, HEAD CRLF.
    elsif ($ohne_head eq $arbeit) {
        if ($vorgemerkt{$p}) {
            $geschont++;
            push @geschonte, $p if @geschonte < 20;
            next;
        }
        $gegen++;
        push @gegenrichtung, $p if @gegenrichtung < 20;
        if ($aendern and $umgekehrt) {
            open(my $o, '>:raw', $p) or die "$p: $!\n";
            print $o $head;
            close $o;
            my $nach = roh($p);
            die "$p: Angleichen fehlgeschlagen\n" unless defined $nach and $nach eq $head;
        }
    }
    else {
        $echt++;
        push @echte, $p if @echte < 20;
    }
}

printf "  byteidentisch zu HEAD:            %5d\n", $gleich;
printf "  Arbeitskopie CRLF, HEAD LF:       %5d%s\n", $angeglichen,
       ($aendern ? '  -> angeglichen' : '  (mit --aendern angleichen)');
printf "  Arbeitskopie LF, HEAD CRLF:       %5d%s\n", $gegen,
       ($aendern && $umgekehrt ? '  -> angeglichen'
                               : '  (Gegenrichtung, nur mit --auch-umgekehrt)');
printf "  vorgemerkt, nicht angefasst:      %5d\n", $geschont;
printf "  inhaltlich verschieden:           %5d\n", $echt;
printf "  nicht in HEAD:                    %5d\n", $unlesbar;

sub liste {
    my ($titel, $liste, $gesamt) = @_;
    return unless @$liste;
    print "\n  $titel\n";
    print "    $_\n" for @$liste;
    print "    ... und " . ($gesamt - scalar @$liste) . " weitere\n" if $gesamt > @$liste;
}

# Sicherung 1: namentlich, nicht nur als Zahl.
liste($aendern ? 'Angeglichen (Arbeitskopie CRLF -> HEAD LF):'
               : 'Wuerde angeglichen (Arbeitskopie CRLF -> HEAD LF):',
      \@angefasst, $angeglichen);
liste('Gegenrichtung, Arbeitskopie LF und HEAD CRLF - absichtlich? Diese bleiben'
      . "\n  unangetastet, es sei denn mit --auch-umgekehrt:",
      \@gegenrichtung, $gegen);
liste('Vorgemerkt (git add) und deshalb NICHT angefasst - hier hat jemand die'
      . "\n  Zeilenenden absichtlich geaendert:",
      \@geschonte, $geschont);
liste('Inhaltlich verschieden (bleiben unangetastet):', \@echte, $echt);

exit 0;
