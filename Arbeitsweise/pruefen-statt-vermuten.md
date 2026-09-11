---
name: pruefen-statt-vermuten
description: "Vorhandene Quellen oeffnen, bevor ich eine Ursache vermute - und Vermutungen nie als Tatsache aussprechen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-05T17:51:39.000Z
---

Schranke: keine - ob ich vor einer Aussage die Quelle geöffnet habe, ist im Repo nicht sichtbar; stehen bleibt nur die Aussage, nicht ihr Weg

Bevor ich eine Ursache benenne, die vorhandene Quelle oeffnen. Wenn ich trotzdem
vermute, die Vermutung als solche kennzeichnen und dazusagen, worauf sie sich
stuetzt.

**Why:** Das ist meine haeufigste Fehlerklasse in diesem Projekt. Am 28.08.2026
dreimal derselbe Ablauf:

1. Ein `cmd /c`-Aufruf haengte. Ich vermutete ein langsames MSYS-Perl und lud
   unnoetig 300 MB Strawberry Perl. Ursache war eine interaktive Eingabe-
   aufforderung. (Siehe [[haengende-kommandos-abbrechen]].)
2. Die neue QCSSL.dll brachte keine sichtbare Verbesserung. Ich spekulierte ueber
   den Grund, statt das von Gregor geschickte `hermesSSL.zip` zu oeffnen. Darin
   stand die Antwort: HermesSSL 7.8 gamma mit OpenSSL 1.0.2p, also laengst TLS 1.2.
3. Commits im Repo kamen mir fremd vor. Ich behauptete als **Tatsache**, es laufe
   eine zweite Claude-Sitzung parallel. `git reflog` zeigte eine einzige
   durchgehende Kette in einem einzigen Arbeitsverzeichnis - es waren meine
   eigenen Commits aus einer zusammengefassten Sitzungshaelfte.

Gregor musste jedes Mal korrigieren. Beim dritten Mal zu Recht deutlich: die
Regel stand schon in der Ablage und ich habe sie ignoriert.

**Zahlen sind Vermutungen, bis sie gemessen sind.** Die Doku-Pruefung vom
29.08.2026 hat in README, PLAN.md und PORTIERUNG.md acht falsche Werte gefunden,
die ich alle als Tatsachen hingeschrieben hatte: "16 von 18 Projekten bauen" (es
sind 15), "19 Zertifikate von 1996-1998" (Zeitraum 1994-2000), "39 beruehrte
.cpp-Dateien" (42), "52 SEC-Bezeichner" (Zaehlweise unbrauchbar), `afxext.h:269`
(268), zwei `rootcerts.p7b` mit verschiedener SHA256 als eine beschrieben. Also:
keine Zahl ohne den Befehl, der sie erzeugt hat - und den Befehl daneben schreiben,
damit der naechste sie nachrechnen kann statt sie zu glauben.

**Auch ueber mich selbst nicht raten.** Am 28.08.2026 habe ich Gregors eigenen
Arbeitsstand als "deine patch2-Version" bezeichnet - der Patch war meiner. Und am
29.08.2026 habe ich mir einen Fehler eingeraeumt, den der Mitschnitt so nicht
hergibt (siehe [[wissen-gehoert-in-dateien]]). Urheberschaft und Selbstvorwurf
gehoeren genauso belegt wie eine technische Ursache.

**How to apply:** Angehaengte Pfade, Links und Archive sofort oeffnen, auch wenn
sie beilaeufig erwaehnt werden - Gregors Material schlaegt meine Hypothese. Bei
unklarer Repo-Historie `git reflog` und `git worktree list`, bei haengenden
Prozessen die tatsaechliche Ausgabe. Und beim Formulieren: "ich vermute, weil X"
statt "es ist so". Kostet eine Zeile und macht eine fehlende Quelle sofort
sichtbar.

---

## Nachtrag 05.09.2026 - warum die Regel trotzdem nicht griff

Gregor: *„gemessen statt geglaubt - das sollte ja bereits gelten! schon seit
langem. warum immer noch fehlerhaft?"*

Er hat recht, und die Antwort ist unangenehm einfach: ich habe die Regel auf
**fremde Behauptungen** angewendet und nicht auf **mein eigenes Handeln**. Die
Befunde dieser Sitzung sind sauber gemessen (D3a widerlegt, R-1 nachgerechnet,
801 CRLF-Dateien belegt). Meine eigenen Handgriffe nicht - fuenfmal:

| Handgriff | Was danebenlag und nicht angesehen wurde |
|---|---|
| „mein Rebuild hat `OTA50R.lib` zerstoert" | die Zeitstempel - unveraendert vom 31.08. Die Datei hat nie existiert. |
| Debug/Release mit `strings` erkannt | 10,2 MB gegen 2,9 MB, direkt in derselben Ausgabe |
| DLL-Namen aus Binaerdateien gegrept | `s.dll`, `ts.dll` im Ergebnis - sichtbare Bruchstuecke |
| zwei Agenten in einen Arbeitsbaum | `git worktree list`, ein Befehl |
| „schliess Eudora, dann tausche ich" | dass genau das Schliessen abstuerzt - eben gezeigt bekommen |

**Der Grundsatz feuert nicht. Ein Handgriff feuert.** Wo dieses Projekt eine
echte Schranke gebaut hat (`pruefe-bytes.pl` gegen Zeilenenden), ist die
Fehlerklasse weg; wo es beim Merksatz blieb, kommt sie wieder.

**Deshalb, an genau diesen vier Punkten, vor dem Handeln statt nach dem Reden:**

1. **Vor einem Befehl, der loeschen kann** (`Rebuild`, `Clean`, `reset --hard`,
   `checkout -B`, Ueberschreiben): erst auflisten, was er anfassen wird, und
   pruefen, ob davon etwas nicht wiederherstellbar ist. `git status` und
   Zeitstempel **vorher**, nicht hinterher zur Schadensdeutung.
2. **Nach jeder Textersetzung** (perl `s///`, besonders ueber Zeilengrenzen):
   das Ergebnis zurueckelesen und ansehen. Am 05.09. ist mir derselbe
   Zeichenketten-Literal zweimal zerbrochen; beide Male nur aufgefallen, weil
   ich zufaellig ausgegeben habe.
3. **Vor jeder Agentenzuteilung:** `git worktree list`. Siehe
   [[agenten-koordinieren]].
4. **Wenn eine Messung einem offensichtlichen Signal widerspricht** - eine
   4-MB-Datei neben einer 10-MB-Datei, beide angeblich gleich gebaut - ist die
   **Messmethode** verdaechtig, nicht das Signal. Dann die Methode wechseln,
   nicht das Ergebnis glauben.

Und fuer die Selbstbeschuldigung eigens: sie ist genauso eine Behauptung wie
jede andere. „Ich habe X kaputtgemacht" gehoert belegt, bevor ich es sage -
sonst steht am Ende eine falsche Ursache in der README, und der echte Mangel
bleibt unentdeckt.

---

## Nachtrag 10.09.2026 - die Quelle stand fuenf Zeilen ueber meinem Einbau

Befund E-70: die Fenstergroessen ueberleben keinen Neustart. Ich habe das
Laden der Groessen in `SECToolBarManager::LoadState` eingebaut
(`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:4379`) und vier Fassungen lang
gemessen, warum nichts geladen wird.

Ueber der Funktion steht, seit dem Tag der Portierung und von mir selbst
geschrieben:

    // KATEGORIE C laut PLAN.md: Eudora ruft diese Fassung nie auf.
    // QCToolBarManager::QCLoadState ... ist die Ersatzfassung
    void SECToolBarManager::LoadState(LPCTSTR lpszProfileName)

Zeile 4341. Der Einbau steht in Zeile 4379. **38 Zeilen dazwischen, und die
Antwort auf vier Fassungen Fehlersuche stand oben drueber.**

Verdeckt hat es, dass die Gegenrichtung lief: `GroessenSichern` in derselben
Klasse wurde sehr wohl gerufen, weil `QCToolBarManager::SaveState` seine
Basisfassung ausdruecklich aufruft — das Gegenstueck `LoadState` aber nicht.
"Die Haelfte funktioniert" hat wie ein Beleg dafuer ausgesehen, dass die
Stelle richtig ist.

**Was daraus folgt, zusaetzlich zu den vier Punkten oben:**

5. **Bevor ich eine Zeile in eine fremde Funktion setze, lese ich den
   Kommentarkopf dieser Funktion** — nicht die Datei, nicht das
   Architekturpapier, den Block direkt darueber. Er kostet zehn Sekunden und
   ist die einzige Quelle, die genau von dieser Stelle handelt.
6. **Ein eigener Kommentar, der meiner Aenderung widerspricht, ist ein
   Alarmzeichen, kein Hintergrundrauschen.** "Wird nie aufgerufen" und "hier
   baue ich den Aufruf ein" schliessen sich aus; eins von beidem ist falsch,
   und das ist **vor** dem Bau zu entscheiden, nicht nach vier Paketen.
7. **Bei einem Paar aus Sichern und Laden wird die Symmetrie nachgesehen,
   nicht angenommen.** Dass der eine Weg laeuft, sagt nichts ueber den
   anderen — hier war genau diese Asymmetrie die Ursache
   ([[widerlegte-vermutungen-aufschreiben]]).

Siehe [[eingebaute-messung-auslesen]] — der zweite Teil desselben Vorfalls:
die Spurmarken, die es gesagt haetten, lagen seit vier Fassungen im Bau.

---

## Nachtrag 11.09.2026 — „175 echte Nachrichten": die Zahl war nie reproduzierbar

Oben steht seit dem 29.08.2026 der Satz: *keine Zahl ohne den Befehl, der sie
erzeugt hat — und den Befehl daneben schreiben, damit der nächste sie nachrechnen
kann statt sie zu glauben.* Am 11.09.2026 habe ich genau das wieder nicht getan.

Zu Befund E-80 habe ich geschrieben, die Rechnung sei an **175 echten
Nachrichten aus sechs Postfächern** gefahren worden. PRÜFER hat nachgezählt
(`Befunde/PRUEFER-8.md`, 2.3): **134**. „Sechs Postfächer" stimmt — sieben
`.mbx`, davon `Trash.mbx` leer. Die 175 kommt in keinem Bestand heraus; mit den
Sicherungskopien `In.mbx.001` und `In.mbx.002` wären es 200.

**Der Schaden ist nicht die Zahl, sondern ihre Verbreitung.** Sie stand am Ende
in `BEFUNDE.md`, `CHANGELOG.md`, `README.md` **und in den veröffentlichten
Release Notes von v1.0.47** (11.09.2026, 08:52 UTC) — also auch an einer Stelle,
die keine Schranke des Projekts je wieder liest. Eine ungemessene Zahl wandert
innerhalb eines Arbeitstages aus meinem Kopf in eine Veröffentlichung. Alle vier
Fundstellen sind inzwischen berichtigt, drei davon im Commit `fd62016`, die
Release Notes von Hand danach ([[doku-parallel-nicht-hinterher]]).

### Der Befehl, der sie erzeugt — und was er nebenbei zeigt

    cat <Laufverzeichnis>/Mailverzeichnis/*.mbx | grep -c "^From ???@???"

Gefahren am 11.09.2026, 14 Uhr, über alle Laufverzeichnisse:

| Laufverzeichnis | Trennerzeilen |
|---|---|
| `Eudora72-1.0.42-release` | 87 |
| `1.0.43` bis `1.0.47-release` | **134** |
| `Eudora72-1.0.48-release` | **148** |

Damit ist PRÜFERs 134 bestätigt — **und zugleich ist die 148 der Beleg dafür,
warum eine nackte Zahl hier gar nicht tragen kann**: Gregor arbeitet in 1.0.48,
seit der Messung heute Vormittag sind vierzehn Nachrichten dazugekommen. Die
Messgröße wächst, während ich über sie schreibe.

**Was daraus folgt, zusätzlich zu den Punkten oben:**

8. **Eine Zahl, die ich in eine MD schreibe, bekommt den Befehl mit**, der sie
   erzeugt — in derselben Zeile oder direkt darunter, ausführbar. Was sich nicht
   in einen Befehl fassen lässt, ist eine Schätzung und wird so genannt.
9. **Zu einer Zahl über einen fremden Datenbestand gehören Ort und Zeitpunkt.**
   „134 Nachrichten" ist keine Eigenschaft des Projekts, sondern eine Ablesung:
   *134, gemessen am 11.09.2026 in `1.0.47-release`*. Ohne beides veraltet der
   Satz, ohne dass jemand etwas falsch gemacht hätte.
10. **Vor dem Veröffentlichen wird jede Zahl der Release Notes gegen ihre Quelle
    gefahren, nicht gegen die MD, aus der ich sie kopiere.** Abschreiben
    vervielfältigt nur den Fehler ([[doku-parallel-nicht-hinterher]]).
11. **Wenn eine Zahl sich nicht reproduzieren lässt, wird sie ersetzt und der
    Widerspruch genannt** — nicht gerundet, nicht stehen gelassen. „Ich kann
    nicht sagen, woher die Zahl stammt; im heutigen Bestand kommt sie nicht
    heraus" ist der Satz, den PRÜFER geschrieben hat, und er ist der richtige
    ([[widerlegte-vermutungen-aufschreiben]]).
