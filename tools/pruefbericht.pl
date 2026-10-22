#!/usr/bin/perl
use strict;
use warnings;

# pruefbericht.pl - erzeugt Releases/PRUEFBERICHT.md
#
#   perl tools/pruefbericht.pl              Bericht schreiben
#   perl tools/pruefbericht.pl --zeigen     nur ausgeben, nichts schreiben
#
# Rueckgabe: 0 = geschrieben, 1 = es fehlt eine Messung, 2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 22.10.2026:
#
#     "am ende schreiben wir ein reinen report mit versionsnummer, datum,
#      testergebnissen usw. = pruefbericht. und haengen ihn mit rein ins repo."
#
# ---------------------------------------------------------------------------
# WAS DIESER BERICHT NICHT TUT
# ---------------------------------------------------------------------------
#
# Er fuehrt die Tests NICHT selbst aus. Er LIEST, was die beiden Laeufe
# hinterlassen haben:
#
#   Unit-Tests          tools/pruefe-tests-gruen.pl --ohne-bau (wird gerufen)
#   Oberflaechentests   Intern/pruefstand-ergebnis.txt, abgelegt von
#                       tools/pruefstand-lauf.ps1
#
# Der Oberflaechenlauf oeffnet Fenster und braucht Gregors Freigabe mit dem
# heutigen Datum; ein Berichtsgenerator darf so etwas nicht ausloesen
# (CLAUDE.md, Abschnitt 4). Fehlt das Ergebnis oder ist es AELTER als die
# gebaute Eudora.exe, schreibt der Bericht das hin und gibt 1 zurueck -
# er behauptet nichts Gruenes, das niemand gemessen hat
# (Arbeitsweise/ausbleiben-ist-kein-befund.md).

my $zeigen = 0;
for my $a (@ARGV) {
    if    ($a eq '--zeigen') { $zeigen = 1 }
    else { print "  unbekannt: $a\n"; exit 2 }
}

my $wurzel = -f 'VERSION' ? '.' : '..';
unless (-f "$wurzel/VERSION") {
    print "  pruefbericht: aus der Wurzel aufrufen.\n";
    exit 2;
}

sub lies { my ($d) = @_; open my $h, '<:raw', $d or return undef; local $/; my $t = <$h>; close $h; $t }

# --- Fassung -------------------------------------------------------------
my $paket = lies("$wurzel/VERSION") // '';
$paket =~ s/\s+//g;

my $quellstand = '';
my $vh = lies("$wurzel/Eudora71/Version.h") // '';
my @teile;
for my $n (1 .. 4) {
    push @teile, $1 if $vh =~ /^#define\s+EUDORA_VERSION$n\s+(\d+)/m;
}
$quellstand = join('.', @teile) if @teile == 4;
$quellstand ||= '(nicht gefunden)';

my $commit = `git -C "$wurzel" rev-parse --short HEAD 2>&1`;
chomp $commit;
my $schmutzig = `git -C "$wurzel" status --porcelain 2>&1`;
my $anzahl_offen = () = $schmutzig =~ /\n/g;

my @t = localtime;
my $heute = sprintf('%04d-%02d-%02d', $t[5] + 1900, $t[4] + 1, $t[3]);
my $jetzt = sprintf('%04d-%02d-%02d %02d:%02d', $t[5] + 1900, $t[4] + 1, $t[3], $t[2], $t[1]);

# --- Unit-Tests ----------------------------------------------------------
my $unit = `perl "$wurzel/tools/pruefe-tests-gruen.pl" --ohne-bau 2>&1`;
my ($u_ges, $u_gut, $u_schlecht);
if ($unit =~ /Tests\s+(\d+)/)          { $u_ges      = $1 }
if ($unit =~ /bestanden\s+(\d+)/)      { $u_gut      = $1 }
if ($unit =~ /fehlgeschlagen\s+(\d+)/) { $u_schlecht = $1 }
my @u_fehl = $unit =~ /^\s*\[FEHL\]\s*(.+)$/mg;

# --- Oberflaechentests ---------------------------------------------------
my $pfad = "$wurzel/Intern/pruefstand-ergebnis.txt";
my $ober = lies($pfad);
# PowerShell schreibt die Datei mit CRLF; dieser Bericht ist eine .md und
# muss reine LF haben (CLAUDE.md, Abschnitt 5). Sonst wandern 6 CR in die
# Ausgabe - genau so gemessen am 22.10.2026.
$ober =~ s/\r//g if defined $ober;
my (%o, @o_faelle);
if (defined $ober) {
    for my $z (split /\n/, $ober) {
        next if $z =~ /^\s*#/;
        if ($z =~ /^fall=(.*)$/)        { push @o_faelle, $1; next }
        if ($z =~ /^([a-z]+)=(.*)$/)    { $o{$1} = $2 }
    }
}

# Ist das Ergebnis aelter als die gebaute EXE? Dann ist es kalt.
my $kalt = 0;
my ($exe) = grep { -f $_ } (
    "$wurzel/Eudora71/Bin/Release/Eudora.exe",
    "$wurzel/Eudora71/Bin/Debug/Eudora.exe",
);
if (defined $ober and $exe) {
    $kalt = 1 if (stat($pfad))[9] < (stat($exe))[9];
}

# --- Welche Fassung lief in jedem Pruefstand? ----------------------------
#
# AM 22.10.2026 GELERNT (LEKTOR, L-50.1). Dieser Bericht trug in der Kopfzeile
# "Quellstand 7.2.0.121" und "BESTANDEN", und zwei seiner sechs gruenen Faelle
# waren an einem Paket 7.2.0.106 vom 17.10. gemessen - der Pruefstand
# C:\Temp\E118 stand noch auf der alten Fassung. Ein gruener Bericht ueber
# eine Fassung, die nicht gelaufen ist, ist genau die Art Luege, gegen die es
# ihn gibt.
#
# Geprueft wird deshalb HIER, wo die Behauptung gemacht wird, und nicht nur
# im Laeufer: fuer jedes Verzeichnis aus pruefstand-faelle.txt wird die
# Dateiversion der Eudora.exe gelesen und gegen den Quellstand gehalten.
# Weicht eine ab, nennt der Bericht sie und das Gesamturteil faellt.
my (@stand_alt, @stand_ok);
my $faelle_soll = 0;
{
    my $faelle = lies("$wurzel/tools/pruefstand-faelle.txt") // '';
    my %verz;
    for my $z (split /\n/, $faelle) {
        next if $z =~ /^\s*(#|$)/;
        # -1, sonst wirft split die leeren Felder am Zeilenende weg und die
        # achtfeldrige Zeile kommt als siebenfeldrige an.
        my @f = split /\|/, $z, -1;
        next unless @f >= 8;
        my $v = $f[1]; $v =~ s/^\s+|\s+$//g;
        $verz{$v} = 1 if length $v;
        $faelle_soll++;
    }
    for my $v (sort keys %verz) {
        # NICHT "$v\\Eudora.exe" schreiben: in einer Perl-Zeichenkette ist
        # \E eine Steuerfolge (Ende von \Q), aus C:\Temp\E118 wuerde
        # C:\Temp udora.exe. Am 22.10.2026 genau daran gescheitert - die
        # Pruefung lief ins Leere und meldete nichts, also schien alles gut.
        (my $slash = $v) =~ s{\\}{/}g;
        my $exe = $slash . '/Eudora.exe';
        next unless -f $exe;
        my $ps = qq{powershell -NoProfile -Command "(Get-Item '$v\\Eudora.exe').VersionInfo.FileVersion"};
        my $fv = `$ps 2>&1`;
        $fv =~ s/\s+//g;
        next unless $fv =~ /^\d+(\.\d+){3}$/;
        if ($fv eq $quellstand) { push @stand_ok,  "$v ($fv)" }
        else                    { push @stand_alt, "$v traegt $fv, Quellstand ist $quellstand" }
    }
}

# --- Einstufung ----------------------------------------------------------
my $reg = `perl "$wurzel/tools/pruefe-regressionstest.pl" 2>&1`;
my %zahl;
for my $k (qw(kritisch wichtig unkritisch werkzeug)) {
    $zahl{$k} = ($reg =~ /^\s*\Q$k\E\s+(\d+)/m) ? $1 : '?';
}
my ($k_ges)  = $reg =~ /mit Testfall im Pruefstand\s+(\d+) von (\d+)/;
my $k_alle   = $2 // '?';
my ($k_man)  = $reg =~ /zusaetzlich manuell im Plan\s+(\d+)/;
my ($k_ohne) = $reg =~ /OHNE jede Pruefung\s+(\d+)/;

# --- Bericht -------------------------------------------------------------
my $gruen_unit  = (defined $u_schlecht and $u_schlecht == 0) ? 1 : 0;
# TEILLAUF IST KEIN LAUF (22.10.2026, PRUEFER Fund 4a).
# pruefstand-lauf.ps1 -Nur E-131 schreibt dieselbe Ergebnisdatei wie der
# volle Lauf und UEBERSCHREIBT ihn damit. Ohne diese Pruefung sagte der
# Bericht BESTANDEN, obwohl fuenf von sechs Faellen nie gemessen wurden -
# gemessen von PRUEFER mit einer gestellten Datei "faelle=1".
my $unvollstaendig = (defined $ober and $faelle_soll
                      and ($o{faelle} // 0) < $faelle_soll) ? 1 : 0;

my $gruen_ober  = (defined $ober and ($o{fehlgeschlagen} // 1) == 0
                   and !$kalt and !@stand_alt and !$unvollstaendig) ? 1 : 0;
my $urteil = ($gruen_unit && $gruen_ober) ? 'BESTANDEN' : 'NICHT VOLLSTAENDIG';

my $b = '';
$b .= "# Pruefbericht Eudora 7.2\n\n";
$b .= "| | |\n|---|---|\n";
$b .= "| **Paketfassung** | `$paket` |\n";
$b .= "| **Quellstand** | `$quellstand` |\n";
$b .= "| **Commit** | `$commit`" . ($anzahl_offen ? " (**Arbeitsbaum nicht sauber**: $anzahl_offen Dateien geaendert)" : " (Arbeitsbaum sauber)") . " |\n";
$b .= "| **Erstellt** | $jetzt |\n";
$b .= "| **Gesamturteil** | **$urteil** |\n\n";

$b .= "Erzeugt von `tools/pruefbericht.pl`. Er fuehrt die Tests nicht selbst aus,\n";
$b .= "sondern liest, was die Laeufe hinterlassen haben - was nicht gemessen wurde,\n";
$b .= "steht hier als nicht gemessen und nicht als gruen.\n\n";

$b .= "## 1. Unit-Tests (`EudoraTests.exe`)\n\n";
if (defined $u_ges) {
    $b .= "| Tests | bestanden | fehlgeschlagen |\n|---|---|---|\n";
    $b .= "| $u_ges | $u_gut | $u_schlecht |\n\n";
    if (@u_fehl) { $b .= "Fehlgeschlagen:\n\n"; $b .= "* $_\n" for @u_fehl; $b .= "\n" }
} else {
    $b .= "**Nicht gemessen** - `pruefe-tests-gruen.pl --ohne-bau` lieferte keine Ergebniszeile.\n\n";
}

$b .= "## 2. Regressionstests ueber die Oberflaeche (`pruefstand-lauf.ps1`)\n\n";
if (!defined $ober) {
    $b .= "**Nicht gemessen.** `Intern/pruefstand-ergebnis.txt` fehlt. Der Lauf oeffnet\n";
    $b .= "Fenster und braucht Gregors Freigabe mit dem heutigen Datum; dieser Bericht\n";
    $b .= "loest ihn nicht selbst aus.\n\n";
} else {
    $b .= "**Das Ergebnis ist AELTER als die gebaute `Eudora.exe`** - es gilt fuer einen\n"
        . "frueheren Stand und zaehlt fuer dieses Paket nicht.\n\n" if $kalt;
    $b .= "Gefahren am $o{zeit}, Freigabe: *\"$o{freigabe}\"*\n\n" if $o{zeit};
    if ($unvollstaendig) {
        $b .= sprintf("**TEILLAUF - nur %d von %d Faellen sind gemessen.** Die Fallliste\n"
                    . "`tools/pruefstand-faelle.txt` fuehrt %d Faelle; das abgelegte Ergebnis\n"
                    . "nennt %d. Wahrscheinlich lief `pruefstand-lauf.ps1` mit `-Nur` und hat\n"
                    . "das vollstaendige Ergebnis ueberschrieben. Dieses Gruen gilt nicht.\n\n",
                      ($o{faelle} // 0), $faelle_soll, $faelle_soll, ($o{faelle} // 0));
    }
    if (@stand_alt) {
        $b .= "**ACHTUNG - nicht alle Pruefstaende tragen den Quellstand.** Die Faelle\n";
        $b .= "in diesen Verzeichnissen wurden an einer ANDEREN Fassung gemessen, ihr\n";
        $b .= "Gruen gilt fuer dieses Paket also nicht:\n\n";
        $b .= "* $_\n" for @stand_alt;
        $b .= "\nGemessen an der Dateiversion der jeweiligen `Eudora.exe`.\n\n";
    } elsif (@stand_ok) {
        $b .= "Alle Pruefstaende tragen den Quellstand `$quellstand` (an der\n";
        $b .= "Dateiversion ihrer `Eudora.exe` gemessen).\n\n";
    }
    $b .= "| Faelle | bestanden | fehlgeschlagen |\n|---|---|---|\n";
    $b .= "| " . ($o{faelle} // '?') . " | " . ($o{bestanden} // '?') . " | " . ($o{fehlgeschlagen} // '?') . " |\n\n";
    if (@o_faelle) {
        $b .= "```\n";
        $b .= "$_\n" for @o_faelle;
        $b .= "```\n\n";
    }
}

$b .= "## 3. Deckung der kritischen Befunde\n\n";
$b .= "Was *kritisch* heisst, steht in [BEFUNDE.md](../Intern/BEFUNDE.md) unter\n";
$b .= "*Die Stufe*: Post oder Einstellungen gehen verloren oder werden still\n";
$b .= "beschaedigt, eine fremde Installation nimmt Schaden, das Programm stuerzt ab,\n";
$b .= "startet nicht oder haengt, eine Nachricht geht falsch hinaus oder kommt\n";
$b .= "falsch an, Sicherheit.\n\n";
$b .= "| Stufe | Zahl |\n|---|---|\n";
$b .= "| kritisch | $zahl{kritisch} |\n| wichtig | $zahl{wichtig} |\n";
$b .= "| unkritisch | $zahl{unkritisch} |\n| werkzeug | $zahl{werkzeug} |\n\n";
$b .= "Von den **$k_alle kritischen** Befunden haben\n\n";
$b .= "* **" . ($k_ges  // '?') . "** einen automatischen Testfall,\n";
$b .= "* **" . ($k_man  // '?') . "** einen manuellen Fall im [Testplan](../Intern/TESTPLAN.md),\n";
$b .= "* **" . ($k_ohne // '?') . "** bisher **keine Pruefung**.\n\n";
$b .= "Die letzte Zahl ist der Rueckstand. Solange sie nicht null ist, sagt ein\n";
$b .= "gruener Bericht nicht, dass nichts kaputt ist - er sagt, dass nichts von dem\n";
$b .= "kaputt ist, was geprueft wird.\n\n";

$b .= "## 4. Was dieser Bericht nicht abdeckt\n\n";
$b .= "* Die manuellen Faelle in [TESTPLAN.md](../Intern/TESTPLAN.md), Teil M -\n";
$b .= "  sie muessen vor einem Release von Hand gefahren und dort abgehakt werden.\n";
$b .= "* Alles, was keinen Testfall hat (siehe Abschnitt 3).\n";
$b .= "* Ein Release gilt erst nach **Gregors eigenem Lauf** und seiner Zustimmung\n";
$b .= "  (CLAUDE.md, Abschnitt 4) - dieser Bericht ersetzt das nicht.\n";

if ($zeigen) { print $b; exit(($gruen_unit && $gruen_ober) ? 0 : 1) }

my $ziel = "$wurzel/Releases/PRUEFBERICHT.md";
open my $o, '>:raw', $ziel or do { print "  $ziel nicht schreibbar: $!\n"; exit 2 };
print $o $b;
close $o;
print "  Releases/PRUEFBERICHT.md geschrieben - Urteil: $urteil\n";
exit(($gruen_unit && $gruen_ober) ? 0 : 1);
