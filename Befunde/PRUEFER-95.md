# <a id="pruefer-95"></a>PRUEFER-95

Nachtrag zu [PRUEFER-94](PRUEFER-94.md#pruefer-94). Zweig wt/pruefer-20261104b, abgezweigt von `origin/e188_loeschschranke`. Geprüft wird `git log 3bf03de9..HEAD -- Eudora71 tools`: die Behebungen zu [PRUEFER-94 K1](PRUEFER-94.md#k1) und [PRUEFER-94 K2](PRUEFER-94.md#k2) (`a6062c28`), der berichtigte Kommentar (`c5edab8f`), die Prüfstandfälle `E-188tm`/`E-188fm` mit `tools/imap-pruefserver.pl --mehrteilig` und `tools/messen-e188.ps1` (Wege `kontenmehr`, `fetchmehr`) sowie der mit #219 hereingekommene Umbau von `tools/haken-pr-lektor.pl`. Eudora habe ich weder gebaut noch gestartet, kein Fenster geöffnet, keinen Prüfstand angefasst. Die Testsuite habe ich in meinem Baum gebaut und gefahren, den Prüfserver kurz auf Port 1193 befragt.

## Ergebnis vorweg

Die Behebung von [PRUEFER-94](PRUEFER-94.md#pruefer-94) K1 tut im Kern, was sie soll: Verweigert der Server bei einer HTML-Mail einen Teil, bleibt die Mail jetzt „nicht geladen“, und die Löschschranke beim Verschieben greift. Das Merkzeichen wird je Nachricht zurückgesetzt, und jede der vier markierten Abrufstellen setzt es. Ein absichtlich nicht geladener Anhang (Platzhalter) löst es nicht aus. Die Behebung von [PRUEFER-94](PRUEFER-94.md#pruefer-94) K2 schreibt eine ganz geladene Mail nur dann doppelt nach lokal, wenn im Ziel eine **fremde**, liegengebliebene Vorab-Kopie mit derselben Nummer steht. Die Testsuite läuft in meinem Baum mit **409/409**.

Drei Dinge sind wichtig:

- **Bei Abruf mit „ganze Nachricht laden“ wird das neue Merkzeichen gleich wieder überschrieben (K2, am Quelltext belegt).** `CImapChecker::DownloadRemainingMessagesMT` löscht nach jedem gelungenen Laden `IMFLAGS_NOT_DOWNLOADED` selbst, ohne Bedingung. Für Konten, bei denen „Minimal headers only“ abgeschaltet ist, gilt eine neue HTML-Mail mit verweigertem Teil also weiter als ganz geladen, und der Verlustweg aus [PRUEFER-94](PRUEFER-94.md#pruefer-94) K1 ist dort offen. Die Voreinstellung ist „minimal“, deshalb ist der Weg selten. Der Prüfstand misst ihn nicht.
- **Eine weitergeleitete Mail im Anhang (`message/rfc822`) ist nicht erfasst (K1, am Quelltext belegt).** `DownloadSubMessage` holt den Kopf des eingebetteten Teils mit einem eigenen Abruf, und dessen Scheitern setzt das Merkzeichen nicht. `DownloadAllParts` bricht dann ab, alle Teile danach fehlen, und die Mail gilt als ganz geladen. Das betrifft auch Unzustellbarkeitsberichte. Der Test zählt genau vier Abrufstellen und würde eine Behebung als Fehler melden.
- **Eine Mail, deren Teil der Server dauerhaft verweigert, wird jetzt bei jedem Anzeigen neu geholt (K3, am Quelltext belegt).** Beim Öffnen sind es mindestens zwei Abrufe. Jeder hängt die ganze Mail noch einmal an die `.mbx` und legt jeden geladenen Anhang als neue Datei ins Anhangverzeichnis. Eine Endlosschleife habe ich nicht gefunden. Vorher galt eine solche Mail einmal als geladen, mit fehlendem Teil.

**Kein Fund ist eine Verschlechterung gegenüber 7.2.2.132, was den Verlust von Mail angeht.** K3 ist eine neue Belastung beim Lesen, kein Verlust, und K4 öffnet einen kleinen neuen Weg zu einem falsch beschrifteten Doppel. **Kein Fund hält den Merge auf.** K1 und K2 lassen sich in diesem Zweig schließen; zu K3 sollte Gregor vor dem nächsten Paket entscheiden, ob „bleibt ungeladen“ oder ein eigenes Merkzeichen „Rumpf unvollständig“ gewollt ist. Neue Kennungen habe ich nicht vergeben: alle Funde setzen [E-188](../Intern/BEFUNDE.md#e-188) fort, dort wird fortgeschrieben. [E-224](../Intern/BEFUNDE.md#e-224) und E-225 bleiben frei.

## 1. PRUEFER-94 K1: `m_bE188TeilFehlt` (`a6062c28`)

**Was sich ändert (belegt).** `CImapDownloader` hat das Mitglied `m_bE188TeilFehlt` (ImapDownload.h:227). Der Konstruktor belegt es mit FALSE vor (ImapDownload.cpp:214), `DownloadSingleMessage` setzt es zu Beginn zurück (:733), also vor jedem `return`. Vier Abrufstellen setzen es bei Misserfolg: `BreakoutBodyToFile` (:3626, :3636), `BreakoutBodyToEmbeddedFile` (:3792), `AppendBodyTextToMbxFile` (:3927). Im Erfolgszweig (:1092-1099) bleibt dann `IMFLAGS_NOT_DOWNLOADED` stehen, mit Spurzeile.

**Mehrere Nachrichten mit einem Objekt (belegt).** Kommt im heutigen Code nicht vor. `CImapMailbox::DownloadSingleMessage` (ImapMailbox.cpp:2918) und `CImapChecker::DownloadSingleMessage` (ImapChecker.cpp:1121) legen für jede Nachricht einen neuen Downloader an. Gäbe es doch einen zweiten Aufruf, setzt :733 das Merkzeichen zurück, bevor etwas geladen wird. Die Teilfunktionen werden nur aus dem Baum unter `DownloadSingleMessage` aufgerufen (alle Aufrufer: ImapDownload.cpp:974-4096). Ein veralteter Wert kann also nicht in eine andere Nachricht durchschlagen.

**Weitere Abrufstellen eines Teils:**

| Stelle | Abruf | erfasst? | Kennzeichnung |
|---|---|---|---|
| `DownloadSimpleBody` | über `AppendBodyTextToMbxFile` / `BreakoutBodyToFile` | ja | belegt |
| `DownloadMultipartBody` ohne Untertyp (:2966) | `AppendBodyTextToMbxFile` | ja | belegt |
| `HandleMultipartAlternative` | `AppendBodyTextToMbxFile`, `BreakoutBodyToFile` (:3368-3415) | ja. Die Funktion gibt nach der Auswahl **immer** TRUE zurück (:3428), es gibt also keinen Rückfall auf `DownloadAllParts` und kein zweites Laden derselben Teile | belegt |
| `HandleAppleDouble` | `BreakoutBodyToFile` (:3522) | ja | belegt |
| `ContentIdOfSection` → `FetchMIMEHeader` (:5336) | Kopf eines eingebetteten Teils | nein, und **richtig so**: Scheitert er, geht es über `BreakoutBodyToFile` weiter (:3719-3730), und dessen Abruf ist erfasst | belegt |
| `DownloadSubMessage` → `UIDFetchRFC822Header` (:4000) | Kopf einer eingebetteten Mail | **nein, K1** | belegt |
| `DownloadSingleMessageFully` (`bDownloadFully`) | `UIDFetchMessage`, ganze Mail | nicht nötig: der Weg bricht vor jedem Teilabruf ab (:900, :913), hat sein eigenes `E_FAIL`, und der Zweig :1092 läuft nur für `!bDownloadFully` | belegt |
| eine Teilfunktion bricht an `!IsSelected()` ab (:2861, :2941, :3042, :3204, :3549, :3709, :3832) | kein Abruf | nein. Dem geht aber in der Regel ein gescheiterter, erfasster Abruf voraus. Ausnahme: der Abbruch wird zuerst in `FetchMIMEHeader` oder `UIDFetchRFC822Header` bemerkt | belegt, ob `IsSelected` nach einem Abbruch sofort falsch ist: Vermutung |
| `CreateAttachFile`, `OpenEmbeddedFile`, `WriteBodyPartPlaceHolder` scheitern lokal | kein Abruf | nein. `DownloadAllParts` bricht ab (:3178), die Mail gilt als geladen, die Teile danach fehlen. Gleiches Bild wie K1, Ursache aber die eigene Platte | belegt, selten |

**Normales Öffnen einer mehrteiligen Mail mit verweigertem Teil (belegt, Ablauf):**

- `CImapMailbox::DownloadSingleMessage` übernimmt die Zusammenfassung bei `S_OK` (ImapMailbox.cpp:1263-1273). Offset und Länge zeigen jetzt auf den gerade geschriebenen Stand, `IMFLAGS_NOT_DOWNLOADED` bleibt. Die Mail zeigt Kopf und das, was angekommen ist. Eine Fehlermeldung gibt es nicht, nur die Spurzeile. Ob die IMAP-Schicht das `NO` des Servers selbst anzeigt, habe ich nicht verfolgt (Vermutung: nein).
- **Nachladen:** keine Endlosschleife gefunden (Vermutung, gesucht in allen Lesern von `IsNotIMAPDownloadedAtAll`). Aber jedes Anzeigen holt neu, siehe K3.
- **Doppelte Inhalte in der `.mbx`:** ja, je Abruf eine ganze Kopie. Abgeschnitten wird nur bei `E_FAIL` (:1068-1075), hier ist es `S_OK`. Die alten Kopien bleiben als toter Platz in der Datei. Offset und Länge zeigen immer auf die letzte, das ist richtig.

**`WriteBodyPartPlaceHolder` (belegt).** Der Zweig :3639-3647 setzt das Merkzeichen nicht. Die Sicherheit bleibt trotzdem: `m_nUndownloadedAttachments` wird erhöht, also ist `IsNotFullyIMAPDownloaded()` wahr (summary.h:432), und `HasAttachment()` ist wahr (`m_bHasAttachment`, :3679). Zwischen Konten geht die Mail deshalb über `AppendMessageAcrossRemotes` (Rohtext vom Server), nach lokal wird mit Anhängen nachgeladen (ImapActionQueue.cpp:2431).

**Zwischen Konten mit Anhang, `AppendMessageAcrossRemotes` (belegt):**

- Ist mindestens ein Anhang angekommen, ist `MSF_HAS_ATTACHMENT` gesetzt (:1109-1112). Dann wird der Rohtext vom Server hochgeladen (ImapToc.cpp:1285), unabhängig vom lokalen Ladestand. Verweigert der Server auch `BODY[]`, scheitert das `APPEND`, und die Quelle bleibt. Richtig.
- Sind alle Anhänge gescheitert, fehlt `MSF_HAS_ATTACHMENT` (gelöscht bei :848, nie gesetzt). Dann greift `!HasAttachment() && IsNotFullyIMAPDownloaded()` (ImapActionQueue.cpp:2158), und es wird gar nicht hochgeladen. Sicher, aber übervorsichtig: der Rohtext vom Server wäre vielleicht zu haben. Die Mail bleibt in der Quelle, ohne Meldung an den Anwender ([PRUEFER-94 K7](PRUEFER-94.md#k7)).

## 2. PRUEFER-94 K2: Nachkopieren nach lokal (`a6062c28`)

**Was sich ändert (belegt).** `CImapToLocalTransferMsgAction::DoPostProcessing` (ImapActionQueue.cpp:2427-2428) lädt und kopiert jetzt auch dann, wenn die Mail inzwischen ganz geladen ist, im Ziel aber noch eine markierte Vorab-Kopie mit ihrer Nummer liegt. `E184FindeVorabKopie` (ImapToc.cpp:1809-1822) sucht nur, sie löscht das Merkzeichen nicht. Die anschließende Suche in `ImapCopyMsgFromImapToLocal` (:1212) findet also dieselbe Kopie wieder. Das stimmt.

**Kann eine ganz geladene Mail doppelt nach lokal kommen?**

| Lage | Folge | Kennzeichnung |
|---|---|---|
| beim Verschieben schon ganz geladen | `Xfer` kopiert den ganzen Text und markiert **nicht** (tocdoc.cpp:3013). Die Bedingung ist falsch, es wird nichts nachkopiert | belegt |
| beim Verschieben nur Kopf, danach ganz geladen | die eigene Vorab-Kopie wird gefunden und überschrieben. Richtig, das ist die Behebung | belegt |
| ganz geladen, im Ziel liegt eine **fremde** markierte Kopie mit derselben Nummer | **doppelt, K4** | belegt, Lage Vermutung |

## 3. Prüfstand und Test

**Gemessen in meinem Baum:**

| Probe | Ergebnis | Erwartung |
|---|---|---|
| Stand wie eingecheckt, Bau und Lauf | 409/409 | grün |
| Positivprobe G1: Zurücksetzen `m_bE188TeilFehlt = FALSE;` in `DownloadSingleMessage` entfernt (1 Treffer) | **1 rot** | rot, passt |
| Gegenprobe G2: nach dem `if (m_bE188TeilFehlt) … else …` zusätzlich `pSum->m_Imflags &= ~IMFLAGS_NOT_DOWNLOADED;` ohne Bedingung (1 Treffer) | **409/409 grün** | rot: die Mail gilt wieder als geladen, [PRUEFER-94](PRUEFER-94.md#pruefer-94) K1 wieder offen |

Beide Male mit Perl `:raw` geändert, Treffer gezählt, aus der Sicherung im Scratchpad zurückgeholt, mit `cmp` geprüft: byte-gleich. `git status` danach leer.

**Prüfserver (gemessen, Port 1193, `--bodystructure --mehrteilig --fetch-text-scheitert`).** `BODYSTRUCTURE` meldet `multipart/alternative` mit `TEXT/PLAIN` und `TEXT/HTML`. Der Kopf kommt, `BODY.PEEK[2]`, `BODY.PEEK[1.MIME]` und `BODY.PEEK[]` bekommen `NO`. Die Fälle `E-188tm`/`E-188fm` messen also genau den Weg über `HandleMultipartAlternative` → `AppendBodyTextToMbxFile`, mit **allen** Teilen verweigert. Das ist der häufigste Fall und der richtige. Nicht gemessen sind: ein Anhang (`BreakoutBodyToFile`), ein eingebetteter Teil (`multipart/related`), eine eingebettete Mail (K1), ein einzelner verweigerter Teil neben gelungenen, und ein Konto mit „Minimal headers only“ aus (K2; `messen-e188.ps1` fährt mit `IMAPMinDownload=1`). Siehe K6.

**`tools/haken-pr-lektor.pl` (#219).** Selbsttest gemessen: 24 Fälle, 0 rot. Zwei Randfälle selbst gemessen mit `eingereichter_zweig`: `--title "Schalter -H fehlt" --head e188_x` ergibt Zweig `fehlt`, und `--head owner:e188_x` ergibt `owner:e188_x`. Beide liegen in keinem Arbeitsbaum, also hält der Haken auf. Das ist die sichere Richtung, aber die Meldung nennt dann einen falschen Zweig (T1).

## Funde

### <a id="k1"></a>K1 (kritisch, belegt; selten): eine eingebettete Mail (`message/rfc822`) setzt das Merkzeichen nicht

- **Wo:** ImapDownload.cpp:4000. `UIDFetchRFC822Header` scheitert, `DownloadSubMessage` gibt FALSE zurück, ohne `m_bE188TeilFehlt` zu setzen. `DownloadAllParts` bricht ab (:3178), alle Teile danach werden nicht geholt.
- **Folge:** Die Mail gilt als ganz geladen. Ist vorher kein Anhang angekommen, wird zwischen Konten nur der lokale Text hochgeladen (`AppendMessageFromLocal`), ohne die weitergeleitete Mail und ohne alle Teile dahinter, und die Quelle wird gelöscht. Nach lokal genauso. Das Bild von [PRUEFER-94](PRUEFER-94.md#pruefer-94) K1.
- **Wie oft:** Es braucht ein `NO` oder einen Abbruch genau beim Kopf des eingebetteten Teils. Betroffen sind „als Anhang weiterleiten“ und Unzustellbarkeitsberichte (`multipart/report` mit `message/rfc822`). Ob strenge Server `BODY[n.HEADER]` für `message/delivery-status` mit `NO` beantworten, ist eine Vermutung. Dann wäre ein solcher Bericht mit der Behebung **dauerhaft** ungeladen (K3).
- **Vorschlag:** in `DownloadSingleMessage` bei :974 statt nur auf `S_OK` zu achten: `if (!DownloadMultipartBody(...)) m_bE188TeilFehlt = TRUE;`. Das fängt jede Abrufstelle im Baum und auch die lokalen Fehler aus §1, denn `DownloadAllParts` gibt bei jedem gescheiterten Teil FALSE zurück. `HandleMultipartAlternative` gibt immer TRUE zurück, dort tragen die vier Stellen weiter. Danach in `TestE188.cpp` die Zählung `== 4` durch eine Prüfung dieser Zeile ersetzen; mit `== 4` würde jede fünfte Stelle rot.

### <a id="k2"></a>K2 (kritisch, belegt; Weg nur bei abgeschaltetem „Minimal headers only“): der Abruf mit ganzer Nachricht löscht das Merkzeichen selbst

- **Wo:** ImapChecker.cpp:1022-1027 (`DownloadRemainingMessagesMT`) und ImapMailbox.cpp:2663-2668 (`DownloadRemainingMessages`). Nach `SUCCEEDED(hResult)` steht dort `pImapSum->m_Imflags &= ~IMFLAGS_NOT_DOWNLOADED;` ohne Bedingung. Der Kommentar nebenan (ImapChecker.cpp:1130, ImapMailbox.cpp:2925) sagt selbst: *„Only the CImapDownloader can set IMFLAGS_NOT_DOWNLOADED“*.
- **Folge:** Bei Konten mit `IMAPMinDownload=0` gilt eine neue HTML-Mail mit verweigertem Teil nach dem Abruf als ganz geladen. Der Verlustweg aus [PRUEFER-94](PRUEFER-94.md#pruefer-94) K1 ist dort offen. `HandlePostFetch` (:1528) hat die Zeile nicht, der Hintergrundabruf ist also erfasst.
- **Wie oft:** Die Voreinstellung ist „minimal“ (`IMAPMinDownload\n1`, EudoraRes.rc:10335). `DownloadRemainingMessagesMT` lädt ganz nur im Hauptthread (:1005), `DownloadRemainingMessages` wird nur unter `EscapePressed()` aufgerufen (ImapMailbox.cpp:2465). Wann der Abruf im Hauptthread läuft, ist eine Vermutung.
- **Vorschlag, mit Vorsicht:** Die beiden Zeilen streichen genügt **nicht**. Dieser Weg lädt in die temporäre `.mbx`, und `CopyTextFromTmpMbx` überträgt den Text nur bei geladenen Mails (ImapMailbox.cpp:7763). Eine Mail mit stehendem Merkzeichen behielte also einen Offset in die temporäre Datei. Entweder dort auch bei `IsNotIMAPDownloadedAtAll()` kopieren, wenn `m_Length > 0`, oder in den beiden Aufrufern bei stehendem Merkzeichen Offset und Länge auf 0 setzen. Danach einen Prüfstandfall mit `IMAPMinDownload=0` ergänzen.

### <a id="k3"></a>K3 (mittel, belegt): dauerhaft unvollständige Mail wird bei jedem Anzeigen neu geholt

- **Wo:** `CSummary::Display` holt vor dem Öffnen (summary.cpp:842 → :3607), dann holt `CMessageDoc::GetFullMessage` noch einmal, weil die Mail „nicht geladen“ ist (msgdoc.cpp:203 leert den Zwischenspeicher, :228 holt neu). Jeder weitere `GetFullMessage`-Aufruf (38 Aufrufer: Vorschau, Trident-Ansicht, Antworten, Filter auf den Rumpf) holt wieder.
- **Folge, je Abruf:** eine ganze Kopie der Mail mehr in der `.mbx`, ohne dass `m_DelSpace` davon weiß; jeder geladene Anhang als neue Datei, denn `CreateAttachFile` vergibt einen neuen Namen (ImapDownload.cpp:4165-4177); `m_nUndownloadedAttachments` wächst um jeden Platzhalter, weil es in `CopyFromCSummary` übernommen und nie zurückgesetzt wird (ImapSum.cpp:311, ImapDownload.cpp:3646). Beim Löschen der Mail räumt `ImapRemoveAttachments` die Dateien nicht weg, weil die Mail „nicht geladen“ ist (ImapToc.cpp:4827). Die Suche indiziert sie nicht (X1EmailScanner.cpp:2340).
- **Wann:** nur, wenn der Server einen Teil **jedes Mal** verweigert, etwa bei einem kaputten Teil, oder beim Prüfserver mit `--mehrteilig`. Bei einem einmaligen Abbruch heilt das nächste Öffnen die Mail. Vorher galt eine solche Mail einmal als geladen.
- **Vorschlag:** Gregor entscheiden lassen. Entweder so lassen, Verlust ist schlimmer als doppelte Abrufe. Oder wie in [PRUEFER-94 K1](PRUEFER-94.md#k1) zuerst vorgeschlagen: ein eigenes Merkzeichen „Rumpf unvollständig“, das nur die Löschschranke liest (ImapActionQueue.cpp:2158, :2427), und `IMFLAGS_NOT_DOWNLOADED` normal löschen. Dann wird nicht bei jedem Anzeigen neu geholt, und K2 erledigt sich mit.

### <a id="k4"></a>K4 (gering, belegt; Lage Vermutung): die Behebung von PRUEFER-94 K2 trifft auch eine fremde liegengebliebene Vorab-Kopie

- **Wo:** ImapActionQueue.cpp:2428. Die Bedingung prüft nur die Nummer und das Merkzeichen, nicht, ob die Kopie zu dieser Mail gehört.
- **Folge:** Liegt im lokalen Ziel eine markierte Kopf-Kopie einer **anderen** Mail mit derselben Nummer, wird auch eine ganz geladene Mail nachkopiert. `ImapCopyMsgFromImapToLocal` schreibt ihren Text unter den fremden Eintrag (Betreff und Absender der anderen Mail). Die Mail steht danach zweimal im Ziel, einmal unter falschem Betreff. Kein Verlust auf dem Server. Zwei Lagen: der liegengebliebene Eintrag aus [PRUEFER-94 K3](PRUEFER-94.md#k3), oder zwei Mails mit gleicher Nummer aus verschiedenen Ordnern werden kurz nacheinander ins selbe lokale Postfach verschoben, die ganz geladene zuerst, die andere bevor die Warteschlange die erste abarbeitet. Vor `a6062c28` traf das nur nicht ganz geladene Mails.
- **Vorschlag:** Die Vorab-Kopie trägt `Copy(Sum)` der Quelle (tocdoc.cpp:3000). Ein Vergleich von `m_Seconds` und `m_Subject` zusätzlich zur Nummer, in `E184FindeVorabKopie` oder einer Schwester für den Weg nach lokal, macht den Treffer eindeutig genug.

### <a id="k5"></a>K5 (gering, gemessen): der Test sieht ein zusätzliches Löschen des Merkzeichens nicht

- Mit `pSum->m_Imflags &= ~IMFLAGS_NOT_DOWNLOADED;` ohne Bedingung nach dem `if/else` bleibt die Suite 409/409 grün (G2). Der Test prüft nur, dass die drei Zeichenketten vorkommen.
- **Vorschlag:** Im Abschnitt von `DownloadSingleMessage` zählen: `QT_Zaehle(pDs, "&= ~IMFLAGS_NOT_DOWNLOADED;") == 1`. Und die Zählung der Abrufstellen nach K1 umbauen.

### <a id="k6"></a>K6 (gering, gemessen am Prüfserver): `E-188tm`/`E-188fm` messen nur „alle Teile einer HTML-Mail verweigert“

- Der Prüfserver kennt nur `multipart/alternative` mit zwei Textteilen, und `--fetch-text-scheitert` verweigert jeden Teil. Ungemessen bleiben: Anhang, eingebetteter Teil, eingebettete Mail (K1), ein einzelner verweigerter Teil neben gelungenen, `IMAPMinDownload=0` (K2).
- **Vorschlag:** `--mehrteilig mixed` mit einem `application/octet-stream`-Teil und einem `message/rfc822`-Teil, und ein Schalter, der nur einen bestimmten Abschnitt verweigert (etwa `--fetch-teil-scheitert 2`). Damit wären K1 erst rot, dann grün nachzustellen.

### Hinweise (halten nichts auf)

- **T1:** `haken-pr-lektor.pl` liest `-H` auch in einem Titel in Anführungszeichen, und `--head owner:zweig` findet keinen Baum. Gemessen. Beides hält auf, die Meldung nennt aber einen falschen Zweig.
- **T2:** Eine unvollständig geladene Mail zeigt dem Anwender nicht, dass etwas fehlt. Es gibt nur die Spurzeile (ImapDownload.cpp:1094-1096).
- **T3:** `E184FindeVorabKopie` läuft für jede verschobene Mail einmal durch das ganze Ziel (ImapActionQueue.cpp:2428), bei großen lokalen Postfächern und vielen Mails spürbar. Vermutung, nicht gemessen.

| Fund | Was passiert | Schwere | Hält den Merge auf? |
|---|---|---|---|
| K1 | Mail mit eingebetteter Mail (weitergeleitet als Anhang, Unzustellbarkeitsbericht): scheitert deren Kopf, gilt die Mail als geladen, der Rest fehlt, die Quelle wird beim Verschieben gelöscht | kritisch (selten) | nein, keine Verschlechterung; eine Zeile, gehört in diesen Zweig |
| K2 | Bei „Minimal headers only“ aus löscht der Abruf das neue Merkzeichen wieder, der Verlustweg aus [PRUEFER-94](PRUEFER-94.md#pruefer-94) K1 bleibt dort offen | kritisch (selten, Einstellung) | nein, keine Verschlechterung; Behebung braucht die temporäre `.mbx` mit |
| K3 | Dauerhaft verweigerter Teil: bei jedem Anzeigen neu geholt, `.mbx` wächst, Anhänge doppelt im Anhangverzeichnis | mittel | nein, aber vor dem Paket von Gregor entscheiden lassen |
| K4 | Behebung von [PRUEFER-94](PRUEFER-94.md#pruefer-94) K2 trifft eine fremde Vorab-Kopie mit gleicher Nummer: Mail doppelt, einmal unter falschem Betreff | gering | nein |
| K5 | Test blind für ein zusätzliches Löschen des Merkzeichens | gering | nein |
| K6 | Prüfstand misst nur „alle Teile einer HTML-Mail verweigert“ | gering | nein |
| T1-T3 | Hinweise | sehr gering | nein |
