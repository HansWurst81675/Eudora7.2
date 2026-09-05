## E-23 — POP3 nur über Port 110, und der Anmeldefehler bei freenet

**Agent:** PORT · **Zweig:** `wt/port-2` · **Datum:** 05.09.2026 ·
**Fassung:** 7.2.0.10 · **Status:** Ursache belegt, drei Löcher gestopft

Gregors Fehlerliste vom 05.09.2026: *„POP3 nur über port 110"*. Dazu ein
Bildschirmfoto aus demselben Lauf:

```
Task Error
There has been an error transferring your mail.  I said:
    PASS <shhhh!  Don't tell anyone.>
Persona : <Dominant>
Status  : Logging into POP Server
Info    : PASS
und der POP server (adventskalender-mails@freenet.de@mx.freenet.de) said:
    ERR [AUTH] Authentication failed.
```

Beides ist nachgesehen, nicht vermutet. Es sind **zwei verschiedene Sachen**.

---

### 1. Woher der POP-Port kommt

| Stelle | Datei | was dort steht |
|---|---|---|
| Ini-Schlüssel | `Eudora71/Eudora/EudoraRes.rc:8074` | `IDS_INI_POP_PORT "POPPort"` — **ohne Vorgabewert** |
| gelesen | `Eudora71/Eudora/QCMailSettings.cpp:162` | `m_nPopPort = (int) GetIniShort(IDS_INI_POP_PORT);` |
| gereicht | `Eudora71/Eudora/QCPOPSettings.h:96` | `int GetPort(){ return m_nPopPort; }` |
| benutzt | `Eudora71/Eudora/POPSession.cpp:1723` | `UINT idPopPort = m_Settings->GetPort();` |
| verbunden | `Eudora71/QCSocket/src/QCWorkerSocket.cpp:1031` | `QCWorkerSocket::Open(..., PortNumber, DefaultPort, ...)` |

**Der gelesene Wert wird wirklich benutzt.** Er wird unterwegs *nicht* durch eine
feste 110 ersetzt. Wer `POPPort=995` von Hand in die `Eudora.ini` schreibt,
verbindet sich auch auf 995. Die Vermutung aus dem Auftrag greift hier nicht.

Trotzdem stimmt Gregors Beobachtung, und zwar aus drei Gründen:

#### 1a. Es gibt keine Oberfläche für den POP-Port

`IDS_INI_POP_PORT` kommt in `EudoraRes.rc` **genau einmal** vor — in der
STRINGTABLE. In keinem einzigen Dialog. Zum Vergleich: für IMAP gibt es das
Feld (`IDC_PORT_NUMBER`, `EudoraRes.rc:1439`), für Kerberos auch
(`IDS_INI_KERB_PORT`, `:1975`), für SMTP wenigstens das Kästchen
„Use submission port (587)" (`:527`). Für POP: nichts.

Der einzige Weg zu einem anderen Port ohne Texteditor führt über
**Tools → Options → Checking Mail → „Secure Sockets when Receiving"** und dort
den Eintrag **„Required, Alternate Port"**. Der setzt `SSLReceiveUse=2`
(`SSLSettings.h:34`, `settings.cpp:1975-1982` füllt das Auswahlfeld in genau
dieser Reihenfolge) und schaltet damit auf `SSLPOPAlternatePort`, Vorgabe 995
(`EudoraRes.rc:8151`).

#### 1b. Die stille Rückkehr auf 110

`QCWorkerSocket::Open` (`QCWorkerSocket.cpp:1067-1076`):

```c
if(PortNumber)
    SrvAddr.sin_port = QCWinSockLibMT::htons((u_short)PortNumber);
else
    SrvAddr.sin_port = GetPort(ServiceID, DefaultPort);
```

Ist `PortNumber` **0**, wird `DefaultPort` **nicht** genommen. Stattdessen
schlägt `GetPort` (`:739`) den *Dienstnamen* nach — `IDS_POP_SERVICE` ist
`"pop3"` (`EudoraRes.rc:8471`) — über `WSAAsyncGetServByName`, und das liefert
aus `%SystemRoot%\system32\drivers\etc\services` die **110**. `DefaultPort`
greift nur, wenn diese Abfrage *scheitert*.

Damit landet jede Einstellung, bei der der Port 0 wird, stillschweigend auf 110
— auch die Wahl „Required, Alternate Port", die vorher ausdrücklich
`DefaultPort = 995` gesetzt hat. Wer `SSLPOPAlternatePort=0` in der Ini stehen
hat (oder eine Persönlichkeit, die den Schlüssel leer erbt), spricht dann
**unverschlüsselt auf 110**, während die Oberfläche „Required" anzeigt.

**Behoben** in `POPSession.cpp:1736-1741` (und gleichlautend für das Senden in
`SMTPSession.cpp:702-705`): ist der Port 0, wird der vorgesehene Port erzwungen.

#### 1c. Der Kontoassistent prüft immer gegen 110

`Eudora71/AccountWizard/Src/WizardPropSheet.cpp:260`:

```c
case IDS_POP_SERVICE:	PortIniID = GetIniShort(IDS_INI_POP_PORT);  DefaultPort = 110; break;
```

Die Serverprüfung des Assistenten kennt den SSL-Alternativport **nicht**. Bei
einem Anbieter, der nur noch 995 anbietet, scheitert sie deshalb immer.
**Nicht angefasst** — die Datei gehört dem Agenten für den Kontoassistenten.

---

### 2. Der Weg für implizites TLS ist heil

Bei Port 995 muss von der ersten Nachricht an verschlüsselt werden. Der Weg ist
Zeile für Zeile abgegangen:

1. `POPSession.cpp:1732-1735` setzt Port und Vorgabe auf 995.
2. `POPSession.cpp:587` öffnet die TCP-Verbindung (`OpenPOPConnection_`).
3. `POPSession.cpp:602-605` ruft **danach und vor jedem Lesen**
   `SetSSLMode(true, ..., "POP")`.
4. `DoLogon_` → `POPAuthenticate_` (`:2088`) liest die Begrüßung mit
   `GetLine` → `Network::GetLine` (`QCWorkerSocket.cpp:203`) → `Read()`
   (`:1269`) → **`InitializeQCSSL()`**. Der Handschlag findet also **vor** der
   Begrüßung statt. Richtig.
5. `STLS` wird dabei **nicht** gesendet: `m_SSLReceiveAvailableOrAlways`
   (`SSLSettings.cpp:95`) ist nur für `SSLUseAlways` und `SSLUseIfAvailable`
   wahr, nicht für `SSLUseAlternatePort`. Auch richtig.

Der Umbau der SSL-Schicht (H-1, M-1, N-1) hat hier **nichts verloren**. Die
Versionswahl in `QCSSL/src/QCSSLContext.cpp:540-592` benutzt
`TLS_client_method()` mit `SSL_CTX_set_min_proto_version(TLS1_2_VERSION)`;
`QCSSL.vcxproj` bindet `..\OpenSSL3` **statisch** ein (in Gregors
`QCSSL.dll` steht keine Abhängigkeit auf `libcrypto-3.dll`). TLS 1.2 ist also
verfügbar. Die `libeay32.dll`/`ssleay32.dll` im Paket sind Reste des alten
0.9.7-Baums (`Eudora71/OpenSSL/crypto/opensslv.h:32`) und werden nicht mehr
geladen.

#### Ein Loch war doch da

`Network::SetSSLMode` (`QCWorkerSocket.cpp:362-386`):

```c
g_QCSSLDll = ::LoadLibrary("qcssl");
assert(g_QCSSLDll!=NULL);
if(!g_QCSSLDll)
    return;                 // <- m_bSSLMode bleibt false
```

Kein Aufrufer prüft den Ausgang — weder `POPSession.cpp:604` noch
`SMTPSession.cpp:717`. Lädt `qcssl.dll` nicht, redet Eudora danach **im
Klartext auf Port 995** weiter, bekommt einen TLS-Handschlag zurück, sieht Müll
und meldet bestenfalls „never got the banner". Kein Wort über SSL.

**Behoben**: `m_bSSLMode` wird auch auf diesem Weg gesetzt. Dann läuft der
Abruf in `InitializeQCSSL` (`:1952`) hinein, und die dort seit PR-2.1
vorhandene Prüfung meldet den Fehler sauber und bricht ab.

---

### 3. Die Ini-Seite — was Gregors Dateien wirklich enthalten

Nur gelesen, nichts geschrieben:

```
C:\Users\Gregor\Eudora72-1.0.10-release\Mailverzeichnis\Eudora.ini
C:\Users\Gregor\Eudora72-1.0.10-debug\Mailverzeichnis\Eudora.ini
```

Beide **3222 Byte, byte-gleich, unverändert seit dem 30.08.2026 17:57** — also
seit dem Auspacken. Inhalt:

```
[Settings]
NC=1
Code=NC

[Mappings]
... 120 Zeilen Dateizuordnungen ...
```

**Kein `POPAccount`, kein `POPPort`, kein `SSLReceiveUse`, kein
`SSLPOPAlternatePort`, keine `[Persona-…]`-Abschnitte.** Dasselbe gilt für die
Fassungen 1.0.8 und 1.0.9. Im gesamten Benutzerprofil gibt es keine weitere
`Eudora.ini` (`AppData\Roaming\Qualcomm\Eudora` ist leer).

Daraus folgt zweierlei:

- Was Gregor im Assistenten eingerichtet hat, ist **nie in die Ini gelangt**.
  Der Startbefehl übergibt den richtigen Pfad (`Eudora starten.cmd`, letzte
  Zeile: `start "" "%HIER%Eudora.exe" "%DATEN%"`), und E-12 hat den Fall
  „Pfad zeigt auf ein Verzeichnis" bereits geradegezogen
  (`fileutil.cpp:451-470`). Warum trotzdem nichts geschrieben wird, ist **hier
  nicht geklärt** — es gehört nicht zu Port, SSL oder Anmeldung.
- Solange nichts drinsteht, gilt: `POPPort` → `""` → `atoi` → **0**
  (`rs.cpp:503-511`, Vorgabewert wird in `persona.cpp:GetIniDefaultValue` hinter
  dem `\n` gesucht und ist bei `"POPPort"` leer) → Dienstnamensabfrage →
  **110**. Und `SSLReceiveUse` → Vorgabe `1` = „If Available, STARTTLS"
  (`EudoraRes.rc:8142`).

**Es gibt also im Auslieferungszustand keinen Weg zu einem anderen Port als
110, ohne die Ini von Hand zu bearbeiten.** Das ist Gregors Befund, wörtlich.

#### Was Gregor eintragen muss, bis es eine Oberfläche gibt

In `Mailverzeichnis\Eudora.ini`, Abschnitt `[Settings]` (für die dominante
Persönlichkeit) bzw. `[Persona-<Name>]`:

```
SSLReceiveUse=2
SSLPOPAlternatePort=995
SSLSendUse=2
SSLSMTPAlternatePort=465
```

`SSLReceiveUse=2` ist „Required, Alternate Port". Ein zusätzlich gesetztes
`POPPort=995` wird in diesem Fall **nicht** benutzt — `POPSession.cpp:1734`
überschreibt es mit `SSLPOPAlternatePort`. Das ist keine Störung, aber eine
Falle, wenn man beides setzt und nur eines ändert.

---

### 4. Der Anmeldefehler — hängt **nicht** am Port

Der Verdacht aus dem Auftrag war: Eudora kürzt `POPAccount` an der falschen
Stelle und sendet `adventskalender-mails` statt der vollen Adresse.
**Das ist nachgesehen und trifft nicht zu.**

`POPSession.cpp:2153-2160`:

```c
char szPOPUserName[128];
strcpy(szPOPUserName, m_Settings->GetPOPAccount());
char *pAtSign = strrchr(szPOPUserName, '@');
if (NULL == pAtSign) { ASSERT(0); return (-1); }
*pAtSign = 0;		// truncate the POP account at the '@' sign
```

`strrchr` sucht das **letzte** `@`. Aus
`adventskalender-mails@freenet.de@mx.freenet.de` wird damit

```
USER adventskalender-mails@freenet.de
```

— genau das, was freenet verlangt. Zum Server wird der Teil dahinter,
`mx.freenet.de` (`POPSession.cpp:1711`, ebenfalls `strrchr`).

Dazu passt das Bildschirmfoto: der Fehler kommt **nach `PASS`**, nicht nach
`USER`. Der Benutzername wurde angenommen.

#### Zu `POPSession.cpp:1747`

Die im Auftrag genannte Stelle ist **eine andere Funktion und läuft hier gar
nicht**:

```c
if (!stricmp(Server, "hesiod") && SUCCEEDED(QCHesiodLibMT::LoadHesiodLibrary()))
{
    CString LoginName(szPOPAccount);
    int At = LoginName.ReverseFind('@');
    if (At > 0)
        LoginName.ReleaseBuffer(At);      // <- Zeile 1747
```

Der Block wird nur betreten, wenn der Server **wörtlich `hesiod`** heißt. Bei
`mx.freenet.de` niemals. Der Fehler der Klasse R-1 (`ReleaseBuffer` ohne
`GetBuffer`, bei MFC 14 unzulässig) steht dort aber trotzdem, ebenso in
`SMTPSession.cpp:683`. **Beide auf `Left(At)` umgestellt** — zwei von den 25
Stellen aus R-1 sind damit erledigt.

#### Was dann?

Belegen lässt sich der Grund für `-ERR [AUTH] Authentication failed.` **nicht**
— dafür bräuchte es einen Mitschnitt. Zwei Möglichkeiten bleiben stehen:

1. **Das Kennwort ist falsch.** Naheliegend und von hier aus nicht prüfbar. Die
   Kennwortkette ist durchgesehen und in Ordnung: `GetPOPPassword_`
   (`POPSession.cpp:2848-2876`), `GetPassword` (`password.cpp:151`),
   `EncodePassword`/`DecodePassword` (`:544`/`:576`, Base64, Grenze 128
   Zeichen, `DDV_MaxChars` passt dazu). Keine Kürzung, keine Verstümmelung.
2. **Die Sitzung lief im Klartext, und freenet lehnt das mit genau dieser
   Meldung ab.** Möglich: `GetCapabilities` (`POPSession.cpp:734-786`) setzt
   `m_bSupportsSSL` nur, wenn der Server `STLS` in der `CAPA`-Liste nennt;
   nennt er es nicht (oder scheitert `CAPA`), wird bei der Voreinstellung
   „If Available" **ohne Warnung unverschlüsselt** angemeldet. Ob freenet auf
   Port 110 `STLS` ankündigt, ist von hier aus nicht feststellbar.

Eine Kleinigkeit am Rande, die zur Verwirrung beiträgt: der Kennwortdialog
zeigt als Benutzernamen `IDS_INI_LOGIN_NAME` an (`password.cpp:168`), gesendet
wird aber der gekürzte `POPAccount`. Weichen die beiden ab, steht im Dialog
etwas anderes, als über die Leitung geht.

---

### Geändert

| Datei | Zeile | was |
|---|---|---|
| `Eudora71/Eudora/POPSession.cpp` | 1736-1741 | Port 0 bei „Alternate Port" fällt nicht mehr stillschweigend auf 110 zurück |
| `Eudora71/Eudora/POPSession.cpp` | 1753 | `ReleaseBuffer(At)` → `Left(At)` (R-1) |
| `Eudora71/Eudora/SMTPSession.cpp` | 683 | `ReleaseBuffer(At)` → `Left(At)` (R-1) |
| `Eudora71/Eudora/SMTPSession.cpp` | 702-705 | Port 0 bei „Alternate Port" fällt nicht mehr auf 25 zurück |
| `Eudora71/QCSocket/src/QCWorkerSocket.cpp` | 370-380 | fehlendes `qcssl.dll` wird gemeldet, statt still im Klartext weiterzureden |

Byte-erhaltend geschrieben (Perl, `:raw`). Gemessen gegen `HEAD`: CR 18 → 18,
CRLF 18 → 18 in allen drei Dateien, keine Bytes ≥ 0x80 hinzugekommen; LF nur um
die eingefügten Zeilen gewachsen (+6, +4, +9).

### Offen — nicht angefasst

- **Der Assistent prüft POP-Server immer gegen 110** (`WizardPropSheet.cpp:260`).
  Gehört dem Agenten für den Kontoassistenten.
- **Es gibt kein Eingabefeld für den POP-Port.** Ein Feld neben „Mail Server"
  in `IDD_SETTINGS_CHECKING` wäre die saubere Lösung; das ist eine
  Oberflächenänderung und war nicht beauftragt.
- **Die `Eudora.ini` wird offenbar nicht geschrieben.** Solange das so ist,
  überlebt keine dieser Einstellungen einen Neustart. Eigener Befund, eigener
  Agent.
- **`strnicmp(szBuffer, "MANGLE", 5)`** (`POPSession.cpp:759`) vergleicht fünf
  Zeichen eines sechsbuchstabigen Wortes. Folgenlos, aber falsch.

### Bau

Beide Bauten grün, `-t:Build` (nie `Rebuild`, nie `Clean`), Projektmappe `x86`:

| Fassung | Ausgang | Protokoll | Erzeugnis |
|---|---|---|---|
| Release | `EXIT=0`, **0 Fehler**, 4824 Warnungen | kein `error C`, `error LNK` oder `error MSB` | `Eudora71/Bin/Release/Eudora.exe`, 2.935.808 Byte, 05.09.2026 23:51 |
| Debug | `EXIT=0`, **0 Fehler** | kein `error C`, `error LNK` oder `error MSB` | `Eudora71/Bin/Debug/Eudora.exe`, 10.217.472 Byte, 05.09.2026 23:58 |

Auch die Schranke `tools/pruefe-bytes.pl` läuft über den Index sauber durch,
und `tools/releasebuffer-pruefen.pl` zählt nach der Änderung zwei falsche
Stellen weniger.
