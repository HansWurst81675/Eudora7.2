---
name: text-nicht-durch-schichten-schicken
description: Ersetzungstext mit Backslashes oder Anfuehrungszeichen nie inline durch Bash/PowerShell nach Perl reichen; in eine Datei schreiben und ueber Zeilenanker einsetzen
metadata:
  type: feedback
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
