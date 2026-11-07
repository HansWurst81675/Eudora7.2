# <a id="pruefer-108"></a>PRUEFER-108

Geprüft habe ich den Stand `c84bb8c5` des Zweigs `paket_7_2_2_137`, in meinem Zweig wt/pruefer-20261107c. Geprüft ist `git log -p b81bb8ea..HEAD -- Eudora71 tools/paket-bauen.ps1`. Das sind drei Commits: `a1bf7dc6` (nur `Version.h`, 137 → 138), `2869af1d` (Behebung von [PRÜFER-107](PRUEFER-107.md) K1/K4/K5 in `TridentView.cpp` und `TestE169.cpp`) und `454a8058` (Schalter `-EigenerBau` in `paket-bauen.ps1`, [E-248](../Intern/BEFUNDE.md#e-248)). Es ist ein kurzer Lauf vor dem PR.

Eudora habe ich weder gebaut noch gestartet und kein Fenster geöffnet. Keinen Prüfstand habe ich angefasst, `paket-bauen.ps1` habe ich nicht ausgeführt. Die Testsuite lief dreimal in meinem Baum: einmal unverändert, zweimal mit einer vorübergehenden Gegenprobe (§2). Danach habe ich `TridentView.cpp` aus der Sicherung zurückkopiert. `cmp` gegen `git show HEAD:` war gleich, `git status` war leer.

## Ergebnis vorweg

**Kein Fund hält den PR auf.** Die Testsuite ist grün, 429/429 (gemessen). Die Behebung von PRÜFER-107 K1 ist richtig: abgewiesen wird nur noch eine weitere *Vorschau*, ein Druck läuft durch (am Quelltext belegt). Die beiden neuen Prüfungen in `TestE169.cpp` sind nicht blind: jede der drei Gegenproben färbt sie rot (gemessen).

**`-EigenerBau` überspringt genau die neun Prüfer der Arbeitsweise und sonst nichts (am Quelltext belegt).** Schritt 7 (Laufzeit), Schritt 8 (jede ausführbare Datei aus dem Release-Bau, Debug-Muster), die Hilfeseiten und der Prüfbericht selbst bleiben. Versehentlich greift der Schalter nicht. `paket-bereit.pl` liest weiter dieselben neun Prüfer (gemessen).

**Die Zusage „keine Debug-Laufzeit" gilt nur mit `-Bauart Release` (K1, gering, am Quelltext belegt).** Die Vorgabe ist `Debug`. Wer `-EigenerBau` ohne `-Bauart Release` aufruft, bekommt still ein Debug-Paket, Schritt 8 läuft dann nicht. Die Anleitung in `Doku/BAUEN.md` nennt `-Bauart Release`, deshalb ist das nur gering.

Dazu kommt ein geringer Fund zur Beschreibung des Schalters (K2).

**Kennungen:** keine neue vergeben. E-251 und E-252 bleiben frei. Ich empfehle, K1 und K2 bei [E-248](../Intern/BEFUNDE.md#e-248) fortzuschreiben.

| Fund | Was passiert | Schwere | Hält den PR auf? |
|---|---|---|---|
| [K1](#k1) | `-EigenerBau` ohne `-Bauart Release` schnürt still ein Debug-Paket; Schritt 8 entfällt | gering | nein |
| [K2](#k2) | Kommentar und `BAUEN.md` verschweigen zwei übersprungene Prüfungen (Testplan-Voraussetzungen, VERSION gleich `Version.h`) | gering | nein |

## 1. TridentView.cpp: Behebung von PRÜFER-107 K1

* **Bedingung (belegt).** `if (bDoPreview && s_E242.uUhr && s_E242.bVorschau && !s_E242.hVorschau)` (`TridentView.cpp:2524`). Ein Aufruf ohne `bDoPreview` (Print, Print One, `CTocFrame::Print`) geht jetzt an der Abweisung vorbei. Die Serie aus der Postfachliste bricht also nicht mehr nach der ersten Nachricht ab.
* **Folge, bewusst in Kauf genommen (belegt).** Ein Druck während der Ladezeit ruft `E242Zurueckstellen("neuer Druck")`. Das schaltet Zeitgeber und Sanduhr ab (`:2381-2386`) und setzt `bVorschau = bDoPreview`, also `FALSE` (`:2685`). Die ladende Vorschau liest danach die Kopf- und Fußzeile des neuen Drucks. Das ist das „kleinere Übel" aus PRÜFER-107 K1 und PRÜFER-106 K7, kein neuer Fund. Eine dritte Vorschau in diesem Fenster würde nicht mehr abgewiesen, weil `bVorschau` jetzt aus ist. Das ist ein Randfall des Randfalls.
* **Kommentar (belegt).** Der neue Kommentar bei `:2646-2653` stimmt mit dem Code überein: Der Zeitgeber setzt die Sanduhr neu, solange `bSanduhr` gilt. Er verweist richtig auf PRÜFER-107 K3 (Flackern bei Mausbewegung). Die Zahlen 94 ms und 36,6 s stehen so in PRÜFER-107.

## 2. TestE169.cpp: neue Prüfungen und Gegenprobe

**Gemessen:** `RunTests.cmd` an `c84bb8c5`: 429 Tests, 429 bestanden.

**Gegenprobe, gemessen.** Ich habe `TridentView.cpp` vorübergehend mit Perl `:raw` geändert, je Änderung mit genau einem Treffer:

| Lauf | Änderung | Ergebnis |
|---|---|---|
| 1 | A: `if (bDoPreview && s_E242.uUhr` → `if (s_E242.uUhr` (Abweisung wieder für alle) und C: `s_E242.bSanduhr = (… (bDoPreview \|\| bDialog));` → `s_E242.bSanduhr = FALSE;` (Sanduhr nie) | 428/429; rot mit beiden Meldungen, Zeile 150 (K1) und Zeile 152 (K4) |
| 2 | B: `return FALSE;` aus dem Rumpf der Abweisung entfernt | 428/429; rot mit Zeile 150 |

Danach habe ich die Sicherung aus dem Scratchpad zurückkopiert: `cmp` gleich, `git status` leer.

**Zur Form (belegt).** `pP` ist nur der Abschnitt `CTridentView::Print` bis `SetFont`. Darin steht `E240SanduhrSetzen();` genau einmal (`:2527`; die zweite Stelle `:2467` liegt in `E242Uhr`, also in `pH`). Die Suche nach `"E240SanduhrSetzen(); return FALSE; }"` kann deshalb keinen anderen Rumpf treffen. PRÜFER-107 K4 ist damit geschlossen.

## 3. `tools/paket-bauen.ps1`, Schalter `-EigenerBau`

**Welche Prüfungen er überspringt (am Quelltext belegt).** Sieben Zusätze `-not $EigenerBau -and` stehen vor den Blöcken der Prüfer (`:102`, `:152`, `:203`, `:296`, `:337`, `:378`, `:420`). Im Block `:203` stecken drei Prüfer. Das ergibt neun Prüfer, also genau die neun, die `paket-bereit.pl` aus der Datei liest:

| Zeile | Prüfer | übersprungen |
|---|---|---|
| `:102` | `pruefe-datenverlust.pl` | ja |
| `:152` | `spuren-auswerten.pl` | ja |
| `:203` | `pruefe-doku-takt.pl` (CHANGELOG-Abschnitt, lückenlose Nummer, VERSION gleich `Version.h`) | ja |
| `:241` (im Block `:203`) | `testplan-voraussetzungen.pl` | ja, siehe K2 |
| `:265` (im Block `:203`) | `rollen-faellig.pl` | ja |
| `:296` | `pruefe-stand-md.pl` | ja |
| `:337` | `pruefe-befundurteile.pl` | ja |
| `:378` | `befunde-verlinken.pl` | ja |
| `:420` | `agenten-laufen.pl` | ja |
| `:457-498` | Prüfbericht | läuft, `FALSE` wird über `$OhnePruefbericht` hingenommen (`:90`) |

Die vier Abweisungen aus der Klonprobe (Rollen, CHANGELOG-Abschnitt, lückenlose Nummer, Standzeile) liegen alle in diesen Blöcken. Das passt zur Messung.

**Was bleibt (belegt).** Ab `:500` steht kein `$EigenerBau` mehr. Die Abbrüche bei fehlender Grundlage, fehlendem Bauverzeichnis und fehlender Quelldatei (`:507`, `:519`, `:546`), die Hilfeseiten (`:678-706`), Schritt 7 (`:753`) und Schritt 8 (`:797`, Abbruch bei fehlendem Gegenstück `:811` und bei Debug-Laufzeit `:821`) laufen also unverändert. Sie laufen aber nur mit `-Bauart Release`, siehe K1.

**Kann der Schalter versehentlich greifen? Nein (belegt).** Die Vorgabe ist `''`. Nur Leerzeichen oder weniger als 5 Zeichen führen zu `exit 2` (`:86`). `-EigenerBau` ohne Wert lehnt PowerShell ab. Kein anderer Parameter beginnt mit `E`, eine Abkürzung trifft also nichts anderes. Weil das Skript kein `[CmdletBinding()]` hat, ist der Parameter auch über seine Stellung erreichbar. Er steht an Position 8 (Zählung ab 0, ohne den Schalter `-AusBauverzeichnis`). Treffen würde ihn erst ein neunter Wert ohne Namen. Kein Aufrufer in `tools/` ruft `paket-bauen.ps1` so auf (grep). Ist der Schalter gesetzt, steht das in der Ausgabe (`:88`).

**`paket-bereit.pl` (gemessen).** Es liest die Prüfer mit dem Muster `Join-Path \(Split-Path -Parent \$PSCommandPath\) '([a-z0-9-]+\.pl)'` (`paket-bereit.pl:83`). Die Zusätze stehen in den `if`-Zeilen, nicht in den `Join-Path`-Zeilen. Gezählt: vorher (`b81bb8ea`) 9 Treffer, jetzt 9 Treffer, gleiche Namen. Den Schalter kennt `paket-bereit.pl` nicht. Das ist richtig, denn es misst für ein Paket des Projekts.

**Klonprobe, 0,7 min und „keine Fehler" (Vermutung, gestützt).** Übersprungen werden die Perl-Prüfer. Der Prüfbericht läuft, die Testsuite allein braucht in meinem Baum 7 s (gemessen). Danach wird kopiert und gepackt, kompiliert wird in `paket-bauen.ps1` nicht. 0,7 min passt dazu. Dass `paket-pruefen.ps1` keine Fehler meldet, passt zu einem Bau mit `-Bauart Release`, wie ihn `BAUEN.md:252` vorschreibt: Dann liefen Schritt 7 und 8. Wiederholt habe ich die Klonprobe nicht.

## Funde

### <a id="k1"></a>K1 (gering, am Quelltext belegt): `-EigenerBau` ohne `-Bauart Release` ergibt still ein Debug-Paket

Der Kommentar zum Schalter (`paket-bauen.ps1:74-82`) sagt: *„Die technischen Schritte bleiben: jede ausfuehrbare Datei aus dem Release-Bau, keine Debug-Laufzeit."* Das stimmt nur mit `-Bauart Release`. Die Vorgabe ist `Debug` (`:54`). Dann nimmt `:545` die Dateien aus `Bin\Debug`, und Schritt 7 und 8 entfallen (`:753`, `:797`). Für ein Paket des Projekts ist das alter Bestand. Wer aber einen eigenen Bau weitergibt, für den ist ein Debug-Paket genau der Fehler, vor dem Schritt 8 schützt (der Absturz in `ucrtbased.dll`, 26.10.2026).

**Abhilfe:** Mit `-EigenerBau` entweder `-Bauart Release` erzwingen (abweisen oder umstellen und das melden) oder wenigstens eine Warnung ausgeben, wenn `$Bauart -ne 'Release'`.

### <a id="k2"></a>K2 (gering, am Quelltext belegt): zwei übersprungene Prüfungen sind nicht genannt

Der Kommentar `:74-82` und `Doku/BAUEN.md:259-262` zählen die übersprungenen Prüfungen auf. Zwei fehlen:
* `testplan-voraussetzungen.pl` (`:241`). Er steht im Block der Doku-Prüfung und fällt deshalb mit weg. Für einen eigenen Bau ist das harmlos.
* Die Prüfung „VERSION und `Version.h` nennen dieselbe Nummer" in `pruefe-doku-takt.pl`. Sie ist halb technisch: `--fassung` für die Hilfeseiten kommt aus `VERSION` (`:685-688`). Wer in einem Fork nur `Version.h` hochzählt, bekommt Hilfeseiten mit der alten Nummer, und keine Prüfung warnt mehr.

**Abhilfe:** beide in Kommentar und `BAUEN.md` nennen. Den Abgleich von VERSION und `Version.h` könnte man auch bei `-EigenerBau` laufen lassen, als Warnung.
