---
name: haengende-kommandos-abbrechen
description: "Hängende Kommandos früh erkennen, abbrechen und anders lösen statt Zeitlimits auslaufen zu lassen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:57:45.141Z
---

Schranke: keine - ein hängendes Kommando zeigt sich zur Laufzeit im Chat; im Repo bleibt keine Spur, gegen die sich prüfen ließe

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

## Nachtrag 30.10.2026 (CHRONIST): in den Hintergrund geschoben, falsch erklärt, nie gestoppt

Zeiten MEZ, gemessen an Transkript `052dc212…` ([[CHRONIST-2026-10-30]]).

| Zeit | Was |
|---|---|
| 21:55:39 | **ein** Aufruf: Teilstring-Ersetzung in `Releases/PAKETE.md`, Nachrichtendatei schreiben, `git add`, `git commit` |
| 21:57:40 | 120-s-Limit, das Werkzeug schiebt den Aufruf in den Hintergrund, die Ausgabedatei ist leer |
| 21:58:14 | an Gregor: *„Der Commit hängt noch im Haken (Testbau läuft). Ich warte darauf …“* |
| 22:03:11 | Warteschleife auf einen `git commit`, der nicht lief; sofort fertig |
| 22:03:21 | *„Der Commit vorhin ist nicht durchgelaufen.“* |
| 22:03:36 | derselbe Helfer noch einmal mit `timeout 20`: 22 Sekunden, keine Ausgabe, danach ein anderer Weg (`perl -i` über Zeilenanker) |
| 22:31:25 | *„Alles ist gesichert, nichts läuft mehr.“* |

Die Ursache stand nicht im Haken. Sie steckte im Ersetzungshelfer: Der neue Text enthielt den alten, und die Schleife suchte nach jeder Ersetzung wieder von vorn ([[text-nicht-durch-schichten-schicken]], Fall 38, nachgestellt). Der Haken ist nie gestartet. Für den Hintergrundauftrag gibt es im Transkript weder `TaskStop` noch eine Abschlussmeldung.

**Drei Regeln dieser Lehre gebrochen, alle stehen oben:** *„Ausbleibende Ausgabe ist ein Alarmzeichen, kein ‚läuft noch‘“*, *„bei der zweiten Fehlschlagsvariante die Hypothese wechseln“* (der zweite Anlauf um 22:03:36 mit demselben Helfer), und der Nachtrag vom 15.10. in [[einwurf-ist-ein-messwert]]: *„Ein `git push` gehört nicht in denselben Vordergrundaufruf wie die Arbeit, auf die Gregor wartet.“* In diesen zwölf Minuten kamen *„was hat lektor noch gefunden?“* und *„ich warte“*.

**How to apply, zusätzlich:**
- Ein Aufruf, den das Werkzeug in den Hintergrund schiebt, läuft weiter. Entweder seine Ausgabedatei lesen und benennen, was er gerade tut, oder ihn mit `TaskStop` beenden. Ohne gelesene Ausgabe ist die Meldung *„X läuft“* eine Vermutung ([[ursache-nur-gemessen-behaupten]]).
- Wer *„nichts läuft mehr“* sagt, hat jeden Hintergrundauftrag der Sitzung gesehen, der keine Abschlussmeldung bekam. `gesichert.pl` misst nur Git.
- Ändern, Committen und Pushen sind drei Aufrufe. Der Commit-Haken braucht bis zu fünf Minuten, und eine Ersetzung, die hängt, darf nicht hinter ihm verschwinden.
