# Prüfung: baut ein frischer Klon?

Gregors Forderung, wörtlich:

> „ich möchte in der lage sein, nach dem repo clone selbst eine version zu bauen.
> einfach sln in VS2022 laden und build starten. das sollte ohne irgendweche
> tricks klappen!"
> „und alle DLLs sollen so auch baubar sein."
> „stelle einen agenten, der genau das prüft: daß alles sauber baut. wenn man
> clean build aufruft und hinterher build startet."

Gemessen am 05.09.2026 vom Agenten PRUEFBAU. Alles hier ist **nachgemessen**,
nicht abgeleitet: jeder Lauf hat ein Protokoll, jedes Artefakt einen
Zeitstempel, der gegen den Bau-Beginn gehalten wurde.

---

## Die Antwort in einem Satz

**Vorher: nein.** `-t:Clean` gefolgt von `-t:Build` scheiterte im frischen Klon
mit drei `LNK1181`, `-t:Rebuild` mit vier. **Nach der Behebung auf diesem Zweig
(`77424fc`): ja** — nachgewiesen in zwei eigenen, frisch geklonten
Verzeichnissen, Release und Debug, mit `Clean`+`Build` und mit `Rebuild`, jedes
Mal 0 Fehler und alle 17 Artefakte neu erzeugt.

Es fehlte **keine Datei**. Die Ursache war eine fehlende **Baureihenfolge**:
fünf Projekte banden `QCUtils.lib`, ohne einen Projektverweis auf `QCUtils` zu
tragen.

---

## Was gemessen wurde

### Die Aufstellung

Vier frische Klone, alle mit `git clone` aus dem Repo geholt und mit den drei
Einrichtungsschritten versehen. `a` und `b` stehen auf `006dbec` (OT501
draußen, sonst unverändert), `c` und `d` auf `77424fc` (zusätzlich die
Baureihenfolge behoben).

| Klon | Stand | Ziel | Konfig | RC | Fehler | Warnungen | Dauer | Artefakte neu |
|---|---|---|---|---|---|---|---|---|
| a | ohne Behebung | `Build` | Release | 0 | 0 | 4823 | 1391 s | 17 von 17 |
| a | ohne Behebung | `Clean` | Release | 0 | 0 | 0 | 12 s | — |
| a | ohne Behebung | `Build` **nach Clean** | Release | **1** | **3** | 1589 | 347 s | **13 von 17** |
| a | ohne Behebung | `Build` | Debug | 0 | 0 | 4432 | 728 s | 17 von 17 |
| b | ohne Behebung | `Rebuild` | Release | **1** | **4** | 2007 | 388 s | **13 von 17** |
| c | **mit Behebung** | `Build` | Release | 0 | 0 | 4823 | 573 s | 17 von 17 |
| c | **mit Behebung** | `Build` (Leerlauf) | Release | 0 | 0 | 61 | 78 s | — |
| c | **mit Behebung** | `Clean` | Release | 0 | 0 | 0 | 4 s | — |
| c | **mit Behebung** | `Build` **nach Clean** | Release | **0** | **0** | 4405 | 444 s | **17 von 17** |
| c | **mit Behebung** | `Build` | Debug | 0 | 0 | 4432 | 456 s | 17 von 17 |
| d | **mit Behebung** | `Rebuild` | Release | **0** | **0** | 4823 | 448 s | **17 von 17** |

„17 von 17" zählt die Artefakte der 18 gebauten Projekte ohne `OpenSSL`, dessen
angemeldete Ausgabe grundsätzlich nie entsteht (siehe unten). „Neu" heißt:
Zeitstempel **nach** dem Beginn des jeweiligen Laufs, nicht bloß vorhanden.

Die Klone lagen unter `…\Local\pb\a` bis `…\Local\pb\d`, außerhalb des Repos
und außerhalb des Temp-Verzeichnisses — Letzteres, weil MSBuild sonst 32-mal
`MSB8029` warnt („Ausgabeverzeichnis darf nicht im temporären Verzeichnis
liegen").

Die Dauern sind **nicht vergleichbar**: auf demselben Rechner (4 logische Kerne)
liefen zeitweise Bauten anderer Agenten und Klonvorgänge. Ein ungestörter
Release-Bau derselben Projektmappe dauerte in einem Vorlauf **4:39**; unter Last
wurde daraus 23 Minuten. Für die Frage „läuft es durch" ist das ohne Belang, für
jede Aussage über Geschwindigkeit aber schon.

### Wie gemessen wurde — und warum nicht am Rückgabewert

MSBuild kann mit 0 zurückkommen, ohne etwas gebaut zu haben. Deshalb dreimal
gemessen:

1. **Protokoll** — `grep` auf `error`/`fatal error` in der vollständigen Ausgabe
   jedes Laufs, zusätzlich die Endsummenzeile.
2. **Zeitstempel** — jedes erwartete Artefakt gegen den in Sekunden
   festgehaltenen Bau-Beginn (`artefakte.sh`). Ein Artefakt, das älter ist als
   der Bau, zählt nicht als gebaut.
3. **Versionsressource** — `Eudora.exe` gegen `EUDORA_BUILD_VERSION` in
   `Eudora71/Version.h`.

Der dritte Punkt trägt. `Version.h` sagt an diesem Commit `"7.2.0.3"`, und die
gebauten Dateien melden dasselbe:

| Datei | FileVersion | ProductVersion | FileDescription |
|---|---|---|---|
| `Bin/Release/Eudora.exe` (Klon c) | 7.2.0.3 | 7.2.0.3 | EUDORA |
| `Bin/Debug/Eudora.exe` (Klon a) | 7.2.0.3 | 7.2.0.3 | EUDORA |
| `Bin/Release/EudoraRes.dll` (Klon c) | 7.2.0.3 | — | — |

`InternalName` steht auf `EUDORA32`, `OriginalFilename` auf `EUDORA.EXE`,
`CompanyName` auf `QUALCOMM Incorporated`. Die Ressource kommt über
`Eudora/EudoraExeVer.rc` → `..\VersionBeg.inc` aus derselben `Version.h`; hätte
der Bau die alte EXE nur liegen lassen, stünde hier eine andere Nummer.

Und der zweite Punkt hat sich sofort ausgezahlt: der Lauf `a`/`Build` **nach
Clean** endete mit `RC=1` — der Rückgabewert stimmte hier. Aber `a`/`Clean`
endete mit `RC=0` und hat trotzdem **nicht sauber aufgeräumt** (siehe unten).
Wer nur auf den Rückgabewert sieht, hält `Clean` für erledigt.

---

## Der Befund: die fehlende Baureihenfolge

### Was passiert

Fünf Projekte binden `QCUtils.lib`, tragen aber **keinen Projektverweis** auf
`QCUtils`:

| Projekt | bindet | verweist auf QCUtils |
|---|---|---|
| `NSImport` | `QCUtils.lib` | **nein** |
| `OEImport` | `QCUtils.lib` | **nein** |
| `OLImport` | `QCUtils.lib` | **nein** |
| `QCSSL` | `QCUtils.lib`, `EuMemMgr.lib` | **nein** (nur `QCSocket`) |
| `plstclnt` | `QCUtils.lib`, `eulang.lib` | **nein** (nur `EuLang`) |

Ohne Verweis ist die Reihenfolge im Parallelbau undefiniert. MSBuild mit `-m`
baut parallel — und **die VS2022-IDE baut immer parallel**. Der Linker der
Importfilter greift dann auf `Lib\Release\QCUtils.lib` zu, während `QCUtils`
noch bindet:

```
LINK : fatal error LNK1181: Eingabedatei "QCUtils.lib" kann nicht geöffnet werden.
```

### Warum ausgerechnet nach einem Clean

Im ersten Bau eines frischen Klons ist das ein **Wettlauf**: mal trifft er zu,
mal nicht. Beide Ausgänge wurden gemessen — derselbe Befehl im selben Zustand:

* Vorlauf am 05.09. um 19:35: **2 Fehler**, `NSImport` und `OEImport`; es fehlten
  `Eudora.exe`, `NSImport.eif`, `OEImport.eif`.
* Lauf `a1` um 19:48 (unter höherer Last, dadurch andere Reihenfolge):
  **0 Fehler**, alle 17 Artefakte da.

Nach `-t:Clean` ist es **kein Wettlauf mehr, sondern die Regel**: `Clean` löscht
`Lib\Release\QCUtils.lib` und alle `.lastbuildstate`. Im folgenden `Build` müssen
alle Projekte neu binden, und die drei Importfilter sind schneller fertig als
`QCUtils` — jedes Mal. Lauf `a3` zeigt genau das: **3 Fehler**, in `NSImport`,
`OEImport` und `OLImport`. Weil `Eudora.vcxproj` auf alle drei verweist, fällt
`Eudora.exe` mit aus.

Fehlende Artefakte nach `Clean` + `Build` ohne Behebung (Lauf `a3`):
`Bin\Release\Eudora.exe`, `NSImport.eif`, `OEImport.eif`, `OLImport.eif`.

Dasselbe bei `-t:Rebuild` im zweiten frischen Klon (Lauf `b1`): **4 Fehler**, in
`NSImport`, `OEImport`, `OLImport` und **`plstclnt`**. Fehlende Artefakte:
`Eudora.exe`, `plstclnt.dll`, die drei `.eif`. `plstclnt` ist der Beleg dafür,
dass es nicht nur die Importfilter trifft — deshalb sind alle fünf Projekte
behoben, nicht nur die drei auffälligen.

### Die Behebung

Commit `77424fc` trägt in den fünf Projektdateien je einen Projektverweis auf
`QCUtils` nach:

```xml
<ProjectReference Include="..\..\QCUtils\QCUtils.vcxproj">
  <Project>{8153db1a-f996-48a8-a1a6-b183c086a94d}</Project>
  <ReferenceOutputAssembly>false</ReferenceOutputAssembly><LinkLibraryDependencies>false</LinkLibraryDependencies>
</ProjectReference>
```

`ReferenceOutputAssembly=false` und `LinkLibraryDependencies=false` sind
Absicht und entsprechen dem, was `Eudora.vcxproj` schon überall so macht: der
Verweis stellt **nur die Reihenfolge** her, gebunden wird weiter über
`AdditionalDependencies`. Kein Kniff, kein zusätzlicher Schalter, kein
Sonderweg — die Projektdatei sagt jetzt, was sie ohnehin braucht.

Nachweis, gelaufen in einem **neu geklonten** Verzeichnis (`c`), das die
Behebung von Anfang an enthielt:

* `Build` aus dem frischen Klon: **0 Fehler**, 17 von 17 Artefakten neu.
* `Clean`, dann `Build`: **0 Fehler**, 17 von 17 Artefakten neu — das ist
  Gregors Frage, und die Antwort ist ja.
* `Build` in Debug: **0 Fehler**, 17 von 17.

Und im **vierten** frischen Klon (`d`), der nie etwas anderes gesehen hat als
`-t:Rebuild`: **0 Fehler**, 17 von 17 Artefakten neu, `Eudora.exe` mit
`FileVersion 7.2.0.3`. Genau der Befehl, der am Vormittag `OTA50R.lib`
gelöscht hatte, läuft jetzt durch, ohne eine einzige verfolgte Datei zu
verlieren.

Gegenprobe an den Zeitstempeln desselben Laufs `c4`: `Lib\Release\QCUtils.lib`
entsteht um **20:48:08**, danach `NSImport.eif` 20:48:27, `OEImport.eif`
20:48:30, `OLImport.eif` 20:48:33. Die Reihenfolge steht jetzt fest, statt sich
zu ergeben. (Die späteren Zeitstempel auf `QCUtils.dll` und `plstclnt.dll`
— 20:55 — stammen aus dem Nachbearbeiten mit `Bind.Exe` am Ende des Baus, siehe
den Abschnitt weiter unten.)

---

## Voraussetzung dafür, dass das überhaupt so weit kam: OT501 ist draußen

Am 05.09.2026 hat ein `-t:Rebuild` die vorgebaute, in **keinem** Commit und
**keinem** Release-ZIP vorhandene `Eudora71/OT501/Src/OTA50R/OTA50R.lib`
gelöscht — endgültig. Daraufhin nachgesehen und belegt: **niemand braucht sie.**

* Kein Projekt bindet `OTA50R.lib`/`OTA50D.lib`. Die einzige Erwähnung steht in
  `Eudora.vcxproj` unter `IgnoreSpecificDefaultLibraries` — also um sie
  ausdrücklich **nicht** zu binden.
* Beide Projektverweise trugen bereits `LinkLibraryDependencies=false`.
* Keine Quelldatei bindet Stingray-Kopfdateien ein; die Ersatzschicht
  `Eudora71/OTShim/` hat OT501 abgelöst.

Deshalb ist `OT501` mit Commit `006dbec` aus dem Bau genommen: Projektverweise
aus `Eudora.vcxproj` und `EudoraRes.vcxproj`, die beiden `.Build.0`-Zeilen aus
`Eudora.sln`. Damit **kann ein Clean oder Rebuild diese Bibliothek nicht mehr
löschen**, und die drei OT501-Fehler, die die README bis eben noch nannte
(zweimal `NMAKE U1073`, einmal `MSB3073`), treten nicht mehr auf.

Gemessen: in **keinem** der elf hier protokollierten Läufe kam ein
OT501-Fehler vor, und in keinem Klon hat ein `Clean` oder `Rebuild` eine Datei
unter `Eudora71/OT501/` angefasst. Die Folgerung, die zu prüfen war — „jetzt,
wo OT501 draußen ist, müsste ein Clean+Build wieder gefahrlos durchlaufen" —
ist damit **zur Hälfte bestätigt**: gefahrlos ja, durchlaufen aber erst nach
der zweiten Behebung oben. Die beiden Fragen sahen nur gleich aus.

---

## `Clean` räumt nicht sauber auf

Gemessen an Klon `a`: nach `-t:Build` (erfolgreich, 17 Artefakte) und
anschließendem `-t:Clean` (`RC=0`, 0 Fehler, 12 s) waren **noch 13 der 17
Artefakte da**, mit den Zeitstempeln des vorherigen Baus:

* **gelöscht**: `Bin\Release\Eudora.exe`, `Bin\Release\Imap.dll`,
  `Lib\Release\EuImap.lib`, `Lib\Release\QCUtils.lib`, die drei `.eif`
* **stehen geblieben**: `EuLang.dll`, `EudoraRes.dll`, `QCSSL.dll`,
  `QCSocket.dll`, `QCUtils.dll`, `plstclnt.dll`, `msvcr71.dll`,
  `AccountWizard.lib`, `DirectoryServicesUI.lib`, `SearchEngine.lib`,
  `EudoraOldIcons.epi`

Im Klon `c` dasselbe Bild, mit demselben Satz gelöschter Dateien.

Das Protokoll des `Clean`-Laufs nennt namentlich nur 17 gelöschte
`.lastbuildstate`-Dateien. „Clean" heißt hier also: **Bauzustand vergessen**,
nicht **Ausgabe entfernen**. Wer nach einem `Clean` glaubt, ein leeres
Ausgabeverzeichnis vor sich zu haben, irrt. Das ist auch der Grund, warum der
`Build` nach einem `Clean` fast so lange dauert wie ein vollständiger: der
Bauzustand ist weg, also wird alles neu übersetzt (444 s gegen 573 s).

---

## Der Bau fasst versionierte Dateien an

Das ist der zweite strukturelle Befund und derselbe Fehlerkreis, dem `OTA50R.lib`
zum Opfer gefallen ist: **Ausgabeverzeichnisse und versionierte Binärdateien
liegen im selben Ordner.** `Eudora71/Bin/{Debug,Release}` und
`Eudora71/Lib/{Debug,Release}` sind `OutDir` der Projekte **und** enthalten
rund 130 verfolgte Dateien.

Nach einem `Build` + `Clean` im frischen Klon meldete `git status`
**20 veränderte oder gelöschte verfolgte Dateien** — in Klon `a` und in Klon `c`
unabhängig voneinander dieselbe Liste:

**verändert** (durch das Nachbearbeiten mit `BinTools\Bind.Exe` aus
`PostProcessRel.bat`, das die Importtabellen jeder DLL im Ausgabeordner
umschreibt — auch die fremden):

`Bin/Release/DirServ.dll`, `EuMemMgr.dll`, `EudoraBk.dll`, `ISock.dll`,
`LDAP32.DLL`, `Ldap.dll`, `Paige32.dll`, `Ph.dll`, `SPELL32.DLL`,
`libeay32.dll`, `libexpat.dll`, `ssleay32.dll`

**gelöscht bzw. neu geschrieben** (MIDL-Erzeugnisse, die zugleich versioniert
sind):

`Eudora/EudoraExe.h`, `EudoraExe.tlb`, `EudoraExe_i.c`, `EudoraExe_p.c`,
`GoogleDesktopSearchAPI.h`, `GoogleDesktopSearchAPI_i.c`,
`GoogleDesktopSearchAPI_p.c`, `dlldata.c`

Dazu entsteht eine **unverfolgte** Datei: `Eudora71/EMSAPI/EMSSDK/emsapi-win.h`
(aus `BinTools\UpdateExternalEMSAPIHeader.pl`). Sie erklärt den `??`-Eintrag,
der im Hauptbaum seit Tagen steht.

**Folge:** ein frischer Klon ist nach einem einzigen Bau schmutzig. Alles davon
ist versioniert und mit `git checkout --` wiederherstellbar — anders als
`OTA50R.lib`, das nirgends lag. Der Schaden ist also Lärm, kein Verlust. Aber
der Mechanismus ist derselbe, und beim nächsten nicht versionierten
Vorgabe-Binär trifft er wieder.

Zwei Gegenproben, die den Mechanismus festnageln:

* Im Lauf `b1` (Rebuild, ohne Behebung) blieb `git status` **leer**. Dort ist
  `Eudora.vcxproj` gar nicht erst gebunden worden, also lief weder MIDL noch das
  `PostBuildEvent` `call ..\BinTools\PostProcessRel Eudora`. Kein Bau von
  `Eudora` — keine verschmutzten Dateien.
* Im Protokoll steht, was `Bind.Exe` anfasst, Zeile für Zeile:
  `BIND: DirServ.dll - Imports from QCUtils.dll`. Es geht alle DLLs im
  Ausgabeordner durch, auch die mitgelieferten fremden.

Sauber wäre: die MIDL-Erzeugnisse aus der Versionierung nehmen (der Bau
erzeugt sie ohnehin, MIDL liegt im Windows SDK), und die vorgebauten
Fremd-DLLs aus `Bin/` in ein eigenes, nicht als `OutDir` benutztes
Verzeichnis legen, aus dem der Bau sie kopiert. Beides ist eine Entscheidung
für Gregor, nicht für diesen Agenten — deshalb hier nur belegt, nicht gemacht.

---

## Vollständigkeit: welche DLLs baut die Projektmappe?

`Eudora71/Eudora.sln` enthält **19** Projekte. `OT501` ist seit `006dbec` ohne
`.Build.0`-Zeile, also 18 gebaute Projekte. Alle 18 erzeugen ihr Artefakt —
mit **einer** Ausnahme:

| Projekt | Art | Artefakt | im Bau erzeugt |
|---|---|---|---|
| `Eudora` | Application | `Bin\<Konfig>\Eudora.exe` | ja |
| `EudoraRes` | DLL | `Bin\<Konfig>\EudoraRes.dll` | ja |
| `EuLang` | DLL | `Bin\<Konfig>\EuLang.dll` | ja |
| `Imap` | DLL | `Bin\<Konfig>\Imap.dll` | ja |
| `QCUtils` | DLL | `Bin\<Konfig>\QCUtils.dll` | ja |
| `QCSocket` | DLL | `Bin\<Konfig>\QCSocket.dll` | ja |
| `QCSSL` | DLL | `Bin\<Konfig>\QCSSL.dll` | ja |
| `plstclnt` | DLL | `Bin\<Konfig>\plstclnt.dll` | ja |
| `VC71Bruecke` | DLL | `Bin\<Konfig>\msvcr71.dll` | ja |
| `NSImport` | DLL | `Bin\<Konfig>\NSImport.eif` | ja |
| `OEImport` | DLL | `Bin\<Konfig>\OEImport.eif` | ja |
| `OLImport` | DLL | `Bin\<Konfig>\OLImport.eif` | ja |
| `EudoraOldIcons` | DLL | `EudoraOldIcons\<Konfig>\EudoraOldIcons.epi` | ja |
| `AccountWizard` | statisch | `Lib\<Konfig>\AccountWizard.lib` | ja |
| `DirectoryServicesUI` | statisch | `Lib\<Konfig>\DirectoryServicesUI.lib` | ja |
| `EuImap` | statisch | `Lib\<Konfig>\EuImap.lib` | ja |
| `SearchEngine` | statisch | `Lib\<Konfig>\SearchEngine.lib` | ja |
| `OpenSSL` | Makefile | `OpenSSL\<Konfig>\OpenSSL.exe` | **nein — nie** |
| `OT501` | statisch | — | nicht mehr im Bau |

Wer die Importfilter in `Bin\Release` als `NSImport.dll` sucht, findet sie
nicht: sie heißen `.eif` (Eudora Import Filter), `EudoraOldIcons` heißt `.epi`.
Das ist so gewollt (`<OutputFile>$(OutDir)$(ProjectName).eif`), erzeugt aber bei
jedem Bau die Warnungen `MSB8012`.

### Das Projekt `OpenSSL` ist toter Ballast im Bau

* Es ist ein Makefile-Projekt und ruft `nmake /f "ms\nt.mak"` auf — den
  OpenSSL-0.9.x-Baum von 2006.
* Seine `<NMakeOutput>` heißt `OpenSSL.exe` und **existiert nach keinem Lauf**.
  MSBuild hält es deshalb bei **jedem** Bau für veraltet und baut es neu.
* `QCSSL` bindet nicht dagegen, sondern gegen `..\OpenSSL3/lib`
  (`libssl.lib`, `libcrypto.lib`, versioniert unter `Eudora71/OpenSSL3/lib/`).
* `git grep` über alle `.vcxproj`: **kein** Projekt bindet `libeay32` oder
  `ssleay32`.

Gemessen: ein **zweiter Bau ohne jede Änderung** (Lauf `c2`, direkt nach `c1`)
dauert **78 Sekunden** und meldet 61 Warnungen. Ein Bau, bei dem nichts zu tun
ist, sollte Sekunden dauern. Der Löwenanteil davon ist der `nmake`-Lauf von
`OpenSSL`, der wegen der nie entstehenden `OpenSSL.exe` immer wieder anläuft.

Das ist derselbe Fall wie OT501, nur ohne Datenverlust: ein Projekt im Bau, das
niemand braucht, das aber jeden Bau verlängert. Es wurde hier **nicht** entfernt
— es bricht nichts, und die Entscheidung gehört Gregor. Der Beleg steht damit
bereit.

### „Alle DLLs baubar" — die ehrliche Antwort

12 der 18 gebauten Projekte erzeugen eine DLL, und alle 12 bauen. Aber
`Eudora71/Bin/` enthält **20 weitere** ausgelieferte Binärdateien, die **kein**
VS2022-Projekt hat:

* mit altem VC7-Projekt, nie umgestellt: `DirServ.dll`, `EudoraBk.dll`,
  `ISock.dll`, `Ldap.dll`, `Ph.dll`, `Paige32.dll` (aus `PaigeDLL/PAIGE32`),
  `EuMemMgr.dll` (aus `EuMemMgr/BugslayerUtil`, `JFX`, `SymbolEngine`)
* nur als Binärdatei vorhanden: `EuMAPI32.dll`, `EUMAPI.DLL`, `EuShlExt.dll`,
  `EudoraNS.dll`, `EuGraph.ocx`, `SPELL32.DLL`, `LDAP32.DLL`, `x1lib.dll`,
  `libexpat.dll`, `dbghelp.dll`, `libeay32.dll`, `ssleay32.dll`,
  `swEudora.exe`

Dazu die statisch gebundene `Lib/<Konfig>/EuMemMgr.lib`, die **sechs** Projekte
binden und die als vorgebaute Datei im Repo liegt. Sie ist versioniert — geht
sie verloren, holt `git checkout --` sie zurück. Das ist der Unterschied zu
`OTA50R.lib`.

Auch die acht EMSAPI-Erweiterungen (`Attach`, `Junk`, `Launch`, `PseudoSn`,
`PseudoSq`, `Sort`, `ToolMenu`, `UpprLowr`) und `Eudora71/Tests/Tests.vcxproj`
stehen nicht in der Projektmappe.

**Kurz:** „`.sln` laden, Build drücken" baut die 18 Projekte der Projektmappe
vollständig. Es baut **nicht** alles, was im Auslieferungsordner liegt — rund
zwanzig DLLs sind mitgelieferte Binärdateien ohne heutiges Projekt. Wer das
ändern will, muss die alten `.vcproj` umstellen; das ist eigene Arbeit und
steht hier nur als Befund.

---

## Was ein frischer Klon zusätzlich braucht

### Von Visual Studio 2022

Alle Projektdateien tragen `PlatformToolset v143`. Gebraucht wird die
**Workload „Desktopentwicklung mit C++"** mit:

* **MSVC v143 — VS 2022 C++ x64/x86 Buildtools**
* **C++-MFC für v143-Buildtools (x86 & x64)** — 33 Projektkonfigurationen
  tragen `UseOfMfc=Dynamic`
* **C++-ATL für v143-Buildtools (x86 & x64)** — zwei tragen `UseOfAtl=Static`
* **Windows-SDK** (gemessen mit 10.0.22621.0) — liefert auch `midl.exe`, das
  der Bau von `Eudora.vcxproj` braucht
* `nmake` (Teil der Buildtools) — für das Makefile-Projekt `OpenSSL`

Die **IDE selbst wird nicht gebraucht**: alle Läufe dieser Prüfung liefen über
`MSBuild.exe` von der Kommandozeile.

### Einrichtung nach dem Klonen

```bash
git config core.autocrlf false
sh tools/hooks-einrichten.sh
perl tools/zeilenenden-angleichen.pl --aendern
```

In den vier für diese Prüfung angelegten Klonen meldete der dritte Schritt
jedesmal **6444 Dateien byteidentisch zu HEAD, 0 anzugleichen** — weil der
erste Schritt schon vor dem Klonen wirksam war. Wer mit `core.autocrlf=true`
klont, bekommt genau die 4616 stillschweigend umgeschriebenen Dateien, die
Befund S-7 beschreibt.

`perl` wird **nicht zwingend** gebraucht: der `PreBuildEvent` von
`Eudora.vcxproj` sucht `perl`, dann `C:\Program Files\Git\usr\bin\perl.exe`,
und kopiert sonst `BuildKennung-vorlage.h` — der Bau läuft weiter, die Kennung
sagt dann „unbekannt". Für die drei Einrichtungsschritte oben braucht man es
aber (Git für Windows bringt es mit).

### Der Bau selbst

```bash
"C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" Eudora71\Eudora.sln -t:Build -p:Configuration=Release -p:Platform=x86 -m
```

Zwei Stolpersteine, beide nicht im Repo begründet:

* **Plattformname.** Die Projektmappe kennt `x86`, die Projektdateien `Win32`.
  `-p:Platform=Win32` an die `.sln` gibt `MSB4126`.
* **Pfadlänge.** In einem Verzeichnis mit langem Pfad bricht der Bau ab:
  ```
  error MSB6003: Die angegebene ausführbare Datei der Aufgabe "CL.exe" konnte
  nicht ausgeführt werden. System.IO.DirectoryNotFoundException: ...
  ```
  Gemessen in einem Klon 132 Zeichen unterhalb der Wurzel — der längste
  Zwischenpfad des Baus ist rund 105 Zeichen, zusammen über der
  260-Zeichen-Grenze. Ein Klon unter `C:\Users\<Name>\Documents\github\` ist
  unkritisch. Zusätzlich: liegt der Klon unterhalb des Temp-Verzeichnisses,
  warnt MSBuild 32-mal mit `MSB8029`.

### Was der Bau meldet, ohne dass etwas kaputt ist

Ein durchlaufender Release-Bau meldet rund **4800 Warnungen**, ein Debug-Bau
rund **4400**. Die häufigsten: `C4996` (veraltete CRT-Funktionen, 2380×),
`C4840`, `C4005` (Makro-Neudefinition), `C4091`. Dazu `MSB8012` (`.eif`/`.epi`
statt `.dll`) und `LNK4286`/`LNK4070` aus `libpng.lib`. Keine davon ist neu,
keine wurde in dieser Prüfung angefasst.

---

## Was offen bleibt

1. **`Clean` räumt nicht auf** — 13 von 17 Artefakten überleben ein `-t:Clean`.
   Wer wirklich leer anfangen will, löscht `Bin/`, `Lib/`, `Build/`, `ResBuild/`
   von Hand — und stellt danach die versionierten Dateien in `Bin/` und `Lib/`
   mit `git checkout --` wieder her.
2. **Der Bau verschmutzt den Arbeitsbaum** — 20 verfolgte Dateien, siehe oben.
   Behebbar, aber eine Entscheidung.
3. **Das Projekt `OpenSSL`** baut bei jedem Lauf den Baum von 2006 neu, obwohl
   niemand dagegen bindet. Es zu streichen wäre derselbe Handgriff wie bei
   `OT501`.
4. **Rund 20 ausgelieferte DLLs** haben kein VS2022-Projekt. Gregors Satz „alle
   DLLs sollen so auch baubar sein" ist für die Projektmappe erfüllt, für den
   Auslieferungsordner nicht.

---

## Wie man diese Prüfung wiederholt

```bash
git clone <url> pruefklon
cd pruefklon
git config core.autocrlf false
perl tools/zeilenenden-angleichen.pl --aendern
MSB="C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
"$MSB" Eudora71\Eudora.sln -t:Build   -p:Configuration=Release -p:Platform=x86 -m
"$MSB" Eudora71\Eudora.sln -t:Clean   -p:Configuration=Release -p:Platform=x86 -m
"$MSB" Eudora71\Eudora.sln -t:Build   -p:Configuration=Release -p:Platform=x86 -m
git status --short          # zeigt, was der Bau an verfolgten Dateien angefasst hat
```

Und danach **nicht** dem Rückgabewert glauben, sondern nachsehen, ob
`Eudora71/Bin/Release/Eudora.exe` einen Zeitstempel **nach** dem Bau-Beginn hat.
