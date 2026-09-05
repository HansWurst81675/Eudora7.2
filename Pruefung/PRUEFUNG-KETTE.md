# PRUEFUNG-KETTE — Gegenprüfung von Befund R-1 und `tools/releasebuffer-pruefen.pl`

Agent KETTE, Worktree `Eudora7.2-wt-kette`, Branch `wt/kette`, 05.09.2026.
**Es ist keine Quelldatei geändert worden.** Geprüft, nicht behoben.

Jede Aussage ist mit `gemessen:` oder `VERMUTUNG:` gekennzeichnet. „Gemessen"
heißt: aus einer Datei gelesen, die im Bericht mit Pfad und Zeile steht, oder
Ausgabe eines Befehls, der im Bericht steht.

---

## 0. Der Lauf des Werkzeugs

`perl tools/releasebuffer-pruefen.pl` (Laufzeit gut zwei Minuten, Rückgabe 1):

```
142 Vorkommen von ReleaseBuffer in 3511 Dateien untersucht.
Einstufung:
  falsch        20
  lockbuffer     4
  danach         1
  verdaechtig    0
  ok           117
```

**gemessen:** Die Zahlen aus R-1 sind reproduzierbar, alle fünf stimmen.

**gemessen:** Auch die Vollzähligkeit stimmt. Unabhängige Zählung:

| Messung | Ergebnis |
|---|---|
| `grep -rniE "ReleaseBuffer[[:space:]]*\(" --include=*.cpp --include=*.CPP --include=*.c --include=*.h --include=*.hpp --include=*.inl Eudora71` | 143 Zeilen |
| davon in `.CPP` (Großschreibung) | 1 |
| davon in `.h`/`.hpp`/`.inl`/`.c` | **0** |
| davon Kommentarzeile (`eudora.cpp:3372`) | 1 |
| echte Vorkommen | **142** |
| davon findet das Werkzeug | **142** |

**gemessen:** Es gibt kein `ReleaseBufferSetLength` im Baum (0 Treffer), also
keine Vorkommen, die das Werkzeug als anderen Aufruf verwechseln könnte.

**gemessen — Abweichung zu R-1:** R-1 schreibt, `[Funktionsanfang unsicher]`
komme im Baum nicht mehr vor. Es kommt **dreimal** vor:
`Text2Html.cpp:912`, `:939`, `:955`. Auf die Einstufung wirkt es sich dort
nicht aus (siehe Abschnitt 5).

---

## 1. Die Grundlage, die R-1 fehlt: was MFC 14 wirklich tut

R-1 führt unter „UNGEPRÜFT" auf, die MFC-Quellen lägen in dieser Umgebung
nicht vor. **gemessen: sie liegen vor**, in

`C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.38.33130\atlmfc\include\atlsimpstr.h`

Das ändert die Bewertung jeder einzelnen Stelle, deshalb steht es vor der
Tabelle. Wörtlich aus `atlsimpstr.h`:

```cpp
void ReleaseBuffer(_In_ int nNewLength = -1)
{
    if( nNewLength == -1 )
    {
        int nAlloc = GetData()->nAllocLength;
        nNewLength = StringLengthN( m_pszData, nAlloc);
    }
    SetLength( nNewLength );
}

void SetLength(_In_ int nLength)
{
    ATLASSERT( nLength >= 0 );
    ATLASSERT( nLength <= GetData()->nAllocLength );
    if( nLength < 0 || nLength > GetData()->nAllocLength)
        AtlThrow(E_INVALIDARG);
    GetData()->nDataLength = nLength;
    m_pszData[nLength] = 0;
}
```

**gemessen:** `ReleaseBuffer` ruft **kein** `Fork()` und kein
`PrepareWrite()`. Es schreibt ungeprüft in die Verwaltungsstruktur.
Daraus folgen genau zwei Schadensarten, und nur zwei:

1. **`n > nAllocLength`** → `AtlThrow(E_INVALIDARG)`. Das ist auch im
   Release-Build eine echte Ausnahme, kein weggelassenes ASSERT. **Das ist
   der einzige Weg, auf dem ein `ReleaseBuffer` abstürzen kann.**
2. **Puffer geteilt (`nRefs > 1`)** → die Kürzung trifft **alle** Mitbesitzer
   still mit. Kein Absturz, sondern stille Datenänderung an anderer Stelle.

**gemessen:** Ist `nRefs == 1` **und** `0 <= n <= nAllocLength`, dann tut
`ReleaseBuffer(n)` unter MFC 14 exakt dasselbe wie unter VC6: es kürzt.

**gemessen:** Geteilt wird ein Puffer beim Kopieren. Aus derselben Datei:

```cpp
CSimpleStringT(_In_ const CSimpleStringT& strSrc)
{ CStringData* pSrcData = strSrc.GetData();
  CStringData* pNewData = CloneData( pSrcData );   // AddRef, keine Kopie
  Attach( pNewData ); }
```
`operator=(const CSimpleStringT&)` geht denselben Weg. Ein `CString` aus
einem `const char*` dagegen bekommt einen eigenen Puffer.

**gemessen, für die Nebenfälle:**
* `Truncate(n)` = `GetBuffer(n)` + `ReleaseBufferSetLength(n)` — löst das Teilen
  auf und ist damit richtig. Die Behebung von E-11 ist handwerklich in Ordnung.
* `SetAt()` ruft intern `GetBuffer()`/`ReleaseBufferSetLength()`, hebt das
  Teilen also selbst auf, und wirft bei `iChar >= GetLength()`.
* `LockBuffer()` forkt und setzt `nRefs = -1`; `ReleaseBuffer` hebt das nicht
  auf. Die Zeichenkette bleibt bis zu ihrem Ende gesperrt.
* Die Leerzeichenkette (`CNilStringData m_nil`, `atlstr.h:153`) ist ein
  **beschreibbares** Feld des Verwalters mit `nAllocLength == 0`. Ein
  `ReleaseBuffer(0)` darauf ist folgenlos; ein `ReleaseBuffer(n>0)` darauf
  wirft.

**VERMUTUNG** (VC6-Quellen liegen hier nicht vor, das ist Erinnerungswissen):
VC6 rief in `ReleaseBuffer` zuerst `CopyBeforeWrite()`. Genau dieser eine
weggefallene Aufruf ist der Unterschied — und er betrifft **nur** Schadensart 2,
nicht Schadensart 1.

---

## 2. Tabelle: alle 25 beanstandeten Stellen, einzeln angesehen

Für jede Stelle wurde der ganze umgebende Funktionsrumpf gelesen; zusätzlich
**gemessen** für alle 20 `falsch`-Empfänger: `grep -cE "<Name>[[:space:]]*(\.|->)[[:space:]]*GetBuffer"`
über die **ganze Datei** ergibt jeweils **0** Treffer. Es gibt in keiner der
20 Dateien ein `GetBuffer` auf dem beanstandeten Empfänger — auch nicht
außerhalb der geschätzten Funktionsgrenzen.

**gemessen:** Keine der 25 Stellen steht in einem `#if`/`#ifdef`-Block
(eigenes Skript über alle Vorverarbeitungszeilen der 16 Dateien: durchweg
„kein #if"). Es ist also nirgends toter Code beanstandet worden.

Spalte „Urteil": *berechtigt* = kein `GetBuffer` vorhanden, die Meldung ist
richtig. Die Spalte „Wirkung" sagt, was unter MFC 14 tatsächlich passiert.

| Stelle | Werkzeug | mein Urteil | Wirkung / Begründung |
|---|---|---|---|
| `eudora.cpp:3403` `RegClientsMail` | falsch | **berechtigt** | `CString RegClientsMail(HLMMailto)` (:3399) **teilt** den Puffer mit `HLMMailto`. `LastSlash`=21 < Länge 28 ≤ Alloc → **kein Wurf**, aber `HLMMailto` wird mitgekürzt. `HLMMailto` wird nach :3403 nicht mehr gelesen (:3404–:3416 gemessen) → **folgenlos** |
| `eudora.cpp:3413` `EudoraOption` | falsch | **berechtigt** | `CRString`, eigener Puffer (`nRefs==1`), `SlashIndex`=15 < Länge 33 → reine Kürzung, **wie unter VC6**. Kein Wurf, keine Fremdwirkung |
| `sendmail.cpp:1782` `szLine` | falsch | **berechtigt** | `CString szLine(pSrcLine, n)` (:1736) → eigener Puffer; `SetAt` (:1780/1781) forkt ohnehin; `iLineLen` ≤ `GetLength()` → **wie VC6**, harmlos |
| `sendmail.cpp:1788` | falsch | **berechtigt** | dito, `iLineLen`+2 ≤ Länge (die Fundstelle von `"\r\n"` garantiert das) |
| `sendmail.cpp:1815` | falsch | **berechtigt** | `szLine[tempWWColumn]` wird eine Zeile vorher gelesen (:1812), also < Länge → harmlos |
| `sendmail.cpp:1865` | falsch | **berechtigt** | `iLineLen` stammt aus Indizes in `szLine` → ≤ Länge, harmlos |
| `QCSharewareManager.cpp:1318` `RetailVersion` | falsch | **berechtigt** | `CString(GetIniString(...))` aus `const char*` → eigener Puffer; `LastDot+1` ≤ Länge → harmlos |
| `POPSession.cpp:1747` `LoginName` | falsch | **berechtigt** | `szPOPAccount` ist `const char*` (`POPSession.cpp:1699`) → **kein** Teilen → harmlos |
| `Imapdll/src/Network.cpp:179` `LoginName` | falsch | **berechtigt** | `loginname` ist `const char*` (`Network.cpp:129`) → harmlos |
| `SMTPSession.cpp:683` `LoginName` | falsch | **berechtigt, und der gefährlichste Fall der 20** | `QCSMTPSettings::GetPOPAccount()` liefert **`CString&`** (`QCSMTPSettings.h:41`) → der Puffer wird geteilt → `ReleaseBuffer(At)` **kürzt die gespeicherte Kontoeinstellung** dauerhaft |
| `PaigeEdtView.cpp:657` `strTitle` | falsch | **berechtigt, zweitgefährlichster Fall** | `strTitle = pDoc->GetTitle()`; `CDocument::GetTitle()` liefert **`const CString&`** (`afxwin.h:5985`) → geteilt → `ReleaseBuffer(31)` **kürzt den echten Dokumenttitel** bei jedem Druck eines Titels über 31 Zeichen |
| `SMTPSession.cpp:328` `Recipient` | falsch | **berechtigt** | `Recipient = ++p` aus `char*` → eigener Puffer, harmlos |
| `mime.cpp:2020` `m_CID` | falsch | **berechtigt** | aus `const char*` zugewiesen → eigener Puffer; das Argument ist durch die Prüfung `CID[strlen(CID)-1]=='>'` immer ≥ 0 → harmlos |
| `msgutils.cpp:2128` `szPath` | falsch | **berechtigt** | `szPath = CString(ptr,len)` → eigener Puffer, `i` = Fundstelle < Länge → harmlos |
| `msgutils.cpp:2165` | falsch | **berechtigt** | dito, `GetLength()-1` hinter `IsEmpty()==FALSE` abgesichert |
| `msgutils.cpp:2185` | falsch | **berechtigt** | dito, `leftAngleBracketPos` per `ReverseFind` |
| `msgutils.cpp:2265` | falsch | **berechtigt** | dito |
| `fileutil.cpp:482` `EudoraDir` | falsch | **berechtigt, praktisch unerreichbar** | `EudoraDir` teilt auf einem Weg (`:466`) den Puffer mit der **globalen** `ExecutableDir`. Aber `ExecutableDir` endet immer auf `\` (`fileutil.cpp:414`, `temp[1]=0`), und der Zweig um :482 verlangt, dass das letzte Zeichen **kein** `\` ist (:476) → auf diesem Weg nicht erreichbar. Auf dem anderen Weg (`:378`, aus `char[]`) eigener Puffer |
| `guiutils.cpp:1605` `File` | falsch | **berechtigt** | `Filename` ist `const char*` (`DoFileCommand`, `guiutils.cpp:1473`) → eigener Puffer, harmlos |
| `MAPI/recip.cpp:52` `FullAddress` | falsch | **berechtigt** | mit `+=` aufgebaut → eigener Puffer, harmlos |
| `Text2Html.cpp:912` `szUrl` | lockbuffer | **berechtigt, geringste Dringlichkeit** | `LockBuffer` forkt und sperrt; `ReleaseBuffer` setzt die Länge richtig, entsperrt aber nicht. Folge: die Zeichenkette teilt bis zu ihrem Ende keinen Puffer mehr. Kein Absturz. **VERMUTUNG:** unter VC6 genauso, also keine Portierungsregression |
| `Text2Html.cpp:939` `temp` | lockbuffer | **berechtigt** | dito |
| `Text2Html.cpp:955` `szUrl` | lockbuffer | **berechtigt** | dito |
| `PGHTMIMP.CPP:2944` `translated_URL` | lockbuffer | **berechtigt** | dito |
| `MimeStorage.cpp:270` `Message` | danach | **berechtigt** | `Message` ist ein `CString&`-Rückgabeparameter. Auf einer leeren Zeichenkette schreibt `ReleaseBuffer(0)` in das beschreibbare `m_nil` → folgenlos; auf einer nicht-leeren geteilten kürzt es beim Aufrufer — was hier aber gerade die Absicht ist. Der richtige Weg bleibt `Empty()` |

Zusätzlich in derselben Funktion geprüft: `eudora.cpp:3372` (die behobene
Stelle) — siehe Abschnitt 4.

---

## 3. Falschmeldungen (zu Unrecht beanstandet)

**Keine. Null von 25.**

**gemessen:** Für alle 20 `falsch`-Stellen existiert in der gesamten
betroffenen Datei kein einziges `GetBuffer` auf dem gemeldeten Empfänger.
Für die 4 `lockbuffer`-Stellen und die eine `danach`-Stelle wurde der Code
gelesen; das Muster ist jeweils genau das, was das Werkzeug behauptet.
Keine der 25 steht in totem Code (`#if`-Messung, Abschnitt 2).

R-1 hat 8 der 20 von Hand gegengelesen und „kein Fehlalarm" geschrieben.
Das trägt jetzt für alle 20.

**Aber:** „berechtigt" ist nicht dasselbe wie „gefährlich". Das ist der
inhaltliche Einwand gegen R-1, nicht gegen das Werkzeug. R-1 sortiert die 20
nach „wie oft der Weg läuft" und stellt damit `sendmail.cpp` („bei jeder
gesendeten Klartextmail") weit nach oben. **gemessen:** an allen vier
`sendmail`-Stellen hat `szLine` einen eigenen Puffer und das Argument liegt
innerhalb der Länge — dort passiert unter MFC 14 buchstäblich dasselbe wie
unter VC6. Die richtige Reihenfolge nach tatsächlichem Schaden lautet:

1. `SMTPSession.cpp:683` — kürzt eine gespeicherte Kontoeinstellung
2. `PaigeEdtView.cpp:657` — kürzt den Dokumenttitel
3. alles Übrige — Vertragsbruch ohne messbare Wirkung, gehört trotzdem
   ersetzt, weil die nächste Änderung am Umfeld ihn scharf macht

---

## 4. Ist E-11 vollständig behoben?

### 4a. Die Angaben aus R-1 und WEITERMACHEN.md stimmen

**gemessen:** `CEudoraApp::RegisterURLSchemes()` reicht von
`Eudora71/Eudora/eudora.cpp:3274` bis `:3417` — genau wie behauptet, auf die
Zeile.

**gemessen:** Sie enthält drei `ReleaseBuffer`:

| Zeile | Stand im Quelltext |
|---|---|
| 3372 | `RegMailto.Truncate(i);	// war ReleaseBuffer(i) ohne GetBuffer - Befund E-11` |
| 3403 | `RegClientsMail.ReleaseBuffer(LastSlash);` — **unverändert** |
| 3413 | `EudoraOption.ReleaseBuffer(SlashIndex);` — **unverändert** |

### 4b. Erreichbarkeit — R-1 untertreibt sogar

**gemessen**, aus den Bedingungen:

* `:3372` steht in `if (bSetDefaultMailto)` (:3366).
* `:3403` steht in `if (bIsDefaultMailto)` (:3397) und `if (LastSlash >= 0)`.
* `:3344` lautet `if (bSetDefaultMailto || strstr(defMailto, appName)) bIsDefaultMailto = TRUE;`
  — aus `bSetDefaultMailto` folgt also **immer** `bIsDefaultMailto`.
* `:3413` steht **nur** in `if (SlashIndex >= 0)`, sonst unbedingt.

**Antwort auf die gestellte Frage: ja, und mehr als das.** Jeder Weg, der
`:3372` erreicht, erreicht auch `:3403`. `:3413` wird bei **jedem** Aufruf der
Funktion erreicht, unabhängig von jeder Antwort im Dialog. Klickt Gregor bei
frischer Installation im Warndialog `IDS_WARN_DEFAULT_MAILTO` (:3331) auf
Ja/Weiter, laufen alle drei.

**gemessen:** Die Funktion wird genau einmal gerufen, `eudora.cpp:1591`, aus
`InitInstance`.

### 4c. Warum die Frage trotzdem falsch gestellt ist

**gemessen**, Zeichenketten aus `Eudora71/Eudora/EudoraRes.rc`:

| Bezeichner | Wert | Länge | Argument | Ergebnis |
|---|---|---|---|---|
| `IDS_REG_MAILTO` (:3372) | `mailto\shell\open\command` | 24 | `Find('\\')` = 6 | 6 ≤ Alloc |
| `IDS_REG_HLM_MAILTO` (:3403) | `Software\Clients\Mail\Eudora` | 28 | `ReverseFind('\\')` = 21 | 21 ≤ Alloc |
| `IDS_REG_EUDORA_OPTION` (:3413) | `x-eudora-option\shell\open\command` | 33 | `Find('\\')` = 15 | 15 ≤ Alloc |

**gemessen:** In allen drei Fällen ist das Argument kleiner als die Länge,
also kleiner als `nAllocLength`. Nach `SetLength` (Abschnitt 1) **kann keine
der drei Stellen `AtlThrow` auslösen.**

**gemessen:** `CRString` ist `class CRString : public CString { CRString(UINT id){LoadString(id);} }`
(`Eudora71/Eudora/rs.h:12`) — ein frisch geladener, eigener Puffer.
`RegMailto` (:3287) wird bis :3372 nur an `RegOpenKey` und an `AddToRegistry`
gereicht; `AddToRegistry` nimmt `const char *` (`eudora.h:221`). Also
`nRefs == 1`.

**Folgerung, gemessen:** `RegMailto.ReleaseBuffer(6)` in der alten Fassung von
:3372 hätte unter MFC 14 dasselbe getan wie unter VC6 — auf 6 Zeichen gekürzt,
ohne Wurf und ohne Fremdwirkung. Dasselbe gilt für :3413. Für :3403 gilt es
mit der Einschränkung, dass `HLMMailto` mitgekürzt wird, was folgenlos bleibt,
weil `HLMMailto` danach nicht mehr gelesen wird.

**VERMUTUNG, klar als solche gekennzeichnet:** Damit ist keine der drei Zeilen
die Ursache des Absturzes gewesen. Die Behebung von E-11 hat an :3372 die
Schreibweise verbessert, aber vermutlich kein Verhalten geändert.

Zwei geprüfte Gegenhypothesen, damit die Vermutung belastbar bleibt:

* **`pMainFrame` ist NULL** (:3304, benutzt ohne Prüfung bei :3354/:3359,
  also zwischen dem Dialog :3331 und :3372). **Widerlegt, gemessen:**
  `m_pMainWnd` wird in `eudora.cpp:1431`/`:1449` gesetzt, lange vor dem Aufruf
  bei `:1591`.
* **`strrchr(MapiDLL,'\\') + 1`** (:3392), gefolgt von `strcpy` (:3393) —
  bei fehlendem Backslash ein Schreibzugriff auf Adresse 1. **VERMUTUNG:**
  `app` stammt aus `GetShortPathName(GetModuleFileName(...))` und enthält
  immer einen Backslash; unwahrscheinlich, aber nicht ausgeschlossen.

### 4d. Antwort in einem Satz

**Nein — aber nicht aus dem Grund, den R-1 nennt.** `:3403` und `:3413` sind
tatsächlich unverändert und tatsächlich auf demselben (bzw. einem weiteren)
Weg erreichbar; sie gehören ersetzt, weil `ReleaseBuffer` ohne `GetBuffer` der
falsche Vertrag ist. Aber ihre Behebung wird den Absturz **nicht** beheben,
denn gemessen an der ATL-Quelle kann keine der drei Zeilen abstürzen.

**Das ist die praktisch wichtigste Aussage dieses Berichts:** Wenn Gregor das
nächste Paket baut, in dem :3403 und :3413 auf `Truncate` umgestellt sind, und
es stürzt weiterhin ab, dann ist das **kein** Widerspruch und **keine**
Überraschung, sondern zu erwarten. Der Absturz auf frischen Installationen ist
weiterhin unerklärt und braucht einen Stapelabzug, keine weitere Quelltextsuche
nach `ReleaseBuffer`.

---

## 5. Übersehen (zu Unrecht als `ok` eingestuft)

Vorgehen: Statt die ersten 25 der 117 zu nehmen, wurden alle 117 mit einem
eigenen Skript nach struktureller Verwickeltheit sortiert (Abstand
`GetBuffer`→`ReleaseBuffer`, Klammerbilanz dazwischen, Schleifen/Zweige/
`return` dazwischen, mehrere `GetBuffer` auf demselben Empfänger, Argument
beim `ReleaseBuffer` trotz vorhandenem Paar). Die 30 obersten sind einzeln
gelesen worden. Zusätzlich lief ein gezielter Sucher auf das Muster
„zwischen dem letzten `GetBuffer` und diesem `ReleaseBuffer` steht bereits ein
anderes `ReleaseBuffer` auf derselben Variablen" — das Paar wäre dann schon
geschlossen.

### 5.1 Ein echter Fehlbefund: `QCMailboxDirector.cpp:1316`

```cpp
1305:	do
1306:	{
1307:		szFilename = szName;
1308:		LegalizeFilename( szFilename.GetBuffer( 0 ) );
1309:		szFilename.ReleaseBuffer();          // <- hier ist das Paar geschlossen
1310:
1311:		if( uCount )
1312:		{
1313:			CString szCount;
1314:			szCount.Format("%u", uCount);
1315:			if (!::LongFileSupportMT(szNewDir))
1316:				szFilename.ReleaseBuffer(8 - szCount.GetLength());   // ungepaart
```

**gemessen:** Das Werkzeug stuft `:1316` als `ok` ein, weil in derselben
Funktion vorher bei `:1308` ein `GetBuffer` auf `szFilename` steht. Dieses Paar
ist aber bei `:1309` **bereits geschlossen**, und beide Zeilen liegen auf
demselben geraden Weg — kein `if`/`else` dazwischen. `:1316` ist damit
inhaltlich genau dasselbe wie die 20 gemeldeten Stellen: ein Kürzen ohne
`GetBuffer`. **Es gehört in die Liste der zu ändernden Stellen. Aus 25 werden
26.**

**gemessen:** `szFilename` ist ein `CString&`-Parameter (`:1295`), gehört also
dem Aufrufer.

**gemessen — und hier ist es kein reiner Schönheitsfehler:** das Argument ist
`8 - szCount.GetLength()`, eine **feste Zahl, die nichts mit der Länge von
`szFilename` zu tun hat**. Ist `szFilename` kürzer als `8 - GetLength()`, wird
`SetLength` mit `nLength > nAllocLength` gerufen → `AtlThrow(E_INVALIDARG)`.
Das ist die einzige Absturzart, die `ReleaseBuffer` überhaupt hat, und sie
steht ausgerechnet an der Stelle, die das Werkzeug für in Ordnung hält.

**VERMUTUNG:** Erreichbar nur ohne Langdateinamen-Unterstützung
(`!LongFileSupportMT`) und bei Namenskollision (`uCount > 0`) — also selten.
Der Weg ist nicht nachgestellt worden.

Derselbe Sucher fand vier weitere Treffer, die **keine** Fehlbefunde sind:
`MAPI/mapifunc.cpp:121` und `:159`, `SwMapi/status.cpp:155` und `:169` — dort
liegen `GetBuffer`/`ReleaseBuffer` in `if`- und `else`-Zweig, es läuft also
immer nur eines von beiden. Richtig `ok`.

### 5.2 Ein Muster, das R-1 gar nicht behandelt: `LockBuffer` ohne Partner

R-1 schreibt: „Gemessen im Baum: 7 `LockBuffer`, aber nur 2 `UnlockBuffer`."

**gemessen, mit Wortgrenze und ohne Kommentarzeilen — beide Zahlen sind
falsch:**

| | R-1 | nachgemessen |
|---|---|---|
| `LockBuffer(`-Aufrufe im Code | 7 | **6** |
| `UnlockBuffer(`-Aufrufe im Code | 2 | **1** |

Die 7 entsteht, weil `grep "LockBuffer"` auch `UnlockBuffer` als Teilzeichenkette
trifft; die zweite Zahl zählt eine Kommentarzeile mit
(`DSPrintEdit.cpp:298`). Die tatsächlichen Stellen:

* `DSPrintEdit.cpp:112` `LockBuffer()` → `:113` `UnlockBuffer()` — **richtig**
* `PGHTMIMP.CPP:2938`, `Text2Html.cpp:910`, `:937`, `:953` — die vier, die
  R-1 als `lockbuffer` meldet
* **`qctree.cpp:269` `szText.LockBuffer()` — ohne jeden Partner**, weder
  `UnlockBuffer` noch `ReleaseBuffer`. Die Zeichenkette bleibt bis zum Ende
  ihres Gültigkeitsbereichs gesperrt.

Diese sechste Stelle steht in keiner Liste von R-1. Sie kann das Werkzeug
auch gar nicht finden, weil es ausschließlich an `ReleaseBuffer`-Zeilen
ansetzt (siehe Abschnitt 6).

### 5.3 Grenzfälle, die geprüft wurden und richtig `ok` sind

Damit nachvollziehbar ist, was *nicht* zu beanstanden war:

| Stelle | warum verwickelt | Urteil |
|---|---|---|
| `StripRich.cpp:219` (`this`) | `GetBufferSetLength` steht in :161 **oder** :175, also in zwei verschiedenen Zweigen | **richtig ok** — beide Zweige liegen in demselben `if`-Block wie das `ReleaseBuffer` (:154–:220), jeder Weg belegt den Puffer |
| `SearchEngine.cpp:1363` | `GetBuffer(FINDBUFSIZE+1)` **vor** der `while`-Schleife (:1286), `ReleaseBuffer(nRead)` **in** der Schleife → 1 `GetBuffer` zu N `ReleaseBuffer` | **richtig ok**, aber unsauber: `nRead ≤ FINDBUFSIZE ≤ nAllocLength`, also kein Wurf; `MakeLower()` (:1366) belegt nicht neu, `szBuffer` bleibt gültig |
| `AutoCompleteSearcher.cpp:991`/`:992` | `return` bei :964 zwischen `GetBuffer` und `ReleaseBuffer` | **richtig ok**; das übersprungene `ReleaseBuffer` ist unter MFC 14 wie unter VC6 folgenlos |
| `compmsgd.cpp:1633` | `GetBuffer` in einer `for`-Schleife, drei `break` davor | **richtig ok**, gleiche Begründung |
| `summary.cpp:1197`, `compmsgd.cpp:208`, `PgMsgView.cpp:497`, `guiutils.cpp:2682`, `guiutils.cpp:1371` | `GetBuffer` vor, `ReleaseBuffer` nach einer Schleife mit Zeigerarithmetik | **richtig ok** |
| `mapifunc.cpp:117/121/153/159`, `status.cpp:129/155/163/169` | `GetBuffer` im Bedingungsausdruck, `ReleaseBuffer` in beiden Zweigen | **richtig ok** |
| `X1EmailIndexItem.cpp:340`, `SpoolMgr.cpp:1235`, `QCStationeryDirector.cpp:448`, `headervw.cpp:1626`, `QComApplication.cpp:61`, `OTShim_Spur.cpp:121`, `ImapConnection.cpp:1120`, `Trnslate.cpp:6149`, `SearchManagerUtils.cpp:136`, `TridentView.cpp:3690/3692`, `WazooBar.cpp:700`, `eudora.cpp:4731/4751` | jeweils Argument, mehrfaches `GetBuffer` oder größerer Abstand | **richtig ok** |

**gemessen:** In keiner der 117 `ok`-Einstufungen liegt das Argument des
`ReleaseBuffer` über der beim `GetBuffer` angeforderten Größe — außer im Fall
`QCMailboxDirector.cpp:1316` aus 5.1, wo es gar kein offenes `GetBuffer` gibt.

### 5.4 Nebenbefund, außerhalb von R-1

**gemessen:** 233 `GetBuffer(`/`GetBufferSetLength(` gegen 142
`ReleaseBuffer(` im Baum. In `Text2Html.cpp` etwa stehen `GetBuffer` (:356)
und `GetBufferSetLength` (:859) auf `szDest`, aber **kein einziges**
`szDest.ReleaseBuffer` in der ganzen Datei. Das Werkzeug kann diese
Fehlerklasse grundsätzlich nicht sehen. **VERMUTUNG:** Sie ist harmloser als
E-11, weil `GetBuffer` ohne `ReleaseBuffer` unter VC6 wie unter MFC 14 nur
eine veraltete Länge hinterlässt — aber sie ist ungezählt.

---

## 6. Grenzen des Werkzeugs

Der Dateikopf nennt vier Grenzen. Sie wurden nachgemessen, indem eine kleine
Probedatei mit neun bewusst gebauten Fällen im Ablagebereich angelegt und
`perl tools/releasebuffer-pruefen.pl --alle <probe>` darauf angesetzt wurde.
**Alle Aussagen dieses Abschnitts sind gemessen, nicht überlegt.**

### 6.1 Wie der Funktionsanfang erkannt wird

Rückwärts bis zur nächsten Zeile, die mit `}` in Spalte 1 beginnt, höchstens
400 Zeilen (`$MAX_RUECK`). Reißt die Suche, steht `[Funktionsanfang unsicher]`
in der Ausgabe.

**gemessen:** Das trifft im Baum dreimal zu, alle in `Text2Html.cpp`
(:912, :939, :955). Die umgebende Funktion beginnt dort bei Zeile 321
(letzte `^}` davor: :320) und endet bei :1077 — 592 Zeilen, also über der
Grenze; gesucht wurde nur ab :512.

**Ist die Einstufung dort verlässlich? Ja, aber aus Glück.** gemessen: die
einzigen `GetBuffer` der Datei stehen bei :356 und :859 und beide auf
`szDest` — nicht auf `szUrl` oder `temp`. Der abgeschnittene Bereich
:321–:511 enthält kein `GetBuffer`. Hätte er eines enthalten, wäre die
Einstufung falsch gewesen, ohne dass die Ausgabe mehr gesagt hätte als
„unsicher".

**gemessen:** Bei eingerückter schließender Klammer (Klassenmethoden im
`class`-Rumpf, K&R-Stil) greift die Regel nicht; das Werkzeug läuft dann bis
zur nächsten Klammer in Spalte 1, also über die Funktionsgrenze hinweg. In der
Probe (`f5`, `C::m`) blieb das folgenlos, weil die Abstände klein waren.

### 6.2 Was in der Probe schiefging — vier Befunde

**a) Ein Vorkommen wird still verschluckt.** Die Probe enthält neun
`ReleaseBuffer(`; das Werkzeug meldet „8 Vorkommen … untersucht". Verloren
geht:

```cpp
s = "http://example.com";  s.ReleaseBuffer(3);
```

Der Kommentarentferner streicht alles ab `//` — auch das `//` **innerhalb
einer Zeichenkette**. Der Rest der Zeile, mitsamt dem `ReleaseBuffer`, ist
danach weg. **Das ist die gefährlichste Grenze, weil sie kein Rauschen
erzeugt, sondern schweigt.** Im Kopf des Werkzeugs steht nur, dass
Zeichenketten nicht ausgeblendet werden — dass sie den Kommentarentferner
ihrerseits stören können, steht nicht dort.

**gemessen, zur Entwarnung für diesen Baum:** Der Zählabgleich in Abschnitt 0
(142 gefunden gegen 142 echte Vorkommen aus `grep`) zeigt, dass im
Eudora-Baum derzeit **kein** Vorkommen auf diese Weise verlorengeht.

**b) `#if 0` wird nicht erkannt.** `t.ReleaseBuffer(5)` in einem `#if 0`-Block
wird als `falsch` gemeldet. Fehlalarm auf totem Code. (Im Baum ohne Wirkung:
gemessen, keine der 25 Stellen steht in einem `#if`.)

**c) Zeichenketten-Literale und `#define` erzeugen Fehlalarme.**
`const char* p = "call ReleaseBuffer(7) here";` wird als `falsch` mit dem
Empfänger `this` gemeldet; `#define RELEASE(x) x.ReleaseBuffer(9)` als
`falsch` mit dem Empfänger `x`. Beides steht im Dateikopf als Grenze,
beides ist bestätigt, beides kommt im Baum nicht vor.

**d) Zwei Denkfehler in der Einstufung selbst — die eigentlichen Grenzen:**

```cpp
void f7() { CString c;  if (0) { c.GetBuffer(30); }  c.ReleaseBuffer(7); }
```
→ **`ok`**. Das Werkzeug sucht das `GetBuffer` textlich im Funktionsrumpf und
kennt keinen Ablauf. Liegt das `GetBuffer` in einem Zweig, den der
`ReleaseBuffer`-Weg nicht durchläuft, meldet es trotzdem „richtiges Paar".

```cpp
void f8() { CString d;  char* r = d.GetBuffer(4);  d.ReleaseBuffer(400); }
```
→ **`ok`**. Das Werkzeug vergleicht die beiden Argumente **nie**. Genau dieser
Fall ist der einzige, der unter MFC 14 wirklich abstürzt
(`SetLength` → `AtlThrow`), und genau er fällt durch. `QCMailboxDirector.cpp:1316`
aus Abschnitt 5.1 ist die reale Ausprägung davon.

Ein dritter, verwandter Denkfehler steht in 5.1: **ein bereits durch ein
früheres `ReleaseBuffer` geschlossenes Paar zählt weiter als offen.** Das
Werkzeug merkt sich nur „irgendwo vorher stand ein `GetBuffer`".

**e) Was das Werkzeug richtig macht, obwohl es schwer ist:** `GetBuffer` auf
`a` und `ReleaseBuffer` auf `b` in derselben Funktion wird korrekt als
`falsch` gemeldet (Probe `f6`). Die vom Auftrag vermutete Verwechslung gibt es
im Baum nicht.

### 6.3 Die strukturelle Grenze

Das Werkzeug setzt ausschließlich an `ReleaseBuffer`-Zeilen an. Es kann
deshalb grundsätzlich nicht sehen:
* `GetBuffer` ohne `ReleaseBuffer` (91 Zeilen Differenz im Baum, Abschnitt 5.4),
* `LockBuffer` ohne jeden Partner (`qctree.cpp:269`, Abschnitt 5.2),
* dass ein Puffer geteilt ist — und das ist die Eigenschaft, auf die es unter
  MFC 14 allein ankommt (Abschnitt 1). `SMTPSession.cpp:683` und
  `PaigeEdtView.cpp:657` sind gefährlich, `sendmail.cpp:1782` ist es nicht;
  das Werkzeug stuft alle drei gleich ein.

### 6.4 Zum „Nachtrag" von R-1

R-1 vermerkt einen Fehler in `passt()` (Commit `26b52b8`, eine von vier
Aufrufstellen nicht nachgezogen, perl-Warnung bei jedem Lauf).
**gemessen: behoben.** Der Lauf in Abschnitt 0 gibt keine Warnung mehr aus;
`:151` ruft `passt()` mit drei Argumenten.

---

## 7. Fazit in drei Sätzen

**Der Befund R-1 trägt in seinem Kern: die Zahlen sind reproduzierbar, alle 25
Beanstandungen sind berechtigt, es ist keine einzige Falschmeldung darunter,
und mit `QCMailboxDirector.cpp:1316` ist sogar eine 26. Stelle hinzuzunehmen,
die das Werkzeug fälschlich als richtig durchgewinkt hat.**

**Er trägt nicht in seiner Dringlichkeitsaussage: gemessen an der
ATL-Quelle, die entgegen der Annahme von R-1 auf diesem Rechner vorliegt, kann
`eudora.cpp:3403` und `:3413` weder werfen noch fremde Daten beschädigen — und
die alte Fassung von `:3372` hätte es ebenso wenig gekonnt, weshalb E-11
vermutlich nie die Ursache des Absturzes war und der Absturz nach der nächsten
Behebung unverändert wiederkommen wird.**

**Die zwei Stellen, die unter MFC 14 wirklich Schaden anrichten, stehen in
R-1 ganz unten oder gar nicht — `SMTPSession.cpp:683` kürzt eine gespeicherte
Kontoeinstellung und `PaigeEdtView.cpp:657` den Dokumenttitel, weil beide
Zeichenketten einen geteilten Puffer besitzen; genau diese Eigenschaft ist
die, die das Werkzeug bauartbedingt nicht prüfen kann.**
