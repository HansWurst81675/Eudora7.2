#!/usr/bin/perl
#
# Gegentest zu tools/pruefe-taboo-liste.pl.
#
#   perl tools/pruefe-taboo-liste-tests.pl
#
# Rueckgabe 0 = alle Faelle wie erwartet, 1 = ein Fall abweichend.
#
# JEDER FALL LAEUFT IN BEIDE RICHTUNGEN. Eine Schranke, die nur gegen den
# Fehler gefahren wird, kann stumm sein; eine, die nur gegen den erlaubten
# Fall gefahren wird, kann Fehlalarm geben. Beides kostet dasselbe
# (Lehre "Schranke gegentesten").
#
# DER WICHTIGSTE FALL ist "Originalliste allein, Stand vor der Behebung":
# das ist woertlich der Zustand, den Gregor am 11.09.2026 an 1.0.44 gemeldet
# hat. Faengt die Schranke den nicht, ist sie nutzlos.
#
# Gearbeitet wird in einem Wegwerfverzeichnis unter dem Temp-Verzeichnis, in
# dem nur Eudora71/Eudora/EudoraRes.rc und resource.h liegen. Die Schranke
# wird ueber die Umgebungsvariable PRUEFWURZEL dorthin gezeigt; der Quellbaum
# wird nicht angefasst.

use strict;
use warnings;
use File::Temp qw(tempdir);
use File::Path qw(make_path);
use File::Spec;
use Cwd qw(abs_path);

my $werkzeug = abs_path($0);
$werkzeug =~ s/-tests\.pl$/.pl/;
die "Werkzeug nicht gefunden: $werkzeug\n" unless -f $werkzeug;

# Der Backslash als Zeichen, nicht als Escape - Escape-Sequenzen durch
# mehrere Schichten sind in diesem Projekt schon mehrfach zerbrochen.
my $BS = chr(92);

my $ORIGINAL = join(',', qw(
	X-UID Received Status X-UIDL Message In-Reply X-Priority Importance
	Mime-Version Content- X-Persona Resent-Message References Return X400
	X-400 Mail-System Errors-To X-List Delivery Disposition X-Juno
	Precedence X-Attachments X-MSMail X-MimeOLE X-Nav X-Habeas
));

my $ERGAENZT = join(',',
	'X-', 'DKIM-', 'ARC-', 'Authentication-Results', 'Envelope-To',
	'Delivered-To', 'List-', 'Feedback-ID', 'Thread-', 'Accept-Language',
	'User-Agent', 'Auto-Submitted', 'Autocrypt', 'UI-OutboundReport',
	'UI-InboundReport', 'msip_');

my $HEUTE = $ORIGINAL . ',' . $ERGAENZT;

# Ein Fall: Name, Liste (undef = Zeichenkette ganz weglassen),
# resource.h-Inhalt (undef = der uebliche), erwarteter Rueckgabewert.
my @faelle = (

	# --- muss MELDEN (Rueckgabe 1) -------------------------------------

	[ 'Originalliste allein - der Stand VOR der Behebung',
	  $ORIGINAL, undef, 1 ],

	[ 'Zeichenkette TabooHeaders ganz verschwunden',
	  undef, undef, 1 ],

	[ 'Originalliste gekuerzt: X-UID fehlt vorne',
	  join(',', (split /,/, $ORIGINAL)[1 .. 27]) . ',' . $ERGAENZT, undef, 1 ],

	[ 'Originalliste umsortiert: die ersten beiden vertauscht',
	  'Received,X-UID,' . join(',', (split /,/, $ORIGINAL)[2 .. 27]) . ',' . $ERGAENZT, undef, 1 ],

	[ 'eine Ergaenzung fehlt: DKIM- ist weg',
	  $ORIGINAL . ',' . join(',', grep { $_ ne 'DKIM-' } split /,/, $ERGAENZT), undef, 1 ],

	[ 'Leerzeichen nach dem Komma - der Eintrag wirkt nie',
	  $ORIGINAL . ', ' . $ERGAENZT, undef, 1 ],

	[ 'leerer Eintrag durch doppeltes Komma - versteckt ALLES',
	  $HEUTE . ',', undef, 1 ],

	[ 'Dublette: DKIM- zweimal',
	  $HEUTE . ',DKIM-', undef, 1 ],

	[ 'ein Eintrag erschlaegt Subject',
	  $HEUTE . ',Subject', undef, 1 ],

	[ 'ein zu kurzer Eintrag erschlaegt Reply-To',
	  $HEUTE . ',Re', undef, 1 ],

	[ 'ein zu kurzer Eintrag erschlaegt Date und DKIM-Signature gleichermassen',
	  $HEUTE . ',D', undef, 1 ],

	[ 'Kennung IDS_INI_USER_TABOO_HEADERS aus resource.h verschwunden',
	  $HEUTE, "#define IDS_IRGENDWAS 10207\n", 1 ],

	# --- muss STILL bleiben (Rueckgabe 0) -------------------------------

	[ 'der heutige Stand: 28 alte plus 16 ergaenzte',
	  $HEUTE, undef, 0 ],

	[ 'heutiger Stand plus ein harmloser weiterer Eintrag',
	  $HEUTE . ',X-Spam-Flag', undef, 0 ],

	[ 'Ergaenzungen in anderer Reihenfolge - nur die Originalliste ist gebunden',
	  $ORIGINAL . ',' . join(',', reverse split /,/, $ERGAENZT), undef, 0 ],

	[ 'Originalliste in anderer Gross-/Kleinschreibung - strnicmp ist ohnehin blind dafuer',
	  lc($ORIGINAL) . ',' . $ERGAENZT, undef, 0 ],

	[ 'Sender bleibt stehen, obwohl "Sende" fast passt',
	  $HEUTE . ',Sendmail', undef, 0 ],
);

my $ok = 0;
my $schlecht = 0;

print "Gegentest zu " . $werkzeug . "\n\n";

for my $fall (@faelle)
{
	my ($name, $liste, $res_h, $erwartet) = @$fall;

	my $baum = tempdir(CLEANUP => 1);
	make_path(File::Spec->catdir($baum, 'Eudora71', 'Eudora'));

	my $rc = File::Spec->catfile($baum, 'Eudora71', 'Eudora', 'EudoraRes.rc');
	open my $o, '>:raw', $rc or die "$rc: $!";
	print $o "STRINGTABLE DISCARDABLE\n";
	print $o "BEGIN\n";
	print $o "    IDS_IRGENDWAS           \"Sonstiges" . $BS . "nWert\"\n";
	if (defined $liste)
	{
		print $o "    IDS_INI_USER_TABOO_HEADERS\n";
		print $o "                            \"TabooHeaders" . $BS . "n" . $liste . "\"\n";
	}
	print $o "END\n";
	close $o;

	my $h = File::Spec->catfile($baum, 'Eudora71', 'Eudora', 'resource.h');
	open my $o2, '>:raw', $h or die "$h: $!";
	print $o2 defined $res_h ? $res_h : "#define IDS_INI_USER_TABOO_HEADERS      10207\n";
	close $o2;

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
