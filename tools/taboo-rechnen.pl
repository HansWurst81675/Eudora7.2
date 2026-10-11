#!/usr/bin/perl
use strict;
use warnings;
use FindBin;

# taboo-rechnen.pl - was der Knopf "Blah Blah Blah" an einer ECHTEN Nachricht
# ausrichtet, ohne Eudora zu starten.
#
#   perl tools/taboo-rechnen.pl <postfach.mbx>
#
#   TABOO=<datei>   liest die Liste aus der ersten Zeile dieser Datei,
#                   statt sie aus EudoraRes.rc zu holen
#
# Gregor am 11.09.2026, zwei Bildschirmfotos: die Schaltflaeche heisst laut
# Statuszeile "Shows/hides non-important headers", und im Nachrichtenfenster
# stehen trotzdem Authentication-Results und DKIM-Signature.
#
# Der Filter ist ein PRAEFIXVERGLEICH, nicht mehr:
#   strnicmp( Listeneintrag, Kopfzeile, Laenge(Listeneintrag) )
# (TridentReadMessageView.cpp:2465, gleichlautend ReadMessageDoc.cpp:504)
#
# Also laesst sich ohne Programm ausrechnen, welche Kopfzeile ueberlebt.
#
# ------------------------------------------------------------------------
# NACHGEPRUEFT AM 11.09.2026 (PRUEFER), Gegenprobe: tools/taboo-rechnen-tests.pl
#
# Die Pruefung hat 18 Faelle gegen den C-Code gefahren; sieben davon rechnete
# dieses Werkzeug anders als Eudora. Sechs sind hier abgestellt:
#
# 1. DIE LISTE KAM NICHT AUS DER QUELLE. Eingebaut war die Liste von 2006 mit
#    28 Eintraegen; EudoraRes.rc fuehrt inzwischen 44. Wer ohne TABOO rechnete,
#    bekam an In.mbx 62 "ueberlebende" Kopfzeilennamen statt 7 - also genau
#    die Aussage, die der Befund E-80 widerlegt hat. Die Liste wird jetzt aus
#    EudoraRes.rc gelesen; gibt es sie dort nicht, bricht das Werkzeug ab,
#    statt still mit einer veralteten Kopie weiterzurechnen
#    (Lehre "Pruefumfang nicht von Hand").
# 2. EINE KOPFZEILE OHNE DOPPELPUNKT beendet im C-Code die GESAMTE
#    Kopfzeilenverarbeitung ("no more headers", TridentReadMessageView.cpp
#    :2454-2458; in ReadMessageDoc.cpp:491-494 setzt sie GetOut). Hier wurde
#    nur die eine Zeile uebersprungen.
# 3./4. DER NAME VOR DEM DOPPELPUNKT durfte nur aus [A-Za-z0-9_-] bestehen.
#    Der C-Code laesst jedes Zeichen zu; "X.Foo: bar" und "X-Spam Flag: YES"
#    wurden deshalb gar nicht betrachtet.
# 5. DIE LETZTE NACHRICHT OHNE LEERZEILE nach dem Kopf fiel stillschweigend
#    weg. Eudora nimmt in dem Fall alles als Kopfteil (FindBody,
#    msgutils.cpp:333; GetMessageForDisplay, MimeStorage.cpp:422).
# 6. EIN VORSPANN VOR DER ERSTEN TRENNERZEILE wurde als Nachricht gezaehlt,
#    sobald er irgendwo einen Doppelpunkt enthielt. Jetzt entscheidet, ob die
#    Datei mit der Trennerzeile beginnt - das ist die Frage, um die es geht.
#
# EINE ABWEICHUNG BLEIBT, BEWUSST: steht die Trennerzeichenkette am Anfang
# einer Zeile im NACHRICHTENKOERPER, taeuscht sie hier eine weitere Nachricht
# vor. Eudora findet seine Nachrichten ueber die Offsets in der .toc-Datei
# und sucht den Koerper nie nach Kopfzeilen ab. Ohne die .toc auszuwerten ist
# das von aussen nicht zu unterscheiden. Gemessen an den sieben echten
# Postfaechern (134 Nachrichten) kommt die Zeichenkette 134 mal vor und jedes
# Mal als echter Trenner - heute also folgenlos. Das Werkzeug sagt am Ende,
# wie viele Teile ohne erkennbare Kopfzeile es gefunden hat; eine Zahl
# groesser 0 ist der Hinweis auf genau diesen Fall.
# ------------------------------------------------------------------------

my $BS = chr(92);

# ------------------------------------------------------------- die Liste

my @taboo;
my $woher;

if ($ENV{TABOO})
{
	open my $q, '<:raw', $ENV{TABOO} or die "TABOO=$ENV{TABOO}: $!\n";
	my $l = <$q>;
	close $q;
	die "TABOO=$ENV{TABOO} ist leer.\n" unless defined $l;
	$l =~ s/\r?\n\z//;
	@taboo = split /,/, $l, -1;
	$woher = $ENV{TABOO};
}
else
{
	my $rc = "$FindBin::Bin/../Eudora71/Eudora/EudoraRes.rc";
	open my $q, '<:raw', $rc or die
		"$rc: $!\n" .
		"Ohne die Ressource ist die Liste nicht bekannt. Entweder aus dem\n" .
		"Arbeitsbaum heraus aufrufen oder die Liste ueber TABOO=<datei> angeben.\n";
	my $marke = '"TabooHeaders' . $BS . 'n';
	my $n = 0;
	while (my $z = <$q>)
	{
		$n++;
		my $p = index($z, $marke);
		next if $p < 0;
		my $rest = substr($z, $p + length($marke));
		my $ende = index($rest, '"');
		next if $ende < 0;
		@taboo = split /,/, substr($rest, 0, $ende), -1;
		$woher = "$rc:$n";
		last;
	}
	close $q;
	die "In $rc steht keine Zeichenkette TabooHeaders.\n" unless defined $woher;
}

my ($mbx) = @ARGV;
die "Aufruf: taboo-rechnen.pl <postfach.mbx>\n" unless $mbx && -f $mbx;

open my $h, '<:raw', $mbx or die "$mbx: $!\n";
my $t = do { local $/; <$h> };
close $h;

# -------------------------------------------------- Nachrichten abgrenzen

my $TRENNER = 'From ' . ('?' x 3) . '@' . ('?' x 3);

# Vor jeder Trennerzeile schneiden; die Trennerzeile bleibt am Anfang ihres
# Teils stehen.
my @n = split /(?=^\Q$TRENNER\E)/m, $t;

# Was vor der ERSTEN Trennerzeile steht, ist keine Nachricht - egal ob ein
# Doppelpunkt darin vorkommt. Entscheidend ist allein, ob die Datei mit der
# Trennerzeile beginnt.
shift @n if @n && substr($n[0], 0, length $TRENNER) ne $TRENNER;

printf "  %s: %d Nachricht(en)\n", $mbx, scalar @n;
printf "  Liste aus %s: %d Eintraege\n\n", $woher, scalar @taboo;

my (%ueberlebt, %versteckt);
my $geprueft = 0;
my $ohne_kopf = 0;

for my $m (@n)
{
	# Die Trennerzeile selbst gehoert nicht zum Kopf.
	my $rest = $m;
	$rest =~ s/\A[^\n]*\n//;

	# Der Kopfteil endet an der ersten Leerzeile. Findet sich keine, ist
	# alles Kopfteil - so macht es Eudora auch (FindBody, msgutils.cpp:333).
	my ($kopf) = $rest =~ /\A(.*?)\r?\n\r?\n/s;
	$kopf = $rest unless defined $kopf;

	my $zeilen_gesehen = 0;

	for my $z (split /\r?\n/, $kopf)
	{
		next if $z =~ /^[ \t]/;          # Fortsetzungszeile, hat keinen eigenen Namen

		# Der Doppelpunkt wird nur bis zum Zeilenende gesucht. Fehlt er, ist
		# der Kopfteil zu Ende - und zwar ganz, nicht nur diese Zeile.
		my $dp = index($z, ':');
		last if $dp < 0;

		my $name = substr($z, 0, $dp);
		$zeilen_gesehen++;

		my $tab = 0;
		for my $e (@taboo)
		{
			if (lc(substr($z, 0, length $e)) eq lc($e)) { $tab = 1; last }
		}
		if ($tab) { $versteckt{$name}++ } else { $ueberlebt{$name}++ }
	}

	if   ($zeilen_gesehen) { $geprueft++ }
	else                   { $ohne_kopf++ }
}

printf "  %d Nachrichten mit Kopfteil ausgewertet\n\n", $geprueft;

print "  VERSTECKT der Knopf (steht auf der Liste):\n";
for my $k (sort { $versteckt{$b} <=> $versteckt{$a} || $a cmp $b } keys %versteckt)
{
	printf "    %4dx  %s\n", $versteckt{$k}, $k;
}

print "\n  BLEIBT STEHEN (nicht auf der Liste):\n";
for my $k (sort { $ueberlebt{$b} <=> $ueberlebt{$a} || $a cmp $b } keys %ueberlebt)
{
	printf "    %4dx  %s\n", $ueberlebt{$k}, $k;
}

if ($ohne_kopf)
{
	printf "\n  ACHTUNG: %d Teil(e) ohne erkennbare Kopfzeile. Wahrscheinlich steht\n", $ohne_kopf;
	print "  die Trennerzeichenkette am Anfang einer Zeile im Nachrichtenkoerper.\n";
	print "  Eudora wuerde dort keine Nachricht sehen - es findet seine Nachrichten\n";
	print "  ueber die Offsets der .toc-Datei.\n";
}

exit 0;
