# Eudora 7.2

**Deutsch | [English](README.en.md)**

> **Vor dem ersten Start: sichern.** Wer bereits Eudora 7.1 oder Hermes benutzt, sichert **vorher** die `Eudora.ini` und das komplette Mailverzeichnis. Dieses Projekt startet mit einem **eigenen** Mailverzeichnis und fasst eine vorhandene Installation nicht an — `Eudora starten.cmd` hält sich daran, und wer `Eudora.exe` direkt startet, wird gefragt. Eine Sicherung kostet zwei Minuten; eine verlorene Postablage ist nicht wiederherstellbar.
>
> **Getrennte Verzeichnisse benutzen.** Die `Eudora.ini` bleibt **nicht** rückwärtskompatibel — unsere Fassung und eine vorhandene Eudora oder Hermes schreiben denselben Satz Werkzeugleisten mit unterschiedlichen MFC-Fassungen in dieselbe Datei. Wer sich **eine** INI oder **ein** Mailverzeichnis teilt, muss damit rechnen, dass die jeweils andere Installation danach Fehler zeigt. Parallelbetrieb geschieht **auf eigene Gefahr**.

**Der Mailclient Eudora 7.1, wieder baubar — mit Visual Studio 2022 unter Windows 10 und 11.**

Eudora war von 1988 bis 2006 einer der meistbenutzten Mailclients überhaupt. 2018 hat das [Computer History Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/) den Quellcode mit Genehmigung von Qualcomm freigegeben — als Archiv, nicht als baubares Projekt: er verlangt Visual C++ 6 und 7.1 von 1998 und 2003, dazu die kommerzielle Bibliothek *Stingray Objective Toolkit*, die es nicht mehr zu kaufen gibt.

**Dieses Repo macht daraus wieder ein Programm, das man bauen und benutzen kann.** Aus einem frischen Klon entsteht mit einem Befehl eine `Eudora.exe`, die auf einem heutigen Windows startet, Mail über TLS 1.3 abruft und verschickt.

---

## Update-Infos

**Aktuelles Release: [`v7.2.2.136`](https://github.com/HansWurst81675/Eudora7.2/releases/latest)** vom 06.11.2026.
Neuere Testpakete (7.2.2.137, 7.2.2.138) sind gebaut, aber **nicht veröffentlicht**.

### Versionsübersicht (neueste zuerst)

| Fassung | Art | Datum | Inhalt |
|---|---|---|---|
| **7.2.2.138** | Testpaket, nicht veröffentlicht | — | Sanduhr bei der ersten Druckvorschau ([E-240](Intern/BEFUNDE.md#e-240)); eigenes Release-ZIP aus frischem Klon baubar ([E-248](Intern/BEFUNDE.md#e-248)) |
| **7.2.2.137** | Testpaket, nicht veröffentlicht | — | Behebung der Druckvorschau für [E-242](Intern/BEFUNDE.md#e-242) gebaut (Befund noch offen: Pfad der Zwischendatei); Druck über *Microsoft Print to PDF* von Gregor bestanden |
| **7.2.2.136** | **Release** | 06.11.2026 | Kein Absturz mehr beim Beenden bei offenem Hinweis ([E-239](Intern/BEFUNDE.md#e-239)); `PrintBackground` für die Druckvorschau ([E-169](Intern/BEFUNDE.md#e-169)); „Remember password“ wirkt beim ersten Mal ([E-223](Intern/BEFUNDE.md#e-223)); Anhangsymbol bei S/MIME-signierten Mails ([E-222](Intern/BEFUNDE.md#e-222)). Voller Prüfstandslauf 110/110 am Bau `2a8fd4d7`, Unit-Tests 428/428, von Gregor getestet und freigegeben |
| 7.2.2.135 | Testpaket | 05.11.2026 | Rest von [E-193](Intern/BEFUNDE.md#e-193) (Edit → Find). Prüfbericht bestanden (425 Unit-Tests, 19 Schranken, 103 Prüfstandsfälle; im vollen Lauf 3 Fälle rot, einzeln grün, darunter der Absturz [E-239](Intern/BEFUNDE.md#e-239)) |
| 7.2.2.134 | Testpaket | 05.11.2026 | [E-223](Intern/BEFUNDE.md#e-223), [E-222](Intern/BEFUNDE.md#e-222); 424 Unit-Tests, 19 Schranken, 102 Prüfstandsfälle |
| **7.2.2.133** | **Release** | 05.11.2026 (geschnürt 04.11.) | [E-188](Intern/BEFUNDE.md#e-188), [E-192](Intern/BEFUNDE.md#e-192), [E-193](Intern/BEFUNDE.md#e-193), [E-199](Intern/BEFUNDE.md#e-199), [E-220](Intern/BEFUNDE.md#e-220), [E-221](Intern/BEFUNDE.md#e-221). Gregors Test fand drei neue Fehler aus dem Original ([E-222](Intern/BEFUNDE.md#e-222), [E-223](Intern/BEFUNDE.md#e-223), Rest [E-193](Intern/BEFUNDE.md#e-193)) |
| **7.2.2.132** | **Release** | 03.11.2026 | Erste Fassung der Reihe 7.2.2: Hilfe-Menü ([A-5](Intern/BEFUNDE.md#a-5)), About-Dialog mit Latest Release ([E-216](Intern/BEFUNDE.md#e-216)), Speichern unter mit passender Endung ([E-128](Intern/BEFUNDE.md#e-128)); Persönlichkeiten ([E-39](Intern/BEFUNDE.md#e-39), [E-203](Intern/BEFUNDE.md#e-203), [E-204](Intern/BEFUNDE.md#e-204)), Speichern ([E-194](Intern/BEFUNDE.md#e-194)–[E-196](Intern/BEFUNDE.md#e-196), [E-205](Intern/BEFUNDE.md#e-205), [E-207](Intern/BEFUNDE.md#e-207)), fehlendes Mailverzeichnis ([E-133](Intern/BEFUNDE.md#e-133)), IMAP-Label ([E-170](Intern/BEFUNDE.md#e-170)). 408 Unit-Tests, 19 Schranken, 81 Prüfstandsfälle; Testschritte: [TESTPLAN](Intern/TESTPLAN.md#test-7-2-2-132) |
| **7.2.1.131** | **Release** | 02.11.2026 | Enthält die nicht veröffentlichten Testpakete 7.2.1.129 und 7.2.1.130 (u. a. [E-72](Intern/BEFUNDE.md#e-72) Filter mit verneinter Bedingung, [E-122](Intern/BEFUNDE.md#e-122) Eingangsdatum bei IMAP). Testschritte: [TESTPLAN](Intern/TESTPLAN.md#test-7-2-1-131) |
| **7.2.1.128** | **Release** | 29.10.2026 | Erstes Release 7.2.1; enthält die Testpakete 7.2.0.123–7.2.0.127 (u. a. entfernte eMudhra-Wurzelzertifikate [E-148](Intern/BEFUNDE.md#e-148), IMAP-Ordnernamen mit Umlauten [E-77](Intern/BEFUNDE.md#e-77), Bilder in HTML-Mails [E-113](Intern/BEFUNDE.md#e-113), [E-119](Intern/BEFUNDE.md#e-119)) |
| `v1.0.120` | Release | 21.10.2026 | Eudora übernimmt ein fremdes Mailverzeichnis nicht mehr stillschweigend, sondern fragt vorher ([E-132](Intern/BEFUNDE.md#e-132)); weitere Korrekturen [E-131](Intern/BEFUNDE.md#e-131), [E-134](Intern/BEFUNDE.md#e-134), [E-135](Intern/BEFUNDE.md#e-135) |

Was sich je Fassung genau geändert hat, steht im [CHANGELOG](CHANGELOG.md); die Testschritte zu einer Fassung im [TESTPLAN](Intern/TESTPLAN.md).

**Zur Versionsnummer:** Bis 7.2.1.128 hatten veröffentlichte Pakete eine eigene Zählung (`v1.0.x`), die von der Nummer im Quellstand abwich. Seit 7.2.1.128 tragen Quellstand, `VERSION`, ZIP und Marke dieselbe Nummer ([PAKETE](Releases/PAKETE.md#drei-z%C3%A4hlungen-und-wie-sie-zusammenh%C3%A4ngen)).

### Wichtig beim Aktualisieren

- **Vorher sichern:** `Eudora.ini` und Mailverzeichnis kopieren, bevor eine neue Fassung zum ersten Mal läuft.
- **Neue Fassung übernehmen:** siehe [Doku/FAQ.md](Doku/FAQ.md) (Frage zur neuen Fassung).
- **Wer 7.2.1.128 oder älter benutzt:** Filter mit verneinter Bedingung („doesn't appear“, „doesn't contain“, „is not“) treffen dort jede Nachricht und können mit der Aktion *transfer* den ganzen Posteingang verschieben ([E-72](Intern/BEFUNDE.md#e-72)). Ab 7.2.1.129 behoben, im Release 7.2.1.131 enthalten.
- **Wer `v1.0.117` oder älter benutzt:** diese Fassungen fassen ein vorhandenes Eudora-/Hermes-Mailverzeichnis ohne Rückfrage an. Unbedingt Hinweis oben beachten.
- **Zertifikate:** Fassungen bis Paket 1.0.122 vertrauen vier Wurzelzertifikaten von eMudhra, zu denen am 20.10.2026 kompromittierte Zwischenzertifikate bekannt wurden. Behoben ab Release 7.2.1, siehe [unten](#kompromittierte-zertifikate-von-emudhra-oktober-2026).
- **Eigene `rootcerts.p7b` im Mailverzeichnis** hat Vorrang vor der mitgelieferten und wird beim Update **nicht** ersetzt.

---

## Wo fange ich an?

| Ich will … | … dann hierhin |
|---|---|
| **es einfach ausprobieren** | [Neuestes Paket herunterladen](https://github.com/HansWurst81675/Eudora7.2/releases/latest) — vor dem Auspacken die ZIP entsperren (siehe [Mark of the Web](#wenn-windows-den-start-blockiert-mark-of-the-web)), dann `Eudora starten.cmd` doppelklicken. Nichts zu installieren |
| **wissen, was geht und was nicht** | [Was geht](#was-geht) und [Bekannte Fehler](#bekannte-fehler) gleich hier; ausführlich in [Doku/ANWENDER.md](Doku/ANWENDER.md) |
| **es benutzen** (Filter, Defender, IMAP-Kennwort, Protokoll) | [Doku/ANWENDER.md](Doku/ANWENDER.md) |
| **eine schnelle Antwort** | [Doku/FAQ.md](Doku/FAQ.md) — häufige Fragen, nummeriert |
| **wissen, welche Einstellungen anders sind als im Original Eudora — und warum** | [Intern/EINSTELLUNGEN.md](Intern/EINSTELLUNGEN.md#abweichungen) |
| **es selbst bauen** | [Doku/BAUEN.md](Doku/BAUEN.md) — Visual Studio 2022 mit „Desktopentwicklung mit C++“, ein Befehl; bis zum eigenen Release-ZIP: [Ein eigenes Release-ZIP bauen](Doku/BAUEN.md#ein-eigenes-release-zip-bauen--aus-einem-frischen-klon) (seit 7.2.2.138, [E-248](Intern/BEFUNDE.md#e-248)) |
| **eigene Änderungen prüfen** | [Prüfstand](#eigene-änderungen-prüfen-prüfstand) — `Pruefstand starten.cmd`, Anleitung in [Doku/PRUEFSTAND.md](Doku/PRUEFSTAND.md) |
| **einen Fehler melden** | [Einen Fehler melden](Doku/ANWENDER.md#einen-fehler-melden) |
| **mitarbeiten** | [Doku/MITARBEITEN.md](Doku/MITARBEITEN.md) |
| **wissen, wie portiert wurde** | [Doku/HINTERGRUND.md](Doku/HINTERGRUND.md) und [Intern/PORTIERUNG.md](Intern/PORTIERUNG.md) |

### Wenn hier jemand — oder eine KI — weiterarbeiten soll

Die Reihenfolge ist wichtig, und sie ist kurz:

1. [**CLAUDE.md**](CLAUDE.md) — was *vor* dem ersten Handgriff zu tun ist.
2. **`perl tools/offene-befunde.pl`** — was offen ist. Die erzeugte Tabelle in [Intern/WEITERMACHEN.md](Intern/WEITERMACHEN.md) nennt zu jedem Punkt, **was noch fehlt**, nicht nur, wie er eingestuft ist.
3. [**ZIEL.md**](ZIEL.md) — woran „fertig“ gemessen wird: neun Kriterien, dazu die erzeugte Liste dessen, was zur nächsten Fassung noch fehlt. **ZIEL.md ist die Quelle**; widerspricht ihr eine andere Datei, weist `tools/doku-pruefen.pl` den Commit ab.

### Welche Datei wofür da ist

Im Wurzelverzeichnis liegt, was **für Leser** gedacht ist. Unser Arbeitsmaterial steht unter [`Intern/`](Intern) — zum **Nachschlagen**, nicht zum Lesen.

| Für Leser | |
|---|---|
| [README.md](README.md) | diese Datei: Einstieg, Update-Infos, Wegweiser |
| [Doku/](Doku) | Benutzung, Bauen, Mitarbeiten, technischer Hintergrund |
| [ZIEL.md](ZIEL.md) | woran „fertig“ gemessen wird, und was noch fehlt (erzeugt) |
| [CHANGELOG.md](CHANGELOG.md) | was sich je Fassung geändert hat, und die erzeugte Liste der offenen Befunde |
| [Releases/PRUEFBERICHT.md](Releases/PRUEFBERICHT.md) | **jeder Test** mit Ergebnis, Zeitpunkt und Bau. Nach einer eigenen Änderung vergleicht `perl tools/pruefbericht.pl --vergleich` mit diesem Stand und nennt, was neu rot ist |
| [MELDUNGEN-VON-AUSSEN.md](MELDUNGEN-VON-AUSSEN.md) | gemeldete Fehler von außen, mit Stand (auf Englisch) |
| [LICENSE](LICENSE) | wer es wie benutzen darf |
| [CLAUDE.md](CLAUDE.md) | was ein Agent **vor** dem ersten Handgriff tut |

| `Intern/` — nachschlagen, nicht lesen | |
|---|---|
| [BEFUNDE.md](Intern/BEFUNDE.md) | jeder Befund mit Messung, Urteil und **was noch fehlt**; über die Kennung (`#e-nnn`) anspringen. Legende der Kürzel ganz oben |
| [WEITERMACHEN.md](Intern/WEITERMACHEN.md) | was zu tun ist (erzeugte Liste) |
| [AUFGABEN.md](Intern/AUFGABEN.md), [TESTPLAN.md](Intern/TESTPLAN.md) | Arbeitspakete und Prüfpunkte |
| [PORTIERUNG.md](Intern/PORTIERUNG.md) | Portierungstagebuch |
| [LEKTORAT.md](Intern/LEKTORAT.md), [PRUEFBERICHT.md](Intern/PRUEFBERICHT.md) | Berichte der Rollen LEKTOR und PRÜFER (Archiv bis 30.08.2026 — nicht zu verwechseln mit dem Testbericht `Releases/PRUEFBERICHT.md`) |
| [PRUEFUNG-BAU.md](Intern/PRUEFUNG-BAU.md), [PRUEFUNG-CODE.md](Intern/PRUEFUNG-CODE.md), [PRUEFUNG-BRANCH.md](Intern/PRUEFUNG-BRANCH.md) | Prüfanleitungen |
| [FILTER.md](Intern/FILTER.md), [EINSTELLUNGEN.md](Intern/EINSTELLUNGEN.md), [STARTUMGEBUNG.md](Intern/STARTUMGEBUNG.md), [ABRUF-PRUEFEN.md](Intern/ABRUF-PRUEFEN.md) | Einzelthemen im Detail |
| [AGENTEN.md](Intern/AGENTEN.md) | wie hier mit Agenten gearbeitet wird |
| [BEFUNDE-ALTBESTAND.md](Intern/BEFUNDE-ALTBESTAND.md) | abgeschlossene Befunde aus der Frühzeit |

Dazu [`Befunde/`](Befunde) (LEKTOR- und PRÜFER-Berichte), [`Arbeitsweise/`](Arbeitsweise) (Lehren aus Fehlern) und [`tools/`](tools) (Werkzeuge und Schranken). *Zählstand vom 02.11.2026 mit `git ls-files`: 219 Berichte, 124 Lehren, über 100 Werkzeuge — die Zahlen ändern sich laufend.*

---

## Was geht

- **Mail abrufen und senden** über POP3, IMAP und SMTP mit **TLS 1.3** — auch an heutigen Servern (geprüft an GMX und freenet). Das Original von 2006 kann nur SSL 3.0 / TLS 1.0 und kommt an keinen heutigen Mailserver mehr heran.
- **Lesen** von Text- und HTML-Nachrichten, mit Bildern in der richtigen Größe.
- **Schreiben, antworten, weiterleiten**, Anhänge mit vollem Namen und Endung, mehrere Persönlichkeiten, Filter, Postfachverwaltung.
- **Verschieben in einen IMAP-Ordner** — auch HTML-Nachrichten mit eingebetteten Bildern und gesendete Post; die Nachricht verschwindet aus dem lokalen Postfach erst, wenn sie auf dem Server steht.
- **Ohne Installation:** ZIP auspacken, `Eudora starten.cmd` doppelklicken. Das Paket installiert nichts und legt nichts nach `C:\Program Files`.
- **Selbst weiterbauen:** Der Quellbaum übersetzt vollständig mit MSVC v143 und MFC 14, ohne die Stingray-Bibliothek — an ihrer Stelle steht ein Nachbau in [`Eudora71/OTShim`](Eudora71/OTShim) (siehe [Die Ersatzschicht für Stingray OT501](Doku/HINTERGRUND.md#die-ersatzschicht-f%C3%BCr-stingray-ot501)).

**Nicht `Eudora.exe` direkt starten.** Ohne Angabe des Mailverzeichnisses sucht Eudora sich eines und findet dabei über die Registry das einer **vorhandenen** Eudora- oder Hermes-Installation, auch in einem ganz anderen Ordner, und schreibt dann in deren `Eudora.ini` ([E-132](Intern/BEFUNDE.md#e-132)). `Eudora starten.cmd` übergibt das Verzeichnis als Argument und verhindert das; wer eine Verknüpfung anlegt, gibt den Pfad mit an: `Eudora.exe "C:\…\Mailverzeichnis"`. Ab 7.2.0.114 fragt Eudora vorher und legt ohne Zutun ein eigenes Verzeichnis an (auf allen Startwegen seit 7.2.0.116, auch bei einem fremden Ordner ohne `Eudora.ini` seit 7.2.0.117); veröffentlicht seit `v1.0.120`. Für `v1.0.117` und älter gilt der Hinweis oben unverändert.

**Was zur nächsten Fassung noch fehlt,** steht erzeugt ganz oben in [ZIEL.md](ZIEL.md) — dort und nur dort, mit der Angabe, wer es prüft.

---

## Bekannte Fehler

Stand: Release **7.2.2.136**. Behobene Fehler stehen in den [Update-Infos](#update-infos) und im [CHANGELOG](CHANGELOG.md); hier steht, was **im Release noch offen oder nur teilweise behoben** ist. Messung, Urteil und Quelltextstelle zu jedem Punkt stehen in [Intern/BEFUNDE.md](Intern/BEFUNDE.md) unter der genannten Kennung.

**Ihre Post sichern.** Eudora legt alles im Verzeichnis `Mailverzeichnis` neben dem Programm ab. Wer es vor dem ersten Start einer neuen Fassung kopiert, kann jederzeit zurück.

### Drucken

| Befund | Was passiert | Was hilft | Stand |
|---|---|---|---|
| [E-242](Intern/BEFUNDE.md#e-242) | Druck und Druckvorschau zeigen unten den Pfad der Zwischendatei (`file:///C:/Users/<Windows-Benutzer>/…`) statt *„Printed for …“*; der Windows-Anmeldename steht auf dem Ausdruck | Ausdruck vor Weitergabe prüfen | Behebung der Druckvorschau im Testpaket 7.2.2.137 gebaut, Befund noch offen (nicht veröffentlicht); Druck über *Microsoft Print to PDF* von Gregor an 7.2.2.137 bestanden |
| [E-240](Intern/BEFUNDE.md#e-240) | *File → Print Preview* braucht beim ersten Aufruf nach dem Start lange (rund 38 s gestoppt) ohne Rückmeldung | warten, nicht erneut klicken | Sanduhr im Testpaket 7.2.2.138 (nicht veröffentlicht) |

### Fehlende Funktionen

| Befund | Was passiert | Was hilft |
|---|---|---|
| [E-47](Intern/BEFUNDE.md#e-47) | **Verzeichnisdienste** (LDAP, Ph, EudoraBk), **S/MIME** und der **Junk-Filter** fehlen — Dialog *„Directory Services unavailable“*. Das eigene Adressbuch ist nicht betroffen | Brauchen `MFC71.DLL` und `msvcp71.dll` (Microsoft, 2003) neben der `Eudora.exe`, z. B. aus einer vorhandenen Eudora 7.1, Hermes oder Visual Studio 2003; ein offizielles Nachinstallationspaket gibt es nicht, **von DLL-Download-Seiten raten wir ab**. Ohne sie läuft Eudora, nur diese Zusätze fehlen. Die Bibliotheken von 2003 dürfen nicht mitgeliefert werden ([FILTER.md](Intern/FILTER.md#warum-die-junk-bewertung-hier-nicht-arbeitet)) |
| [E-90](Intern/BEFUNDE.md#e-90) | Emoji in Betreffzeilen erscheinen nicht — sie fallen beim Abrufen ersatzlos weg | — |
| [E-98](Intern/BEFUNDE.md#e-98) | Im Speicherdialog fehlen *Kopfzeilen einschließen* und *Absätze raten* | es gilt die zuletzt gewählte Einstellung |
| [E-139](Intern/BEFUNDE.md#e-139) | Rechtschreibprüfung fehlt in dieser Fassung; die Meldung kommt bei jedem Start | mit *OK* wegklicken (in 7.2.1.129 behoben, siehe CHANGELOG) |

### Speichern, Zeichensätze, Suche

| Befund | Was passiert | Was hilft |
|---|---|---|
| [E-198](Intern/BEFUNDE.md#e-198) | Mehrteilige empfangene Nachricht in einem von Eudora beim Empfang nicht übersetzten Zeichensatz (`windows-1251`, `koi8-r`, `iso-8859-2`) bekommt bei *Speichern unter* und der Filteraktion *Notify Application* die Angabe `ISO-8859-1`; die gespeicherte Datei zeigt dann Zeichensalat (die Nachricht im Postfach nicht) | — |
| [E-207](Intern/BEFUNDE.md#e-207) | *File → Save As* im **Signaturfenster**: schreibt seit 7.2.2.132 den Inhalt, aber das Fenster fragt danach beim Schließen nicht, die Änderung steht nur in der Kopie; der Dialog bietet weiter *Rtf Files* an und schreibt Text | Signatur mit *File → Save* sichern; als `.txt` statt `.rtf` speichern |
| [E-136](Intern/BEFUNDE.md#e-136), [E-178](Intern/BEFUNDE.md#e-178), [E-179](Intern/BEFUNDE.md#e-179) | Emoji und Zeichen außerhalb des westeuropäischen Zeichensatzes können beim Speichern oder Bearbeiten zu `?` werden. Behoben für *Strg+S*, Link, Festbreite (7.2.1.129–130, am Prüfstand gemessen); **nicht gemessen:** *Speichern unter* als `.htm`, Antwort auf markierten Text, Textteil neben dem HTML-Teil und die Suche | in betroffenen Nachrichten nicht bearbeiten und speichern; vorher Postfach sichern |
| [E-193](Intern/BEFUNDE.md#e-193) | Suche mit Umlauten oder `€`: *Find Messages* in 7.2.2.133 behoben; Rest (*Edit → Find* meldet *„not found“*) im Testpaket 7.2.2.135. Die genaue Suche in IMAP-Postfächern ist am Prüfstand nicht gemessen | findet *Edit → Find* ein Wort nicht, das *Find Messages* meldet: einmal oben in den Text klicken und erneut suchen |
| [E-71](Intern/BEFUNDE.md#e-71) | Der Filterbericht bleibt leer — kein Fehler, er ist ab Werk aus (wie im Original) | *Tools → Options → Getting Attention → Generate filter report*, siehe [FAQ 23](Doku/FAQ.md#23-warum-ist-der-filterbericht-leer) |
| [E-220](Intern/BEFUNDE.md#e-220) | Neues Postfach mit Umlaut im Namen (*Prüfung*) bekommt eine Datei ohne Umlaut (`Prfung.mbx`); in Eudora heißt es richtig | bewusst so gelassen; [Issue](https://github.com/HansWurst81675/Eudora7.2/issues) oder PR willkommen |

### IMAP

| Befund | Was passiert | Was hilft |
|---|---|---|
| [E-188](Intern/BEFUNDE.md#e-188) | **Verweigert ein IMAP-Server dauerhaft einen Teil einer Mail** (Anhang, eingebettetes Bild), holt Eudora die Mail bei jedem Anzeigen neu; Postfachdatei und Anhangordner können wachsen. Beim Verschieben bleibt die Mail in der Quelle stehen (Gregors Entscheidung vom 04.11.2026: *Sicherheit vor Platz*), im Ziel steht ein leerer Eintrag. Selten | Wächst eine Postfachdatei auffällig, die Mail auf dem Server prüfen; die Quelle nach dem Verschieben nicht von Hand löschen; den leeren Eintrag im Ziel nicht für die verschobene Mail halten |
| [E-184](Intern/BEFUNDE.md#e-184), [E-189](Intern/BEFUNDE.md#e-189) | Verschieben zwischen IMAP-Ordnern desselben Kontos, wenn im Ziel schon eine andere Mail dieselbe interne Nummer trägt: Anzeige in 7.2.1.131 berichtigt. Ohne UIDPLUS steht die Mail im Ziel unter der alten Nummer neben der anderen | **scheinbare Doppel im Ziel nicht löschen** — auf dem Server trifft das vermutlich die andere Mail |
| [E-142](Intern/BEFUNDE.md#e-142) | Entwurf aus einem IMAP-Ordner nach `Out` gezogen ergibt eine **leere** Nachricht; das Original bleibt im IMAP-Ordner. Ab 7.2.1 fragt Eudora vorher nach. Zur Meldung *„No messages were transferred!“* siehe [E-141](Intern/BEFUNDE.md#e-141) | Entwürfe im lokalen `Out` lassen (*Strg+S*); das Original erst löschen, wenn die Kopie geprüft ist |
| [E-129](Intern/BEFUNDE.md#e-129) | Ohne Serververbindung nach IMAP verschoben und sofort beendet: der Zielordner zeigt nur einen Teil der Nachrichten | *Rechtsklick auf das Postfach → Show Deleted Messages*, dann *Message → UnDelete*; **nicht** *Purge Messages* benutzen |
| [E-126](Intern/BEFUNDE.md#e-126) | Selten, vermutet: eine **gesendete** Mail, die genau während des Ordnerabgleichs verschoben wird, kommt nicht auf dem Server an und liegt nur im lokalen Papierkorb | nach dem Verschieben kurz im IMAP-Ordner nachsehen; Papierkorb nicht sofort leeren |
| [E-123](Intern/BEFUNDE.md#e-123) | Nach Absturz, Stromausfall oder erzwungenem Herunterfahren mitten im Verschieben können eingebettete Bilder fehlen (beim normalen Beenden wartet Eudora seit 7.2.0.104) | vor dem Beenden warten, bis das Verschieben fertig ist |
| [E-127](Intern/BEFUNDE.md#e-127) | War ein IMAP-Ordner seit dem Start noch nie geöffnet, konnten verschobene Mails in der Liste fehlen. Zuletzt am 23.10.2026 nicht mehr aufgetreten, **Ursache nie gefunden** | Ordner schließen und neu öffnen; bitte melden |
| [E-233](Intern/BEFUNDE.md#e-233) | IMAP-Mail, deren Betreff gleich hinter `Subject:` umbricht, steht vermutlich ohne Betreff in der Liste (am Quelltext belegt, nicht gemessen) | Mail öffnen; der Betreff steht im Kopf |
| [AN-1](Intern/BEFUNDE.md#an-1) | Ein Anhang ganz ohne Endung im Dateinamen bekommt über IMAP keine Endung (über POP schon) | Datei im Anhangverzeichnis umbenennen |
| [E-77](Intern/BEFUNDE.md#e-77) | Vor dem Update auf 7.2.1 mit *Fcc* in einen IMAP-Ordner mit Umlaut gespeicherte Nachrichten werden gesendet, aber **ohne Meldung nicht abgelegt** | vor dem Senden das Ablage-Ziel neu wählen |

### Sonstiges

| Befund | Was passiert | Was hilft |
|---|---|---|
| [E-173](Intern/BEFUNDE.md#e-173) | Beim Anlegen eines Filters mit *Make Label* können die Labels einmal ausgegraut sein (Vermutung, nicht nachgestellt) | Filter löschen und neu anlegen |
| [E-222](Intern/BEFUNDE.md#e-222) | Nach dem Öffnen einer S/MIME-signierten Mail über das Anhangsymbol stehen über dem Inhalt zwei Zeilen Kopftext (unkritisch, offen) | — |
| [E-124](Intern/BEFUNDE.md#e-124) | Microsoft Defender kann eine Fassung fälschlich als Trojaner einstufen und das Programm ohne Meldung beenden | [Windows Defender meldet Eudora als Trojaner](Doku/ANWENDER.md#windows-defender-meldet-eudora-als-trojaner) |

Bei jedem Fehler gilt: Die Post selbst geht in den genannten Fällen nicht verloren; *Was hilft* beschreibt, wie man Anzeige- und Bedienprobleme umgeht. Wo es um Kennwörter, fremde Server oder Zertifikate geht, steht es ausdrücklich dabei (siehe [E-204](Intern/BEFUNDE.md#e-204) in 7.2.2.132 behoben, [eMudhra](#kompromittierte-zertifikate-von-emudhra-oktober-2026)).

---

## Wenn Windows den Start blockiert (*Mark of the Web*)

Lädt man ein ZIP aus dem Netz, merkt sich Windows die Herkunft in einem Alternativdatenstrom `Zone.Identifier` — und der Explorer vererbt ihn beim Auspacken an **jede** einzelne Datei. Eine `.exe` wird damit blockiert, eine `.cmd` nicht; deshalb läuft `Eudora starten.cmd`, aber `Eudora.exe` per Doppelklick nicht. **Das ist kein Fehler von Eudora 7.2**, sondern eine Windows-Vorkehrung ([E-138](Intern/BEFUNDE.md#e-138)).

**Am besten vorher:** Rechtsklick auf die heruntergeladene `.zip` → *Eigenschaften* → unten das Kästchen *Zulassen* ankreuzen → *OK* — **dann erst auspacken**. So bekommt keine der Dateien die Markierung.

**Schon ausgepackt?** In PowerShell:

```
Get-ChildItem -Recurse 'C:\Pfad\zum\Eudora72-Verzeichnis' | Unblock-File
```

**Nachsehen, ob es wirklich daran liegt:**

```
Get-Item 'C:\Pfad\zum\Eudora72-Verzeichnis\Eudora.exe' -Stream *
```

Steht dort ein Strom `Zone.Identifier`, ist es die Markierung; `Get-Content ... -Stream Zone.Identifier` zeigt sogar die Herkunfts-URL. Nach dem Entsperren ist der Strom weg und der Doppelklick startet.

> Das Kästchen *Zulassen* im Eigenschaften-Dialog einer **einzelnen** Datei hilft nur dieser einen — die DLLs daneben tragen die Markierung weiter.

> **Nicht zu verwechseln mit dem Defender-Fehlalarm** ([E-124](Intern/BEFUNDE.md#e-124)): der entfernt die Datei und meldet `Trojan:Win32/Bearfoos.A!ml`. Hier wird nichts entfernt, der Start wird nur verweigert.

---

## Kompromittierte Zertifikate von eMudhra (Oktober 2026)

**Worum es geht.** Am 20.10.2026 wurde bekannt, dass acht Zwischenzertifikate der indischen Zertifizierungsstelle **eMudhra** mit Schlüsseln von nur 3 bis 8 Bit erzeugt worden waren — wer sie kennt, kann für **jeden** Server im Internet ein Zertifikat ausstellen, dem Programme mit den eMudhra-Wurzeln vertrauen ([Ars Technica](https://arstechnica.com/security/2026/10/the-internet-goes-on-high-alert-after-discovery-of-8-compromised-tls-certs/)). Browser haben die Zertifikate noch am selben Tag gesperrt. Der Artikel warnt ausdrücklich vor Programmen, die **ihre eigene Liste** von Wurzelzertifikaten mitliefern — Eudora gehört dazu.

**Warum Eudora betroffen war.** Eudora prüft Serverzertifikate nicht gegen Windows, sondern gegen die Datei `rootcerts.p7b` — zuerst im Mailverzeichnis, sonst im Programmverzeichnis — und fragt keine Sperrlisten ab. Die Liste bis Paket 1.0.122 enthielt vier eMudhra-Wurzeln (*emSign Root CA – G1*, *– C1*, *emSign ECC Root CA – G3*, *– C3*). Ausnutzen lässt sich das nur, wenn jemand den Netzverkehr zwischen Eudora und dem Mailserver umleitet, etwa in einem öffentlichen WLAN; dann könnte er Eudora einen gefälschten Mailserver vorspielen und Kennwort und Post mitlesen.

**Was behoben ist (ab dem Release 7.2.1).** Die vier Wurzeln sind aus der mitgelieferten Liste entfernt: [`Releases/1.0/rootcerts.p7b`](Releases/1.0/rootcerts.p7b) enthält jetzt 117 statt 121 Zertifikate, erzeugt von [`rootcerts-erzeugen.ps1`](Releases/1.0/rootcerts-erzeugen.ps1) mit einer Ausschlussliste; der Paketbau legt diese Datei in jedes Paket. GMX und freenet (IMAP, POP3, SMTP) sind gegen die neue Liste mit OpenSSL gemessen und werden angenommen — ihre Zertifikate stammen von der Telekom (T-TeleSec). Mit Eudora selbst hat Gregor es am Testpaket 7.2.0.123 gemessen: Abruf ohne Zertifikatsfehler. Dass Eudora eine eMudhra-Kette ablehnt, bleibt eine Rechnung. Ein Regressionstest wird rot, sobald eine eMudhra-Wurzel zurückkommt ([E-148](Intern/BEFUNDE.md#e-148)).

**Mit einem älteren Paket:** Eudora beenden, die vorhandene `rootcerts.p7b` im Programmverzeichnis in `rootcerts.p7b.alt` umbenennen und die neue Datei aus `Releases/1.0/` hineinlegen — oder Eudora bis dahin nur im eigenen Netz benutzen. Nach dem Austausch einmal Mail abrufen. Meldet Eudora einen Zertifikatsfehler, die neue Datei löschen und `rootcerts.p7b.alt` zurückbenennen; dann sind allerdings auch die vier eMudhra-Wurzeln wieder da.

**Auch im Mailverzeichnis nachsehen.** Wer selbst einmal eine `rootcerts.p7b` ins Mailverzeichnis kopiert hat, behält **diese** Liste, auch mit dem neuen Paket: dort löschen oder durch die neue Datei ersetzen (gefunden von [PRÜFER-51](Befunde/PRUEFER-51.md#pruefer-51), K6).

**Welche Liste gilt, steht im Protokoll** — sofern `LogLevel` in der Gruppe `[Debug]` der `Eudora.ini` den Schalter 32768 enthält (das Paket setzt `LogLevel=58527`, eine eigene `Eudora.ini` oft nicht; siehe [Doku/ANWENDER.md](Doku/ANWENDER.md)). Beim ersten verschlüsselten Abruf oder Versand nach dem Start schreibt Eudora eine Zeile wie `rootcerts.p7b geladen aus: C:\…\Mailverzeichnis\rootcerts.p7b (vorhanden)` in die `eudora.log` im Mailverzeichnis. *„FEHLT“* heißt: in keinem der beiden Verzeichnisse liegt eine `rootcerts.p7b`, und Eudora hat keine Liste, gegen die es Serverzertifikate prüfen kann.

---

## Eigene Änderungen prüfen (Prüfstand)

Wer Eudora in einem Klon oder Fork ändert, prüft mit dem Prüfstand, ob dabei etwas kaputtgegangen ist, was vorher ging. Er startet Eudora rund sechzig Mal mit vorbereiteten Testmails und eigenen Prüfservern auf dem eigenen Rechner (nichts geht ins Internet) und prüft gut hundert Fälle.

1. Eudora bauen: `powershell -File tools\bauen.ps1` ([Doku/BAUEN.md](Doku/BAUEN.md)).
2. **`Pruefstand starten.cmd`** im Hauptordner doppelklicken, Frage mit `j` beantworten.
3. Warten — gemessen 60 bis 91 Minuten für den vollen Lauf (Stand 06.11.2026) — und den Rechner nicht benutzen; Eudora-Fenster gehen auf und zu. Der Starter nennt vorher die erwartete und am Ende die tatsächliche Dauer.
4. Am Ende: `ERGEBNIS: alle Fälle bestanden` oder die Liste der roten Fälle.

**Nur ausprobieren, ohne Visual Studio:** Git für Windows installieren, Repo klonen, `Pruefstand starten.cmd` doppelklicken, `j` — geprüft wird dann das zuletzt veröffentlichte Release (einmaliger Download, rund 9 MB).

**Voraussetzungen kurz:** eigenes Windows-Konto oder VM · Git für Windows · Visual Studio 2022 nur für eigene Änderungen · freie Ports 11110, 1143, 1144, 1025, 18169 · Klon in einem Ordner ohne Leerzeichen · gut 700 MB plus 1,6 GB · eine bis anderthalb Stunden · Internet beim ersten Lauf.

Voraussetzungen, Schalter, Ergebnis lesen und Fehlerbilder: [**Doku/PRUEFSTAND.md**](Doku/PRUEFSTAND.md). Die Prüfverzeichnisse entstehen unter `C:\Temp\Eudora72-Pruefstand` (anderer Ordner mit `-Wurzel`); der Prüfstand fasst nur Verzeichnisse an, die er selbst angelegt und markiert hat — eigene Eudora-Ordner mit echten Mails bleiben unberührt. Wegen der Registry auf einem Rechner mit echter Eudora-Einrichtung trotzdem besser ein eigenes Windows-Konto oder eine VM nehmen.

---

## Stand

Die Messlatte steht in [ZIEL.md](ZIEL.md): neun Kriterien, an denen sich entscheidet, ob eine Fassung abnahmefähig ist, dazu einzelne Anforderungen `A-n`. **ZIEL.md ist die Quelle** — `tools/doku-pruefen.pl` weist jeden Commit ab, in dem eine andere Datei etwas anderes über ein Kriterium behauptet.

Kurz: Eudora baut aus einem frischen Klon, das Paket startet auf einem Rechner ohne Visual Studio, Mail wird über TLS abgerufen und verschickt, Antworten und Weiterleitungen gehen, das Programm beendet sich sauber, und die offenen Fenster stehen als Registerkarten am unteren Rand. Was ein Anwender heute noch merkt, steht oben unter [Bekannte Fehler](#bekannte-fehler) und in [Doku/ANWENDER.md](Doku/ANWENDER.md#was-es-nicht-kann); die vollständige Liste mit Messung und Fundstelle führt das [CHANGELOG](CHANGELOG.md) unter *Noch offen* und *Erreicht*.

**Die Prüfanleitung zum jeweils aktuellen Paket steht nicht hier**, sondern im CHANGELOG beim Eintrag der Fassung — eine Anleitung in der README veraltet mit dem nächsten Bau, ohne dass es jemand merkt.

## Verwandte Projekte

- [HermesMail](https://sourceforge.net/projects/hermesmail/) — rüstet ein installiertes Eudora 7.1 binär mit neueren TLS-DLLs nach (OpenSSL 1.0.2)
- [Eudora_patches](https://github.com/HansWurst81675/Eudora_patches) — Binärpatches für die Umlautdarstellung

## Lizenz

[**LICENSE**](LICENSE) — der vollständige Text. Kurz:

Der Eudora-Quelltext steht unter der BSD-3-Clause-Lizenz mit Patentausschluss, unter der ihn das Computer History Museum 2018 freigegeben hat (Urheberzeile von 2016, siehe Kopf der Quelldateien). **Alles, was in diesem Projekt neu entstanden ist** — die Ersatzschicht unter `Eudora71/OTShim`, die Werkzeuge unter `tools/` und die Dokumentation — steht unter **derselben** Lizenz. Die Änderungen liegen fast alle innerhalb von Dateien mit diesem Lizenzkopf; eine zweite Lizenz ergäbe eine Grenze, die niemand nachziehen kann.

Benutzen, verändern und weitergeben ist damit erlaubt, auch gewerblich, solange Urhebervermerk und Lizenztext mitgehen. Keine Gewährleistung, keine Patentrechte, und unsere Namen nicht zur Werbung.

**Zwei Einschränkungen**, die [LICENSE](LICENSE) im Einzelnen aufführt: Fremdbestandteile wie OpenSSL, expat und libpng behalten ihre eigenen Lizenzen — und einiges im Baum gehört **weder uns noch dem Computer History Museum**: die Stingray-Header unter `Eudora71/OT501`, `Paige32.dll`, `SMIME.dll` und die Verzeichnisdienst-Bibliotheken von 2003. Daran können wir niemandem Rechte einräumen.
