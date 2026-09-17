# LEKTOR-11 — der Bestand nach 7.2.0.64 (17.09.2026)

Auftrag: alle MDs gegen den **Bestand** prüfen, nicht gegen den Diff
([review-sieht-nur-den-diff.md](../Arbeitsweise/review-sieht-nur-den-diff.md)).
Anlass: **E-97** ist behoben — *File → Save As* beendete Eudora sofort, in
**jeder** Fassung seit 1.0.49 und auch im veröffentlichten Release `v1.0.50`.

Gearbeitet im Zweig **`e97-speichern-absturz`** (in `tools/ZWEIGE.md` als von
Gregor bestätigt geführt), im gemeinsamen Arbeitsbaum neben CHRONIST und
PRÜFER — deshalb jeder Commit mit ausdrücklicher Pfadangabe
([agenten-trennen-worktrees](../Arbeitsweise/agenten-trennen-worktrees.md)).

---

## Die Übersicht

| | |
|---|---|
| **Umfang** | **146 MD-Dateien** aus `git ls-files '*.md'` — 19 im Wurzelverzeichnis, 73 in `Arbeitsweise/`, 35 in `Befunde/`, 6 in `tools/`, 3 in `Pruefung/`, 3 in `Releases/`, 7 unter `Eudora71/`. Keine Auswahl nach Gefühl ([pruefumfang-nicht-von-hand](../Arbeitsweise/pruefumfang-nicht-von-hand.md)) |
| **Gefunden** | **13 Mängel** in 10 Dateien |
| **Berichtigt** | `CHANGELOG.md`, `WEITERMACHEN.md`, `AUFGABEN.md`, `README.md`, `ZIEL.md`, `PORTIERUNG.md`, `BEFUNDE.md`, `Releases/PAKETE.md`, `Befunde/SPURMARKEN.md`, `tools/WERKZEUGE.md` |
| **Nicht angefasst** | 6 tote Verweise, die LEKTOR-6 begründet stehen lässt (Zitate, Beispiele, der Spiegel `Arbeitsweise/`); zwei Punkte in `Eudora71/`, siehe unten |
| **Commits** | `375f7e0`, `27da0c9` |

**Alle Schranken grün nach der Arbeit:** `doku-pruefen.pl`,
`pruefe-doku-takt.pl`, `pruefe-stand-md.pl`, `offene-befunde.pl`,
`lehren-schranken.pl`, `rollen-faellig.pl`, `spuren-auswerten.pl`. CR=0 in
jeder geänderten Datei.

---

## 1. Eine Ersetzung 63 → 64 hat drei historische Angaben mitgenommen

Der Commit `8b887bb` hat den Stand von 1.0.63 auf 1.0.64 gezogen. Dabei sind
drei Sätze mitgewandert, die **über die Vergangenheit** reden. **E-95/E-96
sind in 7.2.0.63 behoben, nicht in 7.2.0.64** — das sagen `CHANGELOG.md` und
`BEFUNDE.md` übereinstimmend.

| Datei | stand da | ist |
|---|---|---|
| `WEITERMACHEN.md`:11 | E-95/E-96 *„Gebaut in 7.2.0.64 … Prüfanleitung … Abschnitt 7.2.0.64"* | 7.2.0.63 — der Verweis zeigte auf den **E-97**-Abschnitt, also auf eine fremde Prüfanleitung |
| `AUFGABEN.md`:25 | *„Bildgrößen im Verfassenfenster, 7.2.0.62 und 7.2.0.64"* | 7.2.0.62 und 7.2.0.63 |
| `README.md`:81 | *„der Notbehelf davor ist mit 7.2.0.64 wieder weg"* | 7.2.0.63 |

Die erste ist die teuerste: sie schickt Gregor mit einer Prüfanleitung los,
die zu einem anderen Befund gehört. Ein Verweis auf einen **Abschnitt** ist
eine Zahl wie jede andere und veraltet mit ihr
([doku-parallel-nicht-hinterher](../Arbeitsweise/doku-parallel-nicht-hinterher.md),
Punkt 1).

**Was daraus folgt:** eine Ersetzung über eine Fassungsnummer trifft immer
beides — die Aussage über *jetzt* und die Aussage über *damals*. Wer sie
fährt, sieht jede Fundstelle einzeln an, statt zu zählen, wie viele ersetzt
wurden.

## 2. Vier Stellen behaupteten ein Paket, das es nicht gibt

**Gemessen am 17.09.2026:**

```
ls -d Releases/Eudora72-1.0.6*-release   ->  …-1.0.60, …-1.0.61, …-1.0.62, …-1.0.63
ls Releases/ | grep -c 1.0.64            ->  0
ls -la Eudora71/Bin/Release/Eudora.exe   ->  17.09.2026 07:50
```

7.2.0.64 ist **gebaut**, ein Paket dazu ist **nicht geschnürt**. Vier Stellen
sagten etwas anderes:

| Datei | stand da |
|---|---|
| `WEITERMACHEN.md`:13 | *„Zuletzt gebaut und gepackt: Paket 1.0.64 … unter `Releases/Eudora72-1.0.64-release`"* — ein Pfad, den es nicht gibt |
| `AUFGABEN.md`:27 | *„Gepackt ist 1.0.64"* |
| `PORTIERUNG.md`:43 | *„Stand 14.09.2026 … Als ZIP gepackt wurde zuletzt die Fassung davor"* — Datum und Aussage beide überholt |
| `ZIEL.md`:17 | *„gebaut ist inzwischen 7.2.0.63 / Paket 1.0.63"* — hier war die Ersetzung gar nicht angekommen |

**Warum das mehr ist als eine Zahl:** ein genannter Pfad ist eine
Handlungsanweisung. Wer ihn liest, sucht ein Verzeichnis und findet nichts —
und dieselbe Datei behauptet zwei Zeilen weiter, das Paket warte auf Gregors
Test. Alle vier sagen jetzt getrennt, was **gebaut** und was **geschnürt**
ist.

## 3. E-97 kam im ganzen Bestand außer CHANGELOG und BEFUNDE nicht vor

**Auch nicht in `README.md` unter *Was es nicht kann*** — obwohl `BEFUNDE.md`
ausdrücklich festhält: *„Auch das veröffentlichte Release v1.0.50 ist
betroffen."* Wer heute das Paket von GitHub herunterlädt, verliert Eudora
beim ersten *File → Save As*, und die einzige Datei, die ein Anwender liest,
schwieg dazu.

Nachgetragen:

- `README.md` — ein eigener Punkt unter *Was es nicht kann*, mit der Ursache
  in einem Satz und der Fassung, ab der es behoben ist.
- `WEITERMACHEN.md` — eine Zeile *VON GREGOR ZU PRÜFEN, 17.09.2026 — E-97*
  über der von E-95/E-96.
- `AUFGABEN.md` — aus *„fünf frische Behebungen"* werden **sechs**.
- `ZIEL.md` — E-97 in der Aufzählung des gebauten Standes.

## 4. `BEFUNDE.md` führte die widerlegte Ursache als Handlungsanweisung

Das ist dieselbe Klasse wie **LEKTOR-10, Abschnitt 4** (E-95), einen Monat
später keine drei Tage alt.

Der Eintrag zu **E-97** sagte in der Mitte:

> **Die Ursache im Quelltext:** `CSaveAsDialog` … hängt dem Dialog eine
> **eigene Dialogvorlage** an … **Noch nicht gemessen:** ob
> `QCFindResourceHandle(…)` überhaupt ein gültiges Handle liefert … **Bei der
> Behebung dürfen die beiden Kästchen nicht verlorengehen**

— und erst am **Ende** desselben Eintrags: *„Drei Vermutungen von mir waren
vorher widerlegt worden: die CSS-Grenze, die **Dialogvorlage von 1996** und
die ungeprüften Steuerelemente in `OnInitDialog`."*

Wer von oben liest, fängt an der Dialogvorlage zu arbeiten. Wer die
Urteilsspalte überfliegt — Mensch wie Werkzeug —, nimmt *„Noch nicht
gemessen"* als offene Aufgabe mit.

**Die Messung dazu stand seit dem 15.09.2026 nur in einer Commit-Nachricht**
(`bdd12f4`) und in keiner MD:

```
Dialogvorlage von 1996   NICHT die Ursache - abgeschaltet, stuerzt weiter ab
QCFindResourceHandle     liefert ein gueltiges Handle (71D40000)
OnInitDialog             wird NICHT erreicht (Spurmarke kam nicht)
IsVersion4()             liefert 1, Windows meldet Hauptversion 6
```

Dabei steht **eine Zahl zweimal verschieden im Repo**: der Eintrag sagte *„Auf
Windows 10 ist die Hauptversion **10**"*, die Messung vom 15.09. nennt **6**.
Für `IsVersion4()` (`>= 4`) ist beides wahr, das Urteil ändert sich nicht —
aber unbelegt ist es so oder so. Siehe den Nachtrag ganz unten: `PRUEFER-11.md`
rechnet ebenfalls mit 10, und aufgelöst ist der Widerspruch damit nicht.

Berichtigt: die Vorlagenpassage ist als **widerlegt** gekennzeichnet und sagt
jetzt selbst, womit sie widerlegt wurde; beide Angaben zur Hauptversion stehen
nebeneinander mit dem Vermerk, dass nachzumessen ist; aus *„Noch nicht
gemessen"* ist die Messung geworden.

**Die Regel dahinter:** eine Messung, die nur in einer Commit-Nachricht steht,
ist nicht im Bestand ([wissen-gehoert-in-dateien](../Arbeitsweise/wissen-gehoert-in-dateien.md)).
Und eine widerlegte Vermutung bleibt stehen — aber **als Ausschluss
gekennzeichnet**, nie im Indikativ
([widerlegte-vermutungen-aufschreiben](../Arbeitsweise/widerlegte-vermutungen-aufschreiben.md)).

## 5. Der CHANGELOG-Abschnitt zu 7.2.0.64 trug kein Datum — und stellte damit eine Schranke ab

`tools/pruefe-stand-md.pl` nimmt als Maßstab **das jüngste Datum irgendwo im
`CHANGELOG.md`** (`:88-94`) und hält alle *Stand*-Köpfe dagegen. Der Abschnitt
zu 7.2.0.64 nannte **kein Datum**. Der Maßstab blieb deshalb der **15.09.2026**
— und die Schranke meldete brav:

```
5 Datei(en) mit Stand-Kopf geprueft, Massstab 15.09.2026
Kein Stand-Kopf hinkt hinterher.
```

Fünf Dateien standen auf *Stand 15.09.2026*, zwei Tage nach der Arbeit, die
sie beschreiben sollten — und die Schranke hat es bestätigt, statt es zu
melden. **Kein Fehlalarm, sondern Schweigen**
([prüfstand-kann-blind-sein](../Arbeitsweise/pruefstand-kann-blind-sein.md)).

Der Abschnitt nennt jetzt *„Gebaut am 17.09.2026"*, und `Noch offen` sowie
alle fünf Stand-Köpfe (`AUFGABEN.md`, `CHANGELOG.md`, `WEITERMACHEN.md`,
`ZIEL.md`, `Releases/PAKETE.md`) sind nachgezogen — **im selben
Arbeitsschritt**, sonst hätte die geschärfte Schranke sofort fünf Mängel
gemeldet ([doku-parallel-nicht-hinterher](../Arbeitsweise/doku-parallel-nicht-hinterher.md),
Punkt 4: erst die Mängel, dann scharf schalten).

**Vorschlag, nicht gebaut:** `pruefe-doku-takt.pl` könnte verlangen, dass der
Abschnitt zum **aktuellen** Quellstand ein Datum trägt. Ohne das hängt der
Maßstab aller fünf Stand-Köpfe daran, ob jemand zufällig ein Datum in den
Fließtext geschrieben hat.

## 6. `Befunde/SPURMARKEN.md` kannte die beiden E-97-Marken nicht

Dieselbe Klasse wie **LEKTOR-10, Abschnitt 5** — dort fehlten vier Marken und
die Zahl war zweimal alt. Mit dem Messbefehl, der **in der Datei selbst
steht**, am 17.09.2026 gefahren:

| | Befunde | Stellen | Dateien |
|---|---:|---:|---:|
| behauptet (15.09.) | 29 | 168 | 26 |
| **gemessen (17.09.)** | **30** | **170** | **28** |

Neu in der Tabelle: `SaveAsDialog.cpp:78` (`E-97 OnInitDialog: 1 …`) und
`PgEmbeddedImage.cpp:483` (`E-97 Nachtrag: …`).

**Die erste Marke hat E-97 entschieden, indem sie schwieg.** Sie kam nicht,
während die Marke im Konstruktor kam — daraus folgte, dass der Absturz
**vor** `OnInitDialog` passiert, und der symbolisierte Stapel lieferte dann
`SaveAsDialog.cpp:425`. Die zweite hat in keinem Testlauf geschrieben und
bleibt bewusst stehen.

### Und die Schranke dazu schweigt in beide Richtungen

`tools/spuren-auswerten.pl` erkennt eine Marke daran, dass im Kommentar
darüber das Wort `SPURMARKE` steht (`:122`). Über beiden E-97-Marken steht
`BEFUND E-97` beziehungsweise `E-97-Messung`. Das Werkzeug zählt deshalb
weiter **8** Befunde mit Marken, während der Messbefehl **30** nennt — und
meldet dazu **nichts**, weder Fund noch Fehlalarm.

Bei **E-95** fällt dieselbe Konvention immerhin als Hinweis auf, weil die
Marke in `SPURMARKEN.md` steht. Bei **E-97** stand sie dort nicht — und dann
ist das Werkzeug stumm. Als Nachtrag in `SPURMARKEN.md` festgehalten; die
Behebung ist ein Wort in zwei Kommentaren und liegt in `Eudora71/`, also
**nicht beim LEKTOR**.

## 7. Drei tote Verweise in `tools/WERKZEUGE.md`

Über alle 146 MDs gemessen: **464 Verweise, 9 tot**. Sechs davon hat
**LEKTOR-6** (L-11) begründet stehen gelassen — Zitate, Beispiele in
Schrägstrichen, und `Arbeitsweise/` ist ein Spiegel des
Gedächtnisverzeichnisses, dessen Änderung beim nächsten Spiegeln verlorenginge.

Die drei übrigen standen in `tools/WERKZEUGE.md` und waren echte Fehler:
`](README.md)`, `](AGENTEN.md)` und `](ZIEL.md)` zeigen aus `tools/` heraus
ins Leere. Auf `../` gesetzt; danach **0 tote Verweise außerhalb der sechs
begründeten**.

## 8. Was geprüft wurde und in Ordnung war

Damit dieser Bericht nicht vollständiger aussieht, als er ist — was gemessen
und **nicht** beanstandet wurde:

| Prüfung | Ergebnis |
|---|---|
| `tools/WERKZEUGE.md` vollständig? | **95 Werkzeuge** in `tools/`, **0 nicht dokumentiert** (Schleife über die Dateien, nicht über die Tabelle) |
| `Arbeitsweise/README.md` vollständig? | **73 Dateien**, jede in der Tabelle; `lehren-schranken.pl`: 70 Lehren, 45 mit Schranke, 25 mit begründeter Ausnahme |
| Offene Befunde in `CHANGELOG.md` *Noch offen*? | alle **11** aus `BEFUNDE.md` genannt (E-94, E-92, E-90, E-78, E-77, E-71, E-69, E-67, E-47, E-39, E-14) |
| `offene-befunde.pl` | 11 offen laut `BEFUNDE.md`, 11 in `WEITERMACHEN.md` |
| `tools/ZWEIGE.md` | `e97-speichern-absturz` ist als von Gregor bestätigt geführt |
| `release-pruefen.pl` | weist weiter ab (QCSSL in `Releases/1.0/` hinkt) — genau das, was `WEITERMACHEN.md` behauptet |
| `Releases/PAKETE.md`: *„1.0.30 bis 1.0.63 dazugekommen"* | **richtig**, 1.0.63 ist das letzte geschnürte Paket; nur der Stand-Kopf und der Zusatz zu 7.2.0.64 fehlten |
| Zeitdokumente (`PRUEFBERICHT.md`, `PRUEFUNG-*.md`, `STARTUMGEBUNG.md`, `Befunde/*`) | erklären sich im Kopf als abgeschlossen und verweisen weiter — dürfen alte Zahlen nennen |

## 9. Gefunden, nicht angefasst

1. **Die `SPURMARKE`-Konvention in `Eudora71/`** (Abschnitt 6): zwei
   Kommentare über den E-97-Marken, dazu der bekannte Fall E-95 in
   `PGHTMIMP.CPP:2157`. Ein Wort je Stelle — aber `Eudora71/` ist Latin-1 mit
   gemischten Zeilenenden und nicht mein Gebiet
   ([quelldateien-nur-byte-erhaltend-aendern](../Arbeitsweise/quelldateien-nur-byte-erhaltend-aendern.md)).
2. **`spuren-auswerten.pl` misst sich gegen sich selbst.** Es zählt, was seine
   eigene Konvention findet, nie gegen den Messbefehl aus `SPURMARKEN.md`. Das
   ist derselbe Zuschnitt wie der Zähler aus dem Nachtrag vom 14.09. in
   [pruefumfang-nicht-von-hand](../Arbeitsweise/pruefumfang-nicht-von-hand.md).
3. **`pruefe-doku-takt.pl` verlangt kein Datum** im Abschnitt zum aktuellen
   Quellstand (Abschnitt 5). Beides sind Werkzeugänderungen und gehören
   abgestimmt, nicht nebenbei gemacht.

---

## Was dieser Durchgang über den letzten sagt

Von sieben Mängelgruppen sind **drei wörtliche Wiederholungen aus LEKTOR-10**:
die widersprüchliche Urteilsspalte (dort E-95, hier E-97), die nicht
nachgezogenen Spurmarkenzahlen, und Stellen, die auf einer älteren Fassung
stehen. Die Klasse ist also nicht abgestellt, sondern nur jeweils behoben
([fehlerklassen-abstellen](../Arbeitsweise/fehlerklassen-abstellen.md)).

Der Unterschied diesmal: **zwei der drei hätte eine Schranke fangen können,
und beide Schranken waren stumm** — `pruefe-stand-md.pl`, weil ihr Maßstab an
einem fehlenden Datum hing, und `spuren-auswerten.pl`, weil es nach einem Wort
sucht, das an den neuen Marken nicht steht. Eine grüne Schranke ist kein
Beleg, solange niemand gemessen hat, wie viel sie überhaupt anfasst.

---

## Nachtrag, noch am 17.09.2026: PRÜFER hat eine meiner Berichtigungen widerlegt

Während dieses Durchgangs lief **PRÜFER** am selben Baum und hat E-97
nachgerechnet (`008e18a`, [Befunde/PRUEFER-11.md](PRUEFER-11.md)). Zwei seiner
Funde treffen Abschnitt 4 dieses Berichts:

1. **Meine Berichtigung war selbst falsch.** Ich hatte in `BEFUNDE.md`
   geschrieben, die beiden Kästchen *Kopfzeilen einschließen* und *Absätze
   raten* seien *„deshalb geblieben, die Vorlage ist unangetastet"*. Sie sind
   **weg** — nicht durch die Behebung, sondern seit der Portierung: MFC 14.38
   nimmt `bVistaStyle = TRUE` als Vorgabe, und `ApplyOFNToShellDialog` liest
   `lpTemplateName` nirgends, `IDD_SAVEAS_EXT` wird also nie instanziiert
   (P-2, P-4). Berichtigt und auf `PRUEFER-11.md` verwiesen.

   **Was ich falsch gemacht habe:** ich habe aus *„der Fix hat die Vorlage
   nicht angefasst"* geschlossen, die Kästchen seien noch da. Das ist ein
   Schluss aus dem Diff auf den Bestand — ausgerechnet die Klasse, gegen die
   dieser ganze Durchgang geschrieben ist
   ([review-sieht-nur-den-diff](../Arbeitsweise/review-sieht-nur-den-diff.md)).
   Die Aussage wäre nur mit einem Blick in den laufenden Dialog belegbar
   gewesen, und den hatte ich nicht.

2. **Eine Zahl steht jetzt zweimal verschieden im Repo.** Die Messung vom
   15.09. (`bdd12f4`) nennt für `dwMajorVersion` den Wert **6**,
   `PRUEFER-11.md` rechnet mit **10**. Für `IsVersion4()` ist beides wahr, das
   Urteil ändert sich nicht — aber eine Zahl mit zwei Werten im Bestand ist
   ein Mangel. In `BEFUNDE.md` stehen jetzt beide Angaben nebeneinander mit
   dem Vermerk, dass sie nachzumessen ist; auflösen kann das nur, wer den
   Prozess laufen lässt.

**Für die nächste Runde:** ein LEKTOR-Durchgang, der parallel zu einem
PRÜFER-Durchgang am selben Befund läuft, sollte dessen Bericht abwarten oder
ihn wenigstens vor dem Commit lesen. Meine Berichtigung stand elf Minuten
früher im Baum als seine Widerlegung.
