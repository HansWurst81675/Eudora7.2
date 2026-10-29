# <a id="lektor-97"></a>LEKTOR-97 — Nachlauf zu LEKTOR-96 nach der Einarbeitung `deef1493`, 29.10.2026

**Auftrag.** Kurzer Nachlauf, kein voller Durchgang: was aus den neun Funden
von [LEKTOR-96](LEKTOR-96.md#lektor-96) wurde, ob `deef1493` (*„[LEKTOR-96](LEKTOR-96.md#lektor-96)
eingearbeitet; [E-166](../Intern/BEFUNDE.md#e-166) am Laptop bestanden“*) neue Unstimmigkeiten gebracht
hat, und die sieben Tabellenzeilen aus [L-96.2](LEKTOR-96.md#l-96.2) noch
einmal an GitHubs Markdown-Dienst. Gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor` auf `wt/lektor-20261029g` = `origin/release-7.2.1`
(`deef1493`). **Alle Zeilenangaben gelten für `deef1493`.** Nichts gebaut,
nichts gestartet, kein Prüfstand, Gregors Testverzeichnisse nicht berührt.

**In diesem Bericht steht nichts aus Gregors Postfach.**

**Ergebnis vorweg.** Von den 9 Funden aus [LEKTOR-96](LEKTOR-96.md#lektor-96) sind **6 erledigt**,
**1 teilweise** ([L-96.1](LEKTOR-96.md#l-96.1)), **2 verschoben** nach dem
Release ([L-96.3](LEKTOR-96.md#l-96.3), [L-96.6](LEKTOR-96.md#l-96.6), mit Gregors Plan in der Commit-Nachricht). Die
sieben abgeschnittenen Tabellenzeilen kommen jetzt **ganz** bei GitHub an.
**3 neue Funde**, alle klein, keiner hält das Release auf: die
[E-166](../Intern/BEFUNDE.md#e-166)-Befundzeile nennt Gregors Test noch als
fehlend, obwohl sie ihn zwei Sätze vorher bestätigt ([L-97.1](#l-97.1)); der Kopf des
TESTPLAN spricht weiter in der Zukunft ([L-97.2](#l-97.2)); der neue Laptop-Abschnitt
sagt „Verhalten des Originals“ ohne Zeile und ohne Art des Belegs ([L-97.3](#l-97.3)).

---

## Funde aus LEKTOR-96

| Fund | Was es war | Heute | Beleg (heutiger Stand) |
|---|---|---|---|
| [L-96.1](LEKTOR-96.md#l-96.1) | 12 Stellen sagten, Gregors Test an 7.2.1.128 stehe aus | **teilweise** — die zwölf Standzeilen stimmen, Reste in BEFUNDE und TESTPLAN → [L-97.1](#l-97.1), [L-97.2](#l-97.2) | `README.md:103` *„von Gregor am 29.10.2026 getestet“*; `ZIEL.md:186`; `ZIEL.md:42-47` *„An der Release-Fassung selbst geprüft … bestätigte sie am 29.10.2026 auf Hauptrechner und Laptop“*; `Intern/PORTIERUNG.md:44`; `Releases/PAKETE.md:6`, `:183`; `Intern/AUFGABEN.md:3`; `CHANGELOG.md:109`, `:113`; `Intern/WEITERMACHEN.md:14`; `Intern/TESTPLAN.md:3` *„Getestet am 29.10.2026“*; VM-Abschnitt `:79` ohne „Zwischenstand“ (alle belegt) |
| [L-96.2](LEKTOR-96.md#l-96.2) | GitHub schnitt 7 Tabellenzeilen ab | **erledigt** | gemessen, siehe [unten](#tabellen) |
| [L-96.3](LEKTOR-96.md#l-96.3) | `pruefe-tabellenzeilen.pl` blind für `\|` in Code | **verschoben** (nach dem Release, `deef1493`) | — |
| [L-96.4](LEKTOR-96.md#l-96.4) | [E-173](../Intern/BEFUNDE.md#e-173) (Labels bei *Make Label* einmal ausgegraut) fehlte in README, CHANGELOG, FAQ | **erledigt** | `README.md:168` *„stehen die Labels **einmal ausgegraut** da“*; `CHANGELOG.md:121`; `Doku/FAQ.md:202` (belegt) |
| [L-96.5](LEKTOR-96.md#l-96.5) | Strg+J-Zeilen ~490 Zeilen daneben | **erledigt** | gemessen: `mainfrm.cpp:8398` *„void CMainFrame::InitJunkMenus()“*, `:8490` *„}“*; `EudoraRes.rc:8756` *„CtrlJMapping\n0“*, `:4735` `IDD_CTRL_J_FOR_JUNK`; `JunkMail.h:61-63` die drei `CTRL_J_*` — wie in `Intern/FILTER.md` und `Intern/EINSTELLUNGEN.md` genannt |
| [L-96.6](LEKTOR-96.md#l-96.6) | `pruefbericht.pl` kündigt eine Ergebnistabelle an, die fehlt | **verschoben** (nach dem Release, `deef1493`) | — |
| [L-96.7](LEKTOR-96.md#l-96.7) | „Liste“ statt „Tabellen“, CHANGELOG-Spalte „Herkunft“ | **erledigt** | `grep -n Liste` mit „abweich“/„Tabelle“ in README, EINSTELLUNGEN, FAQ: 0 Treffer; „Herkunft“ im CHANGELOG nur noch an fremden Stellen (`:711`, `:983`) (gemessen) |
| [L-96.8](LEKTOR-96.md#l-96.8) | ZIEL: Skript kenne nur `v1.0.<n>` | **erledigt** | `ZIEL.md:101` *„`release-veroeffentlichen.ps1` ist am 29.10.2026 darauf umgestellt (`a5febb70` …)“* (belegt) |
| [L-96.9](LEKTOR-96.md#l-96.9) | PAKETE empfahl `ausliefern.pl --pruefen` ohne Warnung | **erledigt** | `Releases/PAKETE.md:120` *„liest Gregors Testverzeichnisse, nur mit seiner Zustimmung (WERKZEUGE.md)“* (belegt) |

## <a id="tabellen"></a>Die sieben Tabellenzeilen an GitHubs Markdown-Dienst (gemessen)

Je Kopf-, Trenn- und Datenzeile an `gh api -X POST markdown` (`mode=gfm`).
In allen sieben Zeilen steht in Codespannen kein ungeschütztes `|` mehr;
das letzte Wort der Zeile kommt im HTML an, die Zahl der `<td>` gleicht der
der Kopfzellen.

| Stelle | letzte Worte, im HTML gefunden |
|---|---|
| `Intern/BEFUNDE.md:348` ([E-101](../Intern/BEFUNDE.md#e-101)) | *„unbrauchbar“* |
| `Intern/BEFUNDE.md:371` ([E-125](../Intern/BEFUNDE.md#e-125)) | *„Nachricht“* |
| `Intern/BEFUNDE.md:403` ([E-138](../Intern/BEFUNDE.md#e-138)) | *„gestartet“* |
| `tools/WERKZEUGE.md:64` | *„Am Bestand weiter 10 Aufrufe, 0 ungeprüft</td>“* |
| `tools/WERKZEUGE.md:85` | *„wörtlich“* |
| `tools/WERKZEUGE.md:125` | *„Selbsttest 27 Fälle</td>“* |
| `tools/ZWEIGE.md:148` | *„verloren“* |

Dazu die durch `deef1493` geänderte E-166-Zeile `Intern/BEFUNDE.md:389`:
ebenfalls 0 ungeschützte Pipes, kommt ganz an.

## Mechanisch (gemessen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | *„Kein Widerspruch gefunden.“*; in der Kenntnisliste u. a. *„tools/ZWEIGE.md nennt weder den Quellstand 7.2.1.128 noch die Paketnummer …“* — unverändert gegen [LEKTOR-96](LEKTOR-96.md#lektor-96) |
| `perl tools/pruefe-tabellenzeilen.pl` | *„pruefe-tabellenzeilen: 379 Dateien, keine gebrochene Tabellenzeile.“* — für die Art aus [L-96.2](LEKTOR-96.md#l-96.2) weiter blind ([L-96.3](LEKTOR-96.md#l-96.3), verschoben); heute stimmt die Aussage trotzdem, siehe oben |

---

## Neue Funde

### <a id="l-97.1"></a>L-97.1 — Widerspruch in einer Zeile: die E-166-Befundzeile meldet Gregors Test als bestätigt und zugleich als fehlend

**Was passiert:** wer in `Intern/BEFUNDE.md` nachsieht, was an
[E-166](../Intern/BEFUNDE.md#e-166) (Konto-Eigenschaften verloren
Einstellungen, die Junk-Frage kam wieder) noch zu tun ist, liest, Gregors
Test an der Release-Fassung stehe aus — in derselben Zeile, die ihn
weiter vorn als bestanden einträgt. `deef1493` hat die Zeile ergänzt, das
Ende nicht nachgezogen.

* **Belegt**, `Intern/BEFUNDE.md:389`, vorn: *„**von Gregor am 29.10.2026 an
  Paket 7.2.1.128 auf seinem Hauptrechner bestätigt** … ebenso am Laptop“*.
* **Belegt**, dieselbe Zeile, hinten: *„**Was noch fehlt:** Gregors Test
  **an der Release-Fassung 7.2.1** statt an einem eigenen Testpaket“* und
  *„**GREGOR** — Schritt [TESTPLAN#e-166-am-release]“*.

**Was zu tun wäre:** „Was noch fehlt“ auf *nichts mehr am Programm; offen
nur K4 (Antwort bis zum Beenden nur im Speicher), bewusst nicht behoben*
und „Wie zu prüfen“ in die Vergangenheit.

### <a id="l-97.2"></a>L-97.2 — Rest von L-96.1: der TESTPLAN-Kopf sagt „Getestet“ und spricht darunter weiter vom kommenden Test; WEITERMACHEN nennt den Laptop nur an einer von zwei Stellen

**Was passiert:** Zeile 3 meldet den Test als erledigt, die Zeilen darunter
fordern Gregor noch zum Prüfen auf. Wer den Kopf liest, weiß nicht, ob noch
etwas von ihm erwartet wird.

* **Belegt**, `Intern/TESTPLAN.md:1` *„Stand 29.10.2026 (Prüfschritt zu
  [E-166](../Intern/BEFUNDE.md#e-166) zuerst)“*; `:3` *„**Getestet am 29.10.2026: das Release
  7.2.1.128**“*; `:11-12` *„**Was du darüber hinaus prüfst, entscheidest
  du**“*; `:16-17` *„Deine Ergebnisse kommen hierher. Erst mit deinem Ja
  wird es als `v7.2.1.128` veröffentlicht.“* Der letzte Satz ist richtig
  (das Ja fehlt), die beiden davor nicht mehr.
* **Belegt**, `Intern/WEITERMACHEN.md:7` *„**Gregors Test ist durch:** [E-166](../Intern/BEFUNDE.md#e-166)
  auf seinem Hauptrechner bestanden“* — ohne Laptop; `:14` *„[E-166](../Intern/BEFUNDE.md#e-166) auf
  Hauptrechner und Laptop bestanden“*.

**Was zu tun wäre:** Titel ohne „Prüfschritt zuerst“, die Sätze
`:11-17` in die Vergangenheit bis auf *„Erst mit deinem Ja …“*;
WEITERMACHEN:7 um den Laptop ergänzen.

### <a id="l-97.3"></a>L-97.3 — neuer Laptop-Abschnitt: „das Verhalten des Originals“ ohne Zeilenangabe und ohne Art des Belegs

**Was passiert:** der Abschnitt
[`ergebnis-e-166-laptop`](../Intern/TESTPLAN.md#ergebnis-e-166-laptop)
erklärt, warum die Junk-Frage erst bei der sechsten Sitzung kam, und
schließt *„Das ist das Verhalten des Originals“*. Am Original-Programm
gemessen ist das nicht; die Aussage stützt sich auf den Quelltext, und der
ist ohne Zeile genannt.

* **Belegt**, `Intern/TESTPLAN.md:34` *„(`eudora.cpp`,
  `!pJunkList->IsEmpty() && (askedBits&introAsked)==0`)“* — ohne Zeile;
  gemessen: die Bedingung steht in `Eudora71/Eudora/eudora.cpp:1792`.
* **Gemessen**, `git log -S'(askedBits&introAsked)==0'`: einziger Treffer
  `567a5d87` *„initial commit mit den original sourcen“* — die Bedingung ist
  unverändert aus dem Original, die Aussage also **am Quelltext belegt**,
  nicht am Original-Programm gemessen.
* **Belegt**, `Intern/TESTPLAN.md:45` *„Das ist das Verhalten des Originals:
  Die Frage gehört zum ersten Start mit einem Junk-Werkzeug“*.

**Was zu tun wäre:** `eudora.cpp:1792` einsetzen und *„(am Quelltext
belegt, Bedingung seit dem Original unverändert)“* anhängen.

---

**Nicht erneut gemeldet:** die Frage aus [LEKTOR-96](LEKTOR-96.md#lektor-96), ob Gregors Test schon
sein Ja zu `v7.2.1.128` ist, steht weiter offen (`Intern/TESTPLAN.md:17`
*„Erst mit deinem Ja“*); sie ist dort richtig gestellt.
