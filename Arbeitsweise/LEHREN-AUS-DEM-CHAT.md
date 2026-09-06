# Lehren aus dem Chat

**Erstellt am 06.09.2026** auf Gregors Auftrag:

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

| # | Thema | Fundstellen | Lehre |
|---|---|---:|---|
| 1 | Zwischenstand nicht gesichert, Wissen geht verloren | **45** | [wissen-gehoert-in-dateien](wissen-gehoert-in-dateien.md), [commit-auf-extra-branch-und-pushen](commit-auf-extra-branch-und-pushen.md) |
| 2 | Mannschaft nicht gefuehrt | **41** | [mannschaft-fuehren](mannschaft-fuehren.md), [agenten-koordinieren](agenten-koordinieren.md) |
| 3 | Doku steht auf altem Stand | **32** | [doku-bei-jedem-commit-mitziehen](doku-bei-jedem-commit-mitziehen.md) |
| 4 | Aufgeschriebene Regeln werden nicht befolgt | **31** | [lehren-anwenden-nicht-nur-schreiben](lehren-anwenden-nicht-nur-schreiben.md) — **neu** |
| 5 | Die getestete Fassung ist nicht eindeutig | **31** | [version-eindeutig-machen](version-eindeutig-machen.md) — **neu** |
| 6 | Der angekuendigte Abschalttermin wird ueberzogen | **26** | [abschalten-ist-ein-termin](abschalten-ist-ein-termin.md) — **neu** |
| 7 | Kein sichtbarer Fortschritt | **25** | [nie-stillstehen](nie-stillstehen.md) |
| 8 | Teilschritt statt einsetzbarer Fassung | 13 | [lauffaehiges-ergebnis-liefern](lauffaehiges-ergebnis-liefern.md) |
| 9 | Direkt auf `main` gearbeitet | 12 | [nie-direkt-auf-main](nie-direkt-auf-main.md) |
| 10 | Zeilenenden und Kodierung zerstoert | 11 | [zeilenenden-nach-jedem-schreibzugriff-messen](zeilenenden-nach-jedem-schreibzugriff-messen.md) |
| 11 | Vermutet statt gemessen | 10 | [pruefen-statt-vermuten](pruefen-statt-vermuten.md) |
| 12 | Ohne Absprache auf Gregors Rechner gestartet | 8 | [nichts-auf-gregors-bildschirm-starten](nichts-auf-gregors-bildschirm-starten.md) |

---

## 1. Zwischenstand nicht gesichert — 45 Fundstellen

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

## 2. Mannschaft nicht gefuehrt — 41 Fundstellen

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

## 3. Doku steht auf altem Stand — 32 Fundstellen

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

## 4. Aufgeschriebene Regeln werden nicht befolgt — 31 Fundstellen

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

## 5. Die getestete Fassung ist nicht eindeutig — 31 Fundstellen

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

## 6. Der Abschalttermin wird ueberzogen — 26 Fundstellen

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

## 7. Kein sichtbarer Fortschritt — 25 Fundstellen

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

## Was daraus folgt — die drei Punkte fuer die naechste Sitzung

1. **Zuerst `Arbeitsweise/MEMORY.md` und diese Datei lesen**, vor der ersten
   inhaltlichen Antwort, und die Punkte 1 bis 3 als Aufgaben aufnehmen, nicht
   als Erinnerung.
2. **Vor der ersten Auslieferung** die drei Werte pruefen: Titelzeile,
   Dateiversion, Verzeichnisname.
3. **Beim ersten Wort ueber Abschalten** in den Abschluss gehen — nicht danach.
