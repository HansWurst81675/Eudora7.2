#!/usr/bin/perl
# Prueft jede zum Commit vorgemerkte Datei gegen HEAD auf zwei lautlose Schaeden:
#   1. veraenderte Zeilenenden (CR-Anzahl)
#   2. zerstoerte Sonderzeichen (Unicode-Ersatzzeichen U+FFFD)
# Bewusst ohne Escape-Sequenzen geschrieben - die waren selbst schon die Fehlerquelle.
use strict; use warnings;

my $CR  = chr(13);
my $BAD = chr(0xEF) . chr(0xBF) . chr(0xBD);

sub zaehle {
  my ($text, $muster) = @_;
  my $n = 0; my $p = 0;
  while (($p = index($text, $muster, $p)) >= 0) { $n++; $p += length($muster); }
  return $n;
}

my @dateien = grep { /\.(cpp|h|c|hpp|inl|rc|idl|mak|txt|md)$/i }
              split /\n/, `git diff --cached --name-only --diff-filter=ACM`;
my @fehler;

for my $d (@dateien) {
  next unless -f $d;
  local $/; open(my $fh, '<:raw', $d) or next; my $jetzt = <$fh>; close $fh;
  my $vorher = `git show HEAD:"$d" 2>/dev/null`;
  next unless defined $vorher and length $vorher;   # neue Datei: nichts zu vergleichen

  my $cr_a = zaehle($vorher, $CR);  my $cr_b = zaehle($jetzt, $CR);
  push @fehler, "$d: Zeilenenden veraendert - CR $cr_a in HEAD, $cr_b jetzt"
    if $cr_a != $cr_b;

  my $bd_a = zaehle($vorher, $BAD); my $bd_b = zaehle($jetzt, $BAD);
  push @fehler, "$d: Sonderzeichen zerstoert - $bd_b Ersatzzeichen (U+FFFD), vorher $bd_a"
    if $bd_b > $bd_a;
}

if (@fehler) {
  print "\nCOMMIT ABGEBROCHEN - lautloser Schaden erkannt:\n\n";
  print "  * $_\n" for @fehler;
  print "\nDiese Dateien sind Latin-1 mit gemischten Zeilenenden. Ein Werkzeug hat sie\n";
  print "komplett neu geschrieben. Zurueckseten mit  git checkout -- <datei>  und die\n";
  print "Aenderung byte-erhaltend wiederholen (tools/aendere-zeile.pl).\n";
  print "Bewusst trotzdem committen:  git commit --no-verify\n\n";
  exit 1;
}
exit 0;
