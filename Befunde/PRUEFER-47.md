# <a id="pruefer-47"></a>PRUEFER-47 — die E-125-Gegenprobe am Prüfstand nachgerechnet, 23.10.2026

**Auftrag.** PR #155 (`git diff dd1d1f82..ed2b74c0 -- tools/`) gegen die
Quelle nachrechnen: das neue Messskript `tools/messen-e125.ps1`, den Schalter
`messen=` und die Quelle `messung` in `tools/pruefstand-lauf.ps1`, die Fälle
E-125a bis E-125c in `tools/pruefstand-faelle.txt` — und die Behauptung in
[E-125](../Intern/BEFUNDE.md#e-125) und
[TESTBERICHT-E125](../Intern/TESTBERICHT-E125.md): *„behoben in 7.2.0.122,
Gegenprobe gemessen, gegen 7.2.0.120 rot, gegen 7.2.0.122 acht von acht grün"*.
Sieben Fragen, jede mit Beleg.

**Ergebnis vorweg: das Urteil „behoben" ist gedeckt, und die Gegenprobe misst,
was sie messen soll.** Die Bedienung über das Menü *Transfer* endet im selben
`CTocDoc::Xfer` mit denselben Argumenten wie das Ziehen mit der Maus. Ein
grünes E-125a ist ohne die Sperre nicht zu haben: in den Dateien des Laufs
steht, dass der Entwurf durch den Zweig hinter der Sperre gegangen ist. **Kein
Fund hält ein Release auf.** Acht Funde: einer ist ein neuer Befund am
erlaubten Weg — **[E-144](../Intern/BEFUNDE.md#e-144)**, ein Entwurf verliert beim Zurückschieben nach `Out`
die Antwortbezüge, im Original genauso. Vier sind Lücken im Prüfstand, die
heute nichts verfälschen, aber den nächsten Fall verfälschen können. Drei sind
falsche Sätze im Bericht.

Gekennzeichnet ist jede Aussage: **gemessen** (an Dateien oder am Testlauf
von heute), **am Quelltext belegt** (Datei:Zeile), **Vermutung**.

---

## 1. Menüweg und Ziehen — dieselbe Prüfung?

**Ja. Beide Wege enden in `QCMailboxCommand::Execute(CA_TRANSFER_TO, <Quell-TOC>)`
und von dort im selben `Xfer`-Aufruf.** Am Quelltext belegt.

**Menüweg, wie ihn das Skript nimmt** (`PostMessage(WM_COMMAND, <id>)` an das
Hauptfenster):

1. `CWnd::OnCommand` fragt vor dem Weiterreichen den Update-UI-Zustand ab und
   verwirft einen abgeschalteten Befehl **stumm**
   (MFC `wincore.cpp:2765-2771`, *„make sure command has not become disabled
   before routing"*; die Warnung ist ein `TRACE`, im Release also nichts).
2. `CMainFrame::OnCmdMsg` (`mainfrm.cpp:3457`) → `QCWorkbook::OnCmdMsg` → aktives
   MDI-Kind. Ausnahme: ein Wazoo-Fenster mit Fokus bekommt den Befehl zuerst
   (`mainfrm.cpp:3462-3467`).
3. Update-UI: `CTocFrame::OnUpdateDynamicCommand` (`TocFrame.cpp:2499`) schaltet
   `CA_TRANSFER_TO` genau dann ein, wenn `GetSelCount() > 0` (`TocFrame.cpp:2528`).
4. Ausführung: `CTocFrame::OnDynamicCommand` (`TocFrame.cpp:2602`, über
   `ON_COMMAND_EX_RANGE` in `TocFrame.cpp:258`) → `pCommand->Execute(CA_TRANSFER_TO, pTocDoc)`
   (`TocFrame.cpp:2655`; mit gedrückter Umschalttaste `CA_COPY`, `:2653`).
5. `QCMailboxCommand::Execute` (`QCMailboxCommand.cpp:103-140`): Quelle ist das
   TOC, `pSrcSummary = NULL`; Ziel `Trash` → `Xfer(pTocDoc, NULL)`
   (`:138`), jedes andere Ziel → `Xfer(pTocDoc, NULL, TRUE, FALSE)` (`:140`).
   **Beides ist derselbe Aufruf**, die Vorgaben von `Xfer` sind
   `CloseWindow=TRUE, Copy=FALSE` (`tocdoc.cpp:2516-2517`).
6. In `Xfer`: Auswahl über `View->GetSelCount()` (`tocdoc.cpp:2527`) und
   `View->m_SumListBox.GetSel(i)` (`:2709`), dann die Sperre
   `if (ToOut && !Sum->IsComp())` (`:2753`).

**Ziehen mit der Maus** — zwei Ablageziele:

* auf ein Postfach in der Postfachliste: `mboxtree.cpp:1154-1176` →
  `p_itemdata->m_pCommand->Execute(CA_TRANSFER_TO, qcfTransfer.m_pSourceTocDoc)`;
* auf ein offenes Postfachfenster: `tocview.cpp:4895-4917` →
  `pFolder->Execute(CA_TRANSFER_TO, qcfTransfer.m_pSourceTocDoc)`.

Ab dort Schritt 5 und 6 wie oben. **Dieselbe Funktion, dieselben Argumente.**
Einziger Unterschied: zieht man eine **einzelne Nachricht aus ihrem
Nachrichtenfenster** („Abschleppwagen"), wird `m_pSingleSummary` übergeben
(`mboxtree.cpp:1170`, `tocview.cpp:4911`) — dann ist in `Xfer`
`SingleSum != NULL`. Die Sperre liegt **hinter** der Auswahlprüfung und gilt
für beide Formen (`tocdoc.cpp:2691-2753`). Die Spurmarke zeigt die Form an
(`einzeln=%d`). Gregors Lauf hatte `einzeln=0`, der Prüfstand ebenfalls.

**Was das Menü nicht trifft:** nichts, was für [E-125](../Intern/BEFUNDE.md#e-125) zählt. Der Satz im
Skriptkopf *„derselbe Weg wie das Ziehen"* stimmt — ab `Execute`.

## 2. Ist der Entwurf nach Out → Trash noch `IsComp()`? Sonderweg für Trash?

**Ja, er ist es, und Trash hat auf diesem Weg keinen Sonderzweig.** Am
Quelltext belegt, und an den Dateien des Laufs gemessen.

* `IsComp()` ist `m_State >= MS_UNSENDABLE && m_State != MS_RECOVERED`
  (`summary.h:276-277`, Werte `summary.h:69-81`: 5 bis 11 gelten als verfasst).
* Out → Trash geht über den Zweig `if (!ToOut)` (`tocdoc.cpp:2959-3002`):
  `CopySum->Copy(Sum)` übernimmt `m_State` (`summary.cpp:584`), und weil die
  Quelle `Out` ist, setzt `tocdoc.cpp:2999-3000` den Zustand **ausdrücklich** auf
  `MS_UNSENT` (9). Der Entwurf kommt also mit Zustand 9 in Trash an — verfasst.
* **Sonderbehandlung von Trash in `Xfer`**, vollständig abgesucht
  (`tocdoc.cpp:2516-3157`): nur zwei Stellen. `TargetToc == this` mit Trash
  heißt Endgültig-Löschen (`Purging`, `:2554-2557`), und die Warnung bei vielen
  Nachrichten gilt nur für Trash als **Ziel** (`:2567`). In
  `QCMailboxCommand::Execute` prüft `:137` den Typ des **Ziels**, nicht der
  Quelle. **Für Trash als Quelle gibt es keinen eigenen Zweig.**
* **Mit einem anderen lokalen Postfach wäre die Gegenprobe ebenso grün**: die
  Zustandsübernahme hängt an `Copy` und an `m_Type == MBT_OUT` der Quelle, nicht
  am Ziel. Am Quelltext belegt, nicht gefahren.
* **Gemessen, dass der Entwurf durch den Zweig hinter der Sperre ging:**
  `C:\Temp\E125\Mailverzeichnis\Out.mbx.001` ist die Sicherung, die Eudora beim
  Beenden vor dem Verdichten anlegt (Protokoll: *„Backed up … Out.mbx to
  Out.mbx.001"*). Darin stehen **zwei** Entwürfe: der gespeicherte mit
  `Message-Id: <7.2.0.122.2.20261023145429.061d52a8@127.0.0.1>` und ein zweiter
  mit **neuer** `Message-Id …145443…` und neuer `From `-Zeile. Nach dem
  Verdichten steht in `Out.mbx` nur noch der zweite. Neue Kennung heißt: Den
  Entwurf hat `Sum->SendAgain(FALSE)` neu angelegt (`tocdoc.cpp:3005`). Dieser
  Aufruf liegt im `ToOut`-Zweig **nach** der Sperre in derselben
  Schleifenrunde. Die Prüfung `ToOut && !Sum->IsComp()` wurde also
  ausgewertet und ergab *erlaubt*.

**Gegenvermutung:** *„ein beim Lesen neu aufgebautes Inhaltsverzeichnis macht
aus dem Entwurf eine empfangene Nachricht"* — **für diesen Lauf widerlegt,
für den Alltag bestätigt.** Wird ein Inhaltsverzeichnis **mit Abgleich**
wiederhergestellt, setzt `tocdoc.cpp:451-468` jede neu gefundene Nachricht
außerhalb von `Out` auf `MS_RECOVERED`. Das ist der einzige Zustand ab 5, den
`IsComp()` ausnimmt. Ein Entwurf in einem solchen Postfach wird danach
abgelehnt. Der Anwender behält ihn und kommt über *Send Again* weiter, es geht
also nichts verloren. Den Fall nennt aber weder der Testplan noch der Bericht.
Im Lauf war `Trash.toc` vorhanden (104 Byte, gemessen), der Fall trat nicht ein.

## 3. Kann die Gegenprobe grün sein, ohne dass die Sperre erreicht wird?

**Nein — aber nicht, weil das Skript es unterscheidet, sondern weil die
Zählung keinen anderen Weg zu `out=1 trash=0` lässt.** Am Quelltext belegt.

| Lage | Out | Trash | E-125a |
|---|---|---|---|
| übertragen (Sperre ausgewertet, erlaubt) | 1 | 0 | **grün** |
| abgelehnt (zu weite Sperre) | 0 | 1 | rot, dazu `dialoge-gegenprobe=1` |
| Befehl stumm verworfen (keine Auswahl → Update-UI aus, `wincore.cpp:2769`) | 0 | 1 | rot |
| falsche Menünummer, anderes Ziel | 0 | 0 | rot |
| Schritt 2 als Kopie (Umschalttaste gedrückt, `TocFrame.cpp:2652`) | 2 | 0 | rot |
| Entwurf doppelt gespeichert | 2 | 0 oder 1 | rot |

**`LB_SETSEL` ohne `LBN_SELCHANGE` zählt für Eudora als Auswahl** — am
Quelltext belegt, und nicht nur, weil `GetSel` den Zustand des Steuerelements
liest. `CTocListBox` fängt `LB_SETSEL` selbst ab (`tocview.cpp:395`,
`ON_MESSAGE(LB_SETSEL, OnSetSel)`) und ruft danach
`HandleSelectionMayHaveChanged`, denselben Helfer wie bei `LBN_SELCHANGE`
(`tocview.cpp:2146-2159`). `CTocView::GetSelCount` ist
`m_SumListBox.GetSelCount()` (`tocview.h:263-264`), also `LB_GETSELCOUNT`.
Update-UI und `Xfer` lesen damit genau, was das Skript gesetzt hat.

**Die Zählung `out=1 trash=0 (vorher 1)`:** `(vorher 1)` ist die Trash-Zahl
**vor** der Gegenprobe; ist Trash leer, steigt das Skript vorher aus
(`messen-e125.ps1`, Schritt 3). `out=` liest das aktive Fenster nach
`ID_MAILBOX_OUT`. Öffnet sich `Out` nicht, misst das Skript Trash als „Out",
also `out=1 trash=1` — rot, nicht grün. Der Muss-Text schließt `out=10` und
`dialoge-gegenprobe=01` durch die folgenden Leerzeichen aus.

### <a id="k1"></a>K1 — E-125b allein unterscheidet „abgelehnt" nicht von „nicht ausgeführt"

**Sicherheit: am Quelltext belegt, die Abhängigkeit gemessen.**

E-125b verlangt `in=1 (vorher 1) out=1 (vorher 1) dialoge=1`. „dialoge=1"
zählt **irgendein** sichtbares `#32770`-Fenster, nicht den Hinweistext. Wird
der Befehl stumm verworfen und erscheint zufällig ein anderer Dialog, ist
E-125b grün. Dazu wird die Menünummer in der Umkehrprobe **nicht** auf 0
geprüft (`Befehl $haupt (TransferNach $haupt 'Out')`), anders als in Schritt 2
und 3.

**Dass E-125b gegen 7.2.0.120 rot war, hing an einer Wahl des Skripts:**
`Dialoge` drückt einen Knopf mit dem Text `OK`. Die alte Frage hat Ja/Nein,
also schickt das Skript `IDOK` an den Dialog, und Eudora wertet das als *Ja*
(gemessen, `C:\Temp\E125-alt\Mailverzeichnis\eudora.log:176-177`:
*„Some headers may be removed …"* → *„Dismissed with 1"*). Mit *Nein* wäre
E-125b auch gegen den alten Bau grün gewesen. **Die Trennschärfe liegt in
E-125c**, der Protokollzeile, und die ist da. Darum kein Fehlurteil.

**Vorschlag:** E-125b um den Dialogtext ergänzen — das Skript gibt ihn schon
aus (`E125 DIALOG [...] <Text>`), ein vierter Fall auf Quelle `messung` mit
`Messages can't be transferred to the Out mailbox` genügt. Die Menünummer in
Schritt 5 wie in Schritt 3 auf 0 prüfen. `Waehle` meldet die Auswahlzahl nur;
bei 0 sollte das Skript aussteigen.

## 4. Leere `sumlist` beim Weg Trash → Out

**Gilt, ist hier folgenlos.** Am Quelltext belegt.

`sumlist.AddTail` steht nur im Zweig `if (!ToOut)` (`tocdoc.cpp:3001`), bei
Trash → Out ist die Liste also leer, wie [PRÜFER-46](PRUEFER-46.md) schreibt.
Die IMAP-Nachbearbeitung (`tocdoc.cpp:3133-3134`) läuft aber nur, wenn eine
Seite IMAP ist. Bei Trash (lokal) → Out (lokal) ist das nicht der Fall.
**Kein Datenverlust, kein Doppel, keine Folge aus
[E-141](../Intern/BEFUNDE.md#e-141).** Die Quelle wird abgezogen und in die
Rückgängig-Liste gelegt (`tocdoc.cpp:3022-3042`), wie bei jedem lokalen
Verschieben.

**Anders bei einem IMAP-Papierkorb als Quelle**: dann gelten
[E-141](../Intern/BEFUNDE.md#e-141) (*„No messages were transferred!"*,
möglicher `EXPUNGE`) und [E-142](../Intern/BEFUNDE.md#e-142) (Entwurf doppelt).
Diesen Weg misst die Gegenprobe **nicht**. Das ist keine Lücke der Behebung,
beide Befunde sind älter. Der Bericht sollte aber dazuschreiben, dass die
Gegenprobe nur lokal gilt.

Nebenbei, schon erfasst: `return pCopySum;` in `tocdoc.cpp:3143` verlässt
`Xfer`, ohne `bXferActive` zurückzusetzen. Das steht in [E-141](../Intern/BEFUNDE.md#e-141). Dasselbe gilt
für `return SingleSum;` in `:3139`. Dorthin kommt man aber nicht: `this ==
TargetToc` überlebt bis dahin nur mit `m_Type == MBT_TRASH` (`:2554-2563`),
und ein IMAP-TOC hat diesen Typ nicht. Am Quelltext belegt.

### <a id="k2"></a>K2 — neuer Befund E-144: ein Entwurf verliert beim Zurückschieben nach `Out` die Antwortbezüge

**Sicherheit: am Quelltext belegt; am Programm nicht gemessen** — der Entwurf
im Prüfstand hatte leere `In-Reply-To:` und `References:` (gemessen,
`Out.mbx`).

Eine verfasste Nachricht nach `Out` wird nicht verschoben, sondern über
`Sum->SendAgain(FALSE)` **neu angelegt** (`tocdoc.cpp:3005`, gemessen an der
neuen `Message-Id`, siehe Frage 2). `SendAgain` baut den neuen Entwurf aus
`To`, `Subject`, `Cc`, `Bcc`, `X-Attachments`, Rumpf, Persona und den
Kopfzeilen eingebetteter Objekte (`summary.cpp:1912-1915`) und übernimmt danach
Priorität, Übersetzer, Signatur und die Plugin-Kopfzeile (`:1918-1928`), dazu
im Aufrufer das Etikett (`tocdoc.cpp:3008`). **`In-Reply-To` und `References`
werden nicht übernommen**: `NewCompDocument` hat dafür keinen Parameter
(`compmsgd.cpp:2167-2181`), und gesetzt werden sie sonst nur beim Antworten
(`TocFrame.cpp:1913-1914`). Wer einen Antwortentwurf in ein Postfach schiebt
und zurück nach `Out`, schickt ihn danach **ohne Bezug auf die Nachricht, auf
die er antwortet**. Beim Empfänger fällt er aus dem Gesprächsfaden.
**Vermutung, nicht geprüft:** dasselbe gilt für die Optionen der Nachricht in
`m_Flags`/`m_FlagsEx` (Empfangsbestätigung, Kopie behalten usw.), denn
übernommen wird nur, was oben steht.

**Keine Regression:** dieselbe Zeile steht im ersten Stand des Repos
(`git show 567a5d87:Eudora71/Eudora/summary.cpp`, Zeile 1797). Ob das
*Verhalten* im Original so ist, ist nicht gemessen
([original-ist-eine-messung](../Arbeitsweise/original-ist-eine-messung.md)).
**Warum es trotzdem hierher gehört:** [E-125](../Intern/BEFUNDE.md#e-125) erklärt diesen Weg ausdrücklich
für richtig (*„sie nach Out zu ziehen heisst, sie zum Senden einzureihen, und
das tut genau das, was es soll"*, `tocdoc.cpp:2743-2745`). Die Gegenprobe
prüft nur die **Anzahl** und nicht, ob der Entwurf derselbe geblieben ist.
`perl tools/befund-suchen.pl SendAgain` findet nur [E-125](../Intern/BEFUNDE.md#e-125) und [E-142](../Intern/BEFUNDE.md#e-142), die hier
nicht passen. **Vorschlag Stufe: wichtig** (Datenverlust an Kopfzeilen eines
Entwurfs, kein Verlust der Nachricht). **Messung:** Antwort auf eine
Nachricht in `In` anlegen, speichern, Out → Trash → Out, dann `Out.mbx` auf
`In-Reply-To:` durchsehen. Das geht mit einer Erweiterung von
`messen-e125.ps1` (`ID_MESSAGE_REPLY` statt `ID_MESSAGE_NEWMESSAGE`).

## 5. Die Pfadschranke in `-Vorbereiten`

`$voll = GetFullPath($Pfadfilter).TrimEnd('\')`, abgewiesen wird
`-notmatch '^C:\\Temp\\[^\\]+'`. **Gemessen** mit PowerShell 5.1 an diesem
Rechner:

| Eingabe | `GetFullPath` | Ergebnis |
|---|---|---|
| `C:\Temp\..\Users` | `C:\Users` | abgewiesen |
| `C:\Temp\E125\..\..\Users\Gregor` | `C:\Users\Gregor` | abgewiesen |
| `c:\temp\x` | `c:\temp\x` | **durchgelassen** — richtig, derselbe Ort (`-notmatch` unterscheidet keine Groß- und Kleinschreibung) |
| `\\localhost\C$\Temp\x` | unverändert | abgewiesen (auch wenn es auf `C:\Temp` zeigt) |
| `\\?\C:\Users` | unverändert | abgewiesen |
| `C:\Temp\x\.`, `C:\Temp\x...`, `C:\Temp\x ` | `C:\Temp\x` | durchgelassen, derselbe Ort |
| `C:\Temp` | `C:\Temp` | abgewiesen |
| 8.3-Kurzname, z. B. `C:\PROGRA~1` | unverändert | abgewiesen; ein Kurzname **unter** `C:\Temp\` bleibt unter `C:\Temp` |

### <a id="k3"></a>K3 — Verzeichnisverbindungen unter `C:\Temp` gehen durch, und das Löschen läuft vor der Instanzprüfung

**Sicherheit: am Quelltext belegt; die heutige Lage gemessen.**

`GetFullPath` löst **keine** Verzeichnisverbindung und keinen symbolischen
Link auf. Zeigt `C:\Temp\X` oder `C:\Temp\X\Mailverzeichnis` auf ein
Verzeichnis außerhalb, löscht `-Vorbereiten` dort `In`, `Out` und `Trash`
samt `.toc` und allen `.001`-Sicherungen. Geprüft wird nur der übergebene
Pfad, nicht `$md`. **Gemessen am 23.10.2026:** `C:\Temp` selbst ist ein
gewöhnliches Verzeichnis, unter seinen 59 Unterverzeichnissen ist keine
Verbindung, unter `C:\Temp\E125` und `C:\Temp\E125-alt` (eine Ebene tief)
auch nicht. **Heute folgenlos.** Dieselbe Klasse wie in
[pruefstand-nicht-bequemer-als-die-wirklichkeit](../Arbeitsweise/pruefstand-nicht-bequemer-als-die-wirklichkeit.md):
die Prüfung sieht den Namen, nicht den Ort.

Dazu kommt die Reihenfolge: `pruefstand-lauf.ps1:196` ruft `-Vorbereiten`
**vor** `testlauf.ps1`, und erst `testlauf.ps1:154-163` prüft, ob aus dem
Verzeichnis schon eine Eudora läuft. Hängt eine Instanz aus einem früheren
Lauf, löscht das Skript ihre Postfächer unter ihr weg. Erst danach weist
testlauf ab. Der Schaden bleibt im Prüfstand. Trotzdem steht das Tor hinter
dem Schritt, den es bewachen soll
([tor-gehoert-zum-schritt](../Arbeitsweise/tor-gehoert-zum-schritt.md)).

**Vorschlag:** vor dem Löschen für `$voll` und `$md` und jedes Verzeichnis
dazwischen `(Get-Item -Force).Attributes -band ReparsePoint` prüfen und
abweisen. Vor dem Löschen nach einer laufenden Eudora aus `$voll\` suchen.

### <a id="k4"></a>K4 — der Prozessfilter trifft auch `C:\Temp\E125-alt`

**Sicherheit: am Quelltext belegt.**

`messen-e125.ps1` sucht die Eudora mit
`$_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase')`, ohne abschließenden
Rückstrich. `C:\Temp\E125` trifft damit auch `C:\Temp\E125-alt\Eudora.exe`,
und genommen wird `$proz[0]`. Beide Prüfstände gibt es seit heute. **Heute
verdeckt:** `testlauf.ps1:157` prüft mit demselben Präfixvergleich. Läuft
eine Eudora aus `E125-alt`, weist testlauf einen Lauf in `E125` ab, mit der
falschen Begründung *„Aus diesem Verzeichnis laeuft schon eine Instanz"*. Das
ist ein Fehlalarm, keine Fehlbedienung. Falsch bedient würde nur eine
Instanz, die zwischen der Prüfung und der Messung startet. **Vorschlag:** an
beiden Stellen gegen `$voll.TrimEnd('\') + '\'` vergleichen.

## 6. `pruefstand-lauf.ps1`: Schalter, Abweisung, Ausstieg

* **`.ToLower()` und `Join-Path`:** `messen=tools\messen-e125.ps1` wird klein
  geschrieben, `Substring(7)` liefert `tools\messen-e125.ps1`, und
  `Join-Path $wurzel` trifft die Datei, weil NTFS keine Groß- und
  Kleinschreibung unterscheidet. Die Schablone
  `^messen=tools[\\/]messen-[a-z0-9-]+\.ps1$` (`pruefstand-lauf.ps1:81`) lässt
  keinen Punkt im Namen zu, ein `..` geht also nicht durch. Am Quelltext belegt.
* **testlauf weist ab:** `testlauf.ps1` endet mit `exit 1`, Eudora startet
  nicht. Das alte Protokoll ist vorher gelöscht (`pruefstand-lauf.ps1:157`),
  also ist `$logtext` leer, und alle drei Fälle werden **rot** (*„kein
  Protokoll nach dem Lauf"*, `:233-241`). Richtig.
* **Das Messskript steigt mit `exit 1` aus:** testlauf verschluckt den
  Rückgabewert, weil das Skript in einer Pipeline läuft (`testlauf.ps1:336-337`),
  und `$rc` geht in kein Urteil ein. Trotzdem wird nichts fälschlich grün: je
  nach Abbruchstelle fehlt die Zeile `E125 ERGEBNIS` (E-125a rot), `E125 UMKEHR`
  (E-125b rot) oder die Ablehnungszeile im Protokoll (E-125c rot). Alle drei
  Fälle haben einen **Muss**-Text. Am Quelltext belegt.
* **Gibt es einen „darf nicht"-Fall auf `messung`?** Heute nicht. Das einzige
  „darf nicht" (`quelle=Trash`) steht auf E-125c, also auf `log`, und hat
  einen Muss-Text im **selben** Protokoll. Das ist eine echte Positivprobe.

### <a id="k5"></a>K5 — die Quelle `messung` hat keine Positivprobe

**Sicherheit: am Quelltext belegt; heute ohne Wirkung.**

Die Positivprobe in `pruefstand-lauf.ps1:233` prüft nur, ob ein **Protokoll**
da ist. Ob das Messskript überhaupt lief, prüft sie nicht. testlauf
überspringt es still, wenn Eudora sich vorher beendet hat
(`testlauf.ps1:333`), und das Protokoll kann trotzdem da sein. Ein künftiger
Fall auf `messung` mit leerem Muss-Text und nur einem „darf nicht" wäre dann
mit leerer Ausgabe grün — genau der Fall aus
[ausbleiben-ist-kein-befund](../Arbeitsweise/ausbleiben-ist-kein-befund.md).
Die Prüfung beim Einlesen (`pruefstand-lauf.ps1:81-93`) lässt das zu.
**Vorschlag:** für Quelle `messung` verlangen, dass `$messtext` die Zeile
`--- Ende der Messung ---` enthält (`testlauf.ps1:338`). Besser noch: das
Messskript gibt als letzte Zeile eine eigene Endmarke aus (`E125 ENDE`), und
die wird verlangt — die testlauf-Zeile erscheint auch nach einem `exit 1`.
Oder: ein Fall auf `messung` ohne Muss-Text wird schon beim Einlesen
abgewiesen.

## 7. Ist „behoben, von Gregor bestätigt" gedeckt?

**Ja, so wie es in BEFUNDE.md steht** — die Zeile trennt sauber: *„die
Ablehnung von Gregor … bestätigt, die Gegenprobe am selben Tag am Prüfstand
gemessen"*. Am Text belegt.

* **Der gemeldete Fehler ist gemessen behoben:** Gregors Meldung vom
  16.10.2026 war eine Nachricht aus dem IMAP-Ordner `OUTBOX` nach `Out`. Genau
  diesen Weg hat er an 1.0.122 gefahren, mit Hinweisdialog, Protokollzeile
  `quelle=OUTBOX (<Dominant>) … einzeln=0` und ohne *„No messages were
  transferred!"*. Gezogen hat er mit der Maus, und Frage 1 zeigt: das ist
  derselbe `Xfer`.
* **Die Gegenprobe ist keine Behebung, sondern der Nachweis, dass nichts
  kaputtgegangen ist.** Dass Gregor sie abgelehnt hat, lässt das Urteil
  „behoben" unberührt. Unberührt bleibt aber auch, dass **nur der Prüfstand**
  sie gefahren hat, und zwar **über das Menü und mit lokalen Postfächern**. So
  steht es auch im Bericht.
* **Nicht gedeckt** ist allein der Name des Zweigs und der ZWEIGE-Eintrag
  *„von Gregor bestätigt"*. Er bezieht sich auf den Zweignamen, nicht auf das
  Urteil, und so ist er auch gemeint (`tools/ZWEIGE.md`). Ein Leser des
  PR-Titels kann ihn aber falsch lesen.

### <a id="k6"></a>K6 — „Gegentest gegen 7.2.0.120: dieselben Fälle werden rot" stimmt nur für zwei von drei

**Sicherheit: gemessen an den Dateien des Laufs.**

BEFUNDE.md ([E-125](../Intern/BEFUNDE.md#e-125)) schreibt *„dieselben Fälle werden rot"*, der Testbericht
*„Dieselben Fälle gegen 7.2.0.120 — fehlgeschlagen, wie erwartet"*. **E-125a
ist gegen 7.2.0.120 grün** und muss es sein: verfasste Nachrichten durften auch
im alten Bau nach `Out`. Gemessen in `C:\Temp\E125-alt\Mailverzeichnis`:
`Trash.mbx` hat 0 Byte, `Out.mbx` enthält den Entwurf mit neu vergebener
`Message-Id …145308…` (also über `SendAgain` zurückgeschoben) **und** die
empfangene Nachricht aus `In` (`Subject: Pruefung E-118 …`), `In.mbx` hat
0 Byte. Daraus folgt `out=1 trash=0` nach der Gegenprobe (grün) und
`in=0 out=2` in der Umkehrprobe (E-125b rot). Die Ablehnungszeile fehlt im
Protokoll (E-125c rot). Die Ausgabe des Messskripts selbst ist von diesem Lauf
nicht abgelegt. Gefolgert ist das also aus den Postfächern, nicht aus der
Zeile `E125 ERGEBNIS`.

Das ist kein Fehler des Tests. Falsch ist der Satz darüber, und er verdeckt,
dass **E-125a noch nie rot gesehen wurde** (das schreibt der Testbericht unter
*„Was dieser Test nicht prüft"* selbst). **Vorschlag:** *„E-125b und E-125c
werden rot; E-125a bleibt grün, wie es soll"*. Der Auftrag an mich nannte es
bereits so.

### <a id="k7"></a>K7 — die Zahl der Positivprobe gehört zu einem anderen Lauf

**Sicherheit: gemessen.**

Der Testbericht schreibt *„Das Protokoll des Laufs enthält 453 Spurmarken der
Maske 32768"*. Das Protokoll des Laufs mit acht von acht
(`Intern/pruefstand-ergebnis.txt`: `zeit=2026-10-23 14:54:52`, Protokoll ab
`Fri Oct 23 14:54:27 2026`) enthält **162** Zeilen `MAIN 32768`. Das
E-125-alt-Protokoll enthält 170. `pruefstand-lauf.ps1:157` löscht das
Protokoll vor jedem Lauf. Die 453 stammen also aus einem der fünf
Entwicklungsläufe davor (`tools/TESTLAEUFE.md`, 14:45 bis 14:52), deren
Protokoll nicht mehr da ist. Am Schluss ändert das nichts, die bessere
Positivprobe ist ohnehin E-125c selbst: Ablehnungszeile da, Trash-Zeile nicht
da, **im selben Protokoll**. **Vorschlag:** die Zahl streichen oder durch
diesen Satz ersetzen.

### <a id="k8"></a>K8 — „Der Entwurf steht wieder in Out" ist eine Kopie, kein Rückweg

**Sicherheit: gemessen.**

Der Testbericht schreibt *„Der Entwurf steht wieder in `Out`"*. Gemessen ist:
**eine neue Nachricht** mit neuer `Message-Id` und neuem Datum der
`From `-Zeile, das Original ist beim Verdichten entfernt worden (Frage 2). Für
die Anzahl ist das gleich. Für den Inhalt ist es das nicht, siehe
[K2 / E-144](#k2). Die Gegenprobe vergleicht nur Zahlen. **Vorschlag:** im
Bericht *„ein neu angelegter Entwurf mit denselben Empfängern"*. Im
Messskript den Kopfblock vor und nach der Gegenprobe vergleichen, ohne
`From `-Zeile und `Message-Id`.

---

## Gegenvermutungen, die ich aufgestellt habe

| Gegenvermutung | Ergebnis |
|---|---|
| Der Menüweg umgeht die Sperre, weil er eine eigene Übertragungsfunktion hat | **widerlegt**, Frage 1: ab `QCMailboxCommand::Execute` gemeinsam |
| Trash als Quelle hat einen Sonderzweig, der die Sperre überspringt | **widerlegt**, Frage 2: nur `Purging` und die Warnung, beide hängen am Ziel |
| Der Zustand geht beim Verschieben in ein lokales Postfach verloren | **widerlegt**: `Copy` übernimmt `m_State`, Out setzt `MS_UNSENT` (`tocdoc.cpp:2999-3000`) |
| Grün ohne Sperre, weil der Befehl stumm verworfen wird | **widerlegt**: verworfen heißt `trash=1`, rot (Frage 3) |
| `LB_SETSEL` zählt für Eudora nicht als Auswahl | **widerlegt**: `CTocListBox::OnSetSel` (`tocview.cpp:2146`) |
| Grün, weil ein Rest vom vorigen Lauf gezählt wird | **widerlegt**: `-Vorbereiten` löscht Out/Trash/In, das Protokoll wird vorher gelöscht |
| E-125b allein erkennt den alten Bau | **bestätigt nur bedingt**: hängt an `IDOK` = Ja ([K1](#k1)) |
| Alle drei Fälle sind gegen 7.2.0.120 rot | **widerlegt** für E-125a ([K6](#k6)) |
| Der zurückgeschobene Entwurf ist derselbe | **widerlegt**: neue `Message-Id`, Antwortbezüge fallen weg ([K2](#k2), [K8](#k8)) |
| Ein salvagiertes TOC macht Entwürfe zu empfangenen | **bestätigt** für den Alltag (`MS_RECOVERED`, `tocdoc.cpp:451-468`), im Lauf nicht eingetreten |

## Was gelaufen ist

* `Eudora71/Tests/Build/Debug/EudoraTests.exe` im Arbeitsbaum:
  **277 Tests, 277 bestanden**, darunter beide E-125-Fälle.
* Gelesen, nichts verändert: `C:\Temp\E125\Mailverzeichnis` und
  `C:\Temp\E125-alt\Mailverzeichnis` (`eudora.log`, `Out.mbx`,
  `Out.mbx.001`, `In.mbx`, `Trash.mbx`, `Eudora.ini`), dazu die Attribute der
  Verzeichnisse unter `C:\Temp`.
* Kein Eudora gestartet, kein Fenster, nichts gebaut.
* `perl tools/befund-suchen.pl` zu `bXferActive` (→ [E-141](../Intern/BEFUNDE.md#e-141), schon erfasst) und
  zu `SendAgain` (→ [E-125](../Intern/BEFUNDE.md#e-125), [E-142](../Intern/BEFUNDE.md#e-142); Antwortbezüge nicht erfasst → [E-144](../Intern/BEFUNDE.md#e-144)).

## Übersicht

| Fund | Was passiert | Schwere | Hält ein Release auf? |
|---|---|---|---|
| [K2](#k2) = **[E-144](../Intern/BEFUNDE.md#e-144)** | Antwortentwurf verliert `In-Reply-To`/`References` beim Zurückschieben nach `Out` | wichtig (Kopfzeilen, nicht die Nachricht) | nein — ungeändert seit dem ersten Stand |
| [K1](#k1) | E-125b erkennt die Ablehnung nur zusammen mit E-125c | gering (Prüfstand) | nein |
| [K3](#k3) | Pfadschranke löst Verzeichnisverbindungen nicht auf; Löschen vor der Instanzprüfung | gering (heute keine Verbindung vorhanden) | nein |
| [K4](#k4) | Prozessfilter `C:\Temp\E125` trifft `E125-alt` | gering (Fehlalarm in testlauf) | nein |
| [K5](#k5) | Quelle `messung` ohne Positivprobe | gering (latent, kein heutiger Fall betroffen) | nein |
| [K6](#k6) | „dieselben Fälle werden rot" — E-125a ist gegen .120 grün | Doku | nein |
| [K7](#k7) | 453 Spurmarken stammen nicht aus dem gemeldeten Lauf (dort 162) | Doku | nein |
| [K8](#k8) | „der Entwurf steht wieder in Out" — es ist eine neu angelegte Kopie | Doku | nein |

**[E-144](../Intern/BEFUNDE.md#e-144) vergeben** (für K2). **[E-145](../Intern/BEFUNDE.md#e-145) nicht vergeben.** Eingetragen in
`Intern/BEFUNDE.md` ist [E-144](../Intern/BEFUNDE.md#e-144) noch nicht — das gehört nicht zu meinem Auftrag.
