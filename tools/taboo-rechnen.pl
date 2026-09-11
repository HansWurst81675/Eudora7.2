#!/usr/bin/perl
use strict;
use warnings;

# taboo-rechnen.pl - was der Knopf "Blah Blah Blah" an einer ECHTEN Nachricht
# ausrichtet, ohne Eudora zu starten.
#
# Gregor am 11.09.2026, zwei Bildschirmfotos: die Schaltflaeche heisst laut
# Statuszeile "Shows/hides non-important headers", und im Nachrichtenfenster
# stehen trotzdem Authentication-Results und DKIM-Signature.
#
# Der Filter ist ein PRAEFIXVERGLEICH, nicht mehr:
#   strnicmp( Listeneintrag, Kopfzeile, Laenge(Listeneintrag) )
# (TridentReadMessageView.cpp:2444, gleichlautend ReadMessageDoc.cpp:499)
#
# Also laesst sich ohne Programm ausrechnen, welche Kopfzeile ueberlebt.

my $liste = $ENV{TABOO} ? do { open my $q, "<", $ENV{TABOO} or die; my $l = <$q>; chomp $l; $l } : "X-UID,Received,Status,X-UIDL,Message,In-Reply,X-Priority,Importance,Mime-Version,Content-,X-Persona,Resent-Message,References,Return,X400,X-400,Mail-System,Errors-To,X-List,Delivery,Disposition,X-Juno,Precedence,X-Attachments,X-MSMail,X-MimeOLE,X-Nav,X-Habeas";
my @taboo = split /,/, $liste;

my ($mbx) = @ARGV;
die "Aufruf: taboo-rechnen.pl <postfach.mbx>\n" unless $mbx && -f $mbx;

open my $h, '<:raw', $mbx or die "$mbx: $!\n";
my $t = do { local $/; <$h> };
close $h;

# Nachrichten trennen: Eudora benutzt "From ???@???" am Zeilenanfang.
my @n = split /^From \?\?\?\@\?\?\?/m, $t;
shift @n if @n && $n[0] !~ /:/;

printf "  %s: %d Nachricht(en)\n\n", $mbx, scalar @n;

my (%ueberlebt, %versteckt);
my $geprueft = 0;

for my $m (@n) {
    # Kopfteil endet an der ersten Leerzeile.
    my ($kopf) = $m =~ /\A(.*?)\r?\n\r?\n/s;
    next unless $kopf;
    $geprueft++;
    for my $z (split /\r?\n/, $kopf) {
        next if $z =~ /^[ \t]/;          # Fortsetzungszeile
        next unless $z =~ /^([A-Za-z0-9\-_]+):/;
        my $name = $1;
        my $tab = 0;
        for my $e (@taboo) {
            if (lc(substr($z, 0, length $e)) eq lc($e)) { $tab = 1; last; }
        }
        if ($tab) { $versteckt{$name}++ } else { $ueberlebt{$name}++ }
    }
}

printf "  %d Nachrichten mit Kopfteil ausgewertet\n\n", $geprueft;

print "  VERSTECKT der Knopf (steht auf der Liste von 2006):\n";
for my $k (sort { $versteckt{$b} <=> $versteckt{$a} || $a cmp $b } keys %versteckt) {
    printf "    %4dx  %s\n", $versteckt{$k}, $k;
}

print "\n  BLEIBT STEHEN, obwohl technisch (nicht auf der Liste):\n";
for my $k (sort { $ueberlebt{$b} <=> $ueberlebt{$a} || $a cmp $b } keys %ueberlebt) {
    printf "    %4dx  %s\n", $ueberlebt{$k}, $k;
}
exit 0;
