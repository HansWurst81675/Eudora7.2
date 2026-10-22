# Eudora 7.2

<!-- pruefstand: eceeecf -->
<!-- Die Marke oben nennt den Commit, gegen den diese Datei zuletzt abgeglichen
     wurde. Wer die Datei nachzieht, zieht die Marke mit.
     Gelesen von tools/pruefstand-melden.pl (Befund [NP3-7](BEFUNDE.md#np3-7)). -->

> **Vor dem ersten Start: sichern.** Wer bereits Eudora 7.1 oder Hermes
> benutzt, sichert **vorher** die `Eudora.ini` und das komplette
> Mailverzeichnis. Dieses Projekt startet mit einem **eigenen**
> Mailverzeichnis und fasst eine vorhandene Installation nicht an —
> `Eudora starten.cmd` hält sich daran, und wer `Eudora.exe` direkt startet,
> wird gefragt. Eine Sicherung kostet zwei Minuten; eine verlorene Postablage
> ist nicht wiederherstellbar.
>
> **Getrennte Verzeichnisse benutzen.** Die `Eudora.ini` bleibt **nicht**
> rückwärtskompatibel — unsere Fassung und eine vorhandene Eudora oder Hermes
> schreiben denselben Satz Werkzeugleisten mit unterschiedlichen MFC-Fassungen
> in dieselbe Datei. Wer sich **eine** INI oder **ein** Mailverzeichnis teilt,
> muss damit rechnen, dass die jeweils andere Installation danach Fehler
> zeigt. Parallelbetrieb geschieht **auf eigene Gefahr**.

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

## Wo fange ich an?

| Ich will … | … dann hierhin |
|---|---|
| **es einfach ausprobieren** | [Neuestes Paket herunterladen](https://github.com/HansWurst81675/Eudora7.2/releases/latest) — auspacken, `Eudora starten.cmd` doppelklicken. Nichts zu installieren |
| **wissen, was geht und was nicht** | [Auf einen Blick](#auf-einen-blick-was-das-paket-kann-und-wo-noch-fehler-sind) gleich hier unten; ausführlich in [Doku/ANWENDER.md](Doku/ANWENDER.md) |
| **es benutzen** (Filter, Defender, IMAP-Kennwort, Protokoll) | [Doku/ANWENDER.md](Doku/ANWENDER.md) |
| **es selbst bauen** | [Doku/BAUEN.md](Doku/BAUEN.md) — Visual Studio 2022 mit „Desktopentwicklung mit C++", ein Befehl |
| **einen Fehler melden** | [Einen Fehler melden](Doku/ANWENDER.md#einen-fehler-melden) |
| **mitarbeiten** | [Doku/MITARBEITEN.md](Doku/MITARBEITEN.md) |
| **wissen, wie portiert wurde** | [Doku/HINTERGRUND.md](Doku/HINTERGRUND.md) und [PORTIERUNG.md](PORTIERUNG.md) |

### Wenn hier jemand — oder eine KI — weiterarbeiten soll

Die Reihenfolge ist wichtig, und sie ist kurz:

1. **[CLAUDE.md](CLAUDE.md)** — was *vor* dem ersten Handgriff zu tun ist. 86 Zeilen.
2. **`perl tools/offene-befunde.pl`** — was offen ist. Die erzeugte Tabelle in
   [WEITERMACHEN.md](WEITERMACHEN.md) nennt zu jedem Punkt **was noch fehlt**,
   nicht nur, wie er eingestuft ist.
3. **[ZIEL.md](ZIEL.md)** — woran „fertig" gemessen wird. Neun Kriterien plus
   der Maßstab für die Fassung 7.2.1.0. **ZIEL.md ist die Quelle**; widerspricht
   ihr eine andere Datei, weist `tools/doku-pruefen.pl` den Commit ab.

Mehr braucht es zum Anfangen nicht.

### Welche Datei wofür da ist

Das Wurzelverzeichnis trägt 21 Markdown-Dateien. Die meisten sind **unser
Arbeitsmaterial**, nicht Dokumentation für Leser — diese Tabelle sagt, welche
welche ist, damit niemand sich durch 25 000 Zeilen liest, die nicht für ihn
geschrieben sind.

| Für Leser | |
|---|---|
| [README.md](README.md) | diese Datei: Einstieg und Wegweiser |
| [Doku/](Doku) | Benutzung, Bauen, Mitarbeiten, technischer Hintergrund |
| [ZIEL.md](ZIEL.md) | woran „fertig" gemessen wird |
| [CHANGELOG.md](CHANGELOG.md) | was sich je Fassung geändert hat |
| [MELDUNGEN-VON-AUSSEN.md](MELDUNGEN-VON-AUSSEN.md) | gemeldete Fehler von außen, mit Stand (auf Englisch) |
| [LICENSE](LICENSE) | wer es wie benutzen darf |

| Arbeitsmaterial — nachschlagen, nicht lesen | |
|---|---|
| [BEFUNDE.md](BEFUNDE.md) | jeder Befund mit Messung und Urteil. 8668 Zeilen; **über die Kennung anspringen**, nicht von vorn lesen |
| [WEITERMACHEN.md](WEITERMACHEN.md) | der nächste Schritt und die erzeugte Liste der offenen Befunde |
| [AUFGABEN.md](AUFGABEN.md), [TESTPLAN.md](TESTPLAN.md) | Arbeitspakete und Prüfpunkte |
| [PORTIERUNG.md](PORTIERUNG.md) | Portierungstagebuch |
| [LEKTORAT.md](LEKTORAT.md), [PRUEFBERICHT.md](PRUEFBERICHT.md) | Berichte der Rollen LEKTOR und PRÜFER |
| [PRUEFUNG-BAU.md](PRUEFUNG-BAU.md), [PRUEFUNG-CODE.md](PRUEFUNG-CODE.md), [PRUEFUNG-BRANCH.md](PRUEFUNG-BRANCH.md) | Prüfanleitungen |
| [FILTER.md](FILTER.md), [EINSTELLUNGEN.md](EINSTELLUNGEN.md), [STARTUMGEBUNG.md](STARTUMGEBUNG.md), [ABRUF-PRUEFEN.md](ABRUF-PRUEFEN.md) | Einzelthemen im Detail |
| [AGENTEN.md](AGENTEN.md), [CLAUDE.md](CLAUDE.md) | wie hier mit Agenten gearbeitet wird |
| [BEFUNDE-ALTBESTAND.md](BEFUNDE-ALTBESTAND.md) | abgeschlossene Befunde aus der Frühzeit |
| [Befunde/](Befunde), [Arbeitsweise/](Arbeitsweise), [tools/](tools) | 112 Prüfberichte, 109 Lehren, über 100 Werkzeuge |

## Auf einen Blick: was das Paket kann und wo noch Fehler sind

*Stand **7.2.0.120** / `VERSION` **1.0.120** — am 21.10.2026 geschnürt nach `C:\Users\Gregor\Eudora72-1.0.120-release`, **veröffentlicht als `v1.0.120`**: die Auswahlbox im `To:`-Feld schrumpft nicht mehr bei jedem Cursor-Schritt ([E-135](BEFUNDE.md#e-135)). Davor **1.0.119**, am 21.10.2026 geschnürt nach `C:\Users\Gregor\Eudora72-1.0.119-release`, nicht veröffentlicht: der Kurzname eines neuen Adressbucheintrags kommt an ([E-134](BEFUNDE.md#e-134)). **Veröffentlicht ist `v1.0.120`** (21.10.2026, 19:07:37 UTC) — es trägt 7.2.0.118, 7.2.0.119 und 7.2.0.120, weil die beiden mittleren gebaut, aber nie veröffentlicht wurden; davor `v1.0.117` (07:56:56 UTC); davor `v1.0.113` am 20.10.2026 um 13:01 UTC; davor am selben Tag um 11:55 UTC `v1.0.112` (Quellstand 7.2.0.112); davor `v1.0.101` vom 17.10.2026. Die ausführliche
Fassungsgeschichte steht weiter unten in [Was es kann](#was-es-kann) und
[Was es nicht kann](Doku/ANWENDER.md#was-es-nicht-kann), jede Messung in
[BEFUNDE.md](BEFUNDE.md).*

### Was geht

* **Mail abrufen und senden** über POP3, IMAP und SMTP mit TLS 1.3 – auch an
  heutigen Servern (geprüft an GMX und freenet).
* **Lesen** von Text- und HTML-Nachrichten, mit Bildern in der richtigen Größe.
* **Schreiben, antworten, weiterleiten**, Anhänge mit vollem Namen und Endung,
  mehrere Persönlichkeiten, Filter, Postfachverwaltung.
* **Verschieben in einen IMAP-Ordner** – auch HTML-Nachrichten mit
  eingebetteten Bildern und gesendete Post; die Nachricht verschwindet aus dem
  lokalen Postfach erst, wenn sie auf dem Server steht.
* **Ohne Installation**: ZIP auspacken, `Eudora starten.cmd` doppelklicken.
  **Nicht `Eudora.exe` direkt starten** — ohne Angabe des Mailverzeichnisses
  sucht Eudora sich eines und findet dabei über die Registry das einer
  **vorhandenen** Eudora- oder Hermes-Installation, auch in einem ganz anderen
  Ordner; es schreibt dann in deren `Eudora.ini` ([E-132](BEFUNDE.md#e-132),
  der Weg hinter [E-131](BEFUNDE.md#e-131)). `Eudora starten.cmd` übergibt das
  Verzeichnis als Argument und verhindert das; wer eine Verknüpfung anlegt,
  gibt den Pfad mit an: `Eudora.exe "C:\…\Mailverzeichnis"`. **Ab 7.2.0.114
  fragt Eudora vorher** und legt ohne Zutun ein eigenes Verzeichnis an — seit
  7.2.0.116 auf allen Startwegen, seit 7.2.0.117 auch bei einem fremden Ordner
  ohne `Eudora.ini`. **Veröffentlicht ist das seit dem 21.10.2026 als
  `v1.0.120`** (19:07:37 UTC); **für `v1.0.117` und älter gilt der Hinweis oben
  unverändert.** Die Pakete 1.0.115 bis 1.0.118 sind geschnürt und liegen bei
  Gregor; 1.0.119 liegt seit dem 21.10.2026 als Testverzeichnis bei ihm.

**Neu in `v1.0.101` gegenüber `v1.0.87`:** HTML-Nachrichten und eingebettete Bilder kommen
beim Verschieben in einen IMAP-Ordner vollständig an
([E-118](BEFUNDE.md#e-118)); eine verschobene Nachricht kann – bis auf einen seltenen, vermuteten Fall
(siehe Tabelle) – nicht mehr
verlorengehen, steht nicht mehr doppelt in der Liste und trifft keine fremde
Nachricht mit gleicher Nummer ([E-121](BEFUNDE.md#e-121)); eine beim Start
schon fertige IMAP-Aufgabe blockiert den Ordner nicht mehr und Eudora lässt sich
ohne *„1 task(s) running“* beenden ([E-83](BEFUNDE.md#e-83)); ein versteckter
Vorschautext wird nicht mehr als `? ? ? ?` mitgelesen
([E-105](BEFUNDE.md#e-105), an einer Prüfnachricht gemessen, am echten
Postfach noch nicht bestätigt).

### Bekannte Fehler

Bis auf die mit *Selten* beginnende Zeile geht in keinem dieser Fälle eine
**Nachricht in Ihrem Postfach** verloren. Die zweite Spalte sagt, was sonst verlorengehen oder verfälscht werden kann;
*nichts* heißt, es betrifft nur Anzeige oder Bedienung.

| Was passiert | Was kann verlorengehen | Was hilft | Befund |
|---|---|---|---|
| Läuft eine Fassung **vor 7.2.0.113** neben einer vorhandenen Eudora oder Hermes 7.1, schreibt sie `MRUFloatXPos=-2147483648` – eine ungültige Fensterposition – in die gemeinsam benutzte `Eudora.ini`. Der Melder berichtet, dass sein Hermes 7.1 danach beim Start abstürzte (`EXCEPTION_ACCESS_VIOLATION` in `MFC71.DLL`) | nichts von Ihrer Post – aber möglicherweise die **Benutzbarkeit der vorhandenen Installation** | **Behoben in 7.2.0.113, seit `v1.0.113` veröffentlicht:** diese Fassung schreibt den Wert nicht mehr, am Prüfstand rot und grün gemessen. **Zwei Einschränkungen:** eine `Eudora.ini`, die den Wert schon trägt, wird erst beim nächsten Sichern durch unsere Fassung berichtigt – wer sie nicht mehr startet, berichtigt sie von Hand oder spielt die Sicherung zurück. Und **dass dieser Wert der Grund des Absturzes war, ist nicht belegt** ([PRÜFER-40](Befunde/PRUEFER-40.md#k1) K1: `-2147483648` ist `CW_USEDEFAULT`, das MFC selbst setzt und beim Lesen wieder abfängt); belegt ist nur, dass wir ihn schreiben. **Sicherheitshalber weiter:** `Eudora.ini` und Mailverzeichnis sichern, bevor diese Fassung neben einer vorhandenen Installation läuft. Von außen gemeldet ([Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102), 18.10.2026, an `v1.0.101`) | [E-131](BEFUNDE.md#e-131) |
| Eine Nachricht, die der Filter nicht lesen kann, wird still übersprungen | nichts geht verloren – **diese eine Nachricht** bleibt ungefiltert liegen, die übrigen werden weiter gefiltert (am Quelltext gelesen für *Filter Messages*, [LEKTOR-41](Befunde/LEKTOR-41.md)) | nach dem Filtern stichprobenartig nachsehen; ab 7.2.0.106 (seit `v1.0.112` veröffentlicht) steht die Nachricht mit Betreff und Grund im Fenster *Task Errors*, ab 7.2.0.110 nur noch der erste Fall eines Laufs einzeln und der Rest als ein Sammeleintrag, und es piept höchstens einmal je zwei Sekunden | [E-69](BEFUNDE.md#e-69) |
| Eine als Datei gespeicherte Nachricht zeigt in anderen Programmen falsche Zeichen | die **gespeicherte Datei** ist verfälscht (die Nachricht im Postfach nicht) | die Nachricht im Postfach lassen oder weiterleiten statt speichern. **In 7.2.0.107 bis 7.2.0.109 — alle drei nie als Paket geschnürt — war es für Post in `windows-1251`, `koi8-r` oder `iso-8859-2` schlechter als in `v1.0.101`; ab 7.2.0.110 nicht mehr** ([PRÜFER-37](Befunde/PRUEFER-37.md) F3/F4 behoben). Bei Latin-1- und UTF-8-Post trat das nie auf | [E-101](BEFUNDE.md#e-101) |
| Eine über *File → Save As* gespeicherte Nachricht heißt immer `.txt` – auch wenn ihr Inhalt HTML ist, und ohne jeden Hinweis | nichts – der Inhalt ist vollständig, nur die Endung passt nicht | die Datei in `.html` umbenennen und im Browser öffnen, oder in `.eml` umbenennen und in Thunderbird | [E-128](BEFUNDE.md#e-128) |
| Wird die gerade benutzte Persönlichkeit gelöscht, können Reste ihrer Einstellungen wiederkommen | **Einstellungen** der Persönlichkeit (Ihre Post nicht) | vorher auf eine andere Persönlichkeit wechseln | [E-39](BEFUNDE.md#e-39) |
| Selten, vermutet: wird eine **gesendete** Mail genau in dem Moment in einen IMAP-Ordner verschoben, in dem Eudora diesen Ordner gerade abgleicht, kommt sie nicht auf dem Server an und liegt nur im lokalen Papierkorb | diese **gesendete Mail**, wenn danach der Papierkorb geleert wird | nach dem Verschieben kurz im IMAP-Ordner nachsehen; den Papierkorb nicht sofort leeren | [E-126](BEFUNDE.md#e-126) |
| Nach einem Neustart mitten im Verschieben nach IMAP können eingebettete Bilder einer Nachricht fehlen; die Nachricht selbst bleibt | die **eingebetteten Bilder** dieser Nachricht | vor dem Beenden warten, bis das Verschieben fertig ist. Ab 7.2.0.104 (seit `v1.0.112` veröffentlicht) wartet Eudora beim Beenden selbst, bis das Hochladen fertig ist; ab 7.2.0.108 wird nach fünf Minuten **nicht** mehr erzwungen beendet, sondern das Beenden aufgegeben — das Fenster bleibt offen und der Grund steht in der Statuszeile. Nach einem Absturz, Stromausfall oder erzwungenen Herunterfahren kann es weiter passieren | [E-123](BEFUNDE.md#e-123) |
| War der IMAP-Ordner seit dem Start **noch nie geöffnet**, fehlen die eben dorthin verschobenen Mails in seiner Liste, bis man ihn noch einmal schließt und öffnet | nichts – die Mails sind auf dem Server | den Ordner schließen und neu öffnen | [E-127](BEFUNDE.md#e-127) |
| Wird **ohne Serververbindung** in einen IMAP-Ordner verschoben und sofort beendet, zeigt der Zielordner danach nur einen Teil der Nachrichten | nichts – die Nachrichten stehen weiter im Ausgangspostfach | *Rechtsklick auf das Postfach → Show Deleted Messages* macht sie wieder sichtbar, *Message → UnDelete* holt sie zurück; *Message → Purge Messages* dabei **nicht** benutzen – das entfernt sie | [E-129](BEFUNDE.md#e-129) |
| **Verzeichnisdienste** (LDAP, Ph, EudoraBk) und S/MIME fehlen — Dialog *„Directory Services unavailable“*. **Das eigene Adressbuch ist davon nicht betroffen** und arbeitet | nichts | – (die Bibliotheken von 2003 dürfen nicht mitgeliefert werden) | [E-47](BEFUNDE.md#e-47) |
| Bilder, die als `data:` im HTML stecken, erscheinen beim Antworten und Weiterleiten als grauer Kasten | nichts | – | [E-119](BEFUNDE.md#e-119) |
| Sehr breite Bilder laufen rechts aus dem Fenster; Größenangaben wie `35px` können ein Bild verzerren | nichts | – | [E-113](BEFUNDE.md#e-113), [E-116](BEFUNDE.md#e-116) |
| In einen IMAP-Ordner hochgeladene Nachrichten tragen ein um die Zeitzone verschobenes Eingangsdatum (Sortierung) | nichts | – | [E-122](BEFUNDE.md#e-122) |
| IMAP-Ordnernamen mit Umlauten stehen roh da (`Entw&APw-rfe`) | nichts | – | [E-77](BEFUNDE.md#e-77) |
| Emoji in Betreffzeilen erscheinen als `?` | nichts | – | [E-90](BEFUNDE.md#e-90) |
| Im Speicherdialog fehlen *Kopfzeilen einschließen* und *Absätze raten* | nichts | es gilt die zuletzt gewählte Einstellung | [E-98](BEFUNDE.md#e-98) |
| Eine Nachricht aus einem IMAP-Ordner nach `Out` gezogen wird nicht verschoben: in `Out` entsteht eine neue Nachricht mit `<br>` im Betreff und in den Kopfzeilen, dazu die Meldung *„No messages were transferred!“* | nichts – das Original bleibt im IMAP-Ordner; wer die neue Nachricht sendet, schickt sie mit kaputtem Empfänger | Nachrichten nicht aus einem IMAP-Ordner nach `Out` ziehen; so entstandene Einträge in `Out` nicht senden, sondern löschen | [E-125](BEFUNDE.md#e-125) |
| Der Filterbericht bleibt nach einem Filterlauf leer | nichts | – | [E-71](BEFUNDE.md#e-71) |
| Ein gelöstes, vorher angedocktes Fenster kann einen leeren Bereich hinterlassen | nichts | Fenster einmal neu anordnen | [E-114](BEFUNDE.md#e-114) |
| Microsoft Defender kann eine Fassung fälschlich als Trojaner einstufen und das Programm ohne Meldung beenden | nichts | siehe [Windows Defender meldet Eudora als Trojaner](Doku/ANWENDER.md#windows-defender-meldet-eudora-als-trojaner) | [E-124](BEFUNDE.md#e-124) |

**Ihre Post sichern.** Eudora legt alles im Verzeichnis `Mailverzeichnis`
neben dem Programm ab. Wer es vor dem ersten Start einer neuen Fassung kopiert,
kann jederzeit zurück.

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
  Ersatzschicht für Stingray OT501](Doku/HINTERGRUND.md#die-ersatzschicht-für-stingray-ot501)).
* **Schreiben, senden, antworten, weiterleiten**, Anhänge, mehrere
  Persönlichkeiten, die Postfachverwaltung — der Alltag funktioniert.

## Stand

Die Messlatte steht in [ZIEL.md](ZIEL.md): neun Kriterien, an denen sich
entscheidet, ob eine Fassung abnahmefähig ist, dazu einzelne Anforderungen
`A-n`. **ZIEL.md ist die Quelle** — `tools/doku-pruefen.pl` weist jeden Commit
ab, in dem eine andere Datei etwas anderes über ein Kriterium behauptet.

Kurz: Eudora baut aus einem frischen Klon, das Paket startet auf einem Rechner
ohne Visual Studio, Mail wird über TLS abgerufen und verschickt, Antworten und
Weiterleitungen gehen, das Programm beendet sich sauber, und die offenen
Fenster stehen als Registerkarten am unteren Rand. Was ein Anwender heute noch
merkt, steht oben unter [Was es nicht kann](Doku/ANWENDER.md#was-es-nicht-kann); die
vollständige Liste mit Messung und Fundstelle führt
[CHANGELOG.md](CHANGELOG.md) unter *Noch offen* und *Erreicht*.

**Die Prüfanleitung zum jeweils aktuellen Paket steht nicht hier**, sondern im
CHANGELOG beim Eintrag der Fassung — eine Anleitung in der README veraltet mit
dem nächsten Bau, ohne dass es jemand merkt.


## Verwandte Projekte

- [HermesMail](https://sourceforge.net/projects/hermesmail/) — rüstet ein
  installiertes Eudora 7.1 binär mit neueren TLS-DLLs nach (OpenSSL 1.0.2)
- [Eudora_patches](https://github.com/HansWurst81675/Eudora_patches) — Binärpatches
  für die Umlautdarstellung

## Lizenz

**[LICENSE](LICENSE)** — der vollständige Text. Kurz:

Der Eudora-Quelltext steht unter der BSD-3-Clause-Lizenz mit Patentausschluss,
unter der ihn das Computer History Museum 2018 freigegeben hat (Urheberzeile
von 2016, siehe Kopf der Quelldateien). **Alles, was in diesem Projekt neu
entstanden ist** — die Ersatzschicht unter `Eudora71/OTShim`, die Werkzeuge
unter `tools/` und die Dokumentation — steht unter **derselben** Lizenz. Die
Änderungen liegen fast alle innerhalb von Dateien mit diesem Lizenzkopf; eine
zweite Lizenz ergäbe eine Grenze, die niemand nachziehen kann.

Benutzen, verändern und weitergeben ist damit erlaubt, auch gewerblich,
solange Urhebervermerk und Lizenztext mitgehen. Keine Gewährleistung, keine
Patentrechte, und unsere Namen nicht zur Werbung.

**Zwei Einschränkungen**, die [LICENSE](LICENSE) im Einzelnen aufführt:
Fremdbestandteile wie OpenSSL, expat und libpng behalten ihre eigenen
Lizenzen — und einiges im Baum gehört **weder uns noch dem Computer History
Museum**: die Stingray-Header unter `Eudora71/OT501`, `Paige32.dll`,
`SMIME.dll` und die Verzeichnisdienst-Bibliotheken von 2003. Daran können wir
niemandem Rechte einräumen.

