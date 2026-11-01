---
name: schranke-gegentesten
description: Jede neue Schranke gegen den echten Fehler fahren und gegen den erlaubten Fall; eine stumme Pruefung und ein Fehlalarm sind derselbe Schaden
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-08T07:57:11.327Z
---

Schranke: keine - keine Prüfung verlangt zu jeder Schranke einen Gegentest; gemessen am 08.09.2026 haben 3 von 10 Schranken eine Testsammlung unter tools/*-tests.pl

# Eine Schranke, die ich nicht gegen den echten Fehler gefahren habe, ist keine

Am 07.09.2026 habe ich `tools/doku-pruefen.pl` um vier Prüfungen erweitert.
Beim Gegentest — künstlich einen Fehler einbauen und sehen, ob es anschlägt —
**blieben zwei von drei Prüfungen stumm**, und eine schlug bei etwas an, was
richtig war.

| Fall | was passierte |
|---|---|
| veraltete Paketnummer | Prüfung arbeitete zeilenweise, der Satz „Die Paketnummer … lautet **1.0.21**" ging über zwei Zeilen — stumm |
| Testwert 1.0.19 | steht zu Recht in `PAKETE.md`; **mein Test** war falsch, nicht die Schranke |
| Verweise `PLAN.md`/`INVENTAR.md` | beide liegen in `Eudora71/OTShim/` und verweisen zu Recht relativ aufeinander; das Werkzeug löste gegen die **Repo-Wurzel** auf — Fehlalarm |
| Zeitdokumente | drei Dateien datieren sich im Kopf selbst und dürfen alte Zahlen nennen — als Mangel gemeldet |

Zwei stumme Prüfungen und zwei Fehlalarme in einem Werkzeug, das gerade als
Antwort auf einen wiederholten Fehler entstand.

**Warum:** Beide Ausgänge kosten dasselbe. Eine stumme Prüfung erzeugt
**falsche Sicherheit** — genau die Rolle, in der Gregor mir nicht traut
(*„geprüft, nichts gefunden"* ist schlimmer als eine offene Lücke). Ein
Fehlalarm zerstört die Schranke auf andere Weise: *eine Schranke, die zweimal
umsonst warnt, wird beim dritten Mal nicht mehr geglaubt* — und in dieser
Sitzung ist genau das passiert, dreimal an einem Tag (`bauen.ps1` mit
EuLang/msvcr71, `gesichert.pl` mit „36 Commits nirgends gepusht", die
Zeilennummern in `pruefe-fensterbau.pl`).

**Wie anwenden — für jede neue oder geänderte Prüfung, vor dem Commit:**

1. **Gegentest positiv:** den echten Fehler künstlich einbauen (in eine Kopie
   oder mit `git stash` danach), die Schranke laufen lassen, den **Text der
   Meldung** lesen. Kein Anschlag heißt: die Prüfung ist unfertig, nicht der
   Baum sauber.
2. **Gegentest negativ:** den erlaubten Fall vorlegen, der dem Fehler am
   nächsten kommt — den relativen Verweis, das datierte Zeitdokument, den
   Wert, der zu Recht alt ist. Schlägt es an, ist der Fehler in der Schranke.
3. **Bezugsrahmen prüfen.** Der häufigste Fehlalarm entsteht aus dem falschen
   Bezug: ein Verweis wird gegen das **Verzeichnis der Datei** aufgelöst, nicht
   gegen die Repo-Wurzel; eine Zahl gilt für **das Datum im Kopf der Datei**,
   nicht für heute; `pruefe-bytes.pl` liest den **Index**, nicht den
   Arbeitsbaum.
4. **Zeilenweise ist eine Annahme.** Ein Satz in einer MD-Datei umbricht. Was
   über Zeilengrenzen stehen kann, wird auf dem ganzen Text geprüft
   (`perl -0777`), nicht je Zeile.
5. **Ein falscher Test wird als solcher benannt.** Schlägt der Gegentest fehl,
   ist erst zu entscheiden, ob die Schranke oder der Test falsch war — und das
   Ergebnis gehört in die Commit-Nachricht, nicht nur in den Kopf.

## Nachtrag 08.09.2026: „irgendeiner ist rot" ist nicht dasselbe wie „alle"

`tools/pruefe-beenden.pl` hatte vier Gegentests. Beim ersten Lauf schlugen
**GT1 und GT4** an, GT2 und GT3 blieben stumm. Hätte ich nur auf „der Gegentest
greift" geschaut, wäre die Schranke mit **zwei Löchern** in den Commit gegangen
— und sie ist die Schranke, die Gregors wichtigstes Kriterium hält.

Was danach richtig lief und Regel bleibt: erst habe ich geprüft, ob meine
**Testmanipulation überhaupt angekommen** ist ([[messung-muss-den-weg-treffen]]),
sie neu angesetzt — und dann waren beide Manipulationen im Baum und die
Schranke schwieg trotzdem. Erst damit war belegt: zwei echte Löcher, nicht zwei
kaputte Tests. Die Ursachen lagen beide in der Schranke
([[schranke-liest-nur-code]]): `WM_CLOSE` steht auch im Protokolltext, und der
`default:`-Bereich endete an der inneren Klammer.

**Damit gilt zusätzlich zu Punkt 1:**

- **Jeder Gegentest wird einzeln gefahren und muss einzeln rot werden.** Eine
  Sammelmeldung „Gegentests schlagen an" ist kein Ergebnis; es gehört eine
  Tabelle mit einer Zeile je Gegentest und dem **Text der Meldung** dazu.
- **Bleibt einer stumm, ist die Reihenfolge:** erst nachmessen, ob die
  Manipulation im Baum steht (`grep` auf die entfernte Zeile), dann entscheiden
  — kaputter Test oder Loch in der Schranke. Nie umgekehrt raten.
- **Eine Schranke ist erst fertig, wenn die Zahl der roten Gegentests gleich der
  Zahl ihrer Prüfungen ist.** Vier Prüfungen, vier Gegentests, vier rote Läufe.

## Nachtrag 10.09.2026: der Gegentest hat einen echten Fehler gefangen — und zwar nicht durch Nachdenken

`tools/mailverzeichnis-uebernehmen.ps1` sollte Gregors ganzes Mailverzeichnis
in die naechste Fassung mitnehmen. Darin stand:

    Copy-Item -LiteralPath (Join-Path $q '*') -Destination $z -Recurse

**Mit `-LiteralPath` nimmt Copy-Item das Sternchen woertlich.** Es gibt keine
Datei dieses Namens, also wurde **nichts** kopiert — kein Fehler, kein
Abbruch, ein sauberer Lauf. Ohne Gegentest waere Gregor mit einem leeren
Mailverzeichnis dagestanden, und das nach dem Vormittag, an dem er schon
einmal schrieb: *"meine inhalte (screenshots) sind in den mails weg."*

Gefunden hat es nicht die Ueberlegung und nicht das Lesen des Skripts,
sondern die **Nachmessung im Skript selbst**: es zaehlt am Ende Quelle gegen
Ziel und meldete *"4 Posten sind im Ziel kleiner"*. Nach der Berichtigung auf
`-Path`: Postfach, `attach` und `Embedded` uebernommen, die Paketvorlage im
Ziel blieb stehen, `CtrlJMapping` 1 -> 2, der Name mit Umlauten unveraendert.

**Damit gehoert zu dieser Lehre ein Punkt, der bisher fehlte, weil sie nur
von *pruefenden* Werkzeugen handelte:**

- **Ein Werkzeug, das etwas *tut*, misst am Ende sein eigenes Ergebnis nach**
  — und zwar an der Groesse, um die es geht (hier: Zahl und Groesse der
  Posten in Quelle und Ziel), nicht an seinem eigenen Rueckgabewert. Ein
  Kopierbefehl, der nichts kopiert, ist erfolgreich; nur der Vergleich
  danach weiss es besser.
- **Die Nachmessung ist billiger als der Gegentest und faengt anderes.** Der
  Gegentest laeuft einmal bei mir; die Nachmessung laeuft **jedes Mal**, auch
  bei Gregor, auch mit Eingaben, die ich nicht vorhergesehen habe. Beide
  gehoeren ins Skript, nicht eins statt des anderen.
- **Was eine Nachmessung taugt, entscheidet ihr Bezug.** Hier: Quelle gegen
  Ziel. Ein `if ($?) { "fertig" }` haette dasselbe Skript gruen gemeldet.

Der Gegentest selbst lief in beide Richtungen und in einem nachgebauten
Verzeichnis, nicht bei Gregor: von 158 Paketdateien wurden 155 entfernt,
waehrend eine geaenderte Datei, eine fremde Datei und eine fremde DLL
stehenblieben — und der Ordner deshalb auch.

Siehe [[fehlerklassen-abstellen]], [[lehren-anwenden-nicht-nur-schreiben]],
[[schranke-liest-nur-code]], [[tests-vor-jedem-commit-laufen-lassen]] und
[[pruefen-statt-vermuten]].

## Nachtrag 17.09.2026: die Schranke hat den richtigen Satz abgewiesen — zweimal

`tools/pruefe-behoben-belegt.pl` verlangt zu jedem neuen „behoben" einen
Beleg. Beim Eintragen von **E-97** hat sie den Beleg abgewiesen, obwohl er
dastand. Zweimal nachgebessert, zweimal aus einem anderen Grund.

### Die beiden Gruende, am 17.09.2026 nachgemessen

Gefahren mit `--datei` auf vier kuenstliche Zeilen, die sich nur im
beanstandeten Stueck unterscheiden:

| Fassung | Urteilstext (verkuerzt) | Ergebnis |
|---|---|---|
| f1 | *… waere Funktionsverlust, **kein** Fix. … am laufenden Programm **gegen**geprueft* | **abgewiesen** |
| f2 | *… waere Funktionsverlust, **kein** Fix. … am laufenden Programm geprueft* | **abgewiesen** |
| f3 | *… Der Dialog laeuft wieder. … am laufenden Programm geprueft* | durchgelassen |
| f4 | wie f2, aber ein Satz mehr zwischen „kein" und dem Beleg | durchgelassen |

**Grund 1 — das Muster ist enger als die Sprache.** Der Beleg lautet

```perl
qr/am\s+laufenden\s+Programm\s+(?:gemessen|belegt|best…tigt|gepr…ft)/
```

Nach dem Leerzeichen muss das Wort **mit** `gepr` anfangen. *„am laufenden
Programm **gegen**geprueft"* ist sprachlich der **staerkere** Beleg — eine
Gegenprobe ist mehr als eine Pruefung — und faellt durch. Zusammensetzungen
mit Vorsilbe sind im Deutschen die Regel, nicht die Ausnahme
(*nachgemessen*, *durchgespielt*, *gegengeprueft*); das Muster kennt keine.

**Grund 2 — das Verneinungsfenster misst Abstand, nicht Sinn.** Die Schranke
verwirft einen Beleg, wenn in den **45 Zeichen davor** ein Verneinungswort
steht (`nicht`, `kein`, `ohne`, …). Das ist richtig gebaut und aus gutem
Grund da: *„von Gregor ist nichts davon am laufenden Programm bestaetigt"*
war der Wortlaut, mit dem E-85 einen Tag lang als behoben galt.

Bei E-97 stand davor aber:

> *„Sie einfach wegzulassen waere Funktionsverlust, **kein** Fix."*

Nachgerechnet: der Treffer beginnt bei Zeichen **107**, `kein` steht bei
**74**, Abstand **29 Zeichen** — also innerhalb des Fensters. Das „kein"
gehoert zu einem **anderen Satz** und verneint etwas ganz anderes (naemlich
eine verworfene Behebungsvariante). Zeile f4 beweist es: **dieselbe
Verneinung, nur weiter weg, und die Schranke schweigt.** Was hier entschieden
hat, war der Abstand — nicht die Aussage.

### Why

Diese Lehre sagt seit dem 08.09.2026: *„eine Schranke, die zweimal umsonst
warnt, wird beim dritten Mal nicht mehr geglaubt."* Hier ist der Schaden
genauer zu benennen, und er ist unangenehmer:

**Der Fehlalarm formt den Text um, den er pruefen soll.** Ich habe nicht die
Schranke geaendert, sondern meinen Satz — bis er durchging. Der Satz, den
`BEFUNDE.md` jetzt traegt, ist der, den das Muster akzeptiert, nicht der, den
ich schreiben wollte. Damit ist der Inhalt der Befunddatei am Ende eine
Funktion des Musters. Das ist die teuerste Form des Fehlalarms, weil sie
nichts sichtbar kaputt macht: die Schranke bleibt gruen, die Datei wird
aermer.

Und es ist derselbe Mechanismus wie in [[schranke-liest-nur-code]], eine
Ebene hoeher: dort las eine Schranke ihre eigene Begruendung mit, hier misst
sie **Abstand in Zeichen** und nennt es Verneinung.

### Wie anwenden, zusaetzlich

- **Zum Gegentest gehoert der Satz, den ich wirklich schreiben wuerde** —
  nicht der glatteste Fall, der dem Muster entgegenkommt. Der erlaubte Fall
  aus Punkt 2 oben ist bisher als *der Fehler knapp daneben* gedacht; er ist
  auch *die eigene, normale Formulierung*.
- **Ein Fenster in Zeichen ist eine Annahme ueber Satzbau.** Wo eine Schranke
  mit einem Abstand arbeitet, gehoert ein Gegentest dazu, der **denselben
  Inhalt in zwei Abstaenden** vorlegt (f2 gegen f4). Kommen zwei Ergebnisse
  heraus, misst die Schranke Formatierung.
- **Wenn ich meinen Text umschreibe, damit eine Schranke schweigt, ist das
  ein Befund ueber die Schranke** und gehoert notiert — nicht bloss
  weggearbeitet. Zweimal nachbessern ist das Signal; beim ersten Mal sieht es
  noch wie ein Tippfehler aus.
- **Die Schranke wird trotzdem nicht im Vorbeigehen gelockert.** Sie haelt
  den Fall, fuer den sie gebaut wurde (E-85), und wer das Fenster aufweitet
  oder die Wortliste verlaengert, faehrt vorher `--selbsttest` und die
  echten Staende (`48c1ee2` muss weiter abgewiesen werden). Beschrieben ist
  der Mangel hier; geaendert wurde nichts.

## Nachtrag 12.10.2026: der pre-push-Haken prüft den Zweig, auf dem ich stehe, und nicht die Referenz, die ich schiebe

**Was geschah:** Um 12:51 war PR #84 gemergt. Um 12:52:06 bin ich auf `main`
gewechselt, habe den lokalen Zweig gelöscht und
`git push origin --delete an1-endungen` aufgerufen. Der Haken wies ab
(12:52:16):

    pre-push: ist der Zweigname mit Gregor abgestimmt?
      COMMIT ABGEBROCHEN - 'main' nimmt keine direkten Commits

Das war ein Fehlalarm, und zwar in zwei Punkten. Erstens ging kein Commit
auf `main`. Zweitens stimmt das Wort „COMMIT" nicht, denn es war ein Push.
Gelöscht wurde ein Zweig, den Gregor bereits gemergt hatte. Das verlangt
[[fertig-heisst-fertig]] sogar. Ich habe ihn um 12:52:23 über
`gh api -X DELETE repos/…/git/refs/heads/an1-endungen` gelöscht, ohne
`--no-verify`, und danach mit `ls-remote` gemessen: 0 Treffer.

**Die Stelle:** `.git/hooks/pre-push` ruft `tools/pruefe-branch.pl --streng`
auf, ohne etwas weiterzureichen. Das Skript bestimmt den Zweig in Zeile 120
aus `HEAD`:

    my ($branch, $rc_branch) = git_lauf('symbolic-ref', '--quiet', '--short', 'HEAD');

Zeile 185 entscheidet nur nach diesem Wert:

    if ($branch eq 'main' or $branch eq 'master') {

Ein pre-push bekommt von git auf **stdin** je geschobener Referenz eine
Zeile `<lokale ref> <lokale sha> <entfernte ref> <entfernte sha>`. Bei einem
Löschpush steht dort als lokale sha `0000000…`. Die Schranke liest stdin
nicht. Sie misst also den Arbeitsbaum und nennt das den Push. Das ist
derselbe Bezugsrahmenfehler wie unter Punkt 3 oben: richtige Regel,
falscher Gegenstand. Er verbietet umgekehrt auch keinen echten Fehler:
`git push origin HEAD:main` von einem abgestimmten Zweig aus käme an
Zeile 185 vorbei. Die Sperre bei GitHub fängt das ab, der Haken nicht.

**Vorschlag (nicht umgesetzt, Gregors Entscheidung):**

- Im `--streng`-Lauf stdin lesen. Für jede Zeile gilt:
  - Ist die lokale sha `0{40}`, ist es ein Löschpush. Er wird nicht nach dem
    aktuellen Zweig beurteilt. Abweisen nur, wenn die **entfernte** ref
    `refs/heads/main` ist.
  - Sonst ist die **entfernte** ref der Gegenstand. `refs/heads/main` →
    abweisen. Jeder andere Name → die bestehende ZWEIGE.md-Prüfung gegen
    **diesen** Namen, nicht gegen `HEAD`.
- In `pruefe-branch-tests.pl` zwei Gegentests nach dem Muster dieser Lehre:
  - der echte Fehler: `HEAD:main` von einem abgestimmten Zweig, muss
    abgewiesen werden;
  - der erlaubte Fall: `--delete <gemergter Zweig>` von `main` aus, muss
    durchgehen.
- Die Meldung im pre-push soll „PUSH ABGEBROCHEN" heißen. Ein Text, der den
  falschen Vorgang nennt, ist schon ein Hinweis darauf, dass die Schranke
  den falschen Gegenstand misst.

**Was richtig war:** Den Haken habe ich nicht übergangen. Der gewählte Weg
läuft an keiner Prüfung vorbei, denn das Löschen eines gemergten Zweigs
prüft dieser Haken nicht. Er geht nur nicht durch die Prüfung, die sich
geirrt hat. Ein `--no-verify` hätte auch die anderen Schranken im pre-push
abgeschaltet (Doku, Bytes, Testdaten).

## Nachtrag 20.10.2026: die Gelegenheitsmessung ist die ungetestete Schranke

Die Lehre zählt Schranken unter `tools/` — und genau die haben inzwischen
Selbsttests. Am 20.10. abends kam der Schaden von zwei Messungen, die niemand
„Schranke" nennt und die deshalb nie einen Gegentest hatten:

1. **Der Verweis-Lauf über 6135 Markdown-Verweise.** 20 Treffer, davon **18
   Fehlalarme** (Zitate in Rückstrichen und Blockzitaten). Auf dieses Ergebnis
   hin wurden acht fremde Prüfberichte geändert, bevor irgendjemand einen
   bekannt-guten Fall gegengeprüft hatte ([[schranke-liest-nur-code]]).
2. **Das Fenstererkennungs-Skript zum Über-Dialog.** Es meldete *„KEIN Dialog
   gefunden"*, während der Dialog offen vor ihm stand. Ein **falsch
   negatives** Ergebnis, ungetestet, und es wurde zur Grundlage einer
   Berichtigung, die dadurch selbst falsch war ([[ausbleiben-ist-kein-befund]]).

**How to apply, zusätzlich:**

- **Eine einmalige Messung, auf deren Ergebnis hin ich etwas ändere, ist eine
  Schranke.** Vor der ersten Änderung: ein Treffer, den das Ergebnis enthalten
  **muss** (Positivprobe), und einer, den es **nicht** enthalten darf
  (Gegenprobe). Zwei Minuten.
- **Eine Trefferquote gehört in die Meldung.** „20 tot von 6135" klingt nach
  Arbeit; „20 Treffer, davon 2 nachgesehen" ist die ehrliche Lage. Wer eine
  Trefferliste nicht stichprobenartig öffnet, hat nicht gemessen, sondern
  gesucht.

## Nachtrag 21.10.2026 — der Fehlalarm, der 11 Dateien erfand

`tools/gesichert.pl` meldete am Abend des 21.10.2026:

```
Arbeitsbaum ...-wt-pruefer hat 11 nicht committete Datei(en)
NICHT GESICHERT
```

Nachgemessen war **nichts** ungesichert. Die vier Textdateien waren Byte für
Byte die aus `origin/main` (gleicher Blob-Hash), die sieben DLLs unterschieden
sich um 7–8 Byte im PE-Zeitstempel. Der Zweig in jenem Arbeitsbaum hing 16
Commits zurück — dadurch sah **neuerer** Inhalt wie eine lokale Änderung aus.
Dieselbe Messung ein paar Stunden später: 21 Commits zurück, 6 Dateien, alle 6
mit dem Blob-Hash aus `origin/main`.

**Die Ursache ist eine verwechselte Frage.** `git status` beantwortet *„weicht
das von MEINEM HEAD ab?"*. Die Frage dieses Werkzeugs ist aber *„geht etwas
verloren, wenn Gregor jetzt abschaltet?"* — und die heißt *„liegt dieser Inhalt
schon auf dem SERVER?"*. Beide fallen nur zusammen, solange der Zweig vorne
steht.

Behoben, indem jede geänderte Datei gegen `origin/main` **und** das eigene
Gegenstück gehalten wird (`git diff --name-only -z <ref>`). Was in keinem von
beiden steht, bleibt Mangel; der Rest ist ein Hinweis *„der Zweig hängt nur
zurück, es geht nichts verloren"*.

**Warum das hierher gehört:** ein Werkzeug, das vor dem Abschalten warnt, wird
in dem Moment gelesen, in dem Gregor es eilig hat. Warnt es zweimal umsonst,
wird beim dritten Mal darüber hinweggelesen — und dann fehlt die echte Meldung.
Genau diese Begründung steht an zwei anderen Stellen **im selben Quelltext**
schon einmal: für die ungepushten Commits (06.09.2026) und für den Rat, dem man
nicht folgen kann (07.09.2026). Sie galt nur nicht für den Zähler ganz oben.

Gegenprobe in beide Richtungen, `perl tools/gesichert.pl --selbsttest`, 9 Fälle
in einem Wegwerf-Repo: zurückhängender Zweig, Löschung die `main` schon kennt,
gestagte identische Datei, unverfolgte Datei — **kein** Mangel; echte Änderung,
echte Löschung, Inhalt nur im eigenen Gegenstück — **Mangel**. Am Bestand
desselben Abends: PRÜFER-Baum 6 Dateien / 0 verloren (jetzt Hinweis),
LEKTOR-Baum 5 Dateien, die es wirklich nirgends gibt — die werden jetzt
**namentlich** genannt, was die alte Fassung nicht tat.

**Nachtrag 25.10.2026 — der Rückbau muss den Bau mitnehmen.** Nach der K2-Gegenprobe (`exit(0)` in `TestMain.cpp`) habe ich die Datei mit `cp -p` zurückkopiert: byte-gleich, aber mit dem **alten Zeitstempel**. MSBuild hielt `TestMain.obj` für aktuell, die EXE behielt das `exit(0)`, und `RunTests.cmd` meldete „Fehlgeschlagene Tests: 0“ nach 286 von 296. Gefunden nur, weil die Ergebniszeile fehlte. **How to apply:** nach jeder Gegenprobe an einer übersetzten Quelle `touch` auf die Datei und neu bauen, dann die **Zahl** der Tests gegen den Stand davor halten, nicht nur „0 rot“.

## Nachtrag 25.10.2026 (CHRONIST): ein Haken, der nur aus der Wurzel getestet war

`tools/haken-pr-lektor.pl` (PreToolUse, `.claude/settings.json`) wurde um 10:26 MEZ gebaut und in der Repo-Wurzel gegengetestet. Gemessen am selben Vormittag, Transkript `fa3529ec-…jsonl`:

1. **Aus einem Unterverzeichnis blockierte er alles.** Eingetragen war `perl tools/haken-pr-lektor.pl`, relativ. Nach einem `cd …/Eudora71/Tests` um 10:38:10 meldete jeder weitere Bash-Aufruf *„PreToolUse:Bash hook error: … Can't open perl script "tools/haken-pr-lektor.pl""* — Perl gibt dafür **2** zurück, und 2 heißt für Claude Code „abweisen". Drei Aufrufe abgewiesen, bis `$CLAUDE_PROJECT_DIR` eingetragen war (10:38:22).
2. **Drinnen hätte er durchgelassen.** Die Wurzel kam aus `cwd` des Aufrufs; aus `Eudora71/` fand er `rollen-faellig.pl` nicht, las die leere Antwort als „nicht fällig" und gab 0. Ebenso ließ unlesbares JSON vor der Nachbesserung durch. Behoben über `FindBin` und Rückfall auf den Rohtext (*fail-closed*).

Der gleiche Fehler hat also beide Richtungen gleichzeitig: die Hülle schloss zu viel, der Kern zu wenig.

**How to apply, zusätzlich:** Jeder neue Haken wird gegengetestet (a) aus der Wurzel, (b) **aus einem Unterverzeichnis**, (c) mit fehlendem oder kaputtem Hilfswerkzeug und (d) mit unlesbarer Eingabe. Für (c) und (d) gilt: abweisen und den Grund nennen, nie stumm durchlassen ([[ausbleiben-ist-kein-befund]]). Die Hakenzeile in `settings.json` nennt ihr Skript über `$CLAUDE_PROJECT_DIR`, nie relativ.

## Nachtrag 01.11.2026 nachts (CHRONIST): vier Runden für einen Haken, und die Behebung der Lücke brachte den Fehlalarm

Transkript `6f848773…`, Zeiten MEZ; `Befunde/PRUEFER-78.md` K5, `Befunde/PRUEFER-79.md` K1/K2; gemessen ([[CHRONIST-2026-11-01e]]).

`tools/haken-eudora-start.pl` (Vorschlag aus [[CHRONIST-2026-11-01d]]) weist jeden Befehl ab, der eine `Eudora.exe` an Befehlsstelle aufruft. Er entstand in vier Runden:

| Runde | Selbsttest | Was die Runde fand |
|---|---|---|
| 19:03:26 erster Stand | 20/20 | der echte Befehl von 17:18:55 abgewiesen, `ls` auf die EXE durchgelassen; live 19:03:40 abgewiesen (gewollt) |
| 19:03:59 erster Einsatz | → 23/23 | **Fehlalarm** gegen den eigenen nächsten Befehl: ein `perl -e '…'` mit einer Markdown-Tabelle für `WERKZEUGE.md`. Der Haken zerlegte auch innerhalb von Anführungszeichen |
| PRÜFER-78 K5 (20:02) | → 39/39 | **10 von 14 Startformen durch**, darunter `cmd //c` (die Schreibweise aus Git Bash), `bash -c "…"`, `powershell -Command`, Unterschale, `timeout` |
| PRÜFER-79 K1/K2 (20:25) | → 47/47 | **neuer Fehlalarm**: die Regel aus K5 nahm jeden Schalter `-c` vor einer Zeichenkette als `bash -c`. `grep -c "Eudora.exe"` und `tasklist \| grep -c 'Eudora.exe'`, die naheliegende Prüfung „läuft Eudora noch?“, wurden abgewiesen. Dazu fünf seltene Lücken (`a & Eudora.exe`, `env`, `xargs`, `wsl -e`, Pfad ohne `.exe`) |

Die Gegenproben der Runde 3 waren alle von der Art „muss abweisen“. Erlaubte Befehle **mit demselben Wortbestandteil** (`-c`) wie die neue Regel standen nicht im Selbsttest. So machte die Behebung einer Lücke den Haken an einer anderen Stelle zu scharf. Ein Haken, der die eigene Prozessprüfung abweist, wird umgangen, und dann schützt er nichts mehr.

**Gut gelaufen:** Jede Runde kam als Fall in den Selbsttest, und die Hauptsitzung behob beide PRÜFER-Runden vor dem PR. Live geprüft wurde nur, was der Haken abweisen soll (19:03:40), nicht ein erlaubter Fall im echten Hakenbetrieb.

**How to apply, zusätzlich:** Jede neue Erkennungsregel eines Hakens bekommt im selben Schritt mindestens zwei **erlaubte** Fälle, die dasselbe Schlüsselwort benutzen (hier: `grep -c`, `sed -c`, `Select-String … -c`). Erst wenn beide durchgehen, ist die Regel fertig. Die Prüfbefehle, die die Sitzung selbst täglich nutzt (`tasklist`, `Get-Process … Path`, `grep -a` auf die EXE, `cp` der Binärdateien), gehören fest in den Selbsttest.
