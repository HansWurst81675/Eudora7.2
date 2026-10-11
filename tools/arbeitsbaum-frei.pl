#!/usr/bin/perl
#
# Beantwortet eine Frage: welchen Arbeitsbaum darf der naechste Agent bekommen?
#
#   perl tools/arbeitsbaum-frei.pl                    Lage aller Baeume
#   perl tools/arbeitsbaum-frei.pl --belegen NAME     Baum fuer Agent NAME buchen
#   perl tools/arbeitsbaum-frei.pl --freigeben NAME   Buchung aufheben
#   perl tools/arbeitsbaum-frei.pl --neu NAME         neuen Baum anlegen und buchen
#
# Rueckgabewert 0 = mindestens ein Baum ist vergebbar.  1 = keiner.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 05.09.2026 habe ich zwei Agenten denselben Arbeitsbaum zugeteilt
# (Eudora7.2-wt-paket). Der zweite wechselte dort mit "git checkout -B" den
# Branch und loeschte dabei die UNVERSIONIERTE Arbeit des ersten. Sie ging nur
# deshalb nicht verloren, weil der betroffene Agent es selbst bemerkte.
#
# Gregor: "du musst deine agenten besser koordinieren, damit nichts verloren
# geht! das ist wichtig. jedes mal. bei jeder session!"
#
# Und auf die Antwort "gemessen statt geglaubt": "das sollte ja bereits gelten!
# schon seit langem. warum immer noch fehlerhaft?"
#
# Er hat recht. Die Regel stand als Grundsatz in der Ablage. Ein Grundsatz
# feuert nicht - ein Handgriff feuert.
#
# DER MANGEL DER ERSTEN FASSUNG, und warum es das Verzeichnis gibt
#
# Die erste Fassung dieses Werkzeugs meldete einen Baum als FREI, sobald darin
# keine ungesicherten Dateien lagen. Beim ersten Lauf nannte es prompt zwei
# Baeume frei, in denen gerade Agenten arbeiteten - sie hatten nur noch nichts
# geschrieben. Das ist genau die Luecke, gegen die es gebaut wurde.
#
# Aus dem Dateisystem laesst sich "hier arbeitet jemand" nicht ablesen. Deshalb
# fuehrt dieses Werkzeug ein VERZEICHNIS: wer einen Baum vergibt, bucht ihn.
# Steht keine Buchung drin, sagt das Werkzeug nicht "frei", sondern "keine
# Buchung, keine ungesicherte Arbeit" - und weist darauf hin, dass eine fehlende
# Buchung kein Beweis fuer einen unbenutzten Baum ist.
#
# Das Verzeichnis liegt unter .git/agenten-zuteilung (nicht im Arbeitsbaum, denn
# es ist Sitzungszustand und gehoert nicht in einen Commit; und nicht unter
# .claude, das ist nicht in jedem Klon da).
#
use strict;
use warnings;
use File::Spec;

# --- git aufrufen, ohne dass seine Fehlerausgabe die Anzeige verunziert -------
#
# "no upstream configured" ist hier kein Fehler, sondern eine gueltige Antwort.

sub git {
    my @a = @_;
    my $pid = open(my $fh, '-|');
    return '' unless defined $pid;
    if (!$pid) {
        open(STDERR, '>', File::Spec->devnull);
        exec('git', @a);
        exit 127;
    }
    local $/;
    my $o = <$fh>;
    close $fh;
    return '' unless defined $o;
    # NICHT chomp: "local $/" schaltet den Zeilentrenner ab, damit wird chomp
    # wirkungslos und der Pfad hiesse ".git\n". Genau dieser Fehler hat am
    # 05.09.2026 die Buchungen ins Leere laufen lassen - die Datei wurde unter
    # ".git\n/agenten-zuteilung" gesucht und nie gefunden.
    $o =~ s/\s+\z//;
    return $o;
}

# --- Verzeichnis der Buchungen ------------------------------------------------

my $gitdir = git('rev-parse', '--git-common-dir');
$gitdir = git('rev-parse', '--git-dir') unless length $gitdir;
die "Kein git-Verzeichnis.\n" unless length $gitdir;
my $buchdatei = "$gitdir/agenten-zuteilung";

sub buchungen_lesen {
    my %b;
    return %b unless -f $buchdatei;
    open(my $f, '<', $buchdatei) or return %b;
    while (my $z = <$f>) {
        chomp $z;
        next unless $z =~ /^(\S+)\t(.+)$/;
        $b{$1} = $2;
    }
    close $f;
    return %b;
}

sub buchungen_schreiben {
    my %b = @_;
    open(my $f, '>', $buchdatei) or die "Kann $buchdatei nicht schreiben: $!\n";
    print $f "$_\t$b{$_}\n" for sort keys %b;
    close $f;
}

# --- Argumente ----------------------------------------------------------------

my ($belegen, $freigeben, $neu);
for my $i (0 .. $#ARGV) {
    $belegen   = $ARGV[$i+1] if $ARGV[$i] eq '--belegen';
    $freigeben = $ARGV[$i+1] if $ARGV[$i] eq '--freigeben';
    $neu       = $ARGV[$i+1] if $ARGV[$i] eq '--neu';
}

my %buchung = buchungen_lesen();

if (defined $freigeben and length $freigeben) {
    my @weg = grep { $buchung{$_} eq $freigeben } keys %buchung;
    delete $buchung{$_} for @weg;
    buchungen_schreiben(%buchung);
    print "\n  Freigegeben: " . (@weg ? join(', ', map { _kurz($_) } @weg) : "nichts fuer '$freigeben' gebucht") . "\n\n";
    exit 0;
}

# --- Baeume einsammeln --------------------------------------------------------

my $wurzel = git('rev-parse', '--show-toplevel');
die "Kein git-Verzeichnis.\n" unless length $wurzel;

my (@baeume, $akt);
for my $z (split /\n/, git('worktree', 'list', '--porcelain')) {
    if ($z =~ /^worktree (.+)$/) { $akt = { pfad => $1, branch => '(abgeloest)' }; push @baeume, $akt; }
    elsif ($z =~ /^branch refs\/heads\/(.+)$/ and $akt) { $akt->{branch} = $1; }
}

sub _kurz { my $p = shift // ''; $p =~ s{.*/}{}; return $p }

# --- Lage je Baum -------------------------------------------------------------

my (@vergebbar, @gefaehrdet);

printf("\n  %-30s %-22s %s\n", 'Arbeitsbaum', 'Branch', 'Lage');
print "  " . ('-' x 86) . "\n";

for my $b (@baeume) {
    my $p = $b->{pfad};
    my $ist_haupt = ($p eq $wurzel);

    my @st = grep { length } split /\n/, git('-C', $p, 'status', '--porcelain');
    my @geaendert = grep { !/^\?\?/ } @st;

    # Unverfolgtes: Bau-Ausgaben und Protokolle zaehlen nicht, alles andere
    # schon - dort stecken die Berichte, die beim Branchwechsel verschwinden.
    my @neu;
    for my $z (grep { /^\?\?/ } @st) {
        my $n = $z; $n =~ s/^\?\?\s+//; $n =~ s/^"|"$//g;
        next if $n =~ m{^Eudora71/(Bin|Obj)/};
        next if $n =~ m{^\.claude/};
        next if $n =~ m{\.(log|tmp|obj|pdb|ilk)$};
        next if $n =~ m{/$};
        push @neu, $n;
    }

    my $ungepusht = git('-C', $p, 'rev-list', '--count', '@{u}..HEAD');
    $ungepusht = 0 unless $ungepusht =~ /^\d+$/;

    my @gruende;
    push @gruende, scalar(@geaendert) . " geaendert" if @geaendert;
    push @gruende, scalar(@neu) . " unverfolgt"      if @neu;
    push @gruende, "$ungepusht ungepusht"            if $ungepusht > 0;

    my $agent = $buchung{$p};

    my $lage;
    if ($ist_haupt) {
        $lage = 'HAUPTBAUM - nie an einen Agenten geben';
    }
    elsif (defined $agent) {
        $lage = "GEBUCHT fuer $agent" . (@gruende ? ' (' . join(', ', @gruende) . ')' : '');
    }
    elsif (@gruende) {
        $lage = 'ungesicherte Arbeit: ' . join(', ', @gruende);
    }
    else {
        $lage = 'keine Buchung, nichts Ungesichertes';
        push @vergebbar, $p;
    }

    printf("  %-30s %-22s %s\n", substr(_kurz($p), 0, 30), substr($b->{branch}, 0, 22), $lage);

    if (!$ist_haupt and @neu) {
        push @gefaehrdet, map { _kurz($p) . " : $_" } @neu;
        for my $n (@neu[0 .. ($#neu > 2 ? 2 : $#neu)]) {
            print "  " . (' ' x 30) . "  ! $n\n";
        }
        print "  " . (' ' x 30) . "  ! ... und " . (@neu - 3) . " weitere\n" if @neu > 3;
    }
}

print "\n";

# --- Gefaehrdetes zuerst ------------------------------------------------------

if (@gefaehrdet) {
    print "  WUERDE BEI EINEM BRANCHWECHSEL VERLORENGEHEN:\n\n";
    print "    $_\n" for @gefaehrdet;
    print "\n  Diese Dateien sind unverfolgt. Wer den Baum weitergibt, sichert sie\n";
    print "  vorher - committen und pushen, oder herauskopieren.\n\n";
}

# --- Urteil -------------------------------------------------------------------

if (@vergebbar) {
    print "  Vergebbar, soweit dieses Werkzeug es wissen kann:\n\n";
    print "    $_\n" for @vergebbar;
    print "\n";
    print "  ACHTUNG: \"keine Buchung\" heisst NICHT \"kein Agent darin\". Ein Agent,\n";
    print "  der noch nichts geschrieben hat, ist von aussen nicht zu erkennen -\n";
    print "  genau daran ist die erste Fassung dieses Werkzeugs gescheitert. Wer\n";
    print "  einen Baum vergibt, BUCHT ihn:\n\n";
    print "    perl tools/arbeitsbaum-frei.pl --belegen <AGENTENNAME>\n\n";
}
else {
    print "  Kein Baum ohne Buchung und ohne ungesicherte Arbeit. Neuen anlegen:\n\n";
    print "    perl tools/arbeitsbaum-frei.pl --neu <AGENTENNAME>\n\n";
}

# --- Buchen -------------------------------------------------------------------

if (defined $belegen and length $belegen) {
    if (!@vergebbar) {
        print "  Nichts zu buchen - kein Baum vergebbar.\n\n";
        exit 1;
    }
    my $p = $vergebbar[0];
    $buchung{$p} = $belegen;
    buchungen_schreiben(%buchung);
    my ($br) = map { $_->{branch} } grep { $_->{pfad} eq $p } @baeume;
    print "  Gebucht fuer $belegen:\n\n";
    print "    Pfad:   $p\n";
    print "    Branch: $br\n\n";
    print "  Beides WOERTLICH in den Auftrag des Agenten, mit der Auflage:\n";
    print "  nur in diesem Baum arbeiten, am Ende committen UND pushen.\n\n";
    exit 0;
}

# --- Neuen anlegen ------------------------------------------------------------

if (defined $neu and length $neu) {
    (my $name = $neu) =~ s/[^A-Za-z0-9_-]//g;
    die "Unbrauchbarer Name.\n" unless length $name;

    my $ziel   = "$wurzel/../Eudora7.2-wt-\L$name";
    my $branch = "wt/\L$name";
    my $basis  = git('rev-parse', '--abbrev-ref', 'HEAD');

    if (-d $ziel) {
        print "  Es gibt schon ein Verzeichnis $ziel - nicht angelegt.\n\n";
        exit 1;
    }

    my $rc = system('git', 'worktree', 'add', '-q', '-b', $branch, $ziel, $basis);
    if ($rc != 0) { print "  Anlegen fehlgeschlagen.\n\n"; exit 1; }

    my $voll = git('-C', $ziel, 'rev-parse', '--show-toplevel');
    $voll = $ziel unless length $voll;
    $buchung{$voll} = $neu;
    buchungen_schreiben(%buchung);

    print "  Angelegt und gebucht fuer $neu:\n\n";
    print "    Pfad:   $voll\n";
    print "    Branch: $branch  (von $basis)\n\n";
    print "  Beides WOERTLICH in den Auftrag, mit der Auflage: nur in diesem Baum\n";
    print "  arbeiten, am Ende committen UND pushen.\n\n";
    exit 0;
}

exit(@vergebbar ? 0 : 1);
