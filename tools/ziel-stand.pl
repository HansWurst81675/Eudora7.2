#!/usr/bin/perl
use strict;
use warnings;

# ziel-stand.pl - was fehlt noch zur Fassung 7.2.1.0? Erzeugt den Stand
# oben im Massstab von ZIEL.md, aus den Urteilen in Intern/BEFUNDE.md.
#
#   perl tools/ziel-stand.pl              pruefen, Rueckgabe 1 bei Abweichung
#   perl tools/ziel-stand.pl -schreiben   den Block neu setzen
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 22.10.2026, auf den Massstab fuer 7.2.1.0 blickend:
#
#     "was kann ich daraus schliessen? was fehlt noch zum 7.2.1.0 release?
#      kann hieraus nicht auf einen blick entnehmen."
#
# und kurz darauf, zur Frage wo das ueberhaupt steht:
#
#     "wissen wir, was jetzt noch alles den prios nach zu tun ist? und wo
#      steht es?"
#
# Es stand an drei Stellen - ZIEL.md, Intern/WEITERMACHEN.md und
# Intern/BEFUNDE.md - und an keiner nach Dringlichkeit sortiert. Die
# Massstabstabelle hatte keine Statusspalte; der Stand steckte als Fliesstext
# in der dritten Spalte, teils drei Zeilen lang. Eine Zeile (2a) nannte
# E-86 als offen, obwohl er seit 7.2.0.55 behoben ist.
#
# Gregors Regel dazu: "single point of truth! das datum steht also genau
# einmal richtig an einer stelle, sonst nicht."
#
# Die Reihenfolge der Gruppen ist die aus ZIEL.md und damit Gregors: was
# Post verfaelscht oder eine fremde Installation beschaedigt, steht oben.

my $schreiben = grep { $_ eq '-schreiben' } @ARGV;
my $wurzel = -f 'VERSION' ? '.' : '..';
my $quelle = "$wurzel/Intern/BEFUNDE.md";
my $ziel   = "$wurzel/ZIEL.md";

my $ANFANG = '<!-- ziel-stand: Anfang -->';
my $ENDE   = '<!-- ziel-stand: Ende -->';

sub lies { my ($d) = @_; open my $h,'<:raw',$d or return undef; local $/; my $t=<$h>; close $h; $t }

my $befunde = lies($quelle) or die "  ziel-stand: $quelle nicht lesbar\n";
my $zieltext = lies($ziel)  or die "  ziel-stand: $ziel nicht lesbar\n";

# --- 1. Welcher Befund ist offen, und was fehlt ihm? ----------------------
my (%offen, %fehlt, %kurz, %pruefen, %wer);
my @offen_wort = ('offen', 'in arbeit', 'zurueckgestellt', "zur\xc3\xbcckgestellt",
                  'teilweise', 'beobachtet', 'nicht gemessen');
my @erledigt_wort = ('behoben', 'kein eigener fehler', 'erledigt', 'nicht mehr auf',
                     'widerlegt', 'ueberholt', "\xc3\xbcberholt");
my %gesehen;

for my $zeile (split /\n/, $befunde) {
    next unless $zeile =~ /^\|\s*(?:<a\s+id="[^"]*"><\/a>)?\s*\**\s*([A-Z]{1,3}\d?-\d+[a-z]?)\s*\**\s*\|/;
    my $k = $1;
    next if $gesehen{$k}++;
    my @s = split /(?<!\\)\|/, $zeile, -1;
    next unless @s >= 4;
    my $urteil = $s[3];
    my @fett = grep { /\S/ } ($urteil =~ /\*\*([^*]+?)\*\*/g);
    next unless @fett;
    my $w    = lc $fett[0];
    my $alle = lc join ' || ', @fett;
    my $bleibt = index($alle, 'bleibt offen') >= 0;
    my $wieder = index($w,'wieder offen') >= 0 || index($w,'teilweise') >= 0 || $bleibt;
    next if !$wieder and grep { index($w, $_) >= 0 } @erledigt_wort;
    next unless $bleibt or grep { index($w, $_) >= 0 } @offen_wort;
    $offen{$k} = 1;
    if ($urteil =~ /\*\*Was noch fehlt:\*\*\s*(.+?)(?=\s*\*\*Wie zu pruefen:\*\*|\z)/s) {
        my $f = $1;
        $f =~ s/\s+/ /g; $f =~ s/\s+\z//;
        if (length($f) > 150) {
            $f = substr($f, 0, 150);
            # UTF-8 NICHT MITTEN IM ZEICHEN ABSCHNEIDEN (22.10.2026). substr
            # zaehlt Bytes; ein "ä" sind zwei. Beim Kuerzen von E-131 blieb
            # ein halbes Zeichen stehen, und die beiden erzeugten Bloecke in
            # CHANGELOG.md und Intern/WEITERMACHEN.md wurden dadurch
            # ungleich - der Vergleich meldete "nicht auf dem Stand", ohne
            # dass sich inhaltlich etwas geaendert hatte.
            1 while length($f) && $f =~ /[\x80-\xBF]\z/ && do { chop $f; 1 };
            chop $f if $f =~ /[\xC0-\xFF]\z/;
            $f .= '…';
        }

        $fehlt{$k} = $f;
    }
    # WER PRUEFT UND WIE (22.10.2026). Gregor: "was ist davon fuer mich zu tun
    # und zu testen? was kannst du selbst testen und verifizieren? ich brauche
    # dann eine test-anleitung, was sind die schritte, was muss ich
    # beobachten, damit die punkte geschlossen sind."
    #
    # Die Marke steht hinter "Was noch fehlt" am Ende der Urteilsspalte:
    #
    #     **Wie zu pruefen:** **ICH** - Schritte ...
    #
    # Beginnt sie mit "**ICH", ist es meine Arbeit; nennt sie Gregor, ist es
    # seine. Fehlt sie, steht das so in der Tabelle - sichtbar, nicht
    # verschwiegen.
    if ($urteil =~ /\*\*Wie zu pruefen:\*\*\s*(.+)\z/s) {
        my $p = $1;
        $p =~ s/\s+/ /g; $p =~ s/\s+\z//;
        $wer{$k} = ($p =~ /^\*\*ICH\b/) ? 'ich'
                 : ($p =~ /gregor/i)     ? "Gregor"
                 :                        '?';
        $p =~ s/^\*\*ICH\*\*\s*(?:—|-)?\s*//;
        $p = substr($p, 0, 190) . '…' if length($p) > 190;
        $pruefen{$k} = $p;
    }
    my $b = $s[2] // ''; $b =~ s/\*\*//g; $b =~ s/^\s+|\s+$//g; $b =~ s/\s+/ /g;
    $kurz{$k} = length($b) > 60 ? substr($b,0,57).'…' : $b;
}

# --- 2. Die Zeilen des Massstabs -----------------------------------------
my ($tab) = $zieltext =~ /## Maßstab für die Fassung 7\.2\.1\.0(.*?)\*\*Ausdrücklich nicht/s
    or die "  ziel-stand: die Massstabstabelle ist nicht zu finden.\n";
# DEN EIGENEN BLOCK WEGWERFEN (22.10.2026). Der erzeugte Stand steht INNERHALB
# des Abschnitts; ohne diese Zeile zaehlt das Werkzeug seine eigene Ausgabe als
# Massstabszeilen mit und meldete "18 von 27 erfuellt" statt "8 von 17".
$tab =~ s/\Q$ANFANG\E.*?\Q$ENDE\E//s;

my (@off, $erfuellt);
for my $zeile (split /\n/, $tab) {
    next unless $zeile =~ /^\| /;
    next if $zeile =~ /^\|---/ or $zeile =~ /^\| Gruppe/;
    my @c = split /\s\|\s/, $zeile;
    next unless @c >= 3;
    (my $grp = $c[0]) =~ s/^\|\s*//;
    my @ids = $c[1] =~ /\[\*{0,2}([A-Z]+-\d+)/g;
    unless (@ids) { $erfuellt++; next }          # eine Anforderung
    my @o = grep { $offen{$_} } @ids;
    unless (@o) { $erfuellt++; next }
    push @off, { grp => $grp, id => $o[0] };
}

# --- 3. Den Block bauen ---------------------------------------------------
my $gesamt = $erfuellt + scalar @off;
my $block  = "$ANFANG\n\n";
$block .= sprintf("**Stand: %d von %d erfüllt, %d offen.** Diese Übersicht wird aus den\n", $erfuellt, $gesamt, scalar @off);
$block .= "Urteilen in [Intern/BEFUNDE.md](Intern/BEFUNDE.md) **erzeugt** — `tools/ziel-stand.pl`\n";
$block .= "setzt sie und weist im `pre-commit` ab, wenn sie nicht stimmt. Die Reihenfolge ist\n";
$block .= "die der Gruppen unten: was Post verfälscht oder eine fremde Installation\n";
$block .= "beschädigt, steht oben.\n\n";

if (@off) {
    $block .= "| | wer | Was noch fehlt | Wie zu prüfen |\n|---|---|---|---|\n";
    for my $e (@off) {
        my $f = $fehlt{$e->{id}}   // '— **nicht aufgeschrieben**';
        my $p = $pruefen{$e->{id}} // '— **nicht aufgeschrieben**';
        my $w = $wer{$e->{id}}     // '?';
        $block .= sprintf("| **%s** | %s | %s | %s |\n", $e->{id}, $w, $f, $p);
    }
} else {
    $block .= "**Alle Zeilen des Maßstabs sind erfüllt.**\n";
}
$block .= "\n$ENDE";

# --- 4. Vergleichen oder setzen ------------------------------------------
unless ($zieltext =~ /\Q$ANFANG\E(.*?)\Q$ENDE\E/s) {
    print "  ziel-stand: die Marken fehlen in ZIEL.md. Einmal einsetzen:\n\n";
    print "    $ANFANG\n    $ENDE\n\n";
    exit 2;
}
my $ist = $ANFANG . $1 . $ENDE;
my $ohne = sub { my $s = shift; $s =~ s/\]\([^)]*\)//g; $s =~ s/[\[\]]//g; $s };

if ($ohne->($ist) eq $ohne->($block)) {
    printf "  ziel-stand: %d von %d erfüllt, %d offen - ZIEL.md ist auf dem Stand.\n",
           $erfuellt, $gesamt, scalar @off;
    exit 0;
}

unless ($schreiben) {
    print "  ziel-stand: der Stand in ZIEL.md stimmt nicht mehr.\n";
    printf "  Gemessen: %d von %d erfüllt, %d offen.\n", $erfuellt, $gesamt, scalar @off;
    print "  Neu setzen mit:   perl tools/ziel-stand.pl -schreiben\n";
    exit 1;
}

my $neu = $zieltext;
$neu =~ s/\Q$ANFANG\E.*?\Q$ENDE\E/$block/s;
my $c0 = () = $zieltext =~ /\r\n/g;
my $c  = () = $neu =~ /\r\n/g;
if ($c != $c0) { printf "  ABBRUCH - CRLF %d statt %d\n", $c, $c0; exit 1; }
open my $o,'>:raw',$ziel or die; print $o $neu; close $o;
printf "  ziel-stand neu gesetzt: %d von %d erfüllt, %d offen.\n", $erfuellt, $gesamt, scalar @off;
exit 0;
