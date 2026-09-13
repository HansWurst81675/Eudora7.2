# PRUEFER-9 — Zwei Schranken zum Fensterverhalten (E-76, E-84), und sieben tote Stellen in `OTShim`

| | |
|---|---|
| Datum | 13.09.2026 |
| Arbeitsbaum | `C:\Users\Gregor\Documents\github\Eudora7.2-wt-pruefer` |
| Zweig | `wt/pruefer`, ausgehend von `origin/main` (`da95db4`) |
| Gemessen an | dem Quelltext selbst und den Commits `c060648^`, `c060648`, `643a634^`, `643a634` |
| Nicht getan | **nicht gebaut, kein Programm gestartet.** Geändert wurden nur `tools/`, `Arbeitsweise/` (Gedächtnisabgleich) und diese Datei |

**Kurzfassung.** Zwei Schranken gebaut, jede mit eigener Gegenprobe: zusammen
**31 Gegenproben**, alle 31 grün. Zwei davon fahren den **echten Fehler** aus
dem Commit vor der jeweiligen Behebung vor, und beide haben ihn gefangen.
Unterwegs **zwei Commits** gesetzt und gepusht, je einer pro fertiger
Schranke.

Die Gegenprobe hat einen Fehler **in meiner eigenen Schranke** gefunden: zwei
Fälle, die scheitern mussten, blieben stumm. Ursache und Behebung stehen unter
Punkt 1.

Beim Nachsehen auf tote Weiterleitungen sind **sieben Stellen** in `OTShim`
aufgefallen, vier davon mit echter Logik, die nie läuft. Dazu **zwei
Kommentare, die das Gegenteil behaupten**. Nichts davon behoben — Punkt 3.

---

## 1. Die beiden Schranken

| Schranke | bewacht | Gegenproben | fängt den echten Fehler |
|---|---|---|---|
| `tools/pruefe-fenster-ziehen.pl` | **E-76** — `CalcDynamicLayout` darf beim COMMIT nicht aus `nLength` rechnen | **14** (9 melden, 5 still) | ja: die echten Dateien aus `c060648^` |
| `tools/pruefe-leistengroessen-paar.pl` | **E-84** (und rückwirkend **E-70**) — `GroessenSichern` und `GroessenLaden` bleiben paarig | **17** (14 melden, 3 still) | ja: die echten Dateien aus `643a634^` |

Beide melden bei Fehlschlag **was fehlt, warum es zählt und was zu tun ist**.
Beide lesen nur Code; Kommentare werden weggeworfen, weil die Begründung
beider Behebungen den alten fehlerhaften Zustand wörtlich zitiert (Lehre
*Schranke liest nur Code*).

### `pruefe-fenster-ziehen.pl` — E-76

Der Kern ist nicht „gibt es den Merker", sondern **unter welcher Bedingung aus
`nLength` gerechnet wird**. Die Schranke geht jede Zuweisung an `size.cx` /
`size.cy` durch, die `nLength` verwendet, und sucht rückwärts die Bedingung,
unter der sie steht:

* ein **nacktes `else`** — der alte Zustand — fällt durch, weil der
  abschließende Aufruf `LM_COMMIT|LM_HORZ` **ohne** `LM_LENGTHY` trägt und
  deshalb genau dort hineinfällt, mit `nLength` als **Breite** (780) statt als
  gezogener Höhe (299);
* eine unbedingte Anweisung fällt durch;
* eine Bedingung, die weder `LM_LENGTHY` noch `LM_COMMIT` nennt, fällt durch;
* ein richtig bedingter Zweig, der das Ergebnis **nicht** in
  `m_szZuletztGezogen` nachträgt, fällt ebenfalls durch — er ließe den COMMIT
  auf einem veralteten Wert sitzen.

Dazu: das Feld in `OTShim.h`, seine Anfangsbelegung auf `(0,0)` (der
COMMIT-Zweig unterscheidet „nie gezogen" genau an dieser Null), und im
`LM_COMMIT`-Zweig kommt `nLength` überhaupt nicht vor.

Der Testfall *„eine andere, ebenso richtige Schreibweise des Schutzes"*
(`else if (!(dwMode & (LM_COMMIT | LM_LENGTHY)))`) belegt, dass die Schranke
die **Absicht** prüft und nicht eine Formulierung abnickt.

### `pruefe-leistengroessen-paar.pl` — E-84

E-70 und E-84 sind **zweimal dieselbe Fehlerklasse**: ein Schlüssel, den nur
eine Seite kennt. Einmal fehlte das Lesen (der Aufruf stand in
`SECToolBarManager::LoadState`, über der der eigene Kommentar *„Eudora ruft
diese Fassung nie auf"* steht), einmal das Schreiben (der erste Anlauf saß in
`SECControlBarInfo::SaveState`, die beim Speichern nicht durchlaufen wird).
Beide Male: kein Fehler, keine Meldung, kein Absturz — nur die Vorgabegröße
beim nächsten Start.

Die Schranke hält deshalb sieben Dinge fest:

1. beide Funktionen gibt es;
2. **Paarigkeit** — die Schlüsselnamen sind auf beiden Seiten dieselbe Menge
   (heute vier: `DockVertCx`, `DockHorzCy`, `FloatCx`, `FloatCy`);
3. jeder Schlüssel wird auch wirklich geschrieben bzw. gelesen. Einen Namen zu
   bilden und nichts damit zu tun, rutschte sonst durch die Paarigkeit durch;
4. `m_szFloat` kommt auf **beiden** Seiten vor. Ohne diese Prüfung ließe sich
   E-84 wieder aufreißen, indem man die Float-Schlüssel auf beiden Seiten
   entfernt — paarig und trotzdem falsch. Der Testfall dafür liefert exakt
   dieselben zwei Mängel wie der echte Stand `643a634^`;
5. der **lebende Weg** hängt: `QCToolBarManager::SaveState` →
   `SECToolBarManager::SaveState` → `GroessenSichern`, und
   `QCToolBarManager::LoadState` → `GroessenLaden`. Der Testfall „der Aufruf
   verschwindet aus dem lebenden Weg" **ist** E-70;
6. der INI-**Abschnitt** wird an allen Stellen aus derselben Formatangabe
   gebildet (siehe Punkt 4);
7. in `SECControlBarInfo::SaveState` und `::LoadState` steht **kein**
   Profilzugriff — der Ort sieht richtig aus und wird nie durchlaufen.

Anders als die erste Schranke liest diese Code **mit** Zeichenketten: die
Schlüsselnamen *sind* Zeichenketten. Weggeworfen werden nur die Kommentare;
der Testfall *„ein Kommentar am toten Ort zitiert den alten Anlauf"* belegt,
dass das reicht.

### Was die Gegenprobe an meiner eigenen Schranke gefunden hat

Beim ersten Lauf von `pruefe-fenster-ziehen-tests.pl` blieben **zwei von
vierzehn** Fällen stumm, die scheitern mussten — *„aus dem Schutz wird wieder
ein nacktes else"* und *„der LENGTHY-Zweig trägt nicht mehr nach"*. Beides
sind die Fälle, die dem echten Fehler am nächsten liegen.

Ursache: die Suche nach dem `LM_COMMIT`-Zweig endet mit `last` und ließ
`pos($rumpf)` hinter dem gefundenen `if` stehen. Die nächste `//g`-Schleife
fing deshalb erst **hinter** den beiden Zuweisungen an, um die es geht.
Behoben mit einem ausdrücklichen `pos($rumpf) = 0` und einem Kommentar, der
sagt warum.

Das ist die Lehre *Schranke gegentesten* in einem Satz: ohne die Gegenprobe
wäre eine Schranke entstanden, die auf dem heutigen Stand grün ist, den
bewachten Fehler aber durchlässt — **stumm, und damit schlimmer als gar
keine.**

---

## 2. Der jetzige Stand beider Dateien — Reste

Geprüft auf das, was den Bau zweimal zurückgeschickt hatte (`C2065`, `C2084`).

| geprüft | Ergebnis |
|---|---|
| doppelte Funktionsrümpfe (`C2084`) | **keine.** 290 qualifizierte Rumpfdefinitionen in `OTShim.cpp`, 238 in `OTShim_Werkzeugleiste.cpp`, 3 in `OTShim.h` — jede Signatur genau einmal |
| verwaiste Initialisierung (`C2065`) | **keine.** `m_szZuletztGezogen` ist in `OTShim.h:530` als Feld von `SECControlBar` deklariert und ausschließlich in `SECControlBar::SECControlBar` (`OTShim.cpp:1802`) belegt. In den beiden Konstruktoren von `SECControlBarInfo` (`OTShim.cpp:5254`, `:5276`) kommt es nicht vor; das dort belegte `m_szFloat` ist ein echtes Feld der Klasse (`OT501/Include/sdocksta.h:97`) |
| auskommentierter Code, `#if 0` | **keine Stelle** in beiden Dateien und in `OTShim.h` |
| Kommentar, der auf eine Lösung woanders zeigt | **einer, und er ist richtig:** `OTShim.cpp:5330` in `SECControlBarInfo::SaveState` benennt den toten Ort ausdrücklich und verweist auf `GroessenSichern`. Der Rumpf enthält nur noch `return CControlBarInfo::SaveState(...)`. Die Rücknahme war vollständig |
| baut der jetzige Stand? | **ja, gemessen am Zeitstempel.** Letzter Commit an den Quellen: `643a634`, 11.09. 21:51:09. Bau im Hauptbaum: `OTShim.obj` 22:04:18, `OTShim_Werkzeugleiste.obj` 22:03:22, `Eudora.exe` 22:04:35 — also **nach** der letzten Quelländerung. Die spätere Dateizeit 22:16:47 im Arbeitsbaum stammt vom Auschecken zu `7462e81` (22:16:48), das keine der beiden Dateien angefasst hat |

---

## 3. Weitere tote Weiterleitungen in `OTShim` — gemeldet, nicht behoben

Der Auftrag fragte, ob es **weitere** Stellen gibt, die aussehen wie eine
Umsetzung und nie erreicht werden. Es gibt sie. Ich habe jeden Fund selbst
nachgegriffen; die Aufrufzahlen unten sind gemessen über
`Eudora71/Eudora` + `Eudora71/OTShim`, nur Quelldateien.

**Mit echter Logik — die wiegen:**

| Ort | was tot ist | Beleg |
|---|---|---|
| `OTShim_Werkzeugleiste.cpp:4234` `SECToolBarManager::SetDefaultDockState` | Die Funktion **wird** gerufen (`QCToolBarManager.cpp:1168`), aber ihr Schleifenrumpf (4239–4257: `SetButtons`, `EnableDocking`, `DockControlBar`, `ShowControlBar`) läuft nie: `m_defaultBars` ist immer leer. Ausgeführt wird nur `RecalcLayout()` in 4259 | Einziger Schreiber ist `m_defaultBars.Add` (4209) in `DefineDefaultToolBar` (4190) — und die hat **im ganzen Baum keinen Aufrufer**, nur Deklaration (`OTShim_Werkzeugleiste.h:1067`) und Definition |
| `OTShim_Werkzeugleiste.cpp:2414` `SECCustomToolBar::SetBarInfoEx` | Stellt die **Knopfbelegung** wieder her: `SetButtons(pIDs, nCount)` und je Knopf `SetBtnInfo(...)` — bei einem `SECWndBtn` ist das die gezogene Breite. Läuft nie | Einziger Einstieg wäre `SECControlBar::SetBarInfo` (`OTShim.cpp:2374`). `CControlBar::SetBarInfo` ist in `afxext.h` **nicht virtuell** — dasselbe Muster wie bei `SECControlBarInfo::SaveState`. Und der einzige Aufruf in Eudora (`WazooBarMgr.cpp:501/503`) geht auf ein `CWazooBar`, und `class CWazooBar : public SECControlBar` (`WazooBar.h:60`) — **kein** `SECCustomToolBar` |
| `OTShim_Werkzeugleiste.cpp:3262/3315/3332` `SECCustomToolBarInfoEx::Serialize` / `SaveState` / `LoadState` | Vollständiges Archivformat und ein eigenes INI-Format `"Titel,ID,ID,…"` unter dem Schlüssel `Buttons`. Kein Aufrufer | Der Weg wäre `SECControlBarInfo::Serialize/SaveState/LoadState` → `m_pBarInfoEx->…`; die Shim-Fassungen (`OTShim.cpp:5308/5321/5328`) reichen nur an `CControlBarInfo::…` durch und fassen `m_pBarInfoEx` nie an. Die **Basis**fassungen `SECControlBarInfoEx::…` sind leere Dummys — die abgeleiteten ausdrücklich nicht |
| `OTShim_Werkzeugleiste.cpp:4573` / `OTShim.cpp:5467` `CreateControlBarInfoEx` | **Null externe Aufrufstellen.** Folge: `m_pBarInfoEx` wird auf dem Ladeweg nie erzeugt, und `QCToolBarManager.cpp:1375` findet dort immer `NULL` — die gespeicherte Leistenbezeichnung kommt nie zurück | grep baumweit: nur Deklaration (`OTShim_Werkzeugleiste.h:1146`), die zwei Definitionen und der Basisaufruf in 4579 |

**Ohne Gewicht, der Vollständigkeit halber:**

* `OTShim_Werkzeugleiste.cpp:4379` — der `GroessenLaden(szSection)`-Aufruf in
  `SECToolBarManager::LoadState`. Die Funktion ist als **Kategorie C**
  markiert (4341) und wird nie erreicht; die lebende Behebung steht in
  `QCToolBarManager.cpp:1199`. **Kein Funktionsverlust** — aber es ist genau
  die Stelle, an der der erste Anlauf zu E-70 ins Leere lief, und die tote
  Kopie steht noch da.
* `OTShim_Werkzeugleiste.cpp:3895` `EnableLargeBtns` — einziger Aufrufer ist
  Zeile 4360, also innerhalb der toten `LoadState`. Ehrlich als Kategorie C
  dokumentiert.
* `OTShim_Werkzeugleiste.cpp:3862` `EnableFlyBy` — **kein Aufrufer im ganzen
  Baum.** Auffällig asymmetrisch: `EnableToolTips` und `EnableCoolLook` werden
  aus Eudora gesetzt, `EnableFlyBy` nirgends; `m_bFlyBy` behält damit dauerhaft
  den Konstruktorwert, wird aber in `DynCreateControlBar` (4604) ausgewertet.
* `OTShim_Werkzeugleiste.cpp:4212` `GetDefaultBtns` — liefert aus demselben
  Grund wie Fund 1 immer `FALSE`, und hat zusätzlich keinen Aufrufer.

**Ausdrücklich geprüft und KEIN Befund** — damit niemand sie ein zweites Mal
untersucht: `SECControlBar::CalcInsideRect` (dreistellig, `OTShim.cpp:2127`,
erreichbar über `GetInsideRect` und direkt aus `QCCustomToolBar.cpp:162`, die
E-66-Behebung wirkt also); `SECDockBar::Get/SetBarInfo`;
`SECDockState::Save/LoadState/Clear`; `SECWorkbook::OnViewWorkbook` und
Geschwister; `SECFrameWnd::OnNcM/RButtonDown`; die
`SECDockBar`-Zeilenhelfer — alle entweder erreichbar oder reines Durchreichen
ohne Logik.

### Zwei Kommentare behaupten das Gegenteil

Das wiegt schwerer als die toten Funktionen selbst, weil ein Kommentar das
ist, was der nächste liest:

* `OTShim_Werkzeugleiste.cpp:4229-4232` über `SetDefaultDockState`:
  *„GEBRAUCHT … Ohne diese Fassung stände Eudora dann ohne Werkzeugleiste
  da."* Nicht haltbar — der Schleifenrumpf läuft nie.
* `OTShim.cpp:5300-5302`: *„QCToolBarManager legt es an … die Zusatzschicht
  erzeugt es über `CreateControlBarInfoEx`"* — `CreateControlBarInfoEx` hat
  keinen Aufrufer.

---

## 4. Drei Stellen, an denen derselbe Wert steht

Der INI-Abschnittsname wird **dreimal** gebildet, in zwei Dateien:

| Ort | Formatangabe |
|---|---|
| `OTShim_Werkzeugleiste.cpp:4336` | `_T("%s-ToolBarManager")` |
| `QCToolBarManager.cpp:1126` | `_T("%s-ToolBarManager")` |
| `QCToolBarManager.cpp:1198` (inline, an `GroessenLaden`) | `_T("%s-ToolBarManager")` |

Heute stimmen alle drei überein. Fiele eine auseinander, schriebe die eine
Seite in einen Abschnitt, den die andere nie aufschlägt — dasselbe Ergebnis
wie ein fehlender Schlüssel, nur schwerer zu finden.
`pruefe-leistengroessen-paar.pl` hält sie jetzt gegeneinander; die Gegenproben
*„die Schreibseite bildet einen anderen Abschnittsnamen"* und *„die Leseseite
…"* belegen es. **Zusammenlegen wäre besser als bewachen** — das ist eine
Codeänderung und gehört nicht in diesen Lauf.

---

## 5. Die Spurmarke zu E-76 steht noch drin, und die Übersicht sagt das Falsche

`OTShim.cpp:2032` sagt über sich selbst: *„SIE GEHÖRT WIEDER RAUS, sobald E-76
verstanden ist."* E-76 **ist** verstanden und von Gregor am 11.09.2026
bestätigt — die Marke hat den Befund entschieden, ihre vier Zeilen stehen
wörtlich in der Commit-Nachricht von `c060648`.

`Befunde/SPURMARKEN.md:37` führt E-76 aber weiter als
*„entfällt: braucht eine gedrückte Maustaste"*, und `spuren-auswerten.pl`
zählt sie deshalb unter **„bewusst offen (entfällt)"** statt unter
„ausgewertet" — und gibt 0 zurück. Die Schranke ist an dieser Stelle blind
für genau den Zustand, gegen den sie gebaut wurde (Lehre *Eingebaute Messung
auslesen*).

**Zu tun, in einem Arbeitsschritt:** die Marke aus `OTShim.cpp` entfernen
(`E76Marke`, die beiden Aufrufe und die beiden Hilfszeilen `bSchwebt` /
`szVorher`, soweit sie danach unbenutzt sind) und `SPURMARKEN.md` auf
*ausgewertet 1.0.41* setzen. Beides ist Code bzw. Chronistenarbeit und nicht
meine.

---

## 6. Wo meine Auftragsbeschreibung nicht stimmte

Nichts Wesentliches. Beide Darstellungen — der `dwMode`-Wechsel beim COMMIT
und der falsche Ort des ersten E-84-Anlaufs — habe ich an den genannten
Commits nachgemessen und bestätigt gefunden. Zwei Ergänzungen:

1. Der erste E-84-Anlauf hat nicht nur „nichts bewirkt", sondern ist
   **vollständig zurückgenommen worden**: in `SECControlBarInfo::SaveState`
   steht heute nur noch der Kommentar, der den Irrtum benennt. Das ist
   besser als beschrieben.
2. Die Aufgabe nannte `GroessenSichern`/`GroessenLaden` als Paar. Das Paar ist
   in Wahrheit **dreiteilig**: dazu kommt der Abschnittsname, der an drei
   Stellen gebildet wird (Punkt 4). Ein Schlüssel im falschen Abschnitt ist
   derselbe Ausfall wie ein fehlender Schlüssel; die Schranke prüft deshalb
   beides.

---

## 7. Vorcommit-Prüfungen

Vor **jedem** der beiden Commits gelaufen, jedes Mal alle 0:

| Prüfung | Rückgabe |
|---|---|
| `tools/doku-pruefen.pl` | 0 |
| `tools/pruefe-bytes.pl` | 0 |
| `tools/pruefe-befundurteile.pl` | 0 |
| `tools/pruefe-doku-takt.pl` | 0 |
| `tools/pruefe-stand-md.pl` | 0 |
| `tools/offene-befunde.pl` | 0 |
| `tools/lehren-uebersicht.pl` | 0 |
| `tools/spuren-auswerten.pl` | 0 |
| `tools/pruefe-fenster-ziehen-tests.pl` | 0 (14 von 14) |
| `tools/pruefe-leistengroessen-paar-tests.pl` | 0 (17 von 17) |

`lehren-uebersicht.pl` stand beim ersten Lauf auf 1: eine neue Lehre
(`agent-vor-dem-ende-nicht-starten`) war aus dem Gedächtnisabgleich gekommen
und fehlte in der Tabelle. Mit `-schreiben` neu gesetzt, 56 Lehren, 56 Zeilen.
