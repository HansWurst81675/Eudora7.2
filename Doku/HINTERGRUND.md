# Technischer Hintergrund

Zurück zum [Einstieg](../README.md).

## Wo die Grenzen liegen — und warum sie bleiben

Drei Dinge lassen sich an diesem Programm **nicht** durch Nachbessern beheben.
Sie hängen an der Bauart von 2006, und wer die Fassung einsetzt, sollte sie
kennen.

### 1. Das Verfassenfenster kennt kein CSS

Eudora benutzt **zwei** verschiedene Motoren für HTML:

| | wofür | was er kann |
|---|---|---|
| **MSHTML** (Trident, der Motor des Internet Explorer) | die **Leseansicht** | vollständiges HTML von 2006 — Kästen, Hintergründe, Bildgrößen |
| **Paige** | das **Verfassenfenster** | ein eigenes Textformat, **keine einzige CSS-Eigenschaft** |

Deshalb sieht dieselbe Nachricht beim **Lesen** richtig aus und im
**Verfassenfenster** schlicht. Paiges HTML-Leser führt in `PGHTMDEF.C:20-48`
auf, was er versteht; CSS kommt darin nicht vor. Bildgrößen liest er nur aus
den Attributen `width` und `height`, nicht aus `style="width:…"`.

Seit der Fassung 7.2.0.56 geht beim Senden das **aufgehobene Original** hinaus
statt der Editorfassung (Befund [**E-88**](../BEFUNDE.md#e-88)). Was im Verfassenfenster fehlt, fehlt
also nicht beim Empfänger — das Fenster ist Arbeitsfläche, nicht Vorschau.

### 2. Emoji lassen sich nicht anzeigen

Eudora ist durchgehend **ANSI** gebaut: Mailboxen, Kopfzeilen, die
Nachrichtenliste. Der Zeichensatz Windows-1252 kennt 256 Zeichen und darunter
kein einziges Emoji. Beim Umwandeln entstand früher Bytesalat, dann ein
Fragezeichen je Emoji-Hälfte (`??`), seit 7.2.0.59 fallen sie ersatzlos weg
([**E-90**](../BEFUNDE.md#e-90)). Kyrillisch, Griechisch und Polnisch bleiben erhalten, soweit die
Ersetzungstabelle von Windows sie abbilden kann.

### 3. Was ein Austausch des Motors kosten würde

Die naheliegende Frage lautet: warum nicht eine moderne Bibliothek einsetzen,
statt weiter nachzubessern? Gemessen am 14.09.2026:

```
Paige-Anbindung in Eudora:   13.146 Zeilen, 36 Dateien, 188 Funktionen
MSHTML-Anbindung:             8.637 Zeilen,  9 Dateien
IHTMLDocument2 in TridentView:   13 Stellen
designMode / contentEditable:     0 Stellen
```

Die beiden unteren Zahlen sind am 15.09.2026 nachgemessen und stimmen:

```bash
grep -c IHTMLDocument2 Eudora71/Eudora/TridentView.cpp                    # 13
grep -rl 'designMode\|contentEditable' Eudora71/Eudora/                  # leer
```

**Für die beiden oberen ist der Messbefehl nicht aufgeschrieben worden**, und
sie lassen sich deshalb nicht nachvollziehen — je nachdem, was man zur
„Anbindung" zählt, kommen sehr verschiedene Werte heraus (Dateien mit
`Pg`-Präfix: 46; `.cpp`, die `paige` oder `pg_ref` nennen: 60 mit 104.606
Zeilen). Als **Größenordnung** taugen sie, als Beleg nicht. Wer sie das nächste
Mal braucht, schreibt den Befehl daneben.

**MSHTML im Editiermodus** wäre der naheliegendste Weg: Der Motor liegt bereits
im Programm und rendert die Leseansicht. Er kann auch editieren
(`document.designMode = "On"`) — im Original ist das an **null** Stellen
benutzt. Er steckt in jedem Windows, braucht keine Installation und wirft keine
Lizenzfrage auf. Modernes CSS kann er allerdings nicht: Flexbox, Grid und
`border-radius` sind ihm fremd; für Newsletter-HTML aus Tabellenlayout reicht er.
Der Umbau beträfe den Editorkern — grob 4.000 bis 5.000 der 13.146 Zeilen —,
und danach stünde die Frage an, wie Eudora Stile, Signaturen und Zitatmarken
speichert. Realistisch: **einige Wochen**, nicht Tage.

**WebView2 (Edge/Chromium)** wäre technisch das Beste: echtes modernes HTML,
echte Emoji. Aber die Laufzeit muss auf dem Zielrechner installiert sein, rund
100 MB — damit fiele Kriterium 0 aus [ZIEL.md](../ZIEL.md) (*startet ohne
Nachinstallation*). Chromium direkt einzubetten kostet etwa 150 MB Paketgröße.

**Was kein Motorwechsel löst:** Emoji im Betreff und in der Nachrichtenliste.
Die hängen nicht am Editor, sondern an der ANSI-Bauart der ganzen Anwendung.
Dafür bräuchte es eine Unicode-Umstellung — ein eigenes Vorhaben.


## Technischer Hintergrund

### Wie portiert wurde

Der Quellcode ist von 1996–2006 und stammt aus der Zeit von Visual C++ 6.
Repariert wurden im Wesentlichen acht wiederkehrende Muster — Deklarationen
ohne Rückgabetyp, entfernte Header, alte `for`-Scope-Regeln, die
`const char*`-Überladungen von `strchr`/`strstr`/`strrchr`, `std::auto_ptr`
und Iteratoren-als-Zeiger, MFC-`const`-Overloads, Namenskollisionen mit
winsock2 und der UCRT, dazu drei Projekteinstellungen. Jedes Muster mit den
betroffenen Stellen und der Begründung: **[PORTIERUNG.md](../PORTIERUNG.md)**,
Abschnitt *Angewandte Korrekturen*.

Getrennt davon steht die Portierung von QCSSL auf die **OpenSSL-3.x-API**:
0.9.7l von 2006 kannte noch offene Strukturen, 3.x kapselt sie hinter
Zugriffsfunktionen. Betroffen waren vor allem die BIO-Schicht und
`QCSSLContext.cpp`.

### Die Ersatzschicht für Stingray OT501

`Eudora.exe` linkte gegen **Stingray Objective Toolkit 5.0.1**, eine kommerzielle
MFC-Erweiterung von 1995. Die CHM-Freigabe durfte nur Qualcomm-eigenen Code
enthalten — von OT501 sind deshalb nur die 127 Header unter
`Eudora71/OT501/Include` übrig; von den Quelldateien der `SEC*`-Klassen fehlt
alles, im Baum liegen nur noch mitgelieferte Fremdteile (JPEG, zlib). Eine
fertige Binärdatei von damals hilft nicht: mit VC6 gegen MFC 4.21 übersetzt,
verlinkt sie sich nicht mit VS 2022.

Eudora baut darauf sein komplettes Fenstergerüst auf — `CMainFrame` erbt über
`QCWorkbook` von `SECWorkbook`; insgesamt leitet Eudora an 30 Stellen von
22 Stingray-Klassen ab und ruft 77 Methoden auf. **42** Quelldateien und
**28** Header unter `Eudora71/Eudora` nennen mindestens einen
Stingray-Bezeichner (gezählt am 06.09.2026: Dateien, in denen ein Bezeichner
der Form `SEC<Grossbuchstabe>…` mit mindestens einem Kleinbuchstaben vorkommt —
das trennt die Stingray-Klassen von den gleichnamigen SSPI-Konstanten
`SECBUFFER_*`).

**Gewählter Weg und heutiger Zustand:** eine eigene Ersatzschicht auf modernes
MFC, `Eudora71/OTShim/`, in fünf Teilen über `OTShimAll.h` eingebunden.
`Eudora.exe` bindet damit ohne Stingray, **0 ungelöste Externe**; das Projekt
`OT501` ist ganz aus dem Bau genommen (Befund [B-3](../BEFUNDE.md#b-3)), die frühere Attrappe
`Lib/Debug/OTA50D.LIB` entfällt und **darf nicht wieder angelegt werden** —
sonst linkt Eudora gegen eine leere Bibliothek.

Ein naheliegender Irrtum, der schon zweimal Arbeit gekostet hat: die
Registerkartenleiste ist **nicht** verzichtbar — abschaltbar ist nur der
MDI-Streifen. Warum, steht in [PORTIERUNG.md](../PORTIERUNG.md) unter *Blocker:
OT501*.

Bestandsaufnahme: [Eudora71/OTShim/INVENTAR.md](../Eudora71/OTShim/INVENTAR.md) —
Umsetzungsplan mit Stufen und Belegen:
**[Eudora71/OTShim/PLAN.md](../Eudora71/OTShim/PLAN.md)**

Ein Rest bleibt behelfsmäßig: `__imp___iob` aus `libpng.lib` definiert
`OTShim_Libpng.cpp` als `(char*)stderr - 2*32`, weil libpng 1.2.7 nur `_iob[2]`
anfasst und die damalige CRT 32 Byte je Element hatte. Das trägt, ist aber eine
Annahme; sauber wäre ein Neubau von libpng aus `Eudora71/PNG/libpng` mit v143.

### TLS 1.3 statt SSL 3.0

`QCSSL.dll` ist gegen **OpenSSL 3.5.8 LTS** gebaut, Mindestprotokoll TLS 1.2 für
alle acht Einstellungen von `m_ProtocolVersion`. Eine Obergrenze wird bewusst an
keiner Stelle gesetzt — `SSL_CTX_set_max_proto_version()` kommt in QCSSL nicht
vor, damit stets das höchste beiderseits unterstützte Protokoll ausgehandelt
wird. SSLv2 und SSLv3 sind abgeschaltet.

Gemessen: TLS 1.3 im Komponententest gegen einen lokalen Server, am 29.08.2026
gegen `pop.gmx.net:995` und am 06.09.2026 im selbst gebauten Eudora über
Port 995 (`Negotiation Status: Succeeded`).

**Seit 7.2.0.48 wird eine Kette geprüft, die sich nicht verifizieren lässt.**
Bis dahin behandelte der Verifikations-Callback zwei OpenSSL-Prüffehler als
Erfolg (`X509_V_ERR_CERT_UNTRUSTED` und
`X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE`): er setzte `iOK = 1` und sagte
OpenSSL damit ausdrücklich *„Zertifikat in Ordnung"* — ohne Fehlercode, ohne
Warnung, ohne dass der Anwender etwas sah. Jetzt wird die Verbindung
abgelehnt und `IDS_CERTERR_CHAINNOTTRUSTED` gemeldet.

**Was das für den Betrieb heißt:** Eudora lehnt Verbindungen ab, die es vorher
klaglos annahm. Wer ein bestimmtes Zertifikat trotzdem will, gibt es einzeln
über den Zertifikatsspeicher frei — dieser Weg ist unberührt, denn die Prüfung
sieht dort zuerst nach. Weg fällt nur die pauschale Annahme.

Am 11.09.2026 an zwei GMX-Konten gemessen: IMAP über Port 993 und POP3 über
995 laufen unverändert, `Successfully retrieved`. Für diese Konten war die
pauschale Annahme also nie nötig.

> **Weiterhin offen und sicherheitsrelevant: die Hostnamenprüfung greift
> nicht.** Das ist ein **anderer** Mangel als die Vertrauenskette oben.
> Gemessen: ein Zertifikat mit falschem `CN` wird mit `SSLSUCCEEDED` und
> `ErrorCode 0` angenommen. Ein Hinweistext wird angehängt, bleibt aber ohne
> Wirkung. Altbestand von QUALCOMM, Einzelheiten in
> [PORTIERUNG.md](../PORTIERUNG.md).

QCSSL prüft ausschließlich gegen `rootcerts.p7b`, nicht gegen den
Windows-Zertifikatspeicher. Für die Auslieferung erzeugt
`Releases/1.0/rootcerts-erzeugen.ps1` eine frische Datei aus dem
Windows-Wurzelspeicher der Maschine — abgelaufene und noch nicht gültige
Zertifikate bleiben draußen. Wie viele es sind, sagt das Skript am Ende selbst
(*„Gegenprobe (wieder eingelesen): N Zertifikate"*); die Zahl hängt am
Zertifikatstand des Rechners und wird hier deshalb nicht festgeschrieben. Die
beiden Altbestände im Baum (`Eudora71/Bin/Release/rootcerts.p7b`,
`InstallersForEudora/Eudora7.1/Data/win32/RootCerts`) enthalten abgelaufene
Zertifikate und sind nicht maßgeblich.

### Was gegenüber der CHM-Freigabe dazugekommen ist

Die Freigabe von 2018 durfte nur Qualcomm-eigenen Code enthalten. Vier Dinge
mussten ergänzt werden, damit daraus wieder ein Programm wird:

| Was | Wozu |
|---|---|
| `Eudora71/MAPI/include` | Extended-MAPI-Header aus [microsoft/MAPIStubLibrary](https://github.com/microsoft/MAPIStubLibrary) (MIT) — `mapix.h` und `mapiutil.h` sind seit dem Windows-8-SDK nicht mehr im Windows SDK |
| `Eudora71/OpenSSL3` | OpenSSL 3.5.8 LTS als Header und `.lib`, damit `QCSSL` ohne einen 25-minütigen OpenSSL-Lauf übersetzt. Bauweg und Prüfsumme: [Eudora71/OpenSSL3/BAUEN.md](../Eudora71/OpenSSL3/BAUEN.md) |
| `Eudora71/VC71Bruecke` | Nachbau der `MSVCR71.dll` als Weiterleitung auf Windows' eigene `msvcrt.dll`, 1429 Weiterleitungen — die vorgebauten Fremd-DLLs von 2006 brauchen diese Laufzeit. `MFC71.DLL` und `MSVCP71.dll` sind **nicht** nachbaubar. Messungen: [Eudora71/VC71Bruecke/BEFUND.md](../Eudora71/VC71Bruecke/BEFUND.md) |
| `Eudora71/OTShim` | die Ersatzschicht für Stingray, siehe oben |

Dazu die erweiterte UTF-8-Übersetzungstabelle in `Eudora71/Eudora/utils.cpp`
(von 27 auf 123 Einträge, sieben falsche Zuordnungen aus dem Altbestand
berichtigt) — belegt durch die Unit-Tests in `Eudora71/Tests`, beschrieben in
[PORTIERUNG.md](../PORTIERUNG.md) unter *Zwei Fehler in der Zeichentabelle*. Die
vollständige Liste der Fremdbestandteile steht dort ebenfalls.

## Verwandte Projekte

- [HermesMail](https://sourceforge.net/projects/hermesmail/) — rüstet ein
  installiertes Eudora 7.1 binär mit neueren TLS-DLLs nach (OpenSSL 1.0.2)
- [Eudora_patches](https://github.com/HansWurst81675/Eudora_patches) — Binärpatches
  für die Umlautdarstellung

