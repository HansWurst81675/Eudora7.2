# LEKTOR-25 — Release v1.0.84 gegen GitHub (`c01ca07..1654a52`)

Lauf am 12.10.2026, nur lesend, aus dem Notizordner übernommen. GitHub stimmt (Latest, `eb54752`, SHA-256 nachgerechnet). **Alle vier Mängel sind im selben Commit wie dieser Bericht behoben.**


GitHub belegt: v1.0.84 isDraft=false, isPrerelease=false, publishedAt 2026-10-12T12:59:15Z, Latest; Tag v1.0.84 -> eb547528; Asset Eudora72-1.0.84-release.zip 9 361 952 Byte, sha256sum des Downloads = 4b25a26f…31741 (stimmt). tools/RELEASES.md:31 Zeile vorhanden, 12:59:15 UTC stimmt. doku-pruefen.pl: "Kein Widerspruch gefunden"; zur Kenntnis: Testdaten/README.md, tools/WERKZEUGE.md, tools/pruefdaten/LIESMICH.md nennen 1.0.84 nicht.

## Mängel
1. WEITERMACHEN.md:9 – Zeile sagt "veröffentlicht als `v1.0.84`" und direkt danach "**veröffentlicht ist `v1.0.83`**" (Rest der alten Fassung). Vorschlag: "davor `v1.0.83` (12.10.2026, 11:18 UTC)".
2. ZIEL.md:17 – "**veröffentlicht ist 7.2.0.83 / 1.0.83**" steht vor dem späteren "veröffentlicht als `v1.0.84`" im selben Absatz. Vorschlag: "zuvor veröffentlicht war 7.2.0.83 / 1.0.83 (v1.0.83)".
3. Releases/PAKETE.md:163 – Abschnitt 1.0.84 hat zwei ZIP-Zeilen: "ZIP | **kein ZIP** — als Verzeichnis bereitgestellt" und "ZIP (Release) | …zip, 9 361 952 Byte". Vorschlag: erste Zeile umbenennen in "Testverzeichnis" bzw. "kein ZIP" streichen.
4. (gering) Releases/PAKETE.md:178 und CHANGELOG.md:153 – v1.0.83 noch "auf GitHub als *Latest*" ohne Zeitbezug. Vorschlag: "damals *Latest*, seit 12:59 UTC abgelöst durch v1.0.84".
