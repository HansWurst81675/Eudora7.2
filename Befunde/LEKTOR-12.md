# L-17 — der siebzehnte Lektoratsdurchgang

**17.09.2026.** Geprüft an Zweig `e101-speichern-dateiformat`, Commit `a5cbf3c`,
Quellstand **7.2.0.66** / `VERSION` **1.0.66**. Umfang aus der Quelle:
`git ls-files '*.md'` nennt **149** Dateien — alle, nicht eine Auswahl
([pruefumfang-nicht-von-hand](../Arbeitsweise/pruefumfang-nicht-von-hand.md)).
Vorgänger: [LEKTOR-11.md](LEKTOR-11.md) (L-16, 146 Dateien).

Geprüft wurde gegen den **Bestand**, nicht gegen den Diff
([review-sieht-nur-den-diff](../Arbeitsweise/review-sieht-nur-den-diff.md)) —
und genau das war wieder entscheidend: **kein einziger der neun Mängel unten
steht in einer Datei, die `a5cbf3c` angefasst hat.**

## In einem Satz

Dieselbe Ersetzung wie in L-16, nur andersherum: **eine Zahl blieb stehen, wo
sie hätte mitwandern müssen** — `README.md`, `AUFGABEN.md` und
`WEITERMACHEN.md` schrieben **E-97** der Fassung **7.2.0.66** zu, obwohl E-97
in **7.2.0.64** behoben und von Gregor an **1.0.64** bestätigt ist; dazu war
`WEITERMACHEN.md` die einzige Datei, die Gregor sagt, was zu prüfen ist, und
sie schickte ihn zum **falschen Befund**. **Vier Befunde (E-98 bis E-101)
fehlten in fünf Dateien vollständig**, darunter **E-98 im offenen Teil des
CHANGELOG** — ein offener Mangel, der nirgends in der Anwenderdoku stand.
Und **eine Schranke war zum dritten Mal an derselben Stelle stumm.**

## Die Mängel

| # | Wo | Was stand da | Was stimmt |
|---|---|---|---|
| **L17-1** | `README.md:82`, `:88` | *„Der Absturz beim Speichern einer Nachricht (**7.2.0.66**, E-97)"* und *„Behoben im Quellstand **7.2.0.66**"* | E-97 ist in **7.2.0.64** behoben und von Gregor an 1.0.64 bestätigt. **Derselbe Fehlertyp wie L-16-1**, nur in die andere Richtung: dort wurde eine historische Angabe mitgezogen, hier ist eine stehengeblieben, während die Fassung zweimal weiterrückte |
| **L17-2** | `AUFGABEN.md:27` | *„E-97 (File → Save As beendete Eudora sofort, **7.2.0.66**)"*, und E-97 stand weiter unter *„warten auf sein Urteil"* | 7.2.0.64; **Gregor hat bestätigt**: *„speichern test hat also funktioniert."* Die Zeile hätte ihn ein zweites Mal zum selben Test geschickt |
| **L17-3** | `WEITERMACHEN.md:11` | *„VON GREGOR ZU PRÜFEN — E-97. Gebaut in **7.2.0.66** (**153/153 Tests**), von Gregor **noch nicht bestätigt**. Prüfanleitung … Abschnitt **7.2.0.66**"* | **Drei Fehler in einer Zeile.** E-97 ist 7.2.0.64, bestätigt, und der Abschnitt 7.2.0.66 beschreibt **E-101**. Die Zeile hätte Gregor zur Prüfanleitung eines fremden Befunds geschickt — **wortwörtlich der teuerste Fund aus L-16, ein zweites Mal** |
| **L17-4** | `WEITERMACHEN.md:14` | *„gebaut am 17.09.2026 (**E-97**) … unter `Releases/` liegt zuletzt `Eudora72-**1.0.63**-release"* | Gebaut ist **E-101**; unter `Releases/` liegt das Verzeichnis **`Eudora72-1.0.65-release`**, letztes ZIP `Eudora72-1.0.64-release.zip`. Nachgemessen, nicht geglaubt: **zu 1.0.66 gibt es kein Paket** |
| **L17-5** | `WEITERMACHEN.md:15` | *„Zuletzt von Gregor bestätigt: **1.0.50 am 11.09.2026**"* | **1.0.64 am 17.09.2026** — E-97 (*„gespeichert. funktioniert."*) und E-99 (*„ja, kein datenverlust!"*). Die Zeile war sechs Tage und vierzehn Fassungen alt |
| **L17-6** | `CHANGELOG.md`, Abschnitt *Noch offen* | **E-98 fehlte ganz** | E-98 ist offen und trifft den Anwender unmittelbar: zwei Optionen im Speicherdialog sind nicht wählbar. `BEFUNDE.md` führte ihn, die Anwenderdoku nicht |
| **L17-7** | `README.md` (Einschränkungen), `AUFGABEN.md`, `ZIEL.md` | **E-98, E-99, E-100 und E-101 kamen nicht vor** | Gemessen über alle 149 MDs: die vier Befunde standen **nur** in `BEFUNDE.md`, `CHANGELOG.md`, `WEITERMACHEN.md` (nur E-98) und den Berichten von PRÜFER und LEKTOR. Keine der drei Dateien, die den *jetzigen Stand* führen, kannte sie |
| **L17-8** | `ZIEL.md:17`, `PORTIERUNG.md:43`, `Releases/PAKETE.md:6` | *„gebaut ist inzwischen **7.2.0.64**"* / *„Quellstand **7.2.0.64**, `VERSION` **1.0.64**"* / *„**1.0.30 bis 1.0.63**"*, alle drei mit *„als Paket geschnürt zuletzt **1.0.63**"* | 7.2.0.66 / 1.0.66, geschnürt zuletzt **1.0.65**. **Ein Wert, der mehrfach vorkommt** — drei Dateien, ein Arbeitsschritt ([doku-parallel-nicht-hinterher](../Arbeitsweise/doku-parallel-nicht-hinterher.md)) |
| **L17-9** | `tools/ZWEIGE.md` | der Zweig **`e101-speichern-dateiformat`** fehlte | Er wird seit 7.2.0.64 benutzt und ist auf `origin` gepusht. **Hier war die Schranke nicht stumm:** `tools/pruefe-branch.pl` meldet ihn — sie hängt am Commit, und dort hat sie niemand gelesen |

## Die stumme Schranke: dieselbe Konvention, das dritte Mal

In L-16 standen zwei stumme Schranken. Eine davon ist heute **wieder** stumm
gewesen, an derselben Stelle und aus demselben Grund.

**E-101 hat zwei Spurmarken im Bau** — `msgutils.cpp:3840` und `:4037`, Text
`E-101 speichern:`. `perl tools/spuren-auswerten.pl` sagte dazu an Fassung
1.0.66 **gar nichts**: weder *„hat Marken, aber keine Zeile in SPURMARKEN.md"*
noch *„Zeile ohne Marke"*. Es zählte unverändert **8** Befunde mit Marken.

**Warum.** Das Werkzeug erkennt eine Marke daran, dass in einer Kommentarzeile
das Wort `SPURMARKE` steht (`tools/spuren-auswerten.pl:122`). Über der
E-101-Marke steht `BEFUND E-101` — ohne dieses Wort. Genau wie bei **E-95**
(`E-95-MESSUNG`) und **E-97** (`BEFUND E-97` / `E-97-Messung`).

**Das ist die teurere Sorte von Fehler**
([pruefstand-kann-blind-sein](../Arbeitsweise/pruefstand-kann-blind-sein.md)):
ein kaputter und ein grüner Prüfstand melden beide nichts. Und es ist zugleich
ein Beleg für
[lehren-anwenden-nicht-nur-schreiben](../Arbeitsweise/lehren-anwenden-nicht-nur-schreiben.md):
der Abschnitt *„Nachtrag 17.09.2026"* in `Befunde/SPURMARKEN.md` beschreibt den
Fall seit heute Vormittag — am Nachmittag ist er zum dritten Mal passiert.

**Was ich getan habe:** die Zeile zu E-101 steht jetzt in beiden Tabellen von
`Befunde/SPURMARKEN.md`, und ein zweiter Nachtrag hält den Vorgang fest.
Dadurch meldet das Werkzeug E-101 nun als *verwaist* — **das ist ein Fehlalarm
derselben Sorte wie der zu E-95**, und er steht als solcher dokumentiert.

**Was ich nicht getan habe und nicht darf:** die Kommentare im Quelltext
ändern. Der LEKTOR fasst `Eudora71/` nicht an.

**Mein Vorschlag, und er geht über die drei Einzelfälle hinaus**
([fehlerklassen-abstellen](../Arbeitsweise/fehlerklassen-abstellen.md)): dass
ein Schlüsselwort im **Kommentar** darüber entscheidet, ob eine Marke gesehen
wird, ist die Ursache aller drei Fälle. Ein Erkennungsmuster am
**Ausgabetext** — `"E-<Zahl> <Wort>:"` im Formatstring — hätte E-95, E-97 und
E-101 alle drei gefunden, ohne dass jemand eine Konvention einhalten muss.
**Das ist ein Vorschlag, keine beschlossene Sache.**

### Die zweite Schranke aus L-16: diesmal ein halber Treffer

L-16 fand, dass **kein Werkzeug prüft, ob ein CHANGELOG-Abschnitt ein Datum
trägt**. Gemessen über alle Fassungsabschnitte:

| Abschnitt | Datum |
|---|---|
| 7.2.0.66 | 17.09.2026 — **trägt eines** |
| 7.2.0.65 | **fehlte** — nachgetragen (*„Vom Prüfer am 17.09.2026 gefunden"*) |
| 7.2.0.64 | 17.09.2026 |

Der neue Abschnitt ist also in Ordnung, der davor war es nicht. **Die Schranke
prüft es weiterhin nicht** — `pruefe-doku-takt.pl` verlangt nur, dass ein
Abschnitt *existiert*. Der Vorschlag aus L-16 steht damit unverändert.

## Was still war

| Schranke | Ergebnis |
|---|---|
| `tools/doku-pruefen.pl` | **Kein Widerspruch.** Nach der Arbeit sind `ZIEL.md` und `PORTIERUNG.md` aus der Kenntnisliste verschwunden; übrig bleiben `EINSTELLUNGEN.md`, `FILTER.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md` — Dateien ohne Fassungsbezug, das ist kein Mangel |
| `tools/pruefe-doku-takt.pl` | still. 52 Abschnitte, absteigend, keine Lücke ab 7.2.0.36 |
| `tools/pruefe-stand-md.pl` | still. 5 Stand-Köpfe, Maßstab 17.09.2026 |
| `tools/offene-befunde.pl` | still. **12 offen laut `BEFUNDE.md`, 12 in `WEITERMACHEN.md`** — auch nach dem Umbau der Prüfliste |
| `tools/lehren-schranken.pl` | still. 70 Lehren, 45 mit Schranke, 25 mit begründeter Ausnahme |
| `tools/spuren-auswerten.pl` | **stumm zu E-101** (oben) |
| `tools/pruefe-branch.pl` | **hat gemeldet** — den fehlenden Zweig. Niemand hat sie gelesen |

## Eine Frage an Gregor, die ich nicht allein entscheide

**`C:\Temp\messen-e101.ps1`** (7.381 Byte, 17.09.2026 12:15) ist das
Messskript, mit dem E-101 am laufenden Programm geprüft wurde. Es liegt
**außerhalb** des Repos und ist in **keiner** MD erwähnt.

**Was ich meine:** Das Skript gehört **nicht** nach `tools/`. Es ist ein
Wegwerfwerkzeug für einen einzelnen Befund; `tools/WERKZEUGE.md` führt bereits
96 Einträge, und der Grund, warum diese Datei überhaupt existiert, ist, dass
Werkzeuge ein zweites Mal erfunden werden — ein Bestand aus Einmalskripten
macht das schlimmer, nicht besser
([werkzeug-vor-eigenbau](../Arbeitsweise/werkzeug-vor-eigenbau.md)).

**Aber `tools/TESTLAEUFE.md` genügt hier nicht — weil dort nichts steht.**
Nachgemessen: der letzte Eintrag ist vom **17.09.2026 12:16:43** und nennt
Fassung **1.0.65** (`C:\Temp\E100`). **Zum E-101-Messlauf gibt es keinen
Eintrag.** Das ist die eigentliche Lücke, nicht der Ablageort des Skripts
([eingebaute-messung-auslesen](../Arbeitsweise/eingebaute-messung-auslesen.md)).

**Mein Vorschlag:** Skript draußen lassen, **einen Eintrag in
`tools/TESTLAEUFE.md`** nachtragen — mit dem, was die Marke `E-101 speichern:`
gesagt hat. **Nachtragen kann das nur, wer die Messung gefahren hat**; ich habe
die Werte nicht, und ich erfinde keine
([pruefen-statt-vermuten](../Arbeitsweise/pruefen-statt-vermuten.md)).

## Was berichtigt wurde

| Datei | Änderung |
|---|---|
| `README.md` | E-97 auf 7.2.0.64 zurückgesetzt (2 Stellen), E-99/E-100/E-101 in *Noch nicht im Download enthalten* aufgenommen, **E-98 als eigener Punkt** unter den Einschränkungen |
| `AUFGABEN.md` | E-97 auf 7.2.0.64 und als **bestätigt** gekennzeichnet, ein Absatz zu E-99/E-100/E-101 und dem offenen E-98, Paketstand auf 1.0.65 nachgemessen |
| `WEITERMACHEN.md` | Prüfliste umgebaut: **E-101** und **E-100** als zu prüfen, **E-97** als bestätigt, **E-98** als offen; *Zuletzt gebaut* auf E-101 / 160 Tests / Releases-Stand; *Zuletzt bestätigt* auf 1.0.64 |
| `ZIEL.md` | Stand auf 7.2.0.66, Befundliste um E-99/E-100/E-101 ergänzt, Bestätigungslage und E-98 benannt, Paketstand 1.0.65 |
| `CHANGELOG.md` | **E-98 in *Noch offen*** aufgenommen; Datum im Abschnitt 7.2.0.65 nachgetragen |
| `PORTIERUNG.md` | Stand-Kopf auf 7.2.0.66 / 1.0.66, die drei dazugekommenen Befunde benannt, 160 Tests |
| `Releases/PAKETE.md` | *„1.0.30 bis 1.0.63"* → *bis 1.0.65*, mit der Messung unter `Releases/` |
| `Befunde/SPURMARKEN.md` | **E-101 in beide Tabellen**, zweiter Nachtrag zur dritten stummen Meldung samt Vorschlag für die Fehlerklasse |
| `tools/ZWEIGE.md` | `e101-speichern-dateiformat` nachgetragen — **ausdrücklich ohne Beleg für eine Absprache** |
| `LEKTORAT.md` | Stand-Kopf auf L-17 |

**Nach jedem Schreibzugriff gemessen** — alle Dateien **CR=0**, UTF-8 ohne
BOM ([zeilenenden-nach-jedem-schreibzugriff-messen](../Arbeitsweise/zeilenenden-nach-jedem-schreibzugriff-messen.md)).
Keine Datei unter `Eudora71/` angefasst.

## Was daraus zu lernen war

**Die Ersetzung einer Fassungsnummer ist keine Textersetzung, sie ist eine
Zuordnung.** L-16 fand drei historische Angaben, die eine Ersetzung 63 → 64
mitgenommen hat. L-17 findet den umgekehrten Fall: E-97 blieb bei 66 stehen,
während die Fassung zweimal weiterrückte. Beide Male entstand derselbe Schaden
— **Gregor wird zur Prüfanleitung eines fremden Befunds geschickt.**

Beide Male wäre es an einer Frage aufgefallen, die niemand gestellt hat:
**welche Fassung hat diesen Befund behoben — und in welchem Abschnitt steht
seine Prüfanleitung?** Das sind zwei Werte in einer Zeile
([zwei-werte-in-eine-ausgabe](../Arbeitsweise/zwei-werte-in-eine-ausgabe.md)),
und es ist prüfbar: jede Zeile in `WEITERMACHEN.md`, die einen Befund und einen
CHANGELOG-Abschnitt nennt, muss beide auf dieselbe Fassung beziehen. **Zweimal
in Folge derselbe Fehler ist der Punkt, an dem eine Schranke fällig wird**
([fehlerklassen-abstellen](../Arbeitsweise/fehlerklassen-abstellen.md)) — das
ist der eine Vorschlag, den ich Gregor aus diesem Durchgang vorlege.
