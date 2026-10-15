---
name: funktion-bringt-ihre-vorbedingung-mit
description: "Wer eine bewaehrte Funktion in einen neuen Weg einbaut, uebernimmt ihre Vorbedingungen und Nebenwirkungen - ISOTranslate nullt ein Byte hinter dem Bereich"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
---

Schranke: tools/pruefe-testbau.pl (pre-push) haelt die Testsammlung baubar; die eigentliche Pruefung ist `Test_ChunkLaesstDasByteDahinterInRuhe` in `Eudora71/Tests/TestIsoTranslate.cpp` - ein Waechterbyte hinter dem uebersetzten Stueck muss unveraendert bleiben. Gegenprobe umgedreht: geprueft wird nicht, ob das Ergebnis stimmt, sondern ob der falsche Wert durchkommt. Dazu seit 15.10.2026 der Hinweis tools/pruefe-kennung-suche.pl (pre-commit) fuer jede neue Suche ueber eine Nachrichtenkennung, siehe Nachtrag.

# Die Nebenwirkung wandert mit

Bei der Behebung von E-85 (Umlaute ueber IMAP) lautete die Anweisung aus
NP3-8, im IMAP-Weg **denselben Aufruf** zu verwenden wie im schon
funktionierenden POP3-Weg. Genau das habe ich getan — und damit eine
Regression eingebaut, die **jede Zeile jeder IMAP-Nachricht** verstuemmelt
haette.

## Was die Funktion mitbrachte

`ISOTranslate` schreibt eine Null an `szBuf[lSize]` — **ein Byte hinter** den
uebergebenen Bereich.

| Weg | wo das Byte hinter dem Bereich liegt | Folge |
|---|---|---|
| POP3 | dafuer ist Platz reserviert | harmlos, seit Jahren |
| IMAP | `CChunkReader` gibt bei `text/plain` eine **Zeile aus der Mitte** seines eigenen Puffers heraus (`imapgets.cpp`, `*pBuf = m_pStart`) | das Byte dahinter ist das **erste Zeichen der naechsten Zeile** |

Ohne Behebung haette jede IMAP-Nachricht mit `text/plain; charset=utf-8` in
**jeder Zeile das erste Zeichen verloren**, und ein NUL-Byte waere in der
Mailboxdatei gelandet.

Die Funktion war nicht falsch. Sie war richtig **fuer ihren Weg**. Falsch war
die Annahme, dass „derselbe Aufruf" auch dieselbe Umgebung bedeutet.

## Gefunden hat es der PRUEFER, vor der Auslieferung

Das ist die zweite Haelfte dieses Befunds und die gute. Der Fehler stand im
Zweig, das Paket war in Vorbereitung, und die Rolle PRUEFER hat ihn als
`PRUEFER-10` gemeldet, bevor Gregor es in die Hand bekam. Es ist der bislang
klarste Beleg dafuer, dass die Rolle nicht Verwaltung ist, sondern die
Verteidigungslinie, hinter der sonst nur noch Gregor steht
([[lehren-anwenden-nicht-nur-schreiben]], Bilanz vom 11.09.2026:
*„kein einziger Mangel, fuer den es eine Pruefung gab, hat es bis zu Gregor
geschafft"*).

Der Befund ist danach in einen Test gewandert, statt nur in eine
Commit-Nachricht: `Test_ChunkLaesstDasByteDahinterInRuhe` stellt einen Puffer
mit **zwei** Zeilen nach, uebersetzt nur die erste und prueft, ob das
Waechterbyte `'X'` am Anfang der zweiten Zeile `'X'` geblieben ist. Ohne die
Rettung steht dort `0x00` ([[gegenprobe-umdrehen]],
[[fehlerklassen-abstellen]]).

**Why:** Eine Funktion aus einem funktionierenden Weg zu uebernehmen fuehlt
sich wie das Gegenteil von Risiko an — sie ist ja erprobt. Genau das macht
sie gefaehrlich: **erprobt ist sie unter den Vorbedingungen ihres alten
Aufrufers**, und die stehen nirgends geschrieben. Hier war es die stille
Zusage „hinter dem Puffer ist ein Byte frei". Der alte Aufrufer hielt sie
ein, ohne es zu sagen; der neue konnte sie gar nicht einhalten, weil er den
Puffer nicht besitzt. Dieselbe Klasse wie bei einer gemeinsam benutzten
Kopfdatei ([[gemeinsame-dateien-gegen-alles-messen]]) und bei einem nur
teilweise ersetzten Header ([[teilweise-ersetzte-header]]): der Fehler
entsteht nicht in dem, was geaendert wurde, sondern an der Nahtstelle.

## Wie anwenden

1. **Ein neuer Aufrufer einer bestehenden Funktion ist eine Aenderung an der
   Funktion**, auch wenn keine ihrer Zeilen angefasst wurde. Er wird so
   behandelt: gelesen, gemessen, getestet.
2. **Vor dem Einbau wird der Rumpf auf drei Fragen gelesen:** Schreibt er
   ausserhalb des uebergebenen Bereichs? Erwartet er eine bestimmte Laenge,
   Ausrichtung oder Terminierung? Veraendert er seine Eingabe an Ort und
   Stelle? Jede Ja-Antwort ist eine Vorbedingung, die der neue Aufrufer
   erfuellen muss — oder er darf die Funktion nicht direkt aufrufen.
3. **Wem der Puffer gehoert, entscheidet.** Im POP3-Weg gehoerte der Puffer
   dem Aufrufer, im IMAP-Weg zeigt er in den Puffer eines anderen. Diese
   Frage steht vor jedem `memcpy`, jedem Nullsetzen und jedem `szBuf[n]`.
4. **Die Vorbedingung wird nicht in einen Kommentar geschrieben, sondern in
   einen Test mit Waechterbyte.** Ein Kommentar wird beim naechsten neuen
   Aufrufer wieder nicht gelesen — der Test laeuft.
5. **Wenn ein Befund eine Handlungsanweisung mitliefert („denselben Aufruf
   verwenden wie …"), gilt sie fuer die Absicht, nicht fuer den Wortlaut.**
   Die Anweisung aus NP3-8 war richtig; was sie nicht nennen konnte, war die
   Umgebung des neuen Aufrufers ([[bestand-vor-neuer-suche]]).

Siehe ausserdem [[assert-ist-im-release-nichts]] — auch dort haette der
Schaden im Debug-Bau gemeldet und im Release geschwiegen —, sowie
[[mannschaft-fuehren]] und [[pruefstand-kann-blind-sein]] zur Rolle, die
diesen Fehler gefunden hat.

## Nachtrag 15.10.2026 (CHRONIST): die Kennung gilt nur in ihrem Namensraum

In [E-121](../BEFUNDE.md#e-121) hat eine übernommene Suche dreimal dieselbe
Vorbedingung verletzt. `GetSummaryFromUID(pSum->GetHash())` findet „die“
Nachricht mit einer Kennung. In einem IMAP-Ordner ist `m_Hash` die
**Server-UID** — eindeutig, weil der Server sie vergibt. Die Vorab-Kopie einer
lokal verschobenen Nachricht trägt aber ihre **lokale** Kennung, und die ist
weder eindeutig noch von jeder UID verschieden:

| wann | Kennung | was passiert wäre / ist |
|---|---|---|
| PRÜFER-28 P1, 14.10. | 0 (alle Nachrichten aus `Out`) | die erste Nachricht mit 0 — eine **fremde** — wäre aus der Quelle gelöscht worden |
| 1.0.95, 15.10. | 13, alte UID aus einem früheren IMAP-Abruf | traf UID 13 einer fremden Mail im Ziel; Gregor sah *„Attempt to add the message to mailbox Inbox failed“* |
| N1, offen | wie oben, auf der Quellseite | ein Namensvetter mit gleicher Kennung kann entfernt werden |

Das Muster kam aus `ImapCopyMsgBetweenAccounts` (15.10., 05:44 UTC: *„Ich
übernehme das Muster“*). Dort sind beide Seiten IMAP-Ordner, und die
Vorbedingung gilt. Im Weg lokal → IMAP gilt sie nicht. Die Zeile, die den Fall
1.0.95 auslöste, stand schon in `8008f96e` (1.0.91), drei Pakete vorher:
`pTargetToc->GetSummaryFromUID(pSum->GetHash())`. Die Klasse war am 14.10.
durch P1 bekannt und wurde an der nächsten Stelle wieder geschrieben.

**Vor jeder Suche über eine Kennung drei Fragen:**

1. Wer vergibt sie — der Server (UID) oder Eudora lokal (`m_Hash`)?
2. In welchem Behälter ist sie eindeutig — und wird **genau dort** gesucht?
3. Kann ein anderer Vergeber im selben Behälter denselben Wert haben (0 aus
   `Out`, alte UID aus einem früheren Abruf)?

Die Behebung in 1.0.96 ist die allgemeine Form: ein **Merkzeichen an der
eigenen Kopie** (`IstE121Vorab`) statt einer Suche über einen fremden
Schlüssel. N1 lässt sich nach demselben Prinzip schließen.

**Schranke dazu:** `tools/pruefe-kennung-suche.pl` meldet im pre-commit jede
neu geschriebene Suche über eine Nachrichtenkennung im Eudora-Quelltext
(`GetSummaryFromUID(`, `GetHash() ==`), mit den drei Fragen — als Hinweis,
nicht als Abweisung. Gemessen an den letzten 300 Commits unter `Eudora71/`
hätte er 6-mal angeschlagen, alle zu E-121, darunter `8008f96e`. Gegenprobe:
`--selbsttest`, 8 Fälle in beide Richtungen, Kommentare und Protokolltexte
bleiben still ([[schranke-liest-nur-code]]).
