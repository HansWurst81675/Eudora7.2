---
name: testdaten-muessen-durchkommen
description: "Ein Testdatum muss nicht nur den Fehler treffen, sondern jede Schranke auf dem Weg zur Messstelle ueberleben - 550 Spam message rejected"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-14T06:28:14.790Z
---

Schranke: keine - ob ein fremder Server eine Nachricht annimmt, laesst sich hier nicht ausrechnen; die einzige ehrliche Messung ist das Absenden, und genau der Schritt ist der, der fehlschlaegt

# Ein Testdatum muss den Prüfweg überleben, nicht nur den Fehler treffen

**Gregor am 13.09.2026, 20:32:16 Uhr**, mit einem Bildschirmfoto der
Statuszeile:

> *„was heißt die message im status unten?"*

Darin stand:

    and then the SMTP server (mx.freenet.de) said: 550 Spam message rejected

`550` ist eine endgültige Ablehnung. Die Testmail war nicht draussen und
wurde auch nicht erneut versucht. Nicht Eudora hat das entschieden, sondern
der Server — und zwar zu Recht: ich hatte sie so gebaut, dass sie **technisch
den Fehler trifft**, und dabei genau das erzeugt, wonach ein Spamfilter
sucht:

| im Entwurf | wozu | wie es aussieht |
|---|---|---|
| 900 fast gleiche Zeilen | Blockgrenze bei 8192 Byte überschreiten | Wiederholungsmuster |
| `Preis: 12,50 € — günstig` | Umlaut, Währungszeichen, Gedankenstrich | Werbung |
| Emoji | Vierbytezeichen an der Stückgrenze | Werbung |

## Das Ärgerliche: ich hatte an eine Schranke gedacht, und daraufhin an keine mehr

Eine Stunde vorher, um 19:28 Uhr, habe ich den Betreff nach RFC 5322
gefaltet, mit dieser Begründung im Commit `5971ed8`:

> *„Der Betreff war 155 Zeichen in einer Zeile — doppelt so lang wie
> empfohlen. Ein Server, der ihn selbst umbricht, hätte einen Fehler erzeugt,
> der wie E-85 aussieht."*

Das ist genau die richtige Überlegung — **für eine** Station des Weges. Und
danach galt der Weg als geprüft. Ein Spamfilter, ein Grössenlimit, eine
Umkodierung durch den Server: nichts davon ist noch einmal gefragt worden.
Eine Schranke gefunden zu haben fühlt sich an wie „die Schranken bedacht".

## Die zweite Hälfte: die Form der Lieferung

**Gregor, 20:27:57 Uhr:**

> *„ich habe irgendwelche dateien im verzeichnis gefunden, ich habe klar
> gesagt: ich möchte eine mail im postfach haben, die ich nur abschicken
> kann. oder wie soll ich .eml senden?"*

Er hatte die Form ausdrücklich genannt. Geliefert habe ich `.eml`-Dateien in
einem Verzeichnis — die Form, die für **mich** am einfachsten zu erzeugen
war. Eudora kann eine `.eml` nicht als Nachricht verschicken, nur als Anhang;
genau so ging sie dann hinaus und wurde abgelehnt.

Der Weg, den er meinte, existiert und war am nächsten Morgen in vier Minuten
gefunden: eine Nachricht in ein **lokales** Postfach legen und per
*Transfer* in die IMAP-Inbox ziehen. Eudora lädt sie dann mit dem
IMAP-Befehl `APPEND` hoch (`CTocDoc::ImapCopyMsgFromLocalToImap` →
`AppendMessageFromLocal`) — **kein SMTP, kein Spamfilter**, und die Nachricht
kommt beim nächsten Abgleich durch genau den Übersetzungsweg zurück, um den
es ging. Diese Frage hätte **vor** dem Bauen gestellt werden müssen, nicht
nach der Ablehnung.

## Und die teuerste Zeile: das Testdatum war überflüssig

Gregors eigene weitergeleitete Mail — *„das ist auf jeden fall eine frische
mail, ist aber falsch dargestellt!"* — hat den Fehler bewiesen, und zwar
besser als jede konstruierte: sie kam aus dem echten Betrieb, war frisch
abgerufen, und ihre Kombination aus richtigem Betreff und falschem Rumpf
führte in einer Minute zur Ursache ([[unterschied-im-selben-bild]]). Während
ich eine Testmail baute, faltete, verschickte und von einem Spamfilter
zurückbekam, lag der Beweis bereits im Gespräch.

**Why:** Ein Testdatum wird gegen **eine** Anforderung entworfen — den Fehler
auslösen — und muss **zwei** erfüllen: den Fehler auslösen **und** unversehrt
bis zur Messstelle kommen. Die zweite Anforderung ist unsichtbar, weil sie
aus lauter Stationen besteht, die im Normalbetrieb nichts tun: Spamfilter,
Grössenlimit, Zeilenfaltung, Umkodierung, Virenprüfung, die Frage, in welcher
**Form** der Prüfer das Datum überhaupt benutzen kann. Und je schärfer das
Datum auf den Fehler zielt, desto auffälliger wird es für genau diese
Stationen: 900 gleiche Zeilen sind eine gute Probe **und** ein gutes
Spammerkmal. Die beiden Anforderungen ziehen gegeneinander.

**How to apply:**

1. **Vor dem Bauen wird der Weg aufgeschrieben, Station für Station**, von
   mir bis zur Messstelle. Für eine Mail: Verfassen → SMTP-Server →
   Empfangsserver → Spamfilter → IMAP-Ablage → Abruf → Anzeige. Zu jeder
   Station ein Wort: *unkritisch*, *geprüft*, oder **?**. Ein `?` ist ein
   offener Punkt, kein Hintergrund.
2. **Der Weg mit den wenigsten fremden Schranken gewinnt.** Gibt es einen,
   der ganz ohne fremde Entscheidung auskommt — `APPEND` statt SMTP,
   `tools/imap-pruefserver.pl` statt eines echten Servers, eine lokale
   Mailboxdatei statt eines Versands — dann ist das der Weg, auch wenn er
   umständlicher ist. Was ich nicht kontrolliere, kann ich nicht messen.
3. **Die Form der Lieferung hat Gregor gesagt; sie wird nicht ersetzt.**
   *„eine mail im postfach, die ich nur abschicken kann"* ist eine
   Anforderung, keine Beschreibung. Ein Artefakt in einer Form, die der
   Prüfer nicht benutzen kann, ist nicht geliefert
   ([[erfolg-aus-anwendersicht]]).
4. **Zuerst wird gefragt, ob es das Testdatum überhaupt braucht.** Liegt
   schon ein echter Fall vor — in Gregors Postfach, in einem Protokoll, in
   einem Bildschirmfoto —, ist er dem konstruierten überlegen: er hat den
   Prüfweg bereits überlebt, bewiesenermassen.
5. **Wenn es doch eines braucht: unauffällig statt massenhaft.** Die
   kritischen Zeichen gezielt platzieren, nicht in Menge. Ein Umlaut an der
   Blockgrenze reicht; neunhundert Zeilen davor braucht niemand.

**Warum es hier keine Schranke gibt:** Ob `mx.freenet.de` eine Nachricht
annimmt, entscheidet ein fremdes System nach Regeln, die es nicht
veröffentlicht. Es gibt keine lokale Rechnung, die das vorwegnimmt — die
einzige ehrliche Messung ist das Absenden, und genau dieser Schritt ist der,
der fehlschlägt. Was bleibt, ist Punkt 2: den Weg wählen, auf dem niemand
fremdes entscheidet. Das ist keine Schranke, sondern eine
Entwurfsentscheidung, und sie steht deshalb als erste in der Liste oben.

Siehe [[pruefstand-kann-blind-sein]] — dort war das Messgerät kaputt, hier
kommt die Probe nicht bis zum Messgerät. Ausserdem
[[messung-muss-den-weg-treffen]] und [[lauffaehiges-ergebnis-liefern]].
