# Pruefbericht Eudora 7.2

| | |
|---|---|
| **Paketfassung** | `1.0.121` |
| **Quellstand** | `7.2.0.121` |
| **Commit** | `a27ce156` (**Arbeitsbaum nicht sauber**: 29 Dateien geaendert) |
| **Erstellt** | 2026-10-22 14:18 |
| **Gesamturteil** | **BESTANDEN** |

Erzeugt von `tools/pruefbericht.pl`. Er fuehrt die Tests nicht selbst aus,
sondern liest, was die Laeufe hinterlassen haben - was nicht gemessen wurde,
steht hier als nicht gemessen und nicht als gruen.

## 1. Unit-Tests (`EudoraTests.exe`)

| Tests | bestanden | fehlgeschlagen |
|---|---|---|
| 274 | 274 | 0 |

## 2. Regressionstests ueber die Oberflaeche (`pruefstand-lauf.ps1`)

Gefahren am 2026-10-22 14:17:23, Freigabe: *"Gregor am 22.10.2026: 'ja, fahr die regressionstests'"*

| Faelle | bestanden | fehlgeschlagen |
|---|---|---|
| 6 | 6 | 0 |

```
[ ok ] E-131a   ohne MRUFloatXPos=-2147483648
[ ok ] E-131b   ohne MRUFloatYPos=-2147483648
[ ok ] E-131c   E-131 Leistenposition:
[ ok ] E-14     ohne Erasing X1 indices
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
| kritisch | 63 |
| wichtig | 46 |
| unkritisch | 38 |
| werkzeug | 43 |

Von den **63 kritischen** Befunden haben

* **15** einen automatischen Testfall,
* **0** einen manuellen Fall im [Testplan](../Intern/TESTPLAN.md),
* **48** bisher **keine Pruefung**.

Die letzte Zahl ist der Rueckstand. Solange sie nicht null ist, sagt ein
gruener Bericht nicht, dass nichts kaputt ist - er sagt, dass nichts von dem
kaputt ist, was geprueft wird.

## 4. Was dieser Bericht nicht abdeckt

* Die manuellen Faelle in [TESTPLAN.md](../Intern/TESTPLAN.md), Teil M -
  sie muessen vor einem Release von Hand gefahren und dort abgehakt werden.
* Alles, was keinen Testfall hat (siehe Abschnitt 3).
* Ein Release gilt erst nach **Gregors eigenem Lauf** und seiner Zustimmung
  (CLAUDE.md, Abschnitt 4) - dieser Bericht ersetzt das nicht.
