# <a id="lektor-44"></a>LEKTOR-44 — die Buchführung nannte ein Paket, das es nicht gibt, und die README einen Fehler, der behoben und veröffentlicht ist

Lauf am 20.10.2026 im Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig `wt/lektor`,
Ausgang `4953e1f1`. Anlass: seit [LEKTOR-43](LEKTOR-43.md#lektor-43) (`1d081b2`,
20.10.2026 nachmittags) sind dazugekommen: **zwei Fassungssprünge**
(7.2.0.113 mit [E-131](../BEFUNDE.md#e-131), **veröffentlicht als `v1.0.113`**,
und 7.2.0.114 mit [E-132](../BEFUNDE.md#e-132), **nicht geschnürt**), der neue
Über-Dialog, die Defender-Meldung an Microsoft ([E-124](../BEFUNDE.md#e-124)),
drei neue Dateien (`Releases/DEFENDER-FEHLALARM.md`,
`Releases/ISSUE-102-ANTWORT.md`, `CHRONIST-2026-10-20b.md`) und
[PRÜFER-40](PRUEFER-40.md).

**Der Maßstab dieses Laufs ist nicht neu, aber er ist schärfer geworden.** Seit
gestern steht ein Text auf GitHub, den Fremde lesen. Seit heute liegt ein
**zweiter** im Repo, der noch abgeschickt werden soll
(`Releases/ISSUE-102-ANTWORT.md`), und ein **dritter** ist bereits bei Microsoft
eingereicht (`Releases/DEFENDER-FEHLALARM.md`). Drei Texte nach außen an einem
Tag; keiner davon lässt sich zurücknehmen.

## Umfang

`git ls-files "*.md"` = **249** verfolgte Dateien, ohne `Arbeitsweise/` **148**,
davon **47** außerhalb von `Befunde/`.

**Maßstab von außen** ([Einigkeit ist kein
Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)) — keine dieser Zahlen
stammt aus einem Dokument des Projekts:

| Quelle | Wert |
|---|---|
| `Eudora71/Version.h` | **7.2.0.114** |
| `VERSION` | **1.0.114** |
| `git tag \| sort -V \| tail -1` | **`v1.0.113`** |
| `gh release list` | `v1.0.113` ist **Latest**, veröffentlicht **20.10.2026, 13:01:36 UTC**; `v1.0.112` am selben Tag **11:55:10 UTC** |
| `gh release view v1.0.113` | Marke `ac094f15` (= Merge von PR **#117**), Anhang `Eudora72-1.0.113-release.zip`, **9 378 205 Byte**, SHA-256 `0d1d4bf4…f4772` |
| `ls Releases/*.zip` | **kein** `Eudora72-1.0.114-release.zip` |
| `ls C:\Users\Gregor\Eudora72-*` | 1.0.110, 1.0.111, 1.0.112, 1.0.113 — **kein 1.0.114** |
| `gh issue view 102` | 7 Beiträge; der letzte von uns (20.10.2026, 17:22:30) **nimmt die Ursachenbehauptung ausdrücklich zurück** |
| Uhr | 20.10.2026 |

* **Alle 148** maschinell durchsucht nach `veröffentlicht ist`, `neueste
  Release`, `zuletzt veröffentlicht`, `als *Latest*`, `1\.0\.11[1234]`,
  `7\.2\.0\.11[1234]`, `E-13[12]`, `Bearfoos`.
* **Die 47 außerhalb von `Befunde/`** zusätzlich auf Stand- und
  Release-Aussagen gelesen; **ganz** gelesen:
  `Releases/ISSUE-102-ANTWORT.md`, `Releases/DEFENDER-FEHLALARM.md`,
  `Releases/1.0.113/RELEASE-NOTIZEN.md` **gegen die veröffentlichte Fassung**,
  `README.md` *Auf einen Blick* und *Bekannte Fehler*, `CHANGELOG.md` *Noch
  offen* und die Abschnitte 7.2.0.113/114, `WEITERMACHEN.md` Kopftabelle,
  `Releases/PAKETE.md` Kopf und die Abschnitte 1.0.111–1.0.114, `TESTPLAN.md`,
  `ZIEL.md`, `AUFGABEN.md:3`, `PORTIERUNG.md`, `tools/RELEASES.md`,
  `tools/ZWEIGE.md`, `LEKTORAT.md`.
* Dazu `Befunde/PRUEFER-40.md` ganz, `Befunde/CHRONIST-2026-10-20b.md` ganz und
  `Befunde/LEKTOR-43.md` ganz.

**Werkzeuge vorher:** `doku-pruefen.pl` kein Widerspruch (9 Hinweise *zur
Kenntnis*), `befunde-verlinken.pl` grün, `commit-bereit.pl` **32 Schranken,
keine weist ab**, `offene-befunde.pl` **ZU VIEL: [E-131](../BEFUNDE.md#e-131)**. **Nachher:** alle
grün, `offene-befunde.pl` 35/35, `doku-pruefen.pl` 9 Hinweise (unverändert,
alle berechtigt — es sind Rückblicke und Fremdverzeichnisse).

> **Was dieser Lauf über die Schranken sagt:** `commit-bereit.pl` meldete vor
> meiner Arbeit **32 von 32 grün**, während `Releases/PAKETE.md` ein Paket
> führte, das es nicht gibt, `WEITERMACHEN.md` die Prüfsumme der falschen
> Fassung trug und die README einen behobenen, veröffentlichten Fehler als
> offen auswies. Die Schranken prüfen, **ob** eine Nummer vorkommt, nicht
> **wem** sie gehört ([L-44.11](#l-44.11)).

---

## Berichtigt

### <a id="l-44.1"></a>L-44.1 — die README sagte dem Anwender von `v1.0.113`, der Fehler sei offen und von uns nie nachgestellt (hoch)

`README.md:82`, Tabelle *Bekannte Fehler*, erste Zeile:

> Läuft **diese Fassung** neben einer vorhandenen Eudora oder Hermes 7.1, kann
> das alte Programm danach nicht mehr starten … unsere Fassung **schreibt**
> `MRUFloatXPos=-2147483648` … von außen gemeldet …; von uns **noch nicht
> nachgestellt**

**Gemessen:** `BEFUNDE.md` und `CHANGELOG.md:195` führen
[E-131](../BEFUNDE.md#e-131) als *„Behoben in 7.2.0.113, am Prüfstand rot und
grün gesehen"*, und genau diese Fassung ist seit **13:01:36 UTC** als
`v1.0.113` draußen. Die Zeile war also in **beiden** Aussagen falsch: der
Fehler ist nachgestellt, und *diese Fassung* schreibt den Wert nicht mehr.

**Warum das keine Schranke gefunden hat:** die Zeile hat sich nicht geändert.
Sie stand seit dem 20.10.2026 früh unverändert da und kam deshalb in keinem
Diff vor ([Review sieht nur den
Diff](../Arbeitsweise/review-sieht-nur-den-diff.md)). `pruefe-befundurteile.pl`
hätte sie fangen können — es liest `README.md` —, aber seine Liste
`@unerledigt` kennt die Wendung *„noch nicht nachgestellt"* nicht; das hat der
CHRONIST heute schon gemessen.

Die neue Zeile sagt drei Dinge, die der Anwender braucht: behoben und seit
`v1.0.113` draußen; eine INI, die den Wert **schon** trägt, wird erst beim
nächsten Sichern berichtigt; und **dass dieser Wert den Absturz verursacht hat,
ist nicht belegt** ([L-44.3](#l-44.3)).

### <a id="l-44.2"></a>L-44.2 — `WEITERMACHEN.md` gab `v1.0.113` die Prüfsumme von `v1.0.112` (hoch)

`WEITERMACHEN.md:45`, *Zuletzt gebaut und veröffentlicht*:

> … als **`v1.0.113`** am 20.10.2026 um 13:01:36 UTC … ZIP
> `Eudora72-1.0.113-release.zip`, SHA-256 **`0406c108…65fd`**

`gh release view v1.0.113` sagt **`0d1d4bf4…f4772`**, 9 378 205 Byte.
`0406c108…` ist die Prüfsumme von **`v1.0.112`**.

**Das ist der Rest von [PRÜFER-40](PRUEFER-40.md#k15) K15**, und er ist
lehrreich: beim Nachziehen wurden Zeitpunkt, Marke und PR berichtigt — die
Prüfsumme blieb stehen. Eine Prüfsumme ist genau das, womit ein Anwender
feststellt, ob er die richtige Datei hat; sie ist die einzige Angabe in der
Zeile, die er nachrechnen kann, und die einzige, die falsch war.

Dazu in derselben Zeile: Gregors Bestätigung zu
[E-123](../BEFUNDE.md#e-123) (6015 ms / 4015 ms) stand **ohne Paketnummer**
unter `v1.0.113`; gemessen hat er an **1.0.111**. Das ist
[L-43.2](LEKTOR-43.md#l-43.2), eine Datei weiter.

### <a id="l-44.3"></a>L-44.3 — drei Dokumente behaupten eine Ursache, die wir gegenüber dem Melder schon zurückgenommen haben (hoch)

Am **20.10.2026 um 17:22:30** steht in
[Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102) unser
eigener Beitrag:

> *„We said the invalid `MRUFloatXPos` was the cause of your crash. On review
> that is too strong: `-2147483648` is `CW_USEDEFAULT`, a value MFC itself sets
> in `CDockContext` and checks again when reading it back … What our
> reproduction proves is that **we write it**, not that it is what crashed
> Hermes."*

Dieselbe Sache steht als [PRÜFER-40](PRUEFER-40.md#k1) **K1** im Repo. **Im
Bestand stand sie nirgends:**

| Stelle | sagte |
|---|---|
| `README.md:82` | *„kann das alte Programm danach nicht mehr starten …: unsere Fassung schreibt `MRUFloatXPos`…"* — Ursache als Tatsache |
| `CHANGELOG.md:195 ff.` | *„Behoben"*, ohne jeden Vorbehalt |
| `Releases/1.0.113/RELEASE-NOTIZEN.md:8` (**veröffentlicht**) | *„**Ursache:** in der gemeinsam benutzten `Eudora.ini` stand `MRUFloatXPos=-2147483648`"* |

Berichtigt in allen dreien: *Unsere Spur* statt *Ursache*, mit dem Satz
**„belegt ist, dass wir sie schreiben — nicht, dass sie den Absturz verursacht
hat"**. Das ist [Ursache nur gemessen
behaupten](../Arbeitsweise/ursache-nur-gemessen-behaupten.md) an genau dem
Dokument, an dem es am teuersten ist.

> **Was ich NICHT getan habe: den veröffentlichten Text auf GitHub
> berichtigen.** Die Datei im Repo ist jetzt richtig; die Release-Beschreibung
> trägt den alten Text weiter. Das ist eine Aussage nach außen und Gregors
> Entscheidung — der Befehl steht unten.

### <a id="l-44.4"></a>L-44.4 — die veröffentlichten Notizen zu `v1.0.113` tragen dieselben drei Schäden, die `v1.0.112` schon hatte (hoch)

`diff` der Datei im Repo gegen `gh release view v1.0.113 --json body`: bis auf
die Leerzeile am Ende **identisch**. Die Schäden stehen also öffentlich. Alle
drei sind von [PRÜFER-40](PRUEFER-40.md#k2) K2 gemessen; keiner war beim Beginn
meines Laufs behoben.

| Stelle | was fehlte | Herkunft |
|---|---|---|
| `:26` | *„Mailverzeichnis im ZIP ist leer – ein vorhandenes `Mailverzeichnis` hineinkopieren."* — der Satz bricht nach *„Das"* ab | **wörtlich [L-43.1](LEKTOR-43.md#l-43.1) Nr. 2**, zum zweiten Mal draußen |
| `:42` | `- **Keine Flut von Fehlermeldungen mehr beim Filtern.** Konnte Eudora eine Nachricht` | **wörtlich [L-43.1](LEKTOR-43.md#l-43.1) Nr. 1**, zum zweiten Mal draußen |
| `:124` | `- **Von Gregor am 20.10.2026 an Paket 1.0.111 am laufenden Programm bestätigt,` | neu, beim Entfernen der unwahren Zuschreibung aus [L-43.2](LEKTOR-43.md#l-43.2) entstanden |

Alle drei aus `Releases/1.0.112/RELEASE-NOTIZEN.md` **wörtlich**
wiederhergestellt (die Datei trägt die am Vortag reparierten Fassungen).

**Das Muster ist der eigentliche Fund.** `0f4b2b1a` legte
`Releases/1.0.113/` aus dem **unreparierten** Text an — in demselben Commit,
dessen Nachricht *„[LEKTOR-43](LEKTOR-43.md#lektor-43) hereingefuehrt (17 Punkte)"* sagt. Eine Reparatur,
die nur in **einer** Datei vorgenommen wird, überlebt das nächste Release
nicht; der nächste Ordner wird aus dem Vorgänger kopiert, nicht aus dem
berichtigten Text.

### <a id="l-44.5"></a>L-44.5 — `Releases/PAKETE.md` führte ein Paket, das es nicht gibt, und hängte 1.0.112 an das falsche Tag (hoch)

Zwei Mängel an derselben Datei, beide in der Buchführung, aus der die nächste
Fassungsnummer gezogen wird.

**Erstens: 1.0.114.** Der Abschnitt hieß *„## 1.0.114 — **geschnürt am
20.10.2026**"* und nannte als Testverzeichnis
`C:\Users\Gregor\Eudora72-1.0.114-release`. **Gemessen:** kein
`Eudora72-1.0.114-release.zip` unter `Releases/`, kein Verzeichnis
`Releases/1.0.114/`, kein Tag `v1.0.114`, und bei Gregor liegen 1.0.110 bis
1.0.113 — **kein 1.0.114**. Ein Abschnitt, der ein Paket beschreibt, das es
nicht gibt, ist eine **Anleitung**, der niemand folgen kann
([L-43.9](LEKTOR-43.md#l-43.9), [L-42.10](LEKTOR-42.md#l-42.10)). Über dem
Abschnitt steht jetzt, was gemessen ist.

**Zweitens: 1.0.112 am falschen Tag.** Der Kopf (`:6`) sagte *„zuletzt
veröffentlicht **1.0.112** als `v1.0.113`"*, und die Überschrift des
Abschnitts 1.0.112 ebenso — während die Zeile *Veröffentlicht* **zwei Zeilen
tiefer im selben Abschnitt** richtig *`v1.0.112`, 11:55:10 UTC* sagt. Der
CHRONIST hatte genau diese Stelle heute auf `origin/main` gemessen und
daneben vermerkt, warum `pruefe-release-buchfuehrung.pl` sie durchlässt: sie
fragt, **ob** `1.0.113` vorkommt, nicht **wem** die Nummer gehört.

Dazu zwei kleinere Dinge in derselben Datei: der Abschnitt **1.0.113** hatte
**keine Defender-Zeile**, obwohl genau dieses Paket zweimal eingezogen und bei
Microsoft eingereicht wurde (vom CHRONIST gemeldet); und die Defender-Zeile im
Abschnitt 1.0.114 zählte anders als [E-124](../BEFUNDE.md#e-124)
([L-44.6](#l-44.6)).

### <a id="l-44.6"></a>L-44.6 — die Messung, mit der wir gegenüber Microsoft argumentieren, stand in keinem Befund (hoch)

`Releases/DEFENDER-FEHLALARM.md:64`, im Text, der **eingereicht ist**:

> *„We have now seen it on three separate builds — 1.0.98 on 2026-10-16,
> **1.0.111** and 1.0.113 on 2026-10-20"*

`Releases/PAKETE.md:166` zählte ebenso *„dritter Fall nach 1.0.98 und
1.0.111"*. **[E-124](../BEFUNDE.md#e-124) kannte den Fall 1.0.111 nicht** —
dort standen nur die beiden Erkennungen vom 16.10. und die beiden vom 20.10.
abends, beide an 1.0.113. Zwei Dokumente waren sich einig, und der Befund
wusste nichts davon ([Einigkeit ist kein
Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)).

**Gemessen, woher die Zahl kommt:** die Commit-Nachricht von `0f4b2b1a`
(20.10.2026, 14:34) nennt *„Eudora.exe 13:09:05 gebaut und sofort geprueft (34
Dateien, 0 Funde), von Defender 13:17:28 erkannt"*. Der Bau von **13:09:05**
ist der, aus dem um **13:13** Paket **1.0.111** geschnürt wurde
([L-43.2](LEKTOR-43.md#l-43.2) hat die Zeitfolge). **Die Behauptung gegenüber
Microsoft ist also belegt** — nur nicht dort, wo das Projekt seine Befunde
führt, und damit für jeden Leser unauffindbar.

Nachgetragen in [E-124](../BEFUNDE.md#e-124) als *dritter Fall*, mit Quelle und
mit dem Vermerk, dass er nachgetragen ist. Die Zählung in `Releases/PAKETE.md`
sagt jetzt, **was** sie zählt (Baue, nicht Erkennungen).

Die Prüfsummen und Größen in `Releases/DEFENDER-FEHLALARM.md` habe ich einzeln
gegengehalten: ZIP 9 378 205 Byte / `0D1D4BF4…`, `Eudora.exe` 3 012 608 Byte /
`6243D4B6…`, Fassung 7.2.0.113, Erkennungsname `Trojan:Win32/Bearfoos.A!ml`,
Signaturstand 1.461.115.0, Vorgang `a567fe2a-…`, eingereicht 20:57:52. **Alle
decken sich mit [E-124](../BEFUNDE.md#e-124) und mit `gh release view`.** Den
eingereichten Text selbst habe ich **nicht** angefasst: er ist abgeschickt,
eine Änderung daran machte aus einem Protokoll eine Fälschung.

### <a id="l-44.7"></a>L-44.7 — `CHANGELOG.md`, `WEITERMACHEN.md` und drei weitere Dokumente standen auf dem vorvorletzten Stand (hoch)

Alles am selben Tag datiert, alles überholt:

| Stelle | stand dort | gemessen |
|---|---|---|
| `CHANGELOG.md:16`, *Noch offen (Stand 20.10.2026)*, **erste Zeile** | [E-131](../BEFUNDE.md#e-131): *„Offen … von uns noch nicht nachgestellt … in `v1.0.112` ausdrücklich nicht angefasst"* | behoben in 7.2.0.113, veröffentlicht. **Zeile entfernt** ([PRÜFER-40](PRUEFER-40.md#k4) K4) |
| `CHANGELOG.md`, dieselbe Tabelle, [E-124](../BEFUNDE.md#e-124) | *„Offen: Fehlalarm zu 1.0.98 bei Microsoft **melden**"* | am 20.10.2026 um 20:57:52 eingereicht. Zeile neu |
| `WEITERMACHEN.md:9`, *Quellstand* | **7.2.0.113**, Zweig `e-131-leistenposition` — und dahinter die Beschreibung von 7.2.0.111/112 (*„die Wache beim Beenden zählt jede Übertragungsart"*) | 7.2.0.114. Drei Fassungen stehen jetzt getrennt, jede mit ihrem eigenen Inhalt |
| `WEITERMACHEN.md`, Liste der offenen Befunde | führte [E-131](../BEFUNDE.md#e-131) | `offene-befunde.pl` meldete *ZU VIEL*; mit `-schreiben` neu gesetzt, 35 von 35 |
| `AUFGABEN.md:3` | Zweig `e-123-transfersame`; *„veröffentlicht ist `v1.0.112`"* | Zweig `e-132-fremdes-mailverzeichnis`; veröffentlicht `v1.0.113` |
| `PORTIERUNG.md:44` | *„Stand 20.10.2026, Zweig `e-123-transfersame`: Quellstand 7.2.0.113, `VERSION` 1.0.113, **nicht veröffentlicht**"* | **drei Fehler in einer Zeile:** `e-123-transfersame` trug 7.2.0.112; 7.2.0.113 kam aus `e-131-leistenposition`; und 1.0.113 **ist** veröffentlicht. Die beiden fehlenden Blöcke (7.2.0.113, 7.2.0.114) ergänzt |
| `ZIEL.md:49` | *„Quellstand ist jetzt **7.2.0.113 / Paket 1.0.112**, am 20.10.2026 als `v1.0.112` veröffentlicht"* | Quellstand und Paketnummer gehörten zu zwei verschiedenen Fassungen |
| `TESTPLAN.md:172` | *„Stand 20.10.2026, Paket **1.0.112**"* | zu testen ist 1.0.114 (im Kopf derselben Datei richtig), veröffentlicht ist 1.0.113 |
| `TESTPLAN.md:397` | *„**Stand 20.10.2026**… Quellstand 7.2.0.110, Zweig `e-69-meldungsflut`, 229 Tests"* | 7.2.0.114, `e-132-fremdes-mailverzeichnis`, 241 Tests — **vier Fassungen alt, und die Zeile darüber sagte trotzdem *Stand 20.10.2026*** |
| `tools/ZWEIGE.md:110` | der Eintrag zu `e-132-fremdes-mailverzeichnis` war der **einzige ohne Quellstand** | nachgetragen, mit *noch nicht geschnürt* |

**Der gemeinsame Nenner:** jede dieser Stellen trägt ein Datum, und zwar das
richtige. Ein Stand-Kopf, der stimmt, sagt nichts über den Text darunter —
`pruefe-stand-md.pl` prüft das Datum, nicht die Aussage.

### <a id="l-44.8"></a>L-44.8 — `Releases/ISSUE-102-ANTWORT.md`: jeder Satz belegt, drei Dinge ungesagt (hoch)

Der freigegebene Wortlaut geht an einen Fremden. Ich habe ihn **Satz für Satz**
gegen [E-132](../BEFUNDE.md#e-132), [E-131](../BEFUNDE.md#e-131),
[E-124](../BEFUNDE.md#e-124) und den CHANGELOG-Abschnitt 7.2.0.114 gehalten.

**Belegt ist jeder Satz:**

| Behauptung im Text | Beleg |
|---|---|
| Registry-Weg `HKCU\…\CommandLine\Current`, greift nur ohne Befehlszeile und ohne `Eudora.ini` neben der EXE | [E-132](../BEFUNDE.md#e-132), am Quelltext (`eudora.cpp:1036-1052` → `:3700`) |
| *„ours is located in `Mailverzeichnis\`"* | [E-132](../BEFUNDE.md#e-132), genau die zweite Bedingung |
| drei Antworten, **Vorgabe die mittlere** | [E-132](../BEFUNDE.md#e-132): *„mit „Eigenes anlegen" als Vorgabe"* |
| *No* → frisches Verzeichnis, fremde `Eudora.ini` **byte-identisch** (SHA-256) | [E-132](../BEFUNDE.md#e-132), Messung am laufenden Programm |
| *Yes* → fremdes Verzeichnis benutzt, seine `Eudora.ini` **ändert sich** | [E-132](../BEFUNDE.md#e-132): `LastKnownCrashInfo=0` → `=1`, nach 15 s |
| *Cancel* → Eudora beendet sich, nichts angefasst | [E-132](../BEFUNDE.md#e-132) |
| Über-Dialog: INI-Pfad, Protokollpfad mit LogLevel, Herkunft, Knopf *Copy info* | `CHANGELOG.md`, Abschnitt 7.2.0.114, Tabelle der vier Zeilen |
| Defender `Trojan:Win32/Bearfoos.A!ml`, eingereicht 20.10.2026, Vorgang `a567fe2a-…` | [E-124](../BEFUNDE.md#e-124), `Releases/DEFENDER-FEHLALARM.md` |

**Drei Dinge sagt der Text nicht.** Ich habe den freigegebenen Wortlaut
**nicht angefasst** und die drei Punkte als Anmerkung darüber gesetzt, damit
sie sieht, wer ihn abschickt:

1. **Seine vorhandene `Eudora.ini` wird dadurch nicht heil.** Unsere Behebung
   zu [E-131](../BEFUNDE.md#e-131) berichtigt erst beim **Sichern**. Ihn selbst
   trifft es nicht mehr (er hat zurückgespielt) — einen anderen Leser schon.
2. **Die Ursache ist weiterhin nicht belegt** ([L-44.3](#l-44.3)). *„We found
   the mechanism behind this and fixed it"* ganz oben kann so gelesen werden,
   als sei auch das erledigt; wir haben es 20 Minuten vorher im selben Issue
   zurückgenommen.
3. **Die Bitte, `v1.0.114` neben seiner Installation zu probieren, nennt keine
   Vorsichtsmaßnahme.** Solange die Ursache offen ist — und
   [PRÜFER-40](PRUEFER-40.md#k14) K14 nennt mit `Docking=1` ohne Andockkontext
   einen **zweiten, ungemessenen** Weg zu genau seinem Null-Zeiger — gehört ein
   *„back up your `Eudora.ini` first"* dazu. Dasselbe verlangen wir in der
   README von jedem Anwender.

**Noch nicht abgeschickt**, und das ist richtig so: der Text nennt `v1.0.114`,
und die Fassung gibt es als Release nicht ([L-44.5](#l-44.5)).

### <a id="l-44.9"></a>L-44.9 — `tools/RELEASES.md`: die Zeile zu `v1.0.113` stand wieder außerhalb der Tabelle (mittel)

`grep -n '^|'` zeigte die Tabelle bis Zeile **34** (`v1.0.112`), dann den
Zitatblock — und in Zeile **46**, hinter dem Zitatblock, die Zeile zu
`v1.0.113`. Dort rendert sie als **rohe Zeile voller senkrechter Striche** unter
einem fremden Absatz.

**Das ist [L-43.8](LEKTOR-43.md#l-43.8) zum zweiten Mal, einen Tag später.** Ich
habe die Zeile gestern an dieselbe Stelle gehoben und in
[L-43.12](LEKTOR-43.md#l-43.12) vorgeschlagen, das Skript vor der letzten
Tabellenzeile einsetzen zu lassen. Das Skript ist unverändert, also hängt es
weiter ans **Dateiende** — und beim nächsten Release passiert es wieder.
**Eine Berichtigung ohne Werkzeugänderung ist eine Berichtigung auf Zeit**
([Fehlerklassen abstellen](../Arbeitsweise/fehlerklassen-abstellen.md)).

Dazu: die Zeile zu `v1.0.112` sagte weiterhin *„auf GitHub als **Latest**"* —
das ist seit 13:01:36 UTC `v1.0.113`. Berichtigt, mit *„am selben Tag
abgelöst"*.

### <a id="l-44.10"></a>L-44.10 — die veröffentlichten Notizen zu `v1.0.113` warnen nicht vor E-132 (mittel)

`Releases/1.0.113/RELEASE-NOTIZEN.md`, *Bekannte Fehler*: neun Punkte, von
`.txt`-Endung bis Adressbuch. **[E-132](../BEFUNDE.md#e-132) kommt nicht vor** —
obwohl er in dieser Fassung **offen** ist, obwohl er aus demselben
[Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102) stammt, das
die Notizen oben im Kasten zitieren, und obwohl er das Einzige in der Liste ist,
was etwas **außerhalb** von Eudora beschädigt.

`README.md:55-62` warnt davor, die Notizen nicht. Wer das ZIP von GitHub lädt,
liest aber zuerst die Notizen. Punkt an den Anfang der Liste gesetzt, mit der
Abhilfe (`Eudora starten.cmd`, Pfad in der Verknüpfung) und dem Vermerk, dass
die Behebung erst in 7.2.0.114 steckt.

### <a id="l-44.14"></a>L-44.14 — 16 Verweise aus `Befunde/` auf die Wurzeldokumente gingen ins Leere (mittel)

Alle **6135** Markdown-Verweise auf eine `.md`-Datei maschinell gegen das
Dateisystem gehalten (Skript im Kratzverzeichnis). **20 tot**, davon 16 von
derselben Art: ein Bericht unter `Befunde/` schreibt `](ZIEL.md)`,
`](AGENTEN.md)`, `](BEFUNDE.md)` oder `](README.md)` statt `](../ZIEL.md)`.
Betroffen: [`LEKTOR-5`](LEKTOR-5.md#lektor-5), `-6`, `-11`, `-13`, `-14`, `-27`, `-35` und
[PRÜFER-40](PRUEFER-40.md). Alle berichtigt — es ändert nur den Pfad, keinen
Satz; die Berichte bleiben Rückblicke.

**Zwei davon waren meine eigenen**, eine halbe Stunde alt:
`Releases/ISSUE-102-ANTWORT.md` zeigte mit `](PRUEFER-40.md#k1)` auf eine Datei
neben sich statt auf `../Befunde/`. Gefunden hat sie nicht mein Lesen, sondern
der Durchlauf über den **ganzen** Bestand
([Prüfumfang nicht von Hand](../Arbeitsweise/pruefumfang-nicht-von-hand.md)).

**Vier bleiben stehen, zu Recht:** dreimal `](….md)` in [`LEKTOR-13`](LEKTOR-13.md#lektor-13)/`-14` — ein
Platzhalter im Fließtext, keine Adresse —, und einmal in
`tools/WERKZEUGE.md:130`, wo `[E-115](BEFUNDE.md#e-115)` **als Beispieltext
in Rückstrichen** steht und zeigt, was `befunde-verlinken.pl --verlinken`
schreibt.

**`befunde-verlinken.pl` prüft das nicht.** Es prüft, ob jede **Kennung** ein
Link ist und ob der Anker existiert — nicht, ob der **Dateipfad** davor
stimmt. Vorschlag: die Dateiprüfung dort ergänzen; sie kostet einen
`-e`-Test je Link und hätte alle 16 beim Schreiben gefangen.

---

## Offen — gemeldet, nicht geändert

Alles unter dieser Überschrift ist Quelltext in `tools/` oder eine Aussage nach
außen und damit außerhalb meines Auftrags.

### <a id="l-44.11"></a>L-44.11 — 32 Schranken meldeten grün, während vier Dokumente unwahr waren (hoch)

**Gemessen zu Beginn dieses Laufs:** `perl tools/commit-bereit.pl` →
*„32 Schranken gefahren, keine weist ab"*. Zur selben Zeit:

* `Releases/PAKETE.md` führte ein Paket, das es nicht gibt ([L-44.5](#l-44.5));
* `WEITERMACHEN.md` gab `v1.0.113` die Prüfsumme von `v1.0.112` ([L-44.2](#l-44.2));
* `README.md` nannte einen behobenen, veröffentlichten Fehler offen ([L-44.1](#l-44.1));
* `CHANGELOG.md` sagte in derselben Datei beides ([L-44.7](#l-44.7)).

Die einzige Schranke, die etwas meldete, war `offene-befunde.pl` — und sie
hängt **nicht** in `commit-bereit.pl`s abweisendem Teil.

**Warum jede einzeln zu Recht grün war:**

| Schranke | ihr Maßstab | was ihr entgeht |
|---|---|---|
| `pruefe-release-buchfuehrung.pl` | *kommt die Zeichenkette `1.0.113` vor?* | **wem** die Nummer zugeordnet ist (CHRONIST, heute) |
| `pruefe-befundurteile.pl` | acht von Hand geschriebene Wendungen für *unerledigt* | *„noch nicht nachgestellt"* ist keine davon ([L-43.13](LEKTOR-43.md#l-43.13)-Klasse) |
| `pruefe-stand-md.pl` | das **Datum** im Stand-Kopf | der Text darunter ([L-44.7](#l-44.7)) |
| `doku-pruefen.pl` | Widerspruch **zwischen** Dokumenten | Prüfsummen, Zeitpunkte, Markennamen — nichts davon wird gegen `gh` gehalten |
| `pruefe-fassungsnummer.pl` | höchste Nummer in `PAKETE.md` gegen `VERSION` | ob es das Paket **gibt** |

**Vorschlag — eine Schranke, die den Bestand gegen `gh` hält.** Sie müsste für
die **neueste** Marke vier Werte aus `gh release view` ziehen (Zeitpunkt,
Marke/Commit, ZIP-Name, SHA-256) und jedes Dokument, das einen davon nennt,
dagegen prüfen. Das hätte [L-44.2](#l-44.2) gefangen, und es hätte
[PRÜFER-40](PRUEFER-40.md#k15) K15 vor dem Commit gefangen statt einen Tag
danach. **Zweiter Teil:** eine Nummer in `Releases/PAKETE.md`, deren Abschnitt
*„geschnürt"* sagt, muss ein ZIP oder ein `Releases/<nr>/` haben — sonst ist es
eine Anleitung ins Leere ([L-44.5](#l-44.5)).

### <a id="l-44.12"></a>L-44.12 — die Release-Notizen werden aus dem Vorgänger kopiert, nicht aus dem berichtigten Text (hoch)

[L-44.4](#l-44.4) ist kein Einzelfall, sondern ein **Weg**: `Releases/1.0.113/`
entstand als Kopie von `Releases/1.0.112/` in dem Zustand, in dem diese Datei
**vor** der Reparatur war. Zwei Textschäden, die am Vormittag behoben wurden,
standen am Nachmittag wieder draußen.

**Vorschlag:** `paket-bauen.ps1` / `release-veroeffentlichen.ps1` kopieren die
Notizen nicht aus dem letzten Ordner, sondern aus dem Stand von `origin/main`
zum Zeitpunkt des Baus — oder, billiger: eine Schranke, die in jedem
`Releases/*/RELEASE-NOTIZEN.md` nach Zeilen sucht, die mit einem Kleinbuchstaben
oder mitten im Satz beginnen und direkt auf eine Überschrift oder einen
Listenpunkt folgen. Beide Schäden aus [L-43.1](LEKTOR-43.md#l-43.1) haben genau
diese Form.

### <a id="l-44.13"></a>L-44.13 — aus LEKTOR-43 weiter offen

| Punkt | Stand heute |
|---|---|
| [L-43.11](LEKTOR-43.md#l-43.11) `pruefe-release-buchfuehrung.pl` läuft vor dem Tag | **offen.** `grep -c 'pruefe-release-buchfuehrung' tools/release-veroeffentlichen.ps1` = **0** (CHRONIST, heute). Der Schaden ist seither ein zweites Mal eingetreten: beim Tag `v1.0.113` meldete die Schranke rückwirkend **sechs** Stellen — **zwölf an einem Tag** |
| [L-43.12](LEKTOR-43.md#l-43.12) `paket-bereit.pl` gibt acht Schranken als „alle" aus | **offen.** Gemessen: 32 im Haken, 10 in `paket-bauen.ps1`, **27 nur im Haken**. Der zweite Teil (`tools/RELEASES.md` ans Tabellenende) ist heute wieder eingetreten ([L-44.9](#l-44.9)) |
| [L-43.13](LEKTOR-43.md#l-43.13) `ist_standaussage()` hört auf Wörter | **offen**, und derselbe Bauteil sitzt in `pruefe-befundurteile.pl:212-217` — dort hat er [L-44.1](#l-44.1) durchgelassen |
| [L-43.14](LEKTOR-43.md#l-43.14) vier Nummernkreise in den PRÜFER-Berichten | **teils erledigt:** [PRÜFER-40](PRUEFER-40.md) benutzt `K1` … `K15` **mit Ankern**. Die Verwechslungsgefahr mit [`P-39`](PRUEFER-14.md#p-39) besteht weiter, der Kreis trägt aber nicht mehr die Berichtsnummer |
| [L-43.15](LEKTOR-43.md#l-43.15) Release-Notizen nicht im Prüfumfang von `pruefe-befundurteile.pl` | **offen** — und [L-44.10](#l-44.10) ist genau der Fall: ein offener Befund fehlt in den Notizen, niemand merkt es |
| [L-43.17](LEKTOR-43.md#l-43.17) Defender-Beleg zu 1.0.112 | **erledigt für 1.0.113:** die Messung liegt jetzt in [E-124](../BEFUNDE.md#e-124) und in `Releases/PAKETE.md` ([L-44.6](#l-44.6)). Für **1.0.112** gibt es weiterhin keinen Beleg |
| [L-42.14](LEKTOR-42.md#l-42.14) / [L-41.3](LEKTOR-41.md#l-41.3) `ZIEL.md` kennt die neuen Befunde nicht | **teils erledigt:** `ZIEL.md:20-21` führt jetzt eine Anforderung *Fremde Installation* mit [E-131](../BEFUNDE.md#e-131) und [E-132](../BEFUNDE.md#e-132). [E-122](../BEFUNDE.md#e-122) bis [E-130](../BEFUNDE.md#e-130) stehen weiterhin weder als Voraussetzung noch unter *ausdrücklich nicht* |
| [L-41.8](LEKTOR-41.md#l-41.8) zwei Messskripte ohne Eintrag in `tools/WERKZEUGE.md` | **offen** |
| [L-38.5](LEKTOR-38.md#l-38.5) [E-78](../BEFUNDE.md#e-78) in der README-Tabelle | **offen** |
| [L-37.10](LEKTOR-37.md#l-37.10) AUFGABEN ohne Zeilen für [E-122](../BEFUNDE.md#e-122) ff. | **offen**, jetzt bis [E-132](../BEFUNDE.md#e-132) |
| [E-130](../BEFUNDE.md#e-130) fünf DLLs im Hauptbaum | **unverändert** — `git status` im Hauptbaum zeigt sie weiter als ` M` |

---

## Was bewusst stehen geblieben ist

* **Der veröffentlichte Text auf GitHub.** Berichtigt ist die Datei im Repo;
  die Release-Beschreibung zu `v1.0.113` trägt die drei Schäden aus
  [L-44.4](#l-44.4), die unbelegte Ursache aus [L-44.3](#l-44.3) und die
  fehlende E-132-Warnung aus [L-44.10](#l-44.10) weiter. Gregors Entscheidung.
* **Der eingereichte Text in `Releases/DEFENDER-FEHLALARM.md`.** Er ist bei
  Microsoft abgegeben. Eine Änderung daran machte aus einem Protokoll eine
  Fälschung; die Lücke habe ich stattdessen im Befund geschlossen
  ([L-44.6](#l-44.6)).
* **Der freigegebene Wortlaut in `Releases/ISSUE-102-ANTWORT.md`.** Gregor hat
  ihn Wort für Wort freigegeben, mit einer eigenen Änderung (*„is located"*
  statt *„lives"*). Meine drei Punkte stehen **darüber**, nicht darin
  ([L-44.8](#l-44.8)).
* **`Releases/1.0.101/RELEASE-NOTIZEN.md`, `1.0.110/`, `1.0.112/`** und alle
  `CHANGELOG`-Abschnitte unterhalb 7.2.0.113: Fassungsgeschichte.
* **`LEKTORAT.md` insgesamt** und alle früheren `Befunde/LEKTOR-*.md`:
  Rückblicke.
* **`ZIEL.md:18-34`**, welche der offenen Befunde Voraussetzung für 7.2.1.0
  sind: Gregors Entscheidung.

---

## Was Gregor entscheiden muss

1. **Die veröffentlichte Release-Beschreibung zu `v1.0.113` berichtigen?** Die
   Datei im Repo ist jetzt in Ordnung; GitHub trägt den alten Text. Ein Befehl,
   kein neues Release, kein neues ZIP, die Marke bleibt:

   ```sh
   gh release edit v1.0.113 --notes-file Releases/1.0.113/RELEASE-NOTIZEN.md
   ```

   **Dafür spricht:** zwei Sätze brechen mitten ab, der Punkt zur Meldungsflut
   fehlt ganz, die Ursachenbehauptung ist stärker als unsere eigene
   Richtigstellung im Issue, und vor [E-132](../BEFUNDE.md#e-132) wird nicht
   gewarnt. **Dagegen spricht nichts, was ich sehe** — aber es ist eine Aussage
   nach außen. *(Dieselbe Frage stand als Punkt 1 in
   [LEKTOR-43](LEKTOR-43.md#lektor-43) für `v1.0.112` und ist dort offen
   geblieben; seither ist der Schaden einmal mitgewandert.)*

2. **Die drei Punkte aus [L-44.8](#l-44.8) in den Issue-Beitrag aufnehmen?**
   Besonders der dritte: wir bitten ihn, `v1.0.114` neben seiner Installation
   zu probieren, ohne *„back up your `Eudora.ini` first"* dazuzuschreiben.

3. **Die Schranke aus [L-44.11](#l-44.11) bauen?** Sie hält die führenden
   Dokumente gegen `gh release view` statt gegen sich selbst. Sie ist der
   einzige Vorschlag in diesem Bericht, der [L-44.2](#l-44.2),
   [L-44.5](#l-44.5) und [PRÜFER-40](PRUEFER-40.md#k15) K15 **gemeinsam**
   erledigt.

4. **Die beiden Vorschläge aus [L-43.11](LEKTOR-43.md#l-43.11) und
   [L-43.12](LEKTOR-43.md#l-43.12), die seit gestern offen sind.** Beide
   Schäden sind heute ein zweites Mal eingetreten — zwölf falsche Stellen nach
   dem Tag, und die Tabellenzeile wieder am Dateiende.

---

## Geänderte Dateien

`README.md`, `CHANGELOG.md`, `WEITERMACHEN.md`, `BEFUNDE.md`, `ZIEL.md`,
`AUFGABEN.md`, `PORTIERUNG.md`, `TESTPLAN.md`, `Releases/PAKETE.md`,
`Releases/1.0.113/RELEASE-NOTIZEN.md`, `Releases/ISSUE-102-ANTWORT.md`,
`tools/RELEASES.md`, `tools/ZWEIGE.md`, `LEKTORAT.md`, dazu acht Berichte unter `Befunde/` nur an ihren Verweispfaden ([L-44.14](#l-44.14)), und dieser Bericht.

**Keine Datei unter `Eudora71/` angefasst, kein Werkzeug unter `tools/*.pl`
oder `*.ps1` geändert.** `Releases/DEFENDER-FEHLALARM.md` bewusst unverändert.

Nach jedem Schreibzugriff gemessen: **CRLF 0**, reine LF, UTF-8 ohne BOM.
`perl tools/commit-bereit.pl` vor jedem Commit: **32 Schranken, keine weist
ab.** `offene-befunde.pl` 35/35, `befunde-verlinken.pl` *Anker vollständig*.
