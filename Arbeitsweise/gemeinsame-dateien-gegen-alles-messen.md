---
name: gemeinsame-dateien-gegen-alles-messen
description: "Änderungen an gemeinsam benutzten Dateien gegen die ganze Solution messen, nicht nur gegen das eigene Projekt"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-30T13:01:09.897Z
---

Wer eine Datei ändert, die **mehrere Projekte einbinden**, muss danach die **ganze
Solution** bauen — nicht nur das Projekt, an dem er gerade arbeitet.

**Why:** Am 29.08.2026 habe ich in `Eudora71/Eudora/stdafx.h:52` `secall.h` durch
`OTShimAll.h` ersetzt und den Include-Pfad `..\OTShim` nur in `Eudora.vcxproj`
eingetragen (`7dcac81`). Dieselbe `stdafx.h` binden aber `AccountWizard`,
`DirectoryServicesUI`, `EuImap` und `SearchEngine` mit ein. Alle vier brachen mit
`C1083` ab: statt 15 wurden nur noch 11 von 18 Projekten fertig.

Ich habe es nicht bemerkt, weil ich zum Messen `-p:BuildProjectReferences=false`
auf `Eudora.vcxproj` benutzt habe — ein Aufruf, der genau das ausblendet, was kaputt
ging. Aufgefallen ist es erst mehrere Commits später, und zwar einem Agenten, dessen
ausdrücklicher Auftrag das Nachmessen war. Behoben mit `1c616c9`.

**How to apply:** Nach jeder Änderung an `stdafx.h`, an einer Projektdatei, an
Include-Pfaden oder an einem Header, den mehr als ein Projekt zieht:

```bash
"C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" Eudora71\Eudora.sln -p:Configuration=Debug -p:Platform=x86 -m -v:m -nologo -clp:ErrorsOnly;Summary
```

Wer wissen will, wer eine Datei mitbenutzt: `grep -rl "<dateiname>" --include=*.vcxproj`
und `grep -rl '#include "<dateiname>"'`.

Der Einzelprojekt-Bau mit `BuildProjectReferences=false` bleibt nützlich, um schnell
zu messen — aber er ist eine **Messhilfe**, kein Nachweis. Siehe
[[pruefen-statt-vermuten]].
