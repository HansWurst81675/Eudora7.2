# <a id="pruefer-99"></a>PRUEFER-99

Geprüft habe ich den Sammelzweig `paket_7_2_2_133`. Mein Zweig ist wt/pruefer-20261104f, abgezweigt von `origin/paket_7_2_2_133` (Stand `7818338c`). Geprüft ist alles, was seit `c856b0e` unter `Eudora71/`, `tools/` und `Releases/1.0` dazukam: [E-192](../Intern/BEFUNDE.md#e-192), [E-193](../Intern/BEFUNDE.md#e-193), [E-220](../Intern/BEFUNDE.md#e-220) und [E-221](../Intern/BEFUNDE.md#e-221), dazu das Zusammenführen (Testprojekt, `TestMain.cpp`, `pruefstand-faelle.txt`, `Version.h`). Den Teil von [E-199](../Intern/BEFUNDE.md#e-199) hat [PRUEFER-98](PRUEFER-98.md) schon geprüft, er ist hier nicht wiederholt. Eudora habe ich weder gebaut noch gestartet, kein Fenster geöffnet und keinen Prüfstand angefasst. Die Testsuite habe ich in meinem Baum gebaut und gefahren. Die Prüfstandläufe sind mir genannt worden, gemessen habe ich sie nicht.

## Ergebnis vorweg

Die vier Behebungen tun am Quelltext, was sie sollen. Die Testsuite läuft mit **421/421**. Nach dem Zusammenführen hängt jede Testdatei im Projekt, jeder Testblock wird genau einmal aufgerufen, und keine Fallkennung im Prüfstand steht doppelt. Bei [E-193](../Intern/BEFUNDE.md#e-193) stimmt die Weiche auch bei mehreren Kriterien, bei UND und ODER und bei der Verneinung.

Die Frage nach der Laufzeit der genauen Suche lässt sich am Quelltext nur teilweise beantworten. Wer mit Umlaut sucht, bekommt jetzt die alte Suche ohne Index. Sie liest jedes gewählte Postfach einmal ganz durch. Neu kommt hinzu, dass sie **jede HTML-Mail in jedem gewählten Postfach öffnet und umwandelt**, ob der Begriff roh darin steht oder nicht. Bei einem großen Postfach kann das Minuten dauern, und so lange ist die Suche mit Esc kaum abzubrechen. Wie lange es wirklich dauert, hat niemand gemessen.

Wichtiger als die Laufzeit ist ein Fund bei **IMAP** (K1). Bisher suchte der Index auch in IMAP-Postfächern in der lokalen Kopie. Jetzt geht ein Suchbegriff mit Umlaut bei *contains* an den **Server**, und zwar als rohe Latin-1-Bytes ohne Angabe des Zeichensatzes. Vermutlich findet der Server dann nichts. Gemessen ist das nicht, der Prüfstand für [E-193](../Intern/BEFUNDE.md#e-193) hat nur POP.

Zwei weitere Funde betreffen Stellen, die die Behebungen nicht berühren. Bei IMAP hat der Betreff dieselbe Faltung wie bei [E-221](../Intern/BEFUNDE.md#e-221), sie liest ihn vermutlich als **leer** (K5). Und [E-220](../Intern/BEFUNDE.md#e-220) nimmt bei einem so gefalteten Betreff wieder nur 63 Zeichen (K6).

**Kein Fund hält das Testpaket auf.** K1 und K2 sollte Gregor aber an einem IMAP-Postfach und an einem großen Postfach prüfen, bevor 7.2.2.133 als Release hinausgeht. Ich habe zwei neue Kennungen vergeben: E-232 (K1) und [E-233](../Intern/BEFUNDE.md#e-233) (K5). Beide stehen noch nicht in BEFUNDE.md. *(Nachtrag 05.11.2026 nach [LEKTOR-150](LEKTOR-150.md#l-150.4): [E-233](../Intern/BEFUNDE.md#e-233) steht jetzt in BEFUNDE; E-232 ist nicht vergeben, K1 ist in [E-193](../Intern/BEFUNDE.md#e-193) behoben.)*

## 1. E-193: Was die genaue Suche je Mail öffnet

**Die Weiche (am Quelltext belegt, `SearchView.cpp:2568-2594`, `:2635-2652`).** `E193BrauchtGenaueSuche` sieht alle Kriterien durch. Hat ein Text ein Byte ab 0x80, wird die ganze Suche genau. Ist irgendein Kriterium eine X1-Abfrage, bleibt die ganze Suche beim Index, und zwar unabhängig von der Reihenfolge, weil `return false` sofort greift. Der genaue Weg ist derselbe, den der Anwender mit *Use Indexed Search* aus schon immer bekam: `GetListMailboxPathnamesWithSelectedState(false, …)` und `SearchEngine::Start`.

**Was die Suche je Postfach tut (belegt, `SearchEngine.cpp`).**

| Schritt | Stelle | Kosten |
|---|---|---|
| Postfachdatei ganz lesen, je 64 KB, klein machen, `strstr` je Kriterium | `FindStringInFile` :1290-1420 | einmal je Postfach, linear in der Größe. Das ist die alte Suche ohne Index |
| je Zusammenfassung: Kriterien durchgehen | :842-1035 | ohne Öffnen fast nichts |
| **neu:** jede HTML-Mail öffnen, auch ohne rohen Treffer | :926-927 | je HTML-Mail: `NewChildDocument` (summary.cpp:770), die Postfachdatei **neu öffnen**, suchen, lesen (msgdoc.cpp:249-267), NUL-Bytes entfernen, `strcpy`, `HeaderContents` (Message-ID), `QCMessage::Init` mit Kopie und `BuildURIMap` (MimeStorage.cpp:75-99), zwei weitere Kopien (msgdoc.cpp:362, :382-385), `FindBody`, `Html2Text`, `MakeLower`, `strstr`, `OnCloseDocument` |
| **neu:** ein Postfach ohne rohen Treffer nicht nach der ersten Mail aufgeben | :1031 (`bE193Weiter`) | erst dadurch läuft die Schleife oben über alle Mails |

**Vorher und nachher (belegt).** Bis 7.2.2.132 öffnete die genaue Suche eine HTML-Mail nur, wenn der Begriff roh in ihr stand (`bMatched`, :928). Fand sie den Begriff in einem Postfach nirgends roh, gab sie das Postfach nach der ersten Mail auf (:1031). Jetzt öffnet sie bei einem Suchbegriff mit Umlaut **jede** HTML-Mail jedes gewählten Postfachs. Das gilt auch für Postfächer, in denen der Begriff roh vorkommt. Mails ohne HTML öffnet sie weiterhin nicht (`NeedToOpenMessageForRefinement(false, …)` gibt bei *contains* `false` ohne Öffnen, :1144-1154).

**Einschätzung der Laufzeit (Vermutung, nicht gemessen).** Die Kosten wachsen mit der **Zahl der HTML-Mails mal ihrer Größe**. Dazu kommt je Mail ein fester Anteil: ein MFC-Dokument anlegen und die Postfachdatei öffnen. Jede HTML-Mail wird etwa sechs- bis achtmal ganz kopiert oder durchlaufen. Die alte Suche ohne Index las jedes Byte einmal. Bei einem Postfach mit einigen zehntausend HTML-Mails rechne ich deshalb mit einem Vielfachen der alten Suche ohne Index, also eher Minuten als Sekunden. Die Zeitangabe am Prüfstand (rund 0,4 s) ist das Abfrageraster des Skripts (`messen-e193.ps1:313-317`, je 400 ms) bei neun Mails. Über ein großes Postfach sagt sie nichts.

**Abbrechen (belegt, K3).** In der Schleife über die Zusammenfassungen fragt nichts direkt nach Esc. Abgebrochen wird nur über `ReportResults` (:1013-1014), und `CSearchView::ProcessResults` prüft Esc nur, wenn es Treffer gibt (`SearchView.cpp:2688-2705`). Findet die Suche lange nichts, lässt sie sich so lange nicht abbrechen.

## 2. E-193: Mehrere Kriterien, UND, ODER, Verneinung

Belegt am Quelltext. `PreProcessForMatching` sortiert die Kriterien aus der Zusammenfassung (Betreff, Status, Label) vor die übrigen (`SearchCriteria.cpp:793-799`, :895).

| Fall | Ablauf | Ergebnis |
|---|---|---|
| *Anywhere contains* „Spätzle“, HTML-Mail mit `Sp&auml;tzle` | kein roher Treffer, :926 öffnet, `GetTextToSearch` nimmt `Html2Text` (:365-371) | gefunden, richtig |
| UND: „Zebrafink“ (roh da) **und** „Spätzle“ (nur als Entität) | Kriterium 1: Treffer, `!HasSingleTextCmp` öffnet (:908). Kriterium 2: `pMsgDoc` ist gesetzt, der Block :870 wird übersprungen, `SearchMessage` mit dem geöffneten Text | richtig |
| UND, Mail ohne HTML und ohne rohen Treffer | `bMatched = false`, UND bricht ab (:984) | richtig |
| ODER: „Spätzle“ oder „Zebrafink“ | erstes Kriterium öffnet und verfehlt, das zweite sucht im schon geöffneten Text | richtig |
| *does not contain* „Spätzle“, HTML-Mail mit Entität | ohne rohen Treffer `bMatched = true`, HTML wird geöffnet (das tat schon :928), `Html2Text` findet den Begriff, also `false` | richtig. `HasNegationSearch` verhindert den Abbruch ohnehin (:1031) |
| X1-Abfrage und Umlaut gemischt | `E193BrauchtGenaueSuche` gibt `false` | Index, richtig |
| Umlaut nur im Betreff- oder Postfachnamen-Kriterium | genaue Suche | harmlos. Der Betreff kommt aus der Zusammenfassung, die schon dekodiert ist |

**Unnötiges Öffnen (belegt, Teil von K2).** :926 gilt für jedes Kriterium mit vollem Text, also auch für *From*, *To*, *Cc*, *Bcc*, *Any Recipient*, *Headers* und *Attachment names*. `Html2Text` läuft aber nur für *Body* und *Anywhere* (:363-386). Bei den anderen kostet das Öffnen nur Zeit und ändert nichts am Ergebnis.

## 3. E-193 bei IMAP (K1 und K2)

**Server-Suche ohne Zeichensatz (belegt, K1).** Für ein IMAP-Postfach fragt `SearchEngine::Start` den Server, sobald ein Kriterium `ImapServerCanSearch` erfüllt (:776-829). Das gilt für *contains* und *does not contain* auf *Anywhere*, *Body*, *Headers*, *From*, *To*, *Cc*, *Bcc* und *Subject* (`searchutil.cpp:472-503`). Bei nur einem Kriterium, bei ODER oder bei UND ohne lokales Kriterium gilt dann **nur** die Antwort des Servers (:1045-1055). Der Suchtext geht ohne Umwandlung hinaus (`searchutil.cpp:569`, `:832`). `SEARCH` wird ohne `CHARSET` geschickt (`ImapConnection.cpp:2764`, `Search (NULL, …)`). `SendAstring` behandelt ein Byte ab 0x80 mit vorzeichenbehaftetem `char` als Steuerzeichen (`proto.cpp:2794`, `t[j] > ' '`). So steht „spätzle“ als rohe Latin-1-Bytes in Anführungszeichen. RFC 3501 erlaubt in einer solchen Zeichenkette nur 7-Bit-Zeichen und ohne `CHARSET` nur US-ASCII.

**Folge (Vermutung, nicht gemessen).** Je nach Server gibt es eine Fehlermeldung oder keinen Treffer. Ein Server, der UTF-8 annimmt, vergleicht `E4` mit `C3 A4` und findet nichts. Bis 7.2.2.132 lief eine solche Suche bei eingeschaltetem Index über die lokale Kopie, die X1 auch für IMAP führt (`SearchManagerSearching.cpp:1053-1071`, IMAP-Merkmale im Index). Für einen IMAP-Anwender kann [E-193](../Intern/BEFUNDE.md#e-193) also aus „findet mit Fehlern“ ein „findet nichts“ machen. Der Prüfstand für [E-193](../Intern/BEFUNDE.md#e-193) holt die Post nur über POP (`messen-e193.ps1:31`). Das ist der Kern von **E-232**.

**Lokale IMAP-Suche lädt nach (belegt, K2).** Ist ein Kriterium nicht auf dem Server suchbar, sucht Eudora lokal. Das gilt etwa für *contains word*, das das Suchfenster im Index-Modus anbietet (`SearchView.cpp:1834`), und für ODER mit *Status* oder *Label*. Dann öffnet :926 jede HTML-Mail. `CMessageDoc::GetFullMessage` lädt bei IMAP eine noch nicht geholte Mail vom Server (msgdoc.cpp:226-230, `DownloadImapMessage`, summary.cpp:3625-3627). Ob eine ungeholte Mail als HTML gilt, hängt am `Content-Type` der obersten Ebene im Kopf (ImapDownload.cpp:2747-2755). Eine Suche kann so viele Mails vom Server holen. Das kostet Zeit und Verbindung und ist offline eine Rückfrage je Mail (Vermutung, wie bei [PRUEFER-90](PRUEFER-90.md) K2).

## 4. E-192

Belegt am Quelltext. Die drei Aufrufer (Papierkorb `ImapToc.cpp:3129-3144`, Junk `:3440-3452`, Filter `ImapFiltersd.cpp:1285-1305`) und die beiden Weitergaben in `ImapMailbox.cpp` (:3420-3424, :3563-3567) sind vollständig. Weitere Aufrufer von `ImapTransferSummaryData` gibt es nur in der Warteschlange (`ImapActionQueue.cpp:1616-1621`), und die gibt die Quellmenge seit [E-184](../Intern/BEFUNDE.md#e-184) K3 schon weiter. `tocdoc.cpp:4778` überträgt ohne neue UIDs. `UIDCopy` schickt in Stücken (`ImapStream.cpp:1797-1840`). `StoreUIDPLUSResponses` hängt Quell- und Zielmenge nur gemeinsam an (`proto.cpp:2158-2167`). So bleiben beide gleich lang, auch über mehrere Stücke.

Die bekannte Grenze aus [PRUEFER-78](PRUEFER-78.md) K2 gilt jetzt auch für Papierkorb, Junk und Filter. Wird ein Eintrag der Liste übersprungen, zählt `i` weiter. Die Schleife endet bei `i < iSize` (`ImapToc.cpp:1619`, :1642-1647), und spätere, wirklich kopierte Mails bekommen keine Zuordnung. Wird ein ganzes Stück ohne gültiges `COPYUID` beantwortet, trifft es alle Mails der folgenden Stücke. Verloren geht nichts, die Zusammenfassung kommt beim nächsten Abgleich. Der Befund nennt diese Grenze.

## 5. E-220

**Regeln (belegt, `msgutils.cpp`, `E220DateinameAusBetreff`).** Gezählt wird mit `unsigned char`. Lücken werden zu genau einem Leerzeichen, an den Enden steht keines. Die Grenze von 120 Zeichen und der Puffer stimmen: Ein Leerzeichen kommt nur hinein, wenn danach noch ein Zeichen passt. Die Rechnung für Gerätenamen ist richtig.

**Vollständiger Betreff bei Faltung hinter dem Doppelpunkt (belegt, K6).** `HeaderContents` überspringt nach `Subject:` nur Leerzeichen und Tabulatoren (`msgutils.cpp:72-74`), nicht CR und LF. Bei `Subject:` mit Zeilenumbruch, also genau der Form aus [E-221](../Intern/BEFUNDE.md#e-221), beginnt der Inhalt deshalb mit einem Leerzeichen (:106-110). Der Vergleich `strncmp(pszKopf, pszSummenBetreff, nSumme)` schlägt dann fehl, und der Vorschlag kommt aus den 63 Zeichen der Zusammenfassung. Das ist kein falscher Name, nur ein gekürzter. Betroffen sind Nachrichten älterer Eudora-Fassungen (laut [E-221](../Intern/BEFUNDE.md#e-221) etwa jeder fünfte Umlaut-Betreff von 40 bis 60 Zeichen) und anderer Programme, die so falten.

**Gerätenamen (Hinweis T5, Randfall).** Windows behandelt auch `CON.txt` und `NUL.tar.gz` als Gerät, und laut Microsoft auch `COM¹` bis `COM³` und `LPT¹` bis `LPT³`. Ein Betreff wie „Con. …“ ergibt `Con. ….eml`. Ob Windows 10 den ablehnt, habe ich nicht gemessen. Nach Gregors Entscheidung vom 04.11. ist das ein Randfall.

**Aufrufer (belegt).** In der Postfachliste stammt der Kopf nur bei genau einer Nachricht aus der Aufbereitung von [E-128](../Intern/BEFUNDE.md#e-128) (`tocview.cpp:3077-3133`). Diese Nachricht ist dieselbe wie `pSumE220`, solange sie einen Betreff hat. Hat sie keinen, ist `pSumE220` NULL und das Feld bleibt leer. `szName` ist jetzt vorbelegt (:3033). Im Nachrichtenfenster ist `GetFullMessage()` NULL-fest (`E220DateinameVorschlag` prüft `pszVoll`).

## 6. E-221

**Senden (belegt, `sendmail.cpp:1293-1297`).** Die Grenze `>` passt jetzt zur Prüfung beim Zusammenfassen (:1258). Hinter der Prüfung kann noch ein Leerzeichen vorn (:1309-1315) oder hinten (:1321-1322) dazukommen. Daher die längsten Zeilen von 73 bis 75 Zeichen im Test, das bleibt unter 78.

**Empfang (belegt, `summary.cpp:2291-2299`).** Eine Folgezeile wird nur gelesen, solange `m_Subject` leer ist. `bInSubject` wird von jeder Zeile ohne führenden Leerraum zurückgesetzt (:2257-2259). Das Lesen hinter dem Zeilenende bei Folgezeilen unter 8 Zeichen ist damit auch weg.

**Dieselbe Stelle bei IMAP (belegt, K5, [E-233](../Intern/BEFUNDE.md#e-233)).** `CImapDownloader::ParseMinimalHeaderInMemory` (ImapDownload.cpp:2354-2365) und `ParseHeaderInMemory` (:2725-2736) bekommen die **ganze** Kopfzeile samt Folgezeilen in `Buffer` (:2635-2676). Sie schneiden beim ersten `\r\n` ab und nehmen `Buffer + 8`. `ImapFix2047` entfernt eine Faltung nur zwischen zwei kodierten Wörtern (ImapLex822.cpp:775-790), nicht die direkt hinter `Subject:`. Bei `Subject:` mit Zeilenumbruch bleibt so `"Subject:"` übrig, und der Betreff ist **leer**. Das trifft neue IMAP-Mails, deren Kopf zuerst allein geholt wird (:1751, :1950). Ob ein späteres volles Laden den Betreff wieder setzt, habe ich nicht verfolgt (Vermutung: über `SetSummaryInfoFromHD`, :943). `befund-suchen.pl` auf beide Funktionsnamen: kein bestehender Befund.

## 7. Zusammenführen

Gemessen in meinem Baum:

- Testsuite gebaut und gefahren: **421 Tests, 421 bestanden**.
- Alle `Test*.cpp` und `UnderTest*.cpp` stehen in `Tests.vcxproj`. Jede `Run…Tests` wird in `TestMain.cpp` genau einmal aufgerufen.
- In `pruefstand-faelle.txt` stehen die neuen Fälle [`E-192`](../Intern/BEFUNDE.md#e-192), `E-193w`, `E-220p` und `E-221p`, und keine Fallkennung kommt doppelt vor.
- `Extract.ps1`: die Regionen L4 (`msgutils_e220.inc`), Y und Y2 stoßen nicht zusammen. `UnderTestE221.cpp` kapselt sie in einem eigenen Namensraum.
- Bytes (gemessen gegen `c856b0e`): In allen geänderten Quelldateien ist die Zahl der CRLF gleich geblieben, die Zahl der Bytes ab 0x80 auch. Keine neue Zeile enthält UTF-8.
- `TestE128` erwartet den neuen Aufruf `SA.Start(szNameE220, …, TRUE)`, so passen [E-128](../Intern/BEFUNDE.md#e-128) und [E-220](../Intern/BEFUNDE.md#e-220) zusammen.

## 8. Gegenproben am Test E-193

Gemessen. Die Quelle habe ich vorübergehend mit Perl `:raw` geändert, je Probe genau ein Treffer. Danach habe ich sie aus der Sicherung im Scratchpad zurückgeholt und mit `cmp` als byte-gleich geprüft. `git status` war danach leer. Der Test liest die Quelle zur Laufzeit, ein neuer Bau war deshalb nicht nötig.

| Probe | Ergebnis | Erwartung |
|---|---|---|
| G1: `&& !bE193Weiter` aus dem Abbruch (:1031) gestrichen | 1 rot | rot, passt |
| G2: Öffnen bei Umlaut (:926) zu `if (false)` | 1 rot | rot, passt |
| G3: `E193TextMitUmlaut` mit `> 0x80` statt `>= 0x80` (das €-Zeichen fiele heraus) | **421/421 grün** | rot, siehe K4 |
| G4: `E193TextMitUmlaut` ohne `(unsigned char)` (vorzeichenbehaftet, nie wahr) | **421/421 grün** | rot, siehe K4 |
| G5: dasselbe in `SearchView.cpp` | 1 rot | rot, passt |
| G6: `return false` nach der X1-Abfrage gestrichen | **421/421 grün** | rot, siehe K4 |
| G7: `&euro;` mit `ul == 6` statt `5` | **421/421 grün** | rot, siehe K4 |

## Funde

### <a id="k1"></a>K1 (wichtig, am Quelltext belegt, Folge vermutet; E-232): Eine Umlaut-Suche in einem IMAP-Postfach geht an den Server, ohne Zeichensatz

- **Wo:** Weiche `SearchView.cpp:2635-2652`, Server-Suche `SearchEngine.cpp:819-829` und :1045-1055, ohne `CHARSET` in `ImapConnection.cpp:2764`, Text ohne Umwandlung aus `searchutil.cpp:569` und :832, Anführungszeichen statt Literal in `proto.cpp:2794`.
- **Folge:** *Find Messages* mit Umlaut auf einem IMAP-Postfach liefert vermutlich keinen Treffer oder einen Fehler des Servers. Bisher suchte der Index in der lokalen Kopie und fand ganze Wörter mit Umlaut richtig ([E-193](../Intern/BEFUNDE.md#e-193): 8 von 11).
- **Ursache:** Im Originalweg ohne Index war das schon so. Neu ist, dass [E-193](../Intern/BEFUNDE.md#e-193) jede Umlaut-Suche auf diesen Weg schickt.
- **Vorschlag:** Erst an einem IMAP-Prüfserver messen: Suchbegriff mit Umlaut, eine IMAP-Mail mit dem Wort, Treffer mit Index gegen ohne Index. Rechnet sich die Vermutung nach, gibt es zwei Wege. (a) Die Weiche lässt Suchen, die ein IMAP-Postfach enthalten, beim Index. (b) Bei Umlaut wird die Server-Suche übersprungen und lokal gesucht, mit K2 als Preis. (c) Den Text als UTF-8 mit `CHARSET UTF-8` als Literal schicken, das ist größer. Entscheiden muss Gregor.

### <a id="k2"></a>K2 (mittel, belegt, Laufzeit vermutet): Die genaue Suche öffnet jede HTML-Mail, bei IMAP auch ungeholte

- **Wo:** `SearchEngine.cpp:926-927` mit :1031.
- **Folge:**
  - Bei einem Suchbegriff mit Umlaut öffnet und wandelt die Suche jede HTML-Mail in jedem gewählten Postfach. Das gilt auch, wo der Begriff roh vorkommt, und auch bei *From*, *To*, *Headers* und *Attachment names*, wo `Html2Text` gar nicht läuft (§2).
  - Bei lokaler IMAP-Suche lädt `GetFullMessage` ungeholte Mails vom Server (§3).
  - Die Laufzeit an einem großen Postfach ist nicht gemessen.
- **Vorschlag:**
  - :926 auf `CRITERIA_OBJECT_BODY` und `CRITERIA_OBJECT_ANYWHERE` beschränken.
  - Bei IMAP `pSum->IsNotIMAPDownloadedAtAll()` ausnehmen, wie in [PRUEFER-90](PRUEFER-90.md) K2.
  - Für die Messung eine Logzeile am Ende von `Start` mit `nOpenedMsgs`, `nHTMLMsgs` und der Zeit. Die Zähler gibt es schon, aber nur unter `_DEBUG` (:1114-1123). Gregors Test liefert dann eine Zahl statt eines Eindrucks.

### <a id="k3"></a>K3 (gering, belegt): Eine lange Suche ohne Treffer lässt sich nicht abbrechen

- **Wo:** In der Schleife über die Zusammenfassungen (`SearchEngine.cpp:842-1035`) fragt nichts nach Esc. `CSearchView::ProcessResults` prüft Esc nur bei Treffern (`SearchView.cpp:2688-2705`).
- **Folge:** Das ist Originalbestand. Mit K2 dauert diese Schleife aber jetzt lange, wo sie vorher kurz war.
- **Vorschlag:** In der Schleife alle paar hundert Mails `::EscapePressed(1)` abfragen, wie es :812 schon tut.

### <a id="k4"></a>K4 (gering, gemessen): Der Test E-193 sieht drei Rückfälle nicht

- **Wo:** `Tests/TestE193.cpp`.
- **Folge:**
  - Ohne `(unsigned char)` in `E193TextMitUmlaut` (G4) ist der ganze neue Weg tot, und der Test bleibt grün. Das ist genau die Fehlerart, die [E-220](../Intern/BEFUNDE.md#e-220) als Originalfehler von QUALCOMM fand.
  - Ebenso unbemerkt bleiben `> 0x80` (G3, das €-Zeichen fiele heraus), der fehlende Ausstieg für die X1-Abfrage (G6) und eine falsche Länge bei `&euro;` (G7).
- **Vorschlag:**
  - Die Prüfung `(unsigned char) text[i] >= 0x80` auch im Abschnitt von `E193TextMitUmlaut` verlangen.
  - In `E193BrauchtGenaueSuche` die Folge `MATCHESX1QUERY)) return false;` verlangen.
  - Bei `&euro;` `ul == 5` mitprüfen.
  - Besser wäre, `E193TextMitUmlaut` und `E193BrauchtGenaueSuche` als Funktion zu prüfen. Daran hängt aber `SearchCriteria` (Vermutung, nicht versucht).

### <a id="k5"></a>K5 (wichtig, am Quelltext belegt, nicht gemessen; E-233): Bei IMAP liest Eudora einen Betreff mit Faltung hinter dem Doppelpunkt als leer

- **Wo:** `ImapDownload.cpp:2354-2365` (`ParseMinimalHeaderInMemory`) und :2725-2736 (`ParseHeaderInMemory`).
- **Folge:** Eine IMAP-Mail mit `Subject:` und gleich dem Zeilenumbruch steht in der Liste vermutlich ohne Betreff. Solche Mails schickten Eudora-Fassungen bis 7.2.2.132 bei etwa jedem fünften Umlaut-Betreff mittlerer Länge, und so falten auch andere Programme ([E-221](../Intern/BEFUNDE.md#e-221)). Bei POP ist das jetzt behoben, bei IMAP nicht.
- **Vorschlag:** Am IMAP-Prüfserver nachstellen, mit der Prüfmail aus `messen-e221.ps1` (`Subject:` mit Umbruch). Dann vor dem Abschneiden bei `\r\n` den Leerraum samt Faltung hinter `Subject:` überspringen. Ließe sich auch als Fortsetzung von [E-221](../Intern/BEFUNDE.md#e-221) führen, der Ort ist aber ein anderer.

### <a id="k6"></a>K6 (gering, belegt): E-220 nimmt bei Faltung hinter dem Doppelpunkt nur 63 Zeichen

- **Wo:** `HeaderContents` (`msgutils.cpp:72-74`, :106-110) liefert den Betreff mit einem Leerzeichen vorn. Der Vergleich in `E220DateinameVorschlag` schlägt deshalb fehl.
- **Folge:** Der Vorschlag kommt aus den 63 Zeichen der Zusammenfassung. Die Umlaute bleiben erhalten, und der Name lässt sich speichern.
- **Vorschlag:** Vor dem `strncmp` führenden Leerraum von `pszKopf` überspringen.

## Hinweise (keine Funde)

- **T1 (belegt):** `bE193Weiter` geht `pList` durch, bevor geprüft wird, ob `pList` NULL ist (`SearchEngine.cpp:626-640`). `GetCriteriaList` gibt die Adresse eines Mitglieds zurück, das kann nie NULL sein. Schön ist es nicht.
- **T2 (belegt):** `GetCurVerbTextCmp` und `GetCurValueText` haben ein `ASSERT` (`SearchCriteria.cpp:265`, :345). `E193BrauchtGenaueSuche` und die Schleife für `bE193Weiter` rufen sie für **jedes** Kriterium auf, auch für *Label* oder *Status*. Im Debug-Bau meldet sich dann ein ASSERT. Im Release-Bau bleibt das ohne Folgen.
- **T3 (belegt):** Auf dem genauen Weg gilt *Find deleted IMAP messages* nicht. Der Schalter wird nur an `SearchManager::DoSearch` gegeben (`SearchView.cpp:2647-2648`). Das war mit ausgeschaltetem Index schon immer so.
- **T4 (belegt):** [E-192](../Intern/BEFUNDE.md#e-192) übernimmt die bekannte Grenze aus [PRUEFER-78](PRUEFER-78.md#pruefer-78) K2 (§4). Der Befund nennt sie.
- **T5 (Vermutung):** Gerätenamen mit Punkt (`Con. …`) und `COM¹` bis `COM³`, siehe §5. Randfall.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Umlaut-Suche in IMAP-Postfach geht ohne Zeichensatz an den Server und findet vermutlich nichts (vorher Index, lokal); E-232 | wichtig | nein für das Testpaket; vor dem Release an IMAP messen |
| [K2](#k2) | genaue Suche öffnet jede HTML-Mail, auch bei Kriterien ohne `Html2Text`; bei IMAP lädt sie ungeholte Mails; Laufzeit an großem Postfach ungemessen | mittel | nein; Gregors Test an einem großen Postfach |
| [K3](#k3) | lange Suche ohne Treffer nicht mit Esc abzubrechen | gering | nein |
| [K4](#k4) | `TestE193` grün bei vorzeichenbehaftetem Vergleich, `> 0x80`, fehlendem X1-Ausstieg, falscher `&euro;`-Länge | gering | nein |
| [K5](#k5) | IMAP: Betreff mit Faltung hinter `Subject:` wird leer gelesen (wie [E-221](../Intern/BEFUNDE.md#e-221), anderer Ort); [E-233](../Intern/BEFUNDE.md#e-233) | wichtig | nein (Original, durch das Paket nicht berührt) |
| [K6](#k6) | [E-220](../Intern/BEFUNDE.md#e-220): bei Faltung hinter `Subject:` nur 63 Zeichen im Vorschlag | gering | nein |
| T1 | `pList` vor der NULL-Prüfung benutzt | – | nein |
| T2 | ASSERT im Debug-Bau bei Kriterien ohne Text | – | nein |
| T3 | *Find deleted IMAP messages* gilt auf dem genauen Weg nicht | – | nein |
| T4 | [E-192](../Intern/BEFUNDE.md#e-192) übernimmt [PRUEFER-78](PRUEFER-78.md#pruefer-78) K2 | – | nein |
| T5 | Gerätenamen mit Punkt, `COM¹` | – | nein |
