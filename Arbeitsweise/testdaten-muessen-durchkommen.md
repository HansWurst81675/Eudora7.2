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

## Nachtrag 13.10.2026: die Schranke lag im eigenen Testverzeichnis

Auf Gregors Auftrag *„e-83: selbst testen und ergebnis eintragen"* habe ich
`C:\Temp\E83-1084` als **Kopie von `C:\Temp\E94-nachher`** angelegt, dem
Verzeichnis eines früheren Messlaufs gegen denselben POP-Prüfserver.
Gelöscht habe ich `eudora.log`, `In.mbx`, `In.toc` und `attach\`. Stehen
blieb `spool\lmos.dat`: die Liste der Nachrichten, die Eudora vom Server
schon kennt (*Leave Mail On Server*).

| Zeit (UTC) | Lauf | Ergebnis |
|---|---|---|
| 06:42:12 | 1 | **0 Nachrichten** |
| 06:43:22 | `LMOS*` im Mailverzeichnis gelöscht — dort liegt die Datei nicht | — |
| 06:43:25 | 2 | **0 Nachrichten** |
| 06:44:28 | `spool\lmos.dat` gefunden und gelöscht | — |
| 06:44:31 | 3 | 7 Nachrichten, E-83 bestanden |

Die Testdaten waren richtig, der Server lieferte. Durchgekommen sind sie
trotzdem nicht: Eudora hat sie als „schon geholt" übersprungen. Das ist
die Lage dieser Lehre, nur liegt die Schranke diesmal nicht bei einem
fremden Server, sondern in einer Datei, die ich selbst mitkopiert habe.

**Why:** Ein Verzeichnis aus einem früheren Lauf trägt dessen Zustand mit.
Welche Dateien dazu gehören, stand nirgends; ich habe die gelöscht, die
mir einfielen. Am Vortag (12.10., 12:45) bin ich am selben Punkt
andersherum gestolpert: ich habe Gregor gesagt, seine Nachrichten seien
*„alle frisch vom Server geholt"*, obwohl er sie vom Backup zurückkopiert
hatte.

**How to apply, zusätzlich:**

- **Ein Testverzeichnis wird aus dem Paket und einer INI aufgebaut, nicht
  aus einem früheren Lauf kopiert.** Muss kopiert werden, gehört
  `spool\lmos.dat` ausdrücklich auf die Löschliste, neben `eudora.log`,
  `*.toc`, `attach\` und `OWNER.LOK`.
- **Null ist ein Messwert, kein Fehlschlag des Programms.** Kommt bei einem
  Abruf nichts an, ist die erste Frage: was hat der Server geantwortet
  (Protokoll des Prüfservers), und was hat Eudora davon verworfen. Am 13.10.
  stand die Antwort nach dem zweiten Lauf im Prüfserver-Protokoll.

**Offen:** `testlauf.ps1` könnte warnen, wenn im `-Verzeichnis` ein
`spool\lmos.dat` liegt und das Messskript Mail abruft. Nicht gebaut —
Werkzeuge sind nicht Sache des CHRONIST.

## Nachtrag 14.10.2026: am nächsten Morgen derselbe Weg, sechs Läufe

E-105 sollte an der Prüfnachricht `Testdaten/e105-handyfassung-versteckt.eml`
gemessen werden. Das Messverzeichnis entstand um 05:55 mit
`cp -r /c/Temp/E112-1085 /c/Temp/E105`, also **wieder als Kopie eines
früheren Laufs**, gegen die erste Regel des Nachtrags vom Vortag. Gelöscht
wurde `$D/lmos.dat` im Mailverzeichnis selbst. Dort liegt die Datei nicht;
die Zeile 06:43:22 der Tabelle oben sagt genau das.

| Zeit (UTC) | Lauf | Ergebnis | Ursache |
|---|---|---|---|
| 05:56 | 1 | Nachricht abgerufen, **eine alte geöffnet** | `In.mbx` aus `E112-1085` mitkopiert |
| 05:57:55 | 2 | 0 neue Nachrichten | `spool\lmos.dat` geblieben |
| 05:59:14 | 3 | 0 neue Nachrichten | dasselbe |
| 06:00:37 | 4 | 0 neue Nachrichten | dazu: der neue Prüfserver startete nicht (`Port 11110 … Address already in use`), der alte aus Lauf 1 hielt ihn |
| 06:02:05 | 5 | „Completed. No new messages." | `spool` enthielt `lmos.dat`, `lmos.dat.001`, `lmos.dat.002`: Eudora legt **Sicherungen** an |
| 06:03:3x | 6 | richtig | `spool/lmos.dat*` gelöscht |

Gregor schrieb währenddessen *„ja, du testest, ich halte mich zurück"* und
*„ok. du testest weiter, ich starte nichts."*, also acht Minuten Warten auf
einen Lauf, der nach der Lehre vom Vortag der erste hätte sein können.

**Why:** Der Nachtrag vom 13.10. endete mit *„Offen: `testlauf.ps1` könnte
warnen … Nicht gebaut."* Eine Lehre, die ich beim Anlegen des Verzeichnisses
lesen müsste, wird beim Anlegen nicht gelesen. Gelesen wird, was der Lauf
selbst ausgibt ([[lehren-anwenden-nicht-nur-schreiben]],
[[schranke-gehoert-in-den-haken]]).

**How to apply, zusätzlich:**

- **Zu löschen ist `spool\lmos.dat*` mit Stern**, nicht `lmos.dat`: Eudora
  hält Sicherungen `.001`, `.002`.
- **Vor einem neuen Prüfserver wird der alte beendet**, nach Pfad gefiltert
  (`perl.exe` auf Port 11110), so wie um 06:01:59 geschehen.
- **Null neue Nachrichten heißt: zuerst die Ausgabe von `testlauf.ps1` lesen.**

Schranke ab 14.10.2026: `tools/testlauf.ps1` nennt vor jedem Start
„ALTLASTEN vor dem Lauf: …" mit `spool\lmos.dat*`, der Größe von `In.mbx`
und dem Prozess, der Port 11110 hält. Das ist ein Hinweis und weist nicht ab,
weil ein Lauf ohne Abruf nichts davon braucht. Gegentest: `C:\Temp\E105-1087`
und `C:\Temp\E112-1085` melden alle drei.
