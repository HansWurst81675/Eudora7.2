# Was âlauffÃ¤hig" heiÃt

Von Gregor am 30.08.2026 festgelegt, nachdem eine Fassung als âlauffÃ¤hig"
ausgeliefert wurde, die zwar startete, aber nicht bedienbar war.

> * es genÃ¼gt nicht, daÃ das programm startet
> * die darstellung sollte korrekt sein
> * ich mÃ¶chte damit einen mail server verbinden und mails abrufen.

## Die Kriterien

| # | Kriterium | Stand am 31.08.2026 |
|---|---|---|
| 0 | Das Paket lÃ¤uft ohne Nachinstallieren | **nicht erfÃ¼llt** â der Win11-Lauf war der Debug-Bau mit beigelegten, nicht verteilbaren DLLs (E-8) |
| 1 | Eudora startet und zeigt sein Hauptfenster | **erfÃ¼llt** (31.08.2026, Befund E-1) |
| 2 | Die Darstellung ist korrekt | **fast** â Anordnung, MenÃ¼s und Werkzeugleiste stimmen; Umlaute in HTML-Mails werden zu `â` (E-2) |
| 3 | Ein Mailkonto lÃ¤sst sich einrichten, verbinden und Mail abrufen | **erfÃ¼llt** â 159 Nachrichten abgerufen, Befund E-1 |

Kriterium 0 kam am 31.08.2026 dazu; es steht vor den anderen dreien, weil ohne
lauffÃ¤higes Paket niemand die anderen prÃ¼fen kann. Beschrieben ist es weiter
unten in einem eigenen Abschnitt.

> ### Kriterium 1 â erledigt am 31.08.2026
>
> **Seit Befund E-1 erfÃ¼llt:** das Fenster erscheint und ist bedienbar, die
> MenÃ¼s klappen auf, die Bereiche Ã¼berlagern sich nicht mehr. Was folgt, ist
> der Stand vom Vortag und bleibt stehen, weil die BegrÃ¼ndung weiter gilt.
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

**Erst wenn alle Kriterien erfÃ¼llt sind, darf eine Fassung âlauffÃ¤hig" heiÃen.**
Vorher heiÃt sie, was sie ist â etwa âstartet" oder âVorabfassung".


## Kriterium 0: das Paket muss ohne Nachinstallieren laufen

Von Gregor am 31.08.2026 festgelegt, nachdem Paket 1.0.2 mit `0xc000007b`
scheiterte, weil vier Debug-DLLs von Visual Studio fehlten:

> *âziel: mÃ¶glichst einfach: zip runterladen, entpacken, starten - lÃ¤uft. keine
> fehlenden DLLs, keine fehlermeldungen, daÃ etwas nicht gefunden werden kann
> oder nachinstalliert werden muÃ"*

Und auf die Frage nach dem Weg dorthin:

> *âsonst ja, statisch linken, ist mir auch egal."*

### Was dem heute im Weg steht

Der Debug-Bau braucht `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll` und
`ucrtbased.dll`. **Diese vier dÃ¼rfen nicht mitgeliefert werden** â Microsoft
nimmt die Debug-Fassungen der Laufzeit ausdrÃ¼cklich vom Weiterverteilen aus,
bei Visual Studio liegen sie deshalb in einem Ordner namens `debug_nonredist`.
Ein Redistributable dafÃ¼r gibt es nicht; sie kommen nur mit einer
Visual-Studio-Installation.

### Der Weg dorthin

| Weg | Ergebnis |
|---|---|
| **Debug-Bau** | vier nicht verteilbare DLLs nÃ¶tig, dazu SUPERASSERT-Dialoge beim Start. **Ungeeignet fÃ¼rs Ausliefern.** |
| **Release-Bau, dynamisch** | `mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll` sind verteilbar und dÃ¼rfen beiliegen. Keine Dialoge mehr. Aber: drei Dateien mehr im Paket. |
| **Release-Bau, statisch (`/MT` + MFC statisch)** | **keine Laufzeit-DLL nÃ¶tig.** Die `Eudora.exe` wird grÃ¶Ãer, das Paket kleiner und einfacher. Gregors bevorzugter Weg. |

Die vorgebauten Fremd-DLLs von 2006 (Paige32, EuMemMgr und die Ã¼brigen) bleiben
davon unberÃ¼hrt â sie sind eigene Module mit eigener Laufzeit und brauchen
weiterhin `MSVCR71.dll`. DafÃ¼r gibt es seit Befund B-1 einen **eigenen Nachbau**
(`Eudora71/VC71Bruecke`), der auf die von Windows selbst mitgelieferte
`msvcrt.dll` weiterleitet. Der darf mit ins Paket, er ist unser eigener Code.

### Woran sich Kriterium 0 misst

> ### Berichtigung vom 31.08.2026: Kriterium 0 ist NICHT belegt
>
> Ich hatte gemeldet, Kriterium 0 sei mit `tools/paket-pruefen.ps1`
> âgemessen erfuellt". Das traegt nicht. PRUEFER hat mit einer Gegenprobe
> gezeigt: **der Pruefer prueft die Maschine, nicht das Paket.**
>
> Aus einer ausgepackten Kopie wurden `EudoraRes.dll`, `QCSSL.dll`,
> `SPELL32.DLL`, `EuGraph.ocx` und der ganze `Plugins`-Ordner geloescht â
> das Ergebnis blieb **âkeine Fehler, EXIT=0"**. Fehlende Laufzeiten gelten
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



`tools/paket-pruefen.ps1` gegen das ausgepackte Paket, auf einem Rechner **ohne**
Visual Studio: **null Fehler**. Kein `0xc000007b`, keine Meldung Ã¼ber eine
fehlende DLL, kein Nachinstallieren.


## Woran sich Kriterium 2 misst

Gregor hat als Vergleich ein Bildschirmfoto der Originalfassung geliefert
(Eudora 7 unter Windows XP). MaÃgeblich sind daraus:

- Werkzeugleiste mit **allen** Symbolen, keine leeren grauen Felder
- Postfachbaum links, sauber abgegrenzt
- Nachrichtenfenster mit Kopfzeilenbereich und Textbereich untereinander
- Registerkarten am unteren Rand des Nachrichtenbereichs
- keine sich Ã¼berlagernden Bereiche

Bekannte Abweichungen sind in `BEFUNDE.md` unter S-6 gesammelt.

## Woran sich Kriterium 3 misst

Nachweis ist ein tatsÃ¤chlicher Abruf gegen einen echten Server, mit Beleg:
Protokollversion und Verfahren aus *Tools â Last SSL Info*, und mindestens eine
empfangene Nachricht, die lesbar dargestellt wird.

Das ist zugleich der erste echte Test der neuen TLS-Schicht. Der letzte
erfolgreiche Abruf (`pop.gmx.net`, TLS 1.3) fand mit einer **Ã¤lteren**
QCSSL-Fassung statt â Einzelheiten in `Releases/1.0/AUSLIEFERUNGEN.md`.

## Was daraus fÃ¼r die Benennung folgt

Der Dateiname `Eudora72-1.0.2-lauffaehig.zip` behauptet mehr, als die Fassung
kann. KÃ¼nftige Pakete heiÃen nach ihrem tatsÃ¤chlichen Stand. Siehe
`Releases/PAKETE.md`.
