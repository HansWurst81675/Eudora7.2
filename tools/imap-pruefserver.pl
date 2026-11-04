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
# ZWEI KONTEN UND SERVERZUSTAND (seit 03.11.2026, Befund E-188):
#   --ablage-name <n>   das Postfach "Ablage" heisst <n> (etwa "Ziel"), damit
#                       ein zweiter Server auf anderem Port ein Zielpostfach
#                       mit eigenem Namen fuehrt - zwei Instanzen = zwei Konten.
#   --zustand           schreibt nach dem Start und nach jedem Befehl, der den
#                       Bestand aendert (APPEND, COPY, STORE, EXPUNGE), den
#                       ganzen Bestand: je Nachricht "ZUSTAND <postfach> uid=
#                       del= weg= rumpf= mid= betreff=", abgeschlossen von "ZUSTAND
#                       ENDE <n>". del=1: \Deleted gesetzt; weg=1: danach kam
#                       EXPUNGE in diesem Postfach - ein echter Server haette
#                       die Nachricht endgueltig entfernt. Gefuehrt je
#                       Postfach und nach UID (die alte Zaehlung oben kennt nur
#                       Positionen in INBOX). Der Pruefserver loescht nichts.
#   --bodystructure     beantwortet BODYSTRUCTURE wie ein echter Server (ein
#                       Teil text/plain) und BODY[TEXT]/BODY[1] mit dem Text
#                       allein, unter dem verlangten Abschnittsnamen. Ohne
#                       den Schalter kommt auf BODYSTRUCTURE die ganze
#                       Nachricht als BODY[] - Eudora laedt dann den Text nie
#                       nach (gemessen 03.11.2026, E-188: "Attempt to add the
#                       message ... failed", kein APPEND). Opt-in, damit die
#                       aelteren Faelle unveraendert messen.
#   --mehrteilig        die Pruefnachrichten sind multipart/alternative (ein
#                       Teil text/plain, ein Teil text/html), wie praktisch
#                       jede HTML-Mail; mit --bodystructure kommt die
#                       passende BODYSTRUCTURE, BODY[1]/BODY[2] liefern die
#                       Teile, BODY[n.MIME] ihre Koepfe (PRUEFER-94 K1: der
#                       verweigerte Rumpf bei mehrteiligen Mails war
#                       ungemessen).
#   --fetch-text-scheitert  jede Anfrage nach dem TEXT einer Nachricht (BODY[],
#                       BODY.PEEK[], [TEXT], [1], RFC822) bekommt NO - so wie
#                       ein Abbruch mitten im Herunterladen.
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
    elsif ($a eq '--fremde-bei-copy') { $opt{fremde_bei_copy} = shift @ARGV }   # E-170 ohne UIDPLUS
    elsif ($a eq '--copy-scheitert') { $opt{copy_scheitert} = 1 }   # E-170, PRUEFER-89 K3
    elsif ($a eq '--gleiche-im-ziel') { $opt{gleiche_im_ziel} = shift @ARGV }   # E-170, PRUEFER-89 K3
    elsif ($a eq '--ablage-name') { $opt{ablage_name} = shift @ARGV }   # E-188
    elsif ($a eq '--zustand') { $opt{zustand} = 1 }   # E-188
    elsif ($a eq '--bodystructure') { $opt{bodystructure} = 1 }   # E-188
    elsif ($a eq '--fetch-text-scheitert') { $opt{fetch_text_scheitert} = 1 }   # E-188
    elsif ($a eq '--mehrteilig') { $opt{mehrteilig} = 1 }   # E-188 K1
    else { die "unbekannt: $a\n" }
}
# E-170, PRUEFER-89 K3 (03.11.2026):
# --copy-scheitert   jedes COPY wird mit NO beantwortet, nichts wird kopiert.
#                    Zusammen mit --fremde-bei-copy gleich liegt danach eine
#                    gleich aussehende fremde Mail im Ziel - die Lage aus K1:
#                    Eudora darf ihr das Label der nicht kopierten nicht geben.
# --gleiche-im-ziel <n>  im Ziel "Ablage" liegt schon VOR dem Lauf eine Mail
#                    mit Datum, Absender und Betreff von INBOX-Nachricht <n>
#                    (Message-ID und Text anders) - Eudora darf dann nicht
#                    vormerken (schon-da=1) und keiner ein Label geben.
# E-170 ohne UIDPLUS: beim ersten COPY legt der Server VOR den Kopien eine
# fremde neue Nachricht ins Ziel - so, als waere sie gleichzeitig eingetroffen.
# Sie bekommt die kleinere neue UID. "anders": eigener Absender und Betreff;
# "gleich": Datum, Absender und Betreff wie die erste kopierte Nachricht, nur
# Message-ID und Text anders (Eudora darf dann KEINER ein Label geben).
if (defined $opt{fremde_bei_copy} and $opt{fremde_bei_copy} !~ /^(anders|gleich)$/) {
    die "--fremde-bei-copy anders|gleich\n";
}
my $fremde_bei_copy_gelegt = 0;

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
        ($opt{mehrteilig}
            ? ('Content-Type: multipart/alternative; boundary="pruefgrenze"',
               '',
               '--pruefgrenze',
               'Content-Type: text/plain; charset=us-ascii',
               '',
               "Dies ist Pruefnachricht $i. Sie existiert nur im Arbeitsspeicher",
               'dieses Servers und wird nie geloescht, egal was verlangt wird.',
               '--pruefgrenze',
               'Content-Type: text/html; charset=us-ascii',
               '',
               "<html><body><p>Dies ist Pruefnachricht $i (HTML-Teil).</p></body></html>",
               '--pruefgrenze--')
            : ('Content-Type: text/plain; charset=us-ascii',
               '',
               "Dies ist Pruefnachricht $i. Sie existiert nur im Arbeitsspeicher",
               'dieses Servers und wird nie geloescht, egal was verlangt wird.')),
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
my $ablage_name = defined $opt{ablage_name} ? $opt{ablage_name} : 'Ablage';   # E-188
die "--ablage-name: nur Buchstaben und Ziffern\n" unless $ablage_name =~ /^[A-Za-z0-9]+$/;
my @ordner = ('INBOX', 'Entw&APw-rfe', 'Gel&APY-scht', $ablage_name);

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
if ($opt{gleiche_im_ziel}) {
    my $n = $opt{gleiche_im_ziel};
    die "--gleiche-im-ziel $n: keine solche Nachricht\n" unless $n =~ /^\d+$/ and $n >= 1 and $n <= @nachrichten;
    (my $text = $nachrichten[$n - 1]{text}) =~ s/^Message-ID: .*$/Message-ID: <gleich-im-ziel\@pruefserver.invalid>/mi;
    $text =~ s/\r\n\r\n.*\z/\r\n\r\nLag schon vor dem Verschieben im Ziel und sieht aus wie Nachricht $n.\r\n/s;
    my $uid = 1;
    for my $m (@ablage) { $uid = $m->{uid} + 1 if defined $m->{uid} and $m->{uid} >= $uid }
    push @ablage, { text => $text, flags => '', geloescht_verlangt => 0, uid => $uid };
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
    return (lc $name eq lc $ablage_name) ? \@ablage : \@nachrichten;
}
# Steht das Postfach in der Ordnerliste? INBOX ohne Ruecksicht auf Gross/klein.
sub ordner_index {
    my ($name) = @_;
    for my $i (0 .. $#ordner) {
        return $i if $ordner[$i] eq $name or (uc $name eq 'INBOX' and uc $ordner[$i] eq 'INBOX');
    }
    return -1;
}
# E-188: Positionen (1-basiert) der Nachrichten in $liste, die eine IMAP-Menge
# ("3,2,1", "1:3", "2:*") trifft - nach UID oder nach Position.
sub menge_treffer {
    my ($liste, $menge, $nach_uid) = @_;
    my %pos;
    for my $teil (split /,/, $menge) {
        my ($von, $bis) = $teil =~ /^(\d+|\*)(?::(\d+|\*))?$/ or next;
        $bis = $von unless defined $bis;
        for my $i (1 .. @$liste) {
            my $s = $nach_uid ? uid_von($liste->[$i - 1], $i) : $i;
            my $lo = ($von eq '*') ? $s : $von;
            my $hi = ($bis eq '*') ? 4294967295 : $bis;
            ($lo, $hi) = ($hi, $lo) if $lo > $hi;
            $pos{$i} = 1 if $s >= $lo && $s <= $hi;
        }
    }
    return sort { $a <=> $b } keys %pos;
}
my $zustand_nr = 0;
sub zustand {
    return unless $opt{zustand};
    $zustand_nr++;
    for my $name ('INBOX', $ablage_name) {
        my $liste = liste_fuer($name);
        for my $i (1 .. @$liste) {
            my $m = $liste->[$i - 1];
            my ($mid) = $m->{text} =~ /^Message-ID:\s*(\S+)/mi;
            my ($betr) = $m->{text} =~ /^Subject:\s*(.*?)\r?$/mi;
            # rumpf = Bytes nach der Leerzeile: eine Kopie ohne Text faellt so auf.
            my ($rumpf) = $m->{text} =~ /\r?\n\r?\n(.*)\z/s;
            notiz(sprintf('ZUSTAND %s uid=%d del=%d weg=%d rumpf=%d mid=%s betreff=%s', $name, uid_von($m, $i),
                          $m->{del} ? 1 : 0, $m->{weg} ? 1 : 0, length(defined $rumpf ? $rumpf : ''), defined $mid ? $mid : '-',
                          sichtbar_bytes(defined $betr ? $betr : '-')));
        }
    }
    notiz("ZUSTAND ENDE $zustand_nr");
}
# Bytes ueber 127 sichtbar machen, damit das Protokoll ASCII bleibt.
sub sichtbar_bytes { my ($s) = @_; $s =~ s/([\x80-\xff])/sprintf('\\x%02X', ord $1)/ge; return $s }

zustand();   # E-188: Ausgangsbestand
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
        my $zustand_jetzt = 0;   # E-188

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
            $zustand_jetzt = 1;
            # E-121: wie ein Server ohne UIDPLUS (vermutlich GMX) - keine neue UID melden.
            $antwort = $opt{ohne_appenduid} ? "$marke OK APPEND completed" : "$marke OK [APPENDUID 1 $uid] APPEND completed";
        }
        elsif ($opt{fetch_text_scheitert} and ($B eq 'FETCH' or ($B eq 'UID' and $rest =~ /^FETCH/i))
               and $rest =~ /BODY(?:\.PEEK)?\[(?:TEXT|\d[^\]]*)?\]|RFC822(?![.]SIZE|[.]HEADER)/i) {
            # E-188: der Text kommt nicht - wie ein Abbruch beim Herunterladen.
            notiz('  !! FETCH TEXT ABGELEHNT (--fetch-text-scheitert)');
            $antwort = "$marke NO FETCH failed (Pruefstand)";
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
                my ($tkopf, $trumpf) = $m->{text} =~ /^(.*?\r\n\r\n)(.*)\z/s;
                $trumpf = '' unless defined $trumpf;
                # E-188 K1: Teile einer mehrteiligen Nachricht (Grenze "pruefgrenze").
                my @mteile;
                if ($trumpf =~ /--pruefgrenze\r\n/) {
                    for my $s (split /\r\n--pruefgrenze(?:--)?\r\n?/, "\r\n" . $trumpf) {
                        next unless $s =~ /^(.*?\r\n\r\n)(.*)\z/s;
                        push @mteile, { kopf => $1, rumpf => $2 };
                    }
                }
                if ($opt{bodystructure} and @mteile and $r =~ /BODYSTRUCTURE/i) {
                    my @bs;
                    for my $t (@mteile) {
                        my ($sub) = $t->{kopf} =~ m{Content-Type:\s*text/(\w+)}i; $sub = 'plain' unless defined $sub;
                        my $z = () = $t->{rumpf} =~ /\n/g;
                        push @bs, sprintf('("TEXT" "%s" ("CHARSET" "us-ascii") NIL NIL "7BIT" %d %d NIL NIL NIL)', uc $sub, length($t->{rumpf}), $z);
                    }
                    my @teile = ("UID $uid");
                    push @teile, "FLAGS ($flags)" if $r =~ /FLAGS/i;
                    push @teile, 'BODYSTRUCTURE (' . join('', @bs) . ' "ALTERNATIVE" ("BOUNDARY" "pruefgrenze") NIL NIL NIL)';
                    printf $h "* %d FETCH (%s)\r\n", $i, join(' ', @teile);
                }
                elsif ($opt{bodystructure} and @mteile and $r =~ /BODY(?:\.PEEK)?\[(\d+)(\.MIME)?\]/i) {
                    my ($nr, $mime) = ($1, $2);
                    my $t = $mteile[$nr - 1];
                    my $inhalt = $t ? ($mime ? $t->{kopf} : $t->{rumpf}) : '';
                    my $name = $nr . ($mime ? '.MIME' : '');
                    printf $h "* %d FETCH (UID %d FLAGS (%s) BODY[%s] {%d}\r\n%s)\r\n",
                        $i, $uid, $flags, $name, length($inhalt), $inhalt;
                }
                elsif ($opt{bodystructure} and $r =~ /BODYSTRUCTURE/i) {
                    # E-188: ein Teil text/plain, wie ein echter Server ihn meldet.
                    my ($cs) = $m->{text} =~ /charset="?([A-Za-z0-9_.-]+)/i; $cs = 'us-ascii' unless defined $cs;
                    my $zeilen = () = $trumpf =~ /\n/g;
                    my @teile = ("UID $uid");
                    push @teile, "FLAGS ($flags)" if $r =~ /FLAGS/i;
                    push @teile, sprintf('BODYSTRUCTURE ("TEXT" "PLAIN" ("CHARSET" "%s") NIL NIL "7BIT" %d %d NIL NIL NIL)', $cs, length($trumpf), $zeilen);
                    printf $h "* %d FETCH (%s)\r\n", $i, join(' ', @teile);
                }
                elsif ($opt{bodystructure} and $r =~ /BODY(?:\.PEEK)?\[(TEXT|1)\]/i) {
                    my $abschnitt = uc $1;
                    printf $h "* %d FETCH (UID %d FLAGS (%s) BODY[%s] {%d}\r\n%s)\r\n",
                        $i, $uid, $flags, $abschnitt, length($trumpf), $trumpf;
                }
                elsif ($r =~ /BODY\.PEEK\[HEADER|BODY\[HEADER|RFC822\.HEADER/i) {
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
                my @folge = sort { uid_von($quelle->[$a - 1], $a) <=> uid_von($quelle->[$b - 1], $b) } keys %gewaehlt_pos;
                if ($opt{fremde_bei_copy} and @folge and !$fremde_bei_copy_gelegt) {
                    my $vorlage = $quelle->[$folge[0] - 1]{text};
                    my $ftext;
                    if ($opt{fremde_bei_copy} eq 'gleich') {
                        ($ftext = $vorlage) =~ s/^Message-ID: .*$/Message-ID: <fremd-gleich\@pruefserver.invalid>/mi;
                        $ftext =~ s/\r\n\r\n.*\z/\r\n\r\nFremde Nachricht, die genau so aussieht wie die verschobene.\r\n/s;
                    }
                    else {
                        $ftext = join("\r\n",
                            'From: Fremd <fremd@pruefserver.invalid>',
                            'To: pruefling@pruefserver.invalid',
                            'Subject: Fremde neue Nachricht',
                            'Date: Thu, 10 Sep 2026 12:00:00 +0200',
                            'Message-ID: <fremd-neu@pruefserver.invalid>',
                            'MIME-Version: 1.0',
                            'Content-Type: text/plain; charset=us-ascii',
                            '',
                            'Diese Nachricht kam gleichzeitig mit der verschobenen an.',
                            '');
                    }
                    my $fuid = naechste_uid($zliste);
                    push @$zliste, { text => $ftext, flags => '', geloescht_verlangt => 0, uid => $fuid };
                    $fremde_bei_copy_gelegt = 1;
                    notiz(sprintf('  FREMDE NEUE NACHRICHT (%s) nach "%s": UID %d', $opt{fremde_bei_copy}, sichtbar_bytes($zname), $fuid));
                }
                if ($opt{copy_scheitert}) {
                    # PRUEFER-89 K3: Kopieren scheitert - nichts kopiert, NO.
                    notiz(sprintf('  !! COPY ABGELEHNT (--copy-scheitert) nach "%s": %d Nachricht(en) nicht kopiert',
                                  sichtbar_bytes($zname), scalar @folge));
                    @folge = ();
                }
                for my $i (@folge) {
                    my $m = $quelle->[$i - 1];
                    my $nuid = naechste_uid($zliste);
                    push @$zliste, { text => $m->{text}, flags => ($m->{flags} || ''), geloescht_verlangt => 0, uid => $nuid };
                    push @alt, uid_von($m, $i);
                    push @neu, $nuid;
                }
                $zustand_jetzt = 1;
                notiz(sprintf('  COPY nach "%s": UID %s -> %s', sichtbar_bytes($zname),
                              join(',', @alt) || '(keine)', join(',', @neu) || '(keine)'));
                if ($opt{copy_scheitert}) {
                    $antwort = "$marke NO COPY failed";
                }
                elsif (@alt and !$opt{ohne_copyuid}) {
                    # PRUEFER-78 K7: wie echte Server zusammenhaengende UIDs als Bereich
                    # melden ("1:3" statt "1,2,3"). Mit Listen mass die rote Gegenprobe
                    # zu E-184m nur den alten Leser, der keine Listen kannte - nicht die
                    # Zuordnung nach Listenposition, um die es ging.
                    my $bereiche = sub {
                        my @u = @_; my @aus;
                        while (@u) {
                            my $a = shift @u; my $b = $a;
                            while (@u && $u[0] == $b + 1) { $b = shift @u }
                            push @aus, ($a == $b ? $a : "$a:$b");
                        }
                        return join(',', @aus);
                    };
                    $antwort = sprintf('%s OK [COPYUID 1 %s %s] COPY completed', $marke, $bereiche->(@alt), $bereiche->(@neu));
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
            # E-188: \Deleted je Postfach und nach UID (bzw. Position) fuehren.
            if ($zeile =~ /\\Deleted/i) {
                my $r = ($B eq 'UID') ? do { my $x = $rest; $x =~ s/^STORE\s*//i; $x } : $rest;
                my ($menge, $art) = $r =~ /^(\S+)\s+([+-]?)FLAGS/i;
                if (defined $menge) {
                    my $liste = liste_fuer($gewaehlt{$h} || 'INBOX');
                    for my $i (menge_treffer($liste, $menge, $B eq 'UID')) { $liste->[$i - 1]{del} = ($art eq '-') ? 0 : 1 }
                }
            }
            $antwort = "$marke OK STORE";
            $zustand_jetzt = 1;
        }
        elsif ($B eq 'EXPUNGE' or ($B eq 'UID' and $rest =~ /^EXPUNGE/i)) {
            $expunge++;
            notiz('  !! EXPUNGE VERLANGT - hier wuerde endgueltig geloescht');
            for my $m (@{ liste_fuer($gewaehlt{$h} || 'INBOX') }) { $m->{weg} = 1 if $m->{del} }   # E-188
            $zustand_jetzt = 1;
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
        zustand() if $zustand_jetzt;
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
