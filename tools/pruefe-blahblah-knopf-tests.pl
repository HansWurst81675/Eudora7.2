#!/usr/bin/perl
#
# Gegentest zu tools/pruefe-blahblah-knopf.pl.
#
#   perl tools/pruefe-blahblah-knopf-tests.pl
#
# Rueckgabe 0 = alle Faelle wie erwartet, 1 = ein Fall abweichend.
#
# JEDER FALL LAEUFT IN BEIDE RICHTUNGEN: gegen den echten Fehler und gegen
# den erlaubten Fall. Stumm und Fehlalarm kosten dasselbe (Lehre "Schranke
# gegentesten").
#
# DER MASSGEBLICHE FALL ist der erste: der Stand vor der Behebung, geholt
# mit "git show 567a5d8:...". 567a5d8 ist der letzte Commit, in dem beide
# Ansichten den Knopfzustand lasen, ohne ihn je zu setzen - woertlich der
# Zustand, den Gregor am 11.09.2026 an 1.0.45 gemeldet hat ("der bla bla
# button aendert nichts"). Faengt die Schranke den nicht, ist sie nutzlos.
# Ist der Commit im Arbeitsbaum nicht erreichbar, wird der Fall
# uebersprungen und das laut gesagt - eine stillschweigend ausgelassene
# Pruefung waere schlimmer als keine.
#
# Gearbeitet wird in einem Wegwerfverzeichnis unter dem Temp-Verzeichnis,
# das die drei beteiligten Dateien traegt. Die Schranke wird ueber
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

my $VOR = '567a5d8';   # letzter Commit vor der Behebung zu E-80, Teil 2

my @BETEILIGT = qw(
	TridentReadMessageView.cpp
	PgReadMsgView.cpp
	ReadMessageFrame.cpp
);

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

# Holt eine Datei aus einem alten Commit. Gibt undef zurueck, wenn der
# Commit nicht erreichbar ist.
sub aus_commit
{
	my ($rev, $rel) = @_;
	my $alt = getcwd();
	chdir $quelle or die $!;
	# Der Befehl wird zuerst gebaut und dann ausgefuehrt. Wer ihn im
	# Backtick-Ausdruck zusammensetzt, laesst die Verkettung NACH dem Aufruf
	# geschehen - der Befehl endet dann auf "2>" und die Shell bricht ab.
	my $befehl = 'git show ' . $rev . ':Eudora71/Eudora/' . $rel . ' 2>&1';
	my $t = `$befehl`;
	my $r = $?;
	chdir $alt or die $!;
	return ($r == 0 && defined $t && length $t) ? $t : undef;
}

# Die heutigen Fassungen einmal einlesen - sie sind die Grundlage fast aller
# Faelle.
my %heute;
for my $n (@BETEILIGT)
{
	my $t = lies(File::Spec->catfile($quelle, 'Eudora71', 'Eudora', $n));
	die "Eudora71/Eudora/$n fehlt im Quellbaum.\n" unless defined $t;
	$heute{$n} = $t;
}

# Eine kleine, vollstaendige Ansicht, die den Klick bindet - als dritte
# Ansicht fuer zwei der Faelle.
sub dritte_ansicht
{
	my ($schaltet_um) = @_;
	my $setzen = $schaltet_um ? <<'JA' : "";
	{
		extern UINT umsgButtonSetCheck;
		BOOL bVorher = m_pParentFrame->GetCheck(ID_BLAHBLAHBLAH);
		m_pParentFrame->SendMessage(umsgButtonSetCheck, ID_BLAHBLAHBLAH,
			bVorher ? FALSE : TRUE);
	}
JA
	return <<"ENDE";
#include "stdafx.h"
#include "DritteAnsicht.h"

BEGIN_MESSAGE_MAP(CDritteAnsicht, CView)
	ON_BN_CLICKED( ID_BLAHBLAHBLAH, OnBlahBlahBlah )
END_MESSAGE_MAP()

void CDritteAnsicht::OnBlahBlahBlah()
{
$setzen	bool bIsBlahBlahBlah = (m_pParentFrame->GetCheck(ID_BLAHBLAHBLAH) != 0);
	Reload(bIsBlahBlahBlah);
}
ENDE
}

# Entfernt den Block, der umsgButtonSetCheck schickt - genau das, was die
# Behebung eingefuegt hat.
sub ohne_setzen
{
	my ($t) = @_;
	$t =~ s/\{[^{}]*?extern\s+UINT\s+umsgButtonSetCheck;.*?\n\t\}\n//s;
	return $t;
}

# Verschiebt das Setzen hinter das letzte Lesen: syntaktisch da, wirkungslos.
sub setzen_ans_ende
{
	my ($t, $klasse) = @_;
	my $block;
	if ($t =~ s/(\{[^{}]*?extern\s+UINT\s+umsgButtonSetCheck;.*?\n\t\}\n)//s)
	{
		$block = $1;
	}
	return $t unless defined $block;
	# hinter das Reload am Ende von OnBlahBlahBlah setzen
	$t =~ s/(void\s+\Q$klasse\E::OnBlahBlahBlah\(\).*?\n)\}/$1$block\}/s;
	return $t;
}

my @faelle;

# --- 1. der echte Fehler: der Stand vor der Behebung ---------------------

{
	my %stand;
	my $fehlt = 0;
	for my $n (@BETEILIGT)
	{
		my $t = aus_commit($VOR, $n);
		if (!defined $t) { $fehlt = 1; last }
		$stand{$n} = $t;
	}
	if ($fehlt)
	{
		print "ACHTUNG: Commit $VOR ist nicht erreichbar - der Fall 'Stand vor der\n";
		print "Behebung' wird UEBERSPRUNGEN. Das ist der wichtigste Fall der Sammlung.\n\n";
	}
	else
	{
		push @faelle, [ "Stand vor der Behebung ($VOR) - der echte Fehler", \%stand, 1 ];
	}
}

# --- weitere Faelle, die MELDEN muessen ----------------------------------

push @faelle, [ 'Trident schaltet nicht mehr um',
	{ %heute, 'TridentReadMessageView.cpp' => ohne_setzen($heute{'TridentReadMessageView.cpp'}) }, 1 ];

push @faelle, [ 'Paige-Ansicht schaltet nicht mehr um',
	{ %heute, 'PgReadMsgView.cpp' => ohne_setzen($heute{'PgReadMsgView.cpp'}) }, 1 ];

push @faelle, [ 'eine DRITTE Ansicht kommt dazu und vergisst das Umschalten',
	{ %heute, 'DritteAnsicht.cpp' => dritte_ansicht(0) }, 1 ];

push @faelle, [ 'das Umschalten steht hinter dem letzten Lesen - wirkungslos',
	{ %heute, 'TridentReadMessageView.cpp' =>
		setzen_ans_ende($heute{'TridentReadMessageView.cpp'}, 'CTridentReadMessageView') }, 1 ];

{
	my $r = $heute{'ReadMessageFrame.cpp'};
	$r =~ s/ON_REGISTERED_MESSAGE\(umsgButtonSetCheck, OnButtonSetCheck\)//;
	push @faelle, [ 'ON_REGISTERED_MESSAGE fuer umsgButtonSetCheck faellt weg',
		{ %heute, 'ReadMessageFrame.cpp' => $r }, 1 ];
}

{
	my $r = $heute{'ReadMessageFrame.cpp'};
	$r =~ s/UINT\s+umsgButtonSetCheck\s*=\s*RegisterWindowMessage[^;]*;/UINT umsgButtonSetCheck = 0;/;
	push @faelle, [ 'RegisterWindowMessage faellt weg - das SendMessage geht ins Leere',
		{ %heute, 'ReadMessageFrame.cpp' => $r }, 1 ];
}

{
	my %ohne;
	for my $n (@BETEILIGT)
	{
		my $t = $heute{$n};
		$t =~ s/ON_BN_CLICKED\(\s*ID_BLAHBLAHBLAH\s*,\s*OnBlahBlahBlah\s*\)//g;
		$t =~ s/ON_BN_CLICKED\(\s*ID_BLAHBLAHBLAH,\s*OnBlahBlahBlah\s*\)//g;
		$t =~ s/ON_BN_CLICKED\([^)]*ID_BLAHBLAHBLAH[^)]*\)//g;
		$ohne{$n} = $t;
	}
	push @faelle, [ 'gar keine Bindung mehr - der Knopf reagiert nicht',
		\%ohne, 1 ];
}

# --- Faelle, die STILL bleiben muessen -----------------------------------

push @faelle, [ 'der heutige Stand', { %heute }, 0 ];

push @faelle, [ 'eine dritte Ansicht, die richtig umschaltet',
	{ %heute, 'DritteAnsicht.cpp' => dritte_ansicht(1) }, 0 ];

{
	my $d = dritte_ansicht(1);
	$d =~ s/ON_BN_CLICKED\( ID_BLAHBLAHBLAH, OnBlahBlahBlah \)/ON_COMMAND( ID_BLAHBLAHBLAH, OnBlahBlahBlah )/;
	push @faelle, [ 'Bindung ueber ON_COMMAND statt ON_BN_CLICKED - gleichwertig',
		{ %heute, 'DritteAnsicht.cpp' => $d }, 0 ];
}

push @faelle, [ 'eine Datei nennt ID_BLAHBLAHBLAH ohne Bindung (tote Funktion im Rahmen)',
	{ %heute, 'Erwaehnung.cpp' =>
		"void CIrgendwas::Tu()\n{\n\tif (GetCheck(ID_BLAHBLAHBLAH)) Blah();\n}\n" }, 0 ];

{
	# Der Kommentar der Behebung nennt selbst "GetCheck" und steht VOR dem
	# SendMessage. Wer Kommentare mitliest, meldet ausgerechnet die heile
	# Fassung (Lehre "Schranke liest nur Code"). Dieser Fall haelt das fest.
	my $t = $heute{'TridentReadMessageView.cpp'};
	$t =~ s{(void\s+CTridentReadMessageView::OnBlahBlahBlah\(\)\n\{\n)}
	       {$1\t// GetCheck(ID_BLAHBLAHBLAH) wird weiter unten gelesen - nur Prosa.\n}s;
	push @faelle, [ 'ein Kommentar mit GetCheck(ID_BLAHBLAHBLAH) vor dem Umschalten',
		{ %heute, 'TridentReadMessageView.cpp' => $t }, 0 ];
}

# ------------------------------------------------------------------- Lauf

my $ok = 0;
my $schlecht = 0;

print "Gegentest zu " . $werkzeug . "\n\n";

for my $fall (@faelle)
{
	my ($name, $dateien, $erwartet) = @$fall;

	my $baum = tempdir(CLEANUP => 1);
	my $verz = File::Spec->catdir($baum, 'Eudora71', 'Eudora');
	make_path($verz);
	schreib(File::Spec->catfile($verz, $_), $dateien->{$_}) for sort keys %$dateien;

	local $ENV{PRUEFWURZEL} = $baum;
	my $r = system("perl \"$werkzeug\" --leise");
	$r = $r >> 8;

	if ($r == $erwartet)
	{
		$ok++;
		printf "  ok    %-62s (Rueckgabe %d)\n", $name, $r;
	}
	else
	{
		$schlecht++;
		printf "  FEHLT %-62s (Rueckgabe %d, erwartet %d)\n", $name, $r, $erwartet;
	}
}

printf "\n%d von %d Faellen wie erwartet.\n", $ok, $ok + $schlecht;
exit($schlecht ? 1 : 0);
