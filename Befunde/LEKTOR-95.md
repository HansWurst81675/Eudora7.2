# <a id="lektor-95"></a>LEKTOR-95 — Nummernschema 7.2.0.N / 7.2.1.N und Release 7.2.1.128 gegen den Bestand, 29.10.2026

**Auftrag.** Alle MD-Dateien (`git ls-files '*.md'` ohne `Arbeitsweise/` und
`Befunde/`, 62 Dateien) gegen den Bestand prüfen, Schwerpunkt das neue
Nummernschema (Gregors Entscheidung 10, am 29.10.2026 bestätigt) und die
Nummer 7.2.1.128; dazu, was aus den Funden von
[LEKTOR-94](LEKTOR-94.md#lektor-94) wurde. Gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor` auf `wt/lektor-20261029e`, vorgespult auf `640e1a0e`
(*„Nummer 7.2.1.128 vergeben“*) — diesen Commit gab es beim Start nur lokal
auf `release-7.2.1`, `origin/release-7.2.1` stand auf `a5febb70`. Während
des Laufs kamen `efc9cfd4` (*„Pruefbericht 7.2.1.128: BESTANDEN“*) und
`b74a1e81` (*„Paket 7.2.1.128 geschnuert, Testplan auf das Release
umgestellt“*) hinzu; der Baum ist darauf vorgespult, **alle Zeilenangaben
gelten für `b74a1e81`**. Seit [LEKTOR-94](LEKTOR-94.md#lektor-94) (`4b8a24b5`) geändert: `0a4d2390`,
`a5febb70`, `640e1a0e`, `efc9cfd4`, `b74a1e81`. Nichts gebaut, nichts
gestartet.

**In diesem Bericht steht nichts aus Gregors Postfach.** Wo eine Stelle
Postfachinhalt trägt, steht nur Datei:Zeile und Kategorie.

**Ergebnis vorweg.** **15 Funde.** Das neue Schema ist in `PAKETE.md`,
`MITARBEITEN.md`, `WERKZEUGE.md` und den Standzeilen angekommen — **aber
nicht überall, wo ein Anwender oder Tester liest:** die Anwenderdoku
beschreibt die Titelzeile weiter als `Eudora 7.2.0.<n> / Paket 1.0.<n>`
([L-95.1](#l-95.1)), und der CHANGELOG-Kopf erklärt die Zählung `1.0.x` als
gültig ([L-95.2](#l-95.2)). Der Testplan sagt seit `b74a1e81` *„Zu prüfen
ist nur ein Schritt“* ([E-166](../Intern/BEFUNDE.md#e-166)), während ZIEL.md vor der Marke den Test
aller neun Kriterien an einem frischen Paket verlangt; darunter verweist
er weiter auf einen *„übrigen Release-Test“*, den es nicht gibt
([L-95.11](#l-95.11)). **Seit dem Schnüren (`b74a1e81`) sagen README,
WEITERMACHEN und AUFGABEN „noch nicht geschnürt“** ([L-95.15](#l-95.15)).
Ein Werkzeug, das `PAKETE.md` als Messbefehl empfiehlt, bricht an
`7.2.1.128` ab ([L-95.4](#l-95.4)). Zwei alte Sätze in `PAKETE.md`
bestreiten, dass `Eudora.exe` eine Dateiversion hat — mit 7.2.1.128 steht
dort jetzt `7,2,1,128` ([L-95.6](#l-95.6)). Aus
[LEKTOR-94](LEKTOR-94.md#lektor-94): 14 von 18 erledigt, 3 teilweise, 1
bewusst unverändert. Als **getestet oder veröffentlicht** stellt keine Datei
7.2.1.128 dar (gemessen, unten).

---

## Funde aus LEKTOR-94

Gemessen: die Begriffe, die `528a1589` und `8d42545b` ersetzt haben, kommen
im heutigen Stand außerhalb fremden Codes **0-mal** vor (`git grep`, 16
Muster; die einzigen Treffer eines Musters liegen in Qt- und SDK-Kopfdateien).

| Fund | Was es war | Heute | Beleg |
|---|---|---|---|
| [L-94.1](LEKTOR-94.md#l-94.1) | Anhang-Dateinamen einer beruflichen Mail im CHANGELOG | **erledigt** | gemessen: 0 Treffer; Platzhalter `anhang-a-…docx`/`.pdf` im CHANGELOG (`528a1589`) |
| [L-94.2](LEKTOR-94.md#l-94.2) | Rundbrief: Unterzeichner, Absenderdomain, Bildnamen bis in Unit-Tests | **erledigt** | gemessen: 0 Treffer der Domain und der Bildnamen; Tests auf `beispiel.invalid`/`absender.invalid` |
| [L-94.3](LEKTOR-94.md#l-94.3) | Betreff einer privaten Anzeigen-Unterhaltung mit Gegenstand | **erledigt** | gemessen: 0 Treffer; `8d42545b` neutralisiert dazu Anzeigennummer und Titel in `Testdaten/e106…` |
| [L-94.4](LEKTOR-94.md#l-94.4) | Firmennamen von Absendern, zwei Newsletter-Betreffe | **teilweise** — die Firmennamen bleiben nach Gregors Entscheidung 18; die **Betreffzeilen** nicht → [L-95.14](#l-95.14) | `Intern/WEITERMACHEN.md:139` *„Firmennamen von **Werbe-Absendern** bleiben im Repo … Alles andere aus seinem Postfach (Betreffzeilen, …) kommt nicht ins öffentliche Repo“*; `CHANGELOG.md:4344-4345` (gemessen) |
| [L-94.5](LEKTOR-94.md#l-94.5) | Mailadresse mit echter Domain im Unit-Test | **erledigt** | `Eudora71/Tests/TestPopEmpfang.cpp` jetzt `empfaenger@beispiel.invalid` (gemessen) |
| [L-94.6](LEKTOR-94.md#l-94.6) | Wort aus einer Werbe-Betreffzeile in zwei Release-Texten | **erledigt** | gemessen mit `gh release view` über **alle 22** Release-Texte: 0 Treffer; Entscheidung 19, `Intern/WEITERMACHEN.md:140` |
| [L-94.7](LEKTOR-94.md#l-94.7) | Geschichte und sechs Zweige zeigen Entferntes | **erledigt, soweit entschieden** — Zweige weg, Geschichte bleibt (Gregor) | `git ls-remote --heads origin`: nur `main`, `release-7.2.1`, dieser Zweig (gemessen); `Intern/WEITERMACHEN.md:139` *„die Git-Geschichte wird nicht umgeschrieben“* |
| [L-94.8](LEKTOR-94.md#l-94.8) | Lehre beschrieb das Entfernte zu genau | **erledigt** | `Arbeitsweise/gedaechtnis-ist-oeffentlich.md` und das Gedächtnis byte-gleich, beide ohne die Klammerzusätze (gemessen, `cmp`) |
| [L-94.9](LEKTOR-94.md#l-94.9) | Platzhalter-Grammatik | **erledigt** | 0 Treffer für die zerbrochenen Formen außerhalb von [LEKTOR-94](LEKTOR-94.md#lektor-94) selbst (gemessen) |
| [L-94.10](LEKTOR-94.md#l-94.10) | `Ware` gegen `Waren` bei der E-94-Messung | **teilweise** — überall `Waren`, gleiche Länge wie das ersetzte Wort, die Abschneidestelle stimmt wieder; der Hinweis an den Bildschirmfoto-Zitaten fehlt | `CHANGELOG.md:1611` *„**Gregors Fall:** *„Waren bestel len & 1 5 % sparen …“*“* steht als wörtliches Zitat ohne *„(Wort ersetzt)“*; `git grep -i Produktwort` außerhalb [LEKTOR-94](LEKTOR-94.md#lektor-94): 0 (gemessen) |
| [L-94.11](LEKTOR-94.md#l-94.11) | `Werbemail-A` war keine Werbung | **erledigt** | 0 Treffer `Werbemail-[AB]` außerhalb [LEKTOR-94](LEKTOR-94.md#lektor-94); `Intern/WEITERMACHEN.md:40`, `:45` sagen `Mail-A`/`Mail-B` (gemessen) |
| [L-94.12](LEKTOR-94.md#l-94.12) | Tabelle „an echten Kopfzeilen“ zeigt `<Ort>` | **erledigt** | `Intern/BEFUNDE.md:3511` *„Gemessen an nachgebauten Kopfzeilen“*, `:3520` *„… aus Musterstadt“* |
| [L-94.13](LEKTOR-94.md#l-94.13) | README empfahl *View Source* gegen [E-172](../Intern/BEFUNDE.md#e-172) | **erledigt** | `README.md:167` *„– (*View Source* im Rechtsklickmenü ist nicht geprüft und im Nur-Text-Fenster womöglich gesperrt)“* |
| [L-94.14](LEKTOR-94.md#l-94.14) | drei ältere Release-Texte mit totem Link | **erledigt** | gemessen über alle 22 Texte: 0 × `blob/main/BEFUNDE.md`; Entscheidung 19 — aber das CHANGELOG nennt nur die ersten drei → [L-95.13](#l-95.13) |
| [L-94.15](LEKTOR-94.md#l-94.15) | WEITERMACHEN-Einstieg auf dem Zweig vor #183 | **erledigt** — der Einstieg ist inzwischen wieder einen Schritt zurück → [L-95.9](#l-95.9) | `Intern/WEITERMACHEN.md:7` nennt `release-7.2.1`; der alte *„hier weiter“*-Block ist entfernt |
| [L-94.16](LEKTOR-94.md#l-94.16) | Merge mit Terminal-Steuerzeichen als Nachricht | **unverändert, bewusst** | Geschichte wird nicht umgeschrieben (Entscheidung 18) |
| [L-94.17](LEKTOR-94.md#l-94.17) | WERKZEUGE zählte 17 Muster, die Schranke sieht nur `Testdaten/` | **teilweise** — Zählung berichtigt; außerhalb `Testdaten/` weiter keine Schranke | `tools/WERKZEUGE.md:98` *„am 29.10.2026: 9 eingebaute, dazu die Begriffe aus der lokalen … Liste“*; die Commit-Nachrichten `528a1589`, `0a4d2390` nennen *„Begriffspruefung der Aenderungen 0 Treffer“* — von Hand |
| [L-94.18](LEKTOR-94.md#l-94.18) | CHANGELOG erwähnte die Bereinigung nicht | **erledigt** | `CHANGELOG.md:125` *„**Datenschutz:** Daten aus Gregors Postfach … entfernt und durch Platzhalter ersetzt“* |

**Reste aus älteren Berichten** (unverändert, gemessen):
[L-92.2](LEKTOR-92.md#l-92.2) — **offen**, `Intern/FILTER.md:228` nennt für
*Make Label* weiter `filtersd.cpp:1151-1155`, der Fall `ID_FLT_LABEL` steht
in `:1222`; `:220` weiter `EudoraRes.rc:6063-6093`.
[L-91.4](LEKTOR-91.md#l-91.4) und [L-91.7](LEKTOR-91.md#l-91.7) —
**teilweise**, Wortlaut unverändert (`Intern/TESTPLAN.md:34-35`,
`Intern/FILTER.md:532`).

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe | Bewertung |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„Quellstand 7.2.1.128 · Paketnummer 7.2.1.128 · gepruefte Dateien 48 · Kennungen im Verzeichnis 161 … Kein Widerspruch gefunden.“*; *„Zur Kenntnis“* 20 Dateien ohne 7.2.1.128, darunter *„Doku/FAQ.md … (hoechste genannte Fassung: 7.2.0.12)“* | liest VERSION und Version.h vierteilig richtig. Sieht keine der Beschreibungen des **alten Schemas** ([L-95.1](#l-95.1), [L-95.2](#l-95.2)) — es vergleicht Nummern, nicht Formen. Die FAQ nennt `1.0.127` (Form `1.0.x`), die das Werkzeug in der Kenntnisliste nicht als Fassung zählt |
| `perl tools/offene-befunde.pl` | *„offen laut Intern/BEFUNDE.md 45 … aktuell gemessen 5 (ab Nummer 123) … veraltet gemessen 26 … NIE gemessen 14 … 45 offene Befunde, in beiden Listen gleich.“* | gegen [LEKTOR-94](LEKTOR-94.md#lektor-94) (6/25/14) ist [E-159](../Intern/BEFUNDE.md#e-159) (Absturz am Prüfstand an 7.2.0.122) von *aktuell* nach *veraltet* gewandert — **allein durch die neue Endnummer 128**, ohne neue Messung (`Intern/WEITERMACHEN.md`, erzeugte Zeile *„26.10.2026 an 7.2.0.122 — **veraltet**“*). Richtig gerechnet, aber kein Befundwechsel |
| `perl tools/pruefe-regressionstest.pl` | *„Befunde insgesamt 218 … mit Testfall 74 … manuell im Testplan 2 … behoben und OHNE Testfall 67 … kritisch 73 … OHNE jede Pruefung 24 … Kein neues "behoben" ohne Regressionstest.“* | *manuell 2* ist neu: [E-87](../Intern/BEFUNDE.md#e-87)/[E-88](../Intern/BEFUNDE.md#e-88) über den TESTPLAN-Schritt vom 29.10. Die 24 kritischen ohne Prüfung sind dieselben wie in [LEKTOR-94](LEKTOR-94.md#lektor-94); nach Gregors Entscheidung vom 23.10. kein Release-Hindernis |
| `perl tools/ziel-stand.pl` | *„ziel-stand: 27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* | — |
| `perl tools/ausliefern.pl --pruefen` (zusätzlich, weil `PAKETE.md` es empfiehlt) | *„Paketversion '7.2.1.128' hat nicht die Form a.b.c“*, Rückgabewert 255 | → [L-95.4](#l-95.4) |

---

## Das alte Schema als gültig beschrieben

### <a id="l-95.1"></a>L-95.1 — falsch, Anwender: die Titelzeile heißt in der Doku weiter `Eudora 7.2.0.<n> / Paket 1.0.<n>`

**Was passiert:** wer einen Fehler meldet, soll die Titelzeile abschreiben;
die Anwenderdoku zeigt ihm eine Form, die 7.2.1.128 nicht mehr hat. Seit
`a5febb70` erzeugt der Bau `Eudora 7.2.1.128+<commit> <Zeit>` — ohne
*„/ Paket“*. Wer nach der beschriebenen Form sucht, findet sie nicht, und
wer *„Paket 1.0.128“* erwartet, hält das Release für falsch.

* **Belegt am Quelltext:** `tools/kennung-erzeugen.pl:145-146`
  `"Eudora $produkt+$commit$marke $zeit"`.
* **Belegt**, Anwender: `Doku/ANWENDER.md:101-102` *„Die Titelzeile nennt die
  Fassung, zum Beispiel `Eudora 7.2.0.72 / Paket 1.0.72`“*; `:253-255`
  *„sie nennt Fassung, Paketnummer und den Commit … in der Form
  `Eudora 7.2.0.<n> / Paket 1.0.<n>`“*.
* **Belegt**, Betrieb und Bau: `Intern/STARTUMGEBUNG.md:153-155` *„hat
  **heute** die Form `Eudora <Produktversion> / Paket <Paketnummer>+<Commit>…`“*;
  `Doku/BAUEN.md:196` *„Bau-Kennung — Paketversion, Commit und
  Herkunftsverzeichnis“*.
* Richtig dagegen: `Releases/PAKETE.md:52-53`, `tools/WERKZEUGE.md:54`,
  `CHANGELOG.md:136`.

**Was zu tun wäre:** an allen vier Stellen die neue Form, das Beispiel als
`Eudora 7.2.1.128+<commit> <Zeit>`; *„bis 1.0.127 mit „/ Paket 1.0.N““* als
Nachsatz, damit alte Bildschirmfotos lesbar bleiben.

### <a id="l-95.2"></a>L-95.2 — falsch: der Kopf des CHANGELOG erklärt die Zählung `1.0.x` als Regel

**Was passiert:** die drei ersten Sätze des CHANGELOG — die Stelle, an der
jeder Leser die Nummern lernt — beschreiben das alte Schema im Präsens.
Darunter steht als neueste Fassung `7.2.1.128`, die es widerlegt.

* **Belegt**, `CHANGELOG.md:3-5` *„Jede Nummer gehört genau einem Bau:
  **Quellstand `7.2.0.x`** steht in `Eudora71/Version.h`, **Paketnummer
  `1.0.x`** in `VERSION`. Die Bau-Kennung im Fenstertitel nennt beide plus
  den Commit.“* gegen `VERSION` = `7.2.1.128` (gemessen) und
  `CHANGELOG.md:104`.

**Was zu tun wäre:** *„`7.2.0.N` (Testpaket) bzw. `7.2.1.N` (Release) steht
in `Version.h` und `VERSION` gleich; bis 1.0.127 trug `VERSION` eine eigene
Zählung `1.0.N`“*, mit Verweis auf PAKETE.

### <a id="l-95.3"></a>L-95.3 — veraltet als Anleitung: ZIP- und Zweigname nach dem alten Muster

**Was passiert:** zwei Stellen, die sagen, wie man **das nächste** Paket
macht, geben die alten Namen vor.

* **Belegt**, `Intern/WEITERMACHEN.md:519`
  `tools\paket-bauen.ps1 -Ziel <Verzeichnis> -Zip Releases\Eudora72-1.0.x-release.zip …`
  — `-Zip` ist das **erzeugte** ZIP (`tools/paket-bauen.ps1:9-10` *„wenn -Zip
  angegeben ist, ein ZIP daneben“*), nach PAKETE.md:52 also
  `Eudora72-7.2.1.N-release.zip`.
* **Belegt**, `tools/ZWEIGE.md:56` *„Ein Zweig, der **nur** eine Fassung
  schnürt …, heißt weiter `release_1.0.NN`“* — der Zweig für 7.2.1.128 heißt
  `release-7.2.1`. Der neue Name ist Gregors Sache ([unten](#gregor)).

**Was zu tun wäre:** `:519` auf `Eudora72-<VERSION>-release.zip`; ZWEIGE
erst nach Gregors Antwort.

### <a id="l-95.4"></a>L-95.4 — Werkzeug: `ausliefern.pl --pruefen` bricht an 7.2.1.128 ab, PAKETE und WERKZEUGE empfehlen es weiter

**Was passiert:** Entscheidung 10 kündigt an, die Werkzeuge, die `VERSION`
als `1.0.x` lesen, *„in einem Zug“* umzustellen; das CHANGELOG zählt 15
umgestellte auf. `ausliefern.pl` ist nicht dabei und weist die neue Nummer
als Formfehler ab. `PAKETE.md` nennt es als den Befehl, mit dem man
*„beides gegeneinander“* misst.

* **Gemessen**, `perl tools/ausliefern.pl --pruefen` → *„Paketversion
  '7.2.1.128' hat nicht die Form a.b.c“*, Rückgabewert 255; Ursache
  `tools/ausliefern.pl:79-80` `$paket =~ /^(\d+)\.(\d+)\.(\d+)$/ or die`.
* **Belegt**, `Releases/PAKETE.md:119` `perl tools/ausliefern.pl --pruefen
  # beides gegeneinander`; `tools/WERKZEUGE.md:58` *„prüft die Regel „eine
  Nummer, ein Bau" nach: `--pruefen`“*.
* **Belegt**, `CHANGELOG.md:136` (Liste der umgestellten Werkzeuge ohne
  `ausliefern.pl`); `Intern/WEITERMACHEN.md:131` *„Die Werkzeuge, die
  `VERSION` als `1.0.x` lesen, werden beim Schnüren des Release in einem Zug
  umgestellt.“*
* **Gemessen**: kein anderes Werkzeug ruft `ausliefern.pl` auf (`git grep`
  über `tools/`) — die Wirkung bleibt beim Menschen, der der Anleitung folgt.

**Was zu tun wäre:** `ausliefern.pl` auf die vierteilige Form umstellen wie
`pruefe-fassungsnummer.pl`, oder PAKETE:119 auf `perl
tools/pruefe-fassungsnummer.pl` ändern.

### <a id="l-95.5"></a>L-95.5 — ungenau: „seit 7.2.0.128“ — eine Nummer, die es nicht gibt; MITARBEITEN widerspricht sich in zwei Zeilen

**Was passiert:** vier Stellen datieren das neue Schema auf `7.2.0.128`.
Die Endnummer 128 ist als `7.2.1.128` vergeben, ein Testpaket 7.2.0.128 hat
Gregor ausdrücklich ausgeschlossen. Wer liest *„`7.2.0.128` statt
`1.0.128`“*, sucht ein Paket, das nie entsteht.

* **Belegt**, `Releases/PAKETE.md:67` *„**Seit 7.2.0.128 muss `VERSION` mit
  `EUDORA_BUILD_VERSION` ganz übereinstimmen**“*; `:91` *„**Seit 7.2.0.128**
  steht in `VERSION` die ganze Nummer (`7.2.0.128` statt `1.0.128`)“*;
  `Doku/MITARBEITEN.md:65` *„Seit 7.2.0.128 sind beide Nummern **gleich**“*;
  `tools/WERKZEUGE.md:161` *„(seit 7.2.0.128)“*.
* **Belegt**, Gegenstück: `Intern/WEITERMACHEN.md:136` *„**Kein Testpaket
  7.2.0.128 dafür**“*.
* **Belegt**, `Doku/MITARBEITEN.md:58` *„Zwei Nummern, und sie bedeuten
  Verschiedenes“* — die Tabelle darunter (`:62-63`) gibt beiden denselben
  Wert `7.2.1.128`, `:65` nennt sie *„gleich“*.

**Was zu tun wäre:** *„ab der Endnummer 128 (erste Fassung: 7.2.1.128)“*;
in MITARBEITEN den Einleitungssatz auf *„eine Nummer an zwei Orten; bis
1.0.127 waren es zwei“*.

### <a id="l-95.6"></a>L-95.6 — falsch, jetzt wirksam: PAKETE bestreitet die Dateiversion der `Eudora.exe`

**Was passiert:** im Abschnitt, der das neue Schema erklärt, stehen zwei
Sätze vom 07.09.2026: `Eudora.exe` habe keinen `VS_VERSION_INFO`-Block, und
`EUDORA_BUILD_NUMBER` werde nirgends benutzt. Beides stimmt nicht — und
seit 7.2.1.128 sieht man es im Explorer, denn Entscheidung 10 nennt die
**Dateiversion** ausdrücklich unter den Stellen, die 7.2.1.N tragen. Dieselbe
Datei sagt zwei Bildschirmseiten tiefer das Richtige.

* **Belegt am Quelltext:** `Eudora71/Eudora/EudoraExe.rc:99` `#include
  "EudoraExeVer.rc"`, `EudoraExeVer.rc:19` `#include "..\VersionBeg.inc"`,
  `Eudora71/VersionBeg.inc:4-6` `VS_VERSION_INFO VERSIONINFO`,
  `FILEVERSION EUDORA_BUILD_NUMBER`, `PRODUCTVERSION EUDORA_BUILD_NUMBER`;
  `EudoraExe.rc` steht in `Eudora.vcxproj` (gemessen). `git grep -c
  EUDORA_BUILD_NUMBER`: `Version.h` 1, `VersionBeg.inc` 2 (gemessen).
* **Belegt**, falsch: `Releases/PAKETE.md:62` *„**Nicht** in den
  Dateieigenschaften: `Eudora.exe` hat gar keinen `VS_VERSION_INFO`-Block“*;
  `:101-103` *„Folgenlos ist es nur, weil das Makro derzeit **nirgends
  benutzt** wird (… ein Treffer, die Definition selbst)“*.
* **Belegt**, richtig: `Releases/PAKETE.md:136` *„Dateiversion und
  Produktversion im Explorer … `EUDORA_BUILD_NUMBER` über
  `Eudora71/VersionBeg.inc`“*; `tools/WERKZEUGE.md:162` misst an der
  *„Versionsressource der ausgelieferten `Eudora.exe`“*.

**Was zu tun wäre:** `:62` auf *„auch in den Dateieigenschaften (Reiter
Details)“*; den Kasten `:97-105` als überholt kennzeichnen — die Warnung
darin gilt jetzt umso mehr.

### <a id="l-95.7"></a>L-95.7 — veraltet: Stand-Köpfe in vier Dateien

**Was passiert:** der Kopf einer Datei sagt, gegen welchen Stand sie gilt.
Vier Köpfe stehen mehrere Fassungen zurück; bei PAKETE heißt das, die Datei
verschweigt im Kopf ihren eigenen neuesten Abschnitt.

* **Belegt**, `Releases/PAKETE.md:6` *„Stand 29.10.2026 (Nummern bis 1.0.127
  verzeichnet, geschnürt ist bis 1.0.127 …“* — `:180` verzeichnet 7.2.1.128.
* **Belegt**, `tools/WERKZEUGE.md:3` *„**Stand 7.2.0.122 / Paket 1.0.122.**“*
  — in derselben Datei beschreiben `:54`, `:161` das Schema vom 29.10.
* **Belegt**, `Intern/EINSTELLUNGEN.md:3-4`: geprüft gegen 7.2.0.68, der
  Kopf nennt als heutigen Stand *„inzwischen **7.2.0.73 / 1.0.73**“* — der
  Abschnitt `#abweichungen` derselben Datei ist vom 29.10.2026 (`:248`).
  **Gemessen nebenbei:** `doku-pruefen.pl` meldet genau diesen Kopf als
  MANGEL, wenn er in **einer** Zeile steht (so in einem Entwurf dieses
  Berichts), aber nicht in EINSTELLUNGEN selbst, wo der Umbruch zwischen
  *„Der Quellstand ist“* und *„inzwischen“* liegt. **Vermutung**, nicht am
  Werkzeug nachgelesen: die Prüfung liest zeilenweise.
* **Belegt**, `Intern/PORTIERUNG.md:44` jüngster Standblock *„Stand
  23.10.2026 … Quellstand **7.2.0.122**, `VERSION` **1.0.122**“*.

**Was zu tun wäre:** die vier Köpfe nachziehen; bei EINSTELLUNGEN sagen,
welcher Teil am 29.10. neu nachgesehen ist und welcher nicht.

## Release 7.2.1.128: Buchführung und Testplan

### <a id="l-95.8"></a>L-95.8 — Beleg fehlt im Repo: Gregors Bestätigung vom 29.10. steht nur in einer Commit-Nachricht

**Was passiert:** PAKETE und CHANGELOG berufen sich für *„Endnummer zählt
weiter“* und *„Titelzeile ohne / Paket“* auf **Entscheidung 10**. Die steht
in WEITERMACHEN mit Datum 26.10.2026 und sagt keines von beiden; die
Bestätigung vom 29.10. mit ihren drei Punkten steht nur in `a5febb70`. Der
Schlusssatz *„werden … umgestellt“* ist nicht als eingelöst vermerkt (und
nicht ganz eingelöst, [L-95.4](#l-95.4)).

* **Belegt**, `Intern/WEITERMACHEN.md:131` *„**Entschieden von Gregor am
  26.10.2026:** … das Release heißt überall **7.2.1.N** … Testpakete bleiben
  7.2.0.N …“*; `grep -i endnummer Intern/WEITERMACHEN.md`: 0 Treffer
  (gemessen).
* **Belegt**, Berufung: `Releases/PAKETE.md:48-55` *„(Gregors Entscheidung 10
  …) … Die **Endnummer zählt über beide Formen weiter**“*; `CHANGELOG.md:136`
  *„(Gregors Entscheidung 10, am 29.10.2026 bestätigt)“*.
* **Gemessen**, `git show a5febb70`: *„Gregors Entscheidung 10, am 29.10.2026
  bestaetigt (1. Titelzeile ohne "/ Paket", 2. VERSION traegt die ganze
  Nummer, 3. Endnummer zaehlt weiter …)“*.

**Was zu tun wäre:** an Entscheidung 10 einen Nachtrag *„Bestätigt und
präzisiert am 29.10.2026“* mit den drei Punkten und Gregors Wortlaut; den
Umstellungssatz mit Stand.

### <a id="l-95.9"></a>L-95.9 — veraltet: der Einstieg in WEITERMACHEN nennt als Nächstes, was `a5febb70` und `640e1a0e` erledigt haben

**Was passiert:** der *„ALS ERSTES“*-Block ist von vor den beiden letzten
Commits; die Tabelle direkt darunter ist nachgezogen. Wer einsteigt, liest
zuerst *„Versionsnummer, Werkzeuge umstellen“* als offen.

* **Belegt**, `Intern/WEITERMACHEN.md:7` *„**als Nächstes das Release 7.2.1
  schnüren** (Versionsnummer, Werkzeuge von `1.0.x` umstellen, Paket,
  Prüfbericht)“* gegen `:11` *„**7.2.1.128** … am 29.10.2026 vergeben“* und
  `CHANGELOG.md:136` (Werkzeuge umgestellt).
* **Belegt**, Nebenbefund: `Intern/WEITERMACHEN.md:11`, Zelle *Quellstand*
  zu **7.2.1.128**, endet mit *„**Geschnürt als Paket 1.0.122**, von Gregor am
  23.10.2026 geprüft“* — ein Satz aus der Kette der Vorgänger, der hinter der
  ganzen Aufzählung wie eine Aussage über die Zeile selbst steht.

**Was zu tun wäre:** `:7` auf den Stand nach `b74a1e81` — Nummer vergeben,
Werkzeuge umgestellt, Prüfbericht BESTANDEN, Paket geschnürt; als Nächstes
Gregors Test, dann `v7.2.1.128` (siehe auch [L-95.15](#l-95.15)); den Satz
in `:11` zu 7.2.0.122 ziehen.

### <a id="l-95.10"></a>L-95.10 — widersprüchlich: E-87/E-88 sind seit dem 29.10. von Gregor bestätigt, zwei Stellen sagen das Gegenteil

**Was passiert:** BEFUNDE und das Ergebnis im TESTPLAN führen
[E-87](../Intern/BEFUNDE.md#e-87) und [E-88](../Intern/BEFUNDE.md#e-88)
(weitergeleitete HTML-Mail kommt wie das Original an) als *„von Gregor am
29.10.2026 an 1.0.127 bestätigt“*. WEITERMACHEN führt [E-88](../Intern/BEFUNDE.md#e-88) weiter als *„VON
GREGOR ZU PRÜFEN“*, und der TESTPLAN-Abschnitt selbst beginnt mit *„bestätigt
hat es noch niemand“* — vierzehn Zeilen über dem Ergebnis *„bestanden“*.
Die Überschrift heißt weiter *„Am Release 7.2.1 außerdem“*; dass der Schritt
am Release entfällt, sagt seit `b74a1e81` nur der Kopfkasten.

* **Belegt**, `Intern/WEITERMACHEN.md:46` *„**VON GREGOR ZU PRÜFEN,
  14.09.2026** | **[E-88](../Intern/BEFUNDE.md#e-88) …** **am laufenden
  Programm noch nicht bestätigt.**“*
* **Belegt**, `Intern/TESTPLAN.md:40` (Überschrift), `:42` *„Beide gelten
  seit September als behoben, bestätigt hat es noch niemand.“* gegen `:56`
  *„**Ergebnis 29.10.2026, an 1.0.127 … : bestanden.**“* und `:9-10`
  *„[E-87/E-88](#e-87-am-release) ist schon bestanden“*.
* **Belegt**, `Intern/BEFUNDE.md`, Zeilen [E-87](../Intern/BEFUNDE.md#e-87) und [E-88](../Intern/BEFUNDE.md#e-88) *„von Gregor am
  29.10.2026 an 1.0.127 bestätigt“*.

**Was zu tun wäre:** WEITERMACHEN:46 auf **BESTÄTIGT 29.10.2026 an
1.0.127**; TESTPLAN:42 streichen, die Überschrift auf *„bestanden an
1.0.127“*.

### <a id="l-95.11"></a>L-95.11 — widersprüchlich: TESTPLAN sagt „nur ein Schritt“, ZIEL.md verlangt vor der Marke alle neun Kriterien; Reste des alten Plans verweisen auf einen „übrigen Release-Test“

**Was passiert:** Gregor testet nur, was im TESTPLAN steht. Seit `b74a1e81`
sagt der Kopfkasten richtig, wo das Paket liegt und welche Titelzeile es
zeigt (`Eudora 7.2.1.128+640e1a0e …`, ohne *„/ Paket“*), und: *„Zu prüfen
ist nur ein Schritt“* — [E-166](../Intern/BEFUNDE.md#e-166). ZIEL.md, der Maßstab, verlangt vor der Marke
*„Gregors Test aller neun Kriterien an einem frischen Paket“*; Teil M des
TESTPLAN heißt *„vor dem Release 7.2.1 zu fahren“*. Die Begründung im
Kasten (*„seitdem ist im Programm nur [E-166](../Intern/BEFUNDE.md#e-166) dazugekommen“*, gemessen in
PAKETE) ist ein Argument — aber eines, das ZIEL.md nicht vorsieht und das
dort nicht nachgezogen ist. Zwei Stellen darunter sind vom alten Plan
übrig: der E-166-Abschnitt nennt einen *„übrigen Release-Test“*, den es
nicht gibt, und die nächste Überschrift heißt *„Was jetzt zu testen ist —
Testpaket 7.2.0.127“*.

* **Belegt**, `Intern/TESTPLAN.md:3-16` *„**Jetzt zu testen: das Release
  7.2.1.128** … Die Titelzeile muss `Eudora 7.2.1.128+640e1a0e 2026-10-29
  12:36` zeigen. … **Zu prüfen ist nur ein Schritt:**“*.
* **Belegt**, `ZIEL.md:94-95` *„dann Gregors Test aller neun Kriterien an
  einem frischen Paket, erst danach die Marke“*; `Intern/TESTPLAN.md:766`
  *„Teil M — Manuelle Fälle, die **vor dem Release 7.2.1** zu fahren sind“*.
* **Belegt**, `Intern/TESTPLAN.md:20-21` *„**zuerst**, in einem frisch
  ausgepackten Release-Verzeichnis, vor dem übrigen Release-Test“*;
  Überschriften `:17`, `:40`, `:68` … — keine für einen weiteren
  Release-Test (gemessen, `grep '^## '`); `:68` *„Was jetzt zu testen ist —
  Testpaket 7.2.0.127 (Kurztest)“*.
* Gegenprobe zum Auftrag (gemessen): **keine** Datei stellt 7.2.1.128 als
  **getestet oder veröffentlicht** dar — `CHANGELOG.md:106` *„bis dahin ist
  sie **ungetestet**“*, `Releases/PAKETE.md:182` *„nicht veröffentlicht“*,
  `git ls-remote --tags origin`: neueste Marke `v1.0.120`.

**Was zu tun wäre:** Gregors Antwort auf die Frage [unten](#gregor) in
ZIEL.md **oder** im TESTPLAN nachziehen, je nachdem; `:21` *„vor dem
übrigen Release-Test“* streichen; `:68` auf *„Kurztest 7.2.0.127 —
bestanden“*.

### <a id="l-95.12"></a>L-95.12 — falsch und verrutscht: die Abweichungsliste in EINSTELLUNGEN widerspricht ihrem eigenen ersten Satz, die Zeilenangaben stehen bis zu 22 Zeilen daneben

**Was passiert:** der Abschnitt, auf den FAQ 19 und README für *„was ist
anders als im Original“* zeigen, beginnt mit *„Die eingebauten Vorgaben in
`EudoraRes.rc` sind dieselben wie im Original 7.1“* — und nennt dann zwei
eingebaute Vorgaben, die diese Portierung in `EudoraRes.rc` geändert hat.
Die Zeilen in `EudoraRes.rc`, *„nachgesehen am 29.10.2026“*, stimmen
großenteils nicht mehr; die Datei ist gewachsen.

* **Gemessen**, `git diff 567a5d87 HEAD -- Eudora71/Eudora/EudoraRes.rc`:
  29 Zeilen hinzu, 6 weg, darunter die Zeichenkette `TabooHeaders` (28 → 44
  Einträge), `MessageStyleSheet` (+ `SPAN.EUDORAHEADER`) und die neuen
  Schlüssel `KeepHTMLInResponses`, `ForwardOriginalHTML`.
* **Belegt**, `Intern/EINSTELLUNGEN.md:180-182` *„Die **eingebauten** Vorgaben
  in `EudoraRes.rc` sind dieselben wie im Original 7.1 (verglichen am
  29.10.2026 …)“* gegen `:239` *„`TabooHeaders` … hier **44** Einträge, im
  Original 28“* und `:243-246` *„`MessageStyleSheet` … mit einer zusätzlichen
  Regel … (`EudoraRes.rc:8152`“*.
* **Gemessen**, Zeilen (genannt → tatsächlich): `KeepHTMLInResponses`
  `:7667` → `7685` (`EINSTELLUNGEN.md:165`, `:231`); `ForwardOriginalHTML`
  `:7668` → `7686` (`:166`, `:234`); `LogFileName`/`LogLevel`/`LogFileSize`
  `8440`–`8442` → `8462`–`8464` (`:156-158`); `MaxConcurrentTasks` `8634` →
  `8656` (`:160`); `ShowAllHeaders` `8667` → `8689` (`:159`);
  `MessageStyleSheet` `8130` → `8152` (`:161`); `TabooHeaders` `9996` →
  `10018` (`:162`; in `:9996` steht eine MAPI-Fehlermeldung); `AccountDir`
  `10439` → `10461` (`:109`). Richtig: `:246` `8152`.

**Was zu tun wäre:** den Einleitungssatz auf *„dieselben wie im Original,
außer `TabooHeaders` und `MessageStyleSheet`; neu sind …“*; die Zeilen neu
messen (`grep -n` je Schlüssel) — die Zahlen in der Tabelle `:156-166` und
in der Liste stammen aus verschiedenen Ständen.

### <a id="l-95.13"></a>L-95.13 — unvollständig: der CHANGELOG-Abschnitt 7.2.1.128 nennt drei von neun berichtigten Release-Texten und die Dokumentenprüfungen nur bis LEKTOR-93

**Was passiert:** der Abschnitt ist der Inhalt des ersten Release. Er meldet
die Berichtigung der Release-Texte auf GitHub nur für die ersten drei
(Entscheidung 17), nicht für die sechs aus Entscheidung 19, und die
eingearbeiteten Prüfungen nur bis [LEKTOR-93](LEKTOR-93.md#lektor-93), obwohl [LEKTOR-94](LEKTOR-94.md#lektor-94) in diesem
Abschnitt eingearbeitet wurde (`528a1589`, `4b8a24b5`).

* **Belegt**, `CHANGELOG.md:128` *„Die veröffentlichten Release-Texte
  `v1.0.113`, `v1.0.117` und `v1.0.120` … am 29.10.2026 berichtigt“* gegen
  `Intern/WEITERMACHEN.md:140` (Entscheidung 19: `v1.0.72`, `v1.0.84`,
  `v1.0.2`, `v1.0.3`, `v1.0.10`, `v1.0.43`).
* **Belegt**, `CHANGELOG.md:129` *„Dokumentenprüfungen
  [LEKTOR-90](../Befunde/LEKTOR-90.md) bis
  [LEKTOR-93](../Befunde/LEKTOR-93.md) eingearbeitet“*.

**Was zu tun wäre:** *„… und sechs ältere (Entscheidung 19)“*; *„[LEKTOR-90](LEKTOR-90.md#lektor-90)
bis [LEKTOR-95](#lektor-95)“* nach dem Einarbeiten dieses Berichts.

### <a id="l-95.14"></a>L-95.14 — Datenschutz, Rest aus L-94.4: zwei gekürzte Betreffzeilen in einem Protokollauszug

**Was passiert:** Entscheidung 18 lässt Firmennamen von Werbe-Absendern
stehen, **nicht** Betreffzeilen. In einem Protokollauszug im CHANGELOG
stehen zwei Betreffzeilen in gekürzter Form, eine davon die einer
weitergeleiteten Mail (keine Werbung).

* **Gemessen**, Kategorie *Betreffzeile, gekürzt, in Protokollzeile*:
  `CHANGELOG.md:4344`, `:4345` (je das letzte Feld der Zeile).
* **Belegt**, `Intern/WEITERMACHEN.md:139` *„Alles andere aus seinem
  Postfach (Betreffzeilen, …) kommt nicht ins öffentliche Repo“*.

**Was zu tun wäre:** das letzte Feld beider Zeilen durch `"<Betreff>"`
ersetzen; die Messung (Match 1 gegen Match 0) hängt nicht daran.

### <a id="l-95.15"></a>L-95.15 — seit `b74a1e81` falsch: vier Standzeilen sagen „noch nicht geschnürt“

**Was passiert:** das Paket 7.2.1.128 ist geschnürt und liegt bei Gregor;
der Commit dazu hat PAKETE (Abschnitt) und TESTPLAN nachgezogen, aber nicht
die Standzeilen der führenden Dateien und nicht den Kopf von PAKETE selbst.
Wer die README liest, hält das Paket für nicht vorhanden.

* **Gemessen**, `git show --stat b74a1e81`: geändert `Intern/TESTPLAN.md`,
  `Releases/PAKETE.md`, Prüfstandsdaten, `tools/AGENTEN-LAUFEN.md`,
  `tools/TESTLAEUFE.md` — nicht README, WEITERMACHEN, AUFGABEN.
* **Belegt**, `README.md:103` *„erstes Release 7.2.1, noch nicht geschnürt und
  noch nicht von Gregor getestet“*; `Intern/WEITERMACHEN.md:14`
  *„**7.2.1.128** (`VERSION`, gleich dem Quellstand), noch nicht
  geschnürt“*; `Intern/AUFGABEN.md:3` *„… mit der Behebung von [E-166](../Intern/BEFUNDE.md#e-166), noch
  nicht geschnürt“*; `Releases/PAKETE.md:6` *„Nummern bis 1.0.127
  verzeichnet, geschnürt ist bis 1.0.127“*.
* **Belegt**, Gegenstück: `Releases/PAKETE.md:182` *„**Geschnürt am
  29.10.2026 und als Testverzeichnis abgelegt; nicht veröffentlicht.**“*,
  ZIP mit SHA-256 in `:187`.

**Was zu tun wäre:** die vier Zeilen auf *„geschnürt am 29.10.2026, liegt
bei Gregor, ungetestet“* — im selben Zug wie jede künftige Änderung des
Paketstands ([Doku parallel berichtigen](../Arbeitsweise/doku-parallel-nicht-hinterher.md)).

---

## Geprüft ohne Fund

* **Standzeilen zu 7.2.1.128**, außer *„noch nicht geschnürt“*
  ([L-95.15](#l-95.15)): `README.md:103`, `Intern/AUFGABEN.md:3`,
  `Intern/TESTPLAN.md:1`, `Intern/WEITERMACHEN.md:11`, `:14` nennen
  7.2.1.128, *„ungetestet“* und *„veröffentlicht ist `v1.0.120`“* — passt zu
  `git ls-remote --tags` und `gh release list` (neueste `v1.0.120`,
  gemessen).
* **`Version.h` und `VERSION`** (gemessen): `EUDORA_VERSION3 1`,
  `EUDORA_VERSION4 128`, `EUDORA_BUILD_NUMBER 7,2,1,128`, `EUDORA_BUILD_DESC
  "Version 7.2.1.128\0"`, `EUDORA_BUILD_VERSION "7.2.1.128"`, `VERSION`
  `7.2.1.128` — die sechs Zeilen aus `Releases/PAKETE.md:91-95` stimmen.
* **PAKETE, Kasten unter „Drei Zählungen“** (`:48-58`) und Abschnitt
  7.2.1.128 (`:180-194`): inhaltlich richtig, außer [L-95.5](#l-95.5),
  [L-95.6](#l-95.6), [L-95.7](#l-95.7), [L-95.15](#l-95.15). Die
  Rollenzeile (`:192`) sagt offen, dass der LEKTOR beim Schnüren noch lief.
* **FAQ** (19 Fragen, `Doku/FAQ.md:26-352`): keine Aussage zum Nummernschema;
  Fassungsangaben sind Prüfdaten (*„an Paket 1.0.127 geprüft“*) und damit
  richtig in der alten Form. Frage 19 verweist auf
  `EINSTELLUNGEN.md#abweichungen` — der Anker steht (`Intern/EINSTELLUNGEN.md:178`).
* **ZIEL.md** (`:94-96`): Release *„`7.2.1.<laufende Buildnummer>`“*, Marke
  `v7.2.1.<n>` — passt zu 7.2.1.128.
* **`README.en.md`**: nennt keine Fassung, nur *„the version shown in the
  window title“* (`:51`) — vom Schemawechsel nicht betroffen.

## Nicht geprüft

* Die Werkzeuge selbst über `ausliefern.pl` hinaus; ihre Selbsttests laut
  `a5febb70` nicht nachgefahren.
* `Releases/*/RELEASE-NOTIZEN.md` und `ISSUE-102-*.md` — Abschriften
  veröffentlichter Texte, nur auf Schemaaussagen überflogen (keine).
* Die Abschnitte von `Intern/BEFUNDE.md`, `Intern/LEKTORAT.md` und der
  Teile A–D des TESTPLAN, die nicht vom Nummernschema handeln.
* Nichts am laufenden Programm, kein Bau.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Was du an 7.2.1.128 testest, bevor die Marke gesetzt wird**
  ([L-95.11](#l-95.11), bisher [L-74.10](LEKTOR-74.md#l-74.10)). ZIEL.md
  sagt: alle neun Kriterien an einem frischen Paket; der TESTPLAN sagt seit
  heute *„Zu prüfen ist nur ein Schritt“* — [E-166](../Intern/BEFUNDE.md#e-166) (die Junk-Frage kommt nur
  einmal), weil sich gegenüber 1.0.127 im Programm nur [E-166](../Intern/BEFUNDE.md#e-166) geändert hat.
  Reicht dir das (dann wird ZIEL.md angepasst), oder willst du an 7.2.1.128
  die neun Kriterien oder Teil M (fremdes Mailverzeichnis, Suchindex,
  Ziehen nach `Out`) fahren?
* **Wie ein Zweig heißt, der nur eine Fassung schnürt** ([L-95.3](#l-95.3)):
  bisher `release_1.0.NN`, für 7.2.1.128 `release-7.2.1`. Künftig
  `release-7.2.1` weiterverwenden, `release-7.2.1.N` oder anders?
* Unverändert offen: Kriterium 0 ohne Visual Studio
  ([L-77.3](LEKTOR-77.md#l-77.3)).
