---
name: jeder-start-ins-protokoll
description: "Eine Schranke, die im Werkzeug sitzt, prüft nur die, die das Werkzeug benutzen - am 21.10.2026 liefen 15 Eudora-Starts an testlauf.ps1 vorbei, 0 Zeilen in TESTLAEUFE.md"
metadata:
  type: feedback
---

Schranke: tools/pruefe-startwege.pl (pre-commit) - zählt die eigenen Eudora-Starts unter C:\Temp aus den `eudora.log` und hält sie gegen tools/TESTLAEUFE.md. Gegengetestet in beide Richtungen: `--selbsttest` (11 Fälle), am echten Bestand weist `--tag 2026-10-21` ab (15 Starts, 0 Zeilen) und sechs echte Messtage (12.10., 13.10., 14.10., 17.10., 15.09., 17.09.) laufen durch.

# Jeder Start ins Protokoll

**Regel.** Eudora wird zum Messen über `tools/testlauf.ps1` gestartet, und
über nichts anderes. Wer ein eigenes Mess- oder Serienskript baut, reicht
`-Freigabe` durch, statt selbst `Start-Process` zu rufen. Jeder Start, der
trotzdem danebenläuft, wird noch am selben Tag in `tools/TESTLAEUFE.md`
nachgetragen — mit der Freigabe, auf die er sich stützte.

## Was passiert ist (21.10.2026, E-134)

Für [E-134](../BEFUNDE.md#e-134) (der Kurzname eines neuen Adressbucheintrags
kam nicht an) wurde in gut einer Stunde eine ganze Messserie gefahren:
Spurmarken setzen, drei Läufe mit der Behebung, drei mit der ausgelieferten
1.0.118. Gestartet wurde jedes Mal mit eigenen PowerShell-Aufrufen.

Gemessen am 21.10.2026 im Zweig `wt/chronist-20261021`, mit
`tools/pruefe-startwege.pl`:

| | |
|---|---|
| Prüfstände unter `C:\Temp\E134-*` | **15** |
| eigene Eudora-Starts darin (11:06 bis 12:07) | **15** |
| Zeilen in `tools/TESTLAEUFE.md` mit Datum `2026-10-21` | **0** |
| letzte Zeile in `TESTLAEUFE.md` | `2026-10-20 19:45:51` |

Gregor hat die Fenster gesehen und gefragt.

`tools/WERKZEUGE.md` sagt über `testlauf.ps1`: *„der **einzige** erlaubte Weg,
Eudora zum Messen zu starten. **Öffnet ein Fenster — nur nach Absprache.**"*
Die Regel stand also da, klar und an der richtigen Stelle.

## Warum die vorhandene Schranke nichts gemeldet hat

Sie wurde nicht umgangen. Sie wurde **nicht aufgerufen**.

`testlauf.ps1` weist seit dem 15.10.2026 jede Freigabe ab, die nicht das
heutige Datum nennt ([[nichts-auf-gregors-bildschirm-starten]], Nachtrag
15.10.2026) — und das ist eine gute Schranke. Sie hat nur eine Voraussetzung:
dass jemand `testlauf.ps1` aufruft. Am 21.10. tat es niemand, und die
Schranke schwieg, genau wie sie es an einem Tag ohne jeden Start getan hätte.
Eine stumme Prüfung und eine bestandene Prüfung sehen gleich aus
([[pruefstand-kann-blind-sein]]).

Der Nachtrag vom 13.10.2026 hatte den Mechanismus schon benannt — *„die
Schranke gehört in **jedes** Werkzeug, das startet"* — und daraufhin bekam
`stapel-untersuchen.ps1` die `-Freigabe`-Pflicht. Das schließt den nächsten
bekannten Weg; es schließt nicht den Weg, der im Moment des Messens
**erfunden** wird. Ein Dreizeiler mit `Start-Process` ist in zwanzig Sekunden
geschrieben, und er ist in keiner Liste.

## Woran man es trotzdem sieht

Jeder Eudora-Start schreibt in sein Mailverzeichnis eine `eudora.log` mit
Startzeit und Fassung — unabhängig davon, womit gestartet wurde. Das ist die
Spur, die keiner umgehen kann, weil das Programm sie selbst legt.
`tools/pruefe-startwege.pl` liest sie und hält sie gegen `TESTLAEUFE.md`.

Über den ganzen Bestand von `C:\Temp` (52 Prüfstände) sieht das so aus:

| Tag | Starts | Zeilen | ohne Zeile |
|---|---|---|---|
| 2026-09-08 | 10 | 2 | **10** (vor der ersten Zeile des Protokolls) |
| 2026-09-09 bis 2026-09-17 | 20 | 71 | 1 (16.09.) |
| 2026-10-12 bis 2026-10-17 | 17 | 118 | 0 |
| 2026-10-20 | 6 | 12 | **3** (ab 20:13, nach der letzten Zeile) |
| **2026-10-21** | **15** | **0** | **15** |

Der 21.10. ist kein Ausrutscher, er ist der Höhepunkt: am 20.10. abends
liefen schon drei Starts ohne Zeile. Die Zahl ist nie aufgefallen, weil
niemand sie gebildet hat.

**Eine Falle beim Zählen.** Ein Prüfstand entsteht durch Kopieren, und
mitkopiert wird das Mailverzeichnis samt `eudora.log`. Alle 15 E134-Stände
trugen deshalb dieselbe fremde Startzeile — `Wed Oct 21 10:37:39 2026`, aus
`C:\Users\Gregor\Eudora72-1.0.118-release`, also **Gregors** Lauf,
fünfzehnmal vervielfältigt. Wer sie mitzählt, schlägt fünfzehnmal für einen
fremden Start Alarm. Die Schranke zählt deshalb nur, was **nach** der
`Eudora.exe` dieses Verzeichnisses liegt; gemessen trennt das sauber (die
kopierte Zeile liegt 26 bis 89 Minuten davor, jeder eigene Lauf 2 bis 37
Sekunden danach).

## How to apply

1. Messen heißt `tools/testlauf.ps1 -Freigabe "<Gregors Satz von heute, mit
   Datum>"`. Serien- und Hilfsskripte reichen `-Freigabe` durch (Muster:
   `tools/e118-serie.ps1`), sie tragen sie nie im Quelltext.
2. Vor dem ersten Start des Tages die Ansage: Fenstertitel, Verzeichnis,
   Dauer, *„deine Instanz fasse ich nicht an. Darf ich?"*
   ([[nichts-auf-gregors-bildschirm-starten]]).
3. Prüfstandläufe laufen **im Hintergrund**, damit eine Frage dazwischen
   sofort beantwortet wird.
4. Ist doch danebengestartet worden: `perl tools/pruefe-startwege.pl` sagt,
   welche Starts fehlen. Sie werden nachgetragen, nicht weggelassen.

## Lücken der Schranke

- Sie prüft **nur den heutigen Tag** und nur `C:\Temp`. Gregors eigene
  Verzeichnisse werden nicht angesehen — seine Läufe sind nicht meine, und
  sein Verzeichnis geht mich nichts an (`CLAUDE.md`, Punkt 4).
- Sie zählt im Zweifel zu **wenig**: ein zweiter Lauf im selben Prüfstand,
  ohne dass die `Eudora.exe` dazwischen neu hineinkopiert wurde, fällt heraus.
  Am 21.10. hat sie so einen Start von `E134-Adressbuch` übersehen und
  trotzdem ausgelöst. Zu wenig ist die richtige Richtung: eine Schranke, die
  zu oft umsonst warnt, wird abgeschaltet
  ([[schranke-gehoert-in-den-haken]]).
- Sie prüft, was in `TESTLAEUFE.md` **steht**. Wer nachträgt, was er nicht
  gefragt hat, kommt durch — dagegen hilft nur die Ansage vorher.
- Sie sitzt im `pre-commit`, also **nach** dem Start. Der richtige Moment
  wäre davor ([[ausloeser-an-den-anfang]]); dafür bräuchte es einen
  `PreToolUse`-Haken auf Befehle, die `Eudora.exe` starten, ohne
  `testlauf.ps1` zu nennen. Das ist eine Änderung an Gregors Einstellungen
  und steht als Vorschlag in [CHRONIST-2026-10-21](CHRONIST-2026-10-21.md).

Siehe [[nichts-auf-gregors-bildschirm-starten]], [[werkzeug-vor-eigenbau]],
[[erst-nachstellen-dann-ausliefern]], [[pruefstand-kann-blind-sein]].
