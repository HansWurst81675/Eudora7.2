# <a id="lektor-147"></a>LEKTOR-147 (04.11.2026) — Nachtrag nach LEKTOR-146 und PRÜFER-96: Einarbeitung gegen den Bestand, Zweig `e188_loeschschranke` nach ca187c47

**Umfang:** `git log --stat 37a682e6..HEAD`, also alles seit [LEKTOR-146](LEKTOR-146.md#lektor-146): 5 Commits (`0b5124b4` [PRÜFER-96](PRUEFER-96.md#pruefer-96), Merge `ea323d31`, `43e265eb` Behebung PRÜFER-96 K1 bis K3, `8edd8654` Prüfstand, `ca187c47` Einarbeitung). Gelesen habe ich die geänderten Stellen in `README.md`, `Doku/FAQ.md` (Einträge 14 und 20), `Intern/WEITERMACHEN.md` (Kopf, Entscheidungen 26 bis 30, erzeugte Tabelle), `Intern/BEFUNDE.md` [E-188](../Intern/BEFUNDE.md#e-188) (beim Verschieben in ein anderes IMAP-Konto oder nach lokal kann die Mail auf dem Server verloren gehen), `ZIEL.md:70`, `Intern/LEKTORAT.md:3261`, die Entscheidung zum Release-Nachtrag, dazu `Intern/pruefstand-buch.tsv`, `Intern/pruefstand-ergebnis.txt` und den Code-Diff von `43e265eb` gegen [PRÜFER-96](PRUEFER-96.md#pruefer-96). Gebaut und gestartet habe ich nichts.

**Urteil:** Die Einarbeitung ist sauber. Die README zählt 20 Fragen, WEITERMACHEN steht auf dem Stand nach PRÜFER-96 und führt die Entscheidungen 28 bis 30, der Befund [E-188](../Intern/BEFUNDE.md#e-188) nennt den Lauf von 11:36 als „zuletzt gemessen“, FAQ 20 und README sagen „am Quelltext belegt“ statt „gemessen“. `origin/e188_loeschschranke` steht auf `ca187c47` und enthält `origin/main` (gemessen). Vier Funde, alle gering oder Kleinkram. **Keiner hält den Merge auf.** Zwei Sätze sagen mehr, als gemessen ist ([L-147.1](#l-147.1) Bau gleich Commit, [L-147.2](#l-147.2) „jede Schreibweise“). Einer sagt weniger ([L-147.3](#l-147.3)).

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„Kein Widerspruch gefunden.“* Dazu 19 Hinweise *„… nennt weder den Quellstand 7.2.2.132 noch die Paketnummer“*, derselbe Altbestand wie in [LEKTOR-146](LEKTOR-146.md#lektor-146).
* `perl tools/offene-befunde.pl` (gemessen): *„54 offene Befunde, in beiden Listen gleich.“*, *„aktuell gemessen 21“*, *„nur am Quelltext 2“*, *„veraltet gemessen 24“*, *„NIE gemessen 9“*. Unverändert, `git status` danach leer.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„kritisch 69“*, *„unkritisch 55“*, *„mit Testfall im Pruefstand 67 von 69“*, *„OHNE jede Pruefung 0 <- Rueckstand“*, *„behoben und OHNE Testfall 50“*, *„Kein neues "behoben" ohne Regressionstest.“* Die Stufentabelle `Intern/BEFUNDE.md:158` *„| **kritisch** | 5 | 61 | 3 | 69 |“* zählt dasselbe.
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Funde aus LEKTOR-146 — heutiger Stand

| Fund | Stand | Stelle |
|---|---|---|
| [L-146.1](LEKTOR-146.md#l-146.1) README zählte 19 Fragen | **erledigt** | `README.md:48` *„— 20 häufige Fragen, nummeriert“*; `grep -c '^## [0-9]' Doku/FAQ.md` → 20 (gemessen) |
| [L-146.2](LEKTOR-146.md#l-146.2) WEITERMACHEN vor PRÜFER-95, Entscheidungen fehlten | **erledigt**, Rest siehe [L-147.1](#l-147.1), [L-147.2](#l-147.2) | `Intern/WEITERMACHEN.md:3` *„acht Ursachen … PRÜFER-94 K3 …, PRÜFER-95 K4 …, PRÜFER-95 K6“*, je mit Halbsatz; `:184` *„28. … „Sicherheit vor Platz.““*, `:185` *„29. … unkritisch (Randfall)“*, `:186` *„30. … der Rat „neu abgleichen“ gilt nicht“*; erzeugte Zeilen `CHANGELOG.md:44`, `Intern/WEITERMACHEN.md:105` *„ein weiterer LEKTOR über den Zweig ([LEKTOR-146](LEKTOR-146.md#lektor-146) ist eingearbeitet, 04.11.2026)“* |
| [L-146.3](LEKTOR-146.md#l-146.3) [E-188](../Intern/BEFUNDE.md#e-188) „Zuletzt gemessen“ alt, T1 fehl am Platz | **erledigt** | `Intern/BEFUNDE.md:421` *„Zuletzt gemessen: 04.11.2026 an 7.2.2.132** (Lauf 11:36 … „Eudora 7.2.2.132+ea323d31*“, gebaut … um 11:18“*, *„Davor: 10:56 an „7.2.2.132+01f97a4c*““*; *„([PRÜFER-95] K6 unten)“*; *„Der PR-Haken-Hinweis aus [PRÜFER-95] (dort T1) betrifft `tools/haken-pr-lektor.pl`, nicht [E-188](../Intern/BEFUNDE.md#e-188)“*. Gegen `Intern/pruefstand-buch.tsv` (zehn Zeilen `E-188*` *„ok 2026-11-04 11:36:47 … 7.2.2.132+ea323d31* 2026-11-04 11:18“*) und `Intern/pruefstand-ergebnis.txt` *„faelle=10 bestanden=10“* gleich (gemessen) |
| [L-146.4](LEKTOR-146.md#l-146.4) FAQ 20/README „gemessen“ zu stark, Folgen fehlten | **weitgehend erledigt.** FAQ 14 ohne Verweis, siehe [L-147.3](#l-147.3) | `Doku/FAQ.md:428-438` *„Drei Folgen …“*, `:447-452` *„*Am Quelltext belegt* ([PRÜFER-95] K3 …) … *Am Prüfstand gemessen* ist nur, dass die Mail beim Verschieben in der Quelle bleibt“*; `README.md:174` dasselbe knapp |
| [L-146.5](LEKTOR-146.md#l-146.5) Entscheidung nannte verworfenen Rat | **erledigt** (mit `43e265eb`), aber in LEKTORAT als „nicht eingearbeitet“ geführt, siehe [L-147.4](#l-147.4) | `Arbeitsweise/entscheidung-release-text-7-2-2-132-nachtrag.md:12` *„Ein zusätzlicher Rat „den Ordner neu abgleichen“ stand im ersten Entwurf und wurde verworfen“* |
| [L-146.6](LEKTOR-146.md#l-146.6) Rückstand null, Vorlage als Aufgabe | **teilweise.** WEITERMACHEN sagt null, die Entscheidungsdatei nicht | `Intern/WEITERMACHEN.md:185` *„kritisch ohne jede Prüfung ist seither 0“*; `Arbeitsweise/entscheidung-release-text-7-2-2-132-nachtrag.md:13` weiter *„vier kritische Befunde ohne jede Prüfung: [E-123](../Intern/BEFUNDE.md#e-123), [E-124](../Intern/BEFUNDE.md#e-124), [E-126](../Intern/BEFUNDE.md#e-126), [E-129](../Intern/BEFUNDE.md#e-129)“* |
| [L-146.7](LEKTOR-146.md#l-146.7) README-Zeile [E-188](../Intern/BEFUNDE.md#e-188) nur „Noch offen“ | **erledigt** | `README.md:173` *„Noch offen — **im Quellstand behoben, kommt mit der nächsten Fassung** (Paket 7.2.2.132 und älter haben den Fehler noch)“*, *„wer sie löscht, löscht auf dem Server auch eine fremde Mail“* |
| ZIEL-Überschrift (aus [L-146.6](LEKTOR-146.md#l-146.6)) | **erledigt** | `ZIEL.md:70` *„Sechs Randfälle (am 23.10.2026 als „kritisch“ gefragt; heute ist nur [E-122](../Intern/BEFUNDE.md#e-122) *kritisch*, behoben …)“* |
| [L-145.6](LEKTOR-145.md#l-145.6), [L-145.7](LEKTOR-145.md#l-145.7), [L-144.3](LEKTOR-144.md#l-144.3), [L-138.9](LEKTOR-138.md#l-138.9) und die in [LEKTOR-146](LEKTOR-146.md#lektor-146) als unverändert geführten | **unverändert.** Seit `37a682e6` hat kein Commit diese Stellen berührt (belegt, `git log --stat`) | `Intern/BEFUNDE.md:422` *„Verwandt: [E-188](#e-188) (zwei weitere Stellen)“*; `README.md:98` *„219 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026“*, gezählt 240, mit diesem 241 (gemessen) |

## Funde

### <a id="l-147.1"></a>L-147.1 — WEITERMACHEN setzt den gemessenen Bau mit `43e265eb` gleich, der Befund sagt „nicht nachgewiesen“

**Gewicht: gering.**

- `Intern/WEITERMACHEN.md:3` *„am Prüfstand 10 von 10 grün am Bau `7.2.2.132+ea323d31*` (= `43e265eb`, Lauf 04.11.2026, 11:36)“*. Dagegen `Intern/BEFUNDE.md:421` *„gebaut … aus dem noch nicht gesicherten Baum; der Quellstand wurde danach als `43e265eb` committet. Dass beide Stände gleich sind, ist wahrscheinlich, aber nicht nachgewiesen.“* (belegt). Die Commit-Nachricht `8edd8654` nennt *„SHA-256 gleich“*, das betrifft aber die Kopie des Baus nach `C:\Temp\E188`, nicht den Quellstand.
- Dazu (belegt): Die zehn Fälle messen nichts, was `43e265eb` ändert. Die Fälle `E-188tm`/`fm` sind `multipart/alternative` ([PRÜFER-95](PRUEFER-95.md#k6) K6), PRÜFER-96 K1 betrifft `message/delivery-status`, K2 eine eingebettete Mail (`ImapDownload.cpp:4037-4038`, `:4102`, `:4113`). Der Lauf ist eine Gegenprobe, dass nichts kaputtging. Der Befund sagt richtig *„am Quelltext belegt“*. WEITERMACHEN stellt „erledigt mit `43e265eb`“ und „10 von 10“ in einen Satz.

**Vorschlag:** In WEITERMACHEN „(= `43e265eb`)“ durch „(Quelle danach als `43e265eb` committet)“ ersetzen, wie im Befund.

### <a id="l-147.2"></a>L-147.2 — „K3: der Test sieht jede Schreibweise“: es sind vier, und die zweite Hälfte von K3 ist nirgends geführt

**Gewicht: gering.**

- `Intern/WEITERMACHEN.md:3` *„K3 (der Test sieht jede Schreibweise)“*, `Intern/BEFUNDE.md:421` *„K3 (der Regressionstest sieht das Löschen des Merkzeichens in jeder Schreibweise)“*. Der Test prüft genau vier Zeichenfolgen: `Eudora71/Tests/TestE188.cpp` *„{ "&= ~IMFLAGS_NOT_DOWNLOADED", "&= ~(IMFLAGS_NOT_DOWNLOADED", "&=~IMFLAGS_NOT_DOWNLOADED", "&=~(IMFLAGS_NOT_DOWNLOADED" }“* (belegt, `git show 43e265eb`). Etwa `&= ~ IMFLAGS_NOT_DOWNLOADED` oder ein Löschen über eine Maske in einer Hilfsvariable sieht er nicht (belegt am Text, nicht gegengetestet).
- PRÜFER-96 K3 hatte zwei Hälften. Die zweite: `Befunde/PRUEFER-96.md` *„Umgekehrt verbietet die Prüfung das Löschen in der **ganzen** Datei ImapChecker.cpp und ImapMailbox.cpp; ein späteres, berechtigtes Löschen an anderer Stelle würde rot.“* Sie ist nicht umgesetzt (der Test liest weiter die ganzen Dateien: `Eudora71/Tests/TestE188.cpp:136-137` `char* pC = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapChecker.cpp");` und ebenso `ImapMailbox.cpp`) und steht weder unter „Erledigt“ noch unter „Was noch fehlt“ (gemessen: `grep -c ganze` über die Zeile des Befunds → 1, und der Treffer gehört zu Ursache 8, nicht zu K3)|ganze Datei'` im Befund ohne Treffer zu K3).

**Vorschlag:** „in vier Schreibweisen (mit und ohne Klammer und Leerzeichen)“. Die zweite Hälfte als offen und gering unter „Was noch fehlt“ führen, mit Halbsatz.

### <a id="l-147.3"></a>L-147.3 — FAQ 20 und README nennen die dritte Folge „nicht am Programm gemessen“, der Befund führt sie als gemessen; FAQ 14 ohne Verweis

**Gewicht: gering, vor dem nächsten Paket.** Hier ist die Doku vorsichtiger als nötig, ein Schaden entsteht nicht.

- `Doku/FAQ.md:428-429` *„Drei Folgen … (je *am Quelltext belegt*, nicht am Programm gemessen)“*, dritte Folge `:435` *„Nach dem Verschieben steht im Ziel ein leerer Eintrag (nach lokal) oder nichts, und es kommt keine Meldung.“* `README.md:174` *„Im Ziel steht danach ein leerer Eintrag oder nichts, ohne Meldung; … (je am Quelltext belegt)“*. Der Befund `Intern/BEFUNDE.md:421` sagt dagegen in „Was noch fehlt“: *„nach lokal mit nicht ladbarem Text (`E-188f`, `E-188fm`) bleibt lokal ein Eintrag ohne Text neben der Mail auf dem Server stehen (kein Verlust, `anzeige=FALSCH`)“*, also gemessen (belegt). Nachprüfen konnte ich das am Prüfstandsbuch nicht: die Zeilen sind gekürzt, `E-188f` steht dort nur als *„E188 ERGEBNIS weg=fetch“* (gemessen). `tools/messen-e188.ps1:604` gibt `anzeige=` und `ohne-text=` aber aus.
- FAQ 14 (`Doku/FAQ.md:293` *„Werden Anhänge gelöscht, wenn ich die Mail lösche?“*) nennt die Ausnahme weiter nicht. `Intern/LEKTORAT.md:3261` führt das selbst: *„FAQ 14 hat noch keinen Verweis auf Eintrag 20.“*

**Vorschlag:** In FAQ 20 und README die dritte Folge als „am Prüfstand gemessen nach lokal (`E-188f`, `E-188fm`)“ kennzeichnen, die beiden anderen bleiben „am Quelltext belegt“. In FAQ 14 einen Satz: „Ausnahme: eine IMAP-Mail, die nie ganz geladen wurde, siehe Frage 20.“

### <a id="l-147.4"></a>L-147.4 — LEKTORAT führt L-146.5 als „nicht eingearbeitet“, obwohl es mit `43e265eb` erledigt ist

**Gewicht: Kleinkram.**

- `Intern/LEKTORAT.md:3261` *„Nicht eingearbeitet: [L-146.5](LEKTOR-146.md#l-146.5) und [L-146.6](LEKTOR-146.md#l-146.6) (Vorlage der Release-Notizen: kommt beim nächsten Paket)“*. Der Vorschlag von [L-146.5](LEKTOR-146.md#l-146.5) war, in der Entscheidung den Rat „neu abgleichen“ als verworfen zu kennzeichnen. Das ist geschehen: `Arbeitsweise/entscheidung-release-text-7-2-2-132-nachtrag.md:12` *„… wurde verworfen: gemessen standen die Doppel auch nach erneutem Öffnen noch da (Commit `ea65447e`, [LEKTOR-146](LEKTOR-146.md#lektor-146) [L-146.5](LEKTOR-146.md#l-146.5))“* (belegt, `git show 43e265eb`). Ebenso in `Intern/WEITERMACHEN.md:186`.
- Zu [L-146.6](LEKTOR-146.md#l-146.6): Dieselbe Datei sagt in `:13` weiter *„vier kritische Befunde ohne jede Prüfung: [E-123](../Intern/BEFUNDE.md#e-123), [E-124](../Intern/BEFUNDE.md#e-124), [E-126](../Intern/BEFUNDE.md#e-126), [E-129](../Intern/BEFUNDE.md#e-129)“*. Seit Entscheidung 29 ist das null (`Intern/WEITERMACHEN.md:185`). Wer beim nächsten Release die Vorlage nach dieser Datei schreibt, übernimmt die veraltete Liste (Vermutung).

**Vorschlag:** In LEKTORAT [L-146.5](LEKTOR-146.md#l-146.5) nach „Eingearbeitet“. In der Entscheidungsdatei `:13` ergänzen: „seit dem 04.11.2026 (Entscheidung 29) null; in der Vorlage die Zahl aus `pruefe-regressionstest.pl`, keine feste Liste“.

## Hält etwas den Merge von `e188_loeschschranke` auf?

**Nein** (gemessen: `refs/remotes/origin/e188_loeschschranke` = `ca187c47` = HEAD dieses Baums, `git merge-base --is-ancestor origin/main HEAD` wahr). [L-147.1](#l-147.1) und [L-147.2](#l-147.2) sind je ein Halbsatz und könnten vor dem Merge mit. [L-147.3](#l-147.3) gehört vor das nächste Paket, weil der Text erst ab der nächsten Fassung gilt.

## Was nur Gregor entscheiden kann

Nichts. Alle Funde sind Wortlaut und Buchführung, das hat Gregor dem Hauptagenten übertragen.
