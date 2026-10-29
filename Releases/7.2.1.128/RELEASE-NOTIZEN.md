Erstes Release der Reihe **7.2.1**. Ab jetzt tragen Programm, ZIP und Marke
dieselbe Nummer: `7.2.1.128`. Die letzte Zahl zählt über das bisherige
`1.0.127` hinweg weiter. Dieses Release enthält alles seit `v1.0.120`.

## Behoben

* **Konto-Eigenschaften verlieren keine Einstellungen mehr**
  ([E-166](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-166)).
  Wer *Tools → Personalities* → *Properties* mit OK schloss, verlor
  Einstellungen, die Eudora noch nicht gespeichert hatte — etwa die Antwort
  auf die Junk-Frage, die dann beim nächsten Start wiederkam.
* **`Strg+W` beendet nicht mehr ganz Eudora**, wenn eine Leiste wie
  Adressbuch, Filter oder Postfächer den Fokus hat; es versteckt jetzt diese
  Leiste ([E-137](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-137)).
* **IMAP-Ordner mit Umlauten heißen richtig** — *Entwürfe* statt
  `Entw&APw-rfe` ([E-77](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-77)).
  Umbenannte IMAP-Ordner heißen in Eudora wie auf dem Server
  ([E-146](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-146)).
* **Ziehen nach `Out`:** Eine Nachricht aus einem IMAP-Ordner nach `Out` zu
  ziehen legte eine kaputte neue Nachricht an; das wird jetzt abgelehnt
  ([E-125](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-125)).
  Bei einem Entwurf erscheint vorher ein Hinweis; übertragen wird er auf diesem
  Weg noch nicht ([E-142](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-142), offen).
* **Bilder:** zu breite Bilder werden ins Fenster eingepasst
  ([E-113](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-113)),
  `width="35px"` wird nicht mehr als 3508 gelesen
  ([E-116](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-116)),
  und Bilder, die direkt im HTML stecken, bleiben beim Antworten und
  Weiterleiten erhalten statt als grauer Kasten
  ([E-119](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-119)).
* **Weiterleiten einer Textmail** hängt kein sichtbares `</x-html>` mehr an
  ([E-158](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-158)).
* **Neue Persönlichkeit:** Windows meldet beim Anlegen nicht mehr, es sei
  kein E-Mail-Programm zugeordnet
  ([E-160](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-160)).

## Sicherheit

* Eudora vertraut den vier **eMudhra-Wurzelzertifikaten** nicht mehr, unter
  denen am 20.10.2026 kompromittierte Zwischenzertifikate bekannt wurden; die
  mitgelieferte `rootcerts.p7b` enthält sie nicht mehr. Eine eigene
  `rootcerts.p7b` im Mailverzeichnis hat Vorrang und wird nicht ersetzt
  ([E-148](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-148)).
* Zwei Stellen, an denen Speicher hinter einem Feld überschrieben werden
  konnte, sind geschlossen: beim Auflösen relativer Adressen in HTML-Mails
  ([E-111](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-111))
  und beim Abschalten einer Spalte im Fenster *Task Status*
  ([E-150](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-150)).

## Neu: häufige Fragen

[Doku/FAQ.md](https://github.com/HansWurst81675/Eudora7.2/blob/main/Doku/FAQ.md)
beantwortet 19 Fragen — Post je Konto trennen, Mails farbig markieren
(auch automatisch per Filter), Anhänge beim Leeren des Papierkorbs löschen,
Verschlüsselung und Ports, welche Einstellungen anders sind als im Original
und warum.

## Bekannte Fehler

Was noch nicht geht, steht in der
[README unter „Bekannte Fehler“](https://github.com/HansWurst81675/Eudora7.2/blob/main/README.md),
darunter neu: die Druckvorschau mancher HTML-Mails zeigt keine Bilder, ein
Label geht beim Verschieben innerhalb eines IMAP-Kontos verloren, und beim
Anlegen eines Filters mit *Make Label* waren die Labels einmal ausgegraut.

## Junk-Filter und S/MIME

Die beiden Zusätze brauchen `MFC71.DLL` und `MSVCP71.dll`, die dieses Paket
nicht mitbringt. Liegen sie schon auf dem Rechner, laden die Zusätze, und
Eudora fragt beim ersten Start damit einmal, ob Junk ins Postfach *Junk*
soll.

## Wenn Sie bereits Eudora 7.1 oder Hermes benutzen

**Sichern Sie vorher Ihre `Eudora.ini` und das komplette Mailverzeichnis.**

Dieses Projekt startet mit einem **eigenen** Mailverzeichnis und fasst eine
vorhandene Installation nicht an — `Eudora starten.cmd` hält sich daran. Wer
`Eudora.exe` direkt startet, wird gefragt; die Vorgabe ist ein frischer
Ordner, Enter kann nichts zerstören.

Parallelbetrieb mit geteilter `Eudora.ini` oder geteiltem Mailverzeichnis
geschieht **auf eigene Gefahr**. Verträglichkeit der `Eudora.ini` mit
fremden oder früheren Fassungen ist kein Ziel dieses Projekts — benutzen Sie
getrennte Verzeichnisse.

## Hinweis zu Windows Defender

Defender meldet Dateien dieses Projekts gelegentlich als Trojaner. Das ist
ein Fehlalarm ([Einzelheiten](https://github.com/HansWurst81675/Eudora7.2/blob/main/Releases/DEFENDER-FEHLALARM.md));
gegebenenfalls muss die Datei aus der Quarantäne zurückgeholt werden.
