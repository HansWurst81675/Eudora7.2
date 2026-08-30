# Eudora 7.2

Portierung des Eudora-7.1-Quellcodes auf Visual Studio 2022 — mit dem Ziel, den
Mailclient wieder selbst bauen und weiterentwickeln zu können.

Grundlage ist die Quelltextfreigabe des [Computer History Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/)
(2018, mit Genehmigung von Qualcomm).

## Stand

> **Gemessen an Commit `2d68555` am 30.08.2026**, `Debug|x86`, Toolset v143
> (MSVC 14.38.33130). An diesem Baum arbeiten mehrere Agenten gleichzeitig; wer
> den Stand pruefen will, misst neu und nennt seinen eigenen Bezugscommit.
>
> | Messung | Ergebnis |
> |---|---|
> | Solution-Bau | **3 Fehler**, alle aus `OT501` (zweimal `NMAKE U1073`, einmal `MSB3073`) |
> | fertige Projekte | **15 von 18** |
> | `Eudora.vcxproj` einzeln | uebersetzt **vollstaendig**; `LNK1120: 1 nicht aufgeloestes Externes` |
>
> **Die OT501-Ersatzschicht ist vollstaendig eingehaengt** (`e50a89c`), und seit
> `78a9c10` uebersetzt `Eudora` fehlerfrei. Von den Stingray-Symbolen ist keines
> mehr offen. Das eine verbliebene Symbol ist `__imp___iob`, angefordert von der
> **vorgefertigten `libpng.lib`** (`pngerror.obj`, `pngrutil.obj`) — eine
> VC6-Binaerdatei aus dem Altbestand, die gegen eine CRT von damals gebaut wurde.
>
> Gemessen wurde gegen die leere Attrappe `Eudora71/Lib/Debug/OTA50D.LIB`; sie
> muss weg, bevor daraus ein echtes Ergebnis wird.
>
> Die frueher genannten Symbolzahlen (1088 / 651 / rund 299) stammen aus einem
> Zustand vor dem vollstaendigen Einhaengen und sind heute **nicht
> reproduzierbar**.

Nicht fertig werden drei Projekte:

- `OT501` — die Stingray-Quellen sind nicht freigegeben, das Projekt bricht mit
  `NMAKE U1073` ab.
- `Eudora` und `EudoraRes` — beide haben einen Projektverweis auf `OT501`
  (`Eudora.vcxproj:1013`, `EudoraRes.vcxproj:351`). Im Solution-Bau werden sie
  deshalb gar nicht erst versucht. Sie tauchen in der Fehlerliste **nicht** auf;
  fertig werden sie trotzdem nicht.

Ein voller Solution-Bau meldet daher nur **3 Fehler, alle aus `OT501`**
(zweimal `NMAKE U1073`, einmal `MSB3073`). Das ist keine Auskunft ueber `Eudora`.

Einzeln gemessen mit `-p:BuildProjectReferences=false` uebersetzen `Eudora` und
`EudoraRes` **vollstaendig**. Fuer `Eudora` sind damit alle 269 urspruenglichen
Compilerfehler behoben (Verlauf 269 — 74 — 25 — 16 — 4 — 0, null seit `3f6877a`),
und seit `78a9c10` uebersetzt die Ersatzschicht fehlerfrei mit.

Ohne die Attrappe endet der Link mit `LNK1104: OTA50D.LIB kann nicht geoeffnet
werden`; mit ihr laeuft er durch bis zu den ungeloesten Symbolen — an `2d68555`
noch genau eines, siehe oben. Der Verlauf mit Bezugscommits steht in
[Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md), Abschnitt "Der Weg zum Linken".

Fertig gebaut werden von den 15:

| Ergebnis | Ort |
|---|---|
| `QCSSL.dll`, `Imap.dll`, `QCSocket.dll`, `QCUtils.dll`, `EuLang.dll`, `plstclnt.dll` | `Eudora71/Bin/Debug` |
| `NSImport.eif`, `OEImport.eif`, `OLImport.eif` (Importer-Plugins, DLLs mit eigener Endung) | `Eudora71/Bin/Debug` |
| `EudoraOldIcons.epi` (Icon-Plugin, ebenfalls eine DLL) | `Eudora71/EudoraOldIcons/Debug` |
| elf `.lib` | `Eudora71/Lib/Debug` |
| `libeay32.lib`, `ssleay32.lib` (Projekt `OpenSSL`, Altbestand) | `Eudora71/OpenSSL/out32` |

Von den elf `.lib` sind sieben Importbibliotheken zu den DLLs (kenntlich an der
begleitenden `.exp`); echte statische Bibliotheken sind nur vier: `AccountWizard`,
`DirectoryServicesUI`, `EuImap`, `SearchEngine`. Das Verzeichnis `Lib/Debug`
enthaelt darueber hinaus sechs vorgefertigte Fremdbibliotheken, die kein Projekt
der Solution erzeugt (`EuMemMgr`, `Paige32d`, `SSCEWD32`, `Uuid`, `libpng`,
`zlib`) — insgesamt liegen dort also 17 `.lib`.

`QCSSL.dll` ist inzwischen gegen **OpenSSL 3.5.8 LTS** gebaut. **TLS 1.3 ist
zweimal nachgemessen:** im Komponententest gegen einen lokalen Server
(`Eudora71/Tests/QCSSL`, Protokoll in `work/ergebnis_qcssl_lokal.txt`) und am
29.08.2026 im Betrieb gegen `pop.gmx.net:995`, abgelesen in Eudoras eigenem Dialog
"SSL Connection Information Manager": `TLSv1.3`, `TLS_AES_256_GCM_SHA384`, 256 Bit,
Status `Succeeded`. Dass es dabei diese DLL war und nicht HermesSSL, ist gesichert —
HermesSSL 7.8 gamma setzt auf OpenSSL 1.0.2p auf, das TLS 1.3 gar nicht beherrscht.
Als einbaufertiges Paket liegt die DLL in [Releases/1.0/](Releases/1.0/README.md) —
sie ersetzt in einer bestehenden Eudora-7.1-Installation genau eine Datei. Abruf und
Versand funktionieren.

```
"C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" Eudora71\Eudora.sln -p:Configuration=Debug -p:Platform=x86 -m
```

Die Visual-Studio-IDE wird zum Bauen nicht gebraucht, nur die Installation
(MSVC v143, MFC/ATL, Windows SDK).

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

## Blocker: OT501

`Eudora.exe` linkt gegen **Stingray Objective Toolkit 5.0.1**, eine kommerzielle
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

Stand der Tabelle: Commit `2d68555`. An mehreren Zeilen wird gerade parallel
gearbeitet, sie veraltet also schnell — im Zweifel neu messen.

| Thema | Stand |
|---|---|
| OT501-Ersatzschicht | **geschrieben und vollstaendig eingehaengt** (`e50a89c`). `Eudora71/OTShim/` umfasst an `2d68555` **17828 Zeilen** in 11 Dateien (`wc -l`). Ueber `OTShimAll.h` eingebunden und mit ihren `.cpp` in `Eudora.vcxproj:217` aufgenommen sind alle fuenf Teile: Stufe 0-2 (`OTShim.*`, 5494), Stufe 3 (`OTShim_Werkzeugleiste.*`, 6083), Stufe 4 (`OTShim_Bild.*`, 2358), Registerkarten (`OTShim_Reiter.*`, 2925) und `SECDateTimeCtrl`/Palette (`OTShim_Palette.*`, 890). Dazu `OT501/Src/secaux.cpp` direkt im Projekt |
| Stingray-Symbole beim Binden | **keines mehr offen** (gemessen an `2d68555`). Verlauf 1088 (651 verschiedene) — rund 299 — 8 — 1; das letzte Symbol ist kein Stingray. Bezugscommits in `PLAN.md`, Abschnitt „Der Weg zum Linken" |
| `__imp___iob` aus `libpng.lib` | **offen** — das einzige verbliebene ungeloeste Symbol beim Binden von `Eudora.exe`. Angefordert von der vorgefertigten VC6-`libpng.lib` (`pngerror.obj`, `pngrutil.obj`), nicht von Stingray |
| Attrappe `Lib/Debug/OTA50D.LIB` | **muss weg**, sobald gebunden wird — sonst linkt Eudora gegen eine leere Bibliothek und niemand merkt es. Absichtlich nicht eingecheckt |
| Erster Start von `Eudora.exe` | offen — welche Laufzeitdateien danebenliegen muessen und was noch fehlt (u. a. `EudoraRes.dll`), steht in [STARTUMGEBUNG.md](STARTUMGEBUNG.md) |
| Unit- und Komponententests | **vorhanden** — `Eudora71/Tests` (`RunTests.cmd`) und `Eudora71/Tests/QCSSL` (`bauen.bat`, `messen.ps1`). Nach Vorgabe zu jedem Commit laufen lassen. Die Testzahl waechst gerade, weil die Ersatzschicht Tests bekommt |
| `Eudora.vcxproj` eigene Fehler | 269 — 74 — 25 — 16 — 4 — **0**. `Eudora.exe` kompiliert vollstaendig, seit `78a9c10` samt Ersatzschicht; es scheitert jetzt allein am Binden. `EudoraRes.vcxproj` steht genauso da |
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
