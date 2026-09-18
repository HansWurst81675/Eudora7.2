# PRÜFER-17 — die Schranken vor dem Commit, und warum v1.0.72 durchkam

Stand: 18.09.2026. Zweig `schranken-vor-dem-commit`, Arbeitsbaum
`C:\Users\Gregor\Documents\github\Eudora7.2`. **Kein Quelltext unter
`Eudora71/` angefasst, kein ändernder git-Befehl gefahren.** Geändert wurden
nur `tools/` und die beiden Haken.

Anlass — Gregor am 18.09.2026:

> *„repariere deine schranken, so dass VOR dem commit und merge alles auf
> github vorhanden ist."*

---

## Die Antwort in einem Satz

**Die Schranken haben nicht versagt, weil sie schlecht prüfen — sondern weil
sie zum Zeitpunkt des Commits gar nicht laufen.** Von den fünf Doku-Schranken,
die den Fall v1.0.72 hätten fangen können, hing **keine einzige** in
`pre-commit` oder `pre-push`; die sechste (`release-pruefen.pl`) hing mit
`|| true` und konnte konstruktionsbedingt nie abweisen. Dazu kommen drei
belegte Löcher in den Schranken selbst und **eine Lüge, die noch heute auf
`main` steht** und die neue Schranke ungehindert passiert.

---

## 0. Was ich gefahren habe

* `.git/hooks/pre-commit`, `.git/hooks/pre-push`, `tools/hooks-einrichten.sh`
  gelesen und die Aufrufliste gegen `tools/` abgeglichen.
* Jede der fünf Schranken einzeln gefahren, **mit Laufzeitmessung**.
* `tools/pruefe-release-buchfuehrung.pl` gegen den **echten** Stand `8da72c8`
  gefahren (Dateien über `git show 8da72c8:<datei>` herausgezogen) und gegen
  den **jetzigen** Arbeitsbaum.
* Den echten Fall **7.2.0.70** gegen `pruefe-befund-verbreitung.pl` nachgestellt.

---

## Fund 1 — fünf Schranken hängen in keinem Haken

| | |
|---|---|
| **Fund** | Die Schranken, die den Fall v1.0.72 fangen sollen, laufen weder vor dem Commit noch vor dem Push. Sie laufen nur, wenn jemand daran denkt. |
| **Ort** | `.git/hooks/pre-commit`, `.git/hooks/pre-push` |
| **Gemessen** | `pre-commit` ruft 16 Schranken auf; `pre-push` drei. Von `pruefe-befund-verbreitung.pl`, `pruefe-stand-md.pl`, `pruefe-doku-takt.pl`, `offene-befunde.pl`, `pruefe-release-buchfuehrung.pl` steht **keine** in einer der beiden Dateien (`grep` über beide: null Treffer). `release-pruefen.pl` steht im `pre-commit`, aber als `… \|\| perl … \|\| true` — der Rückgabewert wird weggeworfen. |
| **Bewertung** | Das ist die Hauptursache, nicht ein Nebenbefund. `Arbeitsweise/lehren-anwenden-nicht-nur-schreiben.md`: *„eine Lehre ohne Auslöser und Werkzeug wirkt nicht."* Dasselbe gilt für eine Schranke ohne Aufrufstelle — sie ist Text. Genau diesen Fehler hat `tools/lehren-schranken.pl` am 09.09.2026 schon einmal bei `pruefe-fensterbau.pl` gefunden. |
| **Behebung** | siehe Abschnitt „Verdrahtet". |

---

## Fund 2 — `pruefe-behoben-belegt.pl` und `pruefe-anzeigetext.pl`: Freispruch über die leere Menge

| | |
|---|---|
| **Fund** | Beide melden ihren Erfolgssatz und geben 0 zurück, obwohl sie **0 Zeilen** angesehen haben. |
| **Ort** | `tools/pruefe-behoben-belegt.pl`, `tools/pruefe-anzeigetext.pl` |
| **Gemessen** | Lauf am 18.09.2026 im jetzigen Arbeitsbaum: `geprueft (neu oder geaendert) 0 / mit Beleg 0 / ohne Beleg 0` → *„Jedes neue \"behoben\" nennt seinen Beleg."*, Rückgabe **0**. Und: `gepruefte Zeilen 0 / Zitate ohne Herkunftsangabe 0` → *„Jeder zitierte Oberflaechentext nennt seine Herkunft."*, Rückgabe **0**. |
| **Bewertung** | Die Zahl steht in der Ausgabe und widerspricht dem Satz darunter — `Arbeitsweise/ausreisser-ist-der-befund.md`. *„Nichts geprüft"* und *„geprüft und frei"* sehen identisch aus; das ist genau der Zustand, den E-109 Punkt (4) beschreibt. |
| **Behebung** | siehe Abschnitt „Repariert". |

---

## Fund 3 — `pruefe-befund-verbreitung.pl` ist am echten Fall 7.2.0.70 blind

| | |
|---|---|
| **Fund** | Der Prüfumfang kommt aus den **Überschriften** des jüngsten CHANGELOG-Abschnitts. Nennt ein Abschnitt seine Befunde nur im Fließtext, ist der Umfang 0 — und die Schranke meldet grün. |
| **Ort** | `tools/pruefe-befund-verbreitung.pl`, `kennungen_der_neuesten_fassung` (Zeile 121–136) |
| **Gemessen** | Der Abschnitt `## 7.2.0.70` hat genau drei Überschriften: *„ein vollständiger Stand zum Testen…"*, *„Warum es zwei Fassungsnummern 1.0.68 gab"*, *„Was in welchem Paket steckt"*. **Keine davon nennt eine Kennung.** Im Fließtext desselben Abschnitts stehen **E-101, E-103, E-104, E-106**. Umfang 0 → Ausgabe *„nennt keinen Befund - nichts zu pruefen"*, Rückgabe 0. |
| **Bewertung** | Belegt, genau wie in E-109 beschrieben. Die beiden Schärfungen gegen Fehlalarme (54 → 3 → 0) haben in die Blindheit hinein geschärft. |
| **Behebung** | siehe Abschnitt „Repariert". |

---

## Fund 4 — die neue Schranke lässt eine echte Lüge durch, die heute auf `main` steht

| | |
|---|---|
| **Fund** | `pruefe-release-buchfuehrung.pl` prüft **zeilenweise**. Steht die Standaussage in einer Zeile und die Nummer in der Zeile darüber, sieht sie beide nie zusammen. |
| **Ort** | `tools/pruefe-release-buchfuehrung.pl`, `sub pruefe` (`for my $z (split /\n/, $inhalt)`) — gegen `Releases/PAKETE.md:322-323` |
| **Gemessen** | In `Releases/PAKETE.md` steht heute: Zeile 322 `## 1.0.29 — veröffentlicht am 09.09.2026`, Zeile 323 `**Die aktuelle Fassung, und die einzige, die als Paket im Repo liegt.**` Das ist eine Standaussage über **1.0.29**, während v1.0.72 veröffentlicht ist. Der Lauf gegen den jetzigen Arbeitsbaum meldet zu `Releases/PAKETE.md` **null Mängel**. |
| **Bewertung** | Der Fall, vor dem `Arbeitsweise/schranke-gegentesten.md` seit dem 07.09.2026 ausdrücklich warnt: *„Zeilenweise ist eine Annahme. Ein Satz in einer MD-Datei umbricht."* Die Schranke wurde gegen genau den Fall gebaut, der passiert war (README-Einzeiler), nicht gegen die nächste Spielart — das Muster aus E-109. |
| **Behebung** | siehe Abschnitt „Repariert". |

---

## Fund 5 — Prüfung A der neuen Schranke ist fast wertlos

| | |
|---|---|
| **Fund** | *„Kennt die Datei die neueste Nummer?"* wird von **jeder beliebigen** Erwähnung irgendwo in der Datei erfüllt — auch von einem Beispiel in einer Begriffstabelle. |
| **Ort** | `tools/pruefe-release-buchfuehrung.pl`, `sub pruefe`, Prüfung A |
| **Gemessen** | Am echten Anlassfall `8da72c8` wurde `README.md` **nicht** als schweigend gemeldet. Grund: Zeile 634 lautet `\| **Paketnummer**, z. B. \`1.0.72\` \| die Datei \`VERSION\` \| …` — ein *Beispiel* im Glossar. Ebenso `AUFGABEN.md` über einen Nebensatz in Zeile 3. Nur `Releases/PAKETE.md` und `tools/RELEASES.md` fielen durch A. |
| **Bewertung** | A fängt nur den Extremfall „Wort kommt nirgends vor". Die Arbeit macht Prüfung B. Kein Schaden, aber die Meldung *„kennt die neueste Fassung"* verspricht mehr, als sie misst — `Arbeitsweise/messung-muss-den-weg-treffen.md`, Fall 5: *„Eine Aussage darf nicht weiter reichen als die Messung."* |
| **Behebung** | Ausgabetext geschärft; A bleibt als Grobfilter, wird aber nicht mehr als „Dokument ist auf Stand" ausgegeben. |

---

## Fund 6 — zwei gemessene Fehlalarme der neuen Schranke

| | |
|---|---|
| **Fund** | Gegen den **jetzigen** Arbeitsbaum meldet sie 7 Mängel. **Alle 7 sind Fehlalarme.** |
| **Ort** | `WEITERMACHEN.md:27` (6 ×), `tools/RELEASES.md:29` (1 ×) |
| **Gemessen** | `WEITERMACHEN.md:27` ist die Zeile `\| **Zuletzt gebaut und veröffentlicht** \| Quellstand **7.2.0.72** / \`VERSION\` **1.0.72** … **Sie enthält…**` — sie nennt die **richtige** Nummer und zählt danach auf, was seit 1.0.65 enthalten ist. Die Schranke beanstandet 1.0.65, .67, .68, .69, .70, .71. `tools/RELEASES.md:29` ist die **Protokollzeile** des Releases v1.0.64 vom 17.09.2026, die den damaligen Zustand festhält (*„auf GitHub als \*Latest\* markiert"*). |
| **Bewertung** | `Arbeitsweise/schranke-gegentesten.md`: *„eine Schranke, die zweimal umsonst warnt, wird beim dritten Mal nicht mehr geglaubt"* — und die teurere Folge: *„Der Fehlalarm formt den Text um, den er prüfen soll."* Eine Zeile, die die richtige Nummer nennt **und** ihre Vorgänger aufzählt, ist die normale Schreibweise dieses Projekts, nicht ein Sonderfall. |
| **Behebung** | siehe Abschnitt „Repariert". |

---

## Fund 7 — `ist_standaussage()` schließt zu weit aus

| | |
|---|---|
| **Fund** | Die Ausschlussliste `Vorgänger\|damals\|bis dahin\|stand hier\|zuvor\|ehemals` wirkt auf die **ganze Zeile**. Eine Lüge, in der das Wort *„zuvor"* irgendwo vorkommt, wird nicht mehr angesehen. |
| **Ort** | `tools/pruefe-release-buchfuehrung.pl:149` |
| **Gemessen** | siehe Gegentest GT-7 unten. |
| **Bewertung** | Derselbe Mechanismus wie bei `pruefe-behoben-belegt.pl` im Nachtrag vom 17.09.2026 zu `schranke-gegentesten.md`: ein Wort im Umfeld entscheidet, nicht die Aussage. Und die Wörter sind im Projekt häufig — `tools/RELEASES.md` selbst benutzt *„zuvor"* in der Zeile zu v1.0.50. |
| **Behebung** | siehe Abschnitt „Repariert". |

---

## Fund 8 — `pruefe-stand-md.pl` vergleicht nur Datum gegen Datum

| | |
|---|---|
| **Fund** | Die Rollenhistorien werden nur über ihr **Datum** geprüft. Trägt die letzte Überschrift dasselbe Datum wie der Commit auf den Bericht, ist die Frage beantwortet — auch wenn der Bericht in der Datei nicht vorkommt. |
| **Ort** | `tools/pruefe-stand-md.pl`, Abschnitt „2. Rollenhistorien" |
| **Gemessen** | Bestand am 18.09.2026: `LEKTORAT.md` nennt **13 von 14** Berichten; **`LEKTOR-15` fehlt**. `PRUEFBERICHT.md` erklärt sich als abgeschlossen und ist zu Recht ausgenommen. Die alte Fassung meldete beides grün. |
| **Bewertung** | Ein Datum ist eine Behauptung über Aktualität, die Nennung des Berichts ist der Beleg — `Arbeitsweise/anzeige-ist-kein-zustand.md`. |
| **Behebung** | Jeder Bericht aus `Befunde/<ROLLE>-*.md` muss in der Historie vorkommen; der Umfang kommt aus dem Dateibestand (`Arbeitsweise/pruefumfang-nicht-von-hand.md`). Gegenprobe umgedreht gefahren: mit nachgetragenem `LEKTOR-15` meldet die Prüfung *„(keine) → grün"*. |

---

## Fund 9 — der Prüfstand zu `pruefe-branch.pl` war rot, und niemand hat es gemerkt

| | |
|---|---|
| **Fund** | `tools/pruefe-branch-tests.pl` meldete **`ROT: d`**. Der Testfall erwartete für einen Commit direkt auf `main` *„auf main - in Ordnung"* und Rückgabe **0**. |
| **Ort** | `tools/pruefe-branch-tests.pl`, Fall `d` |
| **Gemessen** | Der Fall ist auch mit der Fassung **aus `HEAD`** rot — nachgemessen, indem ich `git show HEAD:tools/pruefe-branch.pl` in den Baum gelegt und die Sammlung noch einmal gefahren habe. Er ist also nicht durch meine Änderung entstanden. |
| **Bewertung** | **Der Test war falsch, nicht die Schranke.** Gregor am 05.09.2026: *„keine direkten aenderungen am main branch."* Die Schranke weist seither jeden direkten Commit auf `main` ab — richtig so; der Testfall ist dabei stehengeblieben. Ein dauerhaft roter Prüfstand meldet dasselbe wie ein kaputter, nämlich nichts (`Arbeitsweise/pruefstand-kann-blind-sein.md`), und `schranke-gegentesten.md` Punkt 5 verlangt, das als **falschen Test** zu benennen. |
| **Behebung** | Fall `d` auf `erwartet => 1` und das heutige Muster gezogen, mit der Begründung im Quelltext. **15 von 15 Fällen grün.** |

---

## Fund 10 — die Zweignamen-Regel gibt es, sie meldet — und wird nicht gelesen

| | |
|---|---|
| **Fund** | Für *„Zweigname mit Gregor abgestimmt"* gibt es **schon** eine Ablage (`tools/ZWEIGE.md`) und eine Prüfung (`pruefe-branch.pl`, Schluss). Sie **meldet** nur, bewusst. |
| **Ort** | `tools/pruefe-branch.pl:353-389`, `tools/ZWEIGE.md` |
| **Gemessen** | Der Zweig, auf dem diese Arbeit läuft — **`schranken-vor-dem-commit`** — steht **nicht** in `tools/ZWEIGE.md`. Die Meldung lief also bei jedem Commit dieser Sitzung mit und hat nichts bewirkt. |
| **Bewertung** | Die Begründung für „nur meldend" ist gut und steht in `ZWEIGE.md` selbst: eine Schranke, die jeden Commit auf einem neuen Zweig blockiert, wird umgangen. Trotzdem ist der Befund eindeutig: **ein Hinweis, der in 22 Sekunden Hakenausgabe untergeht, ist kein Auslöser.** |
| **Behebung** | Neuer Schalter `--streng`: beim **Commit** weiterhin nur melden, beim **Push** abweisen. Ein Zweig, der auf den Server geht, soll gemergt werden; spätestens da muss der Name vereinbart sein. Lokales Arbeiten bleibt frei. Gegenprobe in beide Richtungen am echten Zweig gefahren: ohne `--streng` → 0, mit `--streng` → 1, nach einem Probeeintrag in `ZWEIGE.md` → 0 (Eintrag danach byte-genau zurückgenommen, `cmp` gegen die Sicherung). |

---

## Fund 11 — `release-pruefen.pl` warf Hinweis und Mangel in einen Topf, und das war die Ursache des `|| true`

| | |
|---|---|
| **Fund** | Das Werkzeug gab auch für einen bloßen **HINWEIS** (QCSSL-Quellen neuer als die ausgelieferte DLL) den Wert **1** zurück — genauso wie für ein echtes Missverhältnis bei Fassung oder Prüfsumme. |
| **Ort** | `tools/release-pruefen.pl:97` (`$fehler = 1;` im Zweig, dessen eigener Text mit `HINWEIS:` beginnt) |
| **Gemessen** | Lauf am 18.09.2026: Rückgabe **1**, Ausgabe *„HINWEIS: 1 Commit(s) haben die QCSSL-Quellen geaendert …"*. Ein echter Fehler lag nicht vor. |
| **Bewertung** | **Das erklärt das `|| true` im Haken.** Die Schranke war dauernd rot, also wurde sie entwaffnet — und konnte danach auch das echte Missverhältnis nicht mehr abweisen. Genau der Schaden, den `Arbeitsweise/schranke-gegentesten.md` beschreibt, hier im Haken selbst. Den Haken „einfach scharf zu schalten", ohne diese Ursache zu beheben, hätte ihn binnen eines Tages wieder umgangen. |
| **Behebung** | Getrennte Rückgabewerte: **0** = stimmt, **1** = Missverhältnis (weist ab), **3** = nur Hinweis (läuft durch). Beide Haken werten das aus. Gegenprobe: jetziger Baum → **3**; mit künstlich falscher Prüfsumme → **1**. |

---

## Fund 12 — der `pre-commit` braucht 22 Sekunden

| | |
|---|---|
| **Fund** | Gemessener Lauf des eingerichteten `pre-commit`: **22,1 s**. |
| **Ort** | `.git/hooks/pre-commit` |
| **Gemessen** | Die vier neu eingehängten Doku-Schranken machen davon **1,2 s** aus (352 + 233 + 134 + 513 ms), die beiden ganz neuen weitere 0,6 s. Die teuersten Posten sind vorher da: `doku-pruefen.pl` 2534 ms, `pruefe-branch.pl` 1049 ms, `release-pruefen.pl` 988 ms, `rollen-faellig.pl` 928 ms, `pruefe-behoben-belegt.pl` 1149 ms, dazu rund zwanzig Perl-Starts. |
| **Bewertung** | Kein Fund über meine Arbeit, aber der wichtigste Risikoposten für alles, was hier gebaut wurde: *„eine lästige Schranke wird umgangen"* steht im Haken selbst als Begründung dafür, `pruefe-testbau.pl` in den `pre-push` zu legen. 22 s je Commit ist die Schwelle, ab der `--no-verify` attraktiv wird. |
| **Behebung** | **Nicht behoben** — siehe „Was offen bleibt". |

---

## Was ich repariert habe

| Werkzeug | Änderung | Gegentest |
|---|---|---|
| `tools/pruefe-release-buchfuehrung.pl` | Prüfung je **Satz** statt je Zeile; Absatz erbt die Nummer seiner Überschrift; Aufzählung der Vorgänger entlastet, wenn die aktuelle Nummer im Satz steht; Rückblick-Wortliste ersetzt durch Zitatblock + datierte Protokollzeile; Umfang 0 weist ab | `--tests` **19/19**; gegen `8da72c8` **7 Mängel** (alle fünf Dokumente), gegen den Arbeitsbaum **1 Mangel** (die echte Lüge), vorher 7 Fehlalarme |
| `tools/pruefe-befund-verbreitung.pl` | Umfang zusätzlich aus `BEFUNDE.md` (*behoben in* der Fassung aus `Version.h`); Umfang 0 weist ab | `--tests` **9/9**; gegen den echten Stand 7.2.0.70 gefahren: vorher grün, jetzt rot |
| `tools/pruefe-behoben-belegt.pl` | Muster `\*\*([^*]{1,80})\*\*` → `\*\*([^*]+)\*\*`; Prüfumfang in der Ausgabe; `--datei` mit 0 Befundzeilen weist ab | `--selbsttest` **12/12** (zwei neue Fälle); Gegenprobe des Musters gemessen |
| `tools/pruefe-anzeigetext.pl` | Prüfumfang in der Ausgabe; `--datei` mit 0 Befundzeilen weist ab | `--selbsttest` **7/7**; leere Datei → 1, Diff ohne `BEFUNDE.md` → 0 |
| `tools/pruefe-stand-md.pl` | Rollenhistorie muss **jeden** Bericht ihrer Rolle nennen, nicht nur ein Datum tragen | Bestand: `LEKTOR-15` fehlt; Gegenprobe umgedreht → grün |
| `tools/release-pruefen.pl` | Rückgabe **3** für den Hinweis, **1** nur für ein echtes Missverhältnis | jetziger Baum → 3; falsche Prüfsumme → 1 |
| `tools/pruefe-branch.pl` | `--streng`: Zweigname, der nicht in `ZWEIGE.md` steht, weist beim Push ab | 3 Läufe, beide Richtungen; `pruefe-branch-tests.pl` **15/15** |
| `tools/pruefe-branch-tests.pl` | Fall `d` auf den Stand seit 05.09.2026 gezogen (falscher Test, nicht stumme Schranke) | vorher 14/15, jetzt **15/15** |
| `tools/pruefe-fassungsnummer.pl` | **neu** — `VERSION`, `Version.h`, `PAKETE.md` und Tag-Bestand gegeneinander; Doppelvergabe statt Lückenlosigkeit | `--tests` **11/11**, darunter der erlaubte Fall 1.0.70/1.0.71; Arbeitsbaum grün, 37 Einzelprüfungen |
| `tools/pruefe-behoben-ausgeliefert.pl` | **neu** — bestätigtes „behoben" gegen die Versionsressource der ausgelieferten `Eudora.exe` | `--tests` **11/11**; 21 Pakete gemessen, Leseweg gegen PowerShell gegengeprüft |
| `tools/hooks-einrichten.sh` | alle oben genannten in `pre-commit` **und** `pre-push`, `\|\| true` raus | beide Haken `sh -n` sauber, neu eingerichtet und gefahren |
| `tools/WERKZEUGE.md` | drei neue Zeilen, die überholte „bekannte Grenze" berichtigt | `doku-pruefen.pl` 0, `pruefe-bytes.pl` 0 |

**Verdrahtung nachgemessen** (`grep` über die eingerichteten Haken):

| Schranke | pre-commit | pre-push |
|---|---|---|
| `pruefe-release-buchfuehrung.pl` | ja, abweisend | ja, abweisend |
| `pruefe-befund-verbreitung.pl` | ja, abweisend | ja, abweisend |
| `pruefe-doku-takt.pl` | ja, abweisend | ja, abweisend |
| `pruefe-stand-md.pl` | ja, abweisend | ja, abweisend |
| `pruefe-fassungsnummer.pl` | ja, abweisend | ja, abweisend |
| `pruefe-behoben-ausgeliefert.pl` | ja, abweisend | ja, abweisend |
| `release-pruefen.pl` | ja, abweisend außer Rückgabe 3 | ja, abweisend außer Rückgabe 3 |
| `offene-befunde.pl` | ja, meldend | — |
| `pruefe-branch.pl --streng` | meldend (ohne `--streng`) | ja, abweisend |

Alle über die `schranke()`-Hilfsfunktion, also Befund X-8 gewahrt: fehlt ein
Werkzeug in diesem Arbeitsbaum, wird es übersprungen und gemeldet.

---

## Achtung — die Haken weisen jetzt ab, und drei Dinge sind offen

Das ist kein Nebeneffekt, sondern der Zweck. Aber wer als nächstes committen
oder pushen will, läuft hier hinein:

| Wo | Was die Schranke sagt | Was zu tun ist |
|---|---|---|
| **`pre-commit`** | `Releases/PAKETE.md:323 gibt 1.0.28 als aktuellen Stand aus, veroeffentlicht ist 1.0.72` | Die Zeile *„**Die aktuelle Fassung, und die einzige, die als Paket im Repo liegt.**"* steht unter `## 1.0.29`. Sie ist seit 43 Fassungen falsch. Umformulieren, z. B. *„Die Fassung, deren ZIP noch im Repo liegt."* |
| **`pre-commit`** | `LEKTORAT.md nennt 1 von 14 Berichten des LEKTOR nicht: LEKTOR-15` | eine Zeile in `LEKTORAT.md` — gehört LEKTOR, ich habe sie nicht angefasst |
| **`pre-commit`** | `'## Noch offen (Stand 17.09.2026)' ist aelter als der juengste Vorgang im CHANGELOG (18.09.2026)`, dazu vier Stand-Köpfe auf 17.09. | `pruefe-doku-takt.pl` und `pruefe-stand-md.pl`; entsteht dadurch, dass LEKTOR gerade einen 18.09.-Abschnitt geschrieben hat. Stand-Köpfe nachziehen |
| **`pre-push`** | `ABGEWIESEN: 'schranken-vor-dem-commit' steht nicht in tools/ZWEIGE.md.` | eine Zeile in `tools/ZWEIGE.md` — **mit Gregors Zitat**, nicht von mir erfunden |

Ich habe diese vier **nicht selbst geschlossen**: drei liegen in `.md`-Dateien,
an denen LEKTOR parallel arbeitet, und der vierte braucht Gregors Wortlaut.

---

## Was offen bleibt, und warum

1. **Die Laufzeit des `pre-commit` (22 s)** ist nicht angefasst. Sie war vorher
   schon bei rund 21 s; meine sechs Schranken kosten 1,8 s. Der richtige
   Schnitt wäre, die quelltextlesenden Schranken (`pruefe-fensterbau`,
   `pruefe-beenden`, `pruefe-nachrichtenschleife`, `pruefe-fenster-ziehen`,
   `pruefe-leistengroessen-paar`, `pruefe-filter-*`) nur laufen zu lassen, wenn
   der Commit `Eudora71/` anfasst. **Das ist aber genau der `if`, der am
   07.09.2026 aus dem Haken entfernt wurde**, weil eine veraltete unveränderte
   Datei in keinem Diff steht (`Arbeitsweise/review-sieht-nur-den-diff.md`).
   Für Quelltext-Schranken gilt dieses Argument nicht in derselben Schärfe wie
   für Doku-Schranken — aber das ist eine Entscheidung, die ich nicht allein
   treffe.

2. **`pruefe-befundurteile.pl`** hat nach E-109 dasselbe `{1,80}`-Muster wie
   `pruefe-behoben-belegt.pl`. Ich habe es **nicht** geändert: es steht in
   keinem der beiden Haken, und eine Änderung ohne Gegentest an seiner eigenen
   Testsammlung wäre genau der Fehler, den dieser Bericht anderswo benennt.
   Der Fund ist belegt und gehört in denselben Arbeitsgang wie die
   Wiedereinhängung dieses Werkzeugs.

3. **Prüfung A von `pruefe-release-buchfuehrung.pl`** (Fund 5) ist weiterhin
   ein Grobfilter. Der Ausgabetext sagt das jetzt, der Quelltext erklärt es —
   geschärft ist sie nicht. Prüfung B trägt die Arbeit.

4. **Die 72 alten „behoben"-Zeilen ohne Beleg** in `BEFUNDE.md`
   (`--datei`-Lauf: 171 Befundzeilen, 107 behoben, 35 mit Beleg) bleiben
   Bestand. Der Haken prüft bewusst nur den Zuwachs; eine Schranke, die
   siebzigmal meckert, wird abgeschaltet.

5. **Kein Test der Haken gegen einen echten `git commit`.** Ich habe beide
   Haken direkt mit `sh` gefahren und ihre Rückgabewerte gemessen, aber keinen
   Commit und keinen Push ausgelöst — das war mir untersagt und ist richtig so.
   Was ich **nicht** gemessen habe: ob `git` selbst den Rückgabewert so
   auswertet, wie ich annehme. Das ist für `pre-commit` seit dem 31.08.2026
   im Repo belegt (Befund X-1/X-2), für den neuen Rückgabewert **3** aber
   nicht — er wird im Haken abgefangen und erreicht `git` nie, also hängt
   daran nichts.

