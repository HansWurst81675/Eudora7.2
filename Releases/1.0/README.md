# Eudora 7.2 — Release 1.0: QCSSL mit TLS 1.3

Diese Version tauscht **zwei Dateien** in einer bestehenden Eudora-7.1-Installation
aus und bringt sie damit auf aktuelle Verschlüsselung.

## Was drin ist

| Datei | Größe | Zweck |
|---|---|---|
| `QCSSL.dll` | 2,8 MB | Eudoras SSL/TLS-Schicht, neu gebaut gegen OpenSSL 3.5.8 LTS |
| `QCSSL.dll.sha256` | | Prüfsumme zum Abgleich |
| `rootcerts.p7b` | 126 KB | Wurzelzertifikatsspeicher, 121 aktuelle Zertifizierungsstellen |
| `rootcerts.p7b.sha256` | | Prüfsumme zum Abgleich |
| `rootcerts-erzeugen.ps1` | | Skript, das `rootcerts.p7b` erzeugt — der Bauweg zum Nachvollziehen |

## Was es bringt

Eudora 7.1 bringt **OpenSSL 0.9.7l von 2006** mit. Das kann höchstens TLS 1.0 und
kennt nur Verschlüsselungsverfahren, die heute kein Mailserver mehr annimmt. Praktisch
heißt das: verschlüsselte Verbindungen scheitern oder kommen gar nicht erst zustande.

Diese DLL ist gegen **OpenSSL 3.5.8 LTS** gebaut:

| | vorher | jetzt |
|---|---|---|
| Höchstes Protokoll | TLS 1.0 (Grenze der Bibliothek) | **keine Obergrenze gesetzt** — TLS 1.3 damit nicht ausgeschlossen, aber nicht nachgemessen |
| OpenSSL-Version | 0.9.7l (2006) | 3.5.8 LTS |
| Sicherheitsupdates | seit ~2007 keine | bis 2030 |
| SSLv2 / SSLv3 | angeboten | abgeschaltet (beide gebrochen) |
| Mindestprotokoll | — | TLS 1.2 bei sieben der acht Werte von `m_ProtocolVersion`; beim Wert 3 (früher "TLSv1") TLS 1.0 |

Gegenüber dem verbreiteten **HermesSSL**-Paket (Version 7.8 gamma): das nutzt
OpenSSL 1.0.2p, seit 2019 End-of-Life und ohne TLS 1.3. Wer HermesSSL bereits
einsetzt, hat funktionierendes TLS 1.2 und wird im Alltag **keinen Unterschied**
bemerken — der Gewinn ist die gepflegte Krypto-Basis, nicht eine sichtbare Funktion.
Einen aktuellen Wurzelzertifikatsspeicher bringen beide mit; der hier beiliegende
ist aus einer offengelegten Quelle nachgebaut (siehe den nächsten Abschnitt,
"Wurzelzertifikatsspeicher"). Außerdem sind hier keine fremden Binärdateien im Spiel —
die DLL ist aus den offiziellen, prüfsummenverifizierten OpenSSL-Quellen gebaut, der
komplette Bauweg liegt im Repository.

Die DLL ist **statisch gelinkt**: keine `libeay32.dll`, keine `ssleay32.dll` daneben nötig.

## Wurzelzertifikatsspeicher

QCSSL prüft Serverzertifikate **nicht** gegen den Windows-Zertifikatspeicher, sondern
gegen eine Datei `rootcerts.p7b` im Eudora-Verzeichnis ([QCSSLContext.cpp:53](../../Eudora71/QCSSL/src/QCSSLContext.cpp:53)).
Sie wird über die Windows-CryptoAPI geöffnet und Zertifikat für Zertifikat in OpenSSLs
`X509_STORE` übertragen ([certstore.cpp:82](../../Eudora71/QCSSL/src/certstore.cpp:82) und
[certstore.cpp:273](../../Eudora71/QCSSL/src/certstore.cpp:273)). Geladen wird sie in
[QCSSLContext.cpp:486](../../Eudora71/QCSSL/src/QCSSLContext.cpp:486). Eine feste
Obergrenze für die Zahl der Zertifikate gibt es dabei nicht.

### Warum der Original-Speicher nicht mehr reicht

Nachgemessen am 29.08.2026 mit OpenSSL 3.5.7:

| Datei | Zertifikate | davon abgelaufen |
|---|---|---|
| `InstallersForEudora/Eudora7.1/Data/win32/rootcerts.p7b` (was der Installer verteilt) | 30 | 17 |
| `Eudora71/Bin/Release/rootcerts.p7b` (was im Build-Verzeichnis liegt) | 19 | 8 |
| **`rootcerts.p7b` aus diesem Release** | **121** | **0** |

Das neueste Zertifikat im Original-Speicher ist von **2004**. Die 13 noch gültigen sind
alte VeriSign- und GeoTrust-Wurzeln, die längst keine Serverzertifikate mehr ausstellen.
Keine der heute üblichen Stellen ist dabei — weder Let's Encrypt (ISRG Root X1) noch
Google Trust Services noch DigiCert G2.

Das ist gemessen, nicht vermutet. Vier Mailserver, jeweils mit dem Original-Speicher und
mit dem neuen als einzigem Vertrauensanker geprüft (`openssl s_client -CAfile ...`):

| Server | Original-Speicher | neuer Speicher |
|---|---|---|
| `imap.gmail.com:993` | `unable to get local issuer certificate` | **OK** |
| `outlook.office365.com:993` | `unable to get local issuer certificate` | **OK** |
| `imap.mail.yahoo.com:993` | `self-signed certificate in certificate chain` | **OK** |
| `imap.web.de:993` | `unable to get local issuer certificate` | **OK** |

Auf einer unberührten 7.1-Installation ist mit dem Original-Speicher also ein
Zertifikatsfehler zu erwarten, auch wenn die TLS-Verbindung selbst zustande kommt.

Einschränkung dieser Messung: geprüft hat OpenSSL 3.5.7 auf der Kommandozeile, nicht
Eudora. Das ist nah dran — QCSSL kippt genau diese Zertifikate in einen OpenSSL-
`X509_STORE` und lässt OpenSSL prüfen —, aber es ist nicht dasselbe.

### Woher der neue Speicher stammt

Quelle ist die **Mozilla-CA-Liste** in der Aufbereitung des curl-Projekts
(`cacert.pem`), so wie **Git für Windows 2.55.0.windows.5** sie mitliefert:

- Datei: `C:\Program Files\Git\mingw64\etc\ssl\certs\ca-bundle.crt`
- SHA256: `f345ac0d7dbd1a584dd80ff96eb2919e8dac68e962db2e7111401b434e888493`
- Inhalt: 121 Zertifikate, davon 0 abgelaufen
- Dieselbe Liste gibt es direkt bei <https://curl.se/ca/cacert.pem>

Daraus erzeugt `rootcerts-erzeugen.ps1` die Datei. Das Skript liest die PEM-Blöcke,
verwirft abgelaufene und noch nicht gültige (hier: keine), sortiert nach Fingerabdruck
— damit das Ergebnis reproduzierbar ist — und schreibt sie über
`X509Certificate2Collection.Export(Pkcs7)` heraus. Dieser Aufruf landet intern bei
`CertSaveStore(..., CERT_STORE_SAVE_AS_PKCS7, ...)`, also **derselben Systemfunktion**,
mit der Eudora den Speicher selbst zurückschreibt ([certstore.cpp:125](../../Eudora71/QCSSL/src/certstore.cpp:125)).
Das Format wird damit nicht nachgebaut, sondern von der Originalfunktion geschrieben.

Nachbauen lässt sich das so:

```
powershell -ExecutionPolicy Bypass -File rootcerts-erzeugen.ps1
```

### Was geprüft ist

- **Format:** `openssl asn1parse` weist für alte wie neue Datei denselben Typ aus,
  DER-kodiertes `pkcs7-signedData`. (Die neue Datei nutzt die lange Längenform —
  `hl=5` statt `hl=4` —, weil sie größer als 64 KB ist. Das ist reguläres DER.)
- **Lesbarkeit mit OpenSSL:** `openssl pkcs7 -inform DER -print_certs` listet
  121 Zertifikate auf.
- **Lesbarkeit auf Eudoras Weg:** derselbe Aufruf, den `CertificateStore::LoadFromFile`
  macht — `CertOpenStore(CERT_STORE_PROV_FILENAME_A, X509_ASN_ENCODING, …)` —, öffnet
  die Datei und zählt darin 121 Zertifikate.
- **Wirkung:** die vier Mailserver oben, Tabelle darüber.
- **Reproduzierbarkeit:** ein zweiter Lauf des Skripts über dieselbe Quelle liefert eine
  byte-identische Datei, SHA256 `b7b0739a8339c41944a9a4f9d72664cba207e414e0c867b869d4be48c44a62e7`.

### Was ungeprüft bleibt

**Ob Eudora selbst die Datei annimmt, ist nicht getestet.** Dafür braucht es eine
laufende Installation; das steht noch aus. Die Prüfungen oben zeigen, dass die Datei
über genau die Schnittstelle lesbar ist, die Eudora benutzt, und dass die enthaltenen
Wurzeln für aktuelle Mailserver ausreichen — mehr nicht.

Wer **HermesSSL** installiert hat, hat bereits einen aktuellen Speicher; ihn zu
ersetzen ist dann nicht nötig.

## Voraussetzung: Laufzeitbibliothek

Die **Visual C++ Redistributable für Visual Studio 2015–2022 (x86)** muss installiert
sein. Die DLL braucht daraus `mfc140.dll` und die C-Laufzeit.

Download bei Microsoft: `vc_redist.x86.exe` — die **x86**-Variante, auch auf 64-Bit-Windows.

Ob sie schon da ist, prüft man so:

```bash
dir %SystemRoot%\SysWOW64\mfc140.dll
```

Auf einem 32-Bit-Windows stattdessen `%SystemRoot%\System32\mfc140.dll`.

## Einbau

1. **Eudora beenden.**

2. Ins Eudora-Verzeichnis wechseln, üblicherweise:
   `C:\Program Files (x86)\Qualcomm\Eudora`

3. Die vorhandene `QCSSL.dll` **umbenennen**, nicht löschen:
   `QCSSL.dll` → `QCSSL.dll.original`

4. Die vorhandene `rootcerts.p7b` ebenfalls **umbenennen**, nicht löschen:
   `rootcerts.p7b` → `rootcerts.p7b.original`

   Wer HermesSSL einsetzt, kann diesen Schritt und den nächsten überspringen — dort
   liegt bereits ein aktueller Speicher.

   `usercerts.p7b` daneben bleibt unangetastet. Dort stehen die Zertifikate, denen der
   Benutzer selbst zugestimmt hat; die gehen sonst verloren.

5. `QCSSL.dll` und `rootcerts.p7b` aus diesem Verzeichnis dorthin kopieren.

6. Eudora starten und Mail abrufen.

## Zurück zum alten Stand

Falls etwas nicht funktioniert: Eudora beenden, die neue `QCSSL.dll` und die neue
`rootcerts.p7b` löschen, dann `QCSSL.dll.original` zurück in `QCSSL.dll` und
`rootcerts.p7b.original` zurück in `rootcerts.p7b` umbenennen. Damit ist der
Ausgangszustand wiederhergestellt.

Beide Dateien lassen sich auch einzeln zurücknehmen — sie hängen nicht voneinander ab.

## Was diese Version NICHT behebt

- **Die fehlerhafte Darstellung von Umlauten und Sonderzeichen.** Die steckt in
  `Eudora.exe`, nicht in einer DLL, und lässt sich nur durch einen Neubau der
  ausführbaren Datei beheben. Der ist noch nicht möglich (siehe [PORTIERUNG.md](../../PORTIERUNG.md)).
- Alles Übrige an Eudora bleibt unverändert.

## Stand der Erprobung

Die DLL ist gegen einen echten Mailserver getestet: **Abruf und Versand funktionieren.**

Zwei Einschränkungen dazu:

- Die Testinstallation hatte **HermesSSL 7.8 gamma** und damit einen aktuellen
  Wurzelzertifikatsspeicher. Dass die Zertifikatsprüfung durchlief, sagt nichts über
  eine unberührte 7.1-Installation aus (siehe den Abschnitt zum Wurzelzertifikats-
  speicher oben).
- **Ungeklärt ist, welcher Build getestet wurde.** Commit `643305d` hat die DLL um
  20:02 neu gebaut; ob davor oder danach kopiert wurde, ist nicht festgestellt. Per
  SHA256 gegen `QCSSL.dll.sha256` nachprüfbar. Der Test ist mit der aktuellen DLL zu
  wiederholen, und dabei über "Last SSL Info" zu protokollieren, welches Protokoll
  und welche Cipher-Suite ausgehandelt werden.

Im Betrieb ist kein Unterschied zu sehen — das ist beabsichtigt. Ausgetauscht wird nur
die Kryptoschicht; Oberfläche und Verhalten von Eudora bleiben unverändert. Der Gewinn
liegt in Protokoll und Wartbarkeit, nicht in sichtbaren Funktionen.

Der beiliegende **`rootcerts.p7b` ist in Eudora selbst nicht erprobt** — siehe
"Was ungeprüft bleibt" im Abschnitt zum Wurzelzertifikatsspeicher.

Trotzdem die Schritte 3 und 4 ernst nehmen und die alten Dateien aufheben.

## Herkunft

- OpenSSL 3.5.8, Quellen von `github.com/openssl/openssl`,
  SHA256 `a8f84a39918ec6415ce765d9b429d313ba97b8143169c172e734b9514464f5b2`
- Übersetzt mit Visual Studio 2022, Toolset v143, Konfiguration **`Release|x86`**.
  (Die übrige Solution wird sonst in `Debug|x86` gebaut; für QCSSL wurde zusätzlich
  der Release-Zweig gebaut, und daraus stammt diese DLL. Sie ist byte-identisch mit
  `Eudora71/Bin/Release/QCSSL.dll`.)
- Konfiguration: `VC-WIN32 no-shared no-asm no-tests no-docs no-apps /MD`
- Eudora-Quellen: Freigabe des Computer History Museum, Branch `vs2022-portierung-fixes`
- `rootcerts.p7b`: Mozilla-CA-Liste in der curl-Aufbereitung (`cacert.pem`), bezogen aus
  Git für Windows 2.55.0.windows.5, Quelldatei-SHA256
  `f345ac0d7dbd1a584dd80ff96eb2919e8dac68e962db2e7111401b434e888493`,
  umgesetzt mit `rootcerts-erzeugen.ps1` am 29.08.2026
