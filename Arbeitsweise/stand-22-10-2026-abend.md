---
name: stand-22-10-2026-abend
description: "Was am Abend des 22.10.2026 nach dem letzten Merge offen blieb und NICHT im Repo steht - vier Berichtigungen, ein Sicherheitspunkt, das E-124-Ergebnis"
metadata:
  node_type: memory
  type: project
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-22T20:22:57.765Z
---

Stand nach PR #147 (Commit `0f2af17e`). `main` ist sauber, nichts ungepusht,
keine offenen PRs. **Alles Folgende steht in KEINER Datei im Repo** — es kam
nach dem letzten Merge zustande und war beim Abschalten nur im Gesprächsverlauf.
Gregor wurde gewarnt und hat die VM bewusst heruntergefahren.

## Zuerst: ein Sicherheitspunkt, der scharf liegt

`tools/messen-e123-abbruch.ps1` (neu in #147) hat **keine eigene Pfadschranke**.
Im vorgesehenen Weg ist es dicht — `testlauf.ps1` prüft gegen `C:\Temp`. Direkt
aufgerufen mit `-Pfadfilter C:\Users\Gregor` **träfe es Gregors eigene Sitzung**.
Das ist [[tor-gehoert-zum-schritt]]: die Schranke liegt beim Aufrufer statt beim
Schritt. Vier Zeilen: dieselbe `$ErlaubtePfade`-Prüfung im Skript, plus Abweisung
einer Laufwerkswurzel. Dazu `$p.Kill()` statt `Stop-Process -Id` (PID-Neuvergabe).

## PRÜFER, 22.10.2026 abends

**Loch in meiner eigenen Behebung vom selben Tag.** `QT_RueckgabeGenutzt`
(`Eudora71/Tests/Quelltext.cpp`) wurde umgedreht auf eine Liste dessen, was den
Rückgabewert entgegennimmt: `"=(,n&|!?:<>+-*/%"`. Darin stehen **`,`**, **`:`**
und **`>`** — damit gilt ein weggeworfener Wert als genutzt hinter
`pObj->Aufruf(x);`, `case 1: Aufruf(x);` und `a = 0, Aufruf(x);`. Gemessen: der
Kommafall ließ NP3-9 grün. Für die zwei heutigen Nadeln dicht, als Werkzeug nicht.

Bestätigt und in Ordnung: `Test_E24_DieStellen` wird beim Rückbau rot (das Loch
von heute Mittag ist zu), 275/275, drei Quelldateien byte-identisch zurück.

## LEKTOR-51, 22.10.2026 abends — sechs Funde

1. `Releases/PRUEFBERICHT.md` nennt **67 kritische Befunde**; auf `main` sind es
   **68**, und die eigene Aufschlüsselung (16+1+51) ergibt ebenfalls 68.
2. Sein Kopf nennt Commit `294eaad5` — **drei Merges alt**. Neu erzeugen.
3. **E-77 und E-113** tragen `**Zuletzt gemessen:**`, obwohl dort nur gegrept und
   gelesen wurde → auf `**Zuletzt belegt am Quelltext:**` umstellen. Dadurch ist
   die Zahl „nur am Quelltext" um zwei zu gut (25 statt 27).
4. **E-98**: meine „14 Stellen" für `E104SchalterLesen` sind **11** (ich hatte
   Kommentare mitgezählt).
5. `tools/WERKZEUGE.md` fehlen `messen-e123-abbruch.ps1` und `pruefbericht.pl`.
6. **E-130 ist ungegengelesen** — LEKTOR kam nicht dazu.

## E-124 ist gemessen und das Ergebnis dreht ihn um

Aus der von Gregor gespeicherten Seite (Submission `a567fe2a`, eingereicht
20.10.2026 20:57:52, Datei `eudora72-1.0.113-release.zip`):

> Status: In progress
> Analyst comments: *„Your submission has been rejected due to too many files.
> For your submission to be analyzed, resubmit fewer files or remove files from
> any archives you sent."*

Der Status sagt *In progress*, der Kommentar sagt **abgewiesen**. 1033 Dateien,
weil das ganze ZIP hochgeladen wurde. **Wir warten nicht auf Microsoft, sondern
auf uns.** Nächster Handgriff: nur die eine Datei neu einreichen, die Defender
wirklich erwischt hat.

Inhaltlich für uns: Client meldet `Trojan:Win32/Wacatac.C!ml`, **die Cloud meldet
„No malware detected"**, und zu `smime.dll / 3.ico` steht ausdrücklich
*„An analyst has determined that this file is normal"* → **Not malware**.

Gregors E-Mail-Adresse steht auf der Seite und gehört **nicht** ins Repo.

## Drei Befunde warteten fälschlich auf Gregor

E-125 (seine Entscheidung B ist längst gefallen, nur nicht gebaut — Stelle:
`CTocDoc::Xfer`, `tocdoc.cpp:2950`), E-128 (es war *mein* Vorschlag) und E-124
(wartet auf Dritte). Ursache: nach dem Stichwort „Entscheidung" einsortiert
statt den Satz zu lesen. Siehe [[nur-offene-entscheidungen-auf-gregors-liste]].
Es bleibt **ein** Punkt für ihn: **E-133**, sein Ja zu einer kurzen
Registry-Änderung auf dieser Maschine.

## Nebenbei

Die Arbeitsbäume `Eudora7.2-wt-chronist`, `-wt-lektor`, `-wt-pruefer` stehen auf
abgelöstem HEAD. CHRONIST ist seit 34 Dateien fällig.

Schranke: keine - dies ist eine Momentaufnahme des Stands vom 22.10.2026, keine Lehre. Die Punkte darin tragen ihre eigenen Schranken, sobald sie behoben sind.
