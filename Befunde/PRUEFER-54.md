# <a id="pruefer-54"></a>PRUEFER-54 — der Prüfstandsfall zu E-100 liest die Eudora.ini jetzt nach dem Beenden; nachgerechnet gegen die Quelle, 25.10.2026

**Auftrag.** Kurzlauf. Geprüft wurde, was `git log --stat 13a2bcca..HEAD -- tools Eudora71`
zeigt (Stand `35051ed8`, Zweig `wt/pruefer-20261025d`). In `Eudora71/` kam nichts
dazu. In `tools/` kam die Behebung von [PRUEFER-53 K4](PRUEFER-53.md#k4) in
`tools/messen-e97.ps1` dazu (`9a4cc0e1`), dazu Protokollzeilen in
`tools/TESTLAEUFE.md`, `tools/ZWEIGE.md` und `tools/AGENTEN-LAUFEN.md`.
Nichts wurde ausgeführt: kein Eudora-Start, kein Prüfstand. Die Testsuite
habe ich nicht laufen lassen, weil sich kein Quelltext unter `Eudora71/`
geändert hat.

**Ergebnis vorweg.**

* **Die Behebung von [PRUEFER-53 K4](PRUEFER-53.md#k4) stimmt im Normalfall.**
  Das Skript schließt Eudora jetzt selbst. Die Eudora.ini liest es erst, wenn
  der Prozess weg ist. Endet Eudora nicht, meldet es „ungemessen“ und der Fall
  wird rot. Eudora schreibt die beiden Werte beim normalen Beenden wirklich
  auf die Platte. Das testlauf-Skript versucht auch kein zweites Beenden,
  wenn Eudora schon weg ist. Beides ist am Quelltext belegt.
* **Eine Lücke bleibt: ein Absturz beim Beenden zählt als „sauber beendet“**
  ([K1](#k1)). Das Skript prüft nur, ob der Prozess weg ist, nicht, wie er
  endete. Stürzt Eudora nach dem Schließbefehl ab, wurde die INI nie
  geschrieben. Trotzdem meldet das Skript „Eudora.ini nach dem Schreiben
  gelesen“ und `ini=ok`, und der Fall ist grün. Eine Behebung gibt es noch
  nicht, und es ist auch noch nicht beobachtet worden.
* **Die Gegenvermutung zu den Dialogen trifft in diesem Fall nicht zu, die
  Gefahr dahinter ist aber echt** ([K2](#k2)). Auf einen Dialog, in dem kein
  Knopf „No“, „Nein“, „Don't Save“ oder „OK“ heißt, drückt das Skript blind
  OK. Bei der Eudora-Frage „Send Queued Messages“ ist OK der Knopf
  „Send them, then quit“. Das Skript würde dann echte Post verschicken. In
  diesem Fall kann der Dialog nicht kommen: Out wird vorher geleert, und die
  verfasste Nachricht wird mit „Nein“ verworfen.
* **Ob der INI-Teil einen Rückfall überhaupt bemerkt, hängt vom Zufall ab**
  ([K3](#k3), Vermutung). Ohne die Vorbelegung aus [E-100](../Intern/BEFUNDE.md#e-100) stehen in den beiden
  Werten zufällige Bytes vom Stapel. Sind das zufällig 0 oder 1, bleibt der
  Fall grün.
* **Keiner der Funde hält das Release 7.2.1.x auf.** Alle drei betreffen das
  Prüfwerkzeug, nicht Eudora.

## Was nachgerechnet wurde

**1. Überspringt `testlauf.ps1` sein eigenes Beenden, wenn Eudora schon weg ist?**
Ja, am Quelltext belegt. `tools/testlauf.ps1:343` lautet
`if (-not $proz.HasExited) {`. Den ganzen Block mit WM_CLOSE, Warten und
Abschießen gibt es nur dann (`testlauf.ps1:343-361`). Die Stoppuhr `$uhr` wird
nur in diesem Block gestartet. Deshalb fehlt im Protokoll dann die
„Schliesszeit“ (`testlauf.ps1:363-367`). Die letzten drei Zeilen in
`tools/TESTLAEUFE.md` (19:09:48, 19:10:20, 19:12:44) haben tatsächlich keine
Schliesszeit (gemessen durch Lesen der Datei). Das passt dazu, dass das Skript
Eudora selbst beendet hat. Einen Exitcode gibt `testlauf.ps1` auf diesem Weg
nicht aus, nur `Beendet: True` (`testlauf.ps1:368`). Das gehört zu [K1](#k1).

**2. Schreibt Eudora IncludeHeaders und GuessParagraphs beim Beenden auf die Platte?**
Ja, beim normalen Beenden. Am Quelltext belegt:

* Beim Speichern aus dem Postfach In (Schritt 1, Knopf OK) werden die Werte
  gesetzt: `tocview.cpp:3074-3089`, `SetIniShort(IDS_INI_INCLUDE_HEADERS, …)`
  und `SetIniShort(IDS_INI_GUESS_PARAGRAPHS, …)`. Das gilt nur nach IDOK und
  nur unter `IsVersion4()`.
* `SetIniShort` → `SetIniString` setzt nur den Zwischenspeicher und die Marke
  `IES_DIRTY` (`rs.cpp:643-646`). Ist der Wert gleich, passiert gar nichts
  (`rs.cpp:640-641`). Deshalb stehen die beiden Einträge im Normalfall gar
  nicht in der Datei.
* `FlushINIFile` schreibt jeden Eintrag mit `IES_DIRTY` (`rs.cpp:1189-1201`).
  Beim Beenden ruft `ExitInstance` die Funktion `IniStringCleanUp()` auf
  (`eudora.cpp:2127`), und die ruft `FlushINIFile()` (`rs.cpp:1433-1436`).
* Fällt `QCWorkbook::OnClose` mit einer Ausnahme aus, holt der Fangzweig das
  Zerstören des Fensters nach (`mainfrm.cpp:5617-5638`, [E-45](../Intern/BEFUNDE.md#e-45)). Damit laufen
  WM_QUIT, `ExitInstance` und der Flush trotzdem.
* Schritt 2 (Verfassen-Fenster, Abbrechen) schreibt nichts in die INI, denn
  ohne IDOK kehrt die Funktion vorher zurück (`compmsgd.cpp:3362-3365`). Die
  geprüften Werte kommen also allein aus Schritt 1. Das ist kein Fehler, steht
  aber so nicht im Kopf des Skripts.

**3. Kann der Fall noch grün sein, ohne dass die INI nach dem Schreiben gelesen wurde?**

* Der Fall lebt nicht mehr nach Schritt 2 (`$lebt2 = 0`): Das Skript liest die
  INI zwar, weil der Prozess weg ist (`messen-e97.ps1:268`), und gibt dabei
  sogar die falsche Zeile „Eudora beendet, Eudora.ini nach dem Schreiben
  gelesen“ aus. Grün wird der Fall trotzdem nicht. Erwartet wird die ganze
  Zeile `E100 ERGEBNIS dialog=1 lebt=1 ini=ok` (`pruefstand-faelle.txt:238`),
  und `lebt=0` passt nicht dazu. Am Quelltext belegt. Die falsche
  Zwischenzeile ist nur ein Schönheitsfehler und steht unter [K1](#k1).
* Eudora endet nicht innerhalb der 30 s: `ini=ungemessen`, also rot. Am
  Quelltext belegt (`messen-e97.ps1:261, 277-279`).
* **Eudora lebt nach Schritt 2, endet nach WM_CLOSE aber durch einen Absturz:**
  Hier kann der Fall grün werden, ohne dass die INI geschrieben wurde. Das ist
  [K1](#k1).

## <a id="k1"></a>K1 — Ein Absturz beim Beenden zählt als sauberes Ende; `ini=ok` ohne geschriebene INI

**Was passiert.** Nach dem WM_CLOSE (`messen-e97.ps1:263`) fragt das Skript
nur `Lebt $pp` ab, also ob es den Prozess noch gibt
(`messen-e97.ps1:109, 264, 268`). Ob Eudora regulär durch `ExitInstance` ging,
prüft es nicht. Stürzt Eudora beim Beenden ab, bevor `IniStringCleanUp`
läuft, gilt Folgendes:

* Die gesetzten Werte stehen nur im Zwischenspeicher und gehen verloren
  (`rs.cpp:643-646`).
* In der Datei steht dann kein Eintrag. Das ist genau der Zustand, den das
  Skript als „ok“ wertet (Kopf `messen-e97.ps1:23-27`).
* Das Skript gibt „Eudora beendet, Eudora.ini nach dem Schreiben gelesen“ aus
  und `ini=ok`. Damit ist der Fall grün, denn „ABGESTUERZT“ schreibt das Skript
  nur beim Aufbau der Dialoge (`messen-e97.ps1:190, 232`), nicht beim Beenden.
* Auch `testlauf.ps1` meldet auf diesem Weg weder Exitcode noch Absturz
  (siehe Punkt 1 oben).

Das ist genau die Lage, die [PRUEFER-53 K4](PRUEFER-53.md#k4) schließen
sollte: `ini=ok` über Werte, die nie auf der Platte waren. Sie ist jetzt
seltener, weil dafür zusätzlich ein Absturz beim Beenden nötig ist, aber
nicht zu.

Ein zweiter, kleinerer Teil: Ist der Prozess schon in Schritt 1 oder 2 tot
(`$lebt2 = 0`), gibt das Skript dieselbe falsche Erfolgszeile aus. Den Fall
macht das nicht grün (`lebt=0`). Wer aber nur das Protokoll liest, wird in
die Irre geführt.

**Belege.** Alles am Quelltext belegt (Zeilen oben). Dass ein solcher
Absturz beim Beenden schon vorkam, ist nicht gemessen. Für möglich halte ich
ihn, weil das Projekt mit [E-33](../Intern/BEFUNDE.md#e-33), [E-42](../Intern/BEFUNDE.md#e-42) und [E-45](../Intern/BEFUNDE.md#e-45) schon mehrere Fehler auf dem
Beendenweg hatte (Vermutung).

**Vorschlag.** Eine Positivprobe, dass wirklich geschrieben wurde. Zwei
Möglichkeiten, beide ohne Eingriff in Eudora:

1. Den Exitcode lesen. Das Prozessobjekt muss dafür früh ein Handle halten:
   `$po = Get-Process -Id $pp; [void]$po.Handle` gleich nach
   `messen-e97.ps1:170`, später `$po.ExitCode`. Ist er nicht 0, heißt das
   Ergebnis „ungemessen (Exitcode n)“.
2. Den Zeitstempel der INI prüfen. `LastWriteTime` von `Eudora.ini` muss
   nach dem WM_CLOSE liegen. Beim Beenden schreibt `ExitInstance` mit
   `SaveStdProfileSettings` und `IniStringCleanUp` (`eudora.cpp:2126-2127`)
   ohnehin, auf jeden Fall die Fensterpositionen. Das zweite ist eine
   Vermutung und müsste einmal gemessen werden.

Die Erfolgszeile gehört außerdem in den Zweig `if ($lebt2)`.

## <a id="k2"></a>K2 — Der Rückfallknopf ist OK, und bei „Send Queued Messages“ heißt OK „senden“

**Was passiert.** `Dialoge` sucht in jedem offenen Dialog einen Knopf nach
dem Muster. Findet es keinen, schickt es `WM_COMMAND IDOK` an den Dialog
(`messen-e97.ps1:144-146`). Beim Beenden ist das Muster
`'^(No|Nein|Don.t Save|OK)$'` (`messen-e97.ps1:265`).

Liegt beim Beenden Post in Out, fragt Eudora mit `IDD_SEND_QUEUED`
(`mainfrm.cpp:5389-5400`). Die Knöpfe heißen „&Send them, then quit“ (IDOK),
„Just &quit“ und „Cancel“ (`EudoraRes.rc`, Dialog `IDD_SEND_QUEUED`; die
Fassung `_12` hat dazu „Send &all delayed messsages, then quit“). Nach dem
Entfernen von `&` passt keiner davon auf das Muster. Also schickt das Skript
IDOK, und das heißt `SendQueuedMessagesAndQuit` (`mainfrm.cpp:5396-5398`).
Eudora würde die wartende Post an den eingestellten SMTP-Server schicken. Am
Quelltext belegt.

**Warum es in diesem Fall nicht eintritt.** Am Quelltext belegt:

* `-Vorbereiten` löscht `Out.mbx` und `Out.toc` (`messen-e97.ps1:51-54`).
* Die Nachricht aus Schritt 2 wird nie in die Warteschlange gestellt. Ihr
  Fenster wird mit WM_CLOSE und dann „No“ verworfen (`messen-e97.ps1:241-250`).
* Bleibt die Frage „Save changes?“ dennoch stehen, kommt sie beim Schließen
  des Hauptfensters noch einmal und wird wieder mit „No“ beantwortet.
  Gespeichert, aber nicht in die Warteschlange gestellt.

Für den Rechtschreib-Hinweis ([E-139](../Intern/BEFUNDE.md#e-139)) ist „OK“ der richtige Knopf. Einen
anderen Dialog beim Beenden, bei dem „No“ oder „Nein“ etwas Ungewolltes
bewirkt, habe ich nicht gefunden. Gesucht habe ich in `QuerySendQueuedMessages`
und an der Stelle `EMPTY_TRASH_ON_QUIT` (`mainfrm.cpp:5543`). Die Liste ist
nicht vollständig (Vermutung).

**Warum es trotzdem ein Fund ist.** Wer das Skript oder die Funktion
`Dialoge` mit „OK“ als blindem Rückfall in einen anderen Fall übernimmt, in
dem Out nicht leer ist, verschickt echte Post. Vorschlag: Als Rückfall IDCANCEL
statt IDOK nehmen, und nach dem Schließbefehl „Just quit“ ausdrücklich in
das Muster aufnehmen.

## <a id="k3"></a>K3 — Ob der INI-Teil einen Rückfall bemerkt, ist Glückssache

**Was passiert.** Die Behebung von [E-100](../Intern/BEFUNDE.md#e-100) belegt `m_Inc` und `m_Guess` im
Konstruktor vor (`SaveAsDialog.cpp:48-49`). Nimmt man das zurück, gibt es
zwei Möglichkeiten:

* Läuft `OnInitDialog` auf dem Vista-Weg, werden die Werte dort ohnehin
  gesetzt (`SaveAsDialog.cpp:146-159`). Dann sieht der Test keinen
  Unterschied.
* Läuft es nicht, stehen in den Werten die Bytes, die gerade auf dem Stapel
  liegen. `CSaveAsDialog theDlg` ist eine lokale Variable in `tocview.cpp`.
  Nur wenn diese Bytes zufällig nicht 0 oder 1 sind, wird der Fall rot.

Ob `OnInitDialog` läuft, ist laut `SaveAsDialog.cpp:41-43` offen. Den
Rückfall habe ich nicht gebaut und nicht gefahren. Das ganze ist eine
Vermutung, am Quelltext begründet. Dieser Teil des Prüfstandsfalls ist also
eine Plausibilitätsprüfung, kein Regressionstest. Der Fall sollte nicht als
„[E-100](../Intern/BEFUNDE.md#e-100) Teil 2 abgesichert“ geführt werden, solange niemand den Rückfall
einmal rot gesehen hat.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Release 7.2.1.x auf? |
|---|---|---|---|
| [K1](#k1) | Stürzt Eudora beim Beenden ab, wird die INI nie geschrieben, und der Fall [E-100](../Intern/BEFUNDE.md#e-100) meldet trotzdem `ini=ok` (grün). Dazu kommt eine falsche Erfolgszeile im Protokoll, wenn Eudora schon vorher tot war. | mittel (Prüfwerkzeug kann falsch grün sein) | nein |
| [K2](#k2) | Findet `Dialoge` keinen passenden Knopf, drückt es OK. Bei „Send Queued Messages“ hieße das: Post verschicken. In diesem Fall nicht erreichbar, weil Out geleert wird. | niedrig (in diesem Fall nicht erreichbar) | nein |
| [K3](#k3) | Ob der INI-Teil einen Rückfall von [E-100](../Intern/BEFUNDE.md#e-100) bemerkt, hängt von zufälligen Stapelbytes ab und davon, ob `OnInitDialog` läuft. | niedrig (Vermutung) | nein |
