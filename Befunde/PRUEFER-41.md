# PRÜFER-41 — 7.2.0.114: die Rückfrage ist auf vier von fünf Startwegen aus

Gegenstand: der Quelltext, der seit [PRÜFER-40](PRUEFER-40.md) dazugekommen ist
und als Paket **1.0.114** hinausgehen soll — Befund
[**E-132**](../BEFUNDE.md#e-132) (fremdes Mailverzeichnis beim Start) und der
erweiterte Über-Dialog. Zweig `wt/pruefer-20261020b`, Stand von `main`
(`6f707bc5`).

**Wie geprüft.** Am Quelltext gelesen, nichts mit Oberfläche gestartet. Dazu
gelesen: `GetDirs`, `CheckMailDirectory`, `GetCommandType` und `StripQuotesMT`
als die Funktionen, gegen die die neue Zerlegung gehalten werden muss;
`CEudoraApp::InitInstance` von `:1003` bis `:1068` für **alle fünf** Startwege,
nicht nur für den gemessenen; `RegisterCommandLine`, weil es die Registry
schreibt, die hier gelesen wird; die MFC-Quelle `atlmfc/src/mfc/strcore.cpp`
für die Frage nach der Initialisierungsreihenfolge. Eine eigene Messung am
lebenden Windows: ob auf Laufwerk `C:` 8.3-Namen erzeugt werden (siehe
[K3](#k3)).

**26 Stellen geprüft, 13 Befunde darunter 12 Funde, davon 4 hoch.**

---

## Urteil

> ### NEIN — Paket 1.0.114 geht so nicht raus.

Nicht, weil die Behebung falsch wäre. Die Entscheidung
`E132IstFremdesVerzeichnis` ist für den Fall, für den sie gemessen wurde,
richtig, und die Zerlegung `E132AufrufZerlegen` trifft die Trennregel von
`GetDirs` bis auf einen Randfall genau ([K8](#k8)). Aber:

* **[K1](#k1): Auf vier von fünf Startwegen ist die Rückfrage abgeschaltet** —
  sie kann dort gar nicht auslösen, weil `ExecutableDir` zu diesem Zeitpunkt
  **leer** ist. Betroffen sind `mailto:`, Postfach-Doppelklick, Briefpapier,
  Anhang und die Automation. Das Protokoll schreibt dann `eigenes="" fremd=0` —
  grün, und genau der Schaden aus Issue #102 geschieht trotzdem.
* **[K2](#k2): Steht unser Programm in einem Pfad mit Leerzeichen, startet
  Eudora nach der Antwort „Nein" überhaupt nicht mehr** — und „Nein" ist die
  **Vorgabe**, die ein unbedachtes Enter auslöst. `C:\Program Files\…`,
  `C:\Users\Hans Wurst\…`: der Pfad geht ungeklammert an `GetDirs`, das am
  ersten Leerzeichen trennt.
* **[K3](#k3): Auf dem eigenen Mailverzeichnis kommt die Warnung fälschlich** —
  gemessen: 8.3-Kurznamen sind auf `C:` eingeschaltet, `RegisterCommandLine`
  schreibt die Registry in Kurzform, `ExecutableDir` ist lang, der
  Präfixvergleich scheitert.

* **[K13](#k13): derselbe Fehlalarm bleibt nach der Behebung von [K3](#k3)
  stehen** — die Registry speichert das Mailverzeichnis ohne Rückstrich,
  `ExecutableDir` trägt einen. Wer sein Mailverzeichnis **im**
  Programmverzeichnis führt, bekommt die Warnung über sein eigenes. Die
  Behebung von [K1](#k1) macht diesen Weg erst erreichbar; beide gehören
  zusammen hinein.

Die Fragen des Koordinators zur geplanten Behebung sind unter
[Antwort auf die vier Fragen](#antwort) beantwortet — mit einer Vergleichsregel,
die [K4](#k4) und [K13](#k13) in einem erledigt und ohne Win32 auskommt.

Siehe [Was ich behoben habe](#behoben). Nach den Behebungen darf das Paket
raus — **nicht vorher**.

### Funde

| Fund | Schwere | Stand |
|---|---|---|
| **[K1](#k1)** `ExecutableDir` ist leer, wenn `StartEudoraWithDefaultLocation` von `eudora.cpp:1017` (CL_ATTACH/STATIONERY/URL/MESSAGE/MAILBOX) oder `:1029` (Automation) gerufen wird — die Rückfrage fällt still aus | **hoch** | **belegt am Quelltext**: `ExecutableDir` wird ausschließlich in `GetDirs` gesetzt (`fileutil.cpp:436`), und `GetDirs` läuft auf diesen Wegen erst **nach** uns |
| **[K2](#k2)** Leerzeichen im Programmpfad: nach „Nein" trennt `GetDirs` am ersten Leerzeichen, `CheckMailDirectory` scheitert, `GetDirs` liefert `FALSE`, Eudora startet nicht | **hoch** | **belegt am Quelltext** (`eudora.cpp:4084`, `fileutil.cpp:445`, `:475`, `:550`, `eudora.cpp:4098`) |
| **[K3](#k3)** 8.3 gegen lang: die Registry trägt nach dem ersten eigenen Start die Kurzform **unseres** Verzeichnisses, `ExecutableDir` ist lang — `fremd=1` auf dem eigenen Mailverzeichnis | **mittel–hoch** | **gemessen** am lebenden Windows (8.3 auf `C:` an) + belegt (`eudora.cpp:3687`) |
| **[K4](#k4)** Der Präfixvergleich kennt kein Trennzeichen. Er geht heute nur gut, weil `ExecutableDir` zufällig auf einen Rückstrich endet — eine Vorbedingung, die weder geprüft noch im Test festgehalten ist. Dazu UNC, Laufwerkszuordnung, `/` statt `\` | mittel | **belegt am Quelltext**, Fälle durchgerechnet |
| **[K5](#k5)** Ohne `Eudora.ini` im Fundort wird **nicht** gefragt — Eudora legt seine Postfächer trotzdem dort an. Und geprüft wird die Existenz von `szIni`, benutzt wird `szVerzeichnis`: die beiden müssen nicht dasselbe Verzeichnis sein | mittel, bewusste Regel mit unbenannter Lücke | **belegt am Quelltext** |
| **[K6](#k6)** Die Angabe „Mail folder from:" im Über-Dialog kann **lügen** — vier Wege benannt, einer davon im häufigsten Fall | mittel | **belegt am Quelltext** |
| **[K7](#k7)** „Copy info" meldet **„Copied"** auch dann, wenn nichts in der Zwischenablage steht — `EmptyClipboard()` ist dann schon gelaufen, die alte Ablage des Anwenders ist weg | gering | **belegt am Quelltext** |
| **[K8](#k8)** Die Trennregel weicht in **einem** Punkt von `GetDirs` ab: `StripQuotesMT` entfernt ein führendes und ein abschließendes Anführungszeichen **unabhängig** voneinander, `E132AufrufZerlegen` nur paarweise. Puffergrenzen nachgerechnet: **kein** Überlauf | gering | **belegt am Quelltext** (`services.cpp:1494-1507`) |
| **[K9](#k9)** Der Weg „Abbrechen" kann im Protokoll **gar nicht** erscheinen: bei `IDCANCEL` steigt `InitInstance` aus, `E132SpurAusgeben()` (`:1213`) wird nie erreicht. Dasselbe bei `err`, bei scheiterndem `GetDirs` und bei scheiterndem `InitDebug` | mittel, Prüflücke | **belegt am Quelltext** |
| **[K10](#k10)** Statische Initialisierungsreihenfolge von `g_szE132Spur`: **kein Fund** | — | **belegt an der MFC-Quelle** (`strcore.cpp:133`, `UseOfMfc=Dynamic`) |
| **[K11](#k11)** Der Über-Dialog schneidet lange Zeilen ohne Ellipse ab; die Log-Zeile verliert dabei gerade das `(LogLevel=…)`, das sie erklären soll. Startbild (`m_IsSplash`) bleibt richtig | gering | **belegt an Quelltext und `.rc`** |
| **[K12](#k12)** Altbestand, durch [E-132](../BEFUNDE.md#e-132) neu sichtbar: `cmdLine` ist nicht vorbelegt und wird nach gescheitertem `RegQueryValueEx` gelesen; die neue `MessageBox` steht **vor** der `err`-Prüfung und kann einen Müllpfad anzeigen | gering | **belegt am Quelltext** |
| **[K13](#k13)** Die Registry speichert das Mailverzeichnis **ohne** Rückstrich, `ExecutableDir` trägt einen — ist das Mailverzeichnis das Programmverzeichnis selbst, meldet der Vergleich „fremd". **Überlebt die Behebung von [K3](#k3)** und wird durch die Behebung von [K1](#k1) erst scharf | **hoch, sobald [K1](#k1) behoben ist** | **belegt am Quelltext** (`eudora.cpp:3681-3684` gegen `fileutil.cpp:435`) |

---

## Was die drei Messungen nicht zeigen

In [E-132](../BEFUNDE.md#e-132) stehen drei Messungen am laufenden Programm:
*Nein* → `fremd=1`, *Ja* → fremde INI geändert, *Abbrechen* → Programm endet.
Alle drei sind echt, und alle drei sind an **`C:\Temp\E132`** gegen
**`C:\Temp\E131`** gefahren. Was dieser Prüfstand nicht treffen kann:

1. **Er hat keine 8.3-Kurzform.** `E131` und `E132` sind vier Zeichen, `Temp`
   ist vier — in Kurz- und Langform derselbe Pfad. Genau deshalb konnte
   [K3](#k3) dort nicht auffallen. Gregors echte Verzeichnisse heißen
   `Eudora72-1.0.114-release`.
2. **Er hat kein Leerzeichen.** [K2](#k2) braucht eines im Programmpfad.
3. **Er fährt nur den Weg mit leerer Befehlszeile.** [K1](#k1) sitzt auf den
   vier anderen.
4. **Die Messung „Abbrechen" kann nicht aus dem Protokoll stammen**
   ([K9](#k9)) — auf diesem Weg wird keine einzige E-132-Zeile geschrieben.
   Was dort beobachtet wurde, ist von außen beobachtet: das Programm endete.
   Das ist richtig, aber es ist eine andere Art von Beleg als bei den beiden
   anderen, und die Zeile in `BEFUNDE.md` unterscheidet das nicht.
5. **Die Gegenprobe „zeigt die Registry auf das eigene Paket, steht `fremd=0`"
   ist mit einem Pfad gefahren, der in beiden Namensformen gleich ist.** Sie
   ist damit kein Nachweis gegen den Fehlalarm, sondern genau der Fall, den
   [K3](#k3) ausnimmt.

---

<a id="k1"></a>

## K1 — die Rückfrage gibt es nur auf einem von fünf Startwegen

`InitInstance` entscheidet in einem `switch` über `GetCommandType`
(`eudora.cpp:1003`). Drei Zweige rufen `StartEudoraWithDefaultLocation`:

| Stelle | Vorher `GetDirs`? | `ExecutableDir` |
|---|---|---|
| `:1017` — `CL_ATTACH`, `CL_STATIONERY`, `CL_URL`, `CL_MESSAGE`, `CL_MAILBOX` | **nein** | **leer** |
| `:1029` — `gbAutomationRunning` | **nein** | **leer** |
| `:1055` — leere Befehlszeile, keine `Eudora.ini` neben der EXE | ja (`:1042`) | gesetzt |

Gemessen wurde nur die dritte Zeile. `ExecutableDir` wird im ganzen Programm an
**einer** Stelle gefüllt:

```cpp
// fileutil.cpp:433-437, in GetDirs()
if (GetModuleFileName(AfxGetInstanceHandle(), buf, sizeof(buf)))
{
    temp = strrchr(buf, SLASH);
    if (temp) { temp[1] = 0; ExecutableDir = buf; }
}
```

(Die zweite Fundstelle, `NSPrefs.cpp:48`, ist eine eigene Kopie hinter
`#ifdef _EUDORA_INSTALLER_` und gehört nicht zu `Eudora.exe`.)

Ist `ExecutableDir` leer, greift in `E132IstFremdesVerzeichnis` die Schranke

```cpp
// eudora.cpp:3795-3797
if (!pEigenes || !*pEigenes)
    return false;
```

— und die Funktion sagt **„nicht fremd"**. Für sich genommen ist das richtig
entschieden (*„lieber nicht fragen als falsch fragen"*). In der Kette ist es
die Abschaltung des gesamten Befundes: `bFremd` ist falsch, es wird nichts
gefragt, `GetDirs(buf)` übernimmt das fremde Verzeichnis, und im Protokoll
steht `eigenes="" fremd=0`. Eine Zeile, die wie eine Entwarnung aussieht.

**Wie oft trifft das?** `GetCommandType` liefert `CL_ATTACH` als **Vorgabe**
für jedes erste Argument, das kein vorhandenes Verzeichnis, keine `.sta`,
`.msg`, `.mbx` und keine lesbare INI ist (`fileutil.cpp:585`). Also auch für
ein Mailverzeichnis, **das es noch nicht gibt** — der erste Start nach einem
versehentlich gelöschten `Mailverzeichnis\` geht über `:1017`. Dazu alles, was
[E-132](../BEFUNDE.md#e-132) selbst im Registry-Export aufzählt: `mailto:`,
`.mbx`, `.sta`, `x-eudora-option`. Der Befund sagt zu Recht, dass wir diese
Zuordnungen nicht kapern — aber ein Anwender, der eine Nachricht oder ein
Postfach auf `Eudora.exe` zieht, fährt denselben Weg.

**Gegenvermutung, geprüft und widerlegt:** *„`ExecutableDir` wird irgendwo
früher gesetzt, etwa in `InitInstance` vor dem `switch`."* Nein — die Suche
über alle `.cpp` findet genau die zwei oben genannten Zuweisungen, und die
erste steht in `GetDirs`.

**Gegenvermutung, geprüft und widerlegt:** *„`Eudora starten.cmd` geht auch
über `:1017`, weil es einen Pfad übergibt."* Nein. Ein **vorhandenes**
Verzeichnis liefert `CL_DIR` (`fileutil.cpp:634`) und landet im `default:`.
Erst wenn das Verzeichnis fehlt, kippt es nach `CL_ATTACH`.

<a id="k2"></a>

## K2 — mit einem Leerzeichen im Pfad startet Eudora nach „Nein" nicht mehr

Der Zweig `IDNO` schreibt das gewählte Verzeichnis zurück nach `buf`:

```cpp
// eudora.cpp:4084-4085
_tcsncpy(buf, szEigenes, sizeof(buf) / sizeof(TCHAR) - 1);
buf[sizeof(buf) / sizeof(TCHAR) - 1] = 0;
```

`szEigenes` ist `ExecutableDir + "Mailverzeichnis"`, also ein **langer Pfad
ohne Anführungszeichen**. Unten geht `buf` an `GetDirs`, und `GetDirs` liest
`buf` als **Befehlszeile**:

```cpp
// fileutil.cpp:443-446
if (Ini = strstr(CmdLine, "\" "))
    *(++Ini)++ = 0;
else if ((*(CmdLine + strlen(CmdLine) - 1) != '\"') && (Ini = strchr(CmdLine, ' ')))
    *Ini++ = 0;
```

Kein Anführungszeichen am Ende, also wird am **ersten Leerzeichen** getrennt.
Aus `C:\Program Files\Eudora72\Mailverzeichnis` wird das Verzeichnis
`C:\Program` und die INI `Files\Eudora72\Mailverzeichnis`. Weiter:

* `GetFileAttributes("C:\Program")` scheitert, `Ini` ist gesetzt →
  `CheckMailDirectory("C:\Program", "command line")` (`fileutil.cpp:475`)
* dort `FileExistsMT` falsch → `ErrorDialog(IDS_ERR_BAD_EUDORA_DIR)`, `FALSE`
* `status` bleibt `FALSE`, `GetDirs` gibt `status` zurück (`fileutil.cpp:550`)
* `if (err || !GetDirs(buf))` → `ErrorDialog(IDS_ERR_CANNOT_START_WITH_ATTACH)`
  → `return FALSE` (`eudora.cpp:4098-4102`)

**Der Anwender bekommt zwei Fehlermeldungen und kein Eudora** — nachdem er die
Antwort gegeben hat, die wir ihm als Vorgabe hingestellt haben, damit *„ein
unbedachtes Enter nichts beschädigt"*.

Dass das im Original nicht passiert, ist kein Zufall: `RegisterCommandLine`
schickt **alle drei** Stücke durch `GetShortPathName` (`eudora.cpp:3686-3688`),
bevor sie mit Leerzeichen zusammengesetzt werden — QUALCOMM ist dieser Falle
mit 8.3 ausgewichen. Unser neuer Zweig ist der erste, der einen **langen** Pfad
in `buf` legt.

<a id="k3"></a>

## K3 — der Fehlalarm auf dem eigenen Verzeichnis

`RegisterCommandLine` schreibt bei **jedem** gewöhnlichen Start in die
Registry, und zwar verkürzt:

```cpp
// eudora.cpp:3685-3689
GetModuleFileName(AfxGetInstanceHandle(), app, sizeof(app));
VERIFY(GetShortPathName(app,app, sizeof(app)) > 0);
VERIFY(GetShortPathName(eDir,eDir, sizeof(eDir)) > 0);
VERIFY(GetShortPathName(INIPath,iniPath, sizeof(iniPath)) > 0);
sprintf(val, "%s %s %s", app, eDir, (const char *)iniPath);
```

`ExecutableDir` dagegen kommt aus `GetModuleFileName` **ohne** Verkürzung
(`fileutil.cpp:433`) und ist lang, wenn der Anwender die EXE aus dem Explorer
startet.

**Gemessen** auf diesem Rechner (`Scripting.FileSystemObject.ShortPath` auf
einem eigens angelegten Verzeichnis; Gregors Prüfverzeichnisse wurden dafür
nicht angefasst):

```
LANG : …\Eudora72-1.0.114-release\Mailverzeichnis
KURZ : …\EUDORA~1.114\MAILVE~1
```

8.3 ist auf `C:` also **eingeschaltet**. Der Vergleich lautet damit

```
_tcsnicmp("…\EUDORA~1.114\MAILVE~1", "…\Eudora72-1.0.114-release\", nEigen)
```

und scheitert am siebten Zeichen des Namens (`~` gegen `7`). **`fremd = 1` auf
dem eigenen Mailverzeichnis.** Der Anwender, der einmal `Eudora starten.cmd`
benutzt hat und danach die EXE doppelklickt, bekommt die Warnung *„belongs to
another installation"* über seinen **eigenen** Ordner.

Der Schaden ist in unserem Paketaufbau gering: `Mailverzeichnis\Eudora.ini`
liegt neben der EXE, „Nein" landet also wieder im selben Ordner. Er ist nicht
gering, wenn jemand sein Mailverzeichnis woanders führt — dann schiebt ihn die
**Vorgabe** in einen frischen Ordner, und seine Post sieht aus wie
verschwunden. Und er ist in jedem Fall das, wogegen Testfall (2) geschrieben
wurde: *„eine Meldung, die immer kommt, liest nach drei Tagen niemand mehr."*

<a id="k4"></a>

## K4 — der Präfixvergleich ohne Trennzeichen

Die Auftragsfrage, Fall für Fall durchgerechnet
(`_tcsnicmp(pKandidat, pEigenes, _tcslen(pEigenes))`):

| `pEigenes` | `pKandidat` | Ergebnis | richtig? |
|---|---|---|---|
| `C:\Eudora\` | `C:\Eudora2\Mail` | fremd | ja |
| `C:\Eudora` *(ohne Rückstrich)* | `C:\Eudora2\Mail` | **nicht fremd** | **nein** |
| `C:\Eudora\` | `C:\Eudora` | fremd | ja (kurzer Kandidat, Vergleich läuft ins Nullbyte) |
| `C:\Eudora\` | `c:\eudora\mail` | nicht fremd | ja |
| `C:\Eudora\` | `C:/Eudora/Mail` | fremd | **nein** |
| `Z:\Eudora\` *(Laufwerkszuordnung)* | `\\srv\share\Eudora\Mail` | fremd | **nein**, derselbe Ordner |
| `\\srv\share\e\` | `\\srv\share\e2\m` | fremd | ja |

Die zweite Zeile ist die gefährliche: ein Geschwisterverzeichnis gilt als
unseres. Heute kann sie nicht eintreten, weil `GetDirs` den Rückstrich anhängt
(`temp[1] = 0`). Das ist eine **Vorbedingung, die die Funktion nicht prüft,
nicht nennt und deren Bruch kein Test fängt** — und sie wird in einer anderen
Datei hergestellt. Nach der Behebung zu [K1](#k1) wird `ExecutableDir` an zwei
Stellen gefüllt; spätestens dann gehört die Prüfung in die Funktion selbst.

UNC gegen Laufwerkszuordnung und `/` gegen `\` sind echte Falschmeldungen,
beide in die misstrauische und damit harmlose Richtung.

<a id="k5"></a>

## K5 — ohne fremde `Eudora.ini` wird nicht gefragt, geschrieben wird trotzdem

```cpp
// eudora.cpp:3791-3792
if (!bHatEigeneIni)
    return false;
```

Der Kommentar sagt *„Dort steht keine Einrichtung — dann ist es auch keine
fremde."* Das stimmt für die `Eudora.ini`. Es stimmt nicht für das, was danach
geschieht: `GetDirs` → `CheckMailDirectory` nimmt das Verzeichnis, Eudora legt
dort `Attach\`, `Embedded\`, Postfächer, `eudora.log` und beim Beenden eine
frische `Eudora.ini` an. Gregors Anforderung lautete *„eine vorhandene
Installation nimmt keinen Schaden"*; ein fremdes Datenverzeichnis ohne INI —
eine frisch kopierte Sicherung etwa, oder ein Eudora, dessen INI woanders
liegt — bleibt ungefragt.

Dazu ein zweiter Punkt: geprüft wird die Existenz von **`szIni`**, entschieden
und benutzt wird **`szVerzeichnis`**. Nennt die Registry eine `Eudora.ini` in
einem anderen Ordner als Stück 1 — möglich, die beiden Pfade sind unabhängig —
dann beantwortet `bIniDa` eine Frage über einen Ordner, über den gar nicht
entschieden wird.

<a id="k6"></a>

## K6 — wo „Mail folder from:" lügt

`MailDirHerkunft` wird an zwei Stellen gesetzt: in `CheckMailDirectory`
(`fileutil.cpp:399`, **nur im Erfolgsfall**, nach allen Fehlerausgängen) und in
`StartEudoraWithDefaultLocation` (`eudora.cpp:4106`). Vier Wege, auf denen die
Angabe nicht stimmt:

1. **`UseAppData=1` wird verschwiegen.** `pHerkunft` wird auf
   `"DEudora.ini UseAppData=1 -> Application Data"` gesetzt (`:3904`), `buf`
   geleert — und unten, weil `buf` leer ist, von
   `"Application Data (nichts in Registry oder DEudora.ini)"` **überschrieben**
   (`:3948`). Der Dialog behauptet dann, in der `DEudora.ini` habe nichts
   gestanden. Dort stand genau der Schlüssel, der diesen Weg erzwungen hat.
2. **Application Data, das keines ist.** Scheitert im `if (!*buf)`-Block
   irgendetwas (kein `Shell32`, kein `SHGetSpecialFolderPath`,
   `CreateDirectoryMT` oder `GetShortPathName` ohne Erfolg), bleibt `buf` leer
   — `pHerkunft` steht aber schon auf `"Application Data …"`. `GetDirs("")`
   nimmt dann `EudoraDir = ExecutableDir` (`fileutil.cpp:503`), also das
   **Programmverzeichnis**. Der Dialog nennt Application Data.
3. **Der häufigste Fall sagt „(unbekannt)", obwohl die Antwort bekannt ist.**
   Liegt eine `Eudora.ini` neben der EXE, läuft
   `StartEudoraWithDefaultLocation` gar nicht; `GetDirs` mit leerer
   Befehlszeile setzt `EudoraDir = ExecutableDir` **ohne**
   `CheckMailDirectory` — `MailDirHerkunft` bleibt leer. Richtig wäre
   „Programmverzeichnis".
4. **Ein gescheiterter Versuch löscht die Angabe nicht.** `CheckMailDirectory`
   setzt `MailDirHerkunft` erst hinter den `return (FALSE)`-Ausgängen; die
   Angabe eines früheren, erfolgreichen Aufrufs bleibt stehen. Bei den **zwei**
   `GetDirs`-Läufen eines gewöhnlichen Starts ist das erreichbar.

Was die Angabe **nicht** kann: über den Weg nach [K1](#k1) lügen. Dort wird
`pHerkunft` korrekt auf `"Registry: …"` gesetzt — nur eben ohne Rückfrage.

<a id="k7"></a>

## K7 — „Copied" steht auch dann, wenn nichts kopiert wurde

`OnClickedCopyInfo` (`AboutDlg.cpp:519-588`) behandelt den `HGLOBAL`
**richtig**: `GlobalUnlock` vor `SetClipboardData`, Eigentumsübergang nur bei
Erfolg (`hSpeicher = NULL`), sonst `GlobalFree`; `CloseClipboard()` wird auf
jedem Weg erreicht, der `OpenClipboard()` überlebt hat. Daran habe ich nichts
zu beanstanden.

Falsch ist das Ende:

```cpp
CloseClipboard();
SetDlgItemText(IDC_ABOUT_COPY, "Copied");
```

`EmptyClipboard()` ist zu diesem Zeitpunkt in **jedem** Fall gelaufen.
Scheitert `GlobalAlloc`, `GlobalLock` oder `SetClipboardData`, dann ist die
Zwischenablage des Anwenders **leer**, sein vorheriger Inhalt ist weg, und der
Knopf sagt „Copied". Er fügt in sein Ticket nichts ein und weiß nicht, warum.
Das ist „Anzeige ist kein Zustand" in zehn Zeilen Abstand.

<a id="k8"></a>

## K8 — die Trennregel, Zeile für Zeile gegen `GetDirs`

| Schritt | `GetDirs` (`fileutil.cpp:439-455`) | `E132AufrufZerlegen` (`eudora.cpp:3830-3885`) | gleich? |
|---|---|---|---|
| Trenner 1 | `strstr(CmdLine, "\" ")`, dann `*(++Ini)++ = 0` → vorderes Stück endet **mit** dem Anführungszeichen | `_tcsstr(pAufruf, _T("\" "))`, `pTrenner = pZitat + 1`, `nVorn` = Abstand → ebenso | **ja** |
| Trenner 2 | nur wenn das letzte Zeichen kein `"` ist: `strchr(CmdLine, ' ')` | gleiche Bedingung, gleicher Aufruf | **ja** |
| Hinteres Stück | `Ini` zeigt hinter das Leerzeichen, dann `TrimWhitespaceMT` | `pRest` überspringt Leerzeichen, dann Kopie | **ja** |
| Anführungszeichen | `StripQuotesMT`: entfernt ein führendes **und** ein abschließendes **unabhängig** voneinander | nur **paarweise** (`p[0]=='"' && p[n-1]=='"'`) | **nein** |
| Kurznamen | `GetShortPathName(Ini,Ini,…)` auf das hintere Stück | nicht | nein, ohne Folge (nur `FileExistsMT`) |
| Leerraum | nur hinteres Stück | beide Stücke, rechts | nein, ohne Folge |

Der eine echte Unterschied trifft eine verstümmelte Registry
(`"C:\Mein Mail` ohne schließendes Zeichen): `GetDirs` räumt das führende
Zeichen weg, wir nicht, und der Vergleich läuft dann gegen `"C:\…` — immer
„fremd". Kein Datenverlust, aber eine Falschmeldung.

**Puffergrenzen nachgerechnet, nichts gefunden:** `nVorn` wird auf
`nVerzeichnis - 1` geklemmt **bevor** kopiert wird, danach steht das Nullbyte
auf einem gültigen Index; `_tcsncpy(pIni, pRest, nIni - 1)` mit
`pIni[nIni - 1] = 0`; das `memmove` läuft nur bei `n >= 2` und schreibt
`p[n - 2]`. Der Zugriff `pAufruf[nLaenge - 1]` ist durch `!*pAufruf` gedeckt.
Beide Ausgabepuffer werden am Anfang genullt, auch wenn die Funktion sofort
zurückkehrt. Aufrufer: `TCHAR[MAX_PATH + 1]` gegen `sizeof()/sizeof(TCHAR)` —
stimmt.

<a id="k9"></a>

## K9 — der Weg „Abbrechen" schreibt nichts ins Protokoll

`E132SpurMerken` sammelt, `E132SpurAusgeben` schreibt — aber erst an
`eudora.cpp:1213`, nach `QCLogFileMT::InitDebug`. Dazwischen liegen vier
Ausgänge, die `InitInstance` mit `return FALSE` verlassen:

* `IDCANCEL` → `StartEudoraWithDefaultLocation` gibt `FALSE` (`:4060`)
* `err` gesetzt oder `GetDirs(buf)` falsch (`:4098`)
* `IsEudoraRunning()` (`:1048`)
* `InitDebug` selbst scheitert (`:1207`)

Auf allen vieren stirbt die gemerkte Spur mit dem Prozess. Die Zeile
`"E-132 Startverzeichnis: abgebrochen"` kann im Protokoll **nie** erscheinen —
sie wird gemerkt und danach weggeworfen. Dazu: ohne `DEBUG_MASK_MISC` (32768)
im `LogLevel` schreibt `PutDebugLog` ohnehin nichts; dass der Über-Dialog das
jetzt anzeigt, ist die richtige Antwort darauf.

Der Einbau ist trotzdem besser als vorher — zwei der drei Wege stehen jetzt im
Protokoll, vorher stand keiner darin. Aber die Behauptung *„auf allen drei
Wegen gemessen"* stützt sich beim dritten auf eine Beobachtung von außen, nicht
auf die eingebaute Messung.

<a id="k10"></a>

## K10 — kein Fund: die globale `CString` ist unbedenklich

Die Frage war: `static CString g_szE132Spur` (`eudora.cpp:3728`) wird vor
`InitInstance` konstruiert — hängt das von der Initialisierungsreihenfolge ab?
Der Konstruktor von `CStringT` holt die Nullzeichenkette über den
Stringverwalter, und der ist ein globales Objekt:

```cpp
// atlmfc/src/mfc/strcore.cpp:133-138
CAfxStringMgr afxStringManager;
IAtlStringMgr* AFXAPI AfxGetStringManager() { return &afxStringManager; }
```

Innerhalb **einer** Binärdatei wäre die Reihenfolge zwischen zwei
Übersetzungseinheiten nicht festgelegt. Hier sind es zwei: `Eudora.vcxproj`
trägt `<UseOfMfc>Dynamic</UseOfMfc>`, `afxStringManager` lebt also in
`MFC140.DLL`, und der Lader baut die Initialisierer einer eingebundenen DLL
**vor** denen der EXE. Dazu ruft kein anderer Initialisierer `E132SpurMerken`.
**Unbedenklich.**

<a id="k11"></a>

## K11 — Anzeige und Startbild

Die vier neuen `CTEXT` stehen bei `y = 188…215` DLU, je `280 × 10`
(`EudoraRes.rc:392-395`), die Knöpfe bei `y = 244`, der Dialog ist von 229 auf
269 DLU gewachsen. **Keine Überschneidung**, und die IDs `8313`–`8317` sind
frei (`_APS_NEXT_CONTROL_VALUE` wurde auf `8318` nachgezogen).

**Startbild richtig:** `m_IsSplash` schneidet die Höhe an der Unterkante von
`IDC_COPYRIGHT_INFO` ab (`AboutDlg.cpp:461-471`), also bei `y ≈ 169` DLU — die
neuen Zeilen beginnen bei 170 und liegen damit außerhalb. Der neue Knopf wird
zusätzlich ausdrücklich versteckt (`:496-500`). Nichts zu beanstanden.

**Abgeschnitten wird trotzdem:** Ein `CTEXT` ohne `SS_ENDELLIPSIS` bricht in
eine zweite Zeile um, die bei 10 DLU Höhe nicht mehr sichtbar ist. Pfade haben
keine Leerzeichen und werden deshalb nur hart beschnitten — das sieht man. Die
**Log-Zeile** hat welche: `"Log: …eudora.log  (LogLevel=32768)"` bricht genau
vor der Klammer um, und dann fehlt die Angabe, die die Zeile erklären soll.
Der Kopierknopf liefert über `GetDlgItemText` den **vollen** Text; wer liest,
sieht weniger als wer kopiert.

<a id="k12"></a>

## K12 — Altbestand, durch die neue Meldung sichtbar

`TCHAR cmdLine[MAX_PATH + 1];` ist nicht vorbelegt (`eudora.cpp:3891`). Nach
zwei gescheiterten Registry-Lesungen wird `*cmdLine` trotzdem gelesen
(`:3932`). `buf[0] = 0` davor rettet den Normalfall, aber ein zufälliges
Leerzeichen im Stapelmüll füllt `buf` mit Unsinn. Bisher fiel das durch
`if (err || …)` weg, bevor jemand etwas sah. **Jetzt steht die neue
`MessageBox` davor** (`:4002` vor `:4098`) und kann einen Müllpfad als
„another installation" anbieten.

Ebenfalls Altbestand, fürs Protokoll: `RegQueryValueEx` bekommt
`buflen = sizeof(cmdLine)` = 261 Byte, `RegisterCommandLine` schreibt aber bis
zu `3 × _MAX_PATH + 3` Byte (`:3673`). Eine lange Befehlszeile liefert
`ERROR_MORE_DATA`, danach ist `err` gesetzt und Eudora startet nicht — auch
dann nicht, wenn Application Data gefunden wurde.

---

<a id="k13"></a>

## K13 — der Fehlalarm, der die Behebung von K3 überlebt

Gefunden beim Nachrechnen der geplanten Behebung, **neu**, und er wird durch
`GetLongPathName` auf beiden Seiten **nicht** behoben.

Die beiden Seiten stehen nicht in derselben Schreibweise, und zwar nicht nur
bei 8.3:

* `RegisterCommandLine` **entfernt den Rückstrich**, bevor es schreibt
  (`eudora.cpp:3681-3684`):
  ```cpp
  //strip	tailing SLASH
  strcpy(eDir,EudoraDir);
  if (eDir[strlen(eDir)-1] == SLASH)
      eDir[strlen(eDir)-1] = 0;
  ```
* `GetDirs` **setzt ihn** (`fileutil.cpp:435`: `temp[1] = 0;`).

Solange das Mailverzeichnis ein **Unterordner** ist (`…\release\Mailverzeichnis`
gegen `…\release\`), fällt das nicht auf. Ist das Mailverzeichnis aber das
**Programmverzeichnis selbst** — der gewöhnliche Eudora-Aufbau, `Eudora.ini`
neben der EXE —, dann steht in der Registry `C:\…\Eudora72` und in
`ExecutableDir` `C:\…\Eudora72\`. `nEigen` ist dann **ein Zeichen länger als
der Kandidat**, `_tcsnicmp` läuft in dessen Nullbyte und meldet ungleich:
**`fremd = 1` auf dem eigenen Programmverzeichnis.**

Testfall (2) deckt das nicht ab, weil er `EIGEN` gegen `EIGEN` prüft — **beide
mit** Rückstrich. Die Registry liefert ihn nie so.

Heute ist dieser Weg nur über `:1017`/`:1029` erreichbar (vgl. [K1](#k1)):
liegt eine `Eudora.ini` neben der EXE, wird
`StartEudoraWithDefaultLocation` von `:1055` gar nicht erst gerufen. **Wird
[K1](#k1) behoben, wird K13 scharf.** Beide Behebungen müssen zusammen hinein.

---

<a id="antwort"></a>

## Antwort auf die vier Fragen zur geplanten Behebung

### 1. Reicht `GetLongPathName`? Was, wenn das Verzeichnis nicht existiert?

**Für die Kurzform ja, für den Vergleich nein.** Drei Teilantworten, alle
gemessen oder am Quelltext belegt.

**(a) Nicht roh aufrufen — `ConvertToLongPathName` nehmen.** **Gemessen** über
P/Invoke gegen `kernel32`, sechs Fälle:

| Eingabe | `rc` | `GetLastError` | Puffer |
|---|---|---|---|
| Kurzform, ohne Rückstrich | 161 | 203 | aufgelöst, **ohne** Rückstrich |
| Kurzform, **mit** Rückstrich | 162 | 203 | aufgelöst, **mit** Rückstrich |
| Langform, mit Rückstrich | 162 | 203 | unverändert, mit Rückstrich |
| Kurzform, Unterordner | 177 | 203 | beide Stufen aufgelöst |
| gibt es nicht (kurz) | **0** | 3 | **unberührt** |
| gibt es nicht (lang) | **0** | 3 | **unberührt** |

Zwei Dinge daran sind für die Behebung wichtig. Erstens: **der abschließende
Rückstrich bleibt erhalten** — die Vorbedingung aus [K4](#k4) überlebt die
Auflösung, `ExecutableDir` endet danach weiter auf `\`. Zweitens: bei
`rc == 0` bleibt der Puffer **unangetastet**; ein roher Aufruf in einen
uninitialisierten `TCHAR[]` liefert dann Stapelmüll. `CheckMailDirectory`
(`fileutil.cpp:354-356`) kennt die Falle und belegt den Puffer vorher — und
`ConvertToLongPathName` (`fileutil.cpp:903-915`) macht es richtig: `rc == 0`
oder `rc > _MAX_PATH` → `false`, `CString` unverändert. **Die gibt es schon,
sie ist in `fileutil.h:124` deklariert, und sie ist die richtige Wahl.**

**(b) Dass das Verzeichnis fehlt, ist der ungefährliche Fall.** Existiert der
Kandidat nicht, dann existiert dort auch keine `Eudora.ini` — `bIniDa` ist
`FALSE`, `E132IstFremdesVerzeichnis` kehrt an der zweiten Schranke um, und es
wird nicht gefragt. Die misslungene Auflösung kann also gar nicht in eine
Falschmeldung münden. **Gegenvermutung geprüft:** eine Lage, in der
`FileExistsMT` auf die `Eudora.ini` gelingt und `GetLongPathName` auf das
Verzeichnis scheitert, gibt es trotzdem — NTFS kennt *Traverse* ohne *List*,
und auf einem Netzlaufwerk kann die Auflösung mit `ERROR_ACCESS_DENIED`
zurückkommen. Dann steht der Kandidat kurz, `ExecutableDir` lang, und der
Fehlalarm ist zurück. **Empfehlung:** scheitert die Auflösung des Kandidaten,
nicht einfach weitervergleichen, sondern zusätzlich die **Kurzform** von
`ExecutableDir` (`GetShortPathName`) gegenhalten und nur dann „fremd" sagen,
wenn **beide** Formen fremd sagen.

**(c) Die Auflösung heilt nur eine von drei Ursachen.** Übrig bleiben
[K4](#k4) (Präfix ohne Trennzeichen) und [K13](#k13) (Rückstrich auf nur einer
Seite). Beide sitzen in der Vergleichsregel, nicht in der Schreibweise. Die
Regel unten erledigt alle drei zusammen.

**Vollständig wäre nur `GetFinalPathNameByHandle`** (Vista+, mit
`CreateFile`/`FILE_FLAG_BACKUP_SEMANTICS`): das löst zusätzlich
Laufwerkszuordnungen, `subst` und Verzweigungspunkte auf und würde auch die
Zeilen „Z:\ gegen UNC" und „`/` statt `\`" aus [K4](#k4) schließen. Das ist
mehr Aufwand als der Befund wert ist — aber es gehört genannt, damit niemand
die Langform für eine Normalform hält. **Sie ist keine.**

### 2. Weitere Stellen, an denen kurz gegen lang verglichen wird

**Gesucht** nach allen Vergleichen über `ExecutableDir`, `EudoraDir` und
`INIPath`. Fünf Stellen vergleichen zwei Verzeichnisse miteinander:

| Stelle | Vergleich | Form |
|---|---|---|
| `ContentConcentrator.cpp:241` | `EudoraDir.CompareNoCase(ExecutableDir)` | beide lang |
| `eudora.cpp:4657` | `_tcsicmp(ExecutableDir, EudoraDir)` | beide lang |
| `fileutil.cpp:750` | `EudoraDir.Compare(ExecutableDir)` | beide lang, **aber groß/klein-empfindlich** |
| `QCMailboxDirector.cpp:110` | `stricmp(szPath, EudoraDir)` | beide lang |
| `QCMailboxDirector.cpp:2455` | `szParentPathname.CompareNoCase(EudoraDir)` | beide lang |

**Keine davon mischt kurz und lang** — weil `CheckMailDirectory` `EudoraDir`
durch `GetLongPathName` schickt (`fileutil.cpp:354-356`) und `ExecutableDir`
aus `GetModuleFileName` ohnehin lang ist. Der neue E-132-Vergleich ist der
**einzige**, der eine Zeichenkette direkt aus der Registry gegen
`ExecutableDir` hält, und damit der einzige, der die Kurzform je zu sehen
bekommt.

Zwei Einschränkungen, beide Altbestand, beide gering:

* Scheitert `GetLongPathName` in `CheckMailDirectory`, bleibt `EudoraDir`
  **kurz** (der Puffer ist vorher mit der Kurzform belegt) — dann melden alle
  fünf Zeilen oben fälschlich „verschieden". Folgen: die
  `ContentConcentrator`-Profildatei und die `EPI`-Erweiterungen werden zweimal
  gesucht, `GetRegInfoFileAlternatePath` liefert einen zweiten Pfad. Nichts
  davon zerstört Daten.
* `fileutil.cpp:750` vergleicht **mit** Groß-/Kleinschreibung. Allein eine
  andere Schreibweise macht daraus „verschieden". Das ist falsch, aber
  harmlos — und es ist nicht neu.

### 3. Der Präfixvergleich ohne Trennzeichen — eine Regel für drei Fehler

Das steht als [K4](#k4) im Bericht, und [K13](#k13) ist derselbe Fehler von der
anderen Seite. Beide verschwinden mit **einer** Regel, die ohne Win32 auskommt
— die Funktion bleibt also für den Prüfstand fahrbar:

```cpp
// Vergleichslaenge OHNE abschliessenden Rueckstrich: die Registry speichert
// das Mailverzeichnis ohne (eudora.cpp:3681-3684), GetDirs haengt ihn an
// ExecutableDir an (fileutil.cpp:435). Beide Seiten muessen gleich enden.
size_t nEigen = _tcslen(pEigenes);
while (nEigen > 0 && (pEigenes[nEigen - 1] == '\\' || pEigenes[nEigen - 1] == '/'))
    nEigen--;
if (nEigen == 0)
    return false;

if (_tcsnicmp(pKandidat, pEigenes, nEigen) != 0)
    return true;                        // anderer Anfang -> fremd

// Praefix allein genuegt nicht: "C:\Eudora2" faengt mit "C:\Eudora" an.
// Es muss ENDEN oder ein Trennzeichen folgen.
const TCHAR cNach = pKandidat[nEigen];
return !(cNach == 0 || cNach == '\\' || cNach == '/');
```

Durchgerechnet, alle sieben Fälle aus [K4](#k4) plus die beiden aus
[K13](#k13):

| `pEigenes` | `pKandidat` | vorher | mit der Regel |
|---|---|---|---|
| `C:\Eudora\` | `C:\Eudora2\Mail` | fremd ✔ | fremd ✔ |
| `C:\Eudora` *(ohne)* | `C:\Eudora2\Mail` | **nicht fremd ✘** | fremd ✔ |
| `C:\Eudora\` | `C:\Eudora` *(Registry-Form)* | **fremd ✘** | nicht fremd ✔ |
| `C:\Eudora` | `C:\Eudora\` | fremd ✘ | nicht fremd ✔ |
| `C:\Eudora\` | `c:\eudora\mail` | nicht fremd ✔ | nicht fremd ✔ |
| `C:\Eudora\` | `C:\Eudor` | fremd ✔ | fremd ✔ |
| `C:\Eudora\` | `C:/Eudora/Mail` | fremd ✘ | fremd ✘ *(bleibt)* |
| `Z:\Eudora\` | `\\srv\share\Eudora\Mail` | fremd ✘ | fremd ✘ *(bleibt)* |

Die beiden, die bleiben, gehen in die misstrauische Richtung: es wird zu viel
gefragt, nie zu wenig. Sie brauchen `GetFinalPathNameByHandle` (siehe 1c) und
sind den Aufwand heute nicht wert — **aber sie gehören in den Kommentar der
Funktion**, damit der nächste Leser nicht denkt, der Vergleich sei vollständig.

**Gegentests, die dazugehören** (alle ohne Dateisystem, also im Prüfstand
fahrbar): `("C:\\Eudora2\\Mail", "C:\\Eudora", true)` muss **fremd** sein,
`("C:\\Eudora", "C:\\Eudora\\", true)` und
`("C:\\Eudora\\", "C:\\Eudora", true)` müssen **nicht fremd** sein. Dazu je ein
Fall für die Auflösung kurz/lang — der gehört aber in den **Aufrufer** und
braucht ein echtes Verzeichnis; mein Vorschlag ist, dafür keinen Testfall zu
bauen, sondern den Aufruf von `ConvertToLongPathName` in der Spurzeile
mitzuprotokollieren (`gefunden=` vor und nach der Auflösung). Dann steht die
Antwort beim nächsten Fehlerbericht im Protokoll statt in einer Vermutung.

### 4. Geht 1.0.114 so raus?

**Nein.** Als **Testpaket bei Gregor** darf es bleiben und soll es bleiben — es
hat gerade seinen Zweck erfüllt und einen Fehler gezeigt, den vier
Prüfdurchgänge nicht gezeigt haben. Als **Veröffentlichung** nicht, und zwar
nicht wegen [K3](#k3) allein:

| | muss vor der Veröffentlichung hinein | warum |
|---|---|---|
| [K1](#k1) | **ja** | ohne das ist [E-132](../BEFUNDE.md#e-132) auf vier von fünf Startwegen gar nicht behoben. Ein Befund, der in der Hälfte der Fälle nicht greift, darf nicht als behoben ausgeliefert werden |
| [K2](#k2) | **ja** | die **Vorgabeantwort** macht Eudora in jedem Pfad mit Leerzeichen startunfähig. Das ist schlimmer als der Fehler, den wir beheben |
| [K3](#k3) | **ja** | läuft bereits |
| [K13](#k13) | **ja**, zusammen mit [K1](#k1) | wird durch die Behebung von [K1](#k1) überhaupt erst erreichbar |
| [K7](#k7) | sollte | eine Zeile |
| [K4](#k4) Rest, [K5](#k5), [K6](#k6), [K8](#k8)–[K12](#k12) | nein | nachziehbar, nichts davon verliert Daten |

Dazu eine Bedingung, die nicht am Code hängt: **die Behebung muss an einem
Prüfstand rot gewesen sein, bevor sie grün ist** —
`C:\Temp\E132` taugt dafür nicht mehr. Nötig sind ein Verzeichnis mit
8.3-Alias (`Eudora72-1.0.115-release` genügt, gemessen) und eines mit einem
Leerzeichen im Pfad. Erst wenn beide den Fehler **zeigen** und nach der
Behebung nicht mehr, ist die Zeile „Gemessen" in `BEFUNDE.md` gedeckt.

---

<a id="behoben"></a>

## Was ich behoben habe

**Nichts am Quelltext.** Der Koordinator hat `Eudora71/Eudora/eudora.cpp` und
`Eudora71/Tests/TestE132.cpp` für seine eigene Behebung übernommen, solange
dieser Bericht lief; eine zweite Hand in denselben Dateien hätte seine Arbeit
beschädigt. Die Funde stehen deshalb vollständig hier, mit der Regel aus
[Punkt 3](#antwort) als fertigem Ersatztext.

**Offen und nicht zugeteilt:** [K7](#k7) (`AboutDlg.cpp`, eine Zeile),
[K5](#k5), [K6](#k6), [K11](#k11), [K12](#k12).
