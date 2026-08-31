# Was „lauffähig" heißt

Von Gregor am 30.08.2026 festgelegt, nachdem eine Fassung als „lauffähig"
ausgeliefert wurde, die zwar startete, aber nicht bedienbar war.

> * es genügt nicht, daß das programm startet
> * die darstellung sollte korrekt sein
> * ich möchte damit einen mail server verbinden und mails abrufen.

## Die Kriterien

| # | Kriterium | Stand am 31.08.2026 |
|---|---|---|
| 0 | Das Paket läuft ohne Nachinstallieren | **nicht erfüllt** — der Win11-Lauf war der Debug-Bau mit beigelegten, nicht verteilbaren DLLs (E-8) |
| 1 | Eudora startet und zeigt sein Hauptfenster | **erfüllt** (31.08.2026, Befund E-1) |
| 2 | Die Darstellung ist korrekt | **fast** — Anordnung, Menüs und Werkzeugleiste stimmen; Umlaute in HTML-Mails werden zu `◆` (E-2) |
| 3 | Ein Mailkonto lässt sich einrichten, verbinden und Mail abrufen | **erfüllt** — 159 Nachrichten abgerufen, Befund E-1 |

Kriterium 0 kam am 31.08.2026 dazu; es steht vor den anderen dreien, weil ohne
lauffähiges Paket niemand die anderen prüfen kann. Beschrieben ist es weiter
unten in einem eigenen Abschnitt.

> ### Kriterium 1 — erledigt am 31.08.2026
>
> **Seit Befund E-1 erfüllt:** das Fenster erscheint und ist bedienbar, die
> Menüs klappen auf, die Bereiche überlagern sich nicht mehr. Was folgt, ist
> der Stand vom Vortag und bleibt stehen, weil die Begründung weiter gilt.
>
> ### Der Stand am 30.08.2026: Kriterium 1 ist nicht erfüllt
>
> Am 30.08.2026 abends, von Gregor:
>
> > *„halte ich für ein gerücht ... das hauptfenster ist ja kaputt!"*
>
> Er hat recht. Ich hatte Kriterium 1 als erfüllt geführt, weil ein Fenster
> erscheint. Das Fenster ist aber **nicht bedienbar**: die Menüs lassen sich
> nicht öffnen (S-5), Bereiche überlagern sich, Werkzeugleisten-Knöpfe sind
> leer (S-6).
>
> **Ein Fenster, das erscheint, aber nicht benutzbar ist, erfüllt kein
> Kriterium.** „Zeigt sein Hauptfenster" heißt: man kann damit arbeiten —
> nicht: es sind Pixel auf dem Schirm.
>
> Damit ist derzeit **keines der Kriterien erfüllt**. Was Paket 1.0.2
> belegt, ist bescheidener und trotzdem ein Fortschritt: der Bau ist
> vollständig, die Abhängigkeiten lösen auf, und die Anwendung läuft bis in
> die Fenstererzeugung, ohne abzustürzen. Das ist ein *Meilenstein*, kein
> erfülltes Kriterium.
>
> **Stand 31.08.2026.** Für beide genannten Mängel sind die Ursachen inzwischen
> belegt **und im Quelltext behoben**: die tote Nichtklientenfläche (M-1,
> `m_bMainFrameEnabled`) und die leeren Werkzeugleisten-Knöpfe samt
> Andockrechnung (A-1). **Das ändert am Stand hier nichts** — behoben im
> Quelltext ist nicht dasselbe wie nachgesehen am laufenden Programm. Kriterium
> 1 und 2 bleiben offen, bis Gregor das Fenster bedient hat.
>
> Zu besprechen in der nächsten Sitzung.

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



`tools/paket-pruefen.ps1` gegen das ausgepackte Paket, auf einem Rechner **ohne**
Visual Studio: **null Fehler**. Kein `0xc000007b`, keine Meldung über eine
fehlende DLL, kein Nachinstallieren.


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

Das ist zugleich der erste echte Test der neuen TLS-Schicht. Der letzte
erfolgreiche Abruf (`pop.gmx.net`, TLS 1.3) fand mit einer **älteren**
QCSSL-Fassung statt — Einzelheiten in `Releases/1.0/AUSLIEFERUNGEN.md`.

## Was daraus für die Benennung folgt

Der Dateiname `Eudora72-1.0.2-lauffaehig.zip` behauptet mehr, als die Fassung
kann. Künftige Pakete heißen nach ihrem tatsächlichen Stand. Siehe
`Releases/PAKETE.md`.
