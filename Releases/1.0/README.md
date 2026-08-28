# Eudora 7.2 — Release 1.0: QCSSL mit TLS 1.3

Diese Version tauscht **eine einzige Datei** in einer bestehenden Eudora-7.1-Installation
aus und bringt sie damit auf aktuelle Verschlüsselung.

## Was drin ist

| Datei | Größe | Zweck |
|---|---|---|
| `QCSSL.dll` | 2,8 MB | Eudoras SSL/TLS-Schicht, neu gebaut gegen OpenSSL 3.5.8 LTS |
| `QCSSL.dll.sha256` | | Prüfsumme zum Abgleich |

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
Hermes bringt dafür einen aktuellen Wurzelzertifikatsspeicher mit, den dieses
Release noch nicht ersetzt (siehe den nächsten Abschnitt, "Voraussetzung: aktueller
Wurzelzertifikatsspeicher"). Außerdem sind hier keine fremden Binärdateien im Spiel —
die DLL ist aus den offiziellen, prüfsummenverifizierten OpenSSL-Quellen gebaut, der
komplette Bauweg liegt im Repository.

Die DLL ist **statisch gelinkt**: keine `libeay32.dll`, keine `ssleay32.dll` daneben nötig.

## Voraussetzung: aktueller Wurzelzertifikatsspeicher

QCSSL prüft Serverzertifikate **nicht** gegen den Windows-Zertifikatspeicher, sondern
gegen eine Datei `rootcerts.p7b` im Eudora-Verzeichnis ([QCSSLContext.cpp:53](../../Eudora71/QCSSL/src/QCSSLContext.cpp:53)).
Die von Eudora 7.1 mitgelieferte Fassung enthält **30 Zertifikate**, das neueste
ausgestellt am **04.03.2004**. Stand August 2026 sind davon **17 abgelaufen**
(nachgemessen an `InstallersForEudora/Eudora7.1/Data/win32/rootcerts.p7b`).

Diese DLL ändert daran nichts — sie liest dieselbe Datei. Mit dem Original-Speicher
ist deshalb trotz funktionierendem TLS ein Zertifikatsfehler ("unknown root") zu
erwarten. Ungeprüft: ob es in der Praxis tatsächlich dazu kommt — das hängt davon ab,
welche der 13 noch gültigen Wurzeln der jeweilige Mailserver nutzt. Wer **HermesSSL** installiert hat, ist versorgt: dessen
Paket bringt eine aktuelle `rootcerts.p7b` mit, und die bleibt beim Austausch der
`QCSSL.dll` liegen.

Ein eigener, aktueller Speicher liegt diesem Release noch nicht bei.

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

4. Die `QCSSL.dll` aus diesem Verzeichnis dorthin kopieren.

5. Eudora starten und Mail abrufen.

## Zurück zum alten Stand

Falls etwas nicht funktioniert: Eudora beenden, die neue `QCSSL.dll` löschen,
`QCSSL.dll.original` zurück in `QCSSL.dll` umbenennen. Damit ist der Ausgangszustand
wiederhergestellt.

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

Trotzdem Schritt 3 ernst nehmen und die alte Datei aufheben.

## Herkunft

- OpenSSL 3.5.8, Quellen von `github.com/openssl/openssl`,
  SHA256 `a8f84a39918ec6415ce765d9b429d313ba97b8143169c172e734b9514464f5b2`
- Übersetzt mit Visual Studio 2022, Toolset v143, Konfiguration **`Release|x86`**.
  (Die übrige Solution wird sonst in `Debug|x86` gebaut; für QCSSL wurde zusätzlich
  der Release-Zweig gebaut, und daraus stammt diese DLL. Sie ist byte-identisch mit
  `Eudora71/Bin/Release/QCSSL.dll`.)
- Konfiguration: `VC-WIN32 no-shared no-asm no-tests no-docs no-apps /MD`
- Eudora-Quellen: Freigabe des Computer History Museum, Branch `vs2022-portierung-fixes`
