# PRÜFER-21 — E-94 nachgerechnet (`6b4b14c`, `f1793e1`)

Lauf am 12.10.2026, nur lesend, aus dem Notizordner übernommen. **Empfehlung: kann ausgeliefert werden.** Der niedrige Befund (Kappung bei `LEX822_TOKEN_MAX` vor der Faltungsregel, einzelnes CR) ist im selben Commit wie dieser Bericht behoben: die Regel verschluckt nur noch, wenn das CR in der Marke steht. Die Gegenvermutung (Klartext auf `?=` vor einem kodierten Wort — ein Leerzeichen fällt weg, kein Text) ist bewusst so belassen.


Stand: Zweig e94-betreff-faltung, HEAD f1793e1. Nichts gebaut, nichts geändert.

## 1. Kern Fix2047 (lex822.cpp:716-735, ImapLex822.cpp gleich)
- Grenzen: `end - nextEqual >= 2` vor `=?`, `>= 3` vor CR LF WS; `*nextEqual` nur bei `nextEqual < end`. Kein Lesen hinter end.
- "?=\r\n" am Ende der Zeile: end-nextEqual == 2 < 3 -> break, CRLF bleibt. OK.
- "?= \r\n\t =?": Leerzeichen -> CRLF+TAB (3) -> Leerzeichen -> "=?" -> lastEqual = nextEqual-1. Mehrfach und gemischt OK.
- strcat(equal, lastEqual+1) kopiert ab "=?" (bzw. ab dem ersten Nicht-Leerraum) hinter den dekodierten Text. Richtig.
- Wenn das "=?" danach KEIN gültiges kodiertes Wort ist: der Leerraum ist trotzdem weg ("=?a?Q?x?= =?kaputt" -> "x=?kaputt"). War für Leerzeichen VORHER genauso; neu nur, dass das jetzt auch für eine Faltung gilt. Sonderfall, kein Rückschritt im Normalbetrieb.
- strcat mit überlappendem Quell-/Zielbereich (Ziel vor Quelle): vorbestehend, nicht neu.

## 2. LexFill (lex822.cpp:869-903; ImapLex822.cpp ~600-640)
- Zeitpunkt: ReadLine liefert eine Zeile mit LF am Ende; erreicht Spot das letzte Zeichen (LF), ruft `nextClass = ... : LexFill()` (lex822.cpp:184). LexFill legt das LF nach Buffer[0], liest die neue Zeile nach readHere = Buffer+1 und setzt m_FaltungLeerraum für GENAU diese Faltung, bevor die Regel (Z. 233) prüft. Bestätigt.
- Der Pfad `if (Spot >= End) LexFill()` (Z. 176) tritt nur beim Start und nach ReceiveError (size=0) auf: Nach jedem LexFill gilt Spot < End, und die Regel setzt Spot auf höchstens Buffer+1+nLeer < End (weil nLeer+1 < size). Dort ist charClass das erste Zeichen der neuen Zeile, nicht LF -> die Regel greift nicht.
- Ein veralteter Wert: m_FaltungLeerraum bleibt stehen, wenn das LF nicht in CollectText liegt, wird aber beim nächsten LexFill (am Zeilenende, VOR der nächsten Prüfung an einem LF) überschrieben. Ein LF in der Mitte des Puffers gibt es nicht (ReadLine endet am LF). Kein Rest für eine spätere Zeile.
- Überlange Zeile (>2045 Bytes, ReadLine liefert Stücke): m_ZeileEndetKodiert/m_FaltungLeerraum werden auf Teilstücken berechnet; die Regel feuert nicht, weil vor dem Stückanfang kein LF steht. Höchstens eine Faltung wird nicht entfernt (wie vorher). Harmlos.
- size/readHere: Zählen nur innerhalb size, die Suche nach "=?" mit i+1 < nEnde-2 bleibt innerhalb. OK. "?= \r\n" (Leerzeichen vor CRLF) wird nicht erkannt -> altes Verhalten, harmlos.

## 3. Faltungsregel (lex822.cpp:233-243)
- Spot zeigt auf das LF (Buffer[0]); `End - Spot = 1+size > nLeer` reicht, und Spot+1+nLeer zeigt auf "=?". OK. `continue` in do-while prüft returnToken == Continue822 -> läuft weiter. OK.
- CR als letztes Zeichen in der Marke: CollectText (Z. 434-455) nimmt CR822 über default ADD auf. Bestätigt.
- **Gekappte Marke**: Die Kappung (Z. 211, TokenSpot > 1021) liegt VOR der Regel. Füllt das CR die Marke genau auf 1022, wird die Marke am LF samt CR ausgegeben und geschrieben. Beim nächsten Aufruf ist TokenSpot==0; die Regel entfernt kein CR, verschluckt aber LF und Leerraum -> in der Mailbox steht ein **einzelnes CR** ("...?=\r=?..." dekodiert). Schwere niedrig (Betreff >1 KB und Kappung genau am CR), aber ein kaputtes Zeilenende in der .mbx. Abhilfe: in der Regel nur verschlucken, wenn `TokenSpot > 0 && Token[TokenSpot-1]=='\r'`, sonst normal als Faltung behandeln.
- Überlange Zeile in der .mbx: Die zusammengefügte Kopfzeile kann länger als 998 Zeichen werden (RFC 5322). Eudora liest seine eigene .mbx; summary.cpp:2099 `static char sBuffer[8192]`, GetLine Z. 2200. Über 8 KB bräuchte es weit über 100 Faltungen kodierter Wörter -> praktisch nicht zu erreichen. Die .mbx trägt ohnehin schon dekodierten 8-Bit-Text, ist also kein RFC-Text. Unbedenklich.

## 4. Kopfzeilen, die kaputtgehen könnten
- **Wichtig**: Nicht nur Subject, sondern JEDE Kopfzeile außer Content-Type/-Transfer-Encoding/-Disposition/MIME-Version läuft in header.cpp über EXPECT_TEXT (header.cpp:94, 183, 227 ...) und damit in CollectText; gleich in ImapHeader.cpp:109. Also auch From/To/Cc/Received. Das ist nach RFC 2047 richtig ("=?..A?=\r\n =?..B?= <x@y>" -> "AB <x@y>"). Die Annahme im Auftrag ("From strukturiert") stimmt nicht – die Regel greift auch dort, und zwar korrekt.
- Klartext-Fehlgriff (GEGENVERMUTUNG, selten): Eine Zeile, die "=?" enthält und auf "?=" endet, ohne kodiert zu sein (z. B. "Subject: a=?b c?=" oder ein unbekannter Zeichensatz, den Translate2047 ablehnt), gefolgt von " =?utf-8?Q?x?=" -> der Leerraum fällt weg ("...?=x"). m_ZeileEndetKodiert prüft nur das Muster, nicht ob Fix2047 dekodiert hat. Gleiches gilt, wenn die Folgezeile mit einem ungültigen "=?" beginnt. Ein Zeichen Leerraum geht verloren, kein Datenverlust.
- "=?" am Anfang einer Fortsetzung mit Klartext davor (vorige Zeile endet nicht auf "?="): m_ZeileEndetKodiert=FALSE -> unverändert. OK.
- URL-Parameter "?a=" endet auf "=" ohne "?=" davor -> FALSE. Variante "...?x=?=" kommt in URLs praktisch nicht vor; wenn doch, siehe oben (nur Leerraum).
- Received: enthält keine kodierten Wörter -> unberührt.

## 5. POP/IMAP
Die Codezeilen beider Teile sind bis auf die Namen (m_State, m_pSpot, m_pEnd, m_Token) gleich; LexFill in ImapLex822.cpp ist gleich aufgebaut (Z. 572-593, Puffer 2048). Symmetrisch. Der Kern ist ebenfalls gleich.

## 6. Speicherbild
Lex822State wird nur in Eudora/header.cpp und Eudora/RegInfoReader.cpp angelegt (beides Eudora.exe). EuImap hat eine eigene Klasse ImapLex822State und ist eine statische Bibliothek (EuImap.vcxproj: StaticLibrary). Andere Dateien, die lex822.h einbinden (ImHexbin, ImSingle, ImUudecode), legen keine Instanz an. Kein Plugin/keine DLL. Ein vollständiger Neubau von EuImap und Eudora reicht.

## Ergebnis
BEFUND (niedrig): lex822.cpp:233-243 / ImapLex822.cpp:246-256 – gekappte Marke (LEX822_TOKEN_MAX 1024), wenn das CR die Marke genau voll macht -> ein einzelnes CR in der .mbx. Eingabe: kodierter Betreff, gefaltet, bei dem das CR auf Markenposition 1022 fällt.
GEGENVERMUTUNG (niedrig): Klartext, der auf "?=" endet, bzw. ein abgelehnter Zeichensatz vor einer Faltung mit kodiertem Wort -> ein Leerzeichen geht verloren.
IN ORDNUNG: Kern-Grenzen, CRLF am Zeilenende, Mehrfach-/Mischfaltung, LexFill-Zeitpunkt, kein veralteter m_FaltungLeerraum, Bedingung End-Spot, CR als letztes Zeichen, POP/IMAP symmetrisch, Speicherbild.
EMPFEHLUNG: kann ausgeliefert werden; den Kappungsfall (CR schon geschrieben -> nicht verschlucken) bei Gelegenheit mit einer Zeile absichern.
