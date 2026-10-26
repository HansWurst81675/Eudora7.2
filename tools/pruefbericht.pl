#!/usr/bin/perl
# pruefbericht.pl - erzeugt Releases/PRUEFBERICHT.md und das Testbuch
# Releases/pruefbericht-tests.tsv, oder vergleicht den heutigen Stand damit.
#
#   perl tools/pruefbericht.pl              Tests fahren, Bericht und Buch schreiben
#   perl tools/pruefbericht.pl --zeigen     dasselbe, aber nichts schreiben
#   perl tools/pruefbericht.pl --vergleich  Tests fahren und mit dem EINGECHECKTEN
#                                           Buch vergleichen - nichts schreiben
#   perl tools/pruefbericht.pl --ohne-bau   die Testsammlung nicht neu bauen
#
# Rueckgabe: 0 = alles gruen bzw. nichts neu rot, 1 = rot oder unvollstaendig
# bzw. neu rot, 2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 22.10.2026: "am ende schreiben wir ein reinen report mit
# versionsnummer, datum, testergebnissen usw. = pruefbericht. und haengen ihn
# mit rein ins repo."
#
# Am 24.10.2026, an der ersten Fassung: "version 0.121? wo ist der inhalt? wo
# sehe ich die tests? warum nicht schon 0.122?" - und dann, was er braucht:
#
#     "ich wollte im pruefbericht etwas mehr details sehen: welcher test ist
#      wann mit welchem build gelaufen."
#
#     "es geht beim test report = pruefbericht darum, wenn jemand das repo
#      clone und weiter entwickelt, dann moechte er die tests evtl. per hand
#      starten und sehen, was nicht geht (z.b. nach seiner aenderung). also
#      ein vergleich vorher - nachher"
#
# Die erste Fassung zeigte nur Summen und wurde von keinem Werkzeug
# aufgerufen; das Paket 1.0.122 kam ohne Bericht heraus (LEKTOR-56, L-56.7).
# Jetzt: jeder Test einzeln mit Zeitpunkt und Bau, ein maschinenlesbares Buch
# als "vorher", --vergleich fuer das "nachher", und paket-bauen.ps1 ruft
# dieses Werkzeug auf.
#
# ---------------------------------------------------------------------------
# WOHER DIE ERGEBNISSE KOMMEN
# ---------------------------------------------------------------------------
#
#   Unit-Tests   EudoraTests.exe wird HIER gefahren (vorher gebaut, ausser
#                mit --ohne-bau). Die Tests lesen den Quelltext im
#                Arbeitsbaum - ihr "Bau" ist also der Commit, plus Sternchen,
#                wenn der Baum nicht sauber war.
#   Schranken    tools/schranken-gegenprobe.pl wird HIER gefahren: jede
#                Schranke aus tools/regression-schranken.txt muss ihren
#                Rueckfall abweisen.
#   Pruefstand   wird NICHT hier gefahren - der Lauf oeffnet Fenster und
#                braucht Gregors Freigabe mit dem heutigen Datum (CLAUDE.md,
#                Abschnitt 4). Gelesen wird Intern/pruefstand-buch.tsv, das
#                tools/pruefstand-lauf.ps1 je Fall fortschreibt: Ergebnis,
#                Zeitpunkt, Pruefstand und die Baukennung aus dessen
#                Eudora.exe. Ein Fall, der an einer ANDEREN Fassung lief als
#                dem Quellstand, oder der im Buch fehlt, zaehlt nicht als
#                gruen (LEKTOR L-50.1, PRUEFER Fund 4a vom 22.10.2026).
#
# Kodierung: reines ASCII im Quelltext; der Bericht ist UTF-8 ohne BOM mit LF.

use strict;
use warnings;

my ($zeigen, $vergleich, $ohne_bau) = (0, 0, 0);
for my $a (@ARGV) {
    if    ($a eq '--zeigen')    { $zeigen = 1 }
    elsif ($a eq '--vergleich') { $vergleich = 1 }
    elsif ($a eq '--ohne-bau')  { $ohne_bau = 1 }
    else { print "  unbekannt: $a\n"; exit 2 }
}

my $wurzel = -f 'VERSION' ? '.' : '..';
unless (-f "$wurzel/VERSION") { print "  pruefbericht: aus der Wurzel aufrufen.\n"; exit 2 }

sub lies { my ($d) = @_; open my $h, '<:raw', $d or return undef; local $/; my $t = <$h>; close $h; $t }
sub zelle { my ($s) = @_; $s //= ''; $s =~ s/\|/\\|/g; $s =~ s/[\r\n\t]+/ /g; return $s }

# --- Fassung und Stand ---------------------------------------------------
my $paket = lies("$wurzel/VERSION") // '';
$paket =~ s/\s+//g;
my $vh = lies("$wurzel/Eudora71/Version.h") // '';
my @teile;
for my $n (1 .. 4) { push @teile, $1 if $vh =~ /^#define\s+EUDORA_VERSION$n\s+(\d+)/m }
my $quellstand = @teile == 4 ? join('.', @teile) : '(nicht gefunden)';

my $commit = `git -C "$wurzel" rev-parse --short HEAD 2>&1`; chomp $commit;
my $schmutz = `git -C "$wurzel" status --porcelain -- . ":(exclude)Releases/PRUEFBERICHT.md" ":(exclude)Releases/pruefbericht-tests.tsv" ":(exclude)Intern/pruefstand-buch.tsv" ":(exclude)Intern/pruefstand-ergebnis.txt" ":(exclude)tools/TESTLAEUFE.md" 2>&1`;
my $offen = () = $schmutz =~ /\n/g;
my $stand = $commit . ($offen ? '*' : '');

my @t = localtime;
my $jetzt = sprintf('%04d-%02d-%02d %02d:%02d', $t[5] + 1900, $t[4] + 1, $t[3], $t[2], $t[1]);

# --- 1. Unit-Tests: bauen und fahren --------------------------------------
my $t_unit = time;
my @unit;      # [bereich, name, ergebnis]
my $unit_lief = 0;
my @unvollstaendig;  # Gruende, warum ein Teil nicht vollstaendig lief
{
    my $bau_ok = 1;
    unless ($ohne_bau) {
        my $bau = `perl "$wurzel/tools/pruefe-tests-gruen.pl" 2>&1`;
        # Rote Tests zaehlen gleich aus den Einzelzeilen. Fehlt aber die
        # Zeile "Rueckgabewert", ist schon der BAU gescheitert - dann darf
        # die alte EudoraTests.exe nicht als heutiger Stand gelten
        # (PRUEFER-51 K2).
        $bau_ok = ($? == 0 or $bau =~ /Rueckgabewert\s+\d+/) ? 1 : 0;
        push @unvollstaendig, 'Bau der Testsammlung gescheitert - alte EudoraTests.exe nicht gefahren' unless $bau_ok;
    }
    my $exe = "$wurzel/Eudora71/Tests/Build/Debug/EudoraTests.exe";
    if ($bau_ok and -f $exe) {
        (my $win = $exe) =~ s{/}{\\}g;
        my $aus = `"$win" 2>&1`;
        my $rc = $? >> 8;
        # Ergebniszeile, Rueckgabe und gezaehlte Zeilen muessen
        # zusammenpassen. Gemessen PRUEFER-51 K2: ein exit(0) mitten im Lauf
        # liess 240 von 295 Tests laufen, und der Bericht hiess BESTANDEN.
        my ($n_ges, $n_ok, $n_fehl) = $aus =~ /Ergebnis:\s*(\d+) Tests,\s*(\d+) bestanden,\s*(\d+) fehlgeschlagen/;
        my $n_zeilen = () = $aus =~ /^\[(?:ok|FEHL)\s*\]/mg;
        if (!defined $n_ges) {
            push @unvollstaendig, "EudoraTests.exe ohne Ergebniszeile beendet (Rueckgabe $rc, $n_zeilen Testzeilen)";
        } elsif ($n_ges != $n_zeilen or $rc != $n_fehl) {
            push @unvollstaendig, "EudoraTests.exe: Ergebniszeile $n_ges Tests / $n_fehl rot, gezaehlt $n_zeilen Zeilen, Rueckgabe $rc";
        }
        my $bereich = '';
        my @z = split /\r?\n/, $aus;
        for my $i (0 .. $#z) {
            # Ein Bereich steht zwischen zwei Gleichheitszeichen-Linien.
            if ($i > 0 and $z[$i - 1] =~ /^=+$/ and $z[$i] !~ /^=+$/ and $i + 1 <= $#z and $z[$i + 1] =~ /^=+$/) {
                ($bereich = $z[$i]) =~ s/^\s+|\s+$//g;
                next;
            }
            if ($z[$i] =~ /^\[(ok|FEHL)\s*\]\s+(.+?)\s*$/) {
                push @unit, [$bereich, $2, $1 eq 'ok' ? 'ok' : 'FEHL'];
                $unit_lief = 1;
            }
        }
    }
}
my $unit_fehl = grep { $_->[2] ne 'ok' } @unit;
my $dauer_unit = time - $t_unit;

# --- 2. Schranken mit Rueckfallprobe --------------------------------------
my $t_schranke = time;
my @schranke;  # [kennung, schranke, ergebnis, text]
{
    my $aus = `perl "$wurzel/tools/schranken-gegenprobe.pl" 2>&1`;
    my %nr;
    for my $z (split /\r?\n/, $aus) {
        next unless $z =~ /^\s*\[\s*(ok|FEHL|[a-z]+)\s*\]\s+(\S+)\s+(\S+)\s+(.*)$/;
        # Mehrere Proben derselben Kennung und Schranke (E-35 R1-R3) bekommen
        # eine laufende Nummer - sonst fallen sie im Vergleich zu einem
        # Schluessel zusammen, und die gruene Zeile gewinnt (PRUEFER-51 K3).
        my $n = ++$nr{"$2 $3"};
        push @schranke, [$2 . ($n > 1 ? "#$n" : ''), $3, $1 eq 'ok' ? 'ok' : 'FEHL', $4];
    }
    # Soll ist die Liste selbst, nicht das, was zurueckkam: keine Zeile hiess
    # bisher "0 Schranken, gruen" (PRUEFER-51 K2).
    my $liste = lies("$wurzel/tools/regression-schranken.txt") // '';
    my $soll = grep { !/^\s*(#|$)/ } split /\r?\n/, $liste;
    push @unvollstaendig, sprintf('Schranken-Gegenprobe: %d von %d Proben zurueckgemeldet', scalar @schranke, $soll)
        if @schranke != $soll;
}
my $schranke_fehl = grep { $_->[2] ne 'ok' } @schranke;
my $dauer_schranke = time - $t_schranke;

# --- 3. Pruefstand: das Buch lesen ---------------------------------------
my (@soll, %muss);
{
    my $f = lies("$wurzel/tools/pruefstand-faelle.txt") // '';
    for my $z (split /\n/, $f) {
        next if $z =~ /^\s*(#|$)/;
        my @sp = split /\|/, $z, -1;
        next unless @sp >= 8;
        my ($k, $m, $d) = map { s/^\s+|\s+$//gr } @sp[0, 4, 5];
        push @soll, $k;
        $muss{$k} = length $m ? $m : "ohne $d";
    }
}
my %buch;      # kennung -> [ergebnis, zeit, pruefstand, bau, gemessen]
{
    my $b = lies("$wurzel/Intern/pruefstand-buch.tsv");
    if (defined $b) {
        $b =~ s/^\x{FEFF}//; $b =~ s/^\xEF\xBB\xBF//;
        for my $z (split /\r?\n/, $b) {
            next if $z =~ /^#/ or $z eq '';
            my @f = split /\t/, $z, -1;
            $buch{$f[0]} = [@f[1 .. 5]];
        }
    }
}
# Massstab fuer "derselbe Bau": die Baukennung in Bin\Release\Eudora.exe, aus
# der das Paket entsteht - Fassung, Commit, Sternchen und Zeit. Vorher reichte
# die Fassungsnummer, und ein Lauf auf 054b6e66* (vor der Behebung von E-119)
# galt als BESTANDEN (PRUEFER-51 K1). Ohne Release-Bau gilt die Fassung, aber
# ein Sternchen (Bau aus unsauberem Baum) zaehlt nie als derselbe Bau.
my $bin_kennung = '';
{
    my $exe = lies("$wurzel/Eudora71/Bin/Release/Eudora.exe") // '';
    ($bin_kennung) = $exe =~ /(Eudora \d+\.\d+\.\d+\.\d+ \/ Paket [ -~]+)/;
    $bin_kennung //= '';
}
my (@stand_zeilen, $st_gruen, $st_rot, $st_fehlt, $st_alt);
$_ = 0 for ($st_gruen, $st_rot, $st_fehlt, $st_alt);
for my $k (@soll) {
    my $e = $buch{$k};
    if (!$e) { push @stand_zeilen, [$k, 'NIE GELAUFEN', '', '', '', $muss{$k}]; $st_fehlt++; next }
    my ($erg, $zeit, $verz, $bau) = @$e;
    $bau //= '';
    my ($fassung) = $bau =~ /^Eudora (\d+\.\d+\.\d+\.\d+)/;
    my $anders = length $bin_kennung ? ($bau ne $bin_kennung ? 1 : 0)
               : (!$fassung or $fassung ne $quellstand or $bau =~ /\*/) ? 1 : 0;
    my $zeigen_erg = $erg eq 'ok' ? 'ok' : 'FEHL';
    if    ($erg ne 'ok') { $st_rot++ }
    elsif ($anders)      { $st_alt++; $zeigen_erg = 'ok, ANDERER BAU' }
    else                 { $st_gruen++ }
    push @stand_zeilen, [$k, $zeigen_erg, $zeit, $verz, $bau, $muss{$k}];
}

# --- Das Testbuch: eine Zeile je Test, Grundlage fuer den Vergleich -------
# Spalten: art, kennung, ergebnis, zeit, bau. Sortiert, damit ein Diff im
# Repository lesbar bleibt.
my @buchzeilen;
for my $u (@unit)     { push @buchzeilen, join("\t", 'unit', "$u->[0] / $u->[1]", $u->[2], $jetzt, "Quelltext $stand") }
for my $s (@schranke) { push @buchzeilen, join("\t", 'schranke', "$s->[0] ($s->[1])", $s->[2], $jetzt, "Quelltext $stand") }
for my $z (@stand_zeilen) { push @buchzeilen, join("\t", 'pruefstand', $z->[0], $z->[1], $z->[2], $z->[4]) }
@buchzeilen = sort @buchzeilen;

# --- --vergleich: heutiger Stand gegen das eingecheckte Buch --------------
if ($vergleich) {
    my $vorher = `git -C "$wurzel" show HEAD:Releases/pruefbericht-tests.tsv 2>&1`;
    if ($? != 0) { print "  Kein eingechecktes Testbuch (Releases/pruefbericht-tests.tsv) - nichts zu vergleichen.\n"; exit 2 }
    my (%alt, %neu);
    for my $z (split /\r?\n/, $vorher) { next if $z =~ /^#/ or $z eq ''; my @f = split /\t/, $z; $alt{"$f[0]\t$f[1]"} = $f[2] }
    for my $z (@buchzeilen)             { my @f = split /\t/, $z; $neu{"$f[0]\t$f[1]"} = $f[2] }
    my (@neu_rot, @neu_gruen, @neu_da, @weg, $gleich);
    $gleich = 0;
    for my $k (sort keys %neu) {
        my $n = $neu{$k} =~ /^ok/ ? 'ok' : 'rot';
        if (!exists $alt{$k}) { push @neu_da, "$k ($neu{$k})"; push @neu_rot, $k if $n eq 'rot'; next }
        my $a = $alt{$k} =~ /^ok/ ? 'ok' : 'rot';
        if    ($a eq 'ok'  and $n eq 'rot') { push @neu_rot, $k }
        elsif ($a eq 'rot' and $n eq 'ok')  { push @neu_gruen, $k }
        else                                { $gleich++ }
    }
    for my $k (sort keys %alt) { push @weg, $k unless exists $neu{$k} }
    my $zeig = sub {
        my ($titel, @l) = @_;
        printf "  %-34s %d\n", $titel, scalar @l;
        for my $x (@l) { (my $y = $x) =~ s/\t/  /g; print "      $y\n" }
    };
    print "\n  Vergleich mit dem eingecheckten Testbuch (Commit $commit)\n";
    print "  ------------------------------------------------------------\n";
    $zeig->('NEU ROT (vorher gruen oder neu)', @neu_rot);
    $zeig->('neu gruen (vorher rot)', @neu_gruen);
    $zeig->('neu hinzugekommen', @neu_da);
    $zeig->('weggefallen', @weg);
    printf "  %-34s %d\n", 'unveraendert', $gleich;
    print "  ------------------------------------------------------------\n";
    print "  Pruefstandsfaelle werden hier nicht gefahren, sondern aus\n";
    print "  Intern/pruefstand-buch.tsv gelesen - nach einer Aenderung am\n";
    print "  Programm vorher tools/pruefstand-lauf.ps1 fahren.\n\n";
    if (@unvollstaendig) {
        print "  NICHT VOLLSTAENDIG GELAUFEN:\n";
        print "      $_\n" for @unvollstaendig;
        print "\n";
    }
    exit((@neu_rot or @unvollstaendig) ? 1 : 0);
}

# --- Deckung der kritischen Befunde ---------------------------------------
my $reg = `perl "$wurzel/tools/pruefe-regressionstest.pl" 2>&1`;
my ($k_ges, $k_alle) = $reg =~ /mit Testfall im Pruefstand\s+(\d+) von (\d+)/;
my ($k_ohne) = $reg =~ /OHNE jede Pruefung\s+(\d+)/;
my ($k_liste) = $reg =~ /OHNE jede Pruefung\s+\d+[^\n]*\n((?:\s{6}\S[^\n]*\n)+)/;
$k_liste = join(' ', grep { length } split /\s+/, $k_liste // '');

# --- Urteil --------------------------------------------------------------
my $gruen = ($unit_lief and !@unvollstaendig and !$unit_fehl and !$schranke_fehl and !$st_rot and !$st_fehlt and !$st_alt) ? 1 : 0;
my $urteil = $gruen ? 'BESTANDEN'
           : ($unit_fehl or $schranke_fehl or $st_rot) ? 'FEHLGESCHLAGEN'
           : 'NICHT VOLLSTAENDIG';

# --- Bericht -------------------------------------------------------------
my $b = '';
$b .= "# Pruefbericht Eudora 7.2\n\n";
$b .= "| | |\n|---|---|\n";
$b .= "| **Quellstand** | `$quellstand` (Paketnummer `$paket`) |\n";
$b .= "| **Commit** | `$commit`" . ($offen ? " \x{2014} **Arbeitsbaum nicht sauber** ($offen Dateien)" : " (Arbeitsbaum sauber)") . " |\n";
$b .= "| **Erstellt** | $jetzt |\n";
$b .= "| **Gesamturteil** | **$urteil** |\n\n";
if (@unvollstaendig) {
    $b .= "**Nicht vollstaendig gelaufen:**\n\n";
    $b .= "- $_\n" for @unvollstaendig;
    $b .= "\n";
}
# DAUER (Gregor am 25.10.2026: "miss auch, wie lange der test in etwa
# dauert, das tragen wir bei den pruefberichten ein"). Unit-Tests und
# Schranken misst dieser Lauf selbst, den Pruefstand liest er aus
# Intern/pruefstand-dauer.txt (letzter VOLLER Lauf von pruefstand-lauf.ps1).
{
    my %pd;
    for my $z (split /\r?\n/, lies("$wurzel/Intern/pruefstand-dauer.txt") // '') {
        $pd{$1} = $2 if $z =~ /^(\w+)\t(.*)$/;
    }
    my $mmss = sub { my $s = shift; return sprintf('%d min %02d s', int($s / 60), $s % 60) };
    $b .= "**Dauer** \x{2014} wer die Tests selbst faehrt, braucht etwa:\n\n";
    $b .= "| Teil | Dauer | gemessen |\n|---|---|---|\n";
    $b .= sprintf("| Unit-Tests bauen und fahren | %s | dieser Lauf |\n", $mmss->($dauer_unit));
    $b .= sprintf("| Schranken mit Rueckfallprobe | %s | dieser Lauf |\n", $mmss->($dauer_schranke));
    if (defined $pd{sekunden}) {
        $b .= sprintf("| Pruefstand, %d Faelle, %d Eudora-Starts | %s | voller Lauf, Ende %s |\n",
                      $pd{faelle} // 0, $pd{starts} // 0, $mmss->($pd{sekunden}), $pd{ende} // '?');
        $b .= sprintf("| **zusammen** | **%s** | |\n", $mmss->($dauer_unit + $dauer_schranke + $pd{sekunden}));
    } else {
        $b .= "| Pruefstand | **nicht gemessen** \x{2014} `Intern/pruefstand-dauer.txt` fehlt | |\n";
    }
    $b .= "\n";
}
if (length $bin_kennung) {
    $b .= "Massstab fuer die Pruefstandsfaelle ist der Bau in `Eudora71\\Bin\\Release`: `$bin_kennung`. "
        . "Ein Fall auf einem anderen Bau heisst *ANDERER BAU*.\n\n";
}

$b .= "| Art | Tests | gruen | rot | sonst |\n|---|---|---|---|---|\n";
$b .= sprintf("| Unit-Tests (`EudoraTests.exe`) | %d | %d | %d | %s |\n", scalar @unit, @unit - $unit_fehl, $unit_fehl, $unit_lief ? '' : '**nicht gelaufen**');
$b .= sprintf("| Schranken mit Rueckfallprobe | %d | %d | %d | |\n", scalar @schranke, @schranke - $schranke_fehl, $schranke_fehl);
$b .= sprintf("| Pruefstand (Oberflaeche) | %d | %d | %d | %d an anderem Bau, %d nie gelaufen |\n\n", scalar @soll, $st_gruen, $st_rot, $st_alt, $st_fehlt);

$b .= "Erzeugt von `tools/pruefbericht.pl`. Jeder Test steht unten einzeln, mit\n";
$b .= "Zeitpunkt und Bau. Maschinenlesbar steht dasselbe in\n";
$b .= "[`pruefbericht-tests.tsv`](pruefbericht-tests.tsv) \x{2014} das ist der Stand *vorher*\n";
$b .= "fuer den Vergleich.\n\n";

$b .= "## Nach einer eigenen Aenderung: vorher und nachher vergleichen\n\n";
$b .= "```\nperl tools/pruefbericht.pl --vergleich\n```\n\n";
$b .= "baut und faehrt die Unit-Tests und die Schranken, liest die Pruefstandsfaelle\n";
$b .= "aus `Intern/pruefstand-buch.tsv` und vergleicht alles mit diesem eingecheckten\n";
$b .= "Stand: **neu rot**, neu gruen, neu hinzugekommen, weggefallen. Rueckgabe 1,\n";
$b .= "sobald etwas neu rot ist. Geschrieben wird dabei nichts.\n\n";
$b .= "Die Pruefstandsfaelle oeffnen Eudora-Fenster und laufen deshalb nur auf\n";
$b .= "Anforderung, je Fall an einem eigenen Verzeichnis unter `C:\\Temp`:\n\n";
$b .= "```\npowershell -ExecutionPolicy Bypass -File tools\\pruefstand-lauf.ps1 -Freigabe \"<wer, wann>\"\n```\n\n";
$b .= "Danach `perl tools/pruefbericht.pl` schreibt Bericht und Testbuch neu.\n\n";

$b .= "## 1. Unit-Tests\n\n";
if ($unit_lief) {
    $b .= "Gelaufen am **$jetzt** gegen den Quelltext von Commit `$stand`.\n\n";
    $b .= "<details><summary>Alle " . scalar(@unit) . " Unit-Tests einzeln</summary>\n\n";
    $b .= "| Bereich | Test | Ergebnis |\n|---|---|---|\n";
    $b .= "| " . zelle($_->[0]) . " | " . zelle($_->[1]) . " | " . ($_->[2] eq 'ok' ? 'ok' : '**FEHL**') . " |\n" for @unit;
    $b .= "\n</details>\n\n";
    if ($unit_fehl) { $b .= "**Rot:**\n\n"; $b .= "* " . zelle("$_->[0] / $_->[1]") . "\n" for grep { $_->[2] ne 'ok' } @unit; $b .= "\n" }
} else {
    $b .= "**Nicht gelaufen** \x{2014} `EudoraTests.exe` fehlt oder lieferte keine Ergebniszeile.\n\n";
}

$b .= "## 2. Schranken mit Rueckfallprobe\n\n";
$b .= "Eine Schranke im `pre-commit` zaehlt nur als Regressionstest, wenn sie ihren\n";
$b .= "Rueckfall abweist: die Behebung wird voruebergehend zurueckgenommen, die\n";
$b .= "Schranke muss rot werden, danach wird die Datei byte-genau wiederhergestellt\n";
$b .= "(`tools/schranken-gegenprobe.pl`, Liste in `tools/regression-schranken.txt`).\n";
$b .= "Gelaufen am **$jetzt** gegen Commit `$stand`.\n\n";
$b .= "| Befund | Schranke | Ergebnis | gemessen |\n|---|---|---|---|\n";
$b .= "| " . zelle($_->[0]) . " | `" . zelle($_->[1]) . "` | " . ($_->[2] eq 'ok' ? 'ok' : '**FEHL**') . " | " . zelle($_->[3]) . " |\n" for @schranke;
$b .= "\n";

$b .= "## 3. Regressionstests ueber die Oberflaeche (Pruefstand)\n\n";
$b .= "Je Fall der **letzte** Lauf. *Bau* ist die Kennung aus der `Eudora.exe` des\n";
$b .= "Pruefstands (Fassung, Paket, Commit; ein `*` heisst: mit uncommitteten\n";
$b .= "Aenderungen gebaut). Ein Fall, der an einer anderen Fassung als `$quellstand`\n";
$b .= "lief, zaehlt fuer diesen Stand nicht als gruen.\n\n";
$b .= "| Fall | Ergebnis | gelaufen am | Pruefstand | Bau | erwartet |\n|---|---|---|---|---|---|\n";
for my $z (@stand_zeilen) {
    my $e = $z->[1] eq 'ok' ? 'ok' : "**$z->[1]**";
    $b .= "| $z->[0] | $e | " . zelle($z->[2]) . " | `" . zelle($z->[3]) . "` | " . zelle($z->[4]) . " | `" . zelle($z->[5]) . "` |\n";
}
$b .= "\n";

$b .= "## 4. Deckung der kritischen Befunde\n\n";
$b .= "Von **" . ($k_alle // '?') . "** kritischen Befunden haben **" . ($k_ges // '?') . "** einen Test, **"
    . ($k_ohne // '?') . "** keinen (gezaehlt von `tools/pruefe-regressionstest.pl`). Ohne Test: "
    . ($k_liste || '-') . ".\n\n";
$b .= "Solange diese Zahl nicht null ist, sagt ein gruener Bericht nicht, dass\n";
$b .= "nichts kaputt ist \x{2014} er sagt, dass nichts von dem kaputt ist, was geprueft\n";
$b .= "wird.\n\n";

$b .= "## 5. Was dieser Bericht nicht abdeckt\n\n";
$b .= "* Die manuellen Faelle in [TESTPLAN.md](../Intern/TESTPLAN.md), Teil M.\n";
$b .= "* Gregors eigene Ergebnisse am Paket: [TESTPLAN.md, Buchfuehrung](../Intern/TESTPLAN.md)\n";
$b .= "  (je Paket und Pruefschritt, mit Paketnummer).\n";
$b .= "* Alles, was keinen Test hat (Abschnitt 4).\n";
$b .= "* Ein Release gilt erst nach **Gregors eigenem Lauf** und seiner Zustimmung\n";
$b .= "  (CLAUDE.md, Abschnitt 4) \x{2014} dieser Bericht ersetzt das nicht.\n";

my $rc = $gruen ? 0 : 1;
if ($zeigen) { binmode STDOUT, ':encoding(UTF-8)'; print $b; exit $rc }

for my $paar (["$wurzel/Releases/PRUEFBERICHT.md", $b],
              ["$wurzel/Releases/pruefbericht-tests.tsv",
               "# Erzeugt von tools/pruefbericht.pl am $jetzt fuer $quellstand, Commit $stand - nicht von Hand aendern.\n"
             . "# art\tkennung\tergebnis\tzeit\tbau\n" . join('', map { "$_\n" } @buchzeilen)]) {
    open my $o, '>:encoding(UTF-8)', $paar->[0] or do { print "  $paar->[0] nicht schreibbar: $!\n"; exit 2 };
    print $o $paar->[1];
    close $o;
}
printf "  Releases/PRUEFBERICHT.md und pruefbericht-tests.tsv geschrieben - %s\n", $urteil;
printf "  Unit %d (%d rot), Schranken %d (%d rot), Pruefstand %d (%d rot, %d anderer Bau, %d nie gelaufen)\n",
    scalar @unit, $unit_fehl, scalar @schranke, $schranke_fehl, scalar @soll, $st_rot, $st_alt, $st_fehlt;
exit $rc;
