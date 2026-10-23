# Pruefbericht Eudora 7.2

| | |
|---|---|
| **Paketfassung** | `1.0.121` |
| **Quellstand** | `7.2.0.121` |
| **Commit** | `0574be0c` (**Arbeitsbaum nicht sauber**: 11 Dateien geaendert) |
| **Erstellt** | 2026-10-23 07:59 |
| **Gesamturteil** | **BESTANDEN** |

Erzeugt von `tools/pruefbericht.pl`. Er fuehrt die Tests nicht selbst aus,
sondern liest, was die Laeufe hinterlassen haben - was nicht gemessen wurde,
steht hier als nicht gemessen und nicht als gruen.

## 1. Unit-Tests (`EudoraTests.exe`)

| Tests | bestanden | fehlgeschlagen |
|---|---|---|
| 275 | 275 | 0 |

## 2. Regressionstests ueber die Oberflaeche (`pruefstand-lauf.ps1`)

Gefahren am 2026-10-22 20:25:54, Freigabe: *"Gregor am 22.10.2026: 'du kannst auch deine tests starten, ich halte mich zurueck'"*

Alle Pruefstaende tragen den Quellstand `7.2.0.121` (an der
Dateiversion ihrer `Eudora.exe` gemessen).

| Faelle | bestanden | fehlgeschlagen |
|---|---|---|
| 5 | 5 | 0 |

```
[ ok ] E-131a   ohne MRUFloatXPos=-2147483648
[ ok ] E-131b   ohne MRUFloatYPos=-2147483648
[ ok ] E-131c   E-131 Leistenposition:
[ ok ] E-121    ablage-dateien=1
[ ok ] E-118    E-118 Bild:
```

## 3. Deckung der kritischen Befunde

Was *kritisch* heisst, steht in [BEFUNDE.md](../Intern/BEFUNDE.md) unter
*Die Stufe*: Post oder Einstellungen gehen verloren oder werden still
beschaedigt, eine fremde Installation nimmt Schaden, das Programm stuerzt ab,
startet nicht oder haengt, eine Nachricht geht falsch hinaus oder kommt
falsch an, Sicherheit.

| Stufe | Zahl |
|---|---|
| kritisch | 67 |
| wichtig | 50 |
| unkritisch | 31 |
| werkzeug | 43 |

Von den **67 kritischen** Befunden haben

* **16** einen automatischen Testfall,
* **51** bisher **keine Pruefung**.

Dazu **1** mit einem manuellen Fall im [Testplan](../Intern/TESTPLAN.md) — diese Zahl **ueberschneidet sich** mit der ersten Zeile, ein Befund kann beides haben (E-132 hat beides). Die Aufteilung sind die ersten beiden Zeilen, und sie geht auf: 67 von 67.

Die letzte Zahl ist der Rueckstand. Solange sie nicht null ist, sagt ein
gruener Bericht nicht, dass nichts kaputt ist - er sagt, dass nichts von dem
kaputt ist, was geprueft wird.

## 4. Was dieser Bericht nicht abdeckt

* Die manuellen Faelle in [TESTPLAN.md](../Intern/TESTPLAN.md), Teil M -
  sie muessen vor einem Release von Hand gefahren und dort abgehakt werden.
* Alles, was keinen Testfall hat (siehe Abschnitt 3).
* Ein Release gilt erst nach **Gregors eigenem Lauf** und seiner Zustimmung
  (CLAUDE.md, Abschnitt 4) - dieser Bericht ersetzt das nicht.
