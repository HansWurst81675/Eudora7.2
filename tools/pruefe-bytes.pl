#!/usr/bin/perl
# Prueft jede zum Commit vorgemerkte Datei auf zwei lautlose Schaeden:
#   1. veraenderte Zeilenenden (CR-Anzahl)
#   2. zerstoerte Sonderzeichen (Unicode-Ersatzzeichen U+FFFD)
#
# Verglichen wird der INDEX-Blob gegen den HEAD-Blob, nicht die Arbeitskopie.
# Grund: manche Dateien liegen im Arbeitsverzeichnis mit CRLF, waehrend im
# Commit LF steht (z. B. doc.h, OleDoc.h) - git meldet sie trotzdem als sauber.
# Ein Vergleich der Arbeitskopie erzeugt dort Fehlalarm. Entscheidend ist
# ohnehin nur, was tatsaechlich in die Historie geschrieben wird.
#
# Bewusst ohne Escape-Sequenzen geschrieben - die waren selbst schon Fehlerquelle.
use strict; use warnings;

my $CR  = chr(13);
my $BAD = chr(0xEF) . chr(0xBF) . chr(0xBD);

sub zaehle {
  my ($text, $muster) = @_;
  my $n = 0; my $p = 0;
  while (($p = index($text, $muster, $p)) >= 0) { $n++; $p += length($muster); }
  return $n;
}

sub blob {
  my ($rev, $datei) = @_;
  my $cmd = "git show $rev:\"$datei\" 2>/dev/null";
  my $out = `$cmd`;
  return (defined $out and length $out) ? $out : undef;
}

# Zaehlt getrennt, wie viele Zeilen mit CRLF und wie viele mit blossem LF enden.
sub zaehle_enden {
  my ($text) = @_;
  my ($crlf, $lf, $p) = (0, 0, 0);
  while (($p = index($text, chr(10), $p)) >= 0) {
    if ($p > 0 and substr($text, $p - 1, 1) eq chr(13)) { $crlf++ } else { $lf++ }
    $p++;
  }
  return ($crlf, $lf);
}

# Zu jedem Zeileninhalt: wie oft kommt er mit CRLF vor, wie oft mit blossem LF?
# Damit laesst sich feststellen, ob eine inhaltlich unveraenderte Zeile ihr
# Zeilenende gewechselt hat.
sub enden_je_inhalt {
  my ($text) = @_;
  my %h;
  my ($anfang, $p) = (0, 0);
  while (($p = index($text, chr(10), $anfang)) >= 0) {
    my $mit_cr = ($p > $anfang and substr($text, $p - 1, 1) eq chr(13));
    my $inhalt = substr($text, $anfang, $p - $anfang - ($mit_cr ? 1 : 0));
    $h{$inhalt} ||= [0, 0];
    $h{$inhalt}[ $mit_cr ? 0 : 1 ]++;
    $anfang = $p + 1;
  }
  return \%h;
}

my @dateien = grep { /\.(cpp|h|c|hpp|inl|rc|idl|mak|txt|md|vcxproj|filters)$/i }
              split /\n/, `git diff --cached --name-only --diff-filter=ACM`;
my @fehler;

for my $d (@dateien) {
  my $jetzt  = blob('',     $d);   # ':datei' = Index
  my $vorher = blob('HEAD', $d);
  next unless defined $jetzt and defined $vorher;   # neue Datei: nichts zu vergleichen

  # Zeilenenden. Verglichen wird NICHT die blosse CR-Zahl - die aendert sich
  # schon, wenn man Zeilen hinzufuegt oder loescht, und der Waechter schlug
  # dann grundlos an (am 30.08.2026 beim Ergaenzen von 20 CRLF-Zeilen in
  # Eudora.vcxproj). Ein Waechter, der grundlos Alarm gibt, wird umgangen und
  # ist damit wertlos.
  #
  # Der Schaden, um den es geht, ist die UMWANDLUNG: aus CRLF wird LF oder
  # umgekehrt. Dabei nimmt eine der beiden Sorten ab. Reines Hinzufuegen laesst
  # beide Zahlen steigen; reines Loeschen laesst sie um hoechstens so viel
  # sinken, wie Zeilen geloescht wurden. Gemeldet wird also nur, wenn eine
  # Sorte um MEHR abnimmt, als der Commit ueberhaupt Zeilen loescht.
  my ($crlf_a, $lf_a) = zaehle_enden($vorher);
  my ($crlf_b, $lf_b) = zaehle_enden($jetzt);

  # Regel 1: Der Inhalt ist gleich, die Bytes nicht. Dann wurde AUSSCHLIESSLICH
  # an den Zeilenenden gedreht - der klassische lautlose Schaden.
  (my $ohne_a = $vorher) =~ s/\r\n/\n/g;
  (my $ohne_b = $jetzt)  =~ s/\r\n/\n/g;

  if ($ohne_a eq $ohne_b and $vorher ne $jetzt) {
    push @fehler, sprintf(
      "%s: NUR die Zeilenenden geaendert, kein Inhalt - CRLF %d -> %d, LF %d -> %d",
      $d, $crlf_a, $crlf_b, $lf_a, $lf_b);
  }
  # Regel 2: Der Inhalt hat sich geaendert, und dabei haben Zeilen, die
  # UNVERAENDERT geblieben sind, ihr Zeilenende gewechselt.
  #
  # Ein blosser Vergleich der CR-ZAHLEN taugt hier nicht: die steigt schon beim
  # Hinzufuegen von Zeilen, und der Waechter schlug dann grundlos an (am
  # 30.08.2026 beim Ergaenzen von 20 CRLF-Zeilen in Eudora.vcxproj). Ein
  # Waechter, der grundlos Alarm gibt, wird umgangen und ist damit wertlos.
  #
  # Ein Vergleich der ANTEILE taugt auch nicht: viele Dateien hier haben
  # gemischte Enden, etwa mainfrm.h mit 18 CRLF unter 655 Zeilen. Gehen die 18
  # verloren, bewegt sich der Anteil um zweieinhalb Punkte - unter jeder
  # sinnvollen Schwelle, obwohl genau das der Schaden ist.
  #
  # Also inhaltsbezogen: fuer jeden Zeileninhalt wird gezaehlt, wie oft er mit
  # CRLF und wie oft mit LF vorkommt. Hatte ein Inhalt in HEAD CRLF-Vorkommen
  # und im Index keine mehr, waehrend er weiter da ist, wurde er umgewandelt.
  else {
    my $a = enden_je_inhalt($vorher);
    my $b = enden_je_inhalt($jetzt);
    my @umgewandelt;
    for my $inhalt (keys %$a) {
      next unless $a->{$inhalt}[0] > 0;                 # hatte kein CRLF
      next unless exists $b->{$inhalt};                 # Inhalt ganz entfallen
      next unless $b->{$inhalt}[0] == 0;                # hat weiter CRLF
      next unless $b->{$inhalt}[1] >= $a->{$inhalt}[0]; # als LF wieder da
      push @umgewandelt, $inhalt;
      last if @umgewandelt >= 3;
    }
    if (@umgewandelt) {
      my $bsp = $umgewandelt[0];
      $bsp = substr($bsp, 0, 40) . '...' if length($bsp) > 40;
      $bsp =~ s/^\s+//;
      push @fehler, sprintf(
        "%s: unveraenderte Zeilen haben ihr Zeilenende gewechselt (CRLF -> LF), z. B. \"%s\"",
        $d, $bsp);
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
