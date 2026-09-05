# Eudora 7.2

<!-- pruefstand: d826a3f -->
<!-- Die Marke oben nennt den Commit, gegen den diese Datei zuletzt abgeglichen
     wurde. Wer die Datei nachzieht, zieht die Marke mit.
     Gelesen von tools/pruefstand-melden.pl (Befund NP3-7). -->

Portierung des Eudora-7.1-Quellcodes auf Visual Studio 2022 â mit dem Ziel, den
Mailclient wieder selbst bauen und weiterentwickeln zu kÃ¶nnen.

Grundlage ist die Quelltextfreigabe des [Computer History Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/)
(2018, mit Genehmigung von Qualcomm).

## Stand

> ## Eudora startet, ist bedienbar und ruft Mail ab â verfassen kann man noch nicht.
>
> **Gemessen am 05.09.2026** an **7.2.0.10 / Paket 1.0.10**
> (`Release|x86`, Toolset v143 / MSVC 14.38.33130). Gregor hat an diesem Abend
> mehrere Fassungen in der VM gestartet, bedient und Mail damit abgerufen.
>
> **Sein Fazit, wÃ¶rtlich** (Stand 7.2.0.6):
>
> > *ârelease startet. mails kÃ¶nnen abgerufen werden. beenden geht nicht.
> > ctrl-n = crash"*
>
> FÃ¼r beide offenen Punkte liegen seither Behebungen vor â **E-16** (sechs
> ungeprÃ¼fte `CPtrArray::ElementAt` in Eudoras eigenem Code) und **E-20**
> (FeldÃ¼berlauf in `ListCtrlEx`). **Beide sind ungeprÃ¼ft**; ob sie tragen, sagt
> erst der nÃ¤chste Lauf.
>
> Von Gregor an diesem Abend **selbst bestÃ¤tigt**:
>
> | | |
> |---|---|
> | Bau-Kennung im Titel, auch ohne offenes Postfach | **E-7** |
> | Fortschritt beim Mailabruf sichtbar | **E-13** |
> | Umlaute in HTML-Mail richtig (`fÃ¼r` statt `fÃÂ¼r`) | **Z-2b** |
> | Zusicherung `WazooBarMgr.cpp:409` bleibt beim Start aus | **E-4**, zur HÃ¤lfte |
>
> Wer den Stand prÃ¼ft, misst neu und nennt seinen eigenen Bezugscommit â an
> diesem Baum arbeiten mehrere Agenten gleichzeitig.
>
> **Zur Versionsnummer:** die letzte Ziffer wandert schnell. Seit dem
> 05.09.2026 gilt **eine Nummer, ein Bau** â jede Fassung, die das
> Entwicklungsverzeichnis verlÃ¤sst, zÃ¤hlt vorher hoch. Vorher gab es dreimal
> denselben Fehler: drei verschiedene ZIPs unter `v1.0.3`, fÃ¼nf QuellÃ¤nderungen
> unter `7.2.0.4`, zwei BinÃ¤rdateien unter `7.2.0.5`. NachzuprÃ¼fen mit
> `perl tools/ausliefern.pl --pruefen`.
>
> Was âlauffÃ¤hig" heiÃt, hat Gregor in [ZIEL.md](ZIEL.md) festgelegt. **Dort
> steht die maÃgebliche Kriterientabelle**; die folgende ist ihre Kurzfassung:
>
> | # | Kriterium | Stand am 05.09.2026 |
> |---|---|---|
> | 0 | das Paket laeuft ohne Nachinstallieren | **nicht belegt** — auf keinem Rechner **ohne** Visual Studio gestartet. `tools/paket-pruefen.ps1` taugt nicht als Nachweis, es prueft die Maschine statt das Paket (PR-2) |
> | 1 | startet und zeigt sein Hauptfenster | **erfuellt** — Gregor hat mehrere Fassungen gestartet und bedient. Der Absturz auf frischen Installationen (E-11) ist behoben, auf einer frischen Installation aber nicht nachgesehen |
> | 2 | die Darstellung ist korrekt | **fast** — Titel (E-7), Fortschritt (E-13) und Umlaute (Z-2b) sind von Gregor bestaetigt. **Offen: Strg-N stuerzt ab** (E-16 behoben, ungeprueft) und das Beenden bricht ab (E-4 zur Haelfte) |
> | 3 | Mailkonto verbinden und Mail abrufen | **erfuellt** — Gregor am 05.09.2026: *„mails koennen abgerufen werden“*; am 31.08. 159 Nachrichten von `mx.freenet.de`, STARTTLS, TLSv1.3 (E-1, E-3) |
>
> **Zwei von vier Kriterien sind belegt, eines fast, eines offen.** Erst wenn
> alle vier erfÃ¼llt sind, darf eine Fassung âlauffÃ¤hig" heiÃen. Die Dateinamen
> `Eudora72-1.0.1-lauffaehig.zip` und `Eudora72-1.0.2-lauffaehig.zip` behaupten
> mehr, als die Fassungen kÃ¶nnen; sie bleiben nur stehen, weil die Pakete unter
> diesen Namen samt PrÃ¼fsumme verÃ¶ffentlicht sind.
>
> **Der nÃ¤chste Schritt** steht in [AUFGABEN.md](AUFGABEN.md) ganz oben: das
> Paket auf dem zweiten PC (Windows 11, ohne Visual Studio) auspacken und
> starten. Dieser eine Lauf beantwortet die Kriterien 0, 1 und 2 zusammen.
> Achtung auf die PrÃ¼fsumme â das ZIP unter
> [Releases v1.0.3](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.3)
> ist am 31.08. um 09:00 **ausgetauscht** worden. Nur die Fassung mit SHA256
> `d4719047â¦` enthÃ¤lt die Behebung von E-11; die erste (`632c4066â¦`) stÃ¼rzte ab.

Der Weg dorthin an zwei Tagen: `Eudora.exe` band zum ersten Mal, startete nicht,
und die GrÃ¼nde dafÃ¼r sind belegt und behoben â siehe
[BEFUNDE.md](BEFUNDE.md), Befunde S-1 bis S-8 sowie B-1/B-2, M-1, A-1, P-1/P-2
und W-1. **Am Anfang von `BEFUNDE.md` steht ein Verzeichnis** aller Kennungen
mit Statusspalte; ohne das findet man in 5900 Zeilen nichts wieder.

Der eigentliche Blocker war die **WerbeflÃ¤che**: `CAdWazooWnd::OnCreate` legt sie
mit `CRect(0,0,0,0)` an, die Textmaschine Paige bekommt eine Umbruchbreite von
null und dreht sich in einer Endlosrekursion fest (1689 Stapelrahmen, davon 1613
im Zyklus). Sie hÃ¤ngt jetzt an `QCSharewareManager::IsBoxBuild()`, dazu der
Ãbersetzungsschalter `BUILD_BOX_OR_SITE_R_VERSION`. Damit entfallen **Werbung,
Registrierung und EinfÃ¼hrungsdialog** â das ist die Fassung, die QUALCOMM an
Firmenkunden ausgeliefert hat.

### Nach einem frischen Klon: einmal die Zeilenenden angleichen

```bash
perl tools/zeilenenden-angleichen.pl --aendern
git ls-files -z | xargs -0 -n 400 git add --
```

**Ohne diesen Schritt springt jede Datei, die man anfasst, als komplett geÃ¤ndert
heraus.** Gemessen am 30.08.2026: 4616 von 5563 verfolgten Dateien lagen als CRLF vor, wÃ¤hrend
im Commit LF steht â Folge eines Auscheckens mit `core.autocrlf=true`. Git sieht
in eine Datei gar nicht hinein, solange Zeitstempel und GrÃ¶Ãe zum Index passen;
der Schaden bleibt deshalb unsichtbar, bis ein Werkzeug die Datei berÃ¼hrt. Das
ist die Wurzel aller CRLF-Probleme dieses Projekts, Befund S-7.

### Bauen

```bash
"C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" Eudora71\Eudora.sln -t:Build -p:Configuration=Release -p:Platform=x86 -m
```

Das ist der ganze Vorgang: Projektmappe laden, bauen. **Keine Zusatzschalter.**
`/p:BuildProjectReferences=false` wird nicht mehr gebraucht â das Projekt `OT501`
ist seit dem 05.09.2026 aus dem Bau genommen (Projektverweise und
`.Build.0`-Zeilen entfernt), weil es niemand bindet. Gemessen und belegt in
[PRUEFUNG-BAU.md](PRUEFUNG-BAU.md).

Die Visual-Studio-IDE wird nicht gebraucht, nur die Installation
(MSVC v143, MFC/ATL, Windows SDK). Achtung auf die **Plattform**: die
Projektmappe kennt `x86`, die Projektdateien `Win32`. Wer `-p:Platform=Win32`
an die `.sln` gibt, bekommt `MSB4126`.

> **In einem frischen Klon oder Worktree zuerst die ganze Solution bauen.**
> Mit `/p:BuildProjectReferences=false` endet der Einzelprojekt-Bau sonst mit
>
> ```
> LINK : fatal error LNK1104: Datei "imap.lib" kann nicht geoeffnet werden.
> ```
>
> â nicht, weil etwas kaputt wÃ¤re, sondern weil `Eudora71/Lib/` von
> `.gitignore` erfasst ist und `imap.lib` erst vom Projekt `imapdll` erzeugt
> wird. Gemessen am 31.08.2026 (Befund A-1, Abschnitt âBauzustand"). Nach einem
> Gesamtbau der Solution bindet `Eudora.vcxproj` durch (Befund B-2).
>
> Der MSBuild-Aufruf muss aus **PowerShell** kommen: die Git-Bash macht aus
> `/p:Configuration=Debug` einen Pfad.

Ein voller Solution-Bau meldet **0 Fehler**, nachgemessen am 05.09.2026 in vier
frischen Klonen, Release und Debug, auch nach `-t:Clean` und mit `-t:Rebuild`
([PRUEFUNG-BAU.md](PRUEFUNG-BAU.md)). Die drei frÃ¼heren `OT501`-Fehler
(zweimal `NMAKE U1073`, einmal `MSB3073`) entfallen, seit `OT501` aus dem Bau
genommen ist.

Der `LNK1181: QCUtils.lib` in `NSImport`, `OEImport`, `OLImport` und `plstclnt`
war **kein bloÃer Wettlauf**, sondern eine fehlende Baureihenfolge: die fÃ¼nf
Projekte banden `QCUtils.lib`, ohne einen Projektverweis auf `QCUtils` zu
tragen. Beim ersten Bau traf es mal zu, mal nicht; **nach einem `Clean` traf es
immer**, weil `Clean` `QCUtils.lib` mit lÃ¶scht. Behoben am 05.09.2026, die
Verweise stehen jetzt in den fÃ¼nf Projektdateien.

### Starten

#### Zuerst: die Debug-Laufzeiten dazulegen

**Ohne diesen Schritt startet Eudora nicht.** Der Debug-Bau braucht vier
DLLs, die nicht mit ausgeliefert werden dÃ¼rfen:

```
mfc140d.dll   msvcp140d.dll   vcruntime140d.dll   ucrtbased.dll
```

DafÃ¼r gibt es ein Werkzeug â es kopiert sie und prÃ¼ft jede einzeln auf ihre
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
> Dieser Code heiÃt `STATUS_INVALID_IMAGE_FORMAT` und bedeutet fast immer
> **Bitness-Konflikt**: eine 64-Bit-DLL in einem 32-Bit-Prozess.
> **`Eudora.exe` ist ein 32-Bit-Programm.**
>
> Zwei Fallen fÃ¼hren dahin:
>
> 1. **DLL-Sammelseiten** wie dll-files.com liefern hÃ¤ufig die 64-Bit-Fassung,
>    ohne es deutlich zu machen. Von dort **keine** Laufzeit-DLLs holen.
> 2. Der 32-Bit-Systemordner heiÃt unter Windows ausgerechnet **`SysWOW64`** â
>    der Name legt das Gegenteil nahe:
>
>    | Ordner | enthÃ¤lt |
>    |---|---|
>    | `C:\Windows\System32` | **64**-Bit-DLLs |
>    | `C:\Windows\SysWOW64` | **32**-Bit-DLLs â diese hier |
>
> Die richtigen Dateien liegen auf jedem Rechner mit installiertem Visual
> Studio 2022 (mit C++-Werkzeugen und MFC/ATL) bereits in `SysWOW64`, in der
> zum Toolset passenden Fassung. **Ohne Visual Studio lÃ¤uft dieser Bau nicht.**
> DafÃ¼r gibt es seit Befund F-1 den **Release-Bau**: er braucht nur
> `mfc140.dll`, `msvcp140.dll` und `vcruntime140.dll`, und diese drei sind Teil
> des Visual-C++-Redistributable und dÃ¼rfen beiliegen.

#### Dann starten

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Das Mailverzeichnis **muss eine `Eudora.ini` enthalten**, sonst bricht Eudora in
`eudora.cpp:3542` ab. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`.

Beim ersten Start erscheinen drei bis vier Dialoge âSUPERASSERT Assertion
Failure" â auf *Ignore Once* klicken. Das sind Debug-Zusicherungen, keine Fehler.
Sie erscheinen nur, weil bisher nur der Debug-Bau lÃ¤uft.

Der Fenstertitel trÃ¤gt die **Bau-Kennung** â Paketversion, Commit und
Herkunftsverzeichnis:

```
Eudora - [In]   [1.0.3+371c1e3 - Eudora72-1.0.3]
```

Ein Sternchen hinter dem Commit heiÃt: beim Bau lagen ungesicherte Ãnderungen
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

`QCSSL.dll` ist gegen **OpenSSL 3.5.8 LTS** gebaut, Mindestprotokoll TLS 1.2 fÃ¼r
alle Einstellungen. TLS 1.3 ist zweimal nachgemessen: im Komponententest gegen
einen lokalen Server und am 29.08.2026 gegen `pop.gmx.net:995`
(`TLSv1.3`, `TLS_AES_256_GCM_SHA384`, 256 Bit).

**Achtung:** dieser Abruf fand mit einer *Ã¤lteren* QCSSL-Fassung statt. Die
ausgelieferte QCSSL 1.0.1 ist gegen Komponententests geprÃ¼ft, aber nie gegen
einen echten Mailserver. Einzelheiten in
[Releases/1.0/AUSLIEFERUNGEN.md](Releases/1.0/AUSLIEFERUNGEN.md).

### Werkzeuge

| Werkzeug | wozu |
|---|---|
| `tools/zeilenenden-angleichen.pl` | Arbeitskopie byteidentisch zum Commit machen. Nach jedem Klon einmal. Seit Befund **X-4**: erfasst 6444 statt 6395 Dateien, nennt jede angefasste **namentlich**, lÃ¤sst **vorgemerkte** Dateien in Ruhe und behandelt die Gegenrichtung (Arbeitskopie LF, HEAD CRLF) getrennt â sie wird nur mit `--auch-umgekehrt` angeglichen. |
| `tools/aendere-zeile.pl` | eine einzelne Zeile byte-erhaltend Ã¤ndern |
| `tools/ersetze-bereich.pl` | einen Zeilenbereich byte-erhaltend ersetzen |
| `tools/pruefe-bytes.pl` | pre-commit-Schranke gegen lautlosen Byteschaden |
| `tools/pruefe-bytes-tests.pl` | Testsammlung fÃ¼r die pre-commit-Schranke: **35 FÃ¤lle** in eigenen Wegwerf-Repos, darunter je einer fÃ¼r die neun LÃ¶cher aus Befund X-1. **Wer `tools/pruefe-bytes.pl` anfasst, lÃ¤sst sie laufen.** |
| `tools/dateiendungen.pl` | gemeinsame Liste der Dateiarten, die als Text gelten. Wird von der Schranke und von `zeilenenden-angleichen.pl` geladen â zwei getrennte Listen sind schon auseinandergelaufen. |
| `tools/stapel-untersuchen.ps1` | kleiner Debugger: fÃ¤ngt die tÃ¶dliche Ausnahme, lÃ¤uft die EBP-Kette ab, symbolisiert mit `dbghelp`. **Muss in der 32-Bit-PowerShell laufen**, braucht die `.pdb` neben der `.exe`. Damit wurde S-2 gefunden. |
| `tools/suche-zeiger.pl` | sucht Zeiger, die auf `NULL` geprÃ¼ft und danach auÃerhalb des geschÃ¼tzten Blocks dereferenziert werden. Damit wurden die Stellen zu P-2 gefunden. Seit Befund **X-3** mit neun Filtern: **18 Treffer statt 347**, davon neun echte Kandidaten (Liste in `AUFGABEN.md`, D3a). LÃ¤uft ohne Visual Studio. |
| `tools/releasebuffer-pruefen.pl` | stuft jedes `ReleaseBuffer` im Baum ein: ist vorher ein `GetBuffer` auf **derselben** Variablen da? Das ist die Fehlerklasse hinter Befund E-11 (Absturz auf frischen Installationen). Gemessen: 117 richtig, 25 zu Ã¤ndern. RÃ¼ckgabe 1, sobald etwas zu tun ist. LÃ¤uft ohne Visual Studio. |
| `tools/kennung-erzeugen.pl` | erzeugt `BuildKennung.h` vor jedem Bau (PreBuildEvent) |
| `tools/laufzeit-holen.ps1` | holt die vier Debug-Laufzeiten von VS2022 aus `SysWOW64` und prÃ¼ft jede einzeln auf x86 nach. Ohne sie startet Eudora mit `0xc000007b` â Befund S-8. `-NurPruefen` sagt nur, was fehlt. |
| `tools/paket-bauen.ps1` | stellt ein Auslieferungspaket aus dem Quellbaum zusammen, wahlweise als ZIP. **VerÃ¶ffentlicht nichts** â ob ausgeliefert wird, entscheidet ein Mensch. |
| `tools/paket-pruefen.ps1` | prÃ¼ft ein ausgepacktes Paket, **bevor** es jemand startet: Startkette, Architektur, fehlende DLLs. RÃ¼ckgabe 0 = in Ordnung, 1 = Fehler, 2 = Aufrufproblem. Das MaÃ fÃ¼r Kriterium 0. |
| `tools/vc71-bruecke-messen.pl` | misst die Bindung der Fremd-DLLs an die VC-7.1-Laufzeit und erzeugt daraus die `.def` der `VC71Bruecke` |
| `tools/release-pruefen.pl` | prÃ¼ft, ob das ausgelieferte Release zum Quellstand passt |
| `tools/hooks-einrichten.sh` | richtet den pre-commit-Hook ein. Nach jedem Klon einmal â ohne ihn treten zwei Fehlerklassen lautlos wieder auf. |
| `tools/lehren-spiegeln.pl` | spiegelt die Lehren aus dem GedÃ¤chtnis nach `Arbeitsweise/` |
| `tools/pruefstand-melden.pl` | meldet, wie weit `BEFUNDE.md`, `README.md` und `PORTIERUNG.md` hinter dem Code herhinken. MaÃstab ist die Zeile `<!-- pruefstand: <commit> -->` in jeder der drei Dateien â **wer eine davon nachzieht, zieht die Marke mit**. Ohne Marke sagt das Werkzeug ânicht messbar" und gibt 1 zurÃ¼ck, statt zu raten (Befunde NP3-6, NP3-7). |
| `tools/ungesichertes-melden.pl` | meldet ungesicherte Ãnderungen |

`tools/rekursion-suchen.pl` wurde am 31.08.2026 **gelÃ¶scht**, siehe Befund W-1:
es bildete jede Kante mit dem Klassennamen der umgebenden Methode und konnte
klassenÃ¼bergreifende Zyklen deshalb strukturell nicht finden â auch den aus S-2
nicht, fÃ¼r den es gebaut wurde. Geliefert hat es ausschlieÃlich Fehlalarme.

## Was bisher gemacht wurde

Der Quellcode ist von 1996â2006 und stammt aus der Zeit von Visual C++ 6.
Repariert wurden im Wesentlichen sieben wiederkehrende Muster:

- Deklarationen ohne RÃ¼ckgabetyp (`default-int`, in C++ nicht mehr erlaubt)
- entfernte Header (`<xstddef>`), fehlende Extended-MAPI-Header
- alte `for`-Scope-Regeln (SchleifenzÃ¤hler nach der Schleife weiterbenutzt)
- `strchr`/`strstr`/`strrchr` liefern in C++ `const char*`
- `std::auto_ptr`, Iteratoren-als-Zeiger (`it = NULL`), nicht-`const` Komparatoren
- MFC-`const`-Overloads liefern kein lvalue mehr
- Namenskollisionen mit winsock2 und der UCRT

Dazu drei Projekteinstellungen: die mitgelieferte VC6-Kopie der `/GS`-Runtime
deaktiviert, SafeSEH fÃ¼r QCSSL aus, `/WX` aus dem OpenSSL-Makefile.

AusfÃ¼hrlich mit BegrÃ¼ndungen: **[PORTIERUNG.md](PORTIERUNG.md)**

Getrennt davon steht die Portierung von QCSSL auf die **OpenSSL-3.x-API**: 0.9.7l von
2006 kannte noch offene Strukturen, 3.x kapselt sie hinter Zugriffsfunktionen. Betroffen
waren vor allem die BIO-Schicht und `QCSSLContext.cpp`. SSLv2 und SSLv3 sind dabei
abgeschaltet. Als Mindestprotokoll setzen inzwischen **alle acht** Einstellungen von
`m_ProtocolVersion` `TLS1_2_VERSION`. Bis Befund M1 setzte `m_ProtocolVersion == 3`
(frÃ¼her "TLSv1") noch `TLS1_VERSION`, also TLS 1.0 â und das war ausgerechnet die
Voreinstellung (`EudoraRes.rc:8143`, `:8147`). Eine Obergrenze wird bewusst an keiner
Stelle gesetzt â `SSL_CTX_set_max_proto_version()` kommt in QCSSL nicht vor, damit
stets das hÃ¶chste beiderseits unterstÃ¼tzte Protokoll ausgehandelt wird.

## Der geloeste Blocker: OT501

> **Erledigt seit `a807b93`** â die Ersatzschicht traegt, `Eudora.exe` bindet ohne
> Stingray. Dieser Abschnitt beschreibt, worin das Problem bestand und wie es
> geloest wurde.

`Eudora.exe` linkte gegen **Stingray Objective Toolkit 5.0.1**, eine kommerzielle
MFC-Erweiterung von 1995. Die CHM-Freigabe durfte nur Qualcomm-eigenen Code
enthalten â von OT501 sind deshalb nur die 127 Header Ã¼brig (`.h`/`.H`; das
Verzeichnis `Eudora71/OT501/Include` hat 130 EintrÃ¤ge, dazu zÃ¤hlen aber `SECRES.RC`,
`SECRES.APS` und der Unterordner `RES`), die Quelldateien fehlen fast vollstÃ¤ndig.
Eine fertige BinÃ¤rdatei von damals hilft nicht: mit VC6 gegen MFC 4.21
Ã¼bersetzt, verlinkt sie sich nicht mit VS 2022.

Eudora baut darauf sein komplettes FenstergerÃ¼st auf â `CMainFrame` erbt Ã¼ber
`QCWorkbook` von `SECWorkbook`. Insgesamt leitet Eudora an 30 Stellen von
22 verschiedenen Stingray-Klassen ab und ruft 77 Methoden auf (ausgezÃ¤hlt aus den
Abschnitten 1 und 2 von [INVENTAR.md](Eudora71/OTShim/INVENTAR.md)).
**42** Quelldateien (`.cpp`) unter `Eudora71/Eudora` nennen mindestens einen
Stingray-Bezeichner; dazu kommen 30 Header. GezÃ¤hlt wurde Ã¼ber `\bSEC[A-Za-z_]â¦`
abzÃ¼glich der Treffer, die kein Stingray sind: die SSPI-Namen aus `AuthRPA.cpp`
(`SEC_E_*`, `SEC_I_*`, `SECPKG_*`, `SECBUFFER_*`, `SECURITY_*`), `SECRET_SEED` in
`timestmp.cpp` und `SECTION` in `persona.cpp`. FrÃ¼her stand hier 39 â diese Zahl
lieÃ sich nicht reproduzieren.

**GewÃ¤hlter Weg:** eine eigene Ersatzschicht auf modernes MFC.

Die Analyse der vier Klassenfamilien ist abgeschlossen und hat den Umfang deutlich
verkleinert. Die 77 Methoden sind nicht 77 Aufgaben: viele sind gar keine
Stingray-Methoden, sondern geerbte MFC-Methoden, die Eudora nur qualifiziert aufruft
(in der Workbook-Familie sind von 16 gelisteten nur 7 Ã¼berhaupt in Stingray-Headern
deklariert); andere werden nie aufgerufen, weil Qualcomm sie durch eigene Varianten
ersetzt hat.

Zwei Funde haben den Weg besonders verkÃ¼rzt:

- **`SECStatusBar` ist eine 1:1-Kopie von MFCs `CStatusBar`** mit anderer Basisklasse.
  Ein `typedef` erledigt alle 11 Methoden.
- **`secData` lag bereits im Repo.** `OT501/Src/secaux.cpp` ist Teil der Freigabe und
  musste nur in die Projektdatei aufgenommen werden.

Ein dritter Fund hat sich dagegen **als falsch erwiesen** und ist hier festgehalten,
damit ihn niemand aus einer Ã¤lteren Fassung dieser Datei Ã¼bernimmt:

- ~~Die Registerkartenleiste ist verzichtbar.~~ Das gilt **nur** fÃ¼r den
  MDI-Streifen hinter `m_bWorkbookMode` (`mainfrm.cpp:1025`). Das
  Registerkarten-*Steuerelement* `SEC3DTabWnd`/`SEC3DTabControl` sitzt in **jeder
  Wazoo-Leiste** (`WazooBar.h:137`, `QC3DTabWnd.h:14`, `:74`) und wird davon nicht
  abgeschaltet. Mit leeren RÃ¼mpfen startet Eudora zwar, aber Mailboxes, Nicknames,
  Filters, Directory Services, Link History und Task Status blieben leer â das
  Programm wÃ¤re unbenutzbar. Die Registerkarten sind deshalb als eigener Teil
  ausgefÃ¼hrt (`OTShim_Reiter.*`, 2925 Zeilen). Beleg: `PLAN.md`, Abschnitt
  âBerichtigungen", Punkt 1.

Bestandsaufnahme: [Eudora71/OTShim/INVENTAR.md](Eudora71/OTShim/INVENTAR.md) â
Umsetzungsplan mit Stufen, Belegen und Inventarkorrekturen:
**[Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md)**

## Offene Themen

Stand der Tabelle: die Zeilen zu Bauzustand und Ersatzschicht sind an `a807b93`
gemessen, die Zeilen zu Start, MenÃ¼s, Erscheinungsbild, Abruf, Paket und
Produktversion am 31.08.2026 (`2cf569f`). An mehreren Zeilen wird parallel
gearbeitet, sie veraltet also schnell â im Zweifel neu messen.

| Thema | Stand |
|---|---|
| OT501-Ersatzschicht | **geschrieben und vollstaendig eingehaengt** (`e50a89c`). `Eudora71/OTShim/` umfasst an `a807b93` **17828 Zeilen** in 11 Dateien (`wc -l`). Ueber `OTShimAll.h` eingebunden und mit ihren `.cpp` in `Eudora.vcxproj:217` aufgenommen sind alle fuenf Teile: Stufe 0-2 (`OTShim.*`, 5494), Stufe 3 (`OTShim_Werkzeugleiste.*`, 6083), Stufe 4 (`OTShim_Bild.*`, 2358), Registerkarten (`OTShim_Reiter.*`, 2925) und `SECDateTimeCtrl`/Palette (`OTShim_Palette.*`, 890). Dazu `OT501/Src/secaux.cpp` direkt im Projekt |
| `Eudora.exe` binden | **erledigt** seit `a807b93` â **0 ungeloeste Externe**, nachgemessen ohne die Attrappe. Verlauf 1088 (651 verschiedene) â rund 299 â 8 â 3 â 1 â 0, Bezugscommits in `PLAN.md`, Abschnitt âDer Weg zum Linken" |
| `__imp___iob` aus `libpng.lib` | **behelfsweise geloest** â `OTShim_Libpng.cpp` definiert das Symbol als `(char*)stderr - 2*32`, weil libpng 1.2.7 nur `_iob[2]` anfasst und die damalige CRT 32 Byte je Element hatte. Traegt, ist aber eine Annahme; sauber waere ein Neubau von libpng aus `Eudora71/PNG/libpng` mit v143 |
| Attrappe `Lib/Debug/OTA50D.LIB` | **entfaellt** â seit `a807b93` nicht mehr noetig (`_SECNOMSG`, `LinkLibraryDependencies` false in `Eudora.vcxproj:1015`). Sie darf nicht wieder angelegt werden, sonst linkt Eudora gegen eine leere Bibliothek |
| `EudoraRes.dll` | **erledigt** â der Projektverweis auf `OT501` ist am 05.09.2026 aus `EudoraRes.vcxproj` entfernt. `EudoraRes.dll` entsteht seither in jedem Bau, Release wie Debug, gemessen in vier frischen Klonen; Versionsressource 7.2.0.3 ([PRUEFUNG-BAU.md](PRUEFUNG-BAU.md)) |
| Erster Start von `Eudora.exe` | **erledigt** seit Befund S-2 (30.08.2026) â Eudora startet und lÃ¤uft bis in die Fenstererzeugung, ohne abzustÃ¼rzen. Am 31.08.2026 ist das Fenster bedienbar und ruft Mail ab, siehe oben und [ZIEL.md](ZIEL.md). Welche Laufzeitdateien danebenliegen mÃ¼ssen, steht in [STARTUMGEBUNG.md](STARTUMGEBUNG.md); was passiert, wenn sie fehlen, in Befund S-8 (`0xc000007b`) |
| Unit- und Komponententests | **vorhanden** â `Eudora71/Tests` (`RunTests.cmd`) und `Eudora71/Tests/QCSSL` (`bauen.bat`, `messen.ps1`). Nach Vorgabe zu jedem Commit laufen lassen. Die Testzahl waechst gerade, weil die Ersatzschicht Tests bekommt |
| `Eudora.vcxproj` eigene Fehler | 269 â 74 â 25 â 16 â 4 â **0**. `Eudora.exe` kompiliert vollstaendig, seit `78a9c10` samt Ersatzschicht, und bindet seit `a807b93`. `EudoraRes.vcxproj` uebersetzt ebenfalls vollstaendig, wird im Solution-Bau aber nicht versucht |
| `OpenSSL3/lib` fehlt im Repo | **erledigt** â `.gitignore` nimmt `Eudora71/OpenSSL3/lib/` ausdruecklich wieder aus; `git ls-files` findet `libcrypto.lib` und `libssl.lib`. Vier frische Klone haben `QCSSL` ohne Zutun gebunden (05.09.2026). Siehe [BAUEN.md](Eudora71/OpenSSL3/BAUEN.md) |
| OpenSSL 3.5 statt 0.9.7l (2006) | **erledigt** â QCSSL baut gegen 3.5.8 LTS; TLS 1.3 zweimal **gemessen** (Komponententest lokal, dann im Betrieb), ausgehandelt `TLS_AES_256_GCM_SHA384`; 30 angebotene Cipher Suites, keine mit RC4, 3DES oder EXPORT |
| QCSSL gegen echten Mailserver prÃ¼fen | **nur mit einer Ã¤lteren Fassung** â am 29.08.2026 gegen `pop.gmx.net:995`: `TLSv1.3`, `TLS_AES_256_GCM_SHA384`, 256 Bit, Status `Succeeded`. Dieser Abruf lief in einer **bestehenden Eudora-7.1-Installation** und mit einer Ã¤lteren QCSSL, nicht mit dem selbst gebauten `Eudora.exe`. Die ausgelieferte QCSSL 1.0.1 ist nie gegen einen echten Server gelaufen. Kriterium 3 aus [ZIEL.md](ZIEL.md) ist damit **nicht** erfÃ¼llt |
| **Hostnamenpruefung greift nicht** | offen und sicherheitsrelevant â gemessen: ein Zertifikat mit falschem `CN` wird mit `SSLSUCCEEDED` und `ErrorCode 0` angenommen. Ein Hinweistext wird durchaus angehaengt ("Destination Host name does not match â¦ But ignoring this error because Certificate is trusted"), er bleibt nur ohne Wirkung. Altbestand von QUALCOMM. Siehe `PORTIERUNG.md` |
| Aktueller `rootcerts.p7b` fÃ¼r das Release | **erledigt** seit `75b60e1` â `Releases/1.0/rootcerts.p7b` mit 121 Zertifikaten, erzeugt von `Releases/1.0/rootcerts-erzeugen.ps1`. Die Altbestaende im Baum sind **zwei verschiedene Dateien** (verschiedene SHA256): `Eudora71/Bin/Release/rootcerts.p7b` mit 19 Zertifikaten (aeltestes gueltig ab 09.11.1994, juengstes ab 22.09.2000), 8 davon heute abgelaufen; `InstallersForEudora/Eudora7.1/Data/win32/rootcerts.p7b` mit 30, juengstes ab 04.03.2004, 17 abgelaufen. QCSSL prueft nur gegen diese Datei, nicht gegen den Windows-Speicher |
| Zeichensatz-Darstellung | **fertig** â der UTF-8-Fall laeuft seit `63f81dc` ueber den Windows-Codepage-Wandler statt ueber die handgepflegte Tabelle; die Tabelle bleibt als Rueckfallweg fuer Post, die `utf-8` behauptet und in Wahrheit CP1252-Bytes traegt. Davor: `XLATE_CHARS` von 27 auf 123 erhoeht (`d03007f`), sieben falsche Zuordnungen berichtigt, Doppelersetzung beseitigt. **33 von 33 Tests gruen** (selbst nachgemessen an `04e93c3` mit `Eudora71/Tests/RunTests.cmd`). Grenzen und Nebenbefunde in `PORTIERUNG.md` |
| Release-Konfiguration | **erledigt** seit Befund F-1 (31.08.2026) â `Eudora.exe` bindet im Release-Zweig, 2 933 760 Byte, und braucht nur die drei **verteilbaren** Laufzeit-DLLs. Zwei Ursachen: in `Eudora.vcxproj:147` stand `OTA50D.LIB` (Debug-Name) statt `OTA50R.LIB` in `IgnoreSpecificDefaultLibraries`, und der Nachbereitungsschritt rief das nicht vorhandene `MakeDox.pl` (`MSB3073`). **Statisch** binden ist dagegen ausgeschlossen: Eudora hat sechs MFC-Erweiterungs-DLLs (F-1.1). Berichtigung aus B-2: Paket 1.0.2 war **gemischt** (Release-Fremdmodule, Debug-`Eudora.exe`) |
| **Kriterium 0: Paket ohne Nachinstallieren** | **nicht belegt** â der Release-Bau ist da (F-1) und braucht keine Debug-Laufzeit mehr, aber niemand hat das Paket auf einem Rechner **ohne** Visual Studio gestartet. Der Win11-Lauf war der Debug-Bau (E-8). `tools/paket-pruefen.ps1` taugt nicht als Nachweis â es prÃ¼ft die Maschine statt das Paket und warnt bei einem Release-Paket viermal falsch (PR-2.0 bis PR-2.3) |
| MenÃ¼s lassen sich nicht Ã¶ffnen (S-5) | **Ursache belegt und behoben** (Befund M-1, 31.08.2026): `SECToolBarManager` setzte `m_bMainFrameEnabled` auf `TRUE`, damit lieferte `CMainFrame::OnNcHitTest` immer `HTERROR` und die gesamte NichtklientenflÃ¤che war tot. **Am laufenden Programm nicht nachgesehen** |
| Erscheinungsbild (S-6) | **Ursachen belegt und behoben** (Befund A-1, 31.08.2026): leere Werkzeugleisten-KnÃ¶pfe (`SECStdBtn::DrawDisabled` lieÃ Text- und Hintergrundfarbe stehen), Andockrechnung nach `m_fPctWidth`, `nCol`/`nRow` in `DockControlBarEx`. Offen bleiben die Splitter und `FloatControlBarInMDIChild`. **Am laufenden Programm nicht nachgesehen** |
| Produktversion | **7.2.0.3** seit `2cf569f` (vorher 7.1.0.9). Erscheint im Splash und unter *Hilfe â Ãber Eudora*. Drei getrennte ZÃ¤hlungen â Produkt `7.2.0.x`, Paket `1.0.x`, QCSSL `1.0.x`; Tabelle in [Releases/PAKETE.md](Releases/PAKETE.md) |
| Build-Artefakte im Repo | **erledigt** seit `e4a0fae` â `.gitignore` greift, **107** Dateien sind aus dem Index (der Commit zeigt 108 geaenderte Dateien, davon 107 geloescht und die `.gitignore` selbst). Getrackt sind noch 20 `.pdb`, die zu vorgefertigten Fremd-DLLs unter `Bin/Debug` und `Bin/Release` gehoeren und nicht aus diesem Bau stammen |

## ErgÃ¤nzungen gegenÃ¼ber der CHM-Freigabe

- `Eudora71/MAPI/include` â Extended-MAPI-Header aus
  [microsoft/MAPIStubLibrary](https://github.com/microsoft/MAPIStubLibrary) (MIT).
  NÃ¶tig, weil `mapix.h` und `mapiutil.h` seit dem Windows-8-SDK nicht mehr
  im Windows SDK enthalten sind â im hier benutzten SDK 10.0.22621.0 liegen unter
  `um\` nur noch `MAPI.h` und `MapiUnicodeHelp.h`.
- `Eudora71/OpenSSL3` â Header und statische Bibliotheken von **OpenSSL 3.5.8 LTS**
  (`libcrypto.lib`, `libssl.lib`), damit sich `QCSSL` ohne einen 25-minÃ¼tigen
  OpenSSL-Lauf Ã¼bersetzen lÃ¤sst. Bauweg und PrÃ¼fsumme stehen in
  [Eudora71/OpenSSL3/BAUEN.md](Eudora71/OpenSSL3/BAUEN.md). Das alte `Eudora71/OpenSSL`
  (0.9.7l) liegt noch im Baum. Gegen `libeay32.lib`/`ssleay32.lib` linkt allerdings
  **kein** Projekt mehr; geblieben ist nur ein toter Include-Pfad `..\OpenSSL\inc32`
  in `QCSocket.vcxproj:60` und das `OpenSSL`-Projekt, das in der Solution noch
  mitgebaut wird. Beides kann weg.
- `Eudora71/Eudora/utils.cpp` â UTF-8-Ãbersetzungstabelle von 27 auf 123 EintrÃ¤ge
  erweitert (deutsche Umlaute und Latin-1), nach
  [HansWurst81675/Eudora_patches](https://github.com/HansWurst81675/Eudora_patches).
  Sie ist inzwischen mehr als der Patch: sieben Zuordnungen aus dem
  Qualcomm-Altbestand waren falsch und sind mit `b4b7de5` berichtigt, ebenso die
  Doppelersetzung, die der neue C3-Block ausgelÃ¶st hat. Belegt durch die Unit-Tests
  in `Eudora71/Tests`.

## Verwandte Projekte

- [HermesMail](https://sourceforge.net/projects/hermesmail/) â rÃ¼stet ein
  installiertes Eudora 7.1 binÃ¤r mit neueren TLS-DLLs nach (OpenSSL 1.0.2)
- [Eudora_patches](https://github.com/HansWurst81675/Eudora_patches) â BinÃ¤rpatches
  fÃ¼r die Umlautdarstellung

## Lizenz

Der Eudora-Quellcode steht unter der BSD-artigen Lizenz der Freigabe von 2018
(siehe Kopf der Quelldateien). Fremdbestandteile behalten ihre eigenen Lizenzen.
