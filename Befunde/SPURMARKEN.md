# Spurmarken und ihre Auswertung

Eine Spurmarke kostet einen Bau. Ihr Nutzen entsteht erst, wenn jemand das
Protokoll liest. Dazwischen liegt ein Moment, an den sich niemand von selbst
erinnert — deshalb steht er hier, und `tools/spuren-auswerten.pl` erzwingt ihn
beim Bau des nächsten Pakets.

**Der Vorfall, aus dem diese Datei entstanden ist:** die Spurmarken zu **E-70**
lagen seit Paket **1.0.37** im Bau. Ausgewertet wurden sie zum ersten Mal an
**1.0.40**. Dazwischen sind 1.0.38, 1.0.39 und 1.0.40 gebaut und ausgeliefert
worden, jedes mit der Bitte an Gregor, etwas anderes zu prüfen. Als das
Protokoll endlich gelesen wurde, sagte es in zwei Zeilen alles: **40** mal
`E-70 gesichert`, **0** mal `E-70 geladen`. Siehe
[eingebaute-messung-auslesen](../Arbeitsweise/eingebaute-messung-auslesen.md).

## Wie diese Tabelle gepflegt wird

- **Eine Zeile je Befund**, sobald eine `SPURMARKE ZU E-nn` in den Quelltext
  kommt. Die Spalte *eingebaut* nennt die Paketfassung, mit der sie zum ersten
  Mal zu Gregor geht.
- **Nach jeder Rückmeldung von Gregor** wird das Protokoll auf diese Marke hin
  gelesen und das Ergebnis hier eingetragen — die Fassung in *ausgewertet* und
  ein Satz, **was sie gesagt hat**. „Nichts gefunden" ist auch ein Ergebnis und
  gehört hin.
- **Soll eine Marke ohne Auswertung weiterlaufen**, steht in *ausgewertet*
  `entfaellt: <Begründung>`. Damit ist die Lücke schriftlich statt vergessen.
- **Ist die Marke ausgebaut**, darf die Zeile weg; `spuren-auswerten.pl` meldet
  sie dann als verwaist (ohne abzuweisen).

## Die Marken

| Befund | eingebaut | ausgewertet | was sie gesagt hat |
|---|---|---|---|
| E-64 | 1.0.39 | 1.0.41 | jede Nachricht gegen alle drei Filter geprüft, `Match=0` war richtig — die Nachricht kam von einer anderen Adresse, als der Filter suchte. Gregors Urteil: Fehlalarm. Eine ältere Marke zu E-64 liegt seit 1.0.30 an derselben Stelle |
| E-66 | 1.0.35 | 1.0.42 | **über Gregors Urteil statt über das Protokoll.** An 1.0.42: *„1. ja / 2. ja / 3. ja"* zu Balken lässt sich ziehen, rechte Hälfte des Filterfensters erreichbar, Änderungen bleiben stehen. Genau das sollten die Marken klären — sie haben ihren Zweck erfüllt und dürfen ausgebaut werden. Bis dahin schreiben sie bei jedem Zeigerwechsel über einer Leiste eine Zeile |
| E-70 | 1.0.37 | 1.0.40 | 40 Zeilen `E-70 gesichert`, 0 Zeilen `E-70 geladen`. Der Wert wird geschrieben und nie gelesen — der Aufruf stand in `SECToolBarManager::LoadState`, die Eudora nie aufruft. Behoben in 7.2.0.41 |
| E-76 | 1.0.41 | entfaellt: braucht eine gedrückte Maustaste, siehe E-51 | Die Marke schreibt nur, wenn jemand am Rand eines **schwebenden** Fensters zieht. Das lässt sich hier nicht auslösen — dasselbe Hindernis wie bei **E-51**: `Splitter::Track` und die Größenänderung eines Rahmens brechen ab, sobald die physische Maustaste los ist. Sie bleibt drin und wartet auf den nächsten Bericht von Gregor. Sie nennt `nLength`, `dwMode` mit ausgeschriebenen Flags, `IsFloating` und die Maße vorher wie nachher in einer Zeile |
| E-44 | 1.0.43 | | zwei Zeitpunkte mit derselben Angabe: `nach SetDockState` und `vor`/`nach LoadWazooBarConfig`, je Leiste mit Kennung, Andockleiste, Sichtbarkeit und Stil. Sagt die erste „hat Andockleiste" und die zweite „keine", geht die Zuordnung dazwischen verloren; sagt schon die erste „keine", wirkt `SetDockState` nicht |

## Prüfen

```
perl tools/spuren-auswerten.pl                # prüft, weist ab
perl tools/spuren-auswerten.pl --nur-melden   # nur Bericht, exit 0
```

Das Werkzeug hängt in `tools/paket-bauen.ps1`. Es weist ab, wenn eine Marke aus
einer **früheren** Fassung noch nicht ausgewertet ist — eine Marke, die mit der
gerade gebauten Fassung zum ersten Mal hinausgeht, ist in Ordnung, denn sie soll
ja erst noch mitlaufen.
