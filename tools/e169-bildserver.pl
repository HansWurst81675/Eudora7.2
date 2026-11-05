#!/usr/bin/perl
# e169-bildserver.pl - kleinster HTTP-Server fuer den Pruefstand zu E-169:
# liefert Testdaten/e169-*.png auf 127.0.0.1:<port> aus und protokolliert
# jede Anfrage (Zeit, Pfad, User-Agent) nach STDOUT. So ist messbar, ob
# Lesefenster und Druckvorschau ein Bild vom Server holen.
#
#   perl tools/e169-bildserver.pl [port] [protokolldatei]   (Vorgabe 18169, STDOUT)
#
# Mit Protokolldatei schreibt der Server selbst dorthin. So kann ihn
# messen-e169.ps1 per Start-Process OHNE Umleitung starten - mit Umleitung
# erbt er die Pipe des Aufrufers, und testlauf.ps1 wartet ewig (gemessen
# 05.11.2026).
#
# Nur 127.0.0.1, nur Dateien e169-*.png aus Testdaten/, sonst 404.
use strict; use warnings;
use IO::Socket::INET;
use File::Basename qw(dirname);
$| = 1;
my $port = shift || 18169;
my $datei = shift;
if ($datei) { open STDOUT, '>>', $datei or die "E169 BILDSERVER: $datei: $!\n"; $| = 1; }
(my $hier = __FILE__) =~ s{\\}{/}g;          # Git-Perl: dirname versteht keine Rueckstriche
my $daten = dirname($hier) . '/../Testdaten';
my $s = IO::Socket::INET->new(LocalAddr => '127.0.0.1', LocalPort => $port, Listen => 5, ReuseAddr => 1)
    or die "E169 BILDSERVER: Port $port: $!\n";
print "E169 BILDSERVER bereit 127.0.0.1:$port\n";
while (my $c = $s->accept) {
    my $kopf = '';
    while (my $z = <$c>) { $kopf .= $z; last if $z =~ /^\r?\n$/; }
    my ($pfad) = $kopf =~ m{^GET\s+(\S+)};
    my ($ua) = $kopf =~ m{^User-Agent:\s*([^\r\n]*)}mi;
    $pfad //= '?'; $ua //= '-';
    my @t = localtime; my $zeit = sprintf '%02d:%02d:%02d', @t[2,1,0];
    if ($pfad =~ m{^/(e169-[a-z0-9-]+\.png)$} && -f "$daten/$1") {
        open my $f, '<:raw', "$daten/$1" or die; local $/; my $b = <$f>; close $f;
        print $c "HTTP/1.0 200 OK\r\nContent-Type: image/png\r\nContent-Length: " . length($b) . "\r\nCache-Control: no-cache\r\n\r\n" . $b;
        print "E169 BILDSERVER $zeit 200 $pfad ua=$ua\n";
    } else {
        print $c "HTTP/1.0 404 Not Found\r\nContent-Length: 0\r\n\r\n";
        print "E169 BILDSERVER $zeit 404 $pfad ua=$ua\n";
    }
    close $c;
}
