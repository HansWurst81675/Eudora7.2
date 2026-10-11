# Spurmarken und ihre Auswertung

Eine Spurmarke kostet einen Bau. Ihr Nutzen entsteht erst, wenn jemand das
Protokoll liest. Dazwischen liegt ein Moment, an den sich niemand von selbst
erinnert — deshalb steht er hier, und `tools/spuren-auswerten.pl` erzwingt ihn
beim Bau des nächsten Pakets.

**Der Vorfall, aus dem diese Datei entstanden ist:** die Spurmarken zu **E-70**
lagen seit Paket **1.0.37** im Bau. Ausgewertet wurden sie zum ersten Mal an
**1.0.40**. Dazwischen sind 1.0.38, 1.0.39 und 1.0.40 gebaut und ausgeliefert
worden, jedes mit der Bitte an Gregor, etwas anderes zu prüfen. Als das
Protokoll endlich gelesen wurde, sagte es in zwei Zeilen alles: **40** mal
`E-70 gesichert`, **0** mal `E-70 geladen`. Siehe
[eingebaute-messung-auslesen](../Arbeitsweise/eingebaute-messung-auslesen.md).

## Wie diese Tabelle gepflegt wird

- **Eine Zeile je Befund**, sobald eine `SPURMARKE ZU E-nn` in den Quelltext
  kommt. Die Spalte *eingebaut* nennt die Paketfassung, mit der sie zum ersten
  Mal zu Gregor geht.
- **Nach jeder Rückmeldung von Gregor** wird das Protokoll auf diese Marke hin
  gelesen und das Ergebnis hier eingetragen — die Fassung in *ausgewertet* und
  ein Satz, **was sie gesagt hat**. „Nichts gefunden" ist auch ein Ergebnis und
  gehört hin.
- **Soll eine Marke ohne Auswertung weiterlaufen**, steht in *ausgewertet*
  `entfaellt: <Begründung>`. Damit ist die Lücke schriftlich statt vergessen.
- **Ist die Marke ausgebaut**, darf die Zeile weg; `spuren-auswerten.pl` meldet
  sie dann als verwaist (ohne abzuweisen).

## Die Marken

| Befund | eingebaut | ausgewertet | was sie gesagt hat |
|---|---|---|---|
| E-64 | 1.0.39 | 1.0.41 | jede Nachricht gegen alle drei Filter geprüft, `Match=0` war richtig — die Nachricht kam von einer anderen Adresse, als der Filter suchte. Gregors Urteil: Fehlalarm. Eine ältere Marke zu E-64 liegt seit 1.0.30 an derselben Stelle |
| E-66 | 1.0.35 | 1.0.42 | **über Gregors Urteil statt über das Protokoll.** An 1.0.42: *„1. ja / 2. ja / 3. ja"* zu Balken lässt sich ziehen, rechte Hälfte des Filterfensters erreichbar, Änderungen bleiben stehen. Genau das sollten die Marken klären — sie haben ihren Zweck erfüllt und dürfen ausgebaut werden. Bis dahin schreiben sie bei jedem Zeigerwechsel über einer Leiste eine Zeile |
| E-70 | 1.0.37 | 1.0.40 | 40 Zeilen `E-70 gesichert`, 0 Zeilen `E-70 geladen`. Der Wert wird geschrieben und nie gelesen — der Aufruf stand in `SECToolBarManager::LoadState`, die Eudora nie aufruft. Behoben in 7.2.0.41 |
| E-76 | 1.0.41 | 1.0.48 | **nach sieben Fassungen geliefert.** Auslösen ließ sie sich hier nie — dafür braucht es eine physisch gedrückte Maustaste, dasselbe Hindernis wie bei **E-51**. Gregor hat am 11.09.2026 an 1.0.48 gezogen, und damit stand alles im Protokoll: beim Ziehen `nLength=105`, `172`, `234`, `299` — richtig gerechnet —, und im **letzten** Aufruf `nLength=780 dwMode=0x0042 COMMIT HORZ -> ergebnis=780x100`: `LM_COMMIT|LM_HORZ` **ohne** `LM_LENGTHY`, also der falsche Zweig. Behoben in 7.2.0.49. **Ein zweites Mal geliefert an 1.0.50:** `E-76 fest: vorher=751x403` statt der Anfangsgröße `200x100` war der Beleg, dass **E-84** wirklich sitzt. Sie nennt `nLength`, `dwMode` mit ausgeschriebenen Flags, `IsFloating` und die Maße vorher wie nachher in einer Zeile |
| E-78 | 1.0.43 | entfaellt: geht mit 1.0.44 zum ersten Mal zu Gregor - 1.0.43 lief bei ihm nur mit der Vorgabe LogLevel=25759, bei der die Marke schweigt |
| E-86 | 1.0.54 | 1.0.55 | **Ausgewertet am 14.09.2026 in zwei Messläufen**, beide über `tools/testlauf.ps1` mit `tools/nachricht-oeffnen.ps1` — Gregors Freigabe: *„freigabe für beides"*, *„du mißt, ich warte"*. **Der erste Lauf war ungültig:** das Werkzeug öffnete die erstbeste Nachricht, und das war die weitergeleitete aus dem Out-Postfach — die ist durch E-87 ohnehin formatierungslos (Anzeigedatei 4774 B, `<body>` ohne Attribute). Erst nachdem in der `Eudora.ini` nur noch das In-Postfach als offenes Fenster stand, wurde die richtige Nachricht getroffen. **Was sie sagte:** `BODY-Elemente=1` (es gibt kein verworfenes zweites `<body>`), Anzeigedatei **36.078 B mit allen 118 `border`-Angaben** der Nachricht — beim Zusammensetzen geht nichts verloren. Damit waren beide Verdächte widerlegt und die Ursache lag im **Rendermodus**. **Nach dem Einbau von `X-UA-Compatible`:** dieselbe Marke meldet `Hintergrund=transparent` statt `#ffffff` — der Modus hat gewechselt |
| E-80 | 1.0.45 | 1.0.45 | Ausgewertet am 11.09.2026 in drei Messläufen (`C:\Temp\E80b`). Erst schwieg sie: die Marke lag in `PgReadMsgView`, der Paige-Textansicht, Gregors Nachricht laeuft aber ueber Trident (`ReadMessageFrame.cpp:277-281`). Nach dem Umzug nach `TridentView.cpp:1425` sagte sie `Knopf=0 konzentriert=1 ShowAllHeaders=0 -> Kopfzeilen ALLE` beim ersten Aufbau und `konzentriert=0 -> Kopfzeilen gekuerzt` danach. **Damit war der Verdacht auf den Content Concentrator erledigt** — im laufenden Betrieb greift die Kuerzung. Sie kuerzte nur fast nichts weg, weil die Liste `TabooHeaders` aus 2006 stammt. Die Marke bleibt drin und nennt Knopf, Concentrator, `ShowAllHeaders` und das Ergebnis in einer Zeile |
| E-79 | 1.0.44 | entfaellt: E-79 war durch die EINSTELLUNG behoben, nicht durch Code — `UseMyFilterWindowPosition=1`, von Gregor am 11.09.2026 an 1.0.44 bestätigt. Die Marke bleibt drin, weil sie sofort sagen würde, wenn die Breite wieder wandert | zwei Zeilen je Lauf: `geladen:` nennt den Wert aus der `Eudora.ini`, den Schalter `UseMyFilterWindowPosition`, die Breite des Elternfensters, das Viertel davon, den gesetzten und den danach tatsächlichen Wert; `gesichert:` nennt, was beim Schließen zurückgeschrieben wird. Damit ist in einem Start-und-Beenden zu sehen, an welcher Stelle die Breite sich ändert |
| E-97 | 1.0.64 | 1.0.64 | **im selben Zug eingebaut und ausgewertet** (`C:\Temp\E97-Stapel`, 15.09.2026, `tools/TESTLAEUFE.md`). Ausgewertet wurde ihr **Schweigen**: `E-97 OnInitDialog: 1` kam nie, die Marke im Konstruktor kam — daraus folgte, dass der Absturz vor `OnInitDialog` passiert, und aus dem symbolisierten Stapel dann die Zeile `SaveAsDialog.cpp:425`. Die zweite Marke (`E-97 Nachtrag` in `PgEmbeddedImage.cpp`) hat nie geschrieben und bleibt bewusst stehen |
| E-101 | 1.0.66 | 1.0.66 | **im selben Zug eingebaut und ausgewertet** (17.09.2026, Messlauf `C:\Temp\messen-e101.ps1` — ein Wegwerfwerkzeug außerhalb des Repos, siehe den Hinweis unten). Die Marke nennt in **einer** Zeile, was aus der Datei wurde: `kopfzeilen`, `xhtml`, `content-type-vorhanden`, den abgeleiteten Typ, den Zeichensatz und beide Bytelängen. Genau die Zusammenstellung *„`xhtml=1` und `content-type-vorhanden=0`"* ist der Befund E-101 in einer Zeile. **Achtung, die Marke ist für `spuren-auswerten.pl` unsichtbar** — der Kommentar darüber trägt das Wort `SPURMARKE` nicht (siehe *Nachtrag 17.09.2026*) |
| E-95 | 1.0.61 | 1.0.62 | **noch vor Gregors Rückmeldung ausgewertet, an einem selbst gestarteten Eudora** (`C:\Temp\E95-Test`, 15.09.2026, Gregors Freigabe: *„mach, was du denn brauchst, um den / die fehler zu fixen!"*). Testnachricht aus drei Bildern **bekannter** Größe — 600×150, 320×80, 20×20. Die Marke sagte `ascent=150 150 150` bei `text-asc=13 150 150`: **jedes Bild erbte die Zeilenhöhe des ersten.** Das war **E-96**, die eigentliche Ursache hinter vier Fassungen Herumprobieren — und zugleich die Widerlegung der `cid:`/`http:`-Unterscheidung aus 7.2.0.61, die daraufhin mit 7.2.0.63 wieder zurückgenommen wurde. Nach der Behebung: `ascent=150 80 20` bei `text-asc=13 13 13`. **Die Marke bleibt dauerhaft drin** |

## Alle Marken im Quelltext

**Gemessen am 17.09.2026: 30 Befunde, 170 Stellen in 28 Dateien.** Am
15.09.2026 waren es 29 Befunde, 168 Stellen in 26 Dateien, am 13.09.2026 23
Befunde, 158 Stellen in 20 Dateien, am 10.09.2026 19 Befunde in 16 Dateien.
**Die Zahl war zweimal hintereinander nicht nachgezogen worden** — deshalb
steht der Messbefehl jetzt hier, statt dass ihn jeder neu erfindet (am
17.09.2026 selbst gefahren, die drei Zahlen oben sind seine Ausgabe):

```bash
Q="Eudora71/Eudora/*.cpp Eudora71/Eudora/*.CPP Eudora71/OTShim/*.cpp"
git ls-files $Q | xargs grep -oh '"E-[0-9]\+[ :]' | grep -o 'E-[0-9]*' | sort -u | wc -l  # Befunde
git ls-files $Q | xargs grep -oh '"E-[0-9]\+[ :]' | wc -l                                 # Stellen
git ls-files $Q | xargs grep -l  '"E-[0-9]\+[ :]' | wc -l                                 # Dateien
```

Gezählt werden **Protokolltexte**, die mit `E-nn` beginnen — nicht Kommentare,
die eine Kennung nennen. `Eudora71/Tests` und `Eudora71/EuImap` bleiben
draußen; die Marke zu **E-85** liegt in `EuImap/src/ImapDownload.cpp` und wird
von dieser Zählung deshalb nicht erfasst.

**Alle hängen an `DEBUG_MASK_MISC` (32768) und schweigen in der Vorgabe.**
Einschalten mit `LogLevel=58527` in der `Eudora.ini` — siehe
[README.md](../README.md), Abschnitt *Mehr ins Protokoll schreiben lassen*.

| Befund | Stellen | wo | was die Zeilen sagen |
|---|---:|---|---|
| **E-27** | 61 | `CompMessageFrame.cpp`, `PaigeEdtView.cpp`, `compmsgd.cpp`, `headervw.cpp`, `mainfrm.cpp` | der ganze Aufbau eines Nachrichtenfensters, Schritt für Schritt: `InitializeNew: Anfang`, `OnCreateClient`, `CHeaderView::OnCreate` … Die dichteste Messung im Baum — sie zeigt, an welcher Stelle ein Fensteraufbau hängenbleibt |
| **E-33** | 34 | `QCCustomToolBar.cpp`, `eudora.cpp`, `mainfrm.cpp` | das Beenden in nummerierten Schritten (`5a vor TrimJunk`, `5b nach TrimJunk`, `5c vor RemoveControlBar`). Damit ist zu sehen, **wo** ein Beenden stehenbleibt |
| **E-34** | 19 | `CompMessageFrame.cpp`, `QCChildToolBar.cpp`, `eudora.cpp` | `NewChildFrame` mit Fensterkennung, Sichtbarkeit, Rechteck und Titel vor und nach `InitialUpdateFrame` |
| **E-35** | 4 | `CompMessageFrame.cpp` | Werkzeugleistenknöpfe: `CommandToIndex`, `GetButton`, `GetSubMenu` — die Klasse, aus der `GetBtnCount=24` bei `m_btns.GetSize=0` kam |
| **E-37** | 3 | `PersonalityView.cpp` | Löschen einer Persönlichkeit, mit dem Namen in der Zeile |
| **E-40** | 2 | `doc.cpp`, `msgdoc.cpp` | was `SaveModified` von `AfxMessageBox` zurückbekommt |
| **E-41** | 2 | `mainfrm.cpp` | `OnSysCommand` mit `SC_CLOSE` — Alt+F4 und das Fensterkreuz |
| **E-42** | 1 | `mainfrm.cpp` | `Beenden: Schritt '…'` — der Name des Aufräumschritts, der gerade läuft |
| **E-43** | 1 | `QCCustomToolBar.cpp` | `SaveCustomInfo` mit dem INI-Abschnitt, in den geschrieben wird |
| **E-78** | 1 | `mainfrm.cpp:862` | je Leiste Kennung, Andockleiste, Sichtbarkeit und Stil. **Eine** Formatzeile, aus **zwei** Zeitpunkten heraus geschrieben (nach `SetDockState` und um `LoadWazooBarConfigFromIni` herum) — welcher gerade dran ist, steht im ersten `%s`. Die Meldung *„für N Leiste(n) war keine Lage gespeichert"* gehört dazu, trägt im Text aber **E-44** |
| **E-44** | 1 | `WazooBarMgr.cpp:698` | *„für N Leiste(n) war keine Lage gespeichert (kein `[ToolBar...]`-Abschnitt)"* — die Meldung, an der **E-78** hängt: sie erscheint bei jedem Start, obwohl dreizehn solche Abschnitte in der `Eudora.ini` stehen |
| **E-79** | 2 | `FiltersWazooWnd.cpp:77`, `:216` | `gesichert:` nennt, was beim Schließen in die `Eudora.ini` zurückgeht; `geladen:` den Wert aus der INI, den Schalter `UseMyFilterWindowPosition`, die Elternbreite, das Viertel davon, den gesetzten und den danach tatsächlichen Wert. In einem Start-und-Beenden ist damit zu sehen, an welcher Stelle die Breite sich ändert |
| **E-45** | 1 | `mainfrm.cpp` | ob `QCWorkbook::OnClose` durchgelaufen ist |
| **E-46** | 1 | `mainfrm.cpp` | ob der Destruktor des Hauptfensters erreicht wird |
| **E-64** | 2 | `filtersd.cpp` | **am Eingang** von `FilterMsg`: wie viele Filter in der Liste sind und welche Masken sie tragen. Dazu je Vergleich `Match=0/1` mit Kopfzeile, Verb, Wert und Betreff |
| **E-66** | 9 | `OTShim.cpp` | Ziehen am Greifrand: Zeigerwechsel, Streifenlage, Bewegung, `Anwenden` und `Anwenden ABGEBROCHEN` mit Maßen |
| **E-68** | 1 | `filtersd.cpp` | eine Regel in `Filters.pce` hat mehr Aktionen als `NUM_FILT_ACTS` — die überzählige wird verworfen und hier genannt |
| **E-69** | 3 | `filtersd.cpp` | die drei Stellen, an denen `FilterMsg` abbricht (kein TOC, kein Nachrichtendokument, `GetMessageDoc` liefert nichts). Vorher waren das `ASSERT(0)` — im Freigabebau also **nichts** |
| **E-70** | 4 | `OTShim_Werkzeugleiste.cpp`, `QCToolBarManager.cpp`, `mainfrm.cpp` | `gesichert:` und `geladen:` je Leiste mit `cx`/`cy` vorher und nachher. **Diese zwei Zeilen nebeneinander haben E-70 entschieden** |
| **E-72** | 1 | `filtersv.cpp` | wenn das Filterfenster einen Filter zurückschreiben wollte, den es nie geladen hat |
| **E-73** | 1 | `filtersd.cpp` | wenn eine Filteraktion auf dem Server löschen wollte — mit Filtername, Betreff und dem Urteil `VERWEIGERT` oder `ERLAUBT` |
| **E-80** | 3 | `TridentView.cpp`, `PgReadMsgView.cpp` | Trident (die Stelle, die zaehlt): Zustand des Knopfes, `m_bWasConcentrated`, `ShouldShowAllHeaders()` und das Ergebnis in einer Zeile. Paige: wie viele Kopfzeilen als taboo markiert wurden, wie viele Listeneintraege es gibt und was der Knopf am Stil umschaltet — diese drei schweigen bei Gregor, weil seine Nachrichten ueber Trident laufen |
| **E-76** | 1 | `OTShim.cpp` | Größenänderung einer schwebenden Leiste: `nLength`, `dwMode` mit ausgeschriebenen Flags, `IsFloating`, Maße vorher und nachher |
| **E-88** | 3 | `PgMsgView.cpp` (2), `sendmail.cpp` | **Die wichtigste Sicherung des HTML-Umbaus.** `E-88 vor dem Absenden` nennt in einer Zeile die gewählte Fassung (`ORIGINAL` oder `EDITOR`, mit dem Grund), den Stand des Schalters `ForwardOriginalHTML`, die Größe beider Fassungen und der neuen, die Länge des eigenen Zusatzes vor und hinter dem Zitat sowie den Antworttyp. `E-88 auf der Leitung` nennt, was **wirklich** hinausgeht: Größe, `IsFancy`, `IsXRich`, `IsHTML`, `SendPlainOnly` und den Betreff. `E-88 eingebettete Teile` meldet, wenn das Aufräumen der eingebetteten Bilder übersprungen wurde, weil ein Original aufgehoben ist. **Warum alle drei:** das Verfassenfenster zeigt immer die schlichte Paige-Fassung — ohne diese zwei Zeilen merkte niemand, wenn eine kaputte Nachricht hinausginge |
| **E-83** | 1 | `QCTaskManager.cpp:430` | `E-83 <Schritt>:` mit `uid`, Zustand samt Zahlwert, `m_pThread`, `m_pWinThread` und der Zahl der laufenden Aufgaben in **einer** Zeile. Gerufen wird sie an acht Stellen (`eingetragen`, `eingereiht`, `Regel1-Obergrenze-erreicht`, `Regel-POP-belegt` …), sodass der Weg einer Aufgabe durch die Warteschlange lückenlos dasteht. **E-83 ist seit 7.2.0.53 behoben**; die Marke bleibt, weil sie eine hängende Aufgabe sofort wieder zeigen würde |
| **E-86** | 2 | `TridentView.cpp:1619`, `:2274` | `E-86: Anzeigedatei <a> -> <b>` nennt die zusammengesetzte Datei; `E-86 fixup: FixupSource laeuft BODY-Elemente=%d Hintergrund=%s` nennt, ob es ein zweites verworfenes `<body>` gibt und welchen Hintergrund MSHTML wirklich zeichnet. **Die zweite Zeile hat E-86 entschieden:** `BODY-Elemente=1` und die vollen 36.078 Byte schlossen beide Verdächte aus, der Rendermodus blieb übrig — nach dem Einbau von `X-UA-Compatible` meldete dieselbe Marke `Hintergrund=transparent` statt `#ffffff` |
| **E-87** | 1 | `summary.cpp:1149` | `E-87 ComposeMessage:` nennt vor dem Aufbau des Verfassenfensters `IsFancy`, `IsRich`, `IsXRich`, `IsFlowed`, `IsHTML`, den Schalter und den Antworttyp. Damit ist in einer Zeile zu sehen, als **welche Art** Nachricht eine Weiterleitung angelegt wird — der Punkt, an dem die Formatierung verlorenging |
| **E-95** | 1 | `PGHTMIMP.CPP:2186` | `E-95 Bild:` nennt je eingefügtem Bild `src` (die ersten 32 Zeichen — `cid:`, `data:` oder `http:`), `attr` (was im HTML stand), `embed` (was Paige nach dem Laden weiß), `ascent` (die entstandene Zeilenhöhe) sowie Text-Ascent und -Descent. **Diese eine Zeile hat E-96 entschieden:** `ascent=150 150 150` bei `text-asc=13 150 150` zeigte, dass jedes Bild die Höhe des ersten erbte. Sie ist **dauerhaft** eingebaut — vier Fassungen lang war jede Erklärung für das Schwanken der Bildgrößen plausibel und falsch, und `embed=` ist der Beleg, dass Paige die wirkliche Größe kennt, auch bei extern verlinkten Bildern |
| **E-97** | 2 | `SaveAsDialog.cpp:78`, `PgEmbeddedImage.cpp:483` | `E-97 OnInitDialog: 1 nach CFileDialog::OnInitDialog` sagt, **ob `OnInitDialog` überhaupt erreicht wird**. Am 15.09.2026 ausgewertet: die Zeile kam **nicht**, während die Marke im Konstruktor kam — damit lag die Lücke zwischen beiden, im `GetSaveFileName`-Aufruf selbst, und der Rückruf `OnTypeChange` war der Täter. `E-97 Nachtrag: quelle=…x… embed=…x…` in `PgEmbeddedImage.cpp` hat in **keinem** meiner Testläufe geschrieben — der Nachtragsweg wird dort nicht erreicht; sie bleibt drin, weil sie bei Gregors echten Bildern schreiben könnte. **Eine Marke, die nichts schreibt, ist ein Messwert** — das war hier der entscheidende |
| **E-101** | 2 | `msgutils.cpp:3840`, `:4037` | `E-101 speichern:` nennt in **einer** Zeile, was `E101SpeicherfassungAufbereiten` an der Datei getan hat: `kopfzeilen` (hatte die Fassung überhaupt welche), `xhtml` (stand Eudoras interner Marker `<x-html>` darin), `content-type-vorhanden`, den daraus abgeleiteten `typ=text/…`, den nach den Bytes bestimmten `charset` sowie `bytes-vorher`, `nachher` und `geaendert`. **Der Befund steht damit in einer Zeile:** `xhtml=1 content-type-vorhanden=0` heißt, die Datei geht als Eudoras interne Fassung hinaus und ist für jedes andere Programm unbrauchbar. Die zweite Stelle (`:3840`) meldet den leeren Eingang — *„leer, nichts zu tun"*; sie ist das Gegenstück, das sagt, dass die Funktion überhaupt gerufen wurde |
| **E-89** | 2 | `msgutils.cpp:3406`, `:3760` | `E-89 Bilder im Editor` nennt in **einer** Zeile, was die Umschrift an den Bildern getan hat: wie viele `<img>` es gab, wie viele unverändert blieben, wie viele ihre Größe aus dem CSS bekamen, wie oft die Vorgabe greifen musste, wie oft gedeckelt wurde, und beide Bytelängen. Steht dort `gesamt=0`, war in der Nachricht kein Bild — dann ist E-89 nicht die Ursache. Geschrieben wird sie **nur**, wenn auch das Original aus E-88 aufgehoben wird; das ist die eine Bedingung, an der beide Befunde hängen |

### Wie man das benutzt

Tritt ein Fehler in einem dieser Bereiche auf, ist die Messung schon
eingebaut. Es braucht **keinen neuen Bau**:

1. Eudora beenden, `eudora.log` löschen.
2. `LogLevel=58527` in `[Settings]` der `Eudora.ini`.
3. Starten, genau die eine Sache tun, beenden.
4. Im Protokoll nach der Befundnummer suchen.

**Warum diese Tabelle vollständig sein muss:** eine Marke, von der niemand
weiß, ist so nutzlos wie keine. Bis zum 10.09.2026 kannte diese Datei fünf
von neunzehn — die übrigen vierzehn lagen im Quelltext und schrieben
mit, ohne dass jemand sie zuordnen konnte.

**Wo noch nie gemessen wurde:** der Mailabruf. Im **Versand** steht seit
E-88 die Marke `E-88 auf der Leitung` (`sendmail.cpp`, in `WriteBody`).
Für den Abruf gibt es Eudoras eigene Schalter (`RCVD` 2, `TRANS` 32,
`RCV` 64, `LMOS` 8192), aber keine Marke aus dieser Portierung. Wenn dort
etwas auftaucht, gehört eine gesetzt — nicht auf Vorrat.


## Ein bekannter Hinweis, der kein Mangel ist

`spuren-auswerten.pl` meldet seit dem 15.09.2026:

```
E-95 steht in Befunde/SPURMARKEN.md, im Quelltext gibt es dazu keine Marke mehr
```

**Das ist ein Fehlalarm, und die Ursache ist eine Konvention, kein Fehler.**
Das Werkzeug erkennt eine Marke daran, dass in einer **Kommentarzeile** das
Wort `SPURMARKE` steht (`tools/spuren-auswerten.pl:122`). Der Kommentar über
der E-95-Marke lautet aber `E-95-MESSUNG, 15.09.2026` — ohne dieses Wort. Die
Marke selbst steht sehr wohl im Bau, in `PGHTMIMP.CPP:2186`, und schreibt bei
`LogLevel=58527` je Bild ihre Zeile.

**Der Fix ist ein Wort:** in `PGHTMIMP.CPP:2157` `E-95-MESSUNG` zu
`SPURMARKE ZU BEFUND E-95` machen. Er gehört in denselben Commit wie die
nächste ohnehin fällige Änderung an dieser Datei — der LEKTOR fasst
`Eudora71/` nicht an.

### Nachtrag 17.09.2026: dieselbe Konvention, diesmal als Schweigen

**E-97 hat zwei Marken im Bau** (`SaveAsDialog.cpp:78`,
`PgEmbeddedImage.cpp:483`) — und `spuren-auswerten.pl` sagt dazu **gar
nichts**, weder Meldung noch Fehlalarm. Beide Kommentare darüber lauten
`BEFUND E-97` beziehungsweise `E-97-Messung`, ohne das Wort `SPURMARKE`. Das
Werkzeug zählt deshalb weiter **8** Befunde mit Marken, während die Messung
über den Quelltext **30** nennt.

Bei E-95 fällt die Konvention als Hinweis auf, weil die Marke in dieser Datei
steht. Bei E-97 stand sie bis heute **nicht** hier — und dann meldet das
Werkzeug nichts, in beide Richtungen nicht. Das ist die teurere Sorte
([prüfstand-kann-blind-sein](../Arbeitsweise/pruefstand-kann-blind-sein.md)).

**Zu tun, in `Eudora71/` und deshalb nicht vom LEKTOR:** beide Kommentare auf
`SPURMARKE ZU BEFUND E-97` bringen — und danach `spuren-auswerten.pl` gegen
die Zahl aus dem Messbefehl oben halten, statt gegen sich selbst
([pruefumfang-nicht-von-hand](../Arbeitsweise/pruefumfang-nicht-von-hand.md),
Nachtrag vom 14.09.).

### Nachtrag 17.09.2026, zweiter: dieselbe Konvention zum dritten Mal — E-101

**Die Lehre ist geschrieben und hat nicht gewirkt.** Der Abschnitt darüber
steht seit heute Vormittag hier; am Nachmittag ist mit **E-101** eine neue
Marke dazugekommen (`msgutils.cpp:3840` und `:4037`, Text `E-101 speichern:`),
und der Kommentar darüber lautet wieder `BEFUND E-101` — **ohne das Wort
`SPURMARKE`**. `spuren-auswerten.pl` zählt an Fassung 1.0.66 unverändert
**8** Befunde mit Marken und sagt zu E-101 **gar nichts**: weder „hat Marken,
aber keine Zeile" noch „Zeile ohne Marke". Die Schranke war also **zum dritten
Mal stumm**, an derselben Stelle und aus demselben Grund
([lehren-anwenden-nicht-nur-schreiben](../Arbeitsweise/lehren-anwenden-nicht-nur-schreiben.md)).

Die Zeile zu E-101 steht jetzt oben in beiden Tabellen. Solange der Kommentar
im Quelltext das Schlüsselwort nicht trägt, wird sie als *verwaist* gemeldet —
**dieser Hinweis ist ein Fehlalarm derselben Sorte wie der zu E-95**, nicht ein
Zeichen, dass die Marke ausgebaut wäre.

**Zu tun, in `Eudora71/` und deshalb nicht vom LEKTOR:** die Kommentare zu
**E-95**, **E-97** und **E-101** in einem Zug auf `SPURMARKE ZU BEFUND E-xx`
bringen. **Und danach die eigentliche Fehlerklasse abstellen**
([fehlerklassen-abstellen](../Arbeitsweise/fehlerklassen-abstellen.md)): dass
ein Schlüsselwort im Kommentar über der Ausgabezeile darüber entscheidet, ob
eine Marke überhaupt gesehen wird, ist die Ursache aller drei Fälle. Ein
Erkennungsmuster am **Ausgabetext** (`"E-<Zahl> <Wort>:"` im Formatstring)
statt am Kommentar hätte alle drei gefunden — das ist ein Vorschlag, keine
beschlossene Sache; er gehört Gregor vorgelegt.

## Prüfen

```
perl tools/spuren-auswerten.pl                # prüft, weist ab
perl tools/spuren-auswerten.pl --nur-melden   # nur Bericht, exit 0
```

Das Werkzeug hängt in `tools/paket-bauen.ps1`. Es weist ab, wenn eine Marke aus
einer **früheren** Fassung noch nicht ausgewertet ist — eine Marke, die mit der
gerade gebauten Fassung zum ersten Mal hinausgeht, ist in Ordnung, denn sie soll
ja erst noch mitlaufen.
