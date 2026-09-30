# Patch: gefaltete Dateinamen im Anhang

**Datei:** `anhangnamen-faltung.patch`
**Betrifft:** vier Dateien, zwei Zweige —
`Eudora71/Eudora/lex822.cpp`, `Eudora71/Eudora/header.cpp` (POP),
`Eudora71/EuImap/src/ImapLex822.cpp`, `Eudora71/EuImap/src/ImapHeader.cpp` (IMAP)
**Befund:** **AN-1**, erster Teil
**Stand:** **nicht angewandt** — bereitgelegt, weil in dieser Sitzung kein
Compiler zur Verfügung stand (Android, kein Windows, kein MSVC)

> **Was an diesem Patch gemessen ist und was nicht**
>
> Gemessen: der Zerleger. `tools/kopfzeile-pruefen.pl` fährt `Lex822()` mit
> `g++` außerhalb von Eudora, mit und ohne diesen Patch, über zehn Fälle. Die
> Tabelle unten ist aus diesen Läufen, nicht geschätzt.
>
> Nicht gemessen: das übersetzte Programm. Es ist **nichts mit MSVC gebaut und
> nichts gestartet worden**. Was `g++ -fsyntax-only` über die vier eingefügten
> Blöcke sagen kann, ist geprüft (fehlerfrei, ohne Warnung) — mehr nicht.
>
> **Es gibt keine Beispielnachricht**, und es wird keine geben. Der Fehler ist
> im Betrieb aufgefallen („immer wieder Dateien im Attachment, bei denen die
> Endung fehlt und der Dateiname nicht vollständig ist"). Dieser Patch ist aus
> dem Quelltext heraus begründet und am Zerleger gemessen; er braucht kein
> Beweisstück, und auf eines zu warten hieße, den Fehler liegen zu lassen.

---

## Was heute passiert

`Lex822()` beendet eine Zeichenkette in Anführungszeichen am CR
(`lex822.cpp:303`). Die Faltungsregel zehn Zeilen höher (`:213`) prüft das
**LF** — im Datenstrom kommt aber zuerst das **CR**, sie greift also nie:

```c
// Is this a folded CRLF?
if (charClass == LF822 && (nextClass == SPACE822 || nextClass == HTAB822))
	charClass = SPACE822;   // treat it like a space
```

Nach RFC 5322 2.2.3 gehört alles nach `CRLF` + Leerzeichen/Tabulator noch zur
selben Kopfzeile. Genau so falten Exchange, Zimbra, JavaMail und die meisten
PHP-Versandskripte lange `filename=`-Parameter:

```
Content-Disposition: attachment;
	filename="Angebot Nr 4711 fuer die Stadtwerke Musterstadt
 Abrechnungszeitraum 2025.pdf"
```

Eudora bekommt daraus `Angebot Nr 4711 fuer die Stadtwerke Musterstadt` —
47 statt 76 Zeichen, **ohne `.pdf`**. Der Rest landet im Zustand `ExpectSem`,
setzt `grokked = FALSE` und wird als unstrukturierter Text weggeworfen.

## Warum die Behebung drei Stellen braucht

Der naheliegende Eingriff — das CR einfach überspringen — geht nicht, und zwar
aus zwei Gründen, die beide gemessen sind:

**Erstens ist am CR noch nicht zu erkennen, ob eine Faltung folgt.**
`LineReader::ReadLine` liefert die Zeile **einschließlich** CRLF; steht `Spot`
auf dem CR, ist das LF das letzte Byte im Puffer und das Zeichen danach noch
gar nicht gelesen. Erst wenn `Spot` auf dem LF steht, füllt `LexFill()` nach —
und hebt dabei genau ein Byte auf. Deshalb steht die Faltungsregel am LF und
nicht am CR. Der Patch macht es wie `CollectText` seit jeher: er **nimmt das CR
in die Marke auf** und entscheidet am LF.

**Zweitens schreibt `WriteHeaderToken` jede Marke in die Mailbox-Datei**
(`lex822.cpp:402`), eine `QText`-Marke dabei in Anführungszeichen. Was der
Zerleger verschluckt, fehlt in der gespeicherten Nachricht. Weil das CR und das
LF nun in der Marke stehen, ist der Rückschrieb **byteidentisch** zu dem, was
auf der Leitung ankam — die gespeicherte Nachricht wird nicht angefasst.

Das ist zugleich der Grund, warum der Wert **nicht** im Zerleger entfaltet
werden darf: dort würde die Entfaltung mitgeschrieben. Sie gehört eine Ebene
höher, in `HeaderDesc::AddAttribute` (`header.cpp:476`) — der Rückschrieb ist
da schon passiert.

## Die drei Teile

| # | Datei | Was |
|---|---|---|
| 1 | `lex822.cpp` `CollectQText` | `case CR822:` nimmt das CR in die Marke, wenn `InStructure` gesetzt ist und ein LF folgt. Neues `case LF822:` beendet die Marke, wenn die Faltungsregel den Umbruch **nicht** zu `SPACE822` gemacht hat — also bei einer unbeendeten Zeichenkette. Die Prüfung auf `charClass == CR822` ist nötig, weil `case QUOTE822:` hierher **durchfällt**. |
| 2 | `lex822.cpp` `WriteHeaderToken` | Ein CR am Ende der Marke kommt aus einer unbeendeten Zeichenkette und wird **hinter** das schließende Anführungszeichen geschrieben. Ohne diesen Teil verlöre die Mailbox-Datei in diesem Fall ein CR (gemessen: 91 statt 92 Byte). |
| 3 | `header.cpp` `AddAttribute` | Macht aus `CRLF` + Leerzeichen/Tabulator ein einzelnes Leerzeichen (RFC 5322 3.2.2) und schneidet ein CR am Ende ab. Fester Puffer, kein `CString`, kein `GetBuffer` — das ist bewusst so, siehe R-1. |

**Und jeder dieser Teile steckt zweimal im Baum.** `EuImap/src/ImapLex822.cpp`
und `ImapHeader.cpp` sind Abschriften desselben Zerlegers, mit `m_`-Präfixen.
Der Patch ändert beide Zweige. Wer nur einen ändert, bekommt einen Fehler, der
von der Kontenart abhängt — das ist schlimmer als der Fehler selbst.

## Was gemessen ist

`perl tools/kopfzeile-pruefen.pl` bzw. `--vorschlag`, zehn Fälle:

| Fall | ohne Patch | mit Patch |
|---|---|---|
| ungefaltet, kurz | heil, Rückschrieb byteidentisch | **unverändert** |
| **gefaltet (der gemeldete Fehler)** | 47 Zeichen, Endung fehlt, `grokked=FALSE`, Rückschrieb 129/128 Byte | **76 Zeichen, `.pdf` da, `grokked=TRUE`, Rückschrieb byteidentisch** |
| derselbe Name ungefaltet | heil | **unverändert** |
| 300 Zeichen ungefaltet | 254 Zeichen, Endung fehlt | unverändert — dafür ist Teil 2 von AN-1 zuständig |
| RFC 2231 | kein Attribut | unverändert — Teil 3 von AN-1 |
| R1 Anführungszeichen, dann weitere Kopfzeile | byteidentisch | **unverändert** |
| R2 unbeendete Zeichenkette | Wert `ohne Ende`, Rückschrieb 92/91 | **unverändert, 92/91** |
| R3 Faltung außerhalb der Anführungszeichen | heil | **unverändert** |
| **R4 Faltung mit Tabulator** | 35 Zeichen, Endung fehlt | **56 Zeichen, vollständig** |
| R5 `filename=""` | Wert `=` | unverändert — Teil 4 von AN-1 |

Drei Dinge daran sind wichtiger als der Rest:

1. **Kein Fall wird schlechter.** Die fünf Rückfallproben R1 bis R5 sind
   entweder byteidentisch wie vorher oder unverändert kaputt.
2. **R2 bleibt genau wie heute** — 92 von 91 Byte, also mit derselben
   Abweichung. Das ist der Zweck von Teil 2 des Patches; ohne ihn wären es
   91 Byte und die Mailbox-Datei hätte ein LF ohne CR.
3. **Der Rückschrieb im behobenen Fall ist byteidentisch** (128 von 128 Byte).
   Heute ist er es nicht (129 von 128) — die kaputte Zerlegung schreibt ein
   Anführungszeichen zu viel in die Mailbox. Der Patch behebt das mit.

## Nach dem Einspielen zu tun

1. `perl tools/kopfzeile-pruefen.pl` — das Werkzeug erkennt am Markierungssatz
   im Patch, dass die Behebung im Baum steht, und bildet dann auch das
   geänderte `WriteHeaderToken` nach. Es meldet **6 Abweichungen**: das sind
   die behobenen Fälle. **Dann ist die Spalte `stand` im Werkzeug
   nachzuziehen** — sonst meldet es die eigene Behebung für immer als Schaden.
2. `--vorschlag` bricht danach ab („der Suchtext passt nicht mehr"). Das ist
   kein Fehler, sondern die Absicht: die Option ist dann überflüssig.
3. **Mit Visual Studio bauen und eine echte Nachricht abrufen.** Der Prüfstand
   fährt den Zerleger, nicht Eudora. Ungeprüft bleibt alles, was `JJFile`,
   `CTLMime` und der Weg bis `OpenAttachFile` tun.
4. Einen Testfall in `Eudora71/Tests/TestPopEmpfang.cpp` nachziehen —
   dort liegt schon das Gerüst für den Empfangspfad.

## Was der Patch **nicht** tut

- Er behebt **nur den ersten** Teil von AN-1. Die 254-Zeichen-Grenze, RFC 2231
  und `filename=""` bleiben offen; sie stehen in `AUFGABEN.md`, Punkt B5.
- Er fasst `DeMacifyName32` nicht an (ein Byte über den Pufferrand,
  `mime.cpp:948` und `EuImap/src/imapmime.cpp:82`).
- `Fix2047` bleibt zeilenweise. Ein RFC-2047-Wort, das über eine Faltung geht,
  wird weiterhin nicht zusammengesetzt.
