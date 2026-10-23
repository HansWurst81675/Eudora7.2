# <a id="pruefer-45"></a>PRUEFER-45 — die E-125-Behebung nachgerechnet, 23.10.2026

**Auftrag.** Die am selben Tag gebaute Behebung zu
[E-125](../Intern/BEFUNDE.md#e-125) gegen die Quelle nachrechnen, mit acht
benannten Fragen — darunter ausdrücklich: *„Gibt es eine Änderung am
Produktivcode, die den Fehler wieder einbaut und trotzdem grün durchkommt?"*

**Ergebnis: neun Punkte, alle am Quelltext belegt, zwei zusätzlich gemessen.
Zwei davon trafen die Behebung selbst und sind noch am selben Tag behoben
worden.**

---

## Die zwei, die geholt haben

### <a id="k1"></a>K1 — Der Regressionstest ließ den ganzen Fehler durch

**Sicherheit: gemessen.** `Eudora71/Tests/TestE125.cpp` gegen
`Eudora71/Eudora/tocdoc.cpp`.

Die Behebung besteht aus zwei Teilen: Eudora zeigt den Hinweis **und steigt
dann aus** (`break`). Der Test prüfte den Hinweis — den Ausstieg nicht.

**Selbst gegengeprüft:** allein die Zeile `break;` gelöscht. Danach läuft der
Ablauf nach dem Hinweisdialog weiter in den `ToOut`-Zweig, `Sum->SendAgain`
legt wieder eine neue Nachricht in `Out` an, der Befund ist vollständig zurück
— und der Prüfstand meldete **277 von 277 bestanden**.

> Das ist die unangenehmste Art Fehler: die Gegenprobe war gefahren worden,
> aber gegen den **alten Stand** und gegen eine **zu weite Bedingung**, nicht
> gegen den fehlenden Ausstieg
> ([schranke-gegentesten](../Arbeitsweise/schranke-gegentesten.md),
> [pruefstand-kann-blind-sein](../Arbeitsweise/pruefstand-kann-blind-sein.md)).

**Behoben.** Der Test prüft jetzt zusätzlich
`AlertDialog(IDD_XFER_TO_OUT_REFUSED); break;` als Folge und die **Reihenfolge**
gegen `Sum->SendAgain(` — stünde die Ablehnung dahinter, wäre jede einzelne
gesuchte Zeichenkette noch zu finden und die Ablehnung trotzdem wirkungslos.
**Gegenprobe erneut gefahren: 276 von 277**, mit dem Satz *„auf den Hinweis
folgt kein break — Eudora laeuft weiter und legt wieder eine neue Nachricht in
Out an"*.

### <a id="k2"></a>K2 — Bei einer IMAP-Quelle kam weiterhin „No messages were transferred!"

**Sicherheit: am Quelltext belegt.** `tocdoc.cpp` (Ende von `CTocDoc::Xfer`)
→ `EuImap/src/ImapToc.cpp:855-859`.

Die Bedingung lautete

```c
if ( IsImapToc() || (TargetToc && TargetToc->IsImapToc()) && sumlist.GetCount() > 0 )
```

`&&` bindet stärker als `||`. Gelesen wird also *„Quelle ist IMAP **oder**
(Ziel ist IMAP **und** es gibt etwas zu tun)"*. Bei einer **IMAP-Quelle**
greift der Zweig damit auch mit **leerer** Liste, läuft über `ImapXfer` →
`ImapXferFromImapToLocal` und endet bei
`ErrorDialog(IDS_ERR_IMAP_NO_MSGS_XFERRED)`.

**Warum das zählt:** Gregors Meldung vom 16.10.2026 war *„mail aus OUTBOX in
Out verschoben"* — eine **IMAP-Quelle**. Die Behebung hätte ihm also den neuen
Hinweis gezeigt **und danach trotzdem die alte Fehlmeldung**. Halb behoben,
und zwar genau für den Weg, auf dem der Befund entstanden ist.

**Behoben** über den Merker `E125Abgelehnt`, der die IMAP-Nachbearbeitung
überspringt. **Gegenprobe gefahren: 276 von 277.**

**Der Vorrangfehler in der Klammerung bleibt stehen.** Ihn zu berichtigen
ändert Verhalten an einer alten Stelle für alle Übertragungen und gehört
abgestimmt, nicht nebenbei mit hinein.

---

## Die fünf, die als eigene Befunde zu führen sind

| | Was passiert | Sicherheit |
|---|---|---|
| <a id="k3"></a>**K3** | Aus dem **Suchfenster** (`SearchView.cpp:3837-3886`) und aus **Filtern** (`filtersd.cpp:1531`, `:1981`) wird `Xfer` **je Nachricht** gerufen. Zwanzig markierte Treffer nach `Out` ergeben **zwanzig modale Dialoge** nacheinander. Hat jemand einen Filter mit *„Transfer To: Out"*, erscheint der Dialog mitten im automatischen Abruf für jede passende Mail; `gbAutomationCall` wird an dieser Stelle nicht abgefragt | belegt |
| <a id="k4"></a>**K4** | **Gemischte Auswahl:** fünf Entwürfe, dann eine empfangene. Die fünf sind **vollständig** übertragen, der Dialog sagt trotzdem *„Messages can't be transferred"*. **Kein Datenverlust** — die Auskunft ist falsch, nicht der Zustand | belegt |
| <a id="k5"></a>**K5** | Auf dem **Filterweg** läuft `ASSERT(CopySum != NULL)` (`tocdoc.cpp:3082`) an und hält den Debug-Bau an; im Release ist die Zusicherung nichts, und `WriteSum(NULL)` steigt harmlos mit FALSE aus ([assert-ist-im-release-nichts](../Arbeitsweise/assert-ist-im-release-nichts.md)) | belegt |
| <a id="k6"></a>**K6** | Nach einer Ablehnung ist das **„Undo Transfer" der vorherigen** Übertragung verfallen: `ClearUndoFrom()` und `ClearUndoTo()` laufen **vor** der Schleife. Gegenüber dem alten Abbruchweg unverändert — aber es trifft jetzt jeden Versuch statt nur eine Absage | belegt |
| <a id="k7"></a>**K7** | Ein **Entwurf aus einem IMAP-Ordner** nach `Out`: `IsComp()` ist wahr, die Ablehnung greift nicht, `SendAgain` legt eine Kopie an, `SubtractSum` ist für IMAP ausgenommen — **Duplikat plus dieselbe Fehlmeldung**. Die Begründung im Kommentar (*„tut genau das, was es soll"*) gilt damit nur für lokale Quellpostfächer | belegt |

---

## Zwei weitere Löcher im Test — beide geschlossen

### <a id="k8"></a>K8 — Die Ressourcenkennung wurde nur auf Vorhandensein geprüft
Setzt der Ressourcen-Editor `_APS_NEXT_RESOURCE_VALUE` beim Speichern neu und
vergibt 8117 ein zweites Mal, zeigt `AlertDialog` den **falschen** Dialog — und
der Test bliebe grün. Jetzt wird `QT_Zaehle(pKopf, " 8117") == 1` geprüft.

### <a id="k9"></a>K9 — Die Textsuchen waren leerraumempfindlich
`QT_LeerraumZusammen` zieht Leerraum auf **ein** Leerzeichen zusammen, es
entfernt ihn nicht. `AlertDialog( IDD_STRIP_HEADERS )` wäre an der Nadel
`AlertDialog(IDD_STRIP_HEADERS)` vorbeigelaufen — **grün trotz altem Stand**.
Die Verneinung hängt jetzt am Bezeichner `IDD_STRIP_HEADERS` allein; im Code
steht er sonst nirgends, und der erklärende Kommentar ist zu diesem Zeitpunkt
schon weggeworfen.

---

## Die acht Fragen, kurz beantwortet

| | Frage | Antwort |
|---|---|---|
| 1 | Zustand nach dem frühen `break` | **in Ordnung** — bitgleich wie beim alten Abbruchweg: beide MBX geschlossen, beide TOCs geschrieben, `bXferActive` zurückgesetzt, `SetRedraw(TRUE)` nachgeholt. `Purging` kann hier nicht wahr sein |
| 2 | Mehrfachauswahl: ein Dialog oder zwanzig? | **einer** — aus dem Postfachfenster. Aus Suchfenster und Filtern N-mal (K3) |
| 3 | Gemischte Auswahl: Datenverlust? | **nein** bei lokalen Postfächern. Die schon übertragenen sind vollständig übertragen, nicht halb. Falsch ist die Auskunft (K4). Bei IMAP-Quelle Duplikate statt Verlusten (K7) |
| 4 | `Copy` nicht unterschieden — richtig? | **ja** — auch Kopieren liefe in denselben `SendAgain`-Zweig und erzeugte eine ungewollte Nachricht |
| 5 | `TargetToc->Name()` NULL oder kaputt? | **in Ordnung** — `TargetToc` wird 200 Zeilen vorher dereferenziert, `CString` ist immer nullterminiert. Mitgeprüft: der Dialogtext enthält kein `%`, `CAlertDialog` benutzt ihn als Formatzeichenkette |
| 6 | War 8117 frei? | **ja**, gemessen über den ganzen Baum. Die zwei weiteren Treffer stehen in einer OpenSSL-Primzahltabelle. Zur Eindeutigkeit auf Dauer: K8 |
| 7 | Dialogmaße, Abschneiden, Überdeckung? | **in Ordnung** — nachgerechnet: 8 DLU Rand, Text braucht drei von sechs möglichen Zeilen, Icon und Knopf liegen 61 DLU auseinander |
| 8 | Prüft der Test, was er behauptet? | **nein** — siehe K1, K8, K9. Alle drei geschlossen |

**Zwei Messungen am gebauten Stand, nicht nur an der Quelle**
([extrakt-ist-nicht-das-programm](../Arbeitsweise/extrakt-ist-nicht-das-programm.md)):
`Bin/Release/Eudora.exe` enthält die Spurmarke `E-125 Xfer nach Out abgelehnt`
und **nicht** mehr `Some headers may be removed`; `Bin/Release/EudoraRes.dll`
enthält den neuen Dialogtext als UTF-16. Diese Messung gehört als Schranke in
den **Paketlauf**, nicht in den Prüfstand.

---

**Nicht geprüft:** `TestE24.cpp`, `TestStartWege.cpp`, `TestZeichenWege.cpp`,
`UnderTestE24.*`, `UnderTestZ2.*`, `Extract.ps1` — der Schwerpunkt lag auf
[E-125](../Intern/BEFUNDE.md#e-125).
