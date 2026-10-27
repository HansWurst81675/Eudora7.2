---
name: text-nicht-durch-schichten-schicken
description: Ersetzungstext mit Backslashes oder Anfuehrungszeichen nie inline durch Bash/PowerShell nach Perl reichen; in eine Datei schreiben und ueber Zeilenanker einsetzen
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-10-14T06:48:34.529Z
---

Schranke: tools/pruefe-rueckstrich.pl (pre-commit 14d seit 14.10.2026 — weist einen Windows-Pfad ohne Rückstrich im Zuwachs einer .md ab) und tools/ersetze-bereich.pl (für jeden Ersetzungstext — nimmt den neuen Block ausschließlich aus einer Datei, nie von der Kommandozeile)

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

---

## Siebter bis neunter Fall, 08.09.2026 — drei an einem Vormittag

| Zeit | Was ich geschrieben habe | Was passiert ist |
|---|---|---|
| 07:34 | `cat > datei <<EOF` **ohne Apostrophe**, weil ich `$SHA` einsetzen wollte | Bash hat den ganzen Text **ausgeführt**: 90 Zeilen `command not found` aus den Backticks des Abschnitts, dazu `Eudora71/Eudora/doc.cpp: line 19: syntax error near unexpected token 'CDoc,'` — die Schale hat versucht, eine Quelldatei als Skript zu lesen. Der halbe CHANGELOG-Abschnitt kam leer heraus |
| 07:18 | `\x{2014}` in einem Perl-Einzeiler, der `ZIEL.md` als Rohdatei schreibt | *„Wide character in print"* — und danach war **die ganze Datei** doppelt kodiert: `ZIEL.md` an **168 Stellen**, vorher 0. `tools/pruefe-bytes.pl` hat den Commit abgebrochen (`LF=211 → 234`, `hoch=390 → 848`); zurücksetzen und alle vier Änderungen wiederholen |
| 07:38 | `\Q$rumpf\E` als **Suchtext** in einer Ersetzung | Perl hat die Variable eingesetzt statt den gemeinten Text; die Ersetzung kam nicht durch, ohne Fehlermeldung |

**Was daraus folgt — zusätzlich zum Ablauf oben:**

- **Ein Hier-Dokument ist immer `<<'MARKE'`, ausnahmslos.** Ohne Apostrophe
  interpretiert die Schale `$`, `` ` `` und `\` im Text. Backticks in einem
  Dokumentationsabschnitt sind der Normalfall, nicht die Ausnahme — in Markdown
  steht in jeder zweiten Zeile einer.
- **Ein Wert, der in den Text soll, kommt über einen Platzhalter hinein**, nicht
  über die Schale: `@@SHA@@` in den Text schreiben und danach mit Perl auf
  Rohbytes ersetzen. So habe ich es um 07:35 gemacht, und es lief auf Anhieb.
- **Kein `\x{...}` in einem Einzeiler, der eine Rohdatei schreibt.** `\x{}`
  erzeugt einen Perl-Zeichenstring; wird der ohne `:encoding` in eine
  Latin-1-Datei geschrieben, kodiert Perl **den gesamten Puffer** nach UTF-8.
  Sonderzeichen gehören in eine Datei, die byteweise gelesen wird — dann ist
  jedes Byte, das hineingeht, dasselbe, das herauskommt.
- **Nach jedem Schreibzugriff auf eine Repo-Datei `tools/pruefe-bytes.pl`.**
  Hier war es die einzige Instanz, die den Schaden bemerkt hat
  ([[zeilenenden-nach-jedem-schreibzugriff-messen]]).

---

## Zehnter Fall, 13.09.2026 — und warum diese Lehre nicht greift

Ein Zeilenanker für eine Schranke sollte lauten

    '^\s*LONG\s+...'

In der Datei stand danach

    ^s*LONGs+...

— **alle Backslashes weg, die Anführungszeichen dazu.** Vierter Tag in Folge
mit derselben Klasse, zehnter dokumentierter Fall seit dem 06.09.2026. Die
Lehre stand die ganze Zeit da und ist beim Schreiben nicht gelesen worden,
weil nichts sie aufgerufen hat.

**Why — der strukturelle Grund, und er ist der eigentliche Befund:** Als
Schranke steht über dieser Lehre `tools/ersetze-bereich.pl`. Das Werkzeug ist
gut, aber es ist **kein Auslöser, sondern ein Angebot**. Es greift nur, wenn
ich es aufrufe — und der Fehler passiert genau dann, wenn ich es *nicht*
aufrufe, weil inline einen Handgriff kürzer ist. Eine Schranke, die man
benutzen muss, damit sie greift, prüft nicht den Weg, auf dem der Fehler
entsteht ([[messung-muss-den-weg-treffen]]).

Das unterscheidet diese Lehre von den wirksamen: `pruefe-bytes.pl` hängt im
pre-commit und fragt niemanden. Deshalb hat es am 08.09.2026 die
Doppelkodierung gefunden — und am 13.09.2026 wieder, ein Mojibake im
CHANGELOG. Diese Lehre hat nichts Vergleichbares.

**Was den zehnten Fall gefangen hätte:** die Nachmessung aus dieser Lehre
selbst — `grep -c` auf den eingesetzten Anker, Rückgabe muss 1 sein — war
nicht gelaufen. Sie ist der billigste Handgriff, den es gibt, und sie ist
mittlerweile in [[erfolgsmeldung-aus-dem-ergebnis]] als eigene Regel
festgehalten: **nach jedem Schreibzugriff das Ergebnis in der Datei zählen,
nie den Kontrollfluss melden.**

## Berichtigung: die Probe in dieser Lehre war selbst stumm

Oben stand seit dem 06.09.2026 als PowerShell-Probe:

    powershell -Command "[ScriptBlock]::Create((Get-Content -Raw 'DATEI'))"

**Diese Probe taugt nicht.** Am 13.09.2026 nachgemessen an einer Datei mit
fehlender schließender Klammer: `[ScriptBlock]::Create` wirft eine
nicht-terminierende `MethodInvocationException`, `powershell -Command` läuft
weiter und beendet sich mit **Rückgabewert 0**. Eine nachgestellte Meldung
`Syntax ok` erscheint unter der Fehlermeldung — und ein Hook, der daran
hängt, lässt die kaputte Datei durch. Genau das ist am 13.09.2026 passiert.

**Richtig ist:**

```powershell
$t = $null; $e = $null
[void][System.Management.Automation.Language.Parser]::ParseFile($pfad, [ref]$t, [ref]$e)
if ($e -and $e.Count) { Write-Error ("Parserfehler: " + $e[0].Message); exit 1 }
```

`perl -c DATEI` bleibt richtig — dort ist der Rückgabewert tatsächlich
ungleich 0. Der Unterschied zwischen beiden ist nicht offensichtlich; er ist
gemessen worden, nicht vermutet ([[pruefen-statt-vermuten]]). Die ganze
Geschichte steht in [[erfolgsmeldung-aus-dem-ergebnis]].

## Elfter und zwölfter Fall, 12.10.2026: die Werkzeugschale macht aus `\\` ein `\`, auch in einfachen Anführungszeichen

Neu gegenüber den ersten zehn Fällen ist, **wo** der Rückstrich verloren
geht. Das ist jetzt gemessen und nicht mehr vermutet. Probe vom 12.10.2026
im Bash-Werkzeug:

    printf '%s' 'a\\b|c\d' | od -c      ->   a \ b | c \ d

Bash und `printf '%s'` deuten in `'…'` nichts. Trotzdem kommt `\\` als **ein**
Rückstrich an, während ein **einzelner** `\` unverändert bleibt. Die
Halbierung geschieht also **vor** der Schale, beim Übergeben des Befehls.
Was danach folgt (Perl, Regex), halbiert ein zweites Mal.

| Zeit | Absicht | Weg | Ergebnis |
|---|---|---|---|
| 12:11:04 | `C:\Temp\AN5` in `WEITERMACHEN.md` | `perl -0777 -i -pe 's/…C:\\Temp…/…/'` | „kein Treffer" |
| 12:11:29 | dasselbe | `perl -pe 's/…/…/'` | „IMMER NOCH KEIN TREFFER" |
| 12:11:39 | dasselbe | `index()`, Ersatz als Perl-String mit `C:\\Temp\\AN5` | **`C:TempAN5`** im Commit (amend) |
| 12:11:57 | dasselbe | `printf '%s'` mit **einzelnen** `\` in eine Datei, `ankertausch.pl` | richtig; `od -c` zeigt `\` |
| 12:54:33 | `\?\` → `\\?\` (LEKTOR-19) | `printf '%s'` mit `\\?\` in eine Datei | Datei enthält `\?\`, **Änderung ohne Wirkung**, `643ad27` |
| 12:54:33 | Nachprüfung | `grep -c` mit Rückstrichen im Muster | „Trailing backslash", Prüfung ausgefallen |
| 12:55:02 | Nachprüfung | `grep -c -F` mit dem Zieltext | **1**, falsch grün: das Muster war ebenso halbiert |

**Why:** Um 12:11:57 hat `printf '%s'` geholfen, weil dort nur **einzelne**
Rückstriche standen. Daraus habe ich „printf '%s' schützt" gemacht. Um
12:54:33 stand im Text ein **doppelter**, und printf hat ihn nicht
geschützt. Die Datei, die als Zwischenlager „nichts deutet", war schon
falsch, als sie geschrieben wurde. Das Hier-Dokument mit `<<'ENDE'` kommt
durch dieselbe Übergabe. Die Regel oben („in eine Datei schreiben") gilt
also nur, wenn die Datei **nicht über die Befehlszeile** entsteht.

Schlimmer ist die Nachprüfung. Sie stand im selben Befehlstext wie der
Fehler und wurde mit ihm halbiert. Dann sucht sie nach dem kaputten Text,
findet ihn und meldet 1. Das ist [[pruefstand-kann-blind-sein]] innerhalb
eines einzigen Befehls.

**How to apply, zusätzlich zur Regel oben:**

- **Ein Text mit `\\` geht nie über die Befehlszeile**, auch nicht als
  `printf '%s'` oder Hier-Dokument. Er gehört mit dem **Write-Werkzeug** in
  eine Datei. Das Write-Werkzeug geht durch keine Schale. Der CHRONIST-3-Bericht
  selbst ist so entstanden, nachdem sein Hier-Dokument in Bash abgebrochen war.
- **Ist eine Zeile unvermeidbar, dann mit `chr(92)`** aus dieser Lehre. Im
  Befehl steht dann kein einziger Rückstrich, den eine Schicht halbieren
  könnte.
- **Die Nachprüfung zählt Rückstriche, sie sucht nicht nach dem Text**:
  `perl -ne 'print scalar(()=/\x5c/g),"\n" if /Langpfaden/' DATEI`. Der Wert
  muss 3 sein (`\\?\`). Der Rückstrich steht dort als `\x5c` und kann nicht
  halbiert werden. Ein `grep -F` mit dem Zieltext in der Befehlszeile misst
  nur, ob beide Seiten gleich verstümmelt wurden.
- **`od -c` auf die Ersatzdatei, bevor sie eingesetzt wird.** Um 12:11:57
  stand das im Befehl und hat die Richtigkeit gezeigt. Um 12:54:33 fehlte es.

**Folge:** `CHANGELOG.md:97` hatte auch nach `643ad27` noch nur einen
Rückstrich vor dem Fragezeichen. Der LEKTOR-19-Mangel „Langpfad-Präfix" war
also **nicht behoben**, obwohl `Befunde/LEKTOR-19.md` und `LEKTORAT.md`
„alle eingearbeitet" meldeten. **Behoben in `bb01b74`** (LEKTOR-20, L-19.3)
mit dem Edit-Werkzeug; nachgezählt über `\x5c`: zwei Rückstriche, Fragezeichen,
ein Rückstrich (LEKTOR-21 hat diesen Absatz als veraltet gemeldet).

## Dreizehnter bis fünfzehnter Fall, 13.10.2026: die Regeln aus Fall 11 und 12 kein einziges Mal angewendet

Am Abend des 12.10. stand in [[reihenfolge-nach-1083]] als Auftrag für die
nächste Sitzung: *„dabei die Steuerzeichen-Schranke für MD-Dateien bauen
(Rückstrich/Escape heute viermal verloren)"*. Gebaut wurde sie nicht. Am
13.10., während Gregors Testlauf an 1.0.84, kamen drei weitere Fälle in
einer Viertelstunde (Transkript `7cea137a-…jsonl`):

| Zeit (UTC) | Absicht | Weg | Ergebnis |
|---|---|---|---|
| 06:40:02 | C1 im TESTPLAN berichtigen, Pfad `C:\Temp\E94-nachher` | Hier-Dokument nach `testplan-haken.pl`, Pfad in einem Perl-String in doppelten Anführungszeichen | Perl warnt zu `\T` und `\E`; `\T` wird zu `T`, `\E` (Ende einer Groß-/Kleinschreibungs-Umschaltung) verschwindet ganz. Im TESTPLAN steht **`C:Temp94-nachher`** |
| 06:45:44 | E-83-Nachtrag in BEFUNDE mit `C:\Temp\E83-1084` und `spool\lmos.dat` | `printf '%s'` mit `\x5c` statt Rückstrich in eine Datei | `printf '%s'` deutet nichts, also auch kein `\x5c`: **wörtlich `\x5c`** in BEFUNDE.md |
| 06:55:51 | AN-2-Widerlegung mit `C:\Temp\AN2-1084` | `printf '%s'` in eine Datei, danach Pfad-Zähler | Zähler meldet **0**, `od -c` zeigt den Pfad **richtig**: diesmal war die Nachprüfung kaputt, nicht der Text |

**Why:** Fall 11/12 hatte drei Regeln hinterlassen: Text mit Rückstrich nur
mit dem **Write-Werkzeug** in eine Datei, sonst `chr(92)`, und nachzählen
über `\x5c` **im Suchmuster**. Am 13.10. lief jeder der drei Schreibvorgänge
wieder durch Bash. Der zweite Fall zeigt, warum ein Ausweg im Kopf nicht
reicht: `\x5c` ist ein Escape, und `printf '%s'` wurde ja gerade deshalb
gewählt, weil es **keine** Escapes deutet. Die beiden Hälften der Regel
wurden kombiniert und haben sich gegenseitig aufgehoben.

Bemerkt wurden alle drei, weil gemessen wurde (Perl-Warnung gelesen,
`grep -o` und `od -c` danach). Gekostet haben sie trotzdem je einen
Zusatzgriff mitten in Gregors Testlauf, während er auf Antworten wartete.

**How to apply, zusätzlich:**

- **Die Schranke zählt mehr als die Regel.** Fünfzehn Fälle, und die
  `Schranke:`-Zeile oben nennt ein Werkzeug, das nur wirkt, wenn man es
  aufruft. Gemessen am 13.10.2026 im ganzen Repo: das Muster
  `\b[A-Z]:(Temp|Users|Program|Windows|Eudora)` (Laufwerk ohne Rückstrich)
  kommt in `*.md` **nur** in den beiden Zeilen vor, die diese Fälle
  beschreiben; `\x5c` wörtlich nur in Lehren und LEKTOR-Berichten, die es
  als Probe nennen. Eine `pre-commit`-Prüfung auf **hinzugefügte** Zeilen
  hätte also keinen Fehlalarm und hätte `C:TempAN5`, `C:Temp94-nachher` und
  das wörtliche `\x5c` abgewiesen. Gegenproben liegen in der Historie
  (`643ad27`, `324d5d1` vor der Berichtigung).
- **Ein Pfad mit Rückstrich in einer Doku-Zeile geht mit dem Edit- oder
  Write-Werkzeug**, nicht über Bash. Die `.md` sind UTF-8 mit LF; für sie
  gilt die Warnung über das Edit-Werkzeug (Latin-1-Quellen) nicht.

**Offen:** die Prüfung bauen und in `tools/hooks-einrichten.sh` hängen;
dann diese `Schranke:`-Zeile auf sie umstellen.

## Sechzehnter bis achtzehnter Fall, 14.10.2026: die Perl-Warnung stand da und wurde weggefiltert

Während E-105, Transkript `7cea137a-…jsonl`, Zeiten UTC:

| Zeit | Absicht | Weg | Ergebnis |
|---|---|---|---|
| 05:38:50 | Senkrechtstriche aus zitierten Betreffzeilen in der E-105-Zeile von BEFUNDE.md maskieren | Ersatz über die Befehlszeile | der Rückstrich vor dem Senkrechtstrich fehlte, die Tabellenzeile war in Spalten zerfallen; zweiter Anlauf mit `\x5c` im Perl-Ersatz |
| 05:55:40 | `$fotoDir` im Messskript auf das Scratchpad setzen | `perl -0pe 's/…/\$fotoDir = "C:\\Users\\Gregor\\AppData\\Local…"/'` | im Skript stand **`C:SERSGREGORAPPDATAocaltempaudec--users-…`**: `\U` schaltet auf Großschreibung, `\L` auf Kleinschreibung, `\E` beendet das. 8 s später gelesen und durch `$PSScriptRoot` ersetzt, ganz ohne Rückstrich |
| 06:09:59 | `C:\Temp\E105` in WEITERMACHEN und PAKETE | Ersatzskript per Hier-Dokument, Pfad in einem Perl-String in **doppelten** Anführungszeichen | Perl meldete `Unrecognized escape \T passed through` und `Useless use of \E`. **Der nächste Aufruf um 06:10:17 hängte ein `grep -v` auf „escape" und „Useless" an.** Im Ergebnis stand `C:Temp105`, gefunden um 06:10:43 mit einem eigenen `grep` |

**Why:** Der dritte Fall ist der schlimmste. Perl hat den Fehler beim Namen
genannt, mit Zeilennummer, und ich habe die Meldung als Rauschen behandelt
und ausgeblendet. `perl -c` sagte zugleich `syntax OK`, die Warnung ist kein
Syntaxfehler. Das ist [[ausreisser-ist-der-befund]]: was in der eigenen
Ausgabe nicht ins Ergebnis passt, ist der Befund.

Gemessen am 14.10.2026, wie man die Warnung zum Abbruch macht:

    perl -e 'use warnings FATAL => "all"; eval q{"C:\Temp\E105"}; print $@'
    ->  Unrecognized escape \T passed through at (eval 1) line 1.

**How to apply, zusätzlich:**

- **Eine Perl-Warnung zu einem Escape wird nie weggefiltert.** Sie ist die
  Fehlermeldung genau dieser Lehre. `grep -v` auf `escape`, `Useless` oder
  `Unrecognized` in einem Befehl ist der Auslöser, sofort anzuhalten.
- **Ein Ersatzskript beginnt mit `use warnings FATAL => 'all';`** Dann bricht
  es ab, bevor es schreibt.
- **Ein Pfad im Ersatz steht in einfachen Anführungszeichen** (`'C:\Temp\E105'`
  deutet in Perl nur `\\` und `\'`) **oder fällt ganz weg**, wie `$PSScriptRoot`
  um 05:55:51.

### Zwei Perl-Fallen im selben Einsetzskript, beide gemessen

| Zeit | Zeile | Erwartet | Tatsächlich |
|---|---|---|---|
| 06:08:12 | `perl -0pi -e 'my $r = do { local $/; …<$f> }; chomp $r; …'` | Ersatztext ohne abschließenden Zeilenumbruch | `-0` setzt `$/` auf `"\0"`, das `local $/` gilt nur im `do`-Block. `chomp` entfernt danach ein Nullbyte, das es nicht gibt. Der Zeilenumbruch aus dem Hier-Dokument landete **mitten in der E-105-Tabellenzeile** von BEFUNDE.md, gesehen im `git diff` um 06:08:19 |
| 06:10:01 | `my $n = () = $t =~ /$re/g;` als Trefferzähler | 1 | **2**: die Liste enthält je Treffer **alle Fanggruppen**, das Muster hatte zwei. Das Skript brach mit „README.md: 2 Treffer" ab, und um 06:10:10 suchte ich nach einer „doppelten Stelle in README", die es nicht gab |

Nachgerechnet am 14.10.2026: `"xab y"` mit `/(a)(b)/g` ergibt in der
Listenzählung 2, mit `$n++ while $t =~ /…/g` 1. Eine Datei `abc\n`, unter
`perl -0` eingelesen und `chomp`t, hat danach noch 4 Zeichen.

**How to apply:**

- **Treffer zählt `$n++ while $t =~ /…/g`**, nie `() =` mit einem Muster,
  das Klammern hat. Die Prüfung meldet sonst einen Fehler, den es nicht gibt,
  und schickt mich auf die Suche danach ([[pruefstand-kann-blind-sein]]).
- **Unter `-0` oder `-0777` den Zeilenumbruch mit `s/\n\z//` entfernen**,
  nicht mit `chomp`.

**Schranke ab 14.10.2026:** `tools/pruefe-rueckstrich.pl` im `pre-commit`
(14d) weist einen Windows-Pfad ohne Rückstrich (`C:Temp105`) und ein
wörtliches `\x5c` im **Zuwachs** einer `.md` ab. Der Punkt „Offen" aus
Fall 13 bis 15 ist damit erledigt. Sie wirkt erst nach `sh
tools/hooks-einrichten.sh` im Hauptbaum. Gegenprobe: `--selbsttest`, 16 Fälle;
mit abgeschalteter Regel 5 rot; die echte `PAKETE.md`-Zeile von 06:10 weist
sie in einem Wegwerf-Repo ab, berichtigt lässt sie sie durch. Für die beiden
Perl-Fallen gibt es keine Schranke: sie stehen in Wegwerfskripten im
Scratchpad, die kein Haken sieht.

## Neunzehnter und zwanzigster Fall, 23.10.2026: beide außerhalb der Schranke

Gregor am 23.10.2026, nachdem es zweimal in einer Stunde passiert war:
*„wie oft hast du denn seit dem beginn des projektes irgendwelche zeichen
(backslash) verloren? das ist ja jetzt irgendwie ungünstig, kostet uns jedes
mal zeit!"*

Gezählt: **20 Fälle seit dem 06.09.2026**, davon 18 in dieser Datei schon
aufgeschrieben. Die beiden neuen während des Baus von E-125:

| Absicht | Weg | Ergebnis |
|---|---|---|
| Die Projektmappe bauen | `powershell -File tools\bauen.ps1` **über das Bash-Werkzeug** | PowerShell bekam `toolsbauen.ps1` und meldete *„Das Argument … ist nicht vorhanden"*. Der Lauf endete mit **Rückgabe 0** — ein falsches Grün, das nur aufgefallen ist, weil ich die Ausgabe gelesen habe statt den Rückgabewert |
| In `EudoraRes.rc` eine `LTEXT`-Zeile mit den **wörtlichen** Zeichen `\r\n` schreiben | `\r\n` in einem Hier-Dokument, das ein Perl-Skript schreibt | Im Perl-Quelltext stand nur noch `\r\n`, Perl machte daraus **echte CR/LF**. Die Zeichenkette der Ressource war damit über drei Zeilen zerrissen. Gefunden an der Byte-Messung: `CRLF 0` → `CRLF 2` |

**Why:** `tools/pruefe-rueckstrich.pl` hat in beiden Fällen nichts gemeldet —
zu Recht, denn sie liegen außerhalb ihres Umfangs. Sie liest den **Zuwachs
einer `.md`**. Fall 19 schrieb überhaupt keine Datei, der Verlust lag im
Argument eines Befehls; Fall 20 schrieb eine `.rc`. Eine Schranke, die nur
einen von drei Wegen bewacht, erzeugt genau das Gefühl, das Gregor beschreibt:
es ist aufgeschrieben, es gibt ein Werkzeug, und es passiert trotzdem weiter
([[schranke-gehoert-in-den-haken]]).

**How to apply, ab sofort:**

- **Kein Windows-Pfad mit Rückstrich durch das Bash-Werkzeug.** Windows und
  PowerShell nehmen den Schrägstrich überall an, wo ein Pfad steht:
  `tools/bauen.ps1` statt `tools\bauen.ps1`. Damit entfällt Fall 19 als Klasse,
  ohne dass irgendetwas zu prüfen wäre.
- **Der Rückgabewert eines Bauskripts allein ist kein Ergebnis.** Gelesen wird
  die Ausgabe ([[erfolgsmeldung-aus-dem-ergebnis]]). In Fall 19 stand
  `Rückgabe 0` über einer Fehlermeldung.
- **Ein wörtlicher Rückstrich gehört nie in ein Hier-Dokument, das Quelltext
  schreibt.** Entweder `chr(92)` im Perl-Skript, oder — besser — die Stelle so
  formulieren, dass sie ohne Rückstrich auskommt. In Fall 20 war die Lösung
  eine `LTEXT`-Zeile ohne Zeilenumbruch: der Dialog bricht den Text selbst um.
- **Die Byte-Messung nach jedem Schreibzugriff bleibt die Fangstelle, die
  wirklich greift.** Sie hat Fall 20 gefangen, und zwar sofort
  ([[zeilenenden-nach-jedem-schreibzugriff-messen]]).

## Nachtrag 24./25.10.2026 (CHRONIST): zwei Wiederholungen bekannter Fälle, beide mit Regel in dieser Datei

Zeiten MEZ, Transkript `fa3529ec-…jsonl`, gemessen.

| Zeit | Was | Welche Regel hier schon stand | Folge |
|---|---|---|---|
| 25.10. 10:49 und 10:57 | Ersatztext per `BEGIN{local $/; open …; $T=<$h>; chomp $T}` eingelesen | 14.10.: *„Unter `-0` … den Zeilenumbruch mit `s/\n\z//` entfernen, nicht mit `chomp`"* — mit `$/` = undef entfernt `chomp` nichts. Nachgemessen am 25.10.: Datei `abc\n` so eingelesen und `chomp`t hat danach **4** Zeichen | der Zeilenumbruch des Hier-Dokuments landete mitten in der E-148-Tabellenzeile (`Intern/BEFUNDE.md:380-381`, LEKTOR-58 L-58.1) und in `tools/WERKZEUGE.md` (LEKTOR-58: zwei Leerzeilen von diesem Tag). Gefunden hat es der LEKTOR um 16:27, nicht ich — die Tabellenschranke las `Intern/` nicht |
| 25.10. 17:07 | `powershell -File tools\bauen.ps1` über das Bash-Werkzeug | 23.10., Fall 19: *„Kein Windows-Pfad mit Rückstrich durch das Bash-Werkzeug"* — zwei Tage alt | PowerShell bekam `toolsbauen.ps1`; drinnen `bau rc=127`, der Hintergrundlauf meldete trotzdem *„[exited with code 0]"*. Gefunden um 17:08, weil ich die Ausgabe gelesen habe |

Nach der Zählung im CHRONIST-Bericht vom 23.10. (21 Fälle) ist der zweite Fall der **22. Rückstrichverlust**. Beide Regeln standen hier, beide wurden nicht angewendet; beide Befehle lagen außerhalb jeder Schranke (Wegwerfbefehle). Die zweite Zeile ist zugleich ein Fall von [[gekuerzte-ausgabe-ist-kein-ergebnis]]: ein Rückgabewert, der nicht der des Bauskripts war.

**How to apply, zusätzlich:** Ersatztext nicht mehr selbst einlesen, sondern `tools/ersetze-bereich.pl` (steht oben als Schranke und wurde an diesen beiden Tagen nicht benutzt). Wer doch einen Einzeiler schreibt: `$T =~ s/\n\z//`, nie `chomp` innerhalb von `local $/`.

## Nachtrag 26.10.2026: dreiundzwanzigster und vierundzwanzigster Fall, beide mit Regel hier

| Was | Welche Regel hier stand | Folge |
|---|---|---|
| E-142-Status per `chomp $z` unter `local $/` eingelesen | 14.10. und 25.10.: nie `chomp` unter `local $/` | Tabellenzeile E-142 in BEFUNDE zerrissen; `pruefe-tabellenzeilen.pl` fand es vor dem Commit |
| neuer Testblock fuer `TestE77.cpp` (C-Pfade mit doppeltem Rueckstrich) per Hier-Dokument in eine Datei | Fall 11/12 (12.10.): Text mit doppeltem Rueckstrich nur mit dem Write-Werkzeug | im Test stand ein Pfad mit einfachen Rueckstrichen; der Compiler warnte C4129, der Test war rot. Gefunden an der Warnung, nicht an einer Messung |

**How to apply:** Ein Einsetzblock fuer **C/C++-Quelltext** geht immer mit dem Write-Werkzeug in die Zwischendatei, nicht nur Doku-Pfade; C-Zeichenketten tragen fast immer Rueckstriche. Neue Testdateien, die ganz mit dem Write-Werkzeug entstanden (`TestE146.cpp`, `TestRootCertsLog.cpp`), waren richtig.

## Nachtrag 27.10.2026 (CHRONIST): fünfundzwanzigster und sechsundzwanzigster Fall, einen Tag nach der Regel

Zeiten MEZ, gemessen am Transkript.

| Zeit | Was | Regel hier | Folge |
|---|---|---|---|
| 12:07:26 / 12:07:39 | E-160: Quelltextzeilen und Testzeilen mit Registry-Pfaden (`Software\\Microsoft\\Office\\16.0\\…`) per `cat > $S/… <<'EOF'` in Zwischendateien | Nachtrag 26.10.: *„Ein Einsetzblock für C/C++-Quelltext geht immer mit dem Write-Werkzeug“* | In `OLImportClass.cpp:320` und `TestE160.cpp:31/33` standen einfache Rückstriche. Ein Reparaturversuch per `perl -i -pe 's/\\\\/…/g'` (12:07:46) verdoppelte jeden Rückstrich, auch den vor dem Anführungszeichen (`\\"Software…`). Erst `od -c` (12:08:05) zeigte, dass schon die Zwischendatei nur **einen** Rückstrich hatte, **obwohl das Hier-Dokument in Hochkommas stand**. Mit dem Write-Werkzeug neu geschrieben (12:08:12–16), danach richtig |
| 15:39:45 | Neue Zeile für `tools/ZWEIGE.md` mit `„…“` und `–` als `\x{201E}`, `\x{2013}` in einem `perl -i -pe` ohne Ausgabeschicht | 14.10. (Fall mit `\x{2014}`) und [[zeilenenden-nach-jedem-schreibzugriff-messen]] (*„Wide character“*) | `Wide character in print … line 175`: die **vorhandene** Zeile 175 (*„ja, paßt“*) wurde doppelt kodiert, nicht nur die neue. Erkannt an der Warnung (15:39:51), Datei aus Git zurückgeholt, Zeile mit dem Write-Werkzeug und `<:raw` eingesetzt (15:40:03–10) |

Beide Male hat die Messung danach gegriffen, der Schaden kam nicht in einen Commit. Beide Male stand die Regel einen Tag vorher in dieser Datei.

**Neu gemessen:** Ein Hier-Dokument mit `<<'EOF'` ist auf diesem Weg **nicht** rückstrichfest. Gemessen 12:08:05 an `q320.txt`. Die Annahme „gequotetes Heredoc reicht ja“ ist widerlegt ([[widerlegte-vermutungen-aufschreiben]]).

**How to apply, zusätzlich:**
- Zwischendateien mit Rückstrich, Anführungszeichen oder Nicht-ASCII-Zeichen entstehen **nur** mit dem Write-Werkzeug. Ein Heredoc ist für solchen Text kein Weg, auch nicht in Hochkommas.
- `\x{…}` über 255 nie in einem Perl-Einzeiler, der eine Datei roh umschreibt. Das Zeichen gehört als UTF-8-Bytes in die Zwischendatei.
