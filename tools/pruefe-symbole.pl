#!/usr/bin/perl
#
# Schranke fuer die Werkzeugleistensymbole (Befund E-30).
#
#   perl tools/pruefe-symbole.pl              # alle Pruefungen
#   perl tools/pruefe-symbole.pl -v           # zusaetzlich jede Leiste einzeln
#   perl tools/pruefe-symbole.pl --wurzel X   # anderer Arbeitsbaum
#
# Rueckgabewert 0 = alles in Ordnung. 1 = mindestens eine Abweichung.
#                                     2 = Aufruffehler (Datei fehlt o.ae.).
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 06.09.2026 hat Gregor die Fassung 7.2.0.10 auf einem Rechner ohne Visual
# Studio gestartet und berichtet:
#
#   "test bestanden: eudora laeuft ohne VS2022 installiert. es fehlen noch
#    icons, bzw. nicht alle werden vollstaendig angezeigt."
#
# Auf seinen Bildschirmfotos war zu sehen: im Hauptfenster alle Symbole da,
# bei vorne liegendem Fenster "Find Messages" an mehreren Stellen leere graue
# Flaechen - genau bei den Knoepfen, die dort GESPERRT sind.
#
# Die Ursache lag nicht im Zeichencode, sondern in den Bilddateien:
#
#   comctl32!CreateMappedBitmap - das, was CBitmap::LoadMappedBitmap aufruft -
#   setzt NUR die Farbtabelle einer Bitmap um. Eine Bitmap mit mehr als 8 Bit
#   Farbtiefe hat keine Farbtabelle und bleibt unveraendert. Die Bitmaps der
#   Hauptwerkzeugleiste sind 24 Bit; ihr Hintergrund 192,192,192 blieb also
#   stehen, waehrend der Knopf selbst in COLOR_BTNFACE (heute 240,240,240)
#   gemalt wird. Die Maske des gesperrten Knopfes traf dadurch das ganze
#   Bildrechteck statt nur das Symbol, und die Praegung uebermalte es.
#
# Unter VC6 fiel das nicht auf: dort war COLOR_BTNFACE selbst 192,192,192.
#
# DIESES WERKZEUG PRUEFT DIE VORAUSSETZUNGEN, UNTER DENEN DIE BEHEBUNG TRAEGT.
# Es startet nichts, es baut nichts und es braucht keinen Bildschirm - es
# liest die Ressourcendateien, die Bilddateien und die Ersatzschicht.
#
# DIE FUENF PRUEFUNGEN
#
#   1  Zu jeder TOOLBAR-Ressource gibt es eine BITMAP-Ressource derselben
#      Kennung. Ohne sie laedt SECLoadToolBarResource nichts.
#
#   2  Jede so benannte Bilddatei liegt auch im Dateisystem.
#
#   3  Jeder Knopf hat ein Bild: Bitmapbreite geteilt durch die in der
#      TOOLBAR-Zeile angegebene Bildbreite muss genau die Zahl der Knoepfe
#      ohne Trenner ergeben, und die Bitmaphoehe muss die Bildhoehe sein.
#      Diese Rechnung steht so auch in Eudoras eigenem Quelltext
#      (QCToolBarManager.cpp:399-401, dort als ASSERT).
#
#   4  Jede Leistenbitmap mit MEHR ALS 8 BIT Farbtiefe verlangt die eigene
#      Umsetzung. Deshalb darf die Ersatzschicht ihre Leistenbitmaps nicht
#      mehr allein ueber CBitmap::LoadMappedBitmap holen: in
#      OTShim_Werkzeugleiste.cpp muessen die Ladestellen ueber
#      SECLadeWerkzeugleistenBitmap gehen. GENAU DIESE PRUEFUNG WAERE VOR DER
#      BEHEBUNG ROT.
#
#   5  Der Hintergrund einer solchen Bitmap ist tatsaechlich 192,192,192 -
#      die Farbe, auf die die Umsetzung ausgelegt ist. Kaeme ein Symbolsatz
#      mit einem anderen Hintergrund dazu, griffe die Umsetzung ins Leere und
#      der Fehler waere wieder da, ohne dass irgendetwas anderes auffiele.
#      Gemessen wird die HAEUFIGSTE Farbe der Bitmap.
#
use strict;
use warnings;
use FindBin;

my $LAUT   = 0;
my $WURZEL = "$FindBin::Bin/..";

while (@ARGV) {
    my $a = shift @ARGV;
    if    ($a eq '-v' || $a eq '--laut') { $LAUT = 1 }
    elsif ($a eq '--wurzel')             { $WURZEL = shift @ARGV }
    else { print STDERR "Unbekannte Angabe: $a\n"; exit 2 }
}

# Die Farbe, die die Werkzeugleistenbitmaps von 1996 als Hintergrund benutzen
# und die OTShim beim Laden auf COLOR_BTNFACE umsetzt.
my @HINTERGRUND = (192, 192, 192);

my $QUELLE = "$WURZEL/Eudora71/Eudora";
my $SCHICHT = "$WURZEL/Eudora71/OTShim/OTShim_Werkzeugleiste.cpp";

my @fehler;
my @hinweise;

sub fehler { push @fehler,   join('', @_) }
sub hinweis{ push @hinweise, join('', @_) }

# ------------------------------------------------------------- Bilddateien

# Liest den Kopf einer BMP-Datei. Liefert eine Referenz auf einen Hash mit
# breite, hoehe, bits, versatz - oder undef.
sub bmp_kopf {
    my ($pfad) = @_;
    open(my $f, '<:raw', $pfad) or return undef;
    read($f, my $kopf, 54) or do { close $f; return undef };
    close $f;
    return undef if length($kopf) < 54;
    return undef unless substr($kopf, 0, 2) eq 'BM';
    return {
        versatz => unpack('V',  substr($kopf, 10, 4)),
        breite  => unpack('l<', substr($kopf, 18, 4)),
        hoehe   => unpack('l<', substr($kopf, 22, 4)),
        bits    => unpack('v',  substr($kopf, 28, 2)),
        packung => unpack('V',  substr($kopf, 30, 4)),
    };
}

# Ermittelt die haeufigste Farbe einer ungepackten 24-Bit-BMP-Datei.
# Liefert (r, g, b, anteil) oder die leere Liste.
sub haeufigste_farbe {
    my ($pfad, $k) = @_;
    return () unless $k->{bits} == 24 && $k->{packung} == 0;

    open(my $f, '<:raw', $pfad) or return ();
    local $/;
    my $d = <$f>;
    close $f;

    my $hoehe = $k->{hoehe} < 0 ? -$k->{hoehe} : $k->{hoehe};
    my $zeile = int(($k->{breite} * 3 + 3) / 4) * 4;
    return () if $k->{versatz} + $zeile * $hoehe > length($d);

    my %zaehler;
    for my $y (0 .. $hoehe - 1) {
        my $basis = $k->{versatz} + $y * $zeile;
        for my $x (0 .. $k->{breite} - 1) {
            $zaehler{ substr($d, $basis + $x * 3, 3) }++;
        }
    }
    return () unless %zaehler;

    my ($top) = sort { $zaehler{$b} <=> $zaehler{$a} } keys %zaehler;
    my @c = map { ord } split //, $top;      # BGR
    my $gesamt = $k->{breite} * $hoehe;
    return ($c[2], $c[1], $c[0], 100 * $zaehler{$top} / $gesamt);
}

# --------------------------------------------------------- Ressourcendatei

# Liest eine .rc und liefert zwei Hashes:
#   bitmaps  Kennung -> Dateiname (wie in der .rc geschrieben)
#   leisten  Kennung -> { breite, hoehe, knoepfe, trenner, zeile }
sub rc_lesen {
    my ($pfad) = @_;
    open(my $f, '<:raw', $pfad) or return (undef, undef);
    my (%bitmaps, %leisten);
    my ($aktuell, $nr) = (undef, 0);

    while (my $z = <$f>) {
        $nr++;
        $z =~ s/[\r\n]+$//;

        if (!defined $aktuell) {
            if ($z =~ /^\s*(\w+)\s+BITMAP\s+(?:DISCARDABLE\s+)?"([^"]+)"/i) {
                $bitmaps{$1} = $2;
            }
            elsif ($z =~ /^\s*(\w+)\s+TOOLBAR\s+(?:DISCARDABLE\s+)?(\d+)\s*,\s*(\d+)/i) {
                $aktuell = $1;
                $leisten{$1} = { breite  => $2, hoehe => $3,
                                 knoepfe => 0,  trenner => 0, zeile => $nr };
            }
            next;
        }

        # innerhalb eines BEGIN/END-Blockes
        if    ($z =~ /^\s*END\b/i)       { $aktuell = undef }
        elsif ($z =~ /^\s*BUTTON\b/i)    { $leisten{$aktuell}{knoepfe}++ }
        elsif ($z =~ /^\s*SEPARATOR\b/i) { $leisten{$aktuell}{trenner}++ }
    }
    close $f;
    return (\%bitmaps, \%leisten);
}

# ------------------------------------------------------------------- Lauf

print "Werkzeugleistensymbole - Pruefung zu Befund E-30\n";
print "Arbeitsbaum: $WURZEL\n\n";

my @rcdateien = grep { -f } ("$QUELLE/EudoraRes.rc", "$QUELLE/EudoraIcons.rc");
unless (@rcdateien) {
    print STDERR "Keine Ressourcendatei gefunden unter $QUELLE\n";
    exit 2;
}

my $anzahl_leisten = 0;
my $anzahl_gross   = 0;      # Leisten mit mehr als 8 Bit Farbtiefe

for my $rc (@rcdateien) {
    my ($bitmaps, $leisten) = rc_lesen($rc);
    unless ($bitmaps) {
        print STDERR "kann $rc nicht lesen\n";
        exit 2;
    }

    my $kurz = $rc;
    $kurz =~ s{.*/}{};

    for my $kennung (sort keys %$leisten) {
        my $L = $leisten->{$kennung};
        $anzahl_leisten++;

        # 1 - Bitmapressource derselben Kennung
        my $datei = $bitmaps->{$kennung};
        unless (defined $datei) {
            fehler("$kurz:$L->{zeile}  $kennung: TOOLBAR ohne gleichnamige ",
                   "BITMAP-Ressource - SECLoadToolBarResource laedt kein Bild");
            next;
        }

        # 2 - Datei im Dateisystem
        (my $rel = $datei) =~ s{\\\\}{/}g;
        $rel =~ s{\\}{/}g;
        my $pfad = "$QUELLE/$rel";
        unless (-f $pfad) {
            fehler("$kurz:$L->{zeile}  $kennung: Bilddatei fehlt: $rel");
            next;
        }

        my $k = bmp_kopf($pfad);
        unless ($k) {
            fehler("$kurz:$L->{zeile}  $kennung: $rel ist keine lesbare BMP-Datei");
            next;
        }

        my $hoehe = $k->{hoehe} < 0 ? -$k->{hoehe} : $k->{hoehe};

        # 3 - jeder Knopf ein Bild
        #
        # Hart ist nur der eine Fall, in dem etwas kaputtgeht: MEHR Knoepfe
        # als Bilder. Dann zeigt SECStdBtn::DrawFace fuer die ueberzaehligen
        # Knoepfe einen Ausschnitt hinter dem Ende der Bitmap.
        #
        # Die beiden anderen Abweichungen sind gemessen vorhanden, aber
        # folgenlos, und stehen deshalb nur als Hinweis (siehe
        # Befunde/SYMBOLE.md, Abschnitt "Zwei Ungereimtheiten im Altbestand"):
        #   - mehr Bilder als Knoepfe: die ueberzaehligen werden nie geholt.
        #   - Bitmap niedriger als die angegebene Bildhoehe: BitBlt beschneidet
        #     das Quellrechteck, der Knopf wird nur einen Punkt hoeher.
        if ($L->{breite} <= 0) {
            fehler("$kurz:$L->{zeile}  $kennung: Bildbreite 0 in der TOOLBAR-Zeile");
        }
        else {
            my $bilder = int($k->{breite} / $L->{breite});
            if ($k->{breite} % $L->{breite} != 0) {
                fehler("$kurz:$L->{zeile}  $kennung: Bitmapbreite $k->{breite} ist ",
                       "kein Vielfaches der Bildbreite $L->{breite}");
            }
            elsif ($bilder < $L->{knoepfe}) {
                fehler("$kurz:$L->{zeile}  $kennung: $L->{knoepfe} Knoepfe, aber nur ",
                       "$bilder Bilder ($rel ist $k->{breite} breit) - ",
                       ($L->{knoepfe} - $bilder), " Knopf/Knoepfe ohne Bild");
            }
            elsif ($bilder > $L->{knoepfe}) {
                hinweis("$kennung: $bilder Bilder in $rel, aber nur ",
                        "$L->{knoepfe} Knoepfe - ", ($bilder - $L->{knoepfe}),
                        " Bild(er) werden nie geholt");
            }
        }
        if ($hoehe < $L->{hoehe}) {
            hinweis("$kennung: TOOLBAR nennt die Bildhoehe $L->{hoehe}, ",
                    "$rel ist aber nur $hoehe hoch - BitBlt beschneidet, der ",
                    "Knopf wird ", ($L->{hoehe} - $hoehe), " Punkt(e) hoeher");
        }
        elsif ($hoehe > $L->{hoehe}) {
            fehler("$kurz:$L->{zeile}  $kennung: TOOLBAR nennt die Bildhoehe ",
                   "$L->{hoehe}, $rel ist aber $hoehe hoch - die untersten ",
                   ($hoehe - $L->{hoehe}), " Punktzeile(n) werden nie gezeigt");
        }

        # 5 - Hintergrundfarbe der Bitmaps ohne Farbtabelle
        if ($k->{bits} > 8) {
            $anzahl_gross++;
            my @h = haeufigste_farbe($pfad, $k);
            if (@h) {
                my ($r, $g, $b, $anteil) = @h;
                if ($r != $HINTERGRUND[0] || $g != $HINTERGRUND[1]
                                          || $b != $HINTERGRUND[2]) {
                    fehler("$kurz:$L->{zeile}  $kennung: haeufigste Farbe in $rel ",
                           "ist $r,$g,$b und nicht $HINTERGRUND[0],",
                           "$HINTERGRUND[1],$HINTERGRUND[2] - die Umsetzung ",
                           "auf COLOR_BTNFACE griffe hier ins Leere (E-30)");
                }
                elsif ($anteil < 10) {
                    hinweis("$kennung: der Hintergrund macht nur ",
                            sprintf('%.1f', $anteil), "% von $rel aus");
                }
            }
        }

        if ($LAUT) {
            printf("  %-22s %-34s %5dx%-4d %2d Bit  %3d Knoepfe, %d Trenner\n",
                   $kennung, $rel, $k->{breite}, $hoehe, $k->{bits},
                   $L->{knoepfe}, $L->{trenner});
        }
    }
}

# 4 - die Ersatzschicht muss die Umsetzung selbst leisten
if ($anzahl_gross > 0) {
    if (!-f $SCHICHT) {
        fehler("Ersatzschicht nicht gefunden: $SCHICHT");
    }
    else {
        open(my $f, '<:raw', $SCHICHT) or die "$SCHICHT: $!\n";
        local $/;
        my $q = <$f>;
        close $f;

        # Die Ladestellen erkennt man daran, dass die Ressourcenkennung des
        # Aufrufers weitergereicht wird. Steht dort noch LoadMappedBitmap,
        # bleibt der Hintergrund der 24-Bit-Bitmaps stehen.
        my $alt = () = $q =~ /bmp\.LoadMappedBitmap\s*\(\s*\n?\s*\(UINT\)/g;
        my $neu = () = $q =~ /SECLadeWerkzeugleistenBitmap\s*\(/g;

        if ($alt > 0) {
            fehler("OTShim_Werkzeugleiste.cpp: $alt Ladestelle(n) holen die ",
                   "Leistenbitmap noch ueber CBitmap::LoadMappedBitmap. ",
                   "comctl32 setzt Bitmaps ohne Farbtabelle nicht um, und ",
                   "$anzahl_gross Leiste(n) haben mehr als 8 Bit (E-30)");
        }
        if ($neu == 0) {
            fehler("OTShim_Werkzeugleiste.cpp: SECLadeWerkzeugleistenBitmap ",
                   "kommt nicht vor - die eigene Umsetzung des Hintergrunds ",
                   "fehlt (E-30)");
        }
    }
}

# ---------------------------------------------------------------- Ergebnis

print "\n" if $LAUT;
printf("Geprueft: %d Werkzeugleisten, davon %d mit mehr als 8 Bit Farbtiefe\n",
       $anzahl_leisten, $anzahl_gross);

for my $h (@hinweise) { print "hinweis: $h\n" }

if (@fehler) {
    print "\n";
    for my $f (@fehler) { print "FEHLER: $f\n" }
    printf("\n%d Abweichung(en).\n", scalar @fehler);
    exit 1;
}

print "Keine Abweichung.\n";
exit 0;
