# <a id="pruefer-103"></a>PRUEFER-103

Geprüft habe ich den Stand `7739b889` des Zweigs `paket_7_2_2_136` (veröffentlicht als v7.2.2.136). Mein Zweig ist wt/pruefer-20261106. Geprüft ist alles, was seit `3387d346` unter `Eudora71/`, `tools/` und `Releases/1.0` dazukam (`git log 3387d34..HEAD -- Eudora71 tools Releases/1.0`, 14 Commits): [E-239](../Intern/BEFUNDE.md#e-239) (`mainfrm.cpp`/`mainfrm.h`, `TestE239.cpp`), [E-169](../Intern/BEFUNDE.md#e-169) (`TridentView.cpp`, `EudoraRes.rc`, `resource.h`, `TestE169.cpp`), der Versionssprung, die Messskripte `messen-e239.ps1` und `messen-e169.ps1` mit `e169-bildserver.pl`, die Fälle in `pruefstand-faelle.txt` und die neue Schranke `tools/testplan-voraussetzungen.pl` in `paket-bauen.ps1`. Unter `Releases/1.0` hat sich nichts geändert. Eudora habe ich weder gebaut noch gestartet, kein Fenster geöffnet, keinen Prüfstand angefasst. Die Testsuite habe ich in meinem Baum gebaut und gefahren. Gelesen habe ich außerdem den Registrierungsschlüssel `HKCU\Software\Microsoft\Internet Explorer\PageSetup` dieses Rechners (nur lesen).

## Ergebnis vorweg

**Am Programmcode selbst habe ich keinen Fehler gefunden, der das nächste Paket aufhält.** `mainfrm.cpp` und `TestE239.cpp` sind seit `3282be36` unverändert. Dort gilt [PRUEFER-102](https://github.com/HansWurst81675/Eudora7.2/blob/wt/pruefer-20261105c/Befunde/PRUEFER-102.md) weiter. Die Behebung von [E-169](../Intern/BEFUNDE.md#e-169) tut am Quelltext, was der Befund sagt: Sie setzt den Wert nur mit dem Schalter, nur für den einen Aufruf und stellt ihn danach wieder her, auch wenn er vorher fehlte.

**Die Nacharbeit zu PRÜFER-102 ist nicht im Paket (K1).** Der Commit `2d8f7dfa` liegt nur auf `origin/e239_absturz_beenden`. Er schärft den Test für [E-239](../Intern/BEFUNDE.md#e-239) nach und gibt dem Prüfstand ein Urteil. Weder `paket_7_2_2_136` noch `main` enthalten ihn, und auch der Bericht PRÜFER-102 selbst fehlt dort. Ausgeliefert ist also der schwache Test: Ich habe heute an `7739b889` nachgemessen, und er bleibt grün, wenn die Zeile fehlt, die den Absturz verhindert. Auch die Reste K4 bis K6 aus PRÜFER-102 stehen in `Intern/BEFUNDE.md` des Pakets nicht. **Wird der Zweig so nachgemergt, wie er ist, wird der Prüfstandfall wieder unzuverlässig (K2).** Das Hilfsskript dort legt die Betriebsart `exit-close` fest. Genau die hat das Paket am 06.11. als Wettlauf erkannt und durch `hinweis-exit-close` ersetzt. Dazu kommen fünf Merge-Konflikte.

**Der neue Test zu [E-169](../Intern/BEFUNDE.md#e-169) hat dieselbe Schwäche wie damals der zu [E-239](../Intern/BEFUNDE.md#e-239) (K3).** Von fünf vorübergehenden Änderungen an `CTridentView::Print` bemerkt er nur eine. Grün bleibt er zum Beispiel, wenn Eudora den Registrierungswert nach dem Druck nie mehr zurücksetzt. Dann druckt jedes Programm auf dem Rechner, das den Internet Explorer zum Drucken benutzt, dauerhaft mit Hintergründen.

Zwei offene Punkte am Druck (K4, K5, Vermutung): Die Vorschau ist nicht modal, der Wert steht also schon wieder auf „fehlt“, während sie offen ist. Was beim Drucken **aus der Vorschau heraus** geschieht, ist nicht gemessen. Fehlt der Schlüssel `PageSetup` ganz, wirkt der Schalter still nicht. Die Schranke `testplan-voraussetzungen.pl` arbeitet wie beschrieben, ihr Selbsttest ist grün (10/10). Ein paar Grenzen sollte man kennen (K6).

**Kein Fund hält das nächste Paket auf.** K1 und K2 gehören vor den nächsten Merge, der [E-239](../Intern/BEFUNDE.md#e-239) berührt. K3 sollte mit dem nächsten Paket nachgezogen werden. Neue E-Kennungen vergebe ich nicht. Die Funde gehören als Rest zu [E-239](../Intern/BEFUNDE.md#e-239), [E-169](../Intern/BEFUNDE.md#e-169) und [E-242](../Intern/BEFUNDE.md#e-242). `befund-suchen.pl TridentView.cpp` nennt [E-169](../Intern/BEFUNDE.md#e-169), [E-240](../Intern/BEFUNDE.md#e-240) und [E-242](../Intern/BEFUNDE.md#e-242), einen weiteren Befund zu `Print` nennt es nicht.

## 1. E-239 im Paket

**Quelltext (belegt).** `git diff 3282be36 7739b889 -- Eudora71/Eudora/mainfrm.cpp Eudora71/Eudora/mainfrm.h Eudora71/Tests/TestE239.cpp` ist leer. Was PRÜFER-102 §1 und §2 am Quelltext belegt, gilt damit unverändert für v7.2.2.136. Ebenso gelten die Funde K4 (*nur im Infobereich*), K5 (ein aufgeschobener Schließwunsch übergeht ein späteres *Abbrechen*) und K6 (Abmeldung während des Beendens).

**Messskript (belegt).** Neu im Paket sind die Betriebsarten `hinweis-exit` und `hinweis-exit-close` (`messen-e239.ps1:25-32`, :234-239). Beide warten, bis nach dem `QUIT` ein Dialog erscheint, und schicken erst dann den Schließwunsch. Der Wettlauf von `exit-close` ist damit für den Prüfstandfall weg. `E-239p` und `E-239w` haben dasselbe Verzeichnis und denselben Schalter. `pruefstand-lauf.ps1:181` fasst sie deshalb zu **einem** Lauf zusammen. Die Positivprobe `E239 PROBE ok` gehört also zum selben Lauf wie `absturz=0 beendet=1`. Das ist richtig so.

Was aus PRÜFER-102 K2 im Paket offen bleibt (belegt):
* Die Betriebsart steht weiter nur in `C:\Temp\E239\modus.txt`, außerhalb des Repos. Fehlt die Datei, gilt still `einfach` (`messen-e239.ps1:70-75`). Der Kommentar in `pruefstand-faelle.txt` nennt `hinweis-exit-close`. Ein Werkzeug, das die Datei schreibt, gibt es im Paket nicht.
* Als „Hinweis“ zählt jeder Dialog, der nach dem `QUIT` neu erscheint (:213). Unter `hinweis-exit-close` ist das unschädlich, weil vor dem Exit noch kein `CloseDown` läuft und es dessen Rückfragen noch nicht gibt (Vermutung, am Weg plausibel).

**Gregors Test (gelesen in `Intern/TESTPLAN.md`).** Schritt 3 (*Exit* im Menü des Symbols im Infobereich bei offenem Hinweis) ist bestanden, mit den Spurzeilen *aufgeschoben* und *nachgeholt* aus seiner `eudora.log`. Damit ist PRÜFER-102 K7 am echten System gemessen, und zwar über den Aufschub. Merker und `DestroyWindow`-Zeitgeber sind weiter ungemessen (PRÜFER-102 §3).

## 2. E-169 am Quelltext

`CTridentView::Print` (`TridentView.cpp:2318-2484`):

* **Schalter (belegt).** `GetIniShort(IDS_INI_PRINT_BACKGROUND)` (:2417), Vorgabe `0` (`EudoraRes.rc:7696`), ID 11153 nur einmal in `resource.h:3581`. Mit `0` wird nichts geöffnet und nichts geschrieben. Das Verhalten ist dann byte-gleich zum Original.
* **Setzen (belegt).** Gesetzt wird nur, wenn das Lesen `ERROR_SUCCESS` oder `ERROR_FILE_NOT_FOUND` liefert (:2426). Ein Wert über 64 Byte (`ERROR_MORE_DATA`) bleibt unangetastet. `"yes"` mit Länge 4 enthält die abschließende Null, so verlangt es `REG_SZ`.
* **Wiederherstellen (belegt).** Nur bei `bSetBackground` (:2458): der alte Typ und die alte Länge, sonst `RegDeleteValue`. Die Reihenfolge stimmt: erst Kopf und Fuß (:2440-2454), dann der Hintergrund. Schlägt das zweite `RegOpenKeyEx` fehl, bleibt `yes` stehen, und keine Spurzeile sagt es. Das ist dieselbe Lücke wie bei Kopf und Fuß im Original (:2442-2444, nur `ASSERT`).
* **Rückkehr vor dem Setzen (belegt).** Der einzige vorzeitige Ausstieg (`WM_QUIT`, :2334-2339) liegt vor :2412. Es bleibt also nichts gesetzt zurück.
* **Verschachtelt (Vermutung, unschädlich).** Läuft ein zweites `Print`, während das erste noch in `ExecCommandOnNullSet` steckt, liest das innere `yes` als alten Wert und stellt `yes` wieder her. Danach löscht das äußere. Das Ergebnis ist richtig.
* **Andere Druckwege (belegt).** `OLECMDID_PRINT`/`OLECMDID_PRINTPREVIEW` gibt es nur in `TridentView.cpp:2436`. *Print*, *Print One* und *Print Preview* (:3210-3223) und `QuietPrint` (:2313) laufen alle hier durch. Paige-Fenster drucken über MFC und sind nicht betroffen. Das sagt auch `EINSTELLUNGEN.md`.

Die Doku (`EINSTELLUNGEN.md:171`, :220, `FAQ.md:503`, `FUNKTIONEN.md:971`) stimmt mit dem Quelltext überein und nennt den ungemessenen Druck auf Papier offen.

## 3. Gegenproben an den Tests

`TestE169` und `TestE239` lesen die Quelle zur Laufzeit (`QT_LiesNurCode`). Ich habe die jeweilige Datei vorübergehend mit Perl geändert (`:raw`, Ersatz über Regex, genau 1 Treffer), `EudoraTests.exe` in meinem Baum gefahren und die Datei aus der Sicherung im Speicher zurückgeschrieben. Nach jeder Probe war sie byte-gleich zur Sicherung. Am Ende war `git status` leer (gemessen).

| Probe | Änderung | Ergebnis (gemessen) |
|---|---|---|
| ohne | `7739b889`, `RunTests.cmd` (gebaut) | 428 Tests, 428 bestanden |
| H1 | `bSetBackground = TRUE;` gestrichen: der Wert bleibt nach dem Druck für immer `yes` | **428 bestanden** |
| H2 | `if (bHadBackground)` → `if (!bHadBackground)`: ein vorhandener Wert des Anwenders wird gelöscht | **428 bestanden** |
| H3 | `bHadBackground = TRUE;` fest: statt zu löschen, wird der ungelesene Puffer (Typ 0) geschrieben | **428 bestanden** |
| H4 | `OldBackgroundLen = sizeof(OldBackground);` gestrichen: ein vorhandener Wert liest sich nie (Länge 0), Schalter wirkungslos | **428 bestanden** |
| H5 | `if (GetIniShort(…))` → `if (!GetIniShort(…))` | 427 bestanden, 1 rot ([E-169](../Intern/BEFUNDE.md#e-169)) |
| G6 | `mainfrm.cpp`: `return;` hinter *weiteres Schliessen ignoriert* gestrichen (PRÜFER-102 G6, Absturzweg offen) | **428 bestanden** |
| G3 | `mainfrm.cpp`: `return;` des Aufschubs gestrichen (PRÜFER-102 G3) | **428 bestanden** |

Das Skript liegt im Scratchpad der Sitzung, nicht im Repo.

## Funde

### <a id="k1"></a>K1 (mittel, gemessen): Die Nacharbeit zu PRÜFER-102 ist nicht im Paket und nicht auf `main`

`2d8f7dfa` *„[E-239](../Intern/BEFUNDE.md#e-239): PRUEFER-102 K1/K2 – TestE239 prueft jeden Schutz ganz, Fall E-239p mit Urteil und fester Betriebsart“* liegt nur auf `origin/e239_absturz_beenden` (`git branch -r --contains 2d8f7dfa`). Weder `7739b889` noch `origin/main` enthalten ihn (`git merge-base --is-ancestor`: nein). Mit ihm fehlen:
* der geschärfte `TestE239.cpp`. Am ausgelieferten Stand bleiben G3 und G6 grün (§3, heute nachgemessen),
* `Befunde/PRUEFER-102.md`. Er liegt sonst nur noch auf `wt/pruefer-20261105c`,
* der Eintrag der Reste K4, K5 und K6 in [E-239](../Intern/BEFUNDE.md#e-239). `grep -c PRUEFER-102 Intern/BEFUNDE.md` ergibt am Paket **0**.

Die Folge: Eine spätere Änderung an `CMainFrame::OnClose` kann den Schutz gegen den gemessenen Absturz entfernen, und die Testsuite bleibt grün. Die drei Randfälle stehen nirgends, wo `offene-befunde.pl` sie findet. Genau dagegen steht die Regel *„den Bestand an Befunden lesen“* in `CLAUDE.md`. **Vorschlag:** `e239_absturz_beenden` vor dem nächsten Paket in `paket_…`/`main` bringen (mit K2), danach `RunTests.cmd` und die Gegenproben G1 bis G7 aus `2d8f7dfa` an diesem Stand wiederholen.

### <a id="k2"></a>K2 (mittel, belegt; Merge mit `git merge-tree` gemessen): Ein Merge des Zweigs `e239_absturz_beenden` ohne Nacharbeit macht E-239p wieder unzuverlässig

`git merge-tree --write-tree 7739b889 origin/e239_absturz_beenden` meldet Konflikte in `Arbeitsweise/MEMORY.md`, `CHANGELOG.md`, `Intern/BEFUNDE.md`, `Intern/WEITERMACHEN.md` und `tools/pruefstand-faelle.txt` (dort die Zeilen `E-239p`/`E-239w`). `tools/messen-e239.ps1` führt **ohne** Konflikt zusammen: Im Ergebnis gibt es `-Weg`, `E239 URTEIL` und `hinweis-exit-close` nebeneinander (:61, :89, :344). Das neue Hilfsskript `messen-e239-exit-close.ps1` vom Zweig ruft aber fest `-Weg 'exit-close'` auf. Genau diese Betriebsart hat das Paket am 06.11. als Wettlauf erkannt (`50cc41f0`: 3/3 *kein Hinweis*, Fall trotzdem grün) und für den Prüfstandfall durch `hinweis-exit-close` ersetzt (`pruefstand-faelle.txt`, Kommentar zu [E-239](../Intern/BEFUNDE.md#e-239)). Nach dem Merge wäre der Fall nicht mehr blind grün, denn `URTEIL` verlangt `hinweis=1`. Er würde aber je nach Zeitlage `ungueltig` melden, also mal rot und mal grün, ohne dass sich am Programm etwas ändert (Vermutung aus beiden Messungen). **Vorschlag:** Beim Merge das Hilfsskript auf `hinweis-exit-close` stellen (Name entsprechend), den Fall `E-239p` auf `E239 URTEIL gruen` lassen, `E-239w` behalten und einmal rot/grün nachmessen (7.2.2.135 rot, 7.2.2.136 grün). So schließt sich auch PRÜFER-102 K3 (Bau mit Commit-Kennung).

### <a id="k3"></a>K3 (mittel, gemessen): `TestE169` bemerkt vier von fünf Fehlern im Wiederherstellen nicht

`TestE169` prüft die Lage einzelner Zeichenketten (`QT_Stelle`) und ob die Zeile `if (lAbfrage == …)` vorkommt. Was in den Zweigen geschieht, prüft er nicht. Grün bleiben (§3):
* **H1:** Der Wert wird nie zurückgesetzt. `Print_Background=yes` bliebe dann in der Registrierung des Anwenders stehen, und **alle** Programme, die über den Internet Explorer drucken, drucken danach Hintergründe. Das ist ein Eingriff in fremde Einstellungen, den Gregors Entscheidung *„Vorgabe aus“* gerade vermeiden soll.
* **H2/H3:** Ein vorhandener Wert des Anwenders wird gelöscht, oder statt eines Löschens wird ein ungültiger Wert geschrieben.
* **H4:** Der alte Wert lässt sich nie lesen, und der Schalter wirkt bei vorhandenem Wert nicht.

Der Prüfstand fängt H1 bis H3 nur zum Teil: `E-169r`/`E-169s` prüfen *vorher = nachher*, aber nur im Zustand `fehlt` (`E169 REGISTRY unveraendert=1 vorher=fehlt nachher=fehlt`). Den Fall *vorhanden* deckt kein Fall ab. **Vorschlag:** wie bei [E-239](../Intern/BEFUNDE.md#e-239) (`2d8f7dfa`) die Blöcke als Ganzes prüfen, nach `QT_LiesNurCode` mit zusammengezogenem Leerraum, zum Beispiel `bHadBackground = (lAbfrage == ERROR_SUCCESS);`, `{ if (RegSetValueEx(… "yes", 4) == ERROR_SUCCESS) bSetBackground = TRUE; }` und `if (bHadBackground) VERIFY(RegSetValueEx(…OldBackground, OldBackgroundLen)…); else VERIFY(RegDeleteValue(…));`. Danach H1 bis H5 wiederholen. Am Prüfstand einen Fall mit vorher gesetztem Wert ergänzen, etwa `Print_Background=no` vorher und `no` nachher. Die Registrierung gehört aber dem Prüfrechner. Das Skript müsste den Wert vorher sichern und nachher zurückstellen. Ob das zulässig ist, entscheidet Gregor.

### <a id="k4"></a>K4 (gering, Vermutung; Lage am Quelltext und im Befund belegt): Drucken aus der offenen Vorschau ist nicht gemessen

Der Befund misst, dass der Wert schon **während** der offenen Vorschau wieder auf `fehlt` steht ([E-169](../Intern/BEFUNDE.md#e-169), `WAEHREND-VORSCHAU`). `ExecCommandOnNullSet` kehrt also zurück, bevor die Vorschau zu ist, und `Print` hat danach zurückgesetzt (:2457-2465). Aus dem Vorschaufenster kann der Anwender selbst drucken. Ob MSHTML dafür die Einstellung beim Öffnen der Vorschau behält oder neu liest, ist offen. Im zweiten Fall käme der Ausdruck aus der Vorschau ohne Hintergründe. Das ist der Weg, auf dem Gregor das Fehlen zuerst bemerkt hat (*File → Print Preview*). Dazu: Das Ergebnis von Schritt 5 im Testplan belegt für `PrintBackground=1` nur die **Vorschau** („die schwarze Fläche, der blaue Knopf … in der Vorschau“). Ob der Ausdruck auf Papier mit `1` Hintergründe trug, steht dort nicht ausdrücklich. Der Eintrag zu [E-169](../Intern/BEFUNDE.md#e-169) steht noch auf *„kommt mit dem Testpaket 7.2.2.136“* und *„Druck auf Papier … nicht gemessen“*. **Vorschlag:** Bei Gregor nachfragen, ob sein Ausdruck mit `1` die Flächen zeigte, und das in [E-169](../Intern/BEFUNDE.md#e-169) eintragen. In den nächsten Testplan aufnehmen: „Vorschau öffnen, **aus der Vorschau** drucken (auch als PDF)“.

### <a id="k5"></a>K5 (gering, Vermutung; Gegenstück gemessen): Fehlt der Schlüssel `PageSetup`, wirkt der Schalter still nicht

`Print` öffnet `HKCU\…\Internet Explorer\PageSetup` mit `RegOpenKeyEx` (:2419). Fehlt der **Schlüssel**, wird nichts gesetzt, und keine Spurzeile sagt es. Auf diesem Rechner besteht der Schlüssel, enthält aber **0 Werte** (gemessen, `Get-Item … ValueCount`). Das ist auch der Zustand, den [E-242](../Intern/BEFUNDE.md#e-242) für den Prüfrechner nennt. Ob er auf einem frischen Windows-Profil überhaupt angelegt ist, habe ich nicht gemessen. **Vorschlag:** Wenn [E-242](../Intern/BEFUNDE.md#e-242) Kopf- und Fußzeile auch bei fehlendem Wert setzt, im selben Zug `RegCreateKeyEx` nehmen (einen neu angelegten Schlüssel danach nicht löschen, das wäre harmlos) und eine Spurzeile schreiben, wenn der Schalter an ist, aber nicht gesetzt werden konnte.

### <a id="k6"></a>K6 (gering, belegt): Grenzen der Schranke `testplan-voraussetzungen.pl`

Die Schranke tut, was sie verspricht: Am Paket meldet sie `E-239: 'Alert=1' steht im Testabschnitt`, ihr Selbsttest ist 10/10 grün (beides gemessen). Sie teilt aber Annahmen mit den Messskripten:
* (a) Sie sieht nur Einstellungen, die ein Skript **in die INI schreibt**. Was der Prüfstand **umgeht**, sieht sie nicht. Beispiel: Schritt 3 braucht das Symbol im Infobereich (`AlwaysShowTrayIcon=1`). `messen-e239.ps1` schickt `ID_APP_EXIT` direkt ans Hauptfenster (:234) und braucht das Symbol nicht. Im Testplan steht es trotzdem, weil es von Hand ergänzt wurde.
* (b) Gesucht wird `Schlüssel=Wert` irgendwo im Abschnitt (`index($abs, "$k=$w")`, :104), nicht im betroffenen Schritt. Ein Satz wie „anders als `Alert=1` …“ oder ein Ergebnisabsatz genügt schon.
* (c) INI-Änderungen erkennt sie nur an `WriteAll*`/`Set-Content`/`Add-Content`/`Out-File` mit `$ini` (:69-71). `messen-e137.ps1:57` ersetzt die INI per `Copy-Item … $ini` und gilt deshalb als „stellt die INI nicht“.
* (d) Sie läuft in `paket-bauen.ps1` innerhalb von `if (Test-Path -LiteralPath $dokupruefer)` (:186). Fehlt `pruefe-doku-takt.pl`, läuft sie stumm nicht.
* (e) 20 Messskripte schreiben die INI und erklären keine `VORAUSSETZUNG-HANDTEST`-Zeile (gezählt mit dem Muster der Schranke), etwa `messen-e188.ps1` und `messen-e193.ps1`. Nennt ein künftiger Testabschnitt eine dieser Kennungen, auch nur im Fließtext („alles aus 7.2.2.135“), hält die Schranke das Paket an. Das ist gewollt, sollte aber vor dem nächsten Paketbau bekannt sein und nicht erst beim Bau auffallen.

**Vorschlag:** (b) und (d) mit wenig Aufwand schließen: nur Tabellenzeilen und die Zeilen mit „Voraussetzung“ durchsuchen, die Schranke aus dem `if`-Block herausnehmen. (e) jetzt einmal durchgehen und je Skript `keine` oder die Werte eintragen. (a) ist eine Grenze des Verfahrens und gehört in den Kopf des Werkzeugs.

## Hinweise (keine Funde)

* **T1:** `offene-befunde.pl` (Unterzeilen mit Urteil) und `pruefe-weitermachen-kopf.pl` habe ich nur gesichtet. Beide hat [LEKTOR-152](LEKTOR-152.md#lektor-152) eingearbeitet, die Selbsttests liegen bei.
* **T2:** `e169-bildserver.pl` lauscht nur auf 127.0.0.1 und liefert nur `Testdaten/e169-*.png` aus. Der Pfad ist durch das Muster `^/(e169-[a-z0-9-]+\.png)$` gegen `..` geschützt (belegt).
* **T3:** `messen-e169.ps1` schreibt die Registrierung nicht, es liest nur (:218-219). Das passt zur Regel, nichts auf dem Prüfrechner zu verstellen.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Nacharbeit zu PRÜFER-102 (`2d8f7dfa`: scharfer `TestE239`, Urteil im Prüfstand, Reste K4–K6, Bericht) nur auf `e239_absturz_beenden`; ausgeliefert ist der schwache Test, G3/G6 heute grün nachgemessen | mittel | nein; vor dem nächsten Merge, der [E-239](../Intern/BEFUNDE.md#e-239) berührt, nachholen |
| [K2](#k2) | Merge von `e239_absturz_beenden` ohne Nacharbeit: 5 Konflikte, Hilfsskript fest auf das wettlaufende `exit-close` → E-239p mal rot, mal grün | mittel | nein; beim Merge auf `hinweis-exit-close` umstellen und rot/grün nachmessen |
| [K3](#k3) | `TestE169` bleibt grün bei 4 von 5 Fehlern im Setzen/Wiederherstellen, auch wenn `Print_Background=yes` für immer stehen bliebe | mittel | nein; mit dem nächsten Paket Blöcke ganz prüfen |
| [K4](#k4) | Drucken aus der offenen Vorschau ungemessen (Wert ist dann schon zurückgesetzt); Papierdruck mit `1` im Testergebnis nicht ausdrücklich belegt, [E-169](../Intern/BEFUNDE.md#e-169) nicht nachgezogen | gering | nein; bei Gregor nachfragen, Testschritt ergänzen |
| [K5](#k5) | Ohne Schlüssel `PageSetup` wirkt `PrintBackground=1` still nicht | gering | nein; mit [E-242](../Intern/BEFUNDE.md#e-242) `RegCreateKeyEx` und Spurzeile |
| [K6](#k6) | Schranke `testplan-voraussetzungen.pl`: sieht Umgangenes nicht, sucht im ganzen Abschnitt, übersieht `Copy-Item`, läuft nur im `if` des Doku-Prüfers; 20 Skripte ohne Erklärung | gering | nein; (b), (d), (e) vor dem nächsten Paketbau |
