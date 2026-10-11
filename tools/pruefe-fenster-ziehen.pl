#!/usr/bin/perl
#
# Schranke gegen den Rueckfall in BEFUND E-76: der abschliessende Aufruf von
# SECControlBar::CalcDynamicLayout darf die Groesse nicht wieder aus nLength
# rechnen.
#
#   perl tools/pruefe-fenster-ziehen.pl            prueft und meldet
#   perl tools/pruefe-fenster-ziehen.pl --leise    nur Rueckgabewert
#
# Rueckgabe 0 = kein Mangel, 1 = Mangel, 2 = Aufruffehler.
#
# Diese Schranke scheitert von Anfang an scharf: die Behebung ist am
# 12.09.2026 in main (Commit c060648, Merge f7e715a) und von Gregor
# bestaetigt. Ein Melden ist also ab sofort ein echter Rueckfall.
#
# ------------------------------------------------------------------------
# WAS SCHIEFGING
#
# Gregor, 10.09.2026, an Paket 1.0.40: "filter fenster laesst sich nicht nach
# unten vergroessern, nur zur seite."
#
# Die Spurmarke E76Marke hat Eingang und Ausgang in EINER Zeile genannt
# (Lehre "Zwei Werte in eine Ausgabe") und damit den Widerspruch geschlossen:
#
#   Beim ZIEHEN kommt dwMode = 0x0022 = LM_LENGTHY|LM_HORZ, und nLength ist
#   die neue HOEHE: 105, 172, 234, 299.
#
#   Der ABSCHLIESSENDE Aufruf kommt mit dwMode = 0x0042 = LM_COMMIT|LM_HORZ,
#   also OHNE LM_LENGTHY - und dort ist nLength die BREITE (780).
#
# Der alte Rumpf sah so aus:
#
#     if (dwMode & LM_LENGTHY)
#         size.cy = max(nLength, 20);
#     else
#         size.cx = max(nLength, 20);       <-- HIER
#
#     if (dwMode & LM_COMMIT)
#         m_szFloat = size;
#
# Der COMMIT-Aufruf fiel in den nackten else-Zweig, setzte die BREITE aus
# nLength neu, liess die Hoehe auf dem alten Wert von m_szFloat stehen - und
# genau das wurde gespeichert. Im Protokoll: 780x299 beim Ziehen, 780x100
# nach dem COMMIT. Die Hoehe sprang also im letzten Augenblick zurueck.
#
# Behoben mit dem Merker m_szZuletztGezogen: jeder Ziehschritt legt die
# gerechnete Groesse dort ab, und der COMMIT nimmt sie von dort, statt aus
# nLength neu zu rechnen.
#
# WAS GEPRUEFT WIRD
#
# 1. Es gibt SECControlBar::CalcDynamicLayout in OTShim.cpp.
# 2. Es gibt den Merker: als Feld in OTShim.h UND mit einer Anfangsbelegung,
#    sonst steht beim ersten COMMIT Zufall drin.
# 3. Im Rumpf gibt es einen Zweig fuer LM_COMMIT, und darin kommt nLength
#    NICHT vor. Das ist der Kern: im COMMIT-Aufruf hat nLength eine andere
#    Bedeutung als beim Ziehen, jede Rechnung daraus ist falsch.
# 4. Der COMMIT-Zweig liest den Merker und schreibt m_szFloat.
# 5. Jede Zuweisung an size.cx/size.cy, die nLength verwendet, steht unter
#    einer Bedingung, die LM_LENGTHY oder LM_COMMIT nennt. Ein nackter
#    else-Zweig - der alte Fehler - faellt hier durch, denn er faengt den
#    COMMIT-Aufruf mit ein.
# 6. Jeder dieser Zweige legt den Merker nach. Ein Zweig, der rechnet aber
#    nicht merkt, laesst den COMMIT auf einem alten Wert sitzen.
#
# GELESEN WIRD NUR CODE. Kommentare und Zeichenketten werden weggeworfen -
# die Begruendung der Behebung zitiert den alten fehlerhaften Code woertlich
# (siehe oben), und eine Schranke, die ihre eigene Begruendung anschwaerzt,
# ist unbrauchbar (Lehre "Schranke liest nur Code").
#
# GEGENPROBE: tools/pruefe-fenster-ziehen-tests.pl.

use strict;
use warnings;

my $leise = 0;
for my $a (@ARGV)
{
	if ($a eq '--leise') { $leise = 1 }
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

my $QUELLE = 'Eudora71/OTShim/OTShim.cpp';
my $KOPF   = 'Eudora71/OTShim/OTShim.h';
my $MERKER = 'm_szZuletztGezogen';

unless (-f $QUELLE) { print STDERR "$QUELLE fehlt.\n"; exit 2 }
unless (-f $KOPF)   { print STDERR "$KOPF fehlt.\n";   exit 2 }

# ------------------------------------------------------------------ Werkzeug

# Wirft Kommentare und Zeichenketten weg und laesst jedes Zeichen an seinem
# Platz. Zeilennummern und Klammerzaehlung bleiben damit gueltig.
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

sub zeilennummer
{
	my ($t, $pos) = @_;
	my $n = 1;
	my $i = 0;
	while (($i = index($t, "\n", $i)) >= 0 && $i < $pos) { $n++; $i++ }
	return $n;
}

# Von der oeffnenden Klammer an den passenden Abschluss suchen.
# Liefert die Stellung der schliessenden Klammer oder -1.
sub klammer_ende
{
	my ($t, $auf, $zu_auf, $zu_zu) = @_;
	my $tiefe = 0;
	for (my $i = $auf; $i < length $t; $i++)
	{
		my $c = substr($t, $i, 1);
		$tiefe++ if $c eq $zu_auf;
		if ($c eq $zu_zu)
		{
			$tiefe--;
			return $i if $tiefe == 0;
		}
	}
	return -1;
}

# Rueckwaerts von $pos aus die Bedingung suchen, unter der die Anweisung an
# $pos steht. Liefert ('if', Bedingungstext), ('else', '') fuer einen nackten
# else-Zweig oder ('keine', '') fuer eine unbedingte Anweisung.
sub beherrschende_bedingung
{
	my ($t, $pos) = @_;

	my $i = $pos - 1;
	# Leerraum und eine oeffnende Rumpfklammer ueberspringen.
	while ($i >= 0 && substr($t, $i, 1) =~ /\s/) { $i-- }
	if ($i >= 0 && substr($t, $i, 1) eq '{')
	{
		$i--;
		while ($i >= 0 && substr($t, $i, 1) =~ /\s/) { $i-- }
	}
	return ('keine', '') if $i < 0;

	my $c = substr($t, $i, 1);

	if ($c eq ')')
	{
		# Zur passenden oeffnenden Klammer zurueck.
		my $tiefe = 0;
		my $auf = -1;
		for (my $j = $i; $j >= 0; $j--)
		{
			my $x = substr($t, $j, 1);
			$tiefe++ if $x eq ')';
			if ($x eq '(')
			{
				$tiefe--;
				if ($tiefe == 0) { $auf = $j; last }
			}
		}
		return ('keine', '') if $auf < 0;

		my $bed = substr($t, $auf + 1, $i - $auf - 1);

		# Davor muss das Wort if stehen.
		my $k = $auf - 1;
		while ($k >= 0 && substr($t, $k, 1) =~ /\s/) { $k-- }
		return ('keine', '') if $k < 1;
		return ('if', $bed) if substr($t, $k - 1, 2) eq 'if'
			&& ($k - 2 < 0 || substr($t, $k - 2, 1) !~ /\w/);
		return ('keine', '');
	}

	if ($i >= 3 && substr($t, $i - 3, 4) eq 'else'
		&& ($i - 4 < 0 || substr($t, $i - 4, 1) !~ /\w/))
	{
		return ('else', '');
	}

	return ('keine', '');
}

# ------------------------------------------------------------------ Einlesen

sub lies_roh
{
	my ($f) = @_;
	open my $fh, '<:raw', $f or do { print STDERR "$f: $!\n"; exit 2 };
	local $/;
	my $t = <$fh>;
	close $fh;
	return $t;
}

my $roh      = lies_roh($QUELLE);
my $code     = nur_code($roh);
my $kopf_roh = lies_roh($KOPF);
my $kopf     = nur_code($kopf_roh);

my @mangel;

# ------------------------------------------------- 1. Die Funktion selbst

my ($rumpf, $rumpf_anfang) = ('', -1);

if ($code =~ /\bCSize\s+SECControlBar::CalcDynamicLayout\s*\([^)]*\)\s*\{/g)
{
	my $auf = $+[0] - 1;
	my $zu  = klammer_ende($code, $auf, '{', '}');
	if ($zu < 0)
	{
		push @mangel, "der Rumpf von SECControlBar::CalcDynamicLayout ist nicht geschlossen.";
	}
	else
	{
		$rumpf_anfang = $auf;
		$rumpf = substr($code, $auf, $zu - $auf + 1);
	}
}
else
{
	push @mangel, "SECControlBar::CalcDynamicLayout steht nicht mehr in $QUELLE. Ohne sie gibt es keine Stelle mehr, an der das Ziehen am schwebenden Fenster ausgewertet wird.";
}

# ------------------------------------------------- 2. Der Merker

unless ($kopf =~ /\bCSize\s+\Q$MERKER\E\s*;/)
{
	push @mangel, "$KOPF: das Feld 'CSize $MERKER;' gibt es nicht mehr. Ohne Merker hat der COMMIT-Aufruf keine Quelle ausser nLength - und nLength bedeutet dort etwas anderes.";
}

# Anfangsbelegung: entweder im Rumpf eines Konstruktors oder in der
# Bauliste. Ohne sie steht beim ersten COMMIT Zufall im Merker.
unless ($code =~ /\Q$MERKER\E\s*(?:=\s*CSize\s*\(|\(\s*0\s*,\s*0\s*\))/)
{
	push @mangel, "$QUELLE: $MERKER bekommt nirgends eine Anfangsbelegung auf (0,0). Der COMMIT-Zweig unterscheidet 'nie gezogen' genau an dieser Null; ohne sie entscheidet uninitialisierter Speicher ueber die Fenstergroesse.";
}

# ------------------------------------------------- 3.-6. Der Rumpf

if ($rumpf ne '')
{
	# --- Den Zweig fuer LM_COMMIT abgrenzen. -----------------------------
	# Gesucht ist ein 'if', dessen Bedingung LM_COMMIT nennt und das NICHT
	# verneint ist (das verneinte gehoert zum Ziehzweig).
	my $commit_rumpf;
	my $commit_pos = -1;

	while ($rumpf =~ /\bif\s*\(/g)
	{
		my $auf = $+[0] - 1;
		my $zu  = klammer_ende($rumpf, $auf, '(', ')');
		next if $zu < 0;
		my $bed = substr($rumpf, $auf + 1, $zu - $auf - 1);
		next unless $bed =~ /\bLM_COMMIT\b/;
		next if $bed =~ /!/;          # !(dwMode & LM_COMMIT) ist der Ziehzweig

		# Rumpf des Zweigs: geklammert oder eine einzelne Anweisung.
		my $k = $zu + 1;
		$k++ while $k < length($rumpf) && substr($rumpf, $k, 1) =~ /\s/;
		if ($k < length($rumpf) && substr($rumpf, $k, 1) eq '{')
		{
			my $e = klammer_ende($rumpf, $k, '{', '}');
			next if $e < 0;
			$commit_rumpf = substr($rumpf, $k, $e - $k + 1);
		}
		else
		{
			my $e = index($rumpf, ';', $k);
			next if $e < 0;
			$commit_rumpf = substr($rumpf, $k, $e - $k + 1);
		}
		$commit_pos = $auf;
		last;
	}

	if (!defined $commit_rumpf)
	{
		push @mangel, "in CalcDynamicLayout gibt es keinen Zweig mehr fuer LM_COMMIT. Ohne ihn wird die gezogene Groesse nie uebernommen - oder schlimmer: bei jedem Zwischenschritt.";
	}
	else
	{
		# 3. Im COMMIT-Zweig darf nLength nicht vorkommen.
		if ($commit_rumpf =~ /\bnLength\b/)
		{
			push @mangel, sprintf(
				"%s:%d  der LM_COMMIT-Zweig verwendet nLength. Genau das war E-76: im abschliessenden Aufruf traegt nLength die BREITE (780), nicht die gezogene Hoehe (299). Wer dort aus nLength rechnet, wirft die gezogene Hoehe im letzten Augenblick weg.",
				$QUELLE, zeilennummer($roh, $rumpf_anfang + $commit_pos));
		}

		# 4. Er muss den Merker lesen und m_szFloat schreiben.
		unless ($commit_rumpf =~ /\Q$MERKER\E/)
		{
			push @mangel, "der LM_COMMIT-Zweig liest $MERKER nicht. Dann uebernimmt er irgendeine andere Groesse - die gezogene ist nur dort abgelegt.";
		}
		unless ($commit_rumpf =~ /\bm_szFloat\s*=/)
		{
			push @mangel, "der LM_COMMIT-Zweig schreibt m_szFloat nicht. m_szFloat ist die schwebende Groesse, die spaeter gesichert wird (BEFUND E-84); ohne diese Zuweisung ist das Ziehen nach dem Loslassen vergessen.";
		}
	}

	# --- 5./6. Jede Rechnung aus nLength ---------------------------------
	# Die Suche nach dem LM_COMMIT-Zweig oben endet mit 'last' und laesst
	# damit pos($rumpf) hinter dem gefundenen if stehen. Ohne das Zuruecksetzen
	# faengt die naechste //g-Schleife erst DANACH an - und genau die beiden
	# Zuweisungen, um die es geht, stehen davor. Der Fehler ist im Gegentest
	# aufgefallen: zwei Faelle blieben stumm, die scheitern mussten.
	pos($rumpf) = 0;

	while ($rumpf =~ /\b(?:size|szNeu)\s*\.\s*c([xy])\s*=\s*([^;]*?);/g)
	{
		my ($achse, $wert) = ($1, $2);
		my $pos = $-[0];
		next unless $wert =~ /\bnLength\b/;

		my ($art, $bed) = beherrschende_bedingung($rumpf, $pos);
		my $zeile = zeilennummer($roh, $rumpf_anfang + $pos);

		if ($art eq 'else')
		{
			push @mangel, sprintf(
				"%s:%d  'size.c%s = %s;' steht in einem nackten else-Zweig. Das IST der Fehler E-76: der abschliessende Aufruf traegt LM_COMMIT ohne LM_LENGTHY und faellt deshalb genau hier hinein - mit nLength als BREITE. Der Zweig gehoert an eine Bedingung, die LM_COMMIT ausschliesst, etwa 'else if (!(dwMode & LM_COMMIT))'.",
				$QUELLE, $zeile, $achse, $wert);
		}
		elsif ($art eq 'keine')
		{
			push @mangel, sprintf(
				"%s:%d  'size.c%s = %s;' steht unbedingt im Rumpf. Dann rechnet auch der abschliessende LM_COMMIT-Aufruf aus nLength, und dort bedeutet nLength etwas anderes als beim Ziehen.",
				$QUELLE, $zeile, $achse, $wert);
		}
		elsif ($bed !~ /\bLM_LENGTHY\b/ && $bed !~ /\bLM_COMMIT\b/)
		{
			my $kurz = $bed;
			$kurz =~ s/\s+/ /g;
			$kurz =~ s/^ | $//g;
			push @mangel, sprintf(
				"%s:%d  'size.c%s = %s;' steht unter '%s'. Diese Bedingung nennt weder LM_LENGTHY noch LM_COMMIT - es ist damit nicht entschieden, ob nLength hier die Hoehe oder die Breite ist.",
				$QUELLE, $zeile, $achse, $wert, $kurz);
		}
		else
		{
			# Der Zweig rechnet richtig - dann muss er auch merken.
			my ($zweig_anf, $zweig_end) = ($pos, $pos);
			my $j = $pos - 1;
			$j-- while $j >= 0 && substr($rumpf, $j, 1) =~ /\s/;
			if ($j >= 0 && substr($rumpf, $j, 1) eq '{')
			{
				my $e = klammer_ende($rumpf, $j, '{', '}');
				($zweig_anf, $zweig_end) = ($j, $e) if $e > 0;
			}
			my $zweig = substr($rumpf, $zweig_anf, $zweig_end - $zweig_anf + 1);
			unless ($zweig =~ /\Q$MERKER\E\s*=/)
			{
				push @mangel, sprintf(
					"%s:%d  der Zweig um 'size.c%s = %s;' rechnet aus nLength, legt das Ergebnis aber nicht in %s ab. Der COMMIT-Aufruf nimmt seine Groesse ausschliesslich von dort; ein Zweig ohne Nachtrag laesst ihn auf einem veralteten Wert sitzen.",
					$QUELLE, $zeile, $achse, $wert, $MERKER);
			}
		}
	}
}

# ------------------------------------------------------------------ Ergebnis

if (@mangel)
{
	unless ($leise)
	{
		printf "Ziehen am schwebenden Fenster (%s): %d Mangel.\n\n", $QUELLE, scalar @mangel;
		print "  $_\n\n" for @mangel;
		print <<'ENDE';
WARUM ES ZAEHLT
  CalcDynamicLayout ist die einzige Stelle, an der das Ziehen an einem
  schwebenden Fenster in eine Groesse umgerechnet wird. MFC ruft sie beim
  Ziehen viele Male mit LM_LENGTHY und einmal zum Schluss mit LM_COMMIT -
  und der abschliessende Aufruf uebergibt in nLength etwas ANDERES als die
  Ziehschritte davor. Wer das verwechselt, laesst den Anwender das Fenster
  ziehen und wirft das Ergebnis beim Loslassen weg. Es gibt keinen Fehler,
  keine Meldung; das Fenster springt einfach zurueck.

WAS ZU TUN
  Jeden Ziehschritt in m_szZuletztGezogen ablegen und den LM_COMMIT-Zweig
  ausschliesslich von dort bedienen:

      if (dwMode & LM_LENGTHY)
      {
          size.cy = max(nLength, 20);
          m_szZuletztGezogen = size;
      }
      else if (!(dwMode & LM_COMMIT))
      {
          size.cx = max(nLength, 20);
          m_szZuletztGezogen = size;
      }

      if (dwMode & LM_COMMIT)
      {
          if (m_szZuletztGezogen.cx > 0 && m_szZuletztGezogen.cy > 0)
              size = m_szZuletztGezogen;
          m_szFloat = size;
      }
ENDE
	}
	exit 1;
}

print "Ziehen am schwebenden Fenster: Merker vorhanden und belegt, LM_COMMIT rechnet nicht aus nLength, jeder Ziehzweig traegt nach.\n" unless $leise;
exit 0;
