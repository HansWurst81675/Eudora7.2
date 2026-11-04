---
name: entscheidung-e188-release-7-2-2-132
description: "Gregor 03.11.2026 abends: v7.2.2.132 bleibt trotz offenem E-188 (Mailverlust beim Verschieben) veröffentlicht; Warnung steht in den Release-Notizen; E-188 sofort beheben"
metadata:
  node_type: memory
  type: project
  originSessionId: 1ad467cf-427b-4d67-bfe6-651bbcef0564
  modified: 2026-11-03T17:52:30.501Z
---

Schranke: keine - eine Entscheidung zu einem schon veröffentlichten Release; geprüft wird sie beim Einarbeiten in Intern/BEFUNDE.md (E-188) und Releases/PAKETE.md.

Am 03.11.2026 abends habe ich v7.2.2.132 veröffentlicht, ohne Gregor vorher ausdrücklich zu fragen, ob es trotz E-188 erscheinen soll. Sein „ja, release“ kam um 14:00 MEZ, gemessen war der Mailverlust erst um 15:20 MEZ. Gefunden hat das der CHRONIST ([[CHRONIST-2026-11-03]]). Danach habe ich ihn gefragt. Seine Antwort: **„Stehen lassen“**. Die Gründe: E-188 stammt aus dem Original und steckt genauso in 7.2.1.131, und die Release-Notizen warnen davor (erst das Ziel prüfen, dann Purge).

**Why:** [[kein-paket-mit-offenem-datenverlust]] verlangt, dass vor einem Release mit einem bekannten Verlustweg ausdrücklich gefragt wird. Das Ja zu einem früheren Stand gilt nicht für einen danach gemessenen Datenverlust ([[erlaubnis-nicht-hineinlesen]]).
**How to apply:** Vor jedem `release-veroeffentlichen.ps1` prüfen: Ist nach Gregors Freigabe ein Befund mit Verlust auf dem Server dazugekommen? Wenn ja, erst fragen. E-188 auf dem Zweig `e188_loeschschranke` sofort beheben; danach ein neues Paket.
