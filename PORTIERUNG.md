# Eudora 7.1 → Visual Studio 2022: Portierungsstand

Stand: 2026-08-28 · Branch `vs2022-portierung-fixes`

## Kurzfassung

**17 von 18 Projekten der Solution bauen.** Einziger verbleibender Fehler ist `OT501`
(Stingray Objective Toolkit), und der blockiert nur noch `Eudora.exe` selbst.

## Umgebung

- Visual Studio 2022 Professional, Toolset v143 (MSVC 14.38.33130)
- Windows SDK 10.0.22621.0
- Konfiguration: `Debug|x86` (Release ist noch ungetestet)
- Die IDE wird nicht gebraucht — gebaut wird mit MSBuild von der Kommandozeile:

```
"C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" Eudora71\Eudora.sln -p:Configuration=Debug -p:Platform=x86 -m -v:m -clp:ErrorsOnly;Summary
```

Ein voller Durchlauf dauert ca. 1–4 Minuten (OpenSSL beim ersten Mal deutlich länger).

## Was gebaut wird

`Eudora71/Bin/Debug`: `QCSSL.dll`, `Imap.dll`, `QCSocket.dll`, `QCUtils.dll`,
`EuLang.dll`, `plstclnt.dll`

`Eudora71/Lib/Debug`: `AccountWizard.lib`, `DirectoryServicesUI.lib`, `EuImap.lib`,
`EuLang.lib`, `Imap.lib`, `OEImport.lib`, `OLImport.lib`, `QCSSL.lib`, `QCSocket.lib`,
`QCUtils.lib`, `SearchEngine.lib`

`Eudora71/OpenSSL/out32`: `libeay32.lib`, `ssleay32.lib` (OpenSSL 0.9.7l, statisch)

## Blocker: OT501 (Stingray Objective Toolkit)

Die Freigabe des Computer History Museum enthält von OT501 nur die **130 Header**
unter `Eudora71/OT501/Include`. Von den 186 Quelldateien, die `otlib50.mak` erwartet,
liegen nur zlib, JPEG, `treectrl` und `shortcut` bei — der proprietäre Stingray-Code
wurde entfernt. Dasselbe gilt für die zweite Kopie unter `Sandbox/OT501`.

Eudora benutzt rund **63 dieser Klassen** (`SECWorkbook`, `SECControlBar`,
`SECCustomToolBar`, `SECMDIFrameWnd`, `SECTab` …). Ohne `ota50d.lib` linkt
`Eudora.exe` nicht.

Eine fertige VC6-`ota50d.lib` hilft **nicht** — sie wäre ABI-inkompatibel zu VS2022
(andere CRT, andere MFC-Version). Die Bibliothek müsste in jedem Fall aus Quellen
mit v143 neu gebaut werden.

Mögliche Wege:

1. Die ~63 benutzten Klassen gegen die vorhandenen Header (14k Zeilen Deklarationen)
   auf reines MFC nachbauen. Die Schnittstelle ist durch die Header vollständig
   definiert — also ein großes, aber wohldefiniertes Projekt.
2. Objective Toolkit 5.0.1 Quellen beschaffen (Rogue Wave / Perforce).
3. `Eudora.exe` zurückstellen und nur die DLLs pflegen (aktuell gewählter Weg).

## Nächster Schritt: OpenSSL 3.5 LTS hinter QCSSL

Aktuell hängt an QCSSL **OpenSSL 0.9.7l von 2006** — maximal TLS 1.0. Damit kommt
Eudora an keinem aktuellen Mailserver mehr vorbei.

Günstige Ausgangslage:

- Der gesamte OpenSSL-Kontakt steckt in **einer Datei**: `Eudora71/QCSSL/src/QCSSLContext.cpp`.
- QCSSL linkt OpenSSL **statisch** — die gebaute `QCSSL.dll` hat keine Abhängigkeit
  auf `libeay32.dll`/`ssleay32.dll` und ist damit ein echtes Drop-in für eine
  bestehende Eudora-Installation (dann aber als *Release*-Build).
- Nur drei Stellen greifen direkt auf OpenSSL-Interna zu:
  `QCSSLContext.cpp:780` (`ctx->cert_store`), `qccertificate.cpp:43` und `:55` (`ctx->ex_data`).

Zu ändern für 3.x:

| Stelle | Problem | Lösung |
|---|---|---|
| `QCSSLContext.cpp:305–307` | eigene `BIO_METHOD`-Struktur (`BIO_s_workersocket`) | `BIO_METHOD` ist seit 1.1.0 opak → `BIO_meth_new()` + `BIO_meth_set_*()` |
| `QCSSLContext.cpp:556` | `SSLv2_method()` | seit 1.1.0 entfernt → Zweig streichen |
| `QCSSLContext.cpp:547/550` | `SSLv3_method()`, `TLSv1_method()` | vorhanden, aber meist wegkompiliert → auf `TLS_client_method()` + `SSL_CTX_set_min_proto_version()` umstellen |
| `QCSSLContext.cpp:873` | `ERR_remove_state(0)` | seit 1.1.0 entfernt → ersatzlos streichen (Thread-Cleanup ist jetzt automatisch) |
| `QCSSLContext.cpp:780` | `ctx->cert_store` | `SSL_CTX_get_cert_store()` |
| `qccertificate.cpp:43/55` | `ctx->ex_data` | `X509_STORE_CTX_get_ex_data()` |

Geschätzt 60–100 geänderte Zeilen.

### Offener Punkt beim OpenSSL-Bau

Quellen sind geprüft vorhanden (SHA256 gegen die Veröffentlichung abgeglichen):
`openssl-3.5.8.tar.gz` → `a8f84a39918ec6415ce765d9b429d313ba97b8143169c172e734b9514464f5b2`

`perl Configure VC-WIN32 no-shared no-asm no-tests no-docs` mit dem MSYS-Perl aus
Git für Windows läuft **nicht durch** (>10 min ohne `configdata.pm`). OpenSSL verlangt
für die VC-Targets ein Windows-natives Perl.

Vor dem Weitermachen zu installieren:

- **Strawberry Perl** (https://strawberryperl.com) — zwingend
- **NASM** — nur wenn ohne `no-asm` gebaut werden soll (schnellere Krypto)

Alternative, falls das zu umständlich ist: ein fertiges Win32-x86-Paket mit Headern
und statischen Libs (slproweb "Win32 OpenSSL", FireDaemon). DLLs allein reichen
**nicht** — zum Kompilieren von QCSSL braucht es Header und Libs derselben Version.

Danach: `Eudora71/QCSSL/QCSSL.vcxproj` von `..\OpenSSL\inc32` / `..\OpenSSL\out32`
auf das neue Verzeichnis umstellen und `libeay32.lib;ssleay32.lib` durch
`libssl.lib;libcrypto.lib` ersetzen.

## Angewandte Korrekturen (Kategorien)

Alle Änderungen sind einzeln in den Commits von `vs2022-portierung-fixes` dokumentiert.

1. **Deklarationen ohne Rückgabetyp** (default-int, in C++ nicht mehr erlaubt) —
   `LNG_GetLanguageInfo`, `CDynamicMenu::OnInitMenuPopup`, `CSortedStringListMT::operator=`,
   `CAttacher/CSpecial::GetIcon`, `IsInYerFace`, `adproc`, `get_entry_info`,
   `bIteratingFiles`, `bitno`
2. **Entfernte Header** — `<xstddef>` (12 Dateien) → `<functional>`; Extended-MAPI-Header
   ergänzt (siehe unten)
3. **Alte for-Scope-Regeln** — Schleifenzähler, die nach der Schleife weiterbenutzt
   wurden (`oemh`, `pszEnd`, `lNumRead`, `nSearch`, `i`), vorgezogen bzw. lokalisiert
4. **`const char*`-Rückgaben** — `strchr`/`strrchr`/`strstr` haben in C++ eine
   const-Überladung; rund 20 Stellen mit `const_cast` versehen
5. **STL-Modernisierung** — `std::auto_ptr` → `std::unique_ptr<char[]>`;
   Komparator-`operator()` const (std::set); Iteratoren sind keine Zeiger mehr
   (`= NULL` / `!= NULL` ersetzt, u.a. durch `m_bIteratorValid` in `searchutil`)
6. **MFC-`const`-Overloads** — `CObList::GetHead() const` liefert kein lvalue mehr,
   deshalb geben die const-Varianten in `summary.h` jetzt by value zurück
7. **CRT/Winsock-Kollisionen** — eigene `ntohl`/`htons` in `krbv4.cpp` nach `krbv4_*`
   umbenannt; `tzname`/`daylight` → `_tzname`/`_daylight`; `localtime` braucht `time_t`
8. **Projekteinstellungen** — `GSSupport/sec*.c` (VC6-Kopie der `/GS`-Cookie-Runtime)
   in allen 6 Projekten auf `ExcludedFromBuild`; `ImageHasSafeExceptionHandlers=false`
   für QCSSL (OpenSSLs x86-Assembler hat keine SEH-Tabelle); `/WX` aus
   `OpenSSL/ms/nt.mak` entfernt

## Fremdbestandteile im Repo

- `Eudora71/MAPI/include` — Extended-MAPI-Header aus
  https://github.com/microsoft/MAPIStubLibrary (MIT, Lizenz liegt bei).
  Nötig, weil `mapix.h`/`mapiutil.h` seit dem Windows-8-SDK nicht mehr im Windows SDK
  sind. Eingebunden in `Eudora`, `AccountWizard`, `OLImport`.
- `Eudora71/Eudora/utils.cpp` — UTF-8-Übersetzungstabelle von 27 auf 123 Einträge
  erweitert (deutsche Umlaute + Latin-1 U+00A0..U+00FF), Patch aus
  https://github.com/HansWurst81675/Eudora_patches

## Fallstricke für die Weiterarbeit

- **`core.autocrlf`**: repo-lokal auf `false` gesetzt. Die Quellen haben gemischte
  Zeilenenden; mit `autocrlf=true` schreibt Git beim Stagen jede angefasste Datei
  komplett um und der Diff wird unlesbar.
- **`sed` unter Git Bash**: nur mit `-b` (binary) benutzen. Ohne `-b` verschluckt es
  die CR aus CRLF-Zeilen und erzeugt dieselbe Diff-Flut.
- **Build-Artefakte im Repo**: `.pdb`, `.idb`, `.tlog`, `.sbr` und `Build/`-Ordner sind
  aus dem ersten Import mit eingecheckt und tauchen bei jedem Build als Änderung auf.
  Sollte man aufräumen und in `.gitignore` aufnehmen.
- `AccountWizard` meldete gelegentlich `C1041` (PDB-Zugriff) beim Parallelbau — ein
  Race, verschwindet beim erneuten Bauen. Falls es stört: `/FS` bzw. serieller Bau.

## Verworfene Alternativen

- **Fertige OpenSSL-DLLs übernehmen** (z.B. HermSSL 1.0.2p aus dem HermesMail-Projekt):
  reicht nicht, weil zum Kompilieren von QCSSL Header und Import-Libs derselben
  Version nötig sind. Für eine reine *Binär*-Nachrüstung einer bestehenden
  Eudora-Installation ist HermSSL dagegen der etablierte Weg.
- **OpenSSL 1.0.2u statt 3.5**: wäre fast Drop-in für QCSSL, ist aber seit 2019
  End-of-Life und kann kein TLS 1.3.
