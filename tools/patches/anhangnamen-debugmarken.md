# Patch: Debug-Marken auf dem Weg eines Anhangnamens

**Datei:** `anhangnamen-debugmarken.patch`
**Betrifft:** sieben Dateien —
`QCUtils/public/inc/debug.h`, `QCUtils/src/debug.cpp`,
`Eudora/lex822.cpp`, `Eudora/header.cpp`, `Eudora/mime.cpp` (POP),
`EuImap/src/ImapLex822.cpp`, `EuImap/src/ImapHeader.cpp` (IMAP)
**Befund:** **AN-1**
**Stand:** **nicht angewandt** — bereitgelegt, weil in dieser Sitzung kein
Compiler zur Verfügung stand

> **Dieser Patch und `anhangnamen-faltung.patch` stören sich nicht.** Beide
> greifen einzeln auf den unveränderten Baum, und die Behebung greift auch noch,
> wenn die Marken schon drin sind (mit `git apply --check` nachgewiesen). Die
> Marke im Zerleger sitzt deshalb **vor** dem `switch` und nicht im
> `case CR822:`, den der Behebungspatch umschreibt.

---

## Wozu

Wenn beim Mailabruf ein Anhang unter einem falschen Namen landet, soll man in
**einer Logdatei** sehen können, **wo** auf dem Weg der Name kaputtgeht — ohne
Debugger, ohne Haltepunkte, ohne Neubau. Der Weg hat sieben Stationen, und an
jeder kann etwas verlorengehen.

## Einschalten

Eudora hat die Logdatei schon: `QCLogFileMT`, gesteuert über eine **Bitmaske**
in `eudora.ini`. Der Patch legt ein neues Bit an:

```
const DebugMaskType DEBUG_MASK_ATTACH = 0x10000;
```

In `eudora.ini`, Gruppe `[Settings]`:

```
LogLevel=91295
```

**91295 = 25759 (die Voreinstellung) + 65536 (`0x10000`).** Ist dort schon ein
anderer Wert eingetragen, einfach 65536 dazuzählen. Die Einstellung wirkt beim
nächsten Start; geschrieben wird nach **`eudora.log`** im Eudora-Verzeichnis.

Alles, was dieser Patch schreibt, beginnt mit `ANHANG`:

```
grep ANHANG eudora.log
```

## Die acht Marken

| # | Wo | Was sie sagt |
|---|---|---|
| 1 | `Lex822()`, Marke voll (`lex822.cpp:206`) | Ein Wert wird bei 254 Zeichen gekappt — AN-1, zweiter Teil |
| 2 | `Lex822()`, vor dem `switch` (`lex822.cpp:213`) | **Ein Umbruch mitten in einer Zeichenkette in Anführungszeichen.** Das ist AN-1, erster Teil — die Stelle, an der die Endung verlorengeht |
| 3 | `HeaderDesc::AddAttribute` (`header.cpp:476`) | Der Wert, **wie er abgelegt wird** — nach allem, was Zerleger und `AddAttribute` damit gemacht haben. Wer nur eine Zeile braucht: diese |
| 4 | `GenericReader::ReadIt` (`mime.cpp:1634`) | **Woher der Name kommt**: aus `filename`/`name` — oder, wenn beides fehlt, aus dem **Betreff** (`subj[32]`, 31 Zeichen). Letzteres ist der Fingerabdruck von RFC 2231 |
| 5 | dieselbe Stelle, nach `MIMEMap` | Ob das Sicherheitsnetz die Endung nachgetragen hat — und wenn nicht, dass `MIMEMap` den Typ gar nicht kennt (`application/octet-stream` steht nicht in `[Mappings]`) |
| 6 | `OpenAttachFile` / `OpenEmbeddedFile` (`mime.cpp:1275`) | Der Name **vor und nach** `DeMacifyName32` — und ob überhaupt die 8+3-Fassung `DeMacifyName` gelaufen ist |
| 7 | dieselbe Stelle, nach `CheckName` | **Wie die Datei am Ende wirklich heißt**, mit vollem Pfad |
| 8 | `CheckName` (`mime.cpp:1127`) | Dass hier gekürzt wurde — das ist der eine Ort auf dem ganzen Weg, der die Endung dabei richtig erhält |

Die Marken 1, 2 und 3 gibt es **zweimal**: einmal für POP (`lex822.cpp`,
`header.cpp`) und einmal für IMAP (`ImapLex822.cpp`, `ImapHeader.cpp`). Sie sind
im Log an `ANHANG ImapLex822:` bzw. `ANHANG ImapKopfzeile:` zu erkennen.

## Steuerzeichen werden sichtbar

Der Patch bringt dafür eine eigene Ausgabe mit, `PutDebugLogSichtbar()` in
`QCUtils/src/debug.cpp`. Sie ersetzt `CR` durch `<CR>`, `LF` durch `<LF>`,
Tabulator durch `<TAB>` und alles andere unter 32 durch `<XX>` in hexadezimal.

**Ohne das wäre der Log für diesen Befund wertlos** — eine Faltung im
Dateinamen sähe aus wie ein Zeilenumbruch im Log und wäre nicht von einem
echten zu unterscheiden. Erprobt (mit `g++` gegen einen Stellvertreter gefahren):

```
ANHANG Lex822: Umbruch IN der Zeichenkette [Angebot Nr 4711 fuer die Stadtwerke
Musterstadt<CR><LF> Abrechnungszeitraum 2025.pdf] (76)
```

Die Funktion arbeitet mit einem festen Puffer und ohne `CString` — sie läuft
mitten im Empfangsweg und darf dort nichts anfassen, was schiefgehen könnte.

## So liest man das Ergebnis

Ein Abruf des Prüffalls `01-gefaltet-leerzeichen` aus
`tools/pruefdaten/anhang-faltung/` **müsste** ungefähr das hier liefern:

```
ANHANG Lex822: Umbruch IN der Zeichenkette - Rest geht verloren [Angebot ... Musterstadt] (47)
ANHANG Kopfzeile: filename = [Angebot ... Musterstadt] (47)
ANHANG Name: aus filename/name [Angebot ... Musterstadt] (47)
ANHANG Name: nach MIMEMap::SetExtension [Angebot ... Musterstadt.pdf] (51)
ANHANG Datei: Name vor DeMacify [Angebot ... Musterstadt.pdf] (51)
ANHANG Datei: nach DeMacifyName32 [Angebot ... Musterstadt.pdf] (51)
ANHANG Datei: WIRD GESCHRIEBEN ALS [C:\...\attach\Angebot ... Musterstadt.pdf] (51)
```

**Die erste Zeile ist der Befund.** Alles danach arbeitet nur noch mit dem, was
sie übriggelassen hat. Ob `MIMEMap` in Zeile 4 rettet, hängt vom MIME-Typ ab —
bei `application/octet-stream` steht dort stattdessen „kennt den Typ NICHT", und
dann fehlt die Endung bis zum Schluss.

> **Das ist eine Erwartung, keine Messung.** Übersetzt und ausgeführt ist
> nichts. Weicht der wirkliche Log davon ab, ist die Abweichung selbst der
> nächste Befund — dann bitte den Log-Ausschnitt an AN-1 anhängen.

## Kosten

Jede Marke prüft zuerst das Maskenbit und kehrt sofort zurück, wenn es aus ist.
Bei ausgeschaltetem Log sind das ein Vergleich und ein Funktionsaufruf je Marke.
Die beiden Marken im Zerleger sitzen in der innersten Schleife — deshalb prüfen
sie **vor** dem Aufruf mit `QCLogFileMT::DebugMaskSet()` und nicht erst darin.

## Was dieser Patch **nicht** tut

- Er behebt nichts. Er macht nur sichtbar.
- Er ist **nicht übersetzt**. Geprüft ist: `g++ -fsyntax-only` über alle
  eingefügten Blöcke (fehler- und warnungsfrei) und `PutDebugLogSichtbar()`
  einmal wirklich gebaut und ausgeführt.
- Die IMAP-Seite bekommt nur die Marken 1 bis 3. Für die Marken 4 bis 8 fehlt
  dort das Gegenstück in dieser Fassung — `EuImap/src/imapmime.cpp` hat eigene
  Abschriften von `OpenAttachFile` und `CheckName`, die noch nicht mit
  aufgenommen sind. Nachziehen, sobald IMAP dran ist.
