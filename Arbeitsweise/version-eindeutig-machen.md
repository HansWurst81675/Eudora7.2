---
name: version-eindeutig-machen
description: "Jede Fassung, die Gregor in die Hand bekommt, muss sich selbst benennen koennen - Nummer, Commit, Bauzeit, sichtbar im Programm"
metadata:
  type: feedback
---

Schranke: tools/doku-pruefen.pl (pre-commit, pre-push — Abschnitt 7 hält Version.h gegen sich selbst und gegen VERSION)

# Jede ausgelieferte Fassung muss sich selbst benennen

**Gregor am 05.09.2026, nachdem ich ihm mitten im Test zwei Staende
untergeschoben hatte:** *„sooo nicht! garantiert nicht! sowas fangen wir gar
nicht an, habe ich gesagt. version muss eindeutig sein."*

Und eine Minute spaeter: *„warum bist du so dumm? und machst den fehler jedes
mal neu?"*

## Warum das die teuerste Kleinigkeit im Projekt ist

Gregor ist der einzige, der die Software wirklich bedient. Sein Testbericht ist
das einzige belastbare Messergebnis, das dieses Projekt hat. Ein Testbericht
ohne eindeutige Fassung ist **wertlos** — er selbst hat das am 30.08.2026
ausbuchstabiert:

> *„nun ja, am ende hast du ja die verwirrung, wenn ich sage, ich habe mit der
> version 1.0.0 getestet und es laeuft oder laeuft nicht - weil du nicht genau
> sagen kannst, auf welche version ich referenziere."*

Wenn die Fassung unklar ist, ist nicht nur der eine Test verloren, sondern der
ganze Testlauf: ich weiss nicht, ob mein Fix gewirkt hat, und muss ihn Gregor
noch einmal geben.

## Die Kette der Wiederholungen — belegt

| Datum | Was passiert ist | Gregors Wort |
|---|---|---|
| 29.08. 21:56 | QCSSL.dll ohne Versionsressource ausgeliefert | *„setz mal eine versionsnummer in die QCSSL.dll ein... sonst wirkt dein readme unprofessionell"* |
| 30.08. 15:32 | naechstes Paket wieder ohne | *„warum muss ich dich das separat fragen mit der version der QCSSL.dll? dsa haben wir ja beschlossen und notiert. trotzdem falsch?"* |
| 30.08. 19:18 | Menuefehler nicht zuzuordnen, weil kein Stand benennbar | *„da es von dir ja keine versionsnummer gibt, kann ich nicht sagen, welcher stand es war - pech!"* |
| 30.08. 19:19 | **Gregor** erfindet die Loesung, nicht ich | *„schreib in der titel leiste die build nummer und den commit hash"* |
| 05.09. 21:19 | Verzeichnis `1.0.4-release`, EXE meldet `7.2.0.5` | *„was stimmt hier nicht?"* |
| 05.09. 22:07 | Nummernsprung 0.6 auf 0.10 ohne Erklaerung | *„wieso haben wir schon 7.2.0.10? wir waren gerade bei 0.6"* |
| 05.09. 21:33 | zwei Staende gleichzeitig eingespielt, waehrend er testet | *„version muss eindeutig sein."* |

Zwischen Absprache (29.08.) und letztem Verstoss (05.09.) liegen acht Tage und
mindestens sechs Auslieferungen. **31 Nachrichten** in den beiden Mitschriften
drehen sich um die Frage, welche Fassung gerade gilt.

Dazu Gregors Nachsatz, der am meisten weh tut: *„mussste ich aber dir erklaeren,
wie das geht. von selbst bist du nicht drauf gekommen."*

## Die Regel — als Arbeitsschritt, nicht als Vorsatz

**Kein Paket verlaesst den Bauplatz, bevor diese vier Punkte erfuellt sind:**

1. **Die EXE sagt selbst, wer sie ist.** Titelzeile: Paketnummer, kurzer
   Commit-Hash, Bauzeit. Gregor kann dann einen Bildschirmabzug schicken, und
   die Zuordnung steht ohne Rueckfrage.
2. **Verzeichnisname, Dateiversion und Titelzeile stimmen ueberein.** Ein
   Ordner `1.0.4-release` mit einer EXE `7.2.0.5` darin ist ein Fehler, kein
   Schoenheitsproblem — genau daran ist der 05.09. gescheitert. Vor dem Packen
   die drei Werte nebeneinanderlegen und vergleichen.
3. **Eine Nummer je Bau, und sie steigt lueckenlos.** Wenn zwischendurch
   Nummern verbrannt werden, gehoert das in `CHANGELOG.md` — sonst kommt die
   Frage „wieso schon 0.10?".
4. **Waehrend Gregor testet, wird nichts ausgetauscht.** Findet sich in der
   Zwischenzeit ein besserer Stand, bekommt der die **naechste** Nummer und
   wartet, bis Gregor seinen Bericht abgegeben hat. Zwei Fassungen im selben
   Testlauf machen beide Berichte unbrauchbar.

**Die Probe:** Ich kann jederzeit auf einen Satz genau sagen, welche Datei
Gregor gerade unter welchem Pfad ausfuehrt und aus welchem Commit sie stammt.
Kann ich das nicht, darf ich ihn nicht um einen Test bitten.

Siehe auch [[erst-pruefen-dann-anweisen]] und [[lauffaehiges-ergebnis-liefern]].

## Nachtrag 11.09.2026: eine Nummer steht an mehr Stellen, als ich mir merke

Punkt 2 oben verlangt, Verzeichnisname, Dateiversion und Titelzeile
nebeneinanderzulegen. Am 11.09.2026 war die Fassung **innerhalb einer einzigen
Datei** uneinheitlich, und zwar unauffällig:

```
#define EUDORA_VERSION4 44          <- alt
#define EUDORA_BUILD_NUMBER    7,2,0,47
#define EUDORA_BUILD_DESC      "Version 7.2.0.47\0"
#define EUDORA_BUILD_VERSION   "7.2.0.47"
```

`EUDORA_VERSION1..4` gehen in die **Ressourcen der EXE** — das Feld, das
Windows im Eigenschaftendialog anzeigt. Das Paket hätte also in einem Feld
7.2.0.47 getragen und im anderen 7.2.0.44, und der Unterschied wäre erst bei
Gregor sichtbar geworden, an genau der Stelle, an der er eine Fassung
identifiziert.

**Gefunden hat es `tools/doku-pruefen.pl`, Abschnitt 7** — also die Schranke
dieser Lehre, im scharfen Lauf vor dem Commit (`3e8f289`). Danach wurde noch
einmal komplett gebaut. Seit demselben Tag hält auch `tools/pruefe-doku-takt.pl`
`VERSION` gegen die vier `EUDORA_VERSION*`-Makros, und zwar im Paketbau. Das ist
der Fall, in dem die Bauart dieser Lehre funktioniert hat: **nicht gemerkt,
sondern geprüft.**

**Was ich daraus mitnehme, zusätzlich zu Punkt 2:**

- **„Die Version hochsetzen" ist kein Handgriff, sondern eine Suche.** Der alte
  Wert wird gesucht, nicht die Stelle, an der er „hingehört" — in `Version.h`
  allein steht die Fassungsnummer an **vier** Stellen in drei Schreibweisen
  (`44`, `7,2,0,44` und `"7.2.0.44"`).
- **Zwei Schreibweisen derselben Zahl sind zwei Fundstellen.** Eine Suche nach
  `7.2.0.44` findet `7,2,0,44` nicht. Wer eine Versionsnummer sucht, sucht auch
  die Komma-Form und die nackte letzte Stelle.
- **Nach dem Hochsetzen wird neu gebaut, nicht nachgebessert.** Eine berichtigte
  `Version.h` über einem alten Bau ergibt eine EXE, die immer noch die alte
  Nummer trägt ([[messung-muss-den-weg-treffen]]).

## Nachtrag 12.10.2026: zwei Zweige, eine Nummer — 7.2.0.80 doppelt vergeben

**Was geschah:** Beide Zweige gingen von `main` mit 7.2.0.79 aus. Beide
nahmen „VERSION + 1":

| Zweig | Commit | Zeit | Nummer |
|---|---|---|---|
| `patch_20261012` → `an1-endungen` (diese Sitzung) | `ca8da5a` AN-1 achter Teil | 11:23:23 | **7.2.0.80** |
| `fix_startup_page` (parallele Sitzung, als PR #83) | `804c91e` AN-2 | 11:26:40 | **7.2.0.80** |

Zwischen den beiden Commits lagen drei Minuten. Keine der beiden Sitzungen
konnte die andere sehen. Um 11:40 hat Gregor PR #83 gemergt. Damit gab es
zwei verschiedene `Eudora.exe`, die sich im Programm beide als
„Version 7.2.0.80" ausweisen. Genau das schließt die Regel oben aus. Ausgeliefert
wurde 7.2.0.80-an1 nie, deshalb ist kein Schaden entstanden. Gelöst wurde
das so: Der gemeinsame Stand wurde auf 7.2.0.82 gehoben (`9113007`). Im
CHANGELOG und in PAKETE.md heißt die AN-1-Fassung jetzt
**„Messfassung 7.2.0.80-an1"**, mit dem Vermerk *„Nummer doppelt vergeben"*.
Den Anstoß gab `pruefe-doku-takt.pl`, das auf absteigende Überschriften
besteht.

### Why

Die Regel oben macht eine Fassung *in sich* eindeutig: Titelzeile,
Dateiversion und Verzeichnis nennen dieselbe Nummer. Sie sagt nichts
darüber, **wer** eine Nummer vergeben darf. Solange nur ein Zweig lebte, war
„VERSION + 1" eindeutig. Mit zwei Sitzungen nebeneinander ist es das nicht
mehr. Jede liest dieselbe Ausgangszahl und zählt für sich hoch.

### How to apply

- **Vor dem Hochzählen messen, was vergeben ist, nicht nur `main`:**
  `git fetch && git for-each-ref --format='%(refname:short)' refs/remotes/origin | xargs -I{} git show {}:VERSION 2>/dev/null | sort -V | tail -1`.
  Die neue Nummer liegt über dem Höchsten, was auf irgendeinem Zweig
  vorkommt.
- **Eine Messfassung auf einem Zweig trägt ein Kürzel im Text**
  (`EUDORA_BUILD_DESC "Version 7.2.0.80-an1"`). Die blanke Nummer bekommt
  erst, was zu Gregor geht. So sind auch zwei Zweige, die gleichzeitig
  hochzählen, im Programm unterscheidbar.
- Ein Merge von `main` in den Zweig ist ein Anlass für `git show
  origin/main:VERSION`, bevor der eigene Stand weiter hochgezählt wird. So
  wurde es am 12.10. gemacht, und es ging schnell.

## Nachtrag 21.10.2026: die Messfassung nennt sich wie die, gegen die sie misst

Bei [E-134](../BEFUNDE.md#e-134) wurden sechs Läufe gefahren, drei mit der
Behebung und drei mit der ausgelieferten 1.0.118. Nachgemessen am 21.10.2026
im Zweig `wt/chronist-20261021`:

| Prüfstand | `Eudora.exe` (MD5, erste 12) | `Version`-Zeile in `eudora.log` |
|---|---|---|
| `C:\Temp\E134-F1` (mit Behebung) | `8dabda7360fd` | `Version 7.2.0.118` |
| `C:\Temp\E134-G1` (ausgeliefert) | `b52792cd7d9e` | `Version 7.2.0.118` |

Zwei verschiedene Binärdateien, **dieselbe Fassungsnummer in beiden
Protokollen**. `Version.h` wurde erst beim Commit auf 7.2.0.119 gehoben; die
Messläufe liefen vorher. Wer die 15 Protokolle unter `C:\Temp\E134-*`
morgen wieder öffnet, kann aus ihnen **nicht** ablesen, welcher Lauf welche
Fassung gemessen hat. Der einzige Unterschied steht in der Prüfsumme der
Datei — und die hat damals niemand aufgeschrieben.

Es ist nichts passiert: die Verzeichnisnamen (`F` für die Behebung, `G` für
die ausgelieferte Fassung) waren zur Laufzeit eindeutig, und das Ergebnis
steht in `BEFUNDE.md`. Aber genau das ist der Fall, den Punkt 4 oben
beschreibt — nur eine Ebene tiefer: nicht zwei Fassungen bei Gregor, sondern
**zwei Fassungen in meiner eigenen Messreihe**, und die Messreihe ist der
Beleg, mit dem ein Befund geschlossen wird.

**How to apply, als Ergänzung zu Punkt 2:**

- **Eine Messreihe, die zwei Fassungen vergleicht, hebt die Nummer schon vor
  der ersten Messung** — oder trägt wenigstens das Kürzel aus dem Nachtrag
  vom 12.10.2026 ein (`EUDORA_BUILD_DESC "Version 7.2.0.118-e134fix"`). Die
  Nummer kostet nichts und ist nach dem Lauf nicht mehr nachzutragen.
- **Geht das nicht, gehört die Prüfsumme in den Befund:** *„mit Behebung
  `8dabda73`, ausgeliefert `b52792cd`"*. Ein Verzeichnisname ist eine
  Behauptung über die Datei, eine Prüfsumme ist die Datei.
