Fehlerbehebungen und ein neuer Schalter für den Druck. Programm, ZIP und Marke tragen dieselbe
Nummer: `7.2.2.136`. Dieses Release enthält alles seit `v7.2.2.133`.

## Behoben

* **„Remember password“ speichert das Kennwort schon beim ersten Mal.**
  Bisher fragte Eudora beim nächsten Start noch einmal
  ([E-223](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-223),
  Originalfehler).
* **Ein Klick auf das Symbol einer S/MIME-signierten Mail** meldet nicht mehr
  *„Plugin no longer available“*, sondern ruft das S/MIME-Plugin auf
  ([E-222](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-222),
  Originalfehler).
* ***Edit → Find* findet ein Wort, das *Find Messages* gemeldet hat,** auch
  gleich nach dem Öffnen der Mail: bisher suchte es ab dem schon markierten
  Treffer weiter und meldete *„not found“*; jetzt sucht es dann einmal von
  oben, markiert den Treffer und scrollt ihn in den sichtbaren Bereich.
  *Weitersuchen* und F3 springen nach dem letzten Treffer stumm wieder zum
  ersten, statt *„not found“* zu melden; *„not found“* kommt nur noch, wenn
  das Wort gar nicht in der Mail steht
  ([E-193](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-193)).
* **Kein Absturz mehr beim Beenden, während der Hinweis nach dem Mailabruf
  offen ist:** Eudora schiebt das Beenden auf, bis der Hinweis mit *OK*
  geschlossen ist, und beendet sich dann von selbst
  ([E-239](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-239),
  Originalfehler).

## Neu

* **Druck und Druckvorschau mit Hintergründen auf Wunsch:** mit
  `PrintBackground=1` in `[Settings]` der `Eudora.ini` zeigen *Print* und
  *Print Preview* auch farbige Flächen und Hintergrundbilder einer HTML-Mail;
  Vorgabe `0`, also wie bisher. Eudora vorher beenden
  ([E-169](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-169)).

## Wie geprüft

Jede Behebung hat einen Regressionstest und einen Prüfstandsfall am laufenden
Programm, der am alten Bau rot und am neuen grün war
([Prüfbericht](https://github.com/HansWurst81675/Eudora7.2/blob/main/Releases/PRUEFBERICHT.md)).
Der volle Prüfstandslauf an genau diesem Bau (`7.2.2.136+2a8fd4d7`) am
06.11.2026: **110 von 110 Fällen bestanden**. Das Beenden bei offenem Hinweis
nach dem Abruf ist zusätzlich auf drei Wegen gemessen (Fenster schließen,
*Fenster schließen* aus der Taskleiste, *Exit* aus dem Menü des Symbols im
Infobereich), je mit und ohne neue Mail: kein Absturz, die abgerufene Mail
liegt im Posteingang. Getestet und freigegeben vom Projektinhaber am
06.11.2026 an seinem eigenen System.

**Rückstand an Regressionstests:** Nicht jede ältere Behebung hat schon einen
eigenen automatischen Test. Am 06.11.2026 sind es **50** behobene Befunde ohne
eigenen Testfall; von den **70** kritischen Befunden (Verlust, Schaden,
Absturz) ist keiner mehr ohne Prüfung.

## Bekannte Fehler

**Ausdrucke tragen unten den Pfad einer Zwischendatei, darin Ihr
Windows-Anmeldename** (`file:///C:/Users/<Name>/AppData/Local/Temp/eudN.htm`),
oben den Titel der HTML-Seite statt der Nachricht: Eudora setzt seine eigene
Kopf- und Fußzeile nur, wenn der Internet Explorer schon eine in der Registry
hinterlegt hat, und unter Windows 10 ist das in der Regel nicht so
([E-242](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-242);
nicht durch dieses Release entstanden, der Quelltext ist original). Eine
Abhilfe ist noch nicht gemessen; die Behebung folgt in einem späteren Release.

Was noch nicht geht, steht in der
[README unter „Bekannte Fehler“](https://github.com/HansWurst81675/Eudora7.2/blob/main/README.md#bekannte-fehler).

## Hinweis: Kennwort vergessen lassen

*Special → Forget Password(s)* löscht nur das gespeicherte Kennwort, nicht das
Häkchen *Remember password* (bei POP auch *Save password* unter *Tools →
Options → Checking Mail*). Ist es gesetzt, speichert Eudora das Kennwort beim
nächsten Abruf wieder. Wer es nicht mehr speichern will, wählt erst das Häkchen
ab und nimmt dann *Forget Password(s)*
([FAQ 21](https://github.com/HansWurst81675/Eudora7.2/blob/main/Doku/FAQ.md#21-warum-speichert-eudora-das-kennwort-nach-forget-passwords-wieder)).

## S/MIME, Junk-Filter und LDAP

Diese Zusätze brauchen `MFC71.DLL` (Microsoft, z. B. 7.10.6041.0) und
`msvcp71.dll` (Microsoft, z. B. 7.10.6052.0) **neben der `Eudora.exe`**. Das
Paket bringt sie nicht mit. Sie stammen aus einer vorhandenen Installation von
Eudora 7.1, Hermes oder Visual Studio 2003; ein offizielles
Nachinstallationspaket von Microsoft gibt es für diese Fassung nicht. **Von
DLL-Download-Seiten raten wir ab.** Ohne die beiden Dateien läuft Eudora, nur
diese Zusätze fehlen. Ob sie geladen sind, zeigt *Special → Message Plug-ins
Settings*.

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
