# Was „lauffähig" heißt

Von Gregor am 30.08.2026 festgelegt, nachdem eine Fassung als „lauffähig"
ausgeliefert wurde, die zwar startete, aber nicht bedienbar war.

> * es genügt nicht, daß das programm startet
> * die darstellung sollte korrekt sein
> * ich möchte damit einen mail server verbinden und mails abrufen.

## Die Kriterien

> **Diese Tabelle ist die Quelle.** `README.md`, `AUFGABEN.md`,
> `WEITERMACHEN.md`, `PORTIERUNG.md` und `Releases/PAKETE.md` verweisen hierher,
> statt sie zu wiederholen. Wer den Stand ändert, ändert ihn **hier**.

Stand **06.09.2026**, gemessen an Fassung **7.2.0.10 / Paket 1.0.10** (die
zuletzt gepackte und gestartete; Quellstand ist 7.2.0.11).

| # | Kriterium | Stand |
|---|---|---|
| 0 | Das Paket läuft ohne Nachinstallieren | **nicht belegt** — auf keinem Rechner **ohne** Visual Studio ausgepackt und gestartet. Der einzige Lauf auf einem fremden Rechner war am 31.08. der **Debug**-Bau mit beigelegten, nicht verteilbaren DLLs (E-8) |
| 1 | Eudora startet und zeigt sein Hauptfenster | **erfüllt** — Gregor hat mehrere Fassungen in der VM gestartet und bedient. Der Absturz nach *Weiter* im Kontoassistenten (**E-25**) ist an der Ursache behoben, aber **ungeprüft** |
| 2 | Die Darstellung ist korrekt | **fast** — Fenster, Menüs und Werkzeugleiste stimmen (E-1, E-2), der Titel trägt die Bau-Kennung (E-7), der Fortschritt beim Abruf ist sichtbar (E-13), Umlaute stimmen (Z-2, Z-2b), „In" steht nur noch einmal unter *Recent* (E-24). **Offen:** Strg-N stürzt ab, Doppelklick öffnet keine Nachricht, Suchtreffer sind nicht anklickbar, Meldung „Encountered an improper argument" |
| 3 | Ein Mailkonto lässt sich einrichten, verbinden und Mail abrufen | **erfüllt** — POP3 über **Port 995 mit TLSv1.3**, `Negotiation Status: Succeeded`, von Gregor am 06.09.2026 bestätigt. Zuvor am 31.08. 159 Nachrichten von `mx.freenet.de` über Port 110 mit STARTTLS (E-1, E-3) |

**Zwei von vier Kriterien sind belegt, eines fast, eines offen.**

**Erst wenn alle Kriterien erfüllt sind, darf eine Fassung „lauffähig" heißen.**
Vorher heißt sie, was sie ist — etwa „startet" oder „Vorabfassung". Die
Dateinamen `Eudora72-1.0.1-lauffaehig.zip` und `Eudora72-1.0.2-lauffaehig.zip`
behaupten mehr, als die Fassungen können; sie bleiben nur stehen, weil die
Pakete unter diesen Namen samt Prüfsumme veröffentlicht sind.

## Kriterium 0: das Paket muss ohne Nachinstallieren laufen

Von Gregor am 31.08.2026 festgelegt, nachdem Paket 1.0.2 mit `0xc000007b`
scheiterte, weil vier Debug-DLLs von Visual Studio fehlten:

> *„ziel: möglichst einfach: zip runterladen, entpacken, starten - läuft. keine
> fehlenden DLLs, keine fehlermeldungen, daß etwas nicht gefunden werden kann
> oder nachinstalliert werden muß"*

Und auf die Frage nach dem Weg dorthin:

> *„sonst ja, statisch linken, ist mir auch egal."*

Kriterium 0 steht vor den anderen dreien, weil ohne lauffähiges Paket niemand
die anderen prüfen kann.

### Der Weg dorthin

| Weg | Ergebnis |
|---|---|
| **Debug-Bau** | vier nicht verteilbare DLLs nötig (`mfc140d`, `msvcp140d`, `vcruntime140d`, `ucrtbased` — Microsoft nimmt die Debug-Laufzeit ausdrücklich vom Weiterverteilen aus), dazu SUPERASSERT-Dialoge beim Start. **Ungeeignet fürs Ausliefern.** |
| **Release-Bau, dynamisch** | `mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll` sind verteilbar und dürfen beiliegen. Keine Dialoge mehr. **Das ist der heutige Zustand.** |
| **Release-Bau, statisch (`/MT` + MFC statisch)** | keine Laufzeit-DLL nötig; Gregors bevorzugter Weg. **Ausgeschlossen** — Eudora hat sechs MFC-Erweiterungs-DLLs (Befund F-1.1) |

Die vorgebauten Fremd-DLLs von 2006 (Paige32, EuMemMgr und die übrigen) bleiben
davon unberührt — sie sind eigene Module mit eigener Laufzeit und brauchen
weiterhin `MSVCR71.dll`. Dafür gibt es seit Befund B-1 einen **eigenen Nachbau**
(`Eudora71/VC71Bruecke`), der auf die von Windows selbst mitgelieferte
`msvcrt.dll` weiterleitet. Der darf mit ins Paket, er ist unser eigener Code.

### Woran sich Kriterium 0 misst

**Das ZIP auf einem Rechner ohne Visual Studio auspacken und starten** — kein
`0xc000007b`, keine Meldung über eine fehlende DLL, kein Nachinstallieren. Für
das Release-Paket ist dieser Lauf noch nicht gemacht worden.

> **`tools/paket-pruefen.ps1` ist NICHT dieser Nachweis.** Am 31.08.2026 war
> Kriterium 0 mit diesem Werkzeug als „gemessen erfüllt" gemeldet worden; die
> Gegenprobe hat es widerlegt: aus einer ausgepackten Kopie wurden
> `EudoraRes.dll`, `QCSSL.dll`, `SPELL32.DLL`, `EuGraph.ocx` und der ganze
> `Plugins`-Ordner gelöscht — das Ergebnis blieb **„keine Fehler, EXIT=0"**.
> **Der Prüfer prüft die Maschine, nicht das Paket.** Dazu erzeugt seine feste
> Debug-Laufzeitliste bei einem **Release**-Paket vier Falschwarnungen; wer
> ihnen folgt, holt sich die **nicht verteilbaren** DLLs ins Paket. Bis das
> behoben ist (PR-2.0 bis PR-2.3), ist es kein Freigabekriterium.

## Woran sich Kriterium 2 misst

Gregor hat als Vergleich ein Bildschirmfoto der Originalfassung geliefert
(Eudora 7 unter Windows XP). Maßgeblich sind daraus:

- Werkzeugleiste mit **allen** Symbolen, keine leeren grauen Felder
- Postfachbaum links, sauber abgegrenzt
- Nachrichtenfenster mit Kopfzeilenbereich und Textbereich untereinander
- Registerkarten am unteren Rand des Nachrichtenbereichs
- keine sich überlagernden Bereiche

Dazu kommt: **was man anklickt, muss auch aufgehen.** Ein Fenster, das erscheint,
aber nicht benutzbar ist, erfüllt kein Kriterium — das war Gregors Maßstab schon
am 30.08.2026 (*„das hauptfenster ist ja kaputt!"*). Deshalb zählen Strg-N, der
Doppelklick auf eine Nachricht und die Suchtreffer zu Kriterium 2 und nicht zu
den Kleinigkeiten.

Bekannte Abweichungen im Erscheinungsbild sind in `BEFUNDE.md` unter S-6
gesammelt.

## Woran sich Kriterium 3 misst

Nachweis ist ein tatsächlicher Abruf gegen einen echten Server, mit Beleg:
Protokollversion und Verfahren aus *Tools → Last SSL Info*, und mindestens eine
empfangene Nachricht, die lesbar dargestellt wird.

> **Erbracht.** Am 31.08.2026, 08:09:43 (Befund E-3): `mx.freenet.de` auf
> **Port 110 mit STARTTLS**, `TLSv1.3`, `TLS_AES_256_GCM_SHA384` (256 Bit),
> Status *Succeeded*, danach 159 abgerufene und lesbar dargestellte Nachrichten.
> Am 06.09.2026 zusätzlich über **Port 995** mit `TLSv1.3`,
> `Negotiation Status: Succeeded` — damit gilt auch der Weg mit implizitem TLS
> als belegt, und die frühere Einschränkung „nur über Port 110" ist überholt.

## Was daraus für die Benennung folgt

Der Dateiname `Eudora72-1.0.2-lauffaehig.zip` behauptet mehr, als die Fassung
kann. Künftige Pakete heißen nach ihrem tatsächlichen Stand. Siehe
`Releases/PAKETE.md`.
