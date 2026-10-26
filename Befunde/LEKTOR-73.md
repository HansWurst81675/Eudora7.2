# <a id="lektor-73"></a>LEKTOR-73 — Gregors Ergebnisse an 7.2.0.123 und der Kurztest 7.2.0.124, Zweig `0.123_ergebnisse`, 26.10.2026

**Auftrag.** (1) Stand der Funde [L-72.1](LEKTOR-72.md#l-72.1) bis
[L-72.5](LEKTOR-72.md#l-72.5); (2) was seit `d83e4de6` an `*.md` geändert
wurde (`git diff d83e4de6..HEAD -- '*.md'`, 14 Dateien, 136 Zeilen hinzu,
53 weg), vor allem die Ergebnistabelle 7.2.0.123 und der Kurztest T1–T5 in
`Intern/TESTPLAN.md`, der CHANGELOG-Abschnitt 7.2.0.124, die neuen Befunde
[E-156](../Intern/BEFUNDE.md#e-156), [E-157](../Intern/BEFUNDE.md#e-157),
[E-158](../Intern/BEFUNDE.md#e-158) und die Nachträge, `ZIEL.md`, `README.md`,
`Intern/WEITERMACHEN.md`, `Releases/PAKETE.md`; (3) Widersprüche zu anderen
Stellen nach Gregors Regel vom 26.10.2026 (*„die infos in den MD dateien sollen
alle konsistent sein und sich nicht widersprechen“*); (4) die mechanischen
Prüfungen. Gemessen im Arbeitsbaum `Eudora7.2-wt-lektor` auf `8bdab960`
(nach `git fetch` und `git merge --ff-only origin/0.123_ergebnisse`: *„Already
up to date.“*). Vor dem Commit auf `1bd0fe96` vorgezogen (lokaler Stand von
`0.123_ergebnisse`, ändert keine geprüfte `.md` außer `tools/AGENTEN-LAUFEN.md`
und `tools/TESTLAEUFE.md`), weil `pre-commit` (`pruefe-startwege.pl`) zehn
Prüfstandsstarts von 12:24–12:31 ohne Protokollzeile abwies; die Zeilen stehen
in `1bd0fe96`.

**Ergebnis vorweg.** **11 Funde** (6 falsch, 3 unvollständig, 2 Hinweise).
Von den fünf Funden aus [LEKTOR-72](LEKTOR-72.md#lektor-72) ist **einer
erledigt**, drei sind offen, davon zwei durch den Abschluss des Tests
gegenstandslos, einer ist gewachsen. **Der Kurztest T1–T5 stimmt mit dem Code**
(T4: *No* ist Standardknopf, belegt), aber T1 und T4 lassen je eine
Voraussetzung offen. **Der schwerste Fund:** `ZIEL.md` meldet *„25 von 25
erfüllt“*, während seine eigene Zeile zu [E-119](../Intern/BEFUNDE.md#e-119)
**offen** sagt — das Werkzeug liest das Wort *„widerlegt“* als „erledigt“
([L-73.1](#l-73.1)). Daneben sind Gregors Bestätigungen vom 26.10.2026 nur in
die Ergebnistabelle eingetragen; `BEFUNDE.md`, `ZIEL.md` und `WEITERMACHEN.md`
sagen an fünf Befunden weiter „noch nicht bestätigt“ ([L-73.2](#l-73.2)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-72

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-72.1](LEKTOR-72.md#l-72.1) | Vorgänger in `WEITERMACHEN.md:9` und `:10` doppelt | **offen, gewachsen** | `:9` nennt jetzt drei Vorgänger: *„Davor 7.2.0.123 (Zweig `vor-testpaket-7.2.0.123`), davor 7.2.0.122, Zweig `e-14-gemessen-und-rollen` — [[E-125](../Intern/BEFUNDE.md#e-125)] … davor in 7.2.0.121 [[E-111](../Intern/BEFUNDE.md#e-111)] … **Geschnürt als Paket 1.0.122**, von Gregor am 23.10.2026 geprüft.“*; `:10` dieselben drei: *„7.2.0.123 (Paket 1.0.123, 26.10.2026 …); davor 7.2.0.122 (Paket 1.0.122 …); davor 7.2.0.121“*. Kein Widerspruch, aber in `:9` liest sich *„Geschnürt als Paket 1.0.122“* jetzt wie eine Aussage über 7.2.0.124 |
| [L-72.2](LEKTOR-72.md#l-72.2) | Teil 0 A begründet mit einer Folge, die A.1 aufhebt | **offen, gegenstandslos** | `TESTPLAN.md:56-58` unverändert; der Abschnitt heißt seit `:37` *„Testpaket 7.2.0.123 — abgeschlossen am 26.10.2026“*, M1 ist bestanden (`:142`) |
| [L-72.3](LEKTOR-72.md#l-72.3) | `WEITERMACHEN.md:12` sagt nicht, dass 1.0.123 geschnürt ist | **erledigt** | `:12` *„Das Testpaket davor hat Gregor am 26.10.2026 getestet.“*; `PAKETE.md:6` *„geschnürt ist bis 1.0.123, 1.0.124 folgt“* |
| [L-72.4](LEKTOR-72.md#l-72.4) | [E-146](../Intern/BEFUNDE.md#e-146) beschreibt den alten Fehler zweimal | **offen** | `BEFUNDE.md:388` enthält weiter *„Bis 7.2.0.122: benannte man auf einem IMAP-Server ohne Ordnerhierarchie einen Ordner um, hieß er in Eudora danach falsch …“* und *„**Vorher (bis 26.10.2026):** benannte man auf einem IMAP-Server ohne Ordnerhierarchie einen Ordner um, hieß er in Eudora danach falsch.“* (gemessen: `grep -o`, je 1 Treffer) |
| [L-72.5](LEKTOR-72.md#l-72.5) | Teil 0 C nennt Teil 3 (M3) nicht | **offen, gegenstandslos** | `TESTPLAN.md:82-83` unverändert *„dann Teil 1 und Teil 2 in beliebiger Reihenfolge.“*; Gregor hat M3 trotzdem gefahren (`:143` *„M3 \| **ja** \| 26.10.2026“*) |

---

## <a id="l-73.1"></a>L-73.1 — falsch: `ZIEL.md` meldet alles erfüllt, obwohl E-119 offen ist; E-119 fehlt in beiden Listen der offenen Befunde

* `ZIEL.md:44` (belegt, erzeugt): *„**Stand: 25 von 25 erfüllt, 0 offen.**“*,
  `:50` *„**Alle Zeilen des Maßstabs sind erfüllt.**“*
* `ZIEL.md:69` (belegt, dieselbe Datei): *„[[E-119](../Intern/BEFUNDE.md#e-119)] | `data:`-Bilder als grauer
  Kasten (**offen** für Bilder über 48 KB — von Gregor am 26.10.2026 an
  7.2.0.123 gefunden …“*
* `BEFUNDE.md:365` (belegt), erstes Fettgedrucktes im Urteil: *„offen — am
  Testpaket 7.2.0.123 von Gregor am 26.10.2026 für große Bilder
  **widerlegt**; die Behebung des zweiten Teils ist eingebaut …“*
* **Ursache (belegt):** `tools/ziel-stand.pl:54-55` führt *„widerlegt“* in
  `@erledigt_wort`; `:70-71` überspringt einen Befund, dessen erstes
  Fettgedrucktes ein Erledigt-Wort enthält, außer bei *„wieder offen“*,
  *„teilweise“* oder *„bleibt offen“*. `tools/offene-befunde.pl:83` hat dieselbe
  Liste und dieselbe Ausnahme (`:146-160`). Nachgerechnet mit einem Auszug
  derselben Regel (gemessen): [E-119](../Intern/BEFUNDE.md#e-119) → Wörter `[widerlegt offen]`, fällt also
  heraus.
* **Folge (gemessen):** `perl tools/ziel-stand.pl` → *„25 von 25 erfüllt, 0
  offen - ZIEL.md ist auf dem Stand.“*; `grep -n '^| \*\*\[E-119\]'` in
  `CHANGELOG.md` und `Intern/WEITERMACHEN.md` → kein Treffer, obwohl
  `perl tools/offene-befunde.pl` *„40 offene Befunde, in beiden Listen gleich“*
  meldet.

Dieselbe Klasse wie [L-16.1](LEKTOR-16.md#l-16.1) ([E-112](../Intern/BEFUNDE.md#e-112), *„WIEDER OFFEN. …
widerlegt“*). **Was zu tun wäre:** im Urteil von [E-119](../Intern/BEFUNDE.md#e-119) *„widerlegt“* durch
*„nicht bestanden“* ersetzen genügt für heute; dauerhaft gehört in beide
Werkzeuge die Regel „beginnt das erste Fettgedruckte mit *offen*, ist der
Befund offen“, mit einem Gegentest an [E-119](../Intern/BEFUNDE.md#e-119).

## <a id="l-73.2"></a>L-73.2 — falsch: Gregors Bestätigungen vom 26.10.2026 stehen nur in der Ergebnistabelle; fünf Befunde heißen anderswo weiter „noch nicht bestätigt“

Die Ergebnistabelle (`TESTPLAN.md:122-144`) trägt für N4, N5, N6, K3, N1,
N1b, N2 und das Protokoll Gregors *ja* vom 26.10.2026. Dagegen (alle belegt):

| Befund | Ergebnistabelle | widersprechende Stelle |
|---|---|---|
| [E-77](../Intern/BEFUNDE.md#e-77) | N4 und N5 **ja** (`:138`, `:139`) | `BEFUNDE.md:324` *„**Was noch fehlt:** Gregors Bestätigung am Testpaket 7.2.0.123.“*; `ZIEL.md:67` *„**von Gregor noch nicht bestätigt**“* |
| [E-113](../Intern/BEFUNDE.md#e-113) | N6 **ja** (`:140`) | `BEFUNDE.md:359` *„**Was noch fehlt:** Gregors Bestätigung am Testpaket 7.2.0.123.“*; `ZIEL.md:68` *„**von Gregor noch nicht bestätigt**“* |
| [E-146](../Intern/BEFUNDE.md#e-146) | N5 **ja**, *„[E-146](../Intern/BEFUNDE.md#e-146): PASSED“* (`:139`) | `BEFUNDE.md:388` *„Gregor prüft das gewöhnliche Umbenennen im Testpaket (TESTPLAN N5)“*; `ZIEL.md:75` ohne Gregors Ergebnis |
| [E-148](../Intern/BEFUNDE.md#e-148) | K3 **ja**; Protokoll *„`rootcerts.p7b geladen aus: …1.0.123-release\rootcerts.p7b (vorhanden)`“* (`:128`, `:144`) | `BEFUNDE.md:387` *„**Logzeile, eingebaut am 26.10.2026, am Programm noch nicht gemessen**“*; `WEITERMACHEN.md:135` *„am Programm noch nicht gemessen“*; `ZIEL.md:74` *„mit Eudora selbst prüft es Gregor im Testpaket“* |
| [E-137](../Intern/BEFUNDE.md#e-137) | N1, N1b, N2 **ja** (`:134-136`) | `BEFUNDE.md:394`, Kopf richtig (*„von Gregor am 26.10.2026 an Paket 1.0.123 bestätigt“*), aber weiter hinten *„**Was noch fehlt:** Gregors Prüfung im Testpaket 7.2.0.123“*; daraus erzeugt `CHANGELOG.md:38` und `WEITERMACHEN.md:377` *„**nie gemessen** \| Gregors Prüfung im Testpaket 7.2.0.123“*; `WEITERMACHEN.md:133` *„eingebaut am 25.10.2026, am Programm noch nicht gemessen“* |

Dazu [E-119](../Intern/BEFUNDE.md#e-119): Kopf *„am Prüfstand noch nicht gemessen
(Fall `E-119e`)“* — seit `1bd0fe96` gemessen: `Intern/pruefstand-buch.tsv:22`
*„E-119e ok 2026-10-26 12:31:14 … Eudora 7.2.0.124 … laenge=78519“*; und
dieselbe Zeile weiter hinten *„**Was noch fehlt:** Gregors
Bestätigung am Testpaket 7.2.0.123.“* (`BEFUNDE.md:365`).

Der Auftrag nannte Nachträge zu [E-146](../Intern/BEFUNDE.md#e-146) und [E-148](../Intern/BEFUNDE.md#e-148); **in `d83e4de6..HEAD` gibt es
keine** (gemessen: `git diff -U0 --word-diff` über `Intern/BEFUNDE.md` hat
Treffer nur in den Zeilen 365, 378, 381–383 und 394). **Was zu tun wäre:** je
Befund ein Satz *„Von Gregor am 26.10.2026 an 1.0.123 bestätigt (TESTPLAN
N…)“* und *Was noch fehlt* nachziehen; `ZIEL.md:67`, `:68`, `:74`, `:75` und
`WEITERMACHEN.md:133`, `:135` danach auf einen Verweis kürzen. Die erzeugten
Listen folgen von selbst.

## <a id="l-73.3"></a>L-73.3 — falsch: drei Stand-Zeilen nennen 7.2.0.123 als aktuellen Stand

* `README.md:99` (belegt): *„Stand **7.2.0.123** / `VERSION` **1.0.123** —
  Testpaket für Gregors Test vor dem Release 7.2.1; was darin neu ist, steht im
  [CHANGELOG, Abschnitt 7.2.0.123]“*.
* `ZIEL.md:172` (belegt): *„**Stand 26.10.2026.** Quellstand **7.2.0.123** /
  `VERSION` **1.0.123** (Testpaket)“*.
* `TESTPLAN.md:3-6` (belegt), direkt unter der Überschrift *„Quellstand
  7.2.0.124“* (`:1`): *„**Testpaket 7.2.0.123** (Paket 1.0.123) — es kommt nach
  `C:\Users\Gregor\Eudora72-1.0.123-release`, neben dein 1.0.122 … Nach deinem
  Test und deinem Ja wird daraus das Release **7.2.1.<n>**.“*
* Dagegen `WEITERMACHEN.md:9`, `AUFGABEN.md:3`, `TESTPLAN.md:1`, `:9-12` und
  `Doku/MITARBEITEN.md:63`: 7.2.0.124 / 1.0.124.

`perl tools/doku-pruefen.pl` meldet *„Kein Widerspruch gefunden.“* (gemessen) —
es prüft nur, ob eine Datei die aktuelle Nummer **gar nicht** nennt, nicht, ob
sie eine ältere als aktuell ausgibt. **Was zu tun wäre:** die drei Stellen auf
7.2.0.124 heben; `TESTPLAN.md:3-6` streichen, der Kopf des Kurztests (`:9-12`)
sagt es schon.

## <a id="l-73.4"></a>L-73.4 — falsch: der Block „HIER WEITERMACHEN“ schickt zum PR und zu Gregors Test, beides ist erledigt

* `WEITERMACHEN.md:132` (belegt): *„**Stand 26.10.2026 – HIER WEITERMACHEN,
  Zweig `vor-testpaket-7.2.0.123`**“*.
* `:145` (belegt): *„**Als Nächstes:** PR an Gregor, dann sein Test nach
  TESTPLAN Teil 0 bis 3, Ergebnisse in die Tabelle dort, dann Release
  7.2.1.<n>.“*
* Dagegen `:9` (Zweig `0.123_ergebnisse`, 7.2.0.124), `TESTPLAN.md:37`
  (*„abgeschlossen am 26.10.2026“*) und `PAKETE.md:161` (*„Bau, Prüfstand und
  Schnüren folgen“*).

Wer nach `CLAUDE.md` hier einsteigt, liest als nächsten Schritt den PR zu
7.2.0.123 und danach das Release — nicht den Bau von 1.0.124 und Gregors
Kurztest. Die neuen Entscheidungen 8–10 stehen **in** diesem veralteten Block.
**Was zu tun wäre:** Kopf auf `0.123_ergebnisse` und *Als Nächstes* auf „1.0.124
bauen, prüfen, schnüren; Gregors Kurztest T1–T5; dann Release 7.2.1.N nach
Entscheidung 10“.

## <a id="l-73.5"></a>L-73.5 — falsch: CHANGELOG zählt drei nicht bestandene Punkte, die Ergebnistabelle zwei; K4 ist leer, obwohl während des Tests ein Absturz war

* `CHANGELOG.md:103` (belegt): *„15 Punkte bestanden, drei nicht.“*
* `TESTPLAN.md:122-144` (gemessen, Zeilen gezählt): **15** × *ja* (K0/K1, K2,
  K3, K5, K7, K8, N1, N1b, N2, N3, N4, N5, N6, M1, M3), **2** × *nein* (K6 `:131`,
  N7 `:141`), K4 (`:129`) und *Protokoll* (`:144`) mit *„—“*.
* `BEFUNDE.md:383` ([E-156](../Intern/BEFUNDE.md#e-156), belegt): *„Gefunden an
  Gregors Test von 7.2.0.123: Windows meldete um 10:05 einen Absturz von
  `C:\Users\Gregor\Eudora72-1.0.123-release\Eudora.exe` in `ucrtbased.dll`“*.

Der dritte Punkt des CHANGELOG ist also K4 (Vermutung, aus *„behebt die drei“*
und [E-156](../Intern/BEFUNDE.md#e-156) geschlossen) — aber die Tabelle, die nach `ZIEL.md` Voraussetzung des
Release ist, sagt es nicht, und der Abschnitt heißt *„abgeschlossen“*. **Was zu
tun wäre:** K4 → *„**nein** \| 26.10.2026 \| Absturz um 10:05 in
`ucrtbased.dll`, Ursache [[E-156](../Intern/BEFUNDE.md#e-156)], behoben für 7.2.0.124“*; die Zeile
*Protokoll* bekommt *„gelesen“* statt *„—“*.

## <a id="l-73.6"></a>L-73.6 — falsch: angedockt oder abgedockt — die Ergebnistabelle und E-137 beschreiben Gregors Fall gegensätzlich

* `TESTPLAN.md:134`, Bemerkung zu N1 (belegt): *„Einmal griff Strg+W im
  **angedockten** Filterfenster nicht (keine E-137-Zeile), vermutlich nach einem
  Klick in die Filterdetails“*.
* `BEFUNDE.md:394` (belegt), Gregors Wortlaut: *„mail auswählen, dann filter
  fenster (**abgedockt**) anklicken, ctrl-W: schließt mail fenster, nicht filter
  fenster“*; ebenso der Kommentar `Eudora71/Eudora/WazooBar.cpp:1946-1948`.

*Abgedockt* ist die schwebende Leiste. Beide Stellen beschreiben denselben
Vorfall (Vermutung: es gibt im Protokoll keinen zweiten), sagen aber
Gegensätzliches über den Ort, und *„griff nicht“* ist schwächer als *„schließt
mail fenster“*. Für den Kurztest zählt das, weil T1 den Ort nicht nennt
([L-73.7](#l-73.7)). **Was zu tun wäre:** Gregors Wort übernehmen:
*„im abgedockten (schwebenden) Filterfenster schloss Strg+W das Mailfenster
statt der Leiste“*.

## <a id="l-73.7"></a>L-73.7 — unvollständig: T1 nennt weder angedockt/schwebend noch, dass die Mail geöffnet sein muss

* `TESTPLAN.md:21` (belegt): *Wo* *„lokal, eine Mail in `In` **ausgewählt**“*;
  *Erwartung* *„nur das Filterfenster verschwindet, **die Mail bleibt offen**“*.
* Eine nur ausgewählte Mail hat kein Fenster, das offen bleiben könnte; Gregors
  Fall war *„mail fenster“* bei **abgedockter** Leiste ([L-73.6](#l-73.6)).
* Code (belegt): `CWazooBar::OnMouseActivate` (`WazooBar.cpp:1961-1976`) gibt
  bei jedem Klick in die Leiste, angedockt wie schwebend, dem aktiven
  Wazoo-Fenster den Fokus und schreibt `[E-137](../Intern/BEFUNDE.md#e-137) Klick in Wazoo-Leiste: Fokus geht
  in die Leiste`. *Tools → Filters* gibt es (`EudoraRes.rc:5805-5807`). Die
  Erwartung stimmt also mit dem Code.

**Was zu tun wäre:** *Wo* → *„lokal, eine Mail aus `In` geöffnet“*; *Was zu tun
ist* → *„… einmal schwebend (wie am 26.10.), einmal angedockt“*; Erwartung um
*„im `eudora.log` die Zeile `E-137 Klick in Wazoo-Leiste`“* ergänzen.

## <a id="l-73.8"></a>L-73.8 — unvollständig: T4 setzt einen Entwurf im IMAP-Ordner *Gelöscht* voraus, den N3 löschen ließ

* `TESTPLAN.md:24` (belegt): *„einen Entwurf aus *Gelöscht* nach `Out` ziehen“*.
* `TESTPLAN.md:105`, N3 (belegt): *„… Danach den Entwurf in `Gelöscht`
  löschen“*.
* Code (belegt): `tocdoc.cpp:2788` ruft `YesNoDialogPlainNeinVorgewaehlt`,
  `guiutils.cpp:867-873` setzt `SetDefID(IDCANCEL)` und den Fokus auf *No*;
  weiter geht es nur bei `IDOK`. *„Enter drücken: nichts passiert“* stimmt.

**Was zu tun wäre:** *„einen Entwurf anlegen und nach *Gelöscht* ziehen wie in
N3, dann zurück nach `Out` ziehen“* — oder den N3-Schritt verlinken.

## <a id="l-73.9"></a>L-73.9 — unvollständig: „Befund folgt“, der Befund ist da

* `TESTPLAN.md:146` (belegt): *„Der Prüfstand muss den Eintrag sichern und
  zurückschreiben (**Befund folgt**).“*
* `BEFUNDE.md:382` [E-157](../Intern/BEFUNDE.md#e-157) (belegt): *„`tools/pruefstand-lauf.ps1`
  hält `CommandLine` und `LaunchManager` vor dem Lauf fest und setzt sie danach
  zurück“*.

**Was zu tun wäre:** *„(Befund folgt)“* → *„([[E-157](../Intern/BEFUNDE.md#e-157)], eingebaut)“*.

## <a id="l-73.10"></a>L-73.10 — Hinweis: E-156 „vermutlich ebenso betroffen“ ist messbar — das veröffentlichte `v1.0.120` trägt alle sechs Testfassungen

* `BEFUNDE.md:383` (belegt): *„die veröffentlichten Pakete sind auf derselben
  Grundlage gebaut, also vermutlich ebenso betroffen — nicht einzeln
  nachgemessen“*.
* **Gemessen** (nur gelesen, `unzip -p … | grep -a -c`) an
  `Releases/Eudora72-1.0.120-release.zip` im Hauptbaum: alle sechs Dateien
  liegen darin, Datum 30.08.2026 17:57; `NSImport.eif`, `OEImport.eif`,
  `OLImport.eif` enthalten `ucrtbased.dll`, `mfc140d` und `_CrtDbgReport`;
  `EuShlExt.dll`, `EudoraNS.dll`, `swEudora.exe` enthalten `_CrtDbgReport`.
* `README.md`, *Bekannte Fehler* (`:144-175`): keine Zeile dazu.

Wie sich das bei einem Anwender ohne Visual Studio zeigt, ist nicht gemessen
(Vermutung: ohne `ucrtbased.dll` lädt Windows die drei Importmodule gar nicht,
statt abzustürzen). **Was zu tun wäre:** in [E-156](../Intern/BEFUNDE.md#e-156) *„vermutlich“* durch die
Messung ersetzen; ob die README einen Satz für `v1.0.120` bekommt, siehe unten.

## <a id="l-73.11"></a>L-73.11 — Hinweis: `PAKETE.md` 1.0.123 nennt kein Ergebnis

* `Releases/PAKETE.md:165-180` (belegt): *„Für Gregors Test vor dem Release
  7.2.1.“* — kein Satz, dass der Test am 26.10.2026 stattfand und mit K6/N7
  (und K4, [L-73.5](#l-73.5)) nicht bestanden ist.

Kein Widerspruch. **Was zu tun wäre:** eine Zeile *„Von Gregor am 26.10.2026
getestet, Ergebnis: [TESTPLAN](../Intern/TESTPLAN.md#ergebnis-7-2-0-123)“* —
nur der Verweis, nach Gregors Regel.

---

## Geprüft, kein Fund

* **CHANGELOG 7.2.0.124** (`:99-124`): die fünf Punkte decken sich mit
  `BEFUNDE.md` ([E-156](../Intern/BEFUNDE.md#e-156), [E-119](../Intern/BEFUNDE.md#e-119) zweiter Teil, [E-158](../Intern/BEFUNDE.md#e-158), [E-137](../Intern/BEFUNDE.md#e-137) zweiter Teil, [E-142](../Intern/BEFUNDE.md#e-142)
  *No*); *„Über 48 KB“* passt zu *„ab 65.536 Zeichen“* ([E-119](../Intern/BEFUNDE.md#e-119), Base64:
  65.536 × 3/4 = 49.152 Byte); *„34 Mal“* passt zu [E-156](../Intern/BEFUNDE.md#e-156) *„34 Abstürze in
  `ucrtbased.dll`“*; *„311 Tests“* zu [E-158](../Intern/BEFUNDE.md#e-158).
* **Testzahlen:** [E-137](../Intern/BEFUNDE.md#e-137) 309, [E-119](../Intern/BEFUNDE.md#e-119) 310, [E-142](../Intern/BEFUNDE.md#e-142) 310, [E-158](../Intern/BEFUNDE.md#e-158) 311. Dass [E-142](../Intern/BEFUNDE.md#e-142) bei 310
  bleibt, stimmt: `dd3855c7` ändert nur `TestE142.cpp`, nicht `TestMain.cpp`
  (gemessen: `git show --stat`).
* **Kurztest T2, T3, T5 und Vorbereitung** (`TESTPLAN.md:14-25`): Ort genannt,
  Erwartung passt zu [E-119](../Intern/BEFUNDE.md#e-119), [E-158](../Intern/BEFUNDE.md#e-158) und [E-156](../Intern/BEFUNDE.md#e-156). Die Vorbereitung nimmt
  `eudora.log` aus; eine `rootcerts.p7b` im Mailverzeichnis gibt es in 1.0.123
  nicht (Protokoll `:144`: *„aus … (das **Programm**verzeichnis)“*).
* **[E-142](../Intern/BEFUNDE.md#e-142) in der README** (`:172`) und N3 (`:105`): *Nach Ja* kommt weiter die
  Meldung, *No* ist still — passt zu T4.
* **Entscheidung 10** (`WEITERMACHEN.md:143`) gegen `ZIEL.md:87` und
  `WEITERMACHEN.md:134`, `:161`: alle sagen 7.2.1.N und `v7.2.1.N`. Dass
  Testpakete weiter *„Paket 1.0.124“* heißen, deckt Entscheidung 10 selbst
  (*„Testpakete bleiben 7.2.0.N … Werkzeuge … beim Schnüren des Release
  umgestellt“*).
* **ZIEL-Zeilen [E-156](../Intern/BEFUNDE.md#e-156) und [E-158](../Intern/BEFUNDE.md#e-158)** (`:72-73`) gegen BEFUNDE: beide *„behoben auf
  dem Zweig `0.123_ergebnisse`“*, *„von Gregor im Testpaket zu bestätigen“* —
  stimmt.
* **README „Neu in den Testpaketen“** (`:136-139`) verweist auf den CHANGELOG
  statt zu wiederholen; E-119-Zeile (`:164`) passt zu ZIEL `:69`.
* **`PAKETE.md:6`** und `:159-163`: *„1.0.124 folgt“* — stimmt mit
  `WEITERMACHEN.md:12`.

## Mechanisch

* `perl tools/doku-pruefen.pl` (gemessen): *„Quellstand 7.2.0.124,
  Paketnummer 1.0.124 … gepruefte Dateien 46 … Kein Widerspruch gefunden.“*,
  dazu 16 Zeilen *„nennt weder den Quellstand 7.2.0.124 noch die Paketnummer“*
  (alle in Fahrtenbüchern, Release-Notizen und Anleitungen). Blind für
  [L-73.3](#l-73.3).
* `perl tools/ziel-stand.pl` (gemessen): *„25 von 25 erfüllt, 0 offen - ZIEL.md
  ist auf dem Stand.“* — falsch, siehe [L-73.1](#l-73.1).
* `perl tools/offene-befunde.pl` (gemessen): *„40 offene Befunde, in beiden
  Listen gleich.“* — ohne [E-119](../Intern/BEFUNDE.md#e-119).

## Nicht geprüft

* Der Prüfstandslauf `1bd0fe96` selbst (36 Fälle) — nur die Zeile zu `E-119e`
  gelesen.
* Gregors Absturzbericht und das Ereignisprotokoll selbst.

## Was nur Gregor entscheiden kann

* **`v1.0.120` und [E-156](../Intern/BEFUNDE.md#e-156):** Das veröffentlichte Paket trägt die sechs
  Testfassungen nachweislich ([L-73.10](#l-73.10)). Soll die README unter
  *Bekannte Fehler* einen Satz für Anwender von `v1.0.120` bekommen (etwa
  „gelegentliche Abstürze möglich, behoben ab 7.2.1“), oder genügt das
  kommende Release?
