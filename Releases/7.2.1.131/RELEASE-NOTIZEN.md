Zweites Release der Reihe **7.2.1** — Fehlerbehebungen, keine neuen
Funktionen. Programm, ZIP und Marke tragen dieselbe Nummer: `7.2.1.131`.
Dieses Release enthält alles seit `v7.2.1.128`, auch die beiden nicht
veröffentlichten Testpakete 7.2.1.129 und 7.2.1.130.

## Behoben

* **Speichern unter nennt den Zeichensatz.** *File → Save As* aus dem
  Nachrichten- und aus dem Verfassen-Fenster schreibt jetzt den Zeichensatz
  in die Datei; andere Programme zeigen Umlaute und `€` damit richtig
  ([E-140](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-140)).
* **Emoji gehen beim Speichern nicht mehr verloren.** *Strg+S* und
  *Speichern unter* als `.htm` (am laufenden Programm noch nicht gemessen)
  schreiben Zeichen außerhalb des
  westeuropäischen Zeichensatzes als HTML-Angabe statt als `??`; im
  Bearbeiten-Modus lassen *Link einfügen* und *Festbreite* sie stehen
  ([E-136](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-136),
  [E-178](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-178)).
  Als `.txt` gespeichert bleibt ein Ersatzzeichen — eine solche Textdatei
  kann kein Emoji tragen.
* **Textfassung von HTML-Mails:** aus `&#128293;` wird nicht mehr ein
  einzelnes falsches Zeichen (Nachtrag 02.11.2026: am Prüfstand beim Senden als
  reiner Text bestätigt; der Textteil neben dem HTML-Teil und die Suche sind
  nicht gemessen)
  ([E-179](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-179)).
* **Filter mit „doesn't appear“** trifft nur noch die richtigen Nachrichten,
  nicht mehr jede (am Quelltext und im Regressionstest gesichert, am
  laufenden Programm noch nicht gemessen)
  ([E-72](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-72)).
* **Filter nach `Out`:** *Out* wird als Filterziel nicht mehr angeboten; ein
  älterer Filter mit diesem Ziel hält den Abruf nicht mehr an (am laufenden
  Programm noch nicht gemessen). Aus dem
  Suchfenster nach *Out* kommt **ein** Hinweis statt einem je Treffer
  ([E-143](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-143)).
* **Filteraktion *Notify Application*** übergibt dem anderen Programm keine
  falsche Zeichensatzangabe mehr
  ([E-177](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-177)).
* **IMAP:** Das Eingangsdatum einer Mail, die man aus einem lokalen Postfach
  in einen IMAP-Ordner überträgt, liegt nicht mehr um die Zeitzone zu früh
  ([E-122](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-122)).
  Beim Verschieben innerhalb eines IMAP-Kontos bleibt das Label meistens
  erhalten, wenn der Server die neuen Nummern meldet (Nachtrag 02.11.2026, am
  Prüfstand gemessen: das tat schon 7.2.1.128; meldet der Server sie nicht,
  geht das Label weiter verloren, 7.2.1.131 schreibt dann nur den Grund ins
  Protokoll) — auch an einem Server, der die Nummern meldet, ging es am
  29.10.2026 einmal verloren, die Ursache ist offen (Nachtrag 03.11.2026)
  ([E-170](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-170)),
  und Eudora überschreibt im Zielordner nicht mehr Betreff und Absender einer
  fremden Mail mit derselben Nummer
  ([E-184](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-184),
  [E-189](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-189)).
  Für mehrere Mails auf einmal in den Papierkorb, nach Junk oder per Filter
  gilt das noch nicht
  ([E-192](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-192),
  siehe *Bekannte Fehler*).
* **Antwortentwurf zurück nach `Out`** behält `In-Reply-To` und `References`;
  die Antwort bleibt beim Empfänger im Gesprächsfaden
  ([E-144](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-144)).
* **Kleinere:** der Hinweis auf die fehlende Rechtschreibprüfung lässt sich
  abschalten ([E-139](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-139));
  *Search Mailfolder* ohne markierten Text bringt keine Fehlermeldung mehr
  ([E-171](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-171));
  die Vervollständigungsbox im `To:`-Feld ist richtig bemessen
  ([E-165](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-165));
  Base64-Text mit ungültigen Bytes wird nicht mehr falsch dekodiert
  ([E-145](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-145));
  eine Übertragung aus einem IMAP-Ordner nach `Out` stößt die
  IMAP-Nachbearbeitung samt Bereinigen des Ordners am Server (*Expunge*)
  nicht mehr an
  ([E-141](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-141)),
  und beim Schließen einer neuen Nachricht ohne Speichern liest Eudora nicht
  mehr aus schon freigegebenem Speicher
  ([E-176](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-176))
  — beide am Quelltext und im Regressionstest gesichert (Nachtrag 02.11.2026:
  E-141 am Prüfstand bestätigt; E-176 auf dem Prüfstand nicht messbar).

Neu im Repository, nicht im Paket: eine Übersicht, was Eudora kann und wo
man es findet — Menüs, Tastenkürzel, Einstellungen, Filter
([Doku/FUNKTIONEN.md](https://github.com/HansWurst81675/Eudora7.2/blob/main/Doku/FUNKTIONEN.md)).

## Wie geprüft

Jede Behebung hat einen Regressionstest, die meisten zusätzlich einen
Prüfstandsfall am laufenden Programm, der am alten Bau rot und am neuen grün
war. Unit-Tests, Schranken und Prüfstandsfälle des Baus stehen im
[Prüfbericht](https://github.com/HansWurst81675/Eudora7.2/blob/main/Releases/PRUEFBERICHT.md),
dazu Gregors Test an seinem eigenen System am 02.11.2026: alle sieben
Schritte bestanden
([Testplan](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/TESTPLAN.md#test-7-2-1-131)).

**Rückstand an Regressionstests:** nicht jeder früher behobene Fehler hat
schon einen automatischen Test. Bei den kritischen Befunden sind es am
02.11.2026 noch **6 von 70** ohne jede Prüfung; sie werden nachgeliefert
([ZIEL.md, Regressionstests](https://github.com/HansWurst81675/Eudora7.2/blob/main/ZIEL.md#regressionstests--anordnung-vom-22102026)).

## Bekannte Fehler

Was noch nicht geht, steht in der
[README unter „Bekannte Fehler“](https://github.com/HansWurst81675/Eudora7.2/blob/main/README.md#bekannte-fehler),
darunter:

* *Festbreite* im Bearbeiten-Modus schreibt `t;` sichtbar in den Text
  ([E-199](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-199)).
* Die Suche mit Umlauten oder `€` liefert widersprüchliche Ergebnisse
  ([E-193](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-193)).
* Werden mehrere IMAP-Mails auf einmal in den Papierkorb, nach Junk oder per
  Filter verschoben, oder Mails zwischen zwei IMAP-Konten, kann der Eintrag
  im Zielordner Betreff und Absender einer anderen Mail zeigen. Beim
  Papierkorb, Junk und Filtern geht auf dem Server nichts verloren; ob beim
  Verschieben zwischen zwei Konten etwas verloren gehen kann, ist nicht
  untersucht
  ([E-192](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-192),
  [E-188](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-188)).
* *Speichern unter* hat kleine Mängel bei Zeichensatz und Dateiformat
  ([E-194](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-194),
  [E-195](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-195),
  [E-196](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-196),
  [E-198](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-198)).

## Junk-Filter und S/MIME

Die beiden Zusätze brauchen `MFC71.DLL` und `MSVCP71.dll`, die dieses Paket
nicht mitbringt. Liegen sie schon auf dem Rechner, laden die Zusätze.

## Wenn Sie bereits Eudora 7.1 oder Hermes benutzen

**Sichern Sie vorher Ihre `Eudora.ini` und das komplette Mailverzeichnis.**

Dieses Projekt startet mit einem **eigenen** Mailverzeichnis und fasst eine
vorhandene Installation nicht an — `Eudora starten.cmd` hält sich daran. Wer
`Eudora.exe` direkt startet, wird gefragt; die Vorgabe ist ein frischer
Ordner, Enter kann nichts zerstören.

Parallelbetrieb mit geteilter `Eudora.ini` oder geteiltem Mailverzeichnis
geschieht **auf eigene Gefahr**.

## Hinweis zu Windows Defender

Defender meldet Dateien dieses Projekts gelegentlich als Trojaner. Das ist
ein Fehlalarm ([Einzelheiten](https://github.com/HansWurst81675/Eudora7.2/blob/main/Releases/DEFENDER-FEHLALARM.md));
gegebenenfalls muss die Datei aus der Quarantäne zurückgeholt werden.

*Die mit „Nachtrag 02.11.2026“ markierten Stellen ([LEKTOR-134](../../Befunde/LEKTOR-134.md#l-134.1)) stehen seit dem 02.11.2026 auch im veröffentlichten Text auf GitHub (Gregor: *„ja, berichtige den text auf github“*); das ZIP ist unverändert.*
