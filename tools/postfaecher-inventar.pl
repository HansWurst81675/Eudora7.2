#!/usr/bin/perl
use strict;
use warnings;

# postfaecher-inventar.pl - was steckt in den alten Testverzeichnissen, und
# ist es anderswo schon vorhanden?
#
# WARUM ES DAS GIBT
#
# Am 10.09.2026 wollte Gregor die alten Testverzeichnisse aufraeumen:
# "loesch die alten versionen, die du nicht mehr brauchst. aber falls
# irgendwelche mail postfaecher noch gesichert werden muessen, dann sichere
# sie vorher."
#
# Am selben Vormittag ist Post verlorengegangen, weil ich einen
# Kopierbefehl geschrieben habe, der nur *.mbx nahm - Anhaenge liegen bei
# Eudora in "attach", eingebettete Bilder in "Embedded", und in der .mbx
# steht nur eine Zeile "Attachment Converted:".
#
# Vor dem Loeschen wird deshalb GEMESSEN, nicht geschaetzt. Dieses Werkzeug
# vergleicht jedes Testverzeichnis gegen ein Bezugsverzeichnis und sagt je
# Verzeichnis, ob es etwas enthaelt, das dort FEHLT.
#
# Verglichen wird dreierlei:
#
#   Nachrichten   ueber Message-ID, ersatzweise ueber Betreff+Datum. Die
#                 Dateigroesse taugt nicht: dieselbe Nachricht hat nach
#                 einem Kompaktieren eine andere.
#   Anhaenge      Dateiname und Groesse in "attach"
#   Bilder        dasselbe in "Embedded"
#
# AUFRUF
#
#   perl tools/postfaecher-inventar.pl
#   perl tools/postfaecher-inventar.pl --bezug "C:\Pfad\zum\Verzeichnis"
#   perl tools/postfaecher-inventar.pl --wurzel "C:\Users\Gregor"
#
# Rueckgabe: 0 = alles ist im Bezugsverzeichnis vorhanden, die anderen
# duerfen weg. 1 = mindestens eines enthaelt etwas Einzigartiges.
#
# ES LOESCHT NICHTS. Es sagt nur, was gefahrlos weg darf.

my %opt = (
    wurzel => 'C:/Users/Gregor',
    bezug  => '',
    muster => 'Eudora72-*',
);

while (@ARGV) {
    my $a = shift @ARGV;
    if    ($a eq '--wurzel') { $opt{wurzel} = shift @ARGV }
    elsif ($a eq '--bezug')  { $opt{bezug}  = shift @ARGV }
    elsif ($a eq '--muster') { $opt{muster} = shift @ARGV }
    else { die "unbekannt: $a\n" }
}
$opt{wurzel} =~ s{\\}{/}g;
$opt{bezug}  =~ s{\\}{/}g;

# --- Verzeichnisse einsammeln ---------------------------------------------
my @verz = sort grep { -d $_ } glob("$opt{wurzel}/$opt{muster}");
unless (@verz) {
    print "\n  Keine Verzeichnisse nach dem Muster '$opt{muster}' gefunden.\n\n";
    exit 0;
}

# Ohne Angabe ist das Bezugsverzeichnis das mit der hoechsten Nummer.
unless ($opt{bezug}) {
    my @sortiert = sort {
        my ($x) = $a =~ /(\d+)-release$/; my ($y) = $b =~ /(\d+)-release$/;
        ($x || 0) <=> ($y || 0)
    } grep { /-release$/ } @verz;
    $opt{bezug} = $sortiert[-1] if @sortiert;
}
die "kein Bezugsverzeichnis\n" unless $opt{bezug} && -d $opt{bezug};

# --- Eine Mailbox aufschluesseln ------------------------------------------
sub nachrichten_aus {
    my ($datei) = @_;
    my %n;
    open my $h, '<:raw', $datei or return %n;
    my ($id, $betreff, $datum, $imkopf) = ('', '', '', 0);
    my $merken = sub {
        return unless $betreff ne '' || $id ne '';
        my $s = $id ne '' ? "id:$id" : "bd:$betreff|$datum";
        $n{$s} = { betreff => $betreff, datum => $datum };
        ($id, $betreff, $datum) = ('', '', '');
    };
    while (my $z = <$h>) {
        $z =~ s/\r?\n$//;
        if ($z =~ /^From /) { $merken->(); $imkopf = 1; next; }
        if ($imkopf) {
            if    ($z eq '')                        { $imkopf = 0 }
            elsif ($z =~ /^Message-ID:\s*(.+)$/i)   { $id      = lc $1 }
            elsif ($z =~ /^Subject:\s*(.*)$/i)      { $betreff = $1 }
            elsif ($z =~ /^Date:\s*(.+)$/i)         { $datum   = $1 }
        }
    }
    close $h;
    $merken->();
    return %n;
}

sub bestand_aus {
    my ($verz) = @_;
    my %b = (nachrichten => {}, dateien => {});
    my $m = "$verz/Mailverzeichnis";
    return %b unless -d $m;

    for my $mbx (glob("$m/*.mbx")) {
        next unless -s $mbx;
        my %n = nachrichten_aus($mbx);
        $b{nachrichten}{$_} = $n{$_} for keys %n;
    }
    for my $u ('attach', 'Embedded') {
        next unless -d "$m/$u";
        opendir(my $d, "$m/$u") or next;
        for my $e (readdir $d) {
            next if $e =~ /^\./;
            my $p = "$m/$u/$e";
            next unless -f $p;
            $b{dateien}{ lc("$u/$e") . '|' . (-s $p) } = $p;
        }
        closedir $d;
    }
    return %b;
}

# --- Bezug ----------------------------------------------------------------
print "\n  Postfaecher-Inventar\n";
print '  ', '-' x 72, "\n";
printf "  Bezug: %s\n", $opt{bezug};

my %bezug = bestand_aus($opt{bezug});
printf "         %d Nachrichten, %d Dateien in attach/Embedded\n",
       scalar keys %{ $bezug{nachrichten} }, scalar keys %{ $bezug{dateien} };
print '  ', '-' x 72, "\n\n";

# --- Vergleich ------------------------------------------------------------
printf "  %-32s %10s %10s   %s\n", 'Verzeichnis', 'Nachr.', 'Dateien', 'Urteil';
printf "  %-32s %10s %10s   %s\n", '-' x 32, '-' x 10, '-' x 10, '-' x 22;

my @einzigartig;

for my $v (@verz) {
    next if $v eq $opt{bezug};
    my $name = (split m{/}, $v)[-1];
    my %b = bestand_aus($v);

    my @fehlt_n = grep { !exists $bezug{nachrichten}{$_} } keys %{ $b{nachrichten} };
    my @fehlt_d = grep { !exists $bezug{dateien}{$_} }     keys %{ $b{dateien} };

    my $urteil;
    if (!%{ $b{nachrichten} } && !%{ $b{dateien} }) {
        $urteil = 'leer - darf weg';
    }
    elsif (!@fehlt_n && !@fehlt_d) {
        $urteil = 'alles im Bezug - darf weg';
    }
    else {
        $urteil = sprintf('EINZIGARTIG: %d Nachr., %d Dateien', scalar @fehlt_n, scalar @fehlt_d);
        push @einzigartig, { verz => $v, name => $name,
                             n => \@fehlt_n, d => \@fehlt_d, b => \%b };
    }

    printf "  %-32s %10d %10d   %s\n", $name,
           scalar keys %{ $b{nachrichten} }, scalar keys %{ $b{dateien} }, $urteil;
}

# --- Was einzigartig ist, im Klartext -------------------------------------
if (@einzigartig) {
    print "\n  NICHT LOESCHEN - diese Verzeichnisse enthalten Einzigartiges:\n";
    for my $e (@einzigartig) {
        print "\n    $e->{name}\n";
        for my $s (sort @{ $e->{n} }) {
            my $t = $e->{b}{nachrichten}{$s}{betreff} || '(ohne Betreff)';
            $t = substr($t, 0, 66) . '...' if length($t) > 66;
            print "      Nachricht: $t\n";
        }
        for my $s (sort @{ $e->{d} }) {
            my ($rel, $gr) = split /\|/, $s;
            printf "      Datei:     %-52s %s B\n", $rel, $gr;
        }
    }
    print "\n  Erst sichern, dann loeschen.\n\n";
    exit 1;
}

print "\n  Alles ist im Bezugsverzeichnis vorhanden.\n";
print "  Die uebrigen Verzeichnisse duerfen geloescht werden.\n\n";
exit 0;
