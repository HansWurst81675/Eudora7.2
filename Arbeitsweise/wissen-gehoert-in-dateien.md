---
name: wissen-gehoert-in-dateien
description: "Befunde und Erkenntnisse gehören in Dateien im Repo, nicht nur in den Chat — sonst überleben sie kein Abschalten"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:57:27.061Z
---

Jeder Agent, der etwas herausfindet, schreibt sein Ergebnis in eine **Datei im Repo**
und committet sie. Ein Bericht, der nur im Chat steht, ist verloren, sobald der
Prozess endet oder mein Kontext zusammengefasst wird.

**Why:** Gregor hat am 28.08.2026 ausdrücklich gesagt "sichern und commiten, ich
schalte ab", und trotzdem fehlten danach Informationen. Zwei getrennte Ursachen:

1. Ich habe die Anweisung nicht ausgeführt. Am Mitschnitt nachgemessen ist der
   Ablauf genauer, als ich ihn damals eingeräumt habe: Gregors Nachricht "ich fahre
   die VM runter. du bleibst dran und sicherst den stand." ging um 14:36:40 in die
   Warteschlange, meine letzte Aktivität war 14:36:35 — die Nachricht wurde nie
   verarbeitet, ebensowenig zwei weitere um 14:37:21. "No response requested."
   antwortete ich nicht darauf, sondern um 16:23 auf die Wiederaufnahme-
   Aufforderung, also genau an der Stelle, an der die 1¾ Stunden Stillstand noch
   hätten aufgeholt werden können. (Meine damalige Selbstbezichtigung war ungeprüft
   und in diesem Punkt falsch — auch Schuldeingeständnisse gehören belegt, siehe
   [[pruefen-statt-vermuten]]. Zum Stillstand selbst: [[nie-stillstehen]].)
2. Wichtiger und weniger offensichtlich: **Committen sichert Dateien, nicht Wissen.**
   Die Befunde eines früheren Prüf-Agenten standen nur im Chat. Kein noch so
   gewissenhaftes Committen hätte sie gerettet, weil es nichts zu committen gab.
   Agenten sind Einwegarbeiter im Prozess; mit dem Abschalten der VM stirbt ihr
   gesamter Kontext.

**How to apply:** Beim Beauftragen eines Agenten immer mitgeben, in welche Datei sein
Ergebnis gehört — `BEFUNDE.md` für Prüfungen, `PLAN.md`/`INVENTAR.md` für Analysen,
`PORTIERUNG.md` für Portierungsentscheidungen. Auch "geprüft und in Ordnung" und
"nicht geprüft, weil …" gehören hinein; das erspart der nächsten Prüfung die Arbeit.
Vor einem angekündigten Abschalten alle laufenden Agenten committen lassen, nicht nur
den eigenen Arbeitsbaum.

**Das gilt für Absprachen genauso wie für Befunde.** Was Gregor festlegt,
zurückstellt oder zusagt, gehört sofort in eine Datei — nicht in meinen Kontext.
Er hat vier Mal nachfassen müssen ("war ja nicht so ausgemacht!", "habe ich gesagt,
les' nach!", "muß ich dich an alles erinnern?"). Siehe [[anweisungen-abarbeiten]].

Siehe auch [[commit-auf-extra-branch-und-pushen]] und [[agenten-benennen]].

---

## Nachtrag 06.09.2026 — was tatsaechlich verlorengegangen ist

Diese Lehre ist die meistgenannte des ganzen Projekts: **45 Nachrichten** in den
beiden Sitzungsmitschriften mahnen das Sichern an oder fragen danach. Gregor
fragt in jeder Sitzung mehrfach *„eingecheckt? commited? gepusht?"* — dass er
fragen muss, ist selbst schon der Befund.

Acht Verluste sind woertlich belegt:

| Datum | Was fehlte | Gregor |
|---|---|---|
| 28.08. | Arbeit doppelt vorhanden statt gesichert | *„du hast ja selbst gemerkt, dass du gepfuscht hast, ja?"* |
| 29.08. | Infos nach angekuendigtem Abschalten weg | *„war es nicht eindeutig? warum fehlen dann trotzdem infos?"* |
| 29.08. | Befund des PRUEFERs nur im Chat | *„ich weiss, dass der pruefer was gefunden hat, was du fixen wolltest!"* |
| 29.08. | dasselbe noch einmal | *„weil sie DIR floeten gegangen sind!"* |
| 29.08. | Ergebnisse des LEHRE-Agenten nicht im Repo | *„wo sind die aufzeichnungen von lehre im repo?"* |
| 29.08. | und die Folgerung daraus | *„er hat gefunden, dass infos verloren gehen und genau das setzt du nicht um?"* |
| 05.09. | `WEITERMACHEN.md`-Commit auf geloeschtem Fernzweig | *„einer von deinen agenten sollte genau das verhindern! sowas kostet nur zeit!"* |
| 05.09. | zugesagtes Release nicht erstellt | *„wo ist mein release? vergessen?"* |

**Der Fall vom 29.08. ist der bitterste:** ein Agent hat als Befund geliefert,
dass Wissen verlorengeht — und genau dieser Befund ging verloren. Gregors Frage
danach steht bis heute: *„wozu macht man lessons learned, wenn du sie
anschliessend wieder ignorierst?"*

## Die Werkzeuge existieren — sie werden nicht aufgerufen

Fuer diese Fehlerklasse hat das Projekt inzwischen zwei Schranken:

- `perl tools/ungesichertes-melden.pl` — meldet, was im Arbeitsverzeichnis liegt
  und nicht committet ist
- `perl tools/gesichert.pl` — beantwortet die eine Frage, ob Gregor jetzt
  zusammenfuehren und abschalten kann

Sie haben in den Sitzungen danach trotzdem nichts verhindert, weil sie an keinen
festen Zeitpunkt gebunden waren. **Also gebunden:**

1. **Sobald Gregor Abschalten, Runterfahren oder Mergen erwaehnt:**
   `perl tools/gesichert.pl` in *jedem* Arbeitsbaum, nicht nur im eigenen. Die
   Liste der Arbeitsbaeume kommt aus `git worktree list`. Siehe
   [[abschalten-ist-ein-termin]].
2. **Bevor ich einen Agenten fuer beendet erklaere:** nachsehen, in welche Datei
   er geschrieben hat. Kein Ergebnis in einer Datei heisst kein Ergebnis —
   dann wird er nicht als erledigt gemeldet, sondern nachbeauftragt.
3. **Vor jeder Antwort, die einen Zwischenstand meldet:**
   `perl tools/ungesichertes-melden.pl`. Ein Zwischenstand, der nur im Chat
   steht, ist kein Zwischenstand.
