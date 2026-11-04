# <a id="pruefer-96"></a>PRUEFER-96

Nachtrag zu [PRUEFER-95](PRUEFER-95.md#pruefer-95). Zweig wt/pruefer-20261104c, abgezweigt von `origin/e188_loeschschranke`, Stand `e2456be9`. Geprüft wird nur `9c9d9ffc` (Behebung von [PRUEFER-95 K1](PRUEFER-95.md#k1) und [PRUEFER-95 K2](PRUEFER-95.md#k2)); seit diesem Commit hat sich unter `Eudora71/` nichts mehr geändert, unter `tools/` nur `TESTLAEUFE.md`. Eudora habe ich weder gebaut noch gestartet, kein Fenster geöffnet, keinen Prüfstand angefasst. Die Testsuite habe ich in meinem Baum gebaut und gefahren.

## Ergebnis vorweg

Die Behebung tut, was sie soll: Scheitert eine mehrteilige oder eingebettete Mail als Ganzes, bleibt sie jetzt „nicht geladen“, und der Downloader setzt das Merkzeichen selbst. Eine ganz geladene Mail bleibt dadurch nicht fälschlich „nicht geladen“: weder beim Laden über einen Übersetzer noch bei einem absichtlich nicht geladenen Anhang. Die Testsuite läuft mit **409/409**, und der Test erkennt das Entfernen der neuen Zeile genauso wie das Zurückholen der alten.

Drei Dinge sind wichtig:

- **Unzustellbarkeitsberichte und Lesebestätigungen könnten jetzt dauerhaft „nicht geladen“ bleiben (K1, Vermutung zum Server, Rest belegt).** Eudora fragt für jeden `message/…`-Teil den Kopf ab, auch für `message/delivery-status` und `message/disposition-notification`, die gar keinen Kopf haben. Antwortet der Server darauf mit `NO`, gilt die Mail jetzt bei jedem Öffnen als unvollständig und wird neu geholt, und zwischen Konten wird sie gar nicht verschoben. Vorher galt sie als geladen, aber der angehängte Originaltext fehlte. Das ist die gewollte Richtung („Sicherheit vor Platz“), aber es träfe dann **jeden** solchen Bericht, nicht nur kaputte Mails. Ob Gregors Server so antwortet, ist nicht gemessen.
- **Der geänderte Weg in `ImapChecker.cpp` läuft nie (Hinweis T1, belegt).** `DownloadRemainingMessagesMT` lädt im Zweig „ganze Nachricht“ immer die Nummer 0 und hängt das Ergebnis nirgends an. Die Änderung dort schadet nicht, nützt aber auch nichts. Der Weg in `ImapMailbox.cpp` läuft nur, wenn der Anwender gerade Esc gedrückt hat, und schreibt in die echte `.mbx`, nicht in die temporäre. `CopyTextFromTmpMbx` ist von der Änderung also auf keinem lebenden Weg betroffen. Bei abgeschaltetem „Minimal headers only“ lädt in Wirklichkeit `HandlePostFetch`, und das war schon vorher richtig.
- **Ein Rest von [PRUEFER-95 K1](PRUEFER-95.md#k1) bleibt (K2, belegt, selten).** In einer eingebetteten Mail wertet `DownloadSubMessage` das Ergebnis ihres Rumpfs nicht aus. Scheitert dort etwas, das keine der markierten Abrufstellen ist, etwa der Kopf einer zweiten, darin eingebetteten Mail, gilt die Mail weiter als geladen.

**Kein Fund hält den Merge auf.** Keiner ist eine Verschlechterung beim Verlust von Mail. Neue Kennungen habe ich nicht vergeben, alle Funde setzen [E-188](../Intern/BEFUNDE.md#e-188) fort. E-226 und E-227 bleiben frei.

## 1. Was `9c9d9ffc` ändert, gegen die Quelle

**(a) Scheitern als Ganzes (belegt).** In `CImapDownloader::DownloadSingleMessage` setzen jetzt beide `else`-Zweige `m_bE188TeilFehlt = TRUE` (ImapDownload.cpp:978-984 für `DownloadMultipartBody`, :998-1001 für `DownloadSubMessage`). `hResult` stammt dort noch vom gelungenen Kopfabruf (`UIDFetchHeaderFull`, :861) und bleibt `S_OK`, die Mail wird also wie gewollt gezeigt, nicht abgeschnitten. Der zweite Zweig (`pBody->type == TYPEMESSAGE`) ist unerreichbar: eine Mail, die ganz aus einer eingebetteten Mail besteht, geht schon bei :915 auf `bDownloadFully`. Er schadet nicht.

**Was `DownloadMultipartBody` FALSE werden lässt**, also jetzt „nicht geladen“ (belegt):

| Ursache | Stelle | richtig? |
|---|---|---|
| ein Teilabruf scheitert (`NO`, Abbruch) | die vier markierten Stellen, dazu `UIDFetchRFC822Header` (:4014) | ja |
| lokal: `CreateAttachFile`, `OpenEmbeddedFile`, Platzhalter schreiben scheitert | `BreakoutBodyToFile` (:3596), `DownloadAllParts` bricht ab (:3193) | ja, die Teile danach fehlen wirklich |
| `IsSelected()` falsch | Anfang jeder Teilfunktion | ja |
| absichtlich nicht geladener Anhang (Platzhalter) | `WriteBodyPartPlaceHolder` gibt TRUE (:3655) | wird nicht ausgelöst, richtig |
| Anhang wird nach MIME-Tabelle oder als `.vcf` gelöscht | `bResult = TRUE` (:3585), `DeleteFile` danach | wird nicht ausgelöst, richtig |
| `multipart/alternative` | `HandleMultipartAlternative` gibt immer TRUE | wird nicht ausgelöst, die vier Stellen tragen |
| ein `multipart` ohne jeden Teil | `DownloadAllParts`: `bResult` beginnt mit FALSE (:3048), die Schleife (:3101) läuft nicht | **falsch „nicht geladen“**, siehe T2 |

**(b) Setzen statt Stehenlassen (belegt).** Im Erfolgszweig steht jetzt `pSum->m_Imflags |= IMFLAGS_NOT_DOWNLOADED` (:1107), sonst wird gelöscht (:1113). Der Zweig läuft nur für `!bDownloadFully` (:1092).

**Übersetzer, `bDownloadFully` (belegt).** Der Weg bricht bei :901 oder :915 ab, bevor ein Teil geholt wird, `m_bE188TeilFehlt` ist also FALSE. `DownloadSingleMessageFully` löscht das Merkzeichen selbst (:548, :553) oder gibt `E_FAIL`. Eine ganz geladene Mail bleibt auf diesem Weg nicht „nicht geladen“.

**(c) Sind die Zusammenfassungen dort wirklich neu? (belegt)** Ja. Beide Wege legen sie mit `DEBUG_NEW_MFCOBJ_NOTHROW CImapSum` an (ImapChecker.cpp:1016, ImapMailbox.cpp:2655), der Konstruktor setzt `m_Imflags = 0` (ImapSum.cpp:142), und zwischen Anlegen und Laden steht nur `SetHash`. Das Merkzeichen kann also nur vom Downloader kommen.

**Laufen die beiden Wege überhaupt? (belegt)**

| Weg | Befund | Kennzeichnung |
|---|---|---|
| `CImapChecker::DownloadRemainingMessagesMT`, Zweig „ganze Nachricht“ | `uid` wird mit 0 angelegt (ImapChecker.cpp:983) und nie aus `uidmap` gelesen; `SetHash(uid)` (:1019) lädt also Nummer 0. Gelingt das, wird `pImapSum` nicht in `pSumList` gehängt (einziges `AddTail` der Datei steht bei :1490) und geht verloren. Der Zweig läuft ohnehin nur im Hauptthread (:1005); `DoCheckMailMT` läuft als Hintergrundaufgabe | belegt; dass `DoCheckMailMT` nie im Hauptthread läuft: Vermutung |
| `CImapMailbox::DownloadRemainingMessages` | einziger Aufrufer `DoFetchNewMessages` ruft ihn nur unter `if (EscapePressed())` (ImapMailbox.cpp:2464-2471), also nur, wenn gerade Esc in der Warteschlange lag. `bToTmpMbx` bleibt FALSE (Vorgabe, :2471), geladen wird in die echte `.mbx` | belegt; das umgekehrte `if` steht so schon im Original (`567a5d87`, Zeile 2462) |
| `HandlePostFetch` (der wirkliche Weg bei „Minimal headers only“ aus) | lädt in die echte `.mbx` (`DownloadSingleMessage(pImapSum, FALSE, FALSE)`, ImapChecker.cpp:1531); die Zusammenfassung kommt aus dem Minimalabruf mit gesetztem Merkzeichen (ImapDownload.cpp:1840) | belegt, von `9c9d9ffc` nicht berührt |

**`CopyTextFromTmpMbx` (belegt).** Die Funktion überspringt jede Zusammenfassung mit stehendem Merkzeichen (ImapMailbox.cpp:7766-7769). Auf dem einzigen Weg, der in die temporäre `.mbx` lädt (`DownloadRemainingMessagesMT`), kommen nur Minimalabrufe in die Liste, und die haben ohnehin kein Rumpfstück dort. An ihrem Verhalten ändert `9c9d9ffc` auf keinem lebenden Weg etwas. Wäre der Zweig „ganze Nachricht“ lebendig, behielte eine unvollständige Mail Offset und Länge in die temporäre Datei, und die zeigten in der echten `.mbx` auf fremde Bytes. Das ist der Vorbehalt aus [PRUEFER-95 K2](PRUEFER-95.md#k2); er greift heute nicht.

## 2. Test

**Gemessen in meinem Baum** (Quelle mit Perl `:raw` geändert, Treffer gezählt, aus der Sicherung im Scratchpad zurückgeholt, mit `cmp` byte-gleich geprüft, `git status` danach leer; Läufe mit `--ohne-bau`, weil der Test die Quelle zur Laufzeit liest):

| Probe | Treffer | Ergebnis | Erwartung |
|---|---|---|---|
| Stand wie eingecheckt, Bau und Lauf | – | 409/409 | grün |
| P1: `pSum->m_Imflags \|= IMFLAGS_NOT_DOWNLOADED;` in ImapDownload.cpp entfernt | 1 | **1 rot** | rot, passt |
| P2: in ImapMailbox.cpp `pImapSum->m_Imflags &= ~IMFLAGS_NOT_DOWNLOADED;` wieder eingesetzt | 1 | **1 rot** | rot, passt |
| G3: dieselbe Zeile als `&= ~(IMFLAGS_NOT_DOWNLOADED);` | 1 | **409/409 grün** | rot, siehe K3 |

## Funde

### <a id="k1"></a>K1 (mittel, belegt; Serververhalten Vermutung): Berichte mit `message/delivery-status` könnten dauerhaft „nicht geladen“ bleiben

- **Wo:** `DownloadAllParts` schickt jeden Teil vom Typ `TYPEMESSAGE` an `DownloadSubMessage` (ImapDownload.cpp:3152), und der holt zuerst `UIDFetchRFC822Header` (:4014), also `BODY.PEEK[n.HEADER]` (proto.cpp:172-173). Der Parser vergibt `TYPEMESSAGE` für **jeden** Untertyp, nur `RFC822` bekommt einen eingebetteten Kopf (proto.cpp:4878-4880). Für `message/delivery-status` (Unzustellbarkeitsbericht) und `message/disposition-notification` (Lesebestätigung) wird also ein Kopf verlangt, den es nicht gibt. RFC 3501 §6.4.5 erlaubt `HEADER` hinter einer Teilnummer nur für `message/rfc822`.
- **Folge, wenn der Server `NO` sagt:** `DownloadAllParts` bricht ab, der angehängte Originaltext (meist Teil 3) wird nie geholt. Vor `9c9d9ffc` galt die Mail trotzdem als geladen (das war [PRUEFER-95 K1](PRUEFER-95.md#k1)). Jetzt bleibt sie „nicht geladen“: bei jedem Anzeigen neu geholt ([PRUEFER-95 K3](PRUEFER-95.md#k3)), und zwischen Konten wird sie, ohne Anhang, gar nicht hochgeladen und bleibt ohne Meldung in der Quelle (ImapActionQueue.cpp:2158, [PRUEFER-94 K7](PRUEFER-94.md#k7)). Kein Verlust, aber die Mail lässt sich nicht verschieben, und der Originaltext fehlt weiter.
- **Wie oft:** Vermutung. Antwortet der Server mit leerem Inhalt statt `NO`, passiert nichts. Wie Gregors Server antwortet, ist nicht gemessen. Wenn `NO`, dann trifft es jeden solchen Bericht im Konto, nicht nur kaputte Mails, also mehr als bei der Entscheidung „Sicherheit vor Platz“ angenommen.
- **Vorschlag:** in `DownloadSubMessage` den Kopfabruf nur machen, wenn `pBody->nested.msg` gesetzt ist (also `message/rfc822`); sonst gleich `AppendBodyTextToMbxFile` wie im `else` bei :4110. Messen lässt sich das am Prüfserver mit einem `multipart/report`, der `BODY[2.HEADER]` mit `NO` beantwortet (siehe [PRUEFER-95 K6](PRUEFER-95.md#k6)), und an Gregors Server mit einem Bounce in der Spur.

### <a id="k2"></a>K2 (gering, belegt; selten): in einer eingebetteten Mail wird das Scheitern des Rumpfs nicht weitergegeben

- **Wo:** `DownloadSubMessage` ruft `DownloadSimpleBody` (ImapDownload.cpp:4092) und `DownloadMultipartBody` (:4103) auf, ohne das Ergebnis zu nutzen; `bResult` bleibt TRUE vom Kopfabruf.
- **Folge:** Die Abrufe der Blätter sind trotzdem erfasst (sie setzen `m_bE188TeilFehlt` selbst). Nicht erfasst ist, was nur über den Rückgabewert läuft: der Kopf einer weiteren `message/rfc822` **innerhalb** der eingebetteten Mail (weitergeleitete Mail, die selbst eine weitergeleitete Mail enthält; Bounce einer solchen) und die lokalen Fehler aus §1. Dann gilt die Mail als geladen, und die Teile danach fehlen. Das Bild von [PRUEFER-95 K1](PRUEFER-95.md#k1), eine Ebene tiefer.
- **Vorschlag:** `bResult = DownloadSimpleBody (…)` und `bResult = DownloadMultipartBody (…)`. Dann reicht das bestehende `else` in `DownloadSingleMessage` für jede Tiefe.

### <a id="k3"></a>K3 (gering, gemessen): der Test erkennt das Löschen nur in einer Schreibweise

- `QT_Enthaelt(…, "&= ~IMFLAGS_NOT_DOWNLOADED")` übersieht `&= ~(IMFLAGS_NOT_DOWNLOADED)` (G3 grün). Umgekehrt verbietet die Prüfung das Löschen in der **ganzen** Datei ImapChecker.cpp und ImapMailbox.cpp; ein späteres, berechtigtes Löschen an anderer Stelle würde rot.
- **Vorschlag:** die Prüfung auf den Abschnitt der beiden Funktionen beschränken und dort nach `IMFLAGS_NOT_DOWNLOADED` überhaupt suchen (darf nur im Kommentar stehen, der ist weg). [PRUEFER-95 K5](PRUEFER-95.md#k5) ist weiter offen.

### Hinweise (halten nichts auf)

- **T1:** Der Zweig „ganze Nachricht“ in `DownloadRemainingMessagesMT` lädt immer Nummer 0 und verwirft das Ergebnis (ImapChecker.cpp:983, :1019); `DownloadRemainingMessages` läuft nur nach Esc (ImapMailbox.cpp:2464). Beides steht so im Original. Die Begründung in der Commit-Nachricht („ihre Zusammenfassung ist neu“) stimmt, die beiden Änderungen wirken aber auf keinem Weg, den ein Anwender trifft. Ein Prüfstandfall mit `IMAPMinDownload=0` ([PRUEFER-95 K6](PRUEFER-95.md#k6)) misst `HandlePostFetch`, nicht diese Zeilen.
- **T2:** Ein `multipart` ohne Teile lässt `DownloadAllParts` FALSE zurückgeben (ImapDownload.cpp:3048), die Mail bliebe jetzt dauerhaft „nicht geladen“. Ob der Parser so etwas je liefert, ist eine Vermutung; der Server müsste eine kaputte `BODYSTRUCTURE` schicken.

| Fund | Was passiert | Schwere | Hält den Merge auf? |
|---|---|---|---|
| K1 | Unzustellbarkeitsberichte und Lesebestätigungen: verweigert der Server den nicht vorhandenen Kopf, bleiben sie dauerhaft „nicht geladen“ und lassen sich zwischen Konten nicht verschieben | mittel (Server unbekannt) | nein, kein Verlust; vor dem Paket an Gregors Server messen oder den Kopfabruf auf `message/rfc822` beschränken |
| K2 | Scheitern tief in einer eingebetteten Mail lässt die Mail weiter als geladen gelten | gering (selten) | nein, keine Verschlechterung; zwei Zuweisungen |
| K3 | Test sieht das Löschen des Merkzeichens nur in einer Schreibweise und verbietet es in der ganzen Datei | gering | nein |
| T1, T2 | geänderte Wege laufen praktisch nie; leeres `multipart` | sehr gering | nein |
