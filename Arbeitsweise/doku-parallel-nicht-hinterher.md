---
name: doku-parallel-nicht-hinterher
description: Ein Wert, der in mehreren MDs steht, wird im selben Arbeitsschritt ueberall berichtigt; doku-pruefen.pl haelt sie gegeneinander
metadata:
  type: feedback
---

Schranke: tools/doku-pruefen.pl (pre-commit, pre-push)

# Doku parallel berichtigen, nicht hinterher

**Gregor am 07.09.2026, 07:04 Uhr:** *„ich hasse es, wenn in den dokus falshe
oder veraltete infos und werte stehten. das muß immer parallel gleich erledigt
werden, klar?"*

Am Vorabend zweimal dasselbe, konkreter:

> *„und auch alle MDs: sollen auf dem aktuellen stand sein und commited. damit
> bei der nächsten session DIR klar ist, was noch zu tun ist. verstanden?"*
> (06.09.2026, 16:25)
> *„ziel.md ist alt! nur 4 stück drin. das ist falsch, das ist alt. es gibt
> weitere ziele, stehen aber nicht drin."* (06.09.2026, 17:05)

## Was tatsächlich passiert ist

Am 06.09.2026 standen **fünf Dateien gleichzeitig auf drei verschiedenen
Zahlen** für dieselbe Sache — nachlesbar im Kopf von `tools/doku-pruefen.pl`:

| Datei | behauptete |
|---|---|
| `CHANGELOG.md` | „Alle vier Kriterien sind erfüllt" |
| `README.md` | dieselbe Behauptung |
| `WEITERMACHEN.md` | dieselbe Behauptung |
| `ZIEL.md` | „drei von vier belegt, eines fast" |
| `PORTIERUNG.md` | „zwei von vier" |

Dazu zwei weitere Widersprüche aus derselben Feder: `ZIEL.md` führte vier
Kriterien in der Tabelle, obwohl **sieben** verabredet waren — drei standen in
einem eigenen Abschnitt weiter unten, wo Gregor sie nicht gesucht hat. Und die
Offen-Tabelle im `CHANGELOG.md` vergab die Kennung **E-31 zweimal**: einmal für
„File → Exit", obwohl E-31 die behobene `pg_time_t`-Sache ist.

Keinen dieser drei Fehler hat ein Prüfer gefunden. Alle drei hat Gregor
gefunden, und sein Schluss war: *„ich traue dir nicht ganz, jemand soll dich
immer wieder überprüfen - das bin aber nicht ich!"*

## Warum die vorhandene Lehre nicht gereicht hat

[doku-bei-jedem-commit-mitziehen](doku-bei-jedem-commit-mitziehen.md) sagt
richtig, **wann** die Doku dran ist (im selben Commit) und **welche Abschnitte**
zu prüfen sind. Ihr fehlen zwei Dinge, und genau an denen ist es gescheitert:

- Sie prüft jede Datei **für sich**. Alle fünf Dateien oben waren „mitgezogen" —
  nur eben zu verschiedenen Zeitpunkten auf verschiedene Stände. Ein Wert, der
  mehrfach vorkommt, braucht einen Abgleich **zwischen** den Dateien.
- Sie **delegiert** an PRÜFER und LEKTOR. Das ist der Teil, der versagt hat, und
  Gregors Satz sagt, warum: eine Prüfung, die ich selbst beauftrage und selbst
  abnehme, ist keine.

## Die Regel

1. **Derselbe Arbeitsschritt, nicht derselbe Tag.** Wer eine gemessene Größe
   ändert — Kriterienzahl, Paketnummer, Befundkennung, Datum, Versionsstand —
   sucht sie vor dem Commit im ganzen Baum und berichtigt jede Fundstelle:
   ```
   grep -rn "<alter wert>" --include=*.md .
   ```
   Nicht die Datei suchen, in der der Wert „hingehört", sondern **alle**.
2. **Ein Wert hat eine Quelle.** Steht eine Zahl in mehr als einer Datei, ist
   eine davon die führende (`ZIEL.md` für die Kriterien, `CHANGELOG.md` für
   Paketnummern und Befundkennungen). Die anderen verweisen darauf, statt sie zu
   wiederholen.
3. **`perl tools/doku-pruefen.pl`** prüft das mechanisch — die Dokumente
   gegeneinander, nicht nur gegen den Quellstand. Rückgabe 0 = kein Mangel,
   1 = Mangel, 2 = Aufruffehler. **Seit dem 07.09.2026 ist es eine Schranke:**
   `tools/hooks-einrichten.sh` hängt es in `pre-commit` **und** `pre-push` mit
   `|| exit $?` ein (Zeilen 69 und 91), und beide Hooks sind eingerichtet
   (nachgemessen: je ein Treffer in `.git/hooks/pre-commit` und
   `.git/hooks/pre-push`). Es prüft **alle** MD-Dateien aus `git ls-files`,
   nicht eine Liste von Hand ([[pruefumfang-nicht-von-hand]]).
   Die frühere Fassung dieser Lehre sagte „noch keine Schranke, gilt von Hand" —
   das ist überholt.
4. **Ein neuer Wert bekommt eine neue Prüfung.** Die Schranke wächst mit: elf
   Prüfungen am 07.09.2026, die letzte hält `ZIEL.md` A-1 gegen
   `tools/DEudora.ini` ([[anforderung-gehoert-in-den-massstab]]). Wer eine Zahl
   in zwei Dateien schreibt und keine Prüfung dazu, hat die Klasse nicht
   abgestellt ([[fehlerklassen-abstellen]]) — und jede neue Prüfung wird in
   beide Richtungen gegengetestet ([[schranke-gegentesten]]).
   Reihenfolge dabei: **erst** die gemeldeten Mängel beheben, **dann** die
   Prüfung scharf schalten. Ein `|| exit` über einem roten Baum blockiert jeden
   Commit im Projekt, auch die der anderen Agenten.
5. **Keine Erfolgsbehauptung, die eine zweite Datei bestreitet.** Vor jedem
   „erfüllt", „erreicht", „alle" in einer MD: nachsehen, ob eine andere Datei
   etwas anderes sagt. Wenn ja, ist nicht die andere Datei alt — dann ist die
   Behauptung unbelegt.
6. **Eine Zeile mit veraltetem Messstand ist falsch, nicht alt.** Sie wird
   berichtigt oder gelöscht, nicht stehen gelassen, bis jemand fragt.

Siehe [doku-bei-jedem-commit-mitziehen](doku-bei-jedem-commit-mitziehen.md),
[version-eindeutig-machen](version-eindeutig-machen.md) und
[fehlerklassen-abstellen](fehlerklassen-abstellen.md).

## Rueckfall am 07.09.2026, nachmittags — dreimal derselbe Typ

Gregor musste seine Standardfrage — *„alles gesichert? alles commited? readme
updated? changelog auch? findings eingepflegt? vom lektor, prüfer, chronist?"* —
an einem Nachmittag **zweimal** stellen. Beim zweiten Mal fanden sich drei
echte Luecken, alle vom Typ „Doku nicht parallel":

| Fund | Stand |
|---|---|
| `README.md:77` fuehrte **E-37** als offenen Fehler | war seit einer Stunde behoben |
| `AUFGABEN.md:68` fuehrte E-37 als **Aufgabe** | dieselbe Sache |
| `CHANGELOG.md`: *„Nach 7.2.0.21 — alles Gebaute ist gepackt"* | falsch: vier Quelldateien gebaut, in **keinem** Paket |

Wichtig daran: **die Schranke war die ganze Zeit gruen.** `doku-pruefen.pl`
prueft Zahlen, Kennungen und Widersprueche zwischen Dateien — nicht, ob ein
behobener Befund noch als offen gefuehrt wird, und nicht, ob eine
Fertig-Behauptung zum Paketstand passt. Eine gruene Schranke ist deshalb kein
Ersatz fuer Punkt 1: **im selben Arbeitsschritt** suchen.

**Der Handgriff, der die drei Faelle gefangen haette** — nach jedem behobenen
Befund, vor dem Commit:

    grep -rn "E-37" --include=*.md .        # jede Fundstelle, nicht die naheliegende
    grep -rn "alles Gebaute ist gepackt\|ist gepackt" --include=*.md .

Und: **wenn Gregor die Standardfrage stellt, ist die Antwort schon zu spaet.**
Die Frage ist die Schranke, die ich mir selbst haette setzen muessen
([[daueraufgaben-brauchen-einen-takt]]). Ein „behoben" ist erst fertig, wenn
kein MD es noch als offen fuehrt.

## Nachtrag 11.09.2026: eine Fundstelle liegt außerhalb des Repos

Punkt 1 dieser Lehre sagt: den alten Wert im **ganzen Baum** suchen. Am
11.09.2026 hat sich gezeigt, dass der Baum nicht alle Fundstellen enthält.

Die widerlegte Zahl „175 echte Nachrichten" (gemessen 134, siehe
[[pruefen-statt-vermuten]]) stand in `BEFUNDE.md`, `CHANGELOG.md`, `README.md` —
alle drei mit `grep -rn` zu finden, alle drei von `doku-pruefen.pl` erreichbar —
**und in den Release Notes von v1.0.47**, veröffentlicht am 11.09.2026 um
08:52 UTC. Die vierte Fundstelle steht in keinem `git ls-files`, wird von keiner
Schranke gelesen und lässt sich nicht im selben Arbeitsschritt mitberichtigen,
weil sie eine Veröffentlichung ist.

Nachgemessen am 11.09.2026 gegen 14 Uhr:

    gh release view v1.0.47 | grep -n "134\|175"

Dort steht inzwischen **134**; die Notes sind nachträglich berichtigt worden,
und im Repo führt nur noch `Befunde/PRUEFER-8.md` die 175 — als Beleg der
Widerlegung, wo sie hingehört. Der Vorgang ist damit sauber abgeschlossen. Genau
deshalb ist er hier festzuhalten: **die Berichtigung war ein eigener Handgriff
nach der Veröffentlichung**, und nur weil PRÜFER nachgezählt hat, ist er
überhaupt passiert.

**Also gehört zu Punkt 1:**

- **Die Release Notes sind eine Kopie der Doku und werden wie eine behandelt.**
  Wer einen Wert ändert, der schon veröffentlicht wurde, sieht mit
  `gh release view v<Nummer>` dort nach. Die Suche über `grep -rn --include=*.md`
  findet diese Fundstelle nie.
- **Was veröffentlicht ist, wird nicht mehr zurückgeholt.** Der Zeitpunkt, an dem
  eine Zahl geprüft werden muss, liegt **vor** dem Release, nicht beim nächsten
  Lektorat ([[release-erst-nach-gregors-test]], [[daueraufgaben-brauchen-einen-takt]]).
- **Eine Zahl, die nach außen geht, bekommt vorher denselben Befehl daneben wie
  jede andere.** Genau die Werte, die in eine Veröffentlichung wandern, schreibe
  ich am ehesten aus dem Kopf ab.
