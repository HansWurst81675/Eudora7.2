# <a id="lektor-43"></a>LEKTOR-43 — die veröffentlichten Release-Notizen zu `v1.0.112` waren verstümmelt, und nach dem Release sagten sechs Stellen weiter `v1.0.101`

Lauf am 20.10.2026 im Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig `wt/lektor`,
Ausgang `f87a4a74` (während des Laufs auf `8f7092a0` nachgezogen). Anlass:
seit [LEKTOR-42](LEKTOR-42.md#lektor-42) (`8d1075b0`, 19.10. abends) sind
7.2.0.111 ([E-123](../Intern/BEFUNDE.md#e-123): die Wache beim Beenden zählt jede
Übertragungsart), 7.2.0.112 (Rücknahme des Hochladezählers nach
[PRÜFER-39](PRUEFER-39.md) N1), vier neue Befunde
([E-128](../Intern/BEFUNDE.md#e-128), [E-129](../Intern/BEFUNDE.md#e-129),
[E-130](../Intern/BEFUNDE.md#e-130), [E-131](../Intern/BEFUNDE.md#e-131)), zwei neue
Schranken und — zum ersten Mal in diesem Lauf — **ein Release** dazugekommen.

**Das ändert den Maßstab.** Bis gestern war die schlimmste Unwahrheit eine, die
nur im Repo stand. Seit heute 11:55:10 UTC steht ein Text auf GitHub, den
Fremde lesen. Der erste Fehlerbericht von außen ([Issue
#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)) ist drei Tage
alt.

## Umfang

`git ls-files "*.md"` = **243** verfolgte Dateien, ohne `Arbeitsweise/` **142**,
davon **44** außerhalb von `Befunde/`.

**Maßstab von außen** ([Einigkeit ist kein
Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)) — keine dieser Zahlen
stammt aus einem Dokument des Projekts:

| Quelle | Wert |
|---|---|
| `Eudora71/Version.h` | **7.2.0.112** |
| `VERSION` | **1.0.112** |
| `git tag \| sort -V \| tail -1` | **`v1.0.112`** |
| `gh release view v1.0.112` | veröffentlicht **20.10.2026, 11:55:10 UTC**, *Latest*, ein Anhang `Eudora72-1.0.112-release.zip` |
| `gh release view v1.0.112 --json body` | **114 Zeilen, identisch mit `Releases/1.0.112/RELEASE-NOTIZEN.md`** bis auf den Zeilenumbruch am Ende |
| Uhr | 20.10.2026 |

Der letzte Eintrag ist der wichtigste: der veröffentlichte Text ist **nicht**
eine andere Fassung der Datei im Repo, sondern dieselbe. Was in der Datei kaputt
war, steht so auf GitHub.

* **Alle 243** maschinell durchsucht nach: `v1\.0\.10[0-9]` zusammen mit
  *Latest / veröffentlicht ist / zuletzt veröffentlicht*; `1\.0\.11[012]`
  zusammen mit *nicht veröffentlicht*; `E-12[89]`, `E-13[01]`.
* **Die 44 außerhalb von `Befunde/`** zusätzlich auf Stand- und
  Release-Aussagen gelesen; ganz gelesen: `Releases/1.0.112/RELEASE-NOTIZEN.md`
  **gegen die veröffentlichte Fassung**, `TESTPLAN.md` Kopf und
  Buchführungsabschnitt, `README.md` *Auf einen Blick* (`:36-100`),
  `CHANGELOG.md` *Noch offen* und die Abschnitte 7.2.0.111/112,
  `WEITERMACHEN.md` Kopftabelle, `Releases/PAKETE.md:1-180`, `ZIEL.md:47`,
  `AUFGABEN.md:3` und `:124`, `tools/RELEASES.md`, `LEKTORAT.md`.
* Dazu `Befunde/PRUEFER-39.md` ganz und `Befunde/LEKTOR-42.md` ganz.

**Werkzeuge vorher:** `offene-befunde.pl` 36/36, `paket-bereit.pl` 1 von 8 weist
ab (LEKTOR fällig), `doku-pruefen.pl` kein Widerspruch (3 Hinweise *zur
Kenntnis*). **`pruefe-release-buchfuehrung.pl` wies mit sechs Stellen ab** —
sie steht aber nicht unter den acht, die `paket-bereit.pl` liest
([L-43.12](#l-43.12)). **Nachher:** alle grün, `offene-befunde.pl` 36/36.

---

## Berichtigt

### <a id="l-43.1"></a>L-43.1 — die veröffentlichten Release-Notizen tragen drei Schäden, einer davon löscht die größte Verbesserung des Pakets (hoch)

`gh release view v1.0.112 --json body --jq .body` gegen
`Releases/1.0.112/RELEASE-NOTIZEN.md`: **identisch.** Also stehen alle drei
Schäden öffentlich.

**1. Der Aufzählungspunkt zu [E-69](../Intern/BEFUNDE.md#e-69) hat seinen Kopf verloren.**
Der veröffentlichte Text lautet:

> — auch wenn **innerhalb** desselben IMAP-Kontos verschoben wurde. Bis
> 7.2.0.110 zählte die Wache nur Übertragungen aus einem lokalen Postfach, und
> der andere Weg lief an ihr vorbei.
> **nicht lesen, legte es je Nachricht einen eigenen Eintrag in *Task Errors*
> an** – jeder mit Piepton und Fenstersprung.

Der Satz beginnt mitten im Nebensatz. **Herkunft gemessen:** in `d6db51c7`
(`Releases/1.0.111/RELEASE-NOTIZEN.md`, 13:13 Uhr) wurde die neue
[E-123](../Intern/BEFUNDE.md#e-123)-Zeile eingesetzt, dabei aber nicht **vor** den
E-69-Punkt, sondern **über** seine ersten zwei Zeilen. Verloren ging:

> `- **Keine Flut von Fehlermeldungen mehr beim Filtern.** Konnte Eudora eine Nachricht`

Aus `cd6786c2` (`Releases/1.0.110/RELEASE-NOTIZEN.md`) wörtlich
wiederhergestellt. **Warum das zählt:** aus 500 Pieptönen werden 25 — das ist
die Verbesserung, die ein Anwender am deutlichsten merkt, und sie stand in den
Notizen nicht mehr als eigener Punkt. Der Rest des Punktes hing als Fließtext
am E-123-Punkt und las sich wie ein Übertragungsfehler.

**2. Der Einleitungssatz bricht nach dem dritten Wort des Folgesatzes ab:**

> ZIP auspacken, `Eudora starten.cmd` doppelklicken. Nichts zu installieren. Das
> ## Neu gegenüber v1.0.101

**Herkunft gemessen:** in `61c91b43` ersetzte der Warnblock zu
[E-131](../Intern/BEFUNDE.md#e-131) beide Zeilen des Absatzes; zurück kam nur die
erste. Die zweite — *„Mailverzeichnis im ZIP ist leer – ein vorhandenes
`Mailverzeichnis` hineinkopieren."* — fehlt. Ein Anwender, der das ZIP auspackt,
findet ein leeres Postfachverzeichnis und erfährt an dieser Stelle nicht, was zu
tun ist. Wiederhergestellt.

**3. Die Überschrift `## Was geprüft wurde – und was nicht` stand zweimal
hintereinander** (`:93` und `:94`). Entstanden ebenfalls in `d6db51c7`.
Eine entfernt.

> **Was ich NICHT getan habe: den veröffentlichten Text auf GitHub
> berichtigen.** Ein Release ist eine Aussage nach außen
> ([Release erst nach Gregors Test](../Arbeitsweise/release-erst-nach-gregors-test.md));
> ich ändere sie nicht von mir aus. Der Befehl steht unten unter
> *Was Gregor entscheiden muss*.

### <a id="l-43.2"></a>L-43.2 — die Notizen schreiben Gregors Messung dem Paket zu, an dem er nicht gemessen hat (hoch)

Veröffentlicht steht:

> **Von Gregor am 20.10.2026 an Paket 1.0.112 am laufenden Programm bestätigt,
> auf beiden Wegen:** … (Eudora wartete **6015 ms**) … (**4015 ms**).

**Gemessen hat er an 1.0.111.** Die Zeitfolge aus `git log`:

| Zeit | Vorgang |
|---|---|
| 13:13 | `d6db51c7` — 1.0.111 geschnürt |
| 13:15 | `9d78748c` — *„[E-123](../Intern/BEFUNDE.md#e-123) Weg 2b von Gregor am laufenden Programm bestaetigt"* |
| 13:25 | `099e3871` — Weg 2a dazu |
| **13:41** | `61c91b43` — **7.2.0.112 gebaut**, der Zähler ist heraus |

`Releases/PAKETE.md` sagt es richtig (*„Von Gregor am 20.10.2026 an 1.0.111 …
bestätigt"*, 1.0.112 *„Gemessen: ohne Nachstellung"*), die
Commit-Nachricht des Releases (`a872293d`) sagt es richtig. **Nur die Notizen
sagten es falsch** — und zwar das einzige Dokument, das ein Fremder liest.

Das ist kein Haarspalten: 1.0.112 unterscheidet sich von 1.0.111 genau durch
den Zähler, der bei Weg 2a `laeuft=1` erzeugt hat. Dass seine Rücknahme an
beiden Messungen nichts ändert, ist **am Quelltext und an Gregors Protokollen
hergeleitet**, nicht nachgemessen. Der Satz in den Notizen behauptete eine
Messung, die es nicht gibt
([Erst nachstellen, dann ausliefern](../Arbeitsweise/erst-nachstellen-dann-ausliefern.md)).
Berichtigt auf 1.0.111, mit der Herleitung als Klammer.

### <a id="l-43.3"></a>L-43.3 — nach dem Release sagten sechs Stellen weiter `v1.0.101` (hoch)

`pruefe-release-buchfuehrung.pl` nannte sie alle, beim ersten Lauf dieses
Durchgangs:

| Stelle | stand dort | jetzt |
|---|---|---|
| `README.md:38`, Kopf *Auf einen Blick* | *„Stand Paket **1.0.101** … in Arbeit 7.2.0.112 / Paket **1.0.111** (20.10.2026, **nicht veröffentlicht**)"* | Stand Paket 1.0.112, am 20.10.2026 als `v1.0.112` veröffentlicht. **Zwei Fehler in einem Satz:** falsche Paketnummer *und* falscher Veröffentlichungsstand |
| `README.md:133` | *„Das neueste Release ist `v1.0.101`"* | `v1.0.112`, 11:55 UTC, mit `v1.0.101` als *davor* |
| `WEITERMACHEN.md:9`, *Quellstand* | *„7.2.0.112 … **nicht veröffentlicht**"* | veröffentlicht als `v1.0.112`, PR #112 gemergt |
| `WEITERMACHEN.md:45`, *Zuletzt gebaut und veröffentlicht* | 7.2.0.101 / 1.0.101 als *Latest* | 7.2.0.112 / 1.0.112 mit Marke, SHA-256 und Gregors Bestätigung; 1.0.101 als *davor* |
| `Releases/PAKETE.md:6` und `:20` | *„zuletzt veröffentlicht **1.0.101**"*, *„veröffentlicht ist inzwischen **`v1.0.101`**"* | 1.0.112; dazu `:538` und `:551` (*„heute ist `v1.0.101` *Latest*"*) |
| `tools/RELEASES.md` | **kannte die Fassung 112 an keiner Stelle** | Zeile eingetragen ([L-43.8](#l-43.8)) |

Dazu, von mir gefunden und nicht von der Schranke:
`ZIEL.md:47` sagte *„Quellstand ist jetzt 7.2.0.112 / Paket **1.0.111** (Zweig
**`e-69-meldungsflut`**"* — `VERSION` sagt 1.0.112, der Zweig hieß
`e-123-transfersame`. `AUFGABEN.md:3` sagte *„bei ihm liegt 1.0.110 … **1.0.111
folgt**"* und *„veröffentlicht ist `v1.0.101`"*, `:124` dasselbe noch einmal.

**Warum keine Schranke das vor dem Release gefangen hat** — die Antwort ist
unbequem und steht in [L-43.11](#l-43.11): die Schranke hängt im `pre-commit`.
Das Tag entsteht **nach** dem letzten Commit. Im Augenblick des Taggens werden
die Dokumente unwahr, und danach läuft nichts mehr. Es ist kein Loch in der
Schranke, sondern eines in ihrer Aufhängung.

### <a id="l-43.4"></a>L-43.4 — die Liste, auf die die veröffentlichten Notizen verweisen, kannte drei der vier neuen Befunde nicht (hoch)

Die Notizen sagen unter *Bekannte Fehler*:

> Die vollständige Liste mit Abhilfe steht in der
> [README, Abschnitt „Auf einen Blick"](…#auf-einen-blick-was-das-paket-kann-und-wo-noch-fehler-sind).

**Gemessen:** `grep -c "E-128\|E-129\|E-130\|E-131" README.md` = **0**. Keiner
der vier kam in der ganzen Datei vor. Die Notizen nennen drei davon namentlich —
[E-131](../Intern/BEFUNDE.md#e-131) sogar im Warnblock ganz oben — und schicken den
Leser für die Einzelheiten an eine Stelle, die sie nicht kennt.

Drei Zeilen in die Tabelle eingesetzt:

| Befund | wo | warum dort |
|---|---|---|
| [E-131](../Intern/BEFUNDE.md#e-131) | **als erste Zeile** | der einzige bekannte Fehler, der etwas **außerhalb** von Eudora unbrauchbar macht; er trifft jeden mit vorhandener Installation, und zwar sofort |
| [E-128](../Intern/BEFUNDE.md#e-128) | bei den Speicher-Befunden | *„heißt `.txt`, enthält HTML"* mit der Abhilfe (umbenennen in `.html` oder `.eml`) |
| [E-129](../Intern/BEFUNDE.md#e-129) | bei den IMAP-Befunden | mit *Show Deleted Messages* / *UnDelete* **und** der Warnung, *Purge Messages* dabei nicht zu benutzen |

**[E-130](../Intern/BEFUNDE.md#e-130) bewusst nicht eingesetzt:** gestempelte
Fremd-DLLs im Bau sind kein Anwenderfehler. Der Abschnitt heißt *„was das Paket
kann und wo noch Fehler sind"* und ist in Anwendersprache; ein Befund über den
schmutzigen Arbeitsbaum gehört dorthin nicht.

Dazu zwei Altlasten in derselben Tabelle: *„ab 7.2.0.106 (noch nicht
veröffentlicht)"* und *„Ab 7.2.0.104 (noch nicht veröffentlicht)"* — beide
Stände sind seit heute in `v1.0.112` draußen. Und die Überschrift *„Neu
gegenüber `v1.0.87`"* beschrieb den Sprung auf 1.0.101; sie heißt jetzt *„Neu in
`v1.0.101` gegenüber `v1.0.87`"*, damit sie nicht wie der heutige Stand gelesen wird.

### <a id="l-43.5"></a>L-43.5 — der Testplan nannte im Kopf 1.0.112 und schickte Gregor drei Zeilen tiefer nach 1.0.110 (hoch)

`TESTPLAN.md:1` sagte *„Paket 1.0.112, Stand 20.10.2026"*. `:5-9` sagten:

> Testverzeichnis `C:\Users\Gregor\Eudora72-1.0.110-release` …
> Unter *Help → About Eudora* muss **7.2.0.110** stehen.

Der Plan wurde heute zweimal umgebaut; dabei ist der Kopf mitgewandert und der
Körper stehen geblieben. **Schlimmer als die Nummer ist aber, was der Plan
verlangte:** die beiden Schritte unter *„Was jetzt zu testen ist"* sind **beide
erledigt** — Schritt 1 (Speichern) am 20.10. an 1.0.110, Schritt 2 (Beenden
während einer Übertragung) am 20.10. an 1.0.111, auf beiden Wegen. Beides steht
in den veröffentlichten Notizen als bestätigt. Der Plan hätte Gregor Arbeit
abverlangt, die er schon geleistet hat
([Nie benutzt ist nicht geprüft](../Arbeitsweise/nie-benutzt-ist-nicht-geprueft.md)
gilt auch umgekehrt: schon geprüft ist nicht noch einmal zu prüfen).

**Neu:** der Kopf nennt, was wirklich offen ist und wofür es ihn braucht —
[E-131](../Intern/BEFUNDE.md#e-131), von außen gemeldet, von uns nicht nachgestellt,
mit der Auflage, vorher `Eudora.ini` und Mailverzeichnis zu sichern. Die beiden
erledigten Schritte stehen als **[C7](../Intern/TESTPLAN.md#c7)** weiter da, jeder mit
dem Paket, an dem er gemessen wurde. Der Buchführungsabschnitt (`:118`) stand
auf *„Stand 20.10.2026, Paket 1.0.110"* und nennt jetzt alle drei Pakete
getrennt — samt dem Satz, dass an **1.0.112 selbst nichts am laufenden Programm
gemessen** ist.

### <a id="l-43.6"></a>L-43.6 — E-131 stand als verwaiste Tabellenzeile in der allerletzten Zeile von BEFUNDE.md (mittel)

`grep -n 'a id="e-131"' BEFUNDE.md` traf **Zeile 8666 von 8666** — die letzte
Zeile der Datei. Darüber: der Abschnitt *„### Was dieser Befund **nicht**
behebt"* eines Befundes über den Werbeserver (`CAdFailureNagTask`). Die Zeile
beginnt mit `|` und endet mit `|`, hat aber weder Kopfzeile noch Nachbarn —
in Markdown rendert sie als **rohe Zeile voller senkrechter Striche** unter
einer fremden Überschrift. Dieselbe Klasse wie
[L-42.8](LEKTOR-42.md#l-42.8) (`tools/ZWEIGE.md`) und [L-43.8](#l-43.8).

Im **Verzeichnis** oben, wo [E-128](../Intern/BEFUNDE.md#e-128) bis
[E-130](../Intern/BEFUNDE.md#e-130) stehen und wo `befund-suchen.pl` und jeder Leser
sucht, fehlte er. Zeile **wörtlich unverändert** dorthin verschoben, hinter
[E-130](../Intern/BEFUNDE.md#e-130).

Dass `offene-befunde.pl` trotzdem 36/36 meldete, ist kein Trost: das Werkzeug
findet die Zeile über ihr Muster, egal wo sie liegt. Ein Mensch findet sie nicht.

### <a id="l-43.7"></a>L-43.7 — die CHANGELOG-Liste „Noch offen" vom heutigen Tag kannte drei der vier neuen Befunde nicht (mittel)

`CHANGELOG.md:12` heißt *„## Noch offen (Stand 20.10.2026)"*. Die Tabelle
darunter führt 28 Kennungen. **Gemessen:** [`E-128`](../Intern/BEFUNDE.md#e-128) 0 Treffer in der ganzen
Datei, [`E-129`](../Intern/BEFUNDE.md#e-129) 0, [`E-130`](../Intern/BEFUNDE.md#e-130) 0; [`E-131`](../Intern/BEFUNDE.md#e-131) **ein** Treffer, und der steht im
Abschnitt 7.2.0.112 (*„in dieser Fassung ausdrücklich NICHT angefasst"*), nicht
in der Liste.

Eine Liste, die sich im Titel auf den heutigen Tag datiert und drei heute
aufgenommene Befunde nicht nennt, ist schlechter als eine undatierte. Vier
Zeilen an den Kopf der Tabelle gesetzt ([E-131](../Intern/BEFUNDE.md#e-131), [E-130](../Intern/BEFUNDE.md#e-130), [E-129](../Intern/BEFUNDE.md#e-129), [E-128](../Intern/BEFUNDE.md#e-128) — die
Tabelle ist neueste-zuerst geordnet), jede mit Urteil, Datenverlustfrage und
Abhilfe.

### <a id="l-43.8"></a>L-43.8 — `tools/RELEASES.md`: die Fassung 112 fehlte, und die beiden jüngsten Zeilen standen außerhalb der Tabelle (mittel)

Zwei Mängel an derselben Datei.

**Erstens:** das Verzeichnis der Veröffentlichungen nannte `v1.0.112` nicht.
Die Zeile existiert — aber **nur als uncommittete Änderung in Gregors
Hauptarbeitsbaum** (`git diff` dort zeigt sie). Das Release-Skript hat sie
geschrieben, niemand hat sie committet, und auf `main` steht sie nicht. Genau
der Fall, den der Zitatblock in derselben Datei beschreibt: *„wer diese Datei
liest, glaubt, seit dem 13.09.2026 sei nichts hinausgegangen"*. Die Zeile aus
dem Hauptbaum übernommen (Zeitstempel `2026-10-20 13:55:11`, Gregors Zitat),
ergänzt um Marke und *Latest*.

**Zweitens:** die Zeile zu `v1.0.101` stand **hinter** dem Zitatblock, der auf
die Tabelle folgt (`:34-43`) — also außerhalb der Tabelle, als roher Text mit
Strichen. Die neue 112er-Zeile wäre an dieselbe Stelle gewandert. Beide stehen
jetzt in der Tabelle, hinter `v1.0.87`; der Zitatblock bleibt darunter.
Dass das Anhängen die Tabelle verfehlt, ist ein Mangel am **Werkzeug**, das die
Zeile schreibt — Vorschlag in [L-43.12](#l-43.12).

### <a id="l-43.9"></a>L-43.9 — auf `main` liegen Release-Notizen für ein Paket, das es nie gab, mit ungefülltem Platzhalter (mittel)

Die Buchführung der drei Nummern, gemessen gegen `git`, `gh` und das
Dateisystem:

| Nummer | geschnürt? | bei Gregor? | veröffentlicht? | `Releases/<nr>/` |
|---|---|---|---|---|
| **1.0.110** | ja, 19.10. | ja | **nein**, kein Tag | `TESTEN.txt` **und** `RELEASE-NOTIZEN.md` |
| **1.0.111** | ja, 20.10. 13:13 | ja, und **getestet** | **nein**, kein Tag | **weg** — in `61c91b43` nach `1.0.112` umbenannt (`R078`) |
| **1.0.112** | ja, 20.10. 13:41 | ja | **ja**, `v1.0.112`, 11:55:10 UTC | `TESTEN.txt`, `RELEASE-NOTIZEN.md` |

`Releases/PAKETE.md` führt alle drei mit eigenem Abschnitt — das stimmt. Zwei
Dinge stimmten nicht:

* Der Abschnitt **1.0.112** sagte mit keinem Wort, dass das Paket
  **veröffentlicht** ist. Überschrift und eine Zeile *Veröffentlicht* mit
  Marke, Zeitpunkt und SHA-256 ergänzt.
* `Releases/1.0.110/RELEASE-NOTIZEN.md` liegt auf `main` mit der Zeile
  *„SHA-256 des ZIPs: `<wird beim Schnüren eingetragen>`"* — für ein Paket, das
  nie veröffentlicht wurde. Es ist eine **Anleitung**, kein Rückblick, und
  Anleitungen sind Aufforderungen zu handeln
  ([L-42.10](LEKTOR-42.md#l-42.10)). Datierter Nachtrag an den Kopf gesetzt:
  nie veröffentlicht, kein Tag, Inhalt steckt in `v1.0.112`, als Anleitung gilt
  sie nicht; der Platzhalter ist als solcher benannt. Der Text darunter bleibt
  unverändert stehen.

**1.0.111 ist nicht „leer oder weg" im Sinne eines Versehens:** die Datei wurde
umbenannt, die Historie ist lückenlos (`git log --follow`). Nur die Verstümmelung
aus [L-43.1](#l-43.1) ist dabei mitgewandert.

### <a id="l-43.10"></a>L-43.10 — LEKTORAT und der Nachtrag von heute früh

`LEKTORAT.md` trug bereits einen *Nachtrag am 20.10.2026*, der 7.2.0.111 als
Quellstand nennt — richtig zum Zeitpunkt des Schreibens, seit 13:41 überholt.
Eintrag für diesen Durchgang angefügt und der Nachtrag auf 7.2.0.112 und
`v1.0.112` fortgeschrieben.

---

## Offen — gemeldet, nicht geändert

Alles unter dieser Überschrift ist Quelltext in `tools/` und damit außerhalb
meines Auftrags.

### <a id="l-43.11"></a>L-43.11 — die Schranke gegen Release-Lügen läuft im falschen Augenblick (hoch)

`pruefe-release-buchfuehrung.pl` ist **genau** für diesen Fall gebaut; ihr
Kopfkommentar zitiert Gregor mit *„keine luegen auf dem main"* und *„repariere
deine schranken, so dass VOR dem commit und merge alles auf github vorhanden
ist"*. Sie hat heute auch funktioniert: sechs Stellen, alle richtig.

**Nur hat sie niemand zum richtigen Zeitpunkt laufen lassen, und das konnte sie
auch nicht.** Sie hängt in `pre-commit` und `pre-push`
(`tools/hooks-einrichten.sh:336`, `:497`). Ihr Maßstab ist das höchste Tag. Die
Reihenfolge eines Release ist:

1. letzter Commit — Tag ist noch `v1.0.101`, die Dokumente sagen `v1.0.101`: **grün, zu Recht**
2. `release-veroeffentlichen.ps1` setzt `v1.0.112` — **in diesem Augenblick werden alle Dokumente unwahr**
3. danach: kein Commit, also kein Haken, also keine Messung

So stand `main` von 11:55 bis zu meinem ersten Commit mit sechs falschen
Stellen da. **Vorschlag:** `release-veroeffentlichen.ps1` ruft
`pruefe-release-buchfuehrung.pl` ein zweites Mal auf, **nachdem** das Tag steht,
und weist das Release nicht ab (es ist schon draußen), sondern **nennt die
Stellen und verlangt den Nachzieh-Commit, bevor es sich beendet**. Das ist
dieselbe Bauart wie
[Auslöser an den Anfang](../Arbeitsweise/ausloeser-an-den-anfang.md), nur am
anderen Ende.

### <a id="l-43.12"></a>L-43.12 — `paket-bereit.pl` meldet „alle Schranken vor dem Paket" und meint acht von mehr (mittel)

`paket-bereit.pl` sagt im Kopf *„8 Schranke(n), gelesen aus paket-bauen.ps1"*.
`pruefe-release-buchfuehrung.pl` ist **nicht darunter** — `grep` in
`paket-bauen.ps1` findet sie nicht. Beim ersten Lauf dieses Durchgangs meldete
`paket-bereit.pl` also *„FREI"* für alles außer der Rollenschranke, während
dieselbe Schranke von Hand aufgerufen **sechs Mängel** nannte.

Das ist [Schranke teilt nicht die
Annahme](../Arbeitsweise/schranke-teilt-nicht-die-annahme.md) in Reinform: das
Übersichtswerkzeug nimmt seinen Umfang aus **einer** Datei und gibt sich als
Gesamtbild aus. **Vorschlag:** den Umfang aus `tools/hooks-einrichten.sh`
nehmen (dort stehen alle) oder beide Mengen gegeneinanderhalten und die
Differenz ausgeben — *„3 Schranken laufen im Haken, aber nicht vor dem
Paket: …"*.

**Zweiter Punkt an derselben Stelle:** `tools/RELEASES.md` bekommt seine Zeile
von einem Skript angehängt, und zwar ans **Dateiende** statt ans Tabellenende
([L-43.8](#l-43.8)). Vorschlag: vor der letzten Zeile der Tabelle einsetzen,
nicht anhängen — und danach prüfen, dass die Zeile noch an einer Tabellenzeile
hängt.

### <a id="l-43.13"></a>L-43.13 — `ist_standaussage()` hört auf Wörter, nicht auf Aussagen (mittel)

Beim Berichtigen von `AUFGABEN.md:124` habe ich den wahrheitsgemäßen Rückblick
*„**Davor `v1.0.101`** — am 17.10.2026 … (damals *Latest*, Marke auf
`eec4e4e5`…)"* geschrieben. `pruefe-release-buchfuehrung.pl` wies ab:
*„AUFGABEN.md:124 gibt 1.0.101 als aktuellen Stand aus"*. Grund:
`ist_standaussage()` (`:195-202`) schlägt bei `als *Latest*` an, egal ob
*„damals"* davorsteht. Mein zweiter Versuch (*„damals das neueste Release"*)
traf die Zeile daneben (`/neueste[sn]?\s+(?:Release|Fassung|Paket)/`). Erst
*„seinerzeit auf GitHub bereitgestellt"* kam durch.

Das ist dieselbe Klasse wie [`L-15.5`](LEKTOR-15.md#l-15.5)/[E-109](../Intern/BEFUNDE.md#e-109) — *Wortauslöser
statt Aussage* —, und sie kostet zweimal: einmal den Fehlalarm, einmal die
Umformulierung, die am Ende **weniger** genau ist als der Text davor (jetzt
steht nicht mehr da, dass `v1.0.101` einmal *Latest* war). **Vorschlag:** ein
Vergangenheitsmerkmal vor dem Auslöser (*damals*, *seinerzeit*, *bis zum*,
*abgelöst durch*, *davor*) den Satz entschärfen lassen.

### <a id="l-43.14"></a>L-43.14 — die PRÜFER-Berichte haben vier Nummernkreise, und `P-39` ist schon vergeben (mittel)

Mein Auftrag nannte *„P-39.x"*. Diese Kennung gibt es nicht, und der Name ist
gefährlich:

| Bericht | Kennungen |
|---|---|
| `PRUEFER-36` | `P1`, `P2`, `P3` |
| `PRUEFER-37` | `F1` … `F4` |
| `PRUEFER-38` | `R1` … `R4` |
| `PRUEFER-39` | `N1` … `N9` |

Kein Kreis trägt die Nummer seines Berichts, und vier Buchstaben stehen für
dasselbe. **[`P-39`](PRUEFER-14.md#p-39) existiert bereits** — als Befund in
`Befunde/PRUEFER-14.md:731` (*„der Suchlauf vergleicht Stile, nicht Bilder"*,
zu [E-103](../Intern/BEFUNDE.md#e-103)), zitiert in `PRUEFER-16.md` an vier Stellen.
Wer *„[P-39](PRUEFER-14.md#p-39)"* schreibt und `PRÜFER-39` meint, trifft einen fremden Befund.

**Der LEKTOR macht es anders und richtig:** [`L-42.1`](LEKTOR-42.md#l-42.1) bis [`L-42.15`](LEKTOR-42.md#l-42.15) tragen die
Berichtsnummer, sind eindeutig und über `#l-42.n` verlinkbar — alle 15 Anker
geprüft, vollständig. **Vorschlag an den PRÜFER:** `P-39.1` … `P-39.9` statt
`N1` … `N9`, mit Anker. Das ist seine Entscheidung, nicht meine; ich habe die
bestehenden Kennungen **nicht** umbenannt, weil datierte Berichte Rückblicke
sind.

### <a id="l-43.15"></a>L-43.15 — kein Dokument prüft die Release-Notizen auf Befundurteile (mittel)

`pruefe-befundurteile.pl` liest weiterhin die feste Liste aus
[L-42.12](LEKTOR-42.md#l-42.12): `README.md`, `FILTER.md`, `PORTIERUNG.md`,
`ZIEL.md`, `CHANGELOG.md`, `WEITERMACHEN.md`, `Releases/1.0.3/LIESMICH.txt`
(`:235-243`, unverändert). **`Releases/*/RELEASE-NOTIZEN.md` steht nicht
darin** — ausgerechnet das Dokument, das veröffentlicht wird.

Hätten die Notizen einen offenen Befund als behoben ausgegeben, hätte das
niemand gemerkt. Diesmal taten sie es nicht (ich habe alle Urteile gegen
`BEFUNDE.md` gehalten; [E-123](../Intern/BEFUNDE.md#e-123) wird korrekt als *weiterhin
möglich nach Absturz* geführt, [E-101](../Intern/BEFUNDE.md#e-101)s Teilbehebung
korrekt beschrieben). Aber [L-43.2](#l-43.2) zeigt, dass gerade dieses Dokument
die Fehler sammelt. **Vorschlag:** den Umfang am Merkmal aufhängen statt an der
Positivliste — alle `*.md` außer `Befunde/`, `Arbeitsweise/` und `LEKTORAT.md`,
wie schon in [L-42.12](LEKTOR-42.md#l-42.12) vorgeschlagen; das nimmt
`TESTPLAN.md`, `AUFGABEN.md`, `Releases/PAKETE.md` **und** die Release-Notizen
mit hinein.

### <a id="l-43.16"></a>L-43.16 — aus LEKTOR-42 weiter offen

| Punkt | Stand heute |
|---|---|
| [L-42.11](LEKTOR-42.md#l-42.11) drei Hinweise *zur Kenntnis* aus `doku-pruefen.pl` | **unverändert** — `Releases/1.0.101/RELEASE-NOTIZEN.md`, `Testdaten/README.md`, `tools/pruefdaten/LIESMICH.md`. Alle drei zu Recht; der Vorschlag einer Ausnahmeliste steht seit [L-41.10](LEKTOR-41.md#l-41.10) |
| [L-42.12](LEKTOR-42.md#l-42.12) `pruefe-befundurteile.pl` prüft 7 Dateien von Hand | **offen**, verschärft durch [L-43.15](#l-43.15) |
| [L-42.13](LEKTOR-42.md#l-42.13) `doku-pruefen.pl` sieht Widerspruch in derselben Tabelle nicht | **offen** |
| [L-42.14](LEKTOR-42.md#l-42.14) / [L-41.3](LEKTOR-41.md#l-41.3) [E-123](../Intern/BEFUNDE.md#e-123) fehlt im Maßstab 7.2.1.0 | **offen** — `ZIEL.md:18-34` führt [E-123](../Intern/BEFUNDE.md#e-123) und [E-122](../Intern/BEFUNDE.md#e-122) bis [E-131](../Intern/BEFUNDE.md#e-131) weder als Voraussetzung noch unter *ausdrücklich nicht*. **Gregors Entscheidung**, und mit vier neuen Befunden dringlicher als gestern |
| [L-41.8](LEKTOR-41.md#l-41.8) zwei Messskripte ohne Eintrag in `tools/WERKZEUGE.md` | **offen** |
| [L-38.5](LEKTOR-38.md#l-38.5) [E-78](../Intern/BEFUNDE.md#e-78) in der README-Tabelle | **offen** |
| [L-37.10](LEKTOR-37.md#l-37.10) AUFGABEN ohne Zeilen für [E-122](../Intern/BEFUNDE.md#e-122) ff. | **offen**, jetzt bis [E-131](../Intern/BEFUNDE.md#e-131) |
| [L-37.13](LEKTOR-37.md#l-37.13) / [E-130](../Intern/BEFUNDE.md#e-130) fünf DLLs im Hauptbaum | **als Befund aufgenommen** ([E-130](../Intern/BEFUNDE.md#e-130)), Entscheidung getroffen: nicht committen. Der Hauptbaum zeigt sie weiter als ` M` |
| [L-42.15](LEKTOR-42.md#l-42.15) PRÜFER wegen reinem Versionssprung fällig | **entschärft** — `rollen-faellig.pl` meldet PRÜFER heute *aktuell*. Fällig sind LEKTOR (dieser Lauf) und **CHRONIST** |

---

## Was bewusst stehen geblieben ist

* **Der veröffentlichte Text auf GitHub.** Berichtigt ist die Datei im Repo;
  die Release-Beschreibung auf GitHub trägt die drei Schäden aus
  [L-43.1](#l-43.1) und die falsche Zuschreibung aus [L-43.2](#l-43.2) weiter.
  Das ist eine Aussage nach außen und damit Gregors Entscheidung.
* **Die Kennungen `N1`–`N9` in `Befunde/PRUEFER-39.md`.** Datierte Berichte
  sind Rückblicke ([L-43.14](#l-43.14)).
* **Die Überschrift *„Gregors Test an 1.0.111 — wenn N1 und N3 drin sind"***
  in `PRUEFER-39.md`. Anders als die Fälle in
  [L-42.10](LEKTOR-42.md#l-42.10) **gibt** es 1.0.111: es wurde geschnürt,
  bereitgestellt und von Gregor getestet. Kein Nachtrag nötig.
* **`Releases/1.0.101/RELEASE-NOTIZEN.md`** — veröffentlichter Text zu genau
  dieser Fassung, unverändert richtig.
* **Alle Abschnitte in `CHANGELOG.md` zu 7.2.0.111 und älter**, alle
  `Releases/PAKETE.md`-Abschnitte unterhalb 1.0.112, `LEKTORAT.md` insgesamt:
  Fassungsgeschichte.
* **`ZIEL.md:18-34`**, die Maßstabstabelle für 7.2.1.0 — welche der neuen
  Befunde Voraussetzung sind, entscheidet Gregor.

---

## <a id="l-43.17"></a>L-43.17 — eine Behauptung, die ich weder belegen noch widerlegen kann

Die veröffentlichten Notizen sagen:

> **Dieses Paket wurde vor dem Hochladen mit Defender geprüft: 0 Funde**
> (34 Dateien).

**Gemessen:** im ganzen Repo gibt es **keinen** Defender-Beleg zu 1.0.112 oder
1.0.111. `Releases/PAKETE.md` führt eine Defender-Zeile zuletzt für **1.0.101**
(`:377`) — *„sauber (Paketprüfung, 34 Dateien, 0 Funde)"*, mit **derselben
Dateizahl und demselben Ergebnis**. `release-veroeffentlichen.ps1` nennt
Defender nicht, und die Commit-Nachricht des Releases (`a872293d`) nennt ihn
auch nicht; sie führt nur *„Prueflauf mit `-NurPruefen`: alle Voraussetzungen
erfuellt"* an.

Daraus folgt **nicht**, dass die Prüfung nicht stattgefunden hat — nur, dass
nichts im Repo sie belegt und dass die Zahl die des Vorgängerpakets ist. Ich
habe den Satz **nicht geändert**: wenn der Lauf stattfand, wäre meine
„Berichtigung" die Unwahrheit. Nach
[Eingebaute Messung auslesen](../Arbeitsweise/eingebaute-messung-auslesen.md)
gehört das Ergebnis aber in `Releases/PAKETE.md`, bevor es in die Notizen
kommt. **Das muss Gregor entscheiden** — siehe unten.

---

## Was Gregor entscheiden muss

1. **Die veröffentlichte Release-Beschreibung berichtigen?** Die Datei im Repo
   ist in Ordnung; GitHub trägt den alten Text. Ein Befehl, kein neues Release,
   kein neues ZIP, die Marke bleibt:

   ```sh
   gh release edit v1.0.112 --notes-file Releases/1.0.112/RELEASE-NOTIZEN.md
   ```

   **Dafür spricht:** der Text ist öffentlich, der E-69-Punkt fehlt, und ein
   Satz bricht mitten ab. **Dagegen spricht nichts, was ich sehe** — aber es
   ist eine Aussage nach außen, und die setze ich nicht ohne ihn ab.

2. **Defender zu 1.0.112:** lief er? Wenn ja, trage ich das Ergebnis in
   `Releases/PAKETE.md` nach. Wenn nein, gehört der Satz aus den Notizen
   heraus ([L-43.17](#l-43.17)).

3. **[E-131](../Intern/BEFUNDE.md#e-131) im Maßstab** `ZIEL.md:18-34`: Voraussetzung
   für 7.2.1.0 oder ausdrücklich nicht? Er ist der erste Fehler, den ein
   Fremder gemeldet hat, er trifft jeden mit vorhandener Installation, und im
   Hauptarbeitsbaum läuft bereits ein Zweig `e-131-leistenposition`. Dasselbe
   steht seit [L-41.3](LEKTOR-41.md#l-41.3) für
   [E-122](../Intern/BEFUNDE.md#e-122) bis [E-130](../Intern/BEFUNDE.md#e-130) offen.

4. **Die drei Werkzeugvorschläge** aus [L-43.11](#l-43.11),
   [L-43.12](#l-43.12) und [L-43.13](#l-43.13) — soll ich sie bauen, oder
   gehören sie an den PRÜFER? Der erste ist der wichtigste: ohne ihn wiederholt
   sich [L-43.3](#l-43.3) bei jedem Release.

---

## Geänderte Dateien

`Releases/1.0.112/RELEASE-NOTIZEN.md`, `Releases/1.0.110/RELEASE-NOTIZEN.md`,
`Releases/PAKETE.md`, `README.md`, `WEITERMACHEN.md`, `TESTPLAN.md`,
`CHANGELOG.md`, `ZIEL.md`, `AUFGABEN.md`, `BEFUNDE.md`, `tools/RELEASES.md`,
`LEKTORAT.md`, dieser Bericht.

**Keine Datei unter `Eudora71/` angefasst, kein Werkzeug unter `tools/*.pl`
oder `*.ps1` geändert.**

Nach jedem Schreibzugriff gemessen: **CRLF 0**, reine LF, UTF-8 ohne BOM,
**0** neue Doppelkodierungen (`Ã` kommt in `BEFUNDE.md` dreimal vor, an allen
drei Stellen als *zitiertes Beispiel* für Fehlkodierung — gegen `HEAD`
verglichen: unverändert). `perl tools/commit-bereit.pl` vor jedem Commit:
**32 Schranken, keine weist ab.**
