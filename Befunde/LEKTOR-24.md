# <a id="lektor-24"></a>LEKTOR-24 — E-94-Bestätigung gegen Bildschirmfoto und Bestand (`f0f6d0e..306d611`)

Lauf am 12.10.2026, nur lesend, aus dem Notizordner übernommen. **Alle vier Mängel sind im selben Commit wie dieser Bericht behoben.**


Geprüft: Bildschirmfoto images/2.png, C:\Users\Gregor\Eudora72-1.0.84-release (existiert, Eudora.exe FileVersion 7.2.0.84), offene-befunde.pl („Die Liste deckt die offenen Befunde.", 28/28), doku-pruefen.pl („Kein Widerspruch gefunden."; zur Kenntnis: PORTIERUNG.md, Testdaten/README.md, tools/WERKZEUGE.md, tools/ZWEIGE.md, tools/pruefdaten/LIESMICH.md nennen 7.2.0.84/1.0.84 nicht).

Richtig: Titelzeile `7.2.0.84 / Paket 1.0.84+05bbaba*`; Kopf-Betreff einstellig und ohne Gedankenstrich (zwei Leerzeichen vor `Nur bis`), wie die Beobachtung sagt; `Rabatt aktivieren und Preisvorteil si` steht in der Liste. PAKETE.md 1.0.84 passt zum Verzeichnis.

## Mängel

1. WEITERMACHEN.md:9 „**[E-94](../BEFUNDE.md#e-94) in Arbeit**“ — widerspricht „behoben, von Gregor bestätigt“. Vorschlag: „[E-94](../BEFUNDE.md#e-94) behoben in 7.2.0.84, von Gregor bestätigt (12.10.2026); 1.0.84 bereitgestellt, nicht veröffentlicht“.
2. WEITERMACHEN.md:10 endet bei „Gebaut und gemessen (POP …)“ — keine IMAP-Messung, keine Bestätigung, nichts zu „bereitgestellt“. Vorschlag: beides ergänzen.
3. ZIEL.md:17 „**In Arbeit ist 7.2.0.84 mit [E-94](../BEFUNDE.md#e-94)** … über POP am laufenden Programm gemessen“ — veraltet. Vorschlag: „7.2.0.84 mit [E-94](../BEFUNDE.md#e-94) ist behoben, über POP und IMAP gemessen, von Gregor bestätigt; Paket 1.0.84 bereitgestellt, nicht veröffentlicht“. Im selben Absatz fehlt bei „am 12.10.2026 liegen dort die Verzeichnisse 1.0.72 bis 1.0.76 und 1.0.83“ das Verzeichnis 1.0.84.
4. AUFGABEN.md:725 Überschrift „am laufenden Programm gemessen (POP)“ und die Tabelle 731–736 ohne IMAP-Messung und Bestätigung. Vorschlag: „… gemessen (POP und IMAP), von Gregor bestätigt am 12.10.2026“ und eine Zeile „Gregors Test an 1.0.84 | bestätigt (Bildschirmfoto)“.
5. CHANGELOG.md:98 und BEFUNDE.md (E-94-Zeile): das Zitat `Fw: [Letzte Chance] Toner bestellen & 15 % sparen – Nur bis` ist nicht wörtlich. Im Bild stehen doppelte Leerzeichen: `Fw:  [Letzte Chance] Toner  bestellen & 15 % sparen  – Nur bis`. CHANGELOG:85ff. gibt `Toner  bestellen` richtig mit doppeltem Leerzeichen wieder. Vorschlag: die Leerzeichen wie im Bild setzen oder „(Leerraum vereinfacht)“ dazuschreiben.
6. README.md:135 ist richtig („behoben in 7.2.0.84“), nennt aber die Bestätigung nicht. Kein Widerspruch, Ergänzung empfohlen.

Nirgends steht zu [E-94](../BEFUNDE.md#e-94) „noch nicht bestätigt“ oder „nicht gebaut“ (grep über alle *.md; Treffer nur in Befunde/LEKTOR-23.md, einem älteren Bericht).
