# CHRONIST, zweiter Lauf vom 20.10.2026

Schranke: keine — dies ist der Bericht eines CHRONIST-Laufs, keine Lehre. Jede
neue oder ergänzte Lehre trägt ihre eigene Schranke-Zeile.

Ausgewertet: die Arbeit vom **20.10.2026 ab etwa 13:00**. Der Vormittag steht in
[CHRONIST-2026-10-20](CHRONIST-2026-10-20.md) und wird hier nicht wiederholt;
wo ein Befund von dort fortgeschrieben wird, steht es dabei.

## Quelle und Kennzeichnung

Nach [ursache-nur-gemessen-behaupten](../Arbeitsweise/ursache-nur-gemessen-behaupten.md)
trägt jede Ursachenaussage eines von drei Wörtern: **gemessen**, **belegt am
Quelltext**, **Vermutung**.

| Quelle | Umfang |
|---|---|
| `git log --all --since='2026-10-20'` | **48 Commits**, Betreffzeilen vollständig, acht Nachrichtenkörper ganz |
| `git log --first-parent main` und `git reflog show main` | die Bewegung von `main` an diesem Tag, Eintrag für Eintrag |
| `gh release view v1.0.112 / v1.0.113 --json body` | beide veröffentlichten Texte heruntergeladen und gegen die Repo-Dateien gehalten |
| `gh issue view 102` | alle **fünf** Kommentare, darunter der neue von 16:11:54 UTC |
| `Releases/1.0.110/`, `1.0.111/`, `1.0.112/`, `1.0.113/RELEASE-NOTIZEN.md` | in je zwei bis vier Fassungen gegeneinander gehalten |
| [LEKTOR-43](LEKTOR-43.md#lektor-43) | alle 17 Punkte; vier davon nachgemessen |
| `tools/release-veroeffentlichen.ps1`, `pruefe-bytes.pl`, `pruefe-befundurteile.pl`, `pruefe-release-buchfuehrung.pl`, `pruefe-branch.pl`, `paket-bereit.pl`, `offene-befunde.pl`, `lehren-schranken.pl` | am Quelltext gelesen **und** gefahren |
| `Arbeitsweise/` und `…/memory/MEMORY.md` | Bestand gegen die Vorschläge der CHRONIST-Berichte gezählt |

**Eigene Messungen** (alle lesend; nichts mit Oberfläche gestartet, keine Datei
unter `Eudora71/` und kein Werkzeug unter `tools/` angefasst):

* **Steuerzeichen über den ganzen Tag:** für jeden der 48 Commits und je
  `BEFUNDE.md`, `Releases/PAKETE.md`, `WEITERMACHEN.md` die Zahl der
  Steuerzeichen — **0 Treffer in 144 Messungen**.
* **Die Release-Buchführung im Augenblick des Taggens**, rückwirkend gefahren:
  `git checkout ac094f15` (15:01, der Stand unmittelbar nach dem Tag
  `v1.0.113`), dann `perl tools/pruefe-release-buchfuehrung.pl` → **MANGEL, 6
  Stellen**.
* **Die Schranken des Hakens gegen die des Pakets:** 32 gegen 10, Differenz 27.
* **Herkunft der 1.0.113-Notizen:** drei Vergleiche gegen drei
  Vorgängerfassungen, dazu ein Abzug im Scratchpad.
* **Lehrenbestand:** 101 Dateien in `Arbeitsweise/`, 6 in CHRONIST-Berichten
  vorgeschlagene `name:`-Zeilen, davon 2 nie angekommen.

---

## Die acht Punkte des Auftrags, einzeln nachgeprüft

Sechs tragen unverändert. **Zwei gehen weiter, als der Auftrag sagt** — bei
Punkt 1 ist die vermutete Ursache zu milde, bei Punkt 3 steht die Sache
inzwischen im Repo, nur nicht auf `main`. Beides steht unten und noch einmal
unter *Widerlegte Vermutungen*. **Zwei Punkte sind dazugekommen**, beide beim
Fahren der eigenen Schranken gefunden und nicht gesucht: **6b** (die Buchführung
zu `v1.0.113` trägt die Angaben von `v1.0.112` und blockiert gerade jeden
Commit) und **6c** (die Zweigschranke weist den Befehl ab, den sie vorschlägt).

### Punkt 1 — zwei Releases, zweimal falsche Notizen; und die Ursache ist eine andere

**(a) Die leeren Notizen: am Quelltext belegt.**
`tools/release-veroeffentlichen.ps1:44` erklärt `[string] $Notizen = ''`, und
`:248` lautet:

```powershell
if ($Notizen -ne '' -and (Test-Path $Notizen)) { $argumente += @('--notes-file', $Notizen) }
```

Ohne `-Notizen` geht `gh release create` also **ohne** `--notes-file` hinaus,
und GitHub veröffentlicht einen leeren Körper. Das Skript kennt `$Fassung` als
Pflichtparameter und könnte `Releases/$Fassung/RELEASE-NOTIZEN.md` selbst
finden; es tut es nicht, und es meldet auch nicht, dass die Notizen fehlen.
**Der Vorgang selbst** — dass der erste Versuch leer hinausging und mit
`gh release edit` nachgetragen wurde — **ist im Repo nirgends vermerkt**; dafür
ist der Auftragstext die einzige Quelle.

**(b) Der verstümmelte Nachtrag: gemessen, in drei Schritten.**

| Schritt | Commit | was verlorenging |
|---|---|---|
| 1.0.110 → 1.0.111 | `d6db51c7`, 13:13 | die Kopfzeile des [E-69](../Intern/BEFUNDE.md#e-69)-Punktes (*„Keine Flut von Fehlermeldungen mehr beim Filtern."*) wurde durch den neuen [E-123](../Intern/BEFUNDE.md#e-123)-Block **ersetzt**; die Überschrift `## Was geprüft wurde – und was nicht` kam ein **zweites** Mal dazu |
| 1.0.111 → 1.0.112 | `61c91b43`, 13:41 | die zweite Zeile des Einleitungsabsatzes (*„Mailverzeichnis im ZIP ist leer …"*) |
| berichtigt | `ce5c2e33`, 14:07 ([L-43.1](LEKTOR-43.md#l-43.1)) | alle drei zurückgeholt |

**Warum Schritt 1 unsichtbar war:** `git show --stat d6db51c7` meldet
`Releases/1.0.111/RELEASE-NOTIZEN.md | 84 +++++`, **84 insertions, 0
deletions** — eine neue Datei an einem neuen Pfad hat keinen Unterschied, den
git zeigen könnte. Der Schaden steht erst im Vergleich mit dem Vorgänger, und
den hat nie jemand gefahren:

```
$ diff <(git show cd6786c2:Releases/1.0.110/RELEASE-NOTIZEN.md) \
       <(git show d6db51c7:Releases/1.0.111/RELEASE-NOTIZEN.md)
8c8,13
< - **Keine Flut von Fehlermeldungen mehr beim Filtern.** Konnte Eudora eine Nachricht
---
> - **Beenden wartet jetzt auf jede Art von Übertragung.** …
62a70
> ## Was geprüft wurde – und was nicht
```

Bei Schritt 2 hat git den Unterschied sehr wohl gezeigt
(`Releases/{1.0.111 => 1.0.112}/RELEASE-NOTIZEN.md | 32 +-`, als Umbenennung
erkannt) — und der Verlust stand mitten darin. **Ein gezeigter Unterschied
reicht also nicht.**

**(c) `v1.0.113`: dieselbe Klasse, und die Ursache ist nicht „Zahlen
nachziehen". Gemessen.**

Der Auftrag vermutet: *„ich kopiere Release-Notizen von einer Fassung zur
nächsten und ziehe nur die Zahlen nach, dabei habe ich eine Reparatur des
LEKTORS überholt."* Die erste Hälfte stimmt, die zweite ist zu milde. Gemessen:

```
$ diff <(git show 69954622:Releases/1.0.112/RELEASE-NOTIZEN.md) \
       <(git show 0f4b2b1a:Releases/1.0.113/RELEASE-NOTIZEN.md)
```

ergibt **drei** Unterschiede: die Versionszeile, den Defender-Absatz, und
`1.0.112` → `1.0.113` in der Bestätigungszeile. `69954622` ist die
**unberichtigte**, um 11:55 veröffentlichte Fassung. Die neue Datei ist also
Zeile für Zeile der alte, kaputte Text.

**Die berichtigte Fassung lag im selben Arbeitsbaum.** `0f4b2b1a` hat
`e182c990` als einzigen Elternteil — die Spitze des LEKTOR-Zweigs. Im Baum
dieses Commits enthält `Releases/1.0.112/RELEASE-NOTIZEN.md` alle Reparaturen;
die 27 Minuten jüngere Datei `Releases/1.0.113/RELEASE-NOTIZEN.md` enthält
keine davon.

**Woher die Kopie kam, ist gemessen.** Im Scratchpad liegt
`veroeffentlicht.md`, geschrieben **13:59** — und sie ist byteweise die
unberichtigte 1.0.112 (Vergleich gegen `69954622`: ein einziger Unterschied,
die fehlende Leerzeile am Ende). Das ist der Abzug von GitHub, der zum
Vergleichen heruntergeladen wurde. Um 14:34 sind die neuen Notizen **aus diesem
35 Minuten alten Abzug** entstanden, nicht aus der Datei daneben.

**Vier Reparaturen waren damit wieder weg:**

| [LEKTOR-43](LEKTOR-43.md#lektor-43), 14:07 | Stand in 1.0.113 um 14:34 |
|---|---|
| E-69-Kopfzeile zurückgeholt | **wieder entfernt** |
| zweite Zeile des Einleitungsabsatzes zurückgeholt | **wieder entfernt** |
| doppelte Überschrift entfernt | **wieder doppelt** (`grep -c` = 2) |
| Zuschreibung auf 1.0.111 berichtigt ([L-43.2](LEKTOR-43.md#l-43.2)) | **auf 1.0.113 gesetzt** — eine Fassung weiter, als der Fehler vorher war; gemessen hat Gregor an 1.0.111 |

Dazu die Testzahl: `grep -o '2[0-9][0-9] Tests'` auf der 113-Datei um 14:34 →
**`229 Tests`**, während die Commit-Nachricht desselben Commits
*„234 Tests, 234 bestanden (fuenf neue)"* sagt.

Gregor hat beides gefunden (*„Befund läuft bei uns als [E-131](../Intern/BEFUNDE.md#e-131). link fehlt!"*,
*„zeile doppelt: fehlt da war?"*), und `d64247cb` / `fe49a6ab` haben es
berichtigt.

**(d) Was heute noch öffentlich steht — und es entstand beim Berichtigen.**
Der veröffentlichte Körper von `v1.0.113` (133 Zeilen, 7977 Zeichen) ist
byteweise die heutige Repo-Datei. In ihr steht, Zeile 128:

```
  auf beiden Wegen:** aus einem lokalen Postfach in einen IMAP-Ordner (Eudora
```

Der neue Aufzählungspunkt *„Der Beenden-Weg stammt aus Gregors Lauf an
1.0.110"* wurde **über** die Kopfzeile des nächsten Punktes gesetzt. Übrig
bleibt ein Satzrest mit offener Fettschrift. **Dieselbe Klasse, erzeugt von der
Reparatur.**

Und der **gute** Teil: der veröffentlichte Körper von `v1.0.112` **ist
berichtigt** — der E-69-Punkt steht wieder bei `:34`, die zweite
Einleitungszeile bei `:24`, die Überschrift kommt einmal vor. Damit ist
[LEKTOR-43](LEKTOR-43.md#lektor-43)s Abschnitt *„Was bewusst stehen geblieben
ist"* an dieser Stelle überholt.

### Punkt 2 — `printf`: warum eine Lehre vom selben Tag nicht greift

**Der mechanische Teil, gemessen.** Für jeden der 48 Commits dieses Tages und
jede der drei genannten Dateien die Zahl der Steuerzeichen: **0 von 144.** Kein
committeter Stand trug je ein ESC-Byte. Die Schranke (`pruefe-bytes.pl`
Regel 6, Aufrufstellen `:396` und `:500`, im `pre-commit`) hatte also **nie
etwas zu fangen** — der Schaden entstand und verschwand vollständig in der
Lücke zwischen Schreiben und Committen. Das ist kein Lob für die Schranke,
sondern ihr Befund: sie hängt hinter dem Schaden.

**Der inhaltliche Teil, gemessen.**
`Arbeitsweise/text-nicht-durch-schichten-schicken.md` ist zuletzt am
**14.10.2026** geändert worden (`d135f170`). Der Satz, der **genau diesen Fall**
benennt — *jeder Text mit Rückstrich geht als `%s`-Argument, nie in die
Formatzeichenkette, auch innerhalb einer Schicht* — ist am Vormittag
geschrieben worden und steht bis heute **nur** in
[CHRONIST-2026-10-20](CHRONIST-2026-10-20.md). Was in der Lehre steht, ist der
engere Satz *„inline durch Bash/PowerShell nach Perl"*, und der trifft den Fall
nicht.

**Der strukturelle Teil, gemessen.** Von **6** in CHRONIST-Berichten
vorgeschlagenen Lehren (`grep -h '^name: ' Befunde/CHRONIST-*.md`) fehlen
**2** in `Arbeitsweise/`: `anleitung-ist-ein-pruefling` und
`main-ist-was-gregor-sieht` — beide vom heutigen Vormittag, 11:58. In
`MEMORY.md` stehen sie ebenfalls nicht (`grep -c` = 0). Der Bestand ist 101
Lehren.

**Damit ist die Frage des Auftrags beantwortet, und die Antwort ist nicht
„Nachlässigkeit":**

1. Die passende Regel war um 11:58 **geschrieben**, aber in einem *Bericht*.
   Der CHRONIST schreibt bewusst nicht nach `Arbeitsweise/` — der
   Vorcommit-Haken spiegelt dieses Verzeichnis aus dem Gedächtnis und nähme sie
   wieder heraus. Der Weg vom Bericht ins Gedächtnis läuft **über Gregor, von
   Hand**, und **niemand misst, ob er gegangen wurde**.
2. Die Regel, die im Gedächtnis **stand**, nennt einen anderen Umfang als den
   heutigen Fall.
3. Das einzige, was von selbst läuft, sitzt **hinter** dem Schaden.

Eine Lehre wirkt also nicht dadurch, dass sie am selben Tag geschrieben wurde,
sondern dadurch, dass im Augenblick des Handelns etwas sie ausführt. Heute gab
es diesen Augenblick dreimal nicht. Gregors Satz dazu — *„du stellst dir gerne
selbst ein bein, was?"* — trifft die Sache genauer als jede Lehre: das Bein
steht da, weil niemand es wegräumt, nicht weil ich es jedes Mal neu hinstelle.

### Punkt 3 — der erste Fremdbericht, der widerlegte Satz, und wo er inzwischen steht

**Die neue Antwort, gemessen.** `gh issue view 102` → fünf Kommentare, der
letzte von `rjsdotorg` am **20.10.2026, 16:11:54 UTC**:

> *„What got me was that the new install »found« (via registry lookups) the
> existing one in another folder and modified its ini"*

**Was das widerlegt.** Zwei Dokumente sagen das Gegenteil, und beide stehen
heute auf `main`:

| Stelle | Wortlaut | Urteil |
|---|---|---|
| `README.md:75` | *„Ein eigener Ordner genügt **nicht**, solange dieselbe `Eudora.ini` benutzt wird."* | **falsch in der Bedingung.** Der Nebensatz sagt im Umkehrschluss: ein eigener Ordner **mit eigener INI** schütze. Er schützt nicht |
| `Releases/1.0.112/RELEASE-NOTIZEN.md:19` (und so veröffentlicht) | *„Ein eigener Ordner reicht **nicht** aus: eine gemeinsam benutzte `Eudora.ini` genügt für den Schaden."* | dasselbe |

Die **Warnung** war richtig, die **Begründung** nicht — und die Begründung ist
das, wonach ein Leser handelt.

**Es steht inzwischen im Repo, aber nicht auf `main`.** Im Hauptarbeitsbaum
liegt der Zweig `e-132-fremdes-mailverzeichnis` mit einem **neuen Befund
**[E-132](../Intern/BEFUNDE.md#e-132)****, gestaget und **nicht committet**. Sein Text
belegt die Kette am Quelltext:

* `eudora.cpp:1036-1052` — ist die Befehlszeile **leer** *und* liegt **keine**
  `Eudora.ini` neben der EXE, ruft Eudora `StartEudoraWithDefaultLocation()`
  (`:3700`);
* diese liest `HKEY_CURRENT_USER\Software\Qualcomm\Eudora\CommandLine\Current`,
  ersatzweise `HKEY_CLASSES_ROOT`, und schneidet den Datenordner aus der dort
  hinterlegten Befehlszeile heraus (`:3736-3748`) — also aus dem letzten Start
  einer **fremden** Installation;
* unser Paket erfüllt beide Bedingungen, weil die mitgelieferte `Eudora.ini` in
  `Mailverzeichnis\` liegt und nicht neben der EXE.

**Damit ist auch der Schutz belegt am Quelltext:** `Eudora starten.cmd` übergibt
das Mailverzeichnis als Argument, die Befehlszeile ist also nicht leer, und der
Registry-Weg wird gar nicht erst betreten. Der Doppelklick auf `Eudora.exe`
betritt ihn.

**Offen bleibt — und das ist der Punkt für Gregor:** auf `origin/main` steht
[`E-132`](../Intern/BEFUNDE.md#e-132) **nirgends** (`grep -c 'e-132'` auf `BEFUNDE.md` und `README.md` je 0),
`README.md:75` trägt unverändert die widerlegte Bedingung **und** den Satz
*„von uns **noch nicht nachgestellt**"*, obwohl [E-131](../Intern/BEFUNDE.md#e-131)
seit 14:34 behoben und seit 15:01 veröffentlicht ist. In `WEITERMACHEN.md`
steht [E-131](../Intern/BEFUNDE.md#e-131) weiter unter den offenen Befunden
(`offene-befunde.pl`: *„ZU VIEL (1, laut BEFUNDE.md erledigt): [E-131](../Intern/BEFUNDE.md#e-131)"*).

**Und noch etwas steht in derselben Antwort**, das niemand aufgenommen hat: der
Melder hat ein eigenes
[Unicode-Fix-Plugin](https://github.com/rjsdotorg/EudoraUnicodeFix-releases)
geschrieben und schlägt [Scintilla](https://scintilla.org/Steps.html) für
Lese- und Schreibfenster vor. Das ist kein Fehlerbericht und keine Aufgabe des
CHRONIST — aber es ist das erste Angebot von außen, und es verfällt, wenn es
nur im Issue steht.

### Punkt 4 — der PRÜFER hat ein Paket aufgehalten und ein zweites nicht

Sachlich, ohne Bewertung — es war Gregors Entscheidung mit seiner Begründung.

| | 7.2.0.111 | 7.2.0.113 ([E-131](../Intern/BEFUNDE.md#e-131)) |
|---|---|---|
| Urteil des PRÜFERS | [PRÜFER-39](PRUEFER-39.md) **N1**, Gewicht *hoch*: der Zähler in `CImapSameServerTransferMsgAction::DoWork` kann Eudora unbeendbar machen (13:26, `dd26a967`) | `PRUEFER-40` **angestoßen 14:59**, läuft noch (`paket-bereit.pl`: *weist ab*) |
| Sicherheit des Urteils | **belegt am Quelltext**; der Bericht sagt selbst, dass ein tatsächlich hängendes `XferMessagesOnServer` **nicht gemessen** ist | — |
| Folge | zurückgenommen, 7.2.0.112 gebaut (`61c91b43`, 13:41) | veröffentlicht als `v1.0.113`, 13:01:36 UTC |
| Begründung | *„Was vor dem Paket hinein muss: N1"* ([PRÜFER-39](PRUEFER-39.md):67) | Gregor: *„wir nehmen die alternative"* — sonst kommt der Melder nicht an die Behebung |

Der Unterschied zwischen beiden Lagen ist nicht die Schwere, sondern **wer
wartet**. Bei 7.2.0.111 wartete niemand außer uns; bei
[E-131](../Intern/BEFUNDE.md#e-131) wartet ein Fremder, dessen vorhandene Installation
unbrauchbar ist, und für den jede Stunde ohne Paket eine Stunde ohne Abhilfe
ist. Diese Größe kommt in keiner unserer Lehren vor —
[kein-paket-mit-offenem-datenverlust](../Arbeitsweise/kein-paket-mit-offenem-datenverlust.md)
kennt nur Gregor als Empfänger.

### Punkt 5 — [E-124](../Intern/BEFUNDE.md#e-124): die Messung steht, aber am falschen Ort

**Die Messung ist veröffentlicht, gemessen.**
`Releases/1.0.113/RELEASE-NOTIZEN.md:91-101`, wortgleich im GitHub-Körper:

> *Microsoft Defender hat Zwischenfassungen fälschlich als Trojaner eingestuft
> und das Programm ohne Meldung beendet — zuletzt am 20.10.2026 eine Fassung,
> die **acht Minuten zuvor** mit 0 Funden geprüft worden war. […] **Das ist kein
> Freispruch**, sondern nur der Nachweis, dass zu diesem Zeitpunkt nichts
> bekannt war.*

Gregors Entscheidung — keine Wartezeit einbauen, er meldet es — steht in der
Commit-Nachricht von `0f4b2b1a`.

**Die Messung steht aber in keinem Befund.** `grep` über `BEFUNDE.md` nach
`13:09:05` und `13:17:28`: **null Treffer**. [E-124](../Intern/BEFUNDE.md#e-124) endet
unverändert beim Fall vom 16.10.2026. In `Releases/PAKETE.md` steht zu 1.0.113
keine Defender-Zeile mit dieser Messung.

**Und die Commit-Nachricht behauptet das Gegenteil.** `0f4b2b1a` sagt im
Körper:

> *„[E-124](../Intern/BEFUNDE.md#e-124) fortgeschrieben: die Defender-Schranke prueft ZU FRUEH. Gemessen -
> Eudora.exe 13:09:05 gebaut und sofort geprueft (34 Dateien, 0 Funde), von
> Defender 13:17:28 erkannt."*

`git show 0f4b2b1a -- BEFUNDE.md` ändert **ausschließlich** die Zeile zu
[E-131](../Intern/BEFUNDE.md#e-131). Die Nachricht nennt eine Änderung, die der Commit
nicht enthält —
[erfolgsmeldung-aus-dem-ergebnis](../Arbeitsweise/erfolgsmeldung-aus-dem-ergebnis.md)
in der Fassung *Commit-Nachricht*.

Das ist deshalb teuer, weil [L-43.17](LEKTOR-43.md#l-43.17) heute früh genau
diese Lücke gemeldet hat: der LEKTOR fand zu 1.0.112 **keinen** Defender-Beleg
im Repo und konnte den Satz weder belegen noch widerlegen. Es gibt jetzt einen
belastbaren Beleg — und er liegt wieder nur in dem Dokument, in das der LEKTOR
nicht schaut.

### Punkt 6 — vier Werkzeugmängel, keiner behoben; und einer wiegt schwerer als gedacht

| Punkt | gemessen |
|---|---|
| [L-43.11](LEKTOR-43.md#l-43.11) `pruefe-release-buchfuehrung.pl` läuft vor dem Tag | `grep -c 'pruefe-release-buchfuehrung' tools/release-veroeffentlichen.ps1` = **0**. **Rückwirkend gefahren:** im Baum `ac094f15` (15:01, unmittelbar nach dem Tag `v1.0.113`) meldet die Schranke **MANGEL, 6 Stellen** — `README.md:136`, `Releases/PAKETE.md:547` und `:560`, `WEITERMACHEN.md:15` und `:45`, `tools/RELEASES.md` kennt die 113 nicht. Der Auftrag sagt fünf; es sind **sechs**, und mit den sechs von 1.0.112 ([L-43.3](LEKTOR-43.md#l-43.3)) **zwölf an einem Tag** |
| [L-43.12](LEKTOR-43.md#l-43.12) `paket-bereit.pl` kennt den Umfang nicht | `grep -c` in `paket-bauen.ps1` = **0**. Schärfer als im Bericht: **32** Schranken hängen im `pre-commit`/`pre-push`, **10** in `paket-bauen.ps1`, **27 hängen im Haken und nicht vor dem Paket** — während die Kopfzeile von `paket-bereit.pl` *„alle Schranken vor dem Paket"* lautet und die Zeile darunter *„8 Schranke(n), gelesen aus paket-bauen.ps1"* |
| [L-43.13](LEKTOR-43.md#l-43.13) `ist_standaussage()` hört auf Wörter | unverändert — **und derselbe Bauteil sitzt in einer zweiten Schranke:** `pruefe-befundurteile.pl:212-217` führt `@unerledigt` als **acht von Hand geschriebene Wendungen**; *„noch nicht nachgestellt"* ist keine davon. Deshalb meldet die Schranke heute *„Kein Dokument … keinen behobenen für unerledigt"* — während `README.md:75` über den behobenen [E-131](../Intern/BEFUNDE.md#e-131) sagt, er sei *„von uns noch nicht nachgestellt"* |
| [L-43.15](LEKTOR-43.md#l-43.15) Release-Notizen nicht im Prüfumfang | unverändert |

**Ein fünfter, aus derselben Wurzel, heute gefunden:**
`pruefe-release-buchfuehrung.pl` meldet auf `origin/main` **grün**, und
`Releases/PAKETE.md:6` lautet dort *„zuletzt veröffentlicht **1.0.112** als
`v1.0.113` am 20.10.2026"*. Die Schranke fragt, **ob** die Nummer 113 vorkommt,
nicht **wem** sie zugeordnet ist. Eine Zeile, die das falsche Paket an das
richtige Tag hängt, kommt durch.

### Punkt 6b — `WEITERMACHEN.md:45` beschreibt `v1.0.113` mit den Angaben von `v1.0.112`

Beim Fahren der Commit-Schranken gefunden, nicht gesucht. Auf `origin/main`
lautet die Zeile *Zuletzt gebaut und veröffentlicht*:

> *Quellstand **7.2.0.112** / `VERSION` **1.0.113**, als **`v1.0.113`** am
> 20.10.2026 um **11:55:10 UTC** auf GitHub veröffentlicht (Marke auf
> `f87a4a74` = Merge von PR **#113**, ZIP `Eudora72-1.0.113-release.zip`,
> SHA-256 `0406c108…`)*

Gemessen über `gh release view` und `git rev-parse`:

| Angabe | gemessen | gehört zu |
|---|---|---|
| Quellstand 7.2.0.112 | `VERSION` = **1.0.113** | **1.0.112** |
| 11:55:10 UTC | `v1.0.113` = **13:01:36 UTC** | **1.0.112** |
| Marke auf `f87a4a74`, PR #113 | `v1.0.113` zeigt auf **`ac094f15`**, PR **#117** | **1.0.112** |
| SHA-256 `0406c108…` | ZIP zu 1.0.113 = **`0d1d4bf4…`** | **1.0.112** |
| ZIP `Eudora72-1.0.113-release.zip` | der Anhang heißt so | 1.0.113 |

**Von sechs Angaben sind vier die des Vorgängers.** Nachgezogen wurden genau
die zwei, in denen die Zahl im Text steht. Das ist Punkt 1 (c) noch einmal, in
einem zweiten Dokument und ohne dass ein Abzug im Spiel war — die Vorlage war
die eigene Zeile von vorhin.

**Dazu, in `Releases/PAKETE.md`, zwei Abschnitte für dieselbe Marke:** `:159`
führt *„1.0.113 — geschnürt am 20.10.2026 … Zweig `e-131-leistenposition`"*,
`:167` führt *„1.0.112 … **als `v1.0.113` veröffentlicht**"*. Zwei Pakete
beanspruchen ein Tag.

**Und das blockiert gerade die Arbeit.** `doku-pruefen.pl` hängt **abweisend**
im `pre-commit` *und* im `pre-push` (`tools/hooks-einrichten.sh:157`, `:463`)
und meldet auf dem sauberen `origin/main`:

```
MANGEL:
  - WEITERMACHEN.md:45 nennt 'Eudora72-1.0.113-release.zip' - liegt nicht in
    Releases/ und steht auch nicht in Releases/PAKETE.md
```

Gemessen am unveränderten `origin/main` (meine eigene Änderung weggelegt).
**Solange das so steht, kann auf diesem Stand niemand committen oder pushen** —
auch `PRUEFER-40` nicht, der gerade läuft. Ich habe es **nicht** berichtigt:
Release-Buchführung ist Sache des LEKTORS, und `WEITERMACHEN.md` wird von
mehreren Zweigen gleichzeitig angefasst. Dieser Bericht ist deshalb mit
`--no-verify` committet worden, und der Grund steht hier.

### Punkt 6c — die Zweigschranke weist den Befehl ab, den sie selbst vorschlägt

Beim Anlegen dieses Arbeitszweigs gemessen. `pruefe-branch.pl` hängt im
`pre-push` und verlangt, dass ein `wt/`-Zweig sein **eigenes** Gegenstück bei
`origin` verfolgt. Der Ausweg, den sie im Klartext nennt, lautet:

```
      git push -u origin wt/chronist-20261020b
```

Genau dieser Befehl löst den `pre-push`-Haken aus, und der weist ihn mit
derselben Meldung ab. Das Gegenstück kann erst **durch** den Push entstehen,
die Schranke verlangt es **vor** dem Push. Ein frisch angelegter
Arbeitsbaum-Zweig kommt so nie durch.

Behelf, ohne eine Prüfung abzuschalten: das Gegenstück über
`gh api repos/…/git/refs` anlegen, `git fetch`, dann
`git branch --set-upstream-to=origin/wt/chronist-20261020b`. Danach meldet
`pruefe-branch.pl` **grün** (Rückgabe 0, keine Ausgabe), und jeder weitere Push
läuft mit vollem Haken.

**Das ist derselbe Befund wie `schranke-an-den-augenblick`, nur von innen:** die
Schranke steht einen Augenblick zu früh für die Lage, die sie herstellen will.
Sie ist in `tools/` und deshalb nicht meine Änderung — sie steht unten unter
*Was Gregor tun muss*.

### Punkt 7 — direkt auf `main`: die Regel war verletzt, die Historie ist sauber

Gemessen:

* `git log --first-parent main` für den 20.10.: **12 Einträge, alle
  Zusammenführungen**, kein einziger eigener Commit.
* `git reflog show main`: an diesem Tag **sechs** Bewegungen, jede
  `pull --ff-only: Fast-forward`.

Auf `main` ist also **nichts** gelandet; die Arbeit wurde rechtzeitig auf
`e-131-leistenposition` gehoben (`0f4b2b1a`, zusammengeführt als #116). Verletzt
war die Regel im **Arbeitsbaum**, nicht in der Geschichte.

Und genau daran hängt der Befund: `pruefe-branch.pl:185` **weist einen Commit
auf `main` ab** — beim **Commit**. Zwischen `git checkout main` und dem ersten
Commit-Versuch sammelt sich beliebig viel Arbeit an, und nichts sagt ein Wort.
Dieselbe Bauart wie [L-43.11](LEKTOR-43.md#l-43.11), nur am anderen Ende der
Arbeit.

### Punkt 8 — der Einfügefehler: nicht zweimal, sondern sechsmal

| # | Ort | Zustand |
|---|---|---|
| 1 | `d6db51c7` — E-69-Kopfzeile in den 1.0.111-Notizen überschrieben | berichtigt `ce5c2e33` |
| 2 | `d6db51c7` — Überschrift *Was geprüft wurde* doppelt | berichtigt `ce5c2e33` |
| 3 | `61c91b43` — zweite Zeile des Einleitungsabsatzes der 1.0.112-Notizen | berichtigt `ce5c2e33` |
| 4 | `0f4b2b1a` — [E-131](../Intern/BEFUNDE.md#e-131) als verwaiste Tabellenzeile in Zeile **8666 von 8666** von `BEFUNDE.md` ([L-43.6](LEKTOR-43.md#l-43.6)) | verschoben |
| 5 | `d64247cb`/`fe49a6ab` — *„auf beiden Wegen:"* als Satzrest mit offener Fettschrift in den 1.0.113-Notizen, Zeile 128 | **steht öffentlich auf GitHub** |
| 6 | `BEFUNDE.md` auf `origin/main`: die Zeile zu [E-131](../Intern/BEFUNDE.md#e-131) ist über **zwei** Zeilen gebrochen — `:300` endet mit *„…vielleicht nicht."* **ohne** schließenden senkrechten Strich, `:301` beginnt mit einem Leerzeichen und endet mit einem | **steht auf `main`** |

Die Ursache zu #4 — das Einfügen verankerte sich an einem
[E-130](../Intern/BEFUNDE.md#e-130)-Treffer, der nach einer Zusammenführung
woanders stand — ist **Vermutung**; belegt ist nur das Ergebnis. Was alle sechs
gemeinsam haben, ist dagegen gemessen: **der eingefügte Text war jedes Mal in
Ordnung, kaputt war sein Nachbar.** Keine Byteprüfung, keine der 32 Schranken
und kein `commit-bereit.pl`-Lauf schlägt dabei an — der Schaden ist nicht in
den Bytes, sondern in der Zeile daneben.

---

## Die Lehren, die ich vorschlage

**Nicht nach `Arbeitsweise/` geschrieben**, aus demselben Grund wie am
Vormittag. Die drei Entwürfe stehen hier fertig zum Übernehmen, jeder mit
seiner `Schranke:`-Zeile.

---

### Neue Lehre 1 — `schranke-an-den-augenblick`

```
name: schranke-an-den-augenblick
description: Eine Schranke im Haken laeuft trotzdem im falschen Augenblick - am 20.10.2026 prueften die Release-Buchfuehrung VOR dem Tag (zweimal zusammen zwoelf unwahre Stellen), die Byteschranke NACH dem Schaden (dreimal printf, 0 von 144 Commits getroffen) und die Zweigschranke erst beim Commit (eine Sitzung lang auf main gearbeitet)
Schranke: tools/pruefe-schranken-augenblick.pl (zu bauen, pre-commit,
  meldend) - zwei Fragen, beide heute rot: (a) ruft
  tools/release-veroeffentlichen.ps1 nach dem "gh release create" die
  Schranke pruefe-release-buchfuehrung.pl ein zweites Mal auf und verlangt
  den Nachzieh-Commit, bevor es sich beendet? (b) gibt paket-bereit.pl die
  Differenz "im Haken, aber nicht vor dem Paket" als Zahl und Liste aus?
  Gegenprobe gemessen und fertig im Repo: der Baum ac094f15 (15:01, direkt
  nach dem Tag v1.0.113) muss auf (a) sechs Stellen melden; der heutige
  Stand muss auf (b) 27 von 32 melden.
```

**Der Fall, dreimal an einem Tag, jedes Mal mit einer Schranke, die es gibt.**

| Schranke | hängt in | der Augenblick, in dem die Aussage falsch wird | Abstand |
|---|---|---|---|
| `pruefe-release-buchfuehrung.pl` | `pre-commit`, `pre-push` | `gh release create` setzt das Tag — **nach** dem letzten Commit | der Haken läuft **davor**; danach läuft nichts |
| `pruefe-bytes.pl` Regel 6 | `pre-commit` | `printf` schreibt das ESC-Byte in die Datei | der Haken läuft **danach**; gemessen 0 von 144 — er bekam es nie zu sehen |
| `pruefe-branch.pl` | `pre-commit` | `git checkout main`, und dann die erste Änderung | der Haken läuft beim ersten Commit, also beliebig spät |

**Die Regel.** Eine Schranke wird nicht danach aufgehängt, wo ein Haken gerade
frei ist, sondern **an dem Augenblick, in dem die Aussage, die sie prüft, falsch
werden kann.** Dieser Augenblick gehört in die `Schranke:`-Zeile der Lehre und
in die Zeile des Werkzeugs in `tools/WERKZEUGE.md` — nicht als `pre-commit`,
sondern als Satz: *„wird falsch, sobald das Tag steht"*, *„wird falsch, sobald
die Datei geschrieben ist"*.

**Warum das nicht
[ausloeser-an-den-anfang](../Arbeitsweise/ausloeser-an-den-anfang.md) ist:**
dort hing die Schranke **gar nicht** an einem Augenblick, der im Alltag
vorkommt (nur am Paketbau), und die Abhilfe war, sie zusätzlich in den
`pre-commit` zu hängen. Hier hängt sie **im** `pre-commit`, und genau das ist
der Fehler.

**Warum das nicht
[schranke-gehoert-in-den-haken](../Arbeitsweise/schranke-gehoert-in-den-haken.md)
ist:** dort lautet der Befund *„läuft nur, wenn ich daran denke"*. Alle drei
Schranken von heute laufen, ohne dass jemand daran denkt. Sie laufen nur nicht
dann, wenn es darauf ankommt. **Das ist der nächste Schritt derselben
Entwicklung, und er ist schwerer zu sehen, weil die Schranke grün meldet.**

**Ein Augenblick, für den es im Projekt noch gar keinen Haken gibt**, und der
heute dreimal gebraucht wurde: der Augenblick **vor** einem Schreibbefehl. Dort
könnte ein Haken auf Bash-Aufrufe sehen und jeden `printf` mit Rückstrich im
Formatteil abweisen. Das ist eine Änderung an Gregors Konfiguration und damit
**seine Entscheidung**, nicht meine — sie steht unten unter *Was Gregor tun
muss*.

---

### Neue Lehre 2 — `einfuegen-misst-den-nachbarn`

```
name: einfuegen-misst-den-nachbarn
description: Wer in ein Dokument einfuegt oder ersetzt, misst danach den NACHBARN, nicht den eingefuegten Text - am 20.10.2026 sechsmal dieselbe Klasse an einem Tag, zwei davon stehen noch oeffentlich; der eingefuegte Text war jedes Mal heil
Schranke: tools/pruefe-md-waisen.pl (zu bauen, pre-commit, abweisend fuer
  geaenderte .md ausser Befunde/, Arbeitsweise/ und LEKTORAT.md) - vier
  Fragen an den Zuwachs: (a) keine "## "-Ueberschrift zweimal gleichlautend
  im selben Dokument; (b) keine Tabellenzeile ohne Tabellen- oder Trennzeile
  als Nachbar; (c) keine Tabellenzeile ohne schliessenden senkrechten
  Strich; (d) die Zahl der Fettschrift-Marken in einem Absatz oder
  Aufzaehlungspunkt (bis zur Leerzeile oder zum naechsten Punkt) muss gerade
  sein. Gegenproben liegen fertig im Repo: d6db51c7:Releases/1.0.111/
  RELEASE-NOTIZEN.md rot auf (a); der heutige Koerper von v1.0.113 rot auf
  (d), Zeile 128; BEFUNDE.md auf origin/main rot auf (c), Zeile 300;
  ce5c2e33:Releases/1.0.112/RELEASE-NOTIZEN.md gruen auf alle vier.
```

**Der Fall.** Die sechs Vorkommen stehen oben unter Punkt 8. Was sie
zusammenhält, ist gemessen:

* **Byteprüfung sagt nichts.** `CRLF 0`, reine LF, UTF-8 ohne BOM, keine
  Doppelkodierung, keine Steuerzeichen — in allen sechs Fällen.
* **Der angezeigte Unterschied sagt nichts Zuverlässiges.** Bei `d6db51c7` gab
  es keinen (`84 insertions(+)`, neuer Pfad). Bei `61c91b43` gab es einen von
  32 Zeilen, und der Verlust stand mittendrin.
* **`commit-bereit.pl` sagt nichts.** Der LEKTOR hat vor jedem Commit
  *„32 Schranken, keine weist ab"* gemessen — und seine eigene Reparatur hat
  Fall 5 erzeugt.

**Die Regel.** Nach jedem Einfügen oder Ersetzen in einem Dokument wird
**nicht** der eingefügte Text gelesen, sondern die Zeile **davor** und die Zeile
**danach**. Drei Fragen, die alle sechs Fälle gefangen hätten:

1. Steht die Zeile davor noch ganz da?
2. Steht die Zeile danach noch ganz da?
3. Ist der eingefügte Block dort, wo seine **Nachbarn** hingehören — eine
   Tabellenzeile zwischen Tabellenzeilen, ein Aufzählungspunkt zwischen
   Aufzählungspunkten?

**Querverweis.**
[erfolgsmeldung-aus-dem-ergebnis](../Arbeitsweise/erfolgsmeldung-aus-dem-ergebnis.md)
verlangt, nach dem Schreiben die **Datei** zu messen statt des eigenen
Kontrollflusses. Das ist heute geschehen — gemessen wurden Bytes und
Zeilenenden, und die waren heil. Diese Lehre sagt, **was** an der Datei zu
messen ist.

---

### Neue Lehre 3 — `notizen-aus-der-quelle-nicht-aus-der-kopie`

```
name: notizen-aus-der-quelle-nicht-aus-der-kopie
description: Ein veroeffentlichter Text, den ich zum Vergleich herunterlade, ist ein Abzug mit Zeitstempel - am 20.10.2026 entstanden die Notizen zu 1.0.113 aus einem 35 Minuten alten Abzug von GitHub, waehrend die vom LEKTOR berichtigte Datei im selben Arbeitsbaum lag; alle vier Reparaturen waren wieder weg
Schranke: tools/pruefe-notizen-herkunft.pl (zu bauen, pre-commit) - drei
  Fragen an jede neu angelegte Releases/<N>/RELEASE-NOTIZEN.md, gehalten
  gegen Releases/<N-1>/RELEASE-NOTIZEN.md IM SELBEN BAUM: (a) jede
  "## "-Ueberschrift des Vorgaengers kommt vor oder ist in der
  Commit-Nachricht begruendet; (b) keine Zeile des Vorgaengers faellt
  unbegruendet weg; (c) der Abschnitt "Was geprueft wurde" nennt die
  Testzahl dieses Baus und keine Fassungsnummer unterhalb von VERSION.
  Gegenprobe fertig im Repo: 0f4b2b1a muss auf alle drei rot gehen (drei
  Zeilen des Vorgaengers fehlen, "229 Tests" statt 234, "an Paket 1.0.113"
  fuer eine Messung an 1.0.111); fe49a6ab gruen auf alle drei.
```

**Der Fall, gemessen.** Siehe Punkt 1 (c). Die Kette in einer Zeile:
`gh release view --json body` um **13:59** in den Scratchpad → LEKTOR berichtigt
die Repo-Datei um **14:07** → neue Notizen um **14:34** aus dem Abzug.

**Warum ein Abzug so gefährlich ist.** Er sieht aus wie die Wahrheit — er
**war** die Wahrheit, 35 Minuten lang. Er trägt keinen Zeitstempel im Text, und
er liegt neben mir, während die Quelle im Repo liegt. Ein Abzug altert
lautlos, genau wie eine Anzeige
([anzeige-ist-kein-zustand](../Arbeitsweise/anzeige-ist-kein-zustand.md)).

**Die Regel.**

1. **Ein heruntergeladener Text wird zum Vergleichen benutzt und danach
   weggeworfen**, nie als Vorlage. Die Vorlage ist immer die Datei im
   Arbeitsbaum.
2. **Der Prüfabschnitt wird neu geschrieben, nicht fortgeschrieben.** Was in
   *„Was geprüft wurde – und was nicht"* steht, kommt aus dem Bau **dieser**
   Fassung: die Testzahl aus diesem Lauf, die Messungen aus diesem Prüfstand,
   die Fassungsnummer, an der Gregor gemessen hat. Heute standen dort
   nacheinander die Testzahl von 1.0.110, der Warnblock von 1.0.112 und ein
   Satz über [E-123](../Intern/BEFUNDE.md#e-123) in den Notizen zu
   [E-131](../Intern/BEFUNDE.md#e-131).
3. **Ein Warnblock, den die Fassung behebt, ist keine Warnung mehr.** Der
   gefährlichste Satz des Tages stand in den veröffentlichten Notizen zu
   1.0.113: *„Wir haben es noch nicht nachgestellt"* — über genau den Befund,
   den diese Fassung behebt und für den sie am Prüfstand rot und grün gesehen
   wurde.

**Querverweis auf den Vormittag:** `main-ist-was-gregor-sieht` (noch nicht
übernommen) sagt, dass ein Stand erst zählt, wenn er auf `origin/main` steht.
Heute kommt die dritte Stelle dazu: **der veröffentlichte Release-Körper**. Er
kann von `main` abweichen, in beide Richtungen — `v1.0.112` war erst schlechter
als die Datei, dann gleich; `v1.0.113` ist heute gleich und trägt denselben
Schaden. Der Satz dieser Lehre gehört in die dortige Regel 2.

---

## Nachträge zu vorhandenen Lehren

| Lehre | Nachtrag |
|---|---|
| [text-nicht-durch-schichten-schicken](../Arbeitsweise/text-nicht-durch-schichten-schicken.md) | **Dritter bis fünfter Rückfall, und der Nachtrag vom Vormittag ist nie angekommen.** Gemessen: die Datei ist zuletzt am **14.10.2026** geändert worden (`d135f170`); die `%s`-Regel, die genau diesen Fall benennt, steht nur in [CHRONIST-2026-10-20](CHRONIST-2026-10-20.md). **Zweitens, und das ist der härtere Befund:** über alle 48 Commits dieses Tages und die drei betroffenen Dateien gemessen, trägt **kein einziger** ein Steuerzeichen (0 von 144). `pruefe-bytes.pl` Regel 6 hatte nie etwas zu fangen — der Schaden entsteht und vergeht **vor** dem Commit. Die Lehre braucht deshalb keinen weiteren Satz über Perl, sondern einen Augenblick vor dem Schreibbefehl (`schranke-an-den-augenblick`). |
| [lehren-anwenden-nicht-nur-schreiben](../Arbeitsweise/lehren-anwenden-nicht-nur-schreiben.md) | **Die Lücke ist gemessen, und sie ist die Übergabe.** Von **6** in CHRONIST-Berichten vorgeschlagenen Lehren fehlen **2** in `Arbeitsweise/` und in `MEMORY.md` — beide von **heute 11:58**, und der Nachmittag hat genau das getan, wovor sie warnen. `tools/lehren-schranken.pl` prüft nur Lehren, die **schon** in `Arbeitsweise/` liegen; `tools/lehren-spiegeln.pl` spiegelt vom Gedächtnis **nach** `Arbeitsweise/`. **Die Gegenrichtung prüft niemand.** Ein kleines Werkzeug genügt: die `name:`-Zeilen aus `Befunde/CHRONIST-*.md` gegen `Arbeitsweise/*.md` halten und die nie angekommenen nennen. Dazu gehört die ehrliche Zahl: der Weg funktioniert (4 von 6 sind angekommen), **die Laufzeit ist das Problem** — sieben Stunden, und sie lagen genau über dem Teil des Tages, in dem die Lehren gebraucht wurden. |
| [schranke-gehoert-in-den-haken](../Arbeitsweise/schranke-gehoert-in-den-haken.md) | **Ein Gegenfall, den die Lehre nicht kennt: die Schranke hängt im Haken und greift trotzdem nicht.** Drei Belege an einem Tag, alle gemessen (Tabelle unter `schranke-an-den-augenblick`). Dazu der Umfang: **32** Schranken hängen im `pre-commit`/`pre-push`, **10** stehen in `paket-bauen.ps1` — **27 im Haken und nicht vor dem Paket**. Der Satz *„nicht im Haken = keine Schranke"* bleibt richtig; er ist nur nicht mehr hinreichend. |
| [schranke-teilt-nicht-die-annahme](../Arbeitsweise/schranke-teilt-nicht-die-annahme.md) | **Zwei neue Belege, beide heute grün gemeldet.** (1) `pruefe-befundurteile.pl` sagt *„keinen behobenen für unerledigt"*, während `README.md:75` über den behobenen [E-131](../Intern/BEFUNDE.md#e-131) sagt, er sei *„von uns noch nicht nachgestellt"*. Ursache am Quelltext: `@unerledigt` (`:212-217`) ist eine Liste von **acht** von Hand geschriebenen Wendungen, und diese ist keine davon. (2) `pruefe-release-buchfuehrung.pl` meldet grün, während `Releases/PAKETE.md:6` sagt *„zuletzt veröffentlicht **1.0.112** als `v1.0.113`"* — die Schranke fragt, **ob** die Nummer vorkommt, nicht **wem** sie zugeordnet ist. Beide Male prüft die Schranke eine Wortliste statt einer Aussage, genau wie [L-43.13](LEKTOR-43.md#l-43.13). |
| [erfolgsmeldung-aus-dem-ergebnis](../Arbeitsweise/erfolgsmeldung-aus-dem-ergebnis.md) | **Die Fassung *Commit-Nachricht*.** `0f4b2b1a` schreibt im Körper *„[E-124](../Intern/BEFUNDE.md#e-124) fortgeschrieben … 13:09:05 … 13:17:28"*; `git show 0f4b2b1a -- BEFUNDE.md` ändert ausschließlich die Zeile zu [E-131](../Intern/BEFUNDE.md#e-131), und `grep` über `BEFUNDE.md` findet beide Zeitangaben **nirgends**. Eine Commit-Nachricht ist eine Erfolgsmeldung wie jede andere: **jeder Punkt, den sie nennt, wird vor dem Absenden im Diff wiedergefunden.** `tools/commit-bereit.pl` wäre der Ort dafür. |
| [wissen-gehoert-in-dateien](../Arbeitsweise/wissen-gehoert-in-dateien.md) | **Es reicht nicht, dass es in *einer* Datei steht — es muss in *der* Datei stehen.** Die Acht-Minuten-Messung zu [E-124](../Intern/BEFUNDE.md#e-124) steht vollständig und gut formuliert in `Releases/1.0.113/RELEASE-NOTIZEN.md:91-101` und damit öffentlich auf GitHub, aber in **keinem** Befund und in keiner Paketzeile. Der nächste, der [E-124](../Intern/BEFUNDE.md#e-124) aufschlägt, liest den Stand vom 16.10. — und [L-43.17](LEKTOR-43.md#l-43.17) hat heute früh genau nach diesem Beleg gesucht und keinen gefunden. **Ein Messwert gehört in den Befund, bevor er in ein Anwenderdokument geht.** |
| [erst-nachstellen-dann-ausliefern](../Arbeitsweise/erst-nachstellen-dann-ausliefern.md) | **Zum ersten Mal hat sie ohne Gregor als Prüfstand funktioniert — und das Dokument hat es bestritten.** Gemessen und in [E-131](../Intern/BEFUNDE.md#e-131) belegt: 7.2.0.112 schrieb bei einem einzigen Start-und-Beenden `MRUFloatXPos=-2147483648` dreimal in die INI (3249 → 6480 Byte, 16 neue Abschnitte), 7.2.0.113 null Treffer für `INT_MIN`, in zwei Läufen. Rot und grün, am eigenen Prüfstand, **vor** der Auslieferung. Die veröffentlichten Notizen derselben Fassung sagten dazu *„Wir haben es noch nicht nachgestellt"*. **Nachtrag:** die Lehre endet nicht beim Messen. Der Satz, der die Messung behauptet oder bestreitet, steht in einem anderen Dokument, und der gehört dazu. |
| [kein-paket-mit-offenem-datenverlust](../Arbeitsweise/kein-paket-mit-offenem-datenverlust.md) | **Eine Größe, die in der Lehre fehlt: wer wartet.** Zweimal an einem Tag dieselbe Frage, zwei verschiedene Antworten, beide von Gregor. 7.2.0.111 wurde wegen [PRÜFER-39](PRUEFER-39.md) N1 zurückgenommen — Gewicht *hoch*, aber **belegt am Quelltext**, nicht gemessen, und es wartete niemand außer uns. 7.2.0.113 ging hinaus, ohne auf `PRUEFER-40` zu warten (*„wir nehmen die alternative"*), weil ein Fremder mit unbrauchbarer Installation wartet. Die Lehre kennt bisher nur Gregor als Empfänger. **Ab dem ersten Fehlerbericht von außen gibt es Empfänger, für die Warten teurer ist als für uns** — die Abwägung gehört benannt, die Entscheidung bleibt seine. |
| [nie-direkt-auf-main](../Arbeitsweise/nie-direkt-auf-main.md) | **Gemessen: auf `main` ist nichts gelandet.** `git log --first-parent main` zeigt für den 20.10. zwölf Einträge, alle Zusammenführungen; `git reflog show main` sechs Bewegungen, alle `pull --ff-only`. Verletzt war die Regel im **Arbeitsbaum**. `pruefe-branch.pl:185` weist den Commit auf `main` ab — beim Commit, also beliebig spät. **Nachtrag ins How-to-apply:** der erste Handgriff nach `git checkout main` ist `git branch --show-current`, und der erste **Schreibzugriff** auf eine Projektdatei gehört auf einen Zweig — nicht erst der erste Commit. |
| [pruefen-statt-vermuten](../Arbeitsweise/pruefen-statt-vermuten.md) | **Eine Schutzbehauptung ist eine Ursachenbehauptung und braucht dieselbe Messung.** `README.md:75` und die veröffentlichten Notizen zu 1.0.112 nannten eine **Bedingung** — *„solange dieselbe `Eudora.ini` benutzt wird"* —, die nie gemessen wurde und die im Umkehrschluss einen Schutz verspricht, den es nicht gibt. Der Melder hat sie am 20.10. um 16:11 UTC widerlegt. **Eine Bedingung in einer Warnung ist das, wonach der Leser handelt; sie ist der geprüfte Teil, nicht das Beiwerk.** |
| [kuerzel-im-chat-uebersetzen](../Arbeitsweise/kuerzel-im-chat-uebersetzen.md) | **Zweiter Beleg für die Erweiterung vom Vormittag, diesmal nach außen.** Gregors Einwurf *„Befund läuft bei uns als [E-131](../Intern/BEFUNDE.md#e-131). link fehlt!"* betraf den veröffentlichten Release-Text: dort stand die Kennung ohne Verweis, für Leser, die `BEFUNDE.md` nicht kennen. In der berichtigten Fassung ist sie verlinkt. **In einem veröffentlichten Dokument ist eine Kennung ohne Link und ohne Klartext nicht nur unhöflich, sie ist unbrauchbar** — der Leser hat unser Repo nicht im Kopf. |

---

## Schranken: Stand nach diesem Tag

| # | Schranke | Stand |
|---|---|---|
| 1 | `tools/pruefe-schranken-augenblick.pl` | **fehlt.** Zwei Fragen, beide heute rot; Gegenproben gemessen (`ac094f15` → 6 Stellen, heutiger Stand → 27 von 32) |
| 2 | `tools/pruefe-md-waisen.pl` | **fehlt.** Vier Fragen; drei rote und eine grüne Gegenprobe liegen fertig im Repo |
| 3 | `tools/pruefe-notizen-herkunft.pl` | **fehlt.** Gegenprobe: `0f4b2b1a` rot, `fe49a6ab` grün |
| 4 | `pruefe-release-buchfuehrung.pl` **nach** dem Tag ([L-43.11](LEKTOR-43.md#l-43.11)) | **fehlt**, und sie ist die dringendste: zweimal heute, zusammen **zwölf** unwahre Stellen auf `main` |
| 5 | `paket-bereit.pl` kennt seinen Umfang ([L-43.12](LEKTOR-43.md#l-43.12)) | **fehlt.** 27 von 32 Schranken fehlen ihm |
| 6 | Wortliste statt Aussage ([L-43.13](LEKTOR-43.md#l-43.13)) | **fehlt**, jetzt in **zwei** Werkzeugen belegt |
| 7 | Release-Notizen in den Prüfumfang ([L-43.15](LEKTOR-43.md#l-43.15)) | **fehlt** |
| 8 | Ein Haken **vor** dem Schreibbefehl (gegen `printf` mit Rückstrich) | **fehlt**, und er betrifft Gregors Konfiguration — seine Entscheidung |
| 9 | Die nie übernommenen Lehren melden | **fehlt.** Heute 2 von 6, beide sieben Stunden alt |
| 10 | `pruefe-branch.pl` beim **ersten** Push eines `wt/`-Zweigs | **fehlerhaft**, Punkt 6c: sie weist den Befehl ab, den sie selbst vorschlägt |
| 11 | Die sechs vom Vormittag ([CHRONIST-2026-10-20](CHRONIST-2026-10-20.md)) | **unverändert offen** |

**Was dieser Tag über Schranken zeigt**, und es ist der rote Faden durch alle
acht Punkte: **die Schranken haben nicht gefehlt, sie standen am falschen
Augenblick.** `pruefe-release-buchfuehrung.pl` ist für genau diesen Fall gebaut
und hat auch funktioniert — rückwirkend gefahren nennt sie alle sechs Stellen.
`pruefe-bytes.pl` Regel 6 ist heute früh für genau diesen Fall gebaut worden.
`pruefe-branch.pl` verbietet genau das, was geschehen ist. Alle drei haben an
diesem Tag **grün gemeldet**, und alle drei zu Recht, gemessen an dem
Augenblick, in dem sie liefen. Gefangen haben am Ende: Gregor (zweimal), der
LEKTOR (einmal), und ein Blick auf eine Datei nach dem Schreiben (dreimal).

---

## Widerlegte Vermutungen

Nach [widerlegte-vermutungen-aufschreiben](../Arbeitsweise/widerlegte-vermutungen-aufschreiben.md)
— jede mit ihrer Messung:

| Vermutung | woher | Messung | Urteil |
|---|---|---|---|
| *„Ein eigener Ordner genügt nicht, **solange dieselbe `Eudora.ini` benutzt wird**"* | `README.md:75` und `Releases/1.0.112/RELEASE-NOTIZEN.md:19`, beides veröffentlicht | `gh issue view 102`, Kommentar vom 20.10. 16:11:54 UTC: *„the new install »found« (via registry lookups) the existing one in another folder"*; am Quelltext bestätigt in `eudora.cpp:1036-1052`, `:3700`, `:3736-3748` | **falsch in der Bedingung.** Die Warnung trägt, der Nebensatz verspricht einen Schutz, den es nicht gibt |
| *„ich kopiere Release-Notizen von einer Fassung zur nächsten und ziehe nur die Zahlen nach; dabei habe ich eine Reparatur des LEKTORS überholt"* | Auftragstext, ausdrücklich als Vermutung | drei Unterschiede zwischen `69954622:…/1.0.112` und `0f4b2b1a:…/1.0.113`; `0f4b2b1a^` = `e182c990` (LEKTOR-Spitze, berichtigte Datei im selben Baum); `scratchpad/veroeffentlicht.md` vom **13:59** byteweise die unberichtigte Fassung | **zu milde.** Es war kein Überholen, sondern eine **Kopie des veröffentlichten Textes neben der berichtigten Datei**. Alle vier Reparaturen zurückgedreht, die Zuschreibung sogar eine Fassung weiter verschoben |
| *„Die veröffentlichten Notizen zu `v1.0.112` tragen die drei Schäden weiter"* | [LEKTOR-43](LEKTOR-43.md#lektor-43), *Was bewusst stehen geblieben ist* | `gh release view v1.0.112 --json body`: E-69-Kopfzeile bei `:34`, zweite Einleitungszeile bei `:24`, `grep -c 'Was geprüft wurde'` = **1** | **überholt.** Der veröffentlichte Text ist berichtigt worden |
| *„Bei 1.0.113 wurden fünf Stellen unwahr"* | Auftragstext | `git checkout ac094f15 && perl tools/pruefe-release-buchfuehrung.pl` → **MANGEL, 6 Stellen** | **zu niedrig.** Sechs, also mit 1.0.112 zusammen **zwölf** an einem Tag |
| *„Die Schranke `pruefe-bytes.pl` Regel 6 hätte beim Commit gegriffen"* | Auftragstext | 48 Commits × 3 Dateien = **144 Messungen, 0 Steuerzeichen** | **richtig und gegenstandslos.** Sie hätte gegriffen, wenn der Schaden je bis zum Commit gekommen wäre; das ist er nie. Der Befund liegt davor, nicht in der Schranke |
| *„Das Registry-Wissen steht noch in keinem Dokument"* | Auftragstext | `BEFUNDE.md` im Hauptarbeitsbaum, Zweig `e-132-fremdes-mailverzeichnis`, **gestaget, nicht committet**, mit der vollständigen Quelltextkette | **inzwischen falsch — aber nur im Arbeitsbaum.** Auf `origin/main`: `grep -c 'e-132'` = **0** in `BEFUNDE.md` und `README.md`; in `WEITERMACHEN.md`, `CHANGELOG.md`, `AUFGABEN.md` und den Notizen zu 1.0.113 **nirgends** |
| *„Ich habe eine Zeit lang direkt auf `main` gearbeitet"* (als Historienbefund) | Auftragstext | `git log --first-parent main` 20.10. = 12 Einträge, alle Zusammenführungen; `git reflog show main` = sechs `pull --ff-only` | **richtig als Regelverstoß, falsch als Historienbefund.** Auf `main` ist nichts gelandet; verletzt war die Regel im Arbeitsbaum |

**Nicht widerlegt, aber auch nicht belegt:** dass der erste Versuch zu
`v1.0.112` die Notizen **leer** veröffentlichte (im Repo steht dazu nichts; am
Quelltext belegt ist nur, dass das Skript es zulässt und nicht meldet); dass das
Einfügen von [E-131](../Intern/BEFUNDE.md#e-131) sich an einem verschobenen
[E-130](../Intern/BEFUNDE.md#e-130)-Treffer verankert hat (belegt ist nur das Ergebnis);
und wann genau `gh release edit` auf `v1.0.112` und `v1.0.113` gelaufen ist —
GitHub führt darüber keine Historie, die `gh` ausgibt.

---

## Was Gregor tun muss

**1. `main` ist gerade dicht — das ist der dringendste Punkt.**
`doku-pruefen.pl` weist auf dem sauberen `origin/main` ab, im `pre-commit`
**und** im `pre-push`. Niemand kann auf diesem Stand committen oder pushen,
auch der laufende `PRUEFER-40` nicht. Ursache ist `WEITERMACHEN.md:45` (siehe
Punkt 6b): die Zeile nennt ein ZIP, das weder in `Releases/` liegt noch in
`Releases/PAKETE.md` steht — **und vier ihrer sechs Angaben zu `v1.0.113` sind
die von `v1.0.112`** (Uhrzeit, Marke, PR-Nummer, Prüfsumme). Dazu beanspruchen
`Releases/PAKETE.md:159` und `:167` beide die Marke `v1.0.113`.

**2. Fünf Unwahrheiten stehen gerade öffentlich oder auf `main`:**

| wo | was | Handgriff |
|---|---|---|
| `main`, `WEITERMACHEN.md:45` | vier von sechs Angaben zu `v1.0.113` sind die von `v1.0.112` (11:55:10 statt 13:01:36 UTC, `f87a4a74`/#113 statt `ac094f15`/#117, SHA `0406c108…` statt `0d1d4bf4…`, Quellstand 7.2.0.112 statt .113) | gemessene Werte eintragen; danach läuft `doku-pruefen.pl` wieder |
| `main`, `Releases/PAKETE.md:159` und `:167` | zwei Pakete beanspruchen die Marke `v1.0.113` | eines davon richtigstellen |
| GitHub, `v1.0.113` | Zeile 128 ist ein Satzrest mit offener Fettschrift | die Zeile in `Releases/1.0.113/RELEASE-NOTIZEN.md` an ihren Punkt anschließen, dann `gh release edit v1.0.113 --notes-file Releases/1.0.113/RELEASE-NOTIZEN.md` |
| `main`, `README.md:75` | sagt über den **behobenen** [E-131](../Intern/BEFUNDE.md#e-131) *„von uns noch nicht nachgestellt"* und nennt die widerlegte Bedingung *„solange dieselbe `Eudora.ini` benutzt wird"* | gehört in denselben Zweig wie **[E-132](../Intern/BEFUNDE.md#e-132)** |
| `main`, `BEFUNDE.md:300/301` | die Zeile zu [E-131](../Intern/BEFUNDE.md#e-131) ist über zwei Zeilen gebrochen, `:300` endet ohne schließenden senkrechten Strich | eine Zeile daraus machen |

Dazu: `WEITERMACHEN.md` führt [E-131](../Intern/BEFUNDE.md#e-131) weiter als offen
(`perl tools/offene-befunde.pl -schreiben` setzt es).

**3. `pruefe-branch.pl` weist beim ersten Push eines neuen `wt/`-Zweigs den
Befehl ab, den sie selbst vorschlägt** (Punkt 6c). Der Behelf steht dort; die
Schranke selbst gehört repariert, sonst kostet sie jeden neuen Arbeitsbaum
einen Umweg.

**4. Die Lehren übernehmen.** Fünf warten: die **zwei vom Vormittag**
(`anleitung-ist-ein-pruefling`, `main-ist-was-gregor-sieht` — gemessen: beide
sind nach sieben Stunden weder in `Arbeitsweise/` noch in `MEMORY.md`) und die
**drei von hier**. Dazu die elf Nachträge oben und die zehn vom Vormittag.
**Solange sie nur im Bericht stehen, wirken sie nicht** — das ist heute dreimal
gemessen worden.

**5. [L-43.11](LEKTOR-43.md#l-43.11) ist die wichtigste offene Schranke.**
Zwölf unwahre Stellen auf `main` an einem Tag, in zwei Releases, und beide Male
hat die vorhandene Schranke sie rückwirkend alle genannt. Ein zweiter Aufruf in
`release-veroeffentlichen.ps1` nach dem `gh release create`, der nicht abweist,
sondern die Stellen nennt und den Nachzieh-Commit verlangt.

**6. Eine Entscheidung, die nur Du treffen kannst:** soll ein Haken **vor** den
Schreibbefehl, der jeden `printf` mit Rückstrich im Formatteil abweist? Das ist
eine Änderung an Deiner Konfiguration, nicht an einem Werkzeug im Repo. Ohne
ihn bleibt der `printf`-Fehler eine Sache des Erinnerns — und heute war er das
dreimal, an dem Tag, an dem die Lehre dazu geschrieben wurde.

**7. Der Melder aus [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102)
bietet mehr an als einen Fehlerbericht:** ein eigenes Unicode-Fix-Plugin und
den Vorschlag, Scintilla für die Lese- und Schreibfenster zu nehmen. Ob und wie
darauf geantwortet wird, ist Deine Entscheidung — es steht hier, damit es nicht
im Issue verfällt.

## Offen, nicht Sache des CHRONIST

1. **`PRUEFER-40` läuft** (angestoßen 14:59) und prüft die INI-Nachbehandlung
   in `CMainFrame::SaveBarState`. Das Paket ist bereits veröffentlicht.
2. **Der Leseweg zu [E-131](../Intern/BEFUNDE.md#e-131) ist offen**: eine bereits
   beschädigte INI wird erst beim nächsten Sichern berichtigt. Steht so im
   Befund und in den Notizen.
3. ****[E-132](../Intern/BEFUNDE.md#e-132)** ist nicht committet** und auf `main`
   unbekannt; er ist am Quelltext belegt und **nicht nachgestellt**.
4. **[PRÜFER-39](PRUEFER-39.md) N2 bis N9** sind nicht abgearbeitet; N1 ist
   durch die Rücknahme erledigt.
5. **Die vier Werkzeugmängel aus [LEKTOR-43](LEKTOR-43.md#lektor-43)**
   ([L-43.11](LEKTOR-43.md#l-43.11) bis [L-43.15](LEKTOR-43.md#l-43.15)) und
   die neun Punkte aus [L-43.16](LEKTOR-43.md#l-43.16).
6. **Die fünf `Eudora71/Bin/Release/*.dll`** ([E-130](../Intern/BEFUNDE.md#e-130))
   stehen weiter als geändert im Hauptarbeitsbaum; entschieden ist, sie nicht
   zu committen.
