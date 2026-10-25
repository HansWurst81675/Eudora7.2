# <a id="pruefer-52"></a>PRUEFER-52 — der neue E-20-Test, die Behebungen von PRUEFER-51 K1–K3, die Kennungssuche und der PR-Haken gegen die Quelle nachgerechnet, 25.10.2026

**Auftrag.** `git log c0bbacb5..HEAD -- Eudora71 tools Releases/1.0` (Stand
`37cb4392`, Zweig `wt/pruefer-20261025b`): der Regressionstest zu
[E-20](../Intern/BEFUNDE.md#e-20), der jetzt die Funktion aufruft
(`UnderTestE20.cpp`, `TestSpeicherfehler.cpp`, `Extract.ps1` Region V,
`Tests.vcxproj`), die Behebungen von [PRUEFER-51 K1–K3](PRUEFER-51.md#k1) in
`tools/pruefbericht.pl`, die neue Kennungssuche in
`tools/pruefe-regressionstest.pl` und der neue PR-Haken
`tools/haken-pr-lektor.pl`.

**Ergebnis vorweg.**

* **Der neue E-20-Test ruft wirklich den Programmcode auf.** Ich habe zwei
  eigene Rückfälle eingebaut, beide wurden rot: den Originalcode von QUALCOMM
  und eine Fassung ohne das Vorbelegen des Feldes. Der Test liest also nicht
  mehr nur den Quelltext.
* **Aber er bewacht nur eine von zwei Behebungen.** [E-20](../Intern/BEFUNDE.md#e-20)
  wurde an zwei Stellen behoben, in `InsertArr` und in `NotifyInsertedCol`.
  Ich habe die zweite Stelle auf den alten Stand zurückgesetzt. Ergebnis:
  **296 von 296 grün** ([K2](#k2)).
* **Neuer Programmfehler, Spiegelbild von [E-20](../Intern/BEFUNDE.md#e-20): Beim Ausblenden einer Spalte
  im Fenster „Task Status“ kann Eudora hinter ein Feld schreiben** ([K1](#k1),
  neue Kennung [E-150](../Intern/BEFUNDE.md#e-150)). Wer dort Spalten ein- und ausschaltet, kann den Speicher
  beschädigen. Das Ausblenden ist der Gegenweg zum Einblenden, also dem Weg,
  auf dem [E-20](../Intern/BEFUNDE.md#e-20) entstand. Gemessen habe ich das an der herausgeschnittenen
  Funktion: 4 Byte hinter einem Feld von 4 Byte überschrieben. Dass Eudora
  diesen Weg nimmt, ist am Quelltext belegt. Eudora selbst habe ich nicht
  gestartet. Der Fehler steckt seit QUALCOMM unverändert im Code.
* **Die Behebungen im Prüfbericht halten.** Ein Fall an einem fremden Bau
  wird erkannt, ein gescheiterter Bau ebenso, auch eine einzelne rote Probe
  neben grünen gleichen Namens. **Drei Lücken bleiben:**
  * Fehlt `Eudora71\Bin\Release\Eudora.exe`, etwa in einem frischen Klon,
    reicht wieder die Fassungsnummer. Gemessen: BESTANDEN mit E-119d an einem
    Bau **vor** der Behebung ([K4](#k4)).
  * Der Vergleich vorher/nachher meldet weiter Rückgabe 0, wenn Tests
    **wegfallen**. Gemessen: eine ganze Testgruppe (5 Tests, darunter beide
    E-20-Tests) auskommentiert, Rückgabe 0 ([K5](#k5)).
  * **Seit der Behebung von K3 sieht `pruefe-regressionstest.pl` eine rote
    Schrankenprobe nicht mehr, wenn sie nicht die erste ihrer Kennung ist.**
    Gemessen: [E-35](../Intern/BEFUNDE.md#e-35) Probe 3 rot, [E-35](../Intern/BEFUNDE.md#e-35) zählt
    weiter als geprüft ([K3](#k3)). Die Behebung von [PRUEFER-51](PRUEFER-51.md#pruefer-51) K3 hat damit
    die Behebung von [PRUEFER-50 K12](PRUEFER-50.md#k12) ausgehebelt.
* **Die neue Kennungssuche zählt heute nichts Falsches.** Gemessen: Sie
  ändert das Ergebnis nur bei drei Kennungen ([E-106](../Intern/BEFUNDE.md#e-106), [E-108](../Intern/BEFUNDE.md#e-108), [E-119](../Intern/BEFUNDE.md#e-119)). Alle drei
  kommen über echte Prüfstandsfälle (`E-106p`, `E-108p`, `E-119a–d`).
* **Den PR-Haken kann man auf vielen gewöhnlichen Wegen umgehen** ([K6](#k6)).
  Er prüft nur die wörtliche Folge `gh pr create`. Gemessen:
  `gh pr new` (Kurzname derselben Funktion), eine Zeilenfortsetzung,
  `url="$(gh pr create …)"` und `bash -lc "…"` kommen durch. Der Selbsttest
  meldet 13 von 13, weil keiner dieser Fälle darin vorkommt.
* **Die Testsuite ist grün: 296 Tests, 296 bestanden** (gemessen, vor und
  nach allen Rückfallproben, zuletzt nach `touch` und Neubau).

**Hält ein Fund das nächste Paket auf?** **Nein.** [K1](#k1) ist ein
Originalfehler und kein Rückschritt. Nach Gregors Entscheidung vom 23.10.
halten kritische Funde ein Release nicht auf. Die Behebung ist klein, dieselbe
Rechnung wie bei [E-20](../Intern/BEFUNDE.md#e-20), und gehört neben [E-20](../Intern/BEFUNDE.md#e-20). **Ob sie vor dem Paket kommt,
entscheidet Gregor.** Die übrigen Funde betreffen Prüfwerkzeuge und gehören
vor **7.2.1.0**. Für das Paket gilt wie bei [PRUEFER-51](PRUEFER-51.md#pruefer-51): Es wird nach
`Intern/WEITERMACHEN.md:492` mit `-AusBauverzeichnis -Bauart Release`
geschnürt, sonst gilt der Prüfbericht für eine andere EXE als die
ausgelieferte ([K4](#k4)).

**Neue E-Kennungen: [E-150](../Intern/BEFUNDE.md#e-150) vergeben ([K1](#k1)). [E-151](../Intern/BEFUNDE.md#e-151) bleibt frei.**
Eingetragen in `Intern/BEFUNDE.md` ist nichts. Vorher gelaufen:
`perl tools/befund-suchen.pl` zu `ListCtrlEx` ([E-20](../Intern/BEFUNDE.md#e-20)),
`DeleteArr` (kein Befund) und `NotifyDeletedCol` (kein Befund). In
`Befunde/` und `Intern/` steht keines der beiden Wörter (gemessen, `grep`).

Gekennzeichnet ist jede Aussage: **gemessen** (Testlauf, Rückfallprobe,
Werkzeuglauf), **am Quelltext belegt** (Datei:Zeile, Stand `37cb4392`),
**Vermutung**.

---

## 1. Der neue E-20-Test

**Was er tut** (am Quelltext belegt). `Extract.ps1:426-435` schneidet
`CListCtrlEx::InsertArr` aus `ListCtrlEx.cpp` (Region V, bis zur ersten
schließenden Klammer am Zeilenanfang). `UnderTestE20.cpp` bindet das Stück
ein und leitet `DEBUG_NEW` auf ein eigenes `operator new[]` um. Das legt hinter
jedes Feld 64 Byte `0xAB` als Schutzstreifen. Geprüft werden der Streifen, die
neue Länge und jeder Eintrag (`TestSpeicherfehler.cpp:28-61`).

**Ist das der Programmcode?** Ja. Drei Messungen:

* `wer-baut.pl`: `ListCtrlEx.cpp` steht in `Eudora.vcxproj` (gemessen).
  `Tests.vcxproj:67` ruft `Extract.ps1` bei jedem Bau. Nach meinen Proben
  enthielt `generated/listctrlex_e20.inc` den Rumpf aus `ListCtrlEx.cpp` Byte
  für Byte, ohne Wagenrückläufe verglichen (gemessen).
* `ForceConformanceInForLoopScope=false` steht in `Eudora.vcxproj:75` und
  `:128` und für `UnderTestE20.cpp` in `Tests.vcxproj:105-108` (am Quelltext
  belegt). Beide übersetzen die Laufvariable `i` gleich.
* Rückfallproben (je Probe `ListCtrlEx.cpp` mit Perl `:raw` geändert, gebaut,
  gefahren, zurückgeschrieben, `cmp` gleich):

| Rückfall in `ListCtrlEx.cpp` | Ergebnis |
|---|---|
| ganzer `InsertArr`-Rumpf aus dem ersten Commit `567a5d87` (QUALCOMM: `[nLen + 1]`, `nLen++`) | **295/296**, „schreibt hinter das Ende“ und „nLen stimmt nicht“ |
| nur das Vorbelegen `for (v …) pTemp[v] = nDefault;` entfernt | **295/296**, drei falsche Einträge (`0xABABABAB`) |
| `NotifyInsertedCol`, Bildlisten-Block auf den QUALCOMM-Stand (`[m_DispImageListArrLen + 1]`) | **296/296 grün**, siehe [K2](#k2) |

Die beiden Proben aus der Commit-Nachricht (`[nLen + 1]`, `nBis = nIdx`) habe
ich nicht wiederholt. Meine erste Probe enthält beide.

**Kleinigkeit** (gemessen): Beim fehlenden Vorbelegen meldet der Test
„0xABABABAB: hinter dem alten Feld gelesen“. Gelesen wurde dabei aber nichts.
Die Einträge waren nie beschrieben, und der Streifen-`new` hatte das ganze
neue Feld mit `0xAB` gefüllt. Die Meldung führt bei der Ursachensuche in die
falsche Richtung. Kein eigener Fund.

### <a id="k2"></a>K2 — Der E-20-Test bewacht nur InsertArr, nicht die zweite Behebung in NotifyInsertedCol

**Was passiert** (gemessen). [E-20](../Intern/BEFUNDE.md#e-20) nennt als Ort
„`CListCtrlEx::InsertArr` und `NotifyInsertedCol`“. In `NotifyInsertedCol`
steht dieselbe Rechnung ein zweites Mal, ausgeschrieben, für das Feld der
Bildlisten (`ListCtrlEx.cpp:1408-1430`, Kommentar „Befund [E-20](../Intern/BEFUNDE.md#e-20), dieselbe
Rechnung wie in InsertArr“). Diesen Block habe ich durch den Block aus
`567a5d87` ersetzt: `[m_DispImageListArrLen + 1]`, Kopieren bis `nCol`,
`m_DispImageListArrLen++`. Ergebnis: **296 von 296 grün**, beide E-20-Tests
`[ok]`. Danach byte-genau zurück.

**Warum** (am Quelltext belegt). Region V endet an der schließenden Klammer
von `InsertArr` (`Extract.ps1:434`). `NotifyInsertedCol` wird nicht
geschnitten, und kein Test und keine Schranke nennt die Funktion (gemessen:
`grep NotifyInsertedCol Eudora71/Tests tools` ohne Treffer außerhalb von
Kommentaren).

**Vorschlag:** Den Bildlisten-Block über eine Schablone
`InsertArr<T>(T*&, unsigned&, T, unsigned)` laufen lassen. Dann gibt es nur
eine Rechnung, und der Test deckt beide Felder. Oder `NotifyInsertedCol` mit
einer Ersatzklasse ausschneiden, die die sechs Felder als Member hat. Die
erste Lösung ändert Programmcode, die zweite nur den Test. **Schwere:** mittel
(Lücke im Regressionstest eines kritischen Befunds).

## 2. Neuer Fehler: das Spiegelbild von E-20 beim Löschen einer Spalte

### <a id="k1"></a>K1 — E-150: DeleteArr und NotifyDeletedCol schreiben hinter das Feld, wenn die Spalte hinter dem Feldende liegt

**Was passiert.** `DeleteArr` legt das neue Feld mit `[nLen - 1]` an und
kopiert dann `pTemp[i] = pArr[i]` für `i < nIdx` (`ListCtrlEx.cpp:1384-1399`).
Ist `nIdx >= nLen`, schreibt die Schleife hinter das neue Feld und liest
hinter dem alten. Der Bildlisten-Block in `NotifyDeletedCol` macht dasselbe
(`:1440-1451`). Das ist genau die Lage von [E-20](../Intern/BEFUNDE.md#e-20), nur beim Löschen statt beim
Einfügen. Behoben wurde nur das Einfügen.

**Gemessen** an der herausgeschnittenen Funktion. `DeleteArr` per Perl aus
`ListCtrlEx.cpp` geschnitten, mit demselben Schutzstreifen wie
`UnderTestE20.cpp` und `cl /Zc:forScope-` übersetzt, im Scratch-Verzeichnis
und nicht im Repo:

| `nLen` | `nIdx` | neues Feld | Schutzstreifen |
|---|---|---|---|
| 4 | 1 | 12 Byte | unberührt |
| 2 | 2 | 4 Byte | **4 Byte überschrieben** |
| 2 | 3 | 4 Byte | **4 Byte überschrieben**, ein zweiter Schreibzugriff schrieb `0xABABABAB` aus dem Streifen des alten Feldes und fiel deshalb nicht auf |

**Wie Eudora dorthin kommt** (am Quelltext belegt, nicht am Programm
gemessen). Die Felder in `CListCtrlEx` wachsen nur, wenn eine Spalte ein Bild
oder einen Balken bekommt (`SetColImageList`, `SetColImageWidth/Height`,
`SetColDisplayType`, `:858-1010`). `InsertArr` tut bei einem NULL-Feld nichts
(`:1350`). Ein Feld kann also kürzer sein als die Zahl der Spalten. Im Fenster
„Task Status“ (`TaskStatusView.cpp:598-772`) entsteht das zum Beispiel so:

1. Unter *Optionen* die Spalten **Task** und **Status** abschalten
   (`TaskStatusShowColTask`/`…Status`, Vorgabe 1, `EudoraRes.rc:10332-10336`).
   Eudora neu starten. Das Fenster baut nur **Progress** auf (Details ist
   von Haus aus aus). Die Bildfelder bleiben NULL.
2. **Status** wieder einschalten. Status kommt an Stelle 0 (`FindInsertIndex`),
   `SetColImageList(0, …)` legt die drei Bildfelder mit Länge 1 an. Es gibt
   jetzt zwei Spalten.
3. **Progress** abschalten: `NotifyDeletedCol(1)` (`:768`).
   `DeleteArr(m_ImageHeightArr, 1, 1)` legt ein Feld der Länge 0 an und
   schreibt `pTemp[0]`. Dasselbe passiert in `m_ImageWidthArr` und im
   Bildlisten-Feld.

Die Optionsseite meldet jede Änderung dieser Schalter über
`bTaskStatusColChanged` (`settings.cpp:1157-1164`). Am Ende landet das in
`UpdateColumns` (`TaskStatusView.cpp:538`). Mit zwei Persönlichkeiten gibt es
weitere Wege. Wie oft das jemand tut, ist **Vermutung**: Man muss die Spalten
umstellen und dazwischen neu starten.

**Folge.** Schreiben hinter ein Feld im Heap. Je nach Lage folgt sofort
nichts, ein späterer Absturz oder eine beschädigte Verwaltung des Heaps.
Welche Folge es bei Eudora gibt, habe ich nicht gemessen.

**Herkunft** (am Quelltext belegt). `DeleteArr` und der Block in
`NotifyDeletedCol` stehen in `567a5d87` genau so wie heute. Ob das
QUALCOMM-Programm denselben Weg tatsächlich nimmt, habe ich nicht gemessen
([Arbeitsweise/original-ist-eine-messung.md](../Arbeitsweise/original-ist-eine-messung.md)).

**Vorschlag:** In `DeleteArr` und `NotifyDeletedCol` bei `nIdx >= nLen` nichts
löschen (die Spalte hat keinen Eintrag) und die Schleife bis
`min(nIdx, nLen)` laufen lassen. Ein Test dazu kann `UnderTestE20.cpp`
erweitern: `DeleteArr` mit ausschneiden und mit `(2, 2)` und `(1, 1)` rufen.
**Schwere:** kritisch (Speicherfehler: Schreiben hinter das Feld), wie [E-20](../Intern/BEFUNDE.md#e-20).
**Hält das Paket nicht auf** (Originalfehler, kein Rückschritt; Gregor
23.10.).

## 3. Die Behebungen von PRUEFER-51 K1–K3 im Prüfbericht

Gefahren mit `perl tools/pruefbericht.pl --zeigen --ohne-bau`,
`--vergleich --ohne-bau` und einmal `--zeigen` mit Bau. Geschrieben wurde
nichts. Grundstand im Arbeitsbaum: **NICHT VOLLSTÄNDIG**, weil hier in
`Bin\Release` eine alte, nicht eingecheckte `Eudora.exe` vom 21.10. liegt
(`7.2.0.120 / Paket 1.0.120+976c8e64`). Alle 29 Fälle zählen deshalb als
„ANDERER BAU“. Das ist die richtige Richtung (gemessen).

| Probe | Ergebnis | hält? |
|---|---|---|
| K1: `Bin\Release\Eudora.exe` durch eine Datei mit der Kennung `… 1.0.122+9402f257 2026-10-25 09:31` ersetzt, Buch unverändert | BESTANDEN, 29/29 | ja |
| K1: dazu E-119d im Buch auf `+054b6e66` (vor der Behebung) | **NICHT VOLLSTÄNDIG**, „1 an anderem Bau“ | ja |
| K1: **ohne** `Bin\Release\Eudora.exe`, E-119d auf `+054b6e66` (ohne Sternchen) | **BESTANDEN**, 29/29 | **nein**, [K4](#k4) |
| K2: `#error` in `UnderTestE20.cpp`, `--zeigen` mit Bau | NICHT VOLLSTÄNDIG, „Bau der Testsammlung gescheitert – alte EudoraTests.exe nicht gefahren“, Unit „nicht gelaufen“ | ja |
| K2: `RunSpeicherfehlerTests` in `TestMain.cpp:151` auskommentiert, gebaut (291 Tests) | `--vergleich`: weggefallen 5, **Rückgabe 0** | **nein**, [K5](#k5) |
| K2: eine E-35-Zeile aus `regression-schranken.txt` gelöscht | `--vergleich`: weggefallen 1 (`E-35#4`), **Rückgabe 0**; Soll-Zahl folgt der Liste, also kein „unvollständig“ | **nein**, [K5](#k5) |
| K3: zweite E-62-Probe wirkungslos (Rückfall = Vorlage) | `schranken-gegenprobe.pl` 17/18; `--vergleich`: **NEU ROT 1 (`E-62#2`), Rückgabe 1** | ja |

Jede Datei danach mit `cmp` gegen die Kopie geprüft; `TestMain.cpp` und
`UnderTestE20.cpp` zusätzlich `touch` und Neubau: 296/296.

### <a id="k3"></a>K3 — Seit den laufenden Nummern sieht pruefe-regressionstest.pl eine rote zweite Probe nicht

**Gemessen.** In `Releases/pruefbericht-tests.tsv` die Zeile
`E-35#3 (pruefe-fensterbau.pl)` auf `FEHL` gesetzt:
`pruefe-regressionstest.pl --hinweis` meldet weiter „OHNE jede Prüfung 26“,
[E-35](../Intern/BEFUNDE.md#e-35) steht nicht in der Liste. Gegenprobe: dieselbe Änderung an der **ersten**
Zeile `E-35 (pruefe-fensterbau.pl)` ergibt 27, und [E-35](../Intern/BEFUNDE.md#e-35) steht in der Liste.
Danach byte-genau zurück. [E-35](../Intern/BEFUNDE.md#e-35) ist nur über Schranken gedeckt (gemessen: kein
Treffer in `Eudora71/Tests/*.cpp` und `pruefstand-faelle.txt`).

**Am Quelltext belegt.** `pruefbericht.pl:151-152` hängt seit `3b48d9b9` an
die Kennung `#2`, `#3` usw. `pruefe-regressionstest.pl:130` nimmt aus der
Spalte `/^(\S+)/`, also `E-35#3`, und merkt sich die rote Zeile unter diesem
Schlüssel. Abgefragt wird aber `$schranke_rot{"E-35"}` (`:138`). Die
Schranken-Prüfung aus [PRUEFER-50 K12](PRUEFER-50.md#k12) („keine rote,
mindestens eine grüne“) wirkt deshalb nur noch auf die erste Probe jeder
Kennung. Betroffen sind heute [E-35](../Intern/BEFUNDE.md#e-35) (Proben 2–4) und
[E-62](../Intern/BEFUNDE.md#e-62) (Probe 2). Es ist genau der Fall, den die
Behebung von [PRUEFER-51](PRUEFER-51.md#pruefer-51) K3 schließen sollte: Eine rote Probe neben grünen
Geschwistern bleibt unsichtbar, jetzt nur an anderer Stelle.

**Vorschlag:** In `pruefe-regressionstest.pl:130` mit `/^([^\s#]+)/` lesen.
Als Schranke dazu: `pruefe-regressionstest.pl --selbsttest` mit einem Testbuch,
in dem `X#2` rot ist. **Schwere:** wichtig (Prüfstand). Die Deckungszahl der
kritischen Befunde geht so in den Prüfbericht ein.

### <a id="k4"></a>K4 — Ohne Release-Bau gilt wieder die Fassungsnummer; geprüfte und ausgelieferte EXE werden nirgends verglichen

**Gemessen.** Siehe Tabelle, dritte Zeile: Ohne `Bin\Release\Eudora.exe`
zählt E-119d an `+054b6e66` als „dieser Bau“, Gesamturteil **BESTANDEN**.
`Bin/` steht in `.gitignore:6` (gemessen, `git check-ignore`). In jedem
frischen Klon fehlt die Datei also. Das ist genau die Lage aus
[PRUEFER-51 K1](PRUEFER-51.md#k1) („jemand, der das Repo klont“).

**Am Quelltext belegt**, drei Reste:

1. `pruefbericht.pl:207-208`: Ohne Release-Bau reichen Fassung und „kein
   Sternchen“. Zwischen zwei Paketen haben alle Bauten dieselbe Fassung
   ([Arbeitsweise/nummer-erst-beim-schnueren.md](../Arbeitsweise/nummer-erst-beim-schnueren.md)).
   Ehrlicher wäre: kein Release-Bau, dann „ungeprüft“, oder der Commit aus der
   Baukennung muss `git rev-parse --short HEAD` sein.
2. Ob die Release-EXE zum Quelltext von HEAD passt, prüft niemand. Die
   Unit-Tests laufen gegen HEAD, die Prüfstandsfälle gegen den Commit in der
   Baukennung. Der Bericht nennt nur den Commit von HEAD. Heute passt es
   zufällig: Seit `9402f257` hat sich unter `Eudora71/` außer `Tests/` nichts
   geändert (gemessen, `git log 9402f257..HEAD`).
3. `paket-bauen.ps1` ruft den Bericht (`:428-450`). Mit der Vorgabe
   `-Bauart Debug` (`:54`) übernimmt es aber die EXE aus `Bin\Debug` (`:498`).
   Ohne `-AusBauverzeichnis` behält es die EXE der Grundlage
   `Eudora72-1.0.2-lauffaehig.zip`. In beiden Fällen bescheinigt der Bericht
   die Release-EXE, ausgeliefert wird eine andere. Der dokumentierte Aufruf
   (`Intern/WEITERMACHEN.md:492`) setzt beide Schalter richtig.

**Vorschlag:** `paket-bauen.ps1` liest nach dem Kopieren die Baukennung aus
`$Ziel\Eudora.exe` und vergleicht sie mit `$bin_kennung` aus dem Bericht.
Zusätzlich im Bericht Fall 1 schließen. **Schwere:** wichtig (Prüfstand).
**Hält das Paket nicht auf**, wenn wie dokumentiert geschnürt wird.

### <a id="k5"></a>K5 — Der Vergleich vorher/nachher meldet weggefallene Tests weiter mit Rückgabe 0

**Gemessen** (Tabelle, Zeilen 5 und 6). Eine auskommentierte Testgruppe
nimmt fünf Tests aus dem Lauf, darunter beide E-20-Tests. Eine gelöschte
Probenzeile nimmt eine Schranke weg. Beide Male zeigt `--vergleich` die
Einträge unter „weggefallen“ und gibt 0 zurück. Auch das Gesamturteil merkt
nichts: Die Ergebniszeile von `EudoraTests.exe` stimmt in sich (291 Tests,
291 Zeilen, Rückgabe 0), und das Soll der Schranken wird aus derselben Liste
gezählt, aus der die Zeile verschwand.

**Am Quelltext belegt.** `pruefbericht.pl:264`:
`exit((@neu_rot or @unvollstaendig) ? 1 : 0)`. `@weg` geht nicht ein. Der
Vorschlag aus [PRUEFER-51 K2](PRUEFER-51.md#k2) („weggefallen ist im
Vergleich rot“) wurde nicht umgesetzt. Die Commit-Nachricht von `3b48d9b9`
nennt ihn auch nicht.

**Dazu, gemessen:** `pruefe-regressionstest.pl --hinweis` gab mit
auskommentierter Gruppe **dieselbe Ausgabe** wie ohne (`diff` leer). [E-18](../Intern/BEFUNDE.md#e-18),
[E-20](../Intern/BEFUNDE.md#e-20), [E-25](../Intern/BEFUNDE.md#e-25) und [E-31](../Intern/BEFUNDE.md#e-31) zählten weiter als getestet. Das Werkzeug liest die
Kennung im Quelltext der Tests. Ob der Test läuft, sieht es nicht.

**Vorschlag:** „weggefallen“ ist im Vergleich Rückgabe 1. Wer bewusst einen
Test streicht, nennt ihn mit `--weg-erlaubt <Schlüssel>`. Für
`pruefe-regressionstest.pl`: Eine Kennung aus `Tests/*.cpp` zählt nur, wenn
sie auch in einem Testnamen im eingecheckten Testbuch steht. **Schwere:**
wichtig (Prüfstand). Genau diesen Vergleich hat Gregor für Prüfungen nach
einer Änderung verlangt.

### Hinweis: laufende Nummern (PRUEFER-51 K3) und doppelte Testnamen

Am Quelltext belegt, ohne eigenen Fund. Die Nummer `#n` richtet sich nach der
Reihenfolge in `regression-schranken.txt`. Löscht man die **erste** E-35-Zeile,
meldet der Vergleich `E-35#4` als weggefallen und vergleicht die alte erste
Probe mit der neuen ersten (vorher die zweite). Die Namen im Vergleich führen
dann in die Irre. Für Unit-Tests gibt es keine Nummer
(`pruefbericht.pl:220`, Schlüssel `Bereich / Name`). Zwei gleichnamige Tests
derselben Gruppe würden zu einem Eintrag zusammenfallen, wie bei K3. Heute
sind alle 296 Schlüssel verschieden (gemessen).

## 4. Die neue Kennungssuche in pruefe-regressionstest.pl

**Gemessen.** Ich habe eine Kopie des Werkzeugs im Scratch-Verzeichnis
gefahren. Darin wurde jede Kennung mit dem alten Muster `\Q…\E\b` **und** dem
neuen `(?<![\w-])\Q…\E(?!\d)` gesucht, und ausgegeben wurde jeder
Unterschied. Ergebnis: **nur drei Unterschiede**, alle von „nicht gedeckt“
nach „gedeckt“:

| Kennung | gedeckt durch |
|---|---|
| [E-106](../Intern/BEFUNDE.md#e-106) | Prüfstandsfall `E-106p` (`pruefstand-faelle.txt:177`, prüft die Bildgröße aus [E-106](../Intern/BEFUNDE.md#e-106)) |
| [E-108](../Intern/BEFUNDE.md#e-108) | Prüfstandsfall `E-108p` (`:180`, verlangt „Logging shutdown“ ohne „Exception“) |
| [E-119](../Intern/BEFUNDE.md#e-119) | Prüfstandsfälle `E-119a` bis `E-119d` |

Kein Fall, in dem das neue Muster weniger findet. Die Sperre vor der Kennung
(`(?<![\w-])`) ändert heute nichts.

**Grenze** (am Quelltext belegt, heute ohne Wirkung): Ein Buchstabe hinter der
Kennung ist jetzt erlaubt. Ein Test, der nur `Z-2B` nennt, deckt damit auch
[Z-2](../Intern/BEFUNDE.md#z-2). [Z-2b](../Intern/BEFUNDE.md#z-2b) ist die einzige Kennung mit Buchstaben
in `Intern/BEFUNDE.md` (gemessen). [Z-2](../Intern/BEFUNDE.md#z-2) ist zusätzlich über den Gruppennamen
„[NP3-8](../Intern/BEFUNDE.md#np3-8), [NP3-9](../Intern/BEFUNDE.md#np3-9), [Z-2](../Intern/BEFUNDE.md#z-2) und Z-2B“ gedeckt. Ob dieser Gruppenname eine Prüfung ist,
ist eine andere Frage ([PRUEFER-51](PRUEFER-51.md#pruefer-51), „Ohne Fund“).

**Kein Fund.**

## 5. Der PR-Haken

**Selbsttest:** 13 Fälle, 0 rot (gemessen). **Live:** Der Haken hat einen
meiner eigenen Aufrufe abgewiesen, in dem `gh pr create --help` ausgeführt
werden sollte (LEKTOR steht in `tools/AGENTEN-LAUFEN.md` des Hauptbaums). Er
greift also, und er wirkt für Bash und PowerShell (`.claude/settings.json`,
`"matcher": "Bash|PowerShell"`).

### <a id="k6"></a>K6 — Der PR-Haken lässt `gh pr new`, Zeilenfortsetzungen und `"$(…)"` durch

**Gemessen**, zwei Wege. `nur_befehle` herausgeschnitten und mit 14 Befehlen
gefahren. Vier davon auch über den ganzen Haken mit JSON auf stdin. Der
Grundfall `gh pr create --title x` ergab dort **Rückgabe 2**, die drei
anderen **Rückgabe 0**:

| Befehl | Haken |
|---|---|
| `gh pr new --title x` (laut `gh` der Kurzname derselben Funktion: „ALIASES gh pr new“) | **durch** (auch über JSON) |
| `gh pr \`↵`  create --title x` | **durch** (auch über JSON) |
| `url="$(gh pr create --title x)"` | **durch** (auch über JSON) |
| `` echo "`gh pr create`" `` | durch |
| `bash -lc "gh pr create"` | durch (`-c` muss allein stehen) |
| `cmd /c "gh pr create"` | durch |
| `powershell -command "gh pr create"` | durch (nur `-Command` mit großem C) |
| `gh.exe pr create`, `"…/GitHub CLI/gh" pr create` | durch |
| `Invoke-Expression "gh pr create"` | durch |
| `gh api repos/o/r/pulls -f …` | durch |
| `sh -c 'gh pr create'` | geprüft |

Dazu, nebenbei gemessen: Mein Aufruf `a=create; gh pr $a --help` lief am
Live-Haken vorbei.

**Am Quelltext belegt.** `haken-pr-lektor.pl:41` sucht nur
`\bgh[ \t]+pr[ \t]+create\b`. `nur_befehle` (`:82-96`) wirft jede Zeichenkette
in doppelten Anführungszeichen weg. Gerettet wird ihr Inhalt nur hinter genau
`-c`, `-Command` oder `eval`. Eine Befehlsersetzung `$(…)` oder `` `…` `` in
doppelten Anführungszeichen wird aber ausgeführt.

**Wie schwer?** Der Haken soll **mein** Vergessen abfangen, nicht einen
Angreifer. Wahrscheinlich sind daher nur die ersten drei Zeilen: `gh pr new`,
ein langer Befehl mit Zeilenfortsetzung und das Auffangen der PR-Adresse in
einer Variablen. **Vorschlag:** Vor der Suche `\`+Zeilenende entfernen. Den
Inhalt von `$(…)` und `` `…` `` auch in doppelten Anführungszeichen behalten.
`(?:create|new)` suchen, `-c` auch in `-lc`/`-xc` und `-command` ohne Rücksicht
auf Groß/klein erkennen, `gh(?:\.exe)?`. Jede Zeile der Tabelle als Fall in
den Selbsttest. **Schwere:** mittel (Prozessschranke).

---

## 6. Stand der bekannten Funde aus PRUEFER-51

Seit `c0bbacb5` hat kein Commit `pruefe-nachrichtenschleife.pl`,
`pruefe-fensterbau.pl`, `TestE148.cpp`, `paket-pruefen.ps1`,
`PgEmbeddedImage.cpp`, `messen-e119-geteilt.ps1`, `pruefstand-lauf.ps1` oder
`pruefstand-faelle.txt` geändert (gemessen, `git log c0bbacb5..HEAD --
<Dateien>`). Daher unverändert **offen**:

| Fund | Kurz | Stand |
|---|---|---|
| [PRUEFER-51 K4](PRUEFER-51.md#k4) | Nachrichtenschleifen-Schranke: zwei Schleifen einer Funktion decken einander | offen |
| [PRUEFER-51 K5](PRUEFER-51.md#k5) | GetButton-Schranke: `(*p).` und nicht schützende Prüfung | offen |
| [PRUEFER-51 K7](PRUEFER-51.md#k7) | TestE148 prüft den Skripttext, nicht das Paket | offen |
| [PRUEFER-51 K8](PRUEFER-51.md#k8) | [E-119](../Intern/BEFUNDE.md#e-119) K5: gescheiterte Kopie teilt die Datei wieder | offen |
| [PRUEFER-51 K9](PRUEFER-51.md#k9) | E-119d prüft das Löschen nicht | offen |
| [PRUEFER-51 K10](PRUEFER-51.md#k10) | alte Entwürfe tragen die geteilte Datei weiter (Vermutung) | offen |
| [PRUEFER-51 K11](PRUEFER-51.md#k11) | Ergebnisbuch: eine Uhrzeit je Lauf | offen |

Nicht gefragt, aber gesehen: [PRUEFER-51 K6](PRUEFER-51.md#k6) ist in der
README erledigt (`README.md:147` und `:247` nennen das Mailverzeichnis, am
Quelltext belegt).

## Was gelaufen ist

* `Eudora71/Tests/RunTests.cmd` im Arbeitsbaum `Eudora7.2-wt-pruefer`:
  **296 Tests, 296 bestanden**, Rückgabe 0. Gelaufen vor den Proben, nach dem
  Zurückschreiben von `TestMain.cpp` (mit `touch`) und zuletzt nach allen
  Proben (mit `touch` auf `ListCtrlEx.cpp` und `UnderTestE20.cpp`). Die Zahl
  296 blieb jedes Mal gleich.
* Rückfallproben mit Bau: `ListCtrlEx.cpp` (3), `TestMain.cpp` (1),
  `UnderTestE20.cpp` (1, Bau muss scheitern). Ohne Bau:
  `Intern/pruefstand-buch.tsv` (1), `tools/regression-schranken.txt` (2),
  `Releases/pruefbericht-tests.tsv` (2), `Bin\Release\Eudora.exe` (nicht
  eingecheckt; einmal weggenommen, einmal durch eine Datei mit Baukennung
  ersetzt, danach die alte Datei zurück). Jede Datei mit Perl `:raw` oder
  `cp` geändert und mit `cmp` gegen die Kopie geprüft. `git status` danach
  ohne Änderung an eingecheckten Dateien.
* `pruefbericht.pl` nur mit `--zeigen` bzw. `--vergleich`, es wurde nichts
  geschrieben.
* Prüfling für `DeleteArr` mit `cl` (VS 2022, `vcvars32.bat`) übersetzt und
  gefahren. Der Haken wurde über eine herausgeschnittene `nur_befehle` und
  über JSON auf stdin geprüft.
* Alle Hilfsdateien lagen in `pruef-tmp/` im Arbeitsbaum und sind gelöscht.
* Kein Eudora gebaut oder gestartet, kein Fenster,
  `pruefstand-lauf.ps1` nicht gestartet, nichts unter `C:\Temp` angefasst.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | [E-150](../Intern/BEFUNDE.md#e-150): Wird im Fenster „Task Status“ eine Spalte ausgeblendet, kann Eudora hinter ein Feld im Speicher schreiben. Spiegelbild von [E-20](../Intern/BEFUNDE.md#e-20), gemessen an der herausgeschnittenen Funktion (4 Byte überschrieben) | kritisch (Speicherfehler) | nein (Originalfehler; Gregor entscheidet, ob die kleine Behebung mitgeht) |
| [K2](#k2) | Der E-20-Test bewacht nur `InsertArr`. Die zweite Behebung in `NotifyInsertedCol` lässt sich zurücksetzen, und es bleibt 296/296 grün | mittel | nein |
| [K3](#k3) | `pruefe-regressionstest.pl` sieht seit den laufenden Nummern eine rote zweite, dritte oder vierte Schrankenprobe nicht. Gemessen: [E-35](../Intern/BEFUNDE.md#e-35) bleibt „gedeckt“ | wichtig (Prüfstand) | nein; vor 7.2.1.0 beheben |
| [K4](#k4) | Fehlt die Release-EXE (frischer Klon), meldet der Prüfbericht BESTANDEN mit einem Fall an einem Bau vor der Behebung. Geprüfte und ausgelieferte EXE werden nirgends verglichen | wichtig (Prüfstand) | nein, wenn wie in `WEITERMACHEN.md:492` mit `-AusBauverzeichnis -Bauart Release` geschnürt wird |
| [K5](#k5) | `--vergleich` gibt 0 zurück, wenn Tests oder Schranken wegfallen. Gemessen: 5 Tests und 1 Probe | wichtig (Prüfstand) | nein; vor 7.2.1.0 beheben |
| [K6](#k6) | PR-Haken: `gh pr new`, Zeilenfortsetzung, `"$(gh pr create …)"`, `bash -lc` u. a. kommen durch | mittel | nein |
| [PRUEFER-51 K4, K5, K7–K11](PRUEFER-51.md#k4) | bekannt, seit `c0bbacb5` unverändert | wie dort | nein |

**Vergeben: [E-150](../Intern/BEFUNDE.md#e-150) ([K1](#k1)). Frei: [E-151](../Intern/BEFUNDE.md#e-151).** Eingetragen in
`Intern/BEFUNDE.md` ist nichts.
