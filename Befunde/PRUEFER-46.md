# <a id="pruefer-46"></a>PRUEFER-46 — vier offene Punkte nach 1.0.122, 23.10.2026

**Auftrag.** Der Quelltext hatte sich seit [PRÜFER-45](PRUEFER-45.md) nicht
geändert; geprüft wurden deshalb nicht Änderungen, sondern **vier konkrete
offene Punkte**, die am selben Tag entstanden waren. Dazu die Frage, die
unmittelbar an Gregors Paket hing.

**Ergebnis vorweg: kein Fund hält das Paket 1.0.122 auf.** Keiner ist eine
Verschlechterung gegenüber 1.0.121; an einer Stelle ist es besser.

---

## Der Kern, den PRÜFER-45 noch nicht hatte

**`sumlist` wird in `CTocDoc::Xfer` an genau einer Stelle gefüllt** —
`tocdoc.cpp:3001`, im Zweig `if (!ToOut)`. Selbst nachgezählt:
`sumlist.AddTail` kommt in der ganzen Funktion **einmal** vor.

Daraus folgt ein Satz, den vorher niemand hatte:

> **Bei jeder Übertragung nach `Out` ist `sumlist` leer — ausnahmslos.**

Zusammen mit dem Vorrangfehler in `tocdoc.cpp:3134` heißt das: bei einer
**IMAP-Quelle** läuft die ganze IMAP-Nachbearbeitung mit leerer Liste durch.
Die Gegenrichtung (lokale Quelle, IMAP-Ziel) ist korrekt abgesichert — der
Fehler ist **einseitig**.

Was dabei anläuft, am Quelltext belegt: die Fehlmeldung
`IDS_ERR_IMAP_NO_MSGS_XFERRED` (`EuImap/src/ImapToc.cpp:857`), bei
abgeschalteter Verbindung ein modaler Offline-Dialog (`:395`), bei
schreibgeschütztem Ordner ein zweiter Ja/Nein-Dialog (`:365-373`), eine
überflüssige Serververbindung (`:413`, `:423`) — und ein `EXPUNGE` (`:246-249`).

Aufgenommen als [E-141](../Intern/BEFUNDE.md#e-141).

### Die Einstufung, die ich gegen den Bericht geändert habe

PRÜFER nannte den `EXPUNGE` *„das Schwerste"*. **Selbst nachgemessen ist er
schmaler:** `ExpungeAfterDelete` liest nur die Kontoeinstellung
`IDS_INI_IMAP_REMOVE_ON_DELETE` (`ImapMailbox.cpp:6057-6063`), und auf dem
**normalen Löschweg** expunged Eudora bei eingeschalteter Einstellung ohnehin
sofort (`ImapToc.cpp:3148-3154`). Wer sie an hat, hat im Ordner im Regelfall
**keine** gelöscht-markierten Nachrichten liegen. Verloren gehen kann nur, was
ein **anderes Programm** oder ein Offline-Lauf seit dem letzten Abgleich
markiert hat.

**Deshalb `wichtig`, nicht `kritisch`** — und damit kein Riegel vor künftigen
Paketen. Die Einstufung ist eine Aussage über Schaden, nicht über Ärger.

---

## Der Merker `E125Abgelehnt`

**Reicht er?** Ja, für das, wofür er gebaut wurde. Die Ablehnung hat genau eine
Stelle (`tocdoc.cpp:2752`), der Merker wird dort als erstes gesetzt, vor
Protokollzeile, Dialog und `break`. Es gibt keinen zweiten Einsprung; die
früheren `return`s liegen **vor** der Schleife.

**Kann er gesetzt sein und etwas Falsches geschehen?** Nein — weil `sumlist`
bei `ToOut` nie gefüllt ist, kann das Überspringen keine nötige Arbeit
überspringen.

**Der Punkt, der zählt:** die Berichtigung aus [E-141](../Intern/BEFUNDE.md#e-141)
würde den Merker **vollständig ersetzen**. Er ist kein Irrtum, sondern eine
punktuelle Abhilfe für einen allgemeinen Fehler — und er schließt genau einen
der beiden `ToOut`-Fälle. Der andere ist
[E-142](../Intern/BEFUNDE.md#e-142): ein **Entwurf** aus einem IMAP-Ordner nach
`Out` liegt danach doppelt da, plus Fehlmeldung, plus `EXPUNGE`.

---

## Die Frage, die am Paket hing

**Kann ein Filter mit Ziel `Out` beim automatischen Mailabruf einen modalen
Dialog hochziehen, der den Abruf anhält?**

**Ja — aber das tat er vorher auch, mit demselben Dialog an derselben Stelle.**
Das ist die Antwort, die das Paket freigegeben hat.

Nachgerechnet: `Out` steht in der Postfachliste
(`QCMailboxDirector.cpp:159`) und wird beim Menübau nicht ausgenommen
(`:2074`); das Filterfenster benutzt dasselbe Transfer-Menü wie der Anwender
(`controls.cpp:316`, aus `filtersv.cpp:2206`). Der Abruf filtert im
**Hauptfaden** (`pop.cpp:1003`), `CFilter::Action` ruft `Xfer` je Nachricht
(`filtersd.cpp:1531`), und `AlertDialog` ist modal (`guiutils.cpp:905`).
`gbAutomationCall` schützt nicht (`Automation.cpp:145-150`).

**Warum es trotzdem keine Regression ist:** der alte Quelltext zeigte an
derselben Stelle `AlertDialog(IDD_STRIP_HEADERS)`, ebenfalls modal, und
`StripHeaders` war eine **lokale** Variable je `Xfer`-Aufruf. Die Zahl der
Dialoge ist dieselbe. Neu ist nur, dass keine unbrauchbare Nachricht mehr in
`Out` entsteht.

Aufgenommen als [E-143](../Intern/BEFUNDE.md#e-143), zusammen mit den beiden
kleineren Punkten K4 (falsche Auskunft bei gemischter Auswahl, kein
Datenverlust) und K5 (`ASSERT` auf dem Filterweg). K6 bleibt ohne eigenen
Eintrag: unverändert gegenüber jedem früheren Abbruchweg.

---

## Die Prüflücke bei E-101 — bestätigt, aber anders als gemeldet

LEKTOR hatte geschrieben, `TestE101.cpp` habe *„keinen einzigen Fall mit
taboo-geschnittenem Kopf"*. **Formal richtig, aber irreführend:**
`kSelbstVerfasst`, `kNurText`, `kZitatImRumpf` und weitere sind strukturell
genau das — Kopfzeilen da, kein `Content-Type`. Der **Ergänzungszweig** ist
also sehr wohl geprüft.

**Was wirklich fehlt:** die Verbindung *Kopfzeilen da + kein `Content-Type` +
ein falsches `<meta charset>` im Rumpf* kommt in 843 Zeilen kein einziges Mal
vor — und das ist der **Normalfall jeder empfangenen HTML-Mail**. Jede Vorlage
mit `<meta>` bringt einen `Content-Type` mit und läuft damit in den toten
Zweig; jede ohne `Content-Type` hat kein `<meta>`.

Am eigenen Prüfstand gemessen (`C:\Temp\E80b\Mailverzeichnis\In.mbx`,
55 Nachrichten mit `<x-html>`): eine Nachricht trägt im Kopf
`multipart/mixed` mit einer Grenzzeichenkette, die im Rumpf **0-mal** vorkommt
— Eudora hat sie beim Empfang schon auf einen Teil zusammengelegt. Das ist
zugleich die Entwarnung zu einer naheliegenden Sorge: der ergänzte
`Content-Type: text/html` ist in diesem Fall **richtig**.

**PRÜFER hat den fehlenden Testfall fertig formuliert** — einzusetzen in
`Eudora71/Tests/TestE101.cpp` hinter dem Block *dritter Teil*. Er steht noch
nicht drin; das ist der nächste Handgriff an dieser Stelle.

Dazu zwei kleinere Punkte an derselben Datei: die Begründung der Gegenprobe
`kEmpfangen` (*„an einer empfangenen Nachricht ist nichts zu tun"*) stimmt auf
dem ausgelieferten Weg nicht und gehört umgeschrieben; und der ganze dritte
Teil der Suite hängt daran, dass `Content-` in der Taboo-Vorgabe steht — nimmt
jemand es heraus, wird der tote Zweig schlagartig lebendig, und kein Test
merkt es ([schranke-teilt-nicht-die-annahme](../Arbeitsweise/schranke-teilt-nicht-die-annahme.md)).

---

## Urteil zum Paket

| Fund | vor 1.0.122 | in 1.0.122 |
|---|---|---|
| [E-141](../Intern/BEFUNDE.md#e-141) | genauso, zusätzlich mit Fehlmeldung bei abgelehnten Übertragungen | **unverändert für Entwürfe, besser für empfangene Nachrichten** — der Merker schaltet dort sogar den `EXPUNGE` ab |
| [E-142](../Intern/BEFUNDE.md#e-142) | genauso, mit Ja/Nein-Dialog davor | unverändert |
| [E-143](../Intern/BEFUNDE.md#e-143) | **dieselbe Anzahl** Dialoge, derselbe modale Kasten | ein Knopf statt Ja/Nein, keine unbrauchbare Nachricht mehr |
| Prüflücke [E-101](../Intern/BEFUNDE.md#e-101) | bestand schon | besteht fort, **kein Datenverlustweg** |

**Nichts davon hält 1.0.122 auf.**

**Was NICHT geprüft ist:** nichts davon ist am laufenden Programm gemessen —
alle Aussagen sind am Quelltext belegt, die einzige echte Messung ist die an
`In.mbx`. Gregors Lauf zu [TESTPLAN M3](../Intern/TESTPLAN.md#m3-e125) bleibt
das, was fehlt.
