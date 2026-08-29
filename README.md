# Eudora 7.2

Portierung des Eudora-7.1-Quellcodes auf Visual Studio 2022 — mit dem Ziel, den
Mailclient wieder selbst bauen und weiterentwickeln zu können.

Grundlage ist die Quelltextfreigabe des [Computer History Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/)
(2018, mit Genehmigung von Qualcomm).

## Stand

Die Zahlen in diesem Abschnitt sind an Commit `fd9a235` gemessen, Konfiguration
`Debug|x86`, Toolset v143 (MSVC 14.38.33130). Am Baum wird gerade weitergearbeitet;
wer den Stand pruefen will, misst neu.

**15 der 18 Projekte der Solution werden fertig.** Drei nicht:

- `OT501` — die Stingray-Quellen sind nicht freigegeben, das Projekt bricht mit
  `NMAKE U1073` ab.
- `Eudora` und `EudoraRes` — beide haben einen Projektverweis auf `OT501`
  (`Eudora.vcxproj:1013`, `EudoraRes.vcxproj:351`). Im Solution-Bau werden sie
  deshalb gar nicht erst versucht. Sie tauchen in der Fehlerliste **nicht** auf;
  fertig werden sie trotzdem nicht.

Ein voller Solution-Bau meldet daher nur **3 Fehler, alle aus `OT501`**
(zweimal `NMAKE U1073`, einmal `MSB3073`). Das ist keine Auskunft ueber `Eudora`.

Einzeln gemessen mit `-p:BuildProjectReferences=false` uebersetzen `Eudora` und
`EudoraRes` **vollstaendig** und scheitern beide an genau einer Stelle:
`LNK1104: OTA50D.LIB kann nicht geoeffnet werden` — je 1 Fehler. Fuer `Eudora` sind
damit alle 269 urspruenglichen Compilerfehler behoben (Verlauf 269 — 74 — 25 — 16 —
4 — 0, null seit `3f6877a`). Uebrig bleibt allein die fehlende Fremdbibliothek —
siehe [Blocker](#blocker-ot501).

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
abgeschaltet. Als Mindestprotokoll setzt `QCSSLContext.cpp:561-583` bei sieben der acht
Einstellungen von `m_ProtocolVersion` (0, 1, 2, 4, 5, 6, 7) `TLS1_2_VERSION`; bei
`m_ProtocolVersion == 3` (früher "TLSv1") dagegen `TLS1_VERSION`, also TLS 1.0.
Eine Obergrenze wird an keiner Stelle gesetzt — `SSL_CTX_set_max_proto_version()`
kommt in QCSSL nicht vor.

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

Zwei Funde verkürzen den Weg besonders:

- **Die Registerkartenleiste ist verzichtbar.** Sie ist eine zur Laufzeit umschaltbare
  Anwendereinstellung (`mainfrm.cpp:1025`), jede Auswertung steht hinter
  `m_bWorkbookMode`. Ein schlichter `CMDIFrameWnd` reicht für ein startendes
  `Eudora.exe` — damit entfällt der komplette GDI-Zeichencode, der teuerste Posten.
- **`SECStatusBar` ist eine 1:1-Kopie von MFCs `CStatusBar`** mit anderer Basisklasse.
  Ein `typedef` erledigt alle 11 Methoden.

Bestandsaufnahme: [Eudora71/OTShim/INVENTAR.md](Eudora71/OTShim/INVENTAR.md) —
Umsetzungsplan mit Stufen, Belegen und Inventarkorrekturen:
**[Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md)**

## Offene Themen

Stand der Tabelle: Commit `fd9a235`. An mehreren Zeilen wird gerade parallel
gearbeitet, sie veraltet also schnell — im Zweifel neu messen.

| Thema | Stand |
|---|---|
| OT501-Ersatzschicht | **Stufe 0 und 1 fertig** (`Eudora71/OTShim/`, bei `fd9a235` 2272 Zeilen: 987 in `OTShim.h`, 1285 in `OTShim.cpp`; syntaktisch geprueft, noch nicht eingehaengt). Offen: Stufe 2 (Andockleisten mit prozentualen Zeilenbreiten und Splittern) — danach sollte `Eudora.exe` linken |
| OTShim einhaengen | offen — `OTShim.h` in `stdafx.h` (dort kommt bisher `secall.h` herein), `OTShim.cpp` ins Projekt mit `/Y-` (kein vorkompilierter Header) |
| Unit- und Komponententests | **vorhanden** — `Eudora71/Tests` (`RunTests.cmd`) und `Eudora71/Tests/QCSSL` (`bauen.bat`, `messen.ps1`). Nach Vorgabe zu jedem Commit laufen lassen |
| `Eudora.vcxproj` eigene Fehler | 269 — 74 — 25 — 16 — 4 — **0**. `Eudora.exe` kompiliert vollstaendig; es scheitert jetzt allein am Linker, dem `OTA50D.LIB` fehlt. `EudoraRes.vcxproj` steht genauso da |
| OpenSSL 3.5 statt 0.9.7l (2006) | **erledigt** — QCSSL baut gegen 3.5.8 LTS; TLS 1.3 zweimal **gemessen** (Komponententest lokal, dann im Betrieb), ausgehandelt `TLS_AES_256_GCM_SHA384`; 30 angebotene Cipher Suites, keine mit RC4, 3DES oder EXPORT |
| QCSSL gegen echten Mailserver prüfen | **erledigt** — Abruf und Versand laufen. Am 29.08.2026 gegen `pop.gmx.net:995`: `TLSv1.3`, `TLS_AES_256_GCM_SHA384`, 256 Bit, Status `Succeeded`. Da HermesSSL (OpenSSL 1.0.2p) kein TLS 1.3 beherrscht, war es gesichert diese DLL |
| **Hostnamenpruefung greift nicht** | offen und sicherheitsrelevant — gemessen: ein Zertifikat mit falschem `CN` wird mit `SSLSUCCEEDED` und `ErrorCode 0` angenommen. Ein Hinweistext wird durchaus angehaengt ("Destination Host name does not match … But ignoring this error because Certificate is trusted"), er bleibt nur ohne Wirkung. Altbestand von QUALCOMM. Siehe `PORTIERUNG.md` |
| Aktueller `rootcerts.p7b` für das Release | **erledigt** seit `75b60e1` — `Releases/1.0/rootcerts.p7b` mit 121 Zertifikaten, erzeugt von `Releases/1.0/rootcerts-erzeugen.ps1`. Die Altbestaende im Baum sind **zwei verschiedene Dateien** (verschiedene SHA256): `Eudora71/Bin/Release/rootcerts.p7b` mit 19 Zertifikaten (aeltestes gueltig ab 09.11.1994, juengstes ab 22.09.2000), 8 davon heute abgelaufen; `InstallersForEudora/Eudora7.1/Data/win32/rootcerts.p7b` mit 30, juengstes ab 04.03.2004, 17 abgelaufen. QCSSL prueft nur gegen diese Datei, nicht gegen den Windows-Speicher |
| Zeichensatz-Darstellung | **fertig** — `XLATE_CHARS` von 27 auf 123 erhoeht (`d03007f`). Die beiden von den Unit-Tests nachgewiesenen Fehler sind behoben: sieben falsche Zuordnungen berichtigt, `ISOTranslate` laeuft jetzt in einem Durchgang statt in 123 Ersetzungslaeufen. 23 von 23 Tests gruen. Siehe `PORTIERUNG.md` |
| Release-Konfiguration | für QCSSL gebaut, übrige Projekte ungetestet |
| Build-Artefakte im Repo | **erledigt** seit `e4a0fae` — `.gitignore` greift, 108 Dateien sind aus dem Index. Getrackt sind noch 20 `.pdb`, die zu vorgefertigten Fremd-DLLs unter `Bin/Debug` und `Bin/Release` gehoeren und nicht aus diesem Bau stammen |

## Ergänzungen gegenüber der CHM-Freigabe

- `Eudora71/MAPI/include` — Extended-MAPI-Header aus
  [microsoft/MAPIStubLibrary](https://github.com/microsoft/MAPIStubLibrary) (MIT).
  Nötig, weil `mapix.h` und `mapiutil.h` seit dem Windows-8-SDK nicht mehr
  im Windows SDK enthalten sind.
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
  [HansWurst81675/Eudora_patches](https://github.com/HansWurst81675/Eudora_patches)

## Verwandte Projekte

- [HermesMail](https://sourceforge.net/projects/hermesmail/) — rüstet ein
  installiertes Eudora 7.1 binär mit neueren TLS-DLLs nach (OpenSSL 1.0.2)
- [Eudora_patches](https://github.com/HansWurst81675/Eudora_patches) — Binärpatches
  für die Umlautdarstellung

## Lizenz

Der Eudora-Quellcode steht unter der BSD-artigen Lizenz der Freigabe von 2018
(siehe Kopf der Quelldateien). Fremdbestandteile behalten ihre eigenen Lizenzen.
