#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket::INET;
use IO::Select;

# imap-pruefserver.pl - ein IMAP-Server, der nur mitschreibt, was Eudora
# von ihm will. Damit laesst sich pruefen, ob eine Filteraktion Post auf
# dem Server loeschen wuerde - OHNE ein echtes Postfach zu gefaehrden.
#
# WARUM ES DAS GIBT
#
# Am 10.09.2026 ist Gregors Post auf dem Server geloescht worden, waehrend
# er eine Fassung von mir testete. Danach hat PRUEFER zwei weitere Wege
# gefunden, auf denen eine Filteraktion loescht - einer davon ueber IMAP.
# Beide sind geschlossen, aber nur am Quelltext belegt.
#
# Gregors Antwort auf die Bitte, das zu testen, ist berechtigt:
#
#     "du verstehst sicherlich, dass ich es nur ungern bei mir teste,
#      seitdem meine mails alle weg sind?"
#
# Also wird es hier gemessen. Der Server haelt Testnachrichten im
# Arbeitsspeicher, beantwortet genug IMAP, dass Eudora ein Konto abrufen
# und filtern kann, und schreibt JEDEN Befehl mit. Loeschen tut er nichts -
# er merkt sich nur, ob es verlangt wurde.
#
# ENTSCHEIDEND IST DIE ZEILE
#
#     UID STORE <n> +FLAGS (\Deleted)     bzw.  STORE ... \Deleted
#
# Kommt sie nach einem Filterlauf, loescht die Filteraktion auf dem Server.
# Kommt sie nicht, greift die Sperre.
#
# AUFRUF
#
#   perl tools/imap-pruefserver.pl                 Port 1143, laeuft bis Strg-C
#   perl tools/imap-pruefserver.pl --port 1143
#   perl tools/imap-pruefserver.pl --protokoll <datei>
#   perl tools/imap-pruefserver.pl --nachrichten 5
#   perl tools/imap-pruefserver.pl --zeitschranke 300   Sekunden bis Feierabend
#
# Er hoert NUR auf 127.0.0.1. Von aussen ist er nicht erreichbar.
#
# WAS ER NICHT IST: eine vollstaendige IMAP-Umsetzung. Er kann genau so
# viel, wie Eudora zum Anmelden, Auflisten, Abrufen und Markieren braucht.
# Was er nicht kennt, beantwortet er mit OK und schreibt es ins Protokoll -
# so faellt beim Lesen auf, wo etwas fehlt.

my %opt = (
    port         => 1143,
    protokoll    => '',
    nachrichten  => 4,
    zeitschranke => 600,
);

while (@ARGV) {
    my $a = shift @ARGV;
    if    ($a eq '--port')         { $opt{port}         = shift @ARGV }
    elsif ($a eq '--protokoll')    { $opt{protokoll}    = shift @ARGV }
    elsif ($a eq '--nachrichten')  { $opt{nachrichten}  = shift @ARGV }
    elsif ($a eq '--zeitschranke') { $opt{zeitschranke} = shift @ARGV }
    else { die "unbekannt: $a\n" }
}

# --- Testnachrichten ------------------------------------------------------
#
# Die Absender sind so gewaehlt, dass sich Filter darauf bauen lassen:
# zwei von derselben Adresse, zwei verschiedene. Damit sieht man, ob nur
# die passenden angefasst werden.
my @absender = (
    'newsletter@pruefserver.invalid',
    'newsletter@pruefserver.invalid',
    'jemand.anderes@pruefserver.invalid',
    'dritte.adresse@pruefserver.invalid',
);

my @nachrichten;
for my $i (1 .. $opt{nachrichten}) {
    my $von = $absender[($i - 1) % @absender];
    my $text = join("\r\n",
        "From: Pruefserver <$von>",
        'To: pruefling@pruefserver.invalid',
        "Subject: Pruefnachricht $i von $von",
        'Date: Thu, 10 Sep 2026 12:00:00 +0200',
        "Message-ID: <pruef-$i\@pruefserver.invalid>",
        'MIME-Version: 1.0',
        'Content-Type: text/plain; charset=us-ascii',
        '',
        "Dies ist Pruefnachricht $i. Sie existiert nur im Arbeitsspeicher",
        'dieses Servers und wird nie geloescht, egal was verlangt wird.',
        '');
    push @nachrichten, { text => $text, flags => '', geloescht_verlangt => 0 };
}

# --- Protokoll ------------------------------------------------------------
my $pfad = $opt{protokoll};
unless ($pfad) {
    my $verz = $ENV{TEMP} || '/tmp';
    $verz =~ s{\\}{/}g;
    $pfad = "$verz/imap-pruefserver.log";
}

open my $prot, '>:raw', $pfad or die "$pfad: $!\n";
$prot->autoflush(1);

sub notiz {
    my ($was) = @_;
    my @t = localtime;
    my $z = sprintf("%02d:%02d:%02d", $t[2], $t[1], $t[0]);
    print       "$z  $was\n";
    print $prot "$z  $was\n";
}

# --- Server ---------------------------------------------------------------
my $server = IO::Socket::INET->new(
    LocalAddr => '127.0.0.1',
    LocalPort => $opt{port},
    Proto     => 'tcp',
    Listen    => 5,
    ReuseAddr => 1,
) or die "Port $opt{port} nicht zu bekommen: $!\n";

notiz("IMAP-Pruefserver auf 127.0.0.1:$opt{port}");
notiz(sprintf("%d Testnachrichten, Zeitschranke %d s", scalar @nachrichten, $opt{zeitschranke}));
notiz("Protokoll: $pfad");
notiz('-' x 62);

my $ende      = time + $opt{zeitschranke};
my $sel       = IO::Select->new($server);
my $loeschen  = 0;      # wie oft \Deleted verlangt wurde
my $expunge   = 0;
my %gesehen;            # Befehl -> Anzahl

while (time < $ende) {
    my @bereit = $sel->can_read(2);
    next unless @bereit;

    for my $h (@bereit) {
        if ($h == $server) {
            my $c = $server->accept or next;
            $c->autoflush(1);
            $sel->add($c);
            notiz('Verbindung von ' . $c->peerhost);
            print $c "* OK [CAPABILITY IMAP4rev1 LOGINDISABLED=0] Pruefserver bereit\r\n";
            next;
        }

        my $zeile = <$h>;
        unless (defined $zeile) {
            notiz('Verbindung beendet');
            $sel->remove($h);
            close $h;
            next;
        }

        $zeile =~ s/\r?\n$//;
        next if $zeile eq '';

        # Kennwoerter nicht mitschreiben.
        my $sichtbar = $zeile;
        $sichtbar =~ s/^(\S+\s+LOGIN\s+\S+\s+).*$/$1<Kennwort nicht protokolliert>/i;
        notiz("  <- $sichtbar");

        my ($marke, $befehl, $rest) = $zeile =~ /^(\S+)\s+(\S+)\s*(.*)$/;
        $marke  = '*' unless defined $marke;
        $befehl = ''  unless defined $befehl;
        $rest   = ''  unless defined $rest;
        my $B = uc $befehl;
        $gesehen{$B}++;

        my $antwort;

        if ($B eq 'CAPABILITY') {
            print $h "* CAPABILITY IMAP4rev1 UIDPLUS\r\n";
            $antwort = "$marke OK CAPABILITY";
        }
        elsif ($B eq 'LOGIN' or $B eq 'AUTHENTICATE') {
            $antwort = "$marke OK angemeldet";
        }
        elsif ($B eq 'LIST' or $B eq 'LSUB') {
            print $h "* $B (\\HasNoChildren) \"/\" \"INBOX\"\r\n";
            print $h "* $B (\\HasNoChildren) \"/\" \"Entw&APw-rfe\"\r\n";
            print $h "* $B (\\HasNoChildren) \"/\" \"Gel&APY-scht\"\r\n";
            $antwort = "$marke OK $B";
        }
        elsif ($B eq 'SELECT' or $B eq 'EXAMINE') {
            my $n = scalar @nachrichten;
            print $h "* $n EXISTS\r\n";
            print $h "* 0 RECENT\r\n";
            print $h "* OK [UIDVALIDITY 1] gueltig\r\n";
            print $h "* OK [UIDNEXT " . ($n + 1) . "] naechste\r\n";
            print $h "* FLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft)\r\n";
            print $h "* OK [PERMANENTFLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft)] erlaubt\r\n";
            $antwort = "$marke OK [READ-WRITE] $B";
        }
        elsif ($B eq 'FETCH' or ($B eq 'UID' and $rest =~ /^FETCH/i)) {
            my $r = ($B eq 'UID') ? do { my $x = $rest; $x =~ s/^FETCH\s*//i; $x } : $rest;
            my ($von, $bis) = $r =~ /^(\d+)(?::(\d+|\*))?/;
            $von = 1 unless defined $von;
            $bis = $von unless defined $bis;
            $bis = scalar @nachrichten if !defined $bis or $bis eq '*';
            $bis = scalar @nachrichten if $bis > @nachrichten;
            for my $i ($von .. $bis) {
                my $m = $nachrichten[$i - 1] or next;
                my $laenge = length $m->{text};
                my $flags = $m->{flags} || '';
                if ($r =~ /BODY\.PEEK\[HEADER|BODY\[HEADER|RFC822\.HEADER/i) {
                    my ($kopf) = $m->{text} =~ /^(.*?\r\n)\r\n/s;
                    $kopf = $m->{text} unless defined $kopf;
                    printf $h "* %d FETCH (UID %d FLAGS (%s) RFC822.SIZE %d BODY[HEADER] {%d}\r\n%s)\r\n",
                        $i, $i, $flags, $laenge, length($kopf), $kopf;
                }
                else {
                    printf $h "* %d FETCH (UID %d FLAGS (%s) RFC822.SIZE %d BODY[] {%d}\r\n%s)\r\n",
                        $i, $i, $flags, $laenge, $laenge, $m->{text};
                }
            }
            $antwort = "$marke OK FETCH";
        }
        elsif ($B eq 'STORE' or ($B eq 'UID' and $rest =~ /^STORE/i)) {
            # HIER ENTSCHEIDET SICH ALLES.
            if ($zeile =~ /\\Deleted/i) {
                $loeschen++;
                my ($num) = $rest =~ /(\d+)/;
                $num = '?' unless defined $num;
                notiz("  !! LOESCHEN VERLANGT: \\Deleted fuer Nachricht $num");
                my $m = ($num =~ /^\d+$/) ? $nachrichten[$num - 1] : undef;
                $m->{geloescht_verlangt} = 1 if $m;
            }
            $antwort = "$marke OK STORE";
        }
        elsif ($B eq 'EXPUNGE' or ($B eq 'UID' and $rest =~ /^EXPUNGE/i)) {
            $expunge++;
            notiz('  !! EXPUNGE VERLANGT - hier wuerde endgueltig geloescht');
            $antwort = "$marke OK EXPUNGE (der Pruefserver loescht nichts)";
        }
        elsif ($B eq 'CLOSE') { $antwort = "$marke OK CLOSE" }
        elsif ($B eq 'NOOP')  { $antwort = "$marke OK NOOP" }
        elsif ($B eq 'LOGOUT') {
            print $h "* BYE tschuess\r\n";
            $antwort = "$marke OK LOGOUT";
        }
        else {
            notiz("  ?? unbekannter Befehl '$B' - mit OK beantwortet");
            $antwort = "$marke OK $B";
        }

        print $h "$antwort\r\n";
        notiz("  -> $antwort");
    }
}

# --- Bilanz ----------------------------------------------------------------
notiz('-' x 62);
notiz('Zeitschranke erreicht. Bilanz:');
notiz(sprintf('  Befehle insgesamt      %d', eval { my $s = 0; $s += $_ for values %gesehen; $s } || 0));
for my $b (sort keys %gesehen) {
    notiz(sprintf('    %-14s %d', $b, $gesehen{$b}));
}
notiz(sprintf('  \\Deleted verlangt      %d', $loeschen));
notiz(sprintf('  EXPUNGE verlangt       %d', $expunge));
notiz('');

if ($loeschen == 0 && $expunge == 0) {
    notiz('  ERGEBNIS: nichts sollte geloescht werden.');
}
else {
    notiz('  ERGEBNIS: es WURDE Loeschen verlangt - siehe die !!-Zeilen.');
}

close $prot;
exit($loeschen || $expunge ? 1 : 0);
