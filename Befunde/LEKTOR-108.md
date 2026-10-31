# <a id="lektor-108"></a>LEKTOR-108 — Abschlusslauf nach 33e7a52d (31.10.2026)

Kurzer Lauf, kein Vollbestand. Geprüft: die beiden Funde aus
[LEKTOR-107](LEKTOR-107.md) und die neue Doku zu
[E-136](../Intern/BEFUNDE.md#e-136) (Emoji gehen beim Speichern verloren)
aus `cb477bbf`.

## Kurz

Beide Funde aus [LEKTOR-107](LEKTOR-107.md#lektor-107) sind **erledigt**. [E-136](../Intern/BEFUNDE.md#e-136) kommt in BEFUNDE,
README, CHANGELOG, TESTPLAN, WERKZEUGE und der erzeugten Liste einheitlich
als **offen** an, nirgends als „behoben“, nirgends ist die Behebung „am
Programm gemessen“. Zwei kleine neue Funde: im Urteil zu [E-136](../Intern/BEFUNDE.md#e-136) steht der
alte Absatz „Was noch fehlt: die Stelle … ist nicht gefunden“ weiter im
Präsens hinter der neuen, belegten Ursache ([L-108.1](#l-108.1)); die
Überschriften in CHANGELOG und TESTPLAN sagen „gehen nicht mehr verloren“
als Tatsache, die Einschränkung folgt erst im Satz ([L-108.2](#l-108.2)).

## Funde aus LEKTOR-107

| Fund | Worum es ging | Heute | Beleg |
|---|---|---|---|
| [L-107.1](LEKTOR-107.md#l-107.1) | Die erzeugte Liste nannte [E-165](../Intern/BEFUNDE.md#e-165) (Vervollständigungsbox im `To:`-Feld) „nie gemessen“, weil die Marke fehlte | **erledigt** | `Intern/BEFUNDE.md:382` jetzt *„**Zuletzt gemessen: 31.10.2026 an 7.2.1.128** (Bau `efcd5945`, Quellstand mit der Behebung)“*; `Intern/WEITERMACHEN.md:83` und `CHANGELOG.md:36` *„31.10.2026 an 7.2.1.128“*; `offene-befunde.pl` *„davon NIE gemessen 11“* (vorher 12) (gemessen). Die Schreibweise „Fassung + Bau“ gibt es auch an anderen Zeilen, z. B. *„an 7.2.0.127 (`+772ed08d`, mit Behebung)“* (gemessen) |
| [L-107.2](LEKTOR-107.md#l-107.2) | [E-171](../Intern/BEFUNDE.md#e-171) (Suche ohne markierten Text): „nicht nachgesehen“ im Urteil; CHANGELOG schrieb dem Prüfstandsfall die Gegenmessung zu | **erledigt** | `Intern/BEFUNDE.md:387` jetzt *„für Nur-Text-Mails (`PaigeEdtView.cpp:8746` ruft dieselbe Funktion, am 31.10.2026 nachgesehen)“*; `CHANGELOG.md:111` *„**am Programm gemessen** mit `tools/messen-e171.ps1`: 7.2.1.128 mit Meldung (`C:\Temp\E171-alt`), der neue Bau ohne; der Prüfstandsfall `E-171p` prüft den neuen Bau.“* (gemessen) |

## E-136 in allen Dokumenten

| Ort | Aussage | Urteil |
|---|---|---|
| `Intern/BEFUNDE.md:407` | *„**offen — Behebung im Quellstand (31.10.2026), am Quelltext und am Funktionstest belegt, am laufenden Programm NICHT nachgestellt; in keinem Paket.**“*; *„**Am Programm nicht nachgestellt:** `tools/messen-e136.ps1` … erreicht den Speicherweg nicht … `gespeichert=0`, bei **beiden** Fassungen“*; die Marke bleibt *„**Zuletzt gemessen: 22.10.2026 an 7.2.0.120**“* | stimmt (gemessen); siehe aber [L-108.1](#l-108.1) |
| `Intern/WEITERMACHEN.md:91`, `CHANGELOG.md:44` | *„22.10.2026 an 7.2.0.120 — **veraltet** \| Gregors Weg am nächsten Paket ([TESTPLAN](…#e-136-naechstes)), oder ein Messweg, der die Nachricht wirklich verändert.“* | stimmt (gemessen); die Liste nimmt das erste „Was noch fehlt“ |
| `README.md:182` | *„im Quelltext geändert (am Programm noch nicht nachgemessen), kommt mit dem nächsten Paket“* | stimmt (gemessen) |
| `CHANGELOG.md:110` | *„([E-136](…), bleibt offen bis zur Messung am Programm) … **Am Programm noch nicht nachgestellt** — der Prüfstand erreicht den Speicherweg nicht. 350 Tests, 350 bestanden.“*, unter `CHANGELOG.md:104` *„## Im Quellstand, noch in keinem Paket“* | stimmt; Überschrift siehe [L-108.2](#l-108.2) |
| `Intern/TESTPLAN.md:183-197` | *„**Noch kein Paket — erst ausführen, wenn das nächste Paket da ist. Vorher das Postfach sichern** … Lokales Postfach, nicht IMAP. Mein Prüfstand erreicht diesen Weg nicht — dieser Schritt ist die einzige Messung am Programm.“* | stimmt, Ort genannt (gemessen) |
| `tools/WERKZEUGE.md:143` | *„**Erreicht den Speicherweg bisher nicht** (31.10.2026: `gespeichert=0` an 7.2.1.128 und am neuen Bau) — als Messung also noch untauglich“* | stimmt mit BEFUNDE überein (gemessen) |
| Dateien | `Eudora71/Tests/TestE136.cpp` (69 Zeilen), `Testdaten/e136-zeichen-als-entitaet.eml`, `tools/messen-e136.ps1` vorhanden; `Eudora71/Tests/Tests.vcxproj:150` *„TestE136.cpp“* | vorhanden (gemessen); die Zahl 350/350 ist **nicht** nachgemessen — in diesem Lauf wird nichts gebaut |

Das Wort „behoben“ steht zu [E-136](../Intern/BEFUNDE.md#e-136) an keiner dieser Stellen (gemessen:
`grep -n "E-136\|e-136"` über README, CHANGELOG, TESTPLAN, WERKZEUGE,
WEITERMACHEN, ZIEL).

## Neue Funde

### <a id="l-108.1"></a>L-108.1 — E-136: der alte Absatz „Was noch fehlt … nicht gefunden“ steht weiter im Präsens

**Gewicht: ein Satz, aber er widerspricht dem Kopf derselben Zeile.**
`Intern/BEFUNDE.md:407`

Worum es geht: Der Kopf des Urteils sagt, die Ursache sei am Quelltext
belegt (`CString = BSTR` im Speicherweg). Weiter hinten, im Teil
„Vorgeschichte“, steht unverändert:

> *„**Was noch fehlt:** die Stelle, an der beim Speichern nach windows-1252
> umkodiert wird. Sie ist **nicht** gefunden — die einzige
> CP1252-Umwandlung mit dem E-90-Filter ist `ISOTranslate` …“* und
> *„**Vermutung, nicht gemessen:** die Umwandlung geschieht in der
> Paige-/Trident-Schicht beim Schreiben der Nachricht.“*

**Gemessen:** die Zeile enthält „Was noch fehlt“ **zweimal**
(`grep -o … | wc -l` → 2). Die erzeugte Liste nimmt das erste, neue —
darum ist WEITERMACHEN richtig. Wer die Zeile liest, findet aber zwei
gegensätzliche „Was noch fehlt“.

**Vorschlag:** den alten Absatz als überholt kennzeichnen, z. B.
*„**Damals noch offen (22.10.2026, überholt am 31.10.2026):** …“*, und die
Vermutung mit *„bestätigt: Trident-Schicht, `SaveInfo` und `GetAllHTML`“*
abschließen — nach dem Muster, mit dem [L-107.2](LEKTOR-107.md#l-107.2)
bei [E-171](../Intern/BEFUNDE.md#e-171) erledigt wurde.

### <a id="l-108.2"></a>L-108.2 — Überschriften sagen „gehen nicht mehr verloren“, ehe es am Programm gemessen ist

**Gewicht: Kleinkram.** `CHANGELOG.md:110`, `Intern/TESTPLAN.md:183`

> `CHANGELOG.md:110`: *„**Emoji und andere Zeichen außerhalb von
> windows-1252 gehen beim Speichern einer HTML-Nachricht nicht mehr
> verloren** ([E-136](…), bleibt offen bis zur Messung am Programm)“*
>
> `Intern/TESTPLAN.md:183`: *„Im nächsten Paket: Emoji gehen beim
> Speichern nicht mehr verloren“*

Die Einschränkung steht jeweils im selben Eintrag (belegt); eine
Überbehauptung im Sinne von „behoben“ oder „am Programm gemessen“ ist es
also nicht. Wer nur die fetten Überschriften liest, liest aber eine
Tatsache, die am Programm noch niemand gesehen hat — und Gregor soll vor
dem Schritt sein Postfach sichern, gerade weil es nicht sicher ist.

**Vorschlag:** *„… sollen beim Speichern nicht mehr verloren gehen“* oder
*„… im Quellstand geändert, am Programm noch zu prüfen“*.

## Werkzeuge

`perl tools/doku-pruefen.pl` (Exit 0):

```
  Quellstand                   7.2.1.128
  Paketnummer                  7.2.1.128
  Kriterien in ZIEL.md         9
  gepruefte Dateien            50
  Kennungen im Verzeichnis     164
  Abschnitte in Intern/BEFUNDE.md 14
  Kein Widerspruch gefunden.
```

„Zur Kenntnis“ nennt wie bisher ältere Dateien ohne die Fassung 7.2.1.128
(z. B. `Releases/1.0.120/RELEASE-NOTIZEN.md`), nichts zu [E-136](../Intern/BEFUNDE.md#e-136).

`perl tools/offene-befunde.pl`:

```
    offen laut Intern/BEFUNDE.md  42
      davon aktuell gemessen       5  (ab Nummer 123)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     26
      davon NIE gemessen          11
    in Intern/WEITERMACHEN.md     42

  42 offene Befunde, in beiden Listen gleich.
```

## Was nur Gregor entscheiden kann

Nichts Neues.
