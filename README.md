# Eudora 7.2

Portierung des Eudora-7.1-Quellcodes auf Visual Studio 2022 — mit dem Ziel, den
Mailclient wieder selbst bauen und weiterentwickeln zu können.

Grundlage ist die Quelltextfreigabe des [Computer History Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/)
(2018, mit Genehmigung von Qualcomm).

## Stand

**16 von 18 Projekten der Solution bauen** mit VS 2022 (Toolset v143, `Debug|x86`).
Nicht dabei sind `OT501` (die Quellen sind nicht freigegeben) und
`Eudora` selbst: `Eudora.vcxproj` **kompiliert seit `3f6877a` vollstaendig**, linkt aber nicht, weil ihm `OTA50D.LIB` aus OT501 fehlt.

Fertig gebaut werden: `QCSSL.dll`, `Imap.dll`, `QCSocket.dll`, `QCUtils.dll`,
`EuLang.dll`, `plstclnt.dll`, dazu elf `.lib` in `Eudora71/Lib/Debug` und OpenSSL.
Von den elf `.lib` sind sieben Importbibliotheken zu den DLLs (kenntlich an der
begleitenden `.exp`); echte statische Bibliotheken sind nur vier: `AccountWizard`,
`DirectoryServicesUI`, `EuImap`, `SearchEngine`.

`Eudora.exe` **uebersetzt vollstaendig** — alle 269 urspruenglichen Compilerfehler sind
behoben (Verlauf 269 — 74 — 25 — 16 — 4 — 0). Der Build endet jetzt an genau einer
Stelle: `LNK1104: OTA50D.LIB kann nicht geoeffnet werden`. Damit ist alles erledigt,
was Portierungsarbeit war; uebrig bleibt allein die fehlende Fremdbibliothek —
siehe [Blocker](#blocker-ot501).

`QCSSL.dll` ist inzwischen gegen **OpenSSL 3.5.8 LTS** gebaut. Der Code setzt eine
Untergrenze (meist TLS 1.2, siehe unten) und **keine Obergrenze**; TLS 1.3 ist damit
nicht ausgeschlossen. Welches Protokoll tatsächlich ausgehandelt wird, ist nicht
nachgemessen.
Als einbaufertiges Paket liegt sie in [Releases/1.0/](Releases/1.0/README.md) — sie
ersetzt in einer bestehenden Eudora-7.1-Installation genau eine Datei. **Gegen einen
echten Mailserver getestet:** Abruf und Versand funktionieren.

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
abgeschaltet. Als Mindestprotokoll setzt `QCSSLContext.cpp` bei sieben der acht
Einstellungen von `m_ProtocolVersion` (0, 1, 2, 4, 5, 6, 7) `TLS1_2_VERSION`; bei
`m_ProtocolVersion == 3` (früher "TLSv1") dagegen `TLS1_VERSION`, also TLS 1.0.
Eine Obergrenze wird an keiner Stelle gesetzt.

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
22 verschiedenen Stingray-Klassen ab, ruft 77 Methoden auf und berührt
39 Quelldateien (`.cpp`).

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

| Thema | Stand |
|---|---|
| OT501-Ersatzschicht | Analyse fertig, Stufenplan steht, Implementierung offen |
| `Eudora.vcxproj` eigene Fehler | 269 — 74 — 25 — 16 — 4 — **0**. `Eudora.exe` kompiliert vollstaendig; es scheitert jetzt allein am Linker, dem `OTA50D.LIB` fehlt |
| OpenSSL 3.5 statt 0.9.7l (2006) | **erledigt** — QCSSL baut gegen 3.5.8 LTS; TLS 1.3 ist möglich, im Feld noch nicht nachgemessen |
| QCSSL gegen echten Mailserver prüfen | **erledigt** — Abruf und Versand laufen (Installation mit HermesSSL); Protokoll noch zu protokollieren |
| Aktueller `rootcerts.p7b` für das Release | offen — Eudoras Speicher ist von 2005, QCSSL prüft nur gegen diese Datei |
| Zeichensatz-Darstellung | **eingebaut** — `XLATE_CHARS` in `utils.cpp` von 27 auf 123 erhöht, alle 123 Einträge der UTF-8-Tabelle belegt (Commit `d03007f`); sichtbar wird das erst mit einer neu gebauten `Eudora.exe` |
| Release-Konfiguration | für QCSSL gebaut, übrige Projekte ungetestet |
| Build-Artefakte im Repo | `.gitignore` greift jetzt; die mitversionierten Altbestände müssen noch aus dem Index |

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
