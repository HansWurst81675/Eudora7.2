# PRÜFER-43 — 7.2.0.119: die beiden Behebungen zu E-134, gegen die MFC nachgerechnet

Gegenstand: **Commit `14786286`** („7.2.0.119: der Kurzname eines neuen
Adressbucheintrags kommt an"), zwei Änderungen — `nicktree.cpp` (zweimal ein
`DoSelectItem(…, TRUE)` hinter `SelectItem()`) und `nickview.cpp`
(`CNicknamesViewRight::NicknameEditChanged`). Zweig `wt/pruefer-20261021`,
Basis `origin/e-134-adressbuch-auswahl`. Es geht um die Auslieferung als
**1.0.119**.

**Wie geprüft.** Am Quelltext gelesen: `AddNewNickname`, `NicknameWasChanged`,
`RestoreVisualState`, `GetSelectedNicknames`, `GetSelectedNicknamefiles`,
`FindSingleSelectedNicknameFile`, `BroadcastSelectedNickname`,
`MarkSelectedNicknameDirty`, `CheckForDuplicateNickname`,
`CheckForDuplicateNicknameInTree`, `EvaluateSelection`,
`EvaluateSelectionForRecipients/ForBP/ForRename/ForNewAndDel`, `OnSelChanged`,
`OnLButtonDown`, `OnRightButtonDown`, `OnBeginDrag`, `OnKeyDown`,
`OnEndLabelEdit`, `DoDeselectAll`, `DoSelectItem`, `DoSelectItemRange`,
`IsItemSelected`, `DoFindNext`, `GetFirstSelectedNickorFile`, dazu
`CNicknameEdit::WindowProc/UpdateEdit`, `CNicknamesViewRight::OnUpdate`,
`CNicknamesViewLeft32::OnUpdate/NicknameChanged/CheckDuplicateNickname`,
`CNickname::SetName/HasValidName/IsValidNickName/SetValidateMode`.

**Dazu eine eigene Messung** am lebenden Windows, siehe [K1](#k1): ein eigenes
Baumsteuerelement mit genau den Stilbits von `IDC_NICKNAME_LEFT_LIST`, je
einmal gegen comctl32 **5.82** und **6.16**. Die Frage, die der Commit offen
lässt, ist damit beantwortet.

**Gebaut und gemessen nach meiner Änderung:** `tools\bauen.ps1 -Konfiguration
Release` — **ERFOLG, 0 Fehler, 2 Warnungen**. `EudoraTests.exe` — **243 Tests,
243 bestanden, 0 fehlgeschlagen**.

---

## Urteil

> ### JA — 1.0.119 geht so raus.

Beide Behebungen sind **richtig und ungefährlich**. Meine Hauptgegenvermutung
— das zusätzliche `DoSelectItem(h_child, TRUE)` könne zwei Einträge
gleichzeitig ausgewählt lassen und damit `m_LastEvaluatedSelectionState =
SELSTATE_SINGLE` zur Lüge machen — ist **gemessen widerlegt** ([K3](#k3)):
`SelectItem()` löscht das Bit der alten Karette mit, bevor es das neue setzt.
Die Reihenfolge im Fokusverlust-Weg ist **die einzig mögliche richtige**
([K6](#k6)): die Dublettenprüfung vergleicht Objektnamen, sie *braucht* das
`SetName()` davor. Ein doppelter Name kann nicht durchrutschen.

**Kein Fund dieses Berichts verliert Daten, und keiner macht Eudora
startunfähig.** Deshalb hält keiner das Paket auf.

Der schwerwiegendste Fund ist [K1](#k1), und er betrifft nicht den Code,
sondern das, was über ihn geschrieben steht: die an sechs Stellen gesetzte
Ursache *„`SelectItem()` setzt in diesem Bau die Karette, aber nicht
`TVIS_SELECTED`"* ist **in dieser Allgemeinheit falsch** — und die daneben
geäußerte Vermutung, es liege an der Fassung der Common Controls, ist
**widerlegt**. Ich habe den Text berichtigt; die beiden Zeilen Code bleiben
unangetastet, denn sie sind in beiden Lesarten richtig.

### Funde

| | Fund | Einstufung |
| --- | --- | --- |
| [K1](#k1) | Die angegebene Ursache stimmt so nicht — gemessen, und die Common-Controls-Vermutung ist widerlegt | hält nicht auf (von mir berichtigt) |
| [K2](#k2) | In `AddNewNickname` ist die neue Zeile in der Normallage wirkungslos; die Beweiskette trägt dort nicht | hält nicht auf |
| [K3](#k3) | Gegenvermutung Mehrfachauswahl — **widerlegt**, gemessen | kein Mangel |
| [K4](#k4) | Karette gegen Zustand — sie laufen nach der Änderung **enger** zusammen, nicht weiter auseinander | kein Mangel |
| [K5](#k5) | `CheckForDuplicateNicknameInTree()` ignoriert sein Argument und liest `m_u.pNickname` ohne Typprüfung | hält nicht auf (vorbestehend) |
| [K6](#k6) | Reihenfolge im Fokusverlust-Weg — richtig; kein Durchrutschen, kein Fehlalarm | kein Mangel |
| [K7](#k7) | Leeres oder ungültiges Feld: Anzeige und Daten laufen auseinander | hält nicht auf (unverändert) |
| [K8](#k8) | `SetValidateMode`: das Weglassen **war** ein eigener Fehler; das Zurücksetzen hat keine Nebenwirkung | kein Mangel |
| [K9](#k9) | Von den übrigen acht `SelectItem()`-Stellen ist **eine** betroffen: `OnRightButtonDown` | hält nicht auf |
| [K10](#k10) | `m_focusNickName`: 256 Byte Leck je Fokusgewinn, `strcpy` ohne Längenschranke | hält nicht auf (vorbestehend) |
| [K11](#k11) | Byte-Disziplin: 18 CRLF vorher, 18 nachher, kein Byte > 127 | kein Mangel |
| [K12](#k12) | Der gesamte Weg steht in keinem Test, und das bleibt so | hält nicht auf |

---

<a id="k1"></a>

## K1 — Die angegebene Ursache stimmt so nicht. Gemessen.

**Einstufung: hält nicht auf. Von mir berichtigt (nur Text).**

Der Commit schreibt an sechs Stellen — zwei Kommentarblöcken in `nicktree.cpp`,
`CHANGELOG.md`, `BEFUNDE.md`, `PORTIERUNG.md`, `AUFGABEN.md` — denselben Satz:

> `CTreeCtrl::SelectItem()` setzt in diesem Bau die **Karette**, aber **nicht**
> `TVIS_SELECTED`.

und vermutet daneben: *„naheliegend ist die Fassung der Common Controls oder
der MFC"*.

`CTreeCtrl::SelectItem(h)` ist nichts weiter als
`SendMessage(TVM_SELECTITEM, TVGN_CARET, h)`. Diese Botschaft ist messbar, und
sie braucht kein Eudora dazu. Ich habe ein eigenes Baumsteuerelement mit genau
den Stilbits von `IDC_NICKNAME_LEFT_LIST` gebaut
(`TVS_HASBUTTONS | TVS_HASLINES | TVS_EDITLABELS | TVS_SHOWSELALWAYS`), x86 wie
Eudora, und dasselbe Programm zweimal gebunden: einmal **ohne** Manifest
(comctl32 **5.82**) und einmal mit `Microsoft.Windows.Common-Controls`
**6.0.0.0** wie `Eudora.manifest` (comctl32 **6.16**; dass die ausgelieferte
`Eudora.exe` diese Abhängigkeit wirklich trägt, steht als Zeichenkette in der
Datei, und `Eudora.vcxproj` reicht `Eudora.manifest` an den Binder weiter —
die `CREATEPROCESS_MANIFEST_RESOURCE_ID`-Zeile in `EudoraExe.rc:125` ist
auskommentiert).

**Gemessen, 21.10.2026 — beide Fassungen liefern Zeichen für Zeichen dasselbe:**

| Lage vor dem Aufruf | nach `SelectItem(X)` |
| --- | --- |
| Karette steht woanders | `TVIS_SELECTED(X)` = **1**, und das Bit der alten Karette ist **0** |
| Bit von `X` per `TVM_SETITEM` gelöscht, Karette steht **schon auf `X`** | `TVIS_SELECTED(X)` = **0** |
| dasselbe, aber der Baum hat den Eingabefokus | unverändert: **1** bzw. **0** |
| Ablauf wie `AddNewNickname`: Kind einfügen, `TVM_SORTCHILDREN`, alle Bits löschen, `SelectItem(neu)` | `TVIS_SELECTED(neu)` = **1** |

Daraus folgt dreierlei:

1. **Die Aussage ist zu weit gefasst.** `SelectItem()` setzt `TVIS_SELECTED`
   sehr wohl — immer dann, wenn das Element nicht ohnehin schon die Karette
   trägt. Richtig ist: `TVM_SELECTITEM`/`TVGN_CARET` tut **nichts**, wenn
   `hItem` bereits die Karette ist. Dass ein `DoDeselectAll()` das Bit kurz
   davor über `TVM_SETITEM` gelöscht hat, bemerkt das Steuerelement nicht —
   sein interner Zeiger auf das ausgewählte Element steht unverändert auf `X`,
   also hat es nichts zu tun.
2. **Die Common-Controls-Vermutung ist widerlegt.** 5.82 und 6.16 verhalten
   sich gleich. Der Unterschied zu Hermes liegt nicht dort.
3. **Für `NicknameWasChanged` ist der Fall belegt** — die Funktion läuft bei
   jedem Tastendruck im Namensfeld, die Karette steht also längst auf
   `h_child`. Das ist genau die Zeile 2 der Tabelle, und damit ist die
   Behebung an dieser Stelle **richtig und notwendig**.

**Berichtigt** in `nicktree.cpp` (beide Kommentarblöcke), `CHANGELOG.md`,
`BEFUNDE.md`, `PORTIERUNG.md` und `AUFGABEN.md`; dazu der Zeilenverweis `nicktree.cpp:936-941`
→ `877-894` (die Zeile 936 gab es dort nie). **Kein Ausführungspfad geändert**,
Release neu gebaut (0 Fehler), 243/243 Tests grün.

Was dadurch **offen** wird und vorher als beantwortet galt: *warum* die Karette
in diesem Bau schon auf dem Eintrag steht, wo sie es in Hermes nicht tat. Das
ist kein Grund, 1.0.119 zurückzuhalten — die Behebung setzt den Zustand
ausdrücklich und hängt nicht an der Antwort.

---

<a id="k2"></a>

## K2 — In `AddNewNickname` ist die neue Zeile in der Normallage wirkungslos

**Einstufung: hält nicht auf.**

`nicktree.cpp:523`, der erste der beiden Einbauten. Nach [K1](#k1) wirkt er
genau dann, wenn die Karette beim Anlegen schon auf dem neuen Eintrag steht.
Die vierte Zeile meiner Messtabelle bildet den dortigen Ablauf nach — Kind
einfügen, `SortChildren`, alles abwählen, `SelectItem(neu)` — und dort **setzt
`SelectItem()` das Bit**. In der Normallage ist die Zeile also eine Sicherung,
kein Fix.

Dazu passt, dass die Beweislage im Befund an dieser Stelle **nicht aufgeht**.
`BEFUNDE.md` führt als Messung an:

> Baumzustand über `TVM_GETITEMSTATE` von außen gelesen: Wurzel `0x0062` =
> `SELECTED+EXPANDED`, Kind `0x0000` = **nicht ausgewählt**.

Eine *ausgewählte Wurzel* kann es nach einem durchlaufenen `AddNewNickname`
nicht geben: das `DoDeselectAll()` zwei Zeilen darüber löscht das Bit jedes
Wurzelelements (`nicktree.cpp:3976-3984`), ehe `SelectItem()` überhaupt
drankommt. Entweder wurde dieser Zustand **vor** dem Anlegen gelesen, oder
`AddNewNickname` hat seine Auswahlschleife gar nicht erreicht — die Funktion
hat drei frühe `return FALSE`, und ihre Suchschleife läuft mit
`GetNextVisibleItem()` über die Geschwisterliste hinaus, wenn das Dateielement
nicht sichtbar aufgeklappt ist; abgefangen nur von einem `ASSERT`, das im
Freigabebau nichts ist (Klasse [E-83](../BEFUNDE.md#e-83)).

**Es ist kein Grund, das Paket zu halten** — die Zeile schadet in keiner Lage,
und der gemessene Erfolg (dreimal `alias hans`) steht. Aber die Ursache ist an
dieser Stelle **nicht belegt**.

**Handlungsanweisung** (nach 1.0.119, nicht davor): eine Spurmarke unmittelbar
vor `DoDeselectAll()` in `AddNewNickname`, die `GetSelectedItem()` und
`h_nickname` in **einer** Zeile ausgibt (Lehre *zwei-werte-in-eine-ausgabe*).
Steht dort „gleich", ist die Zeile ein Fix; steht dort „verschieden", ist sie
eine Sicherung und der Fehler saß allein in `NicknameWasChanged`.

---

<a id="k3"></a>

## K3 — Kann das neue `DoSelectItem(h_child, TRUE)` eine Mehrfachauswahl verfälschen? **Nein.**

**Einstufung: kein Mangel. Die Gegenvermutung ist gemessen widerlegt.**

Die Stelle (`nicktree.cpp:877-895`):

```cpp
if (m_LastEvaluatedSelectionState != SELSTATE_SINGLE)
    DoDeselectAll();
SelectItem(h_child);
DoSelectItem(h_child, TRUE);          // neu
m_LastEvaluatedSelectionState = SELSTATE_SINGLE;
```

Meine Gegenvermutung war: im Fall `SELSTATE_SINGLE` läuft **kein**
`DoDeselectAll()`. Steht das Bit dann auf einem **anderen** Eintrag `A` und
wird die Funktion für `B` gerufen, so hätte `B` hinterher zusätzlich das Bit —
zwei ausgewählte Einträge, während `m_LastEvaluatedSelectionState` „einer"
behauptet. `GetSelectedNicknames()` liefert dann zwei Einträge, und
`NicknameEditChanged` nimmt mit `GetHead()` den **falschen**: der Anwender
benennt einen Eintrag um, den er nie angefasst hat.

**Gemessen (Probe 3 derselben Messreihe):** Karette auf `b`, Bit von `a` von
Hand gesetzt, also `a=1 b=1`. Nach `SelectItem(a)`: **`a=1 b=0`**. Das
Steuerelement räumt das Bit der alten Karette selbst ab. Die Vermutung trägt
also nicht: nach `SelectItem(h_child)` steht das Bit bereits auf `h_child`
allein, und `DoSelectItem(h_child, TRUE)` ist dort nur noch doppelt gemoppelt.

Die beiden anderen Lagen prüfen sich von selbst:

* **Zustand `SELSTATE_MULTI`, `_NONE` oder `_UNKNOWN`:** `DoDeselectAll()`
  löscht alles, dann setzt entweder `SelectItem()` das Bit (Karette wandert)
  oder — der E-134-Fall — die neue Zeile. In beiden Fällen ist danach **genau
  ein** Eintrag ausgewählt, und `SELSTATE_SINGLE` ist **wahr**. Vorher war
  dieselbe Zeile im Fall „Karette steht schon dort" eine Lüge: null
  ausgewählte Einträge bei behauptetem „einer". **Die Änderung macht
  `m_LastEvaluatedSelectionState` also ehrlicher, nicht unehrlicher.**
* **Erzwungene Einfachauswahl:** Dass `NicknameWasChanged` eine bestehende
  Mehrfachauswahl abräumt, stand schon vor dieser Fassung im Code
  (`DoDeselectAll()` + `= SELSTATE_SINGLE`) und ist ausdrücklich so gewollt
  (*„While we're at it, force a single selection"*). Daran ändert der Einbau
  nichts.

Dazu: bei Mehrfachauswahl ist das Namensfeld gar nicht bedienbar — die rechte
Seite bekommt `NICKNAME_HINT_MULTISELECT_*` und ruft `EnableAllControls(FALSE)`
(`nickview.cpp:965-973`). Der Weg über `NicknameEditChanged` ist dort zu.

---

<a id="k4"></a>

## K4 — Karette gegen `TVIS_SELECTED`: wo bricht etwas?

**Einstufung: kein Mangel.**

Die Frage war, ob `GetSelectedItem()` (Karette) und `TVIS_SELECTED` nach der
Änderung auf **verschiedene** Einträge zeigen können. Nach [K1](#k1) und
[K3](#k3) ist die Antwort: die Änderung bringt die beiden **näher zusammen**.
Sie behebt genau den Zustand „Karette auf `X`, aber `X` nicht ausgewählt" — den
Zustand, auf den der vorhandene Code an mehreren Stellen ausdrücklich
misstraut. Durchgegangen:

* **`EvaluateSelection()` (1507).** `m_hAnchorItem = GetSelectedItem()`, danach
  wird über `IsItemSelected()` gezählt. Vorher konnte `selcount` 0 sein,
  während der Anker auf einen Eintrag zeigte; dann griff `case 0:` →
  `SELSTATE_NONE` und `UpdateAllViews(NOSELECT…)`, also leere Felder rechts.
  Nach der Änderung stimmt `selcount` mit dem Anker überein. **Besser, nicht
  schlechter.**
* **`BroadcastSelectedNickname()` (812).** Hat die Divergenz als Kommentar
  stehen (*„GetSelectedItem is not trustworthy, double check"*) und prüft
  `IsItemSelected(h_selitem)` nach. Vorher fiel der Broadcast still aus, jetzt
  greift er. Genau das soll er.
* **`FindSingleSelectedNicknameFile()` (730), `MarkSelectedNicknameDirty()`
  (775), `EvaluateSelectionForRename()` (2010),
  `EvaluateSelectionForNewAndDel()` (2059).** Alle hängen an `SELSTATE_SINGLE`
  + `GetSelectedItem()`. Sie profitieren davon, dass die Behauptung jetzt
  zutrifft.
* **`m_hAnchorItem`.** Wird nur in `EvaluateSelection()` (1516), bei `Reset`
  (348, 1329) und in den Umschalt-Wegen von `OnLButtonDown`/`OnKeyDown`
  gesetzt. `DoSelectItem()` ist ein reines `TVM_SETITEM` und rührt weder
  Karette noch Anker an. **Unberührt.**
* **`DoSelectItemRange()` (4069).** Arbeitet über `GetItemRect()` und
  `GetNextVisibleItem()`, nicht über die Karette. **Unberührt.**
* **`CheckForDuplicateNickname()` (910)** und
  **`CheckForDuplicateNicknameInTree()` (943)** lesen `GetSelectedItem()`,
  während die aufrufende `NicknameEditChanged` ihren `nickname` aus
  `GetSelectedNicknames()` (also aus `TVIS_SELECTED`) hat. Das ist **der**
  Punkt, an dem eine Divergenz wirklich wehtäte — siehe [K5](#k5) —, und genau
  diese Divergenz schließt die Änderung.

---

<a id="k5"></a>

## K5 — `CheckForDuplicateNicknameInTree()` ignoriert sein Argument

**Einstufung: hält nicht auf. Vorbestehend, aber jetzt auf einem Weg, der
wieder läuft.**

`nickview.cpp:2753`:

```cpp
bool CNicknamesViewLeft32::CheckDuplicateNickname(CNickname* pNickname)
{
    if(!pNickname) return false;
    if(m_NicknamesTree.CheckForDuplicateNicknameInTree()) { … }
```

Der Parameter wird **nur auf `NULL` geprüft und dann weggeworfen**. Die
eigentliche Prüfung (`nicktree.cpp:943`) holt sich ihr Vergleichsobjekt selbst,
aus `GetSelectedItem()`. Solange Karette und `TVIS_SELECTED` auf demselben
Eintrag stehen, ist das richtig — und dafür sorgt diese Fassung jetzt. Es
bleibt eine Falle: wer die Funktion künftig mit einem anderen `CNickname*`
ruft, prüft etwas anderes, als er denkt, ohne dass es auffällt.

Zweitens liest sie die Nutzlast **ohne Typprüfung**:

```cpp
CNicknamesTreeItemData *pSelNickData = (CNicknamesTreeItemData *) GetItemData(hSelItem);
CNickname *pSelNick = pSelNickData->m_u.pNickname;
```

`m_u` ist eine Union; steht die Karette auf einem Adressbuch**datei**-Element,
wird ein `CNicknameFile*` als `CNickname*` gelesen und `GetName()` darauf
gerufen. Erreichbar ist das auf dem heutigen Weg nicht (das Namensfeld gibt es
nur bei ausgewähltem Eintrag), aber die Funktion sagt das nirgends.

**Handlungsanweisung** (nach 1.0.119): in `CheckForDuplicateNicknameInTree()`
den übergebenen `CNickname*` als Parameter annehmen und verwenden, und vor dem
Zugriff auf `m_u.pNickname` `pSelNickData->m_itemType` gegen `ITEM_FILE`
prüfen — oder schlicht `GetSafeNickname(hSelItem)` benutzen, das es dafür schon
gibt (`nicktree.cpp:3711`).

---

<a id="k6"></a>

## K6 — Der Fokusverlust-Weg: stimmt die Reihenfolge? **Ja, und sie ist die einzig mögliche.**

**Einstufung: kein Mangel.**

Der neue Block (`nickview.cpp:624-655`) endet mit
`nickname->SetName(strEditText)` und läuft dann in den vorhandenen Teil:

```cpp
if(bIsKillFocus) {
    if(CheckEmptyNickname(strEditText) || pViewLeft->CheckDuplicateNickname(nickname)) {
        … m_NickNameEdit.SetWindowText(m_focusNickName); nickname->SetName(m_focusNickName); …
    } else { … }
}
```

**Kann ein doppelter Name durchrutschen? Nein.** Die Dublettenprüfung
vergleicht `pNick->GetName()` gegen `pSelNick->GetName()` — also **Objekt gegen
Objekt**, nicht gegen `strEditText` (`nicktree.cpp:943-972`). Sie sieht den
neuen Namen nur dann, wenn er **vorher** ins Objekt geschrieben wurde. Das
`SetName()` muss also davor stehen. Stünde es danach, prüfte sie den alten
Namen gegen die Geschwister und fände nie etwas. **Die Reihenfolge ist richtig,
und zwar notwendig so.**

**Kann ein gültiger Name fälschlich als doppelt gelten? Nein.** Die Schleife
schließt den eigenen Eintrag über den Handle-Vergleich aus
(`hSelItem != htChildIterItem`), nicht über den Namen. Ein unverändert
übernommener Name trifft also nur sich selbst und wird nicht gemeldet.

**Was passiert bei leerem Feld?** `CheckEmptyNickname(strEditText)` steht als
erster Operand des `||` und greift vor der Dublettenprüfung; der vorherige Name
wird aus `m_focusNickName` zurückgeschrieben, das Feld wird zurückgesetzt und
bekommt den Fokus wieder. Das war vorher schon so und bleibt so — **mit einer
Ausnahme**, siehe [K7](#k7).

Nachgerechnet, wie oft der neue Block überhaupt greift: Sobald die Behebung in
`nicktree.cpp` wirkt, trägt **jeder Tastendruck** den Namen schon ins Objekt
(`WM_CHAR`/`WM_KEYUP`/`WM_PASTE` → `UpdateEdit(false)` → der gemeinsame Schwanz
der Funktion mit `SetName`). Beim Fokusverlust sind `strEditText` und
`nickname->GetName()` dann **gleich**, die Bedingung
`strEditText != nickname->GetName()` ist falsch, und der neue Block läuft gar
nicht erst an. Er ist das Netz für den Fall, dass der Tastendruckweg wieder
ausfällt — und genau deshalb gehört er hin: vorher war das Netz ein `return`.

---

<a id="k7"></a>

## K7 — Leeres oder ungültiges Feld: Anzeige und Daten laufen auseinander

**Einstufung: hält nicht auf. Durch die Änderung nicht schlimmer geworden.**

`CNickname::IsValidNickName()` (`nickdoc.cpp:193`) weist einen **leeren** Namen
ab, ebenso führende und schließende Leerzeichen, Kommas und mehr als 32
Zeichen. Trifft das beim Fokusverlust zu, piept es und die Funktion kehrt
zurück (`nickview.cpp:629-636`) — **ohne** den alten Namen ins Feld
zurückzuschreiben. Das Feld zeigt dann weiter den unbrauchbaren Text, während
Objekt und Baum den alten Namen tragen, bis der Eintrag das nächste Mal
angezeigt wird.

Das war vor dem Commit **identisch** (dort stand an derselben Stelle ein
unbedingtes `return`, den `MessageBeep` eingeschlossen). Die Änderung
verschiebt daran nichts. Praktisch ist der Weg zudem schwer zu treffen: der
Tastendruckweg hat den Namen schon mitgeführt, also sind die beiden
Zeichenketten beim Fokusverlust gleich und die Prüfung läuft gar nicht an; dann
greift stattdessen `CheckEmptyNickname` mit sauberem Rückschreiben. Das
Eingabefeld ist außerdem auf 32 Zeichen begrenzt (`nickview.cpp:400`).

**Vorschlag** (nach 1.0.119): vor dem `return` dasselbe tun wie der
Dublettenzweig — `m_NickNameEdit.SetWindowText(nickname->GetName())` und
`SetFocus()`/`SetSel(0,-1)`. Dann sieht der Anwender, was gilt.

---

<a id="k8"></a>

## K8 — `SetValidateMode`: war das Weglassen ein eigener Fehler? **Ja. Und das Zurücksetzen hat keine Nebenwirkung.**

**Einstufung: kein Mangel.**

Die Funktion schaltet den Prüfmodus zu Beginn des `bValidate`-Blocks ab
(`nickview.cpp:623`, `SetValidateMode(false)`) und am Ende dreimal wieder an
(734, 735, 754). Die beiden alten frühen Ausstiege liefen an diesen drei Zeilen
**vorbei** — das Objekt blieb dauerhaft im Zustand „nicht prüfen".

Das ist nicht folgenlos:

```cpp
BOOL CNickname::HasValidName() const
{
    if (!m_bValidate) return TRUE;        // nickdoc.cpp:183
    …
}
```

Im Zustand „nicht prüfen" liefert `HasValidName()` **bedingungslos `TRUE`**.
Damit ist unter anderem die Selbstheilung in `NICKNAME_HINT_DISPLAYNICKNAME`
stillgelegt (`nickview.cpp:996-1005`:
`if (!p_nickname->HasValidName()) { CreateValidName(NULL); … }`) — ein
unbrauchbarer Name wird beim nächsten Anzeigen nicht mehr repariert. Der
Normalzustand ist `true`: so setzt ihn der Konstruktor (`nickdoc.cpp:89`), und
so setzen ihn alle regulären Ausgänge. **Das Zurücksetzen stellt also nur
wieder her, was ohnehin gilt, und kann nichts kaputtmachen.**

Eine Nebenwirkung habe ich ausdrücklich gesucht und nicht gefunden: der einzige
weitere Leser von `m_bValidate` ist `VERIFY(HasValidName())` in
`CNickname::SetName()` — und `VERIFY` ist im Freigabebau nur die Auswertung
ohne Prüfung, im Fehlersuchbau eine Zusicherung. Im Fehlersuchbau bedeutet das
Zurücksetzen: ein `SetName()` mit unbrauchbarem Namen meldet sich jetzt wieder,
statt still durchzugehen. Das ist der gewünschte Zustand.

---

<a id="k9"></a>

## K9 — Die übrigen `SelectItem()`-Stellen im Baum

**Einstufung: hält nicht auf.**

Vollständige Liste aller `SelectItem()`-Aufrufe in `CNicknamesTreeCtrl`
(Zeilennummern nach meiner Kommentarberichtigung):

| Zeile | Funktion | Vorher `DoDeselectAll()`? | Betroffen? |
| --- | --- | --- | --- |
| 508 | `AddNewNickname` | ja | behoben (523); in der Normallage unnötig — [K2](#k2) |
| 626 | `RestoreVisualState` | nein | **nein** — die Karette ist dort noch `NULL`, das Bit wird gesetzt |
| 881 | `NicknameWasChanged` | bedingt | behoben (894); **das war der Fehler** |
| 2941 | `OnRightButtonDown` | **ja, unmittelbar davor** | **ja — offen** |
| 2988 | `OnBeginDrag` | — | nein, `SelectItem(NULL)` räumt ab |
| 4530, 4562, 4590, 4618, 4639, 4666 | `DoFindNext` (6×) | nein | nicht am Bit; siehe unten |

**Die eine offene Stelle, `OnRightButtonDown` (2933-2942):**

```cpp
if (! IsItemSelected(tvhit.hItem))
{
    DoDeselectAll();
    SelectItem(tvhit.hItem);
}
```

Das ist Zeile 2 meiner Messtabelle, Wort für Wort: trägt das angeklickte
Element schon die Karette, ist es aber nicht ausgewählt, dann löscht
`DoDeselectAll()` nichts Neues und `SelectItem()` tut nichts — der Rechtsklick
wählt den Eintrag **nicht** aus. Erreichbar: erst mit der rechten Maustaste in
den leeren Bereich unter die Einträge klicken (der `else`-Zweig räumt ab,
`m_LastEvaluatedSelectionState` wird `SELSTATE_NONE`, die Karette bleibt aber
stehen), dann denselben Eintrag rechts anklicken. Es folgt keine
`TVN_SELCHANGED` und damit keine `EvaluateSelection()`, der Zustand bleibt
`SELSTATE_NONE`, und `OnInitMenuPopup` baut ein Kontextmenü, in dem *New*,
*Delete* und *Rename* **ausgegraut** sind. Kein Datenverlust, keine falsche
Zeile — nur ein totes Menü.

*Nicht gemessen* (am Quelltext und an der Messtabelle hergeleitet), deshalb
rühre ich es **vor** 1.0.119 nicht an: eine Verhaltensänderung, die ich nicht
selbst am laufenden Programm rot und dann grün gesehen habe, gehört nicht in
ein Paket (Lehre *erst-nachstellen-dann-ausliefern*).

**Handlungsanweisung** (nach 1.0.119): hinter Zeile 2941 dasselbe
`DoSelectItem(tvhit.hItem, TRUE);` wie an den beiden behobenen Stellen, dazu
`EvaluateSelection()`, weil ohne Karettenwechsel keine Benachrichtigung kommt.

**`DoFindNext` (sechsmal):** Diese Stellen rufen **kein** `DoDeselectAll()`
vorher. Der Treffer bekommt die Karette und damit nach Zeile 1 der Messtabelle
sein Bit, und das Bit der alten Karette fällt weg. Das Bit-Problem gibt es dort
also nicht. Was es dort gibt: bestand vorher eine **Mehrfachauswahl**, bleiben
deren übrige Bits stehen, und `GetFirstSelectedNickorFile()` (4445) — der
Startpunkt des nächsten *Weitersuchen* — liefert dann nicht den Treffer,
sondern den ersten ausgewählten Eintrag in Baumreihenfolge. *Weitersuchen*
kommt dann nicht vom Fleck. Vorbestehend, unabhängig von [E-134](../BEFUNDE.md#e-134), und keine Zeile
dieses Commits berührt es.

---

<a id="k10"></a>

## K10 — `m_focusNickName`: ein Leck und ein `strcpy` ohne Schranke

**Einstufung: hält nicht auf. Vorbestehend.**

`nickview.cpp:715-718`:

```cpp
if(!m_bFoundDupNickName) {
    m_focusNickName = DEBUG_NEW char[256];
    strcpy(m_focusNickName, (LPCTSTR)nickname->GetName());
}
```

Der alte Zeiger wird **nicht** freigegeben — anders als bei `m_selNickName`
drei Zeilen darüber (706-708), wo es ausdrücklich geschieht. Jeder Fokusgewinn
im Namensfeld verliert also 256 Byte. Zweitens kennt der `strcpy` keine
Schranke; das Eingabefeld begrenzt auf `MAX_NAME_LENGTH` = 32, aber ein von
Hand oder durch Einlesen entstandener Name in der `NNdbase.txt` kann länger
sein, und `CNickname::SetName()` kürzt nicht.

Beides stand vor diesem Commit schon so da und wird von ihm nicht berührt.
**Handlungsanweisung** (nach 1.0.119): `delete [] m_focusNickName;` davor,
`strncpy` mit `sizeof`-Schranke und abschließender Null — oder beide Felder auf
`CString` umstellen, wie es der Rest der Klasse tut.

---

<a id="k11"></a>

## K11 — Byte-Disziplin

**Einstufung: kein Mangel. Gemessen.**

| Datei | vorher (`3819758a`) | nach `14786286` | nach meiner Berichtigung |
| --- | --- | --- | --- |
| `nicktree.cpp` | CRLF 18, nur-LF 4818, >127 **0** | CRLF 18, nur-LF 4839, >127 **0** | CRLF 18, nur-LF 4846, >127 **0** |
| `nickview.cpp` | CRLF 18, nur-LF 3213, >127 **0** | CRLF 18, nur-LF 3242, >127 **0** | unverändert |

Die Zahl der CRLF ist in allen drei Ständen **18**, die geforderte. Kein Byte
über 127 ist hinzugekommen: die neuen Kommentare sind durchgehend in
ASCII-Umschrift („geloescht", „traegt", „ausgewaehlt"), wie es die übrigen
Kommentare dieser Dateien auch halten. Die `.md` im Wurzelverzeichnis sind
weiterhin reines LF ohne BOM.

---

<a id="k12"></a>

## K12 — Der Weg steht in keinem Test, und das bleibt so

**Einstufung: hält nicht auf.**

Der Commit sagt es selbst: *„243 Tests, 243 bestanden — die Suite deckt diesen
Weg allerdings NICHT ab."* Das stimmt, und es lässt sich auch nicht ohne
weiteres ändern: `CNicknamesTreeCtrl` ist ein `CTreeCtrl` in einem
Splitterfenster, und die Prüfgröße (*kommt `alias hans` in der `NNdbase.txt`
an?*) hängt am ganzen Adressbuchfenster.

Was sich **schon** prüfen ließe, und zwar ohne Eudora: die Regel aus
[K1](#k1). Ein Test, der ein nacktes `SysTreeView32` anlegt, ein Element
auswählt, sein `TVIS_SELECTED` löscht und `SelectItem()` auf dasselbe Element
ruft, hält genau die Annahme fest, an der die beiden Einbauten hängen — und
schlägt an, falls eine künftige Common-Controls-Fassung sie ändert. Dieselbe
Messung, die ich für diesen Bericht gefahren habe, in 40 Zeilen.

**Kein Grund, 1.0.119 zu halten**, aber der Eintrag gehört in `TESTPLAN.md`.

---

<a id="behoben"></a>

## Was ich behoben habe

Eine Sache, und sie ändert **keinen Ausführungspfad**:

* **[K1](#k1)** — die falsche Ursachenbeschreibung, an sechs Stellen: die beiden
  Kommentarblöcke in `nicktree.cpp` (bei 508 und bei 881), der Abschnitt *„Eine
  Zeile, die auswählt, ohne auszuwählen"* in `CHANGELOG.md` samt der Stelle
  *„Warum `SelectItem()` den Zustand nicht mehr setzt, ist nicht gemessen"*,
  die Ursachenzeile und der Absatz *„Nicht gemessen und weiterhin offen"* in
  `BEFUNDE.md`, der Stand-Absatz in `PORTIERUNG.md` und der Kopfsatz in
  `AUFGABEN.md`. Überall steht jetzt
  die gemessene Regel samt Messtabelle, und die Common-Controls-Vermutung ist
  als widerlegt gekennzeichnet. Dazu der Zeilenverweis
  `nicktree.cpp:936-941` → `877-894`.

**Gemessen nach der Änderung:** Release gebaut — **ERFOLG, 0 Fehler, 2
Warnungen**; `EudoraTests.exe` — **243 Tests, 243 bestanden**.

Nicht angefasst habe ich die offenen Stellen aus [K5](#k5), [K7](#k7),
[K9](#k9) und [K10](#k10). Alle vier sind Verhaltensänderungen, und keine davon
habe ich am laufenden Programm rot gesehen. Sie gehören in einen eigenen Zweig
nach 1.0.119, nicht in das Paket.

---

## Was diese Prüfung nicht abdeckt

* **Den Lauf selbst.** Ich habe Eudora nicht gestartet (Absprache: nichts auf
  Gregors Bildschirm). Die drei Läufe `alias hans` gegen `alias Untitled`
  stehen so, wie der Commit sie berichtet; nachgemessen habe ich sie nicht.
* **Warum die Karette in `AddNewNickname` dort steht, wo sie steht.** Siehe
  [K2](#k2). Das ist die Frage, die [K1](#k1) neu aufmacht, und sie braucht
  eine Spurmarke im laufenden Programm.
* **Warum es in Hermes ging.** Meine Messung schließt die Fassung der Common
  Controls als Erklärung aus, mehr nicht. Ein Hermes 7.1 zum Gegenmessen gibt
  es hier nach wie vor nicht.
* **Das Adressbuch jenseits dieser beiden Funktionen** — Ziehen und
  Fallenlassen, *Move To*/*Copy To*, Umbenennen über die Baumbeschriftung
  (`OnBeginLabelEdit`/`OnEndLabelEdit`), Import und Export. Gelesen habe ich
  sie nur dort, wo sie die Auswahl berühren.
