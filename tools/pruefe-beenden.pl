#!/usr/bin/perl
use strict;
use warnings;

# Schranke fuer das Beenden (Kriterium 7, Befunde E-40, E-41, E-42).
#
# WARUM ES DIESE SCHRANKE GIBT
#
# Gregor am 08.09.2026, nachdem alle drei Wege endlich beendeten: "haben wir
# ein review? und neue tests fuer die neue version? wenn nicht, nachholen!"
# Die Behebung besteht aus drei Teilen, und jeder von ihnen kann durch eine
# spaetere, gut gemeinte Aenderung lautlos wieder verschwinden:
#
#   E-40  CDoc::SaveModified und CMessageDoc::SaveModified duerfen im
#         default-Zweig NICHT FALSE liefern. IDCANCEL hat seinen eigenen
#         Zweig; in default faellt vor allem die 0 von AfxMessageBox, wenn der
#         Dialog gar nicht erzeugt werden kann - dann hat niemand entschieden.
#   E-41  CMainFrame::OnSysCommand muss SC_CLOSE einfassen und im Fehlerfall
#         WM_CLOSE nachschicken. Ohne das halten Alt-F4 und das Kreuz an dem
#         ENSURE_VALID in CFrameWnd::OnSysCommand (winfrm.cpp:1112-1114).
#   E-42  Die zwoelf Aufraeumschritte muessen durch AUFRAEUMEN laufen.
#
# Die Schranke prueft den QUELLTEXT, nicht das laufende Programm - sie braucht
# also kein Fenster und kann im pre-commit haengen. Das laufende Programm misst
# tools/beenden-pruefen.ps1, und das oeffnet ein Fenster.

my $wurzel = $ENV{EUDORA_WURZEL} || '.';
my @mangel;
my @gesehen;

sub lies {
    my ($pfad) = @_;
    open(my $h, '<:raw', "$wurzel/$pfad") or return undef;
    local $/;
    my $i = <$h>;
    close $h;
    return $i;
}

# Kommentare entfernen, BEVOR im Quelltext nach Anweisungen gesucht wird.
# Sonst liest die Schranke ihre eigene Begruendung: der E-40-Kommentar enthaelt
# woertlich "return FALSE", und die erste Fassung dieser Datei hat daraufhin
# doc.cpp und msgdoc.cpp angeschwaerzt, obwohl beide behoben waren. Dieselbe
# Falle steckte am 07.09.2026 in tools/pruefe-fensterbau.pl.
#
# Reihenfolge: ZEILENkommentare zuerst, dann Blockkommentare. Umgekehrt
# verschluckt ein "/*" innerhalb eines "//"-Kommentars den halben Rest der
# Datei - genau das ist bei pruefe-fensterbau.pl passiert.
sub ohne_kommentare {
    my ($t) = @_;
    return '' unless defined $t;
    $t =~ s{//[^\n]*}{}g;
    $t =~ s{/\*.*?\*/}{}gs;
    return $t;
}

# ---------------------------------------------------------------- E-40 ------
# Die elf Schritte, die durch AUFRAEUMEN laufen muessen.
#
# 'QCWorkbook::OnClose' stand hier bis zum 08.09.2026 mit dabei. Er ist
# ausdruecklich HERAUSGENOMMEN: PRUEFER-5 hat belegt, dass genau dieser Schritt
# nicht uebersprungen werden darf, weil CFrameWnd::OnClose mit DestroyWindow()
# endet (MFC 14, winfrm.cpp:941) und CMainFrame::OnClose es nirgends selbst
# ruft - ohne ihn bliebe ein Prozess ohne Fenster uebrig (BEFUND E-45). Fuer
# ihn gilt weiter unten eine eigene, umgekehrte Pruefung.
my @schritte = (
    'CloseImapConnections', 'EmptyTrash', 'CleanSSLLibrary', 'TrayItem',
    'DeleteMenuObjects', 'TrimJunk',
    'RemoveBogusAdToolBars', 'SaveBarState(ToolBar)', 'SaveWazooBarConfigToIni',
    'SaveCrashStateToINI', 'WriteToolBarMarkerToIni',
);

for my $datei ('Eudora71/Eudora/doc.cpp', 'Eudora71/Eudora/msgdoc.cpp') {
    my $inhalt = lies($datei);
    unless (defined $inhalt) { push @mangel, "$datei nicht lesbar"; next; }

    # SaveModified herausschneiden - nur dort gilt die Regel.
    my ($rumpf) = ohne_kommentare($inhalt) =~ /SaveModified\(\)\s*\{(.*?)\n\}/s;
    unless (defined $rumpf) {
        push @mangel, "$datei: SaveModified nicht gefunden - die Schranke kann E-40 nicht pruefen";
        next;
    }
    push @gesehen, "$datei SaveModified";

    # Im default-Zweig darf kein "return (FALSE)" mehr stehen.
    # Vom default-Zweig bis zum ENDE des Rumpfes lesen, nicht bis zur naechsten
    # schliessenden Klammer: der neue Zweig hat einen eigenen Block { }, und die
    # erste Fassung dieser Schranke hoerte an dessen Klammer auf. Ein
    # zurueckgekehrtes "return FALSE" DAHINTER blieb damit unentdeckt - im
    # Gegentest nachgewiesen.
    my ($nach_default) = $rumpf =~ /\n\s*default:(.*)\z/s;
    if (defined $nach_default && $nach_default =~ /return\s*\(?\s*FALSE/) {
        push @mangel, "$datei: der default-Zweig von SaveModified liefert wieder FALSE - "
                    . "eine Rueckfrage, die sich nicht oeffnen laesst, gilt damit erneut als "
                    . "\"Abbrechen\" und haelt Eudora offen (E-40)";
    }
    unless ($rumpf =~ /E-40/) {
        push @mangel, "$datei: die Marke E-40 fehlt in SaveModified - der default-Zweig "
                    . "muss den Rueckgabewert protokollieren, sonst ist der Fall von aussen "
                    . "nicht zu erkennen";
    }
}

# ---------------------------------------------------------------- E-41/42 ---
my $mainfrm = lies('Eudora71/Eudora/mainfrm.cpp');
if (!defined $mainfrm) {
    push @mangel, 'Eudora71/Eudora/mainfrm.cpp nicht lesbar';
}
else {
    push @gesehen, 'mainfrm.cpp';

    # E-42: das Makro muss da sein ...
    unless ($mainfrm =~ /#define\s+AUFRAEUMEN\s*\(\s*name\s*,\s*anweisung\s*\)/) {
        push @mangel, 'mainfrm.cpp: das Makro AUFRAEUMEN fehlt - ohne es kann jeder '
                    . 'Aufraeumschritt das Beenden wieder abbrechen (E-42)';
    }
    # ... und es muss wirklich einfassen, nicht bloss ausfuehren.
    my ($makro) = ohne_kommentare($mainfrm) =~ /(#define\s+AUFRAEUMEN.*?)\n\n/s;
    if (defined $makro) {
        push @mangel, 'mainfrm.cpp: AUFRAEUMEN fasst nicht ein - TRY fehlt (E-42)'
            unless $makro =~ /\bTRY\b/;
        push @mangel, 'mainfrm.cpp: AUFRAEUMEN faengt nicht - CATCH_ALL fehlt (E-42)'
            unless $makro =~ /\bCATCH_ALL\b/;
        push @mangel, 'mainfrm.cpp: AUFRAEUMEN meldet nicht - PutDebugLog fehlt (E-42)'
            unless $makro =~ /PutDebugLog/;
        push @mangel, 'mainfrm.cpp: AUFRAEUMEN nennt den Grund nicht - GetErrorMessage fehlt (E-42)'
            unless $makro =~ /GetErrorMessage/;
    }

    # E-42: jeder der elf Schritte muss eingefasst sein.
    for my $s (@schritte) {
        my $q = quotemeta $s;
        unless ($mainfrm =~ /AUFRAEUMEN\s*\(\s*"$q"/) {
            push @mangel, "mainfrm.cpp: der Aufraeumschritt '$s' laeuft nicht durch "
                        . "AUFRAEUMEN - er kann das Beenden abbrechen (E-42)";
        }
    }

    # E-45: QCWorkbook::OnClose ist der Gegenfall. Er darf NICHT durch
    # AUFRAEUMEN laufen (dann faellt DestroyWindow aus und es bleibt ein
    # Prozess ohne Fenster), muss aber trotzdem gefasst sein UND das
    # Zerstoeren des Fensters im Fangzweig nachholen.
    if ($mainfrm =~ /AUFRAEUMEN\s*\(\s*"QCWorkbook::OnClose"/) {
        push @mangel, 'mainfrm.cpp: QCWorkbook::OnClose laeuft durch AUFRAEUMEN - '
                    . 'dann faellt DestroyWindow() aus und es bleibt ein Prozess '
                    . 'ohne Fenster uebrig (E-45)';
    }
    else {
        push @gesehen, 'QCWorkbook::OnClose laeuft nicht durch AUFRAEUMEN (E-45)';
    }

    # Den eigenen Fangzweig herausschneiden: von der Aufrufzeile bis zum
    # naechsten END_CATCH_ALL. Kommentare vorher weg, damit die Erklaerung
    # im Quelltext die Pruefung nicht selbst erfuellt.
    my $rein = ohne_kommentare($mainfrm);
    my ($zweig) = $rein =~ /QCWorkbook::OnClose\s*\(\s*\)\s*;(.*?)END_CATCH_ALL/s;
    if (!defined $zweig) {
        push @mangel, 'mainfrm.cpp: nach dem Aufruf von QCWorkbook::OnClose folgt '
                    . 'kein END_CATCH_ALL - der Schritt ist ungefasst (E-45)';
    }
    else {
        push @gesehen, 'eigener Fangzweig um QCWorkbook::OnClose (E-45)';
        push @mangel, 'mainfrm.cpp: der Fangzweig um QCWorkbook::OnClose faengt '
                    . 'nicht - CATCH_ALL fehlt (E-45)'
            unless $zweig =~ /CATCH_ALL/;
        push @mangel, 'mainfrm.cpp: der Fangzweig um QCWorkbook::OnClose holt das '
                    . 'Zerstoeren des Fensters nicht nach - DestroyWindow fehlt (E-45)'
            unless $zweig =~ /DestroyWindow\s*\(/;
        push @mangel, 'mainfrm.cpp: der Fangzweig um QCWorkbook::OnClose meldet '
                    . 'nichts - PutDebugLog fehlt (E-45)'
            unless $zweig =~ /PutDebugLog/;
    }
    push @mangel, 'mainfrm.cpp: der Aufruf von QCWorkbook::OnClose steht nicht in '
                . 'einem TRY (E-45)'
        unless $rein =~ /TRY\s*\{\s*QCWorkbook::OnClose\s*\(\s*\)\s*;/s;

    # E-41: OnSysCommand muss SC_CLOSE einfassen und WM_CLOSE nachschicken.
    my ($sys) = ohne_kommentare($mainfrm) =~ /CMainFrame::OnSysCommand\s*\([^)]*\)\s*\{(.*?)\n\}/s;
    if (!defined $sys) {
        push @mangel, 'mainfrm.cpp: CMainFrame::OnSysCommand nicht gefunden - '
                    . 'die Schranke kann E-41 nicht pruefen';
    }
    else {
        push @gesehen, 'CMainFrame::OnSysCommand';
        push @mangel, 'mainfrm.cpp: OnSysCommand behandelt SC_CLOSE nicht eigens - '
                    . 'Alt-F4 und das Kreuz halten dann am ENSURE_VALID in '
                    . 'CFrameWnd::OnSysCommand (E-41)'
            unless $sys =~ /SC_CLOSE/;
        push @mangel, 'mainfrm.cpp: OnSysCommand fasst SC_CLOSE nicht ein - TRY fehlt (E-41)'
            unless $sys =~ /\bTRY\b/;
        # Auf PostMessage(WM_CLOSE pruefen, nicht bloss auf WM_CLOSE: der Name
        # steht auch im Protokolltext ("schicke WM_CLOSE nach"), und die erste
        # Fassung dieser Schranke war damit blind fuer das Entfernen des
        # Rueckfallwegs - im Gegentest nachgewiesen.
        push @mangel, 'mainfrm.cpp: OnSysCommand schickt kein WM_CLOSE nach - '
                    . 'scheitert die Systembehandlung, passiert dann nichts (E-41)'
            unless $sys =~ /PostMessage\s*\(\s*WM_CLOSE/;
        push @mangel, 'mainfrm.cpp: OnSysCommand behandelt ID_SYSTEM_MENU_CHECKMAIL nicht '
                    . 'mehr - der Sonderfall aus dem Systemmenue ist verlorengegangen'
            unless $sys =~ /ID_SYSTEM_MENU_CHECKMAIL/;
    }

    # Die Rueckfragen in CloseDown duerfen NICHT eingefasst sein: wer
    # "Abbrechen" drueckt, will nicht beenden.
    for my $frage ('QuerySendQueuedMessages', 'CanCloseFiltersFrame') {
        my $q = quotemeta $frage;
        if ($mainfrm =~ /AUFRAEUMEN\s*\(\s*"[^"]*$q/) {
            push @mangel, "mainfrm.cpp: die Rueckfrage '$frage' laeuft durch AUFRAEUMEN - "
                        . "damit wird ein \"Abbrechen\" des Anwenders verschluckt und "
                        . "Eudora beendet gegen seinen Willen";
        }
    }
}

# ---------------------------------------------------------------- Bilanz ----
my $leise = grep { $_ eq '-q' or $_ eq '--leise' } @ARGV;
unless ($leise) {
    print "\n  Beenden pruefen (Kriterium 7: E-40, E-41, E-42)\n";
    print '  ', '-' x 60, "\n";
    printf("  %-34s %d\n", 'gepruefte Stellen', scalar @gesehen);
    printf("  %-34s %d\n", 'eingefasste Aufraeumschritte', scalar @schritte);
    print '  ', '-' x 60, "\n";
    if (@mangel) {
        print "\n  MANGEL:\n\n";
        print "    - $_\n" for @mangel;
        print "\n";
    }
    else {
        print "\n  Das Beenden ist abgesichert.\n\n";
    }
}

exit(@mangel ? 1 : 0);
