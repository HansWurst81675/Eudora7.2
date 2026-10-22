# <a id="lektor-46"></a>LEKTOR-46 — Nachlauf vor der Veröffentlichung von v1.0.117: die Prüfsumme lag in den Notizen eines anderen Pakets, und das führende Dokument forderte ein Release, das es nicht geben soll

Kurzer Nachlauf am 21.10.2026 im Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig
`wt/lektor`, Ausgang `514c1be5`. Kein voller Durchgang. Anlass: **Paket 1.0.117
soll gleich als `v1.0.117` veröffentlicht werden** — für Fremde, unter anderem
für den Melder aus [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102).
Geprüft wurde nur, was dabei nach außen geht oder den Stand behauptet.

## Maßstab von außen

Nichts davon aus einem Dokument des Projekts ([Einigkeit ist kein
Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)):

| Quelle | Wert |
|---|---|
| `git tag \| sort -V \| tail -1` | **`v1.0.113`** — **kein** `v1.0.114` bis `v1.0.117` |
| `gh release list` | `v1.0.113` ist **Latest** (20.10.2026, 13:01:36 UTC) |
| `Eudora71/Version.h:14` | `7.2.0.117` |
| `VERSION` | `1.0.117` |
| ZIPs im Hauptbaum `Releases/` | `Eudora72-1.0.114-release.zip` (07:07), `…-115…` (07:26), `…-116…` (08:39), `…-117…` (09:14), alle 21.10.2026 |
| `sha256sum Eudora72-1.0.117-release.zip` | **`335751a91ca67b7996c4076f077deb49a0f4ce4ac1de74c8a079cc2cb7eeb1a1`**, 9.382.044 Byte |
| `sha256sum Eudora72-1.0.116-release.zip` | `78cfacf5…81fe` — **nicht** dieselbe Datei |
| `ls C:\Users\Gregor\Eudora72-*` | 1.0.110, 1.0.111, 1.0.112, 1.0.113, **1.0.115, 1.0.116, 1.0.117** — **kein 1.0.114** |
| `ls Releases/1.0.117/` | **gab es nicht**, bis dieser Lauf das Verzeichnis anlegte |
| Uhr | 21.10.2026 |

**Werkzeuge vorher:** `doku-pruefen.pl` kein Widerspruch (10 Hinweise *zur
Kenntnis*, alle berechtigt — ältere Release-Notizen und Rückblicke),
`befunde-verlinken.pl` *Anker vollständig*, `commit-bereit.pl` **33 Schranken,
keine weist ab**. **Nachher** dieselben Werte.

---

## Die Reste der Versionsschleife

### <a id="l-46.1"></a>L-46.1 — `WEITERMACHEN.md` nannte in derselben Tabelle zwei verschiedene Fassungen und forderte unten ein Release `v1.0.114` (hoch)

Zwei Stellen, beide im Dokument, das die nächste Sitzung **zuerst** liest.

**(a) Die Tabelle widerspricht sich selbst.** Zeile 9, *Quellstand*:

> 7.2.0.114 (`Eudora71/Version.h`), `VERSION` 1.0.114, Zweig
> `e-132-fremdes-mailverzeichnis` — **noch nicht als Paket geschnürt und nicht
> veröffentlicht**

Vier Zeilen tiefer, *Paketnummer*: **1.0.117**. Gemessen trägt `Version.h`
`7.2.0.117`, `VERSION` `1.0.117`, und der Zweig heißt
`e-132-startwege-und-merker`. Jede einzelne Angabe der oberen Zeile ist falsch,
und sie steht **über** der richtigen.

**(b) Der Block *HIER WEITERMACHEN* beschrieb vier Handgriffe, die drei Pakete
zu spät kommen.** `WEITERMACHEN.md:140-145`:

> **Es gibt noch KEIN Paket 1.0.114 und keine Veröffentlichung.** … 1. Paket
> 1.0.114 schnüren …, die SHA-256 des ZIPs in `Releases/1.0.114/RELEASE-NOTIZEN.md`
> eintragen — dort steht an der Stelle noch *„wird beim Schnüren des Pakets
> eingetragen"* … 3. **Erst danach Release `v1.0.114`.**

Gemessen: **alle vier Pakete 1.0.114 bis 1.0.117 sind geschnürt**, drei liegen
bei Gregor, die SHA-256 ist längst eingetragen (und zwar falsch, siehe
[L-46.3](#l-46.3)), und veröffentlicht werden soll `v1.0.117`. Wer diesen Block
befolgt, veröffentlicht die Fassung, die an Gregors eigenem Fund gescheitert
ist.

**Das ist derselbe Mechanismus wie [L-45.4](LEKTOR-45.md#l-45.4) und
[L-44.7](LEKTOR-44.md#l-44.7):** der Block trägt ein gültiges Datum, und
`pruefe-stand-md.pl` prüft das Datum, nicht die Aussage. Er trug sogar den
**heutigen** 21.10.2026 — und war trotzdem um drei Fassungen zurück. Ein Datum
ist hier keine Schranke mehr; die Schranke aus
[L-44.11](LEKTOR-44.md#l-44.11), die gegen `gh release view` und `VERSION`
misst statt gegen das Dokument selbst, ist weiterhin **nicht gebaut**.

Beides berichtigt. Der Block nennt jetzt die vier geschnürten Pakete, `v1.0.113`
als veröffentlichten Stand, `v1.0.117` als Ziel, und die zwei Handgriffe, die
beim Release von Hand nachzuholen sind ([L-43.11](LEKTOR-43.md#l-43.11),
[L-43.12](LEKTOR-43.md#l-43.12)).

### <a id="l-46.2"></a>L-46.2 — der `CHANGELOG` schloss unter der Überschrift *7.2.0.117* mit dem Satz *„Also 1.0.116"* (hoch)

`CHANGELOG.md:129-147`, ein Abschnitt *„Zwei Bauten unter demselben Namen — und
wie man sie unterscheidet"*, der **innerhalb** des Abschnitts `## 7.2.0.117`
steht:

> Ich hatte vorgeschlagen, diese Fassung **1.0.117** zu nennen … Seine Antwort:
> *„ich habe auch 0.116 gesagt, nicht 0.117."* **Also 1.0.116.**
>
> Damit gibt es den Namen zweimal. … | **erster**, 21.10.2026 vormittags |
> `1454F544…` | | **zweiter**, 21.10.2026 mittags | *(siehe `Releases/PAKETE.md`)* |

Das ist die stehengebliebene Mitte der Versionsschleife. Gemessen: `VERSION`
sagt **1.0.117**, `Version.h` sagt **7.2.0.117**, es gibt
`Eudora72-1.0.116-release.zip` **und** `Eudora72-1.0.117-release.zip` mit
verschiedenen Prüfsummen, und die Commit-Nachricht von `514c1be5` hält Gregors
spätere Ansage fest: *„sonst müssen wir tatsächlich die versionsnummer
hochzählen"* und *„release 1.0.117 auf github"*.

**Warum das mehr ist als ein überholter Absatz.** Er beschreibt ausgerechnet den
Zustand, den [version-eindeutig-machen](../Arbeitsweise/version-eindeutig-machen.md)
verbietet — zwei Bauten unter einem Namen —, und erklärt ihn für den geltenden.
Wer in einem halben Jahr eine Messung *„an 1.0.116"* zuordnen will, liest hier,
es gebe zwei davon, und sucht eine Prüfsumme, die nirgends steht (*„siehe
`Releases/PAKETE.md`"* — dort stand sie nicht).

Ersetzt durch *„Wie diese Fassung zu ihrer Nummer kam"*: was wirklich geschah,
und eine Tabelle **zweier Pakete mit zwei Nummern**, mit dem Vermerk, welches
veröffentlicht wird.

### <a id="l-46.3"></a>L-46.3 — die Prüfsumme des 1.0.117-ZIPs stand in den Release-Notizen zu 1.0.114, und zu 1.0.117 gab es überhaupt keine (hoch, der schwerste Punkt)

`Releases/1.0.114/RELEASE-NOTIZEN.md:100` trug seit `514c1be5`:

> SHA-256 des ZIPs: `335751a91ca67b7996c4076f077deb49a0f4ce4ac1de74c8a079cc2cb7eeb1a1`

**Nachgemessen mit `sha256sum`:** das ist
`Eudora72-1.0.117-release.zip`. `Eudora72-1.0.114-release.zip` hat eine andere.
Der Weg dorthin steht im Diff: `git log -S` findet die Zeichenkette in genau
einem Commit, dem **1.0.117**-Commit, der den Platzhalter *„wird beim Schnüren
des Pakets eingetragen"* ersetzt hat — in der Datei des falschen Pakets, weil
`Releases/1.0.117/` nicht existierte.

**Was dabei herauskam, ist der schlimmste Fall eines Textes nach außen:** ein
Dokument mit der Überschrift *„Eudora 7.2.0.114 / Paket 1.0.114"*, das
*„241 Tests, 241 bestanden"* meldet, nichts von den Behebungen aus 115, 116 und
117 weiß — und darunter die **echte, nachprüfbare Prüfsumme der Datei, die
herausgeht**. Eine Prüfsumme ist das eine Feld, dem ein Fremder blind glaubt;
sie ist der Grund, warum er die Datei für unverfälscht hält. Hier hätte sie
einen Text beglaubigt, der ein anderes Paket beschreibt.

**Und es gab keine Release-Notizen zu 1.0.117** — `Releases/` führte Verzeichnisse
bis `1.0.114`. Ein Release ohne Notizen hätte entweder die 1.0.114-Notizen
bekommen (241 statt 243 Tests, kein Wort zu den drei Behebungen, die dieses
Paket ausmachen) oder gar keine.

**Berichtigt:**

* `Releases/1.0.117/RELEASE-NOTIZEN.md` **neu angelegt**, nicht aus dem
  Vorgänger kopiert ([L-44.12](LEKTOR-44.md#l-44.12)). Inhalt Satz für Satz
  gegen das Gemessene: 243 Tests, die rot/grün-Tabelle aus `Releases/PAKETE.md`
  (keine Rückfrage und 29 Einträge in die fremde Sicherung an der Fassung
  davor; Rückfrage an 7.2.0.117), die drei Antworten *No*/*Yes*/*Cancel* samt
  Gegenprobe, die Defender-Zählung **dreimal am 20.10.2026** (dieselbe Zahl wie
  [E-124](../Intern/BEFUNDE.md#e-124), `Releases/DEFENDER-FEHLALARM.md` *„three
  separate builds"* und [L-45.3](LEKTOR-45.md#l-45.3)), Vorgang
  `a567fe2a-9f58-47e1-a675-a62733ec538f`, die Prüfsumme **an der Datei selbst
  gemessen**. Gegen die Halbsatz-Regel aus
  [L-43.1](LEKTOR-43.md#l-43.1) / [PRÜFER-40](PRUEFER-40.md#k2) K2 gefahren:
  **0 Absätze** mit ungerader Zahl von `**`, **0** mit Kleinbuchstaben am
  Anfang.
* `Releases/1.0.114/RELEASE-NOTIZEN.md`: die fremde Prüfsumme heraus, an ihrer
  Stelle steht, wem sie gehört und dass diese Notizen zu einem Paket gehören,
  das **nicht** veröffentlicht wird.
* `Releases/PAKETE.md`, Abschnitt 1.0.117: eine Zeile *ZIP und Prüfsumme* mit
  Dateiname, Größe, Uhrzeit und der gemessenen SHA-256. Die fehlte — und
  `tools/doku-pruefen.pl` hat sie beim ersten Commit-Versuch auch eingefordert.

### <a id="l-46.4"></a>L-46.4 — `Releases/PAKETE.md` bewies zum zweiten Mal an zwei Tagen die Abwesenheit von etwas, das es gibt (mittel)

Der Kasten über dem Abschnitt 1.0.114, geschrieben von
[L-45.2](LEKTOR-45.md#l-45.2) — einer Berichtigung desselben Kastens vom
Vortag:

> **Diese Nummer ist vergeben, das Paket gibt es noch nicht.** Gemessen am
> 21.10.2026: unter `Releases/` liegt kein `Eudora72-1.0.114-release.zip`, …
> und bei Gregor liegt kein `Eudora72-1.0.114-release` (dort stehen 1.0.110 bis
> 1.0.113). … es hält die Release-Notizen, deren SHA-256 noch ein Platzhalter
> ist.

**Gemessen, Punkt für Punkt:** das ZIP liegt seit 07:07 in `Releases/`; bei
Gregor stehen 1.0.115, 1.0.116 und 1.0.117 (die Aufzählung endet im Text bei
1.0.113); die SHA-256 ist kein Platzhalter mehr, sondern die Prüfsumme eines
fremden Pakets. **Richtig geblieben ist nur, dass es kein Tag `v1.0.114` gibt.**
Dazu widersprach der Kasten dem Kopf derselben Datei (`:6`), der 1.0.114
bereits als *„geschnürt und bei Gregor getestet"* führt.

**Die Form ist das Problem, nicht die Zahl.** Ein Kasten, der eine
**Abwesenheit** beweist, verfällt in dem Moment, in dem jemand die Sache
anlegt — und er verfällt lautlos, weil er aussieht wie eine Messung mit Datum.
Derselbe Kasten ist am 20.10., am 21.10. früh und jetzt zum **dritten Mal** in
Folge berichtigt worden. Er sagt jetzt, was **ist** (geschnürt, an Gregors Lauf
gescheitert, wird nicht veröffentlicht) statt was fehlt.

### <a id="l-46.5"></a>L-46.5 — der Testplan trug 1.0.117 im Titel und schickte Gregor an ein Verzeichnis, das er für ungeschnürt erklärte (mittel)

`TESTPLAN.md:1` sagt *„Paket 1.0.117, Stand 21.10.2026"*. Der einzige Schritt,
der zu tun ist, sagte zwölf Zeilen tiefer (`:18`):

> **Vorbereitung.** Testverzeichnis `C:\Users\Gregor\Eudora72-1.0.115-release` —
> **das Paket ist noch nicht geschnürt**, das Verzeichnis gibt es also noch
> nicht; dieser Schritt wird fällig, sobald es da ist.

Und `:172` sagte *„Zu testen ist 1.0.115 (oben) — **geschnürt und bei Gregor**"*.
Drei Aussagen in einer Datei, zwei davon falsch: 1.0.115 **ist** geschnürt und
liegt bei ihm, und zu testen ist 1.0.117. Auch `Schritt 2` und die
`grep`-Zeile, die er bei einem Fehlschlag abschicken soll, standen auf
1.0.115 — nach ihr hätte er im Protokoll **des falschen Pakets** gesucht.

Alles vier auf 1.0.117 gezogen. **Die `grep`-Zeile steht in Rückstrichen und
ist trotzdem geändert** — sie ist kein Beleg, sondern ein Befehl, den Gregor
ausführen soll ([L-44.14](LEKTOR-44.md#l-44.14) meint Zitate und Messwerte,
nicht Handlungsanweisungen).

### <a id="l-46.6"></a>L-46.6 — der Beitrag an den Melder nannte viermal eine Fassung, die es nicht gibt (hoch, geht nach außen)

`Releases/ISSUE-102-ANTWORT.md` nannte `v1.0.114` — zweimal im von Gregor
**freigegebenen englischen Wortlaut** (*„we found the mechanism behind this and
fixed it in v1.0.114"*, *„if you can try v1.0.114 alongside your existing
installation"*) und zweimal im deutschen Vorspann.

**Nur die Nummer ist geändert**, auf `v1.0.117`, an allen vier Stellen. Die
Datei selbst hält das seit dem 20.10.2026 als einzige zulässige Änderung ohne
neue Freigabe fest — *„eine Fassungsnummer ist eine Tatsache, kein Wortlaut"*.
Kein Wort des freigegebenen Textes ist sonst angefasst; *„is located"* statt
*„lives"* steht unverändert.

**Der Beitrag darf erst nach dem Release abgeschickt werden.** Solange es kein
Tag `v1.0.117` gibt, zeigen alle vier Stellen ins Leere — das steht jetzt als
erster Satz über dem Text. **Offen und Gregors Entscheidung bleiben die drei
Punkte aus [L-44.8](LEKTOR-44.md#l-44.8)**, allen voran das fehlende *„back up
your `Eudora.ini` first"*; sie stehen unverändert über dem Wortlaut.

### <a id="l-46.7"></a>L-46.7 — die README erklärte die Behebung für ungeschnürt (mittel)

`README.md:60-63`, im Abschnitt *Auf einen Blick* — genau der Abschnitt, auf den
die Release-Notizen einen Fremden für die vollständige Fehlerliste verweisen:

> **In 7.2.0.114 fragt Eudora vorher** … diese Fassung ist aber **noch nicht als
> Paket geschnürt und nicht veröffentlicht**

Der erste Halbsatz ist überholt (seit 7.2.0.116 auf allen Wegen, seit 7.2.0.117
auch ohne fremde `Eudora.ini`), der zweite falsch (geschnürt ist sie). Richtig
und wichtig war nur das Ende: *„für `v1.0.113` gilt der Hinweis oben
unverändert"* — das steht weiterhin da, denn veröffentlicht ist bis zur Stunde
nur `v1.0.113`.

---

## <a id="l-46.8"></a>L-46.8 — stimmen die Zahlen überall überein?

Nachgezählt, nicht abgeschrieben.

| Angabe | Maßstab | wo sie steht | Urteil |
|---|---|---|---|
| **243 Tests, 243 bestanden** | Commit-Nachricht `514c1be5`, Bau zu 1.0.117 | `CHANGELOG.md` (7.2.0.115/116/117), `Releases/PAKETE.md` (1.0.115/116/117), `WEITERMACHEN.md`, `AUFGABEN.md`, `tools/ZWEIGE.md`, **neu** `Releases/1.0.117/RELEASE-NOTIZEN.md` | **stimmig.** Die **241** in den 1.0.114-Notizen ist richtig — sie gehört zu 7.2.0.114 |
| **rot:** keine Rückfrage, **29 Einträge** in die fremde Sicherung in 90 s | Commit `514c1be5`, am laufenden Programm gemessen | `Releases/PAKETE.md:167`, `CHANGELOG.md`, `WEITERMACHEN.md` (dort als *„neunundzwanzig Einträge"*), **neu** in den Notizen | **stimmig.** Die Fassung, an der *rot* gemessen wurde, heißt überall **1.0.116** |
| **grün:** `fremd=1`, Rückfrage, nach *Nein* eigenes Verzeichnis | ebd. | dieselben Stellen | **stimmig** |
| **ZIP-SHA-256 `335751a9…eb1a1`** | `sha256sum` an der Datei | stand **nur** in den 1.0.114-Notizen; jetzt in `Releases/1.0.117/RELEASE-NOTIZEN.md`, `Releases/PAKETE.md` und `WEITERMACHEN.md` | **war falsch zugeordnet**, siehe [L-46.3](#l-46.3) |
| **Defender dreimal am 20.10.2026** | [E-124](../Intern/BEFUNDE.md#e-124), `DEFENDER-FEHLALARM.md:64` *„three separate builds"* | `README.md`, `Releases/PAKETE.md`, `WEITERMACHEN.md`, beide Notizen | **stimmig** seit [L-45.3](LEKTOR-45.md#l-45.3) |
| **veröffentlicht ist `v1.0.113`** | `git tag`, `gh release list` | `README.md:38/:146`, `TESTPLAN.md:172`, `Releases/PAKETE.md:6`, `AUFGABEN.md:3`, `WEITERMACHEN.md` | **stimmig — und es bleibt stimmig, bis das Tag steht** |

`Releases/DEFENDER-FEHLALARM.md` ist **nicht angefasst**: der Text ist bei
Microsoft eingereicht, seine Angaben zu 1.0.113 sind historisch richtig, und ein
eingereichter Wortlaut wird nicht nachträglich umgeschrieben.

---

## Darf `v1.0.117` so veröffentlicht werden?

**Ja — nach diesen sieben Berichtigungen**, und unter drei Bedingungen, die beim
Veröffentlichen selbst zu erfüllen sind. Gemessen gilt jetzt:

* **Kein geprüftes Dokument behauptet mehr, 1.0.117 sei veröffentlicht.** Alle
  sagen ausdrücklich das Gegenteil und nennen `v1.0.113` als jüngstes Release.
* **Es gibt Release-Notizen zu 1.0.117**, Satz für Satz gegen das Gemessene
  gehalten, mit der an der Datei nachgemessenen Prüfsumme.
* **Kein Dokument nennt mehr 1.0.116 oder 7.2.0.116 als aktuellen Stand**, und
  die Begründung *„1.0.117 heißt so, weil 1.0.116 schon vergeben ist"* steht
  nirgends mehr als geltende Regel; `Releases/PAKETE.md:165` behält sie als
  **Begründung der Nummernwahl** — das ist eine Tatsache über den 21.10.2026 und
  bleibt wahr.

**Drei Dinge, die beim Veröffentlichen zu tun sind und von selbst ausfallen:**

1. **Gregors Test an 1.0.117 abwarten.** Das Paket liegt bei ihm; bestätigt hat
   er 1.0.116. [Release erst nach Gregors
   Test](../Arbeitsweise/release-erst-nach-gregors-test.md) — das Urteil hier
   betrifft die **Texte**, nicht die Freigabe.
2. **`perl tools/pruefe-release-buchfuehrung.pl` direkt nach `gh release create`
   von Hand fahren.** `tools/release-veroeffentlichen.ps1` ruft sie **null Mal**
   ([L-43.11](LEKTOR-43.md#l-43.11), seit drei Tagen offen); bei `v1.0.113`
   meldete sie hinterher sechs Stellen. Danach `README.md:38` und `:146`,
   `TESTPLAN.md:172`, `Releases/PAKETE.md:6`, `AUFGABEN.md:3` und
   `README.md:60-63` auf `v1.0.117` ziehen — **heute sind sie richtig, mit dem
   Tag werden sie falsch.**
3. **Die neue Zeile in `tools/RELEASES.md` in die Tabelle heben.**
   `release-veroeffentlichen.ps1:286` hängt sie mit `AppendAllText` ans
   Dateiende ([L-43.12](LEKTOR-43.md#l-43.12)); bei `v1.0.112` und `v1.0.113`
   ist das je einmal von Hand nachgeholt worden, bei `v1.0.117` wird es das
   dritte Mal.

**Offen, unverändert aus [L-45.5](LEKTOR-45.md#l-45.5)** (nachgemessen, nicht
abgeschrieben): die veröffentlichte Beschreibung von `v1.0.113` weicht weiter
vom Repo-Text ab (zum **vierten** Mal offen); die Schranke aus
[L-44.11](LEKTOR-44.md#l-44.11) ist nicht gebaut — sie hätte
[L-46.1](#l-46.1) gefangen; `tools/pruefe-halbe-saetze.pl` ist nicht gebaut;
[L-43.13](LEKTOR-43.md#l-43.13), [L-43.15](LEKTOR-43.md#l-43.15),
[L-42.14](LEKTOR-42.md#l-42.14), [L-41.8](LEKTOR-41.md#l-41.8),
[L-38.5](LEKTOR-38.md#l-38.5), [L-37.10](LEKTOR-37.md#l-37.10) und
[E-130](../Intern/BEFUNDE.md#e-130) stehen unverändert.

**Ein Muster aus diesem Lauf, das eine eigene Schranke verdient.** Fünf der
sieben Funde sind **Aussagen über den eigenen Auslieferungsstand**: welches
Paket geschnürt ist, wo es liegt, welche Nummer es trägt, welche Prüfsumme dazu
gehört. Keine einzige davon hat eine der 33 Schranken gesehen, weil alle gegen
**Dokumente** prüfen und keine gegen das **Dateisystem** — gegen
`ls Releases/*.zip`, `ls C:\Users\Gregor\Eudora72-*`, `sha256sum`. Der Maßstab
lag die ganze Zeit zwei Verzeichnisse weiter.

---

## Geänderte Dateien

`WEITERMACHEN.md`, `CHANGELOG.md`, `README.md`, `TESTPLAN.md`, `AUFGABEN.md`,
`Releases/PAKETE.md`, `Releases/ISSUE-102-ANTWORT.md`,
`Releases/1.0.114/RELEASE-NOTIZEN.md`, **neu**
`Releases/1.0.117/RELEASE-NOTIZEN.md`, `LEKTORAT.md` und dieser Bericht.

**Keine Datei unter `Eudora71/` angefasst, kein Werkzeug unter `tools/`
geändert.** `Releases/DEFENDER-FEHLALARM.md` (eingereicht) unverändert; vom
freigegebenen Wortlaut in `Releases/ISSUE-102-ANTWORT.md` ist **nur die
Fassungsnummer** geändert.

Nach jedem Schreibzugriff gemessen: **CRLF 0**, reine LF, UTF-8 ohne BOM.
`perl tools/commit-bereit.pl` vor jedem Commit: **33 Schranken, keine weist
ab.** `befunde-verlinken.pl` *Anker vollständig*, `doku-pruefen.pl` kein
Widerspruch.
