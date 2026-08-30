# Eudora 7.2

Portierung des Eudora-7.1-Quellcodes auf Visual Studio 2022 — mit dem Ziel, den
Mailclient wieder selbst bauen und weiterentwickeln zu können.

Grundlage ist die Quelltextfreigabe des [Computer History Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/)
(2018, mit Genehmigung von Qualcomm).

## Stand

> ## Eudora startet und zeigt sein Hauptfenster.
>
> **Gemessen an Commit `371c1e3` am 30.08.2026**, `Debug|Win32`, Toolset v143
> (MSVC 14.38.33130). An diesem Baum arbeiten mehrere Agenten gleichzeitig; wer
> den Stand prüfen will, misst neu und nennt seinen eigenen Bezugscommit.
>
> **Aber es ist noch nicht „lauffähig".** Was das heißt, steht in
> [ZIEL.md](ZIEL.md) — von Gregor am 30.08.2026 festgelegt:
>
> | # | Kriterium | Stand |
> |---|---|---|
> | 1 | startet und zeigt sein Hauptfenster | **strittig** — das Fenster erscheint, ist aber nicht bedienbar |
> | 2 | die Darstellung ist korrekt | **nicht erfüllt** (Befund S-6) |
> | 3 | Mailkonto verbinden und Mail abrufen | **nicht geprüft** |
>
> Erst wenn alle drei erfüllt sind, darf eine Fassung „lauffähig" heißen. Der
> Dateiname `Eudora72-1.0.2-lauffaehig.zip` behauptet mehr, als die Fassung kann.

Der Weg dorthin an einem Tag: `Eudora.exe` band zum ersten Mal, startete nicht,
und die drei Gründe dafür sind belegt und behoben — siehe
[BEFUNDE.md](BEFUNDE.md), Befunde S-1 bis S-7.

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
heraus.** Gemessen: 4616 von 5563 verfolgten Dateien lagen als CRLF vor, während
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

Ein voller Solution-Bau meldet weiterhin **3 Fehler, alle aus `OT501`**
(zweimal `NMAKE U1073`, einmal `MSB3073`). Das Projekt wird nicht mehr gebraucht:
die Ersatzschicht hat es abgelöst.

### Starten

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Das Mailverzeichnis **muss eine `Eudora.ini` enthalten**, sonst bricht Eudora in
`eudora.cpp:3542` ab. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`.

Beim ersten Start erscheinen drei bis vier Dialoge „SUPERASSERT Assertion
Failure" — auf *Ignore Once* klicken. Das sind Debug-Zusicherungen, keine Fehler.
Sie erscheinen nur, weil bisher nur der Debug-Bau läuft; der Release-Zweig
scheitert an einer fehlenden `Imap.lib`.

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
| `tools/zeilenenden-angleichen.pl` | Arbeitskopie byteidentisch zum Commit machen. Nach jedem Klon einmal. |
| `tools/aendere-zeile.pl` | eine einzelne Zeile byte-erhaltend ändern |
| `tools/ersetze-bereich.pl` | einen Zeilenbereich byte-erhaltend ersetzen |
| `tools/pruefe-bytes.pl` | pre-commit-Schranke gegen lautlosen Byteschaden |
| `tools/stapel-untersuchen.ps1` | kleiner Debugger: fängt die tödliche Ausnahme, läuft die EBP-Kette ab, symbolisiert mit `dbghelp`. **Muss in der 32-Bit-PowerShell laufen**, braucht die `.pdb` neben der `.exe`. Damit wurde S-2 gefunden. |
| `tools/kennung-erzeugen.pl` | erzeugt `BuildKennung.h` vor jedem Bau |
| `tools/release-pruefen.pl` | prüft, ob das ausgelieferte Release zum Quellstand passt |
| `tools/rekursion-suchen.pl` | Zyklensuche im Aufrufgraphen. **Grenze:** unterscheidet Überladungen nur am Namen und an der Argumentzahl, nicht an den Typen — lieferte bisher ausschließlich Fehlalarme. |

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

Stand der Tabelle: Commit `a807b93`. An mehreren Zeilen wird gerade parallel
gearbeitet, sie veraltet also schnell — im Zweifel neu messen.

| Thema | Stand |
|---|---|
| OT501-Ersatzschicht | **geschrieben und vollstaendig eingehaengt** (`e50a89c`). `Eudora71/OTShim/` umfasst an `a807b93` **17828 Zeilen** in 11 Dateien (`wc -l`). Ueber `OTShimAll.h` eingebunden und mit ihren `.cpp` in `Eudora.vcxproj:217` aufgenommen sind alle fuenf Teile: Stufe 0-2 (`OTShim.*`, 5494), Stufe 3 (`OTShim_Werkzeugleiste.*`, 6083), Stufe 4 (`OTShim_Bild.*`, 2358), Registerkarten (`OTShim_Reiter.*`, 2925) und `SECDateTimeCtrl`/Palette (`OTShim_Palette.*`, 890). Dazu `OT501/Src/secaux.cpp` direkt im Projekt |
| `Eudora.exe` binden | **erledigt** seit `a807b93` — **0 ungeloeste Externe**, nachgemessen ohne die Attrappe. Verlauf 1088 (651 verschiedene) — rund 299 — 8 — 3 — 1 — 0, Bezugscommits in `PLAN.md`, Abschnitt „Der Weg zum Linken" |
| `__imp___iob` aus `libpng.lib` | **behelfsweise geloest** — `OTShim_Libpng.cpp` definiert das Symbol als `(char*)stderr - 2*32`, weil libpng 1.2.7 nur `_iob[2]` anfasst und die damalige CRT 32 Byte je Element hatte. Traegt, ist aber eine Annahme; sauber waere ein Neubau von libpng aus `Eudora71/PNG/libpng` mit v143 |
| Attrappe `Lib/Debug/OTA50D.LIB` | **entfaellt** — seit `a807b93` nicht mehr noetig (`_SECNOMSG`, `LinkLibraryDependencies` false in `Eudora.vcxproj:1015`). Sie darf nicht wieder angelegt werden, sonst linkt Eudora gegen eine leere Bibliothek |
| `EudoraRes.dll` | **offen** — das Projekt haengt ueber `EudoraRes.vcxproj:351` an `OT501` und wird gar nicht erst versucht. Fuer `Eudora` ist dieselbe Bindung geloest; hier steht der Handgriff noch aus |
| Erster Start von `Eudora.exe` | **offen und ungeprueft** — ob das Programm laeuft, ist noch nicht gemessen. Welche Laufzeitdateien danebenliegen muessen, steht in [STARTUMGEBUNG.md](STARTUMGEBUNG.md) |
| Unit- und Komponententests | **vorhanden** — `Eudora71/Tests` (`RunTests.cmd`) und `Eudora71/Tests/QCSSL` (`bauen.bat`, `messen.ps1`). Nach Vorgabe zu jedem Commit laufen lassen. Die Testzahl waechst gerade, weil die Ersatzschicht Tests bekommt |
| `Eudora.vcxproj` eigene Fehler | 269 — 74 — 25 — 16 — 4 — **0**. `Eudora.exe` kompiliert vollstaendig, seit `78a9c10` samt Ersatzschicht, und bindet seit `a807b93`. `EudoraRes.vcxproj` uebersetzt ebenfalls vollstaendig, wird im Solution-Bau aber nicht versucht |
| `OpenSSL3/lib` fehlt im Repo | **offen** — `libcrypto.lib` und `libssl.lib` sind von `.gitignore:7` (`Lib/`) erfasst und nicht versioniert (`git ls-files`: null Treffer). Ein frischer Klon endet bei `QCSSL` mit `LNK1104: libssl.lib`. Siehe [BAUEN.md](Eudora71/OpenSSL3/BAUEN.md) |
| OpenSSL 3.5 statt 0.9.7l (2006) | **erledigt** — QCSSL baut gegen 3.5.8 LTS; TLS 1.3 zweimal **gemessen** (Komponententest lokal, dann im Betrieb), ausgehandelt `TLS_AES_256_GCM_SHA384`; 30 angebotene Cipher Suites, keine mit RC4, 3DES oder EXPORT |
| QCSSL gegen echten Mailserver prüfen | **erledigt** — Abruf und Versand laufen. Am 29.08.2026 gegen `pop.gmx.net:995`: `TLSv1.3`, `TLS_AES_256_GCM_SHA384`, 256 Bit, Status `Succeeded`. Da HermesSSL (OpenSSL 1.0.2p) kein TLS 1.3 beherrscht, war es gesichert diese DLL |
| **Hostnamenpruefung greift nicht** | offen und sicherheitsrelevant — gemessen: ein Zertifikat mit falschem `CN` wird mit `SSLSUCCEEDED` und `ErrorCode 0` angenommen. Ein Hinweistext wird durchaus angehaengt ("Destination Host name does not match … But ignoring this error because Certificate is trusted"), er bleibt nur ohne Wirkung. Altbestand von QUALCOMM. Siehe `PORTIERUNG.md` |
| Aktueller `rootcerts.p7b` für das Release | **erledigt** seit `75b60e1` — `Releases/1.0/rootcerts.p7b` mit 121 Zertifikaten, erzeugt von `Releases/1.0/rootcerts-erzeugen.ps1`. Die Altbestaende im Baum sind **zwei verschiedene Dateien** (verschiedene SHA256): `Eudora71/Bin/Release/rootcerts.p7b` mit 19 Zertifikaten (aeltestes gueltig ab 09.11.1994, juengstes ab 22.09.2000), 8 davon heute abgelaufen; `InstallersForEudora/Eudora7.1/Data/win32/rootcerts.p7b` mit 30, juengstes ab 04.03.2004, 17 abgelaufen. QCSSL prueft nur gegen diese Datei, nicht gegen den Windows-Speicher |
| Zeichensatz-Darstellung | **fertig** — der UTF-8-Fall laeuft seit `63f81dc` ueber den Windows-Codepage-Wandler statt ueber die handgepflegte Tabelle; die Tabelle bleibt als Rueckfallweg fuer Post, die `utf-8` behauptet und in Wahrheit CP1252-Bytes traegt. Davor: `XLATE_CHARS` von 27 auf 123 erhoeht (`d03007f`), sieben falsche Zuordnungen berichtigt, Doppelersetzung beseitigt. **33 von 33 Tests gruen** (selbst nachgemessen an `04e93c3` mit `Eudora71/Tests/RunTests.cmd`). Grenzen und Nebenbefunde in `PORTIERUNG.md` |
| Release-Konfiguration | für QCSSL gebaut, übrige Projekte ungetestet |
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
