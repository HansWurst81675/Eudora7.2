# Was „lauffähig" heißt

Von Gregor am 30.08.2026 festgelegt, nachdem eine Fassung als „lauffähig"
ausgeliefert wurde, die zwar startete, aber nicht bedienbar war.

> * es genügt nicht, daß das programm startet
> * die darstellung sollte korrekt sein
> * ich möchte damit einen mail server verbinden und mails abrufen.

## Die drei Kriterien

| # | Kriterium | Stand am 30.08.2026 |
|---|---|---|
| 1 | Eudora startet und zeigt sein Hauptfenster | **erfüllt** (Paket 1.0.2) |
| 2 | Die Darstellung ist korrekt | **nicht erfüllt** |
| 3 | Ein Mailkonto lässt sich einrichten, verbinden und Mail abrufen | **nicht geprüft** |

**Erst wenn alle drei erfüllt sind, darf eine Fassung „lauffähig" heißen.**
Vorher heißt sie, was sie ist — etwa „startet" oder „Vorabfassung".

## Woran sich Kriterium 2 misst

Gregor hat als Vergleich ein Bildschirmfoto der Originalfassung geliefert
(Eudora 7 unter Windows XP). Maßgeblich sind daraus:

- Werkzeugleiste mit **allen** Symbolen, keine leeren grauen Felder
- Postfachbaum links, sauber abgegrenzt
- Nachrichtenfenster mit Kopfzeilenbereich und Textbereich untereinander
- Registerkarten am unteren Rand des Nachrichtenbereichs
- keine sich überlagernden Bereiche

Bekannte Abweichungen sind in `BEFUNDE.md` unter S-6 gesammelt.

## Woran sich Kriterium 3 misst

Nachweis ist ein tatsächlicher Abruf gegen einen echten Server, mit Beleg:
Protokollversion und Verfahren aus *Tools → Last SSL Info*, und mindestens eine
empfangene Nachricht, die lesbar dargestellt wird.

Das ist zugleich der erste echte Test der neuen TLS-Schicht. Der letzte
erfolgreiche Abruf (`pop.gmx.net`, TLS 1.3) fand mit einer **älteren**
QCSSL-Fassung statt — Einzelheiten in `Releases/1.0/AUSLIEFERUNGEN.md`.

## Was daraus für die Benennung folgt

Der Dateiname `Eudora72-1.0.2-lauffaehig.zip` behauptet mehr, als die Fassung
kann. Künftige Pakete heißen nach ihrem tatsächlichen Stand. Siehe
`Releases/PAKETE.md`.
