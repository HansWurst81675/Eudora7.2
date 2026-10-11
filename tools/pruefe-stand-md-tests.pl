#!/usr/bin/perl
use strict;
use warnings;
use File::Temp qw(tempdir);
use File::Path qw(make_path);
use File::Spec;

# pruefe-stand-md-tests.pl - Gegenproben fuer tools/pruefe-stand-md.pl.
#
# Die Faelle sind keine erfundenen Beispiele, sondern die vier Zustaende vom
# 11.09.2026:
#
#   b  AUFGABEN.md behauptete "Stand 09.09.2026", der CHANGELOG war vom 11.
#   c  LEKTORAT.md endete beim "Siebten Durchgang - 07.09.2026", waehrend
#      LEKTOR am 09.09. zuletzt in Befunde/ berichtet hatte - GREGORS FUND
#   d  dieselbe Datei mit dem 09.09. im FLIESSTEXT: die erste Fassung der
#      Schranke hielt sie damit faelschlich fuer fortgeschrieben. Nur die
#      Ueberschrift zaehlt.
#   e  PRUEFBERICHT.md erklaert sich selbst als abgeschlossen - kein Mangel.
#
# Aufruf: perl tools/pruefe-stand-md-tests.pl
# Rueckgabe: 0 = alle Faelle wie erwartet, 1 = mindestens einer nicht.

my $wurzel = -f 'VERSION' ? '.' : '..';
my $schranke = File::Spec->rel2abs("$wurzel/tools/pruefe-stand-md.pl");
unless (-f $schranke) { print "  tools/pruefe-stand-md.pl nicht gefunden.\n"; exit 2; }

sub schreib {
    my ($pfad, $inhalt) = @_;
    my ($v) = $pfad =~ m{^(.*)[/\\][^/\\]+$};
    make_path($v) if $v and not -d $v;
    open my $h, '>:raw', $pfad or die "$pfad: $!\n";
    print $h $inhalt;
    close $h;
}

# Baut ein Miniaturprojekt MIT git-Historie - die Schranke fragt git nach dem
# juengsten Commit auf die Berichte einer Rolle.
sub probe {
    my (%o) = @_;
    my $d = tempdir(CLEANUP => 1);
    my $alt = File::Spec->rel2abs('.');
    chdir $d or die "chdir $d: $!\n";

    schreib("$d/VERSION", '1.0.48');
    schreib("$d/CHANGELOG.md", "# Fassungen\n\n## 7.2.0.48\n\nAm 11.09.2026 gebaut.\n");
    schreib("$d/AUFGABEN.md", $o{aufgaben}) if $o{aufgaben};
    schreib("$d/LEKTORAT.md", $o{lektorat}) if $o{lektorat};
    schreib("$d/Befunde/LEKTOR-6.md", "# Bericht\n\nL-12 vom 09.09.2026.\n")
        if $o{lektorat};

    `git init -q 2>&1`;
    `git config user.email t\@t 2>&1`;
    `git config user.name T 2>&1`;
    `git add -A 2>&1`;
    # Der Commit auf den Bericht traegt das Datum, gegen das geprueft wird.
    $ENV{GIT_COMMITTER_DATE} = '2026-09-09T12:00:00';
    $ENV{GIT_AUTHOR_DATE}    = '2026-09-09T12:00:00';
    `git commit -q -m Bericht 2>&1`;
    delete $ENV{GIT_COMMITTER_DATE};
    delete $ENV{GIT_AUTHOR_DATE};

    my $ausgabe = `perl "$schranke" 2>&1`;
    my $rc = $? >> 8;
    chdir $alt or die "chdir zurueck: $!\n";
    return ($rc, $ausgabe);
}

my $lektorat_alt = <<'ENDE';
# Lektorat

# Siebter Durchgang — 07.09.2026

Irgendein Inhalt.
ENDE

my $lektorat_falle = <<'ENDE';
# Lektorat

# Siebter Durchgang — 07.09.2026

Im Fliesstext steht der 09.09.2026 — das darf die Schranke nicht taeuschen.
ENDE

my $lektorat_gut = <<'ENDE';
# Lektorat

# Siebter Durchgang — 07.09.2026

Irgendein Inhalt.

# Achter Durchgang — 09.09.2026

Nachgetragen.
ENDE

my $lektorat_zu = <<'ENDE';
# Lektorat

> Dies ist ein abgeschlossener Bericht und wird nicht fortgeschrieben.

# Siebter Durchgang — 07.09.2026

Irgendein Inhalt.
ENDE

my @faelle = (
  { name => 'a  alles in Ordnung', soll => 0,
    o => { aufgaben => "# Aufgaben\n\n**Stand 11.09.2026**, aktuell.\n",
           lektorat => $lektorat_gut } },

  { name => 'b  Stand-Kopf haengt hinterher', soll => 1, erwartet => 'AUFGABEN.md behauptet',
    o => { aufgaben => "# Aufgaben\n\n**Stand 09.09.2026**, veraltet.\n",
           lektorat => $lektorat_gut } },

  { name => 'c  Historie nicht fortgeschrieben (Gregors Fund)', soll => 1,
    erwartet => 'nicht fortgeschrieben',
    o => { aufgaben => "# Aufgaben\n\n**Stand 11.09.2026**, aktuell.\n",
           lektorat => $lektorat_alt } },

  { name => 'd  Datum im Fliesstext taeuscht nicht', soll => 1,
    erwartet => 'nicht fortgeschrieben',
    o => { aufgaben => "# Aufgaben\n\n**Stand 11.09.2026**, aktuell.\n",
           lektorat => $lektorat_falle } },

  { name => 'e  abgeschlossene Historie ist kein Mangel', soll => 0,
    o => { aufgaben => "# Aufgaben\n\n**Stand 11.09.2026**, aktuell.\n",
           lektorat => $lektorat_zu } },
);

my $fehler = 0;
print "\n  Gegenproben fuer pruefe-stand-md\n";
print "  ------------------------------------------------------------\n";

for my $f (@faelle) {
    my ($rc, $ausgabe) = probe(%{ $f->{o} });
    my $ok = ($rc == $f->{soll});
    $ok = ($ausgabe =~ /\Q$f->{erwartet}\E/) if $ok and $f->{erwartet};
    printf "  %-6s %-52s rc=%d\n", ($ok ? 'ok' : 'FEHLER'), $f->{name}, $rc;
    unless ($ok) {
        $fehler = 1;
        printf "         erwartet rc=%d%s\n", $f->{soll},
               ($f->{erwartet} ? " mit '$f->{erwartet}'" : '');
        print  "         $_\n" for grep { /\S/ } split /\n/, $ausgabe;
    }
}

print "  ------------------------------------------------------------\n";
if ($fehler) { print "  MINDESTENS EINE GEGENPROBE IST DURCHGEFALLEN.\n\n"; exit 1; }
print "  Alle fuenf Faelle wie erwartet.\n\n";
exit 0;
