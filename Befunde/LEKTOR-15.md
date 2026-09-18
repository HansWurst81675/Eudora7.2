# LEKTOR-15 — keine Lügen auf dem `main`, nach Release v1.0.72

**Stand 18.09.2026.** Zweig `schranken-vor-dem-commit`. Vorgänger:
[LEKTOR-14.md](LEKTOR-14.md), [LEKTOR-13.md](LEKTOR-13.md).

Gregors Auftrag, wörtlich:

> *„es scheinen einige MDs veraltet zu sein, was falsch ist: **keine lügen auf
> dem main**."*

Und er hat den ersten Fund selbst geliefert: `README.md` sagte zu **E-108**
*„bei Gregor noch nicht bestätigt"*, während `BEFUNDE.md` in derselben Fassung
*„von Gregor am laufenden Programm bestätigt"* schrieb. Zwei Dateien, eine
Tatsache, zwei Antworten.

## Umfang

Aus der Quelle, nicht aus dem Kopf
([pruefumfang-nicht-von-hand.md](../Arbeitsweise/pruefumfang-nicht-von-hand.md)):

```
git ls-files "*.md"   ->  155 Dateien
```

**155 Markdown-Dateien, alle 155 maschinell durchsucht**, 22 davon von Hand
gegen den gemessenen Stand gehalten. Berichtigt wurden **10**: `PORTIERUNG.md`,
`ZIEL.md`, `AUFGABEN.md`, `BEFUNDE.md`, `WEITERMACHEN.md`, `CHANGELOG.md`,
`README.md`, `tools/ZWEIGE.md`, `LEKTORAT.md`, `Releases/PAKETE.md`.

## Der Maßstab — gemessen, nicht abgeschrieben

| Frage | Messung | Ergebnis |
|---|---|---|
| Neuestes Release | `gh release list` | **`v1.0.72`**, *Latest*, 2026-09-17T20:07:49Z; davor `v1.0.64` (10:23:08Z) |
| Quellstand | `Eudora71/Version.h:14` | **7.2.0.72** |
| Paketnummer | `VERSION` | **1.0.72** |
| Pakete bei Gregor | `ls C:\Users\Gregor\Eudora72-*` | **1.0.65, 1.0.67, 1.0.68, 1.0.69, 1.0.71, 1.0.72** — **kein 1.0.70** |
| Stand des Zweigs `p38-spurmarke-rumpf` | `git show ceab98f:Eudora71/Version.h`, `:VERSION` | **7.2.0.69 / 1.0.69** |
| Offene Befunde | `perl tools/offene-befunde.pl` | vorher 13 / 12 — **E-109 fehlte**; nach E-105: **14 / 14** |
| Testzahl | `BEFUNDE.md`, `CHANGELOG.md` 7.2.0.72 | **171/171** |
| Bilder im Prüfstand | `C:\Temp\E107-vorher\…\eudora.log`, `C:\Temp\E100\…` | **8 × `E-95 Bild`**, 3 × `E-103`, **0 × `E-106 groesser`** |

---

## Die Funde

### L-15.1 — `PORTIERUNG.md` nannte `v1.0.64` als veröffentlicht — **zum dritten Mal dieselbe Zeile**

| | |
|---|---|
| **Behauptung** | `PORTIERUNG.md:43-55`: *„Stand 17.09.2026, Quellstand **7.2.0.70**, `VERSION` **1.0.70**; als Paket geschnürt und das erste, das **alles** enthält … **Veröffentlicht** ist bei GitHub `v1.0.64` (17.09.2026, als *Latest* markiert)"* |
| **Gemessen** | `gh release list`: **`v1.0.72`**, als *Latest* markiert, 2026-09-17T20:07:49Z, Marke auf `8da72c8`. `Version.h` sagt 7.2.0.72, `VERSION` sagt 1.0.72 |
| **Warum das die schwerste ist** | **Dieselbe Zeile trug bereits den Vermerk *„berichtigt am 17.09.2026 vom LEKTOR, L-14.2"***, und davor hatte L-13.1 dieselbe Unwahrheit in fünf Dokumenten gefunden. Sie war also **zweimal berichtigt und dreimal falsch**. Ein Berichtigungsvermerk sieht wie ein Beleg aus und wird deshalb nicht nachgeprüft ([anzeige-ist-kein-zustand.md](../Arbeitsweise/anzeige-ist-kein-zustand.md)) |
| **Berichtigt** | **ja**, mit Vermerk L-15.1 |

### L-15.2 — `ZIEL.md` führte E-106 als *„ausdrücklich nicht nachgewiesen"*

| | |
|---|---|
| **Behauptung** | `ZIEL.md:17`: *„**E-106** (7.2.0.68) … von ihm noch nicht am laufenden Programm beurteilt; **E-106 ist ausdrücklich nicht nachgewiesen**"* und *„Als Paket geschnürt ist **1.0.70** … bei Gregor liegen 1.0.65, 1.0.67, 1.0.68 und 1.0.69, **1.0.70 noch nicht**"* |
| **Gemessen** | E-106 hat Gregor am 17.09.2026 an **1.0.69** bestätigt (Bildschirmfoto: Überlappung weg) — `AUFGABEN.md:52` und `README.md:92` sagten das bereits. Bei ihm liegen zusätzlich 1.0.71 und **1.0.72**; 1.0.70 dagegen **nie** |
| **Zusatz** | Die Zeile nannte das **Release `v1.0.72` mit keinem Wort**, obwohl `ZIEL.md` die Datei ist, auf die alle anderen für den Stand verweisen (*„Wer den Stand ändert, ändert ihn hier"*) |
| **Berichtigt** | **ja**, mit Vermerk L-15.2 |

### L-15.3 — `AUFGABEN.md` widersprach sich selbst, 61 Zeilen auseinander

| | |
|---|---|
| **Behauptung** | Zeile 64: *„**Gebaut und geschnürt ist 7.2.0.70 / 1.0.70** … **Es ist das erste Paket, das alles enthält**"*; Zeile 68: *„Bei Gregor liegen 1.0.65 sowie **1.0.67 bis 1.0.72**"* |
| **Gemessen** | **Zeile 3 derselben Datei** sagt bereits *„gemessen an Quellstand **7.2.0.72** / `VERSION` **1.0.72**"*, Zeile 69 *„Veröffentlicht ist `v1.0.72`"*. Und „1.0.67 bis 1.0.72" schließt **1.0.70** ein, das Gregor nie hatte |
| **Berichtigt** | **ja**, mit Vermerk L-15.3 |

### L-15.4 — `BEFUNDE.md` führte E-106 als nicht nachgewiesen

| | |
|---|---|
| **Behauptung** | `BEFUNDE.md`, E-106: *„**gebaut in 7.2.0.68, bei Gregor noch nicht nachgewiesen.**"*, am Ende der Zelle *„**Noch nicht nachgewiesen** … Bleibt sie aus, ist auch diese Ursache widerlegt"* |
| **Gemessen** | Bestätigt an 1.0.69. **Dies ist genau die Klasse, die Gregor selbst zu E-108 gefunden hat**, nur ein Befund weiter: `BEFUNDE.md` und `README.md` beantworteten dieselbe Frage verschieden |
| **Hinweis zum Urteilsformat** | Das neue Urteil bleibt mit 50 Zeichen unter der 80-Zeichen-Grenze aus **L-14.10** — sonst hätten `offene-befunde.pl` und `pruefe-befundurteile.pl` den Befund lautlos wieder als offen gezählt |
| **Berichtigt** | **ja**, mit Vermerk L-15.4 in der Zelle |

### L-15.5 — `tools/ZWEIGE.md:73` zum **dritten** Mal weitergeschoben — und die Schranke war der Antreiber

| | |
|---|---|
| **Behauptung** | *„`p38-spurmarke-rumpf` … Quellstand **7.2.0.72**, Paketnummer **1.0.72**"* |
| **Gemessen** | `git show ceab98f:Eudora71/Version.h` → **7.2.0.69**, `:VERSION` → **1.0.69**. `ceab98f` ist der Merge dieses Zweigs (PR #63), und der CHANGELOG-Abschnitt **7.2.0.69** trägt seinen Namen |
| **Die Reihe** | 69 → 70 (L-14, gemeldet) → 71 (L-14 Nachtrag, gemeldet) → **72**. **Zweimal gemeldet, dreimal weitergeschoben** |
| **Und hier kommt der eigentliche Fund** | Der Antreiber ist **`tools/doku-pruefen.pl` selbst.** Es löst auf das Wort *Paketnummer* aus (`:594`) und verlangt in den 200 Zeichen dahinter die **aktuelle** Nummer. In `tools/ZWEIGE.md` steht dort aber, was ein Zweig **gebracht** hat. **Gegengeprobt:** nach meiner ersten, wahren Berichtigung auf 1.0.69 meldete die Schranke prompt *„MANGEL: tools/ZWEIGE.md:73 nennt Paketnummer 1.0.69 als Stand, VERSION sagt 1.0.72"* — sie verlangt also die Lüge |
| **Berichtigt** | **ja**, und **ohne Eingriff in `tools/`**: die Zeile sagt jetzt *„Daraus entstand Quellstand 7.2.0.69 und Paket 1.0.69"*, dieselbe Wendung wie die Nachbarzeile `e103-darstellung-bilder` (*„Daraus entstand Paket 1.0.67"*), die seit Tagen stumm durchläuft. Danach meldet `doku-pruefen.pl` **„Kein Widerspruch gefunden"** |
| **Bleibt offen** | Die Grenze der Schranke. Sie steht jetzt als achter Punkt unter **E-109** |

### L-15.6 — `WEITERMACHEN.md`: zwei Fassungen in einer Zelle, und ein Widerspruch eine Zeile weiter

| | |
|---|---|
| **Behauptung (a)** | Zeile 13: Überschrift *„**BESTÄTIGT, 17.09.2026 — E-106**"*, Text darunter *„**bei mir nicht nachweisbar** … **Nur sein Lauf kann es belegen.** **Zu prüfen:** `LogLevel=58527` lassen, die Kleinanzeigen-Nachricht weiterleiten …"* |
| **Behauptung (b)** | Zeile 28: *„**Zuletzt von Gregor bestätigt** \| **1.0.64 am 17.09.2026**"* |
| **Gemessen** | (a) Überschrift und Inhalt derselben Zelle sagen das Gegenteil — genau die Klasse *„zwei Satzhälften aus zwei Fassungen"*. (b) **Zeile 27 derselben Datei** sagt bereits, dass Gregor **1.0.72** geprüft hat (*„kein crash"*). Zuletzt bestätigt ist **1.0.72** (E-108), davor 1.0.69 (E-106) |
| **Berichtigt** | **ja**, beide; die Prüfanweisung ist gestrichen, die Bestätigungskette steht jetzt vollständig |

### L-15.7 — `CHANGELOG.md`: die vertauschte Paketzeile stand nach L-14.1 unverändert weiter

| | |
|---|---|
| **Behauptung** | Tabelle im Abschnitt 7.2.0.70: *„1.0.69 \| 7.2.0.69 \| E-101 **zweiter Teil**, P-38 \| **E-106**"* und *„**1.0.70** \| 7.2.0.70 \| **alles** \| —"* |
| **Gemessen** | **Vertauscht.** Der E-106-Merge `0334a6c` (20:16:00) ist Vorfahr von `acc8ad7`, woraus die `Eudora.exe` von 1.0.69 um 20:24:54 entstand; der zweite Teil von E-101 (`e27ccf1`) kam um 20:58:43. **Zweiter, unabhängiger Beleg:** Gregor hat den E-106-Absturz **an 1.0.69** erlebt — ohne E-106 unmöglich. Und 1.0.70 ist nicht *„alles"*: es trägt den Absturz aus E-107/E-108 |
| **Warum das hierher gehört** | **L-14.1 hat genau das am 17.09.2026 gemessen und als teuersten Fund gemeldet.** Die Zeile stand danach unverändert. Ein Fund, der nur im Bericht landet, ist keine Berichtigung |
| **Berichtigt** | **ja**, Tabelle um 1.0.71 und 1.0.72 ergänzt, mit Vermerk L-15.7 |

### L-15.8 — eine Prüfanleitung, die auf ein abstürzendes Paket zeigt

| | |
|---|---|
| **Behauptung** | Abschnittskopf 7.2.0.70: *„**Zu prüfen:** dies ist die erste Fassung, die **alles** enthält"*, dazu der Messpunkt für E-106 |
| **Gemessen** | 1.0.70 ist **nie zu Gregor gelangt** und trägt den Absturz E-107/E-108. Der Messpunkt ist durch seinen Lauf an **1.0.69** erledigt |
| **Warum das zählt** | Eine Prüfanleitung ist eine **Handlungsanweisung**. Wer ihr folgt, lädt ein Paket, das es bei ihm nicht gibt, und ist einen Klick vom Absturz entfernt ([erst-pruefen-dann-anweisen.md](../Arbeitsweise/erst-pruefen-dann-anweisen.md)) |
| **Berichtigt** | **ja**, der Kasten sagt jetzt *„nicht mehr zu prüfen, und 1.0.70 nicht mehr zu benutzen"* und verweist auf `v1.0.72` |

### L-15.9 — **drei Fassungen einer Aussage über den eigenen Prüfstand, und die verbreitetste war falsch**

Das ist der Fund mit der größten Reichweite, denn an dieser Aussage hängt die
Erklärung, warum drei Fassungen hintereinander danebengingen.

| | |
|---|---|
| **Die drei Fassungen** | (1) `BEFUNDE.md` E-106: *„mein Prüfstand lädt die Bilder **nicht** (null Ladespuren, während Gregors Protokoll 27 hat)"*. (2) `BEFUNDE.md` E-107, `WEITERMACHEN.md` 12/15/16, `CHANGELOG.md` 143/349: *„der Prüfstand lädt **keine** Bilder — weder aus dem Netz noch als `data:`"*. (3) `BEFUNDE.md` E-108: *„der Prüfstand lädt **zwar** Bilder, aber der Block läuft dort nicht an"* |
| **Gemessen** | An `C:\Temp\E107-vorher\Mailverzeichnis\eudora.log` (17.09.2026, 21:28) und `C:\Temp\E100\…` (21:45): **je acht `E-95 Bild`-Zeilen** und **drei `E-103`-Zeilen**. Darunter `E-103 Nachtrag: quelle=79x64 embed=79x64 gefunden=1` — **`quelle=` ist die echte Dateigröße**, die nur nach dem Holen und Vermessen bekannt ist. **Null** ist allein `E-106 groesser` |
| **Warum null** | Im Testdatensatz hat **jedes** Bild `attr == embed`: `79x32`, `22x22` (dreimal), `135x40` (zweimal) — und die zwei ohne Höhe (`attr=79x0 embed=0x0`) werden vom E-103-Weg nachgemessen. **Kein einziges ist größer als angegeben**, also hat der E-106-Block nichts zu tun |
| **Urteil** | **Fassung (3) stimmt, (1) und (2) sind falsch.** Der Prüfstand lädt Bilder; ihm fehlt ein **Testdatum** ([testdaten-muessen-durchkommen.md](../Arbeitsweise/testdaten-muessen-durchkommen.md)), nicht eine Fähigkeit |
| **Was die falsche Fassung gekostet hat** | Sie stand als **erster Punkt der Nacharbeit** in `WEITERMACHEN.md` (*„Das Wichtigste zuerst: der Prüfstand lädt keine Bilder"*) und als Punkt 10 unter *„was ich falsch gemacht habe"*. Wer sie liest, baut eine Bildladefunktion in den Prüfstand — und findet den Fehler trotzdem nicht. Gebraucht wird **eine Nachricht mit einem Bild, dessen Datei größer ist als die HTML-Angabe** |
| **Zwei Zähler, ein Satz** | *„null Ladespuren"* verwechselt `E-106 groesser` mit `E-95 Bild`. Genau die Klasse aus [zwei-werte-in-eine-ausgabe.md](../Arbeitsweise/zwei-werte-in-eine-ausgabe.md) — nur andersherum: hier wurden zwei Zähler in **einen** Satz gezogen, der dann beide falsch wiedergibt |
| **Berichtigt** | **ja, an allen sechs Stellen**: `BEFUNDE.md` (E-106, E-107), `WEITERMACHEN.md` (12, 13, 15, 16), `CHANGELOG.md` (143, 349) — mit Vermerk an der CHANGELOG-Stelle. Die Zitate in `Befunde/LEKTOR-14.md` bleiben als datierter Bericht stehen |

### L-15.10 — **E-105 hatte keine Zeile**, und **E-102 ist nie vergeben worden**

| | |
|---|---|
| **Behauptung** | `WEITERMACHEN.md` führte seit dem 17.09.2026 als Nacharbeit: *„**E-105 aufschreiben:** … noch kein Befundeintrag"* |
| **Gemessen** | `grep -c "E-105" BEFUNDE.md` → **0**. `grep -c "E-102"` über alle 155 MDs → **0**. Die Kennungsreihe lautete E-100, E-101, E-103, E-104, E-106 … — **zwei Lücken**. `perl tools/befund-suchen.pl "display:none"` → *„Kein bestehender Befund nennt diesen Ort. Ein neuer Eintrag ist berechtigt."* — also keine Doppelvergabe |
| **Belegt** | An `C:\Temp\probe-ebay.eml` (40.936 Byte, 17.09.2026): **vier** `display:none`-Bereiche, darunter `<div class="preheaderMod" style="display:none;">` mit *„Jetzt bieten."* und darin `<div style="display:none;">` mit **96 Wiederholungen von `?&nbsp;`**. **Paige kennt `display` nicht:** die drei Attributlisten stehen in `PGHTMDEF.C:29`, `:38` und `:49`, `display` steht in keiner; `grep -ci display PGHTMDEF.C` = **0**. Die drei Treffer in `PGHTMIMP.CPP:966/985/1229` sind Kommentare über *„on display"* |
| **Ein Zusatz, der vor einer Falschsuche schützt** | **Die Fragezeichen sind kein Zeichensatzfehler.** Sie stehen wörtlich als `?` in der Quelle — anders als bei **E-90**, wo `ISOTranslate` Emoji zu `?` macht. Wer hier nach einer Umkodierung sucht, sucht am Fall vorbei |
| **Angelegt** | **ja**, `BEFUNDE.md` zwischen E-104 und E-106; danach `offene-befunde.pl`: **14 offen / 14 in `WEITERMACHEN.md`**, grün. **E-102 bleibt eine Lücke** — nie vergeben, nirgends belegt; wer die nächste Nummer zieht, nimmt **E-110** |

### L-15.11 — die öffentliche Grenzen-Liste nannte zwei offene Fehler nicht

| | |
|---|---|
| **Gemessen** | `README.md`, Abschnitt *Wo die Grenzen liegen*: **E-98** und **E-77** stehen da, **E-94** und **E-105** nicht (`grep -c 'E-94' README.md` → 0). Ebenso im CHANGELOG-Abschnitt *Noch offen*: **E-105**, **E-109** und die sieben LF-Weiterleitungen fehlten |
| **Warum E-94 dorthin gehört** | Der Fehler trifft den **Empfänger**, nicht den Absender: `Toner bestel len`, `Wochenend e!` in der Betreffzeile jeder gesendeten Nachricht. Wer das Programm benutzt, sieht es selbst nie |
| **Berichtigt** | **ja**: `README.md` um E-94 und E-105 ergänzt, `CHANGELOG.md` *Noch offen* um E-109, E-105 und die LF-Weiterleitungen (letztere ausdrücklich **ohne** Nummer, weil noch nicht entschieden ist, ob Eudora sie verursacht) |

---

## Die Schranken: was sie gemeldet haben

| Schranke | vorher | nachher |
|---|---|---|
| `doku-pruefen.pl` | „Kein Widerspruch gefunden", 24 Dateien | **meldete meine wahre Berichtigung als MANGEL** (L-15.5), nach der Umformulierung wieder grün |
| `offene-befunde.pl` | **13 offen / 12 gelistet — E-109 fehlte** | 14 / 14, grün |
| `pruefe-befundurteile.pl` | siehe unten | siehe unten |
| `pruefe-stand-md.pl` | grün, obwohl `LEKTORAT.md` 7.2.0.70 als jüngsten Stand nannte | nach dem Kopf-Nachtrag 7.2.0.72 |

**Keine** Schranke hat L-15.1 bis L-15.4 und L-15.6 bis L-15.11 gesehen. Das
ist kein neuer Befund, sondern **E-109 in Betrieb**: die Schranken prüfen
Zahlenformate gegeneinander, nicht Aussagen gegen die Wirklichkeit.

**Der eine neue Punkt für E-109** ist L-15.5: eine Schranke, die eine wahre
Angabe als Mangel meldet und damit die Unwahrheit erzwingt. Eine stumme
Prüfung und ein Fehlalarm sind derselbe Schaden
([schranke-gegentesten.md](../Arbeitsweise/schranke-gegentesten.md)) — nur ist
der Fehlalarm hier der teurere, weil ihm jemand **gefolgt** ist, dreimal.

---

## Was ich bewusst stehen gelassen habe

| Stelle | Warum |
|---|---|
| `Befunde/LEKTOR-13.md`, `LEKTOR-14.md` und alle übrigen `Befunde/*.md` | **datierte Berichte.** Sie zitieren `gh release list` vom 17.09.2026 mit `v1.0.64` — das war damals richtig. Ein Rückblick ist keine Lüge |
| Die Durchgangsabschnitte in `LEKTORAT.md` unterhalb des Kopfes | Fahrtenbuch; jeder Abschnitt gilt für seinen Tag. Berichtigt wurde nur der Kopf, der sich als **heutige** Aussage ausgibt |
| `CHANGELOG.md`, Abschnitte 7.2.0.x unterhalb von 7.2.0.70 | nach Fassungen gegliedert; eine Nummer im eigenen Abschnitt ist richtig. Eingegriffen habe ich nur, wo die Aussage **sachlich falsch** war (L-15.7) oder eine **Handlungsanweisung** trug (L-15.8) |
| Die Berichtigungsvermerke L-13.1 in `README.md` und `Releases/PAKETE.md`, die `v1.0.64` nennen | sie sind ausdrücklich auf den 17.09.2026 datiert und beschreiben, was **damals** gemessen wurde |
| `EINSTELLUNGEN.md`, `FILTER.md` (*„Stand 7.2.0.68 / Paket 1.0.68. Geprüft gegen diesen Quellstand."*) | **kein falscher Wert, sondern eine wahre Aussage über den Zeitpunkt der Prüfung.** `doku-pruefen.pl` meldet sie unter *Zur Kenntnis*, nicht als Widerspruch — richtig so |
| `tools/WERKZEUGE.md` (höchste genannte Fassung 7.2.0.70) | Werkzeugübersicht ohne Stand-Zusage; PRUEFER arbeitet parallel in `tools/`, ich habe dort nur `ZWEIGE.md` angefasst |
| `tools/RELEASES.md` | trägt `v1.0.72` mit Datum, Beleg und Marke — **stimmt**, nachgemessen gegen `gh release list` |
| `Arbeitsweise/*.md` | **Spiegel des Gedächtnisverzeichnisses** (L-14.9): jede Berichtigung dort wird vom Vorcommit-Haken aus der Quelle zurückgenommen. Ich habe nichts angefasst |
| `Releases/PAKETE.md` | vom parallelen Lauf am 17.09. abends neu gemessen, nennt `v1.0.72` und führt 1.0.66 bis 1.0.72 einzeln — geprüft, keine Abweichung |
| Die sieben LF-Weiterleitungen | **keine Befundnummer vergeben.** Noch nicht gemessen, ob Eudora sie verursacht oder die Samsung-App sie mitbringt. Eine Nummer ohne Messung wäre dieselbe Sorte Behauptung, die dieser Durchgang abstellt |

---

## Zeilenenden

Nach **jedem** Schreibzugriff einzeln gemessen
([zeilenenden-nach-jedem-schreibzugriff-messen.md](../Arbeitsweise/zeilenenden-nach-jedem-schreibzugriff-messen.md)):
**CR = 0 in allen neun berührten Dateien.**

Ein Fehler ist dabei passiert und **durch die Messung sofort aufgefallen**: ein
`chomp` unter `local $/` (Slurp-Modus, `$/` ist `undef`) entfernt **nichts** —
der Ersatztext behielt sein `\n` und zerlegte `BEFUNDE.md:265` in drei Zeilen
(7844 → 7846). Gefunden durch die Zeilenzählung unmittelbar nach dem Schreiben,
im selben Arbeitsschritt zurückgebaut, `git diff --numstat` gegengeprüft.
**Das ist der Grund, warum nach jedem Schreibzugriff gemessen wird** — ohne die
Messung hätte eine zerrissene Tabellenzeile im `main` gestanden.

---

## Gegenprobe an den eigenen Berichtigungen

Nicht prüfen, ob die Schranke grün meldet, sondern ob sie den eigenen Zuwachs
**sieht** ([gegenprobe-umdrehen.md](../Arbeitsweise/gegenprobe-umdrehen.md)) —
die Lehre aus **L-14.10**, wo ein Fettdruck über 80 Zeichen einen behobenen
Befund lautlos wieder öffnete. Ausgelesen wurde der erste Fettdruck der dritten
Spalte, genau wie `offene-befunde.pl` und `pruefe-befundurteile.pl` es tun:

| Befund | vorher (HEAD) | jetzt |
|---|---|---|
| E-105 | *(Zeile existierte nicht)* | `offen, Ursache am Quelltext belegt.` (35 Z.) |
| E-106 | `gebaut in 7.2.0.68, bei Gregor noch nicht nachgewiesen.` | `behoben in 7.2.0.68, von Gregor an 1.0.69 bestätigt.` (51 Z.) |
| E-109 | `offen, an einem Tag belegt.` | unverändert |

**Alle unter 80 Zeichen**, alle vom Muster getroffen. `offene-befunde.pl` und
`pruefe-befundurteile.pl` zählen danach übereinstimmend **14 offen / 72
behoben**.

`pruefe-behoben-belegt.pl` und `pruefe-anzeigetext.pl` melden weiterhin
**„geprueft 0"** — sie lesen den **gestageten** Diff, und ich stage nicht
(Gregor committet). Das ist **Befund S-2 aus L-13** unverändert: ein Prüfstand,
der über null Zeilen seinen Erfolgssatz schreibt.

## Ein Nebenfund, nicht angefasst

`BEFUNDE.md`, Zeile E-106 enthält das Quelltextzitat
`` `if (embed->height == 0 || embed->width == 0)` ``. Die beiden `|` zählen in
einer Markdown-Tabelle als Spaltentrenner, **auch innerhalb von Backticks** —
die Zeile hat dadurch **6 statt 4** Spalten. Der Mangel steht wortgleich im
`HEAD` und ist **nicht** durch diesen Durchgang entstanden (gegengeprüft mit
`git show HEAD:BEFUNDE.md`). Ich habe ihn stehen lassen: ein `\|` im Zitat
verändert den zitierten Quelltext, und das ist eine Entscheidung für Gregor,
nicht für den Lektor.

## Was als Nächstes zu tun ist

1. **`tools/doku-pruefen.pl` gegen L-15.5 schärfen** — der Auslöser
   *Paketnummer* darf in `tools/ZWEIGE.md` nicht die aktuelle Nummer
   verlangen. Vorschlag: dieselbe Ausnahme wie für Überschriften, aber am
   Merkmal statt am Dateinamen — eine Zeile, die *„Daraus entstand"*,
   *„gebracht"* oder einen Commit-Kurznamen nennt, ist eine Aussage über die
   Vergangenheit. **Gehört zu PRUEFER, nicht zu mir** (`tools/` ist seins).
2. **Ein Testdatum für E-106 beschaffen** (L-15.9): eine Nachricht mit einem
   Bild, dessen Datei größer ist als die HTML-Angabe. Ohne sie bleibt jeder
   Nachweis an dieser Ecke bei Gregor.
3. **Die sieben LF-Weiterleitungen messen**, bevor eine Nummer vergeben wird.
4. **E-102 bleibt eine Lücke** — wer die nächste Nummer zieht, nimmt **E-110**.

---

## Nachtrag, 18.09.2026 — **E-110** angelegt (L-15.12)

Gregor hat den Befund an **1.0.72** gemeldet, mit drei Bildschirmfotos:
*„beim weiterleiten und antworten werden nicht alle bilder so übernommen.
sollte doch schon gefixt sein?"*

### Erst gesucht, dann angelegt

Pflichtlauf vor dem neuen Eintrag ([bestand-vor-neuer-suche.md](../Arbeitsweise/bestand-vor-neuer-suche.md)):

| Suche | Ergebnis |
|---|---|
| `befund-suchen.pl PgEmbeddedImage.cpp` | **1 Treffer: E-2** — gelesen, handelt von HTML-Umlauten (*„Beleg; Ursache in Z-2"*), **nicht derselbe Fall** |
| `befund-suchen.pl fetch_url_schmookie` | kein Treffer |
| `befund-suchen.pl GetPartAsFile` | kein Treffer |
| Volltext *„grauer Kasten"* über alle 155 MDs | **Treffer in `CHANGELOG.md` 7.2.0.57/7.2.0.58** — gelesen, und sie sind der **Schlüssel**, nicht der Doppelgänger |

**Was der Bestand beisteuert, und es ist mehr als ein Ausschluss.**
`CHANGELOG.md`, Abschnitt 7.2.0.58, sagt bereits:

> *„Den grauen Kasten selbst gibt es ohnehin: **Paige zeichnet ihn für jedes
> Bild, das es nicht geladen hat** — auf Gregors Bildern stehen welche in
> **echten** Bildmaßen."*

Ein grauer Kasten **in richtiger Größe** heißt danach: die Maßangabe war
bekannt, **die Bilddatei kam nicht.** Das ist die Deutung des Symptoms aus dem
eigenen Bestand — sie steht seit dem 14.09.2026 da. **Abzugrenzen ist der
andere graue Kasten aus 7.2.0.57**: der entstand aus der 200×90-Vorgabe für
Bilder **ohne** bekanntes Maß und ist in 7.2.0.58 ersatzlos zurückgenommen.
Ohne diese Unterscheidung liest sich E-110 wie ein Rückfall in 7.2.0.57.

### Was in den Eintrag kam

| | |
|---|---|
| **Belegt** | Lesefenster vollständig, Verfassenfenster teilweise grau; Fassung `7.2.0.72 / 1.0.72+e2f2d07`, Nachricht `Re: FW: Durchbrechen Sie die Eskalations-Spirale` |
| **Ausdrücklich kein Rückschritt** | Die Kästen haben die **richtige Größe**, der Text liegt **nicht** darüber — **E-103 und E-106 arbeiten.** Dieser Satz steht im Eintrag, damit beim nächsten Mal nicht am falschen Ende gesucht wird |
| **Verdacht, als ungemessen gekennzeichnet** | Die Gabelung `PgEmbeddedImage.cpp:362-415`, am Quelltext nachgeschlagen und Zeile für Zeile bestätigt: MIME-Speicher (`GetPartAsFile`, `:382`) → `if (!(*filePath))` (`:387`) → Netzabruf nur bei `bAllowThreadedFetch` (`:389`, `:401`), sonst `fRet = true` mit QUALCOMMs Kommentar (`:407-414`). Dazu `eCallback`: `false` bei `EMBED_PREPARE_IMAGE` (`:268`), `true` bei `EMBED_LOAD_IMAGE` (`:280`) |
| **Eine zweite Gabelung, selbst gefunden** | Der MIME-Speicher-Weg hängt an `pSB->pMessage` (`:376-377`), gesetzt in `PgMsgView.cpp:181-182`. Bei einer **Antwort** entsteht das zitierte HTML neu über `QuoteText`, die `cid:`-Verweise zeigen aber auf den MIME-Speicher der **Original**nachricht. **Und die naheliegende Abkürzung ist widerlegt:** `PgStuffBucket::kMessage` deckt laut Kommentar (`PgStuffBucket.h:21`) *„comp, read, preview"* — das Verfassenfenster fällt an der Abfrage in `:362` also **nicht** heraus. Entschieden wird es an `pMessage`, nicht an `kind` |
| **Ursache** | **NICHT gemessen**, so gekennzeichnet. Keine Behebung, keine Handlungsanweisung |
| **Was zu messen ist** | Gregors `eudora.log` — `LogLevel=58527` liegt in 1.0.72 bei, je Bild eine `E-95 Bild`-Zeile mit `attr`, `embed`, `ascent`. Daran ist abzulesen, ob der Abruf ausbleibt oder scheitert |

### Zwei Folgen, die weiterreichen

**1. E-110 ist auf dem Prüfstand nachstellbar — anders als E-106.** Das folgt
unmittelbar aus **L-15.9**: der Prüfstand lädt Bilder (acht `E-95 Bild`-Zeilen
je Messlauf). Gebraucht wird eine Nachricht mit einem `cid:`-Bild **und** einem
Netzbild; geöffnet, beantwortet, und die `E-95 Bild`-Zeilen beider Fenster
verglichen. **Damit ist der erste der von Gregor verlangten Regressionstests
baubar** (*„für all diese szenarien brauchen wir regression tests!"*).

**2. `BEFUNDE.md` unter E-109 um zwei Punkte ergänzt** — und damit eingelöst,
was dieser Bericht weiter oben zusagt:

- **(8)** die Schranke, die die Unwahrheit erzwingt (L-15.5). Der Bericht hatte
  behauptet, sie stehe *„jetzt als achter Punkt unter E-109"*; **das stimmte
  beim Schreiben noch nicht.** Ein Bericht, der eine Eintragung meldet, die
  nicht existiert, ist genau die Sorte Behauptung, die dieser Durchgang
  abstellt — deshalb steht es hier und nicht nur dort.
- **(9)** die Regressionstests, mit dem Stand aus L-15.9: für E-110 und die
  Bildszenarien baubar, für **E-106** fehlt weiterhin genau ein Testdatum.

### Eingetragen in

`BEFUNDE.md` (E-110 neu, E-109 ergänzt), `WEITERMACHEN.md` (**15 offen / 15
gelistet**, über `offene-befunde.pl -schreiben`), `CHANGELOG.md` (*Noch offen*),
`README.md` (*Wo die Grenzen liegen*). **CR = 0 in allen vier**, nach jedem
Schreibzugriff einzeln gemessen; E-110 und E-109 tragen je **4 Pipes**, die
Tabellenstruktur ist unversehrt.

**E-102 bleibt die einzige Lücke der Kennungsreihe** — E-100, E-101, E-103 …
E-110 stehen lückenlos. Die nächste freie Nummer ist **E-111**.

### Nachtrag zum Nachtrag: die Protokollmessung zu E-110 (L-15.13)

Gregor hatte den Schalter schon gesetzt. **Selbst nachgemessen** an
`C:\Users\Gregor\Eudora72-1.0.72-release\Mailverzeichnis\eudora.log`
(150.580 Byte, 18.09.2026 08:20) — jeden gemeldeten Wert nachgezählt, statt ihn
zu übernehmen ([mannschaft-fuehren.md](../Arbeitsweise/mannschaft-fuehren.md)):

| Wert | gemeldet | nachgezählt |
|---|---|---|
| `E-95 Bild` | 128 | **128** |
| `E-106 groesser als angegeben` | 32 | **32** |
| `E-103 Nachtrag` / `E-103 Neuzeichnen` | 11 / 11 | **11 / 11** |
| letzte Zeile / `Exception.log` | `Logging shutdown` / keine | **bestätigt** |
| `src=` exakt 32 Zeichen | alle | **alle 128** |
| `PGHTMIMP.CPP:2255` kürzt mit `%.32s` | ja | **ja — und zusätzlich `:2250` mit `for (i = 0; i < 32 …)`. Zweimal gekürzt** |

**Und ein Ausreißer, der die Deutung schärft.** Gemeldet war *„`attr` und
`embed` sind **gleich**"*, belegt an einer Beispielzeile. Nachgezählt über alle
128: **76 gleich, 52 ungleich** — und die 52 tragen durchweg **`embed=0x0`**
bei bekannter Breite:

```
attr=56x0  embed=0x0   20 ×        attr=79x0  embed=0x0    3 ×
attr=110x0 embed=0x0   10 ×        attr=183x0 embed=0x0    3 ×
attr=30x0  embed=0x0    9 ×        attr=194x0 embed=0x0    1 ×
attr=150x0 embed=0x0    5 ×        attr=120x0 embed=0x0    1 ×
```

**`embed=0x0` heißt: für dieses Bild liegt kein Embed vor** — und die Höhe ist
bei allen 52 zugleich 0, die Maße stammen also aus dem HTML-Attribut, nicht aus
einer geladenen Datei. **Damit steht der Satz „der Platz stimmt, die Bildpunkte
fehlen" auf 52 gezählten Zeilen statt auf einer Beispielzeile**, und E-110
liegt nachweislich **hinter** dem Layout. Das ist derselbe Satz wie gemeldet —
aber jetzt mit einer Zahl, die man nachprüfen kann
([ausreisser-ist-der-befund.md](../Arbeitsweise/ausreisser-ist-der-befund.md)).

**Die falsche Spur ist mit eingetragen**, ausdrücklich als solche: alle 128
`src=` sind 32 Zeichen lang, was zwingend nach einem abgeschnittenen URL-Feld
aussieht — es ist die Spurmarke selbst, und sie kürzt an **zwei** Stellen.

**Der offene Punkt daraus:** die Spurmarke taugt für E-110 nicht. Sie zeigt
nicht, **welches** Bild grau bleibt (32 Zeichen reichen bei diesen Adressen
nicht bis zum Dateinamen), und **beide** ausgegebenen Werte sind Maße
(`source_width/height` gegen `mess_ptr->width/height`, `PGHTMIMP.CPP:2258-2259`)
— keiner sagt, ob **Bilddaten** dahinterliegen. Gebraucht wird `image_data`
neben dem Maß, in **derselben** Zeile
([zwei-werte-in-eine-ausgabe.md](../Arbeitsweise/zwei-werte-in-eine-ausgabe.md)).

**Die Ursache bleibt offen.** Gregor: *„aber erstmal das andere zu ende führen,
sonst kommst du durcheinander."* Kein Quelltext angefasst, keine Behebung.
