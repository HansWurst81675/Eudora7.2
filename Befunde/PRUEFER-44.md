# PRÜFER-44 — 7.2.0.120: die Vervollständigungsbox, am laufenden Programm nachgerechnet

Gegenstand: **Commit `f6d525dc`** („7.2.0.120: die Auswahlbox schrumpft nicht
mehr bei jedem Cursor-Schritt"), zwei Änderungen —
`AutoCompleteSearcher.cpp` (`AutoCompleterListBox::ReCalcACListBoxPos`:
`GetClientRect` → `GetWindowRect`, die `+ 6` weg) und `nicktree.cpp:2941`
(`OnRightButtonDown`: ein `DoSelectItem(…, TRUE); EvaluateSelection();` als
Sicherung). Zweig `wt/pruefer-20261021b`, Basis
`origin/e-135-vervollstaendigungsbox`. Es geht um die Auslieferung als
**1.0.120**.

**Wie geprüft.** Am Quelltext gelesen: `AutoCompleterListBox` vollständig
(`DoACListBox`, `ReCalcACListBoxPos`, `KillACListBox`, `RemoveFirstItem`,
`RemoveLastItem`, `InitList`, `InitListDSDropDown`, `AddToACListBox`,
`SetListToControl`, `SetControlToItem`, `OnArrowKey`, `OnDeleteKey`), dazu die
Aufrufstellen in `headervw.cpp` (`CHeaderField::GetACListWindowRect`,
`OnACListDisplayed`, die beiden Füllwege bei `:1479` und `:3355`, der
`VK_DELETE`-Zweig bei `:2881`) und in
`DirectoryServices/.../DSEditImpl.cpp`, die Dialogvorlage `IDD_AUTOCOMP` in
`EudoraRes.rc:3599`, sowie in `nicktree.cpp` `OnRightButtonDown`,
`EvaluateSelection`, `OnSelChanged`, `DoDeselectAll`, `DoSelectItem`,
`IsItemSelected`.

**Vier eigene Messläufe am laufenden Programm**, alle über `tools\testlauf.ps1`
mit `tools\messen-e135.ps1` bzw. `tools\messen-k9.ps1`, Freigabe *„Gregor am
21.10.2026: e-135-vervollstaendigungsbox ist ok, mach das"*. Gemessen wurde
gegen **zwei nachweislich verschiedene EXE**: 1.0.119 (MD5 `B50D9136…`, aus
`C:\Temp\E135-box`) und ein von mir selbst gebautes 1.0.120 (MD5
`9C840EFB…`, aus `C:\Temp\E135-120`) — also eine **dritte** EXE neben den
beiden, die der Commit nennt.

Dafür habe ich `tools/messen-e135.ps1` erweitert statt ein eigenes Skript zu
bauen: es gibt jetzt zusätzlich **Position** und **Zahl der Listeneinträge**
aus und kann **Entf-Schritte** fahren, einschließlich der Antwort auf den
Rückfragedialog. Ohne diese Antwort misst der Entf-Schritt nichts (siehe
[K1](#k1)) — das ist die Positivprobe im Sinne von
[ausbleiben-ist-kein-befund](../Arbeitsweise/ausbleiben-ist-kein-befund.md).

**Gebaut und gemessen nach meiner Änderung:** `tools\bauen.ps1 -Konfiguration
Release` — **ERFOLG, 0 Fehler, 2 Warnungen**. `EudoraTests.exe` — **243 Tests,
243 bestanden, 0 fehlgeschlagen**.

---

## Urteil

> ### JA — 1.0.120 geht so raus.

**Die Behebung wirkt, und zwar an zwei verschiedenen Datenlagen gemessen**
(siehe [Die Behebung selbst](#die-behebung-selbst)). Die Box schrumpft nicht
mehr, weder bei fünf noch bei zwei Einträgen.

Sechs Funde, **keiner hält das Paket auf**. Keiner verliert Daten, keiner macht
Eudora startunfähig, alle sechs sind reine Anzeigefragen oder toter Code.

Die zwei, die wirklich etwas sind:

* [K1](#k1) — **Nach der Entf-Taste bleibt die Box zu groß.** Gemessen: von 5
  auf 2 Einträge heruntergelöscht, Höhe konstant **70 px**, richtig wären
  **40 px**. Zwei leere Zeilen. Das ist die Kehrseite von „nur noch
  verschieben" und auf diesem einen Weg eine **kleine Verschlechterung**
  gegenüber 1.0.119 — dort schrumpfte die Box dabei, wenn auch um den falschen
  Betrag. Kosmetisch.
* [K2](#k2) — **Die Box erscheint um 104/115 Pixel versetzt und springt beim
  ersten Cursor-Schritt an ihren Platz.** Gemessen, und zwar in **beiden**
  Fassungen gleich: `InitList()` gibt `MoveWindow` Bildschirmkoordinaten,
  obwohl `IDD_AUTOCOMP` `WS_CHILD` ist. **Kein Rückschritt durch 1.0.120** —
  der Fehler ist so alt wie der Code.

Meine Hauptgegenvermutung zur zweiten Änderung — die Sicherung in
`OnRightButtonDown` könne eine Mehrfachauswahl zerstören oder durch doppelte
Arbeit schaden — ist **widerlegt** ([K5](#k5)), am Quelltext und am laufenden
Programm.

---

## K1 — Nach „Entf" bleibt die Box zu groß. Gemessen. *Hält nicht auf.*

**Der Weg.** `headervw.cpp:2881` fängt `VK_DELETE` ab, solange die Box
Einträge hat, und ruft `AutoCompleterListBox::OnDeleteKey`
(`AutoCompleteSearcher.cpp:1160`). Die Funktion entfernt den Eintrag und ruft
danach `ReCalcACListBoxPos()` (`:1273`). **`InitList` wird auf diesem Weg
nicht gerufen** — am Quelltext belegt: `InitList` hat im ganzen Baum genau
drei Aufrufstellen, `headervw.cpp:1490`, `headervw.cpp:3412` und
`DSEditImpl.cpp:230`, alle drei im Füllweg nach einem Tastendruck, keine in
`OnDeleteKey`.

Damit ist seit 1.0.120 **niemand mehr für die Höhe zuständig**, wenn sich die
Zahl der Einträge ändert: `InitList` setzt sie, läuft hier aber nicht, und
`ReCalcACListBoxPos` behält sie jetzt bei.

**Gemessen** (1.0.120, `C:\Temp\E135-120`, `C:\Temp\pruefer44-lauf120b.log`):

```
E135 Schritt 5  Hoehe   70 Breite  108   links 376 oben 257   Eintraege 5
E135   Dialog [Warning!] mit Knopf [Yes] beantwortet
E135 Entf 1     Hoehe   70 Breite  108   links 376 oben 257   Eintraege 4
E135   Dialog [Warning!] mit Knopf [Yes] beantwortet
E135 Entf 2     Hoehe   70 Breite  108   links 376 oben 257   Eintraege 3
E135   Dialog [Warning!] mit Knopf [Yes] beantwortet
E135 Entf 3     Hoehe   70 Breite  108   links 376 oben 257   Eintraege 2
```

**Wie groß wäre richtig?** `InitList` rechnet
`hoehe = anzahl * (cyChar - 1) + 10`, gedeckelt auf
`IDS_INI_COMPLETER_LIST_HEIGHT` (Vorgabe **70**, `EudoraRes.rc:6936`). Aus dem
Zweieinträge-Lauf: `2 * (cyChar-1) + 10 = 40`, also `cyChar - 1 = 15`. Für
fünf Einträge wären das 85, gedeckelt auf 70 — deshalb die gemessenen 70. Nach
dem Löschen auf zwei Einträge wären **40** richtig. Gemessen: **70**. Die Box
ist **30 px zu hoch, zwei leere Zeilen**.

**Die Positivprobe war nötig.** Der erste Anlauf
(`C:\Temp\pruefer44-lauf3.log`) meldete nach drei Entf-Schritten unverändert
fünf Einträge — und das hätte man als „kein Fund" lesen können. Der Grund
stand im Quelltext: für einen Adressbucheintrag (Bild 1) fragt `OnDeleteKey`
erst mit `WarnYesNoDialog(0, IDS_DELETE_AB_ADDRESS)` nach
(`AutoCompleteSearcher.cpp:1199`). Der Gegenlauf an 1.0.119
(`C:\Temp\pruefer44-lauf119.log`) zeigte den Dialog `[Warning!]` dreimal
stehen. Erst nachdem das Skript ihn mit `BM_CLICK` auf *Yes* beantwortet,
sinkt die Eintragszahl — und erst dann misst der Schritt etwas.

**Einstufung: hält nicht auf.** Zwei leere Zeilen in einer Auswahlbox, die
beim nächsten Tastendruck ohnehin neu aufgebaut wird (`KillACListBox` +
`DoACListBox` + `InitList`, `headervw.cpp:3351–3412`). Kein Datenverlust: der
Eintrag wird korrekt entfernt und `NickFile->WriteTxt()` geschrieben.

**Gegenüber 1.0.119 ist das ein kleiner Rückschritt auf diesem einen Weg**,
und das sage ich ausdrücklich: dort schrumpfte die Box bei jedem Entf um
16 px. Richtig gewesen wären 15. Es war also nie eine Zeilenkorrektur, sondern
derselbe Rechenfehler, der zufällig in die richtige Richtung zeigte — und der
im Gegenzug bei **jedem Cursor-Schritt** zuschlug, wo er nichts zu suchen
hatte. Der Tausch ist richtig; die Lücke, die er hinterlässt, gehört in einen
eigenen Zweig.

**Der saubere Nachtrag** (nicht in diesem Paket, nicht von mir eingebaut):
`OnDeleteKey` müsste nach `DeleteItem` die Höhe neu setzen — am billigsten
durch `InitList(false)` statt `ReCalcACListBoxPos()` in `:1273`, weil
`InitList` genau diese Rechnung schon enthält und am Ende ohnehin
`OnACListDisplayed()` ruft. **Vermutung, nicht gemessen** — ich habe es nicht
gebaut, weil es eine Verhaltensänderung an einem Weg ist, den Gregor nicht
gemeldet hat.

---

## K2 — Die Box erscheint 104/115 Pixel versetzt und springt beim ersten Cursor-Schritt. Gemessen. *Hält nicht auf — und ist nicht neu.*

`IDD_AUTOCOMP` ist **`WS_CHILD`** (`EudoraRes.rc:3600`:
`STYLE DS_SETFONT | DS_FIXEDSYS | WS_CHILD | WS_CLIPSIBLINGS | WS_THICKFRAME`).
Für ein Kindfenster erwartet `MoveWindow` **Elternkoordinaten**. Vier Stellen
geben ihm stattdessen das, was `GetWindowRect` liefert, also
**Bildschirmkoordinaten**:

| Stelle | `GetWindowRect` | `ScreenToClient` | `MoveWindow` |
|---|---|---|---|
| `DoACListBox` `:516` | — (Feldrechteck) | **ja** `:525` | `:527` |
| `ReCalcACListBoxPos` `:530` | ja `:560` | **ja** `:569` | `:570` |
| `AddToACListBox` `:696` | ja `:716` | **ja** `:734` | `:736` |
| `RemoveFirstItem` `:582` | ja `:587` | **nein** | `:597` |
| `RemoveLastItem` `:600` | ja `:605` | **nein** | `:615` |
| `InitList` `:618` | ja `:622` | **nein** | `:641` |
| `InitListDSDropDown` `:657` | ja `:661` | **nein** | `:680` |

Der Unterschied ist genau der **Nullpunkt des Elternfensters auf dem
Bildschirm**. Gemessen (`C:\Temp\pruefer44-exakt.log`):

```
E135 Elternfenster 11863490 [EudoraMainWindow] Nullpunkt auf dem Bildschirm 104,115
E135 Schritt 0  Hoehe 40 Breite 100   links  480 oben  372   Eintraege 2
E135 Schritt 1  Hoehe 40 Breite 100   links  376 oben  257   Eintraege 2
```

`480 - 376 = 104`, `372 - 257 = 115`. **Schritt 0** steht direkt nach
`InitList`, **Schritt 1** nach dem ersten `ReCalcACListBoxPos`. Die Box steht
also erst falsch und springt beim ersten Cursor-Schritt an ihren Platz, genau
um den Nullpunkt des Hauptfensters.

**Warum fällt das meistens nicht auf?** Weil `InitList` am Ende
`m_pEditControl->OnACListDisplayed()` ruft (`:644`), das geht nach
`CHeaderField::OnACListDisplayed` (`headervw.cpp:2521`) → `SetListToControl(TRUE)`
→ und **wenn der getippte Text keinen Eintrag exakt trifft** (`Selection == -1`,
`AutoCompleteSearcher.cpp:866`) → `SetControlToItem(0)` → `ReCalcACListBoxPos()`
(`:1012`). Dann wird die Position sofort wieder gerade gerückt, und niemand
sieht etwas. Genau so war es im Lauf mit `ha` (fünf Treffer, kein exakter):
dort steht schon Schritt 0 auf 376/257.

Sichtbar wird es in dem Fall, in dem `SetControlToItem` **nicht** läuft: der
getippte Text ist selbst ein Listeneintrag. Dafür habe ich den Prüfstand
`C:\Temp\E135-exakt` gebaut (`NNdbase.txt` mit `hans` und `hansi`) und `hans`
getippt — Ergebnis oben.

**Nicht neu.** Derselbe Lauf an 1.0.119 (`C:\Temp\pruefer44-ex119.log`):

```
E135 Schritt 0  Hoehe 40 Breite 100   links 480 oben 372
E135 Schritt 1  Hoehe 24 Breite  84   links 376 oben 257
```

Identischer Versatz, identischer Sprung. `ReCalcACListBoxPos` hatte sein
`ScreenToClient` auch vorher schon. **Einstufung: hält nicht auf** — ein alter
Anzeigefehler, der durch 1.0.120 weder besser noch schlechter wird.

---

## K3 — `RemoveFirstItem` / `RemoveLastItem`: toter Code, aber mit dem Fehler aus [K2](#k2), nicht mit dem aus [E-135](../BEFUNDE.md#e-135). *Hält nicht auf.*

**Gemessen (Suche über den ganzen Baum):** beide Funktionen haben außer
Deklaration (`AutoCompleteSearcher.h:172,173`) und Definition **keine
Aufrufstelle**. Toter Code.

**Welchen Fehler tragen sie?** Nicht den von
[E-135](../BEFUNDE.md#e-135): sie lesen mit
`GetWindowRect` das Außenmaß und setzen das Außenmaß — das ist in sich
stimmig. Sie tragen den Fehler aus [K2](#k2): `GetWindowRect` → `MoveWindow`
**ohne** `ScreenToClient`. Würde man sie je aufrufen, spränge die Box um
104/115 Pixel.

Dazu ein zweiter Unterschied, am Quelltext belegt: die Zeilenhöhe kommt hier
aus `CClientDC dc(m_AutoCompList)` (`:586`, `:604`), in `InitList` dagegen aus
`CClientDC dc(m_AutoCompList->GetListBox())` (`:624`) — zwei verschiedene
Gerätekontexte mit möglicherweise verschiedener Schrift. Und der Abzug ist
`cyChar + 2`, während `InitList` mit `cyChar - 1` rechnet. Drei Zahlen, drei
verschiedene Vorstellungen von einer Zeile.

**Einstufung: hält nicht auf.** Nicht anfassen in diesem Paket. Wer sie
einmal braucht, ersetzt sie am besten durch `DeleteItem` + `InitList(false)`.

---

## K4 — `InitListDSDropDown` hat denselben Fehler wie `InitList`. *Hält nicht auf.*

`AutoCompleteSearcher.cpp:657` ist eine Kopie von `InitList` mit derselben
Höhenrechnung und derselben fehlenden `ScreenToClient`-Umrechnung vor
`MoveWindow` (`:680`). Aufgerufen aus
`DirectoryServices/DirectoryServicesUI/src/DSEditImpl.cpp:226` für das
Verzeichnisdienst-Aufklappfeld.

**Nicht gemessen** — der Weg braucht einen eingerichteten Verzeichnisdienst,
den dieser Prüfstand nicht hat. Am Quelltext ist er identisch zu [K2](#k2).
**Einstufung: hält nicht auf**, gehört zusammen mit [K2](#k2) in denselben
Nachtrag.

---

## K5 — Die Sicherung in `OnRightButtonDown`: kann sie etwas verschlechtern? **Nein.** *Hält nicht auf.*

Drei Gegenvermutungen, alle drei beantwortet.

**(a) Zerstört sie eine bestehende Mehrfachauswahl?** Nein, **am Quelltext
belegt**. Die neuen Zeilen stehen innerhalb von
`if (! IsItemSelected(tvhit.hItem))` (`nicktree.cpp:2933`) und **hinter**
`DoDeselectAll()` (`:2938`). Klickt man mit rechts auf ein Element, das zur
Mehrfachauswahl gehört, läuft der ganze Block gar nicht erst an. Klickt man
daneben, hat `DoDeselectAll()` die Mehrfachauswahl schon vorher
weggeräumt — von der ursprünglichen Fassung, nicht von der neuen Zeile.

**(b) Doppelte Arbeit, weil `SelectItem()` über `TVN_SELCHANGED` schon
`EvaluateSelection()` ausgelöst hat?** Ja, auf dem Normalweg — und folgenlos.
`OnSelChanged` (`:2216`) ruft `SetFocus()` und `EvaluateSelection()`. Der
zweite Durchlauf kommt zum selben Ergebnis und ruft
`g_Nicknames->UpdateAllViews(NULL, NICKNAME_HINT_DISPLAYNICKNAME, p_nickname)`
(`:1712`) mit **demselben Hinweis und demselben Zeiger**. Die Operation ist
damit idempotent. `p_nickname->NeedsReadIn()` (`:1706`) ist beim zweiten Mal
falsch, es wird nicht zweimal von der Platte gelesen. Kosten: ein zusätzlicher
Baumdurchlauf plus `RefreshRecipListDisplay()` und `RefreshBPListDisplay()`.
Dass das bei großen Adressbüchern spürbar wird, ist **Vermutung** — gemessen
habe ich es nicht.

**(c) Können danach zwei Elemente ausgewählt sein?** **Gemessen, nein.**
`tools\messen-k9.ps1` an 1.0.120 (`C:\Temp\pruefer44-k9.log`):

```
K9 ausgewaehlte Kinder vor dem Klick: 0
K9 Rechtsklick y=10  -> ausgewaehlte Kinder 0
K9 Rechtsklick y=26  -> ausgewaehlte Kinder 1
K9 Rechtsklick y=42  -> ausgewaehlte Kinder 1
K9 Rechtsklick y=58  -> ausgewaehlte Kinder 0
K9 Rechtsklick y=74  -> ausgewaehlte Kinder 0
```

Nie mehr als eins. `y=10` trifft die Wurzelzeile (eine Nicknamedatei, kein
Kind), `y=58` und `y=74` treffen unter den letzten Eintrag — dort räumt der
`else`-Zweig (`:2954`) korrekt ab. Das deckt sich mit dem, was der Commit
berichtet, und mit dem, was [PRÜFER-43 K9](PRUEFER-43.md#k9) vorhergesagt
hatte: die Vorhersage bestätigt sich **nicht**, die Zeile schadet aber auch
nicht.

**Einstufung: hält nicht auf.** Die Zeile ist eine Zusicherung, die nichts
kostet außer einem Baumdurchlauf.

---

## K6 — Byte-Disziplin. *In Ordnung.*

```
Eudora71/Eudora/AutoCompleteSearcher.cpp      CRLF 18 nur-LF 1669 >127 0
Eudora71/Eudora/nicktree.cpp                  CRLF 18 nur-LF 4856 >127 0
```

**18 CRLF** in beiden Dateien, **kein Byte über 127** — genau die Werte, die
der Auftrag nennt. Die neuen Kommentarblöcke sind reines ASCII mit `ae/oe/ue`.
Die von mir geänderte `tools/messen-e135.ps1`: **CRLF 0, nur-LF 205, >127 0** —
reines ASCII mit LF, wie die übrigen Werkzeuge.

---

## Die Behebung selbst

Unabhängig von der Messung des Commits nachgefahren, mit einer selbst gebauten
EXE (MD5 `9C840EFB…`, also eine dritte neben den beiden im Commit) und an
**zwei** Datenlagen.

**Fünf Einträge** (`ha`, `C:\Temp\pruefer44-lauf119.log` gegen
`C:\Temp\pruefer44-lauf120b.log`):

| Schritt | 1.0.119 | 1.0.120 |
|---|---|---|
| 0 | 100 × 62 | **108 × 70** |
| 1 | 84 × 46 | 108 × 70 |
| 2 | 68 × 30 | 108 × 70 |
| 3 | 52 × 14 | 108 × 70 |
| 4 | 36 × 14 | 108 × 70 |
| 5 | 20 × 14 | 108 × 70 |

**Zwei Einträge** (`hans`, `C:\Temp\pruefer44-ex119.log` gegen
`C:\Temp\pruefer44-exakt.log`):

| Schritt | 1.0.119 | 1.0.120 |
|---|---|---|
| 0 | 100 × 40 | **100 × 40** |
| 1 | 84 × 24 | 100 × 40 |
| 2 | 68 × 14 | 100 × 40 |
| 5 | 20 × 14 | 100 × 40 |

**Eine Quervergleichsprobe, die das Modell bestätigt.** Im `ha`-Lauf steht
1.0.119 schon in Schritt 0 auf 100 × 62, 1.0.120 auf 108 × 70 — genau 8 Pixel
Unterschied in **beiden** Richtungen, also **ein** Aufruf von
`ReCalcACListBoxPos`, der in 1.0.119 bereits vor der ersten Messung gelaufen
ist (über `OnACListDisplayed` → `SetListToControl` → `SetControlToItem(0)`).
Im `hans`-Lauf dagegen stehen **beide** Fassungen in Schritt 0 auf 100 × 40 —
weil dort der exakte Treffer `SetControlToItem` überspringt (siehe
[K2](#k2)) und `ReCalcACListBoxPos` eben noch nicht gelaufen ist. Die
Differenz von 8 Pixel je Aufruf und das Ausbleiben des Aufrufs sind damit
**unabhängig voneinander belegt**.

Dass die Breite im `ha`-Lauf 108 statt 100 beträgt, ist kein Ausreißer:
`AddToACListBox` (`:696`) verbreitert die Box auf
`strlen(string) * cxChar + 45`, wenn ein Eintrag länger ist.

---

## Was ich geändert habe

Nur ein Werkzeug, keine Quelldatei von Eudora:

* `tools/messen-e135.ps1` — gibt jetzt zusätzlich **Position** (links/oben auf
  dem Bildschirm), die **Zahl der Listeneinträge** (`LVM_GETITEMCOUNT`) und
  den **Nullpunkt des Elternfensters** aus; neu `-Entfernen <n>` für
  Entf-Schritte samt Beantwortung des Rückfragedialogs über `BM_CLICK` auf ein
  **gemessenes Knopf-Handle** (nie ein Tastendruck,
  [keine-tastendruecke-verschicken](../Arbeitsweise/keine-tastendruecke-verschicken.md));
  `E135_TIPPEN` und `E135_ENTFERNEN` als Umgebungsvariablen, weil
  `testlauf.ps1` nur `-Pfadfilter` durchreicht.

**Gemessen nach der Änderung:** Release gebaut — **ERFOLG, 0 Fehler, 2
Warnungen**; `EudoraTests.exe` — **243 Tests, 243 bestanden**.

An `AutoCompleteSearcher.cpp` und `nicktree.cpp` habe ich **nichts** geändert.
[K1](#k1), [K2](#k2), [K3](#k3) und [K4](#k4) sind Verhaltensänderungen an
Wegen, die Gregor nicht gemeldet hat; sie gehören in einen eigenen Zweig nach
1.0.120.

---

## Was diese Prüfung nicht abdeckt

* **Den Verzeichnisdienst-Weg** (`DSEditImpl.cpp`, `InitListDSDropDown`,
  `SetListToControlDS`, `SetControlToItemDS`). Gelesen, nicht gemessen — der
  Prüfstand hat keinen eingerichteten Dienst.
* **Das Kontextmenü im Adressbuch.** `messen-k9.ps1` zählt ausgewählte
  Kinder, nicht die Menüpunkte. Ob *Delete* und *Rename* nach einem
  Rechtsklick wirklich anklickbar sind, hat niemand gemessen — weder vor noch
  nach der Sicherung.
* **Die Box bei abgeschalteter Vervollständigung** und bei
  `IDS_INI_AUTO_COMP_LIST_ONLY` (`SetControlToItem` `:748` steigt dann früh
  aus). Nicht gemessen.
* **Mehrere Adressen im `To:`-Feld.** Alle Läufe hatten genau eine
  angefangene Adresse. `SetListToControl` sucht über Kommagrenzen
  (`:838–845`); der zweite und dritte Eintrag in derselben Zeile ist
  ungemessen.
