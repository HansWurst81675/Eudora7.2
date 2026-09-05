# Was „lauffähig" heißt

Von Gregor am 30.08.2026 festgelegt, nachdem eine Fassung als „lauffähig"
ausgeliefert wurde, die zwar startete, aber nicht bedienbar war.

> * es genügt nicht, daß das programm startet
> * die darstellung sollte korrekt sein
> * ich möchte damit einen mail server verbinden und mails abrufen.

## Die Kriterien

> **Diese Tabelle ist die Quelle.** Sie stand am 31.08.2026 an fünf Stellen im
> Repo, dreimal mit verschiedenem Inhalt. `README.md`, `AUFGABEN.md`,
> `WEITERMACHEN.md`, `PORTIERUNG.md` und `Releases/PAKETE.md` verweisen jetzt
> hierher, statt sie zu wiederholen. Wer den Stand ändert, ändert ihn **hier**.

| # | Kriterium | Stand am 05.09.2026 |
|---|---|---|
| 0 | Das Paket läuft ohne Nachinstallieren | **weiterhin nicht belegt** — der Release-Bau steht (F-1), aber auf keinem Rechner **ohne** Visual Studio gestartet worden. Der Win11-Lauf vom 31.08. war der Debug-Bau mit beigelegten, nicht verteilbaren DLLs (E-8); `tools/paket-pruefen.ps1` taugt nicht als Nachweis (PR-2.0 bis PR-2.3) |
| 1 | Eudora startet und zeigt sein Hauptfenster | **erfüllt** — Gregor hat am 05.09.2026 die Fassung **7.2.0.4** in der VM gestartet und bedient. Auf einer **frischen** Installation stürzte Eudora am 31.08. nach dem Kontoassistenten ab (E-11, behoben); dieser Fall ist weiterhin **nicht** nachgesehen |
| 2 | Die Darstellung ist korrekt | **fast** — Fenster, Menüs und Werkzeugleiste stimmen (E-1, E-2). Der Titel trägt die Bau-Kennung wieder (E-7 behoben am 05.09., **am Programm nicht nachgesehen**). **Offen: beim Mailabruf ist kein Fortschritt sichtbar.** Umlaute in HTML-Mail (Z-2) und der einzelne zerrissene Umlaut je Nachricht (Z-2b) sind an der Ursache behoben, beide **ungeprüft** |
| 3 | Ein Mailkonto lässt sich einrichten, verbinden und Mail abrufen | **erfüllt** — Gregor am 05.09.2026 zu 7.2.0.4: *„mails lassen sich abrufen"*. Zuvor bereits am 31.08.: 159 Nachrichten von `mx.freenet.de`, Port 110, STARTTLS, TLSv1.3, `TLS_AES_256_GCM_SHA384` (E-1, E-3) |

**Zwei von vier Kriterien sind belegt, eines fast, eines offen.**

> ### Berichtigung vom 05.09.2026
>
> Bis zum 05.09.2026 stand in dieser Tabelle der Stand vom **31.08.2026**. Er
> ist berichtigt, nicht gelöscht: die Belege zu 1.0.3 stehen unverändert in
> `BEFUNDE.md` (E-1, E-2, E-3, E-8). Geändert hat sich dreierlei:
>
> * **Kriterium 1 und 3 sind jetzt an der Fassung 7.2.0.4 belegt**, nicht mehr
>   nur an 1.0.3.
> * **Kriterium 2 hat einen neuen offenen Punkt bekommen**, den es am 31.08.
>   nicht gab: beim Abruf ist kein Fortschritt sichtbar. Dafür ist E-7 (fehlende
>   Bau-Kennung im Titel) weggefallen.
> * **Kriterium 0 hat sich nicht bewegt.** Es ist das einzige, das noch nie
>   gemessen wurde.

Kriterium 0 kam am 31.08.2026 dazu; es steht vor den anderen dreien, weil ohne
lauffähiges Paket niemand die anderen prüfen kann. Beschrieben ist es weiter
unten in einem eigenen Abschnitt.

> ### Kriterium 1 — erledigt am 31.08.2026
>
> **Seit Befund E-1 erfüllt:** das Fenster erscheint und ist bedienbar, die
> Menüs klappen auf, die Bereiche überlagern sich nicht mehr. Was folgt, ist
> der Stand vom Vortag und bleibt stehen, weil die Begründung weiter gilt.
>
> ### Wie es zu Kriterium 1 kam
>
> Am 30.08.2026 hatte ich Kriterium 1 als erfüllt geführt, weil ein Fenster
> erschien. Gregor widersprach: *„das hauptfenster ist ja kaputt!“* Er hatte
> recht — die Menüs öffneten nicht (Befund M-1), die Werkzeugleisten-Knöpfe
> waren leer (A-1), die Flächen überlappten.
>
> **Ein Fenster, das erscheint, aber nicht benutzbar ist, erfüllt kein
> Kriterium.** Das ist der Maßstab, nicht der Aufwand, der dahintersteckt.
>
> Am 31.08.2026 hat Gregor selbst nachgesehen: *„menü funktioniert“* — und im
> selben Lauf 159 Nachrichten abgerufen. **Seitdem** gilt Kriterium 1 als
> erfüllt, und zwar auf einer eingerichteten Installation. Auf einer frischen
> stürzte der Kontoassistent noch ab (E-11, behoben, ungeprüft).
>
> Die Dateinamen `Eudora72-1.0.1-lauffaehig.zip` und `…1.0.2-lauffaehig.zip`
> behaupten mehr, als die Fassungen konnten. Sie bleiben nur stehen, weil die
> Pakete unter diesen Namen samt Prüfsumme veröffentlicht sind.

**Erst wenn alle Kriterien erfüllt sind, darf eine Fassung „lauffähig" heißen.**
Vorher heißt sie, was sie ist — etwa „startet" oder „Vorabfassung".


## Kriterium 0: das Paket muss ohne Nachinstallieren laufen

Von Gregor am 31.08.2026 festgelegt, nachdem Paket 1.0.2 mit `0xc000007b`
scheiterte, weil vier Debug-DLLs von Visual Studio fehlten:

> *„ziel: möglichst einfach: zip runterladen, entpacken, starten - läuft. keine
> fehlenden DLLs, keine fehlermeldungen, daß etwas nicht gefunden werden kann
> oder nachinstalliert werden muß"*

Und auf die Frage nach dem Weg dorthin:

> *„sonst ja, statisch linken, ist mir auch egal."*

### Was dem heute im Weg steht

Der Debug-Bau braucht `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll` und
`ucrtbased.dll`. **Diese vier dürfen nicht mitgeliefert werden** — Microsoft
nimmt die Debug-Fassungen der Laufzeit ausdrücklich vom Weiterverteilen aus,
bei Visual Studio liegen sie deshalb in einem Ordner namens `debug_nonredist`.
Ein Redistributable dafür gibt es nicht; sie kommen nur mit einer
Visual-Studio-Installation.

### Der Weg dorthin

| Weg | Ergebnis |
|---|---|
| **Debug-Bau** | vier nicht verteilbare DLLs nötig, dazu SUPERASSERT-Dialoge beim Start. **Ungeeignet fürs Ausliefern.** |
| **Release-Bau, dynamisch** | `mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll` sind verteilbar und dürfen beiliegen. Keine Dialoge mehr. Aber: drei Dateien mehr im Paket. |
| **Release-Bau, statisch (`/MT` + MFC statisch)** | **keine Laufzeit-DLL nötig.** Die `Eudora.exe` wird größer, das Paket kleiner und einfacher. Gregors bevorzugter Weg. |

Die vorgebauten Fremd-DLLs von 2006 (Paige32, EuMemMgr und die übrigen) bleiben
davon unberührt — sie sind eigene Module mit eigener Laufzeit und brauchen
weiterhin `MSVCR71.dll`. Dafür gibt es seit Befund B-1 einen **eigenen Nachbau**
(`Eudora71/VC71Bruecke`), der auf die von Windows selbst mitgelieferte
`msvcrt.dll` weiterleitet. Der darf mit ins Paket, er ist unser eigener Code.

### Woran sich Kriterium 0 misst

> ### Berichtigung vom 31.08.2026: Kriterium 0 ist NICHT belegt
>
> Ich hatte gemeldet, Kriterium 0 sei mit `tools/paket-pruefen.ps1`
> „gemessen erfuellt". Das traegt nicht. PRUEFER hat mit einer Gegenprobe
> gezeigt: **der Pruefer prueft die Maschine, nicht das Paket.**
>
> Aus einer ausgepackten Kopie wurden `EudoraRes.dll`, `QCSSL.dll`,
> `SPELL32.DLL`, `EuGraph.ocx` und der ganze `Plugins`-Ordner geloescht —
> das Ergebnis blieb **„keine Fehler, EXIT=0"**. Fehlende Laufzeiten gelten
> ihm als vorhanden, sobald sie irgendwo in `SysWOW64` liegen.
>
> Dazu kommt: bei einem **Release**-Paket erzeugt seine feste
> Debug-Laufzeitliste vier Falschwarnungen. Wer ihnen folgt, holt sich mit
> `laufzeit-holen.ps1` genau die **nicht verteilbaren** DLLs ins Paket. Ein
> Pruefwerkzeug, das zum Lizenzverstoss anleitet, ist schlimmer als keines.
>
> **Bis das behoben ist, darf `paket-pruefen.ps1` nicht als Freigabekriterium
> gelten.** Der einzige belastbare Nachweis fuer Kriterium 0 bleibt: das ZIP
> auf einem Rechner **ohne** Visual Studio auspacken und starten.

Der Maßstab bleibt damit: **das ZIP auf einem Rechner ohne Visual Studio
auspacken und starten** — kein `0xc000007b`, keine Meldung über eine fehlende
DLL, kein Nachinstallieren. Für das Release-Paket ist dieser Lauf noch nicht
gemacht worden (E-8); für den Debug-Bau zählt er nicht, weil dort vier nicht
verteilbare DLLs beiliegen mussten.

Bis `tools/paket-pruefen.ps1` nach den **Importen** der Paketdateien statt nach
einer festen Liste urteilt (PR-2.0), ist es kein Freigabekriterium.


## Woran sich Kriterium 2 misst

Gregor hat als Vergleich ein Bildschirmfoto der Originalfassung geliefert
(Eudora 7 unter Windows XP). Maßgeblich sind daraus:

- Werkzeugleiste mit **allen** Symbolen, keine leeren grauen Felder
- Postfachbaum links, sauber abgegrenzt
- Nachrichtenfenster mit Kopfzeilenbereich und Textbereich untereinander
- Registerkarten am unteren Rand des Nachrichtenbereichs
- keine sich überlagernden Bereiche

Bekannte Abweichungen sind in `BEFUNDE.md` unter S-6 gesammelt.

## Woran sich Kriterium 3 misst

Nachweis ist ein tatsächlicher Abruf gegen einen echten Server, mit Beleg:
Protokollversion und Verfahren aus *Tools → Last SSL Info*, und mindestens eine
empfangene Nachricht, die lesbar dargestellt wird.

> **Erbracht am 31.08.2026, 08:09:43** (Befund E-3): `mx.freenet.de` auf
> **Port 110 mit STARTTLS**, `TLSv1.3`, `TLS_AES_256_GCM_SHA384` (256 Bit),
> Status *Succeeded*, danach 159 abgerufene und lesbar dargestellte Nachrichten.
> Abgelesen in *Tools → Last SSL Info*.

Damit ist zugleich der erste echte Servertest der **ausgelieferten** QCSSL 1.0.1
(`ab55281a`) bestanden. Der vorherige Lauf (`pop.gmx.net`, 29.08., TLS 1.3) war
mit einer **älteren** Fassung gelaufen — Einzelheiten in
`Releases/1.0/AUSLIEFERUNGEN.md`.

## Was daraus für die Benennung folgt

Der Dateiname `Eudora72-1.0.2-lauffaehig.zip` behauptet mehr, als die Fassung
kann. Künftige Pakete heißen nach ihrem tatsächlichen Stand. Siehe
`Releases/PAKETE.md`.
