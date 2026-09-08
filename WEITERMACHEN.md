# Hier weitermachen

**Stand 07.09.2026, morgens.** `main` ist gesperrt und wird nur von Gregor per
Merge bewegt; jeder Agent arbeitet in seinem eigenen Arbeitsbaum und Zweig
(siehe [AGENTEN.md](AGENTEN.md)).

| | |
|---|---|
| **Quellstand** | 7.2.0.22 (`Eudora71/Version.h`) |
| **Paketnummer** | 1.0.22 (`VERSION`) |
| **Zuletzt gebaut und gepackt** | Paket **1.0.22** - `Releases/Eudora72-1.0.22-release.zip`, SHA256 `7ddab1a0f0fdf1c4458a7aa2ab00d2f1fbb15561ab576657c73006fcfa95586c`. Als Marke noch **nicht** veröffentlicht; die jüngste Marke ist [v1.0.21](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.21) |
| **Zuletzt von Gregor gestartet** | Paket 1.0.21 am 07.09.2026 — *„mail können jetzt abgeschickt werden."* und *„weiterleitung funktioniert übrigens."* |
| **Zuletzt von Gregor bestätigte Behebungen** | 7.2.0.21 (E-31/E-34/E-35/E-36: Verfassen, Abschicken, Weiterleiten) |
| **Was er dabei bemängelt hat** | *„beenden geht nicht."* und *„kann man die untere zeile (status) immer anzeigen lassen?"* |

> **Die Fassungsgeschichte mit allen Messungen steht in
> [CHANGELOG.md](CHANGELOG.md)** — dort auch die Prüfanleitung zum aktuellen
> Paket und der Abschnitt *Wo man weitermachen kann* mit den offenen Enden und
> Fundstellen. Diese Datei hier ist nur der Einstieg.

## Das Ziel, an dem alles hängt

**Neun Kriterien stehen in [ZIEL.md](ZIEL.md) — fünf belegt (0, 1, 3, 5, 6),
drei fast oder halb (2, 4, 8), eines nicht: das Beenden (7).** Gregor hat am
06.09.2026 die zweite Stufe gesetzt, Kriterien **4 bis 6**; **7** ist am
07.09.2026 aus seinem Urteil zu Paket 1.0.18 nachgetragen, **8** noch am
selben Tag aus seinem Wunsch nach sichtbaren offenen Fenstern:

| # | | Stand |
|---|---|---|
| 4 | **Keine Abstürze** | fast — fünfmal Strg-N ohne Absturz gemessen, das Beenden fehlt |
| 5 | **Eine neue Mail schreiben und abschicken** | **erfüllt** (07.09.2026, von Gregor bestätigt) |
| 6 | **Eine Mail weiterleiten** | **erfüllt** (07.09.2026, von Gregor bestätigt) |
| 7 | ***File → Exit*** beendet Eudora sauber | **nicht erfüllt** — *„beenden geht nicht."* |
| 8 | Offene Fenster sichtbar und auswählbar | halb — Menü *Window* ja, Reiterleiste unten fehlt |

## Was seit dem 06.09.2026 anders ist

**E-31 ist behoben — das war die Wurzel.** Strg-N und *Weiterleiten* beendeten
Eudora mit `0xC00000FD STATUS_STACK_OVERFLOW` in `Paige32.dll`
(`pgInstallFont`, 525 Windungen tief); deshalb entstand auch nie ein
`Exception.log` — ein voller Stapel lässt keinen Platz mehr für den
Absturzbehandler. Die Ursache war eine Zeile in
`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`: `pg_time_t` erbte seine Breite von
`time_t`, und das ist unter VS2022 **acht** Byte breit statt der vier, mit denen
die ausgelieferte DLL von 2005 rechnet. Damit war **jede** Struktur verschoben,
die Eudora an Paige reichte — und in dieser Portierung entstand bis dahin
**kein einziges Paige-Fenster**. Seither läuft der Fensterbau vollständig durch
(`OnMessageNewMessage: fertig`). Die Messung mit allen Feldversätzen steht in
[CHANGELOG.md](CHANGELOG.md) unter 7.2.0.21.

**Sieben Vermutungen sind auf diesem Weg widerlegt worden** — jede gebaut,
gestartet, gemessen. Sie stehen samt Messwerten in
[CHANGELOG.md](CHANGELOG.md) unter 7.2.0.21. **Nicht noch einmal
durchprobieren.**

**E-32: der Code-Mangel ist behoben, die Ursachenbehauptung ist widerlegt.**
`CHeaderView::OnKillFocusRecipient` in `Eudora71/Eudora/headervw.cpp`
dereferenzierte `pField` ungeprüft, obwohl die Abfrage drei Zeilen darüber
ausdrücklich mit NULL rechnet — das ist behoben (`060a4bf`) und bleibt richtig.
Dass **diese** Stelle die modale Meldung „An unhandled exception has occurred"
verursacht hätte, hat PRUEFER dreifach gemessen und **verworfen**
(`Befunde/PRUEFER-3.md`, Abschnitt 2): die Funktion läuft bei Strg-N gar nicht,
das Herausnehmen der Behebung bringt die Meldung nicht zurück, und im Paket
1.0.18 tritt sie über denselben Weg nicht auf. Aufgeklärt hat die Meldung erst
**E-34** — eine MFC-Ausnahme in `QCChildToolBar::GetButton`, die den ganzen
Fensterbau abwickelte (`CHANGELOG.md` unter 7.2.0.20 und 7.2.0.21).

## Der nächste Schritt

**Ein Paket bauen und das Protokoll lesen — suchen muss niemand mehr.**

**Kriterium 7 — das Beenden (E-33).** *File → Exit*, das **Kreuz** und
**Alt-F4** beenden Eudora nicht, sondern bringen den Meldungsdialog
**„Encountered an improper argument"**. Gregor am 07.09.2026 an Paket 1.0.21,
mit Bildschirmfoto: *„exit: weder alt+F4, noch x rechts oben funktionieren. da
kommt wieder die meldung"*. Das ist der einzige verbliebene **Fehler**; alles
Weitere ist Ausstattung.

Diese Messung hat drei Dinge entschieden ([Befunde/BEENDEN.md](Befunde/BEENDEN.md)):

1. Das Beenden **beginnt** — alle drei Wege gehen durch dasselbe
   `CMainFrame::OnClose`. `CFileBrowseView::OnAppExit`
   (`FileBrowseView.cpp:2218`) ist damit **ausgeschlossen**.
2. Der Abbruch ist eine **geworfene `CInvalidArgException`**, keine stille
   FALSE-Rückgabe. `CMainFrame::SaveOpenWindows` ist deshalb **nicht** mehr der
   Spitzenkandidat.
3. `CWinApp::ProcessWndProcException` (`appcore.cpp:1009-1039`) zeigt die
   Meldung und liefert 0 — `WM_CLOSE` gilt als beantwortet, das Fenster bleibt.
   Das ist **bestätigt**, nicht mehr Vermutung.

Weil das Fenster nach der Meldung noch da ist, muss der Wurf **vor**
`pApp->HideApplication()` (`winfrm.cpp:885`) fallen. **Verdacht:**
`QCCustomToolBar::SaveCustomInfo`
(`Eudora71/Eudora/QCCustomToolBar.cpp:421`) — dieselbe Form wie E-34 (Grenze
aus `GetBtnCount()`, Zugriff über `m_btns[...]`, und MFC 14 wirft dort auch im
Release-Bau, `afxcoll.inl:201-217`), gelegen in `CloseDown` Stufe 5
(`SaveBarState`), und im normalen Betrieb **nur beim Beenden** erreicht.
**Belegt ist das nicht, behoben ist nichts.**

**So wird es belegt:** ein Paket aus diesem Stand bauen, mit `LogLevel=32896`
unter `[Settings]` in der `Eudora.ini` starten, beenden — und die **letzte**
`E-33`-Zeile in `eudora.log` lesen. 32 Marken liegen: in
`QCCustomToolBar.cpp:408-415` vor der Schleife samt `TRY`/`CATCH_ALL` mit
`GetErrorMessage` und `THROW_LAST()` (der Ablauf bleibt unverändert, es wird
nur protokolliert), in `mainfrm.cpp` je **Aufruf** statt je Stufe (`5a`…`5i`,
`6a`…`6f`), in `eudora.cpp` an `OnAppExit` und `ExitInstance`.

> **Zur Maske:** `LogLevel=32896` ist ausreichend, aber nicht nötig. Gemessen an
> Gregors Log vom 07.09.2026: sein `LogLevel 25759` (0x649F) enthält
> `DEBUG_MASK_MISC` (0x8000) **nicht**, wohl aber `DEBUG_MASK_TOC_CORRUPT`
> (0x80) — und weil `PutDebugLog` nur auf ein gemeinsames Bit prüft, schreiben
> die Marken trotzdem. Sichtbar an seinen `MAIN 32896:`-Zeilen.

**E-38 hängt daran.** Die im Assistenten eingegebenen Daten stehen in der
`Eudora.ini` (von Gregor nachgesehen), fehlen aber im Eigenschaften-Dialog.
Gregor: *„vielleicht fehlen die daten, wenn ich eudora per task manager
abschließen muß"* — das ist erst zu messen, wenn Eudora sich normal beenden
lässt. Vorher ist jede Aussage dazu wertlos.

**Danach Kriterium 8** — die untere Reiterleiste für die offenen Fenster. Das
Menü *Window* listet sie schon auf; was fehlt, ist die **WazooBar**
(`Eudora71/Eudora/WazooBar.cpp:572,578`, Abschnitt `[WazooBars]` in
`Eudora.ini`, Namen in `EudoraRes.rc:10637-10640`). Die Ersatzschicht `OTShim`
bildet sie nicht nach — dort liegt der Ansatz, nicht in Eudora selbst.

## Ebenfalls offen

- Die Meldung **„Encountered an improper argument"** beim Anzeigen mancher
  Nachrichten. Zwei Quellen sind behoben (E-16, E-34). **Offen ist die
  Ursache:** warum meldet `GetBtnCount()` 27, während `m_btns[24]` wirft? Das
  Abfangen behandelt das Symptom

## Wie man misst

Alles, was man dafür braucht, steht bereit — es muss niemand danebensitzen.

**Protokollierung einschalten.** In `Mailverzeichnis\Eudora.ini` unter
`[Settings]`:

```
LogLevel=32896
```

Ohne diese Zeile schreibt Eudora nichts: `PutDebugLog` prüft die Maske und kehrt
sonst sofort zurück (`QCUtils/src/debug.cpp:140`). 32896 = `DEBUG_MASK_MISC`
(0x8000) + `DEBUG_MASK_TOC_CORRUPT` (0x80). Danach stehen die Spurmarken mit
`E-27` in `Mailverzeichnis\eudora.log`.

**Absturzbericht auswerten:**

```bash
perl tools/absturz-auswerten.pl
```

Findet `Exception.log` und `Eudora.map` selbst und macht aus jeder Stapelzeile
einen Funktionsnamen. Bei Berichten vor 7.2.0.13 sagt es, dass es nicht geht,
statt zu raten.

**Unter dem Debugger laufen lassen** — muss die **32-Bit**-PowerShell sein:

```
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File tools\stapel-untersuchen.ps1 -Exe <Paket>\Eudora.exe -Argumente "<Mailverzeichnis>"
```

Er fängt die tödliche Ausnahme ab und **tastet den Stapel ab** — die EBP-Kette
taugt bei Paige nichts, die DLL ist ohne Rahmenzeiger übersetzt.

**Eudora ohne Maus bedienen.** Meldungsfenster der Klasse `#32770` mit
`SendMessage(h, WM_COMMAND=0x0111, IDOK=1, 0)` schließen, dann
`PostMessage(hauptfenster, 0x0111, 32797, 0)` an die Fensterklasse
`EudoraMainWindow` für *Neue Nachricht* (`ID_MESSAGE_FORWARD` ist 32799).
Fensterliste über `EnumWindows` + `GetWindowThreadProcessId`; bei
`GetClassName`/`GetWindowText` unbedingt `CharSet=CharSet.Unicode`.

## Bauen und packen

```powershell
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Release
```

Meldet Erfolg nur, wenn vier unabhängige Prüfungen zustimmen. **MSBuild kann 0
zurückgeben und trotzdem nichts gebaut haben.**

Paket schnüren und prüfen:

```powershell
powershell -ExecutionPolicy Bypass -File tools\paket-bauen.ps1 -Ziel <Verzeichnis> -Zip Releases\Eudora72-1.0.x-release.zip -AusBauverzeichnis -Bauart Release
powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket <Verzeichnis>
```

**Eine Nummer je Bau.** Vor dem Packen `Eudora71/Version.h` und `VERSION`
hochsetzen und committen — sonst trägt die Bau-Kennung ein Sternchen und der
Bau ist nicht reproduzierbar.

## Nach einem frischen Klon

```bash
sh tools/hooks-einrichten.sh
```

Das war es. Zeilenenden sind seit `.gitattributes` (`* -text`) kein Thema mehr —
nachgemessen: ein frischer Auscheck mit erzwungenem `core.autocrlf=true` meldet
null geänderte Dateien.

## Wie hier gearbeitet wird

- [AGENTEN.md](AGENTEN.md) — Koordination paralleler Arbeit, aus fünf gemessenen
  Kollisionen
- [Arbeitsweise/](Arbeitsweise/) — die Lehren aus diesem Projekt, eine Datei je
  Lehre. **Vor dem Anfangen lesen**, besonders
  [mannschaft-fuehren.md](Arbeitsweise/mannschaft-fuehren.md): ein Auftrag ohne
  konkrete Beobachtung liefert nichts, und jeder Rücklauf wird selbst
  nachgemessen
- Die Quellen sind **Latin-1 mit gemischten Zeilenenden**. `tools/pruefe-bytes.pl`
  vor jedem Commit; das Edit-Werkzeug zerstört beides lautlos
