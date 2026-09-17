# Eudora 7.2

<!-- pruefstand: eceeecf -->
<!-- Die Marke oben nennt den Commit, gegen den diese Datei zuletzt abgeglichen
     wurde. Wer die Datei nachzieht, zieht die Marke mit.
     Gelesen von tools/pruefstand-melden.pl (Befund NP3-7). -->

**Der Mailclient Eudora 7.1, wieder baubar — mit Visual Studio 2022 unter
Windows 10 und 11.**

Eudora war von 1988 bis 2006 einer der meistbenutzten Mailclients überhaupt.
2018 hat das [Computer History
Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/)
den Quellcode mit Genehmigung von Qualcomm freigegeben — als Archiv, nicht als
baubares Projekt: er verlangt Visual C++ 6 und 7.1 von 1998 und 2003, dazu die
kommerzielle Bibliothek *Stingray Objective Toolkit*, die es nicht mehr zu
kaufen gibt.

**Dieses Repo macht daraus wieder ein Programm, das man bauen und benutzen
kann.** Aus einem frischen Klon entsteht mit einem Befehl eine `Eudora.exe`,
die auf einem heutigen Windows startet, Mail über TLS 1.3 abruft und
verschickt.

| | |
|---|---|
| **Sofort ausprobieren** | [Neuestes Paket herunterladen](https://github.com/HansWurst81675/Eudora7.2/releases/latest) — auspacken, `Eudora starten.cmd` doppelklicken. Nichts zu installieren |
| **Selbst bauen** | [Selbst bauen](#selbst-bauen) — Visual Studio 2022 mit „Desktopentwicklung mit C++", ein Befehl |
| **Was geht und was nicht** | [Was es kann](#was-es-kann), [Was es nicht kann](#was-es-nicht-kann) und [ZIEL.md](ZIEL.md) |
| **Was gefunden und behoben wurde** | [CHANGELOG.md](CHANGELOG.md) je Fassung, [BEFUNDE.md](BEFUNDE.md) je Befund mit Messung |
| **Wie portiert wurde** | [PORTIERUNG.md](PORTIERUNG.md) |

<!-- Hier gehoert ein Bildschirmfoto des Hauptfensters hin. Es liegt keines
     im Repo, und ein Agent darf zum Erzeugen nichts starten (tools/testlauf.ps1
     braucht Gregors Freigabe). Gregor entscheidet, ob eines aufgenommen wird. -->

## Was es kann

* **Mail abrufen und verschicken** über POP3 und SMTP mit **TLS 1.3** — das
  Original von 2006 kann nur SSL 3.0 / TLS 1.0 und kommt damit an keinen
  heutigen Mailserver mehr heran.
* **Ohne Installation starten.** Das Paket enthält alles, was der Lader
  braucht; es schreibt nichts in die Registrierung und nichts nach
  `C:\Program Files`.
* **Selbst weiterbauen.** Der Quellbaum übersetzt vollständig mit MSVC v143
  und MFC 14, ohne die Stingray-Bibliothek — an ihrer Stelle steht ein
  Nachbau im Verzeichnis [`Eudora71/OTShim`](Eudora71/OTShim) (siehe [Die
  Ersatzschicht für Stingray OT501](#die-ersatzschicht-für-stingray-ot501)).
* **Schreiben, senden, antworten, weiterleiten**, Anhänge, mehrere
  Persönlichkeiten, die Postfachverwaltung — der Alltag funktioniert.

## Was es nicht kann

* **Kein fertiges Installationsprogramm.** Es gibt ein ZIP, sonst nichts.
* **Adressbuch, LDAP, Ph und S/MIME fallen aus.** Diese Teile brauchen
  `MFC71.DLL` und `MSVCP71.dll` von 2003, und Microsoft hat sie nie zur
  Weitergabe freigegeben. Der Start ist davon nicht betroffen (Befund
  **E-47**).
* **Eine Filterregel verträgt kein bloßes Ansehen.** Eine Regel der Form
  *„Junk Score is less than N"* wird unbrauchbar, sobald man sie im
  Filterfenster anklickt (**E-67**, offen). Sichern Sie `Filters.pce`, bevor
  Sie im Filterfenster stöbern. Das Filtern selbst arbeitet korrekt — dass
  ein Lauf über ein ganzes Postfach *alle* Nachrichten verschob (**E-64**),
  ist behoben und am 10.09.2026 bestätigt. Was Filter können und wo ihre
  Grenzen liegen, steht in [FILTER.md](FILTER.md).
* **HTML-Nachrichten werden beim Lesen inzwischen richtig dargestellt**
  (**E-86**, behoben in 7.2.0.55): MSHTML lief ohne `X-UA-Compatible` im
  IE-7-Modus von 2006. Im **Verfassenfenster** bleibt die Darstellung schlicht
  — siehe *Wo die Grenzen liegen* weiter unten.
* **IMAP-Postfachnamen mit Umlauten stehen roh da** (**E-77**, offen):
  `Entw&APw-rfe` statt *Entwürfe*. IMAP selbst läuft — von Gregor am
  10.09.2026 bestätigt: *„imap: funktioniert"*, `imap.gmx.net:993`.
* **Noch nicht im Download enthalten:** das neueste Release ist `v1.0.50`. Im
  Quellstand sind seither behoben: Zeichensalat beim IMAP-Abruf (7.2.0.52),
  das Beenden mit hängender Aufgabe (7.2.0.53), die HTML-Darstellung beim
  Lesen (7.2.0.55), der Formatverlust beim Weiterleiten (7.2.0.56), sich
  überlagernde Bilder im Verfassenfenster (7.2.0.58), Fragezeichen statt
  Emoji (7.2.0.59), **Inhaltsverlust beim Weiterleiten** einer bereits
  weitergeleiteten Nachricht (7.2.0.59, **E-93** — es gingen 17.889 statt
  105.125 Byte hinaus) und die **Bildgrößen im Verfassenfenster**: jedes Bild
  bekam die Zeilenhöhe des ersten und wurde dadurch abgeschnitten oder
  gequetscht (7.2.0.62, **E-96**; der Notbehelf davor ist mit 7.2.0.63 wieder
  weg). **Und der Absturz beim Speichern einer Nachricht** (7.2.0.65,
  **E-97**) — siehe den Punkt darunter. Wer das braucht, baut selbst.
* **Im Release `v1.0.50` beendet *File → Save As* Eudora sofort** (**E-97**):
  der Windows-Dateidialog ruft `CSaveAsDialog::OnTypeChange` auf, bevor der
  Dialog fertig aufgebaut ist, und ein ungeprüfter `GetParent()` liefert dort
  `NULL`. Der Fehler steckt in **jeder** Fassung von 1.0.49 bis 1.0.63.
  Behoben im Quellstand **7.2.0.65**; wer das veröffentlichte Paket benutzt,
  speichert Nachrichten bis dahin besser nicht.
* **Nur 32 Bit.** Eine 64-Bit-Fassung ist nicht in Arbeit.

Die vollständige Liste der offenen Punkte steht in [CHANGELOG.md](CHANGELOG.md)
unter *Noch offen*.

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
statt der Editorfassung (Befund **E-88**). Was im Verfassenfenster fehlt, fehlt
also nicht beim Empfänger — das Fenster ist Arbeitsfläche, nicht Vorschau.

### 2. Emoji lassen sich nicht anzeigen

Eudora ist durchgehend **ANSI** gebaut: Mailboxen, Kopfzeilen, die
Nachrichtenliste. Der Zeichensatz Windows-1252 kennt 256 Zeichen und darunter
kein einziges Emoji. Beim Umwandeln entstand früher Bytesalat, dann ein
Fragezeichen je Emoji-Hälfte (`??`), seit 7.2.0.59 fallen sie ersatzlos weg
(**E-90**). Kyrillisch, Griechisch und Polnisch bleiben erhalten, soweit die
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
100 MB — damit fiele Kriterium 0 aus [ZIEL.md](ZIEL.md) (*startet ohne
Nachinstallation*). Chromium direkt einzubetten kostet etwa 150 MB Paketgröße.

**Was kein Motorwechsel löst:** Emoji im Betreff und in der Nachrichtenliste.
Die hängen nicht am Editor, sondern an der ANSI-Bauart der ganzen Anwendung.
Dafür bräuchte es eine Unicode-Umstellung — ein eigenes Vorhaben.

## Für Anwender

### Herunterladen und starten

1. [Neuestes Release](https://github.com/HansWurst81675/Eudora7.2/releases/latest)
   herunterladen, ZIP auspacken — an eine Stelle, an der man schreiben darf,
   also **nicht** nach `C:\Program Files`.
2. **`Eudora starten.cmd`** doppelklicken. Beim ersten Start fragt Eudora nach
   den Zugangsdaten des Mailkontos.
3. Die Titelzeile nennt die Fassung, zum Beispiel
   `Eudora 7.2.0.65 / Paket 1.0.65` — diese Angabe gehört in jeden
   Fehlerbericht.

Das Postfach liegt im Unterverzeichnis `Mailverzeichnis` **neben** dem
Programm. Wer eine neue Fassung auspackt, kopiert dieses Verzeichnis herüber
und behält damit Mails, Konten und Filter.

> **Prüfsummen** zu jedem Paket stehen in
> [Releases/PAKETE.md](Releases/PAKETE.md), zusammen mit dem Commit, aus dem
> es gebaut wurde.

### Post automatisch einsortieren

Wie ein Filter entsteht, wann er läuft, was seine fünf Aktionen tun, wo die
Regeln gespeichert werden und was es mit der Junk-Punktzahl auf sich hat:
[FILTER.md](FILTER.md). Dort steht auch, warum diese Punktzahl hier bei
jeder eingehenden Nachricht **0** bleibt.

### Was nicht in der Oberfläche steht

Schalter ohne Menüpunkt, die Regeln für die `Eudora.ini` und das
Verhalten, das sich nicht von selbst meldet — gesammelt und belegt in
[EINSTELLUNGEN.md](EINSTELLUNGEN.md). Dort steht auch, was beim Umstieg
auf eine neue Fassung mitkopiert werden muss.

### Beim Start wird nach dem IMAP-Kennwort gefragt: das Fenster schließen

Wer ein **IMAP**-Postfach benutzt und beim Beenden ein IMAP-Postfachfenster
offen stehen lässt, wird beim **nächsten Start** nach dem Kennwort gefragt —
auch dann, wenn bei dieser Persönlichkeit *Check mail* **abgewählt** ist.

**Was hilft:** das IMAP-Postfachfenster **vor dem Beenden schließen**. Dann
steht beim nächsten Start nichts wieder herzustellen, und es wird nichts
gefragt. Wer das Fenster offen behalten will, lässt statt dessen das Kennwort
speichern.

**Warum das so ist.** Eudora merkt sich beim Beenden alle offenen Fenster im
Abschnitt `[Open Windows]` der `Eudora.ini`, jedes als eigene Zeile
`OpenWindow<n>=…` (`CMainFrame::SaveOpenWindows`, `mainfrm.cpp:2504`). Beim
Start öffnet es sie wieder (`CMainFrame::LoadOpenWindows`, `mainfrm.cpp:2307`;
gelesen `:2337`, geöffnet `:2403`). Ein IMAP-Postfach zu öffnen heißt aber,
sich anzumelden — und die Anmeldung fragt nach, sobald kein Kennwort
gespeichert ist. Die Kette ist durchgehend nachgesehen:

`CTocDoc::Display` (`tocdoc.cpp:3424`) → `OpenOnDisplay` (`:3451`) →
`CImapMailbox::OpenMailbox` (`EuImap/src/ImapMailbox.cpp:817`) → `GetLogin`
(`:825` bzw. `:700`) → `CImapAccount::Login`
(`EuImap/src/ImapAccount.cpp:3763`) → Kennwortdialog (`:3824`).

**Warum *Check mail* nichts daran ändert.** Das Häkchen setzt den Schlüssel
`CheckMailByDefault` (`EudoraRes.rc:10791`, Schaltfläche `:2926`). Gelesen
wird er an zwei Stellen, und keine davon hat mit dem Öffnen von Fenstern zu
tun: `CPersonality::GetParams` (`persona.cpp:271`, `:333`) holt ihn, um das
Häkchen im Dialog anzuzeigen, und `CPersonality::CheckMailList`
(`persona.cpp:675`, Schlüssel `:683`) stellt daraus die Liste der Konten
zusammen, die beim **Mailabruf** drankommen (`GetMail`, `GetMail.cpp:82`,
`:112`). Das Wiederherstellen der Fenster fragt diese Liste nicht — die
beiden Wege haben keine gemeinsame Stelle.

Das ist **kein Fehler dieser Portierung**, sondern Verhalten des Originals;
es hat deshalb keine Befundnummer. Verwandt: bei IMAP fragt auch ein
**Filterlauf** nach dem Kennwort, aus einem anderen Grund — siehe
[FILTER.md](FILTER.md), Abschnitt *Was überrascht*.

### Einen Fehler melden

Fehler gehören in die
[Issues](https://github.com/HansWurst81675/Eudora7.2/issues) dieses Repos.
Damit ein Bericht verwertbar ist, gehören drei Dinge hinein:

1. **Die Bau-Kennung aus der Titelzeile** — sie nennt Fassung, Paketnummer und
   den Commit, aus dem gebaut wurde, in der Form
   `Eudora 7.2.0.<n> / Paket 1.0.<n>`. Ohne sie ist nicht zu sagen, welcher Stand
   gemeint ist. Ein Sternchen hinter dem Commit heißt: beim Bau lagen
   ungesicherte Änderungen vor, dieser Bau ist nicht reproduzierbar.
2. **Was Sie getan haben und was statt dessen geschah** — der Weg im Menü, der
   Tastendruck, der Dialog.
3. **Nach einem Absturz:** die Datei `Mailverzeichnis\Exception.log` neben dem
   Programm. Eudora schreibt sie von selbst, ohne dass etwas eingeschaltet
   werden muss. Sie enthält seit 7.2.0.13 die Ladeadressen aller Module, und
   `perl tools/absturz-auswerten.pl` macht daraus ohne Visual Studio
   Funktionsnamen. Wie das gelesen wird, steht in
   [Befunde/SPUR.md](Befunde/SPUR.md).

Bevor Sie schreiben: die bekannten offenen Punkte stehen in
[CHANGELOG.md](CHANGELOG.md) unter *Noch offen*.

## Einstellungen, die es nur hier gibt

Diese Portierung weicht an einigen Stellen **bewusst** vom Original ab — und
jede Abweichung lässt sich zurückdrehen.

**Die vollständige Liste steht in [EINSTELLUNGEN.md](EINSTELLUNGEN.md)**, mit
Schlüssel, Abschnitt, Vorgabe hier, Vorgabe im Original und Fundstelle im
Quelltext. Dort und nur dort — bis zum 14.09.2026 standen dieselben Schlüssel
in **zwei** Tabellen, hier und dort, und zwölf davon in beiden. Zwei Listen
mit denselben Werten laufen zwangsläufig auseinander; Gregor hat es bemerkt
und entschieden: *„nur in einstellungen, nicht in readme"*.

Was ein Anwender beim **ersten Start** wissen muss, steht weiter unten unter
*Ein Mailverzeichnis übernehmen* und *Mehr ins Protokoll schreiben lassen*.

## Mehr ins Protokoll schreiben lassen

Eudora führt ein Protokoll in `eudora.log` im Mailverzeichnis. **Wie viel
darin landet, steuert ein einziger Schlüssel** — ohne Neubau, ohne
Codeänderung:

```ini
[Debug]
LogLevel=25759
```

> **`[Debug]`, nicht `[Settings]`.** `LogLevel` trägt die Nummer 10802 und
> fällt damit in den Bereich, den `GetSectionID` dem Abschnitt `[Debug]`
> zuweist — siehe [Wo ein Schlüssel stehen
> muss](#wo-ein-schlüssel-stehen-muss). Bis zum 11.09.2026 stand hier
> `[Settings]`; das war falsch. Dasselbe gilt für die beiden Nachbarn
> `LogFileName` (10801) und `LogFileSize` (10803).

`LogLevel` ist keine Stufe von 0 bis 5, sondern eine **Summe von Schaltern**.
Jeder Bereich hat seinen Wert; addiert wird, was man sehen will. Die
eingebaute Vorgabe ist **25759**, und sie enthält bereits die meisten
Bereiche.

| Wert | Bereich | in 25759 |
|---:|---|:---:|
| 1 | allgemeine Protokollzeilen | an |
| 2 | Empfang einer Nachricht | an |
| 4 | Wählverbindung | an |
| 8 | Dialogmeldungen | an |
| 16 | Fortschrittsanzeigen | an |
| 32 | **alle gesendeten Bytes** | aus |
| 64 | **alle empfangenen Bytes** | aus |
| 128 | Prüfung auf beschädigte Inhaltsverzeichnisse | an |
| 256 | Zusatzmodule, Grundzüge | aus |
| 512 | Zusatzmodule, ausführlich | aus |
| 1024 | **Filteraktionen** | an |
| 2048 | fehlgeschlagene `ASSERT`/`VERIFY` | aus |
| 4096 | Abspiellisten | aus |
| 8192 | *Leave mail on server* | an |
| 16384 | Suche und Suchindex | an |
| 32768 | **Spurmarken dieser Portierung** | **aus** |

Belegt in `Eudora71/QCUtils/public/inc/debug.h:15-32`; gelesen wird der
Schlüssel in `eudora.cpp:1192`, ausgewertet in `debug.cpp:140-146`.

### Die Spurmarken einschalten

Diese Portierung schreibt an Stellen, an denen ein Befund untersucht wurde,
Zeilen der Form `E-44 …`, `E-64 …`, `E-70 …`. Sie hängen alle am Schalter
**32768** und sind deshalb **standardmäßig aus**. Einschalten heißt: den
Wert addieren.

```ini
[Debug]
LogLevel=58527
```

58527 ist 25759 + 32768. Eudora muss beim Ändern geschlossen sein, sonst
überschreibt es die Datei beim Beenden.

> **Warum das hier steht.** Bis zum 10.09.2026 waren diese Marken fest
> eingeschaltet — sie hingen zusätzlich am Schalter 128, und der ist in der
> Vorgabe an. Das machte das Protokoll unlesbar und zwang dazu, jede Marke
> nach Gebrauch von Hand wieder auszubauen. Gregors Hinweis darauf hat das
> abgestellt: *„damit kann man im bedarfsfall mehr logs zu debug zwecken
> rausschreiben, ohne den code zu ändern."*

### Wenn etwas nicht tut, was es soll

Der schnellste Weg zu einer belastbaren Aussage:

1. Eudora beenden.
2. `eudora.log` im Mailverzeichnis löschen — dann steht darin nur der
   nächste Lauf.
3. `LogLevel=58527` eintragen.
4. Eudora starten, **genau die eine Sache tun**, um die es geht, beenden.
5. `eudora.log` ansehen. Die Zeilen tragen die Befundnummer am Anfang.

Für Filterläufe lohnt zusätzlich Schalter **1024** (in der Vorgabe schon an):
er schreibt zu jeder Regel, die greift, eine Zeile
`Filter "…" matches "…"`.

**Was ein volles Protokoll kostet:** die Schalter 32 und 64 schreiben jedes
gesendete und empfangene Byte mit, also auch Ihre Zugangsdaten und den
vollständigen Text jeder Mail. Sie sind aus gutem Grund aus. Wer sie
einschaltet, sollte die Datei danach löschen und sie niemandem schicken.

## Stand

Die Messlatte steht in [ZIEL.md](ZIEL.md): neun Kriterien, an denen sich
entscheidet, ob eine Fassung abnahmefähig ist, dazu einzelne Anforderungen
`A-n`. **ZIEL.md ist die Quelle** — `tools/doku-pruefen.pl` weist jeden Commit
ab, in dem eine andere Datei etwas anderes über ein Kriterium behauptet.

Kurz: Eudora baut aus einem frischen Klon, das Paket startet auf einem Rechner
ohne Visual Studio, Mail wird über TLS abgerufen und verschickt, Antworten und
Weiterleitungen gehen, das Programm beendet sich sauber, und die offenen
Fenster stehen als Registerkarten am unteren Rand. Was ein Anwender heute noch
merkt, steht oben unter [Was es nicht kann](#was-es-nicht-kann); die
vollständige Liste mit Messung und Fundstelle führt
[CHANGELOG.md](CHANGELOG.md) unter *Noch offen* und *Erreicht*.

**Die Prüfanleitung zum jeweils aktuellen Paket steht nicht hier**, sondern im
CHANGELOG beim Eintrag der Fassung — eine Anleitung in der README veraltet mit
dem nächsten Bau, ohne dass es jemand merkt.

## Selbst bauen

### Nach einem frischen Klon: ein Schritt

```bash
sh tools/hooks-einrichten.sh
```

Das war es. Der Hook liegt unter `.git/hooks` und wird von git nicht
mitversioniert, muss also je Klon einmal eingerichtet werden; er prüft vor jedem
Commit Zweigwahl, Zeilenenden, Kodierung — und, sobald eine `.md`, `VERSION`
oder `Eudora71/Version.h` mit im Commit ist, die Doku gegen sich selbst
(`tools/doku-pruefen.pl`).

**Zeilenenden sind kein Thema mehr.** [.gitattributes](.gitattributes) setzt
`* -text` und schaltet damit jede Umwandlung durch git ab — beim Auschecken wie
beim Einchecken bleiben die Bytes, wie sie sind, unabhängig davon, wie
`core.autocrlf` auf dem jeweiligen Rechner steht.

Nachgemessen am 06.09.2026: ein frischer Auscheck des Stands, geprüft mit
**erzwungenem** `core.autocrlf=true`, meldet **null geänderte Dateien**. Die
Datei `Eudora71/Eudora/eudora.cpp` steht dabei als `i/mixed w/mixed` da — ihre
absichtlich gemischten Zeilenenden aus den Neunzigern kommen unversehrt an.

> Früher standen hier vier Schritte, darunter `git config core.autocrlf false`
> und ein Lauf von `tools/zeilenenden-angleichen.pl`. Beides war nötig, **bevor**
> es `.gitattributes` gab. Das Werkzeug bleibt liegen — es repariert einen
> Arbeitsbaum, der aus jener Zeit stammt —, aber ein heutiger Klon braucht es
> nicht.

### Der Bau

```powershell
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Release
```

`tools/bauen.ps1` liest Konfiguration und Plattform aus `Eudora71/Eudora.sln`
und sucht MSBuild über `vswhere.exe`; geraten wird nichts. Erfolg meldet es
**nur**, wenn vier voneinander unabhängige Prüfungen zustimmen: Rückgabewert,
Fehlerprotokoll, Zeitstempel der Artefakte und die Versionsressource der
`Eudora.exe`. Grund dafür ist Befund **X-6** — am 05.09.2026 hat ein
MSBuild-Aufruf von Hand Erfolg gemeldet, ohne gebaut zu haben.

Wer doch von Hand baut, kennt drei Fallen:

- **`/p:BuildProjectReferences=false` wird nicht mehr gebraucht** und ist auch
  nicht mehr erwünscht: `OT501` ist seit dem 05.09.2026 aus dem Bau genommen
  (Befund **B-3**). Wer den Schalter trotzdem setzt, bekommt in einem frischen
  Klon `LNK1104: imap.lib` — nicht, weil etwas kaputt wäre, sondern weil
  `Eudora71/Lib/` von `.gitignore` erfasst ist und `imap.lib` erst vom Projekt
  `imapdll` entsteht.
- **Die Plattform heißt `x86`.** Die Projektmappe kennt `x86`, die
  Projektdateien `Win32`. Wer `-p:Platform=Win32` an die `.sln` gibt, bekommt
  `MSB4126`.
- **Der Aufruf muss aus der PowerShell kommen.** Die Git-Bash macht aus
  `/p:Configuration=Debug` einen Pfad.

Die Visual-Studio-IDE wird nicht gebraucht, nur die Installation (MSVC v143,
MFC/ATL, Windows SDK). Belege zum Bauzustand: [PRUEFUNG-BAU.md](PRUEFUNG-BAU.md).

### Was fertig gebaut wird

`<Konfiguration>` steht für `Debug` oder `Release`.

| Ergebnis | Ort |
|---|---|
| **`Eudora.exe`** | `Eudora71/Bin/<Konfiguration>` |
| `EudoraRes.dll` | `Eudora71/Bin/<Konfiguration>` |
| `QCSSL.dll`, `Imap.dll`, `QCSocket.dll`, `QCUtils.dll`, `EuLang.dll`, `plstclnt.dll` | `Eudora71/Bin/<Konfiguration>` |
| `msvcr71.dll` (Projekt `VC71Bruecke`, Weiterleitung auf `msvcrt.dll`) | `Eudora71/Bin/<Konfiguration>` |
| `NSImport.eif`, `OEImport.eif`, `OLImport.eif` (Importer-Plugins, DLLs mit eigener Endung) | `Eudora71/Bin/<Konfiguration>` |
| `EudoraOldIcons.epi` (Icon-Plugin, ebenfalls eine DLL) | `Eudora71/EudoraOldIcons/<Konfiguration>` |
| die `.lib` (siehe unten) | `Eudora71/Lib/<Konfiguration>` |
| `libeay32.lib`, `ssleay32.lib` (Projekt `OpenSSL`, Altbestand) | `Eudora71/OpenSSL/out32` |

#### Die `.lib` in `Eudora71/Lib/<Konfiguration>` — drei Sorten

Zahlen stehen hier absichtlich nicht: `Eudora71/Lib/` ist von `.gitignore`
erfasst, der Inhalt hängt also davon ab, was zuletzt gebaut wurde, und jedes
neue Projekt verschiebt ihn. Wer wissen will, was da liegt, unterscheidet nach
diesen drei Merkmalen — sie halten auch dann noch, wenn ein Projekt dazukommt:

| Sorte | woran man sie erkennt | woher |
|---|---|---|
| **Importbibliothek** zu einer DLL | daneben liegt eine gleichnamige `.exp` | jedes Projekt mit `<ConfigurationType>DynamicLibrary` und `<ImportLibrary>..\Lib\…` |
| **echte statische Bibliothek** | keine `.exp`, wird beim Bau neu geschrieben | `AccountWizard`, `DirectoryServicesUI`, `EuImap`, `SearchEngine` — die vier Projekte mit `<ConfigurationType>StaticLibrary` |
| **vorgefertigte Fremdbibliothek** | keine `.exp`, und `git ls-files Eudora71/Lib/` nennt sie | im Repo mitversioniert, kein Projekt erzeugt sie |

Nachzählen, ohne etwas zu bauen:

```sh
ls Eudora71/Lib/Release/*.exp                       # die Importbibliotheken
git ls-files Eudora71/Lib/                          # die mitgelieferten Fremdlibs
grep -l StaticLibrary Eudora71/*/*.vcxproj Eudora71/*/*/*.vcxproj
```

Die mitgelieferten Fremdbibliotheken heißen in **Release** `EuMemMgr.lib`,
`Paige32.lib`, `SSCEWD32.LIB`, `Uuid.Lib`, `libpng.lib`, `zlib.lib` — in
**Debug** genauso, nur heißt Paige dort `Paige32d.lib`. Auf Groß- und
Kleinschreibung achten: `SSCEWD32.LIB` und `Uuid.Lib` fallen sonst aus einem
`ls *.lib` heraus.

Eine Falle beim Zählen: `VC71Bruecke` baut die DLL `msvcr71.dll`, seine
Importbibliothek heißt aber `msvcr71-bruecke.lib` — Projektname, DLL-Name und
`.lib`-Name gehen hier auseinander.

### Tests

Unit- und Komponententests liegen in `Eudora71/Tests` (`RunTests.cmd`) und
`Eudora71/Tests/QCSSL` (`bauen.bat`, `messen.ps1`). Nach Vorgabe zu jedem Commit
laufen lassen.

### Den eigenen Bau starten

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Ins Mailverzeichnis gehört eine `Eudora.ini`. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`. Welche Dateien
danebenliegen müssen, steht in [STARTUMGEBUNG.md](STARTUMGEBUNG.md).

Der Fenstertitel trägt die **Bau-Kennung** — Paketversion, Commit und
Herkunftsverzeichnis. Ein Sternchen hinter dem Commit heißt: beim Bau lagen
ungesicherte Änderungen vor, der Bau ist nicht reproduzierbar. Damit ist ein
Bildschirmfoto eindeutig einem Bau und einer Instanz zuzuordnen.

### Nur für den Debug-Bau: die Laufzeit-DLLs

**Das Release-Paket braucht nichts aus diesem Abschnitt.** Es bringt
`mfc140.dll`, `msvcp140.dll` und `vcruntime140.dll` selbst mit; die drei sind
Teil des Visual-C++-Redistributable und dürfen beiliegen (Befund F-1).

Der **Debug**-Bau dagegen braucht vier DLLs, die nicht weiterverteilt werden
dürfen und nur mit einer Visual-Studio-Installation kommen:

```
mfc140d.dll   msvcp140d.dll   vcruntime140d.dll   ucrtbased.dll
```

`tools/laufzeit-holen.ps1` kopiert sie und prüft jede einzeln auf ihre
Architektur nach; `-NurPruefen` sagt nur, was fehlt, ohne etwas zu kopieren:

```powershell
powershell -ExecutionPolicy Bypass -File tools\laufzeit-holen.ps1 -Ziel "C:\Pfad\zu\Eudora"
```

Fehlen sie, bricht der Start mit **`0xc000007b`** ab — `STATUS_INVALID_IMAGE_FORMAT`,
Befund S-8. Derselbe Code kommt bei falscher Bitness heraus, und **`Eudora.exe`
ist ein 32-Bit-Programm**. Zwei Fallen führen zu 64-Bit-DLLs: DLL-Sammelseiten
wie dll-files.com liefern häufig die 64-Bit-Fassung, ohne es deutlich zu machen
(von dort **keine** Laufzeit-DLLs holen), und der 32-Bit-Systemordner heißt unter
Windows ausgerechnet **`SysWOW64`**, während in `System32` die 64-Bit-DLLs
liegen. Die richtigen Dateien liegen auf jedem Rechner mit Visual Studio 2022
(C++-Werkzeuge, MFC/ATL) bereits in `SysWOW64`.

Beim ersten Start des Debug-Baus erscheinen drei bis vier Dialoge „SUPERASSERT
Assertion Failure" — auf *Ignore Once* klicken. Das sind Debug-Zusicherungen,
keine Fehler; im Release-Bau entfallen sie samt allen `ASSERT`/`VERIFY`.

## Mitarbeiten

### Was liegt wo

```
Eudora7.2/
├─ Eudora71/                 der Quellbaum, eine Projektmappe (Eudora.sln)
│  ├─ Eudora/                das Programm selbst — hier liegt das meiste
│  ├─ OTShim/                die Ersatzschicht für Stingray OT501
│  ├─ OT501/                 was von Stingray übrig ist: 127 Header, keine Quellen
│  ├─ QCSSL/ QCSocket/ QCUtils/ EuImap/ Imapdll/ EuLang/ …
│  │                         die einzelnen DLLs
│  ├─ AccountWizard/ Importers/ DirectoryServices/ SearchEngine/
│  │                         Assistent, Importer, Verzeichnisdienste, Suche
│  ├─ PaigeDLL/              der Textsatz von 2005 (Paige32.dll)
│  ├─ OpenSSL3/              OpenSSL 3.5.8 LTS: Header und .lib, im Repo
│  ├─ OpenSSL/               OpenSSL 0.9.7l von 2006 — Altbestand, niemand linkt es
│  ├─ VC71Bruecke/           Nachbau der MSVCR71.dll als Weiterleitung
│  ├─ Tests/                 Unit- und Komponententests (RunTests.cmd)
│  ├─ Bin/<Konfiguration>/   hierhin baut alles (nicht versioniert)
│  └─ Lib/<Konfiguration>/   die .lib (nicht versioniert)
├─ tools/                    Bauskripte, Prüfschranken, Messwerkzeuge
├─ Releases/                 ausgelieferte Pakete, Prüfsummen, PAKETE.md
├─ Befunde/                  je Agent eine Datei; BEFUNDE.md ist die Zusammenführung
├─ Pruefung/                 abgeschlossene Prüfberichte
├─ Arbeitsweise/             Spiegel der Lehren (tools/lehren-spiegeln.pl)
├─ InstallersForEudora/      Originaldateien von QUALCOMM: INI-Vorlagen, Zertifikate
├─ OnlineHelp/ Documents/    Altbestand aus der CHM-Freigabe von 2018
├─ Sandbox/ BuildTools/      Altbestand aus dem ersten Import, nicht im Bau
└─ *.md                      die Dokumentation, siehe darunter
```

### Welche Datei welche Frage beantwortet

| Frage | Datei |
|---|---|
| Woran wird „fertig" gemessen? | [ZIEL.md](ZIEL.md) — die Quelle für Kriterien und Anforderungen |
| Was hat sich je Fassung geändert? | [CHANGELOG.md](CHANGELOG.md) |
| Wie funktionieren Filter und Junk, und welche INI-Schlüssel gehören dazu? | [FILTER.md](FILTER.md) |
| Welche Schalter gibt es ohne Menüpunkt, und was überrascht beim Betrieb? | [EINSTELLUNGEN.md](EINSTELLUNGEN.md) |
| Was wurde gefunden, mit Messung und Fundstelle? | [BEFUNDE.md](BEFUNDE.md), Einzelbefunde in `Befunde/` |
| Was ist als Nächstes zu tun? | [AUFGABEN.md](AUFGABEN.md), Einstieg in [WEITERMACHEN.md](WEITERMACHEN.md) |
| Wie wurde von VC6 auf VS2022 portiert, und warum so? | [PORTIERUNG.md](PORTIERUNG.md) |
| Welche Werkzeuge gibt es in `tools/`? | [tools/WERKZEUGE.md](tools/WERKZEUGE.md) |
| Was muss neben `Eudora.exe` liegen, damit sie startet? | [STARTUMGEBUNG.md](STARTUMGEBUNG.md) |
| Welches ZIP gehört zu welchem Commit? | [Releases/PAKETE.md](Releases/PAKETE.md) |
| Wie arbeiten mehrere Agenten nebeneinander? | [AGENTEN.md](AGENTEN.md) |
| Wonach wird gebaut, geprüft, abgenommen? | [PRUEFUNG-BAU.md](PRUEFUNG-BAU.md), [PRUEFUNG-CODE.md](PRUEFUNG-CODE.md), [PRUEFUNG-BRANCH.md](PRUEFUNG-BRANCH.md) |
| Warum steht die Doku so, wie sie steht? | [LEKTORAT.md](LEKTORAT.md) |

### Fassungen und Pakete

Zwei Nummern, und sie bedeuten Verschiedenes:

| Nummer | steht in | bedeutet |
|---|---|---|
| **Quellstand**, z. B. `7.2.0.44` | `Eudora71/Version.h` | die Produktversion, die ein Bau in die `Eudora.exe` schreibt. Sie steht in der Dateiinfo und in der Titelzeile |
| **Paketnummer**, z. B. `1.0.65` | die Datei `VERSION` | benennt das ausgelieferte ZIP |

`cat VERSION` liefert also **nicht** die Quellversion. Beide Nummern gehen
gemeinsam hoch, und zwar **bevor** gebaut wird — sonst tragen zwei
verschiedene Bauten dieselbe Kennung, und ein Fehlerbericht ist keinem Stand
mehr zuzuordnen (Befund **V-1**).

Die Titelzeile nennt beide Nummern plus den Commit; ein Bildschirmfoto ist
damit eindeutig. Welches ZIP zu welcher Marke und welchem Commit gehört, führt
[Releases/PAKETE.md](Releases/PAKETE.md) mit Prüfsumme.

### Werkzeuge und Schranken

In `tools/` liegen die Bauskripte, die Messwerkzeuge und die Schranken, die vor
jedem Commit laufen. Die vollständige Übersicht mit einer Zeile je Werkzeug:
**[tools/WERKZEUGE.md](tools/WERKZEUGE.md)**.

Was man als Erstes wissen muss:

* **Der `pre-commit`-Hook läuft immer.** Er prüft Zweigwahl
  (`tools/pruefe-branch.pl`), Zeilenenden und Kodierung
  (`tools/pruefe-bytes.pl`) und — sobald eine `.md`, `VERSION` oder
  `Eudora71/Version.h` im Commit steht — die Doku gegen sich selbst
  (`tools/doku-pruefen.pl`). `--no-verify` ist keine Lösung, sondern das
  Umgehen der Antwort.
* **Zeilenenden und Kodierung sind heikel.** Die Quellen von 1996–2006 sind
  **Latin-1** mit absichtlich gemischten Zeilenenden, teils innerhalb einer
  Datei. Wer eine Quelldatei ändert, nimmt `tools/aendere-zeile.pl` oder
  `tools/ersetze-bereich.pl` — beide schreiben byte-erhaltend. Die MD-Dateien
  sind dagegen reines LF ohne BOM.
* **Nichts starten, was ein Fenster öffnet**, ohne Absprache — dafür gibt es
  `tools/testlauf.ps1` als einzigen Weg.

### Wie hier gearbeitet wird

Jede Änderung läuft über einen eigenen Zweig; `main` wird nicht direkt
beschrieben. Mehrere Agenten arbeiten in getrennten Arbeitsbäumen, jeder
schreibt seine Befunde in eine **eigene** Datei unter `Befunde/`, und
`tools/befunde-einsammeln.pl` führt sie am Ende in [BEFUNDE.md](BEFUNDE.md)
zusammen — zwei Agenten fassen so nie dieselbe Datei an. Das Verfahren steht
in [AGENTEN.md](AGENTEN.md).

## Technischer Hintergrund

### Wie portiert wurde

Der Quellcode ist von 1996–2006 und stammt aus der Zeit von Visual C++ 6.
Repariert wurden im Wesentlichen acht wiederkehrende Muster — Deklarationen
ohne Rückgabetyp, entfernte Header, alte `for`-Scope-Regeln, die
`const char*`-Überladungen von `strchr`/`strstr`/`strrchr`, `std::auto_ptr`
und Iteratoren-als-Zeiger, MFC-`const`-Overloads, Namenskollisionen mit
winsock2 und der UCRT, dazu drei Projekteinstellungen. Jedes Muster mit den
betroffenen Stellen und der Begründung: **[PORTIERUNG.md](PORTIERUNG.md)**,
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
`OT501` ist ganz aus dem Bau genommen (Befund B-3), die frühere Attrappe
`Lib/Debug/OTA50D.LIB` entfällt und **darf nicht wieder angelegt werden** —
sonst linkt Eudora gegen eine leere Bibliothek.

Ein naheliegender Irrtum, der schon zweimal Arbeit gekostet hat: die
Registerkartenleiste ist **nicht** verzichtbar — abschaltbar ist nur der
MDI-Streifen. Warum, steht in [PORTIERUNG.md](PORTIERUNG.md) unter *Blocker:
OT501*.

Bestandsaufnahme: [Eudora71/OTShim/INVENTAR.md](Eudora71/OTShim/INVENTAR.md) —
Umsetzungsplan mit Stufen und Belegen:
**[Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md)**

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
> [PORTIERUNG.md](PORTIERUNG.md).

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
| `Eudora71/OpenSSL3` | OpenSSL 3.5.8 LTS als Header und `.lib`, damit `QCSSL` ohne einen 25-minütigen OpenSSL-Lauf übersetzt. Bauweg und Prüfsumme: [Eudora71/OpenSSL3/BAUEN.md](Eudora71/OpenSSL3/BAUEN.md) |
| `Eudora71/VC71Bruecke` | Nachbau der `MSVCR71.dll` als Weiterleitung auf Windows' eigene `msvcrt.dll`, 1429 Weiterleitungen — die vorgebauten Fremd-DLLs von 2006 brauchen diese Laufzeit. `MFC71.DLL` und `MSVCP71.dll` sind **nicht** nachbaubar. Messungen: [Eudora71/VC71Bruecke/BEFUND.md](Eudora71/VC71Bruecke/BEFUND.md) |
| `Eudora71/OTShim` | die Ersatzschicht für Stingray, siehe oben |

Dazu die erweiterte UTF-8-Übersetzungstabelle in `Eudora71/Eudora/utils.cpp`
(von 27 auf 123 Einträge, sieben falsche Zuordnungen aus dem Altbestand
berichtigt) — belegt durch die Unit-Tests in `Eudora71/Tests`, beschrieben in
[PORTIERUNG.md](PORTIERUNG.md) unter *Zwei Fehler in der Zeichentabelle*. Die
vollständige Liste der Fremdbestandteile steht dort ebenfalls.

## Verwandte Projekte

- [HermesMail](https://sourceforge.net/projects/hermesmail/) — rüstet ein
  installiertes Eudora 7.1 binär mit neueren TLS-DLLs nach (OpenSSL 1.0.2)
- [Eudora_patches](https://github.com/HansWurst81675/Eudora_patches) — Binärpatches
  für die Umlautdarstellung

## Lizenz

Der Eudora-Quellcode steht unter der BSD-artigen Lizenz der Freigabe von 2018
(siehe Kopf der Quelldateien). Fremdbestandteile behalten ihre eigenen Lizenzen.
