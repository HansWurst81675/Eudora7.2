# <a id="lektor-56"></a>LEKTOR-56 — Bestandsprüfung nach PR #168 und #169 (E-77 Umbenennen, Regressionstests, Gregors Entscheidungen vom 24.10.2026), 24.10.2026

**Auftrag.** Nach [LEKTOR-55](LEKTOR-55.md#lektor-55) kamen PR #166, #167
(Regressionstests Block 1d, 2a), #168 ([E-77](../Intern/BEFUNDE.md#e-77)
Umbenennen, [PRÜFER-49](PRUEFER-49.md#pruefer-49) eingetragen,
[E-145](../Intern/BEFUNDE.md#e-145) neu) und #169 (Regressionstests Block 2b,
2c, Gregors Entscheidungen) auf `main`, `git log 0ec43545..c297097f`.
Geprüft wurde **der Bestand**, nicht der Diff: alle 60 `.md` aus
`git ls-files '*.md'` ohne `Arbeitsweise/` und `Befunde/`. Maßstab von außen:
`Eudora71/Version.h` (`7.2.0.122`), `VERSION` (`1.0.122`), `git tag`
(zuletzt `v1.0.120`), `Releases/PAKETE.md`, `Intern/BEFUNDE.md`, `git log`,
und Gregors fünf Entscheidungen vom 24.10.2026 in
`Intern/WEITERMACHEN.md:140`.

**Ergebnis vorweg.** Was [LEKTOR-55](LEKTOR-55.md#l-55.10) als Folge
vorhergesagt hat, ist eingetreten. [E-116](../Intern/BEFUNDE.md#e-116) ist
geschlossen, und `ZIEL.md` meldet jetzt *„**Alle Zeilen des Maßstabs sind
erfüllt.**"* Zwei der neun Kriterien heißen in derselben Datei weiter *„fast"*,
und vier der als erfüllt gezählten Behebungen stecken in keinem Paket
([L-56.1](#l-56.1)). Gregors Entscheidung zu [E-142](../Intern/BEFUNDE.md#e-142)
(Hinweis statt Behebung) steht nur angehängt am Ende der Befundzeile. Urteil,
Kurzsatz und die beiden erzeugten Listen verlangen weiter, die Ursache zu
messen und zu beheben, und der Kurzsatz sagt *„Verloren geht nichts"*
([L-56.2](#l-56.2)). Die Lücken, die [PRÜFER-49](PRUEFER-49.md#pruefer-49) in
[E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113) und [E-119](../Intern/BEFUNDE.md#e-119) gefunden hat, stehen in keiner Liste
([L-56.6](#l-56.6)). Eine davon tritt mit dem Paket 7.2.0.123 erst auf:
gespeicherte Nachrichten mit Ablage in einen IMAP-Ordner mit Umlaut legen
ihre Kopie ohne Meldung nicht mehr ab.
**`Releases/PRUEFBERICHT.md` gilt für keinen Paketstand.** Die Datei nennt
ein Paket 1.0.121, das nie geschnürt wurde. Seit dem 23.10.2026 um 08:00 hat
niemand sie neu geschrieben, weil kein Werkzeug den Erzeuger aufruft. Welche
Tests gelaufen sind, zeigt sie nicht, nur Zahlen ([L-56.7](#l-56.7)).

**Stand der 19 Funde aus [LEKTOR-55](LEKTOR-55.md#lektor-55):** 2 erledigt, 4 teilweise, 13 offen
(Teil 1). **10 neue Funde**: 2 falsch, 1 Widerspruch, 3 veraltet,
4 unvollständig. **Eine Frage an Gregor**, am Ende.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt** (Zitat
mit Datei:Zeile), **Vermutung**.

---

## Mechanisch zuerst

Die Ausgaben, gemessen am 24.10.2026 gegen 23:15 in diesem Arbeitsbaum
(`c297097f`). Übernommen sind sie nicht als Urteil, siehe [L-56.1](#l-56.1).

| Werkzeug | Ausgabe | was sie nicht sagt |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„Kein Widerspruch gefunden."*, 46 geprüfte Dateien, 14 Hinweise, darunter *„Releases/PRUEFBERICHT.md nennt weder den Quellstand 7.2.0.122 noch die Paketnummer 1.0.122 (hoechste genannte Fassung: 7.2.0.121)"* | der Hinweis ist der Kern von [L-56.7](#l-56.7) und weist nicht ab |
| `perl tools/offene-befunde.pl` | *„offen laut Intern/BEFUNDE.md 37 … davon NIE gemessen 10 … 37 offene Befunde, in beiden Listen gleich."* | die sechs Lücken aus PRÜFER-49 zählen nicht mit ([L-56.6](#l-56.6)); zwei der „nie gemessen" hat Gregor gemessen ([L-55.16](LEKTOR-55.md#l-55.16)) |
| `perl tools/pruefe-regressionstest.pl` | 200 Befunde, 64 mit Testfall, 2 manuell, 70 behoben ohne Testfall; kritisch 67, davon 39 mit Testfall, **26 ohne jede Prüfung**; *„Kein neues "behoben" ohne Regressionstest."* | — |
| `perl tools/ziel-stand.pl` | *„19 von 19 erfüllt, 0 offen - ZIEL.md ist auf dem Stand."* | dass „erfüllt" hier „kein offener Befund" heißt ([L-56.1](#l-56.1)) |
| `perl tools/pruefe-befundurteile.pl` | *„Kein Dokument erklaert einen offenen Befund fuer erledigt - und keinen behobenen fuer unerledigt."* | `Doku/ANWENDER.md:32` und `:42` nennen [E-77](../Intern/BEFUNDE.md#e-77) und [E-119](../Intern/BEFUNDE.md#e-119) *offen* ([L-55.7](LEKTOR-55.md#l-55.7), unverändert) |

---

## <a id="teil-1"></a>Teil 1 — Die 19 Funde aus LEKTOR-55, Stand heute

| Fund | worum es ging | heute | Beleg |
|---|---|---|---|
| [L-55.1](LEKTOR-55.md#l-55.1) | [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119) stehen „auf dem Zweig", dahinter „Was noch fehlt: die Behebung" | **offen** | `Intern/BEFUNDE.md:324` *„behoben auf dem Zweig `e-77-imap-ordnernamen`"*, weiter hinten *„**Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — unverändert offen … **Was noch fehlt:** die Behebung"*; `:359` *„**Was noch fehlt:** alles"*; `:365` *„**Was noch fehlt:** der Einbau"*. Der Nachtrag vom Abend zu [E-77](../Intern/BEFUNDE.md#e-77) wurde vorn angehängt, der Schwanz blieb |
| [L-55.2](LEKTOR-55.md#l-55.2) | [E-116](../Intern/BEFUNDE.md#e-116): „es fehlt eine Prüfnachricht" gegen die Messung damit | **teilweise.** Im Befund erledigt (Urteil mit Gregors Vermerk, der Satz ist weg). Der CHANGELOG sagt weiter *eingebaut* → [L-56.3](#l-56.3) | `Intern/BEFUNDE.md:362`; `CHANGELOG.md:107-109` |
| [L-55.3](LEKTOR-55.md#l-55.3) | „Gemergt am 23.10.2026 (PR #157 und #158)" | **offen**, jetzt sind es acht PRs | `CHANGELOG.md:98` |
| [L-55.4](LEKTOR-55.md#l-55.4) | Einstieg, Aufgaben, Portierung nennen zwei der fünf Behebungen | **offen**, dazu PR #168 | `Intern/WEITERMACHEN.md:9` (Quellstand ohne [E-77](../Intern/BEFUNDE.md#e-77)/[E-113](../Intern/BEFUNDE.md#e-113)/[E-119](../Intern/BEFUNDE.md#e-119)/[E-116](../Intern/BEFUNDE.md#e-116)/[E-130](../Intern/BEFUNDE.md#e-130)), `:132` *„auf `main` stecken aber schon [E-116](../Intern/BEFUNDE.md#e-116) und [E-130](../Intern/BEFUNDE.md#e-130)"*, `:135-137` Schritt 1 und 2 ohne Haken; `Intern/AUFGABEN.md:3` *„mit diesem Zweig [E-119](../Intern/BEFUNDE.md#e-119)"*, `:100`, `:414`, `:416`; `Intern/PORTIERUNG.md:44` *„Stand 23.10.2026"* |
| [L-55.5](LEKTOR-55.md#l-55.5) | ZIEL.md zählt [E-77](../Intern/BEFUNDE.md#e-77) oben erfüllt, unten fehlend | **offen** | `ZIEL.md:167` (Zeile 2a) und `:175-178` nennen [E-77](../Intern/BEFUNDE.md#e-77) als das, was Kriterium 2 fehlt; `:43-46` tragen keinen Stand |
| [L-55.6](LEKTOR-55.md#l-55.6) | „Bekannte Fehler" in drei Anwenderdateien | **offen** | `README.md:158`, `:159`, `:161`; `Doku/ANWENDER.md:32`, `:42`; `Intern/EINSTELLUNGEN.md:221` |
| [L-55.7](LEKTOR-55.md#l-55.7) | `pruefe-befundurteile.pl` sieht „([E-77](../Intern/BEFUNDE.md#e-77), offen)" nicht | **offen** (gemessen: grün, siehe oben; letzte Änderung am Werkzeug `d98144ef`, vor [LEKTOR-55](LEKTOR-55.md#lektor-55)) | `tools/pruefe-befundurteile.pl` |
| [L-55.8](LEKTOR-55.md#l-55.8) | Variante B von [E-113](../Intern/BEFUNDE.md#e-113) fällt aus jeder Liste | **erledigt durch Entscheidung**: *„paßt so"*, Regressionsfall `E-113b`/`E-113b2`. Reste → [L-56.4](#l-56.4) | `Intern/BEFUNDE.md:359`; `tools/pruefstand-faelle.txt:197-198` |
| [L-55.9](LEKTOR-55.md#l-55.9) | [E-130](../Intern/BEFUNDE.md#e-130) behoben, Zelle sagt „Offen: wer stempelt" | **offen** | `Intern/BEFUNDE.md:376`: *„**Offen:** wer stempelt, und welche der beiden Fassungen gilt."*; *„Stufe: kritisch** (Paket: ausgeliefert wird etwas anderes als im Bau steht)"*; Spalte 2 weiter *„Fünf vorgebaute Fremd-DLLs"* |
| [L-55.10](LEKTOR-55.md#l-55.10) | „erfüllt" heißt „kein offener Befund" | **offen, und eingetreten** → [L-56.1](#l-56.1) | `ZIEL.md:20`, `:26`; `tools/ziel-stand.pl` |
| [L-55.11](LEKTOR-55.md#l-55.11) | [E-116](../Intern/BEFUNDE.md#e-116) kann niemand schließen | **erledigt** (Entscheidung 2) | `Intern/BEFUNDE.md:362` *„so geschlossen auf Gregors Entscheidung vom 24.10.2026"* |
| [L-55.12](LEKTOR-55.md#l-55.12) | kein Testplan für 7.2.0.123 | **teilweise.** Die Abnahme der neun Kriterien gehört nach Entscheidung 4 nicht in diese Sitzung. Einen Plan für die Sitzung am Paket 7.2.0.123 gibt es trotzdem nicht, obwohl Gregor *„mehrere sachen zusammen testen"* will | `Intern/TESTPLAN.md:1` *„Quellstand 7.2.0.122 / `VERSION` 1.0.122"*, `:8` *„**Im Moment nichts.**"*; `Intern/WEITERMACHEN.md:140` |
| [L-55.13](LEKTOR-55.md#l-55.13) | vier „Wie zu prüfen" mehrdeutig | **offen** | `Intern/BEFUNDE.md:381` ([E-144](../Intern/BEFUNDE.md#e-144), der Antwortentwurf verliert seinen Gesprächsfaden) weiter *„nach `Trash` und zurück nach `Out`"*, ohne zu sagen welches `Trash`; `:378` ([E-142](../Intern/BEFUNDE.md#e-142)) unverändert; `:324` verlangt weiter *„Einen Ordner `Entwürfe` anlegen"* am Prüfserver, der `CREATE` nicht kennt; `:359` → [L-56.4](#l-56.4) |
| [L-55.14](LEKTOR-55.md#l-55.14) | „Was bekannt ist" im Testplan | **offen** | `Intern/TESTPLAN.md:226-235` (grauer Kasten, breite Bilder, `35px`; [E-142](../Intern/BEFUNDE.md#e-142) und [E-144](../Intern/BEFUNDE.md#e-144) fehlen); `:251` *„277 Tests"* |
| [L-55.15](LEKTOR-55.md#l-55.15) | „Für Gregor nichts zu tun" bei [E-77](../Intern/BEFUNDE.md#e-77), [E-119](../Intern/BEFUNDE.md#e-119); PRÜFER fehlte | **teilweise.** PRÜFER ist gelaufen (PRÜFER-49), Umbenennen ist am Prüfstand gemessen (`E-77d`). Weiter ungemessen: Anlegen ([E-77](../Intern/BEFUNDE.md#e-77)) und Senden einer Weiterleitung mit `data:`-Bild ([E-119](../Intern/BEFUNDE.md#e-119)); die Zellen sagen weiter *„Für Gregor ist nichts zu tun"* | `Intern/BEFUNDE.md:324` *„**Nicht am Programm gemessen:** Anlegen eines Ordners mit Umlaut"*; `:365` *„Ebenfalls nicht gemessen: was beim **Senden** … geschieht"* |
| [L-55.16](LEKTOR-55.md#l-55.16) | [E-142](../Intern/BEFUNDE.md#e-142), [E-144](../Intern/BEFUNDE.md#e-144) „nie gemessen", obwohl Gregor gemessen hat | **offen** (gemessen: keine Marke `**Zuletzt gemessen:` in beiden Zeilen) | `CHANGELOG.md:28`, `:30`; `Intern/WEITERMACHEN.md:350`, `:352` |
| [L-55.17](LEKTOR-55.md#l-55.17) | [E-142](../Intern/BEFUNDE.md#e-142): „Verloren geht nichts" | **offen, jetzt gegen Gregors Entscheidung** → [L-56.2](#l-56.2) | `Intern/BEFUNDE.md:378` |
| [L-55.18](LEKTOR-55.md#l-55.18) | Release-Notizen nennen den Rückstand nicht | **offen** (gemessen: `git grep -n -i "Rückstand\|Rueckstand" -- CHANGELOG.md tools/release-veroeffentlichen.ps1` → nichts). `ZIEL.md:67` *„50 von 67"*, heute 26; die Tabelle `:93-98` *„Stand am 22.10.2026"* 186/29/0/97, heute 200/64/2/70 | `ZIEL.md:64-70`, `:93-98` |
| [L-55.19](LEKTOR-55.md#l-55.19) | getestet würde ein anderer Bau als veröffentlicht | **teilweise.** Die Nummer ist entschieden: *„7.2.1.<Buildnummer zum Zeitpunkt des Baus>"*. Dass die Abnahme an genau diesem Bau stattfindet, steht nirgends → [L-56.5](#l-56.5). Der Name der Marke auf GitHub ist weiter offen | `Intern/WEITERMACHEN.md:140`, `:144` |

---

## Teil 2 — Gregors Entscheidungen vom 24.10.2026 gegen den Bestand

### <a id="l-56.1"></a>L-56.1 — der Maßstab meldet „Alle Zeilen des Maßstabs sind erfüllt"; Gregors Abnahme hat nicht stattgefunden, zwei Kriterien heißen „fast"

**Gewicht: falsch (erzeugter Text, der Leser hält es für das Urteil).** `ZIEL.md:20`, `:26`; dagegen `:16`, `:57-58`, `:142`, `:166`, `:169`, `:175`

Worum es geht: Am Kopf des Maßstabs für 7.2.1 steht erzeugt:

> `ZIEL.md:20`: *„**Stand: 19 von 19 erfüllt, 0 offen.**"*
> `ZIEL.md:26`: *„**Alle Zeilen des Maßstabs sind erfüllt.**"*

**Gemessen:** `perl tools/ziel-stand.pl` → *„19 von 19 erfüllt, 0 offen"*. Die
Zahl ist richtig gerechnet. Sie zählt aber nur, dass keine Zeile einen
offenen Befund trägt. [LEKTOR-55](LEKTOR-55.md#l-55.10) hat genau diesen Satz
für den Tag vorhergesagt, an dem [E-116](../Intern/BEFUNDE.md#e-116) geschlossen wird. Gregor hat das
Schließen am 24.10.2026 entschieden (Entscheidung 2), und seither steht der
Satz da.

**Was dieselbe Datei sagt (belegt):**

* `:16`: *„Maßstab sind alle neun Kriterien unten, und zwar **erfüllt**, nicht „fast“."*
* `:166` Kriterium 2: *„**fast.**"*; `:169` Kriterium 4: *„**fast**"*; `:175`:
  *„zwei sind fast erfüllt (2, 4)"*.
* `:142`: Die Kriterientabelle hat den Stand *„Quellstand **7.2.0.120**"*.
  Ihre Urteile stammen laut `:57` von 7.2.0.55.
* `:57-58`: *„**Vor dem Release:** die Tabelle der Kriterien neu messen …,
  dann Gregors Test aller neun Kriterien an einem frischen Paket, erst danach
  die Marke."* Gregor am 24.10.2026: Die Sitzung an 7.2.0.123 ist *„noch
  nicht"* die Abnahme (`Intern/WEITERMACHEN.md:140`, Entscheidung 4).
* Vier der 19 Zeilen (`:43-46`: [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119), [E-116](../Intern/BEFUNDE.md#e-116)) zählen als
  erfüllt, stecken aber in keinem Paket (`VERSION` = 1.0.122,
  `Releases/PAKETE.md:159`).

**Was ein Leser daraus macht (Vermutung):** Wer `README.md:75` folgt (*„was
zur Fassung 7.2.1 noch fehlt, ganz oben, erzeugt"*), liest *„alle erfüllt"* und
hält 7.2.1 für fertig.

**Vorschlag:** wie [L-55.10](LEKTOR-55.md#l-55.10), jetzt dringend. Den
Schlusssatz in `ziel-stand.pl` nicht mehr auf *„alle erfüllt"* setzen, solange
im Maßstab zwei Zeilen ohne Marke stehen: *„Kriterientabelle neu gemessen
(Quellstand …)"* und *„Gregors Abnahme der neun Kriterien an Paket 7.2.1.<n>"*.
Die Zählzeile ehrlich benennen: *„19 von 19 ohne offenen Befund; Abnahme
ausstehend"*. Schranke gegentesten: mit den zwei neuen Zeilen ohne Marke muss
das Werkzeug *offen* melden, mit Marke *erfüllt*.

### <a id="l-56.2"></a>L-56.2 — E-142: Gregor hat „Hinweis statt Behebung" entschieden; Urteil, Kurzsatz und beide erzeugten Listen sagen weiter „messen, dann beheben"

**Gewicht: Widerspruch.** `Intern/BEFUNDE.md:378`; erzeugt daraus `CHANGELOG.md:30`, `Intern/WEITERMACHEN.md:352`; dazu `Intern/WEITERMACHEN.md:134-138`, `README.md:164`, `Intern/TESTPLAN.md:224-236`

Worum es geht: Wer einen Entwurf aus einem IMAP-Ordner nach `Out` zieht,
bekommt in `Out` eine **leere** Nachricht. Das Original bleibt im IMAP-Ordner.
Wer es dort löscht, weil er es für verschoben hält, verliert den Entwurf.
Gregor hat am 24.10.2026 entschieden (Entscheidung 5): ein **Hinweis**, dass
bei dieser Aktion Inhalt verloren gehen kann, und keine Behebung der leeren
Kopie.

Am Ende der Zelle steht das richtig (belegt):

> `:378`, Schluss: *„**Vereinbart — Gregor am 24.10.2026:** … Zu bauen ist also ein **Hinweis** … — keine Behebung der leeren Kopie."*

Davor, in derselben Zelle, steht noch (belegt):

> Urteil vorn: *„**offen, von Gregor am 23.10.2026 am laufenden Programm bestätigt (Paket 1.0.122).**"*
> Kurzsatz: *„**Verloren geht nichts, das Original bleibt im IMAP-Ordner. Die Behebung fehlt noch.**"*
> *„**Was noch fehlt:** die Ursache der leeren Kopie messen (Spurmarke beim Lesen der IMAP-Quelle, Vorschlag in PRÜFER-48), dann beheben."*
> *„Zweitens die Frage, ob ein Entwurf … **verschwinden** soll … Ohne diese Entscheidung ist nichts zu bauen."*

Der Satz *„Was noch fehlt"* geht über das Werkzeug wortgleich in
`CHANGELOG.md:30` und `Intern/WEITERMACHEN.md:352` (gemessen: beide Zeilen
beginnen mit *„die Ursache der leeren Kopie messen"*). Die Liste sagt also
das Gegenteil der Entscheidung.

**Dazu, belegt:**

* Der Hinweis steht in keiner Arbeitsliste. Die Reihenfolge
  `Intern/WEITERMACHEN.md:134-138` nennt [E-142](../Intern/BEFUNDE.md#e-142) nur unter Schritt 4,
  *„am Prüfstand rot und grün nachstellen"*. `Intern/AUFGABEN.md` nennt
  [E-142](../Intern/BEFUNDE.md#e-142) gar nicht (gemessen: `grep -c E-142` → 0).
* `README.md:164` (Bekannte Fehler): *„eine Nachricht aus einem IMAP-Ordner
  nach `Out` gezogen … **Ab Paket 1.0.122** lehnt Eudora das Ziehen mit einem
  Hinweis ab"*. Das gilt nur für **empfangene** Nachrichten
  (`BEFUNDE.md:378`: *„Die Ablehnung aus [E-125](../Intern/BEFUNDE.md#e-125) greift bewusst nur für
  **empfangene** Nachrichten"*). Ein Entwurf wird nicht abgelehnt und ergibt
  die leere Nachricht. Die README nennt [E-142](../Intern/BEFUNDE.md#e-142) nirgends (gemessen:
  `grep -n "E-142" README.md` → nichts), ebensowenig
  `Intern/TESTPLAN.md:224-236`, *Was bekannt ist*. Das ist der einzige offene
  Fall, in dem nach Gregors eigener Entscheidung Inhalt verloren gehen kann.

**Vorschlag:** Urteil vorn: *„offen; vereinbart ist ein Hinweis beim Ziehen
(Gregor 24.10.2026), keine Behebung der leeren Kopie; der Hinweis ist noch
nicht gebaut."* Kurzsatz: *„Sofort verloren geht nichts. Wer das Original im
IMAP-Ordner löscht, weil er es für verschoben hält, verliert den Entwurf."*
*Was noch fehlt*: *„der Hinweis beim Ziehen eines Entwurfs aus einem
IMAP-Ordner nach `Out`, mit Regressionsfall"*. Den alten Satz mit *Ohne diese
Entscheidung* als *„Bis 24.10.2026 stand hier …"* kennzeichnen. Den Hinweis in
die Reihenfolge `WEITERMACHEN.md:134-138` aufnehmen. In `README.md` eine
eigene Zeile *Bekannte Fehler* für Entwürfe aus IMAP-Ordnern, und in
`README.md:164` *„eine **empfangene** Nachricht"*.

### <a id="l-56.3"></a>L-56.3 — E-116 ist geschlossen; vier Stellen nennen es weiter „eingebaut" oder als bekannten Fehler, und sein Prüfschritt prüft nichts

**Gewicht: veraltet.** `CHANGELOG.md:107-109`; `Intern/AUFGABEN.md:414`; `Testdaten/README.md:40`; `README.md:159`; `Intern/BEFUNDE.md:362` (Schwanz)

Worum es geht: Ein Bild mit `width="35px"` wurde früher riesig breit
gezeichnet. Gregor hat am 24.10.2026 entschieden, dass der Befund mit dem
Vermerk *„am Programm nicht nachstellbar"* geschlossen wird. Das Urteil in
`BEFUNDE.md:362` sagt das richtig. An vier anderen Stellen steht noch der alte
Stand (belegt):

> `CHANGELOG.md:107-109`: *„**Am laufenden Programm noch nicht gesehen** — deshalb im Befund „eingebaut", nicht „behoben"."*
> `Intern/AUFGABEN.md:414`: *„**eingebaut** (PR #157, 23.10.2026, Testsuite 280/280); offen ist nur die Messung am laufenden Programm"*
> `Testdaten/README.md:40`: *„**[E-116](../Intern/BEFUNDE.md#e-116)** (eingebaut 23.10.2026, PR #157)"*
> `README.md:159` (Bekannte Fehler): *„Größenangaben wie `35px` können ein Bild verzerren"*

In der Zelle selbst, hinter dem neuen Urteil, steht noch:

> *„**Wie zu pruefen:** **ICH** — Prüfnachricht mit `width="35px"` … öffnen; das Bild muss 35 Pixel breit sein"*
> *„**Zuletzt belegt am Quelltext: 23.10.2026 an 7.2.0.122** — Behebung auf dem Zweig `e-116-bildbreite-px`"*

Der Prüfschritt ist laut derselben Zelle auch an der **alten** Fassung grün
(*„die alte 7.2.0.120 aber genauso"*). Er kann einen Rückfall nicht finden
([Gegenprobe umdrehen](../Arbeitsweise/gegenprobe-umdrehen.md)). Der Beleg
ist die Testsuite.

**Vorschlag:** CHANGELOG: *„Am laufenden Programm nicht nachstellbar: auf
den gemessenen Wegen war der Fehler auch vorher nicht zu sehen. Belegt durch
Testsuite mit Gegenprobe und PRÜFER-48; so geschlossen auf Gregors
Entscheidung."* `AUFGABEN.md:414` und `Testdaten/README.md:40` auf *behoben*.
In `README.md:159` den E-116-Teil streichen. *Wie zu prüfen*:
*„`TestE116.cpp`; am Programm nicht nachstellbar."*

### <a id="l-56.4"></a>L-56.4 — E-113 Variante B ist entschieden („paßt so"), die Zelle verlangt aber weiter, das Fenster zu ziehen, und „Was noch fehlt: alles"

**Gewicht: unvollständig.** `Intern/BEFUNDE.md:359`; `CHANGELOG.md:132-134`; `Intern/AUFGABEN.md:100-104`

Worum es geht: Ein zu breites Bild wird jetzt beim Laden eingepasst
(Variante A). Wird das Fenster danach schmaler gezogen, passt es sich nicht
an (Variante B). Gregor am 24.10.2026: *„paßt so."* Dazu gibt es die
Regressionsfälle `E-113b`/`E-113b2`. Sie halten fest, dass Eudora dabei lebt
und das Bild **nicht** neu berechnet.

Vorn in `:359` steht das richtig. Weiter hinten (belegt):

> *„**Was noch fehlt:** alles — von Gregor angeordnet …"*
> *„**Wie zu pruefen:** … Grün: es ist auf die Fensterbreite eingepasst. Danach Fenstergröße ändern und noch einmal sehen."*

Was man nach dem Ziehen sehen soll, sagt der letzte Satz nicht. Wer *„Grün:
eingepasst"* auch dort erwartet, meldet das vereinbarte Verhalten als Fehler.
`CHANGELOG.md:133`: *„(Variante B, nicht gebaut)"*. Dass B auch nicht gebaut
**wird** und dass ein Regressionsfall es festhält, steht dort nicht.
`Intern/AUFGABEN.md:100`: *„**Weiter offen: [E-113](../Intern/BEFUNDE.md#e-113)** … Auf Gregors Anordnung
„erst A, dann B" getrennt gehalten."*

**Vorschlag:** Den Schwanz von `:359` als *„Bis 24.10.2026 stand hier …"*
kennzeichnen. *Wie zu prüfen*: *„`E-113p` (eingepasst), `E-113b`/`b2`
(Fenster schmaler ziehen: das Bild bleibt, wie es ist; so vereinbart)"*.
CHANGELOG: *„… wird nicht gebaut (Gregor: „paßt so."); Regressionsfall
`E-113b` hält das fest."* `AUFGABEN.md:100-104` auf erledigt setzen.

### <a id="l-56.5"></a>L-56.5 — „Vor dem Release" in ZIEL.md trägt Entscheidung 1 und 4 nicht; dass die Abnahme am Release-Bau selbst stattfindet, steht nirgends

**Gewicht: unvollständig.** `ZIEL.md:57-59`; `Intern/WEITERMACHEN.md:140`, `:144`

> `ZIEL.md:57-59`: *„… dann Gregors Test aller neun Kriterien an einem frischen Paket, erst danach die Marke. Das Release heißt `7.2.1.<laufende Buildnummer>` (Gregor am 23.10.2026: „release wird dann heißen: 7.2.1.123 (bzw. die laufende build nummer …)")"*
> `WEITERMACHEN.md:140`: *„(1) die Releasenummer ist `7.2.1.<Buildnummer zum Zeitpunkt des Baus>` — „könnte auch .130 oder .150 sein …"; … (4) die Sitzung am Paket 7.2.0.123 ist **noch nicht** die Abnahme für 7.2.1"*

`ZIEL.md` ist die Quelle für den Maßstab (`README.md:60`). Dort steht noch das
Beispiel *7.2.1.123*. Entscheidung 4 steht dort nicht. Aus Entscheidung 1 und
den Regeln
[Release erst nach Gregors Test](../Arbeitsweise/release-erst-nach-gregors-test.md)
und [Paket gegen den Bau messen](../Arbeitsweise/paket-gegen-den-bau-messen.md)
folgt (Schluss von mir, kein Zitat): Das Paket für die Abnahme muss schon als
`7.2.1.<n>` gebaut sein, und genau dieses Paket wird veröffentlicht. Das ist
keine neue Frage an Gregor. Es ergibt sich aus Regeln, die er schon gesetzt
hat, und es fehlt nur der Satz.

**Vorschlag:** `ZIEL.md:57-59`: *„Gregors Abnahme der neun Kriterien findet
an einem Paket statt, das schon als `7.2.1.<Buildnummer beim Bau>` gebaut ist;
veröffentlicht wird genau dieses Paket. Die Sitzung an 7.2.0.123 ist noch
nicht die Abnahme (Gregor 24.10.2026)."* Die Frage nach dem Namen der Marke
bleibt (siehe Frage unten).

---

## Teil 3 — Was PRÜFER-49 gefunden hat und wo es steht

### <a id="l-56.6"></a>L-56.6 — sechs Lücken aus PRÜFER-49 stehen nur in Zeilen, die „behoben" heißen; eine davon tritt mit 7.2.0.123 erst auf

**Gewicht: unvollständig (gewichtig).** `Intern/BEFUNDE.md:324`, `:359`, `:365`; `CHANGELOG.md:120-145`; `Befunde/PRUEFER-49.md:588-602`

[PRÜFER-49](PRUEFER-49.md#pruefer-49) hat die drei Behebungen vom 24.10.2026
gegen die Quelle nachgerechnet und elf Funde gemacht. K1 und K2 sind behoben
(PR #168), K11 ist als [E-145](../Intern/BEFUNDE.md#e-145) eingetragen. Die
übrigen stehen als Nebensatz in den Zeilen der behobenen Befunde (belegt):

| Fund | was passiert | Schwere laut PRÜFER-49 | steht in |
|---|---|---|---|
| [K3](PRUEFER-49.md#k3) | eine Nachricht, die **vor 7.2.0.123** mit Ablage (Fcc) in einen IMAP-Ordner mit Umlaut gespeichert wurde, wird gesendet, aber ihre Kopie landet **ohne Meldung** nirgends | mittel | `BEFUNDE.md:324` ([E-77](../Intern/BEFUNDE.md#e-77), behoben) |
| [K5](PRUEFER-49.md#k5) | wird **eine** Nachricht mit einem `data:`-Bild endgültig gelöscht, verlieren alle anderen mit demselben Bild ihre Bilddatei | wichtig (Daten) | `:365` ([E-119](../Intern/BEFUNDE.md#e-119), behoben) |
| [K6](PRUEFER-49.md#k6) | `data:`-Bilder über rund 48 KB kommen abgeschnitten an | mittel | `:365` |
| [K7](PRUEFER-49.md#k7) | ein `<a href="data:image/…">` trägt beim Weiterleiten den lokalen Pfad mit dem Windows-Benutzernamen zum Empfänger | mittel (Datenschutz) | `:365` |
| [K9](PRUEFER-49.md#k9) | bei vollständiger Größenangabe wird nur das Bild verkleinert, nicht sein Rahmen (Muster [E-106](../Intern/BEFUNDE.md#e-106)) | wichtig (Darstellung) | `:359` ([E-113](../Intern/BEFUNDE.md#e-113), behoben) |
| [K10](PRUEFER-49.md#k10) | QuickTime-Weg ohne Deckel; die gedeckelte Größe geht ins gesendete HTML | gering | `:359` |

**Gemessen:** `perl tools/offene-befunde.pl` → 37 offen. Keiner der sechs
erscheint, denn das Werkzeug liest nur das Urteil vorn, und das heißt
*behoben*. `git grep -n "PRUEFER-49.md#k[3567]\|#k9\|#k10" -- '*.md'
':!Befunde'` findet nur die drei Befundzeilen. Der CHANGELOG-Abschnitt für
das nächste Paket (`CHANGELOG.md:120-127` [E-119](../Intern/BEFUNDE.md#e-119), `:135-145` [E-77](../Intern/BEFUNDE.md#e-77)) nennt keinen
davon. Das ist dieselbe Fehlerklasse wie Variante B in
[L-55.8](LEKTOR-55.md#l-55.8)
([Liste aus einer Quelle](../Arbeitsweise/liste-aus-einer-quelle.md)).

**K3 ist neu durch die Behebung** (belegt, `PRUEFER-49.md:369-387`): Vor
7.2.0.123 hieß der Ordner `Entw&APw-rfe`, und die gespeicherte Nachricht
trägt diesen Namen. Ab 7.2.0.123 heißt er *Entwürfe*, `FindByNamedPath` findet
ihn nicht, und die Ablage entfällt still. Für jemanden, der mit 1.0.122 eine
solche Nachricht in `Out` liegen hat, ist das Paket 7.2.0.123 an dieser Stelle
schlechter ([Erfolg aus Anwendersicht](../Arbeitsweise/erfolg-aus-anwendersicht.md):
Regressionen benennen). PRÜFER-49 schreibt dazu *„nein; im Eintrag nennen"*
(hält das Paket nicht auf). Im Eintrag steht es, im CHANGELOG nicht.

**Beobachtung, Vermutung:** Der Hauptbaum steht auf einem Zweig
`e-119-bild-geteilt`, und unter `C:\Temp\E119K` lief um 23:22:12 ein Start
(gemessen: `perl tools/pruefe-startwege.pl`). Vermutlich wird K5 gerade
behoben. Nicht nachgesehen.

**Vorschlag:** Für K3, K5, K6, K7 und K9 je einen offenen Befund oder eine
offene Zeile mit eigenem Urteil, damit `offene-befunde.pl` sie zählt. Was
behoben wird, bekommt sein *behoben* dort. In den CHANGELOG-Abschnitt je einen
Satz unter [E-77](../Intern/BEFUNDE.md#e-77) und [E-119](../Intern/BEFUNDE.md#e-119), mindestens zu K3 (*„Ältere gespeicherte Nachrichten
mit Ablage in einen Umlaut-Ordner legen ihre Kopie nicht mehr ab"*) und zu K7.
Ob K3 vor dem Paket behoben wird, entscheidet der Hauptagent. Die Behebung ist
laut PRÜFER-49 *„eine Zeile je Suchstelle"*.

---

## Teil 4 — `Releases/PRUEFBERICHT.md`

Gregor fragte dazu: *„version 0.121? wo ist der inhalt? wo sehe ich die
tests? warum nicht schon 0.122?"*

### <a id="l-56.7"></a>L-56.7 — der Prüfbericht nennt ein Paket, das es nie gab, ist seit dem 23.10.2026 um 08:00 nicht neu erzeugt, und zeigt keine Tests, nur Zahlen

**Gewicht: falsch (für keinen Paketstand gültig).** `Releases/PRUEFBERICHT.md:5-9`, `:17-30`, `:48-58`; `tools/pruefbericht.pl`; `Releases/PAKETE.md:177-183`; `README.md:87`; `Intern/TESTPLAN.md:251`

**Was die Datei behauptet** (belegt):

> `:5` *„**Paketfassung** | `1.0.121`"*; `:6` *„**Quellstand** | `7.2.0.121`"*; `:7` *„`0574be0c` (**Arbeitsbaum nicht sauber**: 11 Dateien geaendert)"*; `:8` *„2026-10-23 07:59"*; `:9` *„**BESTANDEN**"*
> `:19` Unit-Tests *„275 | 275 | 0"*; `:23` *„Gefahren am 2026-10-22 20:25:54"*, `:30` *„5 | 5 | 0"*
> `:50-58` *„kritisch | 67"*, davon *„**16** einen automatischen Testfall"*, *„**51** bisher **keine Pruefung**"*

**Gegen den heutigen Stand:**

| Angabe | im Bericht | heute | Beleg |
|---|---|---|---|
| Paket | 1.0.121 | **1.0.121 wurde nie geschnürt**; geschnürt ist 1.0.122 (23.10.2026, ZIP 13:28) | `Releases/PAKETE.md:177-183` *„Nur übersetzt am 22.10.2026, nicht geschnürt … Es gibt kein ZIP und kein Testverzeichnis"*; `:159-170` (belegt) |
| Erzeugt | 23.10.2026 07:59, Commit `0574be0c`, Baum nicht sauber | letzte Änderung der Datei: `c0ac719e`, 23.10.2026 08:00 | gemessen: `git log -- Releases/PRUEFBERICHT.md` |
| Unit-Tests | 275 | 293 laut Commit `65eec1ac` (*„EudoraTests 293 Tests, 293 bestanden"*); `Intern/TESTPLAN.md:251` nennt 277. Drei Zahlen für dieselbe Sache | belegt (Commit-Nachricht), selbst nicht gefahren |
| Oberflächenfälle | 5, vom 22.10.2026 | 25 von 25, gefahren am 24.10.2026 13:01:16; in der Fallliste stehen inzwischen 28 (`E-77d`, `E-113b`, `E-113b2` noch in keinem Lauf) | gemessen: `Intern/pruefstand-ergebnis.txt`, `tools/pruefstand-faelle.txt` |
| kritisch mit Test / ohne | 16 / 51 | 39 / 26 | gemessen: `perl tools/pruefe-regressionstest.pl` |

**„warum nicht schon 0.122?"**, gemessen: `tools/pruefbericht.pl` wird von
**keinem** Werkzeug aufgerufen. `grep -l -i pruefbericht
tools/paket-bereit.pl tools/paket-bauen.ps1 tools/release-veroeffentlichen.ps1`
→ nichts. Der einzige Treffer außerhalb des Werkzeugs selbst ist ein Kommentar
in `tools/pruefstand-lauf.ps1:291`. Das Paket 1.0.122 ist also ohne
Prüfbericht geschnürt worden, und das hat nichts gemeldet.
`doku-pruefen.pl` bemerkt den alten Stand, führt ihn aber nur *„zur
Kenntnis"*. Gregors Anordnung vom 22.10.2026 lautete *„**am ende** schreiben
wir ein reinen report …"* (`tools/pruefbericht.pl:18-19`). Ein Ende hat
keinen Auslöser
([Auslöser an den Anfang](../Arbeitsweise/ausloeser-an-den-anfang.md),
[Werkzeug vor Eigenbau](../Arbeitsweise/werkzeug-vor-eigenbau.md): ein
Werkzeug ohne Aufrufstelle wirkt wie eine Lehre, die nur Text ist).

**„version 0.121?"** (am Quelltext belegt, `tools/pruefbericht.pl:54`): Die
Paketfassung liest das Werkzeug aus `VERSION`, nicht aus einem Paket. Am
Morgen des 23.10.2026 stand dort 1.0.121, die Nummer eines Baus, der nie
geschnürt wurde. Der Bericht sieht also aus wie der Bericht zu einem Paket.
Erzeugt ist er aus dem Arbeitsbaum, und der war laut `:7` nicht sauber.
Welche elf Dateien geändert waren, sagt der Bericht nicht.

**„wo ist der inhalt? wo sehe ich die tests?"** (belegt): Der Bericht hat
vier Abschnitte. Zu den Unit-Tests steht nur eine Zeile mit drei Zahlen
(`:17-19`). Welche Tests es sind und welchen Befund jeder prüft, steht nicht
darin und ist auch nicht verlinkt. Die Tests liegen in
`Eudora71/Tests/Test*.cpp` (gemessen: 31 Dateien). Die Oberflächenfälle
stehen als Kennung mit Suchtext da (`:32-38`), ohne Verweis auf
`tools/pruefstand-faelle.txt` und ohne zu sagen, was ein Fall zeigt. Ob die
manuellen Fälle (Teil M des Testplans) gefahren sind, sagt `:68-69` nicht.
Dort steht nur, dass sie zu fahren sind. Wer wissen will, *was* geprüft ist,
findet in der Datei keinen Weg dorthin.

**Dazu, belegt:** `README.md:87` verlinkt unter *„Berichte der Rollen LEKTOR
und PRÜFER"* die **andere** Datei gleichen Namens, `Intern/PRUEFBERICHT.md`.
Das ist ein abgeschlossener Bericht vom 30.08.2026 (`Intern/PRUEFBERICHT.md:3`).
`Releases/PRUEFBERICHT.md` ist aus `README.md` gar nicht erreichbar
(gemessen: `grep -n "Releases" README.md` → nichts). Zwei Dateien heißen
gleich und meinen zwei verschiedene Dinge. `Intern/TESTPLAN.md:251` verweist
für die Testzahl auf `pruefbericht.pl` (*„sie gehört aus
`tools/pruefbericht.pl` erzeugt"*), und der Bericht zeigt eine dritte Zahl.

**Vorschlag:**
1. Sofort: oben in `Releases/PRUEFBERICHT.md` ein Satz *„Stand 23.10.2026,
   gilt für kein ausgeliefertes Paket (1.0.121 wurde nicht geschnürt); für
   1.0.122 wurde kein Prüfbericht erzeugt."* Ohne das liest jeder ihn als
   aktuell.
2. `pruefbericht.pl` als Schritt in `paket-bauen.ps1` (nach dem Bau, vor dem
   ZIP) und als Tor in `release-veroeffentlichen.ps1`. Abweisen bei
   unsauberem Baum. Die Paketfassung aus dem gebauten Paket lesen, nicht aus
   `VERSION`. Ablage je Paket (`Releases/<n>/PRUEFBERICHT.md`), damit
   *„0.122"* eine eigene Datei hat.
3. Inhalt: je Unit-Test Name und Befundkennung (aus der Ausgabe von
   `EudoraTests.exe`), je Oberflächenfall Kennung, Befund und *was er zeigt*
   (aus `pruefstand-faelle.txt`), Teil M mit Stand *gefahren / nicht
   gefahren*, und Verweise auf die Quellen.
4. `README.md:87` auf `Befunde/PRUEFER-*.md` umstellen und
   `Releases/PRUEFBERICHT.md` als *„Prüfbericht zum Paket"* aufnehmen.

---

## Teil 5 — Übriger Bestand

### <a id="l-56.8"></a>L-56.8 — AUFGABEN.md nennt als Lücke von Kriterium 2 noch E-86 (behoben seit 7.2.0.55) und E-77

**Gewicht: veraltet.** `Intern/AUFGABEN.md:22-28`

> `:24-26`: *„**Kriterium 2 fehlt darüber hinaus** [E-86](../Intern/BEFUNDE.md#e-86) (HTML-Nachrichten falsch dargestellt) und [E-77](../Intern/BEFUNDE.md#e-77) (IMAP-Postfachnamen roh) — beides steht in `ZIEL.md` in der eigenen Zeile **2a**."*

`ZIEL.md:180-187` berichtigt [E-86](../Intern/BEFUNDE.md#e-86) am 22.10.2026 *„an drei Stellen"* (ZIEL.md
zweimal und `PORTIERUNG.md`). Diese vierte Stelle blieb stehen. [E-77](../Intern/BEFUNDE.md#e-77) ist seit
PR #165 behoben ([L-55.5](LEKTOR-55.md#l-55.5)).

**Vorschlag:** den Absatz auf einen Verweis auf `ZIEL.md` kürzen. Wer den
Stand ändert, ändert ihn dort (`ZIEL.md:139-140`).

### <a id="l-56.9"></a>L-56.9 — zwei Prüfnachrichten und sechs Regressionsfälle fehlen in ihren Verzeichnissen

**Gewicht: unvollständig.** `Testdaten/README.md`; `tools/WERKZEUGE.md:134`

**Gemessen:** `ls Testdaten/` enthält `e113-breites-bild.eml` und
`e119-data-bild.eml`. `grep -n "e11[39]" Testdaten/README.md` → nichts. Beide
sind die Prüfnachrichten der Regressionsfälle `E-113p` und `E-119a`–`c`
(`Intern/BEFUNDE.md:359`, `:365`). `tools/WERKZEUGE.md:134` zählt die Fälle von
`messen-bild.ps1` auf (*„`E-103p`, `E-105p`, … `BILD-lauf`"*). `E-113p`,
`E-113b`, `E-113b2` und `E-119a`–`c` stehen dort nicht, obwohl sie dasselbe
Skript fahren (`tools/pruefstand-faelle.txt:186`, `:197-198`, `:203`).

**Vorschlag:** beide Zeilen nachtragen. Die Fallliste in `WERKZEUGE.md:134`
durch einen Verweis auf `pruefstand-faelle.txt` ersetzen, statt sie ein
zweites Mal von Hand zu führen.

### <a id="l-56.10"></a>L-56.10 — README zählt 112 Prüfberichte und 109 Lehren; es sind 124 und 130

**Gewicht: veraltet (Form).** `README.md:93`

> *„Dazu `Befunde/` (112 Prüfberichte), `Arbeitsweise/` (109 Lehren aus Fehlern)"*

**Gemessen:** `git ls-files 'Befunde/*.md' | wc -l` → 124;
`git ls-files 'Arbeitsweise/*.md' | wc -l` → 130. Die Zahlen stammen vom
22.10.2026 (`git log -S"112 Prüfberichte"`).

**Vorschlag:** die Zahlen streichen (*„die Prüfberichte"*, *„die Lehren"*)
oder erzeugen lassen.

---

## <a id="fragen"></a>Was nur Gregor entscheiden kann

1. **Heißt die Marke auf GitHub für das Release `v7.2.1.<n>` oder weiter
   `v1.0.<n>`?** Das ist der Name, unter dem das Release nach außen geht. Die
   Frage steht seit [LEKTOR-54](LEKTOR-54.md#lektor-54) offen
   (`Intern/WEITERMACHEN.md:144`), und `release-veroeffentlichen.ps1` kennt
   bisher nur `v1.0.<n>`.

Nicht hierher gehören, weil Gregor sie übertragen oder schon entschieden hat:
die Einstufung von K3, K5 und K7 ([L-56.6](#l-56.6)), ob K3 vor dem Paket
behoben wird, der Wortlaut des E-142-Hinweises (entschieden ist *„ein
Hinweis"*), und die Form von `Releases/PRUEFBERICHT.md`.

---

## Geprüft und in Ordnung

* **Gregors Entscheidungen** stehen wortgetreu, mit Zitat und Datum, in
  `Intern/WEITERMACHEN.md:140`. [E-116](../Intern/BEFUNDE.md#e-116) (`BEFUNDE.md:362`) und [E-113](../Intern/BEFUNDE.md#e-113)
  (`:359`, vorn) tragen ihre Entscheidung im Urteil.
* **[E-145](../Intern/BEFUNDE.md#e-145)** (`BEFUNDE.md:380`): Urteil vorn,
  drei Sätze ohne Kürzel, Herkunft *PRÜFER-49 K11*, Stufe. Erscheint in beiden
  erzeugten Listen (gemessen).
* **Die erzeugten Listen** *Noch offen*: 37, in `CHANGELOG.md` und
  `WEITERMACHEN.md` gleich (gemessen).
* **`tools/ZWEIGE.md:182-183`**: `fehlende_regression_tests_implementieren`
  und `e-77-umbenennen` mit Gregors Freigabe zum Namen.
* **`tools/TESTLAEUFE.md:366-383`**: die Läufe zu [E-77](../Intern/BEFUNDE.md#e-77) Umbenennen und [E-113](../Intern/BEFUNDE.md#e-113) B
  vom 24.10.2026 stehen mit Freigabe im Protokoll.
* **`git tag`**: zuletzt `v1.0.120`; keine Datei behauptet ein späteres
  Release (gemessen).

## Nicht geprüft

* Die Zahl 293 Unit-Tests: aus der Commit-Nachricht `65eec1ac`, nicht selbst
  gefahren (Auftrag: nichts starten).
* Der Code der Behebungen und von PR #169. Das ist Sache des PRÜFERS.
* Der Zweig `e-119-bild-geteilt` im Hauptbaum (nicht in `tools/ZWEIGE.md`,
  gemessen mit `grep`). Ob Gregor den Namen freigegeben hat, steht vielleicht
  nur im Chat. Den Hauptbaum fasse ich nicht an.
* `Releases/1.0.*/RELEASE-NOTIZEN.md` über die Hinweise von `doku-pruefen.pl`
  hinaus; `Arbeitsweise/` und `Befunde/` (Auftrag).
