# Hier weitermachen

**Stand 08.09.2026, mittags.** `main` ist gesperrt und wird nur von Gregor per
Merge bewegt; jeder Agent arbeitet in seinem eigenen Arbeitsbaum und Zweig
(siehe [AGENTEN.md](AGENTEN.md)).

| | |
|---|---|
| **Quellstand** | 7.2.0.23 (`Eudora71/Version.h`) |
| **Paketnummer** | 1.0.23 (`VERSION`) |
| **Zuletzt gebaut und gepackt** | Paket **1.0.23** — `Releases/Eudora72-1.0.23-release.zip`, SHA256 `3f58a93c85c8fbf9f206ccc319a4798bb40236f3b60821a3de6df17710139045`, 9 340 228 Byte, `Eudora.exe` vom 08.09.2026 10:51. **Noch nicht committet**, als Marke **nicht** veröffentlicht; die jüngste Marke ist [v1.0.21](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.21) |
| **Zuletzt von Gregor gestartet** | Paket **1.0.22** am 08.09.2026 — *„schließen klappt jetzt."* und *„default werte beim neuen persona konto für ‚leave message on server' greifen."*; dazu die Prüfinstanz mit 7.2.0.23 zu A-2 — *„jetzt ist sie unten, ja"* |
| **Zuletzt von Gregor bestätigte Behebungen** | 7.2.0.22: **E-40/E-41/E-42** (Beenden, Kriterium 7) und **A-1** (Vorgaben für ein neues Konto). 7.2.0.23: **E-44** (Anforderung A-2). Davor 7.2.0.21: E-31/E-34/E-35/E-36 (Verfassen, Abschicken, Weiterleiten) |
| **Was er dabei bemängelt hat** | *„die meldung kommt, wenn ich eine persona gelöscht habe"* und *„sie verschwindet links nicht, bis ich eudora geschlossen habe"* — beides **E-37**, der zweite Behebungsanlauf ist gebaut und **nicht bestätigt** |

> **Die Fassungsgeschichte mit allen Messungen steht in
> [CHANGELOG.md](CHANGELOG.md)** — dort auch die Prüfanleitung zum aktuellen
> Paket und der Abschnitt *Wo man weitermachen kann* mit den offenen Enden und
> Fundstellen. Diese Datei hier ist nur der Einstieg.

## Das Ziel, an dem alles hängt

**Neun Kriterien stehen in [ZIEL.md](ZIEL.md) — sechs sind belegt
(0, 1, 3, 5, 6, 7), drei fast oder halb (2, 4, 8).** Gregor hat am
06.09.2026 die zweite Stufe gesetzt, Kriterien **4 bis 6**; **7** ist am
07.09.2026 aus seinem Urteil zu Paket 1.0.18 nachgetragen, **8** noch am
selben Tag aus seinem Wunsch nach sichtbaren offenen Fenstern:

| # | | Stand |
|---|---|---|
| 4 | **Keine Abstürze** | fast — fünfmal Strg-N ohne Absturz gemessen; das Beenden ist erledigt, offen bleiben die Meldung beim Anzeigen mancher Nachrichten und der abgefangene Wurf in `SaveCustomInfo` (**E-43**) |
| 5 | **Eine neue Mail schreiben und abschicken** | **erfüllt** (07.09.2026, von Gregor bestätigt) |
| 6 | **Eine Mail weiterleiten** | **erfüllt** (07.09.2026, von Gregor bestätigt) |
| 7 | ***File → Exit*** beendet Eudora sauber | **erfüllt** (08.09.2026, von Gregor bestätigt) — *„schließen klappt jetzt."* Alle drei Wege: Menü, Alt-F4, Kreuz |
| 8 | Offene Fenster sichtbar und auswählbar | halb — Menü *Window* ja; die Leiste unten gibt es seit **E-44**, sie zeigt aber *Task Status* und *Task Errors* statt der Reiter |

**Dazu zwei Anforderungen, die kein Kriterium sind:** **A-1** (Vorgaben für ein
neu angelegtes Konto) und **A-2** (*Task Status* und *Task Errors* waagrecht
unten) — beide umgesetzt und **von Gregor bestätigt**, beide in
[ZIEL.md](ZIEL.md) aufgeschrieben.

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

**Kriterium 7 ist erledigt, A-1 und A-2 sind bestätigt.** Was jetzt ansteht,
steht ausführlich in [AUFGABEN.md](AUFGABEN.md) unter *Die Hauptarbeit*; hier
die Reihenfolge in einem Satz je Punkt.

1. **E-37 zu Ende bringen** — ein gelöschtes Konto bleibt in der Liste stehen,
   bis Eudora neu startet. Der zweite Anlauf ist in 7.2.0.23 gebaut und **von
   Gregor nicht bestätigt**; der erste war eine **Regression** und hat dem
   Anwender „Encountered an improper argument" gezeigt. Das ist der einzige
   Punkt, an dem die Portierung zwischenzeitlich **schlechter** war als vorher
   — deshalb zuerst. Fundstelle:
   `CPersonalityView::OnCmdDeletePersonality`
   (`Eudora71/Eudora/PersonalityView.cpp`). Offen bleibt auch, **warum**
   `FindItem` −1 liefert und **warum** `PopulateView` geworfen hat.
2. **E-38 messen** — die im Kontoassistenten eingegebenen Daten fehlen unter
   *Konto → Eigenschaften*. Der Befund hing an E-33; **der Blocker ist weg**,
   weil Eudora sich normal beenden lässt. Der erste Handgriff kostet keinen
   Bau: nach einem **normalen** Beenden den Abschnitt `[Persona-<Name>]` in der
   `Eudora.ini` ansehen. Stehen die Werte da, scheitert das **Lesen**
   (`GetParams`, `persona.cpp:279ff`, stumm über `VERIFY` in
   `ModifyAcctSheet.cpp:47`); fehlen sie, ist es die Schreibseite.
3. **E-39** — wird die aktuell benutzte Persönlichkeit gelöscht, kann ihr
   INI-Abschnitt teilweise wiederentstehen. `CPersonality::Remove`
   (`persona.cpp:565-566`) stellt die aktuelle Persönlichkeit nicht um.
   Naheliegend: nach erfolgreichem `Remove` auf `<Dominant>` umschalten.
4. **Kriterium 8** — die Reiterleiste für die offenen Fenster. Die Leiste am
   unteren Rand ist mit **E-44** da und liegt waagrecht; was fehlt, sind die
   **Reiter**. Gelesen wird die Anordnung in
   `Eudora71/Eudora/WazooBar.cpp:552` aus dem Abschnitt `[WazooBars]` der
   `Eudora.ini` (`WazooBarIds`, `WazooBar%d`, `WazooMDI%d`, Namen in
   `EudoraRes.rc:10637-10640`); die Ersatzschicht `OTShim` bildet die Reiter
   nicht nach — dort liegt der Ansatz, nicht in Eudora selbst.
5. **E-43** — `QCCustomToolBar::SaveCustomInfo` wirft beim Beenden, der
   Leistenzustand wird **nie** gespeichert. Abgefangen, nicht behoben; Folge
   ist ein fehlender `[ToolBar…]`-Abschnitt in der `Eudora.ini` (am 08.09.2026
   in zwei Profilen nachgemessen: null Treffer), und daraus folgte E-44.
   Eingegrenzt auf `GetBtnCount=24/24` bei `m_btns.GetSize=0/0` — gleiches
   Objekt, gleiche Adresse, in **einer** Protokollzeile gemessen. Der Wert
   flackert also nicht, und ein freigegebenes Objekt ist ausgeschlossen
   (**E-46** ist damit **widerlegt**). Es bleibt: der übersetzte Code liest an
   zwei verschiedenen Adressen. Die dritte Marke gibt die Rohwörter des Feldes
   aus und sagt, welche.

> **Was nicht mehr zu suchen ist.** Das Beenden ist entschieden: E-40 (eine
> Rückfrage, die sich nicht öffnen lässt, galt als Abbrechen), E-41 (Alt-F4 und
> das Kreuz laufen durch ein `ENSURE_VALID`, das *File → Exit* nicht hat) und
> E-42 (zwölf Aufräumschritte konnten den Ablauf abbrechen), dazu E-45 (der
> eine Schritt, der **nicht** übersprungen werden darf). Der Weg dorthin steht
> in [Befunde/BEENDEN.md](Befunde/BEENDEN.md), das Review in
> [Befunde/PRUEFER-5.md](Befunde/PRUEFER-5.md). **Nicht wieder von vorn
> aufrollen.**

## Ebenfalls offen

- Die Meldung **„Encountered an improper argument"** beim Anzeigen mancher
  Nachrichten. Zwei Quellen sind behoben (E-16, E-34). **Offen ist die
  Ursache** — dieselbe Frage wie bei E-43: `GetBtnCount()` ist wörtlich
  `return (int)m_btns.GetSize()`, und trotzdem melden die beiden verschiedene
  Werte. Das Abfangen behandelt das Symptom
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
