## E-24 — Unter „Recent" stand „In" zweimal

**Agent:** POSTFACH · **Zweig:** `wt/postfach-2` · **Datum:** 05.09.2026 ·
**Fassung:** 7.2.0.10 · **Status:** behoben

Gregor am 05.09.2026, Fehlerliste zur Fassung 7.2.0.10: *„2x in unter recent"*.
Im Postfachbaum links stand unter dem Ordner **Recent** der Eintrag **In**
zweimal — beide mit demselben Symbol wie das echte „In".

### Was zuerst geprüft wurde

Der Verdacht lautete: der Ini-Abschnitt `[Recent Mailboxes]` enthalte zwei
Zeilen, die auf dasselbe Postfach zeigen, aber verschieden geschrieben sind.

**Das trifft nicht zu.** Gregors Ini
`C:\Users\Gregor\Eudora72-1.0.10-release\Mailverzeichnis\Eudora.ini` enthält
genau zwei Abschnitte:

```
[Settings]
[Mappings]
```

Einen Abschnitt `[Recent Mailboxes]` gibt es dort **nicht** — und auch in
keiner der fünf anderen Mailverzeichnis-Ini-Dateien unter `C:\Users\Gregor`
(Fassungen 1.0.8, 1.0.9 und 1.0.10, jeweils Debug und Release). Alle sechs
Dateien sind byte-gleich der Auslieferungsfassung vom 30.08.2026.

Der Doppeleintrag entsteht also **ohne jedes Zutun der Ini**, allein aus dem
Programmablauf bei einem frischen Mailverzeichnis. Das erklärt auch, warum
Gregor ihn direkt nach dem ersten Start gesehen hat.

### Ursache

`Eudora71/Eudora/QCMailboxDirector.cpp`, Zeile 2560 (Stand vor der Änderung):

```cpp
	// Put the In mailbox in the list if there's nothing in it, just so that it's not empty
	if (s_RecentMailboxList.empty())
		s_RecentMailboxList.push_front(CRString(IDS_IN_MBOX_FILENAME) + CRString(IDS_MAILBOX_EXTENSION));
```

`s_RecentMailboxList` ist ein `std::list<LPCTSTR>` — die Liste hält **rohe
Zeiger**, keine Zeichenketten. Der Kommentar zwanzig Zeilen darüber erklärt
den Kniff: die Zeiger sollen in die `CString`-Puffer der `QCMailboxCommand`-
Objekte zeigen, die bis zum Programmende bestehen bleiben. Der Vergleich
zweier Einträge ist dann ein Zeigervergleich und trifft trotzdem zu.

Die Ersatzzeile bricht genau diese Voraussetzung: `CRString(...) + CRString(...)`
erzeugt eine **temporäre** `CString`. Der daraus gewonnene `LPCTSTR` zeigt in
einen Puffer, der schon am Ende dieser Anweisung freigegeben wird. Er ist
damit erstens ein hängender Zeiger und zweitens mit keinem echten Eintrag
zeigergleich.

Der Ablauf bei einem frischen Mailverzeichnis:

1. `QCMailboxTreeCtrl::UpdateRecentFolder()` ruft `BuildRecentMailboxesList()`.
2. `[Recent Mailboxes]` ist leer → die Ersatzzeile legt den hängenden Zeiger ab.
   Der Baum zeigt **Recent → In**.
3. Eudora öffnet das Postfach „In". `CTocView::OnInitialUpdate`
   (`tocview.cpp:2950`) ruft `UpdateRecentMailboxList(".../In.mbx", TRUE)`.
4. Dort (`QCMailboxDirector.cpp:2584`):
   `*(s_RecentMailboxList.begin()) != RelativePathname` — Zeigervergleich,
   ergibt „ungleich".
   `s_RecentMailboxList.remove(RelativePathname)` — `std::list::remove`
   vergleicht bei `LPCTSTR` ebenfalls die **Zeiger**, entfernt also nichts.
   `push_front(RelativePathname)` — die Liste hat jetzt **zwei** Einträge.
5. `UpdateRecentFolder()` löst beide über `FindByPathname` auf, findet zweimal
   dasselbe `QCMailboxCommand` und hängt **zwei Baumeinträge „In"** ein — mit
   demselben Symbol.

Antworten auf die Prüffragen:

* Wird beim Hinzufügen geprüft, ob das Postfach schon in der Liste steht?
  Ja, aber **über den Zeiger**, nicht über den Inhalt.
* Wie wird verglichen? Gar nicht auf Zeichenebene. Weder
  groß-/kleinschreibungsunabhängig noch normalisiert; `GetFullPathName` kommt
  nirgends vor. Der Zeigervergleich trägt nur, solange **jeder** Eintrag aus
  einem `QCMailboxCommand` stammt — und genau das hielt die Ersatzzeile nicht ein.
* Gibt es eine Obergrenze? Ja, `MaxRecentMailbox` (Vorgabe 10). Sie wird auf
  die Liste angewendet (`resize`), aber **nicht auf die Ini**: wird die Liste
  kürzer, bleiben die überzähligen Zeilen `Mailbox07`…`Mailbox10` stehen und
  werden beim nächsten Start wieder eingelesen. Das ist eine zweite, davon
  unabhängige Quelle für Doppeleinträge.

### Was geändert wurde

Alles in `Eudora71/Eudora/QCMailboxDirector.cpp`:

1. **Neue Hilfsfunktionen** `RecentPathsEqual`, `RecentListContains`,
   `RecentListRemove` (vor `BuildRecentMailboxesList`). Sie vergleichen den
   **Inhalt** mit `stricmp`, also ohne Rücksicht auf Groß-/Kleinschreibung.
2. **`BuildRecentMailboxesList`, Ersatzeintrag:** statt eines Zeigers auf eine
   temporäre `CString` wird das Postfach „In" über `FindByPathname` gesucht und
   dessen dauerhafter Zeiger abgelegt. Wird es nicht gefunden, bleibt die Liste
   leer — der Ordner „Recent" ist dann eben leer, was der Baum verträgt.
   *Das ist die Behebung des gemeldeten Fehlers.*
3. **`BuildRecentMailboxesList`, Einlesen:** ein Eintrag wird übersprungen,
   wenn dasselbe Postfach schon in der Liste steht. Damit heilt eine bereits
   doppelte Ini beim nächsten Start von selbst — Gregor muss nichts von Hand
   löschen.
4. **`UpdateRecentMailboxList`:** `std::list::remove` (Zeigervergleich) durch
   `RecentListRemove` (Inhaltsvergleich) ersetzt, in beiden Zweigen.
5. **`UpdateRecentMailboxList`, Zurückschreiben:** überzählige Ini-Zeilen
   werden mit `WriteEudoraProfileString(..., NULL)` gelöscht, damit sie beim
   nächsten Start nicht wieder auftauchen.

### Muss Gregor seine Ini anfassen?

**Nein.** Punkt 3 überspringt Doppelte schon beim Lesen, Punkt 5 räumt beim
nächsten Schreiben auf. In seinem Fall gibt es ohnehin nichts zu heilen: der
Abschnitt `[Recent Mailboxes]` steht gar nicht in seiner Datei.

### Nebenbefund: `QCMailboxDirector.cpp:1316` mitbehoben

Der Agent KETTE hatte diese Stelle als die gefährlichste der 24
`ReleaseBuffer`-Fundstellen eingestuft. Sie liegt in derselben Datei und wurde
gleich mit erledigt:

```cpp
	if (!::LongFileSupportMT(szNewDir))
		szFilename.ReleaseBuffer(8 - szCount.GetLength());
```

`ReleaseBuffer(n)` ohne vorangehendes `GetBuffer` kürzt nicht, sondern setzt
die Länge hart. `CStringT::SetLength` prüft `n <= GetAllocLength()` mit
`ATLENSURE` und löst sonst `AtlThrow` aus. Gemeint war ein Abschneiden auf acht
Zeichen für Datenträger ohne lange Dateinamen. Ersetzt durch:

```cpp
	if (!::LongFileSupportMT(szNewDir))
	{
		const int nKeep = 8 - szCount.GetLength();
		szFilename = (nKeep > 0)? szFilename.Left(nKeep) : CString();
	}
```

`CString::Left` verträgt ein `n` größer als die Länge und gibt dann die ganze
Zeichenkette zurück — das ist genau das gewünschte Verhalten.

### Prüfanleitung für Gregor

1. Mailverzeichnis leeren (nur `Eudora.ini` stehen lassen), Eudora starten.
2. Im Postfachbaum links **Recent** aufklappen. Dort darf **genau ein** „In"
   stehen.
3. „Out" öffnen, dann „Trash", dann wieder „In". Unter „Recent" müssen drei
   verschiedene Einträge stehen, keiner doppelt, „In" ganz oben.
4. Eudora beenden und in `Mailverzeichnis\Eudora.ini` den Abschnitt
   `[Recent Mailboxes]` ansehen: drei Zeilen `Mailbox01`…`Mailbox03`, jede
   ein anderes Postfach.
5. Gegenprobe für die Heilung: in diesem Abschnitt von Hand eine Zeile
   `Mailbox04=in.mbx` ergänzen (kleingeschrieben). Nach dem nächsten Start
   darf „In" unter „Recent" trotzdem nur einmal stehen.
