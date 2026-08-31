# Mail abrufen — Prüfanleitung

Für Kriterium 3 aus `ZIEL.md`. Reihenfolge einhalten, sie ist danach gebaut, dass
jeder Schritt sein eigenes Ergebnis zeigt.

Gilt für die dominante Persönlichkeit `<Dominant>`. Deren Einstellungen stehen in
`Eudora.ini` im Abschnitt `[Settings]` (belegt: `persona.cpp:879` und `:898`).

---

## 1. Eudora.ini

Eudora beenden. Dann in `Eudora.ini` unter `[Settings]` diese Zeilen setzen
(vorhandene gleichnamige Zeilen ersetzen, nicht doppelt anlegen):

```ini
[Settings]
LoginName=DEIN-BENUTZERNAME
POPAccount=DEIN-BENUTZERNAME@mx.freenet.de
RealName=Gregor
ReturnAddress=DEIN-BENUTZERNAME@freenet.de
SMTPServer=mx.freenet.de
SmtpAuthAllowed=1

; Empfang: implizites TLS auf Port 995
SSLReceiveUse=2
SSLPOPAlternatePort=995

; Versand: implizites TLS auf Port 465
SSLSendUse=2
SSLSMTPAlternatePort=465
```

`POPAccount` ist immer `Benutzername@Server` — Eudora setzt es aus `LoginName`
und dem POP-Server zusammen (`settings.cpp:1339-1380`) und zerlegt es beim Abruf
wieder am `@` (`POPSession.cpp:1711`).

**Die Werte von `SSLReceiveUse` / `SSLSendUse`** (Reihenfolge der Auswahlliste,
`settings.cpp:1975-1978`, Aufzählung `SSLSettings.h:30-35`):

| Wert | Bedeutung | Port |
|---|---|---|
| 0 | nie | 110 |
| 1 | falls verfügbar — STARTTLS, fällt auf Klartext zurück | 110 |
| **2** | **erforderlich, eigener Port — TLS von der ersten Sekunde an** | **995** |
| 3 | erforderlich — STARTTLS, bricht ab wenn der Server es nicht kann | 110 |

**2 ist die Empfehlung für den ersten Versuch.** Damit wird die Verbindung sofort
verschlüsselt aufgebaut (`POPSession.cpp:602-605`), noch bevor irgendein Passwort
über die Leitung geht. Bei 1 und 3 schickt Eudora erst `CAPA`, dann `STLS`
(`POPSession.cpp:2130-2143`) — ein Schritt mehr, der schiefgehen kann.

### Welcher Servername? — beantwortet

> **Erledigt am 31.08.2026 (Befund E-3): `mx.freenet.de` spricht POP3**, und
> zwar auf **Port 110 mit STARTTLS**. Gregor hat darüber 159 Nachrichten
> abgerufen, `TLSv1.3` / `TLS_AES_256_GCM_SHA384`, abgelesen in
> *Tools → Last SSL Info*. Der Verdacht, es sei nur ein MX-Eintrag für die
> Zustellung, war unbegründet.
>
> **Das ist nicht der Weg, den diese Anleitung unten empfiehlt** (Port 995,
> implizites TLS). Beide funktionieren. Belegt ist **Port 110 mit STARTTLS** —
> das entspricht `SSLReceiveUse=1` oder `=3`; **welchen der beiden Werte Gregor
> gesetzt hatte, ist nicht festgehalten** und lässt sich nachträglich nur aus
> seiner `Eudora.ini` ablesen. Die Tabelle darunter bleibt stehen, weil sie den
> zweiten Weg und die Fehlersuche beschreibt.

Es gibt genau zwei Möglichkeiten. **Woran du merkst, welche zutrifft:**

| Was passiert | Welcher Fall | Was tun |
|---|---|---|
| Eudora fragt nach dem Passwort, danach kommt eine Antwort vom Server — egal ob Erfolg oder `-ERR` | **`mx.freenet.de` ist auch der POP-Server.** Es horcht auf 995. | Nichts. Weiter bei Schritt 4. |
| Es kommt gar nichts: Zeitüberschreitung, „connection refused", oder Eudora hängt in „Connecting…" und bricht dann ab. **Kein** Passwortdialog, **kein** Zertifikatsdialog, „Last SSL Info" bleibt leer | **Falscher Name oder falscher Port.** Auf 995 horcht dort nichts. | Zweiter Versuch mit `pop.freenet.de`, siehe unten. |

Das unterscheidende Merkmal ist der **Passwortdialog**. Er kommt erst, nachdem die
TCP-Verbindung steht und (bei `SSLReceiveUse=2`) TLS ausgehandelt ist
(`POPSession.cpp:602-605`, dann `POPAuthenticate_` ab `:2047`). Kommt er, ist
Name und Port richtig — alles Weitere ist dann ein anderes Problem.

**Zweiter Versuch, wenn kein Passwortdialog kam.** Eudora beenden, in
`Eudora.ini` unter `[Settings]` beide Zeilen ändern:

```ini
PopServer=pop.freenet.de
POPAccount=DEIN-BENUTZERNAME@pop.freenet.de
```

`POPAccount` **muss** mitgeändert werden: Eudora zerlegt es beim Abruf am `@` und
nimmt den Teil dahinter als Servernamen (`POPSession.cpp:1711`). `PopServer`
allein reicht nicht.

**Dritter Versuch, falls auch das nichts bringt:** wahrscheinlich kann das Konto
gar kein POP3 (bei manchen Anbietern muss der Zugriff „für externe
Mailprogramme" im Webportal erst freigeschaltet werden). Das ist dann kein
Eudora-Problem — die richtige Angabe steht in der Kontoübersicht bei freenet.

## 2. Was daneben liegen muss

Im selben Verzeichnis wie `Eudora.exe`:

- `QCSSL.dll` — Prüfsumme muss mit `ab55281a` beginnen (QCSSL 1.0.1)
- `rootcerts.p7b` — der Wurzelzertifikatsspeicher, 121 Zertifikate

Prüfen:

```
certutil -hashfile QCSSL.dll SHA256
```

Liegt eine andere Fassung da, die aus `Releases/1.0/` darüberkopieren. Welche
Fassung was kann, steht in `Releases/1.0/AUSLIEFERUNGEN.md`.

## 3. Abruf auslösen

Eudora starten, dann **File → Check Mail** (oder Strg+M).

Eudora fragt nach dem Passwort. Das Passwort geht bei `SSLReceiveUse=2` erst raus,
nachdem TLS steht.

## 4. Was zu sehen sein muss, wenn es geklappt hat

**a) Die Statuszeile** zählt die Nachrichten durch und endet ohne Fehlerdialog.

**b) Der Postfacheintrag** erscheint in `In`. Betreff und Absender müssen lesbar
sein — **keine** Zeichenketten der Form `=?UTF-8?B?…?=` und keine Folgen wie `Ã¼`
statt `ü`. Die Nachricht öffnen: Umlaute im Text müssen richtig stehen, und am
Zeilenende darf kein Rest hängen.

**c) Die SSL-Auskunft** — das ist der eigentliche Beleg:

> **Tools → Options → Checking Mail → Knopf „Last SSL Info"**

(Es ist ein Knopf in der Einstellungsseite, kein Menüpunkt. Für den Versand steht
derselbe Knopf unter *Sending Mail*.)

Dort muss stehen:

| Feld | erwartet |
|---|---|
| Protokollversion | `TLSv1.3`, notfalls `TLSv1.2` |
| Verfahren (Cipher) | ein AEAD-Verfahren, z. B. `TLS_AES_256_GCM_SHA384` |

**`TLSv1.0` oder `TLSv1.1` darf dort nicht stehen.** Die neue Schicht setzt für
*alle* Einstellungen TLS 1.2 als Untergrenze (Befund M1). Steht dort etwas
Älteres, stimmt etwas mit der geladenen `QCSSL.dll` nicht.

Zum Vergleich: der letzte erfolgreiche Abruf (29.08., `pop.gmx.net`, mit der
älteren Fassung `c875a750`) zeigte `TLSv1.3` / `TLS_AES_256_GCM_SHA384`.

**Bitte diese zwei Zeilen abschreiben oder fotografieren** — sie sind der Nachweis
für Kriterium 3.

## 5. Die häufigsten Fehlermeldungen

| Meldung / Verhalten | Bedeutung | Was tun |
|---|---|---|
| Dialog mit Zertifikatstext und einem Ablehnungsgrund (*CTrustCertDlg*, `QCTaskManager.cpp:695`) | Das Serverzertifikat ließ sich nicht bis zu einer bekannten Wurzel zurückverfolgen | Text notieren. „OK" nimmt das Zertifikat dauerhaft an. **Vorher den Text melden**, denn er sagt, ob `rootcerts.p7b` gefunden wurde. |
| „SSL Negotiation Failed: …" (`IDS_ERR_SSL_NEGOTIATION`, `QCWorkerSocket.cpp:1959`) | Der Handshake selbst ist gescheitert | **Siehe Abschnitt 5a** — der Text hinter dem Doppelpunkt sagt, warum. |
| Eudora verschwindet beim Abruf kommentarlos, ohne Dialog | War bis 31.08. der wahrscheinlichste Absturz: ein NULL-Zeiger nach gescheiterter SSL-Aushandlung (`QCWorkerSocket.cpp:1969`, Befund P-1.5a) | **Behoben** (Befund P-2.1). Stürzt es trotzdem ab, ist es *nicht* diese Stelle — dann bitte melden, mit dem Zeitpunkt. |
| „Server does not support SSL" (`IDS_SSL_NOSUPPORT`, `POPSession.cpp:2144`) | `SSLReceiveUse=3` gesetzt, aber der Server bietet in `CAPA` kein `STLS` an | Auf `SSLReceiveUse=2` und Port 995 umstellen. |
| `-ERR` mit `[AUTH]` oder „authentication failed" | Benutzername oder Passwort falsch (`POPSession.cpp:1818-1878`) | `POPAccount` prüfen: muss `benutzer@server` sein, nicht die Mailadresse. Bei freenet ist der Anmeldename oft die vollständige Mailadresse — dann lautet `POPAccount` `name@freenet.de@mx.freenet.de`. |
| Verbindung kommt gar nicht zustande, Zeitüberschreitung | Falscher Server oder falscher Port | Siehe UNGEPRÜFT-Hinweis unter Schritt 1. |
| Nachricht kommt an, aber Umlaute sind kaputt | Zeichensatzpfad | Genau festhalten, was dasteht (siehe unten) — daran lässt sich die Stelle bestimmen. |

Der Zertifikatsdialog ist **nicht** notwendigerweise ein Fehler: die Prüfung ist in
dieser Fassung bewusst nachsichtig (`tools/patches/zertifikatspruefung-verschaerfen.patch`
ist absichtlich **nicht** eingespielt). Sie lässt mehr durch, als streng richtig
wäre — der Abruf wird daran also eher nicht scheitern.

## 5a. „SSL negotiation failed" — im Einzelnen

Wortlaut: **`SSL Negotiation Failed: <Grund>`**, gefolgt von
`Cause: … (<Zahl>)`. Zusammengesetzt in `QCWorkerSocket.cpp:1959`, ausgegeben
über `SetError` → `ReportError` (`:680` und `:713`).

**Es bedeutet immer dasselbe:** die TCP-Verbindung stand, aber der TLS-Handshake
kam nicht zustande. Was *danach* steht, sagt warum.

| Was hinter dem Doppelpunkt steht | Bedeutung | INI-Zeile |
|---|---|---|
| `no details available from the SSL layer. …` | Die SSL-Schicht hat gar kein Ergebnis abgeliefert. Fast immer: `QCSSL.dll` fehlt, ist die falsche Fassung, oder eine OpenSSL-DLL daneben fehlt. **Das ist der Text, den ich neu eingebaut habe** — vorher stürzte Eudora an dieser Stelle ab. | Erst Schritt 2 nachprüfen. Wenn die DLLs stimmen: `SSLReceiveUse=0` als Gegenprobe. |
| `Certificate Error: …` (irgendetwas mit *Certificate*) | Kein Handshake-Problem, sondern ein Zertifikatsproblem. Siehe 5b. | siehe 5b |
| gar nichts, nur `Cause: (…)` | Der Server hat die Verbindung mitten im Handshake zugemacht. Meist: auf diesem Port wird kein TLS gesprochen. | `SSLReceiveUse=3` und `SSLPOPAlternatePort` entfernen (STARTTLS auf 110), oder Servername prüfen (Schritt 1). |

**Die Gegenprobe, die alles auseinanderhält.** Eudora beenden, in `Eudora.ini`:

```ini
SSLReceiveUse=0
```

und `SSLPOPAlternatePort` auskommentieren oder auf `110` setzen. Dann läuft der
Abruf im Klartext über Port 110.

- **Es klappt jetzt** → Konto, Passwort und Server sind richtig, das Problem
  liegt allein in der TLS-Schicht.
- **Es klappt immer noch nicht** → das Problem liegt nicht bei TLS, sondern bei
  Servername, Port oder Zugangsdaten.

> Danach **unbedingt zurückstellen** auf `SSLReceiveUse=2` und
> `SSLPOPAlternatePort=995`. Bei `0` geht das Passwort im Klartext über die
> Leitung.

## 5b. Zertifikatsfehler — welcher Text heißt was

Alle diese Texte erzeugt `qccertificate.cpp` (Zeilen 60–140) und legt sie in
`m_Outcome.m_Errors` ab; angezeigt werden sie im Vertrauensdialog *CTrustCertDlg*
oder als Anhang an „SSL Negotiation Failed". Die Textbausteine stehen in
`Eudora71/QCSSL/src/qcssl.rc:56-70`.

| Text im Dialog | OpenSSL-Ursache | Bedeutung | Was tun / INI-Zeile |
|---|---|---|---|
| **`Certificate Error: Cert Chain not trusted.`** | `X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY` — auf Englisch **„unable to get local issuer certificate"** | Das Serverzertifikat ist in Ordnung, aber die ausstellende Stelle steht **nicht in `rootcerts.p7b`**. Entweder fehlt die Datei ganz, oder sie ist zu alt für die heutige CA von freenet. `qccertificate.cpp:82-89` | **Keine INI-Zeile hilft.** Erst prüfen, ob `rootcerts.p7b` überhaupt gefunden wird — siehe unten. Notfalls im Dialog „OK": das trägt das Zertifikat dauerhaft in `usercerts.p7b` ein und die Meldung kommt nicht wieder. |
| **`Certificate Error: Unknown and unprovided root certificate.`** | `X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT` / `…SELF_SIGNED_CERT_IN_CHAIN` | Das Zertifikat ist selbstsigniert. Bei einem echten Anbieter wie freenet heißt das fast sicher: du bist nicht beim richtigen Server. | Servername prüfen (Schritt 1). **Nicht** einfach „OK" drücken. |
| **`One certificate in the server cert chain has Expired`** | `X509_V_ERR_CERT_HAS_EXPIRED` / `…NOT_YET_VALID` | Ein Zertifikat in der Kette ist abgelaufen — oder **die Uhr des Rechners geht falsch**. | Erst Systemdatum prüfen. Wenn die stimmt: `SSLReceiveIgnoreExpCert=1` unter `[Settings]`. Danach wieder auf `0`. |
| **`Certificate Error: Data not found`** | `X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT` u. a. | Die Kette ist unvollständig oder unlesbar. | Wie „Cert Chain not trusted": `rootcerts.p7b` prüfen. |
| **`Certificate Error: No Certificates Received from Server during SSL negotiation`** | — | Der Server hat überhaupt kein Zertifikat geschickt. Auf dem Port wird kein TLS gesprochen. | `SSLPOPAlternatePort` prüfen; bei Port 110 gehört `SSLReceiveUse=3` (STARTTLS), nicht `2`. |

**Nicht in der Liste:** `X509_V_ERR_CERT_UNTRUSTED` und
`X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE` werden in `qccertificate.cpp:110-112`
**stillschweigend als Erfolg gewertet** (`iOK = 1`). Diese beiden Fälle siehst du
also nie — genau das ist es, was der zurückgestellte Patch ändern würde.

**Wird `rootcerts.p7b` überhaupt gefunden?** Eudora sucht in **zwei**
Verzeichnissen: dem Eudora-Datenverzeichnis (wo `Eudora.ini` liegt) **und** dem
Verzeichnis von `Eudora.exe` (`SSLSettings.cpp:88`:
`m_InputCertsDir = EudoraDir + "\r\n" + ExecutableDir`). Der Dateiname ist fest
verdrahtet: `rootcerts.p7b` (`QCSSLContext.cpp:53`). Sicherheitshalber in
**beide** Verzeichnisse legen. Ein Fehlen wird **nicht** eigens gemeldet — es
äußert sich genau als „Cert Chain not trusted".

## 6. Wenn es scheitert — was ich brauche

1. **Den genauen Wortlaut** der Meldung, Zeichen für Zeichen. Ein Bildschirmfoto
   des Dialogs ist ideal.
2. **An welcher Stelle** es abbricht: schon beim Verbinden, nach der
   Passwortabfrage, beim Zählen der Nachrichten, oder erst beim Anzeigen?
3. **Den Inhalt von „Last SSL Info"** — auch wenn er leer ist. Leer heißt: es kam
   nie ein Handshake zustande.
4. Bei kaputten Umlauten: den betroffenen **Betreff und eine Textzeile** so, wie
   Eudora sie zeigt, und dazu die Zeile `Content-Type:` aus der Rohfassung
   (**Blue Ribbon**-Knopf oder *Message → Show Original*).
5. Ob es mit `SSLReceiveUse=0` / Port 110 anders läuft (nur als Gegenprobe, das
   überträgt das Passwort im Klartext — danach wieder zurückstellen).
