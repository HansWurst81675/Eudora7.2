# <a id="pruefer-90"></a>PRUEFER-90

Lauf nach [PRUEFER-89](PRUEFER-89.md). Zweig wt/pruefer-20261103, abgezweigt von `origin/e128_endung_aus_inhalt` (Stand c2402a4c). Geprüft wird `origin/main..HEAD -- Eudora71 tools Releases/1.0`: die Commits 23b31352 und c2402a4c ([E-128](../Intern/BEFUNDE.md#e-128), [E-213](../Intern/BEFUNDE.md#e-213)). Danach, nur lesend, die Einarbeitung von PRUEFER-89 auf `origin/e170_label_ohne_uidplus` (01f4c9cd). Auf Zuruf der Hauptsitzung vorgezogen: der Commit 3c6d988d auf `origin/e133_mailverzeichnis_fehlt` (Abschnitt *Zusatz: e133*). Eudora habe ich weder gebaut noch gestartet. Keinen Prüfstand habe ich angefasst.

## Ergebnis vorweg

Die Behebung von [E-128](../Intern/BEFUNDE.md#e-128) tut, was sie verspricht. Der Dialog *Speichern unter* schlägt jetzt eine Endung vor, die zum Inhalt passt, und belegt den Dateityp passend vor. Den Zeiger auf die Vorgabeendung behält MFC 14 nur, statt ihn zu kopieren. Die Behebung übergibt deshalb feste Texte, und das ist richtig. Nebenbei verschwinden damit zwei alte hängende Zeiger in der Postfachliste und im Verfassen-Fenster. Drei weitere solche Stellen bleiben (K6, neu E-214). Die Testsuite läuft mit 391/391. [E-213](../Intern/BEFUNDE.md#e-213) ist richtig gebaut: Ein Fehler im Messskript überspringt das Beenden nicht mehr.

Vier Dinge passen nicht ganz zum Eintrag. Die Postfachliste bietet neu *HTML Files (\*.htm)* an, schreibt aber nie reines HTML (K1). Vor dem Dialog lädt sie bei IMAP eine noch nicht geholte Nachricht vom Server. Das geschieht auch, wenn man danach abbricht, und offline kommt die Rückfrage „online gehen?“ schon vor dem Dialog (K2). Eine deutsche Textmail mit Umlauten bekommt aus der Postfachliste `.eml`, nicht `.txt`, wie der Eintrag sagt (K3). Im Verfassen-Fenster richtet sich die Vorgabe nach dem Stand beim letzten Speichern, nicht nach dem Text im Fenster (K4). Der Regressionstest bleibt grün, wenn man die HTML-Erkennung in beiden Fenstern abschaltet (K5, gemessen).

Bei [E-170](../Intern/BEFUNDE.md#e-170) erfüllt die Einarbeitung von PRUEFER-89 die Funde K1 bis K5 am Quelltext. Zwei Lücken bleiben. Der Anstoß, der eine Vormerkung nach dem Abgleich verwirft, sitzt nur an einer der Stellen, die den Abgleich auslösen. In den anderen Fällen gilt wieder die Frist von fünf Minuten (K8). Läuft schon ein Abgleich des Ziels, kann er die Vormerkung verwerfen, bevor die Kopie da ist. Dann fehlt das Label, ein falsches kommt aber nicht (K9). Die neuen Logzeilen stehen in einem Bereich, der in der Vorgabe ausgeschaltet ist (K10).

Zum Zusatz e133 siehe unten: **nichts hält den Merge auf.**

**Kein Fund hält das nächste Paket (7.2.2.132) auf.** Vor dem Paket sollte Gregor K3 kennen. Dort steht im Eintrag zu [E-128](../Intern/BEFUNDE.md#e-128) „reiner Text als `.txt`“. Für eine Textmail mit Umlauten aus der Postfachliste stimmt das nicht.

## Zusatz: e133

Geprüft: 3c6d988d *„PRUEFER-87 Nachtrag 2 P1: Kurzform-Grenze gegen MAX_PATH, Laengenpruefung in CheckMailDirectory“* (`eudora.cpp`, `fileutil.cpp`, `Tests/TestE133.cpp`, `Tests/Extract.ps1`). Zeilen sind Stand `origin/e133_mailverzeichnis_fehlt`. Nur gelesen, nicht gebaut.

**Ergebnis: Nichts hält den Merge von e133 auf.** Die Längenprüfung sitzt an der richtigen Stelle, und ihre Grenze stimmt auf das Byte.

### Pufferlängen in CheckMailDirectory

Am Quelltext belegt (fileutil.cpp):

- `szShortEDir` und `Edir` fassen je `_MAX_PATH + 1` = 261 Byte (:346-347).
- `E209MailDirPasst` lässt höchstens 259 Zeichen durch, die zwei Zeichen Laufwerk eingerechnet (:333ff). Geprüft wird vor dem `strcat` (:363 vor :370), und zwar `strlen(dir)` vor `TrimWhitespaceMT`. Das ist die strengere Seite.
- Rechnung für den längsten erlaubten Fall: `szShortEDir` bekommt 259 Zeichen und die Null, also 260 Byte. `GetFullPathName` kopiert nur bei `dwAbsLen < sizeof` (:378ff). `Edir` wird mit `strcpy` gesät, höchstens 259 Zeichen. `GetLongPathName(…, _MAX_PATH)` (:387) schreibt nur bei einem Ergebnis bis 259 Zeichen, sonst bleibt die Saat. Der Rückstrich (:424) macht daraus höchstens 260 Zeichen und die Null, also genau 261 Byte. **Kein Überlauf.**
- Die Grenzwerte im Test (259 ja, 259 mit Laufwerk nein, 260 nein, 275 nein, NULL nein) treffen genau diese Rechnung. Die Funktion wird echt aus `fileutil.cpp` geschnitten (Extract.ps1 Region R5).

### Die beiden Kurzform-Ausweichen (eudora.cpp)

- `E133InBefehlszeile` (:4145ff) und der E-132-Weg *„Nein“* (:4586) weichen jetzt schon ab 260 Zeichen Pfad auf die Kurzform aus, nicht erst ab der Größe von `buf`. Belegt.
- **Gegenvermutung: `GetShortPathName(…, szKurz, MAX_PATH + 1) > 0` (:4157, :4586).** Ist der Puffer zu klein, liefert die Funktion die nötige Länge (> 0) und schreibt nichts. Dann würde ein nicht beschriebenes `szKurz` übernommen. Erreichbar ist das hier nicht. `szPfad` kommt aus `SHGetPathFromIDList` in einen Puffer von `MAX_PATH + 1` (:4130-4132), ist also höchstens 259 Zeichen lang. `szEigenes` stammt aus `ExecutableDir`, und das kommt aus `GetModuleFileName` in einen Puffer von 261 Byte. Die Kurzform ist nie länger als die Langform, sie passt also in `szKurz`. Am Quelltext belegt. Sauberer wäre trotzdem `n > 0 && n <= MAX_PATH` (Z1, **sehr gering**). Das hält nichts auf.
- Mit einem Pfad über 259 Zeichen und ohne Kurzform bleibt die Langform stehen. `CheckMailDirectory` weist sie dann ab wie ein fehlendes Verzeichnis. Belegt.

### Trifft der Test den Weg?

- `E209MailDirPasst` wird im Verhalten geprüft, mit den echten Grenzen. Belegt.
- `CheckMailDirectory` selbst läuft nicht im Test, denn es ruft `ErrorDialog`. Dass die Prüfung **vor** dem `strcat` steht, verlangt der Test über die Stellung im Text (`QT_Stelle`, TestE133.cpp). Das reicht für diesen Befund.
- `E133InBefehlszeile` läuft mit 270 Zeichen und einem Wächterbyte. Den Ordner gibt es nicht, `GetShortPathName` scheitert also, und es bleibt die Langform. Geprüft wird, dass `buf` abgeschlossen ist und nicht überschrieben wird. Den Zweig *„Kurzform gefunden“* deckt der Test nicht ab. Das ist eine Vermutung aus dem Testtext, ohne Bedeutung für die Sicherheit.
- Die Gegenproben aus der Commit-Nachricht (vier Stück, je 390/391 rot) habe ich nicht nachgefahren. Auftragsgemäß habe ich nur gelesen.

### Nebenbefund außerhalb des Diffs (alt, QUALCOMM)

`GetEnvironmentVariable(EudoraEnvironVar, buf, sizeof(buf))` (fileutil.cpp:515): Ist die Umgebungsvariable länger als 260 Zeichen, liefert die Funktion die nötige Länge und lässt `buf` unverändert. In `buf` steht dann noch das Programmverzeichnis aus `GetModuleFileName`. `CheckMailDirectory` nimmt dann still das Programmverzeichnis statt einer Fehlermeldung. Belegt am Quelltext und an der Schnittstelle von `GetEnvironmentVariable`, nicht gemessen. Schwere **sehr gering**, nicht von e133 eingeführt, hält nichts auf.

## 1. E-128: der Weg am Quelltext

Alle Zeilen sind Stand c2402a4c, `Eudora71/Eudora/`.

- **Wie MFC die Vorgabeendung behandelt.** `CFileDialog` speichert nur den Zeiger: `m_ofn.lpstrDefExt = lpszDefExt` (MFC 14.38, `atlmfc/src/mfc/dlgfile.cpp:78`). Gelesen wird er erst in `DoModal` über `ApplyOFNToShellDialog` (:346-349, `SetDefaultExtension`). Den Filter dagegen kopiert MFC (`m_strFilter = lpszFilter`, :94). Die Behebung übergibt als Endung immer einen festen Text (`E128Vorgabeendung` liefert Literale, msgutils.cpp) oder einen `CRString`, der bis nach `DoModal` lebt (`ExtensionText`, saveas.cpp:93-94). **Richtig.** Vorher bekamen `tocview.cpp` und `compmsgd.cpp` ein Temporärobjekt `CRString( IDS_TEXT_EXTENSION )`, also einen Zeiger, der bei `DoModal` schon freigegeben war. Das hat [E-128](../Intern/BEFUNDE.md#e-128) nebenbei behoben. Drei solche Stellen bleiben, siehe K6. Belegt.
- **Filterindex.** MFC setzt `SetFileTypeIndex(m_ofn.nFilterIndex > 1 ? m_ofn.nFilterIndex : 1)` (dlgfile.cpp:423). Eine 0 aus `E128FilterIndex` heißt also „erster Eintrag“, und das ist harmlos. `OnTypeChange` des Shell-Dialogs schreibt den Index nur zurück, wenn der Anwender umschaltet (dlgfile.cpp:643). `CSaveAsDialog::OnTypeChange` kehrt ohne Kästchen sofort zurück (SaveAsDialog.cpp, `m_GuessParagraphs.GetSafeHwnd() == NULL`). `ToggleStat` hängt an `IDC_STATIONERY`, und das gibt es ohne Vorlage nicht. Beide ändern den vorbelegten Index also nicht. Belegt.
- **Vorhersage gegen Schreiben in der Postfachliste.** Vor dem Dialog (tocview.cpp:3077-3115) wird dieselbe Kette gerechnet wie danach (:3157-3255): `IncludeHeaders` aus der INI, ohne Kopfzeilen `FindBody`, dann `E101SpeicherfassungAufbereiten`. Abweichungen gibt es drei. (a) Nach dem Dialog läuft bei `GuessParagraphs` `UnwrapText` (:3212). Das ändert weder den Marker `<x-html>` noch die Hochbytes, also auch nicht, ob [E-101](../Intern/BEFUNDE.md#e-101) einen Kopf ergänzt. (b) Mit Kopfzeilen schneidet `StripTabooHeaders` Zeilen weg, oder es kommt eine `Date:`-Zeile dazu. `E128DateiMitKopf` liefert mit Kopfzeilen ohnehin `true`. (c) Nach dem Dialog wird `m_Inc` in die INI geschrieben (:3145). Den Wert kann heute niemand ändern, weil die Kästchen fehlen ([E-98](../Intern/BEFUNDE.md#e-98)). Wer [E-98](../Intern/BEFUNDE.md#e-98) behebt, muss die Vorhersage nach dem Dialog wiederholen. Vermutung zur Zukunft, heute ohne Wirkung. Belegt.
- **Gelesen-Markierung.** Die Vorhersage ruft `GetMessageDoc` und `GetFullMessage` und gibt das Dokument mit `NukeMessageDocIfUnused` wieder frei. `SetState(MS_READ)` steht nur in der Schreibschleife nach dem Dialog. Wer abbricht, ändert die Markierung also nicht. Belegt. Bei IMAP lädt `GetFullMessage` aber eine noch nicht geholte Nachricht vom Server (msgdoc.cpp:226-230), siehe K2.
- **Weitere Aufrufer.** `CSaveAs::Start` hat nur noch einen Aufrufer mit Dialog (ReadMessageDoc.cpp:620). Der in `PgReadMsgView.cpp:618` ist auskommentiert. `Trnslate.cpp` und `filtersd.cpp:2113` benutzen nur `CreateFile`. `CSaveAsDialog` wird außer in `saveas.cpp` nur in `tocview.cpp` und `compmsgd.cpp` gebaut. *Speichern unter* aus der Vorschau leitet an `CTocView` weiter (TridentPreviewView.cpp:682, PgReadMsgPreview.cpp:144) und bekommt damit die Regel der Postfachliste. Es fehlt kein Weg. Belegt.
- **Ressource.** `IDS_TOC_SAVEAS_FILE_FILTER 3131` ist eindeutig unter den Zeichenketten (resource.h:1586). Belegt.

## 2. Testsuite und Gegenproben (in meinem Baum)

Gemessen mit `Eudora71\Tests\RunTests.cmd` aus PowerShell. Die Quellen habe ich mit Perl `:raw` geändert, mit Ankern, die genau einmal trafen. Danach habe ich sie aus einer Sicherung im Scratchpad zurückkopiert, mit neuem Zeitstempel, ohne `cp -p` (Lehre aus [PRUEFER-89](PRUEFER-89.md)). `cmp` meldete jedes Mal byte-gleich. `git status` war danach leer.

| Lauf | Änderung (vorübergehend) | Ergebnis |
|---|---|---|
| 0 | keine | 391/391 |
| G1+G2+G3 in einem Lauf | tocview.cpp: `FindBody(pszVollE128)` → `pszVollE128` (ohne Kopfzeilen die ganze Nachricht vorhersagen); ReadMessageDoc.cpp und compmsgd.cpp: `bHtmlE128` fest `false` | **391/391, grün** (K5) |
| P (Positivprobe) | compmsgd.cpp: `bHtmlE128` fest `false` **und** `E128GewaehltSchreiben( "Verfassen-Fenster", … )` auskommentiert | 390/391, rot nur an `fehlt [E128GewaehltSchreiben…]`. Der Test liest also meinen Baum, und die Abschaltung der HTML-Erkennung allein sieht er nicht |
| 0' | alles zurück | 391/391 |

G1 bis G3 liefen in einem gemeinsamen Lauf. Weil jede der drei Stellen in einer eigenen Datei und einem eigenen Textabschnitt steht, ist auch jede einzeln grün. Das habe ich aus dem Aufbau des Tests geschlossen, nicht einzeln gemessen. Die Gegenprobe des BEHEBERS (tocview.cpp auf dem alten Stand → 390/391) habe ich nicht nachgefahren.

## 3. E-213 (tools/testlauf.ps1)

Nur gelesen, nicht gestartet, wie verlangt. `ErrorActionPreference` wird vor dem Aufruf auf `Continue` gesetzt und im `finally` zurückgesetzt. `catch` meldet `MESSSKRIPT-FEHLER:`. Beenden und Protokoll folgen danach ohne weitere Bedingung (testlauf.ps1:346-400). Belegt. Ein `NativeCommandError` aus `2>&1` wird mit `Continue` kein abbrechender Fehler mehr, sondern eine Zeile in der Pipeline. Das ist PowerShell-5.1-Verhalten und am Prüfstand vom BEHEBER gemessen. Ich habe es nicht nachgemessen.

Was bleibt, steht in K7: Das Beenden ist nur gegen Fehler *im Messskript* geschützt. Ein Messskript, das hängt, oder ein Abbruch von `testlauf.ps1` selbst zwischen Start und Beenden, etwa mit Strg-C, lässt Eudora weiter offen. Die Messskripte von [E-128](../Intern/BEFUNDE.md#e-128) haben überall begrenzte Wartezeiten (messen-e128.ps1, Schleifen mit 40 bis 60 Durchläufen). Für sie gilt das also nicht.

Zu `messen-e128.ps1` am Rand: Die Erwartungszeile prüft nur die angehängte Endung, nicht `typ-index`. Ob die Vorbelegung von `nFilterIndex` im Dialog ankommt, steht also nur in der Zeile `E128 WEG …`, nicht im Urteil. Weil der Vista-Dialog die Endung des gewählten Typs anhängt, ist sie mittelbar gemessen. Das ist eine Vermutung zum Verhalten des Shell-Dialogs. Ungemessen sind mehrere Nachrichten (`anzahl=2` → `txt`), Text mit Umlauten (K3) und IMAP (K2).

## 4. E-170: Einarbeitung von PRUEFER-89 (01f4c9cd, nur gelesen)

Zeilen sind Stand `origin/e170_label_ohne_uidplus`.

| PRUEFER-89 | Eingearbeitet | Urteil |
|---|---|---|
| K1 gescheitertes COPY merkt vor | `E170WegWaehlen(…, m_iState == kActionStateSucceeded, …)`, Grund `fehlgeschlagen` (ImapActionQueue.cpp, `E170LabelsNachtragen`) | erledigt, belegt |
| K1 Restlage 5 min | `E170AbgleichAngestossen` vor `DoManualResync` (:1643-1645), `E170AbgleichFertig` am Ende von `CImapChecker::DoMergeNewTocs` (ImapChecker.cpp:1292) und nach `ImapAppendSumList` in `DoFetchNewMessages` | erledigt für diesen Weg. Lücken: K8, K9 |
| K2 Verwaltung blind | `E170Vormerkbar`, `E170GehoertZu`, `E170Anstossen`, `E170AbgleichEntscheiden`, `E170AbgleichEnde` als reines C++ in `E170Zuordnung.h`. Die Gegenproben stehen in der Commit-Nachricht (16 × 387/388) | im Aufbau erledigt. Die Gegenproben habe ich nicht nachgefahren, weil ich nur lesen sollte |
| K3 Prüfstand | `--copy-scheitert`, `--gleiche-im-ziel`, Fälle `E-170c`, `E-170s` | nicht geprüft (nur `Eudora71` gelesen) |
| K4 Verfall still | Zeile `E-170 Vormerkung verworfen: verfallen=<n> grund=… ziel=…` (ImapToc.cpp:1904), Frist ab dem Anstoß | erledigt. Die Zeile steht aber in MISC, siehe K10 |
| K5 Leck beim Beenden | `E170VormerkungenFreigeben()` in `ExitInstance` (eudora.cpp, `#ifdef IMAP4`) | erledigt, belegt |

Am Speicher geprüft: `E170Eintrag` hält `szZiel`, `m.szVon` und `m.szBetreff` als Zeiger in die `CString`-Glieder derselben `E170Vormerkung`. Diese Glieder werden nach dem Setzen nicht mehr geändert, und die Vormerkung wird nie kopiert, nur über ihren Zeiger verschoben. Die Zeiger bleiben also gültig. `E170Eintraege` kopiert flach, und `E170AbgleichAngestossen` schreibt die Kopie zurück. Das ist unbedenklich. Gelöscht wird erst nach der letzten Verwendung (`E170Verwerfen` hinter der Schleife). Belegt. Die Reihenfolge Vormerken (:1632) → Anstoß (:1643) → Abgleich läuft ganz im Hauptfaden (`DoPostProcessing`). Ein Abgleich kann sich also nicht zwischen Vormerken und Anstoß schieben. Belegt.

## 5. Funde

### <a id="k1"></a>K1: Die Postfachliste bietet *HTML Files (\*.htm)* an, schreibt aber nie reines HTML

(am Quelltext belegt)

Der neue Filter `IDS_TOC_SAVEAS_FILE_FILTER` (EudoraRes.rc:8552) enthält `HTML Files (*.htm)`. Vorher bot die Postfachliste nur *Text* und *Alle* an (`IDS_TEXT_FILE_FILTER`). Der Speicherweg der Postfachliste wertet die Endung aber nicht aus. Er schreibt immer das Ergebnis von `E101SpeicherfassungAufbereiten`, bei HTML also mit `MIME-Version` und `Content-Type` vorn (tocview.cpp:3247ff, `.htm` kommt in `tocview.cpp` nicht vor). Der Kommentar von QUALCOMM direkt darüber sagt dasselbe: *„you cannot save the message data as an HTML file“* (:3061-3064). Der Eintrag zu [E-128](../Intern/BEFUNDE.md#e-128) begründet `.eml` genau damit, dass ein Browser diese Zeilen als Text zeigt. Wer im Dialog *HTML Files* wählt, bekommt also die Datei, vor der die Behebung bewahren will. Der Test verlangt nur, dass `.rtf` fehlt, nicht `.htm`. **Abhilfe:** den Eintrag aus `IDS_TOC_SAVEAS_FILE_FILTER` streichen (dann `Text`, `Mail`, `Alle`), im Test `!QT_Enthaelt(pToc, "htm")` verlangen. **Schwere: gering.** **Hält das Paket nicht auf.**

### <a id="k2"></a>K2: Bei IMAP holt die Vorhersage die Nachricht schon vor dem Dialog vom Server

(am Quelltext belegt; nicht gemessen)

Bei genau einer markierten Nachricht ruft die Postfachliste vor dem Dialog `GetFullMessage` (tocview.cpp:3092). In einem IMAP-Postfach lädt das eine noch nicht geholte Nachricht: `DownloadImapMessage` (msgdoc.cpp:226-230) → `OnPreviewSingleMessage` (EuImap/src/ImapMailbox.cpp:2987ff) → `GetConnectionState(bDoAllowOffline)`. Daraus folgt dreierlei. (a) Wer den Dialog abbricht, hat trotzdem einen Serverzugriff ausgelöst. Bei einer großen Nachricht wartet er auf den Dialog. (b) Ist Eudora offline und `ImapAllowOfflineActions` aus, erscheint die Rückfrage `IDD_ERR_OFFLINE` (ImapTypes.cpp:88) **vor** dem Dialog *Speichern unter*. Bleibt man offline, schlägt `GetFullMessage` fehl, die Vorgabe wird `txt`, und nach OK kommt dieselbe Rückfrage ein zweites Mal aus der Schreibschleife. (c) Ist Eudora offline und die Offline-Aktionen sind erlaubt, wird nur ein Abruf eingereiht. Die Vorgabe bleibt dann `txt`, auch für eine HTML-Mail. Den Lesestatus auf dem Server ändert das nicht: Die Abrufe benutzen `FT_PEEK` (Imapdll/src/ImapStream.cpp). Das ist eine Vermutung, denn ich habe nur den Abruf beim Vorschauen gesehen. Der Prüfstand misst nur POP. **Abhilfe:** die Vorhersage nur rechnen, wenn `!pSum->IsNotIMAPDownloadedAtAll()`. Sonst die Regel aus der Zusammenfassung nehmen (`IsHTML()` → `eml`) oder `txt`. **Schwere: gering.** **Hält das Paket nicht auf.**

### <a id="k3"></a>K3: Eine Textmail mit Umlauten bekommt aus der Postfachliste `.eml`, nicht `.txt`

(am Quelltext belegt; im Test festgeschrieben)

Ohne Kopfzeilen ergänzt [E-101](../Intern/BEFUNDE.md#e-101) den MIME-Kopf nicht nur bei HTML, sondern bei jedem Hochbyte und bei `<x-flowed>`/`<x-rich>` (msgutils.cpp:4634, `bWarHtml || bWarRich || bHochbyte`). `E128DateiMitKopf` macht daraus `.eml`. Der Test verlangt das ausdrücklich: *„Text mit Umlauten bekommt von [E-101](../Intern/BEFUNDE.md#e-101) einen Kopf … also .eml“* (TestE128.cpp, `Test_E128_KetteMitE101`). Für deutsche Textmails ist das der Normalfall. Die Datei trägt dann nur `MIME-Version`, `Content-Type` und `Content-Transfer-Encoding`, kein `From`, `Subject` oder `Date`. Ein Doppelklick öffnet das Mailprogramm statt des Editors. Der Eintrag zu [E-128](../Intern/BEFUNDE.md#e-128) sagt dagegen *„reiner Text als `.txt`“*, und gemessen ist nur reines ASCII (`E-128t`). Das ist kein Fehler im Code, die Regel ist folgerichtig. Gregor hat aber zu „Endung aus dem Inhalt“ ja gesagt, ohne diesen Fall zu kennen. **Abhilfe:** den Fall in den Eintrag und in den Testplan schreiben und Gregor fragen, ob eine Textmail mit Umlauten `.eml` oder `.txt` heißen soll. Bei `.txt` müsste `E128DateiMitKopf` HTML vom Zeichensatzkopf unterscheiden. **Schwere: gering** (Erwartung und Doku). **Hält das Paket nicht auf**, Gregor sollte es aber vor seinem Test kennen.

### <a id="k4"></a>K4: Im Verfassen-Fenster folgt die Vorgabe dem gespeicherten Stand, nicht dem Text im Fenster

(am Quelltext belegt; Wirkung Vermutung)

`compmsgd.cpp:3368` liest `m_Sum->IsHTML()`. Gesetzt wird `MSFEX_HTML` beim Anlegen aus dem Anfangstext (`IsFancy(Body)`, compmsgd.cpp:275-281) und erst beim Speichern aus der Ansicht neu bestimmt (`PgHasStyledText`, PgMsgView.cpp:375-393). Wer eine neue, leere Nachricht im Fenster fett formatiert und dann *Speichern unter* wählt, bekommt `.txt`, und die Formatierung geht verloren. Das war vor [E-128](../Intern/BEFUNDE.md#e-128) genauso, es ist also kein Rückschritt. Umgekehrt bleibt eine Antwort, aus der alle Auszeichnung gelöscht wurde, bei `.htm`. Das schadet nicht. **Abhilfe:** in `OnFileSaveAs` die Ansicht fragen (`PgHasStyledText` wie in PgMsgView.cpp:751) statt der Zusammenfassung. **Schwere: gering.**

### <a id="k5"></a>K5: Der Test sieht die HTML-Erkennung der Fenster und den Rumpf der Vorhersage nicht

(gemessen, Abschnitt 2)

Grün bleiben drei Änderungen. In beiden Fenstern `bHtmlE128` fest auf `false`: Damit fiele die halbe Behebung weg, denn beide Fenster böten wieder immer `.txt` an. In der Postfachliste die ganze Nachricht statt des Rumpfs vorhersagen: Dann bekäme eine HTML-Mail ohne Hochbytes `.txt`, weil `<x-html>` nicht mehr am Anfang steht. `Test_E128_Quelltext` verlangt den Aufruf `E128Vorgabeendung( false, 1, false, bHtmlE128 )`, aber nicht, woraus `bHtmlE128` entsteht, und nicht die Zeile mit `FindBody`. Das ist dieselbe Klasse wie [PRUEFER-89](PRUEFER-89.md#k2) K2. **Abhilfe:** die Zeilen `const bool bHtmlE128 = …IsHTML()…` und `… : FindBody(pszVollE128);` wörtlich verlangen. Besser wäre die Vorhersage der Postfachliste als reine Funktion `E128VorhersageListe(pszVoll, bKopf)` nach `msgutils.cpp` zu ziehen und im Verhalten zu prüfen. **Schwere: gering.**

### <a id="k6"></a>K6 (neu E-214): `CFileDialog` behält den Zeiger auf die Vorgabeendung, drei Aufrufer übergeben ein Temporärobjekt

(am Quelltext belegt, in MFC und bei den Aufrufern; Wirkung nicht gemessen)

MFC speichert `lpszDefExt` nur als Zeiger (dlgfile.cpp:78) und liest ihn erst in `DoModal` (:346-349). Drei Aufrufer übergeben `CRString(IDS_TEXT_EXTENSION)` als Temporärobjekt. Es wird am Ende der Deklaration freigegeben, also **vor** `DoModal`:

- `CSignatureDoc::OnFileSaveAs`, signatur.cpp:71
- `CTextFileDoc::OnFileSaveAs`, textfile.cpp:108
- `CEudoraApp::OnFileOpen`, eudora.cpp:4910

Bis [E-128](../Intern/BEFUNDE.md#e-128) gehörten auch `tocview.cpp` und `compmsgd.cpp` dazu. Das ist ein Original von QUALCOMM. Im Release steht im freigegebenen Block wahrscheinlich noch `txt`. Dafür spricht, dass [E-207](../Intern/BEFUNDE.md#e-207) aus dem Signaturfenster `.txt` gemessen hat. Das ist aber Glück. Im Debug-Bau füllt die CRT freigegebenen Speicher mit `0xDD`, und die Vorgabeendung wäre Unsinn. Das habe ich aus dem Verhalten der CRT abgeleitet, nicht gemessen. `tools/befund-suchen.pl lpstrDefExt` und `CEudoraApp::OnFileOpen` melden nichts. [E-207](../Intern/BEFUNDE.md#e-207) und [E-195](../Intern/BEFUNDE.md#e-195) nennen die Stellen, aber nicht diesen Fehler. **Abhilfe:** an allen drei Stellen ein benanntes `CRString` vor dem Dialog anlegen, oder `"txt"` übergeben. Dazu ein Quelltexttest, der `CFileDialog …( …, CRString(` verbietet. **Schwere: gering.** **Hält das Paket nicht auf.**

### <a id="k7"></a>K7: `testlauf.ps1` beendet Eudora nur bei einem Fehler im Messskript sicher

(am Quelltext belegt)

`try`/`finally` umschließt nur den Aufruf des Messskripts (testlauf.ps1:346ff). Hängt das Messskript, gibt es keine Zeitschranke. Bricht `testlauf.ps1` selbst zwischen dem Start und *Beenden* ab, etwa mit Strg-C oder einem Fehler beim Fenstertitel, bleibt Eudora offen, und der Start fehlt in `TESTLAEUFE.md`. Das ist genau die Lage von [E-213](../Intern/BEFUNDE.md#e-213), nur aus einem anderen Grund. **Abhilfe:** ein `try`/`finally` vom Start bis zum Protokoll und eine Zeitschranke für das Messskript (`Start-Process … -PassThru` und `WaitForExit(ms)`). **Schwere: sehr gering.**

### <a id="k8"></a>K8: Der Anstoß sitzt nur an einer von mehreren Stellen, die den Abgleich des Ziels auslösen

(am Quelltext belegt, `origin/e170_label_ohne_uidplus`)

`E170AbgleichAngestossen` steht nur in `CImapTransferMsgAction::DoPostProcessing` (ImapActionQueue.cpp:1643). Ob diese Aktion den Abgleich auslöst, hängt an `m_bIsLastOnMailbox`, also an `GetNextMailboxMatch(m_lDestMailboxHash) == NULL` (:1960). Folgt in der Warteschlange eine andere Aktion auf dasselbe Ziel, stößt die letzte den Abgleich an, ohne die Vormerkungen anzustoßen. Ein Beispiel ist eine Übertragung aus einem lokalen Postfach, deren Abgleich bei :2714 nichts von [E-170](../Intern/BEFUNDE.md#e-170) weiß. Dann verwirft `E170AbgleichFertig` die Vormerkungen nicht (`bAngestossen` bleibt `false`, E170Zuordnung.h, `E170AbgleichEnde`). Es gilt wieder die Frist von fünf Minuten, und damit die Restlage aus [PRUEFER-89](PRUEFER-89.md#k1) K1. Das geschieht selten: Es braucht zwei Aktionen auf dasselbe Ziel in einer Warteschlange und danach eine gleich aussehende fremde Mail. **Abhilfe:** den Anstoß dorthin legen, wo jeder Abgleich beginnt (`CImapMailMgr::CheckMail`), oder in `E170AbgleichFertig` jede Vormerkung verwerfen, deren Zeitpunkt vor dem Beginn dieses Abgleichs liegt. **Schwere: gering.**

### <a id="k9"></a>K9: Ein schon laufender Abgleich des Ziels kann die Vormerkung verwerfen, bevor die Kopie da ist

(Kette am Quelltext belegt; ob der eingereihte Abgleich über `CheckMailOnServer` läuft, ist eine Vermutung)

`DoManualResync` (bInForeGround `FALSE`) reiht nur ein `CImapResyncAction` ein (ImapMailMgr.cpp:249-287). Gibt es für das Ziel schon einen Abgleich, lehnt `AddTask` einen zweiten ab (:315-324). Der laufende Abgleich kann den Serverstand **vor** dem `COPY` gelesen haben. Er ruft am Ende trotzdem `E170AbgleichFertig` (ImapChecker.cpp:1292) und verwirft die angestoßene Vormerkung, weil die Kopie nicht dabei war. Das Label fehlt dann. **Ein falsches kommt nicht**, und das ist die sichere Seite. Vor der Einarbeitung wartete die Vormerkung bis zu fünf Minuten und hätte den nächsten Abgleich noch erreicht. Ein häufiger Fall: Das Ziel ist ein Postfach, das Eudora regelmäßig abgleicht. **Abhilfe:** wie K8, nur Abgleiche zählen, die *nach* dem Anstoß begonnen haben (Zeit in `CImapChecker` beim Start merken, `E170AbgleichFertig(pToc, dwBeginn)`). **Schwere: gering.**

### <a id="k10"></a>K10: Die neuen Logzeilen von E-170 stehen im Bereich MISC, der in der Vorgabe aus ist

(am Quelltext belegt)

`E-170 Vormerkung angestossen` und `E-170 Vormerkung verworfen` schreiben mit `DEBUG_MASK_MISC` (ImapToc.cpp:1904ff, :1990ff). Die Vorgabe `LogLevel` ist 25759 = 0x649F (EudoraRes.rc:8472), und MISC (0x8000) ist darin aus (so auch tocview.cpp:3261). [PRUEFER-89](PRUEFER-89.md#k4) K4 sollte eine Meldung von Gregor von einem Fehler der Zuordnung unterscheidbar machen. In seinem Protokoll steht die Zeile aber nicht. Die übrigen Zeilen von [E-170](../Intern/BEFUNDE.md#e-170) stehen ebenfalls in MISC, der Prüfstand schaltet MISC also offenbar ein. Dazu kommt: Die Zeile heißt auch bei `grund=ohne-treffer-im-abgleich` noch `verfallen=<n>` (:1904, :2075), obwohl nichts verfallen ist. **Abhilfe:** `DEBUG_MASK_DIALOG` oder einen in der Vorgabe eingeschalteten Bereich nehmen, wie [E-101](../Intern/BEFUNDE.md#e-101) und [E-128](../Intern/BEFUNDE.md#e-128). Statt `verfallen=` besser `anzahl=`. **Schwere: sehr gering.**

### Zum Zusatz e133

- <a id="z1"></a>**Z1:** `GetShortPathName(…) > 0` statt `> 0 && <= MAX_PATH` (eudora.cpp:4157, :4586). Heute nicht erreichbar, siehe oben. **Sehr gering.**
- <a id="z2"></a>**Z2:** Ist die Umgebungsvariable `EUDORA` länger als 260 Zeichen, wird still das Programmverzeichnis genommen (fileutil.cpp:515). Das ist alt und nicht von e133. **Sehr gering.**

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | Postfachliste bietet *HTML Files* an, schreibt aber MIME-Kopf und HTML: die `.htm`, vor der [E-128](../Intern/BEFUNDE.md#e-128) bewahren will | gering | nein |
| K2 | IMAP: die Nachricht wird schon vor dem Dialog geholt, auch bei Abbruch; offline kommt die Rückfrage vor dem Dialog und danach noch einmal | gering | nein |
| K3 | Textmail mit Umlauten aus der Postfachliste → `.eml`, der Eintrag sagt `.txt` | gering | nein; Gregor vor dem Test sagen |
| K4 | Verfassen-Fenster: Vorgabe nach dem gespeicherten Stand, nicht nach dem Text im Fenster | gering | nein |
| K5 | Test grün ohne HTML-Erkennung in beiden Fenstern und mit falschem Rumpf in der Vorhersage (gemessen) | gering | nein |
| K6 (neu E-214) | drei `CFileDialog` bekommen die Vorgabeendung als freigegebenes Temporärobjekt (signatur.cpp, textfile.cpp, eudora.cpp) | gering | nein |
| K7 | `testlauf.ps1`: Hängen des Messskripts oder ein eigener Abbruch lässt Eudora offen | sehr gering | nein |
| K8 | [E-170](../Intern/BEFUNDE.md#e-170): der Anstoß fehlt, wenn eine andere Aktion den Abgleich des Ziels auslöst, dann wieder 5 min Frist | gering | nein |
| K9 | [E-170](../Intern/BEFUNDE.md#e-170): ein laufender, älterer Abgleich verwirft die Vormerkung, dann fehlt das Label (kein falsches) | gering | nein |
| K10 | [E-170](../Intern/BEFUNDE.md#e-170): neue Logzeilen in MISC (Vorgabe aus), `verfallen=` auch ohne Verfall | sehr gering | nein |
| Z1 | e133: `GetShortPathName`-Rückgabe nicht gegen den Puffer geprüft (nicht erreichbar) | sehr gering | nein, auch nicht den Merge von e133 |
| Z2 | alt: zu lange Umgebungsvariable `EUDORA` → still das Programmverzeichnis | sehr gering | nein |
