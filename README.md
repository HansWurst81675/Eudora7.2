# Eudora 7.2

<!-- pruefstand: 9512108 -->
<!-- Die Marke oben nennt den Commit, gegen den diese Datei zuletzt abgeglichen
     wurde. Wer die Datei nachzieht, zieht die Marke mit.
     Gelesen von tools/pruefstand-melden.pl (Befund NP3-7). -->

Portierung des Eudora-7.1-Quellcodes auf Visual Studio 2022 — mit dem Ziel, den
Mailclient wieder selbst bauen und weiterentwickeln zu können.

Grundlage ist die Quelltextfreigabe des [Computer History Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/)
(2018, mit Genehmigung von Qualcomm).

> **Diese Datei sagt, was jetzt gilt.** Stand **06.09.2026**.
>
> **Zwei Nummern, die nichts miteinander zu tun haben.** Der **Quellstand** ist
> **7.2.0.14** — das steht in `Eudora71/Version.h` (`EUDORA_BUILD_VERSION`) und
> ist die Produktversion, die ein Bau aus diesem Klon in die `Eudora.exe`
> schreibt. Die **Paketnummer** steht in der Datei `VERSION` und lautet
> **1.0.14**; sie benennt das ZIP. `cat VERSION` liefert also **nicht** die
> Quellversion, sondern die Paketnummer — beide liest `tools/ausliefern.pl`
> getrennt ein.
>
> **Beide zeigen auf dasselbe:** `Releases/Eudora72-1.0.14-release.zip`,
> geschnürt am 06.09.2026 aus Commit `ba7d43a`, geprüft mit
> `tools/paket-pruefen.ps1` (*„keine Fehler", „In der Startkette fehlt
> nichts", Kriterium 0 — JA*). Die Bau-Kennung im Fenstertitel nennt beide
> Nummern plus den Commit, ein Bildschirmfoto ist damit eindeutig zuzuordnen.
>
> Wer wann was gemessen hat, steht in [BEFUNDE.md](BEFUNDE.md) und im
> git-Verlauf — hier nicht.

## Stand

**Sieben Kriterien stehen in [ZIEL.md](ZIEL.md) — vier sind belegt, eines fast,
drei nicht.** Eudora baut aus einem frischen Klon, das Paket startet auf einem
Rechner ohne Visual Studio, die Darstellung stimmt weitgehend, und Mail wird
über TLS abgerufen.

**Benutzbar ist es noch nicht.** Verfassen und Weiterleiten öffnen zwar kein
Fenster mehr mit einem Absturz, aber es erscheint eine **modale** Meldung „An
unhandled exception has occurred" — und danach lässt sich Eudora nicht einmal
mehr beenden (**E-32**). Gregors Urteil zu 1.0.18: *„es crasht nicht, aber es
passiert auch nichts. nichts statt crash ist auch keine verbesserung!"*

Was offen ist, steht vollständig in [CHANGELOG.md](CHANGELOG.md).

Belegt:

| Was | Beleg |
|---|---|
| **Bau** | ganze Projektmappe aus einem frischen Klon: **18 erfolgreich, 0 Fehler, 1 übersprungen**, 2:37 min. Von Gregor am 06.09.2026 in der IDE nachgemessen. Das eine übersprungene ist `OT501`, siehe unten |
| **Start und Bedienung** | Hauptfenster, Menüs, Werkzeugleiste, Postfachbaum |
| **Mailabruf über TLS** | POP3 auf **Port 995**, *Tools → Last SSL Info*: `Negotiation Status: Succeeded`, **TLSv1.3**, `TLS_AES_256_GCM_SHA384`. Gemessen an 7.2.0.12 am 06.09.2026 gegen `mx.freenet.de`. Die richtige Einstellung dafür ist *Secure Sockets when Receiving* → **„Required, Alternate Port"** |
| **Darstellung** | Bau-Kennung im Titel (E-7), Fortschritt beim Abruf (E-13), Umlaute in HTML-Mail (Z-2b) |
| **Kriterium 0 — Paket laeuft ohne Nachinstallieren** | Gregor hat `Eudora72-1.0.10-release.zip` am 06.09.2026 auf einem Rechner **ohne Visual Studio** ausgepackt und gestartet: *„test bestanden: eudora läuft ohne VS2022 installiert."* Damit ist das letzte offene der ersten vier Kriterien aus [ZIEL.md](ZIEL.md) belegt — keine fehlende DLL, kein `0xc000007b`, nichts nachzuinstallieren. Vorhergesagt hatte es `tools/paket-pruefen.ps1` aus den PE-Importtabellen (13 Module in der Startkette, 251 Importe gegen Windows-eigene Bibliotheken, *„In der Startkette fehlt nichts"*) — die Vorhersage und der Lauf am lebenden Objekt stimmen überein |

### Was an 7.2.0.14 zu prüfen ist

Paket: `Releases/Eudora72-1.0.14-release.zip`. Auspacken, **`Eudora starten.cmd`**
doppelklicken (nicht `Eudora.exe` — der Starter übergibt das Mailverzeichnis).

| Prüfen | erwartet | wenn nicht |
|---|---|---|
| **Doppelklick** auf eine Nachricht | öffnet sie | E-28 greift nicht |
| **Suchtreffer anklicken** | öffnet die Nachricht | dito |
| **Strg-N** | war bisher lautloser Tod | siehe unten — jetzt hinterlässt es Spuren |
| **Beenden** | sauber | Absturz war bisher offen |
| **Werkzeugleiste** im Suchfenster | abgeschaltete Knöpfe | E-30 noch offen, Symbole fehlen dort |

**Strg-N ist der wichtigste Punkt, und er ist jetzt auswertbar.** Bisher starb
das Programm ohne jede Spur. Der Grund ist gefunden: der Absturzbehandler hing
nur an `SetUnhandledExceptionFilter`, und vier Wege gehen daran vorbei —
Heap-Beschädigung, der `/GS`-Wächter, ein ungültiges Argument an die
C-Laufzeit, und `std::terminate`. Drei davon sind seit 7.2.0.14 angemeldet und
schreiben Klartext.

Nach einem Strg-N-Absturz also **zwei Dateien** im Mailverzeichnis ansehen:

- **`eudora.log`** — die letzte Zeile mit `E-27` nennt die letzte Station, die
  noch erreicht wurde. 15 Spurmarken liegen auf dem Weg; sie schreiben **ohne**
  INI-Änderung.
- **`Exception.log`** — enthält jetzt die Modultabelle. Damit:

```bash
perl tools/absturz-auswerten.pl
```

Das Werkzeug findet Bericht und Karte selbst und macht aus jeder Zeile des
Aufrufstapels einen Funktionsnamen. **Bleibt `Exception.log` leer**, war es
Heap-Beschädigung — dann hilft nur Page Heap (siehe unten).

### Offen — Stand 06.09.2026

- **Strg-N** beendet Eudora; die schuldige Zeile ist **nicht** gefunden. Beste
  Spur: `Paige32.dll` und `EuMemMgr.dll` sind vorgebaute Binärdateien von 2005,
  die `malloc`/`free` aus `MSVCR71` holen — **zwei getrennte Halden** neben der
  UCRT von `Eudora.exe`. Das Verfassen-Fenster ist der Hauptbenutzer von Paige.
  Speicher, der über diese Grenze gereicht wird, ergibt genau `0xC0000374`
- **Beenden** bricht ab
- **Werkzeugleiste:** abgeschaltete Knöpfe zeigen kein Symbol (E-30, in
  Arbeit). Die Symbole selbst sind in Ordnung — sie erscheinen im Hauptfenster
  vollständig und fehlen nur dort, wo der Knopf abgeschaltet ist. Gemessen:
  `SetDisabledImageList` kommt im Projekt nicht vor, und die Bilderliste wird
  mit `ILC_COLORDDB` angelegt (heute 32 Bit statt der 8, für die der Code
  geschrieben wurde). Siehe [Befunde/SYMBOLE-VORARBEIT.md](Befunde/SYMBOLE-VORARBEIT.md)
- Meldung **„Encountered an improper argument"** — reproduzierbar: *Find
  Messages*, Suche mit einem Treffer (7.2.0.10)

### Die Suche nach der Wurzel der Abstürze

Das ist die wichtigste Erkenntnis vom 06.09.2026, und sie stellt die bisherige
Suche vom Kopf auf die Füße.

Im **Windows-Ereignisprotokoll** (Quelle *Application Error*), das bis dahin
niemand gelesen hatte, steht:

```
7.2.0.10   0xc0000374   STATUS_HEAP_CORRUPTION   in ntdll   (zweimal)
7.2.0.7    0xc0000005                            in ntdll
```

**Der Heap wird beschädigt.** Damit sind `afxcoll.inl:213` und die Meldung
„Encountered an improper argument" **Folge, nicht Ursache**: eine beschädigte
`CPtrArray` trägt beschädigte `m_nSize` und `m_pData`, und dann meldet *jeder*
Zugriff „Index außerhalb" — auch ein korrekt begrenzter. Wer dort einen
unbegrenzten Index sucht, sucht am falschen Ort.

Die Beschädigung selbst ist gefunden (**E-25**): eine **Doppelfreigabe** in
`Eudora71/Importers/NSImport/NSImportClass.cpp`, `LocateNetscapePrefsFile`.
`FileList` kommt als Zeiger *nach Wert* an; der Aufräumer gab den Knoten des
**Aufrufers** frei und setzte nur die örtliche Kopie auf NULL — danach Zugriff
auf Freigegebenes und eine zweite Freigabe. Letztes geladenes Modul im
Fehlerbericht: `NSImport.eif`. Der Weg läuft **immer**, auch ohne Netscape.

Eine beschädigte Halde wirkt **global und verzögert**. Das erklärt zwanglos alle
fünf Beobachtungen aus einer Wurzel.

> **Die Hypothese hat den Test nicht bestanden.** 7.2.0.12 stürzt weiter ab.

### Das Absturzprotokoll — und wie man es liest

Eudora schreibt seinen eigenen Absturzbericht, ohne dass man etwas einschalten
muss: **`Mailverzeichnis\Exception.log`** neben der EXE. Gregor hat 7.2.0.12 am
06.09.2026 um 00:32 laufen lassen, und darin steht:

```
Eudora.exe caused an EXCEPTION_ACCESS_VIOLATION in module <UNKNOWN>
at 0023:414E3345
Call stack: 00894B53, 008962D7, 6FB9A3E6 (mfc140.dll), ...
```

**Das Modul heißt `<UNKNOWN>`.** Der Sprung ging auf eine Adresse, die zu
*keinem* geladenen Modul gehört. So etwas passiert, wenn eine Sprungtabelle oder
ein Funktionszeiger überschrieben wurde — genau das Schadensbild einer
beschädigten Halde. Die Doppelfreigabe E-25 war demnach **nicht die einzige
Quelle**.

#### Warum die Adressen bis 7.2.0.12 nichts hergaben

Die EXE ist 2,8 MB groß; läge sie wie vorgesehen auf `0x00400000`, endete sie
bei `0x006CD000`. Die protokollierte Adresse `0x00894B53` liegt weit dahinter.
Windows lädt sie also **verschoben** (ASLR), und der Bericht schrieb die
tatsächliche Ladeadresse **nicht mit**. Ohne sie ist jede Umrechnung in einen
Funktionsnamen geraten. Ein erster Versuch am 06.09. rechnete gegen
`0x00400000` und lieferte prompt einen Namen aus dem Ressourcenbereich —
sichtbarer Unsinn, und der Beweis, dass die Rechnung nicht stimmte.

#### Beide Hälften sind jetzt da

| Hälfte | Wo | Seit |
|---|---|---|
| **Namen zu Adressen**: `Eudora71/Bin/Release/Eudora.map`, 51.075 Einträge | `Eudora.vcxproj` erzeugt sie bei jedem Bau | 06.09.2026 |
| **Ladeadressen**: eine Modultabelle im Bericht, vor dem Aufrufstapel | `QCExceptionHandler::WriteModuleTable` in [ExceptionHandler.cpp](Eudora71/Eudora/ExceptionHandler.cpp) (E-26) | 06.09.2026 |

Ein Bericht **ab 7.2.0.14** beginnt deshalb so:

```
Loaded modules - subtract the load address from a stack address to get
the offset listed in the .map file of that module:
Load address  Size      Module
00E30000      002CD000  Eudora.exe
6FB00000      ...       mfc140.dll
```

Adresse minus Ladeadresse ergibt den Versatz, den die `.map` kennt. Damit wird
aus jeder Zeile des Aufrufstapels ein Funktionsname — **ohne Debugger und ohne
Visual Studio**, aus einer Textdatei, die ein Anwender einfach mitschicken kann.
Das war Gregors Vorschlag: *„oder du schreibst eine log datei, während eudora
ausgeführt wird, dann steht es darin, was der letzte aufruf war."*

Berichte von **7.2.0.12 und älter** haben die Tabelle nicht und bleiben
unauflösbar. Das ist kein Mangel des Werkzeugs, sondern eine Tatsache über die
alten Dateien — geraten wird nicht.

**Der zweite Weg, falls das nicht reicht:** **Page Heap** macht aus der
Beschädigung einen Zugriffsfehler an der verursachenden Anweisung statt
irgendwo später — als Administrator `gflags /p /enable Eudora.exe /full`,
Debug-Bau starten, Strg-N, dann `tools\stapel-untersuchen.ps1` in einer
**32-Bit**-PowerShell mit der `Eudora.pdb` neben der `Eudora.exe`; danach
`gflags /p /disable Eudora.exe`.

## Bauen

### Nach einem frischen Klon: ein Schritt

```bash
sh tools/hooks-einrichten.sh
```

Das war es. Der Hook liegt unter `.git/hooks` und wird von git nicht
mitversioniert, muss also je Klon einmal eingerichtet werden; er prüft vor jedem
Commit Zeilenenden, Kodierung und Zweigwahl.

**Zeilenenden sind kein Thema mehr.** [.gitattributes](.gitattributes) setzt
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

### Der Bau

```powershell
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Release
```

`tools/bauen.ps1` liest Konfiguration und Plattform aus `Eudora71/Eudora.sln`
und sucht MSBuild über `vswhere.exe`; geraten wird nichts. Erfolg meldet es
**nur**, wenn vier voneinander unabhängige Prüfungen zustimmen: Rückgabewert,
Fehlerprotokoll, Zeitstempel der Artefakte und die Versionsressource der
`Eudora.exe`. Grund dafür ist Befund **X-6** — am 05.09.2026 hat ein
MSBuild-Aufruf von Hand Erfolg gemeldet, ohne gebaut zu haben.

Wer doch von Hand baut, kennt drei Fallen:

- **`/p:BuildProjectReferences=false` wird nicht mehr gebraucht** und ist auch
  nicht mehr erwünscht: `OT501` ist seit dem 05.09.2026 aus dem Bau genommen
  (Befund **B-3**). Wer den Schalter trotzdem setzt, bekommt in einem frischen
  Klon `LNK1104: imap.lib` — nicht, weil etwas kaputt wäre, sondern weil
  `Eudora71/Lib/` von `.gitignore` erfasst ist und `imap.lib` erst vom Projekt
  `imapdll` entsteht.
- **Die Plattform heißt `x86`.** Die Projektmappe kennt `x86`, die
  Projektdateien `Win32`. Wer `-p:Platform=Win32` an die `.sln` gibt, bekommt
  `MSB4126`.
- **Der Aufruf muss aus der PowerShell kommen.** Die Git-Bash macht aus
  `/p:Configuration=Debug` einen Pfad.

Die Visual-Studio-IDE wird nicht gebraucht, nur die Installation (MSVC v143,
MFC/ATL, Windows SDK). Belege zum Bauzustand: [PRUEFUNG-BAU.md](PRUEFUNG-BAU.md).

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

Die mitgelieferten Fremdbibliotheken heißen in **Release** `EuMemMgr.lib`,
`Paige32.lib`, `SSCEWD32.LIB`, `Uuid.Lib`, `libpng.lib`, `zlib.lib` — in
**Debug** genauso, nur heißt Paige dort `Paige32d.lib`. Auf Groß- und
Kleinschreibung achten: `SSCEWD32.LIB` und `Uuid.Lib` fallen sonst aus einem
`ls *.lib` heraus.

Eine Falle beim Zählen: `VC71Bruecke` baut die DLL `msvcr71.dll`, seine
Importbibliothek heißt aber `msvcr71-bruecke.lib` — Projektname, DLL-Name und
`.lib`-Name gehen hier auseinander.

Unit- und Komponententests liegen in `Eudora71/Tests` (`RunTests.cmd`) und
`Eudora71/Tests/QCSSL` (`bauen.bat`, `messen.ps1`). Nach Vorgabe zu jedem Commit
laufen lassen.

## Starten

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Ins Mailverzeichnis gehört eine `Eudora.ini`. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`. Welche Dateien
danebenliegen müssen, steht in [STARTUMGEBUNG.md](STARTUMGEBUNG.md).

> **Berichtigung (06.09.2026).** Hier stand bis dahin: *„Das Mailverzeichnis
> muss eine `Eudora.ini` enthalten, sonst bricht Eudora in `eudora.cpp:3542`
> ab."* **Das stimmt nicht.** An `eudora.cpp:3542` steht
> `CEudoraApp::RegisterMailbox`, und einen Abbruch wegen fehlender INI gibt es
> im Code nicht: `GetDirs`/`CheckMailDirectory` (`fileutil.cpp`) prüfen nur, ob
> das **Verzeichnis** existiert und schreibbar ist, und `SetupINIFilename`
> (`rs.cpp`) setzt `INIPath` zusammen, ohne die Datei zu verlangen. Gemeint war
> `VERIFY(GetShortPathName(INIPath, …) > 0)` in
> **`CEudoraApp::RegisterCommandLine`** (`Eudora71/Eudora/eudora.cpp`) — das
> schlägt bei fehlender Datei fehl, aber `VERIFY` wirkt **nur im Debug-Bau**
> und bringt dort einen SUPERASSERT-Dialog, kein Programmende; im Release-Bau
> tut es gar nichts. Ohne INI läuft Eudora also weiter, nur mit den Vorgaben
> für jede Einstellung — was man nicht will, aber etwas anderes ist als ein
> Abbruch. Der einzige Weg im Code, der wirklich vorzeitig endet, betrifft den
> Start **ohne** Argument: dann sucht `StartEudoraWithDefaultLocation` das
> zuletzt benutzte Verzeichnis in Registry und `%APPDATA%`, und erst wenn auch
> das nichts hergibt, verlässt `InitInstance` lautlos das Programm.

Der Fenstertitel trägt die **Bau-Kennung** — Paketversion, Commit und
Herkunftsverzeichnis. Ein Sternchen hinter dem Commit heißt: beim Bau lagen
ungesicherte Änderungen vor, der Bau ist nicht reproduzierbar. Damit ist ein
Bildschirmfoto eindeutig einem Bau und einer Instanz zuzuordnen.

### Nur für den Debug-Bau: die Laufzeit-DLLs

**Das Release-Paket braucht nichts aus diesem Abschnitt.** Es bringt
`mfc140.dll`, `msvcp140.dll` und `vcruntime140.dll` selbst mit; die drei sind
Teil des Visual-C++-Redistributable und dürfen beiliegen (Befund F-1).

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
Befund S-8. Derselbe Code kommt bei falscher Bitness heraus, und **`Eudora.exe`
ist ein 32-Bit-Programm**. Zwei Fallen führen zu 64-Bit-DLLs: DLL-Sammelseiten
wie dll-files.com liefern häufig die 64-Bit-Fassung, ohne es deutlich zu machen
(von dort **keine** Laufzeit-DLLs holen), und der 32-Bit-Systemordner heißt unter
Windows ausgerechnet **`SysWOW64`**, während in `System32` die 64-Bit-DLLs
liegen. Die richtigen Dateien liegen auf jedem Rechner mit Visual Studio 2022
(C++-Werkzeuge, MFC/ATL) bereits in `SysWOW64`.

Beim ersten Start des Debug-Baus erscheinen drei bis vier Dialoge „SUPERASSERT
Assertion Failure" — auf *Ignore Once* klicken. Das sind Debug-Zusicherungen,
keine Fehler; im Release-Bau entfallen sie samt allen `ASSERT`/`VERIFY`.

## TLS

`QCSSL.dll` ist gegen **OpenSSL 3.5.8 LTS** gebaut, Mindestprotokoll TLS 1.2 für
alle acht Einstellungen von `m_ProtocolVersion`. Eine Obergrenze wird bewusst an
keiner Stelle gesetzt — `SSL_CTX_set_max_proto_version()` kommt in QCSSL nicht
vor, damit stets das höchste beiderseits unterstützte Protokoll ausgehandelt
wird. SSLv2 und SSLv3 sind abgeschaltet.

Gemessen: TLS 1.3 im Komponententest gegen einen lokalen Server, am 29.08.2026
gegen `pop.gmx.net:995` und am 06.09.2026 im selbst gebauten Eudora über
Port 995 (`Negotiation Status: Succeeded`).

> **Offen und sicherheitsrelevant: die Hostnamenprüfung greift nicht.** Gemessen:
> ein Zertifikat mit falschem `CN` wird mit `SSLSUCCEEDED` und `ErrorCode 0`
> angenommen. Ein Hinweistext wird angehängt, bleibt aber ohne Wirkung.
> Altbestand von QUALCOMM, Einzelheiten in [PORTIERUNG.md](PORTIERUNG.md). Der
> vorbereitete Patch ist **zurückgestellt** und wird nicht ohne Gregors Wort
> angewendet (`tools/patches/zertifikatspruefung-verschaerfen.patch`).

QCSSL prüft ausschließlich gegen `rootcerts.p7b`, nicht gegen den
Windows-Zertifikatspeicher. Für die Auslieferung erzeugt
`Releases/1.0/rootcerts-erzeugen.ps1` eine frische Datei aus dem
Windows-Wurzelspeicher der Maschine — abgelaufene und noch nicht gültige
Zertifikate bleiben draußen. Wie viele es sind, sagt das Skript am Ende selbst
(*„Gegenprobe (wieder eingelesen): N Zertifikate"*); die Zahl hängt am
Zertifikatstand des Rechners und wird hier deshalb nicht festgeschrieben. Die
beiden Altbestände im Baum (`Eudora71/Bin/Release/rootcerts.p7b`,
`InstallersForEudora/Eudora7.1/Data/win32/RootCerts`) enthalten abgelaufene
Zertifikate und sind nicht maßgeblich.

## Werkzeuge

| Werkzeug | wozu |
|---|---|
| `tools/bauen.ps1` | baut die Projektmappe und meldet Erfolg erst, wenn Rückgabewert, Fehlerprotokoll, Zeitstempel und Versionsressource zusammenpassen. Prüft nach: alles x86, im Release keine Debug-Laufzeit in der Importtabelle. `-NurPruefen` misst nur |
| `tools/zeilenenden-angleichen.pl` | Arbeitskopie byteidentisch zum Commit machen. Nach jedem Klon einmal. Nennt jede angefasste Datei namentlich, lässt vorgemerkte Dateien in Ruhe; die Gegenrichtung nur mit `--auch-umgekehrt` |
| `tools/aendere-zeile.pl` | eine einzelne Zeile byte-erhaltend ändern |
| `tools/ersetze-bereich.pl` | einen Zeilenbereich byte-erhaltend ersetzen |
| `tools/pruefe-bytes.pl` | `pre-commit`-Schranke gegen lautlosen Byteschaden: Zeilenenden, Kodierung, Doppelkodierung |
| `tools/pruefe-bytes-tests.pl` | Testsammlung dazu, **35 Fälle** in eigenen Wegwerf-Repos. **Wer `pruefe-bytes.pl` anfasst, lässt sie laufen** |
| `tools/pruefe-branch.pl` | `pre-commit`-Schranke gegen Commits auf einen toten Zweig: schon in `origin/main`, Gegenstück auf dem Server gelöscht, oder abgelöster HEAD. Läuft als **erster** Schritt im Hook; `--melden` berichtet nur (Befund X-5) |
| `tools/pruefe-branch-tests.pl` | Testsammlung dazu, **15 Fälle**, jeder in zwei Durchläufen. **Wer `pruefe-branch.pl` anfasst, lässt sie laufen** |
| `tools/dateiendungen.pl` | gemeinsame Liste der Dateiarten, die als Text gelten. Wird von der Schranke und von `zeilenenden-angleichen.pl` geladen — zwei getrennte Listen sind schon auseinandergelaufen |
| `tools/hooks-einrichten.sh` | richtet den `pre-commit`-Hook ein. Nach jedem Klon einmal. Schreibt nach `--git-common-dir`, läuft also auch aus einem Arbeitsbaum |
| `tools/stapel-untersuchen.ps1` | kleiner Debugger: fängt die tödliche Ausnahme, läuft die EBP-Kette ab, symbolisiert mit `dbghelp`. **Muss in der 32-Bit-PowerShell laufen**, braucht die `.pdb` neben der `.exe` |
| `tools/absturz-auswerten.pl` | übersetzt die Adressen aus einer `Exception.log` in Funktionsnamen aus `Eudora71/Bin/Release/Eudora.map`. Nimmt die Ladeadresse aus der Modultabelle des Berichts (ab 7.2.0.14) und **rät nicht**, wenn sie fehlt — ein falscher Name ist schlimmer als keiner (Befund E-29). Läuft ohne Visual Studio |
| `tools/absturz-auswerten-tests.pl` | Testsammlung dazu, **15 Fälle** mit künstlicher Karte und künstlichem Bericht. **Wer `absturz-auswerten.pl` anfasst, lässt sie laufen** |
| `tools/suche-zeiger.pl` | sucht Zeiger, die auf `NULL` geprüft und danach außerhalb des geschützten Blocks dereferenziert werden. 18 Treffer, davon neun echte Kandidaten (Liste in `AUFGABEN.md`, D3a). Läuft ohne Visual Studio |
| `tools/releasebuffer-pruefen.pl` | stuft jedes `ReleaseBuffer` im Baum ein: steht vorher ein `GetBuffer` auf **derselben** Variablen? Das ist die Fehlerklasse **R-1**. Rückgabe 1, sobald etwas zu tun ist. Läuft ohne Visual Studio |
| `tools/pruefe-symbole.pl` | prüft die Werkzeugleisten-Ressourcen ohne Übersetzer: jede `TOOLBAR` hat eine gleichnamige `BITMAP`, jede Bilddatei ist da, jeder Knopf hat ein Bild, keine Ladestelle in der Ersatzschicht holt eine Bitmap ohne Farbtabelle noch über `CBitmap::LoadMappedBitmap`, und deren Hintergrund ist wirklich 192,192,192 (Befund E-30). `-v` listet jede Leiste |
| `tools/pruefe-symbole-tests.pl` | Testsammlung dazu, **12 Fälle** auf künstlichen Arbeitsbäumen. **Wer `pruefe-symbole.pl` anfasst, lässt sie laufen** |
| `tools/postfach-zeichen-pruefen.pl` | prüft ein `.mbx` auf unübersetzte UTF-8-Folgen (Befund Z-2b) |
| `tools/kennung-erzeugen.pl` | erzeugt `BuildKennung.h` vor jedem Bau (PreBuildEvent) |
| `tools/laufzeit-holen.ps1` | holt die vier **Debug**-Laufzeiten aus `SysWOW64` und prüft jede auf x86 nach. Für den Release-Bau nicht nötig |
| `tools/paket-bauen.ps1` | stellt ein Auslieferungspaket aus dem Quellbaum zusammen, wahlweise als ZIP. **Veröffentlicht nichts** — ob ausgeliefert wird, entscheidet ein Mensch |
| `tools/paket-pruefen.ps1` | prüft ein ausgepacktes Paket. **Taugt nicht als Freigabekriterium** — es prüft die Maschine statt das Paket und warnt bei einem Release-Paket viermal falsch (PR-2.0 bis PR-2.3) |
| `tools/ausliefern.pl` | prüft die Regel „eine Nummer, ein Bau" nach: `--pruefen` |
| `tools/release-pruefen.pl` | prüft, ob das ausgelieferte Release zum Quellstand passt |
| `tools/vc71-bruecke-messen.pl` | misst die Bindung der Fremd-DLLs an die VC-7.1-Laufzeit und erzeugt daraus die `.def` der `VC71Bruecke` |
| `tools/gesichert.pl` | beantwortet in einem Aufruf: alles committet, alles gepusht, sind die **anderen** Arbeitsbäume sauber? **Sofort laufen lassen, wenn Gregor einen Merge ankündigt.** `--ohne-holen` verzichtet auf `git fetch --prune` |
| `tools/ungesichertes-melden.pl` | meldet ungesicherte Änderungen |
| `tools/lehren-spiegeln.pl` | spiegelt die Lehren aus dem Gedächtnis nach `Arbeitsweise/` |
| `tools/pruefstand-melden.pl` | meldet, wie weit `BEFUNDE.md`, `README.md` und `PORTIERUNG.md` hinter dem Code herhinken. Maßstab ist die Zeile `<!-- pruefstand: <commit> -->` in jeder der drei Dateien — **wer eine davon nachzieht, zieht die Marke mit** |

## Was bisher gemacht wurde

Der Quellcode ist von 1996–2006 und stammt aus der Zeit von Visual C++ 6.
Repariert wurden im Wesentlichen sieben wiederkehrende Muster:

- Deklarationen ohne Rückgabetyp (`default-int`, in C++ nicht mehr erlaubt)
- entfernte Header (`<xstddef>`), fehlende Extended-MAPI-Header
- alte `for`-Scope-Regeln (Schleifenzähler nach der Schleife weiterbenutzt)
- `strchr`/`strstr`/`strrchr` liefern in C++ `const char*`
- `std::auto_ptr`, Iteratoren-als-Zeiger (`it = NULL`), nicht-`const` Komparatoren
- MFC-`const`-Overloads liefern kein lvalue mehr
- Namenskollisionen mit winsock2 und der UCRT

Dazu drei Projekteinstellungen: die mitgelieferte VC6-Kopie der `/GS`-Runtime
deaktiviert, SafeSEH für QCSSL aus, `/WX` aus dem OpenSSL-Makefile.

Ausführlich mit Begründungen: **[PORTIERUNG.md](PORTIERUNG.md)**

Getrennt davon steht die Portierung von QCSSL auf die **OpenSSL-3.x-API**:
0.9.7l von 2006 kannte noch offene Strukturen, 3.x kapselt sie hinter
Zugriffsfunktionen. Betroffen waren vor allem die BIO-Schicht und
`QCSSLContext.cpp`.

## Die Ersatzschicht für Stingray OT501

`Eudora.exe` linkte gegen **Stingray Objective Toolkit 5.0.1**, eine kommerzielle
MFC-Erweiterung von 1995. Die CHM-Freigabe durfte nur Qualcomm-eigenen Code
enthalten — von OT501 sind deshalb nur die 127 Header unter
`Eudora71/OT501/Include` übrig; von den Quelldateien der `SEC*`-Klassen fehlt
alles, im Baum liegen nur noch mitgelieferte Fremdteile (JPEG, zlib). Eine
fertige Binärdatei von damals hilft nicht: mit VC6 gegen MFC 4.21 übersetzt,
verlinkt sie sich nicht mit VS 2022.

Eudora baut darauf sein komplettes Fenstergerüst auf — `CMainFrame` erbt über
`QCWorkbook` von `SECWorkbook`; insgesamt leitet Eudora an 30 Stellen von
22 Stingray-Klassen ab und ruft 77 Methoden auf. **42** Quelldateien und
**28** Header unter `Eudora71/Eudora` nennen mindestens einen
Stingray-Bezeichner (gezählt am 06.09.2026: Dateien, in denen ein Bezeichner
der Form `SEC<Grossbuchstabe>…` mit mindestens einem Kleinbuchstaben vorkommt —
das trennt die Stingray-Klassen von den gleichnamigen SSPI-Konstanten
`SECBUFFER_*`).

**Gewählter Weg und heutiger Zustand:** eine eigene Ersatzschicht auf modernes
MFC, `Eudora71/OTShim/`, in fünf Teilen über `OTShimAll.h` eingebunden.
`Eudora.exe` bindet damit ohne Stingray, **0 ungelöste Externe**; das Projekt
`OT501` ist ganz aus dem Bau genommen (Befund B-3), die frühere Attrappe
`Lib/Debug/OTA50D.LIB` entfällt und **darf nicht wieder angelegt werden** —
sonst linkt Eudora gegen eine leere Bibliothek.

> **Achtung, ein naheliegender Irrtum:** die Registerkartenleiste ist **nicht**
> verzichtbar. Abschaltbar ist nur der MDI-Streifen — `CMainFrame::FinishInitAndShowWindow`
> ruft dafür `ShowMDITaskBar(GetIniShort(IDS_INI_MDI_TASKBAR))`, und
> `SECWorkbook` in der Ersatzschicht hält `m_bWorkbookMode` dauerhaft auf
> `FALSE` (`OTShim.cpp`, Konstruktor und `SetWorkbookMode`). Das
> Registerkarten-*Steuerelement* `SEC3DTabWnd`/`SEC3DTabControl` sitzt in
> **jeder** Wazoo-Leiste und wird davon nicht berührt. Mit leeren Rümpfen
> startet Eudora zwar, aber Mailboxes, Nicknames, Filters, Directory Services,
> Link History und Task Status bleiben leer. Die Registerkarten sind deshalb als
> eigener Teil ausgeführt (`OTShim_Reiter.*`).

Bestandsaufnahme: [Eudora71/OTShim/INVENTAR.md](Eudora71/OTShim/INVENTAR.md) —
Umsetzungsplan mit Stufen und Belegen:
**[Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md)**

Ein Rest bleibt behelfsmäßig: `__imp___iob` aus `libpng.lib` definiert
`OTShim_Libpng.cpp` als `(char*)stderr - 2*32`, weil libpng 1.2.7 nur `_iob[2]`
anfasst und die damalige CRT 32 Byte je Element hatte. Das trägt, ist aber eine
Annahme; sauber wäre ein Neubau von libpng aus `Eudora71/PNG/libpng` mit v143.

## Ergänzungen gegenüber der CHM-Freigabe

- `Eudora71/MAPI/include` — Extended-MAPI-Header aus
  [microsoft/MAPIStubLibrary](https://github.com/microsoft/MAPIStubLibrary) (MIT).
  Nötig, weil `mapix.h` und `mapiutil.h` seit dem Windows-8-SDK nicht mehr
  im Windows SDK enthalten sind — im hier benutzten SDK 10.0.22621.0 liegen unter
  `um\` nur noch `MAPI.h` und `MapiUnicodeHelp.h`.
- `Eudora71/OpenSSL3` — Header und statische Bibliotheken von **OpenSSL 3.5.8 LTS**
  (`libcrypto.lib`, `libssl.lib`), damit sich `QCSSL` ohne einen 25-minütigen
  OpenSSL-Lauf übersetzen lässt. Beide liegen im Repo, ein frischer Klon bindet
  `QCSSL` ohne Zutun. Bauweg und Prüfsumme stehen in
  [Eudora71/OpenSSL3/BAUEN.md](Eudora71/OpenSSL3/BAUEN.md). Das alte `Eudora71/OpenSSL`
  (0.9.7l) liegt noch im Baum. Gegen `libeay32.lib`/`ssleay32.lib` linkt allerdings
  **kein** Projekt mehr; geblieben ist nur ein toter Include-Pfad `..\OpenSSL\inc32`
  in `QCSocket.vcxproj:60` und das `OpenSSL`-Projekt, das in der Solution noch
  mitgebaut wird. Beides kann weg.
- `Eudora71/VC71Bruecke` — eigener Nachbau der `MSVCR71.dll` als Weiterleitung
  auf die von Windows mitgelieferte `msvcrt.dll`. Die vorgebauten Fremd-DLLs von
  2006 (Paige32, EuMemMgr und die übrigen) brauchen diese Laufzeit. `MFC71.DLL`
  und `MSVCP71.dll` sind dagegen **nicht** nachbaubar (157 Ordinale); Adressbuch,
  LDAP und Ph fallen deshalb dauerhaft aus (Befund B-1).
- `Eudora71/Eudora/utils.cpp` — UTF-8-Übersetzungstabelle von 27 auf 123 Einträge
  erweitert (deutsche Umlaute und Latin-1), nach
  [HansWurst81675/Eudora_patches](https://github.com/HansWurst81675/Eudora_patches).
  Sieben Zuordnungen aus dem Qualcomm-Altbestand waren falsch und sind berichtigt,
  ebenso die Doppelersetzung. Der UTF-8-Fall läuft inzwischen über den
  Windows-Codepage-Wandler; die Tabelle bleibt als Rückfallweg für Post, die
  `utf-8` behauptet und CP1252-Bytes trägt. Belegt durch die Unit-Tests in
  `Eudora71/Tests`.

## Verwandte Projekte

- [HermesMail](https://sourceforge.net/projects/hermesmail/) — rüstet ein
  installiertes Eudora 7.1 binär mit neueren TLS-DLLs nach (OpenSSL 1.0.2)
- [Eudora_patches](https://github.com/HansWurst81675/Eudora_patches) — Binärpatches
  für die Umlautdarstellung

## Lizenz

Der Eudora-Quellcode steht unter der BSD-artigen Lizenz der Freigabe von 2018
(siehe Kopf der Quelldateien). Fremdbestandteile behalten ihre eigenen Lizenzen.
