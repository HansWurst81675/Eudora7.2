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
#
# Die 6385 enthalten 0 Dateien, die sich nur in den Zeilenenden unterscheiden -
# die erweiterte Liste deckt also keinen neuen Schaden auf. Wer nachzaehlen will:
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

my $aendern = grep { $_ eq '--aendern' } @ARGV;

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

my ($gleich, $angeglichen, $echt, $unlesbar) = (0, 0, 0, 0);
my @echte;

for my $p (@dateien) {
    my $arbeit = roh($p);
    next unless defined $arbeit;
    my $head = blob($p);
    if (!defined $head) { $unlesbar++; next; }

    if ($arbeit eq $head) { $gleich++; next; }

    (my $ohne = $arbeit) =~ s/\r\n/\n/g;
    if ($ohne eq $head) {
        $angeglichen++;
        if ($aendern) {
            open(my $o, '>:raw', $p) or die "$p: $!\n";
            print $o $head;             # den HEAD-Stand woertlich schreiben
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

printf "  byteidentisch zu HEAD:        %5d\n", $gleich;
printf "  nur Zeilenenden verschieden:  %5d%s\n", $angeglichen,
       ($aendern ? '  -> angeglichen' : '  (mit --aendern angleichen)');
printf "  inhaltlich verschieden:       %5d\n", $echt;
printf "  nicht in HEAD:                %5d\n", $unlesbar;

if (@echte) {
    print "\n  Inhaltlich verschieden (bleiben unangetastet):\n";
    print "    $_\n" for @echte;
    print "    ...\n" if $echt > @echte;
}

exit 0;
