# <a id="lektor-163"></a>LEKTOR-163 (07.11.2026) — Zweig `paket_7_2_2_137` nach c84bb8c5: Anleitung „Ein eigenes Release-ZIP bauen“ nach der zweiten Klonprobe, Erledigungsstand LEKTOR-162, Testergebnisse 7.2.2.137/7.2.2.138

**Umfang:** `git diff 8fb6db54..HEAD -- '*.md'` (11 Dateien). Schwerpunkt ist der neu geschriebene Abschnitt in `Doku/BAUEN.md:202-291`. Ich habe ihn gegen den `param`-Block und die Schranken in `tools/paket-bauen.ps1`, gegen `tools/bauen.ps1` und gegen den Nachtrag zu [E-248](../Intern/BEFUNDE.md#e-248) (Release-ZIP aus einem frischen Klon) gehalten. Dazu kommen die Testergebnisse in `Intern/TESTPLAN.md`, die Nachträge zu [E-240](../Intern/BEFUNDE.md#e-240) (Druckvorschau ohne Rückmeldung), [E-241](../Intern/BEFUNDE.md#e-241) (Bild ↑/↓ in der Vorschau) und [E-242](../Intern/BEFUNDE.md#e-242) (Pfad der Zwischendatei auf dem Ausdruck), PAKETE und CHANGELOG 7.2.2.138 sowie der Kopf von WEITERMACHEN. Gebaut und gestartet habe ich nichts.

**Urteil:** Mit der Anleitung kommt jemand ohne Vorwissen von einem frischen `git clone` zu einem eigenen, geprüften ZIP. Reihenfolge, Schalter und Ausnahmen stimmen mit dem Quelltext überein (siehe unten). Am Ende hört der Weg aber auf: **Veröffentlichen** auf GitHub geht mit dem genannten Befehl aus diesem Klon nicht ([L-163.3](#l-163.3)). Gerade das gehört zu Gregors Forderung *„… um es auf github zu veröffentlichen!“*. Von [LEKTOR-162](LEKTOR-162.md#lektor-162) sind sieben Funde erledigt, einer zur Hälfte ([L-162.3](LEKTOR-162.md#l-162.3) → [L-163.2](#l-163.2)). **Datenschutz: kein Treffer.** **8 Funde.** Vor dem PR: [L-163.1](#l-163.1) bis [L-163.3](#l-163.3), das sind Textänderungen. Den Code betrifft keiner.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): *„Kein Widerspruch gefunden.“* Dazu Hinweise *„nennt weder …“*, wie in [LEKTOR-162](LEKTOR-162.md#lektor-162).
* **Datenschutz (gemessen):** `perl tools/pruefe-namen-gestaget.pl --commit <rev>` für `2869af1d`, `dfa32f0c`, `454a8058`, `62c58b23` und `c84bb8c5` meldet jeweils *„kein Name aus der lokalen Liste (commit, 11 Muster)“*. Die hinzugefügten MD-Zeilen habe ich zusätzlich mit `grep` nach `@…`, `Betreff:`, `Subject:`, `Postfach`, `Ordner` und `Absender` durchsucht und die Treffer gelesen. Gefunden habe ich nur allgemeine Wörter: PRÜFER-107 schreibt „aus der Postfachliste“, der Testplan nennt „Mail mit Bildern aus dem Netz“. Keine Namen, keine Adressen, keine Ordnernamen, keine Betreffs und keine Inhalte aus Gregors Mails.

## Funde

### <a id="l-163.1"></a>L-163.1 — Test 7.2.2.138, Schritt 2: „bestanden“, obwohl die Wartezeit nicht eingetreten ist; „statt 36,6 s“ klingt nach einer Beschleunigung, die die Abhilfe gar nicht leistet

**Gewicht: mittel.** Belegt am Text. **Vor dem PR.**

* `Intern/TESTPLAN.md:16`, Schritt 2, Maßstab: *„bis die Vorschau da ist, die Sanduhr zu sehen ist, auch während die Maus sich bewegt.“* Verlangt ist das *„nach einem **Neustart des Rechners**“*, also beim langsamen ersten Aufruf.
* `Intern/TESTPLAN.md:21`: *„Schritt 2 **bestanden** — das Vorschaufenster kam in sechs Aufrufen nach 250–300 ms (`E-242 Vorschaufenster da nach 250 ms`; an 7.2.2.137 waren es 36 609 ms)“*. Dieselbe Zeile sagt zu Schritt 3: *„**nicht prüfbar**, weil das Fenster zu schnell da war“*.
* Die Abhilfe für 7.2.2.138 lädt nichts schneller. Sie hält nur die Sanduhr, und zwar mit einem Zeitgeber, der alle 250 ms nachsieht (`Intern/BEFUNDE.md:411`: *„der Zeitgeber `E242Uhr` setzt die Sanduhr bei jedem Schlag (250 ms) neu“*; früher in derselben Zelle: *„Abhilfe dann höchstens Rückmeldung (Sanduhr), nicht schneller laden“*). „Nach 250 ms“ ist also der erste Schlag des Zeitgebers, das Fenster war spätestens dann da. Bei 250 ms gibt es keine Wartezeit, in der die Sanduhr gegen die Mausbewegung hätte stehen müssen. Was Schritt 2 prüfen soll, ist so wenig eingetreten wie bei Schritt 3.
* Vermutung, nicht gemessen: Der langsame erste Aufruf (36,6 s an 7.2.2.137, rund 38 s an 7.2.2.136) trat diesmal nicht auf, weil die Teile der Vorschau schon geladen waren. Ob vorher neu gestartet wurde, sagt das Ergebnis nicht.
* Dieselbe Lesart steht in `Intern/BEFUNDE.md:411` ([E-240](../Intern/BEFUNDE.md#e-240)): *„Vorschaufenster in sechs Aufrufen nach 250–300 ms (vorher 36,6 s)“*. Als „Was noch fehlt“ nennt die Zelle nur noch *„der zweite Klick während der Wartezeit ist nicht geprüft“*. Die Sanduhr während der Wartezeit ist genauso ungeprüft. Die Commit-Nachricht `c84bb8c5` lautet *„Schritt 2 bestanden: Fenster nach 250-300 ms statt 36,6 s“*.

**Soll:** In `Intern/TESTPLAN.md:21` Schritt 2 als „nicht prüfbar (Vorschau nach höchstens 250 ms da, der langsame erste Aufruf trat nicht auf)“ werten. In [E-240](../Intern/BEFUNDE.md#e-240) „vorher 36,6 s“ als Beobachtung kennzeichnen, nicht als Wirkung der Abhilfe. „Was noch fehlt“ ergänzen: „Sanduhr **und** zweiter Klick beim langsamen ersten Aufruf“. Sonst gilt [E-240](../Intern/BEFUNDE.md#e-240) beim nächsten Release-Entscheid als bestätigt, ohne dass die Abhilfe je gelaufen ist.

### <a id="l-163.2"></a>L-163.2 — E-248: Messmarke gesetzt, aber die Tabellen zeigen als „was noch fehlt“ weiter das erledigte erste Stück (Rest von L-162.3)

**Gewicht: mittel.** Gemessen am Text. **Vor dem PR.**

* Erledigt ist die Marke: `Intern/BEFUNDE.md:403` *„**Zuletzt gemessen: 07.11.2026 an 7.2.2.137** (Klonprobe …)“*. `CHANGELOG.md:31` und `Intern/WEITERMACHEN.md:108` übernehmen sie (*„07.11.2026 an 7.2.2.137“*).
* Offen ist der Rest: Mitten in der Zelle `Intern/BEFUNDE.md:403` steht weiter ungekennzeichnet *„**Was noch fehlt:** Schritt 8 nimmt die in Schritt 7 aus dem Redist-Ordner gelegten Dateien aus; das Plug-in kommt aus der Grundlage …; ein Abschnitt *Ein eigenes Release-ZIP bauen* …; Gegenprobe aus einem frischen `git clone`.“* Laut Nachtrag in derselben Zelle ist das alles erledigt. Das Werkzeug für die Tabellen nimmt das **erste** „Was noch fehlt“. Deshalb zeigen `CHANGELOG.md:31` und `Intern/WEITERMACHEN.md:108` weiter *„Schritt 8 nimmt die in Schritt 7 aus dem Redist-Ordner gelegten Dateien aus; das Plug-in kommt aus der Grundlage …“* als offen. Offen ist tatsächlich nur noch der MIDL-Rest.

**Soll:** Das erste „Was noch fehlt“ umschreiben, so wie in [E-240](../Intern/BEFUNDE.md#e-240) und [E-242](../Intern/BEFUNDE.md#e-242) geschehen: „**Damals fehlte:** …“ bzw. „Erledigt am 07.11.2026 ([L-162.3](LEKTOR-162.md#l-162.3)/[L-163.2](#l-163.2)): …“. Dann kommt der MIDL-Rest von selbst in die Tabellen.

### <a id="l-163.3"></a>L-163.3 — Anleitung, Schritt 5 „Veröffentlichen“: aus diesem Klon kommt man so nicht zu einem GitHub-Release

**Gewicht: mittel.** Belegt am Text. Was `gh` tut, ist belegt nach dessen Hilfe, gemessen habe ich es nicht. **Vor dem PR.** Das betrifft Gregors Forderung *„… um es auf github zu veröffentlichen!“* unmittelbar.

* `Doku/BAUEN.md:224` klont `https://github.com/HansWurst81675/Eudora7.2.git`, und `:246` sagt *„ein Push ist nicht nötig“*.
* `Doku/BAUEN.md:288-290`: *„`gh release create v7.2.2.139 C:\Temp\Eudora72-eigen.zip --title "…" --notes-file <Text>` — in einem eigenen Fork.“* Wie man zu diesem Fork kommt, steht nirgends. Drei Lücken:
  1. In diesem Klon zeigt `origin` auf das Projekt. Ohne Fork und ohne Umstellen von `origin` (`gh repo fork --remote` oder `git remote set-url`) zielt `gh release create` auf das Projekt-Repo. Dort hat ein Außenstehender keine Rechte.
  2. Der Commit „eigener Bau 7.2.2.139“ liegt nur lokal. Gibt es die Marke `v7.2.2.139` noch nicht, legt `gh release create` sie ohne `--target` auf den Stand des Standardzweigs im Fork, nicht auf den gebauten Commit. Die Quelle zum Release stimmt dann nicht mit dem ZIP überein. Nötig sind `git push -u origin eigener-bau` und `--target eigener-bau` (oder die Marke vorher selbst setzen und pushen).
  3. `gh` braucht eine Anmeldung (`gh auth login`). In den Voraussetzungen `:218` steht nur *„die GitHub CLI `gh“*. Den Weg über die Release-Seite im Browser nennt die Anleitung auch nicht (vorgeschlagen in [L-162.6](LEKTOR-162.md#l-162.6)).
* Nebenbei, gering: Die eigene Nummer „die nächste nach dem Stand des Klons“ (`:235-237`) ist zugleich die nächste Nummer des Projekts. `:240` begründet die eigene Nummer aber damit, nicht dieselbe Nummer wie ein Release des Projekts zu tragen. Ein Satz dazu, dass die Nummer nur bis zum nächsten Projekt-Release frei ist, würde genügen.

**Soll:** Schritt 5 als kurze Folge schreiben: `gh auth login` → `gh repo fork --remote` (stellt `origin` auf den Fork um) → `git push -u origin eigener-bau` → `gh release create v7.2.2.139 <ZIP> --target eigener-bau --title … --notes-file …`. Alternativ die Release-Seite im Browser nennen. Unter Schritt 1 einen Hinweis, dass wer veröffentlichen will, gleich seinen Fork klonen kann.

### <a id="l-163.4"></a>L-163.4 — E-240/E-242: Gregors Test an 7.2.2.138 steht im Testplan, die Befunde und Tabellen nennen ihn noch als offen bzw. haben die Marke 7.2.2.137

**Gewicht: gering.** Gemessen am Text.

* `Intern/TESTPLAN.md:21` zu Schritt 4: *„Kopf und Fuß laut Protokoll gesetzt (`E-242 gesetzt: … gesetzt=1 … gesetzt=1`), zurückgestellt jeweils erst beim Schließen“*. Ob Gregor Kopf und Fuß gesehen hat, sagt die Zeile nicht. Ein *bestanden* oder *nicht bestanden* fehlt, obwohl der Maßstab in `:18` ein Sichtbefund ist.
* `Intern/BEFUNDE.md:409` ([E-242](../Intern/BEFUNDE.md#e-242)) hat weiter *„**Was noch fehlt:** Gregors Test an 7.2.2.138 (Schritt 4: Kopf und Fuß weiter richtig)“*. Diesen Wortlaut zeigen auch `CHANGELOG.md:36` und `Intern/WEITERMACHEN.md:113`.
* [E-240](../Intern/BEFUNDE.md#e-240) und [E-242](../Intern/BEFUNDE.md#e-242) tragen weiter *„**Zuletzt gemessen: 07.11.2026 an 7.2.2.137**“* (`CHANGELOG.md:36`, `:38`; `Intern/WEITERMACHEN.md:113`, `:115`). Die Messung an 7.2.2.138 aus Gregors `eudora.log` fehlt dort.

**Soll:** Schritt 4 bei Gregor erfragen oder als „laut Protokoll gesetzt, Sichtbefund fehlt“ werten. [E-242](../Intern/BEFUNDE.md#e-242) entsprechend nachtragen und die Marke auf 7.2.2.138 setzen, dazu die Marke von [E-240](../Intern/BEFUNDE.md#e-240).

### <a id="l-163.5"></a>L-163.5 — WEITERMACHEN-Kopf: „Gregor testet“ ist seit c84bb8c5 überholt

**Gewicht: gering.** Gemessen am Text.

* `Intern/WEITERMACHEN.md:16` *„**In Arbeit: Testpaket 7.2.2.138** (geschnürt, Gregor testet; davor 7.2.2.137 getestet, …)“*. Im selben Commit `c84bb8c5` kam das Ergebnis in `Intern/TESTPLAN.md:21`.

**Soll:** „geschnürt, von Gregor am 07.11.2026 getestet (Schritt 2 und 3 nicht prüfbar, siehe Testplan)“. Die Lesart folgt [L-163.1](#l-163.1).

### <a id="l-163.6"></a>L-163.6 — Anleitung: „jede ausführbare Datei aus dem Release-Bau“ steht wieder da (Rest von L-162.5)

**Gewicht: gering.** Belegt am Quelltext.

* `Doku/BAUEN.md:265-266` *„Die technischen Schritte bleiben: **jede ausführbare Datei aus dem Release-Bau**, keine Debug-Laufzeit.“*
* Drei Zeilen weiter, `:271-273`, steht es richtig: *„— außer der Laufzeit aus dem Redist-Ordner von Visual Studio und den mitgelieferten Plug-ins“*. Der Quelltext gibt `:271-273` recht: `tools/paket-bauen.ps1` Schritt 7/8, Ausnahme `$ausRedist`. Der Satz in `:265-266` stammt fast wörtlich aus dem Kommentar `tools/paket-bauen.ps1:80-81`.

**Soll:** In `:265-266` „jede ausführbare Datei aus dem Release-Bau (Ausnahmen unten)“ schreiben, oder nur „keine Debug-Laufzeit, keine alte Fassung aus der Grundlage“.

### <a id="l-163.7"></a>L-163.7 — Voraussetzungen: Pfad ohne Leerzeichen, ATL, Dauer des Prüfstands

**Gewicht: gering.** Belegt am Repo-Bestand.

* **Leerzeichen im Pfad:** `Doku/BAUEN.md:225` *„cd Eudora7.2“* nach dem Klonen im aktuellen Verzeichnis. Unter `C:\Users\<Vorname Nachname>\…` liegt der Klon dann in einem Pfad mit Leerzeichen. Für Schritt 4 (Prüfstand) ist das ein bekannter Fehler: [E-244](../Intern/BEFUNDE.md#e-244) (*„Liegt der Klon in einem Pfad mit Leerzeichen, startet kein Prüfserver“*), dazu `Doku/PRUEFSTAND.md:206`. Bau und Paket sind in einem solchen Pfad nicht gemessen. Beide Klonproben lagen unter `C:\Temp`.
* **ATL:** `Doku/BAUEN.md:213-214` nennt *„Desktopentwicklung mit C++ einschließlich MFC“*. `Eudora71/Eudora/Eudora.vcxproj:28` und `:36` setzen `<UseOfAtl>Static</UseOfAtl>`. Der ältere Abschnitt `Doku/BAUEN.md:124` nennt deshalb *„MFC/ATL, Windows SDK“*. Vermutung: ATL ist in dieser Arbeitslast meist schon vorgewählt. Ein Wort kostet nichts.
* **Prüfstand:** `:285-286` verweist für die Regressionstests auf den Prüfstand. Dass ein voller Lauf rund 91 Minuten dauert und dabei Eudora-Fenster aufgehen (`Releases/PRUEFBERICHT.md`: *„Pruefstand, 110 Faelle, 67 Eudora-Starts | 91 min 16 s“*), steht nicht dabei.

**Soll:** Unter *Voraussetzungen* einen Klonpfad ohne Leerzeichen empfehlen (etwa `C:\src`), „MFC und ATL“ schreiben und bei Schritt 4 Dauer und Fenster nennen.

### <a id="l-163.8"></a>L-163.8 — Schritt 2 nennt die vier Zeilen nicht, der Verweis führt über zwei Stationen

**Gewicht: gering.** Belegt am Text.

* `Doku/BAUEN.md:237-239` *„vier Zeilen in `Eudora71/Version.h` — welche, steht im Abschnitt [Vor dem Bau: die Version heben]“*. Dort (`:69-76`) steht eine Suche, die auch `EUDORA_BUILD_MONTH` trifft (`Eudora71/Version.h:19`). Die eigentliche Tabelle steht erst in `Releases/PAKETE.md:87-93`, mit einem Beispiel nach dem alten Schema `1.0.18 / 7.2.0.18`.
* Gemessen in `Eudora71/Version.h:11-14`: Zu ändern sind genau `EUDORA_VERSION4`, `EUDORA_BUILD_NUMBER`, `EUDORA_BUILD_DESC` und `EUDORA_BUILD_VERSION`. Die Datei ist reines ASCII, ein Editor kann also nichts an der Kodierung verderben.

**Soll:** Die vier Namen mit Vorher und Nachher für 138 → 139 direkt in Schritt 2 schreiben, etwa `EUDORA_VERSION4 138` → `139` und `"Version 7.2.2.139\0"`.

## Erledigungsstand LEKTOR-162

| Fund | Stand | Beleg |
|---|---|---|
| [L-162.1](LEKTOR-162.md#l-162.1) Gregors Druck an 7.2.2.137 fehlt in [E-242](../Intern/BEFUNDE.md#e-242)/README | **erledigt** | `Intern/BEFUNDE.md:409` *„Erledigt am 07.11.2026 ([L-162.1](LEKTOR-162.md#l-162.1)): … Druck über Microsoft Print to PDF bestanden“*; `README.md:239` *„der Druck über Microsoft Print to PDF ist von Gregor an 7.2.2.137 bestanden“*; `CHANGELOG.md:36` und `Intern/WEITERMACHEN.md:113` mit neuem „was noch fehlt“ |
| [L-162.2](LEKTOR-162.md#l-162.2) alter Schluss in [E-240](../Intern/BEFUNDE.md#e-240) | **erledigt** | `Intern/BEFUNDE.md:411` *„Überholt durch den Nachtrag oben ([L-162.2](LEKTOR-162.md#l-162.2)): damals nicht gemessen waren …“*; `CHANGELOG.md:38` und `Intern/WEITERMACHEN.md:115` mit neuem „was noch fehlt“ (Inhalt siehe [L-163.1](#l-163.1)) |
| [L-162.3](LEKTOR-162.md#l-162.3) [E-248](../Intern/BEFUNDE.md#e-248) ohne Marke, Tabellen veraltet | **zur Hälfte** | Marke gesetzt (`Intern/BEFUNDE.md:403`, `CHANGELOG.md:31`); das erste „Was noch fehlt“ ist weiter ungekennzeichnet, siehe [L-163.2](#l-163.2) |
| [L-162.4](LEKTOR-162.md#l-162.4) eigene Nummer, Hook, Reihenfolge | **erledigt** | `Doku/BAUEN.md:221-246`: eigener Zweig, Nummer heben und committen vor dem Bau; Hook ausdrücklich weggelassen mit Grund (`:229-233`); belegt gegen `tools/bauen.ps1:223-254` (nur Commit nötig, kein Push) |
| [L-162.5](LEKTOR-162.md#l-162.5) „jede ausführbare Datei“ | **erledigt, mit Rest** | `Doku/BAUEN.md:269-273` richtig; derselbe Satz kommt in `:265-266` wieder, siehe [L-163.6](#l-163.6) |
| [L-162.6](LEKTOR-162.md#l-162.6) `gh`, `-TrotzDatenverlust` | **erledigt** | `Doku/BAUEN.md:218` *„Zum Veröffentlichen zusätzlich die GitHub CLI `gh`“*; `-EigenerBau` überspringt die Datenverlust-Schranke (`tools/paket-bauen.ps1:102`, in der Anleitung `:260`), der Schalter wird im fremden Klon also nicht mehr gebraucht; `gh auth login` fehlt weiter ([L-163.3](#l-163.3)) |
| [L-162.7](LEKTOR-162.md#l-162.7) [E-241](../Intern/BEFUNDE.md#e-241) „zwei Vermutungen“ | **erledigt** | `Intern/BEFUNDE.md:410` *„eine Vermutung gemessen widerlegt“*; `CHANGELOG.md` 7.2.2.138 *„eine Vermutung widerlegt“* |
| [L-162.8](LEKTOR-162.md#l-162.8) Stand nach dem Sprung auf 138 | **erledigt** | `README.md:240` *„im Testpaket 7.2.2.138 bleibt sie bis zur Vorschau stehen“*; `Intern/WEITERMACHEN.md:16` auf 7.2.2.138; `Releases/PAKETE.md` 7.2.2.138 *„Geschnürt am 07.11.2026 um 16:08 …“* mit Größen und SHA-256; `CHANGELOG.md` Abschnittskopf *„geschnürt am 07.11.2026“*. Neuer Rest: [L-163.5](#l-163.5) |

## Was sich als richtig erwiesen hat (belegt am Quelltext)

* **`-EigenerBau` (belegt):** `tools/paket-bauen.ps1:83` `[string]$EigenerBau = ''`. Bei weniger als 5 Zeichen bricht `:86` mit Rückgabe 2 ab. Das Beispiel *„eigener Bau“* in `Doku/BAUEN.md:252` hat 11 Zeichen. `:90` setzt `$OhnePruefbericht`, damit stimmt *„baut auch, wenn der Prüfbericht nicht BESTANDEN meldet (der Bericht läuft trotzdem …)“* (`Doku/BAUEN.md:262-263`): `pruefbericht.pl` läuft ohne Bedingung (`:475-486`).
* **Übersprungene Schranken (belegt):** `-not $EigenerBau` steht vor Datenverlust (`:102`), Spurmarken (`:152`), Doku-Takt (`:203`, mit Testplan-Voraussetzungen und Rollen im selben Block bis `:283`), Standzeilen (`:296`), Befundurteilen (`:337`), Verweisen (`:378`) und laufenden Agenten (`:420`). Das ist genau die Aufzählung in `Doku/BAUEN.md:259-262`. Die technischen Abbrüche bleiben: Perl, Hilfeseiten, Schritt 8 mit Gegenstück und Debug-Laufzeit (`:811`, `:821`).
* **Ein Commit genügt, kein Push (belegt):** `tools/bauen.ps1:223-254` prüft nur `git status --porcelain`. Ausgenommen sind `Eudora71/Bin/*`, `Eudora71/*/Build/*`, `Releases/*` und `tools/TESTLAEUFE.md`. Damit stört auch `Releases/PRUEFBERICHT.md`, das `paket-bauen.ps1` neu schreibt, einen zweiten Bau nicht. `git commit -am` erfasst `VERSION` und `Version.h`, beide sind versioniert.
* **`bauen.ps1` ohne Schalter (belegt):** `tools/bauen.ps1:185` `$Konfiguration = 'Release'`.
* **`C:\Temp` muss nicht vorhanden sein (belegt):** `tools/paket-bauen.ps1:512` `New-Item -ItemType Directory -Force -Path $Ziel` legt auch das Elternverzeichnis an, bevor `:832` das ZIP daneben schreibt.
* **`Eudora starten.cmd` im Paket (belegt):** `tools/paket-bauen.ps1:642`.
* **Hook weglassen (belegt):** Die Meldung *„MANGEL“* kommt aus `tools/hooks-einrichten.sh:123` (Doku-Prüfung im pre-commit). Ohne Hook prüft nur noch `bauen.ps1`, und das verlangt keine Projekt-Doku.
* **Zahlen der zweiten Klonprobe (gemessen am Text):** `Doku/BAUEN.md:208-210` (0,7 min, *„keine Fehler“*, Produktversion 7.2.2.139) stimmt mit dem Nachtrag `Intern/BEFUNDE.md:403` überein.
* **PAKETE 7.2.2.138:** Größen und SHA-256 beider ZIPs stehen da. Der Paketname `Eudora72-7.2.2.138-release` ist ein Paketname, keine Angabe aus Gregors Mails.

## Was nur Gregor entscheiden kann

Nichts Neues. Ob Schritt 4 an 7.2.2.138 bestanden ist, kann nur Gregor sagen ([L-163.4](#l-163.4)). Das ist eine Frage nach seinem Sichtbefund, keine Entscheidung.
