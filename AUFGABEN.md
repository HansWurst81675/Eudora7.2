# Aufgaben für die nächste Sitzung

Stand **05.09.2026, abends**. Zweig `bau-und-pruefung` (Commit `3d03c50`).
Einstieg: [WEITERMACHEN.md](WEITERMACHEN.md) · Maßstab: [ZIEL.md](ZIEL.md) ·
Belege: [BEFUNDE.md](BEFUNDE.md)

Diese Datei ist die Arbeitsliste — was zu tun ist, in welcher Reihenfolge, und
für jeden Punkt die Fundstelle. Sie ist so geschrieben, dass ein Agent damit
sofort anfangen kann, ohne die Vorgeschichte zu kennen. Welcher Befund noch
gilt, sagt das **Verzeichnis am Anfang von [BEFUNDE.md](BEFUNDE.md)**.

> **Braucht der Punkt Visual Studio?** Die Aufteilung steht in
> `WEITERMACHEN.md`, Abschnitt „Was ohne Visual Studio geht". Kurz: **A2, C1,
> D1–D4 und jede Zählung gehen ohne Compiler**; alles unter „Ganz zuerst",
> B1–B4, C2, C3 und E1–E3 brauchen einen Bau oder einen Start.

---

## Wo wir stehen

Maßgeblich ist die Tabelle in [ZIEL.md](ZIEL.md). Kurzfassung, Stand
**05.09.2026**:

| # | Kriterium aus ZIEL.md | Stand |
|---|---|---|
| 0 | Paket läuft ohne Nachinstallieren | **weiterhin nicht belegt** — nie auf einem Rechner ohne Visual Studio gestartet; `paket-pruefen.ps1` trägt nicht (PR-2.0 bis PR-2.3) |
| 1 | startet, Hauptfenster bedienbar | **erfüllt** — Gregor hat 7.2.0.4 gestartet und bedient |
| 2 | Darstellung korrekt | **fast** — E-7 (Titel) behoben, ungeprüft. **Offen: kein Fortschritt beim Mailabruf sichtbar** (E-13). Z-2 und Z-2b behoben, ungeprüft |
| 3 | Mailkonto verbinden und Mail abrufen | **erfüllt** — Gregor: *„mails lassen sich abrufen"* |

---

## Was am 05.09.2026 erledigt wurde

Damit niemand einen dieser Punkte noch einmal anfängt. Alle mit Commit belegt;
nachzählen mit
`git log --format='%h %ad %s' --date=format:'%d.%m %H:%M' d59cf63..HEAD`.

| Befund | Was | Commit | Stand |
|---|---|---|---|
| **B-3** | `OT501` aus dem Bau genommen — ein frischer Klon baut ohne Kniffe | `d8cc9d3` | **behoben** |
| **E-7** | Bau-Kennung fehlt im Titel | `bcc59bb` | behoben, **ungeprüft** |
| — | zwei Meldungen: Standard-Mailprogramm-Rückfrage raus, Wazoo-Text verständlich | `44224a5` | behoben, **ungeprüft** |
| **Z-2b** | ein einzelner Umlaut je Nachricht an der Lesestückgrenze zerrissen | `34c1d7f` | behoben, **ungeprüft** |
| **E-12** | `Eudora.exe Mailverzeichnis` wurde als Ini-*Dateiname* gedeutet | `79c09d4` | behoben, **ungeprüft** |
| **E-4** | Schreibzugriff durch einen ungeprüften Cast beim **Start** (sichtbar beim Beenden) | `1188e87` | behoben, **ungeprüft** |
| **Z-3** | fehlende Projektabhängigkeit in `Eudora.sln` belegt | `ee08b8e` | **offen**, nur belegt |
| **E-13** | Ursache für den unsichtbaren Fortschritt belegt und behoben | `bd3959c` auf `wt/fortschritt-arbeit` | **noch nicht in diesem Zweig** |

„Ungeprüft" heißt hier: der Code ist geändert und gebaut, aber **niemand hat am
laufenden Programm nachgesehen**. Das ist der erste Schritt unten.

---

## Ganz zuerst: 7.2.0.5 bauen, packen und einmal durchsehen

> ### Berichtigung vom 05.09.2026
>
> An dieser Stelle stand bis heute: *„Ganz zuerst: das Release auf dem zweiten
> PC probieren — am 31.08. um 09:00 nicht mehr geschafft."* **Das ist
> überholt.** Gregor hat am 05.09.2026 die Fassung 7.2.0.4 in der VM gestartet,
> bedient und Mail damit abgerufen. Die Belege zu 1.0.3 stehen unverändert in
> `BEFUNDE.md` (E-1, E-3, E-6, E-8, V-1).

**Der Grund für einen neuen Bau: „7.2.0.4" bezeichnet inzwischen mehr als einen
Bau.** `Releases/Eudora72-1.0.4-release.zip` (SHA256 `a3eb72e5…`) ist am 05.09.
um **19:22** gepackt worden — danach sind noch fünf Quelländerungen unter
derselben Produktversion gelandet (E-7 19:33, zwei Meldungen 19:45, Z-2b 20:14,
E-12 20:30, E-4 20:33). Das ist dieselbe Verwechslung wie in **V-1**.

**Zu tun, in dieser Reihenfolge:**

1. **Produktversion hochzählen** auf `7.2.0.5` / Paket `1.0.5`. Die fünf Stellen
   in zwei Dateien stehen in [Releases/PAKETE.md](Releases/PAKETE.md).
2. **Ganze Projektmappe bauen**, `Release|x86`, aus der PowerShell.
   `/p:BuildProjectReferences=false` **nicht** mehr benutzen (B-3). Danach die
   drei Prüfungen aus `README.md`, „Was den Bau kaputtmacht", Punkt 3 — ein
   Rückgabewert 0 allein trägt nicht.
3. **Packen** mit `tools/paket-bauen.ps1`, **nicht veröffentlichen**.
4. **Einmal durchsehen** — dieser eine Lauf beantwortet sieben offene Punkte:
   - **Titelzeile**: steht die Bau-Kennung von Anfang an da? (E-7, B2)
   - **Mail abrufen**: ist jetzt ein Fortschritt sichtbar? (E-13 — **nur, wenn
     `wt/fortschritt-arbeit` vorher zusammengeführt ist**)
   - **Umlaute**: neu abrufen, dann
     `perl tools/postfach-zeichen-pruefen.pl <Mailverzeichnis>\In.mbx`
     (Z-2b, B1)
   - **Beenden**: kommt die Meldung aus E-4 noch?
   - **Konto**: werden die Einstellungen gespeichert und wiedergefunden? (E-12)
   - **Meldungen**: kommt die Rückfrage nach dem Standard-Mailprogramm noch?
   - **Kriterium 0**: das ZIP auf einem Rechner **ohne** Visual Studio auspacken
     und starten (C2). Das ist der einzige belastbare Nachweis; er fehlt seit
     dem 31.08.
5. **Erst danach** an die offenen Punkte unten.

---

## Was offen bleibt

| Punkt | wo | braucht |
|---|---|---|
| **Kriterium 0** — Paket auf einem Rechner ohne Visual Studio starten | C2, ZIEL.md | einen zweiten Rechner |
| **Fortschritt beim Mailabruf** — Zweig `wt/fortschritt-arbeit` zusammenführen und nachsehen | E-13 | Bau + Start |
| **`tools/paket-pruefen.ps1`** prüft die Maschine statt das Paket und leitet zum Lizenzverstoß an | C1, PR-2.0 bis PR-2.3 | PowerShell, **kein** Compiler |
| **CRLF-Dateien in der Arbeitskopie** — gemessen am 05.09.2026 in `C:\Users\Gregor\Documents\github\Eudora7.2`: **800** Dateien liegen als CRLF vor, während in HEAD LF steht. Befehl: `perl tools/zeilenenden-angleichen.pl`. Behebbar mit `--aendern`. **Achtung: das ist eine Eigenschaft der Arbeitskopie, nicht des Repos** — in einem frischen Klon mit `core.autocrlf=false` sind es 0 | S-7, X-4 | perl |
| **`ReleaseBuffer` ohne `GetBuffer`** — gemessen am 05.09.2026 mit `perl tools/releasebuffer-pruefen.pl`: **141 Vorkommen, 117 richtig, 24 zu ändern** (19 `falsch`, 4 `lockbuffer`, 1 `danach`). Am 31.08. waren es 142/117/25; eine Stelle ist mit E-12 nebenbei erledigt (`fileutil.cpp:482`) | A2, R-1 | Bau |
| **`Z-3`** — fehlende Projektabhängigkeit in `Eudora.sln`: `OEImport`/`NSImport` linken vor `QCUtils` | Z-3 | Projektdatei, dann Gesamtbau |
| **Neun Zeigerstellen** aus X-3 | D3a | Bau |

---

## A — Zuerst: der Absturz auf frischen Installationen

**Dringend, weil er jeden neuen Anwender trifft.**

### A1 · Die Behebung prüfen lassen

`eudora.cpp:3372` wurde am 31.08. um 08:55 geändert — **nachgelesen, im Code
steht `Truncate`, nicht `Left`** (die frühere Angabe hier war falsch):

```cpp
RegMailto.Truncate(i);	// war ReleaseBuffer(i) ohne GetBuffer - Befund E-11
```

> **WICHTIG, neu am 31.08. abends (Befund R-1):** in **derselben Funktion**
> `CEudoraApp::RegisterURLSchemes()` (`eudora.cpp:3274-3417`) stehen **zwei
> weitere** Vorkommen derselben Art, unverändert: `:3403`
> (`RegClientsMail.ReleaseBuffer(LastSlash)`) und `:3413`
> (`EudoraOption.ReleaseBuffer(SlashIndex)`). Der Beleg aus `eudora.log` sagt
> nur, dass der Absturz **hinter `:3331`** liegt — nicht, dass er an `:3372`
> lag. **Stürzt es weiterhin ab, sind das die nächsten Verdächtigen.** Zwei
> Zeilen, ein Bau.

Ursache und Beleg stehen in **E-11**. Kurzfassung: `ReleaseBuffer` ohne
vorangehendes `GetBuffer` ist bei MFC 14 unzulässig — `CStringT` zählt
Referenzen. Auf Gregors VM fiel es nie auf, weil der Zweig nur bei einer
**jungfräulichen** Installation betreten wird (Eudora ist dort schon
`mailto`-Handler).

**Zu tun:** Release bauen, Paket schnüren, Gregor auf dem Win11-Rechner
probieren lassen: Assistent → *Weiter*. Der Bau lief beim Sitzungsende noch.

### A2 · Die Fehlerklasse abstellen — **25 von 142 Vorkommen**, ausgezählt

> **Das Werkzeug ist gebaut und gelaufen** (31.08.2026 abends): 
> `perl tools/releasebuffer-pruefen.pl` — Rückgabe 1, sobald etwas zu tun ist,
> `--alle` zeigt auch die richtigen. Vollständiger Befund mit allen Fundstellen,
> Gegenproben und Grenzen: **R-1** in `BEFUNDE.md`.

| Einstufung | Bedeutung | Anzahl |
|---|---|---|
| `ok` | richtiges Paar `GetBuffer`/`ReleaseBuffer` — **bleibt** | 117 |
| `falsch` | kein `GetBuffer`, Länge übergeben (kürzt) | **20** |
| `lockbuffer` | davor `LockBuffer` — der Partner ist `UnlockBuffer()` | **4** |
| `danach` | `GetBuffer` erst danach (`MimeStorage.cpp:270`) | **1** |

**Zu tun, in dieser Reihenfolge — nach Häufigkeit des Wegs, nicht nach Datei:**

1. `eudora.cpp:3403` und `:3413` — dieselbe Funktion wie der E-11-Absturz,
   läuft bei jeder frischen Installation. Siehe den Kasten in A1.
2. `QCSharewareManager.cpp:1318` (`RetailVersion`) — **bei jedem Start**.
3. `sendmail.cpp:1782`, `:1788`, `:1815`, `:1865` (`szLine`) — **bei jeder
   gesendeten Klartextmail**. `CString szLine(pSrcLine, …)` bei `:1736`, dann
   `SetAt`, dann `ReleaseBuffer`.
4. `mime.cpp:2020` (`m_CID`) — jede Nachricht mit `Content-ID` in `<…>`.
5. Die übrigen zwölf: `msgutils.cpp:2128/2165/2185/2265`, `POPSession.cpp:1747`,
   `SMTPSession.cpp:328/683`, `Imapdll/src/Network.cpp:179`,
   `fileutil.cpp:482`, `guiutils.cpp:1605`, `PaigeEdtView.cpp:657`,
   `MAPI/recip.cpp:52`.
6. Die vier `LockBuffer`-Stellen (`Text2Html.cpp:912/939/955`,
   `PGHTMIMP.CPP:2944`) — dort ist der Ersatz **nicht** `Truncate`, sondern
   entweder `UnlockBuffer()` oder der Verzicht auf den Puffer:
   `if (s.Right(2) == "\r\n") s.Truncate(s.GetLength()-2);`
7. `MimeStorage.cpp:270` — `Message.Empty()` statt `ReleaseBuffer(0)`.

**Ersatz beim Kürzen: `s.Truncate(n)`** — so ist E-11 behoben — oder
`s = s.Left(n)`.

**Nicht in der Liste, obwohl A2 sie früher nannte:** `ConConProfile.cpp:198`.
Nachgemessen: dort steht ein `GetBuffer` auf derselben Variablen davor, die
Stelle ist `ok`.

Das ist eine **Fehlerklasse**, kein Einzelfall: eine VC6-Altlast, die sich erst
zur Laufzeit meldet, und zwar nur auf bestimmten Wegen.

---

## B — Was Gregor sieht

### B1 · HTML-Umlaute: Wirkung prüfen

Behoben in `TridentView.cpp:1334-1351` und `msgutils.cpp:1625-1639` (**Z-2**),
übersetzt, **aber nie im Programm gesehen**. Eine HTML-Mail mit Umlauten öffnen.

Gegenprobe ohne Eudora-Start: nach dem Anzeigen liegt die Zwischendatei als
`%TEMP%\eud*.htm` (`TridentView.cpp:1469-1484`) — dort muss die
`charset=windows-1252`-Zeile als **erste** stehen und keine fremde
`charset`-Angabe mehr vorkommen.

**Am 05.09. gemessen und erledigt:** die Zwischendatei stimmt, die Ansage steht
als erste Zeile. Der verbliebene Rest von E-2 hatte eine **andere** Ursache und
liegt beim Abruf, nicht bei der Anzeige (**Z-2b**): ein UTF-8-Zeichen, das auf
die Grenze zweier Lesestücke fällt, wurde gar nicht übersetzt — genau **ein**
Umlaut je Nachricht kam als `fÃ¼r` heraus. Behoben in `utils.cpp` und
`TextReader.cpp`. **Zu prüfen bleibt: neu abrufen** (schon geholte Nachrichten
bleiben kaputt, die rohen Bytes stehen im Postfach) und danach
`perl tools/postfach-zeichen-pruefen.pl <Mailverzeichnis>\In.mbx` — es darf
keine vollständige UTF-8-Folge mehr melden.

### B2 · ~~Die Bau-Kennung fehlt im Titel (**E-7**)~~ — **behoben am 05.09.2026, zu prüfen**

Behoben in `bcc59bb`: ein einmaliges `OnUpdateFrameTitle(TRUE)` am Ende von
`CMainFrame::FinishInitAndShowWindow` (`mainfrm.cpp:1135`), also nachdem das
Fenster steht. Die Funktion hängt die Kennung nicht doppelt an, sie prüft das
selbst.

> Warum das mehr als Kosmetik ist: Seit Befund **V-1** sind unter `v1.0.3` drei
> verschiedene ZIPs veröffentlicht, und alle melden Produktversion `7.2.0.3`.
> Dasselbe gilt jetzt für **7.2.0.4** — das lokal gepackte Paket 1.0.4 ist vor
> fünf weiteren Quelländerungen desselben Tages entstanden. Die Bau-Kennung
> enthält den Commit und ist damit das einzige Merkmal am laufenden Programm,
> das die Bauten unterscheidet.

**Zu tun:** starten und auf die Titelzeile sehen. Erwartet wird etwas wie
`Eudora   [1.0.4+<commit> - …]`, **von Anfang an**, auch ohne geöffnetes
Postfach. Ein Sternchen hinter dem Commit heißt: beim Bau lagen ungesicherte
Änderungen vor.

### B3 · ~~Absturz beim Beenden (**E-4**)~~ — **behoben am 05.09.2026, zu prüfen**

> **Der Verdacht in diesem Punkt war falsch.** Hier stand: „`SECDockBar::
> MoveControlBarToPosition` baut `m_arrBars` von Hand um". Gregors Debug-Bau
> 7.2.0.4 hat etwas anderes gezeigt.

Die Ursache liegt **beim Start**, nicht beim Beenden: `WazooBarMgr.cpp` castet
an zwei Stellen per C-Cast — der prüft nichts — das **Hauptfenster** auf
`CMDIChildWnd`/`QCControlBarWorksheet` und schreibt hinein. Im Debug meldete
sich `ASSERT_KINDOF`, im Release ist `ASSERT` leer und der Schreibzugriff blieb.
`afxcoll.inl:213` beim Beenden war nur die Folge.

Behoben in `1188e87`: beide Blöcke sind mit `if (pWazooBar->IsMDIChild())`
verriegelt (`WazooBarMgr.cpp:273` und `:421`). Einzelheiten in **E-4**.

**Zu tun:** Eudora starten und wieder beenden. Kommt die Meldung noch?
### B4 · Gesperrte Werkzeugleisten-Knöpfe

`DrawDisabled` ist behoben (E-2), aber geprüft ist nur der Zustand, in dem die
Knöpfe **freigegeben** sind. Nachsehen, ob gesperrte Knöpfe erkennbar grau
erscheinen statt leer.

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
`SysWOW64` einer Entwicklermaschine steht.

Solange das offen ist, ist **Kriterium 0 nicht nachweisbar**.

### C2 · Kriterium 0 auf einem Rechner ohne Visual Studio nachweisen

Das Release-Paket dort auspacken und starten. Das ist der einzige belastbare
Nachweis. Am 31.08. lief auf dem Win11-Rechner das **Debug**-Paket mit
beigelegten, nicht verteilbaren DLLs (**E-8**) — das zählt nicht.

### C3 · Warum musste das Mailverzeichnis von Hand dazugelegt werden?

Beide Pakete enthalten `Mailverzeichnis\Eudora.ini`. Ungeklärt (**E-6**).

---

## C4 · NEU: diese Sitzung ist nicht gegengeprüft

**Die 15 Commits vom 31.08.2026 abends hat niemand außer mir angesehen.** Das
ist ein offener Punkt, nicht eine Formalie: `Arbeitsweise/doku-bei-jedem-commit-mitziehen.md`
verlangt ausdrücklich die Trennung — *„wer prüft und korrigiert, winkt seine
eigenen Befunde durch. LEKTOR hat PRUEFER am selben Tag fünfmal widerlegt."*
In dieser Sitzung waren keine Agenten freigegeben, also fehlt sie.

Ersatzweise ist gegen die Quelle gemessen worden statt gegen mein Urteil, und
das hat vier eigene Fehler zutage gebracht — sie stehen in den Befunden, hier
nur als Beleg, dass die Selbstprüfung nicht ausreicht:

| Fehler | wo festgehalten |
|---|---|
| die Klammersuche lief bei klammerlosem `if` in die **nächste Funktion** | X-3 |
| die Streichung der `//`-Kommentare ging verloren, eine Klammer **im Kommentar** zählte als Blockende | X-3 |
| `passt()` an einer von vier Aufrufstellen ohne dritten Parameter (perl warnte zweimal je Lauf) | R-1, Nachtrag |
| die Gegenprobe in X-2 nannte `HEAD` statt des Commits — die Anleitung lieferte damit „35 grün" statt „11 rot" | X-2 und LEKTORAT, dritter Durchgang |

Dazu drei Aussagen, die ich zuerst behauptet und dann berichtigt habe: der
`SSLReceiveUse`-Wert (aus dem Port geraten), zwei Treffer als „echt" eingestuft,
die in einem auskommentierten Block standen, und `EUDORA_BUILD_NUMBER` habe
keinen Verwender (mein grep hatte `.inc` nicht im Filter).

**Zu tun:** einen PRÜFER-Durchgang über `git log origin/main..` dieser Sitzung —
Schwerpunkt auf den drei umgebauten Werkzeugen (`pruefe-bytes.pl`,
`suche-zeiger.pl`, `zeilenenden-angleichen.pl`), weil sie vor **jedem** Commit
bzw. auf **allen** Dateien laufen. Die Testsammlungen sind da; was fehlt, ist ein
zweites Paar Augen auf den Filtern und auf den Zahlen in R-1, X-3 und X-4.

Kleinigkeit derselben Art: zweimal wurde mit `git add -A` gestaget statt mit
Pfadangabe, wie `Arbeitsweise/commit-auf-extra-branch-und-pushen.md` es verlangt.
Der Commit-Inhalt wurde danach kontrolliert (kein Bauartefakt, keine fremde
Datei), aber die Regel sagt es anders.

## D — Die Werkzeuge

### D1 · ~~Neun Löcher in `pruefe-bytes.pl`~~ — **erledigt** (Befund X-2)

Alle neun sind geschlossen, **jedes mit eigenem Testfall**. Die Sammlung
`tools/pruefe-bytes-tests.pl` wächst von 23 auf **35 Fälle**. Gegen die alte
Schranke sind 11 der 12 neuen Fälle **rot** (der zwölfte ist die Gegenkontrolle),
gegen die neue **35 grün**. Einzelheiten je Loch in X-2.

### D2 · ~~Der pre-commit-Hook wertet seinen ersten Schritt nicht aus~~ — **erledigt**

`perl "$WURZEL/tools/lehren-spiegeln.pl" || exit $?`. In einem Wegwerf-Repo
vorgeführt: mit dem alten Hook lief der Commit trotz Abbruchmeldung durch, mit
dem neuen nicht. Dazu NP3-5: `lehren-spiegeln.pl` meldet jetzt auf `STDERR`,
wenn es das Gedächtnisverzeichnis nicht findet, samt dem abgeleiteten Pfad.

**Nach jedem frischen Klon einmal `sh tools/hooks-einrichten.sh` laufen lassen** —
der Hook liegt unter `.git/hooks` und wird von git nicht mitversioniert. Ein
alter Hook aus einem früheren Klon verschluckt den Abbruch weiterhin.

### D3 · ~~`suche-zeiger.pl` ist Rauschen~~ — **erledigt** (Befund X-3)

**347 → 18 Treffer**, neun Filter, alle achtzehn von Hand nachgelesen.
Fehlalarmquote 6 von 18; im eigenen Code, ohne die OpenSSL-Beispiele, 4 von 16.
Vorher 15 von 15. Aufruf und Empfehlung (Fremdcode ausschließen) in X-3.

### D3a · NEU: die neun Zeigerstellen aus X-3 beheben — **braucht einen Bau**

Prüfung vorhanden, Zugriff danach ungeschützt, kein erkennbarer Grund, warum der
Zeiger dort belegt sein müsste. Nach Dringlichkeit:

1. **`EuImap/src/ImapMailbox.cpp:1637` → `:1659`** (`pImapCommand`) — der Block
   des Wächters ist `if (!pImapCommand) { ASSERT(0); … }` **ohne `return`**. Im
   **Release** entfällt das `ASSERT` (F-1), dann läuft es weiter und greift auf
   den Nullzeiger zu. Der ernsteste der neun.
2. **`Eudora/POPSession.cpp:896` → `:905`** (`pDiskHost`) — auf dem Abrufpfad,
   direkter Nachbar von P-1/P-2.
3. `EuImap/src/ImapChecker.cpp:945` → `:953` (`m_pTaskInfo`)
4. `EuImap/src/ImapMailbox.cpp:1022` → `:1051` (`pAccount`)
5. `EuImap/src/imapgets.cpp:735` → `:743` (`m_pAccount`)
6. `Eudora/TocFrame.cpp:3968` → `:3973` (`pTocDoc`)
7. `Eudora/headervw.cpp:546` → `:551` (`pField`)
8. `Eudora/PgEmbeddedObject.cpp:276` → `:303` (`pView`)
9. `AccountWizard/Src/WizardImportPage.cpp:379` → `:420` (`pChild`)

Die Behebung ist jeweils dieselbe Form wie in P-2: die Prüfung mitziehen
(`if (p && …)`) oder früh aussteigen. **Jede Änderung braucht einen Bau** —
deshalb steht sie hier und nicht bei den compilerfreien Punkten. Drei weitere
Treffer sind unklar und brauchen ein menschliches Urteil (`ImapAccount.cpp:3152`,
`CompMessageFrame.cpp:644`, `StatMng.cpp:2399`).

### D4 · ~~`zeilenenden-angleichen.pl`: zwei Lücken~~ — **erledigt** (Befund X-4)

Sechs Dateiarten aufgenommen (`.ih .rgs .mc .user .hh .hpj`, 49 Dateien,
Grundgesamtheit 6395 → 6444; alle 49 waren byteidentisch zu HEAD). Und drei
Sicherungen gegen das richtungslose Zurückschreiben: jede angefasste Datei wird
**namentlich** genannt, **vorgemerkte** Dateien werden nicht angefasst, und die
**Gegenrichtung** hat ihre eigene Zeile und bleibt unangetastet
(`--auch-umgekehrt`, wenn doch). Vier Fälle in einem Wegwerf-Repo gegengeprobt.

**Damit ist Befund X-1 vollständig abgearbeitet** (X-2, X-3, X-4).

### D5 · NEU: `tools/bauen.ps1` — bauen, ohne belogen zu werden (Befund X-6)

Am 05.09.2026 meldete ein Bau-Lauf **EXITCODE 0, ohne gebaut zu haben**: in der
`Eudora.exe` stand noch 7.2.0.3, während `Version.h` schon 7.2.0.4 sagte. Um ein
Haar wäre genau das ausgeliefert worden. Zweiter Fehler desselben Laufs: der
Aufruf riet `-p:Platform=Win32`, die Projektmappe kennt aber nur `x86`
(`MSB4126`). Einzelheiten in **X-6**.

Seitdem wird so gebaut — **nicht** mehr mit einem MSBuild-Aufruf von Hand:

```
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Release
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Debug -Ziel Rebuild
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -NurPruefen
```

Das Werkzeug liest Konfiguration und Plattform aus `Eudora71/Eudora.sln` und
sucht MSBuild über `vswhere.exe`; geraten wird nichts. Erfolg meldet es **nur**,
wenn vier voneinander unabhängige Prüfungen zustimmen: Rückgabewert (über
`Start-Process -PassThru`, nicht `$LASTEXITCODE`), Fehlerprotokoll (eigener
`ErrorsOnly`-Logger, damit kein Suchmuster an der deutschen MSBuild-Ausgabe
vorbeigeht), Zeitstempel der Artefakte gegen den Bau-Beginn, und die
Versionsressource der `Eudora.exe` gegen `EUDORA_BUILD_VERSION`. Eingebaut sind
außerdem die Nachkontrollen: alles x86, und im Release-Zweig importiert keine
Datei eine Debug-Laufzeit — gelesen aus der **Importtabelle** des PE-Kopfes,
nicht per `grep` über die Datei. Rückgabe 0/1/2 wie bei den anderen Werkzeugen.

**Nebenbefund, beim Bauen gemessen (05.09.2026):** Aus einem reinen
Projektmappen-Bau kommt **nie** eine `Eudora.exe` heraus. `Eudora.vcxproj` und
`EudoraRes.vcxproj` führen `OT501.vcxproj` als Projektverweis, OT501 scheitert
(der bekannte Blocker), und MSBuild lässt ein Projekt aus, dessen Verweis
gescheitert ist. Sieben der neun überwachten Artefakte entstehen, die beiden
wichtigsten nicht. `bauen.ps1` erkennt das und hängt einen **zweiten Gang** an,
der `EudoraRes.vcxproj` und `Eudora.vcxproj` einzeln mit
`/p:BuildProjectReferences=false` baut — mit der *Projekt*konfiguration
`Release|Win32`, die dafür aus der `.sln` abgelesen wird. Das ist genau die
Handarbeit, die bisher in der Auflagenliste stand und beim Eiligsein vergessen
wurde. Abschalten mit `-OhneZweitenGang`.

---

## E — Die Ersatzschicht

### E1 · `FloatControlBarInMDIChild` ist ein leerer Rumpf (**A-1**)

`WazooBarMgr.cpp:377-400` dockt danach das Adressbuch an, schickt
`ID_SEC_MDIFLOAT` (wirkungslos) und ruft `GetParentFrame()` — das liefert dann
**das Hauptfenster** statt eines `QCControlBarWorksheet`. Im Debug greift
`ASSERT_KINDOF`, **im Release läuft `MoveWindow` auf das Hauptfenster**.

ANSICHT hält das für den größten verbliebenen Rest.

### E2 · Der größte Eingriff des Tages hat keinen Test (**PR-2**)

`1a4a6d5` ändert `OTShim.cpp` um **334 Zeilen**; `Eudora71/Tests/` blieb
unangetastet. `TestOTShimAndocken.cpp:214` prüft sogar noch das **alte**
Verhalten (`CalcDynamicLayout(0, LM_HORZDOCK) == 32767`). Der neue Zweig wird
von keinem der 105 Tests betreten.

### E3 · `SetControlBarWidthsInRow` ist noch leer

`OTShim.cpp:2244`, und `OnSizeParent` (`:3276`) reicht noch durch.

---

## F — Offene Kleinigkeiten

- **`Out.mbx`-Größe 1.788.158.654 für eine leere Datei** (E-11, Nebenbefund) —
  nicht initialisierter Wert im Protokoll, zwei Zeilen später steht korrekt 0.
- ~~**PR-5**, der Zeitstempel in der Bau-Kennung~~ — **erledigt am 31.08.2026
  abends.** Der Kopf von `tools/kennung-erzeugen.pl` sagte „dem Zeitpunkt des
  Baus"; tatsächlich nennt der Zeitstempel den Zeitpunkt, zu dem sich **Commit
  oder Sauberkeit** zuletzt geändert haben — die Datei wird nur neu geschrieben,
  wenn sich etwas außer dem Zeitstempel ändert. Das Verhalten ist richtig
  gewählt (sonst übersetzt jeder Bau alles neu), nur die Beschreibung war
  falsch. Jetzt an drei Stellen richtig: Kopf, erzeugte `BuildKennung.h`, und an
  der Stelle im Code, an der der Unterschied entsteht.
- **`EUMAPI.DLL` ist eine 16-Bit-Datei** von 1995 (Signatur `NE`, belegt in
  Z-1). Niemand importiert sie. Kann vermutlich aus dem Paket.
- **`MFC71.DLL` und `MSVCP71.dll`** sind nicht nachbaubar (157 Ordinale, B-1).
  Adressbuch, LDAP und Ph fallen dauerhaft aus, solange die Fremd-DLLs von 2006
  benutzt werden.
- ~~**Der Release-Zweig von `EudoraRes`** hängt noch über einen Projektverweis an
  `OT501`~~ — **erledigt am 05.09.2026** (**B-3**, Commit `d8cc9d3`). Nachgesehen:
  `grep -n OT501 Eudora71/Eudora/EudoraRes.vcxproj` liefert nur noch vier
  `AdditionalIncludeDirectories` mit `..\OT501\Include`; die Kopfdateien werden
  gebraucht, die Bibliothek nicht. Kein `ProjectReference` mehr.
- **LEKTORAT:** am 31.08.2026 abends sind **alle 45 Markdown-Dateien** gelesen
  und die Widersprüche berichtigt worden (dritter Durchgang in `LEKTORAT.md`).
  `Releases/1.0.3/LIESMICH.txt` ist ebenfalls neu gefasst — sie beschrieb den
  Debug-Weg und hätte den Empfänger dazu gebracht, sich die vier **nicht
  verteilbaren** Debug-Laufzeiten zu holen. Offen bleibt allein
  `Releases/1.0.2/LIESMICH.txt`; sie beschreibt ein Paket, das nicht mehr
  ausgeliefert wird.
- ~~**Die alte CR-Anzahl-Regel** steht noch in vier `Arbeitsweise/`-Dateien, in
  `PORTIERUNG.md` und in einem Patch-Kommentar.~~ **Nachgemessen am 31.08.2026
  abends: die Behauptung war zu weit gefasst.** Von acht Fundstellen war
  **eine** falsch (`tools/patches/zertifikatspruefung-verschaerfen.md:105`,
  jetzt berichtigt). Die `Arbeitsweise/`-Stellen beschreiben `aendere-zeile.pl`
  — und das bricht wirklich bei geänderter CR-Zahl ab (`:33`) — oder den
  Handgriff von Hand; beides richtig. `PORTIERUNG.md:664` sagt ausdrücklich,
  dass die CR-Anzahl **nicht** mehr verglichen wird.
- ~~**`VC71Bruecke/BEFUND.md:462`** nennt eine **falsche GUID**~~ — **berichtigt
  am 31.08.2026 abends**, mit Kasten und der echten GUID aus
  `VC71Bruecke.vcxproj:32` (gegengeprüft: sie steht fünfmal in
  `Eudora71/Eudora.sln`).

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
   mit `:raw`, **nicht** `grep -c $'\r'`.
4. **Bauen nur in der PowerShell**, nicht in der Git-Bash. Visual Studio liegt
   unter **Professional**. **Die ganze Projektmappe bauen**, nicht ein
   Einzelprojekt — die `.lib` entstehen erst dabei.
   `/p:BuildProjectReferences=false` ist seit dem 05.09.2026 **nicht mehr nötig
   und nicht mehr erwünscht**: `OT501` ist aus dem Bau genommen (**B-3**,
   Commit `d8cc9d3`).
4. **Bauen mit `tools/bauen.ps1`**, in der PowerShell, nicht in der Git-Bash.
   Kein MSBuild-Aufruf von Hand mehr: am 05.09.2026 hat einer Erfolg gemeldet,
   ohne gebaut zu haben (X-6). Die Plattform heißt auf Projektmappenebene
   **`x86`**, nicht `Win32`. Visual Studio liegt unter **Professional**.
   Einzelprojekte brauchen `/p:BuildProjectReferences=false`; für den
   Release-Zweig einmal **mit** Verweisen bauen, damit die `.lib` entstehen,
   dann **ohne**.
5. **Zeilenangaben veralten**, sobald jemand dieselbe Datei anfasst (Z-1: sieben
   von elf Abweichungen waren genau das). Wer eine Fundstelle benutzt, prüft sie
   nach.
6. **In kleinen Schritten committen und pushen.** Was nicht gepusht ist, ist bei
   einem Abschalten verloren.

### Auf welchem Zweig stehe ich?

Am 31.08.2026 hat Gregor um **09:03** zusammengeführt und angekündigt, den Zweig
zu löschen. Um **09:06** lag trotzdem ein weiterer Commit auf genau diesem Zweig.
Inhaltlich ging nichts verloren — aber nur zufällig (Befund **X-5**).

7. **Vor jedem Commit: auf welchem Zweig stehe ich, und lebt der noch?** Nicht
   aus dem Gedächtnis, sondern gemessen: `perl tools/pruefe-branch.pl --melden`.
   Der `pre-commit`-Hook prüft es als **ersten** Schritt und bricht ab. Wer den
   Hook nicht eingerichtet hat (`sh tools/hooks-einrichten.sh`), arbeitet ohne
   diese Schranke — sie liegt unter `.git/hooks` und wird nicht mitversioniert.
8. **Kündigt Gregor einen Merge an, läuft SOFORT `perl tools/gesichert.pl`** —
   vor jeder anderen Handlung, und das Ergebnis wird gemeldet. Es beantwortet in
   einem Aufruf: alles committet? alles gepusht? sind die *anderen* Arbeitsbäume
   sauber? Rückgabewert `0` heißt gesichert, `1` nennt, was fehlt. Die Ansage ist
   der Auslöser, nicht der Nachweis: „es sollte alles committet und gepusht
   sein" ist eine Erwartung, kein Messwert.
9. **Nach einem Merge durch Gregor wird auf `main` gewechselt**, nicht auf dem
   alten Zweig weitergearbeitet:
   `git checkout main && git pull && git switch -c <neuer-name>`.
   Ein Zweig, der in `origin/main` steckt, ist erledigt — was danach dort
   committet wird, steht auf einem Ast, der beim nächsten Aufräumen abfällt.
10. **Eine Auflage, die nur im Text steht, trägt nicht.** Das war der
    Entwurfsfehler hinter X-5: die Regel stand hier als Prosa und hing daran,
    dass ein Agent daran denkt. Wer eine neue Regel aufstellt, **baut die
    Schranke dazu** — ein Werkzeug mit Rückgabewert, eingehängt im Hook, und
    einen Testfall in einer Sammlung, der beweist, dass sie greift *und* dass sie
    nicht grundlos anschlägt. Beides gehört in denselben Commit wie die Regel.
