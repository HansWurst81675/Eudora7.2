# <a id="pruefer-83"></a>PRUEFER-83

Lauf nach [PRUEFER-82](PRUEFER-82.md#pruefer-82), geprüft: `90807904..HEAD -- Eudora71 tools Releases/1.0` (f950fd66, 509e7caf, 3c1f5948; dazu der Merge fda44d5e), Zweig wt/pruefer-20261102c (von `origin/e122_imap_datum`). Schwerpunkt [E-122](../Intern/BEFUNDE.md#e-122): `CImapAppend::ReformatHeader` / `E122DatumAlsUtc` in `ImapAppend.cpp`, der Test `TestE122.cpp`, das Messskript `messen-e122.ps1` und der neue TESTPLAN-Schritt. Eudora nicht gebaut und nicht gestartet; die Prüfstände `C:\Temp\E122` und `C:\Temp\E122-alt` nur gelesen.

## Ergebnis vorweg

Die Behebung stimmt für den Normalfall. Eine Mail, die man aus einem lokalen Postfach in einen IMAP-Ordner überträgt, bekommt jetzt das richtige Eingangsdatum, im Winter wie im Sommer und für jede Absenderzone. Das zeigen das Protokoll des Prüfstands und ein Nachbau der Rechnung mit derselben Laufzeitbibliothek.

Es gibt eine Ausnahme. Fällt die Uhrzeit im `Date:`-Kopf in die Stunde, die beim Umstellen auf Sommerzeit auf **diesem** Rechner übersprungen wird (letzter Märzsonntag, 02:00–02:59 Ortszeit), liegt das Eingangsdatum eine Stunde zu früh. Das ist selten und klein (K1).

Schwerer wiegt der Test: Er bleibt grün, wenn man in `E122DatumAlsUtc` ein einziges Wort tauscht (`localtime` gegen `gmtime`) und damit den alten Fehler genau wiederherstellt. Ebenso bleibt er grün, wenn das Ergebnis gar nicht mehr nach `m_Seconds` geschrieben wird (K2). Dazu kommen zwei Randfälle: ein `Date:`-Kopf ohne Zone und mehrere `Date:`-Köpfe (K3). Außerdem kann Gregors TESTPLAN-Schritt blind sein, wenn sein Webmailer den `Date:`-Kopf statt des Eingangsdatums anzeigt (K4).

Für das Paket: Keiner der Funde hält es auf. K2 sollte vor dem Merge erledigt werden, weil die Schranke sonst den Rückfall nicht meldet. K4 sollte vor Gregors Test berichtigt werden.

## 1. Die Behebung am Quelltext

- **Rechnung.** `E122DatumAlsUtc` (ImapAppend.cpp:1039-1061) ruft `GetTimeMT(Wert, FALSE)`. Diese Funktion liest die Felder mit `mktime` und `tm_isdst = -1` als Ortszeit (services.cpp:2160-2274, `mktime` bei :2268). `localtime` holt aus dem Ergebnis die Felder zurück, `_mkgmtime` liest sie als UTC, und `FormatDateMT` zieht die Absenderzone ab (services.cpp:2021-2083, `lSeconds -= nTimeZoneMinutes * 60` bei :2081). Das Ergebnis ist „Felder als UTC minus Absenderzone“, also echtes UTC. Am Quelltext belegt. Die Rückrechnung über `localtime` ist nur außerhalb der Sommerzeitlücke verlustfrei (K1).
- **Vorher.** `CSummary` setzt `m_Seconds = GetTime(Zeile + 5)` und danach `FormatDate(Zeile)` (summary.cpp:2256-2264, 2978-2989). Das ergibt „Felder als Ortszeit minus Absenderzone“, also UTC minus die Ortszone **am Tag der Mail**. Am Quelltext belegt. Im Nachbau gemessen: −60 min im November und −120 min für eine Mail vom Juli, unabhängig vom heutigen Datum.
- **Gesendete Nachrichten.** `ComposeDate` (sendmail.cpp:643-668) schreibt den `Date:`-Kopf aus demselben UTC und der Zone `-GetGMTOffset()` und setzt `m_Seconds` auf echtes UTC. Die neue Rechnung liest diesen Kopf und kommt sekundengenau auf denselben Wert zurück. Das gilt auch, wenn eine INI-Zone von der Windows-Zone abweicht, weil die Absenderzone aus dem Kopf genommen wird. Am Quelltext belegt.
- **Fehlender oder unlesbarer Date-Kopf.** Fehlt der Kopf, wird `E122DatumAusKopf` nicht gerufen. Der Kopf wird wie vorher aus `m_Seconds` erzeugt (:1272-1290), unverändert. Ist der Kopf unlesbar, liefert `GetTimeMT` 0, `E122DatumAlsUtc` gibt 0 zurück und `m_Seconds` bleibt (:1046-1047, :1076-1077). Dasselbe gilt für ein Datum vor 1970: `mktime` liefert −1, `GetTimeMT` gibt 0. Am Quelltext belegt.
- **Fortsetzungszeilen.** Beide Aufrufe (:1191, :1244) bekommen nur die erste physische Zeile, `len` endet am ersten `\r`/`\n`. Steht das Datum ganz in einer Folgezeile, ist der Wert unlesbar und `m_Seconds` bleibt. Steht nur die Zone in der Folgezeile, siehe K3. Die alte Rechnung in `CSummary` las ebenfalls nur die erste Zeile (summary.cpp:2256), insofern nichts Neues. Am Quelltext belegt.
- **Zeile ohne Zeilenende** (Kopf ohne Rumpf, :1176-1194): `len = strlen(t)` und derselbe Aufruf. Belegt.
- **Abstreifen.** `FormatDateMT` kopiert den Wert, entfernt Kommentare in Klammern und schneidet Leerraum an den Enden ab (`StripAddressMT` → `TrimWhitespaceMT`). Ein angehängtes `\r\n` oder ein Leerzeichen hinter der Zone stört also nicht. Belegt.
- **AppendMessageAcrossRemotes** (IMAP→IMAP ohne COPY, ImapAppend.cpp:1721ff.) spoolt nicht und ruft `ReformatHeader` nicht. `m_Seconds` geht dort weiter unverändert aus `pSum->m_Seconds` (ImapMailbox.cpp:4431) an `AppendMessage` (:1771). Der Weg ist wie angekündigt unverändert und trägt den alten Versatz weiter. Für IMAP-Summaries setzt `ImapDownload.cpp:6123` `m_Seconds = GetTime(pEnv->date)`. Am Quelltext belegt. Er steht im Commit als „nicht geändert“; ob er im E-122-Eintrag als offener Rest geführt wird, habe ich nicht nachgesehen.
- **Nebenwirkung Message-ID.** `NewMessageID` (:1785ff.) nimmt `m_Seconds` in die erzeugte Kennung. Diese ist jetzt um die Ortszone anders. Das ist ohne Bedeutung (vgl. Entscheidung „Message-ID: kein Befund“). Belegt.

## 2. Nachbau der Rechnung (gemessen)

Kleines Konsolenprogramm (VS 2022, Win32, UCRT, Rechnerzone *W. Europe Standard Time*) im Scratchpad. Es baut `GetTimeMT` (`mktime`, `tm_isdst = -1`), `E122DatumAlsUtc` (`localtime` → `_mkgmtime`) und den numerischen Teil von `FormatDateMT` nach. Die Spalten zeigen die Abweichung vom richtigen UTC:

| Date-Kopf | vorher | neu |
|---|---|---|
| 02.11.2026 09:10 +0200 | −60 min | 0 |
| 01.07.2026 09:10 +0200 | −120 min | 0 |
| 01.07.2026 09:10 −0500 | −120 min | 0 |
| 29.03.2026 01:59 +0000 | −60 min | 0 |
| **29.03.2026 02:00 +0000 (Lücke)** | −120 min | **−60 min** |
| **29.03.2026 02:30 +0300 (Lücke)** | −120 min | **−60 min** |
| 29.03.2026 03:00 +0000 | −120 min | 0 |
| 25.10.2026 02:30 +0000 (doppelte Stunde) | −60 min | 0 |

Es ist ein Nachbau, nicht das Programm. Die Funktionen sind abgeschrieben, nicht gelinkt.

## 3. Testsuite und Gegenproben (in meinem Baum)

Gemessen, `cmd /c Eudora71\Tests\RunTests.cmd`:

| Lauf | Änderung (vorübergehend, ImapAppend.cpp) | Ergebnis |
|---|---|---|
| 1 | keine | 362/362 |
| G1 | `localtime( &tOrt )` → `gmtime( &tOrt )` (stellt den alten Fehler genau wieder her) | **362/362, grün** (K2) |
| G2 | `m_Seconds = (unsigned long) lUtc;` entfernt (Behebung wirkungslos) | **362/362, grün** (K2) |
| G3 | Zeile `FormatDateMT( pszWert, lUtc, nZoneMinuten );` entfernt | 361/362, rot `E-122 (Quelltext)`, *„die Zone des Absenders wird nicht mehr abgezogen“*. Positivprobe: der Test lebt. |

Nach jedem Lauf zurückkopiert; `cmp` gegen die Sicherung ergab keinen Unterschied, `git status` war leer.

## 4. Messskript und Prüfstand

- **Trifft es den Weg?** Ja. `C:\Temp\E122\Mailverzeichnis\eudora.log` enthält zwei Zeilen `E-122 IMAP-Eingangsdatum aus Date:-Kopf: utc=1793603400 vorher=1793599800 uebernommen` und `utc=1793628600 vorher=1793625000`. Das sind 07:10 und 14:10 UTC, beide Male eine Stunde mehr als vorher. `imap-e122.log` zeigt `APPEND Ablage () "02-Nov-2026 08:10:00 +0100"` und `"15:10:00 +0100"`. `C:\Temp\E122-alt\imap-e122.log` zeigt `07:10` und `14:10`, ohne E-122-Zeile im Protokoll. Gemessen (vom Hauptagenten, von mir nachgelesen).
- **Gegenprobe haltbar?** Ja. Die Prüfung vergleicht den Zeitpunkt der APPEND-Zeile mit dem `Date:`-Kopf der hochgeladenen Datei, nicht mit einer festen Erwartung. Die zwei Absenderzonen schließen einen Zufallstreffer aus. Der alte Bau ist mit `verschoben=2` rot. Belegt am Skript (`AlsZeit`, Auswertung Schritt 5).
- **Was es nicht misst:** nur ein Datum im November. Der Sommerfall (alter Fehler −120 min) und die Lücke aus K1 sind nur im Nachbau gemessen, nicht am Programm. Ebenso wenig misst es eine gesendete Nachricht aus *Sent* (dort war `m_Seconds` schon echtes UTC). Das ist kein Fund, nur der Umfang.
- **Zuordnung APPEND ↔ Datei** über die Reihenfolge (`append-001`, `-002`). Bei zwei Nachrichten mit gleichem Kopf-Datum würde ein Vertauschen nicht auffallen, hier haben sie verschiedene Zonen. Kein Fund.
- Der Bau trägt `6c95e284*`, der Stern bedeutet einen geänderten Arbeitsbaum. Die Commit-Nachricht nennt den Quellstand f950fd66. Ich habe nicht nachgeprüft, dass der Bau genau diesen Stand enthielt. Die Logzeile zeigt aber, dass die Behebung drin war.

## 5. Funde

### K1: Sommerzeitlücke des Rechners: eine Stunde zu früh

Fällt die Wanduhrzeit des `Date:`-Kopfs in die Stunde, die in der Rechnerzone beim Umstellen auf Sommerzeit nicht existiert (in Mitteleuropa am letzten Märzsonntag 02:00–02:59), schiebt `mktime` sie auf 01:xx zurück. `localtime` liefert dann 01:xx statt 02:xx, und das Ergebnis liegt 60 min zu früh. Die Absenderzone spielt dabei keine Rolle. Der Nachbau hat das gemessen (Tabelle in Abschnitt 2), am Programm ist es nicht gemessen. Vorher lag dieselbe Mail 120 min daneben, es ist also keine Verschlechterung, nur ein Rest.

Behebung: die Felder nicht über `mktime`/`localtime` zurückholen, sondern direkt in eine `struct tm` lesen und `_mkgmtime` geben. Das geht etwa über eine Variante von `GetTimeMT`, die die `struct tm` herausgibt, oder über einen eigenen `sscanf` mit denselben Formaten (`IDS_SCAN_DATE_2`/`_3`). Ein Verhaltenstest mit 29.03. 02:30 würde K1 und K2 zugleich abdecken. **Schwere: gering.**

### K2: Test bleibt grün, wenn der alte Fehler zurückkommt

`Test_E122_Stelle` prüft nur, dass `_mkgmtime( &Felder )` und `FormatDateMT(…)` vorkommen und `mktime(` nicht. Gegenprobe G1 tauscht `localtime` gegen `gmtime`. Die Felder sind dann die UTC-Felder des Ortszeit-Werts, und das Ergebnis ist genau der alte Wert (UTC minus Ortszone). Der Test ist grün. G2 entfernt die Zuweisung an `m_Seconds`, und der Test ist ebenfalls grün. Beides gemessen.

Vorschlag: zusätzlich `localtime( &tOrt )` und `m_Seconds = (unsigned long) lUtc;` im Abschnitt verlangen. Besser wäre ein Verhaltenstest gegen eine echte Zeitangabe (Rechnerzone setzen oder den Versatz aus `GetTimeZoneInformation` einrechnen). `E122DatumAlsUtc` ist `static` und von der Suite aus nicht aufrufbar; ob sich `QCUtils` in die Suite linken lässt, habe ich nicht geprüft (Vermutung: ja, `GetTimeMT` braucht aber die Stringressourcen `IDS_MONTHS`/`IDS_SCAN_DATE_*`). **Schwere: mittel** (die Schranke schützt die Behebung nicht).

### K3: Randfälle Date-Kopf ohne Zone und mehrere Date-Köpfe

- **Ohne Zone**, oder die Zone steht in einer Folgezeile (`Date: Mon, 02 Nov 2026 09:10:00` + `\r\n +0200`): `FormatDateMT` findet keine Zone (services.cpp:2034-2040) und zieht nichts ab. Neu gilt die Uhrzeit damit als UTC, vorher als Ortszeit des Rechners. Ein Kopf `09:10` ohne Zone kommt jetzt als 10:10 MEZ an statt 09:10. RFC 5322 behandelt fehlende oder unbekannte Zonen wie `-0000`, also wie UTC. Die neue Lesart ist damit vertretbar, für Gregor aber sichtbar anders. Unbekannte Buchstabenzonen (`atoi` → 0) verhalten sich genauso. Am Quelltext belegt, im Nachbau gemessen.
- **Mehrere `Date:`-Köpfe**: Jeder Treffer ruft `E122DatumAusKopf`, und der **letzte** gewinnt. `CSummary` nimmt den **ersten** (`!*m_Date`, summary.cpp:2256). Spalte *Date* in Eudora und Eingangsdatum am Server können dann auseinanderfallen. Am Quelltext belegt, nicht gemessen. Vorschlag: nur beim ersten Treffer setzen (`if (!bDateHeaderFound)` vor dem Setzen prüfen).

**Schwere: gering.**

### K4: TESTPLAN-Schritt kann blind sein

Schritt 3 von „Mit dem nächsten Paket: Eingangsdatum …“ (TESTPLAN.md:343ff.) lässt im Webmailer „das angezeigte Datum“ mit der Uhrzeit vergleichen. Viele Webmailer zeigen in Liste und Ansicht den `Date:`-Kopf, nicht das Eingangsdatum (INTERNALDATE). Dann ist der Schritt auch mit dem alten Bau grün. Das ist eine Vermutung zum Verhalten von Gregors Webmailer, nicht gemessen.

Vorschlag: im Webmailer nach *Eingang* oder *Empfangen* sortieren oder diese Spalte zeigen lassen, oder eine Mail nehmen, deren Datum deutlich von ihren Nachbarn abweicht, und die Sortierposition prüfen. Nebenbei: „im Winter eine Stunde, im Sommer zwei“ hängt am Datum **der Mail**, nicht an der Jahreszeit des Tests (Nachbau: eine Juli-Mail liegt auch im November 120 min daneben). **Schwere: gering bis mittel** (Gregors einziger Test am echten Server).

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | Mail mit Uhrzeit in der übersprungenen Sommerzeitstunde des Rechners: Eingangsdatum 60 min zu früh (vorher 120) | gering | nein |
| K2 | Test bleibt grün bei `localtime`→`gmtime` (alter Fehler) und ohne Zuweisung an `m_Seconds` | mittel | nein, vor dem Merge nachschärfen |
| K3 | Date-Kopf ohne Zone gilt jetzt als UTC statt als Ortszeit; bei mehreren Date-Köpfen gewinnt der letzte statt der erste | gering | nein |
| K4 | TESTPLAN vergleicht mit dem Webmailer-Datum, das oft der `Date:`-Kopf ist: Schritt kann blind sein | gering bis mittel | nein, vor Gregors Test berichtigen |
