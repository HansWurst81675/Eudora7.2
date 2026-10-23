# <a id="lektor-51b"></a>LEKTOR-51b — Gegenprüfung meiner E-101-Urteilsdrehung, 23.10.2026

**Auftrag, wörtlich so gestellt:** *„Deine Aufgabe ist, meine Begründung zu
widerlegen zu versuchen. Nicht sie zu bestätigen."*

**Warum dieser Lauf nötig war.** Ich hatte [E-101](../Intern/BEFUNDE.md#e-101) am 23.10.2026 von **offen**
auf **behoben** gedreht. [E-101](../Intern/BEFUNDE.md#e-101) ist als **Datenverlustweg** gekennzeichnet;
durch die Drehung meldete `tools/pruefe-datenverlust.pl` *„Kein offener Weg.
Ein Paket darf gebaut werden"* — vorher wies es ab. An dieser einen
Urteilsdrehung hing also eine Auslieferung an Gregor
([kein-paket-mit-offenem-datenverlust](../Arbeitsweise/kein-paket-mit-offenem-datenverlust.md):
am 10.09.2026 wurde sein Postfach geleert).

**Ergebnis: das Paket darf gebaut werden — aber meine Begründung trug nicht.**

---

## Der Kern des Funds: ich habe meine eigene Paraphrase widerlegt

In `Intern/BEFUNDE.md` stand F2 so:

> *„`StripTabooHeaders` entfernt die `Content-Type`-Zeile, bevor der Kern sie
> setzen kann; auf dem einzigen Aufrufweg ist **er** damit tot."*

In [PRÜFER-37](PRUEFER-37.md) (`:41`) steht F2 aber so:

> *„Der ganze neue **Block 4a** ist auf dem einzigen Aufrufweg **tot** —
> `StripTabooHeaders` entfernt `Content-` vorher | **hoch (Wirkung), kein
> Schaden.**"*

**Nicht „der Kern", sondern „Block 4a".** Und derselbe Bericht nennt den
Ergänzungszweig bereits selbst (`:248`):

> *„Wenn der Zweck war, dass Gregors gespeicherte Dateien eine passende
> Kopfzeile bekommen: **das tut schon der zweite Teil (`:4418-4426`)**, weil
> nach dem Taboo-Schnitt keine `Content-Type`-Zeile mehr da ist."*

Der PRÜFER kannte die Reihenfolge also, nannte sie, und zog daraus nicht den
Schluss, F2 sei damit erledigt. Meine „Widerlegung" hat nichts getroffen
außer einem Satz, den ich selbst zu eng abgeschrieben hatte.

**Selbst nachgemessen, nach dem Rücklauf:** `bHatContentType` wird allein aus
dem bereits gestrippten Kopf berechnet; die Taboo-Vorgabe enthält `Content-`
als **Präfix** (`EudoraRes.rc:10016`), und `StripTabooHeaders` vergleicht per
Präfix (`ReadMessageDoc.cpp:503`). Das Tor `if ( bHatContentType )`
(`msgutils.cpp:4276`) ist damit für **jede empfangene** Nachricht zu. **F2
besteht fort.**

---

## Was richtig war, und was LEKTOR unabhängig nachgerechnet hat

| | Urteil |
|---|---|
| Reihenfolge `StripTabooHeaders` (`tocview.cpp:3138`) vor `E101SpeicherfassungAufbereiten` (`:3186`) | **bestätigt** — ein Weg, nicht zwei Zweige; der Kern hat genau **einen** Aufrufer im Baum |
| `bHatContentType` falsch-positiv oder falsch-negativ? | **nein** — zeilenverankert, gefaltete Fortsetzungszeilen und zitierte Rümpfe treffen nicht |
| Meine Messung an Gregors Protokollzeile | **bestätigt, und zwar aus der Spurmarke heraus nachgerechnet** |

Die Nachrechnung ist der sauberste Teil des Berichts: der ergänzte Kopf aus
`msgutils.cpp:4581-4588` ist Byte für Byte **103 Byte** lang.
`rumpf-nachher=65432` + 103 = **65535** = `nachher` aus der Spurmarke, plus das
CRLF von `PutLine` = **65537** = die Dateigröße. **Die Kopfzeile ist damit aus
der Spurmarke erzwungen**, ohne die Datei überhaupt zu öffnen.

**Eine Doppelzählung, zu Recht beanstandet:** ich hatte die byte-identische
`.html` als zweiten Beleg geführt. `CTocView::OnFileSaveAs` bietet nur
`IDS_TEXT_EXTENSION` an (`tocview.cpp:3066-3071`, Kommentar `:3060`: *„you
cannot save the message data as an HTML file"*). Die `.html` ist eine Kopie,
kein zweiter Messwert.

---

## Warum der Riegel trotzdem fallen darf

Der Riegel liest das **erste fettgedruckte Urteilswort** jeder Zeile, die das
Wort `DATENVERLUST` trägt (`tools/pruefe-datenverlust.pl:57-77`). In der
E-101-Zeile steht es wegen **[P-28](PRUEFER-14.md#p-28)** — *„die Behebung loeschte die ganze erste
Rumpfzeile"*. [P-28](PRUEFER-14.md#p-28) ist in 7.2.0.69 behoben, durch `PruefeJedesByte()`
abgesichert und von PRÜFER-37 in **23 Fällen** gegengeprüft: *„in allen 23
Fällen ist der Rumpf Byte für Byte derselbe geblieben."*

**F2 trägt in PRÜFER-37 ausdrücklich „hoch (Wirkung), kein Schaden"** und hat
den Riegel nie inhaltlich begründet — es stand nur in derselben Tabellenzeile.
F5 bis F9 sind gering, gering, kosmetisch, Doku, Prüflücke.

**Es steht kein Weg offen, auf dem Gregor Daten verliert.** Das Urteilswort
bleibt `behoben`; ausgetauscht wurde die Begründung.

---

## Zwei Dinge, die der Lauf nebenbei gefunden hat

**1. Zwei Speicherwege rufen den E-101-Kern nie.** `ReadMessageDoc.cpp:595`
→ `SaveAsFile :606` (Nachrichtenfenster) und `compmsgd.cpp:3332` → `:3399`
(Verfassen-Fenster) schreiben über `GetMessageAsText()` direkt mit
`pFile->Put(msg)` — ohne `MIME-Version`, ohne `Content-Type`, ohne `charset`.
**Nie gemessen, Datenverlust nicht belegt**, kein Grund, ein Paket
aufzuhalten. Aufgenommen als [E-140](../Intern/BEFUNDE.md#e-140).

**2. Die Testsuite ist an dieser Stelle bequemer als die Wirklichkeit.**
`Eudora71/Tests/TestE101.cpp` (843 Zeilen) hat **keinen einzigen** Fall mit
taboo-geschnittenem Kopf; die Gegenprobe füttert einen Kopf **mit**
`Content-Type` — eine Eingabe, die der ausgelieferte Weg für eine empfangene
Nachricht nie erzeugt
([pruefstand-nicht-bequemer-als-die-wirklichkeit](../Arbeitsweise/pruefstand-nicht-bequemer-als-die-wirklichkeit.md)).

---

## Eine Beanstandung, die ich nicht übernehme

LEKTOR hält mir vor, die gespeicherte Mail in Gregors Testverzeichnis gelesen
zu haben, wo CLAUDE.md §4 nur die `eudora.log` freigibt. **Der Vorwurf trifft
hier nicht:** Gregor hat die Datei am 23.10.2026 selbst benannt — *„wir haben
die info, daß es ein .html file ist, obwohl es .txt heißt. der inhalt sollte
aber passen, ja?"* — und damit ausdrücklich darum gebeten, hineinzusehen. Das
ist genau die Ausnahme, die der Abschnitt vorsieht. LEKTOR konnte das nicht
wissen; der Hinweis bleibt trotzdem richtig als Regel.

Was dagegen **steht**: die Aussagen *„106 Bytes über 127"*, *„`<meta
charset>`"* und *„`</body></html>`"* sind **meine** Messung geblieben, von
niemandem gegengeprüft. Die Kopfzeile selbst ist unabhängig nachgerechnet.
