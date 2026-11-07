# Selbst bauen

Zurück zum [Einstieg](../README.md).

## Selbst bauen

### Welche Eingabeaufforderung gemeint ist

Dieses Projekt läuft auf Windows, und drei Eingabeaufforderungen sind im
Umlauf. Sie können nicht dasselbe:

| | `cat` | `grep` | `ls` | `sh` | `powershell -File …` |
|---|---|---|---|---|---|
| **PowerShell** | ja (Alias für `Get-Content`) | **nein** | ja (Alias für `Get-ChildItem`) | nur mit vollem Pfad | ja |
| **Git Bash** | ja | ja | ja | ja | ja |
| **cmd.exe** | nein | nein | nein | nein | ja |

Die Blöcke unten sind deshalb doppelt, wo es einen Unterschied macht: einmal
` ```sh ` für die Git-Bash, einmal ` ```powershell `. Wo nur ein Block steht,
tut es jede der drei.

> **Die PowerShell-Fassungen sind nicht auf einem Windows-Rechner
> nachgemessen** — sie sind aufgeschrieben, nicht geprüft. Wer die erste davon
> laufen lässt und eine Abweichung findet, berichtigt sie hier. (Aufgeschrieben
> am 11.10.2026, nachdem Gregor fragte: *„gilt es auch unter windows?"* — und
> der Abschnitt bis dahin `grep` verlangte, das es in der PowerShell nicht
> gibt.)

### Nach einem frischen Klon: ein Schritt

```bash
sh tools/hooks-einrichten.sh
```

In der **PowerShell** gibt es `sh` nur, wenn das `bin`-Verzeichnis von Git für
Windows im Suchpfad liegt — in der Standardinstallation tut es das nicht. Dann
mit vollem Pfad:

```powershell
& "$env:ProgramFiles\Git\bin\sh.exe" tools/hooks-einrichten.sh
```

Das war es. Der Hook liegt unter `.git/hooks` und wird von git nicht
mitversioniert, muss also je Klon einmal eingerichtet werden; er prüft vor jedem
Commit Zweigwahl, Zeilenenden, Kodierung — und, sobald eine `.md`, `VERSION`
oder `Eudora71/Version.h` mit im Commit ist, die Doku gegen sich selbst
(`tools/doku-pruefen.pl`).

**Zeilenenden sind kein Thema mehr.** [.gitattributes](../.gitattributes) setzt
`* -text` und schaltet damit jede Umwandlung durch git ab — beim Auschecken wie
beim Einchecken bleiben die Bytes, wie sie sind, unabhängig davon, wie
`core.autocrlf` auf dem jeweiligen Rechner steht.

Nachgemessen am 06.09.2026: ein frischer Auscheck des Stands, geprüft mit
**erzwungenem** `core.autocrlf=true`, meldet **null geänderte Dateien**. Die
Datei `Eudora71/Eudora/eudora.cpp` steht dabei als `i/mixed w/mixed` da — ihre
absichtlich gemischten Zeilenenden aus den Neunzigern kommen unversehrt an.

> Früher standen hier vier Schritte, darunter `git config core.autocrlf false`
> und ein Lauf von `tools/zeilenenden-angleichen.pl`. Beides war nötig, **bevor**
> es `.gitattributes` gab. Das Werkzeug bleibt liegen — es repariert einen
> Arbeitsbaum, der aus jener Zeit stammt —, aber ein heutiger Klon braucht es
> nicht.

### Vor dem Bau: die Version heben

**Wer etwas geändert hat, hebt vorher die Nummer** — sonst tragen zwei
verschiedene `Eudora.exe` dieselbe Produktversion, und ein Fehlerbericht lässt
sich keinem Bau mehr zuordnen (Befund [**V-1**](../Intern/BEFUNDE.md#v-1)). Es sind **fünf Zeilen in zwei
Dateien**; die Tabelle dazu steht in
[Releases/PAKETE.md](../Releases/PAKETE.md), Abschnitt *„Wie man die Version
hebt"*. Nachsehen, was gerade gilt:

```sh
cat VERSION
grep -n "EUDORA_VERSION4\|EUDORA_BUILD_" Eudora71/Version.h
```

```powershell
Get-Content VERSION
Select-String "EUDORA_VERSION4|EUDORA_BUILD_" Eudora71\Version.h
```

`Select-String` nimmt .NET-Reguläre: das `|` steht dort **ohne** Rückstrich,
anders als im `grep`-Aufruf darüber.

Alle fünf Zeilen durchgehen: `EUDORA_BUILD_NUMBER` ist beim Heben schon
**zweimal** stehengeblieben, und kein Werkzeug hat es damals gemeldet.
`tools/doku-pruefen.pl` meldet es heute.

### Der Bau

```powershell
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Release
```

**`bauen.ps1` weist ab, solange ungesicherte Quelldateien im Baum liegen** —
nach einem `git apply` ist das der Normalfall. Entweder vorher committen und
pushen, oder, wenn es wirklich ein Wegwerfbau ist, `-Ungesichert` anhängen.
Ändert der Eingriff einen Header einer DLL (etwa
`Eudora71/QCUtils/public/inc/debug.h`), dann `-Ziel Rebuild` nehmen.

`tools/bauen.ps1` liest Konfiguration und Plattform aus `Eudora71/Eudora.sln`
und sucht MSBuild über `vswhere.exe`; geraten wird nichts. Erfolg meldet es
**nur**, wenn vier voneinander unabhängige Prüfungen zustimmen: Rückgabewert,
Fehlerprotokoll, Zeitstempel der Artefakte und die Versionsressource der
`Eudora.exe`. Grund dafür ist Befund [**X-6**](../Intern/BEFUNDE.md#x-6) — am 05.09.2026 hat ein
MSBuild-Aufruf von Hand Erfolg gemeldet, ohne gebaut zu haben.

Wer doch von Hand baut, kennt drei Fallen:

- **`/p:BuildProjectReferences=false` wird nicht mehr gebraucht** und ist auch
  nicht mehr erwünscht: `OT501` ist seit dem 05.09.2026 aus dem Bau genommen
  (Befund [**B-3**](../Intern/BEFUNDE.md#b-3)). Wer den Schalter trotzdem setzt, bekommt in einem frischen
  Klon `LNK1104: imap.lib` — nicht, weil etwas kaputt wäre, sondern weil
  `Eudora71/Lib/` von `.gitignore` erfasst ist und `imap.lib` erst vom Projekt
  `imapdll` entsteht.
- **Die Plattform heißt `x86`.** Die Projektmappe kennt `x86`, die
  Projektdateien `Win32`. Wer `-p:Platform=Win32` an die `.sln` gibt, bekommt
  `MSB4126`.
- **Der Aufruf muss aus der PowerShell kommen.** Die Git-Bash macht aus
  `/p:Configuration=Debug` einen Pfad.

Die Visual-Studio-IDE wird nicht gebraucht, nur die Installation (MSVC v143,
MFC/ATL, Windows SDK). Belege zum Bauzustand: [PRUEFUNG-BAU.md](../Intern/PRUEFUNG-BAU.md).

### Was fertig gebaut wird

`<Konfiguration>` steht für `Debug` oder `Release`.

| Ergebnis | Ort |
|---|---|
| **`Eudora.exe`** | `Eudora71/Bin/<Konfiguration>` |
| `EudoraRes.dll` | `Eudora71/Bin/<Konfiguration>` |
| `QCSSL.dll`, `Imap.dll`, `QCSocket.dll`, `QCUtils.dll`, `EuLang.dll`, `plstclnt.dll` | `Eudora71/Bin/<Konfiguration>` |
| `msvcr71.dll` (Projekt `VC71Bruecke`, Weiterleitung auf `msvcrt.dll`) | `Eudora71/Bin/<Konfiguration>` |
| `NSImport.eif`, `OEImport.eif`, `OLImport.eif` (Importer-Plugins, DLLs mit eigener Endung) | `Eudora71/Bin/<Konfiguration>` |
| `EudoraOldIcons.epi` (Icon-Plugin, ebenfalls eine DLL) | `Eudora71/EudoraOldIcons/<Konfiguration>` |
| **nicht gebaut, mitgeliefert:** `Plugins/SMIME.dll`, `SpamHeaders.dll`, `SpamWatch.dll` (Originale von QUALCOMM, brauchen `MFC71.DLL`/`msvcp71.dll`, siehe [S-3](../Intern/BEFUNDE.md#s-3)) und `Plugins/EudoraUnicodeFix.dll` samt LIESMICH und LIZENZ (Zusatz von `rjsdotorg`, BSD-3, [E-147](../Intern/BEFUNDE.md#e-147)) | `Eudora71/Bin/Release/Plugins` (im Repo versioniert) |
| die `.lib` (siehe unten) | `Eudora71/Lib/<Konfiguration>` |
| `libeay32.lib`, `ssleay32.lib` (Projekt `OpenSSL`, Altbestand) | `Eudora71/OpenSSL/out32` |

#### Die `.lib` in `Eudora71/Lib/<Konfiguration>` — drei Sorten

Zahlen stehen hier absichtlich nicht: `Eudora71/Lib/` ist von `.gitignore`
erfasst, der Inhalt hängt also davon ab, was zuletzt gebaut wurde, und jedes
neue Projekt verschiebt ihn. Wer wissen will, was da liegt, unterscheidet nach
diesen drei Merkmalen — sie halten auch dann noch, wenn ein Projekt dazukommt:

| Sorte | woran man sie erkennt | woher |
|---|---|---|
| **Importbibliothek** zu einer DLL | daneben liegt eine gleichnamige `.exp` | jedes Projekt mit `<ConfigurationType>DynamicLibrary` und `<ImportLibrary>..\Lib\…` |
| **echte statische Bibliothek** | keine `.exp`, wird beim Bau neu geschrieben | `AccountWizard`, `DirectoryServicesUI`, `EuImap`, `SearchEngine` — die vier Projekte mit `<ConfigurationType>StaticLibrary` |
| **vorgefertigte Fremdbibliothek** | keine `.exp`, und `git ls-files Eudora71/Lib/` nennt sie | im Repo mitversioniert, kein Projekt erzeugt sie |

Nachzählen, ohne etwas zu bauen:

```sh
ls Eudora71/Lib/Release/*.exp                       # die Importbibliotheken
git ls-files Eudora71/Lib/                          # die mitgelieferten Fremdlibs
grep -l StaticLibrary Eudora71/*/*.vcxproj Eudora71/*/*/*.vcxproj
```

```powershell
Get-ChildItem Eudora71\Lib\Release\*.exp            # die Importbibliotheken
git ls-files Eudora71/Lib/                          # die mitgelieferten Fremdlibs
Select-String StaticLibrary Eudora71\*\*.vcxproj, Eudora71\*\*\*.vcxproj |
    Select-Object -ExpandProperty Path -Unique
```

Die mitgelieferten Fremdbibliotheken heißen in **Release** `EuMemMgr.lib`,
`Paige32.lib`, `SSCEWD32.LIB`, `Uuid.Lib`, `libpng.lib`, `zlib.lib` — in
**Debug** genauso, nur heißt Paige dort `Paige32d.lib`. Auf Groß- und
Kleinschreibung achten: `SSCEWD32.LIB` und `Uuid.Lib` fallen sonst aus einem
`ls *.lib` heraus.

Eine Falle beim Zählen: `VC71Bruecke` baut die DLL `msvcr71.dll`, seine
Importbibliothek heißt aber `msvcr71-bruecke.lib` — Projektname, DLL-Name und
`.lib`-Name gehen hier auseinander.

### Tests

Unit- und Komponententests liegen in `Eudora71/Tests` (`RunTests.cmd`) und
`Eudora71/Tests/QCSSL` (`bauen.bat`, `messen.ps1`). Nach Vorgabe zu jedem Commit
laufen lassen.

### Den eigenen Bau starten

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Ins Mailverzeichnis gehört eine `Eudora.ini`. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`. Welche Dateien
danebenliegen müssen, steht in [STARTUMGEBUNG.md](../Intern/STARTUMGEBUNG.md).

Der Fenstertitel trägt die **Bau-Kennung** — Fassung, Commit und
Herkunftsverzeichnis. Ein Sternchen hinter dem Commit heißt: beim Bau lagen
ungesicherte Änderungen vor, der Bau ist nicht reproduzierbar. Damit ist ein
Bildschirmfoto eindeutig einem Bau und einer Instanz zuzuordnen.

### Ein eigenes Release-ZIP bauen — aus einem frischen Klon

Was hier steht, ist **gemessen**: am 07.11.2026 aus einem frischen
`git clone` (Klonprobe, Zweig `paket_7_2_2_137`, Commit `1051bfaf`) — Bau
3,4 Minuten, Paket 0,8 Minuten, `paket-pruefen.ps1` ohne Fehler, derselbe
Dateibestand wie das Testpaket 7.2.2.137 ([E-248](../Intern/BEFUNDE.md#e-248)).
Die Klonprobe rief `sh tools/hooks-einrichten.sh` in der Git Bash auf, die
übrigen Zeilen genau so in der PowerShell. Bis zu diesem Tag ließ sich das
Paket nur aus dem Hauptordner der
Entwicklermaschine schnüren.

**Voraussetzungen:** Visual Studio 2022 mit *Desktopentwicklung mit C++*
einschließlich MFC (die verteilbare Laufzeit `mfc140.dll`, `msvcp140.dll`,
`vcruntime140.dll` nimmt das Werkzeug aus dem Redist-Ordner von Visual
Studio), Git für Windows (bringt `sh` und Perl mit), Windows PowerShell 5.1.
Sonst nichts — alles Weitere liegt im Repo.

```powershell
git clone https://github.com/HansWurst81675/Eudora7.2.git
cd Eudora7.2
& "$env:ProgramFiles\Git\bin\sh.exe" tools/hooks-einrichten.sh
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1
powershell -ExecutionPolicy Bypass -File tools\paket-bauen.ps1 -Ziel C:\Temp\Eudora72-eigen -Zip C:\Temp\Eudora72-eigen.zip -AusBauverzeichnis -Bauart Release -RollenSindGelaufen "eigener Bau" -OhnePruefbericht "eigener Bau" -AgentLaeuftAbsichtlich "eigener Bau"
powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket C:\Temp\Eudora72-eigen
```

Danach liegt das fertige Paket in `C:\Temp\Eudora72-eigen` und das ZIP
daneben. Was die Schritte tun und worauf man achtet:

* **Die drei Schalter mit Begründung.** `paket-bauen.ps1` hat Schranken für
  die Arbeitsweise *dieses* Projekts: es baut kein Paket, solange eine der
  Prüfrollen (LEKTOR, PRÜFER, CHRONIST) fällig ist, ein Prüfauftrag läuft oder
  der Prüfbericht nicht *BESTANDEN* meldet. In einem eigenen Klon weisen sie
  deshalb ab (gemessen: *„KEIN PAKET, solange eine Rolle ueberfaellig
  ist“*). Die Schalter übergehen sie; die Begründung steht danach im
  Protokoll. Wer das Projekt selbst ausliefert, lässt sie weg und erfüllt die
  Schranken.
* **Die Grundlage.** Ohne `-Grundlage` nimmt das Werkzeug
  `Releases/Eudora72-1.0.2-lauffaehig.zip` aus dem Repo (Hilfe, Emoticons,
  Mailverzeichnis-Vorlage und die übrigen Dateien des Originals); **jede
  ausführbare Datei** darin wird aus dem eigenen Bau ersetzt (Schritt 8, im
  Lauf gemessen: *„6 ersetzt, 33 schon gleich, keine Debug-Laufzeit“*). Mit
  `-Grundlage <ZIP>` geht auch das letzte Release von GitHub.
* **Ein zweiter Bau im selben Klon.** Der Bau schreibt fünf versionierte
  Dateien neu (`Eudora71/Eudora/EudoraExe_i.c`, `EudoraExe_p.c`,
  `GoogleDesktopSearchAPI_i.c`, `GoogleDesktopSearchAPI_p.c`, `dlldata.c`).
  Danach weist `bauen.ps1` ab (*„Erst sichern“*) und die Bau-Kennung bekäme
  ein Sternchen. Vor dem nächsten Bau zurücksetzen:
  `git checkout -- Eudora71/Eudora/EudoraExe_i.c Eudora71/Eudora/EudoraExe_p.c Eudora71/Eudora/GoogleDesktopSearchAPI_i.c Eudora71/Eudora/GoogleDesktopSearchAPI_p.c Eudora71/Eudora/dlldata.c`
  (noch offen in [E-248](../Intern/BEFUNDE.md#e-248)).
* **Eine eigene Fassungsnummer.** Wer veröffentlichen will, hebt vorher die
  Version und committet (Abschnitt [Vor dem Bau: die Version heben](#vor-dem-bau-die-version-heben)) —
  sonst trägt das ZIP dieselbe Nummer wie das letzte Release.
* **Testen.** Das Paket mit `Eudora starten.cmd` und einem eigenen
  Mailverzeichnis starten ([Den eigenen Bau starten](#den-eigenen-bau-starten));
  die Regressionstests über die Oberfläche laufen mit dem
  [Prüfstand](PRUEFSTAND.md).
* **Veröffentlichen.** Das ZIP als Anhang eines GitHub-Release hochladen,
  etwa `gh release create v7.2.2.N C:\Temp\Eudora72-eigen.zip --title "…" --notes-file <Text>`.
  Dieses Projekt veröffentlicht erst nach Gregors Test und Freigabe.

### Nur für den Debug-Bau: die Laufzeit-DLLs

**Das Release-Paket braucht nichts aus diesem Abschnitt.** Es bringt
`mfc140.dll`, `msvcp140.dll` und `vcruntime140.dll` selbst mit; die drei sind
Teil des Visual-C++-Redistributable und dürfen beiliegen (Befund [F-1](../Intern/BEFUNDE.md#f-1)).

Der **Debug**-Bau dagegen braucht vier DLLs, die nicht weiterverteilt werden
dürfen und nur mit einer Visual-Studio-Installation kommen:

```
mfc140d.dll   msvcp140d.dll   vcruntime140d.dll   ucrtbased.dll
```

`tools/laufzeit-holen.ps1` kopiert sie und prüft jede einzeln auf ihre
Architektur nach; `-NurPruefen` sagt nur, was fehlt, ohne etwas zu kopieren:

```powershell
powershell -ExecutionPolicy Bypass -File tools\laufzeit-holen.ps1 -Ziel "C:\Pfad\zu\Eudora"
```

Fehlen sie, bricht der Start mit **`0xc000007b`** ab — `STATUS_INVALID_IMAGE_FORMAT`,
Befund [S-8](../Intern/BEFUNDE.md#s-8). Derselbe Code kommt bei falscher Bitness heraus, und **`Eudora.exe`
ist ein 32-Bit-Programm**. Zwei Fallen führen zu 64-Bit-DLLs: DLL-Sammelseiten
wie dll-files.com liefern häufig die 64-Bit-Fassung, ohne es deutlich zu machen
(von dort **keine** Laufzeit-DLLs holen), und der 32-Bit-Systemordner heißt unter
Windows ausgerechnet **`SysWOW64`**, während in `System32` die 64-Bit-DLLs
liegen. Die richtigen Dateien liegen auf jedem Rechner mit Visual Studio 2022
(C++-Werkzeuge, MFC/ATL) bereits in `SysWOW64`.

Beim ersten Start des Debug-Baus erscheinen drei bis vier Dialoge „SUPERASSERT
Assertion Failure" — auf *Ignore Once* klicken. Das sind Debug-Zusicherungen,
keine Fehler; im Release-Bau entfallen sie samt allen `ASSERT`/`VERIFY`.

