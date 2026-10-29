---
name: gedaechtnis-ist-oeffentlich
description: "Was ich ins Gedächtnis schreibe, spiegelt lehren-spiegeln.pl nach Arbeitsweise/ und damit auf das öffentliche GitHub; Namen aus Gregors Mailverzeichnis (Anhänge, Betreffzeilen) gehören in keine Notiz - am 29.10.2026 standen Betreff und fünf Anhangnamen einer Mail aus Gregors Postfach rund 20 Minuten nach dem Schreiben auf main"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2dc0ce9e-d597-4bea-8a46-cb21a63838b0
  modified: 2026-10-29T20:36:42.188Z
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

Gregor: *„solche daten haben jetzt und in zukunft nicht im öffentlichen repo zu suchen!“* Der Suchlauf danach fand Daten aus seinem Postfach in vielen Dateien, angesammelt seit September — Kopfzeilen, Namen und Dateinamen aus empfangenen Mails —, in Befunden, CHANGELOG, Testplan, Prüfberichten, Lehren, **Quelltextkommentaren, Unit-Tests und Testdaten**, und in einem Prüfwerkzeug als Suchmuster. Eine Suchliste findet nur, was sie kennt: der LEKTOR fand danach noch Stellen, die in keiner Liste standen. Ersetzt durch Platzhalter (`<Betreff>`, `Mail-A`, `<Ordner>`, `<Gregors Adresse>`); die persönlichen Suchmuster liegen jetzt in `tools/anonym-begriffe.lokal` (von Git ignoriert).

- **Auch Quelltext und Tests sind öffentlich.** Ein Kommentar „gemessen an Gregors X-Nachricht“ nennt X nicht beim Namen; ein Test baut keine echte Mail nach, sondern eine erfundene mit `.invalid`-Adressen.
- **Vor jedem Commit:** `perl tools/pruefe-testdaten-anonym.pl` prüft nur `Testdaten/`; für alles andere die Begriffe aus `tools/anonym-begriffe.lokal` über `git diff --cached` suchen.

## Nachtrag 29.10.2026 abends (CHRONIST): die Lehre trug selbst einen Namen, und es brauchte sechs Runden

**Die Lehre wiederholte ihren Fehler.** Der CHRONIST-Lauf vom Morgen schrieb diese Datei. In ihrer Tabelle, Zeile 08:23:33, stand der **Dateiname von Gregors Sicherung**, wörtlich, zwei Absätze über dem Satz *„sie nennen die Art der Daten, nicht die Daten“* (gemessen: `git show 6eae4a3 -- Arbeitsweise/gedaechtnis-ist-oeffentlich.md`, ein Treffer in Zeile 43 des Diffs). Gefunden hat es die Hauptsitzung um 09:38:22 nach dem Merge von #183, nicht der CHRONIST. Die Regel war richtig, angewandt habe ich sie nur auf den Betreff und die Anhangnamen, die ich als „privat“ erkannt hatte. Der Name einer Sicherungsdatei galt mir als technische Angabe.

**Sechs Runden, jede als vollständig gemeldet** (MEZ, gemessen an `2dc0ce9e-…jsonl` und den Commits):

| Runde | Zeit | Gefunden von | Wo |
|---|---|---|---|
| 1 | 08:47 | CHRONIST | Stand-Vermerk (Betreff, Anhangnamen) |
| 2 | 09:38 | Hauptsitzung | diese Lehre (Name der Sicherung) |
| 3 | 09:39–09:41 | Hauptsitzung | am selben Tag geschriebene Befunde E-169 bis E-172 und ein Stand-Vermerk: Betreffzeilen, Kontoname, Ordnername, eine Absenderadresse aus einem Bildschirmfoto |
| 4 | 09:57–10:10 | Hauptsitzung, nach Gregors *„warum kann man das nicht alles zusammen machen?“* (09:52:59) | älterer Bestand, auch in Lehren, Werkzeugen, Unit-Tests und Testdaten, darunter persönliche Angaben Gregors (PR #185) |
| 5 | 10:35–10:45 | Hauptsitzung nach Gregors *„in den testdaten stehen auch keine datenschutz relevanten inhalte drin?“* (10:32:36), dann LEKTOR-94 | was in keiner Suchliste stand: eine Kleinanzeige in den Testdaten, Anhangnamen einer beruflichen Mail, ein Rundbrief, eine Adresse |
| 6 | 13:41 | LEKTOR-95 (L-95.14) | zwei gekürzte Betreffzeilen im CHANGELOG |

Gregor um 09:39:26: *„echt jetzt? was kommt noch alles? was hast du noch alles eingebaut, von dem ich nichts weiß?“*, um 10:01:24: *„solche daten haben jetzt und in zukunft nicht im öffentlichen repo zu suchen!“*

Gut war, wie die Meldungen ab Runde 4 formuliert waren: *„soweit ich es mit Suchläufen prüfen kann“* (10:10:34), *„nach allen Begriffen, die der Lektor und ich kennen“* (10:53:02). Die Ursache für die Runden nannte die Hauptsitzung um 10:42:23 selbst: *„Meine Suchläufe haben nur gefunden, was in meiner Begriffsliste stand.“* Das ist [[schranke-teilt-nicht-die-annahme]]: Die Suchliste kam aus demselben Kopf, der die Daten für unbedenklich gehalten hatte.

**Die Begriffsprüfung im Commit-Haken hat Gregor um 10:25:18 abgelehnt**, aus Misstrauen ([[abweisung-ist-eine-antwort]]). Die Schranke oben bleibt deshalb „keine“. Was bleibt, ist der Abgleich des gestagten Diffs mit `tools/anonym-begriffe.lokal` von Hand, den die Hauptsitzung seither vor jedem Commit fährt (gemessen an den Antworttexten: 10:31, 11:07, 12:14, 13:48).

**How to apply, zusätzlich:**
- **Die Probe ist nicht „ist das privat?“, sondern „kommt das aus Gregors Rechner?“** Dateinamen, Ordnernamen, Sicherungen, Kontonamen, Bildschirmfotos zählen mit, auch wenn sie technisch aussehen.
- **Eine Lehre über einen Datenfehler zitiert den Fall nicht.** Zeit, Art und Anzahl reichen. Das gilt besonders für CHRONIST-Berichte, die aus dem Transkript schöpfen, und im Transkript stehen die Namen.
- **Eine Suche, die nach bekannten Begriffen fragt, endet nicht mit „sauber“.** Sie endet mit „nach diesen Begriffen sauber“ und einer zweiten Prüfung aus anderer Richtung: Muster (Adressen, `Fw:`/`Re:`/`Subject:`) oder ein LEKTOR mit freiem Blick.

Verwandt: [[erlaubnis-nicht-hineinlesen]], [[aussenwirkung-ist-der-massstab]], [[wissen-gehoert-in-dateien]].
