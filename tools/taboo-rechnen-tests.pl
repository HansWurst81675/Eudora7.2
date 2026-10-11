#!/usr/bin/perl
#
# Gegentest zu tools/taboo-rechnen.pl.
#
#   perl tools/taboo-rechnen-tests.pl
#
# Rueckgabe 0 = alle Faelle wie erwartet, 1 = ein Fall abweichend.
#
# MASSSTAB IST DER C-CODE, nicht das Perl-Skript. Die erwartete Antwort jedes
# Falles steht im Kommentar darueber, mit Datei und Zeile:
#
#   Eudora71/Eudora/TridentReadMessageView.cpp:2404  WriteHeaders
#     :2444 Suche nach dem Doppelpunkt, :2456 Abbruch "no more headers",
#     :2465 der Vergleich  strnicmp( Listeneintrag, Kopfzeile, Laenge )
#     :2525 do-while: Zeilen mit fuehrendem Leerzeichen/Tabulator gehoeren
#           noch zur selben Kopfzeile
#   Eudora71/Eudora/ReadMessageDoc.cpp:472  StripTabooHeaders
#     :494 Abbruch (GetOut) bei Zeile ohne Doppelpunkt, :504 derselbe
#     Vergleich, :513 Fortsetzungszeilen
#   Eudora71/Eudora/ReadMessageDoc.cpp:433  BuildTabooHeaderArray
#     zerlegt die INI-Zeichenkette an Kommas
#   Eudora71/Eudora/EudoraRes.rc:9996  die gueltige Liste (44 Eintraege)
#   Eudora71/Eudora/MimeStorage.cpp:422 + msgutils.cpp:333  FindBody:
#     ohne "\r\n\r\n" ist die GANZE Nachricht Kopfteil
#
# JEDER FALL LAEUFT IN BEIDE RICHTUNGEN. Es gibt Faelle, in denen das Werkzeug
# recht behalten MUSS (Referer ueberlebt neben References), und Faelle, in
# denen es irren muss, wenn der Verdacht stimmt. Eine Pruefung, die nur den
# Fehler sucht, kann stumm sein; eine, die nur den erlaubten Fall faehrt, kann
# Fehlalarm geben (Lehre "Schranke gegentesten").
#
# Die Liste wird ueber die Umgebungsvariable TABOO gesetzt, damit die Faelle
# nicht von der im Werkzeug eingebauten Liste abhaengen. Genau ein Fall laesst
# TABOO absichtlich weg - der prueft die eingebaute Liste gegen EudoraRes.rc.
#
# Gearbeitet wird in einem Wegwerfverzeichnis unter File::Temp. Der Quellbaum
# und die echten Postfaecher werden nicht angefasst.

use strict;
use warnings;
use File::Temp qw(tempdir);
use File::Spec;
use Cwd qw(abs_path);

my $werkzeug = abs_path($0);
$werkzeug =~ s/-tests\.pl$/.pl/;
die "Werkzeug nicht gefunden: $werkzeug\n" unless -f $werkzeug;

my $quelle = abs_path($0);
$quelle =~ s{[\\/]tools[\\/][^\\/]+$}{};

my $RES_RC = File::Spec->catfile($quelle, 'Eudora71', 'Eudora', 'EudoraRes.rc');

# --- Vorspann: die gueltige Liste aus der Quelle lesen ----------------------
#
# Nur zur Anzeige, und damit der Test es merkt, wenn die Liste in der Quelle
# sich aendert. Der Fall "eingebaute Liste" unten stuetzt sich darauf.

my $rc_liste = '';
if (-f $RES_RC)
{
	open my $r, '<:raw', $RES_RC or die "$RES_RC: $!";
	while (my $z = <$r>)
	{
		next unless $z =~ /"TabooHeaders\\n([^"]*)"/;
		$rc_liste = $1;
		printf "  EudoraRes.rc:%d fuehrt %d Listeneintraege.\n",
			$., scalar(split /,/, $rc_liste);
		last;
	}
	close $r;
}
print "  EudoraRes.rc nicht gefunden - der Fall zur eingebauten Liste bleibt trotzdem gueltig.\n"
	unless $rc_liste;
print "\n";

# ---------------------------------------------------------------------------
# Bausteine fuer kuenstliche Postfaecher.
#
# Eudora trennt Nachrichten mit "From ???@???" am Zeilenanfang, danach folgt
# auf derselben Zeile das Datum. Diese Datumszeile faengt nach dem Trenner mit
# einem Leerzeichen an - sie ist deshalb fuer jede Auswertung eine
# Fortsetzungszeile und traegt nie einen Kopfzeilennamen bei.

sub nachricht
{
	my ($kopf, $koerper) = @_;
	$koerper = '' unless defined $koerper;
	return "From ???\@??? Fri Sep 11 10:00:00 2026\r\n" . $kopf . "\r\n" . $koerper;
}

# ---------------------------------------------------------------------------
# Die Faelle.
#
#   name        Anzeigename
#   liste       Inhalt der TABOO-Datei; undef = TABOO nicht setzen
#   mbx         Inhalt der kuenstlichen .mbx-Datei
#   versteckt   erwartete Zaehlung unter "VERSTECKT der Knopf"
#   ueberlebt   erwartete Zaehlung unter "BLEIBT STEHEN"; undef = nicht geprueft
#   nachrichten erwartete Zahl der Nachrichten; undef = nicht geprueft
#   ausgewertet erwartete Zahl "Nachrichten mit Kopfteil"; undef = nicht geprueft

my @faelle;

# 1) Praefix trifft genau.
# strnicmp("Status", "Status: U", 6) == 0 -> versteckt
# (TridentReadMessageView.cpp:2465). "From" und "Subject" stehen nicht auf der
# Liste, also bleiben sie stehen.
push @faelle, {
	name      => 'Praefix trifft genau (Status gegen "Status: U")',
	liste     => 'Status',
	mbx       => nachricht("From: a\@example.invalid\r\nSubject: Hallo\r\nStatus: U\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'Status' => 1 },
	ueberlebt => { 'From' => 1, 'Subject' => 1 },
};

# 2) Praefix trifft einen laengeren Namen.
# Verglichen werden nur die 7 Zeichen des Listeneintrags gegen den ANFANG DER
# GANZEN ZEILE: strnicmp("Message", "Message-ID: <1@x>", 7) == 0
# (TridentReadMessageView.cpp:2465). Der Eintrag "Message" verdeckt also auch
# Message-ID.
push @faelle, {
	name      => 'Praefix trifft laengeren Namen (Message gegen Message-ID)',
	liste     => 'Message',
	mbx       => nachricht("From: a\@example.invalid\r\nMessage-ID: <1\@x>\r\nSubject: Hallo\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'Message-ID' => 1 },
	ueberlebt => { 'From' => 1, 'Subject' => 1 },
};

# 3) Praefix trifft NICHT, obwohl er aehnlich aussieht.
# strnicmp("References", "Referer: http://x", 10): an Stelle 7 steht 'n' gegen
# ':' -> ungleich (TridentReadMessageView.cpp:2465). Referer muss ueberleben.
# Dieser Fall faengt eine Pruefung ab, die nur auf den Namensanfang schaut.
push @faelle, {
	name      => 'Praefix trifft nicht (References gegen Referer)',
	liste     => 'References',
	mbx       => nachricht("References: <1\@x>\r\nReferer: http://x\r\nSubject: Hallo\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'References' => 1 },
	ueberlebt => { 'Referer' => 1, 'Subject' => 1 },
};

# 4) Gross- und Kleinschreibung.
# strNICmp vergleicht ohne Ruecksicht auf die Schreibweise
# (TridentReadMessageView.cpp:2465), der Eintrag "X-" verdeckt also auch
# "x-originating-ip".
push @faelle, {
	name      => 'Gross-/Kleinschreibung (X- gegen x-originating-ip)',
	liste     => 'X-',
	mbx       => nachricht("x-originating-ip: [1.2.3.4]\r\nX-Mailer: Egal\r\nSubject: Hallo\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'x-originating-ip' => 1, 'X-Mailer' => 1 },
	ueberlebt => { 'Subject' => 1 },
};

# 5) Fortsetzungszeilen gehoeren zur Kopfzeile davor.
# Die do-while-Schleife (TridentReadMessageView.cpp:2525) schluckt jede Zeile,
# die mit Leerzeichen oder Tabulator anfaengt, in die laufende Kopfzeile;
# gleichlautend ReadMessageDoc.cpp:513. Die Falle "X-Falle" steht auf einer
# Fortsetzungszeile und ist deshalb GAR KEINE Kopfzeile - sie darf weder
# versteckt noch als ueberlebend gezaehlt werden.
push @faelle, {
	name      => 'Fortsetzungszeile (Tabulator) zaehlt nicht als eigene Kopfzeile',
	liste     => 'Received,X-',
	mbx       => nachricht("Received: von a\r\n\tX-Falle: ja\r\n  mit c\r\nSubject: Hallo\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'Received' => 1 },
	ueberlebt => { 'Subject' => 1 },
};

# 6) Fortsetzungszeile einer Kopfzeile, die ueberlebt.
# Dasselbe in die andere Richtung: die eingerueckte Zeile darf auch dann nicht
# gezaehlt werden, wenn die Kopfzeile davor stehen bleibt
# (TridentReadMessageView.cpp:2525).
push @faelle, {
	name      => 'Fortsetzungszeile (Leerzeichen) einer ueberlebenden Kopfzeile',
	liste     => 'Status',
	mbx       => nachricht("Subject: eine sehr lange\r\n Betreffzeile\r\nStatus: U\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'Status' => 1 },
	ueberlebt => { 'Subject' => 1 },
};

# 7) Kopfzeile OHNE Doppelpunkt.
# Die Suche nach dem Doppelpunkt bricht am Zeilenende ab
# (TridentReadMessageView.cpp:2444); danach gilt
#   if( ( szColon == szEndOfHeaders ) || ( *szColon != ':' ) ) break;   // :2454
# also endet die GESAMTE Kopfzeilenverarbeitung. Gleichlautend setzt
# ReadMessageDoc.cpp:494 GetOut. Ab dieser Zeile wird KEINE Kopfzeile mehr mit
# der Liste verglichen: Status und X-Mailer koennen nicht mehr versteckt
# werden, obwohl sie auf der Liste stehen.
#
# "ueberlebt" wird hier nicht geprueft, weil die beiden C-Wege sich nur im
# Rest unterscheiden: WriteHeaders schreibt ab dem Abbruch gar nichts mehr,
# StripTabooHeaders kopiert den Rest unveraendert (ReadMessageDoc.cpp:525).
# Einig sind sie darin, dass nichts mehr VERSTECKT wird - und nur das steht
# hier zur Pruefung.
push @faelle, {
	name      => 'Kopfzeile ohne Doppelpunkt beendet die Verarbeitung',
	liste     => 'Status,X-',
	mbx       => nachricht("From: a\@example.invalid\r\nKAPUTTE ZEILE OHNE DOPPELPUNKT\r\nStatus: U\r\nX-Mailer: Egal\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { },
	ueberlebt => undef,
};

# 8) Name mit einem Punkt darin.
# Der C-Code sucht nur den ersten Doppelpunkt und laesst davor JEDES Zeichen
# zu (TridentReadMessageView.cpp:2444). strnicmp("X.", "X.Foo: bar", 2) == 0
# -> versteckt (:2465). Ein Listeneintrag "X." ist erlaubt, weil die Liste aus
# der INI kommt und an Kommas zerlegt wird (ReadMessageDoc.cpp:433).
push @faelle, {
	name      => 'Name mit Punkt (X. gegen "X.Foo: bar")',
	liste     => 'Status,X.',
	mbx       => nachricht("From: a\@example.invalid\r\nX.Foo: bar\r\nStatus: U\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'X.Foo' => 1, 'Status' => 1 },
	ueberlebt => { 'From' => 1 },
};

# 9) Leerzeichen im Namen.
# Auch hier zaehlt nur der erste Doppelpunkt (TridentReadMessageView.cpp:2444),
# und strnicmp("X-", "X-Spam Flag: YES", 2) == 0 -> versteckt (:2465).
# Solche Zeilen kommen von kaputten Servern wirklich vor.
push @faelle, {
	name      => 'Leerzeichen im Namen (X- gegen "X-Spam Flag: YES")',
	liste     => 'X-',
	mbx       => nachricht("From: a\@example.invalid\r\nX-Spam Flag: YES\r\nSubject: Hallo\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'X-Spam Flag' => 1 },
	ueberlebt => { 'From' => 1, 'Subject' => 1 },
};

# 10) Mehrere Nachrichten in einer Datei.
# Jede Nachricht wird fuer sich ausgewertet; die Zaehlung addiert sich.
push @faelle, {
	name        => 'Mehrere Nachrichten in einer Datei',
	liste       => 'Status',
	mbx         => nachricht("From: a\@example.invalid\r\nSubject: eins\r\nStatus: U\r\n", "Text eins\r\n")
	             . nachricht("From: b\@example.invalid\r\nSubject: zwei\r\nStatus: R\r\n", "Text zwei\r\n"),
	nachrichten => 2,
	ausgewertet => 2,
	versteckt   => { 'Status' => 2 },
	ueberlebt   => { 'From' => 2, 'Subject' => 2 },
};

# 11) Letzte Nachricht ohne Leerzeile nach dem Kopf.
# FindBody sucht "\r\n\r\n"; findet es das nicht, zeigt es auf das Ende der
# Nachricht (msgutils.cpp:333). GetMessageForDisplay nimmt dann ALLES als
# Kopfteil (MimeStorage.cpp:422), und WriteHeaders arbeitet es ganz normal ab.
# Die Kopfzeilen der letzten Nachricht muessen also mitgerechnet werden.
push @faelle, {
	name        => 'Letzte Nachricht ohne Leerzeile nach dem Kopf',
	liste       => 'Status',
	mbx         => nachricht("From: a\@example.invalid\r\nSubject: eins\r\nStatus: U\r\n", "Text eins\r\n")
	             . "From ???\@??? Fri Sep 11 11:00:00 2026\r\nFrom: b\@example.invalid\r\nSubject: zwei\r\nStatus: R\r\n",
	nachrichten => 2,
	ausgewertet => 2,
	versteckt   => { 'Status' => 2 },
	ueberlebt   => { 'From' => 2, 'Subject' => 2 },
};

# 12) "From ???@???" im Nachrichtenkoerper.
# Eudora findet seine Nachrichten ueber die Offsets in der .toc-Datei, nicht
# ueber eine Textsuche; der Koerper wird nie nach Kopfzeilen abgesucht
# (WriteHeaders bekommt nur szHeaders, TridentView.cpp:1447). Hier steht also
# EINE Nachricht in der Datei, und "Status" kommt genau einmal vor.
# Kuenstlicher Fall: in den 7 echten Postfaechern kommt die Zeichenkette
# "From ???@???" 134 mal vor und jedes Mal als Trenner am Zeilenanfang -
# gemessen mit grep -c gegen grep -c '^...'.
push @faelle, {
	name        => 'Trennerzeile im Nachrichtenkoerper taeuscht keine Nachricht vor',
	liste       => 'Status',
	mbx         => nachricht("From: a\@example.invalid\r\nSubject: echt\r\nStatus: U\r\n",
	                         "Guten Tag.\r\n\r\nFrom ???\@??? Sat Sep 12 11:00:00 2026\r\nStatus: R\r\nSubject: erfunden\r\n\r\nEnde\r\n"),
	nachrichten => 1,
	ausgewertet => 1,
	versteckt   => { 'Status' => 1 },
	ueberlebt   => { 'From' => 1, 'Subject' => 1 },
	grenze      => 'ohne die .toc-Datei von aussen nicht zu unterscheiden; an den '
	             . '134 echten Nachrichten gemessen folgenlos',
};

# 13) Vorspann vor der ersten Trennerzeile, der einen Doppelpunkt enthaelt.
# Solche Reste entstehen an abgeschnittenen oder halb verdichteten Postfaechern.
# Eudora zeigt sie nicht an - die .toc kennt sie nicht. Erwartet wird deshalb
# EINE Nachricht, und "Rest" ist keine Kopfzeile.
push @faelle, {
	name        => 'Vorspann mit Doppelpunkt vor der ersten Nachricht',
	liste       => 'Status',
	mbx         => "Rest: einer abgeschnittenen Nachricht\r\n\r\n"
	             . nachricht("From: a\@example.invalid\r\nSubject: echt\r\nStatus: U\r\n", "Text\r\n"),
	nachrichten => 1,
	ausgewertet => 1,
	versteckt   => { 'Status' => 1 },
	ueberlebt   => { 'From' => 1, 'Subject' => 1 },
};

# 14) Gegenprobe zu 13: derselbe Vorspann OHNE Doppelpunkt.
# Hier muss die Zeile "shift @n if @n && $n[0] !~ /:/" greifen und der Vorspann
# verschwinden. Erwartet wird dasselbe Ergebnis wie in 13 - also darf der Test
# in 13 nicht einfach an der Zahl scheitern, sondern am Vorspann.
push @faelle, {
	name        => 'Vorspann ohne Doppelpunkt wird verworfen (Gegenprobe zu 13)',
	liste       => 'Status',
	mbx         => "abgeschnitten\r\n\r\n"
	             . nachricht("From: a\@example.invalid\r\nSubject: echt\r\nStatus: U\r\n", "Text\r\n"),
	nachrichten => 1,
	ausgewertet => 1,
	versteckt   => { 'Status' => 1 },
	ueberlebt   => { 'From' => 1, 'Subject' => 1 },
};

# 15) Leerer Listeneintrag durch doppeltes Komma.
# BuildTabooHeaderArray zerlegt stur an Kommas (ReadMessageDoc.cpp:433) und
# legt bei "Status,,Subject" einen leeren Eintrag an. Dessen GetLength() ist 0,
# und strnicmp(x, y, 0) gibt 0 zurueck - der leere Eintrag passt auf JEDE
# Kopfzeile (TridentReadMessageView.cpp:2465). Ein Tippfehler in der INI
# versteckt also alle Kopfzeilen.
push @faelle, {
	name      => 'Leerer Listeneintrag (doppeltes Komma) versteckt alles',
	liste     => 'Status,,Subject',
	mbx       => nachricht("From: a\@example.invalid\r\nSubject: Hallo\r\nStatus: U\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'From' => 1, 'Subject' => 1, 'Status' => 1 },
	ueberlebt => { },
};

# 16) Der Praefix zaehlt nur am Zeilenanfang.
# szHeaderScan zeigt immer auf den Anfang der Kopfzeile
# (TridentReadMessageView.cpp:2465), ein Treffer mitten im Wert zaehlt nicht.
# "Subject: Return to sender" enthaelt "Return", muss aber stehen bleiben.
push @faelle, {
	name      => 'Praefix nur am Zeilenanfang (Return im Betreff zaehlt nicht)',
	liste     => 'Return',
	mbx       => nachricht("Subject: Return to sender\r\nReturn-Path: <x\@example.invalid>\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'Return-Path' => 1 },
	ueberlebt => { 'Subject' => 1 },
};

# 17) Listeneintrag laenger als die Kopfzeile.
# strnicmp liest bis zu 22 Zeichen und damit ueber das Zeilenende hinaus in die
# naechste Zeile (der Kopfteil ist ein einziger Puffer,
# TridentReadMessageView.cpp:2465). Treffen kann das trotzdem nie, weil kein
# Listeneintrag ein \r oder \n enthalten kann - die Liste wird an Kommas
# zerlegt (ReadMessageDoc.cpp:433). "Auth: x" muss also stehen bleiben.
push @faelle, {
	name      => 'Listeneintrag laenger als die Kopfzeile (Auth ueberlebt)',
	liste     => 'Authentication-Results',
	mbx       => nachricht("Auth: x\r\nAuthentication-Results: spf=pass\r\nSubject: Hallo\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'Authentication-Results' => 1 },
	ueberlebt => { 'Auth' => 1, 'Subject' => 1 },
};

# 18) Die eingebaute Standardliste gegen die Quelle.
# EINZIGER Fall ohne TABOO. Massstab ist EudoraRes.rc:9996: dort stehen
# 44 Eintraege, darunter "DKIM-", "Authentication-Results" und "User-Agent".
# Wer taboo-rechnen.pl ohne TABOO aufruft, muss dieselbe Antwort bekommen wie
# das Programm - sonst rechnet das Werkzeug mit einer Liste, die es nicht gibt.
push @faelle, {
	name      => 'Eingebaute Liste gegen EudoraRes.rc:9996 (ohne TABOO)',
	liste     => undef,
	mbx       => nachricht("DKIM-Signature: v=1; a=rsa\r\nAuthentication-Results: spf=pass\r\nUser-Agent: Egal\r\nSubject: Hallo\r\n", "Text\r\n"),
	nachrichten => 1,
	versteckt => { 'DKIM-Signature' => 1, 'Authentication-Results' => 1, 'User-Agent' => 1 },
	ueberlebt => { 'Subject' => 1 },
};

# ---------------------------------------------------------------------------

my $tmp = tempdir(CLEANUP => 1);
my $ok = 0;
my $schlecht = 0;
my $grenzen = 0;
my $nr = 0;

for my $fall (@faelle)
{
	$nr++;

	my $mbxpfad = File::Spec->catfile($tmp, sprintf('f%02d.mbx', $nr));
	schreibe($mbxpfad, $fall->{mbx});

	if (defined $fall->{liste})
	{
		my $lp = File::Spec->catfile($tmp, sprintf('f%02d.taboo', $nr));
		schreibe($lp, $fall->{liste} . "\n");
		$ENV{TABOO} = $lp;
	}
	else
	{
		delete $ENV{TABOO};
	}

	my $ausgabe = lauf($mbxpfad);
	my ($anz, $ausgewertet, $v, $u) = auswerten($ausgabe);

	my @abweichung;

	if (defined $fall->{nachrichten} && $anz != $fall->{nachrichten})
	{
		push @abweichung, sprintf('Nachrichten %d statt %d', $anz, $fall->{nachrichten});
	}
	if (defined $fall->{ausgewertet} && $ausgewertet != $fall->{ausgewertet})
	{
		push @abweichung, sprintf('ausgewertet %d statt %d', $ausgewertet, $fall->{ausgewertet});
	}
	if (defined $fall->{versteckt})
	{
		my $ist  = karte2text($v);
		my $soll = karte2text($fall->{versteckt});
		push @abweichung, "versteckt [$ist] statt [$soll]" if $ist ne $soll;
	}
	if (defined $fall->{ueberlebt})
	{
		my $ist  = karte2text($u);
		my $soll = karte2text($fall->{ueberlebt});
		push @abweichung, "ueberlebt [$ist] statt [$soll]" if $ist ne $soll;
	}

	if (@abweichung && $fall->{grenze})
	{
		# Eine BEKANNTE GRENZE: die Abweichung vom C-Code ist gemessen,
		# benannt und im Kopf von taboo-rechnen.pl begruendet. Sie zaehlt
		# nicht als Fehlschlag - sonst stuende der Test dauerhaft rot und
		# wuerde nach einer Woche ignoriert. Genannt wird sie bei jedem Lauf.
		$grenzen++;
		printf "  GRENZE %s\n", $fall->{name};
		print  "          $_\n" for @abweichung;
		print  "          bekannt und begruendet: $fall->{grenze}\n";
	}
	elsif (@abweichung)
	{
		$schlecht++;
		printf "  FEHLT %s\n", $fall->{name};
		print  "          $_\n" for @abweichung;
	}
	elsif ($fall->{grenze})
	{
		# Die Gegenrichtung: verschwindet eine bekannte Grenze, ist die
		# Begruendung im Kopf des Werkzeugs veraltet und muss weg.
		$schlecht++;
		printf "  NEU   %s\n", $fall->{name};
		print  "          Dieser Fall galt als bekannte Grenze und stimmt jetzt.\n";
		print  "          Den Schluessel 'grenze' hier und den zugehoerigen Absatz\n";
		print  "          im Kopf von tools/taboo-rechnen.pl streichen.\n";
	}
	else
	{
		$ok++;
		printf "  ok    %s\n", $fall->{name};
	}
}

printf "\n%d von %d Faellen wie erwartet.\n", $ok, $ok + $schlecht + $grenzen;
printf "%d Fall/Faelle rechnet taboo-rechnen.pl anders als der C-Code.\n", $schlecht
	if $schlecht;
printf "%d bekannte Grenze(n), im Kopf von tools/taboo-rechnen.pl begruendet.\n", $grenzen
	if $grenzen;
exit($schlecht ? 1 : 0);

# ---------------------------------------------------------------------------

sub schreibe
{
	my ($pfad, $inhalt) = @_;
	open my $o, '>:raw', $pfad or die "$pfad: $!";
	print $o $inhalt;
	close $o;
}

# Das Werkzeug in einem eigenen Prozess starten. Listenform, damit keine
# Anfuehrungszeichen durch eine Kommandozeilenschicht muessen.
sub lauf
{
	my ($mbx) = @_;
	open my $p, '-|', $^X, $werkzeug, $mbx or die "Start: $!";
	my $t = do { local $/; <$p> };
	close $p;
	return defined $t ? $t : '';
}

# Die Ausgabe von taboo-rechnen.pl zerlegen.
#   "  <pfad>: 3 Nachricht(en)"
#   "  3 Nachrichten mit Kopfteil ausgewertet"
#   "  VERSTECKT ..." / "  BLEIBT STEHEN ..." und darunter "    12x  Name"
sub auswerten
{
	my ($ausgabe) = @_;
	my ($anz, $ausgewertet) = (0, 0);
	my (%v, %u);
	my $abschnitt = '';

	for my $z (split /\r?\n/, $ausgabe)
	{
		if ($z =~ /:\s+(\d+)\s+Nachricht\(en\)/)              { $anz = $1; next; }
		if ($z =~ /^\s*(\d+)\s+Nachrichten mit Kopfteil/)     { $ausgewertet = $1; next; }
		if ($z =~ /VERSTECKT/)                                { $abschnitt = 'v'; next; }
		if ($z =~ /BLEIBT STEHEN/)                            { $abschnitt = 'u'; next; }
		if ($z =~ /^\s+(\d+)x\s+(\S.*?)\s*$/)
		{
			my ($zahl, $name) = ($1, $2);
			if    ($abschnitt eq 'v') { $v{$name} = $zahl; }
			elsif ($abschnitt eq 'u') { $u{$name} = $zahl; }
		}
	}

	return ($anz, $ausgewertet, \%v, \%u);
}

sub karte2text
{
	my ($h) = @_;
	return join(', ', map { "$_=$h->{$_}" } sort keys %$h);
}
