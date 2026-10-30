# <a id="lektor-100"></a>LEKTOR-100 — WEITERMACHEN nach dem Umbau: die Liste „Nach dem Release 7.2.1“ gegen ihre Quellen

**Datum:** 30.10.2026 · **Geprüft:** Commit `9369fb63` auf `weitermachen-aufraeumen` · **Arbeitsbaum:** `wt/lektor-20261030`

**Auftrag.** Alle MDs gegen den Bestand, Schwerpunkt der Umbau von
`Intern/WEITERMACHEN.md` (548 → 224 Zeilen, Rest nach
`Intern/WEITERMACHEN-bis-7.2.0.md`, Schranke `tools/pruefe-nach-dem-release.pl`):
(a) ging etwas verloren, (b) stimmt jede Zeile der Liste mit ihrer Quelle,
(c) fehlt eine offene Aufgabe, (d) behauptet eine andere Datei noch etwas
über die alte Gestalt. **Alle Zeilenangaben gelten für `9369fb63`.** Nichts
gebaut, nichts gestartet, kein Prüfstand. **In diesem Bericht steht nichts
aus Gregors Rechner oder Postfach.**

**Ergebnis vorweg.** Die drei Funde aus [LEKTOR-99](LEKTOR-99.md#lektor-99)
sind erledigt. Der Umbau selbst hat nichts verloren: jede Zeile der alten
Datei steht in der neuen oder im Archiv (gemessen). Die Liste hat aber
**Lücken und zwei falsche Zeilen**. **11 Funde.** Die drei wichtigsten:

* **Der Rückstand an Regressionstests steht in keiner Liste mehr**
  ([L-100.1](#l-100.1)). Gregor hat am 23.10. angeordnet, ihn *vor jedem
  neuen Thema* abzuarbeiten. `ZIEL.md:113` schickt für „Liste und
  Reihenfolge“ nach WEITERMACHEN. Dort steht er nicht mehr, nur noch im
  Archiv, in einem Block, der als überholt markiert ist.
* **`Intern/AUFGABEN.md` ist weiter eine zweite Aufgabenliste**
  ([L-100.2](#l-100.2)). WEITERMACHEN sagt, was zu tun ist, stehe *„an genau
  einer Stelle“*. Die Schranke prüft nur WEITERMACHEN.
* **[E-13](../Intern/BEFUNDE.md#e-13) (beim Mailabruf ist kein Fortschritt
  sichtbar) fällt durch beide Listen** ([L-100.10](#l-100.10)). Der Befund
  sagt, die Behebung liege auf einem Zweig, den es nicht mehr gibt. Sie ist
  seit September in `HEAD`, gemessen hat sie seither niemand.

---

## Funde aus LEKTOR-99

| Fund | Was es war | Heute | Beleg |
|---|---|---|---|
| [L-99.1](LEKTOR-99.md#l-99.1) | Anwenderhandbuch nannte `v1.0.120` als aktuell | **erledigt** | `Doku/ANWENDER.md:275` *„`v7.2.1.128` (in `v1.0.120` war er noch nicht enthalten)“* (gemessen) |
| [L-99.2](LEKTOR-99.md#l-99.2) | AUFGABEN: „draußen ist seit dem 21.10.2026 `v1.0.120`“ | **erledigt** | `Intern/AUFGABEN.md:118` *„seit dem 29.10.2026 ist `v7.2.1.128` draußen“* (gemessen) |
| [L-99.3](LEKTOR-99.md#l-99.3) | WEITERMACHEN „Zuletzt von Gregor bestätigt“ bei 1.0.101 | **erledigt**, die Zeile ist ins Archiv gewandert | `Intern/WEITERMACHEN-bis-7.2.0.md:59` nennt 7.2.1.128 am 29.10.2026; der neue Kopf `Intern/WEITERMACHEN.md:3-5` *„Veröffentlicht ist `v7.2.1.128` (29.10.2026, nach Gregors Test …)“* (gemessen) |

## Mechanisch zuerst (zitiert, nicht als Urteil übernommen)

| Werkzeug | Ausgabe | Einordnung |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„gepruefte Dateien 50 … Kein Widerspruch gefunden.“*, dazu 15 Dateien „Zur Kenntnis“ | die Liste sind alte Release-Notizen und Archive; Rauschen |
| `perl tools/offene-befunde.pl` | *„offen laut Intern/BEFUNDE.md 46 … in Intern/WEITERMACHEN.md 46 … in beiden Listen gleich.“* | zählt nur Urteile, die mit „offen“ beginnen; [E-13](../Intern/BEFUNDE.md#e-13) (*„Ursache belegt“*) und PR-2.2–2.7 (*„Bericht“*) sieht es nicht, siehe [L-100.10](#l-100.10) |
| `perl tools/pruefe-regressionstest.pl` | *„behoben und OHNE Testfall 67 … kritisch 73 … OHNE jede Pruefung 24“* | das ist der Rückstand aus [L-100.1](#l-100.1) |
| `perl tools/ziel-stand.pl` | *„27 von 27 erfüllt, 0 offen“* | — |
| `perl tools/pruefe-nach-dem-release.pl --selbsttest` | *„13 von 13 Faellen richtig“*; ohne Schalter: keine Ausgabe, rc=0 | die Grenzen stehen in [L-100.9](#l-100.9) |
| `perl tools/pruefe-release-buchfuehrung.pl` | *„5 Datei(en), 4 Standaussage(n)“* | bei [LEKTOR-99](LEKTOR-99.md#lektor-99) waren es **5**; siehe [L-100.8](#l-100.8) |

## (a) Ist beim Umbau etwas verloren gegangen?

**Gemessen:** jede nichtleere Zeile von `git show 49041c22:Intern/WEITERMACHEN.md`
gegen die Summe aus neuer Datei und Archiv. Es fehlen wörtlich nur 25 Zeilen:

* Zeilen 122–140, die Entscheidungen 1 bis 19. Sie stehen in der neuen Datei
  (`:122-140`), nur ohne das Zitatzeichen `> `. Entscheidung 16 hat einen
  Verweis auf die Liste dazubekommen.
* Zeile 184, *„Angefangen und nicht fertig“*. Sie steht im Archiv
  (`:177`) und hat den Anker `angefangen` dazubekommen.
* Zeilen 356–365 und 420–424, Überschriften und Begleitsätze der alten
  Tabelle. Sachlich fehlt davon nur der Satz *„Keiner dieser Punkte ist
  Gregor zugewiesen“*. Den braucht die Liste nicht.

**Die Commit-Nachricht stimmt**: *„alle Stand-Bloecke und die Paketgeschichte
unveraendert (Zeilen 3-120, 141-355, 424-465 der alten Datei)“*. Der Umbau
hat also nichts gelöscht. **Verloren ist trotzdem etwas, nämlich die
Geltung.** Das Archiv sagt über sich selbst (`:7-8`): *„Aussagen wie
‚aktuell‘, ‚als Nächstes‘ oder ‚offen‘ gelten für den Tag ihres Blocks,
nicht für heute.“* Was nur dort offen steht und nicht in die Liste kam,
gilt damit nicht mehr als offen. Das betrifft [L-100.1](#l-100.1),
[L-100.5](#l-100.5) und [L-100.10](#l-100.10).

## (b) Die Liste gegen ihre Quellen

Alle Links und Anker beider Dateien sind vorhanden (gemessen mit einem
Ankerprüfer im Scratchpad, Positivprobe: drei absichtlich falsche Verweise
wurden alle drei gemeldet). Das gilt auch für `#offene-arbeiten`,
`#angefangen`, `#entscheidungen` und `#nach-dem-release`. Kein `.md` im Repo
verweist auf einen Anker der alten Datei, den es nicht mehr gibt (gemessen
über alle 407 Dateien).

Zeile für Zeile (`Intern/WEITERMACHEN.md`):

| Zeile | Urteil | Beleg |
|---|---|---|
| :32 Übersicht „Was Eudora kann“ | stimmt | Gregors Satz wörtlich in `Arbeitsweise/stand-29-10-2026.md`, Nachtrag 29.10. |
| :33 Formprüfung | stimmt, aber [L-100.4](#l-100.4) | kein Werkzeug in `tools/` (gemessen); [LEKTOR-96](LEKTOR-96.md#werkzeug) „Vorschlag, nicht gebaut“ |
| :34 Codespanne in `pruefe-tabellenzeilen.pl` | stimmt | `tools/pruefe-tabellenzeilen.pl:227` ersetzt weiter `` `…` `` vor dem Zählen (gemessen) |
| :35 Betriebsart „Pro“ | **falsch gewichtet** → [L-100.6](#l-100.6) | |
| :36 Testpaket gegen Release | stimmt | `tools/release-veroeffentlichen.ps1:67` *„`-notmatch '^\d+\.\d+\.\d+\.\d+$'`“*; `tools/ausliefern.pl:88` *„`$p1.$p2.$p3.` . ($p4+1)“* (gemessen) |
| :37 alte Nummernform | stimmt | `Releases/PAKETE.md:62` *„Produktversion `7.2.0.x`“* (gemessen) |
| :38 `Intern/FILTER.md` | stimmt | `Intern/FILTER.md:228` weiter *„`filtersd.cpp:1151-1155`“*; [LEKTOR-96](LEKTOR-96.md#lektor-96) fand es „größer als gemeldet“, verlinkt ist nur [L-92.2](LEKTOR-92.md#l-92.2) |
| :39–:41 Vorschläge 1, 2, 5 | stimmt | [CHRONIST 29.10. abends](../Arbeitsweise/CHRONIST-2026-10-29b.md), „Werkzeugmängel“ 1, 2, 5 |
| :42 Merge-Commit `80f340d5` | stimmt | ebenda, „Für die Hauptsitzung“ |
| :43 `MEMORY.md` kürzen | **Quelle falsch** → [L-100.7](#l-100.7) | |
| :44 Gregors Frage von 09:11 | stimmt | CHRONIST 29.10. abends und [CHRONIST 30.10.](../Arbeitsweise/CHRONIST-2026-10-30.md) (*„seither noch zweimal angekündigt“*); der zweite ist nicht verlinkt |
| :45 Kriterium 0 | stimmt | [L-77.3](LEKTOR-77.md#l-77.3) |
| :46 neun Messskripte | stimmt | alle neun vorhanden (gemessen, nur `test -f`) |
| :47 halbe Sätze | stimmt | `tools/pruefe-halbe-saetze.pl` gibt es nicht (gemessen) |
| :48 alte Punkte | stimmt, aber unvollständig → [L-100.5](#l-100.5) | die genannten Stellen gibt es: Archiv `:161`, `:319`, `:378`, `:385`, `Intern/AUFGABEN.md:849` (D3a) |

## (c) und (d) — die Funde

### <a id="l-100.1"></a>L-100.1 — Der Rückstand an Regressionstests steht in keiner Liste mehr; ZIEL schickt ins Leere

**Was passiert:** Gregor hat am 23.10. angeordnet, dass die fehlenden
Regressionstests *„ab der nächsten Sitzung vor jedem neuen Thema“*
nachgeholt werden. Die Reihenfolge dazu stand oben in WEITERMACHEN. Jetzt
steht sie nur noch im Archiv, in einem Block, der sich selbst „überholt“
nennt. ZIEL.md verweist weiter auf WEITERMACHEN.

* **Belegt**, `ZIEL.md:109-113` *„er wird ab der nächsten Sitzung **vor
  jedem neuen Thema** abgearbeitet — Liste und Reihenfolge stehen oben in
  [WEITERMACHEN.md](Intern/WEITERMACHEN.md).“*
* **Gemessen**, `Intern/WEITERMACHEN.md`: „Regressionstest“ kommt nur in
  `:48` vor (*„Regressionstests C“* als alter Punkt, der erst geprüft werden
  soll) und in `:126` (Entscheidung 5, wie oft eine rote Probe nötig ist).
* **Belegt**, Archiv `:145-151` *„Stand 24.10.2026 — überholt durch den
  Block vom 26.10.2026 darüber … 4. **Der übrige Rückstand an
  Regressionstests** — vor jedem neuen Thema. Dazu am Prüfstand rot und
  grün nachstellen: [E-69](../Intern/BEFUNDE.md#e-69), [E-101](../Intern/BEFUNDE.md#e-101) F1/F3/F4, [AN-1](../Intern/BEFUNDE.md#an-1), [E-142](../Intern/BEFUNDE.md#e-142) und [E-144](../Intern/BEFUNDE.md#e-144)“*.
* **Gemessen**, `perl tools/pruefe-regressionstest.pl`: 24 kritische
  Befunde ohne jede Prüfung, 67 behobene ohne Testfall.
* **Dazu belegt**, `ZIEL.md:110` *„Die Release-Notizen nennen den
  Rückstand ausdrücklich“*. **Gemessen**, `Releases/7.2.1.128/RELEASE-NOTIZEN.md`
  (91 Zeilen): kein Treffer für „Regress“, „Rückstand“ oder „Test“. Für das
  erste Release 7.2.1 stimmt der Satz nicht. Der Text ist veröffentlicht,
  deshalb steht die Frage unten bei Gregor.

**Was zu tun wäre:** eine Zeile in die Liste mit Verweis auf
`pruefe-regressionstest.pl` und die Reihenfolge, oder die Reihenfolge an
eine Stelle außerhalb des Archivs. Dann `ZIEL.md:113` auf
`#nach-dem-release` zeigen lassen.

### <a id="l-100.2"></a>L-100.2 — `Intern/AUFGABEN.md` bleibt eine zweite Aufgabenliste; „an genau einer Stelle“ stimmt nicht

**Was passiert:** WEITERMACHEN verspricht eine einzige Liste. AUFGABEN heißt
aber weiter *„Aufgaben für die nächste Sitzung“* und führt eigene offene
Punkte, die in der Liste nicht stehen. Die neue Schranke prüft nur
WEITERMACHEN.

* **Belegt**, `Intern/WEITERMACHEN.md:14-17` *„**Was zu tun ist, steht an
  genau einer Stelle:** in der Liste … Eine Aufgabe ‚nach dem Release‘ an
  anderer Stelle dieser Datei weist der Commit-Haken ab“*.
* **Belegt**, `Intern/AUFGABEN.md:1` *„# Aufgaben für die nächste Sitzung“*;
  `:399-417` Tabelle *„Was sonst noch offen ist“*; `:937-960` *„F — Offene
  Kleinigkeiten“*; dazu `:841` (C3), `:898-935` (E1–E3).
* **Gemessen**, nicht in der Liste: *„Encountered an improper argument“*
  beim Anzeigen (`:408`), die vier Kleinigkeiten aus F (Größe von `Out.mbx`
  im Protokoll, `EUMAPI.DLL` 16 Bit, toter Include-Pfad `..\OpenSSL\inc32`,
  fehlende PAKETE-Abschnitte [M-4](PRUEFER-15.md#m-4)), C3.
* **Belegt**, `tools/pruefe-nach-dem-release.pl:44` prüft ohne Argument nur
  `Intern/WEITERMACHEN.md`.

**Was zu tun wäre:** AUFGABEN entweder ins Archiv nehmen (wie WEITERMACHEN)
und die noch gültigen Punkte in die Liste übertragen, oder den Kopf von
AUFGABEN auf „Nachschlagen, Aufgaben stehen in WEITERMACHEN“ umstellen.
Danach `:14` nachmessen.

### <a id="l-100.3"></a>L-100.3 — Vier Werkzeugvorschläge des CHRONIST vom 30.10. fehlen in der Liste

**Was passiert:** Der CHRONIST-Bericht vom 30.10. war vor dem Umbau
committet (`411f6019`), seine neuen Vorschläge sind aber nicht in die Liste
gekommen. Nur die älteren aus dem Lauf vom 29.10. stehen drin.

* **Belegt**, `Arbeitsweise/CHRONIST-2026-10-30.md`, „Werkzeugmängel“:
  1. `verlauf-messen.pl --offen` (Einwurf ohne Antwort, drittes Auftreten);
  2. Hintergrundaufträge vor *„nichts läuft mehr“* prüfen (`gesichert.pl`
     misst nur Git); 3. ein Teilstring-Ersetzer mit Selbsttest (Fall „neu
     enthält alt“); 4. `pruefe-release-buchfuehrung.pl` über alle
     Gegenwartssätze statt fünf Absätze.
* **Belegt**, `Arbeitsweise/CHRONIST-2026-10-29b.md`, „Werkzeugmängel“
  Punkt 6: `testlauf.ps1` erkennt keinen Absturz während der Messung,
  `pruefe-startwege.pl:163`, `pruefe-rueckstrich.pl` für `stand-*.md`,
  `pruefe-nachgestellt.pl` blind seit 1.0.121. Vermutung: der erste ist
  durch [E-157](../Intern/BEFUNDE.md#e-157) gedeckt (*„sehen keine
  Abstürze“*), die drei anderen durch nichts.
* **Gemessen**, `Intern/WEITERMACHEN.md:32-48`: keiner dieser acht Punkte.

### <a id="l-100.4"></a>L-100.4 — Prüfer- und Lektorfunde fehlen oder stehen nur als Beispiel da

* [L-96.6](LEKTOR-96.md#l-96.6) (der Prüfbericht verweist auf eine
  „Ergebnistabelle je Kriterium“, die es nicht gibt) ist nach
  [LEKTOR-97](LEKTOR-97.md#lektor-97) **auf nach dem Release verschoben**.
  In der Liste steht er nur als Beleg für die Formprüfung (`:33`), nicht
  als eigene Reparatur. **Gemessen**: `tools/pruefbericht.pl:392` *„die
  Ergebnistabelle im Kopf von“* unverändert, `Intern/TESTPLAN.md:584`
  *„Stand 23.10.2026: an 1.0.122 …“* unverändert. Der Satz kommt in jeden
  neuen Prüfbericht wieder.
* [PRÜFER-64](PRUEFER-64.md) K5 (eine zurückgesetzte Einstellung kann
  wirkungslos bleiben, wenn sie in derselben Sitzung geändert wurde;
  *„Vorschlag E-167“*) und K6 (ein Prüfstand-Skript schreibt die INI als
  ASCII). **Gemessen**: `E-167` gibt es in `Intern/BEFUNDE.md` nicht, die
  Liste nennt beide nicht. Archiv `:137` hielt sie als *„offen und niedrig“*.
  K2 ist behoben (`tools/messen-e166-assistent.ps1:193`, gemessen), K3 steht
  in der Zeile von [E-166](../Intern/BEFUNDE.md#e-166).
* [PRÜFER-63](PRUEFER-63.md) K2 (die Spurzeile zu [E-137](../Intern/BEFUNDE.md#e-137) zeigt nicht, ob
  eine Marke verworfen wurde): Archiv `:139` *„Offen: PRÜFER-63 K2“*, in
  der Liste nicht.

### <a id="l-100.5"></a>L-100.5 — Zwei Reste aus dem Archiv sind nicht in Zeile 48 aufgezählt

Zeile `:48` zählt die alten Punkte auf, die noch zu prüfen sind. Zwei fehlen:

* **Belegt**, Archiv `:161` *„`tools/arbeitsbaum-frei.pl --belegen` bucht
  nicht den aktuellen Baum, sondern den ersten freien (am 23.10.2026 zweimal
  falsch, einmal sogar den Hauptbaum)“*. **Gemessen**: das Werkzeug ist seit
  `d15b551b` (05.09.2026) unverändert, der Mangel steht also noch.
* [E-13](../Intern/BEFUNDE.md#e-13) aus *„Ebenfalls offen“* (Archiv `:383`),
  siehe [L-100.10](#l-100.10).

**Gemessen ohne Fund:** Punkt F der alten Tabelle (`pruefe-befundurteile.pl`
trug das Muster `{1,80}`) ist erledigt, das Muster steht dort nicht mehr.
Punkt A und B waren schon erledigt.

### <a id="l-100.6"></a>L-100.6 — Zeile 35 macht aus „kein Handlungsbedarf“ eine Aufgabe

**Was passiert:** Die Zeile über die Betriebsart „Pro“ klingt, als sähen
alle Anwender nach dem Umstieg eine andere Betriebsart. Die Quelle sagt:
nur wer „Light“ gewählt hatte, und das ist unwahrscheinlich. Zu tun sei
nichts.

* **Belegt**, `Intern/WEITERMACHEN.md:35` *„Anwender sehen nach dem Umstieg
  eine andere Betriebsart als vorher“*.
* **Belegt**, [PRÜFER-65 K1](PRUEFER-65.md#k1) *„Wer die Betriebsart
  ‚Light‘ (`Mode=1`) gewählt hat, ist nach dem Wechsel wieder in ‚Pro‘ …
  Dass jemand ‚Light‘ benutzt, ist unwahrscheinlich … Kein Handlungsbedarf.“*
* **Belegt**, `Intern/BEFUNDE.md:240` ([PR-2](../Intern/BEFUNDE.md#pr-2))
  *„PR-2.8 kein Handlungsbedarf“*. Die Zeile steht unter *„Aufgaben ohne
  Befundnummer“*, hat aber eine.

**Was zu tun wäre:** streichen. Oder, falls es als Wissen bleiben soll: in
„Warum“ den Satz der Quelle übernehmen und PR-2.8 nennen.

### <a id="l-100.7"></a>L-100.7 — Zeile 43 nennt eine Quelle, in der das nicht steht

* **Belegt**, `Intern/WEITERMACHEN.md:43` verweist für *„`MEMORY.md`
  kürzen“* auf [CHRONIST 29.10. abends](../Arbeitsweise/CHRONIST-2026-10-29b.md).
* **Gemessen**: in dieser Datei kommt „MEMORY“ nur im Kopf vor
  (`node_type: memory`). Der Auftrag steht in
  `Arbeitsweise/stand-29-10-2026.md`, Nachtrag 29.10.2026 21:55 *„MEMORY.md
  20,7 KB kuerzen“*. Die 22 KB der Zeile stimmen (gemessen 22.332 Byte).

### <a id="l-100.8"></a>L-100.8 — Die Release-Buchführung prüft WEITERMACHEN seit dem Umbau nicht mehr

**Was passiert:** `pruefe-release-buchfuehrung.pl` erkennt eine Aussage
über den aktuellen Stand an vier Wendungen. Der neue Kopf von WEITERMACHEN
benutzt keine davon. Die Schranke bleibt grün, prüft dort aber nichts
mehr.

* **Gemessen**: [LEKTOR-99](LEKTOR-99.md#lektor-99) zitierte *„5 Datei(en),
  5 Standaussage(n)“*, heute *„5 Datei(en), 4 Standaussage(n)“*.
* **Gemessen**: Zeilen mit einer der vier Wendungen aus
  `tools/pruefe-release-buchfuehrung.pl:197-203` (*neueste/aktuelle
  Release|Fassung|Paket, als Latest, Zuletzt gebaut|veröffentlicht*):
  WEITERMACHEN alt 2, neu 0.
* **Belegt**, `Intern/WEITERMACHEN.md:3` *„Veröffentlicht ist
  **`v7.2.1.128`**“*. Passt auf keine der vier Wendungen.

Heute ist der Satz richtig. Falsch werden kann er beim nächsten Release, und
dann meldet es niemand. Das ist genau der Fall aus
[[schranke-teilt-nicht-die-annahme]] und CHRONIST 30.10., Vorschlag 4.

### <a id="l-100.9"></a>L-100.9 — Die neue Schranke fängt nur genau eine Wendung

**Gemessen** an Kopien der neuen Datei im Scratchpad, je ein Absatz unter
einer neuen Überschrift angehängt:

| Angehängt | Rückgabe |
|---|---|
| *„Das Werkzeug X bauen wir erst nach 7.2.1.“* | 0, durchgelassen |
| *„Das Werkzeug X bauen wir nach dem Release.“* | 1, abgewiesen |
| dasselbe mit einem Link auf `#nach-dem-release`, Aufgabe nicht in der Liste | 0, durchgelassen |

Die Datei selbst schreibt die andere Wendung: Entscheidung 7 *„behoben wird
nach 7.2.1“* (`:128`), Entscheidung 13 *„erst nach 7.2.1“* (`:134`). Beide
Fälle sind heute über die erzeugte Tabelle gedeckt ([E-140](../Intern/BEFUNDE.md#e-140), [E-141](../Intern/BEFUNDE.md#e-141), [E-145](../Intern/BEFUNDE.md#e-145),
[E-142](../Intern/BEFUNDE.md#e-142)). `tools/WERKZEUGE.md:169` beschreibt die Schranke ohne diese Grenzen
und nur für eine Datei ([L-100.2](#l-100.2)).

### <a id="l-100.10"></a>L-100.10 — E-13 fällt durch beide Listen; sein Urteil nennt einen Zweig, den es nicht gibt

**Was passiert:** Beim Mailabruf ist kein Fortschritt sichtbar
([E-13](../Intern/BEFUNDE.md#e-13)). Der Befund sagt, die Behebung liege auf
einem eigenen Zweig und sei nicht übernommen. Tatsächlich ist sie seit
September im Stand und damit auch im Release. Ob sie wirkt, hat seither
niemand gemessen. Weil das Urteil nicht mit „offen“ beginnt, zählt
`offene-befunde.pl` ihn nicht. Weil er aus WEITERMACHEN ins Archiv
gewandert ist, steht er auch nicht in der Liste.

* **Belegt**, `Intern/BEFUNDE.md:274` *„**Ursache belegt**; Behebung liegt
  auf `wt/fortschritt-arbeit`, **nicht** in diesem Zweig.“*;
  `Intern/AUFGABEN.md:413` *„Merge-Entscheidung“*.
* **Gemessen**: `wt/fortschritt-arbeit` gibt es weder lokal noch auf
  `origin` (0 Treffer). Der Commit `bd3959c2` (*„[E-12](../Intern/BEFUNDE.md#e-12): Fortschritt beim
  Mailabruf in der Statusleiste sichtbar machen“*, 05.09.2026,
  `statbar.cpp`) ist Vorfahre von `HEAD` (`merge-base --is-ancestor`), über
  den Merge `1e84e310`.
* **Am Rand, belegt**: `Intern/BEFUNDE.md:240` [PR-2](../Intern/BEFUNDE.md#pr-2)
  *„PR-2.2 bis PR-2.7 offen“*. Das Urteil beginnt mit *„Bericht“*, also
  zählt das Werkzeug auch das nicht. Ob die sechs Punkte noch gelten, habe
  ich nicht geprüft.

### <a id="l-100.11"></a>L-100.11 — Zwei Texte beschreiben noch den Stand vor dem Umbau

* **Belegt**, `README.md:89` *„| [WEITERMACHEN.md](Intern/WEITERMACHEN.md) |
  der nächste Schritt |“*. Einen Abschnitt „Der nächste Schritt“ gibt es
  nicht mehr, die Datei ist jetzt die Liste nach dem Release.
* **Belegt**, `Arbeitsweise/eine-stelle-dann-verlinken.md:36` *„**Schranke
  (vereinbart, nicht gebaut):** Der Commit-Haken weist eine ‚nach dem
  Release‘-Aufgabe außerhalb der Liste ab“*. Gebaut seit `9369fb63`
  (`tools/hooks-einrichten.sh:555-560`). Die Datei gehört zum gespiegelten
  Gedächtnis und liegt außerhalb meines Schreibbereichs.

**Sonst ohne Fund (gemessen):** `CLAUDE.md:14`, `Doku/MITARBEITEN.md:46`,
`Intern/AUFGABEN.md:5`, `ZIEL.md:45`, `Intern/TESTPLAN.md:100` und
`Releases/PAKETE.md:49` verweisen auf Entscheidungen 10 und 15 bzw. auf den
erzeugten Block. Beides steht unverändert da. `tools/sitzungsbeginn.pl:39`
liest den erzeugten Block, und den gibt es weiter. `tools/pruefe-befundurteile.pl:386`
nennt „Der naechste Schritt“ nur in einem Kommentar zur Geschichte.
`pruefe-befund-verbreitung.pl` und `pruefe-stand-md.pl` sind grün.

## Nicht geprüft

* Die 51 MD-Dateien außerhalb von `Arbeitsweise/`, `Befunde/`, Archiven und
  alten Release-Notizen sind nicht Zeile für Zeile gelesen. Durchsucht habe
  ich sie nach Aussagen über den Release-Stand und nach Verweisen auf
  WEITERMACHEN. Seit `49041c22` hat sich außer dem Umbau keine von ihnen
  geändert.
* Ob die Punkte in `Intern/AUFGABEN.md` ([L-100.2](#l-100.2)) noch gelten,
  habe ich nur stichprobenweise geprüft ([E-13](../Intern/BEFUNDE.md#e-13), F).
* Nichts am laufenden Programm, kein Bau, kein Prüfstand.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Soll der veröffentlichte Text von `v7.2.1.128` einen Satz zu den
  fehlenden Regressionstests bekommen?** Am 23.10. hast du festgelegt:
  *„für release dokumentieren wir, daß die fehlenden regression tests
  nachgeholt werden“*. `ZIEL.md:110` sagt, die Release-Notizen nennen den
  Rückstand. In den Notizen zu 7.2.1.128 steht er nicht (heute: 24
  kritische Befunde ohne jede Prüfung, [L-100.1](#l-100.1)). Den
  veröffentlichten Text haben bisher nur deine Entscheidungen 17 und 19
  geändert.
