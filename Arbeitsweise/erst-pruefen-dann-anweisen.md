---
name: erst-pruefen-dann-anweisen
description: "Keine Handlungsanweisung an Gregor geben, ohne sie vorher selbst durchgeführt und gemessen zu haben"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-31T05:44:00.043Z
---

Schranke: keine - ob ich eine Anleitung vor der Weitergabe selbst gefahren habe, steht nur im Chat; im Repo sieht eine ungeprüfte Anleitung genauso aus wie eine geprüfte

Wenn ich Gregor sage „schau unter *Hilfe → Über*" oder „starte es aus diesem
Verzeichnis", muss ich vorher **geprüft haben, dass dieser Weg funktioniert**.

**Why:** Am 31.08.2026 zweimal hintereinander falsch:

1. Ich sagte, die Version 7.2.0.3 sei im Startbildschirm und unter *Help → About*
   zu sehen — ohne geprüft zu haben, ob die frisch gebaute EXE überhaupt startet.
2. Ich schlug vor, sie aus `Eudora71\Bin\Debug` zu starten. Dort liegen die
   **Debug**-Fassungen der vorgebauten Fremd-DLLs von 2006, die `MSVCR71D.dll`
   verlangen. Das ist Befund S-1 — der Fehler, an dem schon Paket 1.0.1
   gescheitert war und den ich selbst dokumentiert hatte.

Seine Worte: *„erst prüfen, dann antworten! wenn exe nicht lauffähig, dann
schlage nicht vor, ich soll unter hilfe -> about nachschauen"*

Der Schaden ist nicht die falsche Auskunft an sich, sondern dass Gregor seine
Zeit für einen Weg aufwendet, den ich in Sekunden hätte ausschließen können.

**How to apply:**

- Vor jeder Handlungsanweisung: den Weg selbst gehen, soweit es ohne Fenster
  geht. Abhängigkeiten mit `dumpbin -dependents` oder
  `tools/paket-pruefen.ps1` durchrechnen, statt sie anzunehmen.
- Ein Verzeichnis, aus dem gebaut wird, ist **nicht** ein Verzeichnis, aus dem
  gestartet werden kann. `Bin\Debug` enthält den Bauzustand, nicht das Paket.
  Zum Starten gehört ein mit `tools/paket-bauen.ps1` erstelltes Verzeichnis.
- Was ich nicht prüfen kann (alles mit Fenstern, siehe
  [[nichts-auf-gregors-bildschirm-starten]]), sage ich als **ungeprüft** an —
  nicht als Anweisung.

Siehe [[pruefen-statt-vermuten]] und [[was-lauffaehig-heisst]].

## Nachtrag 07.09.2026 — zwei Funktionen mit fast gleichem Namen

Ich habe Gregor gesagt, mit den Werten in `tools/DEudora.ini` sei die Sache
erledigt: *„Damit brauchst du keinen Neubau."* Er hat es gefahren und
geantwortet: **„greift nicht"**.

Der Grund war eine Anleitung auf halb gelesenem Weg. Es gibt **zwei** Funktionen
mit fast gleichem Namen, und nur eine liest die Datei:

| Funktion | liest `DEudora.ini`? | benutzt fuer |
|---|---|---|
| `GetDefaultIniSetting` (`Eudora71/Eudora/rs.cpp:357-385`) | **ja** | ein **neu angelegtes** Konto, ueber `CPersParams::GetDefaultParams` |
| `CPersonality::GetIniDefaultValue` (`Eudora71/Eudora/persona.cpp:606`) | **nein** — nur `QCLoadString`, also die Ressource | ein **bestehendes** Konto beim Anzeigen |

Ich hatte den ersten Weg vollstaendig belegt (`WizardPropSheet.cpp:137` →
`GetDefaultParams()` → `GetDefaultIniSetting`) und daraus geschlossen, die Datei
wirke. Fuer den Dialog, den Gregor offen hatte — ein **bestehendes** Konto —
lief der zweite Weg. Dazu zwei weitere Bedingungen, die ich nicht angesagt
hatte: die Datei muss neben **genau der laufenden** `Eudora.exe` liegen
(`ExecutableDir` aus `GetModuleFileName`, `fileutil.cpp:418-435`), und der
Wert eines bestehenden Kontos steht ausdruecklich in der `Eudora.ini` und
schlaegt jede Vorgabe.

**Zusaetzlich zur Regel oben:**

- **Bevor ich sage „damit wirkt X": alle Leser des Werts aufzaehlen**, nicht den
  ersten gefundenen. `grep -rn '<Schluessel>\|<Funktionsname>'` ueber `*.cpp`
  und `*.h`, und jeden Treffer einordnen. Ein zweiter, aehnlich benannter
  Aufrufweg ist in diesem Quelltext die Regel, nicht die Ausnahme.
- **Die Anleitung nennt den Geltungsbereich.** „Fuer **neue** Konten" ist eine
  andere Zusage als „fuer dein offenes Fenster". Gregors Antwort darauf war
  praezise: *„fuer neue konten. bestehendes kann ich selbst korrigieren."*
- **Die Bedingungen gehoeren in die Anleitung**, nicht in die Erklaerung
  danach: welcher Pfad, welcher Stand, welcher Weg im Programm.
- **Und wenn ich es nicht selbst fahren kann, wird die Probe umgedreht** statt
  bestaetigt — Gregors Test hat die Frage in einem Zug entschieden
  ([[gegenprobe-umdrehen]]).

## Nachtrag 12./13.10.2026: zwei INI-Dateien, beide vor der Probe übergeben

**12.10.2026, 12:40 UTC.** Gregor: *„mach mir eine neue, saubere ini"*. Um
12:41 lag sie in seinem 1.0.84-Verzeichnis, nicht gestartet. Um 12:42:
*„kann keine mails abrufen, bei check for mails passiert nichts"*. Das
IMAP-Konto braucht in einem leeren Verzeichnis erst *Refresh Mailbox List*;
das wusste die INI nicht und ich auch nicht. Gleich danach, 12:45, sagte
ich ihm *„Das ist schon erledigt … alles frisch vom Server geholt"* — und
er: *„nein, ich habe sie vom backup zurück kopiert"*. Eine Behauptung über
seinen Bildschirm, ungemessen ([[pruefen-statt-vermuten]]).

**13.10.2026, Transkript `7cea137a-…jsonl` (UTC):**

| Zeit | Was geschah |
|---|---|
| 06:52:22 | Gregor: *„für AN-2 brauche ich eine saubere ini"* |
| 06:53:08 | ich übergebe `Eudora-AN2-sauber.ini` mit drei Handgriffen und *„Was richtig ist"*. Darunter: *„Diese INI habe ich nicht selbst gestartet. […] Sag „ja", dann starte ich."* Begründung in der Anleitung: *„Ohne `Mode`-Zeile startet Eudora in der Werbe-Betriebsart"* |
| 06:53:48 | Gregor: *„ja"* |
| 06:54:44 | Probelauf in `C:\Temp\AN2-1084`: Kontoassistent, **kein Werbeabruf** |
| 06:55:30 | Ursache: `BUILD_BOX_OR_SITE_R_VERSION` ist in Debug und Release gesetzt (`Eudora.vcxproj:78`, `:132`), seit `bf14e14` vom **30.08.2026** — die Vorgabe ist `Mode=2`, Pro, ohne Werbung |
| 06:56:23 | Gregor: *„was muß ich jetzt tun?"* |
| 06:58:59 | ich: *„Nimm die INI, die ich dir gegeben habe, nicht."* Dazwischen 2½ Minuten Hakenpflege am CHANGELOG |

Die Annahme stand seit `804c91e` (12.10.2026) in BEFUNDE, CHANGELOG 7.2.0.80
und AUFGABEN, mit der Begründung *„`BUILD_BOX_OR_SITE_R_VERSION` ist nicht
gesetzt"*. Ein `grep` über `Eudora71/Eudora/Eudora.vcxproj` hätte sie am
Tag ihres Entstehens widerlegt; der Schalter war damals sechs Wochen alt.

**Why:** Die Lehre oben erlaubt, Ungeprüftes **als ungeprüft** weiterzugeben,
wenn ich es nicht selbst fahren kann. Hier konnte ich es — in `C:\Temp`,
mit seiner Erlaubnis, eine Minute. Der Vermerk „nicht selbst gestartet"
stand **unter** einer fertigen Anleitung; gelesen wird die Anleitung. Und
als die Probe sie widerlegte, kam die Rücknahme erst nach dem Haken, obwohl
Gregor in der Zwischenzeit fragte, was er tun soll.

**How to apply, zusätzlich:**

- **Kann ich es in `C:\Temp` fahren, frage ich zuerst nach dem Probelauf**,
  nicht nach dem Einsatz. Die Anleitung kommt danach, mit dem, was der Lauf
  gezeigt hat. Für eine INI heißt das: mit genau dieser Datei einmal starten
  und den Zustand lesen, den Gregor sehen soll.
- **Die Begründung einer Anleitung ist selbst eine Behauptung.** Nennt sie
  einen Schalter, eine Vorgabe oder eine Datei („ist nicht gesetzt"), wird
  das vor dem Schreiben mit einem `grep` belegt — mit Fundstelle.
- **Widerruf vor Hakenpflege.** Ist eine Anweisung an Gregor widerlegt,
  ist der Widerruf die nächste Nachricht. Der Commit kann warten.
