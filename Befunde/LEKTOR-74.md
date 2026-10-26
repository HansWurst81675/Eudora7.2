# <a id="lektor-74"></a>LEKTOR-74 — Bestand vor dem Testpaket 7.2.0.124, nach LEKTOR-73 und PRUEFER-59, Zweig `0.123_ergebnisse`, 26.10.2026

**Auftrag.** (1) Stand der Funde [L-73.1](LEKTOR-73.md#l-73.1) bis
[L-73.11](LEKTOR-73.md#l-73.11); (2) alle `*.md` aus `git ls-files` ohne
`Arbeitsweise/` und `Befunde/` (60 Dateien) gegen den Bestand, besonders
`ZIEL.md`, `README.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`,
`Releases/PAKETE.md`, `CHANGELOG.md` gegen `Intern/BEFUNDE.md`; geändert seit
`b26abf7`: `84a4baba`, `ff2cb005`, `3a895491`, `2ae1ea58`, `31a9b110`
(`git log --stat b26abf7..HEAD`); (3) die mechanischen Prüfungen. Gemessen im
Arbeitsbaum `Eudora7.2-wt-lektor` auf `31a9b110` (= `origin/0.123_ergebnisse`
nach `git fetch`).

**Ergebnis vorweg.** **12 Funde** (4 falsch, 3 veraltet, 4 unklar,
1 Doppelung). Von den elf Funden aus [LEKTOR-73](LEKTOR-73.md#lektor-73) sind
**sechs erledigt, fünf teilweise**; der Werkzeugfehler
[L-73.1](LEKTOR-73.md#l-73.1) ist behoben, `ZIEL.md` meldet jetzt richtig
*„24 von 25 erfüllt, 1 offen“*. **Vor dem Schnüren zu berichtigen sind vier
Stellen**, an denen der Bestand Gregors Ergebnis vom 26.10.2026 noch nicht
kennt oder ihm widerspricht: die Kriterientabelle in `ZIEL.md` nennt
Kriterium 4 und 6 weiter erfüllt bzw. „fast“, obwohl K4 und K6 an 7.2.0.123
*nein* waren ([L-74.1](#l-74.1)); [E-148](../Intern/BEFUNDE.md#e-148)
(eMudhra-Zertifikate) sagt in derselben Zeile „mit Eudora gemessen“ und
„nicht gemessen“ ([L-74.2](#l-74.2)); [E-142](../Intern/BEFUNDE.md#e-142)
(Entwurf aus IMAP nach `Out`) heißt „am Programm noch NICHT gemessen“, obwohl
Gregor es in N3 gefahren hat ([L-74.3](#l-74.3)); und die erzeugten Listen der
offenen Befunde zeigen bei fünf gemessenen Befunden „nie gemessen“ oder ein
altes Datum ([L-74.4](#l-74.4)). **Von [PRUEFER-59](PRUEFER-59.md#pruefer-59) sind drei der elf Punkte
eingearbeitet** (K5, K6, K11), acht stehen nur im Bericht ([L-74.6](#l-74.6)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-73

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-73.1](LEKTOR-73.md#l-73.1) | `ziel-stand.pl` und `offene-befunde.pl` lasen „widerlegt“ mitten im Urteil von [E-119](../Intern/BEFUNDE.md#e-119) (Bilder im HTML) als erledigt | **erledigt** | beide Werkzeuge: neue Regel `$beginnt_offen` (`git show ff2cb005`); `ZIEL.md:44` *„**Stand: 24 von 25 erfüllt, 1 offen.**“*, `:52` [E-119](../Intern/BEFUNDE.md#e-119); `CHANGELOG.md:48` und `WEITERMACHEN.md:387` führen [E-119](../Intern/BEFUNDE.md#e-119) (gemessen: `perl tools/ziel-stand.pl`, `perl tools/offene-befunde.pl`, unten). Ein eigener Gegentest im Werkzeug fehlt; Gegentest ist nur der Bestand |
| [L-73.2](LEKTOR-73.md#l-73.2) | Gregors Bestätigungen vom 26.10. standen nur in der Ergebnistabelle | **teilweise** | erledigt: [E-77](../Intern/BEFUNDE.md#e-77) (Umlaute in IMAP-Ordnern) `BEFUNDE.md:324` *„**Was noch fehlt:** nichts — von Gregor am 26.10.2026 an Paket 1.0.123 bestätigt“*, `ZIEL.md:69`; [E-113](../Intern/BEFUNDE.md#e-113) (breite Bilder) `BEFUNDE.md:359`, `ZIEL.md:70`; [E-137](../Intern/BEFUNDE.md#e-137) (Strg+W in der Leiste) Kopf `BEFUNDE.md:395`; [E-146](../Intern/BEFUNDE.md#e-146) (Umbenennen) `BEFUNDE.md:389` *„von Gregor am 26.10.2026 an Paket 1.0.123 bestätigt (TESTPLAN N5)“*; E-148-Logzeile `WEITERMACHEN.md:135`. **Offen:** `ZIEL.md:77` [E-146](../Intern/BEFUNDE.md#e-146) ohne Gregors Ergebnis (*„behoben auf dem Zweig `vor-testpaket-7.2.0.123`, kommt mit 7.2.0.123; am Prüfstand erst rot, dann grün“*); `ZIEL.md:76` [E-148](../Intern/BEFUNDE.md#e-148) *„mit Eudora selbst prüft es Gregor im Testpaket“* ([L-74.2](#l-74.2)); `WEITERMACHEN.md:134` [E-137](../Intern/BEFUNDE.md#e-137) und [E-142](../Intern/BEFUNDE.md#e-142) *„am Programm noch nicht gemessen“* ([L-74.3](#l-74.3)); `ZIEL.md:71` [E-119](../Intern/BEFUNDE.md#e-119) *„Prüfstandsfälle `E-119a` bis `E-119d`, zuletzt grün am 25.10.2026“* — `E-119e` lief am 26.10. (`Releases/PRUEFBERICHT.md:438`) |
| [L-73.3](LEKTOR-73.md#l-73.3) | drei Stand-Zeilen nannten 7.2.0.123 | **erledigt** | `README.md:99` *„Stand **7.2.0.124** / `VERSION` **1.0.124**“*; `ZIEL.md:174` *„Quellstand **7.2.0.124**“*; `TESTPLAN.md:3-6` *„**Testpaket 7.2.0.124** (Paket 1.0.124)“* |
| [L-73.4](LEKTOR-73.md#l-73.4) | „HIER WEITERMACHEN“ schickte zu PR und Test von 7.2.0.123 | **erledigt** | `WEITERMACHEN.md:132` *„Zweig `0.123_ergebnisse`“*; `:145` *„**Als Nächstes:** LEKTOR- und PRÜFER-Funde einarbeiten, Testpaket 7.2.0.124 schnüren, PR an Gregor, sein Kurztest (TESTPLAN T1–T5)“* |
| [L-73.5](LEKTOR-73.md#l-73.5) | CHANGELOG zählte drei *nein*, die Tabelle zwei; K4 leer | **teilweise** | `TESTPLAN.md:129` K4 *„**nein** \| 26.10.2026 \| Windows verzeichnete um 10:05 einen Absturz …“* — die Zählung stimmt jetzt (gemessen: 15 × *ja*, 3 × *nein*). Die Zeile *Protokoll* (`:144`) trägt in der Ergebnisspalte weiter *„—“* |
| [L-73.6](LEKTOR-73.md#l-73.6) | angedockt oder abgedockt — Tabelle und [E-137](../Intern/BEFUNDE.md#e-137) gegensätzlich | **teilweise, Rest falsch** | Ort berichtigt: `TESTPLAN.md:134` *„im schwebenden (abgedockten) Filterfenster“*. Weiter widersprüchlich: dort *„griff Strg+W … nicht (keine E-137-Zeile) … Ursache nicht gemessen“*, in `BEFUNDE.md:395` Gregors Wortlaut *„ctrl-W: schließt mail fenster, nicht filter fenster“* und *„Ursache: Strg+W richtet sich nach dem Tastaturfokus, und ein Klick auf eine Beschriftung oder leere Fläche der Leiste ließ ihn in der Mail“* |
| [L-73.7](LEKTOR-73.md#l-73.7) | T1 ohne Ort und ohne geöffnete Mail | **teilweise** | `TESTPLAN.md:21` *„lokal, eine Mail aus `In` geöffnet“*, *„einmal angedockt, einmal schwebend (abgedockt)“*. Die Protokollzeile `E-137 Klick in Wazoo-Leiste` steht nicht in der Erwartung — für Gregor unerheblich, für meine Auswertung des `eudora.log` nicht |
| [L-73.8](LEKTOR-73.md#l-73.8) | T4 setzte einen gelöschten Entwurf voraus | **erledigt** | `TESTPLAN.md:24` *„einen Entwurf anlegen (*Message → New Message* …), in *Gelöscht* ziehen, dann zurück nach `Out` ziehen“* |
| [L-73.9](LEKTOR-73.md#l-73.9) | „Befund folgt“ | **erledigt** | `TESTPLAN.md:146` *„([E-157](BEFUNDE.md#e-157), seit 26.10.2026 im Prüfstand behoben)“* |
| [L-73.10](LEKTOR-73.md#l-73.10) | [E-156](../Intern/BEFUNDE.md#e-156) „vermutlich“ auch im veröffentlichten Paket | **erledigt** | `BEFUNDE.md:384` *„auch das veröffentlichte `v1.0.120` ist betroffen — gemessen von [LEKTOR-73](LEKTOR-73.md#lektor-73) am ZIP“*. Die Frage an Gregor (ein Satz in der README für Anwender von `v1.0.120`) ist unbeantwortet — `README.md` nennt [E-156](../Intern/BEFUNDE.md#e-156) nur in `:138` unter *Neu in den Testpaketen*; sie steht unten wieder |
| [L-73.11](LEKTOR-73.md#l-73.11) | `PAKETE.md` 1.0.123 ohne Ergebnis | **erledigt**, aber mit neuer Doppelung | `PAKETE.md:168` verweist auf die Ergebnistabelle — und wiederholt die Zählung, siehe [L-74.11](#l-74.11) |

Aus [LEKTOR-72](LEKTOR-72.md#lektor-72) bleiben offen: [L-72.1](LEKTOR-72.md#l-72.1)
(`WEITERMACHEN.md:9` nennt in der Zeile *Quellstand 7.2.0.124* weiter
*„**Geschnürt als Paket 1.0.122**, von Gregor am 23.10.2026 geprüft“*) und
[L-72.4](LEKTOR-72.md#l-72.4) ([E-146](../Intern/BEFUNDE.md#e-146) beschreibt den alten Fehler zweimal:
`BEFUNDE.md:389` *„Bis 7.2.0.122: benannte man auf einem IMAP-Server ohne
Ordnerhierarchie einen Ordner um …“* und *„Vorher (bis 26.10.2026):** benannte
man auf einem IMAP-Server ohne Ordnerhierarchie einen Ordner um …“*, gemessen
mit `grep -o`, je ein Treffer).

---

## <a id="l-74.1"></a>L-74.1 — falsch: die Kriterientabelle in `ZIEL.md` kennt Gregors Test an 7.2.0.123 nicht — Kriterium 6 „erfüllt“, Kriterium 4 „fast, nur noch improper argument“, beides war an 7.2.0.123 *nein*

* `ZIEL.md:207-210` (belegt): *„**Neun Kriterien: sieben sind belegt (0, 1,
  3, 5, 6, 7, 8), zwei sind fast erfüllt (2, 4).** Beiden fehlt nur noch der
  Nachweis, dass die Meldung „Encountered an improper argument" nicht mehr
  kommt (Zeile **2a**) — Gregors Test am Testpaket 7.2.0.123 mit Protokoll“*.
* `ZIEL.md:201`, Kriterium 4 (belegt): *„**Offen bleibt eine Stelle:** die
  Meldung „Encountered an improper argument" beim **Anzeigen** mancher
  Nachrichten“*. `ZIEL.md:203`, Kriterium 6 (belegt): *„**erfüllt**“*, Beleg
  vom 07.09.2026.
* Dagegen die Ergebnistabelle (belegt): `TESTPLAN.md:127` K2 *„**ja** …
  im `eudora.log` keine Zeile `Ausnahme …`, daneben Marken derselben Klasse …
  die leere Spur zählt also“* — der in `ZIEL.md:209` verlangte Nachweis ist
  geliefert; `:129` K4 *„**nein** … Absturz von
  `Eudora72-1.0.123-release\Eudora.exe` in `ucrtbased.dll`“*
  ([E-156](../Intern/BEFUNDE.md#e-156), Debug-Fassungen im Paket); `:131` K6
  *„**nein** … die weitergeleitete Mail endet mit sichtbarem `</x-html>`“*
  ([E-158](../Intern/BEFUNDE.md#e-158)).

`ZIEL.md:87-88` verlangt *„Vor dem Release: die Tabelle der Kriterien neu
messen (ihre Urteile stammen von 7.2.0.55)“* — die Messung liegt seit dem
26.10.2026 in `TESTPLAN.md:122-144` vor, die Tabelle ist nicht nachgezogen.
Wer `ZIEL.md` liest, findet für Kriterium 4 nur noch die Meldung als Rest und
für Kriterium 6 nichts — beides ist nach Gregors Test falsch.
**Was zu tun wäre:** Spalte *Stand* der Zeilen 2, 4, 6 auf Gregors Ergebnis
an 7.2.0.123 setzen, mit Verweis auf die Ergebnistabelle statt Wiederholung
(2: Nachweis geliefert, K2; 4 und 6: an 7.2.0.123 nicht bestanden, behoben für
7.2.0.124, Bestätigung T5 und T3); den Absatz `:207-211` danach auf einen Satz
mit Verweis kürzen.

## <a id="l-74.2"></a>L-74.2 — falsch: E-148 sagt in derselben Zeile „an Gregors Paket gemessen, Abruf ohne Zertifikatsfehler“ und „nicht gemessen: eine Verbindung durch Eudora selbst“; README und ZIEL folgen der zweiten Aussage

[E-148](../Intern/BEFUNDE.md#e-148): Eudora vertraute vier kompromittierten eMudhra-Wurzelzertifikaten; ein
Angreifer im selben Netz hätte einen Mailserver vorspielen können.

* `BEFUNDE.md:388` (belegt), vorn: *„**Logzeile, eingebaut am 26.10.2026, am
  laufenden Programm gemessen an Gregors Paket 1.0.123:** `rootcerts.p7b
  geladen aus: C:\Users\Gregor\Eudora72-1.0.123-release\rootcerts.p7b
  (vorhanden)`, das Programmverzeichnis; Abruf bei GMX und freenet ohne
  Zertifikatsfehler (TESTPLAN K3)“*.
* Dieselbe Zeile, weiter hinten (belegt): *„**Nicht gemessen:** eine
  Verbindung durch Eudora selbst gegen einen echten Server — gemessen hat
  OpenSSL auf der Kommandozeile“*.
* `README.md:253-254` (belegt): *„**Mit Eudora selbst** ist das erst mit dem
  Testpaket 7.2.0.123 zu messen; bis dahin ist es eine Rechnung, keine
  Beobachtung am Programm.“*
* `ZIEL.md:76` (belegt): *„GMX und freenet mit OpenSSL gegen die neue Liste
  gemessen, mit Eudora selbst prüft es Gregor im Testpaket“*.
* `TESTPLAN.md:128` K3 (belegt): *„**ja**, mit Bemerkung … GMX über IMAP
  sofort; freenet über POP … Kein Zertifikatsfehler.“*; `:144` Protokoll mit
  der Zeile `rootcerts.p7b geladen aus: …1.0.123-release\rootcerts.p7b`.

Gemessen ist damit die **Annahme** der beiden Server durch Eudora mit der
neuen Liste; dass Eudora einen Server mit eMudhra-Kette **ablehnt**, bleibt
eine Rechnung (Vermutung, dass genau das mit „nicht gemessen“ gemeint war —
gesagt wird es nicht). **Was zu tun wäre:** in `BEFUNDE.md:388` *„Nicht
gemessen“* auf die Ablehnung einschränken; `README.md:253-254` und
`ZIEL.md:76` auf den Stand bringen (oder in `ZIEL.md` nur verweisen).

## <a id="l-74.3"></a>L-74.3 — falsch: E-142 heißt „am Programm noch NICHT gemessen“ und „Gregor prüft im Testpaket 7.2.0.123“, obwohl Gregor es dort in N3 gefahren hat; `WEITERMACHEN.md:134` ebenso für E-137

[E-142](../Intern/BEFUNDE.md#e-142): ein Entwurf aus einem IMAP-Ordner nach `Out` gezogen ergibt in `Out`
eine leere Nachricht; vereinbart ist eine Rückfrage vorher.

* `BEFUNDE.md:378` (belegt): *„**Hinweis eingebaut am 26.10.2026, am
  Programm noch NICHT gemessen**“* und *„Gregor prüft im Testpaket
  7.2.0.123.“*
* Dieselbe Zeile (belegt): *„Am Testpaket 7.2.0.123 von Gregor am 26.10.2026
  geprüft (TESTPLAN N3, *No*, Protokoll `antwort=nein`); dabei war *Yes*
  vorgewählt.“* — ebenso `TESTPLAN.md:137` N3 *„**ja** … Protokoll `[E-142](../Intern/BEFUNDE.md#e-142)
  Hinweis Entwurf aus IMAP nach Out: quelle=Gelöscht (<Dominant>)
  antwort=nein`“*.
* `WEITERMACHEN.md:134` (belegt), Entscheidung 2: [E-137](../Intern/BEFUNDE.md#e-137) *„**eingebaut am
  25.10.2026, am Programm noch nicht gemessen** (`mainfrm.cpp` `OnCommand`
  …; Gregor prüft im Testpaket …)“* und [E-142](../Intern/BEFUNDE.md#e-142) *„(**eingebaut am
  26.10.2026**, am Programm noch nicht gemessen)“* — beide an 1.0.123
  gemessen (`TESTPLAN.md:134-137`, `BEFUNDE.md:395` *„von Gregor am
  26.10.2026 an Paket 1.0.123 bestätigt“*).

Für [E-137](../Intern/BEFUNDE.md#e-137) ist der **zweite** Teil (Klick auf eine Beschriftung, dann Strg+W)
tatsächlich noch nicht am Programm gemessen (`BEFUNDE.md:395`); `:134` meint
aber den ersten. **Was zu tun wäre:** in `BEFUNDE.md:378` die beiden Sätze
streichen oder als „Stand vor dem 26.10.“ kennzeichnen; `WEITERMACHEN.md:134`
auf einen Verweis kürzen.

## <a id="l-74.4"></a>L-74.4 — falsch: die erzeugten Listen der offenen Befunde melden bei fünf gemessenen Befunden „nie gemessen“ oder ein Datum vom 22.10.

Die Spalte *zuletzt gemessen* in `CHANGELOG.md` (*Noch offen*),
`Intern/WEITERMACHEN.md` und der Block oben in `ZIEL.md` kommt aus der Marke
`**Zuletzt gemessen: <Datum> an 7.2.0.<n>**` bzw. `**Zuletzt belegt am
Quelltext: …**` im Urteil (`tools/offene-befunde.pl:193`, `:211`; ohne Marke
`:331` *„**nie gemessen**“*, belegt). Dagegen (alle belegt):

| Befund | was passiert | Liste sagt | das Urteil in `BEFUNDE.md` sagt |
|---|---|---|---|
| [E-159](../Intern/BEFUNDE.md#e-159) | Prüfstands-Eudora 7.2.0.122 abgestürzt, Ursache unbekannt | `CHANGELOG.md:27`, `WEITERMACHEN.md:366` *„**nie gemessen**“* | `:381` *„**offen — gemessen am 26.10.2026, Ursache nicht bestimmt.**“* (Windows-Ereignisprotokoll) |
| [E-157](../Intern/BEFUNDE.md#e-157) | Prüfstand verbog Gregors Registry, sah keine Abstürze | `CHANGELOG.md:28`, `WEITERMACHEN.md:367` *„**nie gemessen**“* | `:383` *„Vorher: am 26.10.2026 an Gregors Rechner gemessen“*, *„**Gegenprobe gemessen**“* |
| [E-142](../Intern/BEFUNDE.md#e-142) | Entwurf aus IMAP nach `Out` wird leer | `CHANGELOG.md:34`, `WEITERMACHEN.md:373` *„**nie gemessen**“* | `:378` *„Von Gregor am laufenden Programm bestätigt am 23.10.2026“*, N3 am 26.10. ([L-74.3](#l-74.3)) |
| [E-137](../Intern/BEFUNDE.md#e-137) | Strg+W in einer Leiste | `CHANGELOG.md:39`, `WEITERMACHEN.md:378` *„**nie gemessen**“* | `:395` *„von Gregor am 26.10.2026 an Paket 1.0.123 bestätigt“* |
| [E-119](../Intern/BEFUNDE.md#e-119) | große `data:`-Bilder abgeschnitten | `CHANGELOG.md:48`, `WEITERMACHEN.md:387`, `ZIEL.md:52` *„22.10.2026 an 7.2.0.121 (Quelltext)“* | `:365` *„Fall `E-119e`: am Bau 1.0.123 `laenge=12983`, am Bau 1.0.124 `laenge=78519`“*; `PRUEFBERICHT.md:438` *„E-119e \| ok \| 2026-10-26 12:31:14“* |

`perl tools/offene-befunde.pl` zählt deshalb *„davon NIE gemessen 14“*
(gemessen) — mindestens vier davon sind gemessen. Die Ursache liegt im
Bestand, nicht im Werkzeug: die Konvention steht in `offene-befunde.pl:189`,
die fünf Urteile tragen keine oder eine alte Marke. **Was zu tun wäre:** je
Urteil eine Marke `**Zuletzt gemessen: 26.10.2026 an 7.2.0.12x**` ([E-137](../Intern/BEFUNDE.md#e-137),
[E-142](../Intern/BEFUNDE.md#e-142): 7.2.0.123; [E-119](../Intern/BEFUNDE.md#e-119): 7.2.0.124; [E-157](../Intern/BEFUNDE.md#e-157), [E-159](../Intern/BEFUNDE.md#e-159): am Rechner bzw. 7.2.0.122),
dann die Listen neu erzeugen. Die übrigen zehn „nie gemessen“ habe ich nicht
nachgesehen.

## <a id="l-74.5"></a>L-74.5 — unklar: E-158 heißt „behoben“, obwohl PRUEFER-59 die Messung einer HTML-Weiterleitung vor „behoben“ verlangt; der Schritt steht nirgends in der Reihenfolge

[E-158](../Intern/BEFUNDE.md#e-158): beim Weiterleiten einer Textmail stand am Ende sichtbar `</x-html>`.

* `Befunde/PRUEFER-59.md:540`, Übersicht K6 (belegt): *„nein, aber vor
  „behoben“ eine HTML-Weiterleitung in `Out.mbx` messen“*.
* `BEFUNDE.md:382` (belegt): Urteil *„**behoben auf dem Zweig
  `0.123_ergebnisse`**“*; die Einschränkung sagt *„Vor einer Bestätigung ist
  eine weitergeleitete HTML-Mail in `Out.mbx` zu messen.“* — aus „vor
  behoben“ wurde „vor einer Bestätigung“.
* `ZIEL.md:44` zählt [E-158](../Intern/BEFUNDE.md#e-158) damit unter *erfüllt* (gemessen: `perl
  tools/ziel-stand.pl` → *„24 von 25 erfüllt“*, [E-158](../Intern/BEFUNDE.md#e-158) nicht im Block);
  `ZIEL.md:75` *„(**behoben** auf dem Zweig `0.123_ergebnisse` …)“*.
* `WEITERMACHEN.md:145` (belegt), *Als Nächstes*: kein Schritt „HTML-Weiterleitung
  messen“; T3 (`TESTPLAN.md:23`) prüft nur eine **Text**mail.

Ob „behoben“ trotz der offenen Ursache stehen darf, ist eine Einstufung und
liegt beim Hauptagenten. Unklar ist, **wann** die Messung geschieht: vor dem
Schnüren (dann gehört sie in `:145`) oder nach Gregors T3 (dann bestätigt
Gregor etwas, dessen Vorbedingung fehlt).

## <a id="l-74.6"></a>L-74.6 — veraltet: von PRUEFER-59 sind drei der elf Punkte im Bestand, acht nur im Bericht — zwei davon schränken Aussagen im CHANGELOG und im TESTPLAN ein

* **Gemessen:** `grep -o 'PRUEFER-59[^)]*)' Intern/BEFUNDE.md` → nur `#k5`,
  `#k6`, `#k11`. Keine Spur von K1 (Klick auf Reiter holt Fokus, [E-137](../Intern/BEFUNDE.md#e-137)), K2,
  K3 und K4 ([E-119](../Intern/BEFUNDE.md#e-119)), K7 und K8 ([E-156](../Intern/BEFUNDE.md#e-156)), K9 und K10 ([E-157](../Intern/BEFUNDE.md#e-157)). Alle acht hat
  [PRUEFER-59](PRUEFER-59.md#pruefer-59) als *„hält das Paket nicht auf“* eingestuft (`:535-545`).
* **K7 gegen `CHANGELOG.md:111-112`** (belegt): *„Jetzt kommt jede
  Programmdatei aus dem fertigen Bau“* — ebenso `BEFUNDE.md:384` *„Ab
  7.2.0.124 kommt jede Programmdatei aus dem fertigen Bau.“* [PRUEFER-59](PRUEFER-59.md#pruefer-59) K7
  (`:382-394`): `mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll` kommen als
  *„Handkopien vom 28.08.“* aus `Bin\Release`, heute byte-gleich mit dem
  Redist-Ordner, nach einem Update von Visual Studio nicht mehr. Kein
  Widerspruch heute, aber die Aussage ist weiter, als K7 sie deckt.
* **K9 gegen `TESTPLAN.md:146`** (belegt): *„seit 26.10.2026 im Prüfstand
  behoben“*. K9 (`:446-454`, Übersicht `:543`): das Zurücksetzen bricht an einem Wert
  „(Standard)“ ab und *„lässt dann `LaunchManager` stehen“*, und bei Abschuss
  von außen geschieht gar nichts. Heute trifft keiner der Fälle zu (gemessen
  von [PRUEFER-59](PRUEFER-59.md#pruefer-59)).
* **K4 gegen `BEFUNDE.md:365`** (belegt): *„Regressionstest `TestE119.cpp`
  … mit dem alten Aufruf einmal rot“*; K4 (`:235-242`, gemessen): mit dem
  vollständig zurückgebrachten 16-Bit-Fehler bleibt die Testsuite *„311 von
  311“* grün — den Rückfall sieht nur der Prüfstandsfall `E-119e`.

Nach der Regel „ein Fund wird ganz abgehakt“ fehlen diese acht im Bestand;
der nächste, der `perl tools/befund-suchen.pl paket-bauen.ps1` oder
`pruefstand-lauf.ps1` fährt, findet sie nicht (Vermutung: das Werkzeug liest
`Befunde/` nicht). **Was zu tun wäre:** je Befund ein Satz
*„Nachprüfung [PRUEFER-59](PRUEFER-59.md#pruefer-59): K…, niedrig, nicht behoben“* mit Anker.

## <a id="l-74.7"></a>L-74.7 — veraltet: der CHANGELOG-Abschnitt 7.2.0.123 heißt weiter „noch nicht bestätigt“ und E-137 „noch nicht am Programm gemessen“

* `CHANGELOG.md:128` (belegt), Überschrift: *„Strg+W in angedockter Leiste
  ([E-137](../Intern/BEFUNDE.md#e-137), noch nicht am Programm gemessen)“*.
* `CHANGELOG.md:130` (belegt): *„**Quellstand 7.2.0.123, Paket 1.0.123 —
  Testpaket, noch nicht bestätigt.**“*
* Dagegen `CHANGELOG.md:104-105` im Abschnitt darüber: *„Gregor hat 7.2.0.123
  am 26.10.2026 getestet“*; `BEFUNDE.md:395` [E-137](../Intern/BEFUNDE.md#e-137) erster Teil bestätigt.

**Was zu tun wäre:** *„Testpaket, von Gregor am 26.10.2026 getestet, Ergebnis
[TESTPLAN](Intern/TESTPLAN.md#ergebnis-7-2-0-123)“*; in der Überschrift den
Klammerzusatz zu [E-137](../Intern/BEFUNDE.md#e-137) streichen.

## <a id="l-74.8"></a>L-74.8 — veraltet: `PORTIERUNG.md` und `WERKZEUGE.md` stehen auf 7.2.0.122; `WERKZEUGE.md` kennt die neuen Prüfungen aus E-156 und E-157 nicht

* `Intern/PORTIERUNG.md:44` (belegt), oberster Stand-Absatz: *„**Stand
  23.10.2026, Zweig `e-14-gemessen-und-rollen`:** Quellstand **7.2.0.122**“*;
  letzte Änderung 24.10.2026 (gemessen: `git log -1`).
  `perl tools/doku-pruefen.pl` meldet es nur *„Zur Kenntnis“* (gemessen).
* `tools/WERKZEUGE.md:3` (belegt): *„**Stand 7.2.0.122 / Paket 1.0.122.**“*.
  Die Zeilen zu `paket-pruefen.ps1` (`:57`) und `pruefstand-lauf.ps1`
  (`:130`) erwähnen weder die Abweisung von Debug-Fassungen
  ([E-156](../Intern/BEFUNDE.md#e-156), Commit `ec177b26`) noch das
  Zurücksetzen der Registry und die Absturzauswertung
  ([E-157](../Intern/BEFUNDE.md#e-157), `d6b9ff3b`) — gemessen: `grep -c
  '[E-157](../Intern/BEFUNDE.md#e-157)\|[E-156](../Intern/BEFUNDE.md#e-156)' tools/WERKZEUGE.md` → 0. Nach `CLAUDE.md` Abschnitt 3 ist
  `WERKZEUGE.md` der Ort, an dem man vor dem Bauen nachsieht.

**Was zu tun wäre:** in `PORTIERUNG.md` den Stand-Absatz durch einen Verweis
auf `WEITERMACHEN.md` ersetzen (Gregors Regel vom 26.10.); in `WERKZEUGE.md`
je einen Satz zu den beiden Werkzeugen und den Kopf auf 7.2.0.124.

## <a id="l-74.9"></a>L-74.9 — unklar: `PAKETE.md` sagt zu 1.0.123 „`paket-pruefen.ps1`: keine Fehler“, E-156 sagt, `paket-pruefen.ps1` weise 1.0.123 mit sechs Fehlern ab

* `Releases/PAKETE.md:177` (belegt), Paket 1.0.123: *„`paket-pruefen.ps1` \|
  keine Fehler, Kriterium 0 *„startet ohne Nachinstallation: JA"*“*.
* `BEFUNDE.md:384` (belegt): *„`paket-pruefen.ps1` weist Paket 1.0.123 mit
  genau diesen sechs Dateien ab (6 FEHLER)“*.

Beides stimmt für seine Fassung des Werkzeugs (Vermutung: `PAKETE.md` gibt die
Fassung vor `ec177b26` wieder), gesagt wird es an keiner der beiden Stellen.
Wer 1.0.123 nachprüft, erhält einen anderen Befund als den eingetragenen.
**Was zu tun wäre:** in `PAKETE.md:177` *„(Fassung vor [[E-156](../Intern/BEFUNDE.md#e-156)]; die heutige
weist das Paket mit 6 Fehlern ab)“*. `PAKETE.md:197` (1.0.122) trägt dieselbe
Zeile.

## <a id="l-74.10"></a>L-74.10 — unklar: `ZIEL.md:87-89` verlangt vor dem Release Gregors Test aller neun Kriterien an einem frischen Paket; der Plan ist ein Kurztest an 7.2.0.124

* `ZIEL.md:87-89` (belegt): *„**Vor dem Release:** die Tabelle der Kriterien
  neu messen …, dann Gregors Test aller neun Kriterien an einem frischen
  Paket, erst danach die Marke.“*
* `TESTPLAN.md:10-12` (belegt): *„Geprüft wird nur, was sich gegenüber
  7.2.0.123 geändert hat; alles andere hast du an 7.2.0.123 bestätigt“* —
  K4 und K6 hat Gregor an 7.2.0.123 aber **nicht** bestätigt (`:129`,
  `:131`); T5 und T3 prüfen sie nach.
* `WEITERMACHEN.md:145` (belegt): *„sein Kurztest (TESTPLAN T1–T5), dann
  Release 7.2.1.N nach Entscheidung 10“*; Entscheidung 10 (`:143`): das
  Release bekommt eine neue Nummer in `VERSION`, Fenstertitel und ZIP, die
  Werkzeuge werden *„beim Schnüren des Release in einem Zug umgestellt“*.

Kein Paket hat bisher alle neun Kriterien in einem Durchgang bestanden; das
Release 7.2.1.N wird ein weiteres, neu gebautes Paket sein. Ob die Summe aus
7.2.0.123 und dem Kurztest den Maßstab erfüllt, ist eine Frage an Gregor
(unten). Die Formulierung *„alles andere hast du … bestätigt“* in
`TESTPLAN.md:11-12` ist für K4 und K6 ungenau, unabhängig von der Antwort.

## <a id="l-74.11"></a>L-74.11 — Doppelung: Gregors Ergebnis an 7.2.0.123 wird an drei Stellen gezählt

* `Releases/PAKETE.md:168` (belegt): *„— 15 ja, 3 nein (K4 Absturz durch
  Debug-Fassungen, K6 `</x-html>`, N7 großes `data:`-Bild)“*.
* `Intern/WEITERMACHEN.md:145` (belegt): *„([TESTPLAN](TESTPLAN.md), 15 ja,
  3 nein)“*.
* `CHANGELOG.md:105` (belegt): *„15 Punkte bestanden, drei nicht“*.

Heute stimmen alle drei mit der Ergebnistabelle (gemessen, gezählt). Nach
Gregors Regel vom 26.10. (*eine Stelle, sonst verlinken*) genügt der Verweis;
`PAKETE.md:168` wiederholt dazu die Ursachen. Kein Fehler, nur die Stelle, an
der die nächste Abweichung entsteht (so geschehen in
[L-73.5](LEKTOR-73.md#l-73.5)).

## <a id="l-74.12"></a>L-74.12 — unklar: E-156 ist kritisch und behoben, die Regressionsbilanz führt ihn „OHNE jede Prüfung“

* `perl tools/pruefe-regressionstest.pl` (gemessen): *„OHNE jede Prüfung 22
  <- Rückstand … [E-129](../Intern/BEFUNDE.md#e-129) [E-156](../Intern/BEFUNDE.md#e-156) [E-136](../Intern/BEFUNDE.md#e-136)“*; ebenso `Releases/PRUEFBERICHT.md:452`.
* `BEFUNDE.md:384` (belegt): *„Gegenprobe im Protokoll von
  `paket-pruefen.ps1` belegt: `paket-pruefen.ps1` weist Paket 1.0.123 mit
  genau diesen sechs Dateien ab (6 FEHLER)“*, *„**Stufe: kritisch**“*.

Eine Prüfung mit Gegenprobe gibt es also, das Werkzeug zählt nur Unit-Tests,
Prüfstandsfälle und `Prüfung: manuell` (Vermutung, aus `:58-60` *„Welche
Kennungen nennt der Prüfstand?“*). Für die Release-Notizen, die den Rückstand
nennen sollen (`ZIEL.md:35-36`), ist offen, ob [E-156](../Intern/BEFUNDE.md#e-156) darin zählt.
**Was zu tun wäre:** eine Marke für „durch eine Paketprüfung gedeckt“ oder
ein Vermerk am Befund; Einstufung beim Hauptagenten.

---

## Geprüft, kein Fund

* **Kurztest T1–T5** (`TESTPLAN.md:21-25`) gegen BEFUNDE: T1 passt zu [E-137](../Intern/BEFUNDE.md#e-137)
  *„Was noch fehlt“* (`:395`), T2 zu [E-119](../Intern/BEFUNDE.md#e-119) (`:365`), T3 zu [E-158](../Intern/BEFUNDE.md#e-158) (`:382`,
  Textfall), T4 zu [E-142](../Intern/BEFUNDE.md#e-142) *No* vorgewählt (`:378`), T5 zu [E-156](../Intern/BEFUNDE.md#e-156) *„null neue
  Abstürze aus dem Paketverzeichnis“* (`:384`) und [E-157](../Intern/BEFUNDE.md#e-157) *„für 7.2.0.124 muss
  sie null sein“* (`:383`). Die Ergebnistabelle 7.2.0.124 (`:27-35`) ist leer
  angelegt.
* **Ergebnistabelle 7.2.0.123** (`TESTPLAN.md:122-144`): 15 × *ja*, 3 ×
  *nein* (K4, K6, N7), gezählt; passt zu `CHANGELOG.md:105`,
  `PAKETE.md:168`, `WEITERMACHEN.md:145`.
* **CHANGELOG 7.2.0.124** (`:101-126`): die fünf Punkte und *„311 Tests“*
  passen zu BEFUNDE und `PRUEFBERICHT.md:25` (*„36 \| 36“*) bzw. den
  Unit-Tests 311; *„34 Mal“* zu [E-156](../Intern/BEFUNDE.md#e-156).
* **[E-159](../Intern/BEFUNDE.md#e-159)** (Absturz eines Prüfstands-Eudora 7.2.0.122): in beiden Listen
  (`CHANGELOG.md:27`, `WEITERMACHEN.md:366`), Stufe *wichtig*, nicht in
  `ZIEL.md` — richtig, er betrifft keinen Stand, den Gregor hat.
* **Stand-Zeilen** `README.md:99`, `ZIEL.md:174`, `AUFGABEN.md:3`,
  `TESTPLAN.md:1`, `WEITERMACHEN.md:9`, `:12`, `PAKETE.md:6`, `:159-163`:
  alle 7.2.0.124 / 1.0.124, *„1.0.124 folgt“*.
* **README *Bekannte Fehler*** [E-119](../Intern/BEFUNDE.md#e-119) (`:164`), [E-142](../Intern/BEFUNDE.md#e-142) (`:172`, *„Nach *Ja*
  meldet Eudora weiter …“*): stimmen mit BEFUNDE.
* **ZIEL-Block** (`:42-54`): genau [E-119](../Intern/BEFUNDE.md#e-119) offen, *„wer: ich“* — stimmt mit
  der Regel; ob [E-158](../Intern/BEFUNDE.md#e-158) darin stehen müsste, siehe [L-74.5](#l-74.5).

## Mechanisch

* `perl tools/doku-pruefen.pl` (gemessen): *„Kein Widerspruch gefunden.“*,
  dazu 16 Zeilen *„nennt weder den Quellstand 7.2.0.124 noch die
  Paketnummer“*, darunter `Intern/PORTIERUNG.md` (*„höchste genannte Fassung:
  7.2.0.122“*) — siehe [L-74.8](#l-74.8). `tools/WERKZEUGE.md` steht nicht in
  der Liste, obwohl es 7.2.0.122 als Stand nennt (Vermutung: es nennt
  irgendwo 1.0.124 oder wird nicht geprüft).
* `perl tools/offene-befunde.pl` (gemessen): *„offen laut Intern/BEFUNDE.md
  42 … davon NIE gemessen 14 … 42 offene Befunde, in beiden Listen gleich.“*
  — die Zahl 14 ist zu hoch, siehe [L-74.4](#l-74.4).
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„kritisch 70 … mit
  Testfall im Pruefstand 46 von 70 … OHNE jede Pruefung 22 … Kein neues
  "behoben" ohne Regressionstest.“* — siehe [L-74.12](#l-74.12).
* `perl tools/ziel-stand.pl` (gemessen): *„24 von 25 erfüllt, 1 offen -
  ZIEL.md ist auf dem Stand.“* — stimmt mit der Regel; blind für
  [L-74.1](#l-74.1) (die Kriterientabelle liest es nicht).

## Nicht geprüft

* Die übrigen zehn „nie gemessen“ der erzeugten Listen.
* `Befunde/PRUEFER-59.md` K1–K11 selbst am Quelltext — nur, ob sie im
  Bestand stehen.
* Die 46 nicht geänderten `.md` außerhalb der genannten über die
  Stand-Zeilen und `doku-pruefen.pl` hinaus.

## Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss** ([L-74.10](#l-74.10)):
  `ZIEL.md` verlangt deinen Test aller neun Kriterien an einem frischen Paket.
  Geplant ist: Ergebnis an 7.2.0.123 (dort Absturz und `</x-html>` beim
  Weiterleiten) plus Kurztest T1–T5 an 7.2.0.124, danach wird 7.2.1.N mit
  neuer Nummer gebaut. Genügt dir das, oder willst du am Paket 7.2.1.N selbst
  noch einmal alle neun Kriterien kurz durchgehen?
* **`v1.0.120` und [E-156](../Intern/BEFUNDE.md#e-156)** (aus [LEKTOR-73](LEKTOR-73.md#lektor-73), noch
  offen): das veröffentlichte Paket enthält die sechs Testfassungen, mit denen
  Eudora gelegentlich abstürzt (gemessen). Soll die README unter *Bekannte
  Fehler* einen Satz für Anwender von `v1.0.120` bekommen, oder genügt das
  kommende Release?
