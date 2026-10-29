# <a id="pruefer-65"></a>PRUEFER-65 — Prüfung des Nummernwechsels auf 7.2.1.128, 29.10.2026

**Auftrag.** Alles, was seit `4b8a24b5` unter `Eudora71`, `tools` und
`Releases/1.0` dazukam (`git log 4b8a24b5..HEAD`, Stand `159d3955`). Im
Quelltext ist das nur `Eudora71/Version.h` (`640e1a0e`: 7.2.0.127 auf
7.2.1.128). Unter `tools/` kamen dazu: das neue Nummernschema in 20
Werkzeugen (`a5febb70`) und zwei neue Prüfungen für Markdown
(`0a4d2390`: `pruefe-abschnittsverweise.pl`, Spaltenzahl in
`pruefe-tabellenzeilen.pl`). Unter `Releases/1.0` hat sich nichts geändert.

Eudora wurde weder gebaut noch gestartet. Kein Prüfstand lief. Gefahren habe
ich die Testsuite in meinem Arbeitsbaum (`wt/pruefer-20261029`, Stand
`159d3955`): **314 Tests, 314 bestanden** (gemessen). Dazu liefen die
Selbsttests der geänderten Werkzeuge, alle grün (gemessen). Das ZIP
`Releases/Eudora72-7.2.1.128-release.zip` habe ich im Hauptbaum nur gelesen
und nicht entpackt.

**Ergebnis vorweg.**

* **Die Nummer ist überall dieselbe.** In `Version.h` stehen alle sechs
  Felder auf 7.2.1.128, und `VERSION` sagt dasselbe (gemessen). Auch die
  ausgelieferten Dateien im ZIP tragen 7.2.1.128: `Eudora.exe`,
  `EudoraRes.dll`, `Imap.dll`, `QCSSL.dll`, `QCSocket.dll` und
  `QCUtils.dll`, jeweils im festen Versionsblock und als Text. Die Titelzeile
  heißt `Eudora 7.2.1.128+640e1a0e 2026-10-29 12:36`. Die Prüfsumme des ZIP
  stimmt mit `Releases/PAKETE.md` überein (alles gemessen).
* **Im Programm liest keine Stelle die Nummer so, dass der Wechsel von
  7.2.0 auf 7.2.1 etwas kaputt macht** (am Quelltext belegt). Eine einzige
  Stelle reagiert auf den Wechsel: Eudora stellt die Betriebsart beim
  ersten Start einmal auf „Pro“ zurück ([K1](#k1)). Das ist harmlos, weil
  dieser Bau ohnehin in „Pro“ läuft.
* **Die Werkzeuge kommen mit dem neuen Schema zurecht.** Alle Stellen, an
  denen eine Fassung gelesen wird, kennen jetzt `7.2.0.N` und `7.2.1.N`.
  Sortiert wird nach der Endnummer, und die zählt über beide Formen weiter.
  Der Schritt von 127 auf 128 ist damit richtig geordnet (am Quelltext
  belegt). Die Schranken weisen ab, wenn `Version.h` und `VERSION` nicht
  übereinstimmen. Gegenprobe gefahren, sie schlagen an ([Frage 2](#frage-2--lesen-die-werkzeuge-das-neue-schema-richtig)).
* **Zwei Werkzeuge kennen den Unterschied zwischen Testpaket und Release
  noch nicht** ([K2](#k2)). `release-veroeffentlichen.ps1` würde auch ein
  7.2.0.N als Release veröffentlichen. `ausliefern.pl` schlägt nach dem
  Release 7.2.1.129 als nächste Nummer vor, obwohl das nächste Testpaket
  7.2.0.129 heißen muss.
* **Hält ein Fund das Release v7.2.1.128 auf? Nein.** Kein Fund ist
  kritisch. Gregors Test an 7.2.1.128 bleibt gültig.

## Frage 1 — Stimmen die Versionsfelder untereinander und mit dem Paket?

**Ja** (gemessen).

* `Eudora71/Version.h:8-14`: `EUDORA_VERSION1..4` = 7, 2, 1, 128;
  `EUDORA_BUILD_NUMBER` = `7,2,1,128`; `EUDORA_BUILD_DESC` =
  `"Version 7.2.1.128\0"`; `EUDORA_BUILD_VERSION` = `"7.2.1.128"`. `VERSION`
  = `7.2.1.128`. `EUDORA_BUILD_MONTH` ist unverändert, und das ist
  beabsichtigt ([PR-2](../Intern/BEFUNDE.md#pr-2), Punkt 8).
* **Im ZIP** (SHA-256 `97d29f15…e209e6b`, wie in `PAKETE.md`) gelesen mit
  `unzip -p`, ohne etwas abzulegen:

  | Datei | fester Block (`FILEVERSION`) | Versionstext |
  |---|---|---|
  | `Eudora.exe` | 7.2.1.128 | 7.2.1.128 (3×), Titelzeile `Eudora 7.2.1.128+640e1a0e 2026-10-29 12:36` |
  | `EudoraRes.dll` | 7.2.1.128 | 7.2.1.128, `IDS_VERSION` = `Version 7.2.1.128` |
  | `Imap.dll`, `QCSSL.dll`, `QCSocket.dll`, `QCUtils.dll` | 7.2.1.128 | 7.2.1.128 |

  Eine 7.2.0 kommt in diesen Dateien nirgends mehr vor.
* **Wer im Programm die Makros liest** (am Quelltext belegt):
  `VersionBeg.inc:4-6,25-26` (Versionsblock aller DLLs und der EXE),
  `EudoraExeVer.rc:13` und `EudoraResVer.rc:17` (`IDS_VERSION`, daraus
  Über-Dialog, `X-Mailer`, Systeminfo und LMOS-Datei),
  `ExceptionHandler.cpp:558,715`, `guiutils.cpp:2407`, `msgdoc.cpp:1355`,
  `QComApplication.cpp:586-610`, drei `User-Agent`-Zeichenketten im
  Playlist-Client und `eudora.cpp:548-551` (Betreff des Fehlerberichts). Alle
  geben die Nummer nur aus. Keine vergleicht sie, ausgenommen
  [K1](#k1). `hostlist.cpp:509` schreibt `IDS_VERSION` als erste Zeile der
  LMOS-Datei, und der Leser (`hostlist.cpp:377-396`) überspringt bis
  `#POPSTART`, ohne sie zu prüfen. `eudora.cpp:1122` meldet dem
  Audit-Protokoll 721 statt 720. Die Formel ist die des Originals.

## Frage 2 — Lesen die Werkzeuge das neue Schema richtig?

**Ja, mit den Einschränkungen in [K2](#k2) und [K4](#k4)** (am Quelltext
belegt, Schranken gemessen).

* **Lesen.** `pruefe-fassungsnummer`, `offene-befunde`,
  `pruefe-befund-verbreitung`, `pruefe-doku-takt`, `pruefe-stand-md` und
  `doku-pruefen` nehmen `EUDORA_BUILD_VERSION` vierteilig oder mit
  beliebigen drei vorderen Stellen. In BEFUNDE-Urteilen, Marken, ZIP-Namen und
  EXE-Ressourcen erkennen `pruefe-behoben-ausgeliefert`,
  `pruefe-aussenstand`, `pruefe-release-buchfuehrung`,
  `pruefe-nachgestellt`, `pruefe-original-belegt` und `ausliefern` jetzt
  `7\.2\.[01]`. Ein festverdrahtetes `7\.2\.0` in einem Muster, das eine
  aktuelle Fassung lesen soll, habe ich nicht mehr gefunden. Was übrig ist,
  steht in Selbsttests, Kommentaren oder alten Meldungstexten ([K4](#k4)).
* **Ordnen.** Verglichen wird überall die Endnummer
  (`pruefe-release-buchfuehrung.pl` `neueste_paketnummer`,
  `spuren-auswerten.pl` `zahl`, `pruefe-doku-takt.pl:212-224`,
  `pruefe-fassungsnummer.pl` Prüfung D). Weil die Endnummer über 1.0.127,
  7.2.1.128 und künftige 7.2.0.N weiterzählt, steht 128 richtig über 127.
  Der Selbsttest `neues Tag nach altem` deckt das ab. Die frühere Sortierung
  nach allen drei Teilen hätte `v7.2.1.128` zwar auch richtig gestellt, ein
  späteres `v7.2.0.129` aber darunter. Die neue Sortierung ist also die
  richtige.
* **Titelzeile.** `kennung-erzeugen.pl` schreibt jetzt
  `Eudora 7.2.1.128+<commit> <Zeit>`. Die drei Leser (`pruefbericht.pl:202`,
  `pruefstand-lauf.ps1:430`, `pruefstaende-auffrischen.ps1:33`) machen
  ` / Paket …` optional. Im echten ZIP passt das Muster (gemessen, siehe
  Frage 1).
* **Gegenproben** (Quelle vorübergehend geändert, danach per `cp` zurück,
  `cmp` gleich, `git status` leer, alles gemessen):
  * `EUDORA_VERSION3` allein auf 0: `pruefe-doku-takt.pl` weist ab (rc 1,
    *„EUDORA_VERSION1..4 sagt 7.2.0.128, EUDORA_BUILD_VERSION sagt
    7.2.1.128“*). `doku-pruefen.pl` meldet dasselbe unter „Zu tun“.
    `pruefe-fassungsnummer.pl` bleibt grün, weil es nur
    `EUDORA_BUILD_VERSION` liest. Das ist so gewollt, die beiden anderen
    decken den Fall ab.
  * `Version.h` ganz auf 7.2.0.128, `VERSION` auf 7.2.1.128 (Testbau als
    Release): `pruefe-fassungsnummer.pl` und `pruefe-doku-takt.pl` weisen
    beide ab, *„beide müssen dieselbe Nummer tragen“*. Gegen genau diesen
    Fall war die neue Prüfung A2 gebaut.

## <a id="k1"></a>K1 — Beim Wechsel zwischen 7.2.0 und 7.2.1 setzt Eudora die Betriebsart einmal auf „Pro“

**Was passiert.** `QCSharewareManager::Load` liest `RetailVersion` aus der
INI und schneidet sie hinter dem letzten Punkt ab, aus `7.2.0.127` wird also
`7.2.0.`. Stimmt dieser Anfang nicht mit `EUDORA_BUILD_VERSION` überein,
erzwingt Eudora `SWM_MODE_PRO` und schreibt die neue Nummer zurück
(`QCSharewareManager.cpp:1315-1327`, mit `DEFAULT_SWM_MODE == 2`, am
Quelltext belegt). Innerhalb von 7.2.0.N blieb der Anfang gleich. Jetzt
ändert er sich bei **jedem** Wechsel zwischen Testpaket und Release, also
bei 7.2.0.127 → 7.2.1.128 und wieder bei 7.2.1.128 → 7.2.0.129.

**Folge.** Wer die Betriebsart „Light“ (`Mode=1`) gewählt hat, ist nach dem
Wechsel wieder in „Pro“. Daten gehen nicht verloren. Dass jemand „Light“
benutzt, ist unwahrscheinlich, denn an 1.0.84 stand nach jedem Beenden
`Mode=2` in der INI ([AN-2](../Intern/BEFUNDE.md#an-2), gemessen). Bekannt
war die Stelle schon ([PR-2](../Intern/BEFUNDE.md#pr-2), Punkt 8). Neu ist
nur, dass der Wechsel jetzt öfter vorkommt.

**Schwere: sehr niedrig.** **Hält das Release auf: nein.** Kein Handlungsbedarf.
Es reicht, das zu wissen, falls jemand nach einem Paketwechsel fragt, warum
seine Betriebsart anders ist.

## <a id="k2"></a>K2 — Zwei Werkzeuge kennen den Unterschied zwischen Testpaket und Release noch nicht

* **`release-veroeffentlichen.ps1:67`** verlangt nur die Form `a.b.c.d`.
  Stehen `VERSION`, `Version.h`, CHANGELOG und ZIP auf `7.2.0.129`, würde
  das Werkzeug diese Fassung als Release `v7.2.0.129` veröffentlichen. Nach
  Gregors Entscheidung 10 heißt ein Release aber immer `7.2.1.N`
  (`Releases/PAKETE.md`, Kasten „Drei Zählungen“). Am Quelltext belegt,
  nicht ausgeführt. Davor schützen nur die Freigabe und die Bestätigung im
  CHANGELOG, also der Mensch. Vorschlag: die dritte Stelle muss `1` sein.
* **`ausliefern.pl:88-89`** schlägt als nächste Nummer `$p3` unverändert
  vor. Nach dem Release 7.2.1.128 hieße das nächste Testpaket also
  `7.2.1.129` statt `7.2.0.129`. `--machen` ist nicht umgesetzt
  (`ausliefern.pl:151-155`), die Zeile ist also nur ein Vorschlag. Wer ihr
  folgt, baut aber ein Testpaket mit Release-Nummer. Keine Schranke würde
  das abweisen, denn `VERSION` und `Version.h` stimmen dann ja überein. Am
  Quelltext belegt, nicht ausgeführt: das Werkzeug liest die `Eudora.exe` in
  Gregors Testverzeichnissen, die fasse ich nicht an.

**Schwere: niedrig.** **Hält das Release auf: nein.** Beides betrifft erst
die Zeit **nach** v7.2.1.128.

## <a id="k3"></a>K3 — Die neue Spaltenzählung übersieht einen Strich in einer Codespanne

`pruefe-tabellenzeilen.pl:227` zählt einen `|` innerhalb einer Codespanne
nicht als Zelltrenner, und der Selbsttest `Pipe in Codespanne zaehlt nicht`
(`:240`) schreibt das fest. Die GFM-Spezifikation sieht es anders: Tabellen
werden vor den Inline-Elementen zerlegt, ein `|` trennt auch in einer
Codespanne, es sei denn, er ist als `\|` maskiert (Abschnitt *Tables
(extension)*). Belegt an der Spezifikation, auf GitHub nicht gemessen.
Folge: eine Zeile wie ``| `a|b` | c |`` hat für GitHub drei Zellen, für die
Prüfung zwei. Die Schranke ist dann blind und meldet keinen Fehler zu viel.

**Gemessen:** In keiner `.md` außerhalb von `Befunde/` und `Arbeitsweise/`
steht ein solcher Fall. Der Fehler ist also derzeit ohne Wirkung.

**Schwere: sehr niedrig.** **Hält das Release auf: nein.**

## <a id="k4"></a>K4 — Alte Nummernform in Meldungstexten und einer Tabelle

Diese Stellen verfälschen kein Urteil, nur den Text einer Meldung (am
Quelltext belegt):

* `pruefe-doku-takt.pl:248-255` meldet Lücken als `7.2.0.<n>`, auch wenn die
  fehlende Fassung eine 7.2.1 war.
* `pruefe-behoben-ausgeliefert.pl:179` sagt *„keine Fassung 7.2.0.NN“*, und
  `:188` gibt *„Paket 7.2.1.128 heisst 7.2.1.128, …“* aus (Name doppelt).
* `release-veroeffentlichen.ps1:25,89` spricht von „DREI Makros“. Geprüft
  werden vier Muster. `EUDORA_BUILD_DESC` ist nicht darunter, das prüft aber
  `doku-pruefen.pl:708-719`.
* `Releases/PAKETE.md:62` überschreibt die Zeile mit
  *„Produktversion `7.2.0.x`“*, obwohl in derselben Zelle schon 7.2.1.128
  steht.

**Schwere: sehr niedrig.** **Hält das Release auf: nein.**

## Was sonst dazukam

`pruefe-abschnittsverweise.pl` (neu, im Commit-Haken als Schritt 1b2) und
die Spaltenprüfung in `pruefe-tabellenzeilen.pl` prüfen nur Markdown. Beide
Selbsttests sind grün (9/9 und 27/27, gemessen). Bis auf [K3](#k3) habe ich
nichts gefunden. Ins Paket geht keines von beiden.

## Neue Kennungen

Keine vergeben. E-174 und E-175 bleiben frei. K1 schreibt
[PR-2](../Intern/BEFUNDE.md#pr-2) Punkt 8 fort. In `Intern/BEFUNDE.md` habe
ich nichts eingetragen.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| — | Fragen 1 und 2: alle Versionsfelder, `VERSION` und die ausgelieferten Dateien tragen 7.2.1.128. Die Werkzeuge lesen und ordnen das neue Schema richtig, und die Schranken schlagen bei einem Widerspruch an. 314/314 Tests. | keine | nein |
| [K1](#k1) | Beim ersten Start nach einem Wechsel zwischen Testpaket (7.2.0) und Release (7.2.1) stellt Eudora die Betriebsart auf „Pro“. Wer „Light“ gewählt hatte, muss es neu wählen. | sehr niedrig | nein |
| [K2](#k2) | `release-veroeffentlichen.ps1` würde auch ein Testpaket 7.2.0.N als Release veröffentlichen. `ausliefern.pl` schlägt nach dem Release 7.2.1.129 statt 7.2.0.129 vor. | niedrig | nein |
| [K3](#k3) | Die neue Spaltenprüfung zählt `\|` in Codespannen nicht, GitHub schon. Eine so zerbrochene Tabelle bliebe unbemerkt. Heute kein Fall im Repo. | sehr niedrig | nein |
| [K4](#k4) | Meldungstexte und eine Tabellenzeile nennen noch die Form 7.2.0. Die Urteile sind richtig. | sehr niedrig | nein |
