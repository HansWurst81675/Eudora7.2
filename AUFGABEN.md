# Aufgaben für die nächste Sitzung

**Stand 07.09.2026, morgens.** Der Einstieg ist
[WEITERMACHEN.md](WEITERMACHEN.md), die Fassungsgeschichte mit allen Messungen
[CHANGELOG.md](CHANGELOG.md), der Maßstab [ZIEL.md](ZIEL.md). `main` ist
gesperrt; jeder Agent arbeitet in seinem eigenen Zweig ([AGENTEN.md](AGENTEN.md)).

## Die Hauptarbeit: Kriterium 4 bis 7

Kriterien 4 bis 6 hat Gregor am 06.09.2026 gesetzt, nachdem die ersten vier
gefallen waren; **7** ist am 07.09.2026 aus seinem Urteil zu 1.0.18
nachgetragen ([ZIEL.md](ZIEL.md)):

| # | | Stand |
|---|---|---|
| 4 | **Keine Abstürze** | nicht erfüllt |
| 5 | **Eine neue Mail schreiben und abschicken** | nicht erfüllt |
| 6 | **Eine Mail weiterleiten** | nicht erfüllt |
| 7 | ***File → Exit*** beendet Eudora sauber | nicht erfüllt |

**Die Wurzel ist gefunden und behoben: E-31.** Strg-N und *Weiterleiten*
beendeten Eudora mit `0xC00000FD` STATUS_STACK_OVERFLOW in `Paige32.dll`
(`pgInstallFont`, 525 Windungen tief). Ursache war `pg_time_t` in
`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`: acht Byte breit unter VS2022, vier in
der DLL von 2005 — damit war jede Paige-Struktur verschoben. Die Meldung, die
danach an die Stelle des Absturzes trat, ist ebenfalls behoben (**E-32**,
`CHeaderView::OnKillFocusRecipient`).

**Sieben Vermutungen sind auf dem Weg dahin widerlegt worden**, jede gebaut und
gemessen — die Liste mit Messwerten steht in [CHANGELOG.md](CHANGELOG.md) unter
7.2.0.17. **Nicht noch einmal durchprobieren.**

**Was jetzt zu tun ist: bauen, packen, Gregor geben.** Ob das Verfassen-Fenster
für den Anwender sichtbar wird, ob eine Mail zu schreiben ist und ob sich Eudora
mit *File → Exit* beenden lässt, hat niemand gesehen. Bis dahin gilt sein
Urteil zu 1.0.18: *„es crasht nicht, aber es passiert auch nichts. beenden kann
ich es auch nicht. nichts statt crash ist auch keine verbesserung!"*

Alles Übrige in dieser Datei ist **nebenbei**, nicht statt dessen.

## Erledigt seit 1.0.10

Von Gregor bestätigt: **Kriterium 0** (Paket startet ohne Visual Studio),
**E-30** (Symbole gesperrter Knöpfe), **E-28** (Doppelklick und Suchtreffer
öffnen die Nachricht). Dazu **E-26** (Ladeadressen im Absturzbericht),
**E-29** (`tools/absturz-auswerten.pl`) und die entfernte `dbghelp.dll` von
2005. Gemessen, aber von Gregor **noch nicht** nachgesehen: **E-31** und
**E-32**. Einzelheiten in [CHANGELOG.md](CHANGELOG.md).

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

Zwei sind behoben und bestätigt: Doppelklick und Suchtreffer öffnen die
Nachricht (**E-28**), gesperrte Knöpfe zeigen ihr Symbol (**E-30**). Was bleibt,
steht oben unter *Die Hauptarbeit* und in [ZIEL.md](ZIEL.md) als Kriterium 4
bis 7 — Verfassen, Weiterleiten, *File → Exit* und die Meldung „Encountered an
improper argument". Das ist der erste Schritt, nicht ein Punkt unter vielen.

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

### C1 · `paket-pruefen.ps1` ist unbrauchbar als Freigabekriterium (**PR-2**)

Zwei belegte Mängel:

1. **Es prüft die Maschine, nicht das Paket.** Gegenprobe: `EudoraRes.dll`,
   `QCSSL.dll`, `SPELL32.DLL`, `EuGraph.ocx` und `Plugins\` aus einer Kopie
   gelöscht → *„keine Fehler, EXIT=0"*.
2. **Bei einem Release-Paket erzeugt es vier Falschwarnungen** (feste
   Debug-Laufzeitliste, `:360`). Wer ihnen folgt, holt mit `laufzeit-holen.ps1`
   die **nicht verteilbaren** DLLs ins Paket — es leitet zum Lizenzverstoß an.

**Behebung:** die nötigen Laufzeiten aus den **Importen** der Paketdateien
ableiten, nicht aus einer Liste. Und „vorhanden" nur gelten lassen, wenn die
Datei **im Paket** liegt oder von Windows selbst stammt — nicht, wenn sie in
`SysWOW64` einer Entwicklermaschine steht. `tools/bauen.ps1` liest die
Importtabelle bereits; dort steht der Baustein.

Das hindert **Kriterium 0** nicht mehr — es ist am 06.09.2026 am lebenden Objekt
belegt (siehe C2). Es hindert nur, `paket-pruefen.ps1` als **Freigabekriterium**
zu benutzen: sein „keine Fehler" sagt nichts über das Paket.

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
Zeiger dort belegt sein müsste. Nach Dringlichkeit:

1. **`EuImap/src/ImapMailbox.cpp:1637` → `:1659`** (`pImapCommand`) — der Block
   des Wächters ist `if (!pImapCommand) { ASSERT(0); … }` **ohne `return`**. Im
   **Release** entfällt das `ASSERT`, dann läuft es weiter und greift auf den
   Nullzeiger zu. Der ernsteste der neun.
2. **`Eudora/POPSession.cpp:896` → `:905`** (`pDiskHost`) — auf dem Abrufpfad.
3. `EuImap/src/ImapChecker.cpp:945` → `:953` (`m_pTaskInfo`)
4. `EuImap/src/ImapMailbox.cpp:1022` → `:1051` (`pAccount`)
5. `EuImap/src/imapgets.cpp:735` → `:743` (`m_pAccount`)
6. `Eudora/TocFrame.cpp:3968` → `:3973` (`pTocDoc`)
7. `Eudora/headervw.cpp:546` → `:551` (`pField`)
8. `Eudora/PgEmbeddedObject.cpp:276` → `:303` (`pView`)
9. `AccountWizard/Src/WizardImportPage.cpp:379` → `:420` (`pChild`)

Die Behebung ist jeweils dieselbe Form: die Prüfung mitziehen (`if (p && …)`)
oder früh aussteigen. Drei weitere Treffer sind unklar und brauchen ein
menschliches Urteil (`ImapAccount.cpp:3152`, `CompMessageFrame.cpp:644`,
`StatMng.cpp:2399`).

**Nummer 9 ist nicht der Assistenten-Absturz** — der ist E-25, siehe oben. Die
Stelle bleibt trotzdem zu härten.

---

## E — Die Ersatzschicht

### E1 · `FloatControlBarInMDIChild` ist ein leerer Rumpf (**A-1**)

`WazooBarMgr.cpp:377-400` dockt danach das Adressbuch an, schickt
`ID_SEC_MDIFLOAT` (wirkungslos) und ruft `GetParentFrame()` — das liefert dann
**das Hauptfenster** statt eines `QCControlBarWorksheet`. Im Debug greift
`ASSERT_KINDOF`, **im Release läuft `MoveWindow` auf das Hauptfenster**.
Der größte verbliebene Rest im Erscheinungsbild, dazu die Splitter
(`SECDockBar::AddSplitter` wird nie gerufen).

### E2 · Der größte Eingriff an `OTShim.cpp` hat keinen Test (**PR-2**)

`1a4a6d5` ändert `OTShim.cpp` um **334 Zeilen**; `Eudora71/Tests/` blieb
unangetastet. `TestOTShimAndocken.cpp:214` prüft sogar noch das **alte**
Verhalten (`CalcDynamicLayout(0, LM_HORZDOCK) == 32767`).

### E3 · `SetControlBarWidthsInRow` ist noch leer

`OTShim.cpp:2244`, und `OnSizeParent` (`:3276`) reicht noch durch.

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
- **`Releases/PAKETE.md` hinkt hinterher** — der jüngste dort geführte Abschnitt
  ist 1.0.3, ausgeliefert ist 1.0.10. Wer das nächste Paket schnürt, trägt die
  Lücke nach. Weitere überholte Stellen in anderen `.md` stehen in
  [Befunde/LEKTOR.md](Befunde/LEKTOR.md).

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
