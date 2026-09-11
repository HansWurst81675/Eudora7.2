# Hier weitermachen

**Stand 10.09.2026, nachmittags.** `main` ist gesperrt und wird nur von Gregor per
Merge bewegt; jeder Agent arbeitet in seinem eigenen Arbeitsbaum und Zweig
(siehe [AGENTEN.md](AGENTEN.md)).

| | |
|---|---|
| **Quellstand** | 7.2.0.44 (`Eudora71/Version.h`) |
| **Paketnummer** | 1.0.47 (`VERSION`) |
| **Zuletzt gebaut und gepackt** | Paket **1.0.43** — auf GitHub als `v1.0.43` veroeffentlicht, SHA256 `e68d8a8a579c6644…`. **1.0.44 ist in Arbeit** |
| **Zuletzt von Gregor bestätigt** | **1.0.44 am 10.09.2026**: *„filter fenstergröße nach neustart gespeichert: PASS"* (**E-70**) und *„filter funktionieren"* (**E-64**, **E-72**, **E-75**). Davor 1.0.29 mit *„1-6, ok"* zu E-54 bis E-58 und E-61, dazu E-65/E-66 (*„1. ja / 2. ja / 3. ja"*) |
| **Was als Nächstes zu messen ist** | **E-44 — die Spur, die aus E-70 herausfiel.** Die Meldung *„für 3 Leiste(n) war keine Lage gespeichert (kein `[ToolBar...]`-Abschnitt)"* kommt bei **jedem** Start, und ihre Begründung stimmt nicht: in der `Eudora.ini` stehen dreizehn solche Abschnitte, und die vier Andockleisten tragen ihre Kinderlisten (`Bars=4`, `Bars=3`, `Bars=3`, `Bars=3`). MFC schreibt `Bars=N` nur für eine **nicht leere** Andockleiste (`dockstat.cpp:245`). Der Zustand ist also gespeichert und wird nicht angewandt. Zwei Marken `E-44 nach SetDockState:` und `E-44 vor/nach LoadWazooBarConfig:` liegen seit 7.2.0.43 im Bau, **noch nicht gebaut**. Das könnte auch erklären, warum Fenster nach einem Neustart nicht im Vollbild stehen |
| **Offen, zurückgestellt** | **E-71** (Filterbericht bleibt leer) — von Gregor am 10.09.2026 ausdrücklich auf die nächste Fassung geschoben: *„kann aber als ToDo für die nächste version aufgeschrieben werden"*. **Nicht von selbst aufgreifen.** Belegt ist, dass der Lauf trifft; zu messen ist `CFilterActions::EndFiltering` |
| **Offen, mit Marken im Bau** | **E-76** (das schwebende Filterfenster lässt sich nur seitlich vergrößern; Marke seit 7.2.0.41, noch nicht ausgewertet). **E-66** (Marken seit 1.0.35, seit dem Umbau auf `ZiehenAmRand` **nie wieder gelesen** — `tools/spuren-auswerten.pl` weist den Paketbau deshalb ab). **E-68** (`copyInstead` schreibt/liest asymmetrisch, `CFiltersDoc::Read` prüft `NUM_FILT_ACTS` nicht — PRÜFER rechnet nach). **E-47** (MFC71/MSVCP71) |
| **Aufräumen, sobald die Befunde sitzen** | Die Spurmarken **E-64**, **E-66**, **E-70**, **E-72**, **E-73**, **E-76** und die neuen **E-44** schreiben je Nachricht, Filter oder Anordnungsdurchlauf eine Protokollzeile. E-64, E-70, E-72 und E-73 sind bestätigt und dürfen raus |
| **Von Gregor fuer den 11.09.2026 bestellt** | **1.** die Sache mit den **Zertifikaten** erklaeren, die zurueckgestellt wurde — `tools/patches/zertifikatspruefung-verschaerfen.patch` samt Begruendung daneben, dazu der Wurzelzertifikatsspeicher von 2004 (`rootcerts.p7b`, 17 von 30 Zertifikaten im August 2026 abgelaufen) und der fehlende Namensabgleich (nur CN, keine SAN, kein SNI). Fundstellen in `PORTIERUNG.md:435-470`. **2.** die **ToDo-Liste** durchsehen: was ist noch offen, was davon lohnt als Naechstes |
| **Was ich dabei nicht selbst messen kann** | das Ziehen mit der Maus. `Splitter::Track` bricht ab, sobald die **physische** Maustaste los ist (**E-51**). Alles andere lässt sich seit Gregors Freigabe vom 10.09.2026 (*„du kannst ja jetzt lokal ausführen, ich greife nicht rein"*) über `tools/testlauf.ps1` und `tools/leisten-messen.ps1` selbst messen — genau so ist der zweite Teil von E-70 gefunden worden |

> **Die Fassungsgeschichte mit allen Messungen steht in
> [CHANGELOG.md](CHANGELOG.md)** — dort auch die Prüfanleitung zum aktuellen
> Paket und der Abschnitt *Wo man weitermachen kann* mit den offenen Enden und
> Fundstellen. Diese Datei hier ist nur der Einstieg.

## Das Ziel, an dem alles hängt

**Neun Kriterien: sieben sind belegt (0, 1, 3, 5, 6, 7, 8), zwei sind fast
erfüllt (2, 4).** Die Tabelle dazu steht in [ZIEL.md](ZIEL.md) und ist die
Quelle. Gregor hat am 06.09.2026 die zweite Stufe gesetzt, Kriterien **4 bis
6**; **7** ist am 07.09.2026 aus seinem Urteil zu Paket 1.0.18 nachgetragen,
**8** noch am selben Tag aus seinem Wunsch nach sichtbaren offenen Fenstern.

| # | | Stand |
|---|---|---|
| 4 | **Keine Abstürze** | fast — fünfmal Strg-N ohne Absturz gemessen; das Beenden ist erledigt, und mit **E-43** sind **E-37** und **E-38** weggefallen. Offen bleibt die Meldung beim Anzeigen mancher Nachrichten |
| 5 | **Eine neue Mail schreiben und abschicken** | **erfüllt** (07.09.2026, von Gregor bestätigt) |
| 6 | **Eine Mail weiterleiten** | **erfüllt** (07.09.2026, von Gregor bestätigt) |
| 7 | ***File → Exit*** beendet Eudora sauber | **erfüllt** (08.09.2026, von Gregor bestätigt) — *„schließen klappt jetzt."* Alle drei Wege: Menü, Alt-F4, Kreuz |
| 8 | Offene Fenster sichtbar und auswählbar | **erfüllt** (09.09.2026, von Gregor bestätigt) — Menü *Window* und die Registerkartenleiste unten; der Klick holt das Fenster nach vorn (**A-3** / **E-48**) |

**Beiden noch nicht erfüllten Kriterien fehlt dasselbe:** die Meldung
„Encountered an improper argument" beim **Anzeigen** mancher Nachrichten. Sie
ist der letzte bekannte Fehler, den ein Anwender merkt — und **neu zu messen**,
seit **E-43** die Fehlerklasse an der Wurzel behoben hat.

**Dazu vier Anforderungen, die kein Kriterium sind**, alle in
[ZIEL.md](ZIEL.md) aufgeschrieben: **A-1** (Vorgaben für ein neu angelegtes
Konto), **A-2** (*Task Status* und *Task Errors* waagrecht unten) und **A-3**
(offene Fenster als Registerkarten) sind umgesetzt und **von Gregor
bestätigt**; **A-4** (den linken Bereich breiter ziehen) ist **gebaut und
nicht bestätigt**.

## Was seit dem 06.09.2026 anders ist

**E-31 ist behoben — das war die Wurzel.** Strg-N und *Weiterleiten* beendeten
Eudora mit `0xC00000FD STATUS_STACK_OVERFLOW` in `Paige32.dll`
(`pgInstallFont`, 525 Windungen tief); deshalb entstand auch nie ein
`Exception.log` — ein voller Stapel lässt keinen Platz mehr für den
Absturzbehandler. Die Ursache war eine Zeile in
`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`: `pg_time_t` erbte seine Breite von
`time_t`, und das ist unter VS2022 **acht** Byte breit statt der vier, mit denen
die ausgelieferte DLL von 2005 rechnet. Damit war **jede** Struktur verschoben,
die Eudora an Paige reichte — und in dieser Portierung entstand bis dahin
**kein einziges Paige-Fenster**. Seither läuft der Fensterbau vollständig durch
(`OnMessageNewMessage: fertig`). Die Messung mit allen Feldversätzen steht in
[CHANGELOG.md](CHANGELOG.md) unter 7.2.0.21.

**Sieben Vermutungen sind auf diesem Weg widerlegt worden** — jede gebaut,
gestartet, gemessen. Sie stehen samt Messwerten in
[CHANGELOG.md](CHANGELOG.md) unter 7.2.0.21. **Nicht noch einmal
durchprobieren.**

**E-32: der Code-Mangel ist behoben, die Ursachenbehauptung ist widerlegt.**
`CHeaderView::OnKillFocusRecipient` in `Eudora71/Eudora/headervw.cpp`
dereferenzierte `pField` ungeprüft, obwohl die Abfrage drei Zeilen darüber
ausdrücklich mit NULL rechnet — das ist behoben (`060a4bf`) und bleibt richtig.
Dass **diese** Stelle die modale Meldung „An unhandled exception has occurred"
verursacht hätte, hat PRUEFER dreifach gemessen und **verworfen**
(`Befunde/PRUEFER-3.md`, Abschnitt 2): die Funktion läuft bei Strg-N gar nicht,
das Herausnehmen der Behebung bringt die Meldung nicht zurück, und im Paket
1.0.18 tritt sie über denselben Weg nicht auf. Aufgeklärt hat die Meldung erst
**E-34** — eine MFC-Ausnahme in `QCChildToolBar::GetButton`, die den ganzen
Fensterbau abwickelte (`CHANGELOG.md` unter 7.2.0.20 und 7.2.0.21).

## Der nächste Schritt

**Der nächste Schritt gehört Gregor: vier gebaute Behebungen warten auf sein
Urteil.** Alles Weitere steht ausführlich in [AUFGABEN.md](AUFGABEN.md) unter
*Die Hauptarbeit*; hier die Reihenfolge in einem Satz je Punkt.

1. **A-4 / E-49, E-52, E-54 und E-55 an 1.0.29 prüfen** — den linken Bereich am
   Trennbalken nach rechts ziehen, über 180 Pixel hinaus, und **gleich noch
   einmal** ziehen. Bleibt der Balken greifbar? Stehen die Registerkarten
   danach einfach da, nicht doppelt? Überlebt die Breite einen Neustart?
   **Und vor allem: friert nichts ein** (**E-51**)? Die fünf Prüfschritte
   stehen in [ZIEL.md](ZIEL.md) unter A-4.
2. **E-50 an 1.0.26 prüfen** — die drei Mängel an der Registerkartenleiste:
   bleibt eine Karte eingedrückt, wenn ein anderes Fenster aktiv ist; stimmt
   die Darstellung beim Skalieren; bleiben die Karten beim Öffnen und Schließen
   stehen. Alle drei hatten dieselbe Wurzel — der Streifen wurde nur beim
   Neuzeichnen gemalt, und niemand erklärte ihn für ungültig.
3. **Die Meldung „Encountered an improper argument" beim Anzeigen neu messen.**
   Das ist der letzte bekannte Fehler, den ein Anwender merkt, und der einzige
   Grund, warum Kriterium 2 und Kriterium 4 nicht *erfüllt* heißen. **Seit
   E-43** ist die Fehlerklasse dahinter an der Wurzel behoben — gut möglich,
   dass die Meldung mit verschwunden ist. **Erst messen, dann suchen.**
4. **Der Nebenbefund ohne Nummer: die Fenster stehen nach einem Neustart nicht
   im Vollbild**, obwohl sie beim Beenden so waren (Gregor am 09.09.2026 an
   1.0.25). Das ist der Fensterzustand über `CMainFrame::SaveOpenWindows`,
   **nicht** die Kartenleiste. Erster Handgriff ohne Bau: nach einem normalen
   Beenden in der `Eudora.ini` nachsehen, ob der Maximiert-Zustand dort steht.
5. **E-39** — wird die aktuell benutzte Persönlichkeit gelöscht, kann ihr
   INI-Abschnitt teilweise wiederentstehen. `CPersonality::Remove`
   (`persona.cpp:565-566`) stellt die aktuelle Persönlichkeit nicht um.
   Naheliegend: nach erfolgreichem `Remove` auf `<Dominant>` umschalten.
6. **E-47** — der Fehlerdialog des Verzeichnisdienstes. Ursache belegt
   (`MFC71.DLL` und `MSVCP71.dll` fehlen und wird es immer), **keine Behebung
   in Sicht**; betrifft Adressbuch, LDAP, Ph und S/MIME, nicht den Start.

> **Was nicht mehr zu suchen ist.** Das Beenden ist entschieden: E-40 (eine
> Rückfrage, die sich nicht öffnen lässt, galt als Abbrechen), E-41 (Alt-F4 und
> das Kreuz laufen durch ein `ENSURE_VALID`, das *File → Exit* nicht hat) und
> E-42 (zwölf Aufräumschritte konnten den Ablauf abbrechen), dazu E-45 (der
> eine Schritt, der **nicht** übersprungen werden darf). Der Weg dorthin steht
> in [Befunde/BEENDEN.md](Befunde/BEENDEN.md), das Review in
> [Befunde/PRUEFER-5.md](Befunde/PRUEFER-5.md). **Nicht wieder von vorn
> aufrollen.**
>
> **Ebenso entschieden ist E-43** — `SECControlBar` war **zweimal definiert**
> (`OT501/Include/sbarcore.h` und `OTShim/OTShim.h`, der Ersatz mit einem Feld
> mehr), und zwei Übersetzungseinheiten lasen dasselbe Feld acht Byte
> auseinander. Gemessen vorher `GetBtnCount=24/24 m_btns.GetSize=0/0`, nachher
> `24/24` gegen `24/24`. Die `Eudora.ini` enthält seither **13**
> `[ToolBar…]`-Abschnitte statt **0**. Damit fielen **E-37** und **E-38** mit
> weg, und **E-46** (freigegebenes `CMainFrame`-Objekt) ist **widerlegt**.
> Schranke: `tools/pruefe-waechter.pl`.

## Ebenfalls offen

- **`ReleaseBuffer` ohne `GetBuffer`** — Fehlerklasse **R-1**, **16** Stellen
  bleiben (gemessen am 07.09.2026 mit `perl tools/releasebuffer-pruefen.pl`).
  Die Reihenfolge steht in [AUFGABEN.md](AUFGABEN.md) unter A2, nach
  Häufigkeit des Wegs sortiert.
- **Neun Zeigerstellen** aus X-3 ([AUFGABEN.md](AUFGABEN.md), D3a).
- **E-14** — die Zusicherung beim Start, der X1-Suchindex werde neu angelegt.
  Auf einem frischen Mailverzeichnis ist das der normale erste Lauf; ein
  echter Befund wird es erst, wenn die Meldung auch beim **zweiten** Start
  kommt.
- **E-13** — beim Mailabruf ist kein Fortschritt sichtbar. Die Behebung liegt
  auf `wt/fortschritt-arbeit`, **nicht** in diesem Zweig.
- **`EuMemMgr.dll` ist kein Projekt der Projektmappe** — vorgebaut, 2005,
  Version 7.0.0.9. Ausgerechnet sie löst den Aufrufstapel im Absturzbericht auf.
- **Die Hostnamenprüfung greift nicht** (sicherheitsrelevant, in
  `PORTIERUNG.md` beschrieben) — von Gregor ausdrücklich **zurückgestellt**,
  siehe [AUFGABEN.md](AUFGABEN.md) am Ende.

## Wie man misst

Alles, was man dafür braucht, steht bereit — es muss niemand danebensitzen.

**Protokollierung einschalten.** In `Mailverzeichnis\Eudora.ini` unter
`[Settings]`:

```
LogLevel=32896
```

Ohne diese Zeile schreibt Eudora nichts: `PutDebugLog` prüft die Maske und kehrt
sonst sofort zurück (`QCUtils/src/debug.cpp:140`). 32896 = `DEBUG_MASK_MISC`
(0x8000) + `DEBUG_MASK_TOC_CORRUPT` (0x80). Danach stehen die Spurmarken mit
`E-27` in `Mailverzeichnis\eudora.log`.

**Absturzbericht auswerten:**

```bash
perl tools/absturz-auswerten.pl
```

Findet `Exception.log` und `Eudora.map` selbst und macht aus jeder Stapelzeile
einen Funktionsnamen. Bei Berichten vor 7.2.0.13 sagt es, dass es nicht geht,
statt zu raten.

**Unter dem Debugger laufen lassen** — muss die **32-Bit**-PowerShell sein:

```
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File tools\stapel-untersuchen.ps1 -Exe <Paket>\Eudora.exe -Argumente "<Mailverzeichnis>"
```

Er fängt die tödliche Ausnahme ab und **tastet den Stapel ab** — die EBP-Kette
taugt bei Paige nichts, die DLL ist ohne Rahmenzeiger übersetzt.

**Eudora ohne Maus bedienen.** Meldungsfenster der Klasse `#32770` mit
`SendMessage(h, WM_COMMAND=0x0111, IDOK=1, 0)` schließen, dann
`PostMessage(hauptfenster, 0x0111, 32797, 0)` an die Fensterklasse
`EudoraMainWindow` für *Neue Nachricht* (`ID_MESSAGE_FORWARD` ist 32799).
Fensterliste über `EnumWindows` + `GetWindowThreadProcessId`; bei
`GetClassName`/`GetWindowText` unbedingt `CharSet=CharSet.Unicode`.

## Bauen und packen

```powershell
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Release
```

Meldet Erfolg nur, wenn vier unabhängige Prüfungen zustimmen. **MSBuild kann 0
zurückgeben und trotzdem nichts gebaut haben.**

Paket schnüren und prüfen:

```powershell
powershell -ExecutionPolicy Bypass -File tools\paket-bauen.ps1 -Ziel <Verzeichnis> -Zip Releases\Eudora72-1.0.x-release.zip -AusBauverzeichnis -Bauart Release
powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket <Verzeichnis>
```

**Eine Nummer je Bau.** Vor dem Packen `Eudora71/Version.h` und `VERSION`
hochsetzen und committen — sonst trägt die Bau-Kennung ein Sternchen und der
Bau ist nicht reproduzierbar.

## Nach einem frischen Klon

```bash
sh tools/hooks-einrichten.sh
```

Das war es. Zeilenenden sind seit `.gitattributes` (`* -text`) kein Thema mehr —
nachgemessen: ein frischer Auscheck mit erzwungenem `core.autocrlf=true` meldet
null geänderte Dateien.

## Wie hier gearbeitet wird

- [AGENTEN.md](AGENTEN.md) — Koordination paralleler Arbeit, aus fünf gemessenen
  Kollisionen
- [Arbeitsweise/](Arbeitsweise/) — die Lehren aus diesem Projekt, eine Datei je
  Lehre. **Vor dem Anfangen lesen**, besonders
  [mannschaft-fuehren.md](Arbeitsweise/mannschaft-fuehren.md): ein Auftrag ohne
  konkrete Beobachtung liefert nichts, und jeder Rücklauf wird selbst
  nachgemessen
- Die Quellen sind **Latin-1 mit gemischten Zeilenenden**. `tools/pruefe-bytes.pl`
  vor jedem Commit; das Edit-Werkzeug zerstört beides lautlos
