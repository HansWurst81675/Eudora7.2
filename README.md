# Eudora 7.2

<!-- pruefstand: eceeecf -->
<!-- Die Marke oben nennt den Commit, gegen den diese Datei zuletzt abgeglichen
     wurde. Wer die Datei nachzieht, zieht die Marke mit.
     Gelesen von tools/pruefstand-melden.pl (Befund [NP3-7](Intern/BEFUNDE.md#np3-7)). -->

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
| **wissen, wie portiert wurde** | [Doku/HINTERGRUND.md](Doku/HINTERGRUND.md) und [PORTIERUNG.md](Intern/PORTIERUNG.md) |

### Wenn hier jemand — oder eine KI — weiterarbeiten soll

Die Reihenfolge ist wichtig, und sie ist kurz:

1. **[CLAUDE.md](CLAUDE.md)** — was *vor* dem ersten Handgriff zu tun ist. 86 Zeilen.
2. **`perl tools/offene-befunde.pl`** — was offen ist. Die erzeugte Tabelle in
   [WEITERMACHEN.md](Intern/WEITERMACHEN.md) nennt zu jedem Punkt **was noch fehlt**,
   nicht nur, wie er eingestuft ist.
3. **[ZIEL.md](ZIEL.md)** — woran „fertig" gemessen wird. Neun Kriterien plus
   der Maßstab für die Fassung 7.2.1. **ZIEL.md ist die Quelle**; widerspricht
   ihr eine andere Datei, weist `tools/doku-pruefen.pl` den Commit ab.

Mehr braucht es zum Anfangen nicht.

### Welche Datei wofür da ist

Im Wurzelverzeichnis liegt nur noch, was **für Leser** gedacht ist. Unser
Arbeitsmaterial steht unter [`Intern/`](Intern) — es ist zum **Nachschlagen**
da, nicht zum Lesen.

| Für Leser | |
|---|---|
| [README.md](README.md) | diese Datei: Einstieg und Wegweiser |
| [Doku/](Doku) | Benutzung, Bauen, Mitarbeiten, technischer Hintergrund |
| [ZIEL.md](ZIEL.md) | woran „fertig" gemessen wird — **und was zur Fassung 7.2.1 noch fehlt**, ganz oben, erzeugt |
| [CHANGELOG.md](CHANGELOG.md) | was sich je Fassung geändert hat, und die erzeugte Liste der offenen Befunde |
| [Releases/PRUEFBERICHT.md](Releases/PRUEFBERICHT.md) | **jeder Test** mit Ergebnis, Zeitpunkt und Bau — Unit-Tests, Schranken, Prüfstandsfälle. Nach einer eigenen Änderung vergleicht `perl tools/pruefbericht.pl --vergleich` mit diesem Stand und nennt, was neu rot ist |
| [MELDUNGEN-VON-AUSSEN.md](MELDUNGEN-VON-AUSSEN.md) | gemeldete Fehler von außen, mit Stand (auf Englisch) |
| [LICENSE](LICENSE) | wer es wie benutzen darf |
| [CLAUDE.md](CLAUDE.md) | was ein Agent **vor** dem ersten Handgriff tut |

| `Intern/` — nachschlagen, nicht lesen | |
|---|---|
| [BEFUNDE.md](Intern/BEFUNDE.md) | jeder Befund mit Messung, Urteil und **was noch fehlt**. 8700 Zeilen; über die Kennung anspringen. Die Legende der 16 Kürzel steht ganz oben |
| [WEITERMACHEN.md](Intern/WEITERMACHEN.md) | der nächste Schritt |
| [AUFGABEN.md](Intern/AUFGABEN.md), [TESTPLAN.md](Intern/TESTPLAN.md) | Arbeitspakete und Prüfpunkte |
| [PORTIERUNG.md](Intern/PORTIERUNG.md) | Portierungstagebuch |
| [LEKTORAT.md](Intern/LEKTORAT.md), [PRUEFBERICHT.md](Intern/PRUEFBERICHT.md) | Berichte der Rollen LEKTOR und PRÜFER (Archiv bis 30.08.2026 — nicht zu verwechseln mit dem Testbericht `Releases/PRUEFBERICHT.md`) |
| [PRUEFUNG-BAU.md](Intern/PRUEFUNG-BAU.md), [PRUEFUNG-CODE.md](Intern/PRUEFUNG-CODE.md), [PRUEFUNG-BRANCH.md](Intern/PRUEFUNG-BRANCH.md) | Prüfanleitungen |
| [FILTER.md](Intern/FILTER.md), [EINSTELLUNGEN.md](Intern/EINSTELLUNGEN.md), [STARTUMGEBUNG.md](Intern/STARTUMGEBUNG.md), [ABRUF-PRUEFEN.md](Intern/ABRUF-PRUEFEN.md) | Einzelthemen im Detail |
| [AGENTEN.md](Intern/AGENTEN.md) | wie hier mit Agenten gearbeitet wird |
| [BEFUNDE-ALTBESTAND.md](Intern/BEFUNDE-ALTBESTAND.md) | abgeschlossene Befunde aus der Frühzeit |

Dazu [`Befunde/`](Befunde) (112 Prüfberichte), [`Arbeitsweise/`](Arbeitsweise)
(109 Lehren aus Fehlern) und [`tools/`](tools) (über 100 Werkzeuge und
Schranken).
## Auf einen Blick: was das Paket kann und wo noch Fehler sind

*Stand **7.2.0.122** / `VERSION` **1.0.122** — geschnürt als Paket 1.0.122 (23.10.2026), am selben Tag von Gregor und am Prüfstand geprüft ([Testbericht](Intern/TESTBERICHT-E125.md)): [E-125](Intern/BEFUNDE.md#e-125), Ziehen einer empfangenen Nachricht nach `Out` wird abgelehnt statt eine neue Nachricht anzulegen (277 Tests, 277 bestanden, zweimal gegengetestet); davor in 7.2.0.121 [E-111](Intern/BEFUNDE.md#e-111), `resolve_URL` schreibt nicht mehr über das Zielfeld hinaus (246 Tests, mit Gegenprobe). **Veröffentlicht ist `v1.0.120`** (21.10.2026, 19:07:37 UTC) — die Auswahlbox im `To:`-Feld schrumpft nicht mehr bei jedem Cursor-Schritt ([E-135](Intern/BEFUNDE.md#e-135)). Die vollständige Fassungsgeschichte steht in [CHANGELOG.md](CHANGELOG.md), was zur Fassung 7.2.1 noch fehlt oben in [ZIEL.md](ZIEL.md).*

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
  Ordner; es schreibt dann in deren `Eudora.ini` ([E-132](Intern/BEFUNDE.md#e-132),
  der Weg hinter [E-131](Intern/BEFUNDE.md#e-131)). `Eudora starten.cmd` übergibt das
  Verzeichnis als Argument und verhindert das; wer eine Verknüpfung anlegt,
  gibt den Pfad mit an: `Eudora.exe "C:\…\Mailverzeichnis"`. **Ab 7.2.0.114
  fragt Eudora vorher** und legt ohne Zutun ein eigenes Verzeichnis an — seit
  7.2.0.116 auf allen Startwegen, seit 7.2.0.117 auch bei einem fremden Ordner
  ohne `Eudora.ini`. **Veröffentlicht ist das seit dem 21.10.2026 als
  `v1.0.120`** (19:07:37 UTC); **für `v1.0.117` und älter gilt der Hinweis oben
  unverändert.** Die Pakete 1.0.115 bis 1.0.118 sind geschnürt und liegen bei
  Gregor; 1.0.119 liegt seit dem 21.10.2026 als Testverzeichnis bei ihm.

**Neu im veröffentlichten `v1.0.120` gegenüber `v1.0.101`:** Eudora übernimmt das
Mailverzeichnis einer **fremden Installation** nicht mehr stillschweigend, sondern
fragt vorher und legt ohne Zutun ein eigenes an — auf allen Startwegen
([E-132](Intern/BEFUNDE.md#e-132), der Weg hinter dem ersten Fehlerbericht von
außen); der Kurzname eines neuen Adressbucheintrags kommt an
([E-134](Intern/BEFUNDE.md#e-134)); die Auswahlbox im `To:`-Feld schrumpft nicht
mehr bei jedem Cursor-Schritt ([E-135](Intern/BEFUNDE.md#e-135)); und es wird keine
ungültige Fensterposition mehr in eine gemeinsam benutzte `Eudora.ini` geschrieben
([E-131](Intern/BEFUNDE.md#e-131)).

**Was zur Fassung 7.2.1 noch fehlt, steht erzeugt ganz oben in
[ZIEL.md](ZIEL.md)** — dort und nur dort, mit der Angabe, wer es prüft.

### Bekannte Fehler

Bis auf die mit *Selten* beginnende Zeile geht in keinem dieser Fälle eine
**Nachricht in Ihrem Postfach** verloren. Die zweite Spalte sagt, was sonst verlorengehen oder verfälscht werden kann;
*nichts* heißt, es betrifft nur Anzeige oder Bedienung.

| Was passiert | Was kann verlorengehen | Was hilft | Befund |
|---|---|---|---|
| **Bis Paket 1.0.122: Eudora vertraut vier Wurzelzertifikaten der Zertifizierungsstelle eMudhra**, unter denen am 20.10.2026 acht kompromittierte Zwischenzertifikate bekannt wurden. Wer zwischen Eudora und dem Mailserver sitzt, könnte Eudora einen gefälschten Server vorspielen | **Zugangsdaten und Post**, wenn jemand den Netzverkehr umleitet (öffentliches WLAN, fremdes Netz) | **Behoben ab dem Release 7.2.1** (schon im Testpaket 7.2.0.123) – die vier Wurzeln sind aus der mitgelieferten Liste entfernt. Bis dahin: Eudora nicht in fremden Netzen benutzen, oder `rootcerts.p7b` im Programmverzeichnis durch die neue Datei ersetzen. Liegt eine eigene `rootcerts.p7b` im Mailverzeichnis, gilt **diese** – auch nach dem neuen Paket. Einzelheiten unten | [E-148](Intern/BEFUNDE.md#e-148) |
| **Eudora startet per Doppelklick nicht, weil das zuletzt benutzte Mailverzeichnis gelöscht oder verschoben wurde** — Meldung *„The directory specified in the command line … doesn't exist or is not writable"* (Text aus `IDS_ERR_BAD_EUDORA_DIR`, gesetzt in `CheckMailDirectory`) | nichts — die Daten sind schon vorher weg, Eudora fasst nichts an | **`Eudora starten.cmd` benutzen.** Es übergibt das eigene Mailverzeichnis des Pakets und umgeht den gemerkten Pfad. Bleibt so, auf Gregors Entscheidung vom 21.10.2026: *„nur aufnehmen, nicht fixen"* | [E-133](Intern/BEFUNDE.md#e-133) |
| **Nach dem Herunterladen von GitHub startet `Eudora.exe` nicht per Doppelklick** — nur der Umweg über `Eudora starten.cmd` geht. Windows hängt beim Auspacken an jede Datei die Markierung *„stammt von einem anderen Computer“* (*Mark of the Web*) | nichts — das Programm startet nur nicht | **ZIP vor dem Auspacken entsperren**: Rechtsklick auf die `.zip` → Eigenschaften → *Zulassen*. Schon ausgepackt: siehe unten | [E-138](Intern/BEFUNDE.md#e-138) |
| Läuft eine Fassung **vor 7.2.0.113** neben einer vorhandenen Eudora oder Hermes 7.1, schreibt sie `MRUFloatXPos=-2147483648` – eine ungültige Fensterposition – in die gemeinsam benutzte `Eudora.ini`. Der Melder berichtet, dass sein Hermes 7.1 danach beim Start abstürzte (`EXCEPTION_ACCESS_VIOLATION` in `MFC71.DLL`) | nichts von Ihrer Post – aber möglicherweise die **Benutzbarkeit der vorhandenen Installation** | **Behoben in 7.2.0.113, seit `v1.0.113` veröffentlicht:** diese Fassung schreibt den Wert nicht mehr, am Prüfstand rot und grün gemessen. **Zwei Einschränkungen:** eine `Eudora.ini`, die den Wert schon trägt, wird erst beim nächsten Sichern durch unsere Fassung berichtigt – wer sie nicht mehr startet, berichtigt sie von Hand oder spielt die Sicherung zurück. Und **dass dieser Wert der Grund des Absturzes war, ist nicht belegt** ([PRÜFER-40](Befunde/PRUEFER-40.md#k1) K1: `-2147483648` ist `CW_USEDEFAULT`, das MFC selbst setzt und beim Lesen wieder abfängt); belegt ist nur, dass wir ihn schreiben. **Sicherheitshalber weiter:** `Eudora.ini` und Mailverzeichnis sichern, bevor diese Fassung neben einer vorhandenen Installation läuft. Von außen gemeldet ([Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102), 18.10.2026, an `v1.0.101`) | [E-131](Intern/BEFUNDE.md#e-131) |
| Eine Nachricht, die der Filter nicht lesen kann, wird still übersprungen | nichts geht verloren – **diese eine Nachricht** bleibt ungefiltert liegen, die übrigen werden weiter gefiltert (am Quelltext gelesen für *Filter Messages*, [LEKTOR-41](Befunde/LEKTOR-41.md)) | nach dem Filtern stichprobenartig nachsehen; ab 7.2.0.106 (seit `v1.0.112` veröffentlicht) steht die Nachricht mit Betreff und Grund im Fenster *Task Errors*, ab 7.2.0.110 nur noch der erste Fall eines Laufs einzeln und der Rest als ein Sammeleintrag, und es piept höchstens einmal je zwei Sekunden | [E-69](Intern/BEFUNDE.md#e-69) |
| Eine als Datei gespeicherte Nachricht zeigt in anderen Programmen falsche Zeichen | die **gespeicherte Datei** ist verfälscht (die Nachricht im Postfach nicht) | die Nachricht im Postfach lassen oder weiterleiten statt speichern. **In 7.2.0.107 bis 7.2.0.109 — alle drei nie als Paket geschnürt — war es für Post in `windows-1251`, `koi8-r` oder `iso-8859-2` schlechter als in `v1.0.101`; ab 7.2.0.110 nicht mehr** ([PRÜFER-37](Befunde/PRUEFER-37.md) F3/F4 behoben). Bei Latin-1- und UTF-8-Post trat das nie auf | [E-101](Intern/BEFUNDE.md#e-101) |
| Eine über *File → Save As* gespeicherte Nachricht heißt immer `.txt` – auch wenn ihr Inhalt HTML ist, und ohne jeden Hinweis | nichts – der Inhalt ist vollständig, nur die Endung passt nicht | die Datei in `.html` umbenennen und im Browser öffnen, oder in `.eml` umbenennen und in Thunderbird | [E-128](Intern/BEFUNDE.md#e-128) |
| Wird die gerade benutzte Persönlichkeit gelöscht, können Reste ihrer Einstellungen wiederkommen | **Einstellungen** der Persönlichkeit (Ihre Post nicht) | vorher auf eine andere Persönlichkeit wechseln | [E-39](Intern/BEFUNDE.md#e-39) |
| Selten, vermutet: wird eine **gesendete** Mail genau in dem Moment in einen IMAP-Ordner verschoben, in dem Eudora diesen Ordner gerade abgleicht, kommt sie nicht auf dem Server an und liegt nur im lokalen Papierkorb | diese **gesendete Mail**, wenn danach der Papierkorb geleert wird | nach dem Verschieben kurz im IMAP-Ordner nachsehen; den Papierkorb nicht sofort leeren | [E-126](Intern/BEFUNDE.md#e-126) |
| Nach einem Neustart mitten im Verschieben nach IMAP können eingebettete Bilder einer Nachricht fehlen; die Nachricht selbst bleibt | die **eingebetteten Bilder** dieser Nachricht | vor dem Beenden warten, bis das Verschieben fertig ist. Ab 7.2.0.104 (seit `v1.0.112` veröffentlicht) wartet Eudora beim Beenden selbst, bis das Hochladen fertig ist; ab 7.2.0.108 wird nach fünf Minuten **nicht** mehr erzwungen beendet, sondern das Beenden aufgegeben — das Fenster bleibt offen und der Grund steht in der Statuszeile. Nach einem Absturz, Stromausfall oder erzwungenen Herunterfahren kann es weiter passieren | [E-123](Intern/BEFUNDE.md#e-123) |
| War der IMAP-Ordner seit dem Start **noch nie geöffnet**, konnten die eben dorthin verschobenen Mails in seiner Liste fehlen, bis man ihn noch einmal schloss und öffnete. **Am 23.10.2026 in zwei Läufen an 7.2.0.120 nicht mehr aufgetreten; die Ursache wurde nie gefunden** — wer es sieht, bitte melden | nichts – die Mails sind auf dem Server | den Ordner schließen und neu öffnen | [E-127](Intern/BEFUNDE.md#e-127) |
| Wird **ohne Serververbindung** in einen IMAP-Ordner verschoben und sofort beendet, zeigt der Zielordner danach nur einen Teil der Nachrichten | nichts – die Nachrichten stehen weiter im Ausgangspostfach | *Rechtsklick auf das Postfach → Show Deleted Messages* macht sie wieder sichtbar, *Message → UnDelete* holt sie zurück; *Message → Purge Messages* dabei **nicht** benutzen – das entfernt sie | [E-129](Intern/BEFUNDE.md#e-129) |
| **Verzeichnisdienste** (LDAP, Ph, EudoraBk) und S/MIME fehlen — Dialog *„Directory Services unavailable“*. **Das eigene Adressbuch ist davon nicht betroffen** und arbeitet | nichts | – (die Bibliotheken von 2003 dürfen nicht mitgeliefert werden) | [E-47](Intern/BEFUNDE.md#e-47) |
| Bilder, die als `data:` im HTML stecken, erscheinen beim Antworten und Weiterleiten als grauer Kasten | nichts | – | [E-119](Intern/BEFUNDE.md#e-119) |
| Sehr breite Bilder laufen rechts aus dem Fenster; Größenangaben wie `35px` können ein Bild verzerren | nichts | – | [E-113](Intern/BEFUNDE.md#e-113), [E-116](Intern/BEFUNDE.md#e-116) |
| In einen IMAP-Ordner hochgeladene Nachrichten tragen ein um die Zeitzone verschobenes Eingangsdatum (Sortierung) | nichts | – | [E-122](Intern/BEFUNDE.md#e-122) |
| IMAP-Ordnernamen mit Umlauten stehen roh da (`Entw&APw-rfe`) | nichts | – | [E-77](Intern/BEFUNDE.md#e-77) |
| Emoji in Betreffzeilen erscheinen gar nicht — sie fallen beim Abrufen ersatzlos weg (seit 7.2.0.59; davor standen zwei `?` je Emoji) | nichts | – | [E-90](Intern/BEFUNDE.md#e-90) |
| Im Speicherdialog fehlen *Kopfzeilen einschließen* und *Absätze raten* | nichts | es gilt die zuletzt gewählte Einstellung | [E-98](Intern/BEFUNDE.md#e-98) |
| **Bis `v1.0.120`:** eine Nachricht aus einem IMAP-Ordner nach `Out` gezogen wird nicht verschoben: in `Out` entsteht eine neue Nachricht mit `<br>` im Betreff und in den Kopfzeilen, dazu die Meldung *„No messages were transferred!“* | nichts – das Original bleibt im IMAP-Ordner; wer die neue Nachricht sendet, schickt sie mit kaputtem Empfänger | Nachrichten nicht aus einem IMAP-Ordner nach `Out` ziehen; so entstandene Einträge in `Out` nicht senden, sondern löschen. **Ab Paket 1.0.122** lehnt Eudora das Ziehen mit einem Hinweis ab | [E-125](Intern/BEFUNDE.md#e-125) |
| Der Filterbericht bleibt nach einem Filterlauf leer | nichts | – | [E-71](Intern/BEFUNDE.md#e-71) |
| Microsoft Defender kann eine Fassung fälschlich als Trojaner einstufen und das Programm ohne Meldung beenden | nichts | siehe [Windows Defender meldet Eudora als Trojaner](Doku/ANWENDER.md#windows-defender-meldet-eudora-als-trojaner) | [E-124](Intern/BEFUNDE.md#e-124) |

**Ihre Post sichern.** Eudora legt alles im Verzeichnis `Mailverzeichnis`
neben dem Programm ab. Wer es vor dem ersten Start einer neuen Fassung kopiert,
kann jederzeit zurück.

### Wenn Windows den Start blockiert (*Mark of the Web*)

Lädt man ein ZIP aus dem Netz, merkt sich Windows die Herkunft in einem
Alternativdatenstrom `Zone.Identifier` — und der Explorer vererbt ihn beim
Auspacken an **jede** einzelne Datei. Eine `.exe` wird damit blockiert, eine
`.cmd` nicht; deshalb läuft `Eudora starten.cmd` und `Eudora.exe` nicht.
**Das ist kein Fehler von Eudora 7.2**, sondern eine Windows-Vorkehrung.

**Am besten vorher:** Rechtsklick auf die heruntergeladene `.zip` →
*Eigenschaften* → unten das Kästchen *Zulassen* ankreuzen → *OK* — **dann
erst auspacken**. So bekommt keine der rund 50 Dateien die Markierung.

**Schon ausgepackt?** In PowerShell:

```powershell
Get-ChildItem -Recurse 'C:\Pfad\zum\Eudora72-Verzeichnis' | Unblock-File
```

**Nachsehen, ob es wirklich daran liegt:**

```powershell
Get-Item 'C:\Pfad\zum\Eudora72-Verzeichnis\Eudora.exe' -Stream *
```

Steht dort ein Strom `Zone.Identifier`, ist es die Markierung;
`Get-Content ... -Stream Zone.Identifier` zeigt sogar die Herkunfts-URL.
Nach dem Entsperren ist der Strom weg und der Doppelklick startet.

> Das Kästchen *Zulassen* im Eigenschaften-Dialog einer **einzelnen** Datei
> hilft nur dieser einen — die DLLs daneben tragen die Markierung weiter.

> **Nicht zu verwechseln mit dem Defender-Fehlalarm**
> ([E-124](Intern/BEFUNDE.md#e-124)): der entfernt die Datei und meldet
> `Trojan:Win32/Bearfoos.A!ml`. Hier wird nichts entfernt, der Start wird nur
> verweigert.

### Kompromittierte Zertifikate von eMudhra (Oktober 2026)

**Worum es geht.** Am 20.10.2026 wurde bekannt, dass acht
Zwischenzertifikate der indischen Zertifizierungsstelle **eMudhra** mit
Schlüsseln von nur 3 bis 8 Bit erzeugt worden waren — wer sie kennt, kann für
**jeden** Server im Internet ein Zertifikat ausstellen, dem Programme mit den
eMudhra-Wurzeln vertrauen
([Ars Technica: *„The Internet goes on high alert after discovery of 8 compromised TLS certs“*](https://arstechnica.com/security/2026/10/the-internet-goes-on-high-alert-after-discovery-of-8-compromised-tls-certs/)).
Browser haben die Zertifikate noch am selben Tag gesperrt. Der Artikel warnt
ausdrücklich vor Programmen, die **ihre eigene Liste** von
Wurzelzertifikaten mitliefern — Eudora gehört dazu.

**Warum Eudora betroffen war.** Eudora prüft Serverzertifikate nicht gegen
Windows, sondern gegen die Datei `rootcerts.p7b` — zuerst im Mailverzeichnis,
sonst im Programmverzeichnis (siehe unten) —, und
fragt keine Sperrlisten ab. Die Liste bis Paket 1.0.122 enthielt vier
eMudhra-Wurzeln (*emSign Root CA – G1*, *– C1*, *emSign ECC Root CA – G3*,
*– C3*). Ausnutzen lässt sich das nur, wenn jemand den Netzverkehr zwischen
Eudora und dem Mailserver umleitet — etwa in einem öffentlichen WLAN; dann
könnte er Eudora einen gefälschten Mailserver vorspielen und Kennwort und Post
mitlesen.

**Was behoben ist (ab dem Release 7.2.1).** Die vier Wurzeln sind aus der
mitgelieferten Liste entfernt: [`Releases/1.0/rootcerts.p7b`](Releases/1.0/rootcerts.p7b)
enthält jetzt 117 statt 121 Zertifikate, erzeugt von
[`rootcerts-erzeugen.ps1`](Releases/1.0/rootcerts-erzeugen.ps1) mit einer
Ausschlussliste, und der Paketbau legt diese Datei in jedes Paket. GMX und
freenet (IMAP, POP3, SMTP) sind gegen die neue Liste mit **OpenSSL** gemessen
und werden angenommen — ihre Zertifikate stammen von der Telekom (T-TeleSec),
nicht von eMudhra. **Mit Eudora selbst** ist das erst mit dem Testpaket 7.2.0.123 zu
messen; bis dahin ist es eine Rechnung, keine Beobachtung am Programm. Ein Regressionstest wird rot, sobald eine eMudhra-Wurzel
zurückkommt ([E-148](Intern/BEFUNDE.md#e-148)).

**Was Sie mit einem älteren Paket tun können:** Eudora beenden, die
vorhandene `rootcerts.p7b` im Programmverzeichnis in `rootcerts.p7b.alt`
umbenennen und die neue Datei aus `Releases/1.0/` hineinlegen — oder Eudora
bis zum neuen Paket nur im eigenen Netz benutzen. Ob Eudora mit der neuen
Datei bei Ihrem Anbieter weiter abruft, ist wie oben gesagt erst mit OpenSSL
gemessen: nach dem Austausch einmal Mail abrufen. Meldet Eudora einen
Zertifikatsfehler, die neue Datei löschen und `rootcerts.p7b.alt` wieder in
`rootcerts.p7b` umbenennen — dann sind allerdings auch die vier
eMudhra-Wurzeln wieder da, und für das fremde Netz gilt wieder die Vorsicht
von oben.

**Auch im Mailverzeichnis nachsehen.** Eudora sucht `rootcerts.p7b` zuerst im
**Mailverzeichnis** (dort, wo `Eudora.ini` und die Postfächer liegen) und nur,
wenn sie dort fehlt, im Programmverzeichnis — so hat QUALCOMM es gebaut, damit
man die mitgelieferte Liste durch eine eigene ersetzen kann
(`QCSSLContext.cpp`, `ChooseCertFileDirectory`). Das Paket legt dort keine
solche Datei ab. Wer aber selbst einmal eine `rootcerts.p7b` ins
Mailverzeichnis kopiert hat, behält **diese** Liste, auch mit dem neuen Paket:
dort löschen oder ebenfalls durch die neue Datei ersetzen. Gefunden von
[PRUEFER-51](Befunde/PRUEFER-51.md#pruefer-51) (K6).

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

