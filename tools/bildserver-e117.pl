# Mini-HTTP-Server fuer E-117: liefert gruen-330x327.png nur, wenn die Abfrage
# "&w=2" (echtes &) enthaelt; bei "&amp;w=2" ein 1x1-Pixel - wie der eBay-Dienst.
use strict; use warnings; use IO::Socket::INET;
my ($port, $bild, $pixel, $log) = @ARGV;
sub lies { open my $h, '<:raw', $_[0] or die $_[0]; local $/; my $x = <$h>; return $x }
my ($B, $P) = (lies($bild), lies($pixel));
my $s = IO::Socket::INET->new(LocalAddr => '127.0.0.1', LocalPort => $port, Listen => 5, ReuseAddr => 1) or die "Port: $!";
open my $L, '>>', $log or die; select((select($L), $| = 1)[0]);
while (my $c = $s->accept) {
  my $z = <$c> // ''; $z =~ s/\r?\n$//;
  while (my $k = <$c>) { last if $k =~ /^\r?\n$/ }
  my $gut = ($z =~ m{GET \S*\?a=1&w=2\b});
  my $d = $gut ? $B : $P;
  print $L ($gut ? "BILD  " : "PIXEL ") . "$z\n";
  print $c "HTTP/1.0 200 OK\r\nContent-Type: image/png\r\nContent-Length: " . length($d) . "\r\nConnection: close\r\n\r\n$d";
  close $c;
}
