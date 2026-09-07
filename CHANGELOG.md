# Was sich geändert hat

Neueste Fassung zuerst. Jede Nummer gehört genau einem Bau: **Quellstand
`7.2.0.x`** steht in `Eudora71/Version.h`, **Paketnummer `1.0.x`** in `VERSION`.
Die Bau-Kennung im Fenstertitel nennt beide plus den Commit.

> **Wer hier neu einsteigt:** [ZIEL.md](ZIEL.md) sagt, woran „fertig" gemessen
> wird, [README.md](README.md) wie man baut und startet, [BEFUNDE.md](BEFUNDE.md)
> was im Einzelnen gefunden wurde. Der Abschnitt **Wo man weitermachen kann**
> ganz unten nennt die offenen Enden mit Fundstelle.

## Noch offen (Stand 07.09.2026)

| Kennung | | |
|---|---|---|
| **E-33** | *File → Exit* bringt eine Meldung statt sauber zu beenden | noch nicht untersucht. Nach der Behebung von E-32 neu zu messen: bis dahin verdeckte die modale Meldung aus E-32 alles Weitere |
| — | Meldung „Encountered an improper argument" beim Anzeigen mancher Nachrichten | MFCs Text für `CInvalidArgException` — kommt also nicht aus Eudora. Eine Quelle war `QCChildToolBar::GetButton` mit Index −1 (E-16, behoben); es gibt eine zweite |
| — | **Ob der Anwender das Verfassen-Fenster sieht** | der Fensterbau läuft im Protokoll durch (`OnMessageNewMessage: fertig`) und E-32 ist behoben; auf einem Rechner hat das niemand nachgesehen. Daran hängen Kriterium 5 und 6 |

## Erreicht

| | |
|---|---|
| **Kriterien 0, 1 und 3** aus [ZIEL.md](ZIEL.md) | erfüllt: Bau aus frischem Klon, Start ohne Nachinstallieren auf einem Rechner ohne Visual Studio, Mailabruf über POP3/TLS 1.3 auf Port 995 |
| **Kriterium 2** (Darstellung) | *fast* — offen bleibt „Encountered an improper argument" |
| **Kriterien 4 bis 7** (benutzbar) | **nicht erfüllt** |
| **E-31 und E-32** | behoben, aber **von Gregor nicht nachgemessen** — und nicht in Paket 1.0.18 |

> **Aus Anwendersicht hat sich am 06.09.2026 nichts verbessert.** Gregors Urteil
> zu 1.0.18: *„es crasht nicht, aber es passiert auch nichts. beenden kann ich
> es auch nicht. nichts statt crash ist auch keine verbesserung!"*
>
> Verbessert hat sich die **Ausgangslage**, nicht das Programm: bis dahin
> entstand in dieser Portierung kein einziges Paige-Fenster, und die Ursache war
> unbekannt. Jetzt ist sie gefunden und behoben. Ob daraus für den Anwender ein
> benutzbares Verfassen-Fenster wird, entscheidet der nächste Lauf auf seinem
> Rechner.

---

## Nach 7.2.0.18 — 07.09.2026 · noch nicht gebaut, noch nicht gepackt

Diese Änderungen liegen im Repo, aber in **keinem** Paket. Wer sie sehen will,
muss bauen. `Eudora71/Version.h` und `VERSION` stehen weiter auf 7.2.0.18 /
1.0.18 — wer daraus ein Paket schnürt, setzt beide Nummern vorher hoch, sonst
tragen zwei verschiedene Bauten dieselbe Kennung.

- **E-32 behoben — die modale Meldung „An unhandled exception has occurred"
  beim Verfassen.** `CHeaderView::OnKillFocusRecipient` in
  `Eudora71/Eudora/headervw.cpp` dereferenzierte `pField`, obwohl die Abfrage
  drei Zeilen darüber ausdrücklich mit NULL rechnet (`if (pField && …)`).
  `GetDlgItem` liefert NULL, solange das Kopfzeilenfeld nicht existiert — und
  `OnKillFocusTo` läuft während `LoadFrame`, also bevor die Felder da sind.
  Weil der Zugriff **innerhalb einer Fensterprozedur** passiert, meldet Windows
  `0xC000041D` (STATUS_FATAL_USER_CALLBACK_EXCEPTION) statt des üblichen
  Zugriffsfehlers. Dieselbe Fehlerklasse wie E-18 und E-22.
  **Von Gregor nicht nachgemessen**
- **`tools/doku-pruefen.pl`** prüft die Dokumentation mechanisch gegen sich
  selbst und gegen den Quellstand: Kriterienzahl gegen `ZIEL.md`, doppelt
  vergebene Befundkennungen, Statuswidersprüche im Verzeichnis von
  `BEFUNDE.md`, Verweise ins Leere, und ob eine Datei eine ältere Fassung als
  den Quellstand behauptet. Auf Gregors Ansage *„ich traue dir nicht ganz,
  jemand soll dich immer wieder überprüfen — das bin aber nicht ich!"*
- **Doku-Durchgang L-7** (`Befunde/LEKTOR-3.md`) — die falschen und veralteten
  Werte in `README.md`, `ZIEL.md`, `WEITERMACHEN.md`, `AUFGABEN.md`,
  `CHANGELOG.md`, `PORTIERUNG.md` und `Releases/PAKETE.md`, ausgelöst von
  Gregors Ansage *„ich hasse es, wenn in den dokus falsche oder veraltete infos
  und werte stehen"*

---

## 7.2.0.18 / Paket 1.0.18 — 06.09.2026 · die Ursache gefunden

**E-31 — `pg_time_t` war acht Byte breit statt vier.** Eine Zeile im
Windows-Zweig von `Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H` (`grep -n pg_time_t`):

```c
typedef time_t   pg_time_t;      /* vorher */
typedef long     pg_time_t;      /* nachher */
```

`time_t` war unter VC6/VC7.1 **vier** Byte breit, unter VS2022 ist es **acht**.
`Paige32.dll` stammt von 2005 und rechnet mit vier. `pg_time_t` steckt in
`style_info` und fünfmal in `pg_doc_info` — und damit in `pg_globals` und in
`paige_rec`. **Jede** Struktur, die Eudora an Paige reichte, war verschoben.

Gemessen mit einem 32-Bit-Programm, das die ausgelieferte DLL lädt,
`pgMemStartup`/`pgInit` auf einen genullten Puffer ruft und darin die Adressen
der exportierten Standardprozeduren sucht:

| Feld in `pg_globals` | die DLL sagt | VS2022 rechnete | nachher |
|---|---|---|---|
| `def_style.procs.init` | 524 | **536** | 524 |
| `def_par.procs.line_proc` | 1300 | **1316** | 1300 |
| `def_hooks` | 1360 | **1376** | 1360 |
| `sizeof(style_info)` | 292 | **304** | 292 |

Alle 30 Zeiger in `def_hooks` und alle 17 in `def_style.procs` lösen sich danach
lückenlos auf. Kein `/Zp`, kein `#pragma pack` im Spiel — `time_t` ist der
einzige Typ in `PGHEADER`, dessen Breite sich geändert hat.

**Damit erklärt sich, warum die sieben Vermutungen aus 7.2.0.17 nichts
brachten:** `PgGlobals::InitFonts` schrieb mit `memcpy(&def_style, &styleInfo,
304)` zwölf Byte über die Struktur hinaus — bei jedem Start. Und
`pPg->user_refcon = (long)pSB` landete 20 Byte neben dem echten Feld. Beides
passiert, **bevor** der verdächtigte `pgNewNamedStyle` überhaupt gerufen wird.

**Zwei Annahmen der Vorarbeit waren falsch.** Es *gibt* Paige-Quellen:
`Eudora71/PaigeDLL/PGSOURCE`, **37** `.C`-Dateien (nachgezählt am 07.09.2026 —
`git ls-files Eudora71/PaigeDLL/PGSOURCE` liefert 38 Einträge, davon einer
`.SBT`). Der Rekursionszyklus ist dort nachzulesen — `pgInstallFont` →
`pgStyleSuperImpose` → `target_style->procs.init(...)` (`PGDEFSTL.C:1640`).

### Die Probe

| | vorher | nachher |
|---|---|---|
| Strg-N | `ABGESTUERZT, Code 0xC0000005`, letzte Marke `NPO: vor CreateHTMLStyles` | `OnMessageNewMessage: fertig`, **Fenster steht**, Eudora läuft weiter |
| Vollständiges `CPaigeEdtView::OnCreate` im Protokoll | **kein einziges** | ja |
| *Weiterleiten* | beendet Eudora | beendet Eudora nicht mehr |

**In dieser Portierung entstand bis dahin nie ein Paige-Fenster.**

### Was danach noch offen war

> **Nachtrag 07.09.2026: E-32 ist behoben.** Der unten festgehaltene Verdacht
> traf den Ort, aber nicht die Ursache. Es war nicht
> `AutoCompleterListBox::KillACListBox` selbst, sondern der **ungeprüfte
> Zeiger auf dem Weg dorthin**: `CHeaderView::OnKillFocusRecipient` in
> `Eudora71/Eudora/headervw.cpp` dereferenzierte `pField`, obwohl die Abfrage
> drei Zeilen darüber ausdrücklich mit NULL rechnet. `GetDlgItem` liefert NULL,
> solange das Kopfzeilenfeld nicht existiert — und `OnKillFocusTo` läuft
> während `LoadFrame`, also bevor die Felder da sind. Dieselbe Fehlerklasse wie
> E-18 und E-22. **Von Gregor nicht nachgemessen.**

- **E-32 — die Meldung „An unhandled exception has occurred" beim Verfassen.**
  Das ist der letzte Schritt bis Kriterium 5. **Gemessen am 06.09.2026 nach der
  Behebung von E-31:** die Spur läuft jetzt **vollständig** durch —
  `OnCreateClient: vor GetSubMenu 11` → **`OnMessageNewMessage: fertig`**. Der
  Fensterbau ist also fertig; die Ausnahme kommt **danach**, beim Anzeigen.

  Der Verdacht am 06.09.2026: `AutoCompleterListBox::KillACListBox`
  (`AutoCompleteSearcher.cpp:548`), gerufen aus `CHeaderView::OnKillFocusTo`.
  Der Agent sah dort unter dem Debugger `0xC000041D`
  (STATUS_FATAL_USER_CALLBACK_EXCEPTION — eine Ausnahme innerhalb einer
  Fensterprozedur) und hielt es für fokusabhängig und selten. **Das stimmte
  nicht:** Gregor bekam die Meldung bei jedem Versuch, und sie war modal —
  deshalb ließ sich Eudora danach auch nicht mehr beenden.

- Unter dem Debugger trat dieselbe Ausnahme als scheinbar zweiter,
  **fokusabhängiger** Fehler zutage: `0xC000041D` in
  `AutoCompleterListBox::KillACListBox+5` (`AutoCompleteSearcher.cpp:551`),
  gerufen aus `CHeaderView::OnKillFocusTo`. In vier Läufen ohne Debugger nicht
  ausgelöst — das war irreführend, es ist E-32
- **Der eigentliche Schlussstein wäre ein Neubau von `Paige32.dll` mit VS2022** —
  Quellen (`PGSOURCE`, 37 `.C`-Dateien) und `PAIGE32/Paige32.vcproj` liegen
  vor. Dann kann keine Kopfdatei mehr von der Binärdatei abweichen

### Neue Werkzeuge

`tools/strg-n-pruefen.ps1` startet Eudora, klickt Meldungen weg, schickt Strg-N
und sagt, ob das Fenster aufgeht — ohne dass jemand danebensitzt.
`tools/befehl-schicken.ps1` schickt einen beliebigen Menübefehl. Beide beenden
nur Eudora-Prozesse aus dem angegebenen Testverzeichnis.

## 7.2.0.17 / Paket 1.0.17 — 06.09.2026 · nicht ausgeliefert

Reine Messfassung. Zweck war, E-27 einzukreisen. **Das ist gelungen, die
Behebung nicht.**

### Der Absturz ist gemessen, nicht mehr vermutet

Eudora unter `tools/stapel-untersuchen.ps1` gestartet, Strg-N per `WM_COMMAND`
geschickt:

```
AUSNAHME 0xC00000FD   (STATUS_STACK_OVERFLOW)
EIP  Paige32.dll  pgInstallFont

Zyklus aus der Stapelabtastung:
    527 x  Eudora.exe   PgSharedAccess::pgGlobals
    526 x  Paige32.dll  pgInstallFont + 77
    525 x  pgDeleteTextProc / pgCopyTextProc / pgDeleteStyleProc /
           pgAlterStyleProc / pgSaveStyleProc / pgBytesToUnicode
Weg hinein:  pgLocateStyleSheet -> pgStyleSuperImpose -> pgInstallFont
```

Eine **Endlosrekursion rund 525 Windungen tief**, in der Fremdbibliothek
`Paige32.dll` (Binärdatei von 2005, keine Quellen im Repo). Jede Windung
schiebt eine Kopie von Eudoras Paige-Globals auf den Stapel.

Damit ist auch erklärt, **warum nie ein `Exception.log` entstand**: ein voller
Stapel lässt keinen Platz mehr, den Absturzbehandler auszuführen. Dieselbe
Fehlerklasse wie Befund S-2 vom 30.08.2026, wo Paige an einer Fläche der Größe
null in dieselbe Falle lief.

### Sieben Vermutungen, alle durch Versuch widerlegt

Jede einzeln gebaut, gestartet, gemessen — **keine** hat den Absturz beseitigt:

| Vermutung | Messung |
|---|---|
| Umgestülptes Client-Rechteck | gemessen `Rect=8,2,2,598`, Breite **minus 6**; begradigt, stürzt weiter ab |
| Zu kleine Anfangsgröße der Ansicht | mit `CSize(400,600)` gesundes `8,2,375,598`, stürzt weiter ab |
| `parInfo`/`parMask` nicht vorbelegt | genullt, stürzt weiter ab |
| Reihenfolge der beiden `CreateView` | getauscht, stürzt weiter ab |
| Veralteter `styleInfo.font_index` | auf 0 gesetzt, stürzt weiter ab |
| **`pgNewNamedStyle` selbst** | **ganz übersprungen, stürzt weiter ab** |
| Eine bestimmte Einstellung | frische `Eudora.ini` aus dem Paket, stürzt weiter ab |

Der vorletzte Punkt wiegt am schwersten: es liegt **nicht an diesem einen
Aufruf**, sondern am Anlegen benannter Stile überhaupt — `CreateHTMLStyles` tut
über `make_style` dasselbe und stirbt genauso.

### Eine Annahme, die sich als falsch erwies

Die HTML-Nachricht im Vorschaufenster wird von **Internet Explorer** gezeichnet
(Fensterklasse `Internet Explorer_Hidden`), nicht von Paige. Dass sie korrekt
erscheint, beweist also **nicht**, dass Paige funktioniert. Möglich ist, dass in
dieser Portierung noch nie ein Paige-Fenster erfolgreich entstanden ist — das
ist die nächste zu klärende Frage.

### Behalten, weil unabhängig davon richtig

- `PaigeEdtView.cpp`: umgestülptes Rechteck wird begradigt, `parInfo` und
  `parMask` werden vorbelegt. Die Datei hält sich an zwei anderen Stellen selbst
  an diese Regel — nur hier fehlte es
- `tools/stapel-untersuchen.ps1`: `[IntPtr][int]` lief bei Stapeladressen über
  `0x7FFFFFFF` über und brach die Auswertung ab. Neu dazu eine
  **Stapelabtastung**, weil die EBP-Kette bei Paige nichts taugt — die DLL ist
  ohne Rahmenzeiger übersetzt und lieferte genau zwei Rahmen
- `tools/bauen.ps1`: die Artefaktprüfung verglich jede Datei mit der jüngsten
  Quelle im **ganzen** Baum und meldete `EuLang.dll` und `msvcr71.dll` deshalb
  fälschlich als veraltet. Jetzt projektbezogen

## 7.2.0.16 / Paket 1.0.16 — 06.09.2026 · zurückgezogen

**Fror beim Start ein.** Eigenes Versehen: das Einsetzmuster für die Spurmarken
traf `UnuseMemory( m_paigeRef );`, und diese Zeile kommt **17-mal** in
`PaigeEdtView.cpp` vor, auch in den Zeichenroutinen. Jede Bildwiederholung
schrieb ins Protokoll.

> **Lehre:** Ein Einsetzmuster mit mehr Treffern als erwartet wird gezählt,
> bevor es angewandt wird. 29 statt 12 hätte auffallen müssen.

## 7.2.0.15 / Paket 1.0.15 — 06.09.2026

Messfassung mit feineren Spurmarken um beide `CreateView` im Verfassen-Fenster.
Ergebnis: `CHeaderView` läuft sauber durch, der Absturz liegt im Anlegen der
Paige-Ansicht.

**Wichtig für eigene Messungen:** Die Spurmarken schreiben nur, wenn in
`Mailverzeichnis\Eudora.ini` unter `[Settings]` steht:

```
LogLevel=32896
```

`PutDebugLog` prüft diese Maske und kehrt sonst sofort zurück
(`QCUtils/src/debug.cpp:140`). 32896 = `DEBUG_MASK_MISC` (0x8000) +
`DEBUG_MASK_TOC_CORRUPT` (0x80).

## 7.2.0.14 / Paket 1.0.14 — 06.09.2026

Erste Fassung, in der Gregor mehrere Behebungen bestätigt hat.

- **E-30 — Symbole der Werkzeugleiste.** Gesperrte Knöpfe zeigten eine leere
  graue Fläche. Ursache: die sechs Bitmaps der Hauptleiste sind **24 Bit** und
  haben damit keine Farbtabelle, die `CreateMappedBitmap` umsetzen könnte. Das
  Buttongrau `192,192,192` blieb stehen, während `COLOR_BTNFACE` heute
  `240,240,240` ist; die Maske erfasste dadurch das ganze Bildrechteck. Die
  8-Bit-Bitmaps der Nachrichtenfenster waren nie betroffen — das erklärt, warum
  nicht *alle* Symbole fehlten. Unter VC6 war die Systemfarbe selbst
  `192,192,192`, deshalb fiel es nie auf. Behoben in
  `OTShim/OTShim_Werkzeugleiste.cpp`, dazu `tools/pruefe-symbole.pl` und
  `Eudora71/Tests/TestSymbole.cpp`
- **E-28 — Doppelklick und Suchtreffer öffneten nichts.**
  `CSummary::m_FrameWnd` blieb als Zeiger auf einen zerstörten Rahmen stehen:
  `CMessageFrame::ActivateFrame` setzt ihn bedingungslos, `OnDestroy` löschte
  ihn nur **innerhalb** von `if (m_InitialSize != wp.rcNormalPosition)` — also
  nur, wenn das Fenster verschoben oder in der Größe geändert wurde
- **`dbghelp.dll` von 2005 entfernt.** Sie lag seit dem ersten Commit in
  `Eudora71/Bin/Release` und verdeckte die aktuelle aus `SysWOW64`. Am
  05.09.2026 stürzte der Absturzbehandler **in ihr** ab — genau dann, wenn er
  gebraucht wird. Wiederherstellbar aus `567a5d8`
- `paket-bauen.ps1` legt `Eudora starten.cmd` jetzt selbst ins Paket. Im ersten
  Anlauf fehlte sie; `paket-pruefen.ps1` hat es gemeldet

## 7.2.0.13 / Paket 1.0.13 — 06.09.2026 · übersprungen

Gebaut und geprüft, aber nie ausgeliefert — E-30 kam dazwischen. Die Nummer
bleibt verbrannt, damit keine zwei Bauten dieselbe tragen.

- **E-26 — der Absturzbericht nennt die Ladeadresse jedes Moduls.** Ohne sie war
  keine Zeile des Aufrufstapels einem Funktionsnamen zuzuordnen: Windows lädt
  `Eudora.exe` verschoben (ASLR), und `Exception.log` schrieb die tatsächliche
  Basis nicht mit. Ein Versuch, gegen die vorgesehene `0x00400000` zu rechnen,
  lieferte prompt einen Namen aus dem Ressourcenbereich
- **E-29 — `tools/absturz-auswerten.pl`**, 15 Selbsttests. Macht aus
  `Exception.log` Funktionsnamen und sagt bei älteren Berichten ausdrücklich,
  dass es **nicht** geht, statt zu raten
- **E-27, erster Teil** — die drei stillen Fehlerklassen werden protokolliert:
  `_set_invalid_parameter_handler`, `_set_purecall_handler`, `set_terminate`.
  Der Absturzbehandler hing nur an `SetUnhandledExceptionFilter`, und vier Wege
  gehen daran vorbei
- `Eudora.vcxproj` erzeugt bei jedem Bau `Eudora71/Bin/Release/Eudora.map`

## 7.2.0.10 / Paket 1.0.10 — 05.09.2026

Die Fassung, mit der **Kriterium 0** belegt wurde: von Gregor am 06.09.2026 auf
einem Rechner ohne Visual Studio ausgepackt und gestartet.

- **E-23** — POP3 fiel nicht mehr still auf Port 110 zurück; TLS-Fehler werden
  gemeldet statt verschluckt. Damit lief erstmals Port 995 mit TLS 1.3
- **E-24** — „In" stand zweimal unter *Recent*
- **E-22** — ungeprüfte Zeiger im Aufbau des Nachrichtenfensters
- **E-18, E-19** — zwei Fehler, die erst mit einer zweiten Persönlichkeit
  auftreten

## 7.2.0.3 / Paket 1.0.3 — 31.08.2026

Erster Release-Bau, der Mail abruft: 159 Nachrichten über POP3 Port 110 mit
STARTTLS.

## Paket 1.0.2 — 30.08.2026

Eudora startet und zeigt sein Hauptfenster — erstmals seit Beginn der
Portierung. Möglich wurde das durch **S-2**: die Werbefläche wurde mit
`CRect(0,0,0,0)` angelegt, Paige bekam eine Umbruchbreite von null und
verhedderte sich in einer Endlosrekursion.

## Paket 1.0.1 — 30.08.2026

Erstes Paket überhaupt. Die Dateinamen `…-lauffaehig.zip` von 1.0.1 und 1.0.2
behaupten mehr, als die Fassungen konnten; sie bleiben stehen, weil die Pakete
unter diesen Namen samt Prüfsumme veröffentlicht sind.

---

## Wo man weitermachen kann

Die offenen Enden mit Fundstelle — für jemanden, der das Repo frisch klont.
**Stand 07.09.2026.**

### 1. Ob das Verfassen-Fenster für den Anwender sichtbar wird

Daran hängen Kriterium 5 und 6, und es ist **nicht gemessen**. E-31 und E-32
sind behoben, der Fensterbau läuft im Protokoll vollständig durch
(`OnMessageNewMessage: fertig`) — gesehen hat das Fenster niemand.

**So misst man es:** `LogLevel=32896` in die `Eudora.ini`, Eudora starten,
Strg-N, danach in `eudora.log` nach `CPaigeEdtView::OnCreate` und
`OnMessageNewMessage: fertig` suchen. Ohne dass jemand danebensitzt:

```
powershell -ExecutionPolicy Bypass -File tools\strg-n-pruefen.ps1 -Verzeichnis <Paket>
```

Das Werkzeug startet Eudora, klickt Meldungen weg, schickt Strg-N und sagt, ob
das Fenster aufgeht.

**Unter dem Debugger**, 32-Bit-PowerShell:

```
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File tools\stapel-untersuchen.ps1 -Exe <Paket>\Eudora.exe -Argumente "<Mailverzeichnis>"
```

Eudora lässt sich dabei von außen steuern, ohne dass jemand klicken muss:
Meldungsfenster mit `WM_COMMAND`/`IDOK` schließen, dann `WM_COMMAND` mit
`ID_MESSAGE_NEWMESSAGE` (32797) an die Fensterklasse `EudoraMainWindow`.

**Was Paige angeht:** `Eudora71/PaigeDLL` enthält **doch** Quellen — `PGSOURCE`
mit 37 `.C`-Dateien, dazu `PAIGE32/Paige32.vcproj` und die alten Makefiles. Bis
zum 06.09.2026 stand an dieser Stelle das Gegenteil, und das hat die Suche nach
E-31 unnötig lange aufgehalten. Der Rekursionszyklus ist dort nachzulesen
(`PGDEFSTL.C:1640`). **Der eigentliche Schlussstein wäre ein Neubau von
`Paige32.dll` mit VS2022** — dann kann keine Kopfdatei mehr von der Binärdatei
abweichen, und genau diese Abweichung war E-31.

**Noch nicht versucht:** Page Heap (`gflags /p /enable Eudora.exe /full`, als
Administrator).

### 2. Die verbleibenden zwei Meldungen

- **E-33** — *File → Exit* bringt eine Meldung statt sauber zu beenden. Noch
  nicht untersucht, und nach der Behebung von E-32 neu zu messen: bis dahin
  verdeckte die modale Meldung aus E-32 alles Weitere
- „Encountered an improper argument" — das ist MFCs Text für
  `CInvalidArgException`, kommt also aus MFC, nicht aus Eudora. Eine bekannte
  Quelle war `QCChildToolBar::GetButton` mit Index minus 1 (E-16, behoben); es
  gibt offenbar eine zweite

### 3. Die Altlast, die niemand bauen kann

- **`EuMemMgr.dll`** ist gar kein Projekt der Projektmappe — eine vorgebaute
  Binärdatei von 2005 (Version 7.0.0.9). Ausgerechnet sie löst den Aufrufstapel
  im Absturzbericht auf. Sie holt `malloc`/`free` aus `MSVCR71`, hat damit eine
  **eigene Halde** neben der UCRT von `Eudora.exe`, und Speicher, der über diese
  Grenze gereicht wird, ergibt `0xC0000374`. Für `Paige32.dll` gilt dasselbe —
  dort liegen aber Quellen vor (siehe 1.)

### 4. Was beim Mitarbeiten hilft

- `AGENTEN.md` — wie parallele Arbeit koordiniert wird, aus fünf gemessenen
  Kollisionen
- `Arbeitsweise/` — die Lehren aus diesem Projekt, eine Datei je Lehre
- `tools/pruefe-bytes.pl` — die Quellen sind Latin-1 mit gemischten
  Zeilenenden; ein Werkzeug, das das zerstört, fällt erst Wochen später auf
- `tools/paket-pruefen.ps1` — prüft ein Paket über die PE-Importtabellen gegen
  Kriterium 0 und wertet einen Treffer in `SysWOW64` ausdrücklich **nicht** als
  erfüllt
- `tools/bauen.ps1` — baut und meldet Erfolg nur, wenn vier unabhängige
  Prüfungen zustimmen. MSBuild kann 0 zurückgeben und trotzdem nichts gebaut
  haben
