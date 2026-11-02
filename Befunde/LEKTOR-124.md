# <a id="lektor-124"></a>LEKTOR-124 — Bestand nach E-177, Zweig e177_filter_programm nach 0a04175a (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-123](LEKTOR-123.md#lektor-123).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102c`, abgezweigt von `origin/e177_filter_programm`, Stand `0a04175a`.
Umfang: alle `.md` aus `git ls-files` ohne `Arbeitsweise/` und `Befunde/` gegen den Bestand; geändert seit `34ff9e92` (Merge von #199) sind davon `Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`, `CHANGELOG.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md`, `tools/TESTLAEUFE.md` (`git diff --stat 34ff9e92 HEAD`, gemessen). Schwerpunkte nach Auftrag: [E-177](../Intern/BEFUNDE.md#e-177) (die Filteraktion *Notify Application* mit `%6` übergab eine Datei mit falscher Zeichensatzangabe), der Testplan zu [E-178](../Intern/BEFUNDE.md#e-178) (Fett, Kursiv und Link im Bearbeiten-Modus machen Emoji zu `??`), der CHRONIST-Lauf vom 02.11. mit der Berichtigung von `kein-squash-im-repo`, die Berichtigung meines Fundes [L-123.4](LEKTOR-123.md#l-123.4) und Daten von Gregors Rechner in Stand und Commit-Nachrichten.

## Kurz

[E-177](../Intern/BEFUNDE.md#e-177) ist in der Sache sauber belegt: Behebung `034162bc`, Prüfstand grün an `034162bc`, rot am alten Bau, Regressionstest mit zwei Fällen. Die Texte rund um [E-177](../Intern/BEFUNDE.md#e-177) sind aber auf drei verschiedenen Ständen. Der WEITERMACHEN-Kopf meldet den Fehler als nur gemessen, und das Nachrichtenfenster von [E-140](../Intern/BEFUNDE.md#e-140) (Speichern unter ohne Zeichensatz) noch als „erneut zu prüfen“ ([L-124.2](#l-124.2)). Der E-177-Eintrag beschreibt im Kurztext und beim Prüfstandsfall noch den Fehlerstand ([L-124.3](#l-124.3)). Und er verlangt „Gregors Test am nächsten Paket“, obwohl er sagt „Gregor muss nichts tun“ und im TESTPLAN kein Abschnitt dazu steht ([L-124.4](#l-124.4)). Mein eigener Fund [L-123.4](LEKTOR-123.md#l-123.4) war falsch abgehakt: gemergt wurde normal, Gregor entschied „so lassen“ ([L-124.1](#l-124.1)). Daten von Gregors Rechner: im Stand und in den neun Commit-Nachrichten seit `34ff9e92` keine (gemessen). Zehn Funde, keiner am Programm. Nach Auftrag ist nichts berichtigt.

## Funde aus LEKTOR-123

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-123.1](LEKTOR-123.md#l-123.1) [E-140](../Intern/BEFUNDE.md#e-140) „zweite Datei“ | erledigt | `Intern/BEFUNDE.md:429` *„Gregors erste Datei vom 01.11. (23:12) war aus der Postfachliste gekommen“* |
| [L-123.2](LEKTOR-123.md#l-123.2) TESTPLAN zu [E-194](../Intern/BEFUNDE.md#e-194) (`<x-flowed>` in der gespeicherten Datei) | erledigt | `Intern/TESTPLAN.md:175` *„(`<x-flowed>` in der Datei aus der Postfachliste)“* |
| [L-123.3](LEKTOR-123.md#l-123.3) [E-143](../Intern/BEFUNDE.md#e-143) (Out-Hinweis je Nachricht) Restsätze | erledigt | `Intern/BEFUNDE.md:395` *„**Was noch fehlt:** der Filterteil ist am Programm gemessen … das Suchfenster ist entschieden (ein Hinweis je Übertragung) und noch einzubauen.“* |
| [L-123.4](LEKTOR-123.md#l-123.4) Namen in `1c75f5c3` | **im Nachtrag falsch abgehakt** | berichtigt in [L-124.1](#l-124.1) |
| [L-123.5](LEKTOR-123.md#l-123.5) README-Zahl | erledigt, mit diesem Bericht wieder veraltet | `README.md:98` *„200 LEKTOR- und PRÜFER-Berichte“*; an `0a04175a` 122 LEKTOR + 78 PRÜFER (nur nummerierte, gemessen), mit diesem Bericht 201. Die *„124 Lehren“* (`README.md:99`) stimmen jetzt: 124 mit dem Filter aus [LEKTOR-123](LEKTOR-123.md#nachtrag-02-11-2026) ohne `MEMORY.md` (gemessen; an `34ff9e92` waren es 123, dazu kam `kein-squash-im-repo`) |
| [L-123.6](LEKTOR-123.md#l-123.6) [E-195](../Intern/BEFUNDE.md#e-195) (`.rtf` liefert Klartext) Aufrufer | erledigt, Zeilennummer seit `034162bc` verschoben | siehe [L-124.9](#l-124.9) |

Zur Kenntnis aus [LEKTOR-123](LEKTOR-123.md#lektor-123), unverändert (gemessen): `Intern/BEFUNDE.md:400`, `:401`, `:429` verweisen mit `[LEKTOR-122](../Befunde/LEKTOR-122.md) L-122.x` ohne Sprungmarke; `ImapAppend.cpp:691` in [E-194](../Intern/BEFUNDE.md#e-194); `DSPrintEdit.cpp` fehlt in [E-195](../Intern/BEFUNDE.md#e-195) (0 Treffer). Die Zeile in [LEKTOR-123](LEKTOR-123.md#lektor-123) „Zur Kenntnis“ zu `23e624af` hat sich erledigt: der Commit ist jetzt Vorfahr dieses Stands, `Intern/TESTPLAN.md:237-242` hat die Anleitung zum Sichern.

## Funde

### <a id="l-124.1"></a>L-124.1 — Berichtigung zu L-123.4: nicht durch *Squash* erledigt, sondern durch Gregors „so lassen“

**Gewicht: mittel.** Mein Nachtrag in [LEKTOR-123](LEKTOR-123.md#nachtrag-02-11-2026) hat einen Fund auf eine Ankündigung hin abgehakt. Die Ankündigung ist dann nicht eingetreten. (gemessen; Gregors Satz belegt)

`Befunde/LEKTOR-123.md:125` *„erledigt durch Entscheidung | laut Hauptagent hat Gregor *Squash and merge* für diesen PR bestätigt (belegt nur durch die Nachricht des Hauptagenten)“*, ebenso `Intern/LEKTORAT.md:3029` *„die Namen in `1c75f5c3` verschwinden mit *Squash and merge* (laut Hauptagent von Gregor bestätigt)“*.

Gemessen:

- `34ff9e92` *„Merge pull request #199 …“* hat zwei Eltern (`99e77aa1 ed697a24`), Zeit 08:14:07. Ein gewöhnlicher Merge.
- `git merge-base --is-ancestor 1c75f5c3 origin/main` → ja. Der Commit steht in der Geschichte von `main`, mit dem Freigabepfad in seiner Nachricht.
- `gh api repos/HansWurst81675/Eudora7.2` → `[true,true,"COMMIT_MESSAGES"]` (`allow_squash_merge`, `allow_merge_commit`, `squash_merge_commit_message`). *Squash* wäre möglich gewesen, hätte aber die Nachricht von `1c75f5c3` mit dem Pfad in den Squash-Commit übernommen. Mein Vorschlag aus [L-123.4](LEKTOR-123.md#l-123.4) hätte also nicht gewirkt.

Belegt: `Arbeitsweise/kein-squash-im-repo.md:13` *„Gregor: „ja, so lassen.““*; `Arbeitsweise/CHRONIST-2026-11-02.md:66` *„Gemergt wurde normal, und Gregor entschied um 08:16:09 „ja, so lassen.““*.

**Richtig:** [L-123.4](LEKTOR-123.md#l-123.4) ist *erledigt durch Entscheidung: Die Geschichte bleibt, wie sie ist (Gregor 02.11.2026, 08:16)*. Im Stand steht weiter nichts davon. Die Lehre für diese Rolle steht schon in `Arbeitsweise/kein-squash-im-repo.md:29`: *„Ein LEKTOR hakt einen Fund erst nach der Handlung ab, nicht auf ihre Ankündigung hin.“* `LEKTOR-123.md` bleibt nach Auftrag unverändert. In `Intern/LEKTORAT.md` steht die Berichtigung bei [LEKTOR-123](LEKTOR-123.md#lektor-123) und unten bei [LEKTOR-124](#lektor-124).

### <a id="l-124.2"></a>L-124.2 — Stand-Köpfe: WEITERMACHEN, TESTPLAN und ZWEIGE stehen vor `9c28db92` und `034162bc`

**Gewicht: mittel.** Wer morgens den Kopf liest, hält [E-177](../Intern/BEFUNDE.md#e-177) für unbehoben und [E-140](../Intern/BEFUNDE.md#e-140) für halb geprüft. (gemessen)

- `Intern/WEITERMACHEN.md:3` *„**Stand 02.11.2026 mittags.** [E-177](../Intern/BEFUNDE.md#e-177) gemessen …: die Filteraktion *Notify Application* mit `%6` übergibt eine Datei mit **falscher** Zeichensatzangabe.“* Seit `034162bc`/`12d47ba5` ist [E-177](../Intern/BEFUNDE.md#e-177) im Quellstand behoben und am Prüfstand gemessen (`Intern/BEFUNDE.md:409` *„offen — im Quellstand behoben … und am Prüfstand gemessen; kommt mit dem nächsten Paket.“*).
- Ebenda: *„[E-140](../Intern/BEFUNDE.md#e-140) für das Verfassen-Fenster bestätigt, das Nachrichtenfenster ist erneut zu prüfen“* und *„Danach Zweig `e177_filter_programm` (Testplan [E-178](../Intern/BEFUNDE.md#e-178) schon eindeutig gemacht, dann [E-177](../Intern/BEFUNDE.md#e-177))“*. Gregor hat das Nachrichtenfenster am 02.11. bestätigt (`9c28db92`; `Intern/BEFUNDE.md:429` *„damit an beiden Fenstern bestätigt“*). Beide Schritte des Zweigs sind getan. Was als Nächstes kommt, steht nirgends. Der CHRONIST hat am selben Morgen eine Zeile „Reihenfolge“ in WEITERMACHEN angemahnt (`Arbeitsweise/CHRONIST-2026-11-02.md:43`).
- `Intern/TESTPLAN.md:1` *„zuletzt getestet am 01. und 02.11.2026 das Testpaket 7.2.1.130: [E-140](../Intern/BEFUNDE.md#e-140) im Verfassen-Fenster und [E-143](../Intern/BEFUNDE.md#e-143) im Filterteil bestätigt“*. Der Abschnitt selbst (`:175`) sagt richtig *„[E-140](../Intern/BEFUNDE.md#e-140) ist damit an beiden Fenstern bestätigt.“*
- `tools/ZWEIGE.md:204` beschreibt `e177_filter_programm` nur mit dem Plan: *„dann [E-177](../Intern/BEFUNDE.md#e-177) messen (Filteraktion *an Programm übergeben*: Zwischendatei ohne Zeichensatz)“*. Gemessen wurde eine **falsche** Angabe, nicht eine fehlende. Andere Zeilen führen einen Stand (`:206` *„Stand `2fd14adc`: …“*).

**Vorschlag:** Den Kopf auf „[E-177](../Intern/BEFUNDE.md#e-177) behoben und am Prüfstand gemessen, [E-140](../Intern/BEFUNDE.md#e-140) an beiden Fenstern bestätigt“ setzen, dazu eine Zeile *Reihenfolge*. Den TESTPLAN-Kopf ebenso. In ZWEIGE einen Stand nachtragen.

### <a id="l-124.3"></a>L-124.3 — E-177 beschreibt sich teils noch im Fehlerstand; E-140 nennt E-177 „ungemessen, ohne Angabe“

**Gewicht: mittel.** Derselbe Eintrag sagt vorn „steht weiter“ und hinten „behoben“. (gemessen)

`Intern/BEFUNDE.md:409`:

- Kurztext: *„Bei einer empfangenen UTF-8-Nachricht steht darin weiter „charset=utf-8", der Text selbst aber in windows-1252“*. Im Quellstand stimmt das seit `034162bc` nicht mehr (ebenda: *„trägt jetzt `charset="windows-1252"` über windows-1252-Bytes“*).
- *„**Prüfstandsfall** `E-177p` … erwartet heute den Fehlerstand `falsche-angabe=1` und wird nach der Behebung auf `0` umgestellt.“* Er ist umgestellt: `tools/pruefstand-faelle.txt:323` erwartet *„pop=passt e118=passt roh=falsch falsche-angabe=0“*. Weiter hinten im selben Eintrag: *„der Fall urteilt seither je Weg“*.
- `tools/pruefstand-faelle.txt:315-317` sagt dasselbe noch: *„ACHTUNG: die Erwartung ist der GEMESSENE FEHLERSTAND an 7.2.1.130 (falsche-angabe=1 …)“*. Zwei Zeilen tiefer steht *„Nach der Behebung umgestellt (02.11.2026)“*.

`Intern/BEFUNDE.md:429` ([E-140](../Intern/BEFUNDE.md#e-140)): *„**Nicht behoben:** die Filteraktion *„an Programm übergeben"* … schreibt ihre Zwischendatei weiter ohne Angabe — ungemessen, jetzt eigener Befund [E-177](../Intern/BEFUNDE.md#e-177)“*. Gemessen ist eine falsche Angabe, und sie ist im Quellstand behoben.

**Vorschlag:** Kurztext in die Vergangenheit setzen (*„stand … — im Quellstand behoben“*). Den Satz zum Prüfstandsfall und das *ACHTUNG* in `pruefstand-faelle.txt` auf die heutige Erwartung kürzen. Bei [E-140](../Intern/BEFUNDE.md#e-140) *„falsche Angabe, gemessen und im Quellstand behoben, siehe [E-177](../Intern/BEFUNDE.md#e-177)“*.

### <a id="l-124.4"></a>L-124.4 — E-177: „Gregor muss nichts tun“ und „Was noch fehlt: Gregors Test“, aber kein Testplan

**Gewicht: mittel.** Dasselbe Muster wie bei [E-172](../Intern/BEFUNDE.md#e-172) (`Arbeitsweise/MEMORY.md`, CHRONIST 01.11. nachts: *„[E-172](../Intern/BEFUNDE.md#e-172) fünfmal erbeten trotz „Gregor muss nichts tun““*). (gemessen)

`Intern/BEFUNDE.md:409` Kurztext *„Es geht in Eudora nichts verloren; Gregor muss nichts tun.“*, am Ende *„**Was noch fehlt:** Gregors Test am nächsten Paket.“* Die erzeugten Zeilen übernehmen das (`Intern/WEITERMACHEN.md:88`, `CHANGELOG.md:40` *„Gregors Test am nächsten Paket.“*). `grep -c 'E-177' Intern/TESTPLAN.md` → 0. Nach [Nur der Testplan zählt](../Arbeitsweise/nur-testplan-zaehlt.md) gibt es also keinen Test, den Gregor ausführen könnte. Unter allen Einträgen mit „Gregor muss nichts tun“ ist [E-177](../Intern/BEFUNDE.md#e-177) der einzige, der zugleich Gregors Test verlangt (gemessen über `Intern/BEFUNDE.md`).

Für Gregor wäre der Test nicht klein: ein Filter mit *Notify Application* und `%6`, ein Programm, das die Datei liest, und eine per POP empfangene UTF-8-Mail (`tools/messen-e177.ps1` braucht dafür ein VBS und den POP-Prüfserver).

**Vorschlag (Hauptagent):** Entweder einen TESTPLAN-Abschnitt mit ausführbaren Schritten schreiben, oder den Prüfstand als genügend erklären und „Was noch fehlt“ auf „kommt mit dem nächsten Paket“ setzen. Welcher Test vor dem Release läuft, hat Gregor dem Hauptagenten überlassen.

### <a id="l-124.5"></a>L-124.5 — E-177: der Zweig für ausgehende Nachrichten ist im Eintrag nicht erwähnt

**Gewicht: Kleinkram.** (belegt am Quelltext; Wirkung Vermutung, ungemessen)

`Intern/BEFUNDE.md:409` *„`CFilter::SetupCommandLine` (`filtersd.cpp:2074`) setzt `IncludeHeaders=1` und schreibt über `CReadMessageDoc::SaveAs`“*. Das gilt nur für empfangene Nachrichten. `filtersd.cpp:2106-2109`:

```
if (Sum->IsComp())
{
    SetIniShort(IDS_INI_INCLUDE_HEADERS, 0);
    doc->WriteAsText( &theFile );
```

Eine ausgehende Nachricht (Filter auf *Outgoing*) geht über `CCompMessageDoc::WriteAsText` (`compmsgd.cpp:3839`) ohne Kopfzeilen, also auch ohne Zeichensatzangabe. Das ist der Fall „fehlende Angabe“, mit dem [E-177](../Intern/BEFUNDE.md#e-177) ursprünglich angelegt war. `034162bc` ändert diesen Zweig nicht, und `messen-e177.ps1` misst ihn nicht (Regel *manual* auf *In*). Vermutung: das ist harmlos, solange das Programm ohne Angabe windows-1252 annimmt. Gemessen ist es nicht.

**Vorschlag:** Den Zweig im Eintrag nennen und sagen, ob er dazugehört. Dem nächsten PRÜFER (fällig wegen `034162bc`, siehe Werkzeuge) mitgeben.

### <a id="l-124.6"></a>L-124.6 — WERKZEUGE: `messen-e177.ps1` mit altem Urteil und nur der Messung vor der Behebung

**Gewicht: Kleinkram.** (gemessen)

`tools/WERKZEUGE.md:149` *„Urteil `E177 ERGEBNIS dateien= falsche-angabe= fehlende-angabe= lebt=`. … Gemessen am 02.11.2026 an 7.2.1.130: `falsche-angabe=1`“*. Das Skript gibt seit `12d47ba5` `pop=`, `e118=` und `roh=` mit aus (`tools/messen-e177.ps1:32` und `:347`). Der Prüfstandsfall urteilt nach diesen Wegen. Die Messung nach der Behebung (`falsche-angabe=0`, `pop=passt`, am Bau aus `034162bc`) fehlt, ebenso der Grund für das Urteil je Weg (*„Zaehler ueber alle Dateien sind blind fuer den Weg“*, `tools/pruefstand-faelle.txt:321-322`). Die anderen `messen-*`-Zeilen nennen vorher und nachher (`:146` *„7.2.1.128 → `1`, Bau `9459edaa` → `3`“*).

### <a id="l-124.7"></a>L-124.7 — `12d47ba5` trägt den ganzen CHRONIST-Lauf unter einer E-177-Nachricht

**Gewicht: mittel.** Wer die Herkunft einer Lehre sucht, landet bei einem Commit, dessen Nachricht nichts davon sagt. (gemessen; Ursache Vermutung)

`git show --stat 12d47ba5`: 18 Dateien, darunter `Arbeitsweise/CHRONIST-2026-11-02.md` (81 Zeilen neu) und neun weitere Dateien unter `Arbeitsweise/`. Die Nachricht *„[E-177](../Intern/BEFUNDE.md#e-177) am Pruefstand bestaetigt …“* nennt nur Messung, `messen-e177.ps1` und Tests. `git diff 6d590b82 12d47ba5 -- Arbeitsweise` ist leer. Der Inhalt unter `Arbeitsweise/` ist also byte-gleich mit dem CHRONIST-Commit `6d590b82`, der erst danach in `0a04175a` hereingemergt wurde (Konflikt nur in `tools/TESTLAEUFE.md`). `git log -- Arbeitsweise/CHRONIST-2026-11-02.md` zeigt deshalb zwei Ursprünge.

Vermutung zur Ursache: Die CHRONIST-Dateien lagen beim Commit im Arbeitsbaum oder Index von `e177_filter_programm`, und `git add` hat sie mitgenommen ([Agenten trennen mit Worktrees](../Arbeitsweise/agenten-trennen-worktrees.md)). Dem Inhalt schadet es nicht. Die Nachricht ist aber falsch über ihren Umfang. Das ist eine Variante von *„Commit-Nachricht steht nicht im Diff“* ([gedaechtnis-ist-oeffentlich](../Arbeitsweise/gedaechtnis-ist-oeffentlich.md)).

**Vorschlag:** Nichts umschreiben, die Geschichte ist gepusht. Vor dem Commit mit `git diff --cached --stat` gegen die Nachricht prüfen. Gibt es dafür schon eine Schranke in `commit-bereit.pl`? Wenn nicht, den Fall dem CHRONIST mitgeben.

### <a id="l-124.8"></a>L-124.8 — `kein-squash-im-repo` und CHRONIST: Zeitraum der `vmware-host`-Treffer ungenau, Name der Lehre widerspricht ihrer Berichtigung

**Gewicht: Kleinkram.** (gemessen)

- `Arbeitsweise/kein-squash-im-repo.md:26` und `Arbeitsweise/CHRONIST-2026-11-02.md:39`: *„`git log origin/main -G vmware-host` [trifft] schon Commits vom 26.10. bis 30.10.“* Gemessen: 14 Treffer vom **24.10.** (`00c1c3d6`) bis 30.10., dazu `1c75f5c3` und `09c39785` vom 02.11. `-G` trifft jede geänderte Zeile mit dem allgemeinen Hostnamen der VM-Freigabe, auch Werkzeuge und Schranken, die nur nach dem Muster suchen. Ob in diesen Commits Gregors Ordnername steht, sagt die Zählung nicht (Vermutung: nicht in allen).
- `Arbeitsweise/kein-squash-im-repo.md:25` *„Die Überschrift dieser Lehre ist deshalb falsch.“* Name und Verzeichniseintrag bleiben aber *„Kein Squash im Repo“* (`Arbeitsweise/MEMORY.md:163`) und `kein-squash-im-repo` (`Arbeitsweise/README.md:147`). Die Beschreibung ist berichtigt, der Titel nicht.

Die Berichtigung selbst stimmt: `allow_squash_merge` true und `COMMIT_MESSAGES` habe ich nachgemessen (siehe [L-124.1](#l-124.1)).

### <a id="l-124.9"></a>L-124.9 — Bauzeiten und eine verschobene Zeilennummer

**Gewicht: Kleinkram.** (gemessen)

- `Intern/BEFUNDE.md:409` *„am Bau `7.2.1.130` vom 02.11.2026 08:39 aus `034162bc`“*. Titelzeile und Prüfstandsbuch nennen 08:32: `tools/TESTLAEUFE.md:718` *„[Eudora 7.2.1.130+034162bc 2026-11-02 08:32 - E177]“*, `Intern/pruefstand-buch.tsv:41` *„Eudora 7.2.1.130+034162bc 2026-11-02 08:32“*. Ebenso *„Gegenprobe mit dem alten Bau (01.11.2026 15:16)“* gegen *„2026-11-01 15:15“* (`tools/TESTLAEUFE.md:720`). Vermutung: Dateizeit gegen eingebaute Zeit. Die Titelzeile ist der Maßstab ([Version eindeutig machen](../Arbeitsweise/version-eindeutig-machen.md)).
- `Intern/BEFUNDE.md:400` ([E-195](../Intern/BEFUNDE.md#e-195)) *„`ReadMessageDoc.cpp:597`“*: Seit `034162bc` (zehn Zeilen in `SaveAs` dazu) steht `CSaveAs SA;` in `:607`. An `34ff9e92` war es `:597`.

### <a id="l-124.10"></a>L-124.10 — README „Bekannte Fehler“: E-177 fehlt, E-140 ohne Gregors Bestätigung; die Berichtszahl ist zum achten Mal veraltet

**Gewicht: Kleinkram.** (gemessen)

- [E-177](../Intern/BEFUNDE.md#e-177) ist seit dem 02.11. *wichtig* und steckt im veröffentlichten `v7.2.1.128` (der Originalcode, gemessen am Bau `955d50d4*`). `grep -c 'E-177' README.md` → 0. Der vergleichbare [E-140](../Intern/BEFUNDE.md#e-140) steht dort (`README.md:195`). Wer *Notify Application* mit `%6` nutzt, erfährt nichts von der falschen Angabe.
- `README.md:195` zu [E-140](../Intern/BEFUNDE.md#e-140): *„behoben in 7.2.1.129 (Testpaket)“*. Die Zeile zu [E-165](../Intern/BEFUNDE.md#e-165) (Vervollständigungsbox im To:-Feld) sagt *„(Testpaket, von Gregor bestätigt)“* (`:190`). [E-140](../Intern/BEFUNDE.md#e-140) ist seit dem 02.11. an beiden Fenstern bestätigt.
- `README.md:98` *„200 LEKTOR- und PRÜFER-Berichte“*: mit diesem Bericht 201 ([L-123.5](LEKTOR-123.md#l-123.5)). Werkzeugmangel 2 im CHRONIST (`Arbeitsweise/CHRONIST-2026-11-02.md:62`) ist weiter offen.

**Vorschlag:** eine Zeile zu [E-177](../Intern/BEFUNDE.md#e-177) unter „Bekannte Fehler“ (Ausweg: das Programm windows-1252 annehmen lassen; behoben im nächsten Paket). Bei [E-140](../Intern/BEFUNDE.md#e-140) „von Gregor bestätigt“ ergänzen. Die Form legt der Hauptagent fest.

## Zur Kenntnis

- **[E-178](../Intern/BEFUNDE.md#e-178)-Testplan** (`Intern/TESTPLAN.md:219-271`): Die drei Ortsangaben stimmen mit der Menüvorlage (belegt am Quelltext, nicht am Programm). *Edit the message* ist `EudoraRes.rc:7384` (`ID_EDIT_MESSAGE`, Knopf in `IDR_READMESS` `:6748`). *Edit → Text → Make Hyperlink* ist `:5520`/`:5532`/`:5582` im Hauptmenü. Der Knopf *Make hyperlink* ist `:7443`. Strg+B und Strg+I stehen in `:302`/`:315`. Der Knopf *Make hyperlink* sitzt in derselben Leiste des Nachrichtenfensters wie *Edit the message* (`IDR_READMESS` `:6773`). Eine eigene „Formatierleiste“, wie Schritt 4 sagt, gibt es in der Vorlage nicht. Der Text sagt selbst *„am laufenden Programm von mir noch nicht nachgesehen“*.
- **Daten von Gregors Rechner:** In den Nachrichten der neun Commits `34ff9e92..0a04175a` stehen nur Prüfstandspfade unter `C:\Temp` (gemessen: `git log --format=%B | grep -i 'users\|vmware\|shared\|\\\\'` → nur zwei Zeilen mit `C:\Temp\E177`). Im hinzugekommenen Text stehen `vmware-host`, `Shared Folders` und `C:\Users\` nur als Muster (CHRONIST, Lehren, `messen-e177.ps1:431`), ohne Ordnernamen. Die Prüfstandsfreigabe in `tools/TESTLAEUFE.md:715-721` zitiert Gregors Satz, ohne Pfad.
- **CHRONIST-Zeiten** (`Arbeitsweise/CHRONIST-2026-11-02.md:25`): `1c75f5c3` 07:15:06, `ed697a24` 08:08:29, `34ff9e92` 08:14:07 nachgemessen, stimmen.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): *„Kein Widerspruch gefunden.“* „Zur Kenntnis“: dieselben 18 Dateien ohne 7.2.1.130 wie in [LEKTOR-123](LEKTOR-123.md#lektor-123). Die Widersprüche aus [L-124.2](#l-124.2) und [L-124.3](#l-124.3) sieht das Werkzeug nicht, weil sie im Fließtext stehen.

`perl tools/offene-befunde.pl` (gemessen):

```
    offen laut Intern/BEFUNDE.md  50
      davon aktuell gemessen       6  (ab Nummer 125)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     28
      davon NIE gemessen          16
    in Intern/WEITERMACHEN.md     50

  50 offene Befunde, in beiden Listen gleich.
```

Gegenüber [LEKTOR-123](LEKTOR-123.md#lektor-123) ist [E-177](../Intern/BEFUNDE.md#e-177) von „nie gemessen“ zu „aktuell gemessen“ gewandert (5 → 6, 17 → 16). [E-140](../Intern/BEFUNDE.md#e-140) zählt nicht als offen.

`perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“* 231 Befunde, 113 mit Testfall. Kritisch ohne jede Prüfung: 7 ([E-122](../Intern/BEFUNDE.md#e-122) [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-133](../Intern/BEFUNDE.md#e-133) [E-39](../Intern/BEFUNDE.md#e-39)), unverändert.

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

`perl tools/rollen-faellig.pl` (gemessen): Der **PRÜFER ist fällig**: *„seit seinem Bericht (09c3978) haben sich 3 Datei(en) in seinem Bereich geaendert - Eudora71/Eudora/ReadMessageDoc.cpp, Eudora71/Tests/TestE177.cpp, Eudora71/Tests/TestMain.cpp“*. Die E-177-Behebung ist noch von keinem PRÜFER gegengelesen, wie der CHRONIST erwartet hat (`Arbeitsweise/CHRONIST-2026-11-02.md:57`).

## Was nur Gregor entscheiden kann

Nichts aus diesem Bericht. Die Frage aus [LEKTOR-123](LEKTOR-123.md#lektor-123) (wie #199 gemergt wird) hat Gregor beantwortet: *„ja, so lassen.“* ([L-124.1](#l-124.1)). Ob [E-177](../Intern/BEFUNDE.md#e-177) einen Test bei Gregor braucht ([L-124.4](#l-124.4)) und wie die README ihn führt ([L-124.10](#l-124.10)), entscheidet der Hauptagent.
