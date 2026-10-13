# <a id="lektor-16"></a>LEKTOR-16 — Dokumentation gegen den Bestand nach AN-1 (bis Commit `ca8da5a`)

Lauf am 12.10.2026, nur lesend, Bericht aus dem Notizordner übernommen. ~~Die Funde sind noch nicht eingearbeitet~~ — **Stand 12.10.2026: eingearbeitet in [LEKTOR-20](LEKTOR-20.md)**, bis auf [L-16.1](#l-16.1) (Werkzeug, Sache des Hauptagenten) und die dort als offen genannten Reste.


**Stand 12.10.2026**, HEAD `ca8da5a` auf Zweig `patch_20261012`, seit dem
letzten Lektorat `c0f946c`. Nur gelesen: keine Datei im Repo geändert, kein
git-Befehl mit Schreibwirkung, nichts gebaut, nichts gestartet. Gelesen wurden
außerdem `C:\Temp\AN1\Mailverzeichnis\eudora.log` und `...\attach\` (der
Prüflauf vom 12.10., nicht Gregors `Eudora72-*`-Verzeichnisse).

## Umfang

`git diff --name-only c0f946c HEAD -- '*.md'` ergibt **17 Dateien**:
AUFGABEN.md, Arbeitsweise/MEMORY.md, Arbeitsweise/README.md,
Arbeitsweise/zweigname-heisst-vorheriger-fertig.md, BEFUNDE.md,
Befunde/BEENDEN.md, Befunde/PRUEFER-18.md, Befunde/SPURMARKEN.md, CHANGELOG.md,
README.md, Releases/PAKETE.md, WEITERMACHEN.md, ZIEL.md, tools/TESTLAEUFE.md,
tools/WERKZEUGE.md, tools/ZWEIGE.md, tools/pruefdaten/LIESMICH.md.
Von Hand geprüft: alle ohne `Arbeitsweise/` (nach AGENTEN.md Schritt 7
ausgenommen). Schwerpunkt [AN-1](../BEFUNDE.md#an-1)/B5. Dazu jede Datei aus `git ls-files '*.md'`
nach den Stichworten [AN-1](../BEFUNDE.md#an-1), „zehn Marken“, `LogLevel`/`[Settings]` und B5.8/B5.9
durchsucht.

## Der Maßstab, gemessen

| Frage | Messung | Ergebnis |
|---|---|---|
| Quellstand | `Eudora71/Version.h:14` | **7.2.0.80** |
| Paketnummer | `VERSION` | **1.0.80** |
| Zweig | `git status` | `patch_20261012` |
| Gemessene Fassung | Kopf von `C:\Temp\AN1\Mailverzeichnis\eudora.log` | `Version 7.2.0.79`, `LogLevel 91295 (0x1649F)` |
| Starts | `tools/TESTLAEUFE.md:84-85` | 11:10:53 und 11:12:37, Fenstertitel `Paket 1.0.79+f4d1439*`, **mit Stern** |
| ANHANG-Zeilen | `grep -a -c ANHANG eudora.log` | **128** (zwei Abrufe) |
| Marke 5 „kennt den Typ NICHT“ | grep | **12** = 6 Fälle × 2 Abrufe; **0** × „nach MIMEMap::SetExtension“ |
| Fall 03 | Log | Kopfzeile 304 → Name 259 → nach DeMacifyName32 255 → Datei: Basisname **224 × `A`**, keine Endung |
| Fall 05 | `ls attach` | `Pruefung AN-1 leerer Dateiname` (30 Zeichen), keine Endung |
| `[Mappings]` im Prüfverzeichnis | `Mailverzeichnis\Eudora.ini:48,64` | `both=pdf,,,application,pdf` ist da |
| ANHANG-Marken im Quelltext | `grep -rn "ANHANG-Marke" Eudora71` | POP **1–8, 10, 11**; IMAP **1–9** (Marke 5 zweimal in `ImapDownload.cpp:3727, 4117`) — **elf Nummern** |
| `perl tools/doku-pruefen.pl` | Lauf | „Kein Widerspruch gefunden“, 5 Hinweise (siehe unten) |
| `perl tools/offene-befunde.pl` | Lauf | „16 / 16, Die Liste deckt die offenen Befunde“ — **ohne [AN-1](../BEFUNDE.md#an-1) und ohne [E-112](../BEFUNDE.md#e-112)** ([L-16.1](#l-16.1)) |
| `perl tools/pruefe-ini-abschnitte.pl` | Lauf | „alle Angaben stimmen mit GetSectionID überein“ |

**Die Zahlen im CHANGELOG 7.2.0.80** (Fall-Tabelle, 304 → 259 → 255 → 224,
Marke 5 bei allen sechs, `application/pdf` in `[Mappings]`) **stimmen mit dem
Log überein.** Ebenso die WEITERMACHEN-Zeile 10 und der Kasten in
AUFGABEN.md:452-460. Die Mängel sitzen fast alle in **älteren Stellen derselben
Dateien**, die den neuen Stand nicht mitbekommen haben. `ca8da5a` hat
AUFGABEN.md und CHANGELOG.md angefasst, **BEFUNDE.md, PAKETE.md, ZIEL.md,
README.md und LIESMICH.md gar nicht**.

---

## Die Funde

### <a id="l-16.1"></a>L-16.1 — `offene-befunde.pl` sieht AN-1 und E-112 nicht — die Schranke aus CLAUDE.md Schritt 1 ist an zwei Stellen blind

| | |
|---|---|
| **Behauptung** | `perl tools/offene-befunde.pl`: *„offen laut BEFUNDE.md 16 … Die Liste deckt die offenen Befunde.“* |
| **Bestand** | (a) `tools/offene-befunde.pl:78` liest nur Zeilen `^\|\s*\**\s*(E-\d+)` — **[AN-1](../BEFUNDE.md#an-1)** (`BEFUNDE.md:177`, Status im Abschnitt „teilweise“, `:7863`) kann nie gezählt werden, auch kein NP-, PR-, X-… Eintrag, obwohl CLAUDE.md genau diese Nummernkreise aufzählt. (b) **[E-112](../BEFUNDE.md#e-112)** (`BEFUNDE.md:278`) steht als *„**WIEDER OFFEN. Der Versuch in 7.2.0.76 wirkt nicht — von Gregor … am laufenden Programm widerlegt …**“*; das Wort `widerlegt` steht in `@erledigt_wort` (`offene-befunde.pl:72`) und schlägt „offen“. [E-112](../BEFUNDE.md#e-112) fehlt deshalb in der erzeugten Liste in WEITERMACHEN.md, obwohl CHANGELOG.md:17 es als „Wieder offen“ führt |
| **Warum es zählt** | Das ist genau die Lage, gegen die CLAUDE.md Schritt 1 geschrieben ist: der Bestand nennt einen offenen Befund, das Werkzeug zu Sitzungsbeginn meldet ihn nicht. Schranke stumm = Fehlalarm in der Wirkung ([schranke-gegentesten.md](../Arbeitsweise/schranke-gegentesten.md)) |
| **Vorschlag** | Kennungsmuster auf `[A-Z]+\d*-\d+` erweitern; „widerlegt“ nur werten, wenn es nicht neben „offen“ steht, oder „wieder offen“ vor `@erledigt_wort` prüfen. Gegentest: [E-112](../BEFUNDE.md#e-112) und [AN-1](../BEFUNDE.md#an-1) müssen erscheinen, [E-110](../BEFUNDE.md#e-110) nicht. Danach `-schreiben` |

### <a id="l-16.2"></a>L-16.2 — `BEFUNDE.md` AN-1: der Messstand vom 12.10. fehlt ganz, mehrere Stellen sagen „nicht übersetzt“

`ca8da5a` hat BEFUNDE.md nicht angefasst. Der Abschnitt [AN-1](../BEFUNDE.md#an-1) kennt nur die
Messung an **7.2.0.77** (IMAP, keine Anhänge). Die Messung an **7.2.0.79**
(POP, sechs Prüfnachrichten, 4 von 6 heil), Ursache **B5.8** (Kappung von
hinten in `strncpy`/`DeMacifyName32`) und Befund **B5.9** (`MIMEMap::Find`
scheitert überall) stehen nur in AUFGABEN.md und CHANGELOG.md.

| Datei:Zeile | Zitat | Bestand | Vorschlag |
|---|---|---|---|
| BEFUNDE.md:177 | *„**sieben** Ursachen … **im Quelltext geändert, Stand 7.2.0.79 — nicht übersetzt und von Gregor nicht geprüft.** … dazu zehn Debug-Marken … Das Urteil **behoben** steht noch aus — es braucht einen Bau und einen Abruf“* | 7.2.0.79 ist gebaut und abgerufen (Log oben); Quellstand 7.2.0.80; elf Marken; zwei weitere Teile (B5.8, B5.9) | Zeile neu: „7.2.0.79 gemessen: 00/01/02/04 heil, 03 ohne `.pdf` (B5.8, in 7.2.0.80 geändert, nicht übersetzt), 05 ohne Endung (B5.9, `MIMEMap::Find` scheitert überall, Ursache offen); elf Marken“ |
| BEFUNDE.md:7868-7873 | *„**Stand 12.10.2026.** Die Teile 1 bis 6 sind im Quelltext, Fassung 7.2.0.79 … **Übersetzt ist nichts**“* | übersetzt, Rebuild 0 Fehler, gemessen | Kasten nachziehen, Verweis auf CHANGELOG 7.2.0.80 |
| BEFUNDE.md:7875 ff. | Abschnitt „Gemessen am laufenden Programm, 12.10.2026“ behandelt nur 7.2.0.77 | zweite Messung am selben Tag an 7.2.0.79 fehlt | eigenen Abschnitt mit der Fall-Tabelle aus CHANGELOG:78-85 anlegen |
| BEFUNDE.md:8146 | *„Behebung: ein `Token[0] = 0;` … **Nicht angefasst** — kein Compiler.“* | steht im Code: `lex822.cpp:205`, `ImapLex822.cpp:220` | als Altstand kennzeichnen: „seit 7.2.0.79 drin (B5.2)“ |
| BEFUNDE.md:8260 | DeMacifyName32: *„**Nicht angefasst**, weil hier nicht gebaut werden kann.“* | geändert (B5.4), seit 7.2.0.80 zusätzlich mit `AnhangNameKuerzen` (`mime.cpp:985`, `imapmime.cpp:119`) | ebenso |
| BEFUNDE.md:8270 | *„Stand \| **im Quelltext seit 7.2.0.79.** Nicht übersetzt“* | übersetzt und gemessen: 01/02 heil | „übersetzt, am laufenden Programm wirksam (Fall 01, 02)“ |
| BEFUNDE.md:8307-8326 | „Was noch offen ist“ nennt 2 (Marke vergrößern), 3 (RFC 2231), 4 (`Token[0]`), 5 (DeMacifyName32) als offen | alle vier sind B5.3, B5.5, B5.2, B5.4 — erledigt. Offen sind [B5.7](../AUFGABEN.md#b5.7), B5.9, und der Bau von 7.2.0.80 | Abschnitt ersetzen oder als „Stand 30.09.“ markieren |
| BEFUNDE.md:8340-8353 | *„daran hängen **zehn Marken**“*, Tabelle mit **acht** Zeilen, *„Marken 1 bis 3 gibt es doppelt, einmal für IMAP“* | elf Nummern; IMAP hat 1–9; 9 (IMAP), 10 (RFC 2231, `header.cpp:601`), 11 (`MIMEMap.cpp:73`) fehlen in der Tabelle | Tabelle um 9, 10, 11 ergänzen, IMAP-Satz berichtigen |
| BEFUNDE.md:8402-8405 | Entscheidungstabelle „00 heil, 01–05 kaputt / alle sechs heil / 00 kaputt“ | gemessen ist ein vierter Fall: **gemischt** (4 heil, 2 ohne Endung) | Zeile „gemischt → die Liste der kaputten Fälle zeigt auf den Teil“ ergänzen, oder auf das Ergebnis verweisen |
| BEFUNDE.md:8449 | *„Nichts davon ist am laufenden Programm nachgesehen. Es gibt keinen Bau.“* | falsch seit 12.10. | streichen bzw. „bis 12.10.“ |

### <a id="l-16.3"></a>L-16.3 — `BEFUNDE.md` AN-1: zitierte Zeilennummern stimmen nicht mehr

Die Stichprobe stammt aus der Zeit vor 7.2.0.79. Der Text liest sich als
Gegenwart. Für den Weg des Namens (Tabelle `:8023-8030`) und die Marken-Tabelle
(`:8342-8351`) ist das irreführend, denn dort wird nachgeschlagen.

| zitiert (BEFUNDE.md) | heute im Code |
|---|---|
| `header.cpp:77` HeaderDesc::Read (:8026) | `header.cpp:78` |
| `mime.cpp:1634` GenericReader::ReadIt (:8027, :8347) | `mime.cpp:1657`, Marke 4 bei `:1707` |
| `MIMEMap.cpp:388` SetExtension (:8028, :8150) | `MIMEMap.cpp:416` |
| `MIMEMap.cpp:397` „1 bis 3 Zeichen“ (:8157) | `MIMEMap.cpp:431` |
| `mime.cpp:1275` / `:948` OpenAttachFile/DeMacifyName32 (:8029, :8349, :8241) | `mime.cpp:1300` / `:958` |
| `mime.cpp:992` CheckName (:8030) | `mime.cpp:1009` |
| `mime.cpp:1127` Marke 8 (:8351) | `mime.cpp:1146` |
| `lex822.cpp:213` Faltungsregel (:8037, :8345) | `lex822.cpp:221` |
| `lex822.cpp:206` Marke voll (:8085, :8344) | `lex822.cpp:210` |
| `lex822.cpp:201` ReinitToken (:8125, :8318) | `lex822.cpp:198-206` (mit `Token[0] = 0;` bei `:205`) |
| `lex822.h:70` `BYTE Token[256]` (:8085, :8201, :8312) | `lex822.h:72` `LEX822_TOKEN_MAX 1024`, `:88` `Token[LEX822_TOKEN_MAX]` |
| `header.cpp:502` GetAttribute (:8103) | `header.cpp:568` |
| `mime.cpp:1640` `strncpy(fName, …subj…)` (:8106-8108) | gibt es nicht mehr; `mime.cpp:1703` `AnhangNameKuerzen(fName, _MAX_PATH - 1, …subj)` |
| `mime.cpp:1646` SetExtension-Aufruf (:8227) | `mime.cpp:1718` |
| `header.cpp:476` AddAttribute (:8289, :8346) | `header.cpp:477` |
| `ImapDownload.cpp:5964` GetFilenameParameter (:8210) | `ImapDownload.cpp:5973` |
| `ImapDownload.cpp:3536` MIMEMap (:8229) | `ImapDownload.cpp:3535` |
| `imapmime.cpp:116 / :166 / :220` LOCAL_CheckName (:8219-8222) | `:124` / `:213` / `:267`; `tmp` ist jetzt `char tmp[_MAX_PATH + 1]` (`:144`) |
| `imapmime.cpp:82` LOCAL_DeMacifyName32 (:8323) | `imapmime.cpp:92` |

**Stimmen:** `rs.cpp:89` (GetSectionID), `MAPI/include/MAPI.h:35` (EXPORT
leer), `header.h:101` (`char subj[32]`), `MIMEMap.cpp:64` (`Find`).

**Vorschlag:** über beide Tabellen „Zeilen Stand 7.2.0.76 (vor der Behebung)“
schreiben oder auf Funktionsnamen umstellen. Die Werkzeuge arbeiten schon mit
Textankern statt Zeilennummern; die Doku könnte es auch.

### <a id="l-16.4"></a>L-16.4 — `AUFGABEN.md` B5: der Kasten oben ist neu, der Rest des Abschnitts noch auf „nicht gebaut“

| Datei:Zeile | Zitat | Bestand | Vorschlag |
|---|---|---|---|
| AUFGABEN.md:466-468 | *„**Es ist nichts mit MSVC gebaut.** Alle drei Sitzungen dazu liefen ohne Windows und ohne Compiler.“* | widerspricht dem Kasten 452-460 drei Zeilen darüber (*„Rebuild 0 Fehler“*) | streichen oder „bis 7.2.0.78“ |
| AUFGABEN.md:471 | *„Sechs getrennte Ursachen“* | Tabelle 489 heißt „sieben Teile“, der Kasten nennt B5.8 und B5.9 | Zahl vereinheitlichen (B5.1–B5.9, davon [B5.0](../AUFGABEN.md#b5.0) Marken) |
| AUFGABEN.md:489-500 | „Stand der **sieben** Teile“ — Tabelle endet bei [B5.7](../AUFGABEN.md#b5.7) | **B5.8** und **B5.9** gibt es nur im Kasten; sonst kommen sie in keiner MD vor (`grep B5.[89]` → nur AUFGABEN.md:456, :459) | zwei Zeilen: B5.8 „strncpy 259 / DeMacifyName32 255 kappen von hinten — geändert in 7.2.0.80 (`AnhangNameKuerzen`), nicht übersetzt“; B5.9 „`MIMEMap::Find` scheitert bei allen sechs, Ursache offen, Marke 11“ |
| AUFGABEN.md:493 | [B5.0](../AUFGABEN.md#b5.0): *„zehn Stellen … IMAP 4–9 und Marke 10 sind **nicht übersetzt**“* | elf Marken; 7.2.0.79 ist übersetzt; im POP-Lauf geschrieben haben 2, 3, 4, 5, 6, 7 (Marke 8 nicht, IMAP-Marken konnten nicht) | „elf Marken; POP 2–7 an 7.2.0.79 gemessen, Marke 11 neu in 7.2.0.80, IMAP 4–9 übersetzt, aber ohne IMAP-Abruf ungemessen“ |
| AUFGABEN.md:496 | B5.3 **behoben** | Kopfzeile trägt 304 Zeichen (gemessen), die Datei hatte trotzdem keine Endung — erst B5.8 macht B5.3 für den Anwender wirksam | Zusatz „Kopfzeile ja; Dateiname erst mit B5.8“ |
| AUFGABEN.md:454 | *„B5.1, B5.2 und B5.5 wirken“* | CHANGELOG:87 sagt zusätzlich „B5.3 wirkt“ | B5.3 mit Einschränkung ergänzen |
| AUFGABEN.md:519-521 | *„… genau aus wie die drei Übersetzungsfehler, die am 12.10.2026 ungeklärt blieben“* | 7.2.0.79: Rebuild, 0 Fehler. Die drei Fehler sind in keiner anderen MD beschrieben | sagen, was aus ihnen wurde (behoben? anderer Bau?), sonst ist die Begründung für „[B5.7](../AUFGABEN.md#b5.7) offen“ nicht mehr nachvollziehbar |
| AUFGABEN.md:539-540 | *„**Nicht gemessen:** nichts davon ist mit MSVC gebaut, nichts ist gestartet.“* | gebaut und gestartet (TESTLAEUFE.md:84-85) | berichtigen |
| AUFGABEN.md:543-553 | „Der nächste Schritt an einem Windows-Rechner“, 1. bauen … 4. grep | Schritte 1–4 sind für 7.2.0.79 erledigt; offen sind Bau von 7.2.0.80 und Schritt 5 (Test in `TestPopEmpfang.cpp`; dort steht noch nichts zu [AN-1](../BEFUNDE.md#an-1)/`AnhangNameKuerzen`) | als „für 7.2.0.80 wiederholen“ umschreiben |
| AUFGABEN.md:555-559 | *„Spalte `stand` … gewollt, solange niemand bestätigt hat, dass die Behebung am laufenden Programm wirkt“* | für B5.1 und B5.2 ist das seit dem 12.10. am Programm gemessen (Fälle 01, 02, 05: kein `=`) | entscheiden und vermerken; die Bedingung ist zumindest technisch erfüllt (Gregors Bestätigung fehlt noch) |
| AUFGABEN.md:576 | *„Zehn Marken auf dem Weg des Namens“* | elf; dass `MIMEMap::Find` scheitert (Marke 11), fehlt in der Aufzählung | „Elf“ und Marke 11 nennen |
| AUFGABEN.md:607-611 | Tabelle *„alle sechs heil → B5.1 bis B5.6 wirken“* | (a) gemessen ist „gemischt“, keine Zeile passt; (b) **B5.6 ist nur IMAP** (AUFGABEN.md:499), der Prüfstand ist POP — B5.6 lässt sich damit gar nicht zeigen, B5.4 auch nicht (nur Pufferrand) | „alle sechs heil → B5.1, B5.2, B5.3+B5.8, B5.5 wirken auf POP“; Zeile „gemischt“ ergänzen |
| AUFGABEN.md:634-636 | *„Alle sechs behobenen Teile sind aus dem Quelltext heraus begründet und, soweit ohne MSVC möglich, gemessen.“* | inzwischen mit MSVC gebaut und gemessen | nachziehen |

### <a id="l-16.5"></a>L-16.5 — `CHANGELOG.md`: 7.2.0.79 trägt noch „nicht übersetzt“

| Datei:Zeile | Zitat | Bestand | Vorschlag |
|---|---|---|---|
| CHANGELOG.md:104 | Überschrift *„7.2.0.79 — … **nicht übersetzt**“* | CHANGELOG.md:72 (drei Zeilen weiter oben): *„7.2.0.79 ist am 12.10.2026 zum ersten Mal übersetzt und am laufenden Programm gemessen worden“* | „… übersetzt und gemessen am 12.10.2026, 4 von 6 heil“ |
| CHANGELOG.md:106-108 | *„**Hier ist nichts gebaut und nichts gestartet.**“* | wie oben | als Stand beim Commit kennzeichnen („beim Einspielen war …“) oder streichen |
| CHANGELOG.md:125 | *„**Zehn Debug-Marken**“* | mit 7.2.0.79 war das richtig (1–10). Im 7.2.0.80-Abschnitt heißt die neue „Marke 11“, eine Gesamtzahl nennt er nicht | im 7.2.0.80-Abschnitt „jetzt elf Marken“ |
| CHANGELOG.md:16 | [AN-1](../BEFUNDE.md#an-1) in „Noch offen“: *„**Sechs von sieben Ursachen geändert in 7.2.0.79 — nichts davon ist übersetzt oder am laufenden Programm bestätigt.** … Offen ist [B5.7](../AUFGABEN.md#b5.7) … und der Bau“* | gebaut und gemessen; offen sind [B5.7](../AUFGABEN.md#b5.7), **B5.9** und der Bau von 7.2.0.80 | Zeile auf den Stand von :72-102 bringen |
| CHANGELOG.md:70 | Überschrift 7.2.0.80 „**in Arbeit**“ | der Commit `ca8da5a` sagt *„ZWISCHENSTAND: noch nicht übersetzt, Tests nicht gelaufen“* — der Abschnitt selbst sagt das nicht | einen Satz „7.2.0.80 ist nicht übersetzt, Tests nicht gelaufen“ hinzufügen. Sonst liest man „Behoben in 7.2.0.80“ (:92) als gemessen |
| CHANGELOG.md:88-90 | *„dann kappten drei Stellen **von hinten**: `strncpy` auf 259 …, `DeMacifyName32` auf 255, und der Pfad auf 224. `CheckName` hätte die Endung behalten“* | die dritte Kürzung (Pfad → 224) **ist** `CheckName` (`mime.cpp:1163`, „truncate while maintaining the correct extension“). Sie kappt nicht stumpf von hinten. Die Commit-Nachricht nennt als dritte Stelle `LOCAL_DeMacifyName32` (IMAP), die im POP-Lauf gar nicht vorkommt | „zwei Stellen kappten von hinten (259, 255); danach kürzte `CheckName` den Pfad auf 224 Zeichen Basisname — die Endung war da schon weg“ |
| CHANGELOG.md:96-99 | *„**ANHANG-Marke 11** in `MIMEMap::Find` nennt jetzt jeden Ausstieg“* | `MIMEMap.cpp:77-78`: der Ausstieg `if (!ms \|\| !ms->m_hd) return (FALSE);` ist **stumm**. Ein Kommentar im Code (`:76`) spricht von „drei Ausstiegen“, und drei sind markiert | „jeden Ausstieg außer dem Nullzeiger-Fall“, oder auch dort eine Zeile schreiben (Sache des PRUEFERs) |
| CHANGELOG.md:72-76 | Messung „Rebuild, Rückgabewert 0“ | TESTLAEUFE.md:84 zeigt die Kennung `1.0.79+f4d1439*`. Der Stern bedeutet laut CHANGELOG.md:172-175 *„ungesicherte Änderungen im Baum, der Bau also absichtlich nicht reproduzierbar“* | die Kennung nennen und sagen, was der Stern abdeckte. `git status` zeigt heute nur geänderte DLLs unter `Bin/Release`, keine Quellen |

### <a id="l-16.6"></a>L-16.6 — `Releases/PAKETE.md`: 1.0.79 „nicht gebaut“, 1.0.80 „7.2.0.79 gebaut“ — derselbe Abschnitt, zwei Antworten

| Datei:Zeile | Zitat | Bestand | Vorschlag |
|---|---|---|---|
| Releases/PAKETE.md:171 | *„## 1.0.79 — **nicht gebaut, nicht geschnürt**“* | PAKETE.md:167: *„weil 7.2.0.79 an diesem Tag gebaut und gemessen wurde“*; ein Bau liegt in `C:\Temp\AN1` | „gebaut und gemessen am 12.10.2026 (`C:\Temp\AN1`), **nicht geschnürt**“ |
| Releases/PAKETE.md:186-188 | *„sechs der sieben Ursachen … dazu zehn Debug-Marken … **Übersetzt ist nichts**, und von Gregor ist nichts geprüft“* | übersetzt; Ergebnis 4 von 6 | nachziehen |
| Releases/PAKETE.md:165 | Zweig `patch_20261012` | **steht nicht in `tools/ZWEIGE.md`** (siehe [L-16.9](#l-16.9)) | — |

### <a id="l-16.7"></a>L-16.7 — `tools/pruefdaten/LIESMICH.md`: „was Eudora heute daraus macht“ beschreibt 7.2.0.76

| Datei:Zeile | Zitat | Bestand (7.2.0.79, gemessen) | Vorschlag |
|---|---|---|---|
| LIESMICH.md:13 | Spaltenkopf *„was Eudora heute daraus macht“* | „heute“ ist 7.2.0.79/80 | Spalte umbenennen in „Eudora 7.1 bis 7.2.0.78“ und eine Spalte „7.2.0.79 (gemessen 12.10.)“ dazu |
| LIESMICH.md:15-16 | 01, 02: *„abgeschnitten, **ohne `.pdf`**“* | heil, 76 bzw. 56 Zeichen mit `.pdf` | s. o. |
| LIESMICH.md:18 | 03: *„bei 254 gekappt, ohne `.pdf`“* | 224 × `A`, ohne `.pdf` (Kappung bei 259/255/Pfad, nicht 254) | s. o. |
| LIESMICH.md:19 | 04: *„der **Betreff**, auf 31 Zeichen“* | heil, 56 Zeichen mit `.pdf` | s. o. |
| LIESMICH.md:20 | 05: *„eine Datei namens `=`“* | `Pruefung AN-1 leerer Dateiname`, ohne Endung | s. o. |
| LIESMICH.md:42-45 | *„Sind hinterher **alle sechs heil**, wirken die Behebungen **B5.1 bis B5.6**“* | B5.6 ist nur IMAP, der Prüfstand POP (wie [L-16.4](#l-16.4)) | „B5.1–B5.5 und B5.8 auf dem POP-Weg“ |

### <a id="l-16.8"></a>L-16.8 — `WEITERMACHEN.md`: „Der nächste Schritt“ trägt das Datum 12.10., der Inhalt ist vom 18.09. und vom 30.09.

| Datei:Zeile | Zitat | Bestand | Vorschlag |
|---|---|---|---|
| WEITERMACHEN.md:106-114 | *„**Stand 12.10.2026.** … Er will `git apply` fahren … **[B5.0](../AUFGABEN.md#b5.0) bis B5.5** … Zwei Patches liegen bereit und sind **nicht angewandt**.“* | Patches sind entfernt und eingespielt (AUFGABEN.md:462-464, CHANGELOG.md:113-114); `git ls-files '*.patch'` zeigt nur `tools/patches/zertifikatspruefung-verschaerfen.patch`; 7.2.0.79 gemessen | Punkt 1 ersetzen: „7.2.0.80 bauen (Rebuild), Prüfdaten erneut über `--pop`, Marke 11 lesen (B5.9)“ |
| WEITERMACHEN.md:138-142 | *„**Was heute fertig wurde:** [E-110](../BEFUNDE.md#e-110) behoben … 171 → **185** Tests“* | das war der 18.09.2026 (CHANGELOG.md:233); am 12.10. wurde [AN-1](../BEFUNDE.md#an-1) eingespielt, gebaut, gemessen | „Was am 18.09. fertig wurde“ oder durch den 12.10. ersetzen |
| WEITERMACHEN.md:10 | Zeile **Paketnummer** 1.0.80 trägt die ganze AN-1-Messung | in der Sache richtig (deckt sich mit dem Log). Ein Paket 1.0.80 gibt es nicht (PAKETE.md:162). In der Zeile „Paketnummer“ fehlt genau dieser Hinweis | „1.0.80 — vergeben, **nicht gebaut**“ voranstellen, Messung in eine eigene Zeile |
| WEITERMACHEN.md:27 | „Zuletzt gebaut und veröffentlicht: 7.2.0.72“ | zuletzt **veröffentlicht** stimmt (`v1.0.72`); zuletzt **gebaut** ist 7.2.0.79 (12.10.) | trennen |

### <a id="l-16.9"></a>L-16.9 — Zweig `patch_20261012` ist nirgends verzeichnet

| | |
|---|---|
| **Bestand** | `git status`: aktueller Zweig `patch_20261012`, darauf `ca8da5a`. `grep -rn patch_20261012 --include=*.md` → nur `Releases/PAKETE.md:165`. `tools/ZWEIGE.md` führt ihn nicht, auch keine Zustimmung zum Namen |
| **Maßstab** | CLAUDE.md §4 „Kein Zweig ohne Gregors Ja zum Namen“; tools/ZWEIGE.md führt jeden Zweig mit Beleg der Zustimmung |
| **Vorschlag** | Eintrag in tools/ZWEIGE.md mit Herkunft des Namens. Ich kann nicht feststellen, ob Gregor ihn selbst angelegt hat (der Name sieht nach seinem aus). Das gehört belegt, nicht vermutet |

### <a id="l-16.10"></a>L-16.10 — `ZIEL.md:17` und `README.md:149`: „nicht übersetzt“

| Datei:Zeile | Zitat | Bestand | Vorschlag |
|---|---|---|---|
| ZIEL.md:17 | *„seitdem ist nichts gebaut … **Quellstand ist jetzt 7.2.0.79** … **aber nicht übersetzt** … Der letzte wirklich **gebaute** Stand ist **7.2.0.76**“* | Quellstand 7.2.0.80; gebaut wurden am 12.10. 7.2.0.77, 7.2.0.78 (Gregor) und 7.2.0.79 (`C:\Temp\AN1`) | nachziehen. `doku-pruefen.pl` meldet ZIEL.md schon als Hinweis (höchste Fassung 7.2.0.79) |
| README.md:149-151 | *„**Sechs davon sind in 7.2.0.79 geändert, aber nicht übersetzt** und von Gregor nicht geprüft“* | übersetzt und gemessen, 4 von 6 heil | nachziehen |
| README.md:372-390 | LogLevel-Tabelle endet bei 32768; Beleg *„`debug.h:15-32`“* | `DEBUG_MASK_ATTACH = 0x10000` (65536, „ANHANG“) steht in `debug.h:44`, die Tabelle kennt ihn nicht; die Masken stehen heute in `debug.h:14-44` | Zeile „65536 \| Anhangnamen (ANHANG, [AN-1](../BEFUNDE.md#an-1)) \| aus“ und Beleg nachziehen |

### Kleinere Funde

* **AUFGABEN.md:494**: B5.1 „behoben, POP **und IMAP**“. Drei Absätze weiter
  (:502-505) steht: „B5.1 wirkt nur auf dem POP-Weg“. Beides stimmt jeweils
  halb. Vorschlag: „geändert in POP und IMAP; für den Dateinamen wirkt es nur
  über POP“.
* **CHANGELOG.md:127-128** „POP-Marken 1 bis 8 … gemessen“ meint 7.2.0.77.
  Marke **8** hat auch im Lauf an 7.2.0.79 nicht geschrieben, weil kein Fall
  `nBaseLen` überschreitet. Wer „1 bis 8 gemessen“ liest, hält Marke 8 für
  geprüft ([nie-benutzt-ist-nicht-geprueft.md](../Arbeitsweise/nie-benutzt-ist-nicht-geprueft.md)).
  Nachprüfen am Log zu 7.2.0.77 ist mir nicht möglich, der liegt nicht in
  `C:\Temp\AN1`.
* **Befunde/BEENDEN.md:473**: berichtigt auf `[Debug]`. Gegengeprüft mit
  `pruefe-ini-abschnitte.pl`, das grün ist. Keine Fundstelle mit `LogLevel`
  unter `[Settings]` mehr in den MDs.
* **Befunde/PRUEFER-18.md**: neu, Stand 18.09.2026, betrifft [E-110](../BEFUNDE.md#e-110). Ich habe
  es nicht gegen den Code nachgerechnet (außerhalb des Schwerpunkts).
* **tools/WERKZEUGE.md:61-63**: Einträge zu `kopfzeile-pruefen.pl`,
  `rfc2231-pruefen.pl` und `anhang-pruefdaten.pl` passen zu den Dateien. Die
  Werkzeuge selbst habe ich nicht laufen lassen: Sie übersetzen mit `g++`, und
  der Auftrag lautet „nichts bauen“.
* `kopfzeile-pruefen.pl:22` nennt im Kopfkommentar `header.cpp:77` (heute 78).
  Das ist keine MD, nur zur Kenntnis.

---

## Meldungen von `perl tools/doku-pruefen.pl`

```
Quellstand 7.2.0.80 · Paketnummer 1.0.80 · Kriterien in ZIEL.md 9 ·
gepruefte Dateien 26 · Kennungen im Verzeichnis 111 · Abschnitte in BEFUNDE.md 14
Kein Widerspruch gefunden.
Zur Kenntnis:
 - PORTIERUNG.md nennt weder 7.2.0.80 noch 1.0.80 (hoechste: 7.2.0.73)
 - Testdaten/README.md nennt weder 7.2.0.80 noch 1.0.80 (hoechste: 7.2.0.73)
 - ZIEL.md nennt weder 7.2.0.80 noch 1.0.80 (hoechste: 7.2.0.79)
 - tools/WERKZEUGE.md nennt weder 7.2.0.80 noch 1.0.80 (hoechste: 7.2.0.73)
 - tools/ZWEIGE.md nennt weder 7.2.0.80 noch 1.0.80 (hoechste: 7.2.0.79)
```

**Bewertung:** „Kein Widerspruch gefunden“, obwohl dieselbe Datei
(PAKETE.md:167 gegen :171, CHANGELOG.md:72 gegen :104) sich selbst widerspricht.
Das Werkzeug vergleicht Versionsnummern, nicht die Aussage „übersetzt / nicht
übersetzt“. Mögliche Schranke: eine Fassung, zu der `TESTLAEUFE.md` einen Start
verzeichnet (hier `7.2.0.79`, :84-85), darf in keiner MD als „nicht
übersetzt“/„nicht gebaut“/„nichts gebaut“ stehen. Mit dieser Regel wären
[L-16.2](#l-16.2), .4, .5, .6 und .10 mechanisch gefallen.

---

## Zusammenfassung

Der neue Messstand (CHANGELOG 7.2.0.80, AUFGABEN-Kasten :452-460,
WEITERMACHEN:10) ist richtig und deckt sich mit dem Log in `C:\Temp\AN1`.
Er ist aber **nur an der Spitze** angekommen. BEFUNDE.md [AN-1](../BEFUNDE.md#an-1), PAKETE.md 1.0.79,
LIESMICH.md, ZIEL.md, README.md, CHANGELOG.md 7.2.0.79 sowie der Rest von
AUFGABEN B5 sagen weiter „nicht übersetzt“, „zehn Marken“ und „sieben Teile“.
B5.8 und B5.9 stehen nur in einem Kasten. Am schwersten wiegt **[L-16.1](#l-16.1)**:
`offene-befunde.pl` meldet zu Sitzungsbeginn weder [AN-1](../BEFUNDE.md#an-1) noch [E-112](../BEFUNDE.md#e-112).
