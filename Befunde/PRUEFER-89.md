# <a id="pruefer-89"></a>PRUEFER-89

Lauf nach [PRUEFER-88](PRUEFER-88.md). Geprüft wurde `0341c5fe..HEAD -- Eudora71 tools Releases/1.0` auf Zweig wt/pruefer-20261102i, abgezweigt von `origin/e170_label_ohne_uidplus` (Stand f6b242a0). Im Bereich liegen zwei Commits des BEHEBERS: d2cf569d (die Behebung von [E-170](../Intern/BEFUNDE.md#e-170) für Server ohne UIDPLUS, neu `E170Zuordnung.h`, Erweiterung von `TestE170.cpp`, dazu die übernommene Prüfstandssperre) und 783a1be7 (Prüfstandsfälle `E-170m`/`f`/`g`, `messen-e170m/f/g.ps1`, `messen-e184.ps1 -MehrereLabels -FremdeBeiCopy`, `imap-pruefserver.pl --fremde-bei-copy`, Doku). Der Merge f6b242a0 wurde nur auf Verluste geprüft. Eudora habe ich weder gebaut noch gestartet. Keinen Prüfstand habe ich angefasst.

## Ergebnis vorweg

Die Behebung tut, was sie verspricht, und sie ist vorsichtig gebaut. Ohne UIDPLUS merkt sich Eudora beim Verschieben Datum, Absender und Betreff jeder Mail mit Label. Nach dem Abgleich bekommt die neu angelegte Zusammenfassung im Ziel das Label nur dann, wenn genau eine passt und diese zu keiner anderen Vormerkung passt. Steht im Ziel schon eine gleich aussehende Mail, wird gar nicht erst vorgemerkt. Alles läuft im Hauptfaden. Mehrere Konten trennt der Pfad des Ziels. Eine Zeitumstellung zwischen dem Eintreffen der Quelle und dem Abgleich ändert das Datum nicht. Die Testsuite läuft mit 387/387. Der Merge hat nichts verloren.

Ein Label auf einer fremden Mail ist aber nicht ganz ausgeschlossen. Der Eintrag zu [E-170](../Intern/BEFUNDE.md#e-170) sagt *„nie ein falsches"*, und das ist zu stark (K1). Taucht die Kopie im ersten Abgleich nicht auf, wartet die Vormerkung fünf Minuten. Kommt in dieser Zeit eine einzelne Mail mit gleichem Datum auf die Sekunde, gleichem Absender und gleichem Betreff ins Ziel, bekommt sie das Label. Das kann zum Beispiel geschehen, wenn das Kopieren auf dem Server scheitert: Auch dann wird vorgemerkt, sogar bei Servern mit UIDPLUS. Eine solche Mail ist praktisch immer eine Doppelzustellung derselben Nachricht. Der Schaden ist klein. Dazu kommen Lücken im Test: Vier der sieben Gegenproben bleiben grün, darunter das Abschalten der Zielprüfung und der Frist (K2). Im Prüfstand fehlen die Lagen *„schon da"* und *„Kopie fehlt"* (K3). Ein Verfall nach fünf Minuten hinterlässt keine Spur (K4). Beim Beenden werden die Vormerkungen nicht freigegeben (K5).

Für das Paket: **Keiner der Funde hält 7.2.2.132 auf.** K1 sollte im Eintrag zu [E-170](../Intern/BEFUNDE.md#e-170) berichtigt werden. Dort steht „nie ein falsches".

## 1. Der Weg am Quelltext

Alle Zeilen sind Stand f6b242a0.

- **Merken beim Einreihen.** `ImapXferOnSameAccount` füllt Label, Sekunden, Absender und Betreff an derselben Stelle der Schleife, hinter dem `continue` für nicht schließbare Fenster (ImapToc.cpp:538-548). Die fünf Felder bleiben also gleich lang und stehen in derselben Folge. Übergeben werden sie vor `QueueAction` (:596-601). `Copy` und damit `Duplicate` nehmen sie mit (ImapActionQueue.cpp:1481-1487, :1902-1909). Belegt.
- **Vormerken.** `DoPostProcessing` ruft zuerst `E189VorabKopienEntfernen`, dann `E170LabelsNachtragen` (ImapActionQueue.cpp:1628, :1631). Die Vorab-Kopie aus [E-184](../Intern/BEFUNDE.md#e-184) ist also schon fort, wenn `E170LabelsVormerken` nach einer gleich aussehenden Mail im Ziel sucht. Sonst würde sie immer *schon da* melden. Bleibt eine Vorab-Kopie stehen, weil ihr Fenster das Schließen ablehnt (ImapToc.cpp:1808-1817), findet die Suche sie. Dann wird nicht vorgemerkt, und es gibt kein Label statt eines falschen. Belegt.
- **Nur mit Label.** Mails ohne Label werden nicht vorgemerkt (:1870). Hat keine Mail ein Label, kehrt `E170LabelsNachtragen` sofort zurück (ImapActionQueue.cpp:1712-1713). Belegt.
- **Zuordnung.** `E170NachAbgleich` verwirft zuerst die abgelaufenen Vormerkungen aller Ziele (ImapToc.cpp:1925-1933). Dann nimmt es nur die Vormerkungen, deren Zeiger *und* Pfad zum Ziel passen (:1943). `E170Zuordnen` verlangt genau einen Treffer und prüft, dass dieser zu keiner anderen Vormerkung passt (E170Zuordnung.h:70-90). Gesetzt wird nur auf Label 0 (ImapToc.cpp:1972-1974). Eine mehrdeutige Vormerkung wird verworfen, eine ohne Treffer bleibt stehen (:1980-1987). Belegt.
- **Kandidaten.** Das sind nur die Zusammenfassungen, die *dieser* Aufruf von `ImapAppendSumList` neu angelegt hat (ImapMailbox.cpp:5044). Solche, die über `GetSummaryFromUID` gefunden werden, gehören nicht dazu (:5001). `SetLabel` ist rein lokal und ruft nichts auf (summary.cpp:2769-2776). Es gibt also keinen Wiedereintritt. Gespeichert wird danach (ImapMailbox.cpp:5072-5073). Belegt.

### Gegenvermutungen

| Lage | Ergebnis | Kennzeichnung |
|---|---|---|
| **Fäden.** Zwei Abgleiche gleichzeitig, `s_aE170Vormerkungen` ohne Sperre | kein Problem. `QCTaskManager::DoPostProcessing` verlangt den Hauptfaden (`ASSERT(::IsMainThreadMT())`, QCTaskManager.cpp:668). `ImapAppendSumList` wird aus `CImapChecker::PostProcessSummaries` (ImapChecker.cpp:1386ff) und `DoFetchNewMessages` gerufen und ist laut Kopf *„done in the main thread"* (ImapMailbox.cpp:4958). `DoWork` im Nebenfaden fasst die Vormerkungen nicht an. | Quelltext; den Faden von `PostProcessSummaries` habe ich nur am Kommentar gelesen |
| **Abgleich vor der Vormerkung.** Ein Abgleich holt die Kopie schon, bevor `DoPostProcessing` läuft | sicher. Die Kopie steht dann ohne Label im Ziel, und `E170LabelsVormerken` meldet *schon da*. Das Label fehlt, aber nichts ist falsch. | Quelltext |
| **Abgleich, der den Serverstand vor dem COPY las**, hängt aber nach der Vormerkung an | die Kopie ist nicht dabei, die Vormerkung bleibt stehen. Siehe K1. | Quelltext |
| **Mehrere Konten** | getrennt über `GetMBFileName()` (:1903, :1938). Zwei Konten teilen keinen Pfad. Ein wiederverwendeter Zeiger für ein anderes Postfach scheitert am Pfad. Der Zeiger wird nie dereferenziert. | Quelltext |
| **Zeitzone und Sommerzeit.** Quelle im Oktober angelegt, Kopie nach der Umstellung | gleich. `GetTimeMT` setzt `tm_isdst = -1` (services.cpp:2264), das Ergebnis hängt also nur am Datum selbst, nicht am Zeitpunkt des Lesens. `FormatDateMT` zieht nur die Zone aus dem Kopf ab (services.cpp:2021-2077). Beide Seiten laufen durch dieselben Funktionen. | Quelltext |
| **Andere Bauwege der Zusammenfassung.** Kopfzeilen (ImapDownload.cpp:2296, :2670), Umschlag (:6123), ganze Nachricht (:538, dort `m_Seconds + 60*m_TimeZoneMinutes`) | Vermutung: Liegt die Quelle aus einem anderen Weg vor als die Kopie, können Sekunden oder Betreff abweichen. Dann gibt es kein Label, nie ein falsches. Das steht schon als Grenze im Eintrag. | Vermutung |
| **Betreff mit Kodierung, `m_Subject[64]`** | beide Seiten sind gleich dekodiert, wenn sie denselben Weg nehmen (siehe oben). Durch das Abschneiden auf 63 Zeichen passen lange Betreffe mit gleichem Anfang häufiger zusammen. Dafür braucht es aber auch dieselbe Sekunde und denselben Absender. | Quelltext (summary.h:408-409) |
| **Leeres Datum.** Ohne `Date:` bleibt `m_Seconds = 0` | Mails ohne Datum mit gleichem Absender und Betreff sehen gleich aus. Gleichzeitig: mehrdeutig, also sicher. Nacheinander: K1. | Quelltext |
| **Neustart, Warteschlange offline** | `CImapTransferMsgAction::Write` schreibt keines der E-170-Felder (ImapActionQueue.cpp:1448-1468). Nach einem Neustart gibt es kein Label, aber auch kein falsches. Das stand schon als Grenze im Eintrag. | Quelltext |
| **5-Minuten-Frist, Überlauf von `GetTickCount`** | `dwJetzt - p->dwSeit` ist vorzeichenlos (:1928) und übersteht den Überlauf nach 49 Tagen. | Quelltext |
| **Frist und Warteschlange.** Abgeglichen wird nur nach der letzten Übertragung auf dieses Ziel (`m_bIsLastOnMailbox`, ImapActionQueue.cpp:1638, gesetzt in :1958-1961) | bei langen Warteschlangen oder langsamem Abgleich verfällt die Vormerkung, siehe K4. | Quelltext |
| **Zwei gleich aussehende Mails in einem Zug**, eine mit, eine ohne Label | sicher. Nur die mit Label wird vorgemerkt, beide Kopien passen: `nTreffer = 2`, also mehrdeutig. | Quelltext, Test Lage 3 |
| **Mehrdeutig, und eine der beiden kommt später allein wieder** | sicher. Mehrdeutige Vormerkungen werden sofort verworfen (`bErledigt` bleibt `TRUE`, :1980-1981). | Quelltext |
| **Voller Neuabgleich** (`m_bRemoveAllLocalSumsBeforeMerging`, ImapChecker.cpp:1401) | alle Mails des Ziels werden Kandidaten. Was schon beim Vormerken gleich aussah, ist nie vorgemerkt worden (*schon da*). Neues kommt nur über K1 dazu. | Quelltext |

### Zusammenspiel mit E-184, E-189 und E-192

- **[E-184](../Intern/BEFUNDE.md#e-184) und [E-189](../Intern/BEFUNDE.md#e-189).** Die Reihenfolge [E-189](../Intern/BEFUNDE.md#e-189) vor [E-170](../Intern/BEFUNDE.md#e-170) ist nötig und richtig (siehe oben). Mit UIDPLUS ändert sich am Weg aus [E-184](../Intern/BEFUNDE.md#e-184) nichts, *außer* wenn das Kopieren scheitert (K1). Belegt.
- **[E-192](../Intern/BEFUNDE.md#e-192)** (Papierkorb, Junk, Filter). Diese Wege rufen `XferMessagesOnServer` direkt auf (ImapFiltersd.cpp:1285, ImapMailbox.cpp:3550) und füllen die E-170-Felder nicht. Dort geht das Label weiter verloren wie bisher, und an [E-192](../Intern/BEFUNDE.md#e-192) ändert sich nichts. Belegt. Ein Filter im INBOX, der eine gerade eben beschriftete Kopie weiterschiebt, verliert das Label ebenso. Das gilt nur, wenn das Ziel INBOX ist. Vermutung, nicht weiter verfolgt.

## 2. Testsuite und Gegenproben (in meinem Baum)

Gemessen. Die Basis lief über `cmd /c Eudora71\Tests\RunTests.cmd`: 387 Tests, 387 bestanden. Die Zahl ist höher als die 369 im Commit, weil der Merge von `main` Tests mitgebracht hat. Die Gegenproben haben die Quelle mit Perl `:raw` geändert, Anker mit genau einem Treffer. Danach habe ich die Datei byte-genau zurückgeschrieben. `cmp` meldete jedes Mal *byte-gleich*, und `git status` war am Ende leer.

Bei G6 und G7 lief zuerst noch die Objektdatei aus G5. Ich hatte `E170Zuordnung.h` mit `cp -p` zurückgeschrieben, also mit dem alten Zeitstempel, und MSBuild hat `TestE170.cpp` deshalb nicht neu übersetzt. Beide waren aus diesem Grund rot. Nach `touch` auf den Kopf lief die Basis wieder mit 387/387. Die Werte unten für G6 und G7 stammen aus dem zweiten Lauf. Das gehört in die Anleitung für Gegenproben: Wer einen Kopf zurückschreibt, der übersetzt wird, darf den alten Zeitstempel nicht wiederherstellen.

| Lauf | Änderung (vorübergehend) | Ergebnis |
|---|---|---|
| 0 | keine | 387/387 |
| G1 | in `E170NachAbgleich` `if (p->pZiel == pToc && …CompareNoCase…)` → `if (1)`: Vormerkungen gelten für jedes Postfach | **387/387, grün** (K2) |
| G2 | `if (dwJetzt - p->dwSeit > E170_FRIST_MS)` → `if (0)`: keine Frist | **387/387, grün** (K2) |
| G3 | mehrdeutige Vormerkung bleibt stehen (`bErledigt = FALSE`) | **387/387, grün** (K2) |
| G4 | `if (0)` vor `if (bErledigt)`: auch zugeordnete Vormerkungen bleiben | **387/387, grün** (K2) |
| G5 | `E170Zuordnen` ohne die Prüfung auf andere Vormerkungen (`pnZuordnung[i] = kTreffer;`) | 386/387, rot (Lage 6) |
| G6 | `return 0;` am Anfang von `E170LabelsVormerken`: es wird nie vorgemerkt | **387/387, grün** (K2; der Prüfstand fängt es) |
| G7 | `E170NachAbgleich` nur bei `bFromTmpMbx` | **387/387, grün** (gering; der Weg über `DoFetchNewMessages` wäre blind) |

Die Gegenprobe des BEHEBERS (`nTreffer > 5`) habe ich nicht nachgefahren. G5 zeigt dieselbe Stärke: `E170Zuordnen` ist im Verhalten gut abgedeckt. Die Verwaltung um die Zuordnung herum ist es nicht. Dazu gehören Ziel, Frist und Verwerfen, und gerade sie entscheidet, ob ein Label auf eine fremde Mail kommt (K2).

## 3. Prüfstand: treffen die Messungen den Weg?

- **`--fremde-bei-copy`.** Der Prüfserver legt die fremde Mail beim ersten `UID COPY` *vor* die Kopien ins Ziel (imap-pruefserver.pl:537-562). Sie bekommt die kleinere UID, die Kopie die nächste. Beide stehen also im selben Abgleich, und genau diese Lage prüfen `E-170f` und `E-170g`. Bei `gleich` ersetzt der Server nur die Message-ID und den Text. Datum, Absender und Betreff stammen aus der kopierten Nachricht. Belegt. Positivprobe: `fremde-gelegt` zählt die Serverzeile `FREMDE NEUE NACHRICHT … UID 1` (messen-e184.ps1:491). Belegt.
- **`E-170m`.** Drei Mails mit drei Labels, nach Datum sortiert (Liste 3,2,1, `--datum-absteigend`), alle zusammen verschoben. Jede Kopie wird über den Betreff ihrer Quelle zugeordnet. Die Positivprobe zählt drei verschiedene Labels in `INBOX.toc` (messen-e184.ps1:503-520). Die Betreffe sind verschieden. Der Fall belegt also, dass nicht mehr nach Position zugeordnet wird. Belegt. Das passt zum Testfall Lage 7.
- **`log-grund`** ist die *letzte* Zeile `E-170 Labels beim Verschieben` der ganzen `eudora.log` (:481-483, :515-517). Auch die Zeile nach dem Abgleich beginnt so. Gemeint ist also die Zeile nach dem Abgleich, und das ist richtig. `-Vorbereiten` muss die Log-Datei leeren, sonst gilt dieselbe Grenze wie bei [PRUEFER-88](PRUEFER-88.md#k9) K9. Das habe ich nicht nachgesehen.
- **Nicht gemessen:** *schon da* (das Ziel ist in allen Fällen leer) und die Restlage aus K1 (die Kopie fehlt im Abgleich, eine gleich aussehende ist da). Siehe K3.

## 4. Merge f6b242a0

Gemessen. Merge-Basis ist 0ad4eb78. Jede Datei, die nur eine Seite geändert hat, trägt im Ergebnis genau den Blob dieser Seite. Geprüft habe ich das für alle Dateien des Zweigs und von `main`. Bei den elf Dateien, die beide Seiten geändert haben, habe ich jede hinzugefügte Zeile beider Seiten im Ergebnis gesucht. Gefehlt hat nur die Zeile *„Stand 02.11.2026 abends"* in `Intern/WEITERMACHEN.md`. Sie ist von Hand zu einer Zeile zusammengeführt und enthält beide Teile: #209/#210 von `main` und den laufenden Zweig `e170_label_ohne_uidplus`. **Kein Verlust.** Unter `Eudora71/` hat nur `main` geändert, ohne Überschneidung.

`tools/startzeilen-sammeln.pl` gibt es auf diesem Zweig nicht. Die Startzeilen konnte ich deshalb nicht abgleichen. Ich habe Eudora nicht gestartet, also fehlt keine eigene Startzeile.

## 5. Funde

### <a id="k1"></a>K1: Eine Vormerkung ohne Treffer kann fünf Minuten später eine gleich aussehende fremde Mail beschriften

(am Quelltext belegt; nicht gemessen)

Findet der Abgleich die Kopie nicht, bleibt die Vormerkung bis zu fünf Minuten stehen (ImapToc.cpp:1983-1987). Jeder Abgleich des Ziels in dieser Zeit, in dem *genau eine* neue Mail mit gleicher Sekunde, gleichem Absender und gleichem Betreff steht, gibt ihr das Label. Die Kopie muss nicht dabei sein. Dass die Kopie im Abgleich fehlt, kann so geschehen:

1. **Das Kopieren scheitert.** `DoWork` setzt dann `kActionStateFailed`, gibt aber `S_OK` zurück (ImapActionQueue.cpp:1977-1984). `DoPostProcessing` prüft den Zustand nicht (:1609-1631). `m_dwaNewUIDs` ist leer, also läuft der Zweig `keine-neuen-uids`, und es wird vorgemerkt. **Das geschieht auch bei Servern mit UIDPLUS.** Die Logzeile meldet dann `grund=keine-neuen-uids` für einen Fehlschlag. Das führt in die Irre. Dass die Nachbearbeitung nach einem Fehlschlag überhaupt läuft, habe ich nur an `NeedsPostProcessing` gelesen (TaskInfo.cpp:485-489). Das ist eine Vermutung mit starkem Beleg.
2. Ein Abgleich, der den Serverstand **vor** dem `COPY` gelesen hat, hängt erst nach der Vormerkung an (siehe die Tabelle in Abschnitt 1).

Die fremde Mail muss in allen drei Merkmalen gleich sein. Das ist in der Praxis fast immer dieselbe Nachricht, doppelt zugestellt, etwa über eine Liste und direkt. Der Schaden ist ein Label auf einem Doppel. Mit dem Satz *„nie ein falsches"* in [E-170](../Intern/BEFUNDE.md#e-170) (Grenzen) verträgt sich das trotzdem nicht. **Abhilfe:** nur vormerken, wenn `m_iState == kActionStateSucceeded`. Eine Vormerkung ohne Treffer nach dem *ersten* Abgleich des Ziels verwerfen, der nach der Übertragung angestoßen wird (:1638-1640), statt fünf Minuten zu warten. Den Satz im Eintrag berichtigen. **Schwere: gering.** **Hält das Paket nicht auf.**

### <a id="k2"></a>K2: Der Test sieht Ziel, Frist und Verwerfen der Vormerkungen nicht

(gemessen, Abschnitt 2)

G1 bis G4 und G6 bleiben grün. G1 schaltet genau die Prüfung ab, die eine Vormerkung auf ihr Ziel beschränkt. G2 schaltet die Frist ab. G3 und G4 lassen Vormerkungen stehen, die verworfen werden müssen. Jede davon vergrößert die Lage aus K1 von fünf Minuten oder einem Postfach auf beliebig lange oder alle Postfächer. Der Prüfstand fängt nur G6 (`E-170o/m/f` würden `kopie-label=0` liefern). G1 bis G4 fängt keiner. `Test_E170_OhneUidplus_Stelle` sucht nur einzelne Sätze. Ein früher Ausstieg oder eine geänderte Bedingung daneben fällt nicht auf, wie schon in [PRUEFER-88](PRUEFER-88.md#k2) K2. **Abhilfe:** die Verwaltung (Frist, Ziel, Verwerfen) wie `E170Zuordnen` als reines C++ in `E170Zuordnung.h` ziehen und im Verhalten testen. Oder wenigstens die Bedingung auf :1943 und die Frist auf :1928 wörtlich verlangen. **Schwere: gering.**

### <a id="k3"></a>K3: Der Prüfstand misst *schon da* und die Restlage aus K1 nicht

(am Quelltext belegt)

In allen E-170-Fällen ist das Ziel vor dem Verschieben leer. Bei `--fremde-bei-copy` kommt die fremde Mail im selben Abgleich wie die Kopie. Ungemessen sind deshalb: (a) im Ziel steht schon eine gleich aussehende Mail, dann sollte `schon-da=1` kommen und kein Label; (b) das `COPY` scheitert (`NO`), und danach kommt eine gleich aussehende Mail an, das ist K1. `E-170g` sichert die Schranke. Am alten Bau ist der Fall nur wegen `log-grund` rot, das sagt der Fall selbst. **Abhilfe:** `imap-pruefserver.pl` um `--copy-scheitert` und um eine gleich aussehende Mail im Ziel schon vor dem Lauf ergänzen. Erwartet wird bei (a) `kopie-label=0 schon-da=1`. Bei (b) zeigt der Fall heute ein falsches Label und nach der Abhilfe aus K1 keines. **Schwere: gering.**

### <a id="k4"></a>K4: Eine verfallene Vormerkung hinterlässt keine Spur

(am Quelltext belegt)

Verworfen wird still (ImapToc.cpp:1925-1933). Abgeglichen wird nur nach der *letzten* Übertragung auf dieses Ziel (`m_bIsLastOnMailbox`, ImapActionQueue.cpp:1638). Bei einer langen Warteschlange oder einem langsamen Server kann der Abgleich nach mehr als fünf Minuten kommen. Dann fehlt das Label, und das Protokoll sagt `kein-treffer` oder gar nichts, nicht *verfallen*. Bei einer Meldung von Gregor wäre das nicht von einem Fehler der Zuordnung zu unterscheiden. **Abhilfe:** beim Verwerfen eine Zeile `E-170 … verfallen=<n> ziel=…` schreiben. Die Frist nach dem Abgleich rechnen, nicht nach dem Einreihen (siehe K1). **Schwere: gering.**

### <a id="k5"></a>K5: Die Vormerkungen werden beim Beenden nicht freigegeben

(am Quelltext belegt)

`s_aE170Vormerkungen` ist ein statisches `CPtrArray` mit `DEBUG_NEW`-Einträgen (ImapToc.cpp:1850, :1901). Freigegeben wird nur bei einer Zuordnung oder beim Verfall in `E170NachAbgleich`. Ein Aufräumen beim Beenden gibt es nicht. Wer innerhalb von fünf Minuten vor dem Beenden verschiebt, bekommt im Debug-Bau eine Leckmeldung. Im Release ist das bedeutungslos. **Abhilfe:** Aufräumen in `ExitInstance`, oder hinnehmen und im Kommentar sagen. **Schwere: sehr gering.**

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | eine Vormerkung ohne Treffer (z. B. nach gescheitertem `COPY`, auch mit UIDPLUS) gibt innerhalb von 5 min einer einzelnen gleich aussehenden fremden Mail das Label; „nie ein falsches" im Eintrag ist zu stark | gering | nein; Eintrag zu [E-170](../Intern/BEFUNDE.md#e-170) berichtigen |
| K2 | Regressionstest bleibt grün ohne Zielprüfung, ohne Frist, ohne Verwerfen, ohne Vormerken (G1-G4, G6) | gering | nein |
| K3 | Prüfstand ohne Fälle *schon da* und *COPY scheitert, dann gleich aussehende Mail* | gering | nein |
| K4 | Verfall nach 5 min ohne Logzeile; Frist läuft ab dem Einreihen, nicht ab dem Abgleich | gering | nein |
| K5 | statische Vormerkungen beim Beenden nicht freigegeben (Debug-Leckmeldung) | sehr gering | nein |
