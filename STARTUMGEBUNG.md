# Startumgebung für den ersten Start von Eudora.exe

Vorarbeit vom 30.08.2026, Branch `eudora-exe-linkt`, gemessen an `a139f9b`.

`Eudora.exe` linkt noch nicht und wurde nie gestartet. Diese Datei sammelt, was
beim ersten Startversuch danebenliegen muss — damit die Suche danach nicht erst
dann anfängt.

## Was zur Laufzeit gebraucht wird

Gemessen aus `Eudora.vcxproj` (`AdditionalDependencies`) und durch Nachsehen, ob
die jeweilige `.lib` eine DLL nennt (Import-Bibliothek) oder nicht (statisch):

| Bibliothek | Art | DLL nötig? | in `Bin/Debug`? |
|---|---|---|---|
| `Paige32d.lib` | Import | `Paige32d.dll` | **ja** |
| `SSCEWD32.LIB` | Import | `SSCEWD32.dll` | **nein — siehe unten** |
| `libpng.lib` | statisch | — | — |
| `zlib.lib` | statisch | — | — |
| `spchwrap.lib` | statisch | — | — |
| `qtmlclient.lib` | statisch | — | — |
| `libexpat.lib` | Import | `libexpat.dll` | ja |

Bemerkenswert: **QuickTime und das Speech-SDK sind statisch gebunden.** Es braucht
zur Laufzeit weder `qtmlClient.dll` noch eine Sprach-DLL, obwohl beide im Baum
liegen (`Qt3.x/Libraries/qtmlClient.dll`).

## Der Fall SSCEWD32

`SSCEWD32.LIB` ist eine Import-Bibliothek und nennt `SSCEWD32.dll`. Diese DLL liegt
**nirgends** — weder in `Eudora71/Bin/`, noch im Original-Installer unter
`InstallersForEudora/Eudora7.1/Data/win32/`, noch sonst im Baum.

Das ist vermutlich **kein Problem**, und zwar aus folgendem Grund: die
Rechtschreibprüfung ist stillgelegt. `spell.cpp` fehlt in der CHM-Freigabe und wurde
durch einen Platzhalter ersetzt; `ssce.h` ist ebenfalls ein Platzhalter. Damit ruft
**keine einzige Stelle** eine SSCE-Funktion auf, und der Linker verwirft den Import
mitsamt der DLL-Abhängigkeit.

**Ungeprüft** — nachweisbar erst, wenn `Eudora.exe` existiert:

```bash
dumpbin /dependents Eudora71\Bin\Debug\Eudora.exe
```

Taucht `SSCEWD32.dll` dort auf, muss sie beschafft werden (Sentry Spelling Checker
Engine von Wintertree Software), oder die Referenz muss aus dem Projekt heraus.

## Was gegenüber dem Original-Installer fehlt

Der Installer bringt 25 DLLs mit, `Bin/Debug` hat davon fünf nicht:

| Datei | Bedeutung |
|---|---|
| `EudoraRes.dll` | **Ressourcen-DLL.** Wird vom Projekt `EudoraRes` gebaut, das ebenfalls an OT501 hängt. Ohne sie startet Eudora vermutlich nicht — sie enthält Dialoge, Zeichenketten und Symbole. |
| `paige32.dll` | Release-Variante der Textsatz-Engine; für den Debug-Bau nicht nötig (`Paige32d.dll` ist da). |
| `capicom.dll` | Microsoft-Kryptobibliothek, für S/MIME. |
| `dbghelp.dll` | Absturzberichte; liefert Windows selbst mit. |
| `EudUnInst.dll` | Deinstallation; für den Start unerheblich. |

**Der wichtige Posten ist `EudoraRes.dll`.** Sie ist kein Beiwerk, sondern trägt
die Oberfläche. Beim Bau von `EudoraRes` gilt dasselbe wie bei `Eudora`: es hängt
über einen Projektverweis an OT501 und wird beim Solution-Bau übersprungen.

## Checkliste für den ersten Startversuch

1. `Eudora.exe` linkt — dann zuerst `dumpbin /dependents` darauf laufen lassen und
   die Ausgabe gegen `Bin/Debug` halten.
2. `EudoraRes.dll` bauen (Projekt `EudoraRes`, ebenfalls mit
   `-p:BuildProjectReferences=false`, solange OT501 nicht baut).
3. `capicom.dll` aus dem Installer nach `Bin/Debug` kopieren, falls Eudora sie beim
   Start verlangt.
4. Erst dann starten — und mit einem **frischen, leeren Mailverzeichnis**, nicht mit
   dem produktiven. Eudora legt beim ersten Start Dateien an und könnte eine
   bestehende Installation beschädigen.

Punkt 4 ist kein Formalismus: der Auftraggeber liest mit Eudora täglich Mail. Ein
Startversuch mit einer selbst gebauten, nie gelaufenen Fassung gehört in eine Kopie.

## Was hier bewusst nicht steht

Ob Eudora **startet**, sagt diese Datei nicht. Sie sagt nur, welche Dateien
danebenliegen müssen, damit der Ladevorgang nicht schon am Import scheitert. Alles
danach — Registry, `eudora.ini`, Mailverzeichnis, die Frage, ob die Ersatzschicht
zur Laufzeit trägt — ist offen.
