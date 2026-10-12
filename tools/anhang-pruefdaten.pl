use strict; use warnings;
#
# Pruefdaten fuer Befund AN-1: E-Mails mit Anhang, deren Dateiname im Kopf
# GEFALTET ist - genau der Fall, an dem Eudora die Endung verliert.
#
#   perl tools/anhang-pruefdaten.pl              # zeigt die Faelle
#   perl tools/anhang-pruefdaten.pl --erzeugen   # schreibt die .eml-Dateien
#   perl tools/anhang-pruefdaten.pl --pop        # POP3-Server auf 127.0.0.1:11110
#   perl tools/anhang-pruefdaten.pl --pop 11000  # ... auf einem anderen Port
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Gregor hat den Fehler im Betrieb gesehen, kann aber keine Beispielnachricht
# liefern. Auf eine zu warten hiesse, den Fehler liegen zu lassen. Also werden
# die Faelle hier erzeugt - aus dem, was in BEFUNDE.md AN-1 gemessen ist.
#
# WARUM EIN POP3-SERVER UND NICHT NUR DATEIEN
#
# Der Fehler sitzt im EMPFANGSweg (CPOP::WriteMessageToMBX_ -> HeaderDesc::Read
# -> Lex822). Eine .eml in eine .mbx zu kopieren reicht NICHT: dann laeuft der
# Empfangsweg gar nicht, und der Anhang wird nie geschrieben. Die Nachricht muss
# wirklich abgerufen werden. Dieser Server tut nichts anderes, als sie
# auszuliefern - kein Netz, keine Zugangsdaten, alles auf 127.0.0.1.
#
# SO WIRD GEPRUEFT (auf dem Windows-Rechner mit Eudora)
#
#   1. perl tools/anhang-pruefdaten.pl --pop
#   2. In Eudora ein Konto anlegen:
#        Server   127.0.0.1
#        Port     11110        (Extras > Optionen > Ports, oder 127.0.0.1:11110)
#        Benutzer pruef        Kennwort beliebig
#        SSL      AUS
#   3. Mail abrufen.
#   4. Ins Anhangverzeichnis sehen (Eudora-Verzeichnis, Unterordner "attach").
#
# WAS DABEI HERAUSKOMMEN MUSS
#
#   00-gutfall                Rechnung.pdf                      <- muss heil sein
#   01-gefaltet-leerzeichen   Angebot ... Musterstadt           <- OHNE .pdf
#   02-gefaltet-tabulator     Angebot ... Stadtwerke            <- OHNE .pdf
#   03-ueber-254-zeichen      254 Buchstaben                    <- OHNE .pdf
#   04-rfc2231                der BETREFF, auf 31 Zeichen       <- OHNE .pdf
#   05-leerer-dateiname       eine Datei namens "="
#   06-betreff-gefaltet       Anhang heil, BETREFF mit Luecken mitten im Wort (E-94)
#
# Ist 00 heil und sind 01 bis 05 kaputt, ist AN-1 bestaetigt. Sind hinterher
# ALLE sechs heil, wirken die Behebungen B5.1 bis B5.6 (siehe AUFGABEN.md)
# am laufenden Programm.
#
# WORAN MAN ES AUCH IN ECHTER POST ERKENNT
#
# Eudora schreibt die Kopfzeile in die .mbx-Datei zurueck - und setzt dabei im
# Fehlerfall ein Anfuehrungszeichen AN DIE FALSCHE STELLE. In der Mailbox steht
# dann:
#
#     filename="Angebot Nr 4711 fuer die Stadtwerke Musterstadt"
#      Abrechnungszeitraum 2025.pdf"
#
# Zwei schliessende Anfuehrungszeichen, das erste am Zeilenende vor einer Zeile,
# die mit Leerzeichen oder Tabulator beginnt. Das ist der Fingerabdruck: wer in
# einer .mbx danach sucht, findet die betroffenen Nachrichten.
#
# Bewusst ohne Escape-Sequenzen fuer Steuerzeichen geschrieben und ohne Umlaute.

use MIME::Base64 ();

my $CR = chr(13);
my $LF = chr(10);
my $CRLF = $CR . $LF;

my ($erzeugen, $pop, $port);
for (my $i = 0; $i < @ARGV; $i++) {
  my $a = $ARGV[$i];
  if    ($a eq '--erzeugen') { $erzeugen = 1 }
  elsif ($a eq '--pop')      { $pop = 1; $port = $ARGV[$i+1] if defined $ARGV[$i+1] && $ARGV[$i+1] =~ /^\d+$/; $i++ if defined $port }
  else                       { die "unbekannte Option: $a\n" }
}
$port = 11110 unless $port;

my $wurzel = `git rev-parse --show-toplevel`;
die "nicht in einem git-Baum\n" if $?;
chomp $wurzel;
my $ZIEL = "$wurzel/tools/pruefdaten/anhang-faltung";

# ---------------------------------------------------------------------------
# Der Anhang: ein gueltiges einseitiges PDF, 639 Byte. Es liegt hier als
# base64, damit dieses Werkzeug fuer sich allein steht.
# ---------------------------------------------------------------------------
my $PDF_B64 = join '', qw(
  JVBERi0xLjQKMSAwIG9iago8PCAvVHlwZSAvQ2F0YWxvZyAvUGFnZXMgMiAwIFIgPj4KZW5k
  b2JqCjIgMCBvYmoKPDwgL1R5cGUgL1BhZ2VzIC9LaWRzIFszIDAgUl0gL0NvdW50IDEgPj4K
  ZW5kb2JqCjMgMCBvYmoKPDwgL1R5cGUgL1BhZ2UgL1BhcmVudCAyIDAgUiAvTWVkaWFCb3gg
  WzAgMCAzMDAgMTIwXSAvUmVzb3VyY2VzIDw8IC9Gb250IDw8IC9GMSA1IDAgUiA+PiA+PiAv
  Q29udGVudHMgNCAwIFIgPj4KZW5kb2JqCjQgMCBvYmoKPDwgL0xlbmd0aCA5NSA+PgpzdHJl
  YW0KQlQgL0YxIDE0IFRmIDIwIDcwIFRkIChFdWRvcmEgNy4yIC0gUHJ1ZWZhbmhhbmcgQU4t
  MSkgVGogMCAtMjQgVGQgKERhdGVpbmFtZSBtaXQgRmFsdHVuZykgVGogRVQKZW5kc3RyZWFt
  CmVuZG9iago1IDAgb2JqCjw8IC9UeXBlIC9Gb250IC9TdWJ0eXBlIC9UeXBlMSAvQmFzZUZv
  bnQgL0hlbHZldGljYSA+PgplbmRvYmoKeHJlZgowIDYKMDAwMDAwMDAwMCA2NTUzNSBmIAow
  MDAwMDAwMDA5IDAwMDAwIG4gCjAwMDAwMDAwNTggMDAwMDAgbiAKMDAwMDAwMDExNSAwMDAw
  MCBuIAowMDAwMDAwMjQxIDAwMDAwIG4gCjAwMDAwMDAzODYgMDAwMDAgbiAKdHJhaWxlcgo8
  PCAvU2l6ZSA2IC9Sb290IDEgMCBSID4+CnN0YXJ0eHJlZgo0NTYKJSVFT0YK
);

# ---------------------------------------------------------------------------
# Die Faelle. "kopf" ist der MIME-Teilkopf des Anhangs, woertlich so, wie er
# auf der Leitung ankommt - mit CR und LF an genau den Stellen, um die es geht.
# "soll" ist der Dateiname, den der Absender meint.
# "heute" ist das, was Eudora daraus macht (BEFUNDE.md AN-1, gemessen).
# ---------------------------------------------------------------------------
my $LANGNAME = 'A' x 300;

my @faelle = (
  { nr    => '00-gutfall',
    betr  => 'Pruefung AN-1: Gutfall, ungefaltet',
    kopf  => 'Content-Type: application/pdf; name="Rechnung.pdf"' . $CRLF
           . 'Content-Disposition: attachment; filename="Rechnung.pdf"' . $CRLF,
    soll  => 'Rechnung.pdf',
    heute => 'Rechnung.pdf',
    wort  => 'Gegenprobe - dieser Fall MUSS heil sein, vorher wie nachher' },

  { nr    => '01-gefaltet-leerzeichen',
    betr  => 'Pruefung AN-1: Dateiname an einem Leerzeichen gefaltet',
    kopf  => 'Content-Type: application/pdf;' . $CRLF
           . ' name="Angebot Nr 4711 fuer die Stadtwerke Musterstadt' . $CRLF
           . ' Abrechnungszeitraum 2025.pdf"' . $CRLF
           . 'Content-Disposition: attachment;' . $CRLF
           . ' filename="Angebot Nr 4711 fuer die Stadtwerke Musterstadt' . $CRLF
           . ' Abrechnungszeitraum 2025.pdf"' . $CRLF,
    soll  => 'Angebot Nr 4711 fuer die Stadtwerke Musterstadt Abrechnungszeitraum 2025.pdf',
    heute => 'Angebot Nr 4711 fuer die Stadtwerke Musterstadt',
    wort  => 'DER gemeldete Fall. So falten Exchange, Zimbra, JavaMail und PHP-Skripte' },

  { nr    => '02-gefaltet-tabulator',
    betr  => 'Pruefung AN-1: Dateiname mit Tabulator gefaltet',
    kopf  => 'Content-Type: application/pdf; name="Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf"' . $CRLF
           . 'Content-Disposition: attachment;' . $CRLF
           . chr(9) . 'filename="Angebot Nr 4711 fuer die Stadtwerke' . $CRLF
           . chr(9) . 'Musterstadt 2025.pdf"' . $CRLF,
    soll  => 'Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf',
    heute => 'Angebot Nr 4711 fuer die Stadtwerke',
    wort  => 'derselbe Fehler - RFC 5322 erlaubt Leerzeichen UND Tabulator' },

  { nr    => '03-ueber-254-zeichen',
    betr  => 'Pruefung AN-1: Dateiname ueber 254 Zeichen, ungefaltet',
    kopf  => 'Content-Type: application/pdf; name="' . $LANGNAME . '.pdf"' . $CRLF
           . 'Content-Disposition: attachment; filename="' . $LANGNAME . '.pdf"' . $CRLF,
    soll  => $LANGNAME . '.pdf',
    heute => ('A' x 254),
    wort  => 'die Marke Token[256] laeuft voll (lex822.h:70)' },

  { nr    => '04-rfc2231',
    betr  => 'AN-1 Pruefung mit sehr langem Betreff der als Name herhalten muss',
    kopf  => 'Content-Type: application/pdf' . $CRLF
           . 'Content-Disposition: attachment;' . $CRLF
           . ' filename*0="Angebot Nr 4711 fuer die Stadtwerke";' . $CRLF
           . ' filename*1=" Musterstadt 2025.pdf"' . $CRLF,
    soll  => 'Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf',
    heute => 'der Betreff, auf 31 Zeichen gekuerzt (mime.cpp:1640, subj[32])',
    wort  => 'RFC 2231 kennt der Baum nicht - dann gibt es gar kein filename' },

  { nr    => '05-leerer-dateiname',
    betr  => 'Pruefung AN-1: leerer Dateiname',
    kopf  => 'Content-Type: application/pdf; name=""' . $CRLF
           . 'Content-Disposition: attachment; filename=""' . $CRLF,
    soll  => '(leer - Eudora darf sich einen Namen ausdenken)',
    heute => 'eine Datei namens "="',
    wort  => 'die leere Marke traegt das erste Byte der VORIGEN Marke' },

  # Befund E-94 (12.10.2026): nicht der Anhang, sondern der BETREFF. So faltet
  # der web.de-Webmailer einen langen Betreff - in mehrere kodierte Woerter
  # zerlegt, und die Grenzen liegen mitten im Wort. RFC 2047, 6.2: der
  # Leerraum zwischen zwei kodierten Woertern faellt weg, auch eine Faltung.
  # Der Anhang ist absichtlich heil, damit dieser Fall nur E-94 misst.
  { nr     => '06-betreff-gefaltet',
    befund => 'E-94',
    betr   => '=?utf-8?Q?Pruefung_E-94:_Toner_bestel?=' . $CRLF
            . ' =?utf-8?Q?len_und_1?=' . $CRLF
            . ' =?utf-8?Q?5_Prozent_sparen_bis_zum_Wochenend?=' . $CRLF
            . ' =?utf-8?Q?e!?=',
    kopf   => 'Content-Type: application/pdf; name="Rechnung-E94.pdf"' . $CRLF
            . 'Content-Disposition: attachment; filename="Rechnung-E94.pdf"' . $CRLF,
    soll   => 'Betreff "Pruefung E-94: Toner bestellen und 15 Prozent sparen bis zum Wochenende!", Anhang Rechnung-E94.pdf',
    heute  => 'Betreff mit Luecken mitten im Wort ("bestel len", "1 5", "Wochenend e!")',
    wort   => 'E-94: kodierte Woerter ueber eine Faltung hinweg (lex822.cpp:685)' },
);

# ---------------------------------------------------------------------------
# Eine vollstaendige Nachricht bauen
# ---------------------------------------------------------------------------
sub nachricht {
  my $f = shift;
  my $grenze = '----EUDORA-AN1-' . $f->{nr};

  my $befund = $f->{befund} || 'AN-1';
  my $text = "Pruefnachricht fuer Befund $befund, Fall " . $f->{nr} . "." . $CRLF
           . $CRLF
           . "Erwartet wird der Anhang" . $CRLF
           . "  " . $f->{soll} . $CRLF
           . $CRLF
           . "Heute macht Eudora daraus" . $CRLF
           . "  " . $f->{heute} . $CRLF
           . $CRLF
           . "Siehe BEFUNDE.md, Befund $befund." . $CRLF;

  my $anhang = $PDF_B64;
  $anhang =~ s/(.{1,76})/$1$CRLF/g;

  return  'Return-Path: <pruefstand@localhost>' . $CRLF
        . 'Received: from pruefstand (127.0.0.1) by localhost;' . $CRLF
        . ' Tue, 30 Sep 2026 12:00:00 +0200' . $CRLF
        . 'Date: Tue, 30 Sep 2026 12:00:00 +0200' . $CRLF
        . 'From: Pruefstand AN-1 <pruefstand@localhost>' . $CRLF
        . 'To: Eudora <pruef@localhost>' . $CRLF
        . 'Subject: ' . $f->{betr} . $CRLF
        . 'Message-ID: <an1-' . $f->{nr} . '@localhost>' . $CRLF
        . 'MIME-Version: 1.0' . $CRLF
        . 'Content-Type: multipart/mixed; boundary="' . $grenze . '"' . $CRLF
        . $CRLF
        . 'Diese Nachricht hat mehrere Teile im MIME-Format.' . $CRLF
        . $CRLF
        . '--' . $grenze . $CRLF
        . 'Content-Type: text/plain; charset="iso-8859-1"' . $CRLF
        . 'Content-Transfer-Encoding: 7bit' . $CRLF
        . $CRLF
        . $text
        . '--' . $grenze . $CRLF
        . $f->{kopf}
        . 'Content-Transfer-Encoding: base64' . $CRLF
        . $CRLF
        . $anhang
        . '--' . $grenze . '--' . $CRLF;
}

# ---------------------------------------------------------------------------
# Uebersicht
# ---------------------------------------------------------------------------
unless ($erzeugen || $pop) {
  print "Pruefdaten fuer AN-1 (00-05) und E-94 (06) - " . scalar(@faelle) . " Nachrichten mit einem PDF im Anhang.\n\n";
  printf "  %-24s %s\n", 'Fall', 'was Eudora heute daraus macht';
  printf "  %-24s %s\n", '-' x 24, '-' x 45;
  for my $f (@faelle) {
    my $h = $f->{heute};
    $h = substr($h, 0, 28) . '...' . substr($h, -8) . ' (' . length($f->{heute}) . ' Zeichen)'
      if length($h) > 45;
    printf "  %-24s %s\n", $f->{nr}, $h;
    printf "  %-24s   (%s)\n", '', $f->{wort};
  }
  print "\n  --erzeugen   schreibt sie nach tools/pruefdaten/anhang-faltung/\n";
  print "  --pop        liefert sie auf 127.0.0.1:$port aus (so wird wirklich geprueft)\n";
  print "\nDer Kopf dieser Datei sagt, wie das Konto in Eudora einzurichten ist.\n";
  exit 0;
}

# ---------------------------------------------------------------------------
# Dateien schreiben
# ---------------------------------------------------------------------------
if ($erzeugen) {
  for my $t ("$wurzel/tools/pruefdaten", $ZIEL) {
    mkdir $t unless -d $t;
  }
  for my $f (@faelle) {
    my $pfad = "$ZIEL/" . $f->{nr} . ".eml";
    open my $fh, '>', $pfad or die "$pfad: $!\n";
    binmode $fh;
    print $fh nachricht($f);
    close $fh;
    printf "geschrieben: %-28s %6d Byte\n", $f->{nr} . '.eml', -s $pfad;
  }
  print "\nAchtung: eine .eml in eine .mbx zu kopieren reicht NICHT - dann laeuft\n";
  print "der Empfangsweg nicht und der Anhang wird nie geschrieben. Zum Pruefen\n";
  print "--pop benutzen.\n";
  exit 0;
}

# ---------------------------------------------------------------------------
# Minimaler POP3-Server. Nur so viel, wie Eudora braucht.
# ---------------------------------------------------------------------------
require IO::Socket::INET;

my @post = map { nachricht($_) } @faelle;

my $horch = IO::Socket::INET->new(
  LocalAddr => '127.0.0.1', LocalPort => $port,
  Proto => 'tcp', Listen => 5, ReuseAddr => 1)
  or die "Port $port laesst sich nicht oeffnen: $!\n";

print "POP3-Pruefstand auf 127.0.0.1:$port, " . scalar(@post) . " Nachrichten.\n";
print "Konto in Eudora: Server 127.0.0.1, Port $port, Benutzer pruef, SSL AUS.\n";
print "Beenden mit Strg-C.\n\n";

while (my $v = $horch->accept) {
  $v->autoflush(1);
  my $wer = $v->peerhost;
  print "[$wer] verbunden\n";
  my @weg;   # zum Loeschen vorgemerkt - wir loeschen nie wirklich

  print $v "+OK Eudora AN-1 Pruefstand bereit$CRLF";

  while (defined(my $z = <$v>)) {
    $z =~ s/[\r\n]+$//;
    print "[$wer] > $z\n";
    my ($b, @arg) = split /\s+/, $z;
    $b = uc($b || '');

    if    ($b eq 'USER' || $b eq 'PASS') { print $v "+OK$CRLF" }
    elsif ($b eq 'CAPA') {
      print $v "+OK Faehigkeiten$CRLF" . "TOP$CRLF" . "UIDL$CRLF" . "USER$CRLF" . ".$CRLF";
    }
    elsif ($b eq 'STAT') {
      my $n = 0; my $s = 0;
      for my $i (0 .. $#post) { next if $weg[$i]; $n++; $s += length $post[$i] }
      print $v "+OK $n $s$CRLF";
    }
    elsif ($b eq 'LIST' || $b eq 'UIDL') {
      my $uidl = ($b eq 'UIDL');
      if (@arg) {
        my $i = $arg[0] - 1;
        if ($i < 0 || $i > $#post || $weg[$i]) { print $v "-ERR gibt es nicht$CRLF" }
        elsif ($uidl) { print $v "+OK " . ($i+1) . " an1-" . $faelle[$i]{nr} . $CRLF }
        else          { print $v "+OK " . ($i+1) . " " . length($post[$i]) . $CRLF }
      }
      else {
        print $v "+OK$CRLF";
        for my $i (0 .. $#post) {
          next if $weg[$i];
          print $v ($i+1) . " " . ($uidl ? "an1-" . $faelle[$i]{nr}
                                         : length($post[$i])) . $CRLF;
        }
        print $v ".$CRLF";
      }
    }
    elsif ($b eq 'RETR' || $b eq 'TOP') {
      my $i = ($arg[0] || 0) - 1;
      if ($i < 0 || $i > $#post || $weg[$i]) { print $v "-ERR gibt es nicht$CRLF"; next }
      my $t = $post[$i];
      if ($b eq 'TOP') {
        my $n = defined $arg[1] ? $arg[1] : 0;
        my ($k, $r) = split /$CRLF$CRLF/, $t, 2;
        my @zl = split /$CRLF/, (defined $r ? $r : '');
        $t = $k . $CRLF . $CRLF . join($CRLF, @zl[0 .. ($n-1 < $#zl ? $n-1 : $#zl)]);
        $t .= $CRLF if length $t;
      }
      print $v "+OK$CRLF";
      #  Punkt am Zeilenanfang verdoppeln (RFC 1939 Abschnitt 3)
      for my $zl (split /$CRLF/, $t, -1) {
        $zl = '.' . $zl if substr($zl, 0, 1) eq '.';
        print $v $zl . $CRLF;
      }
      print $v ".$CRLF";
      print "[$wer] < Nachricht " . ($i+1) . " (" . $faelle[$i]{nr} . ") ausgeliefert\n";
    }
    elsif ($b eq 'DELE') {
      #  Wir merken das Loeschen nur vor und vergessen es beim Trennen -
      #  die Pruefdaten sollen beim naechsten Abruf wieder da sein.
      my $i = ($arg[0] || 0) - 1;
      if ($i < 0 || $i > $#post) { print $v "-ERR gibt es nicht$CRLF" }
      else { $weg[$i] = 1; print $v "+OK vorgemerkt (bleibt trotzdem liegen)$CRLF" }
    }
    elsif ($b eq 'NOOP' || $b eq 'RSET') { @weg = () if $b eq 'RSET'; print $v "+OK$CRLF" }
    elsif ($b eq 'QUIT') { print $v "+OK tschuess$CRLF"; last }
    else { print $v "-ERR kenne ich nicht$CRLF" }
  }
  close $v;
  print "[$wer] getrennt\n\n";
}
