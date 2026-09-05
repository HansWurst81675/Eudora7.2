#!/usr/bin/perl
# Sucht in einem Eudora-Postfach (.mbx) nach rohen UTF-8-Bytes.
#
#   perl tools/postfach-zeichen-pruefen.pl <postfach.mbx> [...]
#
# Warum: Eudora uebersetzt den Nachrichtenrumpf beim ABRUF nach Windows-1252
# (TextReader::ReadIt -> ISOTranslate). Im Postfach darf danach kein einziges
# vollstaendiges UTF-8-Zeichen mehr stehen. Steht doch eines da, ist es beim
# Abruf durchgerutscht - und wird in der Anzeige zu Bytesalat ("fÃ¼r" statt
# "fuer"), weil die Anzeige zu Recht windows-1252 ansagt (Befund Z-2).
#
# Das Skript LIEST nur. Es startet nichts und veraendert nichts.
#
# Rueckgabe: 0 wenn nichts gefunden wurde, sonst 1.
use strict; use warnings;

die "Aufruf: $0 <postfach.mbx> [...]\n" unless @ARGV;

my $gesamt = 0;

for my $datei (@ARGV)
{
	local $/;
	open(my $fh, '<:raw', $datei) or die "$datei: $!\n";
	my $inhalt = <$fh>;
	close $fh;

	# Nachrichtengrenzen: Eudora trennt mit "From ???@??? <Datum>".
	my @start;
	while ($inhalt =~ /\nFrom \?\?\?\@\?\?\? /g)
	{
		push @start, pos($inhalt) - length("From ???\@??? ") - 1;
	}
	push @start, length($inhalt);

	my $inDatei = 0;

	for my $i (0 .. $#start - 1)
	{
		my $von  = $start[$i];
		my $bis  = $start[$i + 1];
		my $nachricht = substr($inhalt, $von, $bis - $von);
		my ($betreff) = $nachricht =~ /^Subject: (.*)$/m;
		$betreff = defined $betreff ? $betreff : '(ohne Betreff)';
		$betreff =~ s/\s+$//;

		# Eine vollstaendige UTF-8-Folge: Kopfbyte C2..F4 gefolgt von
		# Folgebytes 80..BF. Einzelne CP1252-Bytes passen darauf nicht.
		while ($nachricht =~ /([\xC2-\xDF][\x80-\xBF]|[\xE0-\xEF][\x80-\xBF]{2}|[\xF0-\xF4][\x80-\xBF]{3})/g)
		{
			my $folge = $1;
			my $stelle = pos($nachricht) - length($folge);
			my $umfeld = substr($nachricht, ($stelle > 30 ? $stelle - 30 : 0), 70);
			$umfeld =~ s/[\r\n\t]/ /g;
			$umfeld =~ s/([\x80-\xFF])/sprintf("<%02X>", ord($1))/ge;

			printf("%s +%d  %s\n", $datei, $von + $stelle, substr($betreff, 0, 50));
			printf("    %s  %s\n",
				   join(' ', map { sprintf("%02X", ord($_)) } split //, $folge),
				   $umfeld);

			$inDatei++;
			$gesamt++;
		}
	}

	printf("%s: %d rohe UTF-8-Folgen in %d Nachrichten\n",
		   $datei, $inDatei, scalar(@start) - 1);
}

print "\n";
if ($gesamt)
{
	print "$gesamt Stellen gefunden. Beim Abruf ist Zeichensatzarbeit liegengeblieben.\n";
	exit 1;
}

print "Nichts gefunden: das Postfach ist durchgehend Windows-1252.\n";
exit 0;
