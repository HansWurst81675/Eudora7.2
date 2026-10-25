# <a id="lektor-65"></a>LEKTOR-65 — Kurzlauf „keine Lügen auf main": Commits seit 45e704f4, 25.10.2026

**Auftrag.** Nur die `.md`-Änderungen `45e704f4..39d348d8` auf
`RC1_vorbereiten`: `346a5ec0` ([LEKTOR-64](LEKTOR-64.md#lektor-64) eingeholt), `424966f6` ([E-137](../Intern/BEFUNDE.md#e-137)
nachgebessert nach PRÜFER-55), `0074f287` und `39d348d8` (Prüfbericht).
Maßstab: steht danach eine Aussage im Bestand, die nachweislich falsch ist?

**Ergebnis vorweg.** [L-64.1](LEKTOR-64.md#l-64.1) und [L-64.2](LEKTOR-64.md#l-64.2) sind richtig eingearbeitet, die
E-137-Nachbesserung steht so im Code, wie [BEFUNDE.md](../Intern/BEFUNDE.md) und CHANGELOG sie
beschreiben, die Zahlen im Prüfbericht gehen auf. **Falsch ist eine
Aussage:** [E-137](../Intern/BEFUNDE.md#e-137) nennt eine Spurmarke, die es seit `424966f6` nicht mehr gibt
([L-65.1](#l-65.1)). **2 Funde: 1 falsch, 1 Hinweis.** Keine neue Frage an
Gregor.

Kennzeichnung: **gemessen** (Befehl mit Ausgabe), **belegt** (Datei:Zeile),
**Vermutung**.

## Was geprüft wurde und stimmt

- **[E-137](../Intern/BEFUNDE.md#e-137) „angedockt wie schwebend", „nur sichtbare Leiste", „Schwerpunkt ans
  aktive Fenster"** (belegt): `Eudora71/Eudora/mainfrm.cpp:3485-3501` —
  Abfrage `pFokusLeiste->IsWindowVisible() && !pFokusLeiste->IsMDIChild()`,
  dann `PostMessage(WM_COMMAND, ID_SEC_HIDE, 0)` und
  `MDIGetActive()` → `pAktiv->SetFocus()`, wenn sichtbar.
- **„`IsMDIChild` ist in der Ersatzschicht immer FALSE"** (belegt):
  `SECControlBar::IsMDIChild` (`Eudora71/OTShim/OTShim.cpp:1914-1918`) ist
  nur wahr an einer Andockleiste mit `m_bMDIChild`; die einzige solche
  entsteht im `SECControlBarWorksheet` (`:1606`), und das legt nur
  `FloatControlBarInMDIChild` an, das in dieser Stufe nichts tut
  (`:372-375`, Kommentar `:1910-1913`).
- **„der Test prüft jetzt auch das (K2)"** (belegt):
  `Eudora71/Tests/TestE137.cpp:60` (`IsWindowVisible`), `:65-67`
  (`pAktiv->SetFocus();`).
- **CHANGELOG** (belegt): `CHANGELOG.md:107-112` deckt sich mit dem Code;
  „am laufenden Programm prüft es Gregor" bleibt ehrlich.
- **WEITERMACHEN Punkt 2** (belegt): `Intern/WEITERMACHEN.md:135` führt
  [E-137](../Intern/BEFUNDE.md#e-137) als erledigt, `:140` „von 2. noch [E-142](../Intern/BEFUNDE.md#e-142) und [E-146](../Intern/BEFUNDE.md#e-146)" — [L-64.1](LEKTOR-64.md#l-64.1)
  erledigt.
- **[E-147](../Intern/BEFUNDE.md#e-147) Lizenzsatz** (belegt): `Intern/BEFUNDE.md:380` nennt jetzt unsere
  Lizenz „BSD-3-Clause **mit Patentausschluss**" — [L-64.2](LEKTOR-64.md#l-64.2) erledigt.
- **Prüfbericht** (gemessen): `Releases/PRUEFBERICHT.md:1-25` — 302/302,
  19/19, 32/32 auf Bau `1.0.122+424966f6`; Prüfstand „5 min 35 s" =
  `sekunden 335` in `Intern/pruefstand-dauer.txt:3`, zusammen 6 + 8 + 335
  = 349 s = „5 min 49 s". Zwischen `424966f6` und dem Berichtscommit
  `0074f287` ändert sich nichts unter `Eudora71/` und an keinem Werkzeug
  außer `.md` (`git diff --stat` leer).
- **Mechanisch** (gemessen): `doku-pruefen.pl` „Kein Widerspruch gefunden"
  (nur bekannte Hinweise auf alte Fassungsnummern), `pruefe-stand-md.pl`
  „Kein Stand-Kopf hinkt hinterher", `pruefe-tabellenzeilen.pl` „319
  Dateien, keine gebrochene Tabellenzeile".

## Funde

### <a id="l-65.1"></a>L-65.1 — E-137 nennt eine Spurmarke, die es nicht mehr gibt (falsch)

`Intern/BEFUNDE.md:390`: *„Spurmarke `[E-137](../Intern/BEFUNDE.md#e-137) Strg-W: angedockte
Wazoo-Leiste wird versteckt`"*. Der Code schreibt seit `424966f6`
*„[E-137](../Intern/BEFUNDE.md#e-137) Strg-W: Wazoo-Leiste wird versteckt statt Eudora zu beenden"*
(`Eudora71/Eudora/mainfrm.cpp:3497`; gemessen mit `git log -L3497,3497`:
`424966f6` hat „angedockte " gestrichen). Wer Gregors `eudora.log` nach dem
Text aus [BEFUNDE.md](../Intern/BEFUNDE.md) durchsucht, findet nichts und hält die Behebung für nicht
gelaufen — genau der Prüfgriff, mit dem Gregor [E-137](../Intern/BEFUNDE.md#e-137) im Testpaket
bestätigen soll. Berichtigung: Spurmarke in `BEFUNDE.md:390` auf
`E-137 Strg-W: Wazoo-Leiste wird versteckt` setzen.

### <a id="l-65.2"></a>L-65.2 — Hinweis: Testname sagt noch „angedockten"

`Eudora71/Tests/TestE137.cpp:28` *„[E-137](../Intern/BEFUNDE.md#e-137): Strg-W in einer angedockten
Wazoo-Leiste versteckt nur die Leiste"*, daraus `Releases/PRUEFBERICHT.md:356`.
Nicht falsch (angedockt stimmt), nur enger als die Behebung, die auch
schwebend greift. Beim nächsten Anfassen des Tests mitziehen; kein eigener
Schritt.

## Abgleich

| Fund | Art | Datei:Zeile | Wirkung |
|---|---|---|---|
| [L-65.1](#l-65.1) | falsch (überholt) | `Intern/BEFUNDE.md:390` | Suche im Protokoll nach der genannten Spurmarke findet nichts |
| [L-65.2](#l-65.2) | Hinweis | `Eudora71/Tests/TestE137.cpp:28`, `Releases/PRUEFBERICHT.md:356` | keine |
