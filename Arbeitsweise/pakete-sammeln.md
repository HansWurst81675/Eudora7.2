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

**Nachtrag 25.10.2026 (CHRONIST):** Die Lehre entstand erst beim **vierten** Mal. Gregor am 24.10. (MESZ): 12:35 *„können wir dann zusammen machen, wenn mehreres behoben ist, dann kann ich es in einer session testen"*, 12:38 *„es ist eh besser, wenn mehrere bugs gefixt sind und ich dann ein build zum testen habe"*, 12:49 *„bruachen wir jetzt schon ein .0123? ich teste lieber alles zusammen."*, 22:28 der Satz oben. `tools/verlauf-messen.pl` führt den zweiten als Wiederholung. Wer eine Vorgabe zweimal in 15 Minuten hört, schreibt sie beim zweiten Mal auf ([[anweisungen-abarbeiten]]: Wiederholung ist ein Alarmzeichen).
