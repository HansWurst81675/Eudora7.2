#!/usr/bin/perl
use strict;
use warnings;

# pruefe-fassungsnummer.pl - vergibt niemand eine Nummer zweimal, und behauptet
# niemand eine Luecke, die es nicht gibt?
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE SCHRANKE GIBT
# ---------------------------------------------------------------------------
#
# Zwei gleichzeitig laufende Sitzungen koennen dieselbe naechste Fassungsnummer
# vergeben. Nichts hat das bisher bemerkt. Der Schaden ist die unangenehme
# Sorte: zwei verschiedene Pakete heissen gleich, und danach ist keine Messung
# mehr zuzuordnen - "1.0.68" bezeichnet dann zwei Staende
# (Arbeitsweise/version-eindeutig-machen.md).
#
# Genau das ist am 17.09.2026 passiert und steht im CHANGELOG unter der
# Ueberschrift "Warum es zwei Fassungsnummern 1.0.68 gab".
#
# Die Quelle der naechsten Nummer ist seit dem 17.09.2026 Releases/PAKETE.md,
# so steht es im Kopf der Datei. Eine Quelle, die niemand gegen die anderen
# haelt, hinkt aber hinterher - am 17.09.2026 um fuenf Nummern. Diese Schranke
# haelt die vier Stellen gegeneinander, an denen eine Fassungsnummer steht:
#
#     VERSION                 die Paketnummer      1.0.72
#     Eudora71/Version.h      der Quellstand       7.2.0.72
#     Releases/PAKETE.md      die Buchfuehrung     ## 1.0.72
#     git tag                 was veroeffentlicht  v1.0.72
#
# ---------------------------------------------------------------------------
# WAS SIE PRUEFT - und was sie ausdruecklich NICHT prueft
# ---------------------------------------------------------------------------
#
#   A. VERSION und Version.h nennen dieselbe Nummer.
#      Laeuft eine zweite Sitzung mit, zaehlt oft nur eine der beiden Dateien
#      hoch - das ist das frueheste sichtbare Zeichen einer Kollision.
#
#   B. Keine Nummer hat in Releases/PAKETE.md ZWEI Abschnitte.
#      Zwei Abschnitte zur selben Nummer heisst: zwei Staende, ein Name.
#
#   C. Die Nummer aus VERSION hat einen Abschnitt in Releases/PAKETE.md.
#      Eine vergebene, aber nicht eingetragene Nummer ist der Weg, auf dem die
#      naechste Sitzung sie ein zweites Mal vergibt.
#
#   D. Kein Tag ist HOEHER als die Nummer aus VERSION.
#      Ein Tag v1.0.73 bei VERSION 1.0.72 heisst, dass jemand anders die 73
#      schon verbraucht hat.
#
# NICHT geprueft wird, ob die Nummernfolge luecken los ist. 1.0.70 wurde
# gebaut und nie veroeffentlicht; 1.0.71 stuerzt ab und ist ausdruecklich nicht
# zu benutzen. Solche Luecken sind der NORMALFALL und duerfen keinen Fehlalarm
# ausloesen (Arbeitsweise/schranke-gegentesten.md: der erlaubte Fall, der dem
# Fehler am naechsten kommt). Gemeldet - nicht beanstandet - wird nur, wie
# viele Tags keinen Abschnitt haben; das ist der seit langem offene Mangel M-4.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-fassungsnummer.pl            prueft
#   perl tools/pruefe-fassungsnummer.pl --tests    Selbsttest
#
# Rueckgabe: 0 = stimmt, 1 = Kollision oder Luecke in der Buchfuehrung,
#            2 = Aufrufproblem.

my $wurzel = -f 'VERSION' ? '.' : '..';

sub lies {
    my ($pfad) = @_;
    open my $h, '<:raw', $pfad or return undef;
    my $t = do { local $/; <$h> };
    close $h;
    return $t;
}

# --- Die vier Quellen, jede einzeln lesbar, damit der Selbsttest sie stellen
#     kann -------------------------------------------------------------------

sub nr_aus_version {
    my ($t) = @_;
    return undef unless defined $t;
    return $t =~ /\b1\.0\.(\d+)\b/ ? $1 : undef;
}

sub nr_aus_versionh {
    my ($t) = @_;
    return undef unless defined $t;
    return $t =~ /EUDORA_BUILD_VERSION\s+"7\.2\.0\.(\d+)"/ ? $1 : undef;
}

# Alle Abschnittsnummern aus Releases/PAKETE.md, mit ihrer Haeufigkeit.
sub abschnitte_aus_pakete {
    my ($t) = @_;
    my %n;
    return %n unless defined $t;
    for my $z (split /\n/, $t) {
        next unless $z =~ /^##\s+1\.0\.(\d+)\b/;
        $n{$1}++;
    }
    return %n;
}

sub nummern_aus_tags {
    my (@tags) = @_;
    my %n;
    for my $t (@tags) {
        $n{$2} = 1 if $t =~ /^v(\d+\.\d+)\.(\d+)$/;
    }
    return sort { $a <=> $b } keys %n;
}

# --- Der Kern, ohne Dateizugriff -------------------------------------------
sub pruefe {
    my ($nr_version, $nr_versionh, $abschnitte, $tags) = @_;
    my (@mangel, @hinweis);
    my $geprueft = 0;

    unless (defined $nr_version && defined $nr_versionh) {
        push @mangel, 'VERSION oder Eudora71/Version.h ist nicht lesbar - '
                    . 'ohne beide ist keine Aussage moeglich';
        return (\@mangel, \@hinweis, 0);
    }

    # A.
    $geprueft++;
    push @mangel, "VERSION sagt 1.0.$nr_version, Eudora71/Version.h sagt "
                . "7.2.0.$nr_versionh - eine der beiden ist hochgezaehlt worden, "
                . "die andere nicht"
        if $nr_version != $nr_versionh;

    # B.
    for my $n (sort { $a <=> $b } keys %$abschnitte) {
        $geprueft++;
        push @mangel, "Releases/PAKETE.md hat $abschnitte->{$n} Abschnitte fuer "
                    . "1.0.$n - dieselbe Nummer ist zweimal vergeben worden"
            if $abschnitte->{$n} > 1;
    }

    # C.
    $geprueft++;
    push @mangel, "1.0.$nr_version ist vergeben, hat aber keinen Abschnitt in "
                . "Releases/PAKETE.md - ueber diese Luecke vergibt die naechste "
                . "Sitzung dieselbe Nummer noch einmal"
        unless $abschnitte->{$nr_version};

    # D.
    for my $t (@$tags) {
        $geprueft++;
        push @mangel, "Das Tag v1.0.$t ist hoeher als die vergebene Nummer "
                    . "1.0.$nr_version - jemand anders hat die $t schon verbraucht"
            if $t > $nr_version;
    }

    # Nur Hinweis: Tags ohne Abschnitt. Das ist der offene Mangel M-4, keine
    # Kollision - und eine Schranke, die ihn jedes Mal als Fehler meldet, wird
    # abgeschaltet.
    my @ohne = grep { !$abschnitte->{$_} } @$tags;
    push @hinweis, scalar(@ohne) . " veroeffentlichte Fassung(en) haben keinen "
                 . "Abschnitt in Releases/PAKETE.md: "
                 . join(', ', map { "1.0.$_" } @ohne)
                 . " (offener Mangel M-4, kein Grund abzuweisen)"
        if @ohne;

    return (\@mangel, \@hinweis, $geprueft);
}

# ---------------------------------------------------------------------------
# Selbsttest: gegen den echten Fehler UND gegen den erlaubten Fall
# ---------------------------------------------------------------------------
if (grep { $_ eq '--tests' } @ARGV) {
    my ($fehler, $nr) = (0, 0);
    my $pruef = sub {
        my ($name, $ist, $soll) = @_;
        $nr++;
        return if $ist eq $soll;
        print "  FEHLER Selbsttest $nr ($name):\n    erwartet: $soll\n    bekommen: $ist\n";
        $fehler++;
    };

    # --- Die Quellen werden wirklich gelesen ------------------------------
    $pruef->('VERSION', nr_aus_version("1.0.72\n"), '72');
    $pruef->('Version.h', nr_aus_versionh(
        "#define EUDORA_BUILD_DESC      \"Version 7.2.0.72\\0\"\n"
      . "#define EUDORA_BUILD_VERSION   \"7.2.0.72\"\n"), '72');

    my $pakete = "# Ausgelieferte Pakete\n\n## 1.0.72 - veroeffentlicht\n\nText\n\n"
               . "## 1.0.71 - nie veroeffentlicht, stuerzt ab\n\nText\n\n"
               . "## 1.0.70 - gebaut, nie veroeffentlicht\n\nText\n";
    my %a = abschnitte_aus_pakete($pakete);
    $pruef->('Abschnitte gefunden', join(',', sort { $a <=> $b } keys %a), '70,71,72');

    $pruef->('Tags numerisch', join(',', nummern_aus_tags(qw(v1.0.9 v1.0.72 v1.0.64))),
             '9,64,72');

    # --- DER ERLAUBTE FALL, und er ist der wichtigere ---------------------
    #
    # 1.0.70 und 1.0.71 wurden gebaut und nie veroeffentlicht. Es gibt also
    # Tags fuer 64 und 72, aber keine fuer 70 und 71. Das ist KEIN Mangel.
    my ($m_ok, $h_ok, $g_ok) = pruefe(72, 72, \%a, [9, 64, 72]);
    $pruef->('Luecke in der Tag-Folge ist kein Mangel',
             join(' | ', @$m_ok), '');
    $pruef->('und es wurde etwas geprueft', $g_ok >= 4 ? 'ja' : "nein ($g_ok)", 'ja');
    $pruef->('Tags ohne Abschnitt sind nur ein Hinweis',
             (grep { /1\.0\.9, 1\.0\.64/ } @$h_ok) ? 'ja' : 'nein (' . join('|', @$h_ok) . ')',
             'ja');

    # --- A: die halb hochgezaehlte Kollision ------------------------------
    my ($m_a) = pruefe(72, 71, \%a, [72]);
    $pruef->('VERSION und Version.h auseinander',
             (grep { /VERSION sagt 1\.0\.72, Eudora71\/Version\.h sagt 7\.2\.0\.71/ } @$m_a)
             ? 'ja' : 'nein', 'ja');

    # --- B: DER ECHTE FALL "zwei Fassungsnummern 1.0.68" ------------------
    my %doppelt = (68 => 2, 72 => 1);
    my ($m_b) = pruefe(72, 72, \%doppelt, [72]);
    $pruef->('dieselbe Nummer zweimal in PAKETE.md',
             (grep { /2 Abschnitte fuer 1\.0\.68/ } @$m_b) ? 'ja' : 'nein', 'ja');

    # --- C: vergeben, aber nicht eingetragen ------------------------------
    my ($m_c) = pruefe(73, 73, \%a, [72]);
    $pruef->('Nummer ohne Abschnitt',
             (grep { /1\.0\.73 ist vergeben, hat aber keinen Abschnitt/ } @$m_c)
             ? 'ja' : 'nein', 'ja');

    # --- D: ein Tag hoeher als die eigene Nummer --------------------------
    my ($m_d) = pruefe(72, 72, \%a, [72, 73]);
    $pruef->('fremdes Tag hoeher als die eigene Nummer',
             (grep { /Tag v1\.0\.73 ist hoeher/ } @$m_d) ? 'ja' : 'nein', 'ja');

    if ($fehler) {
        printf "\n  %d von %d Selbsttests fehlgeschlagen.\n\n", $fehler, $nr;
        exit 1;
    }
    printf "\n  Selbsttest: %d von %d bestanden - darunter der echte Fall\n"
         . "  \"zwei Fassungsnummern 1.0.68\" und der erlaubte Fall (1.0.70 und\n"
         . "  1.0.71 gebaut, nie veroeffentlicht - keine Luecke, die zaehlt).\n\n",
         $nr, $nr;
    exit 0;
}

# ---------------------------------------------------------------------------
my $nr_version  = nr_aus_version(lies("$wurzel/VERSION"));
my $nr_versionh = nr_aus_versionh(lies("$wurzel/Eudora71/Version.h"));
my %abschnitte  = abschnitte_aus_pakete(lies("$wurzel/Releases/PAKETE.md"));
my @tags        = nummern_aus_tags(
                      grep { length } split /\n/, `git -C "$wurzel" tag 2>/dev/null`);

my ($mangel, $hinweis, $geprueft) =
    pruefe($nr_version, $nr_versionh, \%abschnitte, \@tags);

printf "\n  %s\n  Fassungsnummern gegeneinander\n  %s\n", '-' x 60, '-' x 60;
printf "    VERSION                        %s\n",
    defined $nr_version ? "1.0.$nr_version" : '(nicht lesbar)';
printf "    Eudora71/Version.h             %s\n",
    defined $nr_versionh ? "7.2.0.$nr_versionh" : '(nicht lesbar)';
printf "    Releases/PAKETE.md             %d Abschnitt(e), hoechster %s\n",
    scalar(keys %abschnitte),
    (keys %abschnitte) ? '1.0.' . (sort { $b <=> $a } keys %abschnitte)[0] : '-';
printf "    Tags                           %d, hoechstes %s\n",
    scalar @tags, @tags ? 'v1.0.' . $tags[-1] : '-';
printf "    Einzelpruefungen               %d\n", $geprueft;

print "\n  HINWEIS: $_\n" for @$hinweis;

# Umfang 0 ist kein Freispruch (E-109, Punkt 4).
unless ($geprueft) {
    print "\n  NICHTS GEPRUEFT - das ist kein gruenes Ergebnis.\n";
    print "  Keine der vier Quellen war lesbar. Aus dem Wurzelverzeichnis aufrufen.\n\n";
    exit 1;
}

unless (@$mangel) {
    print "\n  Die vier Quellen widersprechen sich nicht. Keine Nummer ist zweimal\n";
    print "  vergeben, und kein fremdes Tag steht ueber der eigenen Nummer.\n\n";
    exit 0;
}

printf "\n  MANGEL - %d Stelle(n):\n\n", scalar @$mangel;
print "    - $_\n" for @$mangel;

print <<'ENDE';

  Eine Fassungsnummer ist ein Name. Wird sie zweimal vergeben, bezeichnet sie
  zwei Staende, und danach ist keine Messung mehr zuzuordnen - "gemessen an
  1.0.68" sagt dann nichts mehr (Arbeitsweise/version-eindeutig-machen.md).
  Der CHANGELOG fuehrt den Fall unter "Warum es zwei Fassungsnummern 1.0.68
  gab".

  Quelle der naechsten Nummer ist Releases/PAKETE.md. Erst dort eintragen,
  dann VERSION und Version.h hochzaehlen - in derselben Reihenfolge und im
  selben Arbeitsschritt (Arbeitsweise/doku-parallel-nicht-hinterher.md).

ENDE
exit 1;
