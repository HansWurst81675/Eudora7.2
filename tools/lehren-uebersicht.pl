#!/usr/bin/perl
use strict;
use warnings;

# lehren-uebersicht.pl - die Tabelle in Arbeitsweise/README.md aus dem
# Bestand erzeugen, statt sie von Hand zu pflegen.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 11.09.2026 gemessen: im Verzeichnis liegen 56 Lehren, die Tabelle
# "Die Regeln" fuehrt 27. Achtundzwanzig fehlen, darunter Regeln, die taeglich
# gebraucht werden - assert-ist-im-release-nichts,
# keine-tastendruecke-verschicken, nichts-auf-gregors-bildschirm-starten.
#
# CHRONIST hat den Mangel am selben Tag gemeldet und bewusst NICHT im
# Vorbeigehen zwei Zeilen ergaenzt: das haette den Eindruck erweckt, die
# Tabelle sei gepflegt. Genau das ist der Punkt - eine von Hand gefuehrte
# Liste neben einem wachsenden Verzeichnis ist immer unvollstaendig, und
# unvollstaendig ist schlimmer als gar nicht, weil man ihr glaubt.
# (Arbeitsweise/pruefumfang-nicht-von-hand.md)
#
# Deshalb wird die Tabelle nicht ergaenzt, sondern ERZEUGT: aus dem
# Dateinamen und der description-Zeile jeder Lehre.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/lehren-uebersicht.pl            prueft nur, Rueckgabe 1 bei
#                                              Abweichung
#   perl tools/lehren-uebersicht.pl -schreiben  setzt die Tabelle neu
#
# Rueckgabe: 0 = Tabelle deckt den Bestand, 1 = Abweichung, 2 = Aufrufproblem.

my $schreiben = grep { $_ eq '-schreiben' } @ARGV;

my $wurzel = -f 'VERSION' ? '.' : '..';
my $verz   = "$wurzel/Arbeitsweise";
my $datei  = "$verz/README.md";

unless (-d $verz and -f $datei) {
    print "  lehren-uebersicht: Arbeitsweise/README.md nicht gefunden -\n";
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

# --- Bestand einlesen ------------------------------------------------------
my @lehren;
opendir(my $dh, $verz) or die "$verz: $!\n";
for my $f (sort readdir $dh) {
    next unless $f =~ /^(.+)\.md$/;
    my $name = $1;
    next if $name eq 'README' or $name eq 'MEMORY';
    my $t = lies("$verz/$f") or next;

    # Eine Lehre erkennt man am Frontmatter mit "name:". Sammeldateien wie
    # LEHREN-AUS-DEM-CHAT.md haben keins und gehoeren nicht in die Tabelle -
    # das Merkmal wird GELESEN, nicht als Namensliste gepflegt, sonst hat man
    # die Handarbeit nur an eine andere Stelle verschoben.
    next unless $t =~ /^name:\s*\S/m;

    # Die description aus dem Frontmatter. Sie ist der Einzeiler, der auch in
    # MEMORY.md steht - damit bleiben beide Uebersichten bei derselben Aussage.
    my ($besch) = $t =~ /^description:\s*"?(.*?)"?\s*$/m;
    unless (defined $besch and length $besch) {
        # Ohne description: die erste Ueberschrift als Notbehelf, damit die
        # Zeile nicht leer bleibt und der Mangel auffaellt.
        ($besch) = $t =~ /^#\s+(.+?)\s*$/m;
        $besch = defined $besch ? "$besch (keine description)" : '(keine description)';
    }
    push @lehren, [$name, $besch];
}
closedir $dh;

unless (@lehren) {
    print "  lehren-uebersicht: keine Lehren gefunden.\n";
    exit 2;
}

# --- Die Tabelle, wie sie aussehen muss ------------------------------------
my $soll = '';
for my $l (@lehren) {
    my ($name, $besch) = @$l;
    $soll .= "| [$name]($name.md) | $besch |\n";
}

# --- Gegen den Bestand halten ----------------------------------------------
my $t = lies($datei);
my ($c0) = (() = $t =~ /\r\n/g);
my ($l0) = (() = $t =~ /\n/g);

# Der Tabellenblock: von der Kopfzeile bis zur letzten Zeile, die mit "| ["
# beginnt.
unless ($t =~ /(^\|---\|---\|\n)((?:^\|\s*\[.*\n)+)/m) {
    print "  lehren-uebersicht: die Tabelle 'Die Regeln' ist nicht zu finden.\n";
    exit 2;
}
my $kopf = $1;
my $ist  = $2;

my %im_ist;
while ($ist =~ /\]\((.+?)\.md\)/g) { $im_ist{$1} = 1; }
my @fehlen = grep { not $im_ist{ $_->[0] } } @lehren;
my @zuviel = grep { my $n = $_; not grep { $_->[0] eq $n } @lehren } sort keys %im_ist;

printf "\n  ------------------------------------------------------------\n";
printf "  lehren-uebersicht\n";
printf "  ------------------------------------------------------------\n";
printf "    Lehren im Verzeichnis   %3d\n", scalar @lehren;
printf "    Zeilen in der Tabelle   %3d\n", scalar keys %im_ist;

if (not @fehlen and not @zuviel) {
    print "\n  Die Tabelle deckt den Bestand.\n\n";
    exit 0;
}

if (@fehlen) {
    printf "\n  FEHLEN in der Tabelle (%d):\n", scalar @fehlen;
    print  "    - $_->[0]\n" for @fehlen;
}
if (@zuviel) {
    printf "\n  STEHEN in der Tabelle, aber es gibt keine Datei (%d):\n", scalar @zuviel;
    print  "    - $_\n" for @zuviel;
}

unless ($schreiben) {
    print <<'ENDE';

  Eine von Hand gefuehrte Liste neben einem wachsenden Verzeichnis ist
  immer unvollstaendig - und unvollstaendig ist schlimmer als gar
  nicht, weil man ihr glaubt.

  Neu setzen mit:   perl tools/lehren-uebersicht.pl -schreiben

ENDE
    exit 1;
}

# --- Neu setzen ------------------------------------------------------------
$t =~ s/(^\|---\|---\|\n)(?:^\|\s*\[.*\n)+/$kopf$soll/m;

my ($c) = (() = $t =~ /\r\n/g);
if ($c != $c0) {
    printf "  ABBRUCH - CRLF %d statt %d\n", $c, $c0;
    exit 1;
}

open my $o, '>:raw', $datei or die "$datei: $!\n";
print $o $t;
close $o;

printf "\n  Tabelle neu gesetzt: %d Zeilen.\n\n", scalar @lehren;
exit 0;
