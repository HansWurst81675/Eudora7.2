# PRÜFER-39 — 7.2.0.111: die Wache beim Beenden sieht jetzt jede Übertragungsart

Gegenstand: zwei Commits auf `e-123-transfersame`, Quellstand **7.2.0.111 / 1.0.111**.

| Commit | Inhalt | Dateien |
|---|---|---|
| `a093c03c` | Zählschleife und Merker auf die Basisklasse; Zähler in `CImapSameServerTransferMsgAction::DoWork`; neue Schranke; Fassungssprung | `EuImap/src/ImapActionQueue.cpp`, `tools/pruefe-e123-zaehlung.pl`, `Version.h`, `VERSION`, 14 MDs |
| `903bbd42` | LEKTORAT-Nachtrag zum Versionssprung | `LEKTORAT.md` |

**Wie geprüft.** Am Quelltext gelesen, nichts mit Oberfläche gestartet.
Eigene Messungen: die neue Schranke selbst gefahren (`--selbsttest`, gegen die
Branch-Fassung, gegen `origin/main:…/ImapActionQueue.cpp`) und mit **sieben
erfundenen Umgehungsfassungen** beschossen. Quelle im Kratzverzeichnis:
`…\scratchpad\p39\umgehung.pl`. Dazu die Fadenwege von `DoWork` und
`DoPostProcessing` am Quelltext belegt.

---

## Urteil

**Paket 1.0.111 zu Gregor: NEIN — nicht mit der dritten Änderung drin. Sie ist
drei Zeilen, und sie kann Eudora unbeendbar machen. Ohne sie ist der Zweig
fertig.**

**Die gute Nachricht zuerst: Gregors Fehler ist behoben, und zwar durch die
ersten beiden Änderungen allein.** Sein Protokoll sagte `eintraege=1` bei
`uebertragungen=0` — ein Eintrag, der noch in `m_array` stand und nie gestartet
war. Die Zählschleife auf `CImapTransferMsgAction` zählt ihn. Die dritte
Änderung (Zähler in `DoWork`) trägt zu seinem Fall **nichts** bei: zu dem
Zeitpunkt lief die Aufgabe gar nicht.

> **N1: Der Zähler in `CImapSameServerTransferMsgAction::DoWork` kann Eudora
> dauerhaft unbeendbar machen.** `DoWork` läuft im **Nebenfaden**
> (`QCTaskManager.cpp:1095`, `ThreadStartupFunc`) und blockiert dort unbegrenzt
> auf dem Netz; `CImapAction::RequestThreadStop()` ist ein **leerer Rumpf**
> (`ImapActionQueue.cpp:709`) — niemand bricht den Faden ab. Solange der Zähler
> steht, nimmt die Wache jedes Mal den Zweig `bNotfall && bLaeuft`
> (`mainfrm.cpp:2005`): kein `WM_CLOSE`, und seit PRUEFER-38/R4 dazu
> `m_bE123Gewartet = FALSE` (`:2029`). Der nächste Versuch wartet also wieder
> fünf Minuten und gibt wieder auf — **endlos**. Heraus kommt Gregor nur über
> den Offline-Modus oder den Task-Manager.

> **N2: Der Zähler steht am falschen Ort — er deckt die harmlose Phase und
> lässt die gefährliche offen.** Die Begründung für „bei `bLaeuft` nie beenden"
> war (PRUEFER-36/P1): `CloseDown` liefe **verschachtelt** im Hochladen. Das
> gilt für Arbeit im **Hauptfaden**. `SameServer::DoWork` läuft im Nebenfaden —
> dort kann `CloseDown` gar nicht verschachteln. Umgekehrt steht die eigentliche
> Arbeit von **ToLocal und CrossServer** in `DoPostProcessing`, und das läuft im
> **Hauptfaden** (`QCTaskManager.cpp:669` `ASSERT(::IsMainThreadMT())`, gerufen
> aus `eudora.cpp:2603`) — **ohne** Zähler. `CImapToLocalTransferMsgAction::DoWork`
> ist bis auf eine Zeigerprüfung leer.

### Funde

| Fund | Schwere | Stand |
|---|---|---|
| **N1** Zähler in `SameServer::DoWork` blockiert das Beenden unbegrenzt; jeder weitere Versuch wartet neu | **hoch.** Genau die Symptomklasse, gegen die [E-33](../BEFUNDE.md#e-33) und [E-123](../BEFUNDE.md#e-123) angelegt sind | **belegt am Quelltext**; dass ein `XferMessagesOnServer` tatsächlich hängt, ist nicht gemessen |
| **N2** Zähler deckt die Nebenfaden-Phase, nicht die drei Hauptfaden-`DoPostProcessing` | **mittel.** Der eigentliche Schutzzweck bleibt unerfüllt | belegt am Quelltext |
| **N3** Die Schranke steht **nicht** in `tools/hooks-einrichten.sh` — nur in der unversionierten `.git/hooks/pre-commit` dieser Maschine | **mittel.** Nach frischem Klon fehlt sie; `WERKZEUGE.md` nennt sie trotzdem „pre-commit-Schranke" | **gemessen** (0 Treffer in der Hook-Quelle) |
| **N4** Die Schranke lässt sechs von sieben naheliegenden Umgehungen durch, darunter die im Auftrag genannte Hilfsvariable **und die ganz entfernte Zählschleife** | **mittel.** Prüflücke | **gemessen**, 7 Fassungen |
| **N5** Bereichserkennung der Schranke öffnet bei jeder *Nennung* des Funktionsnamens; `HatOffeneUebertragung` darf **nicht** auf die Basisklasse umgestellt werden | gering, Fehlalarmgefahr mit Folgeschaden | belegt am Quelltext |
| **N6** Keine Doppelzählung, kein hängenbleibender Zähler — Fragen 3 und 4 entwarnt | kein Fund | belegt am Quelltext |
| **N7** Die Basisklasse zählt genau die acht Übertragungsarten und keine andere; `ToLocal` kostet höchstens 90 s | kein Fund | belegt am Quelltext |
| **N8** Kein Datenverlust durch das Warten; eine **gestartete** Aufgabe steht aber nicht mehr in `actionqueue.dat` | gering, Altbestand | belegt am Quelltext |
| **N9** Nicht am laufenden Programm gemessen; Gregor ist wieder der Prüfstand. Die Commit-Nachricht sagt es offen | Prüflücke, bekannt | belegt |

**Was vor dem Paket hinein muss: N1.** Die billigste und sauberste Fassung ist,
die drei Zeilen wieder zu entfernen — sein Fehler ist dann trotzdem behoben.
**N3** gehört in denselben Commit (eine Zeile). Alles andere kann nach.

---

## N1 — der Zähler kann Eudora unbeendbar machen

### Der Weg, Schritt für Schritt

1. Gregor verschiebt innerhalb des IMAP-Kontos. `OnIdle` reicht die Aufgabe an
   den Fadenverwalter (`ImapActionQueue.cpp:3765`), nimmt sie aus `m_array`
   (`:3778`) und setzt `m_bE123UebertragungLaeuft = true` (`:3777`).
2. Der Fadenverwalter startet `ThreadStartupFunc`
   (`QCTaskManager.cpp:1081-1097`), und dort läuft `pWorkThread->DoWork()` —
   **im Nebenfaden**. Das ist für `CImapSameServerTransferMsgAction` der Ort,
   an dem `XferMessagesOnServer` und `DeleteMessagesFromServer` wirklich mit
   dem Server reden (`ImapActionQueue.cpp:1793-1801`).
3. Neu seit diesem Commit: die erste Anweisung in diesem Rumpf ist
   `CE123HochladenZaehler e123Zaehler(true);`. Ab jetzt liefert
   `E123HochladenLaeuft()` **true**.
4. Gregor beendet. `OnClose` findet `nOffen == 1` (die laufende Aufgabe über
   `bLaeuft` in `E123OffeneUebertragungen`, `ImapActionQueue.cpp:4038-4042`),
   startet den Zeitgeber und wartet.
5. Alle 2 s prüft `OnTimer`. `bLaeuft` kommt aus dem Zähler
   (`ImapAccountMgr.cpp:1286`) und ist **true**.
6. Die 90-s-Regel greift nicht (`!bLaeuft` ist falsch). Nach 300 s greift
   `if (bNotfall && (bLaeuft || bDialogOffen))` (`mainfrm.cpp:2005`):
   Zeitgeber aus, **kein `WM_CLOSE`**, Statuszeile
   *„Quit cancelled: messages are still being transferred to the IMAP server."*
7. Dort steht seit PRUEFER-38/R4 auch `m_bE123Gewartet = FALSE` (`:2029`).
   Beim nächsten *File → Exit* findet `OnClose` deshalb wieder
   `m_bE123Gewartet == FALSE`, und `nOffen` ist weiterhin 1 — **der volle
   Fünf-Minuten-Lauf beginnt von vorn.**

**Es gibt keinen Ausstieg**, solange `DoWork` nicht zurückkehrt. Und
zurückkehren muss es nicht: `CImapAction::RequestThreadStop()` ist leer
(`ImapActionQueue.cpp:709-711`), es gibt kein `TerminateThread` im
Produktivcode, und der Nebenfaden hängt an einem Netzlesevorgang.

### Warum das nicht nur Theorie ist: der unsichtbare Zeitüberschreitungsdialog

Reagiert der Server nicht mehr, ruft die IMAP-DLL ihren Rückruf
`__TimeoutQuery` (`ImapConnection.cpp:3829`, gesetzt in `__OpenMailbox`
`:3419` und `__OpenControlStream` `:3549`):

```cpp
BOOL  __TimeoutQuery ()
{
	return AlertDialog (IDD_NETWORK_TIMEOUT, NULL) == IDOK;
}
```

`AlertDialog` beginnt mit `ASSERT(::IsMainThreadMT());` (`guiutils.cpp:907`).
Im **Release ist das nichts** ([ASSERT ist im Release nichts](../Arbeitsweise/assert-ist-im-release-nichts.md)). Der modale Dialog
läuft also im Nebenfaden, mit `pParent = NULL`; der Nebenfaden hat kein
`m_pMainWnd`, der Dialog bekommt damit keinen Besitzer und **sperrt das
Hauptfenster nicht**. Folge:

* der Dialog kann hinter dem Hauptfenster liegen und wird übersehen,
* `bDialogOffen = !IsWindowEnabled()` bleibt **FALSE**,
* `bLaeuft` bleibt **TRUE**, weil der Zähler auf dem Stapel von `DoWork` liegt,
* Gregor liest nur *„messages are still being transferred"* und sieht nichts,
  was er schließen könnte.

**Stand:** der Fadenweg, der leere `RequestThreadStop`, der Zweig in `OnTimer`
und das `ASSERT` sind **am Quelltext belegt**. Dass ein `XferMessagesOnServer`
bei Gregor tatsächlich hängenbleibt, ist **nicht gemessen** — dafür bräuchte es
einen Server, der mitten im `COPY` verstummt.

### Der eine Ausweg, den es gibt

`CImapAccountMgr::E123OffeneUebertragungen` kehrt im Offline-Modus vor der
Zählung zurück (`ImapAccountMgr.cpp:1289-1290`). Wer *Offline* schaltet, kommt
heraus. Das muss man wissen; in der Meldung steht es nicht.

### Kleinster sicherer Gegenvorschlag

**(a) — empfohlen: die drei Zeilen wieder heraus.** Gregors Fehler ist durch
die Zählschleife behoben. Die laufende Nebenfaden-Phase ist über
`m_bE123UebertragungLaeuft` ohnehin schon in `nOffen` enthalten
(`ImapActionQueue.cpp:4038`), das Beenden wartet also auch ohne den Zähler auf
sie — nur eben **begrenzt**, höchstens 90 s, und genau das ist hier richtig:
`CloseDown` kann im Hauptfaden nicht in einer Nebenfaden-Übertragung
verschachteln.

**(b) — wenn der Nebenfaden ausdrücklich gezählt werden soll:** ein **zweiter**
Zähler, der in `nOffen` eingeht statt in `bLaeuft`. Dann wirkt er wie ein
Warteschlangeneintrag, die 90-s-Grenze bleibt wirksam, und es gibt keinen
Zustand ohne Ausgang:

```cpp
static LONG s_lE123NebenfadenLaeuft = 0;
bool E123NebenfadenLaeuft() { return s_lE123NebenfadenLaeuft > 0; }
```

— und in `E123OffeneUebertragungen` `++nOffen`, wenn gesetzt, statt `bLaeuft`
zu setzen.

## N2 — der Zähler deckt die falsche Phase

Wo bei den vier Übertragungsarten die Arbeit wirklich steht, und wo der Zähler:

| Klasse | Arbeit in | Faden | Zähler? |
|---|---|---|---|
| `CImapFromLocalTransferMsgAction` | `DoPreThreadAction` (`:2304`), `DoPostProcessing` (`:2398`) | **Haupt** | ja, beide |
| `CImapSameServerTransferMsgAction` | **`DoWork`** (`:1771`) | **Neben** | **ja, neu** |
| `CImapSameServerTransferMsgAction` | `CImapTransferMsgAction::DoPostProcessing` mit `DoManualResync` | **Haupt** | **nein** |
| `CImapCrossServerTransferMsgAction` | `DoPostProcessing` — `ImapFetchMessagesFromServer`, `ImapCopyMsgBetweenAccounts`, `DeleteMessagesFromServer` | **Haupt** | **nein** |
| `CImapToLocalTransferMsgAction` | `DoPostProcessing` — `ImapFetchMessagesFromServer`, `ImapCopyMsgFromImapToLocal`, `DeleteMessagesFromServer` | **Haupt** | **nein** |

`CImapToLocalTransferMsgAction::DoWork` und
`CImapCrossServerTransferMsgAction::DoWork` tun **nichts** als Zeiger prüfen —
die ganze Arbeit liegt in der Nachbearbeitung im Hauptfaden.

**Warum das genau verkehrt herum ist.** Der Grund, aus dem bei `bLaeuft` nie
beendet werden darf, ist die Verschachtelung: `CloseDown` liefe **innerhalb**
des Hochladens ab (PRUEFER-34 Lauf d, PRUEFER-36 P1). Das kann nur passieren,
wenn die Arbeit im **Hauptfaden** steht und dabei Botschaften zustellt — und
das tut sie: `EscapePressed` (`guiutils.cpp:1669`) wird aus dem IMAP-Weg
gerufen (`ImapMailbox.cpp:1014`, `:1718`, `:1976` und weitere) und dispatcht
mit `PM_REMOVE` alles, was ansteht, also auch ein zuvor gepostetes `WM_CLOSE`.

Im Nebenfaden ist diese Gefahr **ausgeschlossen**. Dort gewinnt man durch
unbegrenztes Warten nichts und riskiert N1.

**Kleinster sicherer Gegenvorschlag:** den Zähler aus `SameServer::DoWork`
herausnehmen und statt dessen je eine Zeile an den Anfang von

* `CImapTransferMsgAction::DoPostProcessing` — deckt `SameServer` und
  `CrossServer` über die Basisfassung mit,
* `CImapToLocalTransferMsgAction::DoPostProcessing`,
* `CImapCrossServerTransferMsgAction::DoPostProcessing`.

Alle drei laufen im Hauptfaden und kehren zurück; der Zähler kann dort nicht
länger stehen als eine Nachbearbeitung dauert. Das ist dieselbe Bauweise, die
für `CImapFromLocalTransferMsgAction` seit PRUEFER-36 steht und sich bewährt
hat.

**Reihenfolge:** N2 **nicht ohne N1** einbauen. Wer N2 einbaut und den
`DoWork`-Zähler stehen lässt, hat beide Zustände.

## N3 — die Schranke steht nicht im versionierten Haken (gemessen)

```
$ git show e-123-transfersame:tools/hooks-einrichten.sh | grep -c e123-zaehlung
0
$ grep -n "e123-zaehlung" .git/hooks/pre-commit
381:schranke pruefe-e123-zaehlung.pl || exit $?
```

Die Zeile steht **nur** in der unversionierten `.git/hooks/pre-commit` dieser
Maschine. `tools/hooks-einrichten.sh` — die Datei, deren Kopf sagt „Muss
einmal nach jedem frischen Klon laufen… ohne diesen Schritt fehlen alle
Schranken und die Fehler, gegen die sie schuetzen, treten lautlos wieder
auf" — kennt sie nicht. Nach dem nächsten frischen Klon oder dem nächsten
Lauf von `hooks-einrichten.sh` ist die Schranke **weg**, während
`tools/WERKZEUGE.md` und die Commit-Nachricht sie als „15. Schranke im
pre-commit" führen.

Das ist [Schranke gehört in den Haken](../Arbeitsweise/schranke-gehoert-in-den-haken.md), eine Zeile.

**Gegenvorschlag:** `schranke pruefe-e123-zaehlung.pl || exit $?` in
`tools/hooks-einrichten.sh` eintragen, an derselben Stelle wie im laufenden
Haken, und zwar in **beiden** dort erzeugten Haken, wenn die Schranke in beide
gehört.

## N4 — die Schranke findet die Umgehungen nicht (gemessen)

Erst die gute Hälfte. Gefahren, selbst, am 20.10.2026:

```
--selbsttest                       2 Faelle, 0 Fehler                 rc=0
gegen e-123-transfersame           ok, keine Uebertragungsart blind   rc=0
gegen origin/main (Fehlerstand)    2 Mangel: Zeile 3768 und 4007      rc=1
```

Die Gegenprobe trifft den **echten** Fehler und lässt den erlaubten Fall durch.
Das ist [Schranke gegentesten](../Arbeitsweise/schranke-gegentesten.md) richtig gemacht.

Jetzt die andere Hälfte. Sieben erfundene Fassungen durch `pruefe_text`
geschickt (`…\scratchpad\p39\umgehung.pl`):

| Fassung | Ergebnis |
|---|---|
| A C-Cast `(CImapFromLocalTransferMsgAction*)` statt `dynamic_cast` | **durchgelassen** |
| B `dynamic_cast<` am Zeilenende, Klasse in der nächsten Zeile | **durchgelassen** |
| C Cast in einer Hilfsfunktion über der Zählschleife | **durchgelassen** |
| D Zählschleife ganz entfernt — zählt nie etwas | **durchgelassen** |
| E Merker: `dynamic_cast<` umgebrochen, Unterklasse in der Folgezeile | **durchgelassen** |
| F Merker über eine Hilfsvariable gesetzt | **durchgelassen** |
| G Rumpfabschluss eingerückt — Bereich schließt nie | erkannt, aber als Fehlalarm in der *nächsten* Funktion |

**F ist genau die Umgehung aus dem Auftrag** („ein `dynamic_cast` über eine
Hilfsvariable"), und sie kommt durch. **D ist die schlimmste:** wer die
Zählschleife leert oder die Bedingung umdreht, lässt die Schranke grün und die
Wache blind — also wieder genau Gregors Fehler, mit grünem Haken darüber.

Die Schranke prüft heute **nur, dass nichts Falsches dasteht**, nicht, **dass
das Richtige dasteht**.

**Kleinster sicherer Gegenvorschlag**, zwei Ergänzungen in `pruefe_text`:

1. **positiv prüfen:** im Bereich der Zählschleife **muss**
   `dynamic_cast<CImapTransferMsgAction*>` vorkommen, und die Zuweisung an
   `m_bE123UebertragungLaeuft` (außer `= false`) **muss** sie ebenfalls
   enthalten. Fehlt sie, ist das ein Mangel. Das erschlägt A, C, D und F.
2. **breiter suchen:** im Bereich ist die **Nennung** einer Unterklasse
   verboten, nicht nur in `dynamic_cast<…>` — gesucht wird auf
   Nicht-Kommentarzeilen nach den vier Klassennamen selbst. Das erschlägt
   B, E und F.

Dazu, weil die Schranke sonst eine falsche Sicherheit trägt: **die dritte der
drei Stellen prüft sie gar nicht.** Ob ein Übertragungsrumpf einen
`CE123HochladenZaehler` trägt, steht nirgends unter Aufsicht. Die
Commit-Nachricht sagt „haelt die drei E-123-Stellen darauf fest" — gemeint
und geprüft sind die Zählschleife und der Merker, und ein dritter Cast, den es
nicht gibt.

## N5 — der geprüfte Bereich hängt an einer Namensnennung

Die Bereichserkennung öffnet bei **jeder** Zeile, in der der Name
`E123OffeneUebertragungen` vorkommt — auch in einem Kommentar
(`ImapActionQueue.cpp:678`), auch in einer künftigen Aufrufstelle in derselben
Datei — und schließt erst bei der nächsten schließenden Klammer in Spalte 1.

Heute geht das gut: die Nennung in Zeile 678 liegt in einem Kommentarblock, und
Kommentarzeilen werden ohnehin übersprungen; die erste schließende Klammer in
Spalte 1 danach ist das Rumpfende von `CImapAction::DoPreThreadAction`.

**Warum es trotzdem zählt.** Vierzig Zeilen unter der Zählschleife steht
`CActionQueue::HatOffeneUebertragung` (`ImapActionQueue.cpp:4064`), und die
**muss** auf `CImapFromLocalTransferMsgAction` prüfen. Dort werden
`m_szMessageIDs` gegen einen **lokalen** Hash verglichen ([E-121](../BEFUNDE.md#e-121) P3, die
Schutzvermerke der eingebetteten Bilder). Bei den anderen drei Arten stehen in
`m_szMessageIDs` **IMAP-UIDs**, keine lokalen Hashes — eine Umstellung auf die
Basisklasse gäbe Falschtreffer, und eingebettete Bilddateien würden nicht mehr
gelöscht. Öffnet der Bereich eines Tages zu früh, meldet die Schranke genau
diese Zeile, und die naheliegende „Behebung" macht [E-121](../BEFUNDE.md#e-121) P3 kaputt.

**Gegenvorschlag:** den Bereich an der **Definitionszeile** öffnen
(`^int\s+CActionQueue::E123OffeneUebertragungen`), nicht an jeder Nennung —
und `HatOffeneUebertragung` in der Schranke namentlich ausnehmen, mit genau
dieser Begründung als Kommentar.

## N6 — Doppelzählung und hängenbleibender Zähler: entwarnt

**Frage 3 — zählt irgendeine Klasse jetzt zweimal?** Nein.

| Klasse | `DoPreThreadAction` | `DoWork` | `DoPostProcessing` |
|---|---|---|---|
| `FromLocal` | Zähler | — | Zähler |
| `SameServer` | Basisfassung, kein Zähler | **Zähler (neu)** | Basisfassung, kein Zähler |
| `CrossServer` | kein Zähler | kein Zähler | kein Zähler |
| `ToLocal` | kein Zähler | kein Zähler | kein Zähler |

Keine Klasse trägt zwei Zähler auf **einem** Stapel. Bei `FromLocal` liegen die
beiden nacheinander, nicht ineinander — das hat PRUEFER-38 Punkt 4 schon
nachgerechnet und gilt unverändert. Und selbst wenn sich zwei Zähler
schachteln, ist das unschädlich: es ist ein Zähler, kein Merker.

**Frage 2 — Lebensdauer und Faden.** `CE123HochladenZaehler` ist ein
Stapelobjekt (`ImapActionQueue.cpp:654-662`) mit
`InterlockedIncrement`/`InterlockedDecrement` — über Fäden hinweg richtig. Auf-
und Abbau liegen im **selben** Faden, weil das Objekt den Rumpf nicht verlässt.
Jeder Rückgabeweg und jede durchlaufende C++-Ausnahme bauen es ab;
`ThreadStartupFunc` fängt `CMemoryException*` und `std::bad_alloc`
(`QCTaskManager.cpp:1099-1121`) **außerhalb** von `DoWork`, die Entwindung
läuft also durch den Destruktor.

Eine **Zugriffsverletzung** entwindet nicht — nimmt aber den ganzen Prozess
mit: es gibt im Produktivweg weder `_set_se_translator` noch
`SetUnhandledExceptionFilter` noch `__try` (einziger Treffer im Baum:
`atlimage.h:298`). Ein verwaister Zähler in einem weiterlaufenden Eudora ist
damit ausgeschlossen. **Fadenabbruch** gibt es nicht:
`CImapAction::RequestThreadStop()` ist leer (`:709`), `TerminateThread` kommt im
Produktivcode nicht vor.

**Frage 4 — Array plus `bLaeuft` doppelt?** Nein. `OnIdle` nimmt die Aufgabe
mit `m_array.RemoveAt(0)` (`:3778`) heraus, **bevor**
`m_bE123UebertragungLaeuft` etwas bedeutet. Array und laufende Aufgabe
schließen sich aus.

Eine theoretische Ausnahme habe ich gesucht und gefunden, sie trägt aber nicht:
`~CImapAction` legt bei `m_iState == kActionStateOffline` über `ReAdd` ein
Duplikat zurück ins Array und ruft dabei `ActionDone()` **nicht**
(`:617-628`) — dann stünden Array-Eintrag und `bLaeuft` gleichzeitig, und die
Warteschlange bliebe für immer in `kQueueStateProcessing`. Dieser Zustand wird
aber nur in `CImapAction::OpenMailbox` gesetzt (`:869`, `:883`), das im
Hauptfaden aus `DoPreThreadAction` läuft; dort steht die Aufgabe **noch im
Array** und wird nicht zerstört, sondern über `case kActionStateOffline:`
(`:3800`) als blockiert behandelt — und `bBlockiert` nimmt sie aus der Zählung
(`:4010`, `ImapAccountMgr.cpp:1307`). Weg praktisch unerreichbar, Original von
QUALCOMM, kein Fund.

## N7 — zählt die Basisklasse zu viel? Nein, und das Warten ist begrenzt

**Umfang.** `actionqueue.dat` kennt acht Übertragungsarten
(`ImapActionQueue.cpp:174-181`): `transfersame`, `copysame`, `transfercross`,
`copycross`, `transfertolocal`, `copytolocal`, `transferfromlocal`,
`copyfromlocal`. Sie bilden genau die vier Unterklassen von
`CImapTransferMsgAction` ab. Von den elf direkten `CImapAction`-Unterklassen
(`ImapActionQueue.h:113-524`) ist keine weitere betroffen — `status`, `delete`,
`undelete`, `creatembx`, `renamembx`, `deletembx`, `refresh`, `expunge`,
`resync`, `download` bleiben ungezählt, und das ist richtig: keine von ihnen
trägt Nachrichtentext, der verlorengehen kann.

**Entsteht ein Warten, das nie endet?** Für `nOffen` **nein**. `nOffen` wirkt
nur über den zweiten Zweig (`mainfrm.cpp:2040`):

```cpp
else if (bNotfall || (!bLaeuft && !bDialogOffen && (nOffen == 0 || dwVergangen > 90000)))
```

Bleibt `bLaeuft` falsch — und das tut es bei `ToLocal` und `CrossServer`, die
keinen Zähler haben —, dann wird spätestens nach **90 s** beendet, ganz gleich
wie hoch `nOffen` steht. Die Notbremse nach fünf Minuten kommt gar nicht zum
Zuge. Der Preis für `ToLocal` ist also **höchstens eine anderthalbminütige
Verzögerung beim Beenden**, und die trifft nur, wer gerade etwas aus IMAP in
ein lokales Postfach verschoben hat.

**Ist das richtig so?** Ja. Eine abgebrochene `ToLocal`-Verschiebung ist
dasselbe Risiko wie die aus `FromLocal`: kopieren und löschen sind zwei
Schritte. Darauf zu warten ist die richtige Richtung.

**Die Notbremse greift in jedem Fall — außer bei `bLaeuft`.** Das ist kein
Versehen, sondern PRUEFER-36/P1 so gewollt; es ist aber genau der Hebel, an dem
N1 hängt. Mit `bLaeuft == true` **gibt es keine Notbremse**, es gibt nur das
Aufgeben — und mit `m_bE123Gewartet = FALSE` dahinter beginnt jeder neue
Versuch von vorn.

## N8 — Datenverlust durch Warten oder Notbremse?

**Durch das Warten: nein.** Wartende Aufgaben stehen in `actionqueue.dat`
(`WriteQueue`, ausgelöst über `m_bNeedsWrite`) und laufen nach dem Neustart
weiter. Das Warten verlängert nur die Zeit, in der sie von selbst fertig
werden.

**Durch die Notbremse: nein, aber.** Wird nach 90 s beendet, während eine
Aufgabe im Nebenfaden steht, ist sie bereits aus `m_array` genommen und steht
damit **nicht mehr** in `actionqueue.dat`. Verloren ist dann der *Vorgang*,
nicht die *Nachrichten*: sie liegen entweder noch im Quellordner (COPY nicht
durch) oder in beiden Ordnern (COPY durch, DELETE nicht). Das ist Altbestand
und gilt genauso für den Weg über den Task-Manager, in den N1 den Anwender
treibt — **N1 macht diesen Altbestand erst wahrscheinlich.**

**Was der neue Zähler wirklich gewinnt**, ehrlich genannt: er verhindert, dass
mitten in `XferMessagesOnServer` beendet wird. Das ist ein echter Gewinn. Er
ist über Vorschlag (b) aus N1 ohne den Preis zu haben.

## N9 — was der Prüfstand nicht gesehen hat

Die Commit-Nachricht sagt es selbst:

> „Bau Release: 0 Fehler. Nicht am laufenden Programm gemessen - dafuer waere
> ein IMAP-Konto noetig, das der Pruefstand nicht hat."

Das ist offen und richtig benannt, aber es heißt: **Gregor ist wieder der
Prüfstand** ([Erst nachstellen, dann ausliefern](../Arbeitsweise/erst-nachstellen-dann-ausliefern.md)). Zu [E-123](../BEFUNDE.md#e-123) gibt es in
`Eudora71/Tests` nichts Neues; die einzige Absicherung ist die Textschranke,
und die hat die Lücken aus N4.

**Was ohne IMAP-Konto trotzdem messbar wäre**, als Vorschlag für den nächsten
Durchgang: `E123OffeneUebertragungen` hängt nur an `m_array`, `m_iState` und
zwei Merkern. Eine Testeinheit mit vier erfundenen Aktionsobjekten (je eine
Unterklasse) würde festhalten, dass jede von ihnen gezählt wird — und sie wäre
beim nächsten Umbau die Probe, die D aus N4 findet.

---

## Zusammenfassung: was vor 1.0.111 hinein muss

1. **N1** — `CE123HochladenZaehler e123Zaehler(true);` aus
   `CImapSameServerTransferMsgAction::DoWork` **heraus** (Vorschlag a), oder
   als zweiter, in `nOffen` eingehender Zähler umbauen (Vorschlag b). Drei
   Zeilen. **Ohne das kann 1.0.111 in einer Lage, in der 1.0.110 noch beendbar
   war, nicht mehr beendet werden.**
2. **N3** — `schranke pruefe-e123-zaehlung.pl || exit $?` in
   `tools/hooks-einrichten.sh`. Eine Zeile.

Danach kann das Paket zu Gregor. **N2** (Zähler an die drei
`DoPostProcessing`) und **N4/N5** (Schranke schärfen) gehören in den nächsten
Durchgang; **N2 nicht ohne N1**. **N6**, **N7** und **N8** sind entwarnt,
**N9** bleibt als bekannte Prüflücke offen.

## Gregors Test an 1.0.111 — wenn N1 und N3 drin sind

**Test 1 (der Anlassfall, [E-123](../BEFUNDE.md#e-123)/2b):** Mehrere Nachrichten **innerhalb**
desselben IMAP-Kontos verschieben (INBOX → HW_Box), sofort *File → Exit*.
Erwartet im Protokoll:

```
E-123 Warteschlange: ... eintraege=1 ... uebertragungen=1
E-123 Beenden wartet auf 1 Uebertragung(en) in IMAP-Ordner
E-123 Beenden: Warten zu Ende nach ... ms, offen=0
E-33 ExitInstance: erreicht
```

Entscheidend ist `uebertragungen=1` — bei 1.0.110 stand dort `0`. Danach muss
`Imap\Dominant\actionqueue.dat` **leer** sein.

**Test 2 (die Gegenprobe, [E-123](../BEFUNDE.md#e-123)/2a):** dasselbe aus dem **lokalen** In in einen
IMAP-Ordner. Muss weiter wie in 1.0.110 laufen — hier ist nichts geändert
worden außer der Weite des Casts.

**Test 3 (dass Eudora beendbar bleibt):** einen IMAP-Ordner mit einigen
Nachrichten in ein **lokales** Postfach verschieben (`transfertolocal`), sofort
beenden. Erwartet: Eudora wartet, und ist **spätestens nach 90 Sekunden** zu.
Dauert es länger, oder kommt „Quit cancelled", ist N1 nicht behoben.

**Nicht testen:** das Netzkabel mitten in einer Verschiebung innerhalb des
IMAP-Kontos ziehen und dann beenden. Das ist N1, und solange die drei Zeilen
drin sind, kommt man aus diesem Zustand nur über *Offline* oder den
Task-Manager heraus.
