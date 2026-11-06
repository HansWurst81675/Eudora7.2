#!/usr/bin/perl
# pruefe-feste-pfade.pl - laeuft der Pruefstand noch aus einem fremden Klon?
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE SCHRANKE GIBT
# ---------------------------------------------------------------------------
#
# Befund E-151: die Pruefstandsfaelle liefen nur auf der Entwicklermaschine.
# Gregor am 05.11.2026: "ich moechte separat von hier (oder auch jemand, der
# die repo forkt oder clonet) die tests nach eigenen aenderungen durchfuehren."
# Zwei Dinge banden den Pruefstand an diesen einen Rechner:
#   1. der Repo-Pfad stand fest im Code ('C:\Users\Gregor\Documents\github\
#      Eudora7.2' in e118-serie.ps1, messen-e118.ps1 ...) - in jedem Klon
#      zeigte er ins Leere oder, schlimmer, auf einen anderen Stand;
#   2. jedes Messskript pruefte seinen Pfad mit '^C:\\Temp\\...' - eine andere
#      Wurzel (-Wurzel, EUDORA72_PRUEFSTAND) wies es ab.
# Beides ist seit E-151 behoben. Ohne Schranke kommt es mit dem naechsten
# Messskript zurueck, das von einem alten abgeschrieben wird
# (Arbeitsweise/fehlerklassen-abstellen.md).
#
# ---------------------------------------------------------------------------
# WAS SIE PRUEFT
# ---------------------------------------------------------------------------
#
# Umfang aus der Quelle, nicht von Hand (Arbeitsweise/pruefumfang-nicht-von-
# hand.md): die Kernwerkzeuge des Pruefstands plus jedes Messskript, das
# tools/pruefstand-faelle.txt nennt, plus jedes tools/*.ps1, das eines davon
# per Namen aufruft (eine Ebene). Gelesen wird nur Code - Kommentarzeilen und
# Kommentare hinter dem Code fallen vorher weg (Arbeitsweise/schranke-liest-
# nur-code.md). Abgewiesen wird
#   - ein Benutzerpfad 'C:\Users\...' im Code,
#   - eine Pfadschranke der alten Form -notmatch '^C:\\Temp\\...' (die neue
#     liest die Wurzel aus $env:EUDORA72_PRUEFSTAND).
#
#   perl tools/pruefe-feste-pfade.pl             prueft
#   perl tools/pruefe-feste-pfade.pl --selbsttest  beide Richtungen
#
# Rueckgabe: 0 = sauber, 1 = Mangel, 2 = nichts geprueft / Aufruffehler.
# Kodierung: reines ASCII, nur LF.

use strict;
use warnings;

my $B = chr(92);

sub pruefe_text {
    my ($name, $text) = @_;
    my @m;
    my $n = 0;
    for my $z (split /\n/, $text) {
        $n++;
        next if $z =~ /^\s*#/;
        (my $c = $z) =~ s/\s#[^'"]*$//;
        if (index($c, "C:${B}Users${B}") >= 0) {
            push @m, "$name:$n: Benutzerpfad im Code: " . substr($c, 0, 120);
        }
        # nur die Verzeichnisschranke '^C:\\Temp\\<...>' - nicht die Pruefung
        # der Wurzel selbst ('^C:\\Temp(\\...)*$' in pruefstand-lauf/-einrichten)
        if ($c =~ /-notmatch\s+'\^C:\Q$B$B\ETemp\Q$B$B\E/) {
            push @m, "$name:$n: alte Pfadschranke '^C:${B}${B}Temp' - Wurzel aus \$env:EUDORA72_PRUEFSTAND lesen: " . substr($c, 0, 120);
        }
    }
    return @m;
}

if (@ARGV && $ARGV[0] eq '--selbsttest') {
    my $fehler = 0;
    my @a = pruefe_text('rot1', "\$repo = 'C:${B}Users${B}Gregor${B}x'\n");
    my @b = pruefe_text('rot2', "if (\$voll -notmatch '^C:$B${B}Temp$B$B" . "[^$B$B]+') { exit 2 }\n");
    my @c = pruefe_text('gruen1', "# frueher 'C:${B}Users${B}Gregor'\n\$repo = Split-Path -Parent \$PSScriptRoot\n");
    my @d = pruefe_text('gruen2', "if (\$voll -notmatch ('^' + [regex]::Escape(\$w) + '$B${B}x')) { exit 2 }\n");
    $fehler++ unless @a == 1; $fehler++ unless @b == 1; $fehler++ if @c; $fehler++ if @d;
    print "pruefe-feste-pfade --selbsttest: ", ($fehler ? "ROT ($fehler)" : "4 von 4 gruen"), "\n";
    exit($fehler ? 1 : 0);
}

my $tools = 'tools';
-d $tools or do { print "pruefe-feste-pfade: kein Ordner tools/ - aus dem Wurzelverzeichnis aufrufen\n"; exit 2 };

my %umfang = map { ("$tools/$_" => 1) } qw(
    pruefstand-lauf.ps1 pruefstand-einrichten.ps1 pruefstand-starten.ps1
    pruefserver-aufraeumen.ps1 testlauf.ps1 pruefstand-sperre.ps1
    pruefstaende-auffrischen.ps1 e118-serie.ps1 messen-e118.ps1);
open my $fh, '<:raw', "$tools/pruefstand-faelle.txt" or do { print "pruefe-feste-pfade: Fallliste fehlt\n"; exit 2 };
while (my $z = <$fh>) {
    next if $z =~ /^\s*#/;
    while ($z =~ /messen=tools[\\\/]([\w.-]+\.ps1)/g) { $umfang{"$tools/$1"} = 1 }
}
close $fh;
# eine Ebene: was die Dateien im Umfang per Namen aufrufen
my @erst = keys %umfang;
for my $f (@erst) {
    open my $h, '<:raw', $f or next; local $/; my $t = <$h>; close $h;
    # Gegentests (*-test.ps1) faehrt der Pruefstand nicht; sie tragen erfundene
    # Pfade wie 'C:\Users\X\...' als Testwerte.
    while ($t =~ /([\w-]+\.ps1)/g) { my $k = "$tools/$1"; $umfang{$k} = 1 if -f $k && $k !~ /-test\.ps1$/ }
}

my @mangel;
my $gelesen = 0;
for my $f (sort keys %umfang) {
    next unless -f $f;
    open my $h, '<:raw', $f or next; local $/; my $t = <$h>; close $h;
    $gelesen++;
    push @mangel, pruefe_text($f, $t);
}
if ($gelesen == 0) { print "pruefe-feste-pfade: ROT - nichts geprueft (leere Menge ist kein Freispruch)\n"; exit 2 }

# Jedes Verzeichnis der Fallliste braucht eine Vorlage unter Testdaten/pruefstand/,
# sonst laeuft sein Fall in einem fremden Klon nicht und wird still
# uebersprungen. Am 06.11.2026 fehlten E169, E169B und E239 (kamen mit main,
# LEKTOR-156 L-156.1, PRUEFER-104 K4): 49 Verzeichnisse, 46 Vorlagen.
my $vorlagen_geprueft = 0;
if (open my $fh, '<:raw', "$tools/pruefstand-faelle.txt") {
    my %namen;
    while (my $z = <$fh>) {
        next if $z =~ /^\s*(#|$)/;
        my @f = split /\|/, $z;
        next unless @f >= 8;
        (my $d = $f[1]) =~ s/^\s+|\s+$//g;
        my @teile = split /\Q$B\E/, $d;
        $namen{$teile[-1]} = 1 if @teile;
    }
    close $fh;
    for my $n (sort keys %namen) {
        $vorlagen_geprueft++;
        push @mangel, "Testdaten/pruefstand/$n/Mailverzeichnis/Eudora.ini fehlt - Vorlage erfassen: tools/pruefstand-vorlage-erfassen.ps1 -Nur $n"
            unless -f "Testdaten/pruefstand/$n/Mailverzeichnis/Eudora.ini";
    }
} else {
    push @mangel, "$tools/pruefstand-faelle.txt nicht lesbar - Vorlagen nicht geprueft";
}
if (@mangel) {
    print "pruefe-feste-pfade: $gelesen Pruefstand-Skripte, MANGEL:\n";
    print "  $_\n" for @mangel;
    print "  Der Pruefstand soll aus jedem Klon laufen (E-151): Repo-Pfad aus \$PSScriptRoot,\n";
    print "  Wurzel aus \$env:EUDORA72_PRUEFSTAND (Vorgabe C:${B}Temp${B}Eudora72-Pruefstand, Entscheidung 39).\n";
    exit 1;
}
print "pruefe-feste-pfade: $gelesen Pruefstand-Skripte, kein fester Benutzerpfad, keine alte Pfadschranke; $vorlagen_geprueft Fallverzeichnisse, jedes mit Vorlage.\n";
exit 0;
