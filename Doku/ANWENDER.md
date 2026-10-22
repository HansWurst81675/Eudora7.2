# Was Eudora 7.2 kann und was nicht

Zurück zum [Einstieg](../README.md).

## Was es nicht kann

**Hier steht nur, was heute fehlt.** Keine Fassungsgeschichte, keine behobenen
Fehler — die stehen in [CHANGELOG.md](../CHANGELOG.md), und eine Liste, die
beides mischt, liest sich wie eine Liste von Mängeln, die längst keine mehr
sind.

Die **tagesaktuellen Fehler mit Abhilfe** führt die Tabelle *Bekannte Fehler*
in der [README](../README.md#bekannte-fehler). Was hier folgt, sind die
Grenzen, die **bleiben** — und die zwei, drei Mängel, die ein Anwender im
Alltag am ehesten merkt.

* **Kein fertiges Installationsprogramm.** Es gibt ein ZIP, sonst nichts.
* **LDAP, Ph, S/MIME und die Suche über den Verzeichnisdienst fallen aus —
  das eigene Adressbuch nicht.** Diese Teile brauchen
  `MFC71.DLL` und `MSVCP71.dll` von 2003, und Microsoft hat sie nie zur
  Weitergabe freigegeben. Der Start ist davon nicht betroffen (Befund
  [**E-47**](../BEFUNDE.md#e-47)). **Nicht gemeint ist das eigene Adressbuch**
  (*Tools → Address Book*, die Kurznamen-Leiste): es ist in `Eudora.exe`
  übersetzt — `nickdoc.cpp`, `nicktree.cpp`, `nickpage.cpp` und
  `NicknamesWazooWnd.cpp` stehen in `Eudora71/Eudora/Eudora.vcxproj` —,
  braucht kein `MFC71.DLL` und arbeitet; in 1.0.119 und 1.0.120 sind zwei
  Fehler darin behoben und von Gregor bestätigt
  ([E-134](../BEFUNDE.md#e-134), [E-135](../BEFUNDE.md#e-135)). `EudoraBk.dll`
  klingt nach Adressbuch, ist aber der Protokollanbieter *„EudoraBk
  Protocol"* des Verzeichnisdienstes
  (`DirectoryServices/DirectoryServicesUI/inc/RegisterComponentImpl.h:67`).
* **IMAP-Postfachnamen mit Umlauten stehen roh da** ([**E-77**](../BEFUNDE.md#e-77), offen):
  `Entw&APw-rfe` statt *Entwürfe*. IMAP selbst läuft — von Gregor am
  10.09.2026 bestätigt: *„imap: funktioniert"*, `imap.gmx.net:993`.
* **Im Dialog *Speichern unter* fehlen zwei Optionen** ([**E-98**](../BEFUNDE.md#e-98), offen):
  *Kopfzeilen einschließen* und *Absätze raten* sind nicht wählbar. Windows 10
  öffnet den modernen Dateidialog, und der zeigt Eudoras Dialogvorlage von 1996
  nicht mehr an. Es gilt, was zuletzt in der `Eudora.ini` stand. Das ist **kein
  Rückschritt durch die Behebung von [E-97](../BEFUNDE.md#e-97)** — die Kästchen fehlen seit der
  Portierung, es kam nur niemand so weit, weil das Programm vorher abbrach.
* **Versteckter Vorschautext wird mitgelesen** ([**E-105**](../BEFUNDE.md#e-105), im Download `v1.0.87` offen; Behebung in 7.2.0.88 eingebaut, ausgeliefert mit `v1.0.101`, von Gregor noch nicht bestätigt): In manchen
  Werbemails steht über dem Inhalt eine lange Reihe `? ? ? ?`. Absender
  füllen damit die Vorschauzeile und verbergen sie per CSS `display:none` —
  Eudoras HTML-Anzeige (Paige) kennt keine CSS-Eigenschaften und zeigt den
  Bereich deshalb an. Nur Darstellung, kein Datenverlust. Aus demselben Grund
  stehen in manchen Newslettern Bilder doppelt da (Desktop- und
  Handyfassung, eine davon per `display:none` verborgen; zweiter Fall,
  von Gregor am 13.10.2026 an 1.0.86 gemeldet).
* **Bilder, die als `data:`-Adresse im HTML stecken, erscheinen beim Antworten
  und Weiterleiten als grauer Kasten** ([**E-119**](../BEFUNDE.md#e-119), offen, am Protokoll belegt):
  der Lader sucht eine Datei, das Bild steht aber base64-kodiert in der
  Adresse selbst.
* **Anhänge werden unter abgeschnittenem Namen gespeichert, die Endung fehlt**
  ([**AN-1**](../BEFUNDE.md#an-1)): aus `Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf`
  wird `Angebot Nr 4711 fuer die Stadtwerke`. **Es liegt nicht an der Länge** —
  ein Name mit 76 Zeichen kommt vollständig an, solange er in *einer* Zeile
  steht. Elf getrennte Ursachen (B5.1 bis B5.11), alle aus Eudora 7.1: eine
  Faltung beendete die Zeichenkette in Anführungszeichen, die Marke des
  Zerlegers war 256 Byte groß, zwei Puffer liefen über, `filename=""` wurde zum
  Wert `=`, **RFC 2231** — die Form, in der lange Namen heute übertragen
  werden — kannte der Baum gar nicht (dann nahm Eudora ersatzweise den
  **Betreff**, 31 Zeichen ohne Endung), lange Namen wurden von hinten gekappt,
  und die Zuordnung MIME-Typ → Endung scheiterte an einem einzigen
  Registry-Eintrag ganz. **Behoben bis auf einen Teil:** über POP am laufenden
  Programm gemessen, alle sechs Prüffälle heil seit 7.2.0.81 (auch an 7.2.0.82
  und 7.2.0.83, Testsuite 185/185); über IMAP von Gregor mit Paket 1.0.83 an
  seinem Postfach getestet und bestätigt. **Offen bleibt [B5.7](../AUFGABEN.md#b5.7):** über IMAP
  wird keine Endung aus dem MIME-Typ nachgetragen, wenn der Name keine hat.
  Durchlauf in [AUFGABEN.md](../AUFGABEN.md), **B5**.
* **Eine gespeicherte HTML-Nachricht zeigt in anderen Programmen falsche
  Umlaute** ([**E-101**](../BEFUNDE.md#e-101), **wieder offen** seit 13.10.2026, an 1.0.84 gemeldet):
  die Datei aus *File → Save As* sagt im `<meta>` UTF-8, enthält aber
  Windows-1252. Jedes Programm, das sie als HTML liest, folgt dem `<meta>` und
  zeigt statt der Umlaute Ersatzzeichen.
* **Ein gelöstes angedocktes Fenster hinterlässt eine leere Fläche**
  ([**E-114**](../BEFUNDE.md#e-114), offen, an 1.0.84 gemeldet): wird etwa das Filterfenster
  angedockt und wieder gelöst, bleibt an seiner alten Stelle ein weißer
  Bereich stehen.
* **Ctrl+F (*Find Messages*) meldet „Encountered an improper argument"**
  ([**E-115**](../BEFUNDE.md#e-115), an 1.0.84 gemeldet), und im Reiter *Mailboxes* ist kein
  Postfach angehakt — wenn ein IMAP-Postfach aktiv ist. **Behoben in 7.2.0.86,
  veröffentlicht mit `v1.0.87`, von Gregor am 13.10.2026 an 1.0.86 bestätigt**
  (vorläufig: der Fehler trat vorher nur sporadisch auf). In `v1.0.84` und
  älter noch enthalten; kein Datenverlust.
* **Nur 32 Bit.** Eine 64-Bit-Fassung ist nicht in Arbeit.

Die vollständige Liste der offenen Punkte steht in [CHANGELOG.md](../CHANGELOG.md)
unter *Noch offen*.


## Für Anwender

### Herunterladen und starten

1. [Neuestes Release](https://github.com/HansWurst81675/Eudora7.2/releases/latest)
   herunterladen, ZIP auspacken — an eine Stelle, an der man schreiben darf,
   also **nicht** nach `C:\Program Files`.
2. **`Eudora starten.cmd`** doppelklicken. Beim ersten Start fragt Eudora nach
   den Zugangsdaten des Mailkontos.
3. Die Titelzeile nennt die Fassung, zum Beispiel
   `Eudora 7.2.0.72 / Paket 1.0.72` — diese Angabe gehört in jeden
   Fehlerbericht.

Das Postfach liegt im Unterverzeichnis `Mailverzeichnis` **neben** dem
Programm. Wer eine neue Fassung auspackt, kopiert dieses Verzeichnis herüber
und behält damit Mails, Konten und Filter.

> **Prüfsummen** zu jedem Paket stehen in
> [Releases/PAKETE.md](../Releases/PAKETE.md), zusammen mit dem Commit, aus dem
> es gebaut wurde.

### Post automatisch einsortieren

Wie ein Filter entsteht, wann er läuft, was seine fünf Aktionen tun, wo die
Regeln gespeichert werden und was es mit der Junk-Punktzahl auf sich hat:
[FILTER.md](../FILTER.md). Dort steht auch, warum diese Punktzahl hier bei
jeder eingehenden Nachricht **0** bleibt.

### Was nicht in der Oberfläche steht

Schalter ohne Menüpunkt, die Regeln für die `Eudora.ini` und das
Verhalten, das sich nicht von selbst meldet — gesammelt und belegt in
[EINSTELLUNGEN.md](../EINSTELLUNGEN.md). Dort steht auch, was beim Umstieg
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
[FILTER.md](../FILTER.md), Abschnitt *Was überrascht*.

### Windows Defender meldet Eudora als Trojaner

**Was man sieht.** Das Eudora-Fenster ist plötzlich weg – ohne Fehlermeldung,
ohne Absturzdialog, und im Mailverzeichnis liegt **keine** `Exception.log`.
Das sieht aus wie ein Absturz, ist aber keiner: **Microsoft Defender hat
Eudora beendet.** In *Windows-Sicherheit → Viren- & Bedrohungsschutz →
Schutzverlauf* steht dann eine Meldung wie **`Trojan:Win32/Bearfoos.A!ml`**
mit `Eudora.exe` als betroffenem Element. Danach lässt sich die Datei nicht
mehr starten oder kopieren.

**Was das ist.** Das Kürzel `!ml` heißt: die Einstufung stammt aus Defenders
**maschinellem Lernverfahren**, nicht aus der Signatur einer bekannten
Schadsoftware. Defender schickt eine unbekannte, **unsignierte** Programmdatei
an die Microsoft-Cloud, bewertet sie dort und verteilt bei einem negativen
Urteil eine Signatur für genau diese Datei. Jede Fassung dieses Projekts ist
eine neue, unsignierte Datei – das Urteil kann bei jeder Fassung neu fallen.
Am 16.10.2026 traf es das Testpaket 1.0.98 ([E-124](../BEFUNDE.md#e-124)); das
veröffentlichte `v1.0.87` und die Pakete 1.0.96 und 1.0.97 waren sauber,
1.0.99 (derselbe Quelltext wie 1.0.98, neu gebaut) ebenfalls. Wir halten
das für einen **Fehlalarm**: die Datei ist aus dem Quelltext in diesem Repo
gebaut, und der Unterschied zur sauberen Vorfassung sind rund 60 Zeilen im
Aufgabenverwalter ohne jeden neuen Systemaufruf.

**Was Sie tun können.**

1. **Prüfen, ob es Defender war:** im Schutzverlauf nachsehen, oder in einer
   PowerShell `Get-MpThreatDetection` – dort steht die Uhrzeit und der Pfad
   der `Eudora.exe`.
2. **Ihre Post ist nicht betroffen.** Defender beendet nur das Programm; das
   Mailverzeichnis bleibt, wie es war. Was Eudora vor dem Beenden schon
   geschrieben hatte, ist da.
3. **Eine andere Fassung nehmen** – die nächste Fassung ist eine neue Datei
   und wird neu bewertet –, **oder** die Datei im Schutzverlauf selbst
   **zulassen**, wenn Sie der Herkunft vertrauen. Das ist Ihre Entscheidung;
   wir empfehlen nicht, Defender abzuschalten.
4. **Den Fehlalarm melden:** <https://www.microsoft.com/wdsi/filesubmission>,
   Kategorie *Incorrectly detected as malware*. Microsoft nimmt solche
   Signaturen meist binnen weniger Tage zurück.

**Was wir dagegen tun.** `tools/paket-pruefen.ps1` lässt seit 7.2.0.99
Defender über jede EXE und DLL eines Pakets laufen und weist bei einem Fund
ab; kein Paket geht mehr hinaus, das Defender **in diesem Moment** schon
beanstandet. Ganz ausschließen lässt es sich nicht, weil die Cloud mitunter
erst nach dem ersten Start urteilt. Dauerhaft hilft nur eine Code-Signatur
mit einem Zertifikat – die gibt es für dieses Projekt bisher nicht.

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
   [Befunde/SPUR.md](../Befunde/SPUR.md).

Bevor Sie schreiben: die bekannten offenen Punkte stehen in
[CHANGELOG.md](../CHANGELOG.md) unter *Noch offen*.

## Einstellungen, die es nur hier gibt

Diese Portierung weicht an einigen Stellen **bewusst** vom Original ab — und
jede Abweichung lässt sich zurückdrehen.

**Die vollständige Liste steht in [EINSTELLUNGEN.md](../EINSTELLUNGEN.md)**, mit
Schlüssel, Abschnitt, Vorgabe hier, Vorgabe im Original und Fundstelle im
Quelltext. Dort und nur dort — bis zum 14.09.2026 standen dieselben Schlüssel
in **zwei** Tabellen, hier und dort, und zwölf davon in beiden. Zwei Listen
mit denselben Werten laufen zwangsläufig auseinander; Gregor hat es bemerkt
und entschieden: *„nur in einstellungen, nicht in readme"*.

Was ein Anwender beim **ersten Start** wissen muss, steht weiter unten unter
*Ein Mailverzeichnis übernehmen* und *Mehr ins Protokoll schreiben lassen*.

## Wie Eudora gestartet werden kann — und warum das zählt

**Es gibt mehr Wege als den Doppelklick auf `Eudora.exe`.** Jedes Mal muss
Eudora sein Mailverzeichnis finden, und jedes Mal kann es dabei über die
Registry im Verzeichnis einer **fremden** Installation landen
([E-132](../BEFUNDE.md#e-132)).

| Weg | was dabei passiert |
|---|---|
| **`Eudora starten.cmd`** doppelklicken | der vorgesehene Weg: das Mailverzeichnis wird als Argument übergeben, Eudora muss nicht suchen |
| Doppelklick auf **`Eudora.exe`** | Eudora sucht sich das Mailverzeichnis selbst |
| Klick auf einen **`mailto:`-Link** | Windows startet Eudora und übergibt die Adresse |
| Doppelklick auf eine **Postfachdatei** (`.mbx`) | Eudora startet und soll das Postfach öffnen |
| Doppelklick auf **Briefpapier** (`.sta`) | Eudora startet und legt eine Nachricht damit an |
| Eine Datei **auf Eudora ziehen** | Eudora startet und hängt sie an |

**Nur der erste Weg kommt ohne Suche aus.** Bei allen anderen greift seit
7.2.0.114 eine Rückfrage, bevor ein fremdes Verzeichnis übernommen wird —
**seit 7.2.0.116 auf allen Wegen.** Bis 7.2.0.115 kam sie nur beim Doppelklick
auf `Eudora.exe`; auf den vier anderen war das Programmverzeichnis intern noch
nicht gesetzt, und die Prüfung stieg wortlos mit *nicht fremd* aus. Im
Protokoll stand dann

```
E-132 Startverzeichnis: … eigenes="" fremd=0
```

— eine Zeile, die wie eine Entwarnung aussieht und keine war. Gefunden hat das
der Agent PRÜFER beim Nachrechnen, nicht ein Testlauf: über einen
`mailto:`-Link muss man erst einmal kommen.

**Wenn gefragt wird, ist die Vorgabe *Nein*** — ein eigenes Verzeichnis neben
dem Programm. Wer die Meldung wegdrückt, beschädigt nichts. Die Antwort wird
gemerkt (in der `DEudora.ini` neben der EXE); wie man sie wieder loswird,
steht im Dialog.

## Was in einen Fehlerbericht gehört — *Help → About Eudora*

**Seit 7.2.0.114 nennt der Über-Dialog alle Pfade, nach denen bei einem Fehler
als erstes gefragt wird**, und ein Knopf legt sie auf die Zwischenablage.

*Help → About Eudora* → **Copy info** → in das Ticket oder Issue einfügen.
Herauskommt ein Block wie dieser:

```
Version 7.2.0.114R - Paid Mode
Not Registered in This Mode
Data: C:\Users\Name\Eudora72-1.0.114-release\Mailverzeichnis
Application: C:\Users\Name\Eudora72-1.0.114-release
INI: C:\Users\Name\Eudora72-1.0.114-release\Mailverzeichnis\Eudora.ini
Default INI: C:\Users\Name\Eudora72-1.0.114-release\DEudora.ini
Log: C:\Users\Name\Eudora72-1.0.114-release\Mailverzeichnis\eudora.log  (LogLevel=25759, keine E-nn-Marken)
Mail folder from: command line
```

| Zeile | warum sie gebraucht wird |
|---|---|
| **Version** | ohne sie ist kein Urteil zuzuordnen — *„behoben"* stand hier schon einen Tag lang da, während das ausgelieferte Paket den Fehler noch hatte |
| **Data** | das Mailverzeichnis: dort liegen Postfächer, Anhänge und das Protokoll |
| **Application** | das Programmverzeichnis — bei uns **nicht** dasselbe wie *Data* |
| **INI** | **welche** `Eudora.ini` wirklich gelesen wird. In unseren Paketen liegt sie in `Mailverzeichnis\`, nicht neben der EXE. Genau diese Abweichung öffnet den Weg von [E-132](../BEFUNDE.md#e-132) |
| **Default INI** | die `DEudora.ini`. Dort stehen `DataFolder` und `UseAppData` — die Stufen 3 und 4 der Verzeichnissuche |
| **Log** | wohin das Protokoll geschrieben wird **und ob es überhaupt etwas enthält**. Steht dort *„keine E-nn-Marken"*, fehlt `DEBUG_MASK_MISC` (32768) im `LogLevel`, und keine einzige Spurmarke wird geschrieben — siehe den nächsten Abschnitt |
| **Mail folder from** | **woher** Eudora das Mailverzeichnis hat: Befehlszeile, Umgebungsvariable, `DEudora.ini`, Registry oder Application Data. Diese eine Zeile hat am 20.10.2026 Stunden gekostet, weil sie fehlte ([E-132](../BEFUNDE.md#e-132)) |

**Die Angaben werden aus dem Dialog genommen, nicht aus dem Programminneren.**
Der kopierte Block kann also nichts behaupten, was auf dem Bildschirm nicht
genauso dasteht.

**Eine Warnung zum Mitschicken:** die Pfade enthalten deinen
Windows-Benutzernamen. Wer das nicht veröffentlichen will, ersetzt ihn vor dem
Einfügen — die Angaben bleiben auch dann brauchbar.

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
> zuweist — siehe [EINSTELLUNGEN.md](../EINSTELLUNGEN.md), Regel 1.1. Der
> Abschnitt *Wo ein Schlüssel stehen muss*, auf den hier bis zum 21.10.2026
> verwiesen wurde, steht seit dem 14.09.2026 nicht mehr in dieser Datei.
> Bis zum 11.09.2026 stand hier
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
| 65536 | **Anhangnamen** (Zeilen `ANHANG`, Befund [AN-1](../BEFUNDE.md#an-1)) | **aus** |

Belegt in `Eudora71/QCUtils/public/inc/debug.h:14-44`; gelesen wird der
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

