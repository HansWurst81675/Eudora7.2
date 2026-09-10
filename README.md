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
* **Kein IMAP getestet.** Der Code ist da, geprüft ist nur POP3.
* **Nur 32 Bit.** Eine 64-Bit-Fassung ist nicht in Arbeit.

Die vollständige Liste der offenen Punkte steht in [CHANGELOG.md](CHANGELOG.md)
unter *Noch offen*.

## Für Anwender

### Herunterladen und starten

1. [Neuestes Release](https://github.com/HansWurst81675/Eudora7.2/releases/latest)
   herunterladen, ZIP auspacken — an eine Stelle, an der man schreiben darf,
   also **nicht** nach `C:\Program Files`.
2. **`Eudora starten.cmd`** doppelklicken. Beim ersten Start fragt Eudora nach
   den Zugangsdaten des Mailkontos.
3. Die Titelzeile nennt die Fassung, zum Beispiel
   `Eudora 7.2.0.29 / Paket 1.0.29` — diese Angabe gehört in jeden
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

Diese Portierung weicht an einigen Stellen **bewusst** vom Original ab. Jede
Abweichung steht hier mit ihrem Schlüssel, ihrer Vorgabe und dem Grund — und
jede lässt sich zurückdrehen.

Die Schlüssel stehen im Abschnitt `[Settings]` der **`Eudora.ini`** im
Mailverzeichnis. Die Spalte *Original* nennt den eingebauten Wert von
Eudora 7.1 (nachgesehen in `EudoraRes.rc`).

Hier stehen nur die **Abweichungen**. Die vollständige Liste aller Filter-
und Junk-Schlüssel mit ihren eingebauten Vorgaben und Fundstellen steht in
[FILTER.md](FILTER.md).

| Schlüssel | hier | Original | was er tut |
|---|---|---|---|
| `FilterMayDeleteFromServer` | **0** | *gibt es nicht* | Erlaubt einer **Filteraktion**, Post auf dem Server zu löschen. Bei 0 wird der Versuch abgelehnt und protokolliert (`E-73 … VERWEIGERT`) |
| `DeleteFetchedJunk` | **0** | **1** | Löscht als **Junk eingestufte** Post auf dem Server. Steht in `tools/DEudora.ini` und gilt damit für **neu angelegte** Konten |
| `LeaveMailOnServer` | **1** | **0** | Lässt abgeholte Post auf dem Server liegen. Ebenfalls Vorgabe für neue Konten (Anforderung **A-1**) |
| `SSLSendUse`, `SSLReceiveUse` | **2** | 0 | TLS für Senden und Abrufen verlangen, alternativer Port (465 / 995) — sonst kommt Eudora an keinen heutigen Mailserver heran |
| `CtrlJMapping` | **2**, wenn beim ersten Start keine Filter da sind | **1** in derselben Lage | Welcher Befehl auf **Strg+J** liegt: `1` = *Junk*, `2` = *Filter Messages*. Eingebaut steht `0` — „noch nicht entschieden"; den echten Wert setzt Eudora beim ersten Start selbst |

### Warum die drei Löschsperren

Eudora kennt **drei** Wege, Post auf dem Server zu löschen, und sie sind
voneinander unabhängig:

1. **Kein `Leave mail on server`** — POP3 löscht nach dem Abholen. Eingebaute
   Vorgabe: löschen.
2. **`Delete fetched junk`** — was als Junk gilt, wird zusätzlich vom Server
   geworfen. Eingebaute Vorgabe: **an**.
3. **Die Filteraktion „Server Options"** mit *Delete* — sticht im Original
   sogar `Leave mail on server`.

Am 10.09.2026 hat Weg 3 ein ganzes Postfach geleert, ohne dass die Aktion je
eingestellt worden war: sie war durch einen Fehler in das Filterobjekt
geraten (**E-72**, **E-73**). Weg 2 ist hier abgeschaltet, weil die
Junk-Bewertung auf Zusatzmodule angewiesen ist, die in dieser Portierung gar
nicht laden können (**E-47**) — eine Einstufung, der man nicht trauen kann,
darf keine Post löschen.

> **Wer eine dieser Sperren löst, sollte wissen warum.** Die Wege 1 und 2
> löschen **ohne Rückfrage**, und was auf dem Server gelöscht ist, ist weg.

Was die Junk-Punktzahl bedeutet, woher sie kommt und warum sie hier bei
jeder eingehenden Nachricht 0 bleibt, steht in [FILTER.md](FILTER.md).

### Warum Strg+J hier filtert

Vor der Junk-Funktion war **Strg+J** in Eudora *Filter Messages*. Seit
Eudora 6 möchte das Programm die Taste für *Junk* haben und fragt vorher —
der Dialog dafür steht bis heute in den Ressourcen (`IDD_CTRL_J_FOR_JUNK`):

> *The Ctrl-J key combination is currently associated with the „Filter
> Messages" menu item. Would you like to switch it to be associated with the
> „Junk" menu item?*

**Gefragt wird aber nur, wenn beim ersten Start schon manuelle Filter da
sind.** Andernfalls legt `CMainFrame::InitJunkMenus` (`mainfrm.cpp`) die
Taste **stillschweigend** auf *Junk* und schreibt `CtrlJMapping=1` fest. Der
Zweig läuft nur ein einziges Mal — später angelegte Filter ändern nichts
mehr daran.

Wer mit einem **leeren Mailverzeichnis** anfängt und die Filter danach
anlegt, landet also dauerhaft auf *Junk*, ohne es je gelesen zu haben. Genau
das ist am 10.09.2026 passiert: neun Nachrichten wanderten in den
Junk-Ordner, während der Fortschrittsbalken „Messages left to filter" zeigte
(**E-75**). Hier bleibt Strg+J deshalb auf *Filter Messages*.

**In einem bestehenden Mailverzeichnis wirkt das nicht** — dort steht der
Wert schon in der `Eudora.ini` und wird nicht mehr überschrieben. Bei
geschlossenem Eudora von Hand ändern:

```ini
[Settings]
CtrlJMapping=2
```

Umgekehrt geht es genauso: Wer *Junk* auf Strg+J will, stellt es in den
Einstellungen um oder trägt `1` ein. *Filter Messages* liegt dann auf
Strg+Umschalt+L. Welche Belegung gilt, steht im Menü — unter *Special* neben
*Filter Messages* und unter *Message* neben *Junk*.

### Drei Befehle, eine Fortschrittsanzeige

Im Original melden *Filter Messages*, *Junk / Not Junk* und *Recheck Junk*
alle dieselbe Zeile `Messages left to filter`. Ein Junk-Lauf sieht damit aus
wie ein Filterlauf, obwohl kein einziger Filter befragt wird. Hier sagen die
beiden Junk-Befehle `Messages left to mark` beziehungsweise `Messages left
to scan for junk`.

### Vorgaben für neu angelegte Konten

`DEudora.ini` **neben der `Eudora.exe`** liefert die Vorgaben für Konten, die
neu entstehen — gelesen in `GetDefaultIniSetting` (`rs.cpp:357-385`), noch vor
den eingebauten Werten. Sie ändert **kein bestehendes Konto**; dort gilt, was
in der `Eudora.ini` des Mailverzeichnisses steht.

Dieselbe Datei trägt die 124 Dateizuordnungen von QUALCOMM im Abschnitt
`[Mappings]`. Wer sie ersetzt, verliert sie — deshalb liegt im Paket die
Originaldatei mit unseren Zeilen **ergänzt**, nicht eine eigene.

## Mehr ins Protokoll schreiben lassen

Eudora führt ein Protokoll in `eudora.log` im Mailverzeichnis. **Wie viel
darin landet, steuert ein einziger Schlüssel** — ohne Neubau, ohne
Codeänderung:

```ini
[Settings]
LogLevel=25759
```

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
[Settings]
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
| **Quellstand**, z. B. `7.2.0.43` | `Eudora71/Version.h` | die Produktversion, die ein Bau in die `Eudora.exe` schreibt. Sie steht in der Dateiinfo und in der Titelzeile |
| **Paketnummer**, z. B. `1.0.43` | die Datei `VERSION` | benennt das ausgelieferte ZIP |

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

> **Offen und sicherheitsrelevant: die Hostnamenprüfung greift nicht.** Gemessen:
> ein Zertifikat mit falschem `CN` wird mit `SSLSUCCEEDED` und `ErrorCode 0`
> angenommen. Ein Hinweistext wird angehängt, bleibt aber ohne Wirkung.
> Altbestand von QUALCOMM, Einzelheiten in [PORTIERUNG.md](PORTIERUNG.md). Der
> vorbereitete Patch ist **zurückgestellt** und wird nicht ohne Gregors Wort
> angewendet (`tools/patches/zertifikatspruefung-verschaerfen.patch`).

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
