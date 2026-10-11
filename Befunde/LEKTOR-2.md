# LEKTOR-2 — Ist die README auf dem Stand? Gemessen, nicht gelesen

**Agent:** LEKTOR · **Kennung:** `L-6` · **Zweig:** `wt/lektor` ·
**Arbeitsbaum:** `Eudora7.2-wt-lektor` · **Datum:** 06.09.2026 ·
**Bezugscommit:** `9512108`

**Nicht gebaut, Eudora nicht gestartet.** Alle Aussagen unten sind am Baum
gemessen; jeder Messbefehl steht dabei, damit sie nachprüfbar sind.

## Die Antwort auf Gregors Frage

> *„readme ist auf dem letzten stand? alle alten inhalte gelöscht?"*

**Nein, sie war es nicht.** Von den Tatsachenbehauptungen der `README.md` waren
**sechs falsch** — nicht nur unscharf, sondern falsch: zwei Fundstellen zeigten
auf etwas ganz anderes, ein ganzer Absatz zählte Bibliotheken, die es so nicht
gibt, und ein Beleg (`cat VERSION`) liefert eine andere Zahl als die, für die er
angeführt wird. **Alle sechs sind berichtigt.** Was stimmte, ist ebenfalls
nachgemessen und steht unter L-6.8.

---

## L-6.1 — `eudora.cpp:3542` zeigt auf etwas ganz anderes

**Behauptung** (README, Abschnitt „Starten"; ebenso `STARTUMGEBUNG.md:106` und
`Releases/PAKETE.md:197`):

> „Das Mailverzeichnis **muss eine `Eudora.ini` enthalten**, sonst bricht Eudora
> in `eudora.cpp:3542` ab."

**Gemessen.** An `eudora.cpp:3542` steht der Aufruf von `GetModuleFileName`
mitten in `CEudoraApp::RegisterMailbox` — Registrierung der Dateizuordnung für
`.mbx`, kein Abbruch, kein INI-Bezug.

**Woher der Satz stammt.** `STARTUMGEBUNG.md` nennt die gemeinte Stelle mit:
`VERIFY(GetShortPathName(INIPath,…))`. Die steht heute an `eudora.cpp:3605`, in
**`CEudoraApp::RegisterCommandLine`** (Funktionsbeginn Zeile 3584).

**Aber auch das ist kein Abbruch.** `VERIFY` wirkt nur im Debug-Bau; dort löst
es einen SUPERASSERT-Dialog aus (*Ignore Once*), im Release-Bau wertet es den
Ausdruck aus und tut sonst nichts. `GetShortPathName` scheitert an einer Datei,
die es nicht gibt — mehr passiert nicht.

**Bricht Eudora bei fehlender `Eudora.ini` überhaupt ab? Nein.** Der Weg mit
Mailverzeichnis auf der Kommandozeile (`Eudora.exe "<Pfad>"`) läuft so:

| Schritt | Datei | prüft die INI? |
|---|---|---|
| `CEudoraApp::InitInstance` → `GetDirs(m_lpCmdLine)` | `fileutil.cpp:398` | nein |
| `GetDirs` → `CheckMailDirectory` | `fileutil.cpp:321` | nein — nur, ob das **Verzeichnis** existiert (`FileExistsMT`), sonst `ErrorDialog(IDS_ERR_BAD_EUDORA_DIR)` |
| `GetDirs` → `SetupINIFilename` | `rs.cpp:1359` | nein — setzt `INIPath` zusammen; `FileExistsMT(INIPath)` steuert dort nur die Umwandlung des alten INI-Formats |
| `RegisterCommandLine` | `eudora.cpp:3584` | das `VERIFY` oben, nur Debug-Bau |

Die einzige Stelle, die wegen einer fehlenden INI vorzeitig endet, ist
`eudora.cpp:1038` — und die greift **nur, wenn gar kein Argument übergeben
wurde**: `if (CommandLine.IsEmpty())`, dann `if (!FileExistsMT(INIPath))`, dann
`if (!StartEudoraWithDefaultLocation()) return FALSE;`.

`StartEudoraWithDefaultLocation` (`eudora.cpp:3625`) sucht daraufhin
`DEudora.ini`, die Registry (`HKEY_CURRENT_USER`, danach `HKEY_CLASSES_ROOT`)
und zuletzt `%APPDATA%`. Erst wenn auch das nichts hergibt, gibt sie `FALSE`
zurück, und `InitInstance` beendet das Programm **lautlos**.

**Was jetzt dasteht** (README, `STARTUMGEBUNG.md`, `Releases/PAKETE.md`): die
Empfehlung, eine `Eudora.ini` beizulegen, plus ein Berichtigungskasten mit dem
alten Wortlaut und der Fundstelle als **Funktionsname**. Kein Zeilenverweis
mehr — Funktionsnamen verschieben sich nicht.

## L-6.2 — Der Absatz über die Bibliotheken nannte vier Zahlen, drei davon falsch

**Behauptung** (README, „Was fertig gebaut wird"): elf `.lib`, davon sieben
Importbibliotheken, vier statische, dazu sechs vorgefertigte Fremdbibliotheken
`EuMemMgr`, `Paige32d`, `SSCEWD32`, `Uuid`, `libpng`, `zlib`.

**Gemessen — ohne einen Bau, an den Projektdateien:**

```sh
grep -oE '<ConfigurationType>[^<]*' Eudora71/*/*.vcxproj Eudora71/*/*/*.vcxproj
grep -oE '<ImportLibrary>[^<]*'     Eudora71/*/*.vcxproj Eudora71/*/*/*.vcxproj
git ls-files Eudora71/Lib/
```

| | Behauptet | Gemessen |
|---|---|---|
| statische Bibliotheken | 4 | **4** — `AccountWizard`, `DirectoryServicesUI`, `EuImap`, `SearchEngine`; die einzigen vier Projekte mit `<ConfigurationType>StaticLibrary` |
| Importbibliotheken nach `Lib/<Konfig>` | 7 | **11** Projekte schreiben eine dorthin: `EuLang`, `EudoraRes`, `imap`, `NSImport`, `OEImport`, `OLImport`, `QCSSL`, `QCSocket`, `QCUtils`, `plstclnt`, `VC71Bruecke` |
| `.lib` insgesamt | 11 | hängt davon ab, was zuletzt gebaut wurde — `Eudora71/Lib/` ist von `.gitignore` erfasst |
| Fremdbibliotheken | 6, darunter `Paige32d` | **6**, aber in **Release** heißt Paige `Paige32.lib`, nur in **Debug** `Paige32d.lib` |

Zwei Fallen, die beim Zählen von Hand zuschlagen — und die erklären, warum
frühere Zählungen auseinandergingen:

* **Groß- und Kleinschreibung.** `SSCEWD32.LIB` und `Uuid.Lib` fallen aus einem
  `ls *.lib` heraus. Wer sie übersieht, kommt auf vier statt sechs
  Fremdbibliotheken.
* **`VC71Bruecke` heißt dreimal anders.** Projekt `VC71Bruecke`, DLL
  `msvcr71.dll` (`<TargetName>msvcr71`), Importbibliothek
  `msvcr71-bruecke.lib`. Wer nach „VC71Bruecke.lib" sucht, findet nichts.

**Was jetzt dasteht:** keine Zahlen mehr, sondern **drei Sorten mit
Erkennungsmerkmal** — Importbibliothek hat eine `.exp` daneben; statische
Bibliothek hat keine und wird beim Bau neu geschrieben; Fremdbibliothek hat
keine und steht in `git ls-files`. Dazu drei Befehle zum Nachzählen. Das
veraltet nicht, wenn ein Projekt dazukommt.

## L-6.3 — `cat VERSION` belegt nicht, was es belegen soll

**Behauptung** (README, Kopf): „**Quellstand ist 7.2.0.12** (`cat VERSION`,
`Eudora71/Version.h`)".

**Gemessen:** `cat VERSION` liefert **`1.0.12`**;
`grep EUDORA_BUILD_VERSION Eudora71/Version.h` liefert `"7.2.0.12"`.

`VERSION` enthält die **Paketnummer**, nicht die Quellversion. Genau die
Verwechslung, vor der derselbe Absatz zwei Sätze später warnt, steckt in seiner
eigenen Belegklammer. `tools/ausliefern.pl:70-73` liest beide getrennt ein.

Nebenbefund: `VERSION` steht bereits auf `1.0.12`, obwohl es kein Paket 1.0.12
gibt — die Nummer ist vorgezogen. Das ist so gewollt, steht jetzt aber auch da.

## L-6.4 — `mainfrm.cpp:1025` ist eine Kommentarzeile

**Behauptung** (README, Kasten zur Registerkartenleiste): „Abschaltbar ist nur
der MDI-Streifen hinter `m_bWorkbookMode` (`mainfrm.cpp:1025`)."

**Gemessen:** Zeile 1025 ist eine leere Kommentarzeile. Der Aufruf steht eine
Zeile tiefer, `ShowMDITaskBar(GetIniShort(IDS_INI_MDI_TASKBAR))`, in
`CMainFrame::FinishInitAndShowWindow` (ab Zeile 820). `m_bWorkbookMode` kommt in
`mainfrm.cpp` überhaupt erst ab Zeile 8447 vor; gesetzt wird es in der
Ersatzschicht (`OTShim.cpp:788`, Konstruktor), und `SECWorkbook::SetWorkbookMode`
(`OTShim.cpp:1105`) weist ihm **bewusst nichts** zu.

**Was jetzt dasteht:** Funktionsnamen statt Zeilennummern.

## L-6.5 — Stingray-Header: 30 behauptet, 28 gemessen

**Behauptung:** „**42** Quelldateien und 30 Header unter `Eudora71/Eudora`
nennen mindestens einen Stingray-Bezeichner."

**Gemessen.** Die naive Suche `\bSEC[A-Z]` trifft auch die SSPI-Konstanten
`SECBUFFER_*`, `SECPKG_*`, `SECURITY_*` und liefert 45/32. Zählt man nur
Bezeichner mit mindestens einem Kleinbuchstaben — `SECControlBar`,
`SEC3DTabWnd`, `SECWorkbook` —, ergibt sich **42 Quelldateien** (stimmt genau)
und **28 Header** (behauptet: 30). Der Befehl:

```sh
for ext in cpp h; do
  for f in $(grep -rlE 'SEC[A-Z]' Eudora71/Eudora --include=*.$ext); do
    grep -oE 'SEC[A-Z][A-Za-z0-9_]*' "$f" | grep -q '[a-z]' && echo "$f"
  done | wc -l
done
```

Dass die 42 auf den Punkt trifft, spricht dafür, dass es dieselbe Zählweise
ist; die beiden Header sind seither weggefallen. Berichtigt auf 28, mit der
Zählweise dabei.

Die übrigen OT501-Zahlen stimmen und sind nachgemessen: **127 Header** unter
`Eudora71/OT501/Include` (das Verzeichnis zählt 130 Einträge — dazu `SECRES.RC`,
`SECRES.APS` und der Ordner `RES`), **67** vorhandene Quelldateien von den 186,
die `otlib50.mak` erwartet.

## L-6.6 — „121 Zertifikate" ist keine Eigenschaft des Repos

`Releases/1.0/rootcerts-erzeugen.ps1` liest den **Windows-Wurzelspeicher der
Maschine** und wirft abgelaufene und noch nicht gültige Zertifikate weg. Die
Zahl hängt damit am Zertifikatstand des Rechners und am Tag. Das Skript nennt
sie am Ende selbst (*„Gegenprobe (wieder eingelesen): N Zertifikate"*); eine 121
steht nirgends darin. Zahl entfernt, Messweg hingeschrieben.

## L-6.7 — `msvcr71.dll` fehlte in der Liste der Bauergebnisse

Die Tabelle „Was fertig gebaut wird" nannte `Eudora.exe`, `EudoraRes.dll`, sechs
DLLs, drei `.eif`, ein `.epi` — aber nicht die `msvcr71.dll` aus dem Projekt
`VC71Bruecke`, obwohl sie nach `Eudora71/Bin/<Konfiguration>` geht und ohne sie
`EuMemMgr.dll` und `Paige32d.dll` nicht laden. Ergänzt.

## L-6.8 — Was in der README nachgemessen wurde und stimmt

Damit der Bericht nicht nur die Fehler zeigt. Alles Folgende ist am 06.09.2026
geprüft und **richtig**:

| Behauptung | Messung |
|---|---|
| alle 25 in „Werkzeuge" genannten Dateien existieren | `test -e` je Datei — 25 von 25, dazu `tools/Kriterium0-pruefen.wsb`, der Patch und `Releases/1.0/rootcerts-erzeugen.ps1` |
| die Schalter `-Konfiguration`, `-NurPruefen`, `-Ziel`, `--ohne-holen`, `--melden`, `--pruefen`, `--auch-umgekehrt` | in `param(...)` bzw. in der Argumentprüfung des jeweiligen Werkzeugs gefunden |
| `pruefe-bytes-tests.pl` „35 Fälle", `pruefe-branch-tests.pl` „15 Fälle" | `grep -cE 'schl\s*=>'` → **35** und **15** |
| `utils.cpp`: Übersetzungstabelle auf 123 Einträge erweitert | `utils.cpp:46` — `#define XLATE_CHARS 123` |
| Windows SDK 10.0.22621.0 hat unter `um\` nur noch `MAPI.h` und `MapiUnicodeHelp.h` | Verzeichnis aufgelistet — genau diese zwei |
| OpenSSL 3.5.8, TLS 1.2 als Untergrenze für alle acht Werte von `m_ProtocolVersion`, keine Obergrenze | `QCSSLContext.cpp:561` — `switch` über `case 0..7`, jeder Zweig auf `TLS1_2_VERSION`; `set_max_proto_version` im ganzen QCSSL **0 Treffer** |
| toter Include-Pfad `..\OpenSSL\inc32` in `QCSocket.vcxproj:60` | steht dort |
| `Eudora.map` entsteht bei jedem Bau | `Eudora.vcxproj:98` und `:148` — `<GenerateMapFile>true</GenerateMapFile>` |
| `QCExceptionHandler::WriteModuleTable` in `ExceptionHandler.cpp` | Zeile 346, aufgerufen aus Zeile 412 |
| `.gitattributes` setzt `* -text` | letzte Zeile der Datei |
| `EudoraOldIcons.epi` und die drei `.eif` | `<OutputFile>$(OutDir)EudoraOldIcons.epi` bzw. `$(OutDir)$(ProjectName).eif` |
| die Ersatzschicht „in fünf Teilen über `OTShimAll.h`" | fünf `#include "OTShim*.h"` darin |
| 19 Projekte in der Projektmappe, eines übersprungen (18/0/1) | `grep -E '^Project\(' Eudora71/Eudora.sln` → 19; `OT501` hat `ActiveCfg`, aber **kein** `Build.0` |
| OpenSSL3-Bibliotheken: Größen und Prüfsummen aus `BAUEN.md` | `sha256sum` — beide stimmen auf das Byte |

---

## L-6.9 — Die Liste aus dem fünften Durchgang (L-4), abgearbeitet

`Befunde/LEKTOR.md`, Abschnitt L-4, führte rund 37 überholte Aussagen in
anderen `.md`. Stand nach diesem Durchgang:

### Behoben

| Datei | Was |
|---|---|
| `PORTIERUNG.md` | Kasten „gemessen 05.09.2026" (Stand vor B-3); „16 der 18 Projekte"; `EudoraRes.vcxproj:351`; OpenSSL3-Libs „nicht im Repo"; E-11; „im Release-Zweig ungetestet"; Kopf, Zweig, Prüfstandsmarke; Port 995 ergänzt |
| `STARTUMGEBUNG.md` | Debug-Laufzeiten als Punkt 1 für jeden Paketanwender (L-3); `EudoraRes` hänge an OT501; `eudora.cpp:3542`; SUPERASSERT „nur Debug-Bau"; alte Bau-Kennung (M-9); „ob Eudora startet, sagt diese Datei nicht" |
| `Releases/PAKETE.md` | Kasten über die Lücke 1.0.4–1.0.10; Versionsanleitung; E-11 an zwei Stellen; Debug-Laufzeiten im Release-Abschnitt (L-3); LIESMICH „beschreibt noch den Debug-Weg"; Tabelle „Stand nach ZIEL.md"; `eudora.cpp:3542` |
| `ABRUF-PRUEFEN.md` | „Belegt ist Port 110"; Entscheidungsbaum „auf 995 horcht dort nichts"; Verweis auf einen UNGEPRÜFT-Hinweis, den es nicht mehr gibt |
| `Eudora71/OpenSSL3/BAUEN.md` | die Aufforderung ganz oben, OpenSSL selbst zu bauen |
| `BEFUNDE.md` | `Z-3` auf „offen"; **E-14, E-16, E-17, E-22, E-23, E-24, E-25, E-26** fehlten im Verzeichnis; Kopfzahlen; Prüfstandsmarke |
| `PRUEFUNG-BRANCH.md`, `Pruefung/PRUEFUNG-KETTE.md`, `Pruefung/PRUEFUNG-ZEIGER.md` | „Ursache wieder offen" / „weiterhin unerklärt" / E-11 — Nachtragskästen mit E-25 und E-26 |
| `PRUEFUNG-BAU.md` | `Version.h` sage 7.2.0.3; roher `MSBuild.exe`-Aufruf statt `tools/bauen.ps1` (X-6) |
| `PRUEFUNG-CODE.md` | M-11 stand an drei Stellen als offen, ist mit `57fe6a4` behoben; M-8 abgearbeitet |
| `Releases/1.0/README.md`, `Releases/1.0/AUSLIEFERUNGEN.md` | rootcerts „nicht getestet"; Servertest nur über Port 110 |
| `Eudora71/VC71Bruecke/BEFUND.md` | alle vier „nächsten Schritte" erledigt; die drei Fremd-DLLs liegen inzwischen im Repo |
| `Eudora71/OTShim/PLAN.md`, `BEFUND-ANSICHT.md`, `BEFUND-MENUE.md` | `LNK1104: imap.lib`; „zu prüfen, ob ein Solution-Bau die Datei erzeugt"; „EudoraRes.dll fehlt, der Startversuch scheitert daran"; Projektverweis Zeile 1015; eine Vorhersage, die E-1 entschieden hat |
| `BEFUNDE-ALTBESTAND.md`, `tools/patches/zertifikatspruefung-verschaerfen.md` | die alte CR-Anzahl-Regel und „`--no-verify` gerechtfertigt" |
| `LEKTORAT.md` | der fünfte Durchgang war der letzte Eintrag; dieser hier ist als **sechster** nachgetragen |

### Bewusst stehen gelassen — mit Begründung

| Was | Warum |
|---|---|
| **Die Messwerte in allen Prüfberichten** (`PRUEFUNG-*.md`, `Pruefung/*.md`, `Befunde/*.md`) | Ein Bericht ist ein Zeitdokument. Seine Zahlen bleiben, weil sie belegen, was an jenem Tag galt. Überholt ist nur die *Schlussfolgerung* — die ist mit einem Nachtragskasten gekennzeichnet, nicht ersetzt. Wer sie löscht, kann später nicht mehr zeigen, warum jemand etwas geglaubt hat |
| **`Releases/PAKETE.md` ohne Abschnitte für 1.0.4 bis 1.0.10** | Dafür bräuchte es Messwerte an den ZIPs — Dateigrößen, Prüfsummen, Kennung der enthaltenen `Eudora.exe`. Zwei der sieben ZIPs liegen gar nicht im Repo. Erfinden kommt nicht in Frage; ein Kasten am Anfang benennt die Lücke, **M-4** bleibt offen |
| **`README.md:34` „18 erfolgreich, 0 Fehler, 1 übersprungen, 2:37 min"** | Gregors eigene Messung vom 06.09.2026 in der IDE. Ich baue nicht, kann sie also nicht nachmessen — nur die Randbedingung prüfen (19 Projekte, `OT501` ohne `Build.0`), und die stimmt |
| **`README.md:132` „`Eudora.map`, 51.075 Einträge"** | `Eudora71/Bin/Release/` ist von `.gitignore` erfasst, die Datei entsteht erst beim Bau. Nachgemessen ist, dass sie bei jedem Bau **entsteht** (`<GenerateMapFile>true</GenerateMapFile>`); die Zahl selbst konnte ich ohne Bau nicht prüfen und habe sie deshalb nicht angefasst |
| **`README.md` „30 Stellen, 22 Stingray-Klassen, 77 Methoden"** | Die Zählweise ist nicht dokumentiert, und anders als bei den 42 Quelldateien ist mir keine Rekonstruktion gelungen, die genau diese drei Zahlen ergibt. Raten wäre schlimmer als stehen lassen. **Zurückgestellt** |
| **`Eudora71/Eudora/mainfrm.cpp:9684`** | Der Kommentar zeigt die alte Bau-Kennung `[1.0.3+31810e2 - Eudora72-1.0.3]`; heute lautet sie `Eudora <Produkt> / Paket <Nummer>+<Commit><Marke> <Zeit>`. Das ist **Quelltext**, nicht Dokumentation — LEKTOR fasst keinen Quelltext an. Als **M-9** bekannt, in `STARTUMGEBUNG.md` jetzt ausdrücklich benannt |
| **`Eudora71/Tests/QCSSL/README.md`, `Eudora71/OTShim/INVENTAR.md`** | Schon im fünften Durchgang ohne Befund; erneut durchgesehen, weiter ohne Befund |
| **`BEFUNDE.md`: E-27, E-28, E-29** | Laufen gerade bei anderen Agenten. Ein Verzeichniseintrag ohne Abschnitt wäre genau der Fehler, gegen den das Verzeichnis geschrieben ist |

## L-6.10 — Zwei Fehlerklassen, nicht zwei Einzelfehler

Beide Fundstellenfehler dieses Durchgangs sind vom selben Typ, und der ist
vermeidbar:

1. **Zeilennummern in Fließtext veralten lautlos.** `eudora.cpp:3542` und
   `mainfrm.cpp:1025` zeigten beide auf etwas anderes, ohne dass irgendetwas
   angeschlagen hätte. **Schranke:** wo es geht, **Funktionsname statt
   Zeilennummer**. `CEudoraApp::RegisterCommandLine` verschiebt sich nicht.
   Wo eine Nummer unvermeidlich ist (Projektdateien, `.sln`), gehört der
   erwartete Inhalt daneben, damit ein Leser den Verrutscher merkt.
2. **Eine Zahl, die niemand pflegt, ist schlimmer als keine.** Der
   Bibliotheksabsatz nannte vier Zahlen; drei waren falsch, und die falschen
   sahen genauso vertrauenswürdig aus wie die richtige. **Schranke:** die
   **Kategorie** beschreiben und das **Erkennungsmerkmal** dazu
   („Importbibliothek = hat eine `.exp` daneben"), plus den Befehl zum
   Nachzählen. Dann steht in der Datei nichts, was veralten kann.

## L-6.11 — Arbeitsweise und Byte-Messung

**Kein Edit-Werkzeug.** Alle Änderungen über `tools/ersetze-bereich.pl`, das mit
`:raw` liest und schreibt und Kopf und Rumpf byteweise durchreicht. Nach jeder
Änderung gemessen:

```sh
perl -e 'open(my $h,"<:raw",$ARGV[0]);local $/;my $d=<$h>;
  my $cr=()=$d=~/\r/g; my $dk=()=$d=~/\xC3\x83\xC2|\xC3\xA2\xC2\x80|\xC3\x82\xC2/g;
  print "CR=$cr DK=$dk\n"' DATEI.md
```

und gegen `git show HEAD:DATEI.md` gehalten. **Ergebnis: in allen 19 geänderten
Dateien sind CR-Zahl und Doppelkodierungszahl unverändert.**

**Drei Beobachtungen, die dem nächsten Durchgang Zeit sparen:**

* **Der naive Doppelkodierungszähler schlägt auf Zitate an.** `BEFUNDE.md`
  meldet 3, `PORTIERUNG.md` 1, `ABRUF-PRUEFEN.md` 1, `LEKTORAT.md` 1 — alle
  vorher wie nachher, und alle sind **absichtlich** dort: es sind zitierte
  Beispiele für genau diesen Schaden, in den Befunden zur Umlautdarstellung
  (Z-2, Z-2b). Nicht der absolute Wert zählt, sondern der **Vergleich mit
  `HEAD`**.
* **`Pruefung/PRUEFUNG-ZEIGER.md` hat CRLF** (193 CR). Ein Ersatzblock mit
  LF-Enden senkt die CR-Zahl lautlos — beim ersten Versuch genau so passiert und
  nur aufgefallen, weil `ersetze-bereich.pl` die Zahl vorher/nachher ausgibt.
  Der Block muss dieselben Zeilenenden tragen wie die Datei. **Vor dem
  Schreiben prüfen**, nicht danach.
* **Ein `cat`-Heredoc über etwa 10 KB bricht ab** („unexpected EOF") — schon in
  `Befunde/LEKTOR.md` als Nebenbefund vermerkt und hier erneut aufgetreten.
  Diese Datei ist deshalb in sechs Stücken geschrieben und mit `cat`
  zusammengesetzt worden.

## Was ich nicht getan habe

* **Nicht gebaut, Eudora nicht gestartet, keine Zeile Quelltext geändert.**
* **`README.md`, Abschnitte „Nach einem frischen Klon" und „Das
  Absturzprotokoll" nicht angefasst** — die hat der auftraggebende Agent vorher
  selbst geprüft und berichtigt.
* **Keinen Befund E-27 bis E-29 eingetragen** — die laufen bei anderen Agenten.
