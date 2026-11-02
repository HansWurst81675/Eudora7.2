# <a id="lektor-126"></a>LEKTOR-126 — Bestand nach E-122 (Eingangsdatum beim Hochladen nach IMAP), Zweig e122_imap_datum nach 3c1f5948 (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-125](LEKTOR-125.md#lektor-125).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102e`, abgezweigt von `origin/e122_imap_datum`, Stand `3c1f5948`.
Umfang: alle 64 `.md` aus `git ls-files '*.md'` ohne `Arbeitsweise/` und `Befunde/` gegen den Bestand. Geändert seit `90807904` (Merge von #201) sind davon `CHANGELOG.md`, `Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`, `Testdaten/README.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md`; im Code `ImapAppend.cpp`, `ImapAppend.h`, `TestE122.cpp`, `TestMain.cpp`, `Tests.vcxproj`; neu `tools/messen-e122.ps1` und zwei Prüfnachrichten (`git diff --stat 90807904 HEAD`, 17 Dateien, gemessen). Schwerpunkte nach Auftrag: [E-122](../Intern/BEFUNDE.md#e-122) (das Eingangsdatum einer in einen IMAP-Ordner hochgeladenen Nachricht ist um die Zeitzone verschoben) in BEFUNDE, TESTPLAN, WERKZEUGE, `pruefstand-faelle.txt`, README und CHANGELOG; die Konfliktauflösungen des Merges `fda44d5e` in `WERKZEUGE.md`, `pruefstand-faelle.txt` und `TESTLAEUFE.md`.

## Kurz

Die Messung ist in der Sache sauber: Am Bau mit der Behebung stimmt das Datum der `APPEND`-Zeile für beide Absenderzonen, am Bau ohne sie liegt es je 60 Minuten zu früh, genau die Ortszone der VM. Der Merge hat in den drei Konfliktdateien nichts verloren und nichts verdoppelt (gemessen). Zwei Dinge stehen aber schief. Der neue Testschritt für Gregor prüft im Webmailer das angezeigte Datum, und das ist nach dem eigenen Text des Abschnitts der `Date:`-Kopf, der nie falsch war. Der Schritt kann damit vermutlich nicht rot werden ([L-126.1](#l-126.1)). Und die Stand-Köpfe melden `e143_suchfenster` zum dritten Mal in Folge mit „PR folgt“, obwohl #201 gemergt ist ([L-126.2](#l-126.2)); im CHANGELOG fehlt [E-122](../Intern/BEFUNDE.md#e-122) ganz ([L-126.3](#l-126.3)). Daten von Gregors Rechner: keine, weder im Zuwachs noch in den Commit-Nachrichten (gemessen). Sechs Funde, keiner am Programm. Nach Auftrag ist nichts berichtigt.

## Funde aus LEKTOR-125

Nach dem [Nachtrag](LEKTOR-125.md#nachtrag-02-11-2026) standen neun Funde auf erledigt und zwei auf teilweise. Heute (gemessen):

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-125.1](LEKTOR-125.md#l-125.1) [E-178](../Intern/BEFUNDE.md#e-178) „Gregors Test“ | erledigt | `Intern/TESTPLAN.md:241` *„**Für Gregor entfällt dieser Test vorerst — er misst sich am Prüfstand.**“*; `Intern/WEITERMACHEN.md:3` *„**für Gregor entfällt der E-178-Test vorerst**“* |
| [L-125.2](LEKTOR-125.md#l-125.2) TESTPLAN „Was der Prüfstand tut“ | erledigt | unverändert seit dem Nachtrag (`git diff cb99c5f4 HEAD -- Intern/TESTPLAN.md` berührt nur den neuen E-122-Abschnitt) |
| [L-125.3](LEKTOR-125.md#l-125.3) [E-136](../Intern/BEFUNDE.md#e-136) „nie gemessen“ | erledigt | `Intern/BEFUNDE.md:435` *„Zuletzt gemessen: 02.11.2026 an 7.2.1.130“* |
| [L-125.4](LEKTOR-125.md#l-125.4) E-136-Gegenprobe | erledigt | `Intern/BEFUNDE.md:435` *„gibt es nicht“* |
| [L-125.5](LEKTOR-125.md#l-125.5) Stand-Köpfe | erledigt, **wieder veraltet** | `Intern/WEITERMACHEN.md:3` *„Zweig `e143_suchfenster`, PR folgt“*; #201 ist gemergt. Siehe [L-126.2](#l-126.2) |
| [L-125.6](LEKTOR-125.md#l-125.6) CHANGELOG | erledigt, **wieder veraltet** | `CHANGELOG.md:116` *„**Zweig `e143_suchfenster`** (nach dem Merge von #200; PR folgt)“*. Siehe [L-126.3](#l-126.3) |
| [L-125.7](LEKTOR-125.md#l-125.7) README | **teilweise, Rest offen** | `README.md:98` *„(204 LEKTOR- und PRÜFER-Berichte)“*; gezählt an `3c1f5948` 205 (`ls Befunde/LEKTOR-[0-9]*.md Befunde/PRUEFER-[0-9]*.md`), mit diesem Bericht 206 |
| [L-125.8](LEKTOR-125.md#l-125.8) `messen-e143s`, Gegenprobe-Bau | erledigt | `tools/WERKZEUGE.md:151`, `tools/pruefstand-faelle.txt` Kommentar zu `E-143s` *„Gelaufen am 02.11.2026“* |
| [L-125.9](LEKTOR-125.md#l-125.9) doppelte Zeilen in WERKZEUGE | erledigt | `grep -o '^| \`tools/[^\`]*\`' tools/WERKZEUGE.md \| sort \| uniq -d` leer, auch nach dem Merge (der Zweig `e122_imap_datum` trug die vier Doppel noch, `509e7caf`; der Merge hat die bereinigte Fassung aus `main` übernommen) |
| [L-125.10](LEKTOR-125.md#l-125.10) Link auf [E-179](../Intern/BEFUNDE.md#e-179) | erledigt | `grep -c '](BEFUNDE.md' CHANGELOG.md` → 0 |
| [L-125.11](LEKTOR-125.md#l-125.11) Betreff-Fragezeichen | **teilweise, Rest offen** | `Intern/BEFUNDE.md:353` ([E-90](../Intern/BEFUNDE.md#e-90), Emoji im Betreff fallen beim Empfang weg) sagt weiter *„**Am laufenden Programm ist das seit 7.2.0.59 nie nachgemessen worden.**“*; Gregors Betreff `tesmail  ?).` steht nur bei [E-178](../Intern/BEFUNDE.md#e-178) (`:410`) |

## Funde

### <a id="l-126.1"></a>L-126.1 — TESTPLAN E-122: der Schritt im Webmailer prüft vermutlich das Datum, das nie falsch war

**Gewicht: mittel.** Ein Test, der nicht rot werden kann, meldet Gregor ein Bestanden, das nichts sagt ([Prüfstand kann blind sein](../Arbeitsweise/pruefstand-kann-blind-sein.md), [Erst nachstellen, dann ausliefern](../Arbeitsweise/erst-nachstellen-dann-ausliefern.md)). (Text gemessen; was der Webmailer anzeigt: Vermutung)

- `Intern/TESTPLAN.md:349-351` *„Der `Date:`-Kopf der Mail selbst blieb richtig; falsch war nur das Datum, nach dem der Server und andere Programme „nach Eingang“ sortieren.“* Das ist das `INTERNALDATE` des Servers. So steht es auch in `Intern/BEFUNDE.md:384` *„der `Date:`-Kopf selbst bleibt richtig“*.
- `:356-360` *„3. Den Ordner im **Webmailer** öffnen und die Mail ansehen: das angezeigte Datum stimmt mit der Uhrzeit aus Schritt 1 überein. **Nicht bestanden:** die Uhrzeit liegt eine Stunde (Sommerzeit: zwei Stunden) früher.“* Ein Webmailer zeigt in der geöffneten Mail üblicherweise das Datum aus dem `Date:`-Kopf (Vermutung, an Gregors Webmailer nicht gesehen). Dann stimmt die Uhrzeit mit jedem Bau, auch mit 7.2.1.130.
- `:364-365` *„Am Prüfstand am 02.11.2026 so gefahren (Fall `E-122p`, IMAP-Prüfserver)“*. Der Prüfstand fährt nicht „so“: Er vergleicht das Datum in der `APPEND`-Zeile des Serverprotokolls mit dem `Date:`-Kopf (`tools/messen-e122.ps1:258` *„`'<- \S+ APPEND '`“*, `:270-273`). Eine Anzeige liest er nicht. Gemessen ist also das richtige Datum, nur nicht auf dem Weg, den der Schritt Gregor gibt.
- Nebenbei, Schritt 1 (`:352-353`, *„deren Uhrzeit du kennst (Spalte *Date*)“*): Ob Eudoras Spalte die Absenderzeit oder die Ortszeit zeigt, sagt der Schritt nicht. Bei einer Mail aus einer anderen Zeitzone weichen Spalte und Webmailer dann auch ohne Fehler voneinander ab (Vermutung, nicht nachgesehen).

Der Fehler ist an 7.2.1.130 noch drin (`:345-346` *„dort ist die Behebung nicht drin“*). Damit lässt sich die Tauglichkeit des Schritts schon heute prüfen, ohne neues Paket.

**Vorschlag:** Den Schritt auf etwas setzen, das das Eingangsdatum zeigt: die Sortierung „nach Eingang“ oder eine Spalte „Empfangen“ im Webmailer, wenn es sie gibt. Oder erst einmal die Schritte 1–3 an 7.2.1.130 fahren lassen: Zeigt der Webmailer dort die Stunde Versatz, ist der Schritt tauglich; zeigt er sie nicht, misst er nichts. Den Satz „so gefahren“ auf „gemessen am Serverprotokoll“ berichtigen. Form und Reihenfolge legt der Hauptagent fest.

### <a id="l-126.2"></a>L-126.2 — Stand-Köpfe: „PR folgt“ nach dem Merge von #201, `e122_imap_datum` „in Arbeit“ — zum dritten Mal in Folge

**Gewicht: mittel.** Den Kopf von WEITERMACHEN liest `sitzungsbeginn.pl` jeden Morgen. Dasselbe Muster stand in [L-124.2](LEKTOR-124.md#l-124.2) und [L-125.5](LEKTOR-125.md#l-125.5). Nach [Fehlerklassen abstellen](../Arbeitsweise/fehlerklassen-abstellen.md) ist beim zweiten Auftreten eine Schranke fällig. Ein Werkzeug, das „PR folgt“ oder „PR offen“ gegen die gemergten Zweige hält, gibt es nicht (`grep -n 'PR folgt\|PR offen' tools/*.pl`: kein Treffer). (gemessen)

- `Intern/WEITERMACHEN.md:3` *„Zweig `e143_suchfenster`, PR folgt“* und *„Zweig `e122_imap_datum` in Arbeit: [E-122](../Intern/BEFUNDE.md#e-122) behoben und am IMAP-Prüfserver gemessen.“* #201 ist gemergt (`90807904` *„Merge pull request #201 from HansWurst81675/e143_suchfenster“*). Für `e122_imap_datum` sind Behebung, Messung, Testplan und der Merge von `main` getan (`f950fd66`, `509e7caf`, `fda44d5e`, `3c1f5948`); „in Arbeit“ sagt nicht, ob der PR folgt.
- `Intern/AUFGABEN.md:8` *„Zweig `e143_suchfenster`, PR folgt“*, ebenso.
- `tools/ZWEIGE.md:207` (`e143_suchfenster`) endet auf *„PR folgt.“* `:204` (`e122_imap_datum`) hat nur den Zweck, keinen Stand. Die Zeile zu `e177_filter_programm` (`:205`) hat einen.

**Vorschlag:** Die drei Köpfe auf „#201 gemergt; Zweig `e122_imap_datum`: behoben, am Prüfstand gemessen, Testplan steht, PR folgt“ setzen, in ZWEIGE einen Stand. Und eine Schranke: Ein Zweigname, der im Kopf mit „PR folgt“ oder „PR offen“ steht, darf nicht unter `git log --merges --grep 'Merge pull request'` auf `origin/main` vorkommen.

### <a id="l-126.3"></a>L-126.3 — CHANGELOG „Im Quellstand, noch in keinem Paket“: E-122 fehlt, `e143_suchfenster` „PR folgt“

**Gewicht: mittel.** Aus diesem Abschnitt entsteht die Paketnotiz. Wie [L-125.6](LEKTOR-125.md#l-125.6). (gemessen)

- `grep -n 'E-122' CHANGELOG.md` trifft nur die erzeugte Zeile `:61`. Im Abschnitt ab `:114` steht die Behebung nicht.
- `CHANGELOG.md:116` *„**Zweig `e143_suchfenster`** (nach dem Merge von #200; PR folgt).“* Gemergt ist er als #201.

**Vorschlag:** Einen Absatz *Zweig `e122_imap_datum`* über den bestehenden: das Eingangsdatum beim Übertragen aus einem lokalen Postfach in einen IMAP-Ordner stimmt wieder; Prüfstandsfall `E-122p` vorher je 60 Minuten zu früh, nachher gleich; Regressionstest `Test_E122_Stelle`; Werkzeug `tools/messen-e122.ps1`; nicht geändert `AppendMessageAcrossRemotes`. Den bestehenden Absatz auf „gemergt als #201“ setzen.

### <a id="l-126.4"></a>L-126.4 — README „Bekannte Fehler“: E-122 ohne „im Quellstand behoben“; 204 statt 206 Berichte

**Gewicht: Kleinkram.** Die Tabelle gilt für `v7.2.1.128`, dort ist der Fehler drin. (gemessen)

- `README.md:179` *„| In einen IMAP-Ordner hochgeladene Nachrichten tragen ein um die Zeitzone verschobenes Eingangsdatum (Sortierung) | nichts | – |“*. Die Zeilen zu [E-143](../Intern/BEFUNDE.md#e-143) (`:187` *„Für das Suchfenster im Quellstand geändert, kommt mit dem nächsten Paket“*) und [E-177](../Intern/BEFUNDE.md#e-177) (`:196` *„im Quellstand behoben, kommt mit dem nä…“*) sagen es, die zu [E-122](../Intern/BEFUNDE.md#e-122) nicht.
- `README.md:98` *„204“*, siehe [L-125.7](LEKTOR-125.md#l-125.7) oben; mit diesem Bericht 206.

### <a id="l-126.5"></a>L-126.5 — Der gewertete Lauf `E-122p` hat keine Titelzeile — neun von 22 Starts am 02.11.

**Gewicht: Kleinkram, aber zum dritten Mal.** [Version eindeutig machen](../Arbeitsweise/version-eindeutig-machen.md): Maßstab für den Bau ist die Titelzeile. (gemessen)

- `tools/TESTLAEUFE.md:735` *„| 2026-11-02 11:41:57 | `C:\Temp\E122` | … | Hauptfenster 2295382 - Eudora  Schliesszeit 1 s. |“*, ohne `[Eudora …]`. Das ist der Lauf, den `Intern/pruefstand-buch.tsv:24` als `E-122p ok 2026-11-02 11:42:00` führt. Den Bau nennt nur das Buch (*„Eudora 7.2.1.130+6c95e284\* 2026-11-02 11:18“*). Die beiden Läufe davor (`:733`, `:734`) haben ihre Titelzeile.
- Am 02.11. fehlt sie bei neun von 22 Starts (`grep '^| 2026-11-02' tools/TESTLAEUFE.md`, davon ohne `[Eudora`: `:715`, `:719`, `:721`, `:722`, `:724`, `:728`, `:730`, `:732`, `:735`). Gemeldet war es schon für `E-178p` ([LEKTOR-125](LEKTOR-125.md#lektor-125), Zur Kenntnis) und `E-143s` (Nachtrag dort, „Neu“).

**Vorschlag:** Ursache in `tools/testlauf.ps1` suchen (Vermutung: das Fenster hat beim Lesen noch keinen Titel) und den Bau dort festhalten, wo er sicher steht. Wenn das Buch der Maßstab sein soll, das in `version-eindeutig-machen` sagen. Der Hauptagent entscheidet.

### <a id="l-126.6"></a>L-126.6 — E-122: die Zeilennummer im Aufrufer ist um eins verrutscht

**Gewicht: Kleinkram.** (gemessen)

`Intern/BEFUNDE.md:384` *„`ImapMailbox.cpp:4281` gab ihn an `append_date`“*. Die Zeile steht heute in `Eudora71/EuImap/src/ImapMailbox.cpp:4282` (*„`Append.m_Seconds = pSum->m_Seconds ;/*+ 60*pSum->m_TimeZoneMinutes;*/`“*), in `CImapMailbox::AppendMessageFromLocal` (`:4099`). Die zweite Zuweisung, in `AppendMessageAcrossRemotes` (`:4315`), steht in `:4431`; der Eintrag nennt die Funktion, aber keine Zeile. `services.cpp:2265` stimmt (`Eudora71/QCUtils/src/services.cpp:2265` *„`time_t seconds = mktime(&time);`“*).

## Zur Kenntnis

- **Konfliktauflösungen in `fda44d5e`** (gemessen, je Datei: Zeilen eines Elternteils, die im Merge fehlen, und doppelte Zeilen im Merge):
  - `tools/WERKZEUGE.md`: Es fehlen nur die beiden alten Kopfzeilen (vereinigt zu *„neu `messen-e177`, `messen-e122`, `messen-e143s` und `messen-e178`“*, `:3`), die vier Doppel aus [L-125.9](LEKTOR-125.md#l-125.9), die `main` schon bereinigt hatte, und die alte Fassung der `messen-e136`-Zeile. Nichts doppelt.
  - `tools/pruefstand-faelle.txt`: Aus beiden Eltern fehlt nichts. `E-122p` (`:332`), `E-143s` und `E-178p` stehen je einmal. Doppelt sind nur Trennlinien aus `#` und `-`.
  - `tools/TESTLAEUFE.md`: Aus beiden Eltern fehlt nichts, nichts doppelt, Zeiten in Folge (`:733-736`). Die E-122-Zeilen standen schon auf `main` (`f950fd66` übernahm umgekehrt die Zeilen aus `e143_suchfenster`).
  - `Intern/pruefstand-ergebnis.txt` (kein `.md`, zur Kenntnis): Der Merge behielt den späteren Teillauf `E-143s` (11:53:09) und verwarf den Teillauf `E-122p` (11:42:00). Das ist die Regel der Datei (letzter Lauf). `E-122p` steht im Buch (`Intern/pruefstand-buch.tsv:24`).
- **Tests nach dem Merge:** Beide Zweige gingen von `6c95e284` aus und meldeten je *„361/361“* (`f950fd66`, `CHANGELOG.md:116`). Nach dem Merge sind es 362 erwartet (Vermutung). `TestMain.cpp` ruft beide auf (4 Treffer für `RunE122Tests`/`RunE143`, gemessen). Die Nachricht von `fda44d5e` nennt keinen Testlauf. Ein Lauf am Merge-Stand ist in keiner Nachricht belegt.
- **[E-122](../Intern/BEFUNDE.md#e-122) am Quelltext** (`git show f950fd66`, belegt): `E122DatumAusKopf` wird an beiden Stellen aufgerufen, an denen `ReformatHeader` den `Date:`-Kopf erkennt; `TestE122.cpp` prüft genau das (*„`QT_Zaehle(pFn, "E122DatumAusKopf( t, (int) len );") == 2`“*). Die Logzeile geht über `DEBUG_MASK_MISC`. Den hat Gregor nach `Intern/TESTPLAN.md` an ([LEKTOR-125](LEKTOR-125.md#lektor-125), Zur Kenntnis), Schritt 4 ist also ausführbar. Ob der Rückweg `localtime` → `_mkgmtime` in der Umstellungsstunde der Sommerzeit stimmt, ist nicht gemessen (die VM läuft ohne Sommerzeit, `Testdaten/README.md:40`). Das gehört zum PRÜFER, der laut `rollen-faellig.pl` für `ImapAppend.cpp` fällig ist.
- **`messen-e122.ps1`** paart die i-te `APPEND`-Zeile mit der i-ten Ablagedatei nach Namen (`:259-266`). Eine falsche Paarung ergäbe eine Abweichung von Stunden, also rot, nicht grün. Blind ist das nicht (belegt am Skript).
- **Daten von Gregors Rechner:** In den Nachrichten von `90807904..HEAD` (und `509e7caf`, `f950fd66`) steht nichts zu `Users`, `vmware` oder `Shared Folders`; im Zuwachs des Diffs ebenso nichts (gemessen). Die Prüfnachrichten adressieren nur `.invalid`.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): *„Kein Widerspruch gefunden.“* „Zur Kenntnis“: dieselben 18 Dateien ohne 7.2.1.130 wie in [LEKTOR-125](LEKTOR-125.md#werkzeuge). Die Funde [L-126.1](#l-126.1) bis [L-126.3](#l-126.3) sieht das Werkzeug nicht.

`perl tools/offene-befunde.pl` (gemessen):

```
    offen laut Intern/BEFUNDE.md  52
      davon aktuell gemessen      10  (ab Nummer 125)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     26
      davon NIE gemessen          16
    in Intern/WEITERMACHEN.md     52

  52 offene Befunde, in beiden Listen gleich.
```

`perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“* Kritisch ohne jede Prüfung jetzt 6 (*„[E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-133](../Intern/BEFUNDE.md#e-133) [E-39](../Intern/BEFUNDE.md#e-39)“*); [E-122](../Intern/BEFUNDE.md#e-122) ist mit dem Fall `E-122p` aus dieser Liste gefallen (in [LEKTOR-125](LEKTOR-125.md#werkzeuge) waren es 7).

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

`perl tools/rollen-faellig.pl` (gemessen): fällig LEKTOR (dieser Lauf), **PRÜFER** (*„Eudora71/EuImap/src/ImapAppend.cpp, Eudora71/EuImap/src/ImapAppend.h, Eudora71/Tests/TestE122.cpp und 1 weitere“*: die Behebung von [E-122](../Intern/BEFUNDE.md#e-122) ist von keinem PRÜFER gegengelesen) und CHRONIST.

## Was nur Gregor entscheiden kann

Nichts. Alle Funde betreffen Buchführung, Testform und Reihenfolge; das hat Gregor dem Hauptagenten übertragen. Auch ob Gregor die Schritte 1–3 aus [L-126.1](#l-126.1) zur Probe schon an 7.2.1.130 fährt, ist eine Frage der Testreihenfolge.
