# <a id="lektor-88"></a>LEKTOR-88 — Prüfung vor dem PR des Zweigs `0.127_test_ergebnisse` nach `main`: Gregors Kurztest an 1.0.127, E-137 und E-160 behoben, E-165 neu, ANWENDER Strg+K, 27.10.2026

**Auftrag.** Lauf über `91c92ed0..486d6a69` ohne `Arbeitsweise/`: Gregors
Ergebnisse an Paket 1.0.127 in `Intern/TESTPLAN.md` (V1–V3 aus seinem
Protokoll auf seine Anweisung, V4/V5/V6 von ihm bestätigt),
[E-137](../Intern/BEFUNDE.md#e-137) (Strg+W auf einer Leiste schloss die Mail statt der Leiste)
und [E-160](../Intern/BEFUNDE.md#e-160) (Windows-Meldung beim Anlegen einer Persönlichkeit) auf
„behoben, bestätigt“, neuer Befund [E-165](../Intern/BEFUNDE.md#e-165) (Vervollständigungsbox mit
einem Treffer sieht verbaut aus), Vorbereitung „leerer Stand“ im TESTPLAN,
neuer Abschnitt in `Doku/ANWENDER.md`, Eintrag in `tools/ZWEIGE.md`.
Besonders: (1) nennt noch eine Stelle [E-137](../Intern/BEFUNDE.md#e-137)/[E-160](../Intern/BEFUNDE.md#e-160) offen? (2) ist die
Bestätigung von [E-137](../Intern/BEFUNDE.md#e-137) sauber belegt? (3) [E-165](../Intern/BEFUNDE.md#e-165) vollständig? (4) ANWENDER
gegen `EudoraRes.rc` und `namenick.cpp`. Gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor` auf `wt/lektor-20261027e`.

**Ergebnis vorweg.** **10 Funde: 2 falsch, 4 veraltet, 1 ungenau, 2 unklar,
1 Hinweis.** Die Umstellung auf „behoben“ ist **nur in `Intern/BEFUNDE.md`,
im TESTPLAN und in den erzeugten Listen** angekommen; die handgeschriebenen
Stellen — ZIEL-Maßstab, CHANGELOG 7.2.0.127/.126, WEITERMACHEN (Kopf,
Entscheidung 2, „hier weiter“), README-Stand, AUFGABEN, PAKETE, TESTPLAN-Kopf —
nannten [E-137](../Intern/BEFUNDE.md#e-137)/[E-160](../Intern/BEFUNDE.md#e-160) weiter *„am Programm nicht gemessen“*, *„zu prüfen“*
oder *„Gregors Test steht noch aus“*. Diese sieben Funde
([L-88.1](#l-88.1) bis [L-88.7](#l-88.7)) sind reine Doku-Zeilen und
**vom LEKTOR selbst berichtigt** (Auftrag des Hauptagenten). **Vor dem PR
offen:** [L-88.8](#l-88.8) — [E-137](../Intern/BEFUNDE.md#e-137) nennt *„viermal“* die Protokollzeile, der
TESTPLAN nur zwei plus eine unbezifferte; das lässt sich nur am Protokoll
klären, das ich nicht lesen kann. [L-88.9](#l-88.9) und [L-88.10](#l-88.10)
hindern den PR nicht.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-87

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-87.1](LEKTOR-87.md#l-87.1) | CHANGELOG 7.2.0.127 versprach Strg+W schließt nach **jedem** Doppelklick das Postfach | **erledigt** | `CHANGELOG.md:107-111` *„Ausnahme: war das Postfach beim Doppelklick schon das vorderste Fenster, verschwindet bei Strg+W weiterhin die Leiste \*Mailboxes\*“* (belegt) |
| [L-87.2](LEKTOR-87.md#l-87.2) | „hier weiter“ nannte PRÜFER-63 nicht | **erledigt**, inzwischen überholt | `Intern/WEITERMACHEN.md:137` *„Danach hat [PRÜFER-63] die Korrektur gegengelesen: sie hält“* (belegt); der Block selbst war nach Gregors Test veraltet → [L-88.5](#l-88.5) |

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe vor der Berichtigung | nach der Berichtigung |
|---|---|---|
| `perl tools/doku-pruefen.pl` | rc=0, *„Kein Widerspruch gefunden.“* (zur Kenntnis: fünf Dateien ohne 7.2.0.127, alle geschichtlich) | rc=0, unverändert |
| `perl tools/offene-befunde.pl` | rc=0, *„41 offene Befunde, in beiden Listen gleich.“* (42 − [E-137](../Intern/BEFUNDE.md#e-137) − [E-160](../Intern/BEFUNDE.md#e-160) + [E-165](../Intern/BEFUNDE.md#e-165)) | rc=0, unverändert |
| `perl tools/pruefe-regressionstest.pl` | rc=0, *„Kein neues "behoben" ohne Regressionstest.“* | rc=0 |
| `perl tools/ziel-stand.pl` | rc=0, *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* | rc=0 |
| `perl tools/pruefe-befundurteile.pl` | rc=0, *„Kein Dokument erklaert einen offenen Befund fuer erledigt - und keinen behobenen fuer unerledigt.“* | rc=0 |
| `perl tools/rollen-faellig.pl` | rc=0; LEKTOR und CHRONIST *„faellig, aber beauftragt“*, PRÜFER aktuell | — |

**Alle fünf Schranken waren grün, während sieben Dateien [E-137](../Intern/BEFUNDE.md#e-137)/[E-160](../Intern/BEFUNDE.md#e-160) noch als
ungeprüft führten** ([L-88.1](#l-88.1) bis [L-88.6](#l-88.6)).
`pruefe-befundurteile.pl` erkennt *„am Programm noch nicht gemessen“* und
*„Gregors Test steht noch aus“* nicht als Urteil „unerledigt“ — dieselbe
Lücke wie die Wortliste vom 22.10.2026 (`ZIEL.md:199`, *„weil ihre Wortliste
das Wort \*offen\* nicht kannte“*). Ob die Schranke erweitert wird, ist
Sache des Hauptagenten.

---

## <a id="l-88.1"></a>L-88.1 — falsch: ZIEL-Maßstab nennt E-160 „am Programm noch nicht gemessen“

**Was passiert:** wer den Maßstab liest, hält die Windows-Meldung beim
Anlegen einer Persönlichkeit für ungeprüft, obwohl Gregor V4 bestanden hat.

* **Belegt**, `ZIEL.md:74` vorher: *„(\*\*Behebung eingebaut\*\*, kommt mit
  7.2.0.127; Unit-Test rot ohne und grün mit, am Programm noch nicht gemessen
  — TESTPLAN V4)“*; Gegenstück `Intern/BEFUNDE.md:381` *„\*\*behoben — von
  Gregor am 27.10.2026 an Paket 1.0.127 bestätigt (TESTPLAN V4, „V4:
  PASSED“\*\*“* und `Intern/TESTPLAN.md:50`.

**Berichtigt** vom LEKTOR selbst: `ZIEL.md:74` *„(\*\*behoben\*\*, … von
Gregor am 27.10.2026 an Paket 1.0.127 bestätigt — TESTPLAN V4)“*.

## <a id="l-88.2"></a>L-88.2 — veraltet: ZIEL-Maßstab führt E-137 ohne Gregors Ergebnis

**Was passiert:** die Zeile *„Vor 7.2.1 beheben (Entscheidung 2)“* endet mit
*„— TESTPLAN V1–V3, Gegenprobe V6)“*, liest sich also als Prüfauftrag; dass
Gregor bestätigt hat und welcher Rest bleibt, steht nicht da.

* **Belegt**, `ZIEL.md:75` vorher: *„… am Prüfstand rot an 1.0.125, grün an
  1.0.126 und 1.0.127 — TESTPLAN V1–V3, Gegenprobe V6)“*.

**Berichtigt:** `ZIEL.md:75` ergänzt um *„\*\*behoben\*\*, von Gregor am
27.10.2026 an Paket 1.0.127 bestätigt — TESTPLAN V1–V3 aus seinem Protokoll
auf seine Anweisung, Gegenprobe V6; bekannter Rest [PRÜFER-63] K1 in [E-137](../Intern/BEFUNDE.md#e-137)
vermerkt“*.

## <a id="l-88.3"></a>L-88.3 — falsch: CHANGELOG 7.2.0.127 heißt „noch nicht getestet“, 7.2.0.126 „Gregors Test steht noch aus“

**Was passiert:** der CHANGELOG ist die Seite nach außen. Dort stand nach
Gregors bestandenem Kurztest an fünf Stellen, dass niemand am Programm
gemessen habe.

* **Belegt**, vorher:
  `CHANGELOG.md:102` *„Testpaket, noch nicht getestet.“*;
  `:106-107` *„soll wieder das Postfach schließen\*\* (am Programm nicht
  gemessen, TESTPLAN V6)“*; `:116-117` *„Gregors Gegenprobe: TESTPLAN V6.“*;
  `:135` *„Gregors Test steht noch aus.“* ([E-137](../Intern/BEFUNDE.md#e-137)); `:143` *„am Programm noch
  nicht gemessen.“* ([E-160](../Intern/BEFUNDE.md#e-160)).
* Vorbild für die Form: `CHANGELOG.md:162` *„Testpaket, von Gregor im
  Kurztest geprüft“* (7.2.0.124).

**Berichtigt:** `:102` *„Testpaket, von Gregor am 27.10.2026 im Kurztest
geprüft: V1 bis V6 bestanden ([TESTPLAN]; V1–V3 aus seinem Protokoll auf
seine Anweisung)“*; `:106` *„schließt wieder das Postfach\*\* (von Gregor an
1.0.127 bestätigt, TESTPLAN V6)“* — die Ausnahme aus PRÜFER-63 K1 bleibt
unverändert dahinter; `:117` *„TESTPLAN V6 bestanden“*; `:137` und `:143`
*„Von Gregor an 1.0.127 bestätigt (TESTPLAN V1–V3)“* bzw. *„(TESTPLAN V4)“*.
Der Kopf von 7.2.0.126 (*„nie getestet, ersetzt durch 7.2.0.127“*) bleibt
richtig.

## <a id="l-88.4"></a>L-88.4 — veraltet: Entscheidung 2 in WEITERMACHEN „an 1.0.127 zu prüfen“

**Was passiert:** wer morgen einsteigt, liest, [E-137](../Intern/BEFUNDE.md#e-137) sei noch zu prüfen,
und die Entscheidung „vor 7.2.1 beheben“ noch nicht eingelöst.

* **Belegt**, `Intern/WEITERMACHEN.md:121` vorher: *„fünfter Anlauf mit
  Korrektur eingebaut, an 1.0.127 zu prüfen (V1–V3, Gegenprobe V6)“*.

**Berichtigt:** *„… von Gregor am 27.10.2026 an 1.0.127 bestätigt (V1–V3 aus
seinem Protokoll, Gegenprobe V6) — \*\*eingelöst\*\*“*.

## <a id="l-88.5"></a>L-88.5 — veraltet: „hier weiter“ steht auf dem gemergten Zweig und nennt Gregors Test als nächsten Schritt

**Was passiert:** der Einstieg für die nächste Sitzung schickte zu einem
Test, der bestanden ist, auf einen Zweig, der gemergt ist; [E-165](../Intern/BEFUNDE.md#e-165) und die
Reihenfolge für morgen (CHRONIST, [E-165](../Intern/BEFUNDE.md#e-165) am Prüfstand, PR) standen nur im
Stand-Vermerk unter `Arbeitsweise/`.

* **Belegt**, `Intern/WEITERMACHEN.md:135` vorher: *„\*\*Stand 27.10.2026 —
  hier weiter:\*\* Zweig `0.125_ergebnisse`, … \*\*Als Nächstes:\*\* PR —
  Gregor merged; Gregors Kurztest V1–V6; erst wenn V1–V3 bestehen, ist
  Entscheidung 2 für 7.2.1 eingelöst“*.
* **Belegt**, Quelle des neuen Stands: `Arbeitsweise/stand-27-10-2026.md`
  *„Reihenfolge morgen: CHRONIST, [E-165](../Intern/BEFUNDE.md#e-165) am Prüfstand … messen (ein Treffer),
  PR für `0.127_test_ergebnisse`“*; `tools/ZWEIGE.md:176` *„offen dazu
  CHRONIST und [[PRUEFER-63](PRUEFER-63.md#pruefer-63)] K2“*.

**Berichtigt:** neuer Block `Intern/WEITERMACHEN.md:135` *„\*\*Stand
27.10.2026 abends — hier weiter:\*\* Zweig `0.127_test_ergebnisse`. Gregors
Kurztest an Paket 1.0.127 … ganz bestanden … \*\*Als Nächstes:\*\*
CHRONIST; [E-165](../Intern/BEFUNDE.md#e-165) am Prüfstand messen; PR … Release 7.2.1.N erst nach Gregors
Ja. Offen: PRÜFER-63 K2 …“*; der alte Block (`:137`) heißt jetzt *„überholt
durch den Block darüber“*, wie es `:139` für den Block davor vormacht.

## <a id="l-88.6"></a>L-88.6 — veraltet: fünf Stand-Angaben nennen Paket 1.0.127 ohne Gregors Ergebnis

**Was passiert:** README, AUFGABEN, WEITERMACHEN-Kopf, PAKETE und
TESTPLAN-Kopf beschreiben 1.0.127 als zu testendes Paket; der TESTPLAN-Kopf
sagte *„Nach deinem Test und deinem Ja wird das Release gebaut“*.

* **Belegt**, vorher: `README.md:101` *„Testpaket mit dem fünften Anlauf zu
  [[E-137](../Intern/BEFUNDE.md#e-137)] … und [[E-160](../Intern/BEFUNDE.md#e-160)] …, vor dem Release 7.2.1“*;
  `Intern/AUFGABEN.md:3` ebenso ohne Ergebnis;
  `Intern/WEITERMACHEN.md:12` *„— Kurztest in [TESTPLAN.md]“*;
  `Releases/PAKETE.md:161` *„nicht veröffentlicht.\*\* Ersetzt 1.0.126“* —
  im Gegensatz zu `:196` (1.0.125) und `:212` (1.0.124), die *„Von Gregor am
  … im Kurztest geprüft“* tragen; `Intern/TESTPLAN.md:3` *„Kurztest direkt
  hierunter“*, `:8` *„Nach deinem Test und deinem Ja“*.

**Berichtigt:** an allen fünf Stellen *„von Gregor am 27.10.2026 im
Kurztest geprüft/bestätigt, V1 bis V6 bestanden“* mit Verweis auf
`TESTPLAN.md#ergebnis-7-2-0-127`; TESTPLAN-Kopf `:3-4` *„\*\*am 27.10.2026
bestanden\*\* (V1 bis V6, [Ergebnis])“*, `:9` *„Nach deinem Ja wird …“*.

## <a id="l-88.7"></a>L-88.7 — ungenau: ANWENDER sagt, nach „Ja“ öffne sich der Adressbuch-Dialog „leer“

**Was passiert:** wer Strg+K auf eine Mail an sich selbst drückt und *Ja*
wählt, findet Kurzname und Name schon ausgefüllt, nur die Adresse fehlt —
nicht wie beschrieben einen leeren Dialog.

* **Belegt**, `Doku/ANWENDER.md:139-140` vorher: *„Mit \*Ja\* öffnet sich der
  Dialog leer, und du trägst die Adresse selbst ein.“*
* **Belegt am Quelltext**: `namenick.cpp:1380` (Postfachliste) und `:1410`
  (geöffnete Mail) *„pre-populate the "new name" field of the dialog box …
  with a stripped down version of the sender's "Real Name", if any“*;
  `:1794-1798` setzt `m_NewName`, `m_NewFullName` aus diesem Vorschlag und
  `m_NewAddress` aus der (nach `StripMe` leeren) Adressliste. Am Programm
  nicht gemessen.

**Berichtigt:** *„öffnet sich der Dialog ohne Adresse — Kurzname und Name
sind aus dem Absender vorbelegt, wenn er einen Namen trägt —, und du trägst
die Adresse selbst ein.“*

Übriger Abschnitt **ohne Fund** (belegt): Menüpunkt
`EudoraRes.rc:5788` *„Ma&ke Address Book Entry...\tCtrl+K“* unter
`POPUP "&Special"` (`:5784`); Tastenkürzel `:319` *„"K",
ID_SPECIAL_MAKENICKNAME, VIRTKEY, CONTROL“*; Meldungstext `:10723`
*„Eudora could not find any usable addresses … except maybe your own
address.  Create an empty nickname anyway?“*; Schalter `:509`
*„&Include yourself“* im Dialog `IDD_SETTINGS_REPLYING`, Titel
*„Replying“*; Vorgabe `:8767` *„IncludeSelf\n0“* (aus); `namenick.cpp:1763-1764`
`StripMe` bei `IncludeSelf` = 0; Wirkung auf *Reply to All*
`summary.cpp:1609` *„bStripAll = !GetIniShort(IDS_INI_INCLUDE_SELF)“*.
Der Menütext trägt im Original drei Punkte (*„…Entry...“*), die ANWENDER
weglässt — kein Fund.

## <a id="l-88.8"></a>L-88.8 — unklar: E-137 zählt „viermal“ die Protokollzeile, der TESTPLAN zwei und eine unbezifferte

**Was passiert:** die Bestätigung von [E-137](../Intern/BEFUNDE.md#e-137) — Strg+W versteckt nach einem
Klick auf die Leiste nur die Leiste — stützt sich bei V1–V3 allein auf
Gregors Protokoll. Die beiden Stellen, die es zitieren, zählen verschieden,
und eine Angabe steht nur im Befund.

* **Belegt**, `Intern/BEFUNDE.md:397`: *„V1 bis V3 aus seinem `eudora.log`
  (auf seine Anweisung … : \*\*viermal\*\* `E-137 Strg-W angekommen` mit
  `Wazoo-Leiste wird versteckt`, schwebend mit Fokus in der Postfachliste und
  \*\*angedockt\*\* mit Fokus auf „Match“)“*.
* **Belegt**, `Intern/TESTPLAN.md:47`: *„\*\*zweimal\*\* `[E-137](../Intern/BEFUNDE.md#e-137) Strg-W
  angekommen: leiste-mit-fokus=nein … fokus=ListBox …`“*, `:48` (V2) *„wie
  V1, dieselben zwei Zeilen“*, `:49` (V3) eine Zeile *„leiste-mit-fokus=ja …
  fokus=Button“* ohne Zahl und ohne Angabe, ob die Leiste angedockt war.
* Dazu, nicht als Fehler: V1 (Titelzeile) und V2 (Rand) ruhen auf denselben
  zwei Zeilen; `:47` sagt selbst *„Ob ein Klick auf die Titelzeile oder auf
  den Rand ging, zeigt die Zeile nicht“*. Dass das „ja“ für V2 auf Gregors
  Anweisung *„du kannst die ergebnisse jetzt übernehmen“* beruht und nicht auf
  einer eigenen Zeile, steht damit offen da — Frage (2) des Auftrags: **ja,
  sauber gekennzeichnet**, in TESTPLAN `:47` und BEFUNDE `:397` mit Zitat.

Gregors `eudora.log` (*„geteilter Ordner `test_0.127`“*) liegt nicht in
meiner Reichweite; welche Zahl stimmt, ist nicht gemessen. **Was zu tun
wäre:** am Protokoll zählen und eine der beiden Stellen angleichen
(Vermutung: zwei ListBox- plus zwei Button-Zeilen, dann fehlt im TESTPLAN
V3 *„zweimal“*); „angedockt“ in [E-137](../Intern/BEFUNDE.md#e-137) nur stehen lassen, wenn das Protokoll
es zeigt (etwa eine `E-76 … schwebt=0`-Zeile). **Vor dem PR empfohlen** —
eine Zahl in einer Bestätigung.

## <a id="l-88.9"></a>L-88.9 — veraltet: E-124 kennt den Defender-Fall an 1.0.127 nicht

**Was passiert:** Microsoft Defender hat am 27.10.2026 die `Eudora.exe` aus
Paket 1.0.127 auf Gregors Rechner in Quarantäne genommen — das steht nur im
TESTPLAN, nicht im Befund, der dafür da ist.

* **Belegt**, `Intern/TESTPLAN.md:51` (V5): *„Microsoft Defender nahm die
  `Eudora.exe` um 16:47 in Quarantäne, danach erschien „Error Loading
  Resource DLL (EudoraRes.dll)“; das ist der bekannte Fehlalarm [[E-124](../Intern/BEFUNDE.md#e-124)]“*.
* **Belegt**, `Intern/BEFUNDE.md:370` ([E-124](../Intern/BEFUNDE.md#e-124)): *„gemessen am 16.10.2026“*,
  kein Eintrag zu 1.0.127 (gemessen: `grep -o '1\.0\.127'` in der Zeile ohne
  Treffer).

**Was zu tun wäre:** Nachtrag in [E-124](../Intern/BEFUNDE.md#e-124) (*„27.10.2026 an Paket 1.0.127
außerhalb der VM erneut, TESTPLAN V5“*). Nicht selbst berichtigt, weil das
das Messdatum und damit die erzeugten Listen ändert. Hindert den PR nicht.

## <a id="l-88.10"></a>L-88.10 — Hinweis: PRÜFER-63 sagt jetzt mit Verweis „E-165 … nicht vergeben“

**Was passiert:** `befunde-verlinken.pl` hat in einem abgeschlossenen
Prüferbericht den Satz *„[E-165](../Intern/BEFUNDE.md#e-165) und E-166 sind nicht vergeben“* mit einem
Verweis auf den inzwischen vergebenen [E-165](../Intern/BEFUNDE.md#e-165) versehen; wer klickt, landet bei
der Vervollständigungsbox.

* **Belegt**, `Befunde/PRUEFER-63.md:186`: *„Keine.
  [E-165](../Intern/BEFUNDE.md#e-165) und E-166 sind nicht vergeben.“*
  (Commit `32773377`).

Geschichtlich richtig, nur der Verweis ist neu. Ob das Werkzeug Sätze mit
*„nicht vergeben“* auslassen soll, ist Sache des Hauptagenten. Hindert den PR
nicht.

---

## Geprüft ohne Fund

* **[E-165](../Intern/BEFUNDE.md#e-165)** (Frage 3), belegt `Intern/BEFUNDE.md` Zeile `id="e-165"`: Klartext
  *„\*\*Kurz:\*\* Beim Tippen eines Kurznamens erscheint die Auswahlbox,
  sieht aber unfertig aus. Bedienen lässt sie sich; verloren geht nichts.“*;
  *„\*\*Was noch fehlt:\*\*“*, *„\*\*Wie zu pruefen:\*\* \*\*ICH\*\*“*,
  *„\*\*Stufe: unkritisch\*\* (Aussehen)“* vorhanden; in den erzeugten Listen
  `CHANGELOG.md:27` und `Intern/WEITERMACHEN.md:360` (gemessen); nicht in
  ZIEL, richtig, weil unkritisch. Quelltextangaben stimmen (belegt):
  `EudoraRes.rc:3612-3613` `IDD_AUTOCOMP … WS_THICKFRAME`;
  `AutoCompleteSearcher.cpp:518` `SetFont( &GetMessageFont() )`, `:618`
  `InitList`, Höhe *„GetItemCount() \* (cyChar - 1) + 10“* an einem
  `CClientDC` ohne `SelectObject`; `:1441` `WS_VSCROLL`. Das genannte Werkzeug
  `tools/messen-e135.ps1` gibt es (gemessen). Die Ursache ist als
  **Vermutung** gekennzeichnet.
* **[E-160](../Intern/BEFUNDE.md#e-160)**, `Intern/BEFUNDE.md:381`: Urteil *„behoben — von Gregor … bestätigt
  (TESTPLAN V4, „V4: PASSED“…)“*, deckt sich mit `TESTPLAN.md:50`.
* **V5** (`TESTPLAN.md:51`): „ja“ ohne Zählung im Ereignisprotokoll; das sagt
  die Zeile selbst (*„ist nicht gezählt“*) und stützt sich auf Gregors Wort.
  [E-156](../Intern/BEFUNDE.md#e-156) (Debug-Fassungen im Paket) bleibt auf seiner Bestätigung an
  1.0.124 — kein Widerspruch.
* **V6** (`TESTPLAN.md:52`): Gregors *„V6: passed“* plus siebenmal
  `mdi-gewechselt=ja` ohne Verstecken; die Grenze (*„Ob ein Doppelklick in
  \*Mailboxes\* vorausging, zeigt das Protokoll nicht“*) ist offen genannt.
* **Vorbereitung „leerer Stand“** (`TESTPLAN.md:23-29`): SHA-256 gleich
  `Releases/PAKETE.md:169`; `LogLevel=58527` gleich `:168`.
* **`tools/ZWEIGE.md:176`**: *„Von Gregor gewaehlt (\*„0.127_test_ergebnisse“\*,
  als Antwort auf meinen Vorschlag `0.127_ergebnisse`)“* — Name und Zweck
  stimmen.
* **Bestand** (gemessen: `grep` nach `E-137|E-160` über alle `*.md` ohne
  `Arbeitsweise/` und `Befunde/`): nach der Berichtigung nennt keine Stelle
  mehr [E-137](../Intern/BEFUNDE.md#e-137) oder [E-160](../Intern/BEFUNDE.md#e-160) als ungeprüft; übrige Treffer sind Geschichte
  (TESTPLAN T/U/N-Abschnitte, CHANGELOG ≤ 7.2.0.125, LEKTORAT, PAKETE ≤
  1.0.126, PRUEFBERICHT-Zeilen).

## Nicht geprüft

* Gregors `eudora.log` aus `test_0.127` (nicht erreichbar) — daher
  [L-88.8](#l-88.8) offen.
* Der Prüfstand `C:\Temp\E135-box` (Auftrag: keine Prüfstände anfassen).
* Ob `README.md` unter „Bekannte Fehler“ [E-165](../Intern/BEFUNDE.md#e-165) nennen soll — dort stehen nur
  Befunde nach Gregors Entscheidung; unkritisch und ohne Entscheidung kein
  Fund.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)) — ob ein frischer Test aller neun
  Kriterien nötig ist oder die Kurztests T, U, V reichen. Mit V1–V6 sind alle
  27 Zeilen des Maßstabs erfüllt; die Frage ist damit die letzte vor dem
  Release.
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)) — ob
  der Start auf einem Rechner ohne Visual Studio vor 7.2.1 noch einmal
  geprüft werden soll; zuletzt am 06.09.2026 an Paket 1.0.10. Gregors Test
  an 1.0.127 lief „außerhalb der VM“ — ob dort Visual Studio installiert
  ist, steht nirgends; wenn nicht, wäre die Frage damit beantwortet.
