# Gegenlesen des Branches `bau-und-pruefung`

Agent **PRUEFER**, 05.09.2026. Arbeitsbaum `Eudora7.2-wt-beenden`, Branch
`wt/beenden-arbeit`. Geprüft wurde `origin/bau-und-pruefung` (`bcc59bb`) gegen
`origin/main` (`d59cf63`) — fünf Commits, 28 Dateien.

Geändert wurde von mir **nichts** außer dieser Datei.

Jede Aussage ist mit „gemessen:" oder „VERMUTUNG:" gekennzeichnet. Wo nichts
steht, ist es eine Folgerung aus den davor genannten Messungen.

---

## Urteil auf einen Blick

| # | Eingriff | Urteil |
|---|---|---|
| 1 | OT501 aus dem Bau genommen | **TRÄGT** — technisch sauber, ein Doku-Mangel |
| 2 | `OnUpdateFrameTitle(TRUE)` beim Start | **TRÄGT** — kein NULL-Zugriff, kein Doppelanhang |
| 3 | Version 7.2.0.4 / Paket 1.0.4 | **TRÄGT im Quelltext**, **MANGEL im Paket** |
| 4 | `pruefe-branch.pl` / `gesichert.pl` | **MANGEL** — eine Lücke, die genau den Anlassfall durchlässt |

**Elf Mängel**, davon zwei schwer (M-1, M-5), **keiner gefährlich** im Sinne von
„zerstört Arbeit oder Bau". Kein Eingriff ist zurückzunehmen.

**Bauprobe, gemessen:** zwei volle Projektmappen-Bauten in diesem Arbeitsbaum.
Der zweite läuft mit **0 Fehlern** durch und liefert eine `Eudora.exe` mit der
Kennung `Eudora 7.2.0.4 / Paket 1.0.4+bcc59bb` — ohne Sternchen, also
reproduzierbar. Der Branch baut.

---

## 1. OT501 aus dem Bau genommen — **TRÄGT**

`Eudora71/Eudora/Eudora.vcxproj`, `Eudora71/Eudora/EudoraRes.vcxproj`,
`Eudora71/Eudora.sln` (Commit `d8cc9d3`)

Ich habe die Begründung nicht übernommen, sondern jeden Punkt neu gemessen.

### Bindet irgendetwas `OTA50R.lib` / `OTA50D.lib`?

**gemessen:** Suche über den ganzen Baum in `*.vcxproj`, `*.vcproj`, `*.props`,
`*.mak`, `*.def`, `*.sln`, `*.filters`, `*.dsp`, `*.dsw` nach `OTA50`. Außerhalb
von `Eudora71/OT501/` gibt es **genau zwei** Treffer, beide in
`Eudora71/Eudora/Eudora.vcxproj`:

- Zeile 97 — `<IgnoreSpecificDefaultLibraries>…;OTA50D.LIB;…`
- Zeile 147 — `<IgnoreSpecificDefaultLibraries>…;OTA50D.LIB;OTA50R.LIB;…`

**gemessen:** kein einziges `<AdditionalDependencies>` im Baum enthält `OTA` —
Suche über alle `.vcxproj`, null Treffer. Die einzige Erwähnung ist also
tatsächlich die, die das Binden ausdrücklich **verhindert**. Die Behauptung im
README stimmt.

### Hat `OTA50R.lib` je existiert?

**gemessen:** `git log --all --diff-filter=A` auf `*OTA50R.lib`/`*OTA50D.lib`
liefert nichts; `git rev-list --all --objects | grep -i OTA50` liefert genau drei
Objekte, alle aus `Eudora71/OT501/Src/OTA50D/`: das Verzeichnis selbst,
`OTA50D.idb` und `OTA50D.pdb`. **Eine `.lib` war nie im Repo.** Die Berichtigung
in `f468a02` ist richtig.

### Ändert das Entfernen die Baureihenfolge?

**gemessen:** die OT501-GUID `{36EB689A-7C2C-4C2E-8F1C-744FDD4DDFA2}` kommt im
ganzen Baum nur noch vor in

- `Eudora71/Eudora.sln:27` — die Projektzeile (das Projekt bleibt sichtbar),
- `Eudora71/Eudora.sln:93,94` — zwei `ActiveCfg`-Zeilen,
- `Eudora71/OT501/Src/OT501.vcxproj:20` — die eigene `ProjectGuid`,
- `Eudora71/Backup/Eudora.sln` — die alte `.vcproj`-Mappe, die niemand lädt.

Kein anderes Projekt verweist auf OT501.

**gemessen:** `Eudora71/Eudora.sln` enthält **keinen einzigen**
`ProjectSection(ProjectDependencies)`-Abschnitt. Es gab also im ganzen
Projektmappen-Modell keine reine Reihenfolge-Abhängigkeit auf OT501, die jetzt
fehlen könnte. Nichts baut deshalb zu früh.

### Bleibt die Projektmappe gültig?

**gemessen:** 19 `Project(`-Zeilen, 19 verschiedene GUIDs im
Konfigurationsabschnitt — kein Projekt ohne Konfiguration, keine Konfiguration
ohne Projekt. 38 `ActiveCfg`-Zeilen (19 × 2 Konfigurationen), 36 `Build.0`.
Genau **ein** Projekt — OT501 — hat 2 × `ActiveCfg` und 0 × `Build.0`.

Das ist eine **gültige** Kombination: sie entspricht exakt dem abgehakten
Häkchen „Erstellen" im Konfigurations-Manager. Visual Studio schreibt diese Form
selbst, wenn man ein Projekt aus dem Bau nimmt. `SolutionConfigurationPlatforms`
kennt weiterhin nur `Debug|x86` und `Release|x86`.

**gemessen:** beide `.vcxproj` laden fehlerfrei in `System.Xml` — wohlgeformt.
`Eudora.vcxproj` hat noch 15 `ProjectReference`, `EudoraRes.vcxproj` noch 1
(QCUtils).

### Werden Kopfdateien aus `..\OT501\Include` gebraucht?

**Ja, und zwar reichlich.**

**gemessen:** `..\OT501\Include` steht weiterhin im Suchpfad von 9 Projekten
(AccountWizard, DirectoryServicesUI, Eudora, EudoraRes, EuImap, imap, QCUtils,
SearchEngine, Tests). Eingebunden werden von dort unter anderem:

| Fundstelle | Kopfdatei |
|---|---|
| `Eudora71/Eudora/mainfrm.h:32` | `sbarmgr.h` |
| `Eudora71/Eudora/SearchBar.h:33` | `sbarcore.h` |
| `Eudora71/Eudora/EudoraRes.rc:11` | `secres.h` |
| `Eudora71/OTShim/OTShim_Werkzeugleiste.h:75,81,85,89` | `secaux.h`, `secres.h`, `sbarcore.h`, `sbarmgr.h` |
| `Eudora71/OTShim/OTShim_Reiter.h:493` | `tabwnd.h` |
| `Eudora71/OTShim/OTShim.h:1041` | `swinfrm.h` |

**gemessen:** im Bauprotokoll dieses Arbeitsbaums erscheinen Warnungen aus
`Eudora71\OT501\Include\TrCtlX.h(46,1)` und `…\sectndlg.h(64,4)` — die
Kopfdateien werden also tatsächlich übersetzt, nicht nur gefunden.

**gemessen:** `Eudora71/Eudora/Eudora.vcxproj:237` und
`Eudora71/Tests/Tests.vcxproj:73` übersetzen `..\OT501\Src\secaux.cpp` **direkt**
als `ClCompile`. Diese Datei bindet in Zeile 9 `secaux.h` ein. Der Eingriff
berührt das nicht: ein `ClCompile` hängt nicht am Projektverweis.

### Wirkt der Eingriff?

**gemessen:** im Bauprotokoll eines vollen Projektmappen-Baus dieses
Arbeitsbaums (`-t:Build -p:Configuration=Release -p:Platform=x86 -m`) kommt
`OT501.vcxproj` **null**mal vor. Das Projekt wird nicht mehr angefasst; die
früher gemeldeten `NMAKE U1073`-Fehler sind weg.

### Mangel

**M-6 (Doku, klein).** `README.md:354` behauptet „Keine Quelldatei bindet
Stingray-Kopfdateien ein." Das ist **falsch** (siehe Tabelle oben) und
widerspricht fünf Zeilen weiter `README.md:359`: „`..\OT501\Include` bleibt im
Suchpfad — die Kopfdateien werden gebraucht, nur die Bibliothek nicht." Richtig
wäre: *keine Quelldatei bindet die Stingray-**Bibliothek**.*

---

## 2. `OnUpdateFrameTitle(TRUE)` in `FinishInitAndShowWindow` — **TRÄGT**

`Eudora71/Eudora/mainfrm.cpp:1128–1135` (Commit `bcc59bb`)

### Steht das Fenster?

**gemessen:** `ShowWindow(nWindowState)` steht in derselben Funktion in Zeile
1087, der neue Aufruf in Zeile 1135. Zwischen Zeile 900 und 1137 gibt es genau
einen vorzeitigen `return false` — und der liegt **vor** dem `ShowWindow`.
Zusätzlich prüft `CMainFrame::OnUpdateFrameTitle` selbst
(`mainfrm.cpp:9698`): `if (GetSafeHwnd() == NULL) return;`. Der Ort ist richtig.

### Kann der Aufruf etwas anfassen, das noch nicht steht?

**gemessen:** `QCWorkbook` (`Eudora71/Eudora/workbook.h:174`) leitet von
`SECWorkbook` ab und definiert `OnUpdateFrameTitle` **nicht**. Der Aufruf
`QCWorkbook::OnUpdateFrameTitle(bAddToTitle)` landet deshalb über
`SECMDIFrameWnd::OnUpdateFrameTitle` (`Eudora71/OTShim/OTShim.cpp:388`), die
nichts tut als weiterzureichen, bei `CMDIFrameWnd::OnUpdateFrameTitle`.

**gemessen** im Quelltext des tatsächlich benutzten Toolsets
(`…/MSVC/14.38.33130/atlmfc/src/mfc/winmdi.cpp`):

```cpp
CDocument* pDocument = GetActiveDocument();
if (bAddToTitle &&
  (pActiveChild = MDIGetActive()) != NULL &&
  (pActiveChild->GetStyle() & WS_MAXIMIZE) == 0 &&
  (pDocument != NULL ||
   (pDocument = pActiveChild->GetActiveDocument()) != NULL))
    UpdateFrameTitleForDocument(pDocument->GetTitle());
else
    … UpdateFrameTitleForDocument(lpstrTitle);   // lpstrTitle darf NULL sein
```

`pDocument` wird **vor jeder** Dereferenzierung gegen NULL geprüft. Ohne offenes
Dokument und ohne aktives Kindfenster fällt der Code in den `else`-Zweig und
ruft `UpdateFrameTitleForDocument(NULL)`. **Ein NULL-Zugriff ist ausgeschlossen**
— und das ist keine Vermutung über „was MFC wohl tut", sondern der Quelltext der
Fassung, gegen die hier gebaut wird.

Der Parameter `TRUE` ist damit im dokumentfreien Zustand schlicht wirkungslos:
`bAddToTitle` steht als erstes in der `&&`-Kette, die ohnehin an `MDIGetActive()
!= NULL` scheitert.

### Wird die Kennung doppelt angehängt?

**Nein.**

**gemessen** (`…/atlmfc/src/mfc/winfrm.cpp`,
`CFrameWnd::UpdateFrameTitleForDocument`): der Titel wird aus `m_strTitle`
(± Dokumentname) **neu zusammengesetzt** und mit `AfxSetWindowText` gesetzt —
also **ersetzt**, nicht ergänzt. Die Reihenfolge in `CMainFrame::OnUpdateFrameTitle`
ist deshalb richtig herum: erst die Basis (Titel wird auf „Eudora" bzw.
„Eudora - [In]" zurückgesetzt, die Kennung fällt weg), dann das Anhängen.

Weil `m_strTitle` dabei **nie** verändert wird, kann sich nichts aufschaukeln.
Die `Find`-Prüfung in Zeile 9730 ist trotzdem nicht überflüssig: die Basis kehrt
vorzeitig zurück, wenn `FWS_ADDTOTITLE` fehlt oder ein OLE-`m_pNotifyHook` den
Titel selbst setzt — dann bleibt die alte Kennung stehen, und `Find` verhindert
die zweite. Beide Wege sind abgedeckt.

### `static CString strHerkunft`

**gemessen:** Toolset ist MSVC v143 / 14.38.33130. Dort ist `/Zc:threadSafeInit`
die Vorgabe, und in `Eudora71/Eudora/Eudora.vcxproj` steht kein `/Zc:`-Schalter,
der das abschaltet (null Treffer). Die **Initialisierung** des lokalen statischen
`CString` ist damit vom Compiler gesperrt — kein Problem mit
Initialisierungsreihenfolge, kein Wettlauf beim ersten Betreten.

Das nachgelagerte Füllen (`if (strHerkunft.IsEmpty()) { … }`) ist für sich
genommen **nicht** fadensicher. VERMUTUNG: das ist folgenlos, weil
`OnUpdateFrameTitle` ein geschützter MFC-Rahmenaufruf ist, der nur aus der
Nachrichtenschleife des Oberflächenfadens kommt. Ich habe keinen Aufruf aus
einem Arbeitsfaden gefunden (gemessen: die einzigen beiden Fundstellen sind
`mainfrm.cpp:1135` und die Überschreibung selbst).

### Mangel

**M-1 (schwer).** *Die Behebung ist in keinem ausgelieferten Paket.*

**gemessen:** `Releases/Eudora72-1.0.4-release.zip` wurde in Commit `2734414`
hinzugefügt; die Behebung steht in `bcc59bb` — **danach**. Die `Eudora.exe` im
ZIP trägt die Kennung

```
Eudora 7.2.0.4 / Paket 1.0.4+d59cf63* 2026-09-05 19:05
```

`d59cf63` ist die Spitze von **`origin/main`**, nicht ein Commit dieses Branches,
und das Sternchen sagt: beim Bau lagen uncommittete Änderungen vor. Das
ausgelieferte 1.0.4 ist damit **aus keinem Commit reproduzierbar** und enthält
E-7 nicht. `BEFUNDE.md:133` führt E-7 weiterhin als „offen" — was für das Paket
sogar stimmt, aber nicht mehr für den Quelltext.

---

## 3. Version 7.2.0.4 / Paket 1.0.4 — **TRÄGT im Quelltext, MANGEL im Paket**

`Eudora71/Version.h`, `VERSION` (Commit `2734414`)

### Sind alle Stellen mitgezogen?

**gemessen:** `Releases/PAKETE.md` Zeile 25–35 nennt für eine Anhebung **fünf
Zeilen in zwei Dateien**. Der Branch ändert **genau diese fünf**:

| Datei | Angabe | alt | neu |
|---|---|---|---|
| `VERSION` | — | `1.0.3` | `1.0.4` |
| `Eudora71/Version.h` | `EUDORA_VERSION4` | `3` | `4` |
| `Eudora71/Version.h` | `EUDORA_BUILD_NUMBER` | `7,2,0,3` | `7,2,0,4` |
| `Eudora71/Version.h` | `EUDORA_BUILD_DESC` | `"Version 7.2.0.3\0"` | `"Version 7.2.0.4\0"` |
| `Eudora71/Version.h` | `EUDORA_BUILD_VERSION` | `"7.2.0.3"` | `"7.2.0.4"` |

`EUDORA_VERSION1/2/3` (7/2/0) bleiben richtig unverändert.

**gemessen:** Suche über alle `.rc`/`.rc2` nach `7.2.0.` und `7, 2, 0,` — außer
`Version.h` **kein** Treffer. Kein `VS_VERSION_INFO` widerspricht. Die
FILEVERSION-Angaben der Zusatzmodule (Attach 1,3,0,0; Junk 1,1,0,0; QVoice32
4,1,0,1 usw.) zählen eigenständig und sind nicht betroffen.

**gemessen** an der ausgelieferten Datei: `Eudora.exe` im 1.0.4-ZIP meldet
`FileVersion 7.2.0.4`, `ProductVersion 7.2.0.4`. Die Anhebung ist auch wirksam
geworden.

### `EUDORA_BUILD_MONTH` — hält die Begründung noch?

**Ja.** Die Begründung war, ein Anheben mache bestehende Registrierungscodes
ungültig. Die Frage war, ob das noch gilt, wo `BUILD_BOX_OR_SITE_R_VERSION`
ausgebaut ist.

**gemessen:** `EUDORA_BUILD_MONTH` wird an fünf Stellen ausgewertet:

- `QCSharewareManager.cpp:944` — `(regCodeMonth + 12) < EUDORA_BUILD_MONTH` → `paidExpired`
- `QCSharewareManager.cpp:953` — dito
- `QCSharewareManager.cpp:963` — dito, hinter `#ifdef SUPPORT_US_ENGLISH_ONLY_REGCODES`
- `QCSharewareManager.cpp:1182,1183` — Demo-Zeitraum
- `QCSharewareManager.h:85` — `IsNewDemoBuild()`

**gemessen:** `BUILD_BOX_OR_SITE_R_VERSION` kommt im ganzen Quelltext nur an
**einer** Stelle vor (`QCSharewareManager.h:55`) plus einem Kommentar in
`WazooBarMgr.cpp:157`. Die drei Vergleiche in Zeile 944/953/963 stehen **nicht**
darin. Sie sind lebender Code.

**Zur Prämisse der Frage — sie stimmt nicht.** Die Frage lautete, ob die
Begründung noch trägt, „wo die Registrierung über `BUILD_BOX_OR_SITE_R_VERSION`
ausgebaut ist". **gemessen:** das Makro ist gar nicht ausgebaut, es ist in
`Eudora71/Eudora/Eudora.vcxproj` in **beiden** Konfigurationen definiert
(Zeile 78 Debug, Zeile 132 Release). Und es tut auch nichts an der Registrierung:
`QCSharewareManager.h:54-60` setzt damit nur `DEFAULT_SWM_MODE` auf `2`
(`SWM_MODE_PRO`) statt `0`. Die Codeprüfung selbst wird davon nicht berührt.

Ein Anheben von `EUDORA_BUILD_MONTH` würde also jeden Code, dessen
`regCodeMonth + 12` darunter fällt, als abgelaufen werfen — **auf beiden Wegen**.
**Die Begründung ist nachgemessen richtig, und das Nicht-Anheben ist richtig.**

### Greift die Prüfung in `tools/kennung-erzeugen.pl`?

**Ja.** **gemessen:** die Prüfung (Zeile 100–110) vergleicht die letzte Stelle
von `EUDORA_BUILD_VERSION` mit der letzten Stelle aus `VERSION`. Hier 4 gegen 4 —
keine Warnung, richtig.

Dass sie überhaupt gelaufen ist, lässt sich an der ausgelieferten EXE ablesen:
die Kennung trägt die **Langform** `Eudora 7.2.0.4 / Paket 1.0.4+…`. Die
entsteht laut Zeile 113–115 nur, wenn `Version.h` gelesen und damit auch geprüft
wurde. Wäre die Datei nicht lesbar gewesen, stünde dort nur `1.0.4+…` — und die
Prüfung wäre stillschweigend ausgefallen.

### Mängel

**M-2 (mittel).** *Das ausgelieferte 1.0.4-Paket nennt sich selbst 1.0.3.*

**gemessen** in `LIESMICH.txt` im ZIP `Eudora72-1.0.4-release.zip`:

- Zeile 1: `Eudora 7.2 — Paket 1.0.3 (Release-Bau)`
- Zeile 31: `certutil -hashfile Eudora72-1.0.3-release.zip SHA256`
- Zeile 286: `Produktversion: 7.2.0.3   Paketversion: 1.0.3   QCSSL: 1.0.1`

**Ursache gemessen:** `tools/paket-bauen.ps1:156` hat den Pfad fest verdrahtet:
`$liesmich = Join-Path $wurzel 'Releases\1.0.3\LIESMICH.txt'`. Der Branch fasst
die Datei nicht an. Jedes künftige Paket erbt damit das 1.0.3-LIESMICH.
`PAKETE.md` warnt selbst genau davor („bei der QCSSL.dll sind genau so zwei
verschiedene Binärdateien unter derselben Kennung ausgeliefert worden").

**M-3 (mittel).** *`tools/Eudora starten.cmd` fällt beim nächsten Paketbau
heraus.*

**gemessen:** die Datei liegt im ausgelieferten ZIP im Wurzelverzeichnis
(`Eudora starten.cmd`, 2677 Byte) — aber `tools/paket-bauen.ps1` und
`tools/paket-pruefen.ps1` erwähnen sie mit **null** Treffern. Sie wurde von Hand
hineingelegt. Der nächste Lauf von `paket-bauen.ps1` liefert ein Paket **ohne**
Starter, und `paket-pruefen.ps1` merkt es nicht.

**M-4 (klein).** *Kein `Releases/1.0.4/`, kein Abschnitt in `PAKETE.md`.*

**gemessen:** `Releases/` enthält `1.0.2/`, `1.0.3/` — aber kein `1.0.4/`.
`Releases/PAKETE.md` hat Abschnitte bis „## 1.0.3", keinen für 1.0.4. Das ZIP ist
da, seine Buchführung nicht.

**Was stimmt:** die Prüfsumme. **gemessen:** SHA-256 des ZIP ist
`a3eb72e5f0beccb4e693e08cd57853d8e7627e6728125fc0490c2db2a91b4b72` und genau das
steht in `Releases/Eudora72-1.0.4-release.zip.sha256`.

---

## 4. `tools/pruefe-branch.pl` und `tools/gesichert.pl` — **MANGEL**

Geprüft wurde **nicht** die Fassung aus `bau-und-pruefung`, sondern der
überarbeitete Stand des Agenten SCHRANKE: `origin/wt/schranke` (`5e1187a`).

### Läuft die Testsammlung wirklich grün?

**gemessen:** ja. Ich habe `pruefe-branch.pl` und `pruefe-branch-tests.pl` aus
`origin/wt/schranke` in ein Wegwerf-Verzeichnis geholt und die Sammlung dort
laufen lassen: **15 Fälle, 15 grün, 0 rot.** Die Meldung ist belastbar.

### Prüfen die Fälle das Richtige?

**Überwiegend ja, und das Vorgehen ist gut.** Jeder Fall läuft **zweimal** —
einmal hart (Rückgabewert) und einmal mit `--melden` (Begründung gegen ein
Muster). Damit fällt auf, wenn die Schranke aus dem richtigen Ergebnis den
falschen Grund macht. Es wird nichts im Projektbaum angelegt; alles läuft in
Wegwerf-Repos unter `TMPDIR`. Die Fälle `g` (frisch abgezweigt), `j`
(Klammern im Zweignamen), `l`/`m` (fremde Arbeitsbäume) und `o` (laufender
Rebase) decken genau die Fehlalarm-Klassen ab, an denen die erste Fassung
gescheitert ist.

### Der Fall, den die Sammlung NICHT abdeckt — **M-5, der schwerste Befund**

**Alle sechs Fälle, die abbrechen sollen (`b`, `c`, `h`, `i`, `m`, `n`), rufen im
Aufbau vorher `git fetch --prune`.** Der Fall „auf dem Server ist
zusammengeführt, lokal wurde **nicht** geholt" kommt in der Sammlung nicht vor.

**gemessen.** Ich habe ihn nachgestellt: zwei Klone eines Wegwerf-Servers, Klon A
arbeitet auf `arbeit`, in Klon B wird `arbeit` nach `main` zusammengeführt und
gepusht, Klon A holt **nicht**. Dann in Klon A:

```
pruefe-branch: 'arbeit' ist eigenstaendig und lebt - in Ordnung
Rueckgabe(hart)=0        (0 = durchgelassen)
```

**Das ist genau die Lage vom 31.08.2026, 09:06** — drei Minuten nach dem Merge
hätte kein Arbeitsbaum von sich aus gefetcht. Die Schranke hätte den Vorfall, für
den sie gebaut wurde, **nicht** verhindert.

Fair ist: der Quelltext sagt das offen (Zeile 235–237: „ein Hook holt nicht
selbst vom Server — das haengte jeden Commit ans Netz"), und `gesichert.pl` holt
vorher. Die Entscheidung ist begründet. Der Mangel ist, dass **kein Testfall die
Grenze festhält** und die Zeile „15/15 grün" die Schranke stärker aussehen lässt,
als sie ist. Ein Fall `p` mit `erwartet => 0` und einem Kommentar „bewusste
Grenze: ohne vorheriges fetch schlägt die Schranke nicht an" würde die Lücke
dokumentieren statt sie zu verdecken.

### Kleinere Lücken

**gemessen:** der `origin/master`-Zweig der Hauptsuche (`pruefe-branch.pl`
Zeile 179) ist von keinem Fall abgedeckt. Ich habe ihn nachgestellt: er **greift
richtig** (Abbruch mit „bereits in origin/master enthalten"). Kosmetischer
Schönheitsfehler: der Ausweg-Text sagt dann trotzdem `git checkout main`.

**gemessen:** `vorgang_laeuft()` prüft auch `BISECT_LOG`; getestet wird nur der
Rebase-Fall (`o`). Cherry-Pick, Revert und Bisect sind ungetestet.

**gemessen:** `tools/gesichert.pl` hat **keine** Testsammlung — 287 geänderte
Zeilen mit einer nicht-trivialen Auswertung über fremde Arbeitsbäume, null Fälle.
Das ist die Datei, auf deren Wort hin Gregor abschaltet.

### `gesichert.pl` übersieht unverfolgte Dateien in fremden Arbeitsbäumen — **M-10**

**gemessen:** ich habe `gesichert.pl --ohne-holen` in diesem Arbeitsbaum laufen
lassen. Es findet die neun anderen Bäume und meldet richtig 3, 15, 15, 17 nicht
committete Dateien und 2 nicht gepushte Commits — die Überarbeitung wirkt.

Für den Hauptbaum `C:/Users/Gregor/Documents/github/Eudora7.2` meldet es
**„sauber"**. **gemessen** zum selben Zeitpunkt hat dieser Baum **fünf**
unverfolgte Einträge (`.claude/`, `Eudora71/EMSAPI/EMSSDK/emsapi-win.h`,
`Eudora71/OT501/Src/OT501__4/`, `Releases/Eudora72-1.0.2-symbole.zip` und dessen
`.sha256`).

**Ursache im Quelltext:** für fremde Bäume zählt

```perl
my @z = grep { length } split /\n/, git_in($p, 'status', '--porcelain');
my $n = grep { !/^\?\?/ } @z;
```

nur die **verfolgten** Änderungen. Unverfolgte werden weggefiltert und danach
weder gezählt noch gemeldet. Für den **eigenen** Baum werden sie sehr wohl
ausgewiesen („unverfolgt 1"). Die Ungleichbehandlung ist nirgends begründet.

Das ist genau die Verlustart, gegen die das Werkzeug gebaut ist: ein Agent
schreibt in seinem Baum einen Bericht, vergisst `git add`, das Werkzeug sagt
„sauber", Gregor führt zusammen und schaltet ab. Mindestens ein Hinweis wie beim
eigenen Baum gehört dazu.

### Zusammenführ-Reihenfolge — **M-7**

**gemessen:** `bau-und-pruefung` und `wt/schranke` zweigen beide von `d59cf63`
ab und ändern beide `tools/pruefe-branch.pl` und `tools/gesichert.pl`
(`git merge-tree`: „changed in both"). `bau-und-pruefung` bringt die **alte,
nachweislich falsche** Fassung mit (bricht den ersten Commit jedes frischen
Zweigs ab; meldet im leeren Repo fälschlich „abgelöster HEAD"; lässt ohne origin
stumm durch).

Entschärfend, **gemessen:** auf `bau-und-pruefung` ist `tools/hooks-einrichten.sh`
**nicht** geändert und erwähnt `pruefe-branch.pl` mit null Treffern. Die alte
Fassung wäre also nicht scharf — sie läge nur als Falle im Baum. Auf
`wt/schranke` wird sie in Zeile 36 als erster Schritt verdrahtet.

**Folge: `wt/schranke` muss nach `bau-und-pruefung` zusammengeführt werden**, und
beim Konflikt in diesen zwei Dateien gilt der Stand von `wt/schranke`.

---

## Zeilenenden und Kodierung

Gemessen an den Blobs (`git show <ref>:<datei>`), nicht am Arbeitsbaum — damit
ist die Messung von `core.autocrlf` unabhängig.

| Datei | CR alt→neu | LF alt→neu | Byte alt→neu | +/− Zeilen | stimmt? |
|---|---|---|---|---|---|
| `Eudora71/Eudora.sln` | 0 → 0 | 132 → **130** | 9249 → 9099 | 0 / −2 | ✅ −2 = −2 |
| `Eudora71/Eudora/Eudora.vcxproj` | 1064 → **1060** | 1069 → **1065** | 54024 → 53753 | 0 / −4 | ✅ −4 = −4 |
| `Eudora71/Eudora/EudoraRes.vcxproj` | 0 → 0 | 362 → **358** | 17667 → 17400 | 0 / −4 | ✅ −4 = −4 |
| `Eudora71/Eudora/mainfrm.cpp` | 18 → **18** | 9724 → **9732** | 280989 → 281446 | +8 / 0 | ✅ +8 = +8 |
| `Eudora71/Version.h` | 0 → 0 | 21 → 21 | 598 → 598 | 4 / 4 | ✅ Ersatz gleicher Länge |
| `VERSION` | 0 → 0 | 1 → 1 | 6 → 6 | 1 / 1 | ✅ |
| `README.md` | 0 → 0 | 390 → **579** | 28659 → 35608 | +189 / 0 | ✅ +189 = +189 |

**Kein Sprung.** Jede Differenz entspricht exakt der Zahl der geänderten Zeilen.
Befund S-7 ist hier nicht aufgetreten.

Bemerkenswert und **unverändert richtig behandelt:**

- `Eudora.vcxproj` ist eine **gemischte** Datei: 1064 CR gegen 1069 LF, also
  fünf reine LF-Zeilen. Die CR-Zahl sinkt um genau 4 wie die LF-Zahl — die vier
  entfernten Zeilen waren CRLF-Zeilen, die Mischung bleibt unangetastet.
- `mainfrm.cpp` hat 18 CR bei 9724 LF. Die CR-Zahl bleibt **exakt gleich**: die
  acht neuen Zeilen wurden mit LF eingefügt, also wie die Mehrheit der Datei.
  Richtig.
- `Eudora.sln` und `EudoraRes.vcxproj` sind reine LF-Dateien — auch schon in
  `origin/main`. Nichts wurde umgestellt.

**Kodierung, gemessen:**

- die acht neuen Zeilen in `mainfrm.cpp` enthalten **kein** Byte über `0x7F`
  (Umlaute als „ae/oe/ue" geschrieben). Die Datei hat weder vorher noch nachher
  ein Hochbyte. Die Latin-1-Regel ist eingehalten.
- `README.md` ist nach der Änderung **gültiges UTF-8** (Perl `Encode::decode`
  mit `FB_CROAK` läuft durch).

---

## Was die Dokumentation sagt — und was davon nicht mehr stimmt

`README.md` wurde **nur ergänzt** (189 Zeilen dazu, 0 entfernt). Der neue
Abschnitt „Selbst bauen" ist in sich gut, aber er widerspricht dem Rest der
Datei.

### Was im neuen Abschnitt stimmt

- **gemessen:** die Berichtigung über `OTA50R.lib` ist richtig (siehe Eingriff 1).
- **gemessen:** Punkt 2 stimmt — `Eudora.sln` kennt nur `x86`, die `.vcxproj` nur
  `Win32`.
- Punkt 3 (MSBuild kann 0 zurückgeben, ohne zu bauen) ist der richtige Rat und
  deckt sich mit dem, was ich in Eingriff 3 selbst gemacht habe.

### Was nicht stimmt — **M-6 bis M-9**

**M-6** siehe Eingriff 1: `README.md:354` gegen `README.md:359`.

**M-8 (mittel).** Die alten Abschnitte sind nicht nachgezogen und widersprechen
dem neuen jetzt frontal:

| Fundstelle | steht dort | gemessener Stand |
|---|---|---|
| `README.md:82-84` | „`/p:BuildProjectReferences=false` ist **nötig** — sonst scheitert der Bau am Projekt `OT501`" | nicht mehr nötig; der Projektverweis ist weg |
| `README.md:101-103` | „Ein voller Solution-Bau meldet **weiterhin 3 Fehler, alle aus `OT501`**" | OT501 wird gar nicht mehr gebaut (0 Treffer im Bauprotokoll) |
| `README.md:465` | „`EudoraRes.dll` — **offen**, hängt über `EudoraRes.vcxproj:351` an `OT501`" | die Zeile gibt es nicht mehr; `EudoraRes.vcxproj` hat nur noch den QCUtils-Verweis |
| `README.md:464` | verweist auf `Eudora.vcxproj:1015` | Zeilennummern haben sich um 4 verschoben |
| `README.md:18,19,44,479` | „Paket `Eudora72-1.0.3`", „Produktversion **7.2.0.3**", Verweis auf Release `v1.0.3` | 1.0.4 / 7.2.0.4 |

Zeile 83 ist die vom Auftrag ausdrücklich genannte Stelle: **sie steht im
direkten Widerspruch zur neuen Überschrift „klonen, laden, erstellen — fertig.
Ohne Kniffe."**

Dasselbe in `PORTIERUNG.md`, **gemessen**: Zeile 32 („3 Fehler, alle aus
`OT501`"), Zeile 47–49 („`EudoraRes` hat einen Projektverweis auf `OT501`
(`EudoraRes.vcxproj:351`)") und Zeile 55 sind ebenso überholt.

**M-9 (klein).** `README.md:175` zeigt die Bau-Kennung als
`[1.0.3+371c1e3 - Eudora72-1.0.3]`. **gemessen** an der ausgelieferten EXE lautet
sie inzwischen `Eudora 7.2.0.4 / Paket 1.0.4+d59cf63* 2026-09-05 19:05` — mit
Produktversion und Zeitstempel. Auch der erklärende Kommentar in
`mainfrm.cpp:9686` zeigt noch die alte Form. Beides ist vom Branch nicht
verursacht, wird aber vom neuen Abschnitt mitgeschleppt.

**Nachtrag zum Anspruch „ohne Kniffe" — gemessen.** Ein voller
Projektmappen-Bau dieses Arbeitsbaums aus dem Zustand des Branches
(`-t:Build -p:Configuration=Release -p:Platform=x86 -m`) meldet **3 Fehler**:

```
LINK : fatal error LNK1181: Eingabedatei "QCUtils.lib" kann nicht geoeffnet werden.
   [Eudora71\Importers\OEImport\OEImport.vcxproj]
   [Eudora71\Importers\OLImport\OLImport.vcxproj]
   [Eudora71\Importers\NSImport\NSImport.vcxproj]
```

**Ursache gemessen:** die drei `Importers`-Projekte haben **keinen einzigen**
`ProjectReference`, und `Eudora.sln` hat keinen
`ProjectSection(ProjectDependencies)`-Abschnitt. Es gibt also nichts, was
MSBuild zwingt, `QCUtils` vor ihnen zu bauen — bei `-m` starten sie zu früh.

**Das ist NICHT vom Eingriff verursacht** (die `Importers`-Projekte sind vom
Branch nicht angefasst und hatten nie einen Bezug zu OT501); es ist ein
vorhandener Mangel. Aber es widerlegt den Satz „klonen, laden, *Projektmappe
erstellen* — fertig. Ohne Kniffe." für den **ersten** Bau eines frischen Klons.
Diese Zusage sollte entweder eingelöst (drei Projektverweise auf `QCUtils`
nachtragen) oder auf „**zweimal** erstellen" abgeschwächt werden. **M-11.**

---

## Bauprobe — der Branch baut

Zwei Läufe in diesem Arbeitsbaum, beide `-t:Build -p:Configuration=Release
-p:Platform=x86 -m`. Kein `Rebuild`, kein `Clean`, kein Programmstart.

| Lauf | Ergebnis | Dauer |
|---|---|---|
| 1 (frischer Baum) | **3 Fehler**, `Eudora.vcxproj` bricht ab, keine `Eudora.exe`; Rückgabewert **1** | 15:37 |
| 2 (direkt danach) | **0 Fehler**, 2824 Warnungen, „Der Buildvorgang wurde erfolgreich ausgeführt" | 10:06 |

**Die drei Fehler sind ein einmaliger Wettlauf, kein Dauerzustand.** Sobald
`Eudora71/Lib/Release/QCUtils.lib` einmal da ist, geht der zweite Lauf durch.
Der zweite Lauf zeigt außerdem, dass MSBuild in Lauf 1 **richtig** eine 1
zurückgegeben hat — die im README beschriebene Falle „Rückgabewert 0 ohne Bau"
ist hier nicht aufgetreten.

**Ergebnis von Lauf 2, gemessen:**

- `Eudora71/Bin/Release/Eudora.exe`, **2 933 760 Byte** — Byte-genau dieselbe
  Größe wie die `Eudora.exe` im ausgelieferten 1.0.4-ZIP.
- Bau-Kennung in der EXE und in `Eudora71/Eudora/BuildKennung.h`:

  ```
  Eudora 7.2.0.4 / Paket 1.0.4+bcc59bb 2026-09-05 20:07
  ```

  **Ohne Sternchen** und auf dem Commit `bcc59bb` — also aus einem sauberen
  Stand der Branchspitze, **mit** der E-7-Behebung. Das ist genau das, was dem
  ausgelieferten Paket fehlt (M-1): dort steht `1.0.4+d59cf63*`.

Damit ist belegt: **der Branch baut vollständig und liefert eine reproduzierbare
`Eudora.exe`.** Ein neues Paket 1.0.4 ist einen Lauf entfernt.

---

## Was fehlt

Was in diesen Commits hätte mitgezogen werden müssen und nicht wurde:

| # | fehlt | Beleg |
|---|---|---|
| 1 | **`BEFUNDE.md`: E-7 steht weiter auf „offen"** | `BEFUNDE.md:133` — der Quelltext ist behoben (`bcc59bb`). Richtig wäre **behoben, ungeprüft**, mit dem Hinweis, dass das ausgelieferte 1.0.4 die Behebung nicht enthält. Auch der Befundtext ab `BEFUNDE.md:5372` („31.08.2026, OFFEN") gehört fortgeschrieben |
| 2 | **`BEFUNDE.md`: kein Befund für das Herausnehmen von OT501** | Der Eingriff ist die größte Änderung am Bau seit OTShim, hat eine eigene Beweiskette und eine Berichtigung (`f468a02`) — und steht nur im README. Ein Befund samt Zeile im Verzeichnis (Zeile 46 ff.) fehlt |
| 3 | **`BEFUNDE.md`: kein Befund X-5** für die Schranke | Der Commit `5e1187a` auf `wt/schranke` beruft sich auf „Befund X-5", das Verzeichnis kennt nur X-1 bis X-4 |
| 4 | **`AUFGABEN.md` unverändert** | Kopf sagt weiter „Stand 31.08.2026, 09:00. Branch `darstellung-und-menue`". Weder das Herausnehmen von OT501 noch 1.0.4 noch E-7 sind eingetragen; die Punkte, die durch den Eingriff erledigt oder hinfällig sind, stehen unverändert drin |
| 5 | **`PORTIERUNG.md` unverändert** | Zeilen 32, 47–49, 55 beschreiben einen Bauzustand, den es nicht mehr gibt (siehe M-8) |
| 6 | **`Releases/PAKETE.md`: kein Abschnitt „## 1.0.4"** | Abschnitte enden bei „## 1.0.3" (Zeile 93). Das ZIP liegt im Repo, ohne Zeile in der Buchführung — genau die Lücke, vor der die Datei selbst in Zeile 70–76 warnt |
| 7 | **`Releases/1.0.4/` fehlt** samt eigenem `LIESMICH.txt` | `Releases/` hat `1.0.2/` und `1.0.3/`. Deshalb greift `paket-bauen.ps1:156` weiter auf `Releases\1.0.3\LIESMICH.txt` — Ursache von M-2 |
| 8 | **`tools/paket-bauen.ps1` nicht nachgezogen** | Zeile 156 verdrahtet 1.0.3 fest; `Eudora starten.cmd` kommt gar nicht vor (M-2, M-3) |
| 9 | **`tools/paket-pruefen.ps1` prüft den Starter nicht** | Ein von Hand hineingelegter Bestandteil, den kein Prüfwerkzeug kennt, verschwindet unbemerkt |
| 10 | **keine Testsammlung für `tools/gesichert.pl`** | `pruefe-branch.pl` hat 15 Fälle, `gesichert.pl` null — bei 287 geänderten Zeilen |
| 11 | **`README.md` und `mainfrm.cpp:9686` zeigen die alte Kennungsform** | M-9 |

---

## Mängelverzeichnis

| # | Mangel | Schwere | Fundstelle |
|---|---|---|---|
| M-1 | Die E-7-Behebung ist in keinem Paket; das ausgelieferte 1.0.4 stammt aus `d59cf63*` und ist nicht reproduzierbar | **schwer** | `2734414` vs. `bcc59bb`; Kennung in der EXE |
| M-2 | Das 1.0.4-Paket nennt sich in `LIESMICH.txt` selbst 1.0.3 | mittel | `tools/paket-bauen.ps1:156` |
| M-3 | `Eudora starten.cmd` fällt beim nächsten Paketbau heraus | mittel | `tools/paket-bauen.ps1` (kein Treffer) |
| M-4 | Kein `Releases/1.0.4/`, kein `PAKETE.md`-Abschnitt | klein | `Releases/` |
| M-5 | Die Schranke lässt ohne vorheriges `fetch` genau den Anlassfall durch; kein Testfall hält die Grenze fest | **schwer** | `tools/pruefe-branch.pl`, nachgestellt |
| M-6 | `README.md:354` widerspricht `README.md:359` | klein | `README.md` |
| M-7 | `bau-und-pruefung` bringt die alte, falsche Fassung der beiden Werkzeuge mit; Konflikt mit `wt/schranke` | mittel | `git merge-tree`: changed in both |
| M-8 | `README.md:82,101,464,465,18,19,44,479` und `PORTIERUNG.md:32,47-49,55` sind überholt | mittel | siehe Tabelle oben |
| M-9 | Kennungsform in `README.md:175` und `mainfrm.cpp:9686` veraltet | klein | — |
| M-10 | `gesichert.pl` übersieht **unverfolgte** Dateien in fremden Arbeitsbäumen und nennt sie „sauber" | mittel | `tools/gesichert.pl`, Abschnitt 6 |
| M-11 | Der erste Bau eines frischen Baums scheitert an drei `Importers`-Projekten ohne `QCUtils`-Projektverweis — der Satz „ohne Kniffe" trägt so nicht | mittel | Bauprobe, Lauf 1 |

---

## Empfehlung

**Der Branch kann nach `main`.** Die vier Eingriffe am Programm und am Bau sind
sauber: der Bau ist nachweislich besser als vorher, die Titelzeilen-Behebung ist
gegen den MFC-Quelltext geprüft und ungefährlich, die Versionsanhebung ist
vollständig, die Zeilenenden sind unbeschädigt.

Was fehlt, ist **Buchführung, nicht Code**. Vor oder unmittelbar nach dem
Zusammenführen sollten erledigt werden:

1. `wt/schranke` **nach** `bau-und-pruefung` zusammenführen; bei den zwei
   Werkzeugdateien gilt `wt/schranke` (M-7).
2. `BEFUNDE.md`, `AUFGABEN.md`, `PORTIERUNG.md`, `Releases/PAKETE.md` nachziehen
   (Punkte 1–7 unter „Was fehlt").
3. `README.md:82-84`, `:101-103`, `:354`, `:464-465` und die Versionsangaben
   berichtigen (M-6, M-8).
4. `tools/paket-bauen.ps1` von `Releases\1.0.3\LIESMICH.txt` lösen und den
   Starter aufnehmen (M-2, M-3).
5. Das Paket 1.0.4 **neu bauen** — aus einem sauberen Commit, mit der
   E-7-Behebung, mit einem eigenen `LIESMICH.txt` (M-1). Die `Eudora.exe` dafür
   liegt bereits gebaut in diesem Arbeitsbaum, Kennung `1.0.4+bcc59bb` ohne
   Sternchen.
6. In `gesichert.pl` die unverfolgten Dateien fremder Arbeitsbäume mitmelden
   (M-10) und drei `ProjectReference` auf `QCUtils` in die `Importers` eintragen
   (M-11) — oder den Satz „ohne Kniffe" auf „zweimal erstellen" abschwächen.

**Zwei Punkte gehören vor das Abschalten, nicht danach:**

- **M-5.** Die Schranke schlägt ohne vorheriges `fetch` nicht an. Wer sich nach
  einer Merge-Ankündigung auf sie verlässt, verlässt sich auf nichts. Bis ein
  Testfall die Grenze festhält und `gesichert.pl` (das holt) vorgeschaltet ist,
  ist die Regel weiter Prosa.
- **M-1.** Solange das veröffentlichte 1.0.4 aus `d59cf63*` stammt, ist es nicht
  reproduzierbar — und E-7 in `BEFUNDE.md` steht für dieses Paket zu Recht auf
  „offen". Der Eintrag darf erst umgeschrieben werden, wenn ein Paket aus einem
  Commit ohne Sternchen existiert.
