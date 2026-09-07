# Was sich geändert hat

Neueste Fassung zuerst. Jede Nummer gehört genau einem Bau: **Quellstand
`7.2.0.x`** steht in `Eudora71/Version.h`, **Paketnummer `1.0.x`** in `VERSION`.
Die Bau-Kennung im Fenstertitel nennt beide plus den Commit.

> **Wer hier neu einsteigt:** [ZIEL.md](ZIEL.md) sagt, woran „fertig" gemessen
> wird, [README.md](README.md) wie man baut und startet, [BEFUNDE.md](BEFUNDE.md)
> was im Einzelnen gefunden wurde. Der Abschnitt **Wo man weitermachen kann**
> ganz unten nennt die offenen Enden mit Fundstelle.

## Noch offen (Stand 06.09.2026)

| Kennung | | |
|---|---|---|
| **E-32** | **Meldung „An unhandled exception has occurred" beim Verfassen** | Sie ist **modal** — danach lässt sich Eudora nicht einmal mehr beenden. Der Fensterbau läuft vollständig durch (`OnMessageNewMessage: fertig`); die Ausnahme kommt erst beim Anzeigen. Verdacht: `AutoCompleterListBox::KillACListBox` aus `CHeaderView::OnKillFocusTo` |
| **E-33** | *File → Exit* bringt eine Meldung statt sauber zu beenden | noch nicht untersucht |
| — | Meldung „Encountered an improper argument" beim Anzeigen mancher Nachrichten | MFCs Text für `CInvalidArgException` — kommt also nicht aus Eudora. Eine Quelle war `QCChildToolBar::GetButton` mit Index −1 (E-16, behoben); es gibt eine zweite |

## Erreicht

| | |
|---|---|
| **Kriterien 0, 1 und 3** aus [ZIEL.md](ZIEL.md) | erfüllt: Bau aus frischem Klon, Start ohne Nachinstallieren auf einem Rechner ohne Visual Studio, Mailabruf über POP3/TLS 1.3 auf Port 995 |
| **Kriterium 2** (Darstellung) | *fast* — offen bleibt „Encountered an improper argument" |
| **Kriterien 4 bis 7** (benutzbar) | **nicht erfüllt** |

> **Aus Anwendersicht hat sich am 06.09.2026 nichts verbessert.** Gregors Urteil
> zu 1.0.18: *„es crasht nicht, aber es passiert auch nichts. beenden kann ich
> es auch nicht. nichts statt crash ist auch keine verbesserung!"*
>
> Verbessert hat sich die **Ausgangslage**, nicht das Programm: die Ursache ist
> gefunden und behoben, und was übrig bleibt, ist ein einzelner benannter Punkt
> statt einer ganzen Bibliothek.

---


## 7.2.0.18 / Paket 1.0.18 — 06.09.2026 · die Ursache gefunden

**E-31 — `pg_time_t` war acht Byte breit statt vier.** Eine Zeile in
`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H:695`:

```c
typedef time_t   pg_time_t;
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
`Eudora71/PaigeDLL/PGSOURCE`, 38 C-Dateien. Der Rekursionszyklus ist dort
nachzulesen — `pgInstallFont` → `pgStyleSuperImpose` →
`target_style->procs.init(...)` (`PGDEFSTL.C:1640`).

### Die Probe

| | vorher | nachher |
|---|---|---|
| Strg-N | `ABGESTUERZT, Code 0xC0000005`, letzte Marke `NPO: vor CreateHTMLStyles` | `OnMessageNewMessage: fertig`, **Fenster steht**, Eudora läuft weiter |
| Vollständiges `CPaigeEdtView::OnCreate` im Protokoll | **kein einziges** | ja |
| *Weiterleiten* | beendet Eudora | beendet Eudora nicht mehr |

**In dieser Portierung entstand bis dahin nie ein Paige-Fenster.**

### Was danach noch offen ist

- **E-32 — die Meldung „An unhandled exception has occurred" beim Verfassen.**
  Das ist der letzte Schritt bis Kriterium 5. **Gemessen am 06.09.2026 nach der
  Behebung von E-31:** die Spur läuft jetzt **vollständig** durch —
  `OnCreateClient: vor GetSubMenu 11` → **`OnMessageNewMessage: fertig`**. Der
  Fensterbau ist also fertig; die Ausnahme kommt **danach**, beim Anzeigen.

  Der Verdacht steht: `AutoCompleterListBox::KillACListBox`
  (`AutoCompleteSearcher.cpp:548`), gerufen aus `CHeaderView::OnKillFocusTo`.
  Der Agent sah dort unter dem Debugger `0xC000041D`
  (STATUS_FATAL_USER_CALLBACK_EXCEPTION — eine Ausnahme innerhalb einer
  Fensterprozedur) und hielt es für fokusabhängig und selten. **Das stimmt
  nicht:** Gregor bekommt die Meldung bei jedem Versuch, und sie ist modal —
  deshalb lässt sich Eudora danach auch nicht mehr beenden.

  **Nächster Schritt:** Marken in `KillACListBox` und `CHeaderView::OnKillFocusTo`
  setzen, dann `tools/strg-n-pruefen.ps1 -Verzeichnis <Paket>` laufen lassen.
  Der Weg dorthin ist damit derselbe wie bei E-31, und der hat funktioniert.

- Eine Meldung „An unhandled exception has occurred" bleibt. Die Spur endet
  jetzt bei `OnCreateClient: Auswahlfelder gefüllt, jetzt die Schriftnamen` —
  danach kommen fest verdrahtete Menü-Indizes (`GetSubMenu(11)`). Sechs neue
  Marken sitzen dort
- Unter dem Debugger tritt ein zweiter, **fokusabhängiger** Fehler zutage:
  `0xC000041D` in `AutoCompleterListBox::KillACListBox+5`
  (`AutoCompleteSearcher.cpp:551`), gerufen aus `CHeaderView::OnKillFocusTo`.
  In vier Läufen ohne Debugger nicht ausgelöst
- **Der eigentliche Schlussstein wäre ein Neubau von `Paige32.dll` mit VS2022** —
  Quellen und `Paige32.vcproj` liegen vollständig vor. Dann kann keine
  Kopfdatei mehr von der Binärdatei abweichen

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

### 1. E-27: die Rekursion in Paige (der große Brocken)

**Nächste Frage:** Entsteht in dieser Portierung überhaupt jemals ein
Paige-Fenster? Bisher ist kein einziger erfolgreicher Durchlauf von
`CPaigeEdtView::NewPaigeObject` belegt. Fällt die Antwort „nein" aus, ist nicht
das Verfassen-Fenster das Problem, sondern die ganze Paige-Anbindung.

**So misst man es:** `LogLevel=32896` in die `Eudora.ini`, dann eine
Nur-Text-Nachricht öffnen — HTML geht an Internet Explorer und sagt nichts aus —
und in `eudora.log` nach `CPaigeEdtView::OnCreate` suchen.

**Werkzeug:** `tools/stapel-untersuchen.ps1`, **32-Bit-PowerShell**:

```
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File tools\stapel-untersuchen.ps1 -Exe <Paket>\Eudora.exe -Argumente "<Mailverzeichnis>"
```

Die Stapelabtastung zeigt den Zyklus und die seltenen Treffer, die hineinführen.
Eudora lässt sich dabei von außen steuern, ohne dass jemand klicken muss:
Meldungsfenster mit `WM_COMMAND`/`IDOK` schließen, dann `WM_COMMAND` mit
`ID_MESSAGE_NEWMESSAGE` (32797) an die Fensterklasse `EudoraMainWindow`.

**Was Paige angeht:** `Eudora71/PaigeDLL` enthält nur Kopfdateien und Makefiles,
keine Quellen. An der Bibliothek selbst ist nichts zu reparieren — es geht
darum, das Muster zu vermeiden, das sie nicht verträgt. Bei S-2 war das der Weg
zur Lösung.

**Noch nicht versucht:** Page Heap (`gflags /p /enable Eudora.exe /full`, als
Administrator), und ein Vergleich der Strukturgrößen
`style_info`/`font_info`/`par_info` zwischen `PAIGE.H` und dem, was die DLL von
2005 erwartet.

### 2. Die verbleibenden zwei Meldungen

- *File → Exit* bringt eine Meldung. Noch nicht untersucht
- „Encountered an improper argument" — das ist MFCs Text für
  `CInvalidArgException`, kommt also aus MFC, nicht aus Eudora. Eine bekannte
  Quelle war `QCChildToolBar::GetButton` mit Index minus 1 (E-16, behoben); es
  gibt offenbar eine zweite

### 3. Zwei Altlasten, die niemand bauen kann

- **`EuMemMgr.dll`** ist gar kein Projekt der Projektmappe — eine vorgebaute
  Binärdatei von 2005 (Version 7.0.0.9). Ausgerechnet sie löst den Aufrufstapel
  im Absturzbericht auf
- **`Paige32.dll`**, ebenfalls 2005, ohne Quellen. Beide holen `malloc`/`free`
  aus `MSVCR71` — das sind **zwei getrennte Halden** neben der UCRT von
  `Eudora.exe`. Speicher, der über diese Grenze gereicht wird, ergibt
  `0xC0000374`

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
