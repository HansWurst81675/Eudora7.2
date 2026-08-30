#!/usr/bin/perl
#
# Sucht Endlosrekursionen in einer Klassenschicht - auch wechselseitige.
#
#   perl tools/rekursion-suchen.pl <verzeichnis>
#
# Baut einen Aufrufgraphen ueber alle Methodenruempfe und meldet jeden Zyklus.
# Beruecksichtigt nur Aufrufe OHNE Objekt davor (also implizit ueber this) und
# ohne "::" davor - denn Basis::Name() ist genau der richtige Weg und darf nicht
# gemeldet werden.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Beim ersten Startversuch am 30.08.2026 starb Eudora mit
# EXCEPTION_STACK_OVERFLOW beim Erzeugen des Hauptfensters. Beim Nachbau fremder
# Klassen ist das die haeufigste Falle: eine ueberschriebene Methode ruft den
# eigenen Namen statt Basisklasse::Name. Das uebersetzt sich fehlerfrei und faellt
# erst zur Laufzeit auf.
#
# GRENZE: Ueberladungen werden am Namen unterschieden, nicht an den
# Parametertypen. Ein Zyklus zwischen zwei gleichnamigen Ueberladungen ist daher
# ein Fehlalarm und muss von Hand geprueft werden. Deshalb wird zu jedem Zyklus
# die Fundstelle mitgedruckt.
#
use strict;
use warnings;

my $verz = shift or die "Aufruf: perl tools/rekursion-suchen.pl <verzeichnis>\n";
my @quellen = (-d $verz) ? glob("$verz/*.cpp") : ($verz);
@quellen or die "Keine .cpp in $verz\n";

my (%ruft, %ort, %argzahl);

sub argumente {                       # grobe Zaehlung der Argumente eines Aufrufs
    my ($s) = @_;
    return 0 if $s =~ /^\s*$/;
    my ($tiefe, $n) = (0, 1);
    for my $c (split //, $s) {
        $tiefe++ if $c eq '(' or $c eq '<';
        $tiefe-- if $c eq ')' or $c eq '>';
        $n++ if $c eq ',' && $tiefe == 0;
    }
    return $n;
}

for my $datei (@quellen) {
    open(my $fh, '<:raw', $datei) or next;
    local $/; my $text = <$fh>; close $fh;
    my @z = split /\n/, $text;

    for (my $i = 0; $i < @z; $i++) {
        next unless $z[$i] =~ /^[A-Za-z_][\w\s\*\&:<>,]*?\b([A-Za-z_]\w*)::([A-Za-z_~]\w*)\s*\((.*)$/;
        my ($klasse, $methode, $rest) = ($1, $2, $3);
        next if $methode eq $klasse or $methode =~ /^~/;
        my $sig = "$klasse\::$methode/" . argumente($rest =~ s/\).*$//rs);
        $ort{$sig} = "$datei:" . ($i + 1);

        my ($tiefe, $begonnen) = (0, 0);
        for (my $j = $i; $j < @z && $j < $i + 500; $j++) {
            my $zeile = $z[$j];
            if ($begonnen && $zeile !~ m{^\s*//}) {
                while ($zeile =~ /(^|[^\w:.>\)])([A-Za-z_]\w*)\s*\(([^;]*)/g) {
                    my ($ziel, $args) = ($2, $3);
                    next if $ziel =~ /^(if|for|while|switch|return|sizeof|catch|new|delete|ASSERT|VERIFY|TRACE|DYNAMIC_DOWNCAST|MAKEINTRESOURCE|CRect|CPoint|CSize|CString|memset|memcpy|min|max)$/;
                    my $zsig = "$klasse\::$ziel/" . argumente($args =~ s/\).*$//rs);
                    push @{ $ruft{$sig} }, [ $zsig, $j + 1, ($zeile =~ s/^\s+//r) ];
                }
            }
            my $auf = ($zeile =~ tr/{//); my $zu = ($zeile =~ tr/}//);
            $begonnen = 1 if !$begonnen && $auf;
            $tiefe += $auf - $zu;
            if ($begonnen && $tiefe <= 0) { $i = $j; last; }
        }
    }
}

# Zyklensuche
my (%farbe, @pfad, @zyklen, %gesehen);
sub lauf {
    my ($k) = @_;
    $farbe{$k} = 1; push @pfad, $k;
    for my $kante (@{ $ruft{$k} || [] }) {
        my $z = $kante->[0];
        next unless exists $ort{$z};                 # nur Ziele, die wir kennen
        if (($farbe{$z} || 0) == 1) {
            my ($p) = grep { $pfad[$_] eq $z } 0 .. $#pfad;
            my @zy = @pfad[$p .. $#pfad];
            my $s = join(' -> ', @zy);
            push @zyklen, [ \@zy, $kante ] unless $gesehen{$s}++;
        } elsif (!$farbe{$z}) { lauf($z); }
    }
    pop @pfad; $farbe{$k} = 2;
}
lauf($_) for sort keys %ort;

if (!@zyklen) { print "Keine Zyklen gefunden.\n"; exit 0; }
for my $e (@zyklen) {
    my ($zy, $kante) = @$e;
    printf "ZYKLUS (%d Glied%s): %s -> %s\n", scalar(@$zy), (@$zy == 1 ? '' : 'er'),
           join(' -> ', @$zy), $zy->[0];
    print "    $ort{$_}\n" for @$zy;
    print "    Rueckkante bei Zeile $kante->[1]: $kante->[2]\n\n";
}
printf "%d Zyklus/Zyklen.\n", scalar @zyklen;
exit 1;
