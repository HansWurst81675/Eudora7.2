# LEKTOR-14 — der Bestand nach 1.0.70 (17.09.2026, abends)

**Stand 17.09.2026.** Zweig `wt/lektor-1070`, Grundlage `origin/main`
(`ceab98f`), Arbeitsbaum `Eudora7.2-wt-lektor-1070`. Vorgänger:
[LEKTOR-13.md](LEKTOR-13.md), [LEKTOR-12.md](LEKTOR-12.md),
[LEKTOR-11.md](LEKTOR-11.md).

Auftrag von Gregor, wörtlich: *„readme, changelog, befunde sind up to date?
lass' mal wieder pruefer und lektor drueber laufen."*

Geprüft wurde gegen den **Bestand**, nicht gegen den Diff
([review-sieht-nur-den-diff.md](../Arbeitsweise/review-sieht-nur-den-diff.md)).
Umfang aus der Quelle
([pruefumfang-nicht-von-hand.md](../Arbeitsweise/pruefumfang-nicht-von-hand.md)):
`git ls-files '*.md'` — **153 Dateien**.

> **Eine Besonderheit dieses Durchgangs.** Der Quellstand **7.2.0.70** /
> `VERSION` **1.0.70** war beim Prüfen **noch nicht committet**; er lag als
> Arbeitskopie im Hauptbaum auf `paketliste-glattziehen`. Gemessen habe ich
> deshalb an der Arbeitskopie (das ist der Bestand, den Gregor sieht),
> berichtigt aber auf einem Zweig von `origin/main` — und nur an Stellen, die
> der parallele Lauf **nicht** anfasst. Was in seinen Zeilen liegt
> (`CHANGELOG.md`, `tools/ZWEIGE.md`, `Releases/PAKETE.md`), steht hier als
> **Befund zur Übergabe**, nicht als Berichtigung.

---

## Die Grundlage: was wirklich in welchem Paket steckt

Der Auftrag nannte die Fassungszuordnung als teuersten Fund aus L-11 und L-13.
Ich habe sie deshalb nicht aus einer MD abgeschrieben, sondern **gemessen** —
an der Produktversion und dem Zeitstempel jeder `Eudora.exe` und an der
Vorfahrenschaft der Behebungscommits (`git merge-base --is-ancestor`).

| Paket | `Eudora.exe` | Produktversion | Stand beim Bau |
|---|---|---|---|
| 1.0.65 | 17.09., 09:08:48 | 7.2.0.65 | — |
| 1.0.67 | 17.09., **18:58:58** | 7.2.0.67 | — |
| 1.0.68 | 17.09., 20:18:38 | 7.2.0.68 | — |
| 1.0.69 | 17.09., **20:24:54** | 7.2.0.69 | `acc8ad7` (20:21:59) |
| 1.0.70 | 17.09., 21:18:31 | 7.2.0.70 | nach `ceab98f` (21:10:18) |

Und die Behebungen mit ihrer Uhrzeit:

| Behebung | Commit | Zeit | Quellstand |
|---|---|---|---|
| E-101, erster Teil | `38bb52c` | 14:10 | **7.2.0.66** |
| E-103 | `ca3d6b1` | 16:02 | **7.2.0.67** |
| E-104, erste Hälfte | `eed2e4e` | **16:08:52** | 7.2.0.67 |
| E-104, zweite Hälfte | `6b36c83` | **18:59:55** | 7.2.0.68 |
| E-106 | `0334a6c` | **20:16:00** | **7.2.0.68** |
| E-101, zweiter Teil | `e27ccf1` | **20:58:43** | **7.2.0.69** |

**Daraus folgt dreierlei, und alle drei stehen heute falsch in den MDs.**

---

## L-14.1 — die Tabelle im CHANGELOG-Abschnitt 7.2.0.70 hat die Zeile zu 1.0.69 vertauscht

**Das ist der teuerste Fund des Durchgangs**, weil Gregor **1.0.69** auf der
Platte hat und **1.0.70 nicht** (gemessen: `C:\Users\Gregor\` trägt
`Eudora72-1.0.65/-1.0.67/-1.0.68/-1.0.69-release`, kein `-1.0.70-release`).

| | |
|---|---|
| **Behauptung** | `CHANGELOG.md`, Abschnitt 7.2.0.70: *„1.0.69 \| 7.2.0.69 \| **enthält** E-101 **zweiter Teil**, P-38 \| **es fehlt** E-106"* |
| **Gemessen** | **Beide Hälften sind vertauscht.** Die `Eudora.exe` von 1.0.69 ist um **20:24:54** entstanden, aus dem Stand `acc8ad7` (20:21:59). Der E-106-Merge `0334a6c` (20:16:00) **ist Vorfahr davon** — E-106 **ist** in 1.0.69. Der zweite Teil von E-101 (`e27ccf1`) entstand um **20:58:43**, also **34 Minuten nach dem Bau** — er ist **nicht** darin |
| **Gegenprobe im eigenen Haus** | Der Abschnitt **7.2.0.69** derselben Datei sagt es bereits richtig: *„sein `1.0.69` trug sie noch nicht"*. Die neue Tabelle widerspricht dem Abschnitt zwanzig Zeilen weiter unten |
| **Was es kostet** | Gregor liest die Tabelle, sucht in seinem 1.0.69 nach der `E-101 speichern:`-Zeile mit `Content-Type` — und findet sie nicht, weil sie dort nicht sein kann. Umgekehrt hält er E-106 für ungetestet, obwohl genau sein 1.0.69 der Lauf wäre, der es belegen könnte |
| **Berichtigt** | **nein** — die Zeile liegt im uncommitteten Abschnitt des parallelen Laufs. **Zur Übergabe**, siehe unten |

## L-14.2 — dieselbe Unwahrheit über die Veröffentlichung stand in zwei weiteren Dateien

| | |
|---|---|
| **Behauptung** | `WEITERMACHEN.md:24`: *„Auf GitHub veröffentlicht ist weiterhin `v1.0.50`; **1.0.51 bis 1.0.68 sind nicht freigegeben**."* Dieselbe Aussage in `PORTIERUNG.md:49`: *„**Veröffentlicht** ist bei GitHub `v1.0.50` (13.09.2026)."* |
| **Gemessen** | `gh release list`: **`v1.0.64`**, 2026-09-17T10:23:08Z, als *Latest* markiert. `git ls-remote --tags origin`: `refs/tags/v1.0.64` (`1d37623`) |
| **Warum das schwerer wiegt als ein veralteter Wert** | **L-13.1 hat diese Unwahrheit am selben Tag gefunden und für erledigt erklärt.** Der Vermerk in `AUFGABEN.md` sagt: *„Dieselbe Unwahrheit stand in `WEITERMACHEN.md`, `Releases/PAKETE.md`, `README.md` und `tools/RELEASES.md` — fünf Dokumente, ein Irrtum."* In `WEITERMACHEN.md` stand sie danach **weiter**, und `PORTIERUNG.md` war in keinem der beiden Vermerke genannt. Es waren **sechs** Dokumente, und **zwei** blieben stehen |
| **Die Klasse** | Ein Berichtigungsvermerk ist selbst eine Behauptung. Niemand prüft ihn nach, weil er wie ein Beleg aussieht ([anzeige-ist-kein-zustand.md](../Arbeitsweise/anzeige-ist-kein-zustand.md)) |
| **Berichtigt** | **ja** — `WEITERMACHEN.md:24` und `PORTIERUNG.md:43-50` neu geschrieben, dazu ein Nachtrag am Vermerk in `AUFGABEN.md`, der die Nachmessung festhält |

## L-14.3 — „zuletzt gebaut" hing zwei Fassungen zurück und behauptete, es gebe kein Paket

| | |
|---|---|
| **Behauptung** | `WEITERMACHEN.md:24`: *„Quellstand **7.2.0.68** / `VERSION` **1.0.68** … **Ein Paket dazu ist noch nicht geschnürt** — unter `Releases/` liegt zuletzt das Verzeichnis `Eudora72-1.0.65-release`, das letzte ZIP ist `Eudora72-1.0.64-release.zip`."* Dasselbe in `AUFGABEN.md:57-61`, `PORTIERUNG.md:43`, `ZIEL.md:17` |
| **Gemessen** | Unter `Releases/` liegen die Verzeichnisse `Eudora72-1.0.67-release`, `-1.0.68-release` und `-1.0.70-release` sowie das ZIP `Eudora72-1.0.70-release.zip` (9 356 792 Byte, 17.09., 21:19). Gebaut ist **7.2.0.70** |
| **Zusatz** | Dieselbe Zelle in `WEITERMACHEN.md` widersprach der **Kopftabelle derselben Datei**, die zwei Zeilen darüber 7.2.0.70 / 1.0.70 nennt. Ein Widerspruch innerhalb einer Datei, sechs Zeilen auseinander |
| **Berichtigt** | **ja**, in allen vier Dateien |

## L-14.4 — vier Befunde standen unter der falschen Fassung, in fünf Dateien

Die Ersetzungsklasse aus L-11 und L-13, diesmal in die andere Richtung: alles
wurde auf **7.2.0.68** gezogen, weil das die Nummer war, als der Block
geschrieben wurde.

| Befund | stand als | ist | stand in |
|---|---|---|---|
| **E-101** | 7.2.0.68 bzw. 7.2.0.67 | **7.2.0.66** (erster Teil), **7.2.0.69** (zweiter Teil) | `AUFGABEN.md`, `README.md`, `ZIEL.md`, `BEFUNDE.md`, `WEITERMACHEN.md` |
| **E-103** | 7.2.0.68 | **7.2.0.67** | `AUFGABEN.md`, `README.md`, `WEITERMACHEN.md` |
| **E-104** | 7.2.0.68 bzw. nur 7.2.0.67 | **7.2.0.67** (verfasste) **und 7.2.0.68** (empfangene Nachricht) | `AUFGABEN.md`, `README.md`, `BEFUNDE.md` |
| **E-106** | 7.2.0.68 | **7.2.0.68** — richtig | — |

**Warum das nicht Kosmetik ist:** `WEITERMACHEN.md` schickt Gregor zur
Prüfanleitung *„in `CHANGELOG.md`, Abschnitt 7.2.0.68"*. Der Abschnitt 7.2.0.68
handelt von **E-106**. Wer dort die Anleitung zu E-101 oder E-103 sucht, findet
die eines fremden Befunds — genau der Schaden, den L-16 und L-17 schon
beschrieben haben.

**Berichtigt:** `AUFGABEN.md`, `README.md`, `ZIEL.md`, `BEFUNDE.md`
(E-101 und E-104), `PORTIERUNG.md`. **Nicht berichtigt:** die
Verweise auf *„Abschnitt 7.2.0.68"* in `WEITERMACHEN.md:12/18` — sie liegen
neben den Zeilen des parallelen Laufs; siehe Übergabe.

## L-14.5 — E-106 steht überall ehrlich als *nicht nachgewiesen*

Das war die ausdrückliche Frage im Auftrag. **Keine Fundstelle behauptet etwas
anderes.** Gemessen über alle 153 MDs:

| Datei | Wortlaut |
|---|---|
| `BEFUNDE.md:265` | *„**gebaut in 7.2.0.68, bei Gregor noch nicht nachgewiesen.**"* |
| `WEITERMACHEN.md:11` | *„**bei mir nicht nachweisbar** — mein Prüfstand lädt die Bilder nicht (null Ladespuren, während Gregors Protokoll 27 hat). **Nur sein Lauf kann es belegen.**"* |
| `AUFGABEN.md:48` | *„ist gebaut, aber **bei Gregor noch nicht nachgewiesen**"* |
| `README.md:90` | *„bei Gregor noch nicht nachgewiesen"* |
| `CHANGELOG.md:67-73` | *„**Bleibt die Zeile aus, ist auch diese Ursache widerlegt.**"* |
| `ZIEL.md:17` | nannte E-106 in der Liste des Gebauten, **ohne** den Vorbehalt — **ergänzt** |

Ein einziger Nachtrag also, und der ist kein Widerspruch, sondern eine
Auslassung. Das ist das beste Ergebnis, das dieser Punkt haben konnte.

## L-14.6 — `LEKTORAT.md` kannte den eigenen jüngsten Durchgang nicht

| | |
|---|---|
| **Behauptung** | *„Der jüngste Durchgang ist **L-17** und steht in `Befunde/LEKTOR-12.md`"* und *„Der jüngste Durchgang **in dieser Datei** ist weiterhin der **neunte**, ganz unten."* |
| **Gemessen** | `Befunde/LEKTOR-13.md` existiert seit 15:39 Uhr desselben Tages (`260eb4d`) und kommt in `LEKTORAT.md` **kein einziges Mal** vor. Und die Datei selbst trägt Überschriften bis *„Sechzehnter Durchgang — 17.09.2026 (L-16)"* (Zeile 907), während Zeile 8 *„der dreizehnte bis fünfzehnte"* sagt. Drei Angaben, drei Fehler |
| **Dazu ein Nummernproblem** | Ab `LEKTOR-13.md` tragen die Funde die Nummer der **Berichtsdatei** (`L-13.1`), die Durchgänge in `LEKTORAT.md` die des **Durchgangs** (`L-13` = 14.09.2026). Die Vermerke in `README.md`, `AUFGABEN.md` und `tools/RELEASES.md` sagen *„(LEKTOR, L-13.1)"* und meinen die Datei. Das ist jetzt im Kopf von `LEKTORAT.md` festgehalten |
| **Berichtigt** | **ja**, Kopf neu geschrieben, Eintrag zu diesem Durchgang angelegt |

## L-14.7 — die neue Schranke fehlte in `tools/WERKZEUGE.md`

`pruefe-befund-verbreitung.pl` ist am 17.09.2026 entstanden und war die
**einzige** der 76 Dateien unter `tools/`, die in `tools/WERKZEUGE.md` nicht
vorkam (gemessen: jede `tools/*.pl` und `tools/*.ps1` gegen die Datei). Die
Lehre [werkzeug-vor-eigenbau.md](../Arbeitsweise/werkzeug-vor-eigenbau.md)
lebt davon, dass diese Liste vollständig ist. **Berichtigt**, samt der Grenze
aus L-14.8. Der Stand-Kopf der Datei hing auf 7.2.0.67 und steht jetzt auf
7.2.0.70.

## L-14.9 — zwei tote Verweise, von L-13 gefunden und nicht behoben

`Arbeitsweise/agenten-koordinieren.md:13` zeigt auf `[AGENTEN.md](AGENTEN.md)`
und `Befunde/LEKTOR-5.md:483` zeigte auf `[ZIEL.md](ZIEL.md)`; aus einem
Unterverzeichnis lösen beide auf nicht vorhandene Dateien auf. **L-13 hat beide
gemessen und beschrieben** — behoben wurden sie nicht. Von **500** geprüften
Verweisen über alle 153 MDs sind das die einzigen zwei; die vier weiteren
Treffer meines Prüfers (`Befunde/LEKTOR-13.md:32/114/115`) sind **Zitate** der
beiden Fehler und des Suchmusters `….md` — gemessene Fehlalarme.

`Befunde/LEKTOR-5.md:483` ist auf `../ZIEL.md` gesetzt. **Der andere lässt sich
hier nicht beheben, und das ist der eigentliche Fund:** `Arbeitsweise/` ist ein
**Spiegel** des Gedächtnisverzeichnisses
(`~/.claude/projects/<Projekt>/memory/`, gespiegelt von
`tools/lehren-spiegeln.pl`). Mein Commit-Versuch hat es gezeigt — der
Vorcommit-Haken hat die Datei aus der Quelle **neu geschrieben und meine
Berichtigung dabei zurückgenommen**:

```
Arbeitsweise/ wurde aktualisiert (1 Datei(en)):
  agenten-koordinieren.md
Der Commit wurde abgebrochen.
```

**Folge:** jede Berichtigung an einer `Arbeitsweise/`-Datei ist wirkungslos,
solange sie nicht an der **Quelle** geschieht. Das gehört in
`Arbeitsweise/README.md` gesagt — und wer den Verweis richtigstellen will,
ändert `agenten-koordinieren.md` im Gedächtnisverzeichnis auf
`[AGENTEN.md](../AGENTEN.md)`. Das habe ich **nicht** getan: das
Gedächtnisverzeichnis gehört Gregor, nicht diesem Zweig.

---

## Die Schranken: welche stumm blieb

Alle acht angeordneten Schranken und die neue neunte wurden gefahren, im
Hauptbaum gegen den wirklichen Stand 7.2.0.70. **Alle neun blieben still.**

| Schranke | Meldung | hätte sie L-14.1 … L-14.4 sehen können? |
|---|---|---|
| `doku-pruefen.pl` | „Kein Widerspruch gefunden", 24 Dateien | nein — prüft Fassungsnummern gegeneinander, nicht Befund gegen Fassung |
| `pruefe-doku-takt.pl` | „Die Fassung ist beschrieben" | nein |
| `pruefe-stand-md.pl` | „Kein Stand-Kopf hinkt hinterher", 5 Dateien | **nein — und das ist L-14.8** |
| `offene-befunde.pl` | „Die Liste deckt die offenen Befunde", 12 | nein |
| `lehren-schranken.pl` | 70 Lehren, alle gedeckt | nein |
| `pruefe-befundurteile.pl` | 12 offen / 70 behoben | nein — prüft *offen gegen behoben*, nicht *Fassung gegen Fassung* |
| `pruefe-behoben-belegt.pl` | „geprueft (neu oder geaendert) **0**" | nein — prüft nur den Zuwachs. **Und sie hat auch meinen eigenen Zuwachs nicht gesehen: L-14.10** |
| `pruefe-anzeigetext.pl` | „gepruefte Zeilen **0**" | nein — prüft nur den Zuwachs |
| `pruefe-befund-verbreitung.pl` | **„Der neueste CHANGELOG-Abschnitt nennt keinen Befund - nichts zu pruefen"** | **nein — und das ist L-14.8** |

### L-14.8 — die neue Schranke war bei ihrem ersten echten Lauf blind

Das ist der Fund, den der Auftrag als den wertvollsten bezeichnet hat: eine
Schranke, die still bleibt, während von Hand etwas zu finden ist.

**`pruefe-befund-verbreitung.pl`** liest die Kennungen aus den
**Überschriften** des jüngsten `CHANGELOG`-Abschnitts. Das ist eine bewusste,
im Kopf der Datei begründete Entscheidung — der zweite Entwurf las den
Fließtext und zählte Querverweise mit, drei Fehlalarme. Der Abschnitt
**7.2.0.70** hat aber drei Überschriften, und in keiner steht eine Kennung:

```
## 7.2.0.70 — ein vollständiger Stand zum Testen, und die Paketliste wieder geradegezogen
### Warum es zwei Fassungsnummern 1.0.68 gab
### Was in welchem Paket steckt
```

Die vier Befunde, um die es in der Fassung geht — **E-101, E-103, E-104,
E-106** — stehen im Fließtext und in einer Tabelle. Die Schranke meldete
*„nichts zu pruefen"* und war damit **beim ersten echten Lauf nach ihrem Bau
wirkungslos**.

**Der Fehler liegt nicht im Werkzeug, sondern zwischen Werkzeug und Text:** die
Schranke setzt eine Überschriftenform voraus, die nirgends verlangt ist. Zwei
Wege stehen offen, und ich schlage den ersten vor:

1. **Die Schranke merkt an, wenn der jüngste Abschnitt keine Kennung in der
   Überschrift trägt**, statt *„nichts zu pruefen"* zu melden — eine Fassung
   ohne Befund gibt es, aber sie ist die Ausnahme und gehört gesagt.
2. Eine Regel, dass jeder `## 7.2.0.x`-Abschnitt seine Befunde in der
   Überschrift nennt. Alle anderen 56 Abschnitte tun das bereits.

**Ebenso stumm: `pruefe-stand-md.pl` bei L-14.6.** Es misst das **Datum** der
letzten Rollenüberschrift gegen den jüngsten Bericht der Rolle. Beide standen
auf dem 17.09.2026, also grün — obwohl die Überschrift zu einem **anderen**
Bericht gehörte als der jüngste. Das Datum ist zu grob; verglichen werden
müsste der **genannte Berichtsname**.


### L-14.10 — ein zu langes Urteil macht einen behobenen Befund lautlos wieder offen

**Gefunden an der eigenen Berichtigung**, durch die Gegenprobe
([gegenprobe-umdrehen.md](../Arbeitsweise/gegenprobe-umdrehen.md)): nicht
prüfen, ob die Schranke grün meldet, sondern ob sie den **eigenen Zuwachs
überhaupt sieht**.

Nach meiner ersten Fassung von L-14.4 lautete das Urteil zu **E-101**:

```
| E-101 | … | **behoben in 7.2.0.66 (erster Teil) und 7.2.0.69 (zweiter Teil),
am laufenden Programm geprüft, von Gregor noch nicht bestätigt.** Von Gregor …
```

`pruefe-behoben-belegt.pl` meldete daraufhin **„geprueft (neu oder geaendert)
0"** — bei zwei geänderten Urteilszeilen im gestageten Diff. Nachgestellt:

```
KOPF: [Gemessen an seiner Datei]              erledigt=0
KOPF: [ Von Gregor am 17.09.2026 an 1.0.65 …] erledigt=0
```

**Die Ursache** steht in `pruefe-behoben-belegt.pl:120` und wortgleich in
`pruefe-befundurteile.pl`: das Urteil ist der **erste Fettdruck** der dritten
Spalte, gefunden mit `\*\*([^*]{1,80})\*\*`. Wird der Fettdruck **länger als
80 Zeichen**, greift das Muster dort nicht mehr — es greift beim **nächsten**
Fettdruck derselben Zelle. Aus `**behoben in …**` wurde so `**Gemessen an
seiner Datei**`, und der Befund galt als **offen**.

**Das ist keine Kleinigkeit.** Dieselbe Regel entscheidet in
`offene-befunde.pl` und `pruefe-befundurteile.pl`, was offen und was behoben
ist. Ein Urteil, das jemand ausführlicher schreibt, verschwindet damit
lautlos aus der Zählung — und niemand merkt es, weil beide Werkzeuge weiter
grün melden: sie zählen den Befund einfach in der anderen Spalte.

**Sofort abgestellt** habe ich es, indem der Fettdruck beider Zeilen unter 80
Zeichen bleibt (`**behoben in 7.2.0.66 und 7.2.0.69, am laufenden Programm
geprüft.**`, 64 Zeichen) und die Einzelheiten dahinter stehen. Danach:

```
geprueft (neu oder geaendert)  2
mit Beleg                      2
  E-101    am laufenden Programm
  E-104    am laufenden Programm
```

**Vorschlag für die Klasse:** das Muster nicht am **Zeichenzähler** enden
lassen, sondern am **Zellenende** — `\*\*([^*|]+?)\*\*` trifft denselben
ersten Fettdruck ohne Obergrenze. Wer die Grenze braucht, meldet einen
**überlangen Fettdruck** als Mangel, statt still zum nächsten zu springen.

---

## Zur Übergabe an den parallelen Lauf (`paketliste-glattziehen`)

Diese fünf Stellen liegen in den Zeilen, an denen der parallele Lauf gerade
arbeitet. Ich habe sie **nicht** angefasst
([auftrag-darf-nicht-loeschen.md](../Arbeitsweise/auftrag-darf-nicht-loeschen.md)).

| Stelle | Was zu ändern ist |
|---|---|
| `CHANGELOG.md`, Tabelle im Abschnitt 7.2.0.70, Zeile **1.0.69** | **enthält: E-106, P-38** — **es fehlt: E-101 zweiter Teil.** Genau umgekehrt zum jetzigen Stand, Messung in L-14.1 |
| `CHANGELOG.md`, dieselbe Tabelle, Zeile **1.0.67** | *„es fehlt: E-104"* stimmt nur für die **zweite Hälfte** (`6b36c83`, 18:59:55). Die erste (`eed2e4e`, 16:08:52) ist in 1.0.67 drin — die Exe entstand um 18:58:58 |
| `CHANGELOG.md`, Abschnitt 7.2.0.70, Absatz zum Protokollkanal | *„der Protokollkanal war **nicht** abgeschaltet — `LogLevel=58527` ist `0xE49F` und enthält `0x8000` sehr wohl"* widerlegt den Abschnitt 7.2.0.69 nicht: **der hat `LogLevel 25759 (0x649F)` aus Gregors Protokoll gemessen**, und `0x649F & 0x8000 = 0`. Beide Aussagen können stimmen, sie reden über verschiedene Läufe. Der Schlusssatz *„Die Behebung war dort schlicht noch nicht drin"* ist **richtig und gemessen** (L-14.1) — er trägt die Erklärung allein |
| `tools/ZWEIGE.md:70` | Der Zweig `p38-spurmarke-rumpf` steht jetzt als *„Quellstand **7.2.0.70**, Paketnummer **1.0.70**"*. Er hat **7.2.0.69 / 1.0.69** gebracht — der CHANGELOG-Abschnitt 7.2.0.69 trägt seinen Namen, und `ceab98f` ist sein Merge. **Das ist die Ersetzungsklasse aus L-11 und L-13:** eine Ersetzung `69 → 70` hat eine Angabe über die **Vergangenheit** mitgenommen |
| `WEITERMACHEN.md:12` und `:18` | verweisen auf *„`CHANGELOG.md`, Abschnitt 7.2.0.68"* für **E-103** bzw. **E-101**. Richtig sind **7.2.0.67** (E-103) und **7.2.0.66 / 7.2.0.69** (E-101) |

**Und eine Sache, die kein Dokumentfehler ist, aber Gregor betrifft:**
`1.0.70` ist das erste vollständige Paket — bei ihm liegt es **nicht**. Auf
seiner Platte stehen 1.0.65, 1.0.67, 1.0.68 und 1.0.69. Solange das so ist,
läuft jede Prüfanleitung, die 1.0.70 voraussetzt, ins Leere.

---

## Was geprüft wurde und still blieb

| Prüfung | Ergebnis |
|---|---|
| **Verweise** `[…](….md)` über alle 153 MDs | **500** geprüft, **2** echte Fehler (L-14.9): einer behoben, einer nur an der Quelle des Spiegels zu beheben |
| **Werkzeuge gegen `tools/WERKZEUGE.md`** | 76 Dateien, **1** fehlte (L-14.7) |
| **E-106 als „nachgewiesen" oder „behoben"** | **keine einzige Stelle** — siehe L-14.5 |
| **Offene Befunde** | 12 offen / 70 behoben laut `BEFUNDE.md`; `WEITERMACHEN.md` deckt alle 12; kein Dokument erklärt einen offenen für erledigt |
| **Kriterien in `ZIEL.md`** | neun, sieben belegt (0, 1, 3, 5, 6, 7, 8), zwei fast (2, 4) — `WEITERMACHEN.md` und `PORTIERUNG.md` sagen dasselbe |
| **Testzahl** | **171/171**, belegt im CHANGELOG-Abschnitt 7.2.0.69 und in `BEFUNDE.md:262`. Die führenden Dokumente nannten **169**, `PORTIERUNG.md` sogar **160** — berichtigt |
| **Zeilenenden nach jedem Schreibzugriff** | jede geänderte Datei einzeln gemessen, **CR=0** durchgehend |

## Was ich bewusst stehen gelassen habe

* **`EINSTELLUNGEN.md` und `FILTER.md`** tragen *„Stand 7.2.0.68 / Paket
  1.0.68. Geprüft gegen diesen Quellstand."* Das ist **kein** falscher Wert,
  sondern eine wahre Aussage über den Zeitpunkt der Prüfung. `doku-pruefen.pl`
  meldet sie unter *Zur Kenntnis*, nicht als Widerspruch — richtig so.
* **Die Durchgangsabschnitte in `LEKTORAT.md`** unterhalb des Kopfes. Die
  Datei ist ausdrücklich ein Fahrtenbuch; jeder Abschnitt gilt für seinen Tag.
  Berichtigt wurde nur, was sich als **heutige** Aussage ausgibt.
* **Die vier alten Zitate ohne Herkunft** in `BEFUNDE.md` (E-16, E-33, E-34,
  E-47), die `pruefe-anzeigetext.pl` im Bestand kennt und deshalb nur im
  Zuwachs prüft.

---

## Nachtrag, 17.09.2026 nach dem Commit — 1.0.71 ist dazwischengekommen

Während dieser Bericht entstand, hat der parallele Lauf weitergearbeitet:
`7d555df` bringt **7.2.0.71 / 1.0.71** und **E-107** — *„Absturz beim
Antworten auf eine geöffnete Nachricht"*. Drei Dinge folgen daraus, und das
erste ist der wichtigste Satz dieses Berichts.

### 1. Gregors Absturz belegt L-14.1 unabhängig

`BEFUNDE.md` zu **E-107**: *„**Der Fehler war meiner**, eingebaut mit
**E-106** wenige Stunden zuvor. **Von Gregor am 17.09.2026 um 21:23 an
1.0.69 gemeldet**."*

**Wenn Gregor den E-106-Absturz an 1.0.69 erlebt hat, dann ist E-106 in
1.0.69.** Genau das habe ich aus Zeitstempel und Vorfahrenschaft gemessen —
und genau das bestreitet die Tabelle im CHANGELOG-Abschnitt 7.2.0.70 bis
heute (`CHANGELOG.md:143`): *„1.0.69 … **es fehlt E-106**"*. Die Zeile ist
damit **zweifach widerlegt**: durch die Messung und durch Gregors eigenen
Lauf. **Sie steht noch da.**

### 2. „1.0.70 enthält alles" ist jetzt gefährlich, und keine MD sagt es

`CHANGELOG.md:144` sagt weiterhin *„**1.0.70** | 7.2.0.70 | **alles** | —"*
und der Abschnittskopf nennt es *„ein vollständiger Stand zum Testen"*.
**1.0.70 enthält E-106 und damit den Absturz aus E-107.** Wer der Anleitung
folgt — Kleinanzeigen-Nachricht öffnen, weiterleiten — ist einen Klick vom
*Antworten* entfernt. Behoben ist es erst in **7.2.0.71**.

**Zu tun:** in derselben Tabelle hinter 1.0.70 *„enthält den Absturz E-107"*,
und die Prüfanleitung auf **1.0.71** ziehen. Bei Gregor liegt 1.0.71 bereits
(`C:\Users\Gregor\Eudora72-1.0.71-release`, gemessen) — **1.0.70 dagegen nie**.

### 3. Die Ersetzungsklasse aus L-14.4 hat innerhalb einer Stunde zugeschlagen

`tools/ZWEIGE.md:73` sagt jetzt: der Zweig `p38-spurmarke-rumpf` habe
**Quellstand 7.2.0.71, Paketnummer 1.0.71** gebracht. Beim Prüfen stand dort
**7.2.0.70 / 1.0.70**, im Commit davor **7.2.0.69 / 1.0.69** — und **das war
richtig**: der CHANGELOG-Abschnitt 7.2.0.69 trägt den Namen dieses Zweigs,
`ceab98f` ist sein Merge. **Dieselbe Zeile ist an einem Abend zweimal um eine
Fassung weitergeschoben worden**, jedes Mal von einer Ersetzung, die die
Gegenwart meinte und die Vergangenheit traf.

Das ist die Klasse, die L-11, L-13 und L-14.4 beschrieben haben, zum
**fünften** Mal. Sie ist mit Berichtigen nicht zu erledigen. **Vorschlag für
eine Schranke:** `tools/ZWEIGE.md` nennt zu jedem Zweig einen Quellstand —
der lässt sich gegen `git show <merge>:Eudora71/Version.h` prüfen. Ein Zweig,
dessen Merge eine andere Nummer trägt als die Tabelle, ist ein Mangel, und
zwar einer, den kein Mensch von Hand findet.

### Was das für diesen Bericht bedeutet

Meine Berichtigungen sind an **7.2.0.70** gemessen und auf `origin/main`
(`ceab98f`, 7.2.0.69) geschrieben. Die Zahlen **7.2.0.70 / 1.0.70** in
`AUFGABEN.md`, `WEITERMACHEN.md`, `ZIEL.md`, `PORTIERUNG.md` und
`tools/WERKZEUGE.md` müssen beim Zusammenführen auf **7.2.0.71 / 1.0.71**
gehoben werden. **Die Fassungszuordnungen der Befunde ändern sich dadurch
nicht** — E-101 bleibt 7.2.0.66 und 7.2.0.69, E-103 bleibt 7.2.0.67, E-104
bleibt 7.2.0.67 und 7.2.0.68, E-106 bleibt 7.2.0.68. Genau das ist der
Unterschied zwischen einer Zahl, die mitwandert, und einer, die nicht darf.
