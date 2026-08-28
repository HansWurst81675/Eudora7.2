# OpenSSL 3.5 fuer QCSSL bauen

Dieses Verzeichnis enthaelt die fertigen Header und statischen Bibliotheken,
gegen die `QCSSL` gebaut wird. Wer sie neu erzeugen will:

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

Erwartete SHA256: `a8f84a39918ec6415ce765d9b429d313ba97b8143169c172e734b9514464f5b2`

Dann in einer **x86**-Entwicklerkonsole (`vcvars32.bat`), mit Perl im Pfad:

```bash
perl Configure VC-WIN32 no-shared no-asm no-tests no-docs no-apps /MD --prefix=<Zielverzeichnis>
```

```bash
nmake && nmake install_dev
```

Der Lauf dauert auf einer Zwei-Kern-Maschine etwa 25 Minuten.

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
