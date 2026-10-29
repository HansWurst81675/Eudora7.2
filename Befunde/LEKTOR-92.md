# <a id="lektor-92"></a>LEKTOR-92 — Nachlauf vor dem PR `e166-junk_message_fix`: LEKTOR-91 eingearbeitet, FAQ neu, E-169 neu, 29.10.2026

**Auftrag.** Kurzer Nachlauf über `5a235c55..01f583db` (Merge von
[LEKTOR-91](LEKTOR-91.md#lektor-91), *„FAQ angelegt“* `98fb9822`,
*„[LEKTOR-91](LEKTOR-91.md#lektor-91) eingearbeitet, [E-169](../Intern/BEFUNDE.md#e-169) eingetragen“* `3715e231`, *„FAQ: Label
automatisch per Filter“* `01f583db`) und Bestand der 62 `.md` ohne
`Arbeitsweise/` und `Befunde/`. Besonders: jeder der 11 Funde aus
[LEKTOR-91](LEKTOR-91.md#lektor-91) einzeln; die neue `Doku/FAQ.md` gegen
README, ANWENDER, FILTER und gegen die Menüs in `EudoraRes.rc`;
[E-169](../Intern/BEFUNDE.md#e-169) (Druckvorschau einer HTML-Mail ohne
Bilder). Gemessen im Arbeitsbaum `Eudora7.2-wt-lektor` auf
`wt/lektor-20261029b` (= `01f583db`).

**Ergebnis vorweg.** **5 Funde: 1 unvollständig, 1 veraltet, 2 ungenau,
1 Hinweis.** Von den 11 Funden aus [LEKTOR-91](LEKTOR-91.md#lektor-91) sind
4 erledigt und 7 teilweise — erledigt ist jeweils der Teil, der in den
Dokumenten mit dem größten Gewicht stand (ZIEL, TESTPLAN, PORTIERUNG,
README); liegen geblieben sind Nebenstellen. Nichts davon hindert den PR.
**Wichtigster neuer Fund:** [E-169](../Intern/BEFUNDE.md#e-169) sagt, die
Stelle, die die Zwischendatei `eud*.htm` schreibt, sei *„noch nicht
gefunden“* — sie steht in `CTridentView::LoadMessage`, und **das Lesefenster
zeigt dieselbe Datei an**. Damit trägt die erste Vermutung des Befunds
(Lesefenster lädt die Bilder, die Zwischendatei nicht) nicht mehr
([L-92.1](#l-92.1), belegt am Quelltext). Die FAQ ist in sich stimmig, ihre
Menüpfade stehen bis auf das „Sortierfeld“ so im Programm
([L-92.3](#l-92.3)).

---

## Funde aus LEKTOR-91

| Fund | Was es war | Heute | Beleg |
|---|---|---|---|
| [L-91.1](LEKTOR-91.md#l-91.1) | Startwege-Schranke sieht den 28.10. nicht | **teilweise** — die Grenze steht jetzt offen da, das Werkzeug ist unverändert (bewusst). Offen: der dritte unsichtbare Start vom 20.10. (`C:/Temp/E131`) fehlt weiter, keiner der drei ist in `tools/TESTLAEUFE.md` nachgetragen | `tools/WERKZEUGE.md:30` *„**Grenze, gemessen am 29.10.2026** … für den 28.10. bleibt es bei einem Start“*, aber weiter *„zwei bisher unsichtbare Starts vom 20.10.2026 in `C:\Temp\E132`“*; `grep -c E131 tools/WERKZEUGE.md` → 0, `grep '2026-10-20 2[01]:' tools/TESTLAEUFE.md` → kein Treffer (gemessen) |
| [L-91.2](LEKTOR-91.md#l-91.2) | Frage zur Notiz `v1.0.120` falsch gestellt | **teilweise** — die Frage ist gestrichen; der irreführende Halbsatz in der Abschrift steht noch | `Intern/WEITERMACHEN.md:138` *„(b) ~~Notiz zu `v1.0.120` um den Junk-Filter ergänzen?~~ gegenstandslos“*; `Releases/1.0.120/RELEASE-NOTIZEN.md:84-85` unverändert *„der Text auf GitHub ist unverändert“* (belegt) |
| [L-91.3](LEKTOR-91.md#l-91.3) | sieben tote Links in drei veröffentlichten Release-Texten | **teilweise** — als Frage an Gregor eingetragen; die Abschriften tragen keinen Vermerk, dass ihre Links vom veröffentlichten Text abweichen, und der Kopf nennt sie weiter *„wörtlich“* | `WEITERMACHEN.md:138` *„2 + 2 + 3 Links … berichtigen?“*; `Releases/1.0.120/RELEASE-NOTIZEN.md:6` *„Der **Text unten ist der Rumpf des veröffentlichten Releases, wörtlich**“*, `:28` `blob/main/Intern/BEFUNDE.md#e-135` (belegt) |
| [L-91.4](LEKTOR-91.md#l-91.4) | E-166-Prüfschritt grün, auch wenn die Frage nie kam | **teilweise** — der Fall *„nicht prüfbar“* steht da. Offen: die Reihenfolge zum übrigen Release-Test (Gregors Daten erst danach hineinkopieren) und was ein *„kommt wieder“* für die README-Zeile heißt | `Intern/TESTPLAN.md:28-32` *„**Kam sie schon in Schritt 1 nicht**, ist der Schritt **nicht prüfbar** … nicht als bestanden“*; zur Reihenfolge nur `:18-19` *„Voraussetzung: ein **leeres** Mailverzeichnis“* (belegt) |
| [L-91.5](LEKTOR-91.md#l-91.5) | ZIEL kannte den E-166-Prüfschritt nicht | **teilweise** — ZIEL nennt ihn jetzt. Offen: README und CHANGELOG sagen weiter nicht, dass [E-166](../Intern/BEFUNDE.md#e-166) mit 7.2.1 kommt | `ZIEL.md:42-47` *„**Was an der Release-Fassung selbst noch geprüft wird:** die Behebung von [[E-166](../Intern/BEFUNDE.md#e-166)] …“*; `README.md:138-141` zählt [E-166](../Intern/BEFUNDE.md#e-166) nicht auf; `CHANGELOG.md:102` *„die Nummer kommt beim Schnüren“* ohne *„kommt mit dem Release 7.2.1“* (belegt) |
| [L-91.6](LEKTOR-91.md#l-91.6) | PORTIERUNG dehnte die Ausnahme auf die Verzeichnisdienste aus | **erledigt** | `Intern/PORTIERUNG.md:739` *„ob dann auch die Verzeichnisdienste arbeiten, ist nicht gemessen“* |
| [L-91.7](LEKTOR-91.md#l-91.7) | „Punktzahl 0“ ohne Bedingung an vier Stellen | **teilweise** — FILTER `:511`, EINSTELLUNGEN 4.1, STARTUMGEBUNG, AUFGABEN berichtigt. Offen: `FILTER.md:737` sagt weiter *„trifft dann nie“*, `:526-528` derselben Datei *„trifft … **jede** Nachricht“*; die Folge für `DeleteFetchedJunk` bei geladenem Modul (`:530-533`) fehlt; `README.md:167` wiederholt `C:\Windows\SysWOW64` | `Intern/FILTER.md:511` *„Fehlen die beiden Dateien, schlägt `LoadLibrary` fehl“*; `:737` *„eine Regel auf *Junk Score* trifft dann nie“* (belegt) |
| [L-91.8](LEKTOR-91.md#l-91.8) | [E-157](../Intern/BEFUNDE.md#e-157) wusste nichts vom Absturz am 28.10. | **erledigt** — *„Zuletzt gemessen: 26.10.2026“* bleibt; vertretbar, der 28.10. ist ein neuer Fall, keine neue Zählung | `Intern/BEFUNDE.md:388` *„**Weiterer Fall, 28.10.2026:** ein Absturz im Konto-Assistenten …“* |
| [L-91.9](LEKTOR-91.md#l-91.9) | Kopfzeilen auf dem 28.10. | **teilweise** — WEITERMACHEN berichtigt; ZIEL nicht | `Intern/WEITERMACHEN.md:3` *„**Stand 29.10.2026.**“*; `ZIEL.md:181` weiter *„**Stand 27.10.2026.**“*, obwohl `:42-47` am 29.10. dazukam (belegt) |
| [L-91.10](LEKTOR-91.md#l-91.10) | E-167 stille Lücke | **erledigt** (in BEFUNDE erklärt; das Verlinken von *„nicht vergeben“* durch `befunde-verlinken.pl` bleibt, Werkzeug) | `Intern/BEFUNDE.md:384` *„**Zur Nummer:** E-167 ist frei gehalten für den Vorschlag K5 aus [PRÜFER-64] …“* |
| [L-91.11](LEKTOR-91.md#l-91.11) | README nannte das Menü *Konto → Eigenschaften* | **erledigt**, auch in CHANGELOG und im Prüfschritt von [E-166](../Intern/BEFUNDE.md#e-166) | `README.md:162` *„die Kontoeinstellungen (*Tools → Personalities*, Rechtsklick → *Properties*)“*; `CHANGELOG.md:104` ebenso; Menü `EudoraRes.rc:6268` |

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe | Bewertung |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„gepruefte Dateien 48 … Kein Widerspruch gefunden.“*, dazu *„Zur Kenntnis“* 14 Dateien, die 7.2.0.127 nicht nennen (Release-Notizen, PORTIERUNG, MELDUNGEN-VON-AUSSEN …) | die Liste ist Rauschen (alte Notizen sollen alt bleiben); 48 von 62 — `Doku/FAQ.md` liest es ohne Befund, die Zeilennummer-Drift aus [L-92.2](#l-92.2) prüft es nicht |
| `perl tools/offene-befunde.pl` | *„42 offene Befunde, in beiden Listen gleich“*, davon 12 nie gemessen | [E-169](../Intern/BEFUNDE.md#e-169) ist mitgezählt (WEITERMACHEN `:367`, CHANGELOG `:27`) |
| `perl tools/pruefe-regressionstest.pl` | *„mit Testfall im Pruefstand 47 von 71 … OHNE jede Pruefung 22“*, *„Kein neues "behoben" ohne Regressionstest.“* | unverändert gegenüber dem Stand vor [E-169](../Intern/BEFUNDE.md#e-169); [E-169](../Intern/BEFUNDE.md#e-169) ist offen und zählt nicht |
| `perl tools/ziel-stand.pl` | *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* | stimmt für den erzeugten Block; der E-166-Prüfschritt steht absichtlich außerhalb (`ZIEL.md:47` *„Die Übersicht unten zählt das nicht mit.“*) |

---

## <a id="l-92.1"></a>L-92.1 — unvollständig: E-169 sucht die Stelle, die `eud*.htm` schreibt — sie ist im Lesefenster selbst, und das zeigt dieselbe Datei an

**Was passiert:** die Druckvorschau einer HTML-Mail zeigt bei Gregor keine
Bilder. Der Befund vermutet, das Lesefenster lade die Bilder vom Server, die
gedruckte Zwischendatei aber nicht, und sagt, die Stelle, die die
Zwischendatei schreibt, sei noch nicht gefunden. Die Stelle ist die
Anzeige im Lesefenster selbst: Eudora schreibt die Mail für **jede**
Anzeige in `eudNN.htm` und lädt genau diese Datei in die Ansicht. Lesefenster
und Vorschau gehen also von derselben Datei aus; der Unterschied muss im
Druckweg liegen, nicht in der Datei.

* **Belegt**, der Befund: `Intern/BEFUNDE.md:383` *„die Bilder sind
  Verweise auf den Server des Absenders, die das Lesefenster lädt, die
  Vorschau der Zwischendatei aber nicht“* und *„die Stelle, die sie schreibt,
  ist noch nicht gefunden“* (ebenso im erzeugten Block `CHANGELOG.md:27`,
  `Intern/WEITERMACHEN.md:367`).
* **Belegt am Quelltext:** `Eudora71/Eudora/TridentView.cpp:1512`
  `CTridentView::LoadMessage`; `:1530` *„GetTempFileName( szPath, "eud",
  ++s_uTmpFileUnique, szTmpReal )“*, `:1538-1544` Endung aus
  `IDS_HTM_EXTENSION` (`EudoraRes.rc:8547` *„htm“*), `:1556`
  `WriteTempFile`, und `:1633` *„m_pSite->Load((LPTSTR)(LPCTSTR)m_szTmpFile)“*
  — die Ansicht lädt diese Datei. Die Vorschau: `:3155-3157`
  `OnFilePrintPreview` → `Print(FALSE, TRUE)` (`:2305`).
* **Belegt**, warum `befund-suchen.pl` nichts fand: es durchsucht
  `BEFUNDE.md`, nicht den Quelltext; `eud` steht als Vorsilbe getrennt von
  `htm` (gemessen: `git grep 'eud.*\.htm'` im Quelltext ohne Treffer, `"eud"`
  in vier Dateien, davon nur `TridentView.cpp` mit `.htm`).
* **Vermutung**, nicht gemessen: ob die Vorschau die Datei neu lädt (dann
  ohne bereits geholte Bilder) oder das Dokument der Ansicht druckt, entscheidet
  sich in `Print` (`:2305ff`), nicht gelesen.

**Was zu tun wäre:** in [E-169](../Intern/BEFUNDE.md#e-169) die Fundstelle eintragen und die erste
Vermutung umformulieren (beide Ansichten gehen von derselben Datei aus);
die Messung *„eingebettetes gegen nachgeladenes Bild“* bleibt richtig.
Hindert den PR nicht.

## <a id="l-92.2"></a>L-92.2 — veraltet: FILTER.md zeigt für dieselben Stellen andere Zeilen als die neue FAQ

**Was passiert:** die FAQ schickt Leser für die Filter nach FILTER.md. Beide
nennen für die Filteraktion *Make Label* eine Fundstelle — verschiedene.
Die der FAQ stimmt; FILTER.md ist seit der letzten Änderung an
`filtersd.cpp` (19.10.) um rund 70 Zeilen, in `EudoraRes.rc` um rund 20
Zeilen verrutscht, verspricht aber *„Die Zeilennummern beziehen sich auf den
Stand dieses Zweigs“* (`Intern/FILTER.md:22`).

* **Belegt**, `Doku/FAQ.md:54-55` *„Aktion *Make Label* in
  `EudoraRes.rc:6088`, ausgeführt in `filtersd.cpp:1222-1226`“* — gemessen:
  `EudoraRes.rc:6089` *„MENUITEM "Make &Label", ID_FLT_LABEL“*,
  `filtersd.cpp:1222` *„case ID_FLT_LABEL:“* (FAQ eine Zeile daneben, sonst
  richtig).
* **Belegt**, `Intern/FILTER.md:228` *„**Make Label** … `filtersd.cpp:1151-1155`“*
  (dort gemessen: ein Kommentar zu `DEBUG_MASK_FILTERS`, kein `ID_FLT_LABEL`); `:220`
  *„`EudoraRes.rc:6063-6093`“* — die Auswahl steht in `:6083-6111`;
  `:184` *„`EudoraRes.rc:9271-9276`, `:9660-9663`“* — `IDS_FHEADER_TO` steht
  in `:9293`, `IDS_FHEADER_PERSONALITY` in `:9684`.
* **Gemessen**, `git log -1 -- Eudora71/Eudora/filtersd.cpp` → `8eded03e`
  vom 19.10.2026.

**Was zu tun wäre:** die Fundstellen in FILTER.md neu ziehen (Aktionen,
Kopfzeilen, Vergleiche), oder den Satz `:22` auf den Stand mit Datum
einschränken. Kein Fehler in der Sache, aber zwei Dokumente, die einander
zitieren, widersprechen sich in der Zeile.

## <a id="l-92.3"></a>L-92.3 — ungenau: die FAQ nennt ein „Sortierfeld über der Liste“, das es nicht gibt

**Was passiert:** Schritt 3 der Label-Antwort sagt, man sortiere über ein
Sortierfeld über der Liste. Eudora hat dort keine Auswahlliste, sondern
Spaltenköpfe zum Anklicken; ausdrücklich gibt es *Edit → Sort → Sort by
Label*. Wer ein Auswahlfeld sucht, findet keines.

* **Belegt**, `Doku/FAQ.md:43` *„Nach Label sortieren: im Sortierfeld über
  der Liste *Label*.“*
* **Belegt am Quelltext:** `EudoraRes.rc:5520` *„POPUP "&Edit"“*, darin
  `:5625` *„POPUP "&Sort"“* und *„MENUITEM "Sort by &Label",
  ID_EDIT_SORT_SORTBYLABEL“*; Spaltenköpfe als Knöpfe
  `tocview.cpp:144` `CTocHeaderButton::m_hBitmapSortByLabel`, `:1195`
  *„case FW_LABEL: g_SortMethod = BY_LABEL;“*.
* Gregors *„labels funktionieren. paßt.“* (`FAQ.md:68-69`) sagt nicht, ob er
  sortiert hat (**Vermutung**, dass „Sortierfeld“ den Spaltenkopf meint).

**Was zu tun wäre:** *„auf den Spaltenkopf *Label* klicken, oder *Edit →
Sort → Sort by Label*“*.

## <a id="l-92.4"></a>L-92.4 — ungenau: wann die Zeile farbig hinterlegt ist, und eine Fundstelle daneben

**Was passiert:** die FAQ sagt, die Zeile nehme die Label-Farbe als
Hintergrund an, solange sie ausgewählt ist. Das gilt nur, solange die Liste
auch den Fokus hat; ohne Fokus ist die ausgewählte Zeile grau mit farbiger
Schrift. Kleinigkeit, aber genau die Beobachtung, die ein Anwender beim
Wechsel ins Lesefenster macht.

* **Belegt**, `Doku/FAQ.md:59-60` *„der Hintergrund bleibt weiß und nimmt die
  Label-Farbe nur an, solange die Zeile ausgewählt ist“*.
* **Belegt am Quelltext**, `tocview.cpp:624-636`: ausgewählt **und**
  `HasFocus` → `BackColor` = Label-Farbe; ausgewählt ohne Fokus →
  *„BackColor = RGB(0xC0, 0xC0, 0xC0)“*; nicht ausgewählt →
  `GetSysColor(COLOR_WINDOW)` (weiß nur im Standard-Farbschema).
* **Belegt**, `Doku/FAQ.md:65-66` *„Menüs `EudoraRes.rc:5745-5756` und
  `:5938-5948`“* — `:5935` beginnt *„Change &Priority“*, *„Change &Label“* steht
  in `:5943-5954`.

**Was zu tun wäre:** *„… solange die Zeile ausgewählt ist und die Liste den
Fokus hat (sonst grau)“*; Fundstelle `:5943-5954`. Hindert nichts.

## <a id="l-92.5"></a>L-92.5 — Hinweis: die README kündigt die FAQ ohne die Labels an

**Was passiert:** die Wegweiser-Zeile der README nennt zwei der drei
Fragen; die Labels — die einzige Antwort, die Gregor am Programm bestätigt
hat — fehlen.

* **Belegt**, `README.md:48` *„**eine schnelle Antwort** (Post je Konto
  trennen, Anhänge beim Löschen)“*; `Doku/FAQ.md:32` *„## Wie markiere ich
  wichtige Mails farbig?“*.
* `README.en.md` verweist nicht auf die FAQ; die FAQ ist deutsch — kein Fund.

**Was zu tun wäre:** *„(Post je Konto trennen, Mails farbig markieren,
Anhänge beim Löschen)“*.

---

## Geprüft ohne Fund

* **FAQ, Menüpfade gegen `EudoraRes.rc`** (belegt): *Tools → Filters*
  (`:5807`), *Tools → Personalities* (`:5814`), *Tools → Options…* (`:5827`),
  *Special → Empty Trash* (`:5797`), *Message → Change → Label* (`:5660`,
  `:5701`, `:5745`), Kontextmenü *Change Label* (`:5943`), Filterfenster
  *New* (`:2309`), *Incoming* (`:551`), *Header:*, *contains* (`:9686`),
  *«Personality»* (`:9684`), Aktionen *Make Label* (`:6089`) und *Transfer To*
  (`:6107`), Einstellungsseiten *Labels* (`:1931-1959`, Farbknopf links,
  Namensfeld rechts, Vorgabe *„Label 1“* `:10194`) und *Attachments*
  (`:415-449`, *„Delete attachments when emptying &Trash“* `:435`, die drei
  Knöpfe *Never* / *After sending message* / *When message emptied from
  Trash*), Suchkategorie *Personality* (`:11432`).
* **FAQ, Vorgaben** (belegt): `TidyAttach\n0` (`:8232`),
  `AutoAttachedDeleteTrash\n1` (`:8813`), `WholeSummaryLabelColor\n1`
  (`:11232`); `TidyAttach` wirkt nur beim Leeren des Papierkorbs
  (`tocdoc.cpp:2583`, `:3850`, jeweils unter `Purging`).
* **FAQ, `X-Persona`** (belegt): `pop.cpp:710-720` und
  `ImapDownload.cpp:422-430` schreiben sie nur bei nicht leerem
  `GetCurrent()`; Format *„X-Persona: <%s>“* (`EudoraRes.rc:10785`) passt zu
  *„ohne `<>`“* (`FAQ.md:20`) — der Filter streift die Klammern ab
  (`filtersd.cpp:907-915`).
* **FAQ in sich:** jede Antwort trägt ihre Herkunft; der Filterteil der
  Labels sagt *„Am Programm noch nicht geprüft“* (`:55-56`), Gregors
  Bestätigung (`:67-69`) steht beim Teil, den er gesehen hat. Gegen FILTER
  (`:189` *«Personality»*, `:228` *Make Label*) und ANWENDER kein
  Widerspruch in der Sache.
* **[E-169](../Intern/BEFUNDE.md#e-169) im Bestand:** in BEFUNDE, im erzeugten Block von CHANGELOG und
  WEITERMACHEN, im Einstieg `WEITERMACHEN.md:7`; *File → Print Preview*
  besteht (`EudoraRes.rc:5512`). Stufe *wichtig*, *„nichts geht verloren“* —
  deshalb nicht in der README-Liste der bekannten Fehler, stimmig mit deren
  Kopf.
* **`WEITERMACHEN.md:7`** *„offen bei Gregor nur die Frage nach den toten
  Links“* — stimmt mit `:138` und mit [LEKTOR-91](LEKTOR-91.md#gregor).
* **Bestand ohne Bezug zu den genannten Commits:** seit
  [LEKTOR-91](LEKTOR-91.md#lektor-91) unverändert (gemessen: `git log --stat
  5a235c55..HEAD` nennt nur CHANGELOG, Doku/FAQ, AUFGABEN, BEFUNDE,
  EINSTELLUNGEN, FILTER, PORTIERUNG, STARTUMGEBUNG, TESTPLAN, WEITERMACHEN,
  README, ZIEL, tools/AGENTEN-LAUFEN, tools/WERKZEUGE).

## Nicht geprüft

* Die FAQ am laufenden Programm — Auftrag ohne Start.
* `CTridentView::Print` (`TridentView.cpp:2305ff`) — nur bis zum Aufruf
  gelesen ([L-92.1](#l-92.1)).

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Die veröffentlichten Release-Texte `v1.0.113`, `v1.0.117`, `v1.0.120`**
  mit sieben toten Links auf `BEFUNDE.md` (seit dem Umzug nach `Intern/`) —
  berichtigen oder lassen? Unverändert aus
  [LEKTOR-91](LEKTOR-91.md#l-91.3), steht in `WEITERMACHEN.md:138`.
* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)) und **Kriterium 0 ohne Visual Studio**
  ([L-77.3](LEKTOR-77.md#l-77.3)) — unverändert offen.
