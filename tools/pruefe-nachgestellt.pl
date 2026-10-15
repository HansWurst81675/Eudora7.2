#!/usr/bin/perl
# pruefe-nachgestellt.pl - kein Paket an Gregor ohne Nachstellung am eigenen
# Pruefstand: der alte Stand zeigt seinen Fehler, der neue nicht.
#
# WARUM ES DAS GIBT
#
# E-121 (Doppelanzeige nach dem Verschieben in einen IMAP-Ordner) ging am
# 15.10.2026 durch SECHS Pakete, 1.0.91 bis 1.0.96. Fuenf davon trugen in
# Releases/PAKETE.md eine Zeile "Gemessen", die keinen roten alten Stand
# nannte:
#
#   1.0.91  "Pruefstand: summen=1 im Fall mit Vorab-Kopie"   (Gegenprobe an
#           7.2.0.90 zeigte den Fehler in fuenf Laeufen NICHT - stattdessen
#           "deine Beobachtung an 1.0.90 als Nachweis")
#   1.0.92  "am Pruefstand nicht im Doppelfall gemessen"
#   1.0.93  "Am Pruefstand NICHT gemessen (vier Laeufe ... hingen ...)"
#   1.0.94  "am Pruefstand nicht gemessen"
#   1.0.95  "am Pruefstand nicht gemessen"
#
# Alle fuenf fielen bei Gregor durch. 1.0.96 war das erste Paket mit
# "an 1.0.95 Gregors Fehler nachgestellt, an 1.0.96 gruen" - und das erste,
# das er beim ersten Anlauf bestaetigt hat. Gregor dazwischen: "warum
# brauchen wir so viele anlaeufe, um es zu fixen? duerfte doch nicht so
# schwer sein?" (Arbeitsweise/erst-nachstellen-dann-ausliefern.md)
#
# WAS GEPRUEFT WIRD
#
# Nur der Zuwachs in Releases/PAKETE.md. Fuer jede neu geschriebene Zeile
# "| Gemessen | ..." in einem Abschnitt, der ein Testverzeichnis als
# "bereitgestellt" fuehrt, muss die Zeile einen roten alten Stand nennen:
#
#   - "Gegenprobe" oder "nachgestellt" (nicht verneint), oder
#   - "vorher rot" (ein Test, der den Fehler vor der Behebung zeigte), oder
#   - "an/mit <Fassung> ... Fehler/Meldung/rot/zeigt".
#
# Oder die Ausnahme steht ausdruecklich da: "ohne Nachstellung" UND ein
# woertliches Zitat Gregors in deutschen Anfuehrungszeichen. Ob ein Paket
# ungemessen zu ihm geht, entscheidet er, nicht ich.
#
# Verneint heisst: "nicht nachgestellt", "nicht reproduziert", "Gegenprobe
# ... nicht" - genau der Satz von 1.0.91.
#
# Aufruf:
#   perl tools/pruefe-nachgestellt.pl              - gestagten Zuwachs pruefen
#   perl tools/pruefe-nachgestellt.pl --commit <r> - Zuwachs eines Commits
#   perl tools/pruefe-nachgestellt.pl --selbsttest
#
# Rueckgabe: 0 = in Ordnung, 1 = Paket ohne Nachstellung.

use strict;
use warnings;

my $DATEI = 'Releases/PAKETE.md';
my $AUF = "\xe2\x80\x9e";    # deutsches Anfuehrungszeichen unten (UTF-8)
my $ZU  = "\xe2\x80\x9c";    # deutsches Anfuehrungszeichen oben (UTF-8)

# Liefert '' wenn die Zeile genuegt, sonst den Grund.
sub urteil {
    my ($z) = @_;
    if ($z =~ /ohne Nachstellung/i) {
        return '' if $z =~ /Gregor[^|]*\Q$AUF\E[^|]{4,}?\Q$ZU\E/;
        return '"ohne Nachstellung" ohne woertliches Zitat Gregors';
    }
    my $verneint =
        $z =~ /\bnicht\s+(?:\S+\s+){0,3}?(?:nachgestellt|reproduziert)/i
     || $z =~ /\b(?:nachgestellt|reproduziert)\b[^;|]{0,15}\bnicht\b/i
     || $z =~ /Gegenprobe[^;|]{0,80}?\bnicht\b/i;
    return 'Nachstellung verneint' if $verneint;
    return '' if $z =~ /\bGegenprobe\b/i;
    return '' if $z =~ /\bnachgestellt\b/i;
    return '' if $z =~ /\bvorher rot\b/i;
    return '' if $z =~ /\b(?:an|mit)\s+(?:1\.0|7\.2\.0)\.\d+\b[^;|]*?\b(?:rot|Fehler|Meldung|zeigt)/i;
    return 'kein roter alter Stand genannt';
}

# Abschnitte (## ...) der Datei; je Abschnitt: wird ein Testverzeichnis
# bereitgestellt?
sub bereitgestellt_je_zeile {
    my ($text) = @_;
    my %bereit;
    my @abschnitte = split /^(?=## )/m, $text;
    for my $a (@abschnitte) {
        my $b = ($a =~ /^\|\s*Testverzeichnis\s*\|[^\n]*bereitgestellt/mi) ? 1 : 0;
        for my $z (split /\n/, $a) {
            $bereit{$z} = 1 if $b && $z =~ /^\|\s*Gemessen\s*\|/;
        }
    }
    return \%bereit;
}

sub pruefe {
    my ($diff, $text) = @_;
    my $bereit = bereitgestellt_je_zeile($text);
    my @maengel;
    for my $z (split /\n/, $diff) {
        next unless $z =~ /^\+(\|\s*Gemessen\s*\|.*)$/;
        my $zeile = $1;
        $zeile =~ s/\r$//;
        next unless $bereit->{$zeile};
        my $grund = urteil($zeile);
        push @maengel, [$grund, $zeile] if $grund ne '';
    }
    return @maengel;
}

sub selbsttest {
    my @rot = (
        '| Gemessen | Testsuite 209/209; am Pr' . "\xc3\xbc" . 'fstand nicht gemessen |',
        '| Gemessen | Testsuite 209/209; Am Pr' . "\xc3\xbc" . 'fstand NICHT gemessen (vier L' . "\xc3\xa4" . 'ufe hingen) |',
        '| Gemessen | Testsuite 209/209; Pr' . "\xc3\xbc" . 'fstand: `summen=1` im Fall mit Vorab-Kopie |',
        '| Gemessen | Gegenprobe mit 7.2.0.90 hat den Doppelfall in f' . "\xc3\xbc" . 'nf L' . "\xc3\xa4" . 'ufen nicht reproduziert |',
        '| Gemessen | am Pr' . "\xc3\xbc" . 'fstand nicht nachgestellt |',
        '| Gemessen | ohne Nachstellung, weil nur bei GMX |',
        '| Gemessen | Testsuite 207/207 |',
    );
    my @gruen = (
        '| Gemessen | Testsuite 209/209; Pr' . "\xc3\xbc" . 'fstand mit `--fremde-uid`: an 1.0.95 Gregors Fehler nachgestellt, an 1.0.96 gr' . "\xc3\xbc" . 'n |',
        '| Gemessen | IMAP-Pr' . "\xc3\xbc" . 'fserver: `text/html`; Gegenprobe 1.0.88 ohne `Content-Type` |',
        '| Gemessen | Testsuite 196/196 (`TestResolveURL.cpp` (8), vorher rot) |',
        '| Gemessen | am laufenden Programm: mit 7.2.0.84 Meldung, mit 7.2.0.86 keine |',
        '| Gemessen | ohne Nachstellung; Gregor am 15.10.2026: ' . $AUF . 'gib mir das so, ich teste es an GMX' . $ZU . ' |',
    );
    my $fehler = 0;
    for my $z (@rot) {
        my $g = urteil($z);
        if ($g ne '') { print "  [ok ] weist ab:  $z\n"; }
        else          { print "  [ROT] STUMM:     $z\n"; $fehler++; }
    }
    for my $z (@gruen) {
        my $g = urteil($z);
        if ($g eq '') { print "  [ok ] laesst durch: $z\n"; }
        else          { print "  [ROT] FEHLALARM ($g): $z\n"; $fehler++; }
    }
    # Abschnitt ohne bereitgestelltes Testverzeichnis wird nicht geprueft.
    my $text = "## 1.0.80 - kein Paket\n\n| Testverzeichnis | keines |\n| Gemessen | Testsuite 1/1 |\n";
    my @m = pruefe("+| Gemessen | Testsuite 1/1 |\n", $text);
    if (@m) { print "  [ROT] FEHLALARM: Abschnitt ohne Testverzeichnis geprueft\n"; $fehler++; }
    else    { print "  [ok ] Abschnitt ohne bereitgestelltes Testverzeichnis bleibt aussen vor\n"; }
    my $n = @rot + @gruen + 1;
    print "  pruefe-nachgestellt --selbsttest: $n Faelle, $fehler falsch\n";
    return $fehler ? 1 : 0;
}

my $modus = shift(@ARGV) // '';
exit selbsttest() if $modus eq '--selbsttest';

my ($diff, $text);
if ($modus eq '--commit') {
    my $rev = shift(@ARGV) // die "Aufruf: $0 --commit <rev>\n";
    $diff = `git show -U0 --no-color --format= $rev -- $DATEI`;
    $text = `git show $rev:$DATEI 2>/dev/null`;
} else {
    $diff = `git diff --cached -U0 --no-color -- $DATEI`;
    $text = `git show :$DATEI 2>/dev/null`;
}
$diff = '' unless defined $diff;
$text = '' unless defined $text;
exit 0 if $diff eq '';

my @maengel = pruefe($diff, $text);
exit 0 unless @maengel;

print "pruefe-nachgestellt: Paket an Gregor ohne Nachstellung am eigenen Pruefstand:\n";
for my $m (@maengel) {
    my ($grund, $z) = @$m;
    my $kurz = length($z) > 140 ? substr($z, 0, 137) . '...' : $z;
    print "  - $grund\n      $kurz\n";
}
print "  Ein Paket, das Gregors Fehler beheben soll, braucht vorher am eigenen\n";
print "  Pruefstand: der alte Stand zeigt seinen Fehler (rot), der neue nicht.\n";
print "  Gelingt das Nachstellen nicht, ist der Pruefstand das naechste\n";
print "  Arbeitspaket - nicht das naechste Paket. Ausnahme nur mit seinem Ja:\n";
print "  \"ohne Nachstellung\" und sein woertliches Zitat in die Zeile.\n";
print "  (Arbeitsweise/erst-nachstellen-dann-ausliefern.md)\n";
exit 1;
