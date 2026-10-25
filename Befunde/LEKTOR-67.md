# <a id="lektor-67"></a>LEKTOR-67 — Mikrolauf: L-66.1 und L-66.2 in E-137 umgesetzt?, 25.10.2026

**Auftrag.** Nur die Zeile [E-137](../Intern/BEFUNDE.md#e-137)
(`Intern/BEFUNDE.md:390`) gegen [L-66.1](LEKTOR-66.md#l-66.1) und
[L-66.2](LEKTOR-66.md#l-66.2) und gegen `Eudora71/Eudora/mainfrm.cpp`, auf
`5f648d3f`. Maßstab: steht an dieser Zeile noch etwas Falsches?

**Ergebnis vorweg.** Beide Funde sind erledigt. **Nichts Falsches gefunden.**
**1 Fund: 1 Hinweis.** Keine neue Frage an Gregor.

Kennzeichnung: **gemessen** (Befehl mit Ausgabe), **belegt** (Datei:Zeile),
**Vermutung**.

## Was geprüft wurde und stimmt

- **[L-66.1](LEKTOR-66.md#l-66.1) erledigt** (belegt): der Absatz *Behebung* nennt jetzt den
  *„Anfang von `CMainFrame::OnCommand`"*, vor jeder Weitergabe; Code
  `mainfrm.cpp:3395` (`OnCommand`), Block `:3433-3445`, vor
  `GetWazooWindowWithFocus()` `:3447`. Die Bedingung im Text (*„sichtbare
  Wazoo-Leiste hat den Schwerpunkt"*) deckt sich mit `:3436`; `ID_SEC_HIDE`
  `:3439`, Schwerpunkt an das aktive Fenster `:3440-3442`, `return TRUE`
  `:3443`. `OnCmdMsg` (`:3496`) enthält kein `ID_FILE_CLOSE` (gemessen:
  `grep -n ID_FILE_CLOSE mainfrm.cpp` → nur `:3433`). Die erste Fassung steht
  als *„griff nicht und ist entfernt"*, MDI-Abfrage ebenso. Der Satz *„Weiter
  nicht gemessen: wer Eudora vorher beendete …"* ist weg (gemessen:
  `grep -o` → nichts).
- **[L-66.2](LEKTOR-66.md#l-66.2) erledigt** (gemessen): `Was noch fehlt` kommt in der Zeile genau
  einmal vor und nennt *„Gregors Prüfung im Testpaket 7.2.0.123"* mit
  Spurmarke im `eudora.log`; die alte Fassung ist umbenannt in
  *„Stand 23.10.2026, überholt — damals fehlte"*.
- **Spurmarke** (belegt): `mainfrm.cpp:3438` wörtlich wie im Eintrag.
- **`SECControlBar::OnHide`, `OTShim.cpp`** (belegt):
  `Eudora71/OTShim/OTShim.cpp:1775` (`ON_COMMAND(ID_SEC_HIDE, …)`), `:2491`.
- **„`IsMDIChild` immer FALSE"** (belegt): `OTShim.cpp:1910-1918`, weil
  `FloatControlBarInMDIChild` nichts tut (`:372-375`).
- **`CDoc::OnFileClose` (`doc.cpp:144-149`)** (belegt): `GetFirstViewPosition`
  … `Frame->SendMessage(WM_CLOSE)`.
- **„302 Tests, 302 bestanden"** (belegt): `Releases/PRUEFBERICHT.md`, Zeile
  `302 | 302 | 0`.
- **Mechanisch** (gemessen): `pruefe-tabellenzeilen.pl Intern/BEFUNDE.md` →
  „1 Dateien, keine gebrochene Tabellenzeile"; `offene-befunde.pl` →
  „39 offene Befunde, in beiden Listen gleich".

## Funde

### <a id="l-67.1"></a>L-67.1 — Hinweis: der Teil „Stand davor" sagt noch „Das ist der nächste Schritt"

`Intern/BEFUNDE.md:390`, im Abschnitt *„Stand davor"*: *„**Was dabei Eudora
beendet, ist NICHT gemessen** — … Das ist der nächste Schritt."* und
*„`ID_FILE_CLOSE` kommt in `Eudora71/` fünfmal vor"*. Beides ist der Stand vom
23.10.; heute ist die Ursache am Quelltext belegt, und `mainfrm.cpp:3433` ist
ein sechstes Vorkommen (gemessen: `grep -rn ID_FILE_CLOSE Eudora71` ohne
Tests → 6). Als Geschichte gekennzeichnet, deshalb nicht falsch; wer die Zeile
mittendrin liest, bekommt aber einen erledigten „nächsten Schritt". Beim
nächsten Anfassen der Zeile ein „(Stand 23.10.)" davorsetzen genügt.

Nebenbei, außerhalb des Auftrags: der Kommentar `WazooBarMgr.cpp:270` verweist
für `IsMDIChild` auf `OTShim.cpp:1565`; die Funktion steht heute bei `:1914`.

## Abgleich

| Fund | Art | Datei:Zeile | Wirkung |
|---|---|---|---|
| [L-66.1](LEKTOR-66.md#l-66.1) | erledigt | `Intern/BEFUNDE.md:390` | Behebung steht in `OnCommand`, erste Fassung als entfernt |
| [L-66.2](LEKTOR-66.md#l-66.2) | erledigt | `Intern/BEFUNDE.md:390` | „Was noch fehlt" nennt Gregors Prüfung im Testpaket |
| [L-67.1](#l-67.1) | Hinweis | `Intern/BEFUNDE.md:390` | Geschichtsteil nennt einen erledigten „nächsten Schritt" |
