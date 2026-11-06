---
name: stand-03-11-2026-abend
description: "Stand 03.11.2026 abends — #217 (Paket 7.2.2.132) wartet auf Merge, dann Release; danach E-188-Löschbedingung vor E-199"
metadata:
  node_type: memory
  type: project
  originSessionId: f3d03714-d2ce-4d84-96d0-5244b9e265ce
  modified: 2026-11-03T14:42:42.548Z
---

Schranke: keine - Stand-Notiz zum Abschalten; sie haelt einen Tagesstand fest und verliert mit dem naechsten Stand ihre Geltung.

Stand beim Abschalten am 03.11.2026 (alles gepusht, alle Bäume sauber):

- **PR #217** `paket_7_2_2_132` offen, wartet auf Gregors Merge. Danach: Release `v7.2.2.132` mit `Releases/7.2.2.132/RELEASE-NOTIZEN.md` und dem ZIP `%USERPROFILE%\Eudora72-7.2.2.132-release.zip` (SHA-256 177b5997…9115478); Hash der hochgeladenen Datei nachmessen.
- **Gregor 03.11. abends: „ja"** — direkt nach dem Release die **E-188-Löschbedingung** beheben (Quelle nur löschen, wenn im Ziel vollständig angekommen; `ImapActionQueue.cpp` :2160, :2393), **vor E-199**. Zweignamen vorher mit Gregor abstimmen.
- Fertig, PR erst nach dem Release (je LEKTOR davor): `e220_dateiname_vorschlag` (1fa871ab), `e221_betreff_gefaltet` (4fda4987), `E-192_multiple_IMAP-Mails`, `messungen_e188_e193` (f6693b4b, nur Messung + Werkzeuge). Beim Merge: Backtick-Kennungen `E-220`/`E-221` in README/Notizen zu Links machen (L-141.3), README:164 E-220-Doppelzeile.
- E-193: Vorschlag „bei Umlaut/€ ohne Index suchen" — Gregor noch nicht gefragt. Offen: eigene Nummer für den E-188-Löschfehler (meine Entscheidung, Form der Doku).
- CHRONIST fällig. pre-push-Haken blockt Lösch-Pushes (Werkzeugfehler, offen).

Verwandt: [[entscheidung-reihenfolge-nach-7-2-2-132]], [[kein-paket-mit-offenem-datenverlust]]
