---
name: zeilenenden-nach-jedem-schreibzugriff-messen
description: "Nach jedem Skript, das Dateien schreibt, die CR-Anzahl gegen HEAD messen - der Fehler ist lautlos"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T08:30:18.185Z
---

Schranke: tools/pruefe-bytes.pl (pre-commit, pre-push)

Nach **jedem** Skript, das Dateien im Repo schreibt, und **vor** `git add`:
CR-Anzahl der Arbeitskopie gegen `git show HEAD:<datei>` vergleichen. Weicht sie
ab, zurueckwandeln, bevor irgendetwas gestaget wird.

**Why:** Am 28.08.2026 zweimal passiert. Einmal wurden vier reine LF-Dateien
(statbar.cpp, header.cpp, BossProtector.cpp, TridentPreviewView.cpp) auf CRLF
umgestellt - 2194 Scheinaenderungen allein in statbar.cpp, Ursache bis heute
ungeklaert. Einmal landete ein echtes CR-Byte im Text von PORTIERUNG.md.
Gregor hat beides bemerkt und gefragt, wo die Schwierigkeit liege.

Die Schwierigkeit ist, dass der Fehler **lautlos** ist: kein Abbruch, keine
Warnung, der fachliche Inhalt stimmt. Sichtbar wird er erst im Diff, und dann
sieht eine Einzeilenaenderung wie ein Totalumbau aus. Eine Regel im Kopf reicht
dagegen nicht, nur eine Messung.

**How to apply:**

- Pruefbefehl: `tr -cd '\r' < datei | wc -c` gegen
  `git show HEAD:datei | tr -cd '\r' | wc -c`.
- **Nie ein Steuerzeichen-Escape in einen Heredoc schreiben.** Getestet und
  bestaetigt: ein doppelt geschriebenes Backslash-r kommt bei Perl als einfaches
  an und wird zum CR-Byte - auch bei `<<'MARKE'` in Anfuehrungszeichen. Wenn im
  Text von Zeilenenden die Rede sein soll, umschreiben ("CR-Anzahl per tr")
  statt das Escape zu setzen.
- Entlastet: Lesen mit `:raw`, `split /(?<=\n)/`, `join`, Schreiben mit `:raw`
  ist byte-erhaltend (getestet, 0 CR bei einer LF-Datei). Der Roundtrip ist
  nicht die Ursache.
- Bei gemischten Zeilenenden im Repo (hier der Normalfall) nie pauschal
  konvertieren, sondern nur die Dateien zuruecksetzen, deren CR-Zahl abweicht.

**Nachtrag 07.09.2026 — das Messwerkzeug hat gelogen.** Beim Schreiben mehrerer
MD-Dateien habe ich alles auf CRLF gesetzt, obwohl die Dateien reines LF waren;
die Byte-Schranke im pre-commit-Hook hat es gefangen. Beim Nachmessen kamen
dann drei Fehler dazu, alle drei lehrreich:

- Gemessen wurde **nach** dem Schreiben statt **vorher gegen HEAD** — die Regel
  im ersten Satz dieser Lehre, wortwoertlich nicht befolgt.
- `grep -c` auf ein CR und Perl ohne `:raw` lesen unter Windows im
  **Textmodus** und zaehlen dabei Unsinn: gemeldet wurden 559 CR bei
  tatsaechlich 53. Also nur `tr -cd` bzw. Perl mit `binmode`/`:raw` — ein
  Messwerkzeug, das die Groesse veraendert, die es messen soll, ist keins.
- `tools/pruefe-bytes.pl` liest den **Index**, nicht den Arbeitsbaum. Nach dem
  Zuruecknormalisieren muss neu gestaget werden, sonst prueft die Schranke die
  alte Fassung und meldet den Fehler weiter.


**Nachtrag 10.09.2026 — dieselbe Lehre, nicht angewendet, und was mich
gerettet hat.** Beim Einbau von E-75 habe ich die Zeilenenden von vier
Dateien mit `grep -c $'\r'` gezaehlt. Ergebnis: CR gleich Zeilenzahl in allen
vier Dateien, also scheinbar reines CRLF. Ich habe daraufhin ein
Aenderungsskript mit `\r\n` geschrieben. **Alle fuenf Ersetzungen passten
0x** — die Dateien sind in Wahrheit LF, mainfrm.cpp und TocFrame.cpp mit
genau 18 CRLF-Ausreissern.

Der Absatz `grep -c` in dieser Lehre stand da schon. Ich habe ihn nicht
befolgt.

Die Ursache ist praeziser als bisher beschrieben und hat nichts mit dem
Windows-Textmodus zu tun: **`$'\r'` kommt durch die Werkzeugschicht als
leeres Muster an**, und `grep -c ''` zaehlt jede Zeile. Nachgemessen an
`resource.h`, die kein einziges CR-Byte enthaelt:

    grep -c $'\r' resource.h      4472      <- alle Zeilen
    grep -c "$CR" resource.h         0      <- CR=$(printf '\r'), richtig
    grep -c '' resource.h         4472      <- das leere Muster, gleiche Zahl

Verwandt mit [[text-nicht-durch-schichten-schicken]]: ein Steuerzeichen
ueberlebt den Weg durch die Schichten nicht, und zwar auch dann nicht, wenn
es nur ein *Suchmuster* ist und kein Ersetzungstext.

**Der verlaessliche Messbefehl** ist Perl auf `:raw`, und er nennt beide
Zahlen in einer Zeile (siehe [[zwei-werte-in-eine-ausgabe]]):

    perl -e 'open my $h,"<:raw",$ARGV[0];local $/;my $t=<$h>;
             my $crlf=()=$t=~/\r\n/g; my $lf=()=$t=~/\n/g;
             printf "CRLF=%d nur-LF=%d\n",$crlf,$lf-$crlf;' datei

**Was mich wirklich gerettet hat, war nicht die Regel, sondern die Bauform
des Skripts:** es prueft erst *alle* Ersetzungen gegen *alle* Dateien, meldet
zu jeder, wie oft sie passt, und schreibt **nur, wenn jede genau einmal
passt**. Ein Skript, das Datei fuer Datei ersetzt und schreibt, haette hier
nichts gefunden und nichts geaendert — und ich haette den Bau angeworfen und
mich ueber das unveraenderte Verhalten gewundert.

Dazu gehoert die zweite Haelfte: das Skript zaehlt die CRLF **vor** und
**nach** der Aenderung und schreibt nur, wenn die Zahl gleich geblieben ist.
Damit misst es die eigene Annahme ueber die Zeilenenden nach, statt ihr zu
vertrauen.

Also, als Bauform fuer jedes Aenderungsskript an Quelldateien:

1. alle Dateien lesen, Zeilenenden zaehlen und merken,
2. alle Ersetzungen im Speicher ausfuehren und jede auf **genau einmal**
   pruefen, bei Abweichung abbrechen, **ohne etwas zu schreiben**,
3. Zeilenenden gegen Schritt 1 halten, bei Abweichung abbrechen,
4. erst dann schreiben.

Siehe auch [[pruefen-statt-vermuten]],
[[doku-bei-jedem-commit-mitziehen]] und [[schranke-gegentesten]].
