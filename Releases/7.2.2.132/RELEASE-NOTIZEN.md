Erstes Release der Reihe **7.2.2**, mit neuen Funktionen und Fehlerbehebungen.
Programm, ZIP und Marke tragen dieselbe Nummer: `7.2.2.132`. Dieses Release
enthält alles seit `v7.2.1.131`.

## Neu

* **Hilfe-Menü:** *Help → Keyboard Shortcuts* und *Help → Settings Reference*
  zeigen alle Tastenkürzel bzw. alle Einstellungen aus *Tools → Options* samt
  ihren `Eudora.ini`-Schlüsseln als Seite im Standard-Browser
  ([A-5](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#a-5)).
* **About-Dialog:** neuer Knopf *Latest Release*, der diese Release-Seite
  öffnet. Die Knöpfe überdecken sich nicht mehr, und die Pfadzeilen
  *Mail folder from* und *Log* haben Platz für zwei Zeilen
  ([E-216](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-216)).
* ***Speichern unter* schlägt die passende Endung vor:** aus der
  Postfachliste `.eml`, wenn die Datei einen Kopf trägt (mit Kopfzeilen, bei
  HTML oder Umlauten), sonst `.txt`; aus Nachrichten- und Verfassen-Fenster
  `.htm` für HTML-Nachrichten, sonst `.txt`
  ([E-128](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-128)).

## Behoben

* **Speichern unter:** keine internen `<x-flowed>`-Zeilen mehr in der Datei
  ([E-194](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-194)),
  kein irreführendes *Rtf Files* für Nachrichten
  ([E-195](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-195)),
  eine `.htm`-Datei nennt ihren Zeichensatz
  ([E-196](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-196)),
  mit Kopfzeilen stimmt das Datum
  ([E-205](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-205)),
  und aus dem Signaturfenster entsteht keine leere Datei mehr
  ([E-207](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-207)).
* **Fehlt das gespeicherte Mailverzeichnis,** fragt Eudora beim Start nach
  einem anderen Ordner, statt sich zu beenden
  ([E-133](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-133));
  ein Mailverzeichnis in einem Pfad mit Leerzeichen auf einem Laufwerk ohne
  Kurznamen wird wiedergefunden
  ([E-209](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-209)).
* **Persönlichkeiten:** eine gelöschte Persönlichkeit kommt nicht in die
  `Eudora.ini` zurück
  ([E-39](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-39));
  eine neue Persönlichkeit erbt nicht das Kennwort einer gelöschten
  gleichen Namens
  ([E-204](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-204));
  *Change Password* lässt nicht mehr die falsche Persönlichkeit als aktuelle
  stehen
  ([E-203](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-203),
  [E-210](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-210),
  [E-211](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-211)).
* **Label beim Verschieben im IMAP-Konto:** bleibt jetzt auch an Servern ohne
  UIDPLUS erhalten; ist die Zuordnung nicht eindeutig, setzt Eudora lieber
  kein Label als ein falsches
  ([E-170](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-170)).
* **Vorgabeendung in fünf weiteren Dialogen** kam aus schon freigegebenem
  Speicher (Originalfehler)
  ([E-214](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-214)).

## Wie geprüft

Jede Behebung hat einen Regressionstest, die meisten zusätzlich einen
Prüfstandsfall am laufenden Programm, der am alten Bau rot und am neuen grün
war. Am Bau dieses Pakets: **408 Unit-Tests, 19 Schranken, 81
Prüfstandsfälle, alle bestanden**
([Prüfbericht](https://github.com/HansWurst81675/Eudora7.2/blob/main/Releases/PRUEFBERICHT.md)),
dazu Gregors Test an seinem eigenen System am 03.11.2026: alle zwölf
Schritte bestanden
([Testplan](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/TESTPLAN.md#test-7-2-2-132)).

## Bekannte Fehler

Was noch nicht geht, steht in der
[README unter „Bekannte Fehler“](https://github.com/HansWurst81675/Eudora7.2/blob/main/README.md#bekannte-fehler),
darunter:

* Der **vorgeschlagene Dateiname** bei *Speichern unter* verliert Umlaute
  und ist auf 63 Zeichen gekürzt. Den Namen bei Bedarf von Hand ändern. Die
  Behebung ist in Arbeit.
* Ein langer **Betreff mit Umlauten** kann in der Postfachliste um seine
  ersten sieben Zeichen gekürzt erscheinen, wenn der Absender die Kopfzeile
  gleich hinter `Subject:` umbricht; Eudora selbst tut das bei etwa jedem
  fünften Umlaut-Betreff von 40 bis 60 Zeichen.
  Die Nachricht selbst ist vollständig. Das war schon vor 7.2.2 so (Originalfehler); die
  Behebung ist in Arbeit.
* Werden mehrere IMAP-Mails auf einmal in den Papierkorb, nach Junk oder per
  Filter verschoben, kann der Eintrag im Zielordner Betreff und Absender
  einer anderen Mail zeigen; auf dem Server geht nichts verloren
  ([E-192](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-192);
  die Behebung ist in Arbeit). Beim Verschieben zwischen zwei IMAP-Konten
  ist dasselbe möglich
  ([E-188](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-188)).
* *Festbreite* im Bearbeiten-Modus schreibt `t;` sichtbar in den Text
  ([E-199](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-199)).
* Die Suche mit Umlauten oder `€` liefert widersprüchliche Ergebnisse
  ([E-193](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-193)).

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
