# <a id="lektor-148"></a>LEKTOR-148 (04.11.2026) — Zweig `e199_festbreite` nach f8c3dbf5: E-199 gegen den Bestand

**Umfang:** `git log --stat aa1692b6..HEAD`, also alles seit dem Merge von #220: 3 Commits (`4ae1c87e` Wirkprobe in `tools/messen-e178.ps1`, rot an `main`; `1ba00341` Behebung in `TridentReadMessageView.cpp` und `Tests/TestE199.cpp`; `f8c3dbf5` Prüfstand grün, Befund fortgeschrieben). Gelesen habe ich die geänderten Stellen und dazu den Bestand zu [E-199](../Intern/BEFUNDE.md#e-199) (Festbreite im Bearbeiten-Modus schreibt `t;` in den Text): `Intern/BEFUNDE.md` ([E-199](../Intern/BEFUNDE.md#e-199), [E-178](../Intern/BEFUNDE.md#e-178), [E-188](../Intern/BEFUNDE.md#e-188)), `README.md`, `Doku/FAQ.md`, `Intern/TESTPLAN.md`, `CHANGELOG.md`, `Intern/WEITERMACHEN.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md`, `tools/TESTLAEUFE.md`, `Intern/pruefstand-buch.tsv`, `Intern/pruefstand-ergebnis.txt` (auch in der Fassung von `4ae1c87e`). Gebaut und gestartet habe ich nichts.

**Urteil:** Die Behebung und ihr Befund sind sauber und stimmen mit dem Code: genau sechs Stellen `// strip "\r\n"` in der ganzen Quelle, alle sechs jetzt mit `.Right(2) == "\r\n"` geschützt (gemessen, `grep -rnF 'GetLength() - 2 ); // strip'` über `Eudora71/` → `TridentReadMessageView.cpp:3637, 3640, 3643, 3646, 4080, 4083`, sonst nichts). Rot an `main` und grün mit der Behebung sind im Prüfstandsbuch und in der Ergebnisdatei nachvollziehbar. Der Originalfehler ist an 7.2.1.128 belegt. Sechs Funde, alle gering oder Kleinkram. **Keiner hält den Merge auf.** Drei Stellen sagen noch, die Messung sehe den `t;`-Rest nicht ([L-148.2](#l-148.2)), die README nennt die Behebung nicht ([L-148.3](#l-148.3)). Die vier Funde aus [LEKTOR-147](LEKTOR-147.md#lektor-147) sind alle noch offen, obwohl die Übergabe sie für diesen Zweig vorsieht ([L-148.6](#l-148.6)).

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„Kein Widerspruch gefunden.“*, dazu 19 Hinweise *„… nennt weder den Quellstand 7.2.2.132 noch die Paketnummer“*, derselbe Altbestand wie in [LEKTOR-147](LEKTOR-147.md#lektor-147).
* `perl tools/offene-befunde.pl` (gemessen): *„54 offene Befunde, in beiden Listen gleich.“*, *„aktuell gemessen 21“*, *„nur am Quelltext 2“*, *„veraltet gemessen 24“*, *„NIE gemessen 9“*. Unverändert, `git status` danach leer.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„kritisch 69“*, *„unkritisch 55“*, *„mit Testfall im Pruefstand 67 von 69“*, *„OHNE jede Pruefung 0 <- Rueckstand“*, *„behoben und OHNE Testfall 50“*, *„Kein neues "behoben" ohne Regressionstest.“* [E-199](../Intern/BEFUNDE.md#e-199) zählt dort nicht als behoben, weil der Befund bis zum Paket „offen“ bleibt; das ist die Regel des Hauses, kein Fehler.
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Funde aus LEKTOR-147 — heutiger Stand

Kein Commit seit `aa1692b6` hat eine dieser Stellen berührt (belegt, `git log --stat aa1692b6..HEAD`: nur die oben genannten Dateien).

| Fund | Stand | Stelle |
|---|---|---|
| [L-147.1](LEKTOR-147.md#l-147.1) WEITERMACHEN setzt den gemessenen E-188-Bau mit `43e265eb` gleich | **offen** | `Intern/WEITERMACHEN.md:3` weiter *„am Bau `7.2.2.132+ea323d31*` (= `43e265eb`, Lauf 04.11.2026, 11:36)“* |
| [L-147.2](LEKTOR-147.md#l-147.2) „der Test sieht jede Schreibweise“, es sind vier | **offen** | `Intern/WEITERMACHEN.md:3` *„K3 (der Test sieht jede Schreibweise)“*; `Intern/BEFUNDE.md:421` *„K3 (der Regressionstest sieht das Löschen des Merkzeichens in jeder Schreibweise)“* |
| [L-147.3](LEKTOR-147.md#l-147.3) FAQ 20 nennt die dritte Folge „nicht gemessen“; FAQ 14 ohne Verweis | **offen** | `Doku/FAQ.md:428-429` *„Drei Folgen … (je *am Quelltext belegt*, nicht am Programm gemessen)“*; `Doku/FAQ.md:293` FAQ 14 ohne Verweis auf 20 (gemessen: `grep -n 'Frage 20\|Eintrag 20'` → nur der Index `:17`) |
| [L-147.4](LEKTOR-147.md#l-147.4) LEKTORAT führt [L-146.5](LEKTOR-146.md#l-146.5) als „nicht eingearbeitet“; Entscheidung nennt vier kritische | **offen** | `Intern/LEKTORAT.md:3261` *„Nicht eingearbeitet: [L-146.5](LEKTOR-146.md#l-146.5) und [L-146.6](LEKTOR-146.md#l-146.6)“*; `Arbeitsweise/entscheidung-release-text-7-2-2-132-nachtrag.md:13` *„vier kritische Befunde ohne jede Prüfung: [E-123](../Intern/BEFUNDE.md#e-123), [E-124](../Intern/BEFUNDE.md#e-124), [E-126](../Intern/BEFUNDE.md#e-126), [E-129](../Intern/BEFUNDE.md#e-129)“* |

## Funde

### <a id="l-148.1"></a>L-148.1 — Befund nennt „Bau `1ba00341`“, gemessen ist ein ungesicherter Baum vor diesem Commit

**Gewicht: gering.** Dasselbe Muster wie [L-147.1](LEKTOR-147.md#l-147.1).

- `Intern/BEFUNDE.md:413` *„grün mit der Behebung `1ba00341`“* und *„Zuletzt gemessen: 04.11.2026 an 7.2.2.132** (Quellstand mit der Behebung, Bau `1ba00341`; …)“*. Das Prüfstandsbuch sagt `Intern/pruefstand-buch.tsv:63` *„E-178p ok 2026-11-04 13:59:42 … Eudora 7.2.2.132+4ae1c87e* 2026-11-04 13:56“*, ebenso `tools/TESTLAEUFE.md:1177` (gemessen). Der Bau ist um 13:56 aus dem Baum über `4ae1c87e` mit ungesicherten Änderungen entstanden; `1ba00341` ist um 13:57:56 committet (`git log --date=iso`). Dass der Baum genau `1ba00341` war, ist wahrscheinlich (der Commit ändert nur die eine Quelldatei und die Tests), aber nicht nachgewiesen. Das *„SHA-256 gleich“* in der Commit-Nachricht `f8c3dbf5` betrifft die Kopie nach `C:\Temp\E178`, nicht den Quellstand (belegt).
- Für den roten Lauf fehlt die Bau-Kennung ganz: `tools/TESTLAEUFE.md:1176` *„Hauptfenster 8913386 - Eudora  Schliesszeit 1 s.“* (kein Titel mit Bau), und die Ergebnisdatei in `4ae1c87e` nennt keinen Bau (gemessen, `git show 4ae1c87e:Intern/pruefstand-ergebnis.txt`). *„rot an `main` `aa1692b6`“* steht nur in der Commit-Nachricht `4ae1c87e` (belegt). Dass der Titel ohne Kennung kam, ist selbst ein Ausreißer; ob der Bau von `main` keine Kennung trug oder das Skript sie nicht las, ist nicht gemessen (Vermutung).

**Vorschlag:** In [E-199](../Intern/BEFUNDE.md#e-199) „Bau `7.2.2.132+4ae1c87e*` (Quelle danach als `1ba00341` committet)“; für den roten Lauf „Bau von `aa1692b6` laut Commit `4ae1c87e`, Kennung im Titel fehlt“.

### <a id="l-148.2"></a>L-148.2 — Drei Stellen sagen weiter, die Messung von E-178p sehe den `t;`-Rest nicht

**Gewicht: gering, vor dem Merge.** Die Wirkprobe ist der Kern dieses Zweigs; wer nach WERKZEUGE oder TESTPLAN urteilt, hält die Messung für blinder, als sie ist.

- `tools/WERKZEUGE.md:168` *„Ausgabe `E178 ERGEBNIS fett= kursiv= tt= link= gespeichert= antwort= lebt=`“* und *„**Was das Urteil nicht sieht** … Ihm entgehen ein **leerer Link** …, der **`t;`-Rest** der Festbreite ([E-199](../Intern/BEFUNDE.md#e-199)) und das **Vollzitat** der Antwort.“* Die neue Zeile `E178 MUELL anzahl=` und die Wirkprobe stehen dort nicht (gemessen: `grep -n 'MUELL\|Wirkprobe' tools/WERKZEUGE.md` → nur *„Vorschlag aus K3: je Schritt eine Wirkprobe“*).
- `Intern/TESTPLAN.md:416-417` *„Das Urteil sieht nur die beiden Zeichen: einen leeren Link, den `t;`-Rest aus [E-199](../Intern/BEFUNDE.md#e-199) oder ein Vollzitat erkennt es nicht.“*
- `Intern/BEFUNDE.md:424` ([E-178](../Intern/BEFUNDE.md#e-178)) *„Das Urteil des Skripts sieht außerdem weder einen leeren Link noch den `t;`-Rest der Festbreite ([E-199](#e-199)).“*
- Dagegen der Code: `tools/messen-e178.ps1` (seit `4ae1c87e`) *„if ($vier -and $kyr -and $frage -eq 0 -and $muell -eq 0) { 'passt' } else { 'kaputt' }“* (belegt), und rot an `main` mit *„gespeichert=kaputt“* (gemessen, Ergebnisdatei in `4ae1c87e`).
- Dazu, was die Wirkprobe nicht sieht (belegt am Muster, nicht gegengetestet): `(?<![A-Za-z0-9#&])t;` zählt `t;` nach einem Buchstaben oder einer Ziffer nicht. Läge der Platzhalter direkt hinter einem Wort, bliebe der Müll unerkannt. Gemessen standen alle bisherigen Fälle hinter `>`.

**Vorschlag:** An allen drei Stellen „seit `4ae1c87e` sieht `gespeichert` den `t;`-Rest (Zeile `E178 MUELL anzahl=`); nicht hinter Buchstabe oder Ziffer“. Leerer Link und Vollzitat bleiben ungesehen.

### <a id="l-148.3"></a>L-148.3 — README nennt E-199 unter „Bekannte Fehler“ ohne den Hinweis, dass es behoben ist

**Gewicht: gering, vor dem Merge.**

- `README.md:195` *„… schreibt *Festbreite* die Zeichen `t;` sichtbar in den Text … (am 02.11.2026 an 7.2.1.130 am Prüfstand gemessen; Fehler aus dem Original)“*. Kein *„im Quellstand behoben, kommt mit der nächsten Fassung“*, wie es die E-188-Zeile darüber hat: `README.md:173` *„Noch offen — **im Quellstand behoben, kommt mit der nächsten Fassung** (Paket 7.2.2.132 und älter haben den Fehler noch)“* (gemessen).
- `Doku/FAQ.md` nennt [E-199](../Intern/BEFUNDE.md#e-199) nicht (gemessen, `grep -n "E-199" Doku/FAQ.md` ohne Treffer), `CHANGELOG.md` führt Behebungen erst unter der Fassung beim Schnüren (Muster wie bei [E-188](../Intern/BEFUNDE.md#e-188), `CHANGELOG.md:117` ff.). Beides kein Fund.

**Vorschlag:** In `README.md:195` nach „Fehler aus dem Original“ ergänzen: „im Quellstand behoben, kommt mit der nächsten Fassung (7.2.2.132 und älter haben ihn noch)“.

### <a id="l-148.4"></a>L-148.4 — WEITERMACHEN und E-188 stehen noch vor dem Merge von #220

**Gewicht: gering.** Hier geht es um [E-188](../Intern/BEFUNDE.md#e-188) (beim Verschieben in ein anderes IMAP-Konto oder nach lokal kann die Mail auf dem Server verloren gehen).

- `Intern/WEITERMACHEN.md:3` nennt den Zweig `e199_festbreite` gar nicht und sagt zu [E-188](../Intern/BEFUNDE.md#e-188) *„der PR folgt, der Befund bleibt bis zum Paket offen“*. #220 ist gemergt (`aa1692b6` *„Merge pull request #220 from HansWurst81675/e188_loeschschranke“*, Vorfahr von HEAD, gemessen).
- `Intern/BEFUNDE.md:421` *„**Was noch fehlt:** ein weiterer LEKTOR über den Zweig ([LEKTOR-146](LEKTOR-146.md#lektor-146) ist eingearbeitet, 04.11.2026); das Paket; …“*, erzeugt daraus `CHANGELOG.md:44` und die Zeile in `Intern/WEITERMACHEN.md`. Der weitere LEKTOR war [LEKTOR-147](LEKTOR-147.md#lektor-147), der Zweig ist gemergt (belegt).

**Vorschlag:** WEITERMACHEN-Kopf: „#220 gemergt ([E-188](../Intern/BEFUNDE.md#e-188) im Quellstand, kommt mit dem nächsten Paket); Zweig `e199_festbreite`: [E-199](../Intern/BEFUNDE.md#e-199) behoben, Prüfstand rot an `main`, grün mit der Behebung“. In [E-188](../Intern/BEFUNDE.md#e-188) „ein weiterer LEKTOR …“ streichen, „das Paket“ bleibt.

### <a id="l-148.5"></a>L-148.5 — Die erzeugte Spalte „was noch fehlt“ trägt bei E-199 Durchgestrichenes

**Gewicht: Kleinkram.**

- `CHANGELOG.md:37` und `Intern/WEITERMACHEN.md:98` *„PRÜFER und LEKTOR über den Zweig; das Paket. ~~nur abschneiden, wenn der Text wirklich auf `"\r\n"` endet, an allen Stellen in `WrapTag` und `SplitT…“*. Die Tabelle erklärt sich selbst: `CHANGELOG.md:22` *„Die Spalte **was noch fehlt** sagt, was zu tun bleibt — nicht, was schon erledigt ist.“* Quelle ist `Intern/BEFUNDE.md:413` *„~~nur abschneiden … Wirkprobe, die Zeichenmüll erkennt~~ (erledigt 04.11.2026, siehe oben)“*. Unter den 54 Zeilen ist das die einzige mit `~~` (gemessen).

**Vorschlag:** Das Durchgestrichene in [E-199](../Intern/BEFUNDE.md#e-199) aus „Was noch fehlt“ nehmen; die Behebung steht im Befund schon unter „Behebung (`1ba00341`)“.

### <a id="l-148.6"></a>L-148.6 — Die Übergabe sieht die LEKTOR-147-Funde für diesen Zweig vor, keiner ist eingearbeitet; die Übergabe widerspricht sich

**Gewicht: gering.**

- `Arbeitsweise/stand-04-11-2026.md:25` *„PRÜFER-94..97 und [LEKTOR-145](LEKTOR-145.md#lektor-145)..147 eingearbeitet“*, im selben Absatz *„Für den nächsten Zweig mitnehmen (kein PR-Aufschub): [LEKTOR-147](LEKTOR-147.md#lektor-147) [L-147.1](LEKTOR-147.md#l-147.1)..4 (u. a. FAQ 14 Verweis auf 20; …), PRÜFER-97 K1/K2“*. [LEKTOR-147](LEKTOR-147.md#lektor-147) kann nicht zugleich eingearbeitet und mitzunehmen sein. Der nächste Zweig ist `e199_festbreite`, und keine der Stellen ist berührt (siehe Tabelle oben, belegt). Ob PRÜFER-97 K1/K2 (die Anzeige bricht hinter einer fehlerhaften weitergeleiteten Mail ab; der Test prüft Text statt Wirkung) irgendwo geführt sind, habe ich nicht geprüft.

**Vorschlag:** [L-147.1](LEKTOR-147.md#l-147.1) bis [L-147.4](LEKTOR-147.md#l-147.4) auf diesem Zweig einarbeiten, sonst in der Übergabe sagen, wohin sie gehen. In `stand-04-11-2026.md:25` „[LEKTOR-145](LEKTOR-145.md#lektor-145)..146 eingearbeitet, [LEKTOR-147](LEKTOR-147.md#lektor-147) mitnehmen“.

## Hält etwas den Merge von `e199_festbreite` auf?

**Nein** (gemessen: `origin/e199_festbreite` = `f8c3dbf5` = HEAD dieses Baums, `git merge-base --is-ancestor origin/main HEAD` wahr). [L-148.2](#l-148.2) und [L-148.3](#l-148.3) betreffen die Beschreibung dessen, was dieser Zweig ändert, und sollten mit; je ein Satz. [L-148.6](#l-148.6) mit den vier Funden aus [LEKTOR-147](LEKTOR-147.md#lektor-147) sollte nach der Übergabe ebenfalls mit. Ein PRÜFER über den Zweig steht laut Befund noch aus (`Intern/BEFUNDE.md:413` *„PRÜFER und LEKTOR über den Zweig“*).

## Was nur Gregor entscheiden kann

Nichts. Alle Funde sind Wortlaut und Buchführung, das hat Gregor dem Hauptagenten übertragen.
