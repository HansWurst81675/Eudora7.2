# LEKTOR-19 — Gregors IMAP-Test im CHANGELOG 7.2.0.83 (`76ec870`)

Lauf am 12.10.2026, nur lesend, aus dem Notizordner übernommen. **Alle drei Mängel und der Hinweis sind im selben Commit wie dieser Bericht eingearbeitet.**


Nur gelesen: `eudora.log` und `Imap\dominant\Inbox\attach\` in `C:\Users\Gregor\Eudora72-1.0.83-release\Mailverzeichnis`.

## Stimmt

- Namen und Längen aus dem Log: .docx (42) in Z. 1052/1056, .pdf (41) in Z. 1057/1061, der lange Name (229) in Z. 971, geschrieben mit (175) und `.zip` in Z. 976.
- Voller Pfad: 83 Zeichen Verzeichnispräfix + 175 = 258.
- Inhalt: .docx beginnt mit `PK`, .pdf mit `%PDF-1.4`, die .zip-Dateien mit `PK` und je 351 502 Byte.
- Zwei PDFs (Flyer_Da_Watschnbaum.pdf 08:45:16, Nilkreuzfahrt_2027_Vergleich-1.pdf 08:44:58), je 1 204 Byte, beginnen mit `5c e1 e2 05`, also nicht mit `%PDF`.
- LogLevel 91295 stimmt.

## Mängel

1. **CHANGELOG.md:92** „laut Log 7.2.0.77/78“: Das Log kennt keine 7.2.0.78. Die Sitzungen um 08:44:13 (Z. 416/417) und 09:03:19 (Z. 750/751) laufen beide mit **7.2.0.77**. Vorschlag: „laut Log 7.2.0.77“.
2. **CHANGELOG.md:80** „drei Sitzungen ab 12:25“: Das Log hat **vier** Sitzungen mit 7.2.0.83, um 12:25:52, 12:26:28, 12:42:11 und 12:45:07 (Z. 765/779/1017/1084). Vorschlag: „vier Sitzungen ab 12:25“, oder sagen, welche davon gezählt werden.
3. **CHANGELOG.md:91** `\?\` ist falsch. Das Präfix für Langpfade heißt `\\?\`. Vorschlag: `` `\\?\` ``.
4. Hinweis, kein Fehler im Text: Unter dem 175-Zeichen-Namen aus Log Z. 976 liegt **keine** Datei. Im Verzeichnis liegen zwei Kopien mit je 351 502 Byte, beide 12:32:34, mit anderen Namen: `…_D_Wartung_…41813.07_dat.zip` und `…_databas - Kopie.zip`. Vermutlich hat Gregor sie umbenannt oder kopiert. Die Zeile „Inhalt `PK`, 351 502 Byte“ stimmt für beide. Vorschlag: einen Satz ergänzen, dass die Datei inzwischen anders heißt.
