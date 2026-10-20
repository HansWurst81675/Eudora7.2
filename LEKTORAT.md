# Lektorat der Dokumentation

**Diese Datei ist ein Fahrtenbuch, kein Statusbericht.** Sie sammelt die
Durchgänge des Agenten LEKTOR in zeitlicher Folge — jeder Abschnitt gilt für
seinen Tag, nicht für heute. Was **jetzt** gilt, steht in [ZIEL.md](ZIEL.md),
[README.md](README.md) und [CHANGELOG.md](CHANGELOG.md).

Hier stehen der erste bis vierte, der sechste bis neunte, der dreizehnte
bis sechzehnte sowie der neunzehnte und zwanzigste Durchgang. Der
**fünfte** steht nicht hier, sondern in [Befunde/LEKTOR.md](Befunde/LEKTOR.md);
die späteren in [Befunde/LEKTOR-2.md](Befunde/LEKTOR-2.md) ([L-6](Befunde/LEKTOR.md#l-6)),
[Befunde/LEKTOR-3.md](Befunde/LEKTOR-3.md) (L-7),
[Befunde/LEKTOR-4.md](Befunde/LEKTOR-4.md) (L-8, alle 47 MD-Dateien),
[Befunde/LEKTOR-5.md](Befunde/LEKTOR-5.md) (L-9, 41 Befunde am 08.09.2026) und
[Befunde/LEKTOR-6.md](Befunde/LEKTOR-6.md) — dort stehen **L-10** (das
Einarbeiten von L-9, 08.09.2026) und **L-11** (der Stand auf 7.2.0.27 / 1.0.27,
09.09.2026, mit zwei gemessenen Fehlalarmen in `tools/doku-pruefen.pl`) und
[Befunde/LEKTOR-7.md](Befunde/LEKTOR-7.md) (**[L-12](Befunde/LEKTOR-6.md#l-12)**, der Stand auf
7.2.0.51 / 1.0.51, 13.09.2026, **125** MD-Dateien, [E-85](BEFUNDE.md#e-85) und seine Regression)
und [Befunde/LEKTOR-8.md](Befunde/LEKTOR-8.md) (**L-13**, der Stand auf
7.2.0.53 / 1.0.53, 14.09.2026, **133** MD-Dateien), [Befunde/LEKTOR-9.md](Befunde/LEKTOR-9.md) (**L-14**, 7.2.0.57 / 1.0.57, 14.09.2026, 3217 doppelt umkodierte Stellen in BEFUNDE.md), [Befunde/LEKTOR-10.md](Befunde/LEKTOR-10.md) (**L-15**, der Stand auf 7.2.0.63 / 1.0.63, 15.09.2026, **144** MD-Dateien), [Befunde/LEKTOR-11.md](Befunde/LEKTOR-11.md) (**L-16**, der Stand auf 7.2.0.64, 17.09.2026, **146** MD-Dateien, [E-97](BEFUNDE.md#e-97)) und [Befunde/LEKTOR-12.md](Befunde/LEKTOR-12.md) (**[L-17](Befunde/LEKTOR-12.md#l-17)**, der Stand auf 7.2.0.66 / 1.0.66, 17.09.2026, **149** MD-Dateien, [E-98](BEFUNDE.md#e-98) bis [E-101](BEFUNDE.md#e-101)).

**Die Reviews des Agenten PRUEFER** liegen daneben:
[Befunde/PRUEFER-3.md](Befunde/PRUEFER-3.md) ([P-3](Befunde/PRUEFER-11.md#p-3)),
[Befunde/PRUEFER-4.md](Befunde/PRUEFER-4.md) ([P-4](Befunde/PRUEFER-11.md#p-4), [E-37](BEFUNDE.md#e-37) und die
Exit-Beweisführung) und [Befunde/PRUEFER-5.md](Befunde/PRUEFER-5.md) ([P-5](Befunde/PRUEFER-11.md#p-5), das
Review der Exit-Behebung — dort ist [**E-45**](BEFUNDE.md#e-45) gefunden worden).

> **Stand dieser Datei: 18.09.2026.** Der jüngste Durchgang steht in
> `Befunde/LEKTOR-15.md` (Funde **[L-15.1](Befunde/LEKTOR-15.md#l-15.1)** ff.) — *„keine Lügen auf dem main"*
> nach dem Release **`v1.0.72`**; gemessen an Quellstand **7.2.0.72** /
> `VERSION` **1.0.72** über **155** MD-Dateien aus `git ls-files '*.md'`.
> Davor `Befunde/LEKTOR-14.md` (Funde **[L-14.1](Befunde/LEKTOR-14.md#l-14.1)** ff., 7.2.0.70 / 1.0.70,
> 153 Dateien), `Befunde/LEKTOR-13.md` (Funde **[L-13.1](Befunde/LEKTOR-13.md#l-13.1)** ff.,
> `main` auf Unwahrheiten, 17.09.2026, 151 Dateien), **[L-17](Befunde/LEKTOR-12.md#l-17)** in
> `Befunde/LEKTOR-12.md` (7.2.0.66 / 1.0.66, 149 Dateien), **L-16** in
> `Befunde/LEKTOR-11.md` (7.2.0.64, 146 Dateien) und **L-15** in
> `Befunde/LEKTOR-10.md` (7.2.0.63 / 1.0.63, 15.09.2026). Der jüngste
> Durchgang *in dieser Datei* ist der **zwanzigste**, ganz unten. Alles ab
> **[L-6](Befunde/LEKTOR.md#l-6)** steht nicht hier, sondern in `Befunde/LEKTOR-2.md` bis
> `Befunde/LEKTOR-15.md`.
>
> **Zwei Berichtigungen am 17.09.2026 ([L-14.6](Befunde/LEKTOR-14.md#l-14.6)).** (1) Hier stand *„Der jüngste
> Durchgang ist **[L-17](Befunde/LEKTOR-12.md#l-17)**"* — `Befunde/LEKTOR-13.md` war da längst geschrieben
> und kam in dieser Datei überhaupt nicht vor. (2) Hier stand *„Der jüngste
> Durchgang in dieser Datei ist weiterhin der **neunte**"*, während der
> **sechzehnte** seit dem Vormittag ganz unten stand; dieselbe Zeile weiter
> oben nannte *„der dreizehnte bis fünfzehnte"*. `pruefe-stand-md.pl` hat
> nichts davon gesehen: es vergleicht nur das **Datum** der letzten Überschrift
> gegen den jüngsten Bericht der Rolle, und beide standen auf dem 17.09.2026.
> **Zur Nummerierung:** ab `LEKTOR-13.md` tragen die Funde die Nummer ihrer
> **Berichtsdatei** (`L-13.x`, `L-14.x`), nicht die des Durchgangs — die
> Verweise in `README.md`, `AUFGABEN.md` und `tools/RELEASES.md` meinen
> `Befunde/LEKTOR-13.md`, **nicht** den dreizehnten Durchgang vom 14.09.2026.
>
> **[L-17](Befunde/LEKTOR-12.md#l-17) in einem Satz:** Dieselbe Ersetzung wie in L-16, nur andersherum —
> [**E-97**](BEFUNDE.md#e-97) stand in `README.md`, `AUFGABEN.md` und `WEITERMACHEN.md` als
> Fassung **7.2.0.66**, obwohl es in **7.2.0.64** behoben und von Gregor an
> 1.0.64 **bestätigt** ist; die Prüfzeile in `WEITERMACHEN.md` hätte ihn damit
> ein zweites Mal zur Prüfanleitung eines fremden Befunds geschickt. Dazu
> fehlten **[E-98](BEFUNDE.md#e-98) bis [E-101](BEFUNDE.md#e-101)** in fünf Dateien vollständig — [E-98](BEFUNDE.md#e-98) auch im
> offenen Teil des CHANGELOG —, drei Dateien nannten einen Paketstand 1.0.63,
> den es so nicht mehr gibt, und `spuren-auswerten.pl` war zum **dritten Mal**
> an derselben Stelle stumm: die neue E-101-Marke trägt das Wort `SPURMARKE`
> nicht im Kommentar.
>
> **L-16 in einem Satz:** Eine Ersetzung 63 → 64 hat drei **historische**
> Angaben mitgenommen — darunter einen Verweis, der Gregor zur Prüfanleitung
> eines fremden Befunds geschickt hätte — und vier Stellen behaupteten ein
> Paket 1.0.64, das es nicht gibt; dazu schwiegen **zwei Schranken**:
> `pruefe-stand-md.pl`, weil der neue CHANGELOG-Abschnitt kein Datum trug und
> ihr Maßstab damit zwei Tage alt blieb, und `spuren-auswerten.pl`, weil die
> beiden E-97-Marken das Wort `SPURMARKE` nicht im Kommentar tragen.
>
> **L-15 in einem Satz:** Eine Schranke zählte offene Befunde nur, solange
> ihr Urteil kürzer als 60 Zeichen war — sie meldete *„Die Liste deckt die
> offenen Befunde"* und übersah zwei; dazu standen neun Stellen im Bestand
> auf 1.0.52, 1.0.55, 1.0.56 oder 1.0.57 statt 1.0.63, zwei davon als
> **Handlungsanweisung** für Arbeit, die längst getan ist.
>
> **L-13 in einem Satz:** Drei Fassungen in vierundzwanzig Stunden haben die
> Doku an neun Stellen stehenlassen — zwei davon sagten das **Gegenteil** des
> Bestands, und eine davon widersprach sich **innerhalb derselben Datei**
> (`ZIEL.md` Zeile 31 gegen Zeile 43). Dazu waren **[E-85](BEFUNDE.md#e-85) und [E-86](BEFUNDE.md#e-86) für
> `pruefe-befundurteile.pl` unsichtbar**: das eine Urteil war länger als das
> 60-Zeichen-Fenster, das andere enthielt weder „offen" noch „behoben".
>
> **[L-12](Befunde/LEKTOR-6.md#l-12) in einem Satz:** [E-85](BEFUNDE.md#e-85) (Umlaute über IMAP) war behoben, während vier
> Dokumente ihn noch als offen führten — und dreimal an diesem Tag stand die
> Doku still, während der Zweig weiterlief, zweimal davon mit einer Aussage,
> die ich selbst eine Stunde zuvor geschrieben hatte.

## Erster Durchgang — 30.08.2026

Durchgang vom 30.08.2026 durch den Agenten LEKTOR, Branch
`worktree-agent-a3a787cbbe74cbbe2`, gemessener Ausgangsstand `371c1e3`.

Anlass: Gregors Frage „die ganzen MD sind up to date?". **Antwort: nein, mehrere
waren deutlich veraltet.** Der Durchgang wurde vorzeitig abgebrochen (VM wird
abgeschaltet), ist also **unvollständig** — was noch aussteht, steht unten.

## Kurzantwort

Die Dokumentation behauptete an mehreren Stellen einen Stand, der seit dem
30.08.2026 überholt ist. Der schwerste Fall: **drei Dateien schrieben, es sei
ungeprüft, ob Eudora startet** — es startet seit Befund [S-2](BEFUNDE.md#s-2). Der zweitschwerste:
**Befund [S-7](BEFUNDE.md#s-7) verwies auf eine Anweisung in `README.md`, die dort nicht stand.**
Beides ist berichtigt.

## Was berichtigt wurde

| Datei | Was falsch war | Was jetzt dasteht |
|---|---|---|
| `README.md` | „Noch nicht geprueft ist, ob das Programm startet" — im Stand-Kasten **und** in der Tabelle „Offene Themen" | Eudora startet ([S-2](BEFUNDE.md#s-2)), erfüllt aber nur Kriterium 1 aus `ZIEL.md`; [S-5](BEFUNDE.md#s-5), [S-6](BEFUNDE.md#s-6) und der ungeprüfte Mailabruf als eigene Zeilen |
| `README.md` | kein Wort zum frischen Klon, obwohl [S-7](BEFUNDE.md#s-7) ausdrücklich sagt „Steht so in README.md" | neuer Abschnitt „Nach einem frischen Klon" mit den vier Schritten inkl. `zeilenenden-angleichen.pl` und der Begründung (4616 von 5563) |
| `README.md` | die Werkzeuge in `tools/` waren nirgends beschrieben | neuer Abschnitt „Werkzeuge" mit allen 13, samt der **Grenze** von `rekursion-suchen.pl` (Überladungen nur nach Name und Argumentzahl) und dem Hinweis, dass `stapel-untersuchen.ps1` die 32-Bit-PowerShell braucht |
| `README.md` | die Bau-Kennung war nirgends erklärt | neuer Abschnitt „Bau-Kennung in der Titelleiste", Beispiel, Bedeutung des Sternchens, Verweis auf `VERSION` und `kennung-erzeugen.pl` |
| `PORTIERUNG.md` | „Ungeprüft ist, ob das Programm startet" (Z. 27) | startet; Verweis auf [S-2](BEFUNDE.md#s-2) und auf die drei Kriterien |
| `PORTIERUNG.md` | beschrieb `pruefe-bytes.pl` mit der **alten** Funktionsweise („bricht ab, wenn sich die CR-Anzahl geändert hat") | die zwei neuen Regeln (Inhalt gleich/Bytes verschieden; Zeilenende-Wechsel bei unveränderter Zeile), ausdrücklich: CR-Anzahl wird nicht mehr verglichen. Gegen `tools/pruefe-bytes.pl` selbst nachgelesen |
| `PORTIERUNG.md` | `core.autocrlf` nur als Zukunftsvorsorge dargestellt | der Altschaden ([S-7](BEFUNDE.md#s-7)) und seine Behebung ergänzt |
| `WEITERMACHEN.md` | „Umgebung herrichten" kannte `zeilenenden-angleichen.pl` nicht | vier Schritte statt zwei, mit [S-7](BEFUNDE.md#s-7) als Begründung |
| `WEITERMACHEN.md` | „Damit ist **git als Fehlerquelle ausgeschlossen**" — stand unmittelbar neben dem Altschaden, den `.gitattributes` gerade **nicht** behebt | auf „für die Zukunft" eingeschränkt; dazu ausdrücklich, dass die frühere Vermutung „mit `autocrlf=true` geklont" **richtig** war und zu Unrecht als widerlegt abgehakt wurde |
| `WEITERMACHEN.md` | „Der nächste Schritt": Frage sei, ob das Programm startet | neue Reihenfolge nach `ZIEL.md`: Kriterium 2 ([S-5](BEFUNDE.md#s-5)/[S-6](BEFUNDE.md#s-6)), Kriterium 3 (Mailabruf), VC7.1-Laufzeiten, dann `EudoraRes.dll`, libpng, Release-Zweig |
| `STARTUMGEBUNG.md` | „`Eudora.exe` linkt noch nicht und wurde nie gestartet" | Kasten vorangestellt: überholt in den Voraussagen, gültig in der Sache; die fehlende **VC7.1-Laufzeit** ergänzt, die in der Aufstellung gar nicht vorkam |
| `Releases/PAKETE.md` | verlor kein Wort darüber, dass beide ZIP-Namen `lauffaehig` behaupten | Kasten zur Benennung mit Verweis auf `ZIEL.md`; 1.0.2 ausdrücklich als „Kriterium 1 von dreien" |
| `Releases/1.0.2/LIESMICH.txt` | endete mit „Danach steht das Hauptfenster" — kein Hinweis auf [S-5](BEFUNDE.md#s-5)/[S-6](BEFUNDE.md#s-6) | neuer Abschnitt „WAS DIESES PAKET NOCH NICHT KANN" mit der Drei-Kriterien-Tabelle und den beiden offenen Befunden |

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
- **`BEFUNDE.md`** — nur gelesen, nichts geändert. Der S-Block ([S-1](BEFUNDE.md#s-1) bis [S-7](BEFUNDE.md#s-7)) ist
  auf Stand; die Abschnitte der Agenten BRUECKE ([B-1](BEFUNDE.md#b-1)), MENUE ([M-1](BEFUNDE.md#m-1)) und ANSICHT
  ([A-1](BEFUNDE.md#a-1)) waren zum Zeitpunkt der Prüfung noch nicht vorhanden.
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

**Der Befund [S-8](BEFUNDE.md#s-8) fehlte in `BEFUNDE.md` ganz.** Der Startfehler `0xc000007b`
war nur im Commit `76efdb6`, in `README.md` und in `Releases/1.0.2/LIESMICH.txt`
festgehalten — in der Datei, die die Befunde sammelt, stand er nicht. Jetzt ans
Ende geschrieben, mit der Abgrenzung zu [S-1](BEFUNDE.md#s-1) (dort lagen die *falschen*
Fremd-DLLs bei, hier fehlte die eigene Laufzeit ganz) und mit dem, was er
**nicht** löst: die vier Debug-DLLs dürfen nicht weiterverteilt werden.

## Was berichtigt wurde

| Datei | Was falsch oder veraltet war | Was jetzt dasteht |
|---|---|---|
| `BEFUNDE.md` | [S-8](BEFUNDE.md#s-8) fehlte | Abschnitt `## S-8` am Ende |
| `ZIEL.md` | die Kriterientabelle kannte **Kriterium 0 nicht**, obwohl der Abschnitt dazu weiter unten in derselben Datei stand | Tabelle mit 0 bis 3; Kriterium 2 und 3 präzisiert |
| `ZIEL.md` | „keines der **drei** Kriterien" | „keines der Kriterien" — es sind vier |
| `ZIEL.md` | der Kasten zu Kriterium 1 nannte [S-5](BEFUNDE.md#s-5) und [S-6](BEFUNDE.md#s-6) als offen | Nachtrag: Ursachen belegt und **im Quelltext behoben** ([M-1](BEFUNDE.md#m-1), [A-1](BEFUNDE.md#a-1)), **das ändert am Stand nichts**, solange niemand das laufende Programm gesehen hat |
| `README.md` | Stand-Kasten ohne Kriterium 0 | Tabelle 0 bis 3, ausdrücklich „derzeit ist kein Kriterium erfüllt" |
| `README.md` | „Befunde [S-1](BEFUNDE.md#s-1) bis [S-7](BEFUNDE.md#s-7)" | [S-1](BEFUNDE.md#s-1) bis [S-8](BEFUNDE.md#s-8) samt [B-1](BEFUNDE.md#b-1)/[B-2](BEFUNDE.md#b-2), [M-1](BEFUNDE.md#m-1), [A-1](BEFUNDE.md#a-1), [P-1](BEFUNDE.md#p-1)/[P-2](BEFUNDE.md#p-2), [W-1](BEFUNDE.md#w-1) |
| `README.md`, „Offene Themen" | **„Erster Start von `Eudora.exe` — offen und ungeprüft, ob das Programm läuft"** — dieselbe überholte Behauptung, die im ersten Durchgang schon an zwei anderen Stellen berichtigt wurde; hier war sie stehen geblieben | erledigt seit [S-2](BEFUNDE.md#s-2), mit Verweis auf [S-8](BEFUNDE.md#s-8) für den Fall fehlender Laufzeiten |
| `README.md`, „Offene Themen" | „QCSSL gegen echten Mailserver prüfen — **erledigt**, Abruf und Versand laufen" | präzisiert: der Abruf lief mit einer **älteren** QCSSL in einer bestehenden 7.1-Installation, nicht mit dem selbst gebauten `Eudora.exe`; Kriterium 3 ist **nicht** erfüllt. Das war die offene Frage 2 aus dem ersten Durchgang |
| `README.md`, „Offene Themen" | „Release-Konfiguration: für QCSSL gebaut" | dazu die Berichtigung aus [B-2](BEFUNDE.md#b-2): Paket 1.0.2 ist **gemischt**, nicht durchgehend Release |
| `README.md`, „Offene Themen" | [S-5](BEFUNDE.md#s-5), [S-6](BEFUNDE.md#s-6), Kriterium 0 und die Produktversion kamen gar nicht vor | vier neue Zeilen |
| `README.md`, Werkzeuge | acht der achtzehn Werkzeuge fehlten in der Liste: `paket-bauen.ps1`, `paket-pruefen.ps1`, `suche-zeiger.pl`, `vc71-bruecke-messen.pl`, `hooks-einrichten.sh`, `lehren-spiegeln.pl`, `pruefstand-melden.pl`, `ungesichertes-melden.pl` | vollständige Liste, gegen den Inhalt von `tools/` abgeglichen |
| `README.md`, Bauen | der Einzelprojekt-Bau war als funktionierend beschrieben | Kasten: im frischen Klon scheitert er an `imap.lib`, weil `Lib/` von `.gitignore` erfasst ist (belegt in `BEFUND-ANSICHT.md`, „Bauzustand"); nach einem Gesamtbau bindet er durch ([B-2](BEFUNDE.md#b-2)). Dazu: MSBuild muss aus PowerShell kommen |
| `README.md` | „3 Fehler aus `OT501`" ohne Bezugsdatum | am 31.08.2026 mit eingehängtem `VC71Bruecke` nachgemessen ([B-2](BEFUNDE.md#b-2)); die zwei `LNK1104: QCUtils.lib` als Parallelbau-Wettlauf erklärt |
| `README.md` | „Stand der Tabelle: Commit `a807b93`" für die ganze Tabelle | nach Zeilen getrennt datiert |
| `WEITERMACHEN.md` | stand vollständig auf dem Stand vom 30.08. abends: [S-5](BEFUNDE.md#s-5)/[S-6](BEFUNDE.md#s-6) „offen", [B-1](BEFUNDE.md#b-1) „UNFERTIG — hängt noch nicht in der Solution", [P-1](BEFUNDE.md#p-1) „ein Zweizeiler wäre der erste Handgriff" | neuer Abschnitt „Was am 31.08. dazugekommen ist" mit [S-8](BEFUNDE.md#s-8), [M-1](BEFUNDE.md#m-1), [A-1](BEFUNDE.md#a-1), [P-2](BEFUNDE.md#p-2), [B-2](BEFUNDE.md#b-2), [W-1](BEFUNDE.md#w-1), Produktversion und Kriterium 0 |
| `WEITERMACHEN.md` | Kopf nannte `eudora-exe-linkt` als Arbeitsbranch | `darstellung-und-menue`, dazu die bekannte Lücke (FREIGABE) |
| `WEITERMACHEN.md` | „Wie man Eudora startet" ohne die Laufzeiten | `laufzeit-holen.ps1` als **ersten** Schritt, sonst `0xc000007b` |
| `WEITERMACHEN.md` | „Solange [S-5](BEFUNDE.md#s-5) offen ist, geht es nur über die `Eudora.ini`" | „solange nicht am laufenden Programm bestätigt ist, dass die Menüs wieder aufgehen" |
| `WEITERMACHEN.md` | nächste Schritte: Platz 1 war „das Erscheinungsbild analysieren" | Platz 1 ist **einmal starten und ein Bildschirmfoto machen**; Kriterium 0 auf Platz 2 |
| `WEITERMACHEN.md` | Agententabelle mit fünf Agenten vom Vorabend | acht Agenten mit Zusammenführungsstand, FREIGABE als noch laufend |
| `Eudora71/OTShim/BEFUND-ANSICHT.md` | Kopf: „**Es wurde keine einzige Quelldatei geändert**" — widersprach dem eigenen Abschnitt „Zweite Sitzung, 31.08.2026 — die Umsetzung" derselben Datei | Kasten davor, der den alten Text auf die erste Sitzung einschränkt. Der Text der Agenten selbst ist unangetastet |

## Was bewusst stehen geblieben ist

- **Die Abschnitte B-, M-, A-, P-, W- und F- in `BEFUNDE.md`.** Auftrag: nicht
  anfassen. Dabei ist mir eines aufgefallen, das jemand mit Zuständigkeit
  ansehen sollte: die Überschrift von [**A-1**](BEFUNDE.md#a-1) trägt weiterhin
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
| `Arbeitsweise/was-lauffaehig-heisst.md` | kennt nur **drei** Kriterien und sagt „Alle drei müssen erfüllt sein". Seit dem 31.08.2026 gibt es **Kriterium 0** (Paket ohne Nachinstallieren). Nicht geändert, weil die Dateien unter `Arbeitsweise/` Spiegel des Gedächtnisses sind (`tools/lehren-spiegeln.pl`) und eine Änderung im Repo beim nächsten Spiegeln verloren geht — das ist Befund [NP3-4](BEFUNDE.md#np3-4). **Die Quelle im Gedächtnis muss nachgezogen werden, dann spiegeln.** |
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
| `PRUEFBERICHT.md` (406 Zeilen) | [PR-1](BEFUNDE.md#pr-1) bis [PR-8](BEFUNDE.md#pr-8) sind laut [W-1](BEFUNDE.md#w-1) **vollständig** behoben ([PR-5](BEFUNDE.md#pr-5) seit `765c39b`); ob die Datei das sagt, ist ungeprüft |
| `STARTUMGEBUNG.md` | im ersten Durchgang nur mit einem Kasten versehen; die vier VS2022-Debug-Laufzeiten aus [S-8](BEFUNDE.md#s-8) gehören dort in die Aufstellung |
| `ABRUF-PRUEFEN.md` (235 Zeilen) | POSTBOTE hat sie geschrieben und mit [P-2](BEFUNDE.md#p-2) fortgeschrieben; ob Anleitung und Befund noch zusammenpassen, ist ungeprüft |
| `Releases/1.0.2/LIESMICH.txt`, `Releases/1.0.3/LIESMICH.txt` | 1.0.3 ist neu und ungelesen; ob 1.0.2 nach [S-8](BEFUNDE.md#s-8) noch stimmt, ist ungeprüft |
| `Releases/1.0/README.md` (268 Zeilen), `Releases/1.0/AUSLIEFERUNGEN.md` | seit dem ersten Durchgang offen |
| `Eudora71/OTShim/PLAN.md` (455 Zeilen), `INVENTAR.md` (201 Zeilen) | seit dem ersten Durchgang offen; die Ersatzschicht ist seit `e50a89c` vollständig eingehängt, der Stufenplan vermutlich überholt |
| `Eudora71/VC71Bruecke/BEFUND.md`, Abschnitt 6 | [B-2](BEFUNDE.md#b-2) sagt, die dort genannte GUID sei **falsch**. Ob die Datei das inzwischen selbst sagt, ist ungeprüft — wer sie abschreibt, bekommt eine Solution, in der `VC71Bruecke` still nicht gebaut wird |
| `BEFUNDE-ALTBESTAND.md`, `Eudora71/OpenSSL3/BAUEN.md`, `Eudora71/Tests/QCSSL/README.md` | aus beiden Durchgängen offen |

**Der nächste Schritt** ist `Eudora71/VC71Bruecke/BEFUND.md` Abschnitt 6 — dort
steht eine Angabe, die nachweislich in einen stillen Fehler führt. Danach
`STARTUMGEBUNG.md` ([S-8](BEFUNDE.md#s-8)) und `PRUEFBERICHT.md` ([W-1](BEFUNDE.md#w-1)).


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
aus der Ueberschrift wurde `# Was âlauffähig" heiÃt`. `HEAD~1` war sauber, die
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
| `PORTIERUNG.md` | „keines der **drei** Kriterien erfuellt", „Hauptfenster nicht bedienbar", „Mailabruf nie getestet" | ueberholt durch [E-1](BEFUNDE.md#e-1)/[E-3](BEFUNDE.md#e-3) |
| `Releases/PAKETE.md` | 1.0.3 „vorbereitet, NICHT veroeffentlicht", keine Pruefsumme | veroeffentlicht, ZIP am 31.08. um 09:00 **ausgetauscht**; nur `d4719047…` traegt die E-11-Behebung |
| `Releases/1.0/README.md` | „TLS 1.3 nicht nachgemessen", „TLS 1.2 bei sieben der acht Werte", „Neubau der exe noch nicht moeglich" | alle drei ueberholt ([E-3](BEFUNDE.md#e-3), M1, das Paket 1.0.3 existiert) |
| `ABRUF-PRUEFEN.md` | UNGEPRUEFT, ob `mx.freenet.de` POP3 spricht | [E-3](BEFUNDE.md#e-3): ja, Port 110 mit STARTTLS |
| `BEFUNDE.md`, [A-1](BEFUNDE.md#a-1) | Ueberschrift „UNFERTIG", „Kein Code geaendert" | fuenf Punkte umgesetzt (`db28adb`, `1a4a6d5`), Wirkung belegt ([E-1](BEFUNDE.md#e-1)/[E-2](BEFUNDE.md#e-2)). LEKTOR und [Z-1](BEFUNDE.md#z-1) hatten es beide gemeldet |
| `BEFUNDE.md`, [S-7](BEFUNDE.md#s-7) | Kasten nennt „4426 von 5336" im Werkzeugkopf; Beispiel beschriftet 5716 B als Arbeitskopie | [W-1](BEFUNDE.md#w-1)/[PR-7](BEFUNDE.md#pr-7) meldete das Nachziehen, fuehrte es aber nicht aus ([Z-1](BEFUNDE.md#z-1)). Jetzt ausgefuehrt: Tabelle mit Daten, Beispiel richtig beschriftet, heutiger Wert 6394 ergaenzt |
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
  im Gedaechtnis nicht nachgezogen wird — Befund [NP3-4](BEFUNDE.md#np3-4). Der Nachtrag sagt das
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
  darf ([PR-2](BEFUNDE.md#pr-2)). Zeilenenden und Kodierung unveraendert (LF, UTF-8).
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
In Befund [X-2](BEFUNDE.md#x-2) stand die Gegenprobe als `git show HEAD:tools/pruefe-bytes.pl`.
Vom naechsten Commit an war das falsch: `HEAD` traegt die **behobene** Fassung,
die Anleitung liefert dann „35 gruen" statt „11 rot", und die Gegenprobe sieht
erfunden aus. Aufgefallen erst, als die Uebergabe gegengelesen wurde. Das ist
dieselbe Fehlerklasse wie die veralteten Zeilenangaben aus [Z-1](BEFUNDE.md#z-1) — nur trifft sie
hier nicht eine Fundstelle, sondern einen **Beweis**.

*Handgriff:* jede Anleitung in einem Befund einmal ausfuehren, bevor sie
eingecheckt wird. Wo ein Commit gemeint ist, gehoert der Commit hin.

**2. Ist die Menge klein genug, wird sie ganz gelesen — nicht gestichprobt.**
Bei `suche-zeiger.pl` ([X-3](BEFUNDE.md#x-3)) hat die Stichprobe von 15 die Filter geliefert, aber
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
| `README.md` | „`/p:BuildProjectReferences=false` ist nötig — sonst scheitert der Bau am Projekt `OT501`" stand unverbunden neben dem neuen, richtigen Abschnitt „Selbst bauen" | eine Kurzfassung, die auf „Selbst bauen" verweist, mit Berichtigungskasten: `OT501` ist seit `d8cc9d3` aus dem Bau (Befund [**B-3**](BEFUNDE.md#b-3)). Der alte Satz steht als Zitat im Kasten |
| `README.md` | „Stand" war vom 31.08. mit Paket 1.0.3 / Produktversion 7.2.0.3 | Stand vom 05.09., 7.2.0.4 / 1.0.4, mit Berichtigungskasten und dem Hinweis, dass ZIEL.md die Quelle ist |
| `README.md` | „117 richtig, 25 zu ändern" bei `releasebuffer-pruefen.pl` | **nachgemessen am 05.09.**: 141 Vorkommen, 117 richtig, **24** zu ändern — eine Stelle ist mit [E-12](BEFUNDE.md#e-12) nebenbei behoben worden (`fileutil.cpp:482`) |
| `README.md` | „in 5900 Zeilen nichts wieder" | **6960**, nachgemessen |
| `ZIEL.md` | die maßgebliche Kriterientabelle war vom 31.08. | Stand vom 05.09. mit Berichtigungskasten. Kriterium 1 und 3 sind jetzt an **7.2.0.4** belegt; Kriterium 2 hat einen neuen offenen Punkt (kein Fortschritt beim Abruf) und einen weggefallenen ([E-7](BEFUNDE.md#e-7)); Kriterium 0 hat sich nicht bewegt |
| `BEFUNDE.md` | [**E-4**](BEFUNDE.md#e-4) und [**E-7**](BEFUNDE.md#e-7) standen auf „offen", sind aber behoben | beide auf „behoben, ungeprüft", je mit Fortschreibungsabschnitt und Commit |
| `BEFUNDE.md` | [**PR-5**](BEFUNDE.md#pr-5) stand an drei Stellen auf „offen", war aber in `765c39b` behoben | überall berichtigt; die Überschrift „[PR-5](BEFUNDE.md#pr-5) bleibt offen" heißt jetzt „[PR-5](BEFUNDE.md#pr-5) — behoben am 31.08.2026 abends" mit Berichtigungskasten |
| `BEFUNDE.md` | für den OT501-Ausbau gab es keinen Befund | neuer Abschnitt [**B-3**](BEFUNDE.md#b-3) mit den vier Belegen, dass niemand `OT501` braucht |
| `BEFUNDE.md` | [`PR-3`](BEFUNDE.md#pr-3) bis [`PR-8`](BEFUNDE.md#pr-8) und [`P-3`](Befunde/PRUEFER-11.md#p-3) kamen im Verzeichnis nicht vor | neuer Abschnitt „Unterbefunde, die man einzeln sucht" mit 13 Zeilen |
| `AUFGABEN.md` | erster Schritt war „das Release auf dem zweiten PC probieren" (31.08.) | Stand vom 05.09.; erster Schritt ist Produktversion hochzählen, bauen, packen, durchsehen. Was heute erledigt wurde, steht in einer eigenen Tabelle |
| `AUFGABEN.md` | Auflage 4 verlangte `/p:BuildProjectReferences=false` | berichtigt: ganze Projektmappe bauen, Schalter nicht mehr benutzen |
| `WEITERMACHEN.md` | Einstieg war vom 31.08. abends | neuer Kasten für den 05.09. ganz oben; die beiden alten Kästen sind als **ÜBERHOLT** gekennzeichnet, nicht gelöscht |
| `LEKTORAT.md` | „[PR-1](BEFUNDE.md#pr-1) bis [PR-8](BEFUNDE.md#pr-8) sind laut [W-1](BEFUNDE.md#w-1) bis auf [PR-5](BEFUNDE.md#pr-5) behoben" | vollständig behoben |

## Aufgelöst: eine doppelt vergebene Kennung

[`E-12`](BEFUNDE.md#e-12) war **zweimal** vergeben — Agent KONTO (Mailverzeichnis-Argument,
`79c09d4`) und Agent FORTSCHRITT (Fortschritt beim Mailabruf, `bd3959c` auf
`wt/fortschritt-arbeit`). Beide hatten unabhängig „die nächste freie E-Nummer"
gewählt.

**Auflösung:** [`E-12`](BEFUNDE.md#e-12) bleibt bei KONTO (zuerst zusammengeführt, steht im
Verzeichnis); FORTSCHRITTs Befund heißt jetzt **[`E-13`](BEFUNDE.md#e-13)** und trägt eine Zeile,
dass er vorher [`E-12`](BEFUNDE.md#e-12) hieß.

Beim Nachmessen kamen **drei weitere Dopplungen** heraus, die niemand gemeldet
hatte: [`P-1`](BEFUNDE.md#p-1), [`P-2`](BEFUNDE.md#p-2) und [`PR-2`](BEFUNDE.md#pr-2) bezeichnen je zwei verschiedene Dinge. Sie werden
**nicht** rückwirkend umbenannt — zu viele Querverweise hängen daran —, stehen
aber jetzt im Verzeichnis als Dopplung ausgewiesen.

**Damit das nicht wieder passiert**, steht im Verzeichnis der Befehl, der die
vergebenen Kennungen über **alle** Zweige misst, dazu eine Tabelle der
Kennungen, deren Abschnitt noch auf einem Arbeitszweig liegt ([`X-5`](BEFUNDE.md#x-5), [`X-6`](BEFUNDE.md#x-6),
[`E-13`](BEFUNDE.md#e-13)) und die nächsten freien Kennungen.

## Was ich bewusst nicht getan habe

* **Keine Zeile Quelltext geändert, nichts gebaut.**
* **Die Abschnitte zu [`X-5`](BEFUNDE.md#x-5) und [`X-6`](BEFUNDE.md#x-6) nicht hierher kopiert.** Sie liegen auf
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
(`Befunde/LEKTOR.md`, [L-1](Befunde/LEKTOR.md#l-1) bis [L-6](Befunde/LEKTOR.md#l-6)): er hat `README.md`, `AUFGABEN.md`,
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
| `BEFUNDE.md` | [`Z-3`](BEFUNDE.md#z-3) stand auf „offen" (behoben mit `57fe6a4`); **[E-14](BEFUNDE.md#e-14), [E-16](BEFUNDE.md#e-16), [E-17](BEFUNDE.md#e-17), [E-22](BEFUNDE.md#e-22), [E-23](BEFUNDE.md#e-23), [E-24](BEFUNDE.md#e-24), [E-25](BEFUNDE.md#e-25), [E-26](BEFUNDE.md#e-26)** fehlten im Verzeichnis ganz |
| `PORTIERUNG.md` | der Kasten „gemessen 05.09.2026" war der Stand **vor** [B-3](BEFUNDE.md#b-3); „16 der 18 Projekte"; `EudoraRes.vcxproj:351`; die OpenSSL3-Libs lägen nicht im Repo; [E-11](BEFUNDE.md#e-11); Port 110 als einziger Beleg |
| `STARTUMGEBUNG.md` | Checkliste Punkt 1 verlangte die nicht verteilbaren Debug-Laufzeiten von jedem Paketanwender ([L-3](Befunde/LEKTOR.md#l-3)); `EudoraRes` hänge an OT501; die `Eudora.ini`-Fundstelle; die alte Bau-Kennung; „ob Eudora startet, sagt diese Datei nicht" |
| `Releases/PAKETE.md` | die Buchführung endet sieben Pakete vor dem Stand; die Versionsanleitung war für 1.0.3→1.0.4 durchgerechnet; [E-11](BEFUNDE.md#e-11) als Begründung der beiden 1.0.3-ZIPs; Debug-Laufzeiten im Release-Abschnitt ([L-3](Befunde/LEKTOR.md#l-3)) |
| `ABRUF-PRUEFEN.md` | „Belegt ist Port 110 … das ist **nicht** der Weg, den diese Anleitung empfiehlt" — seit 06.09.2026 ist Port 995 gemessen |
| `Eudora71/OpenSSL3/BAUEN.md` | Aufforderung ganz oben, OpenSSL selbst zu bauen, weil die `.lib` fehlten — sie liegen im Repo |
| `PRUEFUNG-BAU.md`, `PRUEFUNG-BRANCH.md`, `PRUEFUNG-CODE.md`, `Pruefung/PRUEFUNG-KETTE.md`, `Pruefung/PRUEFUNG-ZEIGER.md` | überholte Schlussfolgerungen ([E-11](BEFUNDE.md#e-11), „Ursache wieder offen", M-11, roher MSBuild-Aufruf) als solche gekennzeichnet |
| `Releases/1.0/README.md`, `Releases/1.0/AUSLIEFERUNGEN.md`, `Eudora71/VC71Bruecke/BEFUND.md`, `Eudora71/OTShim/PLAN.md`, `BEFUND-ANSICHT.md`, `BEFUND-MENUE.md`, `BEFUNDE-ALTBESTAND.md`, `tools/patches/zertifikatspruefung-verschaerfen.md` | „nicht getestet" / „nächster Schritt" / „zu prüfen", was längst entschieden ist |

## Was ich bewusst nicht getan habe

* **Keine Zeile Quelltext geändert, nichts gebaut, Eudora nicht gestartet.**
* **Prüfberichte nicht umgeschrieben.** Ein Bericht ist ein Zeitdokument; seine
  Messwerte bleiben stehen. Überholt ist die *Schlussfolgerung*, und die ist
  mit einem Nachtragskasten gekennzeichnet, nicht ersetzt.
* **`Releases/PAKETE.md` nicht um 1.0.4 bis 1.0.10 ergänzt.** Dafür bräuchte es
  Messwerte an den ZIPs, die ich ohne Bau nicht erheben kann. Der Mangel steht
  jetzt als Kasten am Anfang der Datei und als **[M-4](Befunde/PRUEFER-15.md#m-4)** im Verzeichnis.
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

1. `BEFUNDE.md` erklärte **[E-15](BEFUNDE.md#e-15) und [E-18](BEFUNDE.md#e-18) bis [E-21](BEFUNDE.md#e-21) für nie vergeben** — *„gesucht
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
`CHANGELOG`, der noch [E-27](BEFUNDE.md#e-27) als großen Brocken führte und unter *„noch nicht
versucht"* genau die Messung nannte, die [E-31](BEFUNDE.md#e-31) gelöst hat.

## Die Schranke ist umgebaut, nicht nur benutzt

`tools/doku-pruefen.pl` hatte beim ersten Lauf acht Widersprüche gemeldet —
**vier davon Fehlalarme**, alle aus einer Wurzel: jedes Wort „offen" oder
„behoben" irgendwo in derselben Zeile galt als Status der Kennung. *„…solange
kein Postfach **offen** ist"* reichte.

Jetzt zählt ein Status nur, wo die Kennung ihn **besitzt**: allein in der ersten
Spalte einer Verzeichniszeile, Status **fett**. Dafür drei scharfe Prüfungen
dazu — doppelt vergebene Kennung, Statuswiderspruch im Verzeichnis, und
`CHANGELOG`-*Noch offen* gegen das Verzeichnis. Die letzte hätte den heutigen
Anlass gefunden: [E-32](BEFUNDE.md#e-32) stand als offen und war behoben. Fünf Gegenproben auf
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
| `README.md` | Quellstand 7.2.0.14 / Paket 1.0.14 statt 7.2.0.18 / 1.0.18; Gregors Urteil verkürzt zitiert; „die Wurzel ist [E-25](BEFUNDE.md#e-25)"; „Strg-N beendet Eudora, die schuldige Zeile ist nicht gefunden"; „[E-30](BEFUNDE.md#e-30) in Arbeit"; zweimal 7.2.0.14 statt 7.2.0.13 |
| `WEITERMACHEN.md` | Kopftabelle drei Fassungen alt; Arbeitszweig `strg-n-diagnose` (mit PR #9 zusammengeführt); „Alle drei hängen an [E-27](BEFUNDE.md#e-27)"; „Entsteht überhaupt jemals ein Paige-Fenster?"; der falsche Verdacht bei [E-32](BEFUNDE.md#e-32) |
| `AUFGABEN.md` | „Alle drei hängen an [E-27](BEFUNDE.md#e-27)"; A2 mit 24 statt 21 Stellen und 19 statt 16 falschen; D3a vollständig neu gemessen (siehe oben); E1 mit auskommentiertem Code als Fundstelle; E3 zwei verrutschte Nummern; B1 verwies auf einen Abschnitt, den es nicht gibt; B2 und C2 waren erledigt; C1 „Kriterium 0 nicht nachweisbar"; zwei neue Auflagen (Doku im selben Commit, Zahlen messen statt abschreiben) |
| `CHANGELOG.md` | [E-32](BEFUNDE.md#e-32) unter „Noch offen"; der falsche Verdacht auf `KillACListBox`; ein Punkt, der die Spur früher enden ließ als drei Absätze darüber; „38 C-Dateien" statt 37; `CPUDEFS.H:695`; der ganze Abschnitt *Wo man weitermachen kann*; neuer Abschnitt für den Stand nach 1.0.18, der noch in keinem Paket steckt |
| `PORTIERUNG.md` | `LinkLibraryDependencies`; „vier von sieben Kriterien"; eine zweite Prüfstandsmarke, die der ersten widersprach; „Kriterium 0 nachweisen" als offener Punkt; „142 Vorkommen, 25 davon falsch"; `Eudora.vcxproj:217`, `statbar.h:71`, `TextReader.cpp:251` (zweimal) |
| `Releases/PAKETE.md` | Quellstand 1.0.12; ZIP-Liste drei Pakete alt; Versionsanleitung für 1.0.12→1.0.13; `Eudora.exe` im 1.0.3-ZIP 512 Byte zu klein; „Dateiversion der `Eudora.exe`", die es nicht gibt; „Kriterium 0 bleibt offen"; neuer Abschnitt 1.0.18 mit gemessenen Zahlen |
| `BEFUNDE.md` | der Kasten über die fünf Befunde, die es „nicht gibt"; [E-31](BEFUNDE.md#e-31), [E-32](BEFUNDE.md#e-32), [E-33](BEFUNDE.md#e-33) fehlten im Verzeichnis; [E-30](BEFUNDE.md#e-30) stand auf „in Arbeit"; [R-1](BEFUNDE.md#r-1) mit „25 von 142"; Kopfzahl 7349 Zeilen; Prüfstandsmarke |

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
  liegt kein ZIP im Repo; Größen und Prüfsummen wären erfunden. **[M-4](Befunde/PRUEFER-15.md#m-4)** bleibt
  offen. Für 1.0.18 ist der Abschnitt da, weil dort alles messbar war.
* **„30 Stellen, 22 Stingray-Klassen, 77 Methoden" in `README.md`** weiter
  zurückgestellt — die Zählweise ist nicht dokumentiert, Raten wäre schlimmer.

# Achter Durchgang — 09. bis 11.09.2026

Agent LEKTOR, Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig `wt/lektor`. **Keine
Zeile Quelltext geändert, nichts gebaut, Eudora nicht gestartet.**
Ausführliche Berichte: `Befunde/LEKTOR-6.md` ([L-12](Befunde/LEKTOR-6.md#l-12)) und die Commits
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
  Befunde ergänzt, die dort offen stehen und hier nie genannt waren ([**R-1**](BEFUNDE.md#r-1),
  [**V-1**](BEFUNDE.md#v-1), [**E-14**](BEFUNDE.md#e-14)), dazu die Zertifikatsprüfung als Nebenbefund ohne
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

---

# Neunter Durchgang — 13.09.2026

Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig `wt/lektor`, Ausgangsstand `da95db4`
(`main` nach dem Merge von `e84-bestaetigt`). Gemessener Quellstand **7.2.0.50**
/ Paket **1.0.50**.

**Auftrag: den Bestand prüfen, nicht den Diff.** Alle **121** MD-Dateien im
Verzeichnis (`git ls-files '*.md'`), nicht nur die zuletzt angefassten — die
Lehre [review-sieht-nur-den-diff](Arbeitsweise/review-sieht-nur-den-diff.md).
Der Auftrag sprach von 47 Dateien; das war die Zahl aus dem achten Durchgang
(L-8) und stimmt seit dem 08.09.2026 nicht mehr.

## Die schwersten Funde

**1. `AUFGABEN.md` erklärte drei Befunde für bestätigt, die es nicht sind.**
Abschnitt 1 führte [**E-49**](BEFUNDE.md#e-49), [**E-50**](BEFUNDE.md#e-50) und [**E-52**](BEFUNDE.md#e-52) als *„bestätigt"* und berief
sich dabei ausdrücklich auf `BEFUNDE.md`. Dort steht bei allen dreien *„von
Gregor noch nicht bestätigt"* (`BEFUNDE.md:210`, `:211`, `:213`). Nachgezählt
über alle Urteilszeilen: **vierzehn** behobene Befunde sind unbestätigt — [E-49](BEFUNDE.md#e-49),
[E-50](BEFUNDE.md#e-50), [E-52](BEFUNDE.md#e-52) bis [E-63](BEFUNDE.md#e-63) —, nicht einer. Die Überschrift *„vier gebaute Behebungen
warten auf Gregors Urteil"* stand wortgleich in `AUFGABEN.md` und
`WEITERMACHEN.md`.

Das ist bemerkenswert, weil der achte Durchgang genau diesen Abschnitt
berichtigt hat: er drehte den Widerspruch um, statt ihn aufzulösen.
`tools/pruefe-befundurteile.pl` fängt diese Klasse — aber es prüft sieben
Anwenderdokumente, und **`AUFGABEN.md` ist nicht darunter**, obwohl der
Kommentar im Werkzeug selbst (`:42`) diese Datei als Anlass nennt. *Gemeldet,
nicht geändert: `tools/` gehörte während dieses Durchgangs PRÜFER.*

**2. `ABRUF-PRUEFEN.md` beschrieb eine Zertifikatsprüfung, die es nicht mehr
gibt.** Dort stand, die Prüfung sei *„in dieser Fassung bewusst nachsichtig"*
und der Patch *„absichtlich **nicht** eingespielt"*. Am Quelltext gemessen: er
**ist** eingespielt. `qccertificate.cpp:82-90` hängt
`X509_V_ERR_CERT_UNTRUSTED` und `X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE`
am ablehnenden Zweig, `iOK` bleibt 0. Das ist [**E-82**](BEFUNDE.md#e-82), von Gregor am
11.09.2026 bestätigt. Dieselbe überholte Aussage stand in `AUFGABEN.md` unter
*Zurückgestellt*. Zurückgestellt ist nur noch die **Hostnamensprüfung** (nur
`CN`, keine SAN, kein SNI).

**3. `CHANGELOG.md` sperrte zwei Fassungen für die Veröffentlichung.** Die
Abschnitte **7.2.0.49** und **7.2.0.50** trugen beide *„Noch nicht von ihm
bestätigt"*, obwohl Gregor beide am 11.09.2026 bestätigt hat.
`tools/release-veroeffentlichen.ps1` sucht im Abschnitt der Fassung nach *„noch
nicht best"* und weist ab, wenn es das findet (`:115`) — beide Fassungen waren
damit von einer Veröffentlichung ausgeschlossen, durch eine Aussage, die nicht
mehr stimmte. Kein Schönheitsfehler, sondern eine geschlossene Tür.

**4. Der INI-Schlüssel zu [E-84](BEFUNDE.md#e-84) stand mit falschem Abschnitt in der Doku.**
`EINSTELLUNGEN.md` und `README.md` nannten `[ToolBar]`. Gemessen:
`mainfrm.cpp:4456` übergibt `ToolBar`, `SECToolBarManager::SaveState` setzt
daraus `%s-ToolBarManager` — und in Gregors `Eudora.ini` steht `FloatCx319=751`
unter **`[ToolBar-ToolBarManager]`**. Dazu `WriteProfileString` statt
`WriteProfileInt`. In `BEFUNDE.md` stand außerdem noch der **alte Schlüsselname
`BarFloatSize<n>`** aus dem ersten, wirkungslosen Anlauf, samt dessen Stelle
(`SECControlBarInfo::SaveState`) als angebliche Fundstelle der Behebung.

**5. Die Spurmarke zu [E-76](BEFUNDE.md#e-76) stand als `entfaellt`, obwohl sie geliefert hatte.**
`Befunde/SPURMARKEN.md` sagte *„wartet auf den nächsten Bericht von Gregor"*.
Der Bericht kam am 11.09.2026: er hat an 1.0.48 gezogen, und die Marke schrieb
die fünf Zeilen, die [E-76](BEFUNDE.md#e-76) entschieden haben — und an 1.0.50 ein zweites Mal,
`E-76 fest: vorher=751x403`, der Beleg für [E-84](BEFUNDE.md#e-84). Dieselbe Klasse wie bei [E-70](BEFUNDE.md#e-70)
([eingebaute-messung-auslesen](Arbeitsweise/eingebaute-messung-auslesen.md)),
nur andersherum: dort war die Marke ungelesen, hier war sie gelesen und die
Tabelle sagte weiter, sie sei es nicht.

## Was sonst berichtigt wurde

| Datei | was nicht stimmte |
|---|---|
| `WEITERMACHEN.md` | Quellstand 7.2.0.48 statt 7.2.0.50; „zuletzt gebaut 1.0.48"; „auf GitHub veröffentlicht ist `v1.0.47`" (es ist `v1.0.48`, `gh release list`); „zuletzt von Gregor bestätigt 1.0.48"; [E-76](BEFUNDE.md#e-76) als offen und [E-66](BEFUNDE.md#e-66) als nie ausgewertet geführt, obwohl `spuren-auswerten.pl` beide als erledigt meldet; Prüfschritte, die auf die Pakete 1.0.29 und 1.0.26 zeigten |
| `ZIEL.md` | der Kopf sagt „Diese Tabelle ist die Quelle" und stand auf 7.2.0.48 / 1.0.48 |
| `PORTIERUNG.md` | 1.0.50 als „in Arbeit"; „veröffentlicht ist die Fassung davor" — es sind zwei davor |
| `Releases/PAKETE.md` | „1.0.30 bis 1.0.48 dazugekommen"; „im Repo liegen zwei ZIPs … `Eudora72-1.0.27-release.zip` (die veröffentlichte Fassung)". `git ls-files Releases/` sagt: das zweite ZIP ist **1.0.30**, und veröffentlicht ist `v1.0.48`. Beide Hälften falsch |
| `README.md`, *Was es nicht kann* | *„Kein IMAP getestet. Der Code ist da, geprüft ist nur POP3."* — `ZIEL.md` führt IMAP seit dem **10.09.2026** als von Gregor bestätigt (*„imap: funktioniert"*, `imap.gmx.net:993`), und seither sind [**E-83**](BEFUNDE.md#e-83) und [**E-77**](BEFUNDE.md#e-77) als IMAP-Befunde aufgelaufen, die dort nicht vorkamen. Der Punkt, den ein Anwender zuerst liest, war damit in beide Richtungen falsch |
| `Befunde/SPURMARKEN.md` | Kopfzahlen „19 Befunde, 146 Protokollstellen in 16 Dateien" vom 10.09.; allein die Tabelle darunter summierte sich auf 157. Heute gemessen: **23 Befunde, 158 Stellen in 20 Dateien**. Zwei Zeilen fehlten ([**E-44**](BEFUNDE.md#e-44), [**E-79**](BEFUNDE.md#e-79)), zwei Zahlen stimmten nicht ([E-78](BEFUNDE.md#e-78) hat eine Formatzeile, nicht zwei; [E-80](BEFUNDE.md#e-80) drei Stellen, nicht vier) |

## Was bewusst stehen geblieben ist

* **Die historischen Abschnitte in `BEFUNDE.md`** (`:1325`, `:3457`, `:3543`,
  `:3789`), die den Zertifikats-Patch als *nicht angewandt* führen. Sie stehen
  unter datierten Überschriften vom 30.08.2026 und sind **für ihren Tag
  richtig**. Ein Fahrtenbuch wird nicht nachträglich umgeschrieben; der
  gültige Stand steht in der Urteilszeile zu [E-82](BEFUNDE.md#e-82).
* **`Befunde/LEKTOR-*.md`, `Befunde/PRUEFER-*.md` und die übrigen Berichte
  unter `Befunde/`** — dieselbe Begründung. Es sind Berichte zu einem Stand,
  keine Zustandsbeschreibungen.
* **Die Kriterientabelle in `ZIEL.md`** selbst. Sie ist gegen `BEFUNDE.md` und
  `CHANGELOG.md` gehalten worden und stimmt; nur ihr Stand-Kopf war alt.
* **`tools/`** — dort arbeitete PRÜFER. Der Befund zu
  `pruefe-befundurteile.pl` (`AUFGABEN.md` fehlt in der Prüfliste) ist deshalb
  gemeldet und nicht behoben.
* **`Arbeitsweise/`** bis auf zwei Zwangsläufigkeiten: der Spiegel-Hook legte
  die neue Lehre `agent-vor-dem-ende-nicht-starten.md` herein und verlangte
  sie im selben Commit. Ihre Zeile *„Schranke: keine mechanische möglich — …"*
  wies `tools/lehren-schranken.pl` ab, weil der keine-Zweig `keine - <Grund>`
  verlangt; berichtigt in beiden Fassungen, auch in der Quelle unter
  `~/.claude`. Die Lehrentabelle in `Arbeitsweise/README.md` ist damit neu
  gesetzt — **sie deckt jetzt alle 56 Lehren**, der im achten Durchgang
  benannte Bestandsmangel (27 von 54) ist erledigt.

## Wie gearbeitet wurde

Jede Änderung als Perl-Skript mit `<:raw`/`>:raw`, ohne `use utf8`, jeder Anker
genau einmal geprüft, CR-Anzahl vor und nach jedem Schreibzugriff bilanziert
(alle Dateien 0). Vor jedem Commit die acht verlangten Schranken, alle 0.

**Sieben Commits unterwegs statt eines am Ende** — die ausdrückliche Auflage
dieses Auftrags, nachdem der Vorlauf vom 11.09.2026 mit null Dateien und null
Commits endete. Der erste Commit stand, sobald die erste Datei fertig war. Der
Zweig `wt/lektor` war auf dem Server gelöscht; der `pre-commit`-Hook hat das
gemeldet und den Commit verweigert, bevor etwas nur lokal entstehen konnte —
die Schranke hat genau das getan, wofür sie gebaut ist.

---

# Dreizehnter Durchgang — 14.09.2026 (L-13)

**Der Bericht steht vollständig in [Befunde/LEKTOR-8.md](Befunde/LEKTOR-8.md).**
Hier nur der Eintrag ins Fahrtenbuch, damit diese Datei nicht wieder hinter den
Berichten zurückbleibt.

Gemessen an Quellstand **7.2.0.53** / Paket **1.0.53**, über **133** MD-Dateien
und alle **88** Werkzeuge in `tools/`.

| | |
|---|---|
| **Der schwerste Fund** | `ZIEL.md` widersprach **sich selbst**: Zeile 31 sagte richtig *„seit 7.2.0.52 in Ordnung, am laufenden Programm belegt"*, zwölf Zeilen darunter stand *„mit [E-85](BEFUNDE.md#e-85) in 7.2.0.51 behoben, aber noch nicht bestätigt"* |
| **Der zweitschwerste** | `BEFUNDE.md` widersprach sich **in einer einzigen Zeile**: *„Alle drei Mängel behoben in 7.2.0.51 — Regression noch offen"* gegen *„(3) in 7.2.0.51 gleich mitbehoben"* im selben Absatz |
| **Der stillste** | **[E-85](BEFUNDE.md#e-85) und [E-86](BEFUNDE.md#e-86) waren für `pruefe-befundurteile.pl` unsichtbar** — das eine Urteil war länger als das 60-Zeichen-Fenster, das andere enthielt weder *offen* noch *behoben*. Beide gingen durch jede Gegenprüfung, ohne gewogen zu werden |
| **Zeilenangaben** | 16 nachgemessen, **8 falsch**, alle berichtigt. Das Muster: berichtigt wurde, was *vor* der letzten Änderung derselben Datei gemessen war |
| **Ein abgebrochener Satz** | `PORTIERUNG.md` endete seit einem früheren Umbau mit *„Hier steht bewusst keine"* — ohne Objekt, direkt vor einer Tabelle. Kein Werkzeug prüft darauf |
| **Zwölf offene Befunde** | einzeln am Quelltext nachgemessen, alle weiterhin offen, jeder jetzt mit Datum und Fundstelle. [**E-14**](BEFUNDE.md#e-14) steht ausdrücklich als *nicht entscheidbar* da |
| **Drei neue Schranken** | `pruefe-behoben-belegt.pl` (10/10), `pruefe-anzeigetext.pl` (7/7), `arbeitsbaum-angleichen.sh` (12/12) — alle in beide Richtungen gegengetestet, zwei davon hat erst der Gegentest brauchbar gemacht |
| **Gemessen, nicht geändert** | `Arbeitsweise/*.md` ist ein **Spiegel** des Sitzungsgedächtnisses; `lehren-spiegeln.pl` macht Berichtigungen dort im `pre-commit` lautlos rückgängig. Drei gemessene Berichtigungen sind so verlorengegangen — die Quelle gehört CHRONIST |

**Was beim nächsten Mal zuerst drankommt:** beide Hauptwidersprüche standen
**innerhalb einer Datei**. `doku-pruefen.pl` hält Dateien *gegeneinander* —
keine Schranke prüft eine Datei gegen sich selbst. Eine Prüfung, die zu **einer**
Kennung zwei verschiedene Fassungsnummern in derselben Datei findet, hätte beide
gefunden und wäre billig.

# Vierzehnter Durchgang — 14.09.2026 (L-14)

**Der Bericht steht vollständig in [Befunde/LEKTOR-9.md](Befunde/LEKTOR-9.md).**
Nachgetragen am 15.09.2026 — dieser Durchgang hatte hier nie einen Eintrag
bekommen, obwohl genau das der Zweck dieses Fahrtenbuchs ist.

Gemessen an Quellstand **7.2.0.57** / Paket **1.0.57**. Der schwerste Fund:
**3217 doppelt umkodierte Stellen** in `BEFUNDE.md`, in 1517 von 7826 Zeilen —
und die Datei war dabei durchgehend gültiges UTF-8, sah also für jede Prüfung
normal aus, die nur auf Kodierungsfehler sieht.

# Fünfzehnter Durchgang — 15.09.2026 (L-15)

**Der Bericht steht vollständig in [Befunde/LEKTOR-10.md](Befunde/LEKTOR-10.md).**

Gemessen an Quellstand **7.2.0.63** / Paket **1.0.63**, über **144** MD-Dateien
und alle **108** versionierten Dateien in `tools/`.

| | |
|---|---|
| **Der schwerste Fund** | `offene-befunde.pl` und `pruefe-befundurteile.pl` lasen das Urteil nur bis **60 Zeichen** Länge. [**E-90**](BEFUNDE.md#e-90) (62 Zeichen) und [**E-92**](BEFUNDE.md#e-92) (67) fielen lautlos aus der Zählung — und das Werkzeug schrieb dazu *„Die Liste deckt die offenen Befunde."* Neun standen da, wo elf stehen. **L-13 hatte genau dieses Fenster schon als *„der stillste"* Fund benannt, ohne es zu schließen** — es ist jetzt weg, in beide Richtungen gegengetestet |
| **Die Breite** | **neun Stellen** in sieben Dateien standen auf 1.0.52, 1.0.55, 1.0.56 oder 1.0.57 statt 1.0.63 — `WEITERMACHEN.md`, `AUFGABEN.md`, `ZIEL.md`, `Releases/PAKETE.md`, `README.md` |
| **Die gefährlichste Sorte** | zwei Zeilen in `WEITERMACHEN.md` standen als **Handlungsanweisung** für Arbeit, die längst getan ist: *„DER NÄCHSTE SCHRITT: [E-85](BEFUNDE.md#e-85) ist NICHT behoben"* (behoben seit 7.2.0.52, und zwei Zeilen tiefer in derselben Tabelle stand es auch so) und *„Was als Nächstes zu messen ist: der hängende Resync"* (das ist [E-83](BEFUNDE.md#e-83), seit 7.2.0.53 behoben) |
| **Eine Zahl war schlicht falsch** | `README.md` sagte zu [**E-93**](BEFUNDE.md#e-93) *„17.889 statt 252.921 Byte"*. Die Spurmarke selbst sagt `OrigBytes=105125`, und nur damit stimmen die 83 Prozent im Befundtitel. Der Auftrag an mich nannte ebenfalls 252921 — so wandert eine falsche Zahl weiter |
| **`SPURMARKEN.md`** | behauptete *„23 Befunde, 158 Stellen in 20 Dateien"* und warnte **im selben Absatz** davor, dass die Zahl schon einmal nicht nachgezogen worden war. Gemessen: **29 / 168 / 26**. Vier Marken fehlten ([E-83](BEFUNDE.md#e-83), [E-86](BEFUNDE.md#e-86), [E-87](BEFUNDE.md#e-87), [E-95](BEFUNDE.md#e-95)), eine stand mit falscher Datei da ([E-89](BEFUNDE.md#e-89)). Der Messbefehl steht jetzt dort |
| **Nicht ersetzt, sondern gekennzeichnet** | die README-Zahlen zur *Paige-* und *MSHTML-Anbindung* (13.146 / 8.637 Zeilen) sind **nicht nachvollziehbar** — der Messbefehl wurde nie aufgeschrieben. Eine erfundene Reproduktion wäre schlimmer als ein ehrlicher Vermerk |

**Was beim nächsten Mal zuerst drankommt:** `pruefe-stand-md.pl` hat nicht
gemerkt, dass **L-14 in dieser Datei ganz fehlte** — sie hält Datum gegen Datum,
nicht **Verweis gegen Bestand**. Eine Prüfung, die jeden `Befunde/LEKTOR-*.md`
gegen die Verweise in `LEKTORAT.md` hält, hätte es sofort gesagt und wäre billig.

# Sechzehnter Durchgang — 17.09.2026 (L-16)

**Der Bericht steht vollständig in [Befunde/LEKTOR-11.md](Befunde/LEKTOR-11.md).**

Gemessen an Quellstand **7.2.0.64** über **146** MD-Dateien aus
`git ls-files '*.md'`. Anlass: [**E-97**](BEFUNDE.md#e-97) ist behoben — *File → Save As* beendete
Eudora sofort, in jeder Fassung seit 1.0.49 und auch im veröffentlichten
`v1.0.50`.

**13 Mängel in 10 Dateien**, alle berichtigt. Die drei Gruppen:

| | |
|---|---|
| **Eine Ersetzung 63 → 64** nahm drei Angaben über die **Vergangenheit** mit — [E-95](BEFUNDE.md#e-95)/[E-96](BEFUNDE.md#e-96) sind in 7.2.0.63 behoben, nicht in .64. Die teuerste: `WEITERMACHEN.md`:11 schickte zur Prüfanleitung *„Abschnitt 7.2.0.64"*, und dort steht [E-97](BEFUNDE.md#e-97) | `WEITERMACHEN.md`, `AUFGABEN.md`, `README.md` |
| **Vier Stellen behaupteten Paket 1.0.64.** Gemessen: unter `Releases/` liegt zuletzt `Eudora72-1.0.63-release`; 7.2.0.64 ist gebaut, nicht geschnürt. Eine nannte sogar den Pfad | `WEITERMACHEN.md`, `AUFGABEN.md`, `PORTIERUNG.md`, `ZIEL.md` |
| **[E-97](BEFUNDE.md#e-97) kam außer in CHANGELOG und BEFUNDE nirgends vor** — auch nicht in `README.md` unter *Was es nicht kann*, obwohl das veröffentlichte `v1.0.50` betroffen ist | `README.md`, `WEITERMACHEN.md`, `AUFGABEN.md`, `ZIEL.md` |

**Zwei Schranken waren dabei stumm**, und das ist der eigentliche Fund:

- `pruefe-stand-md.pl` nimmt das jüngste Datum im `CHANGELOG.md` als Maßstab.
  Der Abschnitt zu 7.2.0.64 trug **kein Datum** — der Maßstab blieb der 15.09.,
  und fünf Stand-Köpfe auf dem 15.09. bekamen ein *„Kein Stand-Kopf hinkt
  hinterher"*.
- `spuren-auswerten.pl` erkennt eine Marke am Wort `SPURMARKE` im Kommentar.
  Über beiden **[E-97](BEFUNDE.md#e-97)**-Marken steht `BEFUND E-97`. Das Werkzeug zählt 8 Befunde
  mit Marken, der Messbefehl aus `SPURMARKEN.md` **30** — und meldet dazu
  weder Fund noch Fehlalarm.

**Drei der sieben Mängelgruppen sind wörtliche Wiederholungen aus L-15**: die
widersprüchliche Urteilsspalte (dort [E-95](BEFUNDE.md#e-95), hier [E-97](BEFUNDE.md#e-97)), die nicht nachgezogenen
Spurmarkenzahlen (29/168/26 statt 30/170/28) und Stellen auf einer älteren
Fassung. Die Klasse ist nicht abgestellt, nur jeweils behoben.

# Neunzehnter Durchgang — 17.09.2026, abends (L-19, `Befunde/LEKTOR-14.md`)

**Der Bericht steht vollständig in [Befunde/LEKTOR-14.md](Befunde/LEKTOR-14.md).**

Gemessen an Quellstand **7.2.0.70** / `VERSION` **1.0.70** über **153**
MD-Dateien aus `git ls-files '*.md'`. Anlass, Gregor wörtlich: *„readme,
changelog, befunde sind up to date? lass' mal wieder pruefer und lektor
drueber laufen."*

**Zehn Mängelgruppen, sieben berichtigt, fünf Stellen zur Übergabe** an den parallel
laufenden Zweig `paketliste-glattziehen`.

| | |
|---|---|
| **Der teuerste Fund ([L-14.1](Befunde/LEKTOR-14.md#l-14.1))** | Die Tabelle im neuen CHANGELOG-Abschnitt 7.2.0.70 hat die Zeile zu **1.0.69 vertauscht**: sie sagt *„enthält [E-101](BEFUNDE.md#e-101) zweiter Teil, es fehlt [E-106](BEFUNDE.md#e-106)"*. Gemessen an Zeitstempel und Vorfahrenschaft ist es **umgekehrt** — die `Eudora.exe` entstand 20:24:54 aus `acc8ad7`, der E-106-Merge (20:16:00) ist Vorfahr, der zweite Teil von [E-101](BEFUNDE.md#e-101) (20:58:43) kam danach. Gregor hat **1.0.69** auf der Platte und **1.0.70 nicht** |
| **Ein Berichtigungsvermerk, der nicht stimmte ([L-14.2](Befunde/LEKTOR-14.md#l-14.2))** | [L-13.1](Befunde/LEKTOR-13.md#l-13.1) erklärte die Unwahrheit *„veröffentlicht ist weiterhin `v1.0.50`"* in fünf Dokumenten für erledigt. In `WEITERMACHEN.md` stand sie **weiter**, und `PORTIERUNG.md` trug sie ebenfalls, ohne in einem der Vermerke genannt zu sein. Sechs Dokumente, zwei blieben stehen |
| **Vier Befunde unter falscher Fassung ([L-14.4](Befunde/LEKTOR-14.md#l-14.4))** | Alles war auf **7.2.0.68** gezogen. Richtig: [**E-101**](BEFUNDE.md#e-101) in 7.2.0.66 und 7.2.0.69, [**E-103**](BEFUNDE.md#e-103) in 7.2.0.67, [**E-104**](BEFUNDE.md#e-104) in 7.2.0.67 **und** 7.2.0.68, [**E-106**](BEFUNDE.md#e-106) in 7.2.0.68. Dieselbe Ersetzungsklasse wie in L-11, L-16 und [L-17](Befunde/LEKTOR-12.md#l-17) — sie ist zum **vierten Mal** aufgetreten |
| **[E-106](BEFUNDE.md#e-106) ([L-14.5](Befunde/LEKTOR-14.md#l-14.5))** | **keine einzige Stelle** behauptet, er sei nachgewiesen. Ein Nachtrag in `ZIEL.md`, sonst nichts |

**Drei Schranken waren stumm**, und das ist der eigentliche Fund:

- **`pruefe-befund-verbreitung.pl`**, am selben Tag gebaut, war bei ihrem
  **ersten echten Lauf** wirkungslos: sie liest die Kennungen aus den
  **Überschriften** des jüngsten CHANGELOG-Abschnitts, und die drei
  Überschriften des Abschnitts 7.2.0.70 nennen keine. Die vier Befunde der
  Fassung stehen im Fließtext. Meldung: *„nennt keinen Befund - nichts zu
  pruefen."*
- **`pruefe-stand-md.pl`** meldete *„LEKTORAT.md ist so neu wie der jüngste
  Bericht des LEKTOR"*, während diese Datei `Befunde/LEKTOR-13.md` **kein
  einziges Mal** nannte. Es vergleicht nur das **Datum** der letzten
  Überschrift, und beide standen auf dem 17.09.2026.
- **`pruefe-behoben-belegt.pl`** und `pruefe-befundurteile.pl` lesen das Urteil
  als **ersten Fettdruck** der dritten Spalte, gefunden mit
  `\*\*([^*]{1,80})\*\*`. Wird der Fettdruck **länger als 80 Zeichen**, greift
  das Muster beim **nächsten** — aus `**behoben in …**` wurde `**Gemessen an
  seiner Datei**`, und der behobene Befund galt als **offen**. Gefunden an der
  eigenen Berichtigung, weil die Schranke *„geprueft 0"* meldete, wo zwei
  geänderte Urteilszeilen im Diff standen (**[L-14.10](Befunde/LEKTOR-14.md#l-14.10)**).

**Ein Nebenbefund, der eine Klasse betrifft:** `Arbeitsweise/` ist ein
**Spiegel** des Gedächtnisverzeichnisses (`tools/lehren-spiegeln.pl`). Eine
Berichtigung dort wird vom Vorcommit-Haken aus der Quelle **zurückgenommen** —
gemessen an meinem eigenen Commit-Versuch. Wer eine Lehre berichtigen will,
muss an die Quelle; das steht in `Arbeitsweise/README.md` nicht (**[L-14.9](Befunde/LEKTOR-14.md#l-14.9)**).

**Nachtrag desselben Abends.** Während der Bericht entstand, kam **7.2.0.71 /
1.0.71** mit [**E-107**](BEFUNDE.md#e-107) dazu — ein Absturz beim Antworten, **mit [E-106](BEFUNDE.md#e-106)
eingeschleppt**. Drei Folgen:

- **Gregors Absturzmeldung belegt [L-14.1](Befunde/LEKTOR-14.md#l-14.1) unabhängig.** `BEFUNDE.md` sagt zu
  [E-107](BEFUNDE.md#e-107): *„von Gregor am 17.09.2026 um 21:23 **an 1.0.69** gemeldet"*. Wer den
  E-106-Fehler an 1.0.69 erlebt, hat [E-106](BEFUNDE.md#e-106) in 1.0.69 — genau das bestreitet
  `CHANGELOG.md:143` bis jetzt.
- **`CHANGELOG.md:144` nennt 1.0.70 weiterhin *„alles"* und *„ein
  vollständiger Stand zum Testen"*.** 1.0.70 trägt den Absturz aus [E-107](BEFUNDE.md#e-107);
  behoben ist er erst in 7.2.0.71. Keine MD sagt das.
- **`tools/ZWEIGE.md:73`** hat den Zweig `p38-spurmarke-rumpf` an einem Abend
  **zweimal** weitergeschoben: 7.2.0.69 → .70 → .71. Gebracht hat er
  **7.2.0.69**. Die Ersetzungsklasse zum fünften Mal — Vorschlag für eine
  Schranke steht im Bericht.

---

## Zwanzigster Durchgang — 18.09.2026 (Bericht: `Befunde/LEKTOR-15.md`)

**Anlass, Gregor wörtlich:** *„es scheinen einige MDs veraltet zu sein, was
falsch ist: **keine lügen auf dem main**."* Den ersten Fund hat er selbst
geliefert: `README.md` sagte zu [**E-108**](BEFUNDE.md#e-108) *„bei Gregor noch nicht bestätigt"*,
`BEFUNDE.md` in derselben Fassung *„von Gregor bestätigt"*.

Gemessen an Quellstand **7.2.0.72** / `VERSION` **1.0.72** über **155**
MD-Dateien; Maßstab war das Release **`v1.0.72`** (`gh release list`:
*Latest*, 2026-09-17T20:07:49Z).

| Fund | Kurz |
|---|---|
| **[L-15.1](Befunde/LEKTOR-15.md#l-15.1)** | `PORTIERUNG.md` nannte 7.2.0.70 / 1.0.70 und *„veröffentlicht ist `v1.0.64`"* — **dieselbe Zeile war schon [L-14.2](Befunde/LEKTOR-14.md#l-14.2) und [L-13.1](Befunde/LEKTOR-13.md#l-13.1)**, samt Berichtigungsvermerk |
| **[L-15.2](Befunde/LEKTOR-15.md#l-15.2)** | `ZIEL.md` führte 1.0.70 als geschnürtes Paket und **[E-106](BEFUNDE.md#e-106) als *„ausdrücklich nicht nachgewiesen"*** — bestätigt an 1.0.69; vom Release stand kein Wort |
| **[L-15.3](Befunde/LEKTOR-15.md#l-15.3)** | `AUFGABEN.md` sagte in Zeile 64 *„gebaut und geschnürt ist 7.2.0.70"*, in Zeile 3 derselben Datei **7.2.0.72** — und zählte 1.0.70 zu Gregors Paketen, das er nie hatte |
| **[L-15.4](Befunde/LEKTOR-15.md#l-15.4)** | `BEFUNDE.md` führte [**E-106**](BEFUNDE.md#e-106) als *„bei Gregor noch nicht nachgewiesen"*, während `AUFGABEN.md` und `README.md` die Bestätigung nannten |
| **[L-15.5](Befunde/LEKTOR-15.md#l-15.5)** | `tools/ZWEIGE.md:73` **zum dritten Mal** weitergeschoben (69 → 70 → 71 → 72) — **und der Antreiber war `doku-pruefen.pl` selbst**, siehe unten |
| **[L-15.6](Befunde/LEKTOR-15.md#l-15.6)** | `WEITERMACHEN.md` Zeile 13: Überschrift **BESTÄTIGT**, Text darunter *„Zu prüfen: …"* — zwei Fassungen in einer Zelle. Zeile 28 nannte **1.0.64** als zuletzt bestätigt, eine Zeile über der Angabe 1.0.72 |
| **[L-15.7](Befunde/LEKTOR-15.md#l-15.7)** | `CHANGELOG.md`, Tabelle 7.2.0.70: 1.0.69 **vertauscht**, von [L-14.1](Befunde/LEKTOR-14.md#l-14.1) gemessen und danach unverändert stehen geblieben; 1.0.70 hieß *„alles"*, trägt aber den Absturz [E-108](BEFUNDE.md#e-108) |
| **[L-15.8](Befunde/LEKTOR-15.md#l-15.8)** | die Prüfanleitung im Abschnitt 7.2.0.70 schickte Gregor zu einem Paket, das er nie hatte und das abstürzt |
| **[L-15.9](Befunde/LEKTOR-15.md#l-15.9)** | **drei Fassungen einer Aussage über den eigenen Prüfstand, eine davon falsch** — *„lädt keine Bilder"* gegen *„lädt zwar Bilder"*. Am Protokoll entschieden: er lädt **acht**, ihm fehlt ein **Testdatum** |
| **[L-15.10](Befunde/LEKTOR-15.md#l-15.10)** | **[E-105](BEFUNDE.md#e-105) hatte keine Zeile in `BEFUNDE.md`** — seit dem 17.09. als Aufgabe geführt, nie angelegt. Belegt und nachgetragen. **E-102 ist nie vergeben worden** |
| **[L-15.11](Befunde/LEKTOR-15.md#l-15.11)** | `README.md` nannte unter *Wo die Grenzen liegen* nur [E-98](BEFUNDE.md#e-98) und [E-77](BEFUNDE.md#e-77) — **[E-94](BEFUNDE.md#e-94) und [E-105](BEFUNDE.md#e-105) fehlten**; ebenso im CHANGELOG-Abschnitt *Noch offen* [E-105](BEFUNDE.md#e-105), [E-109](BEFUNDE.md#e-109) und die LF-Weiterleitungen |

**Der Befund, der über den Tag hinausgeht ([L-15.5](Befunde/LEKTOR-15.md#l-15.5)):** `tools/doku-pruefen.pl`
löst auf das Wort *Paketnummer* aus und verlangt in den 200 Zeichen dahinter
die **aktuelle** Nummer. In `tools/ZWEIGE.md` steht dort aber, was ein Zweig
**gebracht** hat. Die Schranke hat damit dieselbe Zeile an einem Abend
**dreimal** in die Unwahrheit getrieben — und beim vierten Mal meinen
berichtigten Wert als *MANGEL* gemeldet. Eine Schranke, die die Unwahrheit
erzwingt, ist teurer als eine, die schweigt
([schranke-gegentesten.md](Arbeitsweise/schranke-gegentesten.md)). Aufgelöst
wurde es ohne Eingriff in `tools/` — die Zeile sagt jetzt *„Daraus entstand
Quellstand 7.2.0.69 und Paket 1.0.69"*, wie die stumme Nachbarzeile darüber;
danach meldet die Schranke *„Kein Widerspruch gefunden"*. **Die Grenze bleibt
und gehört zu [E-109](BEFUNDE.md#e-109).**

## Einundzwanzigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-16.md`)

**Anlass:** [AN-1](BEFUNDE.md#an-1) wurde am 12.10.2026 zum ersten Mal gebaut und am laufenden
Programm gemessen (7.2.0.79: 4 von 6 Prüffällen heil). Der Lauf ging nur lesend
über die MDs seit `c0f946c`, Schwerpunkt B5/[AN-1](BEFUNDE.md#an-1), gemessen an `ca8da5a`.

| Fund | Kurz |
|---|---|
| **[L-16.1](Befunde/LEKTOR-16.md#l-16.1)** | `tools/offene-befunde.pl` liest nur Kennungen der Form `E-\d+` — **[AN-1](BEFUNDE.md#an-1) sieht es nicht**, und [E-112](BEFUNDE.md#e-112) fällt heraus, weil *„widerlegt"* als erledigt zählt. Die Schranke aus CLAUDE.md Schritt 1 ist damit an zwei Stellen blind |
| **[L-16.2](Befunde/LEKTOR-16.md#l-16.2)** | `BEFUNDE.md` [AN-1](BEFUNDE.md#an-1): der Messstand vom 12.10. fehlt, mehrere Stellen sagen *„nicht übersetzt"* |
| **[L-16.3](Befunde/LEKTOR-16.md#l-16.3)** | `BEFUNDE.md` [AN-1](BEFUNDE.md#an-1): rund 20 zitierte Zeilennummern stimmen nicht mehr |
| **[L-16.4](Befunde/LEKTOR-16.md#l-16.4)** | `AUFGABEN.md` B5: der Kasten oben ist neu, der Rest des Abschnitts steht noch auf *„nicht gebaut"* |
| **[L-16.5](Befunde/LEKTOR-16.md#l-16.5)** | `CHANGELOG.md`: 7.2.0.79 trägt noch *„nicht übersetzt"* |
| **[L-16.6](Befunde/LEKTOR-16.md#l-16.6)** | `Releases/PAKETE.md`: zwei Antworten im selben Abschnitt |
| **[L-16.7](Befunde/LEKTOR-16.md#l-16.7)** | `tools/pruefdaten/LIESMICH.md`: *„was Eudora heute daraus macht"* beschreibt 7.2.0.76 |
| **[L-16.8](Befunde/LEKTOR-16.md#l-16.8)** | `WEITERMACHEN.md`: *„Der nächste Schritt"* trägt das Datum 12.10., der Inhalt ist vom 18.09. und 30.09. |
| **[L-16.9](Befunde/LEKTOR-16.md#l-16.9)** | Zweig `patch_20261012` nirgends verzeichnet — **erledigt**: umbenannt in `an1-endungen`, von Gregor bestätigt, eingetragen in `tools/ZWEIGE.md` |
| **[L-16.10](Befunde/LEKTOR-16.md#l-16.10)** | `ZIEL.md:17` und `README.md:149`: *„nicht übersetzt"* |

**Eingearbeitet ist bisher nur [L-16.9](Befunde/LEKTOR-16.md#l-16.9)** und die `CheckName`-Formulierung im
CHANGELOG. Der Rest ist offen; er gehört vor einen Merge von `an1-endungen`.

## Zweiundzwanzigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-17.md`)

**Anlass:** Merge von PR #83 ([AN-2](BEFUNDE.md#an-2)) in `an1-endungen`, Stand 7.2.0.82. Nur
lesend über die MDs seit `4ec9dd1`.

| Fund | Kurz |
|---|---|
| **[L-17.1](Befunde/LEKTOR-17.md#l-17.1)** | [AN-2](BEFUNDE.md#an-2) an sieben Stellen nur „nicht übersetzt", ohne den Stand 7.2.0.82 |
| **[L-17.2](Befunde/LEKTOR-17.md#l-17.2)** | AN-1-Inhalte heißen an sieben Stellen „7.2.0.80" statt „7.2.0.80-an1"; zwei Verweise zeigen dadurch auf den AN-2-Abschnitt |
| **[L-17.3](Befunde/LEKTOR-17.md#l-17.3)** | alter Stand in `ZIEL.md:17`, `README.md:149`, `PORTIERUNG.md:43`, `tools/ZWEIGE.md:93`; 1.0.82 in PAKETE noch „in Arbeit" — **letzteres erledigt** |
| **[L-17.4](Befunde/LEKTOR-17.md#l-17.4)** | AUFGABEN B5: Überschrift mit kaputter Fettschrift — **erledigt**; Tabelle kennt B5.8 bis B5.10 nicht |
| **[L-17.5](Befunde/LEKTOR-17.md#l-17.5)** | Zahl der Ursachen schwankt zwischen sechs, sieben und zehn |
| **[L-17.6](Befunde/LEKTOR-17.md#l-17.6)** | CHANGELOG-Kopf sagte zu [AN-1](BEFUNDE.md#an-1) „nichts davon ist übersetzt" — **erledigt** |
| **[L-17.7](Befunde/LEKTOR-17.md#l-17.7)** | BEFUNDE [AN-1](BEFUNDE.md#an-1): unter dem neuen Kasten stehen alte Aussagen |
| **[L-17.8](Befunde/LEKTOR-17.md#l-17.8)** | `offene-befunde.pl` meldet 16/16 gedeckt und sieht [AN-1](BEFUNDE.md#an-1), [AN-2](BEFUNDE.md#an-2), [E-112](BEFUNDE.md#e-112) nicht (= [L-16.1](Befunde/LEKTOR-16.md#l-16.1)) |

**Berichtigung zu Durchgang 21:** dort stand „eingearbeitet ist bisher nur
[L-16.9](Befunde/LEKTOR-16.md#l-16.9)" — tatsächlich waren es zu dem Zeitpunkt auch [L-16.7](Befunde/LEKTOR-16.md#l-16.7) und Teile von [L-16.2](Befunde/LEKTOR-16.md#l-16.2).

## Dreiundzwanzigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-18.md`)

Kurzlauf vor dem Paket 1.0.83 über `d292850`. Die Aussagen zu 7.2.0.83 sind
belegt. Zwei Mängel (`Releases/PAKETE.md:158` noch „in Arbeit", `WEITERMACHEN.md:10`
ohne AN5), **beide behoben** im selben Commit.

## Vierundzwanzigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-19.md`)

Kurzlauf vor dem Release v1.0.83 über Gregors IMAP-Test im CHANGELOG. Drei
Mängel (Versionsangabe 7.2.0.77/78, Zahl der Sitzungen, Langpfad-Präfix) und ein
Hinweis (umbenannte Datei) — **alle eingearbeitet** im selben Commit.

## Fünfundzwanzigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-20.md`)

**Anlass:** Merge von PR #84; Gregor: *„keine lügen auf main!"* Diesmal
**schreibend**, auf `wt/lektor` über `18f71e5`. Abgearbeitet sind die offenen
Funde aus [LEKTOR-16](Befunde/LEKTOR-16.md#lektor-16) und [LEKTOR-17](Befunde/LEKTOR-17.md#lektor-17), ausgenommen das Werkzeug ([L-16.1](Befunde/LEKTOR-16.md#l-16.1)/[L-17.8](Befunde/LEKTOR-17.md#l-17.8)).

| Fund | Kurz |
|---|---|
| **[L-16.1](Befunde/LEKTOR-16.md#l-16.1)** | Werkzeug nicht angefasst; Übersichtszeilen [AN-1](BEFUNDE.md#an-1)/[AN-2](BEFUNDE.md#an-2) in BEFUNDE.md beginnen jetzt mit dem Urteilswort |
| **[L-16.2](Befunde/LEKTOR-16.md#l-16.2) / [L-17.7](Befunde/LEKTOR-17.md#l-17.7)** | BEFUNDE [AN-1](BEFUNDE.md#an-1): Kasten um 7.2.0.82/83, Teil 11 und IMAP; Altstellen mit Nachtrag — **erledigt** |
| **[L-16.3](Befunde/LEKTOR-16.md#l-16.3)** | Markentabelle auf 7.2.0.83, Marken 9–11 ergänzt; Weg-Tabelle nur als „Stand 7.2.0.76" gekennzeichnet |
| **[L-16.4](Befunde/LEKTOR-16.md#l-16.4) / [L-17.4](Befunde/LEKTOR-17.md#l-17.4)** | AUFGABEN B5: Tabelle um B5.8–B5.11, Altsätze als erledigt — **erledigt** |
| **[L-16.5](Befunde/LEKTOR-16.md#l-16.5) / [L-17.6](Befunde/LEKTOR-17.md#l-17.6)** | CHANGELOG: „Noch offen", Nachträge in 7.2.0.80-an1, 7.2.0.80, 7.2.0.79 — **erledigt**; Stern in der Bau-Kennung offen |
| **[L-16.6](Befunde/LEKTOR-16.md#l-16.6)** | PAKETE 1.0.79 Nachtrag, 1.0.83 „angewiesen, nicht veröffentlicht" — **erledigt** |
| **[L-16.8](Befunde/LEKTOR-16.md#l-16.8)** | WEITERMACHEN „Der nächste Schritt" — **erledigt**; Zeile `:27` nicht trennbar, zwei Schranken weisen gegenläufig ab |
| **[L-16.10](Befunde/LEKTOR-16.md#l-16.10) / [L-17.3](Befunde/LEKTOR-17.md#l-17.3)** | ZIEL, README (mit LogLevel 65536), PORTIERUNG, ZWEIGE — **erledigt** |
| **[L-17.1](Befunde/LEKTOR-17.md#l-17.1)** | [AN-2](BEFUNDE.md#an-2) überall „seit 7.2.0.82 übersetzt, am laufenden Programm nicht gemessen" — **erledigt** |
| **[L-17.2](Befunde/LEKTOR-17.md#l-17.2)** | „-an1" nachgezogen, beide falschen Verweise berichtigt — **erledigt** |
| **[L-17.5](Befunde/LEKTOR-17.md#l-17.5)** | Zählung festgelegt: **elf Teile B5.1–B5.11, zehn behoben, [B5.7](AUFGABEN.md#b5.7) offen** |
| **[L-19.3](Befunde/LEKTOR-20.md#l-19.3)** (nachgeholt) | Langpfad-Präfix im CHANGELOG 7.2.0.83 jetzt `\\?\` (Bytes `5C 5C 3F 5C`) |

**Werkzeuge nach dem Durchgang** (nur lesend): `perl tools/doku-pruefen.pl` —
*„Kein Widerspruch gefunden"*, zur Kenntnis nur noch `Testdaten/README.md` und
`tools/WERKZEUGE.md` (höchste genannte Fassung 7.2.0.73); `ZIEL.md`,
`PORTIERUNG.md` und `tools/pruefdaten/LIESMICH.md` sind aus der Liste
verschwunden. `perl tools/pruefe-stand-md.pl` — siehe Bericht.

## Sechsundzwanzigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-21.md`)

Kurzlauf vor dem Release v1.0.83 über die Liste der offenen Befunde (29) und die
Nachträge des CHRONISTEN. Ein Mangel (eine Lehre nannte das Langpfad-Präfix als
noch offen) und ein Nebenbefund im Kommentar von `tools/offene-befunde.pl` —
**beide behoben** im selben Commit.

## Siebenundzwanzigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-22.md`)

Nach dem Release v1.0.83: Release, ZIP-Prüfsumme und drei Stichproben gegen
Gregors Verzeichnis nachgemessen — stimmen. Vier Mängel (veraltete Liste „Bei
Gregor liegen" in `ZIEL.md` und `AUFGABEN.md`, [E-94](BEFUNDE.md#e-94) im CHANGELOG im Widerspruch
zu WEITERMACHEN, die v1.0.83-Zeile in `tools/RELEASES.md` außerhalb der Tabelle
und in Ortszeit) — **alle behoben** im selben Commit.

## Achtundzwanzigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-23.md`)

[E-94](BEFUNDE.md#e-94) / 7.2.0.84 gegen `C:\Temp\E94-vorher` und `E94-nachher`. Die Messung stimmt;
drei Mängel (ein Rest „noch nicht gebaut“ im CHANGELOG, Fall 03 mit 224 statt der
gemessenen 217/216, `ZIEL.md` mit Quellstand 7.2.0.83) — **alle behoben** im selben
Commit.

## Neunundzwanzigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-24.md`)

E-94-Bestätigung gegen Gregors Bildschirmfoto: vier Mängel (WEITERMACHEN, ZIEL, AUFGABEN B7 ohne IMAP und Bestätigung; Listenzitat nicht wörtlich) — **alle behoben** im selben Commit.

## Dreißigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-25.md`)

Nach dem Release v1.0.84: GitHub nachgemessen, stimmt. Vier Widersprüche, entstanden
beim Nachziehen (neue Sätze neben Resten der alten Fassung in WEITERMACHEN und ZIEL,
zwei ZIP-Zeilen in PAKETE 1.0.84, v1.0.83 ohne Zeitbezug als *Latest*) — **alle
behoben** im selben Commit.

## Einunddreißigster Durchgang — 12.10.2026 (Bericht: `Befunde/LEKTOR-26.md`)

Nach dem Verlinken (PR #90), angestoßen von Gregor: *„mach lektor"*. Zehn Mängel,
**alle behoben** im selben Commit. Zehn Doku-Schranken liefen grün — **gefunden
hat keine davon einen einzigen der zehn.**

Zwei Werkzeuge standen in keiner Zeile von `WERKZEUGE.md` (`verweise-filtern.pl`
am selben Tag gebaut, `pruefe-testdaten-anonym.pl` seit Langem in jedem Commit);
`README.md` führte nicht zu `TESTPLAN.md`; `CHANGELOG.md` listete das bestätigte
[E-94](BEFUNDE.md#e-94) unter *„Noch offen"* und kannte das offene [E-111](BEFUNDE.md#e-111) dort nicht;
`TESTPLAN.md` ließ die fünfzehnte wartende Behebung aus ([E-101](BEFUNDE.md#e-101), Datenverlustklasse);
`WEITERMACHEN.md` behauptete eine Abweisung von `release-pruefen.pl`, die das
Werkzeug ausdrücklich nicht ausspricht; `BEFUNDE.md` vermaß sich selbst falsch
(8388/127/227 statt 8614/128/233, direkt über den Befehlen zum Nachzählen);
`CLAUDE.md` nannte *„über 7800 Zeilen"* und *„über 80 Werkzeuge"* (8614 und 106);
`PRUEFUNG-BRANCH.md` schrieb `NP3-6/7` statt beider Kennungen.

**Der teuerste Punkt ist [L-18.10](Befunde/LEKTOR-26.md#l-18.10):** die Verlinkung von PR #90 hatte vier Lücken,
und alle vier hat **Gregor** gefunden, nicht ich und nicht die Schranke, die ich
dazu gebaut hatte. Sie lief grün, während [E-85](BEFUNDE.md#e-85), [E-98](BEFUNDE.md#e-98) bis [E-101](BEFUNDE.md#e-101), [L-17](Befunde/LEKTOR-12.md#l-17) und [B5.7](AUFGABEN.md#b5.7)
unverlinkt dastanden — weil sie nur prüfte, was das Werkzeug selbst für
verlinkbar hielt. Eine Schranke, die ihren Umfang aus derselben Annahme nimmt
wie das Werkzeug, das sie prüfen soll, prüft nichts ([E-109](BEFUNDE.md#e-109)).

**Und der Nachschlag, [L-18.11](Befunde/LEKTOR-26.md#l-18.11):** das Verlinken hat an einem Tag **zwölf**
Werkzeuge blind gemacht, die alle dieselbe Zeile lesen — die erste Zelle der
Urteilstabelle. `pruefe-behoben-ausgeliefert.pl` ging von 17 geprüften Urteilen
auf **0** und meldete weiter grün; `pruefe-befund-verbreitung.pl` ebenso.
Nachgemessen Werkzeug für Werkzeug gegen einen Arbeitsbaum auf `97f50c8`:
jede der neunzehn `pruefe-*`-Schranken liefert wieder dieselbe Ausgabe wie vor
dem Verlinken.

## Zweiunddreißigster Durchgang — 13.10.2026 (Bericht: `Befunde/LEKTOR-27.md`)

Nach Gregors Test an Paket 1.0.84, vor dem Merge von `e-112_e-113_fix`. 103 MDs
gegen den Bestand. Fünfzehn Mängel: **dreizehn berichtigt**; zwei liegen an den
Haken und sind nur gemeldet bzw. umgangen ([L-27.13](Befunde/LEKTOR-27.md#l-27.13), [L-27.15](Befunde/LEKTOR-27.md#l-27.15): der eingerichtete
`pre-commit` ist vom 18.09.2026 und ruft `pruefe-befundurteile.pl` nicht auf).
`doku-pruefen.pl` und `pruefe-stand-md.pl` liefen grün; `offene-befunde.pl`
meldete *„30 fehlen“* bei deckender Liste — es war seit dem Verlinken der Tabelle
blind ([L-27.1](Befunde/LEKTOR-27.md#l-27.1), Werkzeug berichtigt, Gegenprobe gefahren).

Der Kern: die Bestätigungen des Tages standen in `BEFUNDE.md`, aber
`AUFGABEN.md`, `TESTPLAN.md`, `WEITERMACHEN.md`, `ZIEL.md` und `CHANGELOG.md`
ließen die vierzehn aus Teil A weiter *warten*, [E-101](BEFUNDE.md#e-101) als erledigt stehen und
[E-115](BEFUNDE.md#e-115) unter *Noch offen* weg. Die widerlegte Werbe-Betriebsart stand in **neun**
Dateien weiter als Tatsache ([L-27.4](Befunde/LEKTOR-27.md#l-27.4)). Älter und ausgerechnet zum Namensgeber des
Zweigs: `AUFGABEN.md` nannte [E-112](BEFUNDE.md#e-112) seit vier Wochen *„behoben in 7.2.0.76“*
([L-27.3](Befunde/LEKTOR-27.md#l-27.3)). Dazu drei byteidentisch doppelte Zeilen in `tools/ZWEIGE.md` und
eine falsche Probenzahl in `tools/WERKZEUGE.md`.

Nebenbei gemessen ([L-27.13](Befunde/LEKTOR-27.md#l-27.13)): der `pre-commit` spiegelt nach jedem CHRONIST-Lauf
dessen Lehren in den Baum, in dem gerade committet wird, und weist dort ab, bis
die Übersicht nachgezogen ist.

## Dreiunddreißigster Durchgang — 13.10.2026 (Bericht: `Befunde/LEKTOR-28.md`)

Zum Quellstand 7.2.0.85 auf `e-112-skalierung`, vor einem Paket 1.0.85. 193 MDs,
105 außerhalb von `Arbeitsweise/`, gegen den Bestand. Zehn Mängel, **acht
berichtigt**, zwei nur gemeldet ([L-28.9](Befunde/LEKTOR-28.md#l-28.9) Fehlalarm in `doku-pruefen.pl`,
[L-28.10](Befunde/LEKTOR-28.md#l-28.10) die Spiegelung blockierte wieder den Commit). Alle fünf Doku-Schranken
liefen vorher **grün**.

Der Kern: [E-112](BEFUNDE.md#e-112) war behoben und am laufenden Programm gemessen, aber
`CHANGELOG.md`, `WEITERMACHEN.md` und `Releases/PAKETE.md` sagten *noch nicht
gemessen* oder *wieder offen*, `WEITERMACHEN.md` und `ZIEL.md` nannten 7.2.0.84
als Quellstand, `ZIEL.md` [E-103](BEFUNDE.md#e-103) *noch nicht beurteilt*, obwohl Gregor es widerlegt
hatte. Umgekehrt stand nirgends, dass die Messung **vor** PRÜFER-22 F1 und F2
lief ([L-28.6](Befunde/LEKTOR-28.md#l-28.6)) — und F1 war als Änderung an `PGEMBED.C` beschrieben, die
wirkungslos ist, weil `Paige32.dll` nicht aus dem Quelltext gebaut wird
([L-28.7](Befunde/LEKTOR-28.md#l-28.7), nach `ac8f030`). [E-116](BEFUNDE.md#e-116) fehlte unter *Noch offen*, die
E-112-Prüfnachricht in `Testdaten/README.md`.

## Vierunddreißigster Durchgang — 13.10.2026 (Bericht: `Befunde/LEKTOR-29.md`)

Kurzer Lauf nach [LEKTOR-28](Befunde/LEKTOR-28.md#lektor-28), zum Stand `9f5142b` auf `e-112-skalierung`:
nur die neuen Themen, aber in allen 195 MDs gesucht. Sechs Mängel, **vier
berichtigt**, zwei nur gemeldet ([L-29.5](Befunde/LEKTOR-29.md#l-29.5) Fehlalarm in `pruefe-befundurteile.pl`,
[L-29.6](Befunde/LEKTOR-29.md#l-29.6) die Spiegelung eines laufenden CHRONIST blockierte den Commit).

Der Kern: PRÜFER-22 F1 und F2 waren am Bau `11b6a3a` gemessen, und `BEFUNDE.md`
und `CHANGELOG.md` sagten es — acht andere Dateien und ein Aufzählungspunkt im
CHANGELOG selbst sagten weiter *„noch nicht gebaut“* ([L-29.1](Befunde/LEKTOR-29.md#l-29.1)). PRÜFER-23 und
seine Funde N1–N5 standen in keiner MD außer dem Bericht ([L-29.2](Befunde/LEKTOR-29.md#l-29.2)). Und N1
ist nur zur Hälfte behoben: die Gegenrichtung, nur `height` über 600, ergibt
weiter `width="1"` (`msgutils.cpp:3668-3677`, aus der Quelle gelesen,
[L-29.3](Befunde/LEKTOR-29.md#l-29.3)).

## Fünfunddreißigster Durchgang — 13.10.2026 (Bericht: `Befunde/LEKTOR-30.md`)

Kurzer Lauf nach [LEKTOR-29](Befunde/LEKTOR-29.md#lektor-29), zum Stand `f305f49` auf `e-112-skalierung`:
nur die neuen Themen, aber in allen 198 MDs gesucht. Vier Mängel, **alle
berichtigt**.

Der Kern: `f305f49` hatte N1 und seine Gegenrichtung in den Einzelabschnitten
als gemessen nachgezogen, die Stand-Köpfe in `AUFGABEN.md`, `ZIEL.md`,
`PORTIERUNG.md`, `WEITERMACHEN.md` (Schritt 3) und `README.md` sagten weiter
*„N1 noch nicht gemessen“* und *„194/194“* ([L-30.1](Befunde/LEKTOR-30.md#l-30.1)). In `Releases/PAKETE.md`
standen die Messwerte unter *Nicht gemessen* ([L-30.2](Befunde/LEKTOR-30.md#l-30.2)), `Testdaten/README.md`
zählte sechs statt sieben `<img>` ([L-30.3](Befunde/LEKTOR-30.md#l-30.3)).

## Sechsunddreißigster Durchgang — 13.10.2026 (Bericht: `Befunde/LEKTOR-31.md`)

Lauf nach [LEKTOR-30](Befunde/LEKTOR-30.md#lektor-30), zum Stand `2d7c922` auf `e-112-skalierung` (Quellstand
7.2.0.87) plus [PRÜFER-25](Befunde/PRUEFER-25.md); in allen 202 MDs gesucht. Sechs Mängel, **alle
berichtigt**; `commit-bereit.pl` war vorher grün.

Der Kern: Gregors Urteile an 1.0.86 ([E-112](BEFUNDE.md#e-112), [E-103](BEFUNDE.md#e-103), [E-115](BEFUNDE.md#e-115) bestätigt) standen nur in
`BEFUNDE.md` und im Plan in `WEITERMACHEN.md`; die Stand-Köpfe sagten weiter
*„von Gregor noch nicht bestätigt“*, *„ungemessen“* und `WEITERMACHEN.md` sogar
*„Quellstand 7.2.0.85“* ([L-31.1](Befunde/LEKTOR-31.md#l-31.1)). `CHANGELOG.md` führte [E-115](BEFUNDE.md#e-115) als offen und
ungemessen ([L-31.2](Befunde/LEKTOR-31.md#l-31.2)), [E-118](BEFUNDE.md#e-118)/[E-119](BEFUNDE.md#e-119) standen außer dort nirgends ([L-31.3](Befunde/LEKTOR-31.md#l-31.3)), der
Testplan hatte keinen Schritt für 1.0.85–1.0.87 ([L-31.4](Befunde/LEKTOR-31.md#l-31.4)), die neue Prüfnachricht
fehlte in `Testdaten/README.md` ([L-31.5](Befunde/LEKTOR-31.md#l-31.5)). Aus [PRÜFER-25](Befunde/PRUEFER-25.md): die Ursachenstelle von
[E-118](BEFUNDE.md#e-118) war falsch, der Behebungsort von [E-119](BEFUNDE.md#e-119) zu spät ([L-31.6](Befunde/LEKTOR-31.md#l-31.6)).

## Siebenunddreißigster Durchgang — 14.10.2026 (Bericht: `Befunde/LEKTOR-32.md`)

Kurzlauf vor dem PR `e-112-skalierung` → `main`, zum Stand `1ea7fb3` (Quellstand
7.2.0.87); in allen 205 MDs gesucht. Vier Mängel, **alle berichtigt**.

Der Kern: Gregor hat [E-117](BEFUNDE.md#e-117) am 14.10.2026 an 1.0.87 bestätigt; das stand nur im
Kopf der Zeile in `BEFUNDE.md`. Rumpf derselben Zeile, `AUFGABEN.md`, `CHANGELOG.md`,
`README.md`, `PORTIERUNG.md`, `ZIEL.md`, `Testdaten/README.md` und `WEITERMACHEN.md`
sagten weiter *„von Gregor noch nicht bestätigt“* bzw. *„in Arbeit“* ([L-32.1](Befunde/LEKTOR-32.md#l-32.1)).
Der Einstieg in `WEITERMACHEN.md` wartete noch auf Gregors Ergebnis; jetzt steht
dort PR, Release, dann [E-118](BEFUNDE.md#e-118) ([L-32.2](Befunde/LEKTOR-32.md#l-32.2)). TESTPLAN C4 hatte [E-117](BEFUNDE.md#e-117) offen ([L-32.3](Befunde/LEKTOR-32.md#l-32.3)),
`Releases/PAKETE.md` *„Von Gregor noch nicht getestet“* ([L-32.4](Befunde/LEKTOR-32.md#l-32.4)).

## Achtunddreißigster Durchgang — 14.10.2026 (Bericht: `Befunde/LEKTOR-33.md`)

Nach Release `v1.0.87` und dem Einbau von [E-105](BEFUNDE.md#e-105) in 7.2.0.88, zum Stand
`1d010e0f`; 31 MDs (Wurzel, `tools/`, `Testdaten/`, `Releases/`). Die führenden
Dateien standen schon richtig; berichtigt wurden drei nackte Kennungen
([L-33.1](Befunde/LEKTOR-33.md#l-33.1)), die `v1.0.87`-Zeile in `tools/RELEASES.md`, die außerhalb der
Tabelle und in Ortszeit stand ([L-33.2](Befunde/LEKTOR-33.md#l-33.2)), und drei Stellen, die [E-105](BEFUNDE.md#e-105) noch
vor dem Einbau zeigten ([L-33.3](Befunde/LEKTOR-33.md#l-33.3)).

Der Kern: [E-95](BEFUNDE.md#e-95) und [E-96](BEFUNDE.md#e-96) bleiben offen. Gregors Bestätigung von
[E-112](BEFUNDE.md#e-112) an 1.0.86 gilt einem Logo in der Kleinanzeigen-Nachricht, nicht den
zerschnittenen Doctolib-Bildern und nicht mehreren Bildern verschiedener Höhe
([L-33.4](Befunde/LEKTOR-33.md#l-33.4)); der C3-Handgriff im Testplan nennt aber das E-112-Kriterium
([L-33.5](Befunde/LEKTOR-33.md#l-33.5)). Offen außerdem: `release-veroeffentlichen.ps1` schreibt Ortszeit
und hängt hinter ein Blockzitat ([L-33.6](Befunde/LEKTOR-33.md#l-33.6)).

## Neununddreißigster Durchgang — 14.10.2026 (Bericht: `Befunde/LEKTOR-34.md`)

Nach dem Merge von PR #97 ([E-105](BEFUNDE.md#e-105), 7.2.0.88) und dem Einbau von [E-118](BEFUNDE.md#e-118) in
7.2.0.89, zum Stand `65d066a8`; 41 MDs aus `git ls-files` ohne `Befunde/` und
`Arbeitsweise/`. Berichtigt: [E-105](BEFUNDE.md#e-105) ohne Merge-Vermerk und mit erwartetem Test an
1.0.88, das nie ausgeliefert wurde ([L-34.2](Befunde/LEKTOR-34.md#l-34.2)); [E-118](BEFUNDE.md#e-118) in `README.md` noch
*„am Quelltext belegt“* ([L-34.3](Befunde/LEKTOR-34.md#l-34.3)); das Testverzeichnis 1.0.89 als nicht vorhanden
geführt ([L-34.4](Befunde/LEKTOR-34.md#l-34.4)); TESTPLAN bekommt C5 für 1.0.89 ([L-34.5](Befunde/LEKTOR-34.md#l-34.5)).

Der Kern: `befund-suchen.pl` liest nur Abschnitte mit eigener Überschrift und
übersieht damit 101 von 171 Befunden, darunter jeden ab [E-100](BEFUNDE.md#e-100) — zu
`ImapAppend.cpp` meldet es *„ein neuer Eintrag ist berechtigt“*, obwohl
[E-118](BEFUNDE.md#e-118) die Stelle nennt ([L-34.6](Befunde/LEKTOR-34.md#l-34.6)). Offen außerdem: PRÜFER hat [E-118](BEFUNDE.md#e-118) nicht
nachgerechnet, 1.0.89 liegt schon bereit ([L-34.8](Befunde/LEKTOR-34.md#l-34.8)).

## Vierzigster Durchgang — 14.10.2026 (Bericht: `Befunde/LEKTOR-35.md`)

Nach 7.2.0.90 ([E-118](BEFUNDE.md#e-118) Teil 2, [E-121](BEFUNDE.md#e-121), [E-122](BEFUNDE.md#e-122)), zum Stand `d7439ee6`; 41 MDs aus
`git ls-files` ohne `Befunde/` und `Arbeitsweise/`. Der Kern: [E-118](BEFUNDE.md#e-118) stand mit
*„BESTÄTIGT“* vorn und galt `offene-befunde.pl` als erledigt, obwohl Teil 2 nicht
bestätigt ist; [E-121](BEFUNDE.md#e-121) und [E-122](BEFUNDE.md#e-122) fehlten in der offenen Liste ([L-35.1](Befunde/LEKTOR-35.md#l-35.1)).
Berichtigt außerdem: „bestätigt“ ohne Teil 2 bzw. „nicht getestet“ nach Gregors
Test in sieben Dateien ([L-35.2](Befunde/LEKTOR-35.md#l-35.2)); das falsche IMAP-Ordnerpräfix bei [E-120](BEFUNDE.md#e-120)
([L-35.3](Befunde/LEKTOR-35.md#l-35.3)); neue Schalter des Prüfservers ([L-35.4](Befunde/LEKTOR-35.md#l-35.4)); Zweck des Zweigs ([L-35.5](Befunde/LEKTOR-35.md#l-35.5)).
Offen: `PRUEFER-27.md` fehlt auf dem Zweig ([L-35.6](Befunde/LEKTOR-35.md#l-35.6)), PRÜFER hat [E-121](BEFUNDE.md#e-121) nicht
gesehen ([L-35.7](Befunde/LEKTOR-35.md#l-35.7)), 20 von 62 Testläufen am 14.10. abgeschossen ([L-35.9](Befunde/LEKTOR-35.md#l-35.9)),
TESTPLAN-Vorschlag C6 für 1.0.90 ([L-35.11](Befunde/LEKTOR-35.md#l-35.11)).

## Einundvierzigster Durchgang — 15.10.2026 (Bericht: `Befunde/LEKTOR-36.md`)

Nach 7.2.0.96 ([E-118](BEFUNDE.md#e-118) Teil 1 und 2 bestätigt, [E-121](BEFUNDE.md#e-121) Teile 1 bis 6, Teil 6 an 1.0.96
bestätigt), zum Stand `9840ee35`; 120 MDs aus `git ls-files` ohne `Arbeitsweise/`, davon 41
außerhalb von `Befunde/` gelesen. Der Kern: [E-118](BEFUNDE.md#e-118) stand noch in der offenen Liste
([L-36.1](Befunde/LEKTOR-36.md#l-36.1)), Teil 2 galt an sieben Stellen als nicht bestätigt, `ZIEL.md` widersprach sich in
einer Zelle ([L-36.2](Befunde/LEKTOR-36.md#l-36.2), [L-36.3](Befunde/LEKTOR-36.md#l-36.3)); [E-121](BEFUNDE.md#e-121) stand bei 7.2.0.90 und fehlte mit [E-122](BEFUNDE.md#e-122) im
CHANGELOG unter *Noch offen* ([L-36.4](Befunde/LEKTOR-36.md#l-36.4)); Gregors Tests an 1.0.89 bis 1.0.96 fehlten in
`WEITERMACHEN.md` und `Releases/PAKETE.md` ([L-36.5](Befunde/LEKTOR-36.md#l-36.5)); neue Schalter von Prüfserver und
Messserie ([L-36.6](Befunde/LEKTOR-36.md#l-36.6)); `Testdaten/README.md` ([L-36.7](Befunde/LEKTOR-36.md#l-36.7)).
Offen: PRÜFER hat 7.2.0.91 bis 7.2.0.96 nicht gesehen ([L-36.8](Befunde/LEKTOR-36.md#l-36.8)), der erste Satz des
[E-121](BEFUNDE.md#e-121)-Urteils ([L-36.9](Befunde/LEKTOR-36.md#l-36.9)), feste Freigabe in `e118-serie.ps1` ([L-36.10](Befunde/LEKTOR-36.md#l-36.10)),
Messbeleg 1.0.96 nur uncommittet ([L-36.11](Befunde/LEKTOR-36.md#l-36.11)), TESTPLAN ohne C6 ([L-36.12](Befunde/LEKTOR-36.md#l-36.12)).

## Zweiundvierzigster Durchgang — 16.10.2026 (Bericht: `Befunde/LEKTOR-37.md`)

Nach 7.2.0.99 (7.2.0.97 gesendete Post und N1, 7.2.0.98 [E-83](BEFUNDE.md#e-83) zweite Ursache, 7.2.0.99 Neubau
wegen [E-124](BEFUNDE.md#e-124); 1.0.99 von Gregor bestätigt), zum Stand `8e5936aa`, vor PR und Release; 122 MDs
aus `git ls-files` ohne `Arbeitsweise/`, davon 41 außerhalb von `Befunde/` gelesen. Der Kern:
[E-121](BEFUNDE.md#e-121) stand an drei Stellen mit *„Restfälle N1–N3 offen“* ([L-37.1](Befunde/LEKTOR-37.md#l-37.1) bis [L-37.3](Befunde/LEKTOR-37.md#l-37.3)); [E-123](BEFUNDE.md#e-123) und
[E-124](BEFUNDE.md#e-124) fehlten im CHANGELOG unter *Noch offen* ([L-37.2](Befunde/LEKTOR-37.md#l-37.2)); der Block *„hier weitermachen“* führte
1.0.98 als zu testen und ein Release v1.0.97 ([L-37.4](Befunde/LEKTOR-37.md#l-37.4)); `Releases/PAKETE.md` nannte 1.0.97
*„sein Test steht aus“* ([L-37.5](Befunde/LEKTOR-37.md#l-37.5)); `WERKZEUGE.md` kannte die Defender-Prüfung nicht ([L-37.6](Befunde/LEKTOR-37.md#l-37.6)).
Offen: PRÜFER hat 7.2.0.97/98 nicht gesehen ([L-37.7](Befunde/LEKTOR-37.md#l-37.7)), der erste Satz des [E-121](BEFUNDE.md#e-121)-Urteils
([L-37.8](Befunde/LEKTOR-37.md#l-37.8)), PRÜFER-30 F6 als Datenverlust-Vermutung ohne Eintrag ([L-37.9](Befunde/LEKTOR-37.md#l-37.9)), was für
`v1.0.99` nachzuziehen ist ([L-37.11](Befunde/LEKTOR-37.md#l-37.11)), uncommittete DLLs im Hauptbaum ([L-37.13](Befunde/LEKTOR-37.md#l-37.13)).

## Dreiundvierzigster Durchgang — 16.10.2026 (Bericht: `Befunde/LEKTOR-38.md`)

Nach 7.2.0.100 ([PRÜFER-31](Befunde/PRUEFER-31.md) F1, F3, F4; PR #98 gemergt; Paket 1.0.100 bei Gregor), zum
Stand `a5604ddf`, vor dem Release v1.0.100; 124 MDs aus `git ls-files` ohne `Arbeitsweise/`, davon
41 außerhalb von `Befunde/` gelesen, dazu der neue README-Abschnitt *Auf einen Blick* Zeile für Zeile
gegen die Statusspalte von `BEFUNDE.md`. Berichtigt: 7.2.0.100 fehlte bei [E-121](BEFUNDE.md#e-121) in README,
`ZIEL.md` und CHANGELOG *Noch offen* ([L-38.1](Befunde/LEKTOR-38.md#l-38.1)); der Merge von PR #98 in `tools/ZWEIGE.md` und
das Release-Ziel v1.0.99 in `WEITERMACHEN.md` ([L-38.2](Befunde/LEKTOR-38.md#l-38.2)); der Kopf von `tools/WERKZEUGE.md`
([L-38.3](Befunde/LEKTOR-38.md#l-38.3)). Offen: *Auf einen Blick* nennt [E-121](BEFUNDE.md#e-121) erledigt, `BEFUNDE.md` einen offenen
Datenverlust ([L-38.4](Befunde/LEKTOR-38.md#l-38.4)); Junk-Bewertung bei [E-47](BEFUNDE.md#e-47) und [E-78](BEFUNDE.md#e-78) fehlen in der Tabelle ([L-38.5](Befunde/LEKTOR-38.md#l-38.5));
7.2.0.100 von keinem PRÜFER nachgerechnet ([L-38.6](Befunde/LEKTOR-38.md#l-38.6)); was für v1.0.100 nachzuziehen ist ([L-38.7](Befunde/LEKTOR-38.md#l-38.7)).

## Vierundvierzigster Durchgang — 17.10.2026 (Bericht: `Befunde/LEKTOR-39.md`)

Nach 7.2.0.101 ([PRÜFER-32](Befunde/PRUEFER-32.md): eigene Kennung für gesendete Post, gescheiterte Vorab-Kopie wird
entfernt; [E-67](BEFUNDE.md#e-67) als behoben geführt; [E-125](BEFUNDE.md#e-125) neu), zum Stand `04a33cca`, vor dem Release
v1.0.101; 126 MDs aus `git ls-files` ohne `Arbeitsweise/`, davon 41 außerhalb von `Befunde/` über
Fassungsangaben und die drei Befunde gesucht, die 15 geänderten an den geänderten Stellen gelesen.
Berichtigt: 7.2.0.101 fehlte bei [E-121](BEFUNDE.md#e-121) in README, ZIEL und CHANGELOG, [E-125](BEFUNDE.md#e-125) in der README-Tabelle
und im CHANGELOG *Noch offen*, Prüfer-Kürzel in README und TESTPLAN ([L-39.2](Befunde/LEKTOR-39.md#l-39.2)); `FILTER.md` führte
[E-67](BEFUNDE.md#e-67) und [E-76](BEFUNDE.md#e-76) als offen, [E-76](BEFUNDE.md#e-76) seit 11.09.2026 bestätigt ([L-39.5](Befunde/LEKTOR-39.md#l-39.5)); `messen-e67.ps1` fehlte in
`tools/WERKZEUGE.md` ([L-39.3](Befunde/LEKTOR-39.md#l-39.3)); ZIEL und ZWEIGE ([L-39.4](Befunde/LEKTOR-39.md#l-39.4)). Offen: *Auf einen Blick* verspricht weiter
mehr als das E-121-Urteil, PRÜFER hat 7.2.0.101 nicht gesehen ([L-39.1](Befunde/LEKTOR-39.md#l-39.1)); Kürzel in der CHANGELOG-Zeile
[E-121](BEFUNDE.md#e-121) ([L-39.6](Befunde/LEKTOR-39.md#l-39.6)); was für v1.0.101 nachzuziehen ist, Defender für 1.0.100/1.0.101 nirgends belegt
([L-39.7](Befunde/LEKTOR-39.md#l-39.7)).

## Fünfundvierzigster Durchgang — 17.10.2026 (Bericht: `Befunde/LEKTOR-40.md`)

Nach Release v1.0.101 (Marke auf `eec4e4e5`, PR #99, Doku PR #100) und 7.2.0.102 auf
`e-123-beenden-warten` ([E-123](BEFUNDE.md#e-123) Teilbehebung: Beenden wartet; [E-125](BEFUNDE.md#e-125) Gregors Entscheidung B), zum
Stand `3ea8cbc7`; 129 MDs aus `git ls-files` ohne `Arbeitsweise/`, davon 42 außerhalb von `Befunde/`
über Stand- und Release-Aussagen gesucht. Berichtigt: neue Prüfserver-Option, drei Parameter und
`messen-e123.ps1` fehlten in `tools/WERKZEUGE.md` ([L-40.2](Befunde/LEKTOR-40.md#l-40.2)); v1.0.101 stand in README,
CHANGELOG (13 Überschriften), ZIEL, PAKETE, WEITERMACHEN und ZWEIGE noch als Zukunft ([L-40.3](Befunde/LEKTOR-40.md#l-40.3));
[E-123](BEFUNDE.md#e-123)-Teilbehebung und [E-125](BEFUNDE.md#e-125)-Entscheidung fehlten außerhalb von `BEFUNDE.md` ([L-40.4](Befunde/LEKTOR-40.md#l-40.4)).
Offen: `offene-befunde.pl` liest [E-123](BEFUNDE.md#e-123) als erledigt ([L-40.1](Befunde/LEKTOR-40.md#l-40.1)); PRÜFER und CHRONIST für
7.2.0.102 fällig ([L-40.5](Befunde/LEKTOR-40.md#l-40.5)).

## Sechsundvierzigster Durchgang — 17.10.2026 (Bericht: `Befunde/LEKTOR-41.md`)

Nach 7.2.0.103 bis 7.2.0.106 auf `e-123-beenden-warten` ([E-123](BEFUNDE.md#e-123) nach PRÜFER-34/35, [E-69](BEFUNDE.md#e-69) in Task
Errors) und Gregors *„ja, e-121 behoben“* (17.10.2026, Chat), zum Stand `d3314ddd`; 132 MDs aus `git ls-files`
ohne `Arbeitsweise/`, davon 42 außerhalb von `Befunde/` durchsucht. Auftrag: nur melden, nichts ändern.
Offen: Gregors Urteil zu [E-121](BEFUNDE.md#e-121) steht in keiner Datei, `BEFUNDE.md:288`, CHANGELOG, WEITERMACHEN, ZIEL
und README führen den Befund offen, die zwei Restfälle in der README brauchen eine eigene Kennung
([L-41.1](Befunde/LEKTOR-41.md#l-41.1)); `v1.0.87` als *„veröffentlicht ist“* in ZIEL und AUFGABEN ([L-41.2](Befunde/LEKTOR-41.md#l-41.2)); [E-123](BEFUNDE.md#e-123) fehlt im
Maßstab 7.2.1.0 ([L-41.3](Befunde/LEKTOR-41.md#l-41.3)); README und CHANGELOG nennen für [E-123](BEFUNDE.md#e-123) 90 s und 7.2.0.102 statt bis zu
5 Minuten ab 7.2.0.104 ([L-41.4](Befunde/LEKTOR-41.md#l-41.4)); README überzeichnet [E-69](BEFUNDE.md#e-69), CHANGELOG und FILTER ohne 7.2.0.106
([L-41.5](Befunde/LEKTOR-41.md#l-41.5)); `messen-e69.ps1` und `messen-e123-doppelt.ps1` fehlen in `tools/WERKZEUGE.md` ([L-41.8](Befunde/LEKTOR-41.md#l-41.8)).

## Siebenundvierzigster Durchgang — 19.10.2026 (Bericht: `Befunde/LEKTOR-42.md`)

Nach 7.2.0.107 bis 7.2.0.110 auf `E-101_korrektur_datei_speichern` und `e-69-meldungsflut`
([E-101](BEFUNDE.md#e-101) dritter Teil mit [PRÜFER-37](Befunde/PRUEFER-37.md), [E-123](BEFUNDE.md#e-123) P1/P2, [E-69](BEFUNDE.md#e-69) P3, dazu R1–R4 aus
[PRÜFER-38](Befunde/PRUEFER-38.md)), zum Stand `8d1075b0`; 233 MDs aus `git ls-files`, davon 136 ohne
`Arbeitsweise/` und 42 außerhalb von `Befunde/` durchsucht. Auftrag: melden und berichtigen.
Berichtigt: der Quellstand stand an **sechs** Stellen auf 7.2.0.106, während `Version.h` 7.2.0.110
sagt — in `WEITERMACHEN.md:9` sogar drei Zeilen über der richtigen Paketnummer ([L-42.1](Befunde/LEKTOR-42.md#l-42.1));
der Block *HIER WEITERMACHEN* und die Kopftabelle nannten weder 1.0.110 noch das Paket, das Gregor
wirklich hat ([L-42.2](Befunde/LEKTOR-42.md#l-42.2), [L-42.3](Befunde/LEKTOR-42.md#l-42.3)); die **Regression F3/F4** zu [E-101](BEFUNDE.md#e-101) fehlte in README, TESTPLAN,
ZIEL, AUFGABEN und in der CHANGELOG-Zeile *Noch offen* ([L-42.4](Befunde/LEKTOR-42.md#l-42.4)); der Testplan nannte 1.0.110
im Kopf und gab dazu keinen einzigen Handgriff — neuer Abschnitt [C6](TESTPLAN.md#c6) ([L-42.5](Befunde/LEKTOR-42.md#l-42.5)); die
Prüfpunkte am Beenden-Weg wurden mehrfach wie der Befund [E-123](BEFUNDE.md#e-123) gelesen, einmal von mir selbst
— `pruefe-befundurteile.pl` hat es gefangen ([L-42.6](Befunde/LEKTOR-42.md#l-42.6)); [E-69](BEFUNDE.md#e-69) endete an vier Stellen bei
7.2.0.106 ([L-42.7](Befunde/LEKTOR-42.md#l-42.7)); zwei Zeilen in `tools/ZWEIGE.md` standen durch Leerzeilen außerhalb der
Tabelle ([L-42.8](Befunde/LEKTOR-42.md#l-42.8)); die Prüfanleitung zu 7.2.0.107 verlangte etwas, das auf dem einzigen
Aufrufweg nicht vorkommt ([L-42.9](Befunde/LEKTOR-42.md#l-42.9)); zwei PRÜFER-Berichte luden zum Test nie geschnürter
Pakete ein ([L-42.10](Befunde/LEKTOR-42.md#l-42.10)). Offen: `pruefe-befundurteile.pl` prüft sieben von Hand aufgezählte
Dokumente ohne TESTPLAN, AUFGABEN und PAKETE ([L-42.12](Befunde/LEKTOR-42.md#l-42.12)); `doku-pruefen.pl` sieht einen
Widerspruch innerhalb derselben Tabelle nicht ([L-42.13](Befunde/LEKTOR-42.md#l-42.13)); [E-123](BEFUNDE.md#e-123) fehlt weiter im Maßstab
7.2.1.0 — Gregors Entscheidung ([L-42.14](Befunde/LEKTOR-42.md#l-42.14)).


## Achtundvierzigster Durchgang — 20.10.2026 (Bericht: `Befunde/LEKTOR-43.md`)

**Der erste Durchgang nach einem Release.** `v1.0.112` ging um 11:55:10 UTC
hinaus; der veröffentlichte Text ist mit `Releases/1.0.112/RELEASE-NOTIZEN.md`
byte-gleich, und die Datei war an drei Stellen beschädigt: der
Aufzählungspunkt zu [E-69](BEFUNDE.md#e-69) hatte seinen Kopf verloren und hing
als Fließtext am Punkt darüber, der Einleitungssatz brach nach „Nichts zu
installieren. Das" ab, und eine Überschrift stand doppelt
([L-43.1](Befunde/LEKTOR-43.md#l-43.1)). Die Notizen schrieben Gregors Messung
dem Paket 1.0.112 zu — gemessen hat er an 1.0.111, 26 Minuten vor dem Bau von
1.0.112 ([L-43.2](Befunde/LEKTOR-43.md#l-43.2)). Nach dem Release sagten sechs
Stellen weiter `v1.0.101` ([L-43.3](Befunde/LEKTOR-43.md#l-43.3)); die README,
auf die die Notizen für die „vollständige Liste" verweisen, kannte
[E-128](BEFUNDE.md#e-128), [E-129](BEFUNDE.md#e-129) und
[E-131](BEFUNDE.md#e-131) mit keinem Wort
([L-43.4](Befunde/LEKTOR-43.md#l-43.4)); der Testplan nannte im Kopf 1.0.112 und
schickte Gregor nach 1.0.110, mit zwei Schritten, die er längst bestätigt hatte
([L-43.5](Befunde/LEKTOR-43.md#l-43.5)); [E-131](BEFUNDE.md#e-131) stand als
verwaiste Tabellenzeile in der letzten Zeile von `BEFUNDE.md` statt im
Verzeichnis ([L-43.6](Befunde/LEKTOR-43.md#l-43.6)); die Liste „Noch offen"
vom heutigen Tag kannte drei der vier neuen Befunde nicht
([L-43.7](Befunde/LEKTOR-43.md#l-43.7)); `tools/RELEASES.md` kannte `v1.0.112`
nicht, und seine beiden jüngsten Zeilen standen außerhalb der Tabelle
([L-43.8](Befunde/LEKTOR-43.md#l-43.8)).

**Offen:** `pruefe-release-buchfuehrung.pl` hängt im `pre-commit`, das Tag
entsteht danach — die Unwahrheit entsteht in einem Augenblick, den keine
Schranke sieht ([L-43.11](Befunde/LEKTOR-43.md#l-43.11));
`paket-bereit.pl` gibt acht Schranken als „alle" aus
([L-43.12](Befunde/LEKTOR-43.md#l-43.12)); `ist_standaussage()` hört auf
Wörter, nicht auf Aussagen ([L-43.13](Befunde/LEKTOR-43.md#l-43.13)); die
PRÜFER-Berichte haben vier Nummernkreise, und [`P-39`](Befunde/PRUEFER-14.md#p-39) ist an einen anderen
Befund vergeben ([L-43.14](Befunde/LEKTOR-43.md#l-43.14)); kein Werkzeug prüft
die Release-Notizen auf Befundurteile
([L-43.15](Befunde/LEKTOR-43.md#l-43.15)).

## Nachtrag am 20.10.2026 (kein eigener Durchgang)
**Nachtrag am 20.10.2026 — nicht vom LEKTOR, sondern beim Versionssprung auf
7.2.0.111.** [LEKTOR-42](Befunde/LEKTOR-42.md) nennt an drei Stellen 7.2.0.110
als Quellstand. Der Bericht ist ein **Rückblick** auf den 19.10.2026 und bleibt
inhaltlich unverändert; die drei Stellen tragen jetzt den Vermerk, dass der
Quellstand seit dem 20.10.2026 **7.2.0.111** ist. **Weiter fortgeschrieben am 20.10.2026 ([LEKTOR-43](Befunde/LEKTOR-43.md#lektor-43)):** seit 13:41 Uhr ist der Quellstand **7.2.0.112**, und seit 11:55 UTC ist `v1.0.112` veröffentlicht. `pruefe-stand-md.pl` hat den
Nachtrag erzwungen — ein Bericht, der ohne Hinweis eine überholte Fassung als
gültig ausgibt, ist eine Unwahrheit auf `main`.
