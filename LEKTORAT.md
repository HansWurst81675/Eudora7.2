# Lektorat der Dokumentation

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
| `PRUEFBERICHT.md` (406 Zeilen) | PR-1 bis PR-8 sind laut W-1 bis auf PR-5 behoben; ob die Datei das sagt, ist ungeprüft |
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
