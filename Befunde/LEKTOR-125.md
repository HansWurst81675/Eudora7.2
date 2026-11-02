# <a id="lektor-125"></a>LEKTOR-125 — Bestand nach E-143 Suchfenster und E-178-Messung, Zweig e143_suchfenster nach 214a0879 (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-124](LEKTOR-124.md#lektor-124).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102d`, abgezweigt von `origin/e143_suchfenster`, Stand `214a0879`.
Umfang: alle 64 `.md` aus `git ls-files '*.md'` ohne `Arbeitsweise/` und `Befunde/` gegen den Bestand. Geändert seit `6c95e284` (Merge von #200) sind davon `Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`, `CHANGELOG.md`, `Testdaten/README.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md`, `tools/TESTLAEUFE.md`; im Code `SearchView.cpp` und `TestE143.cpp`; neu `tools/messen-e143s.ps1`, `tools/messen-e178.ps1` (`git diff --stat 6c95e284 HEAD`, sechs Commits, gemessen). Schwerpunkte nach Auftrag: [E-143](../Intern/BEFUNDE.md#e-143) (Out-Hinweis je Nachricht aus Suchfenster und Filtern), Teil Suchfenster; die Messung von [E-178](../Intern/BEFUNDE.md#e-178) (Formatierbefehle im Bearbeiten-Modus machen Emoji zu `??`) und ihre neue Überschrift; [E-136](../Intern/BEFUNDE.md#e-136) (Strg-S zerstört Emoji beim Speichern), erstmals am Programm gemessen; der TESTPLAN mit „entfällt für Gregor“ bei [E-178](../Intern/BEFUNDE.md#e-178) und den Schritten 6–8 bei [E-143](../Intern/BEFUNDE.md#e-143); Doppelungen in `WERKZEUGE.md` und `pruefstand-faelle.txt`.

## Kurz

Die beiden Messungen sind in der Sache sauber: Das Suchfenster zeigt am neuen Bau **einen** Hinweis bei drei Treffern, am alten Bau drei. [E-178](../Intern/BEFUNDE.md#e-178) ist am neuen Bau überall `passt`, am alten kaputt bei Link, Festbreite und Antwort, und Fett und Kursiv waren nie betroffen. Um die Messungen herum stehen die Texte aber auf drei Ständen. Bei [E-178](../Intern/BEFUNDE.md#e-178) sagt der TESTPLAN „für Gregor entfällt dieser Test“. Befund, Listen und der Kopf von WEITERMACHEN verlangen weiter „Gregors Test“ ([L-125.1](#l-125.1)). Der Abschnitt „Was der Prüfstand tut“ ist nur halb umgeschrieben ([L-125.2](#l-125.2)). [E-136](../Intern/BEFUNDE.md#e-136) meldet im Urteil „erstmals gemessen“, steht in den Listen aber weiter als „veraltet, 22.10.“ und mit „noch kein Messweg“ ([L-125.3](#l-125.3)). Seine Gegenprobe beweist für [E-136](../Intern/BEFUNDE.md#e-136) nichts ([L-125.4](#l-125.4)). Im CHANGELOG fehlt unter „Im Quellstand, noch in keinem Paket“ alles aus #200 und diesem Zweig ([L-125.6](#l-125.6)). Daten von Gregors Rechner: keine, weder im Zuwachs noch in den sechs Commit-Nachrichten (gemessen). Elf Funde, keiner am Programm. Nach Auftrag ist nichts berichtigt.

## Funde aus LEKTOR-124

Alle zehn Funde standen nach [Nachtrag 2](LEKTOR-124.md#nachtrag-02-11-2026) auf erledigt oder vermerkt. Heute (gemessen):

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-124.1](LEKTOR-124.md#l-124.1) Berichtigung zu [L-123.4](LEKTOR-123.md#l-123.4) | erledigt | `Intern/LEKTORAT.md:3029` *„**Berichtigt in [LEKTOR-124 L-124.1](../Befunde/LEKTOR-124.md#l-124.1):** gemergt wurde normal“* |
| [L-124.2](LEKTOR-124.md#l-124.2) Stand-Köpfe | erledigt, **wieder veraltet** | `Intern/WEITERMACHEN.md:3` ist seit `6c95e284` unverändert. Er nennt `e177_filter_programm` *„PR offen“* und als Reihenfolge zwei Schritte, die beide überholt sind. Siehe [L-125.5](#l-125.5) |
| [L-124.3](LEKTOR-124.md#l-124.3) [E-177](../Intern/BEFUNDE.md#e-177) im Fehlerstand | erledigt | `Intern/BEFUNDE.md:410` *„Bis 7.2.1.130 stand darin …“*, *„erwartete bis zur Behebung den Fehlerstand `falsche-angabe=1`; seither urteilt er je Weg“*; `:430` *„die Angabe fehlte nicht, sie war falsch“*; `tools/pruefstand-faelle.txt:315` |
| [L-124.4](LEKTOR-124.md#l-124.4) [E-177](../Intern/BEFUNDE.md#e-177) ohne Testplan | erledigt | `Intern/BEFUNDE.md:410` *„Ein eigener Test für Gregor ist nicht nötig“*. Bei [E-178](../Intern/BEFUNDE.md#e-178) kehrt dasselbe Muster umgekehrt wieder: [L-125.1](#l-125.1) |
| [L-124.5](LEKTOR-124.md#l-124.5) ausgehender Filterweg | erledigt | `Intern/BEFUNDE.md:410` *„K3 (ausgehende Nachrichten) messen und entscheiden“* |
| [L-124.6](LEKTOR-124.md#l-124.6) WERKZEUGE `messen-e177` | erledigt | `tools/WERKZEUGE.md:149` |
| [L-124.7](LEKTOR-124.md#l-124.7) `12d47ba5` | vermerkt | unverändert, nicht mehr änderbar |
| [L-124.8](LEKTOR-124.md#l-124.8) `kein-squash-im-repo` | erledigt bis auf den Laufbericht | `Arbeitsweise/CHRONIST-2026-11-02.md:39` nennt weiter *„26.10. bis 30.10.“*, bewusst stehen gelassen |
| [L-124.9](LEKTOR-124.md#l-124.9) Bauzeiten, Zeilennummer | erledigt | `Intern/BEFUNDE.md:410` *„08:32 (Dateizeit … 08:39)“*, *„01.11.2026 15:15“*; `:401` *„`ReadMessageDoc.cpp:607`“*, und dort steht `CSaveAs SA;` |
| [L-124.10](LEKTOR-124.md#l-124.10) README | erledigt, Zahl wieder veraltet | `README.md:196` ([E-177](../Intern/BEFUNDE.md#e-177)), `README.md:98` *„202 LEKTOR- und PRÜFER-Berichte“*; mit diesem Bericht 203 (124 + 79 nummerierte, gemessen) |

Zur Kenntnis, unverändert: `git grep E-197` trifft weiter nur `Befunde/PRUEFER-81.md` (Nachtrag 2 zu [LEKTOR-124](LEKTOR-124.md#lektor-124)).

## Funde

### <a id="l-125.1"></a>L-125.1 — E-178: der TESTPLAN sagt „entfällt für Gregor“, Befund, Listen und Reihenfolge verlangen Gregors Test

**Gewicht: mittel.** Das ist dasselbe Muster wie [L-124.4](LEKTOR-124.md#l-124.4), nur umgekehrt: Dort verlangte der Befund einen Test, den der Plan nicht hatte. Hier hat der Plan den Test zurückgenommen, die übrigen Texte verlangen ihn weiter. (gemessen)

- `Intern/TESTPLAN.md:229` *„**Für Gregor entfällt dieser Test vorerst — er misst sich am Prüfstand.**“*, `:245` *„einen Testschritt für Gregor gibt es erst wieder, wenn eine Emoji-Mail auf seinem Weg nach *In* kommen kann.“* So steht es auch in der Nachricht von `ad500ceb`: *„Der Test entfaellt fuer Gregor vorerst“*.
- `Intern/BEFUNDE.md:409` Urteil *„…; Gregors Test steht aus.“* und *„**Was noch fehlt:** Gregors Test am Paket ([TESTPLAN](../Intern/TESTPLAN.md#e-178-naechstes)).“* Die erzeugten Zeilen übernehmen das: `Intern/WEITERMACHEN.md:88`, `CHANGELOG.md:40`.
- `Intern/WEITERMACHEN.md:3` *„**Reihenfolge danach:** Gregors Test zu [E-178](../Intern/BEFUNDE.md#e-178) (Testplan steht)“*. Ebenso `Arbeitsweise/stand-02-11-2026.md:15` *„(1) Gregor testet [E-178](../Intern/BEFUNDE.md#e-178) nach TESTPLAN“*.

Wer den Kopf liest, schickt Gregor in einen Abschnitt, der ihm sagt, dass es für ihn nichts zu tun gibt. Nach [Nur der Testplan zählt](../Arbeitsweise/nur-testplan-zaehlt.md) gilt der Plan.

**Vorschlag:** „Was noch fehlt“ bei [E-178](../Intern/BEFUNDE.md#e-178) auf das setzen, was wirklich offen ist. Nach dem Eintrag selbst sind das die zwei ungemessenen Stellen (`SplitTagOff` auf schon festbreitem Text, `OnEditInsertLink` selbst). Dazu ein Vermerk: Gregors Test entfällt, bis eine Emoji-Mail unbeschädigt nach *In* kommt. Danach die Listen neu erzeugen und die Reihenfolge im Kopf berichtigen ([L-125.5](#l-125.5)).

### <a id="l-125.2"></a>L-125.2 — TESTPLAN E-178: „Was der Prüfstand tut“ ist nur halb umgeschrieben

**Gewicht: mittel.** Der Abschnitt beschreibt weder den Prüfstand richtig noch die Messung. Sein Schlusssatz widerspricht der eigenen neuen Überschrift. (gemessen; Vergleich mit `tools/messen-e178.ps1` belegt am Skript)

- `Intern/TESTPLAN.md:250` *„1. Die Mail aus Schritt c in *In* öffnen.“* Schritt c ist mit `ad500ceb` gestrichen (Diff: *„-c. Die Mail in *In* per Doppelklick öffnen“*). Der Verweis zeigt ins Leere.
- Die Überschrift `:219` nennt *„Link, Festbreite und Antwort“*. Die Schritte `:254-266` kennen aber nur Fett, Kursiv, *Make Hyperlink*, Strg+S und *Reply*. **Festbreite**, also der Befehl, der am alten Bau zusätzlich Ж zerstörte (`Intern/BEFUNDE.md:409` *„nach Festbreite zusätzlich `Kyrillisch: ?`“*), kommt in keinem Schritt vor. Der Prüfstand fährt ihn als vierten Schritt (`tools/messen-e178.ps1:372` *„`Name='tt'; Id=33004`“*), und zwar nach dem Link (`:362-365` *„Link VOR tt“*). Der Plan nennt den Link zuletzt.
- `:254` *„*Fett* geben (Strg+B)“*, `:258-260` *„in der Formatierleiste (… am laufenden Programm von mir noch nicht nachgesehen — findest du es dort nicht, bitte sagen)“*, `:267-269` *„dann bitte sagen, nach welchem Schritt“*. Das ist weiter die Ansprache an Gregor, und von Tasten ist die Rede. Der Prüfstand schickt `WM_COMMAND` mit den Befehlsnummern und drückt keine Taste (`messen-e178.ps1:7` *„KEIN Tastendruck“*).
- `:271-273` *„Bis 7.2.1.129 wurde aus dem Emoji schon in Schritt 3 `??` auf dem Bildschirm (am Quelltext belegt, nie am Programm gesehen — dieser Schritt ist die erste Messung).“* Schritt 3 ist Fett/Kursiv, und die waren **nie** betroffen (`:224` desselben Abschnitts; `fett=passt kursiv=passt` auch am alten Bau, `tools/pruefstand-faelle.txt` Kommentar zu `E-178p`). Gesehen ist der Fehler seit dem 02.11. am Bau 7.2.1.128.

**Vorschlag:** Die Schritte durch die Reihenfolge des Skripts ersetzen: Fett, Kursiv (Kontrolle), Link, Festbreite, Speichern, Antwort. Die Ansprache an Gregor und den Schlusssatz streichen. Oder den Abschnitt auf einen Verweis auf `tools/WERKZEUGE.md:151` kürzen. Die Form legt der Hauptagent fest.

### <a id="l-125.3"></a>L-125.3 — E-136: das Urteil sagt „erstmals am Programm gemessen“, Marke, Listen, Rumpf, TESTPLAN und README sagen „nie“

**Gewicht: mittel.** Die Marke steuert die Werkzeuge. `offene-befunde.pl` führt [E-136](../Intern/BEFUNDE.md#e-136) deshalb weiter unter „veraltet gemessen“ und verlangt einen Messweg, den es inzwischen gibt. (gemessen)

- `Intern/BEFUNDE.md:434` Urteil (neu in `214a0879`): *„der Weg Strg-S am 02.11.2026 erstmals am laufenden Programm gemessen (Prüfstand, mit der E-178-Messung `tools/messen-e178.ps1`) … `gespeichert=passt` an 7.2.1.130“*.
- Im selben Eintrag stehen weiter: *„**Am Programm nicht nachgestellt:** `tools/messen-e136.ps1` … erreicht den Speicherweg nicht“* und *„Nächster Schritt: die Knopfanordnung aus `CReadMessageToolBar` … am Quelltext bestimmen, den Knopf per Mausbotschaft drücken“*. Den Weg hat `messen-e178.ps1` inzwischen gefunden, und zwar ohne Mausbotschaft (`tools/messen-e178.ps1:17-20` *„Ein Mausklick per Botschaft an die Leiste wirkt nicht … Statt dessen … "umsgButtonSetCheck"“*). Dazu steht weiter *„**Zuletzt gemessen: 22.10.2026 an 7.2.0.120**“*.
- Daraus erzeugt: `Intern/WEITERMACHEN.md:101` und `CHANGELOG.md:53` *„22.10.2026 an 7.2.0.120 — **veraltet** | Gregors Weg am Paket … oder ein Messweg, der die Nachricht wirklich verändert.“*
- `Intern/TESTPLAN.md:198-200` *„Mein Prüfstand erreicht diesen Weg nicht — dieser Schritt ist die einzige Messung am Programm.“*, `:209` *„genau die fehlen meinem Prüfstand.“*
- `README.md:184` *„(beides am Programm noch nicht nachgemessen)“*.

Die Behebung bleibt offen (es fehlt Gregors Bestätigung, und `.htm` ist am Programm nicht gemessen), das ist richtig. Falsch ist nur, *was* fehlt.

**Vorschlag:** Die Marke auf *„Zuletzt gemessen: 02.11.2026 an 7.2.1.130“* setzen, die beiden überholten Sätze in die Vergangenheit, „Was noch fehlt“ auf „*Speichern unter* `.htm` am Programm; Gregors Bestätigung“. TESTPLAN und README ebenso. Bei der Marke gilt aber [L-125.4](#l-125.4).

### <a id="l-125.4"></a>L-125.4 — Die „Gegenprobe“ für E-136 trennt nicht: `gespeichert=kaputt` am alten Bau ist ein Folgefehler von Festbreite

**Gewicht: mittel.** Die Positivmessung am neuen Bau steht. Die rote Seite gehört aber nicht zu [E-136](../Intern/BEFUNDE.md#e-136). Nach [Erst nachstellen, dann ausliefern](../Arbeitsweise/erst-nachstellen-dann-ausliefern.md) fehlt damit für den Strg-S-Weg das Rot. (belegt am Skript; Messwerte gemessen)

`Intern/BEFUNDE.md:434` *„am Bau 7.2.1.128 ohne die E-178-Stellen `gespeichert=kaputt` (`??`)“*. Zwei Gründe, warum das nichts über [E-136](../Intern/BEFUNDE.md#e-136) sagt:

1. `tools/messen-e178.ps1:376` setzt die Liste nur **vor dem nächsten Formatierbefehl** zurück (*„`if ($vorher -ne 'passt') { Zuruecksetzen $doc }`“*, in der Schleife). Festbreite ist der letzte Befehl (`:372`), und am alten Bau ist er `kaputt`. Gespeichert wird also ein Dokument, in dem schon `?` steht. `gespeichert=kaputt` misst dort, was Festbreite angerichtet hat, nicht den Speicherweg.
2. Der alte Bau `7.2.1.128+d3a625fd*` hat den E-136-Speicherweg **schon behoben** (Nachricht `dcedef85` *„E-136-Speicherweg behoben, [E-178](../Intern/BEFUNDE.md#e-178) nicht“*; `tools/pruefstand-faelle.txt` Kommentar zu `E-178p`). Eine Gegenprobe für [E-136](../Intern/BEFUNDE.md#e-136) gibt es an diesem Bau gar nicht.

Gemessen ist also: Am neuen Bau überlebt die bearbeitete Nachricht Strg-S (`gespeichert=passt`), und der Weg lief (`ID_FILE_SAVE`, `In.mbx` geschrieben). Das genügt für „erstmals am Programm gemessen, grün“. Ein Satz, der „am alten Bau kaputt“ als Beleg für [E-136](../Intern/BEFUNDE.md#e-136) liest, geht zu weit. Für [E-178](../Intern/BEFUNDE.md#e-178) selbst schreibt der Eintrag die Kette richtig (*„nach Link einfügen stand auf dem Bildschirm … nach Festbreite zusätzlich …, in `In.mbx` … ebenso“*).

**Vorschlag:** Bei [E-136](../Intern/BEFUNDE.md#e-136) den Halbsatz zum alten Bau streichen oder als „Folgefehler von [E-178](../Intern/BEFUNDE.md#e-178), kein Beleg für [E-136](../Intern/BEFUNDE.md#e-136)“ kennzeichnen. Eine echte Gegenprobe wäre ein Bau vor `d3a625fd` mit nur Fett (bleibt intakt) und dann Strg-S. Ob sie nötig ist, entscheidet der Hauptagent.

### <a id="l-125.5"></a>L-125.5 — Stand-Köpfe: WEITERMACHEN, ZWEIGE und AUFGABEN stehen vor #200 und vor diesem Zweig

**Gewicht: mittel.** Wieder [L-124.2](LEKTOR-124.md#l-124.2): Den Kopf liest `sitzungsbeginn.pl` jeden Morgen. (gemessen)

- `Intern/WEITERMACHEN.md:3` *„(Zweig `e177_filter_programm`, PR offen)“*. #200 ist gemergt (`6c95e284` *„Merge pull request #200 from HansWurst81675/e177_filter_programm“*). *„**Reihenfolge danach:** Gregors Test zu [E-178](../Intern/BEFUNDE.md#e-178) (Testplan steht), dann [E-143](../Intern/BEFUNDE.md#e-143) Suchfenster einbauen“*: Der erste Schritt ist entfallen ([L-125.1](#l-125.1)), der zweite ist getan (`a7e05aef`, gemessen in `782c6908`). Der Zweig `e143_suchfenster` kommt im Kopf nicht vor. Was danach kommt, steht nur in `Arbeitsweise/stand-02-11-2026.md:15` *„(3) Kleinere: [E-194](../Intern/BEFUNDE.md#e-194) …, [E-195](../Intern/BEFUNDE.md#e-195) …, [E-196](../Intern/BEFUNDE.md#e-196) …, [E-177](../Intern/BEFUNDE.md#e-177) K3 …, [E-198](../Intern/BEFUNDE.md#e-198)“*.
- `tools/ZWEIGE.md:207` beschreibt `e143_suchfenster` nur mit dem Plan, ohne Stand. Die Zeile `:204` zu `e177_filter_programm` hat einen (*„**Stand 02.11.2026:** beides erledigt“*).
- `Intern/AUFGABEN.md:8` *„[E-178](../Intern/BEFUNDE.md#e-178), [E-179](../Intern/BEFUNDE.md#e-179), [E-170](../Intern/BEFUNDE.md#e-170), [E-143](../Intern/BEFUNDE.md#e-143) im Quelltext berichtigt, am Programm noch nicht gemessen.“* [E-143](../Intern/BEFUNDE.md#e-143) hat Gregor im Filterteil an drei Wegen bestätigt (`Intern/BEFUNDE.md:395`). [E-178](../Intern/BEFUNDE.md#e-178) ist am Prüfstand gemessen (`:409`).

**Vorschlag:** Den Kopf auf „#200 gemergt; Zweig `e143_suchfenster`: [E-143](../Intern/BEFUNDE.md#e-143) Suchfenster eingebaut und am Prüfstand gemessen, [E-178](../Intern/BEFUNDE.md#e-178) und der Strg-S-Weg von [E-136](../Intern/BEFUNDE.md#e-136) am Prüfstand gemessen“ setzen. Die Reihenfolge aus der Stand-Notiz übernehmen. In ZWEIGE einen Stand nachtragen, in AUFGABEN die beiden Halbsätze.

### <a id="l-125.6"></a>L-125.6 — CHANGELOG „Im Quellstand, noch in keinem Paket“ kennt weder #200 noch diesen Zweig

**Gewicht: mittel.** Beim Schnüren des nächsten Pakets ist das die Liste, aus der die Paketnotiz entsteht. (gemessen)

`CHANGELOG.md:113-133` führt nur `e184_mehrere_mails` und #197. `grep -n 'E-177' CHANGELOG.md` trifft nur die erzeugte Zeile `:41`. Es fehlen:

- die Behebung von [E-177](../Intern/BEFUNDE.md#e-177) (die Filteraktion *Notify Application* übergab eine falsche Zeichensatzangabe; `034162bc`, gemergt in #200) und die `utf8`-Änderung im Kern (`b25ba6b1`);
- das Suchfenster von [E-143](../Intern/BEFUNDE.md#e-143), ein Hinweis je Übertragung (`a7e05aef`);
- die neuen Messwege `messen-e143s.ps1` und `messen-e178.ps1`, der erste, der den Bearbeiten-Modus erreicht.

Ohne Eintrag steht [E-177](../Intern/BEFUNDE.md#e-177) in WEITERMACHEN als „im Quellstand behoben, kommt mit dem nächsten Paket“ (`Intern/BEFUNDE.md:410`). Im CHANGELOG, das die Paketinhalte führt, steht davon nichts.

**Vorschlag:** Je einen Absatz für #200 und für `e143_suchfenster` in den Abschnitt.

### <a id="l-125.7"></a>L-125.7 — README „Bekannte Fehler“: E-178 nennt Fett und Kursiv; E-143, E-178 und E-136 „am Programm nicht gemessen“

**Gewicht: Kleinkram.** Die Tabelle gilt für das veröffentlichte `v7.2.1.128`. Dort sind die Fehler drin, die Spalte „Ausweg“ stimmt also. Falsch sind die Beschreibung und die Angaben zur Messung. (gemessen)

- `README.md:188` *„machen *Fett*, *Kursiv*, *Link einfügen* und die Antwort auf markierten Text … `??`“* und *„in 7.2.1.130 berichtigt (am Programm nicht gemessen)“*. Fett und Kursiv waren nie betroffen. Festbreite fehlt, und gemessen ist es seit dem 02.11. am Prüfstand. Der Ausweg *„solche Nachrichten nicht formatieren“* ist breiter als nötig.
- `README.md:187` [E-143](../Intern/BEFUNDE.md#e-143): *„(am Programm nicht gemessen)“*. Der Filterteil ist von Gregor bestätigt, das Suchfenster seit `a7e05aef` im Quellstand geändert und am Prüfstand gemessen.
- `README.md:184` [E-136](../Intern/BEFUNDE.md#e-136): siehe [L-125.3](#l-125.3).
- `README.md:98` *„202“*: mit diesem Bericht 203.

Zur Kenntnis: `CHANGELOG.md:141` (Paketnotiz 7.2.1.130) sagt ebenfalls *„**Fett, Kursiv, Link einfügen und Antwort auf markierten Text lassen Emoji stehen**“*. Das ist eine Paketnotiz, also Geschichte. Ein Halbsatz „(Fett und Kursiv waren nie betroffen, gemessen 02.11.2026)“ würde genügen.

### <a id="l-125.8"></a>L-125.8 — E-143 Suchfenster: „noch nicht gelaufen“ steht nach dem Lauf; die Gegenprobe nennt den falschen Bau

**Gewicht: Kleinkram.** (gemessen)

- `tools/WERKZEUGE.md:150` *„Angelegt am 02.11.2026, **noch nicht gelaufen**; erwartet nach `a7e05aef` …“*. `tools/pruefstand-faelle.txt:329` *„Beim Eintrag ungetestet.“* Der Fall lief um 10:58:38 grün (`Intern/pruefstand-buch.tsv` Zeile `E-143s ok 2026-11-02 10:58:38`). Die Zeile zu `messen-e178` daneben (`:151`) nennt ihre Messung. Bei `messen-e177` hat [L-124.6](LEKTOR-124.md#l-124.6) dasselbe gemeldet.
- `Intern/BEFUNDE.md:395` *„**Gegenprobe** am Bau `7.2.1.130+034162bc` ohne die Änderung“*, ebenso die Nachricht von `782c6908`. Die Titelzeilen der beiden Läufe ohne die Änderung lauten `tools/TESTLAEUFE.md:725` und `:726` *„[Eudora 7.2.1.130+b25ba6b1 2026-11-02 09:13 - E143S]“*. Auch `b25ba6b1` ist ohne die Änderung, in der Sache stimmt die Gegenprobe also. Maßstab ist aber die Titelzeile ([Version eindeutig machen](../Arbeitsweise/version-eindeutig-machen.md)).

### <a id="l-125.9"></a>L-125.9 — WERKZEUGE führt vier Werkzeuge doppelt, mit verschiedenen Beschreibungen

**Gewicht: Kleinkram.** (gemessen)

`grep -o '^| \`tools/[^\`]*\`' tools/WERKZEUGE.md | sort | uniq -d`:

| Werkzeug | Zeilen |
|---|---|
| `tools/pruefe-behoben-belegt.pl` | `:29` und `:177` |
| `tools/pruefe-anzeigetext.pl` | `:30` und `:178` |
| `tools/arbeitsbaum-angleichen.sh` | `:38` und `:179` |
| `tools/arbeitsbaum-angleichen-tests.sh` | `:39` und `:180` |

Die Paare widersprechen sich nicht, beschreiben aber verschieden genau. `:179` *„**der erste Schritt jedes Agentenauftrags** … setzt sonst die …“* sagt mehr als `:38`. Wer nur eine Zeile liest, bekommt nur die halbe Beschreibung. An `6c95e284` war es genauso (gemessen), dieser Zweig hat es also nicht verursacht. Die zweite Fassung von `pruefe-behoben-belegt.pl` kam mit `8be68e06` (14.09.2026). Die neuen Zeilen dieses Zweigs (`messen-e143s`, `messen-e178`) stehen je einmal da. In `tools/pruefstand-faelle.txt` gibt es keine doppelte Fallkennung (gemessen über die erste Spalte aller Nicht-Kommentarzeilen), `E-143s` und `E-178p` stehen je einmal (`:330`, `:340`).

**Vorschlag:** Je Paar die genauere Zeile behalten. Eine Schranke wie `uniq -d` passt zu [Fehlerklassen abstellen](../Arbeitsweise/fehlerklassen-abstellen.md), wenn es ein zweites Mal vorkommt.

### <a id="l-125.10"></a>L-125.10 — CHANGELOG: der Link auf E-179 zeigt ins Leere, und die Schranke sieht es nicht

**Gewicht: Kleinkram.** (gemessen)

`CHANGELOG.md:39` *„| **[E-179](BEFUNDE.md#e-179)** |“*. Alle anderen Zeilen im Block schreiben `Intern/BEFUNDE.md#…`. Ein `BEFUNDE.md` im Wurzelverzeichnis gibt es nicht. Das steht so seit `424f46de` (01.11.2026, `git log -S`). `tools/offene-befunde.pl:611-615` vergleicht absichtlich ohne Linkpfad (*„ein reiner PFAD-Unterschied faellt ihm deshalb nicht auf. Mit "-schreiben" wird darum immer gesetzt“*). Seitdem hat offenbar niemand mit `-schreiben` neu gesetzt, oder `block_fuer()` übersetzt diese eine Zeile nicht (Vermutung, nicht gemessen; ich habe nichts geschrieben).

### <a id="l-125.11"></a>L-125.11 — Gregors E-178-Versuch: „Fragezeichen im Betreff (E-90)“ widerspricht E-90; und der E-136-Abschnitt bietet die Prüfnachricht an, die E-178 für unerreichbar hält

**Gewicht: Kleinkram, aber ein Ausreißer.** (gemessen am Text; Ursache Vermutung)

- `Intern/TESTPLAN.md:230-235` *„Schon beim Öffnen standen Fragezeichen da — im Betreff ([E-90](../Intern/BEFUNDE.md#e-90): Emoji im Betreff gehen beim Empfang verloren) und im Text (…)“*. Nach `Intern/BEFUNDE.md:353` erscheinen Emoji seit 7.2.0.59 **nicht** als `?`: *„**Emoji erscheinen also nicht als `?`, sie erscheinen gar nicht.**“* (`utils.cpp:1582` streicht jedes Surrogat). Dazu: *„**Am laufenden Programm ist das seit 7.2.0.59 nie nachgemessen worden.**“* Gregors Versuch ist damit die erste Beobachtung am Programm. Der TESTPLAN sagt nicht, welches Zeichen zu `?` wurde. Vermutung: Das `?` ist Ж (kein Surrogat, also `WideCharToMultiByte`-Ersatzzeichen), das Emoji fehlte. Das passte zu [E-90](../Intern/BEFUNDE.md#e-90). Stand im Betreff aber ein `?` für 🔥, dann ist [E-90](../Intern/BEFUNDE.md#e-90) falsch beschrieben. [Ausreißer ist der Befund](../Arbeitsweise/ausreisser-ist-der-befund.md).
- `Intern/TESTPLAN.md:203-204` ([E-136](../Intern/BEFUNDE.md#e-136), an Gregor) bietet als Schritt 1 *„die Prüfnachricht `Testdaten/e136-zeichen-als-entitaet.eml` (🔥 und Ж)“* an, ohne zu sagen, wie sie nach *In* kommt. Der E-178-Abschnitt nimmt Gregor den Test ab, *„wenn eine Emoji-Mail auf seinem Weg nach *In* kommen kann“* (`:245-246`), mit genau dieser Nachricht für den Prüfstand (`:241-243`). Kommt Gregor an die Prüfnachricht, wäre auch [E-178](../Intern/BEFUNDE.md#e-178) für ihn ausführbar. Kommt er nicht an sie, ist der E-136-Schritt 1 so wenig ausführbar wie die alte E-178-Vorbereitung.

**Vorschlag:** Bei Gregor nachfragen, welches Zeichen im Betreff stand, und es bei [E-90](../Intern/BEFUNDE.md#e-90) als Beobachtung eintragen. Den E-136-Abschnitt an dieselbe Feststellung angleichen wie [E-178](../Intern/BEFUNDE.md#e-178).

## Zur Kenntnis

- **[E-143](../Intern/BEFUNDE.md#e-143) Suchfenster am Quelltext** (`SearchView.cpp`, Diff `a7e05aef`, belegt): Empfangene Treffer nach Out werden gezählt und übersprungen, verfasste gehen weiter durch, der Hinweis kommt einmal nach der Schleife. Das entspricht Gregors Entscheidung *„ja, ein hinweis reicht“*. Die Schleife ist dieselbe für die Suche mit und ohne X1-Index (`SearchView.cpp:3852-3876`, über `m_ResultsList` und `GetByMessageId`). Dass der Prüfstand mit `UseIndexedSearch=0` fährt (`messen-e143s.ps1:19`), Gregor aber mit der Vorgabe `1` (`EudoraRes.rc:7848`), ändert am geprüften Weg also nichts. Die Logzeile geht über `DEBUG_MASK_MISC` (0x8000, `debug.h:36`). Die ist in der Vorgabe 25759 aus, in Gregors 58527 an (`Intern/TESTPLAN.md:284-286`). Die Filterzeile von [E-143](../Intern/BEFUNDE.md#e-143) geht über `DEBUG_MASK_FILTERS` (0x400), der in der Vorgabe an ist. Die Schritte 6–8 im TESTPLAN verlangen die Logzeile nicht, daher kein Fund.
- **TESTPLAN [E-143](../Intern/BEFUNDE.md#e-143) Schritte 6–8** (`Intern/TESTPLAN.md:313-324`): *Edit → Find → Find Messages (Strg+F)* stimmt mit der Menüvorlage (`EudoraRes.rc:5612` *„Find &Messages\tCtrl+F“*). Der Hinweistext *„Messages can't be transferred to the Out mailbox …“* stimmt mit `IDD_XFER_TO_OUT_REFUSED` (`EudoraRes.rc:2041-2049`). „Erst mit dem nächsten Paket“ ist eindeutig. Belegt am Quelltext, nicht am Programm.
- **E-178-Gegenprobe:** Die Zeile ohne Titel in `tools/TESTLAEUFE.md` (11:02:02, *„Nachgetragen von Hand“*) ist offen als Nachtrag gekennzeichnet. Die Läufe 11:16:58 und 11:19:01 haben keine Titelzeile (`tools/TESTLAEUFE.md`). Den Bau des gewerteten Laufs 11:19 nennt `Intern/pruefstand-buch.tsv` (`7.2.1.130+a7e05aef 2026-11-02 10:05`).
- **Daten von Gregors Rechner:** In den Nachrichten von `6c95e284..214a0879` steht nichts zu `Users`, `vmware` oder `Shared Folders` (gemessen, `grep` ohne Treffer). Auch im Zuwachs des Diffs steht nichts. Pfade nur unter `C:\Temp`.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): *„Kein Widerspruch gefunden.“* „Zur Kenntnis“: dieselben 18 Dateien ohne 7.2.1.130 wie in [LEKTOR-124](LEKTOR-124.md#werkzeuge). Die Widersprüche aus [L-125.1](#l-125.1), [L-125.3](#l-125.3) und [L-125.5](#l-125.5) sieht das Werkzeug nicht. Sie stehen im Fließtext oder in der Spalte „was noch fehlt“.

`perl tools/offene-befunde.pl` (gemessen):

```
    offen laut Intern/BEFUNDE.md  51
      davon aktuell gemessen       7  (ab Nummer 125)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     28
      davon NIE gemessen          16
    in Intern/WEITERMACHEN.md     51

  51 offene Befunde, in beiden Listen gleich.
```

Gegenüber dem Nachtrag zu [LEKTOR-124](LEKTOR-124.md#lektor-124) (51 offen, 17 nie gemessen) ist [E-178](../Intern/BEFUNDE.md#e-178) von „nie“ zu „aktuell gemessen“ gewandert. [E-136](../Intern/BEFUNDE.md#e-136) zählt weiter unter „veraltet“, siehe [L-125.3](#l-125.3).

`perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“* 232 Befunde, 113 mit Testfall, kritisch ohne jede Prüfung 7 ([E-122](../Intern/BEFUNDE.md#e-122) [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-133](../Intern/BEFUNDE.md#e-133) [E-39](../Intern/BEFUNDE.md#e-39)), unverändert.

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

`perl tools/rollen-faellig.pl` (gemessen): fällig sind LEKTOR (dieser Lauf), **PRÜFER** (*„seit seinem Bericht (b25ba6b) haben sich 2 Datei(en) in seinem Bereich geaendert - Eudora71/Eudora/SearchView.cpp, Eudora71/Tests/TestE143.cpp“*: die Suchfenster-Änderung ist von keinem PRÜFER gegengelesen) und **CHRONIST** (*„seit seinem Bericht (12d47ba) haben sich 10 Datei(en) … geaendert“*).

## Was nur Gregor entscheiden kann

Nur eine Frage, und sie betrifft eine Beobachtung, nicht eine Entscheidung: Welches Zeichen stand beim E-178-Versuch am 02.11. im **Betreff** als Fragezeichen? Stand dort ein `?` für das Emoji, oder fehlte das Emoji und nur Ж wurde `?` ([L-125.11](#l-125.11))? Das sagt, ob [E-90](../Intern/BEFUNDE.md#e-90) (Emoji im Betreff gehen beim Empfang verloren) richtig beschrieben ist. Alles andere in diesem Bericht ist Buchführung und Testform. Das hat Gregor dem Hauptagenten übertragen, ebenso, ob der E-136-Weg eine eigene Gegenprobe braucht ([L-125.4](#l-125.4)).

## <a id="nachtrag-02-11-2026"></a>Nachtrag 02.11.2026

Gegengelesen: `git diff 964a9447..origin/e143_suchfenster` (`f1138540`, `da76ff92`, `abe1721e`, `cb99c5f4`; 16 Dateien), nach `tools/arbeitsbaum-angleichen.sh`. Keine neue Runde. Dazu nach Auftrag: der neue Befund [E-199](../Intern/BEFUNDE.md#e-199) (*Festbreite* im Bearbeiten-Modus schreibt `t;` in den Text), die Änderung an `tools/offene-befunde.pl` und „Antwort nicht gemessen“ bei [E-178](../Intern/BEFUNDE.md#e-178).

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-125.1](#l-125.1) [E-178](../Intern/BEFUNDE.md#e-178) „Gregors Test“ | erledigt | `Intern/BEFUNDE.md:410` *„Für Gregor entfällt der Test vorerst“*, „Was noch fehlt“ nennt die Antwort auf markierten Text; die erzeugten Zeilen stimmen (`offene-befunde.pl`: *„52 offene Befunde, in beiden Listen gleich“*); `Intern/WEITERMACHEN.md:3` *„**für Gregor entfällt der E-178-Test vorerst**“* |
| [L-125.2](#l-125.2) TESTPLAN „Was der Prüfstand tut“ | erledigt | Schritte in der Reihenfolge des Skripts (Fett, Kursiv, Link, Festbreite, Speichern, Antwort), *„vor dem Speichern nicht“* zurückgesetzt, keine Ansprache an Gregor; Schlusssatz *„Bis 7.2.1.129 machten *Make Hyperlink* und *Festbreite* aus dem Emoji schon auf dem Bildschirm `??`“* |
| [L-125.3](#l-125.3) [E-136](../Intern/BEFUNDE.md#e-136) „nie gemessen“ | erledigt | `Intern/BEFUNDE.md:435` Marke *„Zuletzt gemessen: 02.11.2026 an 7.2.1.130“*; „Was noch fehlt: *Speichern unter* als `.htm` am Programm messen“; die überholten Sätze zum Messweg stehen in der Vergangenheit (*„Warum der Prüfstand bis zum 02.11.2026 nicht schrieb“*). Der TESTPLAN-Abschnitt und `README.md:184` ziehen mit. `offene-befunde.pl`: veraltet 28 → 27 |
| [L-125.4](#l-125.4) E-136-Gegenprobe | erledigt | `Intern/BEFUNDE.md:435` *„eine Gegenprobe für diesen Weg gibt es nicht“*; TESTPLAN ebenso, mit der Begründung (Folgefehler der Festbreite, Weg im alten Bau schon behoben) |
| [L-125.5](#l-125.5) Stand-Köpfe | erledigt | `Intern/WEITERMACHEN.md:3` *„#200 … ist gemergt. Zweig `e143_suchfenster`, PR folgt“* mit neuer Reihenfolge; `tools/ZWEIGE.md:207` *„**Stand 02.11.2026 nachmittags:**“*; `Intern/AUFGABEN.md:8` *„seither am Programm gemessen: der Filterteil von [E-143](../Intern/BEFUNDE.md#e-143) … und [E-178](../Intern/BEFUNDE.md#e-178) (am Prüfstand, 02.11.2026, ohne die Antwort auf markierten Text)“* |
| [L-125.6](#l-125.6) CHANGELOG ohne #200 und Suchfenster | erledigt | `CHANGELOG.md`, Abschnitt „Im Quellstand, noch in keinem Paket“: je ein Absatz *„Zweig `e143_suchfenster`“* und *„gemergt als #200“* mit [E-177](../Intern/BEFUNDE.md#e-177), `utf8` und [E-198](../Intern/BEFUNDE.md#e-198) |
| [L-125.7](#l-125.7) README | **teilweise** | erledigt: `README.md:184`, `:187`, `:188` ([E-178](../Intern/BEFUNDE.md#e-178) jetzt *„Link einfügen, Festbreite … (Fett und Kursiv sind nicht betroffen)“*, Antwort *„nicht gemessen“*), Paketnotiz 7.2.1.130 im CHANGELOG mit Nachtrag. **Rest:** `README.md:98` *„204 LEKTOR- und PRÜFER-Berichte“*; gezählt sind an `cb99c5f4` 205 nummerierte (`ls Befunde/LEKTOR-[0-9]*.md Befunde/PRUEFER-[0-9]*.md`, mit [LEKTOR-125](#lektor-125) und PRÜFER-82) |
| [L-125.8](#l-125.8) `messen-e143s`, Gegenprobe-Bau | erledigt | `tools/WERKZEUGE.md:150` *„**Gemessen am 02.11.2026:** Bau 7.2.1.130+a7e05aef (10:58) und nach dem K4-Fix …“*; `tools/pruefstand-faelle.txt` *„Gelaufen am 02.11.2026“*; `Intern/BEFUNDE.md:395` *„**Gegenprobe** am Bau `7.2.1.130+b25ba6b1`“* |
| [L-125.9](#l-125.9) doppelte Zeilen in WERKZEUGE | erledigt | die Suche nach doppelten Werkzeugzeilen (`grep`, `sort`, `uniq -d` über die erste Spalte) ist leer |
| [L-125.10](#l-125.10) Link auf [E-179](../Intern/BEFUNDE.md#e-179) | erledigt | `CHANGELOG.md:40` *„[E-179](../Intern/BEFUNDE.md#e-179)“*; im erzeugten Block des CHANGELOG steht keine Kennung mehr mit `](BEFUNDE.md` (gemessen, 0 Treffer). Ursache und Abhilfe siehe unten |
| [L-125.11](#l-125.11) Betreff-Fragezeichen, E-136-Prüfnachricht | **teilweise** | erledigt: Gregors Betreff steht jetzt wörtlich da (TESTPLAN, E-178-Abschnitt, und `Intern/BEFUNDE.md:410`: *„im Betreff stand `tesmail  ?).` (zwei Leerzeichen: ein Zeichen fiel weg, eines wurde `?`)“*). Damit ist meine Frage an Gregor beantwortet. Der E-136-Abschnitt sagt jetzt *„Für Gregor entfällt dieser Test vorerst“* mit derselben Begründung wie [E-178](../Intern/BEFUNDE.md#e-178). **Rest (Kleinkram):** Bei [E-90](../Intern/BEFUNDE.md#e-90) (Emoji im Betreff gehen beim Empfang verloren) steht weiter *„Am laufenden Programm ist das seit 7.2.0.59 nie nachgemessen worden.“* Die erste Beobachtung am Programm steht nur bei [E-178](../Intern/BEFUNDE.md#e-178). Sie passt zu [E-90](../Intern/BEFUNDE.md#e-90) (ein Zeichen fiel weg), nur ist ungeklärt, welches |

**`tools/offene-befunde.pl`** (gemessen am Diff, belegt am Quelltext): Die Ursache ist jetzt gefunden und steht im Kommentar. Die Kürzung der Spalte „was noch fehlt“ endete bei [E-184](../Intern/BEFUNDE.md#e-184) in einem angeschnittenen Link `([PRUEFER-78](Befu`. Das Muster in `block_fuer()` suchte über das Zeilenende hinweg nach `)` und fing so den Link der nächsten Zeile ein, die E-179-Zeile. Meine Vermutung aus [L-125.10](#l-125.10) („`block_fuer()` übersetzt diese eine Zeile nicht“) traf damit den Ort, nicht aber den Grund. Zwei Änderungen: Ein angeschnittener Link wird ganz weggekürzt (`:309-317`), und das Muster bleibt in seiner Zeile (`[^)\n]`, `:573-574`). Beides ist folgerichtig. Ein eigener Gegentest liegt nicht bei (der Diff enthält keine Testdatei, `tools/` hat keine zu `offene-befunde.pl`). Der Vergleich ohne Linkpfad (`:611-615`) bleibt, wie er ist. Eine künftige Pfadabweichung fällt also weiter nur beim Schreiben auf (Vermutung, nicht geprüft).

**[E-199](../Intern/BEFUNDE.md#e-199)** (`Intern/BEFUNDE.md:399`): Die Ursache ist am Quelltext belegt, ich habe nachgelesen. `TridentReadMessageView.cpp:4074-4077` (`WrapTag`) und `:3636-3643` (`SplitTagOff`) schneiden nach `Text2Html` zwei Zeichen ab (`// strip "\r\n"`). `Text2Html.cpp:1050-1052` hängt `"\r\n"` aber nur an, wenn die Zeile auf `\r` endet. `git log -- Text2Html.cpp` zeigt nur `567a5d87` (erster Commit) und `2fb15664`. „Originalfehler“ ist damit belegt. Die Messung (`t;` in beiden `In.mbx`) stammt aus PRÜFER-82 K2. Ich habe sie nicht wiederholt (nichts gestartet). Die Stufe *unkritisch* passt zur Tabelle (nichts geht verloren). Kurztext ohne Kürzel, *„Gregor muss nichts tun“* und „Was noch fehlt“ widersprechen sich nicht: Ein Test für Gregor wird nicht verlangt.

**[E-178](../Intern/BEFUNDE.md#e-178) „Antwort nicht gemessen“:** Das ist überall gleich geführt: Urteil `Intern/BEFUNDE.md:410` (*„die Antwort auf markierten Text ist nicht gemessen“*), „Was noch fehlt“ (das Skript muss prüfen, dass nur die Markierung zitiert wird; bleibt das Vollzitat, ist es ein Funktionsfehler), TESTPLAN (*„**Antwort: nicht gemessen.**“*, Schritt 7, „Bestanden“ ohne `antwort`), README `:188`, AUFGABEN `:8`, CHANGELOG, WEITERMACHEN-Reihenfolge. Die Begründung folgt PRÜFER-82 K1: Am neuen Bau zitiert `Out.mbx` die ganze Nachricht, am alten nur die Markierung. Zur Kenntnis, beides Kleinkram:

- Der Prüfstandsfall erwartet weiter `antwort=passt` (`tools/pruefstand-faelle.txt`, Zeile `E-178p`; der Kommentar darüber sagt *„ABER antwort ist NICHT gemessen“*). Der Fall bleibt also grün, ob die Antwort richtig zitiert oder nicht, bis das Skript geändert ist. Das ist so gewollt und dokumentiert. Wer nur `pruefstand-ergebnis.txt` liest, sieht es aber nicht.
- Ob das Vollzitat am neuen Bau ein Funktionsfehler ist, bleibt offen (PRÜFER-82: Vermutung). Er stünde dann in einem Weg, den Gregor täglich benutzen kann. Die Reihenfolge im WEITERMACHEN-Kopf setzt die Messung darum richtig an die erste Stelle.

**Neu, Kleinkram:** Der Lauf `E-143s` nach dem K4-Fix hat in `tools/TESTLAEUFE.md` (`2026-11-02 11:53:06`) keine Titelzeile. Den Bau nennt nur `Intern/pruefstand-buch.tsv:36` (*„7.2.1.130+f1138540\* 2026-11-02 11:51“*). `tools/ZWEIGE.md:207` sagt *„am Bau 11:51“*, die Nachricht von `da76ff92` *„am Bau 11:52“*. Maßstab ist die Titelzeile, also 11:51.

Ergebnis: Von elf Funden sind neun erledigt und zwei teilweise ([L-125.7](#l-125.7): Berichtszahl 204 statt 205; [L-125.11](#l-125.11): [E-90](../Intern/BEFUNDE.md#e-90) nennt die Beobachtung nicht). [E-199](../Intern/BEFUNDE.md#e-199), die Werkzeugänderung und „Antwort nicht gemessen“ sind sauber. Für Gregor ist nichts zu entscheiden.
