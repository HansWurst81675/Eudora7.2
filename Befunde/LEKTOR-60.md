# <a id="lektor-60"></a>LEKTOR-60 — Mikrolauf: Commit 0adcecaf (L-59.1 und L-59.2 eingeholt), 25.10.2026

**Auftrag.** Nur der Commit `0adcecaf` (*„[LEKTOR-59](LEKTOR-59.md#lektor-59)
eingeholt: README-Rueckweg mit Sicherungskopie, Selbsttest zaehlt selbst"*),
und darin nur `README.md`, `tools/WERKZEUGE.md` und
`tools/pruefe-tabellenzeilen.pl`. Gefragt war: Sind
[L-59.1](LEKTOR-59.md#l-59.1) und [L-59.2](LEKTOR-59.md#l-59.2) erledigt, und
ist an diesen Stellen etwas **falsch** oder **zerbrochen**?

**Ergebnis vorweg.** Beide Funde sind **erledigt**. **Kein neuer Fund.**

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt** (Zitat
mit Datei:Zeile), **Vermutung**.

---

## Mechanisch

Gemessen am 25.10.2026 in diesem Arbeitsbaum auf `0adcecaf`.

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/pruefe-tabellenzeilen.pl` | *„302 Dateien, keine gebrochene Tabellenzeile."*, Rückgabe 0 |
| `perl tools/pruefe-tabellenzeilen.pl --selbsttest` | *„22 Faelle, 22 richtig, 0 falsch / (15 muessen durchgehen, 7 muessen abweisen)"*, Rückgabe 0 |

## L-59.1 — erledigt

* **Sicherungskopie wird jetzt angelegt** (belegt): `README.md:243-245`
  *„Eudora beenden, die vorhandene `rootcerts.p7b` im Programmverzeichnis in
  `rootcerts.p7b.alt` umbenennen und die neue Datei aus `Releases/1.0/`
  hineinlegen"*.
* **Der Rückweg passt zur Sicherung** (belegt): `README.md:249-250` *„die neue
  Datei löschen und `rootcerts.p7b.alt` wieder in `rootcerts.p7b`
  umbenennen"*.
* **Die Folge wird genannt** (belegt): `README.md:250-252` *„dann sind
  allerdings auch die vier eMudhra-Wurzeln wieder da, und für das fremde Netz
  gilt wieder die Vorsicht von oben"* — „vier" stimmt mit `README.md:225-227`
  (vier namentlich genannte Wurzeln) überein.
* **Die Sicherung stört Eudora nicht** (belegt): Eudora sucht genau den Namen
  `rootcerts.p7b` (`Eudora71/QCSSL/src/QCSSLContext.cpp:53`
  `szRootCertFileName = "rootcerts.p7b"`); eine `rootcerts.p7b.alt` daneben
  wird nicht geladen.

## L-59.2 — erledigt

* **Selbsttest zählt selbst** (belegt und gemessen):
  `tools/pruefe-tabellenzeilen.pl:241-242` zählt die Fälle mit Erwartung `> 0`
  aus `@faelle`; Ausgabe *„15 muessen durchgehen, 7 muessen abweisen"*, das
  sind die in [L-59.2](LEKTOR-59.md#l-59.2) von Hand gezählten Werte, Summe 22
  wie die Fallzahl darüber.
* **`WERKZEUGE.md` widerspricht sich nicht mehr** (belegt):
  `tools/WERKZEUGE.md:125` nennt nur noch *„22 Fälle in beide Richtungen,
  davon 15, die durchgehen müssen"*; der hintere Satz *„Selbsttest jetzt 22
  Fälle"* ist entfallen. Die Kopfzeile des Werkzeugs
  (`tools/pruefe-tabellenzeilen.pl:9`, *„22 Faelle"*) stimmt ebenfalls.

## Nicht geprüft

* Die Tabellenzeile `README.md:147` rät weiter knapp zum Ersetzen von
  `rootcerts.p7b` ohne Sicherung, verweist aber auf *„Einzelheiten unten"* —
  nicht Gegenstand von [L-59.1](LEKTOR-59.md#l-59.1) und nicht falsch.
* Die übrigen Dateien des Commits (`Arbeitsweise/…`) — nicht im Auftrag.
