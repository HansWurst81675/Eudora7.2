---
name: reihenfolge-nach-1083
description: "Gregors festgelegte Reihenfolge nach dem Release v1.0.83 - E-112, E-113, E-94, E-77"
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
