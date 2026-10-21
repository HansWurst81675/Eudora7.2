**Eudora 7.2.0.117 / Paket 1.0.117**

> ## Diese Fassung schützt eine vorhandene Installation — auch eine kopierte Sicherung
>
> Der Melder aus [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)
> hatte berichtet, die neue Installation habe *über Registry-Abfragen* die
> vorhandene in einem anderen Ordner gefunden und deren INI verändert; danach
> startete seine Hermes 7.1 nicht mehr.
> [v1.0.113](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.113)
> hat den **Schaden** behoben, diese Fassung schließt den **Weg** dorthin —
> und zwar auf allen Startwegen.
>
> **Was passiert.** Startet Eudora, ohne dass ihm das Mailverzeichnis gesagt
> wird, sucht es sich eines: über
> `HKEY_CURRENT_USER\Software\Qualcomm\Eudora\CommandLine\Current` findet es
> den Datenordner, mit dem zuletzt **irgendeine** Eudora oder Hermes gestartet
> wurde. Bisher nahm es ihn wortlos und schrieb hinein.
>
> **Jetzt fragt es vorher**, mit drei Wegen: *Yes* (das fremde Verzeichnis
> trotzdem benutzen), *No* (ein eigenes neben dem Programm anlegen), *Cancel*
> (beenden, ohne etwas anzufassen). **Vorgabe ist *No***, damit ein
> unbedachtes Enter nichts beschädigt. Die Antwort wird gemerkt. Der Befund
> läuft bei uns als
> **[E-132](https://github.com/HansWurst81675/Eudora7.2/blob/main/BEFUNDE.md#e-132)**.
>
> **Trotzdem vorher sichern.** Wer bereits ein Eudora oder Hermes 7.1
> installiert hat, legt eine Kopie von `Eudora.ini` und dem Mailverzeichnis
> an, bevor er diese Fassung startet.

ZIP auspacken, `Eudora starten.cmd` doppelklicken. Nichts zu installieren.

## Neu gegenüber v1.0.113

- **Eudora fragt, bevor es ein fremdes Mailverzeichnis übernimmt** — auf
  **allen** Startwegen: Doppelklick auf `Eudora.exe`, `mailto:`-Link,
  Postfachdatei (`.mbx`), Briefpapier (`.sta`) und per Ziehen übergebene
  Anhänge. Startet man wie vorgesehen über `Eudora starten.cmd`, ändert sich
  nichts — die Frage kommt nur, wenn Eudora selbst suchen muss **und** fündig
  wird.
- **Auch eine kopierte Sicherung ist geschützt.** Gefragt wird, sobald im
  fremden Verzeichnis irgendeine Spur einer Einrichtung liegt — eine
  `Eudora.ini`, ein Postfach, `Attach\` oder `Embedded\`. Vorher genügte das
  Fehlen der `Eudora.ini`, um ein fremdes Datenverzeichnis wortlos in Besitz
  zu nehmen.
- **Die Antwort wird gemerkt**, je fremdem Verzeichnis, in der `DEudora.ini`
  neben dem Programm. Wer zwei Fassungen nebeneinander benutzt, wird nicht
  bei jedem Wechsel gefragt. Wie man den Merker wieder loswird, steht im
  Dialog selbst.
- **Der Über-Dialog nennt die Pfade, nach denen bei einem Fehler gefragt
  wird.** *Help → About Eudora* zeigt jetzt zusätzlich, **welche**
  `Eudora.ini` gelesen wird, wo die `DEudora.ini` liegt, wohin das Protokoll
  geschrieben wird samt `LogLevel` — und **woher das Mailverzeichnis stammt**.
  Der Knopf **Copy info** legt alles als Text auf die Zwischenablage, fertig
  zum Einfügen in ein Issue.

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
  wenn ihr Inhalt HTML ist** – ohne Hinweis. Zum Ansehen in `.html` umbenennen
  und im Browser öffnen, oder in `.eml` und in Thunderbird.
- **Wird ohne Serververbindung in einen IMAP-Ordner verschoben und sofort
  beendet**, zeigt der Zielordner danach nur einen Teil der Nachrichten.
  **Nichts geht verloren:** sie stehen weiter im Ausgangspostfach, sichtbar
  über *Rechtsklick → Show Deleted Messages*, zurückzuholen mit
  *Message → UnDelete*. *Purge Messages* dabei nicht benutzen.
- **War der IMAP-Ordner seit dem Start noch nie geöffnet**, erscheinen dorthin
  verschobene Mails erst nach erneutem Öffnen. Sie sind auf dem Server.
- **Eine Mail aus einem IMAP-Ordner nach `Out` ziehen** legt dort eine neue
  Nachricht mit kaputten Kopfzeilen an. Nicht nach `Out` ziehen.
- Nach einem Absturz, einem Eingriff von Defender oder einem Stromausfall
  können einer gerade verschobenen Nachricht eingebettete Bilder fehlen.
- Bilder als `data:`-Adresse erscheinen als grauer Kasten; Bilder breiter als
  das Fenster werden nicht verkleinert.
- Adressbuch-**Verzeichnisdienste** (LDAP, Ph) und S/MIME fehlen weiterhin —
  sie brauchen `MFC71.DLL` von 2003, die Microsoft nie zur Weitergabe
  freigegeben hat. Das **lokale** Adressbuch mit seinen Kurznamen arbeitet;
  der Kurzname wird beim **Senden** aufgelöst, im Verfassen-Fenster bleibt er
  stehen.

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
wird sie beim nächsten Start wieder geholt.

## Prüfsumme

SHA-256 des ZIPs:
`335751a91ca67b7996c4076f077deb49a0f4ce4ac1de74c8a079cc2cb7eeb1a1`

## Was geprüft wurde – und was nicht

- **243 Tests, 243 bestanden** gegen genau diesen Bau; Bau Release 0 Fehler,
  `Eudora.exe` im Paket byteidentisch mit dem Bauverzeichnis, keine
  Debug-Laufzeit, Defender 0 Funde.
- **Rot und grün am laufenden Programm**, am selben Verzeichnis, mit demselben
  Handgriff — ein fremdes Mailverzeichnis **ohne** `Eudora.ini`, also eine
  kopierte Sicherung:

  | | |
  |---|---|
  | **vorher** | keine Rückfrage; Eudora schreibt in neunzig Sekunden **29 Einträge** in die fremde Sicherung, darunter eine **neue `Eudora.ini`**, `Out.mbx`, `Trash.mbx`, `Junk.mbx`, `descmap.pce`, `OWNER.LOK` und die Verzeichnisse `Attach\`, `Embedded\`, `Filters\`, `Nickname\`, `Sigs\`, `Stationery\` |
  | **mit dieser Fassung** | Rückfrage, und nach *No* das eigene Verzeichnis; die fremde Sicherung bleibt unberührt |

- **Der Prüfstand wurde dafür umgebaut**, und das war nötig: der alte lag unter
  `C:\Temp\E132` — ein Pfad **ohne** 8.3-Kurznamen und **ohne** Leerzeichen.
  Drei grüne Messungen dort, und zwei Fehler blieben unentdeckt, bis Gregor
  sie am laufenden Programm fand. Der neue Prüfstand hat beides.
- **Nicht geprüft:** ob eine daneben installierte **Hermes 7.1** danach wieder
  startet. Dazu fehlt uns Hermes; wer es testen kann, wird in
  [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102) darum gebeten.
- **Nicht geprüft:** die Rückfrage über einen `mailto:`-Link, eine `.mbx` oder
  eine `.sta`. Dass sie dort **fehlte**, ist am Quelltext belegt und behoben;
  am laufenden Programm gesehen haben wir nur den Doppelklick.
