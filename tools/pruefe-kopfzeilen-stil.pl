#!/usr/bin/perl
#
# Schranke zu BEFUND E-81: die Kopfzeilen brauchen im Stylesheet eine eigene
# Regel, die Vordergrund UND Hintergrund setzt.
#
#   perl tools/pruefe-kopfzeilen-stil.pl            prueft und meldet
#   perl tools/pruefe-kopfzeilen-stil.pl --leise    nur Rueckgabewert
#   perl tools/pruefe-kopfzeilen-stil.pl --zeigen   gibt das Stylesheet aus
#
# Rueckgabe 0 = kein Mangel, 1 = Mangel gefunden, 2 = Aufruffehler.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Die Kopfzeilen einer Nachricht werden nicht in ein eigenes Fenster
# geschrieben, sondern als <SPAN CLASS=EUDORAHEADER> in DASSELBE
# HTML-Dokument wie die Nachricht selbst
# (CTridentReadMessageView::WriteHeaders, TridentReadMessageView.cpp).
# Wenn das Stylesheet fuer diese Klasse keine Regel hat, erben die
# Kopfzeilen den Hintergrund der Mail - und auf einer Mail mit dunklem
# Hintergrund stehen sie dann unsichtbar da.
#
# DIE FALLE, DIE HIER BEWACHT WIRD: das Stylesheet ist keine feste
# Zeichenkette, sondern eine FORMATVORLAGE. Sie laeuft durch CString::Format
# (TridentView.cpp:1329-1332) mit einer festen Zahl von Argumenten. Jedes
# zusaetzliche Prozentzeichen in einer neuen Regel greift in den falschen
# Platzhalter - Format liest dann ein Argument, das es nicht gibt. Das ist
# kein Schoenheitsfehler, das ist ein Absturz oder Datenmuell in der Anzeige,
# und er faellt beim Uebersetzen nicht auf.
#
# Ein CSS-Prozentzeichen ist trotzdem moeglich: es muss dann als %% in der
# Ressource stehen. Diese Schranke laesst %% ausdruecklich zu und meldet nur
# ein einzelnes %, das nicht zu einem Platzhalter gehoert.
#
# WAS GEPRUEFT WIRD
#
# 1. Die Zeichenkette MessageStyleSheet gibt es in EudoraRes.rc.
# 2. Sie traegt eine Regel fuer die Klasse EUDORAHEADER.
# 3. Diese Regel setzt color UND background-color. Nur eines von beiden ist
#    der halbe Befund: wer nur die Schriftfarbe setzt, hat die Kopfzeilen auf
#    hellem Grund gerettet und auf dunklem verloren, oder umgekehrt.
# 4. Der Klassenname stimmt mit IDS_EUDORAHEADER ueberein - das ist die
#    Zeichenkette, die WriteHeaders wirklich ins HTML schreibt. Zwei Namen,
#    die auseinanderlaufen, ergeben eine Regel, die nie greift.
# 5. Die Zahl der Platzhalter %s stimmt mit der Zahl der Argumente ueberein,
#    die TridentView.cpp an Format uebergibt. DIE ZAHL WIRD AUS DER QUELLE
#    GEZAEHLT, nicht hier eingetragen (Lehre "Pruefumfang nicht von Hand").
# 6. Es gibt kein einzelnes Prozentzeichen ausserhalb eines Platzhalters.
#
# WAS DIESE SCHRANKE NICHT PRUEFT: eine read.css neben der Eudora.exe und ein
# Eintrag MessageStyleSheet in der Eudora.ini ersetzen die Ressource zur
# Laufzeit vollstaendig (TridentView.cpp:1310-1325). Was der Anwender dort
# stehen hat, kann kein Werkzeug im Repo wissen.
#
# GEGENPROBE: tools/pruefe-kopfzeilen-stil-tests.pl. Wer diese Datei anfasst,
# laesst die Sammlung laufen (Lehre "Schranke gegentesten").

use strict;
use warnings;

my $leise  = 0;
my $zeigen = 0;
for my $a (@ARGV)
{
	if    ($a eq '--leise')  { $leise = 1 }
	elsif ($a eq '--zeigen') { $zeigen = 1 }
	else { print STDERR "Unbekannte Angabe: $a\n"; exit 2 }
}

my $wurzel = $ENV{PRUEFWURZEL};
if (!defined $wurzel || $wurzel eq '')
{
	$wurzel = `git rev-parse --show-toplevel 2>&1`;
	chomp $wurzel;
	if ($? != 0 || !-d $wurzel) { print STDERR "Kein git-Arbeitsbaum und kein PRUEFWURZEL.\n"; exit 2 }
}
chdir $wurzel or do { print STDERR "chdir $wurzel: $!\n"; exit 2 };

my $RES_RC = 'Eudora71/Eudora/EudoraRes.rc';
my $TVIEW  = 'Eudora71/Eudora/TridentView.cpp';

unless (-f $RES_RC) { print STDERR "$RES_RC fehlt.\n"; exit 2 }

my $BS = chr(92);

# ------------------------------------------------- Zeichenketten aus der .rc

# In einer .rc steht ein Anfuehrungszeichen INNERHALB einer Zeichenkette als
# "". Ein Parser, der beim ersten " abbricht, schneidet das Stylesheet mitten
# in BODY {font-family=""%s""} ab und meldet dann Unsinn.
sub rc_zeichenkette
{
	my ($zeile, $start) = @_;
	my $aus = '';
	my $i = $start;
	my $n = length $zeile;
	while ($i < $n)
	{
		my $c = substr($zeile, $i, 1);
		if ($c eq '"')
		{
			if ($i + 1 < $n && substr($zeile, $i + 1, 1) eq '"')
			{
				$aus .= '"';
				$i += 2;
				next;
			}
			return ($aus, $i);
		}
		$aus .= $c;
		$i++;
	}
	return (undef, $i);
}

# In der .rc stehen Zeilenumbrueche als die ZEICHEN Backslash-r und
# Backslash-n. Der Ressourcenuebersetzer macht daraus echte Bytes; wer das
# hier nicht nachmacht, sieht vor SPAN.EUDORAHEADER ein 'n' statt eines
# Zeilenumbruchs und findet die Regel nicht. Genau das ist beim ersten Lauf
# dieser Schranke passiert - Fehlalarm auf der heilen Fassung.
sub escapes_aufloesen
{
	my ($t) = @_;
	my $aus = '';
	my $i = 0;
	my $n = length $t;
	while ($i < $n)
	{
		my $c = substr($t, $i, 1);
		if ($c ne $BS) { $aus .= $c; $i++; next }
		my $e = ($i + 1 < $n) ? substr($t, $i + 1, 1) : '';
		if    ($e eq 'r')  { $aus .= chr(13) }
		elsif ($e eq 'n')  { $aus .= chr(10) }
		elsif ($e eq 't')  { $aus .= chr(9) }
		elsif ($e eq $BS)  { $aus .= $BS }
		elsif ($e eq '"')  { $aus .= '"' }
		elsif ($e eq '0')  { $aus .= ' ' }
		else               { $aus .= $c . $e }
		$i += 2;
	}
	return $aus;
}

my $stil;
my $rc_zeile = 0;
{
	open my $fh, '<:raw', $RES_RC or do { print STDERR "$RES_RC: $!\n"; exit 2 };
	my $n = 0;
	while (my $z = <$fh>)
	{
		$n++;
		my $marke = '"MessageStyleSheet' . $BS . 'n';
		my $p = index($z, $marke);
		next if $p < 0;
		my ($text) = rc_zeichenkette($z, $p + length($marke));
		next unless defined $text;
		$stil = escapes_aufloesen($text);
		$rc_zeile = $n;
		last;
	}
	close $fh;
}

if (!defined $stil)
{
	unless ($leise)
	{
		print "MessageStyleSheet: die Zeichenkette steht nicht mehr in $RES_RC.\n\n";
		print <<'ENDE';
WAS FEHLT     Die Ressourcenzeichenkette "MessageStyleSheet" (Kennung
              IDS_INI_READMESSAGE_STYLE_SHEET).
WARUM         Ohne sie hat das erzeugte HTML gar kein Stylesheet: weder die
              Schriftarten noch die Zitatbalken noch die Regel fuer die
              Kopfzeilen. Die Kopfzeilen erben dann den Hintergrund der
              Mail - Befund E-81.
WAS ZU TUN    Die Zeichenkette wiederherstellen; sie beginnt mit
              "MessageStyleSheet" gefolgt von einem Zeilenumbruch-Escape und
              dem HTML-Kopf.
ENDE
	}
	exit 1;
}

if ($zeigen)
{
	print $stil, "\n";
	exit 0;
}

my @mangel;

# ------------------------------------- die Regel fuer die Kopfzeilenklasse

# Welchen Klassennamen schreibt das Programm wirklich ins HTML?
my $klasse = 'EUDORAHEADER';
{
	open my $fh, '<:raw', $RES_RC or do { print STDERR "$RES_RC: $!\n"; exit 2 };
	while (my $z = <$fh>)
	{
		next unless $z =~ /^\s*IDS_EUDORAHEADER\s+"([^"]+)"/;
		$klasse = $1;
		last;
	}
	close $fh;
}

my $regel;
{
	# SPAN.EUDORAHEADER { ... } oder .EUDORAHEADER { ... }
	if ($stil =~ /(?:^|[\s>])[A-Za-z]*\.\Q$klasse\E\s*\{([^}]*)\}/i)
	{
		$regel = $1;
	}
}

if (!defined $regel)
{
	push @mangel, "es gibt keine Regel fuer die Klasse $klasse. Die Kopfzeilen stehen als <SPAN CLASS=$klasse> im selben Dokument wie die Nachricht und erben dann deren Hintergrund - auf einer dunkel gestalteten Mail sind sie unsichtbar (Befund E-81).";
}
else
{
	my $hat_vg = ($regel =~ /(?:^|[;\s])color\s*:/i)            ? 1 : 0;
	my $hat_hg = ($regel =~ /(?:^|[;\s])background-color\s*:/i) ? 1 : 0;

	push @mangel, "die Regel fuer $klasse setzt kein color. Ohne Vordergrundfarbe erbt die Schrift die der Mail."
		unless $hat_vg;
	push @mangel, "die Regel fuer $klasse setzt kein background-color. GENAU DAS war Befund E-81: die Schriftfarbe allein rettet die Kopfzeilen nur auf hellem Grund."
		unless $hat_hg;
}

# ------------------------------------------- Platzhalter gegen die Argumente

# Wie viele Argumente uebergibt TridentView.cpp an Format? Aus der Quelle
# gezaehlt, nicht hier eingetragen.
my $soll_argumente;
if (-f $TVIEW)
{
	my $t;
	{
		open my $fh, '<:raw', $TVIEW or do { print STDERR "$TVIEW: $!\n"; exit 2 };
		local $/;
		$t = <$fh>;
		close $fh;
	}
	my $p = index($t, 'szStyleSheet.Format(');
	if ($p >= 0)
	{
		my $i = index($t, '(', $p);
		my $tiefe = 0;
		my $kommata = 0;
		for (; $i < length $t; $i++)
		{
			my $c = substr($t, $i, 1);
			$tiefe++ if $c eq '(';
			if ($c eq ')') { $tiefe--; last if $tiefe == 0 }
			$kommata++ if $c eq ',' && $tiefe == 1;
		}
		$soll_argumente = $kommata;
	}
}

if (!defined $soll_argumente)
{
	push @mangel, "in $TVIEW ist der Aufruf szStyleSheet.Format(...) nicht zu finden - dann laesst sich nicht sagen, wie viele Platzhalter das Stylesheet haben darf.";
}

# Platzhalter zaehlen: %% ist ein Prozentzeichen, %s ein Argument, alles
# andere hinter einem % ist verdaechtig.
my @unbekannt;
my $platzhalter = 0;
{
	my $i = 0;
	my $n = length $stil;
	while ($i < $n)
	{
		my $c = substr($stil, $i, 1);
		if ($c ne '%') { $i++; next }
		my $next = ($i + 1 < $n) ? substr($stil, $i + 1, 1) : '';
		if ($next eq '%') { $i += 2; next }
		if ($next eq 's') { $platzhalter++; $i += 2; next }
		push @unbekannt, substr($stil, $i, 8);
		$i += 2;
	}
}

if (@unbekannt)
{
	push @mangel, sprintf("%d Prozentzeichen gehoeren zu keinem Platzhalter: %s. CString::Format liest dafuer ein Argument, das nicht uebergeben wird. Ein Prozentzeichen, das im CSS stehen soll, gehoert als %%%% in die Ressource.",
		scalar @unbekannt, join(', ', map { "'$_'" } @unbekannt));
}

if (defined $soll_argumente && $platzhalter != $soll_argumente)
{
	push @mangel, sprintf("das Stylesheet hat %d Platzhalter %%s, %s uebergibt aber %d Argumente an Format. Jede Abweichung verschiebt die Zuordnung; zu viele Platzhalter lesen ueber das Ende der Argumentliste hinaus.",
		$platzhalter, $TVIEW, $soll_argumente);
}

# ------------------------------------------------------------------ Ergebnis

if (@mangel)
{
	unless ($leise)
	{
		printf "MessageStyleSheet (%s:%d): %d Mangel.\n\n", $RES_RC, $rc_zeile, scalar @mangel;
		print "  $_\n\n" for @mangel;
		print <<"ENDE";
WARUM ES ZAEHLT
  Kopfzeilen und Nachrichtentext stehen im selben HTML-Dokument. Ohne eigene
  Regel uebernehmen die Kopfzeilen die Farben der Mail, und die bestimmt der
  Absender. Auf einer dunkel gestalteten Mail verschwinden sie (Befund E-81).
  Und weil das Stylesheet durch CString::Format laeuft, ist jedes zusaetzliche
  Prozentzeichen darin ein Fehler, den erst der Anwender sieht.

WAS ZU TUN
  Die Regel gehoert in die Zeichenkette MessageStyleSheet in
  Eudora71/Eudora/EudoraRes.rc, vor dem schliessenden </STYLE>:

      SPAN.$klasse {color:black; background-color:white; color:windowtext; background-color:window;}

  Die Wiederholung ist Absicht: die beiden Systemfarben kommen zuletzt und
  gewinnen dort, wo sie verstanden werden; die festen Farben bleiben als
  Rueckfall stehen. Ohne Prozentzeichen.
  Das derzeitige Stylesheet zeigt:  perl tools/pruefe-kopfzeilen-stil.pl --zeigen
ENDE
	}
	exit 1;
}

printf "MessageStyleSheet: Regel fuer %s setzt Vorder- und Hintergrund, %d Platzhalter zu %d Argumenten, kein loses Prozentzeichen.\n",
	$klasse, $platzhalter, $soll_argumente unless $leise;
exit 0;
