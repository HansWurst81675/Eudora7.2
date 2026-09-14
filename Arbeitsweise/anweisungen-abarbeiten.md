---
name: anweisungen-abarbeiten
description: "Gregors Nachrichten sind Arbeitsaufträge — Material sofort auswerten, Absprachen festhalten, nichts Neues erfinden"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:56:30.619Z
---

Schranke: keine - ob ich Gregors Nachricht ausgewertet habe, steht nur im Chatverlauf; im Repo ist eine abgearbeitete Anweisung von einer überlesenen nicht zu unterscheiden

Jede Nachricht von Gregor ist ein Auftrag, kein Gesprächsbeitrag. Vier Punkte, an
denen ich in diesem Projekt wiederholt danebenlag:

**1. Geliefertes Material wird ausgewertet, nicht nur entgegengenommen.**
Am 28.08.2026 habe ich `HermSSL.zip` um 12:34 heruntergeladen — und nie
hineingeschaut. Sechs Stunden später spekulierte ich darüber, warum die neue
QCSSL.dll keine Verbesserung bringt. Die Antwort lag im Archiv: OpenSSL 1.0.2p,
also längst TLS 1.2. Gregor: „du hast meine infos ignoriert. denn ich habe dir ja
den link zu hermesSSL.zip geschickt. was steckt drin? genau!" Herunterladen ist
nicht auswerten. Der Inhalt gehört in dieselbe Antwort wie der Download.

**2. Eine zweimal gestellte Frage heisst: ich habe sie nicht beantwortet.**
„für openSSL gibt es ja separate DLLs, soweit ich weiß?" (12:28) und „warum nimmst
du nicht schon vorhandene DLLs für OpenSSL?" (12:59) — dieselbe Frage, dreissig
Minuten auseinander. Dazwischen habe ich weiter aus dem Quelltext gebaut. Ebenso
dreimal die Frage nach dem verschwundenen Review-Agenten (29.08.), zweimal die
Frage nach der README. **Wiederholung ist ein Alarmzeichen**: die Antwort zurück-
nehmen, die Sache tatsächlich prüfen und die Entscheidung begründen — oder sie
ändern.

**3. Absprachen gehören in eine Datei, nicht in mein Gedächtnis.**
„muß ich dich an alles erinnern? kannst du dir nicht die paar aufgaben einfach
merken? aufschreiben?" — „was? wieso? war ja nicht so ausgemacht!" — „habe ich
gesagt, les' nach!". Alles, was vereinbart, zurückgestellt oder zugesagt wurde,
kommt in eine gepflegte Liste im Repo (README „Offene Themen", `BEFUNDE.md`,
[[zurueckgestellte-befunde]]), bevor ich weiterarbeite. Nach einer
Kontextzusammenfassung ist mein Gedächtnis nachweislich unzuverlässig; die Datei
ist es nicht. Siehe [[wissen-gehoert-in-dateien]].

**4. Nichts Neues erfinden.** Am 29.08.2026 prüfte Gregor eine Zusammenfassung
gegen das Besprochene mit den Worten: „ich wollte sicher gehen, daß du nicht
wieder was neues erfindest." Wenn ein Plan steht, wird er abgearbeitet. Eine
Abweichung ist zulässig, aber sie muss angesagt und begründet werden, bevor sie
passiert — nicht danach erklärt.

**How to apply:** Beim Lesen einer Nachricht von Gregor zuerst prüfen: enthält sie
(a) angehängtes Material — dann sofort öffnen; (b) eine Wiederholung — dann meine
letzte Antwort verwerfen; (c) eine Festlegung — dann in eine Datei; (d) eine
Anweisung — dann ausführen, nicht bestätigen. Nachrichten, die eintrafen, während
ich beschäftigt war, gehen sonst unter: am 28.08.2026 sind zwei aus der
Warteschlange komplett verlorengegangen.

---

## Nachtrag 14.09.2026 — Punkt 5: ein Bild ist Material, und ein zitierter Befund ist eine Anweisung

Punkt 1 oben sagt, geliefertes Material werde ausgewertet und nicht nur
entgegengenommen. Der Anlass war damals ein ZIP-Archiv. **Ein Bildschirmfoto
ist dasselbe Material**, und es ist im Alltag das haeufigere.

Gemessen an E-85, 13.09.2026: die entscheidende Kombination — Betreff richtig,
Rumpf falsch — stand ab **11:01:42** in Gregors Bild. Ausgewertet wurde sie um
**20:29:19**. Dazwischen: **9 Stunden 27 Minuten, 318 Werkzeugaufrufe**,
zweimal „behoben" gemeldet und ein Paket ausgeliefert, das den Fehler nicht
behob. Die Auswertung selbst brauchte danach **null** Werkzeugaufrufe. Die
ganze Rechnung steht in [[unterschied-im-selben-bild]]; hier zaehlt nur, dass
sie unter Punkt 1 gehoert: das Material lag vor, es wurde nicht ausgewertet.

**Dazu ein sechster Fall, der in dieser Liste noch fehlte: Gregor zitiert
etwas aus dem eigenen Repo.** Am 14.09.2026 um 07:50 Uhr schickte er zwei
Zeilen aus `BEFUNDE.md` und fragte *„dsa hat jemand auf dem schirm?"*. Das ist
keine Sachfrage — es ist ein Hinweis darauf, dass die Antwort schon im Haus
liegt ([[bestand-vor-neuer-suche]]).

**Und beide entscheidenden Nachrichten dieses Tages kamen als Einwurf**,
mitten in einen laufenden Zug: die zitierten Befunde und
*„du hast deine tools immer noch nciht im griff, was?"* (12:16:15). Das ist
die Form, in der 54 Prozent seiner Nachrichten eintreffen
([[einwurf-ist-ein-messwert]]) — also nicht die Ausnahme, sondern der
Regelfall, fuer den die Auswertung eingerichtet sein muss.

**Zu Punkt 1 ergaenzt, als Handgriff:**

* **Ein Bild wird gelesen, bevor der naechste Werkzeugaufruf laeuft** — einmal
  auf das, was falsch ist, und einmal auf das, was daneben richtig ist.
* **Zitiert Gregor eine Kennung (`NP3-8`, `E-87`, `V-1`), wird zuerst die
  Stelle im Repo geoeffnet**, nicht die Sache neu untersucht.
* **Ein Einwurf unterbricht den laufenden Zug nicht, aber er wird vor dem
  naechsten Werkzeugaufruf gelesen und beantwortet.** Was waehrend einer
  langen Arbeit eintrifft, geht sonst unter — das steht seit dem 28.08.2026
  in Punkt 4 und ist am 13.09.2026 wieder passiert.
