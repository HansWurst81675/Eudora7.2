---
name: pakete-sammeln
description: Kein Testpaket für eine einzelne Behebung anbieten; Gregor testet mehrere Sachen zusammen in einem Bau
metadata:
  node_type: memory
  type: feedback
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-24T20:28:20.590Z
---

Gregor am 24.10.2026, auf mein Angebot, für E-119 ein Testpaket 7.2.0.123 zu bauen: *„nein, wir bauen erstmal nicht extra, ich möchte mehrere sachen zusammen testen, nicht jedes im separaten build."*

**Why:** Jedes Paket kostet ihn eine Testsitzung; einzelne Bauten je Behebung zerstückeln seine Zeit.

**How to apply:** Meldet er einen Fehler, der auf `main` schon behoben ist, nenne ich Befund und Paket, in dem die Behebung kommt — und biete keinen Sonderbau an. Behebungen sammeln sich, bis er ein Paket verlangt. Siehe [[fertige-fassung-bereitstellen]], [[release-erst-nach-gregors-test]].

Schranke: keine - ob ein Sonderbau angeboten wird, ist eine Entscheidung im Gespraech, kein Zustand im Repo; der Ausloeser ist eine Fehlermeldung von Gregor zu einem Befund, der auf main schon behoben ist.
