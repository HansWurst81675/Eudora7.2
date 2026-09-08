---
name: paket-gegen-den-bau-messen
description: "Was im Paket liegt, ist nicht automatisch das, was ich gebaut habe - jede Datei im Paket gegen das Bauverzeichnis messen, bevor Gregor sie bekommt"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-08T07:54:15.228Z
---

Schranke: tools/paket-pruefen.ps1 (nach jedem Paketbau, vor der Übergabe)

# Das Paket ist nicht der Bau, solange ich es nicht gemessen habe

Am 08.09.2026, 06:59 Uhr, hat `tools/paket-pruefen.ps1` einen Fehler gemeldet,
kurz bevor ich Gregor das Paket 1.0.22 geben wollte:

    DEBUG-LAUFZEIT in der Startkette: Eudora.exe importiert
    MSVCP140D.dll, VCRUNTIME140D.dll, ucrtbased.dll

Mein eigener Bau war einwandfrei — `dumpbin -imports` auf
`Eudora71/Bin/Release/Eudora.exe` zeigte die **Release**-Laufzeiten, genau wie
in 1.0.21. Die `Eudora.exe` **im Paket** war eine andere Datei: 10,2 MB, Stand
**30.08.**, ein Debug-Bau aus dem Grundlagen-ZIP. `tools/paket-bauen.ps1` packt
das Grundlagen-ZIP aus und legt die frischen Dateien nur darüber, wenn
`-AusBauverzeichnis` gesetzt ist. Der Schalter fehlte, also blieb die alte
Datei liegen — und hätte alle Messungen von Gregor an einem Bau vom 30.08.
vorgenommen.

**Warum:** Ein Paket entsteht aus zwei Quellen — dem Grundlagen-ZIP und meinem
Bauverzeichnis. Zwischen „ich habe gebaut" und „Gregor startet" liegt also ein
Schritt, der etwas anderes ausliefern kann als das Gebaute, ohne zu klagen. Das
Ergebnis wäre nicht nur ein falscher Stand, sondern eine **falsche Messung**:
Gregors Testbericht ist das einzige belastbare Messergebnis des Projekts
([[version-eindeutig-machen]]), und er hätte einen Bau beurteilt, der meine
Behebung nicht enthält ([[messung-muss-den-weg-treffen]]).

**Wie anwenden:**

1. **Nach jedem Paketbau `tools/paket-pruefen.ps1 -Paket <Verzeichnis>`** — und
   die Ausgabe lesen, nicht nur den Rückgabewert. Sie hat hier genau das
   gefangen, wofür sie da ist.
2. **Zeitstempel und Größe der Startkette gegen das Bauverzeichnis legen.**
   `Eudora.exe`, `QCSSL.dll`, `EudoraRes.dll`: Datum und Byte-Zahl im Paket
   müssen denen in `Eudora71/Bin/Release/` entsprechen. Eine `Eudora.exe` mit
   **10 MB statt 3 MB** ist ein Debug-Bau, das ist an der Zahl allein erkennbar.
3. **Ein Paketbau, der aus zwei Quellen mischt, braucht den Schalter im
   Aufruf** (`-AusBauverzeichnis`). Fehlt er, liefert der Lauf trotzdem ein
   Paket — der stille Fall, nicht der laute.
4. **Debug-Laufzeiten sind das harte Kriterium.** `MSVCP140D`, `VCRUNTIME140D`,
   `ucrtbased` in einem Import-Verzeichnis heißt: darf nicht raus. Auf Gregors
   Rechner gibt es diese DLLs nicht zwangsläufig — das Paket startet dort
   eventuell gar nicht.
5. **Erst messen, dann melden.** Die Zeile „Paket liegt bereit" kommt nach dem
   Prüferlauf, nicht davor.

Siehe [[version-eindeutig-machen]], [[lauffaehiges-ergebnis-liefern]],
[[erst-pruefen-dann-anweisen]] und [[schranke-gegentesten]].
