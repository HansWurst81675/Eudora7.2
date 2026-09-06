#!/usr/bin/perl
#
# Testsammlung fuer tools/pruefe-symbole.pl.
#
#   perl tools/pruefe-symbole-tests.pl          # alle Faelle
#   perl tools/pruefe-symbole-tests.pl -v       # zusaetzlich die Ausgabe
#
# WARUM ES DIESE SAMMLUNG GIBT
#
# Eine Schranke, die nie rot wird, ist keine Schranke. Genau das war die
# Gefahr bei Befund E-30: der Fehler war auf einem Bildschirmfoto zu sehen,
# aber in keinem Testlauf. Ein Werkzeug, das den Fehler ANGEBLICH findet, ist
# nur dann etwas wert, wenn nachgewiesen ist, dass es ihn auch WIRKLICH
# findet - und dass es bei heilem Bestand schweigt.
#
# Deshalb prueft jeder Fall hier beides: dass der erwartete Rueckgabewert
# herauskommt UND dass der erwartete Text in der Ausgabe steht (bzw. bei den
# gruenen Faellen gerade NICHT).
#
# WIE SIE ARBEITET
#
# Jeder Fall baut sich einen vollstaendigen kuenstlichen Arbeitsbaum in einem
# Wegwerf-Verzeichnis:
#
#   <tmp>/Eudora71/Eudora/EudoraRes.rc
#   <tmp>/Eudora71/Eudora/res/icons/*.bmp
#   <tmp>/Eudora71/OTShim/OTShim_Werkzeugleiste.cpp
#
# und ruft das Werkzeug mit --wurzel darauf. Der echte Arbeitsbaum wird nicht
# angefasst, nichts gebaut und nichts gestartet.
#
use strict;
use warnings;
use FindBin;
use File::Temp qw(tempdir);
use File::Path qw(make_path);

my $LAUT     = grep { $_ eq '-v' } @ARGV;
my $WERKZEUG = "$FindBin::Bin/pruefe-symbole.pl";
-f $WERKZEUG or die "Werkzeug nicht gefunden: $WERKZEUG\n";

my ($gelaufen, $fehlgeschlagen) = (0, 0);

# ---------------------------------------------------------------- Bausteine

sub schreib {
    my ($pfad, $bytes) = @_;
    my $verz = $pfad;
    $verz =~ s{/[^/]+$}{};
    make_path($verz) unless -d $verz;
    open(my $f, '>:raw', $pfad) or die "schreiben $pfad: $!\n";
    print $f $bytes;
    close $f;
}

# Eine ungepackte 24-Bit-BMP-Datei: Flaeche in $hg, jedes Bild bekommt in der
# Mitte einen andersfarbigen Punkt, damit der Hintergrund nicht 100% ist.
sub bmp24 {
    my ($breite, $hoehe, $hg) = @_;          # $hg = [r,g,b]
    my $rand  = (4 - (($breite * 3) % 4)) % 4;
    my $bits  = '';
    for my $y (0 .. $hoehe - 1) {
        for my $x (0 .. $breite - 1) {
            if ($y == 0 && $x % 8 == 0) {
                $bits .= chr(0) . chr(0) . chr(0);
            }
            else {
                $bits .= chr($hg->[2]) . chr($hg->[1]) . chr($hg->[0]);
            }
        }
        $bits .= chr(0) x $rand;
    }
    my $ih  = pack('VllvvVVllVV', 40, $breite, $hoehe, 1, 24, 0,
                   length($bits), 2835, 2835, 0, 0);
    my $off = 14 + length($ih);
    return 'BM' . pack('VvvV', $off + length($bits), 0, 0, $off) . $ih . $bits;
}

# Eine ungepackte 8-Bit-BMP-Datei mit 256 Farben.
sub bmp8 {
    my ($breite, $hoehe) = @_;
    my $pal = '';
    $pal .= chr(192) . chr(192) . chr(192) . chr(0);
    $pal .= chr(0) x (4 * 255);
    my $rand = (4 - ($breite % 4)) % 4;
    my $bits = '';
    for my $y (0 .. $hoehe - 1) {
        $bits .= chr(0) x $breite;
        $bits .= chr(0) x $rand;
    }
    my $ih  = pack('VllvvVVllVV', 40, $breite, $hoehe, 1, 8, 0,
                   length($bits), 2835, 2835, 0, 0);
    my $off = 14 + length($ih) + length($pal);
    return 'BM' . pack('VvvV', $off + length($bits), 0, 0, $off)
           . $ih . $pal . $bits;
}

# Eine TOOLBAR-Ressource mit $n Knoepfen.
sub leiste_rc {
    my ($kennung, $bild, $breite, $hoehe, $n) = @_;
    my $t = "$kennung        BITMAP  \"res\\\\icons\\\\$bild\"\n\n";
    $t   .= "$kennung TOOLBAR  $breite, $hoehe\n";
    $t   .= "BEGIN\n";
    $t   .= "    BUTTON      ID_TEST_$_\n" for (1 .. $n);
    $t   .= "END\n\n";
    return $t;
}

# Die Ersatzschicht, einmal mit und einmal ohne die Behebung.
sub schicht_neu {
    return <<'ENDE';
// kuenstliche Fassung fuer den Test
BOOL SECLadeWerkzeugleistenBitmap(CBitmap& bmp, UINT nIDResource)
{
	return bmp.LoadMappedBitmap(nIDResource);
}

BOOL SECLoadToolBarResource(...)
{
	if (IS_INTRESOURCE(lpszResourceName))
		bLoaded = SECLadeWerkzeugleistenBitmap(
					bmp, (UINT)(UINT_PTR)(void*)lpszResourceName);
	return TRUE;
}
ENDE
}

sub schicht_alt {
    return <<'ENDE';
// kuenstliche Fassung fuer den Test - Stand VOR der Behebung
BOOL SECLoadToolBarResource(...)
{
	if (IS_INTRESOURCE(lpszResourceName))
		bLoaded = bmp.LoadMappedBitmap(
					(UINT)(UINT_PTR)(void*)lpszResourceName);
	return TRUE;
}
ENDE
}

# Baut einen Arbeitsbaum und laesst das Werkzeug darauf laufen.
# $bau ist eine Prozedur, die den Wurzelpfad bekommt.
sub lauf {
    my ($bau) = @_;
    my $wurzel = tempdir(CLEANUP => 1);
    $wurzel =~ s{\\}{/}g;
    $bau->($wurzel);
    my $aus = `"$^X" "$WERKZEUG" --wurzel "$wurzel" 2>&1`;
    my $rc  = $? >> 8;
    return ($rc, $aus);
}

sub pruefe {
    my ($name, $rc_soll, $muster, $bau, $nicht) = @_;
    $gelaufen++;
    my ($rc, $aus) = lauf($bau);

    my @abweichung;
    push @abweichung, "Rueckgabe $rc statt $rc_soll" if $rc != $rc_soll;
    if (defined $muster && $aus !~ /$muster/) {
        push @abweichung, "Ausgabe enthaelt nicht /$muster/";
    }
    if (defined $nicht && $aus =~ /$nicht/) {
        push @abweichung, "Ausgabe enthaelt faelschlich /$nicht/";
    }

    if (@abweichung) {
        $fehlgeschlagen++;
        print "[FEHL] $name\n";
        print "         $_\n" for @abweichung;
        print map { "       | $_\n" } split /\n/, $aus;
    }
    else {
        print "[ok  ] $name\n";
        print map { "       | $_\n" } split /\n/, $aus if $LAUT;
    }
}

# Der Normalfall, auf dem die meisten Faelle aufbauen: eine 24-Bit-Leiste mit
# vier Bildern zu 16x16 und vier Knoepfen, dazu die behobene Ersatzschicht.
sub baue_heil {
    my ($w, %anders) = @_;
    my $bilder  = $anders{bilder}  // 4;
    my $knoepfe = $anders{knoepfe} // 4;
    my $hoehe   = $anders{hoehe}   // 16;
    my $hg      = $anders{hg}      // [192, 192, 192];
    my $schicht = $anders{schicht} // schicht_neu();

    schreib("$w/Eudora71/Eudora/res/icons/test24.bmp",
            bmp24(16 * $bilder, $hoehe, $hg))
        unless $anders{ohne_datei};

    my $rc = "// kuenstliche Ressourcendatei\n\n";
    $rc .= leiste_rc('IDR_TEST24', 'test24.bmp', 16, 16, $knoepfe);
    $rc =~ s/^IDR_TEST24        BITMAP.*\n\n//m if $anders{ohne_bitmap};

    schreib("$w/Eudora71/Eudora/EudoraRes.rc", $rc);
    schreib("$w/Eudora71/OTShim/OTShim_Werkzeugleiste.cpp", $schicht);
}

# ------------------------------------------------------------------- Faelle

print "Testsammlung fuer tools/pruefe-symbole.pl\n\n";

pruefe('heiler Bestand: keine Abweichung', 0, qr/Keine Abweichung/,
       sub { baue_heil($_[0]) }, qr/FEHLER/);

pruefe('E-30: alte Ladestelle bei 24-Bit-Leiste wird gemeldet', 1,
       qr/LoadMappedBitmap/,
       sub { baue_heil($_[0], schicht => schicht_alt()) });

pruefe('E-30: fehlende Umsetzfunktion wird gemeldet', 1,
       qr/SECLadeWerkzeugleistenBitmap kommt nicht vor/,
       sub { baue_heil($_[0], schicht => schicht_alt()) });

pruefe('E-30: falscher Bildhintergrund wird gemeldet', 1,
       qr/griffe hier ins Leere/,
       sub { baue_heil($_[0], hg => [200, 200, 200]) });

pruefe('mehr Knoepfe als Bilder ist ein Fehler', 1,
       qr/ohne Bild/,
       sub { baue_heil($_[0], bilder => 3, knoepfe => 4) });

pruefe('mehr Bilder als Knoepfe ist nur ein Hinweis', 0,
       qr/werden nie geholt/,
       sub { baue_heil($_[0], bilder => 5, knoepfe => 4) }, qr/FEHLER/);

pruefe('zu hohe Bitmap ist ein Fehler', 1,
       qr/werden nie gezeigt/,
       sub { baue_heil($_[0], hoehe => 20) });

pruefe('zu niedrige Bitmap ist nur ein Hinweis', 0,
       qr/BitBlt beschneidet/,
       sub { baue_heil($_[0], hoehe => 12) }, qr/FEHLER/);

pruefe('TOOLBAR ohne gleichnamige BITMAP wird gemeldet', 1,
       qr/ohne gleichnamige/,
       sub { baue_heil($_[0], ohne_bitmap => 1) });

pruefe('fehlende Bilddatei wird gemeldet', 1,
       qr/Bilddatei fehlt/,
       sub { baue_heil($_[0], ohne_datei => 1) });

# Die Pruefung auf die Ladestelle darf NUR greifen, wenn es ueberhaupt eine
# Leiste ohne Farbtabelle gibt - sonst wuerde sie ein Projekt anmeckern, das
# den Fehler gar nicht haben kann.
pruefe('nur 8-Bit-Leisten: die alte Ladestelle ist unbedenklich', 0,
       qr/Keine Abweichung/,
       sub {
           my $w = shift;
           schreib("$w/Eudora71/Eudora/res/icons/test8.bmp", bmp8(64, 16));
           schreib("$w/Eudora71/Eudora/EudoraRes.rc",
                   "// kuenstlich\n\n"
                   . leiste_rc('IDR_TEST8', 'test8.bmp', 16, 16, 4));
           schreib("$w/Eudora71/OTShim/OTShim_Werkzeugleiste.cpp",
                   schicht_alt());
       },
       qr/FEHLER/);

pruefe('fehlende Ressourcendatei ist ein Aufruffehler', 2,
       qr/Keine Ressourcendatei/,
       sub { make_path("$_[0]/Eudora71/Eudora") });

# ---------------------------------------------------------------- Ergebnis

print "\n";
printf("Ergebnis: %d Faelle, %d bestanden, %d fehlgeschlagen\n",
       $gelaufen, $gelaufen - $fehlgeschlagen, $fehlgeschlagen);
exit($fehlgeschlagen ? 1 : 0);
