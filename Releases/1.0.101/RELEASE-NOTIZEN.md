**Eudora 7.2.0.101 / Paket 1.0.101**

ZIP auspacken, `Eudora starten.cmd` doppelklicken. Nichts zu installieren. Das
Mailverzeichnis im ZIP ist leer – ein vorhandenes `Mailverzeichnis` hineinkopieren.

## Neu gegenüber v1.0.87

- **Verschieben in einen IMAP-Ordner verliert keine Mail mehr.** In v1.0.87 konnte
  eine verschobene Mail spurlos verschwinden; jetzt verschwindet sie aus dem lokalen
  Postfach erst, wenn sie auf dem Server steht. Das gilt auch für gesendete Post und
  für mehrere Mails auf einmal. Sie steht nicht mehr doppelt in der Liste und trifft
  keine fremde Mail mit gleicher Nummer.
- **HTML-Mails und eingebettete Bilder** kommen beim Verschieben in einen IMAP-Ordner
  vollständig an.
- **Eudora lässt sich wieder sauber beenden**, ohne *„You currently have 1 task(s)
  running“*: eine beim Start schon fertige IMAP-Aufgabe blockierte den Ordner.
- **Ein Filter „Junk Score is less than N“** verändert sich nicht mehr beim bloßen
  Ansehen im Filterfenster.
- **Ein versteckter Vorschautext** wird nicht mehr als `? ? ? ?` über dem Inhalt
  angezeigt (an einer Prüfnachricht gemessen).

## Bekannte Fehler

Die vollständige Liste mit Abhilfe steht in der
[README, Abschnitt „Auf einen Blick“](https://github.com/HansWurst81675/Eudora7.2#auf-einen-blick-was-das-paket-kann-und-wo-noch-fehler-sind).
Die wichtigsten:

- **War der IMAP-Ordner beim Verschieben geschlossen**, erscheinen die verschobenen
  Mails erst, wenn man ihn noch einmal schließt und öffnet. Sie sind auf dem Server.
- **Selten, vermutet:** Wird eine gesendete Mail genau dann verschoben, wenn Eudora
  den Zielordner gerade abgleicht, kann sie nur im lokalen Papierkorb landen. Nach dem
  Verschieben kurz nachsehen und den Papierkorb nicht sofort leeren.
- **Eine Mail aus einem IMAP-Ordner nach `Out` ziehen** legt dort eine neue Nachricht
  mit kaputten Kopfzeilen an. Nicht nach `Out` ziehen; solche Einträge löschen, nicht
  senden.
- Adressbuch, LDAP und S/MIME fehlen weiterhin.

## Hinweis zu Windows Defender

Jede Fassung dieses Projekts ist eine neue, nicht signierte Datei. Microsoft Defender
hat eine Zwischenfassung (1.0.98) fälschlich als Trojaner eingestuft und das Programm
ohne Meldung beendet. **Dieses Paket wurde vor dem Hochladen mit Defender geprüft: 0
Funde.** Sollte Defender es bei Ihnen trotzdem melden, steht in der README unter
*Windows Defender meldet Eudora als Trojaner*, was zu tun ist.

## Prüfsumme

SHA-256 des ZIPs: `79a40bc00e2ca4d929e23f4ad5d043a8cbdab27ce9a7ab66eb58a77764e8694a`

Getestet von Gregor am 17.10.2026 an Paket 1.0.101; die Programmdateien im ZIP sind
byteidentisch mit seinem Testverzeichnis.
