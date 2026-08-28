# Eudora 7.1 → Visual Studio 2022: Portierungsstand

Stand: 2026-08-28 · Branch `vs2022-portierung-fixes`

## Kurzfassung

**16 von 18 Projekten der Solution bauen.** Es fehlen `OT501` (Stingray Objective
Toolkit; die Quellen sind nicht freigegeben) und `Eudora` selbst — `Eudora.vcxproj`
uebersetzt seit `3f6877a` vollstaendig, linkt aber nicht.

`Eudora.exe` **kompiliert vollstaendig** — alle 269 urspruenglichen Compilerfehler sind
behoben (Verlauf 269 - 74 - 25 - 16 - 4 - 0). Es scheitert jetzt allein am Linker:
`LNK1104: OTA50D.LIB kann nicht geoeffnet werden`. Damit ist alles erledigt, was
Portierungsarbeit war; uebrig bleibt allein die fehlende Fremdbibliothek OT501.
Gemessen mit `-p:BuildProjectReferences=false`, also ohne OT501.

Die vier Quelldateien, deren Header vorlagen, deren Implementierung aber in der
Freigabe fehlte (`TBarBmpCombo.cpp`, `TBarEdit.cpp`, `TBarStatic.cpp`, `spell.cpp`),
sind seit `3f6877a` als Dummys vorhanden.

QCSSL ist auf **OpenSSL 3.5.8 LTS** portiert. Belegt ist: der Code setzt eine
Protokoll-Untergrenze und **keine Obergrenze** (`SSL_CTX_set_max_proto_version()`
kommt in QCSSL nicht vor), TLS 1.3 ist damit nicht ausgeschlossen. Welches Protokoll
tatsächlich ausgehandelt wird, ist **nicht nachgemessen**. Die fertige `QCSSL.dll`
liegt als einbaufertiges Paket in `Releases/1.0/`.

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
— Altbestand. Das `OpenSSL`-Projekt steht noch mit `Build.0` in der Solution und
erzeugt die beiden Libs weiterhin, aber **kein** Projekt linkt sie noch; das
Ergebnisverzeichnis ist in `.gitignore` (`Eudora71/OpenSSL/out32/`). Übrig ist
außerdem ein toter Include-Pfad `..\OpenSSL\inc32` in `QCSocket.vcxproj:60`.
Projekt und Pfad können entfallen.

## Blocker: OT501 (Stingray Objective Toolkit)

Die Freigabe des Computer History Museum enthält von OT501 nur **127 Header**
(`.h`/`.H`) unter `Eudora71/OT501/Include`; das Verzeichnis zählt 130 Einträge, dazu
gehören aber `SECRES.RC`, `SECRES.APS` und der Unterordner `RES`. Von den
186 Quelldateien, die `otlib50.mak` erwartet, liegen **67** bei: zlib (14), JPEG (46),
`treectrl` (1), `shortcut` (4) sowie `secaux.cpp` und `STDAFX.CPP` direkt unter
`OT501/Src`. Die übrigen 119 — der proprietäre Stingray-Code — wurden entfernt.
Dasselbe gilt für die zweite Kopie unter `Sandbox/OT501`.

Eudora leitet an **30 Stellen** von **22 verschiedenen** dieser Klassen ab und ruft
77 Methoden auf; insgesamt referenzieren die Eudora-Quellen 52 verschiedene
`SEC`-Bezeichner (Klassen, Makros, Konstanten; ausgezählt in
[Eudora71/OTShim/INVENTAR.md](Eudora71/OTShim/INVENTAR.md), dessen Abschnitt 1
unvollständig war). Früher stand hier "rund 63 Klassen" — diese Zahl ist durch die
Bestandsaufnahme überholt und wird auch weiter unten nicht mehr benutzt.
Beispiele: (`SECWorkbook`, `SECControlBar`,
`SECCustomToolBar`, `SECMDIFrameWnd`, `SECTab` …). Ohne `ota50d.lib` linkt
`Eudora.exe` nicht.

Eine fertige VC6-`ota50d.lib` hilft **nicht** — sie wäre ABI-inkompatibel zu VS2022
(andere CRT, andere MFC-Version). Die Bibliothek müsste in jedem Fall aus Quellen
mit v143 neu gebaut werden.

Mögliche Wege:

1. Die benutzten Klassen (22 Basisklassen, 30 Ableitungen) gegen die vorhandenen
   Header auf reines MFC nachbauen. Umfang der Vorlage: 32124 Zeilen in allen
   127 Headern, davon 19379 Zeilen in den 89 Headern, die überhaupt eine
   `class SEC…` deklarieren. Die Schnittstelle ist durch die Header vollständig
   definiert — also ein großes, aber wohldefiniertes Projekt.
2. Objective Toolkit 5.0.1 Quellen beschaffen (Rogue Wave / Perforce).
3. `Eudora.exe` zurückstellen und nur die DLLs pflegen.

**Gewählt ist Weg 1.** Die Analyse der vier Klassenfamilien ist abgeschlossen und hat
den Umfang deutlich verkleinert: die 77 Methoden sind nicht 77 Aufgaben. Viele sind
geerbte MFC-Methoden, die Eudora nur qualifiziert aufruft, andere werden nie
aufgerufen. Die Registerkartenleiste ist verzichtbar, `SECStatusBar` erledigt ein
`typedef`. Stufenplan mit Belegen: **[Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md)**.

## Erledigt: OpenSSL 3.5.8 LTS hinter QCSSL

QCSSL hing an **OpenSSL 0.9.7l von 2006** — maximal TLS 1.0. Damit kam Eudora an
keinem aktuellen Mailserver mehr vorbei. Die Umstellung auf **OpenSSL 3.5.8 LTS** ist
abgeschlossen; `QCSSL.dll` setzt keine Protokoll-Obergrenze mehr, TLS 1.3 ist damit
nicht ausgeschlossen. Nachgemessen, welches Protokoll ausgehandelt wird, ist es nicht.

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

SSLv2 und SSLv3 sind damit abgeschaltet. Als Mindestprotokoll setzt
`QCSSLContext.cpp` bei sieben der acht Werte von `m_ProtocolVersion` — 0, 1, 2, 4,
5, 6, 7 — `TLS1_2_VERSION`. Der achte, `m_ProtocolVersion == 3` (früher "TLSv1"),
setzt `TLS1_VERSION`, also TLS 1.0. Eine Obergrenze wird nirgends gesetzt.

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

### Geprueft: die Portierung selbst ist korrekt

Eine Pruefung der vier QCSSL-Commits (`1b6e888`, `ac4f00d`, `9ce1274`, `9e7a880`)
gegen den Zustand davor hat die Umstellung **entlastet**. Belegt korrekt sind:

- `SSL_CTX_set_verify(SSL_VERIFY_PEER, CertificateCallback)` ist unveraendert. Die
  Zertifikatspruefung greift. Selbstsignierte Zertifikate (Fehler 18/19) und
  unbekannte Aussteller (20) werden abgewiesen, weil der `switch` im Callback fuer
  sie keinen `case` hat und `iOK = 0` stehen bleibt.
- Die BIO-Schicht: alle sechs Felder der alten `BIO_METHOD`-Struktur sind in der
  richtigen Zuordnung gesetzt, `BIO_set_data`/`BIO_get_data` konsistent umgestellt.
- Die Umstellung von direktem Strukturzugriff auf `X509_STORE_get_ex_data` und
  `X509_STORE_CTX_get_current_cert`/`get_error` trifft dasselbe Objekt und
  dieselben Indizes.
- Die Reihenfolge beim Abraeumen (`SSL_get_SSL_CTX` vor `SSL_free` vor
  `SSL_CTX_free`) stimmt; das ersatzlos gestrichene `ERR_remove_state(0)` wird
  tatsaechlich nicht gebraucht.

### Offene Schwaechen der Zertifikatspruefung - alle Altbestand

Diese Punkte stammen aus dem Originalcode, nicht aus der Portierung. Sie sind
trotzdem echte Schwaechen:

1. **`qccertificate.cpp:110-112` akzeptiert zwei Fehlerarten.**
   `X509_V_ERR_CERT_UNTRUSTED` (27) und `X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE`
   (21) setzen `iOK = 1`, der Handshake laeuft also weiter. Fehler 21 duerfte unter
   3.x unerreichbar sein, weil vorher Fehler 20 gemeldet wird; Fehler 27 aus
   `check_trust()` ist erreichbar. Empfehlung: beide `case` streichen.
2. **`qccertificate.cpp:157` schreibt in einen fremden Slot.**
   `X509_STORE_CTX_set_ex_data(ctx, 0, ...)` belegt Index 0 des STORE_CTX - genau
   den Slot, in den libssl den `SSL*` legt. Der Wert wird nirgends zurueckgelesen:
   ein toter Schreibzugriff, der fremde Daten ueberschreibt.
3. **Der Namensabgleich ist rein beratend.** Bei Nichtuebereinstimmung wird nur ein
   Hinweistext angehaengt; der Rueckgabewert haengt allein am Handshake-Ergebnis.
   Geprueft wird ausserdem nur der CN, keine SAN-Eintraege - moderne Zertifikate
   fuehren oft gar keinen CN mehr. `X509_check_host` gab es in 0.9.7 noch nicht,
   die Luecke ist also Altbestand.
4. **Kein SNI.** `SSL_set_tlsext_host_name` wird nicht gesetzt, vorher wie nachher.
   Bei Mailservern hinter gemeinsamer IP liefert der Server das Standardzertifikat.

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
   Die Familienanalyse ist fertig, der Stufenplan steht in
   [Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md). Reihenfolge: Stufe 0 (typedef
   für `SECStatusBar`, Stub für `SECTipOfDay`), Stufe 1 (MDI ohne Registerkarten —
   Ziel: ein startendes `Eudora.exe`), dann Andockfamilie, Werkzeugleisten, Bilder.

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
   um den Aufruf versehen: erst rund 20 Stellen, dann 49 weitere in 22 Quelldateien
   (Commit `2fb1566`) — das allein brachte `Eudora.vcxproj` von 74 auf 25 Fehler.
   Heute steht der Compilerfehlerstand bei 0 - Eudora.exe uebersetzt vollstaendig.
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
- `Eudora71/OpenSSL3` — Header und statische Bibliotheken von OpenSSL 3.5.8 LTS
  (`libcrypto.lib`, `libssl.lib`), damit sich QCSSL ohne einen 25-minütigen
  OpenSSL-Lauf übersetzen lässt. Bauweg und Prüfsumme in
  [Eudora71/OpenSSL3/BAUEN.md](Eudora71/OpenSSL3/BAUEN.md).
- `Eudora71/Eudora/utils.cpp` — UTF-8-Übersetzungstabelle von 27 auf 123 Einträge
  erweitert (deutsche Umlaute + Latin-1 U+00A0..U+00FF), Patch aus
  https://github.com/HansWurst81675/Eudora_patches

## Fallstricke für die Weiterarbeit

- **`core.autocrlf`**: repo-lokal auf `false` gesetzt. Die Quellen haben gemischte
  Zeilenenden; mit `autocrlf=true` schreibt Git beim Stagen jede angefasste Datei
  komplett um und der Diff wird unlesbar.
- **`sed` unter Git Bash**: nur mit `-b` (binary) benutzen. Ohne `-b` verschluckt es
  die CR aus CRLF-Zeilen und erzeugt dieselbe Diff-Flut.
- **Zwei Werkzeuge gegen genau diese Schäden** (seit Commit `a7aeb33`, beide in
  `tools/`):
  - `tools/pruefe-bytes.pl` — vergleicht für jede zum Commit vorgemerkte Datei den
    **Index**-Blob gegen den **HEAD**-Blob (nicht die Arbeitskopie, die liegt bei
    manchen Dateien abweichend vor) und bricht den Commit ab, wenn sich die CR-Anzahl
    geändert hat oder Unicode-Ersatzzeichen `U+FFFD` hinzugekommen sind — die Eudora-
    Quellen sind **Latin-1**, nicht UTF-8. Geprüft werden die Endungen `cpp h c hpp
    inl rc idl mak txt md vcxproj filters`. Bewusst überspringen:
    `git commit --no-verify`.
  - `tools/aendere-zeile.pl` — ändert eine einzelne Zeile byte-erhaltend:
    `perl tools/aendere-zeile.pl <datei> <zeilennummer> <alt> <neu>`. Liest und
    schreibt mit `:raw`, ersetzt per `index`/`substr` statt per regulärem Ausdruck
    und bricht selbst ab, wenn sich die CR-Anzahl ändern würde.

  `pruefe-bytes.pl` läuft als **pre-commit-Hook**. Der Hook liegt in `.git/hooks/pre-commit`
  und wird von Git **nicht** mitversioniert — nach einem frischen Klon ist er einmal
  einzurichten:

  ```sh
  printf '#!/bin/sh\nexec perl "$(git rev-parse --show-toplevel)/tools/pruefe-bytes.pl"\n' > .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
  ```

- **Skripte, die Quelldateien umschreiben**: hinterher prüfen, ob sich die Zahl der CR
  geändert hat (CR-Anzahl per `tr` gegen `git show HEAD:<datei>`). Am 28.08.2026 hat
  ein Perl-Skript vier reine LF-Dateien (`statbar.cpp`, `header.cpp`,
  `BossProtector.cpp`, `TridentPreviewView.cpp`) auf CRLF umgestellt und damit 2194
  Scheinänderungen allein in `statbar.cpp` erzeugt. Die Ursache wurde nicht gefunden,
  die Rückwandlung ist gegen `HEAD` verifiziert.
- **Build-Artefakte im Repo**: `.pdb`, `.idb`, `.tlog`, `.sbr` und `Build/`-Ordner sind
  aus dem ersten Import mit eingecheckt und tauchen bei jedem Build als Änderung auf.
  Die `.gitignore` ist inzwischen repariert (jede Zeile hatte ein Leerzeichen am Ende,
  weshalb kein einziges Muster griff) und hält rund 2000 unversionierte Dateien fern
  (2003 gemessen mit `git ls-files -o -i --exclude-standard | wc -l`; die Zahl
  schwankt mit dem Build-Zustand des Arbeitsverzeichnisses). Die
  bereits **getrackten** Altbestände bleiben sichtbar — sie müssten per
  `git rm --cached` aus dem Index.
- **Drei Blocker unabhängig von OT501**, gefunden bei der Familienanalyse:
  `statbar.h:71` deklariert `afx_msg void OnTimer(UINT)`, `ON_WM_TIMER()` verlangt in
  MFC 14 aber `UINT_PTR`; der PNG-Code in `QCGraphics.cpp` greift an vier Stellen
  direkt in die libpng-Strukturen (libpng-1.2-API, seit 1.4 gekapselt): `306`
  (`png_ptr->error_ptr` im Warn-Callback `libpng_warning`), `313` und `316`
  (`png_ptr->error_ptr` bzw. `longjmp(png_ptr->jmpbuf, 1)` im Fehler-Callback
  `libpng_error`) und `354` (`setjmp(png_ptr->jmpbuf)`) — nur die letzte liegt
  wirklich in `QCPng::LoadImage`;
  `QCChildToolBar.cpp:62` bindet `ON_MESSAGE_VOID` an einen Handler mit Signatur
  `LRESULT(WPARAM,LPARAM)`.
- `AccountWizard` meldete gelegentlich `C1041` (PDB-Zugriff) beim Parallelbau — ein
  Race, verschwindet beim erneuten Bauen. Falls es stört: `/FS` bzw. serieller Bau.

## Verworfene Alternativen

- **Fertige OpenSSL-DLLs übernehmen** (z.B. HermSSL 1.0.2p aus dem HermesMail-Projekt):
  reicht nicht, weil zum Kompilieren von QCSSL Header und Import-Libs derselben
  Version nötig sind. Für eine reine *Binär*-Nachrüstung einer bestehenden
  Eudora-Installation ist HermSSL dagegen der etablierte Weg.
- **OpenSSL 1.0.2u statt 3.5**: wäre fast Drop-in für QCSSL, ist aber seit 2019
  End-of-Life und kann kein TLS 1.3.
