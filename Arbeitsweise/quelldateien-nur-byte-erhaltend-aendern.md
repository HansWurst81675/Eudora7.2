---
name: quelldateien-nur-byte-erhaltend-aendern
description: "Eudora-Quellen sind Latin-1 mit gemischten Zeilenenden - nur byte-erhaltend aendern, nie mit dem Edit-Werkzeug"
metadata:
  type: project
---

Die Eudora-Quellen von 1996-2006 sind **Latin-1-kodiert** (nicht UTF-8) und haben
**gemischte Zeilenenden** innerhalb derselben Datei. Beides muss jede Aenderung
unangetastet lassen.

**Das Edit-Werkzeug darf an diesen Dateien nicht benutzt werden.** Es schreibt die
ganze Datei neu und beschaedigt dabei beides. Am 28.08.2026 nachgewiesen:

- `html2text.cpp`: aus dem Byte `0xC1` (`A` mit Akut) wurde `EF BF BD`, das
  Unicode-Ersatzzeichen - 267 Zeilen der Zeichentabelle fuer Akzente und Umlaute
  zerstoert. Ausgerechnet die Tabelle, um die es bei diesem Projekt geht.
- `AboutDlg.h`, `html2text.cpp`: 0 CR-Bytes wurden zu 87 bzw. 1620.
- `ConConMessage.cpp`, `mime.cpp`, `MIMEMap.cpp`: die 18 vorhandenen CR-Bytes
  verschwanden.

**Stattdessen:** Perl mit `:raw` lesen und schreiben, Zeile ueber ihre Nummer
ansprechen, per `index`/`substr` ersetzen. Das ist byte-erhaltend (getestet).
Keine Regex-Escapes in Heredocs (siehe
[[zeilenenden-nach-jedem-schreibzugriff-messen]]).

**Pflichtkontrolle vor jedem `git add`:**

- CR-Anzahl gegen `git show HEAD:<datei>`
- Zahl der Ersatzzeichen (`grep -c` auf die Bytefolge EF BF BD) gegen HEAD
- `git diff --stat`: eine Einzeilenaenderung muss als eine Zeile erscheinen.
  Zeigt der Diff hunderte Zeilen, ist die Datei umgeschrieben worden.

## Das fertige Werkzeug benutzen, nicht sed von Hand

Im Repo liegt `tools/aendere-zeile.pl`. Es macht genau das oben Beschriebene und
bricht ab, wenn sich die CR-Anzahl aendern wuerde:

    perl tools/aendere-zeile.pl <datei> <zeilennummer> <alt> <neu>

`<alt>` ist eine woertliche Zeichenkette, kein regulaerer Ausdruck.

**Nicht mehr `sed -b` mit von Hand eingebauten `\r\n` benutzen.** Am 29.08.2026
hat mich genau das zweimal Zeit gekostet: von vier eingefuegten Zeilen bekamen
zwei CRLF und zwei nur LF, und in `EudoraExe.rc` (in HEAD reines LF) landeten
130 CR. Der pre-commit-Hook `tools/pruefe-bytes.pl` (die "Schranke") hat beides
abgefangen — aber erst nach der Arbeit, nicht davor. Gregor hat zu Recht
angemerkt, dass das Zeit kostet.

## Zeilen einfuegen

`aendere-zeile.pl` lehnt jedes Einfuegen ab, weil sich dabei die CR-Anzahl aendert.
Zwei gangbare Wege:

1. **Gar keine Zeile einfuegen.** In XML (`.vcxproj`) mehrere Elemente in dieselbe
   Zeile schreiben: `<SubSystem>Windows</SubSystem><ImageHasSafeExceptionHandlers>false</ImageHasSafeExceptionHandlers>`
   MSBuild liest das genauso. Zeilenzahl und CR-Anzahl bleiben unveraendert, die
   Schranke ist zufrieden, und der Diff bleibt eine Zeile.
2. Muss doch eine Zeile dazu, das Zeilenende der **Nachbarzeile** uebernehmen und
   die erwartete neue CR-Zahl vorher ausrechnen und hinterher nachmessen.
