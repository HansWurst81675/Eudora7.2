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
| E-76 | 1.0.41 | entfaellt: braucht eine gedrückte Maustaste, siehe E-51 | Die Marke schreibt nur, wenn jemand am Rand eines **schwebenden** Fensters zieht. Das lässt sich hier nicht auslösen — dasselbe Hindernis wie bei **E-51**: `Splitter::Track` und die Größenänderung eines Rahmens brechen ab, sobald die physische Maustaste los ist. Sie bleibt drin und wartet auf den nächsten Bericht von Gregor. Sie nennt `nLength`, `dwMode` mit ausgeschriebenen Flags, `IsFloating` und die Maße vorher wie nachher in einer Zeile |
| E-78 | 1.0.43 | entfaellt: geht mit 1.0.44 zum ersten Mal zu Gregor - 1.0.43 lief bei ihm nur mit der Vorgabe LogLevel=25759, bei der die Marke schweigt |
| E-80 | 1.0.45 | **ausgewertet am 11.09.2026**, drei Messlaeufe in `C:\Temp\E80b` | Erst schwieg sie: die Marke lag in `PgReadMsgView`, der Paige-Textansicht, Gregors Nachricht laeuft aber ueber Trident (`ReadMessageFrame.cpp:277-281`). Nach dem Umzug nach `TridentView.cpp:1425` sagte sie `Knopf=0 konzentriert=1 ShowAllHeaders=0 -> Kopfzeilen ALLE` beim ersten Aufbau und `konzentriert=0 -> Kopfzeilen gekuerzt` danach. **Damit war der Verdacht auf den Content Concentrator erledigt** — im laufenden Betrieb greift die Kuerzung. Sie kuerzte nur fast nichts weg, weil die Liste `TabooHeaders` aus 2006 stammt. Die Marke bleibt drin und nennt Knopf, Concentrator, `ShowAllHeaders` und das Ergebnis in einer Zeile |
| E-79 | 1.0.44 | | zwei Zeilen je Lauf: `geladen:` nennt den Wert aus der `Eudora.ini`, den Schalter `UseMyFilterWindowPosition`, die Breite des Elternfensters, das Viertel davon, den gesetzten und den danach tatsächlichen Wert; `gesichert:` nennt, was beim Schließen zurückgeschrieben wird. Damit ist in einem Start-und-Beenden zu sehen, an welcher Stelle die Breite sich ändert |

## Alle Marken im Quelltext

Gemessen am 10.09.2026 über alle `.cpp` in `Eudora71/Eudora` und
`Eudora71/OTShim`: **19 Befunde, 146 Protokollstellen in 16 Dateien.**

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
| **E-78** | 2 | `mainfrm.cpp`, `WazooBarMgr.cpp` | je Leiste Kennung, Andockleiste, Sichtbarkeit und Stil — **an zwei Zeitpunkten**: nach `SetDockState` und um `LoadWazooBarConfigFromIni` herum. Dazu die Meldung, für wie viele Leisten die Standardanordnung nachgezogen wurde |
| **E-45** | 1 | `mainfrm.cpp` | ob `QCWorkbook::OnClose` durchgelaufen ist |
| **E-46** | 1 | `mainfrm.cpp` | ob der Destruktor des Hauptfensters erreicht wird |
| **E-64** | 2 | `filtersd.cpp` | **am Eingang** von `FilterMsg`: wie viele Filter in der Liste sind und welche Masken sie tragen. Dazu je Vergleich `Match=0/1` mit Kopfzeile, Verb, Wert und Betreff |
| **E-66** | 9 | `OTShim.cpp` | Ziehen am Greifrand: Zeigerwechsel, Streifenlage, Bewegung, `Anwenden` und `Anwenden ABGEBROCHEN` mit Maßen |
| **E-68** | 1 | `filtersd.cpp` | eine Regel in `Filters.pce` hat mehr Aktionen als `NUM_FILT_ACTS` — die überzählige wird verworfen und hier genannt |
| **E-69** | 3 | `filtersd.cpp` | die drei Stellen, an denen `FilterMsg` abbricht (kein TOC, kein Nachrichtendokument, `GetMessageDoc` liefert nichts). Vorher waren das `ASSERT(0)` — im Freigabebau also **nichts** |
| **E-70** | 4 | `OTShim_Werkzeugleiste.cpp`, `QCToolBarManager.cpp`, `mainfrm.cpp` | `gesichert:` und `geladen:` je Leiste mit `cx`/`cy` vorher und nachher. **Diese zwei Zeilen nebeneinander haben E-70 entschieden** |
| **E-72** | 1 | `filtersv.cpp` | wenn das Filterfenster einen Filter zurückschreiben wollte, den es nie geladen hat |
| **E-73** | 1 | `filtersd.cpp` | wenn eine Filteraktion auf dem Server löschen wollte — mit Filtername, Betreff und dem Urteil `VERWEIGERT` oder `ERLAUBT` |
| **E-80** | 4 | `TridentView.cpp`, `PgReadMsgView.cpp` | Trident (die Stelle, die zaehlt): Zustand des Knopfes, `m_bWasConcentrated`, `ShouldShowAllHeaders()` und das Ergebnis in einer Zeile. Paige: wie viele Kopfzeilen als taboo markiert wurden, wie viele Listeneintraege es gibt und was der Knopf am Stil umschaltet — diese drei schweigen bei Gregor, weil seine Nachrichten ueber Trident laufen |
| **E-76** | 1 | `OTShim.cpp` | Größenänderung einer schwebenden Leiste: `nLength`, `dwMode` mit ausgeschriebenen Flags, `IsFloating`, Maße vorher und nachher |

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

**Wo noch nie gemessen wurde:** Mailversand und -abruf. Dort gibt es
Eudoras eigene Schalter (`RCVD` 2, `TRANS` 32, `RCV` 64, `LMOS` 8192), aber
keine Marke aus dieser Portierung. Wenn dort etwas auftaucht, gehört eine
gesetzt — nicht auf Vorrat.

## Prüfen

```
perl tools/spuren-auswerten.pl                # prüft, weist ab
perl tools/spuren-auswerten.pl --nur-melden   # nur Bericht, exit 0
```

Das Werkzeug hängt in `tools/paket-bauen.ps1`. Es weist ab, wenn eine Marke aus
einer **früheren** Fassung noch nicht ausgewertet ist — eine Marke, die mit der
gerade gebauten Fassung zum ersten Mal hinausgeht, ist in Ordnung, denn sie soll
ja erst noch mitlaufen.
