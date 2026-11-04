# <a id="lektor-141"></a>LEKTOR-141 (03.11.2026) — Bekannte Fehler E-220/E-221 in README und Release-Notizen 7.2.2.132, Zweig `paket_7_2_2_132` nach 230f37fd

**Umfang:** `git log --stat af73cdde..HEAD` (ein Commit, `230f37fd`: README *Bekannte Fehler* zwei Zeilen, `Releases/7.2.2.132/RELEASE-NOTIZEN.md` E-221-Absatz und E-192-Zustand, `Arbeitsweise/entscheidung-postfachdateien-umlaute.md` neu mit zwei Spiegelzeilen, elf Zeilen `tools/TESTLAEUFE.md`). Gelesen gegen: die Einträge `E-220` auf `origin/e220_dateiname_vorschlag` (`git show …:Intern/BEFUNDE.md`, Zeile 400, Stand `1fa871ab`) und [`E-221`](../Intern/BEFUNDE.md#e-221) auf `origin/e221_betreff_gefaltet` (Zeile 400, Stand `4fda4987`), dazu die Commit-Nachricht von `4f32a676` (E-220-Messung), [E-192](../Intern/BEFUNDE.md#e-192) (IMAP-Verschieben ordnet neue Nummern falsch zu) hier und auf `origin/E-192_multiple_IMAP-Mails`, CHANGELOG, TESTPLAN und README dieses Zweigs. Jeder Fund aus [LEKTOR-140](LEKTOR-140.md#lektor-140) und die offenen aus [LEKTOR-138](LEKTOR-138.md#lektor-138)/139 am heutigen Stand. Den übrigen Bestand nur über `doku-pruefen.pl` und gezielte Suche (`64 Zeichen`, `63 Zeichen`, `nächsten Paket`, `E-22[01]`).

**Urteil:** Die E-221-Zeilen (langer Umlaut-Betreff in der Liste gekürzt) stimmen mit der Messung überein. Die E-220-Zeilen (vorgeschlagener Dateiname bei *Speichern unter*) behaupten zweierlei, was die Messung auf dem E-220-Zweig widerlegt — eine Zahl um eins zu hoch und einen Fehler (*„Windows lehnt ihn ab“*), der dort als Bedienweg eingeordnet ist. Das steht in den Release-Notizen, die mit dem Release öffentlich werden. Drei Funde; [L-141.1](#l-141.1) vor der Veröffentlichung berichtigen, hält den Merge nicht auf.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„Kein Widerspruch gefunden.“*, *„gepruefte Dateien 53“*, 19 Hinweise *„… nennt weder den Quellstand 7.2.2.132 noch die Paketnummer“* — derselbe Altbestand wie in [LEKTOR-140](LEKTOR-140.md#lektor-140), kein Fund. Die beiden Backtick-Kennungen `E-220`/[`E-221`](../Intern/BEFUNDE.md#e-221) meldet es nicht (erwartet: sie sind keine Links).
* `perl tools/offene-befunde.pl` (gemessen): *„61 offene Befunde, in beiden Listen gleich.“*; *„davon aktuell gemessen 26“*, *„veraltet gemessen 24“*, *„NIE gemessen 11“* — E-220 und [E-221](../Intern/BEFUNDE.md#e-221) zählen hier nicht mit, da nicht in `Intern/BEFUNDE.md` dieses Zweigs (`grep -c 'id="e-22[01]"'` → 0, gemessen).

## Funde aus LEKTOR-138 bis LEKTOR-140 — heutiger Stand

| Fund | Stand | Stelle |
|---|---|---|
| [L-140.1](LEKTOR-140.md#l-140.1) TESTPLAN-Schritte 10/11 doppeln den Prüfstand | **offen, für 7.2.2.132 überholt** — Gregor hat alle zwölf Schritte bestanden; der Kopfsatz bleibt Muster für den nächsten Testplan | `Intern/TESTPLAN.md:7` weiter *„**Hier steht nur, was der Prüfstand nicht kann:**“*, Schritte 10/11 unverändert `:26`, `:27` |
| [L-140.2](LEKTOR-140.md#l-140.2) „81 von 81“ aus zwei Läufen; Prüfbericht unsauberer Baum | **offen** | `Intern/TESTPLAN.md:58-59` *„**81 Fälle, 81 bestanden**“*; `Releases/PRUEFBERICHT.md:6` *„**Arbeitsbaum nicht sauber** (2 Dateien)“* |
| [L-140.3](LEKTOR-140.md#l-140.3) „kommt mit 7.2.2.132“ nach dem Schnüren | **teilweise** — `grep -c "kommt mit 7.2.2.132" Intern/BEFUNDE.md` → 0, *„im Testpaket 7.2.2.132“* → 16 (gemessen); *Zuletzt gemessen* unverändert | [E-128](../Intern/BEFUNDE.md#e-128) (Endung bei *Speichern unter*) und [E-216](../Intern/BEFUNDE.md#e-216) (About-Dialog) weiter *„Zuletzt gemessen: 03.11.2026 an 7.2.1.131**“* |
| [L-138.2](LEKTOR-138.md#l-138.2) E-170-Logzeile als *Misc* | **teilweise, Rest bewusst**, unverändert | `Intern/BEFUNDE.md:430` |
| [L-138.9](LEKTOR-138.md#l-138.9) Berichtszahl README (vorgemerkt) | **offen** | `README.md:98` *„(219 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026)“*; `ls Befunde/LEKTOR-*.md Befunde/PRUEFER-*.md` → 231, mit diesem 232 (gemessen) |
| [L-138.10](LEKTOR-138.md#l-138.10) Ordnernamen in den [E-189](../Intern/BEFUNDE.md#e-189)-Logzeilen (Vorab-Kopie bleibt im Ziel) | **hier offen, auf einem Zweig behoben** | `Eudora71/EuImap/src/ImapToc.cpp:1819`, `:1825` weiter *„ziel=\"%s\"“*; auf `origin/E-192_multiple_IMAP-Mails` 0 Treffer, Commit `3d158172` *„E-189-Logzeilen ohne Ordnernamen“* (gemessen) |
| [L-138.11](LEKTOR-138.md#l-138.11) [E-216](../Intern/BEFUNDE.md#e-216) „Umbruch nicht gemessen“ (vorgemerkt) | **offen** | `Intern/BEFUNDE.md:400` |
| [L-138.12](LEKTOR-138.md#l-138.12) CHANGELOG nur `E-216p` (vorgemerkt) | **offen** | `CHANGELOG.md:187` nennt nur `E-216p`; `tools/WERKZEUGE.md:171` Kopf weiter nur *„Mail folder from* mehr als eine Zeile hoch“* |
| [L-139.1](LEKTOR-139.md#l-139.1) TESTPLAN „Erledigt“ bei offenem [E-170](../Intern/BEFUNDE.md#e-170) (Label ohne UIDPLUS) (vorgemerkt) | **offen** | `Intern/TESTPLAN.md:423` *„Erledigt am 03.11.2026: das Label bleibt beim Verschieben im IMAP-Konto“* |

## Funde

### <a id="l-141.1"></a>L-141.1 — E-220: „64 Zeichen“ und „Windows lehnt ihn ab“ widersprechen der Messung auf dem E-220-Zweig

**Gewicht: mittel — steht in den Release-Notizen, die mit 7.2.2.132 öffentlich werden.** `E-220`: der Dateiname, den *Speichern unter* aus dem Betreff vorschlägt, verliert die Umlaute und ist gekürzt.

- **Die Zahl.** `README.md:164` *„ist nach 64 Zeichen abgeschnitten“*, `Releases/7.2.2.132/RELEASE-NOTIZEN.md:76` *„ist auf 64 Zeichen gekürzt“*, `Intern/TESTPLAN.md:49` (Gregors Ergebnis, Schritt 10) *„ist bei 64 Zeichen abgeschnitten“*. Der Eintrag auf `origin/e220_dateiname_vorschlag` (`Intern/BEFUNDE.md:400`): *„ist nach 63 Zeichen abgeschnitten“*, *„nahm nur die 63 Zeichen, die die Postfachliste vom Betreff speichert“*; die Quelle: `Eudora71/Eudora/summary.h:409` `char m_Subject[64];` — 64 Byte mit Endnull, also 63 Zeichen (belegt). Die Commit-Nachricht von `4f32a676` (gemessen am 03.11.2026, 7.2.1.131 und 7.2.2.132): *„auf 63 Zeichen gekuerzt“*. Der E-220-Zweig selbst schreibt in seiner README-Zeile 164 *„nach 63 Zeichen abgeschnitten“*. Weil die Umlaute erst danach wegfallen, ist der Vorschlag oft noch kürzer (Gegenprobe dort: *„57 Zeichen“*).
- **Der abgelehnte Name.** `README.md:164` *„aus der Postfachliste kann er so im Feld stehen, dass Windows ihn ablehnt“*, `RELEASE-NOTIZEN.md:76-77` gleich, `Intern/TESTPLAN.md:49` *„steht aus der Postfachliste als ganzer Pfad mit doppeltem Rückstrich im Feld — Windows lehnt ihn ab“*. Der Eintrag auf dem E-220-Zweig: *„**Der ganze Pfad im Feld** (aus der Postfachliste, dazu *„Der Dateiname ist ungültig“*) ist **ein Bedienweg, kein Fehler:** Gregor am 03.11.2026: *„es kann sein, dass ich es aus dem windows explorer dorthin kopiert habe“*; am Prüfstand schlug der Dialog in beiden Bauten stets nur den Namen vor“*; `4f32a676`: *„Pfad im Feld in keinem Bau nachgestellt … Speichern ohne Aenderung ergab jedes Mal eine Datei.“* `230f37fd` (14:46) ist nach `4f32a676` (14:04) entstanden — die Einordnung lag also schon vor (belegt an den Zeitstempeln).
- Nebenbei: die README-Zeile verschweigt die **doppelten Leerzeichen** (aus ` | ` werden zwei), die der Eintrag in der Überschrift führt — für den Leser nur Schönheit, kein Fund für sich.

**Vorschlag:** README und Release-Notizen: *„Der bei *Speichern unter* vorgeschlagene Dateiname verliert Umlaute, behält doppelte Leerzeichen und wird nur aus den ersten 63 Zeichen des Betreffs gebildet (an 7.2.1.131 und 7.2.2.132 gemessen, Originalfehler). Behebung in Arbeit.“* — den Satz mit Windows streichen. In TESTPLAN:49 die Beobachtung stehen lassen (sie ist Gregors), aber anhängen: *„laut E-220 ein Bedienweg (Pfad aus dem Explorer eingefügt), nicht nachgestellt“* und 64 → 63.

### <a id="l-141.2"></a>L-141.2 — E-221: „Eudora selbst sendet solche Betreffs so“ klingt nach immer

**Gewicht: Kleinkram.** [`E-221`](../Intern/BEFUNDE.md#e-221): ein langer Umlaut-Betreff erscheint in der Postfachliste um seine ersten sieben Zeichen gekürzt.

- Die Zahl *sieben* trifft: Eintrag auf `origin/e221_betreff_gefaltet` (`Intern/BEFUNDE.md:400`) *„das Leerzeichen am Anfang und die ersten sieben Zeichen des Betreffs fehlten in der Liste“*; *„an 7.2.1.131 und 7.2.2.132 gemessen, Originalfehler“* trifft: *„Gemessen … 7.2.1.131 und 7.2.2.132 `gesendet=1 faltung=doppelpunkt kurz=heil gefaltet=fehlen7 gesendet-betreff=fehlen7`“*, dazu die Starts in `tools/TESTLAEUFE.md:1069-1070`, `:1073-1074` (`C:\Temp\E221-alt` mit `7.2.1.131+a2f29b69*`, `C:\Temp\E221` mit `7.2.2.132+561f3ebf`) (belegt).
- Aber `README.md:165` *„Eudora selbst sendet solche Betreffs so“* und `RELEASE-NOTIZEN.md:81` gleich — der Eintrag: *„manchmal — bei Betreffs von etwa 40 bis 60 Zeichen in rund jedem fünften Fall“*, *„201 von 1025 erfundenen Betreffs“*. Der Leser liest „immer“ und wundert sich, dass sein nächster langer Betreff heil ankommt.
- Die Bedingung *„mit Umlauten“* gilt für das **Senden** (nur kodierte Wörter werden so gefaltet). Beim **Empfang** nennt der Eintrag den Fehler auch für *„eine fertige Nachricht mit `Subject:` und Zeilenumbruch (so falten auch andere Programme)“*; ob das ohne Umlaute ebenso eintritt, sagt er nicht ausdrücklich — Vermutung: ja, der Zweig `!*m_Subject && bInSubject` in `CSummary::Build` hängt nicht am Zeichensatz.

**Vorschlag:** *„… Eudora selbst sendet manche langen Umlaut-Betreffs so (etwa jeden fünften zwischen 40 und 60 Zeichen)“*. Die Umlaut-Frage beim Einarbeiten des E-221-Zweigs klären und dann entweder *„mit Umlauten“* stehen lassen oder auf *„ein langer Betreff“* verallgemeinern.

### <a id="l-141.3"></a>L-141.3 — Backtick-Kennungen und doppelte E-220-Zeile beim Zusammenführen

**Gewicht: Kleinkram, Merkposten für den Merge.**

- `README.md:164-165` führen `E-220`/[`E-221`](../Intern/BEFUNDE.md#e-221) als Backtick-Kennung (richtig, solange die Einträge hier fehlen). Sobald `e220_dateiname_vorschlag` und `e221_betreff_gefaltet` eingearbeitet sind, gehören dort Links hin; `doku-pruefen.pl` meldet Backtick-Kennungen nicht (gemessen: Rückgabe 0), der Wechsel geschieht also nicht von selbst.
- Der E-220-Zweig hat an derselben Stelle eine **eigene** E-220-Zeile (`README.md:164` dort: *„… nach 63 Zeichen abgeschnitten … Im Quellstand behoben, noch in keinem Paket“*) und darunter die Zeile zu den Postfachdateien ohne Umlaut (`:165`, Gregors Entscheidung *„So lassen“* mit Einladung zu Issue oder PR — die Entscheidung steht hier schon in `Arbeitsweise/entscheidung-postfachdateien-umlaute.md`). Beim Merge zwei E-220-Zeilen an derselben Stelle: Konflikt oder Doppelung zu erwarten (Vermutung, nicht ausprobiert). Eine der beiden muss weg; die Postfach-Zeile bleibt.
- Die Release-Notizen nennen E-220 und [E-221](../Intern/BEFUNDE.md#e-221) ohne Link (`RELEASE-NOTIZEN.md:75-83`), während [E-192](../Intern/BEFUNDE.md#e-192), [E-188](../Intern/BEFUNDE.md#e-188), [E-199](../Intern/BEFUNDE.md#e-199), [E-193](../Intern/BEFUNDE.md#e-193) auf `blob/main/Intern/BEFUNDE.md` verlinken. Für das Release reicht das; nach dem Merge der Zweige ließe sich angleichen.

## Bestand außerhalb des Schwerpunkts

- **[E-192](../Intern/BEFUNDE.md#e-192) „die Behebung ist in Arbeit“** (`RELEASE-NOTIZEN.md:85-88`): trifft. Hier `Intern/BEFUNDE.md:419` *„offen, am Quelltext belegt … nie gemessen“*, auf `origin/E-192_multiple_IMAP-Mails` *„Behebung im Quellstand … rot an 7.2.1.131, grün mit der Behebung; kommt mit dem nächsten Paket“*. Kein anderes Dokument dieses Zweigs sagt mehr „behoben im nächsten Paket“ (`grep 'nächsten Paket'` in README, CHANGELOG, TESTPLAN, Release-Notizen: nur Altbestand `CHANGELOG.md:288`, `:5145`) (gemessen). `README.md:172` und `CHANGELOG.md:47` sagen *„nicht gemessen“* bzw. *„nie gemessen“* — für diesen Zweig richtig.
- **Persönliche Angaben:** keine. `git show 230f37fd -- '*.md'` enthält nur Prüfstandspfade unter `C:\Temp`, die erfundenen Beispielbetreffs stehen nicht darin; die Entscheidungsdatei zitiert Gregor zur Sache (gelesen).
- **Klartext:** beide README-Zeilen sagen, was passiert, was verlorengeht (*„nichts“*) und was man tun kann — die Spalten stimmen mit den Einträgen überein (*„Kein Datenverlust“* bei [E-221](../Intern/BEFUNDE.md#e-221), *„keine Post betroffen“* bei E-220). `RELEASE-NOTIZEN.md:82` ist mit 89 Zeichen länger als die übrigen Zeilen des Absatzes — nur Quelltextbild.
- **Entscheidungsdatei** `Arbeitsweise/entscheidung-postfachdateien-umlaute.md` und ihre Spiegelzeilen in `Arbeitsweise/MEMORY.md:173` und `Arbeitsweise/README.md:120` stimmen überein; *„im E-220-Eintrag als entschieden vermerkt“* trifft auf dem E-220-Zweig (*„entschieden von Gregor am 03.11.2026 (*„So lassen“*)“*).
- **TESTLAEUFE** `:1067-1077`: elf Starts, jeder mit Gregors Erlaubnis des Tages und Prüfstandspfad; drei ohne Fassung in der Titelspalte (`:1069`, `:1072`, `:1073`) — welche Fassung dort lief, steht in der Nachbarzeile desselben Prüfstands; kein Fund.

## Was nur Gregor entscheiden kann

Nichts.
