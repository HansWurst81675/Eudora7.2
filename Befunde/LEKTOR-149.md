# <a id="lektor-149"></a>LEKTOR-149 (04.11.2026) — Zweig `e199_festbreite` nach 032d886a: Einarbeitung von LEKTOR-147, LEKTOR-148, PRÜFER-97 K1 und PRÜFER-98 gegen den Bestand

**Umfang:** `git log --stat b888cb46..HEAD`: `c856b0e2` ([PRÜFER-98](PRUEFER-98.md#pruefer-98)), der Merge `f06ccf66` und drei Commits, die ich geprüft habe: `1e96dc3a` (Wirkprobe in `tools/messen-e178.ps1` geschärft, `Tests/TestE199.cpp`), `b9ddf7a0` ([L-148.1](LEKTOR-148.md#l-148.1) bis [L-148.5](LEKTOR-148.md#l-148.5), PRÜFER-98 T2) und `032d886a` ([L-147.1](LEKTOR-147.md#l-147.1) bis [L-147.4](LEKTOR-147.md#l-147.4), PRÜFER-97 K1, [L-148.4](LEKTOR-148.md#l-148.4), [L-148.6](LEKTOR-148.md#l-148.6)). Gelesen habe ich die geänderten Stellen und dazu den Bestand: `Intern/BEFUNDE.md` ([E-199](../Intern/BEFUNDE.md#e-199) Festbreite schreibt `t;` in den Text, [E-188](../Intern/BEFUNDE.md#e-188) Mailverlust beim Verschieben, [E-178](../Intern/BEFUNDE.md#e-178) Emoji werden im Bearbeiten-Modus zu `??`), `Doku/FAQ.md` (Fragen 14 und 20), `README.md`, `Intern/TESTPLAN.md`, `tools/WERKZEUGE.md`, `Intern/WEITERMACHEN.md`, `Intern/LEKTORAT.md`, `CHANGELOG.md`, `Intern/pruefstand-buch.tsv`, `Intern/pruefstand-ergebnis.txt`, `tools/TESTLAEUFE.md`, `Arbeitsweise/stand-04-11-2026.md`, `Arbeitsweise/entscheidung-release-text-7-2-2-132-nachtrag.md`, dazu `tools/messen-e178.ps1`, `Eudora71/Tests/TestE199.cpp`, `Eudora71/Tests/Quelltext.cpp`. Gebaut und gestartet habe ich nichts.

**Urteil:** Die Einarbeitung ist sauber. Alle sechs Funde aus [LEKTOR-148](LEKTOR-148.md#lektor-148) und alle vier aus [LEKTOR-147](LEKTOR-147.md#lektor-147) sind erledigt. Die Zeilennummern in [E-199](../Intern/BEFUNDE.md#e-199) stimmen mit dem heutigen Code. Der zweite grüne Lauf steht im Prüfstandsbuch. Drei Funde, alle gering. **Keiner hält den Merge auf.** [E-199](../Intern/BEFUNDE.md#e-199) sagt, der Test zähle „jede Schreibweise“, es ist eine ([L-149.1](#l-149.1)). Das ist dasselbe Muster wie [L-147.2](LEKTOR-147.md#l-147.2). WERKZEUGE und TESTPLAN sagen weiter, das Urteil prüfe nur die Zeichen und nicht, ob ein Befehl gewirkt hat ([L-149.2](#l-149.2)). FAQ 20 und README sagen bei der weitergeleiteten Mail „in dieser Ladung“. Im Fall, den die Frage beschreibt, fehlen die Teile aber bei jedem Öffnen ([L-149.3](#l-149.3)).

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„Kein Widerspruch gefunden.“*, dazu 19 Hinweise *„… nennt weder den Quellstand 7.2.2.132 noch die Paketnummer“*. Das ist derselbe Altbestand wie in [LEKTOR-148](LEKTOR-148.md#lektor-148).
* `perl tools/offene-befunde.pl` (gemessen): *„54 offene Befunde, in beiden Listen gleich.“*, *„aktuell gemessen 21“*, *„nur am Quelltext 2“*, *„veraltet gemessen 24“*, *„NIE gemessen 9“*. Unverändert, `git status` danach leer.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„kritisch 69“*, *„unkritisch 55“*, *„mit Testfall im Pruefstand 67 von 69“*, *„OHNE jede Pruefung 0 <- Rueckstand“*, *„behoben und OHNE Testfall 50“*, *„Kein neues "behoben" ohne Regressionstest.“* Unverändert.
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*
* `perl tools/befunde-verlinken.pl` (gemessen): *„Anker: vollstaendig“*, *„Jede Kennung ist ein Link, und jeder Link trifft eine Urteilszeile.“*

## Funde aus LEKTOR-148 und LEKTOR-147 — heutiger Stand

| Fund | Stand | Stelle (heute) |
|---|---|---|
| [L-148.1](LEKTOR-148.md#l-148.1) Befund nannte „Bau `1ba00341`“ | **erledigt** | `Intern/BEFUNDE.md:413` *„das gemessene Programm meldet sich im Prüfstandsbuch als „Eudora 7.2.2.132+4ae1c87e*“, gebaut um 13:56 aus dem noch nicht gesicherten Baum … wahrscheinlich … aber nicht nachgewiesen“*. Das passt zum Buch: `Intern/pruefstand-buch.tsv:63` *„E-178p ok 2026-11-04 14:17:22 … Eudora 7.2.2.132+4ae1c87e* 2026-11-04 13:56“* und `tools/TESTLAEUFE.md:1177-1178`, gleicher Titel um 13:59 und 14:17 (gemessen). `1e96dc3a` ändert nur `TestE199.cpp` und `messen-e178.ps1` (gemessen, `git show --stat`), also bleibt „Bau gleich“ richtig. Der rote Lauf ohne Kennung ist vermerkt (*„im Titel des roten Laufs fehlt die Bau-Kennung“*). |
| [L-148.2](LEKTOR-148.md#l-148.2) „Messung sieht den `t;`-Rest nicht“ | **erledigt** | `tools/WERKZEUGE.md:168` *„Den `t;`-Rest der Festbreite … sieht seit `4ae1c87e` die Wirkprobe (nicht hinter einem Buchstaben oder einer Ziffer …)“*; `Intern/TESTPLAN.md:417-419`; `Intern/BEFUNDE.md:424` *„den `t;`-Rest der Festbreite ([E-199](#e-199)) sieht es seit `4ae1c87e`“*. Nachgetragen ist nur der `t;`-Rest, der Satz davor ist geblieben, siehe [L-149.2](#l-149.2). |
| [L-148.3](LEKTOR-148.md#l-148.3) README ohne „im Quellstand behoben“ | **erledigt** | `README.md:195` *„**im Quellstand behoben, kommt mit der nächsten Fassung** (7.2.2.132 und älter haben ihn noch; …)“* |
| [L-148.4](LEKTOR-148.md#l-148.4) WEITERMACHEN und [E-188](../Intern/BEFUNDE.md#e-188) vor dem Merge von #220 | **erledigt** | `Intern/WEITERMACHEN.md:3` *„Zweig `e199_festbreite` ([E-199](BEFUNDE.md#e-199)): im Quellstand behoben …“* und *„#220 ist gemergt“*; `Intern/BEFUNDE.md:421` *„**Was noch fehlt:** das Paket ([LEKTOR-146](LEKTOR-146.md#lektor-146) und [LEKTOR-147](LEKTOR-147.md#lektor-147) sind eingearbeitet, #220 ist gemergt)“* |
| [L-148.5](LEKTOR-148.md#l-148.5) Durchgestrichenes unter „was noch fehlt“ | **erledigt** | `grep -c '~~' CHANGELOG.md` → 0 (gemessen); in [E-199](../Intern/BEFUNDE.md#e-199) steht das Erledigte jetzt unter *„**Erledigt (04.11.2026):**“* (`Intern/BEFUNDE.md:413`) |
| [L-148.6](LEKTOR-148.md#l-148.6) Übergabe widersprüchlich, [LEKTOR-147](LEKTOR-147.md#lektor-147) nicht eingearbeitet | **erledigt** | `Arbeitsweise/stand-04-11-2026.md:25` *„[LEKTOR-145](LEKTOR-145.md#lektor-145)..146 eingearbeitet“* und *„**Am 04.11. auf `e199_festbreite` eingearbeitet:** [LEKTOR-147](LEKTOR-147.md#lektor-147) [L-147.1](LEKTOR-147.md#l-147.1)..4 und PRÜFER-97 K1 (als Doku); PRÜFER-97 K2 … ist nicht erledigt“*. Die Datei ist byte-gleich mit der im Gedächtnisverzeichnis (gemessen, `cmp`). |
| [L-147.1](LEKTOR-147.md#l-147.1) „= `43e265eb`“ | **erledigt** | `Intern/WEITERMACHEN.md:3` *„am Bau `7.2.2.132+ea323d31*` (Quelle danach als `43e265eb` committet, …)“* |
| [L-147.2](LEKTOR-147.md#l-147.2) „jede Schreibweise“ bei [E-188](../Intern/BEFUNDE.md#e-188) | **erledigt** | `Intern/WEITERMACHEN.md:3` *„der Test sieht das Löschen in vier Schreibweisen“*; `Intern/BEFUNDE.md:421` *„in vier Schreibweisen: mit und ohne Klammer und Leerzeichen“*. Bei [E-199](../Intern/BEFUNDE.md#e-199) ist das Muster neu aufgetreten, siehe [L-149.1](#l-149.1). |
| [L-147.3](LEKTOR-147.md#l-147.3) FAQ 20 „nicht gemessen“, FAQ 14 ohne Verweis | **erledigt** | `Doku/FAQ.md:433-435` *„die dritte *am Prüfstand gemessen* beim Verschieben nach lokal, zwischen zwei Konten am Quelltext belegt“*; `Doku/FAQ.md:309-312` FAQ 14 verweist auf *„[Frage 20]“* |
| [L-147.4](LEKTOR-147.md#l-147.4) LEKTORAT [L-146.5](LEKTOR-146.md#l-146.5), „vier kritische“ | **erledigt** | `Intern/LEKTORAT.md:3261` *„Nicht eingearbeitet: [L-146.6](LEKTOR-146.md#l-146.6) … Nachgetragen am 04.11.2026 … [L-146.5](LEKTOR-146.md#l-146.5) war mit `43e265eb` schon er[ledigt]“*; `Arbeitsweise/entscheidung-release-text-7-2-2-132-nachtrag.md:13` *„(Stand 04.11.2026: null kritische Befunde ohne jede Prüfung; die vier im ersten Entwurf genannten …)“* |
| [PRÜFER-97](PRUEFER-97.md#k1) K1 (Doku: Anzeige bricht hinter fehlerhafter weitergeleiteter Mail ab) | **erledigt**, Wortlaut siehe [L-149.3](#l-149.3) | `Doku/FAQ.md:446-450`, `README.md:174`, `Intern/BEFUNDE.md:421` |
| [PRÜFER-98](PRUEFER-98.md#pruefer-98) K1/K2/T2 | **erledigt** | K1: `tools/messen-e178.ps1:425-429`, `gespeichert=passt` nur bei `$muell -eq 0 -and $platz -eq 0 -and $restT -eq 0 -and $ttAnz -gt 0` (belegt). K2: `Eudora71/Tests/TestE199.cpp:39` *„szSchnitt = "GetLength() - 2"“*. T2: die Zeilen in `Intern/BEFUNDE.md:413` *„heute `:4078-4083`“* und *„heute `:3635-3646`“* stimmen. `grep -nF 'GetLength() - 2' TridentReadMessageView.cpp` → 3637, 3640, 3643, 3646, 4080, 4083, der erste `Text2Html` bei 3635 (gemessen). |

PRÜFER-97 K2 (der E-188-Test prüft Text statt Wirkung) ist laut Auftrag bewusst offen. Er steht gleichlautend in `Intern/BEFUNDE.md:421` und `Intern/WEITERMACHEN.md:3` (belegt), kein Fund.

## Funde

### <a id="l-149.1"></a>L-149.1 — E-199 sagt, der Test zähle „jede Schreibweise“; er zählt eine

**Gewicht: gering.** Es ist dasselbe Muster wie [L-147.2](LEKTOR-147.md#l-147.2) bei [E-188](../Intern/BEFUNDE.md#e-188), diesmal bei [E-199](../Intern/BEFUNDE.md#e-199) (Festbreite schreibt `t;` in den Text).

- `Intern/BEFUNDE.md:413` *„PRÜFER-98 K1 und K2 (`1e96dc3a`: Wirkprobe sieht Platzhalter, `T>`-Rest und fehlende Festbreite, der Test zählt jede Schreibweise)“*. Die Commit-Nachricht `1e96dc3a` sagt dasselbe: *„Test jede Schreibweise“*.
- Der Code zählt eine Zeichenfolge: `Eudora71/Tests/TestE199.cpp:39` *„const char* szSchnitt = "GetLength() - 2";“*. `QT_LiesNurCode` zieht Leerraum nur zusammen, es setzt keinen ein (`Eudora71/Tests/Quelltext.h:30` *„jeder Leerraum auf genau ein Leerzeichen zusammengezogen“*, `Quelltext.cpp:131-141`; belegt). Ein `GetLength()-2` ohne Leerzeichen bleibt deshalb ungezählt, ebenso ein Schnitt über eine andere Länge, etwa `Left( n - 2 )`. Nicht gegengetestet.
- Was der Befund an derselben Stelle sonst sagt, ist genau: *„seit `1e96dc3a` zählt er jedes `GetLength() - 2` in beiden Funktionen“*.

**Vorschlag:** In der Klammer „der Test zählt jedes `GetLength() - 2`“ statt „jede Schreibweise“.

### <a id="l-149.2"></a>L-149.2 — WERKZEUGE und TESTPLAN sagen weiter, das Urteil prüfe nur die Zeichen

**Gewicht: gering.** Bei [L-148.2](LEKTOR-148.md#l-148.2) wurde der `t;`-Satz nachgetragen, der Satz davor blieb stehen. Seit `1e96dc3a` stimmt er nicht mehr.

- `tools/WERKZEUGE.md:168` *„**Was das Urteil nicht sieht** ([PRÜFER-82] K3): es prüft nur, ob 🔥 und Ж erhalten sind und kein `?` dasteht, nicht, ob ein Befehl gewirkt hat.“* Am Ende derselben Zelle: *„Vorschlag aus K3: je Schritt eine Wirkprobe (`<TT>`, `<A href=…>` mit Text)“*.
- `Intern/TESTPLAN.md:416` *„Das Urteil sieht nur die beiden Zeichen: einen leeren Link oder ein Vollzitat erkennt es nicht.“* Den Platzhalter, den `T>`-Rest und das verlangte `<TT>` nennt der TESTPLAN nicht (gemessen, `grep -c 'platzhalter\|rest-T' Intern/TESTPLAN.md` → 0).
- Der Code: `tools/messen-e178.ps1:429` `gespeichert` wird nur `passt`, wenn *„$ttAnz -gt 0“* (mindestens ein `<TT>` in der gespeicherten Fassung) und weder Platzhalter noch `T>`-Rest da sind (belegt). Für die gespeicherte Fassung prüft das Urteil also seit `1e96dc3a`, ob die Festbreite gewirkt hat. Für die Schritte `tt` und `link` selbst prüft es das weiter nicht. Dort stimmt die alte Aussage.
- WERKZEUGE beschreibt die neue Prüfung schon im selben Eintrag richtig (*„Wirkprobe `E178 MUELL anzahl=.. platzhalter=.. rest-T=.. tt=..` … und mindestens ein `<TT>`“*). Der Eintrag widerspricht sich also selbst.

**Vorschlag:** WERKZEUGE: „es prüft je Schritt nur …; seit `1e96dc3a` verlangt `gespeichert` mindestens ein `<TT>`“, im K3-Vorschlag `<TT>` als erledigt für die gespeicherte Fassung. TESTPLAN: „sieht bei `tt` und `link` nur die Zeichen“, dazu ein Halbsatz zu Platzhalter, `T>`-Rest und `<TT>` in der gespeicherten Fassung.

### <a id="l-149.3"></a>L-149.3 — FAQ 20 und README: „in dieser Ladung“ verdeckt, dass die Teile bei dauerhafter Verweigerung nie erscheinen

**Gewicht: gering, nur Wortlaut.** Es geht um [PRÜFER-97](PRUEFER-97.md#k1) K1: scheitert etwas in einer weitergeleiteten Mail, zeigt Eudora die Teile der äußeren Mail dahinter nicht.

- `Doku/FAQ.md:446-450` *„Steckt der verweigerte Teil in einer **weitergeleiteten Mail** …, bricht die Anzeige dort ab: die Teile der äußeren Mail dahinter erscheinen in dieser Ladung nicht. Die Mail bleibt „nicht geladen“ und wird beim nächsten Öffnen neu geholt; verloren geht nichts“*. Ähnlich `README.md:174` *„die Teile dahinter fehlen in dieser Ladung, die Mail wird beim nächsten Öffnen neu geholt“*.
- Die Frage 20 handelt aber von einem Server, der den Teil **dauerhaft** verweigert (`Doku/FAQ.md:420` *„IMAP-Server **dauerhaft** einen Teil einer Mail“*). In diesem Fall scheitert auch jedes nächste Öffnen, und die Teile erscheinen nie. Das sagt PRÜFER-97 selbst: `Befunde/PRUEFER-97.md:72` *„Bei einem Fehler, der sich jedes Mal wiederholt … sieht der Anwender die Teile dahinter nie.“* Wer nur FAQ oder README liest, erwartet, dass das nächste Öffnen hilft (belegt).
- Die Aussage „verloren geht nichts“ stimmt (auf dem Server bleibt die Mail, belegt durch PRÜFER-97 K1).

**Vorschlag:** In FAQ 20 und README nach „in dieser Ladung nicht“: „und solange der Server den Teil verweigert, auch bei keinem späteren Öffnen“.

## Hält etwas den Merge von `e199_festbreite` auf?

**Nein.** Gemessen: `origin/e199_festbreite` = `032d886a` = HEAD dieses Baums, und `git merge-base --is-ancestor origin/main origin/e199_festbreite` ist wahr. Die drei Funde sind Wortlaut, je ein Halbsatz. [L-149.1](#l-149.1) und [L-149.2](#l-149.2) betreffen das, was dieser Zweig ändert, und sollten deshalb mit. In [E-199](../Intern/BEFUNDE.md#e-199) steht unter „Was noch fehlt“ *„ein weiterer LEKTOR über den Zweig nach [LEKTOR-148](LEKTOR-148.md#lektor-148) und [PRÜFER-98]“* (`Intern/BEFUNDE.md:413`). Das ist dieser Bericht; mit seiner Einarbeitung kann der Punkt gestrichen werden. Offen bleibt der Prüfstandsschritt „Festbreite aus“ (`SplitTagOff`). Er ist ehrlich als „nur am Quelltext belegt“ geführt und hält den Merge nicht auf.

## Was nur Gregor entscheiden kann

Nichts. Alle drei Funde sind Wortlaut, den hat Gregor dem Hauptagenten übertragen.
