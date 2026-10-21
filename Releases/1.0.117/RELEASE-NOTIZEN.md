**Eudora 7.2.0.117 / Paket 1.0.117**

> ## Diese Fassung kann neben einer vorhandenen Eudora oder Hermes laufen
>
> Der Melder aus [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)
> schrieb, die neue Installation habe *über Registry-Abfragen* die vorhandene
> in einem anderen Ordner gefunden und deren INI verändert.
> [v1.0.113](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.113)
> hat den **Schaden** behoben — diese Fassung schließt den **Weg** dorthin.
>
> **Was passierte.** Wer `Eudora.exe` doppelklickt statt `Eudora starten.cmd`
> zu benutzen, überlässt Eudora die Suche nach dem Mailverzeichnis. Liegt
> keine `Eudora.ini` neben der EXE — in unseren Paketen liegt sie in
> `Mailverzeichnis\` —, liest Eudora
> `HKEY_CURRENT_USER\Software\Qualcomm\Eudora\CommandLine\Current` und
> übernimmt **stillschweigend** den Datenordner, mit dem zuletzt irgendeine
> Eudora oder Hermes gestartet wurde.
>
> **Jetzt fragt es vorher**, mit drei Wegen: *Yes* (das fremde Verzeichnis
> trotzdem benutzen), *No* (ein eigenes neben dem Programm anlegen), *Cancel*
> (beenden, ohne etwas anzufassen). **Vorgabe ist *No***, damit ein
> unbedachtes Enter nichts beschädigt. Die Antwort wird gemerkt, so dass die
> Frage nicht bei jedem Start wiederkommt. Der Befund läuft bei uns als
> **[E-132](https://github.com/HansWurst81675/Eudora7.2/blob/main/BEFUNDE.md#e-132)**.
>
> **Was wir nicht prüfen konnten:** ob eine daneben installierte Hermes 7.1
> danach wieder startet — wir haben kein Hermes. Wer das testen kann, wird in
> [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102) darum gebeten.
>
> **Trotzdem vorher sichern.** Wer bereits ein Eudora oder Hermes 7.1
> installiert hat, legt eine Kopie von `Eudora.ini` und dem Mailverzeichnis an,
> bevor er diese Fassung startet.

ZIP auspacken, `Eudora starten.cmd` doppelklicken. Nichts zu installieren.

## Neu gegenüber v1.0.113

- **Eudora fragt, bevor es ein fremdes Mailverzeichnis übernimmt.** Siehe oben.
  Startet man wie vorgesehen über `Eudora starten.cmd`, ändert sich nichts —
  die Frage kommt nur, wenn Eudora selbst suchen muss **und** fündig wird.
- **Die Frage kommt auf jedem Startweg.** Nicht nur beim Doppelklick auf
  `Eudora.exe`, sondern auch über einen `mailto:`-Verweis, eine Postfachdatei
  (`.mbx`), Briefpapier (`.sta`) und jede auf Eudora gezogene Datei. Auf
  diesen vier Wegen war das Programmverzeichnis intern noch nicht gesetzt, und
  die Prüfung stieg wortlos mit *nicht fremd* aus.
- **Das eigene Mailverzeichnis gilt nicht mehr als fremd.** Die Registry führt
  den Pfad als 8.3-Kurzform (`EUDORA~1.114`), das Programm kannte ihn als
  Langform — dadurch fragte Eudora bei **jedem** Start nach seinem eigenen
  Ordner. Beide Seiten werden jetzt aufgelöst, und der Dialog zeigt den
  ausgeschriebenen Pfad.
- **Die Antwort wird gemerkt**, je fremdem Verzeichnis, in der `DEudora.ini`
  neben der EXE. *Cancel* wird nicht gemerkt. Wie man eine gemerkte Antwort
  wieder loswird, steht im Dialog.
- **Eine kopierte Sicherung wird nicht mehr stillschweigend übernommen.**
  Gefragt wurde bisher nur, wenn im fremden Verzeichnis eine `Eudora.ini` lag.
  Ein Ordner mit Postfächern, aber ohne INI — der Fall einer von Hand
  kopierten Sicherung — wurde ungefragt in Besitz genommen, obwohl Eudora
  danach Postfächer, `Attach\` und `Embedded\` hineinschreibt. Jetzt genügt
  irgendeine Spur einer Einrichtung.
- **Der Über-Dialog nennt die Pfade, nach denen bei einem Fehler gefragt wird.**
  *Help → About Eudora* zeigt jetzt zusätzlich, **welche** `Eudora.ini`
  gelesen wird, wo die `DEudora.ini` liegt, wohin das Protokoll geschrieben
  wird samt `LogLevel` — und **woher das Mailverzeichnis stammt**
  (Befehlszeile, Umgebungsvariable, `DEudora.ini`, Registry oder Application
  Data). Der Knopf **Copy info** legt alles als Text auf die Zwischenablage,
  fertig zum Einfügen in ein Issue. Die Zeile *„Mail folder from"* gab bis
  7.2.0.116 in vier Lagen eine falsche Auskunft, darunter der häufigste Fall
  überhaupt; sie ist berichtigt.

## Bekannte Fehler

- **Eine bereits beschädigte `Eudora.ini`** — etwa von einer älteren Fassung
  dieses Projekts — wird erst beim **nächsten Sichern** berichtigt; der
  Leseweg ist noch offen
  ([E-131](https://github.com/HansWurst81675/Eudora7.2/blob/main/BEFUNDE.md#e-131)).
  Vorher eine Kopie anlegen.

Die vollständige Liste mit Abhilfe steht in der
[README, Abschnitt „Auf einen Blick“](https://github.com/HansWurst81675/Eudora7.2#auf-einen-blick-was-das-paket-kann-und-wo-noch-fehler-sind).
Die wichtigsten:

- **Eine über *File → Save As* gespeicherte Nachricht heißt immer `.txt`, auch
  wenn ihr Inhalt HTML ist** – ohne Hinweis. Zum Ansehen die Datei in `.html`
  umbenennen und im Browser öffnen, oder in `.eml` und in Thunderbird.
- **Wird ohne Serververbindung in einen IMAP-Ordner verschoben und sofort
  beendet**, zeigt der Zielordner danach nur einen Teil der Nachrichten.
  **Nichts geht verloren:** die Nachrichten stehen weiter im Ausgangspostfach.
  Sichtbar werden sie über *Rechtsklick auf das Postfach → Show Deleted
  Messages*, und mit *Message → UnDelete* holt man sie endgültig zurück.
  *Message → Purge Messages* dabei nicht benutzen – das entfernt sie.
- **War der IMAP-Ordner seit dem Start noch nie geöffnet**, erscheinen die
  dorthin verschobenen Mails erst, wenn man ihn noch einmal schließt und
  öffnet. Sie sind auf dem Server.
- **Eine Mail aus einem IMAP-Ordner nach `Out` ziehen** legt dort eine neue
  Nachricht mit kaputten Kopfzeilen an. Nicht nach `Out` ziehen; solche
  Einträge löschen, nicht senden.
- Nach einem Absturz, einem Eingriff von Defender oder einem Stromausfall
  können einer gerade verschobenen Nachricht eingebettete Bilder fehlen.
- Bilder, die als `data:`-Adresse in der Mail stecken, erscheinen als grauer
  Kasten; Bilder breiter als das Fenster werden nicht verkleinert.
- Adressbuch, LDAP und S/MIME fehlen weiterhin.

## Hinweis zu Windows Defender

Jede Fassung dieses Projekts ist eine neue, nicht signierte Datei. Microsoft
Defender hat mehrere davon fälschlich als Trojaner eingestuft und das Programm
ohne Meldung beendet — am 20.10.2026 **dreimal an einem Tag**, darunter die
Fassung 7.2.0.113 **beim Starten**, während ein gezielter Scan derselben Datei
nichts meldete.

**Der Fehlalarm ist am 20.10.2026 bei Microsoft eingereicht**, Vorgang
`a567fe2a-9f58-47e1-a675-a62733ec538f`, Einstufung *Incorrect detection*. Ob
Microsoft ihm folgt, wissen wir noch nicht.

**Wird die Datei bei Ihnen eingezogen:** *Windows-Sicherheit → Schutzverlauf →
Aktionen → Auf Gerät zulassen*. Nur *Wiederherstellen* genügt nicht — dann
wird sie beim nächsten Start wieder geholt. In der README steht unter *Windows
Defender meldet Eudora als Trojaner*, was sonst noch hilft.

## Prüfsumme

SHA-256 des ZIPs `Eudora72-1.0.117-release.zip`:
`335751a91ca67b7996c4076f077deb49a0f4ce4ac1de74c8a079cc2cb7eeb1a1`

## Was geprüft wurde – und was nicht

- **243 Tests, 243 bestanden** gegen genau diesen Bau; Bau Release 0 Fehler.
  Die `Eudora.exe` im Paket ist byteidentisch mit `Bin\Release`, keine
  Debug-Laufzeit, Defender 0 Funde.
- **Am laufenden Programm gemessen, rot und grün am selben Prüfstand.** Der
  Prüfstand liegt in einem Pfad **mit Leerzeichen** und mit 8.3-Kurzform
  (`C:\Temp\Eudora Pruefstand 116`), weil ein kürzerer Pfad genau die Fehler
  wegmisst, die Gregor danach gefunden hat.

  | Fall | an der Fassung davor | an 7.2.0.117 |
  |---|---|---|
  | fremdes Verzeichnis **ohne** `Eudora.ini` (kopierte Sicherung) | **keine Frage**, und in 90 Sekunden 29 Einträge hineingeschrieben — neue `Eudora.ini`, `Out.mbx`, `Trash.mbx`, `Junk.mbx`, `descmap.pce`, `OWNER.LOK`, `Attach\`, `Embedded\`, `Filters\`, `Nickname\`, `Sigs\`, `Stationery\` | Frage, nach *No* ein eigenes `Mailverzeichnis` |
  | Leerzeichen im Programmpfad, Antwort *No* | Eudora startete **gar nicht mehr** | Frage, dann das Programmfenster, Protokoll vorhanden |
  | zweiter Start auf dasselbe fremde Verzeichnis | Frage kam wieder | Frage bleibt aus, die Antwort ist gemerkt |

- **Die drei Antworten sind einzeln gemessen** (an 7.2.0.114, dem ersten Bau
  mit der Rückfrage): *No* → eigenes Verzeichnis, fremde `Eudora.ini` SHA-256
  unverändert; *Yes* → fremdes Verzeichnis benutzt und dessen `Eudora.ini`
  verändert, der ursprüngliche Schaden absichtlich nachgestellt; *Cancel* →
  das Programm endet, nichts angefasst. **Gegenprobe:** zeigt die Registry auf
  das eigene Paket, kommt **keine** Frage.
- **Nicht geprüft:** ob eine daneben installierte Hermes 7.1 danach wieder
  startet. Dazu fehlt uns Hermes; wer es testen kann, wird in
  [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102) darum gebeten.
- **Vier Fehler sind erst durch das Messen oder durch Gregors Lauf
  aufgefallen, nicht durch die Testsammlung:** die Rückfrage kam zuerst nie,
  weil die Registry zwei Pfade in **einer** Zeichenkette liefert; die
  Spurmarke war stumm, weil sie lief, bevor das Protokoll offen war; das
  eigene Verzeichnis galt wegen der 8.3-Kurzform als fremd; und auf vier von
  fünf Startwegen stieg die Prüfung wortlos aus. Alle vier sind behoben und
  am laufenden Programm nachgewiesen.
