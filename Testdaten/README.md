# Testdaten

> **Diese Dateien haengen an keiner Programmfassung.** Sie sind Probenachrichten
> und Aufrufstapel; was sie ausloesen, haengt am Absender, nicht an Eudora.
> Zuletzt benutzt wurden sie mit **Paket 1.0.72**. Die Messfassung **1.0.73 /
> Quellstand 7.2.0.73** gibt zu denselben Dateien zusaetzlich `daten=` aus und
> macht damit **E-110** messbar — siehe `CHANGELOG.md`, Abschnitt 7.2.0.73.
> **Die Fassungsangaben in der Tabelle unten nennen, worin ein Befund behoben
> ist, nicht den heutigen Stand** (LEKTOR, L-15.15).

Probenachrichten und Aufrufstapel, mit denen sich die Befunde **E-97**,
**E-101**, **E-103**, **E-104**, **E-106** und **E-108** nachstellen lassen.

Sie liegen hier, weil es sie sonst nirgends mehr gibt. Bis zum 18.09.2026 lag
dieses Material ausschliesslich unter `C:\Temp` und in Gregors Testverzeichnissen
`C:\Users\Gregor\Eudora72-1.0.65-release` bis `-1.0.71-release`. Mit dem
Aufraeumen dieser Verzeichnisse waere jeder dieser Fehler unreproduzierbar
geworden — **jeder einzelne Nachweis an dieser Ecke ist von Gregors Rechner
gekommen, keiner vom Pruefstand.** Der Grund dafuer ist nicht, dass der
Pruefstand keine Bilder laedt — **er laedt sie.** Ihm fehlte genau das, was
jetzt hier liegt: eine Nachricht mit einem Bild, das *groesser* ist als
angegeben (LEKTOR, **L-15.9**, 18.09.2026).

---

## 1. Die Dateien

| Datei | Befund | Was daran den Fehler ausloest | Wie man damit prueft | Was beim Bearbeiten **nicht** angefasst werden darf |
|---|---|---|---|---|
| `e103-bild-ohne-groessenangabe.eml` | **E-103** (behoben in 7.2.0.67), **E-101** | Das erste der fuenf Bilder traegt **weder `width` noch `height`**. Paige misst Bilder nie selbst nach, es liest die Groesse ausschliesslich aus den Attributen (`PGHTMIMP.CPP:2019-2022`) und reserviert dann eine Textzeile von 13 Punkten fuer ein Bild, das 60 Punkte hoch ist. Die anderen vier tragen ihre Masse (80x80, 98x35, 117x35, 80x24) und sind unauffaellig. | Nachricht oeffnen, Protokoll lesen. Ohne die Behebung steht dort `attr=0x0 embed=0x0 ascent=13`, mit ihr `ascent=48` (`E103_MINDESTHOEHE`). Beide Werte sind in **E-103** am laufenden Programm gemessen. | Die `<img>`-Tags: das erste **ohne** Groessenangabe, die vier anderen **mit** genau diesen Werten. Die Reihenfolge. Der `<x-html>`-Marker als **erste Rumpfzeile** und sein Gegenstueck am Ende. |
| `e106-bild-groesser-als-angegeben.eml` | **E-106** (behoben in 7.2.0.68, von Gregor an 1.0.69 bestaetigt), **E-94**, **E-101** | Das Logo traegt **beide** Angaben, `width="200" height="52"`, und die Datei dahinter ist groesser — Absender legen Bilder in doppelter Aufloesung ab und geben im HTML die halbe Groesse an. Paige skaliert nicht, es zeichnet die Datei in Originalgroesse in eine Zeile, die nach der Angabe bemessen ist. Der Nachtrag in `PgLoadUrlImage` lief bis 7.2.0.68 nur `if (embed->height == 0 \|\| embed->width == 0)` und sah ein Bild mit **beiden** Angaben deshalb nie an. Dazu: der **Betreff ist mitten im Wort gefaltet** und die Fortsetzungszeile beginnt mit einem Hochbyte (E-94). | Nachricht oeffnen. Die Spurmarke lautet `E-106 groesser als angegeben: attr=200x52 quelle=<echte Masse> …`. Gregors Protokoll zu 1.0.67 zeigte fuer dieses Logo `attr=200x52 embed=200x52 ascent=52` **und danach keine einzige Zeile mehr** — genau daran wurde der Befund entschieden. Die echten Masse der Datei sind hier **nicht nachgemessen**; aus dieser Sitzung wurde nichts aus dem Netz geladen. | **Alle 13 `width`/`height`-Angaben und alle Bildadressen bis auf das Zaehlpixel** — an der echten Dateigroesse hinter der Adresse haengt der ganze Fall. Die Faltstelle im `Subject`. Der `<x-html>`-Marker. |
| `e108-absturz-und-versteckter-vorschautext.eml` | **E-108** (behoben in 7.2.0.72, von Gregor bestaetigt), **versteckter Vorschautext** (noch ohne Befundnummer), **nackte LF** (noch ohne Befundnummer), **E-101** | Drei Sachen in einer Datei. (1) **Absturz:** zwei Bilder mit `width="135" height="40"`, deren Dateien `_3x` sind, also 405x120 — genau die Stelle, an der in allen drei Absturzprotokollen Schluss war (`attr=135x40 quelle=405x120 pos=765`). (2) **Versteckter Vorschautext:** ein `<div class="preheaderMod" style="display:none;">` mit einem zweiten `display:none`-Block darin, der **96 mal `?&nbsp;`** enthaelt. Eudora wertet kein CSS aus und zeigt beides an — beim Anwender erscheint eine Reihe `? ? ? ?`. (3) **Nackte LF:** der Kopf hat 283 CRLF, der **Rumpf 353 nackte LF** — die Nachricht kommt aus einer Samsung-Android-Mailanwendung (`boundary="--_com.samsung.android.email_…"`). | Auf die geoeffnete Nachricht **antworten**. Bis 7.2.0.71 stuerzte Eudora dabei ab (`EXCEPTION_ACCESS_VIOLATION in Paige32.dll at UnuseMemory()`); ab 7.2.0.72 laeuft der Block ueber `pos=765` hinaus und das Protokoll endet mit `Logging shutdown`, ohne `Exception.log`. Fuer den Vorschautext genuegt das Oeffnen: die `? ? ? ?`-Reihe steht oben im Fenster. | **Die Zeilenenden, Byte fuer Byte** — 283 CRLF und 353 nackte LF. Die vier `display:none`-Vorkommen und die 96 `?&nbsp;` darin, in Auszeichnung wie in Zeichen. Alle neun `width`/`height`-Angaben, besonders die beiden `135x40`, und die Adressen der `_3x.png`-Dateien. |
| `e097-aufrufstapel-ohne-symbole.txt` | **E-97** | Aufrufstapel des Absturzes im *Speichern unter*-Dialog, aufgenommen ohne Symboldatei: Rahmen 0 ist nur `Eudora.exe ?`. | Vergleichsstueck: so sieht ein Stapel aus, wenn die `.pdb` nicht danebenliegt — der Befund ist dann **nicht** ablesbar. | Nichts Persoenliches enthalten, unveraendert uebernommen. |
| `e097-aufrufstapel-mit-symbolen.txt` | **E-97** | Derselbe Absturz mit Symboldatei. Rahmen 0 nennt die Stelle: `CSaveAsDialog::OnTypeChange + 45  SaveAsDialog.cpp:425`. | Vorlage dafuer, wie ein brauchbarer Stapel aussehen muss. Der Unterschied zur Datei darueber ist der Grund, warum die `.pdb` ins Paket gehoert. | Nichts Persoenliches enthalten, unveraendert uebernommen. |

### Was diese Dateien **nicht** leisten

* **`e103-bild-ohne-groessenangabe.eml` laedt seine Bilder nicht.** Der Name des
  absendenden Diensts stand auch in den Bildadressen, und bei dieser Nachricht
  musste der gesamte Sachinhalt weg, nicht nur die Anschriften (siehe
  Abschnitt 3). Die Adressen zeigen jetzt auf `bilder.anbieter.invalid`.
  Das ist **kein Verlust fuer den
  Testfall**: E-103 entsteht beim **Import**, nicht beim Laden — die Spurmarke
  `attr=0x0 embed=0x0 ascent=13` ist genau der Zustand, den der Befund als
  Gegenprobe ausdruecklich mit `https://kein-rechner.invalid/logo.png`
  hergestellt hat.
* **Fuer E-101 und E-104 sind das Ausgangsstuecke, keine fertigen Faelle.** Beide
  Befunde entstehen beim **Speichern** einer Nachricht (`File → Save As`), nicht
  beim Empfangen. Die drei `.eml` bringen mit, was der Speicherweg braucht: den
  `<x-html>`-Marker als erste Rumpfzeile samt Gegenstueck, Hochbytes im Rumpf
  (Zeichensatzerkennung) und einen Kopf mit gefalteten Zeilen (E-104). Die
  fehlerhafte Ausgabe entsteht erst durch das Speichern.
* **Kein Ersatz fuer Gregors Lauf — aber der fehlende Baustein.** Der Pruefstand
  **laedt Bilder**; was ihm fehlte, war ein Bild, das *groesser* ist als
  angegeben, und genau daran haengt der verdaechtige Code: bei Gregors Lauf
  greift der E-106-Block **32-mal**, im Pruefstand **null-mal**. Diese Dateien
  machen den Fall zunaechst **wiederholbar**; sie **automatisch messbar** zu
  machen ist der naechste Schritt und steht als offener Punkt bei **E-109**.

  > **Berichtigt am 18.09.2026 (LEKTOR, L-15.9).** Hier stand bis dahin *„Der
  > Pruefstand laedt keine Bilder; die Bloecke zu E-106 und E-108 laufen dort gar
  > nicht erst an."* Der zweite Halbsatz stimmt, der erste nicht — und der erste
  > war die Begruendung. Dieselbe Aussage stand als **erster Punkt der
  > Nacharbeit**: wer ihr gefolgt waere, haette eine Bildladefunktion gebaut und
  > den Fehler trotzdem nicht gefunden.

---

## 2. Wie man eine Datei in Eudora hineinbekommt

Eudora liest keine `.eml`. Die Nachrichten muessen in eine Mailbox-Datei, und
zwar mit Eudoras eigener Trennzeile davor — genau so lagen sie urspruenglich in
`INBOX.mbx`:

    From ???@??? Tue Sep 15 09:31:15 2026<CR><LF>

Zusammenbauen **nur byte-erhaltend**, also mit Perl im `:raw`-Modus:

```bash
perl -0777 -e 'open(O,">:raw",$ARGV[0]) or die; shift;
  for my $f (@ARGV){ open(I,"<:raw",$f) or die "$f: $!"; local $/; my $d=<I>; close I;
    print O "From ???\@??? ", scalar(gmtime(0)), "\r\n", $d;
    print O "\r\n" unless $d =~ /\r\n\z/; }' Probe.mbx Testdaten/e1*.eml
```

Gemessen an den drei `.eml` dieses Verzeichnisses: `Probe.mbx` = 167.399 Byte,
**2315 CRLF, 353 nackte LF**, drei Trennzeilen — die Summe der Einzeldateien
plus drei Trennzeilen, die nackten LF unversehrt. Die entstandene `Probe.mbx`
kommt neben die anderen `.mbx` ins Mailverzeichnis; Eudora legt beim naechsten
Start die zugehoerige `.toc` an.

**Was hier nicht gemessen ist:** ob Eudora die so gebaute Mailbox anzeigt. Das
haengt an einem laufenden Programm, und aus dieser Sitzung wurde nichts mit
Oberflaeche gestartet.

---

## 3. Herkunft und Anonymisierung

Alle fuenf Dateien stammen aus **echten Nachrichten in Gregors Postfach** bzw.
aus Abstuerzen auf seinem Rechner, aufgenommen zwischen dem 14. und 17.09.2026.
Ein echter Fall ist einem konstruierten ueberlegen: er hat den Pruefweg
bewiesenermassen ueberlebt (`Arbeitsweise/testdaten-muessen-durchkommen.md`).

**Sie sind anonymisiert.** Entfernt wurden, aus Kopfzeilen wie aus dem Rumpf:

| Was | Wodurch ersetzt |
|---|---|
| jede E-Mail-Adresse | `absender@beispiel.invalid`, `empfaenger@beispiel.invalid`, `noreply@…invalid` — `.invalid` ist nach RFC 2606 garantiert nicht aufloesbar |
| Personennamen, auch in Anzeigenamen und Impressen | `Absender Beispiel`, `Max Mustermann` |
| Postanschriften | `Musterweg 1, 12345 Musterstadt` |
| IP-Adressen, auch die des Anschlusses | `192.0.2.x` / `203.0.113.x` (RFC 5737, Dokumentationsbereiche) |
| Wirtsnamen der Postfachanbieter | `…absenderdienst.invalid`, `…empfaengerdienst.invalid` |
| `Message-ID`, `References`, `In-Reply-To`, Zustellkennungen | `nachricht-00N@beispiel.invalid`, `XXXXXX-…` |
| Verfolgungskennungen in Adressen (Kontonummer, Sende- und Vorgangskennung, Artikel- und Bildnummer) | Platzhalter aus einer einzigen Ziffer; `bu=10000000000` |
| Zaehlpixel mit Empfaengertoken | `https://zaehlpixel.beispiel.invalid/open.png` |
| DKIM-Signaturen, `X-Provags-ID`, `UI-Out/InboundReport` | Fuellzeichen `X` **gleicher Laenge** — die Faltung der Kopfzeilen bleibt damit unveraendert |
| Anzeigentitel, Angebotsgegenstand, Nutzungszahlen | neutraler Text |
| bei `e103-…`: **der gesamte Sachinhalt** — absendender Dienst, Zweck der Nachricht, Code, alle Verweisziele und Bildadressen | `Anbieter`, `Bestaetigungscode`, `000000`, `…anbieter.invalid`. Die HTML-Struktur bleibt dabei unveraendert; an ihr haengt der Testfall |

**Erhalten geblieben sind die Bildadressen** der drei Absender, soweit sie
oeffentliche, fuer jeden Empfaenger gleiche Dateien benennen (`static.…`,
`…ebaystatic.com`, `p.ebaystatic.com`). Das ist kein Versehen: an den
**tatsaechlichen Massen der Bilddateien** haengen E-103 und E-106. Eine
ausgetauschte Adresse ist eine ausgetauschte Bildgroesse, und damit kein
Testfall mehr. Die Ausnahme ist `e103-…`, siehe oben.

### Bearbeitet wurde ausschliesslich mit Perl im `:raw`-Modus

Kein Edit-Werkzeug, kein `sed` ohne `-b`, keine PowerShell-Textverarbeitung.
Das Edit-Werkzeug hat in diesem Projekt schon eine Quelldatei zerstoert — alle
CR entfernt und Latin-1 nach UTF-8 umkodiert
(`Arbeitsweise/quelldateien-nur-byte-erhaltend-aendern.md`).

Gemessen vor und nach der Anonymisierung, je Datei:

| Datei | CRLF | nackte LF | Bytes ≥ 0x80 | Bildmasse | `display:none` |
|---|---|---|---|---|---|
| `e103-bild-ohne-groessenangabe.eml` | 297 → **297** | 0 → **0** | 7 → **7** | `-x- 80x80 98x35 117x35 80x24` unveraendert | 0 → 0 |
| `e106-bild-groesser-als-angegeben.eml` | 1732 → **1732** | 0 → **0** | 23 → **23** | alle 13 Angaben unveraendert | 1 → 1 |
| `e108-absturz-und-versteckter-vorschautext.eml` | 283 → **283** | 353 → **353** | 7 → **7** | alle 9 Angaben unveraendert | 4 → 4, `?&nbsp;` 96 → 96 |

Die beiden `.txt` wurden unveraendert uebernommen; sie enthielten nie
personenbezogene Daten (Pruefung auf Namen, Adressen und Pfade: null Treffer).

---

## 4. Die Schranke

    perl tools/pruefe-testdaten-anonym.pl            # prueft dieses Verzeichnis
    perl tools/pruefe-testdaten-anonym.pl --tests    # Selbsttest, 19 Faelle

Sie weist ab, sobald hier eine E-Mail-Adresse steht, die nicht auf `.invalid`
endet, oder eines von 17 Ausschlussmustern vorkommt (Namen, Rufnummern,
Anschriften, IP-Adressen ausserhalb RFC 5737, Vorgangs- und Kundennummern).
Sie nennt ihren **Pruefumfang** und meldet bei **0 geprueften Dateien ROT**,
nicht gruen — ein Freispruch ueber die leere Menge ist in diesem Projekt schon
zweimal vorgekommen (**E-109**).

**Was sie nicht kann:** entscheiden, ob ein Text sinngemaess auf eine Person
zurueckfuehrt. Wer hier eine Datei ergaenzt, muss sie zusaetzlich selbst lesen.

---

## 5. Zeilenenden

`.gitattributes` fuehrt `Testdaten/**` als `-text`. git fasst die Zeilenenden
damit weder beim Einchecken noch beim Auschecken an. Das ist hier **kein
Schoenheitsfehler, sondern Bedingung**:
`e108-absturz-und-versteckter-vorschautext.eml` traegt im Rumpf 353 nackte LF,
und eine Datei, die git normalisiert, ist als Testfall zerstoert.

Nachpruefen:

    git check-attr text eol -- Testdaten/e108-absturz-und-versteckter-vorschautext.eml
    # erwartet: text: unset

Nach **jedem** Schreibzugriff auf eine Datei hier messen:

```bash
perl -0777 -ne '$c=()=/\r\n/g;$l=()=/\n/g;printf "CRLF %d nur-LF %d Byte %d\n",$c,$l-$c,length' <datei>
```
