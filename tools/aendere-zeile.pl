#!/usr/bin/perl
# Aendert eine einzelne Zeile einer Quelldatei byte-erhaltend.
#
#   perl tools/aendere-zeile.pl <datei> <zeilennummer> <alt> <neu>
#
# Liest und schreibt mit :raw und ersetzt per index/substr. Damit bleiben
# Zeilenenden (auch gemischte) und die Latin-1-Kodierung unangetastet.
# Es wird KEIN regulaerer Ausdruck benutzt - <alt> ist eine woertliche Zeichenkette.
use strict; use warnings;

my ($datei, $nr, $alt, $neu) = @ARGV;
die "Aufruf: $0 <datei> <zeilennummer> <alt> <neu>\n"
  unless defined $neu and $nr =~ /^[0-9]+$/;

local $/;
open(my $fh, '<:raw', $datei) or die "$datei: $!\n";
my $inhalt = <$fh>; close $fh;

my $cr_vorher = () = $inhalt =~ /\Q${\ chr(13) }\E/g;

my @zeilen = split /(?<=\n)/, $inhalt;
die "$datei hat nur " . scalar(@zeilen) . " Zeilen\n" if $nr > @zeilen;

my $z = $zeilen[$nr-1];
my $i = index($z, $alt);
die "Zeile $nr enthaelt die gesuchte Zeichenkette nicht:\n  ist:    $z  gesucht: $alt\n"
  if $i < 0;
substr($z, $i, length($alt)) = $neu;
$zeilen[$nr-1] = $z;

my $neuinhalt = join('', @zeilen);
my $cr_nachher = () = $neuinhalt =~ /\Q${\ chr(13) }\E/g;
die "ABBRUCH: CR-Anzahl haette sich von $cr_vorher auf $cr_nachher geaendert\n"
  if $cr_vorher != $cr_nachher;

open(my $out, '>:raw', $datei) or die "$datei: $!\n";
print $out $neuinhalt; close $out;

$z =~ s/^\s+|\s+$//g;
print "ok $datei:$nr  (CR unveraendert: $cr_nachher)\n    $z\n";
