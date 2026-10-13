---
name: chronist-2026-10-13e
description: "CHRONIST-Lauf 13.10.2026 (fünfter): keine neue Lehre, sieben Nachträge (Messfenster hat gewirkt, Startliste machte Nachstellläufe wertlos, Paket aus Bin\Debug, „schlimmer“ ungemessen verneint, Übergabe nur im Chat, Abschaltmeldung ungeprüft, „für morgen“ war heute machbar); Werkzeuge stapel-lesen.ps1 gesichert, testlauf.ps1 zeigt die Startliste"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T15:00:00.000Z
---

Schranke: keine - dies ist der Bericht eines CHRONIST-Laufs, keine Lehre. Jede neue oder ergänzte Lehre trägt ihre eigene Schranke-Zeile.

# CHRONIST, Lauf vom 13.10.2026 (fünfter)

## Quelle

| Transkript | Zeitraum (UTC) | Nachrichten Gregor | davon Einwurf |
|---|---|---:|---:|
| `7cea137a-…jsonl` | 13.10.2026, 10:30–14:29 | 41 | 25 (60 %) |

Gezählt mit `perl tools/verlauf-messen.pl <transkript> 2026-10-13T10:30`. Werkzeugaufrufe 156, größter Block ohne neue Nachricht 23 (10:31, Paketbau 1.0.85). Wiederholungssignale: 2. Gelesen wurden Gregors Nachrichten und meine Texte vollständig, die Werkzeugergebnisse gezielt um 10:35–10:55 (Paket, E-115) und 13:40–14:11. Dazu kamen `BEFUNDE.md` E-115, E-119 und E-105, `tools/paket-bauen.ps1:40-54,419` und der Commit `0fc0cd57`.

## Nachträge

| Lehre | Kern |
|---|---|
| [fehlerbild-ist-ein-messfenster](fehlerbild-ist-ein-messfenster.md) | **Hat gewirkt.** Gregor ließ die Meldung von sich aus stehen. Nach 73 s war die Wurfstelle von E-115 gelesen, nach 3 min die Behebung eingesetzt. Drei Lücken: Das Lesewerkzeug lag nur im Scratchpad. `mfc140.dll`-Rahmen ohne Symbol wurden nicht gedruckt (`GetItemData` erst per `dumpbin` sicher). Das Ende des Messfensters wurde nicht gemeldet, Gregor fragte zweimal und wartete 7 min länger als nötig. Schranke-Zeile nennt jetzt das Werkzeug |
| [messung-muss-den-weg-treffen](messung-muss-den-weg-treffen.md), Fall 10 | Eudora schreibt `[Open Windows]` beim Beenden zurück. *Find Messages* auf der Startliste machte zwei von vier Nachstellläufen ungültig, einer davon sah genau wie der Erfolg der Behebung aus. Erkannt nur am Zeitpunkt `titel='Find Messages'` im Protokoll. Gegenprobe heute: Die Kopie trägt `OpenWindow3=39,1` schon wieder |
| [paket-gegen-den-bau-messen](paket-gegen-den-bau-messen.md) | Zweites Auftreten der Klasse. `-AusBauverzeichnis` nimmt standardmäßig `Bin\Debug` (7.2.0.12) und die Grundlage 1.0.2. `paket-pruefen.ps1` fing es. Seither läuft der Handweg, und im Werkzeug steckt die Falle weiter. Vorschlag: Versionsabgleich mit `Version.h` im Paketwerkzeug selbst |
| [erfolg-aus-anwendersicht](erfolg-aus-anwendersicht.md) | Auf *„es wird immer schlimmer!“* kam die Antwort *„nicht durch die Änderungen von heute entstanden“*. `BEFUNDE.md` sagt zur selben Zeit *„ob 1.0.84 dasselbe zeigt, ist nicht gemessen“*. „Ursache alt“ und „sieht schlechter aus“ sind getrennte Aussagen. Vermutung: E-112 macht nicht geladene Bilder zu großen grauen Kästen |
| [fertige-fassung-bereitstellen](fertige-fassung-bereitstellen.md) | 8 Standfragen in 4 Stunden. Die Übergaben waren vollständig, standen aber nur im Chat, und nach dem VM-Neustart fragte Gregor erneut. Sein Format von 14:21: Tabelle mit E-Nummer, Beschreibung, Testschritten. Gehört nach `PAKETE.md` und als `TESTEN.txt` ins Paket |
| [abschalten-ist-ein-termin](abschalten-ist-ein-termin.md) | Die Abschaltmeldung um 14:06 sagte, der Einstieg in `WEITERMACHEN.md` sei vollständig. Kein Befehl hatte das geprüft, und es fehlten E-117 bis E-120. Gregor fragte 70 s später. Der Dateizeitstempel hilft nicht, weil `offene-befunde.pl` die Datei laufend mitschreibt |
| [nie-stillstehen](nie-stillstehen.md) | *„du kannst es ja teilweise selbst überprüfen, nicht wahr?“* E-117 stand als Aufgabe für morgen da, mit Gregors Postfach als Prüffall. Mit Testnachricht und Bildserver auf `127.0.0.1` war es in 4,5 min gemessen. Listen für später bekommen die Spalte „braucht Gregor / geht ohne ihn“ |

## Werkzeug

Commit `be43ae3d`:

- **`tools/stapel-lesen.ps1`** (neu, aus dem Scratchpad der Sitzung): liest den Stapel eines laufenden Eudora mit offener Meldung. `-Pfadfilter` und `-Freigabe` sind jetzt Pflicht, weil es in Gregors Prozess eingreift. mfc-Worte ohne Symbol stehen jetzt als „ohne Symbol 0x…“ in der Ausgabe. Gegentest: ohne Prozess „0 Prozesse“, Rückgabe 1; zu kurze Freigabe abgewiesen; ScriptBlock-Parse fehlerfrei. **Nicht** an einem echten offenen Fenster geprüft, das geht erst beim nächsten Fall.
- **`tools/testlauf.ps1`**: gibt vor jedem Start, auch mit `-NurPruefen`, die Startliste `[Open Windows]` aus. Gegentest an `C:\Temp\E115-gregor`: `OpenWindow3=39,1` erscheint. Den leeren Fall habe ich nicht gefahren. Die Ausgabe ist ein Hinweis, keine Abweisung, denn welches Fenster stört, hängt am Befund.
- Beide in `tools/WERKZEUGE.md`.

## Vorschläge an die Hauptsitzung (nicht gebaut)

1. `paket-bauen.ps1`: nach dem Übernehmen die Dateiversion von `Eudora.exe` gegen `Version.h` prüfen und abbrechen. Vorgabe `-Bauart Release`, Grundlage das ZIP des letzten Tags. Gegenprobe: der Aufruf von 10:35.
2. `gesichert.pl`: die heute geänderten Kennungen in `BEFUNDE.md` gegen den Einstieg von `WEITERMACHEN.md` abgleichen. Gegenprobe: `508830d0`.
3. Paketübergabe als Tabelle in Gregors Format, auch als `TESTEN.txt` ins Paketverzeichnis. Das passt in `paket-bauen.ps1` oder in den Handweg.

## Verworfen

- **„Messfenster hat gewirkt“ als eigene Lehre:** Das ist ein Nachtrag zur bestehenden Lehre, zusammen mit ihren drei Lücken.
- **„Startliste“ als eigene Lehre:** Es ist Fall 10 derselben Klasse wie `messung-muss-den-weg-treffen`, also nicht neu. Neu ist das Werkzeug.
- **„schlimmer: neu oder nur sichtbar?“ als eigene Lehre:** Punkt 4/5 von `erfolg-aus-anwendersicht` verlangt schon die Zeile *schlechter geworden*. Neu ist nur, dass die Verneinung ungemessen war. Deshalb ein Nachtrag.
- **„Löschen abgelehnt, umbenannt“:** keine Lehre. Das Umbenennen mit sprechendem Namen und die Bitte an Gregor waren richtig ([[auftrag-darf-nicht-loeschen]]).
- **Backslash-Falle im Paketwerkzeug (10:33, `'\'` statt `'\'`):** Sie ist im selben Zug behoben (`5badd6a2`), und die Lehre [text-nicht-durch-schichten-schicken](text-nicht-durch-schichten-schicken.md) deckt sie ab.
