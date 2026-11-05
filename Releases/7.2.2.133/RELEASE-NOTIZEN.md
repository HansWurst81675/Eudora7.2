Fehlerbehebungen, keine neue Funktion. Programm, ZIP und Marke tragen dieselbe
Nummer: `7.2.2.133`. Dieses Release enthält alles seit `v7.2.2.132`.

## Behoben

* **Kein Mailverlust mehr beim Verschieben zwischen zwei IMAP-Konten oder aus
  IMAP in ein lokales Postfach:** Eudora löscht die Mail in der Quelle nur
  noch, wenn sie im Ziel vollständig angekommen ist. Die scheinbar doppelten
  Einträge im Zielordner entstehen nicht mehr
  ([E-188](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-188),
  Originalfehler).
* **Find Messages mit Umlauten und `€`:** Ohne Umlaut im Suchbegriff bleibt es
  beim schnellen Suchindex. Mit Umlaut oder `€` sucht Eudora genau und findet
  nur Mails, in denen das Zeichen wirklich steht, auch in HTML-Mails, die es
  nur als HTML-Entität enthalten (`&auml;`, `&euro;`). Bisher fand die Suche
  mit „€“ jede Mail und mit „öft“ auch „oft“
  ([E-193](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-193)).
* **Mehrere IMAP-Mails in den Papierkorb, nach Junk oder per Filter:** jeder
  Eintrag im Ziel zeigt wieder Betreff und Absender seiner eigenen Mail
  ([E-192](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-192),
  Originalfehler).
* ***Festbreite* im Bearbeiten-Modus** schreibt kein `t;` mehr in den Text
  ([E-199](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-199),
  Originalfehler).
* ***Speichern unter* schlägt einen Dateinamen vor, der sich ohne Änderung
  speichern lässt:** die Umlaute des Betreffs bleiben, verbotene Zeichen
  werden zu einem Leerzeichen, der Name ist bis zu 120 Zeichen lang
  ([E-220](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-220)).
* **Ein langer Betreff mit Umlauten** behält in der Postfachliste seine ersten
  sieben Zeichen, auch bei Mails anderer Programme
  ([E-221](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-221),
  Originalfehler).

## Wie geprüft

Jede Behebung hat einen Regressionstest und einen Prüfstandsfall am laufenden
Programm, der am alten Bau rot und am neuen grün war. Am Bau dieses Pakets:
**421 Unit-Tests und 19 Schranken, alle bestanden**; von den 96
Prüfstandsfällen liefen 6 an genau diesem Bau, die übrigen 90 an den Bauten
der einzelnen Behebungen, keiner rot
([Prüfbericht](https://github.com/HansWurst81675/Eudora7.2/blob/main/Releases/PRUEFBERICHT.md)).
Dazu Gregors Test an seinem eigenen System am 04.11.2026
([Testplan](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/TESTPLAN.md#test-7-2-2-133)).
Er hat dabei die neuen Fehler unten gefunden. Alle stammen aus dem Original,
keiner kostet Mails.

## Bekannte Fehler

Was noch nicht geht, steht in der
[README unter „Bekannte Fehler“](https://github.com/HansWurst81675/Eudora7.2/blob/main/README.md#bekannte-fehler),
darunter, gefunden in Gregors Test an diesem Paket:

* **„Remember password“ wirkt erst beim zweiten Mal:** wer das Häkchen zum
  ersten Mal setzt, wird beim nächsten Start noch einmal nach dem Kennwort
  gefragt; nach der zweiten Eingabe ist es gespeichert
  ([E-223](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-223)).
* **S/MIME-signierte Mails:** ein Klick auf das Anhangsymbol meldet *„Plugin
  no longer available“*, der Inhalt erscheint nicht
  ([E-222](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-222)).
* ***Edit → Find* im geöffneten Fenster** übersieht in manchen HTML-Mails
  (etwa weitergeleiteten Rundmails aus Outlook) ein sichtbares Wort mit
  Umlaut; *Find Messages* findet die Mail
  ([E-193](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-193)).

Die Behebungen kommen mit 7.2.2.134.

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
