# Eudora 7.2

<!-- pruefstand: eceeecf -->
<!-- Die Marke oben nennt den Commit, gegen den diese Datei zuletzt abgeglichen
     wurde. Wer die Datei nachzieht, zieht die Marke mit.
     Gelesen von tools/pruefstand-melden.pl (Befund NP3-7). -->

Portierung des Eudora-7.1-Quellcodes auf Visual Studio 2022 — mit dem Ziel, den
Mailclient wieder selbst bauen und weiterentwickeln zu können.

Grundlage ist die Quelltextfreigabe des [Computer History Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/)
(2018, mit Genehmigung von Qualcomm).

> **Diese Datei sagt, was jetzt gilt.** Stand **09.09.2026**.
>
> **Zwei Nummern, die nichts miteinander zu tun haben.** Der **Quellstand** ist
> **7.2.0.29** — das steht in `Eudora71/Version.h` (`EUDORA_BUILD_VERSION`) und
> ist die Produktversion, die ein Bau aus diesem Klon in die `Eudora.exe`
> schreibt. Die **Paketnummer** steht in der Datei `VERSION` und lautet
> **1.0.29**; sie benennt das ZIP. `cat VERSION` liefert also **nicht** die
> Quellversion, sondern die Paketnummer — beide liest `tools/ausliefern.pl`
> getrennt ein.
>
> **Beide zeigen auf dasselbe:** `Releases/Eudora72-1.0.29-release.zip`. Die
> Bau-Kennung im Fenstertitel nennt beide Nummern plus den Commit, ein
> Bildschirmfoto ist damit eindeutig zuzuordnen. Welches ZIP zu welcher Marke
> und welchem Commit gehört, steht vollständig in
> [Releases/PAKETE.md](Releases/PAKETE.md).
>
> Wer wann was gemessen hat, steht in [BEFUNDE.md](BEFUNDE.md) und im
> git-Verlauf — hier nicht.

## Stand

**Neun Kriterien: sieben sind belegt (0, 1, 3, 5, 6, 7, 8), zwei sind fast
erfüllt (2, 4).** Die Tabelle dazu steht in [ZIEL.md](ZIEL.md) und ist die
Quelle. Eudora baut aus einem frischen Klon, das Paket startet auf einem
Rechner ohne Visual Studio, die Darstellung stimmt weitgehend, Mail wird über
TLS abgerufen, eine neue Mail lässt sich **schreiben, abschicken und
weiterleiten**, Eudora **beendet sich sauber** über *File → Exit*, **Alt-F4**
und das **Kreuz**, und die offenen Fenster stehen als **Registerkarten am
unteren Rand** — ein Klick holt das Fenster nach vorn. Gregors Bestätigungen
dazu: *„mail können jetzt abgeschickt werden."*, *„schließen klappt jetzt."*
und, am 09.09.2026, das Urteil zu den Registerkarten.

Dazu sind **drei** Anforderungen aus [ZIEL.md](ZIEL.md) umgesetzt und von
Gregor bestätigt: **A-1** (die Vorgaben *Leave mail on server* und *Secure
Sockets* greifen bei einem **neu angelegten** Konto), **A-2** (*Task Status*
und *Task Errors* liegen **waagrecht am unteren Fensterrand** statt senkrecht
links — *„jetzt ist sie unten, ja"*) und **A-3** (die offenen Fenster als
Registerkarten direkt auswählbar — damit ist Kriterium 8 geschlossen). Eine
vierte, **A-4** (den linken Bereich breiter ziehen), ist **gebaut und noch
nicht bestätigt**; bestätigt ist von ihr nur der Gegenfall, die Höhe:
*„verschieben rauf / runter — bug gefixt, die anzeige ist korrekt."*

**Fertig ist es nicht.** Was ein Anwender jetzt noch merkt: nach einem Neustart
stehen die Fenster **nicht im Vollbild**, obwohl sie beim Beenden so waren
(Nebenbefund **ohne Kennung**); beim Öffnen der Kurznamen-Leiste kommt ein
Fehlerdialog des Verzeichnisdienstes (**E-47**) — dort fehlen `MFC71.DLL` und
`MSVCP71.dll`, die Microsoft nie als Redistributable herausgegeben hat; und
manche Nachrichten bringen beim **Anzeigen** die Meldung „Encountered an
improper argument". Das Letzte ist der einzige Grund, warum Kriterium 2 und
Kriterium 4 nicht *erfüllt* heißen — und es ist **neu zu messen**, seit E-43
die Fehlerklasse dahinter an der Wurzel behoben hat.

**In 7.2.0.24 behoben und von Gregor am 08.09.2026 bestätigt** (*„persona
läßt sich löschen. keine messagebox“*)**:** **E-43** — und mit
ihm **E-37** (ein gelöschtes Konto blieb in der Liste stehen) und **E-38** (die
Eigenschaften wirkten leer, weil sie zu einem Geistereintrag gehörten). Alle
drei hingen an **einer** Ursache: `SECControlBar` war zweimal definiert, und
dadurch lasen zwei Übersetzungseinheiten dasselbe Feld acht Byte auseinander.

Was offen ist, steht vollständig in [CHANGELOG.md](CHANGELOG.md); was als
Nächstes zu tun ist, in [AUFGABEN.md](AUFGABEN.md). **Die Prüfanleitung zum
jeweils aktuellen Paket** steht im CHANGELOG beim zugehörigen Eintrag, nicht
hier.

Belegt:

| Was | Beleg |
|---|---|
| **Bau** | ganze Projektmappe aus einem frischen Klon: **18 erfolgreich, 0 Fehler, 1 übersprungen**, 2:37 min. Von Gregor am 06.09.2026 in der IDE nachgemessen. Das eine übersprungene ist `OT501`, siehe unten |
| **Start und Bedienung** | Hauptfenster, Menüs, Werkzeugleiste, Postfachbaum |
| **Mailabruf über TLS** | POP3 auf **Port 995**, *Tools → Last SSL Info*: `Negotiation Status: Succeeded`, **TLSv1.3**, `TLS_AES_256_GCM_SHA384`. Gemessen an 7.2.0.12 am 06.09.2026 gegen `mx.freenet.de`. Die richtige Einstellung dafür ist *Secure Sockets when Receiving* → **„Required, Alternate Port"** |
| **Darstellung** | Bau-Kennung im Titel (E-7), Fortschritt beim Abruf (E-13), Umlaute in HTML-Mail (Z-2b), Leiste am unteren Rand waagrecht (E-44) |
| **Kriterium 7 — sauberes Beenden** | Gregor am 08.09.2026 an Paket 1.0.22: *„schließen klappt jetzt."* Alle drei Wege beenden — *File → Exit*, **Alt-F4** und das **Kreuz**. Behoben durch **E-40**, **E-41**, **E-42**, ergänzt um **E-45** in 7.2.0.23 |
| **Anforderung A-1 — Vorgaben für ein neues Konto** | Gregor am 08.09.2026: *„default werte beim neuen persona konto für ‚leave message on server' greifen."* Die Anforderung selbst steht in [ZIEL.md](ZIEL.md), die Werte in `tools/DEudora.ini`; `tools/doku-pruefen.pl` hält beides gegeneinander |
| **Anforderung A-2 — Aufgabenleiste waagrecht unten** | Gregor am 08.09.2026 an der Prüfinstanz: *„jetzt ist sie unten, ja"*. Gemessen mit `tools/leisten-messen.ps1`: Leiste **320**, Andockseite **unten**, sichtbar, **1712×80** |
| **Kriterium 8 / Anforderung A-3 — offene Fenster als Registerkarten** | Gregor am 09.09.2026 an Paket 1.0.25: der Klick auf eine Karte holt das Fenster nach vorn, die Beschriftungen stimmen mit dem Menü *Window*. Behoben durch **E-48** in 7.2.0.25; die Leiste war nicht abwesend, sondern **abgeschaltet**. `tools/leisten-messen.ps1` kann den Registerkartenstreifen messen und mit `-Abbild` ein Bild davon speichern |
| **E-43 — Persönlichkeit löschen, ohne Meldung** | Gregor am 08.09.2026 an Paket 1.0.24: *„persona läßt sich löschen. keine messagebox"*. **Mit ihm fielen E-37 und E-38 weg** — alle drei hatten eine Ursache, `SECControlBar` war zweimal definiert. Gemessen: `[ToolBar…]`-Abschnitte in der `Eudora.ini` **13 statt 0**. Schranke: `tools/pruefe-waechter.pl` |
| **Höhe des unteren Bereichs verschiebbar** | Gregor am 09.09.2026: *„verschieben rauf / runter — bug gefixt, die anzeige ist korrekt."* Das **seitliche** Ziehen (Anforderung **A-4**, Befunde **E-49** und **E-52**) ist gebaut und **noch nicht** beurteilt |
| **Kriterium 0 — Paket laeuft ohne Nachinstallieren** | Gregor hat `Eudora72-1.0.10-release.zip` am 06.09.2026 auf einem Rechner **ohne Visual Studio** ausgepackt und gestartet: *„test bestanden: eudora läuft ohne VS2022 installiert."* Damit ist das letzte offene der ersten vier Kriterien aus [ZIEL.md](ZIEL.md) belegt — keine fehlende DLL, kein `0xc000007b`, nichts nachzuinstallieren. Vorhergesagt hatte es `tools/paket-pruefen.ps1` aus den PE-Importtabellen (13 Module in der Startkette, 251 Importe gegen Windows-eigene Bibliotheken, *„In der Startkette fehlt nichts"*) — die Vorhersage und der Lauf am lebenden Objekt stimmen überein |

### Offen — Stand 09.09.2026

Die vollständige Liste steht in [CHANGELOG.md](CHANGELOG.md) unter *Noch offen*;
hier die Punkte, die ein Anwender merkt. **Nicht mehr dabei sind das Beenden**
(Kriterium 7, seit 1.0.22 erfüllt und bestätigt), **das Löschen eines Kontos**
(E-37/E-38, mit **E-43** in 1.0.24 weggefallen und bestätigt) und **die
Registerkartenleiste** (Kriterium 8, seit 1.0.25 erfüllt und am 09.09.2026
bestätigt).

- **Gebaut, aber von Gregor nicht beurteilt:** **E-49** (den linken Bereich
  breiter ziehen, Anforderung **A-4**), **E-50** (drei Mängel an der
  Registerkartenleiste) und **E-52** (der Trennbalken bleibt greifbar, die
  Karten stehen nicht doppelt). Was daran zu prüfen ist, steht in
  [AUFGABEN.md](AUFGABEN.md) unter *Gebaut, nicht bestätigt* und in
  [ZIEL.md](ZIEL.md) unter A-4. **Solange er nichts gesagt hat, gilt keine
  dieser drei als erledigt.**
- **Nach einem Neustart stehen die Fenster nicht im Vollbild**, obwohl sie beim
  Beenden so waren. Gregor am 09.09.2026 an 1.0.25. **Nebenbefund ohne
  Kennung**, noch nicht angefasst; er gehört zum Fensterzustand über
  `CMainFrame::SaveOpenWindows`, **nicht** zur Registerkartenleiste.
- Meldung **„Encountered an improper argument"** beim **Anzeigen** mancher
  Nachrichten. Eine Quelle war `QCChildToolBar::GetButton` mit Index −1 (E-16,
  behoben), eine zweite hat **E-43** an der Wurzel erledigt: `SECControlBar`
  war zweimal definiert, und zwei Übersetzungseinheiten lasen dasselbe Feld
  acht Byte auseinander. **Seither ist diese Meldung neu zu messen** — gut
  möglich, dass sie mit verschwunden ist. Erst messen, dann suchen.
- **Wird die aktuell benutzte Persönlichkeit gelöscht, kann ihr INI-Abschnitt
  teilweise wiederentstehen** (**E-39**, nicht behoben, nicht am laufenden
  Programm bestätigt). `CPersonality::Remove` (`persona.cpp:565-566`) stellt die
  aktuelle Persönlichkeit nicht um, und `FlushINIFile` schreibt `SavePassword`
  und `SavePasswordText` ausdrücklich in `g_Personalities.GetCurrent()`
  (`rs.cpp:1237-1250`) — der nächste `SetCurrent` legt damit zwei Schlüssel im
  gelöschten Abschnitt wieder an. **Unabhängig von E-43**, das den Zeitpunkt
  nur nach vorn verschiebt.
- **Der Fehlerdialog des Verzeichnisdienstes** (**E-47**): *„Directory Services
  unavailable during this session…"* beim Öffnen der Kurznamen-Leiste.
  `RegisterCOMObjects()` scheitert, weil `DirServ.dll`, `ISock.dll`, `Ph.dll`,
  `Ldap.dll` und `EudoraBk.dll` **`MFC71.DLL` und `MSVCP71.dll`** brauchen — die
  hat Microsoft nie als Redistributable veröffentlicht. Betrifft Adressbuch,
  LDAP, Ph und S/MIME, **nicht** den Start. **Keine Behebung in Sicht.**

> **Warum solche Befunde lange schweigen.** MFC 6 prüfte mit `ASSERT` und
> `VERIFY`; in einem Release-Bau ist `ASSERT` weggelassen und `VERIFY(f)` zu
> `((void)(f))` verkürzt — der Ausdruck wird berechnet, das Ergebnis aber
> **nicht** geprüft. Wo QUALCOMM einen Fehlschlag so „behandelt" hat, passiert
> im ausgelieferten Programm lautlos gar nichts: bei E-37 an vier Stellen, bei
> E-38 an zwei, bei E-33 verwandt — und beim Beenden waren es zwölf Schritte
> (E-42). **Das ist die häufigste Ursachenklasse dieses Projekts.** Wer hier
> weitermacht, sucht auf dem betroffenen Weg zuerst nach `ASSERT(0)` und
> `VERIFY(`. Die Lehre dazu:
> [Arbeitsweise/assert-ist-im-release-nichts.md](Arbeitsweise/assert-ist-im-release-nichts.md).

### Vorgaben für neu angelegte Konten

`tools/DEudora.ini` kommt mit dem Paket und liegt neben `Eudora.exe`. Eudora
liest sie in `GetDefaultIniSetting` (`Eudora71/Eudora/rs.cpp:357-385`) **vor**
den in `EudoraRes.rc` eingebauten Vorgaben. Gesetzt sind vier Werte:

| Schlüssel | Wert | wirkt als |
|---|---|---|
| `SSLSendUse` | `2` | *Secure Sockets when Sending* → **Required, Alternate Port** |
| `SSLReceiveUse` | `2` | dito beim Abruf — die Einstellung, mit der Kriterium 3 belegt ist |
| `CheckMailByDefault` | `1` | *Check Mail* angehakt |
| `LeaveMailOnServer` | `1` | Nachrichten **nicht** vom Server löschen |

Die Datei ist die **Originaldatei von QUALCOMM** mit vier Zusatzzeilen: ihr
Abschnitt `[Mappings]` mit 124 Dateizuordnungen ist unverändert übernommen. Eine
Fassung mit nur `[Settings]` hätte beim Auspacken über eine bestehende
Installation die Zuordnungen gelöscht.

**Sie wirkt nur beim Anlegen** eines Kontos (`CPersParams::GetDefaultParams`,
`PersParams.cpp:195`, gerufen aus `AccountWizard/Src/WizardPropSheet.cpp:137`
und `ModifyAcctSheet.cpp:46`). Ein **vorhandenes** Konto liest seine Werte aus
der `Eudora.ini` des Mailverzeichnisses, und dort über
`CPersonality::GetIniDefaultValue` (`persona.cpp:606-620`) — die kennt die
`DEudora.ini` **nicht**. Vorhandene Konten stellt man von Hand um:
`<Dominant>` im Abschnitt `[Settings]`, jedes weitere in `[Persona-<Name>]`
(`persona.cpp:897-898`, Präfix `:52`).

### Die Wurzel der Abstürze — gefunden

**E-31, gemessen am 06.09.2026:** `pg_time_t` war unter VS2022 **acht** Byte
breit statt vier. Eine Zeile in `Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`:

```c
typedef time_t   pg_time_t;
```

`time_t` war unter VC6/VC7.1 vier Byte breit, unter VS2022 ist es acht.
`Paige32.dll` stammt von 2005 und rechnet mit vier. `pg_time_t` steckt in
`style_info` und fünfmal in `pg_doc_info` — und damit in `pg_globals` und in
`paige_rec`: **jede** Struktur, die Eudora an Paige reichte, war verschoben.
`PgGlobals::InitFonts` schrieb deshalb mit `memcpy(&def_style, &styleInfo, 304)`
bei **jedem Start** zwölf Byte über die Struktur hinaus. Das ist die
Heap-Beschädigung, die im Windows-Ereignisprotokoll (Quelle *Application Error*)
als `0xc0000374 STATUS_HEAP_CORRUPTION` in `ntdll` auftauchte.

Die Messung mit allen Feldversätzen steht in [CHANGELOG.md](CHANGELOG.md) unter
7.2.0.21.

> **Was vorher vermutet wurde, war falsch — und das bleibt hier stehen.** Bis
> zum 06.09.2026 galt die **Doppelfreigabe E-25** in
> `Eudora71/Importers/NSImport/NSImportClass.cpp` (`LocateNetscapePrefsFile`)
> als die Wurzel. 7.2.0.12 stürzte damit weiter ab. Dazu sieben weitere
> Vermutungen, jede gebaut, gestartet und gemessen, jede widerlegt (CHANGELOG,
> 7.2.0.21). **Nicht noch einmal durchprobieren.** Die Härtung aus E-25 ist
> unabhängig davon richtig und bleibt drin.
>
> Was daran richtig war: `afxcoll.inl:213` und „Encountered an improper
> argument" sind **Folge, nicht Ursache**. Eine beschädigte `CPtrArray` trägt
> beschädigte `m_nSize` und `m_pData`, und dann meldet *jeder* Zugriff „Index
> außerhalb" — auch ein korrekt begrenzter.

### Das Absturzprotokoll — und wie man es liest

Eudora schreibt seinen eigenen Absturzbericht, ohne dass man etwas einschalten
muss: **`Mailverzeichnis\Exception.log`** neben der EXE. Gregor hat 7.2.0.12 am
06.09.2026 um 00:32 laufen lassen, und darin steht:

```
Eudora.exe caused an EXCEPTION_ACCESS_VIOLATION in module <UNKNOWN>
at 0023:414E3345
Call stack: 00894B53, 008962D7, 6FB9A3E6 (mfc140.dll), ...
```

**Das Modul heißt `<UNKNOWN>`.** Der Sprung ging auf eine Adresse, die zu
*keinem* geladenen Modul gehört. So etwas passiert, wenn eine Sprungtabelle oder
ein Funktionszeiger überschrieben wurde — das Schadensbild einer beschädigten
Halde. Die Doppelfreigabe E-25 war demnach **nicht die Quelle**; gefunden wurde
sie erst am 06.09.2026 als **E-31** (siehe oben).

#### Warum die Adressen bis 7.2.0.12 nichts hergaben

Die EXE ist 2,8 MB groß; läge sie wie vorgesehen auf `0x00400000`, endete sie
bei `0x006CD000`. Die protokollierte Adresse `0x00894B53` liegt weit dahinter.
Windows lädt sie also **verschoben** (ASLR), und der Bericht schrieb die
tatsächliche Ladeadresse **nicht mit**. Ohne sie ist jede Umrechnung in einen
Funktionsnamen geraten. Ein erster Versuch am 06.09. rechnete gegen
`0x00400000` und lieferte prompt einen Namen aus dem Ressourcenbereich —
sichtbarer Unsinn, und der Beweis, dass die Rechnung nicht stimmte.

#### Beide Hälften sind jetzt da

| Hälfte | Wo | Seit |
|---|---|---|
| **Namen zu Adressen**: `Eudora71/Bin/Release/Eudora.map`, 51.075 Einträge | `Eudora.vcxproj` erzeugt sie bei jedem Bau | 06.09.2026 |
| **Ladeadressen**: eine Modultabelle im Bericht, vor dem Aufrufstapel | `QCExceptionHandler::WriteModuleTable` in [ExceptionHandler.cpp](Eudora71/Eudora/ExceptionHandler.cpp) (E-26) | 06.09.2026 |

Ein Bericht **ab 7.2.0.13** beginnt deshalb so (ausgeliefert erstmals in Paket
1.0.14 — 1.0.13 wurde übersprungen):

```
Loaded modules - subtract the load address from a stack address to get
the offset listed in the .map file of that module:
Load address  Size      Module
00E30000      002CD000  Eudora.exe
6FB00000      ...       mfc140.dll
```

Adresse minus Ladeadresse ergibt den Versatz, den die `.map` kennt. Damit wird
aus jeder Zeile des Aufrufstapels ein Funktionsname — **ohne Debugger und ohne
Visual Studio**, aus einer Textdatei, die ein Anwender einfach mitschicken kann.
Das war Gregors Vorschlag: *„oder du schreibst eine log datei, während eudora
ausgeführt wird, dann steht es darin, was der letzte aufruf war."*

Berichte von **7.2.0.12 und älter** haben die Tabelle nicht und bleiben
unauflösbar. Das ist kein Mangel des Werkzeugs, sondern eine Tatsache über die
alten Dateien — geraten wird nicht.

**Der zweite Weg, falls das nicht reicht:** **Page Heap** macht aus der
Beschädigung einen Zugriffsfehler an der verursachenden Anweisung statt
irgendwo später — als Administrator `gflags /p /enable Eudora.exe /full`,
Debug-Bau starten, Strg-N, dann `tools\stapel-untersuchen.ps1` in einer
**32-Bit**-PowerShell mit der `Eudora.pdb` neben der `Eudora.exe`; danach
`gflags /p /disable Eudora.exe`.

## Bauen

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

Unit- und Komponententests liegen in `Eudora71/Tests` (`RunTests.cmd`) und
`Eudora71/Tests/QCSSL` (`bauen.bat`, `messen.ps1`). Nach Vorgabe zu jedem Commit
laufen lassen.

## Starten

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Ins Mailverzeichnis gehört eine `Eudora.ini`. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`. Welche Dateien
danebenliegen müssen, steht in [STARTUMGEBUNG.md](STARTUMGEBUNG.md).

> **Berichtigung (06.09.2026).** Hier stand bis dahin: *„Das Mailverzeichnis
> muss eine `Eudora.ini` enthalten, sonst bricht Eudora in `eudora.cpp:3542`
> ab."* **Das stimmt nicht.** An `eudora.cpp:3542` steht
> `CEudoraApp::RegisterMailbox`, und einen Abbruch wegen fehlender INI gibt es
> im Code nicht: `GetDirs`/`CheckMailDirectory` (`fileutil.cpp`) prüfen nur, ob
> das **Verzeichnis** existiert und schreibbar ist, und `SetupINIFilename`
> (`rs.cpp`) setzt `INIPath` zusammen, ohne die Datei zu verlangen. Gemeint war
> `VERIFY(GetShortPathName(INIPath, …) > 0)` in
> **`CEudoraApp::RegisterCommandLine`** (`Eudora71/Eudora/eudora.cpp`) — das
> schlägt bei fehlender Datei fehl, aber `VERIFY` wirkt **nur im Debug-Bau**
> und bringt dort einen SUPERASSERT-Dialog, kein Programmende; im Release-Bau
> tut es gar nichts. Ohne INI läuft Eudora also weiter, nur mit den Vorgaben
> für jede Einstellung — was man nicht will, aber etwas anderes ist als ein
> Abbruch. Der einzige Weg im Code, der wirklich vorzeitig endet, betrifft den
> Start **ohne** Argument: dann sucht `StartEudoraWithDefaultLocation` das
> zuletzt benutzte Verzeichnis in Registry und `%APPDATA%`, und erst wenn auch
> das nichts hergibt, verlässt `InitInstance` lautlos das Programm.

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

## TLS

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

## Werkzeuge

| Werkzeug | wozu |
|---|---|
| `tools/bauen.ps1` | baut die Projektmappe und meldet Erfolg erst, wenn Rückgabewert, Fehlerprotokoll, Zeitstempel und Versionsressource zusammenpassen. Prüft nach: alles x86, im Release keine Debug-Laufzeit in der Importtabelle. `-NurPruefen` misst nur |
| `tools/zeilenenden-angleichen.pl` | Arbeitskopie byteidentisch zum Commit machen. Nach jedem Klon einmal. Nennt jede angefasste Datei namentlich, lässt vorgemerkte Dateien in Ruhe; die Gegenrichtung nur mit `--auch-umgekehrt` |
| `tools/aendere-zeile.pl` | eine einzelne Zeile byte-erhaltend ändern |
| `tools/ersetze-bereich.pl` | einen Zeilenbereich byte-erhaltend ersetzen |
| `tools/doku-pruefen.pl` | `pre-commit`-Schranke gegen Widersprüche in der Doku: Kriterienzahl gegen [ZIEL.md](ZIEL.md), doppelt vergebene Befundkennungen, Statuswidersprüche im Verzeichnis von [BEFUNDE.md](BEFUNDE.md), was im CHANGELOG als offen steht aber im Verzeichnis als behoben, Verweise ins Leere, und `Eudora71/Version.h` gegen sich selbst. Weist **nur** ab, wenn der Commit eine `.md`, `VERSION` oder `Version.h` anfasst. Auf Gregors Ansage *„ich traue dir nicht ganz, jemand soll dich immer wieder überprüfen — das bin aber nicht ich!"* |
| `tools/summe-gegentest.sh` | Gegentest zur Summenprüfung in `doku-pruefen.pl`, **6 Fälle in beide Richtungen** in einem eigenen Wegwerf-Repo — je ein richtiger Satz, der still bleiben muss, und ein falscher, der gemeldet werden muss, auch in fetter Schreibweise. **Wer die Kriterienprüfung in `doku-pruefen.pl` anfasst, lässt ihn laufen** |
| `tools/pruefe-bytes.pl` | `pre-commit`-Schranke gegen lautlosen Byteschaden: Zeilenenden, Kodierung, Doppelkodierung |
| `tools/pruefe-bytes-tests.pl` | Testsammlung dazu, **35 Fälle** in eigenen Wegwerf-Repos. **Wer `pruefe-bytes.pl` anfasst, lässt sie laufen** |
| `tools/pruefe-branch.pl` | `pre-commit`-Schranke gegen Commits auf einen toten Zweig: schon in `origin/main`, Gegenstück auf dem Server gelöscht, oder abgelöster HEAD. Läuft als **erster** Schritt im Hook; `--melden` berichtet nur (Befund X-5) |
| `tools/pruefe-branch-tests.pl` | Testsammlung dazu, **15 Fälle**, jeder in zwei Durchläufen. **Wer `pruefe-branch.pl` anfasst, lässt sie laufen** |
| `tools/dateiendungen.pl` | gemeinsame Liste der Dateiarten, die als Text gelten. Wird von der Schranke und von `zeilenenden-angleichen.pl` geladen — zwei getrennte Listen sind schon auseinandergelaufen |
| `tools/hooks-einrichten.sh` | richtet den `pre-commit`-Hook ein. Nach jedem Klon einmal. Schreibt nach `--git-common-dir`, läuft also auch aus einem Arbeitsbaum |
| `tools/stapel-untersuchen.ps1` | kleiner Debugger: fängt die tödliche Ausnahme, läuft die EBP-Kette ab, symbolisiert mit `dbghelp`. **Muss in der 32-Bit-PowerShell laufen**, braucht die `.pdb` neben der `.exe` |
| `tools/absturz-auswerten.pl` | übersetzt die Adressen aus einer `Exception.log` in Funktionsnamen aus `Eudora71/Bin/Release/Eudora.map`. Nimmt die Ladeadresse aus der Modultabelle des Berichts (**ab 7.2.0.13**, ausgeliefert erstmals in Paket 1.0.14) und **rät nicht**, wenn sie fehlt — ein falscher Name ist schlimmer als keiner (Befund E-29). Läuft ohne Visual Studio |
| `tools/absturz-auswerten-tests.pl` | Testsammlung dazu, **15 Fälle** mit künstlicher Karte und künstlichem Bericht. **Wer `absturz-auswerten.pl` anfasst, lässt sie laufen** |
| `tools/suche-zeiger.pl` | sucht Zeiger, die auf `NULL` geprüft und danach außerhalb des geschützten Blocks dereferenziert werden. 18 Treffer, davon neun echte Kandidaten (Liste in `AUFGABEN.md`, D3a). Läuft ohne Visual Studio |
| `tools/releasebuffer-pruefen.pl` | stuft jedes `ReleaseBuffer` im Baum ein: steht vorher ein `GetBuffer` auf **derselben** Variablen? Das ist die Fehlerklasse **R-1**. Rückgabe 1, sobald etwas zu tun ist. Läuft ohne Visual Studio |
| `tools/pruefe-symbole.pl` | prüft die Werkzeugleisten-Ressourcen ohne Übersetzer: jede `TOOLBAR` hat eine gleichnamige `BITMAP`, jede Bilddatei ist da, jeder Knopf hat ein Bild, keine Ladestelle in der Ersatzschicht holt eine Bitmap ohne Farbtabelle noch über `CBitmap::LoadMappedBitmap`, und deren Hintergrund ist wirklich 192,192,192 (Befund E-30). `-v` listet jede Leiste |
| `tools/pruefe-symbole-tests.pl` | Testsammlung dazu, **12 Fälle** auf künstlichen Arbeitsbäumen. **Wer `pruefe-symbole.pl` anfasst, lässt sie laufen** |
| `tools/postfach-zeichen-pruefen.pl` | prüft ein `.mbx` auf unübersetzte UTF-8-Folgen (Befund Z-2b) |
| `tools/kennung-erzeugen.pl` | erzeugt `BuildKennung.h` vor jedem Bau (PreBuildEvent) |
| `tools/laufzeit-holen.ps1` | holt die vier **Debug**-Laufzeiten aus `SysWOW64` und prüft jede auf x86 nach. Für den Release-Bau nicht nötig |
| `tools/paket-bauen.ps1` | stellt ein Auslieferungspaket aus dem Quellbaum zusammen, wahlweise als ZIP. **Veröffentlicht nichts** — ob ausgeliefert wird, entscheidet ein Mensch |
| `tools/paket-pruefen.ps1` | prüft ein ausgepacktes Paket gegen Kriterium 0: rechnet aus den PE-Import- und Verzögerungstabellen die **Startkette** aus und zählt einen Treffer in `SysWOW64`/`System32` ausdrücklich **nicht** als vorhanden; beim Debug-Paket weist es den Weg über `laufzeit-holen.ps1` selbst ab (PR-2.0 behoben am 06.09.2026, drei Gegenproben in `Befunde/PAKET.md`). Es ersetzt keinen Startversuch auf einem fremden Rechner — es sagt, ob der Lader alles findet, was er vor dem ersten Befehl braucht |
| `tools/ausliefern.pl` | prüft die Regel „eine Nummer, ein Bau" nach: `--pruefen` |
| `tools/release-pruefen.pl` | prüft, ob das ausgelieferte Release zum Quellstand passt |
| `tools/vc71-bruecke-messen.pl` | misst die Bindung der Fremd-DLLs an die VC-7.1-Laufzeit und erzeugt daraus die `.def` der `VC71Bruecke` |
| `tools/gesichert.pl` | beantwortet in einem Aufruf: alles committet, alles gepusht, sind die **anderen** Arbeitsbäume sauber? **Sofort laufen lassen, wenn Gregor einen Merge ankündigt.** `--ohne-holen` verzichtet auf `git fetch --prune` |
| `tools/ungesichertes-melden.pl` | meldet ungesicherte Änderungen |
| `tools/lehren-spiegeln.pl` | spiegelt die Lehren aus dem Gedächtnis nach `Arbeitsweise/` |
| `tools/pruefe-fensterbau.pl` | `pre-commit`-Schranke für den Fensterbau: keine modale Meldung in `Eudora71/OTShim/*.cpp` (E-33), `GetButton` hat Indexschranke **und** Ausnahmefang (E-34), jeder `GetButton`-Aufruf prüft sein Ergebnis auf NULL (E-35, E-36). Prüft alle `Eudora71/Eudora/*.cpp` — eine feste Dateiliste hatte genau die Lücke, in der E-36 lag. **Wer sie anfasst, lässt die drei Gegenproben laufen** |
| `tools/strg-n-pruefen.ps1` | startet Eudora, klickt Meldungen weg, schickt Strg-N und sagt, ob das Verfassen-Fenster aufgeht. **Öffnet ein Fenster** — nicht ohne Absprache laufen lassen |
| `tools/arbeitsbaum-frei.pl` | bucht einen Arbeitsbaum auf einen Agenten (`--neu`, `--freigeben`) und nennt namentlich, welche unverfolgten Dateien ein Zweigwechsel vernichten würde. Verfahren in [AGENTEN.md](AGENTEN.md) |
| `tools/befunde-einsammeln.pl` | führt die Befunddateien aus `Befunde/` in `BEFUNDE.md` zusammen (`--anhaengen`) und nennt die nächste freie Kennung (`--naechste E`) |
| `tools/doku-pruefen.pl` | hält alle MD-Dateien gegen `ZIEL.md`, `VERSION` und `Eudora71/Version.h`: Kriterienzahl und Summe der Teile, doppelte oder widersprüchliche Befundkennungen, Verweise ins Leere, genannte ZIPs, die es nicht gibt, und eine alte Paketnummer als heutiger Stand. Holt seine Dateiliste aus `git ls-files` — eine Liste von Hand prüfte genau die Dateien nicht, an die niemand gedacht hat |
| `tools/pruefstand-melden.pl` | meldet, wie weit `BEFUNDE.md`, `README.md` und `PORTIERUNG.md` hinter dem Code herlaufen (Marke `<!-- pruefstand: … -->`) |

**Bewusst nicht in der Tabelle**, weil Hilfsmittel für einen einzelnen Befund:
`tools/befehl-schicken.ps1` (schickt `WM_COMMAND` an ein Fenster) und
`tools/zeiger-nachpruefen.pl` samt `tools/zeiger-nachpruefen-tests.pl`
(Nachprüfung der Zeigerhärtungen). Damit sind alle 37 Dateien in `tools/`
verzeichnet — nachgezählt am 07.09.2026 (Befund W-23, `Befunde/LEKTOR-4.md`).

## Was bisher gemacht wurde

Der Quellcode ist von 1996–2006 und stammt aus der Zeit von Visual C++ 6.
Repariert wurden im Wesentlichen sieben wiederkehrende Muster:

- Deklarationen ohne Rückgabetyp (`default-int`, in C++ nicht mehr erlaubt)
- entfernte Header (`<xstddef>`), fehlende Extended-MAPI-Header
- alte `for`-Scope-Regeln (Schleifenzähler nach der Schleife weiterbenutzt)
- `strchr`/`strstr`/`strrchr` liefern in C++ `const char*`
- `std::auto_ptr`, Iteratoren-als-Zeiger (`it = NULL`), nicht-`const` Komparatoren
- MFC-`const`-Overloads liefern kein lvalue mehr
- Namenskollisionen mit winsock2 und der UCRT

Dazu drei Projekteinstellungen: die mitgelieferte VC6-Kopie der `/GS`-Runtime
deaktiviert, SafeSEH für QCSSL aus, `/WX` aus dem OpenSSL-Makefile.

Ausführlich mit Begründungen: **[PORTIERUNG.md](PORTIERUNG.md)**

Getrennt davon steht die Portierung von QCSSL auf die **OpenSSL-3.x-API**:
0.9.7l von 2006 kannte noch offene Strukturen, 3.x kapselt sie hinter
Zugriffsfunktionen. Betroffen waren vor allem die BIO-Schicht und
`QCSSLContext.cpp`.

## Die Ersatzschicht für Stingray OT501

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

> **Achtung, ein naheliegender Irrtum:** die Registerkartenleiste ist **nicht**
> verzichtbar. Abschaltbar ist nur der MDI-Streifen — `CMainFrame::FinishInitAndShowWindow`
> ruft dafür `ShowMDITaskBar(GetIniShort(IDS_INI_MDI_TASKBAR))`, und
> `SECWorkbook` in der Ersatzschicht hält `m_bWorkbookMode` dauerhaft auf
> `FALSE` (`OTShim.cpp`, Konstruktor und `SetWorkbookMode`). Das
> Registerkarten-*Steuerelement* `SEC3DTabWnd`/`SEC3DTabControl` sitzt in
> **jeder** Wazoo-Leiste und wird davon nicht berührt. Mit leeren Rümpfen
> startet Eudora zwar, aber Mailboxes, Nicknames, Filters, Directory Services,
> Link History und Task Status bleiben leer. Die Registerkarten sind deshalb als
> eigener Teil ausgeführt (`OTShim_Reiter.*`).

Bestandsaufnahme: [Eudora71/OTShim/INVENTAR.md](Eudora71/OTShim/INVENTAR.md) —
Umsetzungsplan mit Stufen und Belegen:
**[Eudora71/OTShim/PLAN.md](Eudora71/OTShim/PLAN.md)**

Ein Rest bleibt behelfsmäßig: `__imp___iob` aus `libpng.lib` definiert
`OTShim_Libpng.cpp` als `(char*)stderr - 2*32`, weil libpng 1.2.7 nur `_iob[2]`
anfasst und die damalige CRT 32 Byte je Element hatte. Das trägt, ist aber eine
Annahme; sauber wäre ein Neubau von libpng aus `Eudora71/PNG/libpng` mit v143.

## Ergänzungen gegenüber der CHM-Freigabe

- `Eudora71/MAPI/include` — Extended-MAPI-Header aus
  [microsoft/MAPIStubLibrary](https://github.com/microsoft/MAPIStubLibrary) (MIT).
  Nötig, weil `mapix.h` und `mapiutil.h` seit dem Windows-8-SDK nicht mehr
  im Windows SDK enthalten sind — im hier benutzten SDK 10.0.22621.0 liegen unter
  `um\` nur noch `MAPI.h` und `MapiUnicodeHelp.h`.
- `Eudora71/OpenSSL3` — Header und statische Bibliotheken von **OpenSSL 3.5.8 LTS**
  (`libcrypto.lib`, `libssl.lib`), damit sich `QCSSL` ohne einen 25-minütigen
  OpenSSL-Lauf übersetzen lässt. Beide liegen im Repo, ein frischer Klon bindet
  `QCSSL` ohne Zutun. Bauweg und Prüfsumme stehen in
  [Eudora71/OpenSSL3/BAUEN.md](Eudora71/OpenSSL3/BAUEN.md). Das alte `Eudora71/OpenSSL`
  (0.9.7l) liegt noch im Baum. Gegen `libeay32.lib`/`ssleay32.lib` linkt allerdings
  **kein** Projekt mehr; geblieben ist nur ein toter Include-Pfad `..\OpenSSL\inc32`
  in `QCSocket.vcxproj:60` und das `OpenSSL`-Projekt, das in der Solution noch
  mitgebaut wird. Beides kann weg.
- `Eudora71/VC71Bruecke` — eigener Nachbau der `MSVCR71.dll` als Weiterleitung
  auf die von Windows mitgelieferte `msvcrt.dll`. Die vorgebauten Fremd-DLLs von
  2006 (Paige32, EuMemMgr und die übrigen) brauchen diese Laufzeit. `MFC71.DLL`
  und `MSVCP71.dll` sind dagegen **nicht** nachbaubar (157 Ordinale); Adressbuch,
  LDAP und Ph fallen deshalb dauerhaft aus (Befund B-1).
- `Eudora71/Eudora/utils.cpp` — UTF-8-Übersetzungstabelle von 27 auf 123 Einträge
  erweitert (deutsche Umlaute und Latin-1), nach
  [HansWurst81675/Eudora_patches](https://github.com/HansWurst81675/Eudora_patches).
  Sieben Zuordnungen aus dem Qualcomm-Altbestand waren falsch und sind berichtigt,
  ebenso die Doppelersetzung. Der UTF-8-Fall läuft inzwischen über den
  Windows-Codepage-Wandler; die Tabelle bleibt als Rückfallweg für Post, die
  `utf-8` behauptet und CP1252-Bytes trägt. Belegt durch die Unit-Tests in
  `Eudora71/Tests`.

## Verwandte Projekte

- [HermesMail](https://sourceforge.net/projects/hermesmail/) — rüstet ein
  installiertes Eudora 7.1 binär mit neueren TLS-DLLs nach (OpenSSL 1.0.2)
- [Eudora_patches](https://github.com/HansWurst81675/Eudora_patches) — Binärpatches
  für die Umlautdarstellung

## Lizenz

Der Eudora-Quellcode steht unter der BSD-artigen Lizenz der Freigabe von 2018
(siehe Kopf der Quelldateien). Fremdbestandteile behalten ihre eigenen Lizenzen.
