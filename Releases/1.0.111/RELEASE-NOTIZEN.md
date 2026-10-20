**Eudora 7.2.0.111 / Paket 1.0.111**

ZIP auspacken, `Eudora starten.cmd` doppelklicken. Nichts zu installieren. Das
Mailverzeichnis im ZIP ist leer – ein vorhandenes `Mailverzeichnis` hineinkopieren.

## Neu gegenüber v1.0.101

- **Beenden wartet jetzt auf jede Art von Übertragung.** Wird eine Nachricht in
  einen IMAP-Ordner verschoben und Eudora sofort beendet, bleibt das Fenster
  stehen, bis die Übertragung durch ist — auch wenn **innerhalb** desselben
  IMAP-Kontos verschoben wurde. Bis 7.2.0.110 zählte die Wache nur
  Übertragungen aus einem lokalen Postfach, und der andere Weg lief an ihr
  vorbei.
  nicht lesen, legte es je Nachricht einen eigenen Eintrag in *Task Errors* an – jeder
  mit Piepton und Fenstersprung. Bei einem IMAP-Postfach mit 500 angerissenen
  Nachrichten waren das 500 Pieptöne, nicht wegzuklicken. Jetzt bekommt der **erste**
  Fall einen Eintrag, der Rest wird zu **einem** Sammeleintrag zusammengefasst, und es
  piept höchstens einmal je zwei Sekunden.
- **Eine gespeicherte Nachricht ist in anderen Programmen wieder lesbar.** Über
  *File → Save As* gesicherte Post in `windows-1251`, `koi8-r` oder `iso-8859-2`
  behält ihre richtige Zeichensatzangabe; eine echte mehrteilige Nachricht wird nicht
  mehr zu `text/plain` gemacht, so dass ihr Anhang erhalten bleibt.
- **Beenden während einer Übertragung ist sicherer geworden.** Läuft noch ein
  Hochladen in einen IMAP-Ordner oder steht ein Dialog offen, wird nach fünf Minuten
  nicht mehr erzwungen beendet, sondern das Beenden aufgegeben – mit dem Grund in der
  Statuszeile. Ein zweiter *File → Exit* wartet wieder, statt in einen unsichtbaren
  Hänger zu führen.

## Bekannte Fehler

Die vollständige Liste mit Abhilfe steht in der
[README, Abschnitt „Auf einen Blick“](https://github.com/HansWurst81675/Eudora7.2#auf-einen-blick-was-das-paket-kann-und-wo-noch-fehler-sind).
Die wichtigsten:

- **Eine über *File → Save As* gespeicherte Nachricht heißt immer `.txt`, auch wenn
  ihr Inhalt HTML ist** – ohne Hinweis. Zum Ansehen die Datei in `.html` umbenennen
  und im Browser öffnen, oder in `.eml` und in Thunderbird.
- **Wird ohne Serververbindung in einen IMAP-Ordner verschoben und sofort beendet**,
  zeigt der Zielordner danach nur einen Teil der Nachrichten. **Nichts geht verloren:**
  die Nachrichten stehen weiter im Ausgangspostfach. Sichtbar werden sie über
  *Rechtsklick auf das Postfach → Show Deleted Messages*, und mit *Message → UnDelete*
  holt man sie endgültig zurück. *Message → Purge Messages* dabei nicht benutzen –
  das entfernt sie.
- **War der IMAP-Ordner seit dem Start noch nie geöffnet**, erscheinen die dorthin
  verschobenen Mails erst, wenn man ihn noch einmal schließt und öffnet. Sie sind auf
  dem Server.
- **Selten, vermutet:** Wird eine gesendete Mail genau dann verschoben, wenn Eudora
  den Zielordner gerade abgleicht, kann sie nur im lokalen Papierkorb landen. Nach dem
  Verschieben kurz nachsehen und den Papierkorb nicht sofort leeren.
- **Eine Mail aus einem IMAP-Ordner nach `Out` ziehen** legt dort eine neue Nachricht
  mit kaputten Kopfzeilen an. Nicht nach `Out` ziehen; solche Einträge löschen, nicht
  senden.
- Nach einem Absturz, einem Eingriff von Defender oder einem Stromausfall können einer
  gerade verschobenen Nachricht eingebettete Bilder fehlen.
- Adressbuch, LDAP und S/MIME fehlen weiterhin.

## Hinweis zu Windows Defender

Jede Fassung dieses Projekts ist eine neue, nicht signierte Datei. Microsoft Defender
hat eine Zwischenfassung (1.0.98) fälschlich als Trojaner eingestuft und das Programm
ohne Meldung beendet. **Dieses Paket wurde vor dem Hochladen mit Defender geprüft: 0
Funde** (34 Dateien). Sollte Defender es bei Ihnen trotzdem melden, steht in der README
unter *Windows Defender meldet Eudora als Trojaner*, was zu tun ist.

## Prüfsumme

SHA-256 des ZIPs: `72350cc64b86b8dd0713618e471c71c0883089353d64659ba435bdb57bf3e0a8`

## Was geprüft wurde – und was nicht
## Was geprüft wurde – und was nicht

- **229 Tests, 229 bestanden** gegen genau diesen Bau; `paket-pruefen.ps1` ohne
  Fehler, Defender 0 Funde bei 34 Dateien, Kriterium 0 erfüllt.
- **Von Gregor am 20.10.2026 bestätigt:** eine über *File → Save As* gespeicherte
  Nachricht wird in Chrome richtig dargestellt (Paket 1.0.110, gleicher Code).
- **Am Programm gemessen:** die Zusammenfassung der Filtermeldungen — ein
  übersprungener Fall ergibt einen Eintrag, drei ergeben einen Eintrag und einen
  Sammeleintrag, und ein zweiter Filterlauf im selben Programmlauf meldet wieder.
- **Der Fehler, den diese Fassung behebt, stammt aus Gregors Lauf an 1.0.110:**
  Verschieben innerhalb eines IMAP-Kontos und sofortiges Beenden — das Fenster
  verschwand, obwohl eine Aufgabe in der Warteschlange stand. Die Behebung ist
  am Quelltext belegt und durch eine eigene Schranke abgesichert
  (`tools/pruefe-e123-zaehlung.pl`, Gegenprobe am Fehlerstand 2 von 2 rot).
- **Von Gregor am 20.10.2026 an Paket 1.0.111 am laufenden Programm bestätigt,
  auf beiden Wegen:** aus einem lokalen Postfach in einen IMAP-Ordner (Eudora
  wartete **6015 ms**) und innerhalb desselben IMAP-Kontos (**4015 ms**). Beide
  Male brachte Eudora die Übertragung zu Ende und beendete sich dann sauber;
  die Warteschlange war danach leer. An 1.0.110 war das Fenster beim zweiten
  Weg sofort weg.
