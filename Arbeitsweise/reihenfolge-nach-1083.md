---
name: reihenfolge-nach-1083
description: Gregors Reihenfolge nach dem Release v1.0.83 - E-94 (Test zuerst), dann E-112, E-113, E-77
metadata:
  node_type: memory
  type: project
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-12T11:00:03.462Z
---

Gregor am 12.10.2026, nach meinem Vorschlag: *„danach die reihenfolge aus deinem vorschlag: E112, E-113, E-94, E-77"*.

1. **Release v1.0.83** abschließen (Zweig `release-v1.0.83`, vorher die Unwahrheiten aus LEKTOR-16/17 auf `wt/lektor` berichtigen — „keine lügen auf main!").
2. **E-112** — Bilder in Originalgröße statt angegebener Größe, Text liegt darauf (Versuch in 7.2.0.76 wirkt nicht: `draw_meta_file` skaliert nur bei `mapping_mode` ≠ `MM_TEXT`).
3. **E-113** — zu breite Bilder laufen rechts aus dem Fenster.
4. **E-94** — Betreff mitten im Wort umbrochen. Ursache am Quelltext belegt, nicht gemessen: `lex822.cpp:685` und `ImapLex822.cpp:719`, Leerraum zwischen zwei kodierten Wörtern über eine Faltung wird nicht entfernt (RFC 2047 6.2). IMAP: `ImapFix2047` bekommt die ganze Kopfzeile (`ImapDownload.cpp:2276`); POP: `LexFill` zeilenweise, braucht Merker. Offene Frage an Gregor: darf ich die Toner-Nachricht roh aus seinem IMAP-Postfach lesen, oder legt er eine .eml hin.
5. **E-77** — IMAP-Ordnernamen in modifiziertem UTF-7 (`Entw&APw-rfe`).

**Why:** Gregor legt die Reihenfolge fest; E-112/E-113 sieht man bei jeder HTML-Mail.
**How to apply:** Nach jedem Punkt erst fertig (gemergt, gelöscht), dann den nächsten Zweignamen vorschlagen ([[zweigname-heisst-vorheriger-fertig]]). Diese Datei nachziehen, sobald ein Punkt erledigt ist.

Schranke: keine - eine Reihenfolge ist eine Absprache, kein Zustand des Codes; sie steht zusätzlich in WEITERMACHEN.md, sobald der LEKTOR-Zweig zusammengeführt ist

## Nachtrag E-94, 12.10.2026 nachmittags (gemessen an Gregors 1.0.75-INBOX.mbx, mit seiner Erlaubnis nur gelesen)

Die Nachricht hat **web.de-Webmail** erzeugt (Received `trinity-msg-rest-webde … via HTTP`, Gregor hat dort von web.de an gmx weitergeleitet), **nicht** Eudora. In der `.mbx` steht der Betreff schon **dekodiert**, mit 8-Bit-Bytes und Faltungen mitten im Wort: `… bestellen & 1<CR><LF> 5 % sparen … Nur b<CR><LF> is zum Wochenende!`. Das passt zur Ursache „Faltung zwischen zwei kodierten Wörtern bleibt stehen“ (`ImapLex822.cpp:719`), denn Eudora dekodiert vor dem Ablegen (`ImapDownload.cpp:2276`). **Noch nicht gemessen:** die Rohform vom Server — Gregor soll sie im GMX-Webmailer per „Quelltext anzeigen“ holen. Erwartet: mehrere `=?UTF-8?…?=` mit Grenzen bei `& 1|5` und `Nur b|is`.
Ich hatte die Ursache zuerst vorschnell für widerlegt erklärt, weil keine kodierten Wörter in der `.mbx` standen — dabei legt Eudora sie gar nicht ab.

## Geändert am 12.10.2026: E-94 rückt vor

Gregor auf meinen Vorschlag dreier Teststufen (Unit-Test POP-`Fix2047`, Unit-Test `ImapFix2047` per `Extract.ps1`, Prüfnachricht 06 im POP-Prüfstand): *„zu diesem fall brauchen wir einen weiteren test"*, dann gewählt **„Jetzt, vor E-112"**.
**Neue Reihenfolge:** Release v1.0.83 → **E-94 (erst die Tests rot, dann Behebung, dann grün)** → E-112 → E-113 → E-77.

**Zweigname für E-94 von Gregor bestätigt** (12.10.2026, *„ja, branch name ist ok"*): `e94-betreff-faltung`. Anlegen erst, wenn `release-v1.0.83` gemergt und gelöscht ist; dann in `tools/ZWEIGE.md` eintragen.

**Stand 12.10.2026, 13:35:** Release v1.0.83 veröffentlicht (11:18 UTC), PR #85 gemergt, `release-v1.0.83` gelöscht. **`e94-betreff-faltung` angelegt** auf `e4c87fb`, verfolgt `origin/e94-betreff-faltung`. Begonnen mit Stufe 1 (rote Tests).

**Stand 12.10.2026, Sitzungsende:** E-94 behoben in 7.2.0.84, von Gregor per Bildschirmfoto bestätigt; 1.0.84 liegt in `C:\Users\Gregor\Eudora72-1.0.84-release`; **PR #86** (`e94-betreff-faltung`) offen, alles gepusht (`f21ff31`). **Nächste Sitzung zuerst:** nach Gregors Merge von #86 das Release **v1.0.84** (Gregor hat es angewiesen: „dann ein github release“) — ZIP mit `paket-bauen.ps1 -Zip`, gegen das bereitgestellte Verzeichnis per Prüfsumme halten, `release-veroeffentlichen.ps1`, danach alle Stand-Aussagen auf „veröffentlicht“ ziehen und LEKTOR. Dann E-112. Offen: Steuerzeichen-Schranke für MD (Rückstrich dreimal verloren), POP-Prüfserver auf 11110 läuft noch (PID 12680).

**Stand 12.10.2026, wirklich zum Sitzungsende:** Release **v1.0.84** veröffentlicht (12:59:15 UTC, Latest, Marke `eb54752`, SHA-256 `4b25a26f…1741` nachgerechnet); PR #86 (E-94) und PR #87 (Release-Doku) gemergt, beide Zweige gelöscht; main auf `ae657e6`, sauber. POP-Prüfserver beendet. **Nächste Sitzung:** zuerst CHRONIST (fällig wegen `tools/RELEASES.md`, `tools/ZWEIGE.md`), dann **E-112** (Zweigname vorher mit Gregor abstimmen), dabei die Steuerzeichen-Schranke für MD-Dateien bauen (Rückstrich/Escape heute viermal verloren: `C:TempAN5`, `\?\`, ESC statt `\E`, `\U` in printf).

**Stand 12.10.2026, abends.** v1.0.84 ist veröffentlicht, E-94 behoben und von Gregor bestätigt. Danach lief ein Tag, an dem **kein Quelltext** angefasst wurde: Verlinkung aller Kennungen (PR #90), Nachbesserung in fünf Punkten, LEKTOR-26 mit zehn Mängeln und zwölf vom Verlinken blind gewordenen Werkzeugen (PR #91, beide gemergt). **Nächster Schritt bleibt [E-112](../BEFUNDE.md#e-112)** — Bilder werden in Originalgröße gezeichnet statt in der angegebenen; danach [E-113](../BEFUNDE.md#e-113), dann [E-77](../BEFUNDE.md#e-77). **Dazwischen wartet Gregors Urteil** zu fünfzehn gebauten Behebungen; der Weg dafür steht in [TESTPLAN.md](../TESTPLAN.md), die fünfzehnte ([E-101](../BEFUNDE.md#e-101)) ist seit LEKTOR-26 darin enthalten. Offen und unverändert: Steuerzeichen-Schranke für MD, und die Frage, ob die Beschreibung eines Befunds an **eine** Stelle gehört statt an durchschnittlich sieben.