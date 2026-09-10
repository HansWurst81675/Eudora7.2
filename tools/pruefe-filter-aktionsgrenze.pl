#!/usr/bin/perl
use strict;
use warnings;

# Schranke gegen den Schreibzugriff hinter das Aktionsfeld eines Filters
# (Befund E-68).
#
# WARUM ES DIESE SCHRANKE GIBT
#
# CFiltersDoc::Read (Eudora71/Eudora/filtersd.cpp) zaehlt beim Einlesen einer
# Regel aus Filters.pce einen Zaehler i hoch, sobald eine Zeile ein
# Aktionsschluesselwort traegt - und prueft ihn im Original NIE gegen
# NUM_FILT_ACTS. Der Zaehler indiziert nicht nur m_Actions[5]
# (filtersd.h:129), sondern auch elf gleich grosse Nachbarfelder, darunter
# die CString-Felder m_Sound, m_NotifyApp, m_Forward, m_Redirect, m_Reply,
# m_CopyTo und m_Desc. Eine Zuweisung an m_Desc[5] fasst den Speicher HINTER
# dem Feld als CString auf - das ist kein verbogener Zahlenwert mehr, sondern
# ein Schreibzugriff durch einen erfundenen Zeiger.
#
# Am 10.09.2026 wurde in Read eine Grenze eingezogen. Sie haengt an einer
# Liste: IstAktionsSchluesselwort() zaehlt die Schluesselwoerter auf, bei
# denen der Zaehler steigt. Zwei Listen, die deckungsgleich sein muessen,
# laufen frueher oder spaeter auseinander - jemand baut ein neues
# Filterschluesselwort ein, traegt es in den switch von Read ein und
# vergisst die Liste. Dann ist der Ueberlauf fuer genau dieses Wort
# stillschweigend wieder offen.
#
# Deshalb vergleicht diese Schranke die beiden Listen bei jedem Commit
# gegeneinander, statt sich auf Aufmerksamkeit zu verlassen.
#
# WAS SIE PRUEFT
#   1. Die Grenze in CFiltersDoc::Read ist ueberhaupt da und fragt
#      NUM_FILT_ACTS.
#   2. Jeder Zweig in Read, der den Zaehler hochzaehlt (m_Actions[i++] oder
#      m_Actions[i] mit einem spaeteren i++), steht in
#      IstAktionsSchluesselwort - und umgekehrt steht in der Liste kein
#      Schluesselwort, das gar nicht zaehlt.
#   3. CFiltersDoc::Write bleibt gebunden (for ... < NUM_FILT_ACTS). Faellt
#      diese Schleife weg, kann Eudora selbst eine Datei schreiben, die sein
#      eigenes Read wieder ueberlaufen laesst.
#
# KOMMENTARE UND ZEICHENKETTEN WERDEN WEGGEWORFEN, bevor gesucht wird - der
# Kopfkommentar von IstAktionsSchluesselwort nennt selbst
# "m_Actions[5]" und "NUM_FILT_ACTS" (Lehre aus tools/pruefe-beenden.pl).
#
# GEGENPROBEN, beide am 10.09.2026 gefahren (mit --selbsttest wiederholbar):
#
#   ABWEISEN    In einer Kopie von filtersd.cpp wurde (a) die Grenzzeile
#               entfernt und (b) ein Schluesselwort aus
#               IstAktionsSchluesselwort gestrichen, obwohl sein Zweig
#               weiterzaehlt. Rueckgabe 1, beide Mangel einzeln benannt.
#   DURCHLASSEN Gegen den behobenen Baum: Rueckgabe 0, 22 zaehlende Marken
#               in Read und 22 Marken in der Liste. Es sind 21 ZWEIGE:
#               IDS_FIO_TRANSFER_TO und IDS_FIO_COPY_TO teilen sich einen.

my $wurzel = $ENV{EUDORA_WURZEL} || '.';
my @mangel;
my $zweige = 0;
my $marken = 0;

my $QUELLE = 'Eudora71/Eudora/filtersd.cpp';

sub lies {
    my ($pfad) = @_;
    open(my $h, '<:raw', $pfad) or return undef;
    local $/;
    my $i = <$h>;
    close $h;
    return $i;
}

# Kommentare und Zeichenketten durch Leerzeichen ersetzen, Zeilen erhalten.
sub nur_code {
    my ($t) = @_;
    return '' unless defined $t;
    $t =~ s{//[^\n]*}{' ' x length($&)}ge;
    $t =~ s{/\*.*?\*/}{my $s = $&; $s =~ s/[^\n]/ /g; $s}ges;
    $t =~ s{"(?:[^"\\\n]|\\.)*"}{' ' x length($&)}ge;
    return $t;
}

# Den Rumpf einer Funktion herausschneiden: ab der Kopfzeile bis zur
# naechsten Zeile, die in Spalte 1 mit "}" beginnt.
sub rumpf {
    my ($code, $kopf) = @_;
    my @z = split(/\n/, $code, -1);
    my $von;
    for my $i (0 .. $#z) {
        if ($z[$i] =~ /\Q$kopf\E/) { $von = $i; last; }
    }
    return undef unless defined $von;
    for my $i ($von + 1 .. $#z) {
        return join("\n", @z[ $von .. $i ]) if $z[$i] =~ /^\}/;
    }
    return join("\n", @z[ $von .. $#z ]);
}

sub pruefe {
    my ($basis) = @_;
    my $roh = lies("$basis/$QUELLE");
    unless (defined $roh) {
        push @mangel, "$QUELLE: nicht lesbar";
        return;
    }
    my $code = nur_code($roh);

    # --- 1. Die Liste --------------------------------------------------
    my %liste;
    if ($code =~ /IstAktionsSchluesselwort\s*\(\s*int\s+\w+\s*\)\s*\{(.*?)\n\}/s) {
        my $rumpf = $1;
        $liste{$_} = 1 for ($rumpf =~ /case\s+(IDS_FIO_\w+)\s*:/g);
        $marken = scalar keys %liste;
    }
    else {
        push @mangel,
            "$QUELLE: IstAktionsSchluesselwort gibt es nicht mehr - damit "
          . "haengt die Grenze aus E-68 in der Luft.";
        return;
    }

    # --- 2. Der Lesezweig ----------------------------------------------
    my $read = rumpf($code, 'BOOL CFiltersDoc::Read(const char *filtFileName');
    unless (defined $read) {
        push @mangel, "$QUELLE: CFiltersDoc::Read(const char*, BOOL) nicht gefunden";
        return;
    }

    unless ($read =~ /i\s*>=\s*NUM_FILT_ACTS/ and $read =~ /IstAktionsSchluesselwort\s*\(/) {
        push @mangel,
            "$QUELLE: CFiltersDoc::Read prueft den Aktionszaehler nicht mehr "
          . "gegen NUM_FILT_ACTS. Die sechste Aktionszeile einer Regel "
          . "schreibt dann wieder hinter m_Actions[5] und hinter die elf "
          . "gleich grossen Nachbarfelder (E-68).";
    }

    # Welche case-Marken fuehren zu einem i++ ?
    # Der switch ist flach: ab "case IDS_FIO_X:" bis zum naechsten "case"
    # oder "}" auf derselben Ebene. Marken ohne eigenen Rumpf (Durchfall)
    # erben den Rumpf der folgenden Marke.
    my @teile = split(/(?=case\s+IDS_FIO_\w+\s*:)/, $read);
    my @offen;
    for my $t (@teile) {
        next unless $t =~ /^case\s+(IDS_FIO_\w+)\s*:/;
        my $name = $1;
        push @offen, $name;
        my $koerper = $t;
        $koerper =~ s/^case\s+IDS_FIO_\w+\s*:\s*//;
        next if $koerper =~ /^\s*$/;              # Durchfall zur naechsten Marke

        my $zaehlt = ($koerper =~ /m_Actions\s*\[\s*i\s*\+\+\s*\]/
                   || $koerper =~ /\bi\s*\+\+\s*;/
                   || $koerper =~ /m_\w+\s*\[\s*i\s*\+\+\s*\]/) ? 1 : 0;

        for my $m (@offen) {
            if ($zaehlt) {
                $zweige++;
                unless ($liste{$m}) {
                    push @mangel,
                        "$QUELLE: der Zweig 'case $m' in CFiltersDoc::Read "
                      . "zaehlt den Aktionszaehler hoch, steht aber NICHT in "
                      . "IstAktionsSchluesselwort. Fuer genau dieses "
                      . "Schluesselwort greift die Grenze aus E-68 nicht.";
                }
            }
            else {
                if ($liste{$m}) {
                    push @mangel,
                        "$QUELLE: '$m' steht in IstAktionsSchluesselwort, der "
                      . "Zweig in CFiltersDoc::Read zaehlt aber nicht hoch. "
                      . "Die Grenze verwirft damit Zeilen, die gar keine "
                      . "Aktion sind.";
                }
            }
        }
        @offen = ();
    }

    # --- 3. Der Schreibzweig -------------------------------------------
    my $write = rumpf($code, 'BOOL CFiltersDoc::Write()');
    if (defined $write) {
        unless ($write =~ /for\s*\(\s*int\s+i\s*=\s*0\s*;\s*i\s*<\s*NUM_FILT_ACTS\s*;/) {
            push @mangel,
                "$QUELLE: die Aktionsschleife in CFiltersDoc::Write ist nicht "
              . "mehr an NUM_FILT_ACTS gebunden. Eudora kann dann selbst eine "
              . "Filters.pce mit mehr Aktionen je Regel schreiben, als sein "
              . "eigenes Read fassen kann (E-68).";
        }
    }
    else {
        push @mangel, "$QUELLE: CFiltersDoc::Write() nicht gefunden";
    }
}

# ---------------------------------------------------------------------------
if (grep { $_ eq '--selbsttest' } @ARGV) {
    require File::Temp;
    require File::Path;

    my $tmp = File::Temp::tempdir(CLEANUP => 1);
    File::Path::make_path("$tmp/Eudora71/Eudora");

    my $t = lies("$wurzel/$QUELLE");
    die "Selbsttest: $QUELLE nicht lesbar\n" unless defined $t;
    # (a) Grenze heraus, (b) ein Schluesselwort aus der Liste heraus.
    $t =~ s/if \(filt && i >= NUM_FILT_ACTS && IstAktionsSchluesselwort\(Keyword\)\)/if (0)/;
    $t =~ s/^\t\tcase IDS_FIO_FORWARD:\n(?=\t\tcase|\t\t\treturn TRUE)//m;
    open(my $o, '>:raw', "$tmp/$QUELLE") or die $!;
    print $o $t;
    close $o;

    print "\n  Gegenprobe 1 - ABWEISEN (Grenze entfernt, IDS_FIO_FORWARD aus der Liste)\n";
    print '  ', '-' x 68, "\n";
    pruefe($tmp);
    my $n1 = scalar @mangel;
    print "    - $_\n" for @mangel;
    print "\n    Mangel: $n1  ->  Rueckgabe waere ", ($n1 ? 1 : 0), "\n";

    @mangel = (); $zweige = 0; $marken = 0;

    print "\n  Gegenprobe 2 - DURCHLASSEN (Arbeitsbaum, behoben)\n";
    print '  ', '-' x 68, "\n";
    pruefe($wurzel);
    my $n2 = scalar @mangel;
    print "    - $_\n" for @mangel;
    printf("\n    zaehlende Marken %d, davon in der Liste in der Liste %d\n", $zweige, $marken);
    print "    Mangel: $n2  ->  Rueckgabe waere ", ($n2 ? 1 : 0), "\n\n";

    if ($n1 > 0 && $n2 == 0) {
        print "  Beide Gegenproben in Ordnung.\n\n";
        exit 0;
    }
    print "  SELBSTTEST GESCHEITERT: abweisen=$n1 (muss >0 sein), ";
    print "durchlassen=$n2 (muss 0 sein).\n\n";
    exit 1;
}

pruefe($wurzel);

my $leise = grep { $_ eq '-q' or $_ eq '--leise' } @ARGV;
unless ($leise) {
    print "\n  Aktionsgrenze beim Einlesen von Filters.pce (E-68)\n";
    print '  ', '-' x 60, "\n";
    printf("  %-34s %d\n", 'zaehlende Marken in Read', $zweige);
    printf("  %-34s %d\n", 'Marken in der Liste',      $marken);
    print '  ', '-' x 60, "\n";
    if (@mangel) {
        print "\n  MANGEL:\n\n";
        print "    - $_\n" for @mangel;
        print "\n";
    }
    else {
        print "\n  Die Grenze steht, und beide Listen sind deckungsgleich.\n\n";
    }
}

exit(@mangel ? 1 : 0);
