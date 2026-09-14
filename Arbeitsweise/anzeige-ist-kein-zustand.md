---
name: anzeige-ist-kein-zustand
description: "Ein Text aus der Oberflaeche ist eine Behauptung des Programms ueber sich selbst - E-83 suchte drei Tage ein Startproblem, das es nie gab"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-14T06:15:45.763Z
---

Schranke: keine - ob ein angezeigter Text den Zustand wirklich meint, zeigt erst der Lauf; im Quelltext sieht beides gleich aus

# Was das Programm über sich sagt, ist kein Messwert

**Gregor am 11.09.2026**, mit Bildschirmfoto von 1.0.48: eine Aufgabe
*Resyncing* steht in der Aufgabenliste, daneben

> *„Waiting in the task queue to be started …"*

und beim Beenden

> *„You currently have 1 task(s) running"*.

Daraus wurde die Überschrift von E-83: *„eine IMAP-Aufgabe bleibt in der
Warteschlange stehen und **wird nie gestartet**"*.

## Was der Satz angerichtet hat

Die drei Wörter **wird nie gestartet** standen nicht im Bild. Sie sind meine
Schlussfolgerung aus dem Wort *waiting* — und sie haben die gesamte Suche
festgelegt. Gesucht wurde, drei Tage lang, ein **Startproblem**:

| Verdacht | Ergebnis |
|---|---|
| `CanScheduleTask` blockiert | ausgeschlossen |
| `DelayTasks`/`StartTasks` werden nie gerufen | **falsch ausgeschlossen** — `QCTaskGroup` ruft beide |
| `MaxConcurrentTasks` erreicht | ausgeschlossen |
| `StartWorkerThread` mit `m_pThread == NULL` | widerlegt — der Zeiger war in jeder gemessenen Zeile gesetzt |

Am 14.09.2026 um 05:21:59 Uhr sagte die Spurmarke in einer Zeile, woran es
lag:

    E-83 liegengeblieben: uid=35 zustand=FERTIG(5) m_pThread=gesetzt aktiv=1/10 titel="Resyncing"

**Die Aufgabe wartete nicht. Sie war fertig.** 17 fertige Aufgaben hatten die
Nachbearbeitung nie angefordert und blieben deshalb als „laufend" gezählt;
15 andere hatten sie angefordert und verschwanden. Das Startthema hat es nie
gegeben.

## Die Widerlegung war die ganze Zeit billig zu haben

`Register()` setzt den Text **einmal** beim Eintragen
(`QCTaskManager.cpp:186`). Im ganzen Baum schreibt ihn niemand beim Start
um. Eine laufende, eine hängende und eine längst fertige Aufgabe sehen in
diesem Fenster **identisch** aus.

Das ist ein `grep`. Er kostet einen Werkzeugaufruf. Gemacht wurde er am
**13.09.2026** — zwei Tage nach der Eröffnung des Befunds, und auch dann
nicht, weil jemand die Anzeige misstraute, sondern nebenbei.

**Berichtigung einer eigenen Zahl:** Ich habe Gregor am 14.09.2026 um 05:28
Uhr gesagt, der Befund habe *„zwei Wochen in die falsche Richtung geführt"*.
Das stimmt nicht. Die erste Fundstelle im Verlauf ist der 11.09.2026,
11:00:52 Uhr, die Behebung der 14.09.2026, 05:21:59 Uhr — **drei Tage**, nicht
vierzehn. Eine übertriebene Zahl in einer Fehlereingestehung ist kein
harmloser Fehler: sie macht die Aussage unprüfbar
([[widerlegte-vermutungen-aufschreiben]]).

**Why:** Ein Oberflächentext fühlt sich wie eine Messung an, weil er aus dem
Programm kommt und nicht aus meinem Kopf. Er ist aber nur so aktuell wie die
Stelle, die ihn zuletzt geschrieben hat — und in einem 25 Jahre alten
Quelltext ist das oft genau eine Stelle, ganz am Anfang. Der Schaden entsteht
nicht beim Lesen, sondern beim **Formulieren des Befunds**: sobald *„wird nie
gestartet"* in der Überschrift steht, ist die Ursachenliste festgelegt, und
jede weitere Stunde arbeitet innerhalb dieser Grenze. Alle vier Verdächte
oben liegen im Startweg. Keiner lag dort, wo der Fehler war.

**How to apply:**

1. **Ein zitierter Oberflächentext wird zurückverfolgt, bevor er in eine
   Befundüberschrift kommt.** Zwei Fragen, beide durch `grep` zu beantworten:
   *wo wird er gesetzt* und *schreibt ihn jemand später um*. Ist die zweite
   Antwort nein, sagt er nichts über den **jetzigen** Zustand.
2. **Die Antwort steht im Befund**, in derselben Zeile wie das Zitat:
   *„stammt aus `Register()` (`QCTaskManager.cpp:186`), wird nie
   überschrieben"*. Das ist die Angabe, die
   `tools/pruefe-anzeigetext.pl` verlangt.
3. **Die Überschrift enthält nur, was im Bild steht.** *„Waiting"* stand da.
   *„wird nie gestartet"* nicht. Was gefolgert ist, gehört in die
   Ursachenliste, wo es widerlegt werden kann — nicht in die Überschrift, wo
   es zur Voraussetzung wird.
4. **Wenn eine Anzeige und ein Protokoll sich widersprechen, gewinnt das
   Protokoll** — und der Widerspruch ist selbst der Befund
   ([[ausreisser-ist-der-befund]]). Hier lautete er: die Anzeige kann gar
   nicht anders, sie wird nie aktualisiert.
5. **Eine Zahl in einem Fehlereingeständnis wird nachgerechnet wie jede
   andere.** „Zwei Wochen" statt drei Tagen klingt nach mehr Einsicht und ist
   weniger wert.

**Gegengetestet in beide Richtungen.** `--selbsttest` fährt 7 Fälle. Am
echten Stand: die E-83-Zeile aus `3256792` (11.09.2026) wird **abgewiesen**,
Rückgabe 1; die Zeile vom 14.09.2026, die `Register()` nennt, läuft
**durch**, Rückgabe 0.

**Zwei Fehlalarme wurden dabei gemessen und abgestellt** — beide standen im
Bestand und wären als Rauschen durchgegangen: E-64 ist ein **deutsches**
Gregor-Zitat, das über die Wörter *in* und *mailbox* als englischer
Oberflächentext galt; E-85 zitiert einen **Quelltextkommentar** mit
`TextReader::ReadIt`. Die Liste der englischen Erkennungswörter ist um die
deutsch-kollidierenden gekürzt, ein Zitat mit `::` gilt als Kommentar, und
ein Zitat über 120 Zeichen als Absatz. Beide Fälle stehen jetzt als
Gegenproben im Werkzeug, damit sie nicht zurückkommen. Im Gesamtbestand
bleiben **zwei** Treffer, beide echt (E-32, E-47).

**Und ein eigener Fehlgriff beim Bauen, der hierher gehört:** Der erste
Selbsttest war grün, während die Schranke am **echten** Eintrag stumm blieb.
Grund: mein erfundener Testfall schloss das Zitat typografisch, `BEFUNDE.md`
schliesst es mit einem geraden `"`. Ein Testfall, den ich selbst tippe, ist
leichter als die Wirklichkeit — deshalb wird jede Schranke zusätzlich gegen
den **echten Stand aus der Versionsgeschichte** gefahren
([[messung-muss-den-weg-treffen]], [[schranke-gegentesten]]).

Siehe [[erfolg-aus-anwendersicht]] — dieselbe Stelle von der anderen Seite:
dort geht es darum, wie der Befund für Gregor heissen muss, hier darum,
woraus seine Überschrift gebildet werden darf. Ausserdem
[[pruefen-statt-vermuten]] und [[eingebaute-messung-auslesen]].
