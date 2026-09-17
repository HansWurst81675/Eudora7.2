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
| 2026-09-11 13:00:17 | v1.0.48 | Gregor am 11.09.2026 zu 1.0.48: IMAP mit der verschaerften Zertifikatspruefung getestet, 'Successfully retrieved markus.bakus@gmx.de' ueber Port 993 | veroeffentlicht |
| 2026-09-11 08:52:00 | v1.0.47 | Gregor am 11.09.2026 zu 1.0.46: 'ja, jetzt geht es' (E-80) und zu 1.0.47: 'ja, passt!' (E-81) | veroeffentlicht; Release Notes am selben Tag berichtigt (134 statt 175 Nachrichten, zehn statt acht Kopfzeilen) |
| 2026-09-10 13:00:20 | v1.0.43 | Gregor am 10.09.2026 zu 1.0.42/1.0.43: '1. filter fenstergroesse nach neustart gespeichert: PASS' und '2. filter funktionieren.' | veroeffentlicht |
| 2026-09-09 09:10:15 | v1.0.27 | nicht dokumentiert | veroeffentlicht |
| 2026-09-06 13:11:23 | v1.0.15 | nicht dokumentiert | veroeffentlicht; Messfassung mit Spurmarken |
| 2026-09-06 12:12:10 | v1.0.14 | nicht dokumentiert | veroeffentlicht |
| 2026-09-05 20:20:58 | v1.0.10 | nicht dokumentiert | veroeffentlicht |
| 2026-08-31 06:29:35 | v1.0.3 | nicht dokumentiert | veroeffentlicht; Befund V-1 - zwei verschiedene ZIPs unter derselben Nummer |
| 2026-08-30 16:21:16 | v1.0.2 | nicht dokumentiert | veroeffentlicht |
| 2026-08-30 15:08:07 | v1.0.1 | nicht dokumentiert | veroeffentlicht |
| 2026-09-09 13:25:20 | v1.0.29 | Gregor am 09.09.2026 zu Paket 1.0.29: '1-6, ok.' und 'bau mir mit dem bug ein 0.29 release auf github. den fehler notieren wir, wird im naechsten release behoben.' | veroeffentlicht |
| 2026-09-13 13:24:37 | v1.0.50 | Gregor am 13.09.2026: 'gemerged, jetzt 0.50 releasen' - E-76 und E-84 hatte er zuvor am laufenden Programm bestaetigt | veroeffentlicht |
| 2026-09-17 20:07:49 | v1.0.72 | Gregor am 17.09.2026 zu 1.0.72: „kein crash" — belegt durch sein Protokoll: der E-106-Block läuft 18 mal und über die bisher tödliche Stelle hinaus (`pos=770` hinter `pos=765`), letzte Zeile `Logging shutdown`, keine `Exception.log`. Marke auf dem Merge-Commit `8da72c8`. Enthält **E-101**, **E-103**, **E-104**, **E-106** und **E-108**. Offen bleibt **E-98** |
| 2026-09-17 10:23:08 | v1.0.64 | Gregor am 17.09.2026 zu 1.0.64: 'gespeichert. funktioniert.' (E-97) und 'ja, kein datenverlust!' (E-99) | veroeffentlicht, auf GitHub als *Latest* markiert; Tag `1d37623` |

> **Nachgetragen am 17.09.2026 vom LEKTOR (L-13.1).** Die Zeile zu `v1.0.64`
> fehlte hier, und **vier** Dokumente behaupteten zur selben Zeit, veroeffentlicht
> sei weiterhin nur `v1.0.50`: `WEITERMACHEN.md`, `AUFGABEN.md`,
> `Releases/PAKETE.md` und diese Datei. Gemessen mit `gh release list` (13
> Releases, `v1.0.64` als *Latest*, 2026-09-17T10:23:08Z) und
> `git ls-remote --tags origin` (`refs/tags/v1.0.64`). **Warum das die
> teuerste Sorte Unwahrheit ist:** wer diese Datei liest, glaubt, seit dem
> 13.09.2026 sei nichts hinausgegangen - waehrend Anwender 1.0.64 herunterladen,
> eine Fassung, in der **E-98** offen ist und **E-101** noch gar nicht gefunden
> war (die gespeicherte Datei ist fuer andere Programme unbrauchbar).
