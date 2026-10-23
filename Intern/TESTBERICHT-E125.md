# Testbericht E-125 — Verschieben nach `Out`, Paket 1.0.122

**Stand 23.10.2026.** Geprüft ist Programmversion **7.2.0.122** aus Paket
**1.0.122**. Der Befund steht in [BEFUNDE.md](BEFUNDE.md#e-125), die Schritte
für den Handtest in [TESTPLAN.md](TESTPLAN.md#m3-e125).

## Ergebnis

**Bestanden.** Eine empfangene Nachricht lässt sich nicht mehr nach `Out`
verschieben: Es kommt der Hinweis, und es entsteht keine kaputte neue
Nachricht. Ein eigener Entwurf geht weiterhin nach `Out`. Gegen die alte
Fassung 7.2.0.120 schlägt derselbe Test fehl. Er erkennt den Fehler also,
wenn er zurückkommt.

| Prüfung | Wer | Ergebnis |
|---|---|---|
| Empfangene Nachricht aus dem IMAP-Ordner `OUTBOX (<Dominant>)` nach `Out` ziehen | Gregor, an 1.0.122 | **bestanden**: Hinweis mit einem Knopf, kein „Transfer anyway?", danach kein „No messages were transferred!" |
| Protokollzeile dazu | Gregor, an 1.0.122 | **bestanden**: `E-125 Xfer nach Out abgelehnt: quelle=OUTBOX (<Dominant>) ziel=Out kopie=0 einzeln=0` |
| Gegenprobe: eigener Entwurf nach `Out` | Gregor | **abgelehnt, nicht durchführbar**: Der Testplan sagte nicht, wie ein Entwurf außerhalb von `Out` entsteht. Das war ein Fehler des Plans. |
| Gegenprobe: Entwurf `Out` → `Trash` → `Out` | Prüfstand `C:\Temp\E125` | **bestanden**: Der Entwurf steht wieder in `Out`, `Trash` ist leer, kein Dialog, keine Ablehnung im Protokoll |
| Umkehrprobe im selben Lauf: empfangene Nachricht `In` → `Out` | Prüfstand | **bestanden**: Hinweis erscheint, die Nachricht bleibt in `In`, Protokoll `E-125 Xfer nach Out abgelehnt: quelle=In ziel=Out` |
| Dieselben Fälle gegen 7.2.0.120 | Prüfstand, Paket 1.0.120 von GitHub | **fehlgeschlagen, wie erwartet**: Das Protokoll zeigt wieder „Some headers may be removed when transferring to the Out Mailbox. Transfer anyway?" |
| Ganzer Regressionslauf `tools/pruefstand-lauf.ps1` | Prüfstand | **8 Fälle, 8 bestanden** (darunter die drei neuen) |

## Wie gemessen wurde

* **Prüfstand.** Paket 1.0.122, aus der ZIP-Datei in `C:\Temp\E125`
  ausgepackt. Dazu ein Dummy-Konto auf `127.0.0.1` ohne automatischen Abruf
  und `LogLevel=58527`, damit die Spurmarke geschrieben wird. Gregors
  Verzeichnisse sind nicht angefasst, ein echtes Postfach auch nicht.
* **Bedienung.** Über `tools/messen-e125.ps1`, gestartet über
  `tools/testlauf.ps1` (jeder Start steht in `tools/TESTLAEUFE.md`). Das
  Skript schickt nur Fensterbotschaften an gemessene Fenster, keine
  Tastendrücke. Es verschiebt über das Menü *Transfer* statt mit der Maus zu
  ziehen. Beides landet in derselben Prüfung (`CTocDoc::Xfer`,
  `tocdoc.cpp:2753`).
* **Positivprobe.** Das Protokoll des Laufs enthält 453 Spurmarken der Maske
  32768. Dass in der Gegenprobe keine `E-125`-Zeile steht, ist also eine
  Messung und kein stummes Protokoll.
* **Regressionstest.** Die Fälle `E-125a` bis `E-125c` stehen in
  `tools/pruefstand-faelle.txt`. Damit sie laufen können, kennt
  `tools/pruefstand-lauf.ps1` seit heute den Schalter
  `messen=tools\messen-<name>.ps1` und die Quelle `messung`. Vor jedem Lauf
  legt das Skript die Postfächer mit `-Vorbereiten` neu an. Dabei löscht es
  nur unter `C:\Temp`, gegengetestet mit einem Pfad außerhalb.

## Was dieser Test nicht prüft

* **Das Ziehen mit der Maus.** Das hat nur Gregor gemacht, und nur in die
  ablehnende Richtung.
* **Eine zu weite Sperre**, also eine, die auch Entwürfe abweist. Über die
  Oberfläche würde der Fall `E-125a` sie fangen. Gegen einen so kaputten Bau
  gefahren ist er aber nicht: Die einzige Gegenprobe war 7.2.0.120, und dort
  fehlt die Sperre ganz. Den falschen Bau fängt `Eudora71/Tests/TestE125.cpp`
  am Quelltext.
* **Was am selben Weg noch offen ist, steht als eigene Befunde da:**
  * [E-141](BEFUNDE.md#e-141): Eine Übertragung nach `Out` stößt die ganze
    IMAP-Nachbearbeitung an.
  * [E-142](BEFUNDE.md#e-142): Ein IMAP-Entwurf, der nach `Out` gezogen wird,
    liegt danach doppelt da.
  * [E-143](BEFUNDE.md#e-143): Aus der Suche und aus Filtern kommt der Hinweis
    einmal je Nachricht.
* **Nebenbei gesehen:** Beim Speichern des Entwurfs kam jedes Mal der Hinweis
  „Die Rechtschreibprüfung ist in dieser Fassung nicht verfügbar". Das ist
  [E-139](BEFUNDE.md#e-139). Für diesen Test zählt der Hinweis nicht mit.
