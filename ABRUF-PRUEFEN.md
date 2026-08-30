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

> **UNGEPRÜFT:** ob `mx.freenet.de` bei freenet auch der POP3-Server ist. Der Name
> sieht nach einem MX-Eintrag aus. Falls Schritt 3 mit „connection refused"
> scheitert, ist der POP-Server bei freenet vermutlich `pop.freenet.de` oder
> `mx.freenet.de` auf einem anderen Port — die richtige Angabe steht in der
> Kontoübersicht bei freenet. Ich konnte das ohne Netz nicht nachsehen.

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
| „SSL negotiation failed" (`IDS_ERR_SSL_NEGOTIATION`, `QCWorkerSocket.cpp:1958`) | Der Handshake selbst ist gescheitert | Meistens `QCSSL.dll` fehlt, ist die falsche Fassung, oder eine OpenSSL-DLL daneben fehlt. Als Gegenprobe `SSLReceiveUse=0` und Port 110 — verbindet es dann, liegt es an der TLS-Schicht, nicht am Konto. |
| „Server does not support SSL" (`IDS_SSL_NOSUPPORT`, `POPSession.cpp:2144`) | `SSLReceiveUse=3` gesetzt, aber der Server bietet in `CAPA` kein `STLS` an | Auf `SSLReceiveUse=2` und Port 995 umstellen. |
| `-ERR` mit `[AUTH]` oder „authentication failed" | Benutzername oder Passwort falsch (`POPSession.cpp:1818-1878`) | `POPAccount` prüfen: muss `benutzer@server` sein, nicht die Mailadresse. Bei freenet ist der Anmeldename oft die vollständige Mailadresse — dann lautet `POPAccount` `name@freenet.de@mx.freenet.de`. |
| Verbindung kommt gar nicht zustande, Zeitüberschreitung | Falscher Server oder falscher Port | Siehe UNGEPRÜFT-Hinweis unter Schritt 1. |
| Nachricht kommt an, aber Umlaute sind kaputt | Zeichensatzpfad | Genau festhalten, was dasteht (siehe unten) — daran lässt sich die Stelle bestimmen. |

Der Zertifikatsdialog ist **nicht** notwendigerweise ein Fehler: die Prüfung ist in
dieser Fassung bewusst nachsichtig (`tools/patches/zertifikatspruefung-verschaerfen.patch`
ist absichtlich **nicht** eingespielt). Sie lässt mehr durch, als streng richtig
wäre — der Abruf wird daran also eher nicht scheitern.

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
