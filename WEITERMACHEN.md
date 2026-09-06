# Hier weitermachen

**Stand 06.09.2026, abends.** Arbeitszweig `strg-n-diagnose`; `main` ist gesperrt
und wird nur von Gregor per Merge bewegt.

| | |
|---|---|
| **Quellstand** | 7.2.0.17 (`Eudora71/Version.h`) |
| **Zuletzt veröffentlicht** | [v1.0.15](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.15) — Messfassung mit Spurmarken |
| **Zuletzt von Gregor bestätigt** | 7.2.0.14 |

> **Die Fassungsgeschichte mit allen Messungen steht jetzt in
> [CHANGELOG.md](CHANGELOG.md)** — dort auch der Abschnitt *Wo man weitermachen
> kann* mit den offenen Enden und Fundstellen. Diese Datei hier ist nur der
> Einstieg.

## Das Ziel, an dem alles hängt

**Alle vier Kriterien aus [ZIEL.md](ZIEL.md) sind erfüllt.** Gregor hat am
06.09.2026 die zweite Stufe gesetzt — Kriterien **4 bis 6**:

| # | | Stand |
|---|---|---|
| 4 | **Keine Abstürze** | nicht erfüllt |
| 5 | **Eine neue Mail schreiben und abschicken** | nicht erfüllt |
| 6 | **Eine Mail weiterleiten** | nicht erfüllt |

**Alle drei hängen an einem einzigen Fehler: E-27.** Das ist die Hauptarbeit.
Alles andere läuft nebenher.

## E-27 — was gemessen ist

Strg-N und *Weiterleiten* beenden Eudora sofort und lautlos:

```
0xC00000FD  STATUS_STACK_OVERFLOW   in Paige32.dll, pgInstallFont
525 Windungen tief; Weg hinein:
    pgLocateStyleSheet -> pgStyleSuperImpose -> pgInstallFont
```

Deshalb entstand nie ein `Exception.log`: ein voller Stapel lässt keinen Platz
mehr, den Absturzbehandler auszuführen.

**Sieben Vermutungen sind bereits widerlegt** — jede gebaut, gestartet,
gemessen. Sie stehen samt Messwerten in [CHANGELOG.md](CHANGELOG.md) unter
7.2.0.17. **Nicht noch einmal durchprobieren.**

**Die nächste Frage:** Entsteht in dieser Portierung überhaupt jemals ein
Paige-Fenster? Ein erfolgreicher Durchlauf von `CPaigeEdtView::NewPaigeObject`
ist bisher nirgends belegt. Fällt die Antwort „nein" aus, ist nicht das
Verfassen-Fenster das Problem, sondern die ganze Paige-Anbindung.

## Ebenfalls offen

- ***File → Exit*** bringt eine Meldung statt sauber zu beenden
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
