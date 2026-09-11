#!/usr/bin/perl
#
# Prueft jede Behauptung der Dokumentation ueber den INI-Abschnitt eines
# Schluessels gegen den Quelltext.
#
#   perl tools/pruefe-ini-abschnitte.pl            prueft und meldet
#   perl tools/pruefe-ini-abschnitte.pl --leise    nur Rueckgabewert
#   perl tools/pruefe-ini-abschnitte.pl --tabelle  gibt die Nummernbereiche aus
#   perl tools/pruefe-ini-abschnitte.pl --was KEY  sagt, wohin ein Schluessel gehoert
#
# Rueckgabe 0 = kein Mangel, 1 = Mangel gefunden, 2 = Aufruffehler.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Eudora ordnet JEDEN INI-Schluessel automatisch einem Abschnitt zu, allein
# nach seiner internen Nummer - GetSectionID, Eudora71/Eudora/rs.cpp:89-97.
# Steht ein Eintrag im falschen Abschnitt, wird er nicht gefunden. Es gibt
# keine Meldung und keinen Fehler; der eingebaute Wert gilt weiter.
#
# Am 11.09.2026 hat Gregor "UseMyFilterWindowPosition=1" nach [Settings]
# geschrieben, weil FILTER.md behauptete, dort gehoerten alle Schluessel hin.
# Die Nummer ist 10922, der Abschnitt also [Window Position]; Eudora las die
# eingebaute 0. Die Doku war schuld, nicht der Anwender.
#
# DAS WAR DAS ZWEITE MAL. Beim Nachpruefen der README fiel derselbe Fehler
# ein zweites Mal auf: dort stand dreimal "LogLevel" unter [Settings],
# obwohl die Nummer 10802 ist und damit [Debug] gilt. Eine Fehlerklasse, die
# sich wiederholt, braucht eine Schranke statt einer weiteren Korrektur.
#
# WAS GEPRUEFT WIRD
#
# 1. INI-Bloecke: eine Zeile "[Abschnitt]" setzt den Abschnitt, jede folgende
#    Zeile "Schluessel=Wert" ist eine Behauptung. Gilt fuer *.ini und fuer
#    ```ini-Bloecke in Markdown.
# 2. Markdown-Tabellenzeilen: enthaelt eine Zeile `Schluessel` in Ruecken-
#    strichen UND eine Zelle, die nur aus einem Abschnittsnamen besteht, ist
#    das eine Behauptung.
# 3. Fliesstext: "`Schluessel` ... im Abschnitt `[Settings]`" in einer Zeile.
#
# Schluessel, die in EudoraRes.rc keine Zeichenkette haben, werden
# uebersprungen - ueber sie kann dieses Werkzeug nichts sagen. Abschnitte,
# die GetSectionID gar nicht vergibt ([Mappings], [Open Windows],
# [Persona-...], [Personalities]), werden ebenfalls uebersprungen.
#
# DER UMFANG KOMMT AUS DER QUELLE. Die Dateiliste holt sich das Werkzeug mit
# "git ls-files" - eine von Hand gepflegte Liste waere beim naechsten neuen
# Dokument wieder unvollstaendig (Lehre "Pruefumfang nicht von Hand").

use strict;
use warnings;

my $leise   = 0;
my $tabelle = 0;
my $was;
for (my $i = 0; $i < @ARGV; $i++)
{
	my $a = $ARGV[$i];
	if    ($a eq '--leise')   { $leise = 1 }
	elsif ($a eq '--tabelle') { $tabelle = 1 }
	elsif ($a eq '--was')     { $was = $ARGV[++$i] }
	else { print STDERR "Unbekannte Angabe: $a\n"; exit 2 }
}

my $wurzel = `git rev-parse --show-toplevel 2>&1`;
chomp $wurzel;
if ($? != 0 || !-d $wurzel) { print STDERR "Kein git-Arbeitsbaum.\n"; exit 2 }
chdir $wurzel or do { print STDERR "chdir $wurzel: $!\n"; exit 2 };

my $RES_H = 'Eudora71/Eudora/resource.h';
my $RES_RC = 'Eudora71/Eudora/EudoraRes.rc';

for my $f ($RES_H, $RES_RC)
{
	next if -f $f;
	print STDERR "$f fehlt - ohne die Quelle kann nichts geprueft werden.\n";
	exit 2;
}

# ---------------------------------------------------------------- die Quelle

my %num;
{
	open my $fh, '<:raw', $RES_H or do { print STDERR "$RES_H: $!\n"; exit 2 };
	while (my $z = <$fh>)
	{
		$num{$1} = $2 if $z =~ /^#define\s+(\S+)\s+(\d+)/;
	}
	close $fh;
}

for my $b (qw(IDS_INISN_SETTINGS IDS_INISN_SETTINGS2 IDS_INISN_WINDOW_POSITION IDS_INISN_DEBUG))
{
	next if defined $num{$b};
	print STDERR "$b steht nicht in $RES_H - GetSectionID laesst sich nicht nachbilden.\n";
	exit 2;
}

my $G_SET2 = $num{IDS_INISN_SETTINGS2};
my $G_WPOS = $num{IDS_INISN_WINDOW_POSITION};
my $G_DBG  = $num{IDS_INISN_DEBUG};

# Die Namen der Abschnitte stehen nicht im Kopf, sondern in der Ressource.
my %abschnittsname;
my %schluessel;   # Name -> [ [IDS, Nummer, rc-Zeile], ... ]
{
	open my $fh, '<:raw', $RES_RC or do { print STDERR "$RES_RC: $!\n"; exit 2 };
	my $n = 0;
	while (my $z = <$fh>)
	{
		$n++;
		next unless $z =~ /^\s*(IDS_\w+)\s+"([^"\\]+?)(?:\\n.*?)?"\s*\r?\n?$/;
		my ($id, $text) = ($1, $2);
		next unless exists $num{$id};
		$abschnittsname{$id} = $text if $id =~ /^IDS_INISN_/;
		push @{ $schluessel{$text} }, [ $id, $num{$id}, $n ];
	}
	close $fh;
}

# GetSectionID, rs.cpp:89-97, Zeile fuer Zeile nachgebaut.
sub abschnitt_zu_nummer
{
	my ($v) = @_;
	return $num{IDS_INISN_SETTINGS}        if $v > $G_SET2;
	return $num{IDS_INISN_WINDOW_POSITION} if $v > $G_WPOS;
	return $num{IDS_INISN_DEBUG}           if $v > $G_DBG;
	return $num{IDS_INISN_SETTINGS};
}

sub abschnitt_name
{
	my ($v) = @_;
	my $id = abschnitt_zu_nummer($v);
	for my $k (keys %abschnittsname)
	{
		return $abschnittsname{$k} if $num{$k} == $id;
	}
	return "?";
}

# Welche Abschnittsnamen vergibt GetSectionID ueberhaupt? Nur diese drei
# koennen falsch sein; jeder andere Abschnitt wird nicht ueber GetSectionID
# angesprochen und ist deshalb nicht zu beurteilen.
my %vergeben = map { $_ => 1 }
	grep { defined }
	map  { my $id = $_; my ($t) = grep { $num{$_} == $num{$id} } keys %abschnittsname; $t ? $abschnittsname{$t} : undef }
	qw(IDS_INISN_SETTINGS IDS_INISN_WINDOW_POSITION IDS_INISN_DEBUG);

if ($tabelle)
{
	printf "Nummernbereich   Abschnitt        (aus %s und %s)\n", $RES_H, $RES_RC;
	printf "%-16s %s\n", "bis $G_DBG",                      '[' . abschnitt_name($G_DBG) . ']';
	printf "%-16s %s\n", ($G_DBG + 1) . " ... $G_WPOS",     '[' . abschnitt_name($G_WPOS) . ']';
	printf "%-16s %s\n", ($G_WPOS + 1) . " ... $G_SET2",    '[' . abschnitt_name($G_SET2) . ']';
	printf "%-16s %s\n", "ab " . ($G_SET2 + 1),             '[' . abschnitt_name($G_SET2 + 1) . ']';
	exit 0;
}

if (defined $was)
{
	if (!$schluessel{$was})
	{
		print "$was: steht nicht als Zeichenkette in $RES_RC - nicht zu beurteilen.\n";
		exit 1;
	}
	for my $e (@{ $schluessel{$was} })
	{
		my ($id, $v, $rc) = @$e;
		printf "%s = %d (%s, %s:%d) -> [%s]\n", $id, $v, $was, $RES_RC, $rc, abschnitt_name($v);
	}
	exit 0;
}

# ------------------------------------------------------------ die Dokumente

my @dateien = grep { /\.(md|ini)$/i } split /\n/, `git ls-files`;
@dateien = grep { !m{^Releases/} } @dateien;

my @mangel;

sub pruefe_behauptung
{
	my ($datei, $zeilennr, $key, $behauptet, $wie) = @_;
	return unless $vergeben{$behauptet};
	return unless $schluessel{$key};
	my @soll = map { abschnitt_name($_->[1]) } @{ $schluessel{$key} };
	my %soll = map { $_ => 1 } @soll;
	return if $soll{$behauptet};
	push @mangel, sprintf(
		"%s:%d  %s steht als [%s], gehoert aber nach [%s] (Nummer %s, %s)  [%s]",
		$datei, $zeilennr, $key, $behauptet, join('] oder [', @soll),
		join('/', map { $_->[1] } @{ $schluessel{$key} }),
		join('/', map { $_->[0] } @{ $schluessel{$key} }), $wie);
}

for my $datei (@dateien)
{
	open my $fh, '<:raw', $datei or next;
	my @zeilen = <$fh>;
	close $fh;

	my $ini_hier = ($datei =~ /\.ini$/i) ? 1 : 0;
	my $im_block = $ini_hier;
	my $abschnitt = '';

	for (my $i = 0; $i < @zeilen; $i++)
	{
		my $z = $zeilen[$i];
		$z =~ s/\r?\n\z//;
		my $nr = $i + 1;

		# ```ini ... ``` in Markdown
		if (!$ini_hier && $z =~ /^\s*```\s*(\w*)\s*$/)
		{
			my $sprache = lc $1;
			if ($im_block) { $im_block = 0; $abschnitt = '' }
			elsif ($sprache eq 'ini') { $im_block = 1; $abschnitt = '' }
			next;
		}

		if ($im_block)
		{
			if ($z =~ /^\s*\[([^\]]+)\]\s*$/) { $abschnitt = $1; next }
			next if $z =~ /^\s*[;#]/;
			if ($abschnitt ne '' && $z =~ /^\s*([A-Za-z][\w]*)\s*=/)
			{
				pruefe_behauptung($datei, $nr, $1, $abschnitt, 'INI-Block');
			}
			next;
		}

		next unless $datei =~ /\.md$/i;

		# Tabellenzeile: eine Zelle ist genau ein Abschnittsname.
		if ($z =~ /^\s*\|/)
		{
			my @zellen = split /\|/, $z;
			my @keys;
			my @sects;
			for my $c (@zellen)
			{
				my $roh = $c;
				$roh =~ s/^\s+|\s+$//g;
				$roh =~ s/^\*+//; $roh =~ s/\*+$//;
				$roh =~ s/^\s+|\s+$//g;
				if ($roh =~ /^`\[([^\]]+)\]`$/) { push @sects, $1; next }
				while ($c =~ /`([A-Za-z][\w]*)`/g) { push @keys, $1 }
			}
			if (@sects == 1)
			{
				pruefe_behauptung($datei, $nr, $_, $sects[0], 'Tabelle') for @keys;
			}
			next;
		}

		# Fliesstext: "`Schluessel` ... Abschnitt `[Settings]`"
		if ($z =~ /Abschnitt\s+`\[([^\]]+)\]`/)
		{
			my $sect = $1;
			my @keys;
			while ($z =~ /`([A-Za-z][\w]*)`/g) { push @keys, $1 }
			pruefe_behauptung($datei, $nr, $_, $sect, 'Fliesstext') for @keys;
		}
	}
}

if (@mangel)
{
	unless ($leise)
	{
		print "INI-Abschnitte: " . scalar(@mangel) . " Behauptung(en) stimmen nicht mit GetSectionID ueberein.\n\n";
		print "  $_\n" for @mangel;
		print "\nMassgeblich ist GetSectionID in Eudora71/Eudora/rs.cpp:89-97.\n";
		print "Die Bereiche zeigt: perl tools/pruefe-ini-abschnitte.pl --tabelle\n";
		print "Einen einzelnen Schluessel: perl tools/pruefe-ini-abschnitte.pl --was <Name>\n";
	}
	exit 1;
}

print "INI-Abschnitte: alle Angaben stimmen mit GetSectionID ueberein.\n" unless $leise;
exit 0;
