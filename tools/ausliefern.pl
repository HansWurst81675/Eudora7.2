#!/usr/bin/perl
#
# Zaehlt hoch, baut, packt und liefert aus - in EINEM Schritt.
#
#   perl tools/ausliefern.pl              zeigt, was geschehen wuerde
#   perl tools/ausliefern.pl --machen     fuehrt es aus
#   perl tools/ausliefern.pl --pruefen    prueft nur, ob Nummern eindeutig sind
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Gregor am 05.09.2026: "sooo nicht! garantiert nicht! sowas fangen wir gar
# nicht an, habe ich gesagt. version muss eindeutig sein."
#
# Und davor, auf dieselbe Sache: "warum bist du so dumm? und machst den fehler
# jedes mal neu?"
#
# Die Antwort ist unangenehm einfach. Das Hochzaehlen war eine UEBERLEGUNG und
# kein ARBEITSSCHRITT. Der Ablauf war: bauen, kopieren. Die Versionsnummer kam
# nur dran, wenn ich zufaellig daran dachte. Nichts hat mich gezwungen - und
# deshalb ist derselbe Fehler an EINEM Abend DREIMAL passiert:
#
#   drei verschiedene ZIPs unter v1.0.3      (Befund V-1)
#   fuenf Quelleaenderungen unter 7.2.0.4     (LEKTOR)
#   zwei Binaerdateien unter 7.2.0.5          (eine Stunde nach dem Hochzaehlen
#                                              wegen genau dieses Problems)
#
# Die Bau-Kennung im Titel unterscheidet die Faelle zwar - aber Gregor liest die
# Version, und die stand dreimal auf demselben Wert.
#
# Dieses Werkzeug macht aus der Ueberlegung einen Handgriff: hochzaehlen, bauen,
# packen, ausliefern gehoeren zusammen und laufen zusammen. Wer es benutzt, kann
# das Hochzaehlen nicht vergessen, weil es Schritt eins ist.
#
# Es PRUEFT ausserdem nach: liegt in einem Auslieferungsverzeichnis schon eine
# Eudora.exe mit derselben Versionsnummer, aber anderer Kennung, bricht es ab.
#
use strict;
use warnings;
use File::Spec;

my $machen  = grep { $_ eq '--machen'  } @ARGV;
my $pruefen = grep { $_ eq '--pruefen' } @ARGV;

sub git {
    my @a = @_;
    my $pid = open(my $fh, '-|');
    return '' unless defined $pid;
    if (!$pid) { open(STDERR,'>',File::Spec->devnull); exec('git',@a); exit 127 }
    local $/;
    my $o = <$fh>;
    close $fh;
    return '' unless defined $o;
    $o =~ s/\s+\z//;                     # NICHT chomp: local $/ macht chomp wirkungslos
    return $o;
}

sub roh {
    my ($p) = @_;
    open(my $f,'<:raw',$p) or return undef;
    local $/;
    my $d = <$f>;
    close $f;
    return $d;
}

# --- Wo stehen wir? -----------------------------------------------------------

my $vh = roh('Eudora71/Version.h');
die "Eudora71/Version.h nicht lesbar\n" unless defined $vh;
my ($produkt) = $vh =~ /EUDORA_BUILD_VERSION\s+"([0-9.]+)"/;
die "EUDORA_BUILD_VERSION nicht gefunden\n" unless defined $produkt;

my $paket = roh('VERSION');
$paket = '' unless defined $paket;
$paket =~ s/\s+//g;

my ($p1,$p2,$p3,$p4) = $produkt =~ /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/
    or die "Produktversion '$produkt' hat nicht die Form a.b.c.d\n";
my ($k1,$k2,$k3) = $paket =~ /^(\d+)\.(\d+)\.(\d+)$/
    or die "Paketversion '$paket' hat nicht die Form a.b.c\n";

printf("\n  Jetzt:   Produkt %s   Paket %s\n", $produkt, $paket);
printf("  Danach:  Produkt %d.%d.%d.%d   Paket %d.%d.%d\n\n",
       $p1,$p2,$p3,$p4+1, $k1,$k2,$k3+1);

# --- Sind die vorhandenen Auslieferungen eindeutig? ---------------------------
#
# Das ist die eigentliche Schranke: zwei Verzeichnisse mit derselben Version,
# aber verschiedenen Kennungen sind genau der Fehler, gegen den es geht.

my $heim = $ENV{USERPROFILE} || $ENV{HOME} || 'C:/Users/Gregor';
$heim =~ s{\\}{/}g;

my %gesehen;
my @doppelt;

if (opendir(my $dh, $heim)) {
    for my $n (sort grep { /^Eudora72-/ } readdir $dh) {
        my $exe = "$heim/$n/Eudora.exe";
        next unless -f $exe;
        my $d = roh($exe);
        next unless defined $d;
        my ($ver)     = $d =~ /(7\.2\.0\.\d+)/;
        my ($kennung) = $d =~ /(\d+\.\d+\.\d+\+[0-9a-f]+\*?)/;
        $ver     = '?' unless defined $ver;
        $kennung = '?' unless defined $kennung;
        printf("    %-30s %-9s %s\n", $n, $ver, $kennung);
        if (exists $gesehen{$ver} and $gesehen{$ver} ne $kennung) {
            push @doppelt, "$ver: $gesehen{$ver} und $kennung";
        }
        $gesehen{$ver} = $kennung;
    }
    closedir $dh;
}

if (@doppelt) {
    print "\n  NICHT EINDEUTIG - dieselbe Version, verschiedene Bauten:\n\n";
    print "    $_\n" for @doppelt;
    print "\n  Das ist Befund V-1. Die alten Verzeichnisse gehoeren weg, bevor\n";
    print "  ausgeliefert wird - sonst weiss niemand mehr, was er testet.\n\n";
    exit 1 if $pruefen;
}
elsif ($pruefen) {
    print "\n  Alle Auslieferungen eindeutig.\n\n";
    exit 0;
}

# --- Was zu tun waere ---------------------------------------------------------

my $neu_produkt = "$p1.$p2.$p3." . ($p4+1);
my $neu_paket   = "$k1.$k2." . ($k3+1);

unless ($machen) {
    print "\n  Was --machen tun wuerde:\n\n";
    print "    1. Eudora71/Version.h auf $neu_produkt, VERSION auf $neu_paket\n";
    print "    2. beides committen (sonst traegt die Kennung ein Sternchen)\n";
    print "    3. Release UND Debug bauen, aus DEMSELBEN Commit\n";
    print "    4. beide Pakete schnueren, Starter und Mailverzeichnis dazu\n";
    print "    5. nachpruefen, dass beide dieselbe Kennung tragen\n\n";
    print "  Erst danach nach $heim/Eudora72-$neu_paket-{release,debug} kopieren.\n\n";
    print "  Warum zusammen: das Hochzaehlen war bisher eine Ueberlegung und kein\n";
    print "  Arbeitsschritt - deshalb ist es dreimal an einem Abend vergessen\n";
    print "  worden. Wer diesen Aufruf benutzt, kann es nicht mehr vergessen.\n\n";
    exit 0;
}

print "  --machen ist noch nicht umgesetzt: die Schritte 1 bis 5 stehen oben und\n";
print "  sind einzeln vorhanden (paket-bauen.ps1, laufzeit-holen.ps1). Was fehlt,\n";
print "  ist ihre Verkettung. Bis dahin ersetzt die Pruefung oben das Vergessen\n";
print "  nicht, sie deckt es nur auf.\n\n";
exit 0;
