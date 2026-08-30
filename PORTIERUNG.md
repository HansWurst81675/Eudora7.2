# Eudora 7.1 → Visual Studio 2022: Portierungsstand

Stand: 2026-08-30 · Branch `eudora-exe-linkt` (der frühere `vs2022-portierung-fixes`
ist mit `22a6d77` nach `main` gemergt) · Messwerte an Commit `2d68555`

An diesem Baum arbeiten mehrere Agenten gleichzeitig. Jede Zahl hier nennt ihren
Bezugscommit; wer sie weiterverwendet, misst nach.

## Kurzfassung

> **Gemessen an `2d68555`, 30.08.2026, `Debug|x86`, Toolset v143.**
> Ein voller Solution-Bau meldet **3 Fehler, alle aus `OT501`** (zweimal
> `NMAKE U1073`, einmal `MSB3073`); **15 der 18 Projekte werden fertig.**
> `Eudora.vcxproj` einzeln gebaut (`-p:BuildProjectReferences=false`)
> **übersetzt vollständig** und endet im Linker mit
> `LNK1120: 1 nicht aufgelöstes Externes`.
>
> Dieses eine Symbol ist `__imp___iob`, angefordert von der **vorgefertigten
> `libpng.lib`** (`pngerror.obj`, `pngrutil.obj`) — eine VC6-Binärdatei aus dem
> Altbestand, die gegen eine CRT von damals gebaut wurde. Mit Stingray hat es
> nichts zu tun: **von der OT501-Ersatzschicht her ist `Eudora.exe` gebunden.**
>
> Gemessen wurde gegen die leere Attrappe `Eudora71/Lib/Debug/OTA50D.LIB`;
> sie muss weg, bevor daraus ein echtes Ergebnis wird.

**Sobald `libpng` gelöst ist, werden 15 der 18 Projekte fertig.** Drei nicht: `OT501` (Stingray
Objective Toolkit; die Quellen sind nicht freigegeben) sowie `Eudora` und
`EudoraRes`. Die beiden letzten haben je einen Projektverweis auf `OT501`
(`Eudora.vcxproj:1013`, `EudoraRes.vcxproj:351`) und werden im Solution-Bau deshalb
gar nicht erst versucht — sie erscheinen nicht in der Fehlerliste, fertig werden sie
trotzdem nicht. Ein voller Solution-Bau meldet 3 Fehler, alle aus `OT501`: zweimal
`NMAKE U1073` (`Blackbox.cpp`, `OTA50D.lib`) und einmal `MSB3073`. Früher stand hier
"16 von 18" — `EudoraRes` war dabei übersehen.

Einzeln gemessen mit `-p:BuildProjectReferences=false` uebersetzen `Eudora` und
`EudoraRes` **vollstaendig**. Fuer `Eudora` sind damit alle 269 urspruenglichen
Compilerfehler behoben (Verlauf 269 - 74 - 25 - 16 - 4 - 0, null seit `3f6877a`),
und seit `78a9c10` uebersetzt auch die Ersatzschicht selbst fehlerfrei mit.

Ohne die Attrappe endet der Link mit `LNK1104: OTA50D.LIB kann nicht geoeffnet
werden`; mit ihr laeuft er durch bis zu den ungeloesten Symbolen. Deren Zahl ist
in dieser Sitzung von 1088 (651 verschiedene) auf **1** gefallen — der Verlauf
mit Bezugscommits steht in
[Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md), Abschnitt "Der Weg zum Linken".

Die vier Quelldateien, deren Header vorlagen, deren Implementierung aber in der
Freigabe fehlte (`TBarBmpCombo.cpp`, `TBarEdit.cpp`, `TBarStatic.cpp`, `spell.cpp`),
sind seit `3f6877a` als Dummys vorhanden.

QCSSL ist auf **OpenSSL 3.5.8 LTS** portiert. Der Code setzt eine
Protokoll-Untergrenze und **keine Obergrenze** (`SSL_CTX_set_max_proto_version()`
kommt in QCSSL nicht vor). **TLS 1.3 ist nachgemessen**, und zwar zweimal: im
Komponententest gegen einen lokalen Server
(`Eudora71/Tests/QCSSL/work/ergebnis_qcssl_lokal.txt`) und am 29.08.2026 im Betrieb
gegen `pop.gmx.net:995`, abgelesen in Eudoras Dialog "SSL Connection Information
Manager" — `TLSv1.3`, `TLS_AES_256_GCM_SHA384`, 256 Bit, Status `Succeeded`. Die
fertige `QCSSL.dll` liegt als einbaufertiges Paket in `Releases/1.0/`.

## Umgebung

- Visual Studio 2022 Professional, Toolset v143. Die installierte Fassung ist
  MSVC **14.38.33130** (einziger Ordner unter
  `VC\Tools\MSVC\`); die `.vcxproj` legen nur `<PlatformToolset>v143` fest.
- Windows SDK **10.0.22621.0**. Auch das steht in keiner `.vcxproj` — es ist die
  Fassung, die MSBuild hier aufloest, abgelesen an den Include-Pfaden im Build-Log.
- Konfiguration: `Debug|x86`; für QCSSL zusätzlich `Release|x86` gebaut,
  die übrigen Projekte sind im Release-Zweig ungetestet
- Die IDE wird nicht gebraucht — gebaut wird mit MSBuild von der Kommandozeile:

```
"C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" Eudora71\Eudora.sln -p:Configuration=Debug -p:Platform=x86 -m -v:m -clp:ErrorsOnly;Summary
```

Ein voller Durchlauf dauerte hier zwischen einer und vier Minuten (OpenSSL beim
ersten Mal deutlich länger) — Erfahrungswert von dieser Maschine, nicht gemessen.

## Was gebaut wird

`Eudora71/Bin/Debug`: `QCSSL.dll`, `Imap.dll`, `QCSocket.dll`, `QCUtils.dll`,
`EuLang.dll`, `plstclnt.dll` sowie `NSImport.eif`, `OEImport.eif`, `OLImport.eif` —
die drei Importer sind ebenfalls DLLs, nur mit der Plugin-Endung `.eif`
(`<OutputFile>$(OutDir)$(ProjectName).eif</OutputFile>`).

`Eudora71/EudoraOldIcons/Debug`: `EudoraOldIcons.epi` — dasselbe, Endung `.epi`.
Dieses Projekt schreibt als einziges nicht nach `Bin/Debug`.

`Eudora71/Lib/Debug`: `AccountWizard.lib`, `DirectoryServicesUI.lib`, `EuImap.lib`,
`EuLang.lib`, `Imap.lib`, `OEImport.lib`, `OLImport.lib`, `QCSSL.lib`, `QCSocket.lib`,
`QCUtils.lib`, `SearchEngine.lib` — elf Stueck. Sieben davon sind Importbibliotheken
zu den DLLs (kenntlich an der `.exp` daneben), echte statische Bibliotheken sind nur
`AccountWizard`, `DirectoryServicesUI`, `EuImap`, `SearchEngine`. Im selben
Verzeichnis liegen zusaetzlich sechs vorgefertigte Fremdbibliotheken, die kein
Projekt der Solution erzeugt (`EuMemMgr.lib`, `Paige32d.lib`, `SSCEWD32.LIB`,
`Uuid.Lib`, `libpng.lib`, `zlib.lib`); insgesamt sind es dort also 17 `.lib`.

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
**77 Methoden** auf. Beide Zahlen sind die Zeilenzahlen der Abschnitte 1 und 2 von
[Eudora71/OTShim/INVENTAR.md](Eudora71/OTShim/INVENTAR.md) und nachgezählt.

Abschnitt 3 des Inventars listet 52 weitere `SEC`-Bezeichner. **Diese 52 ist keine
belastbare Zahl** und sollte nicht zitiert werden: sie enthält mindestens zwei
Fehltreffer (`SEC_TEXT` ist ein SSPI-Makro aus `Sspi.h`, `SECCustonToolBar` ein
Tippfehler in einem Kommentar — beides in `PLAN.md` belegt) und ihr fehlen
umgekehrt Bezeichner, die in den Quellen tatsächlich vorkommen, etwa `SEC_AUX_DATA`
und `SEC_WNDBTN_RESIZE_WIDTH`. Früher stand hier "rund 63 Klassen" — auch das ist
überholt.

Gemessen an den Quellen selbst: **42** `.cpp` und **30** `.h` unter
`Eudora71/Eudora` nennen mindestens einen Stingray-Bezeichner. Gezählt über
`\bSEC[A-Za-z_]…`, abzüglich der Treffer, die kein Stingray sind — die SSPI-Namen
in `AuthRPA.cpp` (`SEC_E_*`, `SEC_I_*`, `SECPKG_*`, `SECBUFFER_*`, `SECURITY_*`),
`SECRET_SEED` in `timestmp.cpp` und `SECTION` in `persona.cpp`. Im README stand
dafür lange 39; diese Zahl ließ sich nicht reproduzieren.

Beispiele für die Klassen: `SECWorkbook`, `SECControlBar`, `SECCustomToolBar`,
`SECMDIFrameWnd`, `SECTab`. Ohne `ota50d.lib` linkt `Eudora.exe` nicht.

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

**Gewählt ist Weg 1, und er ist weitgehend umgesetzt.** Die Analyse der vier
Klassenfamilien hat den Umfang deutlich verkleinert: die 77 Methoden sind nicht 77
Aufgaben. Viele sind geerbte MFC-Methoden, die Eudora nur qualifiziert aufruft,
andere werden nie aufgerufen; `SECStatusBar` erledigt ein `typedef`.

**Alle fünf Teile sind eingehängt** (`e50a89c`). Stand an `2d68555`, gezählt mit
`wc -l` und geprüft gegen `OTShimAll.h` sowie die `ClCompile`-Einträge in
`Eudora.vcxproj:217`:

| Stufe | Dateien | Zeilen | eingehängt? |
|---|---|---|---|
| 0–2, 2b — Workbook, MDI, Statusleiste, Andockfamilie | `OTShim.h/.cpp` | 5494 | ja |
| 3 — Werkzeugleisten und Knöpfe | `OTShim_Werkzeugleiste.h/.cpp` | 6083 | ja |
| 4 — Bilder über GDI+ | `OTShim_Bild.h/.cpp` | 2358 | ja |
| Registerkarten | `OTShim_Reiter.h/.cpp` | 2925 | ja |
| `SECDateTimeCtrl`, Palette | `OTShim_Palette.h/.cpp` | 890 | ja |
| Sammelkopfdatei | `OTShimAll.h` | 78 | — |

Zusammen **17828 Zeilen** in 11 Dateien. `secaux.cpp` aus `OT501/Src` ist direkt in
`Eudora.vcxproj` aufgenommen — `secData` und `SEC_AUX_DATA` brauchten keinen
Nachbau.

Seit `78a9c10` übersetzt `Eudora` damit fehlerfrei; von den Stingray-Symbolen ist
keines mehr offen (gemessen an `2d68555`).

> **Der Wächter `__SECBTNS_H__` in `OTShimAll.h` bleibt auskommentiert.** Ihn zu
> setzen ist der naheliegende, aber falsche Weg: `secbtns.h` liefert ausser
> `SECLoadSysColorBitmap` auch `SECBitmapButton`. Gemessen an `22a6d77`, `Eudora`
> einzeln: auskommentiert **1** Fehler, eingekommentiert **102**. Der `C2572` ist
> stattdessen dadurch gelöst, dass die inline-Fassung in `OTShim.h:307` kein
> Standardargument mehr führt.

**Eine Planannahme hat sich als falsch erwiesen:** die Registerkarten sind *nicht*
durchweg verzichtbar. Das gilt nur für den MDI-Streifen hinter `m_bWorkbookMode`,
nicht für `SEC3DTabWnd`/`SEC3DTabControl`, das Steuerelement in jeder Wazoo-Leiste.
Belegt in PLAN.md, Abschnitt „Berichtigungen" (`7d94c3d`).

Stufenplan mit Belegen: **[Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md)**.

## Erledigt: OpenSSL 3.5.8 LTS hinter QCSSL

QCSSL hing an **OpenSSL 0.9.7l von 2006** — maximal TLS 1.0. Damit kam Eudora an
keinem aktuellen Mailserver mehr vorbei. Die Umstellung auf **OpenSSL 3.5.8 LTS** ist
abgeschlossen; `QCSSL.dll` setzt keine Protokoll-Obergrenze mehr. Nachgemessen wird
**TLS 1.3 tatsächlich ausgehandelt**:

| Messung | Ergebnis |
|---|---|
| Komponententest, lokaler Server (`Eudora71/Tests/QCSSL`, Fall 1a) | `TLSv1.3`, `TLS_AES_256_GCM_SHA384`, 256 Bit, `SSLSUCCEEDED` |
| Betrieb, 29.08.2026, `pop.gmx.net:995` (IP 212.227.17.185), Eudora-Dialog "SSL Connection Information Manager" | `TLSv1.3`, `TLS_AES_256_GCM_SHA384`, 256 Bit, Status `Succeeded` |

Die zweite Messung stammt gesichert aus **dieser** DLL und nicht aus HermesSSL:
HermesSSL 7.8 gamma setzt auf OpenSSL 1.0.2p auf, und 1.0.2 beherrscht TLS 1.3
nicht.

Günstig war die Ausgangslage: der gesamte OpenSSL-Kontakt steckt in **einer Datei**,
`Eudora71/QCSSL/src/QCSSLContext.cpp`, und QCSSL linkt OpenSSL **statisch** — die
gebaute DLL braucht keine `libeay32.dll`/`ssleay32.dll` daneben und ist damit ein
echtes Drop-in für eine bestehende Eudora-Installation.

Umgestellt wurde:

| Stelle | Problem | Lösung |
|---|---|---|
| eigene `BIO_METHOD`-Struktur (`BIO_s_workersocket`) | `BIO_METHOD` ist seit 1.1.0 opak | `BIO_meth_new()` + `BIO_meth_set_*()`. Seit Befund **M2** wird die fertig gefüllte Struktur unteilbar veröffentlicht (`InterlockedCompareExchangePointer`, `:330`) — vorher konnte ein zweiter Thread eine halb gefüllte Methode sehen |
| `BIO_set_fd()` für den `QCSSLReference`-Zeiger | schleust einen Zeiger durch ein `int` — unter Win32 harmlos, unter x64 eine lautlose Trunkierung | seit Befund **N1** nicht mehr benutzt: der Zeiger geht zeigergross durch `BIO_set_data()` (`:249`) bzw. `BIO_ctrl()` (`:341`) |
| `SSLv2_method()` | seit 1.1.0 entfernt | Zweig gestrichen |
| `SSLv3_method()`, `TLSv1_method()` | veraltet | `TLS_client_method()` + `SSL_CTX_set_min_proto_version()` |
| `ERR_remove_state(0)` | seit 1.1.0 entfernt | ersatzlos gestrichen (Thread-Cleanup ist automatisch) |
| `ctx->cert_store` | Struktur opak | `SSL_CTX_get_cert_store()` |
| `qccertificate.cpp` `ctx->ex_data` | Struktur opak | `X509_STORE_get_ex_data(X509_STORE_CTX_get0_store(...))` |

SSLv2 und SSLv3 sind damit abgeschaltet. Als Mindestprotokoll setzen inzwischen
**alle acht** Werte von `m_ProtocolVersion` — 0 bis 7 — `TLS1_2_VERSION`
(`QCSSLContext.cpp:569`, `:575`, `:578`).

Bis Befund **M1** war das anders: `m_ProtocolVersion == 3` (früher "TLSv1") setzte
`TLS1_VERSION`, also TLS 1.0 nach oben offen. Das war nicht bloss ein Ausreisser
unter acht Einstellungen, sondern **die Voreinstellung** — `EudoraRes.rc:8143` und
`:8147` geben `SSLReceiveVersion` und `SSLSendVersion` beide mit `3` vor. Die
schwächste Untergrenze galt damit für jede unveränderte Installation. Gemessen in
`Eudora71/Tests/QCSSL`, Fall 2e: OpenSSL 3 lehnt TLS 1.0/1.1 auf Sicherheitsstufe 1
ohnehin ab — die Absicht steht jetzt auch im Code.

Ein ungültiger Wert landet im `default`-Zweig, meldet `IDS_ERR_VERSIONINVALID` und
liefert seit Befund **H1** `NULL` zurück (`:584`): es wird gar kein Kontext angelegt,
die Verbindung kommt nicht zustande. Vorher wurde trotz Fehlermeldung verbunden.

**Eine Obergrenze wird weiterhin an keiner Stelle gesetzt** —
`SSL_CTX_set_max_proto_version()` kommt in QCSSL nicht vor. Das ist Absicht: so
handelt die Bibliothek stets das höchste beiderseits unterstützte Protokoll aus.

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

Das ist inzwischen keine Erwartung mehr, sondern gemessen: gegen `pop.gmx.net` wurde
`TLS_AES_256_GCM_SHA384` ausgehandelt — ein AEAD-Verfahren, das in der Liste von 2006
nicht vorkam. Die Entfernung war notwendig, nicht vorsorglich. Ohne feste Liste bietet
QCSSL **30 Cipher Suites** an, keine davon mit RC4, 3DES oder EXPORT
(`Eudora71/Tests/QCSSL/work/ergebnis_openssl_lokal.txt`, Prüfpunkt 3).

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
  unbekannte Aussteller (20) werden abgewiesen. Sie haben zwar `case`-Zweige
  (`qccertificate.cpp:101-102` und `:82`), aber keiner davon setzt `iOK` auf 1 -
  es bleibt bei 0, der Handshake bricht ab.
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
   die Luecke ist also Altbestand. Weder `X509_check_host` noch
   `SSL_set_tlsext_host_name` kommen in QCSSL vor (gegrept ueber
   `Eudora71/QCSSL/src`).

   **Zweimal gemessen, im Test und im Betrieb.** Der Komponententest (Fall 1c,
   Server auf Port 14433 mit `CN=falsch.example.com`) liefert `SSLSUCCEEDED`,
   `ErrorCode 0`, `m_bCertRejected = false` und dazu die beiden Texte
   "Certificate bad: Destination Host name does not match host name in
   certificate" und "But ignoring this error because Certificate is trusted".
   Genau dieselben zwei Texte zeigt Eudora am 29.08.2026 im Betrieb gegen
   `pop.gmx.net` — bei `Status: Succeeded`.

   Die praktische Folge ist damit belegt: weil nur der CN und keine SAN geprueft
   wird, schlaegt der Namensabgleich bei heutigen Zertifikaten regelmaessig fehl;
   GMX ist kein Sonderfall. Eudora erkennt die Abweichung, meldet sie und faehrt
   trotzdem fort, weil es sich allein auf "Aussteller ist vertraut" stuetzt. Die
   Namenspruefung ist damit faktisch wirkungslos - uebrig bleibt allein die
   Pruefung des Ausstellers.

   **Nicht behoben, und zwar bewusst:** die Behebung ist zurueckgestellt. Dieser
   Abschnitt dokumentiert nur.
4. **Kein SNI.** `SSL_set_tlsext_host_name` wird nicht gesetzt, vorher wie nachher.
   Bei Mailservern hinter gemeinsamer IP liefert der Server das Standardzertifikat.

### Offener Punkt: Wurzelzertifikatsspeicher

QCSSL prüft Serverzertifikate gegen `rootcerts.p7b` im Eudora- oder Programm-
verzeichnis (`QCSSLContext.cpp:53`, geladen in `SetupCertificates()`), **nicht** gegen
den Windows-Zertifikatspeicher. Die Fassung aus Eudora 7.1 ist von 2005.

Im Repo liegen **zwei verschiedene** Altbestände dieser Datei — sie haben
verschiedene SHA256 und verschiedenen Inhalt. Beide am 29.08.2026 nachgemessen
(`X509Certificate2Collection.Import`, ausgewertet `NotBefore`/`NotAfter`):

| Datei | Zertifikate | ältestes `NotBefore` | jüngstes `NotBefore` | heute abgelaufen | noch gültig |
|---|---|---|---|---|---|
| `InstallersForEudora/Eudora7.1/Data/win32/rootcerts.p7b` | 30 | 09.11.1994 | 04.03.2004 | 17 | 13 |
| `Eudora71/Bin/Release/rootcerts.p7b` (identisch mit `Bin/Debug`) | 19 | 09.11.1994 | 22.09.2000 | 8 | 11 |

Der Installer verteilt die erste, der Build-Baum trägt die zweite. Im README stand
für die zweite Datei früher "19 Zertifikate von 1996-1998" — die Anzahl stimmt, der
Zeitraum nicht.

Die Portierung auf OpenSSL 3.x ändert daran nichts. Auf einer unberührten 7.1-
Installation ist deshalb ein Zertifikatsfehler (`IDS_CERTERR_UNKNOWNROOT`) zu erwarten,
obwohl der TLS-Handshake selbst funktioniert. Ob es real dazu kommt, ist **ungeprüft**
und hängt davon ab, welche der noch gültigen Wurzeln der Mailserver verwendet.

Der erfolgreiche Test lief auf einer Installation mit **HermesSSL 7.8 gamma**, die
einen aktuellen Speicher mitbringt — das erklärt, warum die Zertifikatsprüfung dort
durchlief; der Lauf gegen GMX meldete "Certificate is trusted". Für die
TLS-Version ist Hermes dagegen ausgeschlossen: es liefert OpenSSL 1.0.2p, das kein
TLS 1.3 kann, gemessen wurde aber TLS 1.3.

Erledigt seit `75b60e1`: `Releases/1.0/rootcerts.p7b` mit 121 Zertifikaten liegt dem
Release bei, erzeugt von `Releases/1.0/rootcerts-erzeugen.ps1`. Einzelheiten in
`Releases/1.0/README.md`.

## Nächster Schritt

1. ~~`QCSSL.dll` gegen einen echten Mailserver testen~~ — erledigt. Abruf und Versand
   laufen; am 29.08.2026 gegen `pop.gmx.net:995` protokolliert: `TLSv1.3`,
   `TLS_AES_256_GCM_SHA384`, 256 Bit, Status `Succeeded`. Einschränkung: die
   Installation hatte HermesSSL samt aktuellem Wurzelzertifikatsspeicher, die
   Kette wurde deshalb als vertrauenswürdig eingestuft. Dass die gemessene
   TLS-Verbindung von dieser DLL stammt, ist gesichert — HermesSSL 7.8 gamma
   beruht auf OpenSSL 1.0.2p und kann kein TLS 1.3.
2. ~~Aktuellen `rootcerts.p7b` erzeugen und dem Release beilegen~~ — erledigt mit
   `75b60e1`.
3. ~~OT501-Ersatzschicht implementieren~~ — im Kern erledigt. Alle fünf Teile sind
   geschrieben und eingehängt (`e50a89c`), `Eudora` übersetzt seit `78a9c10`
   fehlerfrei, und von den Stingray-Symbolen ist an `2d68555` keines mehr offen.
   Der Weg mit allen Zwischenmessungen steht in
   [Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md).
4. **`__imp___iob` aus der vorgefertigten `libpng.lib` auflösen** — das letzte
   ungelöste Symbol beim Binden von `Eudora.exe` (gemessen an `2d68555`). Es ist
   kein Stingray-Problem, sondern eine VC6-Binärdatei aus dem Altbestand, die
   gegen eine CRT von damals gebaut wurde. Danach die Attrappe
   `Eudora71/Lib/Debug/OTA50D.LIB` entfernen und neu messen — solange sie liegt,
   linkt Eudora gegen eine leere Bibliothek.
5. **Ersten Start herrichten** — welche Laufzeitdateien danebenliegen müssen und
   was noch fehlt (unter anderem `EudoraRes.dll`), steht in
   [STARTUMGEBUNG.md](STARTUMGEBUNG.md).
6. Hostnamenprüfung — bewusst zurückgestellt, siehe oben. Der Befund ist
   dokumentiert, nicht behoben.

## Rückschritte und ihre Ursachen

Nicht jeder Schritt ging vorwärts. Der folgende Fall ist festgehalten, weil die
Lehre daraus allgemein gilt.

### `stdafx.h` gewechselt, vier Projekte gebrochen

**Was passiert ist.** `7dcac81` hat in `Eudora71/Eudora/stdafx.h:52` `secall.h`
durch `OTShimAll.h` ersetzt, um die OT501-Ersatzschicht einzuhängen. Der
Include-Pfad `..\OTShim` wurde dabei nur in `Eudora.vcxproj:66` eingetragen.

**Die Folge.** `Eudora/stdafx.h` wird von vier weiteren Projekten mitbenutzt:
`AccountWizard`, `DirectoryServicesUI`, `EuImap` und `SearchEngine`. Alle vier
brachen mit `C1083: OTShimAll.h` ab. Nachgemessen an `e7e6f3c` mit einem vollen
Solution-Bau: **7 Fehler statt 3**, und es wurden **11 der 18** Projekte fertig
statt 15.

**Wie es auffiel.** Nicht beim Ändern, sondern erst, als bei einer
Doku-Überprüfung der Bauzustand nachgemessen statt übernommen wurde. Zwischen
Einbau und Entdeckung lagen mehrere Commits.

**Behoben mit `1c616c9`:** `..\OTShim` bzw. `..\..\OTShim` in die
`AdditionalIncludeDirectories` aller vier Projekte, je Debug und Release.

**Ein Nachspiel, das die Lehre bestätigt.** Der Fix beseitigte den `C1083`, aber
nicht den Fehlerstand: nachgemessen an `22a6d77` meldete der Solution-Bau
weiterhin **7 Fehler** und **11 von 18** Projekten. Die vier Projekte fanden die
Kopfdatei jetzt — und liefen damit in denselben `C2572` aus `secbtns.h:340`, an
dem auch `Eudora` hing. Erst `78a9c10` hat beides zugleich aufgelöst; seither sind
es wieder 3 Fehler und 15 von 18 (gemessen an `2d68555`).

**Die Lehre.** Eine Änderung an einer *gemeinsam benutzten* Datei — `stdafx.h`
steht hier stellvertretend — muss gegen die **ganze Solution** gemessen werden,
nicht nur gegen das Projekt, an dem man gerade arbeitet. Ein Einzelprojekt-Bau
hätte den Schaden nie gezeigt, und der zweite Durchgang zeigt, dass auch die
Wirkung eines Fixes gegen die ganze Solution zu prüfen ist. Ausformuliert in
`Arbeitsweise/gemeinsame-dateien-gegen-alles-messen.md`.

## Angewandte Korrekturen (Kategorien)

Alle Änderungen sind einzeln in den Commits dokumentiert — bis `22a6d77` auf
`vs2022-portierung-fixes`, seither auf `eudora-exe-linkt`.

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
  **Achtung:** die beiden `.lib` liegen **nicht** im Repo — `.gitignore:7` (`Lib/`)
  erfasst auch dieses Verzeichnis (gemessen: `git ls-files Eudora71/OpenSSL3/lib`
  liefert null Treffer). Nur die Header sind versioniert. In einem frischen Klon
  endet `QCSSL` deshalb mit `LNK1104: libssl.lib`.
- `Eudora71/Eudora/atlimage.h` — **geänderte Kopie eines Microsoft-Headers.**
  `CImage::IsTransparencySupported()` lautete im Original
  `return( _AtlBaseModule.m_bNT5orWin98 );`. Das `CAtlBaseModule` der ATL von v143
  (`atlcore.h:280`) kennt dieses Win9x/NT4-Erbstück nicht mehr, und im ganzen Baum
  gibt es keine Ersatzdefinition — der Originalrumpf hätte nicht übersetzt. Die
  Funktion liefert jetzt für `WINVER >= 0x0500` fest `TRUE`; auf dem Zielsystem
  Windows 10 ist das ohnehin die richtige Antwort. Die Abweichung ist in der Datei
  selbst bei Zeile 1537/1541 vermerkt (`ba3d2ee`, Befund N5). Beim Wechsel auf den
  SDK-eigenen `atlimage.h` fällt sie weg. Wer hier ein SDK aktualisiert, sollte
  wissen, dass eine veränderte Microsoft-Kopie im Baum liegt.
- `Eudora71/Eudora/utils.cpp` — UTF-8-Übersetzungstabelle von 27 auf 123 Einträge
  erweitert (deutsche Umlaute + Latin-1 U+00A0..U+00FF), Patch aus
  https://github.com/HansWurst81675/Eudora_patches

## Zwei Fehler in der Zeichentabelle - gefunden und behoben

`Eudora71/Tests` prueft die Uebersetzungstabelle aus `utils.cpp` gegen CP1252,
ISO-8859-15 und RFC 3629. Die Erwartungswerte stammen aus den Spezifikationen,
nicht aus dem getesteten Code. Die Tests haben zwei echte Fehler nachgewiesen
(`4c2f614`, damals 19 von 23 gruen); beide sind jetzt behoben, **23 von 23 Tests
sind gruen**.

### 1. Sieben Zuordnungen zeigten auf falsche Codepunkte (Altbestand)

| Quellfolge war | = | Ziel | Ziel ist in CP1252 | Quellfolge ist jetzt |
|---|---|---|---|---|
| `C5 BF` | U+017F LATIN SMALL LETTER LONG S | 0x83 | U+0192 f mit Haken | `C6 92` |
| `CB 82` | U+02C2 MODIFIER LETTER LEFT ARROWHEAD | 0x8B | U+2039 einfaches Anfuehrungszeichen links | `E2 80 B9` |
| `CB 83` | U+02C3 MODIFIER LETTER RIGHT ARROWHEAD | 0x9B | U+203A einfaches Anfuehrungszeichen rechts | `E2 80 BA` |
| `E2 80 B2` | U+2032 PRIME | 0x92 | U+2019 Apostroph / Anfuehrung rechts | `E2 80 99` |
| `E2 80 B3` | U+2033 DOUBLE PRIME | 0x94 | U+201D doppelte Anfuehrung rechts | `E2 80 9D` |
| `E2 80 B5` | U+2035 REVERSED PRIME | 0x91 | U+2018 Anfuehrung links | `E2 80 98` |
| `E2 80 B6` | U+2036 REVERSED DOUBLE PRIME | 0x93 | U+201C doppelte Anfuehrung links | `E2 80 9C` |

Vier davon sind die **typografischen Anfuehrungszeichen**. In der Tabelle standen
die Prime-Zeichen (U+2032/2033/2035/2036) statt der Anfuehrungszeichen
(U+2018/2019/201C/201D) - ein Uebertragungsfehler, `B2/B3/B5/B6` statt
`98/99/9C/9D`. Die drei uebrigen sind vom selben Muster: ein optisch aehnliches,
aber anderes Zeichen.

**Folge vor der Reparatur:** Anfuehrungszeichen und Apostrophe aus UTF-8-Post
wurden gar nicht uebersetzt und erschienen als `a-Tilde-Euro-TM`. Das ist der
haeufigste nicht-ASCII-Fall in echter Post - haeufiger als Umlaute.

Diese sieben Eintraege waren **Originalcode von QUALCOMM**. Der Umlaut-Patch aus
`d03007f` hat sie nicht verursacht, aber auch nicht mitrepariert.

Die Zielbytes blieben unveraendert; geaendert wurden nur die Quellfolgen. Damit
sind alle 35 CP1252-Zeichenliterale der Datei byteweise dieselben wie vorher -
nachgemessen, die Datei ist Latin-1 mit gemischten Zeilenenden.

### 2. Doppelersetzung durch den neuen C3-Block (Regression aus d03007f)

`ISOTranslate` lief die Tabelle der Reihe nach durch und rief fuer jede der 123
Zeilen `CString::Replace` auf den **ganzen** Text. Das ist nicht sicher: eine
Ersetzung erzeugt ein 1252-Byte, und dieses Byte kann sich mit seinem Nachbarn zu
einer Folge verbinden, die eine **spaetere** Zeile ein zweites Mal ersetzt. Aus
zwei Zeichen wurde eines:

    Eingabe C3 83 C2 A9  ->  erwartet C3 A9, erhalten E9

Im Beispiel steht U+00C3 vor U+00A9. Erst lief Zeile `C2 A9 -> A9`, dann Zeile
`C3 83 -> C3`; die dabei entstandene Folge `C3 A9` wurde von der viel spaeteren
Zeile `C3 A9 -> E9` aufgefressen. **50 von 13456 geprueften Zeichenpaaren**
brachen so, alle mit U+00C3 als erstem Zeichen.

Vor `d03007f` war das unmoeglich: die alten 27 Eintraege erzeugten nur Bytes
0x80..0x9F, nie ein Fuehrungsbyte. Erst der neue C3-Block erzeugt 0xC0..0xFF.

**Behoben** durch einen einzigen Durchgang von links nach rechts ueber den Puffer
(`utils.cpp`, `ISOTranslate`): an jeder Stelle wird die laengste passende
Quellfolge gesucht, ihr Zielbyte geschrieben und um die Laenge der Quellfolge
weitergerueckt. Jedes geschriebene Byte liegt hinter der Leseposition und wird nie
wieder angesehen - damit haengt die Uebersetzung eines Zeichens nicht mehr davon
ab, welches Zeichen daneben steht. Genau das ist die Bedeutung einer
Zeichensatzwandlung, und genau das prueft der Test
"Zeichen werden unabhaengig von ihren Nachbarn uebersetzt".

Nebenbei entfaellt die Umkopiererei ueber ein `CString` samt `strncpy`; die
Ausgabe ist nie laenger als die Eingabe, es wird direkt im Puffer gearbeitet.
Der Durchgang laeuft ausserdem ueber die volle Laenge `lSize` statt bis zum
ersten Nullbyte - eingebettete Nullbytes schneiden den Text nicht mehr ab.

### Was schon vorher bestanden hat

Alle Makrowerte, keine Luecke in den 123 Eintraegen, alle Quellfolgen gueltiges
UTF-8, keine Doppeleintraege, und - wichtig fuer `d03007f` - **Latin-1
U+00A0..U+00FF ist vollstaendig und wertgleich**. Der Umlaut-Zusatz war als
Datensatz von Anfang an korrekt.

### Was die Tabelle weiterhin nicht kann (offen, Entscheidung steht aus)

`MAX_CHARS_TO_TRANS` ist 3. Zeichen ausserhalb der BMP - Emoji, U+1F600 und
aufwaerts - sind in UTF-8 vier Byte lang und koennen deshalb prinzipiell nicht
abgebildet werden; sie bleiben als rohe UTF-8-Bytes stehen und erscheinen als
Zeichensalat. Dasselbe gilt fuer alle drei- und zweibyteigen Zeichen ohne
CP1252-Entsprechung, etwa kyrillisch oder griechisch.

**Vorschlag zur Entscheidung:** Das Tabellenverfahren liesse sich vollstaendig
durch den Windows-Codepage-Wandler ersetzen -
`MultiByteToWideChar(CP_UTF8, ...)` gefolgt von `WideCharToMultiByte(1252, ...,
"?", ...)`. Das deckt den gesamten Unicode-Bereich ab, ersetzt Nichtabbildbares
durch ein Fragezeichen statt durch Zeichensalat, macht die 123 Tabellenzeilen
ueberfluessig und ist deutlich schneller. Es ist aber ein Verhaltenswechsel:
heute bleibt ein nicht abbildbares Zeichen unveraendert stehen, danach wuerde es
zu `?`. Das ist eine Entscheidung des Auftraggebers und **nicht** miterledigt.

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
  weshalb kein einziges Muster griff) und hält einige tausend unversionierte Dateien
  fern. Die Zahl schwankt mit dem Build-Zustand des Arbeitsverzeichnisses und ist
  deshalb kein fester Wert: `git ls-files -o -i --exclude-standard | wc -l` ergab am
  28.08.2026 2003, am 29.08.2026 2183. Die bereits **getrackten** Altbestände bleiben
  sichtbar — sie müssten per `git rm --cached` aus dem Index.
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

## Zeichensatz-Darstellung: UTF-8 läuft jetzt über den Windows-Codepage-Wandler

Nachtrag zum Abschnitt *„Zwei Fehler in der Zeichentabelle“* weiter oben. Der dort
unter *„Was die Tabelle weiterhin nicht kann“* formulierte Vorschlag ist umgesetzt
(Commit `63f81dc`, `Eudora71/Eudora/utils.cpp`). Die Tests stehen bei **33 von 33
grün**, vorher 23 von 23; zehn Fälle sind neu.

### Was vorher war

`ISOTranslate()` übersetzte ausschließlich über die Tabelle `pcXlateTable`. Die
bildet eine **UTF-8-Bytefolge auf genau ein CP1252-Byte** ab, und
`MAX_CHARS_TO_TRANS` ist **3**. Daraus folgten zwei harte Grenzen:

- **Emoji waren prinzipiell unmöglich.** Zeichen außerhalb der BMP (U+1F600
  aufwärts) sind in UTF-8 **vier** Byte lang. Es gab keine Tabellenzeile, die so
  etwas hätte beschreiben können — unabhängig davon, wie viele Zeilen man
  ergänzt.
- **Alles ohne CP1252-Entsprechung blieb als rohe Bytes stehen.** Kyrillisch,
  Griechisch, Hebräisch, Chinesisch, Polnisch, Tschechisch, Türkisch: die zwei
  oder drei UTF-8-Bytes wurden durchgereicht und anschließend Byte für Byte als
  CP1252 angezeigt. Genau das ist der Zeichensalat, den der Auftraggeber täglich
  sieht.

### Was jetzt ist

Der **UTF-8-Fall** (Zeichensatz-Index 4) geht durch den Windows-Wandler:

    MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, ...)
    WideCharToMultiByte(1252, 0, ..., "?", NULL)

Damit versteht Eudora den **gesamten Unicode-Bereich**. Was CP1252 nicht halten
kann, wird zu **einem Fragezeichen** statt zu zwei bis vier Salatzeichen.
Zusätzlich — das war nicht geplant, ist aber der größte praktische Gewinn —
arbeitet `WideCharToMultiByte` mit `dwFlags = 0` und benutzt deshalb die
**Ersatztabelle der Codepage**: Zeichen mit einem nahen CP1252-Verwandten werden
auf diesen abgebildet statt auf ein Fragezeichen.

Die Funktion arbeitet weiterhin **an Ort und Stelle** im Puffer des Aufrufers,
schreibt nie mehr Bytes, als hereinkamen, terminiert mit einer Null und gibt die
neue Länge zurück. Der Vertrag zu den Aufrufern ist unverändert.

### Die Testfälle, die den Unterschied belegen

Alle Erwartungswerte sind **gemessen**, nicht geraten — drei meiner Annahmen
waren falsch und wurden vom ersten Testlauf korrigiert (siehe die Anmerkung zum
Emoji). Die Fälle stehen in `Eudora71/Tests/TestIsoTranslate.cpp`.

| Eingabe | vorher | jetzt |
|---|---|---|
| U+1F600 Emoji (`F0 9F 98 80`, vier Byte) | vier Bytes bleiben stehen | `? ?` — **zwei** Fragezeichen |
| U+0416 Ж, U+05D0 א (kyrillisch, hebräisch) | zwei Bytes bleiben stehen | `?` |
| U+4E2D 中, U+3042 あ, U+D55C 한 | drei Bytes bleiben stehen | `?` |
| U+0142 ł (polnisch) | zwei Bytes bleiben stehen | `l` |
| U+0104 Ą, U+0105 ą (polnisch) | dto. | `A`, `a` |
| U+010D č, U+0159 ř (tschechisch) | dto. | `c`, `r` |
| U+015F ş, U+011F ğ (türkisch) | dto. | `s`, `g` |
| U+03B1 α, U+03A9 Ω (griechisch) | dto. | `a`, `O` |
| **jeder** Codepunkt U+00A0..U+FFFD | zwei bis drei Bytes, sobald keine Tabellenzeile passte | **genau ein Byte** |

Der letzte Fall ist der eigentliche Beleg: kein Zeichen der BMP bleibt mehr als
rohe UTF-8-Bytefolge stehen. Dazu kommt ein realistischer Volltext-Fall — ein
deutscher Newsletter mit typografischen Anführungszeichen (U+201E/U+201C),
Gedankenstrich (U+2013), Eurozeichen, Umlauten und einem Emoji — der byteweise
gegen die erwartete CP1252-Zeile geprüft wird.

**Zum Emoji:** es werden **zwei** Fragezeichen, nicht eines. Ein Zeichen
außerhalb der BMP ist in UTF-16 ein Ersatzzeichenpaar, und `WideCharToMultiByte`
setzt für jede der beiden Hälften ein Ersatzzeichen. Zwei Fragezeichen statt vier
Salatzeichen — der Gewinn bleibt, die Zahl ist nur nicht die, die man erwartet.

### Zwei bewusste Entscheidungen

**1. `MB_ERR_INVALID_CHARS` mit Rückfall auf die Tabelle.**
Ohne dieses Flag ersetzt Windows jedes ungültige Byte durch U+FFFD und damit am
Ende durch ein Fragezeichen. Das wäre in zwei häufigen Fällen ein Rückschritt:

- Post, die `utf-8` behauptet und in Wahrheit CP1252-Bytes trägt (alte Programme,
  Spam). Solche Bytes werden **richtig** angezeigt, wenn man sie in Ruhe lässt.
- Eine Zeile, die länger ist als der Lesepuffer von `TextReader` und deshalb
  mitten in einem Zeichen geschnitten wird.

Mit dem Flag bricht die Wandlung in beiden Fällen ab, und der Text fällt auf den
alten Tabellendurchgang zurück, der alles Unbekannte unverändert durchreicht.
**Deshalb kann die Umstellung nie schlechter sein als der Ist-Zustand** — beide
Fälle sind als Test festgehalten. Die 123 Tabellenzeilen bleiben aus genau
diesem Grund erhalten, obwohl sie im Normalfall nicht mehr laufen.

**2. ISO-8859-15 bleibt bei der Tabelle** und läuft *nicht* über Codepage 28605.
Begründung: der Zeichensatz ist einbyteig, seine acht Tabelleneinträge sind
vollständig und durch Tests belegt, und er hat weder die Drei-Byte-Grenze noch
das Abdeckungsproblem — es gibt also nichts zu gewinnen. Zu verlieren gäbe es
dagegen etwas: in ISO-8859-15 sind die Bytes `0x80..0x9F` C1-Steuerzeichen, in
CP1252 sind es druckbare Zeichen (Anführungszeichen, Gedankenstriche,
Eurozeichen). Eine saubere Wandlung über 28605 würde sie zu Fragezeichen machen,
und Post, die `iso-8859-15` behauptet und CP1252-Bytes trägt, ist genauso häufig
wie im UTF-8-Fall. Auch das ist als Test festgehalten.

### Was weiterhin NICHT geht

**Die Anzeige selbst bleibt einbyte-basiert.** Eudora speichert und zeigt Text als
CP1252; daran ändert diese Umstellung nichts. Ein Fragezeichen statt Zeichensalat
ist ein Fortschritt in der Lesbarkeit — mehr nicht:

- **Kyrillisch, Griechisch, Hebräisch, Chinesisch, Japanisch, Koreanisch werden
  nicht dargestellt.** Sie werden durch `?` bzw. durch einen lateinischen
  Verwandten ersetzt. Der ursprüngliche Text ist danach verloren.
- **Emoji werden nicht dargestellt.** Sie werden zu `??`.
- Auch die Ersatztabelle ist eine Annäherung: aus `ł` wird `l`, aus `Ω` wird `O`.
  Lesbar, aber nicht richtig.

Echte Darstellung dieser Schriften bräuchte einen **Unicode-Umbau der Anzeige**
(Speicherung, Editor, Listenspalten, Filter, Adressbuch). Das ist ein eigenes,
großes Vorhaben und in dieser Portierung nicht enthalten.

### Nebenbefund 1: der IMAP-Pfad übersetzt gar nichts

Beim Prüfen der Aufrufstellen gefunden, **nicht** von dieser Umstellung
verursacht und **nicht** behoben (`ImapDownload.cpp` gehört nicht zu dieser
Änderung):

`ISOTranslate()` erwartet die Indizes aus `FindMIMECharset()` (`mime.cpp:382`):
`0` windows-\*, `1` us-ascii, `2` iso-8859-1, `3` iso-8859-15, `4` utf-8.
`Eudora71/EuImap/src/ImapDownload.cpp:4644` bildet den Index aber selbst und
anders:

    iCharsetIdx = FindRStringIndexI(IDS_MIME_US_ASCII, IDS_MIME_ISO_LATIN9,
                                    params->value, -1);

Das liefert `0` us-ascii, `1` iso-8859-1, `2` iso-8859-15 — um eins verschoben,
und **`utf-8` liegt gar nicht im durchsuchten Bereich** (er endet bei
`IDS_MIME_ISO_LATIN9`). Folge:

- `utf-8` → `-1`, die Wächterbedingung `if (iCharsetIdx > 1)` greift nicht,
  `ISOTranslate` wird nie gerufen.
- `iso-8859-15` → `2`, `ISOTranslate` wird gerufen, liest die `2` aber als
  „Latin-1, keine Übersetzung nötig“ und gibt den Text unverändert zurück.

**Über IMAP wird also kein einziger Zeichensatz übersetzt** — weder vorher noch
nachher. Die Umstellung wirkt damit ausschließlich auf dem POP-Pfad
(`lex822.cpp:544` für Kopfzeilen nach RFC 2047, `TextReader.cpp:251` für den
Nachrichtenrumpf). Wer den Fehler auch über IMAP behoben haben will, muss
`ImapDownload.cpp` auf `FindMIMECharset()` umstellen; das ist eine eigene
Änderung mit eigenen Tests.

### Nebenbefund 2: zwei Aufrufer werten die neue Länge nicht aus

Ebenfalls Altbestand, ebenfalls nicht von dieser Umstellung verursacht.
`ISOTranslate()` verkürzt den Puffer und gibt die neue Länge zurück. Zwei
Aufrufer werfen den Rückgabewert weg und rechnen mit der **alten** Länge weiter:

- `Eudora71/Eudora/TextReader.cpp:251` — `size` bleibt unverändert
- `Eudora71/EuImap/src/ImapDownload.cpp:4662` — `inLen` bleibt unverändert

Hinter dem übersetzten Text steht dann die Null, die `ISOTranslate` schreibt, und
dahinter der unveränderte Rest des alten Inhalts; beides wird mitgeschrieben.
`lex822.cpp:544` ist nicht betroffen, weil es danach mit `strlen` weiterrechnet
und die Null die Länge korrekt begrenzt.

Der Befund ist **älter als die Portierung** — schon die ursprüngliche Fassung von
QUALCOMM (Commit `567a5d8`) kürzte den Puffer und gab die neue Länge zurück. Weil
die Umstellung mehr Zeichen zusammenfasst als vorher (drei Bytes Kyrillisch
werden zu einem Fragezeichen), wird der Rest **sichtbarer** als bisher. Das ist
ein Grund, diesen Befund bald anzugehen — er liegt aber in `TextReader.cpp` und
`ImapDownload.cpp`, nicht in `utils.cpp`.

### Neues Werkzeug: `tools/ersetze-bereich.pl`

`tools/aendere-zeile.pl` kann nur *innerhalb* einer Zeile ersetzen und keine
Zeilen einfügen oder löschen — für eine neu geschriebene Funktion reicht das
nicht. `tools/ersetze-bereich.pl` ersetzt einen zusammenhängenden Zeilenbereich:

    perl tools/ersetze-bereich.pl <datei> <vonZeile> <bisZeile> <neuerBlock>

Gelesen und geschrieben wird ausschließlich mit `:raw`. Nach dem Schreiben wird
nachgemessen, dass alles **vor** und **nach** dem ersetzten Bereich byteweise
unverändert geblieben ist; bei Abweichung bricht das Werkzeug ab. Zusätzlich
werden die CR-Zahlen vorher/nachher ausgegeben, damit ein versehentlicher Wechsel
von LF auf CRLF sofort auffällt. Für `utils.cpp` gemessen: 118 CR vorher, 118 CR
nachher, `tools/pruefe-bytes.pl` sauber.
