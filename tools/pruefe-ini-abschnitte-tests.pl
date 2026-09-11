#!/usr/bin/perl
#
# Gegentest zu tools/pruefe-ini-abschnitte.pl.
#
#   perl tools/pruefe-ini-abschnitte-tests.pl
#
# Rueckgabe 0 = alle Faelle wie erwartet, 1 = ein Fall abweichend.
#
# JEDER FALL LAEUFT IN BEIDE RICHTUNGEN. Eine Schranke, die nur gegen den
# Fehler gefahren wird, kann stumm sein; eine, die nur gegen den erlaubten
# Fall gefahren wird, kann Fehlalarm geben. Beides kostet dasselbe
# (Lehre "Schranke gegentesten").
#
# Gearbeitet wird in einem Wegwerf-Arbeitsbaum unter dem Temp-Verzeichnis,
# mit einem eigenen git-Repo - das Werkzeug holt seine Dateiliste ueber
# "git ls-files", also braucht der Test ein echtes Repo. Der Quellbaum wird
# nicht angefasst.

use strict;
use warnings;
use File::Temp qw(tempdir);
use File::Path qw(make_path);
use File::Spec;
use Cwd qw(abs_path);

my $werkzeug = abs_path($0);
$werkzeug =~ s/-tests\.pl$/.pl/;
die "Werkzeug nicht gefunden: $werkzeug\n" unless -f $werkzeug;

my $quelle = abs_path($0);
$quelle =~ s{[\\/]tools[\\/][^\\/]+$}{};

my $RES_H  = File::Spec->catfile($quelle, 'Eudora71', 'Eudora', 'resource.h');
my $RES_RC = File::Spec->catfile($quelle, 'Eudora71', 'Eudora', 'EudoraRes.rc');
die "resource.h fehlt\n"    unless -f $RES_H;
die "EudoraRes.rc fehlt\n"  unless -f $RES_RC;

my $ok = 0;
my $schlecht = 0;

# Ein Fall: Name, Dateiinhalt (als PRUEFUNG.md), erwarteter Rueckgabewert.
my @faelle = (
	# --- muss MELDEN (Rueckgabe 1) -------------------------------------
	[ 'INI-Block: LogLevel unter [Settings]',
	  "```ini\n[Settings]\nLogLevel=25759\n```\n", 1 ],
	[ 'INI-Block: UseMyFilterWindowPosition unter [Settings]',
	  "```ini\n[Settings]\nUseMyFilterWindowPosition=1\n```\n", 1 ],
	[ 'INI-Block: FiltersWindowPosition unter [Debug]',
	  "```ini\n[Debug]\nFiltersWindowPosition=1,2,580,480\n```\n", 1 ],
	[ 'Tabelle: LogLevel als [Settings]',
	  "| Schluessel | Abschnitt |\n|---|---|\n| `LogLevel` | `[Settings]` |\n", 1 ],
	[ 'Tabelle: fett geschriebener falscher Abschnitt',
	  "| Schluessel | Abschnitt |\n|---|---|\n| `MinScoreToJunk` | **`[Window Position]`** |\n", 1 ],
	[ 'Fliesstext: falscher Abschnitt',
	  "Der Schluessel `LogLevel` steht im Abschnitt `[Settings]` der Eudora.ini.\n", 1 ],

	# --- muss STILL bleiben (Rueckgabe 0) -------------------------------
	[ 'INI-Block: LogLevel unter [Debug]',
	  "```ini\n[Debug]\nLogLevel=58527\n```\n", 0 ],
	[ 'INI-Block: UseMyFilterWindowPosition unter [Window Position]',
	  "```ini\n[Window Position]\nUseMyFilterWindowPosition=1\n```\n", 0 ],
	[ 'Tabelle: LogLevel als [Debug]',
	  "| Schluessel | Abschnitt |\n|---|---|\n| `LogLevel` | `[Debug]` |\n", 0 ],
	[ 'Tabelle: fett geschriebener richtiger Abschnitt',
	  "| Schluessel | Abschnitt |\n|---|---|\n| `UseMyFilterWindowPosition` | **`[Window Position]`** |\n", 0 ],
	[ 'Fliesstext: richtiger Abschnitt',
	  "Der Schluessel `LogLevel` steht im Abschnitt `[Debug]` der Eudora.ini.\n", 0 ],
	[ 'Unbekannter Schluessel wird nicht beurteilt',
	  "```ini\n[Window Position]\nGibtEsNichtImRC=1\n```\n", 0 ],
	[ 'Nicht vergebener Abschnitt wird nicht beurteilt',
	  "```ini\n[Open Windows]\nLogLevel=1\n```\n", 0 ],
	[ 'Kommentarzeile im INI-Block zaehlt nicht',
	  "```ini\n[Settings]\n; LogLevel=25759\n```\n", 0 ],
	[ 'Kein ini-Block: reiner Text bleibt unbeachtet',
	  "```\n[Settings]\nLogLevel=25759\n```\n", 0 ],
	[ 'Tabelle ohne Abschnittszelle bleibt unbeachtet',
	  "| Schluessel | was er tut |\n|---|---|\n| `LogLevel` | steuert das Protokoll |\n", 0 ],
);

my $tmp = tempdir(CLEANUP => 1);

for my $fall (@faelle)
{
	my ($name, $inhalt, $erwartet) = @$fall;

	my $baum = File::Spec->catdir($tmp, 'b' . ($ok + $schlecht));
	make_path(File::Spec->catdir($baum, 'Eudora71', 'Eudora'));

	kopiere($RES_H,  File::Spec->catfile($baum, 'Eudora71', 'Eudora', 'resource.h'));
	kopiere($RES_RC, File::Spec->catfile($baum, 'Eudora71', 'Eudora', 'EudoraRes.rc'));

	open my $fh, '>:raw', File::Spec->catfile($baum, 'PRUEFUNG.md') or die $!;
	print $fh $inhalt;
	close $fh;

	# core.autocrlf=false: der Wegwerf-Baum soll die Dateien nehmen, wie sie
	# sind, und nicht bei jedem Fall drei Warnungen ueber Zeilenenden ausgeben.
	system("git -C \"$baum\" init -q") == 0 or die "git init\n";
	system("git -C \"$baum\" config core.autocrlf false") == 0 or die "git config\n";
	system("git -C \"$baum\" add -A -f") == 0 or die "git add\n";

	my $alt = Cwd::getcwd();
	chdir $baum or die $!;
	my $r = system("perl \"$werkzeug\" --leise");
	chdir $alt or die $!;
	$r = $r >> 8;

	if ($r == $erwartet)
	{
		$ok++;
		printf "  ok    %-58s (Rueckgabe %d)\n", $name, $r;
	}
	else
	{
		$schlecht++;
		printf "  FEHLT %-58s (Rueckgabe %d, erwartet %d)\n", $name, $r, $erwartet;
	}
}

sub kopiere
{
	my ($von, $nach) = @_;
	open my $i, '<:raw', $von or die "$von: $!";
	local $/; my $d = <$i>; close $i;
	open my $o, '>:raw', $nach or die "$nach: $!";
	print $o $d; close $o;
}

printf "\n%d von %d Faellen wie erwartet.\n", $ok, $ok + $schlecht;
exit($schlecht ? 1 : 0);
