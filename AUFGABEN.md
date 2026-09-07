# Aufgaben für die nächste Sitzung

**Stand 07.09.2026, morgens.** Der Einstieg ist
[WEITERMACHEN.md](WEITERMACHEN.md), die Fassungsgeschichte mit allen Messungen
[CHANGELOG.md](CHANGELOG.md), der Maßstab [ZIEL.md](ZIEL.md). `main` ist
gesperrt; jeder Agent arbeitet in seinem eigenen Zweig ([AGENTEN.md](AGENTEN.md)).

## Die Hauptarbeit: das Beenden, zwei Kontofehler, die Reiterleiste

Kriterien 4 bis 6 hat Gregor am 06.09.2026 gesetzt, nachdem die ersten vier
gefallen waren; **7** ist am 07.09.2026 aus seinem Urteil zu Paket 1.0.18
nachgetragen, **8** noch am selben Tag aus seinem Wunsch nach sichtbaren
offenen Fenstern ([ZIEL.md](ZIEL.md)):

| # | | Stand |
|---|---|---|
| 4 | **Keine Abstürze** | fast — Strg-N fünfmal ohne Absturz gemessen, das Beenden fehlt noch |
| 5 | **Eine neue Mail schreiben und abschicken** | **erfüllt** — Gregor am 07.09.2026: *„mail können jetzt abgeschickt werden."* |
| 6 | **Eine Mail weiterleiten** | **erfüllt** — Gregor am 07.09.2026: *„weiterleitung funktioniert übrigens."* |
| 7 | ***File → Exit*** beendet Eudora sauber | **nicht erfüllt** — *„beenden geht nicht."* |
| 8 | Offene Fenster sichtbar und auswählbar | halb — das Menü *Window* listet sie, die Reiterleiste am unteren Rand fehlt |

**Damit bleiben vier Punkte.** Drei davon hat Gregor am 07.09.2026 an Paket
1.0.21 selbst gemessen: *„mail können jetzt abgeschickt werden. kann man die
untere zeile (status) immer anzeigen lassen? unter window menü sieht man die
beiden fenster. beenden geht nicht."* — dazu *„löschen der konten geht übrigens
auch nicht: auf toFix liste!"* (**E-37**) und *„obwohl daten (name, mailadresse,
server) im wizard eingetragen werden, fehlen diese beim konto->eigenschaften!"*
(**E-38**).

### 1. Kriterium 7 — das Beenden (E-33)

*File → Exit* beendet Eudora nicht. Das ist der einzige verbliebene **Fehler**
der zweiten Stufe; alles andere ist Ausstattung.

**Gregor hat am 07.09.2026 die entscheidende Messung gefahren:** *„exit: weder
alt+F4, noch x rechts oben funktionieren. da kommt wieder die meldung:"* — und
die Meldung ist **„Encountered an improper argument"**. Daraus folgt dreierlei:

1. Das Beenden **beginnt**. Kreuz und Alt-F4 gehen über `WM_SYSCOMMAND`/
   `SC_CLOSE` in dasselbe `CMainFrame::OnClose`; dass sie dasselbe Symptom
   zeigen wie *File → Exit*, schließt den Menüweg und damit
   `CFileBrowseView::OnAppExit` (`FileBrowseView.cpp:2218`) **aus**.
2. Der Abbruch ist keine stille FALSE-Rückgabe, sondern eine **geworfene
   Ausnahme**: „Encountered an improper argument" ist MFCs Text für
   `CInvalidArgException`. Damit ist es **dieselbe Fehlerklasse wie E-34** —
   MFC 14 prüft in seinen Sammlungen mit `ENSURE`/`ENSURE_ARG` und wirft auch
   im Release-Bau, wo MFC 6 nur ein `ASSERT` hatte.
3. Der Weg danach ist geklärt: `AfxCallWndProc` fängt (`wincore.cpp:270-277`),
   `CWinApp::ProcessWndProcException` (`appcore.cpp:1009-1039`) zeigt die
   Meldung und liefert **0** — `WM_CLOSE` gilt als beantwortet, das Fenster
   bleibt. Eudora überschreibt `ProcessWndProcException` nirgends.

**Zu suchen ist also die Stelle, die auf dem Weg von `WM_CLOSE` bis zum Ende
wirft** — ein Zugriff auf eine MFC-Sammlung (`operator[]`, `GetAt`, `RemoveAt`
auf `CPtrArray`, `CObArray`, `CMapStringToOb`), ein `ENSURE_VALID`, oder ein
Index, der aus einer Sammlung kommt. Weil das Fenster nach der Meldung noch da
ist, muss der Wurf **vor** `pApp->HideApplication()` (`winfrm.cpp:885`) fallen.

**Verdacht:** `QCCustomToolBar::SaveCustomInfo`
(`Eudora71/Eudora/QCCustomToolBar.cpp:421`, Zugriffe `:423`, `:424`, `:427`,
`:491`, `:508`) — dieselbe Form wie E-34: Grenze aus `GetBtnCount()`, Zugriff
über `m_btns[...]`, und MFC 14 führt in `afxcoll.inl:201-217`
`AfxThrowInvalidArgException()` **auch im Release-Bau** aus. Die Stelle liegt in
`CloseDown` Stufe 5 (`SaveBarState`) und wird im Betrieb **nur beim Beenden**
erreicht. **Belegt ist das nicht, behoben ist nichts.**

**Zwei Vermutungen sind auf dem Weg dahin widerlegt** — nicht wieder aufgreifen:
`GetWindowPlacement` prüft sein Argument nicht mit `ENSURE`
(`wincore.cpp:1214-1218`, nur `ASSERT`), und `CTocDoc::CanCloseFrame` wird gar
nicht erreicht, weil ein MDI-Hauptfenster keine Ansicht hat und
`GetActiveDocument()` NULL liefert. Statt dessen läuft
`pApp->SaveAllModified()` (`winfrm.cpp:874`).

**So wird es belegt — ein Bau, kein Suchen:** Paket schnüren, starten, beenden,
und die **letzte** `E-33`-Zeile in `eudora.log` lesen. 28 Marken liegen:
`QCCustomToolBar.cpp:408-415` vor der Schleife samt `TRY`/`CATCH_ALL` mit
`GetErrorMessage` und `THROW_LAST()` — der Ablauf bleibt unverändert, es wird
nur protokolliert —, `mainfrm.cpp` je **Aufruf** statt je Stufe (`5a`…`5i` in
`CloseDown` Stufe 5, `6a`…`6f` in `OnClose`), `eudora.cpp` an `OnAppExit` und
`ExitInstance`.

> **Zur Protokollmaske, berichtigt.** Ich hatte `LogLevel=32896` als *nötig*
> angegeben. Es ist ausreichend, aber nicht nötig: gemessen an Gregors Log vom
> 07.09.2026 enthält sein `LogLevel 25759` (0x649F) `DEBUG_MASK_MISC` (0x8000)
> **nicht**, wohl aber `DEBUG_MASK_TOC_CORRUPT` (0x80) — und `PutDebugLog`
> prüft nur, ob **ein** Bit gemeinsam ist (`QCUtils/src/debug.cpp:138-143`).
> Deshalb erscheinen bei ihm die `MAIN 32896:`-Zeilen ohne Zutun.

**Nicht mehr durchprobieren:** `CFileBrowseView::OnAppExit` (ausgeschlossen,
siehe oben) und die Vermutung, eine modale Meldung der Ersatzschicht verdecke
das Beenden (die modalen `AfxMessageBox` in `OTShim` sind durch
`OutputDebugString` ersetzt, `tools/pruefe-fensterbau.pl` hält das).

### 2. E-37 — erledigt: ein Konto ließ sich scheinbar nicht löschen

**Behoben am 07.09.2026, aber in keinem Paket.** Gregors Nachmessung hat die
erste Annahme widerlegt: auf die Frage „verschwindet der Eintrag nach einem
Neustart?" antwortete er *„ja, sie verschwinden nach neustart"* — gelöscht wurde
also immer korrekt, nur die Liste im Fenster blieb stehen. Damit war es kein
Datenfehler, sondern ein Anzeigefehler.

`FindItem` liefert −1, `DeleteItem(−1)` tut nichts, und abgesichert war das nur
mit `ASSERT(nIndex != -1)`. Behoben in
`CPersonalityView::OnCmdDeletePersonality` unabhängig davon, **warum**
`FindItem` scheitert: der Fehlschlag geht mit Name und Listenlänge ins
Protokoll, und die Liste wird einmal am Ende über `PopulateView()` neu
aufgebaut. Die drei stummen `ASSERT(0)`-Zweige melden jetzt ebenfalls.

**Was daran offen bleibt:** warum `FindItem` den Eintrag nicht findet, obwohl
Spalte 0 den rohen Kontonamen trägt (`PersonalityView.cpp:222-232`) und
dieselbe Zeichenkette bei `Remove` erfolgreich war. Die neue Protokollzeile
sagt es beim nächsten Lauf. **Nicht wieder von vorn suchen.**

### 3. E-38 — die Daten aus dem Kontoassistenten fehlen hinterher

Gregor am 07.09.2026: *„obwohl daten (name, mailadresse, server) im wizard
eingetragen werden, fehlen diese beim konto->eigenschaften!"* Zwei Kandidaten,
beide gelesen, **keiner gemessen**:

- **(a)** `OnSetActive` der Serverseiten setzt erst `m_str… = Params->…` und
  ruft dann `UpdateData(TRUE)` — also in die **falsche** Richtung, aus dem
  Steuerelement in die Variable (`WizardInServerPage.cpp:116-119`,
  `WizardOutServerPage.cpp:73-83`). Über beiden steht die richtige Fassung
  `//UpdateData(false)` auskommentiert. **Beide Zeilen stammen aus dem Original
  von 2006** (`git log -L`, `567a5d8`) — keine Regression der Portierung, aber
  unter MFC 14 kann die Aufbaureihenfolge der Seite anders sein.
- **(b)** `CPersonality::SavePersonaInfo` (`persona.cpp:924-1070`) bricht beim
  **ersten** fehlgeschlagenen `WriteStrHelper` ab und lässt alles Folgende
  ungeschrieben; der Aufrufer verpackt das in
  `VERIFY(g_Personalities.Add(...))` (`WizardPropSheet.cpp:193`), und `VERIFY`
  prüft im Release-Bau nicht. Die Schreibreihenfolge passt zum Symptom:
  POPAccount, RealName, ReturnAddress, DefaultDomain, SMTPServer, POPServer.

**Erste Messung ohne Bau:** in der `Eudora.ini` des Mailverzeichnisses den
Abschnitt `[Persona-<Name>]` ansehen. Fehlen `RealName`, `ReturnAddress` und
`SMTPServer` dort, ist es die Schreib- oder Übertragungsseite; stehen sie
richtig da, liegt der Fehler beim **Lesen** (`GetParams`, `persona.cpp:279ff`,
über `VERIFY` in `ModifyAcctSheet.cpp:47` ebenfalls stumm).

### 4. Kriterium 8 — die untere Statuszeile mit Reitern

Gregors Frage lautet wörtlich *„kann man die untere zeile (status) immer
anzeigen lassen?"*. Das Original hat sie: die **WazooBar**. Gelesen wird sie in
`Eudora71/Eudora/WazooBar.cpp:572,578` aus `Eudora.ini`, Abschnitt
`[WazooBars]`, Schlüssel `WazooBarIds`, `WazooBar%d`, `WazooMDI%d` (Namen in
`EudoraRes.rc:10637-10640`). Die Ersatzschicht `OTShim` bildet die Leiste
derzeit nicht nach — dort liegt der Ansatz, nicht in Eudora selbst.

### Was schon nachgemessen ist — nicht wiederholen

**Die Wurzel der Abstürze ist gefunden und behoben: E-31.** Strg-N und
*Weiterleiten* beendeten Eudora mit `0xC00000FD` STATUS_STACK_OVERFLOW in
`Paige32.dll` (`pgInstallFont`, 525 Windungen tief). Ursache war `pg_time_t` in
`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`: acht Byte breit unter VS2022, vier in
der DLL von 2005 — damit war jede Paige-Struktur verschoben.

Darauf folgten drei Fehler derselben Art, alle behoben und gemessen: **E-34**
(eine MFC-Ausnahme in `QCChildToolBar::GetButton` wickelte den ganzen
Fensterbau ab, ohne Meldung und ohne Absturz), **E-35** und **E-36** (blinde
Zeigerzugriffe an den Aufrufstellen, die E-34 erst sichtbar machte).

**Meine E-32-Ursachenbehauptung ist von PRUEFER widerlegt** —
`CHeaderView::OnKillFocusRecipient` war nicht die Ursache der modalen Meldung.
Das steht so im [CHANGELOG.md](CHANGELOG.md) unter 7.2.0.20.

**Sieben weitere Vermutungen sind widerlegt worden**, jede gebaut und gemessen —
die Liste mit Messwerten steht im [CHANGELOG.md](CHANGELOG.md) unter 7.2.0.21.
**Nicht noch einmal durchprobieren.**

Alles Übrige in dieser Datei ist **nebenbei**, nicht statt dessen.

## Erledigt seit 1.0.10

Von Gregor bestätigt: **Kriterium 0** (Paket startet ohne Visual Studio),
**E-30** (Symbole gesperrter Knöpfe), **E-28** (Doppelklick und Suchtreffer
öffnen die Nachricht). Dazu **E-26** (Ladeadressen im Absturzbericht),
**E-29** (`tools/absturz-auswerten.pl`) und die entfernte `dbghelp.dll` von
2005. **E-31 ist von Gregor mittelbar bestätigt** — ohne Paige-Fenster gibt es
kein Verfassen-Fenster, und er hat am 07.09.2026 mit 7.2.0.21 eine Mail
geschrieben und abgeschickt. Zu **E-32** siehe oben: Ursachenbehauptung von
PRUEFER widerlegt, der Code-Mangel behoben. Einzelheiten in
[CHANGELOG.md](CHANGELOG.md).

## Was sonst noch offen ist

| Punkt | wo | braucht |
|---|---|---|
| ***File → Exit*** bringt eine Meldung (**E-33**) | — | Bau + Start |
| Meldung **„Encountered an improper argument"** — MFCs `CInvalidArgException`, zweite Quelle neben dem behobenen E-16 | — | Bau + Start |
| **`ReleaseBuffer` ohne `GetBuffer`** — Fehlerklasse R-1, **16** Stellen bleiben (gemessen 07.09.2026) | A2, R-1 | Bau |
| **Neun Zeigerstellen** aus X-3 | D3a | Bau |
| **`EuMemMgr.dll` ist kein Projekt der Projektmappe** — vorgebaut, 2005, Version 7.0.0.9. Ausgerechnet sie löst den Aufrufstapel im Absturzbericht auf | — | — |
| **Hostnamenprüfung greift nicht** (sicherheitsrelevant) | `PORTIERUNG.md` | **zurückgestellt**, siehe unten |

---

## A — Die Fehlerklasse `ReleaseBuffer` ohne `GetBuffer`

### A2 · 21 Stellen sind zu ändern — ausgezählt

`ReleaseBuffer` ohne vorangehendes `GetBuffer` ist bei MFC 14 unzulässig:
`CStringT` zählt Referenzen. Eine VC6-Altlast, die sich erst zur Laufzeit meldet,
und zwar nur auf bestimmten Wegen. Das ist eine **Fehlerklasse**, kein Einzelfall.

Gemessen am 07.09.2026 mit `perl tools/releasebuffer-pruefen.pl` (Rückgabe 1,
sobald etwas zu tun ist; `--alle` zeigt auch die richtigen):

| Einstufung | Bedeutung | Anzahl |
|---|---|---|
| `ok` | richtiges Paar `GetBuffer`/`ReleaseBuffer` — **bleibt** | 116 |
| `falsch` | kein `GetBuffer`, Länge übergeben (kürzt) | **16** |
| `lockbuffer` | davor `LockBuffer` — der Partner ist `UnlockBuffer()` | **4** |
| `danach` | `GetBuffer` erst danach (`MimeStorage.cpp:270`) | **1** |

**Zu tun, in dieser Reihenfolge — nach Häufigkeit des Wegs, nicht nach Datei:**

1. `QCSharewareManager.cpp:1318` (`RetailVersion`) — **bei jedem Start**.
2. `sendmail.cpp:1782`, `:1788`, `:1815`, `:1865` (`szLine`) — **bei jeder
   gesendeten Klartextmail**. `CString szLine(pSrcLine, …)` bei `:1736`, dann
   `SetAt`, dann `ReleaseBuffer`.
3. `eudora.cpp:3466` (`RegClientsMail`) und `:3476` (`EudoraOption`) — beide in
   `CEudoraApp::RegisterURLSchemes()`, dem Weg jeder **frischen** Installation.
4. `mime.cpp:2020` (`m_CID`) — jede Nachricht mit `Content-ID` in `<…>`.
5. Die übrigen acht: `msgutils.cpp:2128/2165/2185/2265`, `SMTPSession.cpp:328`,
   `Imapdll/src/Network.cpp:179`, `guiutils.cpp:1605`, `MAPI/recip.cpp:52`.
6. Die vier `LockBuffer`-Stellen (`Text2Html.cpp:912/939/955`,
   `PGHTMIMP.CPP:2944`) — dort ist der Ersatz **nicht** `Truncate`, sondern
   entweder `UnlockBuffer()` oder der Verzicht auf den Puffer.
7. `MimeStorage.cpp:270` — `Message.Empty()` statt `ReleaseBuffer(0)`.

**Ersatz beim Kürzen: `s.Truncate(n)`** oder `s = s.Left(n)`.

Erledigt und darum nicht mehr in der Messung: `eudora.cpp:3372` (E-11),
`fileutil.cpp:482` (E-12), `QCMailboxDirector.cpp:1316` (E-24) — alle seit
31.08.2026 — sowie die drei Hesiod- und Drucktitel-Stellen
`POPSession.cpp:1747` und `SMTPSession.cpp:683` (beide `LoginName`, R-1) und
`PaigeEdtView.cpp:657` (`strTitle`, E-27); dort steht heute `Left(n)` mit einem
Befundkommentar daneben. `ConConProfile.cpp:198` stand früher in dieser Liste
und gehört nicht hinein — dort steht ein `GetBuffer` auf derselben Variablen
davor.

**Zeilenangaben veralten.** Vor dem Ändern die Liste neu erzeugen, nicht diese
abschreiben.

---

## B — Was Gregor sieht

### B1 · Die Bedienfehler, die Gregor merkt

Vier sind behoben und bestätigt: Doppelklick und Suchtreffer öffnen die
Nachricht (**E-28**), gesperrte Knöpfe zeigen ihr Symbol (**E-30**), eine Mail
lässt sich schreiben und abschicken (Kriterium 5) und weiterleiten
(Kriterium 6). Was bleibt, steht oben unter *Die Hauptarbeit*: **Kriterium 7**
(*File → Exit*) und **Kriterium 8** (die untere Reiterleiste), dazu die Meldung
„Encountered an improper argument". Das ist der erste Schritt, nicht ein Punkt
unter vielen.

### B2 · Gesperrte Werkzeugleisten-Knöpfe — **erledigt**

**E-30 ist behoben und von Gregor bestätigt** (Paket 1.0.14). Ursache waren die
sechs **24-Bit**-Bitmaps der Hauptleiste: ohne Farbtabelle konnte
`CreateMappedBitmap` das Buttongrau `192,192,192` nicht auf das heutige
`COLOR_BTNFACE` (`240,240,240`) umsetzen, und die Maske erfasste das ganze
Bildrechteck. Behoben in `OTShim/OTShim_Werkzeugleiste.cpp`, abgesichert durch
`tools/pruefe-symbole.pl` und `Eudora71/Tests/TestSymbole.cpp`.

### B3 · Die Umlaut-Gegenprobe ohne Start

Nach einem **neuen** Abruf (schon geholte Nachrichten bleiben kaputt, die rohen
Bytes stehen im Postfach):

```sh
perl tools/postfach-zeichen-pruefen.pl <Mailverzeichnis>\In.mbx
```

Es darf keine vollständige UTF-8-Folge mehr melden (Z-2b).

---

## C — Das Auslieferungspaket

### C1 · `paket-pruefen.ps1` — **behoben am 06.09.2026** (PR-2.0)

Zwei belegte Mängel, beide beseitigt:

1. **Es prüfte die Maschine, nicht das Paket.** Gegenprobe damals:
   `EudoraRes.dll`, `QCSSL.dll`, `SPELL32.DLL`, `EuGraph.ocx` und `Plugins\` aus
   einer Kopie gelöscht → *„keine Fehler, EXIT=0"*.
2. **Bei einem Release-Paket erzeugte es vier Falschwarnungen** (feste
   Debug-Laufzeitliste). Wer ihnen folgte, holte mit `laufzeit-holen.ps1` die
   **nicht verteilbaren** DLLs ins Paket — es leitete zum Lizenzverstoß an.

**Behoben in Commit `dfc8b40`:** die nötigen Laufzeiten werden aus den
**PE-Import- und Verzögerungstabellen** der Paketdateien abgeleitet statt aus
einer Liste (`tools/paket-pruefen.ps1:437`); ein Treffer in
`SysWOW64`/`System32` gilt ausdrücklich **nicht** als vorhanden (`:546`); beim
Debug-Paket weist es den Weg über `laufzeit-holen.ps1` selbst ab (`:577`). Drei
Gegenproben in `Befunde/PAKET.md:106-127`.

**Was weiter gilt:** das Werkzeug ersetzt keinen Startversuch auf einem fremden
Rechner. Es sagt, ob der Lader alles findet, was er vor dem ersten Befehl
braucht — nicht, ob Eudora läuft. **Kriterium 0** ist ohnehin am lebenden Objekt
belegt (siehe C2).

### C2 · Kriterium 0 auf einem Rechner ohne Visual Studio nachweisen — **erledigt**

**Erbracht am 06.09.2026** von Gregor selbst: `Eudora72-1.0.10-release.zip` auf
einem Rechner **ohne Visual Studio** ausgepackt und gestartet — *„test
bestanden: eudora läuft ohne VS2022 installiert."* Am 31.08. lief dort noch das
**Debug**-Paket mit beigelegten, nicht verteilbaren DLLs (**E-8**); das zählte
nicht, und deshalb stand diese Aufgabe hier.

### C3 · Warum musste das Mailverzeichnis von Hand dazugelegt werden?

Beide Pakete enthalten `Mailverzeichnis\Eudora.ini`. Ungeklärt (**E-6**).

---

## D — Werkzeuge und Quelltextanalyse

### D3a · Die neun Zeigerstellen aus X-3 beheben — **braucht einen Bau**

Prüfung vorhanden, Zugriff danach ungeschützt, kein erkennbarer Grund, warum der
Zeiger dort belegt sein müsste. **Neu gemessen am 07.09.2026** mit
`perl tools/suche-zeiger.pl <datei> …`; der Funktionsname steht dabei, weil die
Zeilennummern verrutschen (bei `headervw.cpp` allein um 34, seit E-32).

| # | Zeiger | Funktion | Prüfung → Zugriff |
|---|---|---|---|
| 1 | `pDiskHost` | `CPOPSession::DoReconcileUIDLInfo_` (`Eudora/POPSession.cpp`) | :896 → :905 — auf dem **Abrufpfad**, deshalb zuerst |
| 2 | `m_pTaskInfo` | `CImapChecker::DownloadNewMessagesToTmpTocMT` (`EuImap/src/ImapChecker.cpp`) | :945 → :953 |
| 3 | `m_pAccount` | `CImapLogin::Login` (`EuImap/src/imapgets.cpp`) | :735 → :743 |
| 4 | `pTocDoc` | `CTocFrame::OnClose` (`Eudora/TocFrame.cpp`) | :3968 → :3973 |
| 5 | `pField` | `CHeaderView::OnInitialUpdate` (`Eudora/headervw.cpp`) | :580 → :585 |
| 6 | `pAccount` | `CImapMailbox::OpenOnDisplay` (`EuImap/src/ImapMailbox.cpp`) | :1022 → :1051 |
| 7 | `pView` | `PgBindToObject` (`Eudora/PgEmbeddedObject.cpp`) | :276 → :303 |
| 8 | `pChild` | `CWizardImportPage::CopySettings` (`AccountWizard/Src/WizardImportPage.cpp`) | :403 → :444 |
| 9 | `pImapCommand` | `EuImap/src/ImapAccount.cpp` | :3152 → :3202 |

Die Behebung ist jeweils dieselbe Form: die Prüfung mitziehen (`if (p && …)`)
oder früh aussteigen.

> **Berichtigung (07.09.2026).** Als Nummer 1 und *„der ernsteste der neun"*
> stand hier: *„`EuImap/src/ImapMailbox.cpp:1637` → `:1659` (`pImapCommand`) —
> der Block des Wächters ist `if (!pImapCommand) { ASSERT(0); … }` **ohne
> `return`**. Im Release entfällt das `ASSERT`, dann läuft es weiter und greift
> auf den Nullzeiger zu."* **Das ist falsch.** Nachgesehen in
> `CImapMailbox::CheckMail`: der Block endet mit `return E_FAIL;`, nach dem
> Wächter ist der Zeiger also belegt.
>
> Es ist ein **Fehlalarm von `suche-zeiger.pl`**: bei einem **negativen**
> Wächter (`if (!p)`) sucht das Werkzeug das `return` nur in den nächsten sechs
> Zeilen, hier steht es fünfzehn Zeilen weiter. Das ist eine vierte
> Fehlerklasse neben den drei, die X-1 schon abgestellt hat, und sie gehört ins
> **Werkzeug**, nicht in diese Liste.
>
> Ebenfalls hier gestanden: drei *„unklare"* Treffer, `ImapAccount.cpp:3152`,
> `CompMessageFrame.cpp:644` und `StatMng.cpp:2399`. Am 07.09.2026 nachgemessen
> melden `CompMessageFrame.cpp` und `StatMng.cpp` **nichts** mehr;
> `ImapAccount.cpp:3152` ist ein gewöhnlicher positiver Wächter und steht jetzt
> als Nummer 9 in der Liste.

**Nummer 8 ist nicht der Assistenten-Absturz** — der ist E-25, siehe oben. Die
Stelle bleibt trotzdem zu härten.

---

## E — Die Ersatzschicht

### E1 · `FloatControlBarInMDIChild` ist ein leerer Rumpf (**A-1**)

`CWazooBarMgr::CreateNewWazooBar` (`WazooBarMgr.cpp`, heute Zeile 254) und
`CWazooBarMgr::SetDefaultWazooBarState` (heute Zeile 424) docken die Leiste an
und schicken danach `ID_SEC_MDIFLOAT`. Der Befehl läuft ins Leere:
`SECMDIFrameWnd::FloatControlBarInMDIChild` ist bewusst ohne Wirkung, weil MFC
kein Gegenstück dafür hat. Die Leiste bleibt angedockt, und `GetParentFrame()`
liefert weiterhin **das Hauptfenster** statt eines `QCControlBarWorksheet`. Im
Debug greift `ASSERT_KINDOF`, **im Release liefe `MoveWindow` auf das
Hauptfenster** — beide Stellen sind deshalb seit Befund **E-4** ausdrücklich
abgesichert; der Kommentar dazu steht im Quelltext daneben.
Der größte verbliebene Rest im Erscheinungsbild, dazu die Splitter
(`SECDockBar::AddSplitter` wird nie gerufen).

> **Berichtigung (07.09.2026).** Hier stand `WazooBarMgr.cpp:377-400` als
> Fundstelle. Dieser Bereich ist **vollständig auskommentiert** — jede Zeile
> beginnt mit `//FORNOW`. Die lebenden Stellen sind die beiden oben genannten.

### E2 · Der größte Eingriff an `OTShim.cpp` hat keinen Test (**PR-2**)

`1a4a6d5` ändert `OTShim.cpp` um **334 Zeilen**; `Eudora71/Tests/` blieb
unangetastet. `TestOTShimAndocken.cpp:214` prüft sogar noch das **alte**
Verhalten (`CalcDynamicLayout(0, LM_HORZDOCK) == 32767`).

### E3 · `SetControlBarWidthsInRow` ist noch leer

`SECDockBar::SetControlBarWidthsInRow` in `Eudora71/OTShim/OTShim.cpp` (heute
Zeile 2245) hat einen leeren Rumpf, und `SECDockBar::OnSizeParent` (heute
Zeile 3360) reicht noch an `CDockBar::OnSizeParent` durch.

---

## F — Offene Kleinigkeiten

- **`Out.mbx`-Größe 1.788.158.654 für eine leere Datei** — nicht initialisierter
  Wert im Protokoll, zwei Zeilen später steht korrekt 0.
- **`EUMAPI.DLL` ist eine 16-Bit-Datei** von 1995 (Signatur `NE`, belegt in
  Z-1). Niemand importiert sie. Kann vermutlich aus dem Paket.
- **`MFC71.DLL` und `MSVCP71.dll`** sind nicht nachbaubar (157 Ordinale, B-1).
  Adressbuch, LDAP und Ph fallen dauerhaft aus, solange die Fremd-DLLs von 2006
  benutzt werden.
- **Toter Include-Pfad** `..\OpenSSL\inc32` in `QCSocket.vcxproj:60` und das
  `OpenSSL`-Projekt in der Solution: gegen `libeay32.lib`/`ssleay32.lib` linkt
  kein Projekt mehr. Beides kann weg.
- **`Releases/PAKETE.md` hinkt hinterher** — einen eigenen Abschnitt haben
  1.0.21, 1.0.18, 1.0.3, 1.0.2 und 1.0.1; **1.0.4 bis 1.0.17 sowie 1.0.19 und
  1.0.20 fehlen** (Mangel **M-4**). In der Tabelle *Wo die Pakete liegen* stehen
  1.0.4, 1.0.10, 1.0.14, 1.0.15 und 1.0.19 mit Prüfsumme; 1.0.20 fehlt auch
  dort. Wer das nächste Paket schnürt, trägt seinen Abschnitt gleich mit ein.
  Weitere überholte Stellen in anderen `.md` stehen in
  [Befunde/LEKTOR.md](Befunde/LEKTOR.md),
  [Befunde/LEKTOR-3.md](Befunde/LEKTOR-3.md) und
  [Befunde/LEKTOR-4.md](Befunde/LEKTOR-4.md).

---

## Zurückgestellt — nicht von selbst aufgreifen

`tools/patches/zertifikatspruefung-verschaerfen.patch` (Hostnamensprüfung,
`X509_V_ERR_CERT_UNTRUSTED`). Gregor hat entschieden, das später anzugehen.
**Nicht ohne sein Wort anwenden.**

---

## Auflagen für Agenten

1. **Kein Programm mit Fenstern starten** ohne Absprache. Gregor testet auf
   derselben Windows-Sitzung. Beim Aufräumen von Prozessen **immer nach Pfad
   filtern** — sonst schießt man seine laufende Sitzung mit ab.
2. **Erst prüfen, dann anweisen.** Keine Handlungsanweisung ohne den Weg selbst
   gegangen zu sein. Ein Bauverzeichnis ist kein Startverzeichnis.
3. **Byte-erhaltend ändern:** `tools/aendere-zeile.pl`, `tools/ersetze-bereich.pl`.
   **Niemals `sed`** — das cygwin-`sed` wirft CR weg (X-1). Zum Messen `perl`
   mit `:raw`.
4. **Bauen mit `tools/bauen.ps1`**, in der PowerShell, nicht in der Git-Bash.
   Kein MSBuild-Aufruf von Hand mehr: am 05.09.2026 hat einer Erfolg gemeldet,
   ohne gebaut zu haben (X-6). Die Plattform heißt auf Projektmappenebene
   **`x86`**, nicht `Win32`. Visual Studio liegt unter **Professional**.
   **Die ganze Projektmappe bauen** — die `.lib` entstehen erst dabei.
   `/p:BuildProjectReferences=false` ist seit dem 05.09.2026 **nicht mehr nötig
   und nicht mehr erwünscht** (B-3).
5. **Zeilenangaben veralten**, sobald jemand dieselbe Datei anfasst (Z-1: sieben
   von elf Abweichungen waren genau das). Wer eine Fundstelle benutzt, prüft sie
   nach.
6. **In kleinen Schritten committen und pushen.** Was nicht gepusht ist, ist bei
   einem Abschalten verloren.
7. **Vor jedem Commit: auf welchem Zweig stehe ich, und lebt der noch?** Nicht
   aus dem Gedächtnis, sondern gemessen: `perl tools/pruefe-branch.pl --melden`.
   Der `pre-commit`-Hook prüft es als **ersten** Schritt und bricht ab. Wer den
   Hook nicht eingerichtet hat (`sh tools/hooks-einrichten.sh`), arbeitet ohne
   diese Schranke — sie liegt unter `.git/hooks` und wird nicht mitversioniert.
   Anlass war **X-5**: am 31.08.2026 lag drei Minuten nach einem Merge ein
   weiterer Commit auf genau dem zusammengeführten Zweig.
8. **Kündigt Gregor einen Merge an, läuft SOFORT `perl tools/gesichert.pl`** —
   vor jeder anderen Handlung, und das Ergebnis wird gemeldet. Rückgabewert `0`
   heißt gesichert, `1` nennt, was fehlt. Die Ansage ist der Auslöser, nicht der
   Nachweis: „es sollte alles committet und gepusht sein" ist eine Erwartung,
   kein Messwert.
9. **Nie direkt auf `main`.** Jede Änderung über einen eigenen Zweig; Gregor
   merged. Nach einem Merge durch ihn wird gewechselt, nicht auf dem alten Zweig
   weitergearbeitet:
   `git checkout main && git pull && git switch -c <neuer-name>`.
10. **Eine Auflage, die nur im Text steht, trägt nicht.** Das war der
    Entwurfsfehler hinter X-5. Wer eine neue Regel aufstellt, **baut die
    Schranke dazu** — ein Werkzeug mit Rückgabewert, eingehängt im Hook, und
    einen Testfall in einer Sammlung, der beweist, dass sie greift *und* dass sie
    nicht grundlos anschlägt. Beides gehört in denselben Commit wie die Regel.
11. **Die Doku gehört in denselben Commit wie die Änderung.** Gregor am
    07.09.2026: *„ich hasse es, wenn in den dokus falsche oder veraltete infos
    und werte stehen. das muss immer parallel gleich erledigt werden, klar?"*
    Wer einen Befund behebt, zieht `BEFUNDE.md`, `CHANGELOG.md` und, wenn der
    Stand sich ändert, `ZIEL.md` mit. Die Schranke dazu ist
    `perl tools/doku-pruefen.pl`; sie läuft im `pre-commit`-Hook, sobald eine
    `.md`, `VERSION` oder `Eudora71/Version.h` mit im Commit ist (Befund L-7).
12. **Zahlen und Fundstellen werden gemessen, nicht abgeschrieben.** Jede Zahl
    in der Doku braucht den Befehl, mit dem man sie nachzählt, daneben. Eine
    Zahl, die niemand pflegt, ist schlimmer als keine (Lehre L-6.10). Wo eine
    Zeilennummer unvermeidlich ist, gehört der **Funktionsname** dazu.
