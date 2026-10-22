#!/usr/bin/perl
# befunde-verlinken.pl - macht jede Befundkennung in den fuehrenden Dokumenten
# anklickbar und haelt die Verweise gegen Intern/BEFUNDE.md.
#
#   perl tools/befunde-verlinken.pl              # nur pruefen (Schranke)
#   perl tools/befunde-verlinken.pl --anker      # Anker in Intern/BEFUNDE.md anlegen
#   perl tools/befunde-verlinken.pl --verlinken  # Kennungen zu Links machen
#   perl tools/befunde-verlinken.pl --anker --verlinken
#   perl tools/befunde-verlinken.pl --zeigen     # was sich aendern wuerde
#
# WARUM ES DAS GIBT
#
# Gregor am 12.10.2026: "ich moechte ueberall, wenn auf einen bug (z.b. E-108
# oder AN-1) verwiesen wird, dass ich drauf als link klicken kann, um zum
# inhalt / problem / beschreibung zu gelangen."
#
# WARUM NICHT DIE ANKER VON GITHUB
#
# GitHub baut den Anker aus dem Ueberschriftentext: "## E-108 - Absturz beim
# Antworten" wird zu "#e-108---absturz-beim-antworten". Wer die Ueberschrift
# umformuliert, macht damit jeden Verweis darauf tot, und es faellt niemandem
# auf. Deshalb setzt dieses Werkzeug EIGENE Anker: <a id="e-108"></a>. Die
# ueberleben jede Umformulierung.
#
# WOHIN DER LINK ZEIGT
#
# Auf die Zeile in der Urteilstabelle von Intern/BEFUNDE.md. Gemessen am 12.10.2026:
# von 138 Kennungen haben nur 44 einen eigenen Abschnitt, 94 stehen
# ausschliesslich in dieser Tabelle - und ihre Urteilsspalte IST die
# Beschreibung. Ein Anker je Kennung, immer an derselben Sorte Stelle.
#
# WAS NICHT ANGEFASST WIRD
#
#   * alles in ``` -Bloecken und in `...` - dort stehen Befehle, kein Fliesstext
#   * eine Kennung, die schon in einem Link steht
#   * die erste Zelle der Urteilstabelle (dort sitzt der Anker selbst)
#   * Ueberschriften
#   * E-7 in E-71: hinter der Kennung darf keine Ziffer stehen
#   * PRUEFER-20, LEKTOR-18: vor dem Praefix darf kein Buchstabe stehen
#
# Rueckgabe: 0 wenn jeder Verweis sitzt, 1 wenn etwas unverlinkt ist oder ins
# Leere zeigt.

use strict;
use warnings;

my ($anker, $verlinken, $zeigen);
for my $a (@ARGV) {
  if    ($a eq '--anker')     { $anker = 1 }
  elsif ($a eq '--verlinken') { $verlinken = 1 }
  elsif ($a eq '--zeigen')    { $zeigen = 1 }
  else  { die "unbekannter Schalter: $a\n" }
}

my $wurzel = $0;
$wurzel =~ s{[\\/]tools[\\/][^\\/]+$}{};
$wurzel = '.' if $wurzel eq $0 || $wurzel eq '';

# Die Familien werden NICHT aufgezaehlt. Eine feste Liste war schon einmal
# falsch: sie kannte E, NP, PR, P, X, Z, R, V, AN, M, L - und uebersah damit
# NP2/NP3, S, B, A, W, F, LEKTOR und PRUEFER, also auch NP3-8, genau den
# Befund, dessen Uebersehen CLAUDE.md als teuersten Fehler des Projekts
# festhaelt. Gesucht wird die FORM; ob die Kennung existiert, entscheidet
# allein die Urteilstabelle in Intern/BEFUNDE.md.
my $PRAEFIX = qr/[A-Z][A-Za-z0-9]{0,8}/;
my $KENNUNG = qr/$PRAEFIX-\d+(?:\.\d+)?[a-z]?/;
# Dritte Form, ohne Bindestrich: B5, B5.7, C1 - die Abschnittskennungen der
# Arbeitspakete in Intern/AUFGABEN.md und Intern/TESTPLAN.md. Gregor am 12.10.2026:
# "Offen bleibt B5.7: ... link fehlt". 44 Nennungen allein fuer B5.7.
my $KURZ    = qr/[A-Z]\d+(?:\.\d+)?/;
my $JEDE    = qr/(?:$KENNUNG|$KURZ)/;

sub lies {
  my $p = shift;
  open my $f, '<:encoding(UTF-8)', $p or die "$p: $!\n";
  local $/; my $t = <$f>; close $f; return $t;
}
sub schreib {
  my ($p, $t) = @_;
  open my $f, '>:encoding(UTF-8)', $p or die "$p: $!\n";
  print $f $t; close $f;
}

# ---------------------------------------------------------------------------
# 1. Welche Kennungen gibt es, und wo steht ihre Urteilszeile?
# ---------------------------------------------------------------------------
my $bef = "$wurzel/Intern/BEFUNDE.md";
my @bz = split /\n/, lies($bef), -1;

my %zeile_von;        # Kennung -> Index in @bz
for my $i (0 .. $#bz) {
  next unless $bz[$i] =~ /^\|\s*(?:<a\s+id="[^"]*"><\/a>)?\s*($KENNUNG)\s*\|/;
  $zeile_von{$1} = $i unless exists $zeile_von{$1};
}
my @kennungen = sort keys %zeile_von;
my %ankerda = map { lc($_) => 1 } @kennungen;
our %ankerda2;
printf "Intern/BEFUNDE.md: %d Kennungen in der Urteilstabelle\n", scalar @kennungen;

sub ankername { my $k = lc shift; $k =~ s/[^a-z0-9.-]//g; return $k }

# ---------------------------------------------------------------------------
# 1b. Das zweite Verzeichnis: die Agentenbefunde unter Befunde/
# ---------------------------------------------------------------------------
# Gregor am 12.10.2026, mit Intern/LEKTORAT.md vor sich: "L-17 usw. - links fehlen!".
# Richtig: L-17.1, LEKTOR-20, P-42, W-2 stehen NICHT in der Urteilstabelle
# von Intern/BEFUNDE.md, sondern haben ihre eigene Ueberschrift in einem Bericht
# unter Befunde/. Die erste Fassung kannte nur ein Verzeichnis und ging an
# 603 Nennungen vorbei.
my %bericht_zeilen;   # Datei -> [Zeilen]
my %bericht_anker;    # Kennung -> [Datei, Zeilenindex]
for my $f (sort glob("$wurzel/Befunde/*.md")) {
  (my $kurz = $f) =~ s{^\Q$wurzel\E/}{};
  my @z = split /\n/, lies($f), -1;
  $bericht_zeilen{$kurz} = \@z;
  for my $i (0 .. $#z) {
    next unless $z[$i] =~ /^\#+\s+(?:<a\s+id="[^"]*"><\/a>)?\s*\*{0,2}\s*($KENNUNG)(?![\w.-])/;
    my $k = $1;
    next if exists $zeile_von{$k};          # Intern/BEFUNDE.md hat Vorrang
    next if exists $bericht_anker{$k};      # die erste Nennung gewinnt
    $bericht_anker{$k} = [$kurz, $i];
  }
}
printf "Befunde/*.md: %d Kennungen mit eigener Ueberschrift\n",
       scalar keys %bericht_anker;
%ankerda2 = map { ankername($_) => 1 } keys %bericht_anker;

# ---------------------------------------------------------------------------
# 1c. Das dritte Verzeichnis: Abschnittskennungen in den Dokumenten selbst
# ---------------------------------------------------------------------------
# B5, B5.7, C1 stehen weder in Intern/BEFUNDE.md noch unter Befunde/, sondern sind
# Ueberschriften in Intern/AUFGABEN.md und Intern/TESTPLAN.md.
my %doku_zeilen;
my %doku_anker;
for my $f (sort (glob("$wurzel/*.md"), glob("$wurzel/tools/*.md"))) {
  (my $kurz = $f) =~ s{^\Q$wurzel\E/}{};
  my @z = split /\n/, lies($f), -1;
  $doku_zeilen{$kurz} = \@z;
  for my $i (0 .. $#z) {
    next unless $z[$i] =~ /^\#+\s+(?:<a\s+id="[^"]*"><\/a>)?\s*\*{0,2}\s*($KURZ)(?![\w.-])/;
    my $k = $1;
    next if exists $zeile_von{$k} || exists $bericht_anker{$k} || exists $doku_anker{$k};
    $doku_anker{$k} = [$kurz, $i];
  }
}
printf "Dokumente: %d Abschnittskennungen (B5, B5.7, C1 ...)\n", scalar keys %doku_anker;
%ankerda2 = (%ankerda2, map { ankername($_) => 1 } keys %doku_anker);

# Wohin zeigt eine Kennung? Datei und Anker, beides relativ zur Wurzel.
my %ziel_von;
$ziel_von{$_} = ['Intern/BEFUNDE.md', ankername($_)] for @kennungen;
$ziel_von{$_} = [$bericht_anker{$_}[0], ankername($_)] for keys %bericht_anker;
$ziel_von{$_} = [$doku_anker{$_}[0],    ankername($_)] for keys %doku_anker;

# Ein Link aus tools/WERKZEUGE.md nach Befunde/LEKTOR-17.md heisst
# ../Befunde/LEKTOR-17.md - der Pfad muss vom LESENDEN Dokument aus gelten.
sub verweis {
  my ($von, $k) = @_;
  my ($datei, $id) = @{ $ziel_von{$k} };
  return "#$id" if $datei eq $von;
  my @v = split m{/}, $von; pop @v;            # Verzeichnis des Lesers
  my @n = split m{/}, $datei;
  shift(@v), shift(@n) while @v && @n > 1 && $v[0] eq $n[0];
  return join('/', ('..') x scalar(@v), @n) . "#$id";
}

# ---------------------------------------------------------------------------
# 2. Anker setzen
# ---------------------------------------------------------------------------
my $neu_anker = 0;
for my $k (@kennungen) {
  my $i = $zeile_von{$k};
  my $id = ankername($k);
  next if $bz[$i] =~ /^\|\s*<a\s+id="\Q$id\E"><\/a>/;
  $neu_anker++;
  $bz[$i] =~ s/^\|\s*/| <a id="$id"><\/a>/;
}
my $neu_anker_b = 0;
for my $k (sort keys %bericht_anker) {
  my ($datei, $i) = @{ $bericht_anker{$k} };
  my $id = ankername($k);
  next if $bericht_zeilen{$datei}[$i] =~ /<a\s+id="\Q$id\E"><\/a>/;
  $neu_anker_b++;
  $bericht_zeilen{$datei}[$i] =~ s/^(\#+\s+)/$1<a id="$id"><\/a>/;
}
my $neu_anker_c = 0;
my %doku_zu;
for my $k (sort keys %doku_anker) {
  my ($datei, $i) = @{ $doku_anker{$k} };
  my $id = ankername($k);
  next if $doku_zeilen{$datei}[$i] =~ /<a\s+id="\Q$id\E"><\/a>/;
  $neu_anker_c++; $doku_zu{$datei} = 1;
  $doku_zeilen{$datei}[$i] =~ s/^(\#+\s+)/$1<a id="$id"><\/a>/;
}
if ($neu_anker_c && $anker) {
  schreib("$wurzel/$_", join("\n", @{ $doku_zeilen{$_} })) for sort keys %doku_zu;
}
$neu_anker_b += $neu_anker_c;
if ($neu_anker || $neu_anker_b) {
  if ($anker) {
    schreib($bef, join("\n", @bz)) if $neu_anker;
    if ($neu_anker_b) {
      my %zu;
      $zu{ $bericht_anker{$_}[0] } = 1 for keys %bericht_anker;
      schreib("$wurzel/$_", join("\n", @{ $bericht_zeilen{$_} })) for sort keys %zu;
    }
    print "Anker gesetzt: $neu_anker in Intern/BEFUNDE.md, $neu_anker_b unter Befunde/\n";
  }
  else {
    print "Anker fehlen: $neu_anker in Intern/BEFUNDE.md, $neu_anker_b unter Befunde/ (mit --anker setzen)\n";
  }
}
else { print "Anker: vollstaendig\n" }

# ---------------------------------------------------------------------------
# 3. Verlinken
# ---------------------------------------------------------------------------
# Keine feste Liste: Gregor sagte "ueberall". Genommen wird jede .md im
# Wurzelverzeichnis, in tools/ und unter Befunde/ - ein neues Dokument ist
# damit von selbst dabei, und niemand muss daran denken. Arbeitsweise/
# bleibt aussen vor, wie beim Lektorat auch.
my @dateien = sort map { s{^\Q$wurzel\E/}{}r }
              (glob("$wurzel/*.md"), glob("$wurzel/tools/*.md"),
               glob("$wurzel/Befunde/*.md"));

my $offen = 0;
my $gesetzt = 0;

for my $d (@dateien) {
  my $pfad = "$wurzel/$d";
  my $text = lies($pfad);
  my @z = split /\n/, $text, -1;
  my $in_block = 0;
  my $geaendert = 0;
  my $hier = 0;

  for my $i (0 .. $#z) {
    my $z = $z[$i];


    if ($z =~ /^\s*```/) { $in_block = !$in_block; next }
    next if $in_block;
    next if $z =~ /^\s*#/;                       # Ueberschrift
    # Die Ankerzelle der Urteilstabelle in Intern/BEFUNDE.md bleibt, wie sie ist.
    # In Intern/BEFUNDE.md bleibt die Urteilstabelle unverlinkt: dort steht die
    # Kennung bei ihrer eigenen Beschreibung, ein Link auf sich selbst
    # hilft niemandem und faerbt 138 Zeilen blau.
    next if $d eq 'Intern/BEFUNDE.md' && $z =~ /^\|\s*(?:<a\s+id="[^"]*"><\/a>)?\s*$KENNUNG\s*\|/;

    # Abschnitte, die NICHT angefasst werden duerfen: Code in Rueckstrichen
    # und fertige Links. Beides wird herausgeschnitten, ersetzt und wieder
    # eingesetzt - so kann die Ersetzung sie nicht treffen.
    my @safe;
    $z =~ s{(`[^`]*`|\[[^\]]*\]\([^)]*\))}{
      my $s = $1;
      # Ein Rueckstrichstueck, das NUR aus einer Kennung besteht, ist eine
      # Beschriftung, kein Befehl - das wird verlinkt. Gregor am 12.10.2026
      # zur Markentabelle in Intern/TESTPLAN.md: "links in der tabelle fehlen".
      # `grep "E-78\|E-70" eudora.log` bleibt unangetastet: wer das kopiert,
      # soll einen Befehl bekommen und keinen Link. Nur die Form MIT
      # Bindestrich: `B7` ist in Intern/BEFUNDE.md:6839 das Byte 0xB7, nicht der
      # Abschnitt B7.
      if ($s =~ /^`($KENNUNG)`$/ && exists $ziel_von{$1}) {
        my $k = $1;
        $hier++;
        $s = "[`$k`](" . verweis($d, $k) . ")";
      }
      push @safe, $s; "\x00" . $#safe . "\x00"
    }ge;

    $z =~ s{(?<![A-Za-z0-9])($JEDE)(?![\w-])(?!\.[0-9a-z])}{
      # Der Fettdruck wird NICHT mitgenommen. Die erste Fassung fasste
      # **E-98** als Einheit und verlangte das Sternchenpaar auf beiden
      # Seiten - in "**E-98 bis E-101**" steht es aber nur aussen, also
      # blieben beide Kennungen unverlinkt. Gregor am 12.10.2026:
      # "Dazu fehlten E-98 bis E-101 - hier auch!". Jetzt wird nur die
      # Kennung selbst zum Link, der Fettdruck bleibt, wo er stand.
      my $k = $1;
      # Eine Abschnittskennung OHNE Punkt gilt nur in ihrer eigenen Datei.
      # B1 und E1 heissen in Befunde/LEKTOR-6.md etwas anderes als in
      # Intern/TESTPLAN.md, und `B7` ist anderswo das Byte 0xB7. Ein falscher Link
      # ist schlimmer als ein fehlender. Mit Punkt - B5.7 - ist die Kennung
      # eindeutig und zaehlt ueberall.
      my $nur_hier = ($k =~ /^$KURZ$/ && $k !~ /\./);
      if (exists $ziel_von{$k} && (!$nur_hier || $ziel_von{$k}[0] eq $d)) {
        $hier++; "[$k](" . verweis($d, $k) . ")";
      }
      else { $k }
    }ge;

    $z =~ s{\x00(\d+)\x00}{$safe[$1]}g;
    if ($z ne $z[$i]) { $z[$i] = $z; $geaendert = 1 }
  }

  if ($hier) {
    $gesetzt += $hier;
    printf "  %-16s %4d Kennung(en) zu verlinken\n", $d, $hier;
    $offen += $hier unless $verlinken;
    if ($verlinken && $geaendert) { schreib($pfad, join("\n", @z)) }
  }
}

# ---------------------------------------------------------------------------
# 4. Zeigen ins Leere?
# ---------------------------------------------------------------------------
my @tot;
for my $d (@dateien) {
  my $text = lies("$wurzel/$d");
  while ($text =~ m{\]\(([^()\s]*)#([A-Za-z][A-Za-z0-9]{0,8}-\d+(?:\.\d+)?[a-z]?)\)}g) {
    my ($wohin, $id) = ($1, lc $2);
    push @tot, "$d -> #$id" unless $ankerda{$id} || $ankerda2{$id};
  }
}
print "\n";
if (@tot) {
  print "  MANGEL - Verweise ins Leere:\n";
  print "    - $_\n" for @tot;
}
if ($offen) {
  printf "  MANGEL - %d Kennung(en) sind kein Link.\n", $offen;
  print  "    Mit --anker --verlinken nachziehen.\n";
}
if (!@tot && !$offen && !$neu_anker) {
  print "  Jede Kennung ist ein Link, und jeder Link trifft eine Urteilszeile.\n";
}

exit((@tot || $offen || ($neu_anker && !$anker)) ? 1 : 0);
