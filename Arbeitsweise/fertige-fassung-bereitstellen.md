---
name: fertige-fassung-bereitstellen
description: "Ist eine neue Fassung fertig, erst eigene Tests, dann als Verzeichnis neben Gregors letztem Release-Verzeichnis bereitstellen"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T15:00:00.000Z
---

Gregor am 12.10.2026: *„wenn eine neue version fertig ist, mach lasse die eigenen tests und wenn alles ok ist, stell mir diese bereit"* — und auf die Frage nach dem Ort: *„ja, hier C:\Users\Gregor\Eudora72-1.0.76-release parallel dazu"*.

**Why:** Er will nicht nach jeder Fassung fragen müssen, ob sie getestet ist und wo sie liegt; er testet selbst erst, wenn meine Prüfung grün ist.

**How to apply:**
- Nach dem Bau: Testsuite (EudoraTests), Messlauf am laufenden Programm über `tools/testlauf.ps1` mit `-MessenSkript`, `paket-pruefen.ps1` — erst wenn alles grün ist, bereitstellen.
- Ort: ein **neues** Verzeichnis `C:\Users\Gregor\Eudora72-<Paketnummer>-release` **neben** dem vorhandenen; das vorhandene (z. B. `Eudora72-1.0.76-release`) wird nicht angefasst. Sein `Mailverzeichnis` dort enthält seine alten Mails und die ini — nur lesen.
- Das ist eine Erlaubnis für genau dieses Bereitstellen, nicht für andere Schreibzugriffe in seinen `Eudora72-*`-Verzeichnissen ([[erlaubnis-nicht-hineinlesen]], [[nichts-auf-gregors-bildschirm-starten]]).
- Kein Release ohne seinen Test ([[release-erst-nach-gregors-test]]).

Schranke: tools/paket-pruefen.ps1 (nach jedem Bereitstellen, gegen das Zielverzeichnis) - ob eine Fassung "fertig" ist, laesst sich nicht mechanisch pruefen; geprueft wird, dass das Bereitgestellte vollstaendig ist und zum Bau passt

## Nachtrag 12.10.2026: wer eine Bedingung nachschiebt, kündigt sie zuerst an

**Gregor um 11:55:36:**

> *„ich sehe noch keine 0.82 version"*

**Die Folge der Meldungen:**

| Zeit | Was ich schrieb |
|---|---|
| 11:46:18 | *„Erst wenn alles davon grün ist, lege ich die Fassung als `…-1.0.82-release` neben deine 1.0.76."* Genannt waren vier Bedingungen (Fehlerdatei, Testsuite, Abruf, `paket-pruefen.ps1`). Der PRÜFER gehörte **nicht** dazu |
| 11:49:15 | PRÜFER gestartet, mit der Frage nach toten Überläufen |
| 11:51:26 | Überschrift: **„7.2.0.82 ist bei mir grün"**, darunter die drei Haken. Erst im **letzten Absatz** steht: *„Bereitgestellt wird die Fassung trotzdem erst nach beiden Rückläufen."* |
| 11:55:36 | Gregor fragt nach der 0.82 |
| 11:55:55 | Erklärung und Wahl zwischen „warten" und „Vorabfassung" |

Die Zurückhaltung war richtig. PRÜFER-20 fand eine Minute später den
Stapelüberlauf in `uudecode.cpp`, und ohne sie wäre 1.0.82 mit diesem
Überlauf bei Gregor gelandet. Falsch war die Reihenfolge. Um 11:46 hatte ich
Gregor eine Regel genannt: vier Bedingungen, dann liegt die Fassung da. Um
11:51 meldete ich alle vier als erfüllt, und zwar in der Überschrift. Die
fünfte Bedingung, die ich inzwischen dazugenommen hatte, stand ganz unten.
Gregor hat die Überschrift gelesen und die Fassung gesucht. Das ist genau
seine Regel von 11:10 (*„wenn alles ok ist, stell mir diese bereit"*).

### Why

Eine angekündigte Bedingungsliste ist eine Zusage. Wer sie erweitert,
ändert die Zusage. Das gehört an den Anfang der nächsten Meldung, nicht ans
Ende. Dieselbe Klasse wie in [[erfolg-aus-anwendersicht]]
(„der Satz stand schon da, nur nicht vorne"): Was Gregor tun kann
oder **nicht** tun kann, steht in der ersten Zeile.

### How to apply

- **Kommt nach einer Ankündigung eine Bedingung hinzu, beginnt die nächste
  Meldung damit:** *„1.0.82 lege ich noch nicht hin: Ich warte auf den
  PRÜFER (etwa 10 Min.), weil …"* Danach kommt, was grün ist.
- **„Bei mir grün" steht nie allein als Überschrift, solange etwas
  zurückgehalten wird.** Die Überschrift nennt den Zustand aus Gregors
  Sicht: *liegt da* oder *liegt noch nicht da, weil*.
- Der PRÜFER gehört von Anfang an in die Liste der Bedingungen, wenn die
  Fassung eine Behebung enthält, die neuen Code erreichbar macht
  ([[nie-benutzt-ist-nicht-geprueft]], Nachtrag 12.10.2026).

## Nachtrag 13.10.2026: die Übergabe steht nur im Chat, also fragt Gregor nach

Zwischen 10:30 und 14:30 UTC fragte Gregor achtmal nach dem Stand eines Pakets oder Zweigs:

| Zeit (UTC) | Gregor |
|---|---|
| 10:31:34 | *„welche bugs sind im 0.85 behoben?"* (Einwurf, Antwort 10:40) |
| 11:12:45 | *„soll ich noch was mergen?"* |
| 13:15:09 | *„was ist jetzt in der 0.86 zum testen?"* (nach dem Neustart der VM) |
| 13:43:30 | *„was ist jetzt bei dem 0.86 alles behoben?"* |
| 13:43:51 | *„was kann ich noch darin testen?"* |
| 14:05:50 | *„stand? welcher branch? was ist zum mergen? was ist nicht dokumentiert und nicht commited?"* |
| 14:07:33 | *„steht für morgen, was als näcshtes ansteht?"* |
| 14:21:29 | *„und was darin zu testen ist: eine tabelle mit E-xxx fehlernummer + beschreibung und test schritte"* |

Die Übergaben selbst waren vollständig. 1.0.86 um 11:01 nannte E-115, wie es geprüft wurde und den Testschritt. Gregor fuhr aber um 11:12 die VM herunter und kam um 13:15 wieder. Die Übergabe stand nur im Chat, und den hatte er nicht mehr vor sich. In `Releases/PAKETE.md` steht zu 1.0.86 *Inhalt* und *Gemessen*, aber kein Testschritt. Im Paketverzeichnis selbst steht gar nichts dazu.

Mit der letzten Frage hat Gregor das Format selbst festgelegt: **Tabelle, je Zeile Fehlernummer, Beschreibung, Testschritte.**

**How to apply (Ergänzung):**

- **Jede Paketübergabe ist eine Tabelle in Gregors Format:** `E-xxx | was war falsch (in seinen Worten) | Testschritte | Stand` (gemessen / von Gregor bestätigt / nicht gemessen). Darunter *Bekannt offen* und, nach dem Nachtrag in [[erfolg-aus-anwendersicht]], *schlechter oder sichtbarer geworden*.
- **Die Tabelle steht in einer Datei, nicht nur im Chat:** im Abschnitt des Pakets in `Releases/PAKETE.md`, und als `TESTEN.txt` im Paketverzeichnis neben `Eudora.exe`. Dort findet Gregor sie nach dem Neustart der VM ([[wissen-gehoert-in-dateien]]). Im Chat steht danach nur der Verweis und die erste Zeile.
- Eine Frage nach dem Stand, die Gregor zum zweiten Mal stellt, ist ein Wiederholungssignal ([[einwurf-ist-ein-messwert]]). Die Antwort darauf ist, die Datei nachzuziehen, nicht die Antwort im Chat zu wiederholen.
