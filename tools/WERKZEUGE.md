# Die Werkzeuge in `tools/`

Diese Übersicht stand bis zum 09.09.2026 in [README.md](README.md). Sie ist
dorthin nicht zurückzuschieben: eine README beantwortet, **was** das Projekt
ist und wie man es baut — die Innenausstattung der Werkstatt gehört daneben.

Verweise sind von der **Wurzel** des Arbeitsbaums aus zu lesen, nicht von
`tools/` aus.


| Werkzeug | wozu |
|---|---|
| `tools/bauen.ps1` | baut die Projektmappe und meldet Erfolg erst, wenn Rückgabewert, Fehlerprotokoll, Zeitstempel und Versionsressource zusammenpassen. Prüft nach: alles x86, im Release keine Debug-Laufzeit in der Importtabelle. `-NurPruefen` misst nur |
| `tools/zeilenenden-angleichen.pl` | Arbeitskopie byteidentisch zum Commit machen. Nach jedem Klon einmal. Nennt jede angefasste Datei namentlich, lässt vorgemerkte Dateien in Ruhe; die Gegenrichtung nur mit `--auch-umgekehrt` |
| `tools/aendere-zeile.pl` | eine einzelne Zeile byte-erhaltend ändern |
| `tools/ersetze-bereich.pl` | einen Zeilenbereich byte-erhaltend ersetzen |
| `tools/summe-gegentest.sh` | Gegentest zur Summenprüfung in `doku-pruefen.pl`, **6 Fälle in beide Richtungen** in einem eigenen Wegwerf-Repo — je ein richtiger Satz, der still bleiben muss, und ein falscher, der gemeldet werden muss, auch in fetter Schreibweise. **Wer die Kriterienprüfung in `doku-pruefen.pl` anfasst, lässt ihn laufen** |
| `tools/pruefe-bytes.pl` | `pre-commit`-Schranke gegen lautlosen Byteschaden: Zeilenenden, Kodierung, Doppelkodierung |
| `tools/pruefe-bytes-tests.pl` | Testsammlung dazu, **35 Fälle** in eigenen Wegwerf-Repos. **Wer `pruefe-bytes.pl` anfasst, lässt sie laufen** |
| `tools/pruefe-branch.pl` | `pre-commit`-Schranke gegen Commits auf einen toten Zweig: schon in `origin/main`, Gegenstück auf dem Server gelöscht, oder abgelöster HEAD. Läuft als **erster** Schritt im Hook; `--melden` berichtet nur (Befund X-5) |
| `tools/pruefe-branch-tests.pl` | Testsammlung dazu, **15 Fälle**, jeder in zwei Durchläufen. **Wer `pruefe-branch.pl` anfasst, lässt sie laufen** |
| `tools/dateiendungen.pl` | gemeinsame Liste der Dateiarten, die als Text gelten. Wird von der Schranke und von `zeilenenden-angleichen.pl` geladen — zwei getrennte Listen sind schon auseinandergelaufen |
| `tools/hooks-einrichten.sh` | richtet den `pre-commit`-Hook ein. Nach jedem Klon einmal. Schreibt nach `--git-common-dir`, läuft also auch aus einem Arbeitsbaum |
| `tools/stapel-untersuchen.ps1` | kleiner Debugger: fängt die tödliche Ausnahme, läuft die EBP-Kette ab, symbolisiert mit `dbghelp`. **Muss in der 32-Bit-PowerShell laufen**, braucht die `.pdb` neben der `.exe` |
| `tools/absturz-auswerten.pl` | übersetzt die Adressen aus einer `Exception.log` in Funktionsnamen aus `Eudora71/Bin/Release/Eudora.map`. Nimmt die Ladeadresse aus der Modultabelle des Berichts (**ab 7.2.0.13**, ausgeliefert erstmals in Paket 1.0.14) und **rät nicht**, wenn sie fehlt — ein falscher Name ist schlimmer als keiner (Befund E-29). Läuft ohne Visual Studio |
| `tools/absturz-auswerten-tests.pl` | Testsammlung dazu, **15 Fälle** mit künstlicher Karte und künstlichem Bericht. **Wer `absturz-auswerten.pl` anfasst, lässt sie laufen** |
| `tools/suche-zeiger.pl` | sucht Zeiger, die auf `NULL` geprüft und danach außerhalb des geschützten Blocks dereferenziert werden. 18 Treffer, davon neun echte Kandidaten (Liste in `AUFGABEN.md`, D3a). Läuft ohne Visual Studio |
| `tools/releasebuffer-pruefen.pl` | stuft jedes `ReleaseBuffer` im Baum ein: steht vorher ein `GetBuffer` auf **derselben** Variablen? Das ist die Fehlerklasse **R-1**. Rückgabe 1, sobald etwas zu tun ist. Läuft ohne Visual Studio |
| `tools/pruefe-symbole.pl` | prüft die Werkzeugleisten-Ressourcen ohne Übersetzer: jede `TOOLBAR` hat eine gleichnamige `BITMAP`, jede Bilddatei ist da, jeder Knopf hat ein Bild, keine Ladestelle in der Ersatzschicht holt eine Bitmap ohne Farbtabelle noch über `CBitmap::LoadMappedBitmap`, und deren Hintergrund ist wirklich 192,192,192 (Befund E-30). `-v` listet jede Leiste |
| `tools/pruefe-symbole-tests.pl` | Testsammlung dazu, **12 Fälle** auf künstlichen Arbeitsbäumen. **Wer `pruefe-symbole.pl` anfasst, lässt sie laufen** |
| `tools/postfach-zeichen-pruefen.pl` | prüft ein `.mbx` auf unübersetzte UTF-8-Folgen (Befund Z-2b) |
| `tools/kennung-erzeugen.pl` | erzeugt `BuildKennung.h` vor jedem Bau (PreBuildEvent) |
| `tools/laufzeit-holen.ps1` | holt die vier **Debug**-Laufzeiten aus `SysWOW64` und prüft jede auf x86 nach. Für den Release-Bau nicht nötig |
| `tools/paket-bauen.ps1` | stellt ein Auslieferungspaket aus dem Quellbaum zusammen, wahlweise als ZIP. **Veröffentlicht nichts** — ob ausgeliefert wird, entscheidet ein Mensch |
| `tools/paket-pruefen.ps1` | prüft ein ausgepacktes Paket gegen Kriterium 0: rechnet aus den PE-Import- und Verzögerungstabellen die **Startkette** aus und zählt einen Treffer in `SysWOW64`/`System32` ausdrücklich **nicht** als vorhanden; beim Debug-Paket weist es den Weg über `laufzeit-holen.ps1` selbst ab (PR-2.0 behoben am 06.09.2026, drei Gegenproben in `Befunde/PAKET.md`). Es ersetzt keinen Startversuch auf einem fremden Rechner — es sagt, ob der Lader alles findet, was er vor dem ersten Befehl braucht |
| `tools/ausliefern.pl` | prüft die Regel „eine Nummer, ein Bau" nach: `--pruefen` |
| `tools/release-pruefen.pl` | prüft, ob das ausgelieferte Release zum Quellstand passt |
| `tools/vc71-bruecke-messen.pl` | misst die Bindung der Fremd-DLLs an die VC-7.1-Laufzeit und erzeugt daraus die `.def` der `VC71Bruecke` |
| `tools/gesichert.pl` | beantwortet in einem Aufruf: alles committet, alles gepusht, sind die **anderen** Arbeitsbäume sauber? **Sofort laufen lassen, wenn Gregor einen Merge ankündigt.** `--ohne-holen` verzichtet auf `git fetch --prune` |
| `tools/ungesichertes-melden.pl` | meldet ungesicherte Änderungen |
| `tools/lehren-spiegeln.pl` | spiegelt die Lehren aus dem Gedächtnis nach `Arbeitsweise/` |
| `tools/pruefe-fensterbau.pl` | `pre-commit`-Schranke für den Fensterbau: keine modale Meldung in `Eudora71/OTShim/*.cpp` (E-33), `GetButton` hat Indexschranke **und** Ausnahmefang (E-34), jeder `GetButton`-Aufruf prüft sein Ergebnis auf NULL (E-35, E-36). Prüft alle `Eudora71/Eudora/*.cpp` — eine feste Dateiliste hatte genau die Lücke, in der E-36 lag. **Wer sie anfasst, lässt die drei Gegenproben laufen** |
| `tools/strg-n-pruefen.ps1` | startet Eudora, klickt Meldungen weg, schickt Strg-N und sagt, ob das Verfassen-Fenster aufgeht. **Öffnet ein Fenster** — nicht ohne Absprache laufen lassen |
| `tools/arbeitsbaum-frei.pl` | bucht einen Arbeitsbaum auf einen Agenten (`--neu`, `--freigeben`) und nennt namentlich, welche unverfolgten Dateien ein Zweigwechsel vernichten würde. Verfahren in [AGENTEN.md](AGENTEN.md) |
| `tools/befunde-einsammeln.pl` | führt die Befunddateien aus `Befunde/` in `BEFUNDE.md` zusammen (`--anhaengen`) und nennt die nächste freie Kennung (`--naechste E`) |
| `tools/doku-pruefen.pl` | hält alle MD-Dateien gegen `ZIEL.md`, `VERSION` und `Eudora71/Version.h`: Kriterienzahl und Summe der Teile, doppelte oder widersprüchliche Befundkennungen, Verweise ins Leere, genannte ZIPs, die es nicht gibt, und eine alte Paketnummer als heutiger Stand. Holt seine Dateiliste aus `git ls-files` — eine Liste von Hand prüfte genau die Dateien nicht, an die niemand gedacht hat. Auf Gregors Ansage *„ich traue dir nicht ganz, jemand soll dich immer wieder überprüfen — das bin aber nicht ich!"* |
| `tools/pruefe-ini-abschnitte.pl` | prüft jede Behauptung der Dokumentation über den INI-**Abschnitt** eines Schlüssels gegen `GetSectionID` (`rs.cpp:89-97`), aus `resource.h` und `EudoraRes.rc` gerechnet. Gelesen werden ```ini-Blöcke, `*.ini`, Tabellenzellen und Fließtext; die Dateiliste kommt aus `git ls-files`. `--was <Name>` sagt, wohin ein einzelner Schlüssel gehört, `--tabelle` gibt die Nummernbereiche aus. Anlass: `UseMyFilterWindowPosition` in `[Settings]` (11.09.2026) und, beim Nachprüfen gefunden, `LogLevel` ebenda statt in `[Debug]` — **zweimal dieselbe Fehlerklasse** |
| `tools/pruefe-ini-abschnitte-tests.pl` | Gegentest dazu, **16 Fälle in beide Richtungen** in eigenen Wegwerf-Repos: sechs falsche Angaben, die gemeldet werden müssen, zehn richtige oder nicht beurteilbare, bei denen es still bleiben muss. **Wer `pruefe-ini-abschnitte.pl` anfasst, lässt ihn laufen** |
| `tools/pruefe-taboo-liste.pl` | Schranke zu **E-80, Teil 1**: hält `TabooHeaders` (`EudoraRes.rc`, Kennung `10207`) gegen die 28 Einträge der Originalliste von 2006 **in ihrer Reihenfolge** und die 16 Ergänzungen vom 11.09.2026. Meldet außerdem leere Einträge, Leerzeichen nach dem Komma (der Eintrag wirkt dann nie) und jeden Eintrag, der eine der acht Kopfzeilen erschlägt, die ein Mensch lesen will — nachgerechnet mit demselben Präfixvergleich wie das Programm. `--liste` gibt die Liste aus |
| `tools/pruefe-taboo-liste-tests.pl` | Gegentest dazu, **17 Fälle in beide Richtungen**: zwölf, die gemeldet werden müssen — darunter die Originalliste allein, also der Stand vor der Behebung —, fünf, bei denen es still bleiben muss. **Wer `pruefe-taboo-liste.pl` anfasst, lässt ihn laufen** |
| `tools/pruefe-blahblah-knopf.pl` | Schranke zu **E-80, Teil 2**: jede Ansicht, die den Klick auf `ID_BLAHBLAHBLAH` an sich bindet, muss den Knopfzustand über `umsgButtonSetCheck` **setzen, bevor** sie ihn mit `GetCheck` liest. Der Umfang kommt aus den Botschaftstabellen im Quelltext, nicht aus einer Liste — eine dritte Ansicht, die das vergisst, wird von selbst gefunden. Prüft mit, dass die registrierte Botschaft im Rahmen wirklich angelegt und behandelt wird. Liest nur Code, Kommentare werden weggeworfen. `-v` listet jede Ansicht |
| `tools/pruefe-blahblah-knopf-tests.pl` | Gegentest dazu, **13 Fälle in beide Richtungen**, darunter die echten Dateien aus `567a5d8` (der Stand, an dem Gregor *„der bla bla button ändert nichts"* meldete) und ein Kommentar, der `GetCheck` nennt, ohne dass es Code wäre. **Wer `pruefe-blahblah-knopf.pl` anfasst, lässt ihn laufen** |
| `tools/pruefe-kopfzeilen-stil.pl` | Schranke zu **E-81**: `MessageStyleSheet` muss eine Regel für die Klasse `EUDORAHEADER` tragen, die Vordergrund **und** Hintergrund setzt — die Kopfzeilen stehen im selben HTML-Dokument wie die Mail und erben sonst deren Farben. Prüft außerdem die **Format-Falle**: das Stylesheet läuft durch `CString::Format`, und jedes einzelne `%` darin greift in einen Platzhalter, den niemand bedient. Die Zahl der erlaubten Platzhalter wird aus dem Aufruf in `TridentView.cpp` gezählt. `--zeigen` gibt das Stylesheet aus |
| `tools/pruefe-kopfzeilen-stil-tests.pl` | Gegentest dazu, **13 Fälle in beide Richtungen**, darunter die echte `EudoraRes.rc` aus `83c80fa` (vor der Behebung) sowie ein einzelnes und ein verdoppeltes Prozentzeichen. **Wer `pruefe-kopfzeilen-stil.pl` anfasst, lässt ihn laufen** |
| `tools/pruefe-zertifikatspruefung.pl` | Schranke gegen den Rückfall in `qccertificate.cpp`: im `switch` über `X509_STORE_CTX_get_error` darf **keine** Zuweisung an `iOK` stehen. `iOK = 1` sagt OpenSSL wörtlich „Zertifikat in Ordnung" — im Zweig, in dem die Prüfung fehlgeschlagen ist. **Meldet auf `main` nur und gibt 0 zurück**, weil die Behebung dort (Stand 11.09.2026) noch nicht liegt; sie steht auf dem Zweig `zertifikate` (`b3be298`). `--streng` macht daraus Rückgabe 1 — **so gehört sie in die Vorcommit-Liste, sobald der Zweig gemergt ist** |
| `tools/pruefe-zertifikatspruefung-tests.pl` | Gegentest dazu, **12 Fälle in beide Richtungen**, darunter beide echten Stände (`main` mit dem Fehler, `b3be298` mit der Behebung), die erlaubte Zuweisung vor dem `switch` und das Verhalten ohne `--streng`. **Wer `pruefe-zertifikatspruefung.pl` anfasst, lässt ihn laufen** |
| `tools/taboo-rechnen.pl` | rechnet an einem echten `.mbx` aus, welche Kopfzeilen der Knopf *Blah Blah Blah* versteckt — ohne Eudora zu starten, weil der Filter ein reiner Präfixvergleich ist (`TridentReadMessageView.cpp:2465`, `ReadMessageDoc.cpp:504`). Die Liste kommt aus `EudoraRes.rc`; `TABOO=<datei>` setzt eine andere ein. **Am 11.09.2026 nachgeprüft und in sechs Punkten berichtigt** — es rechnete unter anderem mit der Liste von 2006 statt mit der aus der Ressource |
| `tools/taboo-rechnen-tests.pl` | Gegentest dazu, **18 Fälle gegen den C-Code**: Präfixtreffer genau und auf längeren Namen, `References` gegen `Referer`, Groß-/Kleinschreibung, Fortsetzungszeilen, Kopfzeile ohne Doppelpunkt, letzte Nachricht ohne Leerzeile, Vorspann vor dem ersten Trenner. Eine **bekannte Grenze** wird benannt statt verschwiegen und meldet sich, wenn sie eines Tages verschwindet. **Wer `taboo-rechnen.pl` anfasst, lässt ihn laufen** |
| `tools/pruefstand-melden.pl` | meldet, wie weit `BEFUNDE.md`, `README.md` und `PORTIERUNG.md` hinter dem Code herlaufen (Marke `<!-- pruefstand: … -->`) |
| `tools/pruefe-waechter.pl` | `pre-commit`-Schranke zur Lehre *Teilweise ersetzte Header*: ein Header, der nur zum Teil ersetzt wird, darf keinen Include-Wächter setzen. Genau dieser Fehler war die Ursache von **E-43** und blieb neun Tage unentdeckt, weil die Lehre nur Text war |
| `tools/pruefe-beenden.pl` | Schranke für Kriterium 7: hält die drei Teile der Behebung (**E-40**, **E-41**, **E-42**) fest, damit eine spätere gut gemeinte Änderung sie nicht lautlos wieder entfernt |
| `tools/pruefe-nachrichtenschleife.pl` | Schranke gegen eigene Nachrichtenschleifen, die `WM_QUIT` verschlucken oder ohne Zeitgrenze warten (**E-51**). Der erste Lauf über den Baum fand sieben weitere Stellen in Eudoras eigenem Code |
| `tools/pruefe-datenverlust.pl` | Schranke in `paket-bauen.ps1`: kein Paket, solange in `BEFUNDE.md` eine Zeile mit **`DATENVERLUST`** nicht auf **behoben** steht. Aus dem Tag, an dem Gregors Postfach auf dem Server geleert wurde — ein Paket ist eine Aufforderung zu handeln. `-TrotzDatenverlust "<Begründung>"` baut trotzdem, die Begründung geht ins Protokoll |
| `tools/spuren-auswerten.pl` | Schranke in `paket-bauen.ps1`: kein Paket, solange eine `SPURMARKE` aus einer **früheren** Fassung nie ausgewertet wurde. Hält die Marken im Quelltext gegen [Befunde/SPURMARKEN.md](../Befunde/SPURMARKEN.md). Aus **E-70**, dessen Marke drei Pakete lang mitschrieb, während die Ursache geraten wurde. `--nur-melden` berichtet nur, `--fassung` prüft gegen eine andere Nummer |
| `tools/pruefe-doku-takt.pl` | Schranke in `paket-bauen.ps1`: **kein Paket ohne beschriebene Fassung**. Prüft, ob `CHANGELOG.md` einen Abschnitt für den Quellstand aus `Version.h` hat, ob `## Noch offen (Stand …)` nicht hinter dem jüngsten Vorgang zurückhängt und ob `VERSION` und die vier `EUDORA_VERSION*`-Makros dieselbe Nummer nennen. Aus dem 11.09.2026, als Release **v1.0.47** gebaut, gemergt und veröffentlicht war und Gregor **danach** nach dem Lektor fragen musste. Gegenproben: `tools/pruefe-doku-takt-tests.pl`, fünf Fälle |
| `tools/home-aufraeumen.ps1` | räumt weg, was am 10.09.2026 versehentlich nach `C:\Users\Gregor` entpackt wurde (das Paket-ZIP hat keine eigene Wurzelebene, 157 Dateien). Löscht nur, was in **Größe und Zeitstempel** exakt zum Paket passt, Ordner nur, wenn sie leer sind, und stellt die überschriebene `Eudora.ini` aus dem passenden Stand zurück |
| `tools/mailverzeichnis-uebernehmen.ps1` | nimmt das **ganze** Mailverzeichnis in die nächste Fassung mit, nicht nur die `*.mbx` — Anhänge liegen in `attach` und `Embedded`. Ergänzt, statt zu erschlagen, bricht ab, wenn eine `Eudora.exe` aus Quelle oder Ziel läuft, setzt `CtrlJMapping=2` und **zählt am Ende Quelle gegen Ziel nach**. Genau diese Nachmessung hat gefangen, dass `Copy-Item -LiteralPath` mit einem `*` nichts kopiert. `-NurCtrlJ` setzt nur die Taste |
| `tools/postfaecher-zusammenfuehren.ps1` | führt die über mehrere Testverzeichnisse verstreuten Postfächer in einem Mailverzeichnis zusammen (Grundlage 1.0.36, `In.mbx` aus 1.0.28, `Out.mbx` aus 1.0.32), löscht die zugehörigen `.toc` und die `eudora.log` und trägt `DeleteFetchedJunk=0` ein — der eingebauten Vorgabe wegen, die für bestehende Konten gilt (**E-74**) |
| `tools/pruefe-filter-serverloeschung.pl` | Schranke gegen Datenverlust auf dem Server durch eine Filteraktion (**E-73**). Jede Stelle im Filterweg, die eine Nachricht auf dem Server zum Löschen vormerkt, muss den Rückschalter `FilterMayDeleteFromServer` fragen. Beim ersten Lauf fand sie **zwei offene Wege**, die die erste Behebung nicht kannte: IMAP und die Junk-Filteraktion. `--selbsttest` fährt beide Gegenproben |
| `tools/pruefe-filter-aktionsgrenze.pl` | Schranke gegen den Schreibzugriff hinter das Aktionsfeld beim Einlesen von `Filters.pce` (**E-68**). Hält die Liste `IstAktionsSchluesselwort` gegen die Zweige in `CFiltersDoc::Read`, die den Zähler hochzählen, und prüft, dass `Write` an `NUM_FILT_ACTS` gebunden bleibt. `--selbsttest` fährt beide Gegenproben |
| `tools/leisten-messen.ps1` | misst Andockseite, Sichtbarkeit, Größe und Lage der Wazoo-Leisten eines **laufenden** Eudora — Zahlen statt Bildschirmfoto, Grundlage für A-2 und Kriterium 8. `-Pfadfilter` ist Pflicht, damit nicht Gregors eigenes Eudora gemessen wird; das Skript misst nur und schickt nichts |
| `tools/testlauf.ps1` | der **einzige** erlaubte Weg, Eudora zum Messen zu starten. **Öffnet ein Fenster — nur nach Absprache** |
| `tools/release-veroeffentlichen.ps1` | der **einzige** erlaubte Weg zu einem GitHub-Release. Erst nach Gregors eigenem Test — 1.0.27 war veröffentlicht und fehlerhaft zugleich |
| `tools/lehren-schranken.pl` | hält jede Lehre in `Arbeitsweise/` gegen die Schranke, die sie durchsetzen soll. Eine Lehre ohne Schranke ist Text |
| `tools/rollen-faellig.pl` | weist einen Push ab, solange eine Daueraufgabe (LEKTOR, PRUEFER, CHRONIST) fällig ist |

**Nicht in der Tabelle**, weil Hilfsmittel für einen einzelnen Befund:
`tools/befehl-schicken.ps1` (schickt `WM_COMMAND` an ein Fenster) und
`tools/zeiger-nachpruefen.pl` samt `tools/zeiger-nachpruefen-tests.pl`
(Nachprüfung der Zeigerhärtungen).

Ebenfalls nicht in der Tabelle, weil keine Werkzeuge: `tools/DEudora.ini`
(Vorgabewerte, siehe [ZIEL.md](ZIEL.md) unter A-1), `tools/Eudora starten.cmd`
(Starter im Paket), `tools/Kriterium0-pruefen.wsb` (Sandkasten für Kriterium 0)
sowie die Textdateien `tools/RELEASES.md`, `tools/TESTLAEUFE.md` und diese
Datei.

> **Der Bestand wächst.** Am 07.09.2026 waren es 37 Dateien in `tools/`, und
> diese Tabelle führte alle (Befund W-23, `Befunde/LEKTOR-4.md`). Wer die
> Übereinstimmung heute nachrechnen will, nimmt keine Zahl aus einer MD-Datei,
> sondern misst:
>
> ```sh
> for f in tools/*; do grep -qF "$(basename "$f")" tools/WERKZEUGE.md || echo "fehlt: $f"; done
> ```
