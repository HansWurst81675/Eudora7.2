**Eudora 7.2.0.113 / Paket 1.0.113**

> ## Diese Fassung behebt einen Schaden an fremden Installationen
>
> Ein Anwender hat am 18.10.2026 gemeldet
> ([#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)), dass sein
> **Hermes 7.1.0.9 nach dem Lauf unserer Fassung `v1.0.101` nicht mehr startet**
> — `EXCEPTION_ACCESS_VIOLATION` in `MFC71.DLL`. Unsere Spur: in der gemeinsam
> benutzten `Eudora.ini` stand `MRUFloatXPos=-2147483648`, eine ungültige
> Fensterposition, die wir beim Beenden hineingeschrieben hatten. **Belegt ist,
> dass wir sie schreiben — nicht, dass sie den Absturz verursacht hat**:
> `-2147483648` ist `CW_USEDEFAULT`, ein Wert, den MFC selbst setzt und beim
> Lesen wieder abfängt. Die Ursache ist damit weiter offen.
>
> **Nachgestellt und behoben.** Ein einziges Starten und Beenden der Fassung
> 7.2.0.112 genügte, um den Wert dreimal in die Datei zu schreiben; mit
> 7.2.0.113 steht dort eine gültige Position und **kein** `INT_MIN` mehr. Der
> Befund läuft bei uns als **[E-131](https://github.com/HansWurst81675/Eudora7.2/blob/main/BEFUNDE.md#e-131)**.
>
> **Was wir nicht prüfen konnten:** ob eine daneben installierte Hermes 7.1
> danach wieder startet — wir haben kein Hermes. Wer das testen kann, wird in
> [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102) darum gebeten.
>
> **Trotzdem vorher sichern:** wer bereits ein Eudora oder Hermes 7.1
> installiert hat, legt eine Kopie von `Eudora.ini` und dem Mailverzeichnis an.
> Eine bereits beschädigte Datei wird von dieser Fassung erst beim **nächsten
> Sichern** berichtigt — der Leseweg ist noch offen.

ZIP auspacken, `Eudora starten.cmd` doppelklicken. Nichts zu installieren. Das
Mailverzeichnis im ZIP ist leer – ein vorhandenes `Mailverzeichnis` hineinkopieren.

## Neu gegenüber v1.0.112

- **Keine ungültige Fensterposition mehr in der `Eudora.ini`.** Beim Beenden
  schrieb Eudora eine nie gesetzte Schwebeposition (`-2147483648`) in die
  Datei; eine daneben installierte Eudora oder Hermes 7.1 stürzte danach beim
  Start ab. Jetzt wird jede unbrauchbare Position durch eine ersetzt, die auf
  dem Bildschirm liegt.

## Neu gegenüber v1.0.101
- **Beenden wartet jetzt auf jede Art von Übertragung.** Wird eine Nachricht in
  einen IMAP-Ordner verschoben und Eudora sofort beendet, bleibt das Fenster
  stehen, bis die Übertragung durch ist — auch wenn **innerhalb** desselben
  IMAP-Kontos verschoben wurde. Bis 7.2.0.110 zählte die Wache nur
  Übertragungen aus einem lokalen Postfach, und der andere Weg lief an ihr
  vorbei.
- **Keine Flut von Fehlermeldungen mehr beim Filtern.** Konnte Eudora eine Nachricht
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

- **`Eudora.exe` nicht direkt doppelklicken.** Ohne Angabe des Mailverzeichnisses
  sucht Eudora sich eines und findet dabei über die Registry das einer
  **vorhandenen** Eudora- oder Hermes-Installation — auch in einem ganz anderen
  Ordner — und schreibt dann in deren `Eudora.ini`. Immer `Eudora starten.cmd`
  benutzen; eine Verknüpfung bekommt den Pfad mit:
  `Eudora.exe "C:\…\Mailverzeichnis"`. Das ist der Weg hinter #102
  ([E-132](https://github.com/HansWurst81675/Eudora7.2/blob/main/BEFUNDE.md#e-132));
  in dieser Fassung ist er **noch offen**, behoben erst in 7.2.0.114.

- **Eine bereits beschädigte `Eudora.ini`** — etwa von einer älteren Fassung
  dieses Projekts — wird erst beim **nächsten Sichern** berichtigt; der Leseweg
  ist noch offen ([#102](https://github.com/HansWurst81675/Eudora7.2/issues/102),
  bei uns [E-131](https://github.com/HansWurst81675/Eudora7.2/blob/main/BEFUNDE.md#e-131)). Vorher eine Kopie anlegen.
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
hat Zwischenfassungen fälschlich als Trojaner eingestuft und das Programm ohne Meldung
beendet — zuletzt am 20.10.2026 eine Fassung, die **acht Minuten zuvor** mit 0 Funden
geprüft worden war.

**Dieses Paket wurde vor dem Hochladen mit Defender geprüft: 0 Funde** (34 Dateien).
**Das ist kein Freispruch**, sondern nur der Nachweis, dass zu diesem Zeitpunkt nichts
bekannt war: das Urteil über eine neue, unsignierte Datei entsteht erst, wenn
Microsofts Lernverfahren sie bewertet hat — und das kann Minuten später sein. Sollte
Defender es bei Ihnen melden, steht in der README unter *Windows Defender meldet Eudora
als Trojaner*, was zu tun ist.

## Prüfsumme

SHA-256 des ZIPs: `0d1d4bf43eab8323f2ce3ad2ff1c78f44af5c7adf7a84e979334aab5687f4772`

## Was geprüft wurde – und was nicht

- **234 Tests, 234 bestanden** gegen genau diesen Bau; `paket-pruefen.ps1` ohne
  Fehler, Defender 0 Funde bei 34 Dateien, Kriterium 0 erfüllt.
- **Am Prüfstand gemessen, rot und grün:** mit der Vorgängerfassung schrieb ein
  einziges Starten und Beenden `MRUFloatXPos=-2147483648` dreimal in die
  `Eudora.ini`; mit dieser Fassung steht dort eine gültige Position und **null**
  Treffer für `INT_MIN` — zwei Läufe hintereinander, gleiches Ergebnis.
- **Nicht geprüft:** ob eine daneben installierte Hermes 7.1 danach wieder
  startet. Dazu fehlt uns Hermes; wer es testen kann, wird in
  [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102) darum gebeten.
- **Von Gregor am 20.10.2026 bestätigt:** eine über *File → Save As* gespeicherte
  Nachricht wird in Chrome richtig dargestellt (Paket 1.0.110, gleicher Code).
- **Am Programm gemessen:** die Zusammenfassung der Filtermeldungen — ein
  übersprungener Fall ergibt einen Eintrag, drei ergeben einen Eintrag und einen
  Sammeleintrag, und ein zweiter Filterlauf im selben Programmlauf meldet wieder.
- **Der Beenden-Weg stammt aus Gregors Lauf an 1.0.110:** Verschieben innerhalb
  eines IMAP-Kontos und sofortiges Beenden — das Fenster verschwand, obwohl eine
  Aufgabe in der Warteschlange stand. Behoben in 7.2.0.111, abgesichert durch
  eine eigene Schranke (`tools/pruefe-e123-zaehlung.pl`, Gegenprobe am
  Fehlerstand 2 von 2 rot).
- **Von Gregor am 20.10.2026 an Paket 1.0.111 am laufenden Programm bestätigt,
  auf beiden Wegen:** aus einem lokalen Postfach in einen IMAP-Ordner (Eudora
  wartete **6015 ms**) und innerhalb desselben IMAP-Kontos (**4015 ms**). Beide
  Male brachte Eudora die Übertragung zu Ende und beendete sich dann sauber;
  die Warteschlange war danach leer. An 1.0.110 war das Fenster beim zweiten
  Weg sofort weg.
