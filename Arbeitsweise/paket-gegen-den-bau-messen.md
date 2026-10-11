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

## Nachtrag 11.09.2026: diesmal fehlte die eine DLL, auf die es ankam

Punkt 2 oben verlangt, Zeitstempel und Größe der **Startkette** gegen das
Bauverzeichnis zu legen: `Eudora.exe`, `QCSSL.dll`, `EudoraRes.dll`. Am
11.09.2026 hat genau dieser Handgriff einen zweiten Fall gefangen — und zwar
den, der am meisten gekostet hätte:

| Datei | im Bau | im Paket |
|---|---|---|
| `QCSSL.dll` | 11.09., 10:56, **2.921.472 B** | 30.08., 17:57, **2.920.960 B** |

Der Zertifikats-Patch dieses Tages ändert **genau diese eine DLL** und keine
andere. Gregor hätte die unveränderte Prüfung getestet, nichts bemerkt und
gemeldet, die Verschärfung wirke nicht — ein Testbericht über einen Bau vom
30.08. ([[messung-muss-den-weg-treffen]]).

**Zwei Dinge sind hier anders als am 08.09.:**

1. **`paket-pruefen.ps1` hat geschwiegen, und zwar zu Recht: es kennt die Datei
   nicht.** Seine Prüfliste ist von Hand gepflegt, `QCSSL.dll` stand nicht
   darauf. Eine Schranke mit handgepflegtem Umfang prüft genau das nicht, woran
   niemand gedacht hat ([[pruefumfang-nicht-von-hand]]).
2. **Gefunden hat es nur der mitausgegebene Zeitstempel**, also ein Nebenprodukt,
   kein Prüfschritt. Beim nächsten Mal steht dieselbe Datei vielleicht ohne
   Zeitstempel da.

Der Unterschied der beiden Bauarten erklärt, warum die DLL überhaupt fehlte:
im **Debug**-Bau ist sie 4.645.376 B gegen 2.920.960 B in der Grundlage, also
eine andere Bauart — deshalb wurde sie bewusst nicht übernommen. Im
**Release**-Bau sind es 2.921.472 B, 512 Byte mehr als die Grundlage, dieselbe
Bauart. Die Begründung im Bauskript stimmte, aber nur für eine der beiden
Bauarten, und galt trotzdem für beide. Seither kommt `QCSSL.dll` bei
`-Bauart Release` mit.

**Also zusätzlich zu Punkt 2:**

- **Die Prüfliste ist die Ausgabe des Baus, nicht eine Aufzählung.** Was der Bau
  in `Eudora71/Bin/<Bauart>/` erzeugt hat, wird Datei für Datei gegen das Paket
  gelegt; was der Bau erzeugt und im Paket **fehlt**, wird genannt. Das ist der
  Vorschlag an PRÜFER; ich habe ihn nicht gebaut.
- **Eine Begründung, die „nicht übernehmen" sagt, nennt die Bauart, für die sie
  gilt.** Ein Satz ohne diese Angabe wird auf beide angewandt und ist dann in
  einer von beiden falsch.
- **Der Patch sagt, welche Datei zu prüfen ist.** Wer eine einzelne Quelldatei
  ändert, weiß, welche Binärdatei sich bewegen muss — und misst genau diese im
  Paket nach, bevor er das Paket meldet.
