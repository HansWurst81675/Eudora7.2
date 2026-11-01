# <a id="pruefer-77"></a>PRUEFER-77 - Kurzlauf zu Commit 878f38e9 (E-189 / PRUEFER-76 K1)

## Ergebnis vorweg

Die Behebung ist richtig. Bevor eine Vorab-Kopie entfernt wird, fragt Eudora jetzt das offene Nachrichtenfenster, ob es geschlossen werden darf, genau wie beim normalen Verschieben. Sagt der Anwender "Abbrechen", bleibt die Nachricht doppelt stehen, statt dass Eudora abstürzt. Eine Endlosschleife kann nicht entstehen, und nach "Ja" oder "Nein" kommt die Frage beim eigentlichen Schließen nicht noch einmal. Es gibt einen kleinen Schönheitsfund (K1), er hält kein Paket auf. Testsuite: 355/355 (gemessen).

## Geprüft

Umfang: nur `Eudora71/EuImap/src/ImapToc.cpp`, Funktion `E189VorabKopienEntfernen` (ImapToc.cpp:1749-1795), aufgerufen allein aus ImapActionQueue.cpp:1624 (am Quelltext belegt, grep).

### 1. Reihenfolge und Endlosschleife

- `SetE184Vorab(FALSE)` steht jetzt vor der Frage (ImapToc.cpp:1768). `E184FindeVorabKopie` liefert nur Einträge mit `IstE184Vorab()` (ImapToc.cpp:1740). Im `continue`-Zweig ist das Merkzeichen also schon weg; die innere Schleife findet dieselbe Kopie nicht wieder und endet (am Quelltext belegt).
- Folge: eine abgelehnte Kopie verliert ihr Merkzeichen dauerhaft und wird später auch nicht mehr entfernt. Das ist gewollt ("lieber ein Doppel") und entspricht [E-121](../Intern/BEFUNDE.md#e-121) N1 in ImapActionQueue.cpp:2647-2650 (am Quelltext belegt).

### 2. Fragt CanCloseFrame bei einem empfangenen IMAP-Fenster?

- `CMessageDoc` überschreibt `CanCloseFrame` nicht (grep über Eudora/*.cpp, *.h: nur Filter-, Nickname- und Hauptfenster). Es läuft also `CDocument::CanCloseFrame` aus MFC, das beim letzten Fenster des Dokuments `SaveModified` ruft (MFC-Verhalten, belegt durch die Quelle von MFC, hier nicht neu gemessen).
- `CMessageDoc::SaveModified` (msgdoc.cpp:940) fragt erst eine ggf. ausstehende Lesebestätigung, dann nur bei `IsModified() || WasTranslated()` den Speichern-Dialog. Ein unverändertes empfangenes Fenster ohne Lesebestätigung geht also ohne Frage durch (am Quelltext belegt, msgdoc.cpp:1004-1005).

### 3. Fragt das spätere SC_CLOSE noch einmal?

- Nein. Nach "Ja" oder "Nein" setzt `SaveModified` am Ende `SetModifiedFlag(FALSE)` (msgdoc.cpp, Kommentar "so the save prompt doesn't come up again", nach dem switch). Die Lesebestätigung ist nach IDOK/IDABORT abgeschaltet (`UnsetFlag(MSF_READ_RECEIPT)`), nach IDRETRY sperrt `m_rrDialogOverride` die zweite Frage (msgdoc.cpp:955-1001). Am Quelltext belegt.
- Bei "Ja" läuft `DoSave` noch während `pSum` lebt; `RemoveSum` kommt erst danach (am Quelltext belegt, ImapToc.cpp:1782-1792).

### 4. Zugriff auf die gelöschte Zusammenfassung nach SC_CLOSE

- `RemoveSum` ruft vor dem `delete` `Sum->NukeMessageDocIfUnused()`, wenn das Dokument noch auf die Zusammenfassung zeigt (tocdoc.cpp:1558-1590). Das ist derselbe Weg wie in `CTocDoc::Xfer` (tocdoc.cpp:2806-2840: CanCloseFrame, PostMessage SC_CLOSE, InvalidateCachedPreviewSummary, später RemoveSum) und in ImapActionQueue.cpp:2650-2661. Die neue Stelle führt kein neues Risiko ein, das die beiden Vorbilder nicht schon tragen (am Quelltext belegt). Der Absturzweg aus PRUEFER-76 (Abbrechen, msgdoc.cpp:1028 mit NULL-`m_Sum`) ist geschlossen, weil bei Abbrechen jetzt gar nicht entfernt wird.
- Einziger Unterschied zu den Vorbildern: die neue Stelle prüft `GetActiveDocument()` auf NULL, die Vorbilder nicht. Strenger, nicht schlechter.

### Gegenvermutungen

- *Ein Fenster mit mehreren Ansichten wird ohne Frage geschlossen.* `CDocument::CanCloseFrame` liefert TRUE ohne Frage, wenn noch ein anderes Fenster dasselbe Dokument zeigt; geschlossen wird aber nur `pFenster`, das Dokument bleibt im anderen Fenster offen. Danach hält `RemoveSum` das Dokument über `NukeMessageDocIfUnused` sauber. Gleiches Verhalten wie Xfer - kein Fund (Vermutung, für Nachrichtenfenster praktisch nicht erreichbar).
- *Während des modalen Dialogs ändert sich die Liste.* Die innere Schleife sucht nach jeder Runde neu über `E184FindeVorabKopie`, hält keinen Listenzeiger über den Dialog - kein Fund (am Quelltext belegt).

## Funde

### K1 - Fensterzeiger wird über den Dialog hinweg gehalten (gering)

`pFenster` wird vor `CanCloseFrame` gelesen und nach dem modalen Dialog für `PostMessage` weiterverwendet (ImapToc.cpp:1775, 1790). Würde das Fenster während des Dialogs anders geschlossen, wäre der Zeiger veraltet. Ein Meldungsfenster von `AfxMessageBox` sperrt aber das Hauptfenster und damit die MDI-Kinder; erreichbar ist das praktisch nicht (Vermutung). Xfer und ImapActionQueue.cpp:2654 machen es genauso. Kein Handlungsbedarf; wer die Stelle ohnehin anfasst, kann nach dem Dialog `pSum->m_FrameWnd` neu lesen.

## Messung

- Testsuite im Baum `.wt/pruefer`: 355 Tests, 355 bestanden, 0 fehlgeschlagen (gemessen, 01.11.2026). Die Tests erreichen `E189VorabKopienEntfernen` nicht (Fensterpfad); die Prüfung oben ist Quelltextprüfung.
- Keine Gegenprobe an der Quelle, kein Eudora-Bau, kein Prüfstand (Auftrag).

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | Fensterzeiger über modalen Dialog gehalten, praktisch nicht erreichbar; wie in den Vorbildern | gering | nein |
