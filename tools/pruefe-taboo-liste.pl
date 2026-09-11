#!/usr/bin/perl
#
# Schranke zu BEFUND E-80, TEIL 1: die Liste der versteckten Kopfzeilen.
#
#   perl tools/pruefe-taboo-liste.pl            prueft und meldet
#   perl tools/pruefe-taboo-liste.pl --leise    nur Rueckgabewert
#   perl tools/pruefe-taboo-liste.pl --liste    gibt die Liste aus, ein Eintrag je Zeile
#
# Rueckgabe 0 = kein Mangel, 1 = Mangel gefunden, 2 = Aufruffehler.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Der Knopf "Blah Blah Blah" versteckt genau die Kopfzeilen, die in
# TabooHeaders stehen (Eudora71/Eudora/EudoraRes.rc, Kennung 10207,
# IDS_INI_USER_TABOO_HEADERS). Diese Liste stammte aus 2006: sie kannte
# X-UID, aber nicht X-; Received, aber nicht DKIM-. Gregor am 11.09.2026 an
# 1.0.44: "er wird immer angezeigt." Der Knopf war nie kaputt - die Liste
# war es. 16 Eintraege sind ergaenzt worden.
#
# Eine Liste in einer Ressourcenzeichenkette ist das Erste, was bei einem
# Ressourcenumbau, einem Ruecksetzen der .rc oder einem Merge verlorengeht,
# und niemand merkt es: das Programm startet, der Knopf reagiert, nur
# versteckt er wieder nichts. Genau dafuer ist diese Schranke da.
#
# WAS GEPRUEFT WIRD
#
# 1. Die Zeichenkette TabooHeaders gibt es ueberhaupt, und zu ihr die
#    Kennung IDS_INI_USER_TABOO_HEADERS in resource.h.
# 2. Die 28 Eintraege der Originalliste von 2006 stehen UNVERAENDERT und in
#    der urspruenglichen Reihenfolge am Anfang. Sie sind gewachsenes
#    Verhalten; wer sie kuerzt, laesst wieder etwas sichtbar werden, das seit
#    zwanzig Jahren versteckt war.
# 3. Alle 16 ergaenzten Eintraege sind da.
# 4. Kein Eintrag ist leer, keiner traegt ein fuehrendes oder abschliessendes
#    Leerzeichen, keiner steht doppelt. Ein Leerzeichen nach dem Komma ist
#    kein Schoenheitsfehler, sondern macht den Eintrag WIRKUNGSLOS: verglichen
#    wird mit strnicmp gegen den Anfang der Kopfzeile, und " DKIM-" kommt dort
#    nie vor.
# 5. KEIN Eintrag ist Praefix einer Kopfzeile, die ein Mensch immer sehen
#    will (From, To, Cc, Bcc, Subject, Date, Reply-To, Sender). Das ist der
#    eigentliche Schaden beim Ergaenzen: wer "S" oder "Re" auf die Liste
#    setzt, loescht Subject beziehungsweise Reply-To aus der Anzeige. Der
#    Vergleich ist ein reiner Praefixvergleich, das laesst sich hier
#    ausrechnen, ohne Eudora zu starten.
#
# DER VERGLEICH IM PROGRAMM, den Punkt 5 nachbildet:
#   strnicmp( Listeneintrag, Kopfzeile, Laenge(Listeneintrag) )
#   Eudora71/Eudora/TridentReadMessageView.cpp:2465 (HTML-Ansicht),
#   gleichlautend Eudora71/Eudora/ReadMessageDoc.cpp:504 (Paige-Ansicht).
#
# Diese beiden Zeilennummern sind am 11.09.2026 nachgemessen worden. BEFUNDE.md
# und tools/taboo-rechnen.pl nennen 2444 und 499; beides stimmt nicht. 2444
# war vor der Behebung zu E-80 Teil 2 die Zeile 2445 und ist seither 2465
# (der Patch hat 21 Zeilen davor eingefuegt); 499 war nie richtig, die Stelle
# steht in jedem Commit des Repos auf 504.
#
# GEGENPROBE: tools/pruefe-taboo-liste-tests.pl. Wer diese Datei anfasst,
# laesst die Sammlung laufen (Lehre "Schranke gegentesten").

use strict;
use warnings;

my $leise = 0;
my $nurliste = 0;
for my $a (@ARGV)
{
	if    ($a eq '--leise') { $leise = 1 }
	elsif ($a eq '--liste') { $nurliste = 1 }
	else { print STDERR "Unbekannte Angabe: $a\n"; exit 2 }
}

# Die Wurzel: PRUEFWURZEL geht vor, damit die Gegenprobe einen Wegwerfbaum
# ohne git-Repo benutzen kann.
my $wurzel = $ENV{PRUEFWURZEL};
if (!defined $wurzel || $wurzel eq '')
{
	$wurzel = `git rev-parse --show-toplevel 2>&1`;
	chomp $wurzel;
	if ($? != 0 || !-d $wurzel) { print STDERR "Kein git-Arbeitsbaum und kein PRUEFWURZEL.\n"; exit 2 }
}
chdir $wurzel or do { print STDERR "chdir $wurzel: $!\n"; exit 2 };

my $RES_RC = 'Eudora71/Eudora/EudoraRes.rc';
my $RES_H  = 'Eudora71/Eudora/resource.h';

for my $f ($RES_RC, $RES_H)
{
	next if -f $f;
	print STDERR "$f fehlt - ohne die Quelle kann nichts geprueft werden.\n";
	exit 2;
}

# Der Backslash wird als Zeichen gebildet, nicht als Escape geschrieben.
# Escape-Sequenzen durch mehrere Schichten waren schon Fehlerquelle
# (pruefe-bytes.pl haelt es genauso).
my $BS = chr(92);

# ------------------------------------------------------- die Liste einlesen

my $roh;
my $rc_zeile = 0;
{
	open my $fh, '<:raw', $RES_RC or do { print STDERR "$RES_RC: $!\n"; exit 2 };
	my $n = 0;
	while (my $z = <$fh>)
	{
		$n++;
		my $marke = '"TabooHeaders' . $BS . 'n';
		my $p = index($z, $marke);
		next if $p < 0;
		my $rest = substr($z, $p + length($marke));
		my $ende = index($rest, '"');
		next if $ende < 0;
		$roh = substr($rest, 0, $ende);
		$rc_zeile = $n;
		last;
	}
	close $fh;
}

my @mangel;

if (!defined $roh)
{
	print "TabooHeaders: die Zeichenkette steht nicht mehr in $RES_RC.\n" unless $leise;
	print <<'ENDE' unless $leise;

WAS FEHLT     Die Ressourcenzeichenkette "TabooHeaders" mitsamt ihrer Liste.
WARUM         Ohne sie versteckt der Knopf "Blah Blah Blah" keine einzige
              Kopfzeile mehr - genau der Zustand, den Gregor am 11.09.2026
              gemeldet hat ("er wird immer angezeigt").
WAS ZU TUN    Die Zeichenkette wiederherstellen. Sie gehoert zur Kennung
              IDS_INI_USER_TABOO_HEADERS (10207) und beginnt mit
              "TabooHeaders" gefolgt von der Liste, durch Kommata getrennt,
              OHNE Leerzeichen.
ENDE
	exit 1;
}

my @eintraege = split /,/, $roh, -1;

if ($nurliste)
{
	print "$_\n" for @eintraege;
	exit 0;
}

# -------------------------------------------------- 1. die Kennung in resource.h

{
	my $gefunden = 0;
	open my $fh, '<:raw', $RES_H or do { print STDERR "$RES_H: $!\n"; exit 2 };
	while (my $z = <$fh>)
	{
		$gefunden = 1 if $z =~ /^#define\s+IDS_INI_USER_TABOO_HEADERS\s+\d+/;
	}
	close $fh;
	push @mangel, "IDS_INI_USER_TABOO_HEADERS steht nicht mehr in $RES_H - die Liste ist dann nicht ansprechbar."
		unless $gefunden;
}

# ------------------------------------------- 2. die Originalliste von 2006

my @original = qw(
	X-UID Received Status X-UIDL Message In-Reply X-Priority Importance
	Mime-Version Content- X-Persona Resent-Message References Return X400
	X-400 Mail-System Errors-To X-List Delivery Disposition X-Juno
	Precedence X-Attachments X-MSMail X-MimeOLE X-Nav X-Habeas
);

if (@eintraege < @original)
{
	push @mangel, sprintf("die Liste hat nur %d Eintraege - die Originalliste von 2006 allein hat schon %d.",
		scalar @eintraege, scalar @original);
}
else
{
	for (my $i = 0; $i < @original; $i++)
	{
		next if lc($eintraege[$i]) eq lc($original[$i]);
		push @mangel, sprintf("Platz %d traegt '%s', die Originalliste von 2006 hat dort '%s'. Die 28 alten Eintraege muessen unveraendert und in ihrer Reihenfolge vorne stehen.",
			$i + 1, $eintraege[$i], $original[$i]);
		last;
	}
}

# ------------------------------------------------ 3. die 16 Ergaenzungen

my @ergaenzt = (
	'X-', 'DKIM-', 'ARC-', 'Authentication-Results', 'Envelope-To',
	'Delivered-To', 'List-', 'Feedback-ID', 'Thread-', 'Accept-Language',
	'User-Agent', 'Auto-Submitted', 'Autocrypt', 'UI-OutboundReport',
	'UI-InboundReport', 'msip_'
);

my %da = map { lc($_) => 1 } @eintraege;
my @fehlt = grep { !$da{ lc($_) } } @ergaenzt;

if (@fehlt)
{
	push @mangel, sprintf("%d der 16 ergaenzten Eintraege fehlen: %s",
		scalar @fehlt, join(', ', @fehlt));
}

# ------------------------------------------ 4. Form der einzelnen Eintraege

my %gesehen;
for (my $i = 0; $i < @eintraege; $i++)
{
	my $e = $eintraege[$i];
	my $nr = $i + 1;

	if ($e eq '')
	{
		push @mangel, "Platz $nr ist leer - zwei Kommata hintereinander oder ein Komma am Ende. Ein leerer Eintrag hat die Laenge 0, und strnicmp mit Laenge 0 trifft JEDE Kopfzeile: damit waere alles versteckt.";
		next;
	}
	if ($e =~ /^\s/ || $e =~ /\s$/)
	{
		push @mangel, "Platz $nr ('$e') traegt ein Leerzeichen am Rand. Verglichen wird gegen den Anfang der Kopfzeile; mit Leerzeichen trifft der Eintrag nie und wirkt gar nicht.";
		next;
	}
	if ($gesehen{ lc $e }++)
	{
		push @mangel, "Platz $nr ('$e') steht doppelt in der Liste.";
	}
}

# ---------------------------- 5. keine Kopfzeile erschlagen, die bleiben muss

# Diese acht sind das, was nach der Ergaenzung an echten Nachrichten uebrig
# bleiben soll. Sie sind der Inhalt, den ein Mensch liest.
my @muss_bleiben = qw(From To Cc Bcc Subject Date Reply-To Sender);

for my $kopf (@muss_bleiben)
{
	my $zeile = $kopf . ': x';
	for my $e (@eintraege)
	{
		next if $e eq '';
		next unless lc(substr($zeile, 0, length $e)) eq lc($e);
		push @mangel, sprintf("der Eintrag '%s' versteckt die Kopfzeile '%s:'. Der Vergleich ist ein Praefixvergleich (strnicmp, TridentReadMessageView.cpp:2465) - '%s' steht am Anfang von '%s:', also verschwindet sie.",
			$e, $kopf, $e, $kopf);
		last;
	}
}

# ------------------------------------------------------------------ Ergebnis

if (@mangel)
{
	unless ($leise)
	{
		printf "TabooHeaders (%s:%d): %d Mangel.\n\n", $RES_RC, $rc_zeile, scalar @mangel;
		print "  $_\n\n" for @mangel;
		print <<'ENDE';
WARUM ES ZAEHLT
  TabooHeaders sagt dem Knopf "Blah Blah Blah", welche Kopfzeilen als
  unwichtig gelten. Stimmt die Liste nicht, verstellt der Knopf entweder
  nichts (Befund E-80, Teil 1) oder er versteckt etwas, das man lesen will.
  Beides faellt beim Bauen und beim Starten nicht auf.

WAS ZU TUN
  Die Liste steht in einer einzigen Zeile in Eudora71/Eudora/EudoraRes.rc,
  hinter "TabooHeaders" und einem Zeilenumbruch-Escape. Aufbau: die 28
  Eintraege von 2006 unveraendert und in ihrer Reihenfolge, danach die 16
  ergaenzten. Getrennt durch Kommata OHNE Leerzeichen.
  Die derzeitige Liste zeigt:  perl tools/pruefe-taboo-liste.pl --liste
  Nachrechnen an einem echten Postfach:  perl tools/taboo-rechnen.pl <datei.mbx>
ENDE
	}
	exit 1;
}

printf "TabooHeaders: %d Eintraege, Originalliste unveraendert, alle 16 Ergaenzungen da, keine der acht Kopfzeilen erschlagen.\n",
	scalar @eintraege unless $leise;
exit 0;
