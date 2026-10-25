---
name: entscheidung-rootcerts-logzeile
description: "Gregor 25.10.2026 - Eudora schreibt eine Zeile in eudora.log, aus welchem Verzeichnis rootcerts.p7b geladen wurde (Mailverzeichnis vor Programmverzeichnis)"
metadata:
  node_type: memory
  type: project
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-25T15:36:55.408Z
---

Gregor am 25.10.2026 auf die Frage aus LEKTOR-58 (nichts ändern / Zeile im Log / Hinweis beim Start): **„zeile im log, ja"**.

**Why:** QCSSL nimmt `rootcerts.p7b` zuerst aus dem Mailverzeichnis (`ChooseCertFileDirectory`, `QCSSLContext.cpp`, QUALCOMM-Absicht). Wer dort eine alte Datei liegen hat, behält nach E-148 die eMudhra-Wurzeln, ohne es zu merken ([[entscheidung-e148-release-7-2-0-123]], PRUEFER-51 K6).

**How to apply:** Auf dem Zweig `agenten-befunde-25-10b` (Name von Gregor freigegeben). Die Zeile nennt den vollen Pfad der geladenen Datei und die Zahl der Zertifikate; kein Dialog, kein Startverhalten ändern. Vorher klären, ob QCSSL Zugriff auf das Eudora-Protokoll hat — sonst aus Eudora heraus nach dem Laden protokollieren. Ändert sich QCSSL selbst: DLL neu bauen, Version hochzählen, Prüfsumme in `Releases/1.0/README.md` erneuern (der Haken meldet das). Test: Prüfstand mit und ohne Datei im Mailverzeichnis, die Logzeile muss den jeweils richtigen Pfad nennen. In BEFUNDE.md unter E-148 vermerken, Kandidat für Paket 7.2.0.123.

Schranke: keine - eine Entscheidung zum Produktverhalten für genau eine Stelle; geprüft wird sie über den Prüfstandsfall, der die Logzeile verlangt.
