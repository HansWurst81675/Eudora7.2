# PRÜFER-13 — E-101 nachgerechnet: die Aufbereitung nimmt Text weg, der dem Anwender gehört

Stand: 17.09.2026, Zweig `e101-speichern-dateiformat`, geprüfter Commit
`a5cbf3c` („E-101: die gespeicherte Datei ist jetzt brauchbar (1.0.66)").

Gelesen wurden nicht nur der Diff, sondern ganz:
`E101SpeicherfassungAufbereiten` (`msgutils.cpp:3828-4049`),
`CTocView::OnFileSaveAs` (`tocview.cpp:3019-3210`), `JJFileMT::PutLine` und
`JJFileMT::Write_` (`QCUtils/src/jjfile.cpp:894-950`),
`CMessageDoc::GetFullMessage` (beide Fassungen, `msgdoc.cpp:197-389`),
`CReadMessageDoc::StripTabooHeaders` und `BuildTabooHeaderArray`
(`ReadMessageDoc.cpp:432-528`), `CReadMessageDoc::SaveAs`/`SaveAsFile`
(`ReadMessageDoc.cpp:531-627`), `CCompMessageDoc::SaveAsFile`
(`compmsgd.cpp:3399-3456`), `CSaveAs::PutText` (`saveas.cpp:144-153`),
`TextReader::ReadIt` (`TextReader.cpp:240-320`), `FindMIMECharset`
(`mime.cpp:382-402`), `ISOTranslate` (`utils.cpp:1439-1480`), der
Marker-Schutz beim Empfang (`mime.cpp:2150-2240`) und `TestE101.cpp` ganz.

---

## KURZANTWORT AUF FRAGE 1: JA. Inhalt geht verloren.

**Drei der zwölf konstruierten Fälle verlieren Text, den der Anwender
geschrieben oder empfangen hat — gemessen, nicht vermutet.** In einem davon
verschwinden 36 von 62 Byte. Der Verlust ist **nicht** auf Markergröße
begrenzt: die Funktion schneidet von `<x-html` bis zum **nächsten `>`
irgendwo im Text**, und in einer Klartextnachricht ist das nächste `>` das
Zitatzeichen der nächsten Zeile.

**Mein Urteil: 1.0.66 sollte in dieser Fassung nicht auf Gregors Rechner
gehen.** Der Ausgangszustand war eine unbrauchbare, aber **vollständige**
Datei. Jetzt ist sie brauchbar und in konstruierbaren Fällen **unvollständig**
— und niemand sieht es, weil die fehlenden Zeilen nicht als Lücke auffallen.
Das ist derselbe Tausch, den `Arbeitsweise/kein-paket-mit-offenem-datenverlust.md`
verbietet.

Die Behebung ist klein: die drei Stellen unten (P-18, P-19, P-21) sind
zusammen rund 25 Zeilen. Der Nutzen von E-101 bleibt dabei vollständig
erhalten — der Normalfall (Fall 10) läuft unverändert durch.

### Wie gemessen wurde

Nicht nachgebaut, nicht überschlagen: `Eudora71/Tests/Extract.ps1` hat die
**echte** Funktion aus `msgutils.cpp` geschnitten (Zeilen 3828..4049), ein
kleines Aufrufprogramm im Ablagepfad wurde mit MFC übersetzt und mit zwölf
Eingaben gefahren. Jede Ein- und Ausgabe wurde **byteweise** ausgegeben
(`<CR>`, `<LF>`, `<FC>`). Im Repo liegt davon nichts; die Fälle gehören nach
`TestE101.cpp` (P-27).

### Die Messung

| # | Eingabe | Byte vorher → nachher | Verlust? |
|---|---------|----------------------|----------|
| 1 | Empfangene Nachricht **mit** `Content-Type`, Rumpf zitiert `<x-html>` in einem `<pre>` | 164 → 156 | **JA**, 8 Byte Rumpftext, obwohl `content-type-vorhanden=1` |
| 2 | Klartext: `Eudora setzt <x-html an den Anfang. Du schriebst:` / `> das war mir neu` | 127 → 185 | **JA**, 31 Byte Rumpftext weg; dazu `text/html` für Klartext |
| 3 | Keine Leerzeile zwischen Kopf und Rumpf | 101 → 80 | nein (nur Marker), aber die Behebung greift nicht |
| 4a | Kopf CRLF, Rumpf LF | 113 → 193 | nein, richtig getrennt |
| 4b | Gemischter Trenner `\r\n` + `\n` | 128 → 208 | nein, aber verirrtes `\r` in der letzten Kopfzeile |
| 5 | Zwei `</x-html>`, das letzte im Text zitiert | 131 → 209 | **JA**, das **zitierte** wird entfernt, das **echte** bleibt in der Datei |
| 6 | `<x-html content-base="http://host/a>b/">` | 130 → 180 | Markerrest `b/">` bleibt als erste Rumpfzeile stehen |
| 7 | Eine führende Leerzeile | 58 → 37 | nein |
| 7b | Zwei führende Leerzeilen | 22 → 18 | **JA**, die Leerzeile verschwindet ersatzlos |
| 8 | UTF-8-Rumpf ohne `Content-Type` | 59 → 159 | nein, aber `charset="ISO-8859-1"` auf UTF-8-Bytes |
| 9 | Nur öffnender Marker | 62 → 149 | nein |
| 10 | Normalfall aus dem Commit | 106 → 184 | nein — **die Behebung tut, was sie soll** |
| 11 | Ohne Kopfzeilen, Rumpf zitiert `<x-html` | 62 → 26 | **JA**, 36 von 62 Byte weg |
| 12 | Kopf ohne Rumpf | 36 → 134 | nein |

Die vier belegten Verluste im Wortlaut:

* **Fall 11** (Haken *Kopfzeilen mitspeichern* aus):
  `Er schrieb <x-html in die Zeile. Du sagtest:<CR><LF>> stimmt<CR><LF>Ende`
  wird zu `Er schrieb  stimmt<CR><LF>Ende`.
* **Fall 2** (mit Kopfzeilen): `Eudora setzt <x-html an den Anfang. Du
  schriebst:<CR><LF>> das war mir neu` wird zu `Eudora setzt  das war mir neu`.
* **Fall 5**: `WICHTIGER NACHSATZ </x-html> ende` wird zu
  `WICHTIGER NACHSATZ  ende` — **und** das echte `</x-html>` steht danach noch
  in der Datei, die Behebung erreicht ihr eigenes Ziel also nicht.
* **Fall 1**: eine **empfangene** Nachricht, an der laut Kommentar *„nichts
  angetastet"* wird, verliert 8 Byte aus dem Rumpf. Die Spurmarke sagt dazu
  `content-type-vorhanden=1 geaendert=1` — das steht schon nebeneinander im
  Protokoll.

Und wie richtig es wäre: **der Marker steht, wenn überhaupt, als erste Zeile
des Rumpfs.** `etf2html.cpp:200` schreibt ihn dort, `TocFrame.cpp:1408`
(`szXHtmlTag.Format("<%s>\r\n", szXHtml)`) ebenfalls. Alles, was weiter hinten
im Rumpf so aussieht, ist Text des Anwenders. Gleiches am Ende: nur wenn hinter
`</x-html>` nichts als Leerraum steht, ist es das Gegenstück.

---

## Die Mängel im Einzelnen

### P-18 — DATENVERLUST: der Marker wird im ganzen Rumpf gesucht (`msgutils.cpp:3898-3916`)

```c
	const int	nAuf = szKlein.Find( "<x-html" );
	...
		const int	nZu = szRumpf.Find( '>', nAuf );
```

`Find` sucht überall, und `Find('>')` läuft über Zeilengrenzen. Damit hängt
die Länge des gelöschten Stücks davon ab, wann im Text das nächste `>` kommt
— in Klartextnachrichten ist das Zitatzeichen. Gemessen: Fall 2 und Fall 11.
Fall 1 zeigt dazu, dass dieser Schritt **vor** der Content-Type-Prüfung läuft
und deshalb auch empfangene Nachrichten trifft.

Richtig ist, nur die **erste Zeile** des Rumpfs anzusehen und sie nur dann zu
entfernen, wenn sie **ganz** aus dem Marker besteht. Das erledigt Fall 1,
Fall 2, Fall 6 und Fall 11 in einem:

```c
	//
	// Der Marker steht, wenn ueberhaupt, als ERSTE Zeile des Rumpfs -
	// etf2html.cpp:200 und TocFrame.cpp:1408 schreiben ihn genau dort.
	// Wer weiter hinten sucht, trifft den Text des Anwenders: gemessen
	// wurde "Er schrieb <x-html in die Zeile. Du sagtest:\r\n> stimmt",
	// woraus "Er schrieb  stimmt" wurde - 36 von 62 Byte weg.
	//
	if ( szKlein.Left( 7 ) == "<x-html" )
	{
		int			nZeile = szRumpf.Find( '\n' );
		const int	nBis   = ( nZeile < 0 ) ? szRumpf.GetLength() : nZeile + 1;

		CString		szErste = szRumpf.Left( nBis );

		while ( !szErste.IsEmpty() &&
				( szErste[szErste.GetLength()-1] == '\r' ||
				  szErste[szErste.GetLength()-1] == '\n' ) )
			szErste = szErste.Left( szErste.GetLength() - 1 );

		// Nur wenn die ganze Zeile der Marker ist. Ein > im Attributwert
		// (<x-html content-base="http://host/a>b/">) hoert damit auf,
		// einen Rest stehen zu lassen.
		if ( szErste.Right( 1 ) == ">" )
		{
			bWarHtml = true;
			szRumpf  = szRumpf.Mid( nBis );
		}
	}
```

### P-19 — DATENVERLUST: das Gegenstück wird als *letzter* Treffer gesucht (`msgutils.cpp:3920-3948`)

Die Rückwärtssuche nimmt das **letzte** `</x-html>` im Rumpf. Steht danach
noch Text (Fall 5), wird das zitierte entfernt und das echte bleibt stehen —
der Verlust und das Nichterreichen des Ziels in derselben Bewegung. Richtig:
den Fund nur annehmen, wenn dahinter nichts als Leerraum steht.

```c
			if ( nEnde >= 0 )
			{
				// Nur wenn hinter dem Fund nichts als Leerraum steht, ist es
				// das Gegenstueck. Sonst ist es zitierter Text: gemessen
				// wurde "WICHTIGER NACHSATZ </x-html> ende", woraus
				// "WICHTIGER NACHSATZ  ende" wurde, waehrend das echte
				// </x-html> in der Datei stehen blieb.
				bool	bNurLeerraum = true;

				for ( int k = nEnde + 9; k < szRumpf.GetLength(); k++ )
				{
					const char	c = szRumpf[k];
					if ( c != '\r' && c != '\n' && c != ' ' && c != '\t' )
					{
						bNurLeerraum = false;
						break;
					}
				}

				if ( bNurLeerraum )
				{
					...bisheriges Herausschneiden...
				}
			}
```

### P-20 — DATENVERLUST: die führende Leerzeile verschwindet (`msgutils.cpp:3875-3883` und `4011-4028`)

Beginnt der Text mit `\r\n\r\n`, ist `nKopfEnde == 0` und `nRumpfAb == 4`.
`szKopf` wird wegen `( nKopfEnde > 0 )` **leer**, und weil der Zusammenbau den
Trenner nur schreibt, wenn `szKopf` nicht leer ist, sind die vier Byte weg.
Gemessen: Fall 7b, 22 → 18 Byte.

```c
	//
	// Steht die Leerzeile ganz vorn, gibt es keinen Kopf - dann ist ALLES
	// Rumpf. Sonst faellt der Trenner beim Zusammenbau ersatzlos weg
	// (gemessen: "\r\n\r\nErste Rumpfzeile\r\n", 22 Byte rein, 18 raus).
	//
	if ( nRumpfAb < 0 || nKopfEnde <= 0 )
	{
		nKopfEnde = 0;
		nRumpfAb  = 0;
	}
```

### P-21 — verirrtes `\r` in der letzten Kopfzeile bei gemischtem Trenner (`msgutils.cpp:3868-3871`)

Lautet der Trenner `\r\n` + `\n`, greift der `"\n\n"`-Zweig und `szKopf` endet
auf einem einzelnen `\r`. Gemessen (Fall 4b): `Subject: gemischter
Trenner<CR><CR><LF>MIME-Version: 1.0`. Kein Verlust, aber eine Kopfzeile, die
kein Leser so erwartet. Abhilfe beim Zusammenbau:

```c
	// Ein gemischter Trenner (\r\n + \n) laesst ein einzelnes \r am Ende
	// des Kopfes stehen. Weg damit, sonst steht \r\r\n in der Datei.
	while ( !szKopf.IsEmpty() &&
			( szKopf[szKopf.GetLength()-1] == '\r' ||
			  szKopf[szKopf.GetLength()-1] == '\n' ) )
		szKopf = szKopf.Left( szKopf.GetLength() - 1 );
```

### P-22 — ohne Leerzeile zwischen Kopf und Rumpf greift die Behebung gar nicht, und die Spurmarke verschweigt es (`msgutils.cpp:3875-3879`, `4030-4046`)

Fall 3: kein Trenner gefunden → alles gilt als Rumpf → `szKopf` leer → keine
Kopfzeilen ergänzt. Die Datei bleibt unbrauchbar, die Spurmarke meldet aber
`kopfzeilen=1 ... geaendert=1` und liest sich wie ein Erfolg. Mindestens
gehört der Zustand in die Marke:

```c
		"E-101 speichern: kopfzeilen=%d trenner=%d xhtml=%d ..."
		bHatKopfzeilen ? 1 : 0,
		( nKopfEnde > 0 ) ? 1 : 0,
```

Sauberer wäre, das Kopfende in diesem Fall an der ersten Zeile zu suchen, die
nicht `Feldname:` oder Fortsetzung ist. Das ist mehr Arbeit und darf warten —
aber **stumm** darf es nicht bleiben.

### P-23 — die Gegenprobe im Test misst einen Weg, den es auf diesem Pfad nicht gibt (`TestE101.cpp:42-52`, `tocview.cpp:3138`, `EudoraRes.rc:9998`)

`kEmpfangen` bringt `Content-Type: text/html; charset=UTF-8` mit, und der Test
belegt, dass daran nichts geändert wird. Im **echten** Ablauf kommt eine
solche Zeile hier nie an: `tocview.cpp:3138` ruft für jede empfangene
Nachricht `StripTabooHeaders`, und die Vorgabeliste
(`IDS_INI_USER_TABOO_HEADERS`, `EudoraRes.rc:9998`) enthält `Mime-Version` und
`Content-` — beides wird per Präfixvergleich (`ReadMessageDoc.cpp:499`)
**entfernt**, bevor `E101SpeicherfassungAufbereiten` den Text sieht.

Folge: der Zweig *„vorhandene Content-Type-Zeile bleibt unangetastet"* ist auf
dem Speicherweg der Übersichtsliste praktisch **tot**, und **jede** empfangene
Nachricht bekommt einen aus den Bytes geratenen Zeichensatz. Das ist kein
Fehler der Funktion, aber der Kommentar (`msgutils.cpp:3824-3827`) und die
Commit-Nachricht behaupten etwas, das auf diesem Weg nicht eintritt. Der Test
gehört um den echten Fall ergänzt: **empfangene Nachricht nach dem
Taboo-Schnitt**, also ohne `Content-Type`.

### P-24 — fünf Kopien der Nachricht im Speicher (x86) (`tocview.cpp:3180-3195`, `msgutils.cpp` ganz)

Der alte Weg schrieb den `char*` unmittelbar in die Datei. Jetzt entstehen
nacheinander `szGanz`, `szAlles`, `szKopf`+`szRumpf`, `szKlein`, `szNeu` und
`szDatei`. Eudora ist ein 32-Bit-Prozess; bei einer sehr großen Nachricht
(Postfächer mit eingebetteten Anhängen) ist das ein Vielfaches des bisherigen
Bedarfs, und `CString` wirft bei Fehlschlag `CMemoryException` — in
`OnFileSaveAs` fängt sie niemand. Kein akuter Mangel, aber ein Punkt für den
Fall, dass jemand eine 40-MB-Nachricht sichert.

### P-25 — mehrere markierte Nachrichten ergeben jetzt **eine** scheinbar gültige Nachricht (`tocview.cpp:3094`, `3101`)

Kein Verlust (siehe Frage 2b), aber: bisher war die Sammeldatei erkennbar eine
Aneinanderreihung. Jetzt trägt jeder Abschnitt einen eigenen
`MIME-Version`/`Content-Type`-Block, und ein Leser, der den ersten sieht, hält
alles Folgende für den Rumpf **einer** Nachricht. Wer das sauber will, braucht
je Nachricht eine `From `-Trennzeile (mbox) — das ist eine eigene Aufgabe, hier
nur vermerkt.

### P-26 — Fälle aus Frage 1 fehlen in `TestE101.cpp`

Die sieben vorhandenen Tests sind gut gebaut (jeder in beide Richtungen), aber
**keiner** von ihnen fährt einen der vier Verlustfälle. Es fehlen: zitiertes
`<x-html` im Rumpf (mit und ohne Kopfzeilen), zwei `</x-html>`, führende
Leerzeile, fehlende Leerzeile, gemischte Zeilenenden, `>` im Attributwert. Der
richtige Prüfsatz ist dabei nicht *„enthält die Ausgabe X"*, sondern **„ist
jedes Byte der Eingabe, das kein Marker ist, noch da"** — sonst geht der
nächste Schnitt wieder stumm durch.

---

## Frage 2 — der Einhängepunkt in `tocview.cpp`

**(a) `PutLine` auf der zusammengezogenen Zeichenkette: identisch.**
`JJFileMT::PutLine` (`jjfile.cpp:894`) ruft `Write_(pBuffer, -1)` und hängt
genau zwei Byte `\r\n` an; `Put` (`jjfile.h:98`) ist dasselbe `Write_` ohne
Anhang. `Put(a)` + `PutLine(b)` und `PutLine(a+b)` erzeugen bytegleiche
Ausgaben. `szDateMaybe` bringt sein `\r\n` schon selbst mit
(`tocview.cpp:3142`). Kein Mangel.

**(b) Schleife und `O_TRUNC`: unbedenklich.** Die Datei wird **einmal vor**
der Schleife geöffnet (`tocview.cpp:3094`); `O_TRUNC` wirkt nur beim Öffnen.
Die Schleife (ab `3101`) schreibt fortlaufend an, wie vorher. Kein Verlust,
keine Änderung gegenüber dem alten Stand — siehe aber P-25.

**(c) Null-Bytes in `CString`: kein neues Risiko.**
`CMessageDoc::GetFullMessage` entfernt Null-Bytes schon beim Lesen
(`msgdoc.cpp:290-310`, *„If NULL bytes are in the message, get rid of them"*)
und liefert den `char*` ohnehin per `strcpy` aus einer `CString`
(`msgdoc.cpp:374-389`). Was in `szGanz` ankommt, kann definitionsgemäß kein
eingebettetes Null-Byte tragen. Der alte Weg war über `strlen` in `Write_`
genauso begrenzt.

---

## Frage 3 — die beiden anderen Speicherwege

**Sie haben den Marker-Teil von E-101 nicht, den Zeichensatz-Teil aber sehr
wohl.**

`CReadMessageDoc::SaveAsFile` (`ReadMessageDoc.cpp:573`) und
`CCompMessageDoc::SaveAsFile` (`compmsgd.cpp:3399`) holen ihren Text **nicht**
aus dem Postfach, sondern über `QCProtocol`/`GetMessageAsText` bzw.
`GetMessageAsHTML` aus der **Anzeige** (Paige). Der interne Marker `<x-html>`
ist dort längst ausgewertet und steht in der Ausgabe nicht mehr. Deshalb sah
Gregors Datei so aus, wie sie aussah: sie kam aus `CTocView::OnFileSaveAs`,
dem einzigen Weg, der die rohe Postfachfassung schreibt.

Was dort **trotzdem** fehlt:

* Beide schreiben mit `pFile->Put(msg)` — **ohne** `MIME-Version`,
  `Content-Type` und Zeichensatz. Speichert der Anwender unter `.eml`, hat er
  dasselbe Leiden wie bei E-101, nur ohne den auffälligen Marker.
* Der HTML-Zweig (`.htm`/`.html`, `compmsgd.cpp:3424`,
  `ReadMessageDoc.cpp:585`) schreibt Latin-1-Bytes in eine HTML-Datei **ohne
  `<meta charset>`**. Jeder heutige Browser nimmt UTF-8 an — die Umlaute sind
  im Browser kaputt. Das ist E-101 in anderer Kleidung und **nachweisbar
  offen**; gemessen habe ich es nicht (kein Fenster gestartet), der fehlende
  `charset` steht aber im Quelltext.

**Gehört die Behebung dorthin?** Nicht dieselbe. Die RFC-822-Kopfzeilen gehören
nur in den Weg, der eine Nachrichtendatei schreibt. Für die beiden anderen ist
das Richtige:
* Textzweig: dieselben drei Kopfzeilen, aber **nur**, wenn Kopfzeilen
  mitgespeichert werden (`IDS_INI_INCLUDE_HEADERS`) — sonst ist es eine reine
  Textdatei und hat keine Kopfzeilen zu tragen.
* HTML-Zweig: ein `<meta http-equiv="Content-Type" content="text/html;
  charset=ISO-8859-1">` in den `<head>`, nichts weiter.

Das ist ein eigener Befund, kein Teil von E-101. Ich habe ihn nicht angelegt
(`befund-suchen.pl` zuerst).

---

## Frage 4 — der Zeichensatz. Richtig, aber aus einem anderen Grund als angegeben

**Auf dem POP-Weg ist `ISO-8859-1` richtig, und zwar nachweisbar:** was ins
Postfach geschrieben wird, ist bereits umgesetzt. `mime.cpp:149/217/248/256`
hängt einen `TextReader` in den Empfangsweg, und `TextReader::ReadIt` ruft
`ISOTranslate(buf, size, iCharsetIdx)` (`TextReader.cpp:300`). Was in `In.mbx`
liegt, ist also Latin-1/CP1252 — genau die Kodierung, von der NP3-8 und E-85
handeln. Die Ableitung aus den Bytes ist damit **nicht** geraten.

**Und sie ist sogar richtiger als die Alternative.** Wegen P-23 ist die
ursprüngliche `Content-Type`-Zeile beim Speichern ohnehin fort; hätte man sie
stehen lassen, stünde `charset=UTF-8` über einem Rumpf, der längst Latin-1
ist — die Umlaute wären kaputt. Wer diesen Zweig je „repariert", indem er die
Originalzeile rettet, macht es dadurch **schlechter**. Das gehört in den
Kommentar.

**Zwei Wege bleiben, auf denen falsch ausgezeichnet wird** (Fall 8 ist der
Beleg: UTF-8-Bytes rein, `charset="ISO-8859-1"` raus):

1. **Zeichensätze, die `ISOTranslate` nicht kennt.** `FindMIMECharset`
   (`mime.cpp:382`) liefert `-1`, wenn der Zeichensatz nicht in der Tabelle
   `IDS_MIME_US_ASCII..IDS_MIME_UTF_8` steht, und `ISOTranslate`
   (`utils.cpp:1447`) lässt bei Index ≤ 2 ohnehin alles unverändert. Eine
   Nachricht in z. B. `koi8-r` oder `gb2312` liegt also **unübersetzt** im
   Postfach und wird jetzt als ISO-8859-1 ausgezeichnet. Vorher stand gar
   nichts da und der Leser durfte raten; jetzt steht dort eine falsche
   Behauptung. **Kein Datenverlust** — die Bytes sind alle da —, aber eine
   Verschlechterung für diese Nachrichten.
2. **Eine selbst verfasste Nachricht mit eingefügtem UTF-8.** Habe ich nicht
   messen können (dazu müsste das Programm laufen). Eudora ist eine
   ANSI-Anwendung, der Verfassenweg legt CP1252 ab; ich halte den Weg für
   verschlossen, **belegt ist er nicht**.

Der billige Schutz gegen 1.: prüfen, ob der Rumpf **gültiges UTF-8** ist
(`ISOIsUTF8Charset`/`ISOIncompleteUTF8Tail` liegen in `utils.cpp` bereits
vor), und dann `UTF-8` auszeichnen statt `ISO-8859-1`. Reine Latin-1-Umlaute
sind fast nie zufällig gültiges UTF-8, der Test ist also trennscharf. Das ist
ein Vorschlag, kein Mangel — wer ihn einbaut, prüft ihn in beide Richtungen.

---

## Frage 5 — P-8 bis P-12 (`PGHTMIMP.CPP`)

**Alle fünf unverändert offen.** `git log` weist seit `008e18a` (PRÜFER-11)
**keinen einzigen Commit** auf `Eudora71/Eudora/PGHTMIMP.CPP` aus. P-11 (die
E-95-Spurmarke liest einen Paige-Handle als Zeichenkette) misst weiterhin
nichts; P-10 (Gegenvermutung zur festen 13/3) ist ungemessen.

---

## Was zu tun ist, in dieser Reihenfolge

1. **P-18, P-19, P-20** — der Datenverlust. Zusammen rund 25 Zeilen, Vorschläge
   oben. Ohne sie kein Paket 1.0.66.
2. **P-26** — die vier Verlustfälle als Tests, mit dem Prüfsatz „kein Byte
   außer dem Marker fehlt". Sonst kommt der nächste Schnitt stumm zurück.
3. **P-23** — den echten Weg (Taboo-Schnitt vor der Aufbereitung) im Test
   abbilden und den Kommentar berichtigen.
4. **P-21, P-22** — gemischter Trenner und die stumme Spurmarke.
5. **Frage 3** — eigener Befund für die beiden anderen Speicherwege
   (`.html` ohne `<meta charset>` ist der handfeste Teil).
6. **P-24, P-25** — vermerkt, nicht dringend.
7. **P-8 bis P-12** — unverändert wie in PRÜFER-11 beschrieben.

## Was ich nicht prüfen konnte

* Das laufende Programm. Alle Messungen oben sind an der **geschnittenen
  echten Funktion** gefahren, nicht an Eudora; kein Fenster gestartet.
* Ob Gregors Nachricht tatsächlich aus `CTocView::OnFileSaveAs` kam. Erschlossen
  daraus, dass nur dieser Weg die rohe Postfachfassung schreibt und seine Datei
  den Marker trug — nicht am Programm nachgestellt.
* Den HTML-Zweig der beiden anderen Speicherwege im Browser. Der fehlende
  `charset` steht im Quelltext, die Wirkung habe ich nicht gemessen.
