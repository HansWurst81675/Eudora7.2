# PRÜFER-14 — `origin/main` nachgerechnet: die E-101-Behebung löscht in einem Fall den ganzen Rumpf

Stand: 17.09.2026. Geprüfter Stand: `origin/main`, Commit `bc515e2`
(„Merge pull request #58 from HansWurst81675/e101-speichern-dateiformat").
Zweig `wt/pruefer-main-pruefung`, eigener Arbeitsbaum, kein Quelltext geändert.

Auftrag von Gregor: *„inzwischen kann lektor und pruefer den main branch
verifizieren, ob unwahrheiten oder alte infos drin stehen"*. Der LEKTOR nimmt
die MDs; hier steht der **Quelltext**.

Gelesen wurden ganz: `SaveAsDialog.cpp` (584 Zeilen) und `SaveAsDialog.h`,
`E101SpeicherfassungAufbereiten` (`msgutils.cpp:3828-4109`),
`E88OriginalEinsetzen` (`msgutils.cpp:2921-3155`), `E89BilderMessbarMachen`
(Zählerteil, `msgutils.cpp:3396-3765`), `PgMsgView::ExportMessage`
(`PgMsgView.cpp:395-474`), `CTocView::OnFileSaveAs` (`tocview.cpp:3060-3210`),
`CReadMessageDoc::StripTabooHeaders` (`ReadMessageDoc.cpp:472-528`),
`CCompMessageDoc::SaveAsFile` (`compmsgd.cpp:3399-3459`),
`CReadMessageDoc::SaveAsFile` (`ReadMessageDoc.cpp:574-627`),
`PGHTMIMP.CPP` 100-120, 375-390, 905-930, 1820-1835, 1955-2200, 3030-3100,
`PgEmbeddedImage.cpp:430-545`, `PGHTMEXP.CPP:180-290`, `TextReader.cpp:105-145`
und `388-412`, `etf2html.cpp:190-205`, `TocFrame.cpp:1385-1415`.

MFC-Quelle 14.38.33130: `dlgfile.cpp`, `winocc.cpp`, `afxwin2.inl`.

**Zwei Messungen, keine Überlegungen:**

1. Die **echte** Funktion `E101SpeicherfassungAufbereiten` wurde aus
   `msgutils.cpp` geschnitten (Zeilen 3828..4109, wie `Extract.ps1` es tut),
   im Ablagepfad mit MFC übersetzt und mit **16 Eingaben** byteweise gefahren
   — die zwölf aus PRÜFER-13 als Gegenprobe plus acht neue. Im Repo liegt
   davon nichts; die Fälle gehören nach `TestE101.cpp`.
2. **Gregors eigenes Protokoll** wurde gelesen:
   `C:\Users\Gregor\Eudora72-1.0.65-release\Mailverzeichnis\eudora.log`,
   608 659 Byte vom 17.09.2026 12:23. Es enthält 12 `E-95 Bild`-Zeilen,
   6 `E-97 Nachtrag`-Zeilen, je eine `E-88`- und `E-89`-Zeile. Drei der
   Befunde unten sind **daran** belegt, nicht am Quelltext allein.

---

## KURZANTWORT

**32 Behauptungen geprüft, 9 widerlegt. Eine davon ist Datenverlust, und sie
steht seit PR #58 in `main`.**

**P-28: `E101SpeicherfassungAufbereiten` löscht den gesamten Nachrichtenrumpf,
wenn `<x-html>` und der Text auf derselben Zeile stehen.** Gemessen: 104 Byte
rein, 128 Byte raus, davon **null Byte Rumpf**. Die Spurmarke meldet
`geaendert=1 bytes-vorher=104 nachher=128` — die Datei wird *größer*, deshalb
sieht niemand etwas.

Dass dieser Fall vorkommt, steht in Eudoras eigenem Leser:
`msgutils.cpp:2374` — *„`<x-html>` And the message all comes on the same
line"*. Und die Ressource, aus der der Marker gebaut wird, hat **kein**
Zeilenende: `IDS_MIME_RICH_ON "<%s>"` (`EudoraRes.rc:9564`);
`etf2html.cpp:200` schreibt `OutPuts( "<x-html>" )` ebenfalls ohne.

Der Gegenvorschlag unten ist **gemessen**: er schließt P-28 und lässt alle
zwölf Fälle aus PRÜFER-13 bitgleich.

Der Rest ist ohne Datenverlust: vier falsche Kommentare, drei Spurmarken, die
nichts messen, und die fünf alten Punkte zu `PGHTMIMP.CPP`, die unverändert
offen sind.

---

# 1. DATENVERLUST

### P-28 — der Marker verschlingt die ganze erste Zeile (`msgutils.cpp:3921-3941`)

```c
	if ( szKlein.Left( 7 ) == "<x-html" )
	{
		const int	nZeile = szRumpf.Find( '\n' );
		const int	nBis   = ( nZeile < 0 ) ? szRumpf.GetLength() : nZeile + 1;

		CString		szErste = szRumpf.Left( nBis );
		... Zeilenende abschneiden ...

		if ( szErste.Right( 1 ) == ">" )
		{
			bWarHtml = true;
			szRumpf  = szRumpf.Mid( nBis );   // <<< die GANZE Zeile
```

Die Bedingung lautet *„die erste Zeile endet auf `>`"*. Sie trifft auf
`<x-html>` zu — und genauso auf
`<x-html><html><body>…</body></html></x-html>`.

**Die Messung an der übersetzten Funktion:**

| Eingabe (Rumpf) | Byte vorher → nachher | Rumpf in der Datei |
|---|---|---|
| `<x-html><html><body>Der ganze Text der Nachricht</body></html></x-html>` | 104 → 128 | **leer** |
| `<x-html><html><body>Inhalt ohne Gegenstueck</body></html>` | 75 → 113 | **leer** |

Die Ausgabe zum ersten Fall, byteweise:

```
From: a@b.de<CR><LF>
Subject: Test<CR><LF>
MIME-Version: 1.0<CR><LF>
Content-Type: text/html; charset="us-ascii"<CR><LF>
Content-Transfer-Encoding: 8bit<CR><LF>
<CR><LF>
```

Danach nichts. Und die Spurmarke dazu:

```
E-101 speichern: kopfzeilen=1 trenner=1 xhtml=1 content-type-vorhanden=0
typ=text/html charset=us-ascii bytes-vorher=104 nachher=128 geaendert=1
```

`nachher` ist **größer** als `vorher`. Wer das Protokoll liest, sieht einen
Erfolg. Das ist derselbe stumme Schnitt, vor dem PRÜFER-13 unter P-26 gewarnt
hat — nur diesmal nicht am Zitat, sondern am ganzen Rumpf.

**Warum der Fall kein Papierfall ist.** Drei Stellen schreiben den Marker:

| Stelle | Zeilenende dahinter? |
|---|---|
| `TextReader.cpp:125/133` (POP-Empfang) | ja — `PutLine` |
| `TocFrame.cpp:1408` (Zitat beim Antworten) | ja — `Format("<%s>\r\n", …)` |
| `etf2html.cpp:200` (`Etf2Html_Convert`, Signaturen und ETF-Teile: `sendmail.cpp:2633`, `signatur.cpp:198`, `msgutils.cpp:1358`, `X1EmailIndexItem.cpp:244`) | **nein** — `OutPuts( "<x-html>" )` |

Dazu die Ressource `IDS_MIME_RICH_ON "<%s>"` (`EudoraRes.rc:9564`), die für
sich genommen ebenfalls kein Zeilenende trägt, und Eudoras eigener Leser, der
den Fall an zwei Stellen ausdrücklich behandelt (`msgutils.cpp:2374` und
`2446`). Gregors gemessene Datei vom 17.09. hatte den Marker auf eigener Zeile
— das ist der POP-Weg. Für alles, was nicht über `PutLine` kam, ist der Weg
offen, und der Preis ist der **ganze** Rumpf.

**Der richtige Code.** Nicht die Zeile, sondern das **Tag** entfernen — und das
Tag endet am ersten `>`, das nicht in Anführungszeichen steht. Genau so macht
es Eudoras eigener Leser (`msgutils.cpp:2385-2394`). Ersetzt
`msgutils.cpp:3921-3941`:

```c
	if ( szKlein.Left( 7 ) == "<x-html" )
	{
		const int	nZeile      = szRumpf.Find( '\n' );
		const int	nZeilenEnde = ( nZeile < 0 ) ? szRumpf.GetLength() : nZeile;

		//
		// PRUEFER P-28: das Tag endet am ersten '>', das NICHT in
		// Anfuehrungszeichen steht - nicht am Zeilenende. Wer die ganze
		// Zeile wegwirft, wirft den Rumpf weg, sobald Marker und Text auf
		// EINER Zeile stehen. Dass das vorkommt, steht in Eudoras eigenem
		// Leser: msgutils.cpp:2374 "<x-html> And the message all comes on
		// the same line". IDS_MIME_RICH_ON ist "<%s>" ohne Zeilenende
		// (EudoraRes.rc:9564), etf2html.cpp:200 schreibt es ebenso.
		//
		// GEMESSEN am 17.09.2026 an der uebersetzten Funktion:
		//   "<x-html><html><body>Der ganze Text der Nachricht</body>
		//    </html></x-html>"  ->  Rumpf leer, Spurmarke sagt
		//   "bytes-vorher=104 nachher=128 geaendert=1".
		//
		int			nTagZu = -1;
		bool		bInStr = false;

		for ( int i = 7; i < nZeilenEnde; i++ )
		{
			const char	c = szRumpf[i];

			if ( c == '"' )
				bInStr = !bInStr;
			else if ( c == '>' && !bInStr )
			{
				nTagZu = i;
				break;
			}
		}

		if ( nTagZu >= 0 )
		{
			//
			// Steht hinter dem '>' in dieser Zeile nur noch Leerraum, faellt
			// die Zeile samt Zeilenende weg. Sonst faellt NUR das Tag weg -
			// der Rest der Zeile ist Text des Anwenders.
			//
			bool	bRestLeer = true;

			for ( int k = nTagZu + 1; k < nZeilenEnde; k++ )
			{
				const char	c = szRumpf[k];

				if ( c != '\r' && c != ' ' && c != '\t' )
				{
					bRestLeer = false;
					break;
				}
			}

			const int	nBis = bRestLeer
								 ? ( ( nZeile < 0 ) ? szRumpf.GetLength() : nZeile + 1 )
								 : ( nTagZu + 1 );

			bWarHtml = true;
			szRumpf  = szRumpf.Mid( nBis );

			... ab hier unveraendert: das Gegenstueck am Ende ...
```

**Gegengemessen, beide Richtungen** (derselbe Messstand, einmal mit der Fassung
aus `main`, einmal mit dem Vorschlag):

| Fall | `main` | Vorschlag |
|---|---|---|
| Marker + Text auf einer Zeile, mit `</x-html>` | 104 → 128, **Rumpf weg** | 104 → 182, Rumpf da, `</x-html>` richtig entfernt |
| Marker + Text auf einer Zeile, ohne Gegenstück | 75 → 113, **Rumpf weg** | 75 → 164, Rumpf da |
| `>` im Attributwert (`content-base="http://host/a>b/"`) | 79 → 134, sauber | 79 → 134, **bitgleich** |
| Normalfall aus Gregors Datei | 90 → 168 | 90 → 168, **bitgleich** |
| die übrigen zehn Fälle aus PRÜFER-13 | — | **alle bitgleich** |

Der Vorschlag kostet nichts und schließt den Weg. Die zwei Fälle gehören
zusätzlich nach `TestE101.cpp`, mit dem Prüfsatz *„ist jedes Byte der Eingabe,
das nicht zum Tag gehört, noch da"* — der vorhandene Prüfsatz *„enthält die
Ausgabe X"* lässt genau diesen Schnitt durch.

**Und die Spurmarke muss es sagen können.** Heute nennt sie nur die
Gesamtlängen, und die wachsen durch die drei neuen Kopfzeilen auch dann, wenn
der Rumpf verschwindet. Zwei Werte in eine Ausgabe
(`Arbeitsweise/zwei-werte-in-eine-ausgabe.md`):

```c
		"E-101 speichern: ... bytes-vorher=%d nachher=%d rumpf-vorher=%d "
		"rumpf-nachher=%d geaendert=%d",
		...
		nRumpfVorher,                 // szRumpf.GetLength() vor Schritt 2
		szRumpf.GetLength(),
```

Aus `rumpf-vorher=72 rumpf-nachher=0` wird der Verlust in einer Zeile sichtbar.

---

# 2. E-97 / E-100 — die Behebung hält, zwei Begründungen halten nicht

### P-29 — der Kommentar in `OnInitDialog` nennt eine Ursache, die nicht abstürzen kann (`SaveAsDialog.cpp:110-121`)

```
// DIE URSACHE steht drei Funktionen weiter oben: DoDataExchange bindet
// die drei Schalter nur an, WENN es sie gibt -
// ...
// - und das ist richtig so. Hier unten wurde dann aber ohne Pruefung
// zugegriffen: m_IncludeHeaders.SetCheck() schickt eine Nachricht an
// m_hWnd, und das ist null, wenn die Anbindung ausgefallen ist.
```

**Falsch, an der MFC-Quelle gemessen.** `afxwin2.inl:629`:

```cpp
_AFXWIN_INLINE void CButton::SetCheck(int nCheck)
	{ ASSERT(::IsWindow(m_hWnd)); ::SendMessage(m_hWnd, BM_SETCHECK, nCheck, 0); }
```

`::SendMessage(NULL, …)` liefert 0 und löst **keine** Ausnahme aus. Das `ASSERT`
davor ist im Release nichts. `SetCheck` auf einem nicht angebundenen Schalter
stürzt nicht ab — das stand schon in PRÜFER-11 (P-1) und gilt unverändert.

Die **echte** Ursache steht 400 Zeilen tiefer im selben File, in
`OnTypeChange` (`SaveAsDialog.cpp:510-515`), mit symbolisiertem Stapel:

```
  0  Eudora.exe  CSaveAsDialog::OnTypeChange + 45
  1  COMDLG32.dll
 25  Eudora.exe  CTocView::OnFileSaveAs + 429
```

Und der ist belegbar: `CWnd::GetDlgItem` ist nicht inline, `winocc.cpp:86-94`
liest `m_pCtrlCont` vom `this`-Zeiger — über NULL gerufen eine
Zugriffsverletzung in `mfc140.dll`. Dass `OnTypeChange` auf der Vista-Schiene
überhaupt gerufen wird, steht in `dlgfile.cpp:638-646`
(`XFileDialogEvents::OnTypeChange` → `pThis->OnTypeChange()`).

**Zwei Kommentare in einer Datei nennen zwei verschiedene Ursachen für
denselben Absturz.** Der in `OnInitDialog` gehört auf den Stand des anderen
gebracht:

```c
	// BEFUND E-97: der Absturz entstand NICHT hier, sondern in OnTypeChange
	// (siehe dort, mit Stapel). m_IncludeHeaders.SetCheck() auf einem nicht
	// angebundenen Schalter geht ueber ::SendMessage(NULL, ...) und liefert
	// nur 0 - afxwin2.inl:629, vom PRUEFER nachgerechnet. Die Pruefungen
	// hier sind trotzdem richtig: sie halten den Dialog arbeitsfaehig,
	// wenn die Schalter fehlen (E-98).
```

Nebenbei: *„drei Funktionen weiter oben"* — `DoDataExchange` steht **eine**
Funktion darüber (Zeile 63 gegen Zeile 88, dazwischen nur die
Nachrichtentabelle).

### P-30 — die Behebungen in `OnOK` und `GetFileNameFromDialog` liegen auf einem Weg, den MFC 14.38 nie betritt

`realFileName[0] = 0` (`SaveAsDialog.cpp:388`) und `buf[0] = '\0'`
(`:431-432`) sind richtig. Aber:

* `GetFileNameFromDialog` und `SetFileNameInDialog` haben **je genau eine**
  Aufrufstelle, beide in `CSaveAsDialog::OnOK` (Zeile 389 und 405) — geprüft
  über den ganzen Baum.
* `CSaveAsDialog::OnOK` wird auf der Vista-Schiene **nicht gerufen**. MFC führt
  das Ergebnis über `XFileDialogEvents::OnFileOk` (`dlgfile.cpp:605-610`), und
  das ruft `OnFileNameOK()`, nicht `OnOK()`.
* Vista-Schiene ist der Normalfall: `m_bVistaStyle` wird im Basiskonstruktor
  entschieden (`dlgfile.cpp:40-47`, `103-144`), **bevor** der Rumpf von
  `CSaveAsDialog` das `OFN_ENABLETEMPLATE` setzt (`SaveAsDialog.cpp:55`).
  Das Flag kommt zu spät und bleibt wirkungslos — das ist P-2/P-4 aus
  PRÜFER-11, unverändert gültig.

**Kein Mangel, aber eine Unwahrheit durch Auslassung:** die Kommentare an
beiden Stellen lesen sich, als wäre damit ein aktiver Weg geschlossen worden.
Ein Satz genügt:

```c
	// Erreichbar wird das erst wieder, wenn E-98 die Vorlage zurueckholt:
	// auf der Vista-Schiene ruft MFC OnFileNameOK, nicht OnOK
	// (dlgfile.cpp:605-610). Heute laeuft diese Funktion nicht.
```

Dasselbe gilt für den `else`-Zweig in `SetFileNameInDialog`
(`SaveAsDialog.cpp:483-500`), in den PRÜFER-12 (P-15) den Wächter verschoben
hat: `IsVersion4()` ist `dwMajorVersion >= 4` (`eudora.h:311-312`), auf
Windows 10 immer wahr. Der Zweig, in dem der Wächter jetzt steht, ist toter
Code. Die Verschiebung war trotzdem richtig — falsch war der Wächter über der
ganzen Funktion.

### P-31 — `m_Inc`/`m_Guess`: die Vorbelegung schließt den Weg, gemessen am Ablauf

`SaveAsDialog.cpp:48-49` belegt beide aus der INI vor. Nachgerechnet:

* Wird `OnInitDialog` erreicht, setzt Zeile 146 `m_Inc = m_Guess = FALSE` und
  Zeile 148/155 danach wieder aus derselben INI — gleiches Ergebnis.
* Wird es nicht erreicht, steht der INI-Wert da statt Stapelmüll.
* Alle drei Aufrufstellen (`tocview.cpp:3087`, `saveas.cpp:106`,
  `compmsgd.cpp:3375`) schreiben danach denselben Wert zurück.

**P-5 aus PRÜFER-11 ist damit geschlossen.** Der Weg in die INI des Anwenders
ist zu.

Offen bleibt die Messung selbst: `SaveAsDialog.cpp:92` schreibt
`E-97 OnInitDialog: 1 …`, ausgeliefert seit 1.0.64. In Gregors Protokoll von
1.0.65 steht die Zeile **null Mal** — bei eingeschaltetem `DEBUG_MASK_MISC`
(12 `E-95`-Zeilen im selben Lauf beweisen, dass protokolliert wurde). Das
heißt entweder *„er hat in diesem Lauf nichts gespeichert"* oder
*„`OnInitDialog` läuft nicht"*, und beides ist mit einer Handlung zu trennen:
**einmal Datei → Speichern unter öffnen und abbrechen, dann die Zeile suchen.**
Solange das offen ist, ist P-4 (die beiden Kästchen) nicht abschließend
beschrieben.

---

# 3. E-99 — die Behebung hält

`CCompMessageDoc::m_bE88AnwenderHatGetippt` (`compmsgd.h:201`, im Konstruktor
`compmsgd.cpp:129` auf FALSE, in `PgMsgView.cpp:443-444` rastend gesetzt).

Nachgerechnet, was die Rastung wertlos machen würde:

* **Rastet sie zu früh?** Nein. `m_chngCount` wird nur in
  `CPaigeEdtView::UpdateChangeState( kAddChange | kRedoChange )` erhöht
  (`PaigeEdtView.cpp:6484-6487`), und die einzigen Aufrufer mit `kAddChange`
  sind `PaigeEdtView.cpp:6091` (Undo-Aufzeichnung bei echten Eingaben) und
  `spellpaige.cpp:362/737/760` (Rechtschreibkorrektur). Das Befüllen des
  Verfassenfensters läuft über `Serialize`/`ImportData`
  (`PaigeEdtView.cpp:5622-5629`) und zählt **nicht** mit; der Konstruktor
  setzt `m_chngCount = m_ccLastSaved = 0` (`:368`). Ein frisch geöffnetes
  Antwort- oder Weiterleitungsfenster kommt also mit FALSE an.
* **Übersteht sie Schließen und Wiederöffnen?** Nein — und das ist gut so:
  `m_szE88OriginalHTML` wird nur beim Anlegen der Antwort gesetzt
  (`summary.cpp:1551`) und nirgends ins Postfach geschrieben. Ein erneut
  geöffneter Entwurf kommt mit leerem Original an, und
  `E88OriginalEinsetzen` urteilt `EDITOR (kein Original gemerkt)`
  (`msgutils.cpp:2941-2942`). Kein Weg, auf dem das Original getippten Text
  überschreiben könnte.

**P-13 aus PRÜFER-11 ist geschlossen.**

### P-32 — der Kommentar in `msgutils.cpp` nennt noch die alte Quelle (`msgutils.cpp:2984-2989`)

> *„Deshalb zaehlt jetzt zuerst, ob der Anwender ueberhaupt etwas getippt hat.
> Paige fuehrt darueber Buch (CPaigeEdtView::HasChanged, PaigeEdtView.h:193)."*

Seit E-99 führt **nicht mehr Paige** darüber Buch, sondern das
Verfassendokument. `HasChanged()` heißt weiterhin nur *„seit dem letzten
Export"* — genau deshalb wurde der Merker eingeführt. Wer diesem Kommentar
folgt und wieder `HasChanged()` einsetzt, baut P-13 zurück. Richtig:

```c
			// Deshalb zaehlt jetzt zuerst, ob der Anwender ueberhaupt etwas
			// getippt hat. Buch fuehrt darueber das Verfassendokument:
			// CCompMessageDoc::m_bE88AnwenderHatGetippt rastet beim ersten
			// HasChanged() ein und wird nie zurueckgenommen (E-99,
			// PgMsgView.cpp:443). NICHT HasChanged() direkt verwenden - das
			// heisst "seit dem letzten Export", und SaveChangeState() steht
			// am Ende jedes Exports (PgMsgView.cpp:473).
```

Der Satz zwei Absätze weiter — *„Die Regel kann nur helfen, nie schaden"* —
trägt jetzt, nach E-99, tatsächlich. Vor E-99 tat er es nicht. Das gehört
dazugeschrieben, sonst liest der nächste ihn als seit jeher gültig.

---

# 4. Kommentare, die etwas Falsches behaupten

### P-33 — „eine vorhandene Content-Type-Zeile bleibt unangetastet": auf diesem Weg gibt es keine (`tocview.cpp:3176-3178`, `msgutils.cpp:3817-3820`)

`tocview.cpp` sagt drei Zeilen unter dem Aufruf, der sie entfernt:

> *„Eine bereits vorhandene Content-Type-Zeile - also der Normalfall bei einer
> empfangenen Nachricht - bleibt unangetastet."*

Der Ablauf ist aber:

1. `tocview.cpp:3136-3138` ruft für jede empfangene Nachricht
   `pReadMessageDoc->StripTabooHeaders(pszFullMessage)`.
2. `StripTabooHeaders` arbeitet **an Ort und Stelle** (`ReadMessageDoc.cpp:517-518`
   schiebt zusammen, `:525` schließt ab); `pszMessage` zeigt auf denselben
   Puffer.
3. Verglichen wird per **Präfix** (`ReadMessageDoc.cpp:504`, `strnicmp` über die
   Länge des Listeneintrags).
4. Die Vorgabeliste `IDS_INI_USER_TABOO_HEADERS` (`EudoraRes.rc:9998`) enthält
   `Mime-Version` **und** `Content-`.

Also sind `Content-Type`, `Content-Transfer-Encoding` und `MIME-Version`
**weg**, bevor `E101SpeicherfassungAufbereiten` den Text sieht. Der Zweig
*„unangetastet"* ist auf diesem Weg tot, und **jede** empfangene Nachricht
bekommt den aus den Bytes abgeleiteten Zeichensatz. Das ist P-23 aus
PRÜFER-13, unverändert in `main`, an zwei Stellen als Gegenteil aufgeschrieben.

Richtig an beiden Stellen:

```c
	// ACHTUNG: auf DIESEM Weg kommt nie eine Content-Type-Zeile an.
	// tocview.cpp:3138 ruft vorher StripTabooHeaders, und die Vorgabeliste
	// IDS_INI_USER_TABOO_HEADERS (EudoraRes.rc:9998) enthaelt "Content-"
	// und "Mime-Version", verglichen per Praefix (ReadMessageDoc.cpp:504).
	// Der Zweig "vorhandene Zeile bleibt stehen" traegt nur, wenn jemand die
	// Funktion aus einem anderen Weg ruft. Das ist kein Fehler - die Ableitung
	// aus den Bytes ist hier sogar richtiger, siehe PRUEFER-13, Frage 4 -
	// aber es ist nicht das, was hier bisher stand.
```

### P-34 — `E101SpeicherfassungAufbereiten` entfernt das Gegenstück nicht immer (`msgutils.cpp:3808`)

Kopfkommentar: *„Sie entfernt den `<x-html>`-Marker und sein Gegenstück
`</x-html>`."* Seit der P-19-Behebung gilt das nur, wenn hinter dem Fund
nichts als Leerraum steht. Gemessen:

```
EIN:  <x-html><CR><LF><html>Inhalt</html><CR><LF></x-html><CR><LF>Anhang folgt<CR><LF>
AUS:  ... <html>Inhalt</html><CR><LF></x-html><CR><LF>Anhang folgt<CR><LF>
```

Das `</x-html>` bleibt in der Datei, und die Datei ist trotzdem als
`text/html` ausgezeichnet. Das ist die richtige Abwägung — die Alternative war
Textverlust —, aber der Kopfkommentar behauptet etwas anderes. Ein Halbsatz
reicht: *„…, sofern dahinter nur Leerraum steht (PRÜFER P-19)."*

### P-35 — der gemerkte Text-Ascent ist Zustand über Nachrichtengrenzen hinweg (`PGHTMIMP.CPP:3091-3095`)

> *„Er wird einmal je Import gesetzt und danach nur gelesen. Die Variable ist
> dateilokal und nicht threadsicher - der HTML-Import laeuft im Hauptstrang,
> und der Wert ist eine Zeilenhoehe, kein Zustand."*

Drei Behauptungen, alle drei falsch:

1. **„einmal je Import"** — die Bedingung ist
   `if (!embed_last_action && original_ascent > 0)` (`:2052`), und
   `embed_last_action` wird an `:382` und `:923` nach jedem Textstück wieder
   auf FALSE gesetzt. Sie läuft mehrfach je Import. (P-9 aus PRÜFER-11,
   unverändert.)
2. **„danach nur gelesen"** — siehe 1.
3. **„kein Zustand"** — doch. `PaigeHTMLImportTextAscent` und
   `…Descent` stehen als **dateilokale statische** Variablen in
   `PGHTMIMP.CPP:1826-1827` und werden mit 13/3 **einmal beim Programmstart**
   belegt. Der Rücksetzblock des Importfilters (`PGHTMIMP.CPP:100-118`) setzt
   `embed_last_action` zurück, diese beiden aber **nicht**. Der Wert der
   vorigen Nachricht lebt in der nächsten weiter: wer eine Nachricht mit
   großer Schrift öffnet und danach eine mit kleiner, bekommt in der zweiten
   den Ascent der ersten als Untergrenze für jede Bildzeile.

Abhilfe: die beiden Zeilen in den Rücksetzblock bei `:112`:

```c
   embed_last_action = FALSE;

   // PRUEFER P-35: auch die gemerkte Textzeilenhoehe gehoert zurueckgesetzt.
   // Sie ist dateilokal statisch (Zeile 1826) und lebte bisher von einer
   // Nachricht in die naechste.
   PaigeHTMLImportTextAscent  = 13;
   PaigeHTMLImportTextDescent = 3;
```

(Die Deklarationen stehen weiter unten als der Rücksetzblock — sie müssen
dafür nach vorn oder als `extern` deklariert werden.)

### P-36 — `nOhneMass` heißt „unangetastet gelassen" und wird trotzdem angetastet (`msgutils.cpp:3399`, `3644`)

```c
	int		nOhneMass = 0;		// kein Mass bekannt - Bild unangetastet gelassen
```

Der erste Zähler (`:3628`) hat ein `continue` dahinter — dort stimmt es. Der
zweite (`:3644`, Breite bekannt, Höhe nicht) hat **keins**: die Ausführung
läuft in den Deckel-Teil weiter und kann das `<img>` umschreiben.

**Gemessen in Gregors Protokoll**, eine Zeile, die sich selbst widerspricht:

```
E-89 Bilder im Editor: gesamt=13 unveraendert=3 aus-CSS=0 eingebettet=0
ohne-Mass=10 gedeckelt=0 geaendert=1 Bytes vorher=82489 nachher=82499
```

3 + 10 = 13, also wäre jedes Bild entweder schon gut oder unangetastet — und
trotzdem `geaendert=1` und zehn Byte mehr. Das ist der Ausreißer, und der
Ausreißer ist der Befund (`Arbeitsweise/ausreisser-ist-der-befund.md`).
Richtig ist ein eigener Zähler:

```c
	int		nOhneMass  = 0;		// gar kein Mass - Bild unangetastet gelassen
	int		nNurBreite = 0;		// Breite bekannt, Hoehe nicht - Bild laeuft weiter
```

und in der Spurmarke `nur-breite=%d` dazu. Ohne das kann niemand sagen, welche
zehn Byte sich geändert haben.

---

# 5. Spurmarken, die nichts messen

### P-11 (bestätigt) — `image_ref` als Zeichenkette (`PGHTMIMP.CPP:2178-2183`)

Unverändert in `main` (`git log` weist seit `d1edf31` keinen Commit an
`PGHTMIMP.CPP` aus). **Jetzt an Gregors Protokoll bestätigt**, nicht nur am
Quelltext:

```
E-95 Bild: src=\100\001x\002\130\001x\002 attr=200x52 embed=200x52 ascent=52 …
E-95 Bild: src=\110\001x\002\110\001x\002 attr=282x0  embed=0x0    ascent=13 …
```

Zwölf Zeilen, zwölfmal Binärmüll. Nie `cid:`, `data:` oder `http:`, wie der
Kommentar bei `:2160` behauptet. Was da steht, sind zwei Maschinenworte aus
dem Kopf der Handle-Struktur.

**Der richtige Code ist einfacher als gedacht.** `UseMemory(image_ref)` braucht
es gar nicht: `GetMemoryRecord(image_ref, 0, &image_record)` steht 130 Zeilen
vorher (`:2045`) und hat den Datensatz bereits in die lokale Variable geholt.
`image_record.URL` ist im Gültigkeitsbereich und wird bei `:2065` schon
benutzt. Ersetzt `:2177-2183`:

```c
               //
               // PRUEFER P-11: hier stand ((const char *)image_ref)[i].
               // image_ref ist ein Paige-memory_ref (Zeile 1966), kein
               // Zeiger auf Text - gelesen wurden die ersten Bytes der
               // Handle-Struktur. In Gregors Protokoll vom 17.09.2026 steht
               // darum zwoelfmal "src=\100\001x\002...". Der Datensatz liegt
               // seit Zeile 2045 in image_record; die URL steht dort.
               //
               strncpy(szSrc, (const char *)image_record.URL, 32);
               szSrc[32] = 0;
```

### P-37 — die `E-97 Nachtrag`-Marke vergleicht einen Wert mit sich selbst (`PgEmbeddedImage.cpp:468-487`)

Die Marke steht **hinter** den Zuweisungen:

```c
	embed->width  = pUrlImage->source_width;    // :462
	embed->height = pUrlImage->source_height;   // :465
	...
	wsprintf(szSpur97, "E-97 Nachtrag: quelle=%dx%d embed=%ldx%ld\r\n",
		(int)pUrlImage->source_width, (int)pUrlImage->source_height,
		(long)embed->width, (long)embed->height);     // :482-485
```

`embed` kann danach gar nichts anderes sein als `quelle`. **Gregors Protokoll,
sechs von sechs Zeilen:**

```
E-97 Nachtrag: quelle=282x683 embed=282x683
E-97 Nachtrag: quelle=288x683 embed=288x683
E-97 Nachtrag: quelle=24x49   embed=24x49     (viermal)
```

Die Frage im Kommentar darüber (*„greift dieser Nachtrag ueberhaupt?"*) bleibt
damit offen. Richtig ist, den alten Wert vorher zu sichern:

```c
				const long	nVorherB = (long)embed->width;
				const long	nVorherH = (long)embed->height;

				... die vier Zuweisungen ...

				wsprintf(szSpur, "E-103 Nachtrag: quelle=%dx%d embed-vorher=%ldx%ld "
					"embed-nachher=%ldx%ld gefunden=%d\r\n", ...);
```

Dazu: **die Marke trägt die falsche Befundnummer.** `E-97` ist der
Speichern-Absturz. Das hier gehört zur Bildgrößen-Familie (E-95/E-96/E-103).
Gregor hat sie auf seinem Zweig `e103-darstellung-bilder` bereits auf
`E-103 Nachtrag` umbenannt — auf `main` steht noch `E-97`.

### P-12 (bestätigt) — die E-96-Behebung ist im Quelltext durchweg mit E-95 ausgezeichnet

`PGHTMIMP.CPP` Zeilen 9, 2049, 2157, 2186, 3041, 3061 sagen **E-95**. Der
Commit heißt `d1edf31 „E-96 behoben: jedes Bild bekam die Zeilenhoehe des
ersten"`. Wer E-96 im Quelltext sucht, findet nichts. Unverändert offen.

### P-38 — die E-101-Marke kann den Verlust aus P-28 nicht zeigen

Siehe P-28: `rumpf-vorher`/`rumpf-nachher` fehlen. Solange sie fehlen, ist die
Marke bei jedem Schnitt am Rumpf stumm.

---

# 6. P-8 bis P-12 (`PGHTMIMP.CPP`) — alle fünf unverändert offen

`git log --oneline -- Eudora71/Eudora/PGHTMIMP.CPP` auf `origin/main`:

```
d1edf31 E-96 behoben: jedes Bild bekam die Zeilenhoehe des ersten (7.2.0.62)
bcbcd8e E-89 behoben: die Bildhoehe zaehlt wieder fuer die Zeilenhoehe (7.2.0.58)
567a5d8 00 initial commit mit den original sourcen
```

Kein Commit seit PRÜFER-11. Stand der fünf:

* **P-8** — `PaigeHTMLImportTextDescent` (`:1827`) wird **nirgends** zugewiesen;
  nur der Ascent wird bei `:2053` gemerkt. `:3097` schreibt stets die fest
  verdrahtete 3 zurück. Der Kommentar bei `:3041` (*„der Text-Ascent/-Descent,
  wie er VOR dem ersten Bild galt"*) beschreibt für den Descent etwas, das der
  Code nicht tut. **Offen und bestätigt.**
* **P-9** — Bedingung falsch beschrieben. **Offen**, und in P-35 oben
  zusammengefasst.
* **P-10** — `ProcessEmbed:3096-3097` klemmt `current_style.ascent/descent` auf
  13/3 fest, und `current_style` gilt auch für den **folgenden Text**.
  **Offen und ungemessen.** Gregors Protokoll stützt die Vermutung indirekt:
  zwölfmal `text-asc=13 text-desc=3` in einer Nachricht mit 13 Bildern — nie
  ein anderer Wert. Entweder ist die Nachricht durchweg 13-Punkt, oder die
  Rückschreibung deckt jede andere Schriftgröße zu. Die Messung aus PRÜFER-11
  (HTML-Nachricht mit 20-pt-Text hinter einem Bild) steht weiter aus.
* **P-11** — bestätigt, siehe oben; richtiger Code genannt.
* **P-12** — bestätigt, siehe oben; dazu die zweite falsche Nummer in
  `PgEmbeddedImage.cpp` (P-37).

---

# 7. Der `.htm`-Speicherweg — belegt, und die Zeile hat keinen Platz

PRÜFER-13, Frage 3 sagte: Latin-1-Bytes ohne `<meta charset>`. **Belegt, und
schlimmer als vermutet: die Datei hat gar keinen `<head>`.**

Der Weg:

* `CCompMessageDoc::SaveAsFile` (`compmsgd.cpp:3424-3431`) und
  `CReadMessageDoc::SaveAsFile` (`ReadMessageDoc.cpp:589-599`) wählen an der
  Endung `.htm`/`.html` den HTML-Zweig und rufen `GetMessageAsHTML`.
* `PgCompMsgView::GetMessageAsHTML` (`PgCompMsgView.cpp:299-330`) holt den Text
  über `PgDataTranslator::kFmtHtml` aus Paige.
* Der Paige-Ausgeber schreibt `<HTML>` (`PGHTMEXP.CPP:189`) und danach
  **sofort** `<BODY>` (`:230`). Dazwischen steht der `<HEAD>`-Block —
  auskommentiert, mit Begründung von QUALCOMM (`:191-219`):
  *„Don't want to write out `<head>` and `<title>` tags because they provide
  no value and just clutter things up."*
* Geschrieben wird mit `pFile->Put(msg)` (`compmsgd.cpp:3452`,
  `ReadMessageDoc.cpp:595`) — Byte für Byte, ohne Umkodierung.

Die Bytes sind Latin-1 (das ist derselbe Nachweis wie bei E-101: der
Empfangsweg setzt über `TextReader::ReadIt` → `ISOTranslate` um, bevor etwas
ins Postfach geht). Ein heutiger Browser ohne `charset`-Angabe nimmt bei einer
lokalen Datei UTF-8 an — jeder Umlaut ist hin.

**Wohin die Zeile gehört.** *Nicht* in `PGHTMEXP.CPP`: das ist Paige-Code, es
gibt eine zweite Kopie unter `Eudora71/PaigeDLL/PGTXR/`, und derselbe Ausgeber
bedient auch Kopieren/Einfügen, wo ein `<head>` stören würde. Sie gehört in
die **beiden Speicherfunktionen**, unmittelbar hinter `GetMessageAsHTML`, weil
nur dort feststeht, dass eine Datei entsteht. Für `compmsgd.cpp:3429-3431`:

```c
		view->GetMessageAsHTML(msg, GetIniShort( IDS_INI_INCLUDE_HEADERS ));
		msg = Text2Html(dateMaybe, TRUE, FALSE) + msg;

		//
		// Der Paige-Ausgeber schreibt <HTML> und dann sofort <BODY>
		// (PGHTMEXP.CPP:189 und 230) - den <HEAD>-Block hat QUALCOMM 1996
		// auskommentiert. Die Bytes sind Latin-1, dieselbe Kodierung, von
		// der NP3-8 und E-85 handeln. Ohne Angabe nimmt jeder heutige
		// Browser bei einer lokalen Datei UTF-8 an, und die Umlaute sind
		// hin. Hier, nicht im Paige-Code: derselbe Ausgeber bedient auch
		// Kopieren/Einfuegen, und es gibt eine zweite Kopie in PaigeDLL.
		//
		{
			static const char	szKopf[] =
				"<head><meta http-equiv=\"Content-Type\" "
				"content=\"text/html; charset=ISO-8859-1\"></head>\r\n";

			int		nHtml = msg.Find( "<HTML>" );

			if ( nHtml < 0 )
				nHtml = msg.Find( "<html>" );

			if ( nHtml >= 0 )
				msg = msg.Left( nHtml + 6 ) + szKopf + msg.Mid( nHtml + 6 );
			else
				msg = CString( szKopf ) + msg;
		}
```

Dasselbe in `ReadMessageDoc.cpp` vor Zeile 595.

**Was ich daran nicht gemessen habe:** die Wirkung im Browser (kein Fenster
gestartet, keine Datei erzeugt). Belegt sind der fehlende `<head>` im
Quelltext und die Latin-1-Herkunft der Bytes. Vor dem Einbau gehört eine
Gegenprobe in beide Richtungen: eine Nachricht mit Umlaut als `.htm` sichern,
im Browser öffnen — einmal ohne die Zeile (kaputt) und einmal mit (richtig).
Das ist genau der Fall aus `Arbeitsweise/nie-benutzt-ist-nicht-geprueft.md`:
den HTML-Zweig hat in diesem Projekt noch nie jemand angeklickt.

**Ein eigener Befund, kein E-101.** `befund-suchen.pl` vor dem Anlegen.

---

# 8. Zugabe zu E-103 (nicht angefasst, nur aufgeschrieben)

Beim Lesen von `PgEmbeddedImage.cpp:455-523` und Gregors Protokoll sind drei
Dinge aufgefallen, die zu deiner laufenden Arbeit gehören:

### P-39 — der Suchlauf vergleicht Stile, nicht Bilder (`PgEmbeddedImage.cpp:500-511`)

```c
				for ( long li = 1; !bFound && (er = pgGetIndEmbed(...)); li++ )
				{
					embed_ptr = (pg_embed_ptr) UseMemory(er);
					if (embed_ptr)
					{
						if (embed->style == embed_ptr->style)
							bFound = true;
```

`embed->style` ist eine **Stil-Kennung**, keine Identität. Alle Bilder, die
`ProcessEmbed` mit der festgeklemmten 13/3 verlassen haben
(`PGHTMIMP.CPP:3096-3097`), tragen denselben Stil. Der Lauf nimmt den
**ersten** Treffer, und `pgInvalEmbedRef(pg->myself, pos, embed, draw_none)`
(`:517`) wird dann an der Stelle eines **anderen** Bildes angewandt. Das ist
das Schadensbild von E-96, nur eine Schicht tiefer. Der Kommentar bei `:477-479`
ahnt es (*„haengt daran, ob der Suchlauf unten das richtige Embed findet"*) —
die Marke sagt aber nur `gefunden=1`, also *dass* etwas gefunden wurde, nicht
*ob das richtige*. Was fehlt, ist `pos` und die Zahl der Durchläufe in der
Marke.

### P-40 — der Nachtrag ändert die Größe, aber nicht die Zeilenhöhe

`:462-466` setzt `embed->width/height` und `pict_frame`. **Nichts** auf diesem
Weg fasst den Ascent/Descent des Stils an — und der ist es, der die Zeile
aufspannt. `ProcessEmbed` hat ihn auf `PaigeHTMLImportTextAscent` = 13
gesetzt, und dabei bleibt es. Das ist genau dein gemessenes Bild:
`attr=0x0 embed=0x0 ascent=13` beim Import, `quelle=202x60` beim Laden, Bild
über dem Text.

Wenn der Nachtrag wirken soll, muss er den Stil des betroffenen Embeds
nachziehen, nicht nur dessen Maße — also dort dasselbe tun wie
`PGHTMIMP.CPP:2150-2153` (`current_style.ascent = source_height`, mit dem
Text-Ascent als Untergrenze), nur nachträglich über `pgSetStyleInfo` auf dem
gefundenen Bereich. Das ist der Punkt, an dem P-39 scharf wird: an der
falschen Stelle angewandt, wandert die Höhe zum falschen Bild.

### P-41 — vier von zehn Bildern bekommen den Nachtrag nie

Aus Gregors Protokoll, ein Lauf, eine Nachricht:

| Quelle | Zahl |
|---|---|
| `E-89 … gesamt=13 … ohne-Mass=10` | 10 Bilder ohne Maß im HTML |
| `E-95 Bild: … embed=0x0` | 10 Zeilen |
| `E-97 Nachtrag: …` | **6** Zeilen |

Die Breiten passen paarweise (282, 288, 24, 24, 24, 24), die vier fehlenden
sind die mit 122, 125 und zwei der 24er. Vier Bilder haben den Ladeweg also
nie erreicht — abgebrochener Abruf, Zwischenspeicher, `QTW_MetafileFromQtImage`
fehlgeschlagen, oder die Marke steht hinter einer Bedingung, die nicht griff.
Das ist keine Vermutung über die Ursache, sondern die Feststellung, dass die
Zahlen nicht aufgehen. Eine Marke am **Eingang** von `PgLoadUrlImage` — vor
jeder Bedingung — trennt das in einem Lauf.

---

# Reihenfolge, in der ich das angehen würde

1. **P-28** — der Datenverlust. Der Vorschlag ist gemessen, er kostet ~35
   Zeilen und lässt alle zwölf alten Fälle bitgleich. **Kein weiteres Paket
   ohne ihn** (`Arbeitsweise/kein-paket-mit-offenem-datenverlust.md`).
2. **P-38 + die zwei Testfälle** — sonst kommt der nächste Schnitt wieder
   stumm zurück.
3. **P-33** — die falsche Aussage über die Content-Type-Zeile, an zwei Stellen.
   Sie steht direkt über dem Code, der das Gegenteil tut.
4. **P-11, P-37** — die beiden Marken, die nichts messen. Beide sind
   ausgeliefert und beide in Gregors Protokoll als Unsinn belegt.
5. **P-36, P-35** — Zähler und gemerkte Zeilenhöhe. Beides erklärt heute
   unerklärte Zahlen.
6. **P-29, P-30, P-32, P-34** — Text berichtigen.
7. **Der `.htm`-Weg** — eigener Befund, mit Gegenprobe im Browser.
8. **P-39 bis P-41** — gehört zu E-103, liegt bei Gregor.
9. **P-8, P-10, P-12** — unverändert wie in PRÜFER-11.

---

# Was ich nicht prüfen konnte

* **Das laufende Programm.** Kein Fenster gestartet
  (`Arbeitsweise/nichts-auf-gregors-bildschirm-starten.md`). Alle Messungen an
  E-101 sind an der **geschnittenen echten Funktion** gefahren, alle Messungen
  an E-95/E-97/E-88/E-89 stammen aus Gregors vorhandenem Protokoll von 1.0.65.
* **Ob `OnInitDialog` auf der Vista-Schiene erreicht wird** (P-31). Die Marke
  ist eingebaut und ausgeliefert, im Protokoll steht sie null Mal — aber im
  selben Lauf wurde auch nichts gespeichert. Eine Handlung trennt das.
* **Ob die Verlustfälle aus P-28 in Gregors Postfach tatsächlich vorkommen.**
  Belegt ist, dass Eudora sie schreibt (`etf2html.cpp:200`,
  `IDS_MIME_RICH_ON`) und liest (`msgutils.cpp:2374`). Ein Suchlauf über
  `In.mbx`/`Out.mbx` nach `<x-html>` mit Text dahinter auf derselben Zeile
  würde es in Minuten klären — dafür fehlt mir die Erlaubnis für seine
  Postfächer.
* **Die Wirkung des fehlenden `<meta charset>` im Browser.** Der fehlende
  `<head>` steht im Quelltext; die kaputte Anzeige habe ich nicht gesehen.
* **P-10** — die Gegenvermutung zur festen 13/3 bleibt ungemessen. Sie braucht
  eine HTML-Nachricht mit großer Schrift hinter einem Bild.
