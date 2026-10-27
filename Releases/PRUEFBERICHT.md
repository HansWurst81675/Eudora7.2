# Pruefbericht Eudora 7.2

| | |
|---|---|
| **Quellstand** | `7.2.0.126` (Paketnummer `1.0.126`) |
| **Commit** | `1cf3d242` — **Arbeitsbaum nicht sauber** (1 Dateien) |
| **Erstellt** | 2026-10-27 12:37 |
| **Gesamturteil** | **BESTANDEN** |

**Dauer** — wer die Tests selbst faehrt, braucht etwa:

| Teil | Dauer | gemessen |
|---|---|---|
| Unit-Tests bauen und fahren | 0 min 00 s | dieser Lauf |
| Schranken mit Rueckfallprobe | 0 min 08 s | dieser Lauf |
| Pruefstand, 36 Faelle, 11 Eudora-Starts | 6 min 08 s | voller Lauf, Ende 2026-10-27 12:37:32 |
| **zusammen** | **6 min 16 s** | |

Massstab fuer die Pruefstandsfaelle ist der Bau in `Eudora71\Bin\Release`: `Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16`. Ein Fall auf einem anderen Bau heisst *ANDERER BAU*.

| Art | Tests | gruen | rot | sonst |
|---|---|---|---|---|
| Unit-Tests (`EudoraTests.exe`) | 314 | 314 | 0 |  |
| Schranken mit Rueckfallprobe | 19 | 19 | 0 | |
| Pruefstand (Oberflaeche) | 36 | 36 | 0 | 0 an anderem Bau, 0 nie gelaufen |

Erzeugt von `tools/pruefbericht.pl`. Jeder Test steht unten einzeln, mit
Zeitpunkt und Bau. Maschinenlesbar steht dasselbe in
[`pruefbericht-tests.tsv`](pruefbericht-tests.tsv) — das ist der Stand *vorher*
fuer den Vergleich.

## Nach einer eigenen Aenderung: vorher und nachher vergleichen

```
perl tools/pruefbericht.pl --vergleich
```

baut und faehrt die Unit-Tests und die Schranken, liest die Pruefstandsfaelle
aus `Intern/pruefstand-buch.tsv` und vergleicht alles mit diesem eingecheckten
Stand: **neu rot**, neu gruen, neu hinzugekommen, weggefallen. Rueckgabe 1,
sobald etwas neu rot ist. Geschrieben wird dabei nichts.

Die Pruefstandsfaelle oeffnen Eudora-Fenster und laufen deshalb nur auf
Anforderung, je Fall an einem eigenen Verzeichnis unter `C:\Temp`:

```
powershell -ExecutionPolicy Bypass -File tools\pruefstand-lauf.ps1 -Freigabe "<wer, wann>"
```

Danach `perl tools/pruefbericht.pl` schreibt Bericht und Testbuch neu.

## 1. Unit-Tests

Gelaufen am **2026-10-27 12:37** gegen den Quelltext von Commit `1cf3d242*`.

<details><summary>Alle 314 Unit-Tests einzeln</summary>

| Bereich | Test | Ergebnis |
|---|---|---|
| utils.cpp - Uebersetzungstabelle pcXlateTable | utils.cpp: XLATE_CHARS / MAX_CHARS_TO_TRANS / MAX_CHARACTER_SETS | ok |
| utils.cpp - Uebersetzungstabelle pcXlateTable | utils.cpp: MAX_CHARACTER_SETS passt zu den IDs in resource.h | ok |
| utils.cpp - Uebersetzungstabelle pcXlateTable | utils.cpp: die Zeichenliterale der Tabelle sind CP1252-Bytes >= 0x80 | ok |
| utils.cpp - Uebersetzungstabelle pcXlateTable | UTF-8-Zeile: alle 123 Eintraege belegt (ISOTranslate bricht sonst ab) | ok |
| utils.cpp - Uebersetzungstabelle pcXlateTable | UTF-8-Zeile: jede Quellfolge ist gueltiges, nullterminiertes UTF-8 | ok |
| utils.cpp - Uebersetzungstabelle pcXlateTable | UTF-8-Zeile: Codepunkt der Quellfolge == Codepunkt des CP1252-Zielbytes | ok |
| utils.cpp - Uebersetzungstabelle pcXlateTable | UTF-8-Zeile: keine doppelten Quellfolgen und keine doppelten Ziele | ok |
| utils.cpp - Uebersetzungstabelle pcXlateTable | UTF-8-Zeile: alle 123 uebersetzbaren CP1252-Zeichen sind abgedeckt | ok |
| utils.cpp - Uebersetzungstabelle pcXlateTable | UTF-8-Zeile: Latin-1 U+00A0..U+00FF vollstaendig und wertgleich abgebildet | ok |
| utils.cpp - Uebersetzungstabelle pcXlateTable | ISO-8859-15-Zeile: die acht Abweichungen zu Latin-1 sind korrekt und vollstaendig | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: Index 0/1/2 laesst den Text unveraendert | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: reiner ASCII-Text bleibt unveraendert | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: U+00A0..U+00FF werden je auf ein Latin-1-Byte abgebildet | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: die 27 CP1252-Sonderzeichen 0x80..0x9F werden uebersetzt | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: deutscher Beispieltext mit Umlauten, scharfem s und Euro | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: eine Ersetzung darf das Ergebnis nicht erneut ersetzen | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: Zeichen werden unabhaengig von ihren Nachbarn uebersetzt | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: ISO-8859-15 (Index 3) wird nach CP1252 uebersetzt | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: Rueckgabewert ist die Laenge des Ergebnisses | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: ein Emoji (vier Byte) faellt ersatzlos weg | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: kyrillisch und hebraeisch werden zu '?' | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: chinesisch, japanisch und koreanisch werden zu '?' | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: Zeichen ohne CP1252-Entsprechung bekommen den nahen Verwandten | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: jedes BMP-Zeichen wird zu genau einem Byte, nie zu Bytesalat | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: deutscher Newsletter mit Anfuehrung, Gedankenstrich, Euro und Emoji | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: ungueltiges UTF-8 wird nicht zu Fragezeichen zerredet | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: bei abgeschnittenem Zeichen faellt die Tabelle ein | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: das Ergebnis ist nie laenger als die Eingabe | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslate: ISO-8859-15 laesst die Bytes 0x80..0x9F unveraendert | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOIncompleteUTF8Tail: angefangenes Zeichen wird gezaehlt | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOIncompleteUTF8Tail: vollstaendiges Zeichen wird nicht zurueckgehalten | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOIncompleteUTF8Tail: getrenntes Zeichen wird ueber die Stueckgrenze heil | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOIsUTF8Charset: erkennt genau den UTF-8-Index | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslateChunk: Grenze mitten im Zeichen | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslateChunk: Drei- und Vierbytezeichen ueber die Grenze | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslateChunk: Nicht-UTF-8 bleibt unangetastet | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslateChunk: angefangenes Zeichen am Ende faellt weg | ok |
| utils.cpp - Verhalten von ISOTranslate() | ISOTranslateChunk: das Byte hinter dem Stueck bleibt unangetastet | ok |
| hexbin.cpp - BinHex-4.0-Dekodiertabelle | HexBinTable: die 64 Alphabetzeichen liefern ihren 6-Bit-Wert | ok |
| hexbin.cpp - BinHex-4.0-Dekodiertabelle | HexBinTable: ':' beendet, CR und LF werden ueberlesen | ok |
| hexbin.cpp - BinHex-4.0-Dekodiertabelle | HexBinTable: jedes Byte ausserhalb des Alphabets ist FAIL | ok |
| hexbin.cpp - BinHex-4.0-Dekodiertabelle | HexBinTable: jeder 6-Bit-Wert 0x00..0x3F kommt genau einmal vor | ok |
| OTShim_Bild - Rechenmethoden von SECImage | SECImage::CalcBytesPerLine: nachgerechnete Werte | ok |
| OTShim_Bild - Rechenmethoden von SECImage | SECImage::CalcBytesPerLine: Vielfaches von 4, kleinste passende Laenge | ok |
| OTShim_Bild - Rechenmethoden von SECImage | SECImage::CalcPadding liefert dasselbe wie CalcBytesPerLine | ok |
| OTShim_Bild - Rechenmethoden von SECImage | SECImage::LastByte: Zeilenlaenge OHNE Auffuellung | ok |
| OTShim_Bild - Rechenmethoden von SECImage | PADWIDTH stimmt mit CalcBytesPerLine ueberein (der QCPng-Weg) | ok |
| OTShim_Bild - Rechenmethoden von SECImage | SECImage::NumBytes/NumColors: leeres Bild und angelegter DIB | ok |
| OTShim_Bild - DIB anlegen, kopieren, speichern, laden | OTShimDibAnlegen: Feldsatz und BITMAPINFOHEADER | ok |
| OTShim_Bild - DIB anlegen, kopieren, speichern, laden | OTShimDibAnlegen: Breite/Hoehe 0 und Ueberlaufschutz | ok |
| OTShim_Bild - DIB anlegen, kopieren, speichern, laden | OTShimDibAnlegen mehrfach auf demselben Objekt | ok |
| OTShim_Bild - DIB anlegen, kopieren, speichern, laden | SECImage::CopyImage: Masse, Daten und Randfaelle | ok |
| OTShim_Bild - DIB anlegen, kopieren, speichern, laden | SECDib 7x5: von Hand geschrieben, ueber GDI+ gelesen, byte-gleich | ok |
| OTShim_Bild - DIB anlegen, kopieren, speichern, laden | SECDib 4x3: von Hand geschrieben, ueber GDI+ gelesen, byte-gleich | ok |
| OTShim_Bild - DIB anlegen, kopieren, speichern, laden | SECDib 1x1: von Hand geschrieben, ueber GDI+ gelesen, byte-gleich | ok |
| OTShim_Bild - DIB anlegen, kopieren, speichern, laden | SECImage::SaveImage auf einem leeren Bild liefert FALSE | ok |
| OTShim_Bild - DIB anlegen, kopieren, speichern, laden | SECDib::LoadImage auf Nichtbild-Daten liefert FALSE | ok |
| OTShim_Bild - DIB anlegen, kopieren, speichern, laden | SECImage: FlipHorz/FlipVert/Rotate90/Crop/UnPadBits melden sich ohne Dialog | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase::AddTab haengt hinten an, GetTabCount zaehlt mit | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase::InsertTab: Index vorne, mittig, hinten und ausserhalb | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase::GetTabInfo gibt alle fuenf Angaben zurueck | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase: Beschriftung NULL beim Einfuegen und beim Umbenennen | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase: der erste Reiter wird aktiv, ohne Wechselmeldung | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase: Einfuegen vor dem aktiven Reiter verschiebt dessen Index | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase::DeleteTab: Liste und aktiver Index | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase::DeleteTab: der aktive Reiter mittendrin | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase::FindTab und TabExists | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase::ActivateTab meldet den Wechsel genau einmal | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase::ActivateTab ist untaetig, wenn der Reiter schon obenauf liegt | ok |
| OTShim_Reiter - Listenpflege von SECTabControlBase | SECTabControlBase: die Auswahlmarke folgt genau dem aktiven Reiter | ok |
| OTShim_Reiter - SEC3DTabControl | SEC3DTabControl::CreateNewTab legt SEC3DTab an, nicht SECTab | ok |
| OTShim_Reiter - SEC3DTabControl | SEC3DTabControl::SetTabIcon legt den Griff am Reiter ab | ok |
| OTShim_Reiter - SEC3DTabControl | SEC3DTabControl::EnableTab und IsTabEnabled | ok |
| OTShim_Reiter - SEC3DTabControl | SEC3DTabControl::GetTabRect und TabHit arbeiten auf m_rect | ok |
| OTShim_Reiter - SEC3DTabControl | SEC3DTabControl: Zeichen- und Blaetterwege ohne Fenster sind folgenlos | ok |
| OTShim_Reiter - Befunde | BEFUND: ActivateTab und ClearSelection fassen GetParent an, bevor sie das Fenster pruefen | ok |
| OTShim_Palette - SECDateTimeCtrl | SECDateTimeCtrl: Vorgabewerte eines frisch angelegten Feldes | ok |
| OTShim_Palette - SECDateTimeCtrl | SECDateTimeCtrl::SetFormat merkt die Zeichenkette auch ohne Fenster | ok |
| OTShim_Palette - SECDateTimeCtrl | SECDateTimeCtrl::SetFormat: die vier Formatarten und ihre Zeichenketten | ok |
| OTShim_Palette - SECDateTimeCtrl | SECDateTimeCtrl::SetMinMax und GetMinMax: Rundlauf | ok |
| OTShim_Palette - SECDateTimeCtrl | SECDateTimeCtrl::Validate prueft nur, wenn eine Pruefart gesetzt ist | ok |
| OTShim_Palette - SECDateTimeCtrl | SECDateTimeCtrl::SetDateTime nimmt nur an, was Validate durchlaesst | ok |
| OTShim_Palette - SECDateTimeCtrl | SECDateTimeCtrl::SetDate und SetTime aendern nur ihre Haelfte | ok |
| OTShim_Palette - SECDateTimeCtrl | SECDateTimeCtrl::SetModified/IsModified: beide Haelften einzeln | ok |
| OTShim_Palette - SECDateTimeCtrl | SECDateTimeCtrl: Schnelleingabe, gesperrte Felder und Fuellzeichen gehen hin und zurueck | ok |
| OTShim_Palette - SECDateTimeCtrl | SECSetOleDateTime setzt den Wert und meldet Fehler | ok |
| OTShim_Palette - SECDateTimeCtrl | SECTmFromOleDate rechnet in die Felder von struct tm um | ok |
| OTShim_Palette - SECDateTimeCtrl | SECDateTimeCtrl: die fensterbezogenen Wege sind ohne Fenster folgenlos | ok |
| OTShim - Anordnungsrechnung von SECControlBar | SECControlBar: Vorgabewerte einer frisch angelegten Leiste | ok |
| OTShim - Anordnungsrechnung von SECControlBar | SECControlBar::CalcFixedLayout liefert die gespeicherten Masse | ok |
| OTShim - Anordnungsrechnung von SECControlBar | SECControlBar::CalcFixedLayout faellt ohne Masse auf die MFC-Fassung zurueck | ok |
| OTShim - Anordnungsrechnung von SECControlBar | SECControlBar::CalcDynamicLayout: LM_HORZDOCK und LM_VERTDOCK | ok |
| OTShim - Anordnungsrechnung von SECControlBar | SECControlBar::CalcDynamicLayout: der Schwebe-Zweig zieht an einem Rand | ok |
| OTShim - Zustand sichern und zuruecklesen | SECControlBar: GetBarInfo und SetBarInfo fuehren den Zustand verlustfrei hin und zurueck | ok |
| OTShim - Zustand sichern und zuruecklesen | SECControlBar: der Ablauf aus WazooBarMgr.cpp - nur die Andockhoehe aendern | ok |
| OTShim - Zustand sichern und zuruecklesen | SECControlBar: Get/SetBarInfo mit NULL tun nichts und stuerzen nicht ab | ok |
| OTShim - Zeilenlogik von SECDockBar | SECDockBar: NextBarThisRow und PrevBarThisRow bleiben in ihrer Zeile | ok |
| OTShim - Zeilenlogik von SECDockBar | SECDockBar::IsNewBar und BarIsNewToThisRow | ok |
| OTShim - Zeilenlogik von SECDockBar | SECDockBar: PredictInsertPosition und CalcDockingLayout sind als offen gekennzeichnet | ok |
| OTShim_Werkzeugleiste - Rechenhilfen | SECConvertDialogUnitsToPixels rechnet mit der Windows-Regel 4 und 8 | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: FindMIMECharset liefert die Indizes, die ISOTranslate erwartet | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP und IMAP: der Index wird um eins verschoben - sonst greift die falsche Tabelle | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: Betreff, Base64 ueber UTF-8 kodiert | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: Betreff, Quoted-Printable ueber UTF-8 kodiert | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: Betreff in ISO-8859-1 wird dekodiert, aber nicht uebersetzt | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: kodiertes Wort mitten in einer Kopfzeile | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: zwei aufeinanderfolgende kodierte Woerter | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: kodierte Woerter ueber eine Faltung hinweg (E-94) | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | IMAP: kodierte Woerter ueber eine Faltung hinweg (E-94) | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP und IMAP: Faltung vor Klartext bleibt Leerraum (Gegenprobe zu E-94) | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: der Absendername wird wie der Betreff behandelt | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: unbrauchbare kodierte Woerter bleiben stehen | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: Nachrichtentext in UTF-8 wird zeilenweise uebersetzt | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: TextReader::ReadIt uebernimmt die neue Laenge von ISOTranslate | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: eine Nachricht ohne Betreff bringt den Kopfzeilenpfad nicht durcheinander | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: eine sehr lange Kopfzeile wird vollstaendig dekodiert | ok |
| POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext | POP: eine ganze RETR-Antwort mit UTF-8-Umlauten | ok |
| Befund E-30 - Werkzeugleistensymbole und gesperrte Knoepfe | E-30: OTShimDibFarbeErsetzen trifft genau die gesuchte Farbe | ok |
| Befund E-30 - Werkzeugleistensymbole und gesperrte Knoepfe | E-30: OTShimDibFarbeErsetzen kann auch 32 Bit | ok |
| Befund E-30 - Werkzeugleistensymbole und gesperrte Knoepfe | E-30: OTShimDibFarbeErsetzen weist ab, was es nicht kann | ok |
| Befund E-30 - Werkzeugleistensymbole und gesperrte Knoepfe | E-30: 24-Bit-Leiste bekommt beim Laden die Knopffarbe | ok |
| Befund E-30 - Werkzeugleistensymbole und gesperrte Knoepfe | E-30: 8-Bit-Leiste geht weiter ueber comctl32 | ok |
| Befund E-30 - Werkzeugleistensymbole und gesperrte Knoepfe | E-30: passender Bildhintergrund ergibt ein gepraegtes Symbol | ok |
| Befund E-30 - Werkzeugleistensymbole und gesperrte Knoepfe | E-30: unpassender Bildhintergrund ergibt eine leere Flaeche | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-88: unveraendert weitergeleitet - das Original geht hinaus | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-88: ein Satz davor - Original bleibt, Zusatz kommt mit | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-88: eine Signatur dahinter - Original bleibt, Signatur kommt mit | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-88 Gegenprobe: im Zitat geaendert - die Editor-Fassung bleibt | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-88 Gegenprobe: mitten im Zitat geloescht - Editor-Fassung bleibt | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-88 Gegenprobe: ForwardOriginalHTML=0 schaltet wirklich ab | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-88 Gegenprobe: kein Original gemerkt - Editor-Fassung bleibt | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-88 Gegenprobe: ein reiner Textrumpf wird nicht angefasst | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-88: andere Umbrueche und Entitaeten kippen die Entscheidung nicht | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-88: die Spurmarke wird in jedem Fall geschrieben | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-93: ohne Tastendruck geht das Original hinaus, auch ohne Fund | ok |
| Befund E-88 - Original-HTML statt Editor-Fassung | E-93 Gegenprobe: MIT Tastendruck bleibt die Editorfassung | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: Groesse nur im CSS - width und height werden ergaenzt | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89 Gegenprobe: width und height schon als Attribut - nichts wird angefasst | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: gar keine Groessenangabe - das Bild bleibt unangetastet | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: breiter als der Deckel - wird gestutzt, die Hoehe geht proportional mit | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: zu breit, Hoehe unbekannt - gestutzt wird nur die Breite, kein height="1" | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: zu hoch, Breite unbekannt - gestutzt wird nur die Hoehe, kein width="1" | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: width mitten im style zwischen anderen Eigenschaften | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89 Gegenprobe: max-width darf nicht als width durchgehen | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: Prozentbreite bleibt Prozent - Paige kann sie | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89 Gegenprobe: Prozenthoehe wird NICHT zur Pixelzahl | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89 Gegenprobe: em und auto werden nicht als Pixel gelesen | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: Grossschreibung und Leerraum im style | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: kaputtes HTML - kein Absturz, kein Lauf ueber das Ende | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: ein '>' im alt-Text beendet die Markierung nicht | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89 Gegenprobe: eine Nachricht ohne Bild kommt Byte fuer Byte durch | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89 mit E-88: die Umschrift ist fuer den Vergleich unsichtbar | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89 Gegenprobe zu (10): ein Platzhalter WUERDE E-88 zerreissen | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: mehrere Bilder in einer Nachricht - jedes einzeln | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-89: das schliessende / einer XHTML-Markierung bleibt erhalten | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-95: eingebettetes Bild ohne Groesse bleibt unangetastet | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-95 Gegenprobe: eingebettetes Bild MIT CSS-Groesse wird umgeschrieben | ok |
| Befund E-89 - lesbare Bilder im Verfassenfenster | E-95: externes Bild ohne Groesse bleibt ebenfalls unangetastet | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101: selbst verfasst - Content-Type wird ergaenzt | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101: der interne Marker <x-html> verlaesst das Haus nicht | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 Gegenprobe: vorhandener Content-Type bleibt unangetastet | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101: ohne Marker und ohne Hochbyte - text/plain, us-ascii | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101: zitiertes Content-Type im Rumpf taeuscht nicht | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 zweiter Teil: ohne Kopfzeilen bekommt HTML trotzdem seinen Content-Type | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 Gegenprobe zum zweiten Teil: reiner ASCII-Text ohne Kopfzeilen bleibt unberuehrt | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 zweiter Teil: Hochbyte ohne Kopfzeilen bekommt seinen Zeichensatz | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 P-18: <x-html mitten im Text ist kein Marker | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 P-19: zitiertes </x-html> ist nicht das Gegenstueck | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 P-18: > im Attributwert laesst keinen Rest stehen | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 P-20: fuehrende Leerzeile geht nicht verloren | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 P-22: ohne Leerzeile meldet die Spurmarke trenner=0 | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 P-21: gemischter Trenner laesst kein   im Kopf stehen | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 P-28: Marker und Text auf derselben Zeile - Rumpf bleibt | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 P-28: Marker ohne Gegenstueck, Text auf derselben Zeile | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 P-28: > im Attributwert beendet das Tag nicht | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 dritter Teil: multipart-Kopf ueber einteiligem Rumpf wird ersetzt | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 dritter Teil: ohne Kopfzeilen wird das <meta> trotzdem berichtigt | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 dritter Teil Gegenprobe: passender Kopf und passendes <meta> bleiben | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 dritter Teil: Klartext mit falschem Zeichensatz im Kopf | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101: leere Eingabe aendert nichts und stuerzt nicht ab | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 F1: echte mehrteilige Nachricht bleibt unangetastet | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 F3: windows-1251 im Kopf bleibt stehen | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 F3: koi8-r und iso-8859-2 ebenso | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 F4: <meta charset=windows-1251> bleibt stehen, auch ohne Kopfzeilen | ok |
| Befund E-101 - was Speichern unter in die Datei schreibt | E-101 F3 Gegenprobe: ein falsches UTF-8 wird weiter berichtigt | ok |
| E-110: resolve_URL und die Prozent-Sequenzen | E-110: %20 wird zum Leerzeichen, nicht weggeworfen | ok |
| E-110: resolve_URL und die Prozent-Sequenzen | E-110: mehrere %20 hintereinander, dazu Klammern | ok |
| E-110: resolve_URL und die Prozent-Sequenzen | E-110: %C3%BC - der Fehler traf jede Sequenz, nicht nur %20 | ok |
| E-110: resolve_URL und die Prozent-Sequenzen | E-110: resolve_URL liefert dasselbe wie unescape_url | ok |
| E-110: resolve_URL und die Prozent-Sequenzen | E-110: eine Adresse ohne Prozentzeichen bleibt unveraendert | ok |
| E-110: resolve_URL und die Prozent-Sequenzen | E-110: Prozentzeichen am Ende laeuft nicht ueber | ok |
| E-110: resolve_URL und die Prozent-Sequenzen | E-110: nMaxLength wird eingehalten, auch mit Sequenzen | ok |
| E-110: resolve_URL und die Prozent-Sequenzen | E-117: &amp; im src wird zu & - sonst liefert der Bilddienst 1x1 | ok |
| E-110: resolve_URL und die Prozent-Sequenzen | E-111: entartete Feldgroessen schreiben nicht hinaus | ok |
| E-112: das Zielrechteck eines Bildes | E-112: Datei groesser als angegeben - die ANGABE gewinnt | ok |
| E-112: das Zielrechteck eines Bildes | E-103 bleibt: ohne Angabe gewinnt die Datei | ok |
| E-112: das Zielrechteck eines Bildes | E-112: halbe Angabe - die fehlende Seite folgt dem Seitenverhaeltnis | ok |
| E-112: das Zielrechteck eines Bildes | E-112: die Angabe gewinnt auch bei kleinerer Datei | ok |
| E-112: das Zielrechteck eines Bildes | E-112: nichts bekannt - 0x0, der Aufrufer laesst alles stehen | ok |
| E-112: das Zielrechteck eines Bildes | E-112: negative Masse zaehlen nicht als Angabe | ok |
| E-112: das Zielrechteck eines Bildes | E-112: Nullzeiger stuerzt nicht ab | ok |
| E-69: die Meldungsflut in Task Errors | E-69 A: 500 uebersprungene ergeben 1 Eintrag + 1 Sammeleintrag | ok |
| E-69: die Meldungsflut in Task Errors | E-69 A: ein einziger Fall ergibt genau einen Eintrag | ok |
| E-69: die Meldungsflut in Task Errors | E-69 A: ein Lauf ohne Zwischenfall meldet nichts | ok |
| E-69: die Meldungsflut in Task Errors | E-69 A: der zweite Lauf faengt wieder bei null an | ok |
| E-69: die Meldungsflut in Task Errors | E-69 A: geschachtelte Laeufe - nur der aeusserste zaehlt ab | ok |
| E-69: die Meldungsflut in Task Errors | E-69 A Gegenprobe: ohne Klammer bleibt es beim alten Verhalten | ok |
| E-69: die Meldungsflut in Task Errors | E-69 B: der erste Fehler ist immer laut | ok |
| E-69: die Meldungsflut in Task Errors | E-69 B: im Fenster bleibt es still, danach wieder laut | ok |
| E-69: die Meldungsflut in Task Errors | E-69 B: Fenstergrenze und Ueberlauf von GetTickCount | ok |
| E-69: die Meldungsflut in Task Errors | E-69 A / R1: nach einem Lauf meldet dieselbe Sammlung weiter | ok |
| E-69: die Meldungsflut in Task Errors | E-69 A / R1: die Zahl im Sammeleintrag addiert sich nicht auf | ok |
| E-131: ungueltige Schwebeposition in der Eudora.ini | E-131: INT_MIN ist keine brauchbare Position | ok |
| E-131: ungueltige Schwebeposition in der Eudora.ini | E-131 Gegenprobe: gewoehnliche Positionen bleiben unangetastet | ok |
| E-131: ungueltige Schwebeposition in der Eudora.ini | E-131: teilweise ausserhalb ist erlaubt, ganz draussen nicht | ok |
| E-131: ungueltige Schwebeposition in der Eudora.ini | E-131: zweiter Bildschirm links - negatives x ist gueltig | ok |
| E-131: ungueltige Schwebeposition in der Eudora.ini | E-131: ohne Bildschirmmass wird nichts verworfen | ok |
| E-131: ungueltige Schwebeposition in der Eudora.ini | E-131: beliebiger Muellwert, nicht nur INT_MIN (Issue #102) | ok |
| E-131: ungueltige Schwebeposition in der Eudora.ini | E-131: die Grenze nach oben liegt bei -1194 | ok |
| E-132: fremdes Mailverzeichnis beim Start | E-132: fremdes Verzeichnis mit eigener Einrichtung wird erkannt | ok |
| E-132: fremdes Mailverzeichnis beim Start | E-132 Gegenprobe: das eigene Verzeichnis gilt nicht als fremd | ok |
| E-132: fremdes Mailverzeichnis beim Start | E-132: Schreibweise des Pfades aendert nichts | ok |
| E-132: fremdes Mailverzeichnis beim Start | E-132: ohne Eudora.ini wird nicht gefragt | ok |
| E-132: fremdes Mailverzeichnis beim Start | E-132: ohne Angaben wird nicht gefragt | ok |
| E-132: fremdes Mailverzeichnis beim Start | E-132: Befehlszeile aus der Registry wird zerlegt | ok |
| E-132: fremdes Mailverzeichnis beim Start | E-132: zerlegt und entschieden - der gemeldete Fall | ok |
| E-132: fremdes Mailverzeichnis beim Start | E-132: Kurzform und Langform, der Fall vom 21.10.2026 | ok |
| E-132: fremdes Mailverzeichnis beim Start | E-132: der Praefix allein genuegt nicht | ok |
| E-112: die Metadatei hat die Groesse, in der das Bild erscheinen soll | E-112: angegeben 35x35, Datei 330x327 - gemalt werden 35x35 | ok |
| E-112: die Metadatei hat die Groesse, in der das Bild erscheinen soll | E-112: angegeben 250x96, Datei 985x378 - gemalt werden 250x96 | ok |
| E-112: die Metadatei hat die Groesse, in der das Bild erscheinen soll | E-103: ohne Groessenangabe wird die Datei in ihrer eigenen Groesse gemalt | ok |
| E-112: die Metadatei hat die Groesse, in der das Bild erscheinen soll | E-112: nur die Breite angegeben - gemalt wird, was die Regel sagt | ok |
| E-112: die Metadatei hat die Groesse, in der das Bild erscheinen soll | E-112: unbrauchbare Eingaben liefern keine Metadatei | ok |
| E-105: versteckte Abschnitte (display:none) | E-105: die Handyfassung aus Gregors freenet-Newsletter wird verschluckt | ok |
| E-105: versteckte Abschnitte (display:none) | E-105 Gegenrichtung: die Desktopfassung bleibt sichtbar | ok |
| E-105: versteckte Abschnitte (display:none) | E-105: Schreibweisen von display:none | ok |
| E-105: versteckte Abschnitte (display:none) | E-105: alles im versteckten Bereich, verschachtelt, danach wieder sichtbar | ok |
| E-105: versteckte Abschnitte (display:none) | E-105: leere Elemente oeffnen keinen Bereich | ok |
| E-105: versteckte Abschnitte (display:none) | E-105 Schutz: ein nie geschlossenes Element verschluckt nicht den Rest | ok |
| E-105: versteckte Abschnitte (display:none) | E-105 Schutz: implizite Enden von td, tr, li und Vorfahren-Ende | ok |
| E-116: Bildbreite aus <img width=...> (decimal_value_percent) | E-116: Einheit und Nachkommastelle beenden die Zahl | ok |
| E-116: Bildbreite aus <img width=...> (decimal_value_percent) | E-116 Gegenrichtung: was vorher stimmte, stimmt weiter | ok |
| E-116: Bildbreite aus <img width=...> (decimal_value_percent) | E-116 Gegenrichtung: fuehrende Leerzeichen und Tabs werden uebersprungen | ok |
| E-113: Bilder auf die Breite des Textbereichs deckeln | E-113: zu breites Bild wird seitenverhaeltnistreu verkleinert | ok |
| E-113: Bilder auf die Breite des Textbereichs deckeln | E-113 Gegenrichtung: was passt, bleibt; ohne Grenze nichts | ok |
| E-77: IMAP-Postfachnamen in modifiziertem UTF-7 | E-77: Gregors Ordner von GMX, hin und zurueck | ok |
| E-77: IMAP-Postfachnamen in modifiziertem UTF-7 | E-77 Gegenrichtung: ASCII und & bleiben, Unbekanntes bleibt roh | ok |
| E-118: HTML-Huelle beim Hochladen in einen IMAP-Ordner | E-118: die Huelle einer empfangenen HTML-Mail wird erkannt und abgestreift | ok |
| E-118: HTML-Huelle beim Hochladen in einen IMAP-Ordner | E-118: Schreibweisen und Vorspann | ok |
| E-118: HTML-Huelle beim Hochladen in einen IMAP-Ordner | E-118 Gegenrichtung: Text ohne Huelle bleibt Text | ok |
| E-118: HTML-Huelle beim Hochladen in einen IMAP-Ordner | E-118: Zeichensatz noetig, sobald ein Byte ueber 0x7F steht | ok |
| E-118: HTML-Huelle beim Hochladen in einen IMAP-Ordner | E-118: Text hinter der Huelle geht nicht verloren | ok |
| E-118: HTML-Huelle beim Hochladen in einen IMAP-Ordner | E-118: das eingebettete Bild findet seinen Verweis im HTML | ok |
| E-24: unter "Recent" stand "In" zweimal | E-24: gleicher Inhalt in verschiedenen Puffern gilt als gleich | ok |
| E-24: unter "Recent" stand "In" zweimal | E-24 Gegenprobe: verschiedene Postfaecher bleiben verschieden | ok |
| E-24: unter "Recent" stand "In" zweimal | E-24: Nullzeiger werfen den Vergleich nicht um | ok |
| E-24: unter "Recent" stand "In" zweimal | E-24: der Ersatzeintrag wird als derselbe erkannt | ok |
| E-24: unter "Recent" stand "In" zweimal | E-24: frisches Mailverzeichnis - "In" steht danach genau einmal | ok |
| E-24: unter "Recent" stand "In" zweimal | E-24: eine schon doppelte Liste wird vollstaendig geheilt | ok |
| E-24: unter "Recent" stand "In" zweimal | E-24 Gegenprobe: ein fremdes Postfach laesst die Liste unberuehrt | ok |
| E-24: unter "Recent" stand "In" zweimal | E-24: QCMailboxDirector.cpp benutzt die Vergleichsfunktionen | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | NP3-8: der alte IMAP-Weg uebersetzte KEINEN einzigen Zeichensatz | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | NP3-8: mit FindMIMECharset rechnet IMAP auf derselben Skala wie POP | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | NP3-8 Gegenprobe: us-ascii, Latin-1 und windows-* bleiben unberuehrt | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | NP3-8: ImapDownload.cpp rechnet mit der Skala von FindMIMECharset | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | NP3-9: ISOTranslate liefert die NEUE Laenge, und sie ist kuerzer | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | NP3-9: beide Aufrufstellen nehmen den Rueckgabewert entgegen | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | Z-2: die Zwischendatei sagt windows-1252 an, Byte fuer Byte | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | Z-2 Gegenprobe: die Modusansage davor traegt keinen Zeichensatz | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | Z-2: die Ansage steht vor dem Stylesheet, fremde Ansagen fliegen raus | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | Z-2B: Gregors Zeile kommt ueber die Stueckgrenze heil an | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | Z-2B: das Ergebnis haengt nicht davon ab, wo das Stueck endet | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | Z-2B Gegenprobe: ohne UTF-8 bleibt jedes Byte stehen | ok |
| NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben | Z-2B: TextReader haelt das angefangene Zeichen zurueck | ok |
| E-11, E-12 und E-17: drei Befunde aus dem Programmstart | E-11: Truncate kuerzt und laesst die geteilte Kopie heil | ok |
| E-11, E-12 und E-17: drei Befunde aus dem Programmstart | E-11: RegMailto wird mit Truncate gekuerzt, nicht mit ReleaseBuffer | ok |
| E-11, E-12 und E-17: drei Befunde aus dem Programmstart | E-12: ein Verzeichnis als Ini-Pfad liefert jede Einstellung als Vorgabe | ok |
| E-11, E-12 und E-17: drei Befunde aus dem Programmstart | E-12: GetFileAttributes trennt Verzeichnis und Dateiname | ok |
| E-11, E-12 und E-17: drei Befunde aus dem Programmstart | E-12: "C:Name" ist laufwerksrelativ, nicht absolut - GetLongPathName merkt das nicht | ok |
| E-11, E-12 und E-17: drei Befunde aus dem Programmstart | E-12: GetDirs fragt das Dateisystem, bevor es den Namen deutet | ok |
| E-11, E-12 und E-17: drei Befunde aus dem Programmstart | E-17: in Gregors Ini ist [Settings] leer und das Konto benannt | ok |
| E-11, E-12 und E-17: drei Befunde aus dem Programmstart | E-17: die Startpruefung fragt alle Persoenlichkeiten, nicht nur [Settings] | ok |
| E-125: Ziehen nach Out wird abgelehnt statt eine neue Nachricht anzulegen | E-125: Ziehen einer empfangenen Nachricht nach Out wird abgelehnt (Stelle im Quelltext) | ok |
| E-125: Ziehen nach Out wird abgelehnt statt eine neue Nachricht anzulegen | E-125: der Hinweisdialog ist eine Ressource und keine Frage | ok |
| E-130: Fremd-DLLs bleiben ungebunden | E-130: keine der zwoelf Fremd-DLLs in Bin\Release ist gebunden | ok |
| E-130: Fremd-DLLs bleiben ungebunden | E-130: BindExe.bat bindet keine Fremd-DLL | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-20: InsertArr hinter dem Ende (nIdx > nLen) bleibt im Feld | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-20: InsertArr in der Mitte und am Ende verschiebt richtig | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-20: NotifyInsertedCol hinter dem Feldende bleibt in allen vier Feldern | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-150: DeleteArr in der Mitte und am Ende loescht richtig | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-150: DeleteArr hinter dem Feldende laesst das Feld unberuehrt | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-150: NotifyDeletedCol hinter dem Feldende (Task-Status-Weg) | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-99: der Merker 'Anwender hat getippt' rastet ein und wird uebergeben | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-18: pFld wird vor dem Zugriff auf NULL geprueft | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-25: LocateNetscapePrefsFile gibt den Knoten des Aufrufers nicht frei | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-31 (Ursache von E-27): pg_time_t ist fest 32 Bit breit | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-137: Strg-W in einer Wazoo-Leiste versteckt nur die Leiste, vor jeder Weitergabe | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-137: ein Klick irgendwo in eine Wazoo-Leiste gibt ihr den Tastaturfokus | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-137: ein Klick auf Titelzeile oder Rand einer schwebenden Leiste gibt ihr den Tastaturfokus | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-137: der letzte Klick in eine Wazoo-Leiste oder auf ihren schwebenden Rahmen wird gemerkt | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | ZIEL 2/4: Ausnahmen aus Fensterbotschaften landen im eudora.log | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | ZIEL 4 / E-154: Ausnahmen ausserhalb von Fensterbotschaften landen im eudora.log | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | E-142: Hinweis beim Ziehen eines Entwurfs aus einem IMAP-Ordner nach Out | ok |
| Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests) | rootcerts.p7b: eudora.log nennt das Verzeichnis, aus dem QCSSL die Liste geladen hat | ok |
| E-146 Umbenennen: ein Name fuer Server und Eudora, Rueckweg bei Ablehnung | E-146 K8: RenameMailbox gibt den Servernamen zurueck, UpdateAfterRename fuehrt ihn | ok |
| E-146 Umbenennen: ein Name fuer Server und Eudora, Rueckweg bei Ablehnung | E-146 K9: lehnt der Server ab, wird die Ordnerliste neu gelesen | ok |
| E-146 Umbenennen: ein Name fuer Server und Eudora, Rueckweg bei Ablehnung | E-119: ein data:-Bild ueber 64 KB kommt mit seiner vollen Laenge an | ok |
| E-146 Umbenennen: ein Name fuer Server und Eudora, Rueckweg bei Ablehnung | E-158: Weiterleiten einer Textmail haengt kein </x-html> an (E-88 nur bei HTML-Mails) | ok |
| E-146 Umbenennen: ein Name fuer Server und Eudora, Rueckweg bei Ablehnung | E-160: ohne Outlook-Eintraege laedt der Kontoassistent kein MAPI | ok |
| E-77 Umbenennen: gefuehrter Name gleich Servername (Quelltext) | E-77 K1: UpdateAfterRename fuehrt den Namen, der an den Server ging | ok |
| E-77 Umbenennen: gefuehrter Name gleich Servername (Quelltext) | E-77 K2: RenameMailbox kodiert an allen fuenf Stellen, INBOX eingeschlossen | ok |
| Startfehler S-2 (Regressionstests) | S-2: die Werbeleiste wird in unserem Bau nicht angelegt | ok |
| E-148: keine kompromittierten Wurzelzertifikate im Paket | E-148: Releases\1.0\rootcerts.p7b enthaelt keine eMudhra-Wurzel | ok |
| E-148: keine kompromittierten Wurzelzertifikate im Paket | E-148: paket-bauen.ps1 legt rootcerts.p7b aus Releases\1.0 ueber die Grundlage | ok |

</details>

## 2. Schranken mit Rueckfallprobe

Eine Schranke im `pre-commit` zaehlt nur als Regressionstest, wenn sie ihren
Rueckfall abweist: die Behebung wird voruebergehend zurueckgenommen, die
Schranke muss rot werden, danach wird die Datei byte-genau wiederhergestellt
(`tools/schranken-gegenprobe.pl`, Liste in `tools/regression-schranken.txt`).
Gelaufen am **2026-10-27 12:37** gegen Commit `1cf3d242*`.

| Befund | Schranke | Ergebnis | gemessen |
|---|---|---|---|
| E-42 | `pruefe-beenden.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-41 | `pruefe-beenden.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-40 | `pruefe-beenden.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-45 | `pruefe-beenden.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-62 | `pruefe-nachrichtenschleife.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-62#2 | `pruefe-nachrichtenschleife.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-61 | `pruefe-nachrichtenschleife.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-34 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-35 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-35#2 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-35#3 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-35#4 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-16 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-36 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-68 | `pruefe-filter-aktionsgrenze.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-73 | `pruefe-filter-serverloeschung.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-74 | `pruefe-filter-serverloeschung.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-43 | `pruefe-waechter.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-51 | `pruefe-nachrichtenschleife.pl` | ok | vorher=0 rueckfall=1 danach=0 |

## 3. Regressionstests ueber die Oberflaeche (Pruefstand)

Je Fall der **letzte** Lauf. *Bau* ist die Kennung aus der `Eudora.exe` des
Pruefstands (Fassung, Paket, Commit; ein `*` heisst: mit uncommitteten
Aenderungen gebaut). Ein Fall, der an einer anderen Fassung als `7.2.0.126`
lief, zaehlt fuer diesen Stand nicht als gruen.

| Fall | Ergebnis | gelaufen am | Pruefstand | Bau | erwartet |
|---|---|---|---|---|---|
| E-131a | ok | 2026-10-27 12:37:32 | `C:\Temp\E131L` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `ohne MRUFloatXPos=-2147483648` |
| E-131b | ok | 2026-10-27 12:37:32 | `C:\Temp\E131L` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `ohne MRUFloatYPos=-2147483648` |
| E-131c | ok | 2026-10-27 12:37:32 | `C:\Temp\E131L` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-131 Leistenposition:` |
| E-121 | ok | 2026-10-27 12:37:32 | `C:\Temp\E118` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `ablage-dateien=1` |
| E-118 | ok | 2026-10-27 12:37:32 | `C:\Temp\E118` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-118 Bild:` |
| E-125a | ok | 2026-10-27 12:37:32 | `C:\Temp\E125` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E125 ERGEBNIS out=1 trash=0 (vorher 1) dialoge-gegenprobe=0` |
| E-125b | ok | 2026-10-27 12:37:32 | `C:\Temp\E125` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E125 UMKEHR in=1 (vorher 1) out=1 (vorher 1) dialoge=1` |
| E-125c | ok | 2026-10-27 12:37:32 | `C:\Temp\E125` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-125 Xfer nach Out abgelehnt: quelle=In ziel=Out` |
| E-103p | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-112 Metadatei: angegeben=0x0 Datei=79x64 gemalt=79x64` |
| E-112p | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-112 Metadatei: angegeben=35x35 Datei=330x327 gemalt=35x35` |
| E-112f2 | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-112 Metadatei: angegeben=150x0 Datei=985x378 gemalt=150x58` |
| E-112n1 | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-112 Metadatei: angegeben=600x0 Datei=985x378 gemalt=600x230` |
| E-112h | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-112 Metadatei: angegeben=0x600 Datei=330x327 gemalt=606x600` |
| E-106p | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-106 groesser als angegeben: attr=35x35 quelle=330x327` |
| E-110p | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-110 Laden: src=cid:punkt-rot@e118.invalid faden=1 ok=1` |
| E-105p | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-105 versteckter Bereich <p> ohne eigenes Ende-Tag beendet` |
| E-108p | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `Logging shutdown` |
| BILD-lauf | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `BILD ERGEBNIS abgeholt=8 geoeffnet=8 weitergeleitet=8` |
| E-113p | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `Datei=985x378 gemalt=718x276` |
| E-113b | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `BILD E113B` |
| E-113b2 | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `neu=0 lebt=1 probe=ok` |
| E-119d | ok | 2026-10-27 12:37:32 | `C:\Temp\E119K` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `vollstaendig=1 probe=ok` |
| E-119a | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `data-db1b9f48.png faden=1 ok=1` |
| E-119b | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-119 data-Bild als Datei:` |
| E-119c | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `data-2eaa4a58.png laenge=1574` |
| E-119e | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `laenge=78519` |
| E-77a | ok | 2026-10-27 12:37:32 | `C:\Temp\E77` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E77 ERGEBNIS roh=0 dekodiert=2` |
| E-77b | ok | 2026-10-27 12:37:32 | `C:\Temp\E77` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-77 Ordnername: server="Entw&APw-rfe"` |
| E-77c | ok | 2026-10-27 12:37:32 | `C:\Temp\E77` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E-77 Ordnername: server="Gel&APY-scht"` |
| E-77d | ok | 2026-10-27 12:37:32 | `C:\Temp\E77U` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E77U ERGEBNIS rename=ok liste=Ablage-&AOQ- unbekannt=0` |
| E-146 | ok | 2026-10-27 12:37:32 | `C:\Temp\E146` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E146 ERGEBNIS rename=abgelehnt baum-neu=weg baum-alt=da liste=(kein Eintrag)` |
| E-97 | ok | 2026-10-27 12:37:32 | `C:\Temp\E97` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E97 ERGEBNIS dialog=1 lebt=1 datei=1` |
| E-100 | ok | 2026-10-27 12:37:32 | `C:\Temp\E97` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `E100 ERGEBNIS dialog=1 lebt=1 ini=ok` |
| E-67 | ok | 2026-10-27 12:37:32 | `C:\Temp\E67` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `verb-gespeichert=14 verb-auswahl=0` |
| ZIEL24 | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `Logging shutdown` |
| ZIEL24b | ok | 2026-10-27 12:37:32 | `C:\Temp\EBILD` | Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea 2026-10-27 12:16 | `Logging shutdown` |

## 4. Deckung der kritischen Befunde

Von **70** kritischen Befunden haben **46** einen Test, **22** keinen (gezaehlt von `tools/pruefe-regressionstest.pl`). Ohne Test: S-1 S-8 V-1 AN-1 E-2 E-3 E-23 E-32 E-60 E-64 E-72 E-82 E-120 E-122 E-123 E-124 E-126 E-129 E-156 E-136 E-133 E-39.

Solange diese Zahl nicht null ist, sagt ein gruener Bericht nicht, dass
nichts kaputt ist — er sagt, dass nichts von dem kaputt ist, was geprueft
wird.

## 5. Was dieser Bericht nicht abdeckt

* Die manuellen Faelle in [TESTPLAN.md](../Intern/TESTPLAN.md), Teil M.
* Gregors eigene Ergebnisse am Paket: die Ergebnistabelle im Kopf von
  [TESTPLAN.md](../Intern/TESTPLAN.md) (je Kriterium und Pruefschritt, mit Paketnummer),
  aeltere in der Buchfuehrung darunter.
* Alles, was keinen Test hat (Abschnitt 4).
* Ein Release gilt erst nach **Gregors eigenem Lauf** und seiner Zustimmung
  (CLAUDE.md, Abschnitt 4) — dieser Bericht ersetzt das nicht.
