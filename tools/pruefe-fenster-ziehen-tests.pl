#!/usr/bin/perl
#
# Gegentest zu tools/pruefe-fenster-ziehen.pl.
#
#   perl tools/pruefe-fenster-ziehen-tests.pl
#
# Rueckgabe 0 = alle Faelle wie erwartet, 1 = ein Fall abweichend.
#
# JEDER FALL LAEUFT IN BEIDE RICHTUNGEN (Lehre "Schranke gegentesten"):
# es gibt Faelle, die scheitern MUESSEN, und Faelle, die durchgehen muessen.
# Stumm und Fehlalarm kosten dasselbe.
#
# DIE BEIDEN MASSGEBLICHEN FAELLE sind die ersten zwei: der echte Stand vor
# der Behebung (c060648^ - der Fehler E-76 ist dort drin) und der echte
# Stand danach (der Arbeitsbaum). Faengt die Schranke den einen nicht oder
# meldet sie den anderen, ist sie nichts wert. Ist der alte Stand nicht
# erreichbar, wird der Fall uebersprungen und das laut gesagt.
#
# Die Schranke liest ZWEI Dateien (OTShim.cpp und OTShim.h); jeder Fall legt
# deshalb beide in einem eigenen Probebaum an.

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

my $REL_CPP = 'Eudora71/OTShim/OTShim.cpp';
my $REL_H   = 'Eudora71/OTShim/OTShim.h';
my $VORHER  = 'c060648^';   # der Stand unmittelbar vor der Behebung zu E-76

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
	my ($rev, $rel) = @_;
	my $alt = getcwd();
	chdir $quelle or die $!;
	my $t = `git show $rev:$rel 2>&1`;
	my $r = $?;
	chdir $alt or die $!;
	return ($r == 0 && defined $t && length $t) ? $t : undef;
}

my $HEUTE_CPP = lies(File::Spec->catfile($quelle, split(m{/}, $REL_CPP)));
my $HEUTE_H   = lies(File::Spec->catfile($quelle, split(m{/}, $REL_H)));
die "$REL_CPP fehlt im Quellbaum.\n" unless defined $HEUTE_CPP;
die "$REL_H fehlt im Quellbaum.\n"   unless defined $HEUTE_H;

my $ALT_CPP = aus_commit($VORHER, $REL_CPP);
my $ALT_H   = aus_commit($VORHER, $REL_H);

# Fall: Name, OTShim.cpp, OTShim.h, erwartete Rueckgabe.
my @faelle;

# --- die beiden echten Staende -------------------------------------------

if (!defined $ALT_CPP || !defined $ALT_H)
{
	print "ACHTUNG: der Stand $VORHER ist nicht erreichbar - der Fall 'der Fehler\n";
	print "E-76, wie er wirklich dastand' wird UEBERSPRUNGEN. Ohne ihn ist nicht\n";
	print "belegt, dass die Schranke den echten Fehler faengt.\n\n";
}
else
{
	push @faelle, [ "der echte Stand vor der Behebung ($VORHER) - der Fehler muss auffallen",
		$ALT_CPP, $ALT_H, 1 ];
}

push @faelle, [ 'der heutige Stand im Arbeitsbaum - muss still bleiben',
	$HEUTE_CPP, $HEUTE_H, 0 ];

# --- kuenstliche Faelle, alle vom heilen Stand aus ------------------------

{
	# Rueckfall genau in der Form von E-76: der COMMIT rechnet wieder selbst.
	my $t = $HEUTE_CPP;
	$t =~ s/\t\t\tif \(m_szZuletztGezogen\.cx > 0 && m_szZuletztGezogen\.cy > 0\)\r?\n\t\t\t\tsize = m_szZuletztGezogen;\r?\n/\t\t\tsize.cx = max(nLength, 20);\n/;
	push @faelle, [ 'der COMMIT-Zweig rechnet wieder aus nLength', $t, $HEUTE_H, 1 ];
}
{
	# Der nackte else-Zweig - die urspruengliche Form des Fehlers.
	my $t = $HEUTE_CPP;
	$t =~ s/\t\telse if \(!\(dwMode & LM_COMMIT\)\)/\t\telse/;
	push @faelle, [ 'aus dem Schutz wird wieder ein nacktes else', $t, $HEUTE_H, 1 ];
}
{
	# Ein Ziehzweig rechnet, merkt aber nicht nach.
	my $t = $HEUTE_CPP;
	$t =~ s/\t\t\tsize\.cy = max\(nLength, 20\);\r?\n\t\t\tm_szZuletztGezogen = size;\r?\n/\t\t\tsize.cy = max(nLength, 20);\n/;
	push @faelle, [ 'der LENGTHY-Zweig traegt nicht mehr in den Merker nach', $t, $HEUTE_H, 1 ];
}
{
	# Der COMMIT liest den Merker nicht mehr.
	my $t = $HEUTE_CPP;
	$t =~ s/\t\t\tif \(m_szZuletztGezogen\.cx > 0 && m_szZuletztGezogen\.cy > 0\)\r?\n\t\t\t\tsize = m_szZuletztGezogen;\r?\n//;
	push @faelle, [ 'der COMMIT-Zweig liest den Merker nicht mehr', $t, $HEUTE_H, 1 ];
}
{
	# Der COMMIT schreibt m_szFloat nicht mehr - dann ist E-84 wieder offen.
	my $t = $HEUTE_CPP;
	$t =~ s/\t\t\tm_szFloat = size;\r?\n//;
	push @faelle, [ 'der COMMIT-Zweig schreibt m_szFloat nicht mehr', $t, $HEUTE_H, 1 ];
}
{
	# Das Feld faellt aus dem Kopf.
	my $h = $HEUTE_H;
	$h =~ s/\tCSize m_szZuletztGezogen;[^\n]*\r?\n//;
	push @faelle, [ 'das Feld m_szZuletztGezogen faellt aus OTShim.h', $HEUTE_CPP, $h, 1 ];
}
{
	# Die Anfangsbelegung faellt weg - dann entscheidet Zufall.
	my $t = $HEUTE_CPP;
	$t =~ s/\tm_szZuletztGezogen = CSize\(0, 0\);[^\n]*\r?\n//;
	push @faelle, [ 'die Anfangsbelegung des Merkers faellt weg', $t, $HEUTE_H, 1 ];
}
{
	# Die ganze Funktion ist weg.
	my $t = $HEUTE_CPP;
	$t =~ s/CSize SECControlBar::CalcDynamicLayout/CSize SECControlBar::AndersHeissendeFunktion/;
	push @faelle, [ 'CalcDynamicLayout ist verschwunden', $t, $HEUTE_H, 1 ];
}
{
	# Der COMMIT-Zweig ist ganz weg.
	my $t = $HEUTE_CPP;
	$t =~ s/\t\tif \(dwMode & LM_COMMIT\)/\t\tif (0)/;
	push @faelle, [ 'der LM_COMMIT-Zweig ist verschwunden', $t, $HEUTE_H, 1 ];
}

# --- Faelle, die NICHT melden duerfen (Gegenprobe umgedreht) --------------

{
	# Die Begruendung der Behebung zitiert den alten fehlerhaften Code
	# woertlich. Eine Schranke, die Kommentare mitliest, schwaerzt ihre
	# eigene Begruendung an (Lehre "Schranke liest nur Code").
	my $t = $HEUTE_CPP;
	$t =~ s{(\t\tif \(dwMode & LM_LENGTHY\))}
	       {\t\t// Frueher stand hier: else size.cx = max(nLength, 20);\n\t\t/* und so: if (dwMode & LM_COMMIT) size.cx = nLength; */\n$1};
	push @faelle, [ 'ein Kommentar zitiert den alten Fehler - muss still bleiben', $t, $HEUTE_H, 0 ];
}
{
	# Eine andere Schreibweise derselben Absicht muss durchgehen: der
	# Schutzzweig darf auch als eigenes if mit ausdruecklichem LM_LENGTHY-
	# Ausschluss geschrieben sein.
	my $t = $HEUTE_CPP;
	$t =~ s/\t\telse if \(!\(dwMode & LM_COMMIT\)\)/\t\telse if (!(dwMode & (LM_COMMIT | LM_LENGTHY)))/;
	push @faelle, [ 'eine andere, ebenso richtige Schreibweise des Schutzes', $t, $HEUTE_H, 0 ];
}
{
	# Eine zusaetzliche Anweisung im COMMIT-Zweig, die nichts mit nLength zu
	# tun hat, ist kein Mangel.
	my $t = $HEUTE_CPP;
	$t =~ s/(\t\t\tm_szFloat = size;)/$1\n\t\t\tm_szZuletztGezogen = size;/;
	push @faelle, [ 'eine harmlose Zusatzzeile im COMMIT-Zweig', $t, $HEUTE_H, 0 ];
}

# ------------------------------------------------------------------- Lauf

my $ok = 0;
my $schlecht = 0;

print "Gegentest zu $werkzeug\n\n";

for my $fall (@faelle)
{
	my ($name, $cpp, $h, $erwartet) = @$fall;

	my $baum = tempdir(CLEANUP => 1);
	my $verz = File::Spec->catdir($baum, 'Eudora71', 'OTShim');
	make_path($verz);
	schreib(File::Spec->catfile($verz, 'OTShim.cpp'), $cpp);
	schreib(File::Spec->catfile($verz, 'OTShim.h'),   $h);

	local $ENV{PRUEFWURZEL} = $baum;
	my $r = system("perl \"$werkzeug\" --leise");
	$r = $r >> 8;

	if ($r == $erwartet)
	{
		$ok++;
		printf "  ok    %-64s (Rueckgabe %d)\n", $name, $r;
	}
	else
	{
		$schlecht++;
		printf "  FEHLT %-64s (Rueckgabe %d, erwartet %d)\n", $name, $r, $erwartet;
	}
}

printf "\n%d von %d Faellen wie erwartet.\n", $ok, $ok + $schlecht;
exit($schlecht ? 1 : 0);
