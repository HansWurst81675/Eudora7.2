---
name: entscheidung-e188-k3-sicherheit-vor-platz
description: "Gregor 04.11.2026: E-188 PRUEFER-95 K3 - Sicherheit vor Platz; eine Mail mit verweigertem Teil bleibt 'nicht geladen' (wird bei jedem Anzeigen neu geholt), kein Speicher-Merkzeichen"
metadata:
  type: project
---

Schranke: keine - eine Abwägung im Verhalten; geprüft wird sie am Quelltext (TestE188) und am Prüfstand (E-188tm/fm).

Gregor am 04.11.2026 zu [PRÜFER-95](../Befunde/PRUEFER-95.md) K3: **„Sicherheit vor Platz"**. Verweigert der Server einen Teil einer mehrteiligen Mail, bleibt sie „nicht geladen" (`IMFLAGS_NOT_DOWNLOADED`), auch über einen Neustart; Eudora holt sie bei jedem Anzeigen neu, die Postfachdatei und die Anhangdateien wachsen dabei. Abgelehnt: ein eigenes Merkzeichen nur für die Löschschranke, das nur im Speicher lebt (nach einem Neustart wäre der Schutz weg).

**Why:** Mailverlust auf dem Server wiegt schwerer als Platz; der Fall ist selten (ein Server, der dauerhaft einen Teil verweigert).
**How to apply:** PRÜFER-95 K2 (zweiter Ladeweg setzt „geladen" ohne Bedingung) im selben Sinn beheben. In meiner Frage stand ungeprüft, „Compact" räume die Doppel weg - vor jeder Doku nachmessen ([[ursache-nur-gemessen-behaupten]]).
