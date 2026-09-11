#!/usr/bin/perl
#
# Gegentest zu tools/pruefe-kopfzeilen-stil.pl.
#
#   perl tools/pruefe-kopfzeilen-stil-tests.pl
#
# Rueckgabe 0 = alle Faelle wie erwartet, 1 = ein Fall abweichend.
#
# JEDER FALL LAEUFT IN BEIDE RICHTUNGEN (Lehre "Schranke gegentesten").
#
# DER MASSGEBLICHE FALL ist der erste: die echte EudoraRes.rc aus 83c80fa,
# dem letzten Commit ohne die Regel fuer EUDORAHEADER. Das ist woertlich der
# Zustand, den Gregor am 11.09.2026 gemeldet hat - Kopfzeilen unsichtbar auf
# dunklem Grund. Ist der Commit nicht erreichbar, wird der Fall
# uebersprungen und das laut gesagt.
#
# DER ZWEITWICHTIGSTE FALL ist die Prozentzeichen-Falle. Das Stylesheet
# laeuft durch CString::Format; ein einzelnes % in einer neuen Regel greift
# in einen Platzhalter, den niemand bedient. Zwei Faelle halten fest, dass
# ein einzelnes % gemeldet und ein verdoppeltes %% durchgelassen wird.
#
# Gearbeitet wird in einem Wegwerfverzeichnis. Die Schranke wird ueber
# PRUEFWURZEL dorthin gezeigt; der Quellbaum wird nicht angefasst.

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

my $VOR = '83c80fa';   # letzter Commit ohne die Regel fuer EUDORAHEADER

my $BS = chr(92);

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
	my $befehl = 'git show ' . $rev . ':' . $rel . ' 2>&1';
	my $t = `$befehl`;
	my $r = $?;
	chdir $alt or die $!;
	return ($r == 0 && defined $t && length $t) ? $t : undef;
}

# TridentView.cpp wird unveraendert uebernommen - dort zaehlt die Schranke,
# wie viele Argumente an Format gehen.
my $TVIEW = lies(File::Spec->catfile($quelle, 'Eudora71', 'Eudora', 'TridentView.cpp'));
die "Eudora71/Eudora/TridentView.cpp fehlt im Quellbaum.\n" unless defined $TVIEW;

my $ECHTE_RC = lies(File::Spec->catfile($quelle, 'Eudora71', 'Eudora', 'EudoraRes.rc'));
die "Eudora71/Eudora/EudoraRes.rc fehlt im Quellbaum.\n" unless defined $ECHTE_RC;

# Baut eine kleine .rc mit dem angegebenen Stylesheet-Inhalt (ohne den
# aeusseren HTML-Rahmen, der wird hier ergaenzt).
sub kleine_rc
{
	my ($regeln, $klassenname) = @_;
	$klassenname = 'EUDORAHEADER' unless defined $klassenname;
	my $NL = $BS . 'r' . $BS . 'n';
	my $inhalt =
		'<HTML><HEAD><STYLE>' . $NL .
		'BODY {font-family=""%s""}' . $NL .
		'TT {font-family=""%s""}' . $NL .
		'BLOCKQUOTE.CITE {border-left:""solid %s"";}' . $NL .
		$regeln .
		'</STYLE></HEAD>' . $NL . '<BODY>' . $NL;
	return
		"STRINGTABLE DISCARDABLE\n" .
		"BEGIN\n" .
		"    IDS_EUDORAHEADER        \"$klassenname\"\n" .
		"    IDS_INI_READMESSAGE_STYLE_SHEET \n" .
		"                            \"MessageStyleSheet" . $BS . "n" . $inhalt . "\"\n" .
		"END\n";
}

my $GUTE_REGEL = 'SPAN.EUDORAHEADER {color:black; background-color:white; color:windowtext; background-color:window;}' . $BS . 'r' . $BS . 'n';

my @faelle;

# --- 1. der echte Fehler -------------------------------------------------

{
	my $rc = aus_commit($VOR, 'Eudora71/Eudora/EudoraRes.rc');
	if (!defined $rc)
	{
		print "ACHTUNG: Commit $VOR ist nicht erreichbar - der Fall 'Stand vor der\n";
		print "Behebung' wird UEBERSPRUNGEN. Das ist der wichtigste Fall der Sammlung.\n\n";
	}
	else
	{
		push @faelle, [ "echte EudoraRes.rc aus $VOR - vor der Behebung zu E-81", $rc, 1 ];
	}
}

# --- weitere Faelle, die MELDEN muessen ----------------------------------

push @faelle, [ 'gar keine Regel fuer EUDORAHEADER',
	kleine_rc(''), 1 ];

push @faelle, [ 'Regel ohne background-color - der halbe Befund',
	kleine_rc('SPAN.EUDORAHEADER {color:windowtext;}' . $BS . 'r' . $BS . 'n'), 1 ];

push @faelle, [ 'Regel ohne color',
	kleine_rc('SPAN.EUDORAHEADER {background-color:window;}' . $BS . 'r' . $BS . 'n'), 1 ];

push @faelle, [ 'ein einzelnes Prozentzeichen in der neuen Regel - die Format-Falle',
	kleine_rc('SPAN.EUDORAHEADER {color:windowtext; background-color:window; width:100%;}' . $BS . 'r' . $BS . 'n'), 1 ];

push @faelle, [ 'ein Platzhalter %s zu viel',
	kleine_rc('SPAN.EUDORAHEADER {color:%s; background-color:window;}' . $BS . 'r' . $BS . 'n'), 1 ];

push @faelle, [ 'MessageStyleSheet ganz verschwunden',
	"STRINGTABLE DISCARDABLE\nBEGIN\n    IDS_EUDORAHEADER \"EUDORAHEADER\"\nEND\n", 1 ];

push @faelle, [ 'IDS_EUDORAHEADER und die CSS-Klasse laufen auseinander',
	kleine_rc($GUTE_REGEL, 'EUDORAKOPFZEILE'), 1 ];

# --- Faelle, die STILL bleiben muessen -----------------------------------

push @faelle, [ 'die echte EudoraRes.rc von heute',
	$ECHTE_RC, 0 ];

push @faelle, [ 'die gute Regel in einer kleinen .rc',
	kleine_rc($GUTE_REGEL), 0 ];

push @faelle, [ 'ein verdoppeltes Prozentzeichen ist erlaubt',
	kleine_rc('SPAN.EUDORAHEADER {color:windowtext; background-color:window; width:100%%;}' . $BS . 'r' . $BS . 'n'), 0 ];

push @faelle, [ 'Regel ohne den Elementnamen: .EUDORAHEADER statt SPAN.EUDORAHEADER',
	kleine_rc('.EUDORAHEADER {color:windowtext; background-color:window;}' . $BS . 'r' . $BS . 'n'), 0 ];

push @faelle, [ 'Regel mit reichlich Leerraum und anderer Reihenfolge',
	kleine_rc('SPAN.EUDORAHEADER  {  background-color : window ;  color : windowtext ;  }' . $BS . 'r' . $BS . 'n'), 0 ];

# ------------------------------------------------------------------- Lauf

my $ok = 0;
my $schlecht = 0;

print "Gegentest zu " . $werkzeug . "\n\n";

for my $fall (@faelle)
{
	my ($name, $rc, $erwartet) = @$fall;

	my $baum = tempdir(CLEANUP => 1);
	my $verz = File::Spec->catdir($baum, 'Eudora71', 'Eudora');
	make_path($verz);
	schreib(File::Spec->catfile($verz, 'EudoraRes.rc'), $rc);
	schreib(File::Spec->catfile($verz, 'TridentView.cpp'), $TVIEW);

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
