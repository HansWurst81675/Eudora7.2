# <a id="lektor-62"></a>LEKTOR-62 — Mikrolauf: Commits 85554d91 und 9d135576, 25.10.2026

**Auftrag.** Nur zwei Commits: `85554d91` (die `ZIEL.md`-Zeilen zu [E-77](../Intern/BEFUNDE.md#e-77),
[E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119), [E-116](../Intern/BEFUNDE.md#e-116)) und `9d135576` (CHRONIST-2026-10-25 eingeholt,
`tools/rollen-faellig.pl` zählt nur noch `Arbeitsweise/CHRONIST-*.md`, dazu
die Zeile in `tools/WERKZEUGE.md` und die neue Lehre
`gekuerzte-ausgabe-ist-kein-ergebnis.md`). Gefragt: Ist dort etwas **falsch**
oder zerbrochen? Die 11 Funde aus [LEKTOR-61](LEKTOR-61.md#lektor-61) werden
nicht wiederholt.

**Ergebnis vorweg.** Die vier `ZIEL.md`-Zeilen stimmen in jeder geprüften
Angabe. Falsch ist etwas anderes: **derselbe Commit, der `rollen-faellig.pl`
berichtigt, trägt drei Texte ein, die den Fehler noch als offen und
unbehoben beschreiben**, mit Zeilennummern, die seit dem Commit auf einen
Kommentar zeigen ([L-62.1](#l-62.1)). Der Kopfkommentar des Werkzeugs
beschreibt die CHRONIST-Rolle doppelt falsch ([L-62.2](#l-62.2)). **4 Funde:
2 falsch, 1 ungenau, 1 Hinweis.** Keiner hält etwas auf; keine neue Frage an
Gregor.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt** (Zitat
mit Datei:Zeile), **Vermutung**.

## Was geprüft wurde und stimmt

- **PR-Nummern** (gemessen, `git log --merges --oneline origin/main`):
  #165 = `bcbce2fb` `e-77-imap-ordnernamen`, #168 = `1f64fa25`
  `e-77-umbenennen`, #164 = `0b5b93be` `e-113-breite-bilder`, #163 =
  `8f81d2a5` `e-119-data-bilder`, #170 = `032895e5` `e-119-bild-geteilt`,
  #157 = `df4f0ac1` `e-116-bildbreite-px`. Der K5-Commit `00c1c3d6` ist
  Vorfahr von `032895e5` (`git merge-base --is-ancestor`, gemessen).
- **Regressionstests** (gemessen): `Eudora71/Tests/TestE77.cpp`,
  `TestE113.cpp`, `TestE116.cpp` liegen vor und stehen in
  `Eudora71/Tests/Tests.vcxproj`. Für [E-119](../Intern/BEFUNDE.md#e-119) behauptet `ZIEL.md:69` keinen
  Testsuitefall, nur Prüfstandsfälle — richtig so.
- **Prüfstandsfälle** (belegt): `tools/pruefstand-faelle.txt:222-224,232`
  (E-77a–d), `:186,197,198` (E-113p, E-113b, E-113b2), `:206,211-213`
  (E-119a–d).
- **„zuletzt grün am 25.10.2026 auf `796369bb`"** (belegt):
  `Releases/PRUEFBERICHT.md:19` nennt den Bau `1.0.122+796369bb`, die Zeilen
  `:421-431` führen alle elf Fälle als `ok`; die Starts stehen in
  `tools/TESTLAEUFE.md:414-417`.
- **[E-116](../Intern/BEFUNDE.md#e-116) „so geschlossen auf Gregors Entscheidung vom 24.10.2026"** (belegt):
  `Intern/BEFUNDE.md:362`, eingetragen in `2222420d` (24.10.2026 22:34).
- **`tools/WERKZEUGE.md:146`** beschreibt die Änderung richtig; das Werkzeug
  meldet jetzt *„CHRONIST aktuell (Bericht 9d13557, seither 0 Dateien in
  seinem Bereich)"* (gemessen).
- **Neue Lehre** (belegt): die Entscheidung zu [E-142](../Intern/BEFUNDE.md#e-142) steht wirklich in
  `Arbeitsweise/stand-23-10-2026-spaet.md:34`; `2222420d` trägt 22:34; die
  Fallnummern 19 und 22 decken sich mit
  `Arbeitsweise/text-nicht-durch-schichten-schicken.md:424,441,443`.
- **Mechanisch** (gemessen): `perl tools/pruefe-tabellenzeilen.pl` →
  *„308 Dateien, keine gebrochene Tabellenzeile"*;
  `perl tools/ziel-stand.pl` → *„19 von 19 erfüllt, 0 offen"* (zur Aussagekraft
  dieser Zahl siehe [L-61.1](LEKTOR-61.md#l-61.1), hier nicht wiederholt).

## <a id="l-62.1"></a>L-62.1 — falsch: drei Texte nennen den Werkzeugfehler unbehoben, den derselbe Commit behebt

`9d135576` ändert `tools/rollen-faellig.pl` und trägt im selben Zug ein:

- `Arbeitsweise/CHRONIST-2026-10-25.md:64` — *„Gemessen, nicht behoben (das
  ist nicht meine Aufgabe)."*, dazu `:66` *„`tools/rollen-faellig.pl:140`:
  `bericht => 'Arbeitsweise/*.md'`"*, `:67` *„`:152`: `git log -1 …`"* und
  `:71` *„**Vorschlag:** `bericht => 'Arbeitsweise/CHRONIST-*.md'`"*; ebenso
  `:11` *„sobald es CHRONIST-Berichte von gespiegelten Lehren unterscheiden
  kann"*.
- `Arbeitsweise/daueraufgaben-brauchen-einen-takt.md:216-217` (dieselben
  Zeilennummern) und `:221` *„**Behebung (nicht von mir gemacht,
  Vorschlag):**"*.
- `Arbeitsweise/messziel-am-merkmal-erkennen.md:101` —
  *„`tools/rollen-faellig.pl:140` erkennt einen CHRONIST-Bericht an
  `Arbeitsweise/*.md`"* (Präsens).

**Stand nach dem Commit (gemessen):** `tools/rollen-faellig.pl:140-145` ist
ein Kommentar, `bericht => 'Arbeitsweise/CHRONIST-*.md'` steht in `:146`, der
`git log -1`-Aufruf in `:158`. Wer den Verweisen folgt, findet einen
Kommentar, der die Behebung beschreibt, und liest daneben, sie sei nur
vorgeschlagen.

**Was zu tun ist:** in allen drei Dateien einen Satz *„behoben in
`9d135576`"* und die Zeilennummern als Stand vor der Behebung kennzeichnen
(oder auf `:146`/`:158` setzen). Es sind Gedächtnisspiegel — die Änderung
gehört in die Gedächtnisdateien des Hauptagenten, der Haken spiegelt sie.

## <a id="l-62.2"></a>L-62.2 — falsch: der Kopfkommentar von `rollen-faellig.pl` beschreibt die CHRONIST-Rolle doppelt falsch

`tools/rollen-faellig.pl:27` (belegt): *„CHRONIST  zustaendig fuer
Arbeitsweise/   -> Bericht Arbeitsweise/*.md"*.

- Der Bericht ist seit `9d135576` `Arbeitsweise/CHRONIST-*.md` (`:146`).
- Zuständig ist der CHRONIST laut Code gar nicht für `Arbeitsweise/`, sondern
  für `muster => qr{^(?:Eudora71/|tools/)}` (`:126`). Das ist der Grund, warum
  das Werkzeug heute *„seither 0 Dateien"* meldet, obwohl der parallel
  gemergte `a4494413` 14 Dateien unter `Arbeitsweise/` geändert hat (gemessen).

Der Commit hat die Zeile 146 geändert und die Zeile 27, die dasselbe
beschreibt, stehen lassen. `:29-30` (*„die hoechste vorhandene
Berichtsdatei"*, vom Code nicht umgesetzt) hat der CHRONIST selbst schon
gemeldet (`CHRONIST-2026-10-25.md:69`) — hier nicht neu gezählt.

## <a id="l-62.3"></a>L-62.3 — ungenau: `d1760537` war kein CHRONIST-Lauf, und die neue Regel zählt ihn trotzdem

`Arbeitsweise/CHRONIST-2026-10-25.md:17` und
`Arbeitsweise/daueraufgaben-brauchen-einen-takt.md:211` nennen als letzten
CHRONIST-Bericht *„23.10. 13:03 MESZ (`d1760537`)"*. Gemessen
(`git log -- Arbeitsweise/CHRONIST-2026-10-23.md`): der Lauf selbst ist
`e8f404fb` (23.10. 11:58, *„CHRONIST 23.10.2026: zwei neue Lehren …"*);
`d1760537` ist *„[LEKTOR-52](LEKTOR-52.md#lektor-52) und [PRUEFER-46](PRUEFER-46.md#pruefer-46) eingearbeitet"* und hat
`CHRONIST-2026-10-23.md` nur in 4 Zeilen nachgezogen.

Für die Messung (59 Dateien) ändert das wenig. Es zeigt aber, dass die neue
Regel dieselbe Restschwäche hat, die der CHRONIST in `:71` nur für LEKTOR
nennt: **jede nachträgliche Änderung an einem alten `CHRONIST-*.md` — etwa
durch `befunde-verlinken.pl --verlinken` oder ein Einarbeiten — gilt als
CHRONIST-Lauf.** Vermutung, nicht gemessen: in der Praxis selten, weil alte
Berichte kaum noch angefasst werden; am 23.10. geschah es aber binnen einer
Stunde.

## <a id="l-62.4"></a>L-62.4 — Hinweis: Commit-Nachricht und Inhalt sagen bei E-116 Verschiedenes

Die Nachricht von `85554d91` sagt, alle vier Zeilen trügen *„'von Gregor
noch nicht bestaetigt'"*. `ZIEL.md:70` ([E-116](../Intern/BEFUNDE.md#e-116)) trägt den Vermerk nicht —
vermutlich mit Absicht, weil [E-116](../Intern/BEFUNDE.md#e-116) am laufenden Programm nicht nachstellbar
und auf Gregors Entscheidung geschlossen ist (`Intern/BEFUNDE.md:362`).
Die Datei ist so richtig; nur die Nachricht verspricht mehr. Nichts zu tun.
