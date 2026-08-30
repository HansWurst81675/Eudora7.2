#!/usr/bin/perl
# Ersetzt einen zusammenhaengenden Zeilenbereich einer Quelldatei byte-erhaltend.
#
#   perl tools/ersetze-bereich.pl <datei> <vonZeile> <bisZeile> <neuerBlock>
#
# Ergaenzt tools/aendere-zeile.pl: jenes Werkzeug kann nur INNERHALB einer Zeile
# ersetzen und keine Zeilen einfuegen oder loeschen. Fuer groessere Umbauten
# (eine ganze Funktion neu schreiben) braucht es diesen Weg.
#
# Gelesen und geschrieben wird ausschliesslich mit :raw. Alles VOR <vonZeile> und
# alles NACH <bisZeile> wird byteweise unveraendert durchgereicht - das wird nach
# dem Schreiben nachgemessen und bei Abweichung abgebrochen. Der neue Block wird
# genau so uebernommen, wie er in <neuerBlock> steht; die Datei mit dem neuen
# Block muss also selbst schon die richtigen Zeilenenden haben.
#
# Ausgegeben werden die CR-Zahlen vorher/nachher, damit ein versehentlicher
# Wechsel von LF auf CRLF sofort auffaellt (der pre-commit-Hook weist ihn ab).
use strict; use warnings;

my ($datei, $von, $bis, $blockdatei) = @ARGV;
die "Aufruf: $0 <datei> <vonZeile> <bisZeile> <neuerBlock>\n"
  unless defined $blockdatei and $von =~ /^[0-9]+$/ and $bis =~ /^[0-9]+$/;
die "vonZeile ($von) liegt hinter bisZeile ($bis)\n" if $von > $bis;

sub lies_roh {
  my ($p) = @_;
  open(my $fh, '<:raw', $p) or die "$p: $!\n";
  local $/; my $t = <$fh>; close $fh;
  return defined $t ? $t : '';
}

sub zaehle_cr { my ($t) = @_; my $n = () = $t =~ /\r/g; return $n; }

my $inhalt = lies_roh($datei);
my $block  = lies_roh($blockdatei);

my @zeilen = split /(?<=\n)/, $inhalt;
die "$datei hat nur " . scalar(@zeilen) . " Zeilen\n" if $bis > @zeilen;

my $kopf  = join('', @zeilen[0 .. $von - 2]);
my $alt   = join('', @zeilen[$von - 1 .. $bis - 1]);
my $fuss  = join('', @zeilen[$bis .. $#zeilen]);

my $neuinhalt = $kopf . $block . $fuss;

open(my $out, '>:raw', $datei) or die "$datei: $!\n";
print $out $neuinhalt; close $out;

# Nachmessen: Kopf und Fuss muessen byteweise dieselben Bytes sein.
my $kontrolle = lies_roh($datei);
my $k_neu = substr($kontrolle, 0, length($kopf));
my $f_neu = length($fuss) ? substr($kontrolle, -length($fuss)) : '';
die "ABBRUCH: Kopf hat sich veraendert\n" if $k_neu ne $kopf;
die "ABBRUCH: Fuss hat sich veraendert\n" if $f_neu ne $fuss;

printf "ok %s: Zeilen %d..%d ersetzt (%d -> %d Zeilen)\n",
       $datei, $von, $bis,
       scalar(() = $alt =~ /\n/g), scalar(() = $block =~ /\n/g);
printf "   CR in der Datei: %d vorher, %d nachher (ersetzter Block: %d -> %d)\n",
       zaehle_cr($inhalt), zaehle_cr($neuinhalt), zaehle_cr($alt), zaehle_cr($block);
