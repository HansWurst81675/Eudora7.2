#!/usr/bin/perl
#
# Schranke gegen den Rueckfall in der Zertifikatspruefung: kein OpenSSL-
# Prueffehler darf im Callback zu "Zertifikat in Ordnung" umgedeutet werden.
#
#   perl tools/pruefe-zertifikatspruefung.pl            prueft und meldet
#   perl tools/pruefe-zertifikatspruefung.pl --leise    nur Rueckgabewert
#   perl tools/pruefe-zertifikatspruefung.pl --streng   Rueckgabe 1 statt einer Meldung
#
# Rueckgabe 0 = kein Mangel (oder: Mangel, aber ohne --streng nur gemeldet),
#          1 = Mangel und --streng, 2 = Aufruffehler.
#
# ------------------------------------------------------------------------
# WARUM DIESE SCHRANKE AUF main NUR MELDET UND NICHT SCHEITERT
#
# Die Behebung, die sie bewacht, liegt am 11.09.2026 NICHT in main. Sie steht
# auf dem eigenen Zweig "zertifikate" (Commit b3be298), und Gregor hat sie
# noch nicht beurteilt - ein Release ist eine Aussage nach aussen, erst prueft
# er lokal (Lehre "Release erst nach Gregors Test").
#
# Eine Schranke, die auf main vom ersten Tag an rot steht, wird binnen einer
# Woche mit --no-verify umgangen und ist danach nichts mehr wert. Deshalb
# meldet sie ohne --streng nur und gibt 0 zurueck.
#
# SOBALD DER ZWEIG "zertifikate" IN main IST, gehoert sie mit --streng in die
# Vorcommit-Liste und in tools/WERKZEUGE.md. Ab dann ist jedes Melden ein
# echter Rueckfall.
# ------------------------------------------------------------------------
#
# WAS SCHIEFGING
#
# Eudora71/QCSSL/src/qccertificate.cpp, QCCertificateUtils::CertificateCallback:
#
#     case X509_V_ERR_CERT_UNTRUSTED:                  /* 27 */
#     case X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE: /* 21 */
#         iOK = 1;
#         break;
#
# iOK ist der Rueckgabewert des Verifikations-Callbacks. iOK = 1 sagt OpenSSL
# woertlich "dieses Zertifikat ist in Ordnung, mach weiter". Genau diese
# beiden Codes meldet ein Zertifikat, dessen Kette sich nicht bis zu einem
# vertrauten Wurzelzertifikat zurueckverfolgen laesst - also der Fall, in dem
# ein Angreifer sein eigenes Zertifikat vorzeigt. Die Verbindung kam
# zustande, und der Anwender sah nichts.
#
# Dieselbe Zuweisung setzt ausserdem m_bTrusted weiter unten auf wahr
# (pNewCertData->m_bTrusted = (iOK == 1)), das Zertifikat galt also auch im
# Rest des Programms als vertrauenswuerdig.
#
# WAS GEPRUEFT WIRD
#
# 1. Es gibt die Funktion CertificateCallback und darin den switch ueber
#    X509_STORE_CTX_get_error.
# 2. In diesem switch steht KEINE Zuweisung an iOK. Der switch ist der Zweig
#    "das Zertifikat ist nicht in Ordnung"; wer dort iOK setzt, dreht das
#    Ergebnis um. Die Zuweisung iOK = 1 VOR dem switch ist etwas anderes und
#    ausdruecklich in Ordnung: dort hat der Anwender das Zertifikat selbst in
#    seine Liste aufgenommen (CertIsInStore).
# 3. Die beiden Fehlercodes kommen im switch ueberhaupt noch vor. Faellt ein
#    case weg, landet der Fehler im default-Zweig - dann gibt es zwar keine
#    falsche Freigabe mehr, aber auch keine benannte Meldung an den Anwender.
#
# GELESEN WIRD NUR CODE. Kommentare und Zeichenketten werden weggeworfen -
# die Begruendung der Behebung zitiert den alten Code woertlich, und eine
# Schranke, die ihre eigene Begruendung anschwaerzt, ist unbrauchbar
# (Lehre "Schranke liest nur Code").
#
# GEGENPROBE: tools/pruefe-zertifikatspruefung-tests.pl.

use strict;
use warnings;

my $leise  = 0;
my $streng = 0;
for my $a (@ARGV)
{
	if    ($a eq '--leise')  { $leise = 1 }
	elsif ($a eq '--streng') { $streng = 1 }
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

my $QUELLE = 'Eudora71/QCSSL/src/qccertificate.cpp';
unless (-f $QUELLE) { print STDERR "$QUELLE fehlt.\n"; exit 2 }

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

# ------------------------------------------------------------------ Einlesen

my $roh;
{
	open my $fh, '<:raw', $QUELLE or do { print STDERR "$QUELLE: $!\n"; exit 2 };
	local $/;
	$roh = <$fh>;
	close $fh;
}
my $code = nur_code($roh);

my @mangel;

# Den switch ueber X509_STORE_CTX_get_error finden und seinen Rumpf abgrenzen.
my $switch_anfang = -1;
my $switch_ende   = -1;

if ($code !~ /\bCertificateCallback\s*\(/)
{
	push @mangel, "die Funktion CertificateCallback steht nicht mehr in $QUELLE.";
}
elsif ($code =~ /\bswitch\s*\(\s*X509_STORE_CTX_get_error\s*\(/g)
{
	my $p = $-[0];
	my $auf = index($code, '{', $p);
	if ($auf < 0)
	{
		push @mangel, "der switch ueber X509_STORE_CTX_get_error hat keinen Rumpf.";
	}
	else
	{
		my $tiefe = 0;
		for (my $i = $auf; $i < length $code; $i++)
		{
			my $c = substr($code, $i, 1);
			$tiefe++ if $c eq '{';
			if ($c eq '}')
			{
				$tiefe--;
				if ($tiefe == 0) { $switch_anfang = $auf; $switch_ende = $i; last }
			}
		}
		push @mangel, "der switch ueber X509_STORE_CTX_get_error ist nicht geschlossen."
			if $switch_anfang < 0;
	}
}
else
{
	push @mangel, "in $QUELLE gibt es keinen switch ueber X509_STORE_CTX_get_error mehr - dann laesst sich nicht sagen, wie die Prueffehler behandelt werden.";
}

if ($switch_anfang >= 0)
{
	my $rumpf = substr($code, $switch_anfang, $switch_ende - $switch_anfang + 1);

	# 1. Keine Zuweisung an iOK im switch.
	my $off = 0;
	while ($rumpf =~ /\biOK\s*=\s*([^=][^;]*);/g)
	{
		my $wert = $1;
		$wert =~ s/^\s+|\s+$//g;
		my $pos = $switch_anfang + $-[0];
		push @mangel, sprintf(
			"%s:%d  im switch steht 'iOK = %s;'. iOK ist der Rueckgabewert des Verifikations-Callbacks; ein Wert ungleich 0 sagt OpenSSL woertlich, das Zertifikat sei in Ordnung. Der switch ist aber der Zweig, in dem die Pruefung FEHLGESCHLAGEN ist.",
			$QUELLE, zeilennummer($roh, $pos), $wert);
	}

	# 2. Die beiden Fehlercodes muessen noch benannt werden.
	for my $code_name (qw(X509_V_ERR_CERT_UNTRUSTED X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE))
	{
		next if $rumpf =~ /\bcase\s+\Q$code_name\E\s*:/;
		push @mangel, "im switch gibt es keinen case fuer $code_name mehr. Der Fehler landet dann im default-Zweig und der Anwender bekommt keine benannte Meldung mehr.";
	}
}

# ------------------------------------------------------------------ Ergebnis

if (@mangel)
{
	unless ($leise)
	{
		printf "Zertifikatspruefung (%s): %d Mangel.\n\n", $QUELLE, scalar @mangel;
		print "  $_\n\n" for @mangel;
		print <<'ENDE';
WARUM ES ZAEHLT
  Der Callback entscheidet, ob eine TLS-Verbindung zustande kommt. Wer einen
  Prueffehler auf "in Ordnung" umbiegt, nimmt jedes Zertifikat an, dessen
  Kette sich nicht bis zu einer vertrauten Wurzel zurueckverfolgen laesst -
  also auch das eines Angreifers, der sich dazwischenschaltet. Es gibt keine
  Meldung, keinen Fehler, keinen Unterschied fuer den Anwender. Nur der
  Schutz ist weg.

WAS ZU TUN
  Die betroffenen Fehlercodes an den Zweig fuer
  X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY haengen. Der meldet
  IDS_CERTERR_CHAINNOTTRUSTED und laesst iOK auf 0 - der Anwender bekommt den
  Dialog und entscheidet selbst. Wer dem Zertifikat trauen will, nimmt es in
  seine Liste auf; dafuer gibt es die Abfrage CertIsInStore weiter oben, und
  DIE darf iOK setzen.
ENDE
	}

	if ($streng) { exit 1 }

	unless ($leise)
	{
		print "\n";
		print "NUR GEMELDET, NICHT GESCHEITERT. Die Behebung liegt auf dem Zweig\n";
		print "\"zertifikate\" (b3be298) und ist am 11.09.2026 nicht in main. Sobald sie\n";
		print "gemergt ist, gehoert diese Schranke mit --streng in die Vorcommit-Liste.\n";
	}
	exit 0;
}

print "Zertifikatspruefung: keine Zuweisung an iOK im Fehler-switch, beide Fehlercodes benannt.\n" unless $leise;
exit 0;
