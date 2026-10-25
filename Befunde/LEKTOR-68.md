# <a id="lektor-68"></a>LEKTOR-68 — Mikrolauf: Gregors Entscheidung zu PRÜFER-57 K2 in E-137, 25.10.2026

**Auftrag.** Nur der Satz, den `75c71096` in [E-137](../Intern/BEFUNDE.md#e-137)
(`Intern/BEFUNDE.md:390`) eingefügt hat, gegen `Eudora71/Eudora/mainfrm.cpp`
und [PRÜFER-57](PRUEFER-57.md#k2) K2. Maßstab: ist er falsch?

**Ergebnis vorweg.** Der Satz stimmt. **Nichts Falsches, keine Funde.** Keine
neue Frage an Gregor.

Kennzeichnung: **gemessen** (Befehl mit Ausgabe), **belegt** (Datei:Zeile),
**Vermutung**.

## Der Satz

*„**Entschieden von Gregor am 25.10.2026** (PRÜFER-57 K2, „a) ist ok."): auch
Datei → Schließen und der Knopf Close Window verstecken die Leiste, wenn sie
den Schwerpunkt hat — wie Strg+W; das Umschalt-„alle schließen" entfällt in
diesem Fall."* (gemessen: `git show 75c71096 --word-diff=plain` — das ist die
einzige Änderung des Commits in `BEFUNDE.md`.)

## Was geprüft wurde und stimmt

- **Herkunft egal** (belegt): `mainfrm.cpp:3400-3402` nimmt `wCommandID` aus
  `LOWORD`, wenn `HIWORD` 0 (Menü) oder 1 (Tastenkürzel) ist; der Block
  `:3433` fragt nur `wCommandID == ID_FILE_CLOSE`, nicht die Herkunft. Also
  Menü, Kürzel und Knopf gleich.
- **Knopf Close Window** (belegt): `EudoraRes.rc:6397` und `:6465` sind
  `BUTTON ID_FILE_CLOSE`; Tooltip „Close Window" `EudoraRes.rc:8839`.
- **„wenn sie den Schwerpunkt hat"** (belegt): `:3435-3436`
  `GetWazooBarWithFocus()` und sichtbar; `ID_SEC_HIDE` `:3439`, `return TRUE`
  `:3443`. Ob ein Menüklick den Schwerpunkt in der Leiste lässt, ist in K2
  eine Vermutung; der Satz ist bedingt formuliert und behauptet das nicht.
- **Umschalttaste entfällt** (belegt): die Abfrage `ShiftDown()` →
  `ID_CLOSE_ALL` sitzt erst in `CDoc::OnFileClose` (`doc.cpp:139-140`); der
  Block kehrt vorher mit `TRUE` zurück und prüft keine Umschalttaste.
- **Deckung mit K2** (belegt): `Befunde/PRUEFER-57.md:44` und `:95-109`
  beschreiben genau diese zwei Folgen; der Satz gibt sie als gewollt wieder.
- **Mechanisch** (gemessen): `perl tools/pruefe-tabellenzeilen.pl
  Intern/BEFUNDE.md` → „1 Dateien, keine gebrochene Tabellenzeile".
