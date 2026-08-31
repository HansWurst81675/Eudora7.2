#!/usr/bin/perl
# Prueft jede zum Commit vorgemerkte Datei auf zwei lautlose Schaeden:
#   1. umgewandelte Zeilenenden - CRLF -> LF UND LF -> CRLF
#   2. zerstoerte Sonderzeichen (Unicode-Ersatzzeichen U+FFFD)
#
# Verglichen wird der INDEX-Blob gegen den HEAD-Blob, nicht die Arbeitskopie.
# Grund: manche Dateien liegen im Arbeitsverzeichnis mit CRLF, waehrend im
# Commit LF steht - git meldet sie trotzdem als sauber. Ein Vergleich der
# Arbeitskopie erzeugt dort Fehlalarm. Entscheidend ist ohnehin nur, was
# tatsaechlich in die Historie geschrieben wird.
#
# GEGENPROBE: tools/pruefe-bytes-tests.pl. Wer diese Datei anfasst, laesst die
# Sammlung laufen. Sie ist genau deshalb entstanden, weil eine fruehere
# "Reparatur" die Schranke schlimmer gemacht hat, ohne dass es auffiel.
#
# Bewusst ohne Escape-Sequenzen geschrieben - die waren selbst schon Fehlerquelle.
use strict; use warnings;
use FindBin;

my $CR  = chr(13);
my $LF  = chr(10);
my $BAD = chr(0xEF) . chr(0xBF) . chr(0xBD);

# Gemeinsame Endungsliste mit tools/zeilenenden-angleichen.pl. Laesst sie sich
# nicht laden, wird der Commit abgebrochen: eine Schranke, die stillschweigend
# nichts mehr prueft, ist schlimmer als gar keine.
my $D = do "$FindBin::Bin/dateiendungen.pl";
unless (ref($D) eq 'HASH' and $D->{muster}) {
  print "\nCOMMIT ABGEBROCHEN - tools/dateiendungen.pl laesst sich nicht laden.\n";
  print "  Grund: " . ($@ ? $@ : $!) . "\n";
  print "Ohne die Liste prueft die Schranke gar nichts. Erst die Datei in Ordnung\n";
  print "bringen. Bewusst trotzdem committen:  git commit --no-verify\n\n";
  exit 1;
}

sub zaehle {
  my ($text, $muster) = @_;
  my $n = 0; my $p = 0;
  while (($p = index($text, $muster, $p)) >= 0) { $n++; $p += length($muster); }
  return $n;
}

# Ruft git ohne Shell auf und liest die Ausgabe byteweise. Die Listenform
# vermeidet jedes Anfuehrungszeichen-Problem mit Pfaden.
sub git_roh {
  my @arg = @_;
  my $pid = open(my $fh, '-|');
  return undef unless defined $pid;
  if (!$pid) {
    open(STDERR, '>', '/dev/null') or open(STDERR, '>', 'NUL');
    exec('git', @arg) or exit 127;
  }
  binmode($fh);
  local $/;
  my $aus = <$fh>;
  close $fh;
  return $aus;
}

sub blob {
  my ($rev, $datei) = @_;
  my $out = git_roh('show', "$rev:$datei");
  return (defined $out and length $out) ? $out : undef;
}

# Zaehlt getrennt, wie viele Zeilen mit CRLF und wie viele mit blossem LF enden.
sub zaehle_enden {
  my ($text) = @_;
  my ($crlf, $lf, $p) = (0, 0, 0);
  while (($p = index($text, $LF, $p)) >= 0) {
    if ($p > 0 and substr($text, $p - 1, 1) eq $CR) { $crlf++ } else { $lf++ }
    $p++;
  }
  return ($crlf, $lf);
}

# ---------------------------------------------------------------------------
# Regel 2: umgewandelte Zeilen im eigentlichen Unterschied suchen.
#
# WARUM NICHT UEBER DEN ZEILENINHALT
#
# Die Fassung vom 30.08.2026 zaehlte je Zeileninhalt, wie oft er mit CRLF und
# wie oft mit LF vorkommt, und meldete jeden Inhalt, der seine CRLF-Vorkommen
# verloren hatte. Das hat zwei Loecher, beide belegt (Befund PR-1/PR-2):
#
#   * Sie sah nur die Richtung CRLF -> LF. Unter Windows ist LF -> CRLF die
#     wahrscheinlichere Schadensrichtung - Editoren, Set-Content, Out-File
#     schreiben CRLF. Genau die lief lautlos durch.
#   * Der Zeileninhalt taugt nicht als Schluessel. "", "{", "}" und ein blosser
#     Tabulator kommen in einer Datei hundertfach vor, mit beiden Enden. Welches
#     Vorkommen welches war, geht beim Zaehlen verloren. Eine geloeschte
#     CRLF-Leerzeile plus eine ergaenzte LF-Leerzeile sah deshalb aus wie eine
#     Umwandlung - Fehlalarm, und als Beispiel nannte die Meldung die leere
#     Zeichenkette, also gar keinen Hinweis.
#
# WAS STATTDESSEN
#
# Der Waechter soll UMWANDLUNGEN erkennen und Ergaenzungen wie Loeschungen
# durchlassen. Genau diese Unterscheidung trifft git selbst schon: eine
# umgewandelte Zeile erscheint in "git diff --cached -U0" als Paar aus einer
# entfernten und einer hinzugefuegten Zeile IM SELBEN Block, deren Inhalt
# gleich und deren Zeilenende verschieden ist. Eine reine Ergaenzung erzeugt
# einen Block ohne entfernte Zeilen, eine reine Loeschung einen ohne
# hinzugefuegte - dort entsteht gar kein Paar.
#
# Damit ist die Zuordnung ortsgebunden statt inhaltsgebunden, und der
# Leerzeilen-Fehlalarm kann strukturell nicht mehr auftreten: die geloeschte
# und die ergaenzte Leerzeile stehen an verschiedenen Stellen und landen
# deshalb in verschiedenen Bloecken.
#
# Innerhalb eines Blocks werden entfernte und hinzugefuegte Zeilen der Reihe
# nach gepaart. Sind es gleich viele - der Normalfall bei einer Umwandlung -
# passt das genau. Sind es verschieden viele (Umwandlung UND ergaenzte Zeilen),
# wird mit begrenzter Vorausschau nachgefuehrt, damit die Paare nicht
# verrutschen.
# ---------------------------------------------------------------------------

my $VORAUSSCHAU = 30;

sub zerlege_diffzeile {
  my ($z) = @_;                      # ohne das fuehrende - oder +
  return [ substr($z, 0, length($z) - 1), 'CRLF' ]
    if length($z) and substr($z, length($z) - 1, 1) eq $CR;
  return [ $z, 'LF' ];
}

sub umwandlungen {
  my ($datei) = @_;
  my $roh = git_roh('diff', '--cached', '-U0', '--no-color', '--no-ext-diff',
                    '--', $datei);
  return () unless defined $roh and length $roh;

  my @treffer;
  my (@weg, @dazu);
  my $letzte_seite = '';

  my $block_auswerten = sub {
    if (@weg and @dazu) {
      my @paare;
      if (@weg == @dazu) {
        @paare = map { [ $weg[$_], $dazu[$_] ] } 0 .. $#weg;
      }
      else {
        my ($i, $j) = (0, 0);
        while ($i <= $#weg and $j <= $#dazu) {
          if ($weg[$i][0] eq $dazu[$j][0]) {
            push @paare, [ $weg[$i], $dazu[$j] ]; $i++; $j++; next;
          }
          my ($vor_dazu, $vor_weg) = (-1, -1);
          for my $k (1 .. $VORAUSSCHAU) {
            last if $j + $k > $#dazu;
            if ($weg[$i][0] eq $dazu[$j + $k][0]) { $vor_dazu = $k; last }
          }
          for my $k (1 .. $VORAUSSCHAU) {
            last if $i + $k > $#weg;
            if ($dazu[$j][0] eq $weg[$i + $k][0]) { $vor_weg = $k; last }
          }
          if    ($vor_dazu >= 0 and ($vor_weg < 0 or $vor_dazu <= $vor_weg)) { $j += $vor_dazu }
          elsif ($vor_weg  >= 0)                                            { $i += $vor_weg }
          else { push @paare, [ $weg[$i], $dazu[$j] ]; $i++; $j++ }
        }
      }
      for my $p (@paare) {
        my ($a, $b) = @$p;
        next unless $a->[0] eq $b->[0];        # anderer Inhalt: echte Aenderung
        next if $a->[1] eq 'OHNE' or $b->[1] eq 'OHNE';   # letzte Zeile ohne Umbruch
        next if $a->[1] eq $b->[1];            # Zeilenende unveraendert
        push @treffer, [ $a->[0], $a->[1], $b->[1] ];
      }
    }
    @weg = (); @dazu = (); $letzte_seite = '';
  };

  my $im_kopf = 1;
  for my $z (split /\n/, $roh, -1) {
    if (index($z, '@@ ') == 0) { $block_auswerten->(); $im_kopf = 0; next }
    next if $im_kopf;
    my $erst = length($z) ? substr($z, 0, 1) : '';
    if ($erst eq '\\') {                       # "\ No newline at end of file"
      if    ($letzte_seite eq '-' and @weg)  { $weg[-1][1]  = 'OHNE' }
      elsif ($letzte_seite eq '+' and @dazu) { $dazu[-1][1] = 'OHNE' }
      next;
    }
    if ($erst eq '-') { push @weg,  zerlege_diffzeile(substr($z, 1)); $letzte_seite = '-'; next }
    if ($erst eq '+') { push @dazu, zerlege_diffzeile(substr($z, 1)); $letzte_seite = '+'; next }
  }
  $block_auswerten->();
  return @treffer;
}

# ---------------------------------------------------------------------------

my @vorgemerkt = split /\n/,
  (git_roh('diff', '--cached', '--name-only', '--diff-filter=ACM') || '');
my @dateien = grep { $_ =~ $D->{muster} } @vorgemerkt;
my @fehler;

for my $d (@dateien) {
  my $jetzt  = blob('',     $d);   # ':datei' = Index
  my $vorher = blob('HEAD', $d);
  next unless defined $jetzt and defined $vorher;   # neue Datei: nichts zu vergleichen

  my ($crlf_a, $lf_a) = zaehle_enden($vorher);
  my ($crlf_b, $lf_b) = zaehle_enden($jetzt);

  # Regel 1: Der Inhalt ist gleich, die Bytes nicht. Dann wurde AUSSCHLIESSLICH
  # an den Zeilenenden gedreht - der klassische lautlose Schaden. Diese Regel
  # arbeitet auf den rohen Blobs und ist damit unabhaengig davon, wie git den
  # Unterschied darstellt.
  (my $ohne_a = $vorher) =~ s/\r\n/\n/g;
  (my $ohne_b = $jetzt)  =~ s/\r\n/\n/g;

  if ($ohne_a eq $ohne_b and $vorher ne $jetzt) {
    push @fehler, sprintf(
      "%s: NUR die Zeilenenden geaendert, kein Inhalt - CRLF %d -> %d, LF %d -> %d",
      $d, $crlf_a, $crlf_b, $lf_a, $lf_b);
  }
  # Regel 2: Inhalt UND Zeilenenden geaendert. Siehe die Begruendung oben.
  else {
    my @um = umwandlungen($d);
    if (@um) {
      my %richtung;
      $richtung{ $_->[1] . ' -> ' . $_->[2] }++ for @um;
      my $bsp = $um[0][0];
      $bsp =~ s/^\s+//;
      $bsp = substr($bsp, 0, 40) . '...' if length($bsp) > 40;
      $bsp = '(Leerzeile)' unless length $bsp;
      push @fehler, sprintf(
        "%s: %d Zeile(n) haben bei unveraendertem Inhalt ihr Zeilenende gewechselt (%s), z. B. \"%s\"",
        $d, scalar(@um), join(', ', map { "$_ x$richtung{$_}" } sort keys %richtung), $bsp);
    }
  }

  my $bd_a = zaehle($vorher, $BAD); my $bd_b = zaehle($jetzt, $BAD);
  push @fehler, "$d: Sonderzeichen zerstoert - $bd_b Ersatzzeichen (U+FFFD), vorher $bd_a"
    if $bd_b > $bd_a;
}

if (@fehler) {
  print "\nCOMMIT ABGEBROCHEN - lautloser Schaden erkannt:\n\n";
  print "  * $_\n" for @fehler;
  print "\nDiese Quellen sind Latin-1 mit gemischten Zeilenenden. Ein Werkzeug hat die\n";
  print "Datei komplett neu geschrieben. Zuruecksetzen mit  git checkout -- <datei>  und\n";
  print "die Aenderung byte-erhaltend wiederholen:  perl tools/aendere-zeile.pl\n";
  print "Bewusst trotzdem committen:  git commit --no-verify\n\n";
  exit 1;
}
exit 0;
