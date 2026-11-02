# <a id="pruefer-84"></a>PRUEFER-84

Lauf nach [PRUEFER-83](PRUEFER-83.md#pruefer-83). Geprüft wurde `253a8a40..HEAD -- Eudora71 tools Releases/1.0` auf Zweig wt/pruefer-20261102d (von `origin/hilfe_menue`). Inhaltlich sind das edf8eb47, a3b1b506, 0a4b77a1, 54af69ed und 54b7b5fa, dazu die Merges. Schwerpunkt ist [A-5](../Intern/BEFUNDE.md#a-5), das Hilfe-Menü für 7.2.2. Geprüft habe ich `CMainFrame::HilfeSeiteOeffnen` (`mainfrm.cpp`), die Kennungen in `resource.h`, Menü und Statuszeilen in `EudoraRes.rc`, `TestHilfeMenue.cpp`, `tools/hilfe-html.pl`, Schritt 5b in `paket-bauen.ps1`, die neue Prüfung in `paket-pruefen.ps1`, `messen-hilfe.ps1` und die Fälle `A-5p`/`A-5p-log`. Eudora habe ich weder gebaut noch gestartet. `C:\Temp\EHILFE` und `C:\Temp\EHILFE-alt` habe ich nur gelesen.

## Ergebnis vorweg

Das Hilfe-Menü ist richtig gebaut. Beide Einträge haben freie Kennungen, die mit keinem Befehlsbereich kollidieren. Sie stehen im richtigen Menü, haben eindeutige Beschleunigerbuchstaben und eine Statuszeile. Der Handler nimmt den Ordner der laufenden `Eudora.exe`, prüft die Datei vor dem Öffnen, meldet ein Fehlen mit Pfad und schreibt in allen drei Ausgängen eine Logzeile. Das Protokoll ist im Paket für diese Zeilen eingeschaltet. Das Werkzeug, das die zwei HTML-Seiten erzeugt, bricht ab, wenn ein Abschnitt fehlt, doppelt vorkommt oder umbenannt wurde. Seine Ausgabe für die heutige `FUNKTIONEN.md` ist sauber: kein Markdown-Rest, nichts doppelt maskiert, kein toter Anker. Die Testsuite läuft mit 365/365.

Die Schwachstelle ist der neue Quelltext-Test (K1). Er bleibt grün, wenn die Meldung „Datei fehlt“ nicht mehr mit `return` endet. Er bleibt auch grün, wenn `strrchr` den falschen Trenner sucht und damit jede Seite als fehlend gilt, und wenn die Prüfungen auf Verzeichnis oder leeren Ordner fehlen. Seine eigene Fehlermeldung verspricht, das `return` zu prüfen. Am Prüfstand würden die zwei schweren Fälle wohl auffallen, in der Suite nicht.

Dazu kommen fünf kleine Funde. Der Erzeuger lässt einen leeren Abschnitt durch (K2). Im Markdown-Umsetzer stecken Fehler, die die heutige Quelle nicht auslöst (K3). Der Regressionsfall prüft nur einen der beiden Einträge und nicht das Öffnen (K4). In zwei seltenen Lagen ist die Meldung irreführend (K5). Die ausgelieferten Seiten verweisen auf interne Projektdateien (K6).

Für das Paket: Keiner der Funde hält 7.2.2.0 auf. K1 sollte vor dem Merge nachgeschärft werden, sonst meldet die Schranke den Rückfall nicht.

## 1. Der Handler am Quelltext

- **Kennungen.** `ID_HELP_KEYBOARD_SHORTCUTS` 33270 und `ID_HELP_SETTINGS_REFERENCE` 33271 (resource.h:4466-4467, 0x81F6/0x81F7) liegen unter `QC_FIRST_COMMAND_ID` 33280 (resource.h:4471). Damit fallen sie in keinen `ON_COMMAND_EX_RANGE(QC_FIRST_COMMAND_ID, QC_LAST_COMMAND_ID, …)` der Ansichten und Rahmen. Auch die übrigen Bereiche treffen sie nicht: `TOOBAR_AD_CMD_BASE` 31000+50 (mainfrm.cpp:280), `ID_COLOR0..16` 32930–32946, Schriftgrößen 33005–33011, Anhänge 33103–33106, Playlist 33148–33157, Junk 33216–33217, `ID_EDIT_CTRL_2..9` 33222–33229, Sortierung 33241–33251. Unter `Eudora71/` werden 33270/33271 nirgends sonst vergeben, auch nicht in `OT501/Include/SECRES.H`, das `EudoraRes.rc` einbindet (dort 10900er-Bereich). Am Quelltext belegt.
- **Menü.** Es gibt genau ein `POPUP "&Help"` (EudoraRes.rc:5837). Die Beschleuniger T, C, S, B, p, K, f, R, I, A kommen je einmal vor. Ich habe keinen Code gefunden, der das Help-Menü über Positionen umbaut: `MAIN_MENU_HELP` (mainfrm.h:80) und `m_hHelpMenu` werden nirgends benutzt, alle `RemoveMenu`/`InsertMenu(…MF_BYPOSITION…)` in mainfrm.cpp betreffen Postfach-, Bearbeiten- und Tools-Menüs. Die neue Gruppe verschiebt also nichts. Belegt. In `theHelpButtons` (QCToolBarManager.cpp:227-235) fehlen beide Befehle. Man kann sie deshalb nicht auf eine Werkzeugleiste ziehen, genau wie *Report A Bug*. Das ist kein Fund.
- **Ressourcen-DLL.** Menütext und Statuszeilen stehen in `EudoraRes.dll`, der Handler steht in `Eudora.exe`. Gemessen an den Prüfständen: `C:\Temp\EHILFE\EudoraRes.dll` enthält „Keyboard Shortcuts“ (UTF-16) einmal, `Eudora.exe` enthält `Tastenkuerzel.html` und `Einstellungen.html` je einmal. In `EHILFE-alt` fehlt alles davon. `paket-pruefen.ps1` entscheidet anhand der EXE, ob die Seiten gebraucht werden. Das passt, solange EXE und Ressourcen-DLL aus demselben Bau stammen. Das prüft schon die bestehende Schranke (paket-bauen.ps1:549).
- **Pfad.** `GetModuleFileName(NULL, szExe, _MAX_PATH)` in einen Puffer `_MAX_PATH + 1`. Ein abgeschnittener Pfad (`nLen == _MAX_PATH`) ergibt einen leeren Ordner, und das wird als „fehlt“ gemeldet (K5). `strrchr(szExe, '\\')` und `pSlash[1] = '\0'` lassen den Rückstrich stehen, `+ "Hilfe\\" + szDatei` ergibt den richtigen Pfad. Belegt. Die Gegenprobe am Prüfstand zeigt genau diesen Pfad im Meldungstext ([A-5](../Intern/BEFUNDE.md#a-5), BEFUNDE.md:243). Damit ist auch die Pfadbildung gemessen, nicht nur `ShellExecute`.
- **Ausgänge.** Fehlt die Datei, ist ein Verzeichnis gemeint oder der Ordner leer, gibt es Logzeile, `AfxMessageBox` und `return` vor `ShellExecute`. Liefert `ShellExecute` ≤ 32, gibt es Logzeile, Meldung mit Code und `return`. Bei Erfolg gibt es eine Logzeile. Kein `ASSERT`. Belegt.
- **Protokoll.** `PutDebugLog(DEBUG_MASK_MISC, …)` mit `DEBUG_MASK_MISC = 0x8000` (QCUtils/public/inc/debug.h:36). Das Paket setzt `LogLevel=58527` = 0xE49F (tools/DEudora.ini:253, paket-bauen.ps1:686), das Bit ist also gesetzt. Belegt. In `C:\Temp\EHILFE\Mailverzeichnis\eudora.log` stehen die drei Zeilen (Zeilen 50, 139, 143, 144: `fehlt`, `geoeffnet`, `geoeffnet`, `fehlt`). Gemessen vom Hauptagenten, von mir nachgelesen.
- **Bytes.** Gegenüber 253a8a40 hat `mainfrm.cpp` weiter 18 CRLF und 0 Bytes >127, `EudoraRes.rc` 0 CRLF und 21 Bytes >127, `resource.h` 0 CRLF. Alle 77 neuen Zeilen in mainfrm.cpp enden auf LF, wie ihre Umgebung. Gemessen.

## 2. `tools/hilfe-html.pl`

- **Selbsttest:** `--selbsttest` 31 ok, 0 FEHLER. Gemessen.
- **Abbruch.** Ich habe drei abgewandelte Kopien von `FUNKTIONEN.md` mit `--quelle` gegeben. Ohne die Überschrift von Abschnitt 5 kommt `Abschnitt … nicht gefunden`, Rückgabe 1, das Zielverzeichnis wird nicht angelegt. Wird Abschnitt 2 von `##` auf `###` herabgestuft, kommt `nicht gefunden`, Rückgabe 1. Mit einem zweiten `## … Tools → Options` kommt `steht 2-mal`, Rückgabe 1. Gemessen. Ein Abschnitt, der zwar da, aber leer ist, geht durch (K2).
- **Ausgabe gegen die echte Quelle** (in mein Scratchpad erzeugt): `Tastenkuerzel.html` hat 25 668 B, `Einstellungen.html` 73 721 B, so groß wie die Seiten in `C:\Temp\EHILFE\Hilfe`. Außerhalb von `<code>` steht kein `*`, `\` oder `_`, kein `&amp;lt;` oder Ähnliches, kein Platzhalterzeichen U+E000, kein `](`. Gemessen.
- **Anker.** Kein toter Anker auf der Seite (Selbsttest). Außerdem habe ich die 56 + 1 Verweise auf `Doku/FUNKTIONEN.md#…` gegen die Anker aller Überschriften und `<a id>` der Datei gehalten. Dafür habe ich einen eigenen Nachbau benutzt, der `_` wie GitHub stehen lässt. Kein toter Verweis. Gemessen. Der Nachbau teilt mit dem Werkzeug die übrigen Annahmen über GitHubs Regel. Gegen github.com habe ich nicht geprüft.
- **Escaping.** `<`, `>`, `&`, `"` werden im Text, in Code und in `href` maskiert. `<script>` in der Quelle kommt als Text heraus (Selbsttest, dazu mein Versuch mit `<b>`). Links, die nicht auf die Seite zeigen, gehen nach `https://github.com/…/blob/main/…`. Ein `javascript:`-Ziel würde zu einem GitHub-Pfad, nicht zu einem Skript. Belegt (link_ziel, hilfe-html.pl:354-369).
- **Fassung im Seitenkopf** kommt aus `VERSION`, weil paket-bauen kein `--fassung` übergibt (paket-bauen.ps1:644). `kennung-erzeugen.pl` liest dieselbe Datei (kennung-erzeugen.pl:49). Seite und EXE stimmen also überein, solange `VERSION` zwischen Bau und Paket nicht geändert wird. Belegt, kein Fund.

## 3. Paketbau und Paketprüfung

- **paket-bauen 5b**: Ohne perl gibt es kein Paket. Bei Rückgabe ≠ 0 des Erzeugers gibt es kein Paket. Ist eine Seite unter 2000 B, gibt es kein Paket. Schritt 8 ersetzt danach nur MZ-Dateien, die Seiten bleiben unberührt. Das ZIP entsteht aus dem ganzen Verzeichnis (`CreateFromDirectory`, :778), `Hilfe\` ist also dabei. Belegt.
- **paket-pruefen**: Die Prüfung sucht die Dateinamen als ASCII in `Eudora.exe` und verlangt die Seite nur, wenn der Name dort steht. Am alten Bau wird das übersprungen: `EHILFE-alt\Eudora.exe` enthält die Namen nicht (gemessen, s. o.). Fehlt die Seite oder ist sie kleiner als 2000 B, meldet sie `Melde-Fehler`. Belegt. Den Lauf selbst habe ich nicht gefahren, weil er Defender über einen Prüfstand unter `C:\Temp` schickt.

## 4. Testsuite und Gegenproben (in meinem Baum)

Gemessen. Die Basis lief über `cmd /c Eudora71\Tests\RunTests.cmd`. Die Gegenproben liefen gegen das gebaute `EudoraTests.exe`, das die Quelltexte zur Laufzeit liest.

| Lauf | Änderung (vorübergehend) | Ergebnis |
|---|---|---|
| 0 | keine | 365/365 |
| G1 | mainfrm.cpp: `strrchr(szExe, '\\')` → `strrchr(szExe, '/')` (Ordner bleibt leer, jede Seite gilt als fehlend) | **365/365, grün** (K1) |
| G2 | mainfrm.cpp: `return;` hinter der Fehlt-Meldung entfernt (Durchfall zu `ShellExecute` auf eine fehlende Datei, zweite Meldung) | **365/365, grün** (K1) |
| G3 | mainfrm.cpp: `(dwAttr & FILE_ATTRIBUTE_DIRECTORY)` → `FALSE` | **365/365, grün** (K1) |
| G4 | mainfrm.cpp: `strOrdner.IsEmpty() \|\| ` entfernt | **365/365, grün** (K1) |
| G5 | mainfrm.cpp: `nErgebnis <= 32` → `< 32` | 364/365, rot *Handler im MESSAGE_MAP …*. Positivprobe: der Test lebt |
| G6 | resource.h: `ID_HELP_SETTINGS_REFERENCE` 33271 → 33268 (= `IDS_DIRSERV_SERVER_DOWN`) | 364/365, rot *Kennungen … keine Nummer doppelt* |

Ersetzt wurde mit Perl `:raw`, Suchtext und Ersatz kamen aus Dateien, die Trefferzahl war jeweils 1. Nach jedem Lauf habe ich die Sicherung zurückkopiert. `cmp` meldete keinen Unterschied, `git status` war leer.

## 5. Messskript und Prüfstandsfall

- **Trifft es den Weg?** Ja. `menue=` liest das echte Hauptmenü (`GetMenu`/`GetSubMenu`, Text roh, Kennung, Stelle, Graustufe nach `WM_INITMENUPOPUP`). Die Gegenprobe benennt den Ordner um, schickt `WM_COMMAND` 33270 und liest das Meldungsfenster. `fehlt-meldung=1` gibt es nur, wenn der Text **und** der erwartete volle Pfad stimmen, das Fenster mit OK zugeht und kein Browserprozess entsteht (messen-hilfe.ps1:342-352). Belegt.
- **Gegenprobe haltbar?** Ja für den alten Bau. Dort fehlen Menü und Meldung, das ergibt `menue=0 … fehlt-meldung=0` (WERKZEUGE.md, von mir nicht nachgemessen). Am Skript gelesen würden auch G1 und G2 rot: Bei G1 fehlt der Ordner im gemeldeten Pfad, also `text-passt=0`. Bei G2 bleibt nach OK ein zweites Meldungsfenster des Prozesses offen, Schritt 4 setzt dann `lebt=0`. Das ist eine Vermutung aus dem Skript, nicht gemessen.
- **Log-Fall.** `pruefstand-lauf.ps1` löscht die `eudora.log` vor jedem Lauf (:232). Die Zeilen 139/143 (`geoeffnet`) aus dem Browserlauf im heutigen Log stören `A-5p-log` (*darf nicht: geoeffnet*) deshalb nicht. Belegt.
- **Was er nicht misst:** siehe K4.

## 6. Funde

### K1: Quelltext-Test bleibt grün bei Durchfall, falschem Trenner und fehlenden Schutzabfragen

Gemessen (G1–G4). `Test_Hilfe_Handler` schneidet den Fehlt-Zweig mit `QT_Abschnitt(pFn, "dwAttr == INVALID_FILE_ATTRIBUTES", "return; }")` aus. Fehlt das `return`, reicht der Ausschnitt bis zum `return; }` des `ShellExecute`-Zweigs. Darin stehen die gesuchte Logzeile und `AfxMessageBox` ebenfalls, also bleibt der Test grün. Seine Meldung sagt aber ausdrücklich *„oder der Zweig endet nicht mit return“*. Die Folge von G2 beim Anwender: Erst kommt die Fehlt-Meldung, dann ruft Eudora `ShellExecute` auf eine fehlende Datei, und es kommt eine zweite Meldung „could not open … error code 2“. Den Trenner in `strrchr` prüft der Test gar nicht. Genau dieser Rückstrich war vor 0a4b77a1 schon einmal falsch (`'\'`). Damals hat der Compiler es gemerkt, `'/'` würde er nicht melden. Mit G1 gilt jede Seite als fehlend, das Menü zeigt nur noch die Meldung.

Vorschlag: Nach `QT_LeerraumZusammen` die Folge `MB_ICONEXCLAMATION); return; } const INT_PTR nErgebnis` verlangen, außerdem `strrchr(szExe, '\\')`, `strOrdner.IsEmpty() ||` und `(dwAttr & FILE_ATTRIBUTE_DIRECTORY)`. Der Prüfstandsfall `A-5p` fängt G1 und G2 vermutlich (Abschnitt 5), läuft aber nicht mit der Suite. **Schwere: mittel** (die Suite schützt die zwei Ausgänge nicht, die sie zu schützen behauptet).

### K2: Leerer Abschnitt geht durch den Erzeuger

Gemessen: Eine Quelle, in der alle drei Überschriften stehen, aber kein Inhalt, ergibt Rückgabe 0 und Seiten mit 1751 B (`Tastenkuerzel.html`) und 1896 B (`Einstellungen.html`). Aufgehalten wird so ein Paket nur von der 2000-B-Schwelle in paket-bauen und paket-pruefen. Der Abstand ist 249 bzw. 104 B. Ein Abschnitt mit einem einzigen Satz („folgt“) käme durch, und die Seite wäre praktisch leer. Vorschlag: im Erzeuger je Abschnitt mindestens eine Tabelle verlangen (beide Seiten bestehen heute aus Tabellen: 6 bzw. 33 `<thead>`, gemessen) und sonst mit Rückgabe 1 abbrechen. **Schwere: gering.**

### K3: Latente Fehler im Markdown-Umsetzer

Die heutige `FUNKTIONEN.md` löst keinen davon aus (Abschnitt 2). Gemessen mit eigenen Eingaben an `inline()`:

- Ein Rückstrich-maskiertes Zeichen im **Linktext** wird doppelt maskiert: `[a \< b](x.md)` ergibt `a &amp;lt; b`. `[x \& y](#y)` ergibt `x \&amp; y`, der Rückstrich bleibt also sogar stehen (`&` fehlt in der Maskenliste, hilfe-html.pl:318). Ursache: `link_html` setzt die schon maskierten Platzhalter zurück und `inline_ohne_links` maskiert noch einmal (:334-345).
- Ein Linkziel mit `)` wird abgeschnitten: `[foo](https://e.org/a_(b))` ergibt `href="https://e.org/a_(b"` und dahinter ein `)` im Text (:320).
- `slug` entfernt jedes `_` (:143). GitHub lässt `_` im Anker stehen. Eine Überschrift mit `_` in Code, etwa ein INI-Schlüssel, bekäme einen anderen Anker als auf GitHub. Der Selbsttest würde das nicht merken, weil er Werkzeug gegen Werkzeug prüft. Heute hat keine Überschrift ein `_` (gemessen).
- Mit `--quelle` nennt die Fehlermeldung trotzdem `Doku/FUNKTIONEN.md` (:175-176).

**Schwere: gering.**

### K4: Regressionsfall deckt nur einen Eintrag und nicht das Öffnen ab

`A-5p`/`A-5p-log` prüfen das Menü für beide Einträge, die Fehlt-Meldung aber nur für *Keyboard Shortcuts*. *Settings Reference* → `Einstellungen.html` ist am Programm nur im Browserlauf des Hauptagenten gemessen (Logzeile 143). Danach schützt es allein der Quelltext-Test. Das Öffnen selbst (`ShellExecute` > 32) ist bewusst nicht im Regressionslauf (Browser, Registerkarten). Belegt an pruefstand-faelle.txt und messen-hilfe.ps1:322-359. Vorschlag: in der Gegenprobe zusätzlich 33271 schicken und die Meldung mit `Einstellungen.html` verlangen. Das kostet keinen Browser. **Schwere: gering.**

### K5: Irreführende Meldung in zwei Randlagen

- Liegt `Eudora.exe` unter einem Pfad mit Zeichen außerhalb der ANSI-Codepage, liefert `GetModuleFileNameA` dafür `?`. Dann scheitert `GetFileAttributes`, und Eudora meldet „could not be found“, obwohl die Datei da ist. Das gilt auch für einen Pfad mit 260 oder mehr Zeichen (`nLen == _MAX_PATH`, leerer Ordner). Dort zeigt die Meldung nur `Hilfe\Tastenkuerzel.html` ohne Ordner. Am Quelltext belegt (mainfrm.cpp, `HilfeSeiteOeffnen`). Dass Eudora in so einem Pfad sonst läuft, habe ich nicht geprüft.
- `ShellExecute(NULL, …)` ohne `SEE_MASK_FLAG_NO_UI`: Gibt es keine Zuordnung für `.html`, kann Windows einen eigenen Dialog zeigen, und danach käme noch Eudoras Meldung mit Code. Das ist eine Vermutung, nicht gemessen.

**Schwere: gering.**

### K6: Ausgelieferte Seiten verweisen auf interne Projektdateien

Gemessen an der erzeugten `Einstellungen.html`: 16 Verweise auf `Intern/BEFUNDE.md`, 7 auf `Intern/EINSTELLUNGEN.md`, 4 auf `Intern/FILTER.md`, 1 auf `Intern/TESTPLAN.md`. Zwei Stellen nennen den Projektinhaber namentlich als Bestätiger. `Tastenkuerzel.html` hat 4 Verweise auf `Intern/BEFUNDE.md`. Alle Verweise zeigen auf den Zweig `main`, also auf den jeweils neuesten Stand und nicht auf den Stand des Pakets. Das ist kein technischer Fehler, aber eine Frage an Gregor: Sollen Anwender diese Spalte (*Herkunft*) und die internen Verweise sehen? **Schwere: gering** (Inhalt, nicht Funktion).

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | `TestHilfeMenue` bleibt grün ohne `return` im Fehlt-Zweig, mit falschem Trenner in `strrchr` und ohne Verzeichnis- bzw. Leer-Prüfung | mittel | nein, vor dem Merge nachschärfen |
| K2 | Erzeuger nimmt einen leeren Abschnitt an; nur die 2000-B-Schwelle (Abstand 104 B) hält ihn auf | gering | nein |
| K3 | Linktext mit Maskierung wird doppelt maskiert, Linkziel mit `)` abgeschnitten, Anker ohne `_`; heute nicht ausgelöst | gering | nein |
| K4 | Regressionsfall prüft die Fehlt-Meldung nur für *Keyboard Shortcuts*, nicht für *Settings Reference* | gering | nein |
| K5 | Pfad mit Nicht-ANSI-Zeichen oder ≥ 260 Zeichen: „could not be found“ trotz vorhandener Datei; ohne `.html`-Zuordnung evtl. zwei Dialoge | gering | nein |
| K6 | Hilfeseiten für Anwender verweisen auf `Intern/…` und nennen den Projektinhaber; Links auf `main` statt auf den Paketstand | gering | nein, Entscheidung Gregor |

## Nachtrag 02.11.2026

Geprüft habe ich `05943a87..origin/hilfe_menue`, inhaltlich 1aa731fc („K1–K6 eingearbeitet“). Im Mittelpunkt stehen der umgebaute `CMainFrame::HilfeSeiteOeffnen`, `TestHilfeMenue.cpp` und `hilfe-html.pl`. Eudora habe ich weder gebaut noch gestartet.

### Ergebnis vorweg

K1 bis K6 sind erledigt. Die Gegenproben aus K1 machen den Test jetzt rot. Die Hilfeseiten verlinken nichts Internes mehr, nennen keinen Namen, und ein leerer Abschnitt bricht ab. Der neue Handler ist richtig gebaut. Der Test hat aber dieselbe Art Lücke behalten wie vorher: Sechs neue Gegenproben am Handler bleiben grün. Die schwerste davon (N1) lässt den Rückstrich am Ordner weg, und dann gilt jede Seite als fehlend. Dazu kommen drei kleine Funde: tote Links auf eine noch nicht vorhandene Release-Marke (N2), das Präfix `\\?\` für Netzwerkpfade (N3) und ein Fehlercode, der verloren geht (N4). Nichts davon hält 7.2.2.132 auf.

### Der neue Handler am Quelltext

- **Puffer.** `CStringW strExe`, `GetBuffer(32768)`, `GetModuleFileNameW(NULL, …, 32768)`. Liefert die Funktion 0 oder 32768 (abgeschnitten), setzt `ReleaseBuffer(…? nLen : 0)` die Länge auf 0. Der Ordner ist dann leer, und das endet in der Meldung „fehlt“. Ein Überlauf ist nicht möglich: `GetBuffer(n)` reserviert n+1 Zeichen. Belegt.
- **Ordner.** `ReverseFind(L'\\')` und `Left(iTrenner + 1)` behalten den Rückstrich, `+ L"Hilfe\\" + CStringW(szDatei)` setzt den Pfad zusammen. `szDatei` ist ASCII, die Umwandlung ist verlustfrei. Belegt.
- **Präfix.** Ab `MAX_PATH` Zeichen geht `\\?\` + Pfad an `GetFileAttributesW`. `ShellExecuteExW` bekommt den Pfad ohne Präfix. Für lokale Pfade ist das richtig. Für UNC-Pfade und für einen Pfad, der schon mit `\\?\` beginnt, siehe N3. Belegt.
- **Unicode/ANSI.** Das Projekt ist MBCS. Alle Zugriffe auf Dateien und die Shell laufen breit. In die ANSI-Welt geht nur `CString strPfad(strPfadW)` für den Meldungstext, und dort werden nicht darstellbare Zeichen zu `?` (so kommentiert). Log und Meldungen bleiben `char`. Diese Mischung ist sauber getrennt. Belegt.
- **Rückgabe.** `hInstApp` ist bei Erfolg größer als 32 und bei Fehlschlag ein `SE_ERR_*`-Wert. Die Abfrage `!bGeoeffnet && nErgebnis > 32 → 0` fängt einen Fehlschlag ohne SE-Code. `sei` ist genullt, `hInstApp` steht also ohne Setzen auf 0. Belegt (siehe N4).
- **Eine Meldung je Fehlerfall.** Fehlt die Datei: eine Meldung, dann `return` vor `SHELLEXECUTEINFOW`. Scheitert `ShellExecuteExW`: wegen `SEE_MASK_FLAG_NO_UI` kein Windows-Dialog und genau ein `AfxMessageBox`, mit eigenem Text für `SE_ERR_NOASSOC`. Erfolg: keine Meldung. Belegt, die Anzahl prüft der Test (`QT_Zaehle(…AfxMessageBox(…) == 1`).
- **Bytes.** `mainfrm.cpp`: CRLF 18, nur LF 10689, >127 0. Das ist dasselbe Muster wie vorher, ohne neue CRLF. `TestHilfeMenue.cpp`: nur LF. Gemessen.

### Testsuite und Gegenproben

`cmd /c Eudora71\Tests\RunTests.cmd` mit Neubau auf 1aa731fc ergibt 365/365. Gemessen. Für jede Gegenprobe habe ich nur mainfrm.cpp vorübergehend geändert und danach zurückkopiert. `cmp` meldete jedes Mal keinen Unterschied, `git status` war leer.

| Lauf | Änderung | Ergebnis |
|---|---|---|
| P1 | `return;` im Fehlt-Zweig entfernt (alte G2) | rot, Handler-Test. K1 erledigt |
| P2 | `ReverseFind(L'\\')` → `L'/'` (alte G1) | rot. K1 erledigt |
| H1 | Zeile `if (!bGeoeffnet && nErgebnis > 32) nErgebnis = 0;` entfernt | **365/365, grün** (N1) |
| H2 | Präfix weg: `strPruefW = strPfadW` | **grün** (N1) |
| H3 | `sei.lpFile = strPruefW` (mit Präfix an die Shell) | **grün** (N1) |
| H4 | `ReleaseBuffer()` ohne Längenprüfung | **grün** (N1) |
| H5 | `strExe.Left(iTrenner + 1)` → `Left(iTrenner)`: Ordner ohne Rückstrich, Pfad `…\EHILFEHilfe\…`, jede Seite „fehlt“ | **grün** (N1) |
| H6 | `bGeoeffnet = TRUE`, die Rückgabe von `ShellExecuteExW` wird verworfen | **grün** (N1) |

### `hilfe-html.pl`

- `--selbsttest` ergibt 47 ok, 0 FEHLER. Mit `--fassung 7.2.1.131` in mein Scratchpad erzeugt: 25 661 B und 71 003 B. Kein `href` auf `Intern/`, `Befunde/`, `Arbeitsweise/` oder `tools/`, kein Personenname, kein Markdown-Rest. Der Seitenkopf zeigt „Commit 1aa731fc“, die Quelle ist sauber. Gemessen. **K6 erledigt.** Verlinkt bleiben nur `Doku/FUNKTIONEN.md`, `FAQ.md` und `ANWENDER.md`.
- **K2 erledigt:** Unter 5 Tabellenzeilen je Abschnitt gibt es einen Abbruch (Selbsttest: 0 und 2 Zeilen). Die echte Quelle hat 68, 233 und 20 Zeilen (gemessen), das ist weit über der Schwelle.
- **K3 erledigt:** Maskierung im Linktext nur einmal, auch `\&`. Das Ziel darf ein Klammerpaar enthalten. Ein Link in Klammern schließt nicht an der äußeren Klammer. `_` bleibt im Anker. Mit `--quelle` nennt die Meldung die echte Datei. Alles im Selbsttest, beide Richtungen.
- Die Namensschranke prüft nur einen einzigen Namen, und zwar im Rumpf, nicht im Titel. Für den heutigen Bestand genügt das. Die Liste muss wachsen, wenn ein anderer Name auftaucht. Kein Fund.
- **K4 erledigt:** `messen-hilfe.ps1` schickt in der Gegenprobe 33270 und 33271, verlangt beide Meldungen mit Pfad und wertet ein zweites Meldungsfenster nach OK als Fehler. Belegt am Skript, den Lauf habe ich nicht gefahren.

### Funde

#### N1: Der Handler-Test lässt die neuen Teile ungeschützt

Gemessen (H1–H6, Tabelle oben). Der Test prüft Aufrufe und Abfragen dem Wortlaut nach. Nicht geprüft werden die Ordnerbildung `Left(iTrenner + 1)`, die Länge in `ReleaseBuffer`, das Präfix, die Zuweisung an `lpFile`, die Auswertung von `bGeoeffnet` und die Abfrage für einen Fehlschlag ohne SE-Code. H5 ist dieselbe Fehlerklasse wie die alte G1: Jede Seite gilt als fehlend, und die Suite bleibt grün. Der Prüfstandsfall `A-5p` würde H5 wohl fangen, weil er den erwarteten Pfad im Meldungstext verlangt. Das habe ich am Skript gelesen, nicht gemessen. H1, H2, H3, H4 und H6 treffen nur Fehlerfälle oder sehr lange Pfade, die der Prüfstand nicht herstellt.

Vorschlag: zusätzlich `strOrdnerW = strExe.Left(iTrenner + 1);`, `sei.lpFile = strPfadW;`, `const BOOL bGeoeffnet = ::ShellExecuteExW(&sei);`, `if (!bGeoeffnet && nErgebnis > 32)` und die Präfix-Zeile verlangen. **Schwere: gering bis mittel** (H5 schaltet die Funktion ganz ab, der Prüfstand fängt es wahrscheinlich).

#### N2: `--fassung` verlinkt auf eine Marke, die es beim Paketbau noch nicht gibt

`paket-bauen.ps1` übergibt `VERSION` als `--fassung`, die Links zeigen dann auf `blob/v<VERSION>/…`. Die Marke entsteht erst bei der Veröffentlichung, nach Gregors lokalem Test. Bis dahin führen alle Links der Seiten ins Leere: 23 in `Einstellungen.html` und 60 in `Tastenkuerzel.html` (gemessen, mit 7.2.1.131 als Beispiel). Wird eine Nummer nie veröffentlicht, bleiben sie für immer tot. Das gilt auch, wenn die Marke auf einen späteren Commit gesetzt wird, dessen `FUNKTIONEN.md` andere Überschriften hat: Dann sind die Anker tot. `git tag -l 'v7.2.2*'` liefert heute nichts. Belegt am Werkzeug, die Wirkung beim Anwender ist eine Vermutung.

Vorschlag: auf den Commit der Quelle verlinken (`blob/<commit>/`). Der steht im Seitenkopf schon, sobald die Quelle sauber committet ist, und existiert sicher. Oder bewusst so lassen und im TESTPLAN vermerken, dass Links erst nach dem Release gehen. **Schwere: gering.**

#### N3: `\\?\` passt nicht zu UNC-Pfaden und nicht zu einem schon präfixierten Pfad

Liegt `Eudora.exe` auf einer Netzfreigabe (`\\server\share\…`) und ist der Pfad 260 Zeichen oder länger, entsteht `\\?\\\server\…`. Gültig wäre `\\?\UNC\server\…`. `GetFileAttributesW` scheitert, und Eudora meldet „fehlt“. Liefert `GetModuleFileNameW` selbst schon einen Pfad mit `\\?\` (Start über so einen Pfad), wird das Präfix verdoppelt. Belegt an der Windows-Pfadregel. Ob das bei Eudora vorkommt, ist eine Vermutung, beides ist sehr selten. Außerdem bekommt `ShellExecuteExW` einen Pfad mit 260 oder mehr Zeichen ohne Präfix. Ob Shell und Browser ihn öffnen, ist nicht gemessen. Wenn nicht, kommt eine ehrliche Fehlermeldung. **Schwere: gering.**

#### N4: Fehlschlag ohne SE-Code wird als `fehler=0` gemeldet

Scheitert `ShellExecuteExW` mit einem `hInstApp` über 32, schreiben Logzeile und Meldung „0“. `GetLastError()` wird nicht festgehalten, die eigentliche Ursache geht verloren. Belegt. Vorschlag: `GetLastError()` in Logzeile und Meldung aufnehmen. **Schwere: gering.**

### Übersicht Nachtrag

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1–K6 | eingearbeitet; P1/P2 jetzt rot, Selbsttest 47/47, keine internen Links, kein Name | – | – |
| N1 | Handler-Test bleibt grün bei Ordner ohne Rückstrich (jede Seite „fehlt“), ohne Präfix, Präfix an die Shell, ohne Längenprüfung, verworfener Rückgabe, fehlender Abfrage auf Fehlschlag ohne SE-Code | gering bis mittel | nein, vor dem Merge nachschärfen |
| N2 | Links auf `blob/v<VERSION>/` sind tot, bis die Marke existiert, und für nie veröffentlichte Nummern für immer | gering | nein |
| N3 | `\\?\` vor UNC-Pfad oder schon präfixiertem Pfad: „fehlt“ trotz vorhandener Datei (ab 260 Zeichen) | gering | nein |
| N4 | Fehlschlag ohne SE-Code: `fehler=0`, `GetLastError` fehlt | gering | nein |
