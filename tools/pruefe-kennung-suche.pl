#!/usr/bin/perl
# pruefe-kennung-suche.pl - HINWEIS (weist nie ab): eine neu geschriebene
# Suche ueber eine Nachrichtenkennung im Eudora-Quelltext.
#
# WARUM ES DAS GIBT
#
# In E-121 hat dieselbe Annahme dreimal getroffen: "die Kennung findet DIE
# Nachricht". GetSummaryFromUID(pSum->GetHash()) sucht im Zielordner; in einem
# IMAP-Ordner ist m_Hash die Server-UID, eindeutig, weil der Server sie
# vergibt. Die Vorab-Kopie einer lokal verschobenen Nachricht traegt aber ihre
# LOKALE Kennung - und die ist weder eindeutig noch von jeder UID verschieden:
#
#   PRUEFER-28 P1 (14.10.2026): alle Nachrichten aus Out haben Kennung 0 -
#                 entfernt worden waere eine fremde.
#   1.0.95 (15.10.2026):        Kennung 13 (alte UID aus einem frueheren
#                 IMAP-Abruf) = UID 13 einer fremden Mail im Ziel; Gregor sah
#                 "Attempt to add the message to mailbox Inbox failed".
#   N1 (offen):   dieselbe Suche auf der Quellseite.
#
# Die Zeile, die den Fall 1.0.95 angelegt hat, stand schon in 8008f96e
# (1.0.91), drei Pakete vorher:
#   pTargetToc->GetSummaryFromUID(pSum->GetHash())
# Dieser Hinweis haette dort angeschlagen.
# (Arbeitsweise/funktion-bringt-ihre-vorbedingung-mit.md, Nachtrag 15.10.2026)
#
# Gemessen an den letzten 300 Commits unter Eudora71/: angeschlagen haetten 6,
# alle zu E-121 (8008f96e, 7b95567a, 3731980c, 9578a1bf, a10adbda, d7439ee6).
# Ein seltener Hinweis wird gelesen.
#
# Kommentare werden vorher weggeworfen (Arbeitsweise/schranke-liest-nur-code.md).
#
# Aufruf:
#   perl tools/pruefe-kennung-suche.pl              - gestagter Zuwachs
#   perl tools/pruefe-kennung-suche.pl --commit <r> - Zuwachs eines Commits
#   perl tools/pruefe-kennung-suche.pl --selbsttest
#
# Rueckgabe: immer 0 (Hinweis), beim Selbsttest 1 wenn ein Fall falsch ist.

use strict;
use warnings;

my $MUSTER = qr/GetSummaryFromUID\s*\(|GetHash\s*\(\s*\)\s*[!=]=|[!=]=\s*[\w>.()-]*GetHash\s*\(\s*\)/;

sub ohne_kommentar {
    my ($z) = @_;
    $z =~ s{/\*.*?\*/}{}g;
    $z =~ s{//.*$}{};
    $z =~ s{"(?:[^"\\]|\\.)*"}{""}g;
    return $z;
}

sub trifft { my ($z) = @_; return ohne_kommentar($z) =~ $MUSTER ? 1 : 0; }

sub selbsttest {
    my @ja = (
        '			CSummary *pCopySum = (pSum->GetHash() != 0) ? pTargetToc->GetSummaryFromUID(pSum->GetHash()) : NULL;',
        '		CSummary *pVorab = pTargetToc->GetSummaryFromUID(pSum->GetHash());',
        '				if (pKandidat && pKandidat->GetHash() == ulId)',
        '	if (ulHash == pSum->GetHash())',
    );
    my @nein = (
        '	// E-121: nicht ueber GetSummaryFromUID(pSum->GetHash()) suchen',
        '	PutDebugLog(DEBUG_MASK_TOC, "GetSummaryFromUID(%lu)", ulHash);',
        '	pSum->SetHash(ulUid);',
        '	CSummary *pVorab = E121FindeVorabKopie(pTargetToc, pSum);',
    );
    my $f = 0;
    for (@ja)   { if (trifft($_)) { print "  [ok ] meldet: $_\n" } else { print "  [ROT] STUMM: $_\n"; $f++ } }
    for (@nein) { if (!trifft($_)) { print "  [ok ] still:  $_\n" } else { print "  [ROT] FEHLALARM: $_\n"; $f++ } }
    printf "  pruefe-kennung-suche --selbsttest: %d Faelle, %d falsch\n", @ja + @nein, $f;
    return $f ? 1 : 0;
}

my $modus = shift(@ARGV) // '';
exit selbsttest() if $modus eq '--selbsttest';

my @pfade = ('Eudora71/*.cpp', 'Eudora71/*.h', 'Eudora71/*.c');
my $diff;
if ($modus eq '--commit') {
    my $rev = shift(@ARGV) // die "Aufruf: $0 --commit <rev>\n";
    $diff = `git show -U0 --no-color --format= $rev -- @pfade`;
} else {
    $diff = `git diff --cached -U0 --no-color -- @pfade`;
}
$diff = '' unless defined $diff;

my ($datei, @treffer) = ('');
for my $z (split /\n/, $diff) {
    if ($z =~ m{^\+\+\+ b/(.*)$}) { $datei = $1; next; }
    next if $z =~ /^\+\+\+/;
    next unless $z =~ /^\+(.*)$/;
    my $inhalt = $1;
    $inhalt =~ s/\r$//;
    if (trifft($inhalt)) {
        (my $k = $inhalt) =~ s/^\s+//;
        $k = substr($k, 0, 110) . '...' if length $k > 113;
        push @treffer, "  $datei: $k";
    }
}
exit 0 unless @treffer;

print "HINWEIS pruefe-kennung-suche: neue Suche ueber eine Nachrichtenkennung:\n";
print "$_\n" for @treffer;
print "  Drei Fragen, bevor das so bleibt (E-121, dreimal getroffen):\n";
print "    1. Wer vergibt diese Kennung - Server (UID) oder Eudora lokal (m_Hash)?\n";
print "    2. In welchem Behaelter ist sie eindeutig - und wird GENAU DORT gesucht?\n";
print "    3. Kann ein anderer Vergeber im selben Behaelter denselben Wert haben\n";
print "       (Kennung 0 aus Out, alte UID aus einem frueheren IMAP-Abruf)?\n";
print "  Sicherer: ein Merkzeichen an der eigenen Kopie statt einer Suche ueber\n";
print "  einen fremden Schluessel (1.0.96, IstE121Vorab).\n";
exit 0;
