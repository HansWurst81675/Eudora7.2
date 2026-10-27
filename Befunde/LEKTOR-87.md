# <a id="lektor-87"></a>LEKTOR-87 — Kurzprüfung der Berichtigungen zu LEKTOR-86 und der Übernahme von PRÜFER-63 vor dem PR des Zweigs `0.125_ergebnisse` nach `main`, 27.10.2026

**Auftrag.** Kurzprüfung nach dem Vorbild von [LEKTOR-83](LEKTOR-83.md#lektor-83):
(1) ob [L-86.1](LEKTOR-86.md#l-86.1) bis [L-86.7](LEKTOR-86.md#l-86.7)
erledigt sind; (2) ob die geänderten Stellen etwas Falsches oder
Widersprüchliches sagen; (3) die Übernahme von [PRÜFER-63](PRUEFER-63.md#pruefer-63)
(Rest zu [E-137](../Intern/BEFUNDE.md#e-137), Vorbedingung in TESTPLAN V6). Kein
Bestandsdurchgang. Lauf über `ecbdbba9..212f826f` — im Kern `f2619654`
(PRÜFER-63 übernommen: `Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`) und
`212f826f` ([LEKTOR-86](LEKTOR-86.md#lektor-86) eingearbeitet: acht Dateien, 16 Zeilen), gemessen im
Arbeitsbaum `Eudora7.2-wt-lektor` auf `wt/lektor-20261027d`.

**Ergebnis vorweg.** **2 Funde: 1 unklar, 1 veraltet.**
[L-86.1](LEKTOR-86.md#l-86.1) bis [L-86.7](LEKTOR-86.md#l-86.7) sind alle
erledigt. Nirgends wird [E-137](../Intern/BEFUNDE.md#e-137) (Strg+W auf einer Leiste schließt die
Mail statt der Leiste) oder [E-160](../Intern/BEFUNDE.md#e-160) (Windows-Meldung beim Anlegen einer
Persönlichkeit) als behoben oder bestätigt ausgegeben. Der Kurztest V1–V6
bleibt ohne Rückfrage ausführbar; V6 trägt jetzt die Vorbedingung aus
PRÜFER-63 K3. Der neue Restfall aus PRÜFER-63 K1 steht aber nur in
[E-137](../Intern/BEFUNDE.md#e-137): der CHANGELOG verspricht für **jeden** Doppelklick auf ein
Postfach, dass Strg+W wieder das Postfach schließt
([L-87.1](#l-87.1)) — **vor dem PR empfohlen** (ein Halbsatz).
[L-87.2](#l-87.2) hindert den PR nicht.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-86

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-86.1](LEKTOR-86.md#l-86.1) | PAKETE 1.0.127: „fällig blieb der CHRONIST“, obwohl die K1-Korrektur ungelesen war | **erledigt** | `Releases/PAKETE.md:173` *„**Fällig waren beim Schnüren PRÜFER und CHRONIST:** die K1-Behebung hatte noch niemand gegengelesen — das hat [PRÜFER-63] nach dem Schnüren nachgeholt (hält, kein Fund entwertet den Kurztest)“* (belegt). Deckt sich mit `Befunde/PRUEFER-63.md:36` *„Entwertet ein Fund Gregors Kurztest an 1.0.127? Nein.“* |
| [L-86.2](LEKTOR-86.md#l-86.2) | Entscheidung 2: „an 1.0.126 zu prüfen (V1–V3)“ | **erledigt** | `Intern/WEITERMACHEN.md:121` *„fünfter Anlauf mit Korrektur eingebaut, an 1.0.127 zu prüfen (V1–V3, Gegenprobe V6)“* (belegt) |
| [L-86.3](LEKTOR-86.md#l-86.3) | `ZIEL.md:77-78` mit 7.2.0.126, *Persona → Neu*, ohne V6 | **erledigt** | `ZIEL.md:77` *„(\*Tools → Personalities\*, Rechtsklick → \*New...\*) … kommt mit 7.2.0.127“*; `:78` *„Korrektur aus PRÜFER-62 K1 in 7.2.0.127; am Prüfstand rot an 1.0.125, grün an 1.0.126 und 1.0.127 — TESTPLAN V1–V3, Gegenprobe V6“* (belegt); gleich `Intern/TESTPLAN.md:27` (V4) |
| [L-86.4](LEKTOR-86.md#l-86.4) | [E-137](../Intern/BEFUNDE.md#e-137) „Zuletzt gemessen … an 7.2.0.126“ | **erledigt** samt erzeugter Listen | `Intern/BEFUNDE.md:396` *„grün an 1.0.126 und 1.0.127)“*, *„**Zuletzt gemessen: 27.10.2026 an 7.2.0.127**“*; `CHANGELOG.md:40` und `Intern/WEITERMACHEN.md:371` *„27.10.2026 an 7.2.0.127“* (belegt) |
| [L-86.5](LEKTOR-86.md#l-86.5) | K1-Korrektur hieß „behoben“, ungemessen | **erledigt** | `Intern/BEFUNDE.md:396` *„am selben Tag korrigiert (am Programm nicht gemessen, TESTPLAN V6)“*; `Intern/WEITERMACHEN.md:135` *„korrigiert, am Programm nicht gemessen (V6)“*; `CHANGELOG.md:107` *„soll wieder das Postfach schließen** (am Programm nicht gemessen,“* (belegt). Zum CHANGELOG-Satz selbst → [L-87.1](#l-87.1) |
| [L-86.6](LEKTOR-86.md#l-86.6) | TESTPLAN: U-Zeilen „an 7.2.0.126“, Rückmelderegel ohne V6 | **erledigt** | `Intern/TESTPLAN.md:31` *„Geht V1, V2, V3 oder V6 schief“*; `:45` *„überholt durch 7.2.0.127“*; `:67-69` *„geht in V2/V3/V5 an 7.2.0.127 auf“*; gemessen: `grep -n 7.2.0.126 Intern/TESTPLAN.md` trifft nur noch `:3-5` (*„1.0.126 bitte nicht testen“*) und U1-Geschichte `:66` |
| [L-86.7](LEKTOR-86.md#l-86.7) | `tools/ZWEIGE.md:175` „vierter Anlauf“, „Testpaket 7.2.0.126“ | **erledigt** | `tools/ZWEIGE.md:175` *„vierter und fünfter Anlauf … samt Korrektur aus PRÜFER-62 K1; … (\*Tools → Personalities\*, \*New...\*); … Testpaket 7.2.0.126 (nie getestet) und 7.2.0.127“* (belegt) |

## Übernahme von PRÜFER-63 (Commit `f2619654`)

* **Rest in [E-137](../Intern/BEFUNDE.md#e-137), belegt.** `Intern/BEFUNDE.md:396` *„**Rest, nicht behoben
  (PRÜFER-63 K1, niedrig):** Doppelklick auf ein Postfach, das schon das
  vorderste Fenster ist, dann Strg+W — das aktive Fenster wechselt nicht, und
  die Leiste \*Mailboxes\* verschwindet statt des Postfachs; nichts geht
  verloren, vermutlich war es vor dem fünften Anlauf genauso“*. Stimmt mit
  `Befunde/PRUEFER-63.md:128-147` überein, auch in der Kennzeichnung (Logik
  belegt, „vermutlich“ für die Lage vor dem fünften Anlauf). Das Urteil von
  [E-137](../Intern/BEFUNDE.md#e-137) bleibt **offen** (gemessen, `pruefe-befundurteile.pl` rc=0).
* **V6 mit Vorbedingung, belegt.** `Intern/TESTPLAN.md:29` *„ein lokales
  Postfach **doppelklicken**, das gerade **nicht** offen ist (etwa `Junk`;
  ist es offen, vorher schließen)“* — erfüllt PRÜFER-63 K3 (`:168-182`),
  strenger als nötig (offen, aber nicht vorn, misst laut K3 auch richtig);
  für Gregor die einfachere Regel. Kein Widerspruch zur Erwartung *„das eben
  geöffnete Postfach geht zu, die Leiste \*Mailboxes\* bleibt stehen“*.
* **Beispiel `Junk`:** am Quelltext legt Eudora `Junk` nur an, wenn
  `IDS_INI_ASKED_ABOUT_JUNK` gesetzt ist (`QCMailboxDirector.cpp:176-191`,
  belegt). Dass Gregors Daten aus 1.0.125 ein `Junk` haben, ist
  **Vermutung**; das *„etwa“* lässt ihm ein anderes Postfach. Kein Fund.
* **PRÜFER-63 K2** (Spurzeile `mdi-gewechselt=` zeigt nicht, ob eine Marke
  verworfen wurde, „sehr niedrig, nur Protokoll“) ist nirgends außer im
  Bericht vermerkt (gemessen: `grep -n 'PRÜFER-63\|PRUEFER-63'` über
  `*.md`, `Intern/`, `Releases/`, `tools/ZWEIGE.md` trifft nur
  `BEFUNDE.md:396` und `PAKETE.md:173`). V6 stützt sich nicht auf diese
  Spalte; ob K2 eingetragen wird, ist Sache des Hauptagenten. Kein Fund.

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | rc=0, *„Kein Widerspruch gefunden.“* |
| `perl tools/offene-befunde.pl` | rc=0, *„42 offene Befunde, in beiden Listen gleich.“* |
| `perl tools/pruefe-regressionstest.pl` | rc=0, *„Kein neues "behoben" ohne Regressionstest.“* |
| `perl tools/ziel-stand.pl` | rc=0, *„25 von 27 erfüllt, 2 offen - ZIEL.md ist auf dem Stand.“* |
| `perl tools/pruefe-befundurteile.pl` | rc=0, *„Kein Dokument erklaert einen offenen Befund fuer erledigt“* |
| `perl tools/rollen-faellig.pl` | rc=1: LEKTOR (dieser Lauf) und CHRONIST fällig; PRÜFER **nicht** mehr fällig |

Keines dieser Werkzeuge sieht, ob ein Restfall aus einem Prüferbericht im
CHANGELOG fehlt ([L-87.1](#l-87.1)).

---

## <a id="l-87.1"></a>L-87.1 — unklar: CHANGELOG 7.2.0.127 verspricht für jeden Doppelklick, dass Strg+W das Postfach schließt — der Restfall aus PRÜFER-63 K1 fehlt

**Was passiert:** wer den CHANGELOG liest, erwartet nach **jedem**
Doppelklick auf ein Postfach in *Mailboxes*, dass Strg+W das Postfach
schließt. Ist das Postfach schon das vorderste Fenster, verschwindet
stattdessen die Leiste *Mailboxes* — nichts geht verloren, aber genau das
Verhalten, das der Eintrag als korrigiert beschreibt.

* **Belegt**, `CHANGELOG.md:106-108`: *„**[[E-137](../Intern/BEFUNDE.md#e-137)] — Strg+W nach einem
  Doppelklick auf ein Postfach in \*Mailboxes\* soll wieder das Postfach
  schließen** (am Programm nicht gemessen, TESTPLAN V6).“*
* **Belegt**, Gegenstück `Intern/BEFUNDE.md:396` *„**Rest, nicht behoben
  (PRÜFER-63 K1, niedrig):** Doppelklick auf ein Postfach, das schon das
  vorderste Fenster ist, dann Strg+W — … die Leiste \*Mailboxes\*
  verschwindet statt des Postfachs“*.
* Der CHANGELOG ist die Seite nach außen; der Restfall steht nur in der
  internen Befundliste. Das ist eine bekannte Einschränkung, die ohne
  Vermerk nach `main` ginge.

**Was zu tun wäre:** nach *„TESTPLAN V6)“* ein Halbsatz, etwa *„— nicht,
wenn das Postfach schon vorn war (dann verschwindet weiter die Leiste,
[PRÜFER-63](Befunde/PRUEFER-63.md) K1)“*. **Vor dem PR empfohlen.**

## <a id="l-87.2"></a>L-87.2 — veraltet: „hier weiter“ in WEITERMACHEN nennt PRÜFER-63 nicht

**Was passiert:** wer morgen bei `Intern/WEITERMACHEN.md:135` einsteigt,
erfährt nicht, dass die K1-Korrektur gegengelesen ist und ein Restfall
bleibt; *„Als Nächstes“* nennt nur noch den CHRONIST als fällig, was mit
`rollen-faellig.pl` übereinstimmt.

* **Belegt**, `Intern/WEITERMACHEN.md:135`: *„dann [PRÜFER-62] K1 (Strg+W
  nach Doppelklick auf ein Postfach in \*Mailboxes\* versteckte die Leiste)
  korrigiert, am Programm nicht gemessen (V6); … **Als Nächstes:** PR —
  Gregor merged; Gregors Kurztest V1–V6; … CHRONIST ist fällig.“* — kein
  PRÜFER-63, kein Restfall (gemessen, `grep -n 'PRÜFER-63\|[PRUEFER-63](PRUEFER-63.md#pruefer-63)'
  Intern/WEITERMACHEN.md` ohne Treffer).

**Was zu tun wäre:** nach *„(V6)“* *„; [PRÜFER-63] liest sie gegen: hält,
Rest bei schon vorderstem Postfach in [E-137](../Intern/BEFUNDE.md#e-137) vermerkt, V6 mit
Vorbedingung“*. Hindert den PR nicht.

---

## Geprüft ohne Fund

* Alle 16 geänderten Zeilen aus `212f826f` und die zwei aus `f2619654`
  einzeln gelesen (gemessen, `git diff --word-diff ecbdbba9..HEAD`). Keine
  nennt 1.0.126 als zu testendes Paket, keine nennt [E-137](../Intern/BEFUNDE.md#e-137), [E-160](../Intern/BEFUNDE.md#e-160) oder K1
  behoben oder bestätigt.
* `Releases/PAKETE.md:173`: *„kein Fund entwertet den Kurztest“* trifft auch
  auf K3 zu, weil V6 vor Gregors Test berichtigt ist (PRÜFER-63 `:180-182`).

## Nicht geprüft

* Alles außerhalb von `ecbdbba9..212f826f`; kein Bestandsdurchgang.
* Der Quelltext der K1-Korrektur — Sache von PRÜFER-63.
* Ob Gregors Datenverzeichnis ein Postfach `Junk` hat (sein Testverzeichnis
  fasst dieser Auftrag nicht an).

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)) — ob ein frischer Test aller neun
  Kriterien nötig ist oder die Kurztests T, U, V reichen. Unverändert offen.
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)) — ob
  der Start auf einem Rechner ohne Visual Studio vor 7.2.1 noch einmal
  geprüft werden soll; zuletzt am 06.09.2026 an Paket 1.0.10.
