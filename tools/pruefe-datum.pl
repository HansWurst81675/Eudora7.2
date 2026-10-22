#!/usr/bin/perl
use strict;
use warnings;

# pruefe-datum.pl - steht in den Dokumenten ein Datum, das es noch gar nicht
# gibt?
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE SCHRANKE GIBT
# ---------------------------------------------------------------------------
#
# Am 17.10.2026 um 23:07 musste der Commit 8e832152 ein Datum berichtigen:
#
#     "Ich hatte in vier Dokumenten den 18.10.2026 eingetragen - Intern/AUFGABEN.md,
#      Intern/BEFUNDE.md, Releases/PAKETE.md und Intern/TESTPLAN.md. Gemessen mit date: es
#      ist der 17.10.2026, 23:06. Die Fassung 7.2.0.107 ist heute Abend
#      entstanden, nicht morgen."
#
# Aufgefallen ist es beim Nachmessen des Zeitstempels der gebauten Eudora.exe,
# NICHT durch eine Schranke. Der Commit haelt das selbst fest:
#
#     "nicht durch eine Schranke - keine prueft Datumsangaben gegen die Uhr."
#
# WAS DARAN DIE KLASSE IST: vier Dokumente waren sich einig, und alle vier
# waren falsch. doku-pruefen.pl haelt die Dokumente GEGENEINANDER und konnte
# deshalb nichts finden - Einigkeit ist kein Beweis
# (Arbeitsweise/einigkeit-ist-kein-beweis.md). Der Massstab muss von aussen
# kommen, und fuer ein Datum ist das die Uhr.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-datum.pl                  die vorgemerkten .md (pre-commit)
#   perl tools/pruefe-datum.pl --dateien a.md   genannte Dateien ganz
#   perl tools/pruefe-datum.pl --stichtag 2026-10-17   andere Uhr (Gegentest)
#   perl tools/pruefe-datum.pl --selbsttest
#
# GEPRUEFT WIRD NUR, WAS HINZUKOMMT. Im pre-commit werden allein die
# HINZUGEFUEGTEN Zeilen der vorgemerkten .md gelesen (git diff --cached -U0).
# Altbestand wird nicht angefasst: eine Schranke, die bei jedem Commit ueber
# fremde Altlasten meckert, wird entwaffnet
# (Arbeitsweise/schranke-gehoert-in-den-haken.md).
#
# AUSNAHME: steht in derselben Zeile das Wort "geplant", "Termin", "faellig"
# oder "Frist", ist ein Datum in der Zukunft erlaubt und gewollt.
#
# Rueckgabe: 0 = kein Datum aus der Zukunft, 1 = Mangel, 2 = Aufrufproblem.

my $wurzel = -f 'VERSION' ? '.' : '..';

my @dateien;
my $modus      = 'staged';
my $stichtag;
my $selbsttest = 0;

while (@ARGV) {
  my $a = shift @ARGV;
  if    ($a eq '--selbsttest') { $selbsttest = 1 }
  elsif ($a eq '--stichtag')   { $stichtag = shift @ARGV }
  elsif ($a eq '--dateien')    { $modus = 'dateien'; push @dateien, @ARGV; @ARGV = () }
  else { print "pruefe-datum.pl: unbekannter Schalter $a\n"; exit 2 }
}

# --- Die Uhr. Von aussen, nicht aus einem Dokument. ------------------------
my $heute;
if (defined $stichtag) {
  $stichtag =~ /^(\d{4})-(\d{2})-(\d{2})$/
    or do { print "pruefe-datum.pl: --stichtag braucht JJJJ-MM-TT\n"; exit 2 };
  $heute = "$1$2$3";
}
else {
  my @t = localtime;
  $heute = sprintf '%04d%02d%02d', $t[5] + 1900, $t[4] + 1, $t[3];
}

my $AUSNAHME = qr/geplant|Termin|faellig|f\xe4llig|Frist/i;

# WIE WEIT IN DIE ZUKUNFT GESCHAUT WIRD - und warum nicht weiter.
#
# Gesucht wird EIN Datum, das sich als heute ausgibt. Solche Datumsfehler
# liegen dicht an heute: der 18. statt des 17., der Monat statt des Vormonats.
# Ein Datum weit in der Zukunft ist dagegen fast immer Absicht - beim
# Gegentest gegen den echten Fall vom 17.10.2026 war der einzige Fehlalarm
# die Zeile "Alle Werte bleiben bis zum 19.01.2038" in Intern/BEFUNDE.md, der
# Ueberlauf der Unix-Zeit. Ein Fehlalarm kostet dasselbe wie eine stumme
# Pruefung (Arbeitsweise/schranke-gegentesten.md), deshalb endet das Fenster
# nach 31 Tagen.
my $FENSTER_TAGE = 31;

# Tageszahl aus JJJJMMTT, ohne Modul (Fliegel/Van Flandern).
sub tagzahl {
  my ($s) = @_;
  my ($j, $m, $t) = ($s =~ /^(\d{4})(\d{2})(\d{2})$/) or return 0;
  my $a  = int((14 - $m) / 12);
  my $y  = $j + 4800 - $a;
  my $mm = $m + 12 * $a - 3;
  return $t + int((153 * $mm + 2) / 5) + 365 * $y + int($y / 4)
           - int($y / 100) + int($y / 400) - 32045;
}

# Findet jedes Datum einer Zeile und gibt die aus der nahen Zukunft zurueck.
sub zukunft_in_zeile {
  my ($zeile, $grenze) = @_;
  return () if $zeile =~ $AUSNAHME;
  my $g = tagzahl($grenze);
  my @kandidaten;
  while ($zeile =~ /\b(\d{1,2})\.(\d{1,2})\.(\d{4})\b/g) {
    push @kandidaten, ["$1.$2.$3", sprintf('%04d%02d%02d', $3, $2, $1)];
  }
  while ($zeile =~ /\b(\d{4})-(\d{2})-(\d{2})\b/g) {
    push @kandidaten, ["$1-$2-$3", "$1$2$3"];
  }
  my @treffer;
  for my $k (@kandidaten) {
    my $d = tagzahl($k->[1]);
    next unless $d > $g && ($d - $g) <= $FENSTER_TAGE;
    push @treffer, $k;
  }
  return @treffer;
}

# --- Selbsttest ------------------------------------------------------------
if ($selbsttest) {
  my @faelle = (
    # Zeile                                       Uhr          erwartete Treffer
    [ 'Fassung 7.2.0.107 gebaut am 18.10.2026',   '20261017', 1 ],
    [ 'Fassung 7.2.0.107 gebaut am 17.10.2026',   '20261017', 0 ],
    [ 'Gregor am 14.09.2026: "das nervt mich"',   '20261017', 0 ],
    [ 'Stand 2026-10-18',                         '20261017', 1 ],
    [ 'Stand 2026-10-17',                         '20261017', 0 ],
    [ 'Release geplant fuer den 25.10.2026',      '20261017', 0 ],
    [ 'Termin 25.10.2026',                        '20261017', 0 ],
    [ 'Version 1.0.107 vom 17.10.2026, 23:05',    '20261017', 0 ],
    [ 'zwei Daten: 17.10.2026 und 19.10.2026',    '20261017', 1 ],
    [ 'Jahreswechsel 01.01.2027',                 '20261231', 1 ],
    [ 'Silvester 31.12.2026',                     '20261231', 0 ],
    [ 'kein Datum, nur Zahlen 1.0.107',           '20261017', 0 ],
    [ 'Alle Werte bleiben bis zum 19.01.2038',    '20261017', 0 ],
    [ 'Stand 30.09.2026',                         '20260917', 1 ],
    [ 'Stand 30.11.2026',                         '20261017', 0 ],
  );
  my $fehler = 0;
  for my $f (@faelle) {
    my @t   = zukunft_in_zeile($f->[0], $f->[1]);
    my $ist = scalar @t;
    if ($ist != $f->[2]) {
      print "  FEHLER: '$f->[0]' erwartet $f->[2], gemessen $ist\n";
      $fehler++;
    }
  }
  printf "pruefe-datum --selbsttest: %d Faelle, %d Fehler\n", scalar @faelle, $fehler;
  exit($fehler ? 1 : 0);
}

# --- Umfang ----------------------------------------------------------------
my @funde;

if ($modus eq 'dateien') {
  for my $d (@dateien) {
    open my $f, '<:raw', $d or do { print "pruefe-datum.pl: $d: $!\n"; exit 2 };
    my $n = 0;
    while (my $z = <$f>) {
      $n++;
      push @funde, [$d, $n, $_->[0], $z] for zukunft_in_zeile($z, $heute);
    }
    close $f;
  }
}
else {
  my @md = grep { /\.md$/ }
           split /\n/, `git -C "$wurzel" diff --cached --name-only --diff-filter=ACM`;
  for my $d (@md) {
    my @diff = split /\n/, `git -C "$wurzel" diff --cached -U0 -- "$d"`;
    my $n = 0;
    for my $z (@diff) {
      if ($z =~ /^\@\@ -\d+(?:,\d+)? \+(\d+)/) { $n = $1; next }
      next unless $z =~ /^\+(?!\+\+)(.*)$/;
      my $text = $1;
      push @funde, [$d, $n, $_->[0], $text] for zukunft_in_zeile($text, $heute);
      $n++;
    }
  }
}

# --- Urteil ----------------------------------------------------------------
if (@funde) {
  print "\n  pruefe-datum: EIN DATUM AUS DER ZUKUNFT\n";
  printf "  Uhr: %s-%s-%s\n\n", substr($heute,0,4), substr($heute,4,2), substr($heute,6,2);
  for my $f (@funde) {
    my $zeile = $f->[3];
    $zeile =~ s/\s+$//;
    $zeile = substr($zeile, 0, 100) . ' ...' if length($zeile) > 100;
    print "    $f->[0]:$f->[1]  $f->[2]\n      $zeile\n";
  }
  print "\n  Ein Dokument, das ein Datum nennt, das es noch nicht gibt, ist an\n";
  print "  dieser Stelle nicht nachrechenbar. Am 17.10.2026 stand der 18.10. in\n";
  print "  vier Dokumenten gleichzeitig (8e832152) - Einigkeit ist kein Beweis.\n";
  print "  Gewollte Zukunft: das Wort geplant, Termin, faellig oder Frist in\n";
  print "  dieselbe Zeile.\n\n";
  exit 1;
}

print "pruefe-datum: kein Datum aus der Zukunft\n" if $modus eq 'dateien';
exit 0;
