#!/usr/bin/perl
#
# Gegentest zu tools/pruefe-zertifikatspruefung.pl.
#
#   perl tools/pruefe-zertifikatspruefung-tests.pl
#
# Rueckgabe 0 = alle Faelle wie erwartet, 1 = ein Fall abweichend.
#
# JEDER FALL LAEUFT IN BEIDE RICHTUNGEN (Lehre "Schranke gegentesten").
#
# Die Faelle laufen mit --streng, sonst waere jeder Rueckgabewert 0 und der
# Test sagte nichts. Zwei eigene Faelle am Schluss pruefen dafuer das
# Verhalten OHNE --streng: melden, aber 0 zurueckgeben.
#
# DIE BEIDEN MASSGEBLICHEN FAELLE sind die ersten zwei: die echte Datei aus
# main (der Fehler ist dort noch drin) und die echte Datei aus b3be298 (die
# Behebung auf dem Zweig "zertifikate"). Faengt die Schranke die eine nicht
# oder meldet sie die andere, ist sie nichts wert. Ist einer der beiden
# Staende nicht erreichbar, wird der Fall uebersprungen und das laut gesagt.

use strict;
use warnings;
use File::Temp qw(tempdir);
use File::Path qw(make_path);
use File::Spec;
use Cwd qw(abs_path getcwd);

my $werkzeug = abs_path($0);
$werkzeug =~ s/-tests\.pl$/.pl/;
die "Werkzeug nicht gefunden: $werkzeug\n" unless -f $werkzeug;

my $quelle = abs_path($0);
$quelle =~ s{[\\/]tools[\\/][^\\/]+$}{};

my $REL     = 'Eudora71/QCSSL/src/qccertificate.cpp';
my $BEHOBEN = 'b3be298';   # Zweig "zertifikate": die Behebung

sub lies
{
	my ($f) = @_;
	open my $fh, '<:raw', $f or return undef;
	local $/;
	my $t = <$fh>;
	close $fh;
	return $t;
}

sub schreib
{
	my ($f, $t) = @_;
	open my $fh, '>:raw', $f or die "$f: $!";
	print $fh $t;
	close $fh;
}

sub aus_commit
{
	my ($rev) = @_;
	my $alt = getcwd();
	chdir $quelle or die $!;
	my $befehl = 'git show ' . $rev . ':' . $REL . ' 2>&1';
	my $t = `$befehl`;
	my $r = $?;
	chdir $alt or die $!;
	return ($r == 0 && defined $t && length $t) ? $t : undef;
}

my $HEUTE = lies(File::Spec->catfile($quelle, split(m{/}, $REL)));
die "$REL fehlt im Quellbaum.\n" unless defined $HEUTE;

my $GUT = aus_commit($BEHOBEN);

# Fall: Name, Dateiinhalt, zusaetzliche Angaben an die Schranke, erwartete Rueckgabe.
my @faelle;

# --- die beiden echten Staende -------------------------------------------

push @faelle, [ 'der Stand in main - der Fehler ist dort noch drin',
	$HEUTE, '--streng --leise', 1 ];

if (!defined $GUT)
{
	print "ACHTUNG: Commit $BEHOBEN ist nicht erreichbar - der Fall 'die Behebung auf\n";
	print "dem Zweig zertifikate' wird UEBERSPRUNGEN. Ohne ihn ist nicht belegt, dass\n";
	print "die Schranke die richtige Fassung durchlaesst.\n\n";
}
else
{
	push @faelle, [ "die Behebung aus $BEHOBEN - muss still bleiben",
		$GUT, '--streng --leise', 0 ];
}

# --- kuenstliche Faelle ---------------------------------------------------

my $BASIS = defined $GUT ? $GUT : $HEUTE;

if (defined $GUT)
{
	{
		# iOK in einem ANDEREN case-Zweig freigeben - dieselbe Klasse, andere Stelle.
		my $t = $GUT;
		$t =~ s/(case X509_V_ERR_CERT_REVOKED:)/$1\n\t\t\t\tiOK = 1;\n\t\t\t\tbreak;/;
		push @faelle, [ 'iOK = 1 in einem anderen case-Zweig', $t, '--streng --leise', 1 ];
	}
	{
		# Ein anderer Wert ungleich 0 ist genauso eine Freigabe.
		my $t = $GUT;
		$t =~ s/(case X509_V_ERR_CERT_REVOKED:)/$1\n\t\t\t\tiOK = 2;\n\t\t\t\tbreak;/;
		push @faelle, [ 'iOK = 2 im switch - jeder Wert ungleich 0 gibt frei', $t, '--streng --leise', 1 ];
	}
	{
		my $t = $GUT;
		$t =~ s/\t*case X509_V_ERR_CERT_UNTRUSTED:\r?\n//;
		push @faelle, [ 'der case fuer X509_V_ERR_CERT_UNTRUSTED faellt weg', $t, '--streng --leise', 1 ];
	}
	{
		my $t = $GUT;
		$t =~ s/\t*case X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE:\r?\n//;
		push @faelle, [ 'der case fuer X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE faellt weg', $t, '--streng --leise', 1 ];
	}
	{
		my $t = $GUT;
		$t =~ s/switch\(X509_STORE_CTX_get_error\(pX509StoreCtx\)\)/switch(0)/;
		push @faelle, [ 'der switch geht nicht mehr ueber X509_STORE_CTX_get_error', $t, '--streng --leise', 1 ];
	}
	{
		my $t = $GUT;
		$t =~ s/QCCertificateUtils::CertificateCallback/QCCertificateUtils::AndersHeissendeFunktion/g;
		push @faelle, [ 'CertificateCallback ist verschwunden', $t, '--streng --leise', 1 ];
	}
	{
		# Die Begruendung der Behebung zitiert den alten Code woertlich. Wer
		# Kommentare mitliest, schwaerzt seine eigene Begruendung an
		# (Lehre "Schranke liest nur Code").
		my $t = $GUT;
		$t =~ s{(switch\(X509_STORE_CTX_get_error\(pX509StoreCtx\)\)\r?\n\t\t\{)}
		       {$1\n\t\t\t// Hier stand frueher: iOK = 1; - das war der Fehler.\n\t\t\t/* auch so: iOK = 1; */}s;
		push @faelle, [ 'ein Kommentar im switch zitiert iOK = 1;', $t, '--streng --leise', 0 ];
	}
	{
		# Die Zuweisung VOR dem switch ist der Fall "der Anwender hat das
		# Zertifikat selbst aufgenommen" und muss erlaubt bleiben. Sie steht
		# in GUT ohnehin drin; dieser Fall macht sie doppelt.
		my $t = $GUT;
		$t =~ s/(bInStore = \(CertIsInStore)/iOK = 1;\n\t\t$1/;
		push @faelle, [ 'iOK = 1 VOR dem switch bleibt erlaubt (CertIsInStore)', $t, '--streng --leise', 0 ];
	}

	# --- das Verhalten ohne --streng ------------------------------------

	push @faelle, [ 'ohne --streng meldet sie den Fehler nur (Rueckgabe 0)',
		$HEUTE, '--leise', 0 ];

	push @faelle, [ 'ohne --streng bleibt die heile Fassung ebenfalls bei 0',
		$GUT, '--leise', 0 ];
}

# ------------------------------------------------------------------- Lauf

my $ok = 0;
my $schlecht = 0;

print "Gegentest zu " . $werkzeug . "\n\n";

for my $fall (@faelle)
{
	my ($name, $inhalt, $angaben, $erwartet) = @$fall;

	my $baum = tempdir(CLEANUP => 1);
	my $verz = File::Spec->catdir($baum, 'Eudora71', 'QCSSL', 'src');
	make_path($verz);
	schreib(File::Spec->catfile($verz, 'qccertificate.cpp'), $inhalt);

	local $ENV{PRUEFWURZEL} = $baum;
	my $r = system("perl \"$werkzeug\" $angaben");
	$r = $r >> 8;

	if ($r == $erwartet)
	{
		$ok++;
		printf "  ok    %-66s (Rueckgabe %d)\n", $name, $r;
	}
	else
	{
		$schlecht++;
		printf "  FEHLT %-66s (Rueckgabe %d, erwartet %d)\n", $name, $r, $erwartet;
	}
}

printf "\n%d von %d Faellen wie erwartet.\n", $ok, $ok + $schlecht;
exit($schlecht ? 1 : 0);
