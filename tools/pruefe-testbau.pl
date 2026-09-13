#!/usr/bin/perl
use strict;
use warnings;

# pruefe-testbau.pl - laesst sich die Testsammlung ueberhaupt noch bauen?
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Vom 10.09.2026 bis zum 13.09.2026 liess sich EudoraTests.exe nicht linken,
# und drei Tage lang hat es niemand gemerkt:
#
#   OTShim.obj : error LNK2019: Verweis auf nicht aufgeloestes externes
#   Symbol "void __cdecl PutDebugLog(unsigned long,char const *,int)"
#
# Die Spurmarke zu E-76 (Commit 3acb82f vom 10.09.2026) hatte PutDebugLog in
# OTShim.cpp eingesetzt. Die Funktion liegt in QCUtils, und QCUtils gehoert
# nicht zum Testprojekt - Tests.vcxproj uebersetzt ..\OTShim\OTShim.cpp
# direkt. Folgen: die Schranken vom 13.09.2026 sind nie gegen die Tests
# gefahren, und zwei rote Tests blieben drei Tage unsichtbar.
#
# Die Lehre Arbeitsweise/tests-vor-jedem-commit-laufen-lassen.md stand seit
# dem 28.08.2026 da und hat nichts genuetzt. Sie konnte auch nichts nuetzen:
# ein kaputter Pruefstand und ein gruener Pruefstand melden im Alltag
# dasselbe, naemlich nichts. Deshalb gibt es dieses Werkzeug.
#
# ---------------------------------------------------------------------------
# WAS ES PRUEFT - UND WAS AUSDRUECKLICH NICHT
# ---------------------------------------------------------------------------
#
# Geprueft wird EINE Frage: laesst sich die Testsammlung uebersetzen und
# linken? Das ist die Frage, die drei Tage lang niemand gestellt hat.
#
# NICHT geprueft wird, ob alle Tests gruen sind. Ein roter Test ist ein
# Ergebnis, kein Grund, einen Commit zu verweigern - genau das steht in der
# Lehre, und am 13.09.2026 waren zwei Tests rot, waehrend an E-85 gearbeitet
# wurde. Wer rote Tests abweist, bringt mich dazu, die Schranke zu umgehen,
# und dann faengt sie auch den Baufehler nicht mehr.
#
# Rueckgabe:
#   0  Testsammlung baut (oder MSBuild ist hier nicht vorhanden - dann wird
#      uebersprungen und gemeldet, Muster aus Befund X-8)
#   1  Testsammlung baut NICHT - der Pruefstand ist blind
#
# Aufruf:
#   perl tools/pruefe-testbau.pl               # bauen und urteilen
#   perl tools/pruefe-testbau.pl --selbsttest  # Gegenprobe in beide Richtungen
#
# Kosten: am 13.09.2026 gemessen, 17,7 Sekunden fuer Bau UND Lauf der
# gesamten Sammlung (120 Tests) aus dem kalten Stand. Der reine Bau liegt
# darunter. Das ist der Grund, warum es keinen Kostengrund gibt, diese
# Schranke nicht zu haengen - sie gehoert in den pre-push, wo sie einmal je
# Zweig laeuft statt einmal je Commit.
#

my $selbsttest = (grep { $_ eq '--selbsttest' } @ARGV) ? 1 : 0;

# --- Repo-Wurzel ------------------------------------------------------------
# --show-toplevel liefert in einem Arbeitsbaum dessen eigenen Pfad, und das
# ist hier genau richtig: die Quellen, die gebaut werden sollen, sind die
# dieses Arbeitsbaums.
my $wurzel = `git rev-parse --show-toplevel 2>/dev/null`;
$wurzel = "" unless defined $wurzel;
$wurzel =~ s/\s+\z//;
my $trenner = chr(92);
$wurzel =~ s/\Q$trenner\E/\//g;
unless (length $wurzel) {
    print "  pruefe-testbau: keine Repo-Wurzel gefunden - uebersprungen.\n";
    exit 0;
}

my $projekt = "$wurzel/Eudora71/Tests/Tests.vcxproj";
unless (-f $projekt) {
    print "  pruefe-testbau: $projekt gibt es in diesem Arbeitsbaum nicht -\n";
    print "  uebersprungen (Muster aus Befund X-8).\n";
    exit 0;
}

# --- MSBuild suchen ---------------------------------------------------------
# Der Pfad steht auch in Eudora71/Tests/RunTests.cmd. Er wird hier nicht von
# Hand wiederholt, sondern von dort gelesen - eine Fassung, ein Wert
# (Arbeitsweise/doku-parallel-nicht-hinterher.md).
sub msbuild_pfad {
    my $cmd = "$wurzel/Eudora71/Tests/RunTests.cmd";
    return "" unless -f $cmd;
    open(my $f, "<", $cmd) or return "";
    while (my $z = <$f>) {
        next unless $z =~ /^\s*set\s+MSBUILD\s*=\s*(.+?)\s*$/i;
        my $p = $1;
        close $f;
        return $p;
    }
    close $f;
    return "";
}

my $msbuild = msbuild_pfad();

# Der Pfad steht in RunTests.cmd mit Backslashes. Fuer -f wird er auf
# Schraegstriche gebracht; beide Formen funktionieren hier, aber die
# Schraegstrichform ist die, die auch unter einer MSYS-Shell sicher trifft.
my $msbuild_test = $msbuild;
$msbuild_test =~ s/\Q$trenner\E/\//g;

# --- Selbsttest -------------------------------------------------------------
# Gegenprobe umgedreht (Arbeitsweise/gegenprobe-umdrehen.md): nicht pruefen,
# ob der gewuenschte Zustand erscheint, sondern ob der UNGEWUENSCHTE Wert
# durchkommt. Geprueft wird deshalb die Urteilsfunktion, nicht der Bau -
# fuer den Bau selbst gibt es nur einen echten Lauf.
sub urteil {
    my ($ausgabe, $rueckgabe) = @_;
    # Ein Linkerfehler ist der Fall, um den es hier geht - er soll auch dann
    # erkannt werden, wenn MSBuild aus irgendeinem Grund 0 zurueckgibt.
    return (1, "Linkerfehler (LNK)")   if $ausgabe =~ /\berror\s+LNK\d+/i;
    return (1, "Uebersetzungsfehler")  if $ausgabe =~ /\berror\s+C\d+/i;
    return (1, "MSBuild meldet Fehler") if $rueckgabe != 0;
    return (0, "");
}

if ($selbsttest) {
    my @faelle = (
        # [ Ausgabe, Rueckgabe, erwartet_abweisung, Beschreibung ]
        [ "OTShim.obj : error LNK2019: Verweis auf nicht aufgeloestes externes Symbol \"void __cdecl PutDebugLog(unsigned long,char const *,int)\"", 1, 1,
          "der echte Fehler vom 10.09.2026" ],
        [ "OTShim.obj : error LNK2019: unresolved external symbol", 0, 1,
          "Linkerfehler, aber MSBuild gibt 0 zurueck" ],
        [ "OTShim.cpp(2019): error C2065: 'PutDebugLog': nichtdeklarierter Bezeichner", 1, 1,
          "Uebersetzungsfehler" ],
        [ "Der Buildvorgang wurde erfolgreich ausgefuehrt.\n  0 Warnung(en)\n  0 Fehler", 0, 0,
          "sauberer Bau" ],
        [ "Der Buildvorgang wurde erfolgreich ausgefuehrt.\nErgebnis: 120 Tests, 118 bestanden, 2 fehlgeschlagen", 0, 0,
          "sauberer Bau MIT roten Tests - darf NICHT abweisen" ],
        [ "warning LNK4099: PDB nicht gefunden", 0, 0,
          "Linker-WARNUNG - darf nicht abweisen" ],
        [ "", 1, 1,
          "MSBuild bricht ohne Ausgabe ab" ],
    );
    my $fehler = 0;
    print "\n  pruefe-testbau --selbsttest\n";
    print "  " . ("-" x 68) . "\n";
    for my $fa (@faelle) {
        my ($aus, $rg, $erwartet, $was) = @$fa;
        my ($ist, $grund) = urteil($aus, $rg);
        my $ok = ($ist == $erwartet);
        $fehler++ unless $ok;
        printf "  [%s] %-52s %s\n", ($ok ? "ok  " : "FEHL"), $was,
               ($ist ? "weist ab ($grund)" : "laesst durch");
    }
    print "  " . ("-" x 68) . "\n";
    if ($fehler) {
        print "  $fehler von " . scalar(@faelle) . " Faellen falsch beurteilt.\n\n";
        exit 1;
    }
    print "  Alle " . scalar(@faelle) . " Faelle richtig beurteilt, in beide Richtungen.\n\n";
    exit 0;
}

# --- Der echte Lauf ---------------------------------------------------------
unless (length($msbuild_test) && -f $msbuild_test) {
    print "  pruefe-testbau: MSBuild nicht gefunden";
    print " ($msbuild)" if length $msbuild;
    print " - uebersprungen.\n";
    print "  Auf einem Rechner ohne VS2022 kann diese Schranke nicht urteilen.\n";
    print "  Sie darf deshalb nicht abweisen (Muster aus Befund X-8).\n";
    exit 0;
}

# Die Schalter stehen mit MINUS, nicht mit Schraegstrich. RunTests.cmd darf
# "/p:" schreiben, weil es von cmd.exe laeuft - dieses Werkzeug laeuft aber aus
# dem git-Hook, und der wird von einer MSYS-Shell ausgefuehrt. Die schreibt
# jedes Argument, das mit "/" beginnt, in einen Windows-Pfad um: aus
# "/p:Configuration=Debug" wird "C:/Program Files/Git/p:Configuration=Debug",
# und MSBuild antwortet mit "Informationen zur Schaltersyntax erhalten Sie...".
# Beim Gegentest am 13.09.2026 hat die Schranke deshalb einen heilen Bau als
# kaputt gemeldet - ein Fehlalarm haette jeden Push abgewiesen. MSBuild nimmt
# "-p:" genauso; gemessen: "/p:" Rueckgabe 1, "-p:" Rueckgabe 0, gleicher Stand.
my $befehl = "\"$msbuild\" \"$projekt\" -p:Configuration=Debug -p:Platform=Win32 -v:minimal -nologo 2>&1";
my $ausgabe = `$befehl`;
$ausgabe = "" unless defined $ausgabe;
my $rueckgabe = $? >> 8;

my ($abweisen, $grund) = urteil($ausgabe, $rueckgabe);

unless ($abweisen) {
    print "  Testbau: EudoraTests.exe laesst sich bauen.\n";
    exit 0;
}

print "\n";
print "  ABBRUCH: die Testsammlung laesst sich nicht bauen ($grund).\n";
print "\n";
print "  Solange das so ist, ist der Pruefstand BLIND. Ein kaputter und ein\n";
print "  gruener Pruefstand melden im Alltag dasselbe, naemlich nichts - vom\n";
print "  10.09.2026 bis zum 13.09.2026 ist genau das drei Tage lang\n";
print "  unbemerkt geblieben.\n";
print "\n";
print "  Haeufigste Ursache: eine Funktion aus QCUtils oder einer anderen\n";
print "  Bibliothek, die NICHT zum Testprojekt gehoert, ist in eine Quelle\n";
print "  geraten, die Tests.vcxproj mituebersetzt (z.B. OTShim.cpp). Abhilfe:\n";
print "  eine Attrappe in Eudora71/Tests/OTShimProbe.cpp, so wie dort schon\n";
print "  PutDebugLog steht.\n";
print "\n";
print "  Die Fehlerzeilen aus MSBuild:\n";
my $gezeigt = 0;
for my $z (split /\n/, $ausgabe) {
    next unless $z =~ /\berror\s+(LNK|C)\d+/i;
    print "    $z\n";
    last if ++$gezeigt >= 10;
}
print "    (keine passende Fehlerzeile gefunden, Rueckgabe $rueckgabe)\n" unless $gezeigt;
print "\n";
exit 1;
