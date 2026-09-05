# Aufgaben für die nächste Sitzung

Stand **06.09.2026**. Zweig `fehler-nach-1010`.
Einstieg: [WEITERMACHEN.md](WEITERMACHEN.md) · Maßstab: [ZIEL.md](ZIEL.md) ·
Belege: [BEFUNDE.md](BEFUNDE.md) und `Befunde/*.md`

Diese Datei ist die Arbeitsliste — was zu tun ist, in welcher Reihenfolge, und
für jeden Punkt die Fundstelle. Sie ist so geschrieben, dass ein Agent damit
sofort anfangen kann, ohne die Vorgeschichte zu kennen. Welcher Befund noch
gilt, sagt das **Verzeichnis am Anfang von [BEFUNDE.md](BEFUNDE.md)**.

> **Braucht der Punkt Visual Studio?** Ohne Compiler gehen: **A2, C1, D3a-Analyse**
> und jede Zählung. Alles unter „Ganz zuerst", B, C2 und E brauchen einen Bau
> oder einen Start. Die Aufteilung im Einzelnen steht in `WEITERMACHEN.md`,
> Abschnitt „Was ohne Visual Studio geht".

---

## Wo wir stehen

Maßgeblich ist die Tabelle in [ZIEL.md](ZIEL.md). Kurz: **Bau, Start und
Mailabruf sind belegt** (18 erfolgreich / 0 Fehler / 1 übersprungen aus frischem
Klon; POP3 über Port 995 mit TLSv1.3). Offen sind Kriterium 0 und vier Fehler in
der Bedienung.

---

## Ganz zuerst: die vier Fehler, die Gregor sieht

Alle vier stammen aus seiner Fehlerliste vom 05./06.09.2026 und stehen zwischen
ihm und einer benutzbaren Fassung. **An dreien arbeiten Agenten.**

| # | Was | Zustand |
|---|---|---|
| **1** | **Strg-N** (neue Nachricht) stürzt ab | in Arbeit |
| **2** | **Doppelklick** auf eine Nachricht öffnet sie nicht | in Arbeit |
| **3** | **Suchtreffer** lassen sich nicht anklicken | in Arbeit |
| **4** | Meldung **„Encountered an improper argument"** | offen |

Danach — und erst danach:

5. **Produktversion hochzählen** (`Releases/PAKETE.md` nennt die Stellen), mit
   `tools/bauen.ps1` bauen, mit `tools/paket-bauen.ps1` packen,
   **nicht** veröffentlichen.
6. **Einmal durchsehen**, weil ein Lauf mehrere ungeprüfte Behebungen auf einmal
   beantwortet: **E-25** (Kontoassistent, *Weiter*), **E-24** („In" nur noch
   einmal unter *Recent*), **E-4** (Beenden), **E-12** (Kontodaten werden
   gespeichert und wiedergefunden).
7. **Kriterium 0:** das ZIP auf einem Rechner **ohne** Visual Studio auspacken
   und starten. Das ist der einzige belastbare Nachweis, und er fehlt seit dem
   31.08.

---

## Was zuletzt erledigt wurde

Damit niemand einen dieser Punkte noch einmal anfängt.

| Befund | Was | Stand |
|---|---|---|
| **E-25** | Absturz nach *Weiter* im Kontoassistenten: **Doppelfreigabe in `NSImport`**, belegt durch die Windows-Fehlerberichte (`0xC0000374`, Heap-Beschädigung, letztes geladenes Modul `NSImport.eif`) | behoben, **ungeprüft** |
| **E-24** | „In" stand zweimal unter *Recent*: Zeigervergleich auf eine temporäre `CString` in `QCMailboxDirector.cpp:2560`; dabei `:1316` mitbehoben | behoben, **ungeprüft** |
| **B-3** | `OT501` aus dem Bau genommen — ein frischer Klon baut ohne Kniffe | behoben |
| **Z-3** | fehlende Projektabhängigkeit: `OEImport`/`NSImport`/`OLImport` und `plstclnt` linkten vor `QCUtils` | behoben, Verweise stehen in den Projektdateien |
| **E-7** | Bau-Kennung fehlte im Titel | behoben, von Gregor gesehen |
| **E-13** | beim Mailabruf war kein Fortschritt sichtbar | behoben, von Gregor gesehen |
| **Z-2 / Z-2b** | Umlaute in HTML-Mail, und ein zerrissenes UTF-8-Zeichen je Nachricht | behoben, von Gregor gesehen |
| **E-12** | `Eudora.exe Mailverzeichnis` wurde als Ini-*Dateiname* gedeutet | behoben, **ungeprüft** |
| **E-4** | Schreibzugriff durch einen ungeprüften Cast beim **Start** (sichtbar beim Beenden) | behoben, **ungeprüft** |
| **X-5** | Schranke gegen Commits auf einen toten Zweig, `tools/pruefe-branch.pl`, 15 Testfälle | behoben |
| **X-6** | ein Bau-Lauf meldete Erfolg, ohne gebaut zu haben; `tools/bauen.ps1` | behoben |

> ### E-11 ist zurückgenommen
>
> **E-11 war nie die Ursache des Absturzes im Kontoassistenten.** Die Ursache
> ist **E-25** — eine Doppelfreigabe in `NSImport`, gemessen an
> `0xC0000374` (`STATUS_HEAP_CORRUPTION`) in den Windows-Fehlerberichten. Alle
> Verdächtigen der Form „hier fehlt eine NULL-Prüfung" sind damit entlastet,
> auch `WizardImportPage.cpp:379 → :420`.
>
> **Die Fehlerklasse R-1 bleibt trotzdem bestehen** (`ReleaseBuffer` ohne
> `GetBuffer`, siehe A2). Sie ist ein echter Mangel — nur eben nicht dieser
> Absturz. Wer E-11 in einer älteren Datei findet, liest hier weiter.

„Ungeprüft" heißt: der Code ist geändert und gebaut, aber **niemand hat am
laufenden Programm nachgesehen**.

---

## Was offen bleibt

| Punkt | wo | braucht |
|---|---|---|
| **Die vier Bedienfehler** oben | — | Bau + Start |
| **Kriterium 0** — Paket auf einem Rechner ohne Visual Studio starten | C2, ZIEL.md | einen zweiten Rechner |
| **`tools/paket-pruefen.ps1`** prüft die Maschine statt das Paket und leitet zum Lizenzverstoß an | C1, PR-2.0 bis PR-2.3 | PowerShell, **kein** Compiler |
| **`ReleaseBuffer` ohne `GetBuffer`** — Fehlerklasse R-1, siehe A2 | A2, R-1 | Bau |
| **Neun Zeigerstellen** aus X-3 | D3a | Bau |
| **Hostnamenprüfung greift nicht** (sicherheitsrelevant) | `PORTIERUNG.md` | **zurückgestellt**, siehe unten |
| **CRLF-Dateien in der Arbeitskopie** — Eigenschaft der Arbeitskopie, nicht des Repos. `perl tools/zeilenenden-angleichen.pl` misst, `--aendern` behebt. In einem frischen Klon mit `core.autocrlf=false` sind es 0 | S-7, X-4 | perl |

---

## A — Die Fehlerklasse `ReleaseBuffer` ohne `GetBuffer`

### A2 · 24 Stellen sind zu ändern — ausgezählt

`ReleaseBuffer` ohne vorangehendes `GetBuffer` ist bei MFC 14 unzulässig:
`CStringT` zählt Referenzen. Eine VC6-Altlast, die sich erst zur Laufzeit meldet,
und zwar nur auf bestimmten Wegen. Das ist eine **Fehlerklasse**, kein Einzelfall.

Gemessen am 06.09.2026 mit `perl tools/releasebuffer-pruefen.pl` (Rückgabe 1,
sobald etwas zu tun ist; `--alle` zeigt auch die richtigen):

| Einstufung | Bedeutung | Anzahl |
|---|---|---|
| `ok` | richtiges Paar `GetBuffer`/`ReleaseBuffer` — **bleibt** | 116 |
| `falsch` | kein `GetBuffer`, Länge übergeben (kürzt) | **19** |
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
5. Die übrigen elf: `msgutils.cpp:2128/2165/2185/2265`, `POPSession.cpp:1747`,
   `SMTPSession.cpp:328/683`, `Imapdll/src/Network.cpp:179`, `guiutils.cpp:1605`,
   `PaigeEdtView.cpp:657`, `MAPI/recip.cpp:52`.
6. Die vier `LockBuffer`-Stellen (`Text2Html.cpp:912/939/955`,
   `PGHTMIMP.CPP:2944`) — dort ist der Ersatz **nicht** `Truncate`, sondern
   entweder `UnlockBuffer()` oder der Verzicht auf den Puffer.
7. `MimeStorage.cpp:270` — `Message.Empty()` statt `ReleaseBuffer(0)`.

**Ersatz beim Kürzen: `s.Truncate(n)`** oder `s = s.Left(n)`.

Erledigt sind seit dem 31.08.2026 `eudora.cpp:3372`, `fileutil.cpp:482` (mit
E-12) und `QCMailboxDirector.cpp:1316` (mit E-24). `ConConProfile.cpp:198` stand
früher in dieser Liste und gehört nicht hinein — dort steht ein `GetBuffer` auf
derselben Variablen davor.

**Zeilenangaben veralten.** Vor dem Ändern die Liste neu erzeugen, nicht diese
abschreiben.

---

## B — Was Gregor sieht

### B1 · Die vier Bedienfehler

Stehen oben unter „Ganz zuerst". Sie sind der erste Schritt, nicht ein Punkt
unter vielen.

### B2 · Gesperrte Werkzeugleisten-Knöpfe

`DrawDisabled` ist behoben (E-2), aber geprüft ist nur der Zustand, in dem die
Knöpfe **freigegeben** sind. Nachsehen, ob gesperrte Knöpfe erkennbar grau
erscheinen statt leer.

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

Solange das offen ist, ist **Kriterium 0 nicht nachweisbar**.

### C2 · Kriterium 0 auf einem Rechner ohne Visual Studio nachweisen

Das Release-Paket dort auspacken und starten. Das ist der einzige belastbare
Nachweis. Am 31.08. lief auf dem Win11-Rechner das **Debug**-Paket mit
beigelegten, nicht verteilbaren DLLs (**E-8**) — das zählt nicht.

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
