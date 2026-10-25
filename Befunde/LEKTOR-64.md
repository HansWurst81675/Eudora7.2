# <a id="lektor-64"></a>LEKTOR-64 — Kurzlauf „keine Lügen auf main": Commits seit 206b3a08, 25.10.2026

**Auftrag.** Nur die Commits `206b3a08..2742bd6e` auf `RC1_vorbereiten`:
`b5d3bcf9` ([LEKTOR-63](LEKTOR-63.md#lektor-63)/PRÜFER-54 eingeholt, [E-147](../Intern/BEFUNDE.md#e-147) neu), `ed0d53a2` ([E-137](../Intern/BEFUNDE.md#e-137)
behoben), `ec468df6` (Prüfstand 32/32), `2742bd6e` (Prüfbericht). Maßstab:
steht danach eine Aussage im Bestand, die nachweislich falsch ist?

**Ergebnis vorweg.** Die drei Berichtigungen aus [LEKTOR-63](LEKTOR-63.md) sind richtig
eingearbeitet, die Zitate aus Issue #102 stimmen wörtlich, Zahlen und
Dauer im Prüfbericht stimmen mit den erzeugten Dateien überein. **Falsch
sind zwei Aussagen:** `WEITERMACHEN.md` schickt die nächste Sitzung noch
an [E-137](../Intern/BEFUNDE.md#e-137), das derselbe Zweig behoben hat ([L-64.1](#l-64.1)), und [E-147](../Intern/BEFUNDE.md#e-147) nennt
Rays Lizenz „dieselbe wie unser Repo", obwohl unsere einen
Patentausschluss trägt ([L-64.2](#l-64.2)). **3 Funde: 2 falsch, 1 Hinweis.**
Keine neue Frage an Gregor.

Kennzeichnung: **gemessen** (Befehl mit Ausgabe), **belegt** (Datei:Zeile),
**Vermutung**.

## Was geprüft wurde und stimmt

- **[E-147](../Intern/BEFUNDE.md#e-147), Zitate und Daten** (gemessen, `gh api …/issues/102/comments`):
  Kommentar `6328190492` von `rjsdotorg`, `2026-10-21T22:43:25Z`, enthält
  *„Feel free to use the methods/code in … in your repository … if it can be
  baked in  so much the better"* und *„roughly around lines 40–50 of
  src/repair.cpp"*; die Auslassungen in `BEFUNDE.md:380` verfälschen nichts.
  Der Link `#issuecomment-6401451303` ist unsere Frage vom
  `2026-10-25T18:26:12Z` nach der Veröffentlichung. Name „Ray Schǔmacher" =
  `gh api users/rjsdotorg` (`name`). `rjsdotorg/EudoraUnicodeFix`:
  `private=true`, Lizenz `BSD-3-Clause` (gemessen).
- **[E-137](../Intern/BEFUNDE.md#e-137)** (belegt): Abfang in `CMainFrame::OnCmdMsg`
  (`Eudora71/Eudora/mainfrm.cpp:3475-3492`) vor `GetWazooWindowWithFocus`,
  nur `!IsMDIChild()`, `PostMessage(WM_COMMAND, ID_SEC_HIDE, 0)`, `return
  TRUE`; `ID_SEC_HIDE` → `SECControlBar::OnHide`
  (`Eudora71/OTShim/OTShim.cpp:1775`, `:2491`); Spurmarke `:3488` beginnt
  mit dem in `BEFUNDE.md:390` genannten Text. `TestE137.cpp` ist in
  `Tests.vcxproj:123` und `TestMain.cpp:44,153` eingetragen. „behoben auf
  dem Zweig `RC1_vorbereiten`" stimmt: `ed0d53a2` ist **nicht** in
  `origin/main` (gemessen, `git merge-base --is-ancestor`).
- **CHANGELOG** (belegt): E-137-Eintrag `CHANGELOG.md:107-111` sagt
  „am laufenden Programm prüft es Gregor" — ehrlich. [E-150](../Intern/BEFUNDE.md#e-150) jetzt „gemessen
  am herausgeschnittenen Code …, im laufenden Programm nicht nachgestellt"
  ([L-63.2](LEKTOR-63.md#l-63.2) erledigt).
- **README [E-148](../Intern/BEFUNDE.md#e-148)** (belegt): „Behoben ab dem Release 7.2.1 (schon im
  Testpaket 7.2.0.123)" und „erst mit dem Testpaket 7.2.0.123" — [L-63.3](LEKTOR-63.md#l-63.3)
  erledigt.
- **WEITERMACHEN K4** (belegt): `9a4cc0e1` existiert („INI-Teil wird erst
  nach dem Beenden gelesen"); „erledigt" stimmt für K4. Die Lücke, die
  PRÜFER-54 K1 danach fand (Absturz beim Beenden = `ini=ok`), ist in
  `b5d3bcf9` behoben und im Commit genannt.
- **Prüfbericht** (gemessen): `Releases/PRUEFBERICHT.md:16-25` — 302/302,
  19/19, 32/32, Bau `1.0.122+ed0d53a2 2026-10-25 19:38`, Dauer „5 min 06 s"
  = `sekunden 306` in `Intern/pruefstand-dauer.txt:3`; der Kopf sagt jetzt
  „Erzeugt von tools/pruefstand-lauf.ps1" ohne den früheren
  Nachtragsvermerk, die Datei hat nur LF (CRLF 0). Zwischen `ed0d53a2` und
  dem Berichtscommit `ec468df6` ändert sich nichts unter `Eudora71/`.
- **Mechanisch** (gemessen): `doku-pruefen.pl` „Kein Widerspruch gefunden"
  (nur bekannte Hinweise auf alte Release-Notizen), `pruefe-stand-md.pl`
  „Kein Stand-Kopf hinkt hinterher", `pruefe-tabellenzeilen.pl` „315
  Dateien, keine gebrochene Tabellenzeile".

## Funde

### <a id="l-64.1"></a>L-64.1 — WEITERMACHEN nennt E-137 noch als nächsten Schritt (falsch, vom Zweig überholt)

`Intern/WEITERMACHEN.md:135`: *„2. **Vor 7.2.1 beheben:** [[E-137](../Intern/BEFUNDE.md#e-137)] …"*, und
`:140`: *„als Nächstes 2.–4."*. [E-137](../Intern/BEFUNDE.md#e-137) ist seit `ed0d53a2` behoben
(`BEFUNDE.md:390`, `CHANGELOG.md:107`); derselbe Commit hat in
`WEITERMACHEN.md` nur die Tabellenzeile entfernt, nicht Punkt 2. Wer dort
einsteigt, arbeitet [E-137](../Intern/BEFUNDE.md#e-137) ein zweites Mal aus — genau die Fehlerklasse aus
`CLAUDE.md` Abschnitt 1. Berichtigung: in Punkt 2 [E-137](../Intern/BEFUNDE.md#e-137) als **behoben
(`ed0d53a2`, am Programm prüft Gregor im Testpaket)** kennzeichnen; offen
bleiben [E-142](../Intern/BEFUNDE.md#e-142) und [E-146](../Intern/BEFUNDE.md#e-146).

### <a id="l-64.2"></a>L-64.2 — E-147: „BSD-3-Clause, dieselbe wie unser Repo" (falsch, ohne Folgen für die Erlaubnis)

`Intern/BEFUNDE.md:380`. Unsere Lizenz ist **nicht** dieselbe: `LICENSE:8`
*„permitted (subject to the limitations in the disclaimer below)"* und
`LICENSE:20` *„NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS"*;
das Repo nennt sie selbst „BSD-3-Clause mit Patentausschluss"
(`LICENSE:39`, `README.md:310`). GitHub erkennt sie entsprechend nicht als
`BSD-3-Clause` (gemessen: `NOASSERTION`, Rays Repo: `BSD-3-Clause`). Die
Folgerung „rechtlich erlaubt" bleibt richtig — Rays Lizenz ist die
weitere, ihre drei Pflichten stehen korrekt da. Berichtigung: „BSD-3-Clause
(unsere ist dieselbe plus Patentausschluss, vereinbar)".

### <a id="l-64.3"></a>L-64.3 — Hinweis: „auf `main`" im CHANGELOG-Kopf und „nicht angedockt"

- `CHANGELOG.md:98` *„Seit 7.2.0.122 auf `main` … Strg+W beendet Eudora
  nicht mehr"* — heute nicht auf `origin/main` (gemessen), wird es mit dem
  Merge von `RC1_vorbereiten`. Auf `main` also wahr; nur auf dem Zweig
  vorgreifend. Kein Handlungsbedarf, solange der Zweig gemergt wird.
- Gregors *„beim nicht angedockten fenster wird es ganz regulär
  geschlossen"* lesen `CHANGELOG.md:109` und `BEFUNDE.md:390` als „eigenes
  Fenster im Arbeitsbereich" (MDI). Der Code-Kommentar
  (`mainfrm.cpp:3469`) sagt, auch **schwebend** nehme niemand den Befehl
  an, und die Behebung greift dort ebenfalls. Ob Gregor schwebend oder MDI
  meinte, ist nicht gemessen (Vermutung: MDI); bei seinem Test im
  Testpaket mit abfragen.

## Abgleich

| Fund | Art | Datei:Zeile | Wirkung |
|---|---|---|---|
| [L-64.1](#l-64.1) | falsch (überholt) | `Intern/WEITERMACHEN.md:135`, `:140` | nächste Sitzung arbeitet [E-137](../Intern/BEFUNDE.md#e-137) doppelt aus |
| [L-64.2](#l-64.2) | falsch | `Intern/BEFUNDE.md:380` | Lizenzangabe; Erlaubnis unberührt |
| [L-64.3](#l-64.3) | Hinweis | `CHANGELOG.md:98`, `:109` | keine |
