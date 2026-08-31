#!/usr/bin/perl
#
# Testsammlung fuer die pre-commit-Schranke tools/pruefe-bytes.pl.
#
#   perl tools/pruefe-bytes-tests.pl          # alle Faelle
#   perl tools/pruefe-bytes-tests.pl -v       # zusaetzlich die Meldung der Schranke
#
# WARUM ES DIESE SAMMLUNG GIBT
#
# Die Schranke wurde am 30.08.2026 einmal "repariert" und war danach falsch:
# sie liess die Umwandlung LF -> CRLF durch und schlug dafuer bei ganz normalen
# Leerzeilen-Aenderungen grundlos an (Befund PR-1/PR-2). Beides waere bei der
# ersten Ausfuehrung dieser Sammlung aufgefallen. Wer die Schranke anfasst,
# laesst diese Sammlung laufen - sonst nicht committen.
#
# WIE SIE ARBEITET
#
# Jeder Fall baut ein eigenes Wegwerf-Repo unter dem Temp-Verzeichnis, legt
# einen HEAD-Stand an, merkt einen zweiten Stand vor und ruft die Schranke im
# Wegwerf-Repo auf. Geprueft wird ausschliesslich der Rueckgabewert:
#
#   0 = durchgelassen        1 = COMMIT ABGEBROCHEN
#
# Die Faelle sind byteweise beschrieben: 'C' heisst CRLF am Zeilenende,
# 'L' heisst blosses LF. Es kommt kein einziges Escape im Testtext vor -
# Escapes waren in diesem Projekt selbst schon Fehlerquelle.
#
use strict;
use warnings;
use FindBin;
use File::Temp qw(tempdir);
use File::Path qw(make_path);
use Cwd qw(getcwd);

my $laut    = grep { $_ eq '-v' } @ARGV;
my $SCHRANKE = "$FindBin::Bin/pruefe-bytes.pl";
-f $SCHRANKE or die "Schranke nicht gefunden: $SCHRANKE\n";

my $CR = chr(13);
my $LF = chr(10);

# ---------------------------------------------------------------- Bausteine

# Baut aus einer Liste [inhalt, 'C'|'L'] den Dateiinhalt.
sub bytes_aus {
    my @z = @_;
    my $t = '';
    for my $e (@z) {
        my ($inhalt, $ende) = @$e;
        $t .= $inhalt . ($ende eq 'C' ? $CR . $LF : $LF);
    }
    return $t;
}

# Dieselben Zeileninhalte, alle mit demselben Ende.
sub alle_mit {
    my ($ende, @inhalte) = @_;
    return map { [ $_, $ende ] } @inhalte;
}

sub schreib {
    my ($pfad, $bytes) = @_;
    open(my $f, '>:raw', $pfad) or die "schreiben $pfad: $!\n";
    print $f $bytes;
    close $f;
}

sub git {
    my @arg = @_;
    my $pid = open(my $fh, '-|');
    die "fork: $!\n" unless defined $pid;
    if (!$pid) {                       # Kind: stderr weg, dann git
        open(STDERR, '>', '/dev/null') or open(STDERR, '>', 'NUL');
        exec('git', @arg) or exit 127;
    }
    local $/;
    my $aus = <$fh>;
    close $fh;
    return defined $aus ? $aus : '';
}

# ------------------------------------------------------------- die Faelle

# vorher  = Zustand in HEAD           (undef = Datei gibt es in HEAD nicht)
# nachher = Zustand im Index          (undef = Datei wird geloescht)
# erwartet= 0 durchlassen, 1 anschlagen

my @cpp_crlf = alle_mit('C', 'eins', 'zwei', 'drei', 'vier');
my @cpp_lf   = alle_mit('L', 'eins', 'zwei', 'drei', 'vier');

# gemischte Datei mit 655 Zeilen, davon 18 mit CRLF (Vorbild: mainfrm.h)
my @gemischt;
for my $i (1 .. 655) {
    push @gemischt, [ "zeile$i", ($i % 36 == 0) ? 'C' : 'L' ];
}
my @gemischt_18_weg = map { [ $_->[0], 'L' ] } @gemischt;   # die 18 CRLF -> LF

my $bad = chr(0xEF) . chr(0xBF) . chr(0xBD);

my @faelle = (
  { schl => 'a', name => 'Zeilen hinzugefuegt (CRLF-Datei)',
    datei => 'a.cpp', erwartet => 0,
    vorher  => [ @cpp_crlf ],
    nachher => [ $cpp_crlf[0], $cpp_crlf[1], [ 'neu1', 'C' ], [ 'neu2', 'C' ], $cpp_crlf[2], $cpp_crlf[3] ] },

  { schl => 'b', name => 'Zeilen hinzugefuegt (LF-Datei)',
    datei => 'b.cpp', erwartet => 0,
    vorher  => [ @cpp_lf ],
    nachher => [ $cpp_lf[0], $cpp_lf[1], [ 'neu1', 'L' ], [ 'neu2', 'L' ], $cpp_lf[2], $cpp_lf[3] ] },

  { schl => 'c1', name => 'Zeilen geloescht (CRLF-Datei)',
    datei => 'c1.cpp', erwartet => 0,
    vorher  => [ @cpp_crlf ],
    nachher => [ $cpp_crlf[0], $cpp_crlf[3] ] },

  { schl => 'c2', name => 'Zeilen geloescht (gemischte Datei)',
    datei => 'c2.h', erwartet => 0,
    vorher  => [ @gemischt ],
    nachher => [ @gemischt[0 .. 99], @gemischt[200 .. 654] ] },

  { schl => 'd', name => 'Leerzeile CRLF weg, Leerzeile LF dazu',
    datei => 'd.cpp', erwartet => 0,
    vorher  => [ [ 'void f()', 'L' ], [ '{', 'L' ], [ '', 'C' ], [ chr(9) . 'int a;', 'L' ], [ '}', 'L' ] ],
    nachher => [ [ 'void f()', 'L' ], [ '{', 'L' ], [ chr(9) . 'int a;', 'L' ],
                 [ chr(9) . 'int b;', 'L' ], [ '', 'L' ], [ '}', 'L' ] ] },

  { schl => 'd2', name => 'haeufige Zeilen ({ } Leerzeile) verschoben, keine Umwandlung',
    datei => 'd2.cpp', erwartet => 0,
    vorher  => [ [ 'void f()', 'L' ], [ '{', 'C' ], [ '', 'L' ], [ '}', 'C' ],
                 [ 'void g()', 'L' ], [ '{', 'L' ], [ '', 'C' ], [ '}', 'L' ] ],
    nachher => [ [ 'void f()', 'L' ], [ '{', 'C' ], [ '', 'L' ], [ '}', 'C' ],
                 [ 'void g()', 'L' ], [ '{', 'L' ], [ '', 'C' ], [ chr(9) . 'h();', 'L' ], [ '}', 'L' ] ] },

  { schl => 'e', name => 'Datei komplett CRLF -> LF',
    datei => 'e.cpp', erwartet => 1,
    vorher  => [ @cpp_crlf ],
    nachher => [ @cpp_lf ] },

  { schl => 'f', name => 'Datei komplett LF -> CRLF',
    datei => 'f.cpp', erwartet => 1,
    vorher  => [ @cpp_lf ],
    nachher => [ @cpp_crlf ] },

  { schl => 'g', name => 'gemischte Datei, 18 CRLF -> LF (655 Zeilen)',
    datei => 'g.h', erwartet => 1,
    vorher  => [ @gemischt ],
    nachher => [ @gemischt_18_weg ] },

  { schl => 'h1', name => 'Umwandlung LF -> CRLF PLUS Inhaltsaenderung',
    datei => 'h1.cpp', erwartet => 1,
    vorher  => [ [ 'zeile1', 'L' ], [ 'zeile2', 'C' ], [ 'zeile3', 'L' ], [ 'zeile4', 'C' ] ],
    nachher => [ [ 'zeile1', 'C' ], [ 'zeile2', 'C' ], [ 'zeile3', 'C' ], [ 'NEU',    'C' ] ] },

  { schl => 'h2', name => 'Umwandlung CRLF -> LF PLUS Inhaltsaenderung',
    datei => 'h2.cpp', erwartet => 1,
    vorher  => [ [ 'zeile1', 'L' ], [ 'zeile2', 'C' ], [ 'zeile3', 'L' ], [ 'zeile4', 'C' ] ],
    nachher => [ [ 'zeile1', 'L' ], [ 'zeile2', 'L' ], [ 'zeile3', 'L' ], [ 'NEU',    'L' ] ] },

  { schl => 'h3', name => 'Umwandlung PLUS hinzugefuegte Zeilen (ungleiche Anzahl)',
    datei => 'h3.cpp', erwartet => 1,
    vorher  => [ @gemischt ],
    nachher => [ @gemischt_18_weg[0 .. 99], [ 'ganz neu', 'L' ], [ 'noch neu', 'L' ],
                 @gemischt_18_weg[100 .. 654] ] },

  { schl => 'i', name => 'nur Inhalt geaendert, Zeilenenden gleich',
    datei => 'i.cpp', erwartet => 0,
    vorher  => [ @gemischt ],
    nachher => [ @gemischt[0 .. 9], [ 'anders', $gemischt[10][1] ], @gemischt[11 .. 654] ] },

  # --- PR-3: Dateiarten, die frueher gar nicht geprueft wurden -------------
  { schl => 'j1', name => '.def komplett CRLF -> LF',
    datei => 'j1.def', erwartet => 1,
    vorher  => [ alle_mit('C', 'LIBRARY X', 'EXPORTS', '  Foo') ],
    nachher => [ alle_mit('L', 'LIBRARY X', 'EXPORTS', '  Foo') ] },

  { schl => 'j2', name => '.sln komplett CRLF -> LF',
    datei => 'j2.sln', erwartet => 1,
    vorher  => [ alle_mit('C', 'Microsoft Visual Studio Solution File', 'Project(x)', 'EndProject') ],
    nachher => [ alle_mit('L', 'Microsoft Visual Studio Solution File', 'Project(x)', 'EndProject') ] },

  { schl => 'j3', name => '.bat komplett CRLF -> LF',
    datei => 'j3.bat', erwartet => 1,
    vorher  => [ alle_mit('C', 'echo aus', 'exit /b 0') ],
    nachher => [ alle_mit('L', 'echo aus', 'exit /b 0') ] },

  { schl => 'j4', name => '.ps1 komplett LF -> CRLF',
    datei => 'j4.ps1', erwartet => 1,
    vorher  => [ alle_mit('L', 'Write-Output eins', 'Write-Output zwei') ],
    nachher => [ alle_mit('C', 'Write-Output eins', 'Write-Output zwei') ] },

  { schl => 'j5', name => '.pl komplett CRLF -> LF',
    datei => 'j5.pl', erwartet => 1,
    vorher  => [ alle_mit('C', 'use strict;', 'print 1;') ],
    nachher => [ alle_mit('L', 'use strict;', 'print 1;') ] },

  # --- Randfaelle ---------------------------------------------------------
  { schl => 'k', name => 'neue Datei (nicht in HEAD), rein CRLF',
    datei => 'k.cpp', erwartet => 0,
    vorher  => undef,
    nachher => [ @cpp_crlf ] },

  { schl => 'l', name => 'Sonderzeichen zerstoert (U+FFFD dazu)',
    datei => 'l.cpp', erwartet => 1,
    vorher  => [ [ 'Gruesse', 'L' ], [ 'Umlaut ' . chr(0xE4), 'L' ] ],
    nachher => [ [ 'Gruesse', 'L' ], [ 'Umlaut ' . $bad,      'L' ] ] },

  { schl => 'm', name => 'gar nichts geaendert (Datei unveraendert vorgemerkt)',
    datei => 'm.cpp', erwartet => 0,
    vorher  => [ @gemischt ],
    nachher => [ @gemischt ] },

  { schl => 'n', name => 'letzte Zeile ohne Zeilenumbruch, Inhalt ergaenzt',
    datei => 'n.cpp', erwartet => 0,
    roh_vorher  => "eins" . $CR . $LF . "zwei" . $CR . $LF . "drei",
    roh_nachher => "eins" . $CR . $LF . "zwei" . $CR . $LF . "drei" . $CR . $LF . "vier" },

  { schl => 'o', name => 'unbekannte Endung .xyz komplett umgeschrieben (dokumentierte Grenze)',
    datei => 'o.xyz', erwartet => 0,
    vorher  => [ @cpp_crlf ],
    nachher => [ @cpp_lf ] },
);

# ------------------------------------------------------------- Durchlauf

my $wurzel = tempdir("pruefebytes_XXXXXX", TMPDIR => 1, CLEANUP => 1);
my $zurueck = getcwd();

my ($gruen, $rot) = (0, 0);
my @rote;

printf("%-4s %-6s %-62s %s\n", 'Fall', 'Ergeb', 'Beschreibung', 'erwartet');
print '-' x 92, "\n";

for my $f (@faelle) {
    my $repo = "$wurzel/$f->{schl}";
    make_path($repo);
    chdir($repo) or die "chdir $repo: $!\n";

    git('init', '-q', '.');
    git('config', 'user.email', 'test@example.invalid');
    git('config', 'user.name',  'Testsammlung');
    git('config', 'core.autocrlf', 'false');
    git('config', 'commit.gpgsign', 'false');
    schreib('.gitattributes', "* -text$LF");
    git('add', '.gitattributes');
    git('commit', '-q', '--no-verify', '-m', 'Grundstand');

    my $vorher  = exists $f->{roh_vorher}  ? $f->{roh_vorher}
                : defined $f->{vorher}     ? bytes_aus(@{ $f->{vorher} })  : undef;
    my $nachher = exists $f->{roh_nachher} ? $f->{roh_nachher}
                : defined $f->{nachher}    ? bytes_aus(@{ $f->{nachher} }) : undef;

    if (defined $vorher) {
        schreib($f->{datei}, $vorher);
        git('add', '--', $f->{datei});
        git('commit', '-q', '--no-verify', '-m', 'HEAD-Stand');
    }
    if (defined $nachher) {
        schreib($f->{datei}, $nachher);
        git('add', '--', $f->{datei});
    }
    else {
        git('rm', '-q', '--cached', '--', $f->{datei});
    }

    my $pid = open(my $fh, '-|');
    die "fork: $!\n" unless defined $pid;
    if (!$pid) { exec($^X, $SCHRANKE) or exit 127; }
    local $/;
    my $meldung = <$fh>;
    close $fh;
    my $rueck = $? >> 8;
    $meldung = '' unless defined $meldung;

    my $ok = ($rueck == $f->{erwartet});
    $ok ? $gruen++ : ($rot++, push @rote, $f);

    printf("%-4s %-6s %-62s %s\n",
           $f->{schl},
           $ok ? 'GRUEN' : 'ROT',
           $f->{name},
           $f->{erwartet} ? 'anschlagen' : 'durchlassen');

    if (!$ok or $laut) {
        my $t = $meldung;
        $t =~ s/^\s+|\s+$//g;
        $t =~ s/\n/\n       /g;
        print "       Rueckgabe $rueck, erwartet $f->{erwartet}\n";
        print "       $t\n" if length $t;
    }

    chdir($zurueck) or die "chdir zurueck: $!\n";
}

print '-' x 92, "\n";
printf("%d Faelle: %d gruen, %d rot\n", scalar(@faelle), $gruen, $rot);
if ($rot) {
    print "\nROT: ", join(', ', map { $_->{schl} } @rote), "\n";
    print "Die Schranke entscheidet in diesen Faellen falsch. NICHT committen,\n";
    print "bevor das behoben ist - eine Schranke, die grundlos anschlaegt, wird\n";
    print "umgangen; eine, die schweigt, ist wertlos.\n";
    exit 1;
}
print "Die Schranke entscheidet in allen Faellen richtig.\n";
exit 0;
