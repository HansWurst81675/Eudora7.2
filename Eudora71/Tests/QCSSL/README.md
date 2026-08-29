# Komponententest der TLS-Schicht (QCSSL)

Dieses Verzeichnis enthaelt einen eigenstaendigen Test fuer Eudoras SSL/TLS-
Schicht. Es wird nichts ausserhalb dieses Verzeichnisses veraendert; weder
`Eudora.sln` noch `QCSSL.vcxproj` werden angefasst.

## Was gemessen wird

1. Verhalten bei ungueltigen Zertifikaten (abgelaufen, selbstsigniert,
   falscher Hostname, unbekannte Wurzel)
2. Welches Protokoll ausgehandelt wird und ob TLS 1.0/1.1 abgelehnt werden
3. Welche Cipher Suites angeboten und ausgewaehlt werden

## Zwei Messwege

| Programm | Was es misst |
|---|---|
| `bin\tlstest.exe` | linkt direkt gegen `Eudora71\OpenSSL3\lib` und bildet `SetSSLVersion()`, `SetCipherSuites()`, `SetupCertificates()` und `CertificateCallback()` nach. Enthaelt zusaetzlich den Zertifikatsgenerator und die lokalen Testserver. |
| `bin\qcsslprobe.exe` | laedt die ausgelieferte `QCSSL.dll` und ruft `QCSSLBeginSession()` auf. Misst den echten Produktivpfad. |

`qcsslprobe.exe` braucht keine laufende Eudora-Instanz: `QCSSLReference` ist
eine einfache Struktur, und die Socket-Ein-/Ausgabe laeuft ueber zwei
Rueckruffunktionen, die der Test selbst bereitstellt. Erforderlich ist nur,
dass der Test mit denselben Einstellungen gebaut wird wie `QCSSL.vcxproj`:
**x86, MFC dynamisch, MBCS, /MD**. Sonst passt die Speicherdarstellung der
MFC-Klassen ueber die DLL-Grenze nicht.

## Bauen

```
.\bauen.bat
```

Das Skript sucht Visual Studio ueber `vswhere`, richtet die x86-Umgebung ein
und ruft `cl.exe` nur fuer die beiden Quelldateien unter `src\` auf. Ergebnis
liegt in `bin\`.

## Ausfuehren

Kompletter Lauf, nur lokal (kein Netz noetig):

```
powershell -ExecutionPolicy Bypass -File .\messen.ps1
```

Zusaetzlich Gegenprobe im Netz gegen badssl.com (nur TLS-Handshakes, keine
Nutzdaten, keine Anmeldung):

```
powershell -ExecutionPolicy Bypass -File .\messen.ps1 -Badssl
```

Protokolle landen in `work\`.

### Einzelaufrufe

```
bin\tlstest.exe gen     work
bin\tlstest.exe servers work
bin\tlstest.exe client  work --local
bin\tlstest.exe client  work --local --minproto tls1
bin\tlstest.exe client  ..\..\Bin\Release --badssl
bin\qcsslprobe.exe ..\..\..\Releases\1.0\QCSSL.dll work localhost 14431 0 "Fall 1a"
```

`--minproto tls1` entspricht `ProtocolInfo::m_ProtocolVersion == 3`.
`--seclevel <n>` weicht bewusst von QCSSL ab und dient nur der
Ursachenklaerung bei den Versionstests.

## Lokale Testserver

| Port | Zertifikat | Protokoll |
|---|---|---|
| 14431 | gueltig, von der Test-CA signiert, CN=localhost | frei |
| 14432 | abgelaufen | frei |
| 14433 | CN=falsch.example.com | frei |
| 14434 | selbstsigniert | frei |
| 14435 | gueltig | nur TLS 1.0 |
| 14436 | gueltig | nur TLS 1.1 |
| 14437 | gueltig | nur TLS 1.2 |
| 14438 | gueltig | nur TLS 1.3 |

Die Server lauschen ausschliesslich auf `127.0.0.1`. Die Sicherheitsstufe wird
nur auf der Serverseite abgesenkt, damit TLS 1.0/1.1 ueberhaupt angeboten
werden koennen; der Client behaelt die Vorgaben, weil genau die gemessen
werden sollen.
