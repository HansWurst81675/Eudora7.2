#!/usr/bin/perl
use strict;
use warnings;

# pruefe-messziel.pl - ein Messziel wird an einem Merkmal DER SACHE erkannt,
# nicht an einer Eigenschaft, die viele teilen.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 21.10.2026 sollte fuer E-135 die Hoehe der Vervollstaendigungsbox ueber
# sechs Cursor-Schritte gemessen werden. Der erste Messlauf suchte die Box
# nach ihrer FENSTERKLASSE:
#
#     $box = AlleFenster $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' } |
#            Select-Object -First 1
#
# "#32770" ist die Klasse JEDES Windows-Dialogs. Gefunden wurde der
# Kontenassistent: 453 x 341, ueber alle sechs Schritte unveraendert. Die
# Messung gab Zahlen aus, die Zahlen waren plausibel, und sie sahen aus wie
# "kein Fehler". Gemessen war nichts.
#
# Erst die Suche nach einem Merkmal DER SACHE - ein Dialog, der eine
# SysListView32 enthaelt - traf die Box, und dann war der Fehler sofort da:
# 100x62, 84x46, 68x30, 52x14, 36x14, 20x14.
#
# Der Unterschied zu den beiden benachbarten Lehren:
#   - ausbleiben-ist-kein-befund: die Messung gibt NICHTS aus. Hier gab sie
#     sechs saubere Zeilen aus.
#   - messung-muss-den-weg-treffen: der gepruefte WEG lief nicht. Hier lief
#     der Weg; getroffen wurde das falsche OBJEKT.
#
# Lehre: Arbeitsweise/messziel-am-merkmal-erkennen.md
#
# ---------------------------------------------------------------------------
# WAS GEPRUEFT WIRD
# ---------------------------------------------------------------------------
#
# Geflaggt wird eine Stelle, die
#   (a) Fensterkandidaten auf eine MEHRDEUTIGE Klasse einschraenkt
#       (#32770, Edit, Button, ListBox ... - Klassen, von denen ein
#        laufendes Eudora mehrere hat), UND
#   (b) daraus GENAU EINEN auswaehlt (Select-Object -First 1, [0]), UND
#   (c) dabei kein weiteres unterscheidendes Merkmal nennt
#       (Id, Text/Titel, ein Kind, eine Sortierung, ein Ausschluss).
#
# Sichtbarkeit ($_.Vis, IsWindowVisible) zaehlt AUSDRUECKLICH NICHT als
# Merkmal: der Kontenassistent war sichtbar.
#
# Ueber ALLE Kandidaten zu laufen ist erlaubt und wird nicht geflaggt - wer
# jeden Dialog schliesst, waehlt keinen aus (tools/befehl-schicken.ps1,
# tools/strg-n-pruefen.ps1).
#
#   perl tools/pruefe-messziel.pl              - alle tools/*.ps1
#   perl tools/pruefe-messziel.pl <datei> ...  - nur diese
#   perl tools/pruefe-messziel.pl --selbsttest - Gegenprobe in beide Richtungen

my @MEHRDEUTIG = (
    '#32770', '#32768', 'Edit', 'Button', 'Static', 'ListBox', 'ComboBox',
    'SysListView32', 'SysTreeView32', 'SysHeader32', 'SysTabControl32',
    'ScrollBar', 'ToolbarWindow32', 'tooltips_class32', 'msctls_statusbar32',
    'RICHEDIT', 'RichEdit20A', 'RichEdit20W', 'Afx',
);

# Begriffe, die EIN STUECK aus der Menge herausheben. Bewusst NICHT dabei:
# Vis, Sichtbar, IsWindowVisible - Sichtbarkeit teilen sich viele Fenster.
my $MERKMAL = qr/
      \bId\b | GetDlgCtrlID | \bText\b | \bTitel\b | \bTitle\b
    | EnumChildWindows | \bKinder\b | \bListe\b
    | Sort-Object | -notcontains | -contains | \bvorher\b
    | GetWindowRect | Rechteck | \bIndex\b
/xi;

my $REDUKTION = qr/ Select(-Object)?\s+-First\s+1 | \)\s*\[0\] | \]\s*\[0\] | \}\s*\[0\] /xi;

sub mehrdeutige_klasse {
    my ($text) = @_;
    # nur Klassenvergleiche ansehen, nicht jedes Vorkommen des Wortes
    return 0 unless $text =~ /Klasse|GetClassName|ClassName/i;
    for my $k (@MEHRDEUTIG) {
        my $q = quotemeta $k;
        return $k if $text =~ /(?:-eq|-match|-like|==)\s*['"][^'"]*$q/i;
    }
    return 0;
}

# Zerlegt eine Datei in logische Anweisungen: Zeilen werden angehaengt,
# solange Klammern offen sind oder die Zeile auf | bzw. den
# Fortsetzungsgravis endet.
sub anweisungen {
    my (@zeilen) = @_;
    my @aus;
    my $puffer = '';
    my $start  = 0;
    my $tiefe  = 0;
    for my $i (0 .. $#zeilen) {
        my $z = $zeilen[$i];
        $start = $i + 1 unless length $puffer;
        $puffer .= ($puffer ? ' ' : '') . $z;
        my $ohne = $z;
        $ohne =~ s/(?<=\s)#.*$//;   # nur echte Kommentare
        $tiefe += ($ohne =~ tr/{([//);
        $tiefe -= ($ohne =~ tr/})]//);
        $tiefe = 0 if $tiefe < 0;
        my $offen = ($tiefe > 0) || ($ohne =~ /(?:\||`)\s*$/);
        next if $offen;
        push @aus, [ $start, $puffer ];
        $puffer = '';
        $tiefe  = 0;
    }
    push @aus, [ $start, $puffer ] if length $puffer;
    return @aus;
}

sub pruefe_text {
    my ($name, $inhalt) = @_;
    my @zeilen = split /\n/, $inhalt;
    my @funde;
    my %verdaechtig;          # Variablenname => [Zeile, Klasse]
    for my $a (anweisungen(@zeilen)) {
        my ($nr, $text) = @$a;
        next if $text =~ /^\s*#/;
        my $rein = $text;
        # Kommentar weg - aber NUR, wenn das Doppelkreuz nach einem
        # Leerzeichen steht. Ohne diese Bedingung frisst die Zeile die
        # Fensterklasse '#32770' selbst auf, und die Schranke wird genau
        # fuer den Fall blind, fuer den sie gebaut ist (gemessen beim
        # ersten Selbsttest: 10 von 12, die beiden echten Fehler stumm).
        $rein =~ s/(?<=\s)#.*$//;
        my $klasse  = mehrdeutige_klasse($rein);
        my $merkmal = ($rein =~ $MERKMAL) ? 1 : 0;
        my $redukt  = ($rein =~ $REDUKTION) ? 1 : 0;

        # Fall 1: alles in einer Anweisung
        if ($klasse && $redukt && !$merkmal) {
            push @funde, [ $nr, $klasse, $rein ];
            next;
        }
        # Fall 2: Zuweisung an eine Variable, Auswahl erst spaeter
        if ($klasse && !$merkmal && $rein =~ /^\s*\$(\w+)\s*=/) {
            $verdaechtig{$1} = [ $nr, $klasse ];
            next;
        }
        if ($redukt && !$merkmal) {
            for my $v (sort keys %verdaechtig) {
                next unless $rein =~ /\$\Q$v\E\b/;
                push @funde, [ $nr, $verdaechtig{$v}[1], $rein ];
                last;
            }
        }
    }
    return @funde;
}

# --------------------------------------------------------------------------
sub selbsttest {
    my @faelle = (
        # [ Name, Text, erwartete Trefferzahl ]
        [ 'der echte Fehler von E-135 (Klasse allein, dann First 1)',
          q{$box = AlleFenster $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' } | Select-Object -First 1},
          1 ],
        [ 'derselbe Fehler ueber zwei Anweisungen',
          qq{\$k = AlleFenster \$pp | Where-Object { \$_.Vis -and \$_.Klasse -eq '#32770' }\n\$box = \$k | Select-Object -First 1},
          1 ],
        [ 'die Behebung: ueber alle Kandidaten laufen, ein Kind entscheidet',
          qq{\$kandidaten = AlleFenster \$pp | Where-Object { \$_.Vis -and \$_.Klasse -eq '#32770' }\nforeach (\$k in \$kandidaten) { Kindersuche \$k.H }},
          0 ],
        [ 'Klasse plus Id',
          q{$baum = Alle $pp | Where-Object { $_.Klasse -eq 'SysTreeView32' -and $_.Id -eq 436 } | Select-Object -First 1},
          0 ],
        [ 'Klasse plus Fenstertext',
          q{$d = Alle $pp | Where-Object { $_.Klasse -eq '#32770' -and $_.Text -match 'Ueber' } | Select-Object -First 1},
          0 ],
        [ 'eindeutige Klasse (EudoraMainWindow) mit First 1',
          q{$haupt = Alle $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' } | Select-Object -First 1},
          0 ],
        [ 'Sichtbarkeit allein reicht NICHT als Merkmal',
          q{$x = Alle $pp | Where-Object { $_.Klasse -eq 'ListBox' -and $_.Vis } | Select-Object -First 1},
          1 ],
        [ 'mehrdeutige Klasse, aber keine Auswahl (alle schliessen)',
          q{foreach ($f in $fenster) { if ($f.Klasse -eq "#32770" -and $f.Sichtbar) { Schliessen $f.H } }},
          0 ],
        [ 'Klasse plus Sortierung und Ausschluss (messen-e135, To-Feld)',
          qq{\$felder = AlleFenster \$pp | Where-Object { \$_.Vis -and (\$_.Klasse -match 'RICHEDIT|Edit') -and (\$vorher -notcontains \$_.H) }\n\$to = \$felder | Sort-Object { (Rechteck \$_.H).T } | Select-Object -First 1},
          0 ],
        [ 'Indexzugriff [0] statt Select-Object',
          q{$box = @(Alle $pp | Where-Object { $_.Klasse -eq 'SysListView32' })[0]},
          1 ],
        [ 'ein Kommentar, der den Fehler beschreibt, zaehlt nicht',
          q{# $box = Alle $pp | Where-Object { $_.Klasse -eq '#32770' } | Select-Object -First 1},
          0 ],
        [ 'gar kein Fenstercode',
          q{$erster = $zahlen | Where-Object { $_ -gt 3 } | Select-Object -First 1},
          0 ],
    );
    my $gut    = 0;
    my $gesamt = 0;
    for my $f (@faelle) {
        my ($name, $text, $soll) = @$f;
        my @t  = pruefe_text('selbsttest', $text);
        my $ist = scalar @t;
        $gesamt++;
        if ($ist == $soll) { $gut++; printf "  ok    %-62s (%d)\n", $name, $ist; }
        else               { printf "  FEHL  %-62s soll %d ist %d\n", $name, $soll, $ist; }
    }
    printf "\n  %d von %d Faellen bestanden.\n", $gut, $gesamt;
    return $gut == $gesamt ? 0 : 1;
}

# --------------------------------------------------------------------------
my @argv = @ARGV;
if (@argv && $argv[0] eq '--selbsttest') { exit selbsttest(); }

my @dateien = @argv;
@dateien = glob('tools/*.ps1') unless @dateien;

my $treffer = 0;
my $gelesen = 0;
for my $d (@dateien) {
    next unless -f $d;
    open my $fh, '<', $d or next;
    my $inhalt = do { local $/; <$fh> };
    close $fh;
    $gelesen++;
    for my $f (pruefe_text($d, $inhalt)) {
        my ($nr, $klasse, $text) = @$f;
        $treffer++;
        $text =~ s/\s+/ /g;
        $text = substr($text, 0, 110) . '...' if length($text) > 110;
        print "\n  $d:$nr  waehlt EIN Fenster nach der mehrdeutigen Klasse '$klasse' aus:\n";
        print "      $text\n";
        print "      -> an einem Merkmal DER SACHE erkennen (Id, Text, ein Kind,\n";
        print "         eine Sortierung). Arbeitsweise/messziel-am-merkmal-erkennen.md\n";
    }
}
print "\n  ------------------------------------------------------------\n";
print "  Messziel: an einem Merkmal der Sache erkannt?\n";
print "  ------------------------------------------------------------\n";
printf "    geprueft                      %d Dateien\n",   $gelesen;
printf "    Auswahl nach Klasse allein    %d\n\n",         $treffer;
print($treffer
      ? "  Mindestens ein Messziel haengt an einer geteilten Eigenschaft.\n"
      : "  Kein Messziel haengt allein an einer mehrdeutigen Fensterklasse.\n");
exit($treffer ? 1 : 0);
