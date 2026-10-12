# Prüfdaten

Erzeugte Nachrichten zum Nachstellen von Befunden. **Kein Fremdmaterial, keine
echte Post** — alles hier ist aus einem Werkzeug im Repo entstanden und lässt
sich damit jederzeit neu erzeugen.

## `anhang-faltung/` — Befund **AN-1**

Sechs Nachrichten mit einem PDF im Anhang. Sie unterscheiden sich nur in einem
Punkt: **wo im Kopf des Anhangs der Zeilenumbruch sitzt** und wie der Dateiname
angegeben ist.

| Datei | Dateiname im Kopf | bis 7.2.0.78 | ab 7.2.0.81 (gemessen 12.10.2026, `C:\Temp\AN3`; ebenso 7.2.0.82 in `C:\Temp\AN4` und 7.2.0.83 in `C:\Temp\AN5`) |
|---|---|---|---|
| `00-gutfall.eml` | `"Rechnung.pdf"`, eine Zeile | `Rechnung.pdf` — **muss heil sein** | `Rechnung.pdf` |
| `01-gefaltet-leerzeichen.eml` | gefaltet an einem Leerzeichen **innerhalb** der Anführungszeichen | abgeschnitten, **ohne `.pdf`** | voller Name, 76 Zeichen, `.pdf` |
| `02-gefaltet-tabulator.eml` | dasselbe, mit Tabulator | abgeschnitten, **ohne `.pdf`** | voller Name, 56 Zeichen, `.pdf` |
| `03-ueber-254-zeichen.eml` | 304 Zeichen, ungefaltet | bei 254 gekappt, ohne `.pdf` | auf 224 gekürzt (Pfad unter 260), **mit `.pdf`** |
| `04-rfc2231.eml` | `filename*0=` / `filename*1=` (RFC 2231) | der **Betreff**, auf 31 Zeichen | voller Name, `.pdf` — gespeichert als `…Musterstadt 20251.pdf`, weil der Name aus Fall 02 schon belegt ist |
| `05-leerer-dateiname.eml` | `filename=""` | eine Datei namens `=` | der Betreff **mit `.pdf`** (aus `MIMEMap`) |

**Erzeugt und ausgeliefert von `tools/anhang-pruefdaten.pl`.** Das Werkzeug ist
die Quelle, diese Dateien sind sein Ergebnis — `--erzeugen` schreibt sie neu.

## Wie geprüft wird

**Eine `.eml` in eine `.mbx` zu kopieren reicht nicht.** Der Fehler sitzt im
*Empfangs*weg (`CPOP::WriteMessageToMBX_` → `HeaderDesc::Read` → `Lex822`).
Liegt die Nachricht schon in der Mailbox, läuft dieser Weg nie, und der Anhang
wird gar nicht erst geschrieben. Die Nachricht muss **abgerufen** werden.

Dafür bringt das Werkzeug einen winzigen POP3-Server mit — kein Netz, keine
Zugangsdaten, alles auf `127.0.0.1`:

```
perl tools/anhang-pruefdaten.pl --pop
```

Dann in Eudora ein Konto anlegen: Server `127.0.0.1`, Port `11110`, Benutzer
`pruef`, Kennwort beliebig, **SSL aus**. Mail abrufen und ins Anhangverzeichnis
sehen (Eudora-Verzeichnis, Unterordner `attach`).

Ist **00 heil und sind 01 bis 05 kaputt**, ist AN-1 bestätigt. Sind hinterher
**alle sechs heil**, wirken die Behebungen aus `AUFGABEN.md` B5 auf dem
**POP**-Weg am laufenden Programm — B5.6 betrifft nur IMAP und wird hiermit
nicht gemessen. **Gemischtes Bild** (so an 7.2.0.79: 00, 01, 02, 04 heil):
dann zeigt `grep ANHANG eudora.log` mit `LogLevel=91295`, an welcher Station
der Name kürzer wird oder die Endung fehlt.

Der Server löscht nie etwas: nach `QUIT` liegen alle sechs Nachrichten wieder
da, man kann also beliebig oft abrufen.

## Woran man es auch in echter Post erkennt

Eudora schreibt die Kopfzeile in die `.mbx`-Datei zurück — und setzt dabei im
Fehlerfall **ein Anführungszeichen an die falsche Stelle**. In der Mailbox steht
dann:

```
	filename="Angebot Nr 4711 fuer die Stadtwerke Musterstadt"
 Abrechnungszeitraum 2025.pdf"
```

Zwei schließende Anführungszeichen: eines am Zeilenende vor einer Zeile, die mit
Leerzeichen oder Tabulator beginnt, und das ursprüngliche am Ende. **Das ist der
Fingerabdruck** — wer in einer `.mbx` danach sucht, findet die betroffenen
Nachrichten, ohne die Originale zu brauchen.
