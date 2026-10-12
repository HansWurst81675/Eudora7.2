# Patch: Debug-Marken auf dem Weg eines Anhangnamens

**Datei:** `anhangnamen-debugmarken.patch`
**Betrifft:** neun Dateien —
`QCUtils/public/inc/debug.h`, `QCUtils/src/debug.cpp`,
`Eudora/lex822.cpp`, `Eudora/header.cpp`, `Eudora/mime.cpp` (POP),
`EuImap/src/ImapLex822.cpp`, `EuImap/src/ImapHeader.cpp`,
`EuImap/src/ImapDownload.cpp`, `EuImap/src/imapmime.cpp` (IMAP)
**Befund:** **AN-1**
**Stand:** **nicht angewandt** — er liegt bereit und wird mit `git apply`
eingespielt.

> **Dieser Patch und `anhangnamen-faltung.patch` stören sich nicht.** Beide
> greifen einzeln auf den unveränderten Baum, und die Behebung greift auch noch,
> wenn die Marken schon drin sind (mit `git apply --check` nachgewiesen, zuletzt
> am 12.10.2026 gegen `d5669e2`). Die Marke im Zerleger sitzt deshalb **vor**
> dem `switch` und nicht im `case CR822:`, den der Behebungspatch umschreibt.

---

## Was daran gemessen ist und was nicht

| | |
|---|---|
| **Marken 1 bis 8 (POP) und 1 bis 3 (IMAP)** | **am laufenden Programm gemessen.** Gregor hat die vorige Fassung dieses Patches am 12.10.2026 übersetzt (7.2.0.77, Release, 0 Fehler) und Mail abgerufen. Sein `eudora.log` enthält **285 `ANHANG`-Zeilen**. Der Schalter `[Debug] LogLevel=91295` steht als `LogLevel 91295 (0x1649F)` im Logkopf — die Angabe unten ist damit nachgemessen, nicht behauptet |
| **Marken 4 bis 9 der IMAP-Seite** | **nicht übersetzt.** Sie sind am 12.10.2026 dazugekommen, nachdem dieses Log gezeigt hatte, dass der IMAP-Weg keine davon hatte. Geprüft ist: `g++ -fsyntax-only -Wall -Wextra` über alle eingefügten Blöcke, fehler- und warnungsfrei |

## Wozu

Wenn beim Mailabruf ein Anhang unter einem falschen Namen landet, soll man in
**einer Logdatei** sehen können, **wo** auf dem Weg der Name kaputtgeht — ohne
Debugger, ohne Haltepunkte, ohne Neubau.

## Einschalten

Eudora hat die Logdatei schon: `QCLogFileMT`, gesteuert über eine **Bitmaske**
in `eudora.ini`. Der Patch legt ein neues Bit an:

```
const DebugMaskType DEBUG_MASK_ATTACH = 0x10000;
```

In `eudora.ini` gehört `LogLevel` in die Gruppe **`[Debug]`** — nicht nach
`[Settings]`. Eudora ordnet jeden Schlüssel allein nach seiner Nummer zu
(`rs.cpp:89`, `GetSectionID`), und `IDS_INI_DEBUG_LOG_LEVEL` ist `10802`:
größer als `IDS_INISN_DEBUG` (10800), kleiner als `IDS_INISN_WINDOW_POSITION`
(10900). Nachzusehen mit `perl tools/pruefe-ini-abschnitte.pl --was LogLevel`.

```ini
[Debug]
LogLevel=91295
```

**91295 = 25759 (die Voreinstellung) + 65536 (`0x10000`).** Ist dort schon ein
anderer Wert eingetragen, einfach 65536 dazuzählen. Die Einstellung wirkt beim
nächsten Start; geschrieben wird nach **`eudora.log`** im Eudora-Verzeichnis.

Alles, was dieser Patch schreibt, beginnt mit `ANHANG`:

```
grep ANHANG eudora.log
```

## Die Marken des POP-Wegs

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

## Die Marken des IMAP-Wegs

**Der IMAP-Weg ist nicht dieselbe Strecke mit anderen Dateinamen, sondern eine
andere Strecke.** Das ist die wichtigste Berichtigung, die aus Gregors Log vom
12.10.2026 folgt:

> Über IMAP kommt der Anhangname **nicht** aus `Lex822`, sondern aus der
> **BODYSTRUCTURE**-Antwort des Servers — `GetFilenameParameter`
> (`ImapDownload.cpp:5964`) liest ihn aus den c-client-Strukturen
> `BODY`/`PARAMETER`. Eine Faltung hat der Server da längst aufgelöst.
> **AN-1, erster Teil, kann über IMAP also gar nicht zuschlagen.**

`ImapLex822`/`ImapHeader` zerlegen den Kopf trotzdem — aber für die
Mailbox-Datei, nicht für den Dateinamen. Die Marken 1 bis 3 der IMAP-Seite
sitzen dort und sind deshalb für AN-1 **nebensächlich**; nützlich sind sie
trotzdem, siehe „Was das Log sonst noch zeigte".

| # | Wo | Was sie sagt |
|---|---|---|
| 4 | `GetFilenameParameter` (`ImapDownload.cpp:5964`) | Welchen Namen die BODYSTRUCTURE geliefert hat — **oder dass sie keinen hatte**. Letzteres ist über IMAP der Fingerabdruck von RFC 2231 (AN-1, fünfter Teil) |
| 5 | `CreateAttachFile` (`ImapDownload.cpp:4108`) und `BreakoutBodyToEmbeddedFile` (`:3723`) | Der Name, der zur Datei geht. **Hier ruft der IMAP-Weg kein `MIMEMap::SetExtension` auf** — das Sicherheitsnetz des POP-Wegs, das eine fehlende Endung aus dem MIME-Typ nachträgt, gibt es über IMAP überhaupt nicht |
| 6 | `OpenLocalAttachFile` (`imapmime.cpp:292`) | Der Name **vor und nach** `LOCAL_DeMacifyName32` bzw. `LOCAL_DeMacifyName` (8+3) |
| 7 | dieselbe Stelle, nach `LOCAL_CheckName` | **Wie die Datei am Ende wirklich heißt**, mit vollem Pfad |
| 8 | `LOCAL_CheckName` (`imapmime.cpp:125`) | Dass gekürzt wurde — und ob der Name überhaupt einen Punkt hat. Hat er keinen, fällt sein Ende ersatzlos weg |
| 9 | `LOCAL_CheckName` (`imapmime.cpp:173`) | **`tmp` ist `char[255]`.** Ist der Name ohne Punkt 255 Zeichen oder länger, schreibt das `tmp[len] = 0;` zwei Zeilen weiter **hinter den Puffer, auf den Stapel** — und der Name kommt vom Server. Die Marke meldet das, behebt es nicht |

## Steuerzeichen werden sichtbar

Der Patch bringt dafür eine eigene Ausgabe mit, `PutDebugLogSichtbar()` in
`QCUtils/src/debug.cpp`. Sie ersetzt `CR` durch `<CR>`, `LF` durch `<LF>`,
Tabulator durch `<TAB>` und alles andere unter 32 durch `<XX>` in hexadezimal.

**Ohne das wäre der Log für diesen Befund wertlos** — eine Faltung im
Dateinamen sähe aus wie ein Zeilenumbruch im Log und wäre nicht von einem
echten zu unterscheiden. So sieht es in Gregors Log vom 12.10.2026 wirklich
aus, gekürzt:

```
ANHANG ImapLex822: Marke voll, wird gekappt [ v=1; a=rsa-sha256; c=relaxed/relaxed;
d=web.de;<CR><LF><TAB>s=s29768273; t=1789902988; … ] (254)
```

Die Funktion arbeitet mit einem festen Puffer und ohne `CString` — sie läuft
mitten im Empfangsweg und darf dort nichts anfassen, was schiefgehen könnte.

## Was das Log sonst noch zeigte

In **vier** abgerufenen Nachrichten schlug die 254-Zeichen-Kappung
**281 Mal** zu. Getroffen wurden `DKIM-Signature` und `X-UI-Filterresults`;
dort ist es folgenlos, weil der Kopfzeilentext stückweise durchgeschrieben
wird. Aber damit ist **B5.3** — `BYTE Token[256]`, im Quelltext kommentiert mit
*„tokens over 255 characters will be shot"* — kein Randfall, sondern der
Normalfall des gewöhnlichen Mailverkehrs.

## So liest man das Ergebnis

Ein Abruf des Prüffalls `01-gefaltet-leerzeichen` aus
`tools/pruefdaten/anhang-faltung/` **über den POP-Prüfstand** müsste ungefähr
das hier liefern:

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

> **Das ist eine Erwartung, keine Messung.** Über POP ist dieser Durchlauf noch
> nicht gefahren worden — Gregors Log vom 12.10.2026 kam über IMAP und enthält
> keine einzige POP-Zeile. Weicht der wirkliche Log davon ab, ist die Abweichung
> selbst der nächste Befund.

## Kosten

Jede Marke prüft zuerst das Maskenbit und kehrt sofort zurück, wenn es aus ist.
Bei ausgeschaltetem Log sind das ein Vergleich und ein Funktionsaufruf je Marke.
Die beiden Marken im Zerleger sitzen in der innersten Schleife — deshalb prüfen
sie **vor** dem Aufruf mit `QCLogFileMT::DebugMaskSet()` und nicht erst darin.

## Der Prüfstand läuft mit

`tools/kopfzeile-pruefen.pl` zieht `Lex822()` wörtlich aus `lex822.cpp`. Bis zum
12.10.2026 hieß das: **sobald dieser Patch angewandt war, übersetzte der
Prüfstand nicht mehr** — fünf Fehler, weil ihm `DEBUG_MASK_ATTACH`,
`PutDebugLogSichtbar` und `QCLogFileMT` fehlten. Er wäre also genau in dem
Moment blind geworden, in dem er gebraucht wird (B5.0 kommt vor B5.1).

Er bringt diese drei jetzt als Attrappen mit. Mit `--lang` gibt er die Marken
sogar aus. Gegengeprobe am 12.10.2026: mit Patch **10 Fälle, 0 Abweichungen**,
mit `--vorschlag` erwartungsgemäß 6 Abweichungen.

## Was dieser Patch **nicht** tut

- Er behebt nichts. Er macht nur sichtbar — auch die Marken 8 und 9 der
  IMAP-Seite melden nur.
- Die IMAP-Marken 4 bis 9 sind **nicht übersetzt**, siehe die Tabelle ganz oben.
