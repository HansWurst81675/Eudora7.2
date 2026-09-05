# Nachprüfung X-3 / D3a — die neun Zeigerstellen

**Geprüft am:** 2026-09-05 · **Agent:** ZEIGER · **Worktree:** `Eudora7.2-wt-zeiger`, Branch `wt/zeiger`
**Auftrag:** prüfen, nicht ändern. Keine Quelldatei angefasst; diese Datei ist die einzige Änderung.

---

## Kurzfassung

**gemessen:** Von den neun als „echte Kandidaten" gemeldeten Stellen halten **vier**
der Nachprüfung stand. **Vier sind nachweislich kein Befund**, eine ist harmlos.
Darunter ist **die als „der ernsteste der neun" bezeichnete Stelle 1** — die
Begründung, der Wächterblock habe kein `return`, ist **falsch**: er hat eines.

Die reine Messkette von X-3 stimmt dagegen: **gemessen:** eigener Lauf über
3295 Dateien ergibt **exakt 18 Treffer**, dieselben 18, die X-3 auflistet. Das
Werkzeug tut also, was behauptet wird. Falsch ist nicht die Zählung, sondern das
**Nachlesen** der Treffer.

---

## Tabelle: die neun behaupteten Stellen

| Nr | Stelle | Behauptung | Urteil | Begründung |
|---|---|---|---|---|
| 1 | `EuImap/src/ImapMailbox.cpp:1637` → `:1659` (`pImapCommand`) | Wächter `if (!pImapCommand) { ASSERT(0); … }` **ohne `return`**; im Release entfällt ASSERT → Zugriff. „Der ernsteste der neun" | **KEIN BEFUND** | **gemessen:** Der Wächterblock reicht von Zeile 1638 bis 1653 und enthält in **Zeile 1652 ein `return E_FAIL;`** — die Funktion wird verlassen, Zeile 1659 ist auf diesem Weg unerreichbar. |
| 2 | `Eudora/POPSession.cpp:896` → `:905` (`pDiskHost`) | auf dem Abrufpfad, Nachbar von P-1/P-2 | **KEIN BEFUND** | **gemessen:** In derselben Funktion steht Zeile 834/835 `if(!pDiskHost) return FALSE;`, und `pDiskHost` wird bis 905 nirgends neu zugewiesen (die Zuweisung in 891 ist auskommentiert). Zwischen 834 und 896 wird der Zeiger in 877 und 882 ohnehin dereferenziert. Die Prüfung in 896 ist tote Redundanz, 905 ist sicher. |
| 3 | `EuImap/src/ImapChecker.cpp:945` → `:953` (`m_pTaskInfo`) | Prüfung im umgebenden Block, Zugriff danach | **KEIN BEFUND (kein Zusatzrisiko)** | **gemessen:** Zeile 936 derselben Funktion (`DownloadNewMessagesToTmpTocMT`) dereferenziert `m_pTaskInfo` **ungeprüft und unbedingt**, 9 Zeilen vor dem Wächter. Wäre der Zeiger null, stürzt es bei 936 ab, nicht bei 953. Ein Wächter bei 953 ändert nichts; die Ungereimtheit liegt bei 936. |
| 4 | `EuImap/src/ImapMailbox.cpp:1022` → `:1051` (`pAccount`) | der Treffer, den X-1 plausibel nannte | **ECHT** | **gemessen:** `CImapAccountMgr::FindAccount` (`ImapAccountMgr.cpp:585`) hat drei `return NULL`-Wege und kann auch am Schleifenende NULL liefern; bei `pAccount == NULL` bleibt `bCheckMail` auf `true`, der Weg 1027 → 1030 → 1045 → 1051 ist offen und dereferenziert. |
| 5 | `EuImap/src/imapgets.cpp:735` → `:743` (`m_pAccount`) | „Passwortpfad" | **KEIN BEFUND** | **gemessen:** Der gesamte Rumpf von `CImapLogin::Login` steht zwischen `#if 0 // No longer used.` (Zeile 705) und `#endif` (Zeile 796). **Der Code wird nicht übersetzt.** Es gibt keinen Passwortpfad; die Funktion tut nur `return TRUE;`. |
| 6 | `Eudora/TocFrame.cpp:3968` → `:3973` (`pTocDoc`) | anderer Wächter | **ECHT** | **gemessen:** `CTocFrame::GetTocDoc()` (`TocFrame.cpp:3221`) gibt NULL zurück, wenn `m_wndSplitter.GetPane(0,0)` keine `CView` liefert. Der Zugriff in 3973 hängt am **fremden** Wächter `if (pFBView)`. Sind beide Panes weg, greift `if(pFBView)` und schützt zufällig mit; garantiert ist das nicht. |
| 7 | `Eudora/headervw.cpp:546` → `:551` (`pField`) | zwei Zeilen nach dem Block | **ECHT, aber harmlos** | **gemessen:** Textlich zutreffend (`ASSERT`+`if(pField)`, danach 551 ungeschützt). Aber `m_headerFields` wird ausschließlich in Zeile 135 mit `AddTail(DEBUG_NEW CHeaderField)` gefüllt — `DEBUG_NEW` ohne `NOTHROW` wirft statt NULL zu liefern. **VERMUTUNG:** der Wächter kann nicht auslösen. |
| 8 | `Eudora/PgEmbeddedObject.cpp:276` → `:303` (`pView`) | Block schließt nach drei Zeilen, Zugriff 27 später | **KEIN BEFUND** | **gemessen:** `pDoc` ist in 266 mit 0 vorbelegt und wird **nur** in Zeile 277 gesetzt, also **nur** innerhalb von `if (pView)`. Zeile 303 liegt in `if (pDoc && is_kind_of(...))` (284). `pDoc != 0` impliziert damit `pView != 0`. |
| 9 | `AccountWizard/Src/WizardImportPage.cpp:379` → `:420` (`pChild`) | Block schließt bei 411 | **ECHT — der ernsteste der neun** | **gemessen:** `pChild = (CImportChild*) m_ImportTree.GetItemData(hItem)` (372). Die Schwesterfunktion `SetupControls()` behandelt denselben Wert in Zeile 265 mit `if (NULL == pChild)` als Fehlerfall. Zusätzlich setzt Zeile 129 auf **Wurzelknoten** einen `CImportProvider*` in dieselbe Item-Data — wer einen Wurzelknoten ankreuzt, bekommt in 420 einen Zeiger vom falschen Typ. |

### Die drei „unklaren"

| Stelle | Urteil | Begründung |
|---|---|---|
| `EuImap/src/ImapAccount.cpp:3152` → `:3202` (`pImapCommand`) | **KEIN BEFUND** | **gemessen:** Zeile 3202 liegt zwischen `#if 0` (3168) und `#endif` (3211). Nicht übersetzter Code. |
| `Eudora/CompMessageFrame.cpp:644` → `:729` (`pMainFrame`) | **ECHT, geringe Gefahr** | **gemessen:** Wächter 644 schließt bei 694, Zugriff 729 liegt außerhalb. `pMainFrame = (CMainFrame*)AfxGetApp()->m_pMainWnd` (642). **VERMUTUNG:** beim Öffnen eines Verfassen-Fensters ist `m_pMainWnd` immer gesetzt; null wäre allenfalls beim Abbruch des Programmstarts denkbar. |
| `Eudora/StatMng.cpp:2399` → `:2407` (`pShortNum`) | **KEIN BEFUND** | **gemessen:** 2399 steht in `case averageSum:`, 2407 in `case total:` desselben `switch` — verschiedene Zweige, nie beide durchlaufen. Und 2377–2380 legt fest: entweder `pNum` **oder** `pShortNum` ist gesetzt; in 2404 wird genau darauf verzweigt. |

### Rangfolge der echten Befunde nach tatsächlicher Gefahr

1. **`WizardImportPage.cpp:420`** (`pChild`) — der einzige, bei dem eine **andere Stelle im selben Modul denselben Wert ausdrücklich als möglicherweise NULL behandelt** (`SetupControls`, 265). Dazu die Typverwechslung bei Wurzelknoten. Das ist der Assistentenpfad, auf dem Gregor die Abstürze E-6/E-9/E-11 gesehen hat.
2. **`ImapMailbox.cpp:1051`** (`pAccount`) — `FindAccount` gibt NULL für einen echten Fehlerfall zurück (Konto nicht gefunden), und der Weg bis zum Zugriff bleibt offen. IMAP-Abrufpfad.
3. **`TocFrame.cpp:3973`** (`pTocDoc`) — `GetTocDoc()` kann NULL geben, aber nur beim Abbau des Fensters, und dann fehlt vermutlich auch `pFBView`. **VERMUTUNG:** in der Praxis selten.
4. **`CompMessageFrame.cpp:729`** (`pMainFrame`) — Wächter, der praktisch nie auslöst.
5. **`headervw.cpp:551`** (`pField`) — Wächter, der nicht auslösen **kann**. Kosmetisch.

---

## Ist ASSERT im Release wirklich leer?

**Ja — gemessen, aber für Stelle 1 ohne Bedeutung**, weil der Wächterblock dort ein `return` hat.

Die Kette, Datei für Datei:

1. `Eudora71/EuImap/EuImap.vcxproj:86` — Release definiert `NDEBUG`, **nicht** `_DEBUG`.
   `Eudora71/Eudora/Eudora.vcxproj:132` genauso.
2. `ImapMailbox.cpp:28` bindet `stdafx.h` ein. `EuImap.vcxproj:60/85` führt `..\Eudora`
   im Suchpfad, also ist das `Eudora71/Eudora/stdafx.h`.
3. `Eudora71/Eudora/stdafx.h:54` — `#include "qcassert.h"  // ASSERT/VERIFY logging`.
4. `Eudora71/QCUtils/public/inc/qcassert.h` bindet erst `<afx.h>` ein, dann
   **unbedingt** `BugslayerUtil.h`. Der `#define ASSERT(expr) QCASSERT_WRAPPERMACRO(expr)`
   steht dort **nur im `#ifdef _DEBUG`-Zweig**. Im `#else`-Zweig (Release) definiert
   `qcassert.h` **nur** `VERIFYLOG` und `EXPRLOG` — `ASSERT` bleibt unangetastet.
5. `Eudora71/EuMemMgr/Include/BugslayerUtil.h:160` bindet `SuperAssert.h` ein.
6. `Eudora71/EuMemMgr/Include/SuperAssert.h:133-139` — im `#else` von `#ifdef _DEBUG`:

       #define NEWASSERT( exp )
       #define NEWVERIFY( exp ) ( (void) (exp) )

   und direkt danach, **außerhalb** jeder `_DEBUG`-Klammer, Zeile 141-145:

       #ifndef USE_OLD_ASSERTS
       #define ASSERT NEWASSERT
       #define VERIFY NEWVERIFY
       #define SUPERASSERT NEWASSERT
       #endif

7. **`USE_OLD_ASSERTS` ist im ganzen Baum nirgends definiert** — **gemessen:** die
   einzigen vier Fundstellen sind die `#ifdef`/`#ifndef`-Abfragen in `DiagAssert.h:282/286`
   und `SuperAssert.h:141/145` selbst. Also greift der `#ifndef`-Zweig, und
   `ASSERT` ist im Release **der leere Makrorumpf** `NEWASSERT`.
8. `SUPERASSERT` ist im Release **dasselbe leere Makro** (`SuperAssert.h:144`). Der
   Kandidat, der im Release etwas tun **könnte** — `OLDSUPERASSERT` mit Stack-Trace
   und Messagebox aus `DiagAssert.h:232` — ist im Release ebenfalls leer
   (`DiagAssert.h:261`) und wäre nur bei gesetztem `USE_OLD_ASSERTS` überhaupt an
   `SUPERASSERT` gebunden.
9. Auch ohne das alles wäre die Annahme richtig: MFCs eigenes `ASSERT` aus `<afx.h>`
   ist im Release `((void)0)`.

**Ergebnis:** Die tragende Annahme von X-3 stimmt — `ASSERT` und `SUPERASSERT`
erzeugen im Release keinen Code, und `ASSERT(0)` schützt dort nichts. Die Annahme
trägt trotzdem nichts, weil die Stelle, für die sie angeführt wurde, ein `return`
hat. Wer die Kette geprüft hat, hat den Quelltext daneben nicht zu Ende gelesen.

---

## Was das Werkzeug nicht findet

Vorweg, was es **richtig** macht: **gemessen:** eigener Lauf,
`perl tools/suche-zeiger.pl` über 3295 Dateien → **18 Treffer**, zeichengleich die
Liste aus X-3. Die neun Filter sind sauber gebaut und die Messkette ist ehrlich.

Die neun Filter, wie sie im Kopf stehen: (1) klammerloser `if`-Rumpf, (2) einzeiliger
Wächter mit Ausstieg, (3) keine Fenstergrenze bei der Blockende-Suche, (4) `else`
nach negiertem Wächter, (5) Zuweisung an den Zeiger, (6) erneute Prüfung (ternär,
`&&`), (7) `else` eines äußeren `if`, (8) Kommentare ausblenden, (9) Steueranweisung
als Rumpf.

### Das nachgewiesene Loch: der Namensfilter

Zeile 117 des Werkzeugs:

    next unless $name =~ /^(?:p[A-Z]|p[a-z]|m_p|fn|g_fn|q_fn|lp)/;

Jeder Zeiger, dessen Name nicht mit `p`, `m_p`, `lp` oder `fn` beginnt, ist
unsichtbar. **gemessen:** eine Kopie des Werkzeugs ohne diese eine Zeile, über
dieselben 3295 Dateien, liefert **40 statt 18 Treffer — 22 zusätzliche**, davon
13 im eigenen Code.

**Der Beleg, ein echter Befund derselben Bauart wie die neun** —
`Eudora71/Eudora/settings.cpp`:

    2935  CWnd* CtrlACAPButton   = GetDlgItem(IDC_ACAP_BUTTON);
    2936  CWnd* CtrlOKButton     = GetDlgItem(IDOK);
    2937  CWnd* CtrlCANCELButton = GetDlgItem(IDCANCEL);
    2939  if (CtrlACAPButton)     CtrlACAPButton->EnableWindow(FALSE);
    2941  if (CtrlOKButton)       CtrlOKButton->EnableWindow(FALSE);
    2943  if (CtrlCANCELButton)   CtrlCANCELButton->EnableWindow(FALSE);
    ...
    2953  CtrlACAPButton->EnableWindow(TRUE);
    2954  CtrlOKButton->EnableWindow(TRUE);
    2955  CtrlCANCELButton->EnableWindow(TRUE);

Drei Prüfungen, vierzehn Zeilen später dreimal derselbe Zugriff **ohne** Prüfung —
exakt das gesuchte Muster, dreifach, und `GetDlgItem` gibt bei fehlendem Steuerelement
tatsächlich NULL. Diese drei Stellen sind **stärker** als fünf der neun gemeldeten.
Das Werkzeug übersieht sie allein wegen der Schreibweise der Namen.

### Weitere Löcher, gemessen oder belegt

- **Yoda-Prüfungen.** Der Ausdruck kennt `if (p)`, `if (p != NULL)`, `if (!p)`,
  `if (p == NULL)` — **nicht** `if (NULL == p)`. Diese Schreibweise kommt im Baum
  vor, z. B. `WizardImportPage.cpp:265`, `POPSession.cpp:3028`,
  `FileBrowseView.cpp:2096`. **gemessen:** eine Kopie, die sie zusätzlich erkennt,
  findet 21 statt 18 Treffer; die drei Zusatztreffer sind hier allerdings alle
  Fehlalarm (jeder Wächterblock steigt aus). Das Loch ist real, kostet in diesem
  Baum aber nichts.
- **Der Präprozessor.** Das Werkzeug blendet Kommentare aus, aber keine
  `#if 0`-Blöcke. **gemessen:** 2 der 18 Treffer (`imapgets.cpp:735`,
  `ImapAccount.cpp:3152`) stehen in nicht übersetztem Code. Das ist ein
  Fehlalarm-Loch, kein Falsch-Negativ — aber es hat beim Nachlesen zwei Mal
  zugeschlagen und gehört in dieselbe Rechnung.
- **Filter 5 kann echte Fälle töten.** „Zuweisung an den Zeiger macht die Prüfung
  gegenstandslos" gilt nur, wenn die Zuweisung nicht selbst NULL liefern kann.
  `p = Irgendwas();` zwischen Prüfung und Zugriff schaltet den Treffer stumm, auch
  wenn `Irgendwas()` NULL zurückgeben darf. **VERMUTUNG:** das ist die
  Falsch-Negativ-Klasse mit dem höchsten Ertrag; nicht ausgezählt.
- **Filter 6 zählt jedes `p &&` als erneute Prüfung**, auch wenn es in einem
  ganz anderen Zweig steht als der Zugriff. Gleiche Wirkung: stummer Treffer.
- **Nur `p->` gilt als Zugriff.** `*p`, `p[i]`, `delete p`, `*p` als Argument —
  alles unsichtbar.
- **Das Suchfenster `$FENSTER = 40`.** Nach dem Blockende wird nur 40 Zeilen weit
  gesucht. `WizardImportPage.cpp` (Abstand 41 ab Wächter, aber nur 9 ab Blockende)
  ging gerade noch durch — ein Zugriff 50 Zeilen nach dem Blockende nicht mehr.
- **Nur der erste Treffer je Wächter** wird gemeldet (`last;`).

---

## Fazit in drei Sätzen: trägt D3a?

**Nein, nicht in der vorliegenden Form:** von den neun Punkten der Liste sind vier
nachweislich kein Befund (1, 2, 5, 8), einer bringt kein Zusatzrisiko (3) und einer
ist ein Wächter, der gar nicht auslösen kann (7) — es bleiben **drei bis vier echte
Stellen**, und die Reihenfolge steht auf dem Kopf, weil der als Nummer 1 geführte
„ernsteste" Fall ein `return` in Zeile 1652 hat und die tatsächlich gefährlichste
Stelle als Nummer 9 ganz unten steht.

Das Werkzeug selbst ist in Ordnung — die Messkette 347 → 18 ist reproduzierbar und
die Filterbegründungen halten —, aber es hat mit dem Namensfilter ein belegtes Loch,
durch das mindestens drei Stellen derselben Bauart fallen (`settings.cpp:2953-2955`),
die stärker sind als der Großteil der gemeldeten neun.

**D3a sollte auf die vier echten Stellen zusammengestrichen und neu geordnet werden**
(`WizardImportPage.cpp:420`, `ImapMailbox.cpp:1051`, `TocFrame.cpp:3973`,
`CompMessageFrame.cpp:729`), und die Lehre aus dieser Prüfung ist nicht „das Werkzeug
taugt nichts", sondern: **beim Nachlesen eines Treffers muss der Wächterblock bis zur
schließenden Klammer und die Datei auf `#if 0` gelesen werden** — beide Fehler haben
hier je zweimal zugeschlagen.
