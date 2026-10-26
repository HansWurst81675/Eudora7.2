# <a id="lektor-70"></a>LEKTOR-70 — Prüfanleitung und Doku zum Testpaket 7.2.0.123, Zweig `vor-testpaket-7.2.0.123` bis `edbafe7d`, 26.10.2026

**Auftrag.** Kurzer Lauf vor dem Testpaket 7.2.0.123: Stand der zwölf Funde
aus [LEKTOR-69](LEKTOR-69.md#lektor-69); die Änderungen seit `33a899ec`
(gemessen: `git log --stat 33a899ec..HEAD` — `82372232` Fassung und
Prüfanleitung, `edbafe7d` Prüfstand und Prüfbericht); jeden Schritt der neuen
Prüfanleitung in `Intern/TESTPLAN.md` gegen Code und
[BEFUNDE.md](../Intern/BEFUNDE.md); Gregors Regel vom 26.10.2026: *„die infos
in den MD dateien sollen alle konsistent sein und sich nicht widersprechen"* —
Widersprüche heißen hier **falsch**, Doppelungen ohne Widerspruch **Hinweis**.

**Ergebnis vorweg.** **16 Funde** (6 falsch, 5 unvollständig, 1 veraltet,
4 Hinweise). Für das Testpaket zählen vor allem drei:

1. **Der Testplan sagt an zwei Stellen das Gegenteil.** Teil 2 verlangt, dass
   breite Bilder eingepasst werden und `data:`-Bilder erscheinen (N6, N7);
   der Abschnitt *„Was bekannt ist — bitte nicht als neuen Fehler melden"*
   desselben Dokuments sagt, beides passiere **nicht** ([L-70.1](#l-70.1)).
2. **Die Prüfanleitung sagt nicht, woher Gregors Postfächer und Konten im
   neuen Verzeichnis kommen.** Das Mailverzeichnis im Paket ist leer; ohne
   Hineinkopieren lassen sich K2, K3 und N3 bis N7 nicht fahren. Liegt in
   seinem Mailverzeichnis eine eigene `rootcerts.p7b`, prüft K3 die **alte**
   Zertifikatsliste, und nichts in der Anleitung würde das zeigen
   ([L-70.7](#l-70.7)).
3. **`WEITERMACHEN.md` nennt in derselben Tabelle zwei Quellstände** —
   Zeile 9 *7.2.0.122 / 1.0.122*, Zeile 12 *1.0.123 / 7.2.0.123*
   ([L-70.2](#l-70.2)); `doku-pruefen.pl` meldet es nicht.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Mechanisch

Gemessen am 26.10.2026 um 09:09 im Arbeitsbaum `Eudora7.2-wt-lektor` auf
`edbafe7d` (nach `git fetch`, `git merge --ff-only` meldete *„Already up to
date"*). Zitiert, nicht als Urteil übernommen — keiner der Funde unten wird
von diesen Werkzeugen gemeldet.

| Werkzeug | Ausgabe (gekürzt) |
|---|---|
| `perl tools/doku-pruefen.pl` | *„Kein Widerspruch gefunden."*; 15 Hinweise *„nennt weder den Quellstand 7.2.0.123 noch die Paketnummer 1.0.123"* (`Doku/ANWENDER.md`, `Doku/HINTERGRUND.md`, `Intern/PORTIERUNG.md`, `Intern/TESTBERICHT-E125.md`, `MELDUNGEN-VON-AUSSEN.md`, Release-Notizen, Issue-Antworten, `Testdaten/README.md`, `tools/pruefdaten/LIESMICH.md`) — Archiv- oder Nachschlagedateien, kein Fund. **Nicht gemeldet:** `Intern/WEITERMACHEN.md:9` nennt 7.2.0.122 ([L-70.2](#l-70.2)), `README.md:99` ebenso ([L-70.12](#l-70.12)) |
| `perl tools/ziel-stand.pl` | *„ziel-stand: 23 von 23 erfüllt, 0 offen - ZIEL.md ist auf dem Stand."* — derselbe Widerspruch wie [L-61.1](LEKTOR-61.md#l-61.1), siehe [L-70.6](#l-70.6) |

## Funde aus LEKTOR-69

| Fund | worum es ging | Stand heute | Beleg |
|---|---|---|---|
| [L-69.1](LEKTOR-69.md#l-69.1) | Einleitung zu *Bekannte Fehler* gegen die E-142-Zeile | **erledigt** für [E-142](../Intern/BEFUNDE.md#e-142) — aber neu verletzt, siehe [L-70.3](#l-70.3) | `README.md:152` *„Bis auf die mit Selten beginnende Zeile und den Entwurf aus einem IMAP-Ordner (dort nur, wenn man das Original löscht)"* |
| [L-69.2](LEKTOR-69.md#l-69.2) | [E-142](../Intern/BEFUNDE.md#e-142) sagt „Verloren geht nichts" | **erledigt**; ein neuer Widerspruch in derselben Zeile, [L-70.4](#l-70.4) | `BEFUNDE.md:378` *„Sofort verloren geht nichts … wer es dort löscht, weil er es für verschoben hält, verliert den Entwurf."* |
| [L-69.3](LEKTOR-69.md#l-69.3) | Logzeile und Spurmarke nur mit Schalter 32768 | **erledigt** in README, CHANGELOG, [E-148](../Intern/BEFUNDE.md#e-148), `ZIEL.md` 2a, `WEITERMACHEN.md:316`; Rest in README-Absatz und Testplan, [L-70.7](#l-70.7), [L-70.13](#l-70.13) | `README.md:285-287` *„sofern `LogLevel` … den Schalter 32768 enthält"*; `CHANGELOG.md:136-137`; `ZIEL.md:195` *„Eine leere Spur zählt nur, wenn …"* |
| [L-69.4](LEKTOR-69.md#l-69.4) | CHANGELOG „auf `main` … bis PR #174" | **erledigt** | `CHANGELOG.md:100-102` *„bis PR #175 (25.10.2026); [E-142](../Intern/BEFUNDE.md#e-142), [E-146](../Intern/BEFUNDE.md#e-146), [E-154](../Intern/BEFUNDE.md#e-154) und die Protokollzeilen kommen mit dem PR aus dem Zweig"*; Überschrift `:97` zählt alle Punkte auf |
| [L-69.5](LEKTOR-69.md#l-69.5) | „Was noch fehlt" nennt bei Behobenem die Behebung | **teilweise** — [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119) berichtigt (*„Was noch fehlt: Gregors Bestätigung am Testpaket 7.2.0.123"*, `BEFUNDE.md:324`, `:359`, `:365`); [E-146](../Intern/BEFUNDE.md#e-146) siehe [L-70.15](#l-70.15) | |
| [L-69.6](LEKTOR-69.md#l-69.6) | `ZIEL.md` 2a führt [E-77](../Intern/BEFUNDE.md#e-77) als offen | **teilweise** — 2a berichtigt (`:195`), die Zusammenfassung darunter nicht ([L-70.6](#l-70.6)) | `ZIEL.md:204-205` *„Was Kriterium 2 noch fehlt, steht vollständig in der Zeile 2a: [E-77](../Intern/BEFUNDE.md#e-77) (IMAP-Postfachnamen mit Umlauten) und die Meldung …"* |
| [L-69.7](LEKTOR-69.md#l-69.7) | E-77-Nebenwirkung auf alte Ablageziele fehlt in der README | **erledigt** | `README.md:184`, Gregors Entscheidung `WEITERMACHEN.md:140` (Punkt 7) |
| [L-69.8](LEKTOR-69.md#l-69.8) | „kommt immer wieder" | **erledigt in der README**, offen im Befund ([L-70.5](#l-70.5)) | `README.md:182` *„kommt nach jedem Programmstart einmal wieder"* |
| [L-69.9](LEKTOR-69.md#l-69.9) | `WEITERMACHEN.md` Kopf auf `RC1_vorbereiten` | **teilweise** — Kopf berichtigt, Reste in [L-70.2](#l-70.2), [L-70.12](#l-70.12) | `WEITERMACHEN.md:132` *„Zweig `vor-testpaket-7.2.0.123` … `origin/main` = PR #175"* |
| [L-69.10](LEKTOR-69.md#l-69.10) | kein Ort für Gregors Ergebnisse je Kriterium | **teilweise** — die Tabelle gibt es jetzt (`TESTPLAN.md:55-80`); der Prüfbericht verweist nicht auf sie ([L-70.16](#l-70.16)) | `Releases/PRUEFBERICHT.md:457` *„[TESTPLAN.md, Buchfuehrung](../Intern/TESTPLAN.md) (je Paket und Pruefschritt …)"* |
| [L-69.11](LEKTOR-69.md#l-69.11) | vier README-Zeilen sagen mehr als gemessen | **erledigt** für [E-142](../Intern/BEFUNDE.md#e-142), [E-143](../Intern/BEFUNDE.md#e-143), [E-136](../Intern/BEFUNDE.md#e-136); **offen** für [AN-1](../Intern/BEFUNDE.md#an-1) (Stufe *kritisch* „nicht mehr zu öffnen" gegen *„verloren geht nichts"*, beides im Befund) | `README.md:181` *„vermutlich … (am Quelltext gelesen, nicht gemessen)"*; `:178` *„Gemessen an einem Emoji …; für andere Schriften erschlossen"*; `:179` *Was hilft* neu |
| [L-69.12](LEKTOR-69.md#l-69.12) | Testplan auf 1.0.122 und 301 Tests | **erledigt** bis auf den Satz zu `LogLevel` ([L-70.7](#l-70.7)) | `TESTPLAN.md:1`, `:8`; Testzahl nur noch im Prüfbericht (`:313`) |

Ältere Funde derselben Klasse, weiter offen: [L-61.1](LEKTOR-61.md#l-61.1)
(siehe [L-70.6](#l-70.6)), [L-61.8](LEKTOR-61.md#l-61.8) (nicht erneut
gelesen), [L-61.9](LEKTOR-61.md#l-61.9) (`ZIEL.md:170` *„Stand 22.10.2026.
Quellstand 7.2.0.120"*, belegt), [L-56.3](LEKTOR-56.md#l-56.3)
(`CHANGELOG.md:176-177` *„deshalb im Befund ‚eingebaut', nicht ‚behoben'"*
gegen `BEFUNDE.md:362` *„behoben, am laufenden Programm nicht nachstellbar"*,
belegt).

---

## <a id="l-70.1"></a>L-70.1 — falsch: „Was bekannt ist" im Testplan nennt drei Fehler, die das Testpaket behebt und Teil 2 prüft

* `Intern/TESTPLAN.md:286`, Überschrift (belegt): *„Was bekannt ist — bitte
  nicht als neuen Fehler melden"*; darunter `:292-295`: *„Bilder, die als
  `data:`-Adresse in der Mail stecken, erscheinen als **grauer Kasten**."* —
  *„Bilder, die **breiter sind als das Fenster**, werden nicht verkleinert."* —
  *„Eine Größenangabe mit Einheit (`width="35px"`) wird nicht ausgewertet."*
* Dasselbe Dokument, `:44-45`, N6 [E-113](../Intern/BEFUNDE.md#e-113): *„das
  Bild passt im Antwortfenster in die Breite, unverzerrt"*; N7
  [E-119](../Intern/BEFUNDE.md#e-119): *„Bild statt grauem Kasten"*.
* `CHANGELOG.md:97` und `README.md:171-172`: alle drei sind in 7.2.0.123
  behoben ([E-116](../Intern/BEFUNDE.md#e-116) eingeschlossen).

Der Abschnitt steht unter dem Satz *„Die Abschnitte direkt hierunter sind
Nachschlagewerk, kein Auftrag"* (`:82`), seine Überschrift ist aber eine
Anweisung an Gregor. Sieht er in N7 einen grauen Kasten, sagt ihm `:292`, das
sei bekannt und nicht zu melden.

**Was zu tun wäre:** die drei Punkte streichen oder mit *„bis Paket 1.0.122"*
kennzeichnen; die übrigen Punkte des Abschnitts (`:288-291`, `:298-304`) gegen
die README-Tabelle prüfen und am besten durch einen Verweis auf sie ersetzen
(Gregors Regel: eine Stelle).

## <a id="l-70.2"></a>L-70.2 — falsch: `WEITERMACHEN.md` nennt in einer Tabelle zwei Quellstände

* `Intern/WEITERMACHEN.md:9`, Zeile *Quellstand* (belegt): *„**7.2.0.122**
  (`Eudora71/Version.h`), `VERSION` **1.0.122**, Zweig
  `e-14-gemessen-und-rollen`"*.
* `:12`, Zeile *Paketnummer* (belegt), am 26.10.2026 in `82372232` geändert:
  *„**1.0.123** (`VERSION`, Quellstand 7.2.0.123)"*.
* Gemessen: `Eudora71/Version.h:14` `#define EUDORA_BUILD_VERSION "7.2.0.123"`,
  `VERSION` = `1.0.123`.

Zeile 9 nennt außerdem einen Zweig, auf dem niemand mehr arbeitet. Der Kopf
`:3` sagt *„Stand 25.10.2026"*. `doku-pruefen.pl` meldet beides nicht — es
sucht offenbar nur, ob eine Datei die Fassung **irgendwo** nennt (Vermutung).

**Was zu tun wäre:** Zeile 9 auf 7.2.0.123 / 1.0.123 und den Zweig
`vor-testpaket-7.2.0.123`; der Rest der Zeile ([E-125](../Intern/BEFUNDE.md#e-125), [E-111](../Intern/BEFUNDE.md#e-111)) gehört in die
Zeile *Quellstand davor*.

## <a id="l-70.3"></a>L-70.3 — falsch: die Einleitung zu *Bekannte Fehler* hält nach den neuen Zeilen zu E-141 und E-77 nicht

* `README.md:152` (belegt): *„Bis auf die mit Selten beginnende Zeile und den
  Entwurf aus einem IMAP-Ordner … geht in keinem dieser Fälle eine
  **Nachricht in Ihrem Postfach** verloren."*
* `:185`, [E-141](../Intern/BEFUNDE.md#e-141), Spalte *Was kann verlorengehen*
  (belegt): *„als gelöscht markierte Nachrichten in diesem IMAP-Ordner, die
  sonst noch zurückzuholen wären"* — das sind Nachrichten im Postfach, und
  der `EXPUNGE` entfernt sie am Server endgültig (`BEFUNDE.md`, [E-141](../Intern/BEFUNDE.md#e-141):
  *„bis hin zu einem `EXPUNGE` auf dem Server"*).
* `:184`, die Nebenwirkung von [E-77](../Intern/BEFUNDE.md#e-77) (belegt):
  *„die **abgelegte Kopie** dieser Nachricht"*. Ob eine nie geschriebene
  Ablagekopie eine „verlorene Nachricht im Postfach" ist, ist Auslegung; die
  E-141-Zeile ist es nicht.

Dazu, in derselben E-141-Zeile: *„Ziehen aus einem IMAP-Ordner nach `Out` …
meldet ‚No messages were transferred!'"* gilt seit 1.0.122 nur noch für
**Entwürfe** und in 7.2.0.123 nur nach **Ja** auf den E-142-Hinweis — für
empfangene Nachrichten überspringt `E125Abgelehnt` die Nachbearbeitung, für
*Nein* `E142Abgebrochen` (belegt: `tocdoc.cpp:3166` *„if ( !E125Abgelehnt &&
!E142Abgebrochen &&"*; `BEFUNDE.md`, [E-141](../Intern/BEFUNDE.md#e-141): *„Für empfangene Nachrichten ist es
dort sogar abgestellt"*).

**Was zu tun wäre:** die Einleitung um die E-141-Zeile ergänzen (oder sie
allgemeiner fassen: *„Die zweite Spalte sagt, was verlorengehen kann"*, ohne
Ausnahmeliste); die E-141-Zeile auf *„einen Entwurf … nach `Out` ziehen und
den Hinweis mit Yes bestätigen"* eingrenzen.

## <a id="l-70.4"></a>L-70.4 — falsch: E-142 sagt „Behoben wird das nicht" und „Was noch fehlt: … dann beheben"

* `Intern/BEFUNDE.md:378`, Kurzfassung (belegt): *„Behoben wird das nicht —
  vereinbart ist ein Hinweis, eingebaut am 26.10.2026."*
* Dieselbe Zeile (belegt): *„**Was noch fehlt:** die Ursache der leeren Kopie
  messen (Spurmarke beim Lesen der IMAP-Quelle, Vorschlag in PRÜFER-48), dann
  beheben."* — und das steht, von `offene-befunde.pl` erzeugt, in
  `CHANGELOG.md:32` unter *Noch offen*.
* `ZIEL.md:74` (belegt): die README-Punkte *„werden nach 7.2.1 angegangen"*.

Der Leser der Kurzfassung (Gregor, Lehre *Befund in Klartext*) erfährt, dass
nichts mehr kommt; der CHANGELOG sagt, die Behebung stehe aus.

**Was zu tun wäre:** *„Behoben wird das vor 7.2.1 nicht"* — oder „Was noch
fehlt" auf *„nach 7.2.1: …"* stellen. Eins von beiden.

## <a id="l-70.5"></a>L-70.5 — falsch: E-139 heißt weiter „kommt bei jeder Gelegenheit wieder"

* `Intern/BEFUNDE.md:389`, Titel (belegt): *„Die Meldung ‚Rechtschreibprüfung
  nicht vorhanden' kommt bei jeder Gelegenheit wieder"*; erzeugt in
  `CHANGELOG.md:35` (*Noch offen*).
* `README.md:182` (belegt), berichtigt nach [L-69.8](LEKTOR-69.md#l-69.8):
  *„kommt nach jedem Programmstart einmal wieder"*; Code `spell.cpp:56`,
  `:60-61` (`s_bHinweisGezeigt`, belegt in [LEKTOR-69](LEKTOR-69.md#lektor-69)).

Gregors eigene Messung steht in derselben Befundzeile. **Was zu tun wäre:**
den Titel angleichen; `CHANGELOG.md` folgt beim nächsten Lauf von
`offene-befunde.pl` von selbst.

## <a id="l-70.6"></a>L-70.6 — falsch: `ZIEL.md` sagt oben „alle erfüllt", unten „zwei fast" und „E-77 fehlt noch"

* Gemessen: `ziel-stand.pl` *„23 von 23 erfüllt"*; `ZIEL.md:44` *„Stand: 23
  von 23 erfüllt, 0 offen"*, `:50` *„Alle Zeilen des Maßstabs sind erfüllt."*
* `ZIEL.md:203-206` (belegt): *„zwei sind fast erfüllt (2, 4). Was Kriterium 2
  noch fehlt, steht vollständig in der Zeile 2a: [E-77](../Intern/BEFUNDE.md#e-77) (IMAP-Postfachnamen mit
  Umlauten) und die Meldung …"* — 2a selbst (`:195`) sagt seit dem 26.10.2026
  *„[E-77](../Intern/BEFUNDE.md#e-77) … ist behoben"*. `:194` und `:197` tragen *„fast"*;
  `CHANGELOG.md:73-74` (*Erreicht*) ebenso.
* `ZIEL.md:28-30` (belegt): *„getestet heißt hier: am Paket gelaufen, von mir
  am Prüfstand und von Gregor an seinem lokalen Test"* — und `:67-69` sagen zu
  [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119) *„von Gregor noch nicht bestätigt"*.

Offen seit [L-61.1](LEKTOR-61.md#l-61.1) (25.10.2026). Für das Testpaket ist
das kein Hindernis, aber nach Gregors Regel ein Widerspruch: der erzeugte
Block zählt „behoben" als erfüllt, die Definition darüber verlangt Gregors
Test. **Was zu tun wäre:** die Zeilen 203-206 auf den Stand von 2a bringen
(nur noch die Meldung); ob `ziel-stand.pl` „behoben, von Gregor noch nicht
bestätigt" als *erfüllt* zählen soll, ist eine Werkzeugfrage — bis dahin
sollte der Block es zumindest sagen.

## <a id="l-70.7"></a>L-70.7 — unvollständig: die Prüfanleitung sagt nicht, wie Gregors Postfächer ins neue Verzeichnis kommen — und was das für K3 heißt

* `Intern/TESTPLAN.md:3-6` (belegt): *„es kommt nach
  `C:\Users\Gregor\Eudora72-1.0.123-release`, neben dein 1.0.122"*; `:10`
  *„Starten immer mit `Eudora starten.cmd`"* — kein Wort zum Mailverzeichnis.
* Das Paket bringt nur die Vorgabe mit (belegt: `Releases/PAKETE.md:642`
  *„`Mailverzeichnis` enthält nur die Vorgabe-`Eudora.ini`"*;
  `tools/paket-bauen.ps1:620-630` ergänzt dort nur `LogLevel=58527`). Frühere
  Anleitungen sagten es ausdrücklich (`TESTPLAN.md:217-219` *„Das
  Mailverzeichnis im Paket ist **leer** — deine Postfächer … müssen bei
  **geschlossenem** Eudora hineinkopiert werden"*; ebenso `:528-529`).
* Ohne seine Daten und Konten sind K2 (*„Nachrichten in `In` (lokal)"*), K3
  (*„bei GMX und bei freenet Mail abrufen"*), N3 bis N7 nicht ausführbar.

**Folge für K3 und die Protokollzeile.** K3 (`:28`) sagt *„das prüft zugleich
die neue Zertifikatsliste, [E-148](../Intern/BEFUNDE.md#e-148)"*. Das stimmt nur, wenn im
**hineinkopierten** Mailverzeichnis keine eigene `rootcerts.p7b` liegt — die
hätte Vorrang (`README.md:275-283`, `BEFUNDE.md:384` PRÜFER-51 K6). Die
Ergebniszeile *Protokoll* (`:80`) verlangt nur *„mit `rootcerts.p7b geladen
aus:`"*, nicht **welches** Verzeichnis dort stehen muss. Ob Gregors
Mailverzeichnis eine eigene Datei hat, ist hier **nicht gemessen**.

**Dazu `LogLevel`** ([L-69.12](LEKTOR-69.md#l-69.12)): bringt er seine
`Eudora.ini` mit, gilt deren `LogLevel`. `TESTPLAN.md:520` nennt *„`LogLevel=58527`
(wie bei dir eingestellt)"* (14.10.2026) — **Vermutung:** gilt noch. Die
Positivprobe steht in der Protokollzeile (`rootcerts.p7b geladen aus:`), das
genügt nach `ZIEL.md:195`.

**Was zu tun wäre:** einen Schritt *Vorbereitung* vor Teil 1: welches
Mailverzeichnis (1.0.122 oder die Sicherung) bei geschlossenem Eudora
hineinkopieren; danach `rootcerts.p7b` im Mailverzeichnis löschen, falls
vorhanden. In der Protokollzeile: *„… geladen aus:
C:\Users\Gregor\Eudora72-1.0.123-release\rootcerts.p7b (vorhanden)"* — das
Programmverzeichnis, nicht das Mailverzeichnis.

## <a id="l-70.8"></a>L-70.8 — unvollständig: M1 in Teil 3 lässt die Vorbereitung weg, und die Reihenfolge des Tests macht Schritt 1 stumm

* `TESTPLAN.md:52` (belegt): *„wie in M1 beschrieben, nur Schritt 1 bis 4"*.
* Die Vorbereitung von M1 (`:604-608`, belegt): *„daneben eine zweite
  Installation mit **eigener** `Eudora.ini` … (bei mir `C:\Temp\E132` und
  `C:\Temp\E131`). Die zweite einmal starten und beenden, damit sie in der
  Registry … steht."* — sie ist kein Schritt und nennt keine Verzeichnisse
  von Gregor.
* Teil 1 K0/K1 startet zuerst das neue Paket mit `Eudora starten.cmd`. Danach
  zeigt die Registry auf das **eigene** Paket, und Eudora fragt **nicht**
  (belegt: `Releases/PAKETE.md:280` *„Gegenprobe: zeigt die Registry auf das
  eigene Paket, steht `fremd=0` und es wird nicht gefragt"*). Schritt 1 von M1
  ergibt dann keine Rückfrage, und Gregor meldet einen Fehler, der keiner ist.
* Schritt 3 verlangt *„SHA256 vorher/nachher vergleichen"* (`:614`), ohne
  Befehl.

**Was zu tun wäre:** in Teil 3 *„Vorbereitung und Schritt 1 bis 4"*; die
Vorbereitung für Gregor ausschreiben: *„vorher einmal `Eudora72-1.0.122-release\Eudora starten.cmd`
starten und beenden; dann im 1.0.123 `Eudora.exe` doppelklicken"*; für den
Vergleich einen Befehl (`certutil -hashfile …\Eudora.ini SHA256`) oder
*„Änderungsdatum der Datei vorher und nachher"*.

## <a id="l-70.9"></a>L-70.9 — unvollständig: N1/N2 prüfen nicht alles, was E-137 vereinbart und verlangt

* `BEFUNDE.md:391`, [E-137](../Intern/BEFUNDE.md#e-137) *„Was noch fehlt"* (belegt): *„Strg+W in der
  angedockten und in der schwebenden Leiste, einmal mit offenem Postfach `In`;
  im `eudora.log` muss die Spurmarke stehen."* — und Gregors Entscheidung vom
  25.10.2026 ebenda: *„auch Datei → Schließen und der Knopf Close Window
  verstecken die Leiste, wenn sie den Schwerpunkt hat"*.
* `TESTPLAN.md:41-42` (N1, N2) prüfen nur Strg+W; die Ergebniszeile
  *Protokoll* (`:80`) nennt die Spurmarke `[E-137](../Intern/BEFUNDE.md#e-137) Strg-W: Wazoo-Leiste wird
  versteckt statt Eudora zu beenden` nicht, ebenso wenig `[E-142](../Intern/BEFUNDE.md#e-142) Hinweis
  Entwurf aus IMAP nach Out: … antwort=nein` (`tocdoc.cpp:2791`, belegt).

Die beiden anderen Wege laufen über denselben Block am Anfang von
`OnCommand` (`BEFUNDE.md:391`), sind aber genau wie Strg+W am Programm nie
gefahren. Ein Absturz dort beendet Eudora wie vorher — mit offenen
Verfassen-Fenstern (`BEFUNDE.md:391` *„Was verlorengehen kann: alles, was in
offenen Verfassen-Fenstern steht"*).

**Was zu tun wäre:** N1 um *„danach dasselbe mit File → Close"* ergänzen; in
die Protokollzeile die beiden Spurmarken aufnehmen (der Hauptagent liest das
Protokoll ohnehin selbst).

## <a id="l-70.10"></a>L-70.10 — unvollständig: N3 nennt den IMAP-Ordner nicht beim Namen und warnt nicht vor *Yes*

* `TESTPLAN.md:43`, N3 (belegt): *„einen Entwurf (File → Save, liegt in `Out`)
  in den IMAP-Papierkorb ziehen, dann zurück nach `Out` ziehen"*.
* Welcher Ordner das ist, sagt die Anleitung nicht. N4 (`:44`) nennt für GMX
  *Gelöscht*, M3 (`:676`) spricht von *„das `Trash` unter deinem IMAP-Konto"*,
  [E-142](../Intern/BEFUNDE.md#e-142) (`BEFUNDE.md:378`) vom *„Papierkorb unter `<Dominant>`"*. Genau diese
  Unschärfe hat am 23.10.2026 [E-142](../Intern/BEFUNDE.md#e-142) hervorgebracht (`BEFUNDE.md:378` *„nahm
  das IMAP-`Trash` statt des lokalen, weil meine Anweisung nicht sagte,
  welches"*; Lehre *Testschritt nennt den Ort*).
* N3 sagt *„No drücken"*. Was bei **Yes** passiert, steht in der README-Zeile
  zu [E-141](../Intern/BEFUNDE.md#e-141) (`README.md:185`): die
  IMAP-Nachbearbeitung läuft an und kann je nach Einstellung den Ordner am
  Server bereinigen. Im Papierkorb liegen am ehesten gelöscht markierte
  Nachrichten (Vermutung). Mit *No* ist das abgestellt (belegt,
  `tocdoc.cpp:3166`).

Der Hinweistext in N3 stimmt wörtlich mit `EudoraRes.rc:7809` überein
(belegt), und der Weg erreicht den Hinweis: ein Entwurf passiert die
E-125-Ablehnung (`tocdoc.cpp:2752` *„if (ToOut && !Sum->IsComp())"*), wie
Gregors Lauf vom 23.10.2026 zeigt (*„[E-27](../Intern/BEFUNDE.md#e-27) NewCompDocument"*, keine
E-125-Zeile, `BEFUNDE.md:378`).

**Was zu tun wäre:** den Ordner nennen (*„in den Ordner *Gelöscht* unter
deinem GMX-Konto"* o. ä., wie er bei Gregor heißt); *„nicht Yes"* dazu.

## <a id="l-70.11"></a>L-70.11 — Hinweis: N5 prüft nur, was Eudora anzeigt, nicht, was am Server ankommt

* `TESTPLAN.md:45`, N5 (belegt): *„einen Testordner `Test-ä` anlegen, in
  `Test-ö` umbenennen, öffnen, dann löschen | heißt richtig, lässt sich öffnen,
  keine Fehlermeldung"*.
* Ausführbar auf GMX (belegt): das Anlegen kodiert den Namen
  (`ImapAccount.cpp:2653` `E77ImapNameFuerServer`), das Umbenennen ebenso
  (`:3001`, `:3016`, `:3029-3046`), und seit [E-146](../Intern/BEFUNDE.md#e-146) führt Eudora genau den
  kodierten Namen weiter (`:3078-3079`). GMX hat einen Trenner
  (`BEFUNDE.md:385` *„GMX und freenet haben eine Hierarchie"*). Löschen nimmt
  den gespeicherten Servernamen (`:2852-2912`); am Prüfstand gibt es dafür
  keinen Fall (Vermutung: geht).
* `CHANGELOG.md:216-217` (belegt): *„Anlegen ist nur in der Testsuite
  geprüft."* N5 ist also der erste Lauf am Programm.

Zeigt Eudora `Test-ö` richtig an, beweist das nicht, dass der Server den
Namen in modifiziertem UTF-7 bekam: ein Server, der rohe Bytes annimmt, gäbe
sie zurück, und die Anzeige stimmte trotzdem (Vermutung; Lehre *Gegenprobe
umdrehen*). **Was zu tun wäre:** *„vor dem Löschen im GMX-Webmailer
nachsehen: heißt der Ordner dort `Test-ö`?"* — dauert eine Minute.

## <a id="l-70.12"></a>L-70.12 — veraltet: drei Stellen nennen den Stand von vorgestern

* `README.md:99` (belegt): *„Stand **7.2.0.122** / `VERSION` **1.0.122** —
  geschnürt als Paket 1.0.122"*. `VERSION` sagt `1.0.123` (gemessen). Gemeint
  ist vermutlich *das letzte geprüfte Paket*; dann sollte es so heißen.
* `Intern/WEITERMACHEN.md:132` (belegt): *„`origin/main` = PR #175 … Auf
  `main`: PR #174 ([E-150](../Intern/BEFUNDE.md#e-150), …)"* — im selben Satz. Und `:142` *„Als Nächstes:
  Fassung 7.2.0.123 / 1.0.123 setzen, bauen, Prüfstand und Prüfbericht, …,
  Prüfanleitung in `TESTPLAN.md`"* — erledigt in `82372232` und `edbafe7d`
  (gemessen, `git log`).
* `ZIEL.md:170` *„Stand 22.10.2026. Quellstand 7.2.0.120"* ([L-61.9](LEKTOR-61.md#l-61.9)).

## <a id="l-70.13"></a>L-70.13 — unvollständig: „Neu im Testpaket 7.2.0.123" in der README

* `README.md:136-145` (belegt). Vier Punkte fehlen gegenüber
  `CHANGELOG.md:97`: der Hinweis zu [E-142](../Intern/BEFUNDE.md#e-142),
  [E-116](../Intern/BEFUNDE.md#e-116), die Logzeile zu `rootcerts.p7b` und die
  Spurmarke zu *„improper argument"*. [E-142](../Intern/BEFUNDE.md#e-142) steht immerhin in der
  Fehlertabelle (`:179` *„Ab dem Release 7.2.1 fragt Eudora vorher nach"*).
* `:144-145` (belegt): *„Ausnahmen, nach denen Eudora bisher wortlos endete,
  stehen jetzt im Protokoll ([E-154](../Intern/BEFUNDE.md#e-154))"* — ohne die
  Bedingung, die dieselbe README für `rootcerts.p7b` nennt: beide Zeilen
  schreiben mit `DEBUG_MASK_MISC` (belegt, `eudora.cpp:2018`, `:2030`).
* `:137-138` (belegt): *„Strg+W in einer angedockten Leiste versteckt nur die
  Leiste"* als Tatsache; der Befund sagt *„offen … am laufenden Programm noch
  NICHT gemessen"* (`BEFUNDE.md:391`), der CHANGELOG ebenso (`:108`).

Kein Widerspruch im strengen Sinn — die README beschreibt ein Testpaket —,
aber drei Stellen sagen über denselben Inhalt dreierlei. Siehe
[L-70.14](#l-70.14).

## <a id="l-70.14"></a>L-70.14 — Hinweis: der Inhalt von 7.2.0.123 steht an fünf Stellen, verschieden vollständig

Gemessen (gelesen): `CHANGELOG.md:97-108` (alle Punkte), `README.md:136-145`
(ohne vier, [L-70.13](#l-70.13)), `Intern/AUFGABEN.md:3` (alle, nach Herkunft
`main` / Zweig), `Intern/WEITERMACHEN.md:132-142` (als Entscheidungen),
`ZIEL.md:67-73` (je Befund mit Stand). Dazu `Releases/PAKETE.md:162` verweist
richtig auf den CHANGELOG. Nach Gregors Regel vom 26.10.2026 gehört die
Aufzählung an eine Stelle (CHANGELOG), die anderen verlinken. Der Rückbau ist
für nach dem Testpaket geplant; bis dahin ist jede Abweichung ein Kandidat für
den nächsten Widerspruch.

## <a id="l-70.15"></a>L-70.15 — Hinweis: E-146 trägt den alten Fehler noch einmal im Präsens

* `BEFUNDE.md:385` (belegt), nach *„Vermutet, nicht gemessen: … (K7)."*:
  *„Benennt man auf einem IMAP-Server ohne Ordnerhierarchie einen Ordner um,
  heißt er in Eudora danach falsch (aus ‚Ablage' wird ‚AblageAblage-…'), und
  jeder weitere Zugriff fragt den Server nach einem Ordner, den es nicht
  gibt"* — und weiter hinten derselbe Satz noch einmal, richtig als
  *„**Vorher (bis 26.10.2026):**"*.

Rest von [L-69.5](LEKTOR-69.md#l-69.5). **Was zu tun wäre:** den ersten Satz
(samt *„Für Gregor ist nichts zu tun …"*) streichen; *„Was noch fehlt"* stimmt.

## <a id="l-70.16"></a>L-70.16 — Hinweis: der Prüfbericht verweist auf die Buchführung statt auf die neue Ergebnistabelle, und sein Bau war nicht sauber

* `Releases/PRUEFBERICHT.md:457` (belegt): *„Gregors eigene Ergebnisse am
  Paket: [TESTPLAN.md, Buchfuehrung](../Intern/TESTPLAN.md) (je Paket und
  Pruefschritt, mit Paketnummer)"* — die Tabelle *je Kriterium* steht seit
  `82372232` unter `TESTPLAN.md#ergebnis-7-2-0-123` (`:55`). Der Abschnitt
  wird von `tools/pruefbericht.pl` erzeugt.
* `:6` (belegt): *„`82372232` — **Arbeitsbaum nicht sauber** (3 Dateien)"*;
  der Prüfstand lief am Bau `1.0.123+82372232 2026-10-26 08:50` (`:19`).
  Welche drei Dateien das waren, sagt der Bericht nicht. **Vermutung:** die
  drei Prüfstandsdateien, die `edbafe7d` danach eincheckte
  (`Intern/pruefstand-buch.tsv`, `-dauer.txt`, `-ergebnis.txt`) — dann ist der
  Bau sauber und nur der Bericht ungenau.
* `Releases/PAKETE.md:161-162` (belegt): *„Bau, Prüfstand und Schnüren
  folgen"*. Wird für das Paket neu übersetzt, trägt es eine andere
  Bau-Kennung als der geprüfte Bau `82372232` (Lehre *Paket gegen den Bau
  messen*).

**Was zu tun wäre:** in `pruefbericht.pl` den Verweis auf
`#ergebnis-7-2-0-123` (bzw. allgemein auf die Ergebnistabelle des Pakets);
die schmutzigen Dateien namentlich ausgeben; beim Schnüren in `PAKETE.md`
festhalten, dass `Eudora.exe` im Paket der geprüfte Bau ist.

---

## Geprüft, kein Fund

* **N1 Tastatur** (belegt): `EudoraRes.rc:322` *„"L", ID_WINDOW_NICKNAMES,
  VIRTKEY, CONTROL"*, Menü `:5819` *„&Address Book\tCtrl+L"*. *„ein zweites
  Strg+W schließt `In`"* deckt sich mit `BEFUNDE.md:391` (*„danach bekommt das
  aktive Fenster den Schwerpunkt"*) und `CHANGELOG.md:109-110`.
* **N3 Hinweistext** (belegt): wörtlich wie `EudoraRes.rc:7809`
  (`IDS_WARN_IMAP_DRAFT_TO_OUT`); *No* → `E142Abgebrochen`, `break`, keine
  Nachbearbeitung (`tocdoc.cpp:2795-2801`, `:3166`) — *„nichts passiert"*
  stimmt.
* **N4** (belegt): *Entwürfe*, *Gelöscht* — Prüfstandsfälle `E-77b`/`c`
  (`PRUEFBERICHT.md`, *„server="Entw&APw-rfe""*, *„server="Gel&APY-scht""*).
* **K2 und die Protokollzeile** gegen `eudora.cpp:2016`, `:2028`, `:2070`: die
  Texte `Ausnahme in Fensterbotschaft` und `Ausnahme ausserhalb einer
  Fensterbotschaft` stehen so im Code; die Positivprobe
  (`rootcerts.p7b geladen aus:`) entspricht `ZIEL.md:195`.
* **M3** gegen `tocdoc.cpp:2752-2771`: Schritt 1-3 und die Gegenprobe 4a-4d mit
  dem **lokalen** `Trash` stimmen; der Satz zu N3 (`:691`) ist richtig.
* **CHANGELOG-Abschnitt 7.2.0.123** gegen die Befunde: Testzahlen je Punkt
  sind die zum jeweiligen Einbau (302 … 307), der Prüfbericht nennt 308 am
  Bau `82372232` (`PRUEFBERICHT.md:23`) — kein Widerspruch, jede Zahl trägt
  ihren Zeitpunkt. [E-146](../Intern/BEFUNDE.md#e-146) *„Lehnt der Server das Umbenennen ab, liest Eudora
  danach die Ordnerliste neu"* gegen `BEFUNDE.md:385` (K9, rot/grün) richtig.
* **`ZIEL.md` neue Zeilen** [E-150](../Intern/BEFUNDE.md#e-150) (`:71`), [E-148](../Intern/BEFUNDE.md#e-148) (`:72`), [E-146](../Intern/BEFUNDE.md#e-146) (`:73`) und die
  Entscheidungszeile (`:74`) gegen die Befunde und die README-Tabelle: alle
  zehn genannten Punkte stehen unter *Bekannte Fehler* (gemessen: je Kennung
  in `README.md:150-191` vorhanden).
* **`Intern/AUFGABEN.md:3`** gegen [L-69.4](LEKTOR-69.md#l-69.4): [E-137](../Intern/BEFUNDE.md#e-137) jetzt unter *„auf `main` bis PR #175"*,
  richtig.
* **`Releases/PRUEFBERICHT.md`**: 308/19/35 am Bau `82372232`,
  *„0 an anderem Bau, 0 nie gelaufen"* (`:23-25`); `ZIEL24b` ist jetzt gelaufen
  (`:444`).

## Nicht geprüft

* `Doku/ANWENDER.md` ([L-61.8](LEKTOR-61.md#l-61.8)) und die Archivdateien aus der `doku-pruefen.pl`-Liste.
* Ob Gregors Mailverzeichnis eine eigene `rootcerts.p7b` hat und welchen
  `LogLevel` seine `Eudora.ini` heute trägt — seine Verzeichnisse lese ich
  nicht ([L-70.7](#l-70.7)).
* Der Inhalt von `Releases/pruefbericht-tests.tsv` und `Intern/pruefstand-buch.tsv`
  Zeile für Zeile.

## Was nur Gregor entscheiden kann

Keine neue Produkt- oder Release-Frage. Alle Funde oben sind Berichtigungen
an Text und Anleitung, die der Hauptagent ohne Entscheidung vornehmen kann.
Eine Frage berührt Gregors Ablauf und wird beim Übergeben des Pakets ohnehin
gestellt: **mit welchen Daten testet er 7.2.0.123** — einer Kopie des
Mailverzeichnisses aus 1.0.122 oder einer anderen Sicherung
([L-70.7](#l-70.7))?
