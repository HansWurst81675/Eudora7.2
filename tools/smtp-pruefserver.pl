#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket::INET;

# smtp-pruefserver.pl - ein SMTP-Server, der jede Nachricht, die Eudora
# sendet, UNVERAENDERT als Datei ablegt und niemandem zustellt.
#
# WARUM ES DAS GIBT
#
# Befund E-179: Eudoras HTML-zu-Text-Umwandlung (Html2Text, html2text.cpp)
# laeuft fuer den Anwender sichtbar vor allem beim SENDEN - der Textteil
# einer HTML-Mail (multipart/alternative, sendmail.cpp SendStyled) entsteht
# dort. Ein IMAP-Pruefserver gab es seit Wochen, einen SMTP-Pruefserver
# nicht (tools/WERKZEUGE.md, 02.11.2026 nachgesehen). Ohne ihn war der Weg
# nur am Quelltext und am herausgezogenen Test (TestE179.cpp) belegt.
#
# AUFRUF
#
#   perl tools/smtp-pruefserver.pl --port 1025 --ablage <verzeichnis>
#                                  [--protokoll <datei>] [--zeitschranke 300]
#
# Er hoert NUR auf 127.0.0.1. Jede Nachricht landet als
# <ablage>/smtp-NNN.eml (Bytes zwischen DATA und dem Punkt, Punkt-Verdopplung
# zurueckgenommen). Er kennt HELO, EHLO (ohne Erweiterungen - also kein
# STARTTLS und kein AUTH), MAIL, RCPT, DATA, RSET, NOOP, QUIT. Alles andere
# bekommt 502 und eine Zeile im Protokoll.
#
# Kodierung: reines ASCII, kein BOM.

my %opt = (port => 1025, ablage => '', protokoll => '', zeitschranke => 300);
while (@ARGV) {
    my $a = shift @ARGV;
    if    ($a eq '--port')         { $opt{port}         = shift @ARGV }
    elsif ($a eq '--ablage')       { $opt{ablage}       = shift @ARGV }
    elsif ($a eq '--protokoll')    { $opt{protokoll}    = shift @ARGV }
    elsif ($a eq '--zeitschranke') { $opt{zeitschranke} = shift @ARGV }
    else  { die "unbekannt: $a\n" }
}
die "--ablage fehlt\n" unless $opt{ablage};
mkdir $opt{ablage} unless -d $opt{ablage};

my $log;
if ($opt{protokoll}) { open($log, '>>', $opt{protokoll}) or die "Protokoll: $!\n"; select((select($log), $| = 1)[0]); }
sub notiz {
    my ($t) = @_;
    my @z = localtime; my $s = sprintf('%02d:%02d:%02d  %s', $z[2], $z[1], $z[0], $t);
    print "$s\n"; print $log "$s\n" if $log;
}

my $srv = IO::Socket::INET->new(LocalAddr => '127.0.0.1', LocalPort => $opt{port}, Listen => 5, ReuseAddr => 1, Proto => 'tcp')
    or die "Port $opt{port}: $!\n";
notiz("SMTP-Pruefserver auf 127.0.0.1:$opt{port}, Ablage $opt{ablage}");
my $ende = time + $opt{zeitschranke};
$SIG{ALRM} = sub { notiz('Zeitschranke erreicht'); exit 0 };
alarm $opt{zeitschranke};

my $nr = 0;
while (time < $ende) {
    my $c = $srv->accept or next;
    binmode $c;
    notiz('Verbindung');
    print $c "220 smtp-pruefserver bereit\r\n";
    while (defined(my $z = <$c>)) {
        (my $sicht = $z) =~ s/\r?\n$//;
        notiz("<- $sicht");
        my ($b) = $sicht =~ /^(\S+)/; $b = uc($b // '');
        if    ($b eq 'HELO' or $b eq 'EHLO') { print $c "250 smtp-pruefserver\r\n" }
        elsif ($b eq 'MAIL' or $b eq 'RCPT' or $b eq 'RSET' or $b eq 'NOOP') { print $c "250 OK\r\n" }
        elsif ($b eq 'DATA') {
            print $c "354 Ende mit <CRLF>.<CRLF>\r\n";
            my $daten = '';
            while (defined(my $d = <$c>)) {
                last if $d =~ /^\.\r?\n$/;
                $d =~ s/^\.\././;
                $daten .= $d;
            }
            $nr++;
            my $datei = sprintf('%s/smtp-%03d.eml', $opt{ablage}, $nr);
            open(my $f, '>', $datei) or die "$datei: $!\n"; binmode $f; print $f $daten; close $f;
            notiz(sprintf('NACHRICHT %d: %d Byte -> %s', $nr, length($daten), $datei));
            print $c "250 OK angenommen als $nr\r\n";
        }
        elsif ($b eq 'QUIT') { print $c "221 Tschuess\r\n"; last }
        else  { notiz("  !! unbekannter Befehl"); print $c "502 nicht unterstuetzt\r\n" }
    }
    close $c;
    notiz('Verbindung zu');
}
