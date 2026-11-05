Fehlerbehebungen, keine neue Funktion. Programm, ZIP und Marke tragen dieselbe
Nummer: `7.2.2.134`. Dieses Release enthält alles seit `v7.2.2.133`.

> Entwurf vom 05.11.2026 für das Testpaket 7.2.2.134. Veröffentlicht wird
> erst nach Gregors Test und Ja; dann kommt sein Ergebnis unter „Wie geprüft“.

## Behoben

* **„Remember password“ speichert das Kennwort schon beim ersten Mal.**
  Bisher fragte Eudora beim nächsten Start noch einmal
  ([E-223](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-223),
  Originalfehler).
* **Ein Klick auf das Symbol einer S/MIME-signierten Mail** meldet nicht mehr
  *„Plugin no longer available“*, sondern ruft das S/MIME-Plugin auf
  ([E-222](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-222),
  Originalfehler).

## Wie geprüft

Jede Behebung hat einen Regressionstest und einen Prüfstandsfall am laufenden
Programm, der am alten Bau rot und am neuen grün war
([Prüfbericht](https://github.com/HansWurst81675/Eudora7.2/blob/main/Releases/PRUEFBERICHT.md)).

## Bekannte Fehler

Was noch nicht geht, steht in der
[README unter „Bekannte Fehler“](https://github.com/HansWurst81675/Eudora7.2/blob/main/README.md#bekannte-fehler),
darunter:

* ***Edit → Find* im geöffneten Fenster** übersieht in manchen HTML-Mails ein
  sichtbares Wort mit Umlaut; *Find Messages* findet die Mail. Die Ursache ist
  noch nicht gefunden
  ([E-193](https://github.com/HansWurst81675/Eudora7.2/blob/main/Intern/BEFUNDE.md#e-193)).

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
