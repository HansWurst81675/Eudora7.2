# <a id="lektor-164"></a>LEKTOR-164 (07.11.2026) — Zweig `paket_7_2_2_137` nach f78dd01a: Nachlauf zu LEKTOR-163 vor dem PR

**Umfang:** nur die Einarbeitung seit meinem Bericht, `git diff 2a4bc723..HEAD -- '*.md' tools/paket-bauen.ps1` (Commits `0975e9a8`, `2dd12223`, `f78dd01a`; `Befunde/PRUEFER-108.md` nur auf Anker und Datenschutz). Keine neue Durchsicht des Bestands.

**Urteil:** Die drei Funde, die vor dem PR stehen sollten ([L-163.1](LEKTOR-163.md#l-163.1) bis [L-163.3](LEKTOR-163.md#l-163.3)), sind eingearbeitet. Von den acht Funden aus [LEKTOR-163](LEKTOR-163.md#lektor-163) sind sechs erledigt, einer zum Teil, einer offen. Der offene ([L-163.4](LEKTOR-163.md#l-163.4)) braucht Gregors Sichtbefund. **Datenschutz: kein Treffer.** **2 neue Funde, beide gering.** **Den PR hält nichts auf.**

## Mechanisch (Ausgaben, kein Urteil)

* **Datenschutz (gemessen):** `perl tools/pruefe-namen-gestaget.pl --commit <rev>` für `2dd12223` und `f78dd01a` meldet jeweils *„kein Name aus der lokalen Liste (commit, 11 Muster)“*.
* **Anker (gemessen):** Der neue Verweis `../Befunde/LEKTOR-163.md#l-163.1` in `Intern/TESTPLAN.md:21` und `Intern/BEFUNDE.md:411` trifft `Befunde/LEKTOR-163.md:14` (`<a id="l-163.1">`).
* **Quelltext (gemessen):** `-EigenerBau` überspringt die Prüfung der Testplan-Voraussetzungen und den Abgleich `VERSION`/`Version.h` tatsächlich. Beide sitzen im Block `if (-not $EigenerBau -and …$dokupruefer)` (`tools/paket-bauen.ps1:207`, Testplan ab `:237`; der Abgleich steht in `tools/pruefe-doku-takt.pl:47`). Die Aufzählung in `Doku/BAUEN.md:266-267` und im Kommentar `tools/paket-bauen.ps1:76-78` stimmt also.

## Erledigungsstand LEKTOR-163

| Fund | Stand | Beleg |
|---|---|---|
| [L-163.1](LEKTOR-163.md#l-163.1) Schritt 2 an 7.2.2.138 „bestanden“ | **erledigt** | `Intern/TESTPLAN.md:21` *„Schritt 2 **nicht prüfbar** (berichtigt nach [LEKTOR-163](LEKTOR-163.md#lektor-163) …)“*; `Intern/BEFUNDE.md:411` *„die Sanduhr-Abhilfe kam also nicht zum Zug“*; `CHANGELOG.md:38` und `Intern/WEITERMACHEN.md:115` *„weder die gehaltene Sanduhr noch die Abweisung des zweiten Klicks ist gemessen“*. Wortlaut siehe [L-164.1](#l-164.1) |
| [L-163.2](LEKTOR-163.md#l-163.2) [E-248](../Intern/BEFUNDE.md#e-248) (Release-ZIP aus dem Klon), erstes „Was noch fehlt“ | **erledigt** | `Intern/BEFUNDE.md:403` *„**Damals fehlte (erledigt am 07.11.2026, siehe Nachtrag):**“*; `CHANGELOG.md:31` und `Intern/WEITERMACHEN.md:108` zeigen jetzt den MIDL-Rest *„Bau schreibt die fünf versionierten MIDL-Ausgaben …“* |
| [L-163.3](LEKTOR-163.md#l-163.3) Schritt 5 „Veröffentlichen“ | **erledigt im Kern** | `Doku/BAUEN.md:297-311`: `gh auth login`, `gh repo fork --remote --remote-name fork`, `git push -u fork eigener-bau`, `gh release create … --repo <dein-konto>/Eudora7.2 --target eigener-bau`; als *„nicht gemessen (kein Fork angelegt)“* ausgewiesen. Die Folge ist in sich schlüssig (belegt nach der Hilfe von `gh`, nicht gemessen). Offen und nicht nötig: der Weg über die Release-Seite im Browser, der Hinweis, gleich den eigenen Fork zu klonen, und der Satz zur Nummer |
| [L-163.4](LEKTOR-163.md#l-163.4) [E-240](../Intern/BEFUNDE.md#e-240)/[E-242](../Intern/BEFUNDE.md#e-242) (Druckvorschau): Test an 7.2.2.138, Marken | **offen** | `Intern/BEFUNDE.md:409` weiter *„**Was noch fehlt:** Gregors Test an 7.2.2.138 (Schritt 4: Kopf und Fuß weiter richtig)“*; [E-240](../Intern/BEFUNDE.md#e-240) und [E-242](../Intern/BEFUNDE.md#e-242) weiter *„Zuletzt gemessen: 07.11.2026 an 7.2.2.137“*. Hängt an Gregors Sichtbefund zu Schritt 4, hält den PR nicht auf |
| [L-163.5](LEKTOR-163.md#l-163.5) WEITERMACHEN-Kopf „Gregor testet“ | **erledigt** | `Intern/WEITERMACHEN.md:16` *„(geschnürt, von Gregor getestet: Vorschau schnell da, Sanduhr und zweiter Klick nicht prüfbar; …)“* |
| [L-163.6](LEKTOR-163.md#l-163.6) „jede ausführbare Datei aus dem Release-Bau“ | **erledigt** | `Doku/BAUEN.md:271-273` *„(außer der Laufzeit aus Visual Studio und den mitgelieferten Plug-ins, siehe nächster Punkt)“* |
| [L-163.7](LEKTOR-163.md#l-163.7) Voraussetzungen | **zum Teil** | ATL und Klonpfad ohne Leerzeichen: `Doku/BAUEN.md:215-219` *„dazu die Komponente *C++ ATL* …“*, *„ein Klonpfad **ohne Leerzeichen** (sonst starten die Prüfserver des Prüfstands nicht, [E-244](../Intern/BEFUNDE.md#e-244))“*. Dauer und Fenster des Prüfstands fehlen bei Schritt 4 weiter (`Doku/BAUEN.md:292-295` unverändert) |
| [L-163.8](LEKTOR-163.md#l-163.8) die vier Zeilen in `Version.h` | **erledigt, mit Rest** | `Doku/BAUEN.md:240-242` nennt `EUDORA_VERSION4`, `EUDORA_BUILD_NUMBER`, `EUDORA_BUILD_DESC`, `EUDORA_BUILD_VERSION`. Rest: [L-164.2](#l-164.2) |

## Funde

### <a id="l-164.1"></a>L-164.1 — Test 7.2.2.138: „die Abhilfe ist nie gelaufen“ und „36,6 s waren der allererste Aufruf nach dem Rechnerstart“ stehen als Tatsache da

**Gewicht: gering.** Belegt am Text.

* `Intern/TESTPLAN.md:21`: *„eine Wartezeit gab es nicht, die Sanduhr-Abhilfe ist nie gelaufen. Die 36 609 ms an 7.2.2.137 waren der allererste Aufruf nach dem Rechnerstart; der Unterschied kommt nicht von der Abhilfe.“* Fast gleich in `Intern/BEFUNDE.md:411`.
* „Nie gelaufen“ stimmt nicht genau. Der Zeitgeber hat einmal geschlagen, die Meldung `nach 250 ms` stammt von diesem ersten Schlag. `Intern/BEFUNDE.md:411` sagt es richtig: *„kam also nicht zum Zug“*. Beide Stellen sollten dasselbe sagen.
* Dass die 36,6 s an 7.2.2.137 der allererste Aufruf nach einem Rechnerstart waren, steht im Repo nur als **Anweisung**: Schritt 4 an 7.2.2.137 verlangte *„nach einem Neustart des Rechners“* (`Intern/TESTPLAN.md:46`, freiwillig). Dass Gregor vorher neu gestartet hat, hat er laut Repo nicht bestätigt. In [L-163.1](LEKTOR-163.md#l-163.1) stand das als Vermutung. Ob er an 7.2.2.138 neu gestartet hat, ist ebenso offen. Das Urteil „nicht prüfbar“ ändert sich dadurch nicht.

**Soll:** In `TESTPLAN.md:21` „kam nicht zum Zug“ statt „ist nie gelaufen“ schreiben. Bei den 36,6 s „laut Testanweisung nach einem Rechnerstart“ ergänzen, an beiden Stellen.

### <a id="l-164.2"></a>L-164.2 — Schritt 2: der Suchbefehl zeigt fünf Zeilen, der Text sagt vier

**Gewicht: gering.** Gemessen.

* `Doku/BAUEN.md:243`: *„Nachsehen: `Select-String "EUDORA_VERSION4|EUDORA_BUILD_" Eudora71\Version.h`“*.
* Dasselbe Muster mit `grep -E` auf `Eudora71/Version.h` gibt die Zeilen 11, 12, 13, 14 **und** 19 aus: `#define EUDORA_BUILD_MONTH REG_EUD_CLIENT_7_1_MONTH`. Das ist dieselbe Falle, die [L-163.8](LEKTOR-163.md#l-163.8) bei der älteren Suche gemeldet hat. Die vier Namen stehen jetzt aber im Satz davor, deshalb ist die Gefahr klein.

**Soll:** Das Muster auf `"EUDORA_VERSION4|EUDORA_BUILD_(NUMBER|DESC|VERSION)"` einengen oder dazuschreiben: „`EUDORA_BUILD_MONTH` bleibt“.

## Hält etwas den PR auf?

**Nein.** Die beiden neuen Funde und die Reste von [L-163.3](LEKTOR-163.md#l-163.3), [L-163.4](LEKTOR-163.md#l-163.4) und [L-163.7](LEKTOR-163.md#l-163.7) sind gering oder hängen an Gregor. Die Funde, die vor dem PR stehen sollten, sind erledigt.
