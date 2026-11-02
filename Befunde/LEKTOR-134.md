# <a id="lektor-134"></a>LEKTOR-134 — Bestand nach den Messungen vor 7.2.2.132 (E-141, E-170, E-176, E-179), Zweig messungen_vor_7_2_2_132 nach fc2f9eae (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: LEKTOR-133 (`Befunde/LEKTOR-133.md`, liegt auf `origin/wt/lektor-20261102` und `origin/e194_e196_speichern_unter`, nicht in diesem Zweig und nicht auf `main` — darum hier ohne Verweis; gelesen mit `git show origin/wt/lektor-20261102:Befunde/LEKTOR-133.md`).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102b`, abgezweigt von `origin/messungen_vor_7_2_2_132`, Stand `fc2f9eae` (*„Merge remote-tracking branch 'origin/main' into messungen_vor_7_2_2_132“*).
Umfang: Bestand der MD-Dateien außerhalb von `Arbeitsweise/` und `Befunde/`. `git log 456c95e1..HEAD` umfasst 33 Commits, davon sind alle außer sechs schon auf `main` (#207, #208) und dort von [LEKTOR-131](LEKTOR-131.md#lektor-131) und [LEKTOR-132](LEKTOR-132.md#lektor-132) geprüft. Schwerpunkt sind darum die sechs eigenen Commits `origin/main..HEAD` (gemessen): `ae8083b0` (Zweig eingetragen), `c3a56169` ([E-170](../Intern/BEFUNDE.md#e-170)), `ffc3fd81` ([E-141](../Intern/BEFUNDE.md#e-141)), `9bfbd0ce` (*„[E-179](../Intern/BEFUNDE.md#e-179) am Pruefstand bestaetigt, [E-141](../Intern/BEFUNDE.md#e-141) bestaetigt, [E-170](../Intern/BEFUNDE.md#e-170) bleibt offen, [E-176](../Intern/BEFUNDE.md#e-176) nicht messbar“*), `ebb003d7` (Gegenprobe an 7.2.1.128), `fc2f9eae` (Merge von `main`). Keine Codeänderung unter `Eudora71/` (`git diff --stat origin/main HEAD -- Eudora71` → leer, gemessen). Nichts gebaut, nichts gestartet, keine Prüfstände angefasst; `pruefstand-buch.tsv`, `pruefstand-ergebnis.txt`, Messskripte und Quelltext nur gelesen.

## Kurz

Die vier neuen Urteile stimmen mit dem, was gemessen wurde: [E-141](../Intern/BEFUNDE.md#e-141) (falsche Meldung *„No messages were transferred!“* nach dem Ziehen eines IMAP-Entwurfs nach `Out`) und [E-179](../Intern/BEFUNDE.md#e-179) (Zeichenangaben wie `&#128293;` im Textteil verfälscht) sind am alten Bau rot und am neuen grün; die Behebungen stehen im Release-Stand `v7.2.1.131` (`git grep` am Tag, gemessen), und der gemessene Bau `f31dbff9` unterscheidet sich vom Tag nur in Hilfe-Menü und [E-39](../Intern/BEFUNDE.md#e-39) (`mainfrm.cpp`, `persona.cpp`, Ressourcen, Tests) — „behoben in 7.2.1.131, bestätigt“ ist damit belegt. [E-170](../Intern/BEFUNDE.md#e-170) (Label geht beim Verschieben im IMAP-Konto verloren) heißt zu Recht weiter offen, [E-176](../Intern/BEFUNDE.md#e-176) (Lesen aus freigegebenem Speicher) zu Recht „nicht messbar“. README, CHANGELOG-Block, AUFGABEN, ZWEIGE und WERKZEUGE sind nachgezogen. **Nicht in Ordnung:** drei Anwendertexte versprechen zu [E-170](../Intern/BEFUNDE.md#e-170) weiter, was die Messung widerlegt hat (Release-Notizen auf GitHub, FAQ, TESTPLAN); die erzeugten Listen zeigen bei [E-170](../Intern/BEFUNDE.md#e-170) die alte Aufgabe, weil der neue Text eine andere Marke benutzt; die E-179-Bestätigung reicht in README und CHANGELOG weiter als der gemessene Weg. Neun Funde, keiner am Programmcode.

## Funde aus LEKTOR-133 — heutiger Stand

LEKTOR-133 prüfte `e194_e196_speichern_unter`. Dieser Zweig ist **nicht** gemergt: `git merge-base --is-ancestor origin/e194_e196_speichern_unter origin/main` → nein; `git branch -r --contains origin/e194_e196_speichern_unter` → nur er selbst und `origin/wt/lektor-20261102` (gemessen). Was LEKTOR-133 dort berichtigt sehen wollte, steht darum weder auf `main` noch hier; gemessen ist der Stand mit `git show origin/e194_e196_speichern_unter:<datei>` (Spitze `5204474a`, *„LEKTOR-133 Nachtrag 1: L-133.1 bis L-133.8 erledigt …, neu L-133.9“*).

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| L-133.1 Zweig auf #206, sechs Konflikte | **erledigt auf `e194_…`** | laut LEKTOR-133 Nachtrag 1 `main` hereingeholt; hier nicht nachgemessen. Neu: dieser Zweig und `e194_…` stoßen beim zweiten Merge aufeinander ([L-134.9](#l-134.9)) |
| L-133.2 Stand-Köpfe, Berichtszahl | **erledigt auf `e194_…`, hier offen** | `origin/e194_…:Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `e194_e196_speichern_unter`“*, `origin/e194_…:README.md:98` *„(216 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026)“*; hier siehe [L-134.6](#l-134.6) |
| L-133.3 README/CHANGELOG zu E-207 | **erledigt auf `e194_…`**, hier nicht enthalten | laut Nachtrag 1; hier gibt es E-207 gar nicht (`grep -c 'id="e-207"' Intern/BEFUNDE.md` → 0) |
| L-133.4 [E-195](../Intern/BEFUNDE.md#e-195) im Signaturfenster | **erledigt auf `e194_…` als Einengung**, hier nicht enthalten | wie L-133.3 |
| L-133.5 E-206 „nie gemessen“ | **erledigt auf `e194_…`**, hier nicht enthalten | wie L-133.3 |
| L-133.6 Messangaben [E-194](../Intern/BEFUNDE.md#e-194) bis [E-196](../Intern/BEFUNDE.md#e-196) | **erledigt auf `e194_…`**, hier nicht enthalten | wie L-133.3 |
| L-133.7 CHANGELOG „alle drei Wege“, ZWEIGE | **erledigt auf `e194_…`**, hier nicht enthalten | wie L-133.3 |
| L-133.8 FAQ 15 *Save As* „unverändert“ | **erledigt auf `e194_…`**, hier offen | hier `Doku/FAQ.md` unverändert gegen `main` (`git diff origin/main HEAD -- Doku/FAQ.md` → leer) |
| L-133.9 Nachbarfälle nicht am gemergten Bau | **offen auf `e194_…`** | `origin/e194_…:CHANGELOG.md:127` *„`E-140p`, `E-177p`, `E-178p` am neuen Bau grün.“*; `origin/e194_…:Intern/pruefstand-buch.tsv:38`, `:45`, `:46` weiter *„2026-11-02 17:04:02 … Eudora 7.2.1.131+cecab886*“* |
| [L-131.8](LEKTOR-131.md#l-131.8) Berichtszahl in der README | **offen, die Klasse ohne Werkzeug** | `README.md:98` *„(213 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026)“* bei 214 im Verzeichnis (`ls Befunde \| grep -cE '^(LEKTOR\|PRUEFER)-[0-9]+\.md$'`), mit diesem 215 |
| [L-130.1](LEKTOR-130.md#l-130.1) persönliche Angabe in alten Zweigen | **unverändert** | `git branch -r --contains d9ae24c8` → `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d`; dieser Zweig ist frei davon |
| [L-129.1](LEKTOR-129.md#l-129.1) Schranke „zuletzt veröffentlicht“ | **offen** | `grep -c 'zuletzt ver' tools/pruefe-release-buchfuehrung.pl` → 0 |
| [L-128.2](LEKTOR-128.md#l-128.2) Schranke gegen „läuft“ nach dem Merge | **offen**, zum zehnten Mal aufgetreten ([L-134.6](#l-134.6)) | `grep -l 'PR folgt\|Laufend' tools/*.pl` → kein Treffer |
| [L-128.3](LEKTOR-128.md#l-128.3) Entwurfskopf in der Notizdatei | **offen** | `tools/release-veroeffentlichen.ps1:128` *„if ($text -match 'noch nicht best')“* nur am CHANGELOG |
| [L-126.5](LEKTOR-126.md#l-126.5) Starts ohne Titelzeile | **teilweise** | vom 02.11. 146 Zeilen, 30 ohne `[Eudora` (`grep '^\| 2026-11-02' tools/TESTLAEUFE.md \| grep -vc '\[Eudora'`); von den 27 Zeilen dieses Zweigs (`EM1…`) eine ohne; die übrigen elf ohne Titel unter den 57 neuen Zeilen sind nachgetragene fremde Starts (`C:\Temp\E194…`) |

## Die neuen Urteile gegen Messung und Quelle

| Aussage | Stelle | Gegen (gemessen, wo nicht anders gesagt) |
|---|---|---|
| Behebungen stecken im Release `v7.2.1.131` | `BEFUNDE.md:394`, `:412` *„behoben in 7.2.1.131“*; `:415` *„Die Behebung ist ausgeliefert“* | `git grep` am Tag `v7.2.1.131` (`7564f54e`): `tocdoc.cpp:3178` *„( (IsImapToc() \|\| (TargetToc && TargetToc->IsImapToc())) && sumlist.GetCount() > 0 )“* (am Tag `v7.2.1.128` noch ohne die Klammer, `:3167`), `E179ZeichenAusNummer` in `html2text.cpp` 4×, `E176ZusammenfassungStirbt` in `summary.cpp` 1×, `E170LabelsNachtragen` in `ImapActionQueue.cpp` 3× — trifft |
| gemessener Bau `7.2.1.131+f31dbff9` steht für das Release | `BEFUNDE.md:394` *„Quellstand gleich `main` 88142c78“* | `git diff --stat v7.2.1.131 f31dbff9 -- Eudora71` → nur `EudoraRes.rc`, `mainfrm.cpp`, `mainfrm.h`, `persona.cpp`, `resource.h` und vier Testdateien; `git diff f31dbff9 88142c78 -- Eudora71` → leer. Dass Hilfe-Menü und [E-39](../Intern/BEFUNDE.md#e-39) die vier Wege nicht berühren, ist aus der Dateiliste belegt, nicht gemessen |
| Vorher-Bau `7.2.1.128+640e1a0e` ist das Release 7.2.1.128 | `BEFUNDE.md:394`, `:412`, `:419`; `pruefstand-faelle.txt` (Kopf des neuen Blocks) | Tag `v7.2.1.128` ist `c8b0893f`; `git diff --stat 640e1a0e v7.2.1.128 -- Eudora71` → leer — gleicher Quellstand, trifft |
| [E-141](../Intern/BEFUNDE.md#e-141) vorher `nicht-uebertragen=1`, nachher `0`, Gegenprobe gleich | `BEFUNDE.md:394`; `README.md:197`; `CHANGELOG.md:122` | `pruefstand-buch.tsv` *„E-141p ok 2026-11-02 18:00:23 … nicht-uebertragen=0 expunge=0 lokal=1“*, *„E-141g-alt ok 2026-11-02 18:13:07 … 7.2.1.128+640e1a0e … geloescht=2 lebt=1“*; `pruefstand-ergebnis.txt` *„[FEHL] E-141p-alt fehlt in messung: … nicht-uebertragen=0 …“* — rot am alten Bau belegt; der Wert `nicht-uebertragen=1` selbst steht nur im Befundtext und in der Commit-Nachricht `ffc3fd81`, in keiner Protokolldatei |
| [E-141](../Intern/BEFUNDE.md#e-141): nur die Meldung gemessen, nicht der `EXPUNGE` | `BEFUNDE.md:394` *„`expunge=0` an beiden, weil *Remove on delete* im Prüfstand aus ist — der `EXPUNGE`-Zweig ist damit nicht gemessen“*; `README.md:197` *„das Bereinigen am Quelltext gelesen“* | trifft, beide sagen es gleich |
| [E-179](../Intern/BEFUNDE.md#e-179) vorher `emoji=kaputt kyr=kaputt hex=fehlt`, nachher alles `entitaet`/`zeichen` | `BEFUNDE.md:412`; `CHANGELOG.md:123` | `pruefstand-buch.tsv` *„E-179p ok 2026-11-02 18:01:00 … emoji=entitaet kyr=entitaet hex=entitaet euro=zeichen umlaut=zeichen lebt=1“*; `pruefstand-ergebnis.txt` *„[FEHL] E-179p-alt …“* — trifft; Reichweite siehe [L-134.3](#l-134.3) |
| [E-170](../Intern/BEFUNDE.md#e-170) bleibt offen; mit UIDPLUS schon der alte Bau richtig | `BEFUNDE.md:419`; `README.md:166`; `CHANGELOG.md:124` | `pruefstand-buch.tsv` *„E-170p ok … kopie-mit-label=1 log-grund=ok lebt=1“*, *„E-170o ok … log-grund=keine-neuen-uids“*; Commit `ebb003d7` *„E-170p-alt rot nur wegen log-grund (Label blieb)“*; Quelltext `ImapActionQueue.cpp:1715` *„szGrund = "keine-neuen-uids";“* — trifft |
| [E-176](../Intern/BEFUNDE.md#e-176) nicht messbar | `BEFUNDE.md:415`; `CHANGELOG.md:125` | belegt nur durch den Befundtext (Suche nach `gflags`, abgewiesener Registrierzugriff); nicht nachgemessen, nichts dazu im Prüfstandsbuch — gewollt, es wurde nichts eingetragen |
| Stufenzählung | `BEFUNDE.md:159` *„\| **wichtig** \| 24 \| 46 \| 4 \| 74 \|“*, `:162` *„\| zusammen \| 52 \| 168 \| 16 \| 236 \|“* | `offene-befunde.pl` *„52 offene Befunde, in beiden Listen gleich.“*; auf `main` 54 — [E-141](../Intern/BEFUNDE.md#e-141) und [E-179](../Intern/BEFUNDE.md#e-179) (beide *wichtig*) geschlossen, trifft |
| neue Werkzeuge in WERKZEUGE | `tools/WERKZEUGE.md:153-155`, `:190` und Stand-Kopf `:3` | jede der Dateien `smtp-pruefserver.pl`, `messen-e141.ps1`, `messen-e170.ps1`, `messen-e170o.ps1`, `messen-e179.ps1` steht dort (`grep -c` ≥ 1); Ergebniszeilen gleich `messen-e141.ps1:341`, `messen-e179.ps1:229`, `messen-e184.ps1:459`; Schalter `--port --ablage --protokoll --zeitschranke` gleich `smtp-pruefserver.pl:34-37`; *„nur auf 127.0.0.1“* gleich `:51` — trifft. Jede `tools/*.pl\|ps1\|sh` aus `git ls-files` steht in WERKZEUGE (Schleife, 0 fehlend) |
| persönliche Angaben | Diff `origin/main..HEAD`, Commit-Nachrichten | in den sechs eigenen Commits kein Pfad aus Gregors Verzeichnissen und keine Adresse; `C:\Temp\EM*` sind Prüfstände (gelesen) |

## Funde

### <a id="l-134.1"></a>L-134.1 — Drei Texte versprechen zu E-170 weiter, dass das Label mit UIDPLUS erhalten bleibt — die Messung sagt: das tat es schon vorher, und ohne UIDPLUS geht es weiter verloren

**Gewicht: mittel.** Ein Anwender liest in den Release-Notizen und der FAQ eine Berichtigung, die nichts ändert; Gregor findet im TESTPLAN einen Schritt, dessen Erwartung nach der Messung bei seinem Server vermutlich nicht eintritt, während der Befund sagt, er müsse nichts tun. (gemessen an den Texten und am Prüfstandsbuch)

- `Releases/7.2.1.131/RELEASE-NOTIZEN.md:39-42` *„Beim Verschieben innerhalb eines IMAP-Kontos bleibt das Label erhalten, wenn der Server die neuen Nummern meldet (am laufenden Programm noch nicht gemessen)“* — wortgleich im veröffentlichten Text des Releases auf GitHub (`gh release view v7.2.1.131 --json body`, Zeilen 39-41, gemessen). Unter „Neu“ gelesen heißt das: vorher ging es verloren. `BEFUNDE.md:419` *„mit UIDPLUS … und das tat schon die alte Fassung 7.2.1.128“*.
- `Doku/FAQ.md:211-212` *„([E-170](../Intern/BEFUNDE.md#e-170); im Quellstand berichtigt für Server, die die neuen Nummern der verschobenen Mails melden — im Testpaket 7.2.1.130).“* — dieselbe Aussage, an der Anwenderseite.
- `Intern/TESTPLAN.md:348-362`, Abschnitt *„In 7.2.1.130: das Label bleibt beim Verschieben im IMAP-Konto“*, Schritt 3 (`:356-357`) *„Den Zielordner öffnen und warten …: die Mail trägt ihr Label.“* — dagegen `BEFUNDE.md:419` *„Gregors Fall ist vermutlich dieser zweite; Gregor muss nichts tun.“* Der Abschnitt steht noch im gültigen Testplan; die erzeugten Listen verweisen auf ihn ([L-134.2](#l-134.2)).
- `Doku/FUNKTIONEN.md:176` *„Geht beim Verschieben im selben IMAP-Konto verloren“* ist enger richtig als die drei oben: nach der Messung nur ohne UIDPLUS. Kein Fund, nur Hinweis.

**Vorschlag:** FAQ: *„… ist das Label danach weg, wenn der Server die neuen Nummern der verschobenen Mail nicht meldet (UIDPLUS); meldet er sie, bleibt es — das war schon vor 7.2.1.130 so (am Prüfstand am 02.11.2026 gemessen). Mit 7.2.1.131 steht im Protokoll, warum es fehlt.“* TESTPLAN-Abschnitt `e-170-naechstes` streichen oder als erledigt kennzeichnen (Schritt 4, die Logzeile mit `grund=keine-neuen-uids`, wäre das Einzige, was Gregors Server zeigen könnte — ob das noch gebraucht wird, entscheidet der Hauptagent). Die Release-Notizen sind veröffentlicht; ob der Text auf GitHub berichtigt wird, entscheidet Gregor (unten).

### <a id="l-134.2"></a>L-134.2 — Die erzeugten Listen zeigen bei E-170 die alte Aufgabe, weil der neue Text „Was fehlt“ statt „Was noch fehlt“ schreibt

**Gewicht: Kleinkram, mit Wirkung auf die Arbeitsliste.** (gemessen)

- `CHANGELOG.md:46` und `Intern/WEITERMACHEN.md:95`, Spalte *was fehlt*: *„die Messung am Programm mit dem Testpaket 7.2.1.130 ([TESTPLAN](../Intern/TESTPLAN.md#e-170-naechstes)); am IMAP-Prüfserver zusätzlich der Fall ohne UIDPLUS.…“* — beides ist seit `c3a56169` getan.
- Ursache: `tools/offene-befunde.pl:295` *„if ($urteil =~ /\*\*Was noch fehlt:\*\*\s*(.+?)(?=\s*\*\*Wie zu pruefen:\*\*|\z)/s)“* nimmt den ersten Treffer der Marke `**Was noch fehlt:**`. Der neue Text in `BEFUNDE.md:419` schreibt *„**Was fehlt:** ein Weg für Server ohne UIDPLUS (Zuordnung nach Merkmalen der Mail, siehe unten); vorher nicht „behoben".“* — ohne „noch“; der erste Treffer liegt darum im alten Teil hinter *„**Bis 02.11.2026 stand hier:**“*.
- Dieselbe Falle hat jeder Befund, dessen alter Teil ein `**Was noch fehlt:**` behält und dessen neuer Teil die Marke anders schreibt. Bei [E-141](../Intern/BEFUNDE.md#e-141) und [E-179](../Intern/BEFUNDE.md#e-179) ohne Folge (geschlossen, in keiner Liste), bei [E-176](../Intern/BEFUNDE.md#e-176) passt der alte Satz zufällig noch.

**Vorschlag:** in `BEFUNDE.md:419` *„**Was noch fehlt:** ein Weg für Server ohne UIDPLUS …“*, die alte Marke im historischen Teil entschärfen (*„Damals fehlte:“*), dann `perl tools/offene-befunde.pl -schreiben`. Als Schranke: `offene-befunde.pl` meldet, wenn die Marke in einem Urteil zweimal vorkommt oder nur hinter „Bis … stand hier“ steht.

### <a id="l-134.3"></a>L-134.3 — E-179: README und CHANGELOG nennen den Textteil einer HTML-Mail und die Suche „bestätigt“; gemessen ist nur das Senden als reiner Text

**Gewicht: Kleinkram.** Der Befund sagt die Grenze selbst; die beiden Kurzfassungen verlieren sie. (gemessen an Texten und Messskript)

- `BEFUNDE.md:412` *„Gemessen ist der Weg *plain only* (`sendmail.cpp` `SendTextContext`, Logzeile `E-88 … SendPlainOnly=1`), nicht `multipart/alternative`.“*
- `tools/messen-e179.ps1:16-18` *„sendmail.cpp SendStyled baut bei "Send both plain and styled" (Vorgabe SendPlainAndStyled=1) ein multipart/alternative und ruft fuer den text/plain-Teil Html2Text.“* — der Weg, den ein Anwender mit der Vorgabe nimmt, ist der nicht gemessene; `:202-204` erklärt, dass der Prüfstand *plain only* trifft, weil die Zusammenfassung in `Out.toc` so steht.
- `README.md:192` *„im **Textteil** einer gesendeten HTML-Mail und in der Suche … auf 7.2.1.131 wechseln; berichtigt ab 7.2.1.130, am Prüfstand am 02.11.2026 bestätigt“* und *„der HTML-Teil bleibt richtig“* — im gemessenen Fall gibt es keinen HTML-Teil. `CHANGELOG.md:123` *„Textteil einer gesendeten HTML-Mail — … an 7.2.1.131 stehen die Angaben unverändert“*. Suche (`X1EmailIndexItem.cpp:251`, laut `BEFUNDE.md:412`) ist nicht gemessen.
- Dass beide Sendewege dieselbe Umwandlung rufen und darum gleich ausgehen, ist belegt (Kommentar `messen-e179.ps1:204`, Aufrufstellen in `BEFUNDE.md:412`), nicht gemessen.

**Vorschlag:** README: *„… am Prüfstand am 02.11.2026 beim Senden als reiner Text bestätigt; der Textteil neben dem HTML-Teil (Vorgabe) und die Suche rufen dieselbe Umwandlung, gemessen sind sie nicht“*; CHANGELOG entsprechend. Oder den Fall um `form=alternative` erweitern (Zusammenfassung ohne *plain only*) — dann darf „bestätigt“ ohne Einschränkung stehen.

### <a id="l-134.4"></a>L-134.4 — E-179 nennt einen Nebenfund (Textteil `iso-8859-1` mit Euro-Byte 0x80), der in keinem Befund steht

**Gewicht: Kleinkram.** (gemessen am Text, belegt durch die Suche)

- `BEFUNDE.md:412` *„Nebenbei gesehen, nicht Teil dieses Befunds: der Textteil trägt `charset="iso-8859-1"`, enthält aber das Euro-Zeichen als Byte 0x80 (windows-1252).“* — ein Empfänger, der sich an die Angabe hält, zeigt statt € ein Steuerzeichen (Vermutung über das Empfängerverhalten).
- `perl tools/befund-suchen.pl SendTextContext` → nur [E-179](../Intern/BEFUNDE.md#e-179); `perl tools/befund-suchen.pl NameCharset` (`sendmail.cpp:745-753`, wählt `IDS_MIME_ISO_LATIN1`) → nur [E-118](../Intern/BEFUNDE.md#e-118), dort für das Hochladen nach IMAP mit eigener `windows-1252`-Erkennung. Für den Sendeweg ist es nirgends geführt; da [E-179](../Intern/BEFUNDE.md#e-179) geschlossen ist, steht es in keiner Liste.

**Vorschlag:** der Hauptagent prüft, ob es zu einem bestehenden Befund gehört, und legt es sonst als eigenen an — mit dem Prüfstandsfall `E-179p` als Messweg (`euro=zeichen` sagt schon, dass das Byte 0x80 dasteht). Keine Kennung von mir.

### <a id="l-134.5"></a>L-134.5 — Die Release-Notizen 7.2.1.131 sagen zu E-141 und E-179 weiter „am laufenden Programm noch nicht gemessen“

**Gewicht: Kleinkram** (Richtung: sie sagen weniger, als jetzt belegt ist). (gemessen)

- `Releases/7.2.1.131/RELEASE-NOTIZEN.md:21-23` *„aus `&#128293;` wird nicht mehr ein einzelnes falsches Zeichen (am laufenden Programm noch nicht gemessen) ([E-179](../Intern/BEFUNDE.md#e-179))“*; `:62-70` zu [E-141](../Intern/BEFUNDE.md#e-141) und [E-176](../Intern/BEFUNDE.md#e-176) *„— beide am Quelltext und im Regressionstest gesichert, am laufenden Programm noch nicht gemessen.“* Ebenso im Text auf GitHub.
- Zur Frage des Auftrags, ob „behoben in 7.2.1.131, bestätigt“ zum CHANGELOG passt: die Behebungen stehen in den Abschnitten der Testpakete — [E-141](../Intern/BEFUNDE.md#e-141) unter 7.2.1.129 (`CHANGELOG.md:224` *„**IMAP nach Out** … stößt die IMAP-Nachbearbeitung nicht mehr an“*), [E-179](../Intern/BEFUNDE.md#e-179) unter 7.2.1.130 (`:63`); der Abschnitt 7.2.1.131 (`:134-136`) nennt sie nicht und sagt auch nicht, dass er die beiden nicht veröffentlichten Testpakete einschließt. In der Sache widerspricht nichts (Tag-Messung oben); die README (`:192`, `:197`) sagt *„berichtigt ab 7.2.1.130“* bzw. *„ab 7.2.1.129“* und *„auf 7.2.1.131 wechseln“* — stimmig.

**Vorschlag:** in der Repo-Datei nichts umschreiben, was veröffentlicht ist, ohne Gregors Ja (unten). Im CHANGELOG-Abschnitt 7.2.1.131 ein Satz *„Enthält auch die Testpakete 7.2.1.129 und 7.2.1.130 (nicht veröffentlicht).“*

### <a id="l-134.6"></a>L-134.6 — Stand-Kopf: WEITERMACHEN nennt `funktionen_ini_abschnitte` laufend, obwohl #208 gemergt ist, und diesen Zweig gar nicht

**Gewicht: Kleinkram, dieselbe Klasse zum zehnten Mal** ([L-128.2](LEKTOR-128.md#l-128.2): nach dem Merge bleibt „läuft“ stehen). (gemessen)

- `Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `funktionen_ini_abschnitte` (in [Doku/FUNKTIONEN.md](../Doku/FUNKTIONEN.md) steht bei jedem Schlüssel sein Abschnitt …)“* — `origin/main` ist `ee7b5400` *„Merge pull request #208 from HansWurst81675/funktionen_ini_abschnitte“*. In Zeile 3 kommen `#200` bis `#207` vor, `#208` nicht.
- `messungen_vor_7_2_2_132` steht in der ganzen Datei nicht (`grep -c messungen Intern/WEITERMACHEN.md` → 0); der Zweig hat nur die beiden Tabellenzeilen über `offene-befunde.pl -schreiben` geändert. CHANGELOG (`:120`), AUFGABEN (`:8`) und ZWEIGE (`:213`) nennen ihn.
- `README.md:98` Berichtszahl 213 bei 214 im Verzeichnis ([L-131.8](LEKTOR-131.md#l-131.8)).

**Vorschlag:** Zeile 3: *„#208: Zweig `funktionen_ini_abschnitte` … Laufend: Zweig `messungen_vor_7_2_2_132` ([E-141](../Intern/BEFUNDE.md#e-141), [E-179](../Intern/BEFUNDE.md#e-179) bestätigt, [E-170](../Intern/BEFUNDE.md#e-170) offen, [E-176](../Intern/BEFUNDE.md#e-176) nicht messbar)“*. Zehn Auftreten in einer Woche: das Werkzeug aus [L-128.2](LEKTOR-128.md#l-128.2) (`Laufend: Zweig <x>` gegen `git log origin/main --merges`) wäre die eine Abhilfe, die alle künftigen abfängt.

### <a id="l-134.7"></a>L-134.7 — Die Gegenprobe an 7.2.1.128 hat Spuren im Repo hinterlassen, die wie ein gescheiterter Gesamtlauf aussehen; ein Fallkommentar widerspricht ihr

**Gewicht: Kleinkram.** (gemessen)

- `Intern/pruefstand-ergebnis.txt` (aus `ebb003d7`): *„faelle=5“*, *„bestanden=1“*, *„fehlgeschlagen=4“*, *„fall=[FEHL] E-170p-alt …“* — ohne die Zeile `nur=…`, die `tools/pruefstand-lauf.ps1:410` bei einem Teillauf schreibt (*„nur=" + $Nur + "   (Teillauf, nicht der Gesamtstand)“*); die Fallliste lag im Scratchpad (Commit-Nachricht *„Fallliste mit -alt-Verzeichnissen nur im Scratchpad“*), darum fehlt die Marke. Wer die Datei liest, sieht den letzten Lauf mit vier roten Fällen. Gelesen wird sie von keinem Werkzeug als Urteil (`tools/pruefbericht.pl:87` schließt sie nur aus, gemessen).
- `Intern/pruefstand-buch.tsv` hat eine Zeile *„E-141g-alt ok 2026-11-02 18:13:07 C:\Temp\EM141-alt Eudora 7.2.1.128+640e1a0e …“* für einen Fall, den `tools/pruefstand-faelle.txt` nicht kennt; die vier roten `-alt`-Fälle stehen nicht darin (das Buch führt nur Bestandenes, Vermutung aus dem Bestand).
- `tools/pruefstand-faelle.txt`, Kommentar zu `E-170p`: *„[E-170](../Intern/BEFUNDE.md#e-170) mit UIDPLUS: das Label bleibt. An BEIDEN Bauten gruen“* — der Fall verlangt `kopie-mit-label=1 log-grund=ok lebt=1` und war am alten Bau rot (`pruefstand-ergebnis.txt` *„[FEHL] E-170p-alt fehlt in messung: kopie-mit-label=1 log-grund=ok lebt=1“*; `ebb003d7` *„E-170p-alt rot nur wegen log-grund (Label blieb)“*). Gemeint ist das Label, nicht der Fall.

**Vorschlag:** Kommentar: *„Das Label bleibt an beiden Bauten; der Fall ist am alten Bau rot nur wegen `log-grund`.“* `pruefstand-lauf.ps1` schreibt die `nur=`-Zeile auch bei einer eigenen Fallliste (oder die Gegenprobe läuft mit `-Nur` und eigenem Verzeichnis). Die `E-141g-alt`-Zeile aus dem Buch nehmen oder die Gegenproben im Buch einheitlich führen.

### <a id="l-134.8"></a>L-134.8 — Zeilenangaben in E-141 und E-176 treffen nicht mehr

**Gewicht: Kleinkram.** (gemessen am Quelltext)

- `BEFUNDE.md:394` ([E-141](../Intern/BEFUNDE.md#e-141)) *„Die Berichtigung selbst steht seit dem 30.10.2026 im Quellstand (`tocdoc.cpp:3170`, die Klammer um den Oder-Teil …)“* — die Bedingung steht `tocdoc.cpp:3178`; in *„Die Kette“* *„`tocdoc.cpp:3001`“* (`sumlist.AddTail`) → heute `:3041`, *„`tocdoc.cpp:3134`“* → `:3178`. *„`EuImap/src/ImapToc.cpp:246-249`“* trifft (`:248` *„if (!bCopy && IsImapToc() && ExpungeAfterDelete(this))“*).
- `BEFUNDE.md:415` ([E-176](../Intern/BEFUNDE.md#e-176)) *„(`summary.cpp:561`; …)“* — der Aufruf `CMessageFrame::E176ZusammenfassungStirbt(this);` steht `summary.cpp:562`.

**Vorschlag:** die vier Angaben nachziehen. Die Kette liegt im Teil hinter „Bis 02.11.2026 stand hier“, ist aber die einzige Herleitung des Befunds und wird weiter gelesen.

### <a id="l-134.9"></a>L-134.9 — Drei Zweige laufen parallel von `main`; dieser und `e194_e196_speichern_unter` geraten beim zweiten Merge in fünf Konflikte

**Gewicht: Kleinkram, aber vor dem zweiten PR zu erledigen.** (gemessen mit `git merge-tree`, nichts ausgecheckt)

- `git merge-tree --write-tree --name-only HEAD origin/e194_e196_speichern_unter` → *„CONFLICT (content)“* in `Intern/BEFUNDE.md`, `Intern/pruefstand-buch.tsv`, `Intern/pruefstand-dauer.txt`, `Intern/pruefstand-ergebnis.txt`, `tools/TESTLAEUFE.md`. Mit `origin/e203_e204_persona_kennwort` nur `tools/TESTLAEUFE.md`.
- In `BEFUNDE.md` ist es die Stufentabelle (`:159`, `:162`): hier 52 offen, auf `e194_…` 57 (LEKTOR-133 Nachtrag 1); zusammen zu erwarten 55 (Vermutung: 57 − [E-141](../Intern/BEFUNDE.md#e-141) − [E-179](../Intern/BEFUNDE.md#e-179)). Die Tabellen in CHANGELOG und WEITERMACHEN vereinigen sich ohne Konfliktmarke und müssen trotzdem neu erzeugt werden; `README.md:98` und `WEITERMACHEN.md:3` ebenso ([L-134.6](#l-134.6)).

**Vorschlag:** wer als Zweiter gemergt wird, holt `main` herein, erzeugt Stufentabelle und Listen mit `offene-befunde.pl -schreiben` neu und nimmt `pruefstand-ergebnis.txt`/`-dauer.txt` vom letzten echten Lauf statt einer Konfliktauflösung von Hand.

## Bestand außerhalb des Schwerpunkts

Seit `456c95e1` geänderte MDs außerhalb von `Arbeitsweise/` und `Befunde/` (`git log --stat 456c95e1..HEAD`): die von #207/#208 (geprüft in [LEKTOR-131](LEKTOR-131.md#lektor-131) und [LEKTOR-132](LEKTOR-132.md#lektor-132), auf `main` unverändert) und aus den eigenen Commits `CHANGELOG.md`, `README.md`, `Intern/AUFGABEN.md`, `Intern/BEFUNDE.md`, `Intern/WEITERMACHEN.md`, `tools/TESTLAEUFE.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md` — alle gelesen. `Intern/AUFGABEN.md:8` *„[E-141](../Intern/BEFUNDE.md#e-141) und [E-179](../Intern/BEFUNDE.md#e-179) am Prüfstand bestätigt (behoben in 7.2.1.131), [E-170](../Intern/BEFUNDE.md#e-170) bleibt offen …“* stimmt mit BEFUNDE. `tools/ZWEIGE.md:213` nennt Gregors Ja wörtlich und die vier Kennungen. Übrige Dateien nach Kennungen der vier Befunde durchsucht (`git ls-files '*.md'` ohne die beiden Verzeichnisse): außer den Funden oben nur `Intern/TESTBERICHT-E125.md:59` (Archiv, Stand 7.2.0.122) und `Releases/PRUEFBERICHT.md:410-421` (Testnamen) — kein Widerspruch. Die Stand-Köpfe von README (`:104`), CHANGELOG, TESTPLAN und WERKZEUGE nennen `v7.2.1.131` als zuletzt veröffentlicht; `VERSION` ist `7.2.1.131` — stimmt. `tools/WERKZEUGE.md`, Stand-Kopf, *„Seit 7.2.0.106 sind 26 Werkzeuge dazugekommen (… nachgezählt am 24.10.2026 …)“* — heute sind es 66 Skripte (`git log --diff-filter=A --name-only --format= fd890f3..HEAD -- tools/`, nach Endung `.pl/.ps1/.sh/.py` gezählt); der Satz ist datiert, liest sich aber als heutiger Stand. Die Zeile zu `messen-e184.ps1` (`:141`) erwähnt den neuen Schalter `-Label` nicht; die Zeile der Hüllen (`:153`) tut es — Kleinkram ohne Kennung.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): *„gepruefte Dateien 52“*, *„Kennungen im Verzeichnis 178“*, *„Kein Widerspruch gefunden.“*; *Zur Kenntnis* wie in LEKTOR-133 (u. a. `Doku/ANWENDER.md` und `Intern/PORTIERUNG.md` höchste Fassung 7.2.1.128, `Doku/FAQ.md` 7.2.1.130). [L-134.1](#l-134.1) bis [L-134.9](#l-134.9) sieht es nicht — es vergleicht Fassungsnummern, nicht Aussagen über Verhalten gegen Messungen.

`perl tools/offene-befunde.pl` (gemessen): *„52 offene Befunde, in beiden Listen gleich.“*, *„davon NIE gemessen 13“* — [E-176](../Intern/BEFUNDE.md#e-176) zu Recht darunter. Die alte Aufgabe bei [E-170](../Intern/BEFUNDE.md#e-170) erkennt es nicht ([L-134.2](#l-134.2)).

`perl tools/pruefe-regressionstest.pl` (gemessen): *„kritisch 69“*, *„mit Testfall im Pruefstand 62 von 69“*, *„OHNE jede Pruefung 5 <- Rueckstand: [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-133](../Intern/BEFUNDE.md#e-133)“*, *„Kein neues "behoben" ohne Regressionstest.“* — [E-170](../Intern/BEFUNDE.md#e-170) (*kritisch*, offen) zählt unter „mit Testfall“; seine beiden Fälle sehen den Fehler aber nicht: `E-170p` war am alten Bau nur wegen der Logzeile rot, `E-170o` verlangt nur den Grund im Protokoll. Das steht so in `pruefstand-faelle.txt` und ist ehrlich; das Werkzeug unterscheidet es nicht.

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Was nur Gregor entscheiden kann

1. **Release-Text von `v7.2.1.131` auf GitHub** ([L-134.1](#l-134.1), [L-134.5](#l-134.5)): er sagt, beim Verschieben im IMAP-Konto bleibe das Label jetzt erhalten, wenn der Server die neuen Nummern meldet ([E-170](../Intern/BEFUNDE.md#e-170)) — gemessen ist, dass das schon 7.2.1.128 tat und ohne diese Meldung weiter nicht geht. Dazu stehen dort [E-141](../Intern/BEFUNDE.md#e-141) und [E-179](../Intern/BEFUNDE.md#e-179) als „nicht gemessen“, beide sind jetzt bestätigt. Soll der veröffentlichte Text berichtigt werden, oder bleibt er, wie er zum Release war, und die Berichtigung steht nur in FAQ, README und CHANGELOG?
2. **Administratorrechte für die Messung von [E-176](../Intern/BEFUNDE.md#e-176)** (Lesen aus schon freigegebenem Speicher beim Schließen einer neuen Nachricht ohne Speichern): Page-Heap braucht einen Eintrag unter `HKLM`, den das Konto der Sitzung nicht schreiben darf. Soll es eine Sitzung mit Administratorrechten dafür geben (Eintrag nur für `C:\Temp\EM176\Eudora.exe`, danach entfernt), oder bleibt [E-176](../Intern/BEFUNDE.md#e-176) „am Quelltext und im Test gesichert, nicht messbar“?
3. **Sollen die Zweige auf GitHub gelöscht werden, die noch die Datei mit der persönlichen Angabe tragen** ([L-130.1](LEKTOR-130.md#l-130.1): eine Gedächtnisdatei mit einer Angabe, die nicht ins Repo soll)? `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d`; `main` und dieser Zweig sind frei davon. Unverändert seit [LEKTOR-131](LEKTOR-131.md#lektor-131).

## <a id="nachtrag-02-11-2026"></a>Nachtrag 02.11.2026 — eingearbeitet im Zweig `messungen_vor_7_2_2_132`

| Fund | Stand | Stelle |
|---|---|---|
| [L-134.1](#l-134.1) | **erledigt im Repo** | `Releases/7.2.1.131/RELEASE-NOTIZEN.md` mit „Nachtrag 02.11.2026“ markiert (veröffentlichter Text auf GitHub unverändert, Gregor entscheidet); `Doku/FAQ.md` „Bekannte Einschränkung“ auf den gemessenen Stand; `Intern/TESTPLAN.md` Abschnitt `e-170-naechstes` als „Bekannt offen — nicht als bestanden erwarten“ gekennzeichnet |
| [L-134.2](#l-134.2) | **erledigt mit Werkzeug** | `tools/offene-befunde.pl` sucht die Aufgabe nur vor „**Bis … stand hier**“ und nimmt „**Was fehlt:**“ wie „**Was noch fehlt:**“. Gegenprobe: mit dem alten Werkzeug zeigte [E-170](../Intern/BEFUNDE.md#e-170) *„die Messung am Programm mit dem Testpaket 7.2.1.130 …“*, mit dem neuen *„ein Weg für Server ohne UIDPLUS …“*; sonst änderte sich nur [E-176](../Intern/BEFUNDE.md#e-176) (neue Marke im aktuellen Urteil) |
| [L-134.3](#l-134.3) | **erledigt** | README und CHANGELOG: bestätigt für das Senden als reiner Text; Textteil neben dem HTML-Teil und Suche nicht gemessen |
| [L-134.4](#l-134.4) | **vermerkt als Beobachtung** | `Intern/BEFUNDE.md` [E-179](../Intern/BEFUNDE.md#e-179), keine eigene Kennung (Auftrag des Hauptagenten) |
| [L-134.5](#l-134.5) | **erledigt im Repo** | Release-Notizen wie bei [L-134.1](#l-134.1) |
| [L-134.6](#l-134.6) | **erledigt** | `Intern/WEITERMACHEN.md:3` nennt #208 gemergt und diesen Zweig laufend; README-Berichtszahl aus dem Verzeichnis gezählt |
| [L-134.7](#l-134.7) | **erledigt** | `pruefstand-ergebnis.txt` und `pruefstand-dauer.txt` auf den letzten echten Lauf (`-Nur E-179`, 18:01:00) zurück; Buchzeile `E-141g-alt` entfernt; Kommentar zu `E-170p` berichtigt. Dass `pruefstand-lauf.ps1` bei eigener Fallliste keine `nur=`-Zeile schreibt, ist nicht geändert |
| [L-134.8](#l-134.8) | **erledigt** | `tocdoc.cpp:3178`, `:3041`, `summary.cpp:562` |
| [L-134.9](#l-134.9) | **offen** | beim zweiten Merge zu erledigen |

## <a id="nachtrag-1-02-11-2026"></a>Nachtrag 1 (02.11.2026)

Gegengelesen: `git diff be422780..origin/messungen_vor_7_2_2_132` (Stand `f08258c7`, *„BEFUNDE: Pfade aus Gregors Benutzerverzeichnis neutral beschrieben“*, davor `a13be324`, *„[LEKTOR-134](#lektor-134) eingearbeitet ([L-134.1](#l-134.1) bis [L-134.8](#l-134.8))“*). Arbeitsbaum vorgespult mit `tools/arbeitsbaum-angleichen.sh`. Nichts gebaut, nichts gestartet. Die Tabelle *„Nachtrag 02.11.2026 — eingearbeitet …“* direkt über diesem Abschnitt hat der Hauptagent in diesen Bericht geschrieben; sie ist seine Selbstauskunft, das Urteil steht hier.

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-134.1](#l-134.1) E-170-Texte | **erledigt im Repo**, ein Rest ([L-134.12](#l-134.12)) | `Doku/FAQ.md:208-214` *„… ist das Label danach weg, wenn der Server die neuen Nummern der verschobenen Mail nicht meldet (UIDPLUS) … Meldet er sie, bleibt das Label; das war schon vor 7.2.1.130 so“*; `Intern/TESTPLAN.md:350` *„**Bekannt offen — nicht als bestanden erwarten (Stand 02.11.2026).** … Gregor muss den Abschnitt nicht ausführen.“*; `Releases/7.2.1.131/RELEASE-NOTIZEN.md` mit *„Nachtrag 02.11.2026“* an drei Stellen und dem Schlusssatz, dass der Text auf GitHub unverändert ist. Stimmt mit `BEFUNDE.md:419` |
| [L-134.2](#l-134.2) Marke „Was fehlt“ | **erledigt mit Werkzeug** | `tools/offene-befunde.pl:295-305` sucht nur vor `**Bis … stand hier:**` und nimmt beide Schreibweisen. Gegenprobe selbst gefahren: über alle Urteilszeilen von `BEFUNDE.md` die gezählt, die eine Bis-Marke und eine Fehlt-Marke haben, aber keine Fehlt-Marke vor der Bis-Marke — nur [E-141](../Intern/BEFUNDE.md#e-141) und [E-179](../Intern/BEFUNDE.md#e-179), beide geschlossen; *„nicht aufgeschrieben“* in `WEITERMACHEN.md` vorher 0, nachher 0; `offene-befunde.pl` *„52 offene Befunde, in beiden Listen gleich.“* In den Listen änderten sich nur [E-170](../Intern/BEFUNDE.md#e-170) (*„ein Weg für Server ohne UIDPLUS …“*) und [E-176](../Intern/BEFUNDE.md#e-176) — dazu [L-134.11](#l-134.11). Die vorgeschlagene Warnung bei doppelter Marke gibt es nicht; mit der neuen Regel ist sie entbehrlich |
| [L-134.3](#l-134.3) [E-179](../Intern/BEFUNDE.md#e-179) Reichweite | **erledigt** | `README.md:192` *„… beim Senden als reiner Text bestätigt; der Textteil neben dem HTML-Teil (Vorgabe) und die Suche rufen dieselbe Umwandlung, gemessen sind sie nicht“*; `CHANGELOG.md:123` *„bestätigt für das Senden als reiner Text: … (Weg *plain only*; der Textteil neben dem HTML-Teil und die Suche sind nicht gemessen)“*; Release-Notizen gleich |
| [L-134.4](#l-134.4) Nebenfund Zeichensatz | **erledigt als Beobachtung ohne Kennung** | `BEFUNDE.md:412` *„**Beobachtung (02.11.2026, keine eigene Kennung):** … Die Zeichensatzwahl beim Senden (`sendmail.cpp`, `IDS_MIME_ISO_LATIN1`) ist in keinem Befund geführt“* — steht damit weiter in keiner Liste, weil [E-179](../Intern/BEFUNDE.md#e-179) geschlossen ist; so gewollt (Hauptagent) |
| [L-134.5](#l-134.5) Release-Notizen [E-141](../Intern/BEFUNDE.md#e-141)/[E-179](../Intern/BEFUNDE.md#e-179) | **erledigt im Repo** | wie [L-134.1](#l-134.1); der Satz im CHANGELOG-Abschnitt 7.2.1.131 fehlt, aber `RELEASE-NOTIZEN.md:19` nennt die *„nicht veröffentlichten Testpakete 7.2.1.129 und 7.2.1.130“* schon — genügt |
| [L-134.6](#l-134.6) Stand-Kopf, Berichtszahl | **erledigt** | `WEITERMACHEN.md:3` *„Gemergt als #208: … Laufend: Zweig `messungen_vor_7_2_2_132` …“*; `README.md:98` *„(215 LEKTOR- und PRÜFER-Berichte …)“* bei 215 (`git ls-files Befunde`). Die Schranke aus [L-128.2](LEKTOR-128.md#l-128.2) fehlt weiter |
| [L-134.7](#l-134.7) Spuren der Gegenprobe | **erledigt bis auf das Werkzeug** | `pruefstand-ergebnis.txt` *„nur=[E-179](../Intern/BEFUNDE.md#e-179)   (Teillauf, nicht der Gesamtstand)“*, `zeit=2026-11-02 18:01:00`; Buchzeile `E-141g-alt` entfernt; Kommentar in `pruefstand-faelle.txt` *„Der Fall ist am alten Bau rot nur wegen log-grund“*. `pruefstand-lauf.ps1` unverändert, wie der Hauptagent selbst sagt |
| [L-134.8](#l-134.8) Zeilenangaben | **erledigt** | `BEFUNDE.md:394` *„`tocdoc.cpp:3041` (Stand 02.11.2026; bei der Niederschrift `:3001`)“*, *„`tocdoc.cpp:3178`“*; `:415` *„`summary.cpp:562`“* — treffen den Quelltext |
| [L-134.9](#l-134.9) Konflikte mit `e194_…` | **offen** | erst beim zweiten Merge |

**Pfade ersetzt (`f08258c7`), auf Sinn und Zitate geprüft** (gemessen, Wortdiff über alle 16 geänderten Zeilen): ersetzt sind 23 Pfade unter Gregors Benutzerverzeichnis durch `<Gregors Testverzeichnis des Pakets 1.0.N>` bzw. `<Gregors Temp-Verzeichnis>`, dazu in [E-128](../Intern/BEFUNDE.md#e-128) ein Dateiname, der der Betreff einer Mail war, durch *„eine Datei `.txt` in seinem Mailverzeichnis des Pakets 1.0.120“*. Paketnummer, Dateiname am Ende (`Eudora.exe`, `eudora.log`, `rootcerts.p7b`, `mfc140d.dll`) und der Satz drumherum bleiben jeweils stehen; die Aussage jedes Satzes trägt weiter. Bei [E-128](../Intern/BEFUNDE.md#e-128) geht es um die Endung, nicht um den Namen — der Betreff fehlt der Aussage nicht. In Zitaten aus Protokoll und Eingabeaufforderung (`rootcerts.p7b geladen aus: <…>\rootcerts.p7b (vorhanden)`, `BEFUNDE.md:6846` `<…1.0.4>>Eudora.exe Mailverzeichnis`) steht jetzt ein Platzhalter mitten im Zitat; die spitzen Klammern zeigen das, verfälscht ist nichts. Zwei Reste: [L-134.10](#l-134.10).

### <a id="l-134.10"></a>L-134.10 — Beim Ersetzen der Pfade ist ein Bereich halb stehengeblieben; ein Pfad in Gregors Benutzerverzeichnis steht noch

**Gewicht: Kleinkram.** (gemessen)

- `BEFUNDE.md:430` *„jedes Paket in `<Gregors Testverzeichnis des Pakets 1.0.110>` bis `-1.0.122-release` liefert 121 Wurzeln aus“* — vorher ergab der zweite Teil nur zusammen mit dem vollen Pfad davor einen Namen; jetzt hängt er in der Luft.
- `BEFUNDE.md:2354-2356` (eingerückte Ausgabe zu `tools/lehren-spiegeln.pl`) nennt den Pfad des Repos unter Gregors Benutzerverzeichnis und den daraus abgeleiteten Verzeichnisnamen; `grep -c 'Users.Gregor' Intern/BEFUNDE.md` → 1. Dort ist der Pfad Gegenstand der Messung (die Ableitung des Verzeichnisnamens); ein Platzhalter müsste die Ableitung mitnehmen.

**Vorschlag:** *„jedes Paket von 1.0.110 bis 1.0.122 in Gregors Testverzeichnissen liefert …“*; für `:2354-2356` Platzhalter für Wurzel und abgeleiteten Namen mit dem Satz, dass Doppelpunkt, Schrägstrich und Punkt zu `-` werden — oder bewusst stehen lassen und das vermerken.

### <a id="l-134.11"></a>L-134.11 — Die Liste zu E-176 hat die zweite offene Aufgabe verloren

**Gewicht: Kleinkram.** (gemessen)

- `CHANGELOG.md:44` und `WEITERMACHEN.md`, Zeile [E-176](../Intern/BEFUNDE.md#e-176), jetzt *„die Messung unter Page-Heap. **Was es zum Messen braucht:** …“*; vorher *„ein Test, der `CSummary` und `CMessageFrame` echt anlegt (`TestE176.cpp` liest bisher nur den Quelltext), und die Messung am Programm …“*.
- Der echte Test ist nicht geschrieben; er steht nur noch im Teil hinter *„Bis 02.11.2026 stand hier“* (`BEFUNDE.md:415` *„echt anlegt (`TestE176.cpp` liest bisher nur den Quelltext)“*), den das Werkzeug seit [L-134.2](#l-134.2) absichtlich nicht mehr liest. Die neue Marke im aktuellen Teil nennt nur die Messung.

**Vorschlag:** im aktuellen Teil *„**Was noch fehlt:** die Messung unter Page-Heap, und ein Test, der `CSummary` und `CMessageFrame` echt anlegt (`TestE176.cpp` liest nur den Quelltext).“*, dann `offene-befunde.pl -schreiben`. Bei jedem fortgeschriebenen Urteil prüfen: übernimmt die neue Marke alles Offene der alten?

### <a id="l-134.12"></a>L-134.12 — Die FAQ verspricht die Logzeile zu E-170 ohne die Bedingung, unter der sie geschrieben wird

**Gewicht: Kleinkram.** (gemessen an den Texten)

- `Doku/FAQ.md:213-214` *„Ab 7.2.1.131 steht in der `eudora.log`, warum es fehlt“*. `BEFUNDE.md:419` und `TESTPLAN.md` (Schritt 4 im Abschnitt `e-170-naechstes`): die Zeile kommt nur mit dem Protokollbereich *Misc* (0x8000), *„in der Vorgabe 25759 aus“*. Ein Anwender mit der Vorgabe findet sie nicht.
- *„Ab 7.2.1.131“*: eingebaut seit 7.2.1.130 (`CHANGELOG.md:64`); für Anwender ist 7.2.1.131 das erste Release damit — vertretbar.

**Vorschlag:** *„… steht in der `eudora.log` eine Zeile mit dem Grund, wenn der Protokollbereich *Misc* eingeschaltet ist (`LogLevel` mit 0x8000; in der Vorgabe aus)“*.

Werkzeuge nach dem Angleichen: `perl tools/doku-pruefen.pl` *„Kein Widerspruch gefunden.“*; `perl tools/offene-befunde.pl` *„52 offene Befunde, in beiden Listen gleich.“* Offen damit: [L-134.9](#l-134.9) bis [L-134.12](#l-134.12).
