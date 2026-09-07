# Hier weitermachen

**Stand 07.09.2026, morgens.** `main` ist gesperrt und wird nur von Gregor per
Merge bewegt; jeder Agent arbeitet in seinem eigenen Arbeitsbaum und Zweig
(siehe [AGENTEN.md](AGENTEN.md)).

| | |
|---|---|
| **Quellstand** | 7.2.0.21 (`Eudora71/Version.h`) |
| **Paketnummer** | 1.0.21 (`VERSION`) |
| **Zuletzt veröffentlicht** | [v1.0.21](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.21) — `Releases/Eudora72-1.0.21-release.zip`, SHA256 `0a699fcb03c3f0b60a0142837fc2128f3baf19884cd6b96a4f388339165b667c` |
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

**E-32 ist am 07.09.2026 behoben, aber von niemandem nachgemessen.** Das war
die modale Meldung „An unhandled exception has occurred", die nach E-31 an die
Stelle des Absturzes trat. `CHeaderView::OnKillFocusRecipient` in
`Eudora71/Eudora/headervw.cpp` dereferenzierte `pField`, obwohl die Abfrage drei
Zeilen darüber ausdrücklich mit NULL rechnet; `GetDlgItem` liefert NULL, solange
das Kopfzeilenfeld noch nicht existiert, und genau das ist beim Aufbau des
Verfassen-Fensters der Fall (`OnKillFocusTo` läuft während `LoadFrame`). Weil
der Zugriff **innerhalb einer Fensterprozedur** passiert, meldet Windows
`0xC000041D` (STATUS_FATAL_USER_CALLBACK_EXCEPTION) statt des üblichen
Zugriffsfehlers — dieselbe Fehlerklasse wie E-18 und E-22.

## Der nächste Schritt

**Bauen, packen, Gregor geben.** Solange niemand Strg-N auf seinem Rechner
gedrückt hat, ist alles darüber Vermutung: ob das Verfassen-Fenster sichtbar
wird, ob eine Mail zu schreiben ist, ob sich Eudora danach beenden lässt. Der
Weg dafür steht unten unter *Bauen und packen*, das Paket gehört in
`Releases/` und die Nummer in `Eudora71/Version.h` und `VERSION`.

## Ebenfalls offen

- ***File → Exit*** bringt eine Meldung statt sauber zu beenden (**E-33**).
  Noch nicht untersucht — und nach der Behebung von E-32 neu zu messen: bis
  dahin war jede Meldung von der modalen Meldung aus E-32 überdeckt
- Meldung **„Encountered an improper argument"** beim Anzeigen mancher
  Nachrichten. Das ist MFCs Text für `CInvalidArgException`, kommt also nicht
  aus Eudora. Eine Quelle war `QCChildToolBar::GetButton` mit Index −1 (E-16,
  behoben); es gibt eine zweite

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
