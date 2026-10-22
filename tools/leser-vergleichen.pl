#!/usr/bin/perl
# leser-vergleichen.pl - jeden Leser gegen den Stand VOR der Aenderung fahren.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 12.10.2026 habe ich in Intern/BEFUNDE.md vor jede Kennung der Urteilstabelle
# einen Anker gesetzt - eine Ergaenzung, keine Zeile mehr oder weniger.
# ZWOELF Werkzeuge lesen genau diese erste Zelle, und alle zwoelf haben sie
# danach nicht mehr gefunden:
#
#   doku-pruefen.pl                164 Kennungen ->   1, weist ab
#   pruefe-behoben-ausgeliefert.pl  17 Urteile   ->   0, RUECKGABEWERT 0
#   pruefe-befund-verbreitung.pl    Umfang E-94  -> (keine), RUECKGABEWERT 0
#   spuren-auswerten.pl            frei          -> weist falsch ab
#   ... und acht weitere
#
# Die gefaehrlichen sind nicht die, die abweisen. Die gefaehrlichen sind die
# beiden, die weiter GRUEN meldeten, waehrend sie nichts mehr pruefen - Befund
# E-109, Punkt (4): "ein Freispruch ueber eine leere Menge".
#
# Gefunden hat das kein Rueckgabewert, sondern der Vergleich der GANZEN
# Ausgabe gegen einen Arbeitsbaum auf dem Stand davor. Genau das macht dieses
# Werkzeug, damit es nicht wieder von Hand gemacht werden muss.
#
# Arbeitsweise/datenformat-aendern-heisst-alle-leser-messen.md
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/leser-vergleichen.pl              gegen origin/main
#   perl tools/leser-vergleichen.pl <commit>     gegen einen anderen Stand
#   perl tools/leser-vergleichen.pl --tests      Selbsttest
#
# Rueckgabe 0, wenn jeder Leser dieselbe Ausgabe liefert wie vorher;
# 1 bei jeder Abweichung; 2 bei einem Aufrufproblem.
#
# Was NICHT verglichen wird, und warum:
#   * pruefe-branch.pl       - der Vergleichsbaum hat einen abgeloesten HEAD,
#                              das meldet sie zu Recht und immer.
#   * pruefe-stand-md.pl     - zaehlt die Berichte mit; ein neuer Bericht im
#                              selben Commit ist eine erwuenschte Abweichung.
#   * *-tests.pl             - Selbsttests, sie nennen ihren eigenen Pfad.
# Diese drei werden genannt, nicht verschwiegen.

use strict;
use warnings;
use File::Temp ();
use File::Path ();
use Cwd ();

my @ARG = @ARGV;
my $tests = grep { $_ eq '--tests' } @ARG;
@ARG = grep { $_ ne '--tests' } @ARG;

my $wurzel = $0;
$wurzel =~ s{[\\/]tools[\\/][^\\/]+$}{};
$wurzel = '.' if $wurzel eq $0 || $wurzel eq '';

# Was ein "Leser" ist: jedes Werkzeug, das Markdown-Tabellenzeilen zerlegt.
# NICHT von Hand aufgezaehlt - die Liste kommt aus dem Quelltext, sonst fehlt
# genau der, an den niemand gedacht hat (Arbeitsweise/pruefumfang-nicht-von-hand.md).
# Genau dieser Fehler ist am 12.10.2026 passiert: der erste Durchgang filterte
# auf "BEFUNDE" und uebersah spuren-auswerten.pl, das SPURMARKEN.md liest.
sub leser_suchen {
  my ($baum) = @_;
  my @gefunden;
  for my $p (sort glob("$baum/tools/*.pl")) {
    (my $kurz = $p) =~ s{^\Q$baum\E/}{};
    next if $kurz =~ /-tests\.pl$/;
    next if $kurz =~ /^tools\/(?:pruefe-branch|pruefe-stand-md|leser-vergleichen)\.pl$/;
    open my $f, '<:raw', $p or next;
    local $/; my $t = <$f>; close $f;
    next unless $t =~ /\.md/;                 # liest ueberhaupt Markdown
    next unless $t =~ /\^\\s\*\\\||\^\\\|/;   # zerlegt Tabellenzeilen
    push @gefunden, $kurz;
  }
  return @gefunden;
}

# ---------------------------------------------------------------------------
# Selbsttest
# ---------------------------------------------------------------------------
if ($tests) {
  my ($n, $schlecht) = (0, 0);
  my $pruefe = sub {
    my ($was, $ist, $soll) = @_;
    $n++;
    return if (defined $ist ? $ist : '') eq (defined $soll ? $soll : '');
    $schlecht++;
    print "  ABWEICHUNG: $was\n    erwartet '$soll', bekommen '", ($ist // '(undef)'), "'\n";
  };

  # saeubern(): macht zwei Ausgaben vergleichbar, ohne echte Unterschiede
  # zuzudecken. Nur der Pfad des Vergleichsbaums faellt weg.
  $pruefe->('Pfad des Vergleichsbaums faellt weg',
            saeubern("Arbeitsbaum: /tmp/x7/tools/..\n  164 Kennungen\n", '/tmp/x7'),
            "Arbeitsbaum: <VERGLEICHSBAUM>/tools/..\n  164 Kennungen\n");
  $pruefe->('eine echte Zahl bleibt stehen',
            saeubern("  0 Urteile\n", '/tmp/x7'), "  0 Urteile\n");
  $pruefe->('ohne Treffer unveraendert',
            saeubern("nichts\n", '/tmp/x7'), "nichts\n");
  $pruefe->('ein Punkt als Wurzel ersetzt NICHTS',
            saeubern("Quellstand 7.2.0.84\n", '.'), "Quellstand 7.2.0.84\n");
  $pruefe->('ein leerer Wert ersetzt NICHTS',
            saeubern("Intern/BEFUNDE.md: 168\n", ''), "Intern/BEFUNDE.md: 168\n");
  $pruefe->('ein Wert ohne Schraegstrich ersetzt NICHTS',
            saeubern("ANWEISUNG-changelog.md\n", 'xyzw'), "ANWEISUNG-changelog.md\n");
  $pruefe->('Pfad mehrfach',
            saeubern("/tmp/x7/a /tmp/x7/b\n", '/tmp/x7'),
            "<VERGLEICHSBAUM>/a <VERGLEICHSBAUM>/b\n");
  # Die Leserliste darf nicht von Hand kommen
  my @l = leser_suchen($wurzel);
  $pruefe->('spuren-auswerten.pl ist in der Leserliste',
            (grep { $_ eq 'tools/spuren-auswerten.pl' } @l) ? 'ja' : 'nein', 'ja');
  $pruefe->('pruefe-behoben-ausgeliefert.pl ist in der Leserliste',
            (grep { $_ eq 'tools/pruefe-behoben-ausgeliefert.pl' } @l) ? 'ja' : 'nein', 'ja');
  $pruefe->('doku-pruefen.pl ist in der Leserliste',
            (grep { $_ eq 'tools/doku-pruefen.pl' } @l) ? 'ja' : 'nein', 'ja');
  $pruefe->('pruefe-branch.pl ist bewusst draussen',
            (grep { $_ eq 'tools/pruefe-branch.pl' } @l) ? 'ja' : 'nein', 'nein');
  $pruefe->('es sind ueberhaupt welche da', (@l >= 5 ? 'ja' : 'nein'), 'ja');

  printf "\n  leser-vergleichen: %d Faelle, %d Abweichung(en)\n\n", $n, $schlecht;
  exit($schlecht ? 1 : 0);
}

sub saeubern {
  my ($t, @pfade) = @_;
  return $t unless defined $t;
  # Nur ECHTE Verzeichnispfade ersetzen. Ein "." oder ein leerer Wert ist
  # keiner - die erste Fassung hat damit jeden Punkt im Text ersetzt und
  # aus "7.2.0.84" ein "7<VERGLEICHSBAUM>2<VERGLEICHSBAUM>0..." gemacht.
  # Gefunden beim ersten echten Lauf, nicht im Selbsttest; daher Fall 3
  # und 4 unten.
  for my $p (@pfade) {
    next unless defined $p && length($p) > 3 && $p =~ m{/};
    $t =~ s/\Q$p\E/<VERGLEICHSBAUM>/g;
  }
  return $t;
}

# ---------------------------------------------------------------------------
# Hauptlauf
# ---------------------------------------------------------------------------
my $stand = $ARG[0] // 'origin/main';

chomp(my $aufgeloest = `git -C "$wurzel" rev-parse --verify "$stand^{commit}" 2>&1`);
if ($? != 0) {
  print "\n  leser-vergleichen: '$stand' ist kein Commit.\n";
  print "  Aufruf: perl tools/leser-vergleichen.pl [<commit>]\n\n";
  exit 2;
}

my @leser = leser_suchen($wurzel);
unless (@leser) {
  print "\n  leser-vergleichen: kein Leser gefunden - das ist selbst ein Mangel.\n\n";
  exit 1;
}

my $abs_wurzel = Cwd::abs_path($wurzel) // $wurzel;
my $baum = File::Temp::tempdir('leser-vergleichen-XXXXXX', TMPDIR => 1);
File::Path::rmtree($baum);
system("git -C \"$wurzel\" worktree add -f --detach \"$baum\" $aufgeloest >/dev/null 2>&1");
unless (-d "$baum/tools") {
  print "\n  leser-vergleichen: Arbeitsbaum auf $aufgeloest liess sich nicht anlegen.\n\n";
  exit 2;
}

printf "\n  %s\n", '-' x 70;
printf "  leser-vergleichen - %d Leser gegen %s (%s)\n",
       scalar @leser, $stand, substr($aufgeloest, 0, 7);
printf "  %s\n\n", '-' x 70;

my @abweichung;
my @fehlt;
for my $l (@leser) {
  unless (-f "$baum/$l") { push @fehlt, $l; next }       # im alten Stand neu
  my $vor  = saeubern(scalar `cd "$baum"   && perl "$l" 2>&1`, $baum, $abs_wurzel);
  my $nach = saeubern(scalar `cd "$wurzel" && perl "$l" 2>&1`, $baum, $abs_wurzel);
  next if $vor eq $nach;
  # Erster Unterschied, damit die Meldung lesbar bleibt
  my @v = split /\n/, $vor;
  my @n = split /\n/, $nach;
  my $i = 0;
  $i++ while $i < @v && $i < @n && $v[$i] eq $n[$i];
  push @abweichung, { was => $l,
                      vor => ($v[$i] // '(Ausgabe zu Ende)'),
                      nach => ($n[$i] // '(Ausgabe zu Ende)') };
}

system("git -C \"$wurzel\" worktree remove --force \"$baum\" >/dev/null 2>&1");

if (@fehlt) {
  print "  Neu seit $stand, deshalb nicht vergleichbar:\n";
  print "    - $_\n" for @fehlt;
  print "\n";
}

if (@abweichung) {
  print "  MANGEL - diese Leser liefern etwas anderes als vorher:\n\n";
  for my $a (@abweichung) {
    print "    * $a->{was}\n";
    print "        vorher:  $a->{vor}\n";
    print "        jetzt:   $a->{nach}\n\n";
  }
  print "  Jede Abweichung ist zu erklaeren, bevor sie stehen bleibt. Ein\n";
  print "  Leser, der weniger findet als vorher UND weiter gruen meldet, ist\n";
  print "  der gefaehrlichste Fall - Befund E-109, Punkt (4).\n\n";
  exit 1;
}

printf "  Alle %d Leser liefern Zeichen fuer Zeichen dieselbe Ausgabe wie auf %s.\n\n",
       scalar @leser, substr($aufgeloest, 0, 7);
exit 0;
