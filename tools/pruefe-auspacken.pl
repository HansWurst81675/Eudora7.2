#!/usr/bin/perl
use strict;
use warnings;

# pruefe-auspacken.pl - eine Pruefung legt nichts Ausfuehrbares auf die Platte.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE SCHRANKE GIBT
# ---------------------------------------------------------------------------
#
# GEMESSEN am 20.10.2026 um 20:45:19: Defender zog die Datei
# Releases\.pruefe-behoben-1.0.113\Eudora.exe ein. Ausgeloest hat den Zugriff
# perl.exe - also unsere eigene Schranke tools/pruefe-behoben-ausgeliefert.pl,
# die das ZIP zum Messen der Fassung ausgepackt hatte.
#
# Die Folge war nicht nur eine Datei weniger. Die Schranke meldete danach:
#
#     Paket 1.0.113: in der Eudora.exe steht keine Fassung 7.2.0.NN
#
# Eine falsche Aussage ueber ein richtiges Paket - erzeugt von der Pruefung
# selbst. Das war an diesem Tag der dritte Defender-Zugriff; die beiden
# anderen trafen ausgelieferte Pakete (E-124).
#
# Seit 1d081b27 liest die Schranke ueber "unzip -p" aus dem Strom. Was nie auf
# der Platte liegt, kann kein Virenscanner einziehen und keine zweite Pruefung
# versehentlich mitmessen.
#
# Die Regel dahinter steht in Arbeitsweise/pruefung-legt-nichts-ab.md. Diese
# Schranke haelt sie fest, damit die naechste Pruefung sie nicht wieder
# verletzt - der Weg "schnell mal auspacken" ist naheliegend und billig.
#
# ---------------------------------------------------------------------------
# WAS GEPRUEFT WIRD
# ---------------------------------------------------------------------------
#
# Betroffen sind nur PRUEFWERKZEUGE: tools/pruefe-*.pl, tools/pruefe-*.ps1 und
# tools/*-pruefen.pl/.ps1. Ein Bauwerkzeug darf auspacken - tools/paket-
# bauen.ps1 muss es sogar; es stellt etwas her, statt etwas zu beurteilen.
#
# Abgewiesen wird in einer Zeile, die kein reiner Kommentar ist:
#
#     unzip ... ohne -p        (packt in ein Verzeichnis)
#     Expand-Archive           (PowerShell, packt immer auf die Platte)
#     ExtractToDirectory       (.NET, dito)
#     7z x / 7z e              (dito)
#     tar -x / tar x           (dito)
#
# Ausnahme: steht im Werkzeug irgendwo die Zeile
#
#     auspacken-erlaubt: <Begruendung>
#
# dann gilt sie fuer diese Datei. Die Luecke ist damit schriftlich und
# zaehlbar, statt stillschweigend (wie in tools/lehren-schranken.pl).
#
# Aufruf:
#   perl tools/pruefe-auspacken.pl                 # alle Pruefwerkzeuge
#   perl tools/pruefe-auspacken.pl <datei> ...     # genau diese Dateien
#   perl tools/pruefe-auspacken.pl --selbsttest
#
# Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

my $wurzel = '.';
$wurzel = $1 if defined $0 and $0 =~ m{^(.*)[\\/]tools[\\/][^\\/]+$};

sub lies {
    my ($p) = @_;
    open my $h, '<:raw', $p or return undef;
    local $/;
    my $d = <$h>;
    close $h;
    return $d;
}

sub ist_pruefwerkzeug {
    my ($pfad) = @_;
    my ($name) = $pfad =~ m{([^\\/]+)$};
    return 0 unless defined $name;
    return 1 if $name =~ /^pruefe-.*[.](?:pl|ps1)$/;
    return 1 if $name =~ /-pruefen[.](?:pl|ps1)$/;
    return 0;
}

# Gibt die Liste der Maengel zurueck: [Zeilennummer, Muster, Zeile].
sub maengel {
    my ($inhalt) = @_;
    return () unless defined $inhalt;
    return () if $inhalt =~ /auspacken-erlaubt:/;

    my @m;
    my $nr = 0;
    for my $z (split /\r?\n/, $inhalt) {
        $nr++;
        # Reine Kommentarzeilen zaehlen nicht - eine Schranke, die ihre eigene
        # Begruendung liest, schwaerzt sich selbst an
        # (Arbeitsweise/schranke-liest-nur-code.md).
        next if $z =~ /^\s*#/;
        next unless $z =~ /\S/;

        if ($z =~ /\bunzip\b/ && $z !~ /unzip\s+(?:-\w+\s+)*-\w*p/) {
            push @m, [ $nr, 'unzip ohne -p', $z ];
        }
        push @m, [ $nr, 'Expand-Archive',     $z ] if $z =~ /\bExpand-Archive\b/i;
        push @m, [ $nr, 'ExtractToDirectory', $z ] if $z =~ /\bExtractToDirectory\b/;
        push @m, [ $nr, '7z x/e',             $z ] if $z =~ /\b7z(?:[.]exe)?\s+[xe]\b/i;
        push @m, [ $nr, 'tar -x',             $z ] if $z =~ /\btar\s+-?x/;
    }
    return @m;
}

# ---------------------------------------------------------------------------
# Selbsttest - beide Richtungen, nicht nur die gewuenschte
# (Arbeitsweise/schranke-gegentesten.md).
# ---------------------------------------------------------------------------
sub selbsttest {
    my @faelle = (
        [ 'unzip in ein Verzeichnis',
          'system("unzip -o -j -q $zip -d $tmp");' . "\n", 1 ],
        [ 'unzip -p aus dem Strom (erlaubt)',
          q{open(my $pz, '-|', "unzip -p $zip Eudora.exe");} . "\n", 0 ],
        [ 'Expand-Archive',
          'Expand-Archive -Path $zip -DestinationPath $ziel' . "\n", 1 ],
        [ 'ExtractToDirectory',
          '[System.IO.Compression.ZipFile]::ExtractToDirectory($a,$b)' . "\n", 1 ],
        [ '7z x',
          '& 7z x $zip -oZiel' . "\n", 1 ],
        [ 'tar -x',
          'system("tar -xf $archiv");' . "\n", 1 ],
        [ 'nur im Kommentar genannt (erlaubt)',
          "# frueher stand hier Expand-Archive\nprint \"nichts\";\n", 0 ],
        [ 'mit Begruendung ausgenommen (erlaubt)',
          "# auspacken-erlaubt: dieses Werkzeug baut das Paket\n"
          . 'Expand-Archive -Path $z -DestinationPath $d' . "\n", 0 ],
        [ 'gar nichts dergleichen (erlaubt)',
          'print "hallo";' . "\n", 0 ],
    );
    my ($gut, $schlecht) = (0, 0);
    for my $f (@faelle) {
        my ($name, $text, $soll) = @$f;
        my $ist = (maengel($text) ? 1 : 0);
        if ($ist == $soll) { $gut++; }
        else { $schlecht++; print "  FEHLT: $name - erwartet $soll, bekommen $ist\n"; }
    }

    # Namenspruefung in beide Richtungen.
    my @namen = (
        [ 'tools/pruefe-behoben-ausgeliefert.pl', 1 ],
        [ 'tools/release-pruefen.pl',             1 ],
        [ 'tools/paket-pruefen.ps1',              1 ],
        [ 'tools/paket-bauen.ps1',                0 ],
        [ 'tools/testlauf.ps1',                   0 ],
    );
    for my $n (@namen) {
        my $ist = ist_pruefwerkzeug($n->[0]);
        if ($ist == $n->[1]) { $gut++; }
        else { $schlecht++; print "  FEHLT: Name $n->[0] - erwartet $n->[1], bekommen $ist\n"; }
    }

    printf "  Selbsttest pruefe-auspacken: %d von %d\n", $gut, $gut + $schlecht;
    return $schlecht ? 3 : 0;
}

# ---------------------------------------------------------------------------
if (@ARGV == 1 && $ARGV[0] eq '--selbsttest') { exit selbsttest(); }

my @dateien = @ARGV;
unless (@dateien) {
    @dateien = grep { ist_pruefwerkzeug($_) }
               (glob("$wurzel/tools/*.pl"), glob("$wurzel/tools/*.ps1"));
}

my $fehler = 0;
my $geprueft = 0;
for my $d (@dateien) {
    next unless -f $d;
    $geprueft++;
    my @m = maengel(lies($d));
    next unless @m;
    $fehler++;
    for my $x (@m) {
        my $z = $x->[2];
        $z =~ s/^\s+//;
        $z = substr($z, 0, 110);
        print "  $d:$x->[0] packt aus ($x->[1]):\n      $z\n";
    }
}

if ($fehler) {
    print "\n  Eine Pruefung legt nichts Ausfuehrbares auf die Platte.\n";
    print "  Aus dem Strom lesen (unzip -p), oder die Ausnahme begruenden:\n";
    print "  eine Zeile \"auspacken-erlaubt: <Grund>\" in das Werkzeug.\n";
    print "  Anlass: 20.10.2026, 20:45:19 - Defender zog die von der Schranke\n";
    print "  ausgepackte Eudora.exe ein, die Schranke meldete danach eine\n";
    print "  falsche Fassung fuer ein richtiges Paket (E-124).\n";
    exit 1;
}
print "  pruefe-auspacken: $geprueft Pruefwerkzeuge, keines packt aus.\n";
exit 0;
