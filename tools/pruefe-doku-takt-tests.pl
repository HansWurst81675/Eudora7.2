#!/usr/bin/perl
use strict;
use warnings;
use File::Temp qw(tempdir);
use File::Path qw(make_path);
use File::Spec;

# pruefe-doku-takt-tests.pl - Gegenproben fuer tools/pruefe-doku-takt.pl.
#
# WARUM ES DIESE DATEI GIBT: eine Schranke, die nur gegen den Zustand
# geprueft wurde, in dem sie geschrieben wurde, beweist nichts. Sie muss
# gegen den ECHTEN FEHLER anschlagen und beim ERLAUBTEN FALL schweigen -
# stumm und Fehlalarm kosten dasselbe
# (Arbeitsweise/schranke-gegentesten.md).
#
# Die Faelle b, c und d sind keine erfundenen Beispiele, sondern die drei
# Zustaende, die es am 11.09.2026 tatsaechlich gegeben hat:
#
#   b  7.2.0.48 gebaut, kein CHANGELOG-Abschnitt dafuer
#   c  "## Noch offen (Stand 10.09.2026)", waehrend der CHANGELOG schon vom
#      11.09. erzaehlte - das ist der Fall, den GREGOR gefunden hat
#   d  EUDORA_BUILD_* auf 7.2.0.47, EUDORA_VERSION1..4 noch auf 7.2.0.44
#
# Aufruf: perl tools/pruefe-doku-takt-tests.pl
# Rueckgabe: 0 = alle Faelle wie erwartet, 1 = mindestens einer nicht.

my $wurzel = -f 'VERSION' ? '.' : '..';
my $schranke = File::Spec->rel2abs("$wurzel/tools/pruefe-doku-takt.pl");
unless (-f $schranke) {
    print "  tools/pruefe-doku-takt.pl nicht gefunden.\n";
    exit 2;
}

sub schreib {
    my ($pfad, $inhalt) = @_;
    my ($v) = $pfad =~ m{^(.*)[/\\][^/\\]+$};
    make_path($v) if $v and not -d $v;
    open my $h, '>:raw', $pfad or die "$pfad: $!\n";
    print $h $inhalt;
    close $h;
}

# Baut ein Miniaturprojekt und laesst die Schranke darauf los.
sub probe {
    my (%o) = @_;
    my $d = tempdir(CLEANUP => 1);

    schreib("$d/VERSION", $o{version});
    schreib("$d/Eudora71/Version.h", <<"ENDE");
// Version.h
#define EUDORA_VERSION1 $o{v1}
#define EUDORA_VERSION2 $o{v2}
#define EUDORA_VERSION3 $o{v3}
#define EUDORA_VERSION4 $o{v4}
#define EUDORA_BUILD_NUMBER    $o{v1},$o{v2},$o{v3},$o{build_letzte}
#define EUDORA_BUILD_DESC      "Version $o{v1}.$o{v2}.$o{v3}.$o{build_letzte}\\0"
#define EUDORA_BUILD_VERSION   "$o{v1}.$o{v2}.$o{v3}.$o{build_letzte}"
ENDE
    schreib("$d/CHANGELOG.md", $o{changelog});

    my $alt = File::Spec->rel2abs('.');
    chdir $d or die "chdir $d: $!\n";
    my $ausgabe = `perl "$schranke" 2>&1`;
    my $rc = $? >> 8;
    chdir $alt or die "chdir zurueck: $!\n";
    return ($rc, $ausgabe);
}

my $changelog_gut = <<'ENDE';
# Fassungsgeschichte

## Noch offen (Stand 11.09.2026)

| Kennung | | |
|---|---|---|
| E-47 | irgendetwas | steht noch aus |

## 7.2.0.48 - die Fassung, um die es geht

Am 11.09.2026 gebaut.

## 7.2.0.47 - die davor

Am 11.09.2026 gebaut.
ENDE

my $changelog_ohne_abschnitt = $changelog_gut;
$changelog_ohne_abschnitt =~ s/^## 7\.2\.0\.48.*?\n\nAm 11\.09\.2026 gebaut\.\n\n//ms;

my $changelog_alt_offen = $changelog_gut;
$changelog_alt_offen =~ s/\(Stand 11\.09\.2026\)/(Stand 10.09.2026)/;

my @faelle = (
  { name => 'a  alles in Ordnung',
    soll => 0,
    o => { version => '1.0.48', v1 => 7, v2 => 2, v3 => 0, v4 => 48,
           build_letzte => 48, changelog => $changelog_gut } },

  { name => 'b  kein CHANGELOG-Abschnitt fuer die gebaute Fassung',
    soll => 1, erwartet => 'keinen Abschnitt',
    o => { version => '1.0.48', v1 => 7, v2 => 2, v3 => 0, v4 => 48,
           build_letzte => 48, changelog => $changelog_ohne_abschnitt } },

  { name => 'c  "Noch offen" haengt einen Tag hinterher (Gregors Fund)',
    soll => 1, erwartet => 'Noch offen',
    o => { version => '1.0.48', v1 => 7, v2 => 2, v3 => 0, v4 => 48,
           build_letzte => 48, changelog => $changelog_alt_offen } },

  { name => 'd  Version.h widerspricht sich (VERSION4 nicht mitgezogen)',
    soll => 1, erwartet => 'widerspricht sich',
    o => { version => '1.0.48', v1 => 7, v2 => 2, v3 => 0, v4 => 44,
           build_letzte => 48, changelog => $changelog_gut } },

  { name => 'e  VERSION passt nicht zum Quellstand',
    soll => 1, erwartet => 'letzte Stelle',
    o => { version => '1.0.44', v1 => 7, v2 => 2, v3 => 0, v4 => 48,
           build_letzte => 48, changelog => $changelog_gut } },
);

my $fehler = 0;
print "\n  Gegenproben fuer pruefe-doku-takt\n";
print "  ------------------------------------------------------------\n";

for my $f (@faelle) {
    my ($rc, $ausgabe) = probe(%{ $f->{o} });
    my $ok = ($rc == $f->{soll});
    if ($ok and $f->{erwartet}) {
        $ok = ($ausgabe =~ /\Q$f->{erwartet}\E/);
    }
    printf "  %-6s %-56s rc=%d\n", ($ok ? 'ok' : 'FEHLER'), $f->{name}, $rc;
    unless ($ok) {
        $fehler = 1;
        printf "         erwartet rc=%d%s\n", $f->{soll},
               ($f->{erwartet} ? " mit '$f->{erwartet}'" : '');
        print  "         --- Ausgabe ---\n";
        print  "         $_\n" for grep { /\S/ } split /\n/, $ausgabe;
    }
}

print "  ------------------------------------------------------------\n";
if ($fehler) {
    print "  MINDESTENS EINE GEGENPROBE IST DURCHGEFALLEN.\n\n";
    exit 1;
}
print "  Alle fuenf Faelle wie erwartet: der erlaubte schweigt,\n";
print "  die vier echten Fehler schlagen an.\n\n";
exit 0;
