#!/usr/bin/perl
#
# Schranke zu BEFUND E-80, TEIL 2: der Knopf "Blah Blah Blah" muss seinen
# eigenen Zustand umschalten, bevor er ihn liest.
#
#   perl tools/pruefe-blahblah-knopf.pl            prueft und meldet
#   perl tools/pruefe-blahblah-knopf.pl --leise    nur Rueckgabewert
#   perl tools/pruefe-blahblah-knopf.pl -v         zeigt jede gefundene Ansicht
#
# Rueckgabe 0 = kein Mangel, 1 = Mangel gefunden, 2 = Aufruffehler.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Gregor am 11.09.2026 an 1.0.45: "header schaut jetzt kuerzer aus. aber: der
# bla bla button aendert nichts."
#
# Der Knopf steht als TBBS_CHECKBOX in der Leiste des Nachrichtenrahmens
# (ReadMessageFrame.cpp:179), sein Zustand ist das Bit TBBS_CHECKED, gelesen
# von CReadMessageFrame::GetCheck (:981-998). Gesetzt wurde das Bit genau
# einmal: beim Anlegen des Fensters (:498-503). Der Klick geht nicht an den
# Rahmen, sondern an die ANSICHT (ON_BN_CLICKED). Beide Ansichten lasen den
# Zustand - und keine setzte ihn. Also stand er in jedem Lauf auf 0, und der
# Knopf tat nichts.
#
# Im Original erledigte das die Stingray-Leiste beim Klick selbst. Der
# OTShim-Ersatz setzt TBBS_CHECKED nur ueber SECToolBarCmdUI::SetCheck
# (OTShim_Werkzeugleiste.cpp:2742), also ueber ON_UPDATE_COMMAND_UI - und so
# einen Eintrag gibt es fuer ID_BLAHBLAHBLAH nirgends. Dieselbe Fehlerklasse
# wie E-43 und E-70.
#
# DER UMFANG KOMMT AUS DER QUELLE. Geprueft wird nicht eine von Hand
# gepflegte Liste von zwei Ansichten, sondern JEDE Uebersetzungseinheit, die
# den Klick auf ID_BLAHBLAHBLAH an sich bindet. Kommt morgen eine dritte
# Ansicht dazu und vergisst das Umschalten, meldet diese Schranke sie
# (Lehre "Pruefumfang nicht von Hand").
#
# WAS GEPRUEFT WIRD
#
# 1. Es gibt ueberhaupt mindestens eine Bindung des Klicks. Verschwindet sie,
#    reagiert der Knopf gar nicht mehr - auch ein Rueckfall.
# 2. Zu jeder Bindung gibt es die zugehoerige Funktion OnBlahBlahBlah.
# 3. In deren Rumpf wird umsgButtonSetCheck an den Rahmen geschickt.
# 4. NACH diesem Schicken wird GetCheck(ID_BLAHBLAHBLAH) gelesen. Das ist der
#    eigentliche Punkt: gelesen wurde immer, gesetzt nie. Ein Lesen VOR dem
#    Schicken ist in Ordnung und noetig - damit wird der alte Zustand geholt,
#    um ihn umzudrehen; entscheidend ist, dass danach noch einmal gelesen wird.
# 5. Die registrierte Botschaft gibt es wirklich: RegisterWindowMessage und
#    ein ON_REGISTERED_MESSAGE im Rahmen. Ohne den Eintrag ginge das
#    SendMessage ins Leere, und zwar lautlos.
#
# GELESEN WIRD NUR CODE. Kommentare und Zeichenketten werden vorher
# weggeworfen - sonst zaehlte die Schranke das Wort "GetCheck" aus der
# Begruendung im Kommentar mit und meldete ausgerechnet die behobene Fassung
# (Lehre "Schranke liest nur Code").
#
# GEGENPROBE: tools/pruefe-blahblah-knopf-tests.pl. Wer diese Datei anfasst,
# laesst die Sammlung laufen (Lehre "Schranke gegentesten").

use strict;
use warnings;

my $leise = 0;
my $laut  = 0;
for my $a (@ARGV)
{
	if    ($a eq '--leise') { $leise = 1 }
	elsif ($a eq '-v')      { $laut = 1 }
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

my $QUELLVERZ = 'Eudora71/Eudora';
unless (-d $QUELLVERZ) { print STDERR "$QUELLVERZ fehlt.\n"; exit 2 }

# ------------------------------------------------------------------ Werkzeug

# Wirft Kommentare und Zeichenketten weg, laesst aber jedes Zeichen an
# seinem Platz (durch Leerzeichen ersetzt). So bleiben Positionen und
# Zeilennummern gueltig, und die Klammerzaehlung stimmt.
sub nur_code
{
	my ($t) = @_;
	my $aus = '';
	my $n = length $t;
	my $i = 0;
	while ($i < $n)
	{
		my $c  = substr($t, $i, 1);
		my $c2 = ($i + 1 < $n) ? substr($t, $i, 2) : '';

		if ($c2 eq '//')
		{
			while ($i < $n && substr($t, $i, 1) ne "\n") { $aus .= ' '; $i++ }
			next;
		}
		if ($c2 eq '/*')
		{
			my $e = index($t, '*/', $i + 2);
			$e = ($e < 0) ? $n : $e + 2;
			while ($i < $e) { my $x = substr($t, $i, 1); $aus .= ($x eq "\n") ? "\n" : ' '; $i++ }
			next;
		}
		if ($c eq '"' || $c eq "'")
		{
			my $q = $c;
			$aus .= ' '; $i++;
			while ($i < $n)
			{
				my $x = substr($t, $i, 1);
				if ($x eq chr(92)) { $aus .= '  '; $i += 2; next }
				$aus .= ($x eq "\n") ? "\n" : ' ';
				$i++;
				last if $x eq $q;
			}
			next;
		}
		$aus .= $c;
		$i++;
	}
	return $aus;
}

sub lies
{
	my ($f) = @_;
	open my $fh, '<:raw', $f or return undef;
	local $/;
	my $t = <$fh>;
	close $fh;
	return $t;
}

# Sucht den Rumpf von <Klasse>::<Funktion>( ... ) { ... } im Codetext und
# gibt Anfang und Ende als Byteversatz zurueck.
sub rumpf
{
	my ($code, $klasse, $funktion) = @_;
	my $marke = $klasse . '::' . $funktion;
	my $p = 0;
	while (($p = index($code, $marke, $p)) >= 0)
	{
		my $nach = substr($code, $p + length($marke), 40);
		# Nur eine Definition, keine Erwaehnung: es muss eine Klammerliste folgen.
		unless ($nach =~ /^\s*\(/) { $p += length($marke); next }
		my $auf = index($code, '{', $p);
		if ($auf < 0) { return () }
		# Zwischen ) und { darf nichts als Leerraum und : (Initialisierer) stehen.
		my $tiefe = 0;
		for (my $i = $auf; $i < length($code); $i++)
		{
			my $c = substr($code, $i, 1);
			$tiefe++ if $c eq '{';
			$tiefe-- if $c eq '}';
			return ($auf, $i) if $tiefe == 0 && $c eq '}';
		}
		return ();
	}
	return ();
}

# ------------------------------------------------------------ die Bindungen

my @dateien;
{
	opendir my $dh, $QUELLVERZ or do { print STDERR "$QUELLVERZ: $!\n"; exit 2 };
	@dateien = sort grep { /\.cpp$/i } readdir $dh;
	closedir $dh;
}

my @mangel;
my @gefunden;   # [ Datei, Klasse, Bindungsart ]

for my $name (@dateien)
{
	my $pfad = "$QUELLVERZ/$name";
	my $roh  = lies($pfad);
	next unless defined $roh;
	next unless index($roh, 'ID_BLAHBLAHBLAH') >= 0;

	my $code = nur_code($roh);

	# Jede Botschaftstabelle einzeln ansehen: BEGIN_MESSAGE_MAP(Klasse, Basis)
	# bis END_MESSAGE_MAP.
	while ($code =~ /BEGIN_MESSAGE_MAP\s*\(\s*(\w+)\s*,\s*\w+\s*\)(.*?)END_MESSAGE_MAP/gs)
	{
		my ($klasse, $tabelle) = ($1, $2);
		my $art;
		my $handler;
		if ($tabelle =~ /ON_BN_CLICKED\s*\(\s*ID_BLAHBLAHBLAH\s*,\s*(\w+)\s*\)/)
		{
			$art = 'ON_BN_CLICKED';
			$handler = $1;
		}
		elsif ($tabelle =~ /ON_COMMAND\s*\(\s*ID_BLAHBLAHBLAH\s*,\s*(\w+)\s*\)/)
		{
			$art = 'ON_COMMAND';
			$handler = $1;
		}
		next unless defined $art;

		push @gefunden, [ $pfad, $klasse, $art, $handler ];

		my ($a, $e) = rumpf($code, $klasse, $handler);
		if (!defined $a)
		{
			push @mangel, "$pfad: $klasse bindet den Klick an $handler, aber $klasse\::$handler hat in dieser Datei keinen Rumpf.";
			next;
		}
		my $r = substr($code, $a, $e - $a + 1);

		my $setz = -1;
		if ($r =~ /SendMessage\s*\(\s*umsgButtonSetCheck\b/)
		{
			$setz = $-[0];
		}
		if ($setz < 0)
		{
			push @mangel, "$pfad: $klasse\::$handler schickt kein SendMessage(umsgButtonSetCheck, ...) - der Knopfzustand wird nie umgeschaltet. Genau das war Befund E-80, Teil 2.";
			next;
		}

		my $danach = substr($r, $setz);
		unless ($danach =~ /GetCheck\s*\(\s*ID_BLAHBLAHBLAH\s*\)/)
		{
			push @mangel, "$pfad: $klasse\::$handler schickt zwar umsgButtonSetCheck, liest danach aber kein GetCheck(ID_BLAHBLAHBLAH) mehr. Dann arbeitet die Ansicht mit dem alten Zustand weiter.";
		}
	}
}

if (!@gefunden)
{
	push @mangel, "keine einzige Botschaftstabelle bindet den Klick auf ID_BLAHBLAHBLAH. Der Knopf reagiert dann gar nicht mehr.";
}

# --------------------------------------------- die registrierte Botschaft

{
	my $rahmen = "$QUELLVERZ/ReadMessageFrame.cpp";
	my $roh = lies($rahmen);
	if (!defined $roh)
	{
		push @mangel, "$rahmen fehlt - dort wird umsgButtonSetCheck registriert und behandelt.";
	}
	else
	{
		# Hier bewusst der ROHE Text: RegisterWindowMessage nimmt eine
		# Zeichenkette, und die wirft nur_code gerade weg.
		unless ($roh =~ /umsgButtonSetCheck\s*=\s*RegisterWindowMessage\s*\(\s*"umsgButtonSetCheck"\s*\)/)
		{
			push @mangel, "$rahmen: umsgButtonSetCheck wird nicht mehr mit RegisterWindowMessage(\"umsgButtonSetCheck\") angelegt.";
		}
		my $code = nur_code($roh);
		unless ($code =~ /ON_REGISTERED_MESSAGE\s*\(\s*umsgButtonSetCheck\s*,/)
		{
			push @mangel, "$rahmen: es gibt keinen ON_REGISTERED_MESSAGE-Eintrag fuer umsgButtonSetCheck. Das SendMessage aus der Ansicht laeuft dann ins Leere, ohne Fehlermeldung.";
		}
	}
}

# ------------------------------------------------------------------ Ergebnis

if ($laut && !$leise)
{
	printf "Gefundene Bindungen des Klicks auf ID_BLAHBLAHBLAH: %d\n", scalar @gefunden;
	printf "  %-44s %-28s %-14s %s\n", @$_[0 .. 3] for @gefunden;
	print "\n";
}

if (@mangel)
{
	unless ($leise)
	{
		printf "Knopf \"Blah Blah Blah\": %d Mangel.\n\n", scalar @mangel;
		print "  $_\n\n" for @mangel;
		print <<'ENDE';
WARUM ES ZAEHLT
  Der Knopf ist eine TBBS_CHECKBOX. Sein Zustand steckt im Bit TBBS_CHECKED
  im Rahmen, nicht in der Ansicht. Setzt ihn niemand, liest jede Ansicht
  ewig dieselbe 0 - der Knopf laesst sich druecken und tut nichts. Das
  faellt weder beim Bauen noch beim Starten auf; es faellt erst einem
  Menschen auf, der ihn drueckt.

WAS ZU TUN
  Am Anfang von OnBlahBlahBlah den alten Zustand holen und umgedreht an den
  Rahmen schicken, bevor er gelesen wird:

      extern UINT umsgButtonSetCheck;
      BOOL bVorher = pParentFrame->GetCheck(ID_BLAHBLAHBLAH);
      pParentFrame->SendMessage(umsgButtonSetCheck, ID_BLAHBLAHBLAH,
                                bVorher ? FALSE : TRUE);

  Dasselbe Muster benutzt summary.cpp:2518-2520 fuer zwei andere Knoepfe.
  Welche Ansichten betroffen sind, zeigt:
      perl tools/pruefe-blahblah-knopf.pl -v
ENDE
	}
	exit 1;
}

printf "Knopf \"Blah Blah Blah\": %d Ansicht(en) binden den Klick, jede setzt den Zustand, bevor sie ihn liest.\n",
	scalar @gefunden unless $leise;
exit 0;
