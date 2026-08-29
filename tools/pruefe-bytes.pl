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

my @dateien = grep { /\.(cpp|h|c|hpp|inl|rc|idl|mak|txt|md|vcxproj|filters)$/i }
              split /\n/, `git diff --cached --name-only --diff-filter=ACM`;
my @fehler;

for my $d (@dateien) {
  my $jetzt  = blob('',     $d);   # ':datei' = Index
  my $vorher = blob('HEAD', $d);
  next unless defined $jetzt and defined $vorher;   # neue Datei: nichts zu vergleichen

  my $cr_a = zaehle($vorher, $CR);  my $cr_b = zaehle($jetzt, $CR);
  push @fehler, "$d: Zeilenenden veraendert - CR $cr_a in HEAD, $cr_b im Index"
    if $cr_a != $cr_b;

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
