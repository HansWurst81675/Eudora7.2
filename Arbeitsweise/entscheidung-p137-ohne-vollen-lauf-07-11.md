---
name: entscheidung-p137-ohne-vollen-lauf-07-11
description: "Gregor 07.11.2026: Test-ZIP 7.2.2.137 ohne vollen Prüfstandslauf (wie 136), voller Lauf vor einem Release; vorher Erst LEKTOR, dann ZIP"
metadata:
  type: project
---

Schranke: tools/paket-bauen.ps1 -OhnePruefbericht mit dieser Begründung; gilt nur für das Testpaket 7.2.2.137.

Gregor am 07.11.2026 (Auswahl): *„ZIP ohne vollen Lauf (Recommended)“* — gelaufen nur E-242, E-169, E-71; der volle Lauf kommt vor einem Release. Davor: *„Erst LEKTOR, dann ZIP“* (keine Umgehung der Rollen-Schranke).

**Why:** schnell testen können, wie bei 7.2.2.136.

**How to apply:** vor einem Release 7.2.2.137 voller Lauf; nicht stillschweigend auf andere Pakete übertragen. Siehe [[release-erst-nach-gregors-test]].
