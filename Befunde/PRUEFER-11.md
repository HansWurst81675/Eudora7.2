# PRÜFER-11 — E-97 nachgerechnet, dazu E-96 und E-88

Stand: 17.09.2026. Geprüft wurde `6ea7e43..HEAD` auf `e97-speichern-absturz`
(`6ea7e43` ist der letzte Commit an `Befunde/PRUEFER-10.md`). MFC-Quelle:
`C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.38.33130\atlmfc`.

Gelesen wurden nicht nur die Diffs, sondern `SaveAsDialog.cpp` ganz,
`PGHTMIMP.CPP` von Zeile 1960 bis 2210 und 3038 bis 3100, `PgMsgView.cpp`
`ExportMessage`/`SaveInfo` ganz, dazu die MFC-Quellen `dlgfile.cpp`,
`dlgcomm.cpp`, `winocc.cpp`, `afxwin2.inl`.

---

## Kurzantwort

**Die E-97-Behebung hält der Nachrechnung stand.** Der Absturz ist beseitigt,
und zwar an genau der Stelle, an der er entstand.

**Durch die Null-Prüfung geht kein Zustand verloren** — weil es den Zustand
nicht gibt. Die beiden Kästchen existieren in diesem Dialog überhaupt nicht,
und zwar schon lange vor E-97.

Aber: **die Begründung im Quelltext und in `BEFUNDE.md` ist in zwei Punkten
falsch**, und der wichtigere Mangel liegt neben E-97 — siehe P-4 und P-5.

---

## E-97

### P-1 — Die Ursache stimmt, und sie lässt sich schärfer belegen als bisher

`SaveAsDialog.cpp:460` — `dlgPtr->GetDlgItem(cmb1)` mit `dlgPtr == NULL`.

Der Beleg, der im Befund fehlt: `CWnd::GetDlgItem(int)` ist **nicht** inline.
Der Rumpf steht in `atlmfc/src/mfc/winocc.cpp:86` und liest zuerst ein
Mitglied des Objekts:

```cpp
CWnd* CWnd::GetDlgItem(int nID) const
{
	ASSERT(::IsWindow(m_hWnd));
	if (m_pCtrlCont == NULL)
		return CWnd::FromHandle(::GetDlgItem(m_hWnd, nID));
	...
}
```

Über einen Nullzeiger aufgerufen, liest das an einer kleinen Adresse — die
Zugriffsverletzung entsteht **innerhalb von `mfc140.dll`**. Genau das steht im
Windows-Ereignisprotokoll, das in `BEFUNDE.md` zitiert wird: *fehlerhaftes
Modul `mfc140.dll`, Ausnahme `0xc0000005`*. Der Befund führt diesen Eintrag
bisher ohne Erklärung mit; er ist der Beweis.

Die Gegenprobe dazu: die anderen Zugriffe, die in der Behebung mit abgesichert
wurden, **stürzen gar nicht ab**. `CButton::SetCheck`, `GetCheck` und
`CWnd::EnableWindow` gehen über `::SendMessage(NULL, …)` bzw.
`::EnableWindow(NULL, …)`; beide liefern mit einem Null-Handle 0 zurück und
lösen keine Ausnahme aus. Nur das `ASSERT` davor schlägt an, und das ist im
Release nichts. Das deckt sich mit dem, was in `BEFUNDE.md` bereits steht
(*„die ungeprüften Steuerelemente in `OnInitDialog`" sei widerlegt worden*).

**Mangel:** der Kommentar in `SaveAsDialog.cpp:96-114` behauptet trotzdem,
`m_IncludeHeaders.SetCheck()` sei *„DIE URSACHE"*. Das widerspricht der
Widerlegung, die im selben Repo steht. Die Prüfungen dort sind harmlos und
dürfen bleiben; der Kommentar sollte sagen, dass sie **Vorsorge** sind, nicht
Ursache.

### P-2 — Die angegebene Begründung ist falsch: es gibt gar kein Vorlagenfenster

Quelltext und Befund sagen: *„Zu diesem Zeitpunkt hat das Vorlagenfenster noch
kein Elternfenster."* Das kann nicht sein, und es ist auch nicht so.

1. `CWnd::GetParent()` ist `afxwin2.inl:212`:
   `{ ASSERT(::IsWindow(m_hWnd)); return CWnd::FromHandle(::GetParent(m_hWnd)); }`
   Ein `WS_CHILD`-Fenster hat **immer** ein Elternfenster. `NULL` kann nur
   herauskommen, wenn `m_hWnd` selbst `NULL` ist — wenn das Dialogobjekt also
   noch **gar kein Fenster** hat.

2. Die Vorlage wird nie instanziiert. `CFileDialog` in MFC 14.38 hat
   `BOOL bVistaStyle = TRUE` als Vorgabe (`afxdlgs.h:144`). `CSaveAsDialog`
   ruft den Basiskonstruktor mit sechs Argumenten auf
   (`SaveAsDialog.cpp:23-25`) und übergibt **kein** `FALSE`. Auf Windows 10 ist
   `dwMajorVersion` 10, also `>= 6`, also bleibt `m_bVistaStyle == TRUE`
   (`dlgfile.cpp:38-46`). Der Konstruktor legt daraufhin `CLSID_FileSaveDialog`
   an und meldet `m_xFileDialogEvents` an. `OFN_ENABLETEMPLATE` und
   `lpTemplateName` setzt Eudora erst **danach** — zu spät, und ohne Wirkung:
   `CFileDialog::DoModal` (`dlgfile.cpp:732`) verzweigt bei `m_bVistaStyle` auf
   `ApplyOFNToShellDialog(); IFileDialog::Show(...)`, und
   `ApplyOFNToShellDialog` liest `lpTemplateName` **nirgends**.

3. Dass die Vista-Schiene wirklich genommen wird, hängt nur noch an
   `CoInitializeEx(NULL, COINIT_APARTMENTTHREADED)` im Konstruktor. Eudora ruft
   `AfxOleInit()` (`eudora.cpp:913`), also STA — der Aufruf liefert `S_FALSE`,
   das ist `SUCCEEDED`. Die Vista-Schiene ist gesichert.

4. Der Rückruf kommt folglich **nicht** über `CDN_TYPECHANGE`/
   `CFileDialog::OnNotify` (`dlgfile.cpp:1816`), sondern über
   `CFileDialog::XFileDialogEvents::OnTypeChange` (`dlgfile.cpp:638`), einen
   COM-Rückruf von `IFileDialogEvents`, den die Shell aus `Show()` heraus
   auslöst, bevor das Dialogfenster erzeugt ist.

**Die Reihenfolgeaussage stimmt also im Ergebnis** (der Rückruf kommt vor
`OnInitDialog`), **die Erklärung dazu nicht.** Richtig wäre: *der Dateidialog
meldet den Dateityp über `IFileDialogEvents`, bevor er sein Fenster erzeugt;
`CSaveAsDialog::m_hWnd` ist noch null, deshalb liefert `GetParent()` NULL.*

Angemerkt: die Reihenfolge ist bisher **nicht gemessen**, nur erschlossen. Die
einzige eingebaute Spurmarke (`SaveAsDialog.cpp:78`) steht in `OnInitDialog`,
keine in `OnTypeChange` — mit einer Marke allein lässt sich keine Reihenfolge
belegen. Und ausgelesen wurde sie auch nicht: unter `C:\Temp\E97-Stapel` liegt
keine `eudora.log`, die diese Zeile enthält (vgl.
`Arbeitsweise/eingebaute-messung-auslesen.md`).

### P-3 — Geht Zustand verloren? Nein. Aber die Begründung dafür ist falsch

Die Antwort auf die wichtigste Frage des Auftrags: **nein, es geht nichts
verloren.**

Der Grund ist aber nicht der, der im Quelltext steht. Weil die Vorlage
`IDD_SAVEAS_EXT` nie instanziiert wird (P-2), scheitern in `DoDataExchange`
(`SaveAsDialog.cpp:52-57`) **alle drei** `if (GetDlgItem(...))`-Abfragen.
`m_IncludeHeaders`, `m_GuessParagraphs` und `m_Stationery` bleiben dauerhaft
unangebunden, `m_hWnd == NULL`. `m_GuessParagraphs.EnableWindow()` in
`OnTypeChange` hätte also **zu keinem Zeitpunkt** etwas bewirkt — weder früh
noch spät. Ein zweiter, unabhängiger Beleg: die Freigabe hängt an
`iCurSel == 1` des Kombinationsfelds `cmb1`, geholt **vom Elternfenster**. In
der Vista-Schiene ist das Elternfenster das Hauptfenster von Eudora, und das
hat kein `cmb1`.

**Falsch ist dagegen dieser Satz** (`SaveAsDialog.cpp:454-456` und wörtlich so
auch in `BEFUNDE.md`):

> *„Dann gibt es nichts zu tun — `OnInitDialog` setzt den Zustand ohnehin
> gleich darauf."*

`OnInitDialog` (Zeile 74-217) setzt **nur die Häkchen** (`SetCheck`), nicht die
Freigabe. Es ruft weder `EnableWindow` auf `m_GuessParagraphs` noch
`OnTypeChange()`. Der Satz ist eine Behauptung, die die gelesene Funktion nicht
deckt. Heute folgenlos — sobald aber jemand die Kästchen wiederherstellt (und
das steht laut `BEFUNDE.md` als Anforderung im Raum), wird daraus ein echter
Fehler: ein Dialog, der mit HTML als Vorauswahl öffnet, zeigt *Absätze raten*
freigegeben, obwohl es gesperrt gehört.

**Zu „kommt `OnTypeChange` später noch einmal?"** Ja — `IFileDialogEvents::
OnTypeChange` feuert bei jedem Wechsel des Dateityps. Dann existiert das
Fenster, `GetParent()` liefert das Hauptfenster, `dlgPtr->GetDlgItem(cmb1)`
liefert `NULL`, und die zweite Prüfung (`m_GuessParagraphs.GetSafeHwnd()`)
greift. Kein Absturz, kein Verhalten. Der Weg „mit gültigem Parent" bleibt also
offen — er führt nur nirgendwohin, und das tat er vorher auch schon.

### P-4 — Der eigentliche Mangel: die beiden Kästchen sind weg, und zwar seit langem

`BEFUNDE.md` hält bei E-97 ausdrücklich fest:

> *„Bei der Behebung dürfen die beiden Kästchen nicht verlorengehen — sie
> einfach wegzulassen wäre Funktionsverlust statt Behebung."*

Sie **sind** verloren — nicht durch die Behebung, sondern durch MFC 14.38: der
Vista-Dateidialog kennt `OFN_ENABLETEMPLATE` nicht (P-2). Beim Speichern einer
Nachricht kann der Anwender *Kopfzeilen einschließen* und *Absätze raten* seit
der Portierung nicht mehr wählen. Gespeichert wird stets nach dem, was in der
INI steht.

Das ist ein eigener Befund, kein E-97. Wer ihn beheben will, hat zwei Wege:
`bVistaStyle = FALSE` an den Basiskonstruktor (dann läuft die Vorlage von 1996
wieder, mit dem alten Erscheinungsbild), oder `IFileDialogCustomize`
(`m_pIFileDialogCustomize` liegt in MFC bereit) mit zwei
`AddCheckButton`-Aufrufen. Der zweite Weg ist der saubere.

### P-5 — `m_Inc` und `m_Guess` sind nirgends vorbelegt (Verdacht auf INI-Verderb)

`SaveAsDialog.h:44` deklariert `BOOL m_Inc, m_Guess;`. Der Konstruktor
(`SaveAsDialog.cpp:21-46`) setzt sie **nicht**. Die einzige Zuweisung steht in
`OnInitDialog:132`, innerhalb von `if (IsVersion4()) { if (m_IsMessage) { … } }`.

Alle drei Aufrufstellen schreiben sie nach `DoModal()` **ungeprüft** in die INI:

* `tocview.cpp:3087-3088`
* `saveas.cpp:106-107`
* `compmsgd.cpp:3374-3375`

Wird `OnInitDialog` in der Vista-Schiene **nicht** erreicht, stehen dort zwei
uninitialisierte Werte, und sie landen dauerhaft in
`IDS_INI_INCLUDE_HEADERS` / `IDS_INI_GUESS_PARAGRAPHS` des Anwenders. Ob
`OnInitDialog` erreicht wird, ist offen: `DoModal` ruft in der Vista-Schiene
`AfxHookWindowCreate(this)` (`dlgfile.cpp:760`), und angebunden wird
**irgendein** erstes Fenster, das die Shell danach erzeugt — nicht zwingend der
Dialog.

**Zwei Messungen, die das in Minuten klären:**

1. Die bereits eingebaute Marke `SaveAsDialog.cpp:78` auslesen
   (`DEBUG_MASK_MISC` einschalten, *File → Save As*, `eudora.log` lesen).
2. Ohne Protokoll, rein optisch: `OnInitDialog:124-129` schiebt den Dialog mit
   `MoveWindow` an die **Unterkante des Hauptfensters**. Erscheint das
   Speichern-Fenster normal mittig, ist `OnInitDialog` nicht gelaufen — dann
   ist P-5 scharf.

Bis das gemessen ist, sollten `m_Inc` und `m_Guess` im Konstruktor auf
`GetIniShort(...)` vorbelegt werden. Das kostet nichts und schließt den Weg.

### P-6 — Dieselbe Lücke, dreimal unbehoben (Gegenvermutung des Auftrags)

Der Auftrag fragt nach `OnFileNameChange`, `OnFolderChange`,
`OnShareViolation`, `OnLBSelChangedNotify`: **`CSaveAsDialog` überschreibt
keine davon**, sie landen in den leeren MFC-Rümpfen. Dort ist nichts zu holen.

Dieselbe Klasse findet sich aber **in derselben Datei**, dreimal, unverändert:

| Stelle | Zeile | Zugriff |
|---|---|---|
| `GetFileNameFromDialog` | 388 | `dlgPtr->GetDlgItem(edt1)`, `dlgPtr = GetParent()`, ungeprüft |
| `ToggleStat` | 241 | `dlgPtr->GetDlgItem(cmb1)`, ungeprüft |
| `StatDir` | 303 | `dlgPtr->GetDlgItem(IDOK)`, ungeprüft |

`GetFileNameFromDialog` ist die gefährliche: sie wird aus `OnOK()` gerufen
(Zeile 352), also **im laufenden Speichervorgang**, nicht nur beim Aufbau.
`ToggleStat` und `StatDir` hängen an `ON_BN_CLICKED(IDC_STATIONERY)` — der
Schalter existiert nicht (P-4), also feuern sie heute nicht; sie werden
scharf, sobald P-4 behoben wird.

`SetFileNameInDialog` (393) berechnet `dlgPtr` und benutzt es auf dem
`IsVersion4()`-Zweig gar nicht — tote Berechnung, kein Fehler.

Angemerkt: `OnOK():345-346` schreibt `m_IncludeHeaders.GetCheck()` in die INI.
An einem unangebundenen Schalter ist das 0. Wird `OnOK` je erreicht, löscht es
die Einstellung des Anwenders still — die Aufrufstelle überschreibt sie danach
zwar wieder mit `m_Inc`, aber nur, wenn `m_Inc` gültig ist (P-5).

### P-7 — Kleinigkeiten

* `OnTypeChange:460/465`: die Prüfung auf `m_GuessParagraphs` steht **hinter**
  dem `GetDlgItem`-Aufruf. Harmlos, gehört aber davor — sonst liest der nächste
  Leser die Reihenfolge als Absicht.
* Die Spurmarke `PutDebugLog(... "E-97 OnInitDialog: 1 ...")`
  (`SaveAsDialog.cpp:78`) ist in 1.0.64 ausgeliefert worden.

---

## E-96 (`PGHTMIMP.CPP`)

### P-8 — `PaigeHTMLImportTextDescent` wird nie beschrieben

`PGHTMIMP.CPP:1827` legt die Variable mit 3 an. Zugewiesen wird sie
**nirgends** — nur der Ascent wird gemerkt (Zeile 2053). `ProcessEmbed:3097`
schreibt also stets die fest verdrahtete 3 zurück, gleich welchen Descent der
Text der Nachricht wirklich hat. Der Kommentar bei 3041 (*„der Text-Ascent/
-Descent, wie er VOR dem ersten Bild galt"*) beschreibt etwas, das der Code für
den Descent nicht tut.

### P-9 — Der Kommentar beschreibt die Bedingung falsch

*„Er wird einmal je Import gesetzt"* — die Bedingung lautet
`if (!embed_last_action && original_ascent > 0)`. `embed_last_action` wird an
`PGHTMIMP.CPP:382` und `:923` wieder auf FALSE gesetzt, also nach jedem
Textstück. Die Aufnahme läuft daher mehrfach je Import. Wirkung ist gutartig
(aufgenommen wird dann der Wert, den `ProcessEmbed` selbst gesetzt hat), die
Beschreibung ist falsch. Zudem sind beide Variablen **dateilokal statisch** —
sie überleben den Import und die Nachricht; der Kommentar spricht von „je
Import".

### P-10 — Gegenvermutung: 13/3 ist für Text nach einem Bild zu wenig

`ProcessEmbed:3096-3097` klemmt `current_style.ascent/descent` auf 13/3 fest.
`current_style` ist der Stil, der auch für den **folgenden Text** gilt, bis ein
Stil-Tag ihn ändert. Bei einer Nachricht mit großer Schrift (etwa 20 pt) bekommt
die Textzeile nach einem Bild damit einen 13/3-Zeilenkasten statt der
Schriftmetrik — dasselbe Schadensbild wie E-89, nur an Text statt an Bildern.

Der im Kommentar verworfene Gegenentwurf (`paige_globals->def_style`, gemessen
`text-asc=0`) misst den **Vorgabestil**, nicht das, was Paige mit `ascent == 0`
an einem Textlauf tut — in Paige heißt 0 üblicherweise *aus der Schrift
ableiten*. Die Widerlegung trägt die Schlussfolgerung nicht.

**Messung:** eine HTML-Nachricht mit 20-pt-Text hinter einem Bild importieren
und die Spurmarke lesen. Ist der Text danach beschnitten, ist P-10 scharf.

### P-11 — Die E-95-Spurmarke liest einen Paige-Handle als Zeichenkette

`PGHTMIMP.CPP:2178-2182`:

```c
if (image_ref)
{
   for (i = 0; i < 32 && ((const char *)image_ref)[i]; i++)
      szSrc[i] = ((const char *)image_ref)[i];
```

`image_ref` ist in Zeile 1966 als `memory_ref` deklariert — ein
Paige-Speicherhandle, das über `GetMemoryRecord`/`UseMemory` aufgelöst werden
muss, wie es Zeile 2045 unmittelbar davor selbst tut. Als `const char*`
gelesen, liefert das die ersten Bytes der Handle-Struktur: **Binärmüll**, nicht
`cid:`, `data:` oder `http:`, wie der Kommentar behauptet. Die Messung, die
laut Kommentar *„misst, statt zu vermuten"*, misst an dieser Stelle nichts.

Die gewollte Angabe steht in `image_record.URL` — Zeile 2065 benutzt sie
bereits. Die Leseschleife ist außerdem nicht durch die tatsächliche Größe des
Objekts begrenzt, sondern nur durch das erste Nullbyte.

Auch diese Marke ist in 1.0.64 ausgeliefert.

### P-12 — Falsche Befundnummer im Quelltext

Sämtliche Kommentare zur `ProcessEmbed`-Behebung sind mit **E-95** ausgezeichnet
(Zeilen 9, 2049, 2156, 3038, 3062). `BEFUNDE.md:257` führt genau diese Behebung
als **E-96**; E-95 ist das Symptom, dessen 7.2.0.61-Behebung zurückgenommen
wurde (`BEFUNDE.md:256`). Wer künftig E-96 im Quelltext sucht, findet nichts.

---

## E-88 / E-93 (`PgMsgView.cpp`, `msgutils.cpp`)

### P-13 — Möglicher Inhaltsverlust: `HasChanged()` heißt nicht „hat getippt"

`PgMsgView.cpp:436` übergibt `HasChanged()` als `bAnwenderHatGetippt` an
`E88OriginalEinsetzen`. In `msgutils.cpp` entscheidet dieser Wert im Zweig
`nFund < 0` (der Klartext des Originals steckt nicht am Stück in der
Editorfassung — genau der `Fw: Fw:`-Fall, der die Regel ausgelöst hat):

```
if (bAnwenderHatGetippt)   szUrteil = "EDITOR (Anwender hat im Zitat geaendert)";
else { nFund = 0; nVorLen = 0; nNachLen = 0; }
```

`nVorLen = nNachLen = 0` heißt: `szVor` und `szNach` bleiben leer, und der
**gesamte** Rumpf wird durch das aufgehobene Original ersetzt.

`HasChanged()` ist `PaigeEdtView.h:193`:
`{ return (m_ccLastSaved != m_chngCount); }`. Und `SaveChangeState()`, das
beide gleichsetzt, steht am **Ende jedes `ExportMessage`**
(`PgMsgView.cpp:463`). `ExportMessage` wird aus `SaveInfo()`
(`PgMsgView.cpp:588`) gerufen, also bei **jedem Sichern** des Entwurfs.

Damit bedeutet `HasChanged()` nicht *„hat seit dem Öffnen getippt"*, sondern
*„hat seit dem letzten Export getippt"*. Ablauf:

1. Anwender leitet eine bereits weitergeleitete Nachricht weiter, tippt eine
   Anmerkung.
2. Entwurf wird gesichert → `ExportMessage` (nimmt korrekt EDITOR) →
   `SaveChangeState()` → `HasChanged() == FALSE`.
3. Anwender sendet, ohne weiter zu tippen → `ExportMessage` erneut →
   `bAnwenderHatGetippt == false` → **die Anmerkung wird verworfen, das nackte
   Original geht hinaus**, ohne jede Meldung.

Der Kommentar in `msgutils.cpp` (*„Die Regel kann nur helfen, nie schaden: sie
greift ausschließlich, wenn nachweislich nicht getippt wurde"*) trägt unter
dieser Semantik nicht. Voraussetzung ist der eingeschaltete Schalter
`IDS_INI_FORWARD_ORIGINAL_HTML`.

**Messung:** `Fw: Fw:` öffnen, Anmerkung tippen, Entwurf sichern, dann senden,
und die Zeile `Fassung=…` im Protokoll lesen. Steht dort `ORIGINAL`, ist der
Inhaltsverlust nachgewiesen.

**Abhilfe**, falls bestätigt: ein eigenes Kennzeichen am Verfassendokument, das
beim ersten `kAddChange` gesetzt und **nie** zurückgenommen wird, statt des
exportabhängigen `HasChanged()`.

Vgl. `Arbeitsweise/kein-paket-mit-offenem-datenverlust.md`.

---

## Was ich nicht prüfen konnte

* Ob `OnInitDialog` in der Vista-Schiene erreicht wird (P-5) — das ist eine
  Messung am laufenden Programm, keine Quelltextfrage.
* Die Reihenfolge `OnTypeChange` vor `OnInitDialog` (P-2) ist erschlossen, nicht
  gemessen; es fehlt eine zweite Spurmarke in `OnTypeChange`.
* `QCTaskManager.cpp`, `TridentView.cpp`, `summary.cpp`, `utils.cpp`,
  `ImapDownload.cpp` und die neuen Tests lagen außerhalb des Auftrags.

---

## Reihenfolge, in der ich das angehen würde

1. **P-13** — möglicher Inhaltsverlust beim Senden, Messung ist billig.
2. **P-5** — `m_Inc`/`m_Guess` vorbelegen; zwei Zeilen, schließt einen Weg in
   die INI des Anwenders.
3. **P-11** — die Spurmarke liest den falschen Zeiger; sie beantwortet gerade
   gar nichts.
4. **P-4** — die beiden Kästchen zurückholen (`IFileDialogCustomize`).
5. **P-6** — die drei verbliebenen `dlgPtr->GetDlgItem`-Stellen absichern.
6. **P-2, P-3, P-9, P-12** — Text berichtigen: falsches Vorlagenfenster,
   „`OnInitDialog` setzt den Zustand ohnehin", falsche Bedingung, falsche
   Befundnummer.
7. **P-10** — Gegenvermutung zur festen 13/3 messen.
8. **P-7, P-8** — Kleinigkeiten.
