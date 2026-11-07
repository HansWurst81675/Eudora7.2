# <a id="lektor-161"></a>LEKTOR-161 (07.11.2026) — Zweig `paket_7_2_2_137` nach 1b18d0f7: Nachlauf zu LEKTOR-160, Einarbeitung vor dem Test-ZIP 7.2.2.137

**Umfang:** geprüft habe ich nur, was seit [LEKTOR-160](LEKTOR-160.md#lektor-160) (`02c94187`) dazukam: `git log --stat 02c94187..HEAD` (sieben Commits, davon zwei mit Text: `7e102069` Versionssprung und Einarbeitung, `1b18d0f7` Messung am Paketbau). Dazu die geänderten MD-Dateien `CHANGELOG.md`, `Releases/PAKETE.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`, `Intern/FILTER.md`, `Intern/BEFUNDE.md`, `Doku/MITARBEITEN.md`. Die Aussagen habe ich gegen [PRÜFER-106](PRUEFER-106.md#pruefer-106) (Prüfung des Codes im selben Zweig) und gegen `Eudora71/Eudora/TridentView.cpp` (Abschnitt E242 und `CTridentView::Print`) gehalten. Gebaut und gestartet habe ich nichts.

**Urteil:** Die Einarbeitung ist in der Sache richtig. Der Code tut, was [E-242](../Intern/BEFUNDE.md#e-242) (Pfad der Zwischendatei auf Ausdruck und Vorschau) und [E-247](../Intern/BEFUNDE.md#e-247) (`&` im Betreff wird zum Platzhalter des Internet Explorer) über ihn sagen. Die Messung am Paketbau ist belegt. **Nichts davon hält das Test-ZIP auf.** Von den zehn Funden aus [LEKTOR-160](LEKTOR-160.md#lektor-160) sind fünf erledigt, drei teilweise, zwei offen. **5 neue Funde**, keiner betrifft das Verhalten des Programms. Vor dem PR sollte mindestens [L-161.1](#l-161.1) berichtigt sein: Der Testplan sagt schon jetzt, das Paket liege bereit, vier andere Stellen sagen „noch nicht geschnürt“.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): *„Quellstand 7.2.2.137“*, *„Paketnummer 7.2.2.137“*, *„gepruefte Dateien 58“*, *„Kein Widerspruch gefunden.“* Dazu 27 Hinweise *„nennt weder den Quellstand 7.2.2.137 noch die Paketnummer …“* (in [LEKTOR-160](LEKTOR-160.md#lektor-160) waren es 23). Neu dabei sind unter anderem `Doku/FAQ.md` und `Doku/PRUEFSTAND.md` (*„hoechste genannte Fassung: 7.2.2.136“*). Das ist die Folge des Versionssprungs, kein Widerspruch.
* `perl tools/offene-befunde.pl` (gemessen): *„offen laut Intern/BEFUNDE.md 62“*, *„davon aktuell gemessen 12 (ab Nummer 132)“*, *„davon veraltet gemessen 35“*, *„davon NIE gemessen 15“*, *„in Intern/WEITERMACHEN.md 62“*, *„62 offene Befunde, in beiden Listen gleich.“* Gegenüber [LEKTOR-160](LEKTOR-160.md#lektor-160) (61, davon 16 nie gemessen): plus [E-247](../Intern/BEFUNDE.md#e-247) neu, minus [E-242](../Intern/BEFUNDE.md#e-242) und [E-240](../Intern/BEFUNDE.md#e-240) (Druckvorschau ohne Rückmeldung) bei „nie gemessen“. Das stimmt mit der Stufentabelle `Intern/BEFUNDE.md:159-163` überein (*„unkritisch | 21“*, *„zusammen | 62 | 201 | 263“*).
* Messung am Paketbau (gemessen an den Dateien): `tools/TESTLAEUFE.md` hat für den Bau *„Eudora 7.2.2.137+7e102069 2026-11-07 14:26“* sechs Läufe von 14:29:15 bis 14:33:40 (`E169`, `E169`, `E169B`, `E118`, `E71`). `Releases/PRUEFBERICHT.md:23-25` sagt *„429 | 429 | 0“* (Unit-Tests), *„19 | 19 | 0“* (Schranken) und *„114 | 9 | 0 | 105 an anderem Bau“* (Prüfstand). Die 9 sind 2 × [E-242](../Intern/BEFUNDE.md#e-242), 5 × [E-169](../Intern/BEFUNDE.md#e-169) (Druck mit Hintergründen) und 2 × [E-71](../Intern/BEFUNDE.md#e-71) (leerer Filterbericht), wie in der Commit-Nachricht von `1b18d0f7`. Das Gesamturteil *„NICHT VOLLSTAENDIG“* (`:8`) entspricht Gregors Entscheidung *„ZIP ohne vollen Lauf“* (`Arbeitsweise/entscheidung-p137-ohne-vollen-lauf-07-11.md:10`).

## Funde aus LEKTOR-160 — heutiger Stand

| Fund | Stand | Beleg (heute) |
|---|---|---|
| [L-160.1](LEKTOR-160.md#l-160.1) TESTPLAN-Kopf „kein neuer Testabschnitt“ | **erledigt** | `Intern/TESTPLAN.md:3` *„**Stand:** Quellstand 7.2.2.137 (Testpaket, Stand 07.11.2026, Test unten)“*. Der Hinweis „Entwurf“ ist aus `:11` heraus. Dafür steht dort jetzt zu früh, das Paket liege bereit ([L-161.1](#l-161.1)) |
| [L-160.2](LEKTOR-160.md#l-160.2) [E-242](../Intern/BEFUNDE.md#e-242) „Originalfehler“ im CHANGELOG | **erledigt** | `CHANGELOG.md:129` *„([E-242](../Intern/BEFUNDE.md#e-242); Quelltext original, Verhalten am Original nicht gemessen)“* |
| [L-160.3](LEKTOR-160.md#l-160.3) [E-242](../Intern/BEFUNDE.md#e-242)/[E-240](../Intern/BEFUNDE.md#e-240) „nie gemessen“ | **erledigt** | Marken `Intern/BEFUNDE.md:408` und `:410` *„**Zuletzt gemessen: 07.11.2026 an 7.2.2.137**“*. Die Tabellen `CHANGELOG.md:35`, `:37` und `Intern/WEITERMACHEN.md:111`, `:113` zeigen *„07.11.2026 an 7.2.2.137“*. Belegt durch `tools/TESTLAEUFE.md` (Läufe 14:29 bis 14:32 am Bau `7e102069`) |
| [L-160.4](LEKTOR-160.md#l-160.4) FILTER.md: [E-71](../Intern/BEFUNDE.md#e-71) zweimal offen | **teilweise** | Der Absatz ist berichtigt: `Intern/FILTER.md:361-362` *„[E-71](../Intern/BEFUNDE.md#e-71) ist durch die Doku erledigt.“* Die Zeile `:734` sagt jetzt *„**Erledigt durch die Doku am 07.11.2026**“*, steht aber weiter in der Tabelle unter `:727` *„Die folgenden Befunde betreffen die Filter und sind **offen**.“* Sie gehört in die Aufzählung „Behoben, aber gut zu wissen“ |
| [L-160.5](LEKTOR-160.md#l-160.5) „107 Fälle“ | **offen** | `Intern/TESTPLAN.md:79` *„`Ergebnis: 107 Faelle, 107 bestanden, 0 fehlgeschlagen`“*, ebenso `Doku/PRUEFSTAND.md:214`. Der Prüfbericht zählt jetzt 114 (`Releases/PRUEFBERICHT.md:25`) |
| [L-160.6](LEKTOR-160.md#l-160.6) [E-71](../Intern/BEFUNDE.md#e-71): alte Sätze, EINSTELLUNGEN.md | **teilweise** | Berichtigt ist in `Intern/BEFUNDE.md:335` *„**Was damals noch fehlte (überholt durch den Nachtrag vom 07.11.2026):**“*. Ohne Kennzeichnung stehen weiter *„Nicht von selbst aufgreifen: Gregor hat ihn ausdrücklich auf die nächste Fassung geschoben“* und *„Gregors Zurückstellung gilt weiter.“* In `Intern/EINSTELLUNGEN.md` kommt `FilterReport` weiterhin 0-mal vor (gemessen, `grep -c`) |
| [L-160.7](LEKTOR-160.md#l-160.7) [E-241](../Intern/BEFUNDE.md#e-241) im Paket? | **erledigt** | `Intern/WEITERMACHEN.md:19` *„[E-241](../Intern/BEFUNDE.md#e-241) **nicht** dabei (Ursache ungeklärt)“*, ebenso `CHANGELOG.md:127` |
| [L-160.8](LEKTOR-160.md#l-160.8) `PrintHeaders=0` undokumentiert | **erledigt** | `Intern/BEFUNDE.md:408` *„**Mit `PrintHeaders=0`** … setzt Eudora jetzt leere Kopf- und Fußzeilen — das war im Original schon so gedacht“* und `CHANGELOG.md:129`. Die Aussage zum Original ist belegt, siehe „Was sich als richtig erwiesen hat“. Damit entfällt auch die Frage an Gregor aus [LEKTOR-160](LEKTOR-160.md#lektor-160) |
| [L-160.9](LEKTOR-160.md#l-160.9) E-129-Nachtrag nicht in der Tabelle | **offen** | `CHANGELOG.md:67` *„22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet**“*, *„beide Mängel stehen noch“*. Die Marke in `Intern/BEFUNDE.md:392` ist unverändert *„**Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121**“* |
| [L-160.10](LEKTOR-160.md#l-160.10) CHANGELOG ohne Regressionstests | **teilweise** | Nachgetragen sind die Fälle in `CHANGELOG.md:129` (*„Fälle `E-242p`, `E-242r`, Regressionstest `Eudora71/Tests/TestE169.cpp`“*), `:131` (`E-169p`) und `:132` (*„Fälle `E-71n`, `E-71r`“*). Der neue Punkt `:130` zu [E-247](../Intern/BEFUNDE.md#e-247) nennt keinen Test, obwohl `TestE169.cpp:125-127` ihn prüft ([L-161.2](#l-161.2)) |

## Funde

### <a id="l-161.1"></a>L-161.1 — Der Testplan sagt „das Paket liegt bereit“, vier andere Stellen sagen „noch nicht geschnürt“

**Gewicht: mittel.** Gemessen am Text.

* `Intern/TESTPLAN.md:11-12` *„Das Paket liegt neben deinem letzten Testverzeichnis, das ZIP daneben.“*
* `Releases/PAKETE.md:189` *„**Nur übersetzt am 07.11.2026, noch nicht geschnürt; nicht veröffentlicht.**“*
* `Intern/BEFUNDE.md:403` ([E-247](../Intern/BEFUNDE.md#e-247)), `:408` ([E-242](../Intern/BEFUNDE.md#e-242)) und `:410` ([E-240](../Intern/BEFUNDE.md#e-240)): jeweils *„nur übersetzt, noch in keinem Paket“*.
* `README.md:239` *„Behebung für die Druckvorschau im Quellstand für 7.2.2.137 gebaut, noch in keinem Paket“* und `:240` *„im Quellstand für 7.2.2.137 eine Sanduhr, noch in keinem Paket“*.

Nach Gregors Reihenfolge *„Erst LEKTOR, dann ZIP“* (`Arbeitsweise/entscheidung-p137-ohne-vollen-lauf-07-11.md:10`) gibt es das ZIP in diesem Augenblick noch nicht. Der Testplan behauptet also einen Zustand, der erst noch eintreten soll. Nach dem Schnüren kehrt sich das um: Dann stimmt der Testplan, und die anderen sechs Stellen sind veraltet. Gregor liest den Testplan als Arbeitsliste (`Arbeitsweise/nur-testplan-zaehlt.md`).

**Soll:** Mit dem Commit zum Schnüren alle Stellen auf einen Stand bringen: in `Releases/PAKETE.md:189` „geschnürt am …“ mit SHA-256, in BEFUNDE `:403`, `:408`, `:410` und `README.md:239-240` „im Testpaket 7.2.2.137“. Wird vorher committet, sollte `Intern/TESTPLAN.md:11-12` bis dahin „das ZIP kommt nach dem LEKTOR“ sagen.

### <a id="l-161.2"></a>L-161.2 — E-247 ist im Testumfang genannt, hat aber keinen Schritt, und der CHANGELOG nennt seinen Test nicht

**Gewicht: gering.** Belegt.

* `Intern/TESTPLAN.md:10-11` nennt *„`&` im Betreff wörtlich in Kopf und Fuß ([E-247](../Intern/BEFUNDE.md#e-247))“* im Umfang. Die Schritte 1 bis 6 (`:19-24`) enthalten keine Mail mit `&` im Betreff.
* `Intern/BEFUNDE.md:403` *„**Nicht gemessen** (keine Prüfmail mit `&` im Betreff). **Was noch fehlt:** am Prüfstand mit einem Betreff wie *„Tom & Jerry &u“* nachmessen“*. `CHANGELOG.md:130` sagt ehrlich *„Nicht gemessen.“*, nennt aber den vorhandenen Test nicht: `Eudora71/Tests/TestE169.cpp:125-127` *„Betreff oder Absenderadresse gehen ohne Verdopplung von & in Kopf/Fuss ([E-247](../Intern/BEFUNDE.md#e-247))“*.

Wer den Testplan liest, erwartet zu [E-247](../Intern/BEFUNDE.md#e-247) etwas zu prüfen und findet nichts. Gemessen ist es nirgends.

**Soll:** Entweder in Schritt 2 „falls vorhanden, eine Mail mit `&` im Betreff“ ergänzen, mit „Bestanden, wenn der Betreff mit `&` dasteht“. Oder im Umfangssatz „(am Prüfstand nachzumessen, für dich kein Schritt)“ schreiben. In `CHANGELOG.md:130` „Quelltextprobe in `TestE169.cpp`“ nennen.

### <a id="l-161.3"></a>L-161.3 — Testschritt zur Sanduhr ohne den Hinweis aus PRÜFER-106 K6: Mausbewegung nimmt sie weg

**Gewicht: gering.** Belegt am Quelltext, nicht gemessen.

* `Intern/TESTPLAN.md:22` (Schritt 4, [E-240](../Intern/BEFUNDE.md#e-240)): *„einmal klicken und warten“*, bestanden, *„bis die Vorschau da ist, eine Sanduhr steht“*.
* Der Code sagt selbst, dass das nicht immer gilt: `TridentView.cpp:2609-2611` *„laedt es erst nach der Rueckkehr, nimmt die erste Mausbewegung sie weg ([PRUEFER-106](PRUEFER-106.md#pruefer-106) K6, nicht gemessen)“*. Ebenso `Intern/BEFUNDE.md:408` *„**K6** — die Sanduhr ([E-240](../Intern/BEFUNDE.md#e-240)) verschwindet bei der ersten Mausbewegung“*.
* PRÜFER-106 K6 hat das ausdrücklich empfohlen: *„Im Testschritt zu [E-240](../Intern/BEFUNDE.md#e-240) sollte stehen: Maus nach dem Klick ruhig halten, und notieren, ob die Sanduhr bleibt.“*

Bewegt Gregor die Maus, meldet er „nicht bestanden“. Daraus ist dann nicht zu erkennen, ob die Sanduhr gar nicht kam oder ob sie wegen K6 verschwand.

**Soll:** Schritt 4 um „Maus nach dem Klick ruhig halten; verschwindet die Sanduhr erst bei einer Mausbewegung, bitte das notieren“ ergänzen.

### <a id="l-161.4"></a>L-161.4 — Zeitangaben nach der K1-Behebung: ein Code-Kommentar und ein Satz in E-242 beschreiben den alten Stand, drei verschiedene Millisekunden-Spannen

**Gewicht: gering.** Belegt.

* `TridentView.cpp:2633-2635` *„beim Druck, wenn 10 s lang kein Dialog dieses Prozesses mehr offen ist“*. Seit der Behebung von PRÜFER-106 K1 gilt aber `:2455-2458`: zurückgestellt wird 10 s nach dem **letzten** gesehenen Dialog, ohne jeden Dialog erst nach 120 s (*„Druck, kein Dialog binnen 120 s“*).
* `Intern/BEFUNDE.md:408` beschreibt in derselben Zelle ohne Kennzeichnung den alten Stand: *„der Code stellt dort erst zurück, wenn 10 s lang kein Dialog dieses Prozesses mehr offen ist (höchstens 10 min)“*. Erst weiter hinten folgt der Nachtrag *„gezählt wird erst, wenn ein Dialog zu sehen war; ohne Dialog nach 120 s“*. Das Nebeneinander ist dieselbe Klasse wie [L-160.6](LEKTOR-160.md#l-160.6).
* Für die Rückkehr von `OLECMDID_PRINTPREVIEW` stehen drei Spannen: `TridentView.cpp:2497` und `:2541` *„30-60 ms“*, `Intern/BEFUNDE.md:408` *„**31–62 ms**“*, `:410` *„zurück nach 16–62 ms“*. Die Spannen widersprechen sich nicht in der Sache (Rückkehr nach Millisekunden, nicht beim Schließen), aber der Kommentar gibt keine der gemessenen Spannen wieder.

**Soll:** Den Kommentar `:2633-2635` auf die neue Regel bringen. Den alten Satz in `:408` mit „bis zum Nachtrag aus PRÜFER-106“ kennzeichnen. Eine Spanne durchgehend verwenden, etwa „16–62 ms“ (`:410`, alle drei Prüfmails).

### <a id="l-161.5"></a>L-161.5 — E-71: die Änderung der Muss-Zeile von `E-71n` (PRÜFER-106 K4) steht nicht im Befund

**Gewicht: gering.** Gemessen (Diff).

* `tools/pruefstand-faelle.txt`, geändert in `7e102069`: Die Muss-Zeile von `E-71n` war `E-71 Bericht: eintraege=0` und ist jetzt `E-71 Eintrag: aktion=1 ziel=1 typ=8 notify=-1 ini=0`. Das ist die Abhilfe aus [PRÜFER-106 K4](PRUEFER-106.md#k4) (*„`E-71n` ist blind“*). Gelaufen ist der Fall am Bau `7e102069` (`tools/TESTLAEUFE.md`, 14:33:13, `E118`).
* `Intern/BEFUNDE.md:335` sagt nur *„die Spurmarken und die Fälle E-71n/E-71r bleiben als Regressionstest“*. Dass `E-71n` bis `7e102069` blind war und jetzt an der Eintragszeile hängt, steht nirgends im Befund. PRÜFER-106 hatte empfohlen, mit K4 [E-71](../Intern/BEFUNDE.md#e-71) fortzuschreiben.

**Soll:** einen Satz in [E-71](../Intern/BEFUNDE.md#e-71): „`E-71n` prüft seit `7e102069` die Zeile `E-71 Eintrag: … ini=0` (vorher blind, PRÜFER-106 K4)“.

## Was sich als richtig erwiesen hat (gemessen bzw. belegt)

* **PRÜFER-106 K1 behoben, wie beschrieben (belegt):** `TridentView.cpp:2446-2460`. Beim Druck wird `dwRuhigSeit` bei jedem gesehenen Dialog neu gesetzt. Zurückgestellt wird 10 s nach dem letzten Dialog, ohne Dialog nach 120 s, spätestens nach 10 min. Die Grenze der Vorschau ist 120 s (`:2477-2478`). Das deckt sich mit `Intern/BEFUNDE.md:408`.
* **[E-247](../Intern/BEFUNDE.md#e-247) (belegt):** `TridentView.cpp:2567` `Title.Replace("&", "&&");` und `:2575` `strAdresse.Replace("&", "&&");`, jeweils vor dem Anhängen der festen Teile mit den echten Platzhaltern. Damit bleiben `&bPage &p of &P` und `&b&d` unberührt, wie PRÜFER-106 K8 verlangt.
* **PRÜFER-106 K5 und K9 (belegt):** Die Kommentare sagen nicht mehr „modal“ oder „kehrt erst beim Schließen zurück“ (`grep modal` ohne Treffer im Abschnitt), `:2497` *„kehrt nach 30-60 ms zurueck, nicht erst beim Schliessen (gemessen)“*. `TestE169.cpp:120-124` verlangt jetzt `s_E242.bAktiv = TRUE;`.
* **`PrintHeaders=0` „im Original schon so gedacht“ (belegt):** Im QUALCOMM-Stand `567a5d87`, `Eudora71/Eudora/TridentView.cpp:2195-2201`, bleibt `Title` bei `bDoHeaderFooter == 0` leer und wird trotzdem mit `RegSetValueEx` geschrieben, sofern der Wert schon stand. Die Aussage in `CHANGELOG.md:129` und `Intern/BEFUNDE.md:408` stimmt also. Die Frage an Gregor aus [LEKTOR-160](LEKTOR-160.md#gregor) hat sich damit erledigt: Das Verhalten entspricht der Absicht des Originals.
* **Versionssprung (gemessen):** `VERSION` *„7.2.2.137“*, `Eudora71/Version.h:11-14` *„7,2,2,137“*, *„Version 7.2.2.137\0“*, `Doku/MITARBEITEN.md:62-63` mit dem Beispiel 7.2.2.137. `doku-pruefen.pl` meldet Quellstand und Paketnummer gleich.
* **CHANGELOG-Kopf 7.2.2.137 (gemessen):** `CHANGELOG.md:125` *„Testpaket (… nur übersetzt, nicht veröffentlicht)“*. Das passt zu `Releases/PAKETE.md:189` und zur Gedächtnisregel „Nummer erst beim Schnüren“.
* **Datenschutz der neuen Texte:** In [E-247](../Intern/BEFUNDE.md#e-247) und den Nachträgen zu [E-242](../Intern/BEFUNDE.md#e-242) steht kein Name aus Gregors Daten. Der Pfad steht als `file:///C:/Users/…`.

## Was nur Gregor entscheiden kann

Nichts Neues aus dieser Runde. Die Frage aus [LEKTOR-160](LEKTOR-160.md#lektor-160) zu `PrintHeaders=0` hat sich durch den Beleg am Original erledigt (siehe oben). Die beiden Fragen aus [LEKTOR-159](LEKTOR-159.md#lektor-159) bleiben bei ihm: der Nachtrag zum Release-Text `v7.2.1.131` und die Reparatur aus EudoraUnicodeFix ([E-147](../Intern/BEFUNDE.md#e-147), Umlaute aus manchen Absendern zerstört).
