# <a id="pruefer-94"></a>PRUEFER-94

Lauf nach [PRUEFER-93](PRUEFER-93.md#pruefer-93). Zweig wt/pruefer-20261104, abgezweigt von `origin/e188_loeschschranke`. Geprüft wird `git log f6693b4b..HEAD -- Eudora71 tools Releases/1.0`. Im Mittelpunkt stehen die vier Behebungen von [E-188](../Intern/BEFUNDE.md#e-188): `aceeffad`, `ce4cda82`, `a9c5d6aa`, `044477d2` und `5e091c97`. Dazu kommen `Tests/TestE188.cpp`, der Umbau von `tools/messen-e188.ps1` (`ed60ee09`) und der Fall `E-188d`. Eudora habe ich weder gebaut noch gestartet. Ich habe kein Fenster geöffnet und keinen Prüfstand angefasst. Die Testsuite habe ich in meinem Baum gebaut und gefahren.

## Ergebnis vorweg

Die vier Behebungen tun, was der Befund sagt. Ich habe sie gegen die Quelle nachgerechnet. Die Löschschranke löscht in der Quelle nur noch, was im Ziel angekommen ist. Ein verweigerter einfacher Rumpf gilt nicht mehr als geladen. Die Vorab-Kopie wird über ihr Merkzeichen gefunden. Die Kopie im Ziel trägt die neue Nummer. Eine Mail, die im Ziel angekommen ist, wird nicht fälschlich als „nicht angekommen“ gezählt, außer in einem einzigen Fall. In diesem Fall liegt sie auf beiden Servern, verloren geht nichts (K7). Die Testsuite läuft in meinem Baum mit **409/409**.

Drei Dinge sind wichtig:

- **Bei mehrteiligen Mails bleibt der Verlustweg offen (K1, am Quelltext belegt).** Dazu gehört jede HTML-Mail (`multipart/alternative`). Verweigert der Server den Rumpf oder reißt die Verbindung, behält `DownloadSingleMessage` das `S_OK` des Kopfabrufs. Die Mail gilt dann als ganz geladen, und die Löschschranke greift nicht. Beim Verschieben in ein anderes Konto wird nur der Kopf hochgeladen, und die Quelle wird gelöscht. Dasselbe gilt für Anhänge, die sich nicht laden lassen. Der Befund nennt mehrteilige Mails „bewusst nicht erfasst“. Das klingt nach einem Randfall, aber es ist die häufigste Form von Mail.
- **Der Regressionstest sieht zwei der Änderungen nicht (K5, gemessen).** Ich habe die Zeile `bAngekommen = false;` im Weg nach lokal entfernt. Sie ist der Kern der Behebung für `E-188f`. Danach ist die Suite trotzdem 409/409 grün. Dasselbe gilt für das Zurücksetzen von `pCopySum` je Mail. Der Test findet dort die Deklaration `*pCopySum = NULL;` statt der neuen Zeile. Positivprobe: Mit `m_szMessageIDs` statt `strAngekommen` wird der Test rot.
- **Nach lokal kann eine nur als Kopf kopierte Mail weiterhin auf dem Server gelöscht werden (K2, am Quelltext belegt, Weg nicht gemessen).** Das passiert, wenn die Quelle zwischen dem Verschieben und dem Abarbeiten der Warteschlange ganz geladen wurde. Dann nimmt der Zweig „schon geladen, Xfer hat alles getan“ an, dass die Mail da ist. Lokal liegt aber nur die Kopf-Kopie. Dieser Fehler stammt aus dem Original. Seit `a9c5d6aa` lässt er sich mit einer Zeile schließen.

**Kein Fund ist eine Verschlechterung gegenüber 7.2.2.132.** Nur K4 ist eine kleine Verschlechterung: nach einem Neustart mit gespeicherter Warteschlange entsteht nach lokal ein Eintrag ohne Text. **Kein Fund hält das nächste Paket auf.** Kritische Befunde sind nach Gregors Entscheidung vom 23.10. kein Release-Blocker. Allerdings dürfen README und Release-Notizen [E-188](../Intern/BEFUNDE.md#e-188) nicht pauschal als „behoben“ führen, solange K1 offen ist. K5 kostet etwa zehn Zeilen und gehört vor den Merge. Neue Kennungen habe ich nicht vergeben. `befund-suchen.pl` findet zu jedem Ort [E-188](../Intern/BEFUNDE.md#e-188) oder [E-184](../Intern/BEFUNDE.md#e-184), dort wird fortgeschrieben. [E-222](../Intern/BEFUNDE.md#e-222) und [E-223](../Intern/BEFUNDE.md#e-223) bleiben frei.

## 1. Löschschranke (`aceeffad`)

**Was sich ändert (belegt).** `CImapCrossServerTransferMsgAction::DoPostProcessing` (ImapActionQueue.cpp:2123-2220) und `CImapToLocalTransferMsgAction::DoPostProcessing` (:2404-2482) übergeben `DeleteMessagesFromServer` nur noch `strAngekommen` (:2209, :2477). Vorher war es `m_szMessageIDs`. Ist nichts angekommen, wird gar nicht gelöscht (:2208, :2476). Zwischen Konten wird eine Mail ohne Anhang, deren Text nicht geladen ist, nicht hochgeladen (:2158). Die Spurzeile meldet es.

**Kann eine angekommene Mail als „nicht angekommen“ gelten?** Dann bliebe ein Doppel auf dem Server.

| Fall | `bAngekommen` | Folge | Kennzeichnung |
|---|---|---|---|
| Konten, `APPEND` gelungen, `APPENDUID` da, `RewriteMbxStub` gelingt | wahr | Quelle gelöscht, richtig | belegt (ImapToc.cpp:1313-1376) |
| Konten, `APPEND` gelungen, kein `APPENDUID` (`NewUid == 0`) | wahr (`bResult` bleibt TRUE, :1313 wird übersprungen) | Quelle gelöscht, Vorab-Kopie entfernt (:2173), der Abgleich holt die Kopie | belegt |
| Konten, `APPEND` gelungen, `RewriteMbxStub` scheitert (:1317) | **falsch** | Quelle bleibt, die Mail liegt auf **beiden** Servern, ohne Dialog. Vorab-Kopie entfernt, also kein falscher Eintrag. **K7** | belegt, Häufigkeit Vermutung (nur bei Schreibfehler im lokalen Cache) |
| Konten, `APPEND` abgelehnt | falsch | Quelle bleibt, Dialog `IDS_ERR_IMAP_APPEND_FAILED` (:1307) | belegt, gemessen (`E-188a`) |
| nach lokal, schon ganz geladen | wahr ohne Prüfung (:2419) | siehe umgekehrte Frage | belegt |
| nach lokal, nachgeladen, `ImapCopyMsgFromImapToLocal` liefert TRUE | wahr | richtig. `bResult` stammt aus `RewriteMbxStub` (:1174) | belegt |

**Umgekehrt: kann eine nicht angekommene Mail als angekommen gelten?** Dann ginge sie verloren.

- **Zwischen Konten: nur über K1** (mehrteilige Mail mit verweigertem Rumpf gilt als geladen). Die Schranke selbst ist richtig. Sie hängt aber an `IsNotFullyIMAPDownloaded()` (summary.h:432), und dieses Merkmal lügt bei mehrteiligen Mails.
- **Nach lokal: ja, im Zweig „schon ganz geladen“ (K2).** Der Zweig setzt `bAngekommen = true` (:2419), ohne nachzusehen. Der Kommentar von QUALCOMM sagt: *„If the message is already downloaded, then the local transfer we did before this action was queued already did all the work.“* Das gilt aber nur, wenn die Mail **beim Verschieben** schon ganz geladen war. Wird sie erst zwischen `CTocDoc::Xfer` und dem Abarbeiten der Warteschlange geladen, steht im lokalen Postfach nur die Kopf-Kopie aus `Xfer` (tocdoc.cpp:2997-3043, `JJBlockMove` des Stummels). Trotzdem wird die Quelle gelöscht. Dass die Mail dazwischen geladen werden kann, ist eine Vermutung. Zwei Wege halte ich für möglich. Erstens: offline verschieben, die durchgestrichene Quelle öffnen, sodass `ImapFetchMessagesFromServer` den Text in die Quelle lädt, dann online gehen. Zweitens: dieselbe Mail erst nach lokal A *kopieren* und dann nach lokal B *verschieben*, bevor die Warteschlange läuft. Die erste Aktion lädt den Text, die zweite hält ihn für schon da. Gemessen habe ich keinen der beiden. Seit `a9c5d6aa` trägt die Kopf-Kopie das Merkzeichen. Das macht den Fall erkennbar: liefert `E184FindeVorabKopie(m_pDestTocDoc, uid)` etwas, ist die Arbeit **nicht** getan, und `ImapCopyMsgFromImapToLocal` muss laufen.

**`GetSummaryFromUIDString` beendet die Schleife bei einer fehlenden Zusammenfassung.** Am Quelltext belegt: :807-833 liefert NULL, und `do … while (pSum)` (:2192, :2461) hört dann auf. Die Folgen:

- Die fehlende UID und **alle nach ihr** werden weder kopiert noch gelöscht. Das ist richtig und eine stille Verbesserung gegenüber dem Original. Dort löschte `DeleteMessagesFromServer(m_szMessageIDs)` die ganze Liste, auch die nie kopierten Mails hinter der Lücke. Das war ein weiterer Verlustweg, den der Befund nicht nennt.
- Allerdings wird nichts davon bemerkt. `bSomeFailed` bleibt falsch, es gibt keine Spurzeile, und `m_iState` ist *Succeeded*. Zwischen Konten bleiben die **markierten Vorab-Kopien** dieser Mails mit der alten Nummer im Ziel stehen, denn `E189VorabKopienEntfernen` läuft nur in der Schleife (:2173). Das ist das Doppel aus `E-188k`, und wer es löscht, trifft eine fremde Mail mit derselben Nummer (`E-188d`). In der Quelle bleiben die Mails lokal als gelöscht markiert (`ImapRemoveOrderedSubSums`, ImapToc.cpp:2498), bis der nächste Abgleich die Merkzeichen vom Server übernimmt (ImapMailbox.cpp:5132-5139). **K6.** Wann eine Zusammenfassung dazwischen fehlt, ist eine Vermutung: wenn ein anderes Programm die Mail in der Quelle entfernt hat und ein Abgleich lief. Das ist selten.

**`m_iState = Failed` nach lokal: wer liest das?** Am Quelltext belegt: **niemand.** Nach `DoPostProcessing` liest nur der Destruktor den Zustand, und der prüft allein `kActionStateOffline` (:620-628). Die Warteschlange liest ihn nur direkt nach `DoPreThreadAction` (:4063-4109). `E170LabelsNachtragen` liest `m_iState == kActionStateSucceeded` (:1735) nur im Weg innerhalb eines Kontos, und `CImapToLocalTransferMsgAction` überschreibt `DoPostProcessing`. Die Änderung schadet also nicht, sie bewirkt aber auch nichts. Nach lokal erfährt der Anwender nicht, dass der Weg gescheitert ist. Die Mail steht im Ziel als Eintrag ohne Text und ist in der Quelle als gelöscht markiert. Auf dem Server ist sie unversehrt (K7).

## 2. Verweigerter Rumpf (`ce4cda82`)

**Was sich ändert (belegt).** Im Zweig für den einfachen Rumpf (ImapDownload.cpp:990-1013) setzt ein gescheitertes `DownloadSimpleBody` jetzt `hResult = E_FAIL`. Vorher galt das `S_OK` aus `UIDFetchHeaderFull` (:859). `DownloadSimpleBody` scheitert, wenn `AppendBodyTextToMbxFile` scheitert. Das passiert, wenn die Verbindung nicht ausgewählt ist (:2846), die Sperre belegt ist (ImapConnection.cpp:1505) oder der Server mit `NO` antwortet (`Msgdata`, proto.cpp:2528-2533). Es scheitert auch, wenn bei einem Nicht-Text-Teil `BreakoutBodyToFile` scheitert (:3567, :3610).

**Beim normalen Lesen.** `CImapMailbox::DownloadSingleMessage` übernimmt die Zusammenfassung nur bei Erfolg (ImapMailbox.cpp:1263-1273). Die alte Zusammenfassung bleibt also, mit `IMFLAGS_NOT_DOWNLOADED`, und beim nächsten Öffnen wird es erneut versucht. Vorher stand ein leerer Rumpf da, und es wurde nie wieder versucht. Das ist eine Verbesserung (belegt). Eine Ausnahme ist der Weg, der den Cache leert (ImapToc.cpp:4485-4507). Dort sind Offset und Länge schon vor dem Laden auf 0 gesetzt, und nach `E_FAIL` bleibt der Eintrag ohne Text. Er bleibt aber „nicht geladen“ und wird beim Öffnen neu geholt. Das ist harmlos (belegt).

**Beim Verbindungsabbruch.** `DownloadSimpleBody` prüft `IsSelected()` (:2846) und liefert FALSE. Jetzt gibt das `E_FAIL`. Richtig (belegt).

**Beim Abruf mit „ganze Nachricht laden“.** `HandlePostFetch` bricht bei der ersten gescheiterten Mail ab (ImapChecker.cpp:1530-1533). Vorher lief es weiter, weil `S_OK` kam. Die übrigen neuen Mails dieses Abrufs bleiben nur als Kopf geladen und werden beim Öffnen geholt. Das ist sehr gering (T2, belegt). Der Rückgabewert wird nicht ausgewertet (:1419, :1438).

**`bDownloadFully`.** Dieser Weg ist nicht berührt. Er nimmt `hResult` aus `DownloadSingleMessageFully` (:1043). Belegt.

**`DownloadSubMessage`.** Für die oberste Ebene ist der Zweig :983-989 **unerreichbar**. Bei :913 bricht `pBody->type == TYPEMESSAGE || (… && …)` vorher mit `bDownloadFully = true` ab. Innerhalb mehrteiliger Mails läuft `DownloadSubMessage` über `DownloadAllParts`, also unter K1. Belegt.

**Zurückschneiden (`bMustTruncate`).** Es ist richtig. `MStart` ist das Dateiende vor diesem Laden (:815-822), und `bMustTruncate` wird erst gesetzt, nachdem `UIDFetchStructure` gelungen ist (:842). `ChangeSize(MStart)` (:1068) entfernt also genau, was dieser Aufruf geschrieben hat. Die Zusammenfassung zeigt weiter auf ihren alten Stummel davor. Belegt. Ein Rest bleibt: `pSum->UnsetFlag(MSF_HAS_ATTACHMENT)` (:848) wird bei Misserfolg nicht zurückgenommen. Im Weg über `CImapMailbox` trifft das nur die Kopie `pImapSum` und schadet nicht. In `HandlePostFetch` trifft es die echte neue Zusammenfassung. Die Folge ist höchstens, dass eine Mail mit einem einzigen Nicht-Text-Teil zwischen Konten nicht hochgeladen wird („Text nicht geladen“). Das ist sicher, nur unnötig (T3, belegt).

**Mehrteilige Mails bewusst ausgenommen: ist das sicher? Nein (K1).** Bei :970-976 setzt nur ein Erfolg `hResult = S_OK`. Scheitert `DownloadMultipartBody`, bleibt das `S_OK` des Kopfabrufs stehen. Die Mail bekommt dann bei :1084 `~IMFLAGS_NOT_DOWNLOADED` und gilt als ganz geladen. Betroffen sind:

1. **`multipart/alternative` ohne Anhang**, also praktisch jede HTML-Mail. Ein `NO` auf `BODY[1]`/`BODY[2]` oder ein Abbruch führt dazu, dass `HandleMultipartAlternative` und danach `DownloadAllParts` scheitern. Die Mail gilt als geladen, `HasAttachment()` ist falsch, und so läuft der Weg über `AppendMessageFromLocal` (ImapToc.cpp:1292). **Nur der Kopf wird hochgeladen, und die Quelle wird gelöscht.** Das ist das Bild von `E-188t`. Nach lokal ist es das Bild von `E-188f`.
2. **`multipart/mixed`, bei dem jeder Anhang scheitert.** `BreakoutBodyToFile` liefert FALSE (:3610), dann wird kein `MSF_HAS_ATTACHMENT` gesetzt (:3661, :1094), weil die Markierung bei :848 gelöscht wurde. Es läuft also wieder `AppendMessageFromLocal` statt `AppendMessageAcrossRemotes`, und **der Anhang ist auf dem Server weg.**

Die Begründung im Kommentar lautet: *„dort meldet schon ein einzelner gescheiterter Anhang FALSE“*. Sie trifft zu. Ein pauschales `E_FAIL` würde eine Mail mit einem dauerhaft kaputten Anhang unlesbar machen. Das spricht aber nur gegen *diese* Behebung, nicht dafür, den Verlustweg offen zu lassen. Der Befund führt den Punkt unter „Was noch fehlt“. Dass er HTML-Mails und Anhänge betrifft, steht dort nicht. Vorschlag in K1.

## 3. Vorab-Kopie über das Merkzeichen (`a9c5d6aa`)

**Was sich ändert (belegt).** `ImapCopyMsgFromImapToLocal` (ImapToc.cpp:1212-1214) und `ImapCopyMsgBetweenAccounts` (:1324-1330) suchen mit `E184FindeVorabKopie` (:1809-1822). Die Funktion liefert den **ersten** markierten Eintrag mit dieser Nummer in Listenfolge und löscht danach das Merkzeichen. `CTocDoc::Xfer` markiert jetzt auch von IMAP nach lokal, wenn die Mail nicht ganz geladen ist (tocdoc.cpp:3013-3014). `Copy()` übernimmt das Merkzeichen nicht (summary.h:479). Gegen eine fremde Mail mit derselben Nummer ist das richtig.

**Kann ein Merkzeichen liegen bleiben und später eine falsche Kopie treffen? Ja, auf drei Wegen:**

- **Nach lokal, gescheitert (K3, belegt).** Lässt sich der Text nicht laden (:2441) oder scheitert `ImapCopyMsgFromImapToLocal`, bleibt die markierte Kopf-Kopie im lokalen Ziel. Niemand entfernt sie oder löscht ihr Merkzeichen. Zwischen Konten tut das `E189VorabKopienEntfernen`, nach lokal gibt es kein Gegenstück. Ein späteres Verschieben einer **anderen** Mail mit derselben Nummer ins selbe lokale Postfach in derselben Sitzung, etwa UID 5 aus einem anderen Ordner, findet zuerst die alte Kopie. Der Grund ist `GetHeadPosition` und der Zusatz mit `AddTail`, tocdoc.cpp:1444. Der Eintrag mit Betreff und Absender der ersten Mail zeigt dann auf den Text der zweiten (:1220-1240). Der Eintrag der zweiten bleibt ohne Text und markiert. Das ist wieder das Bild von `E-188l`. Auf dem Server geht nichts verloren, der Text steht im lokalen Postfach, nur unter dem falschen Eintrag. Häufigkeit gering: es braucht erst einen gescheiterten Weg nach lokal.
- **Nach Neustart mit gespeicherter Warteschlange (K4, belegt; der ganze Weg ist eine Vermutung).** Das Merkzeichen lebt nur im Speicher (summary.h:479). Die Vorab-Kopien stehen aber in der gespeicherten TOC. Wird die Aktion nach einem Neustart abgearbeitet, findet `E184FindeVorabKopie` nichts.
  - *Zwischen Konten:* Es entsteht eine neue Zusammenfassung (:1333). `E189VorabKopienEntfernen` läuft nicht, weil `pCopySum` gesetzt ist. Die alte, unmarkierte Kopie mit der alten Nummer bleibt stehen. Das ist das Doppel aus `E-188k` mit der Gefahr aus `E-188d`. Vor `a9c5d6aa` war das nicht anders, also keine Verschlechterung. Es ist dieselbe Lücke wie [E-184](../Intern/BEFUNDE.md#e-184) K4 (PRÜFER-75).
  - *Nach lokal:* Vorher fand die Suche über die Nummer die unmarkierte Kopf-Kopie richtig, solange keine andere Mail dieselbe Nummer trug. Jetzt findet sie sie nicht. Es entsteht ein zweiter Eintrag mit Text neben der Kopf-Kopie. **Das ist eine kleine Verschlechterung.** Ein Doppel, kein Verlust.
- **Zwei Warteschlangen-Aktionen ins selbe Ziel mit gleicher Nummer** aus verschiedenen Quellordnern (T4, Vermutung). Beide Vorab-Kopien sind markiert und tragen dieselbe Nummer. Welche zuerst gefunden wird, hängt an der Listenfolge. Scheitert die erste Aktion, entfernt `E189VorabKopienEntfernen` mit seiner `while`-Schleife (:1842) **beide**, und die zweite legt eine neue an. Das ist harmlos. Selten.

**`E189VorabKopienEntfernen` bei `!pCopySum`, auch wenn `RewriteMbxStub` nach gelungenem `APPEND` scheitert.** Belegt: dann ist `bResult` FALSE und `*ppCopySum` NULL (:1278). Die Vorab-Kopie wird entfernt, und die Quelle bleibt. **Die Mail liegt auf beiden Servern** (K7). Im Ziel kommt sie mit dem nächsten Abgleich unter ihrer richtigen Nummer. Das ist ein Doppel, kein Verlust, und der Fall ist selten: nur bei einem Schreibfehler im lokalen Cache.

**`pCopySum` je Mail zurückgesetzt (:2157).** Das ist richtig und nötig. Im Zweig „Text nicht geladen“ wird `ImapCopyMsgBetweenAccounts` nicht aufgerufen, und ohne das Zurücksetzen sähe die Bedingung :2173 die Kopie der vorigen Mail. Die Vorab-Kopie bliebe stehen. Belegt. Der Test prüft das aber nicht (K5).

## 4. Neue Nummer und eigene Merkzeichen (`044477d2`, `5e091c97`)

| Frage | Antwort | Kennzeichnung |
|---|---|---|
| Braucht `AddSum` eine Kennung, vergibt es eine? | Es vergibt eine. `InternalAddSum` setzt `m_NextUniqueMessageId` nur, wenn die Kennung 0 ist (tocdoc.cpp:1429-1438). | belegt |
| Ist `m_UniqueMessageId = 0` nötig? | Für die Vorab-Kopie nicht. `SubtractSum` setzt sie schon auf 0 (tocdoc.cpp:1541), deshalb hält auch `ASSERT(0 == m_UniqueMessageId)` in `Copy()` (summary.cpp:627). Für die neue Zusammenfassung ist sie ohnehin 0. Die Zeile schadet nicht. | belegt |
| `m_Hash = NewUid` vor `AddSum` | richtig. `Copy()` übernimmt `m_Hash` (summary.cpp:612). Nur so steht die Kopie im Ziel unter der Nummer, die der Server ihr gab. | belegt; Wirkung gemessen (`E-188k/d` grün) |
| Flags und Status der Vorab-Kopie zurück | Die Vorab-Kopie entstand in `Xfer` mit `Copy(Sum)` (tocdoc.cpp:3000), **bevor** `ImapRemoveOrderedSubSums` die Quelle als gelöscht markiert (ImapToc.cpp:774 bzw. :919, aufgerufen erst nach der Schleife über `ImapXfer`, tocdoc.cpp:3191; Merkzeichen :2498). Sie trägt also die Merkzeichen und den Status der Quelle vor dem Verschieben, und genau das soll die Kopie im Ziel tragen. | belegt |
| `IMFLAGS_NOT_DOWNLOADED` der Vorab-Kopie gegen den hochgeladenen Text | War die Quelle beim Verschieben nur als Kopf geladen und wird sie erst in `DoPostProcessing` nachgeladen, trägt die Kopie im Ziel `NOT_DOWNLOADED`, obwohl `RewriteMbxStub` den ganzen Text ins Ziel geschrieben hat. Folge: beim Öffnen wird die Mail noch einmal vom Server geholt, unter `NewUid`, also die richtige. Das kostet nur einen unnötigen Abruf. Der umgekehrte Fall, „geladen“ mit nur einem Stummel, kann nicht eintreten, denn ohne Anhang wird jetzt nur bei ganz geladenem Text hochgeladen (:2158). | belegt |
| Ohne Vorab-Kopie nur `IMFLAGS_DELETED` entfernt: reicht das? | Für die Anzeige ja. Den Status übernimmt die Kopie aber von der Quelle, und die steht nach `ImapRemoveOrderedSubSums` auf `MS_READ` (ImapToc.cpp:2499). Eine ungelesene Mail kommt also als gelesen an, aber nur ohne Vorab-Kopie, also nach einem Neustart (K4). Sehr gering (T5). `m_nUndownloadedAttachments` übernimmt `Copy()` in keinem der beiden Zweige (summary.cpp:587-628). Das war schon im Original so und ist nicht neu. | belegt |

## 5. Regressionstest, Messskript, Fall `E-188d`

**`Tests/TestE188.cpp`.** Er liest den Quelltext ohne Kommentare und prüft Stellen und Reihenfolgen. Die Tests lesen den Quelltext zur Laufzeit, deshalb genügt für Gegenproben `--ohne-bau`. Gemessen:

| Probe | Ergebnis | Erwartung |
|---|---|---|
| Stand wie eingecheckt, Bau und Lauf | 409/409 | grün |
| Positivprobe: `DeleteMessagesFromServer(strAngekommen,` → `(m_szMessageIDs,` zwischen Konten | **1 rot** (`[FEHL] E-188: Quelle wird nur geloescht …`) | rot, passt |
| Gegenprobe: Zeile `bAngekommen = false;` nach lokal entfernt (:2435) | **409/409 grün** | rot: ohne die Zeile gilt eine nicht ladbare Mail als angekommen, und die Quelle wird gelöscht (`E-188f` wieder offen) |
| Gegenprobe: `pCopySum = NULL;` je Mail entfernt (:2157) | **409/409 grün** | rot: `QT_Stelle(pK2, "pCopySum = NULL;")` findet die Deklaration `CSummary *pCopySum = NULL;` (:2132), und die liegt immer vor dem Aufruf |

Ich habe beide Male mit Perl `:raw` geändert, genau einen Treffer gezählt, die Datei aus der Sicherung im Scratchpad zurückgeholt und mit `cmp` geprüft: byte-gleich. Danach war `git status` leer. Die Testmeldungen selbst sind gut. Sie nennen den Befundfall und schreiben „ungeprüft ist nicht grün“.

**`tools/messen-e188.ps1`, Weg `loeschen` (`ed60ee09`).** Ich habe es gelesen, aber nicht ausgeführt. Die Zahl N kommt aus `Ziel.toc` mit dem Betreff `Pruefnachricht 1*`. Gelöscht wird N-mal die letzte Zeile, nachdem die Liste so viele Zeilen hat wie `Ziel.toc` minus die schon gelöschten (bis zu 60 s). Sonst meldet das Skript *UNGEMESSEN*. Weicht die Anzeigefolge von `Ziel.toc` ab, löscht es womöglich die fremde Mail. Dann wird der Fall rot, nie blind grün. Das Skript sagt das selbst. Belegt.

**Fall `E-188d` (pruefstand-faelle.txt:279).** Er verlangt jetzt `E188 GELOESCHT ALLE` und verbietet `E188 SERVER FREMDE GELOESCHT`. Vorher verlangte er `E188 ERGEBNIS weg=loeschen`. Die Lücke (K8, belegt): `GELOESCHT ALLE` wird in der Bedienphase geschrieben (:493), **vor** der Auswertung der Server. `FREMDE GELOESCHT` setzt voraus, dass `Zustand $logB` einen Endstand liefert (:526, :543). Liefert es `@()`, etwa weil `ZUSTAND ENDE` im Protokoll fehlt (:177-179), oder bricht das Skript nach der Bedienphase ab, ist der Fall grün, ohne dass der Server gemessen wurde. Das Format kennt nur eine Muss-Zeichenkette. Abhilfe: `geloescht-alle=N` in die `ERGEBNIS`-Zeile schreiben und `E188 ERGEBNIS weg=loeschen geloescht-alle=` verlangen. Dazu im Skript: kein Endstand von B ergibt *UNGEMESSEN*. **Die Gegenprobe am alten Bau** war rot aus einem anderen Grund, nämlich *UNGEMESSEN*, weil die Kopie ausgeblendet war. Den eigentlichen Fehler, dass die fremde Mail auf dem Server gelöscht wird, zeigt sie nicht. Er ist aber am 03.11. mit der alten Fassung des Falls gemessen (laut Befund). Das ist ein Hinweis, kein Mangel.

## Funde

### <a id="k1"></a>K1 (kritisch, belegt): mehrteilige Mails, also HTML-Mails, gelten bei verweigertem Rumpf als geladen, und der Verlustweg bleibt offen

- **Wo:** ImapDownload.cpp:970-976. `hResult` bleibt das `S_OK` aus :859, wenn `DownloadMultipartBody` scheitert. Danach folgt :1084 `~IMFLAGS_NOT_DOWNLOADED`.
- **Folge:** Zwischen Konten wird nur der Kopf hochgeladen (`AppendMessageFromLocal`, ImapToc.cpp:1292), und die Quelle wird gelöscht. Nach lokal kommt nur der Kopf an, und die Quelle wird gelöscht. Scheitern alle Anhänge, ist der Anhang weg (§2). Auf dem Prüfstand nicht gemessen: die Fälle `E-188t/f` arbeiten mit `text/plain`.
- **Wie oft:** selten, denn es braucht ein `NO` oder einen Abbruch beim Laden. Betroffen ist aber die häufigste Mailform. Vor dem Paket mit einem Fall `E-188t` mit HTML-Mail nachstellen (Prüfserver `--fetch-text-scheitert` auf `BODY[1]`/`BODY[2]`).
- **Vorschlag:** In `DownloadSingleMessage` bei gescheitertem `DownloadMultipartBody` ein Merkzeichen im Speicher setzen, etwa „Rumpf unvollständig“, ohne `E_FAIL`, damit die Mail lesbar bleibt. Die Löschschranke an beiden Stellen (ImapActionQueue.cpp:2158, :2436) wertet es aus. Gründlicher wäre es, zwischen Konten **immer** über `AppendMessageAcrossRemotes` zu gehen, also den Rohtext vom Server statt aus dem lokalen Cache (ImapToc.cpp:1285). Dann hängt dieser Weg gar nicht mehr am lokalen Ladestand. Fortschreiben in [E-188](../Intern/BEFUNDE.md#e-188) unter „Was noch fehlt“. Dort fehlt bisher, dass HTML-Mails und Anhänge betroffen sind.

### <a id="k2"></a>K2 (mittel, belegt; Weg nicht gemessen): nach lokal gilt „inzwischen ganz geladen“ als „schon kopiert“

- **Wo:** ImapActionQueue.cpp:2419-2423. Ist `IsNotFullyIMAPDownloaded()` falsch, setzt der Code `bAngekommen = true`, ohne zu prüfen, ob `Xfer` den ganzen Text kopiert hat.
- **Folge:** Wurde die Mail zwischen `Xfer` und der Warteschlange geladen (Wege in §1, Vermutung), liegt lokal nur der Kopf, und auf dem Server wird die Mail gelöscht. Das Merkzeichen bleibt liegen (K3). Der Fehler stammt aus dem Original.
- **Vorschlag, eine Bedingung:** `if (pSum->IsNotFullyIMAPDownloaded() || E184FindeVorabKopie(m_pDestTocDoc, pSum->GetHash()))`. Eine markierte Kopf-Kopie im Ziel heißt: die Arbeit ist noch nicht getan. Danach die Fälle `E-188l/e/f` nachmessen.

### <a id="k3"></a>K3 (gering, belegt): nach einem gescheiterten Weg nach lokal bleibt die markierte Kopf-Kopie stehen

- **Wo:** ImapActionQueue.cpp:2441-2446. Nach lokal gibt es kein Gegenstück zu `E189VorabKopienEntfernen`.
- **Folge:** Eine spätere Mail mit derselben Nummer, die ins selbe lokale Postfach geht, trifft die alte Kopie. Das ist das Bild von `E-188l`, nur ohne Verlust auf dem Server (§3).
- **Vorschlag:** Im Zweig „nicht angekommen“ `E184FindeVorabKopie(m_pDestTocDoc, uid)->SetE184Vorab(FALSE)`. Oder die Kopf-Kopie entfernen, wie zwischen Konten. Das beantwortet dann auch den offenen Punkt im Befund (*„nach lokal mit nicht ladbarem Text bleibt lokal ein Eintrag ohne Text“*).

### <a id="k4"></a>K4 (gering, belegt; Weg Vermutung): nach einem Neustart mit gespeicherter Warteschlange fehlt das Merkzeichen

- Zwischen Konten bleibt das Doppel mit der alten Nummer stehen. Das ist wie vorher und dieselbe Lücke wie [E-184](../Intern/BEFUNDE.md#e-184) K4. Nach lokal entsteht neu ein zweiter Eintrag neben der Kopf-Kopie. **Das ist die einzige, kleine Verschlechterung gegenüber 7.2.2.132.**
- **Vorschlag:** Erst wenn [E-184](../Intern/BEFUNDE.md#e-184) K4 angegangen wird, gemeinsam lösen, etwa das Merkzeichen in der TOC speichern oder nach dem Neustart über die Nummer suchen, aber nur bei genau einem Treffer ohne Gegenstück auf dem Server.

### <a id="k5"></a>K5 (mittel, gemessen): `TestE188.cpp` sieht zwei der Änderungen nicht

- Ohne `bAngekommen = false;` (nach lokal) und ohne das Zurücksetzen `pCopySum = NULL;` bleibt die Suite 409/409 grün (§5).
- **Vorschlag, etwa zehn Zeilen:** Nach lokal prüfen, dass `bAngekommen = false;` zwischen `ImapFetchMessagesFromServer(` und `if (!pSum->IsNotFullyIMAPDownloaded())` steht. Zwischen Konten nach `"pCopySum = NULL;"` erst **ab** `QT_Stelle(pK2, "bool bAngekommen = false;")` suchen. Danach beide Gegenproben wiederholen, sie müssen rot werden. Gehört vor den Merge.

### <a id="k6"></a>K6 (gering, belegt): eine fehlende Zusammenfassung beendet die Liste still

- **Wo:** ImapActionQueue.cpp:2138/2192 und :2415/2461.
- **Folge:** Der Rest der Liste wird weder verschoben noch gemeldet, und zwischen Konten bleiben dessen markierte Vorab-Kopien mit alter Nummer im Ziel stehen. Gegenüber dem Original ist das eine Verbesserung, denn dort wurde der Rest auf dem Server ohne Kopie gelöscht.
- **Vorschlag:** Die Liste selbst durchlaufen und bei fehlender Zusammenfassung `bSomeFailed = true` setzen, eine Spurzeile schreiben und `E189VorabKopienEntfernen` für diese Nummer aufrufen. Danach mit `continue` weiter.

### <a id="k7"></a>K7 (gering, belegt): gescheiterte Wege bleiben ohne Meldung

- Nach lokal gibt es weder Dialog noch Zustand, denn `m_iState = Failed` liest niemand (§1). Die Quelle bleibt bis zum nächsten Abgleich als gelöscht markiert. Zwischen Konten liegt die Mail nach gelungenem `APPEND` und gescheitertem `RewriteMbxStub` auf beiden Servern, ebenfalls ohne Meldung.
- **Vorschlag:** Nach lokal bei `bSomeFailed` eine Meldung wie `IDS_WARN_IMAP_SOME_XFER_FAILED` (ImapToc.cpp:792) und die lokalen Merkzeichen der nicht angekommenen Quellen zurücknehmen (`ImapRemoveOrderedSubSums` mit `bUndelete`, :2490).

### <a id="k8"></a>K8 (gering, belegt): `E-188d` kann ohne Serverstand grün werden

- Die verlangte Zeile steht vor der Auswertung der Server, und ein leerer Endstand von B meldet keine gelöschte fremde Mail (§5).
- **Vorschlag:** die Zeile in `ERGEBNIS` verlegen und ohne Endstand *UNGEMESSEN* melden.

### Hinweise (halten nichts auf)

- **T1:** Der Zweig `DownloadSubMessage` der obersten Ebene ist toter Code (ImapDownload.cpp:913 gegen :983). Das betrifft nur die Lesbarkeit.
- **T2:** `HandlePostFetch` bricht nach der ersten verweigerten Mail ab (ImapChecker.cpp:1530). Die übrigen Mails werden beim Öffnen geladen.
- **T3:** `MSF_HAS_ATTACHMENT` wird bei Misserfolg nicht zurückgesetzt (ImapDownload.cpp:848). Das ist sicher, nur unnötig.
- **T4:** Zwei markierte Vorab-Kopien mit gleicher Nummer im selben Ziel: welche zuerst gefunden wird, hängt an der Listenfolge. Das ist harmlos.
- **T5:** Ohne Vorab-Kopie kommt eine ungelesene Mail als gelesen an (`MS_READ` aus ImapToc.cpp:2499).

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | HTML-Mail oder Mail mit Anhängen: bei verweigertem oder abgebrochenem Rumpf wird nur der Kopf übertragen und die Quelle gelöscht. Der Verlustweg ist offen wie bei 7.2.2.132. | kritisch (selten, aber häufigste Mailform) | nein, keine Verschlechterung; Kritische sind kein Release-Blocker (Gregor 23.10.). Release-Text darf [E-188](../Intern/BEFUNDE.md#e-188) nicht als ganz behoben führen. Vorher mit HTML-Fall nachstellen. |
| K2 | Nach lokal: inzwischen ganz geladene Mail gilt als kopiert, lokal nur der Kopf, Server gelöscht | mittel (Original, Weg Vermutung) | nein; eine Bedingung, bietet sich im selben Zweig an |
| K3 | Merkzeichen nach gescheitertem Weg nach lokal bleibt, spätere gleiche Nummer trifft falsche Kopie | gering | nein |
| K4 | Nach Neustart mit Warteschlange kein Merkzeichen: Doppel (Konten, wie vorher) bzw. zweiter Eintrag (lokal, neu) | gering | nein |
| K5 | Test blind für `bAngekommen = false;` und `pCopySum = NULL;` | mittel | nein, aber vor dem Merge nachziehen |
| K6 | Fehlende Zusammenfassung beendet die Liste still, Vorab-Kopien bleiben | gering | nein |
| K7 | Gescheiterte Wege ohne Meldung, Quelle scheinbar verschoben | gering | nein |
| K8 | `E-188d` ohne gemessenen Serverstand grün möglich | gering | nein |
| T1-T5 | Hinweise | sehr gering | nein |
