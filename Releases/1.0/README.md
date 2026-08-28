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
| Höchstes Protokoll | TLS 1.0 | **TLS 1.3** |
| OpenSSL-Version | 0.9.7l (2006) | 3.5.8 LTS |
| Sicherheitsupdates | seit ~2007 keine | bis 2030 |
| SSLv2 / SSLv3 | angeboten | abgeschaltet (beide gebrochen) |
| Mindestprotokoll | — | TLS 1.2 |

Gegenüber dem verbreiteten **HermSSL**-Paket: das nutzt OpenSSL 1.0.2p, seit 2019
End-of-Life und ohne TLS 1.3. Außerdem sind hier keine fremden Binärdateien im Spiel —
die DLL ist aus den offiziellen, prüfsummenverifizierten OpenSSL-Quellen gebaut, der
komplette Bauweg liegt im Repository.

Die DLL ist **statisch gelinkt**: keine `libeay32.dll`, keine `ssleay32.dll` daneben nötig.

## Voraussetzung

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

Die DLL ist gebaut und die Abhängigkeiten sind geprüft. **Ein Test gegen einen echten
Mailserver steht noch aus.** Deshalb Schritt 3 ernst nehmen und die alte Datei aufheben.

## Herkunft

- OpenSSL 3.5.8, Quellen von `github.com/openssl/openssl`,
  SHA256 `a8f84a39918ec6415ce765d9b429d313ba97b8143169c172e734b9514464f5b2`
- Übersetzt mit Visual Studio 2022, Toolset v143, `Debug|x86`-Solution, Konfiguration Release
- Konfiguration: `VC-WIN32 no-shared no-asm no-tests no-docs no-apps /MD`
- Eudora-Quellen: Freigabe des Computer History Museum, Branch `vs2022-portierung-fixes`
