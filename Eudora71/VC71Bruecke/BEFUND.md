# VC71Bruecke — Ersatz für die Laufzeitbibliothek von Visual C++ 7.1

Stand: 30.08.2026, Agent BRUECKE, Branch `worktree-agent-a6ced3628715022ba`.

Alle Zahlen in diesem Dokument sind **gemessen**, nicht geschätzt. Das Werkzeug
war durchgehend `dumpbin` aus VS 2022 (14.38.33145). Aufruf mit **Bindestrich**
statt Schrägstrich, sonst verschluckt Git Bash das Argument:

    dumpbin -imports <datei>
    dumpbin -exports <datei>
    dumpbin -dependents <datei>

Wo etwas nicht nachgemessen ist, steht **UNGEPRÜFT** davor.

---

## Kurzfassung

| Frage | Antwort |
|---|---|
| Ersatz-`msvcr71.dll` als Weiterleitung an `msvcrt.dll` möglich? | **Ja, gebaut und geprüft.** 1430 Exporte, davon 1429 Weiterleitungen und eine eigene Funktion. |
| Braucht die Brücke selbst eine moderne CRT? | **Nein.** `dumpbin -dependents` zeigt nur `KERNEL32.dll`. |
| Lösen die Weiterleitungen zur Laufzeit wirklich auf? | **Ja, alle 1429**, mit einem Konsolen-Prüfprogramm nachgewiesen. |
| Reicht die Release-`Paige32.dll` unter dem Namen `Paige32d.dll`? | **Ja** — ABI-gleich, mit vier unabhängigen Messungen belegt. |
| Braucht das Paket `msvcr71d.dll` / `msvcp71d.dll`? | **Nein.** Details unten. |
| `MFC71.DLL` ersetzbar? | **Nein. Aussichtslos.** 157 Importe **nach Ordinal**, kein einziger nach Namen. |
| `MSVCP71.dll` ersetzbar? | **Praktisch nein.** 173 verstümmelte C++-Namen, kein Windows-Partner. Nachbau wäre möglich, lohnt sich aber nicht — siehe unten. |

---

## 1 — Was die Fremd-DLLs wirklich brauchen

Gemessen wurde **jede** Binärdatei unter `Eudora71/Bin/Release`,
`Eudora71/Bin/Debug` und `InstallersForEudora/Eudora7.1/Data/win32`.
Die Rohdaten liegen in `Messung/`.

### 1.1 Berichtigung zweier Zahlen aus dem Auftrag

Der Auftrag nannte Zahlen, die ich nachrechnen sollte. Zwei stimmen nicht:

| Angabe im Auftrag | Gemessen | Bemerkung |
|---|---|---|
| `Paige32.dll` braucht **20** MSVCR71-Funktionen | **19** | Die im Auftrag aufgezählte Liste enthält selbst nur 19 Namen; die Zahl 20 war der Zählfehler, nicht die Liste. Ordinal-Importe gibt es bei Paige gegen MSVCR71 keine. |
| **85** verschiedene MSVCR71-Funktionen über die sieben DLLs | **83** über die sieben, **118** wenn man die drei mitgelieferten Plugins mitzählt | siehe 1.2 |
| **20** verschiedene MSVCP71-Funktionen | **17** über die sieben, **173** mit den Plugins | siehe 1.2 |
| **0** benannte aus MFC71 | **0 benannte — aber 157 nach Ordinal** | Das ist der entscheidende Punkt, siehe Abschnitt 4. |

### 1.2 Der Kreis ist größer als sieben DLLs

Nicht nur die sieben Fremd-DLLs hängen an der alten Laufzeit. In
`Eudora71/Bin/Release/Plugins` liegen **drei weitere vorgebaute Fremdmodule**
ohne Quellen, die Eudora zur Laufzeit lädt:

    SMIME.dll, SpamHeaders.dll, SpamWatch.dll

Alle drei brauchen `MFC71.DLL`, `MSVCR71.dll` **und** `MSVCP71.dll`. Sie sind in
allen Zahlen dieses Dokuments mitgezählt, wo „mit Plugins“ steht.

### 1.3 Bedarfsmatrix, Release-Fassungen

| Modul | MSVCR71 | MSVCP71 | MFC71 | durch die Brücke gelöst? |
|---|---|---|---|---|
| `Paige32.dll` | ja (19) | — | — | **ja, vollständig** |
| `DirServ.dll` | ja | — | — | **ja, vollständig** |
| `EuMemMgr.dll` | ja | — | — | **ja, vollständig** |
| `Ph.dll` | ja | ja | — | nein (MSVCP71 fehlt) |
| `EudoraBk.dll` | ja | — | **ja** | nein (MFC71 fehlt) |
| `ISock.dll` | ja | — | **ja** | nein |
| `Ldap.dll` | ja | ja | **ja** | nein |
| `Plugins/SMIME.dll` | ja | ja | **ja** | nein |
| `Plugins/SpamHeaders.dll` | ja | ja | **ja** | nein |
| `Plugins/SpamWatch.dll` | ja | ja | **ja** | nein |

**Das ist der wichtigste Befund dieses Auftrags:** die Brücke rettet drei von
zehn Modulen vollständig. Die anderen sieben scheitern nicht an `MSVCR71`,
sondern an `MFC71.DLL` und `MSVCP71.dll` — und die liegen dem Paket nach
Auftragsbeschreibung **gar nicht bei**. Nach dieser Messung sind Adressbuch
(`EudoraBk`), `ISock`, LDAP-Verzeichnisdienst, `Ph` und alle drei Plugins
**heute schon nicht ladbar**, unabhängig von der `msvcr71.dll`-Frage. Das
sollte am echten Paket gegengeprüft werden — es liegt nicht im Repository,
ich konnte es nicht ansehen.

### 1.4 Deckung durch `C:\Windows\SysWOW64\msvcrt.dll`

`msvcrt.dll` exportiert **1429** benannte Symbole (Liste:
`Messung/msvcrt-exporte.txt`).

| Bedarf | Anzahl | in `msvcrt.dll` | fehlt |
|---|---|---|---|
| MSVCR71 (Release, mit Plugins) | 118 | 117 | `__security_error_handler` |
| MSVCR71D (Debug, mit Plugins) | 153 | 151 | `__security_error_handler`, `_CRT_RTC_INIT` |

Die Vermutung aus dem Auftrag hat sich also **bestätigt und sogar übertroffen**:
es fehlt tatsächlich nur die eine Funktion. Auch die Debug-Namen wie
`_malloc_dbg`, `_free_dbg`, `_CrtDbgReport`, `_CrtSetDbgFlag`,
`_CrtDumpMemoryLeaks` exportiert `msvcrt.dll` allesamt.

---

## 2 — Die gebaute Brücke

### 2.1 Was gebaut wurde

`Eudora71/VC71Bruecke/` mit

| Datei | Zweck |
|---|---|
| `vc71bruecke.c` | die einzige Funktion, die `msvcrt.dll` nicht hat, plus eigener Einsprungpunkt |
| `msvcr71.def` | **erzeugt**, 1430 Exporte |
| `msvcrt-stub.def` | **erzeugt**, nur Beiwerk zum Binden (siehe 2.3) |
| `VC71Bruecke.vcxproj` | beide Konfigurationen erzeugen dieselbe `msvcr71.dll`, nur in verschiedene Ausgabeordner |
| `Werkzeug/erzeuge-def.pl` | erzeugt die beiden `.def` aus den Messdateien |
| `Werkzeug/pruefe-bruecke.c` | Konsolen-Prüfprogramm, **öffnet kein Fenster** |
| `Messung/*.txt` | die Rohmessungen, aus denen alles abgeleitet ist |

Bauen:

    MSBuild VC71Bruecke.vcxproj /p:Configuration=Release /p:Platform=Win32 /p:BuildProjectReferences=false /m /v:minimal

Beide Konfigurationen sind gebaut worden und laufen durch.

### 2.2 Nachgemessen am fertigen PE

    dumpbin -headers  Eudora71/Bin/Release/msvcr71.dll
      14C machine (x86)          <- x86, richtig
      2102 characteristics -> DLL

    dumpbin -dependents Eudora71/Bin/Release/msvcr71.dll
      KERNEL32.dll               <- und sonst NICHTS

Das war die Kernbedingung aus dem Auftrag: **keine Abhängigkeit auf die
moderne CRT.** Kein `vcruntime140.dll`, kein `api-ms-win-crt-*`, keine
`msvcp140.dll`. Erreicht durch `/NODEFAULTLIB`, eigenen Einsprungpunkt
`VC71BrueckeEinsprung` und `/GS-` (`<BufferSecurityCheck>false`).

    dumpbin -exports Eudora71/Bin/Release/msvcr71.dll
      1430 Exporte gesamt
      1429 davon Weiterleitungen ("forwarded to msvcrt.<name>")
         1 davon eigener Code: __security_error_handler

Der eine eigene Export erscheint als

    229   E4 00001019 __security_error_handler = ___security_error_handler

### 2.3 Die Stolperstelle beim Binden — bitte lesen, bevor jemand daran ändert

Der klassische Weg aus dem Auftrag

    EXPORTS
      malloc = msvcrt.malloc

**funktioniert mit dem Linker aus VS 2022 nicht ohne Weiteres.** Gemessen:

    msvcr71.def : error LNK2001: Nicht aufgelöstes externes Symbol "malloc".

Ich habe die Ursache eingekreist, nicht geraten. Vier Testbindungen mit
jeweils einer einzigen Exportzeile:

| Zeile in der `.def` | Ergebnis |
|---|---|
| `MeinSleep = kernel32.Sleep` | **klappt**, echter Forwarder im PE |
| `X2 = msvcrt.Sleep` | **klappt** |
| `X1 = foo.malloc` | LNK2001 auf `malloc` |
| `X3 = kernel32.malloc` | LNK2001 auf `malloc` |
| `X4 = msvcrtx.malloc` | LNK2001 auf `malloc` |

Entscheidend ist also **nicht** das Modul auf der rechten Seite, sondern der
**Funktionsname**: `Sleep` geht, `malloc` nicht. Der Unterschied ist, dass
`Sleep` über das mitgebundene `kernel32.lib` als Symbol auffindbar ist und
`malloc` unter `/NODEFAULTLIB` nirgends. **link.exe löst den Namen auf der
rechten Seite trotzdem als gewöhnliches externes Symbol auf**, obwohl es für
einen Forwarder gar keinen Code braucht.

Nicht geholfen haben (alle nachgemessen):

- `/EXPORT:malloc=msvcrt.malloc` auf der Befehlszeile statt in der `.def`
- Zusätze `PRIVATE` und `@ordinal`
- `.def` ohne `LIBRARY`-Zeile
- **`/ALTERNATENAME:malloc=_VC71BrueckeLeer`** — greift bei DEF-getriebenen
  Verweisen nicht
- Binden **mit** den Standardbibliotheken statt `/NODEFAULTLIB`

Was hilft: dem Linker die Namen aus **irgendeiner** Bibliothek anbieten. Der
Bauablauf erzeugt deshalb vor dem Binden mit `lib.exe` eine
**Stub-Importbibliothek** aus `msvcrt-stub.def`:

    lib.exe /NOLOGO /DEF:msvcrt-stub.def /MACHINE:X86 /OUT:$(IntDir)msvcrt-stub.lib

Damit bindet es durch — und, wichtig: link.exe erzeugt trotzdem **echte
Forwarder**, keinen Verweis auf das Stub-Symbol. Nachgemessen: die fertige
DLL hat **keine** Importe auf `msvcrt.dll`, nur die 1429 Forwarder-Exporte.
Die Stub-Bibliothek lebt ausschließlich im Zwischenordner.

Zur Dekorierung, die der Auftrag zu Recht als Stolperstelle nannte: die
CRT-Namen werden **undekoriert** exportiert (`malloc`, nicht `_malloc`) — so
importiert Paige sie auch. In der `.def` steht deshalb der nackte Name. Nur
bei der einen selbst umgesetzten Funktion legt link.exe von sich aus den
führenden Unterstrich an (`__security_error_handler = ___security_error_handler`).
Es war **kein** manuelles Zutun nötig.

### 2.4 `__security_error_handler`

`vc71bruecke.c`. Vertrag: `void __cdecl __security_error_handler(int code, void *data)`.
Der Rumpf gibt eine Meldung über `OutputDebugStringA` aus und ruft
`TerminateProcess(GetCurrentProcess(), 0xC0000409)` —
`STATUS_STACK_BUFFER_OVERRUN`. Bewusst **nicht** `ExitProcess`: das ließe
`DllMain(DLL_PROCESS_DETACH)` und die `atexit`-Kette auf einem bereits
beschädigten Stapel laufen. Bewusst **keine** Meldung im Fenster: aus
demselben Grund, und weil dieser Pfad ohnehin nur bei einem echten
Pufferüberlauf betreten wird.

### 2.5 Laufzeitprüfung (kein Fenster, kein Eudora-Start)

`Werkzeug/pruefe-bruecke.c` ist ein Konsolenprogramm. Es lädt die Brücke,
schlägt jeden Namen mit `GetProcAddress` nach (das folgt Forwardern und lädt
dabei `msvcrt.dll` nach) und ruft danach `malloc`/`strlen`/`free` über die so
geholten Zeiger wirklich auf.

    pruefe-bruecke.exe ..\Bin\Release\msvcr71.dll Messung\benoetigt-msvcr71.txt
      geladen: ...\msvcr71.dll
      nachgeschlagen: 118 Namen, davon nicht aufloesbar: 0
      malloc/strlen/free ueber die Bruecke: strlen=7 (erwartet 7)
      Rueckgabe: 0

    pruefe-bruecke.exe ..\Bin\Release\msvcr71.dll Messung\msvcrt-exporte.txt
      nachgeschlagen: 1429 Namen, davon nicht aufloesbar: 0
      Rueckgabe: 0

**Alle 1429 Weiterleitungen lösen auf.** Es gibt keinen toten Forwarder.

### 2.6 Warum 1430 Exporte und nicht 118

Block 1 der `.def` sind die 118 gemessen benötigten Namen. Block 2 sind die
1312 übrigen, die `msvcrt.dll` ohnehin anbietet — Zugabe für Nachrüster
(fremde Eudora-Plugins, die es reichlich gab). Ein Forwarder, den niemand
importiert, wird vom Lader nie aufgelöst; er kostet nur Platz im
Exportverzeichnis. Der Vorteil ist, dass ein unerwarteter Import nicht zu
einem harten Ladefehler führt. Beide Blöcke sind in der `.def` als solche
gekennzeichnet.

### 2.7 Warnungen beim Binden

Acht `LNK4102` („Export des Löschdestruktors …`vector deleting destructor`…“)
für `exception`, `bad_cast`, `bad_typeid`, `__non_rtti_object`. Das sind
Namen aus Block 2 (Zugabe), die niemand importiert. **UNGEPRÜFT**, aber
begründet: da es reine Weiterleitungen sind und der Code in `msvcrt.dll`
liegt, ist die Warnung hier ohne Gegenstand — sie zielt auf Fälle, in denen
man einen eigenen Löschdestruktor exportiert. Wer sie loswerden will,
streicht diese acht Namen aus Block 2.

---

## 3 — Aufgabe 2: reicht die Release-`Paige32.dll` als `Paige32d.dll`?

### Antwort: Ja. Vier unabhängige Belege.

**Beleg 1 — Exportlisten Name für Name gleich.**

    dumpbin -exports Bin/Release/Paige32.dll  -> 938 Namen
    dumpbin -exports Bin/Debug/Paige32d.dll   -> 938 Namen
    Differenz in beide Richtungen: leer

**Beleg 2 — beide Importbibliotheken bieten dieselben Symbole an.**

    Lib/Release/Paige32.lib  -> 938 Symbole
    Lib/Debug/Paige32d.lib   -> 938 Symbole
    Differenz in beide Richtungen: leer

Der in der `.lib` hinterlegte DLL-Name ist `Paige32.dll` bzw. `Paige32d.dll` —
das ist der einzige Unterschied und genau der Grund, warum die Datei umbenannt
werden muss statt ersetzt.

**Beleg 3 — der entscheidende Punkt: die Strukturen unterscheiden sich nicht.**

Der Auftrag hat richtig auf `PAIGE.H` gezeigt. Nachgemessen:

- In `PAIGE.H` gibt es **keine einzige** `#ifdef _DEBUG`-Stelle. Der einzige
  Treffer ist ein Kommentar, `PAIGE.H:2169`: „The following are used only for
  PG_DEBUG“. Die fünf dort genannten Felder (`globals`, `stylerun`, `parrun`,
  `max_styles`, `max_pars`) stehen **unbedingt** in der Struktur, ohne
  `#ifdef`. Sie sind also in beiden Fassungen vorhanden.
- Paige schaltet nicht über `_DEBUG`, sondern über ein **eigenes** Makro
  `PG_DEBUG`. Das ist in `CPUDEFS.H:35` und `CPUDEFS.H:47` **auskommentiert**
  und wird in **keiner** `.vcxproj` und **keinem** Quelltext des Repositorys
  gesetzt (`grep -rn PG_DEBUG --include=*.vcxproj --include=*.h --include=*.cpp`).
- `PG_DEBUG` **würde** Strukturen verändern — `PGMEMMGR.H:158-162` hängt drei
  Felder an `pgm_globals` an. Es ist aber eben nicht gesetzt.
- `PGAFX.H` benutzt `_DEBUG`, erzeugt damit aber ausschließlich
  `#pragma comment(lib, …)`-Zeilen für MFC42. Kein Einfluss auf Datenlayout.
- Beide `Eudora.vcxproj`-Konfigurationen setzen **kein**
  `StructMemberAlignment`; die Packung ist in Debug und Release gleich.

**Beleg 4 — die Dekorierung beweist es unabhängig von den Kopfdateien.**

`pgAllocateNewRef` hat unter `PG_DEBUG` zwei zusätzliche Parameter
(`char *file, int line`, `PGMEMMGR.H:269-274`), also acht Byte mehr auf dem
Stapel. Der Export heißt in **beiden** DLLs:

    _pgAllocateNewRef@20

Unter `PG_DEBUG` müsste er `@28` heißen. Außerdem exportiert **keine** der
beiden die reinen `PG_DEBUG`-Funktionen `pgCheckAllMemoryRefs` und
`TotalPaigeMemory`. Damit ist von außen bewiesen, dass beide DLLs mit
**derselben** Konfiguration gebaut wurden.

Nebenbei: die Zeitstempel liegen 39 Sekunden auseinander
(14.10.2005, 19:44:17 und 19:44:56) — derselbe Bauvorgang.

### Was das praktisch heißt

`Eudora.vcxproj:83` bindet in Debug gegen `Paige32d.lib`, die den Namen
`Paige32d.dll` anfordert. Der Lader sucht nur nach dem **Dateinamen**; das
im Exportverzeichnis stehende `Paige32.dll` spielt für die Auflösung keine
Rolle. Eine Kopie von `Bin/Release/Paige32.dll` unter dem Namen
`Bin/Debug/Paige32d.dll` ist also zulässig.

**Kosten:** die `Paige32.pdb` passt dann nicht mehr zum Modul, man debuggt
in Paige „blind“. Für ein Auslieferungspaket ist das ohne Belang.

**Ein Startversuch ist für dieses Urteil nicht nötig.** Ich halte die vier
Belege für ausreichend; besonders Beleg 4 ist unabhängig von jeder Annahme
über die Kopfdateien.

### Braucht das Paket `msvcr71d.dll` und `msvcp71d.dll`?

**Nein — und zwar aus einem einfacheren Grund als der Umbenennung.**

Gemessen: **kein einziges** Modul unter `Eudora71/Bin/Release` importiert aus
`MSVCR71D.dll`, `MSVCP71D.dll` oder `MFC71D.DLL`. Die D-Fassungen brauchen
ausschließlich die Debug-Ausgaben unter `Bin/Debug`. Ein Auslieferungspaket
wird aus der Release-Ausgabe gebaut (`Eudora.vcxproj:110` setzt `NDEBUG`,
`Eudora.vcxproj:122` bindet `Paige32.lib`). **`msvcr71d.dll` und
`msvcp71d.dll` sind im Paket also totes Gewicht und können weg.**

Zusatzbefund: `msvcp71d.dll` wäre selbst für die Debug-Ausgabe die falsche
Begründung. `Paige32d.dll` importiert **nur** `KERNEL32`, `USER32`, `GDI32`
und `MSVCR71D` — **kein** `MSVCP71D`. Wer `msvcp71d.dll` „wegen Paige“ ins
Paket gelegt hat, hat sich geirrt. Gebraucht würde sie von den Debug-Fassungen
von `DirServ`, `Ldap`, `Ph` und den drei Plugins — die aber ohnehin an
`MFC71D.DLL` scheitern, das dem Paket nicht beiliegt.

**Falls jemand die Debug-Ausgabe doch lauffähig haben will**, gibt es zwei
Wege, beide ohne fremde Binärdateien:

1. `Bin/Release/Paige32.dll` nach `Bin/Debug/Paige32d.dll` kopieren
   (oben belegt) — dann genügt die gebaute `msvcr71.dll`.
2. Eine zweite Brücke `msvcr71d.dll` nach demselben Muster bauen.
   Machbar: von 153 Namen fehlen `msvcrt.dll` nur zwei. `__security_error_handler`
   ist schon da; für `_CRT_RTC_INIT` müsste man einen Rumpf schreiben.
   **UNGEPRÜFT und der Grund, warum ich sie nicht gebaut habe:** ich konnte den
   genauen Vertrag von `_CRT_RTC_INIT` nicht messen (es gibt keine echte
   `msvcr71d.dll` zum Nachsehen). Aus dem Gedächtnis liefert sie den Zeiger auf
   die RTC-Fehlermeldefunktion zurück; ein Rumpf müsste dann entweder `NULL`
   oder einen eigenen `cdecl`-Rumpf mit variabler Argumentliste liefern, der 0
   zurückgibt. Weg 1 ist belegt, Weg 2 wäre geraten — deshalb Weg 1.

---

## 4 — Aufgabe 3: `MFC71.DLL` und `MSVCP71.dll`

Betroffen sind nach der Messung **sieben** Module, nicht vier: `EudoraBk`,
`ISock`, `Ldap`, `Ph` **und** die drei Plugins `SMIME`, `SpamHeaders`,
`SpamWatch`.

### 4.1 `MFC71.DLL` — aussichtslos, und aus einem härteren Grund als vermutet

Die Einschätzung im Auftrag war, MFC71 sei „erst recht“ nicht zu ersetzen.
Das stimmt, aber die Begründung ist eine andere und schärfere:

**Alle MFC71-Importe laufen über Ordinale, kein einziger über einen Namen.**

    MFC71.DLL   157 verschiedene Ordinale (265, 266, 310, 314, … 6279)
    MFC71D.DLL  173 verschiedene Ordinale (267, 270, 316, 328, … 8676)

Der Auftrag hat „0 benannte aus MFC71“ gemessen und daraus geschlossen, es
gebe nichts zu tun. Tatsächlich heißt es das Gegenteil: es gibt sehr wohl
157 Bindungen, sie sind nur unsichtbar, weil sie über die Ordinalnummer
laufen. Ein Ersatz müsste **dieselbe Ordinalvergabe** treffen wie Microsofts
`MFC71.DLL` von 2003. Diese Zuordnung ist nirgends veröffentlicht und lässt
sich aus den vorliegenden Dateien nicht rekonstruieren — die importierende
Seite speichert nur die Nummer, nicht den Namen.

Dazu käme, dass MFC-Objekte (`CObject`-Ableitungen, `CString`, `CWnd`) über
die DLL-Grenze gereicht werden und ihr Speicherlayout getroffen werden müsste.

**Urteil: aussichtslos. Nicht anfangen.** Der einzige gangbare Weg für
`EudoraBk`, `ISock`, `Ldap` und die drei Plugins wäre, die Funktion
nachzubauen statt die Bibliothek.

### 4.2 `MSVCP71.dll` — technisch machbar, praktisch nicht lohnend

Die Einschätzung im Auftrag stimmt im Kern: es sind verstümmelte C++-Namen,
und `msvcrt.dll` hat dafür keinen Partner. Weiterleitung scheidet aus —
gemessen, **0 von 173** Namen finden sich in `msvcrt.dll`.

Was ich ergänzen möchte, weil es die Lage genauer beschreibt:

- **Über die sieben Fremd-DLLs allein sind es nur 17 Namen**, davon 16
  Mitglieder von `std::basic_string<char>` und ein `?_Nomemory@std@@YAXXZ`.
  Das wäre mit einer nachgebauten Struktur in der Layoutform von VC 7.1
  (SSO-Puffer 16 Byte, dann `_Mysize`, `_Myres`) durchaus zu schreiben.
- **Mit den drei Plugins sind es 173 Namen**, darunter `basic_istream`,
  `basic_ostream`, `basic_streambuf`, `locale`, `ctype<char>` und
  `ctype<wchar_t>`. Das ist keine Handarbeit mehr.
- Vor allem: **es bringt nichts.** Von den sieben Modulen, die `MSVCP71`
  brauchen, hängen sechs zusätzlich an `MFC71.DLL` (siehe 4.1). Übrig bliebe
  **einzig `Ph.dll`** — der Zugriff auf CCSO-/„Ph“-Verzeichnisserver, ein
  Protokoll aus den frühen 1990ern, das es praktisch nicht mehr gibt.

**Urteil: nicht bauen.** Aufwand hoch, ABI-Risiko hoch, Nutzen ein toter
Verzeichnisdienst. Sollte sich später herausstellen, dass `Ph.dll` doch
gebraucht wird, steht der Weg in `Messung/benoetigt-msvcp71.txt` beschrieben.

---

## 5 — Was ich beim Lesen des Auftrags nicht gefunden habe

Damit niemand danach sucht. Diese im Auftrag genannten Dateien **gibt es im
Repository nicht**:

- `ZIEL.md` — nicht vorhanden (weder im Wurzelverzeichnis noch sonst)
- `Releases/PAKETE.md` — nicht vorhanden; unter `Releases/` liegt nur `1.0/`
- Befunde `S-1` bis `S-7` in `BEFUNDE.md` — kein Treffer auf `S-1`…`S-7`;
  die Datei endet mit den Abschnitten `NP2-2`, `NP2-3` und
  „Gesamtzahl nach der Nachprüfung“
- `tools/zeilenenden-angleichen.pl` — nicht vorhanden
- `tools/ersetze-bereich.pl` — nicht vorhanden
  (vorhanden sind: `aendere-zeile.pl`, `pruefe-bytes.pl`,
  `lehren-spiegeln.pl`, `pruefstand-melden.pl`, `hooks-einrichten.sh`,
  `patches/`)

Die drei fremden Binärdateien `msvcr71.dll`, `msvcr71d.dll`, `msvcp71d.dll`
liegen ebenfalls **nicht** im Repository — ich konnte das Auslieferungspaket
also nicht gegenprüfen. Alle Aussagen über den Paketinhalt beruhen auf der
Auftragsbeschreibung.

---

## 6 — Stand und nächster Schritt

### Fertig und geprüft

- `Eudora71/VC71Bruecke/` vollständig: Quelle, beide `.def`, Erzeuger,
  Prüfprogramm, Messdaten, dieses Dokument.
- **Baut** in beiden Konfigurationen (Debug und Release) fehlerfrei.
- **Gemessen** am fertigen PE: x86, nur `KERNEL32.dll` als Abhängigkeit,
  1430 Exporte, 1429 echte Forwarder.
- **Laufzeitgeprüft**: alle 1429 Weiterleitungen lösen auf,
  `malloc`/`strlen`/`free` funktionieren über die Brücke.
- Aufgabe 2 und Aufgabe 3 sind beantwortet und belegt (Abschnitte 3 und 4).

### Angefangen, aber NICHT fertig

- **`VC71Bruecke` ist nicht in `Eudora71/Eudora.sln` eingetragen.** Ich hatte
  das Skript dafür fertig, es aber bewusst nicht mehr ausgeführt, um beim
  Zusammenführen keinen Konflikt in einer von mehreren Agenten geteilten Datei
  zu hinterlassen. Nötig sind zwei Einfügungen (die Datei ist **reines LF**,
  kein CR — byte-erhaltend arbeiten):

  1. vor der Zeile `Project(…) = "plstclnt", …` einfügen:

         Project("{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}") = "VC71Bruecke", "VC71Bruecke\VC71Bruecke.vcxproj", "{7B1E9C40-3D52-4A6E-9E1F-2C4A7150D71B}"
         EndProject

  2. am Ende von `GlobalSection(ProjectConfigurationPlatforms)` einfügen:

         {7B1E9C40-3D52-4A6E-9E1F-2C4A7150D71B}.Debug|x86.ActiveCfg = Debug|Win32
         {7B1E9C40-3D52-4A6E-9E1F-2C4A7150D71B}.Debug|x86.Build.0 = Debug|Win32
         {7B1E9C40-3D52-4A6E-9E1F-2C4A7150D71B}.Release|x86.ActiveCfg = Release|Win32
         {7B1E9C40-3D52-4A6E-9E1F-2C4A7150D71B}.Release|x86.Build.0 = Release|Win32

  Bis dahin baut man das Projekt einzeln mit dem Befehl aus 2.1.

### Nächster Schritt, wenn jemand hier weitermacht

1. **Startversuch mit der Brücke** (braucht Gregors Erlaubnis, ich durfte
   nicht): `Eudora71/Bin/Release/msvcr71.dll` neben `Eudora.exe` legen, die
   drei fremden DLLs von dll-files.com entfernen, starten. Erwartung:
   Textbearbeitung (Paige), `DirServ` und `EuMemMgr` laufen; Adressbuch,
   LDAP, `Ph` und die Plugins bleiben wegen `MFC71.DLL` außen vor — genau
   wie vorher, denn `MFC71.DLL` lag dem Paket nach Auftragsbeschreibung
   ohnehin nie bei.
2. **Am echten Auslieferungspaket nachsehen**, ob `MFC71.DLL` und
   `MSVCP71.dll` doch beiliegen. Davon hängt ab, ob Abschnitt 1.3 eine
   Verschlechterung beschreibt oder nur den Ist-Zustand.
3. `VC71Bruecke` in die Solution eintragen (siehe oben).
4. **Erst danach** über eine `msvcp71.dll`-Brücke nachdenken — und nur, wenn
   Punkt 2 ergibt, dass `MFC71.DLL` vorhanden ist. Ohne MFC71 bringt sie
   nur `Ph.dll`.

### Was ich NICHT getan habe

- Kein Eudora gestartet, kein Programm mit Fenstern, kein
  `OutputDebugString`-Mithörer. Das Prüfprogramm aus 2.5 ist ein
  Konsolenprogramm und lädt ausschließlich die eigene Brücke — **keine**
  Fremd-DLL.
- Keine bestehende Quelldatei geändert. Alle Dateien dieses Auftrags sind neu.
