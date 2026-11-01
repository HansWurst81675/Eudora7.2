# <a id="lektor-119"></a>LEKTOR-119 — Kurzlauf vor dem PR, Zweig e184_imap_zusammenfassung nach 8b5f8342 (01.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-118](LEKTOR-118.md#lektor-118).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261101i`, Stand `8b5f8342`.

## Kurz

Von den neun Funden aus [LEKTOR-118](LEKTOR-118.md#lektor-118) sind sechs erledigt. Drei sind durch
den neuen Commit wieder veraltet, und zwar an denselben Stellen: Die Zeilennummern der
zwei anderen Aufrufer bei [E-184](../Intern/BEFUNDE.md#e-184) (beim Verschieben im IMAP-Konto wurde die
Zusammenfassung einer fremden Mail überschrieben) stimmen nicht mehr, weil die Behebung von
[E-189](../Intern/BEFUNDE.md#e-189) noch einmal 34 Zeilen in `ImapToc.cpp` eingefügt hat ([L-119.1](#l-119.1)). Dem WEITERMACHEN-Kopf
fehlten [E-189](../Intern/BEFUNDE.md#e-189) und [E-188](../Intern/BEFUNDE.md#e-188) ([L-119.2](#l-119.2)). Die Zahl der Prüfberichte in der README war wieder
zu niedrig ([L-119.3](#l-119.3)).

Die neue Buchführung ([E-188](../Intern/BEFUNDE.md#e-188), [E-189](../Intern/BEFUNDE.md#e-189), [E-184](../Intern/BEFUNDE.md#e-184) nur teilweise, README „Bekannte Fehler“,
Begründung zu PRÜFER-72 K2 bei [E-143](../Intern/BEFUNDE.md#e-143)) stimmt in der Sache mit Code und Commit.
Die Stellen habe ich am Quelltext nachgeprüft. Alle vier Werkzeuge sind grün, 46 Befunde
offen.

Acht Funde, keiner am Programm. **Sechs habe ich im selben Commit berichtigt.** Die
übrigen zwei habe ich auf Auftrag des Hauptagenten im zweiten Commit berichtigt. Die erzeugten Listen in CHANGELOG und WEITERMACHEN enthalten einen toten
Verweis `(#e-184)`; das liegt am Erzeuger `offene-befunde.pl` ([L-119.7](#l-119.7)). Und der „Kurz“-Satz von
[E-189](../Intern/BEFUNDE.md#e-189) behauptet als Tatsache, dass der Abgleich die Kopie nicht wegräumt. Die README sagt
dazu „vermutlich“, und abgelegte Werte, die das belegen, habe ich nicht gefunden ([L-119.8](#l-119.8)).

## Funde aus LEKTOR-118

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-118.1](LEKTOR-118.md#l-118.1) [E-184](../Intern/BEFUNDE.md#e-184) in den erzeugten Listen „nie gemessen“ | erledigt | `CHANGELOG.md:32` und `Intern/WEITERMACHEN.md:80` *„01.11.2026 an 7.2.1.130“* |
| [L-118.2](LEKTOR-118.md#l-118.2) Zeilen der zwei anderen Aufrufer bei [E-184](../Intern/BEFUNDE.md#e-184) | **wieder veraltet, berichtigt im selben Commit** | siehe [L-119.1](#l-119.1) |
| [L-118.3](LEKTOR-118.md#l-118.3) „Kurz“-Satz erklärte die widerlegte Ursache | erledigt | `Intern/BEFUNDE.md:401` *„es sucht seine eigene Vorab-Kopie im Ziel unter der ALTEN Nummer“* |
| [L-118.4](LEKTOR-118.md#l-118.4) WERKZEUGE ohne `EXISTS`, Kopf des Prüfservers | erledigt, auch der Kopf | `tools/WERKZEUGE.md:180`; `tools/imap-pruefserver.pl:70` *„# EXISTS (seit 01.11.2026, [E-184](../Intern/BEFUNDE.md#e-184)): aendert sich die Nachrichtenzahl …“* |
| [L-118.5](LEKTOR-118.md#l-118.5) Kopf von `messen-e184.ps1`: „Nie gemessen“ | erledigt | `tools/messen-e184.ps1:13` *„# GEMESSEN am 01.11.2026: rot an 7.2.1.130 (fremd=0), gruen mit der Behebung.“*, `:14-16` die richtige Ursache |
| [L-118.6](LEKTOR-118.md#l-118.6) Datum des ersten Endlos-Ersetzers | erledigt | unverändert seit meinem Commit `420b8b02` |
| [L-118.7](LEKTOR-118.md#l-118.7) WEITERMACHEN-Kopf ohne Behebung von [E-184](../Intern/BEFUNDE.md#e-184) | erledigt, **jetzt unvollständig** | siehe [L-119.2](#l-119.2) |
| [L-118.8](LEKTOR-118.md#l-118.8) README: [E-184](../Intern/BEFUNDE.md#e-184) fehlt unter „Bekannte Fehler“ | erledigt | `README.md:167` ([E-184](../Intern/BEFUNDE.md#e-184)), `:168` ([E-189](../Intern/BEFUNDE.md#e-189)) |
| [L-118.9](LEKTOR-118.md#l-118.9) README-Zahl der Prüfberichte | **wieder falsch, berichtigt im selben Commit** | siehe [L-119.3](#l-119.3) |

## Was seit 420b8b02 dazukam

Gelesen: `git log --stat 420b8b02..HEAD`. Das sind fünf Commits, davon zwei Merges (meiner
und der von PRÜFER-75). Dazu `df533cb9` (Prüfstand, fünf IMAP-Fälle) und `8b5f8342`
(Behebung [E-189](../Intern/BEFUNDE.md#e-189), Buchführung). Gelesen habe ich alle geänderten Zeilen außerhalb von
`Eudora71/` und `Arbeitsweise/`. Vom Quelltext habe ich nur die Stellen gelesen, die die Doku
nennt. Den Code selbst beurteilt der PRÜFER.

| Angabe | Stelle | Ergebnis |
|---|---|---|
| [E-188](../Intern/BEFUNDE.md#e-188): zwei weitere Stellen suchen unter der alten UID | `Intern/BEFUNDE.md:400` *„`EuImap/src/ImapToc.cpp:1302` … und `:1196`“*, *„`summary.cpp:612`“* | stimmt: `ImapToc.cpp:1196` und `:1302` je *„CSummary *pCopySum = pTargetToc->GetSummaryFromUID(pSum->GetHash());“*; `summary.cpp:612` *„m_Hash = NewInfo->m_Hash;“* (gemessen) |
| [E-184](../Intern/BEFUNDE.md#e-184) nur halb behoben: vom `COPYUID` wird nur der Zielteil gelesen | `Intern/BEFUNDE.md:401` *„`proto.cpp:2138-2150`“* | stimmt: `Imapdll/src/proto.cpp:2138` *„// next block is the range of messages transferred“*, der Block wird übersprungen, `:2150` *„UIDStringToUIDs(s, e-s, dwaNewUIDs);“* für den letzten Block (gemessen) |
| [E-189](../Intern/BEFUNDE.md#e-189): Behebung direkt nach `ImapTransferSummaryData` | `Intern/BEFUNDE.md:399` | stimmt: `ImapActionQueue.cpp:1612` ruft `ImapTransferSummaryData`, `:1624` *„E189VorabKopienEntfernen(m_pDestTocDoc, m_szMessageIDs);“*; die Funktion steht in `ImapToc.cpp:1749` (gemessen) |
| [E-189](../Intern/BEFUNDE.md#e-189) rot an 7.2.1.130, grün mit der Behebung; Gegenprobe | `Intern/BEFUNDE.md:399`; `CHANGELOG.md:113`; Commit `8b5f8342` | `Intern/pruefstand-buch.tsv`: *„[E-189](../Intern/BEFUNDE.md#e-189) ok 2026-11-01 18:13:22 … 7.2.1.130+8c904144* … kopie-neu=1 kopie-mit-alter-uid=0 eintraege=2“*. `tools/TESTLAEUFE.md`: sechs Starts mit `8c904144*` (18:08 bis 18:14), zwei mit `955d50d4*` (18:16:39, 18:18:14), das passt zu „beide rot“ (gemessen). Werte der zwei Gegenproben stehen nirgends, siehe [L-119.8](#l-119.8) |
| Stufe von [E-189](../Intern/BEFUNDE.md#e-189) | `Intern/BEFUNDE.md:399` *„**Stufe: kritisch** (solange die Löschvermutung nicht widerlegt ist …)“* | PRÜFER-75 führt K2 als *„wichtig“* (`Befunde/PRUEFER-75.md`, Tabelle am Ende). Einstufen darf der Hauptagent; die Stufentabelle (`Intern/BEFUNDE.md:158-162`) zählt [E-189](../Intern/BEFUNDE.md#e-189) mit, 10 kritische offen (gemessen). Kein Fund |
| PRÜFER-72 K2 ohne Code, Begründung bei [E-143](../Intern/BEFUNDE.md#e-143) | `Intern/BEFUNDE.md` [E-143](../Intern/BEFUNDE.md#e-143) *„so hält es Eudora auch bei Filtern ganz ohne Übertragung (`filtersd.cpp`, `pDestToc = Sum->m_TheToc` nach der Schleife)“* | stimmt: `filtersd.cpp:1665-1668` *„if (Sum && !pDestToc) { pDestToc = Sum->m_TheToc; }“* hinter der Aktionsschleife; der Verweis `../Befunde/PRUEFER-72.md#k2` trifft den Anker (`PRUEFER-72.md:169`) (gemessen) |
| README „Bekannte Fehler“, [E-184](../Intern/BEFUNDE.md#e-184) | `README.md:167` *„im Postfachfenster Rechtsklick auf den Ordner → *Resynchronize Mailbox*“* | den Menüpunkt gibt es: `EudoraRes.rc:6159` *„MENUITEM "Re&synchronize Mailbox", ID_MBOXTREE_IMAP_RESYNC“* im Kontextmenü des Postfachbaums (gemessen) |
| `messen-e184.ps1 -OhneCopyuid`, `messen-e189.ps1`, Fall [`E-189`](../Intern/BEFUNDE.md#e-189) | Diff; `tools/pruefstand-faelle.txt` (Block nach [`E-184`](../Intern/BEFUNDE.md#e-184)); `tools/WERKZEUGE.md:140` | stimmen untereinander: Erwartung, Prüfstand `C:\Temp\E184`, Zeitschranke 20 s. Kopf und Werkzeugliste nannten das Messergebnis ungenau: [L-119.4](#l-119.4), [L-119.5](#l-119.5) |
| CHANGELOG „Im Quellstand, noch in keinem Paket“ | `CHANGELOG.md:110-116` | in der Sache wie BEFUNDE und Commit; die Werkzeugzeile ohne `messen-e189.ps1`: [L-119.6](#l-119.6) |
| `Intern/pruefstand-ergebnis.txt` | Diff in `8b5f8342` | zeigt jetzt den letzten Teillauf: die Gegenprobe am Paketbau, *„fall=[FEHL] [E-184](../Intern/BEFUNDE.md#e-184)“*. Die Datei kennt nur den letzten Lauf (`tools/pruefstand-lauf.ps1:419`), `pruefbericht.pl` nimmt sie aus. Zur Kenntnis, kein Fund |

## Funde

### <a id="l-119.1"></a>L-119.1 — E-184: Zeilennummern der zwei anderen Aufrufer zum zweiten Mal veraltet

**Gewicht: Kleinkram.** Auch PRÜFER-75 K6 hatte das schon gemeldet („Zeilennummern im Eintrag
veraltet“). (gemessen)

**Berichtigt im selben Commit:** `Intern/BEFUNDE.md:401` *„(`ImapToc.cpp:2784`, `:3090`; vor den
Behebungen von [E-184](../Intern/BEFUNDE.md#e-184) und [E-189](../Intern/BEFUNDE.md#e-189) `:2728`, `:3034`)“*. Dazu habe ich die Marke ergänzt: *„… Bau `4593ab89*`,
zuletzt Bau `8c904144*` mit der Behebung von [E-189](../Intern/BEFUNDE.md#e-189)“*. So ist der jüngste grüne Lauf im
Prüfstandsbuch genannt.

Vorher: *„`ImapToc.cpp:2750`, `:3056`“*. Heute gemessen: `ImapToc.cpp:2784`
*„ImapTransferSummaryData(sUidlist, pTargetToc, &dwaNewUIDs);“* und `:3090`
*„ImapTransferSummaryData(strUIDList, pTargetToc, &dwaNewUIDs, pImapSum);“*. Ursache: [E-189](../Intern/BEFUNDE.md#e-189) fügt
`E189VorabKopienEntfernen` (`:1749`) vor beiden ein.

Das ist schon das zweite Mal ([L-118.2](LEKTOR-118.md#l-118.2)). Feste Zeilennummern in einem Befund, dessen Datei
gerade geändert wird, veralten mit jeder Behebung. **Vorschlag:** bei Aufrufern den Namen der
rufenden Funktion nennen statt der Zeile.

### <a id="l-119.2"></a>L-119.2 — WEITERMACHEN-Kopf: E-189 und E-188 fehlten, E-184 stand als ganz behoben da

**Gewicht: mittel.** Der Kopf ist der Einstieg nach einem Neustart. Wer ihn liest, hielt [E-184](../Intern/BEFUNDE.md#e-184)
für erledigt und wusste nichts vom kritischen [E-189](../Intern/BEFUNDE.md#e-189). (gemessen)

**Berichtigt im selben Commit:** `Intern/WEITERMACHEN.md:3` lautet jetzt *„Seit dem Merge von #196
im Quellstand, noch in keinem Paket (Zweig `e184_imap_zusammenfassung`; am Prüfstand je rot an
7.2.1.130, grün mit der Behebung): die Behebung von [E-184](../Intern/BEFUNDE.md#e-184) (nur teilweise — mehrere Mails in nicht
aufsteigender Reihenfolge bekommen die neuen Nummern weiter über Kreuz) und die von [E-189](../Intern/BEFUNDE.md#e-189)
(dasselbe Verschieben an einem Server ohne UIDPLUS); beide Befunde bleiben bis zum Paket offen.
Neu, nur am Quelltext: [E-188](../Intern/BEFUNDE.md#e-188) (…)“*.

Vorher stand dort nur der Satz aus [L-118.7](LEKTOR-118.md#l-118.7) zu [E-184](../Intern/BEFUNDE.md#e-184). Commit `8b5f8342` hat in WEITERMACHEN
nur die erzeugte Tabelle geändert (`git show --stat`: 3 Zeilen dazu, 1 weg, alle in der Tabelle).

### <a id="l-119.3"></a>L-119.3 — README: Zahl der Prüfberichte wieder zu niedrig

**Gewicht: Kleinkram.** (gemessen)

**Berichtigt im selben Commit:** `README.md:98` *„191 LEKTOR- und PRÜFER-Berichte“*.

Am Stand `8b5f8342` sind es `git ls-files Befunde | grep -cE '/LEKTOR-[0-9]+\.md$'` → 117 und
für PRÜFER → 73, zusammen 190. Mit diesem Bericht werden es 191. Die 124 Lehren stimmen
weiter: seit `420b8b02` ist unter `Arbeitsweise/` keine Lehre dazugekommen (`git log
--diff-filter=A`). Das ist dieselbe Altlast wie [L-117.5](LEKTOR-117.md#l-117.5)/[L-118.9](LEKTOR-118.md#l-118.9): Die Zahl veraltet mit jedem
Prüfbericht. **Vorschlag** (zum dritten Mal): streichen oder aus einem Werkzeug erzeugen.

### <a id="l-119.4"></a>L-119.4 — Kopf von `messen-e189.ps1` ohne Messergebnis

**Gewicht: Kleinkram.** Genau das war beim Kopf von `messen-e184.ps1` der Fund [L-118.5](LEKTOR-118.md#l-118.5). (gemessen)

**Berichtigt im selben Commit** (reines ASCII, nachher gemessen: `>127 0`, `nur-LF 23`, vorher
21): nach der erwarteten Zeile *„# GEMESSEN am 01.11.2026: rot an 7.2.1.130 (Quellstand 4593ab89*:
zwei / # Eintraege mit uid=1, kopie-neu=0), gruen mit der Behebung (Bau 8c904144*).“* Die Werte
stammen aus `Intern/BEFUNDE.md:399` und `Intern/pruefstand-buch.tsv`.

Das *„vermutlich“* in `tools/messen-e189.ps1:5` und `tools/messen-e184.ps1:49` (*„ueberlebt … vermutlich den
Abgleich“*) habe ich **stehen lassen**, siehe [L-119.8](#l-119.8).

### <a id="l-119.5"></a>L-119.5 — WERKZEUGE: das rote Ergebnis von `messen-e189.ps1` dem falschen Bau zugeschrieben

**Gewicht: Kleinkram.** (gemessen)

**Berichtigt im selben Commit:** `tools/WERKZEUGE.md:140` *„an 7.2.1.130 rot (Quellstand
`4593ab89*`: zwei Einträge mit UID 1; Gegenprobe am Paketbau `955d50d4` ebenfalls rot), grün mit
der Behebung (Bau `8c904144*`)“*.

Vorher: *„am Paketbau 7.2.1.130 rot (zwei Einträge mit UID 1)“*. Laut `Intern/BEFUNDE.md:399` und
`tools/pruefstand-faelle.txt` (Kommentar zu [`E-189`](../Intern/BEFUNDE.md#e-189), *„Gemessen an 7.2.1.130 (Quellstand 4593ab89*
mit E-184-Behebung): zwei Eintraege mit UID 1“*) stammen die zwei Einträge mit UID 1 vom
Quellstand. Vom Paketbau steht nur „rot“ da (Commit `8b5f8342`).

### <a id="l-119.6"></a>L-119.6 — CHANGELOG: `messen-e189.ps1` fehlte in der Werkzeugzeile

**Gewicht: Kleinkram.** (gemessen)

**Berichtigt im selben Commit:** `CHANGELOG.md:116` *„`tools/messen-e184.ps1` und die Hülle
`tools/messen-e189.ps1` (Prüfstandsfälle [`E-184`](../Intern/BEFUNDE.md#e-184), [`E-189`](../Intern/BEFUNDE.md#e-189))“*.

**Ebenfalls berichtigt** (kein Fund, nur nachgezogen): Die Zeile des Zweigs in
`tools/ZWEIGE.md:204` nennt jetzt, was im Lauf dazukam: [E-189](../Intern/BEFUNDE.md#e-189), [E-188](../Intern/BEFUNDE.md#e-188) und PRÜFER-72 K2 ohne Code.
Vorher endete sie beim Plan.

### <a id="l-119.7"></a>L-119.7 — Toter Verweis `(#e-184)` in den erzeugten Listen

**Gewicht: Kleinkram, Werkzeug.** (gemessen)

**Berichtigt im zweiten Commit** (Auftrag des Hauptagenten): Im Titel von [E-188](../Intern/BEFUNDE.md#e-188)
(`Intern/BEFUNDE.md:400`) steht jetzt *„Dieselbe Verwechslung wie [E-184](../Intern/BEFUNDE.md#e-184) an zwei weiteren
Stellen …“*, als reiner Text ohne Verweis. Danach habe ich `perl tools/offene-befunde.pl
-schreiben` laufen lassen: `grep -c '(#e-184)'` → 0 in `CHANGELOG.md` und in
`Intern/WEITERMACHEN.md` (gemessen). Einen weiteren reinen Anker gibt es in keiner erzeugten
Zeile; gesucht habe ich mit `grep -n '](#'`. Die übrigen Treffer stehen außerhalb der
erzeugten Blöcke und treffen ihren Anker. Das Werkzeug selbst ist unverändert. Ein neuer Titel
mit einem reinen Anker würde wieder durchrutschen.

Ursprünglicher Fund:

`CHANGELOG.md:31` und `Intern/WEITERMACHEN.md:79`: *„Dieselbe Verwechslung wie [E-184](#e-184) an zwei
weiteren Stellen …“*. Weder `CHANGELOG.md` noch `Intern/WEITERMACHEN.md` hat einen Anker `e-184`
(`grep -c 'id="e-184"'` → 0, 0). Der Titel von [E-188](../Intern/BEFUNDE.md#e-188) in BEFUNDE enthält einen Verweis nur auf
einen Anker, und `offene-befunde.pl` übernimmt ihn unverändert. Verweise auf andere Dateien
schreibt es dagegen richtig um: Aus `TESTPLAN.md#e-178-naechstes` wird im CHANGELOG
`Intern/TESTPLAN.md#e-178-naechstes`. `doku-pruefen.pl` meldet den toten Verweis nicht.

**Vorschlag:** `offene-befunde.pl` schreibt `(#…)` beim Übernehmen zu `(BEFUNDE.md#…)` bzw.
`(Intern/BEFUNDE.md#…)` um. Oder der Titel von [E-188](../Intern/BEFUNDE.md#e-188) nennt [E-184](../Intern/BEFUNDE.md#e-184) ohne Verweis.

### <a id="l-119.8"></a>L-119.8 — E-189 „Kurz“: „der Abgleich räumt die Kopie nicht weg“ ist nicht als gemessen belegt

**Gewicht: Kleinkram.** Es geht um die Kennzeichnung, nicht um das Programm: Die Behebung
entfernt die Kopie ohnehin selbst. (belegt / Vermutung)

`Intern/BEFUNDE.md:399` (Kurz): *„… stehen beide mit dieser Nummer in der Liste, und der Abgleich
räumt die Kopie nicht weg.“* Als Tatsache, ohne Kennzeichnung. Woanders steht es vorsichtiger:
- `README.md:168` *„ein erneuter Abgleich räumt ihn vermutlich nicht weg (am Quelltext, [PRÜFER-75](PRUEFER-75.md) K2)“*;
- `tools/messen-e189.ps1:5` und `tools/messen-e184.ps1:49` *„vermutlich“*;
- der rote Wert in BEFUNDE (*„kopie-mit-alter-uid=1“*) stammt vom Quellstand `4593ab89*` (18:04:25).
  Laut Commit `8b5f8342` kam das erneute Öffnen von „Ablage“ (Schritt 5b in `messen-e184.ps1`) aber
  erst danach dazu, weil der Abgleich *„von Lauf zu Lauf“* schwankte. Ob es in diesem Lauf
  abgeglichen hat, steht nirgends.
- Die Gegenprobe am Paketbau (18:16:39) lief vermutlich schon mit Schritt 5b. Von ihr steht nur
  „rot“ da, ohne die Werte (`Intern/pruefstand-buch.tsv` führt nur grüne Läufe,
  `Intern/pruefstand-ergebnis.txt` nur die letzte Gegenprobe zu [E-184](../Intern/BEFUNDE.md#e-184)).

**Berichtigt im zweiten Commit** (Auftrag des Hauptagenten): `Intern/BEFUNDE.md:399` *„und der
Abgleich räumt die Kopie vermutlich nicht weg (am Quelltext, [PRÜFER-75](PRUEFER-75.md) K2; Gegenprobe am
Paketbau rot, Werte nicht abgelegt).“* README und Skripte sagen damit dasselbe.

Ursprünglich nicht berichtigt: Vielleicht hat der Hauptagent die Werte gesehen. Die Protokolle unter
`C:\Temp\E184` habe ich nicht gelesen. **Vorschlag:** die Werte der Gegenprobe zu [E-189](../Intern/BEFUNDE.md#e-189) am
Paketbau in BEFUNDE nachtragen. Steht dort `kopie-mit-alter-uid=1` nach dem erneuten Öffnen, ist
der Satz gemessen und das „vermutlich“ in README und Skripten kann weg. Sonst gehört an den
Satz „(am Quelltext, PRÜFER-75 K2)“.

## Nachtrag: dritter Commit

Dritter Commit: [PRÜFER-76](PRUEFER-76.md) in [E-189](../Intern/BEFUNDE.md#e-189) eingetragen (Auftrag des Hauptagenten). Das sind die Prüfung (355/355, Messfall trennscharf), K1 (mit `878f38e9` abgesichert, `CanCloseFrame` zuerst), K2 bis K4 offen und klein, K3 als Hinweis für den TESTPLAN beim nächsten Paket. Aus „Was noch fehlt“ habe ich „PRÜFER;“ gestrichen, weil die Prüfung erledigt ist. Dazu kommt der Rest von [L-119.1](#l-119.1): `878f38e9` fügt in `ImapToc.cpp` noch einmal 17 Zeilen ein, die zwei anderen Aufrufer stehen jetzt bei `:2801` und `:3107` (gemessen). Bei [E-184](../Intern/BEFUNDE.md#e-184) stehen deshalb jetzt die Funktionen (`CTocDoc::ImapDoPostExpunge`, `CTocDoc::ImapChangeMsgsJunkStatus`) mit den Zeilen am Stand `878f38e9`. Das ist der Vorschlag aus [L-119.1](#l-119.1), so veralten die Angaben nicht mehr mit jedem Einschub.

## Zur Kenntnis

- **README ohne [E-188](../Intern/BEFUNDE.md#e-188).** [E-188](../Intern/BEFUNDE.md#e-188) (*wichtig*: zwischen zwei IMAP-Konten oder beim Verschieben nach
  lokal kann eine fremde Zusammenfassung überschrieben werden) fehlt unter „Bekannte Fehler“.
  Eine Regel, dass jeder offene *wichtige* Befund dort steht, gibt es nicht (vgl. [L-118.8](LEKTOR-118.md#l-118.8), [E-176](../Intern/BEFUNDE.md#e-176)).
  Aufnehmen oder nicht, entscheidet der Hauptagent.
- **`Arbeitsweise/stand-01-11-2026.md:3`** (Beschreibung): *„PRUEFER-75 laeuft; danach PR“*.
  Behebung [E-189](../Intern/BEFUNDE.md#e-189) und `8b5f8342` stehen dort nicht (gemessen). Außerhalb meines Umfangs.
- `Intern/pruefstand-ergebnis.txt` steht nach `8b5f8342` auf *„bestanden=0 fehlgeschlagen=1“*,
  das ist die gewollte Gegenprobe. Wer die Datei ohne Kenntnis des Commits liest, sieht einen
  roten Prüfstand.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen, vor den Berichtigungen):

```
  Quellstand                   7.2.1.130
  Paketnummer                  7.2.1.130
  gepruefte Dateien            50
  Kein Widerspruch gefunden.
```

„Zur Kenntnis“: dieselben 18 Dateien ohne 7.2.1.130 wie in [LEKTOR-118](LEKTOR-118.md#lektor-118), alle alt oder
zum Nachschlagen.

`perl tools/offene-befunde.pl` (gemessen):

```
    offen laut Intern/BEFUNDE.md  46
      davon aktuell gemessen       4  (ab Nummer 125)
      davon veraltet gemessen     28
      davon NIE gemessen          14
    in Intern/WEITERMACHEN.md     46
  46 offene Befunde, in beiden Listen gleich.
```

44 → 46 durch [E-188](../Intern/BEFUNDE.md#e-188) und [E-189](../Intern/BEFUNDE.md#e-189). „Aktuell gemessen“ 3 → 4 durch [E-189](../Intern/BEFUNDE.md#e-189). [E-188](../Intern/BEFUNDE.md#e-188) ist neu und
„nie gemessen“; die Zahl dort steigt dadurch von 13 (am Stand von [LEKTOR-118](LEKTOR-118.md#lektor-118)) auf 14. Den toten Verweis
([L-119.7](#l-119.7)) sieht das Werkzeug nicht.

`perl tools/pruefe-regressionstest.pl`: *„Kein neues "behoben" ohne Regressionstest.“* [E-184](../Intern/BEFUNDE.md#e-184) und
[E-189](../Intern/BEFUNDE.md#e-189) sind „offen“ (Behebung im Quellstand), also nicht betroffen.

`perl tools/ziel-stand.pl`: *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Was nur Gregor entscheiden kann

Nichts Neues.
