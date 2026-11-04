# <a id="pruefer-97"></a>PRUEFER-97

Nachtrag zu [PRUEFER-96](PRUEFER-96.md#pruefer-96). Zweig wt/pruefer-20261104d, abgezweigt von `origin/e188_loeschschranke`, Stand `ca187c47`. Seit `0b5124b4` kamen unter `Eudora71/` und `tools/` zwei Commits dazu: `43e265eb` (Behebung von [PRUEFER-96 K1](PRUEFER-96.md#k1) bis [PRUEFER-96 K3](PRUEFER-96.md#k3)) und `8edd8654` (nur `tools/TESTLAEUFE.md` und das Prüfstandbuch). Geprüft habe ich nur `43e265eb`. Eudora habe ich weder gebaut noch gestartet, kein Fenster geöffnet, keinen Prüfstand angefasst. Die Testsuite habe ich in meinem Baum gebaut und gefahren. Den Prüfstand mit 10/10 am Bau 7.2.2.132+ea323d31* habe ich nicht selbst gemessen, er ist mir genannt worden.

## Ergebnis vorweg

Die Behebung ist richtig. Ein Unzustellbarkeitsbericht oder eine Lesebestätigung bleibt nicht mehr dauerhaft „nicht geladen“, wenn der Server den Kopf verweigert, den es dort gar nicht gibt. Eudora lädt den Inhalt dann trotzdem, und erst wenn **das** scheitert, gilt die Mail als unvollständig. Einen echten Verlust kann die Ausnahme nicht verdecken. Sie greift nur bei Teilen, die keine eingebettete Mail sind. Für diese Teile holt der nächste Schritt den ganzen Inhalt, und dessen Scheitern wird gezählt. Die Testsuite läuft mit **409/409**. Das Zurücknehmen jeder der drei Änderungen macht den Test rot.

Zwei kleine Dinge habe ich gefunden, beide gering:

- **Scheitert etwas in einer weitergeleiteten Mail, fehlen jetzt auch die Teile dahinter in der Anzeige (K1, belegt).** Weil das Scheitern jetzt nach oben gemeldet wird, bricht die äußere Mail an dieser Stelle ab, so wie sie es auf der obersten Ebene schon immer tat. Die Mail bleibt „nicht geladen“ und wird beim nächsten Öffnen neu geholt. Verloren geht nichts.
- **Der Test sieht den Text, nicht die Wirkung (K2, gemessen).** Steht die neue Ausnahme hinter dem `return`, oder schluckt eine zusätzliche Zeile jeden Fehler, bleibt der Test grün. Drei weitere Schreibweisen des Löschens rutschen ebenfalls durch.

**Kein Fund hält den Merge auf.** Neue Kennungen habe ich nicht vergeben, alle Funde setzen [E-188](../Intern/BEFUNDE.md#e-188) fort. E-228 und E-229 bleiben frei.

## 1. K1 von PRUEFER-96: ein verweigerter Kopf ohne eingebettete Mail

**Was die Ausnahme erfasst (belegt).** Der Parser legt `nested.msg` nur für `message/rfc822` an, und dann immer mit `body` (Imapdll/src/proto.cpp:4879-4885). Die Bedingung `!(pBody->nested.msg && (pBody->nested.msg)->body)` (ImapDownload.cpp:4037) heißt also „jeder `message/…`-Teil außer `message/rfc822`“: `delivery-status`, `disposition-notification`, auch `message/global`. Für eine echte eingebettete Mail zählt ein verweigerter Kopf weiter: `return FALSE` (:4040-4041), und das `else` in `DownloadSingleMessage` setzt das Merkzeichen (:983).

**Geht es danach richtig weiter? (belegt)**

| Schritt | Stelle | bei verweigertem Kopf |
|---|---|---|
| Kopfbeschreibung zurück | `m_pHd = pOldHeaderDesc` (:4028) | läuft schon **vor** der Ausnahme, ist also wiederhergestellt |
| `m_isMHTML` übernehmen | :4019-4022 | entfällt. Ohne Kopf gibt es nichts zu übernehmen |
| Puffer schreiben | `m_mbxFile.Flush()` (:4044) | läuft wie beim Erfolg |
| Disposition | :4054-4059 | läuft wie beim Erfolg, die Quelle ist `pBody`, nicht der Kopf |
| Inhalt holen | `AppendBodyTextToMbxFile` (:4120), weil `nested.msg` fehlt | läuft, und bei Scheitern wird es gemerkt (:3941) **und** FALSE gemeldet |

Vor dem Abruf wurde `DownloadingHeader()` gerufen. Bei einem `NO` kommen keine Daten an, also landet nichts halb im Kopfzustand. Danach schaltet `DownloadingBody()` (:4062) zurück. Bricht die Verbindung ab statt `NO`, scheitert auch `AppendBodyTextToMbxFile`, und das zählt. Diese beiden Sätze sind belegt. Dass ein Server-`NO` nie einen Teil der Daten liefert, ist eine Vermutung und folgt aus RFC 3501.

**Kann `bResult = TRUE` einen Verlust verdecken? (belegt: nein)** Die Ausnahme greift nur, wenn danach `AppendBodyTextToMbxFile` den **ganzen** Teil holt, also `BODY[n]`. Fehlt dabei etwas, setzt die Funktion das Merkzeichen selbst. Für `message/rfc822` ohne geparsten Rumpf (geht nach proto.cpp:4885 nicht) enthielte `BODY[n]` sogar den Kopf mit. Gegenüber dem Original ist das sogar eine Verbesserung. Dort brach `DownloadAllParts` beim verweigerten Kopf ab (:3194), und der angehängte Originaltext fehlte ohne Meldung.

## 2. K2 von PRUEFER-96: das Ergebnis der eingebetteten Teile zählt

**Aufrufer (belegt).** Alle Aufrufe von `DownloadSimpleBody`, `DownloadMultipartBody` und `DownloadSubMessage` werten jetzt ihr Ergebnis aus (grep über EuImap/src). Eine Ausnahme ist `HandleMultipartAlternative`. Die Funktion gibt immer TRUE zurück (:3442), auch wenn ihr gewählter Teil eine eingebettete Mail oder ein `multipart` war (:3400, :3417). Das stand so schon im Original und wird von `43e265eb` nicht berührt, siehe Hinweis T1.

**Neue Fälle, in denen eine Mail jetzt „nicht geladen“ bleibt (belegt).** Neu ist nur, was über den Rückgabewert läuft und keine der vier markierten Abrufstellen ist:

| Ursache in der eingebetteten Mail | vorher | jetzt | richtig? |
|---|---|---|---|
| ein Blatt scheitert (`NO`, Abbruch) | schon „nicht geladen“ über `m_bE188TeilFehlt` | dazu Abbruch der äußeren Schleife | ja, siehe K1 |
| Kopf einer weiteren `message/rfc822` darin | als geladen, Kopf fehlte | „nicht geladen“ | ja |
| lokal: `CreateAttachFile`/`OpenLocalAttachFile`, Platzhalter schreiben | als geladen, Anhang fehlte | „nicht geladen“ | ja, wie auf der obersten Ebene ([PRUEFER-96](PRUEFER-96.md#pruefer-96) §1) |
| Anhang absichtlich nicht geladen (Platzhalter), MIME-Tabelle löscht, `.vcf` gelöscht | geladen | geladen (`bResult = TRUE`, :3586; `WriteBodyPartPlaceHolder` gibt TRUE) | ja |
| `multipart` ohne Teile | geladen | „nicht geladen“ (`DownloadAllParts` beginnt mit FALSE) | falsch, aber nur bei kaputter `BODYSTRUCTURE`, siehe Hinweis T2 |

Eine sonst lesbare Mail bleibt also nur im letzten Fall falsch „nicht geladen“. Das ist [PRUEFER-96](PRUEFER-96.md#pruefer-96) T2, jetzt auch eine Ebene tiefer. Ob ein Server so etwas schickt, ist eine Vermutung.

## 3. Test

Gemessen in meinem Baum. Ich habe die Quelle mit Perl `:raw` geändert und die Treffer gezählt. Danach habe ich sie aus der Sicherung im Scratchpad zurückgeholt und mit `cmp` byte-gleich geprüft. `git status` war danach leer. Die Läufe ohne Bau sind gültig, weil der Test die Quelle zur Laufzeit liest. Jeder rote Lauf meldete genau `[FEHL] E-188: Quelle wird nur geloescht, wenn die Mail im Ziel angekommen ist`.

| Probe | Datei | Treffer | Ergebnis | Erwartung |
|---|---|---|---|---|
| Stand wie eingecheckt, Bau und Lauf | – | – | 409/409 | grün |
| P1: Ausnahme (K1) entfernt | ImapDownload.cpp | 1 | **1 rot** | rot, passt |
| P2: `bResult =` vor `DownloadSimpleBody` entfernt | ImapDownload.cpp | 1 | **1 rot** | rot, passt |
| P3: `bResult =` vor `DownloadMultipartBody` entfernt | ImapDownload.cpp | 1 | **1 rot** | rot, passt |
| P4: Ausnahme hinter `if (!bResult) return FALSE;` verschoben (wirkungslos) | ImapDownload.cpp | 1 | 409/409 grün | rot, siehe K2 |
| P5: Ausnahme steht, dahinter zusätzlich `bResult = TRUE;` (schluckt auch den Kopf einer echten eingebetteten Mail) | ImapDownload.cpp | 1 | 409/409 grün | rot, siehe K2 |
| G1-G4: `&= ~IMFLAGS_…`, `&= ~(IMFLAGS_…)`, `&=~(IMFLAGS_…)`, `&=~IMFLAGS_…` eingesetzt | ImapMailbox.cpp | je 1 | **je 1 rot** | rot, passt (K3 von [PRUEFER-96](PRUEFER-96.md#pruefer-96) behoben) |
| G5: `&= ~ IMFLAGS_NOT_DOWNLOADED;` | ImapMailbox.cpp | 1 | 409/409 grün | rot, siehe K2 |
| G6: `&= (~IMFLAGS_NOT_DOWNLOADED);` | ImapMailbox.cpp | 1 | 409/409 grün | rot, siehe K2 |
| G7: `= pImapSum->m_Imflags & ~IMFLAGS_NOT_DOWNLOADED;` | ImapMailbox.cpp | 1 | 409/409 grün | rot, siehe K2 |

## Funde

### <a id="k1"></a>K1 (gering, belegt): scheitert etwas in einer eingebetteten Mail, fehlen auch die Teile dahinter

- **Wo:** `DownloadAllParts` bricht die Schleife ab, sobald ein Teil FALSE meldet (ImapDownload.cpp:3193-3194). Bisher meldete `DownloadSubMessage` bei einer eingebetteten Mail mit `multipart`- oder einfachem Rumpf immer TRUE. Seit `43e265eb` meldet sie das Ergebnis ihres Rumpfs (:4102, :4113).
- **Folge:** Ein Beispiel ist eine weitergeleitete Mail als Anhang, in der ein Anhang nicht geholt werden kann. Bisher zeigte Eudora die Teile der äußeren Mail dahinter trotzdem an. Jetzt fehlen sie in dieser Ladung. Die Mail ist „nicht geladen“ (das war sie über `m_bE188TeilFehlt` schon vorher) und wird beim nächsten Öffnen neu geholt ([PRUEFER-95 K3](PRUEFER-95.md#k3)). Auf der obersten Ebene verhält sich Eudora seit dem Original so. Neu ist nur, dass es jetzt in jeder Tiefe gleich ist. Bei einem Fehler, der sich jedes Mal wiederholt (z. B. eine lokale Dateianlage scheitert immer), sieht der Anwender die Teile dahinter nie. Wie oft das vorkommt, ist eine Vermutung: selten.
- **Einschätzung:** Das passt zu Gregors Entscheidung „Sicherheit vor Platz“, es geht nichts verloren. Vorschlag: nichts ändern, nur im Release-Text oder in der FAQ nicht behaupten, dass die übrigen Teile angezeigt werden.

### <a id="k2"></a>K2 (gering, gemessen): der Test prüft Text, nicht Lage und Wirkung

- Die K1-Prüfung sucht die Zeile irgendwo in `DownloadSubMessage`. Steht sie wirkungslos hinter dem `return` (P4) oder kommt ein pauschales `bResult = TRUE;` dazu (P5), bleibt der Test grün. P5 würde den Kopf einer echten weitergeleiteten Mail stillschweigend verlieren. Das wäre genau der Verlust, den [PRUEFER-96 K1](PRUEFER-96.md#k1) ausschließen wollte.
- Die Löschprüfung hat jetzt vier Schreibweisen (G1-G4 rot), übersieht aber `&= ~ IMFLAGS_…`, `&= (~IMFLAGS_…)` und `x = x & ~IMFLAGS_…` (G5-G7 grün). Weiter verbietet sie das Löschen in der ganzen Datei. Das ist die zweite Hälfte von [PRUEFER-96 K3](PRUEFER-96.md#k3), und sie ist weiter offen.
- **Vorschlag:** In `DownloadSubMessage` die Folge prüfen: `QT_Stelle` der Ausnahme < `QT_Stelle` von `if (!bResult) return FALSE;`, und zwischen dem Kopfabruf und `return FALSE;` kein weiteres `bResult = TRUE;`. Für das Löschen im Abschnitt der beiden Funktionen nach `IMFLAGS_NOT_DOWNLOADED` überhaupt suchen, ohne Operator. Dann fällt jede Schreibweise auf.

### Hinweise (halten nichts auf)

- **T1:** `HandleMultipartAlternative` gibt immer TRUE zurück (ImapDownload.cpp:3442). Scheitert in einem `multipart/alternative` der Kopf einer eingebetteten Mail oder ein lokaler Schritt in einem verschachtelten `multipart`, gilt die Mail als geladen. Die Blätter darin sind über `m_bE188TeilFehlt` erfasst. Das steht so im Original und ist sehr selten (der Quelltext selbst sagt „Shouldn't really have this!!“, :3388).
- **T2:** Ein `multipart` ohne Teile lässt die Mail dauerhaft „nicht geladen“, seit `43e265eb` auch in einer eingebetteten Mail ([PRUEFER-96](PRUEFER-96.md#pruefer-96) T2). Dazu müsste der Server eine kaputte `BODYSTRUCTURE` schicken. Das ist eine Vermutung.

| Fund | Was passiert | Schwere | Hält den Merge auf? |
|---|---|---|---|
| K1 | scheitert etwas in einer weitergeleiteten Mail, fehlen in dieser Ladung auch die Teile dahinter. Die Mail bleibt „nicht geladen“ und wird neu geholt | gering | nein, kein Verlust, passt zu „Sicherheit vor Platz“ |
| K2 | Test bleibt grün, wenn die Ausnahme wirkungslos verschoben oder jeder Kopffehler geschluckt wird, und bei drei weiteren Schreibweisen des Löschens | gering | nein |
| T1, T2 | `multipart/alternative` schluckt Fehler (Original). Ein leeres `multipart` bleibt „nicht geladen“ | sehr gering | nein |
