# <a id="lektor-66"></a>LEKTOR-66 — Kurzlauf „keine Lügen auf main": Commits seit 2909af0c, 25.10.2026

**Auftrag.** Nur die `.md`-Änderungen `2909af0c..d5455410` auf
`RC1_vorbereiten`: `410c3b51` ([LEKTOR-65](LEKTOR-65.md#lektor-65) eingeholt), `78f2ad2a` ([E-137](../Intern/BEFUNDE.md#e-137)
nach `OnCommand` verlegt, PRÜFER-56 K1), `c2207fc8` und `d5455410`
(Prüfbericht). Maßstab: steht danach eine Aussage im Bestand, die
nachweislich falsch ist?

**Ergebnis vorweg.** Der neue Kopf von [E-137](../Intern/BEFUNDE.md#e-137), CHANGELOG, WEITERMACHEN
Punkt 2 und der Prüfbericht decken sich mit dem Code. **Falsch ist eine
Aussage:** in derselben Tabellenzeile steht weiter der alte Absatz
*„Behebung … `CMainFrame::OnCmdMsg` fängt `ID_FILE_CLOSE` ab"* — genau die
Fassung, die nach dem neuen Kopf nie erreicht wurde ([L-66.1](#l-66.1)).
**2 Funde: 1 falsch, 1 Hinweis.** Keine neue Frage an Gregor.

Kennzeichnung: **gemessen** (Befehl mit Ausgabe), **belegt** (Datei:Zeile),
**Vermutung**.

## Was geprüft wurde und stimmt

- **„Abfangung am Anfang von `OnCommand`, vor jeder Weitergabe"** (belegt):
  `Eudora71/Eudora/mainfrm.cpp:3395` `CMainFrame::OnCommand`; der Block
  `if (wCommandID == ID_FILE_CLOSE)` steht `:3433-3445`, vor
  `GetWazooWindowWithFocus()` (`:3447`) und vor jeder anderen Weitergabe;
  davor nur die Befehlsnummer und ein `TRACE` unter `_DEBUG`.
  `OnCmdMsg` (`:3496-3541`) enthält weder `ID_FILE_CLOSE` noch [`E-137`](../Intern/BEFUNDE.md#e-137)
  (gemessen: `grep -c` = 0).
- **Spurmarke** (belegt): `mainfrm.cpp:3438` schreibt
  *„[E-137](../Intern/BEFUNDE.md#e-137) Strg-W: Wazoo-Leiste wird versteckt statt Eudora zu beenden"*,
  wörtlich wie in `Intern/BEFUNDE.md:390` — [L-65.1](LEKTOR-65.md#l-65.1) erledigt.
- **„`CDoc::OnFileClose` (`doc.cpp:144-149`) schickt `WM_CLOSE` an den Rahmen
  der Ansicht"** (belegt): `Eudora71/Eudora/doc.cpp:137-151`, die Zeilen
  144-149 sind `GetFirstViewPosition` … `Frame->SendMessage(WM_CLOSE)`.
- **„Test liest jetzt `OnCommand` und prüft den Block als zusammenhängende
  Anweisungsfolge"** (belegt): `Eudora71/Tests/TestE137.cpp:33`
  (`QT_Abschnitt` von `OnCommand` bis `OnCmdMsg`), `:40-61` (Folge mit
  Abstandsprüfung), `:62-66` (Abfangen vor der Weitergabe). Die Rotproben
  („alte Fassung und verneinte Bedingung je einmal rot") sind von hier aus
  nicht nachzumessen, nicht widerlegt.
- **CHANGELOG** (belegt): `CHANGELOG.md:98` und `:107-112` sagen „soll …"
  und „am laufenden Programm noch nicht gemessen" — ehrlich.
- **WEITERMACHEN Punkt 2** (belegt): `Intern/WEITERMACHEN.md:135` „eingebaut,
  am Programm noch nicht gemessen", nennt `OnCommand`.
- **Prüfbericht** (gemessen): `Releases/PRUEFBERICHT.md:1-25` — 302/302,
  19/19, 32/32; Bau `1.0.122+78f2ad2a` 33-mal, `424966f6` 0-mal.
  Prüfstand „5 min 04 s" = `sekunden 304` in
  `Intern/pruefstand-dauer.txt`; zusammen 8 + 7 + 304 = 319 s = „5 min 19 s".
  Zwischen `78f2ad2a` und `c2207fc8` ändern sich nur Bericht, Buch und
  `.tsv`, nichts unter `Eudora71/` (`git diff --stat`). Testname `:356`
  folgt `TestE137.cpp:28` — [L-65.2](LEKTOR-65.md#l-65.2) erledigt.
- **Mechanisch** (gemessen): `doku-pruefen.pl` Rückgabe 0, nur bekannte
  Hinweise auf alte Fassungsnummern; `pruefe-stand-md.pl` „Kein Stand-Kopf
  hinkt hinterher"; `pruefe-tabellenzeilen.pl` „321 Dateien, keine
  gebrochene Tabellenzeile"; `offene-befunde.pl` „39 offene Befunde, in
  beiden Listen gleich".

## Funde

### <a id="l-66.1"></a>L-66.1 — E-137 beschreibt die Behebung weiter in `OnCmdMsg` (falsch)

`Intern/BEFUNDE.md:390`, Absatz **Behebung**: *„`CMainFrame::OnCmdMsg`
(`mainfrm.cpp`) fängt `ID_FILE_CLOSE` ab, **bevor** der Befehl an das
Wazoo-Fenster oder das aktive Fenster weitergeht, wenn eine Leiste den
Schwerpunkt hat, die **kein** MDI-Fenster ist"*. Der Code fängt in
`OnCommand` ab (`mainfrm.cpp:3433-3445`), `OnCmdMsg` gar nicht (s. o.), und
eine MDI-Abfrage gibt es nicht mehr — die Bedingung ist
`pFokusLeiste && GetSafeHwnd() && IsWindowVisible()` (`:3436`). Derselbe
Eintrag sagt im Kopf das Gegenteil (*„die erste Fassung saß in `OnCmdMsg`
und wurde nie erreicht"*). Wer nur den Behebungsabsatz liest, sucht an der
falschen Funktion. Ebenso überholt im selben Absatz: *„Weiter nicht
gemessen: wer Eudora vorher beendete — die Behebung fängt den Befehl ab,
bevor er dorthin kommt"* — der Kopf nennt den Weg jetzt am Quelltext belegt
(`CDoc::OnFileClose`, `doc.cpp:144-149`). Berichtigung: Absatz auf
`OnCommand` und die heutige Bedingung setzen, den Satz „Weiter nicht
gemessen: wer …" streichen oder auf „am Quelltext belegt, nicht gemessen"
ändern.

### <a id="l-66.2"></a>L-66.2 — Hinweis: „Was noch fehlt" am Zeilenende ist der Stand vom 23.10.

`Intern/BEFUNDE.md:390`, letzter Satz: *„Was noch fehlt: die Messung, was
Eudora tatsaechlich beendet … Dazu die Entscheidung, wie es sein soll"*.
Steht unter „Stand davor", ist also als Geschichte lesbar; die Entscheidung
ist gefallen (WEITERMACHEN:135), die Ursache belegt. Wer nach der Marke
`Was noch fehlt` sucht ([LEKTOR-50](LEKTOR-50.md#lektor-50)), bekommt aber diesen Satz. Beim Berichtigen
von [L-66.1](#l-66.1) mitziehen: dort „am laufenden Programm, Gregor im Testpaket".

## Abgleich

| Fund | Art | Datei:Zeile | Wirkung |
|---|---|---|---|
| [L-66.1](#l-66.1) | falsch (überholt) | `Intern/BEFUNDE.md:390` | nennt `OnCmdMsg` als Ort der Behebung und eine MDI-Abfrage, die es nicht gibt |
| [L-66.2](#l-66.2) | Hinweis | `Intern/BEFUNDE.md:390` | „Was noch fehlt" nennt Erledigtes |
