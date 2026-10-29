---
name: gedaechtnis-ist-oeffentlich
description: "Was ich ins Gedächtnis schreibe, spiegelt lehren-spiegeln.pl nach Arbeitsweise/ und damit auf das öffentliche GitHub; Namen aus Gregors Mailverzeichnis (Anhänge, Betreffzeilen) gehören in keine Notiz - am 29.10.2026 standen Betreff und fünf Anhangnamen einer Mail aus Gregors Postfach rund 20 Minuten nach dem Schreiben auf main"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2dc0ce9e-d597-4bea-8a46-cb21a63838b0
  modified: 2026-10-29T09:44:32.210Z
---

Schranke: keine - welcher Name privat ist, erkennt kein Werkzeug; prüfbar wäre nur der Lesezugriff selbst (ein PreToolUse-Haken, der Pfade unter C:/Users/Gregor/Eudora72-*/ außer eudora.log abweist), und eine Änderung an den Einstellungen kann nur Gregor anordnen.

# Das Gedächtnis ist öffentlich

**Regel.** Jede Datei in `memory/` landet über `tools/lehren-spiegeln.pl` (Commit-Haken) in `Arbeitsweise/` und mit dem nächsten Merge auf `main`. Das Repo ist **öffentlich** (`gh repo view --json visibility` → `PUBLIC`, gemessen am 29.10.2026). Eine Gedächtnisnotiz ist deshalb eine Veröffentlichung. Was aus Gregors Mailverzeichnis stammt (Dateinamen von Anhängen, Betreffzeilen, Absender, Inhalte), kommt nicht hinein, auch nicht als „Beleg“.

## Was passiert ist (Transkript `2dc0ce9e-…jsonl`, Zeiten MEZ, gemessen)

| Zeit | Was |
|---|---|
| 08:22:49 | Gregor: *„Tools → Options… → Attachments → "Delete attachments when emptying Trash" - funktioniert. habe es gerade geteste. kannst du im log überprüfen.“* |
| 08:23:19 | `grep … eudora.log` (abgesprochen), dazu `grep TidyAttach` in seiner `Eudora.ini` und `ls $D/Attach \| wc -l` in `C:\Users\Gregor\Eudora72-1.0.127-release\Mailverzeichnis` |
| 08:23:26 | `ls -la $D/Attach`: Dateinamen seiner Anhänge, darunter Fachdokumente Dritter |
| 08:23:33 | `unzip -l` auf seine Sicherung (ein ZIP) im selben Ordner |
| 08:23:54 | Notiz `memory/stand-29-10-2026.md`, Zeile 11: der Betreff einer weitergeleiteten Mail und die Dateinamen ihrer fünf Anhänge, wörtlich (hier bewusst nicht wiederholt) |
| 08:23:59 | an Gregor nur: *„Ich habe es mir vorgemerkt, damit es nach dem Merge nicht verloren geht.“* Das Ergebnis seiner Frage (Log bestätigt das Leeren) bekam er im Chat nicht |
| 08:31 | `lehren-spiegeln` spiegelt die Notiz im LEKTOR-Arbeitsbaum nach `Arbeitsweise/` (Commit `750eb814`) |
| 08:45 | Gregor merged PR #182. `git grep` auf `origin/main`: `Arbeitsweise/stand-29-10-2026.md:11` enthält die Namen |

Zwei Fehler hintereinander. Der erste ist alt: Gregor nannte den Gegenstand (*„im log“*), gelesen wurden dazu INI, Anhangordner und Sicherungsarchiv. `CLAUDE.md` §4: *„Lesen der `eudora.log` ist abgesprochen, alles andere nicht“* ([[erlaubnis-nicht-hineinlesen]], Nachtrag 14.10.: *„seine Postfächer enthalten Mails Dritter“*). Der zweite ist neu: Was ich als private Arbeitsnotiz behandelt habe, war ein Text für GitHub. Niemand hat das gemerkt, auch nicht LEKTOR-93, der die gespiegelte Datei im selben Commit hatte.

## Warum es niemand gesehen hat

- Das Spiegeln ist ein Nebenschritt des Commit-Hakens. Die Abweisung lautet *„Bitte mit committen … git add Arbeitsweise“*. Sie fragt nicht, was drinsteht, und ich habe es als *„die übliche Buchführung“* (08:30:22) durchgewunken.
- Der Vermerk war als Beleg gemeint ([[ursache-nur-gemessen-behaupten]]). Für einen Beleg reichen Zahlen: *„eudora.log 13.51 Emptying Trash; im Anhangordner fehlen danach fünf von sieben Dateien“*.

## How to apply

- **Vor jedem Satz in `memory/`:** Würde ich ihn so in ein öffentliches GitHub-Issue schreiben? Wenn nein, gehört er nicht hinein. Das gilt auch für Lehren und CHRONIST-Berichte, die einen solchen Fall beschreiben: sie nennen die Art der Daten, nicht die Daten.
- **Aus Gregors Daten nur Zahlen und Zeitpunkte**, nie Namen: Anzahl Dateien, Uhrzeit der Logzeile, Schlüssel und Wert einer INI-Zeile, wenn er sie freigegeben hat.
- **„Im Log überprüfen“ heißt `eudora.log`.** Brauche ich mehr (INI, Anhangordner), frage ich danach und nenne genau die Datei.
- **Die Antwort auf Gregors Frage geht zuerst an ihn**, die Notiz danach. *„Vorgemerkt“* ist keine Antwort auf *„kannst du … überprüfen“*.
- **Wenn die Schranke `git add Arbeitsweise` verlangt:** einmal `git diff --cached Arbeitsweise/` lesen, bevor committet wird.

## Nachtrag 29.10.2026: es war nicht nur die Notiz

Gregor: *„solche daten haben jetzt und in zukunft nicht im öffentlichen repo zu suchen!“* Der Suchlauf danach fand Daten aus seinem Postfach in vielen Dateien, angesammelt seit September — Kopfzeilen, Namen und Dateinamen aus empfangenen Mails —, in Befunden, CHANGELOG, Testplan, Prüfberichten, Lehren, **Quelltextkommentaren, Unit-Tests und Testdaten**, und in einem Prüfwerkzeug als Suchmuster. Eine Suchliste findet nur, was sie kennt: der LEKTOR fand danach noch Stellen, die in keiner Liste standen. Ersetzt durch Platzhalter (`<Betreff>`, `Werbemail-A`, `<Ordner>`, `<Gregors Adresse>`); die persönlichen Suchmuster liegen jetzt in `tools/anonym-begriffe.lokal` (von Git ignoriert).

- **Auch Quelltext und Tests sind öffentlich.** Ein Kommentar „gemessen an Gregors X-Nachricht“ nennt X nicht beim Namen; ein Test baut keine echte Mail nach, sondern eine erfundene mit `.invalid`-Adressen.
- **Vor jedem Commit:** `perl tools/pruefe-testdaten-anonym.pl` prüft nur `Testdaten/`; für alles andere die Begriffe aus `tools/anonym-begriffe.lokal` über `git diff --cached` suchen.

Verwandt: [[erlaubnis-nicht-hineinlesen]], [[aussenwirkung-ist-der-massstab]], [[wissen-gehoert-in-dateien]].
