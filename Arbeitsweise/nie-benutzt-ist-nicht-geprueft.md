---
name: nie-benutzt-ist-nicht-geprueft
description: "Was niemand je angeklickt hat, gilt nicht als geprueft - E-97 lag 15 Fassungen und ein veroeffentlichtes Release lang im Speichern-Dialog"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-17T00:00:00.000Z
---

Schranke: keine - es gibt keine Liste der Grundfunktionen und kein Werkzeug, das sie durchlaeuft. Der Vorschlag steht unten in dieser Datei und ist bewusst noch nicht gebaut; wer ihn baut, traegt die Schranke hier ein.

# Was niemand je angeklickt hat, gilt nicht als geprueft

## Der Ausloeser

**Gregor am 15.09.2026**, nachdem ich ihn gebeten hatte, mir eine Nachricht
als Datei zu geben:

> *„da kommt kurz eine meldung, dann ist eudora weg!"*

Er hat nicht nach einem Fehler gesucht. Er sollte *File → Save As* benutzen,
weil **ich** die Datei brauchte. Der Absturz ist ein Nebenprodukt meiner
eigenen Bitte.

## Die Messung

E-97 wurde danach rueckwaerts eingegrenzt (`tools/TESTLAEUFE.md`,
15.09.2026, 13:38 bis 13:39):

| Fassung | Ergebnis |
|---|---|
| 1.0.63, 1.0.62, 1.0.53 | stuerzt ab (1.0.62 und 1.0.53 von Gregor) |
| 1.0.50, 1.0.49 | stuerzt ab (eigene Testlaeufe) |

**1.0.50 ist veroeffentlicht.** Der Fehler lag also ueber **fuenfzehn
Fassungen** und ein Release im Baum, und in dieser Zeit ist er **kein
einziges Mal** aufgefallen — nicht weil er schwer zu treffen waere, sondern
weil in vier Wochen niemand eine Nachricht gespeichert hat. Ein Klick haette
gereicht.

Die Ursache selbst ist die bekannteste des Projekts: `GetParent()` liefert
NULL, waehrend der Dateidialog sich aufbaut, und beide Zugriffe in
`CSaveAsDialog::OnTypeChange` (`SaveAsDialog.cpp:425`) waren durch ein
`ASSERT` „abgesichert", das im Release nichts tut
([[assert-ist-im-release-nichts]]). Das ist hier aber **nicht** die Lehre.
Die Lehre ist, dass die Stelle nie erreicht wurde.

## Why — „kein Befund" und „nie ausprobiert" sehen gleich aus

Das ist dieselbe Form wie beim blinden Pruefstand
([[pruefstand-kann-blind-sein]]): *ein kaputter und ein gruener Pruefstand
melden im Alltag dasselbe, naemlich nichts.* Hier ist es eine Ebene hoeher:

**Eine Funktion, die niemand aufruft, meldet dasselbe wie eine, die
funktioniert.** In `BEFUNDE.md` steht dann nichts, in `ZIEL.md` steht
Kriterium 4 („keine Abstuerze") auf **fast** — und beides liest sich wie
Deckung.

Der Pruefumfang dieses Projekts kommt bisher fast vollstaendig aus **Gregors
Benutzung**. Was er im Alltag tut (abrufen, lesen, beenden, Fenster ziehen),
ist gut geprueft; was er selten tut, ist ungeprueft und sieht trotzdem
geprueft aus. Das ist ein Pruefumfang von Hand, nur unsichtbar
([[pruefumfang-nicht-von-hand]]): die Liste der geprueften Wege ist genau die
Liste der Wege, an die jemand gedacht hat.

Und es ist teuer in der falschen Richtung: der Fehler wird nicht von mir
gefunden, sondern von **ihm**, in dem Moment, in dem er die Funktion
braucht. Genau die Rolle, die er nicht haben will — *„ich traue dir nicht
ganz, jemand soll dich immer wieder ueberpruefen — das bin aber nicht ich!"*

## Der Bestand: es gibt keine solche Liste

Nachgemessen am 17.09.2026 in `tools/WERKZEUGE.md`: **kein** Werkzeug laeuft
Grundfunktionen durch. Es gibt Einzelstuecke fuer je **einen** Weg —

| Werkzeug | welcher Weg |
|---|---|
| `tools/strg-n-pruefen.ps1` | Nachricht verfassen (Strg-N) |
| `tools/nachricht-oeffnen.ps1` | Nachricht oeffnen |
| `tools/testlauf.ps1` | starten und beenden |

— und beide ersten sind aus einem Befund heraus entstanden, also **nachdem**
der Weg kaputt war. `tools/paket-bereit.pl` faehrt alle Schranken vor dem
Paket; jede einzelne davon liest **Quelltext oder Dokumentation**. Keine
bedient das Programm.

Damit ist die Luecke benannt: **antworten, weiterleiten, speichern, drucken,
loeschen, anhaengen** sind in keiner Fassung dieses Projekts je durch ein
Werkzeug gelaufen.

## How to apply

1. **„Nicht gemeldet" ist keine Aussage ueber eine Funktion.** Bevor
   „funktioniert" oder „keine Regression" fuer einen Weg gesagt wird, gilt
   die Frage: *wer hat ihn wann angeklickt?* Faellt die Antwort aus, heisst
   es **„nie ausprobiert"**, nicht „in Ordnung"
   ([[erfolg-aus-anwendersicht]]).
2. **Wer den Anwender um einen Handgriff bittet, hat ihn vorher selbst
   getan.** E-97 ist bei genau diesem Muster aufgeflogen: ich habe Gregor um
   *Save As* gebeten, ohne es je selbst gemacht zu haben
   ([[erst-pruefen-dann-anweisen]]).
3. **Ein Befund, dessen Weg noch nie gelaufen ist, gehoert mit diesem Satz
   aufgeschrieben.** In E-97 steht er: *„kein neuer Fehler, sondern einer,
   der die ganze Zeit dalag und nie auffiel, weil niemand eine Nachricht
   gespeichert hat"*. Dieser Satz ist der wertvolle Teil des Befunds — er
   sagt, dass danebenliegende Wege denselben Zustand haben koennen.
4. **Die Nachbarschaft mitpruefen.** Wenn ein nie benutzter Weg kaputt war,
   sind die anderen nie benutzten Wege Kandidaten, nicht Zufall. Nach E-97
   gehoeren *drucken*, *anhaengen* und *weiterleiten* auf die Liste, bevor
   Gregor sie das naechste Mal braucht.

## Was fehlt — der Vorschlag, nicht gebaut

Es fehlt eine **Liste der Grundfunktionen** als Datei (nicht als Aufzaehlung
in einem Auftrag) und ein Werkzeug, das vor dem Paketbau meldet, wann jede
zuletzt durchlaufen wurde:

- **Die Liste kommt aus der Quelle, nicht aus meinem Kopf.** Der Kandidat ist
  Eudoras **Menuetabelle** (`EudoraRes.rc`): jeder `ID_FILE_*`, `ID_MESSAGE_*`
  und `ID_EDIT_*`-Eintrag ist ein Weg, den ein Anwender anklicken kann. Eine
  von Hand geschriebene Liste haette „Speichern unter" mit hoher
  Wahrscheinlichkeit nicht enthalten — sie enthaelt, woran man denkt
  ([[pruefumfang-nicht-von-hand]]).
- **Gefuehrt wird, wann ein Weg zuletzt lief**, mit Fassungsnummer, wie
  `tools/TESTLAEUFE.md` es fuer Starts tut. „Zuletzt durchlaufen in 1.0.49"
  ist eine Zahl; „geprueft" ist keine.
- **Meldend vor dem Paket, nicht abweisend.** Eine Schranke, die jeden
  Paketbau blockiert, weil neun von zwanzig Wegen nie liefen, wird abgestellt
  ([[ausloeser-an-den-anfang]], [[schranke-gegentesten]]). Der Nutzen liegt in
  der **Zahl**: *„14 Grundfunktionen, davon 9 in keiner Fassung durchlaufen"*
  ist eine Aussage, die man Gregor hinlegen kann.
- **Wo das Werkzeug ein Fenster oeffnet, gilt die Absprache.** Ein Durchlauf
  bedient das laufende Programm — also nur ueber `tools/testlauf.ps1` und nur
  nach Gregors Ja ([[nichts-auf-gregors-bildschirm-starten]],
  [[keine-tastendruecke-verschicken]]).

**Die Frage beim naechsten Mal:** *Welche Funktion, die Gregor selten
benutzt, ist seit ihrer Portierung kein einziges Mal aufgerufen worden — und
woran wuerde ich es merken, wenn sie kaputt waere?*

Siehe [[assert-ist-im-release-nichts]], [[pruefstand-kann-blind-sein]],
[[pruefumfang-nicht-von-hand]], [[erfolg-aus-anwendersicht]] und
[[erst-pruefen-dann-anweisen]].

## Nachtrag 17.09.2026: PRUEFER hat am selben Tag den zweiten Fall gemessen

`008e18a`, wenige Minuten nach der Behebung von E-97: die Dialogvorlage
`IDD_SAVEAS_EXT` wird **nie instanziiert**. MFC 14.38 nimmt
`bVistaStyle=TRUE` als Vorgabe, `DoModal` geht ueber `IFileDialog::Show`, und
`ApplyOFNToShellDialog` liest `lpTemplateName` nirgends.

Das heisst: **die beiden Kaestchen *Kopfzeilen einschliessen* und *Absaetze
raten* fehlen seit der Portierung ganz.** Nicht seit der Behebung — seit dem
Anfang. Kein Befund, keine Meldung, kein Testlauf hat das je bemerkt, aus
demselben Grund wie beim Absturz: der Dialog wurde nie geoeffnet.

**Das ist die Probe auf diese Lehre.** Ein nie benutzter Weg hatte hier
**zwei** Maengel uebereinander — einen lauten (Absturz) und einen leisen
(fehlende Funktion). Der laute ist aufgefallen, sobald ihn jemand betrat; der
leise haette auch danach noch bleiben koennen, wenn PRUEFER nicht denselben
Weg nachgerechnet haette. Punkt 4 oben (*die Nachbarschaft mitpruefen*) ist
damit nicht mehr Vermutung, sondern gemessen.

Gefunden von PRUEFER, mit seiner Messung zitierbar — nicht von mir
nachgerechnet ([[mannschaft-fuehren]]).

## Nachtrag 12.10.2026: eine Behebung, die toten Code erreichbar macht, ist dessen erster Einsatz

**Was geschah (Zweig `an1-endungen`):** `123b218` (11:35, 7.2.0.81) behob
`MIMEMap::GetMaps`. Vorher verwarf die Funktion die ganze Zuordnungstabelle
am Registry-Typ `pkcs10` (ohne `/`). Deshalb lief `MIMEMap::SetExtension`
auf diesem Rechner **nie**, und zwar seit QUALCOMM. Mit der Behebung lief
die Funktion zum ersten Mal, und mit ihr alles, was in ihr und in ihren
Aufrufern steckte:

| Was lebendig wurde | gefunden von | wann |
|---|---|---|
| Schleife mit negativem Zähler beim Kürzen in `SetExtension` | PRÜFER-19 | vor 11:38 (`4ec9dd1`) |
| Überlauf bis 5 Byte über den Stapel: `uudecode.cpp:88`, `m_Name[255]` | **PRÜFER-20** | 11:56:21 |
| Überlauf 1–4 Byte in `m_Name[40]`: `hexbin.cpp:312`, `ImHexbin.cpp:374`; trifft den Zustand der Dekodierung | PRÜFER-20 | 11:56:21 |
| QUALCOMMs Regel „vierstellige Endung **ersetzen**": `.docx` → `.doc`, `.jpeg` → `.jpg`, nur über POP, nicht über IMAP | PRÜFER-20 | 11:56:21 |
| Versand: `.docx` geht als `application/msword` hinaus (Vergleich nur über 3 Zeichen) | PRÜFER-20 | 11:56:21 |

Um 11:51:26 hatte ich *„7.2.0.82 ist bei mir grün"* gemeldet, mit Bau,
185/185 Tests und 6/6 Prüfanhängen. Das stimmte. Gemessen hatte ich damit
aber nur den Weg, für den die Behebung gebaut war: PDF über POP. Die
Aufrufer mit eigenen kleinen Puffern (UUencode, BinHex) und die
Ersetzungsregel liegen auf Wegen, die keiner meiner Prüfanhänge berührt. Den
Verdacht hatte ich selbst. Der PRÜFER-Auftrag um 11:49 nannte `m_Name[40]`
und `attributeName[32]`. Der zweite Puffer steht allerdings in `#if 0`.
Den schwersten Fall, `uudecode.cpp` mit 255 Byte, hatte ich **nicht**
genannt. Er war nicht klein genug, um mir verdächtig vorzukommen.

Die Ersetzungsregel ist kein Fehler im Code. Sie widerspricht Gregors Ziel
vom 12.10. (*„anhänge werden korrekt gespeichert - mit erweiterung,
komplette dat[einame]"*). Sie war 20 Jahre lang Absicht und ebenso lange tot.
Dass sie mit derselben Behebung auflebte, hätte ich mit keinem Test
gefunden, denn sie *funktionierte*.

Behoben in `c8064b4` (11:58, 7.2.0.83): `SetExtension` bekommt die
Puffergröße mit und ersetzt nie.

### Why

Code, der nie lief, ist **ungeprüft**, nicht bewährt. Das gilt auch dann,
wenn er 20 Jahre alt ist und von QUALCOMM stammt. Die Behebung, die ihn
erreichbar macht, ist sein erster Einsatz. In ihm wird beides auf einmal
lebendig: die **Fehler** (Überläufe) und die **Absichten** (Ersetzungsregel).
Die Absichten sind schwerer zu finden, weil sie fehlerfrei laufen.

Die Klasse ist dieselbe wie bei
[[funktion-bringt-ihre-vorbedingung-mit]], nur umgekehrt. Dort bekam eine
bewährte Funktion einen neuen Aufrufer. Hier bekamen bestehende Aufrufer
zum ersten Mal eine laufende Funktion.

### How to apply

- **Woran man es erkennt:** Eine Behebung hebt eine Bedingung auf, die
  bisher *immer* scheiterte (`return FALSE`, leere Tabelle, `#if 0`,
  abgefangene Ausnahme, Schalter ohne Wert). Dann stellt sich die Frage:
  Was lag dahinter, und wer ruft es auf?
- **Den Umfang holt ein Befehl, nicht das Gedächtnis**
  ([[pruefumfang-nicht-von-hand]]). Gesucht wird jeder Aufrufer der jetzt
  erreichbaren Funktion, mit `grep -rn "SetExtension(" Eudora71/`. Für
  jeden Aufrufer werden Puffergröße und Weg (POP, IMAP, Versand) in eine
  Tabelle eingetragen. Was in der Tabelle keinen Prüfanhang hat, ist
  ungeprüft und wird auch so gemeldet.
- **Der PRÜFER startet mit dem Commit, nicht nach dem grünen Bau.**
  `123b218` lag um 11:35 vor, der PRÜFER startete um 11:49, nach Merge, Bau
  und Messung. Die 14 Minuten dazwischen hätte er schon rechnen können.
- **Auch die Absichten des toten Codes gegen `ZIEL.md` lesen.** Jede
  Regel, die jetzt greift (ersetzen, kürzen, umbenennen), wird gegen Gregors
  Ziel gehalten, nicht nur gegen den Speicher.
