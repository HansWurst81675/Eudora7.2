---
name: text-nicht-durch-schichten-schicken
description: Ersetzungstext mit Backslashes oder Anfuehrungszeichen nie inline durch Bash/PowerShell nach Perl reichen; in eine Datei schreiben und ueber Zeilenanker einsetzen
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T08:29:52.661Z
---

**Gregor am 06.09.2026:** *„das hatten wir schon mit bash und PS. warum lernst du
nicht daraus? warum passiert dir das immer wieder?"*

Er hat recht: es ist an einem Tag dreimal passiert.

## Was passiert

Ein Ersetzungstext, der Backslashes oder Anfuehrungszeichen enthaelt, geht durch
mehrere Schichten — die Werkzeugschale, dann Bash, dann Perl, dann der
Regexausdruck. Jede Schicht frisst eine Ebene. Was am Ende ankommt, ist nicht,
was ich geschrieben habe. Auch ein `<<'ENDE'`-Hier-Dokument schuetzt nicht
zuverlaessig.

**Die drei Faelle vom 06.09.2026:**

| Geschrieben | Angekommen | Folge |
|---|---|---|
| `-notmatch '\OT501'` | `'\OT501'` | ungueltiger Regex, `bauen.ps1` brach mitten in der Bilanz ab |
| `'\(Bin\|Lib)\'` | `'\(Bin\|Lib)\'` | dieselbe Stelle, zweiter Anlauf |
| `s{[/\]\.git\z}{}` | `s{[/\]\.git\z}{}` | „Unmatched [ in regex", `lehren-spiegeln.pl` liess sich nicht mehr uebersetzen |

Frueher schon: ein `\Q` im **Ersetzungsteil** eines `s///` startete quotemeta
und frass das `Q` von `QCUtils` — die `.vcxproj` war danach kaputt.

## Die Regel

**Ersetzungstext niemals inline durch die Befehlszeile reichen.** Stattdessen:

1. Text in eine Datei schreiben (Hier-Dokument ist dafuer in Ordnung, weil der
   Text dort nur *gespeichert* und nicht *interpretiert* wird).
2. Die Datei mit Perl im `:raw`-Modus einlesen.
3. Ueber **Zeilenanker** einsetzen (`grep` auf ein Muster, dann `splice`), nicht
   ueber eine Ersetzung mit Sonderzeichen.

Oder gleich `tools/ersetze-bereich.pl` benutzen — dafuer ist es da.

**Wenn ein Sonderzeichen unvermeidbar ist:** `chr(92)` fuer den Backslash,
`chr(34)` fuer das Anfuehrungszeichen, `chr(39)` fuer den Apostroph. Nie das
Zeichen selbst.

## Die Probe, die es sofort auffliegen lassen wuerde

Nach jedem Einsetzen in eine ausfuehrbare Datei:

    perl -c DATEI                                    # Perl
    powershell -Command "[ScriptBlock]::Create((Get-Content -Raw 'DATEI'))"   # PowerShell

Das kostet zwei Sekunden. Am 06.09.2026 haette es alle drei Faelle vor dem
naechsten Lauf gefangen — im dritten Fall habe ich es getan und den Fehler
sofort gesehen, in den ersten beiden nicht.

## Warum es sich wiederholt hat

Nicht aus Unkenntnis. Inline ist **einen Handgriff kuerzer**, und in dem Moment
sieht der Text im eigenen Kopf richtig aus. Der Fehler wird erst sichtbar, wenn
das Werkzeug laeuft — oft erst Minuten spaeter, bei Gregor.

---

## Vierter Fall, 07.09.2026 — einen Tag nach dieser Lehre

`tools/doku-pruefen.pl` lag **im Repo** mit einem echten **Backspace-Byte
(0x08)** an der Stelle, an der `\b` stehen sollte; aus `\.\*\*` war `.**`
geworden. Die Schranke waere beim naechsten Lauf abgestuerzt — und es ist die
Schranke, die Gregors wichtigste Beschwerde abfangen soll.

Die Probe aus dieser Lehre, `perl -c DATEI`, war nach dem Schreiben **nicht**
gelaufen. Sie haette zwei Sekunden gekostet. Aufgefallen ist es nur, weil ich
die Datei danach zufaellig noch einmal geoeffnet habe.

**Zweiter Befund derselben Stunde:** ein Zeilenanker mit `.` traf nicht, weil
das Gedankenstrich-Zeichen in UTF-8 **drei Byte** ist. Ein Anker wird also auf
reinen ASCII-Text gesetzt (`grep` auf ein Wort, nicht auf ein Satzzeichen),
oder das Muster wird byteweise geschrieben.

**Der Ablauf ist damit nicht verhandelbar:** Text in eine Datei — einsetzen
ueber einen ASCII-Zeilenanker — `perl -c` bzw. `[ScriptBlock]::Create` — erst
dann `git add`. Wer den letzten Schritt weglaesst, hat die Lehre nicht
angewendet, sondern nur gelesen ([[lehren-anwenden-nicht-nur-schreiben]]).

---

## Fuenfter und sechster Fall, 07.09.2026 — der Anker, den es nicht gibt

Zwei Schaeden an einem Nachmittag, beide durch einen **falschen oder fehlenden
Anker** im Ersetzungswerkzeug:

| Datei | was passierte | wie es auffiel |
|---|---|---|
| `tools/doku-pruefen.pl` | `Zeilen 136..494 (359) -> 10 Zeilen (ersetzen)`, dazu die eigene Meldung `nicht gefunden von=136 bis=-1` — **359 Zeilen weg** | `perl -c`: *Global symbol „$behauptung" requires explicit package name* (Exit 255). Zuruecksetzen mit `git checkout --`, danach 467 Zeilen wie in HEAD |
| `Eudora71/Eudora/PersonalityView.cpp` | Splice in eine Funktion hinein: verwaiste `}`, Rumpf doppelt | Klammerzaehlung nach dem Einsetzen; zuruecksetzen und die **ganze Funktion** in einem Stueck ersetzen (`920..978 -> 114 Zeilen`, `129 auf, 129 zu, ausgeglichen`) |

Ein drittes Mal im gleichen Zeitraum hat es **richtig** gemeldet — die Ausgabe
war schlicht `Anker fehlt`, und nichts wurde angefasst. Der Unterschied lag
nicht am Text, sondern daran, dass das Werkzeug im Schadensfall **weitergerechnet
hat**: Ende nicht gefunden → `bis=-1` → `splice` von 136 bis zum Ende.

Und viertens, kleiner, aber gleicher Ursprung: eine Gegenprobe sollte
`[Mappings]` aus einer Testdatei entfernen und traf den **Kommentarkopf** mit,
in dem das Wort ebenfalls vorkommt — von 193 Zeilen blieben 3 uebrig. Nicht die
Schranke war falsch, sondern die Verankerung (`^\[Mappings\]` statt
`[Mappings]`).

**Zusaetzlich zum Ablauf oben gilt damit:**

- **Ein Werkzeug, das seinen Anker nicht findet, bricht ab.** Rueckgabe ungleich
  0, kein Schreibzugriff, keine Ersatzrechnung. `bis=-1`, `bis=$#zeilen`,
  „dann nehme ich das Dateiende" sind kein Rueckfall, sondern der Schaden. Wenn
  eine Meldung wie `nicht gefunden` **und** eine Ersetzungsbilanz in derselben
  Ausgabe stehen, ist das Werkzeug kaputt, nicht der Aufruf.
- **Mehrzeilige Anker taugen nicht.** `'void Foo()' .. '  ASSERT(0);\n }\n}'`
  hat nicht getroffen — Einrueckung, Leerzeilen und Zeilenenden sind nicht
  vorhersagbar. Anker sind **eine** Zeile, ASCII, eindeutig; `grep -c` auf das
  Muster muss **1** liefern, bevor ersetzt wird.
- **Anker am Zeilenanfang festmachen** (`^`), sonst trifft das Muster auch den
  Kommentar, der es beschreibt.
- **Nach jedem Einsetzen die Struktur messen, nicht nur die Syntax:**
  Zeilenzahl gegen HEAD (`git show HEAD:DATEI | wc -l`) und bei C++ die
  Klammerbilanz. `perl -c` faengt den ersten Fall, eine ausgeglichene
  Klammerzaehlung den zweiten — **beide** haben hier gegriffen, aber erst
  hinterher.
- **Eine Funktion wird als Ganzes ersetzt**, nicht in mehreren Splices. Zwei
  Splices in dieselbe Funktion haben hier den doppelten Rumpf erzeugt.
