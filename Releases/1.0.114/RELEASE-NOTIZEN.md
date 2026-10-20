**Eudora 7.2.0.114 / Paket 1.0.114**

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
> unbedachtes Enter nichts beschädigt. Der Befund läuft bei uns als
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
- **Der Über-Dialog nennt die Pfade, nach denen bei einem Fehler gefragt wird.**
  *Help → About Eudora* zeigt jetzt zusätzlich, **welche** `Eudora.ini`
  gelesen wird, wo die `DEudora.ini` liegt, wohin das Protokoll geschrieben
  wird samt `LogLevel` — und **woher das Mailverzeichnis stammt**
  (Befehlszeile, Umgebungsvariable, `DEudora.ini`, Registry oder Application
  Data). Der Knopf **Copy info** legt alles als Text auf die Zwischenablage,
  fertig zum Einfügen in ein Issue.

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
ohne Meldung beendet — am 20.10.2026 **zweimal an einem Tag**, zuletzt die
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

SHA-256 des ZIPs: *(wird beim Schnüren des Pakets eingetragen)*

## Was geprüft wurde – und was nicht

- **241 Tests, 241 bestanden** gegen genau diesen Bau; Bau Release 0 Fehler.
- **Am laufenden Programm gemessen, auf allen drei Wegen.** Ein Prüfpaket
  wurde neben eine zweite Installation gestellt, deren Mailverzeichnis in der
  Registry stand; die Antwort auf die Rückfrage kam jeweils als
  Fensterbotschaft an ein gemessenes Fensterhandle:

  | Antwort | Ergebnis | fremde `Eudora.ini` |
  |---|---|---|
  | **No** | eigenes Verzeichnis gewählt | SHA-256 unverändert |
  | **Yes** | fremdes Verzeichnis benutzt, Protokoll landet dort | **verändert** — der ursprüngliche Schaden, absichtlich nachgestellt |
  | **Cancel** | Programm endet | unverändert |

  **Gegenprobe:** zeigt die Registry auf das eigene Paket, kommt **keine**
  Frage.
- **Zwei Fehler in der ersten Fassung der Behebung, beide durch die Messung
  gefunden:** die Rückfrage kam zunächst **nie**, weil die Registry zwei Pfade
  in **einer** Zeichenkette liefert; und die Spurmarke war stumm, weil sie
  läuft, bevor das Protokoll offen ist. Beides behoben, beides am Prüfstand
  nachgewiesen.
- **Nicht geprüft:** ob eine daneben installierte Hermes 7.1 danach wieder
  startet. Dazu fehlt uns Hermes; wer es testen kann, wird in
  [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102) darum gebeten.
- **Der Über-Dialog ist am laufenden Programm geprüft — gedrückt hat Gregor.**
  Mein Messskript hat den Dialog über `WM_COMMAND ID_APP_ABOUT` geöffnet,
  ihn aber **nicht wiedererkannt** und `KEIN Dialog gefunden` gemeldet; es
  lief ab und ließ ihn offen stehen. Gregor fand ihn offen vor, drückte
  *Copy info* und schickte den Inhalt der Zwischenablage:

  ```
  Version 7.2.0.114R - Paid Mode
  Not Registered in This Mode
  Data: C:\Temp\E132\Mailverzeichnis
  Application: C:\Temp\E132
  INI: C:\Temp\E132\Mailverzeichnis\Eudora.ini
  Default INI: C:\Temp\E132\DEudora.ini
  Log: C:\Temp\E132\Mailverzeichnis\eudora.log  (LogLevel=58527)
  Mail folder from: command line
  ```

  `Mail folder from: command line` ist dabei die richtige Antwort — der
  Prüfstand startet mit dem Verzeichnis als Argument. Dass kein Hinweis
  *„keine E-nn-Marken"* dabeisteht, stimmt ebenfalls: `58527` enthält
  `32768`.
