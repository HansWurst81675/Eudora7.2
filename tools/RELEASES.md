# Veroeffentlichte Releases

Jede Zeile ist ein Release, das ich veroeffentlicht habe, mit der Freigabe,
auf die es sich stuetzt. Angelegt und gefuellt von
`tools/release-veroeffentlichen.ps1` - siehe dort, warum.


> **Nachgetragen am 11.09.2026.** Bis dahin stand hier nur `v1.0.29` - das
> einzige Release, das ueber `release-veroeffentlichen.ps1` lief. Alle
> anderen sind mit `gh release create` von Hand entstanden und deshalb nie
> eingetragen worden. Wo die Freigabe nicht belegbar war, steht *nicht
> dokumentiert*; erfunden wurde keine.

| Zeit | Fassung | Freigabe | Ergebnis |
|---|---|---|---|
| 2026-09-11 13:00:17 | v1.0.48 | Gregor am 11.09.2026 zu 1.0.48: IMAP mit der verschaerften Zertifikatspruefung getestet, 'Successfully retrieved konto-gmx@gregor.invalid' ueber Port 993 | veroeffentlicht |
| 2026-09-11 08:52:00 | v1.0.47 | Gregor am 11.09.2026 zu 1.0.46: 'ja, jetzt geht es' ([E-80](../Intern/BEFUNDE.md#e-80)) und zu 1.0.47: 'ja, passt!' ([E-81](../Intern/BEFUNDE.md#e-81)) | veroeffentlicht; Release Notes am selben Tag berichtigt (134 statt 175 Nachrichten, zehn statt acht Kopfzeilen) |
| 2026-09-10 13:00:20 | v1.0.43 | Gregor am 10.09.2026 zu 1.0.42/1.0.43: '1. filter fenstergroesse nach neustart gespeichert: PASS' und '2. filter funktionieren.' | veroeffentlicht |
| 2026-09-09 09:10:15 | v1.0.27 | nicht dokumentiert | veroeffentlicht |
| 2026-09-06 13:11:23 | v1.0.15 | nicht dokumentiert | veroeffentlicht; Messfassung mit Spurmarken |
| 2026-09-06 12:12:10 | v1.0.14 | nicht dokumentiert | veroeffentlicht |
| 2026-09-05 20:20:58 | v1.0.10 | nicht dokumentiert | veroeffentlicht |
| 2026-08-31 06:29:35 | v1.0.3 | nicht dokumentiert | veroeffentlicht; Befund [V-1](../Intern/BEFUNDE.md#v-1) - zwei verschiedene ZIPs unter derselben Nummer |
| 2026-08-30 16:21:16 | v1.0.2 | nicht dokumentiert | veroeffentlicht |
| 2026-08-30 15:08:07 | v1.0.1 | nicht dokumentiert | veroeffentlicht |
| 2026-09-09 13:25:20 | v1.0.29 | Gregor am 09.09.2026 zu Paket 1.0.29: '1-6, ok.' und 'bau mir mit dem bug ein 0.29 release auf github. den fehler notieren wir, wird im naechsten release behoben.' | veroeffentlicht |
| 2026-09-13 13:24:37 | v1.0.50 | Gregor am 13.09.2026: 'gemerged, jetzt 0.50 releasen' - [E-76](../Intern/BEFUNDE.md#e-76) und [E-84](../Intern/BEFUNDE.md#e-84) hatte er zuvor am laufenden Programm bestaetigt | veroeffentlicht |
| 2026-09-17 20:07:49 | v1.0.72 | Gregor am 17.09.2026 zu 1.0.72: „kein crash" — belegt durch sein Protokoll: der E-106-Block läuft 18 mal und über die bisher tödliche Stelle hinaus (`pos=770` hinter `pos=765`), letzte Zeile `Logging shutdown`, keine `Exception.log`. Marke auf dem Merge-Commit `8da72c8`. Enthält **[E-101](../Intern/BEFUNDE.md#e-101)**, **[E-103](../Intern/BEFUNDE.md#e-103)**, **[E-104](../Intern/BEFUNDE.md#e-104)**, **[E-106](../Intern/BEFUNDE.md#e-106)** und **[E-108](../Intern/BEFUNDE.md#e-108)**. Offen bleibt **[E-98](../Intern/BEFUNDE.md#e-98)** |
| 2026-09-17 10:23:08 | v1.0.64 | Gregor am 17.09.2026 zu 1.0.64: 'gespeichert. funktioniert.' ([E-97](../Intern/BEFUNDE.md#e-97)) und 'ja, kein datenverlust!' ([E-99](../Intern/BEFUNDE.md#e-99)) | veroeffentlicht, auf GitHub als *Latest* markiert; Tag `1d37623` |
| 2026-10-12 11:18:20 | v1.0.83 | Gregor am 12.10.2026 nach seinem IMAP-Test mit 1.0.83: 'gekuerzt mit endung reicht, mach PR fuer an1-endungen'; nach dem Merge von PR #84: 'erstelle ein release auf github' | veroeffentlicht |
| 2026-10-12 12:59:15 | v1.0.84 | Gregor am 12.10.2026 nach seinem IMAP-Test mit 1.0.84 (Bildschirmfoto: Toner-Betreff in einem Stueck), PR #86 gemergt: 'dann ein github release' und 'ja, beides jetzt' | veroeffentlicht |
| 2026-10-14 05:46:20 | v1.0.87 | Gregor am 14.10.2026: 'ja, wir releasen ein 0.87 in github' (nach seinem Test von 1.0.87, alle Behebungen bestaetigt) | veroeffentlicht |
| 2026-10-17 21:12:09 | v1.0.101 | Gregor am 17.10.2026: 'ja, veröffentlichen' (nach seinem Test von 1.0.101 in vier Runden und dem Merge von PR #99) | veroeffentlicht |
| 2026-10-20 13:55:11 | v1.0.112 | Gregor am 20.10.2026: 'wie auch immer: release eine neue version, alles in release notes und changelog, auch der neue befund' und 'ja, mach das!' | veroeffentlicht 11:55:10 UTC; Marke auf `f87a4a74` (PR #113). **Nicht mehr *Latest*** - am selben Tag von `v1.0.113` abgeloest |
| 2026-10-20 15:01:37 | v1.0.113 | Gregor am 20.10.2026: 'jetzt schon releasen, wie soll er ja an die gefixte version kommen?' | veroeffentlicht 13:01:36 UTC, auf GitHub als *Latest*; Marke auf `ac094f15` (PR #117), ZIP `Eudora72-1.0.113-release.zip`, 9 378 205 Byte, SHA-256 `0d1d4bf4...f4772`. **Am 20.10.2026 vom LEKTOR in die Tabelle geholt** - das Skript haengt die Zeile ans Dateiende, also hinter den Zitatblock, und sie stand dort als rohe Strichzeile ([L-43.8](../Befunde/LEKTOR-43.md#l-43.8), [L-43.12](../Befunde/LEKTOR-43.md#l-43.12)) |
| 2026-10-21 09:56:57 | v1.0.117 | Gregor am 21.10.2026: "ja, release 1.0.117 auf github". Begruendung, warum er diese Fassung nicht eigens testet: "wenn es identisch zu 0.116 ist, muss ich ja nichts testen, das hast du bereits gemacht" - 1.0.116 hat er bestaetigt ("2x nacheinander starten verhaelt sich jetzt korrekt"), und 1.0.117 unterscheidet sich davon nur durch zwei Behebungen, die danach rot und gruen am laufenden Programm gemessen wurden. PRUEFER-42: "JA - v1.0.117 geht so raus" (acht Funde, keiner haelt auf). [LEKTOR-46](../Befunde/LEKTOR-46.md#lektor-46): "JA" (sieben Funde in den Papieren, alle berichtigt). | veroeffentlicht |
| 2026-10-21 21:07:37 | v1.0.120 | Gregor am 21.10.2026: 'ich habe ja schon alles getestet.' | veroeffentlicht 19:07:37 UTC, auf GitHub als *Latest*; Marke auf `30feeae2`, ZIP `Eudora72-1.0.120-release.zip`, 9 381 870 Byte, SHA-256 `26fde414...a6a1`. Es traegt 7.2.0.118, 7.2.0.119 und 7.2.0.120. **Am 21.10.2026 vom LEKTOR in die Tabelle geholt** - das Skript haengt die Zeile ans Dateiende, also hinter den Zitatblock; dort stand sie als kopflose Einzelzeile und wurde gar nicht als Tabelle dargestellt. Derselbe Fall wie bei `v1.0.113` ([L-43.8](../Befunde/LEKTOR-43.md#l-43.8), [L-43.12](../Befunde/LEKTOR-43.md#l-43.12)) - die Ursache im Skript ist nach wie vor nicht behoben. |

> **Nachgetragen am 17.09.2026 vom LEKTOR ([L-13.1](../Befunde/LEKTOR-13.md#l-13.1)).** Die Zeile zu `v1.0.64`
> fehlte hier, und **vier** Dokumente behaupteten zur selben Zeit, veroeffentlicht
> sei weiterhin nur `v1.0.50`: `WEITERMACHEN.md`, `AUFGABEN.md`,
> `Releases/PAKETE.md` und diese Datei. Gemessen mit `gh release list` (13
> Releases, `v1.0.64` als *Latest*, 2026-09-17T10:23:08Z) und
> `git ls-remote --tags origin` (`refs/tags/v1.0.64`). **Warum das die
> teuerste Sorte Unwahrheit ist:** wer diese Datei liest, glaubt, seit dem
> 13.09.2026 sei nichts hinausgegangen - waehrend Anwender 1.0.64 herunterladen,
> eine Fassung, in der **[E-98](../Intern/BEFUNDE.md#e-98)** offen ist und **[E-101](../Intern/BEFUNDE.md#e-101)** noch gar nicht gefunden
> war (die gespeicherte Datei ist fuer andere Programme unbrauchbar).
