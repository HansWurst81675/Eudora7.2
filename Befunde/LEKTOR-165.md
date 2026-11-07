# <a id="lektor-165"></a>LEKTOR-165 (07.11.2026) — Zweig `e241_vorschau_tasten` nach b0cdece5: E-241 durch die Doku erledigt, `tools/gesichert.pl` mit der Regel „überholt“

**Umfang:** `git diff 37733cd6..HEAD` (ein Commit, `b0cdece5`). Geprüft: [E-241](../Intern/BEFUNDE.md#e-241) (Druckvorschau blättert mit Alt+Pfeil statt Bild ↑/↓) in `Intern/BEFUNDE.md`, `Doku/FAQ.md`, `Doku/FUNKTIONEN.md`, `tools/hilfe-html.pl`, `tools/ZWEIGE.md`, die erzeugten Listen offener Befunde und der übrige Bestand; dazu die neue Regel in `tools/gesichert.pl` gegen `tools/WERKZEUGE.md`. Die neuen Dateien unter `Arbeitsweise/` nur auf Datenschutz.

**Urteil:** Die Doku zu [E-241](../Intern/BEFUNDE.md#e-241) stimmt mit Gregors Messung überein, die Anker treffen, und die Hilfeseite nimmt den neuen Absatz mit. **Aber `tools/gesichert.pl` bricht jetzt ab, sobald ein anderer Arbeitsbaum sauber ist.** Der Sitzungsbeginn meldet dann „Gesichert: alles committet und gepusht“, ohne dass geprüft wurde ([L-165.1](#l-165.1)). **Das hält den PR auf.** Die Behebung ist eine Zeile. **Datenschutz: kein Treffer.** **6 Funde: 1 hält auf, 5 gering.**

## Mechanisch (Ausgaben, kein Urteil)

* **Datenschutz (gemessen):** `perl tools/pruefe-namen-gestaget.pl --commit b0cdece5` meldet *„kein Name aus der lokalen Liste (commit, 11 Muster).“*
* **Selbsttest (gemessen):** `perl tools/gesichert.pl --selbsttest` meldet *„Selbsttest: 11 von 11 Faellen, 0 rot.“* Er deckt den Abbruch aus [L-165.1](#l-165.1) nicht ab (siehe dort).
* **Offene Befunde (gemessen):** `perl tools/offene-befunde.pl` meldet *„62 offene Befunde, in beiden Listen gleich.“* Die Stufentabelle in `Intern/BEFUNDE.md:157-163` sagt dasselbe (*„zusammen | 62 | 202 | 264“*). [E-241](../Intern/BEFUNDE.md#e-241) ist aus den erzeugten Tabellen in `CHANGELOG.md` und `Intern/WEITERMACHEN.md` verschwunden.
* **Anker (gemessen):** `Doku/FAQ.md:20` → `#24-wie-blättere-ich-in-der-druckvorschau` trifft `Doku/FAQ.md:535` (*„## 24. Wie blättere ich in der Druckvorschau?“*). `#2-tastenkürzel-auf-einen-blick` aus `Doku/FAQ.md:549` und `Intern/BEFUNDE.md:410` trifft `Doku/FUNKTIONEN.md:307`.
* **Hilfeseite (belegt am Quelltext):** `tools/hilfe-html.pl:87` nimmt den Abschnitt *„Tastenkürzel auf einen Blick“*. `seite_bauen` (`:260-264`) schneidet bis vor die nächste Überschrift der Ebene 1 oder 2. Das ist `Doku/FUNKTIONEN.md:458` (*„## 3. *Tools → Options*“*). Der neue Absatz `:446-451` liegt davor und **wird mitgenommen**. Der Link auf `../Intern/BEFUNDE.md#e-241` wird dort zu bloßem Text, weil `Intern/` in `@INTERN` steht (`:68`, `link_ziel` `:454`). Das ist so gewollt.
* **ZWEIGE (gemessen):** `tools/ZWEIGE.md:243` führt `e241_vorschau_tasten` mit Gregors Ja zum Namen und zum Umfang.

## Funde

### <a id="l-165.1"></a>L-165.1 — `gesichert.pl` bricht bei einem sauberen fremden Arbeitsbaum ab, und der Sitzungsbeginn meldet dann „gesichert“

**Gewicht: hält den PR auf.** Belegt am Code. Das Muster ist gemessen, der ganze Lauf nicht (Auftrag: nur `--selbsttest`).

* `tools/gesichert.pl:139`: *„return (\@alle, []) unless @alle;“*. Bei einem Baum ohne Änderungen gibt die Funktion weiter **zwei** Werte zurück. Der neue Schluss `:182` gibt drei zurück (*„return (\@alle, \@verloren, \@ueberholt);“*).
* `tools/gesichert.pl:498-502` nimmt drei Werte an und zählt sie: *„my $u = scalar @$f_ueberholt;“*. Bei einem sauberen Baum ist `$f_ueberholt` undefiniert. Unter `use strict` (`:46`) stirbt Perl daran. **Gemessen** mit demselben Muster: `perl -e 'use strict; … my ($a,$b,$c)=f(); my $u = scalar @$c;'` gibt *„Can't use an undefined value as an ARRAY reference“* aus, Rückgabe 255.
* Der Fall tritt sofort ein. `git status --porcelain` im LEKTOR-Baum `.wt/stand/.wt/lektor` gibt **0** Zeilen aus (gemessen), und `git worktree list` führt ihn als fremden Baum für `.wt/stand`. Nach dem Merge gilt das für jeden geparkten Agentenbaum.
* Folge: `tools/sitzungsbeginn.pl:60-64` sucht in der Ausgabe nach *„NICHT GESICHERT:“*. Der Abbruch kommt, bevor die Mängelliste gedruckt wird. Dann greift der `else`-Zweig: *„Gesichert: alles committet und gepusht“*. Das ist **blind grün**. Es verdeckt auch echte Verluste in Bäumen, die nach dem sauberen Baum gezählt würden. `tools/rollen-faellig.pl` und `tools/pruefe-branch.pl` rufen `gesichert.pl` ebenfalls auf (gemessen mit `grep`; was sie mit dem Abbruch machen, ist nicht geprüft).
* Der Selbsttest sieht das nicht. `$pruefe` (`:249-258`) ruft die Funktion direkt auf, nimmt nur zwei Werte an und durchläuft die Schleife über die Arbeitsbäume nie.

**Soll:** `:139` auf `return (\@alle, [], []) unless @alle;`. Dazu einen Selbsttest-Fall, der die dritte Liste bei einem sauberen Baum abfragt. Prüfen, ob `@$f_ueberholt` definiert ist, oder einen zweiten Arbeitsbaum im Wegwerf-Repo anlegen. Gegenprobe: mit der alten Zeile `:139` muss der neue Fall rot werden.

### <a id="l-165.2"></a>L-165.2 — WERKZEUGE nennt im selben Eintrag „9 Fälle“ und „11/11“

**Gewicht: gering.** Gemessen am Text.

* `tools/WERKZEUGE.md:64`: *„Gegenprobe: `--selbsttest`, **9 Fälle** in einem Wegwerf-Repo“* und weiter hinten *„Selbsttest 11/11“*. Der Kopf von `tools/gesichert.pl:73` ist auf *„11 Faelle“* berichtigt, der Eintrag in WERKZEUGE nicht.
* Im selben Eintrag fehlt der Punkt vor *„**Seit 07.11.2026 „überholt“:**“*. Davor steht *„(gegengeprüft an `wt-chronist` in beide Richtungen)“*. Die Lücke gab es schon vorher, jetzt hängen aber zwei Sätze daran.

**Soll:** „9 Fälle“ → „11 Fälle“ (oder „seit 07.11.2026 11“); Punkt setzen.

### <a id="l-165.3"></a>L-165.3 — Im eigenen Baum wird „überholt“ stillschweigend als „Byte für Byte auf dem Server“ gemeldet

**Gewicht: gering.** Belegt am Code.

* `tools/WERKZEUGE.md:64` sagt allgemein: eine überholte Datei *„wird als Hinweis „überholt, nichts geht verloren“ gemeldet“*. Das stimmt nur für **fremde** Bäume (`tools/gesichert.pl:504-509`).
* Für den eigenen Baum nimmt `:377-378` nur zwei Werte an. Überholte Dateien fallen aus `@verloren` heraus und werden unter `:389-393` gezählt. Dort steht der Hinweis *„ihr Inhalt steht Byte fuer Byte schon auf dem Server“*. Für eine überholte Datei stimmt das nicht. Bei ihr steht nur jede Zeile der Änderung im Ref, die Datei als Ganzes nicht.
* Die Regel prüft, ob eine Zeile **irgendwo** in der Datei im Ref steht (`:169`, `%im_ref` als Menge). Reihenfolge und Anzahl prüft sie nicht. Eine neu hinzugefügte Zeile, die nur aus `}` besteht, oder eine Leerzeile gilt also immer als „im Ref“. Der Wortlaut in WERKZEUGE (*„jede hinzugefügte Zeile dort vorhanden“*) gibt das genau wieder. Dass es im Alltag einen echten Verlust verdeckt, ist eine **Vermutung**. Dafür müsste die ganze Änderung aus solchen Allerweltszeilen bestehen.

**Soll:** Im eigenen Baum die dritte Liste auch annehmen und denselben Hinweis „überholt“ ausgeben. Sonst in WERKZEUGE dazuschreiben: „nur für die anderen Arbeitsbäume“. Die Grenze der Mengenprüfung dort einen Halbsatz lang nennen.

### <a id="l-165.4"></a>L-165.4 — WEITERMACHEN nennt E-241 noch „Ursache ungeklärt“, der neue Zweig fehlt im Kopf

**Gewicht: gering.** Gemessen am Text.

* `Intern/WEITERMACHEN.md:19`, im Punkt *„In Arbeit: Testpaket 7.2.2.138“*: *„[E-241](BEFUNDE.md#e-241) **nicht** dabei (Ursache ungeklärt).“* Dass [E-241](../Intern/BEFUNDE.md#e-241) nicht in 138 ist, stimmt weiter. „Ursache ungeklärt“ widerspricht aber dem heutigen Urteil in `Intern/BEFUNDE.md:410`. Danach ist die Vorschau die des Internet Explorer in einem eigenen Thread, und dort blättert Alt+Pfeil.
* `grep -n "e241\|vorschau_tasten"` über `Intern/WEITERMACHEN.md`, `README.md` und `ZIEL.md` findet nichts (gemessen). Der Kopf von WEITERMACHEN kennt den Zweig `e241_vorschau_tasten` also nicht.
* **Kein Fund**, nur zur Abgrenzung: `CHANGELOG.md:131` (*„die Ursache ist offen“*) und `:135` (*„die Ursache ist nicht geklärt“*) stehen in den Abschnitten der Testpakete 7.2.2.138 und 7.2.2.137. Sie beschreiben den damaligen Stand. `README.md` führt [E-241](../Intern/BEFUNDE.md#e-241) in keiner Tabelle (gemessen, kein Treffer auf „Bild ↑“ oder [E-241](../Intern/BEFUNDE.md#e-241)). `ZIEL.md` nennt [E-241](../Intern/BEFUNDE.md#e-241) nicht.

**Soll:** `:19` auf „(nicht in 138; seit 07.11.2026 durch die Doku erledigt, [FAQ 24](../Doku/FAQ.md#24-wie-blättere-ich-in-der-druckvorschau))“. Den Zweig in den Kopf aufnehmen.

### <a id="l-165.5"></a>L-165.5 — E-241: alte Sätze „Was noch fehlt“ und „Ursache weiter offen“ stehen ohne Vermerk hinter dem neuen Urteil

**Gewicht: gering.** Gemessen am Text.

* `Intern/BEFUNDE.md:410` beginnt richtig mit *„erledigt durch die Doku“* und kennzeichnet den alten Teil mit *„Vorher:“*. Danach stehen aber unverändert zwei Sätze *„**Was noch fehlt:**“* und *„**Nachtrag 07.11.2026 — eine Vermutung gemessen widerlegt, Ursache weiter offen; nicht in 7.2.2.138.**“*. Der letzte Satz *„Was noch fehlt: Gregors Probe, ob Bild ↓ nach einem Mausklick in die Seite der Vorschau blättert; dann, ob dieselbe Vorschau im Internet Explorer selbst blättert“* ist zur Hälfte beantwortet (Klick: nein). Die andere Hälfte ist durch das Urteil hinfällig. Beides steht nirgends dabei.
* Bei [E-240](../Intern/BEFUNDE.md#e-240) (`:411`) ist das Muster dafür schon da: *„**Überholt durch den Nachtrag oben ([L-162.2](LEKTOR-162.md#l-162.2)):**“*.

**Soll:** Vor den alten Teil oder an die beiden Sätze „überholt durch das Urteil vom 07.11.2026“ setzen.

### <a id="l-165.6"></a>L-165.6 — „Eudora kann die Tasten der Vorschau nicht umbelegen“ steht als Tatsache da

**Gewicht: gering.** Belegt am Text. Der Inhalt ist eine **Vermutung**.

* `Doku/FAQ.md:543`: *„dort gelten seine Tasten, Eudora kann sie nicht umbelegen.“* Ebenso `Doku/FUNKTIONEN.md:453-454` und `Intern/BEFUNDE.md:410`.
* Gemessen ist nur der eigene Thread (`Intern/BEFUNDE.md:410`, *„E241 THREAD vorschau=3732 haupt=8368 gleich=0“*), und dass Eudoras `PreTranslateMessage` die Taste nie sieht. Dass Eudora die Tasten **grundsätzlich** nicht umlegen kann, etwa über einen Tastatur-Haken auf den Vorschau-Thread, ist weder versucht noch belegt. Für die Anwenderdoku ist der Satz harmlos. Er schließt aber eine spätere Abhilfe aus, ohne dass sie geprüft wurde.

**Soll:** „Eudora gibt diese Tasten nicht weiter“ oder „Eudoras Tastenbelegung gilt dort nicht“. Das ist gemessen. Den Satz „kann nicht umbelegen“ in BEFUNDE als Vermutung kennzeichnen.

## Hält etwas den PR auf?

**Ja: [L-165.1](#l-165.1).** Nach dem Merge bricht `tools/gesichert.pl` ab, sobald ein anderer Arbeitsbaum sauber ist. Der Sitzungsbeginn meldet dann „Gesichert“, ohne geprüft zu haben. Die Behebung ist eine Zeile (`:139`, drei Rückgabewerte). Dazu kommt ein Selbsttest-Fall, der sie abdeckt. [L-165.2](#l-165.2) bis [L-165.6](#l-165.6) sind gering und halten nichts auf. Die Doku zu [E-241](../Intern/BEFUNDE.md#e-241) selbst ist in Ordnung.
