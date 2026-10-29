# <a id="lektor-93"></a>LEKTOR-93 — Nachlauf unmittelbar vor dem PR `e166-junk_message_fix`: LEKTOR-92 eingearbeitet, E-170 bis E-172 neu, 29.10.2026

**Auftrag.** Kurzer Nachlauf über `e54bb5d9..d72c86bd` (*„[E-170](../Intern/BEFUNDE.md#e-170)
eingetragen“* `f7a7a09b` liegt davor und ist mitgelesen, *„[E-171](../Intern/BEFUNDE.md#e-171) und [E-172](../Intern/BEFUNDE.md#e-172)
eingetragen“* `1a17fde4`, Merge `00686062`, *„[LEKTOR-92](LEKTOR-92.md#lektor-92) eingearbeitet und
Reste aus [LEKTOR-91](LEKTOR-91.md#lektor-91)“* `d72c86bd`). Kein Vollbestand. Besonders: jeder der
5 Funde aus [LEKTOR-92](LEKTOR-92.md#lektor-92) und die Reste aus
[LEKTOR-91](LEKTOR-91.md#lektor-91), die [LEKTOR-92](LEKTOR-92.md#lektor-92) als teilweise führte;
die drei neuen Befunde [E-170](../Intern/BEFUNDE.md#e-170) (Label geht beim
Verschieben innerhalb eines IMAP-Kontos verloren),
[E-171](../Intern/BEFUNDE.md#e-171) (*Search Mailfolder* ohne Auswahl bringt
eine Fehlermeldung) und [E-172](../Intern/BEFUNDE.md#e-172) (Mail erscheint
als rohes Base64) gegen den Quelltext und gegen die Stufen-Legende. Gemessen
im Arbeitsbaum `Eudora7.2-wt-lektor` auf `wt/lektor-20261029c`
(= `d72c86bd`). Kein Quelltext unter `Eudora71/` ist seit `e54bb5d9`
geändert (gemessen: `git log --stat e54bb5d9..HEAD` nennt nur `.md`).

**Ergebnis vorweg.** **6 Funde: 1 unvollständig, 3 ungenau (davon 2 zur
Stufe), 2 Hinweise. Keiner hindert den PR.** Von den 5 Funden aus
[LEKTOR-92](LEKTOR-92.md#lektor-92) sind 3 erledigt, 1 teilweise, 1 offen.
Die Belege der drei neuen Befunde stimmen am Quelltext, bis auf eine um eine
Zeile verrutschte Angabe. **Wichtigster Fund:** [E-170](../Intern/BEFUNDE.md#e-170)
(Label verschwindet beim Verschieben im IMAP-Konto) begründet seine Stufe
*wichtig* mit *„verschwindet still“* — nach der Legende ist *wichtig* gerade
das, was der Anwender **sofort merkt** und wobei **nichts verloren** geht;
still Verlorenes steht dort unter *kritisch* ([L-93.2](#l-93.2)). Dazu
empfiehlt die FAQ genau *Make Label* plus *Transfer To*, ohne [E-170](../Intern/BEFUNDE.md#e-170) zu
erwähnen ([L-93.5](#l-93.5), eine Frage an Gregor).

---

## Funde aus LEKTOR-92

| Fund | Was es war | Heute | Beleg |
|---|---|---|---|
| [L-92.1](LEKTOR-92.md#l-92.1) | [E-169](../Intern/BEFUNDE.md#e-169) (Druckvorschau ohne Bilder) suchte die Stelle, die `eud*.htm` schreibt | **teilweise** — Fundstelle und Folgerung stehen jetzt drin; die widerlegte Vermutung steht aber weiter **davor**, als erste von zwei, ohne Streichung → [L-93.1](#l-93.1) | `Intern/BEFUNDE.md:386` *„die Zwischendatei schreibt `CTridentView::LoadMessage` (`TridentView.cpp:1530`), und das Lesefenster lädt **dieselbe** Datei (`:1633` …)“* (belegt) |
| [L-92.2](LEKTOR-92.md#l-92.2) | FILTER.md nennt verrutschte Zeilen; FAQ eine Zeile daneben | **offen** — unverändert | `Intern/FILTER.md:228` weiter *„`filtersd.cpp:1151-1155`“*, `:220` *„`EudoraRes.rc:6063-6093`“*, `:22` *„Die Zeilennummern beziehen sich auf den Stand dieses Zweigs“*; `Doku/FAQ.md:56` weiter *„`EudoraRes.rc:6088`“* (richtig `:6089`, gemessen in [LEKTOR-92](LEKTOR-92.md#lektor-92)) (belegt) |
| [L-92.3](LEKTOR-92.md#l-92.3) | FAQ: „Sortierfeld über der Liste“ | **erledigt** | `Doku/FAQ.md:43-44` *„auf den Spaltenkopf *Label* klicken, oder *Edit → Sort → Sort by Label*“*; `:68` *„Sortieren `:5633`“* — `EudoraRes.rc:5633` *„MENUITEM "Sort by &Label", ID_EDIT_SORT_SORTBYLABEL“* (gemessen) |
| [L-92.4](LEKTOR-92.md#l-92.4) | Hintergrund nur mit Fokus; Fundstelle daneben | **erledigt** | `Doku/FAQ.md:61-62` *„solange die Zeile ausgewählt ist und die Liste den Fokus hat (sonst ist die ausgewählte Zeile grau)“*; `:68` *„`:5943-5954`“* — `EudoraRes.rc:5943` *„POPUP "Change &Label"“* (gemessen) |
| [L-92.5](LEKTOR-92.md#l-92.5) | README kündigte die FAQ ohne Labels an | **erledigt** | `README.md:48` *„(Post je Konto trennen, Mails farbig markieren, Anhänge beim Löschen)“* |

**Reste aus [LEKTOR-91](LEKTOR-91.md#lektor-91)**, die [LEKTOR-92](LEKTOR-92.md#lektor-92) als
teilweise führte:

| Fund | Heute | Beleg |
|---|---|---|
| [L-91.1](LEKTOR-91.md#l-91.1) (Startwege-Schranke sieht Starts nicht) | **erledigt** — alle drei Starts vom 20.10. genannt, und warum sie nicht nachgetragen werden | `tools/WERKZEUGE.md:30` *„am 20.10.2026 drei Starts ohne Protokollzeile, einer in `C:\Temp\E131` (20:13:54, schon vorher sichtbar) und zwei bisher unsichtbare in `C:\Temp\E132` (21:24, 21:25) — nachträglich nicht mehr zuzuordnen, deshalb nicht in `TESTLAEUFE.md` nachgetragen“* |
| [L-91.2](LEKTOR-91.md#l-91.2) (Halbsatz in der Abschrift `v1.0.120`) | **erledigt** — der Junk-Nachtrag ist aus dem Teil unter *„bewusst nicht steht“* entfernt | `Releases/1.0.120/RELEASE-NOTIZEN.md:83-84` *„**Verzeichnisdienste**: LDAP, Ph, `EudoraBk` und S/MIME. Siehe [[L-49.4](LEKTOR-49.md#l-49.4)]“*; gemessen: `gh release view v1.0.120 --json body` enthält diesen Abschnitt nicht — er ist Repo-Zusatz unter dem Rumpf, kein Teil der wörtlichen Abschrift |
| [L-91.3](LEKTOR-91.md#l-91.3) (tote Links in drei veröffentlichten Release-Texten) | **teilweise** — liegt als Frage bei Gregor; die Abschrift nennt sich weiter *„wörtlich“*, ihre Links weichen ab | `Releases/1.0.120/RELEASE-NOTIZEN.md:6` *„**Text unten ist der Rumpf des veröffentlichten Releases, wörtlich**“*; veröffentlicht (gemessen, `gh release view`): *„blob/main/BEFUNDE.md#e-135“*, Abschrift `Intern/BEFUNDE.md` |
| [L-91.4](LEKTOR-91.md#l-91.4) (E-166-Prüfschritt am Release) | **teilweise** — die Reihenfolge steht jetzt da. Offen nur der eine Satz, was ein *„kommt wieder“* für die README-Zeile heißt | `Intern/TESTPLAN.md:16-17` *„**zuerst**, in einem frisch ausgepackten Release-Verzeichnis, vor dem übrigen Release-Test“*; `:30` *„Kommt sie wieder, ist [E-166](../Intern/BEFUNDE.md#e-166) nicht behoben — bitte melden.“* — dass `README.md:162` dann ihr *„Behoben ab dem Release 7.2.1“* verlöre, steht nicht da (belegt) |
| [L-91.5](LEKTOR-91.md#l-91.5) (README/CHANGELOG: [E-166](../Intern/BEFUNDE.md#e-166) kommt mit 7.2.1) | **erledigt** | `CHANGELOG.md:108` *„**Kommt mit dem Release 7.2.1**; Gregor prüft es an der Release-Fassung“*; `README.md:162` *„**Behoben ab dem Release 7.2.1**“* |
| [L-91.7](LEKTOR-91.md#l-91.7) („Punktzahl 0“ ohne Bedingung) | **teilweise** — `FILTER.md:737` berichtigt. Offen: die Folge für `DeleteFetchedJunk` bei **geladenem** Modul; `README.md:167` wiederholt den Ort `SysWOW64` (doppelt, nicht falsch) | `Intern/FILTER.md:737` *„verhält sich dann wie oben unter *Praktisch heißt das* beschrieben“* — der Anker steht in `:515` (gemessen); `:530-533` unverändert *„Einer Einstufung, die auf einem nicht geladenen Modul beruht, darf man keine Post zum Löschen anvertrauen.“* |
| [L-91.9](LEKTOR-91.md#l-91.9) (Kopfzeilen auf dem 28.10.) | **erledigt** | `ZIEL.md:181` *„**Stand 29.10.2026.**“* |

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe | Bewertung |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„gepruefte Dateien 48 … Kennungen im Verzeichnis 161 … Kein Widerspruch gefunden.“*, dazu *„Zur Kenntnis“* 15 Dateien, die 7.2.0.127 nicht nennen (`Doku/HINTERGRUND.md`, `Intern/PORTIERUNG.md`, `MELDUNGEN-VON-AUSSEN.md`, die Release-Notizen 1.0.101 bis 1.0.120 …) | dieselbe Rauschliste wie in [LEKTOR-92](LEKTOR-92.md#lektor-92) (dort 14 genannt); alte Notizen sollen alt bleiben. Die Stufe der neuen Befunde und Zeilennummern prüft es nicht |
| `perl tools/offene-befunde.pl` | *„offen laut Intern/BEFUNDE.md 45 … davon aktuell gemessen 5 … davon veraltet gemessen 25 … davon NIE gemessen 15 … in Intern/WEITERMACHEN.md 45 … 45 offene Befunde, in beiden Listen gleich.“* | 42 aus [LEKTOR-92](LEKTOR-92.md#lektor-92) plus [E-170](../Intern/BEFUNDE.md#e-170), [E-171](../Intern/BEFUNDE.md#e-171), [E-172](../Intern/BEFUNDE.md#e-172) — stimmt. Alle drei zählen als *nie gemessen*; bei [E-171](../Intern/BEFUNDE.md#e-171) unterschlägt das Gregors Protokoll ([L-93.4](#l-93.4)) |

---

## <a id="l-93.1"></a>L-93.1 — unvollständig: E-169 nennt die widerlegte Vermutung weiter zuerst

**Was passiert:** der Befund zur Druckvorschau ohne Bilder trägt jetzt die
richtige Stelle und sagt selbst, dass die erste Vermutung nicht trägt — aber
erst im Teil *„Was noch fehlt“*. Vorn unter *„Vermutungen“* steht sie
unverändert als erste, ohne Streichung. Wer die Zeile liest, liest zuerst die
falsche Erklärung. Dazu sagt der Klartext-Satz *„als Nächstes wird am
Prüfstand gemessen“*, während derselbe Befund die Messung *„erst nach dem
Release 7.2.1“* ansetzt.

* **Belegt**, `Intern/BEFUNDE.md:386` *„**Vermutungen, nicht gemessen:** die
  Bilder sind Verweise auf den Server des Absenders, die das Lesefenster
  lädt, die Vorschau der Zwischendatei aber nicht“* — und in derselben Zeile
  weiter hinten *„die Vermutung „Lesefenster lädt Bilder, Zwischendatei
  nicht“ trägt damit nicht“*.
* **Belegt**, ebenda *„Gregor muss nichts tun; als Nächstes wird am
  Prüfstand gemessen, welche Mails es trifft.“* gegen *„erst **nach dem
  Release 7.2.1** (Gregor 29.10.2026) die Ursache“*.
* **Belegt am Quelltext**, unverändert seit [LEKTOR-92](LEKTOR-92.md#lektor-92):
  `TridentView.cpp:1530` `GetTempFileName( szPath, "eud", …)`, `:1633`
  `m_pSite->Load(…m_szTmpFile)`.

**Was zu tun wäre:** die erste Vermutung vorn streichen oder als *„widerlegt
am Quelltext, siehe unten“* kennzeichnen; *„als Nächstes“* durch *„nach dem
Release 7.2.1“* ersetzen. Hindert den PR nicht.

## <a id="l-93.2"></a>L-93.2 — ungenau (Stufe): E-170 ist nach dem Wortlaut der Legende eher „kritisch“

**Was passiert:** wer eine Mail mit Label innerhalb eines IMAP-Kontos in
einen anderen Ordner verschiebt, verliert das Label, ohne dass Eudora etwas
meldet. Der Befund stuft das *wichtig* ein und begründet es selbst mit
*„still“*. Die Legende vergibt *wichtig* nur, wenn nichts verloren geht und
der Anwender es sofort merkt; still Verlorenes steht unter *kritisch*. Ob ein
Label als „Einstellung“ oder „Post“ zählt, ist ein Urteil — aber die
Begründung im Befund widerspricht der Stufe, die sie trägt.

* **Belegt**, `Intern/BEFUNDE.md:385` *„**Stufe: wichtig** (eine gesetzte
  Markierung verschwindet still; die Mail selbst bleibt)“*.
* **Belegt**, Legende `Intern/BEFUNDE.md:147` *„**kritisch** | Post oder
  Einstellungen gehen verloren oder werden still beschädigt“*; `:148`
  *„**wichtig** | Eine Funktion ist unbrauchbar, aber nichts geht verloren
  und der Anwender merkt es sofort“*.
* **Belegt am Quelltext**, die Ursache trägt: `EuImap/src/ImapToc.cpp:483`
  `CTocDoc::ImapXferOnSameAccount`; `pSumNew` wird in `:498` mit `NULL`
  angelegt und unverändert in `:600` zurückgegeben (gemessen: im ganzen
  Rumpf `:483-601` keine weitere Zuweisung); `:588` `ImapRemoveOrderedSubSums`
  entfernt die Quell-Zusammenfassung. Neue Zusammenfassung:
  `Eudora/summary.cpp:513` *„m_Label = 0;“*; Kopie lokal → IMAP
  `summary.cpp:594` *„m_Label = NewInfo->m_Label;“*. `$Label` im Baum:
  kein Treffer (gemessen, `git grep`).
* Kleinigkeit: `ImapToc.cpp:1453` ist *„if (!bSchonImZiel)“*, der Aufruf
  `pCopySum->Copy(pSum)` steht in `:1455` — zwei Zeilen daneben.

**Was zu tun wäre:** die Stufe auf *kritisch* heben, oder die Begründung so
fassen, dass sie zur Legende passt (etwa: das Label ist eine Anzeige-Hilfe,
keine Einstellung). Für das Release ohne Folge — Gregor hat am 23.10.
entschieden, dass kritische Befunde 7.2.1 nicht aufhalten
([entscheidung-kritische-nicht-release-blocker](../Arbeitsweise/entscheidung-kritische-nicht-release-blocker.md));
es ändert nur, was `pruefe-regressionstest.pl` als
kritisch ohne Prüfung zählt. Hindert den PR nicht.

## <a id="l-93.3"></a>L-93.3 — ungenau (Stufe): E-172 begründet „wichtig“ mit „nichts geht verloren“, ohne es zu wissen

**Was passiert:** eine Mail erscheint als seitenlange Base64-Zeichenfolge.
Der Befund sagt selbst, offen sei, ob das nur die Anzeige ist oder ob die
Mail so gespeichert wurde — und stuft trotzdem mit *„nichts geht verloren“*
ein. Ist sie undekodiert gespeichert, ist das nach der Legende *„eine
Nachricht … kommt falsch an“*, also *kritisch*. Der Hinweis auf
[E-145](../Intern/BEFUNDE.md#e-145) (Base64-Dekodieren wertet Bytes über 127
falsch) passt zum Bild schlecht: der liefert einzelne falsche Bytes, nicht
ganz undekodierten Text.

* **Belegt**, `Intern/BEFUNDE.md:383` *„Ob das ein Anzeigefehler ist oder
  die Mail selbst einen nicht dekodierten Teil enthält, ist offen.“* und
  *„**Stufe: wichtig** (Mail unlesbar, nichts geht verloren)“*.
* **Belegt**, Legende `Intern/BEFUNDE.md:147` *„eine Nachricht geht falsch
  hinaus oder kommt falsch an“* unter *kritisch*.
* **Belegt**, `Intern/BEFUNDE.md:398` ([E-145](../Intern/BEFUNDE.md#e-145))
  *„heraus kommen einzelne falsche Byt[es]“*, *„**Stufe: unkritisch**“*.
* Kleinigkeit: Titel *„im Lesefenster“*, Klartext *„im eigenen Fenster“* —
  das ist dasselbe, nur zwei Wörter dafür (**Vermutung**, dass es dasselbe
  Fenster meint).

**Was zu tun wäre:** die Stufe als vorläufig kennzeichnen (*„wichtig, bis
geklärt ist, ob die Mail so gespeichert ist; dann kritisch“*); den
E-145-Satz auf *„unwahrscheinlich, [E-145](../Intern/BEFUNDE.md#e-145) verfälscht einzelne Bytes“*
abschwächen. Hindert den PR nicht.

## <a id="l-93.4"></a>L-93.4 — ungenau: E-171 hält einen belegten Weg für eine Vermutung, eine Zeile ist verrutscht, und die Listen nennen es „nie gemessen“

**Was passiert:** der Befund zur falschen Fehlermeldung bei *Search
Mailfolder* ohne Auswahl ist am Quelltext sauber hergeleitet. Drei kleine
Ungenauigkeiten: dass *Search Mailbox* und *Search Eudora* denselben Fehler
haben, ist nicht nur vermutet — alle drei Menüpunkte rufen dieselbe
Funktion. Eine Zeilenangabe liegt eine Zeile daneben. Und die erzeugten
Listen führen den Befund als *„nie gemessen“*, obwohl Gregors Protokoll den
Fehler dreimal zeigt.

* **Belegt**, `Intern/BEFUNDE.md:384` *„Dasselbe gilt vermutlich für *Search
  Mailbox* und *Search Eudora* (gleicher Weg, nicht gemessen)“* —
  `Eudora/TridentView.cpp:1159` `OnSearchInEudoraForSelection(false, true);`
  (*Search Eudora*), `:1172` `(false, false)` (*Search Mailbox*), `:1185`
  `(true, false)` (*Search Mailfolder*); alle drei Freigaben laufen über
  `OnUpdateSearchForSelection` mit `pCmdUI->Enable(TRUE)` (`:1111`)
  (belegt am Quelltext; am Programm nicht gemessen).
* **Belegt**, *„`CSearchView::DoSearch` (`SearchView.cpp:2591-2592`)“* —
  gemessen: `:2590` `ASSERT(m_MSC.GetCriteriaList()->size() > 0);`, `:2591`
  leer, `:2592` `if (m_MSC.GetCriteriaList()->size() == 0)`, `:2593`
  `return false;`. Richtig wäre `:2590-2593`.
* **Belegt**, der Rest stimmt: `TridentView.cpp:1094-1112`, `:1115-1131`,
  `guiutils.cpp:3351` `void OpenFindMessagesWindow(` mit letztem Parameter
  `bool bStartSearch`, `SearchView.cpp:2474-2475` *„if (!DoSearch())
  ErrorDialog(IDS_SEARCH_INTERNAL_ERROR);“*, `EudoraRes.rc:9330`
  `IDS_SEARCH_INTERNAL_ERROR`. Warum kein Kriterium gilt: `GetCriteria`
  (`SearchView.cpp:2275ff`) gibt bei leerem Text `false` zurück
  (`str.IsEmpty()` … `return (false);`, gemessen).
* **Gemessen**, `perl tools/offene-befunde.pl` zählt [E-171](../Intern/BEFUNDE.md#e-171) unter *„NIE
  gemessen 15“*; `CHANGELOG.md:28` und `Intern/WEITERMACHEN.md:368` zeigen
  *„**nie gemessen**“*, während `BEFUNDE.md:384` *„im Protokoll belegt“*
  (Gregors `eudora.log`, drei Fälle) trägt.

**Was zu tun wäre:** *„vermutlich … nicht gemessen“* durch *„derselbe Weg
(`TridentView.cpp:1156-1186`), am Programm nicht gemessen“*;
`SearchView.cpp:2590-2593`; im Urteil *„gemessen an 1.0.127 (Gregors
Protokoll)“*, damit das Werkzeug es als gemessen erkennt — oder es bewusst
so lassen, weil die Behebung erst nach dem Release kommt. Hindert nichts.

## <a id="l-93.5"></a>L-93.5 — Hinweis: die FAQ empfiehlt *Make Label* mit *Transfer To* und weiß nichts von E-170

**Was passiert:** die FAQ-Antwort *„Wie markiere ich wichtige Mails
farbig?“* — die einzige, die Gregor am Programm bestätigt hat — schlägt vor,
an die Label-Regel weitere Aktionen wie *Transfer To* anzuhängen. Wer ein
IMAP-Konto hat und von Hand oder per Filter in einen anderen Ordner
desselben Kontos verschiebt, verliert das Label ([E-170](../Intern/BEFUNDE.md#e-170)).
Die FAQ sagt das nicht; README und ANWENDER auch nicht.

* **Belegt**, `Doku/FAQ.md:52-53` *„*Action:* **Make Label** → `Wichtig`.
  Weitere Aktionen (etwa *Transfer To*) lassen sich darunter anhängen.“*
* **Belegt**, `git grep 'E-170'` außerhalb `Befunde/`: nur
  `Intern/BEFUNDE.md:385`, `CHANGELOG.md:29`, `Intern/WEITERMACHEN.md:369`
  (gemessen).
* **Belegt am Quelltext**, das Verschieben von Hand: siehe [L-93.2](#l-93.2).
  **Vermutung**, nicht gelesen: ob ein Filter mit *Transfer To* in einem
  IMAP-Konto über denselben Weg `ImapXferOnSameAccount` läuft.
* Gregor am 29.10.2026 in [E-170](../Intern/BEFUNDE.md#e-170): *„das muß nur erstmal nur als befund drin
  stehen.“* — das spricht gegen einen Eintrag in der Anwender-Doku vor dem
  Release; deshalb als Frage an ihn ([unten](#gregor)), nicht als Fehler.

**Was zu tun wäre:** wenn Gregor ja sagt, ein Satz unter dem Label-Teil der
FAQ: *„In einem IMAP-Konto geht das Label verloren, wenn die Mail in einen
anderen Ordner desselben Kontos verschoben wird ([[E-170](../Intern/BEFUNDE.md#e-170)])“*.

## <a id="l-93.6"></a>L-93.6 — Hinweis: der Einstieg in WEITERMACHEN kennt nur E-169, und Gregors „nach dem Release“ steht nicht bei den Entscheidungen

**Was passiert:** der Satz, mit dem die nächste Sitzung beginnt, nennt als
neu nur [E-169](../Intern/BEFUNDE.md#e-169) und nicht, dass [LEKTOR-92](LEKTOR-92.md#lektor-92) eingearbeitet ist. [E-170](../Intern/BEFUNDE.md#e-170), [E-171](../Intern/BEFUNDE.md#e-171) und
[E-172](../Intern/BEFUNDE.md#e-172) fehlen dort. Gregors Entscheidung vom 29.10., alle vier erst nach dem
Release zu beheben, steht in jedem der vier Befunde, aber nicht in der
nummerierten Liste der Entscheidungen, die bei 15 endet.

* **Belegt**, `Intern/WEITERMACHEN.md:7` *„[[LEKTOR-90](LEKTOR-90.md#lektor-90)] und [[LEKTOR-91](LEKTOR-91.md#lektor-91)] sind
  eingearbeitet … Neu: [[E-169](../Intern/BEFUNDE.md#e-169)] (Druckvorschau ohne Bilder). **Als Nächstes:**
  PR `e166-junk_message_fix` → `main`.“*
* **Belegt**, `Intern/WEITERMACHEN.md:136` beginnt *„15. **Entschieden von
  Gregor am 29.10.2026:** die Behebung von [[E-166](../Intern/BEFUNDE.md#e-166)] …“*; eine Nummer 16 gibt es
  nicht (gemessen: `grep -n '^> 1[0-9]\.'`).
* **Belegt**, die Entscheidung selbst: `Intern/BEFUNDE.md:385` *„(Gregor
  29.10.2026: *„die findigs können wir erst nach dem release beheben. das muß
  nur erstmal nur als befund drin stehen.“*)“*; ebenso `:383`, `:384`, `:386`
  *„erst **nach dem Release 7.2.1** (Gregor 29.10.2026)“*.

**Was zu tun wäre:** `WEITERMACHEN.md:7` auf *„[LEKTOR-90](LEKTOR-90.md#lektor-90) bis [LEKTOR-92](LEKTOR-92.md#lektor-92)
eingearbeitet … Neu: [E-169](../Intern/BEFUNDE.md#e-169) bis [E-172](../Intern/BEFUNDE.md#e-172), alle erst nach dem Release“*; ob die
Entscheidung als Nr. 16 mit Verweis auf die vier Befunde eingetragen wird,
ist Form ([eine-stelle-dann-verlinken](../Arbeitsweise/eine-stelle-dann-verlinken.md)
spricht für einen Eintrag mit Links statt vier Wiederholungen). Hindert den
PR nicht.

---

## Geprüft ohne Fund

* **Klartext vorn bei [E-170](../Intern/BEFUNDE.md#e-170), [E-171](../Intern/BEFUNDE.md#e-171), [E-172](../Intern/BEFUNDE.md#e-172)** (belegt, `Intern/BEFUNDE.md:383-385`):
  jede Statusspalte beginnt mit dem fetten Urteil *„offen, …“*, danach drei
  Sätze ohne Kürzel, die mit *„Gregor muss nichts tun.“* enden — wie die
  Regel `:23-25` verlangt. Das zweite Fettgedruckte beginnt mit *„Kurz:“*;
  die Werkzeuge lesen nur das erste (`:23`), `offene-befunde.pl` zählt alle
  drei (gemessen).
* **[E-170](../Intern/BEFUNDE.md#e-170), Belege** (gemessen): `ImapToc.cpp:483` *„CSummary\*
  CTocDoc::ImapXferOnSameAccount(CTocDoc \*pTargetToc,“*,
  `summary.cpp:513` und `:594` wie zitiert; `CSummary::Copy` im Weg lokal →
  IMAP `ImapToc.cpp:1455`. Die Ursache trägt (siehe [L-93.2](#l-93.2)).
* **[E-171](../Intern/BEFUNDE.md#e-171), Stufe *unkritisch*** (Urteil): das Suchfenster geht auf, man kann
  einen Begriff eintragen und suchen; falsch ist nur die Meldung. Passt eher
  zu *„Aussehen, Reste, Bequemlichkeit“* (`BEFUNDE.md:149`) als zu *wichtig*
  (*„Suche geht nicht auf“*, `:148`).
* **Doppelte Einträge** (gemessen, `perl tools/befund-suchen.pl` nach dem
  Ort): `ImapXferOnSameAccount` → nur [E-170](../Intern/BEFUNDE.md#e-170); `CImapSameServerTransferMsgAction`
  → [E-170](../Intern/BEFUNDE.md#e-170) und [E-123](../Intern/BEFUNDE.md#e-123) (Bilder nach Neustart
  mitten in lokal → IMAP, anderer Fehler); `OnSearchInEudoraForSelection`,
  `OpenFindMessagesWindow`, `DoSearch` → nur [E-171](../Intern/BEFUNDE.md#e-171); `m_Label` → [E-170](../Intern/BEFUNDE.md#e-170) und
  [E-68](../Intern/BEFUNDE.md#e-68) (Zielpostfächer in `Filters.pce`, anderer
  Fehler). Kein Doppel.
* **Erzeugte Blöcke** in `CHANGELOG.md:27-30` und
  `Intern/WEITERMACHEN.md:367-370` führen [E-169](../Intern/BEFUNDE.md#e-169) bis [E-172](../Intern/BEFUNDE.md#e-172) in derselben
  Reihenfolge und mit *„erst nach dem Release 7.2.1“*.
* **`FILTER.md:737`** verweist auf *„Praktisch heißt das“* — die Überschrift
  steht in `:515` (gemessen).

## Nicht geprüft

* [E-172](../Intern/BEFUNDE.md#e-172) am Quelltext — es gibt keine Stelle, der Befund hat keinen Ort.
* Ob eine Filter-Aktion *Transfer To* in einem IMAP-Konto über
  `ImapXferOnSameAccount` läuft ([L-93.5](#l-93.5)).
* Nichts am laufenden Programm — Auftrag ohne Start.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Soll die FAQ (oder die README) vor dem Release sagen, dass ein Label beim
  Verschieben innerhalb eines IMAP-Kontos verloren geht** ([E-170](../Intern/BEFUNDE.md#e-170),
  [L-93.5](#l-93.5))? Dein *„erstmal nur als befund“* spricht dagegen; die
  FAQ empfiehlt aber gerade *Make Label* mit *Transfer To*.
* **Die veröffentlichten Release-Texte `v1.0.113`, `v1.0.117`, `v1.0.120`**
  mit sieben toten Links auf `BEFUNDE.md` — die Frage ist gestellt
  (`WEITERMACHEN.md:138`, [LEKTOR-91](LEKTOR-91.md#l-91.3)), hier nur
  erwähnt.
* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)) und **Kriterium 0 ohne Visual Studio**
  ([L-77.3](LEKTOR-77.md#l-77.3)) — unverändert offen.
