---
name: haengende-kommandos-abbrechen
description: "Hängende Kommandos früh erkennen, abbrechen und anders lösen statt Zeitlimits auslaufen zu lassen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:57:45.141Z
---

Wenn ein Kommando nicht vorankommt: früh abbrechen und einen anderen Weg nehmen
oder gezielt neu versuchen — nicht zweimal in dasselbe Zeitlimit laufen.

**Die Grundregel dahinter:** alles, was laenger als zwei Minuten dauern kann, laeuft
im Hintergrund mit Ausgabe in eine Datei — nie im Vordergrund mit grossem Zeitlimit.
Am Mitschnitt nachgezaehlt waren es **dreimal** zehn Minuten, nicht zweimal: ein
voller MSBuild-Solution-Lauf und zweimal die OpenSSL-Konfiguration. Dazu kommt, dass
`Remove-Item` in der PowerShell im NonInteractive-Modus abbricht, statt zu fragen —
`-Confirm:$false` gehoert dazu. Siehe [[nie-stillstehen]].

**Why:** In der VS2022-Portierung habe ich zweimal zehn Minuten verloren, weil ein
`cmd /c "<pfad>"`-Aufruf aus Git Bash heraus das Batch-Skript nicht ausgeführt,
sondern eine interaktive Eingabeaufforderung geöffnet hat, die auf Tastatureingaben
wartete. Beim ersten Mal habe ich die Ursache falsch bei einem langsamen MSYS-Perl
vermutet und daraufhin unnötig 300 MB Strawberry Perl geladen. Gregor hat das zu
Recht kritisiert.

**How to apply:** Vor einem absehbar langen Lauf einen Rauchtest mit knappem
Zeitlimit machen und prüfen, ob überhaupt erwartete Ausgabe entsteht. Ausbleibende
Ausgabe ist ein Alarmzeichen, kein "läuft noch". Batch-Skripte unter Windows über
`Start-Process cmd.exe -ArgumentList "/c","<pfad>"` mit umgeleiteten Ausgaben
starten — der Weg funktioniert; `cmd /c` aus Git Bash heraus nicht zuverlässig.
Bei der zweiten Fehlschlagsvariante die Hypothese wechseln, nicht die Geduld
verlängern.

Die allgemeine Form dieser Lehre steht in [[pruefen-statt-vermuten]].
