# Lektorat der Dokumentation

**Diese Datei ist ein Fahrtenbuch, kein Statusbericht.** Sie sammelt die
Durchgänge des Agenten LEKTOR in zeitlicher Folge — jeder Abschnitt gilt für
seinen Tag, nicht für heute. Was **jetzt** gilt, steht in [ZIEL.md](ZIEL.md),
[README.md](README.md) und [CHANGELOG.md](CHANGELOG.md).

Hier stehen der erste bis vierte, der sechste und der siebte Durchgang. Der
**fünfte** steht nicht hier, sondern in [Befunde/LEKTOR.md](Befunde/LEKTOR.md);
die späteren in [Befunde/LEKTOR-2.md](Befunde/LEKTOR-2.md) (L-6),
[Befunde/LEKTOR-3.md](Befunde/LEKTOR-3.md) (L-7),
[Befunde/LEKTOR-4.md](Befunde/LEKTOR-4.md) (L-8, alle 47 MD-Dateien),
[Befunde/LEKTOR-5.md](Befunde/LEKTOR-5.md) (L-9, 41 Befunde am 08.09.2026) und
[Befunde/LEKTOR-6.md](Befunde/LEKTOR-6.md) — dort stehen **L-10** (das
Einarbeiten von L-9, 08.09.2026) und **L-11** (der Stand auf 7.2.0.27 / 1.0.27,
09.09.2026, mit zwei gemessenen Fehlalarmen in `tools/doku-pruefen.pl`).

**Die Reviews des Agenten PRUEFER** liegen daneben:
[Befunde/PRUEFER-3.md](Befunde/PRUEFER-3.md) (P-3),
[Befunde/PRUEFER-4.md](Befunde/PRUEFER-4.md) (P-4, E-37 und die
Exit-Beweisführung) und [Befunde/PRUEFER-5.md](Befunde/PRUEFER-5.md) (P-5, das
Review der Exit-Behebung — dort ist **E-45** gefunden worden).

> **Stand dieser Datei: 09.09.2026.** Der jüngste Durchgang ist **L-11**; er
> steht nicht hier, sondern in
> [Befunde/LEKTOR-6.md](Befunde/LEKTOR-6.md). Gemessen an Quellstand
> **7.2.0.27** / Paket **1.0.27**.

## Erster Durchgang — 30.08.2026

Durchgang vom 30.08.2026 durch den Agenten LEKTOR, Branch
`worktree-agent-a3a787cbbe74cbbe2`, gemessener Ausgangsstand `371c1e3`.

Anlass: Gregors Frage „die ganzen MD sind up to date?". **Antwort: nein, mehrere
waren deutlich veraltet.** Der Durchgang wurde vorzeitig abgebrochen (VM wird
abgeschaltet), ist also **unvollständig** — was noch aussteht, steht unten.

## Kurzantwort

Die Dokumentation behauptete an mehreren Stellen einen Stand, der seit dem
30.08.2026 überholt ist. Der schwerste Fall: **drei Dateien schrieben, es sei
ungeprüft, ob Eudora startet** — es startet seit Befund S-2. Der zweitschwerste:
**Befund S-7 verwies auf eine Anweisung in `README.md`, die dort nicht stand.**
Beides ist berichtigt.

## Was berichtigt wurde

| Datei | Was falsch war | Was jetzt dasteht |
|---|---|---|
| `README.md` | „Noch nicht geprueft ist, ob das Programm startet" — im Stand-Kasten **und** in der Tabelle „Offene Themen" | Eudora startet (S-2), erfüllt aber nur Kriterium 1 aus `ZIEL.md`; S-5, S-6 und der ungeprüfte Mailabruf als eigene Zeilen |
| `README.md` | kein Wort zum frischen Klon, obwohl S-7 ausdrücklich sagt „Steht so in README.md" | neuer Abschnitt „Nach einem frischen Klon" mit den vier Schritten inkl. `zeilenenden-angleichen.pl` und der Begründung (4616 von 5563) |
| `README.md` | die Werkzeuge in `tools/` waren nirgends beschrieben | neuer Abschnitt „Werkzeuge" mit allen 13, samt der **Grenze** von `rekursion-suchen.pl` (Überladungen nur nach Name und Argumentzahl) und dem Hinweis, dass `stapel-untersuchen.ps1` die 32-Bit-PowerShell braucht |
| `README.md` | die Bau-Kennung war nirgends erklärt | neuer Abschnitt „Bau-Kennung in der Titelleiste", Beispiel, Bedeutung des Sternchens, Verweis auf `VERSION` und `kennung-erzeugen.pl` |
| `PORTIERUNG.md` | „Ungeprüft ist, ob das Programm startet" (Z. 27) | startet; Verweis auf S-2 und auf die drei Kriterien |
| `PORTIERUNG.md` | beschrieb `pruefe-bytes.pl` mit der **alten** Funktionsweise („bricht ab, wenn sich die CR-Anzahl geändert hat") | die zwei neuen Regeln (Inhalt gleich/Bytes verschieden; Zeilenende-Wechsel bei unveränderter Zeile), ausdrücklich: CR-Anzahl wird nicht mehr verglichen. Gegen `tools/pruefe-bytes.pl` selbst nachgelesen |
| `PORTIERUNG.md` | `core.autocrlf` nur als Zukunftsvorsorge dargestellt | der Altschaden (S-7) und seine Behebung ergänzt |
| `WEITERMACHEN.md` | „Umgebung herrichten" kannte `zeilenenden-angleichen.pl` nicht | vier Schritte statt zwei, mit S-7 als Begründung |
| `WEITERMACHEN.md` | „Damit ist **git als Fehlerquelle ausgeschlossen**" — stand unmittelbar neben dem Altschaden, den `.gitattributes` gerade **nicht** behebt | auf „für die Zukunft" eingeschränkt; dazu ausdrücklich, dass die frühere Vermutung „mit `autocrlf=true` geklont" **richtig** war und zu Unrecht als widerlegt abgehakt wurde |
| `WEITERMACHEN.md` | „Der nächste Schritt": Frage sei, ob das Programm startet | neue Reihenfolge nach `ZIEL.md`: Kriterium 2 (S-5/S-6), Kriterium 3 (Mailabruf), VC7.1-Laufzeiten, dann `EudoraRes.dll`, libpng, Release-Zweig |
| `STARTUMGEBUNG.md` | „`Eudora.exe` linkt noch nicht und wurde nie gestartet" | Kasten vorangestellt: überholt in den Voraussagen, gültig in der Sache; die fehlende **VC7.1-Laufzeit** ergänzt, die in der Aufstellung gar nicht vorkam |
| `Releases/PAKETE.md` | verlor kein Wort darüber, dass beide ZIP-Namen `lauffaehig` behaupten | Kasten zur Benennung mit Verweis auf `ZIEL.md`; 1.0.2 ausdrücklich als „Kriterium 1 von dreien" |
| `Releases/1.0.2/LIESMICH.txt` | endete mit „Danach steht das Hauptfenster" — kein Hinweis auf S-5/S-6 | neuer Abschnitt „WAS DIESES PAKET NOCH NICHT KANN" mit der Drei-Kriterien-Tabelle und den beiden offenen Befunden |

## Was bewusst stehen geblieben ist

- **Die Dateinamen `Eudora72-1.0.1-lauffaehig.zip` und
  `Eudora72-1.0.2-lauffaehig.zip`.** Beide Pakete sind unter diesem Namen
  veröffentlicht; ein Umbenennen im Repo würde die veröffentlichten Prüfsummen
  unauffindbar machen. Stattdessen steht in `PAKETE.md` und in der `LIESMICH.txt`
  ausdrücklich, dass der Name mehr behauptet, als die Fassung kann.
- **`Releases/1.0.2/LIESMICH.txt` ist bereits ausgeliefert.** Die Berichtigung
  wirkt nur für den Quellbaum und für ein etwaiges Neuveröffentlichen des Anhangs;
  im schon heruntergeladenen ZIP steht die alte Fassung. Das ist hingenommen.
- **Die Zahlen mit Bezugscommit `a807b93`** in `README.md` und `WEITERMACHEN.md`
  (Bauzustand, Zeilenzahlen der Ersatzschicht, Symbolverlauf). Sie sind sauber
  datiert und mit dem Hinweis versehen, dass neu zu messen ist. Nachmessen war in
  der verbleibenden Zeit nicht möglich, und eine ungemessene Aktualisierung wäre
  schlechter als die datierte alte Zahl.
- **`BEFUNDE.md`** — nur gelesen, nichts geändert. Der S-Block (S-1 bis S-7) ist
  auf Stand; die Abschnitte der Agenten BRUECKE (B-1), MENUE (M-1) und ANSICHT
  (A-1) waren zum Zeitpunkt der Prüfung noch nicht vorhanden.
- **`BEFUNDE-ALTBESTAND.md`** — Archiv eines abgeschlossenen Stands; veraltet zu
  sein ist dort kein Mangel.

## Ein Befund, den ich selbst gemacht habe

**Der Kopfkommentar von `tools/pruefe-bytes.pl` beschreibt noch die alte
Funktionsweise.** Zeile 2–4 der Datei:

```
# Prueft jede zum Commit vorgemerkte Datei auf zwei lautlose Schaeden:
#   1. veraenderte Zeilenenden (CR-Anzahl)
```

Der Code darunter zählt seit `371c1e3` keine CR mehr, sondern vergleicht Inhalt
gegen Bytes und die Zeilenenden je Zeileninhalt (`zaehle_enden`,
`enden_je_inhalt`). Der Kommentar ist damit falsch. **Nicht geändert** — die
Datei gehört zum Werkzeugbestand, und eine Änderung an der Commit-Schranke
während drei Agenten parallel committen wollte ich nicht ohne Rückfrage machen.
Zwei Zeilen, wenn jemand sie anfasst.

## Offene Fragen, die ich nicht entscheiden kann

1. **Soll `STARTUMGEBUNG.md` bleiben?** Sie war Vorarbeit für einen Start, der
   inzwischen stattgefunden hat. Ihr Sachgehalt (welche DLL importiert, welche
   nachgeladen wird) ist weiter nützlich, ihre Fragestellung ist erledigt.
   Entweder auf „Laufzeitumgebung" umschreiben oder in `PAKETE.md` aufgehen
   lassen. Ich habe sie nur mit einem Kasten versehen.
2. **Gilt der Satz „Abruf und Versand funktionieren" in `README.md` noch?** Er
   bezieht sich auf `QCSSL.dll` in einer **bestehenden** Eudora-7.1-Installation
   (Release 1.0), nicht auf das selbst gebaute `Eudora.exe`. Nach `ZIEL.md` ist
   Kriterium 3 damit nicht erfüllt. Ich habe den Satz stehen lassen und in der
   Tabelle „Offene Themen" eine Zeile ergänzt, die den Unterschied benennt —
   sauberer wäre, den Satz selbst zu präzisieren.

## Stand und nächster Schritt

**Geprüft und berichtigt:** `README.md`, `PORTIERUNG.md` (die zwei belegten
Stellen), `WEITERMACHEN.md`, `STARTUMGEBUNG.md`, `Releases/PAKETE.md`,
`Releases/1.0.2/LIESMICH.txt`.

**Gelesen, für richtig befunden, nicht geändert:** `ZIEL.md`, `BEFUNDE.md`
(S-Block vollständig gelesen).

**Noch nicht angesehen** — hier geht es weiter:

| Datei | warum sie zu prüfen ist |
|---|---|
| `PORTIERUNG.md`, Rest (rund 850 Zeilen) | nur zwei belegte Stellen berichtigt; der Rest ist ungelesen |
| `Releases/1.0/AUSLIEFERUNGEN.md` | verfolgt die QCSSL-Auslieferungen; `ZIEL.md` verweist darauf für den letzten erfolgreichen Abruf |
| `Releases/1.0/README.md` (268 Zeilen) | beschreibt das QCSSL-Einzelpaket; nennt es womöglich „lauffähig" |
| `Eudora71/OTShim/PLAN.md` (455 Zeilen) | Stufenplan der Ersatzschicht, die seit `e50a89c` vollständig eingehängt ist — vermutlich überholt |
| `Eudora71/OTShim/INVENTAR.md` (201 Zeilen) | Bestandsaufnahme, mehrfach berichtigt |
| `Arbeitsweise/*` (16 Dateien) | insbesondere `lauffaehiges-ergebnis-liefern.md` gegen `ZIEL.md`, und `zeilenenden-nach-jedem-schreibzugriff-messen.md` + `quelldateien-nur-byte-erhaltend-aendern.md` gegen die neue Funktionsweise von `pruefe-bytes.pl` (beide beschreiben noch die CR-Anzahl-Regel — **Verdacht, ungeprüft**) |
| `Eudora71/OpenSSL3/BAUEN.md`, `Eudora71/Tests/QCSSL/README.md` | nicht angesehen |
| `BEFUNDE-ALTBESTAND.md` | als Archiv eingestuft, aber nicht gelesen |
| `tools/patches/zertifikatspruefung-verschaerfen.md` | beschreibt `pruefe-bytes.pl` mit der alten CR-Anzahl-Regel (Z. 105) — **belegt, nicht berichtigt** |

**Der nächste Schritt ist die letzte Zeile der Tabelle plus `Arbeitsweise/`:**
Die alte Funktionsweise von `pruefe-bytes.pl` ist an mindestens vier weiteren
Stellen beschrieben. Suchmuster:

```bash
grep -rn "CR-Anzahl" --include=*.md .
```

---

# Zweiter Durchgang — 31.08.2026, vormittags

Agent LEKTOR, Branch `lektorat-heute`, Ausgangsstand `2cf569f` auf
`darstellung-und-menue`. Anlass: Gregors Frage „wird es alles auch wieder
dokumentiert?"

**Vorbemerkung zum Vorgehen.** Beim ersten Durchgang lief ich *parallel* zu den
Agenten, deren Ergebnisse ich beschreiben sollte — nach neun Minuten fertig,
die anderen nach fünfundzwanzig, meine Arbeit sofort veraltet. Diesmal waren
BRUECKE, MENUE, ANSICHT, POSTBOTE und WERKZEUG bereits **zusammengeführt**.

## Bekannte Lücke

Der Agent **FREIGABE** (Release-Bau) lief noch, als dieser Durchgang endete.
Sein Ergebnis fehlt in allen hier berichtigten Dateien — zwangsläufig, nicht
aus Nachlässigkeit. Es wird die Zeile „Release-Konfiguration" in `README.md`,
Kriterium 0 in `ZIEL.md` und Punkt 2 der nächsten Schritte in `WEITERMACHEN.md`
betreffen. Wer weitermacht, liest zuerst seinen Branch und seinen Abschnitt in
`BEFUNDE.md`.

## Was fehlte und jetzt dasteht

**Der Befund S-8 fehlte in `BEFUNDE.md` ganz.** Der Startfehler `0xc000007b`
war nur im Commit `76efdb6`, in `README.md` und in `Releases/1.0.2/LIESMICH.txt`
festgehalten — in der Datei, die die Befunde sammelt, stand er nicht. Jetzt ans
Ende geschrieben, mit der Abgrenzung zu S-1 (dort lagen die *falschen*
Fremd-DLLs bei, hier fehlte die eigene Laufzeit ganz) und mit dem, was er
**nicht** löst: die vier Debug-DLLs dürfen nicht weiterverteilt werden.

## Was berichtigt wurde

| Datei | Was falsch oder veraltet war | Was jetzt dasteht |
|---|---|---|
| `BEFUNDE.md` | S-8 fehlte | Abschnitt `## S-8` am Ende |
| `ZIEL.md` | die Kriterientabelle kannte **Kriterium 0 nicht**, obwohl der Abschnitt dazu weiter unten in derselben Datei stand | Tabelle mit 0 bis 3; Kriterium 2 und 3 präzisiert |
| `ZIEL.md` | „keines der **drei** Kriterien" | „keines der Kriterien" — es sind vier |
| `ZIEL.md` | der Kasten zu Kriterium 1 nannte S-5 und S-6 als offen | Nachtrag: Ursachen belegt und **im Quelltext behoben** (M-1, A-1), **das ändert am Stand nichts**, solange niemand das laufende Programm gesehen hat |
| `README.md` | Stand-Kasten ohne Kriterium 0 | Tabelle 0 bis 3, ausdrücklich „derzeit ist kein Kriterium erfüllt" |
| `README.md` | „Befunde S-1 bis S-7" | S-1 bis S-8 samt B-1/B-2, M-1, A-1, P-1/P-2, W-1 |
| `README.md`, „Offene Themen" | **„Erster Start von `Eudora.exe` — offen und ungeprüft, ob das Programm läuft"** — dieselbe überholte Behauptung, die im ersten Durchgang schon an zwei anderen Stellen berichtigt wurde; hier war sie stehen geblieben | erledigt seit S-2, mit Verweis auf S-8 für den Fall fehlender Laufzeiten |
| `README.md`, „Offene Themen" | „QCSSL gegen echten Mailserver prüfen — **erledigt**, Abruf und Versand laufen" | präzisiert: der Abruf lief mit einer **älteren** QCSSL in einer bestehenden 7.1-Installation, nicht mit dem selbst gebauten `Eudora.exe`; Kriterium 3 ist **nicht** erfüllt. Das war die offene Frage 2 aus dem ersten Durchgang |
| `README.md`, „Offene Themen" | „Release-Konfiguration: für QCSSL gebaut" | dazu die Berichtigung aus B-2: Paket 1.0.2 ist **gemischt**, nicht durchgehend Release |
| `README.md`, „Offene Themen" | S-5, S-6, Kriterium 0 und die Produktversion kamen gar nicht vor | vier neue Zeilen |
| `README.md`, Werkzeuge | acht der achtzehn Werkzeuge fehlten in der Liste: `paket-bauen.ps1`, `paket-pruefen.ps1`, `suche-zeiger.pl`, `vc71-bruecke-messen.pl`, `hooks-einrichten.sh`, `lehren-spiegeln.pl`, `pruefstand-melden.pl`, `ungesichertes-melden.pl` | vollständige Liste, gegen den Inhalt von `tools/` abgeglichen |
| `README.md`, Bauen | der Einzelprojekt-Bau war als funktionierend beschrieben | Kasten: im frischen Klon scheitert er an `imap.lib`, weil `Lib/` von `.gitignore` erfasst ist (belegt in `BEFUND-ANSICHT.md`, „Bauzustand"); nach einem Gesamtbau bindet er durch (B-2). Dazu: MSBuild muss aus PowerShell kommen |
| `README.md` | „3 Fehler aus `OT501`" ohne Bezugsdatum | am 31.08.2026 mit eingehängtem `VC71Bruecke` nachgemessen (B-2); die zwei `LNK1104: QCUtils.lib` als Parallelbau-Wettlauf erklärt |
| `README.md` | „Stand der Tabelle: Commit `a807b93`" für die ganze Tabelle | nach Zeilen getrennt datiert |
| `WEITERMACHEN.md` | stand vollständig auf dem Stand vom 30.08. abends: S-5/S-6 „offen", B-1 „UNFERTIG — hängt noch nicht in der Solution", P-1 „ein Zweizeiler wäre der erste Handgriff" | neuer Abschnitt „Was am 31.08. dazugekommen ist" mit S-8, M-1, A-1, P-2, B-2, W-1, Produktversion und Kriterium 0 |
| `WEITERMACHEN.md` | Kopf nannte `eudora-exe-linkt` als Arbeitsbranch | `darstellung-und-menue`, dazu die bekannte Lücke (FREIGABE) |
| `WEITERMACHEN.md` | „Wie man Eudora startet" ohne die Laufzeiten | `laufzeit-holen.ps1` als **ersten** Schritt, sonst `0xc000007b` |
| `WEITERMACHEN.md` | „Solange S-5 offen ist, geht es nur über die `Eudora.ini`" | „solange nicht am laufenden Programm bestätigt ist, dass die Menüs wieder aufgehen" |
| `WEITERMACHEN.md` | nächste Schritte: Platz 1 war „das Erscheinungsbild analysieren" | Platz 1 ist **einmal starten und ein Bildschirmfoto machen**; Kriterium 0 auf Platz 2 |
| `WEITERMACHEN.md` | Agententabelle mit fünf Agenten vom Vorabend | acht Agenten mit Zusammenführungsstand, FREIGABE als noch laufend |
| `Eudora71/OTShim/BEFUND-ANSICHT.md` | Kopf: „**Es wurde keine einzige Quelldatei geändert**" — widersprach dem eigenen Abschnitt „Zweite Sitzung, 31.08.2026 — die Umsetzung" derselben Datei | Kasten davor, der den alten Text auf die erste Sitzung einschränkt. Der Text der Agenten selbst ist unangetastet |

## Was bewusst stehen geblieben ist

- **Die Abschnitte B-, M-, A-, P-, W- und F- in `BEFUNDE.md`.** Auftrag: nicht
  anfassen. Dabei ist mir eines aufgefallen, das jemand mit Zuständigkeit
  ansehen sollte: die Überschrift von **A-1** trägt weiterhin
  „(30.08.2026, UNFERTIG)", und der Absatz darunter sagt „**Kein Code
  geändert**". Beides ist seit den Commits `db28adb` und `1a4a6d5` überholt —
  fünf Punkte sind umgesetzt. In `BEFUND-ANSICHT.md` habe ich die
  entsprechende Stelle berichtigt, in `BEFUNDE.md` nicht.
- **Die Dateinamen mit `lauffaehig`** in `Releases/`. Beide Pakete sind unter
  diesem Namen samt Prüfsumme veröffentlicht; Umbenennen macht die Prüfsummen
  unauffindbar. In `README.md`, `ZIEL.md`, `PAKETE.md` und der `LIESMICH.txt`
  steht ausdrücklich, dass der Name mehr behauptet, als die Fassung kann.
- **`BEFUNDE-ALTBESTAND.md`** — Archiv eines abgeschlossenen Stands.
- **Der Kopfkommentar von `tools/pruefe-bytes.pl`** (Befund aus dem ersten
  Durchgang): er beschrieb die alte CR-Anzahl-Regel. Nicht erneut geprüft, weil
  WERKZEUG die Datei am 31.08. neu geschrieben hat — **wer sie anfasst, sieht
  Zeile 2 bis 4 nach.**

## Belegt, aber nicht berichtigt — hier geht es weiter

| Stelle | Was daran falsch ist |
|---|---|
| `Arbeitsweise/was-lauffaehig-heisst.md` | kennt nur **drei** Kriterien und sagt „Alle drei müssen erfüllt sein". Seit dem 31.08.2026 gibt es **Kriterium 0** (Paket ohne Nachinstallieren). Nicht geändert, weil die Dateien unter `Arbeitsweise/` Spiegel des Gedächtnisses sind (`tools/lehren-spiegeln.pl`) und eine Änderung im Repo beim nächsten Spiegeln verloren geht — das ist Befund NP3-4. **Die Quelle im Gedächtnis muss nachgezogen werden, dann spiegeln.** |
| `Arbeitsweise/quelldateien-nur-byte-erhaltend-aendern.md` (Z. 29, 37, 52, 57) | beschreibt `pruefe-bytes.pl` mit der **alten CR-Anzahl-Regel**. Seit `371c1e3` wird die CR-Anzahl nicht mehr verglichen; seit dem 31.08. wertet Regel 2 den eigentlichen Unterschied aus. Gleiche Spiegel-Einschränkung wie oben |
| `Arbeitsweise/zeilenenden-nach-jedem-schreibzugriff-messen.md` (Z. 3, 9, 30), `Arbeitsweise/MEMORY.md` (Z. 5), `Arbeitsweise/README.md` (Z. 48) | dieselbe alte Regel. Als **Handgriff** („CR-Anzahl messen") bleibt der Rat richtig; als **Beschreibung der Schranke** ist er falsch |
| `PORTIERUNG.md` Z. 663–682 | beschreibt die Fassung von `371c1e3`. Die Berichtigung vom 31.08. fehlt. Nicht mehr ganz richtig, aber auch nicht grob falsch |
| `tools/patches/zertifikatspruefung-verschaerfen.md` Z. 105 | alte CR-Anzahl-Regel. Steht seit dem ersten Durchgang offen |

## Was ich nicht geschafft habe

Der Durchgang endete an Gregors Frist (VM-Abschaltung), nicht an einem
Abschluss. **Nicht angesehen:**

| Datei | warum sie zu prüfen wäre |
|---|---|
| `PORTIERUNG.md` (895 Zeilen) | nur der Abschnitt zur Schranke überflogen; der Rest ist aus beiden Durchgängen ungelesen |
| `PRUEFBERICHT.md` (406 Zeilen) | PR-1 bis PR-8 sind laut W-1 **vollständig** behoben (PR-5 seit `765c39b`); ob die Datei das sagt, ist ungeprüft |
| `STARTUMGEBUNG.md` | im ersten Durchgang nur mit einem Kasten versehen; die vier VS2022-Debug-Laufzeiten aus S-8 gehören dort in die Aufstellung |
| `ABRUF-PRUEFEN.md` (235 Zeilen) | POSTBOTE hat sie geschrieben und mit P-2 fortgeschrieben; ob Anleitung und Befund noch zusammenpassen, ist ungeprüft |
| `Releases/1.0.2/LIESMICH.txt`, `Releases/1.0.3/LIESMICH.txt` | 1.0.3 ist neu und ungelesen; ob 1.0.2 nach S-8 noch stimmt, ist ungeprüft |
| `Releases/1.0/README.md` (268 Zeilen), `Releases/1.0/AUSLIEFERUNGEN.md` | seit dem ersten Durchgang offen |
| `Eudora71/OTShim/PLAN.md` (455 Zeilen), `INVENTAR.md` (201 Zeilen) | seit dem ersten Durchgang offen; die Ersatzschicht ist seit `e50a89c` vollständig eingehängt, der Stufenplan vermutlich überholt |
| `Eudora71/VC71Bruecke/BEFUND.md`, Abschnitt 6 | B-2 sagt, die dort genannte GUID sei **falsch**. Ob die Datei das inzwischen selbst sagt, ist ungeprüft — wer sie abschreibt, bekommt eine Solution, in der `VC71Bruecke` still nicht gebaut wird |
| `BEFUNDE-ALTBESTAND.md`, `Eudora71/OpenSSL3/BAUEN.md`, `Eudora71/Tests/QCSSL/README.md` | aus beiden Durchgängen offen |

**Der nächste Schritt** ist `Eudora71/VC71Bruecke/BEFUND.md` Abschnitt 6 — dort
steht eine Angabe, die nachweislich in einen stillen Fehler führt. Danach
`STARTUMGEBUNG.md` (S-8) und `PRUEFBERICHT.md` (W-1).


---

# Dritter Durchgang — 31.08.2026, abends

Branch `claude/letzter-stand-b2ytpi`, Ausgangsstand `2107a85`. Anlass: Gregors
Anweisung „alle md lesen". **Alle 45 Markdown-Dateien wurden gelesen** (659 KB),
einschliesslich der 5475 Zeilen `BEFUNDE.md` und der 23 Regeln unter
`Arbeitsweise/`. Damit ist die Liste „noch nicht angesehen" aus den ersten zwei
Durchgaengen abgearbeitet.

**Ohne Visual Studio gearbeitet** — dieser Durchgang lief in einer
Linux-Umgebung ohne MSBuild, MSVC und PowerShell. Nichts wurde gebaut, nichts
gestartet, **keine C++-Quelldatei angefasst**. Alle Aenderungen sind Text.

## Der schwerste Fund: `ZIEL.md` war teilweise doppelt kodiert

Der Commit `2107a85` („README.md und ZIEL.md auf den Stand vom 31.08.2026
gebracht") hat **40 Zeilen von `ZIEL.md` doppelt UTF-8-kodiert** hinterlassen —
aus der Ueberschrift wurde `# Was âlauffÃ¤hig" heiÃt`. `HEAD~1` war sauber, die
uebrigen 44 Dateien sind es auch (gemessen ueber alle `*.md`).

Berichtigt per Latin-1-Rundlauf, aber **nur auf Zeilen mit Mojibake-Marker**:
richtig kodierte Zeilen scheitern an `encode('latin-1')` und bleiben unberuehrt.
Nachgemessen: 0 Marker, 0 U+FFFD, LF-Anzahl unveraendert, 0 CR.

## Widersprueche innerhalb einer Datei

| Datei | Was sich widersprach | Behandlung |
|---|---|---|
| `ZIEL.md` | Die Berichtigung „Kriterium 0 ist NICHT belegt" — und drei Absaetze weiter „auf einem Rechner **ohne** Visual Studio: **null Fehler**" | Der widerlegte Absatz ist durch den tatsaechlichen Massstab ersetzt |
| `WEITERMACHEN.md` | Kasten oben: „zwei Kriterien erfuellt"; Tabelle acht Zeilen darunter: „Es ist derzeit KEIN Kriterium erfuellt" | Die zweite Tabelle ist raus, sie war der Stand vom Vormittag |
| `Releases/1.0/AUSLIEFERUNGEN.md` | Kasten „der Servertest ist bestanden" — und darunter „Der Mailserver-Test steht fuer sie aus." | Satz berichtigt |

## Eine Quelle fuer die Kriterientabelle

Die Tabelle stand an **fuenf** Stellen, in **drei** verschiedenen Fassungen
(`ZIEL.md`, `README.md`, `AUFGABEN.md`, `WEITERMACHEN.md`, `Releases/PAKETE.md`).
`ZIEL.md` ist jetzt ausdruecklich die Quelle; `README.md` fuehrt eine als solche
gekennzeichnete Kurzfassung, die uebrigen verweisen.

## Was vom 31.08. nicht nachgezogen war

| Datei | Behauptung | Tatsaechlich |
|---|---|---|
| `README.md` (2x), `PORTIERUNG.md`, `WEITERMACHEN.md` (3x) | „der Release-Zweig scheitert an einer fehlenden `Imap.lib`" | F-1.4: es war `OTA50D.LIB` statt `OTA50R.LIB` in `Eudora.vcxproj:147`, dazu `MakeDox.pl`. Der Release-Bau bindet, 2 933 760 Byte |
| `PORTIERUNG.md` | „keines der **drei** Kriterien erfuellt", „Hauptfenster nicht bedienbar", „Mailabruf nie getestet" | ueberholt durch E-1/E-3 |
| `Releases/PAKETE.md` | 1.0.3 „vorbereitet, NICHT veroeffentlicht", keine Pruefsumme | veroeffentlicht, ZIP am 31.08. um 09:00 **ausgetauscht**; nur `d4719047…` traegt die E-11-Behebung |
| `Releases/1.0/README.md` | „TLS 1.3 nicht nachgemessen", „TLS 1.2 bei sieben der acht Werte", „Neubau der exe noch nicht moeglich" | alle drei ueberholt (E-3, M1, das Paket 1.0.3 existiert) |
| `ABRUF-PRUEFEN.md` | UNGEPRUEFT, ob `mx.freenet.de` POP3 spricht | E-3: ja, Port 110 mit STARTTLS |
| `BEFUNDE.md`, A-1 | Ueberschrift „UNFERTIG", „Kein Code geaendert" | fuenf Punkte umgesetzt (`db28adb`, `1a4a6d5`), Wirkung belegt (E-1/E-2). LEKTOR und Z-1 hatten es beide gemeldet |
| `BEFUNDE.md`, S-7 | Kasten nennt „4426 von 5336" im Werkzeugkopf; Beispiel beschriftet 5716 B als Arbeitskopie | W-1/PR-7 meldete das Nachziehen, fuehrte es aber nicht aus (Z-1). Jetzt ausgefuehrt: Tabelle mit Daten, Beispiel richtig beschriftet, heutiger Wert 6394 ergaenzt |
| `Eudora71/VC71Bruecke/BEFUND.md:462` | GUID `{7B1E9C40-…}` | falsch. Richtig `{7B1C4A20-3E5D-4F71-9A16-2C8D5E71B0C4}` — gegengeprueft in `VC71Bruecke.vcxproj:32` und fuenfmal in `Eudora71/Eudora.sln` |

## Eine Behauptung, die sich beim Nachmessen als zu weit gefasst erwies

`AUFGABEN.md` und der zweite Durchgang dieser Datei sagten, die **alte
CR-Anzahl-Regel** stehe „noch in vier `Arbeitsweise/`-Dateien, in
`PORTIERUNG.md` und in einem Patch-Kommentar". Gemessen: von acht Fundstellen
war **eine** falsch. Die `Arbeitsweise/`-Stellen beschreiben `aendere-zeile.pl`
— und das bricht tatsaechlich bei geaenderter CR-Zahl ab
(`tools/aendere-zeile.pl:33`) — oder den Handgriff von Hand. `PORTIERUNG.md:664`
sagt ausdruecklich das Richtige. Berichtigt wurde
`tools/patches/zertifikatspruefung-verschaerfen.md:105`.

Das ist derselbe Fehlertyp, den diese Datei anderen vorhaelt: eine Aussage
weitergeschrieben, ohne sie zu zaehlen.

## Was bewusst stehen geblieben ist

- **Die Agentenberichte** `BEFUND-MENUE.md`, `BEFUND-ANSICHT.md`,
  `VC71Bruecke/BEFUND.md`, `PRUEFBERICHT.md` und die Befundabschnitte in
  `BEFUNDE.md` — sie sind datierte Belege. Wo sie ueberholt sind, steht jetzt
  ein Kasten davor, der Text darunter bleibt unangetastet.
- **`Arbeitsweise/`** ist ein **Spiegel** des Gedaechtnisverzeichnisses
  (`tools/lehren-spiegeln.pl` kopiert von dort ins Repo, nicht umgekehrt). Der
  Nachtrag „es sind vier Kriterien" in `was-lauffaehig-heisst.md` und die Zeile
  in `MEMORY.md` **gehen beim naechsten Spiegeln verloren**, solange die Quelle
  im Gedaechtnis nicht nachgezogen wird — Befund NP3-4. Der Nachtrag sagt das
  selbst.
- **`INVENTAR.md`** — sagt im Kopf selbst, dass es maschinell erzeugt und
  fehlerhaft ist.
- **Die Dateinamen mit `lauffaehig`** in `Releases/` — veroeffentlichte
  Pruefsummen.

## Offen

- ~~**`Releases/1.0.3/LIESMICH.txt`** beschreibt noch den Debug-Weg~~ —
  **erledigt am 31.08.2026 abends.** Sie verlangte vier Laufzeit-DLLs, die das
  veroeffentlichte Release-Paket gar nicht braucht: wer ihr folgte, holte sich
  mit `laufzeit-holen.ps1` genau die vier **nicht verteilbaren** Debug-DLLs.
  Neu gefasst: Release-Bau, die drei verteilbaren Laufzeiten liegen bei, keine
  SUPERASSERT-Dialoge, **vier** Kriterien mit dem Stand vom 31.08. (zwei
  erfuellt, eines fast, Kriterium 0 nicht belegt), die Warnung ueber die **zwei
  ZIPs unter derselben Nummer** samt Pruefsumme, und der Hinweis, dass
  `paket-pruefen.ps1` vier Falschwarnungen erzeugt, denen man **nicht** folgen
  darf (PR-2). Zeilenenden und Kodierung unveraendert (LF, UTF-8).
- Die **Quelle im Gedaechtnis** fuer `Arbeitsweise/was-lauffaehig-heisst.md`.

## Was diesem Durchgang fehlt

**Er ist nicht gegengeprueft.** Diese Datei haelt selbst fest, dass PRUEFER und
LEKTOR getrennt gehoeren — *„wer prueft und korrigiert, winkt seine eigenen
Befunde durch"*. In dieser Sitzung waren keine Agenten freigegeben, also hat
eine Person Doku, Werkzeuge und die Pruefung der eigenen Arbeit gemacht. Der
offene Punkt steht als **C4** in `AUFGABEN.md`, mit der Liste der vier eigenen
Fehler, die beim Messen gegen die Quelle aufgefallen sind.

## Zwei Lehren aus dieser Sitzung, die in `Arbeitsweise/` gehoeren

Sie stehen hier und nicht dort, weil `Arbeitsweise/` ein **Spiegel** des
Gedaechtnisverzeichnisses ist (`tools/lehren-spiegeln.pl` kopiert von dort ins
Repo, nicht umgekehrt) — ein Eintrag, den ich dort anlege, ist beim naechsten
Spiegeln weg. Wer mit dem Gedaechtnis arbeitet, zieht sie dort nach; hier
ueberleben sie.

**1. Eine Anleitung, die einen Commit meint, nennt den Commit — nicht `HEAD`.**
In Befund X-2 stand die Gegenprobe als `git show HEAD:tools/pruefe-bytes.pl`.
Vom naechsten Commit an war das falsch: `HEAD` traegt die **behobene** Fassung,
die Anleitung liefert dann „35 gruen" statt „11 rot", und die Gegenprobe sieht
erfunden aus. Aufgefallen erst, als die Uebergabe gegengelesen wurde. Das ist
dieselbe Fehlerklasse wie die veralteten Zeilenangaben aus Z-1 — nur trifft sie
hier nicht eine Fundstelle, sondern einen **Beweis**.

*Handgriff:* jede Anleitung in einem Befund einmal ausfuehren, bevor sie
eingecheckt wird. Wo ein Commit gemeint ist, gehoert der Commit hin.

**2. Ist die Menge klein genug, wird sie ganz gelesen — nicht gestichprobt.**
Bei `suche-zeiger.pl` (X-3) hat die Stichprobe von 15 die Filter geliefert, aber
**zwei eigene Fehler nicht gefunden**: die Klammersuche, die in die naechste
Funktion lief, und die verlorene Streichung der `//`-Kommentare, wodurch eine
Klammer **im Kommentar** als Blockende zaehlte. Beide fielen erst auf, als alle
Treffer nachgelesen wurden. Dasselbe beim Einstufen: zwei Treffer, die ich als
echte Kandidaten gefuehrt hatte, standen in einem 69 Zeilen langen
auskommentierten Block.

*Handgriff:* ab etwa 30 Treffern abwaerts alle lesen. Eine Stichprobe misst die
Quote, sie findet nicht den Sonderfall — und der Sonderfall ist meistens ein
Fehler im Werkzeug, nicht im geprueften Code.

---

# Vierter Durchgang — 05.09.2026, abends

Agent LEKTOR, Worktree `Eudora7.2-wt-kette`, Zweig `wt/lektor` aus
`origin/bau-und-pruefung` (`3d03c50`). **Keine Zeile Quelltext geändert, nichts
gebaut.**

Anlass: an einem Tag haben sechs Agenten in getrennten Worktrees gearbeitet und
mehrfach zusammengeführt. Die Dokumentation widersprach sich danach an sieben
Stellen.

## Was berichtigt wurde

| Datei | Was falsch war | Was jetzt dasteht |
|---|---|---|
| `README.md` | „`/p:BuildProjectReferences=false` ist nötig — sonst scheitert der Bau am Projekt `OT501`" stand unverbunden neben dem neuen, richtigen Abschnitt „Selbst bauen" | eine Kurzfassung, die auf „Selbst bauen" verweist, mit Berichtigungskasten: `OT501` ist seit `d8cc9d3` aus dem Bau (Befund **B-3**). Der alte Satz steht als Zitat im Kasten |
| `README.md` | „Stand" war vom 31.08. mit Paket 1.0.3 / Produktversion 7.2.0.3 | Stand vom 05.09., 7.2.0.4 / 1.0.4, mit Berichtigungskasten und dem Hinweis, dass ZIEL.md die Quelle ist |
| `README.md` | „117 richtig, 25 zu ändern" bei `releasebuffer-pruefen.pl` | **nachgemessen am 05.09.**: 141 Vorkommen, 117 richtig, **24** zu ändern — eine Stelle ist mit E-12 nebenbei behoben worden (`fileutil.cpp:482`) |
| `README.md` | „in 5900 Zeilen nichts wieder" | **6960**, nachgemessen |
| `ZIEL.md` | die maßgebliche Kriterientabelle war vom 31.08. | Stand vom 05.09. mit Berichtigungskasten. Kriterium 1 und 3 sind jetzt an **7.2.0.4** belegt; Kriterium 2 hat einen neuen offenen Punkt (kein Fortschritt beim Abruf) und einen weggefallenen (E-7); Kriterium 0 hat sich nicht bewegt |
| `BEFUNDE.md` | **E-4** und **E-7** standen auf „offen", sind aber behoben | beide auf „behoben, ungeprüft", je mit Fortschreibungsabschnitt und Commit |
| `BEFUNDE.md` | **PR-5** stand an drei Stellen auf „offen", war aber in `765c39b` behoben | überall berichtigt; die Überschrift „PR-5 bleibt offen" heißt jetzt „PR-5 — behoben am 31.08.2026 abends" mit Berichtigungskasten |
| `BEFUNDE.md` | für den OT501-Ausbau gab es keinen Befund | neuer Abschnitt **B-3** mit den vier Belegen, dass niemand `OT501` braucht |
| `BEFUNDE.md` | `PR-3` bis `PR-8` und `P-3` kamen im Verzeichnis nicht vor | neuer Abschnitt „Unterbefunde, die man einzeln sucht" mit 13 Zeilen |
| `AUFGABEN.md` | erster Schritt war „das Release auf dem zweiten PC probieren" (31.08.) | Stand vom 05.09.; erster Schritt ist Produktversion hochzählen, bauen, packen, durchsehen. Was heute erledigt wurde, steht in einer eigenen Tabelle |
| `AUFGABEN.md` | Auflage 4 verlangte `/p:BuildProjectReferences=false` | berichtigt: ganze Projektmappe bauen, Schalter nicht mehr benutzen |
| `WEITERMACHEN.md` | Einstieg war vom 31.08. abends | neuer Kasten für den 05.09. ganz oben; die beiden alten Kästen sind als **ÜBERHOLT** gekennzeichnet, nicht gelöscht |
| `LEKTORAT.md` | „PR-1 bis PR-8 sind laut W-1 bis auf PR-5 behoben" | vollständig behoben |

## Aufgelöst: eine doppelt vergebene Kennung

`E-12` war **zweimal** vergeben — Agent KONTO (Mailverzeichnis-Argument,
`79c09d4`) und Agent FORTSCHRITT (Fortschritt beim Mailabruf, `bd3959c` auf
`wt/fortschritt-arbeit`). Beide hatten unabhängig „die nächste freie E-Nummer"
gewählt.

**Auflösung:** `E-12` bleibt bei KONTO (zuerst zusammengeführt, steht im
Verzeichnis); FORTSCHRITTs Befund heißt jetzt **`E-13`** und trägt eine Zeile,
dass er vorher `E-12` hieß.

Beim Nachmessen kamen **drei weitere Dopplungen** heraus, die niemand gemeldet
hatte: `P-1`, `P-2` und `PR-2` bezeichnen je zwei verschiedene Dinge. Sie werden
**nicht** rückwirkend umbenannt — zu viele Querverweise hängen daran —, stehen
aber jetzt im Verzeichnis als Dopplung ausgewiesen.

**Damit das nicht wieder passiert**, steht im Verzeichnis der Befehl, der die
vergebenen Kennungen über **alle** Zweige misst, dazu eine Tabelle der
Kennungen, deren Abschnitt noch auf einem Arbeitszweig liegt (`X-5`, `X-6`,
`E-13`) und die nächsten freien Kennungen.

## Was ich bewusst nicht getan habe

* **Keine Zeile Quelltext geändert, nichts gebaut.**
* **Die Abschnitte zu `X-5` und `X-6` nicht hierher kopiert.** Sie liegen auf
  `wt/schranke` und `wt/baumeister` und kommen mit dem Zusammenführen. Ein
  Verzeichniseintrag ohne Abschnitt wäre genau der Fehler, gegen den das
  Verzeichnis geschrieben ist; die Kennungen sind stattdessen **reserviert**.
* **Nichts gelöscht, was ein Beleg ist.** Überholte Aussagen sind berichtigt und
  als berichtigt gekennzeichnet, meist mit dem alten Wortlaut als Zitat.

---

# Sechster Durchgang — 06.09.2026

Agent LEKTOR, Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig `wt/lektor` aus
`9512108`. **Keine Zeile Quelltext geändert, nichts gebaut, Eudora nicht
gestartet.** Der fünfte Durchgang ist der Vormittag desselben Tages
(`Befunde/LEKTOR.md`, L-1 bis L-6): er hat `README.md`, `AUFGABEN.md`,
`WEITERMACHEN.md` und `ZIEL.md` von Grabungsbericht auf Anleitung umgestellt
und die Liste der übrigen Mängel aufgeschrieben. Dieser Durchgang arbeitet
diese Liste ab.

Anlass ist Gregors Frage: *„readme ist auf dem letzten stand? alle alten
inhalte gelöscht?"*

**Vorgehen: messen, nicht lesen.** Jede Tatsachenbehauptung der `README.md` ist
gegen den Baum geprüft worden — jeder Pfad mit `ls`, jede Zeilenangabe
`datei.cpp:1234` durch Nachsehen an der Stelle, jede Zahl durch Nachzählen,
jeder angebotene Befehl durch Ausführen. Der vollständige Befund mit den
Messbefehlen steht in **[Befunde/LEKTOR-2.md](Befunde/LEKTOR-2.md)**.

**Ergebnis in einem Satz:** die `README.md` war **nicht** auf dem Stand — sechs
Tatsachenbehauptungen waren falsch, darunter zwei Fundstellen, die auf etwas
ganz anderes zeigten. Alle sechs sind berichtigt.

## Zwei Fehlerklassen, die dabei sichtbar wurden

1. **Zeilennummern in Fließtext veralten lautlos.** `eudora.cpp:3542` und
   `mainfrm.cpp:1025` zeigten beide nicht mehr auf das Gemeinte. Wo es geht,
   steht jetzt ein **Funktionsname** statt einer Nummer — der verschiebt sich
   nicht.
2. **Zahlen, die niemand pflegt, sind schlimmer als keine.** Der Absatz über
   die `.lib` nannte „elf", „sieben", „vier", „sechs" — davon stimmte nur die
   Vier. Er ist jetzt nach **Sorten** beschrieben, mit dem Erkennungsmerkmal
   (Importbibliothek = hat eine `.exp` daneben) und drei Befehlen zum
   Nachzählen.

## Was berichtigt wurde

| Datei | Was falsch war |
|---|---|
| `README.md` | `eudora.cpp:3542` als Abbruchstelle bei fehlender `Eudora.ini`; der Absatz über die `.lib`; `cat VERSION` als Beleg für die Quellversion; `mainfrm.cpp:1025`; Stingray-Header 30 statt 28; „121 Zertifikate"; `msvcr71.dll` fehlte in der Ergebnisliste |
| `BEFUNDE.md` | `Z-3` stand auf „offen" (behoben mit `57fe6a4`); **E-14, E-16, E-17, E-22, E-23, E-24, E-25, E-26** fehlten im Verzeichnis ganz |
| `PORTIERUNG.md` | der Kasten „gemessen 05.09.2026" war der Stand **vor** B-3; „16 der 18 Projekte"; `EudoraRes.vcxproj:351`; die OpenSSL3-Libs lägen nicht im Repo; E-11; Port 110 als einziger Beleg |
| `STARTUMGEBUNG.md` | Checkliste Punkt 1 verlangte die nicht verteilbaren Debug-Laufzeiten von jedem Paketanwender (L-3); `EudoraRes` hänge an OT501; die `Eudora.ini`-Fundstelle; die alte Bau-Kennung; „ob Eudora startet, sagt diese Datei nicht" |
| `Releases/PAKETE.md` | die Buchführung endet sieben Pakete vor dem Stand; die Versionsanleitung war für 1.0.3→1.0.4 durchgerechnet; E-11 als Begründung der beiden 1.0.3-ZIPs; Debug-Laufzeiten im Release-Abschnitt (L-3) |
| `ABRUF-PRUEFEN.md` | „Belegt ist Port 110 … das ist **nicht** der Weg, den diese Anleitung empfiehlt" — seit 06.09.2026 ist Port 995 gemessen |
| `Eudora71/OpenSSL3/BAUEN.md` | Aufforderung ganz oben, OpenSSL selbst zu bauen, weil die `.lib` fehlten — sie liegen im Repo |
| `PRUEFUNG-BAU.md`, `PRUEFUNG-BRANCH.md`, `PRUEFUNG-CODE.md`, `Pruefung/PRUEFUNG-KETTE.md`, `Pruefung/PRUEFUNG-ZEIGER.md` | überholte Schlussfolgerungen (E-11, „Ursache wieder offen", M-11, roher MSBuild-Aufruf) als solche gekennzeichnet |
| `Releases/1.0/README.md`, `Releases/1.0/AUSLIEFERUNGEN.md`, `Eudora71/VC71Bruecke/BEFUND.md`, `Eudora71/OTShim/PLAN.md`, `BEFUND-ANSICHT.md`, `BEFUND-MENUE.md`, `BEFUNDE-ALTBESTAND.md`, `tools/patches/zertifikatspruefung-verschaerfen.md` | „nicht getestet" / „nächster Schritt" / „zu prüfen", was längst entschieden ist |

## Was ich bewusst nicht getan habe

* **Keine Zeile Quelltext geändert, nichts gebaut, Eudora nicht gestartet.**
* **Prüfberichte nicht umgeschrieben.** Ein Bericht ist ein Zeitdokument; seine
  Messwerte bleiben stehen. Überholt ist die *Schlussfolgerung*, und die ist
  mit einem Nachtragskasten gekennzeichnet, nicht ersetzt.
* **`Releases/PAKETE.md` nicht um 1.0.4 bis 1.0.10 ergänzt.** Dafür bräuchte es
  Messwerte an den ZIPs, die ich ohne Bau nicht erheben kann. Der Mangel steht
  jetzt als Kasten am Anfang der Datei und als **M-4** im Verzeichnis.
* **Kein Edit-Werkzeug.** Alle Änderungen über `tools/ersetze-bereich.pl` mit
  `:raw`, nach jeder Änderung CR-Zahl und Doppelkodierung gegen `HEAD`
  gemessen.

---

# Siebter Durchgang — 07.09.2026

Agent LEKTOR, Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig `wt/lektor` aus
`060a4bf`. **Keine Zeile Quelltext geändert, nichts gebaut, Eudora nicht
gestartet.** Vollständiger Bericht: `Befunde/LEKTOR-3.md` (L-7).

Anlass war Gregors Ansage:

> *„ich hasse es, wenn in den dokus falsche oder veraltete infos und werte
> stehen. das muss immer parallel gleich erledigt werden, klar?"*

## Kurzantwort

**Vier Behauptungen waren nicht veraltet, sondern falsch**, und jede hätte
jemanden in die Irre geführt, der danach gearbeitet hätte:

1. `BEFUNDE.md` erklärte **E-15 und E-18 bis E-21 für nie vergeben** — *„gesucht
   im ganzen Repo"*. Gesucht worden war nur in `*.md`; alle fünf sind in
   Quellkommentaren vergeben und dort begründet, zwei davon stehen sogar im
   `CHANGELOG`.
2. `AUFGABEN.md` führte als *„den ernstesten der neun"* Zeigerstellen einen
   Wächter *„ohne `return`"*. Der Block endet mit `return E_FAIL;` — es war ein
   **Fehlalarm von `tools/suche-zeiger.pl`**, vierte Fehlerklasse dieses
   Werkzeugs.
3. `AUFGABEN.md` beschrieb den größten Darstellungsmangel an
   `WazooBarMgr.cpp:377-400`. **Dieser Bereich ist vollständig
   auskommentiert** (`//FORNOW`).
4. `PORTIERUNG.md` begründete den Wegfall der Attrappe `OTA50D.LIB` mit
   `LinkLibraryDependencies`. Das Element **gibt es in der Datei nicht**; es
   heißt `ReferenceOutputAssembly`, und zwanzig Zeilen weiter unten sagte die
   Datei selbst, dass die Zeilenangabe daneben liegt.

Dazu **elf falsche Zahlen** (darunter „vier von sieben Kriterien belegt" —
Summe 8 bei sieben Kriterien, und richtig sind drei von acht), **fünfzehn
überholte Zustandsaussagen** und der Abschnitt *Wo man weitermachen kann* im
`CHANGELOG`, der noch E-27 als großen Brocken führte und unter *„noch nicht
versucht"* genau die Messung nannte, die E-31 gelöst hat.

## Die Schranke ist umgebaut, nicht nur benutzt

`tools/doku-pruefen.pl` hatte beim ersten Lauf acht Widersprüche gemeldet —
**vier davon Fehlalarme**, alle aus einer Wurzel: jedes Wort „offen" oder
„behoben" irgendwo in derselben Zeile galt als Status der Kennung. *„…solange
kein Postfach **offen** ist"* reichte.

Jetzt zählt ein Status nur, wo die Kennung ihn **besitzt**: allein in der ersten
Spalte einer Verzeichniszeile, Status **fett**. Dafür drei scharfe Prüfungen
dazu — doppelt vergebene Kennung, Statuswiderspruch im Verzeichnis, und
`CHANGELOG`-*Noch offen* gegen das Verzeichnis. Die letzte hätte den heutigen
Anlass gefunden: E-32 stand als offen und war behoben. Fünf Gegenproben auf
einem Kopierbaum belegen, dass die Prüfungen greifen **und** dass die alte
Prosa stumm bleibt.

Ein Fehler im Werkzeug selbst dabei gefunden: gelesen wird mit `:raw`, also
byteweise — `\x{2014}` im Muster konnte die drei Bytes `E2 80 94` nie treffen,
und die Prüfung auf doppelte Überschriften lief ins Leere.

Eingehängt in `tools/hooks-einrichten.sh` als Schritt 4, abweisend nur bei
`.md`, `VERSION` oder `Eudora71/Version.h` im Commit. **Der eingerichtete Hook
ist bewusst nicht überschrieben** — die anderen Arbeitsbäume haben die
berichtigten Dateien noch nicht. Nach dem Merge einmal
`sh tools/hooks-einrichten.sh`.

## Was berichtigt wurde

| Datei | Was falsch war |
|---|---|
| `ZIEL.md` | „sieben Kriterien" bei acht in der Tabelle; „vier von sieben belegt" (richtig: drei von acht); Kriterien 4 bis 7 auf den Stand vom 07.09.; „Kriterium 0 steht vor den anderen dreien"; „für das Release-Paket ist dieser Lauf noch nicht gemacht worden" gegen die eigene Tabelle; der Erfolgston „ein einzelner benannter Punkt statt einer ganzen Bibliothek" |
| `README.md` | Quellstand 7.2.0.14 / Paket 1.0.14 statt 7.2.0.18 / 1.0.18; Gregors Urteil verkürzt zitiert; „die Wurzel ist E-25"; „Strg-N beendet Eudora, die schuldige Zeile ist nicht gefunden"; „E-30 in Arbeit"; zweimal 7.2.0.14 statt 7.2.0.13 |
| `WEITERMACHEN.md` | Kopftabelle drei Fassungen alt; Arbeitszweig `strg-n-diagnose` (mit PR #9 zusammengeführt); „Alle drei hängen an E-27"; „Entsteht überhaupt jemals ein Paige-Fenster?"; der falsche Verdacht bei E-32 |
| `AUFGABEN.md` | „Alle drei hängen an E-27"; A2 mit 24 statt 21 Stellen und 19 statt 16 falschen; D3a vollständig neu gemessen (siehe oben); E1 mit auskommentiertem Code als Fundstelle; E3 zwei verrutschte Nummern; B1 verwies auf einen Abschnitt, den es nicht gibt; B2 und C2 waren erledigt; C1 „Kriterium 0 nicht nachweisbar"; zwei neue Auflagen (Doku im selben Commit, Zahlen messen statt abschreiben) |
| `CHANGELOG.md` | E-32 unter „Noch offen"; der falsche Verdacht auf `KillACListBox`; ein Punkt, der die Spur früher enden ließ als drei Absätze darüber; „38 C-Dateien" statt 37; `CPUDEFS.H:695`; der ganze Abschnitt *Wo man weitermachen kann*; neuer Abschnitt für den Stand nach 1.0.18, der noch in keinem Paket steckt |
| `PORTIERUNG.md` | `LinkLibraryDependencies`; „vier von sieben Kriterien"; eine zweite Prüfstandsmarke, die der ersten widersprach; „Kriterium 0 nachweisen" als offener Punkt; „142 Vorkommen, 25 davon falsch"; `Eudora.vcxproj:217`, `statbar.h:71`, `TextReader.cpp:251` (zweimal) |
| `Releases/PAKETE.md` | Quellstand 1.0.12; ZIP-Liste drei Pakete alt; Versionsanleitung für 1.0.12→1.0.13; `Eudora.exe` im 1.0.3-ZIP 512 Byte zu klein; „Dateiversion der `Eudora.exe`", die es nicht gibt; „Kriterium 0 bleibt offen"; neuer Abschnitt 1.0.18 mit gemessenen Zahlen |
| `BEFUNDE.md` | der Kasten über die fünf Befunde, die es „nicht gibt"; E-31, E-32, E-33 fehlten im Verzeichnis; E-30 stand auf „in Arbeit"; R-1 mit „25 von 142"; Kopfzahl 7349 Zeilen; Prüfstandsmarke |

## Was ich bewusst nicht getan habe

* **Keine Zeile Quelltext geändert, nichts gebaut, Eudora nicht gestartet.**
* **`EUDORA_BUILD_NUMBER` nicht berichtigt.** Es steht auf `7,2,0,12`, die drei
  anderen Angaben in `Eudora71/Version.h` auf `18` — seit 7.2.0.13 nicht
  mitgezogen, und kein Werkzeug hat es gemeldet. Folgenlos nur, weil das Makro
  nirgends benutzt wird. Das ist Quelltext; `doku-pruefen.pl` meldet es jetzt
  bei jedem Lauf unter *ZU TUN am Quellstand*, blockiert aber nichts.
* **Den Fehlalarm in `tools/suche-zeiger.pl` nicht behoben.** Ein Filter ohne
  Testfall ist der Fehler, den Auflage 10 verbietet, und das Werkzeug hat keine
  Testsammlung.
* **Prüfberichte nicht umgeschrieben** — Zeitdokumente. Überholte
  Schlussfolgerungen bekommen einen datierten Nachtrag.
* **`Releases/PAKETE.md` nicht um 1.0.4 bis 1.0.17 ergänzt.** Für die meisten
  liegt kein ZIP im Repo; Größen und Prüfsummen wären erfunden. **M-4** bleibt
  offen. Für 1.0.18 ist der Abschnitt da, weil dort alles messbar war.
* **„30 Stellen, 22 Stingray-Klassen, 77 Methoden" in `README.md`** weiter
  zurückgestellt — die Zählweise ist nicht dokumentiert, Raten wäre schlimmer.

# Achter Durchgang — 09. bis 11.09.2026

Agent LEKTOR, Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig `wt/lektor`. **Keine
Zeile Quelltext geändert, nichts gebaut, Eudora nicht gestartet.**
Ausführliche Berichte: `Befunde/LEKTOR-6.md` (L-12) und die Commits
`a660b1b`, `77b9aa1`, `be5a9cb`, `a788753`.

Nachgetragen am 11.09.2026, nachdem Gregor gefragt hat:

> *„ist eins von MDs, ich fragte, ob alles aktualisiert ist, du sagst, ja.
> war es der letzte ‚Siebter Durchgang — 07.09.2026'? danach nichts mehr?"*

**Er hatte recht.** Drei Arbeitsgänge waren gelaufen, ohne dass diese Datei
etwas davon wusste. Die Berichte lagen in `Befunde/`, die Historie blieb beim
07.09. stehen — und auf die Frage, ob alles aktuell sei, kam ein „ja", das
nur für die 21 Dateien galt, die `doku-pruefen.pl` kennt. Im Repo liegen 47.

## Was in diesen drei Gängen berichtigt wurde

* **Die INI-Abschnittszuordnung hat vier Zweige, nicht zwei.** `GetSectionID`
  (`rs.cpp:89-97`) trennt bis 10800 `[Settings]`, **10801–10900 `[Debug]`**,
  10901–11100 `[Window Position]`, ab 11101 wieder `[Settings]`. Damit gehört
  **`LogLevel` (10802) nach `[Debug]`** — die Anweisung an Gregor, es nach
  `[Settings]` zu setzen, war falsch. Dass sie trotzdem wirkte, liegt daran,
  dass bei der vorherrschenden Persönlichkeit der zuerst durchsuchte
  Abschnitt wörtlich `[Settings]` heißt. Schranke dazu gebaut:
  `tools/pruefe-ini-abschnitte.pl`.
* **Die Zeilenangabe `rs.cpp:293`** war falsch, richtig ist `rs.cpp:334`.
* **`## Noch offen` stand auf dem 10.09.**, während der CHANGELOG schon vom
  11.09. erzählte. Zwölf Zeilen einzeln gegen `BEFUNDE.md` geprüft, drei
  Befunde ergänzt, die dort offen stehen und hier nie genannt waren (**R-1**,
  **V-1**, **E-14**), dazu die Zertifikatsprüfung als Nebenbefund ohne
  Kennung.
* **Der Abschnitt für 7.2.0.48 fehlte ganz**, und **7.2.0.45** ebenso — dessen
  Text steckte als `###`-Unterabschnitt mitten in `7.2.0.44`. Ein
  Zwischenstandstext vom 09.09. stand ganz oben statt bei seiner Fassung.
  Beides von Gregor gefunden: *„reihenfolge stimmt nicht: oben 2.29 / dann
  0.47 / 0.46 / ..."*
* **`WEITERMACHEN.md`** hinkte einen Arbeitstag und vier Fassungen hinterher.

## Was daraus an Schranken entstand

* **`tools/pruefe-doku-takt.pl`** — kein Paket ohne beschriebene Fassung,
  eingehängt in `paket-bauen.ps1`. Sie prüft inzwischen auch, dass die
  Abschnitte absteigend stehen und keine Nummer fehlt; beim ersten Lauf fand
  sie drei Altlasten (7.2.0.36, .37, .38 ohne Abschnitt).
* **`tools/rollen-faellig.pl` endlich angeschlossen.** Es gab sie seit dem
  08.09. und sie meldete korrekt — nur rief sie niemand auf.
* **`tools/pruefe-stand-md.pl`** — jede Datei mit „Stand"-Kopf gegen den
  jüngsten CHANGELOG-Vorgang, und jede Rollenhistorie gegen den jüngsten
  Bericht ihrer Rolle. **Genau diese Schranke hätte den Fund gemacht, um den
  es hier geht.** Sie misst das Datum in der letzten *Überschrift*, nicht
  irgendwo im Text — sonst hätte der 09.09. im Fließtext diese Datei
  fälschlich für fortgeschrieben erklärt.

## Was ich bewusst nicht getan habe

* **`Arbeitsweise/README.md`** nicht angefasst: die Tabelle „Die Regeln" führt
  27 von 54 Lehren und ist seit Wochen unvollständig. Sie im Vorbeigehen um
  zwei Zeilen zu ergänzen hätte den Eindruck erweckt, sie sei gepflegt. Das
  ist ein Bestandsmangel und gehört als solcher angegangen.
* **7.2.0.36, .37 und .38 nicht nachgeschrieben.** Für diese Fassungen gab es
  Pakete, aber nie einen CHANGELOG-Abschnitt. Sie nachzuerzählen wäre
  Archäologie; sie stehen als benannte Altlast in der Schranke, damit *neue*
  Lücken auffallen.
* **`PRUEFBERICHT.md` nicht fortgeschrieben**, sondern als abgeschlossen
  gekennzeichnet: er gilt für den Stand `371c1e3` vom 30.08.2026, und PRÜFER
  berichtet seither in `Befunde/PRUEFER-*.md`.
