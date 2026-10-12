#!/usr/bin/perl
# befunde-verlinken.pl - macht jede Befundkennung in den fuehrenden Dokumenten
# anklickbar und haelt die Verweise gegen BEFUNDE.md.
#
#   perl tools/befunde-verlinken.pl              # nur pruefen (Schranke)
#   perl tools/befunde-verlinken.pl --anker      # Anker in BEFUNDE.md anlegen
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
# Auf die Zeile in der Urteilstabelle von BEFUNDE.md. Gemessen am 12.10.2026:
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
# allein die Urteilstabelle in BEFUNDE.md.
my $PRAEFIX = qr/[A-Z][A-Za-z0-9]{0,8}/;
my $KENNUNG = qr/$PRAEFIX-\d+[a-z]?/;

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
my $bef = "$wurzel/BEFUNDE.md";
my @bz = split /\n/, lies($bef), -1;

my %zeile_von;        # Kennung -> Index in @bz
for my $i (0 .. $#bz) {
  next unless $bz[$i] =~ /^\|\s*(?:<a\s+id="[^"]*"><\/a>)?\s*($KENNUNG)\s*\|/;
  $zeile_von{$1} = $i unless exists $zeile_von{$1};
}
my @kennungen = sort keys %zeile_von;
my %ankerda = map { lc($_) => 1 } @kennungen;
printf "BEFUNDE.md: %d Kennungen in der Urteilstabelle\n", scalar @kennungen;

sub ankername { my $k = lc shift; return $k }

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
if ($neu_anker) {
  if ($anker) { schreib($bef, join("\n", @bz)); print "Anker gesetzt: $neu_anker\n" }
  else        { print "Anker fehlen: $neu_anker (mit --anker setzen)\n" }
}
else { print "Anker: alle $,".scalar(@kennungen)." vorhanden\n" if 0; print "Anker: vollstaendig\n" }

# ---------------------------------------------------------------------------
# 3. Verlinken
# ---------------------------------------------------------------------------
# Keine feste Liste: Gregor sagte "ueberall". Genommen wird jede .md im
# Wurzelverzeichnis - ein neues Dokument ist damit von selbst dabei, und
# niemand muss daran denken.
my @dateien = sort map { s{^\Q$wurzel\E/}{}r } glob("$wurzel/*.md");

my $offen = 0;
my $gesetzt = 0;

for my $d (@dateien) {
  my $pfad = "$wurzel/$d";
  my $text = lies($pfad);
  my @z = split /\n/, $text, -1;
  my $in_block = 0;
  my $geaendert = 0;
  my $hier = 0;
  my %schon;     # Kennung -> im laufenden Absatz bereits verlinkt

  for my $i (0 .. $#z) {
    my $z = $z[$i];

    # Ein neuer Absatz faengt bei einer Leerzeile, einer Ueberschrift, einer
    # Tabellenzeile oder einem Aufzaehlungspunkt an. Dort wird wieder
    # verlinkt; INNERHALB eines Absatzes nur die erste Nennung.
    #
    # Warum nicht jede: Gregor am 12.10.2026 - "mein anliegen ist, dass man
    # sich schneller zurecht findet, nicht die uebersicht verliert". 1473
    # blaue Stellen sind keine Uebersicht, sondern eine zweite Sorte Laerm.
    %schon = () if $z =~ /^\s*$/ || $z =~ /^\s*#/ || $z =~ /^\s*[|*+-]/
                 || $z =~ /^\s*\d+\./ || $z =~ /^\s*>\s*$/;

    if ($z =~ /^\s*```/) { $in_block = !$in_block; next }
    next if $in_block;
    next if $z =~ /^\s*#/;                       # Ueberschrift
    # Die Ankerzelle der Urteilstabelle in BEFUNDE.md bleibt, wie sie ist.
    # In BEFUNDE.md bleibt die Urteilstabelle unverlinkt: dort steht die
    # Kennung bei ihrer eigenen Beschreibung, ein Link auf sich selbst
    # hilft niemandem und faerbt 138 Zeilen blau.
    next if $d eq 'BEFUNDE.md' && $z =~ /^\|\s*(?:<a\s+id="[^"]*"><\/a>)?\s*$KENNUNG\s*\|/;

    # Abschnitte, die NICHT angefasst werden duerfen: Code in Rueckstrichen
    # und fertige Links. Beides wird herausgeschnitten, ersetzt und wieder
    # eingesetzt - so kann die Ersetzung sie nicht treffen.
    my @safe;
    $z =~ s{(`[^`]*`|\[[^\]]*\]\([^)]*\))}{
      my $s = $1;
      # Ein FERTIGER Befundlink zaehlt als die Nennung dieses Absatzes -
      # sonst verlinkt der naechste Lauf die zweite Nennung und der
      # uebernaechste die dritte, bis der Absatz durchgehend blau ist.
      $schon{$1} = 1 while $s =~ /\[\*{0,2}($KENNUNG)\*{0,2}\]\([^)]*#/g;
      push @safe, $s; "\x00" . $#safe . "\x00"
    }ge;

    my $ziel = ($d eq 'BEFUNDE.md') ? '' : 'BEFUNDE.md';

    # (?!\.[0-9a-z]) haelt Unterkennungen zusammen: ohne das wird aus
    # P-1.5b ein [P-1](#p-1).5b - ein Link auf den Oberbefund mit einem
    # abgeschnittenen Rest dahinter. Ein Satzpunkt (Punkt + Leerzeichen)
    # bleibt erlaubt.
    $z =~ s{(?<![A-Za-z0-9])(\*\*)?($KENNUNG)(\*\*)?(?![\d\w-])(?!\.[0-9a-z])}{
      my ($f1, $k, $f2) = ($1 // '', $2, $3 // '');
      if (exists $zeile_von{$k} && !$schon{$k} && (($f1 eq '') == ($f2 eq ''))) {
        $hier++;
        $schon{$k} = 1;
        "[$f1$k$f2]($ziel#" . ankername($k) . ")";
      } else {
        "$f1$k$f2";
      }
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
  # NICHT $KENNUNG einsetzen: ein mit qr// uebersetztes Muster traegt seine
  # eigenen Schalter, das /i von aussen wirkt darin nicht. Genau daran war
  # diese Pruefung blind - die Gegenprobe mit #e-999 lief am 12.10.2026
  # gruen durch, weil das Muster [A-Z] verlangte und der Anker klein ist.
  while ($text =~ m{\]\((?:BEFUNDE\.md)?#([A-Za-z][A-Za-z0-9]{0,8}-\d+[a-z]?)\)}g) {
    # Verglichen wird gegen den ANKERNAMEN, nicht gegen die Kennung in
    # Grossschreibung: uc("z-2b") ist "Z-2B", die Kennung heisst aber
    # "Z-2b" - vier echte Verweise galten dadurch als tot.
    push @tot, "$d -> #$1" unless exists $ankerda{lc $1};
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
