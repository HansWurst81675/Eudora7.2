---
name: messung-muss-den-weg-treffen
description: "Ein Gegentest im falschen Betriebsmodus oder an einem Stand ohne die Aenderung beweist nichts; erst pruefen, ob der geprueste Weg ueberhaupt gelaufen ist"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-10-13T15:00:00.000Z
---

Schranke: tools/testlauf.ps1 (vor jedem Programmstart — prüft vorher, ob Eudora.exe und EudoraRes.dll dieselbe Dateiversion tragen)

# Der Test muss den Weg treffen, den er prueft

Am 07.09.2026 zweimal in einer Stunde dasselbe: eine Messung lief, lieferte ein
Ergebnis — und konnte das, was sie beweisen sollte, gar nicht erreichen.

## Fall 1: der Gegentest im falschen Betriebsmodus

Ich hatte in `tools/bauen.ps1` die Funktion `Hole-NeuesteQuelleFuer`
berichtigt, weil sie **alle** `.cpp` im Projektverzeichnis las und
`EudoraRes.dll` deshalb wegen `mainfrm.cpp` als veraltet meldete (dritter
Fehlalarm aus demselben Werkzeug). Zum Gegentest habe ich `EudoraRes.rc`
angefasst und

    tools/bauen.ps1 -Bauart Release -NurPruefen

laufen lassen. Die Schranke blieb still. Mein Schluss: *„Der Gegentest schlaegt
fehl — die Schranke ist jetzt stumm."*

Falsch. `-NurPruefen` setzt den Status auf `vorhanden` und **ueberspringt die
Aktualitaetspruefung ganz** (`tools/bauen.ps1`, um Zeile 936:
`if ($NurPruefen) { $stand = 'vorhanden' }`). Der Zweig, den ich pruefen
wollte, lief in diesem Modus nie. Entschieden hat es erst der **direkte
Aufruf** der drei geaenderten Funktionen: aus `bauen.ps1` herausgezogen, in ein
eigenes Skript gelegt und einzeln gefahren. Danach war es sauber trennbar —
`EudoraRes.rc` bewegt nur `EudoraRes.dll` (14:18:49), `mainfrm.cpp` nur
`Eudora.exe` (14:18:50).

Verraten hat es das Werkzeug selbst: in der Ausgabe stand `vorhanden`, nicht
`VERALTET` und nicht `unveraendert`. Die Statusspalte war der Beweis, dass der
geprueste Weg nicht gelaufen war — ich habe sie gelesen und nicht gesehen.

## Fall 2: die Messung an einem Stand ohne die Aenderung

Fuer E-33 (das Beenden) lagen **14, spaeter 32 Spurmarken** im Arbeitsbaum des
Agenten. Gregor hat den Log von Paket 1.0.21 geschickt — und darin stand zum
Beenden nichts. Das war kein Befund ueber das Beenden, sondern einer ueber mich:
sein Paket kennt die Marken nicht, weil sie nicht gebaut und nicht gepackt
waren. Jede Sitzung endet im Log deshalb einfach, und das haette sie mit und
ohne Ursache getan.

**Warum:** Ein Test, der den Weg nicht trifft, liefert immer dasselbe Ergebnis —
und zwar das beruhigende. Er ist damit schlimmer als kein Test: er verbraucht
Zeit, erzeugt einen Eintrag „geprueft" und deckt die Luecke zu. Im zweiten Fall
kostet er zusaetzlich Gregors Zeit, weil **er** die Messung fahren musste, die
nichts messen konnte ([[erst-pruefen-dann-anweisen]]).

**Wie anwenden:**

- **Vor der Bewertung eines Gegentests: belegen, dass der geaenderte Zweig
  gelaufen ist.** Ein Zaehler, eine Statuszeile, eine Ausgabe aus genau diesem
  Zweig. Ohne diesen Beleg ist „nichts gemeldet" kein Ergebnis.
- **Schalter und Betriebsarten sind Teil des Tests.** `-NurPruefen`,
  `--dry-run`, `Debug` gegen `Release`, „nur lesen" — jeder dieser Modi laesst
  Code weg. Der Gegentest laeuft im **gleichen** Modus wie der scharfe Lauf,
  oder er ruft die geaenderte Funktion **direkt** auf.
- **Die geaenderte Funktion direkt fahren, wenn der Weg umstritten ist.** Aus
  dem Skript herausziehen (`sed -n 'A,Ep'`), in ein Testskript legen, mit den
  echten Eingaben aufrufen. Das hat hier in zwei Anlaeufen entschieden, was
  drei Skriptlaeufe nicht entschieden haben.
- **Kein Symptom-Befund aus einem Stand ohne die Aenderung.** Bevor ich einen
  Log, ein Paket oder ein Bildschirmfoto auswerte: nachsehen, ob die Marke, der
  Fix oder die Ausgabe in **diesem** Stand ueberhaupt enthalten ist. Erst
  bauen, packen, Nummer nennen — dann messen ([[version-eindeutig-machen]]).
- **Ein falscher Test wird als falscher Test benannt**, nicht als stumme
  Schranke, und das Ergebnis gehoert in die Commit-Nachricht
  ([[schranke-gegentesten]]).

## Fall 3, 08.09.2026: derselbe Auslöser, diesmal richtig behandelt

Beim Gegentest von `tools/pruefe-beenden.pl` blieben zwei von vier Prüfungen
stumm. Der erste Gedanke wäre wieder „die Schranke greift nicht" gewesen. Statt
dessen habe ich zuerst nachgemessen, ob die **Manipulation** im Baum steht —
`grep` auf die Zeile, die ich entfernt haben wollte. Sie stand noch da: das
Suchmuster meiner Testmanipulation hatte nicht getroffen, geändert wurde
nichts. Nach dem zweiten, treffenden Anlauf waren beide Manipulationen im Baum
**und** die Schranke schwieg weiter — erst damit war belegt, dass es zwei echte
Löcher waren (`WM_CLOSE` steht auch im Protokolltext; der `default:`-Bereich
endete an der inneren Klammer, siehe [[schranke-liest-nur-code]]).

Der Ablauf, der das entschieden hat, in dieser Reihenfolge und nicht anders:
**Manipulation nachmessen → Manipulation berichtigen → Schranke bewerten.**
Wer bei Schritt drei anfängt, bekommt in beiden Richtungen ein falsches
Ergebnis: eine gute Schranke gilt als stumm, oder ein Loch gilt als kaputter
Test.

## Fall 4, 10.09.2026: die Messgroesse stammte gar nicht von dem Ereignis

Ich hatte ein Paket-ZIP versehentlich nach `C:\Users\Gregor` entpackt. Die
erste Frage war: lag dort vorher schon eine Installation, die ich gerade
ueberschrieben habe? Ich habe die **Zeitstempel** angesehen, dort stand
ueberall der 30.08., und daraus geschlossen: ja, dort lag schon etwas.

Das war falsch, und zwar nicht knapp. `Expand-Archive` **uebernimmt die
Aenderungszeit aus dem ZIP**. Nachgemessen an einer Datei, deren
Aenderungszeit ich vor dem Packen auf den 30.08. gesetzt hatte:

    LastWriteTime = 2026-08-30 10:00:00      <- aus dem ZIP
    CreationTime  = 2026-09-10 13:27:51      <- vom Auspacken
    jetzt         = 2026-09-10 13:27:51

Die Aenderungszeit kann ueber das Auspacken nichts aussagen, weil sie das
Auspacken nicht ueberlebt — sie wird davon ueberschrieben. Die **Erstellzeit**
im Dateisystem entsteht dagegen genau bei diesem Ereignis. Sie hat die Frage
dann beantwortet: 156 der 157 Dateien um 12:05 neu angelegt, dort lag
vorher nichts. Die eine Ausnahme war `Mailverzeichnis\Eudora.ini`, angelegt
um 09:21 — die einzige Datei, die ich tatsaechlich zerstoert hatte.

**Warum das hierher gehoert:** Fall 1 und 2 fragen, ob die Messung den
geprueften **Weg** trifft. Dieser Fall fragt eine Stufe frueher, ob die
gewaehlte **Groesse** von dem Ereignis erzeugt wird, nach dem ich frage. Eine
Groesse, die von woanders herkopiert wird — Zeitstempel aus einem Archiv, eine
Versionsnummer aus einer Vorlage, eine Pruefsumme aus einer Begleitdatei —
traegt keine Aussage ueber das Ereignis. Sie liefert trotzdem eine Zahl, und
zwar eine, die aussieht wie ein Beleg.

**Wie anwenden, zusaetzlich:**

- **Vor der Messung: welches Ereignis hat diese Groesse geschrieben?** Wenn
  die Antwort nicht das Ereignis ist, nach dem ich frage, ist die Groesse
  falsch gewaehlt — egal wie plausibel die Zahl aussieht.
- **Bei Dateien heisst das konkret:** `LastWriteTime` gehoert dem *Inhalt* und
  wandert mit ihm mit (Kopieren, Auspacken, Wiederherstellen).
  `CreationTime` gehoert *diesem Verzeichniseintrag* und entsteht beim
  Anlegen. Wer wissen will, wann eine Datei **hierher** kam, nimmt die
  Erstellzeit; wer wissen will, wann der Inhalt entstand, die Aenderungszeit.
- **Eine Schadensfeststellung ist eine Behauptung wie jede andere**
  ([[pruefen-statt-vermuten]]): erst die falsche Groesse, dann die falsche
  Schadensmeldung. Beide standen schon geschrieben, bevor die richtige
  Messung lief.

Siehe [[schranke-gegentesten]], [[schranke-liest-nur-code]],
[[gegenprobe-umdrehen]], [[pruefen-statt-vermuten]] und
[[widerlegte-vermutungen-aufschreiben]].

## Fall 5, 14.09.2026: die Messung traf einen Teil des Weges und wurde fuer den ganzen ausgegeben

Auf Gregors Frage zu E-86 habe ich geantwortet:

> *„Deine Frage ist beantwortet und im Befund vermerkt: **nur beim Lesen, nicht
> beim Versenden.** Der Rahmen wird ausschliesslich in `TridentView.cpp`
> gebaut; der Verfassen-Weg laeuft ueber eine andere Klasse und fasst ihn nie
> an. Die Nachricht selbst bleibt unversehrt — wer sie weiterleitet, verschickt
> sie korrekt."*

**Gemessen hatte ich genau eine Sache:** dass der HTML-Rahmen aus
`TridentView.cpp` beim Verfassen nicht gebaut wird. Das ist richtig. Daraus
folgt aber nichts ueber den Zustand der Nachricht — der Verfassen-Weg baut den
Text **neu auf**, ueber `PgCompMsgView` auf Paige-Grundlage, und dabei geht
das CSS verloren.

Widerlegt hat es Gregor am selben Tag, und zwar am Empfaenger: er hat die
weitergeleitete Nachricht dort geoeffnet — *„kommt auch so an."* Damit war es
kein Anzeigefehler im Verfassenfenster, sondern die Formatierung ist beim
Verschicken tatsaechlich weg. Der Befund E-88 entstand daraus.

**Warum das hierher gehoert und nicht zu [[widerlegte-vermutungen-aufschreiben]]:**
Es war keine Vermutung. Es war eine **Messung**, und sie war korrekt — sie hat
nur einen **Abschnitt** des Weges getroffen und wurde fuer den ganzen Weg
ausgegeben. Die Faelle 1 und 2 fragen, ob die Messung den geprueften Weg
ueberhaupt erreicht; Fall 4 fragt, ob die gewaehlte Groesse von dem gesuchten
Ereignis stammt; dieser Fall fragt, **wie weit** die Messung reicht.

Am selben Tag derselbe Griff ein zweites Mal: auf Gregors *„du hast deine tools
immer noch nciht im griff"* habe ich einen gemeinsamen Nenner genannt, der
einen von vier Faellen deckt ([[verwerfen-nur-mit-zaehler]]).

**Wie anwenden, zusaetzlich:**

- **Eine Aussage darf nicht weiter reichen als die Messung.** Gemessen wurde
  „`TridentView.cpp` wird beim Verfassen nicht aufgerufen"; das ist auch der
  Satz, der gesagt werden darf. *„Wer sie weiterleitet, verschickt sie
  korrekt"* ist eine Aussage ueber einen Weg, der nie gemessen wurde.
- **Vor jedem „betrifft nur X" wird der Weg aufgezaehlt.** Lesen, Verfassen,
  Speichern, Versenden, Empfangen sind fuenf Abschnitte. Ein Satz ueber „den
  ganzen Weg" braucht fuer jeden Abschnitt eine Messung oder ein ausdrueckliches
  *„nicht geprueft"*.
- **Die billigste Messung des Versandwegs ist der Empfaenger.** Gregor hat sie
  in einem Satz geliefert, nachdem ich sie zwei Antworten lang nicht gefahren
  hatte ([[erst-pruefen-dann-anweisen]]).

## Fall 6, 12.10.2026: der Lauf war erfolgreich und hat nichts gemessen

Erster Messlauf an 7.2.0.79 (Transkript `7cea137a-…jsonl`, 11:10:47):

    testlauf.ps1 -Verzeichnis C:\Temp\AN1 -Freigabe "…" -Sekunden 60

Beschrieben als *„Eudora im Testverzeichnis 60 Sekunden laufen lassen"*.
`-Sekunden` ist aber die **Frist, in der das Hauptfenster erscheinen muss**
(`testlauf.ps1:215`), nicht die Laufzeit. Ohne `-MessenSkript` schickt das
Skript `WM_CLOSE`, sobald das Fenster steht. Ausgabe: *„Zeit vom WM_CLOSE bis
zum Ende: 1 s — Beendet: True"*. Sechs Sekunden nach dem Aufruf war alles
vorbei, `In.mbx` leer, der POP-Server ohne Zugriff. Der zweite Lauf
(11:11:52) mit einem `-MessenSkript`, das `ID_FILE_CHECKMAIL` schickt, rief
ab.

Gekostet hat es nur eine Minute, weil die Messgröße (`In.mbx`) sofort gelesen
wurde. Aber die Ausgabe des ersten Laufs sah aus wie Erfolg — und der Kopf
von `testlauf.ps1` sagt selbst *„Der Lauf hat eine Hoechstdauer"*, was die
falsche Lesart nahelegt.

## Fall 7, 18.09. und 12.10.2026: das Modell hat bestanden, das Programm nicht

Zweimal derselbe Griff wie in Fall 5, diesmal mit einem **Prüfmodell** statt
einer Teilmessung:

- **AN-1, B5.3:** `kopfzeile-pruefen.pl` meldete *„304 Zeichen mit .pdf statt
  254 ohne"*. Am Programm kam derselbe Fall als 224 × `A` **ohne** `.pdf` an.
  Das Modell bildet den Zerleger (`Lex822`) nach; gekappt wurde **dahinter** —
  `strncpy` auf 259 in `mime.cpp` und `DeMacifyName32` auf 255
  (`ca8da5a`). Der gemessene Abschnitt war heil, der Weg nicht.
- **E-112:** 185 Tests grün, die Gegenprobe fiel richtig um — und am
  Programm war es schlechter als vorher. Getestet war die Regel, nach der
  `pict_frame` gesetzt wird; ob Paige das Rechteck zum Skalieren benutzt,
  stand in `draw_meta_file` (`PGEMBED.C:4085-4125`) und war **nein** bei
  `MM_TEXT`.

**Wie anwenden, zusätzlich:**

- **Ein Lauf ohne Messgröße ist kein Messlauf.** Vor dem Start steht fest,
  welcher Wert danach gelesen wird (hier: `In.mbx`, `attach\`, `ANHANG`-Zeilen
  im Log). `testlauf.ps1` ohne `-MessenSkript` startet und schließt — mehr
  nicht.
- **Ein Prüfmodell sagt, wie weit es reicht.** Neben *„gemessen mit
  kopfzeile-pruefen.pl"* steht, **welche Funktion** es nachbildet, und der
  Rest des Weges als *„nicht geprüft"* — Zerlegen, Namensbildung, Bereinigen,
  Schreiben sind vier Abschnitte, das Modell traf einen.

**Offen:** `testlauf.ps1` sollte ohne `-MessenSkript` ausdrücklich melden
*„nichts gemessen — nur gestartet und geschlossen"*, und der Kopf sollte
`-Sekunden` als Frist bis zum Hauptfenster beschreiben. Nicht geändert —
Werkzeuge sind nicht Sache des CHRONIST.

## Fall 8, 12.10.2026: die Funktion war grün, der Zerleger davor nicht

**Was geschah (E-94):** Der Kern `6b4b14c` (13:43) hat `Fix2047` und
`ImapFix2047` berichtigt. Die zwei neuen Tests gingen von rot auf grün,
Testsuite 188/188. Um 13:44:20 habe ich Gregor gefragt: *„Der IMAP-Weg (dein
Fall) ist mit dem Kern behoben und per Test grün. Wie soll ich mit dem
POP-Weg weitermachen?“* Gemessen hatten die Tests aber nur die **Funktion**,
und zwar ihre wörtliche Abschrift. Sie bekommt dort die ganze Kopfzeile auf
einmal. Wer ihr die Zeilen im Programm zuführt, haben die Tests nicht
geprüft.

**Gefunden hat es das laufende Programm.** Prüfnachricht 06 lief um 13:41 an
7.2.0.83, also **vor** der Behebung. Ergebnis: In `In.mbx` stand der Betreff
mit Faltungen mitten im Wort, und die Postfachliste zeigte nur *„Pruefung
E-94: Waren bestel“*. Die Liste liest nur die erste Zeile einer gefalteten
Kopfzeile (`summary.cpp`). Die Commit-Nachricht des Kerns sagt bereits:
*„dort greift dieser Kern allein NICHT“*. `f1793e1` (13:55) hält dann fest:
*„LexFill holt die Kopfzeile zeilenweise, Fix2047 sieht also nie beide Wörter
zugleich – der Kern aus 6b4b14c heilt allein nur die Felder aus der ganzen
Kopfzeile (ImapDownload.cpp:2276).“* Die Behebung musste deshalb in
**beide** Zerleger, `lex822.*` **und** `ImapLex822.*`. Die Aussage „IMAP
behoben“ reichte also weiter als die Messung. Sie war richtig für die Felder,
die über `ImapDownload.cpp:2276` laufen, und unbelegt für das, was der
IMAP-Zerleger in die Mailbox schreibt. Auch nach `a013f08` gilt: Die
Testsuite prüft die Zerleger nicht (*„die Zerleger selbst prüft sie nicht –
das tut Prüfnachricht 06 am laufenden Programm“*). Gemessen ist der Weg über
den Prüfstand. Ein eigener IMAP-Abruf an 7.2.0.84 steht in keinem Commit.

**Verwandt mit Fall 5:** Es ist dieselbe Frage, *wie weit die Messung
reicht*. Hier liegt die Grenze aber nicht zwischen Lesen und Versenden,
sondern zwischen einer Funktion und ihrem Aufrufer.

**Wie anwenden, zusätzlich:**

- **Ein grüner Funktionstest sagt „die Funktion tut es“, nicht „der Weg tut
  es“.** Vor „behoben“ wird aufgezählt, wer die Funktion womit aufruft: ganze
  Kopfzeile oder Zeile für Zeile, Mailbox, Inhaltsverzeichnis, Postfachliste.
  Zu jedem Glied gehört eine Messung oder ein ausdrückliches *„nicht
  geprüft“*.
- **Die Messung am alten Stand gehört vor die Behebung.** Prüfnachricht 06 an
  7.2.0.83 hat in einem Lauf zwei Dinge gezeigt, die kein Test gesehen hatte:
  den zeilenweisen Zerleger und die abgeschnittene Liste. Danach war „ein
  Paket für POP und IMAP“ eine belegte Entscheidung (Gregor, 13:49).
- **In einer Frage an Gregor steht nur, was gemessen ist.** „Per Test grün“
  ist wahr. „Dein Fall ist behoben“ wäre erst mit seiner Nachricht am
  laufenden Programm wahr ([[erfolg-aus-anwendersicht]]).

## Fall 9, 13.10.2026: der Regeltest war grün, am Ladeweg stand die Angabe woanders

Gregor um 09:24 UTC: *„ja, F2 so einbauen wie im browser"*. Gemeint war:
steht im HTML nur die Breite, wird die Höhe aus dem Seitenverhältnis
berechnet. Die Regel bekam erst rote, dann grüne Tests (09:28). Am laufenden
Programm (09:45) kam `<img width=150>` trotzdem als `angegeben=0x0` an und
wurde in Dateigröße 985x378 gezeichnet. Am Ladeweg in `PgEmbeddedImage.cpp`
ist `embed->width/height` bei einer halben Angabe **noch 0**. Die Angabe steht
dort in `source_width/height` aus dem HTML-Import. Die getestete Regel bekam
also nie, was sie rechnen sollte. Nach der Umstellung (09:46) zeigte die
Messung `angegeben=150x0 ... gemalt=150x58`.

Das Besondere daran: **PRÜFER-22 hatte es vorhergesagt.** Seine Zeile zu F2
nannte `PgEmbeddedImage.cpp:384-392, 549-552, 584-594`, also genau die
Ladestelle. Die Regel wurde trotzdem nur als Funktion getestet. Es ist
derselbe Fehler wie Fall 8, einen Tag später, nur an einer anderen
Schnittstelle: dort der Zerleger vor der Funktion, hier das Feld, aus dem der
Aufrufer liest.

**Wie anwenden, zusätzlich:**

- **Zu einer Regel mit Eingabewerten gehört die Frage, woher der Aufrufer
  die Werte nimmt**, und zwar am Ort des Aufrufs, nicht in der
  Funktionssignatur. Eine Spurmarke, die die *Eingabe* der Regel am
  laufenden Programm ausgibt (`angegeben=…`), hätte es im ersten Lauf
  gezeigt. Hier hat sie es gezeigt, weil sie schon da war
  ([[eingebaute-messung-auslesen]]).
- **Nennt ein PRÜFER-Fund Zeilen am Aufrufweg, gehört genau dieser Weg in
  die Messung**, nicht nur die Regel.
- Was keine Wirkung hatte, weil die Datei gar nicht gebaut wird, steht in
  [[quelle-muss-im-bau-stehen]] (F1, derselbe Vormittag).
- Eine Stunde später derselbe Fehler noch einmal, bei PRÜFER-23 N1 (die
  Gegenrichtung stand im Abschnitt). Daraus wurde [[fund-ganz-abhaken]] mit
  dem Werkzeug `tools/fund-punkte.pl`, das jeden genannten Ort eines Fundes
  als Liste ausgibt.

## Fall 10, 13.10.2026: das Programm hat den Prüfstand zwischen zwei Läufen zurückgeschrieben

Nachgestellt wurde [E-115](../BEFUNDE.md#e-115) („Encountered an improper argument“ nach Ctrl+F), an einer Kopie von Gregors Mailverzeichnis in `C:\Temp\E115-gregor`. Der Fehler kommt nur, wenn Ctrl+F das Fenster *Find Messages* **neu öffnet**. Ist es schon offen, holt Ctrl+F es nur nach vorn, und es passiert nichts.

| Zeit (UTC) | Lauf | Startliste `[Open Windows]` | Ergebnis | gültig? |
|---|---|---|---|---|
| 10:48:49 | 7.2.0.84 (Fehler erwartet) | `OpenWindow3=39,3` (*Find Messages*) | `Meldungsfenster: ''` | **nein**, erkannt um 10:49:01 an `titel='Find Messages'` bei 0.02 s im Protokoll |
| 10:51:39 | 7.2.0.84, Zeile 39 entfernt | ohne 39 | Meldung kommt („ja, treffer!“) | ja |
| 10:53:41 | 7.2.0.86 (Behebung) | **wieder** `OpenWindow3=39,3` | `Meldungsfenster: ''` | **nein**, aber das sah genau wie der erwartete Erfolg aus |
| 10:54:28 | 7.2.0.86, Zeile 39 wieder entfernt | ohne 39 | keine Meldung, `titel='Find Messages'` bei 0.13 s, nach dem Ctrl+F | ja |

Eudora schreibt `[Open Windows]` **beim Beenden** neu. Der Lauf um 10:51, der *Find Messages* geöffnet hatte, setzte es dadurch für den nächsten Lauf wieder auf die Startliste. Der Lauf um 10:53 lieferte das erhoffte Bild: neue Fassung, keine Meldung. Erst der Blick ins Protokoll, *wann* das Fenster aufging (10:53:50), zeigte, dass der Auslöser gar nicht gelaufen war. Zwischen dem ungültigen Lauf und seiner Entdeckung lagen neun Sekunden und kein Satz an Gregor. Wäre das Ergebnis vor diesem Nachsehen gemeldet worden, wäre ein ungültiger Lauf als Beleg hinausgegangen.

Gegenprobe beim CHRONIST-Lauf (≈15:00 UTC): `testlauf.ps1 -NurPruefen` an derselben Kopie meldet `OpenWindow3=39,1`. Nach dem gültigen Lauf von 10:54 steht die Zeile also schon wieder drin. Der nächste E-115-Lauf wäre ohne Eingriff wieder ungültig.

**Vermutung, nicht gemessen:** Auch die beiden Vormittagsläufe in `E115-gregor` (Debugger, „keine C++-Ausnahme“) könnten an der Startliste gescheitert sein. Um 10:42:45 stand `OpenWindow3=39,3` in der Kopie, und ob die Zeile schon beim Kopieren drin war, ist nicht festgehalten. Die damalige Folgerung „hängt an Online-Betrieb oder IMAP-Abgleich“ ist dadurch nicht widerlegt, aber auch nicht gestützt.

**Why:** Ein Prüfstand, den das geprüfte Programm selbst beschreibt, ist nach jedem Lauf ein anderer. Eine Vorbedingung, die einmal hergestellt wurde, gilt nur für einen Lauf. Und „kein Fehler“ ist das Ergebnis, das sowohl die Behebung als auch der nicht gelaufene Auslöser liefert.

**How to apply:**

- **„Kein Fehler“ aus einem Nachstelllauf zählt nur mit dem Protokollbeleg, dass der Auslöser lief**, hier `titel='Find Messages'` *nach* dem Zeitpunkt des Ctrl+F. Diese Zeile gehört in dieselbe Meldung wie das Ergebnis ([[zwei-werte-in-eine-ausgabe]]).
- **Vorbedingungen, die das Programm beim Beenden zurückschreibt, werden vor jedem Lauf neu hergestellt**, nicht einmal am Anfang einer Serie. Bei Eudora sind das mindestens `[Open Windows]` und die Fensterlagen in `Eudora.ini`.
- **Werkzeug:** `tools/testlauf.ps1` gibt seit diesem Lauf die Startliste `[Open Windows]` vor jedem Start aus, auch mit `-NurPruefen`. Abweisen kann es nicht: welches Fenster für welchen Befund stört, weiß nur der Lauf ([[schranke-gehoert-in-den-haken]]: Hinweise dürfen nicht abweisen).

## Fall 11, 21.10.2026: die Vorhersage nannte ihre Vorbedingung, die Messung stellte sie nicht her

[PRÜFER-43 K9](../Befunde/PRUEFER-43.md#k9) sagte für `OnRightButtonDown`
(`nicktree.cpp:2941`) denselben Fehlerfall voraus wie
[E-134](../BEFUNDE.md#e-134) — Rechtsklick wähle nicht aus, das Kontextmenü
bleibe ausgegraut. Der Bericht nannte die **Vorbedingung** wörtlich:

> *„Erreichbar: erst mit der rechten Maustaste in den leeren Bereich unter
> die Einträge klicken (der `else`-Zweig räumt ab, … die Karette bleibt aber
> stehen), dann **denselben** Eintrag rechts anklicken."*

Gemessen wurde mit `tools/messen-k9.ps1` an fünf Klickhöhen
(`y = 10, 26, 42, 58, 74`, `x = 60`) je Fassung. Das Ergebnis: **beide**
Fassungen melden danach genau ein ausgewähltes Kind, die Wirkung tritt nicht
ein. Daraus wurde *„am laufenden Programm nicht nachstellbar"*.

**Nachgezählt am Skript und am Prüfstand:** `C:\Temp\E135-box` enthält
**fünf** Kurznamen, die Zeilenhöhe ist 16 Pixel — die fünf Klickhöhen
treffen die fünf Einträge. Es gibt **keinen** Klick in den leeren Bereich und
**keinen** zweiten Klick auf dasselbe Element. Beide Teile der Vorbedingung
fehlen. Die Begründung im Commit sagt es selbst: *„beim Klick auf ein
**anderes** Element wandert die Karette, und dann setzt `SelectItem()`
`TVIS_SELECTED` sehr wohl."* Das ist die Beschreibung eines Laufs, der an der
Vorbedingung vorbeigeht.

Richtig behandelt wurde die Folge: die Zeile `DoSelectItem(tvhit.hItem, TRUE)`
steht in 7.2.0.120 ausdrücklich als **Sicherung, nicht als gemessene
Behebung**, und das steht in der Commit-Nachricht und in
[E-135](../BEFUNDE.md#e-135) ([[widerlegte-vermutungen-aufschreiben]],
[[ursache-nur-gemessen-behaupten]]). Falsch ist nur das **Urteil über die
Messung**: *„nicht nachstellbar"* behauptet, der Versuch sei gelaufen.
Gelaufen ist ein anderer Versuch.

**Why:** Ein Prüfbericht ist eine **Vermutung mit Fundstelle**. Wenn er seine
Vorbedingung mitliefert, ist sie Teil des Messaufbaus und nicht Zierat. Eine
Messung, die sie nicht herstellt, liefert zuverlässig das beruhigende
Ergebnis — und ein beruhigendes Ergebnis schließt den Fund.

**How to apply:**

- **Die Vorbedingung aus dem Bericht wird abgeschrieben, bevor das Messskript
  entsteht**, Satz für Satz, und jeder Satz bekommt im Skript eine Zeile. Hier
  wären es zwei gewesen: ein Rechtsklick unterhalb des letzten Eintrags, dann
  ein zweiter auf **dasselbe** Element.
- **Die hergestellte Lage wird ausgegeben, nicht angenommen.** Vor dem
  entscheidenden Klick gehört der gelesene Zustand in die Ausgabe — hier
  Karette (`TVGN_CARET`) und `TVIS_SELECTED` desselben Elements in **einer**
  Zeile ([[zwei-werte-in-eine-ausgabe]]). Dann wäre sichtbar gewesen, dass
  die Lage „Karette ja, ausgewählt nein" nie eintrat.
- **Wortwahl im Befund:** *„nicht nachstellbar"* nur, wenn die Vorbedingung
  belegt hergestellt wurde. Sonst heißt es *„nicht gemessen — die
  Vorbedingung X wurde im Messlauf nicht hergestellt"*.

## Nachtrag 28.10.2026 (CHRONIST), Fall 12: das Messskript klickte, der Assistent speicherte nichts

Zeiten MEZ, E-166 am Prüfstand `C:\Temp\E166`, gemessen an Transkript `72be6093…` und `tools/TESTLAEUFE.md`.

| Zeit | Was | Weg getroffen? | erkannt |
|---|---|---|---|
| 13:32:58 | Lauf mit relativem `-File tools\testlauf.ps1` im PowerShell-Werkzeug | nein, Eudora startete gar nicht. Die gefilterte Ausgabe zeigte die Zeilen 247–288 der `eudora.log` eines **früheren** Laufs | 13:33:06 mit `-NurPruefen` ([[gekuerzte-ausgabe-ist-kein-ergebnis]]) |
| 13:33:38 | „Weiter“ im Konto-Assistenten als `PSM_PRESSBUTTON`, eingetragen als `0x0470` | nein, der Assistent blieb auf Seite 1 | 13:34:09, „berichtigt“ auf `0x046F` |
| 13:34:18 | derselbe Lauf mit `0x046F` | nein, wieder Seite 1 | 13:34:47: Wechsel auf `WM_COMMAND`, im Skript steht seither *„PSM_PRESSBUTTON wirkte am 28.10. nicht“* |
| 13:34:54–13:36:36 | `WM_COMMAND` mit `ID_WIZNEXT`/`ID_WIZFINISH`, `lParam` = 0 | halb: Die Seiten wechselten, aber `CPropertySheet::OnCommand` (MFC `dlgprop.cpp`) übernimmt das Ergebnis nur, wenn `lParam` das Knopf-Handle trägt. `DoModal` lieferte 0, und der Assistent speicherte nichts | 13:36:40: *„Auch mit dem vollständig durchgefahrenen Assistenten bleibt die Antwort erhalten (`AskedAboutJunk=6`). Auffällig ist aber, dass kein Konto in der INI steht.“* Ursache 13:37:32 |
| 14:11:52, 14:12:51, 14:13:47 | Lauf 9 am neuen Bau mit `E166_KONTO=1` | nein: *„Persoenlichkeiten-Ansicht: 0 neue Liste(n)“*. Der Konto-Schritt fiel still aus, in der INI stand `AskedAboutJunk=6`, also „grün“ | jedes Mal an `reihenfolge=junk-no` ohne `konto-ok` |

**Neu gemessen (belegt am SDK-Kopf):** `PSM_PRESSBUTTON` ist `WM_USER + 113` = **`0x0471`** (`Windows Kits\10\Include\10.0.22621.0\um\prsht.h:718`). `0x0470` ist `PSM_SETWIZBUTTONS` (`:700`), `0x046F` ist `PSM_SETTITLEA` (`:686`). Beide Werte waren falsch, und die „Berichtigung“ ging in die falsche Richtung. Der Satz im Skript, `PSM_PRESSBUTTON` habe nicht gewirkt, ist eine widerlegte Aussage: Die Botschaft wurde nie geschickt. `BEFUNDE.md` E-166 sagt nur *„`PSM_PRESSBUTTON` falsch beziffert“*, und das stimmt.

**Gegriffen haben** zwei Dinge: der Ausreißer „kein Konto in der INI“ ([[ausreisser-ist-der-befund]]) und die Zeile `reihenfolge=`, die jeden ausgeführten Schritt aufzählt. Ohne sie hätten drei grüne Läufe am neuen Bau eine Behebung bestätigt, deren Auslöser (*Konto → Eigenschaften* mit OK) gar nicht lief. Der Satz um 13:36:40 nannte aber zuerst das Ergebnis und dann den Ausreißer. Richtig ist die umgekehrte Reihenfolge. In `BEFUNDE.md` E-166 steht *„Zwei Messläufe am neuen Bau zählten nicht“*. Gezählt sind es **drei** (14:11:52, 14:12:51, 14:13:47, alle mit *„0 neue Liste(n)“*).

**Zum Wiederverwenden:** Der Regressionsfall E-166a prüft den Weg (`reihenfolge=junk-no,konto-ok`), E-166b danach das Ergebnis (`AskedAboutJunk=6`). An Paket 1.0.127 war E-166a grün und E-166b rot (14:19:01). So sieht eine Gegenprobe aus, die nicht aus dem falschen Grund rot werden kann.

**How to apply, zusätzlich:**
- Jedes Messskript gibt eine Zeile aus, die jeden **ausgeführten** Schritt nennt, und der Fall prüft diese Zeile vor dem Ergebnis. Ein Schritt, der sein Fenster nicht findet, bricht den Lauf mit einer `FEHL`-Zeile ab, statt still weiterzulaufen.
- Eine Fensterbotschaft wird aus dem SDK-Kopf beziffert (`grep -rn "define PSM_PRESSBUTTON" "…/Windows Kits/10/Include"`), nie aus dem Gedächtnis. Wirkt eine Botschaft nicht, wird zuerst ihr Wert gegen den Kopf geprüft, bevor sie für unwirksam erklärt wird.
- Knopfbefehle als `WM_COMMAND` tragen das gemessene Knopf-Handle im `lParam` ([[keine-tastendruecke-verschicken]]).

## Nachtrag 01.11.2026 (CHRONIST), Fall 13: die Gegenprobe im Zweig, den kein Test nimmt

Transkript `6f848773…`, Zeiten MEZ, gemessen.

Die neue Schranke in `TinyTest.cpp` (ein Test ohne `TT_EndTest` wird rot) sollte gegengeprobt werden. Um 10:26:54 entfernte die Hauptsitzung einen `TT_EndTest` aus `TestE171.cpp`, und der Lauf blieb grün. Zwei Deutungen folgten in 54 Sekunden:

1. **10:27:16** *„Gegenprobe ist **blind**: `EudoraTests.exe` stammt von 10:26, also vor meiner Änderung — `pruefe-tests-gruen.pl` hat nicht neu gebaut.“* Das war falsch. **10:27:48** *„Die Uhr steht erst bei 10:27 — die Exe war also doch frisch.“* Die Dateizeit war mit einer geschätzten Uhrzeit verglichen worden, nicht mit einer abgelesenen ([[zwei-werte-in-eine-ausgabe]]).
2. **10:27:52** *„der entfernte Aufruf lag im nicht genommenen Fehlerzweig.“* Das stimmte. Der Test lief am Hauptweg mit seinem zweiten `TT_EndTest` sauber zu Ende. Die Gegenprobe am Hauptweg (Zeile 39) ergab 349/1, Rückgabe 1.

Dieselbe Falle hatte der Vorabend in größerem Maßstab: Von den 17 `TT_EndTest`, die `c458c74d` ergänzte, liegen acht in Fehlerzweigen, die ein grüner Lauf nie betritt ([[pruefstand-kann-blind-sein]], Nachtrag 01.11.).

**How to apply, zusätzlich:**
- Den Fehler für eine Gegenprobe an der Stelle einsetzen, die der Lauf **nachweislich** durchläuft. Im Zweifel vorher eine Spurzeile an der Stelle ausgeben lassen.
- Vergleicht man eine Dateizeit mit „jetzt“, dann gehören `date` und `ls -l` in dieselbe Ausgabe. Eine Uhrzeit aus dem Kopf ist keine Messung, und die Uhr dieser VM ging am 31.10. rund 20 Stunden nach ([[entscheidung-pruefstand-fenster-31-10]]).

## Nachtrag 01.11.2026 nachts (CHRONIST), Fall 14: rot aus dem falschen Grund, und die Zahl hätte es verraten

Transkript `6f848773…`, Zeiten MEZ; `Befunde/PRUEFER-78.md` K7, gemessen ([[CHRONIST-2026-11-01e]]).

Für E-184 K3 (mehrere Mails, neue UIDs nach Listenposition zugeordnet) meldete die Hauptsitzung um 19:22:01 **„Rot nachgestellt: Unter UID 1 steht der Betreff von Mail 3, und Mail 1 fehlt ganz (`richtig=2 falsch=1`)“** am Bau `6e9a43ba` ohne K3-Behebung. Das ging so in Commit `2fd14adc` und in BEFUNDE E-184.

PRÜFER-78 K7 (Rücklauf 20:02:52) rechnete nach: Eine Vertauschung von drei Einträgen hat 0, 1 oder 3 Fixpunkte, **nie 2**. `richtig=2 falsch=1` kann die geprüfte Zuordnung also gar nicht erzeugen. Rot war der Lauf, weil der Prüfserver `COPYUID` als **Liste** meldete (`1,2,3`) und der alte Leser `UIDStringToUIDs` aus einer Liste per `atoi` nur die erste Zahl nimmt. Der K3-Mechanismus selbst war am Prüfstand nie rot gewesen. Echte Server melden zusammenhängende UIDs als Bereich (`1:3`), und genau den versteht der alte Leser.

Behoben in `c0f70c11` (20:18:41): Der Prüfserver fasst zu Bereichen zusammen, der Fall verlangt `anfrage=3,2,1 copyuid=1:3/1:3` in der Ergebniszeile. Neu gemessen am alten Bau `richtig=1 falsch=2` (über Kreuz: alte UID 3 bekommt die neue 1, alte 1 die neue 3, nur die mittlere stimmt), mit Behebung `richtig=3 falsch=0`. PRÜFER-79 hat die Trennschärfe nachgerechnet.

**Was zurückfiel:** Regel 1 dieser Lehre (*„erst prüfen, ob der geprüfte Weg überhaupt gelaufen ist“*) und [[ausreisser-ist-der-befund]]: Die rote Zahl wurde als Bestätigung gelesen, ohne zu fragen, ob der vermutete Mechanismus sie überhaupt liefern kann. Die Messung war ehrlich, der Satz darüber nicht.

**How to apply, zusätzlich:**
- Vor dem Satz „rot nachgestellt“ rechne ich aus, **welchen** roten Wert der vermutete Fehler liefert, und schreibe ihn vor dem Lauf in die Sollzeile der Gegenprobe. Kommt ein anderer roter Wert, ist das ein zweiter Fehler oder ein Prüfstandsfehler, keine Bestätigung.
- Die Ergebniszeile trägt neben dem Ergebnis den Weg (`anfrage=`, `copyuid=`), so wie `reihenfolge=` bei Fall 12.
