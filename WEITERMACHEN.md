# Hier weitermachen

**Stand 15.09.2026.** `main` ist gesperrt und wird nur von Gregor per
Merge bewegt; jeder Agent arbeitet in seinem eigenen Arbeitsbaum und Zweig
(siehe [AGENTEN.md](AGENTEN.md)).

| | |
|---|---|
| **Quellstand** | 7.2.0.64 (`Eudora71/Version.h`) |
| **Paketnummer** | 1.0.64 (`VERSION`) |
| **VON GREGOR ZU PRÜFEN, 15.09.2026 — E-95/E-96** | **die Bilder behalten ihre wirkliche Größe, und jedes bekommt seine eigene Zeilenhöhe.** Gebaut in 7.2.0.64 (**153/153 Tests**, drei davon umgeschrieben), **am laufenden Programm noch nicht bestätigt.** Prüfanleitung in [CHANGELOG.md](CHANGELOG.md), Abschnitt 7.2.0.64, *Zum Prüfen*: die Doctolib- und die FairToner-Nachricht **weiterleiten und beantworten**. **Was zu sehen sein muss: kein Bild ist abgeschnitten, keines auf 20×20 gequetscht, der Text bleibt frei.** Mit `LogLevel=58527` nennt die bleibende Spurmarke `E-95 Bild:` je Bild `attr`, `embed`, `ascent` und den Text-Ascent. **Im selben Lauf muss E-88 weiter tragen:** die Zeilen `E-88 vor dem Absenden` und `E-88 auf der Leitung` müssen `Fassung=ORIGINAL` sagen |
| **VON GREGOR ZU PRÜFEN, 14.09.2026** | **E-88 — die weitergeleitete Nachricht kommt an, wie sie gelesen wurde.** Gebaut in 7.2.0.56 (0 Fehler, 131/131 Tests), **am laufenden Programm noch nicht bestätigt.** Prüfanleitung in [CHANGELOG.md](CHANGELOG.md), Abschnitt 7.2.0.56, *Zum Prüfen*: `LogLevel=58527`, einen Newsletter einmal ohne und einmal mit Kommentar weiterleiten, dann im Protokoll nach `E-88` suchen. **Das Verfassenfenster sieht dabei weiterhin schlicht aus — das ist kein Fehler**, Paige kann kein CSS; es zählt allein, was beim Empfänger ankommt. Abschalten mit `ForwardOriginalHTML=0` in `[Settings]` |
| **Zuletzt gebaut und gepackt** | Paket **1.0.64** (Quellstand 7.2.0.64), unter `Releases/Eudora72-1.0.64-release`. **Auf GitHub veröffentlicht ist weiterhin `v1.0.50`**; **1.0.51 bis 1.0.64 sind nicht freigegeben**. Aus Gregors Lauf mit **1.0.58** am 14.09.2026 stammen **E-89**, **E-90** (offen), **E-91** (offen) und **E-92** (offen); **E-95** meldete er an 1.0.60, **E-96** ist am 15.09.2026 an einem selbst gestarteten Eudora mit drei Bildern bekannter Größe gemessen worden. Bei 1.0.51 zeigte sein Test den Fehler E-85 noch, ab 1.0.52 ist E-85 behoben und belegt |
| **Zuletzt von Gregor bestätigt** | **1.0.50 am 11.09.2026**: **E-84**, die Größe eines losgerissenen Fensters überlebt den Neustart — belegt an beiden Enden (`FloatCx319=751` in der `Eudora.ini`, `E-76 fest: vorher=751x403` beim ersten Aufruf danach). Davor an 1.0.49 **E-76** (*„e-76: paßt: läßt sich jetzt vergrößern."*), an 1.0.48 **E-82** (verschärfte Zertifikatsprüfung — IMAP läuft unverändert, `Successfully retrieved markus.bakus@gmx.de` über Port 993), an 1.0.47 **E-81** (*„ja, paßt!"*, Kopfzeilen auf dunklem Grund lesbar), an 1.0.46 **E-80** (*„ja, jetzt geht es"*, der Knopf *Blah Blah Blah* schaltet wieder) und an 1.0.44 **E-79** (Spaltenbreite im Filterfenster) |
| **ERLEDIGT — Fassungsgeschichte, kein offener Punkt** (Stand vom 13.09.2026 abends, **berichtigt am 15.09.2026**: E-85 ist seit **7.2.0.52** behoben und am laufenden Programm belegt) | **E-85 ist NICHT behoben.** Der Fix vom Nachmittag reparierte den Suchbereich (`FindMIMECharset` statt `FindRStringIndexI` bis `IDS_MIME_ISO_LATIN9`), durchsucht aber die **falsche Quelle**: `ImapDownload.cpp` liest den Zeichensatz aus `m_pHd->m_TLMime` — **TL heißt Top Level**. Bei `multipart/alternative`, also jedem HTML-Newsletter, steht im Top-Level-Header **kein `charset`**, nur `boundary`; der Zeichensatz des Teils steckt in `BODY->parameter` (`Imapdll/public/inc/exports.h:147`) und wird nie ausgelesen. **Belegt durch Gregors frisch abgerufene Mail:** Betreff richtig (anderer Weg, `Fix2047`), Rumpf falsch. Bei `text/plain` ohne multipart wirkt der Fix, bei Newslettern nicht. **Zu tun:** den Zeichensatz aus dem aktuellen Teil nehmen — dort, wo schon `m_CurrentBodyType` und `m_szCurrentBodySubtype` gesetzt werden (`ImapDownload.cpp:2798, 3034, 3283`), den Top-Level nur als Rückfall. Dazu die Spurmarke, die **beide** Zeichensätze in **einer** Zeile nennt |
| **Wichtig beim Prüfen von E-85** | **Eine schon abgerufene Nachricht bleibt kaputt.** Die Übersetzung passiert beim **Abruf** und landet in der Mailboxdatei; die Anzeige liest nur, was dort steht. `IsIMAPMessageBodyDownloaded()` verhindert außerdem, dass Eudora den Rumpf von selbst erneut holt. Es muss also eine **neue** Nachricht sein. Und: die Testmail aus `tools/testmail-bauen.pl` wurde von `mx.freenet.de` mit **`550 Spam message rejected`** abgelehnt — 900 fast gleiche Zeilen mit Preisangaben und Emoji sehen für jeden Spamfilter wie Werbung aus. Wer sie wieder braucht, baut sie **unauffällig**: kurzer Text, die kritischen Zeichen gezielt platziert statt in Masse |
| **ERLEDIGT — Fassungsgeschichte, kein offener Punkt** (Stand vom 11.09.2026, **berichtigt am 15.09.2026**: der hängende Resync ist **E-83** und seit **7.2.0.53** behoben, am laufenden Programm gemessen) | **Der hängende Resync.** Gregor am 11.09.2026 an 1.0.48: eine IMAP-Aufgabe bleibt auf *„Waiting in the task queue to be started …"* stehen und wird nie gestartet; beim Beenden warnt Eudora *„You currently have 1 task(s) running"*. **Nicht** die Zertifikatsprüfung — im selben Lauf stand die Verbindung und eine Mail kam an. Drei Ursachen sind am Quelltext ausgeschlossen (siehe `CHANGELOG.md`, *Noch offen*); der offene Verdacht ist `StartWorkerThread`, das bei `m_pThread == NULL` **nichts** tut — kein Start, kein Fehler, keine Meldung (`QCTaskManager.cpp:406-410`). Zu belegen mit einer Spurmarke, die Zustand, `m_pThread`, aktive Aufgaben und Obergrenze in **einer** Zeile nennt |
| **Offen, zurückgestellt** | **E-71** (Filterbericht bleibt leer) — von Gregor am 10.09.2026 ausdrücklich auf die nächste Fassung geschoben: *„kann aber als ToDo für die nächste version aufgeschrieben werden"*. **Nicht von selbst aufgreifen.** Belegt ist, dass der Lauf trifft; zu messen ist `CFilterActions::EndFiltering` |
| **Offen, mit Marken im Bau** | **E-78** (Marke seit 1.0.43 in `mainfrm.cpp`; in `Befunde/SPURMARKEN.md` als `entfaellt` geführt, weil 1.0.43 bei Gregor nur mit `LogLevel=25759` lief, bei dem sie schweigt). **E-69** (die drei Abbruchstellen in `CFiltersDoc::FilterMsg` protokollieren jetzt, statt nur zu assertieren). **E-68** (`copyInstead` schreibt/liest asymmetrisch, `CFiltersDoc::Read` prüft `NUM_FILT_ACTS` nicht — PRÜFER rechnet nach). **E-47** (MFC71/MSVCP71) |
| **Aufräumen, sobald die Befunde sitzen** | Die Spurmarken **E-64**, **E-66**, **E-70**, **E-72**, **E-73**, **E-76** und die neuen **E-44** schreiben je Nachricht, Filter oder Anordnungsdurchlauf eine Protokollzeile. E-64, E-70, E-72, E-73 und **E-76** sind bestätigt und dürfen raus — E-76 hat mit 1.0.49 geliefert und mit 1.0.50 ein zweites Mal (der Beleg zu E-84 stammt aus dieser Marke) |
| **Von Gregor am 11.09.2026 bestellt** | **1.** die Sache mit den **Zertifikaten** erklaeren, die zurueckgestellt wurde — `tools/patches/zertifikatspruefung-verschaerfen.patch` samt Begruendung daneben, dazu der Wurzelzertifikatsspeicher von 2004 (`rootcerts.p7b`, 17 von 30 Zertifikaten im August 2026 abgelaufen) und der fehlende Namensabgleich (nur CN, keine SAN, kein SNI). Fundstellen in `PORTIERUNG.md:435-470`. **2.** die **ToDo-Liste** durchsehen: was ist noch offen, was davon lohnt als Naechstes |
| **Als Nächstes, mit Gregor abgesprochen** | **1. E-85 — Umlaute in per IMAP abgerufenen Nachrichten: behoben in 7.2.0.52, am laufenden Programm belegt.** Von ihm am 13.09.2026 gemeldet und der Vorschlag angenommen (*„e-85 vorschlag akzeptiert"*), Zweig **`fix-imap_utf8`** angelegt und gefüllt; Befundeintrag steht unter **E-85** in `BEFUNDE.md`. **Es waren vier Mängel, nicht drei, und der entscheidende kam zuletzt:** 7.2.0.51 reparierte den **Suchbereich** (`FindMIMECharset` statt einer Suche, die vor `IDS_MIME_UTF_8` endet), den verworfenen Rückgabewert von `ISOTranslate` und den fehlenden Übertrag über die Stückgrenze (`ISOTranslateChunk`, `utils.cpp:1269`) — durchsuchte aber weiter die **falsche Quelle**. `CImapDownloader::Write` las den Zeichensatz aus `m_pHd->m_TLMime`, dem **Top-Level**-Kopf; bei `multipart/alternative`, also jedem HTML-Newsletter, steht dort kein `charset`. **7.2.0.52** holt ihn aus dem MIME-Teil (`m_szCurrentCharset`, gesetzt an denselben drei Stellen wie `m_CurrentBodyType`: `ImapDownload.cpp:2837, 3074, 3324`), der Nachrichtenkopf bleibt Rückfall. **Belegt im Protokoll von Gregors Lauf:** `teil-charset=utf-8 tl-charset=(keiner) idx=4 uebersetzt=ja`, und null unübersetzte UTF-8-Folgen in der Mailboxdatei. **Eine Regression kam durch die Behebung selbst hinzu und ist mitbehoben:** `ISOTranslate` schreibt die abschließende Null an `szBuf[lSize]` (`utils.cpp:1480`), ein Byte hinter den Bereich; der POP3-Weg hält dafür Platz frei, der IMAP-Weg nicht, sodass bei `text/plain; charset=utf-8` das **erste Byte der nächsten Zeile** getroffen wurde. Von **PRUEFER** am 13.09.2026 gefunden (`Befunde/PRUEFER-10.md`) und in `ISOTranslateChunk` geschlossen, indem das Byte hinter dem Stück gerettet und zurückgeschrieben wird (`utils.cpp:1308-1310` und `:1393-1395`). **2. QCSSL in `Releases/1.0/` hinkt.** Dort liegt `QCSSL 1.0.1` vom 30.08.2026, also **ohne** den E-82-Zertifikatsfix vom 11.09.2026; `tools/release-pruefen.pl` weist deshalb ab. Betroffen ist **nur** diese Nebenablage für 7.1-Anwender („zwei Dateien austauschen") — die Pakete selbst enthalten die richtige DLL. Zu tun: Kennung in `Eudora71/QCSSL/src/qcssl.rc:14-15` auf 1.0.2, QCSSL neu bauen, `Releases/1.0/QCSSL.dll` und `.sha256` ersetzen, Zeile in `Releases/1.0/AUSLIEFERUNGEN.md`. **Reihenfolge noch offen** — Gregor gefragt, vor dem Herunterfahren nicht mehr beantwortet |
| **Was ich dabei nicht selbst messen kann** | das Ziehen mit der Maus. `Splitter::Track` bricht ab, sobald die **physische** Maustaste los ist (**E-51**). Alles andere lässt sich seit Gregors Freigabe vom 10.09.2026 (*„du kannst ja jetzt lokal ausführen, ich greife nicht rein"*) über `tools/testlauf.ps1` und `tools/leisten-messen.ps1` selbst messen — genau so ist der zweite Teil von E-70 gefunden worden |

> **Die Fassungsgeschichte mit allen Messungen steht in
> [CHANGELOG.md](CHANGELOG.md)** — dort auch die Prüfanleitung zum aktuellen
> Paket und der Abschnitt *Wo man weitermachen kann* mit den offenen Enden und
> Fundstellen. Diese Datei hier ist nur der Einstieg.

## Das Ziel, an dem alles hängt

**Neun Kriterien: sieben sind belegt (0, 1, 3, 5, 6, 7, 8), zwei sind fast
erfüllt (2, 4).** Die Tabelle dazu steht in [ZIEL.md](ZIEL.md) und ist die
Quelle. Gregor hat am 06.09.2026 die zweite Stufe gesetzt, Kriterien **4 bis
6**; **7** ist am 07.09.2026 aus seinem Urteil zu Paket 1.0.18 nachgetragen,
**8** noch am selben Tag aus seinem Wunsch nach sichtbaren offenen Fenstern.

| # | | Stand |
|---|---|---|
| 4 | **Keine Abstürze** | fast — fünfmal Strg-N ohne Absturz gemessen; das Beenden ist erledigt, und mit **E-43** sind **E-37** und **E-38** weggefallen. Offen bleibt die Meldung beim Anzeigen mancher Nachrichten |
| 5 | **Eine neue Mail schreiben und abschicken** | **erfüllt** (07.09.2026, von Gregor bestätigt) |
| 6 | **Eine Mail weiterleiten** | **erfüllt** (07.09.2026, von Gregor bestätigt) |
| 7 | ***File → Exit*** beendet Eudora sauber | **erfüllt** (08.09.2026, von Gregor bestätigt) — *„schließen klappt jetzt."* Alle drei Wege: Menü, Alt-F4, Kreuz |
| 8 | Offene Fenster sichtbar und auswählbar | **erfüllt** (09.09.2026, von Gregor bestätigt) — Menü *Window* und die Registerkartenleiste unten; der Klick holt das Fenster nach vorn (**A-3** / **E-48**) |

**Beiden noch nicht erfüllten Kriterien fehlt dasselbe:** die Meldung
„Encountered an improper argument" beim **Anzeigen** mancher Nachrichten. Sie
ist der letzte bekannte Fehler, den ein Anwender merkt — und **neu zu messen**,
seit **E-43** die Fehlerklasse an der Wurzel behoben hat.

**Dazu vier Anforderungen, die kein Kriterium sind**, alle in
[ZIEL.md](ZIEL.md) aufgeschrieben: **A-1** (Vorgaben für ein neu angelegtes
Konto), **A-2** (*Task Status* und *Task Errors* waagrecht unten) und **A-3**
(offene Fenster als Registerkarten) sind umgesetzt und **von Gregor
bestätigt**; **A-4** (den linken Bereich breiter ziehen) ist **gebaut und
nicht bestätigt**.

## Was seit dem 06.09.2026 anders ist

**E-31 ist behoben — das war die Wurzel.** Strg-N und *Weiterleiten* beendeten
Eudora mit `0xC00000FD STATUS_STACK_OVERFLOW` in `Paige32.dll`
(`pgInstallFont`, 525 Windungen tief); deshalb entstand auch nie ein
`Exception.log` — ein voller Stapel lässt keinen Platz mehr für den
Absturzbehandler. Die Ursache war eine Zeile in
`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`: `pg_time_t` erbte seine Breite von
`time_t`, und das ist unter VS2022 **acht** Byte breit statt der vier, mit denen
die ausgelieferte DLL von 2005 rechnet. Damit war **jede** Struktur verschoben,
die Eudora an Paige reichte — und in dieser Portierung entstand bis dahin
**kein einziges Paige-Fenster**. Seither läuft der Fensterbau vollständig durch
(`OnMessageNewMessage: fertig`). Die Messung mit allen Feldversätzen steht in
[CHANGELOG.md](CHANGELOG.md) unter 7.2.0.21.

**Sieben Vermutungen sind auf diesem Weg widerlegt worden** — jede gebaut,
gestartet, gemessen. Sie stehen samt Messwerten in
[CHANGELOG.md](CHANGELOG.md) unter 7.2.0.21. **Nicht noch einmal
durchprobieren.**

**E-32: der Code-Mangel ist behoben, die Ursachenbehauptung ist widerlegt.**
`CHeaderView::OnKillFocusRecipient` in `Eudora71/Eudora/headervw.cpp`
dereferenzierte `pField` ungeprüft, obwohl die Abfrage drei Zeilen darüber
ausdrücklich mit NULL rechnet — das ist behoben (`060a4bf`) und bleibt richtig.
Dass **diese** Stelle die modale Meldung „An unhandled exception has occurred"
verursacht hätte, hat PRUEFER dreifach gemessen und **verworfen**
(`Befunde/PRUEFER-3.md`, Abschnitt 2): die Funktion läuft bei Strg-N gar nicht,
das Herausnehmen der Behebung bringt die Meldung nicht zurück, und im Paket
1.0.18 tritt sie über denselben Weg nicht auf. Aufgeklärt hat die Meldung erst
**E-34** — eine MFC-Ausnahme in `QCChildToolBar::GetButton`, die den ganzen
Fensterbau abwickelte (`CHANGELOG.md` unter 7.2.0.20 und 7.2.0.21).

## Der nächste Schritt

**Der nächste Schritt gehört Gregor: vierzehn gebaute Behebungen warten auf
sein Urteil** — am 13.09.2026 über alle Urteilszeilen in `BEFUNDE.md` gezählt.
Sie stecken alle im aktuellen Paket **1.0.50**; die Fassungsnummern unten sagen
nur, wann sie entstanden sind. Alles Weitere steht ausführlich in [AUFGABEN.md](AUFGABEN.md) unter
*Die Hauptarbeit*; hier die Reihenfolge in einem Satz je Punkt.

1. **A-4 / E-49, E-52, E-54 und E-55 prüfen** (gebaut in 7.2.0.26 bis
   7.2.0.29, enthalten in 1.0.50) — den linken Bereich am
   Trennbalken nach rechts ziehen, über 180 Pixel hinaus, und **gleich noch
   einmal** ziehen. Bleibt der Balken greifbar? Stehen die Registerkarten
   danach einfach da, nicht doppelt? Überlebt die Breite einen Neustart?
   **Und vor allem: friert nichts ein** (**E-51**)? Die fünf Prüfschritte
   stehen in [ZIEL.md](ZIEL.md) unter A-4.
2. **E-50 prüfen** (gebaut in 7.2.0.26, enthalten in 1.0.50) — die drei Mängel
   an der Registerkartenleiste:
   bleibt eine Karte eingedrückt, wenn ein anderes Fenster aktiv ist; stimmt
   die Darstellung beim Skalieren; bleiben die Karten beim Öffnen und Schließen
   stehen. Alle drei hatten dieselbe Wurzel — der Streifen wurde nur beim
   Neuzeichnen gemalt, und niemand erklärte ihn für ungültig.
3. **Die Meldung „Encountered an improper argument" beim Anzeigen neu messen.**
   Das ist der letzte bekannte Fehler, den ein Anwender merkt, und der einzige
   Grund, warum Kriterium 2 und Kriterium 4 nicht *erfüllt* heißen. **Seit
   E-43** ist die Fehlerklasse dahinter an der Wurzel behoben — gut möglich,
   dass die Meldung mit verschwunden ist. **Erst messen, dann suchen.**
4. **Der Nebenbefund ohne Nummer: die Fenster stehen nach einem Neustart nicht
   im Vollbild**, obwohl sie beim Beenden so waren (Gregor am 09.09.2026 an
   1.0.25). Das ist der Fensterzustand über `CMainFrame::SaveOpenWindows`,
   **nicht** die Kartenleiste. Erster Handgriff ohne Bau: nach einem normalen
   Beenden in der `Eudora.ini` nachsehen, ob der Maximiert-Zustand dort steht.
5. **E-39** — wird die aktuell benutzte Persönlichkeit gelöscht, kann ihr
   INI-Abschnitt teilweise wiederentstehen. `CPersonality::Remove`
   (`persona.cpp:565-566`) stellt die aktuelle Persönlichkeit nicht um.
   Naheliegend: nach erfolgreichem `Remove` auf `<Dominant>` umschalten.
6. **E-47** — der Fehlerdialog des Verzeichnisdienstes. Ursache belegt
   (`MFC71.DLL` und `MSVCP71.dll` fehlen und wird es immer), **keine Behebung
   in Sicht**; betrifft Adressbuch, LDAP, Ph und S/MIME, nicht den Start.

> **Was nicht mehr zu suchen ist.** Das Beenden ist entschieden: E-40 (eine
> Rückfrage, die sich nicht öffnen lässt, galt als Abbrechen), E-41 (Alt-F4 und
> das Kreuz laufen durch ein `ENSURE_VALID`, das *File → Exit* nicht hat) und
> E-42 (zwölf Aufräumschritte konnten den Ablauf abbrechen), dazu E-45 (der
> eine Schritt, der **nicht** übersprungen werden darf). Der Weg dorthin steht
> in [Befunde/BEENDEN.md](Befunde/BEENDEN.md), das Review in
> [Befunde/PRUEFER-5.md](Befunde/PRUEFER-5.md). **Nicht wieder von vorn
> aufrollen.**
>
> **Ebenso entschieden ist E-43** — `SECControlBar` war **zweimal definiert**
> (`OT501/Include/sbarcore.h` und `OTShim/OTShim.h`, der Ersatz mit einem Feld
> mehr), und zwei Übersetzungseinheiten lasen dasselbe Feld acht Byte
> auseinander. Gemessen vorher `GetBtnCount=24/24 m_btns.GetSize=0/0`, nachher
> `24/24` gegen `24/24`. Die `Eudora.ini` enthält seither **13**
> `[ToolBar…]`-Abschnitte statt **0**. Damit fielen **E-37** und **E-38** mit
> weg, und **E-46** (freigegebenes `CMainFrame`-Objekt) ist **widerlegt**.
> Schranke: `tools/pruefe-waechter.pl`.

## Alles Offene auf einen Blick

Diese Tabelle wird aus `BEFUNDE.md` **erzeugt** — `tools/offene-befunde.pl`
setzt sie und weist im pre-commit ab, wenn ein Befund fehlt oder einer
darinsteht, der längst behoben ist. Von Hand eintragen lohnt nicht; der
nächste Lauf überschreibt es.

**Keiner dieser Punkte ist Gregor zugewiesen.** Was von ihm kommt, sind
Beobachtungen, die nur auffallen, wenn sie eintreten — siehe *Was ich dabei
nicht selbst messen kann*.

<!-- offene-befunde: Anfang -->

| Kennung | worum es geht |
|---|---|
| **E-94** | die Betreffzeile wird mitten im Wort umbrochen — Toner bestel len, Wochenend e!, und in … |
| **E-92** | der Weiterleitungskopf ist bei Thunderbird eine ausgerichtete kleine Tabelle — auf Grego… |
| **E-90** | Emoji in Betreffzeilen erscheinen als ? — Gregors Thunderbird-Vergleich vom 14.09.2026 z… |
| **E-78** | die Standardanordnung der Leisten wird bei jedem Start nachgezogen, obwohl der Zustand ges… |
| **E-77** | IMAP-Postfachnamen mit Umlauten werden roh angezeigt — Entw&APw-rfe statt *Entwürfe*, G… |
| **E-71** | der Filterbericht ist nach einem Filterlauf leer |
| **E-69** | CFiltersDoc::FilterMsg bricht den Filterlauf im Freigabebau lautlos ab und meldet Erfolg |
| **E-67** | ein Filter *„«Junk Score» is less than N"* wird durch bloßes Anschauen im Filterfenst… |
| **E-47** | beim Öffnen der Kurznamen-/Verzeichnisdienst-Leiste kommt der Fehlerdialog *„Directory … |
| **E-39** | wird die aktuell benutzte Persönlichkeit gelöscht, kann ihr INI-Abschnitt teilweise wied… |
| **E-14** | Zusicherung beim Start: der X1-Suchindex wird neu angelegt (SearchManager::Info::InitX1) |

<!-- offene-befunde: Ende -->

Wofür jeder steht und was als Nächstes zu messen ist, steht in
[BEFUNDE.md](BEFUNDE.md) und in [CHANGELOG.md](CHANGELOG.md) unter
*Noch offen*.

## Ebenfalls offen

- **`ReleaseBuffer` ohne `GetBuffer`** — Fehlerklasse **R-1**, **16** Stellen
  bleiben (gemessen am 07.09.2026 mit `perl tools/releasebuffer-pruefen.pl`).
  Die Reihenfolge steht in [AUFGABEN.md](AUFGABEN.md) unter A2, nach
  Häufigkeit des Wegs sortiert.
- **Neun Zeigerstellen** aus X-3 ([AUFGABEN.md](AUFGABEN.md), D3a).
- **E-14** — die Zusicherung beim Start, der X1-Suchindex werde neu angelegt.
  Auf einem frischen Mailverzeichnis ist das der normale erste Lauf; ein
  echter Befund wird es erst, wenn die Meldung auch beim **zweiten** Start
  kommt.
- **E-13** — beim Mailabruf ist kein Fortschritt sichtbar. Die Behebung liegt
  auf `wt/fortschritt-arbeit`, **nicht** in diesem Zweig.
- **`EuMemMgr.dll` ist kein Projekt der Projektmappe** — vorgebaut, 2005,
  Version 7.0.0.9. Ausgerechnet sie löst den Aufrufstapel im Absturzbericht auf.
- **Die Hostnamenprüfung greift nicht** (sicherheitsrelevant, in
  `PORTIERUNG.md` beschrieben) — von Gregor ausdrücklich **zurückgestellt**,
  siehe [AUFGABEN.md](AUFGABEN.md) am Ende.

## Wie man misst

Alles, was man dafür braucht, steht bereit — es muss niemand danebensitzen.

**Protokollierung einschalten.** In `Mailverzeichnis\Eudora.ini` unter
`[Settings]`:

```
LogLevel=32896
```

Ohne diese Zeile schreibt Eudora nichts: `PutDebugLog` prüft die Maske und kehrt
sonst sofort zurück (`QCUtils/src/debug.cpp:140`). 32896 = `DEBUG_MASK_MISC`
(0x8000) + `DEBUG_MASK_TOC_CORRUPT` (0x80). Danach stehen die Spurmarken mit
`E-27` in `Mailverzeichnis\eudora.log`.

**Absturzbericht auswerten:**

```bash
perl tools/absturz-auswerten.pl
```

Findet `Exception.log` und `Eudora.map` selbst und macht aus jeder Stapelzeile
einen Funktionsnamen. Bei Berichten vor 7.2.0.13 sagt es, dass es nicht geht,
statt zu raten.

**Unter dem Debugger laufen lassen** — muss die **32-Bit**-PowerShell sein:

```
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File tools\stapel-untersuchen.ps1 -Exe <Paket>\Eudora.exe -Argumente "<Mailverzeichnis>"
```

Er fängt die tödliche Ausnahme ab und **tastet den Stapel ab** — die EBP-Kette
taugt bei Paige nichts, die DLL ist ohne Rahmenzeiger übersetzt.

**Eudora ohne Maus bedienen.** Meldungsfenster der Klasse `#32770` mit
`SendMessage(h, WM_COMMAND=0x0111, IDOK=1, 0)` schließen, dann
`PostMessage(hauptfenster, 0x0111, 32797, 0)` an die Fensterklasse
`EudoraMainWindow` für *Neue Nachricht* (`ID_MESSAGE_FORWARD` ist 32799).
Fensterliste über `EnumWindows` + `GetWindowThreadProcessId`; bei
`GetClassName`/`GetWindowText` unbedingt `CharSet=CharSet.Unicode`.

## Bauen und packen

```powershell
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Release
```

Meldet Erfolg nur, wenn vier unabhängige Prüfungen zustimmen. **MSBuild kann 0
zurückgeben und trotzdem nichts gebaut haben.**

Paket schnüren und prüfen:

```powershell
powershell -ExecutionPolicy Bypass -File tools\paket-bauen.ps1 -Ziel <Verzeichnis> -Zip Releases\Eudora72-1.0.x-release.zip -AusBauverzeichnis -Bauart Release
powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket <Verzeichnis>
```

**Eine Nummer je Bau.** Vor dem Packen `Eudora71/Version.h` und `VERSION`
hochsetzen und committen — sonst trägt die Bau-Kennung ein Sternchen und der
Bau ist nicht reproduzierbar.

## Nach einem frischen Klon

```bash
sh tools/hooks-einrichten.sh
```

Das war es. Zeilenenden sind seit `.gitattributes` (`* -text`) kein Thema mehr —
nachgemessen: ein frischer Auscheck mit erzwungenem `core.autocrlf=true` meldet
null geänderte Dateien.

## Wie hier gearbeitet wird

- [AGENTEN.md](AGENTEN.md) — Koordination paralleler Arbeit, aus fünf gemessenen
  Kollisionen
- [Arbeitsweise/](Arbeitsweise/) — die Lehren aus diesem Projekt, eine Datei je
  Lehre. **Vor dem Anfangen lesen**, besonders
  [mannschaft-fuehren.md](Arbeitsweise/mannschaft-fuehren.md): ein Auftrag ohne
  konkrete Beobachtung liefert nichts, und jeder Rücklauf wird selbst
  nachgemessen
- Die Quellen sind **Latin-1 mit gemischten Zeilenenden**. `tools/pruefe-bytes.pl`
  vor jedem Commit; das Edit-Werkzeug zerstört beides lautlos
