# Eudora 7.2

<!-- pruefstand: d826a3f -->
<!-- Die Marke oben nennt den Commit, gegen den diese Datei zuletzt abgeglichen
     wurde. Wer die Datei nachzieht, zieht die Marke mit.
     Gelesen von tools/pruefstand-melden.pl (Befund NP3-7). -->

Portierung des Eudora-7.1-Quellcodes auf Visual Studio 2022 — mit dem Ziel, den
Mailclient wieder selbst bauen und weiterentwickeln zu können.

Grundlage ist die Quelltextfreigabe des [Computer History Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/)
(2018, mit Genehmigung von Qualcomm).

## Stand

> ## Eudora startet, ist bedienbar und ruft Mail ab.
>
> **Gemessen am 31.08.2026** an dem Paket `Eudora72-1.0.3-release.zip`
> (Produktversion 7.2.0.3, `Release|Win32`, Toolset v143 / MSVC 14.38.33130).
> Der Gesamtbau der Solution ist in derselben Sitzung nachgemessen (Befund B-2).
> Wer den Stand prüft, misst neu und nennt seinen eigenen Bezugscommit — an
> diesem Baum arbeiten mehrere Agenten gleichzeitig.
>
> Was „lauffähig" heißt, hat Gregor in [ZIEL.md](ZIEL.md) festgelegt. **Dort
> steht die maßgebliche Kriterientabelle**; die folgende ist ihre Kurzfassung:
>
> | # | Kriterium | Stand am 31.08.2026 |
> |---|---|---|
> | 0 | das Paket läuft ohne Nachinstallieren | **nicht belegt** — das Release-Paket ist gebaut, aber auf keinem Rechner **ohne** Visual Studio nachgewiesen. `tools/paket-pruefen.ps1` taugt nicht als Nachweis, es prüft die Maschine statt das Paket (Befund PR-2) |
> | 1 | startet und zeigt sein Hauptfenster | **erfüllt** auf einer eingerichteten Installation — Gregor: *„menü funktioniert"* (Befund E-1). Auf einer **frischen** Installation stürzte der Kontoassistent beim Klick auf *Weiter* ab (Befund E-11); behoben in `eudora.cpp:3372`, am Programm noch nicht nachgesehen |
> | 2 | die Darstellung ist korrekt | **fast** — Fenster, Menüs und Werkzeugleiste stimmen. Die falschen Zeichen in HTML-Mail (`◆`) sind an der Ursache behoben (Befund Z-2), am Programm noch nicht nachgesehen |
> | 3 | Mailkonto verbinden und Mail abrufen | **erfüllt** — 159 Nachrichten von `mx.freenet.de`, Port 110, STARTTLS, TLSv1.3, `TLS_AES_256_GCM_SHA384` (Befunde E-1 und E-3) |
>
> **Zwei von vier Kriterien sind belegt, eines fast, eines offen.** Erst wenn
> alle vier erfüllt sind, darf eine Fassung „lauffähig" heißen. Die Dateinamen
> `Eudora72-1.0.1-lauffaehig.zip` und `Eudora72-1.0.2-lauffaehig.zip` behaupten
> mehr, als die Fassungen können; sie bleiben nur stehen, weil die Pakete unter
> diesen Namen samt Prüfsumme veröffentlicht sind.
>
> **Der nächste Schritt** steht in [AUFGABEN.md](AUFGABEN.md) ganz oben: das
> Paket auf dem zweiten PC (Windows 11, ohne Visual Studio) auspacken und
> starten. Dieser eine Lauf beantwortet die Kriterien 0, 1 und 2 zusammen.
> Achtung auf die Prüfsumme — das ZIP unter
> [Releases v1.0.3](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.3)
> ist am 31.08. um 09:00 **ausgetauscht** worden. Nur die Fassung mit SHA256
> `d4719047…` enthält die Behebung von E-11; die erste (`632c4066…`) stürzte ab.

Der Weg dorthin an zwei Tagen: `Eudora.exe` band zum ersten Mal, startete nicht,
und die Gründe dafür sind belegt und behoben — siehe
[BEFUNDE.md](BEFUNDE.md), Befunde S-1 bis S-8 sowie B-1/B-2, M-1, A-1, P-1/P-2
und W-1. **Am Anfang von `BEFUNDE.md` steht ein Verzeichnis** aller Kennungen
mit Statusspalte; ohne das findet man in 5900 Zeilen nichts wieder.

Der eigentliche Blocker war die **Werbefläche**: `CAdWazooWnd::OnCreate` legt sie
mit `CRect(0,0,0,0)` an, die Textmaschine Paige bekommt eine Umbruchbreite von
null und dreht sich in einer Endlosrekursion fest (1689 Stapelrahmen, davon 1613
im Zyklus). Sie hängt jetzt an `QCSharewareManager::IsBoxBuild()`, dazu der
Übersetzungsschalter `BUILD_BOX_OR_SITE_R_VERSION`. Damit entfallen **Werbung,
Registrierung und Einführungsdialog** — das ist die Fassung, die QUALCOMM an
Firmenkunden ausgeliefert hat.

### Nach einem frischen Klon: einmal die Zeilenenden angleichen

```bash
perl tools/zeilenenden-angleichen.pl --aendern
git ls-files -z | xargs -0 -n 400 git add --
```

**Ohne diesen Schritt springt jede Datei, die man anfasst, als komplett geändert
heraus.** Gemessen am 30.08.2026: 4616 von 5563 verfolgten Dateien lagen als CRLF vor, während
im Commit LF steht — Folge eines Auscheckens mit `core.autocrlf=true`. Git sieht
in eine Datei gar nicht hinein, solange Zeitstempel und Größe zum Index passen;
der Schaden bleibt deshalb unsichtbar, bis ein Werkzeug die Datei berührt. Das
ist die Wurzel aller CRLF-Probleme dieses Projekts, Befund S-7.

### Bauen

```bash
"C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" Eudora71\Eudora\Eudora.vcxproj /p:Configuration=Debug /p:Platform=Win32 /p:BuildProjectReferences=false /m
```

`/p:BuildProjectReferences=false` ist nötig — sonst scheitert der Bau am Projekt
`OT501`, dessen Stingray-Quellen nicht freigegeben sind. Die Visual-Studio-IDE
wird nicht gebraucht, nur die Installation (MSVC v143, MFC/ATL, Windows SDK).

> **In einem frischen Klon oder Worktree zuerst die ganze Solution bauen.**
> Mit `/p:BuildProjectReferences=false` endet der Einzelprojekt-Bau sonst mit
>
> ```
> LINK : fatal error LNK1104: Datei "imap.lib" kann nicht geoeffnet werden.
> ```
>
> — nicht, weil etwas kaputt wäre, sondern weil `Eudora71/Lib/` von
> `.gitignore` erfasst ist und `imap.lib` erst vom Projekt `imapdll` erzeugt
> wird. Gemessen am 31.08.2026 (Befund A-1, Abschnitt „Bauzustand"). Nach einem
> Gesamtbau der Solution bindet `Eudora.vcxproj` durch (Befund B-2).
>
> Der MSBuild-Aufruf muss aus **PowerShell** kommen: die Git-Bash macht aus
> `/p:Configuration=Debug` einen Pfad.

Ein voller Solution-Bau meldet weiterhin **3 Fehler, alle aus `OT501`**
(zweimal `NMAKE U1073`, einmal `MSB3073`), nachgemessen am 31.08.2026 mit
eingehängtem Projekt `VC71Bruecke` (Befund B-2). Das Projekt `OT501` wird nicht
mehr gebraucht: die Ersatzschicht hat es abgelöst. Zwei zusätzliche
`LNK1104: QCUtils.lib` in `NSImport` und `OLImport` sind ein Wettlauf im
Parallelbau (`/m`), kein Fehler — einzeln gebaut laufen beide durch.

### Starten

#### Zuerst: die Debug-Laufzeiten dazulegen

**Ohne diesen Schritt startet Eudora nicht.** Der Debug-Bau braucht vier
DLLs, die nicht mit ausgeliefert werden dürfen:

```
mfc140d.dll   msvcp140d.dll   vcruntime140d.dll   ucrtbased.dll
```

Dafür gibt es ein Werkzeug — es kopiert sie und prüft jede einzeln auf ihre
Architektur nach:

```powershell
powershell -ExecutionPolicy Bypass -File tools\laufzeit-holen.ps1 -Ziel "C:\Pfad\zu\Eudora"
```

Mit `-NurPruefen` sagt es nur, was fehlt, ohne etwas zu kopieren.

> ### Achtung: `0xc000007b`
>
> ```
> Die Anwendung konnte nicht korrekt gestartet werden (0xc000007b).
> ```
>
> Dieser Code heißt `STATUS_INVALID_IMAGE_FORMAT` und bedeutet fast immer
> **Bitness-Konflikt**: eine 64-Bit-DLL in einem 32-Bit-Prozess.
> **`Eudora.exe` ist ein 32-Bit-Programm.**
>
> Zwei Fallen führen dahin:
>
> 1. **DLL-Sammelseiten** wie dll-files.com liefern häufig die 64-Bit-Fassung,
>    ohne es deutlich zu machen. Von dort **keine** Laufzeit-DLLs holen.
> 2. Der 32-Bit-Systemordner heißt unter Windows ausgerechnet **`SysWOW64`** —
>    der Name legt das Gegenteil nahe:
>
>    | Ordner | enthält |
>    |---|---|
>    | `C:\Windows\System32` | **64**-Bit-DLLs |
>    | `C:\Windows\SysWOW64` | **32**-Bit-DLLs ← diese hier |
>
> Die richtigen Dateien liegen auf jedem Rechner mit installiertem Visual
> Studio 2022 (mit C++-Werkzeugen und MFC/ATL) bereits in `SysWOW64`, in der
> zum Toolset passenden Fassung. **Ohne Visual Studio läuft dieser Bau nicht.**
> Dafür gibt es seit Befund F-1 den **Release-Bau**: er braucht nur
> `mfc140.dll`, `msvcp140.dll` und `vcruntime140.dll`, und diese drei sind Teil
> des Visual-C++-Redistributable und dürfen beiliegen.

#### Dann starten

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Das Mailverzeichnis **muss eine `Eudora.ini` enthalten**, sonst bricht Eudora in
`eudora.cpp:3542` ab. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`.

Beim ersten Start erscheinen drei bis vier Dialoge „SUPERASSERT Assertion
Failure" — auf *Ignore Once* klicken. Das sind Debug-Zusicherungen, keine Fehler.
Sie erscheinen nur, weil bisher nur der Debug-Bau läuft.

Der Fenstertitel trägt die **Bau-Kennung** — Paketversion, Commit und
Herkunftsverzeichnis:

```
Eudora - [In]   [1.0.3+371c1e3 - Eudora72-1.0.3]
```

Ein Sternchen hinter dem Commit heißt: beim Bau lagen ungesicherte Änderungen
vor, der Bau ist nicht reproduzierbar. Damit ist ein Bildschirmfoto eindeutig
einem Bau und einer Instanz zuzuordnen.

### Was fertig gebaut wird

| Ergebnis | Ort |
|---|---|
| **`Eudora.exe`** | `Eudora71/Bin/Debug` |
| `EudoraRes.dll` | `Eudora71/Bin/Debug` |
| `QCSSL.dll`, `Imap.dll`, `QCSocket.dll`, `QCUtils.dll`, `EuLang.dll`, `plstclnt.dll` | `Eudora71/Bin/Debug` |
| `NSImport.eif`, `OEImport.eif`, `OLImport.eif` (Importer-Plugins, DLLs mit eigener Endung) | `Eudora71/Bin/Debug` |
| `EudoraOldIcons.epi` (Icon-Plugin, ebenfalls eine DLL) | `Eudora71/EudoraOldIcons/Debug` |
| elf `.lib` | `Eudora71/Lib/Debug` |
| `libeay32.lib`, `ssleay32.lib` (Projekt `OpenSSL`, Altbestand) | `Eudora71/OpenSSL/out32` |

Von den elf `.lib` sind sieben Importbibliotheken zu den DLLs (kenntlich an der
begleitenden `.exp`); echte statische Bibliotheken sind nur vier: `AccountWizard`,
`DirectoryServicesUI`, `EuImap`, `SearchEngine`. Daneben liegen dort sechs
vorgefertigte Fremdbibliotheken, die kein Projekt der Solution erzeugt
(`EuMemMgr`, `Paige32d`, `SSCEWD32`, `Uuid`, `libpng`, `zlib`).

### TLS

`QCSSL.dll` ist gegen **OpenSSL 3.5.8 LTS** gebaut, Mindestprotokoll TLS 1.2 für
alle Einstellungen. TLS 1.3 ist zweimal nachgemessen: im Komponententest gegen
einen lokalen Server und am 29.08.2026 gegen `pop.gmx.net:995`
(`TLSv1.3`, `TLS_AES_256_GCM_SHA384`, 256 Bit).

**Achtung:** dieser Abruf fand mit einer *älteren* QCSSL-Fassung statt. Die
ausgelieferte QCSSL 1.0.1 ist gegen Komponententests geprüft, aber nie gegen
einen echten Mailserver. Einzelheiten in
[Releases/1.0/AUSLIEFERUNGEN.md](Releases/1.0/AUSLIEFERUNGEN.md).

### Werkzeuge

| Werkzeug | wozu |
|---|---|
| `tools/zeilenenden-angleichen.pl` | Arbeitskopie byteidentisch zum Commit machen. Nach jedem Klon einmal. Seit Befund **X-4**: erfasst 6444 statt 6395 Dateien, nennt jede angefasste **namentlich**, lässt **vorgemerkte** Dateien in Ruhe und behandelt die Gegenrichtung (Arbeitskopie LF, HEAD CRLF) getrennt — sie wird nur mit `--auch-umgekehrt` angeglichen. |
| `tools/aendere-zeile.pl` | eine einzelne Zeile byte-erhaltend ändern |
| `tools/ersetze-bereich.pl` | einen Zeilenbereich byte-erhaltend ersetzen |
| `tools/pruefe-bytes.pl` | pre-commit-Schranke gegen lautlosen Byteschaden |
| `tools/pruefe-bytes-tests.pl` | Testsammlung für die pre-commit-Schranke: **35 Fälle** in eigenen Wegwerf-Repos, darunter je einer für die neun Löcher aus Befund X-1. **Wer `tools/pruefe-bytes.pl` anfasst, lässt sie laufen.** |
| `tools/dateiendungen.pl` | gemeinsame Liste der Dateiarten, die als Text gelten. Wird von der Schranke und von `zeilenenden-angleichen.pl` geladen — zwei getrennte Listen sind schon auseinandergelaufen. |
| `tools/stapel-untersuchen.ps1` | kleiner Debugger: fängt die tödliche Ausnahme, läuft die EBP-Kette ab, symbolisiert mit `dbghelp`. **Muss in der 32-Bit-PowerShell laufen**, braucht die `.pdb` neben der `.exe`. Damit wurde S-2 gefunden. |
| `tools/suche-zeiger.pl` | sucht Zeiger, die auf `NULL` geprüft und danach außerhalb des geschützten Blocks dereferenziert werden. Damit wurden die Stellen zu P-2 gefunden. Seit Befund **X-3** mit neun Filtern: **18 Treffer statt 347**, davon neun echte Kandidaten (Liste in `AUFGABEN.md`, D3a). Läuft ohne Visual Studio. |
| `tools/releasebuffer-pruefen.pl` | stuft jedes `ReleaseBuffer` im Baum ein: ist vorher ein `GetBuffer` auf **derselben** Variablen da? Das ist die Fehlerklasse hinter Befund E-11 (Absturz auf frischen Installationen). Gemessen: 117 richtig, 25 zu ändern. Rückgabe 1, sobald etwas zu tun ist. Läuft ohne Visual Studio. |
| `tools/kennung-erzeugen.pl` | erzeugt `BuildKennung.h` vor jedem Bau (PreBuildEvent) |
| `tools/laufzeit-holen.ps1` | holt die vier Debug-Laufzeiten von VS2022 aus `SysWOW64` und prüft jede einzeln auf x86 nach. Ohne sie startet Eudora mit `0xc000007b` — Befund S-8. `-NurPruefen` sagt nur, was fehlt. |
| `tools/paket-bauen.ps1` | stellt ein Auslieferungspaket aus dem Quellbaum zusammen, wahlweise als ZIP. **Veröffentlicht nichts** — ob ausgeliefert wird, entscheidet ein Mensch. |
| `tools/paket-pruefen.ps1` | prüft ein ausgepacktes Paket, **bevor** es jemand startet: Startkette, Architektur, fehlende DLLs. Rückgabe 0 = in Ordnung, 1 = Fehler, 2 = Aufrufproblem. Das Maß für Kriterium 0. |
| `tools/vc71-bruecke-messen.pl` | misst die Bindung der Fremd-DLLs an die VC-7.1-Laufzeit und erzeugt daraus die `.def` der `VC71Bruecke` |
| `tools/release-pruefen.pl` | prüft, ob das ausgelieferte Release zum Quellstand passt |
| `tools/hooks-einrichten.sh` | richtet den pre-commit-Hook ein. Nach jedem Klon einmal — ohne ihn treten zwei Fehlerklassen lautlos wieder auf. |
| `tools/lehren-spiegeln.pl` | spiegelt die Lehren aus dem Gedächtnis nach `Arbeitsweise/` |
| `tools/pruefstand-melden.pl` | meldet, wie weit `BEFUNDE.md`, `README.md` und `PORTIERUNG.md` hinter dem Code herhinken. Maßstab ist die Zeile `<!-- pruefstand: <commit> -->` in jeder der drei Dateien — **wer eine davon nachzieht, zieht die Marke mit**. Ohne Marke sagt das Werkzeug „nicht messbar" und gibt 1 zurück, statt zu raten (Befunde NP3-6, NP3-7). |
| `tools/ungesichertes-melden.pl` | meldet ungesicherte Änderungen |

`tools/rekursion-suchen.pl` wurde am 31.08.2026 **gelöscht**, siehe Befund W-1:
es bildete jede Kante mit dem Klassennamen der umgebenden Methode und konnte
klassenübergreifende Zyklen deshalb strukturell nicht finden — auch den aus S-2
nicht, für den es gebaut wurde. Geliefert hat es ausschließlich Fehlalarme.

## Selbst bauen

**Ziel: klonen, `Eudora71\Eudora.sln` in Visual Studio 2022 laden, *Projektmappe
erstellen* — fertig. Ohne Kniffe.**

### Voraussetzungen

| | |
|---|---|
| Visual Studio 2022 | mit **Desktopentwicklung mit C++** |
| Toolset | v143 (MSVC 14.38) |
| Zusatzkomponente | **MFC und ATL für v143 (x86)** — ohne sie bricht der Bau sofort ab |
| Plattform | **32 Bit.** Eudora ist x86, eine x64-Fassung gibt es nicht |

Nach jedem frischen Klon **einmalig**:

```bash
git config core.autocrlf false
sh tools/hooks-einrichten.sh
perl tools/zeilenenden-angleichen.pl --aendern
```

Keiner der drei Schritte ist wahlfrei — ohne sie treten zwei Fehlerklassen
lautlos wieder auf (Befund S-7).

### Auf der Kommandozeile

```bash
MSBuild.exe Eudora71/Eudora.sln -t:Build -p:Configuration=Release -p:Platform=x86 -m
```

---

### ⚠ Was den Bau kaputtmacht

Diese vier Fallen haben in diesem Projekt jeweils Zeit gekostet. Sie stehen
hier, damit es kein zweites Mal passiert.

#### 1. `OT501` kann **nie** bauen — und das ist keine Panne

`Eudora71/OT501` kapselt die **Stingray Objective Toolkit**. Das war ein
kommerzielles Fremdprodukt; die CHM-Freigabe durfte es nicht enthalten. Im Repo
liegen nur 39 `.cpp` (fast alle die mitgelieferte JPEG-Bibliothek) und 66
Kopfdateien — eine vollständige Toolkit-Quelle hätte Hunderte.

Der Bau bricht deshalb ab mit:

```
NMAKE : fatal error U1073: ".\utility\crypt\Blackbox.cpp" konnte nicht erstellt werden
NMAKE : fatal error U1073: "OTA50R\OTA50R.lib" konnte nicht erstellt werden
```

Das Verzeichnis `Src/utility/crypt` gibt es nicht; von `Blackbox` liegt nur
`Include/BLACKBOX.H` da, ohne Quelldatei. **`OTA50R.lib` hat nie existiert** —
weder im Repo noch in irgendeinem Release-ZIP noch in einem Commit.

Ersetzt wird das Ganze durch die eigene Schicht [OTShim](Eudora71/OTShim),
rund 18.000 Zeilen. Seit dem 05.09.2026 ist OT501 aus dem Bau genommen (siehe
Punkt 4) — davor scheiterte **jeder Bau aus einem frischen Klon** daran.

> **Berichtigung.** Am 05.09.2026 stand hier zunächst, ein `-t:Rebuild` habe
> eine vorgebaute `OTA50R.lib` gelöscht. Das war falsch. Nachgemessen: die vier
> Dateien in `Src/OTA50R/` tragen unverändert den **31.08.2026, 07:22** — ein
> Clean hätte sie gelöscht. Es waren zwei Objektdateien und eine PCH aus einem
> Bauversuch, der an derselben fehlenden Quelle starb. Zerstört wurde nichts;
> sichtbar wurde ein Mangel, der die ganze Zeit da war.

#### 2. Die Plattform heißt in der Projektmappe anders als im Projekt

| Datei | gültiger Name |
|---|---|
| `Eudora.sln` | **`x86`** |
| `*.vcxproj` | **`Win32`** |

Wer `-p:Platform=Win32` auf die *Projektmappe* anwendet, bekommt:

```
MSB4126: Die angegebene Projektmappenkonfiguration "Release|Win32" ist ungültig.
```

Nicht raten — nachlesen in `Eudora.sln`, Abschnitt
`GlobalSection(SolutionConfigurationPlatforms)`.

#### 3. MSBuild kann **0** zurückgeben, obwohl nichts gebaut wurde

Der Rückgabewert allein trägt nicht. Am 05.09.2026 meldete die Shell `EXITCODE=0`,
während MSBuild sieben Fehler ausgab und keine Datei erzeugte — die
`Eudora.exe` blieb die alte, mit der **alten** Versionsnummer im Paket.

**Immer drei Dinge prüfen:**

```bash
grep -cE "^.*error " bau.log          # 0 erwartet
ls -la Eudora71/Bin/Release/Eudora.exe # Zeitstempel muss neu sein
grep -aoE "7\.2\.0\.[0-9]" Eudora71/Bin/Release/Eudora.exe | sort -u
```

Die letzte Zeile muss dieselbe Nummer zeigen wie `EUDORA_BUILD_VERSION` in
[Eudora71/Version.h](Eudora71/Version.h). Weicht sie ab, wurde nicht neu gebaut.

#### 4. `OT501` ist aus dem Bau genommen — absichtlich

Das Projekt kapselt die **Stingray Objective Toolkit**, deren Quellen die
CHM-Freigabe nicht enthält. Es kann deshalb **nie** bauen. Ersetzt wird es durch
die eigene Schicht [OTShim](Eudora71/OTShim).

Belegt, dass es niemand braucht:

- Kein einziges Projekt bindet `OTA50R.lib` oder `OTA50D.lib`. Die einzige
  Erwähnung steht in `Eudora.vcxproj` unter `IgnoreSpecificDefaultLibraries` —
  also ausdrücklich, um sie **nicht** zu binden.
- Die beiden Projektverweise trugen bereits
  `<LinkLibraryDependencies>false</LinkLibraryDependencies>`.
- Keine Quelldatei bindet Stingray-Kopfdateien ein.

Am 05.09.2026 wurden deshalb die Projektverweise aus `Eudora.vcxproj` und
`EudoraRes.vcxproj` entfernt und die beiden `.Build.0`-Einträge aus
`Eudora.sln`. Das Projekt bleibt in der Mappe **sichtbar**, wird aber nicht mehr
gebaut. `..\OT501\Include` bleibt im Suchpfad — die Kopfdateien werden
gebraucht, nur die Bibliothek nicht.

**Wer OT501 wieder in den Bau nimmt, bricht den Bau.**

---

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

Getrennt davon steht die Portierung von QCSSL auf die **OpenSSL-3.x-API**: 0.9.7l von
2006 kannte noch offene Strukturen, 3.x kapselt sie hinter Zugriffsfunktionen. Betroffen
waren vor allem die BIO-Schicht und `QCSSLContext.cpp`. SSLv2 und SSLv3 sind dabei
abgeschaltet. Als Mindestprotokoll setzen inzwischen **alle acht** Einstellungen von
`m_ProtocolVersion` `TLS1_2_VERSION`. Bis Befund M1 setzte `m_ProtocolVersion == 3`
(früher "TLSv1") noch `TLS1_VERSION`, also TLS 1.0 — und das war ausgerechnet die
Voreinstellung (`EudoraRes.rc:8143`, `:8147`). Eine Obergrenze wird bewusst an keiner
Stelle gesetzt — `SSL_CTX_set_max_proto_version()` kommt in QCSSL nicht vor, damit
stets das höchste beiderseits unterstützte Protokoll ausgehandelt wird.

## Der geloeste Blocker: OT501

> **Erledigt seit `a807b93`** — die Ersatzschicht traegt, `Eudora.exe` bindet ohne
> Stingray. Dieser Abschnitt beschreibt, worin das Problem bestand und wie es
> geloest wurde.

`Eudora.exe` linkte gegen **Stingray Objective Toolkit 5.0.1**, eine kommerzielle
MFC-Erweiterung von 1995. Die CHM-Freigabe durfte nur Qualcomm-eigenen Code
enthalten — von OT501 sind deshalb nur die 127 Header übrig (`.h`/`.H`; das
Verzeichnis `Eudora71/OT501/Include` hat 130 Einträge, dazu zählen aber `SECRES.RC`,
`SECRES.APS` und der Unterordner `RES`), die Quelldateien fehlen fast vollständig.
Eine fertige Binärdatei von damals hilft nicht: mit VC6 gegen MFC 4.21
übersetzt, verlinkt sie sich nicht mit VS 2022.

Eudora baut darauf sein komplettes Fenstergerüst auf — `CMainFrame` erbt über
`QCWorkbook` von `SECWorkbook`. Insgesamt leitet Eudora an 30 Stellen von
22 verschiedenen Stingray-Klassen ab und ruft 77 Methoden auf (ausgezählt aus den
Abschnitten 1 und 2 von [INVENTAR.md](Eudora71/OTShim/INVENTAR.md)).
**42** Quelldateien (`.cpp`) unter `Eudora71/Eudora` nennen mindestens einen
Stingray-Bezeichner; dazu kommen 30 Header. Gezählt wurde über `\bSEC[A-Za-z_]…`
abzüglich der Treffer, die kein Stingray sind: die SSPI-Namen aus `AuthRPA.cpp`
(`SEC_E_*`, `SEC_I_*`, `SECPKG_*`, `SECBUFFER_*`, `SECURITY_*`), `SECRET_SEED` in
`timestmp.cpp` und `SECTION` in `persona.cpp`. Früher stand hier 39 — diese Zahl
ließ sich nicht reproduzieren.

**Gewählter Weg:** eine eigene Ersatzschicht auf modernes MFC.

Die Analyse der vier Klassenfamilien ist abgeschlossen und hat den Umfang deutlich
verkleinert. Die 77 Methoden sind nicht 77 Aufgaben: viele sind gar keine
Stingray-Methoden, sondern geerbte MFC-Methoden, die Eudora nur qualifiziert aufruft
(in der Workbook-Familie sind von 16 gelisteten nur 7 überhaupt in Stingray-Headern
deklariert); andere werden nie aufgerufen, weil Qualcomm sie durch eigene Varianten
ersetzt hat.

Zwei Funde haben den Weg besonders verkürzt:

- **`SECStatusBar` ist eine 1:1-Kopie von MFCs `CStatusBar`** mit anderer Basisklasse.
  Ein `typedef` erledigt alle 11 Methoden.
- **`secData` lag bereits im Repo.** `OT501/Src/secaux.cpp` ist Teil der Freigabe und
  musste nur in die Projektdatei aufgenommen werden.

Ein dritter Fund hat sich dagegen **als falsch erwiesen** und ist hier festgehalten,
damit ihn niemand aus einer älteren Fassung dieser Datei übernimmt:

- ~~Die Registerkartenleiste ist verzichtbar.~~ Das gilt **nur** für den
  MDI-Streifen hinter `m_bWorkbookMode` (`mainfrm.cpp:1025`). Das
  Registerkarten-*Steuerelement* `SEC3DTabWnd`/`SEC3DTabControl` sitzt in **jeder
  Wazoo-Leiste** (`WazooBar.h:137`, `QC3DTabWnd.h:14`, `:74`) und wird davon nicht
  abgeschaltet. Mit leeren Rümpfen startet Eudora zwar, aber Mailboxes, Nicknames,
  Filters, Directory Services, Link History und Task Status blieben leer — das
  Programm wäre unbenutzbar. Die Registerkarten sind deshalb als eigener Teil
  ausgeführt (`OTShim_Reiter.*`, 2925 Zeilen). Beleg: `PLAN.md`, Abschnitt
  „Berichtigungen", Punkt 1.

Bestandsaufnahme: [Eudora71/OTShim/INVENTAR.md](Eudora71/OTShim/INVENTAR.md) —
Umsetzungsplan mit Stufen, Belegen und Inventarkorrekturen:
**[Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md)**

## Offene Themen

Stand der Tabelle: die Zeilen zu Bauzustand und Ersatzschicht sind an `a807b93`
gemessen, die Zeilen zu Start, Menüs, Erscheinungsbild, Abruf, Paket und
Produktversion am 31.08.2026 (`2cf569f`). An mehreren Zeilen wird parallel
gearbeitet, sie veraltet also schnell — im Zweifel neu messen.

| Thema | Stand |
|---|---|
| OT501-Ersatzschicht | **geschrieben und vollstaendig eingehaengt** (`e50a89c`). `Eudora71/OTShim/` umfasst an `a807b93` **17828 Zeilen** in 11 Dateien (`wc -l`). Ueber `OTShimAll.h` eingebunden und mit ihren `.cpp` in `Eudora.vcxproj:217` aufgenommen sind alle fuenf Teile: Stufe 0-2 (`OTShim.*`, 5494), Stufe 3 (`OTShim_Werkzeugleiste.*`, 6083), Stufe 4 (`OTShim_Bild.*`, 2358), Registerkarten (`OTShim_Reiter.*`, 2925) und `SECDateTimeCtrl`/Palette (`OTShim_Palette.*`, 890). Dazu `OT501/Src/secaux.cpp` direkt im Projekt |
| `Eudora.exe` binden | **erledigt** seit `a807b93` — **0 ungeloeste Externe**, nachgemessen ohne die Attrappe. Verlauf 1088 (651 verschiedene) — rund 299 — 8 — 3 — 1 — 0, Bezugscommits in `PLAN.md`, Abschnitt „Der Weg zum Linken" |
| `__imp___iob` aus `libpng.lib` | **behelfsweise geloest** — `OTShim_Libpng.cpp` definiert das Symbol als `(char*)stderr - 2*32`, weil libpng 1.2.7 nur `_iob[2]` anfasst und die damalige CRT 32 Byte je Element hatte. Traegt, ist aber eine Annahme; sauber waere ein Neubau von libpng aus `Eudora71/PNG/libpng` mit v143 |
| Attrappe `Lib/Debug/OTA50D.LIB` | **entfaellt** — seit `a807b93` nicht mehr noetig (`_SECNOMSG`, `LinkLibraryDependencies` false in `Eudora.vcxproj:1015`). Sie darf nicht wieder angelegt werden, sonst linkt Eudora gegen eine leere Bibliothek |
| `EudoraRes.dll` | **offen** — das Projekt haengt ueber `EudoraRes.vcxproj:351` an `OT501` und wird gar nicht erst versucht. Fuer `Eudora` ist dieselbe Bindung geloest; hier steht der Handgriff noch aus |
| Erster Start von `Eudora.exe` | **erledigt** seit Befund S-2 (30.08.2026) — Eudora startet und läuft bis in die Fenstererzeugung, ohne abzustürzen. Am 31.08.2026 ist das Fenster bedienbar und ruft Mail ab, siehe oben und [ZIEL.md](ZIEL.md). Welche Laufzeitdateien danebenliegen müssen, steht in [STARTUMGEBUNG.md](STARTUMGEBUNG.md); was passiert, wenn sie fehlen, in Befund S-8 (`0xc000007b`) |
| Unit- und Komponententests | **vorhanden** — `Eudora71/Tests` (`RunTests.cmd`) und `Eudora71/Tests/QCSSL` (`bauen.bat`, `messen.ps1`). Nach Vorgabe zu jedem Commit laufen lassen. Die Testzahl waechst gerade, weil die Ersatzschicht Tests bekommt |
| `Eudora.vcxproj` eigene Fehler | 269 — 74 — 25 — 16 — 4 — **0**. `Eudora.exe` kompiliert vollstaendig, seit `78a9c10` samt Ersatzschicht, und bindet seit `a807b93`. `EudoraRes.vcxproj` uebersetzt ebenfalls vollstaendig, wird im Solution-Bau aber nicht versucht |
| `OpenSSL3/lib` fehlt im Repo | **offen** — `libcrypto.lib` und `libssl.lib` sind von `.gitignore:7` (`Lib/`) erfasst und nicht versioniert (`git ls-files`: null Treffer). Ein frischer Klon endet bei `QCSSL` mit `LNK1104: libssl.lib`. Siehe [BAUEN.md](Eudora71/OpenSSL3/BAUEN.md) |
| OpenSSL 3.5 statt 0.9.7l (2006) | **erledigt** — QCSSL baut gegen 3.5.8 LTS; TLS 1.3 zweimal **gemessen** (Komponententest lokal, dann im Betrieb), ausgehandelt `TLS_AES_256_GCM_SHA384`; 30 angebotene Cipher Suites, keine mit RC4, 3DES oder EXPORT |
| QCSSL gegen echten Mailserver prüfen | **nur mit einer älteren Fassung** — am 29.08.2026 gegen `pop.gmx.net:995`: `TLSv1.3`, `TLS_AES_256_GCM_SHA384`, 256 Bit, Status `Succeeded`. Dieser Abruf lief in einer **bestehenden Eudora-7.1-Installation** und mit einer älteren QCSSL, nicht mit dem selbst gebauten `Eudora.exe`. Die ausgelieferte QCSSL 1.0.1 ist nie gegen einen echten Server gelaufen. Kriterium 3 aus [ZIEL.md](ZIEL.md) ist damit **nicht** erfüllt |
| **Hostnamenpruefung greift nicht** | offen und sicherheitsrelevant — gemessen: ein Zertifikat mit falschem `CN` wird mit `SSLSUCCEEDED` und `ErrorCode 0` angenommen. Ein Hinweistext wird durchaus angehaengt ("Destination Host name does not match … But ignoring this error because Certificate is trusted"), er bleibt nur ohne Wirkung. Altbestand von QUALCOMM. Siehe `PORTIERUNG.md` |
| Aktueller `rootcerts.p7b` für das Release | **erledigt** seit `75b60e1` — `Releases/1.0/rootcerts.p7b` mit 121 Zertifikaten, erzeugt von `Releases/1.0/rootcerts-erzeugen.ps1`. Die Altbestaende im Baum sind **zwei verschiedene Dateien** (verschiedene SHA256): `Eudora71/Bin/Release/rootcerts.p7b` mit 19 Zertifikaten (aeltestes gueltig ab 09.11.1994, juengstes ab 22.09.2000), 8 davon heute abgelaufen; `InstallersForEudora/Eudora7.1/Data/win32/rootcerts.p7b` mit 30, juengstes ab 04.03.2004, 17 abgelaufen. QCSSL prueft nur gegen diese Datei, nicht gegen den Windows-Speicher |
| Zeichensatz-Darstellung | **fertig** — der UTF-8-Fall laeuft seit `63f81dc` ueber den Windows-Codepage-Wandler statt ueber die handgepflegte Tabelle; die Tabelle bleibt als Rueckfallweg fuer Post, die `utf-8` behauptet und in Wahrheit CP1252-Bytes traegt. Davor: `XLATE_CHARS` von 27 auf 123 erhoeht (`d03007f`), sieben falsche Zuordnungen berichtigt, Doppelersetzung beseitigt. **33 von 33 Tests gruen** (selbst nachgemessen an `04e93c3` mit `Eudora71/Tests/RunTests.cmd`). Grenzen und Nebenbefunde in `PORTIERUNG.md` |
| Release-Konfiguration | **erledigt** seit Befund F-1 (31.08.2026) — `Eudora.exe` bindet im Release-Zweig, 2 933 760 Byte, und braucht nur die drei **verteilbaren** Laufzeit-DLLs. Zwei Ursachen: in `Eudora.vcxproj:147` stand `OTA50D.LIB` (Debug-Name) statt `OTA50R.LIB` in `IgnoreSpecificDefaultLibraries`, und der Nachbereitungsschritt rief das nicht vorhandene `MakeDox.pl` (`MSB3073`). **Statisch** binden ist dagegen ausgeschlossen: Eudora hat sechs MFC-Erweiterungs-DLLs (F-1.1). Berichtigung aus B-2: Paket 1.0.2 war **gemischt** (Release-Fremdmodule, Debug-`Eudora.exe`) |
| **Kriterium 0: Paket ohne Nachinstallieren** | **nicht belegt** — der Release-Bau ist da (F-1) und braucht keine Debug-Laufzeit mehr, aber niemand hat das Paket auf einem Rechner **ohne** Visual Studio gestartet. Der Win11-Lauf war der Debug-Bau (E-8). `tools/paket-pruefen.ps1` taugt nicht als Nachweis — es prüft die Maschine statt das Paket und warnt bei einem Release-Paket viermal falsch (PR-2.0 bis PR-2.3) |
| Menüs lassen sich nicht öffnen (S-5) | **Ursache belegt und behoben** (Befund M-1, 31.08.2026): `SECToolBarManager` setzte `m_bMainFrameEnabled` auf `TRUE`, damit lieferte `CMainFrame::OnNcHitTest` immer `HTERROR` und die gesamte Nichtklientenfläche war tot. **Am laufenden Programm nicht nachgesehen** |
| Erscheinungsbild (S-6) | **Ursachen belegt und behoben** (Befund A-1, 31.08.2026): leere Werkzeugleisten-Knöpfe (`SECStdBtn::DrawDisabled` ließ Text- und Hintergrundfarbe stehen), Andockrechnung nach `m_fPctWidth`, `nCol`/`nRow` in `DockControlBarEx`. Offen bleiben die Splitter und `FloatControlBarInMDIChild`. **Am laufenden Programm nicht nachgesehen** |
| Produktversion | **7.2.0.3** seit `2cf569f` (vorher 7.1.0.9). Erscheint im Splash und unter *Hilfe → Über Eudora*. Drei getrennte Zählungen — Produkt `7.2.0.x`, Paket `1.0.x`, QCSSL `1.0.x`; Tabelle in [Releases/PAKETE.md](Releases/PAKETE.md) |
| Build-Artefakte im Repo | **erledigt** seit `e4a0fae` — `.gitignore` greift, **107** Dateien sind aus dem Index (der Commit zeigt 108 geaenderte Dateien, davon 107 geloescht und die `.gitignore` selbst). Getrackt sind noch 20 `.pdb`, die zu vorgefertigten Fremd-DLLs unter `Bin/Debug` und `Bin/Release` gehoeren und nicht aus diesem Bau stammen |

## Ergänzungen gegenüber der CHM-Freigabe

- `Eudora71/MAPI/include` — Extended-MAPI-Header aus
  [microsoft/MAPIStubLibrary](https://github.com/microsoft/MAPIStubLibrary) (MIT).
  Nötig, weil `mapix.h` und `mapiutil.h` seit dem Windows-8-SDK nicht mehr
  im Windows SDK enthalten sind — im hier benutzten SDK 10.0.22621.0 liegen unter
  `um\` nur noch `MAPI.h` und `MapiUnicodeHelp.h`.
- `Eudora71/OpenSSL3` — Header und statische Bibliotheken von **OpenSSL 3.5.8 LTS**
  (`libcrypto.lib`, `libssl.lib`), damit sich `QCSSL` ohne einen 25-minütigen
  OpenSSL-Lauf übersetzen lässt. Bauweg und Prüfsumme stehen in
  [Eudora71/OpenSSL3/BAUEN.md](Eudora71/OpenSSL3/BAUEN.md). Das alte `Eudora71/OpenSSL`
  (0.9.7l) liegt noch im Baum. Gegen `libeay32.lib`/`ssleay32.lib` linkt allerdings
  **kein** Projekt mehr; geblieben ist nur ein toter Include-Pfad `..\OpenSSL\inc32`
  in `QCSocket.vcxproj:60` und das `OpenSSL`-Projekt, das in der Solution noch
  mitgebaut wird. Beides kann weg.
- `Eudora71/Eudora/utils.cpp` — UTF-8-Übersetzungstabelle von 27 auf 123 Einträge
  erweitert (deutsche Umlaute und Latin-1), nach
  [HansWurst81675/Eudora_patches](https://github.com/HansWurst81675/Eudora_patches).
  Sie ist inzwischen mehr als der Patch: sieben Zuordnungen aus dem
  Qualcomm-Altbestand waren falsch und sind mit `b4b7de5` berichtigt, ebenso die
  Doppelersetzung, die der neue C3-Block ausgelöst hat. Belegt durch die Unit-Tests
  in `Eudora71/Tests`.

## Verwandte Projekte

- [HermesMail](https://sourceforge.net/projects/hermesmail/) — rüstet ein
  installiertes Eudora 7.1 binär mit neueren TLS-DLLs nach (OpenSSL 1.0.2)
- [Eudora_patches](https://github.com/HansWurst81675/Eudora_patches) — Binärpatches
  für die Umlautdarstellung

## Lizenz

Der Eudora-Quellcode steht unter der BSD-artigen Lizenz der Freigabe von 2018
(siehe Kopf der Quelldateien). Fremdbestandteile behalten ihre eigenen Lizenzen.
