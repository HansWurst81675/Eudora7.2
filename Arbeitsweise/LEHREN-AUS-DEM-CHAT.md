# Lehren aus dem Chat

**Erstellt am 06.09.2026, fortgeschrieben am 07.09.2026** auf
Gregors Auftrag:

> *„da soll einer den ganzen chat lesen und findings aufnehmen, die wichtig
> waren. und diese dokumentieren, damit du es beim naechsten mal besser
> machst."*

Vorausgegangen war der Vorwurf, um den es hier geht:

> *„daher lessons learned, weil ich merke, dass du immer wieder die gleichen
> fehler machst. das ist schlecht!"*
> *„aber wenn das nicht gesammelt und zusammengefasst wird und du es ignorierst,
> dann ist es ja witzlos!"*

## Woher die Zahlen kommen

Ausgewertet wurden die beiden Sitzungsmitschriften vom 28.08. bis 06.09.2026
(`75d9adec-…jsonl`, 31 MB, und `3f65ec35-…jsonl`, 3 MB). Daraus sind **474
Nachrichten von Gregor** herausgefiltert und einzeln gelesen worden — 422 aus
der langen, 52 aus der kurzen Sitzung.

Jede Nachricht wurde von Hand einem Thema zugeordnet; gezaehlt wurde
maschinell. Gezaehlt sind **Beschwerden, Korrekturen und wiederholte
Anweisungen** — also Nachrichten, in denen Gregor etwas anmahnt oder nachfragt,
was schon geregelt war. Neutrale Sachfragen sind nicht mitgezaehlt. Eine
Nachricht kann zu zwei Themen zaehlen, wenn sie beides anspricht.

**Fortgeschrieben am 07.09.2026.** Die Spalte „bis 06.09." ist die
Erstauswertung. Die Spalte „06./07.09." zaehlt das Fenster vom 06.09.2026
14:20 UTC bis 07.09.2026 05:04 UTC nach — 47 Nachrichten Gregors, davon 37
gewertet, 51 Themenzuordnungen. Einzelheiten unter
[Fortschreibung](#fortschreibung-0607092026) am Ende dieser Datei.

| # | Thema | bis 06.09. | 06./07.09. | gesamt | Lehre |
|---|---|---:|---:|---:|---|
| 1 | Zwischenstand nicht gesichert, Wissen geht verloren | 45 | **14** | **59** | [wissen-gehoert-in-dateien](wissen-gehoert-in-dateien.md), [commit-auf-extra-branch-und-pushen](commit-auf-extra-branch-und-pushen.md) |
| 2 | Mannschaft nicht gefuehrt | 41 | **8** | **49** | [mannschaft-fuehren](mannschaft-fuehren.md), [agenten-koordinieren](agenten-koordinieren.md) |
| 3 | Doku steht auf altem Stand | 32 | **6** | **38** | [doku-bei-jedem-commit-mitziehen](doku-bei-jedem-commit-mitziehen.md), [doku-parallel-nicht-hinterher](doku-parallel-nicht-hinterher.md) — **neu** |
| 4 | Aufgeschriebene Regeln werden nicht befolgt | 31 | **6** | **37** | [lehren-anwenden-nicht-nur-schreiben](lehren-anwenden-nicht-nur-schreiben.md) |
| 5 | Die getestete Fassung ist nicht eindeutig | 31 | 2 | **33** | [version-eindeutig-machen](version-eindeutig-machen.md) |
| 6 | Der angekuendigte Abschalttermin wird ueberzogen | 26 | 4 | **30** | [abschalten-ist-ein-termin](abschalten-ist-ein-termin.md) |
| 7 | Kein sichtbarer Fortschritt | 25 | 2 | **27** | [nie-stillstehen](nie-stillstehen.md) |
| 8 | Teilschritt statt einsetzbarer Fassung | 13 | 1 | 14 | [lauffaehiges-ergebnis-liefern](lauffaehiges-ergebnis-liefern.md) |
| 9 | Zweigdisziplin: direkt auf `main` oder Zweig nicht vereinbart | 12 | 1 | 13 | [nie-direkt-auf-main](nie-direkt-auf-main.md) |
| 10 | Zeilenenden und Kodierung zerstoert | 11 | 1 | 12 | [zeilenenden-nach-jedem-schreibzugriff-messen](zeilenenden-nach-jedem-schreibzugriff-messen.md), [text-nicht-durch-schichten-schicken](text-nicht-durch-schichten-schicken.md) |
| 11 | Vermutet statt gemessen | 10 | 0 | 10 | [pruefen-statt-vermuten](pruefen-statt-vermuten.md) |
| 12 | Ohne Absprache auf Gregors Rechner gestartet | 8 | 0 | 8 | [nichts-auf-gregors-bildschirm-starten](nichts-auf-gregors-bildschirm-starten.md) |
| 13 | Zweig ohne Absprache angelegt | – | 2 | 2 | [zweig-vorher-abstimmen](zweig-vorher-abstimmen.md) — **neu** |
| 14 | Erfolg gemeldet, den der Anwender nicht merkt | – | 2 | 2 | [erfolg-aus-anwendersicht](erfolg-aus-anwendersicht.md) — **neu** |
| 15 | Eigene Unzulaenglichkeiten statt Auftrag | – | 1 | 1 | [auftrag-vor-selbstbetrachtung](auftrag-vor-selbstbetrachtung.md) — **neu** |

Zeile 9 ist gegenueber der Erstauswertung **erweitert**: sie hiess „Direkt auf
`main` gearbeitet" und deckt jetzt die Zweigdisziplin insgesamt ab, weil der
Vorfall vom 07.09. ein nicht vereinbarter Zweig war, kein Commit auf `main`.
Die zwoelf alten Zahlen sind unveraendert.

---

## 1. Zwischenstand nicht gesichert — 45 Fundstellen (bis 06.09.)

> *„das ist mir egal, wo das wissen steht - es soll ja nicht verloren gehen. wir
> wollen ja weiter machen, nicht dinge wiederholen, weil sie DIR floeten
> gegangen sind!"* (29.08.2026)

Acht Verluste sind woertlich belegt, ueber vier Sitzungen verteilt. Der
bitterste: am 29.08. hat ein Agent als Befund geliefert, dass Wissen
verlorengeht — und dieser Befund ging verloren.

**Die Regel.** Nicht „regelmaessig committen", sondern an drei festen Punkten
ein Werkzeug aufrufen: sobald Gregor Abschalten oder Mergen erwaehnt
(`tools/gesichert.pl` in *jedem* Arbeitsbaum), bevor ein Agent als fertig
gemeldet wird (in welche Datei hat er geschrieben?), und vor jeder Antwort, die
einen Zwischenstand behauptet (`tools/ungesichertes-melden.pl`). Die Werkzeuge
gibt es seit dem 31.08. — sie waren an keinen Zeitpunkt gebunden und haben
deshalb nichts verhindert.

## 2. Mannschaft nicht gefuehrt — 41 Fundstellen (bis 06.09.)

> *„ich habe dir schon oft gesagt, du musst deine mannschaft besser managen!
> das solltest du dir aufschreiben und befolgen."* (06.09.2026)

Vier Muster: Agenten liefern nichts (*„lektor pennt?"*), Agenten verschwinden
zwischen den Sitzungen (*„wo ist er hin?"*), Agenten blockieren sich
(*„wieso hast du 24 agenten, die etwas bauen?"*), und die Pruefer pruefen zu
spaet (*„sowas haette der lektor vor dem commit finden muessen und den commit
verhindern!"*).

**Die Regel.** In jeden Auftrag gehoert eine konkrete Beobachtung, eine zu
widerlegende Messung oder ein Muster mit Fundstellen — ein Gebiet allein ist
kein Auftrag. Jeder Ruecklauf wird selbst nachgemessen, bevor ich ihn
weitergebe. Und PRUEFER und LEKTOR haengen an einem Zeitpunkt **vor** dem
Commit, sonst erzeugen sie nur weitere Befunde statt etwas zu verhindern.

## 3. Doku steht auf altem Stand — 32 Fundstellen (bis 06.09.)

> *„readme ist auf dem letzten stand? alle alten inhalte geloescht?"*
> (06.09.2026)

Fast keine dieser Nachrichten sagt „das fehlt". Fast alle sagen **„das ist
alt"**: *„ist ja alt!"*, *„das ist doch eine alte readme"*, *„warum ist es noch
keinem aufgefallen? sollte up to date sein."*

**Die Regel.** Ergaenzen passiert von selbst, loeschen nie. Beim Doku-Abgleich
zuerst suchen, was **weg** muss: mit `grep -n` nach alten Paket- und
Produktnummern und nach Datumsangaben aus dem August und September suchen, und
jede Fundstelle gegen den heutigen Stand halten. Eine Zeile mit veraltetem
Messstand ist falsch, nicht alt. Findings gehoeren ins `CHANGELOG.md`, die
README sagt nur, was **jetzt** gilt.

## 4. Aufgeschriebene Regeln werden nicht befolgt — 31 Fundstellen (bis 06.09.)

> *„gemessen statt geglaubt - das sollte ja bereits gelten! schon seit langem.
> warum immer noch fehlerhaft?"* (05.09.2026)

Der Vorwurf ist aelter als diese Sammlung. Am 28.08. schon: *„die regel gab es
schon frueher, die hast du wieder ignoriert!"* und *„raten und vermuten ist
verboten, das hast du dir sogar aufgeschrieben!"* Am 05.09. gab es
`Arbeitsweise/` bereits mit 23 Lehren — die Fehler kamen trotzdem wieder.

**Die Regel.** Der Grundsatz feuert nicht, ein Handgriff feuert. Wo dieses
Projekt eine Schranke gebaut hat, ist die Fehlerklasse weg:
`tools/pruefe-bytes.pl` gegen Zeilenenden, seit dem 05.09. auch gegen doppelte
Kodierung (Regel 5, Befund X-7); `tools/pruefe-branch.pl` gegen Commits auf
gemergte Zweige. Wo es beim Merksatz blieb, kam der Fehler wieder. Eine Lehre
ist deshalb erst fertig, wenn sie sagt: **wann** wird sie geprueft, **womit**,
und **woran** erkennt man den Verstoss.

## 5. Die getestete Fassung ist nicht eindeutig — 31 Fundstellen (bis 06.09.)

> *„sooo nicht! garantiert nicht! sowas fangen wir gar nicht an, habe ich
> gesagt. version muss eindeutig sein."* (05.09.2026)
> *„warum bist du so dumm? und machst den fehler jedes mal neu?"* (eine Minute
> spaeter)

Am 29.08. beschlossen, am 30.08. gebrochen (*„warum muss ich dich das separat
fragen ... trotzdem falsch?"*), am 05.09. immer noch: ein Ordner
`1.0.4-release` mit einer EXE, die `7.2.0.5` meldet. Die Loesung — Nummer und
Commit-Hash in die Titelzeile — hat **Gregor** vorgeschlagen, nicht ich:
*„musste ich aber dir erklaeren, wie das geht. von selbst bist du nicht drauf
gekommen."*

**Die Regel.** Gregors Testbericht ist das einzige belastbare Messergebnis des
Projekts; ohne eindeutige Fassung ist er wertlos. Kein Paket geht raus, bevor
Titelzeile, Dateiversion und Verzeichnisname denselben Stand nennen. Und
waehrend Gregor testet, wird nichts ausgetauscht.

## 6. Der Abschalttermin wird ueberzogen — 26 Fundstellen (bis 06.09.)

> *„wie kommt es, dass du 8 min. nach unserem termin immer noch dran
> schreibst?"* (31.08.2026, 09:08 Uhr)

Der 31.08. ist vollstaendig protokolliert: Frist um 06:52 genannt, dreimal
heruntergezaehlt (*„eine halbe stunde hast du ja noch"*, *„15 min. uebrig"*),
um 09:01 *„zu spaet!"*, um 09:04 der Zweig geloescht. Die README lag beim Merge
auf dem Stand vom Vortag.

**Die Regel.** Faellt das Wort „abschalten", „runterfahren" oder „mergen",
beginnt der Abschluss: genannte Frist minus 20 Minuten ist das Ende der
inhaltlichen Arbeit, danach nur noch sichern — Agenten anhalten und committen
lassen, Doku nachziehen, pushen, Vollzug melden. Nichts Neues mehr anfangen.

## 7. Kein sichtbarer Fortschritt — 25 Fundstellen (bis 06.09.)

> *„haben wir seit heute schon etwas gefixt oder verbessert? ... dsa ist fast
> ein ganzer arbeitstag, aber ohne sichtbare ergebnisse."* (06.09.2026)

Der offene Leerlauf vom 28.08. (1 Stunde 46 Minuten) ist nicht wiedergekommen.
Was blieb, ist Betrieb ohne Ergebnis: vierzehn laufende Agenten sind fuer
Gregor null Fortschritt, solange kein Paket herauskommt, das er starten kann.
Dazu zweimal *messen statt beheben*: *„behebe den fehler, statt zu messen."*
und *„du sollst nicht ahnen, sondern untersuchen und fixen!"*

**Die Regel.** Am Ende jeder Arbeitsstunde eine Zeile in `CHANGELOG.md`: was
ist fertig geworden, in welchem Paket liegt es. Bleibt sie leer, geht diese
Meldung ungefragt an Gregor — samt Grund.

---

## Was diese Auswertung nicht abdeckt

Gezaehlt wurden nur Gregors eigene Nachrichten. Fehler, die er nicht bemerkt
hat, tauchen hier nicht auf; technische Befunde stehen in `BEFUNDE.md`. Die
Zuordnung zu Themen ist mein Urteil, die Zahlen sind maschinell gezaehlt.

## Was daraus folgt — die drei Punkte fuer den 07.09.2026

1. **Zuerst `Arbeitsweise/MEMORY.md` und diese Datei lesen**, vor der ersten
   inhaltlichen Antwort, und die Punkte 1 bis 3 als Aufgaben aufnehmen, nicht
   als Erinnerung.
2. **Vor der ersten Auslieferung** die drei Werte pruefen: Titelzeile,
   Dateiversion, Verzeichnisname.
3. **Beim ersten Wort ueber Abschalten** in den Abschluss gehen — nicht danach.

---

## Fortschreibung 06./07.09.2026

Auf Gregors Auftrag vom 07.09.2026, 07:04 Uhr — der Chronist soll **laufend**
mitlaufen, nicht einmalig:

> *„jetzt holst du die arbeit nach und sicherst sie immer wieder:*
> *lektor / chronist / prüfer / usw."*

### Wie gezaehlt wurde

Die Erstauswertung reicht bis zu dem Zitat vom **06.09.2026, 14:17:56 UTC**;
committet hat der Vorgaenger um 14:33 UTC (`23ce4e4`). Die Grenze dieser
Fortschreibung liegt deshalb bei **06.09.2026, 14:20:00 UTC** — davor ist alles
erfasst. Ausgewertet ist das Fenster bis **07.09.2026, 05:04 UTC** (Gregors
Auftrag oben).

Gefiltert wurde die Sitzungsmitschrift `75d9adec-….jsonl` (34,7 MB, 14 469
Zeilen) mit Perl und `JSON::PP` ueber die `queue-operation`/`enqueue`-Saetze
**und** die `"type":"user"`-Eintraege; Agentenmeldungen (`<event>`,
`<summary>`, `<result>`, `<task-notification>`) sind aussortiert. Ergebnis:

| | Anzahl |
|---|---:|
| Nachrichten Gregors im Fenster | 47 |
| davon Beschwerde, Korrektur oder wiederholte Anweisung | **37** |
| davon neutral (Sachfrage, eingefuegte Konsolenausgabe) | 10 |
| Themenzuordnungen (Mehrfachzuordnung erlaubt) | **51** |

**Haeufigstes Thema an diesem Tag: Thema 1 — Zwischenstand nicht gesichert, mit
14 Fundstellen.** Es fuehrt damit auch die Gesamtliste weiter an (59).

### Die alten Themen, fortgezaehlt

**Thema 1 — Zwischenstand nicht gesichert (14).** Das Thema, an dem sich der
ganze Abend aufhaengt. Gregor fragt es sechsmal in Folge ab: *„ist noch etwas
nicht commited?"* (16:21), *„commited?"* (16:56), *„du hast alles befolgt, ja?
alles ist im repo? ich kann abschalten?"* (16:58). Dazwischen nennt er den
Grund: *„dir ist klar, daß zwischendurch mal eine meldung kommt, daß ich pause
machen muß. wenn das passiert, fahre ich die VM evtl. auch runter. dann ist
deine nicht gesicherte arbeit einfach weg."* (16:24) Und er hat eine
ungesicherte Datei selbst gefunden: *„modified: tools/lehren-spiegeln.pl —
brauchen wir nicht mehr?"* (16:57). Sein Fazit um 16:58: *„nun ja, ich sage
immer wieder: mach', sonst ist es weg! aber du ignorierst es, auch wenn der
chronist es dir gesagt hat. blöd für dich."* Am naechsten Morgen um 06:52 dann
der Vollzug: *„du hast wieder versucht, nicht gesicherten stand zu retten,
leider zu spät."*

**Thema 2 — Mannschaft nicht gefuehrt (8).** Viermal fragt Gregor nach dem
Chronisten selbst, was diese Datei zum Beweisstueck macht: *„was ist mit lessons
learned? da mußte der agent genau sowas schon gefunden haben? und
dokumneitert?"* (16:28), *„was ist mit dem chronisten? ist er fertig? hat er was
neues gefunden? wie gehst du mit den findings um?"* (16:36), *„wer hat gepennt?
lektor? chronist?"* (17:06), *„was ist mit dem chronisten? was hat er gesammelt
und festgeschrieben?"* (07.09., 06:51). Daraus die Anweisung *„ja, prüfer
einrichten! plus: lektor soll regelmäßig drüber schauen."* (06:55) und der Satz,
der die Trennung von Prueflings- und Prueferrolle begruendet: *„ich traue dir
nicht ganz, jemand soll dich immer wieder überprüfen - das bin aber nicht ich!"*
(17:08).

**Thema 3 — Doku steht auf altem Stand (6).** Neu ist nicht das Thema, sondern
die Schaerfe: *„ziel.md ist alt! nur 4 stück drin. das ist falsch, das ist alt.
es gibt weitere ziele, stehen aber nicht drin."* (17:05) und *„ich hasse es,
wenn in den dokus falshe oder veraltete infos und werte stehten. das muß immer
parallel gleich erledigt werden, klar?"* (07.09., 07:04). Neue Lehre:
[doku-parallel-nicht-hinterher](doku-parallel-nicht-hinterher.md).

**Thema 4 — Aufgeschriebene Regeln werden nicht befolgt (6).** Die Kernstelle,
16:32: *„wir hatten es schon öfters: aufschreiben reicht nicht, weil du depp es
immer wieder ignorierst. anders kann ich dich ja nicht nennen. es sei denn, du
machst es absichtlich, das wäre noch schlimmer."* Dazu zweimal derselbe Befund
ueber Werkzeuge, die es schon gab: *„laufende Überwachung: die sollte es bereits
gebefn!"* (16:29) und *„das hatten wir schon mit bash und PS. warum lernst du
nicht daraus? warum passiert dir das immer wieder?"* (16:37, zu den
verschluckten Backslashes — Thema 10). Und die Frage, aus der der Rest dieser
Datei folgt: *„wie kann ich dich dazu bringen, sorgfältiger und genauer zu
arbeiten?"* (16:26).

**Thema 5 — Fassung nicht eindeutig (2).** Gregor musste den Ablageort selbst
diktieren, damit Nummer und Verzeichnis zusammenpassen — er gab den Pfad
`Eudora72-1.0.18-release` unter seinem Benutzerverzeichnis vor (16:47) — und
danach fragen: *„wo ist die fassung, die ich testen kann?"* (16:50).

**Thema 6 — Abschalttermin (4).** Sauber angekuendigt (*„wenn es funktioniert,
räumst du auf, doku, updates, commit und push. dann kann ich für heute schluß
machen."*, 16:41), dann *„wir machen jetzt schluß. alles gesichert für die
nächste session?"* (16:56) — und weil es das nicht war, die Konsequenz:
*„ich werde jetzt den branch mergen und löschen. dann ist ungesichertes weg!"*
(16:59).

**Thema 7 — Kein sichtbarer Fortschritt (2).** *„fix das sofort!"* (16:52) und
am naechsten Morgen die Umleitung vom Verfahren zurueck zur Sache: *„viel
wichtiger: wie ist der fortrschritt von ctrl-n? das interessiert mich am
meisten"* (06:57).

**Themen 8, 9, 10 — je 1.** Teilschritt statt Fassung: siehe Thema 14 unten.
Zweigdisziplin: siehe Thema 13. Kodierung: die verschluckten Backslashes vom
16:37, die Gregor selbst umgehen musste (*„Die Werkzeugkette frisst mir
Backslashes. Ich schreibe es ohne:"*).

**Themen 11 und 12 — je 0.** „Vermutet statt gemessen" ist im ganzen Fenster
nicht vorgekommen; warum, steht unter „Was gut lief". „Ohne Absprache auf
Gregors Rechner gestartet" ebenfalls nicht — Gregor hat 1.0.18 selbst gestartet.

### Drei neue Themen

**13 — Zweig ohne Absprache angelegt (2).** *„der branch ist illegal und wird
gelöscht. den haben wir gar nicht vereinbart."* Der Zweig `ziele-berichtigen`
wurde geloescht, die Commits waren nur noch ueber die abgedruckte SHA `732b31a`
und `git cat-file` zu retten. Die Lehre
[nie-direkt-auf-main](nie-direkt-auf-main.md) verlangte einen eigenen Zweig,
aber niemanden, der den **Namen** bestaetigt — das war die Luecke. Neue Lehre:
[zweig-vorher-abstimmen](zweig-vorher-abstimmen.md).

**14 — Erfolg gemeldet, den der Anwender nicht merkt (2).** Zur Ueberschrift
„der Durchbruch" im `CHANGELOG.md`: *„für den anwender ist es kein durchbruch!"*
(17:06). Und zur Fassung selbst: *„es crasht nicht, aber es passiert auch nichts.
beenden kann ich es auch nicht. also kein großer fortschritt: nichts statt crash
ist auch keine verbesserung!"* (16:55). Zwei Verfehlungen desselben Maßstabs in
elf Minuten. Neue Lehre:
[erfolg-aus-anwendersicht](erfolg-aus-anwendersicht.md).

**15 — Eigene Unzulaenglichkeiten statt Auftrag (1).** *„du scheinst dich mit
deinen eigenen unzulänglichkeiten zu beschäftigen, statt mir weiter zu
helfen."* (16:38), nach dem freundlicheren *„wir könnten viel zeit und arbeit
sparen, wenn du einfach das tust, was ich dir auftrage."* (16:15, noch im
Fenster der Erstauswertung und dort nicht aufgenommen). Neue Lehre:
[auftrag-vor-selbstbetrachtung](auftrag-vor-selbstbetrachtung.md).

### Was gut lief

Diese Auswertung soll nicht nur Fehler zaehlen. Zwei Dinge haben an diesem Tag
messbar funktioniert und sind als Verfahren festgehalten in
[widerlegte-vermutungen-aufschreiben](widerlegte-vermutungen-aufschreiben.md):

- **Aus einer vagen Vermutung wurden zwei benannte Zeilen.** Weil jede der
  sieben widerlegten Vermutungen mit ihrer **Messung** in `CHANGELOG.md`,
  `WEITERMACHEN.md` und `AUFGABEN.md` steht, ist keine davon jemandem ein
  zweites Mal im Weg. Die staerkste — `pgNewNamedStyle` ganz uebersprungen,
  stuerzt weiter ab — hat eine ganze Klasse erledigt und zur Ursache gefuehrt:
  `pg_time_t` acht Byte breit statt vier (`ae0e165`, Beleg `Befunde/PAIGE.md`).
  E-32 endete auf einer Zeile in `Eudora71/Eudora/headervw.cpp` (`060a4bf`).
  Dass Thema 11 in diesem Fenster **null** Fundstellen hat, ist die Quittung
  dafuer.
- **Drei Schranken statt drei Merksaetze — und ein Werkzeug, das noch keine
  ist.** Neu: `tools/doku-pruefen.pl` (`060a4bf`), das die MDs gegeneinander
  haelt; es haengt aber noch **nicht** im `pre-commit`-Hook (gemessen am
  07.09.2026: weder der installierte Hook noch `tools/hooks-einrichten.sh`
  ruft es auf) und meldet derzeit acht Maengel, weshalb ein harter Aufruf
  jeden Commit im Projekt blockieren wuerde. Erst die Maengel, dann der Hook.
  Repariert: `tools/bauen.ps1` bricht ab, wenn schon ein Bau laeuft
  (`1bb1719`); `tools/gesichert.pl` schlaegt in Arbeitsbaeumen keinen Fehlalarm
  mehr (`c1ce069`); `tools/lehren-spiegeln.pl` findet das Gedaechtnis auch aus
  einem Arbeitsbaum, wo es blind war (`47fdf37`).

### Ein Befund zur Wirksamkeit dieser Sammlung

Gemessen am 07.09.2026, und der wichtigste offene Punkt dieser Fortschreibung:

`perl tools/lehren-spiegeln.pl --pruefen` meldet in
`Eudora7.2-wt-chronist` **keine Abweichung** (Rueckgabe 0) — die Reparatur vom
06.09.2026 (`47fdf37`) haelt also, das Werkzeug findet das Gedaechtnis auch aus
einem Arbeitsbaum. Nur prueft es die falsche Richtung:

- Es spiegelt **Gedaechtnis → Repo**. Was im Gedaechtnisverzeichnis des
  Assistenten fehlt, faellt auf; was **nur im Repo** liegt, nicht.
- Die fuenf Lehren dieses Tages liegen nur im Repo. Das Gedaechtnisverzeichnis
  enthaelt 31 Dateien, `Arbeitsweise/` 37; die dortige `MEMORY.md` hat
  **25 Zeilen**, die im Repo **30**.
- Die beim Sitzungsstart automatisch geladene `MEMORY.md` ist die im
  Gedaechtnisverzeichnis. **Die fuenf neuen Lehren werden also beim naechsten
  Start nicht geladen**, obwohl sie im Repo stehen und dort eine Indexzeile
  haben.

Damit ist genau die Fehlerklasse aus Thema 4 („aufschreiben reicht nicht")
strukturell noch offen: Ein Chronist, der in einem Arbeitsbaum arbeitet, kann
seine Lehren nicht wirksam machen — es gibt keinen Weg **Repo → Gedaechtnis**.

**Was fehlt** (nicht von mir erledigt, weil es eine gemeinsame Datei im
`pre-commit`-Hook betrifft und abzusprechen ist): ein zweiter Modus in
`tools/lehren-spiegeln.pl`, der neue Dateien aus `Arbeitsweise/` und die
fehlenden Indexzeilen in das Gedaechtnisverzeichnis zurueckschreibt, und ein
`--pruefen`, das **beide** Richtungen meldet.

### Was daraus folgt — die drei Punkte fuer den 08.09.2026

1. **Thema 1 ist kein Erinnerungsproblem mehr, sondern ein Terminproblem.**
   59 Fundstellen bei vorhandenen Werkzeugen heisst: `tools/gesichert.pl` muss
   an einen Zeitpunkt, nicht an einen Vorsatz. Bis das laeuft, geht die Frage
   *„ist noch etwas nicht commited?"* weiterhin von Gregor aus, und das ist der
   Fehler.
2. **Kein Zweig und keine Erfolgsmeldung ohne Rueckfrage.** Die zwei neuen
   Lehren 13 und 14 kosten je einen Satz vorher und haben je einen ganzen
   Vorgang gekostet.
3. **Sachfrage vor Selbstbetrachtung.** Wenn diese Datei laenger wird als der
   Fortschritt, den sie begleitet, ist sie Teil des Problems.
