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
