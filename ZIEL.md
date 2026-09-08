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

Stand **08.09.2026**, gemessen an Fassung **7.2.0.22 / Paket 1.0.22**.

**Neun Kriterien.** 0 bis 3 hat Gregor am 30.08.2026 festgelegt — sie messen, ob
Eudora *läuft*. 4 bis 6 kamen am 06.09.2026 dazu, **Kriterium 7** (sauberes
Beenden) am 07.09.2026 aus seinem Urteil zu 1.0.18 (*„beenden kann ich es auch
nicht"*), **Kriterium 8** (die offenen Fenster sichtbar und auswählbar) am
07.09.2026 nach dem ersten geglückten Verfassen-Fenster. Sie messen, ob man
**damit arbeiten** kann. Ein Mailprogramm, das keine Mail schreiben kann, ist
kein Mailprogramm.

| # | Kriterium | Stand |
|---|---|---|
| 0 | Das Paket läuft ohne Nachinstallieren | **erfüllt** — Gregor hat `Eudora72-1.0.10-release.zip` am 06.09.2026 auf einem Rechner **ohne Visual Studio** ausgepackt und gestartet: *„test bestanden: eudora läuft ohne VS2022 installiert."* |
| 1 | Eudora startet und zeigt sein Hauptfenster | **erfüllt** — mehrfach gestartet und bedient |
| 2 | Die Darstellung ist korrekt | **fast** — Fenster, Menüs und Werkzeugleiste stimmen (E-1, E-2), Bau-Kennung im Titel (E-7), Fortschritt beim Abruf (E-13), Umlaute (Z-2, Z-2b), „In" nur noch einmal unter *Recent* (E-24), gesperrte Knöpfe zeigen ihr Symbol (E-30), Doppelklick und Suchtreffer öffnen die Nachricht (E-28). **Offen:** Meldung „Encountered an improper argument" beim Anzeigen mancher Nachrichten |
| 3 | Ein Mailkonto lässt sich einrichten, verbinden und Mail abrufen | **erfüllt** — POP3 über **Port 995 mit TLSv1.3**, `Negotiation Status: Succeeded`, von Gregor bestätigt |
| 4 | **Keine Abstürze** | **fast** — Strg-N stürzt nicht mehr ab (fünfmal nachgemessen an 7.2.0.21, danach 20 s offen: kein `Exception.log`). Drei Fehler lagen hintereinander: **E-34**, **E-35**, **E-36**. **Offen bleibt das Beenden**, siehe Kriterium 7 |
| 5 | **Eine neue Mail lässt sich schreiben und abschicken** | **erfüllt** — Gregor hat am 07.09.2026 mit 7.2.0.21 eine Mail geschrieben und abgeschickt: *„mail können jetzt abgeschickt werden."* Belegt durch sein Bildschirmfoto: *Out* enthält „test von freenet nach GMX", 10:01 Uhr |
| 6 | **Eine Mail lässt sich weiterleiten** | **erfüllt** — dasselbe Bildschirmfoto zeigt die **Antwort** darauf im Postfach *In*: „Re: test von freenet nach GMX — ja, ist da.", 10:02 Uhr. Verfassen, Senden, Zitieren und Empfangen laufen damit im Kreis |
| 7 | *File → Exit* beendet Eudora sauber | **erfüllt** — Gregor am 08.09.2026 an Paket 1.0.22: *„schließen klappt jetzt."* Alle drei Wege beenden: Menü, Alt-F4 und das Kreuz. Behoben durch **E-40**, **E-41** und **E-42**: ein Fehler beim *Aufräumen* verhindert das Beenden nicht mehr, nur eine bewusste Entscheidung des Anwenders. Der Fehler selbst ist damit **nicht** verschwunden — er steht als Protokollzeile da (`E-42 Beenden: Schritt 'SaveBarState(ToolBar)' hat eine Ausnahme ausgelöst`) und ist als **E-43** weiter offen |
| 8 | **Die offenen Fenster sind sichtbar und auswählbar** | **halb** — das Menü *Window* listet sie auf, von Gregor nachgesehen („1 In", „2 Out"). Was fehlt, ist die **Registerkartenleiste am unteren Fensterrand**: die Ersatzschicht bildet sie nicht nach. Gregors Frage dazu: *„kann man die untere zeile (status) immer anzeigen lassen?"* |

**Sechs von neun Kriterien sind belegt (0, 1, 3, 5, 6, 7), zwei fast oder halb
(2, 4), eines nicht (8 - die Reiterleiste).**

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

> **`tools/paket-pruefen.ps1` war einmal kein Nachweis, ist es heute aber.** Am
> 31.08.2026 war Kriterium 0 mit diesem Werkzeug als „gemessen erfüllt" gemeldet
> worden; die Gegenprobe hat es widerlegt: aus einer ausgepackten Kopie wurden
> `EudoraRes.dll`, `QCSSL.dll`, `SPELL32.DLL`, `EuGraph.ocx` und der ganze
> `Plugins`-Ordner gelöscht — das Ergebnis blieb **„keine Fehler, EXIT=0"**. Das
> Werkzeug prüfte die Maschine, nicht das Paket, und seine feste
> Debug-Laufzeitliste erzeugte bei einem Release-Paket vier Falschwarnungen, die
> zum Lizenzverstoß anleiteten. **Das ist am 06.09.2026 behoben** (PR-2.0,
> Commit `dfc8b40`): es rechnet die Startkette aus den PE-Import- und
> Verzögerungstabellen aus, zählt einen Treffer in `SysWOW64`/`System32`
> ausdrücklich **nicht** als vorhanden und weist den Weg über
> `laufzeit-holen.ps1` selbst ab — mit drei Gegenproben belegt
> (`Befunde/PAKET.md`). Es ersetzt trotzdem keinen Startversuch auf einem
> fremden Rechner: es sagt, ob der Lader alles findet, nicht ob Eudora läuft.

## Anforderungen neben den Kriterien

Die neun Kriterien oben sagen, wann eine Fassung **abnahmefähig** ist. Daneben
stellt Gregor einzelne Anforderungen, die kein Kriterium sind, aber genauso
verbindlich — sie bekommen eine Kennung `A-n` und stehen hier, damit sie
nachprüfbar sind und nicht nur in einer Werkzeugdatei behauptet werden.

### A-1 — Vorgaben für ein **neu angelegtes** Konto

Gestellt am 07.09.2026, mit zwei Bildschirmfotos der Kontoeinstellungen:

> *„die zwei markierte dinge möchte ich als default bei jedem konto. zum testen
> ist es wichtig, sonst werden die mails abgerufen und gelöscht, wenn ich nicht
> dran denke."*

und, nach der Klärung, dass ein bestehendes Konto damit nicht erreichbar ist:

> *„für neue konten. bestehendes kann ich selbst korrigieren."*
>
> *„anforderung an neues konto: beide optionen so setzen, wenn ich per wizard
> ein neues konto anlege."*

**Verbindlich sind diese vier Werte.** Ein per Assistent oder über *New…* neu
angelegtes Konto muss sie tragen:

| Schlüssel | Wert | im Dialog | markiert am |
|---|---|---|---|
| `SSLSendUse` | `2` | *Secure Sockets when Sending* → **Required, Alternate Port** | 07.09.2026, Bild 1 |
| `CheckMailByDefault` | `1` | *Check Mail* angehakt | 07.09.2026, Bild 1 |
| `SSLReceiveUse` | `2` | *Secure Sockets when Receiving* → **Required, Alternate Port** | 07.09.2026, Bild 2 |
| `LeaveMailOnServer` | `1` | *Leave mail on server* angehakt | 07.09.2026, Bild 2 |

Die Zahlen der beiden SSL-Werte sind die Reihenfolge im Auswahlfeld
(`SSLSettings::SSLUsage`, `Eudora71/Eudora/SSLSettings.h:30-36`): `0` Never,
`1` If Available STARTTLS, `2` Required Alternate Port, `3` Required STARTTLS.

**Begründung, die den Umfang festlegt:** Gregor nennt als Grund, dass Testmails
sonst abgerufen **und auf dem Server gelöscht** werden. Das leisten die zwei von
ihm markierten Häkchen **nicht** — *Check Mail* schaltet den Abruf ein, die
SSL-Wahl betrifft nur die Verbindung. Erforderlich dafür ist
`LeaveMailOnServer`; deshalb gehört es zur Anforderung, obwohl er es nicht
markiert hat. Dazu `LeaveOnServerDays=0` und `ServerDelete=0`, die das Löschen
auf anderen Wegen wieder einschalten würden.

**Erfüllt** seit dem 07.09.2026 durch `tools/DEudora.ini`, die
`tools/paket-bauen.ps1` neben `Eudora.exe` ins Paket legt. Eudora liest sie in
`GetDefaultIniSetting` (`Eudora71/Eudora/rs.cpp:357-385`) **vor** den in
`EudoraRes.rc` eingebauten Vorgaben. Belegt ist die Kette bis in die
`Eudora.ini` hinein: `AccountWizard/Src/WizardPropSheet.cpp:137` →
`CPersParams::GetDefaultParams` (`PersParams.cpp:195`, liest die Datei bei
`:215` und `:236-237`) → der Assistent überschreibt die vier Werte nirgends
(kein Treffer in ganz `Eudora71/AccountWizard`) → `WizardPropSheet.cpp:193`
`g_Personalities.Add` → geschrieben in `persona.cpp:988` (`LeaveMailOnServer`)
und `:1051` (`SSLReceiveUse`). **Am laufenden Programm bestätigt**: Gregor am
08.09.2026 an Paket 1.0.22, nach dem Anlegen eines neuen Kontos: *„default
werte beim neuen persona konto für ‚leave message on server' greifen."*

`tools/paket-pruefen.ps1` warnt, wenn die Datei im Paket fehlt oder einen der
vier Werte nicht trägt, und `tools/doku-pruefen.pl` hält die Datei gegen diese
Tabelle — eine Anforderung ohne Schranke ist ein Versprechen.

**Was A-1 ausdrücklich nicht verlangt:** ein **bestehendes** Konto zu ändern.
`CPersonality::GetIniDefaultValue` (`persona.cpp:606-620`) liest beim Laden
eines vorhandenen Kontos ausschließlich die Ressource, nie die `DEudora.ini`.
Gregors Wort dazu: *„bestehendes kann ich selbst korrigieren."* Von Hand geht es
in der `Eudora.ini` des Mailverzeichnisses — `<Dominant>` im Abschnitt
`[Settings]`, jedes weitere in `[Persona-<Name>]` (`persona.cpp:897-898`,
Präfix `:52`).

### A-2 — *Task Status* und *Task Errors* waagrecht unten

Gestellt am 08.09.2026, nachdem Gregor die Leisten im Prüfstand gesehen hatte:

> *„task errors und task status wären waagrecht unten besser als senkrecht —
> nach dem exit-fix korrigieren."*

Beide Bereiche lagen **senkrecht** als schmale Spalten links neben dem
MDI-Bereich. Verlangt ist eine **waagrechte** Anordnung am unteren Fensterrand.
Die Reihenfolge, die Gregor selbst gesetzt hat, gilt: **erst** Kriterium 7 (das
Beenden), dann das.

Zusammenhang mit Kriterium 8: dort geht es um die **Reiterleiste** für die
offenen Fenster (die WazooBar am unteren Rand). A-2 betrifft dieselbe Gegend
des Fensters und dieselbe Ersatzschicht `OTShim` — wer eines angeht, sieht sich
das andere gleich mit an.

**Woran A-2 sich messen lässt.** Nach dem Start muss `tools/leisten-messen.ps1`
für die Leiste mit der Kennung **320** melden: Andockseite **unten**,
**Sichtbar = True**, Höhe **80**, Breite = Breite des Hauptfensters minus
Rahmen. Und zwar **sowohl** beim ersten Start (frisches Profil, kein
`[WazooBars]`-Abschnitt) **als auch** bei jedem weiteren Start mit vorhandener
`Eudora.ini` — das sind zwei verschiedene Programmwege, und nur der zweite ist
der, den Gregor gesehen hat.

**Umgesetzt in 7.2.0.23** (Befund **E-44**), von Gregor noch nicht bestätigt.
Zwei Ursachen, beide gemessen, beide behoben:

1. Beim frischen Profil lag die Leiste schon richtig (unten, 1712×80) und wurde
   nur durch `ID_SEC_HIDE` in `WazooBarMgr.cpp`, `SetDefaultWazooBarState`
   Fall 2, sofort wieder **versteckt**. Diese Zeile ist entfallen.
2. Ab dem zweiten Start läuft ein anderer Zweig, der die Andockseite
   **überhaupt nicht** setzt: `LoadWazooConfigFromIni` (`WazooBar.cpp:552`)
   stellt nur wieder her, welche Fenster in einer Leiste sitzen. Die Lage käme
   aus MFCs `LoadBarState` und damit aus dem INI-Abschnitt `[ToolBar...]` —
   den es nicht gibt, weil `SaveBarState` beim Beenden abbricht (**E-43**).
   Jetzt wird die Standardanordnung nachgezogen, wenn eine Leiste an keiner
   Andockleiste hängt.

Fundstellen: `Eudora71/Eudora/WazooBarMgr.cpp` (`SetDefaultWazooBarState`,
`LoadWazooBarConfigFromIni`), `Eudora71/Eudora/WazooBar.cpp:552`, Abschnitt
`[WazooBars]` in der `Eudora.ini` (Schlüssel `WazooBarIds`, `WazooBar%d`,
`WazooMDI%d`, Namen in `EudoraRes.rc:10637-10640`), und die Andockseite in
`Eudora71/OTShim/OTShim.cpp:293` (`SECMDIFrameWnd::DockControlBarEx`).

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
