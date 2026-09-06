# E-27 — Strg-N beendet Eudora lautlos

Agent VERFASSER, 06.09.2026. Zweig `wt/verfasser`.

> „Strg-N (neue Nachricht verfassen) beendet Eudora lautlos, ohne jede Meldung.
> Kein Dialog, kein Absturzfenster — das Programm ist einfach weg."

**Kurzfassung, ehrlich getrennt:**

| | |
|---|---|
| **Gemessen** | Warum ein Absturz in dieser Fassung *lautlos* sein kann: es gibt vier Wege, auf denen der Prozess stirbt, **ohne** dass der vorhandene Absturzbehandler jemals läuft. Drei davon habe ich abgestellt, einer ist prinzipiell nicht abstellbar. |
| **Gemessen** | Der einzige Absturzbericht, der auf diesem Rechner liegt (`Exception.log`, 7.2.0.12), gehört **nicht** zu Strg-N, sondern zum **Suchfenster**. Die Auswertung im Auftrag („`<UNKNOWN>` = beschädigte vtable im Verfassen-Weg") war eine Fehlzuordnung. |
| **Gemessen** | Am 05.09. um 22:43 starb Eudora 7.2.0.10 **zweimal innerhalb von elf Sekunden** mit `0xC0000374` = `STATUS_HEAP_CORRUPTION`. Das ist genau das Bild „ohne jede Meldung". |
| **Gemessen** | Um 22:46 stürzte beim nächsten Versuch der **Absturzbehandler selbst** ab — in `Bin\Release\dbghelp.dll`, Fassung **6.4.7.1 von 2005**. Danach gibt es weder Fenster noch Protokoll. |
| **Nicht gefunden** | Die eine Zeile im Verfassen-Weg, die den Speicher beschädigt. Ich habe sie nicht. Was ich ausgeschlossen habe, steht in Abschnitt 5. |
| **Geliefert** | Ein Bau, nach dem der nächste Strg-N-Versuch **sagt, wo er stehenbleibt** — Spurmarken in `eudora.log` und drei neue Haken, die die stillen Fehlerklassen in einen richtigen Bericht verwandeln. Anleitung in Abschnitt 6. |

---

## 1. Warum ein Absturz hier lautlos sein kann — vier Wege

Der Absturzbehandler von Eudora (`QCExceptionHandler`, `ExceptionHandler.cpp`)
wird über `SetCrashHandlerFilter` angemeldet. Das ist die BugslayerUtil-Fassung
aus `EuMemMgr.dll` und setzt nichts weiter als `SetUnhandledExceptionFilter`.
**Alles, was an diesem Filter vorbeigeht, hinterlässt keine `Exception.log` und
kein Fenster.** Es gibt vier solche Wege:

| Weg | Was passiert | Sichtbar in | abstellbar? |
|---|---|---|---|
| `0xC0000374` **Heap-Beschädigung** | Der Windows-Heap ruft `RtlFailFast`. Kein Filter läuft. | nur Windows-Ereignisprotokoll | **nein** |
| `0xC0000409` **/GS-Stapelwächter** | `__report_gsfailure` ruft `__fastfail`. Kein Filter läuft. | nur Ereignisprotokoll | **nein** |
| **Ungültiges Argument an die C-Laufzeit** | UCRT ruft `_invoke_watson` → sofortiges Ende | gar nichts | **ja, jetzt behoben** |
| **`std::terminate` / pure-virtual-call** | `abort()` — im Release-Bau eines Fensterprogramms ohne Meldung | gar nichts | **ja, jetzt behoben** |

Beleg für den dritten Weg, im Quelltext der ausgelieferten UCRT
(`C:\Program Files (x86)\Windows Kits\10\Source\10.0.22621.0\ucrt\misc\invalid_parameter.cpp`,
Ende von `_invalid_parameter_internal`):

```cpp
    _invalid_parameter_handler const global_handler = ...;
    if (global_handler) { global_handler(...); return; }

    _invoke_watson(expression, function_name, file_name, line_number, reserved);
```

Ohne angemeldeten Haken ist der Prozess an dieser Stelle weg. **Unter VC6 gab
es diesen Mechanismus überhaupt nicht** — die alte Laufzeit gab einen
Fehlercode zurück. Das ist eine Fehlerklasse, die die Portierung erst
hergestellt hat.

### 1a. Ein Haken, der seit der Portierung ins Leere greift

`QCExceptionHandler::EnableBufferOverflowHandler` ruft
`_qc_set_security_error_handler(SecurityErrorHandler)`. Diese Funktion stammt
aus `MSVCR71` (heute über `VC71Bruecke` an `msvcrt.dll` weitergeleitet). Ab
Visual C++ 8 gibt es `_set_security_error_handler` nicht mehr; die Laufzeit von
VS 2022 ruft **niemals** dorthin. `SecurityErrorHandler` und
`GenerateBufferOverflowReport` sind seit der Portierung toter Code. Ein
/GS-Überlauf hinterlässt seither nichts als einen Eintrag im
Windows-Ereignisprotokoll. Genau so einen gibt es: 05.09.2026 19:22:02,
Eudora.exe 7.2.0.4, `0xc0000409`.

---

## 2. Der vorhandene Absturzbericht gehört zum Suchfenster, nicht zu Strg-N

Auf diesem Rechner liegt genau **eine** `Exception.log`:
`C:\Users\Gregor\Eudora72-1.0.12-release\Mailverzeichnis\Exception.log`,
06.09.2026 00:32:43, Fassung 7.2.0.12:

```
Eudora.exe caused an EXCEPTION_ACCESS_VIOLATION in module
<UNKNOWN> at 0023:414E3345
```

Der Auftrag deutet das als „übersprungener Funktionszeiger im Verfassen-Weg".
**Das stimmt nicht.** So ist es auszurechnen:

**Ladeadresse.** Eudora.exe wird verschoben geladen (ASLR). Sie steht im
Bericht selbst: der Rahmen `6FBADF14 (0x00770000 ...)` ist `AfxWinMain`, und
`0x00770000` ist dessen `hInstance` — also die Ladeadresse. Gegenprobe mit drei
weiteren Rahmen, aufgelöst gegen
`Eudora7.2/Eudora71/Bin/Release/Eudora.map` (Vorzugsbasis `0x00400000`,
Rechnung: `Kartenadresse = Stapeladresse − 0x00770000 + 0x00400000`):

| Stapeladresse | Karte | Name | plausibel? |
|---|---|---|---|
| `0x0093 3FFC` | `0x005C3FFC` | `post_pgo_initialization` (`exe_winmain.obj`) | ja, unterster Rahmen vor `BaseThreadInitThunk` |
| `0x007B C0C7` | `0x0044C0C7` | `CEudoraApp::Run` +0x1A | ja, darüber `mfc140!CWinThread::Run` |
| `0x007B BF88` | `0x0044BF88` | `CEudoraApp::PreTranslateMessage` +0x10C | ja, darüber `mfc140!PumpMessage` |

Drei unabhängige Treffer, alle an der richtigen Stelle der Aufrufkette. Damit
ist die Basis belegt. Und damit gilt für die obersten Rahmen:

| Stapeladresse | Karte | **Name** |
|---|---|---|
| `0x0089 4B53` | `0x00524B53` | **`CSearchView::ResizeControls` +0x1EC** (`SearchView.obj`) |
| `0x0089 62D7` | `0x005262D7` | **`CSearchView::OnMsgListRightClick` +0x272** |
| `0x007F 1CDB` | `0x00481CDB` | **`CListCtrlEx::MeasureItem` +0x57** |

Dazu passt das Ende von `eudora.log` derselben Sitzung:

```
MAIN    16: 4.04 Searching...
MAIN    16: 4.04 Displaying Search Results...
```

und der WER-Bericht zu demselben Absturz, `Ausnahmedaten=00000008` — das ist
ein **Ausführungs**-Zugriffsfehler, also tatsächlich ein Sprung auf eine
Adresse, an der kein Code liegt. Aber im **Suchfenster**, beim Anzeigen der
Treffer.

> **Das ist Gregors Fehler 3 („Suchtreffer lassen sich nicht anklicken"), nicht
> Fehler 1.** Wer an Strg-N arbeitet, darf sich von diesem Bericht nicht leiten
> lassen.

*Einschränkung:* die benutzte `Eudora.map` stammt vom Bau um 12:12 desselben
Tages, die abgestürzte `Eudora.exe` vom Bau um 00:15 (1024 Byte kleiner, E-26
kam dazwischen). Verschöbe sich der Code, lägen die drei Gegenproben oben nicht
so sauber. Beweisend ist das nicht, aber tragfähig.

---

## 3. Was das Ereignisprotokoll über die stillen Abgänge sagt

Gemessen heute mit
`Get-WinEvent -FilterHashtable @{LogName='Application'; Id=1000}` und den
`Report.wer`-Dateien unter `C:\ProgramData\Microsoft\Windows\WER\ReportArchive`:

| Zeitpunkt | Fassung | Ausnahme | Fehlermodul | Bedeutung |
|---|---|---|---|---|
| 05.09. 19:22:02 | 7.2.0.4 | **`0xC0000409`** | Eudora.exe | fail-fast (/GS oder `abort`) — **lautlos** |
| 05.09. 22:43:06 | 7.2.0.10 | **`0xC0000374`** | ntdll +0xe6dc3 | **Heap-Beschädigung — lautlos** |
| 05.09. 22:43:17 | 7.2.0.10 | **`0xC0000374`** | ntdll +0xe6dc3 | dasselbe, 11 s später |
| 05.09. 22:46:34 | 7.2.0.10 | `0xC0000005` | **`Bin\Release\dbghelp.dll` 6.4.7.1** | **der Absturzbehandler selbst stürzt ab** |
| 06.09. 00:28:26 | 7.2.0.12 | `0xC0000005` | ntdll +0x3e663 | keine Zeile in `Exception.log` |
| 06.09. 00:32:43 | 7.2.0.12 | `0xC0000005` | `<UNKNOWN>` | das Suchfenster aus Abschnitt 2 |

Zwei Dinge stechen heraus.

**Erstens:** Zweimal `STATUS_HEAP_CORRUPTION` innerhalb von elf Sekunden, mit
demselben Programm, aus demselben Verzeichnis. Das ist der Fingerabdruck einer
**wiederholbaren Bedienhandlung**, die zuverlässig zuschlägt. Und
`STATUS_HEAP_CORRUPTION` erzeugt **kein Fenster und keine `Exception.log`** —
es ist die genaue Entsprechung von „das Programm ist einfach weg". Belegen kann
ich nicht, dass diese Handlung Strg-N war; Gregor müsste es sagen. Aber es ist
die einzige Spur in den Protokollen, die zum Bild passt.

**Zweitens** — und das ist unabhängig davon ein echter Mangel:

### `Bin\Release\dbghelp.dll` macht jeden Absturz unsichtbar

`EuMemMgr.dll` (vorgebaut, 2005) importiert `dbghelp.dll`. Neben
`Eudora71\Bin\Release\Eudora.exe` liegt eine mitversionierte `dbghelp.dll` der
Fassung **6.4.7.1 (2005)**, und die gewinnt gegen die von Windows 10. Am
05.09. um 22:46:34 ist der Absturzbehandler beim Auslesen des Aufrufstapels
**in dieser DLL** abgestürzt — Ergebnis: keine `Exception.log`, kein Fenster,
Programm weg. Ein Absturz, der eigentlich einen Bericht hinterlassen hätte,
wurde so zum lautlosen Abgang.

**Empfehlung (nicht ausgeführt, weil eine versionierte Binärdatei zu löschen
Gregors Entscheidung ist):** `Eudora71/Bin/Release/dbghelp.dll` aus dem
Repository entfernen. Das **Paket** liefert sie ohnehin nicht mit —
`tools/paket-pruefen.ps1:273` führt `dbghelp` unter den Systembibliotheken, und
in `C:\Users\Gregor\Eudora72-1.0.12-release` liegt keine. Der Paketbau läuft
also längst gegen die von Windows; nur der Entwicklerbau aus `Bin\Release`
läuft gegen die von 2005.

---

## 4. Was ich geändert habe

### 4.1 `ExceptionHandler.cpp` / `.h` — drei Haken gegen den stillen Abgang

`EnableCrashHandler` meldet jetzt zusätzlich an:

```cpp
	_set_invalid_parameter_handler(QCInvalidParameterHandler);
	_set_purecall_handler(QCPureCallHandler);
	::set_terminate(QCTerminateHandler);
```

Alle drei laufen in `ReportSilentFailure` zusammen. Das schreibt zuerst eine
Klartextzeile ans Ende von `Exception.log` — sie sagt, **welche** Fehlerklasse
zugeschlagen hat, und das steht in keinem Registersatz — und erhebt danach eine
richtige strukturierte Ausnahme, damit der vorhandene `QCCrashHandler` Zeit,
Fassung, Modultabelle (E-26), Register und Aufrufstapel darunterhängt.

Aus einem Abgang ohne jede Spur wird damit ein vollständiger Bericht. Was das
**nicht** einfängt, steht als Kommentar an derselben Stelle im Quelltext:
`0xC0000374` und `0xC0000409` gehen an jedem Filter vorbei.

`DisableCrashHandler` nimmt die drei Haken wieder zurück.

### 4.2 Spurmarken auf dem Weg von Strg-N

15 Zeilen der Form

```cpp
	PutDebugLog(DEBUG_MASK_MISC | DEBUG_MASK_TOC_CORRUPT, "E-27 ...");
```

an jedem Abschnitt des Weges:

| Datei | Marken |
|---|---|
| `mainfrm.cpp` | `OnMessageNewMessage`: Anfang, nach `NewCompDocument`, fertig |
| `compmsgd.cpp` | `NewCompDocument`: vor `NewChildDocument`, um `ApplyPersona`. `InitializeNew`: Anfang, vor `CSummary`, um `OutToc->AddSum`, vor den Übersetzern |
| `CompMessageFrame.cpp` | `OnCreateClient`: Anfang, Teiler, beide Ansichten, Übersetzermenü, Leistenressource, um `SetButtons`, Auswahlfelder, Schriftnamen |
| `headervw.cpp` | `OnInitialUpdate`: Anfang, Kopffelder untergeklinkt, um `SetHeaderFromDoc`, fertig |

Die Oder-Verknüpfung der beiden Masken ist Absicht: der Standardwert von
`LogLevel` (`EudoraRes.rc:8441`) ist `25759` = `0x649F`, darin ist
`DEBUG_MASK_MISC` (`0x8000`) **nicht** enthalten, `DEBUG_MASK_TOC_CORRUPT`
(`0x80`) schon. `PutDebugLog` prüft `(DebugMask & ID) == 0`, eine Oder-Maske
heißt also „eines von beiden genügt". So sind die Marken sichtbar, **ohne** dass
Gregor die `Eudora.ini` anfassen muss.

### 4.3 `PaigeEdtView.cpp:657` — `ReleaseBuffer` ohne `GetBuffer`

Die bekannte Fehlerklasse 1, in Eudoras eigenem Code:

```cpp
        strTitle = pDoc->GetTitle();      // teilt sich den Puffer mit dem Dokument
        ...
        if (strTitle.GetLength() > 31)
            strTitle.ReleaseBuffer(31);   // SetLength(31) OHNE Fork
```

`ReleaseBuffer(31)` ohne vorheriges `GetBuffer` ist unter MFC 14 ein
`SetLength(31)` auf dem **gemeinsam genutzten** Puffer: `strTitle` und der
Titel des Dokuments zeigen nach der Zuweisung auf dieselben Bytes. Geschrieben
wird eine Null an Stelle 31 — der Titel des Dokuments wird dabei mitgekürzt.
Kein Absturz, aber ein sichtbarer Schaden am Dokument. Ersetzt durch
`strTitle = strTitle.Left(31);`.

Auf dem Strg-N-Weg liegt die Stelle nicht (sie gehört zum Drucken). Nach dieser
Änderung meldet `perl tools/releasebuffer-pruefen.pl` im ganzen Verfassen-Umfeld
(`compmsgd.cpp`, `CompMessageFrame.cpp`, `headervw.cpp`, `PgCompMsgView.cpp`,
`PgFixedCompMsgView.cpp`, `PaigeEdtView.cpp`) **keine** Fundstelle der Stufe
„falsch" mehr; die 16 verbliebenen liegen sämtlich anderswo (`sendmail.cpp` 4×,
`msgutils.cpp` 4×, `eudora.cpp` 2×, `mime.cpp`, `guiutils.cpp`,
`SMTPSession.cpp`, `QCSharewareManager.cpp`, `Imapdll/Network.cpp`,
`MAPI/recip.cpp`).

---

## 5. Was ich ausgeschlossen habe — und womit

Alles hier ist **gemessen**, nicht vermutet.

| Verdacht | Ausgeschlossen durch |
|---|---|
| **`toupper`/`tolower` mit negativem `char`** (Latin-1-Umlaut in einer deutschen Beschriftung, etwa `CHeaderView::GetShortcutLetter`) beendet den Prozess still | Quelltext der ausgelieferten UCRT, `ucrt/convert/tolower_toupper.cpp`: **keine** Argumentprüfung, kein `_VALIDATE`. Die Vermutung war falsch. |
| `isalpha`/`isspace` & Co. mit negativem `char` | `ucrt/convert/isctype.cpp:36,42` — nur `_ASSERTE`, also ausschließlich im Debug-Bau |
| Der Suchindex X1 tauscht Speicher über die Heap-Grenze | `dumpbin -imports x1lib.dll`: kein `MSVCR71`, keine getrennte Laufzeit |
| `SECStdBtn`-Knöpfe werden über einen versetzten Zeiger freigegeben (Mehrfachvererbung `CTBarBitmapComboBtn : CBitmapCombo, SECWndBtn`) | `OTShim_Werkzeugleiste.h:297`: `virtual ~SECStdBtn();` — der Destruktor ist virtuell, `delete m_btns[i]` ist damit wohldefiniert |
| Doppelfreigabe der Werkzeugleisten-Knöpfe über `PostNcDestroy` | `bmpcombo.cpp:250-257`: `CBitmapCombo::PostNcDestroy` löscht nichts, nur der Leistendestruktor löscht |
| `new BYTE[]` gegen `delete` in der Zustandsablage der Leisten | `OTShim_Werkzeugleiste.cpp:3249-3254`: `delete [] m_pExtraInfo` — richtig gepaart |
| Ungeprüfter `CPtrArray::ElementAt` (Fehlerklasse aus E-16) | E-16 hat alle Stellen abgesichert; die Gegenprobe am Objektcode dort war vollständig |
| `SearchManager::NotifySumAddition` hält einen Zeiger auf eine temporäre `CString` (Fehlerklasse E-24) | `tocdoc.h:124`: `const CString& GetMBFileName() const { return m_MBFileName; }` — Referenz auf ein Feld, keine Kopie |
| `strncpy`-Überläufe in `InitializeNew`, `ApplyPersona`, `OnKillFocusHeader` | jede Stelle nachgelesen: Zielgröße wird durchgereicht, Abschluss-Null wird gesetzt |
| `CSummary::GetSubject` schreibt nach `m_Subject + 1` | `summary.h:403`: `char m_Subject[64]`, `IDS_NO_SUBJECT` ist `"No Subject"` — 11 Bytes, kein Überlauf |

### Was ich als offene Spur stehen lasse

**`Paige32.dll` und `EuMemMgr.dll` haben einen eigenen Heap.** Beide sind
vorgebaute Binärdateien von 2005 und importieren `malloc`/`free` (und
`EuMemMgr` zusätzlich `realloc`) aus `MSVCR71.dll`, das die `VC71Bruecke` an
`msvcrt.dll` weiterleitet. Eudora.exe selbst benutzt die UCRT. Das sind **zwei
getrennte Halden**. Gemessen:

```
$ dumpbin -imports Paige32.dll
    MSVCR71.dll
      101474F0    2DF malloc
      10147310    2AC free
      ...
    Bound to MSVCR71.dll [6A9C4C3B]
      Contained forwarders bound to msvcrt.DLL
```

Gäbe irgendeine Stelle Speicher über diese Grenze weiter — Eudora belegt,
Paige gibt frei, oder umgekehrt —, wäre `STATUS_HEAP_CORRUPTION` die
zwangsläufige Folge, und das **Verfassen-Fenster ist der Hauptbenutzer von
Paige**. Ich habe keine solche Stelle gefunden: `Paige32.lib` ist nur die
Importbibliothek, es wird keine Paige-Quelldatei in `Eudora.exe` mitübersetzt,
und die Paige-Schnittstelle arbeitet über eigene Kennungen (`memory_ref`), nicht
über rohe Zeiger. **Gefunden habe ich nichts — ausgeschlossen habe ich es aber
auch nicht.** Wer hier weitersucht, sucht an der wahrscheinlichsten Stelle.

---

## 6. So wird der Fehler beim nächsten Lauf eingefangen

1. Diesen Stand bauen und starten.
2. **Strg-N** drücken.
3. Wenn Eudora verschwindet, zwei Dateien ansehen — beide im Mailverzeichnis:

   * **`eudora.log`**, letzte Zeile, die mit `E-27` beginnt.
     Sie nennt den letzten Abschnitt, der noch durchlaufen wurde. Beispiel:

     ```
     MAIN   128: 2.05 E-27 OnCreateClient: vor SetButtons der Nachrichtenleiste
     ```

     Dann liegt der Fehler in `SetButtons` oder unmittelbar danach.

   * **`Exception.log`**. Steht dort jetzt ein Block
     „*Stiller Abbruch der Laufzeitbibliothek (Befund E-27)*", war es ein
     ungültiges Argument an die C-Laufzeit, ein pure-virtual-call oder eine
     nicht abgefangene C++-Ausnahme — und der Aufrufstapel darunter nennt die
     Stelle. Bleibt die Datei leer, war es Heap-Beschädigung oder /GS; dann
     Schritt 4.

4. **Nur wenn `Exception.log` leer bleibt**, also bei Heap-Beschädigung: den
   Seiten-Heap einschalten. Damit wird aus dem Schreiben hinter ein Feld sofort
   ein gewöhnlicher Zugriffsfehler an genau der schuldigen Anweisung, und den
   fängt der vorhandene Behandler mit vollem Aufrufstapel.

   ```
   gflags /p /enable Eudora.exe /full        (einschalten)
   gflags /p /disable Eudora.exe             (wieder aus)
   ```

   `gflags` gehört zu den Debugging Tools for Windows. Das ist eine
   **Systemeinstellung** (Image File Execution Options) — deshalb steht sie hier
   als Anleitung und ist nicht ausgeführt. Eudora läuft damit deutlich
   langsamer und braucht mehr Speicher; danach wieder abschalten.

5. Vorher: **`Eudora71/Bin/Release/dbghelp.dll` löschen** (Abschnitt 3),
   sonst kann der Behandler auch diesmal wieder in ihr abstürzen und man sieht
   erneut nichts.

---

## 7. Geänderte Dateien

| Datei | Was |
|---|---|
| `Eudora71/Eudora/ExceptionHandler.h` | Deklaration der drei Haken und von `ReportSilentFailure` |
| `Eudora71/Eudora/ExceptionHandler.cpp` | Anmeldung in `EnableCrashHandler`, Abmeldung in `DisableCrashHandler`, die vier neuen Funktionen |
| `Eudora71/Eudora/mainfrm.cpp` | 3 Spurmarken in `OnMessageNewMessage` |
| `Eudora71/Eudora/compmsgd.cpp` | `#include "debug.h"`, 7 Spurmarken in `NewCompDocument` und `InitializeNew` |
| `Eudora71/Eudora/CompMessageFrame.cpp` | `#include "debug.h"`, 8 Spurmarken in `OnCreateClient` |
| `Eudora71/Eudora/headervw.cpp` | `#include "debug.h"`, 5 Spurmarken in `OnInitialUpdate` |
| `Eudora71/Eudora/PaigeEdtView.cpp` | `ReleaseBuffer(31)` ohne `GetBuffer` ersetzt |

Zeilenenden und Bytes über 127 vor und nach jeder Änderung gemessen und
unverändert: `mainfrm.cpp`, `compmsgd.cpp`, `CompMessageFrame.cpp`,
`headervw.cpp`, `PaigeEdtView.cpp` je CR=18/HI=0, `ExceptionHandler.*` CR=0/HI=0.

**Nicht ausgeführt, aber empfohlen:** `Eudora71/Bin/Release/dbghelp.dll`
löschen.
