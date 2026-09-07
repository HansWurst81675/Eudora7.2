use strict; use warnings;
#
# Selbsttests fuer tools/zeiger-nachpruefen.pl
#
#   perl tools/zeiger-nachpruefen-tests.pl
#
# Rueckgabe: 0 = alle gruen, 1 = mindestens einer rot.
#
# Aufbau wie tools/pruefe-bytes-tests.pl: je Fall ein kurzes Stueck C++,
# und die Erwartung, WIE VIELE Treffer es geben muss und in welcher Zeile.
#
# Die Faelle sind zweigeteilt:
#   MUSS FINDEN   - die drei belegten Befunde E-18, E-22, E-32 in der
#                   Gestalt, in der sie im Quelltext standen, plus die
#                   Stelle, die dieses Werkzeug neu gefunden hat.
#   DARF NICHT    - jede Bauform, die schon einmal einen Fehlalarm erzeugt
#                   hat. Die sechs Filter von suche-zeiger.pl sind hier
#                   noch einmal als Test hinterlegt, damit sie nicht
#                   verlorengehen, wenn jemand die Regeln aendert.

use FindBin;
require "$FindBin::Bin/zeiger-nachpruefen.pl";

my $gruen = 0;
my $rot   = 0;

sub pruefe {
    my ($titel, $text, $erwartet_zeilen) = @_;
    my @t = main::pruefe_text($text);
    my @ist = sort { $a <=> $b } map { $_->{Zeile} } @t;
    my @soll = sort { $a <=> $b } @$erwartet_zeilen;
    my $ok = (scalar(@ist) == scalar(@soll));
    if ($ok) { for my $i (0 .. $#soll) { $ok = 0 if $ist[$i] != $soll[$i] } }
    if ($ok) { $gruen++; printf "  gruen  %s\n", $titel }
    else {
        $rot++;
        printf "  ROT    %s\n", $titel;
        printf "         erwartet Zeilen [%s], bekommen [%s]\n",
               join(',', @soll), join(',', @ist);
        printf "         Treffer: %s:%d (%s)\n", $_->{Datei}, $_->{Zeile}, $_->{Name} for @t;
    }
}

# Hilfe: baut aus einer Liste von Zeilen einen Text, damit die Zeilennummern
# in den Tests sichtbar bleiben (Zeile 1 ist die erste Zeile der Liste).
sub text { return join("\n", @_) . "\n" }

print "MUSS FINDEN\n";

# --- 1. E-32 in der Gestalt, in der es im Quelltext stand ------------------
# headervw.cpp, CHeaderView::OnKillFocusRecipient, vor der Behebung.
# Der Waechter in Zeile 4 ist klammerlos; der ungepruefte Zugriff steht in
# Zeile 8 INNERHALB einer if-Bedingung. Genau daran ist suche-zeiger.pl
# vorbeigelaufen.
pruefe('E-32: Waechter klammerlos, Zugriff in einer Bedingung',
  text(
    'void CHeaderView::OnKillFocusRecipient(UINT nID)',                # 1
    '{',                                                               # 2
    '    CHeaderField* pField = (CHeaderField*)GetDlgItem(nID);',      # 3
    '    if (pField && pField->m_ACListBox)',                          # 4
    '        pField->m_ACListBox->KillACListBox();',                   # 5
    '',                                                                # 6
    '    if (GetIniShort(IDS_INI_AUTO_EXPAND_NICKNAMES) &&',           # 7
    '        pField->IsKindOf(RUNTIME_CLASS(CHeaderField)))',          # 8
    '    {',                                                           # 9
    '        int n = 1;',                                              # 10
    '    }',                                                           # 11
    '}',                                                               # 12
  ), [8]);

# --- 2. headervw.cpp:580/585 - von diesem Werkzeug neu gefunden -----------
# Waechter mit Block in Zeile 5, Zugriff danach in Zeile 8. Das ASSERT in
# Zeile 4 zaehlt ausdruecklich NICHT als Absicherung.
pruefe('P-3: Waechter mit Block, Zugriff danach im selben Schleifenrumpf',
  text(
    'void CHeaderView::OnInitialUpdate()',                             # 1
    '{',                                                               # 2
    '    for ( ; pos; iLabel++, iEdit++ ) {',                          # 3
    '        pField = m_headerFields.GetNext( pos );',                 # 4
    '        ASSERT( pField != NULL );',                               # 5
    '        if ( pField ) {',                                         # 6
    '            pField->Attach( this, iLabel, iEdit );',              # 7
    '        }',                                                       # 8
    '        theSize = theDC.GetTextExtent( pField->GetLabelText() );',# 9
    '    }',                                                           # 10
    '}',                                                               # 11
  ), [9]);

# --- 3. Der einfachste Fall: if (X) {...} danach X-> ----------------------
pruefe('Grundfall: Block-Waechter, Zugriff danach',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (p)',                                                      # 4
    '    {',                                                           # 5
    '        p->eins();',                                              # 6
    '    }',                                                           # 7
    '    p->zwei();',                                                  # 8
    '}',                                                               # 9
  ), [8]);

# --- 4. Zugriff im else-Zweig eines POSITIVEN Waechters -------------------
# Dort ist der Zeiger garantiert NULL - der Zugriff ist sicher falsch.
pruefe('else-Zweig eines positiven Waechters: X ist dort NULL',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (p)',                                                      # 4
    '    {',                                                           # 5
    '        p->eins();',                                              # 6
    '    }',                                                           # 7
    '    else',                                                        # 8
    '    {',                                                           # 9
    '        p->zwei();',                                              # 10
    '    }',                                                           # 11
    '}',                                                               # 12
  ), [10]);

print "\nDARF NICHT FINDEN\n";

# --- 5. Filter 1 von suche-zeiger.pl: klammerloser if-Rumpf --------------
# 212 Fehlalarme der alten Fassung. Der Zugriff IST der Rumpf.
pruefe('klammerloser Rumpf ist der geschuetzte Bereich',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (p)',                                                      # 4
    '        p->eins();',                                              # 5
    '}',                                                               # 6
  ), []);

# --- 6. Filter 2: einzeiliger Waechter mit return ------------------------
pruefe('einzeiliger Waechter mit return sichert den Rest ab',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (!p) return;',                                             # 4
    '    p->eins();',                                                  # 5
    '    p->zwei();',                                                  # 6
    '}',                                                               # 7
  ), []);

# --- 7. Waechter mit Block und return ------------------------------------
pruefe('Waechter mit Block und return sichert den Rest ab',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (!p)',                                                      # 4
    '    {',                                                           # 5
    '        return;',                                                 # 6
    '    }',                                                           # 7
    '    p->eins();',                                                  # 8
    '}',                                                               # 9
  ), []);

# --- 8. Filter 3: langer geschuetzter Block ------------------------------
# Die alte Fassung suchte das Blockende nur 40 Zeilen weit und meldete
# deshalb Zugriffe, die noch INNERHALB des Blocks standen.
pruefe('langer geschuetzter Block, Zugriff noch darin',
  text(
    'void f()',
    '{',
    '    CFoo* p = hol();',
    '    if (p)',
    '    {',
    (map { "        int x$_ = $_;" } 1 .. 60),
    '        p->eins();',
    '    }',
    '}',
  ), []);

# --- 9. Filter 4: else-Zweig nach einem NEGIERTEN Waechter ---------------
pruefe('else-Zweig eines negierten Waechters: X ist dort belegt',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (!p)',                                                      # 4
    '    {',                                                           # 5
    '        melde();',                                                # 6
    '    }',                                                           # 7
    '    else',                                                        # 8
    '    {',                                                           # 9
    '        p->eins();',                                              # 10
    '    }',                                                           # 11
    '}',                                                               # 12
  ), []);

# --- 10. Filter 5: Zuweisung an den Zeiger -------------------------------
pruefe('Zuweisung an den Zeiger macht die Pruefung gegenstandslos',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CDC* pDC = hol();',                                           # 3
    '    if (!pDC)',                                                    # 4
    '    {',                                                           # 5
    '        pDC = &dc;',                                              # 6
    '    }',                                                           # 7
    '    pDC->eins();',                                                # 8
    '}',                                                               # 9
  ), []);

# --- 11. Filter 6a: Pruefung nach && , die der alte Ausdruck nicht sah ---
pruefe('erneute Pruefung nach && in einer Bedingung mit inneren Klammern',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (p)',                                                      # 4
    '    {',                                                           # 5
    '        p->eins();',                                              # 6
    '    }',                                                           # 7
    '    if ( (n > 0) && p && p->zwei() )',                            # 8
    '    {',                                                           # 9
    '        p->drei();',                                              # 10
    '    }',                                                           # 11
    '}',                                                               # 12
  ), []);

# --- 12. Nur ASSERT als "Pruefung" ist keine Pruefung, aber auch kein ----
#         Treffer: ohne nackte Pruefung gehoert die Stelle nicht zu dieser
#         Fehlerklasse.
pruefe('ASSERT allein erzeugt keinen Treffer dieser Klasse',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    ASSERT( p != NULL );',                                        # 4
    '    p->eins();',                                                  # 5
    '}',                                                               # 6
  ), []);

# --- 13. Ein Zugriff INNERHALB von ASSERT ist kein Treffer ---------------
pruefe('Zugriff innerhalb von ASSERT zaehlt nicht',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (p)',                                                      # 4
    '    {',                                                           # 5
    '        p->eins();',                                              # 6
    '    }',                                                           # 7
    '    ASSERT( p->zwei() );',                                        # 8
    '}',                                                               # 9
  ), []);

# --- 14. Kommentar, der eine Pruefung zitiert ----------------------------
# Genau der Fall, der heute in headervw.cpp steht.
pruefe('Kommentar, der eine Pruefung zitiert, zaehlt nicht',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    // BEFUND E-32: hier stand einmal if (p && p->x)',            # 4
    '    p->eins();',                                                  # 5
    '}',                                                               # 6
  ), []);

# --- 15. Zeichenkette, die eine Pruefung zitiert -------------------------
pruefe('Zeichenkette, die eine Pruefung zitiert, zaehlt nicht',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    melde("if (p) fehlt");',                                      # 4
    '    p->eins();',                                                  # 5
    '}',                                                               # 6
  ), []);

# --- 16. Ein Name, der nur wie der gepruefte aussieht --------------------
pruefe('Namensteil zaehlt nicht als derselbe Zeiger',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    CFoo* pLang = hol();',                                        # 4
    '    if (pLang)',                                                  # 5
    '    {',                                                           # 6
    '        pLang->eins();',                                          # 7
    '    }',                                                           # 8
    '    if (p)',                                                      # 9
    '    {',                                                           # 10
    '        p->zwei();',                                              # 11
    '    }',                                                           # 12
    '}',                                                               # 13
  ), []);

# --- 17. Zugriff auf ein Mitglied, nicht auf den Zeiger ------------------
pruefe('Zugriff ueber ein anderes Mitglied zaehlt nicht',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    if (m_p)',                                                    # 3
    '    {',                                                           # 4
    '        m_p->eins();',                                            # 5
    '    }',                                                           # 6
    '    this->m_p->zwei();',                                          # 7
    '}',                                                               # 8
  ), []);

# --- 18a. Zeiger als ARGUMENT in der Bedingung ---------------------------
# Belegter Fehlalarm, Stichprobe 07.09.2026: AboutEMS.cpp:188 und
# eudora.cpp:2252. Der Zeiger steht in einer Aufrufklammer, nicht als
# Wahrheitswert - das ist keine Pruefung, also auch kein Treffer.
pruefe('Zeiger als Argument in der Bedingung ist keine Pruefung (AboutEMS)',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CDC* pDC = hol();',                                           # 3
    '    if (MemDC.CreateCompatibleDC(pDC))',                          # 4
    '    {',                                                           # 5
    '        eins();',                                                 # 6
    '    }',                                                           # 7
    '    pDC->DrawIcon(0, 0, icn);',                                   # 8
    '}',                                                               # 9
  ), []);

pruefe('Zeiger als Argument hinter ! ist keine Pruefung (eudora.cpp)',
  text(
    'BOOL CEudoraApp::IsIdleMessage( MSG* pMsg )',                     # 1
    '{',                                                               # 2
    '    if (!CWinApp::IsIdleMessage(pMsg))',                          # 3
    '        return m_bDoingIdleTimerProcessing;',                     # 4
    '',                                                                # 5
    '    UINT message = pMsg->message;',                               # 6
    '}',                                                               # 7
  ), []);

# Gegenprobe: das Leeren der Aufrufklammern darf die echte Pruefung nicht
# mitnehmen. E-32 muss weiter gefunden werden - das prueft Fall 1 oben, hier
# noch einmal mit einem Aufruf DIREKT hinter der Pruefung.
pruefe('Aufruf hinter der Pruefung nimmt die Pruefung nicht mit',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (p && p->test(RUNTIME_CLASS(CFoo)))',                      # 4
    '        p->eins();',                                              # 5
    '    p->zwei();',                                                  # 6
    '}',                                                               # 7
  ), [6]);

# --- 18b. Kurzschluss ueber mehrere Zeilen -------------------------------
# Belegte Fehlalarme, Stichprobe 07.09.2026: MIMEMap.cpp:116/117,
# nickdoc.cpp:2526/2527, sendmail.cpp:3568.
pruefe('Kurzschluss !X || X->y auf derselben Zeile',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* doc = hol();',                                          # 3
    '    if (doc)',                                                    # 4
    '        eins();',                                                 # 5
    '    if (!doc || !doc->GetText())',                                # 6
    '        return;',                                                 # 7
    '}',                                                               # 8
  ), []);

pruefe('Kurzschluss !X || X->y ueber mehrere Zeilen',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* nn = hol();',                                           # 3
    '    if (!nn ||',                                                  # 4
    '        FAILED(out.PutLine(nn->GetName())) ||',                   # 5
    '        FAILED(out.PutLine(nn->GetAddr())))',                     # 6
    '    {',                                                           # 7
    '        return;',                                                 # 8
    '    }',                                                           # 9
    '}',                                                               # 10
  ), []);

pruefe('Kurzschluss X && X->y ueber mehrere Zeilen',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (p)',                                                      # 4
    '        eins();',                                                 # 5
    '    if (p &&',                                                    # 6
    '        p->zwei())',                                              # 7
    '    {',                                                           # 8
    '        drei();',                                                 # 9
    '    }',                                                           # 10
    '}',                                                               # 11
  ), []);

# --- 18c. Negierter Waechter um eine und-Verknuepfung --------------------
# Belegter Fehlalarm, Stichprobe 07.09.2026: mboxtree.cpp:3580.
pruefe('!(A && B) ist ein negierter Waechter fuer A und fuer B',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    if (! (pTargetCommand && pSourceCommand) )',                  # 3
    '        return;',                                                 # 4
    '',                                                                # 5
    '    if( pSourceCommand->IsKindOf( RUNTIME_CLASS( X ) ) == FALSE )',# 6
    '        return;',                                                 # 7
    '    pTargetCommand->Tu();',                                       # 8
    '}',                                                               # 9
  ), []);

# Gegenprobe: ohne das herausspringende return bleibt der Treffer stehen.
pruefe('!(A && B) ohne Aussprung: Zugriff danach bleibt gemeldet',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    if (! (pA && pB) )',                                          # 3
    '    {',                                                           # 4
    '        melde();',                                                # 5
    '    }',                                                           # 6
    '    pB->Tu();',                                                   # 7
    '}',                                                               # 8
  ), [7]);

# --- 18d. Abgeschaltete Praeprozessorbloecke -----------------------------
# Belegte Fehlalarme, Handpruefung 07.09.2026: PgEmbeddedObject.cpp:246
# steht zwischen "#if 0" (155) und "#endif" (252),
# TridentReadMessageView.cpp:1092 in "#ifdef OLDSTUFF" (993).
pruefe('#if 0 wird nicht uebersetzt, also kein Treffer',
  text(
    '#if 0',                                                           # 1
    'void f()',                                                        # 2
    '{',                                                               # 3
    '    CFoo* pItem = hol();',                                        # 4
    '    if (pItem)',                                                  # 5
    '    {',                                                           # 6
    '        pItem->eins();',                                          # 7
    '    }',                                                           # 8
    '    pItem->zwei();',                                              # 9
    '}',                                                               # 10
    '#endif',                                                          # 11
  ), []);

pruefe('#ifdef OLDSTUFF wird nicht uebersetzt, also kein Treffer',
  text(
    '#ifdef OLDSTUFF',                                                 # 1
    'void f()',                                                        # 2
    '{',                                                               # 3
    '    CFoo* p = hol();',                                            # 4
    '    if (p)',                                                      # 5
    '        p->eins();',                                              # 6
    '    p->zwei();',                                                  # 7
    '}',                                                               # 8
    '#endif',                                                          # 9
  ), []);

# Gegenprobe: der else-Zweig eines abgeschalteten #if WIRD uebersetzt.
pruefe('der else-Zweig eines #if 0 wird uebersetzt und bleibt gemeldet',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '#if 0',                                                           # 4
    '    p->tot();',                                                   # 5
    '#else',                                                           # 6
    '    if (p)',                                                      # 7
    '        p->eins();',                                              # 8
    '    p->zwei();',                                                  # 9
    '#endif',                                                          # 10
    '}',                                                               # 11
  ), [9]);

# Gegenprobe: ein gewoehnliches #ifdef bleibt stehen.
pruefe('gewoehnliches #ifdef wird NICHT ausgeblendet',
  text(
    '#ifdef COMMERCIAL',                                               # 1
    'void f()',                                                        # 2
    '{',                                                               # 3
    '    CFoo* p = hol();',                                            # 4
    '    if (p)',                                                      # 5
    '        p->eins();',                                              # 6
    '    p->zwei();',                                                  # 7
    '}',                                                               # 8
    '#endif',                                                          # 9
  ), [7]);

# --- 18e. Aufruf mit Aufruf im Argument ----------------------------------
# Belegter Fehlalarm, Handpruefung 07.09.2026: mime.cpp:628. Geprueft wird
# innerMS, der Zeiger innerHD steht nur als Argument in einem Aufruf, der
# selbst einen Aufruf im Argument hat.
pruefe('Argument in einem Aufruf mit verschachtelten Aufrufen',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    if (!(innerMS = DEBUG_NEW MIMEState(ms->GetLineReader(), MimeStates.GetSize(), innerHD)) || !innerMS->m_Reader)',  # 3
    '        return;',                                                 # 4
    '    if (Vergleich(IDS_A, innerHD->contentType))',                 # 5
    '        return;',                                                 # 6
    '}',                                                               # 7
  ), []);

# --- 18f. positiver Waechter, dessen else-Zweig herausspringt ------------
# Belegter Fehlalarm, Handpruefung 07.09.2026: compmsgd.cpp:2247-2250.
pruefe('positiver Waechter mit herausspringendem else-Zweig',
  text(
    'CDoc* f()',                                                       # 1
    '{',                                                               # 2
    '    NewCompDoc = (CCompMessageDoc*)NewChildDocument(T);',         # 3
    '    if (NewCompDoc)',                                             # 4
    '        NewCompDoc->InitializeNew(a, b, c);',                     # 5
    '    else',                                                        # 6
    '        return (NewCompDoc);',                                    # 7
    '',                                                                # 8
    '    NewCompDoc->ApplyStationery(&d, e);',                         # 9
    '    return NewCompDoc;',                                          # 10
    '}',                                                               # 11
  ), []);

# Gegenprobe: ohne Aussprung im else bleibt der Treffer stehen.
pruefe('positiver Waechter mit else OHNE Aussprung bleibt gemeldet',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    if (p)',                                                      # 4
    '        p->eins();',                                              # 5
    '    else',                                                        # 6
    '        melde();',                                                # 7
    '',                                                                # 8
    '    p->zwei();',                                                  # 9
    '}',                                                               # 10
  ), [9]);

# --- 18. while-Waechter --------------------------------------------------
pruefe('while-Waechter schuetzt seinen Rumpf',
  text(
    'void f()',                                                        # 1
    '{',                                                               # 2
    '    CFoo* p = hol();',                                            # 3
    '    while (p)',                                                    # 4
    '    {',                                                           # 5
    '        p->eins();',                                              # 6
    '        p = p->next;',                                            # 7
    '    }',                                                           # 8
    '}',                                                               # 9
  ), []);

printf "\n%d gruen, %d rot\n", $gruen, $rot;
exit($rot ? 1 : 0);
