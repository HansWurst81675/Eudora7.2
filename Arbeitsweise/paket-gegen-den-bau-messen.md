---
name: paket-gegen-den-bau-messen
description: "Was im Paket liegt, ist nicht automatisch das, was ich gebaut habe - jede Datei im Paket gegen das Bauverzeichnis messen, bevor Gregor sie bekommt"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-10-13T15:00:00.000Z
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

## Nachtrag 13.10.2026: dieselbe Falle, diesmal aus Bin\Debug, und das Werkzeug hat sie gefangen

Paket 1.0.85 (10:35 UTC) wurde mit `paket-bauen.ps1 -Ziel … -AusBauverzeichnis` gebaut. Ohne weitere Angaben nimmt das Werkzeug zwei Vorgaben, die nicht mehr zum Projekt passen:

- `-Bauart` ist standardmäßig `Debug`. Übernommen wurde also `Eudora71\Bin\Debug`, und dort lag eine `Eudora.exe` mit **7.2.0.12**.
- `-Grundlage` ist standardmäßig `Releases\Eudora72-1.0.2-lauffaehig.zip`.

Das Protokoll meldete *„7 von 7 uebernommen“*. Gemessen hat es erst der nächste Aufruf, `paket-pruefen.ps1` (*„KRITERIUM 0 … NEIN“*, MSVCP71.dll fehlt). In derselben Ausgabe standen die Dateiversion `7.2.0.12` und der Prüfsummenvergleich mit `Bin\Release` (`False`). Die Lehre hat also gewirkt. Gregor hat das falsche Verzeichnis nie gesehen.

Danach:

- Das Löschen des falschen Verzeichnisses lehnte die Sitzung ab (*Irreversible Local Destruction*). Es wurde umbenannt in `Eudora72-1.0.85-FALSCH-debug-7.2.0.12-nicht-benutzen`, und Gregor wurde gebeten, es selbst zu löschen. Das war richtig: Ein Name, der sagt, was das Verzeichnis ist, kann nicht verwechselt werden.
- 1.0.85 und 1.0.86 wurden **von Hand** gebaut: `Eudora72-1.0.84-release.zip` auspacken, die EXE/DLL/OCX aus `Bin\Release` darüberkopieren, dann `paket-pruefen.ps1`. Für die nächste Sitzung steht in `WEITERMACHEN.md` nur ein Satz: *„nicht `paket-bauen.ps1 -AusBauverzeichnis`, das nimmt `Bin\Debug`“*.

**Das ist das zweite Auftreten derselben Klasse** (08.09.: alte Debug-EXE aus der Grundlage; 13.10.: alte Debug-EXE aus `Bin\Debug`). Nach [[fehlerklassen-abstellen]] reicht kein Satz in `WEITERMACHEN.md`. Der Weg, auf dem das Paketwerkzeug ohne Zusatzangaben ein richtiges Paket baut, ist bisher der Handweg daneben.

**How to apply (Ergänzung):**

- **Das Paketwerkzeug muss beim Bauen selbst abweisen**, nicht erst `paket-pruefen.ps1` danach. Vorschlag für die Hauptsitzung, nicht gebaut: `paket-bauen.ps1` vergleicht nach dem Übernehmen die Dateiversion von `Eudora.exe` im Ziel mit `Eudora71/Version.h` und bricht bei Abweichung ab. Dazu `-Bauart` standardmäßig `Release` und als Grundlage das ZIP des letzten Tags statt 1.0.2. Gegenprobe: der Aufruf vom 13.10. (`-AusBauverzeichnis` ohne `-Bauart`) muss abgewiesen werden.
- Bis dahin gilt: Wer ein Paket baut, nennt `-Bauart` und `-Grundlage` ausdrücklich, oder nimmt den Handweg oben. Fertig ist es erst, wenn `paket-pruefen.ps1` grün meldet und die Fassung gleich `Version.h` ist.

## Nachtrag 15.10.2026 (CHRONIST): die Prüfung fing das Fehlende, nicht das Überzählige

Beim Paket 1.0.96 (15.10., 11:35 UTC) meldete `paket-pruefen.ps1`, dass
`MSVCP71.dll` fehlt, und das Paket hatte 31 statt 33 Dateien. Ursache: das
ZIP der Grundlage hat keinen Oberordner, und beim Entpacken war der Ordner
`Emoticons` umbenannt worden. **Die Schranke hat gegriffen**, bevor Gregor
etwas bekam; das Paket wurde neu gebaut.

Danach blieb ein Unterschied, den **keine** Prüfung meldete: `LDAP32.DLL` lag
im neuen Paket und in keinem früheren. Gefunden durch einen Vergleich von Hand
mit 1.0.95 (11:36), herausgenommen um 11:36:54. `paket-pruefen.ps1` prüft die
Startkette auf **fehlende** Abhängigkeiten; eine zusätzliche Datei gegenüber
dem vorigen Paket fällt nicht auf.

**How to apply (Ergänzung):** nach jedem Paketbau die Dateiliste gegen das
vorige Paket halten, in beide Richtungen — fehlt etwas, ist etwas dazu? Der
Handvergleich vom 15.10. ist der Weg, bis das Werkzeug ihn kann.
**Vorschlag für die Hauptsitzung (nicht gebaut):** `paket-pruefen.ps1
-Vorgaenger <Verzeichnis>` meldet beide Richtungen; Gegenprobe: 1.0.96 vor dem
Herausnehmen von `LDAP32.DLL` gegen 1.0.95 muss die Datei nennen.
