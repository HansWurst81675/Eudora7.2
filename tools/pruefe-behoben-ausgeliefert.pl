#!/usr/bin/perl
use strict;
use warnings;

# pruefe-behoben-ausgeliefert.pl - steckt das, was als behoben gilt, wirklich
# in dem Paket, das Gregor bekommt?
#
# ---------------------------------------------------------------------------
# WARUM ES DIESE SCHRANKE GIBT
# ---------------------------------------------------------------------------
#
# Ich habe Gregor "behoben" gemeldet. Er hat 1.0.63 gestartet, und es stuerzte
# wieder ab. Seine Antwort: "idiot!". Die Ursache war nicht der Fix - der war
# richtig. Er lag in Eudora71/Bin/Release/ und war nie gepackt worden.
#
# Danach zweimal dieselbe Klasse:
#   * ein Paket, dessen Eudora.exe noch 7.2.0.67 sagte, obwohl auf .68
#     hochgezaehlt war - der Name des Pakets und sein Inhalt sagten
#     Verschiedenes;
#   * eine Messung gegen eine veraltete EXE im Testverzeichnis.
#
# Alle drei Male war die Aussage "behoben" an der QUELLE gemessen und fuer die
# AUSLIEFERUNG ausgegeben. Arbeitsweise/messung-muss-den-weg-treffen.md,
# Fall 2, beschreibt genau das: "Kein Symptom-Befund aus einem Stand ohne die
# Aenderung."
#
# Es gab dafuer keine Schranke. paket-pruefen.ps1 misst das Paket gegen das
# Bauverzeichnis, aber niemand hielt die Fassung der AUSGELIEFERTEN Eudora.exe
# gegen das, was BEFUNDE.md behauptet.
#
# ---------------------------------------------------------------------------
# WORAN GEMESSEN WIRD
# ---------------------------------------------------------------------------
#
# NICHT an VERSION. VERSION ist eine Absichtserklaerung - eine Datei, die
# jemand hochzaehlt. Gemessen wird an der Versionsressource der Eudora.exe,
# die im Paketverzeichnis liegt: sie entsteht beim Uebersetzen und wandert mit
# der Datei mit (Arbeitsweise/messung-muss-den-weg-treffen.md, Fall 4 - welches
# Ereignis hat diese Groesse geschrieben?).
#
# Gelesen wird die Ressource direkt aus der Datei: die Zeichenkette "7.2.0.NN"
# steht dort als UTF-16LE. Gegengeprueft am 18.09.2026 gegen
# [Diagnostics.FileVersionInfo] aus PowerShell (so liest tools/bauen.ps1:1179
# und tools/testlauf.ps1:109) - drei Pakete, drei Mal derselbe Wert:
#
#     Eudora72-1.0.70-release\Eudora.exe   PowerShell 7.2.0.70   hier 7.2.0.70
#     Eudora72-1.0.71-release\Eudora.exe   PowerShell 7.2.0.71   hier 7.2.0.71
#     Eudora72-1.0.72-release\Eudora.exe   PowerShell 7.2.0.72   hier 7.2.0.72
#
# Perl statt PowerShell, damit die Schranke in den Haken passt, ohne ihn um
# Sekunden zu verlaengern - eine laestige Schranke wird umgangen.
#
# ---------------------------------------------------------------------------
# WAS SIE PRUEFT
# ---------------------------------------------------------------------------
#
#   A. JEDES Paketverzeichnis traegt die Fassung, die sein Name behauptet.
#      Releases/Eudora72-1.0.NN-release/Eudora.exe muss 7.2.0.NN melden.
#      Das ist der gemessene Fall "Paket sagt .68, EXE sagt .67".
#
#   B. Was BEFUNDE.md als "behoben in 7.2.0.NN" fuehrt und zugleich als bei
#      Gregor BESTAETIGT ausgibt, muss in einem Paket liegen, dessen EXE
#      mindestens 7.2.0.NN meldet. Eine Bestaetigung an einem Stand, den es
#      als Paket nie gab, kann es nicht geben.
#
#      Nur behoben, ohne Bestaetigung, ist KEIN Mangel: eine Behebung wird an
#      der Quelle eingetragen, bevor gepackt wird. Diese Schranke soll den
#      Weg zum Paket nicht umdrehen, sondern die Aussage darueber halten.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-behoben-ausgeliefert.pl            prueft
#   perl tools/pruefe-behoben-ausgeliefert.pl --tests    Selbsttest
#
# Rueckgabe: 0 = stimmt, 1 = Paket und Aussage gehen auseinander,
#            2 = Aufrufproblem.

my $wurzel = -f 'VERSION' ? '.' : '..';

sub lies {
    my ($pfad) = @_;
    open my $h, '<:raw', $pfad or return undef;
    my $t = do { local $/; <$h> };
    close $h;
    return $t;
}

# Nur das Ende einer grossen Datei lesen.
#
# Die 21 Paketverzeichnisse enthalten je eine Eudora.exe von rund 3 MB; sie
# alle ganz zu lesen kostete gemessen 2846 ms. Die Versionsressource liegt im
# .rsrc-Abschnitt am Ende. Am 18.09.2026 ueber ALLE 21 Dateien gemessen:
# 63 Fundstellen, die entfernteste 285.036 Byte vor dem Dateiende. Ein
# Megabyte ist also das Dreieinhalbfache des gemessenen Bedarfs.
#
# Und wenn eine kuenftige Fassung doch anders liegt, ist das nicht stumm:
# Pruefung A meldet "in der Eudora.exe steht keine Fassung 7.2.0.NN" als
# MANGEL, nicht als in Ordnung. Ein Fehlgriff faellt also auf, statt zu decken
# (Arbeitsweise/messung-muss-den-weg-treffen.md).
my $SCHWANZ = 1024 * 1024;

sub lies_ende {
    my ($pfad) = @_;
    open my $h, '<:raw', $pfad or return undef;
    my $groesse = -s $h;
    seek $h, ($groesse > $SCHWANZ ? $groesse - $SCHWANZ : 0), 0;
    my $t = do { local $/; <$h> };
    close $h;
    return $t;
}

# Die Fassungen, die die Versionsressource einer EXE nennt.
#
# In einer Windows-EXE steht die Zeichenkette als UTF-16LE, also mit einem
# Nullbyte hinter jedem Zeichen. Gesucht wird genau das Muster des Projekts,
# 7.2.0.NN - damit trifft die Suche keine beliebige Zahlenfolge im Programmtext.
sub fassungen_der_exe {
    my ($inhalt) = @_;
    return () unless defined $inhalt;
    my %v;
    while ($inhalt =~ /(7\x00\.\x002\x00\.\x000\x00\.\x00(?:\d\x00)+)/g) {
        my $s = $1;
        $s =~ s/\x00//g;
        $v{$s} = 1;
    }
    return sort keys %v;
}

# Die Urteile aus BEFUNDE.md: Kennung => { fassung, bestaetigt }
sub urteile {
    my ($befunde) = @_;
    my @u;
    return @u unless defined $befunde;
    for my $z (split /\n/, $befunde) {
        next unless $z =~ /^\s*\|\s*\**\s*([A-Z]{1,3}\d*-\d+)\b/;
        my $kennung = $1;
        next unless $z =~ /behoben\s+in\s+\**\s*7\.2\.0\.(\d+)\b/i;
        my $fassung = $1;

        # "von Gregor ... bestaetigt" - dieselbe Wendung, die
        # pruefe-behoben-belegt.pl als Beleg anerkennt. Eine Verneinung davor
        # zaehlt nicht.
        my $bestaetigt = 0;
        if ($z =~ /von\s+(?:Gregor|ihm)\b([^|]{0,70}?)best(?:\xc3\xa4|ae)tigt/i) {
            my $dazwischen = $1;
            $bestaetigt = 1 unless $dazwischen =~ /\b(?:nicht|kein|noch\s+nicht|ohne)\b/i;
        }
        push @u, { kennung => $kennung, fassung => $fassung,
                   bestaetigt => $bestaetigt };
    }
    return @u;
}

sub pruefe {
    my ($pakete, $urteile) = @_;   # { 1.0.NN => [Fassungen der EXE] }, [Urteile]
    my (@mangel, @hinweis);
    my $geprueft = 0;

    # A. Paketname gegen Versionsressource.
    my $hoechste = 0;
    for my $p (sort keys %$pakete) {
        $geprueft++;
        my @gefunden = @{ $pakete->{$p} };
        unless (@gefunden) {
            push @mangel, "Paket $p: in der Eudora.exe steht keine Fassung "
                        . "7.2.0.NN - die Versionsressource fehlt oder ist anders";
            next;
        }
        my ($nr) = $p =~ /1\.0\.(\d+)/;
        unless (grep { $_ eq "7.2.0.$nr" } @gefunden) {
            push @mangel, "Paket $p heisst 1.0.$nr, seine Eudora.exe meldet aber "
                        . join(' und ', @gefunden)
                        . " - der Name des Pakets und sein Inhalt sagen Verschiedenes";
            next;
        }
        $hoechste = $nr if $nr > $hoechste;
    }

    # B. Bestaetigte Behebungen gegen die hoechste ausgelieferte Fassung.
    unless ($hoechste) {
        push @hinweis, 'kein Paketverzeichnis mit lesbarer Fassung gefunden - '
                     . 'Pruefung B uebersprungen';
        return (\@mangel, \@hinweis, $geprueft);
    }

    for my $u (@$urteile) {
        next unless $u->{bestaetigt};
        $geprueft++;
        next if $u->{fassung} <= $hoechste;
        push @mangel, "$u->{kennung} gilt als behoben in 7.2.0.$u->{fassung} UND "
                    . "als von Gregor bestaetigt - die hoechste Fassung, die je "
                    . "als Paket vorliegt, ist aber 7.2.0.$hoechste. An welchem "
                    . "Stand soll er das bestaetigt haben?";
    }

    return (\@mangel, \@hinweis, $geprueft);
}

# ---------------------------------------------------------------------------
# Selbsttest
# ---------------------------------------------------------------------------
if (grep { $_ eq '--tests' } @ARGV) {
    my ($fehler, $nr) = (0, 0);
    my $pruef = sub {
        my ($name, $ist, $soll) = @_;
        $nr++;
        return if $ist eq $soll;
        print "  FEHLER Selbsttest $nr ($name):\n    erwartet: $soll\n    bekommen: $ist\n";
        $fehler++;
    };

    # --- Die Ressource wird wirklich gelesen ------------------------------
    my $exe72 = "MZ\x90\x00Muell" . join('', map { "$_\x00" } split //, '7.2.0.72')
              . "mehr Muell";
    $pruef->('Fassung aus der Versionsressource',
             join(',', fassungen_der_exe($exe72)), '7.2.0.72');

    # Eine nackte Zahlenfolge im Programmtext ist keine Ressource.
    $pruef->('ASCII-Text wird nicht dafuer gehalten',
             join(',', fassungen_der_exe("irgendwo steht 7.2.0.72 als ASCII")), '');

    # --- A: DER GEMESSENE FALL "Paket .68, EXE .67" -----------------------
    my ($m_a) = pruefe({ '1.0.68' => ['7.2.0.67'] }, []);
    $pruef->('Paket .68 mit EXE .67 wird abgewiesen',
             (grep { /heisst 1\.0\.68, seine Eudora\.exe meldet aber 7\.2\.0\.67/ } @$m_a)
             ? 'ja' : 'nein (' . join('|', @$m_a) . ')', 'ja');

    # --- A, erlaubter Fall ------------------------------------------------
    my ($m_ok, undef, $g_ok) = pruefe({ '1.0.70' => ['7.2.0.70'],
                                        '1.0.72' => ['7.2.0.72'] }, []);
    $pruef->('stimmige Pakete laufen durch', join('|', @$m_ok), '');
    $pruef->('und es wurde etwas geprueft', $g_ok >= 2 ? 'ja' : "nein ($g_ok)", 'ja');

    # --- Urteile aus BEFUNDE.md lesen -------------------------------------
    my $bef = "| E-108 | Absturz | **behoben in 7.2.0.72**, von Gregor am laufenden Programm best"
            . "\xc3\xa4" . "tigt |\n"
            . "| E-99 | Datenverlust | **behoben in 7.2.0.80**, von Gregor best"
            . "\xc3\xa4" . "tigt |\n"
            . "| E-98 | Etwas | **behoben in 7.2.0.90**, von Gregor noch nicht best"
            . "\xc3\xa4" . "tigt |\n"
            . "| E-77 | Umlaute | **offen** |\n";
    my @u = urteile($bef);
    $pruef->('drei Urteile mit Fassung gelesen', scalar @u, '3');
    $pruef->('E-108 gilt als bestaetigt',
             (grep { $_->{kennung} eq 'E-108' && $_->{bestaetigt} } @u) ? 'ja' : 'nein', 'ja');
    $pruef->('"noch nicht bestaetigt" zaehlt NICHT als bestaetigt',
             (grep { $_->{kennung} eq 'E-98' && $_->{bestaetigt} } @u) ? 'ja' : 'nein', 'nein');

    # --- B: bestaetigt an einem Stand, den es als Paket nie gab -----------
    my ($m_b) = pruefe({ '1.0.72' => ['7.2.0.72'] }, \@u);
    $pruef->('Bestaetigung an einer nie gepackten Fassung wird abgewiesen',
             (grep { /^E-99 gilt als behoben in 7\.2\.0\.80 UND/ } @$m_b) ? 'ja' : 'nein', 'ja');
    $pruef->('E-108 (im Paket) loest keinen Fehlalarm aus',
             (grep { /^E-108/ } @$m_b) ? 'ja' : 'nein', 'nein');
    $pruef->('E-98 (nicht bestaetigt) loest keinen Fehlalarm aus',
             (grep { /^E-98/ } @$m_b) ? 'ja' : 'nein', 'nein');

    if ($fehler) {
        printf "\n  %d von %d Selbsttests fehlgeschlagen.\n\n", $fehler, $nr;
        exit 1;
    }
    printf "\n  Selbsttest: %d von %d bestanden - darunter der gemessene Fall\n"
         . "  \"Paket 1.0.68, Eudora.exe 7.2.0.67\" und die beiden erlaubten\n"
         . "  Faelle (behoben ohne Bestaetigung, Bestaetigung im Paket).\n\n",
         $nr, $nr;
    exit 0;
}

# ---------------------------------------------------------------------------
my %pakete;
for my $verz (glob("$wurzel/Releases/Eudora72-1.0.*-release")) {
    next unless -d $verz;
    my ($name) = $verz =~ /(Eudora72-1\.0\.\d+-release)/ or next;
    my ($nr)   = $name =~ /(1\.0\.\d+)/;
    my $exe = "$verz/Eudora.exe";
    next unless -f $exe;
    $pakete{$nr} = [ fassungen_der_exe(lies_ende($exe)) ];
}

my @u = urteile(lies("$wurzel/BEFUNDE.md"));
my ($mangel, $hinweis, $geprueft) = pruefe(\%pakete, \@u);

printf "\n  %s\n  behoben gegen die ausgelieferte Eudora.exe\n  %s\n", '-' x 60, '-' x 60;
printf "    Paketverzeichnisse             %d\n", scalar keys %pakete;
for my $p (sort keys %pakete) {
    printf "      %-10s Eudora.exe meldet %s\n", $p,
        @{ $pakete{$p} } ? join(', ', @{ $pakete{$p} }) : '(keine Fassung lesbar)';
}
printf "    Urteile \"behoben in 7.2.0.NN\"  %d, davon als bestaetigt %d\n",
    scalar @u, scalar grep { $_->{bestaetigt} } @u;
printf "    Einzelpruefungen               %d\n", $geprueft;

print "\n  HINWEIS: $_\n" for @$hinweis;

# Umfang 0 ist kein Freispruch (E-109, Punkt 4).
unless ($geprueft) {
    print "\n  NICHTS GEPRUEFT - das ist kein gruenes Ergebnis.\n";
    print "  Es liegt kein Paketverzeichnis mit einer lesbaren Eudora.exe vor, und\n";
    print "  BEFUNDE.md nennt kein bestaetigtes \"behoben in 7.2.0.NN\". Damit kann\n";
    print "  diese Schranke nichts aussagen - was nicht dasselbe ist wie in Ordnung.\n\n";
    exit 1;
}

unless (@$mangel) {
    print "\n  Jedes Paket traegt die Fassung, die sein Name behauptet, und keine\n";
    print "  bestaetigte Behebung verweist auf einen Stand, den es als Paket nie gab.\n\n";
    exit 0;
}

printf "\n  MANGEL - %d Stelle(n):\n\n", scalar @$mangel;
print "    - $_\n" for @$mangel;

print <<'ENDE';

  Gemessen wird an der Versionsressource der ausgelieferten Eudora.exe, nicht
  an VERSION. VERSION ist eine Absichtserklaerung; die Ressource entsteht beim
  Uebersetzen und wandert mit der Datei mit.

  Der Anlass: ich habe "behoben" gemeldet, waehrend die Behebung nur in
  Eudora71/Bin/Release/ lag und nie gepackt wurde. Gregor hat 1.0.63
  gestartet, es stuerzte wieder ab, und seine Antwort war "idiot!".

  Also: packen, das Paket gegen das Bauverzeichnis messen
  (tools/paket-pruefen.ps1), und erst danach "behoben" sagen
  (Arbeitsweise/paket-gegen-den-bau-messen.md).

ENDE
exit 1;
