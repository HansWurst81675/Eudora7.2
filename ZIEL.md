# Was „lauffähig" heißt

Von Gregor am 30.08.2026 festgelegt, nachdem eine Fassung als „lauffähig"
ausgeliefert wurde, die zwar startete, aber nicht bedienbar war.

> * es genügt nicht, daß das programm startet
> * die darstellung sollte korrekt sein
> * ich möchte damit einen mail server verbinden und mails abrufen.

## Die Kriterien

> **Diese Tabelle ist die Quelle.** `README.md`, `AUFGABEN.md`,
> `WEITERMACHEN.md`, `CHANGELOG.md`, `PORTIERUNG.md` und `Releases/PAKETE.md`
> verweisen hierher, statt sie zu wiederholen. Wer den Stand ändert, ändert ihn
> **hier**.

Stand **07.09.2026, morgens**, gemessen an Fassung **7.2.0.20 / Paket 1.0.20**.

**Acht Kriterien.** 0 bis 3 hat Gregor am 30.08.2026 festgelegt — sie messen, ob
Eudora *läuft*. 4 bis 6 kamen am 06.09.2026 dazu, nachdem Kriterium 0 gefallen
war — sie messen, ob man **damit arbeiten** kann. Ein Mailprogramm, das keine
Mail schreiben kann, ist kein Mailprogramm. **Kriterium 7** ist am 07.09.2026
nachgetragen, aus Gregors Urteil zu 1.0.18 (*„beenden kann ich es auch nicht"*).
Es steht eigens da und nicht als Unterpunkt von Kriterium 4, weil eine Meldung
beim Beenden kein Absturz ist, weil sie einen eigenen Befund hat (E-33) und weil
sie nach der Behebung von E-32 einzeln nachzumessen ist.

| # | Kriterium | Stand |
|---|---|---|
| 0 | Das Paket läuft ohne Nachinstallieren | **erfüllt** — Gregor hat `Eudora72-1.0.10-release.zip` am 06.09.2026 auf einem Rechner **ohne Visual Studio** ausgepackt und gestartet: *„test bestanden: eudora läuft ohne VS2022 installiert."* |
| 1 | Eudora startet und zeigt sein Hauptfenster | **erfüllt** — mehrfach gestartet und bedient |
| 2 | Die Darstellung ist korrekt | **fast** — Fenster, Menüs und Werkzeugleiste stimmen (E-1, E-2), Bau-Kennung im Titel (E-7), Fortschritt beim Abruf (E-13), Umlaute (Z-2, Z-2b), „In" nur noch einmal unter *Recent* (E-24), gesperrte Knöpfe zeigen ihr Symbol (E-30), Doppelklick und Suchtreffer öffnen die Nachricht (E-28). **Offen:** Meldung „Encountered an improper argument" beim Anzeigen mancher Nachrichten |
| 3 | Ein Mailkonto lässt sich einrichten, verbinden und Mail abrufen | **erfüllt** — POP3 über **Port 995 mit TLSv1.3**, `Negotiation Status: Succeeded`, von Gregor bestätigt |
| 4 | **Keine Abstürze** | **nicht erfüllt** — Strg-N und *Weiterleiten* beenden Eudora nicht mehr (E-31), und die modale Meldung „An unhandled exception has occurred" ist am 07.09.2026 behoben (**E-32**, `CHeaderView::OnKillFocusRecipient` in `headervw.cpp`). **Von Gregor nicht nachgemessen** — bis dahin bleibt das Kriterium offen; „Encountered an improper argument" steht ohnehin noch aus |
| 5 | **Eine neue Mail lässt sich schreiben und abschicken** | **nicht erfüllt** — der Fensterbau läuft vollständig durch (`OnMessageNewMessage: fertig`); ob der Anwender das Fenster nach der Behebung von E-32 auch **sieht**, ist nicht nachgemessen |
| 6 | **Eine Mail lässt sich weiterleiten** | **nicht erfüllt** — derselbe Weg, derselbe offene Nachweis |
| 7 | *File → Exit* beendet Eudora sauber | **nicht erfüllt** — es kommt eine Meldung (**E-33**), noch nicht untersucht |

**Drei von acht Kriterien sind belegt (0, 1, 3), eines fast (2), vier nicht (4
bis 7).**

> **Aus Anwendersicht hat sich am 06.09.2026 nichts verbessert.** Gregors Urteil
> zu 1.0.18: *„es crasht nicht, aber es passiert auch nichts. beenden kann ich
> es auch nicht. nichts statt crash ist auch keine verbesserung!"* Das ist der
> Maßstab — nicht, wie weit die Spur im Protokoll kommt.
>
> Was sich verbessert hat, ist die **Ausgangslage**, nicht das Programm: bis
> 06.09.2026 entstand in dieser Portierung kein einziges Paige-Fenster, und die
> Ursache war unbekannt. Jetzt ist sie gefunden und behoben (E-31). Ob daraus für
> den Anwender ein sichtbares Verfassen-Fenster wird, entscheidet der nächste
> Lauf auf Gregors Rechner — nicht diese Datei.

## Kriterium 0: das Paket muss ohne Nachinstallieren laufen

Von Gregor am 31.08.2026 festgelegt, nachdem Paket 1.0.2 mit `0xc000007b`
scheiterte, weil vier Debug-DLLs von Visual Studio fehlten:

> *„ziel: möglichst einfach: zip runterladen, entpacken, starten - läuft. keine
> fehlenden DLLs, keine fehlermeldungen, daß etwas nicht gefunden werden kann
> oder nachinstalliert werden muß"*

Und auf die Frage nach dem Weg dorthin:

> *„sonst ja, statisch linken, ist mir auch egal."*

Kriterium 0 steht vor allen anderen, weil ohne lauffähiges Paket niemand die
übrigen prüfen kann.

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
`0xc000007b`, keine Meldung über eine fehlende DLL, kein Nachinstallieren.
**Erbracht am 06.09.2026** von Gregor selbst, mit dem **Release**-Paket
`Eudora72-1.0.10-release.zip`: *„test bestanden: eudora läuft ohne VS2022
installiert."*

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
