# <a id="lektor-99"></a>LEKTOR-99 — Buchführung nach der Veröffentlichung von v7.2.1.128

**Datum:** 29.10.2026 · **Geprüft:** Commit `321b3599` auf `release-7.2.1-veroeffentlicht` · **Arbeitsbaum:** `wt/lektor-20261029i`

## Abgleich mit GitHub (gemessen)

| Angabe im Commit | GitHub | Urteil |
|---|---|---|
| veröffentlicht 29.10.2026 21:17:31 UTC | `publishedAt` 2026-10-29T21:17:31Z | stimmt |
| Marke auf `c8b0893f` | `targetCommitish` und `git ls-remote --tags origin v7.2.1.128`: `c8b0893f0e05…` | stimmt |
| *Latest* | `releases/latest` → `v7.2.1.128` | stimmt |
| ZIP `Eudora72-7.2.1.128-release.zip`, 9.126.491 Byte | Anhang gleichen Namens, `size` 9126491 | stimmt |

`tools/RELEASES.md` trägt `2026-10-29 22:17:31` — das ist dieselbe Zeit in MEZ (Commit-Zeitzone +0100); belegt, kein Fund.

`perl tools/pruefe-release-buchfuehrung.pl` (gemessen, rc=0):

```
Neuestes Tag                   v7.2.1.128  (Paketnummer 128)
Geprueft                       5 Datei(en), 5 Standaussage(n)
Jedes fuehrende Dokument kennt v7.2.1.128, und keiner der 5
geprueften Absaetze gibt eine aeltere Fassung als aktuellen Stand aus.
```

Das Werkzeug prüft nur fünf Standabsätze; die Funde unten liegen außerhalb.

## Funde

<a id="l-99.1"></a>
### <a id="l-99.1"></a>L-99.1 — Anwenderhandbuch nennt `v1.0.120` als aktuelles Release

`Doku/ANWENDER.md:274-275` (gemessen): *„in `v1.0.120` ist er **noch nicht** enthalten; 1.0.122 ist geschnürt, aber nicht veröffentlicht“*. Gegenwart, nicht Geschichte — seit `v7.2.1.128` ist der Zusatz veröffentlicht (belegt: 7.2.1.128 trägt 7.2.0.122 ff., `CHANGELOG.md`). Der Satz steht in der Anwenderdoku, also nach außen.

<a id="l-99.2"></a>
### <a id="l-99.2"></a>L-99.2 — AUFGABEN: „draußen ist seit dem 21.10.2026 `v1.0.120`“

`Intern/AUFGABEN.md:118` (gemessen): die Klammer *„abgelöst, draußen ist seit dem 21.10.2026 `v1.0.120`“* ist Präsens und seit 21:17:31 UTC falsch; richtig wäre „draußen ist seit dem 29.10.2026 `v7.2.1.128`“.

<a id="l-99.3"></a>
### <a id="l-99.3"></a>L-99.3 — WEITERMACHEN: „Zuletzt von Gregor bestätigt“ steht bei 1.0.101

`Intern/WEITERMACHEN.md:48` (gemessen): Zeile *„Zuletzt von Gregor bestätigt — 1.0.101 am 17.10.2026“*, während Zeile 47 und der Commit selbst Gregors Test an 7.2.1.128 am 29.10.2026 nennen. Nicht vom Commit eingeführt, aber im selben Kasten stehen geblieben.

## Urteil

Die neuen Angaben stimmen mit GitHub überein. Drei Standaussagen außerhalb der vom Commit berührten Zeilen sind veraltet; [L-99.1](#l-99.1) wirkt nach außen.

## Nachprüfung nach 4fff285f

- [L-99.1](#l-99.1) behoben (gemessen): `Doku/ANWENDER.md` sagt jetzt „veröffentlicht erstmals mit `v7.2.1.128` (in `v1.0.120` war er noch nicht enthalten)“ — die Gegenwart ist richtig, v1.0.120 steht nur noch als Geschichte da.
- [L-99.2](#l-99.2) behoben (gemessen): `Intern/AUFGABEN.md:118` „seit dem 29.10.2026 ist `v7.2.1.128` draußen“.
- [L-99.3](#l-99.3) behoben (gemessen): `Intern/WEITERMACHEN.md:48` nennt 7.2.1.128 am 29.10.2026, davor 1.0.127 am 27.10.2026 mit V1 bis V6. Das deckt sich mit `Intern/TESTPLAN.md:179-184` (Abschnitt `ergebnis-7-2-0-127`, V1/V2 am 27.10.2026). Beide Anker, `ergebnis-7-2-0-127` und `ergebnis-e-166-laptop`, sind im TESTPLAN vorhanden.

Nichts Neues kaputt. Nur am Rand: die Zeile in `tools/AGENTEN-LAUFEN.md` beschreibt den Lauf als „alle MDs gegen den Bestand, seit c8b0893f“. Geprüft war `321b3599` samt einer grep-Suche über die MDs. Das ist ungenau, aber kein Fund.
