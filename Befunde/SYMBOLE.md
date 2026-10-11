# E-30 — Gesperrte Werkzeugleistenknöpfe bleiben leere graue Flächen

Agent SYMBOLE, 06.09.2026. Branch `wt/symbole` (von `strg-n-absturz`, Stand
7.2.0.13 / Paket 1.0.13).

Gregors Meldung zur Fassung 7.2.0.10, auf einem Rechner **ohne** Visual Studio:

> test bestanden: eudora läuft ohne VS2022 installiert. es fehlen noch icons,
> bzw. nicht alle werden vollständig angezeigt.

Auf seinen zwei Bildschirmfotos:

* **Hauptfenster, Postfach „In" aktiv** — die Werkzeugleiste zeigt alle Symbole.
* **Fenster „Find Messages" aktiv** — an mehreren Stellen derselben Leiste
  stehen leere graue Flächen, und zwar genau dort, wo der Knopf in diesem
  Zusammenhang nicht anwendbar, also **gesperrt** ist.

**Ursache gefunden: ja. Behoben: ja. Gemessen, nicht vermutet.**

---

## 1. Die Kurzfassung

Es fehlt kein einziges Symbol. Was fehlt, ist die **Umsetzung des
Bildhintergrunds auf die Knopffarbe** — und daran scheitert dann die
Darstellung des *gesperrten* Zustands.

| | |
|---|---|
| **Wo** | `Eudora71/OTShim/OTShim_Werkzeugleiste.cpp`, Ladeweg der Leistenbitmap |
| **Was** | `CBitmap::LoadMappedBitmap` setzt Bitmaps **ohne Farbtabelle** nicht um |
| **Folge 1** | gesperrter Knopf → einheitliche graue Fläche statt geprägtem Symbol |
| **Folge 2** | freigegebener Knopf → Symbol auf sichtbar dunklerem Quadrat |
| **Warum unter VC6 nicht** | dort war `COLOR_BTNFACE` selbst 192,192,192 |

---

## 2. Die Messung

### 2.1 Was `CreateMappedBitmap` wirklich tut

`CBitmap::LoadMappedBitmap` ist eine Zeile Inline-Code
(`atlmfc/include/afxwin1.inl:193`) und ruft `comctl32!CreateMappedBitmap`.
Ein eigenes Messprogramm hat vier Bitmapressourcen durch diese Funktion
geschickt und den obersten Punkt der fertigen Bitmap zurückgelesen. Auf
diesem Rechner ist

    COLOR_3DFACE    = 240,240,240
    COLOR_3DSHADOW  = 160,160,160
    COLOR_3DHILIGHT = 255,255,255

| Ressource | Farbtiefe | 192,192,192 wird zu | 128,128,128 wird zu |
|---|---|---|---|
| `res/icons/tbar16.bmp` (Hauptleiste) | 24 Bit | **192,192,192 — unverändert** | unverändert |
| `res/icons/RTB1.bmp` (Lesefenster) | 8 Bit | **240,240,240** | 160,160,160 |
| künstlich, 4×2 | 24 Bit | 192,192,192 — unverändert | unverändert |
| künstlich, 4×2 | 8 Bit | 240,240,240 | 160,160,160 |

**`CreateMappedBitmap` setzt nur die Farbtabelle um.** Eine Bitmap mit mehr
als 8 Bit Farbtiefe hat keine, und bleibt deshalb, wie sie ist.

Nebenbefund derselben Messung: **unter ComCtl32 5.82 stürzt
`CreateMappedBitmap` bei einer 24-Bit-Ressource ab** (Zugriffsfehler). Eudora
überlebt das nur, weil `Eudora71/Eudora/Eudora.manifest` ausdrücklich Fassung
6 anfordert. Nach dieser Behebung hängt der Ladeweg der Leistenbitmaps nicht
mehr davon ab.

### 2.2 Welche Bitmaps betroffen sind

`tools/pruefe-symbole.pl -v` misst es aus den Ressourcen:

| Ressource | Datei | Maße | Farbtiefe |
|---|---|---|---|
| `IDR_MAINFRAME16` | `res/icons/tbar16.bmp` | 1024×16 | **24 Bit** |
| `IDR_MAINFRAME16A` | `res/icons/tbar16a.bmp` | 976×16 | **24 Bit** |
| `IDR_MAINFRAME16B` | `res/icons/tbar16b.bmp` | 816×16 | **24 Bit** |
| `IDR_MAINFRAME32` | `res/icons/tbar32.bmp` | 2048×32 | **24 Bit** |
| `IDR_MAINFRAME32A` | `res/icons/tbar32a.bmp` | 1952×32 | **24 Bit** |
| `IDR_MAINFRAME32B` | `res/icons/tbar32b.bmp` | 1632×32 | **24 Bit** |
| `IDR_READMESS` | `res/icons/RTB1.bmp` | 510×17 | 8 Bit |
| `IDR_COMPMESS` | `res/icons/comptbar.bmp` | 666×16 | 8 Bit |
| `IDB_IL_STATUS`, `IDB_IL_STATUSM` | `il_status*.bmp` | 400×16 | 8 Bit |
| `IDC_PEANUT_TOOLBAR` | `PeanutToolbar.bmp` | 176×15 | 4 Bit |

Genau die sechs Bitmaps der **Hauptwerkzeugleiste** sind 24 Bit — und genau
die Hauptwerkzeugleiste ist die, auf der Gregor die leeren Flächen sieht.
Die Leisten der Nachrichtenfenster (8 Bit) sind in Ordnung. Das erklärt sein
„**nicht alle**".

Der Hintergrund dieser Bitmaps ist gemessen 192,192,192 und mit Abstand die
häufigste Farbe:

| Datei | Anteil 192,192,192 | Farben insgesamt |
|---|---|---|
| `tbar16.bmp` | 44,8 % | 1196 |
| `tbar16a.bmp` | 56,1 % | 1374 |
| `tbar16b.bmp` | 36,2 % | 1439 |

### 2.3 Wie daraus eine leere Fläche wird

`SECStdBtn` zeichnet einen gesperrten Knopf in drei Schritten:

1. **`DrawFace`** füllt den Knopf mit `secData.clrBtnFace`
   (= `GetSysColor(COLOR_BTNFACE)` = 240,240,240) und kopiert das Symbol
   hinein.
2. **`CreateMask`** kopiert den Knopfpuffer nach *einfarbig* und setzt dabei
   `clrBtnFace` als Hintergrundfarbe der Quelle. GDI-Regel: was diese Farbe
   hat, wird 1, alles Übrige 0.
3. **`DrawDisabled`** malt den Prägepinsel überall dort, wo die Maske **0**
   ist (Verknüpfungszahl `0x00B8074A`).

Bringt das Symbol seinen eigenen, um 48 Stufen dunkleren Hintergrund mit,
dann trifft Schritt 2 nicht das Symbol, sondern **das ganze Bildrechteck** —
und Schritt 3 übermalt es vollständig.

Das ist im Testprogramm nachgemessen, mit derselben GDI-Folge, ohne Fenster
(`Eudora71/Tests/TestSymbole.cpp`, Abschnitt D):

| Bildhintergrund | Maskenpunkte auf 0 | übermalte Punkte | Ergebnis |
|---|---|---|---|
| = `COLOR_BTNFACE` | 15 von 256 | 28 | geprägtes Symbol |
| 192,192,192 | **64 von 256** (= 8×8, das ganze Bild) | **79** | **leere graue Fläche** |

Damit ist die Ursachenkette lückenlos belegt.

---

## 3. Die Behebung

`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp` bekommt zwei neue Funktionen:

* **`OTShimDibFarbeErsetzen(pDib, dwGroesse, crVon, crNach)`** — ersetzt in
  einem DIB im Speicher jeden Punkt einer Farbe durch eine andere. Reine
  Rechnung auf einem Speicherblock, ohne GDI, ohne Fenster, mit Schranke
  gegen das Herauslaufen aus dem Puffer. Liefert `-1` für alles, was sie
  nicht behandelt (Farbtabelle vorhanden, gepackt, unplausible Maße).
* **`SECLadeWerkzeugleistenBitmap(bmp, nID)`** — der neue Ladeweg:
  bis 8 Bit unverändert über `CBitmap::LoadMappedBitmap` (dieser Weg ist
  erprobt, comctl32 macht es richtig), ab 16 Bit mit eigener Umsetzung des
  Hintergrunds auf `COLOR_BTNFACE`.

Benutzt wird sie an den beiden Stellen, an denen die Schicht eine
Leistenbitmap holt: in `SECLoadToolBarResource` (das ist der Weg, den Eudora
geht — `QCToolBarManager.cpp:346, 354, 360`) und in
`SECCustomToolBar::LoadBitmap`.

### Warum nur der Hintergrund umgesetzt wird

`CreateMappedBitmap` setzt bei Bitmaps mit Farbtabelle drei Farben um:
192,192,192 → `COLOR_3DFACE`, 128,128,128 → `COLOR_3DSHADOW`,
255,255,255 → `COLOR_3DHILIGHT`. Bei den 24-Bit-Bitmaps wäre das falsch:
dort sind 128,128,128 und 255,255,255 **echte Bildfarben** (gemessen: 121
bzw. 342 Punkte allein in `tbar16a.bmp`), keine Systemfarbenplätze. Sie
mitzusetzen würde die Symbole selbst verändern. Umgesetzt wird deshalb nur
die eine Farbe, die den Fehler verursacht.

---

## 4. Testfälle

Gregors Auflage: „für den fehler: testfälle erweitern und dokumentieren."

### 4.1 `Eudora71/Tests/TestSymbole.cpp` — 7 Fälle im Testprogramm

Läuft mit `Eudora71/Tests/RunTests.cmd`, ohne Fenster, ohne Eudora zu starten.

| Fall | prüft |
|---|---|
| `OTShimDibFarbeErsetzen trifft genau die gesuchte Farbe` | 12 von 15 Punkten umgesetzt, die drei anderen Farben unangetastet |
| `… kann auch 32 Bit` | derselbe Weg bei 32 Bit |
| `… weist ab, was es nicht kann` | Farbtabelle, gepackt, abgeschnittener Block, Nullzeiger, Zwergblock — alle `-1`, keiner läuft aus dem Puffer |
| **`24-Bit-Leiste bekommt beim Laden die Knopffarbe`** | **die Schranke**: ruft den produktiven `SECLoadToolBarResource` mit der echten `tbar16.bmp` und misst den Hintergrund der geladenen Bitmap |
| `8-Bit-Leiste geht weiter über comctl32` | der alte Weg mit der echten `RTB1.bmp` funktioniert unverändert |
| `passender Bildhintergrund ergibt ein geprägtes Symbol` | Maske und Prägung wie in `SECStdBtn`, 15 Maskenpunkte |
| `unpassender Bildhintergrund ergibt eine leere Fläche` | dieselbe Folge, 64 Maskenpunkte — der Fehler selbst, festgenagelt |

Das Testprogramm fordert jetzt dasselbe ComCtl32 6 an wie Eudora
(`AdditionalManifestDependencies` in `Tests.vcxproj`) — sonst stürzt es beim
alten Ladeweg ab, statt eine Abweichung zu melden.

Die Ressourcen dafür stehen in `Eudora71/Tests/Tests.rc` und binden
**absichtlich die echten Bitmaps** aus `Eudora71/Eudora/res/icons` ein, keine
nachgebauten.

### 4.2 `tools/pruefe-symbole.pl` — statische Prüfung ohne Übersetzer

Fünf Prüfungen über alle `TOOLBAR`-Ressourcen:

1. Zu jeder `TOOLBAR` gibt es eine `BITMAP` derselben Kennung.
2. Jede genannte Bilddatei liegt im Dateisystem.
3. Jeder Knopf hat ein Bild (Breite ÷ Bildbreite gegen die Knopfzahl).
4. **Keine Ladestelle in der Ersatzschicht holt eine Leistenbitmap noch
   allein über `CBitmap::LoadMappedBitmap`**, solange es Leisten mit mehr als
   8 Bit gibt.
5. Der Hintergrund dieser Leisten ist tatsächlich 192,192,192 — sonst griffe
   die Umsetzung ins Leere.

Dazu `tools/pruefe-symbole-tests.pl` mit **12 Fällen** auf künstlichen
Arbeitsbäumen. **Wer `pruefe-symbole.pl` anfasst, lässt sie laufen.**

### 4.3 Der Nachweis, dass die Tests etwas taugen

Ein Test, der auch vor der Behebung grün war, beweist nichts. Beide wurden
deshalb gegen den **unbehobenen** Stand laufen gelassen:

    # nur die Änderung an OTShim weggelegt, alles andere wie behoben
    git stash push -- Eudora71/OTShim/OTShim_Werkzeugleiste.cpp \
                      Eudora71/OTShim/OTShim_Werkzeugleiste.h

| | vor der Behebung | nach der Behebung |
|---|---|---|
| `TestSymbole.cpp` | **`[FEHL]` 24-Bit-Leiste** — `Ecke = 192,192,192, COLOR_BTNFACE = 240,240,240`; 115 von 116 | 116 von 116 |
| dieselbe Datei ohne ComCtl32-6-Manifest | **Absturz** des Testprogramms | — |
| `pruefe-symbole.pl` | **2 Abweichungen**, Rückgabe 1 | Keine Abweichung, Rückgabe 0 |
| `pruefe-symbole-tests.pl` | — | 12 von 12 |

Die 8-Bit-Leiste blieb im roten Lauf grün. Auch das ist ein Beleg: die
Abweichung hängt an der Farbtiefe, nicht an irgendetwas anderem.

---

## 5. Zwei Ungereimtheiten im Altbestand

`tools/pruefe-symbole.pl` meldet sie als **Hinweis**, nicht als Fehler — sie
stammen aus der Originalauslieferung und sind folgenlos:

* **`IDB_IL_STATUS`** — 25 Bilder in `il_status.bmp`, aber nur 23 Knöpfe in
  der `TOOLBAR`-Ressource. Die zwei überzähligen werden nie geholt. (Diese
  Ressource ist ohnehin keine echte Leiste, sondern eine Bilderliste.)
* **`IDR_COMPMESS`** — die `TOOLBAR`-Zeile nennt die Bildhöhe 17,
  `comptbar.bmp` ist aber nur 16 hoch. `BitBlt` beschneidet das
  Quellrechteck; der Knopf wird einen Punkt höher, es fehlt kein Bildinhalt.

Beides ist **nicht** angefasst worden: es sind Originaldaten, und die
Änderung wäre eine Verschlimmbesserung ohne Messwert dahinter.

---

## 6. Was hier **nicht** geprüft ist

* **Das Aussehen auf dem Bildschirm.** Eudora wurde nicht gestartet; geprüft
  sind die Farbwerte der geladenen Bitmap und die Maskenbildung. Ob das Bild
  im Fenster jetzt richtig aussieht, muss Gregor sehen.
* **Die Symbole der Erweiterungen.** `QCToolBarManager::CopyButtonImage`
  kopiert Bilder aus `g_thePluginDirector.m_ImageList` in die zusammengesetzte
  Leistenbitmap. Die kommen nicht aus einer Bitmapressource; ob ihr
  Hintergrund passt, ist eine eigene, ungeprüfte Frage. **Vermutung**, nicht
  Messung: falls dort noch graue Flächen bleiben, ist das der nächste Ort.
* **`SECLoadSysColorBitmap`** (`OTShim.h`) und `OTShim_Knopf.cpp:91` gehen
  weiterhin unmittelbar über `LoadMappedBitmap`. Ihre Aufrufstellen
  (`AdView.cpp:350`, `PaymentAndRegistrationDlg.cpp:210`) sind keine
  Werkzeugleisten und wurden nicht angefasst. Ob deren Bitmaps eine
  Farbtabelle haben, ist **ungeprüft**.

---

## 7. Zum Nachvollziehen

    # statische Prüfung, braucht kein Visual Studio
    perl tools/pruefe-symbole.pl -v
    perl tools/pruefe-symbole-tests.pl

    # Testprogramm
    Eudora71\Tests\RunTests.cmd

    # Eudora bauen
    "C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" ^
        Eudora71\Eudora\Eudora.vcxproj -t:Build -p:Configuration=Release -p:Platform=Win32 -nologo -v:minimal
