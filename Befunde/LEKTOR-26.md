# <a id="lektor-26"></a>LEKTOR-26 — Die Dokumentation nach dem Verlinken (`97f50c8..HEAD`)

Lauf am 12.10.2026 auf `wt/lektor`, angestoßen von Gregor (*„mach lektor"*).
Umfang: alle 102 `.md` aus `git ls-files` ohne `Arbeitsweise/`, gegen den
**Bestand** geprüft, nicht gegen den Diff. **Alle zehn Mängel sind im selben
Commit wie dieser Bericht behoben.**

Mechanisch zuerst, und da war nichts: `doku-pruefen.pl`, `pruefe-stand-md.pl`,
`pruefe-befundurteile.pl`, `pruefe-befund-verbreitung.pl`, `offene-befunde.pl`,
`pruefe-behoben-belegt.pl`, `pruefe-anzeigetext.pl`, `pruefe-rollen-doku.pl`,
`pruefe-datenverlust.pl`, `pruefe-doku-takt.pl` — **alle zehn grün**.
`paket-bereit.pl`: 7 von 8 frei, die achte war dieser Lauf selbst.
Bestand: Quellstand **7.2.0.84** (`Version.h`), Paket **1.0.84** (`VERSION`),
veröffentlicht **v1.0.84** (GitHub, `draft=false`, `prerelease=false`,
12.10.2026 12:59:15 UTC). Alles drei stimmt überein.

Die zehn Mängel hat keine Schranke gefunden. Das ist der eigentliche Befund.

## Mängel

### <a id="l-18.1"></a>L-18.1 — `tools/verweise-filtern.pl` stand in keiner Zeile von `WERKZEUGE.md`

Heute gebaut, heute eingehängt, heute vergessen. `CLAUDE.md` sagt: *„`tools/WERKZEUGE.md`
führt den vollständigen Bestand — **dort nachsehen, bevor etwas Neues gebaut
wird.**"* Gemessen: 106 Werkzeuge im Baum, 105 Zeilen in der Tabelle.
Nachgetragen.

### <a id="l-18.2"></a>L-18.2 — `tools/pruefe-testdaten-anonym.pl` ebenso

Ältere Schuld, gleiche Klasse. Die Schranke läuft in **jedem** `pre-commit`
und gibt dort sieben Zeilen aus — und stand in der Übersicht nicht. Wer
nachsieht, was es gibt, hätte sie ein zweites Mal gebaut. Nachgetragen.

### <a id="l-18.3"></a>L-18.3 — `README.md` nennt `TESTPLAN.md` nicht

Die Tabelle *„Wo finde ich was?"* hat dreizehn Zeilen und führte **nicht** zu
dem Dokument, das Gregor am 12.10.2026 ausdrücklich bestellt hat
(*„jetzt machen wir einen testplan"*). `TESTPLAN.md` war aus `AUFGABEN.md`,
`WEITERMACHEN.md` und `tools/ZWEIGE.md` erreichbar — aus keinem Dokument, das
ein Leser zuerst aufschlägt. Zeile eingefügt.

### <a id="l-18.4"></a>L-18.4 — `CHANGELOG.md` führt `E-94` unter *„Noch offen"* und `E-111` gar nicht

[E-94](../BEFUNDE.md#e-94) ist **behoben in 7.2.0.84 und von Gregor am 12.10.2026 bestätigt** — die
Zelle sagt das selbst, sie steht nur unter der falschen Überschrift. Der Leser
trifft zuerst auf *„Noch offen"*. Umgekehrt führt `WEITERMACHEN.md` [E-111](../BEFUNDE.md#e-111)
als offen und `CHANGELOG.md` kannte ihn in der offenen Liste nicht.
`pruefe-befundurteile.pl` greift hier nicht: sie liest ein Umfeld von 40
Zeichen um die Kennung, und die Überschrift steht sieben Zeilen weiter oben.
E-94-Zeile entfernt (der Abschnitt 7.2.0.84 trägt dieselbe Aussage vollständig),
E-111-Zeile eingefügt.

### <a id="l-18.5"></a>L-18.5 — `TESTPLAN.md` lässt die fünfzehnte wartende Behebung aus

`BEFUNDE.md` führt **fünfzehn** Behebungen als *„von Gregor noch nicht
bestätigt"*: die vierzehn aus Teil A und [E-101](../BEFUNDE.md#e-101). Teil C3 heißt *„Die fünf, die
auf dein Urteil warten"* und nennt [E-101](../BEFUNDE.md#e-101) nicht — die Nachricht, die gespeichert
für jedes andere Programm unbrauchbar war. Ausgerechnet die aus der
Datenverlustklasse. Als sechster Punkt aufgenommen, Überschrift berichtigt.

### <a id="l-18.6"></a>L-18.6 — `WEITERMACHEN.md` behauptet eine Abweisung, die nicht stattfindet

Wörtlich: *„`tools/release-pruefen.pl` weist deshalb ab."* Gemessen am Werkzeug:
es schreibt *„Release stimmt zum Quellstand (QCSSL 1.0.1) — mit dem Hinweis
oben. **Der weist nicht ab.**"* und gibt **3** zurück, den Hinweiscode. Der Satz
stammt aus einer Zeit, in der das anders war, und steht seither als Begründung
für eine Aufgabe da, deren Dringlichkeit er erfindet. Berichtigt.

### <a id="l-18.7"></a>L-18.7 — `BEFUNDE.md` vermisst sich selbst falsch

Zeile 9: *„Gemessen am 11.10.2026: **8388 Zeilen**, **127** Abschnitte auf
zweiter und **227** auf dritter Ebene."* Direkt darunter stehen die drei
Befehle zum Nachzählen. Sie liefern **8614**, **128** und **233**. Eine Datei,
die ihre eigene Messung mitliefert und dabei falsch liegt, lehrt den Leser, der
Messung nicht zu trauen. Nachgemessen und berichtigt.

### <a id="l-18.8"></a>L-18.8 — `CLAUDE.md` nennt zwei veraltete Zahlen

*„`BEFUNDE.md` hat über 7800 Zeilen"* (8614) und *„Es gibt über 80 Werkzeuge"*
(106). Beide Sätze stehen in der Begründung dafür, **warum** man vor dem Suchen
und vor dem Bauen nachsieht — und untertreiben genau das Argument, das sie
tragen sollen. Auf 8600 und 100 gezogen.

### <a id="l-18.9"></a>L-18.9 — `PRUEFUNG-BRANCH.md:29` schreibt `NP3-6/7`

Kurzform für [NP3-6](../BEFUNDE.md#np3-6) und [NP3-7](../BEFUNDE.md#np3-7). Die zweite Kennung steht nicht da, also
kann kein Werkzeug sie finden und kein Leser sie anklicken. Gregor hat genau
diese Zeile gemeldet. Ausgeschrieben.

### <a id="l-18.10"></a>L-18.10 — die Verlinkung von PR #90 hatte vier Lücken, und alle vier hat Gregor gefunden

Das ist der Mangel mit dem höchsten Preis, weil er frisch war. Gemeldet in vier
Nachrichten hintereinander:

| gemeldet | Ursache | behoben |
|---|---|---|
| *„e-85 fehlt"* | ich verlinkte nur die **erste** Nennung je Absatz — meine Sparsamkeit, nicht sein Wunsch. Er hatte *„überall"* gesagt | jede Nennung |
| *„Dazu fehlten [E-98](../BEFUNDE.md#e-98) bis [E-101](../BEFUNDE.md#e-101) — hier auch!"* | der Fettdruck wurde als Einheit gefasst und das Sternchenpaar auf beiden Seiten verlangt; in `**E-98 bis E-101**` steht es nur außen, also blieben **beide** unverlinkt | nur die Kennung wird Link, der Fettdruck bleibt stehen |
| *„[L-17](LEKTOR-12.md#l-17) usw. - links fehlen!"* | [L-17.1](LEKTOR-17.md#l-17.1), [LEKTOR-20](LEKTOR-20.md#lektor-20), [P-42](PRUEFER-16.md#p-42), [W-2](LEKTOR-4.md#w-2) stehen **nicht** in der Urteilstabelle von `BEFUNDE.md`, sondern haben ihre Überschrift in einem Bericht unter `Befunde/`. Das Werkzeug kannte nur ein Verzeichnis | zweites Verzeichnis, 239 Kennungen |
| *„Offen bleibt [B5.7](../AUFGABEN.md#b5.7) … link fehlt"* und *„links in der tabelle fehlen"* | `B5.7` hat keinen Bindestrich und fiel durch jedes Muster; und die Markentabelle in `TESTPLAN.md` schreibt `` [`E-78`](../BEFUNDE.md#e-78) `` in Rückstrichen, die das Werkzeug grundsätzlich schützt | drittes Verzeichnis für Abschnittskennungen; ein Rückstrichstück, das **nur** aus einer Kennung mit Bindestrich besteht, wird verlinkt |

**Zwei Fallen, die beim Beheben aufgingen und nicht übersehen werden dürfen:**

1. `B1`, `E1`, `B7` sind **nicht eindeutig**. In `Befunde/LEKTOR-6.md` heißen
   sie etwas anderes als in `TESTPLAN.md`, und `BEFUNDE.md:6839` benutzt
   `` `B7` `` als **Byte 0xB7**. Abschnittskennungen ohne Punkt werden deshalb
   nur **innerhalb ihrer eigenen Datei** verlinkt; `B5.7` mit Punkt gilt
   überall. Ein falscher Link ist schlimmer als ein fehlender.
2. Rückstrichstücke mit mehr als einer Kennung bleiben unangetastet:
   `` `grep "E-78\|E-70" eudora.log` `` ist ein Befehl zum Kopieren, kein Verweis.

### <a id="l-18.11"></a>L-18.11 — drei weitere Schranken wurden vom Verlinken blind, und zwei meldeten trotzdem grün

Nachgemessen gegen einen Arbeitsbaum auf `97f50c8`, Werkzeug für Werkzeug:

| Schranke | vorher | nach dem Verlinken |
|---|---|---|
| `spuren-auswerten.pl` | frei | **weist ab** — meldet vier vorhandene Zeilen in `Befunde/SPURMARKEN.md` als fehlend |
| `pruefe-behoben-ausgeliefert.pl` | 17 Urteile geprüft, 8 bestätigt | **0 Urteile, 0 bestätigt — und Rückgabewert 0** |
| `pruefe-befund-verbreitung.pl` | Umfang [`E-94`](../BEFUNDE.md#e-94) | Umfang `(keine)` — und Rückgabewert 0 |

Alle drei lesen die **erste Zelle** der Urteilstabelle und kamen mit dem Anker
davor nicht zurecht. Die lautere der drei weist wenigstens ab; die beiden
anderen prüfen nichts und sagen *grün* — genau der Zustand, den [E-109](../BEFUNDE.md#e-109) Punkt (4)
beschreibt: *„ein Freispruch über eine leere Menge"*.

Alle drei überspringen den Anker jetzt. Belegt: jede der neunzehn `pruefe-*`-
Schranken liefert gegen den Arbeitsbaum auf `97f50c8` dieselbe Ausgabe wie
vorher, bis auf drei erklärbare Unterschiede (ein Pfadname, der abgelöste HEAD
des Vergleichsbaums, und `pruefe-stand-md.pl`, das diesen Bericht mitzählt).

**Damit sind es an einem Tag zwölf Werkzeuge, die dieselbe Zeile falsch gelesen
haben** — sieben beim ersten Lauf, drei hier, dazu `pruefe-anzeigetext.pl` und
`pruefe-behoben-belegt.pl` über den Zuwachs. Die Lehre steht schon in [E-109](../BEFUNDE.md#e-109):
wer den Umfang aus derselben Annahme nimmt wie das Werkzeug, das er prüfen
soll, prüft nichts.

## Was offen bleibt

* **CHRONIST ist fällig** (`rollen-faellig.pl`), seit seinem Bericht `1be7554`
  haben sich 14 Dateien in seinem Bereich geändert. Nicht mein Auftrag.
* **Die Streuung selbst.** Dieselbe Kennung steht im Schnitt an sieben Stellen,
  [E-112](../BEFUNDE.md#e-112) an siebzehn in sechs Dateien. Jetzt ist jede davon anklickbar — aber
  *eine* Beschreibung an *einer* Stelle wäre die Antwort auf Gregors Satz
  *„daß die infos nicht überall verteilt sind"*. Das ist eine Umarbeitung an
  den Dokumenten und wartet auf seine Entscheidung.
