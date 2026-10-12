# LEKTOR-23 — E-94-Doku gegen die Messung (`dc5c498..a013f08`)

Lauf am 12.10.2026, nur lesend, aus dem Notizordner übernommen. **Alle drei Mängel sind im selben Commit wie dieser Bericht behoben.**


## Bestätigt (gemessen)
- In.mbx Fall 06: vorher 4 Zeilen (`bestel` / ` len und 1` / ` 5 Prozent sparen bis zum Wochenend` / ` e!`), nachher eine Zeile `Pruefung E-94: Toner bestellen und 15 Prozent sparen bis zum Wochenende!`.
- In.toc: vorher `Pruefung E-94: Toner bestel`, nachher `... bis zum Wo`.
- attach: je 7 Dateien, alle mit .pdf; eudora.log Version 7.2.0.83 / 7.2.0.84.
- tests84.txt: 188 Tests, 188 bestanden. Version.h 7.2.0.84, VERSION 1.0.84, Eudora.exe FileVersion 7.2.0.84 (14:03:59).
- offene-befunde.pl: 28/28, "deckt". doku-pruefen.pl: kein Widerspruch; nur Hinweise (PORTIERUNG.md, Testdaten/README.md, tools/WERKZEUGE.md, tools/ZWEIGE.md, tools/pruefdaten/LIESMICH.md nennen 7.2.0.84 nicht).
- Encode2047 nur noch als widerlegt (README.md:141). PAKETE.md 1.0.84 "in Arbeit": zulässig.

## Mängel
1. CHANGELOG.md:119 „**Noch nicht gebaut, nicht am Programm gemessen.**“ widerspricht der Überschrift CHANGELOG.md:71 „gebaut und gemessen“ und der Tabelle darunter. Vorschlag: Satz streichen oder als „(Stand vor dem Bau)“ kennzeichnen.
2. CHANGELOG.md, Tabelle 7.2.0.84, Zeile „Fälle 00–05“: „Fall 03 hat 216 statt 224 Zeichen“. Gemessen: vorher (E94-vorher) 217, nachher 216. Die 224 stammen nicht aus der Spalte 7.2.0.83 dieser Tabelle. Vorschlag: „216 (vorher 217; Pfad je um die Verzeichnislänge kürzer, mit Pfad 259)“.
3. ZIEL.md:17 „**Quellstand ist jetzt 7.2.0.83 / Paket 1.0.83**“, obwohl Version.h und WEITERMACHEN.md:9 7.2.0.84 nennen (später im selben Absatz „In Arbeit ist 7.2.0.84“). Vorschlag: „Veröffentlicht ist 7.2.0.83 / Paket 1.0.83; Quellstand 7.2.0.84 (E-94, in Arbeit)“.
