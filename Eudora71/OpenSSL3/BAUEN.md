# OpenSSL 3.5 fuer QCSSL bauen

Dieses Verzeichnis enthaelt die fertigen Header und statischen Bibliotheken,
gegen die `QCSSL` gebaut wird (`QCSSL.vcxproj` verweist auf `OpenSSL3/include`
und `OpenSSL3/lib`).

Was hier liegt — Stand 28.08.2026:

| Datei | Groesse | SHA256 |
|---|---|---|
| `lib/libcrypto.lib` | 48 105 758 | `36f07446025bed9877e0e762261be7d624bec80948a3c70b63575dbdd905577e` |
| `lib/libssl.lib` | 10 007 688 | `86ac7b61cabb0af7b5b9d73bfe3223764430d2914ebedf11307adf5faa53ee06` |

Die Version steht in `include/openssl/opensslv.h:90`
(`# define OPENSSL_VERSION_STR "3.5.8"`) — dort nachsehen, nicht raten.

Wer die Bibliotheken neu erzeugen will:

## Voraussetzungen

- Visual Studio 2022 mit C++-Werkzeugen (x86)
- Ein **Windows-eigenes** Perl (Strawberry Perl). Das MSYS-Perl aus Git fuer
  Windows reicht nicht zuverlaessig.

NASM wird nicht gebraucht, weil mit `no-asm` gebaut wird.

## Schritte

Quellen holen und Pruefsumme abgleichen:

```bash
curl -L -o openssl-3.5.8.tar.gz https://github.com/openssl/openssl/releases/download/openssl-3.5.8/openssl-3.5.8.tar.gz
```

Erwartete SHA256 des Archivs:
`a8f84a39918ec6415ce765d9b429d313ba97b8143169c172e734b9514464f5b2`

```bash
sha256sum openssl-3.5.8.tar.gz
```

Der Wert stammt aus dem Lauf vom 28.08.2026 und ist hier **nicht** gegen die
Veroeffentlichung von openssl.org gegengeprueft — wer auf Nummer sicher gehen will,
holt die Pruefsumme dort.

Dann in einer **x86**-Entwicklerkonsole (`vcvars32.bat`), mit Perl im Pfad:

```bash
perl Configure VC-WIN32 no-shared no-asm no-tests no-docs no-apps /MD --prefix=<Zielverzeichnis>
```

```bash
nmake && nmake install_dev
```

Der Lauf dauerte auf der hier benutzten Zwei-Kern-Maschine etwa 25 Minuten — ein
einzelner beobachteter Wert, keine Messreihe.

## Warum diese Optionen

| Option | Grund |
|---|---|
| `no-shared` | statische Bibliotheken, damit `QCSSL.dll` ohne Begleit-DLLs auskommt |
| `no-asm` | spart NASM als Abhaengigkeit; kostet etwas Krypto-Tempo |
| `no-tests`, `no-docs`, `no-apps` | verkuerzt den Bau, wird hier nicht gebraucht |
| **`/MD`** | **wichtig.** OpenSSL nimmt fuer statische Bauten sonst `/MT`. QCSSL nutzt `/MD` bzw. `/MDd` — mischt man das, kommen zwei C-Laufzeiten in eine Binaerdatei, und das faellt erst zur Laufzeit auf. |

Nach einem Wechsel des CRT-Flags **unbedingt** alle `.obj`-Dateien loeschen:
`nmake` vergleicht nur Zeitstempel und wuerde die alten Objektdateien
stillschweigend weiterverwenden.
