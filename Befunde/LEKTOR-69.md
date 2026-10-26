# <a id="lektor-69"></a>LEKTOR-69 — Bestand vor dem Testpaket 7.2.0.123, Zweig `vor-testpaket-7.2.0.123` bis `f3e8389c`, 26.10.2026

**Auftrag.** Alle `.md` außer `Arbeitsweise/` und `Befunde/` gegen den Bestand
prüfen, nicht gegen den Diff. Geändert seit `47d5f77` sind elf Commits bis
`f3e8389c` (gemessen: `git log --oneline 47d5f77..HEAD`), davon zehn auf dem
Zweig `vor-testpaket-7.2.0.123` und einer (`07f181dc`, PR #175) auf `main`.
Schwerpunkt: die neuen Zeilen unter *Bekannte Fehler* in der README, die
Logzeile zu `rootcerts.p7b`, der CHANGELOG-Abschnitt „Seit 7.2.0.122 auf
`main`", die Sätze vom 26.10.2026 in [E-142](../Intern/BEFUNDE.md#e-142), [E-146](../Intern/BEFUNDE.md#e-146), [E-148](../Intern/BEFUNDE.md#e-148), `ZIEL.md` 2a,
`WEITERMACHEN.md` und der Prüfbericht.

**Ergebnis vorweg.** **12 Funde** (4 falsch, 3 unvollständig, 3 veraltet,
2 Hinweise). Die drei schwersten:

1. **Die Logzeile `rootcerts.p7b geladen aus:` erscheint nur, wenn im
   `LogLevel` der Schalter 32768 steht** — Eudoras Vorgabe ist 25759, ohne
   ihn. Gerade wer eine eigene `Eudora.ini` mitbringt (die Leser des
   README-Absatzes), sieht die Zeile nicht und kann sie auch nicht als
   „FEHLT" lesen. Dasselbe gilt für die neue Spurmarke zu *„Encountered an
   improper argument"*: eine leere Spur beweist dort nichts
   ([L-69.3](#l-69.3)).
2. **Die README sagt, außer in der *Selten*-Zeile gehe nirgends eine
   Nachricht verloren — die neue Zeile zu [E-142](../Intern/BEFUNDE.md#e-142) nennt drei Zeilen tiefer
   den verlorenen Entwurf** ([L-69.1](#l-69.1)); der Befund selbst sagt im
   ersten Satz *„Verloren geht nichts"* ([L-69.2](#l-69.2)).
3. **Die README nennt [E-77](../Intern/BEFUNDE.md#e-77) (IMAP-Ordner mit Umlauten) „behoben" und „nichts"
   verloren** — gerade die Behebung lässt aber ältere gespeicherte
   Nachrichten mit Ablage in einen Umlaut-Ordner ihre Kopie ohne Meldung
   verlieren (PRÜFER-49 K3, im Befund als *„Offen innerhalb von [E-77](../Intern/BEFUNDE.md#e-77)"*)
   ([L-69.7](#l-69.7)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Mechanisch

Gemessen am 26.10.2026 im Arbeitsbaum `Eudora7.2-wt-lektor` auf `f3e8389c`.
Die Ausgaben sind zitiert, nicht als Urteil übernommen — keiner der zwölf
Funde unten wird von diesen Werkzeugen gemeldet.

| Werkzeug | Ausgabe (gekürzt) |
|---|---|
| `perl tools/doku-pruefen.pl` | *„Kein Widerspruch gefunden."*; Quellstand 7.2.0.122, 46 Dateien, 13 Hinweise „nennt weder den Quellstand 7.2.0.122 noch die Paketnummer 1.0.122" (Release-Notizen, Issue-Antworten, `Doku/HINTERGRUND.md`, `Testdaten/README.md` u. a. — Archivdateien, kein Fund) |
| `perl tools/offene-befunde.pl` | *„38 offene Befunde, in beiden Listen gleich."*; 27 aktuell gemessen (22 nur am Quelltext), 11 nie gemessen |
| `perl tools/pruefe-regressionstest.pl` | 205 Befunde, 70 mit Testfall, 68 behoben ohne Testfall; kritisch 69, davon 46 mit Testfall, **21 ohne jede Prüfung** (`S-1 S-8 V-1 AN-1 E-2 E-3 E-23 E-32 E-60 E-64 E-72 E-82 E-120 E-122 E-123 E-124 E-126 E-129 E-136 E-133 E-39`); *„Kein neues ‚behoben' ohne Regressionstest."* |
| `perl tools/ziel-stand.pl` | *„19 von 19 erfüllt, 0 offen - ZIEL.md ist auf dem Stand."* — derselbe Widerspruch wie [L-61.1](LEKTOR-61.md#l-61.1), siehe unten |

## Funde aus dem letzten Bericht

[LEKTOR-68](LEKTOR-68.md#lektor-68) hatte **keinen Fund** — es gibt nichts
nachzuhalten. Der letzte Bestandslauf war [LEKTOR-61](LEKTOR-61.md#lektor-61)
(25.10.2026); da der Hauptagent dessen Funde laut
`Intern/WEITERMACHEN.md:139` *„dann die Funde aus [LEKTOR-61](LEKTOR-61.md#lektor-61)"* noch abarbeitet,
hier ihr Stand:

| Fund | worum es ging | Stand heute | Beleg |
|---|---|---|---|
| [L-61.1](LEKTOR-61.md#l-61.1) | `ZIEL.md` oben „0 offen", unten zwei Kriterien „fast" | **offen** | gemessen: `ziel-stand.pl` *„19 von 19 erfüllt, 0 offen"*; belegt: `ZIEL.md:199-200` *„zwei sind fast erfüllt (2, 4)"*; `README.md:136-137` schickt weiter dorthin |
| [L-61.2](LEKTOR-61.md#l-61.2) | anwendersichtbare offene Fehler fehlen in der README | **teilweise** | gemessen (`grep -c` je Kennung in `README.md`): [E-136](../Intern/BEFUNDE.md#e-136), [E-142](../Intern/BEFUNDE.md#e-142), [E-143](../Intern/BEFUNDE.md#e-143), [E-144](../Intern/BEFUNDE.md#e-144), [E-139](../Intern/BEFUNDE.md#e-139), [AN-1](../Intern/BEFUNDE.md#an-1) je 1; [E-141](../Intern/BEFUNDE.md#e-141) (Übertragung IMAP → `Out` stößt die IMAP-Nachbearbeitung bis zum `EXPUNGE` an), [E-140](../Intern/BEFUNDE.md#e-140) (zwei Speicherwege ohne Zeichensatzangabe), [E-145](../Intern/BEFUNDE.md#e-145) (Base64 wertet Bytes über 127 als gültig) je **0**; [E-137](../Intern/BEFUNDE.md#e-137) und [E-146](../Intern/BEFUNDE.md#e-146) sind inzwischen eingebaut — Frage an Gregor unten |
| [L-61.3](LEKTOR-61.md#l-61.3) | README verspricht Anhänge „mit Endung" | **teilweise** | [AN-1](../Intern/BEFUNDE.md#an-1) steht jetzt unter *Bekannte Fehler* (`README.md:172`), aber `:106` sagt weiter *„Anhänge mit vollem Namen und Endung"* |
| [L-61.4](LEKTOR-61.md#l-61.4) | E-142-Hinweis weder gebaut noch in der README | **erledigt** | `tocdoc.cpp:2785-2800`, Text `EudoraRes.rc:7808-7809`; `README.md:168` |
| [L-61.5](LEKTOR-61.md#l-61.5) | kein Ort für Gregors Ergebnisse je Kriterium | **offen** | siehe [L-69.10](#l-69.10) |
| [L-61.6](LEKTOR-61.md#l-61.6) | README verweist auf „7.2.0.123" | **erledigt** | `README.md:147`, `:160-163` *„Behoben ab dem Release 7.2.1 (schon im Testpaket 7.2.0.123)"* |
| [L-61.7](LEKTOR-61.md#l-61.7) | [E-150](../Intern/BEFUNDE.md#e-150) fehlt im CHANGELOG | **erledigt** | `CHANGELOG.md:145-152` |
| [L-61.8](LEKTOR-61.md#l-61.8) | `Doku/ANWENDER.md` „nur was heute fehlt" führt Geschlossenes | **offen** | `Doku/ANWENDER.md:7` *„Hier steht nur, was heute fehlt."*, `:63` [E-101](../Intern/BEFUNDE.md#e-101) *„am 23.10.2026 geschlossen"* |
| [L-61.9](LEKTOR-61.md#l-61.9) | `ZIEL.md:166` nennt 7.2.0.120 | **offen** | `ZIEL.md:166` *„Stand 22.10.2026. Quellstand 7.2.0.120"* |
| [L-61.10](LEKTOR-61.md#l-61.10) | `TESTPLAN.md:251` alte Testzahl | **teilweise** | siehe [L-69.12](#l-69.12) |
| [L-61.11](LEKTOR-61.md#l-61.11) | Testpaket 7.2.0.123 ohne Prüfanleitung | **offen** (noch nicht fällig, aber vor dem Schnüren) | siehe [L-69.12](#l-69.12) |

Zwei ältere Funde derselben Klasse sind ebenfalls weiter offen und kehren
unten wieder: [L-55.1](LEKTOR-55.md#l-55.1) („Was noch fehlt" nennt bei
behobenen Befunden die Behebung, [L-69.5](#l-69.5)) und
[L-55.5](LEKTOR-55.md#l-55.5) ([E-77](../Intern/BEFUNDE.md#e-77) in `ZIEL.md` 2a als offen,
[L-69.6](#l-69.6)); dazu [L-56.3](LEKTOR-56.md#l-56.3):
`CHANGELOG.md:170-172` sagt zu [E-116](../Intern/BEFUNDE.md#e-116) (Bildbreite `35px`) weiter *„deshalb im
Befund ‚eingebaut', nicht ‚behoben'"*, während `Intern/BEFUNDE.md:362` *„behoben,
am laufenden Programm nicht nachstellbar — so geschlossen auf Gregors
Entscheidung vom 24.10.2026"* sagt (belegt).

---

## <a id="l-69.1"></a>L-69.1 — falsch: der Einleitungssatz zu *Bekannte Fehler* hält nach E-142 nicht mehr

* `README.md:141-142` (belegt): *„Bis auf die mit Selten beginnende Zeile geht
  in keinem dieser Fälle eine **Nachricht in Ihrem Postfach** verloren."*
* `README.md:168`, Spalte *Was kann verlorengehen* der neuen Zeile zu
  [E-142](../Intern/BEFUNDE.md#e-142) (Entwurf aus einem IMAP-Ordner nach
  `Out` gezogen ergibt eine leere Nachricht) (belegt): *„der **Entwurf**, wenn
  man das Original im IMAP-Ordner löscht, weil man es für verschoben hält"*.
  Ein Entwurf im IMAP-Ordner ist eine Nachricht im Postfach.
* [E-136](../Intern/BEFUNDE.md#e-136) (Zeichen außerhalb von windows-1252
  werden beim Speichern zu `?`, `:167`) ist dagegen **gedeckt**: der zweite
  Satz (`:142`) nennt *„verlorengehen oder verfälscht"*, und die Nachricht
  bleibt, nur ihre Zeichen nicht.

**Was zu tun wäre:** im Einleitungssatz auch die E-142-Zeile nennen (etwa
*„Bis auf die Zeile mit Selten und den Entwurf aus einem IMAP-Ordner …"*) —
oder die Zeile so fassen, wie es bei [E-129](../Intern/BEFUNDE.md#e-129)
(`:158`) geschieht: dort steht der Verlust nur unter *Was hilft* (*„Purge …
nicht benutzen – das entfernt sie"*), die Verlustspalte sagt *„nichts"*. Eine
der beiden Stellen muss sich ändern; so widersprechen sie sich.

## <a id="l-69.2"></a>L-69.2 — falsch: E-142 sagt im ersten Satz „Verloren geht nichts"

* `Intern/BEFUNDE.md:378`, Kurzfassung am Anfang des Urteils (belegt):
  *„Kurz: … Verloren geht nichts, das Original bleibt im IMAP-Ordner. Die
  Behebung fehlt noch."*
* Dieselbe Zeile weiter hinten (belegt): *„verschwunden ist nichts, solange
  das Original im IMAP-Ordner bleibt — wer es dort löscht, weil er es für
  verschoben hält, verliert den Entwurf."*; und Gregors Vereinbarung ebenda:
  *„daß bei dieser aktion mail inhalt verloren gehen kann"*.
* Der neue Programmtext sagt es ebenso (belegt, `EudoraRes.rc:7809`):
  *„The original stays in the IMAP mailbox - keep it until you have checked
  the copy."*

Die Kurzfassung ist der Teil, den Gregor liest (Lehre *Befund in Klartext*);
sie sagt das Gegenteil der README-Zeile, die am 26.10.2026 aus diesem Befund
geschrieben wurde. Dazu ist *„Die Behebung fehlt noch"* seit dem 26.10.2026
unvollständig: der vereinbarte Hinweis ist eingebaut, eine Behebung ist
ausdrücklich nicht vorgesehen.

## <a id="l-69.3"></a>L-69.3 — unvollständig: die Logzeile zu `rootcerts.p7b` und die neue Spurmarke stehen nur mit Schalter 32768 im Protokoll

**Was der Code tut** (belegt):

* `QCSocket/src/QCWorkerSocket.cpp:1977-1993` — `ProtokolliereRootCertsVerzeichnis`
  schreibt mit `PutDebugLog(DEBUG_MASK_MISC, szSpur)`.
* `QCUtils/src/debug.cpp:140-145` — `PutDebugLog` kehrt sofort zurück, wenn
  `(QCLogFileMT::DebugMask & ID) == 0`.
* `QCUtils/public/inc/debug.h:36` — `DEBUG_MASK_MISC = 0x8000` (32768).
* `Eudora/EudoraRes.rc:8463` — Vorgabe `"LogLevel\n25759"`; gerechnet:
  `25759 & 32768 = 0`, `58527 & 32768 = 32768` (gemessen mit `$((…))`).
* `tools/paket-bauen.ps1:623-630` setzt `LogLevel=58527` **nur** in die
  `Mailverzeichnis\Eudora.ini` des Pakets und nur, wenn dort noch keiner steht.
  `Doku/ANWENDER.md:375` sagt es selbst: *„Steht dort ‚keine E-nn-Marken',
  fehlt `DEBUG_MASK_MISC` (32768) im `LogLevel`, und keine einzige Spurmarke
  wird geschrieben"*.

**Was die Doku sagt** (belegt):

* `README.md:270-276`: *„Beim ersten verschlüsselten Abruf nach dem Start
  schreibt Eudora eine Zeile wie `rootcerts.p7b geladen aus: …` in die Datei
  `eudora.log` im Mailverzeichnis. … ‚FEHLT' heißt: …"* — ohne Bedingung.
* `CHANGELOG.md:128-133` und `Intern/BEFUNDE.md:383` ([E-148](../Intern/BEFUNDE.md#e-148)) ebenso.

**Was passiert.** Der Absatz richtet sich an Leute, die eine **eigene**
`rootcerts.p7b` in ihr Mailverzeichnis gelegt haben — also an Leute mit eigenem
Mailverzeichnis und damit meist eigener `Eudora.ini`. Steht dort kein `LogLevel`
oder einer ohne 32768, kommt die Zeile **nie**, auch nicht als *„FEHLT"*. Wer
nachsieht und nichts findet, kann daraus nichts schließen.

**Dieselbe Bedingung trifft die neue Spurmarke** zu *„Encountered an improper
argument"* (`Eudora/eudora.cpp:2053-2059`, ebenfalls `DEBUG_MASK_MISC`).
`Intern/WEITERMACHEN.md:315` (belegt): *„bleibt sie dort leer, gilt die Meldung
als verschwunden und Kriterium 2 und 4 als erfüllt"*; `ZIEL.md:191` ebenso
sinngemäß. Ob Gregors `Eudora.ini` den Schalter trägt, ist hier **nicht
gemessen** (**Vermutung:** ja, das Paket setzt ihn, und `Doku/ANWENDER.md:463`
leitet dazu an). Eine leere Spur zählt aber erst, wenn im selben Protokoll eine
andere `DEBUG_MASK_MISC`-Marke steht (Lehre *Ausbleiben ist kein Befund*).

**Was zu tun wäre:** in README, CHANGELOG und [E-148](../Intern/BEFUNDE.md#e-148) die Bedingung nennen
(*„sofern `LogLevel` den Schalter 32768 enthält, siehe Doku/ANWENDER.md"*) —
oder die Zeile ohne Maskenprüfung schreiben; das ist eine Bauentscheidung des
Hauptagenten. In `WEITERMACHEN.md:315` und `ZIEL.md:191` die Positivprobe
festschreiben: leer zählt nur neben einer anderen MISC-Marke im selben Lauf.

**Am Quelltext geprüft und richtig** (belegt): *„FEHLT heißt: in keinem der
beiden Verzeichnisse liegt eine rootcerts.p7b"* — `ChooseCertFileDirectory`
(`QCSSL/src/QCSSLContext.cpp:410-442`) fällt dann auf das Mailverzeichnis
zurück, `GetFileAttributes` findet dort nichts, die Zeile sagt `FEHLT`.
*„Einmal je Programmlauf"* — `InterlockedExchange(&s_lGeschrieben, 1)`
(`QCWorkerSocket.cpp:1984`). *„Beim ersten verschlüsselten Abruf"* ist eng
gefasst: der Aufruf sitzt in `InitializeQCSSL` (`:2012`) und läuft auch beim
verschlüsselten **Versand**; das schadet nicht.

## <a id="l-69.4"></a>L-69.4 — falsch: der CHANGELOG-Abschnitt sagt „auf `main` … bis PR #174"

* `CHANGELOG.md:97` (belegt): Überschrift *„Seit 7.2.0.122 auf `main`, kommt
  mit dem Testpaket 7.2.0.123 — Strg+W …, [E-150](../Intern/BEFUNDE.md#e-150), [E-148](../Intern/BEFUNDE.md#e-148), [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119),
  [E-116](../Intern/BEFUNDE.md#e-116), [E-130](../Intern/BEFUNDE.md#e-130)"*.
* `CHANGELOG.md:99` (belegt): *„Auf `main` seit PR #157 (23.10.2026) bis PR
  #174 (25.10.2026)"*.
* Gemessen (`git merge-base --is-ancestor <commit> origin/main`, nach `git
  fetch`): `e6ea91bd`, `e0e811f5` (Spurmarke), `4e065f5b` (E-142), `33c694d8`
  (Logzeile), `62f6047c` ([E-146](../Intern/BEFUNDE.md#e-146)) — **nicht** in `origin/main`; `origin/main`
  steht auf `07f181dc` (PR #175).
* Gemessen (`git log d28929ea..07f181dc -- '*.cpp' '*.rc' '*.h'`): [E-137](../Intern/BEFUNDE.md#e-137) kam
  mit **PR #175**, nicht bis #174 (`ed0d53a2`, `424966f6`, `78f2ad2a`).

**Antwort auf die gestellte Frage.** Die vier neuen Punkte (E-142-Hinweis,
Spurmarke, Logzeile, [E-146](../Intern/BEFUNDE.md#e-146)) stehen heute nur auf dem Zweig. Auf dem Zweig ist
*„auf `main`"* damit unwahr; mit dem Merge des PR wird es von selbst wahr —
**nicht** von selbst wahr wird *„bis PR #174"*, das schon jetzt um #175 zu kurz
ist und nach dem Merge um zwei. Die Überschrift zählt außerdem die vier neuen
Punkte nicht auf. **Vor dem PR zu berichtigen:** die PR-Spanne (*„bis PR #175
und dem PR aus `vor-testpaket-7.2.0.123`"*, die Nummer nach dem Anlegen
nachtragen) und die Aufzählung in der Überschrift. Wer lieber nichts
Künftiges behauptet: *„Seit 7.2.0.122, kommt mit dem Testpaket 7.2.0.123"*
ohne *„auf `main`"*.

## <a id="l-69.5"></a>L-69.5 — veraltet: E-146 ist behoben, „Was noch fehlt" nennt die Behebung

* `Intern/BEFUNDE.md:384`, Urteil (belegt): *„behoben auf dem Zweig
  `vor-testpaket-7.2.0.123` (26.10.2026) … die eine Namensrechnung (K8) am
  Quelltext belegt"*.
* Dieselbe Zeile, weiter hinten (belegt): *„**Was noch fehlt:** eine Rechnung
  statt zwei — `UpdateAfterRename` … übernimmt den Namen, den `RenameMailbox`
  … schon gebildet hat, als Ausgabeparameter; dazu ein Testfall mit Trenner NIL
  und einer mit Präfix."* — und im Präsens: *„Benennt man auf einem
  IMAP-Server ohne Ordnerhierarchie einen Ordner um, heißt er in Eudora danach
  falsch"*.
* Der erste Teil ist erledigt (belegt: `EuImap/src/ImapAccount.cpp:3078-3079`
  `*pstrNeuerImapName = strNewFullImapName;`). **Der zweite Teil ist es
  nicht** (belegt): `Tests/TestE146.cpp:43-96` prüft nur Textstellen im
  Quelltext (`QT_Enthaelt`), einen Fall mit Trenner NIL oder mit Präfix gibt es
  nicht; das Urteil sagt selbst *„am Programm nicht gemessen (der Prüfserver
  hat den Trenner `/`)"*.

**Was zu tun wäre:** „Was noch fehlt" auf den echten Rest kürzen — die beiden
Fälle ohne Trenner und mit Präfix, und das liegengebliebene Verzeichnis
`AblageAOQ` aus dem Rest-Satz —, den Präsens-Satz als *„Vorher:"* kennzeichnen.

**Dieselbe Klasse, weiter offen seit [L-55.1](LEKTOR-55.md#l-55.1)
(24.10.2026)** (belegt): `:324` [E-77](../Intern/BEFUNDE.md#e-77) *„**Was noch fehlt:** die Behebung — eine
Dekodierung … gibt es in `Eudora71/` nirgends"*; `:359` [E-113](../Intern/BEFUNDE.md#e-113) *„**Was noch
fehlt:** alles"*; `:365` [E-119](../Intern/BEFUNDE.md#e-119) *„**Was noch fehlt:** der Einbau"*. Alle drei
tragen im Urteil *„behoben"*, und genau diese drei sind am 26.10.2026 in der
README auf *„Behoben ab dem Release 7.2.1"* umgestellt worden. Dazu tragen
[E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119) und `:383` [E-148](../Intern/BEFUNDE.md#e-148) noch *„behoben auf dem Zweig
`e-…`"*, obwohl sie seit PR #163 bis #172 auf `main` sind
(`ZIEL.md:67-69` sagt es richtig).

## <a id="l-69.6"></a>L-69.6 — falsch: `ZIEL.md` 2a führt E-77 weiter als offen — die Zeile wurde heute bearbeitet

* `ZIEL.md:67` (belegt): [E-77](../Intern/BEFUNDE.md#e-77) *„IMAP-Ordnernamen mit Umlauten roh (**behoben**,
  auf `main` seit PR #165 …)"*.
* `ZIEL.md:191`, Zeile **2a** *„offen zu Kriterium 2"* (belegt): *„[[E-77](../Intern/BEFUNDE.md#e-77)]:
  IMAP-Postfachnamen mit Umlauten stehen roh da, `Entw&APw-rfe` statt
  Entwürfe"* — am 26.10.2026 in derselben Zeile um den Satz *„Stand
  26.10.2026: Gregor hat sie seit dem Fix nicht mehr gesehen …"* ergänzt
  (gemessen: `git diff 47d5f77..HEAD -- ZIEL.md`), [E-77](../Intern/BEFUNDE.md#e-77) blieb stehen.
* `ZIEL.md:199-202` (belegt): *„Was Kriterium 2 noch fehlt, steht vollständig
  in der Zeile 2a: [[E-77](../Intern/BEFUNDE.md#e-77)] (IMAP-Postfachnamen mit Umlauten) und die Meldung …"*.

Gemeldet als [L-55.5](LEKTOR-55.md#l-55.5) am 24.10.2026. Nach dem Stand von
`:67` fehlt Kriterium 2 nur noch die Meldung *„Encountered an improper
argument"* — und deren Prüfung hängt an [L-69.3](#l-69.3).

## <a id="l-69.7"></a>L-69.7 — unvollständig: die README nennt E-77 „behoben", die Behebung kostet älteren Nachrichten die Ablage

* `README.md:163` (belegt): *„Bis Paket 1.0.122: IMAP-Ordnernamen mit Umlauten
  stehen roh da | nichts | Behoben ab dem Release 7.2.1 …, auch beim Anlegen
  und Umbenennen"*.
* `Intern/BEFUNDE.md:324` (belegt): *„**Offen innerhalb von [E-77](../Intern/BEFUNDE.md#e-77):**
  gespeicherte Nachrichten mit Fcc auf einen Umlaut-Ordner, die vor 7.2.0.123
  entstanden, finden ihr Ziel nicht mehr; gesendet wird, die Ablage unterbleibt
  ohne Meldung ([K3](PRUEFER-49.md#k3))."*
* `Befunde/PRUEFER-49.md:369-382` (belegt, dort *„am Quelltext belegt, nicht
  gemessen"*): `FindByNamedPath` vergleicht mit dem neuen Anzeigenamen, findet
  den alten rohen Namen nicht, *„`if (pCommand != NULL)` überspringt die
  Ablage **ohne Meldung**"*; ebenso `IDS_INI_JUNK_TRIM_MAILBOX`.

**Was passiert.** Wer vor dem Update eine Nachricht in `Out` oder als
Briefpapier mit Ablage in `Entwürfe` (o. ä.) gespeichert hat, sendet sie
nach dem Update — die Kopie im Ordner fehlt, ohne Meldung. Das ist neu durch
die Behebung und betrifft genau die GMX-Anwender, für die [E-77](../Intern/BEFUNDE.md#e-77) behoben wurde.
Die README-Zeile sagt *„nichts"*. Seit [L-56.6](LEKTOR-56.md#l-56.6)
(24.10.2026) ist offen, ob K3 vor dem Paket behoben wird; entschieden ist es
nirgends (gemessen: `grep -n K3 Intern/WEITERMACHEN.md ZIEL.md
Intern/TESTPLAN.md` → kein Treffer).

**Was zu tun wäre:** entweder K3 vor 7.2.1 beheben (Nachschlagen auch unter
dem rohen Namen) oder eine eigene Zeile unter *Bekannte Fehler* mit Abhilfe
(*„Ablage-Ziel solcher Nachrichten vor dem Senden neu wählen"*). Nach der
Release-Definition (`ZIEL.md:27-28` *„Was dort nicht steht, muss gehen."*) ist
eines von beiden nötig — die Wahl ist Gregors (unten).

## <a id="l-69.8"></a>L-69.8 — falsch: „kommt immer wieder" — die Rechtschreibmeldung kommt einmal je Programmlauf

* `README.md:171` (belegt): *„Die Meldung, dass die Rechtschreibprüfung in
  dieser Fassung fehlt, kommt immer wieder – es gibt kein Kästchen ‚Nicht mehr
  anzeigen'"*.
* `Intern/BEFUNDE.md:388` (belegt): Gregors Messung *„1. start, neue mail:
  [Hinweis]. 2-te neue mail: kein hinweis. 2. start, neue mail: erneut
  hinweis."* und *„Die Meldung kommt damit heute schon einmal je Lauf"*.
* Code (belegt): `Eudora/spell.cpp:56` `static BOOL s_bHinweisGezeigt = FALSE;`,
  `:60-61` `if (s_bHinweisGezeigt) return;`.

**Was zu tun wäre:** *„kommt nach jedem Programmstart einmal wieder"*. Die
Spalte *Was hilft* (*„mit OK wegklicken"*) stimmt.

## <a id="l-69.9"></a>L-69.9 — veraltet: `WEITERMACHEN.md` schickt in den Zweig `RC1_vorbereiten` und zu erledigten Schritten

* `Intern/WEITERMACHEN.md:132` (belegt): *„**Stand 25.10.2026 abends – HIER
  WEITERMACHEN, Zweig `RC1_vorbereiten`** … Auf `main`: PR #174"*.
  `RC1_vorbereiten` ist mit PR #175 gemergt (gemessen: `git log -1
  origin/main` → `07f181dc Merge pull request #175 from
  HansWurst81675/RC1_vorbereiten`); gearbeitet wird auf
  `vor-testpaket-7.2.0.123` (`tools/ZWEIGE.md`, Zeile vom 26.10.2026).
* `:139` (belegt): *„als Nächstes von 2. noch [E-142](../Intern/BEFUNDE.md#e-142) und [E-146](../Intern/BEFUNDE.md#e-146), dann 3.–4., dann
  die Funde aus [LEKTOR-61](LEKTOR-61.md#lektor-61), dann Testpaket 7.2.0.123"* — [E-142](../Intern/BEFUNDE.md#e-142), [E-146](../Intern/BEFUNDE.md#e-146) und 3.
  (Logzeile) sind laut `:135-136` desselben Blocks seit dem 26.10.2026
  eingebaut.

Die Entscheidungspunkte 2, 3 und 6 selbst (`:135-137`) stimmen mit `BEFUNDE.md`
und dem Code überein (belegt: [E-142](../Intern/BEFUNDE.md#e-142) `tocdoc.cpp:2785`, Logzeile
`QCWorkerSocket.cpp:2012`, [E-146](../Intern/BEFUNDE.md#e-146) `ImapAccount.cpp:3078`); 6 (Message-ID) ist
eine Entscheidung ohne Befund und so eingetragen. Nur der Kopf und die
Reihenfolge sind von gestern.

**Was zu tun wäre:** Kopf auf den Zweig `vor-testpaket-7.2.0.123` und
`origin/main` = PR #175; *Reihenfolge* auf das, was noch fehlt (Funde aus
[LEKTOR-61](LEKTOR-61.md#lektor-61) und diesem Bericht, Prüfanleitung, Testpaket).

## <a id="l-69.10"></a>L-69.10 — unvollständig: der Prüfbericht verweist nicht auf Gregors Ergebnisse, und es gibt sie je Kriterium noch nicht

* Verlangt (belegt, `ZIEL.md:31-34`): *„Releases/PRUEFBERICHT.md für alles
  Automatische … und die Ergebnisse von Gregors Test je Kriterium. Ein Release
  ohne dokumentierte Ergebnisse gibt es nicht."*
* `Releases/PRUEFBERICHT.md:452-457` (belegt): *„Was dieser Bericht nicht
  abdeckt: Die manuellen Faelle in TESTPLAN.md, Teil M. … Ein Release gilt erst
  nach Gregors eigenem Lauf … dieser Bericht ersetzt das nicht."* — kein
  Verweis auf `Intern/TESTPLAN.md:255` *„Buchführung — was wann an welchem
  Paket bestätigt wurde"*, den einzigen Ort, an dem Gregors Ergebnisse heute
  stehen.
* Die Buchführung führt **je Paket und Befund**, nicht je Kriterium (belegt,
  `TESTPLAN.md:257`, ein einziger Absatz von 1.0.89 bis 1.0.122); einen Ort je
  Kriterium gibt es weiter nicht ([L-61.5](LEKTOR-61.md#l-61.5), offen).
  `tools/ZWEIGE.md` (Zeile `vor-testpaket-7.2.0.123`) nennt *„Release-Gerüst
  (Ort für Gregors Testergebnisse, Kriterientabelle neu messen)"* als Inhalt
  dieses Zweigs — **noch nicht gebaut** (gemessen: `grep -rn "je Kriterium"`
  außerhalb von `Befunde/` und `Arbeitsweise/` trifft nur `ZIEL.md:33` und
  `LEKTORAT.md`).

**Gemessen und richtig:** die Zahlen 307/19/34 (`PRUEFBERICHT.md:22-24`)
stimmen mit dem Kopf (Bau `1.0.122+2fbc35d4`, `:19`) und mit der
Commit-Nachricht von `f3e8389c`; 34 Fälle *„0 an anderem Bau, 0 nie
gelaufen"*.

**Was zu tun wäre:** in `pruefbericht.pl` (Abschnitt 5 wird erzeugt) einen
Verweis auf den Ort von Gregors Ergebnissen; den Ort selbst je Kriterium
anlegen, bevor das Testpaket an Gregor geht — sonst hat sein Lauf am
Testpaket keinen Platz.

## <a id="l-69.11"></a>L-69.11 — Hinweis: vier README-Zeilen sagen mehr, als gemessen ist

Keine dieser Aussagen ist widerlegt; sie stehen aber ohne Kennzeichnung da,
wo der Befund selbst *„nicht gemessen"* sagt.

* **[E-142](../Intern/BEFUNDE.md#e-142), *Was hilft*** (`README.md:168`, belegt): *„den Entwurf im
  IMAP-Ordner öffnen und von dort senden"*. In `BEFUNDE.md:378` steht kein
  Lauf dieses Wegs. Ob *Send* aus einem Entwurf in einem IMAP-Ordner einen
  anderen Weg nimmt als das Ziehen nach `Out`, ist hier **nicht verfolgt**
  (**Vermutung:** es reiht ebenfalls nach `Out` ein). Eine Anweisung an
  Anwender, die niemand gefahren hat (Lehre *Erst prüfen, dann anweisen*).
* **[E-143](../Intern/BEFUNDE.md#e-143)** (`:170`): *„ein solcher Filter hält den automatischen Mailabruf an,
  bis man klickt"* — `BEFUNDE.md:379` *„am Quelltext belegt, am laufenden
  Programm nicht gemessen"*. Die README kennzeichnet solches sonst
  (`:155` *„Selten, vermutet"*).
* **[E-136](../Intern/BEFUNDE.md#e-136)** (`:167`): *„mit Emoji oder mit Zeichen außerhalb des
  westeuropäischen Zeichensatzes (Kyrillisch, Griechisch, Chinesisch …)"* —
  gemessen ist **ein** Emoji, das das Plug-in EudoraUnicodeFix als
  HTML-Entität geschrieben hatte (`BEFUNDE.md:391`, *„Die Kette, dreifach
  gemessen"*); die übrigen Schriften und der Weg ohne Plug-in sind
  erschlossen. Zudem fehlt der Hinweis, dass solche Zeichen in Eudora
  überhaupt nur als HTML-Entität sichtbar werden (sonst streicht sie schon
  `ISOTranslate` beim Lesen, [E-90](../Intern/BEFUNDE.md#e-90), `:164`).
* **[AN-1](../Intern/BEFUNDE.md#an-1)** (`:172`): *„nichts – die Datei ist vollständig"* deckt sich mit dem
  Urteil (`BEFUNDE.md:256` *„verloren geht nichts, man muss die Datei
  umbenennen"*), aber nicht mit der Stufe in derselben Zeile: *„Stufe:
  kritisch (Datenschaden: Anhang ohne Endung ist nicht mehr zu oeffnen)"*. Der
  Widerspruch steht im Befund, nicht in der README.

Dazu, ohne README-Folge: die E-142-Zeile verschweigt, dass nach *„Ja"* weiter
*„No messages were transferred!"* erscheint (`BEFUNDE.md:378`: nur *„No"*
unterdrückt die IMAP-Nachbearbeitung; [E-141](../Intern/BEFUNDE.md#e-141) ist
offen). Wer nach *Ja* diese Meldung liest, hält das Original erst recht für
unbewegt — das stützt die Abhilfe, verwirrt aber.

## <a id="l-69.12"></a>L-69.12 — veraltet: der Testplan steht auf 1.0.122 und 301 Tests

* `Intern/TESTPLAN.md:1` (belegt): *„Stand 25.10.2026"*; `:6-8` *„Was jetzt zu
  testen ist — Im Moment nichts."*
* `:251` (belegt): *„am 25.10.2026: **301 Tests, 301 bestanden** auf
  `796369bb`"* — der Prüfbericht nennt 307 auf `2fbc35d4`
  (`Releases/PRUEFBERICHT.md:22`). Die Zeile sagt selbst, die Zahl *„gehört aus
  `tools/pruefbericht.pl` erzeugt, nicht von Hand gepflegt"*.

Für das Paket 1.0.122, das Gregor heute hat, ist *„nichts"* richtig. Auf dem
Zweig liegen aber sieben Dinge, die nur Gregor am Programm prüfen kann
(gemessen an den Urteilen: [E-137](../Intern/BEFUNDE.md#e-137) *„am Programm noch nicht gemessen"*, [E-142](../Intern/BEFUNDE.md#e-142)
Hinweis, Logzeile, Spurmarke *improper argument*, [E-77](../Intern/BEFUNDE.md#e-77)/[E-113](../Intern/BEFUNDE.md#e-113)/[E-119](../Intern/BEFUNDE.md#e-119) *„von Gregor
noch nicht bestätigt"*, `ZIEL.md:67-69`). Die Prüfanleitung dazu gehört vor
das Schnüren ([L-61.11](LEKTOR-61.md#l-61.11)), mit Ort je Schritt (Lehre
*Testschritt nennt den Ort*) und — wegen [L-69.3](#l-69.3) — mit dem Satz,
dass `LogLevel` 32768 enthalten muss.

---

## Geprüft, kein Fund

* **README, neue Zeilen gegen `BEFUNDE.md`** (belegt): [E-144](../Intern/BEFUNDE.md#e-144) (`:169` gegen
  `:386`: lokales Postfach, `In-Reply-To`/`References`, „Text und Betreff
  bleiben"), [E-143](../Intern/BEFUNDE.md#e-143) (`:170` gegen `:379`: je Nachricht, Suchfenster und
  Filter), [AN-1](../Intern/BEFUNDE.md#an-1) (`:172` gegen `:256`: nur ohne Endung, nur IMAP), [E-136](../Intern/BEFUNDE.md#e-136)
  (`:167`: Strg+S, Fragezeichen, nicht rückgängig) — Inhalt und Urteil
  stimmen, *Was hilft* ist ausführbar (Ausnahmen in [L-69.11](#l-69.11)).
* **Die drei umgestellten Zeilen** [E-119](../Intern/BEFUNDE.md#e-119) (`:160`), [E-113](../Intern/BEFUNDE.md#e-113)/[E-116](../Intern/BEFUNDE.md#e-116) (`:161`), [E-77](../Intern/BEFUNDE.md#e-77)
  (`:163`): das Urteil ist in allen Befunden *„behoben"*, `ZIEL.md:67-70`
  ebenso; *„schon im Testpaket 7.2.0.123"* stimmt (alle auf `main` seit PR
  #157 bis #170). Zu E-77 siehe [L-69.7](#l-69.7).
* **E-142-Hinweis gegen Code** (belegt): Text `EudoraRes.rc:7808-7809` wörtlich
  wie in `BEFUNDE.md:378`; *„einmal je Vorgang"* — `E142Gefragt` ist lokal in
  `CTocDoc::Xfer` (`tocdoc.cpp:2646`); *„No überträgt nichts und unterdrückt die
  IMAP-Nachbearbeitung"* — `E142Abgebrochen` in der Bedingung `:3166`;
  Protokollzeile `:2791`.
* **[E-146](../Intern/BEFUNDE.md#e-146) gegen Code** (belegt): `ImapAccount.cpp:3024-3048` bildet den Namen
  auch für Trenner `'\0'` richtig (*„No hierarchy. Use basename as is."*) und
  gibt ihn zurück (`:3078-3079`); CHANGELOG `:135-143` behauptet nichts
  Ungemessenes.
* **`ZIEL.md:191`, Satz zur Spurmarke** (belegt): `CEudoraApp::ProcessWndProcException`
  schreibt `Ausnahme in Fensterbotschaft (ZIEL 2/4)` (`eudora.cpp:2053`) und
  ruft danach die MFC (`:2061`) — *„Verhalten sonst unverändert"* stimmt;
  Prüfstandsfall `ZIEL24` steht im Prüfbericht (`PRUEFBERICHT.md:442`).
* **`WEITERMACHEN.md` Punkte 2, 3, 6** — siehe [L-69.9](#l-69.9).

## Nicht geprüft

* `Doku/HINTERGRUND.md`, `MELDUNGEN-VON-AUSSEN.md`, `Releases/1.0.*/`,
  `Releases/ISSUE-102-*.md`: Archiv bzw. seit `47d5f77` unverändert, von
  `doku-pruefen.pl` nur als „nennt den Quellstand nicht" gemeldet; nicht
  einzeln gelesen.
* Der Inhalt von PRÜFER-58 (läuft laut `tools/AGENTEN-LAUFEN.md` seit 08:01;
  `Befunde/PRUEFER-58.md` und E-154/E-155 gibt es im Baum noch nicht —
  gemessen).
* Die Behauptung *„Schlüsseln von nur 3 bis 8 Bit"* (`README.md:220`,
  `CHANGELOG.md:156`) stammt aus dem verlinkten Artikel; nicht gegen die
  Quelle gelesen.

## Was nur Gregor entscheiden kann

1. **[E-77](../Intern/BEFUNDE.md#e-77), alte Ablageziele ([L-69.7](#l-69.7)).** Nach dem Update auf 7.2.1
   werden Nachrichten, die **vorher** mit Ablage in einen IMAP-Ordner mit
   Umlaut gespeichert wurden (etwa „Entwürfe" bei GMX), gesendet, aber ihre
   Kopie landet ohne Meldung nirgends. Soll das vor 7.2.1 behoben werden, oder
   genügt eine Zeile unter *Bekannte Fehler* mit der Abhilfe „Ablageziel vor
   dem Senden neu wählen"?
2. **Drei offene Befunde, die weder behoben noch in der README stehen
   ([L-61.2](LEKTOR-61.md#l-61.2), teilweise).** [E-141](../Intern/BEFUNDE.md#e-141)
   — eine Übertragung aus einem IMAP-Ordner nach `Out` kann auf dem Server ein
   `EXPUNGE` auslösen und damit Nachrichten endgültig entfernen, die ein
   anderes Programm als gelöscht markiert hat; [E-140](../Intern/BEFUNDE.md#e-140)
   — *File → Save As* aus Nachrichten- und Verfassen-Fenster schreibt ohne
   Zeichensatzangabe; [E-145](../Intern/BEFUNDE.md#e-145) — Base64-Dekodieren
   wertet Bytes über 127 als gültige Zeichen. Am 25.10.2026 hast du fünf
   Befunde für die README benannt, diese drei nicht. Heißt das „vor 7.2.1
   beheben", „in die README" oder „für den Anwender nicht sichtbar, bleibt
   draußen"?
