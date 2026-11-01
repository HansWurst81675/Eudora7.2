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
#   perl tools/imap-pruefserver.pl --gruss-verzoegerung 8   erste Verbindung wartet (E-121)
#   perl tools/imap-pruefserver.pl --ablage <verzeichnis>
#
# APPEND (seit 14.10.2026, Befund E-118): nimmt "tag APPEND <postfach>
# [(flags)] ["datum"] {n}" und {n+} (LITERAL+) an, liest genau n Bytes und
# legt sie UNVERAENDERT als <verzeichnis>/append-NNN.eml ab (ohne --ablage:
# nur mitgeschrieben). Damit laesst sich der Kopf messen, den Eudora einer
# Nachricht beim Hochladen in einen IMAP-Ordner gibt. LIST/LSUB nennen dazu
# das Postfach "Ablage"; SELECT/STATUS darauf zaehlen die hochgeladenen
# Nachrichten, FETCH liefert sie.
#
# RENAME (seit 24.10.2026, Befund E-77, PRUEFER-49 K1): "tag RENAME alt neu"
# benennt in der Ordnerliste um, die LIST/LSUB danach melden. SELECT, EXAMINE
# und STATUS auf einen Namen, der nicht in der Liste steht, bekommen NO und
# eine Zeile "!! UNBEKANNTES POSTFACH" - so wird sichtbar, wenn Eudora nach
# dem Umbenennen einen anderen Namen benutzt als den, den es geschickt hat.
# Mit --rename-ablehnen (seit 26.10.2026, Befund E-146) antwortet RENAME mit
# NO und laesst die Liste, wie sie war.
#
# COPY / UID COPY (seit 01.11.2026, Befund E-184): kopiert die gewaehlten
# Nachrichten in das Zielpostfach, vergibt dort neue UIDs und antwortet wie
# ein Server mit UIDPLUS "OK [COPYUID 1 <alte> <neue>]" (RFC 4315). So
# verschiebt Eudora innerhalb eines Kontos (COPY, \Deleted, EXPUNGE); das
# Loeschen in der Quelle wird wie immer nur mitgeschrieben. Mit
# --ohne-copyuid fehlt die Angabe, wie bei einem Server ohne UIDPLUS (E-170).
# Zusammen mit --fremde-uid <n> liegt im Ziel "Ablage" schon eine fremde
# Nachricht mit der UID, die die verschobene in INBOX traegt.
#
# EXISTS (seit 01.11.2026, E-184): aendert sich die Nachrichtenzahl im
# gewaehlten Postfach einer Verbindung (etwa durch ein COPY ueber eine andere),
# meldet er vor der naechsten Antwort unaufgefordert "* n EXISTS", wie ein
# echter Server (RFC 3501 7.3.1). Ohne das glich Eudora nur bis zur alten
# Zahl ab und sah eine neue UID nie.
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
    ablage       => '',
    gruss_verzoegerung => 0,
    append_ablehnen => 0,
    ohne_appenduid => 0,
    fremde_uid   => 0,
    append_verzoegerung => 0,
    ohne_copyuid => 0,
);

while (@ARGV) {
    my $a = shift @ARGV;
    if    ($a eq '--port')         { $opt{port}         = shift @ARGV }
    elsif ($a eq '--protokoll')    { $opt{protokoll}    = shift @ARGV }
    elsif ($a eq '--nachrichten')  { $opt{nachrichten}  = shift @ARGV }
    elsif ($a eq '--zeitschranke') { $opt{zeitschranke} = shift @ARGV }
    elsif ($a eq '--gruss-verzoegerung') { $opt{gruss_verzoegerung} = shift @ARGV }
    elsif ($a eq '--append-ablehnen') { $opt{append_ablehnen} = 1 }
    elsif ($a eq q{--rename-ablehnen}) { $opt{rename_ablehnen} = 1 }   # E-146 (PRUEFER-50 K9)
    elsif ($a eq '--ohne-appenduid') { $opt{ohne_appenduid} = 1 }
    elsif ($a eq '--fremde-uid')  { $opt{fremde_uid}   = shift @ARGV }
    elsif ($a eq '--append-verzoegerung') { $opt{append_verzoegerung} = shift @ARGV }
    elsif ($a eq '--ablage')       { $opt{ablage}       = shift @ARGV }
    elsif ($a eq '--ohne-copyuid') { $opt{ohne_copyuid} = 1 }   # E-184/E-170
    elsif ($a eq '--datum-absteigend') { $opt{datum_absteigend} = 1 }   # E-184 K3
    else { die "unbekannt: $a\n" }
}

if ($opt{ablage} ne '' and !-d $opt{ablage}) {
    mkdir $opt{ablage} or die "$opt{ablage}: $!\n";
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
        # E-184 K3: mit --datum-absteigend ist UID 1 die juengste Nachricht -
        # nach Datum sortiert steht die Liste dann absteigend nach UID (3,2,1).
        ($opt{datum_absteigend}
            ? sprintf('Date: Thu, 10 Sep 2026 %02d:00:00 +0200', 20 - $i)
            : 'Date: Thu, 10 Sep 2026 12:00:00 +0200'),
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
my @ablage;             # per APPEND hochgeladene Nachrichten (Postfach "Ablage")
my %gewaehlt;           # Verbindung -> gewaehltes Postfach
my %bekannt;            # Verbindung -> Nachrichtenzahl, die sie zuletzt gemeldet bekam (E-184)
my $append_nr = 0;      # laufende Nummer der Ablagedateien
my $unbekannt = 0;      # Zugriffe auf ein Postfach, das es nicht gibt
# Ordnerliste, wie der Server sie fuehrt (modifiziertes UTF-7, RFC 3501 5.1.3).
my @ordner = ('INBOX', 'Entw&APw-rfe', 'Gel&APY-scht', 'Ablage');

# E-121 (Gregor an 1.0.95): im Ordner "Ablage" liegt schon eine FREMDE Nachricht,
# deren UID gleich der lokalen Kennung der zu verschiebenden Mail ist (bei Gregor
# 13). Eudora darf sie nicht fuer die eigene Vorab-Kopie halten.
if ($opt{fremde_uid}) {
    my $text = join("\r\n",
        'From: Fremd <fremd@pruefserver.invalid>',
        'To: pruefling@pruefserver.invalid',
        "Subject: Fremde Nachricht mit UID $opt{fremde_uid}",
        'Date: Thu, 10 Sep 2026 12:00:00 +0200',
        'Message-ID: <fremd-uid@pruefserver.invalid>',
        'MIME-Version: 1.0',
        'Content-Type: text/plain; charset=us-ascii',
        '',
        'Diese Nachricht lag schon vor dem Verschieben auf dem Server.',
        '');
    push @ablage, { text => $text, flags => '', geloescht_verlangt => 0, uid => $opt{fremde_uid} };
}

# UID einer Nachricht: gespeichert oder ihre Position.
sub uid_von { my ($m, $i) = @_; return defined $m->{uid} ? $m->{uid} : $i }
sub naechste_uid {
    my ($liste) = @_;
    my $max = 0;
    for my $i (1 .. @$liste) { my $u = uid_von($liste->[$i - 1], $i); $max = $u if $u > $max }
    return $max + 1;
}

# Postfachname aus "..." oder Atom; liefert die Liste dazu.
sub postfach_name {
    my ($s) = @_;
    return $1 if $s =~ /^"((?:[^"\\]|\\.)*)"/;
    return $1 if $s =~ /^(\S+)/;
    return '';
}
sub liste_fuer {
    my ($name) = @_;
    return ($name =~ /^Ablage$/i) ? \@ablage : \@nachrichten;
}
# Steht das Postfach in der Ordnerliste? INBOX ohne Ruecksicht auf Gross/klein.
sub ordner_index {
    my ($name) = @_;
    for my $i (0 .. $#ordner) {
        return $i if $ordner[$i] eq $name or (uc $name eq 'INBOX' and uc $ordner[$i] eq 'INBOX');
    }
    return -1;
}
# Bytes ueber 127 sichtbar machen, damit das Protokoll ASCII bleibt.
sub sichtbar_bytes { my ($s) = @_; $s =~ s/([\x80-\xff])/sprintf('\\x%02X', ord $1)/ge; return $s }

while (time < $ende) {
    my @bereit = $sel->can_read(2);
    next unless @bereit;

    for my $h (@bereit) {
        if ($h == $server) {
            my $c = $server->accept or next;
            $c->autoflush(1);
            binmode $c;
            $gewaehlt{$c} = 'INBOX';
            $sel->add($c);
            notiz('Verbindung von ' . $c->peerhost);
            # E-121: die ERSTE Verbindung wartet auf Wunsch einige Sekunden auf die
            # Begruessung. So holt das POP-Konto seine Post und der Filter uebertraegt,
            # bevor das IMAP-Konto verbunden ist - der Fall, in dem Eudora den
            # Zielordner erst mitten in der Uebertragung oeffnet.
            if ($opt{gruss_verzoegerung} > 0) {
                notiz("Begruessung verzoegert um $opt{gruss_verzoegerung} s");
                sleep $opt{gruss_verzoegerung};
                $opt{gruss_verzoegerung} = 0;
            }
            print $c "* OK [CAPABILITY IMAP4rev1 LOGINDISABLED=0] Pruefserver bereit\r\n";
            next;
        }

        my $zeile = <$h>;
        unless (defined $zeile) {
            notiz('Verbindung beendet');
            delete $gewaehlt{$h};
            $sel->remove($h);
            close $h;
            next;
        }

        $zeile =~ s/\r?\n$//;
        next if $zeile eq '';

        # Kennwoerter nicht mitschreiben.
        my $sichtbar = $zeile;
        $sichtbar =~ s/^(\S+\s+LOGIN\s+\S+\s+).*$/$1<Kennwort nicht protokolliert>/i;
        notiz("  <- " . sichtbar_bytes($sichtbar));

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
            # Seit 26.10.2026 (E-146) mit Suchmuster nach RFC 3501 6.3.8:
            # "%" passt auf alles ausser dem Trenner "/", "*" auf alles.
            # Vorher kam auf JEDES Muster die ganze Liste - auf
            # LIST "" Ablage/% meldete der Server "Ablage" als eigenes Kind,
            # und Eudora stieg beim Neueinlesen der Ordnerliste endlos hinab
            # (1556 LIST in zwei Sekunden). Ein echter Server tut das nicht.
            # LIST "" "" fragt nur nach dem Trenner.
            my $bezug = postfach_name($rest);
            my $danach = $rest;
            $danach =~ s/^(?:"(?:[^"\\]|\\.)*"|\S+)\s*//;
            my $muster = $bezug . postfach_name($danach);
            if ($muster eq '') {
                print $h "* $B (\\Noselect) \"/\" \"\"\r\n";
            }
            else {
                my $re = join '', map { $_ eq '%' ? '[^/]*' : $_ eq '*' ? '.*' : quotemeta $_ } split //, $muster;
                for (@ordner) {
                    next unless /^$re$/ or (uc $_ eq 'INBOX' and uc $muster eq 'INBOX');
                    print $h "* $B (\\HasNoChildren) \"/\" \"$_\"\r\n";
                }
            }
            $antwort = "$marke OK $B";
        }
        elsif (($B eq q{RENAME} or $B eq q{SELECT} or $B eq q{EXAMINE} or $B eq q{STATUS} or $B eq q{CREATE})
               and $rest =~ /[\x80-\xff]/) {
            # RFC 3501 5.1.3: Postfachnamen sind 7 Bit. Ein echter Server lehnt
            # rohe Umlaute ab - so tat es Eudora vor E-77 beim Umbenennen.
            $unbekannt++;
            notiz("  !! 8-BIT IM POSTFACHNAMEN bei $B: " . sichtbar_bytes($rest));
            $antwort = "$marke BAD $B: Postfachname nicht 7 Bit (RFC 3501 5.1.3)";
        }
        elsif ($B eq 'RENAME') {
            my $alt = postfach_name($rest);
            my $danach = $rest;
            $danach =~ s/^(?:"(?:[^"\\]|\\.)*"|\S+)\s*//;
            my $neu = postfach_name($danach);
            my $i = ordner_index($alt);
            if ($opt{rename_ablehnen} and $i >= 0) {
                # E-146: der Server lehnt ab, die Liste bleibt, wie sie war.
                notiz(q{  RENAME ABGELEHNT (--rename-ablehnen): "} . sichtbar_bytes($alt) . q{" -> "} . sichtbar_bytes($neu) . q{"});
                $antwort = "$marke NO RENAME: abgelehnt (Pruefstand)";
            }
            elsif ($i < 0) {
                $unbekannt++;
                notiz('  !! UNBEKANNTES POSTFACH bei RENAME: "' . sichtbar_bytes($alt) . '"');
                $antwort = "$marke NO [NONEXISTENT] RENAME: kein Postfach";
            }
            else {
                $ordner[$i] = $neu;
                notiz('  RENAME: "' . sichtbar_bytes($alt) . '" -> "' . sichtbar_bytes($neu) . '"');
                $antwort = "$marke OK RENAME";
            }
        }
        elsif (($B eq 'SELECT' or $B eq 'EXAMINE' or $B eq 'STATUS')
               and ordner_index(postfach_name($rest)) < 0) {
            $unbekannt++;
            notiz("  !! UNBEKANNTES POSTFACH bei $B: \"" . sichtbar_bytes(postfach_name($rest)) . '"');
            $antwort = "$marke NO [NONEXISTENT] $B: kein Postfach";
        }
        elsif ($B eq 'SELECT' or $B eq 'EXAMINE') {
            $gewaehlt{$h} = postfach_name($rest);
            my $n = scalar @{ liste_fuer($gewaehlt{$h}) };
            print $h "* $n EXISTS\r\n";
            print $h "* 0 RECENT\r\n";
            print $h "* OK [UIDVALIDITY 1] gueltig\r\n";
            print $h "* OK [UIDNEXT " . naechste_uid(liste_fuer($gewaehlt{$h})) . "] naechste\r\n";
            print $h "* FLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft)\r\n";
            print $h "* OK [PERMANENTFLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft)] erlaubt\r\n";
            $antwort = "$marke OK [READ-WRITE] $B";
        }
        elsif ($B eq 'STATUS') {
            my $name = postfach_name($rest);
            my $n = scalar @{ liste_fuer($name) };
            printf $h "* STATUS \"%s\" (MESSAGES %d RECENT 0 UIDNEXT %d UIDVALIDITY 1 UNSEEN 0)\r\n",
                $name, $n, naechste_uid(liste_fuer($name));
            $antwort = "$marke OK STATUS";
        }
        elsif ($B eq 'APPEND') {
            # tag APPEND <postfach> [(flags)] ["datum"] {n} bzw. {n+}
            my $name = postfach_name($rest);
            my ($n, $plus) = $zeile =~ /\{(\d+)(\+?)\}$/;
            unless (defined $n) {
                $antwort = "$marke BAD APPEND ohne Literal";
                print $h "$antwort\r\n";
                notiz("  -> $antwort");
                next;
            }
            unless ($plus) {
                print $h "+ Ready for literal data\r\n";
                notiz('  -> + Ready for literal data');
            }
            my $daten = '';
            while (length($daten) < $n) {
                my $r = read($h, my $stueck, $n - length($daten));
                last unless $r;
                $daten .= $stueck;
            }
            # Zeilenende nach dem Literal (CRLF oder LF)
            my $nach = <$h>;
            $nach = '' unless defined $nach;
            $nach =~ s/\r?\n$//;
            notiz("  !! Rest nach Literal: '$nach'") if $nach ne '';
            if (length($daten) != $n) {
                notiz(sprintf('  !! Literal unvollstaendig: %d von %d Bytes', length($daten), $n));
            }
            # E-123: die Antwort auf das Hochladen verzoegern - laeuft die Uebertragung
            # noch, wenn Eudora beendet wird, muss das Beenden warten.
            if ($opt{append_verzoegerung} > 0) {
                notiz("  APPEND: Antwort verzoegert um $opt{append_verzoegerung} s");
                sleep $opt{append_verzoegerung};
            }
            # E-121: das Hochladen ablehnen - darf die Nachricht beim Absender bleiben?
            if ($opt{append_ablehnen}) {
                $antwort = "$marke NO [TRYCREATE] APPEND abgelehnt (Pruefserver, --append-ablehnen)";
                print $h "$antwort\r\n";
                notiz("  -> $antwort");
                next;
            }
            my $uid = naechste_uid(\@ablage);
            push @ablage, { text => $daten, flags => '', geloescht_verlangt => 0, uid => $uid };
            $append_nr++;
            my $wohin = '(nicht abgelegt, kein --ablage)';
            if ($opt{ablage} ne '') {
                $wohin = sprintf('%s/append-%03d.eml', $opt{ablage}, $append_nr);
                open my $af, '>:raw', $wohin or die "$wohin: $!\n";
                print $af $daten;
                close $af;
            }
            notiz(sprintf('  APPEND nach "%s": %d Bytes -> %s', $name, length($daten), $wohin));
            # E-121: wie ein Server ohne UIDPLUS (vermutlich GMX) - keine neue UID melden.
            $antwort = $opt{ohne_appenduid} ? "$marke OK APPEND completed" : "$marke OK [APPENDUID 1 $uid] APPEND completed";
        }
        elsif ($B eq 'FETCH' or ($B eq 'UID' and $rest =~ /^FETCH/i)) {
            my $liste = liste_fuer($gewaehlt{$h} || 'INBOX');
            my $r = ($B eq 'UID') ? do { my $x = $rest; $x =~ s/^FETCH\s*//i; $x } : $rest;
            my ($von, $bis) = $r =~ /^(\d+)(?::(\d+|\*))?/;
            $von = 1 unless defined $von;
            $bis = $von unless defined $bis;
            my @nummern;
            if ($B eq 'UID') {
                # UID FETCH: nach UID auswaehlen, nicht nach Position (E-121 --fremde-uid).
                my $obere = ($bis eq '*') ? 4294967295 : $bis;
                for my $i (1 .. @$liste) {
                    my $u = uid_von($liste->[$i - 1], $i);
                    push @nummern, $i if ($u >= $von && $u <= $obere) || ($bis eq '*' && $i == @$liste);
                }
            }
            else {
                $bis = scalar @$liste if $bis eq '*';
                $bis = scalar @$liste if $bis > @$liste;
                @nummern = ($von .. $bis);
            }
            for my $i (@nummern) {
                my $m = $liste->[$i - 1] or next;
                my $uid = uid_von($m, $i);
                my $laenge = length $m->{text};
                my $flags = $m->{flags} || '';
                if ($r =~ /BODY\.PEEK\[HEADER|BODY\[HEADER|RFC822\.HEADER/i) {
                    # Mit der Leerzeile, die den Kopf abschliesst (RFC 3501 6.4.5:
                    # HEADER und HEADER.FIELDS enden mit ihr). Ohne sie las Eudora von
                    # drei Koepfen nur den ersten (gemessen 01.11.2026, E-184 K3).
                    my ($kopf) = $m->{text} =~ /^(.*?\r\n\r\n)/s;
                    $kopf = $m->{text} unless defined $kopf;
                    # E-184 K3: den Abschnitt so zuruecknennen, wie er verlangt wurde
                    # (RFC 3501 7.4.2: "BODY[HEADER.FIELDS (...)]", ohne ".PEEK"). Mit
                    # "BODY[HEADER]" auf eine HEADER.FIELDS-Frage fuehrte Eudora bei drei
                    # Nachrichten nur eine (gemessen 01.11.2026); bei einer fiel es nie auf.
                    my ($abschnitt) = $r =~ /BODY(?:\.PEEK)?\[(HEADER[^\]]*)\]/i;
                    $abschnitt = 'HEADER' unless defined $abschnitt;
                    printf $h "* %d FETCH (UID %d FLAGS (%s) RFC822.SIZE %d BODY[%s] {%d}\r\n%s)\r\n",
                        $i, $uid, $flags, $laenge, $abschnitt, length($kopf), $kopf;
                }
                elsif ($r !~ /BODY|RFC822(?!\.SIZE)|ENVELOPE/i) {
                    # E-184 K3: nur FLAGS/UID/RFC822.SIZE verlangt - nur das liefern,
                    # wie ein echter Server. Vorher kam jedes Mal die ganze Nachricht
                    # mit; bei einer Nachricht nahm Eudora das hin, bei drei nicht.
                    my @teile = ("UID $uid");
                    push @teile, "FLAGS ($flags)" if $r =~ /FLAGS/i;
                    push @teile, "RFC822.SIZE $laenge" if $r =~ /RFC822\.SIZE/i;
                    printf $h "* %d FETCH (%s)\r\n", $i, join(' ', @teile);
                }
                else {
                    printf $h "* %d FETCH (UID %d FLAGS (%s) RFC822.SIZE %d BODY[] {%d}\r\n%s)\r\n",
                        $i, $uid, $flags, $laenge, $laenge, $m->{text};
                }
            }
            $antwort = "$marke OK FETCH";
        }
        elsif ($B eq 'COPY' or ($B eq 'UID' and $rest =~ /^COPY/i)) {
            # E-184: Kopie ins Zielpostfach mit neuer UID, Antwort mit COPYUID.
            my $quelle = liste_fuer($gewaehlt{$h} || 'INBOX');
            my $r = ($B eq 'UID') ? do { my $x = $rest; $x =~ s/^COPY\s*//i; $x } : $rest;
            my ($menge, $zielteil) = $r =~ /^(\S+)\s+(.+)$/;
            my $zname = defined $zielteil ? postfach_name($zielteil) : '';
            if (!defined $menge or ordner_index($zname) < 0) {
                $unbekannt++ if defined $menge;
                notiz('  !! COPY in unbekanntes Postfach: "' . sichtbar_bytes($zname) . '"');
                $antwort = "$marke NO [TRYCREATE] COPY: kein Postfach";
            }
            else {
                my $zliste = liste_fuer($zname);
                my (@alt, @neu, %gewaehlt_pos);
                for my $teil (split /,/, $menge) {
                    my ($von, $bis) = $teil =~ /^(\d+|\*)(?::(\d+|\*))?$/ or next;
                    $bis = $von unless defined $bis;
                    for my $i (1 .. @$quelle) {
                        my $m = $quelle->[$i - 1];
                        my $schluessel = ($B eq 'UID') ? uid_von($m, $i) : $i;
                        my $lo = ($von eq '*') ? $schluessel : $von;
                        my $hi = ($bis eq '*') ? 4294967295 : $bis;
                        ($lo, $hi) = ($hi, $lo) if $lo > $hi;
                        $gewaehlt_pos{$i} = 1 if $schluessel >= $lo && $schluessel <= $hi;
                    }
                }
                # E-184 K3: wie echte Server (etwa Dovecot) in aufsteigender UID-Folge
                # kopieren und so melden - unabhaengig von der Reihenfolge der Anfrage.
                # Eudora schickt die Reihenfolge der Ansicht ("UID COPY 3,2,1"); ein
                # Pruefserver, der in Anfragefolge kopiert, liesse die fehlerhafte
                # Zuordnung nach Listenposition zufaellig richtig aussehen
                # (gemessen 01.11.2026).
                for my $i (sort { uid_von($quelle->[$a - 1], $a) <=> uid_von($quelle->[$b - 1], $b) } keys %gewaehlt_pos) {
                    my $m = $quelle->[$i - 1];
                    my $nuid = naechste_uid($zliste);
                    push @$zliste, { text => $m->{text}, flags => ($m->{flags} || ''), geloescht_verlangt => 0, uid => $nuid };
                    push @alt, uid_von($m, $i);
                    push @neu, $nuid;
                }
                notiz(sprintf('  COPY nach "%s": UID %s -> %s', sichtbar_bytes($zname),
                              join(',', @alt) || '(keine)', join(',', @neu) || '(keine)'));
                if (@alt and !$opt{ohne_copyuid}) {
                    $antwort = sprintf('%s OK [COPYUID 1 %s %s] COPY completed', $marke, join(',', @alt), join(',', @neu));
                }
                else {
                    $antwort = "$marke OK COPY completed";
                }
            }
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

        # E-184: wie ein echter Server (RFC 3501 7.3.1) eine geaenderte
        # Nachrichtenzahl im gewaehlten Postfach unaufgefordert melden - etwa
        # nachdem ein COPY von einer anderen Verbindung dort etwas abgelegt hat.
        # Ohne das gleicht Eudora den Zielordner nur bis zur alten Zahl ab und
        # erfaehrt nie von der neuen UID.
        if (defined $gewaehlt{$h}) {
            my $n = scalar @{ liste_fuer($gewaehlt{$h}) };
            if ($B ne 'SELECT' and $B ne 'EXAMINE' and defined $bekannt{$h} and $n != $bekannt{$h}) {
                print $h "* $n EXISTS\r\n";
                notiz("  -> * $n EXISTS (neu seit der letzten Meldung)");
            }
            $bekannt{$h} = $n;
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
notiz(sprintf('  unbekannte Postfaecher %d', $unbekannt));
notiz('  Ordner am Ende: ' . join(', ', map { sichtbar_bytes($_) } @ordner));
notiz('');

if ($loeschen == 0 && $expunge == 0) {
    notiz('  ERGEBNIS: nichts sollte geloescht werden.');
}
else {
    notiz('  ERGEBNIS: es WURDE Loeschen verlangt - siehe die !!-Zeilen.');
}

close $prot;
exit($loeschen || $expunge ? 1 : 0);
