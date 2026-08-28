# Eudora 7.1 → Visual Studio 2022: Portierungsstand

Stand: 2026-08-28 · Branch `vs2022-portierung-fixes`

## Kurzfassung

**17 von 18 Projekten der Solution bauen.** Einziger verbleibender Fehler ist `OT501`
(Stingray Objective Toolkit), und der blockiert nur noch `Eudora.exe` selbst.

QCSSL ist auf **OpenSSL 3.5.8 LTS** portiert und handelt **TLS 1.3** aus. Die
fertige `QCSSL.dll` liegt als einbaufertiges Paket in `Releases/1.0/`.

## Umgebung

- Visual Studio 2022 Professional, Toolset v143 (MSVC 14.38.33130)
- Windows SDK 10.0.22621.0
- Konfiguration: `Debug|x86`; für QCSSL zusätzlich `Release|x86` gebaut,
  die übrigen Projekte sind im Release-Zweig ungetestet
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

`Eudora71/OpenSSL3/lib`: `libcrypto.lib`, `libssl.lib` (OpenSSL 3.5.8 LTS, statisch)
— das, wogegen QCSSL heute gebaut wird.

`Eudora71/OpenSSL/out32`: `libeay32.lib`, `ssleay32.lib` (OpenSSL 0.9.7l, statisch)
— Altbestand, wird nicht mehr in QCSSL gelinkt.

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

## Erledigt: OpenSSL 3.5.8 LTS hinter QCSSL

QCSSL hing an **OpenSSL 0.9.7l von 2006** — maximal TLS 1.0. Damit kam Eudora an
keinem aktuellen Mailserver mehr vorbei. Die Umstellung auf **OpenSSL 3.5.8 LTS** ist
abgeschlossen, `QCSSL.dll` handelt jetzt TLS 1.3 aus.

Günstig war die Ausgangslage: der gesamte OpenSSL-Kontakt steckt in **einer Datei**,
`Eudora71/QCSSL/src/QCSSLContext.cpp`, und QCSSL linkt OpenSSL **statisch** — die
gebaute DLL braucht keine `libeay32.dll`/`ssleay32.dll` daneben und ist damit ein
echtes Drop-in für eine bestehende Eudora-Installation.

Umgestellt wurde:

| Stelle | Problem | Lösung |
|---|---|---|
| eigene `BIO_METHOD`-Struktur (`BIO_s_workersocket`) | `BIO_METHOD` ist seit 1.1.0 opak | `BIO_meth_new()` + `BIO_meth_set_*()` |
| `SSLv2_method()` | seit 1.1.0 entfernt | Zweig gestrichen |
| `SSLv3_method()`, `TLSv1_method()` | veraltet | `TLS_client_method()` + `SSL_CTX_set_min_proto_version()` |
| `ERR_remove_state(0)` | seit 1.1.0 entfernt | ersatzlos gestrichen (Thread-Cleanup ist automatisch) |
| `ctx->cert_store` | Struktur opak | `SSL_CTX_get_cert_store()` |
| `qccertificate.cpp` `ctx->ex_data` | Struktur opak | `X509_STORE_CTX_get_ex_data()` |

SSLv2 und SSLv3 sind damit abgeschaltet, Mindestprotokoll ist TLS 1.2.

### Bau von OpenSSL 3.5.8

Header und statische Libs liegen fertig im Repo unter `Eudora71/OpenSSL3`, damit sich
QCSSL ohne einen 25-minütigen OpenSSL-Lauf übersetzen lässt. Der komplette Bauweg
steht in [Eudora71/OpenSSL3/BAUEN.md](Eudora71/OpenSSL3/BAUEN.md).

Zwei Stolperfallen, die Zeit gekostet haben:

- OpenSSL verlangt für die VC-Targets ein **Windows-natives Perl** (Strawberry Perl).
  Das MSYS-Perl aus Git für Windows läuft nicht durch.
- Das CRT-Flag muss **`/MD`** sein, gegen OpenSSLs Vorgabe — sonst kollidiert die
  Laufzeit mit der von MFC.

Konfiguration: `perl Configure VC-WIN32 no-shared no-asm no-tests no-docs no-apps /MD`
Quellen-SHA256: `a8f84a39918ec6415ce765d9b429d313ba97b8143169c172e734b9514464f5b2`

### Erledigt: veraltete Cipher-Liste entfernt

`SetCipherSuites()` in `QCSSLContext.cpp` setzte noch die fest verdrahtete Liste von
2006 — RC4, DES, 3DES, IDEA, RC2 und EXPORT-Suiten. In OpenSSL 3.x sind die meisten
davon gar nicht mehr gebaut; übrig blieben nur AES-CBC-Suiten mit SHA-1. Damit fiel
jedes AEAD-Verfahren weg — und genau darauf bestehen heutige Server bei TLS 1.2.
Die alte Liste hätte den Handshake also nicht abgesichert, sondern verhindert.

Der ursprüngliche Kommentar im Code sagte, der Aufruf sei gleichbedeutend mit den
OpenSSL-Vorgaben. Das galt 2006. Seit Commit `643305d` wird die Liste nicht mehr
gesetzt — damit stimmt der Satz wieder.

TLS 1.3 war davon nie betroffen: dort gilt eine eigene, über
`SSL_CTX_set_ciphersuites()` verwaltete Liste.

`Releases/1.0/QCSSL.dll` wurde daraufhin neu gebaut, die SHA256 in
`QCSSL.dll.sha256` ist aktualisiert.

### Offener Punkt: Wurzelzertifikatsspeicher

QCSSL prüft Serverzertifikate gegen `rootcerts.p7b` im Eudora- oder Programm-
verzeichnis (`QCSSLContext.cpp:53`, geladen in `SetupCertificates()`), **nicht** gegen
den Windows-Zertifikatspeicher. Die Fassung aus Eudora 7.1 ist von 2005.

Nachgemessen am mitgelieferten `InstallersForEudora/Eudora7.1/Data/win32/rootcerts.p7b`:
**30 Zertifikate, das neueste vom 04.03.2004, davon 17 im August 2026 abgelaufen.**
(`certutil -dump` auf die Datei; ausgewertet wurden die Felder "Nicht vor"/"Nicht nach".)

Die Portierung auf OpenSSL 3.x ändert daran nichts. Auf einer unberührten 7.1-
Installation ist deshalb ein Zertifikatsfehler (`IDS_CERTERR_UNKNOWNROOT`) zu erwarten,
obwohl der TLS-Handshake selbst funktioniert. Ob es real dazu kommt, ist **ungeprüft**
und hängt davon ab, welche der 13 noch gültigen Wurzeln der Mailserver verwendet.

Der erfolgreiche Test lief auf einer Installation mit **HermesSSL 7.8 gamma**, die
einen aktuellen Speicher mitbringt — das erklärt, warum die Zertifikatsprüfung dort
durchlief. Es erklärt zugleich, warum im Alltag kein Unterschied spürbar war: Hermes
liefert OpenSSL 1.0.2p und damit bereits TLS 1.2.

Zu tun: einen aktuellen `rootcerts.p7b` erzeugen und dem Release beilegen.

## Nächster Schritt

1. ~~`QCSSL.dll` gegen einen echten Mailserver testen~~ — erledigt, Abruf und Versand
   laufen. Einschränkungen: die Installation hatte HermesSSL samt aktuellem
   Wurzelzertifikatsspeicher. **Ungeklärt**, welcher Build getestet wurde — `643305d`
   hat die DLL um 20:02 neu gebaut; ob davor oder danach kopiert wurde, ist nicht
   festgestellt. Per SHA256 gegen `Releases/1.0/QCSSL.dll.sha256` nachprüfbar. Offen: mit der aktuellen
   DLL wiederholen und über "Last SSL Info" protokollieren, welches Protokoll und
   welche Cipher-Suite ausgehandelt werden.
2. Aktuellen `rootcerts.p7b` erzeugen und dem Release beilegen — sonst ist das Paket
   nur auf Installationen mit HermesSSL vollständig.
3. OT501-Ersatzschicht implementieren — der einzige Blocker für `Eudora.exe`.

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
   const-Überladung, die bei `const char*`-Eingabe auch `const char*` liefert. Kein
   Compilerflag hilft, das ist Überladungsauflösung. Durchgehend mit `const_cast<char *>`
   um den Aufruf versehen: erst rund 20 Stellen, dann 47 weitere in 32 Dateien —
   das allein brachte `Eudora.vcxproj` von 74 auf 25 Fehler.
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
