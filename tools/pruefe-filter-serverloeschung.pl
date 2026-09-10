#!/usr/bin/perl
use strict;
use warnings;

# Schranke gegen Datenverlust auf dem SERVER durch eine Filteraktion
# (Befund E-73, zweite Fassung).
#
# WARUM ES DIESE SCHRANKE GIBT
#
# Gregor am 10.09.2026: "wenn ich mails filtere, dann werden sie gleichzeitig
# auf dem server geloescht? das moechte ich NICHT!" - und danach: "ja, 1 auf
# jeden fall! Filteraktion darf nicht mehr vom Server loeschen".
#
# E-73 wurde daraufhin an EINER Stelle geschlossen: im POP-Zweig von
# CFilter::Action. PRUEFER hat am 10.09.2026 alle Stellen gesucht, die aus
# einem Filterlauf heraus Post auf dem Server zum Loeschen vormerken, und
# ZWEI WEITERE gefunden, die daran vorbeiliefen:
#
#   IMAP  CFilter::Action verzweigt bei einem IMAP-Postfach nach ImapAction
#         (filtersd.cpp:1159-1161). Dort steht dieselbe Aktion noch einmal
#         und reicht sie an CImapFilterActions::ImapSetServerOpt weiter
#         (EuImap/src/ImapFiltersd.cpp:791-794) -> m_szDeletedUids ->
#         STORE \Deleted auf dem Server.
#
#   Junk  Die Filteraktion "Junk" laeuft ueber CJunkMail::DeclareJunk, und
#         das loescht bei DeleteFetchedJunk=1 auf dem Server
#         (JunkMail.cpp:687-690). E-74 hat DeleteFetchedJunk nur in
#         tools/DEudora.ini auf 0 gesetzt - eine Vorgabe fuer NEUE Konten,
#         die eine vorhandene Eudora.ini nicht anfasst.
#
# Eine Behebung, die nur einen von drei Wegen kennt, ist keine Behebung. Und
# der vierte Weg kommt beim naechsten Umbau dazu, wenn niemand nachmisst.
# Deshalb diese Schranke: sie liest den Quelltext, braucht kein Fenster und
# kann im pre-commit haengen.
#
# WAS SIE PRUEFT
#   1. Jede Loeschstelle in den Filterdateien wird vom Rueckschalter
#      gedeckt - oder steht namentlich in der Ausnahmeliste unten, MIT
#      Begruendung. Eine neue, ungedeckte Stelle wird abgewiesen.
#   2. Jeder Aufruf von ImapSetServerOpt fragt vorher den Rueckschalter.
#   3. Der Rueckschalter selbst ist heil: er liest FilterMayDeleteFromServer
#      und seine Vorgabe ist 0. Wer die Vorgabe auf 1 dreht, hebt E-73
#      stillschweigend auf.
#
# WAS SIE NICHT KANN: sie liest Text, keinen Ablauf. Steht der Rueckschalter
# in derselben Funktion, aber auf einem Zweig, der die Loeschstelle nicht
# deckt, faellt das hier nicht auf. Dagegen hilft nur Lesen.
#
# KOMMENTARE WERDEN WEGGEWORFEN, BEVOR GESUCHT WIRD. Das ist hier nicht
# vorsorglich: der Kommentar, der die Junk-Luecke erklaert, enthaelt woertlich
# "SetServerStatus(ID_MESSAGE_SERVER_DELETE)". Ohne das Wegwerfen haette die
# Schranke ihre eigene Begruendung angeschwaerzt - dieselbe Falle wie bei
# tools/pruefe-beenden.pl und tools/pruefe-fensterbau.pl.
#
# GEGENPROBEN, beide am 10.09.2026 gefahren (Ergebnisse in dieser Reihenfolge
# reproduzierbar mit --selbsttest):
#
#   ABWEISEN    Der Rueckschalter wurde in einer Kopie von filtersd.cpp und
#               JunkMail.cpp aus allen drei Wegen herausgenommen - also genau
#               der Stand von vor der Behebung. Rueckgabe 1, drei Mangel
#               benannt (POP, IMAP, Junk), jeder mit Datei und Zeile.
#               Gemeldet wurden filtersd.cpp:1282 (CFilter::Action),
#               filtersd.cpp:1781 (CFilter::ImapAction) und JunkMail.cpp:708
#               (CJunkMail::DeclareJunk).
#   DURCHLASSEN Gegen den behobenen Baum: Rueckgabe 0, keine Mangel,
#               3 gedeckte Loeschstellen und 2 benannte Ausnahmen gezaehlt.
#
# Die Gegenprobe in die andere Richtung ist die wichtigere: eine Pruefung,
# die immer 0 liefert, kostet genauso viel wie eine, die immer Alarm schlaegt
# (Arbeitsweise/schranke-gegentesten.md).

my $wurzel = $ENV{EUDORA_WURZEL} || '.';
my @mangel;
my $gedeckt   = 0;
my $ausnahmen = 0;

my $SCHALTER = 'FilterDarfVomServerLoeschen';

# ---------------------------------------------------------------------------
# Die Dateien im Filterweg. Nur hier wird gesucht; eine Loeschstelle im
# Abholcode (pophost.cpp) ist keine Filteraktion und geht diese Schranke
# nichts an.
my @DATEIEN = (
    'Eudora71/Eudora/filtersd.cpp',
    'Eudora71/Eudora/JunkMail.cpp',
);

# Was "auf dem Server loeschen" im Quelltext heisst.
my @LOESCHT = (
    'SetDeleteFlag\s*\(\s*LMOS_DELETE_MESSAGE',
    'SetServerStatus\s*\(\s*ID_MESSAGE_SERVER_DELETE',
    'SetServerStatus\s*\(\s*ID_MESSAGE_SERVER_FETCH_DELETE',
);

# Benannte Ausnahmen: Funktion => Begruendung.
#
# Diese beiden sind KEINE Filteraktionen. Sie laufen beim Abholen bzw. beim
# "Recheck Junk" und haengen an DeleteFetchedJunk - dem Schalter, den E-74
# behandelt. Sie hier mitzufassen wuerde das Verhalten aendern, das der
# Anwender selbst ausgeloest hat. Wer eine dritte Ausnahme eintraegt, soll
# begruenden muessen, warum sie keine Filteraktion ist.
my %AUSNAHME = (
    'CJunkMail::ProcessOne'   => 'kein Filterlauf - Einstufung beim Abholen, haengt an DeleteFetchedJunk (E-74)',
    'CJunkMail::ReprocessOne' => 'kein Filterlauf - "Recheck Junk", vom Anwender ausgeloest',
);

# ---------------------------------------------------------------------------
sub lies {
    my ($pfad) = @_;
    open(my $h, '<:raw', "$pfad") or return undef;
    local $/;
    my $i = <$h>;
    close $h;
    return $i;
}

# Kommentare und Zeichenketten wegwerfen, ZEILENZAHL ERHALTEN. Alles wird
# durch Leerzeichen ersetzt, Zeilenumbrueche bleiben stehen - sonst stimmen
# die gemeldeten Zeilennummern nicht mehr.
#
# Reihenfolge wie in pruefe-beenden.pl: Zeilenkommentare zuerst, dann
# Blockkommentare. Umgekehrt verschluckt ein "/*" innerhalb eines
# "//"-Kommentars den halben Rest der Datei.
sub nur_code {
    my ($t) = @_;
    return '' unless defined $t;
    $t =~ s{//[^\n]*}{' ' x length($&)}ge;
    $t =~ s{/\*.*?\*/}{my $s = $&; $s =~ s/[^\n]/ /g; $s}ges;
    $t =~ s{"(?:[^"\\\n]|\\.)*"}{' ' x length($&)}ge;
    return $t;
}

# Funktionsgrenzen: in diesen Dateien beginnt jede Funktion in Spalte 1.
# Liefert eine Liste [Zeilennummer, Name], aufsteigend.
sub funktionen {
    my ($code) = @_;
    my @f;
    my @z = split(/\n/, $code, -1);
    for my $i (0 .. $#z) {
        my $l = $z[$i];
        next unless $l =~ /^[A-Za-z_]/;      # Spalte 1, kein Einzug
        next if     $l =~ /^(?:using|typedef|struct|class|enum|namespace|extern|static\s+const)\b/;
        next unless $l =~ /\(/;
        next if     $l =~ /;\s*$/;           # blosse Deklaration
        my $name;
        if    ($l =~ /([A-Za-z_]\w*::~?[A-Za-z_]\w*)\s*\(/) { $name = $1; }
        elsif ($l =~ /([A-Za-z_]\w*)\s*\(/)                 { $name = $1; }
        else { next; }
        push @f, [ $i + 1, $name ];
    }
    return @f;
}

sub funktion_von {
    my ($zeile, $fref) = @_;
    my $treffer = '(ausserhalb einer Funktion)';
    for my $f (@$fref) {
        last if $f->[0] > $zeile;
        $treffer = $f->[1];
    }
    return $treffer;
}

# ---------------------------------------------------------------------------
# Ein Dateisatz pruefen. $praefix ist nur fuer die Meldung da, damit der
# Selbsttest sagen kann, dass er auf einer Kopie lief.
sub pruefe_dateien {
    my ($basis, @dateien) = @_;

    for my $rel (@dateien) {
        my $roh = lies("$basis/$rel");
        unless (defined $roh) {
            push @mangel, "$rel: nicht lesbar";
            next;
        }
        my $code = nur_code($roh);
        my @funk = funktionen($code);
        my @z    = split(/\n/, $code, -1);

        # --- 1. Loeschstellen -------------------------------------------
        for my $i (0 .. $#z) {
            my $nr = $i + 1;
            next unless grep { $z[$i] =~ /$_/ } @LOESCHT;

            my $fn = funktion_von($nr, \@funk);

            if (exists $AUSNAHME{$fn}) {
                $ausnahmen++;
                next;
            }

            # Steht der Rueckschalter in derselben Funktion VOR dieser Zeile?
            my $start = 1;
            for my $f (@funk) {
                last if $f->[0] > $nr;
                $start = $f->[0];
            }
            my $rumpf = join("\n", @z[ $start - 1 .. $i ]);

            if ($rumpf =~ /\b\Q$SCHALTER\E\s*\(/) {
                $gedeckt++;
            }
            else {
                push @mangel,
                    "$rel:$nr ($fn) merkt eine Nachricht auf dem SERVER zum "
                  . "Loeschen vor, ohne $SCHALTER zu fragen - E-73 waere hier "
                  . "wieder offen. Entweder den Rueckschalter fragen, oder die "
                  . "Funktion mit Begruendung in %AUSNAHME eintragen.";
            }
        }

        # --- 2. Der IMAP-Weg --------------------------------------------
        for my $i (0 .. $#z) {
            my $nr = $i + 1;
            next unless $z[$i] =~ /ImapSetServerOpt\s*\(/;

            my $fn    = funktion_von($nr, \@funk);
            my $start = 1;
            for my $f (@funk) {
                last if $f->[0] > $nr;
                $start = $f->[0];
            }
            my $rumpf = join("\n", @z[ $start - 1 .. $i ]);

            if ($rumpf =~ /\b\Q$SCHALTER\E\s*\(/) {
                $gedeckt++;
            }
            else {
                push @mangel,
                    "$rel:$nr ($fn) ruft ImapSetServerOpt, ohne $SCHALTER zu "
                  . "fragen. Mit SO_DELETE haengt das die UID in "
                  . "m_szDeletedUids (EuImap/src/ImapFiltersd.cpp:791-794), "
                  . "und daraus wird ein STORE \\Deleted auf dem Server.";
            }
        }
    }

    # --- 3. Der Rueckschalter selbst ------------------------------------
    my $filt = nur_code(lies("$basis/Eudora71/Eudora/filtersd.cpp"));
    if (defined $filt and length $filt) {
        unless ($filt =~ /BOOL\s+\Q$SCHALTER\E\s*\(/) {
            push @mangel,
                "filtersd.cpp: den Rueckschalter $SCHALTER gibt es nicht mehr - "
              . "damit ist E-73 auf allen drei Wegen offen.";
        }
        unless ($filt =~ /GetPrivateProfileInt\s*\(\s*_T\(\s*\)\s*,\s*_T\(\s*\)\s*,\s*0\s*,/s
             or $filt =~ /GetPrivateProfileInt[^;]*?,\s*0\s*,\s*INIPath/s)
        {
            push @mangel,
                "filtersd.cpp: die Vorgabe des Rueckschalters ist nicht mehr 0. "
              . "Eine Filteraktion loescht dann wieder auf dem Server, ohne dass "
              . "es jemand eingestellt hat - genau der Schaden aus E-73.";
        }
    }
}

# ---------------------------------------------------------------------------
# --selbsttest: beide Gegenproben in einem Lauf. Die ABWEISEN-Probe laeuft
# gegen eine Kopie, aus der der Rueckschalter herausgenommen ist - der Stand
# von vor der Behebung. Der Arbeitsbaum wird dabei nicht angefasst.
if (grep { $_ eq '--selbsttest' } @ARGV) {
    require File::Temp;
    require File::Path;
    require File::Copy;

    my $tmp = File::Temp::tempdir(CLEANUP => 1);
    File::Path::make_path("$tmp/Eudora71/Eudora");

    for my $rel (@DATEIEN) {
        my $t = lies("$wurzel/$rel");
        die "Selbsttest: $rel nicht lesbar\n" unless defined $t;
        # Den Rueckschalter aus den AUFRUFEN nehmen, die Definition stehen
        # lassen - so sieht der Stand von vor dem 10.09.2026 aus.
        $t =~ s/if \(\Q$SCHALTER\E\(m_Name, Sum->GetSubject\(\), "POP"\) &&\n\s*/if (/;
        $t =~ s/if \(\(uiServerOpt & SO_DELETE\) &&\n\s*!\Q$SCHALTER\E\(m_Name,\n\s*pSum \? pSum->GetSubject\(\) : "", "IMAP"\)\)/if (0)/;
        $t =~ s/ &&\n\s*\(pFilt != NULL \|\|\n\s*\Q$SCHALTER\E\("Junk", pSum->GetSubject\(\), "Junk-Filteraktion"\)\)//;
        open(my $o, '>:raw', "$tmp/$rel") or die $!;
        print $o $t;
        close $o;
    }

    print "\n  Gegenprobe 1 - ABWEISEN (Rueckschalter aus allen Aufrufen entfernt)\n";
    print '  ', '-' x 68, "\n";
    pruefe_dateien($tmp, @DATEIEN);
    my $n1 = scalar @mangel;
    print "    - $_\n" for @mangel;
    print "\n    Mangel: $n1  ->  Rueckgabe waere ", ($n1 ? 1 : 0), "\n";

    @mangel = (); $gedeckt = 0; $ausnahmen = 0;

    print "\n  Gegenprobe 2 - DURCHLASSEN (Arbeitsbaum, behoben)\n";
    print '  ', '-' x 68, "\n";
    pruefe_dateien($wurzel, @DATEIEN);
    my $n2 = scalar @mangel;
    print "    - $_\n" for @mangel;
    printf("\n    gedeckte Loeschstellen %d, benannte Ausnahmen %d\n", $gedeckt, $ausnahmen);
    print "    Mangel: $n2  ->  Rueckgabe waere ", ($n2 ? 1 : 0), "\n\n";

    if ($n1 > 0 && $n2 == 0) {
        print "  Beide Gegenproben in Ordnung: die Schranke weist den echten\n";
        print "  Fehler ab und laesst den erlaubten Fall durch.\n\n";
        exit 0;
    }
    print "  SELBSTTEST GESCHEITERT: abweisen=$n1 (muss >0 sein), ";
    print "durchlassen=$n2 (muss 0 sein).\n\n";
    exit 1;
}

# ---------------------------------------------------------------------------
pruefe_dateien($wurzel, @DATEIEN);

my $leise = grep { $_ eq '-q' or $_ eq '--leise' } @ARGV;
unless ($leise) {
    print "\n  Serverloeschung durch Filteraktionen (E-73)\n";
    print '  ', '-' x 60, "\n";
    printf("  %-34s %d\n", 'gedeckte Loeschstellen', $gedeckt);
    printf("  %-34s %d\n", 'benannte Ausnahmen',     $ausnahmen);
    print '  ', '-' x 60, "\n";
    if (@mangel) {
        print "\n  MANGEL:\n\n";
        print "    - $_\n" for @mangel;
        print "\n";
    }
    else {
        print "\n  Keine Filteraktion loescht am Rueckschalter vorbei.\n\n";
    }
}

exit(@mangel ? 1 : 0);
