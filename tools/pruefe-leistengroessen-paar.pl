#!/usr/bin/perl
#
# Schranke zu BEFUND E-84: was GroessenSichern schreibt, muss GroessenLaden
# lesen - und beide muessen auf dem Weg liegen, den Eudora wirklich geht.
#
#   perl tools/pruefe-leistengroessen-paar.pl            prueft und meldet
#   perl tools/pruefe-leistengroessen-paar.pl --leise    nur Rueckgabewert
#   perl tools/pruefe-leistengroessen-paar.pl --zeigen   listet die Schluessel
#
# Rueckgabe 0 = kein Mangel, 1 = Mangel, 2 = Aufruffehler.
#
# ------------------------------------------------------------------------
# WAS SCHIEFGING - ZWEIMAL DIESELBE KLASSE
#
# E-70 (Gregor, 10.09.2026): "neustart: das fenster wird auf den default wert
# zurueck gesetzt". Die Andockgroessen WURDEN gesichert - im Protokoll von
# 1.0.40 stehen 40 Zeilen "E-70 gesichert", und in der Eudora.ini stand
# DockVertCx319=586. Gelesen wurde nie: null Zeilen. Der Aufruf von
# GroessenLaden sass in SECToolBarManager::LoadState, und ueber der Funktion
# stand der eigene Kommentar "Eudora ruft diese Fassung nie auf".
#
# E-84 (Gregor, 11.09.2026): "das undocked initiale fenster ist recht klein,
# die groesse (nach der aenderung) wird nach dem schliessen vom filter und
# eudora nicht gespeichert." Der erste Anlauf sass in
# SECControlBarInfo::SaveState - und die wird beim Speichern gar nicht
# durchlaufen: CDockState::SaveState ruft pInfo->SaveState(...) ueber einen
# CControlBarInfo* und NICHT virtuell (dockstat.cpp). Der Einbau war
# fehlerfrei, uebersetzte sauber und bewirkte nichts.
#
# BEIDE MALE dieselbe Fehlerklasse: ein Schluessel, den nur EINE Seite
# kennt. Einmal fehlte das Lesen, einmal das Schreiben. Beide Male gab es
# keinen Fehler, keine Meldung, keinen Unterschied ausser dem, den Gregor
# gesehen hat.
#
# WAS GEPRUEFT WIRD
#
# 1. Es gibt SECToolBarManager::GroessenSichern und ::GroessenLaden.
# 2. PAARIGKEIT: die Menge der Schluesselnamen ist auf beiden Seiten
#    dieselbe. Ein Name nur auf einer Seite ist genau der Fehler.
# 3. Jeder Schluessel in GroessenSichern wird auch wirklich GESCHRIEBEN
#    (WriteProfile*) und jeder in GroessenLaden wirklich GELESEN
#    (GetProfile*). Einen Namen zu bilden und dann nichts damit zu tun,
#    faellt sonst durch die Paarigkeitspruefung durch.
# 4. Die schwebende Groesse kommt auf beiden Seiten vor: GroessenSichern
#    liest m_szFloat, GroessenLaden schreibt es. Ohne diese Pruefung koennte
#    jemand E-84 wieder aufreissen, indem er die Float-Schluessel auf BEIDEN
#    Seiten entfernt - paarig und trotzdem falsch.
# 5. DER LEBENDE WEG: QCToolBarManager::SaveState ruft
#    SECToolBarManager::SaveState (dort steckt GroessenSichern), und
#    QCToolBarManager::LoadState ruft GroessenLaden. Die SEC-eigene
#    LoadState ist Kategorie C - Eudora ruft sie nie auf; ein Aufruf NUR
#    dort ist der Fehler E-70.
# 6. DER ABSCHNITT: der Name des INI-Abschnitts wird an drei Stellen
#    gebildet, in zwei Dateien. Alle drei muessen dieselbe Formatangabe
#    verwenden - sonst schreibt die eine Seite in einen Abschnitt, den die
#    andere nie aufschlaegt.
# 7. In SECControlBarInfo::SaveState und ::LoadState (OTShim.cpp) darf kein
#    Profileintrag geschrieben oder gelesen werden. Diese beiden Funktionen
#    werden nie durchlaufen; wer dort etwas sichert, hat eine Behebung
#    gebaut, die aussieht wie eine und keine ist. Genau dort sass der erste
#    Anlauf zu E-84.
#
# GELESEN WIRD CODE OHNE KOMMENTARE, aber MIT Zeichenketten - die
# Schluesselnamen SIND Zeichenketten. Die Kommentare muessen weg, weil die
# Begruendung der Behebung die alten Namen und den falschen Ort woertlich
# nennt (siehe oben); eine Schranke, die ihre eigene Begruendung anschwaerzt,
# ist unbrauchbar (Lehre "Schranke liest nur Code").
#
# GEGENPROBE: tools/pruefe-leistengroessen-paar-tests.pl.

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

my $LEISTE = 'Eudora71/OTShim/OTShim_Werkzeugleiste.cpp';
my $QCMGR  = 'Eudora71/Eudora/QCToolBarManager.cpp';
my $SHIM   = 'Eudora71/OTShim/OTShim.cpp';

for my $f ($LEISTE, $QCMGR, $SHIM)
{
	unless (-f $f) { print STDERR "$f fehlt.\n"; exit 2 }
}

# ------------------------------------------------------------------ Werkzeug

# Wirft NUR die Kommentare weg und laesst Zeichenketten stehen - die
# Schluesselnamen sind Zeichenketten. Jedes Zeichen bleibt an seinem Platz,
# Zeilennummern bleiben gueltig.
sub ohne_kommentare
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
		# Zeichenketten unveraendert uebernehmen, damit ein // oder /* darin
		# nicht als Kommentaranfang gilt.
		if ($c eq '"' || $c eq "'")
		{
			my $q = $c;
			$aus .= $c; $i++;
			while ($i < $n)
			{
				my $x = substr($t, $i, 1);
				if ($x eq chr(92)) { $aus .= substr($t, $i, 2); $i += 2; next }
				$aus .= $x;
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

sub klammer_ende
{
	my ($t, $auf) = @_;
	my $tiefe = 0;
	for (my $i = $auf; $i < length $t; $i++)
	{
		my $c = substr($t, $i, 1);
		$tiefe++ if $c eq '{';
		if ($c eq '}')
		{
			$tiefe--;
			return $i if $tiefe == 0;
		}
	}
	return -1;
}

# Rumpf einer Funktion holen. Liefert undef, wenn es sie nicht gibt.
sub rumpf_von
{
	my ($code, $muster) = @_;
	return undef unless $code =~ /$muster\s*\([^)]*\)\s*(?:const\s*)?\{/;
	my $auf = $+[0] - 1;
	my $zu  = klammer_ende($code, $auf);
	return undef if $zu < 0;
	return substr($code, $auf, $zu - $auf + 1);
}

sub lies_roh
{
	my ($f) = @_;
	open my $fh, '<:raw', $f or do { print STDERR "$f: $!\n"; exit 2 };
	local $/;
	my $t = <$fh>;
	close $fh;
	return $t;
}

# ------------------------------------------------------------------ Einlesen

my $leiste = ohne_kommentare(lies_roh($LEISTE));
my $qcmgr  = ohne_kommentare(lies_roh($QCMGR));
my $shim   = ohne_kommentare(lies_roh($SHIM));

my @mangel;

# ------------------------------------------------- 1. Die beiden Funktionen

my $sichern = rumpf_von($leiste, 'void\s+SECToolBarManager::GroessenSichern');
my $laden   = rumpf_von($leiste, 'void\s+SECToolBarManager::GroessenLaden');

push @mangel, "SECToolBarManager::GroessenSichern steht nicht mehr in $LEISTE. Dann wird die Groesse einer Leiste nirgends aufgezeichnet - E-70 und E-84 sind wieder offen."
	unless defined $sichern;
push @mangel, "SECToolBarManager::GroessenLaden steht nicht mehr in $LEISTE. Dann wird das Aufgezeichnete nie zurueckgeholt; geschrieben wird weiter, gelesen nie - genau der Zustand, den Gregor an 1.0.40 gemeldet hat."
	unless defined $laden;

# Schluessel einsammeln: Name -> Variable, in die er gebildet wird.
sub schluessel_von
{
	my ($rumpf) = @_;
	my @treffer;
	while ($rumpf =~ /OTShimGroessenSchluessel\s*\(\s*(\w+)\s*,[^,]*,\s*_T\s*\(\s*"([^"]*)"\s*\)/g)
	{
		push @treffer, { var => $1, name => $2, pos => $-[0] };
	}
	return @treffer;
}

my @k_schreiben = defined $sichern ? schluessel_von($sichern) : ();
my @k_lesen     = defined $laden   ? schluessel_von($laden)   : ();

my %schreiben = map { $_->{name} => 1 } @k_schreiben;
my %lesen     = map { $_->{name} => 1 } @k_lesen;

if ($zeigen)
{
	printf "GroessenSichern schreibt: %s\n", join(', ', sort keys %schreiben) || '(nichts)';
	printf "GroessenLaden liest:      %s\n", join(', ', sort keys %lesen)     || '(nichts)';
}

# ------------------------------------------------- 2. Paarigkeit

if (defined $sichern && defined $laden)
{
	unless (@k_schreiben)
	{
		push @mangel, "GroessenSichern bildet ueberhaupt keinen Schluessel mehr. Dann schreibt es nichts, und jede Groesse ist beim naechsten Start wieder die Vorgabe.";
	}
	for my $n (sort keys %schreiben)
	{
		next if $lesen{$n};
		push @mangel, "der Schluessel '$n' wird in GroessenSichern GESCHRIEBEN, aber in GroessenLaden nie gelesen. Das ist genau die Fehlerklasse hinter E-70 und E-84: der Wert steht in der Eudora.ini und wird beim Start nicht angefasst. Es faellt nichts auf - der Anwender sieht nur wieder die Vorgabegroesse.";
	}
	for my $n (sort keys %lesen)
	{
		next if $schreiben{$n};
		push @mangel, "der Schluessel '$n' wird in GroessenLaden GELESEN, aber in GroessenSichern nie geschrieben. Der Eintrag entsteht nie, GetProfileInt liefert immer den Vorgabewert, und das Lesen ist ein Leerlauf.";
	}
}

# ------------------------------------------------- 3. Bilden ist nicht Tun

sub tut_etwas
{
	my ($rumpf, $treffer, $muster) = @_;
	# Fenster bis zum naechsten Schluesselaufruf oder zum Rumpfende.
	my $anf = $treffer->{pos};
	my $end = length $rumpf;
	if ($rumpf =~ /OTShimGroessenSchluessel\s*\(/g)
	{
		pos($rumpf) = $anf + 1;
		$end = $-[0] if $rumpf =~ /OTShimGroessenSchluessel\s*\(/g;
	}
	my $fenster = substr($rumpf, $anf, $end - $anf);
	my $v = $treffer->{var};
	return $fenster =~ /$muster\s*\([^;]*\b\Q$v\E\b/;
}

if (defined $sichern)
{
	for my $t (@k_schreiben)
	{
		next if tut_etwas($sichern, $t, 'WriteProfile(?:Int|String|Binary)');
		push @mangel, "in GroessenSichern wird der Schluessel '$t->{name}' gebildet, aber danach steht kein WriteProfile-Aufruf mit '$t->{var}'. Ein gebildeter Name allein schreibt nichts.";
	}
}
if (defined $laden)
{
	for my $t (@k_lesen)
	{
		next if tut_etwas($laden, $t, 'GetProfile(?:Int|String|Binary)');
		push @mangel, "in GroessenLaden wird der Schluessel '$t->{name}' gebildet, aber danach steht kein GetProfile-Aufruf mit '$t->{var}'. Ein gebildeter Name allein liest nichts.";
	}
}

# ------------------------------------------------- 4. Die schwebende Groesse

if (defined $sichern)
{
	unless ($sichern =~ /\bm_szFloat\s*\.\s*c[xy]\b/)
	{
		push @mangel, "GroessenSichern liest m_szFloat nicht mehr. m_szFloat IST die Groesse des losgerissenen Fensters (BEFUND E-84); ohne sie ist die Sicherung wieder auf die Andockgroessen beschraenkt, und Gregors Meldung vom 11.09.2026 gilt wieder.";
	}
}
if (defined $laden)
{
	unless ($laden =~ /\bm_szFloat\s*=/)
	{
		push @mangel, "GroessenLaden setzt m_szFloat nicht mehr. Dann wird die schwebende Groesse zwar gesichert, aber beim Start nie zurueckgeholt - das losgerissene Fenster ist wieder so klein wie beim ersten Mal.";
	}
}

# ------------------------------------------------- 5. Der lebende Weg

{
	my $sec_save = rumpf_von($leiste, 'void\s+SECToolBarManager::SaveState');
	if (!defined $sec_save)
	{
		push @mangel, "SECToolBarManager::SaveState steht nicht mehr in $LEISTE.";
	}
	elsif ($sec_save !~ /\bGroessenSichern\s*\(/)
	{
		push @mangel, "SECToolBarManager::SaveState ruft GroessenSichern nicht mehr. Das ist die EINZIGE Fassung, die Eudora beim Speichern durchlaeuft (QCToolBarManager::SaveState ruft sie ausdruecklich); ohne den Aufruf wird nichts mehr aufgezeichnet.";
	}

	my $qc_save = rumpf_von($qcmgr, 'void\s+QCToolBarManager::SaveState');
	if (!defined $qc_save)
	{
		push @mangel, "QCToolBarManager::SaveState steht nicht mehr in $QCMGR.";
	}
	elsif ($qc_save !~ /\bSECToolBarManager::SaveState\s*\(/)
	{
		push @mangel, "QCToolBarManager::SaveState ruft SECToolBarManager::SaveState nicht mehr auf. Damit reisst die Kette zur Sicherung der Groessen; GroessenSichern sieht dann korrekt aus und laeuft nie.";
	}

	my $qc_load = rumpf_von($qcmgr, 'void\s+QCToolBarManager::LoadState');
	if (!defined $qc_load)
	{
		push @mangel, "QCToolBarManager::LoadState steht nicht mehr in $QCMGR.";
	}
	elsif ($qc_load !~ /\bGroessenLaden\s*\(/)
	{
		push @mangel, "QCToolBarManager::LoadState ruft GroessenLaden nicht mehr. GENAU DAS WAR E-70: der Aufruf stand nur in SECToolBarManager::LoadState, und ueber der Funktion steht der eigene Kommentar 'Eudora ruft diese Fassung nie auf'. Geschrieben wurde, gelesen nie.";
	}
}

# ------------------------------------------------- 6. Derselbe Abschnitt

{
	my @formate;

	while ($leiste =~ /szToolBarManagerSection\s*\[\s*\]\s*=\s*_T\s*\(\s*"([^"]*)"\s*\)/g)
	{
		push @formate, [ $LEISTE, $1 ];
	}
	while ($qcmgr =~ /szToolBarManagerSection\s*\[\s*\]\s*=\s*_T\s*\(\s*"([^"]*)"\s*\)/g)
	{
		push @formate, [ $QCMGR, $1 ];
	}

	# Der Abschnitt, den QCToolBarManager::LoadState an GroessenLaden gibt,
	# wird dort unmittelbar davor mit einem eigenen Literal gebildet.
	my $qc_load = rumpf_von($qcmgr, 'void\s+QCToolBarManager::LoadState');
	if (defined $qc_load && $qc_load =~ /\bGroessenLaden\s*\(\s*(\w+)\s*\)/)
	{
		my $v = $1;
		my $vor = substr($qc_load, 0, $-[0]);
		if ($vor =~ /\Q$v\E\s*\.\s*Format\s*\(\s*_T\s*\(\s*"([^"]*)"\s*\)/s)
		{
			push @formate, [ "$QCMGR (an GroessenLaden)", $1 ];
		}
		elsif ($vor =~ /wsprintf\s*\(\s*\Q$v\E\s*,\s*(\w+)/s)
		{
			# ueber eine Konstante gebildet - die steht schon in der Liste.
		}
		else
		{
			push @mangel, "in QCToolBarManager::LoadState laesst sich nicht ablesen, aus welcher Formatangabe der Abschnitt fuer GroessenLaden gebildet wird. Damit ist nicht mehr pruefbar, ob Schreib- und Leseseite denselben Abschnitt treffen.";
		}
	}

	if (@formate < 2)
	{
		push @mangel, "die Formatangabe fuer den INI-Abschnitt ist nur noch an " . scalar(@formate) . " Stelle(n) auffindbar. Sie steht in zwei Dateien; wenn eine davon verschwindet, ist nicht mehr belegt, dass beide Seiten denselben Abschnitt treffen.";
	}
	else
	{
		my %verschieden;
		$verschieden{$_->[1]}++ for @formate;
		if (keys(%verschieden) > 1)
		{
			push @mangel, "der INI-Abschnitt wird aus verschiedenen Formatangaben gebildet: "
				. join('; ', map { "$_->[0] => '$_->[1]'" } @formate)
				. ". Dann schreibt die eine Seite in einen Abschnitt, den die andere nie aufschlaegt - dasselbe Ergebnis wie ein fehlender Schluessel, nur schwerer zu finden.";
		}
	}
}

# ------------------------------------------------- 7. Der tote Ort

for my $fn (qw(SaveState LoadState))
{
	my $r = rumpf_von($shim, "BOOL\\s+SECControlBarInfo::$fn");
	next unless defined $r;
	next unless $r =~ /\b(Write|Get)Profile(?:Int|String|Binary)\s*\(/;
	push @mangel, "SECControlBarInfo::$fn ($SHIM) greift auf das Profil zu. Diese Funktion wird NIE DURCHLAUFEN: CDockState::SaveState ruft pInfo->SaveState(...) ueber einen CControlBarInfo* und nicht virtuell (dockstat.cpp), und CDockState::LoadState legt CControlBarInfo-Objekte an, keine SECControlBarInfo. Genau dort sass der erste, wirkungslose Anlauf zu E-84. Er uebersetzte sauber und bewirkte nichts.";
}

# ------------------------------------------------------------------ Ergebnis

if (@mangel)
{
	unless ($leise)
	{
		printf "Leistengroessen (%s): %d Mangel.\n\n", $LEISTE, scalar @mangel;
		print "  $_\n\n" for @mangel;
		print <<'ENDE';
WARUM ES ZAEHLT
  Die Groesse einer Leiste ueberlebt einen Neustart nur, wenn BEIDE Seiten
  denselben Schluessel im selben Abschnitt benutzen und beide auf dem Weg
  liegen, den Eudora wirklich geht. Faellt eine Seite aus, passiert nichts
  Sichtbares: kein Fehler, keine Meldung, kein Absturz. Der Anwender stellt
  sein Fenster ein, startet neu und sieht wieder die Vorgabe. Genau so lief
  E-70 ueber vier Pakete und E-84 ueber einen ganzen Anlauf, der sauber
  uebersetzte und nichts bewirkte.

WAS ZU TUN
  Jeden Schluessel auf beiden Seiten fuehren - GroessenSichern schreibt ihn,
  GroessenLaden liest ihn, beide in OTShim_Werkzeugleiste.cpp:

      OTShimGroessenSchluessel(szSchluessel, 64, _T("FloatCx"), nId);
      pApp->WriteProfileInt(lpszAbschnitt, szSchluessel, pBar->m_szFloat.cx);
          ... und gegenueber ...
      OTShimGroessenSchluessel(szF, 64, _T("FloatCx"), nId);
      const int cx = pApp->GetProfileInt(lpszAbschnitt, szF, 0);

  Und nichts davon in SECControlBarInfo::SaveState einbauen. Der Ort sieht
  richtig aus und wird nie durchlaufen.
ENDE
	}
	exit 1;
}

unless ($leise)
{
	printf "Leistengroessen: %d Schluessel, auf beiden Seiten deckungsgleich (%s). Lebender Weg und Abschnitt stimmen.\n",
		scalar(keys %schreiben), join(', ', sort keys %schreiben);
}
exit 0;
