#!/usr/bin/perl
#
# Gegentest zu tools/pruefe-leistengroessen-paar.pl.
#
#   perl tools/pruefe-leistengroessen-paar-tests.pl
#
# Rueckgabe 0 = alle Faelle wie erwartet, 1 = ein Fall abweichend.
#
# JEDER FALL LAEUFT IN BEIDE RICHTUNGEN (Lehre "Schranke gegentesten"):
# es gibt Faelle, die scheitern MUESSEN, und Faelle, die durchgehen muessen.
# Stumm und Fehlalarm kosten dasselbe.
#
# DIE BEIDEN MASSGEBLICHEN FAELLE sind die ersten zwei: der echte Stand vor
# der Behebung (643a634^ - die schwebende Groesse kam dort nirgends vor) und
# der echte Stand danach (der Arbeitsbaum). Ist der alte Stand nicht
# erreichbar, wird der Fall uebersprungen und das laut gesagt.
#
# Die Schranke liest DREI Dateien; jeder Fall legt deshalb alle drei in einem
# eigenen Probebaum an.

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

my $REL_LEISTE = 'Eudora71/OTShim/OTShim_Werkzeugleiste.cpp';
my $REL_QCMGR  = 'Eudora71/Eudora/QCToolBarManager.cpp';
my $REL_SHIM   = 'Eudora71/OTShim/OTShim.cpp';
my $VORHER     = '643a634^';   # der Stand unmittelbar vor der Behebung zu E-84

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

my $L = lies(File::Spec->catfile($quelle, split(m{/}, $REL_LEISTE)));
my $Q = lies(File::Spec->catfile($quelle, split(m{/}, $REL_QCMGR)));
my $S = lies(File::Spec->catfile($quelle, split(m{/}, $REL_SHIM)));
die "$REL_LEISTE fehlt.\n" unless defined $L;
die "$REL_QCMGR fehlt.\n"  unless defined $Q;
die "$REL_SHIM fehlt.\n"   unless defined $S;

my $AL = aus_commit($VORHER, $REL_LEISTE);
my $AQ = aus_commit($VORHER, $REL_QCMGR);
my $AS = aus_commit($VORHER, $REL_SHIM);

# Fall: Name, Werkzeugleiste.cpp, QCToolBarManager.cpp, OTShim.cpp, erwartet.
my @faelle;

# --- die beiden echten Staende -------------------------------------------

if (!defined $AL || !defined $AQ || !defined $AS)
{
	print "ACHTUNG: der Stand $VORHER ist nicht erreichbar - der Fall 'die\n";
	print "schwebende Groesse kam nirgends vor' wird UEBERSPRUNGEN. Ohne ihn ist\n";
	print "nicht belegt, dass die Schranke den echten Fehler faengt.\n\n";
}
else
{
	push @faelle, [ "der echte Stand vor der Behebung ($VORHER) - E-84 muss auffallen",
		$AL, $AQ, $AS, 1 ];
}

push @faelle, [ 'der heutige Stand im Arbeitsbaum - muss still bleiben',
	$L, $Q, $S, 0 ];

# --- Paarigkeit: ein Schluessel nur auf einer Seite -----------------------

{
	# FloatCx wird geschrieben, aber nicht mehr gelesen. Das ist die
	# Fehlerklasse hinter E-70 und E-84 in Reinform.
	my $t = $L;
	$t =~ s/\t\t\tOTShimGroessenSchluessel\(szF, 64, _T\("FloatCx"\), nId\);\r?\n\t\t\tconst int cx = pApp->GetProfileInt\(lpszAbschnitt, szF, 0\);\r?\n/\t\t\tconst int cx = 0;\n/;
	push @faelle, [ 'FloatCx wird geschrieben, aber nicht mehr gelesen', $t, $Q, $S, 1 ];
}
{
	# FloatCy wird gelesen, aber nicht mehr geschrieben.
	my $t = $L;
	$t =~ s/\t\t\tOTShimGroessenSchluessel\(szSchluessel, 64, _T\("FloatCy"\), nId\);\r?\n\t\t\tpApp->WriteProfileInt\(lpszAbschnitt, szSchluessel, pBar->m_szFloat\.cy\);\r?\n//;
	push @faelle, [ 'FloatCy wird gelesen, aber nicht mehr geschrieben', $t, $Q, $S, 1 ];
}
{
	# Ein Tippfehler im Namen auf der Leseseite - paarig sieht anders aus.
	my $t = $L;
	$t =~ s/OTShimGroessenSchluessel\(szF, 64, _T\("FloatCy"\), nId\);/OTShimGroessenSchluessel(szF, 64, _T("FloatCY"), nId);/;
	push @faelle, [ 'ein Tippfehler im Schluesselnamen auf der Leseseite', $t, $Q, $S, 1 ];
}

# --- Bilden ist nicht Tun ------------------------------------------------

{
	my $t = $L;
	$t =~ s/\t\t\tpApp->WriteProfileInt\(lpszAbschnitt, szSchluessel, pBar->m_szFloat\.cx\);\r?\n//;
	push @faelle, [ 'FloatCx wird gebildet, aber nicht geschrieben', $t, $Q, $S, 1 ];
}

# --- Die schwebende Groesse faellt auf BEIDEN Seiten weg -----------------

{
	# Paarig und trotzdem falsch: genau der Zustand vor der Behebung.
	my $t = $L;
	$t =~ s/\t\tif \(pBar->m_szFloat\.cx > 0 && pBar->m_szFloat\.cy > 0\)\r?\n\t\t\{.*?\r?\n\t\t\}\r?\n//s;
	$t =~ s/\t\t\{\r?\n\t\t\tTCHAR szF\[64\];.*?\t\t\}\r?\n//s;
	push @faelle, [ 'die schwebende Groesse faellt auf beiden Seiten weg', $t, $Q, $S, 1 ];
}

# --- Der lebende Weg -----------------------------------------------------

{
	# GENAU E-70: der Aufruf verschwindet aus dem Weg, den Eudora geht.
	my $t = $Q;
	$t =~ s/\tGroessenLaden\(szMgrSection\);/\t;/;
	push @faelle, [ 'QCToolBarManager::LoadState ruft GroessenLaden nicht mehr (E-70)', $L, $t, $S, 1 ];
}
{
	my $t = $Q;
	$t =~ s/\tSECToolBarManager::SaveState\( lpszProfileName \);/\t;/;
	push @faelle, [ 'QCToolBarManager::SaveState ruft die SEC-Fassung nicht mehr', $L, $t, $S, 1 ];
}
{
	my $t = $L;
	$t =~ s/\tGroessenSichern\(szSection\);/\t;/;
	push @faelle, [ 'SECToolBarManager::SaveState ruft GroessenSichern nicht mehr', $t, $Q, $S, 1 ];
}

# --- Der Abschnitt -------------------------------------------------------

{
	my $t = $L;
	$t =~ s/static const TCHAR szToolBarManagerSection\[\] = _T\("%s-ToolBarManager"\);/static const TCHAR szToolBarManagerSection[] = _T("%s-ToolBars");/;
	push @faelle, [ 'die Schreibseite bildet einen anderen Abschnittsnamen', $t, $Q, $S, 1 ];
}
{
	my $t = $Q;
	$t =~ s/\tszMgrSection\.Format\(_T\("%s-ToolBarManager"\), lpszProfileName\);/\tszMgrSection.Format(_T("%s-ToolBarMgr"), lpszProfileName);/;
	push @faelle, [ 'die Leseseite bildet einen anderen Abschnittsnamen', $L, $t, $S, 1 ];
}

# --- Der tote Ort --------------------------------------------------------

{
	# Der erste, wirkungslose Anlauf zu E-84 kehrt zurueck.
	my $t = $S;
	$t =~ s/(BOOL SECControlBarInfo::SaveState\(LPCTSTR lpszProfileName, int nIndex\)\r?\n\{)/$1\n\tAfxGetApp()->WriteProfileInt(lpszProfileName, _T("FloatCx"), m_szFloat.cx);/;
	push @faelle, [ 'die Sicherung wandert zurueck in SECControlBarInfo::SaveState', $L, $Q, $t, 1 ];
}

# --- Die Funktionen selbst -----------------------------------------------

{
	my $t = $L;
	$t =~ s/void SECToolBarManager::GroessenLaden/void SECToolBarManager::AndersHeissendeFunktion/;
	push @faelle, [ 'GroessenLaden ist verschwunden', $t, $Q, $S, 1 ];
}

# --- Faelle, die NICHT melden duerfen (Gegenprobe umgedreht) --------------

{
	# Die Begruendung der Behebung nennt den falschen Ort und die Namen
	# woertlich. Eine Schranke, die Kommentare mitliest, schwaerzt ihre
	# eigene Begruendung an (Lehre "Schranke liest nur Code").
	my $t = $S;
	$t =~ s{(BOOL SECControlBarInfo::SaveState\(LPCTSTR lpszProfileName, int nIndex\)\r?\n\{)}
	       {$1\n\t// Hier stand: WriteProfileInt(lpszProfileName, _T("FloatCx"), ...);\n\t/* und GetProfileInt(lpszProfileName, _T("FloatCy"), 0); - beides wirkungslos */};
	push @faelle, [ 'ein Kommentar am toten Ort zitiert den alten Anlauf', $L, $Q, $t, 0 ];
}
{
	# Ein weiteres Schluesselpaar auf beiden Seiten ist eine Erweiterung,
	# kein Mangel.
	my $t = $L;
	$t =~ s/(\t\t\tOTShimGroessenSchluessel\(szSchluessel, 64, _T\("FloatCy"\), nId\);\r?\n\t\t\tpApp->WriteProfileInt\(lpszAbschnitt, szSchluessel, pBar->m_szFloat\.cy\);\r?\n)/$1\t\t\tOTShimGroessenSchluessel(szSchluessel, 64, _T("FloatX"), nId);\n\t\t\tpApp->WriteProfileInt(lpszAbschnitt, szSchluessel, 7);\n/;
	$t =~ s/(\t\t\tconst int cy = pApp->GetProfileInt\(lpszAbschnitt, szF, 0\);\r?\n)/$1\t\t\tOTShimGroessenSchluessel(szF, 64, _T("FloatX"), nId);\n\t\t\tconst int x = pApp->GetProfileInt(lpszAbschnitt, szF, 0);\n\t\t\t(void) x;\n/;
	push @faelle, [ 'ein weiteres Schluesselpaar auf beiden Seiten', $t, $Q, $S, 0 ];
}
{
	# Die Hilfsvariable auf der Leseseite heisst anders - das ist erlaubt,
	# solange der Name in demselben Fenster benutzt wird.
	my $t = $L;
	$t =~ s/\bszF\b/szLeseschluessel/g;
	$t =~ s/TCHAR szLeseschluessel\[64\]/TCHAR szLeseschluessel[64]/;
	push @faelle, [ 'die Hilfsvariable auf der Leseseite heisst anders', $t, $Q, $S, 0 ];
}

# ------------------------------------------------------------------- Lauf

my $ok = 0;
my $schlecht = 0;

print "Gegentest zu $werkzeug\n\n";

for my $fall (@faelle)
{
	my ($name, $l, $q, $s, $erwartet) = @$fall;

	my $baum = tempdir(CLEANUP => 1);
	my $v1 = File::Spec->catdir($baum, 'Eudora71', 'OTShim');
	my $v2 = File::Spec->catdir($baum, 'Eudora71', 'Eudora');
	make_path($v1);
	make_path($v2);
	schreib(File::Spec->catfile($v1, 'OTShim_Werkzeugleiste.cpp'), $l);
	schreib(File::Spec->catfile($v1, 'OTShim.cpp'),                $s);
	schreib(File::Spec->catfile($v2, 'QCToolBarManager.cpp'),      $q);

	local $ENV{PRUEFWURZEL} = $baum;
	my $r = system("perl \"$werkzeug\" --leise");
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
