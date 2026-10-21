# Meldungen von außen

**Stand 21.10.2026.** Hier steht jede Meldung, die von außerhalb des Projekts
kommt — mit Datum, Melder, Dringlichkeit und dem, was daraus geworden ist.

**Warum es diese Datei gibt.** Meldungen von Anwendern sind wertvoll und
sollen nicht in einem Issue-Verlauf versickern. Gleichzeitig können wir nicht
alles gleichzeitig beheben. Diese Datei ist der sichtbare Mittelweg: die
Meldung ist aufgenommen, bewertet und nachlesbar — und das Issue kann
geschlossen werden, ohne dass die Sache verschwindet. Wer wissen will, was aus
seinem Bericht geworden ist, sieht hier nach.

**Was hier *nicht* steht:** die Messungen und die Begründungen. Die stehen in
[BEFUNDE.md](BEFUNDE.md), auf das jede Zeile verweist. Diese Datei ist das
Inhaltsverzeichnis, nicht die Akte.

## Dringlichkeit

| Stufe | Bedeutung |
|---|---|
| **hoch** | Post kann verlorengehen, oder eine vorhandene fremde Installation wird unbrauchbar |
| **mittel** | sichtbare Fehlfunktion, aber nichts geht verloren |
| **niedrig** | Schönheitsfehler, Altbestand oder etwas, das außerhalb unseres Ziels liegt |

## Offen

| Meldung | Datum | Melder | Dringlichkeit | Worum es geht | Stand |
|---|---|---|---|---|---|
| [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-3 | 21.10.2026 | `rjsdotorg` | niedrig | **Verwaiste `[ToolBar-BarN]`-Abschnitte.** Seine `Eudora.ini` führt `Bars=12`, enthält aber `Bar0`–`Bar15`. Vorschlag: beim Speichern die überzähligen Abschnitte entfernen | **Wird nicht behoben.** Am 21.10.2026 gemessen: beide Ladewege lesen nur bis `Bars`, die Waisen sind wirkungslos. Der Melder hat es selbst bestätigt — er löschte sie, nichts änderte sich. `CDockState::SaveState` hält `Bars` schon heute genau auf die Zahl der geschriebenen Abschnitte. Rückwärtskompatibilität der `Eudora.ini` ist **kein Ziel** dieses Projekts |
| [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-4 | 21.10.2026 | `rjsdotorg` | mittel | **`MRUFloatYPos=-682908189` in `[ToolBar-Bar10]`.** Anders als die Waisen liegt dieser Abschnitt *innerhalb* von `Bars=12` und wird bei jedem Start geladen. `Bar10` ist die Suchleiste (`IDC_SEARCH_BAR`) | **Noch nicht gemessen.** Offen ist, ob `E131PositionIstBrauchbar` diesen Wert erfasst — die Regel aus [E-131](BEFUNDE.md#e-131) wurde gegen `INT_MIN` gebaut, nicht gegen eine beliebige Müllzahl. Der Melder selbst hat diesen Punkt als Nebensache eingestuft und die wirkungslosen Waisen untersucht |

## Erledigt

| Meldung | Datum | Melder | Dringlichkeit | Worum es geht | Stand |
|---|---|---|---|---|---|
| [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-1 | 18.10.2026 | `rjsdotorg` | hoch | **Nach einem Start unserer Fassung startete seine Hermes 7.1.0.9 nicht mehr** (`EXCEPTION_ACCESS_VIOLATION` in `MFC71.DLL`). Unsere Fassung hatte sich über die Registry stillschweigend sein Mailverzeichnis geholt und dessen `Eudora.ini` verändert | **Behoben** in 7.2.0.117 und 7.2.0.118, veröffentlicht in [`v1.0.120`](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.120). Eudora fragt jetzt, bevor es ein fremdes Mailverzeichnis übernimmt; Vorgabe ist ein frischer Ordner. Auch eine *fehlgeschlagene* Rückfrage übernimmt es nicht mehr. Siehe [E-132](BEFUNDE.md#e-132). **Offen bleibt die Rückmeldung:** ob seine Hermes danach wieder startet, hat er noch nicht berichtet |
| [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-2 | 18.10.2026 | `rjsdotorg` | hoch | **`MRUFloatXPos=-2147483648` in der gemeinsam benutzten `Eudora.ini`** — seine Vermutung für die Absturzursache | **Behoben** in 7.2.0.113. Wir schreiben den Wert nicht mehr; am Prüfstand rot und grün gemessen. **Dass er die Ursache war, ist nicht belegt** — `-2147483648` ist `CW_USEDEFAULT`, das MFC selbst setzt und beim Lesen wieder abfängt ([PRÜFER-40 K1](Befunde/PRUEFER-40.md#k1)). Belegt ist nur, dass wir ihn geschrieben haben. Siehe [E-131](BEFUNDE.md#e-131) |

## Was wir nicht übernehmen

Damit Meldungen nicht an einer Erwartung scheitern, die wir nie hatten:

* **Die `Eudora.ini` bleibt nicht rückwärtskompatibel.** Unsere Fassung und
  eine vorhandene Eudora oder Hermes schreiben denselben Satz Werkzeugleisten
  mit unterschiedlichen MFC-Fassungen. Wer beide benutzen will, benutzt
  **getrennte Verzeichnisse** — so ist das Paket ausgeliefert, und
  `Eudora starten.cmd` hält sich daran.
* **Parallelbetrieb mit geteilter `Eudora.ini` oder geteiltem Mailverzeichnis
  geschieht auf eigene Gefahr.**
* Was wir sehr wohl übernehmen: dass **eine vorsichtige Benutzung nichts
  zerstört**. Genau das war bei [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-1
  verletzt — der Melder hatte nichts falsch gemacht —, und genau deshalb wurde
  es behoben.

## Wie eine Meldung hier landet

1. Issue lesen, die einzelnen Punkte **trennen** — ein Issue enthält oft
   mehrere Meldungen mit sehr verschiedener Dringlichkeit.
2. Vor einem neuen Eintrag in `BEFUNDE.md` erst suchen:
   `perl tools/befund-suchen.pl <Datei oder Funktion>`. Gesucht wird nach dem
   **Ort im Quelltext**, nicht nach der Beschreibung.
3. Hier eintragen, mit Verweis auf den Befund, der die Messung trägt.
4. Im Issue antworten, auf diese Datei verweisen, Issue schließen.
