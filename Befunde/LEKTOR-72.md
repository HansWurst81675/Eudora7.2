# <a id="lektor-72"></a>LEKTOR-72 — Einarbeitung von LEKTOR-71 (`ce28be3b`) und Teil 0 der Prüfanleitung, Zweig `vor-testpaket-7.2.0.123`, 26.10.2026

**Auftrag.** Sehr kurzer Lauf vor dem PR an Gregor, eng begrenzt auf den
Commit `ce28be3b` (*„[LEKTOR-71](LEKTOR-71.md#lektor-71) eingearbeitet“*, gemessen: `git show ce28be3b
--stat` — `Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`,
`tools/AGENTEN-LAUFEN.md`): (1) Stand der Funde [L-71.1](LEKTOR-71.md#l-71.1) bis [L-71.9](LEKTOR-71.md#l-71.9); (2) ob eine
geänderte Zeile eine neue falsche Aussage oder einen Widerspruch einführt;
(3) ob *Teil 0* in `Intern/TESTPLAN.md` von Anfang bis Ende ausführbar ist.
Keine neue Bestandsrunde. Gemessen im Arbeitsbaum `Eudora7.2-wt-lektor` auf
`8249e8bb` (nach `git fetch` und `git merge --ff-only
origin/vor-testpaket-7.2.0.123`; `8249e8bb` ändert nur
`tools/AGENTEN-LAUFEN.md`).

**Ergebnis vorweg.** **5 Funde** (0 falsch, 2 unvollständig, 3 Hinweise).
Von den neun beauftragten Funden aus [LEKTOR-71](LEKTOR-71.md#lektor-71) sind
**fünf erledigt und vier teilweise**; alle drei *falsch*-Funde aus [LEKTOR-71](LEKTOR-71.md#lektor-71)
sind behoben oder auf eine Doppelung ohne Widerspruch zurückgegangen. **Keine
geänderte Zeile führt eine neue falsche Aussage ein.** **Teil 0 ist von A.1 bis
C ohne Widerspruch ausführbar**; der Kontoassistent kommt wie angekündigt, und
ein Einführungsdialog davor kommt nicht (belegt, siehe unten).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-71

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-71.1](LEKTOR-71.md#l-71.1) | Teil 0 B überschreibt `eudora.log` aus M1 | **erledigt** | `TESTPLAN.md:47-50` *„**Zwei Ausnahmen, beide nicht mitkopieren:** `eudora.log` — sonst ist das Protokoll aus M1 Schritt 4 überschrieben …“*; Ergebniszeile `:115` *„aus M1 die Zeilen `E-132 Startverzeichnis: … fremd=1` und `E-132 Startverzeichnis: eigenes gewaehlt=…`“* — Wortlaut passt zu `eudora.cpp:4223` und `:4402` (belegt) |
| [L-71.2](LEKTOR-71.md#l-71.2) | Kopf „Starten immer mit `Eudora starten.cmd`“ gegen Teil 0 A | **erledigt** | `TESTPLAN.md:10-11` *„**einzige Ausnahme ist Teil 0 A**, dort wird `Eudora.exe` doppelgeklickt“*. Die übrigen Doppelklick-Stellen (`:191`, `:209`) stehen im Nachschlageteil (gemessen: `grep -n -i doppelklick`) |
| [L-71.3](LEKTOR-71.md#l-71.3) | Kontoassistent nach M1 Schritt 4 | **erledigt** | `TESTPLAN.md:40-42` *„öffnet deshalb den Assistenten für ein neues Konto: mit *Abbrechen* schließen, dann *File → Exit*“*; dass vorher kein Einführungsdialog kommt, siehe *Teil 0* unten |
| [L-71.4](LEKTOR-71.md#l-71.4) | `WEITERMACHEN.md` nennt zwei Vorgänger | **teilweise**: Zeile 10 ist berichtigt, Zeile 9 nicht gekürzt — kein Widerspruch mehr, aber dieselbe Angabe zweimal ([L-72.1](#l-72.1)) | `WEITERMACHEN.md:10` *„7.2.0.122 (Paket 1.0.122, 23.10.2026, [E-125](../Intern/BEFUNDE.md#e-125)); davor 7.2.0.121“* |
| [L-71.5](LEKTOR-71.md#l-71.5) | [E-142](../Intern/BEFUNDE.md#e-142) „Behoben wird das nicht“ gegen „dann beheben“ | **erledigt** | `BEFUNDE.md:378` *„Vor 7.2.1 wird das nicht behoben — vereinbart ist ein Hinweis, eingebaut am 26.10.2026; die Ursache kommt nach 7.2.1 dran.“*; passt zu *Was noch fehlt* derselben Zeile |
| [L-71.6](LEKTOR-71.md#l-71.6) | `WEITERMACHEN.md` kündigt das Schnüren an | **teilweise**: `:3` (*„Stand 26.10.2026“*) und `:142` berichtigt; `:12` nicht ([L-72.3](#l-72.3)) | `:142` *„Erledigt am 26.10.2026: … Testpaket geschnürt um 09:18 … **Als Nächstes:** PR an Gregor“* |
| [L-71.7](LEKTOR-71.md#l-71.7) | „merkt sich Windows“; M1 Schritt 4 ohne Startweg | **teilweise**: „Eudora“ statt „Windows“ und Schritt 4 berichtigt; die Begründung ist weiter strenger als der Code ([L-72.2](#l-72.2)) | `TESTPLAN.md:28`, `:637` *„Wieder **`Eudora.exe` doppelklicken**, diesmal **No** wählen“* |
| [L-71.8](LEKTOR-71.md#l-71.8) | veraltete Zeilennummern in M1 | **erledigt** | `TESTPLAN.md:639` *„(`eudora.cpp`, `StartEudoraWithDefaultLocation`) … (dieselbe Funktion, …)“* |
| [L-71.9](LEKTOR-71.md#l-71.9) | [E-146](../Intern/BEFUNDE.md#e-146) alter Fehler zweimal, „Für Gregor ist nichts zu tun“ | **teilweise**: der Satz ist durch *„Gregor prüft das gewöhnliche Umbenennen im Testpaket (TESTPLAN N5)“* ersetzt; der alte Fehler steht weiter zweimal ([L-72.4](#l-72.4)) | `BEFUNDE.md:385` |

[L-71.10](LEKTOR-71.md#l-71.10) (README-Auswahlliste) war nicht beauftragt und
ist in `ce28be3b` nicht angefasst (gemessen: `README.md` nicht in `--stat`).

---

## Teil 0 von Anfang bis Ende

Jeder Schritt gegen den nächsten und gegen den Code gelesen:

* **Kopf (`:10-11`) → A:** der Kopf nimmt Teil 0 A aus; A.1 startet das
  **alte** 1.0.122 mit dessen eigenem `Eudora starten.cmd` — das ist kein
  Widerspruch zum Kopf, der vom neuen Verzeichnis spricht (belegt).
* **A.1–A.3, M1 Schritt 1–4:** die Kette aus [LEKTOR-71](LEKTOR-71.md#lektor-71)
  gilt unverändert (`ce28be3b` ändert nur `.md`, gemessen: `--stat`).
  M1 Schritt 3 (`:636`) nennt weiter *„SHA256 vorher/nachher“*, A.3 (`:38-39`)
  ersetzt das ausdrücklich durch das Änderungsdatum — kein Widerspruch, A sagt,
  was gilt.
* **A.4, Kontoassistent:** kommt (belegt). `eudora.cpp:1680-1686` schickt
  `ID_SPECIAL_NEWACCOUNT`, wenn keine Persönlichkeit eine Absenderadresse hat.
  Die Vorgabe-`Mailverzeichnis\Eudora.ini` aus
  `Releases/Eudora72-1.0.2-lauffaehig.zip` enthält nur `[Settings]` und
  `[Mappings]`, kein `ReturnAddress` (gemessen: ZIP-Eintrag gelesen, Treffer
  nur Zeile 1 und 5), `paket-bauen.ps1:609-631` ergänzt nur `LogLevel`, und
  `tools/DEudora.ini` trägt kein Konto (gemessen). **Ein Einführungsdialog
  kommt nicht davor:** `IDD_INTRODUCTION` steht unter
  `if (!QCSharewareManager::IsBoxBuild())` (`eudora.cpp:1656`), und der
  Release-Bau setzt `BUILD_BOX_OR_SITE_R_VERSION`
  (`Eudora71/Eudora/Eudora.vcxproj:132`) → `DEFAULT_SWM_MODE (2)`
  (`QCSharewareManager.h:55-56`) → `IsBoxBuild()` liefert `true`
  (`QCSharewareManager.cpp:1202-1208`). Damit ist die offene Frage aus
  [L-71.3](LEKTOR-71.md#l-71.3) (*„hängt an `SeenIntro` … nicht gemessen“*)
  beantwortet. Ob der Knopf *Abbrechen* oder *Cancel* heißt, hängt an der
  Windows-Sprache (Eigenschaftsblatt, `AccountWizard/Src/WizardPropSheet.cpp`;
  Vermutung) — kein Fund.
* **B:** die zwei Ausnahmen sind klar benannt. Die Begründung *„das alte
  enthält selbst [`E-132`](../Intern/BEFUNDE.md#e-132)-Zeilen“* ist durch [LEKTOR-71](LEKTOR-71.md#lektor-71) gemessen. Eine Rotation
  des Protokolls nach `eudorlog.old` während des Tests ist bei der Vorgabe
  `LogFileSize` 10000 KB (`EudoraRes.rc:8464`, `debug.cpp:387`) nicht zu
  erwarten; ob Gregors `Eudora.ini` einen kleineren Wert trägt, ist nicht
  gemessen.
* **C:** *„Ab jetzt nur noch mit `Eudora starten.cmd`“* passt zum Kopf. C nennt
  danach nur Teil 1 und 2 ([L-72.5](#l-72.5)).

Kein Schritt widerspricht einem anderen.

---

## <a id="l-72.1"></a>L-72.1 — unvollständig: `WEITERMACHEN.md` führt den Vorgänger jetzt in zwei Zeilen

* `Intern/WEITERMACHEN.md:9`, Zeile *Quellstand* (belegt, unverändert):
  *„Davor 7.2.0.122, Zweig `e-14-gemessen-und-rollen` — [E-125](../Intern/BEFUNDE.md#e-125) … davor in
  7.2.0.121 [E-111](../Intern/BEFUNDE.md#e-111) … **Geschnürt als Paket 1.0.122**, von Gregor am 23.10.2026
  geprüft.“*
* `:10`, Zeile *Quellstand davor* (belegt, geändert in `ce28be3b`):
  *„7.2.0.122 (Paket 1.0.122, 23.10.2026, [E-125](../Intern/BEFUNDE.md#e-125)); davor 7.2.0.121 ([E-111](../Intern/BEFUNDE.md#e-111), nie
  einzeln geschnürt).“*

Beide sagen jetzt dasselbe — der Widerspruch aus [L-71.4](LEKTOR-71.md#l-71.4)
ist weg. Nach Gregors Regel vom 26.10.2026 (eine Stelle) gehört der Vorgänger
nur in Zeile 10. **Was zu tun wäre:** in Zeile 9 alles ab *„Davor 7.2.0.122“*
bis *„von Gregor am 23.10.2026 geprüft.“* streichen.

## <a id="l-72.2"></a>L-72.2 — Hinweis: Teil 0 A begründet die Reihenfolge weiter mit einer Folge, die A.1 aufhebt

* `TESTPLAN.md:26-29` (belegt): *„Wird das neue Paket vorher über `Eudora
  starten.cmd` gestartet, merkt sich Eudora das neue Verzeichnis, und die
  Rückfrage aus M1 kommt zu Recht nicht mehr.“*
* `RegisterCommandLine` schreibt `CommandLine\Current` bei **jedem**
  gewöhnlichen Start (`eudora.cpp:1067`, `:3742`, belegt); A.1 setzt es also
  wieder auf 1.0.122, und die Rückfrage kommt trotzdem. Dauerhaft abgestellt
  wird sie nur durch eine gemerkte Antwort *Yes*/*No* in der `DEudora.ini`
  (Rest von [L-71.7](LEKTOR-71.md#l-71.7)).

Die Anleitung führt zum richtigen Ergebnis; der Satz macht nur unnötig Angst,
falls Gregor 1.0.123 schon einmal gestartet hat. **Was zu tun wäre:** *„Hast
du 1.0.123 schon gestartet und in der Rückfrage *Yes* oder *No* gewählt, kommt
sie nicht mehr — dann bitte melden.“*

## <a id="l-72.3"></a>L-72.3 — Hinweis: `WEITERMACHEN.md:12` sagt nicht, dass 1.0.123 geschnürt ist

* `Intern/WEITERMACHEN.md:12` (belegt, unverändert): *„**1.0.123** … Testpaket
  für Gregors Test vor dem Release 7.2.1 … Das Paket davor wurde am 23.10.2026
  geschnürt und liegt bei Gregor“*.
* `:142` (belegt, neu): *„Testpaket geschnürt um 09:18 ([PAKETE](../Releases/PAKETE.md))“*.

Kein Widerspruch, aber die Zeile *Paketnummer* liest sich, als sei nur das
Paket davor geschnürt. Rest von [L-71.6](LEKTOR-71.md#l-71.6). **Was zu tun
wäre:** *„geschnürt am 26.10.2026, siehe [PAKETE.md](../Releases/PAKETE.md)“*
statt des Satzes über das Paket davor.

## <a id="l-72.4"></a>L-72.4 — Hinweis: E-146 beschreibt den alten Fehler weiter zweimal

* `Intern/BEFUNDE.md:385` (belegt): *„Bis 7.2.0.122: benannte man auf einem
  IMAP-Server ohne Ordnerhierarchie einen Ordner um, hieß er in Eudora danach
  falsch …“* und später *„**Vorher (bis 26.10.2026):** benannte man auf einem
  IMAP-Server ohne Ordnerhierarchie einen Ordner um, hieß er in Eudora danach
  falsch.“*

Der irreführende Satz *„Für Gregor ist nichts zu tun“* ist weg, der neue
*„Gregor prüft das gewöhnliche Umbenennen im Testpaket (TESTPLAN N5)“* stimmt
mit `TESTPLAN.md:78` (N5) überein. Die Doppelung bleibt (Rest von
[L-71.9](LEKTOR-71.md#l-71.9)). **Was zu tun wäre:** den *Vorher*-Satz
streichen; der ausführlichere erste Satz genügt.

## <a id="l-72.5"></a>L-72.5 — unvollständig: Teil 0 C schickt Gregor zu Teil 1 und 2, nicht zu Teil 3

* `TESTPLAN.md:53-54` (belegt, unverändert): *„**C. Ab jetzt nur noch mit
  `Eudora starten.cmd`** im neuen Verzeichnis, dann Teil 1 und Teil 2 in
  beliebiger Reihenfolge.“*
* `TESTPLAN.md:82-87` (belegt): *„Teil 3 — die Handfälle aus Teil M“* mit
  **M3** ([E-125](../Intern/BEFUNDE.md#e-125)), das nur Gregor fahren kann.
* `WEITERMACHEN.md:142` (belegt, neu in `ce28be3b`): *„sein Test nach TESTPLAN
  Teil 0 bis 3“*.

Wer Teil 0 als Ablauf liest, endet bei Teil 2 und lässt M3 aus; die
Ergebnistabelle hat eine Zeile M3. **Was zu tun wäre:** in C *„dann Teil 1,
Teil 2 und Teil 3 (M3) in beliebiger Reihenfolge“*.

---

## Geprüft, kein Fund

* **Neue Aussagen in `WEITERMACHEN.md:142`:** *„Prüfstand (35/35)“* gegen
  `Releases/PAKETE.md:169` *„35 Prüfstandsfälle, alle grün“*; *„um 09:18“*
  gegen `:161`; *„Teil 0 bis 3“* gegen `TESTPLAN.md:24`, `:56`, `:69`, `:82` —
  stimmt.
* **`WEITERMACHEN.md:10`:** *„Paket 1.0.122, 23.10.2026, [E-125](../Intern/BEFUNDE.md#e-125)“* gegen `:9`
  und `PAKETE.md:181` — stimmt.
* **[E-142](../Intern/BEFUNDE.md#e-142) (`BEFUNDE.md:378`):** Kurzfassung und *Was noch fehlt* sagen jetzt
  dasselbe.
* **Ergebniszeile *Protokoll* (`TESTPLAN.md:115`):** beide E-132-Zeilen
  wortgleich mit den Formatstrings `eudora.cpp:4223` und `:4402`.

## Nicht geprüft

* Alles außerhalb von `ce28be3b` (Auftrag), insbesondere [L-71.10](LEKTOR-71.md#l-71.10).
* Gregors `Eudora.ini` in 1.0.122 (`LogFileSize`) und ob dort eine
  `eudorlog.old` liegt — nur `eudora.log` ist zu lesen abgesprochen.

## Was nur Gregor entscheiden kann

Nichts. Alle Funde sind Textberichtigungen; keiner hält den PR auf.
