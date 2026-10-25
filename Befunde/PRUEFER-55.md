# <a id="pruefer-55"></a>PRUEFER-55 — Strg-W in der Wazoo-Leiste (E-137) und die zwei Nachbesserungen an den Prüfwerkzeugen, nachgerechnet gegen die Quelle, 25.10.2026

**Auftrag.** Geprüft wurde, was `git log --stat bef3aac0..HEAD -- Eudora71 tools`
zeigt (Stand `2742bd6e`, Zweig `wt/pruefer-20261025e`). Das sind die Behebung
von [E-137](../Intern/BEFUNDE.md#e-137) in `Eudora71/Eudora/mainfrm.cpp` mit dem Test
`Eudora71/Tests/TestE137.cpp` (`ed0d53a2`), die Behebung von
[PRUEFER-54 K1](PRUEFER-54.md#k1) und [K2](PRUEFER-54.md#k2) in `tools/messen-e97.ps1` (`b5d3bcf9`) und die
LF-Fassung von `tools/pruefstand-lauf.ps1` (`ec468df6`). Eudora wurde weder
gebaut noch gestartet. Die Testsuite lief nur in meinem Arbeitsbaum.

**Ergebnis vorweg.**

* **Die Behebung von [E-137](../Intern/BEFUNDE.md#e-137) wirkt im angedockten Fall so, wie sie soll** (am
  Quelltext belegt). Strg-W in einer angedockten Leiste schickt der Leiste
  denselben Befehl wie Rechtsklick → *Hide*, und der Befehl geht nicht weiter.
  Ein Eingabefeld in einem Verfassen-Fenster löst die Abfangung nicht aus.
  Am laufenden Programm ist das weiterhin nicht gemessen.
* **Die Abfangung trifft auch die schwebende Leiste, und die hat laut Gregor
  vorher schon richtig geschlossen** ([K1](#k1)). Die Bedingung „kein
  MDI-Fenster“ ist in diesem Bau immer erfüllt, denn eine Leiste als
  MDI-Fenster gibt es in der Nachbildung der Leistenbibliothek noch gar nicht.
  Was dort vorher „regulär“ geschah, wird jetzt durch *Hide* ersetzt. Das ist
  wahrscheinlich dasselbe Bild, gemessen ist es nicht. Gregor sollte im
  Testpaket beide Fälle prüfen: angedockt und schwebend.
* **Der Regressionstest sieht vier von fünf Rückfällen nicht** ([K2](#k2),
  gemessen). Er sucht Textstellen, prüft aber nicht, ob die Bedingung
  überhaupt greifen kann.
* **Nach dem Verstecken bleibt der Eingabeschwerpunkt vermutlich in der
  unsichtbaren Leiste** ([K3](#k3), Vermutung). Dann tut ein zweites Strg-W
  nichts, auch nicht für das Postfach daneben.
* **[PRUEFER-54](PRUEFER-54.md#pruefer-54) K2 ist behoben, [PRUEFER-54](PRUEFER-54.md#pruefer-54) K1 nur verkleinert** ([K4](#k4)).
  Eudora schreibt die Eudora.ini beim Beenden schon, bevor die beiden
  geprüften Werte auf die Platte kommen. Ein Absturz genau dazwischen zählt
  weiterhin als `ini=ok`.
* **`pruefstand-lauf.ps1` schreibt die Dauerdatei richtig** (gemessen: nur LF,
  kein BOM).
* **Keiner der Funde hält das Release 7.2.1.x auf.** K1 bis K3 betreffen
  höchstens, wie eine Leiste verschwindet. Daten gehen dabei nicht verloren.
  K4 betrifft das Prüfwerkzeug.

**Testsuite** (gemessen, in meinem Baum): 302 Tests, 302 bestanden, vorher
und nach allen Rückfallproben. `mainfrm.cpp` ist nach jeder Probe byte-gleich
zurück (SHA-1 verglichen), danach `touch`.

## Was nachgerechnet wurde

**1. Greift die Abfangung, wenn der Schwerpunkt in einem Verfassen-Fenster liegt?**
Nein, am Quelltext belegt. `CWazooBarMgr::GetWazooBarWithFocus`
(`WazooBarMgr.cpp:1019-1037`) liefert nur dann eine Leiste, wenn das Fenster
mit dem Schwerpunkt ein Nachfahre dieser Leiste ist (`IsChild`). Ein
Verfassen-Fenster ist ein MDI-Kindfenster des Hauptfensters und liegt unter
keiner Leiste. Dann ist das Ergebnis `NULL`, und der Befehl läuft auf dem
alten Weg weiter (`mainfrm.cpp:3477-3478`).

**2. Ist `pExtra` bei `CN_UPDATE_COMMAND_UI` immer ein `CCmdUI*`?**
Ja, nach dem MFC-Vertrag (Vermutung über MFC, nicht im Repo nachgelesen):
`CCmdUI::DoUpdate` ruft `OnCmdMsg(nID, CN_UPDATE_COMMAND_UI, this, NULL)`
auf. `CWnd::OnCommand` übergibt dort ein `CTestCmdUI`, das ebenfalls ein
`CCmdUI` ist. Die Abfrage `if (pExtra)` (`mainfrm.cpp:3483`) schadet nicht.
Der Fall `CN_COMMAND` mit `pHandlerInfo != NULL` ist nur eine Anfrage „gibt
es einen Behandler?“. Darauf antwortet der Code mit TRUE und verschickt
nichts (`mainfrm.cpp:3486-3491`). Das ist richtig.

**3. Erreicht `ID_SEC_HIDE` per `PostMessage` an die Leiste wirklich `SECControlBar::OnHide`?**
Ja, am Quelltext belegt. `CWazooBar` (`WazooBar.cpp:41-59`) hat keinen
Eintrag für `ID_SEC_HIDE` und überschreibt `OnCmdMsg` nicht. Die Tabelle
reicht also an `SECControlBar` weiter, und dort steht
`ON_COMMAND(ID_SEC_HIDE, &SECControlBar::OnHide)` (`OTShim.cpp:1775`).
`OnHide` ruft `ShowControlBar(this, FALSE, FALSE)` (`OTShim.cpp:2491-2498`).
Derselbe Weg mit `SendMessage` ist schon in Gebrauch: Rechtsklick → *Hide*
(`WazooWnd.cpp:513`) und das Ausblenden beim Start (`WazooBarMgr.cpp:483`,
`802`). Die Werbeleiste sperrt den Befehl (`AdWazooBar.cpp:46`, `50`). Dort
tut Strg-W also nichts mehr. Das ist harmlos.

**4. Wer beendete Eudora vorher?**
Am Quelltext nicht entschieden. Auf dem Weg vom Hauptfenster über das
Wazoo-Fenster zum aktiven MDI-Fenster gibt es nur zwei Behandler für
`ID_FILE_CLOSE`: `CDoc::OnFileClose` (`doc.cpp:109`) und
`CMessageDoc::OnFileClose` (`msgdoc.cpp:510`). Beide schließen ein Dokument
und nicht das Programm. Es bleibt wie in [E-137](../Intern/BEFUNDE.md#e-137): nicht gemessen.

## <a id="k1"></a>K1 — Die Abfangung trifft auch die schwebende Leiste; „nur Nicht-MDI“ ist immer wahr

**Was passiert.** Die Behebung soll nur angedockte Leisten treffen. Laut
Kommentar und [E-137](../Intern/BEFUNDE.md#e-137) bleibt es „als MDI-Fenster beim richtigen Weg über
`QCControlBarWorksheet::OnCmdMdiClose`“. In diesem Bau kann aber keine Leiste
ein MDI-Fenster sein:

* `SECControlBar::IsMDIChild` liest `m_bMDIChild` der Andockleiste
  (`OTShim.cpp:1914-1918`). Der Kommentar direkt darüber sagt: „da
  FloatControlBarInMDIChild nichts tut, gibt es keine solche Andockleiste,
  und die Antwort ist immer FALSE“ (`OTShim.cpp:1906-1913`).
* `SECMDIFrameWnd::FloatControlBarInMDIChild` gibt nur eine TRACE-Zeile aus
  (`OTShim.cpp:372-376`). `CreateFloatingMDIChild` liefert `NULL`, und
  `SECDockContext::ToggleMDIFloat` ist leer (`OTShim.cpp:5524-5529`), beides
  „Stufe 2 offen“.

Am Quelltext belegt: `!pFokusLeiste->IsMDIChild()` (`mainfrm.cpp:3478`) ist
immer wahr. Gregors „nicht angedocktes Fenster“, das „ganz regulär
geschlossen“ wird ([E-137](../Intern/BEFUNDE.md#e-137)), kann deshalb nur die **schwebende** Leiste sein.
Auch sie hat den Schwerpunkt in einem Nachfahren der Leiste und wird jetzt
abgefangen. Statt des alten, ungeklärten Wegs bekommt sie *Hide*.

**Was verloren gehen kann.** Nichts. *Hide* versteckt nur und schließt
nichts. Vermutlich sieht der Anwender dasselbe wie vorher: die Leiste ist
weg. Gemessen ist das nicht. Die Spurmarke sagt dann allerdings
„angedockte Wazoo-Leiste“, obwohl die Leiste schwebt.

**Folge für die Prüfung.** Gregor sollte im Testpaket beide Fälle prüfen,
angedockt und schwebend. Kommentar und Befundtext sollten nicht mehr
behaupten, dass ein MDI-Fall ausgenommen ist, den es in diesem Bau gibt.

**Schwere:** niedrig. Ein Weg, der vorher funktionierte, läuft jetzt anders,
vermutlich mit demselben Ergebnis.

## <a id="k2"></a>K2 — Der Regressionstest sieht vier von fünf Rückfällen nicht

Gemessen: Ich habe `mainfrm.cpp` jeweils an einer Stelle vorübergehend
geändert (Perl, `:raw`, genau ein Treffer), die Suite laufen lassen und die
Datei byte-gleich zurückgeschrieben.

| Probe | Änderung | Wirkung im Programm | Test |
|---|---|---|---|
| p1 | `nCode == CN_COMMAND \|\|` entfernt | Strg-W wird nicht mehr abgefangen, der alte Fehler ist zurück | **grün** (302/302) |
| p2 | `pHandlerInfo == NULL` → `!= NULL` | die Leiste wird nie versteckt, Strg-W tut nichts | **grün** |
| p3 | `pFokusLeiste = NULL` statt `GetWazooBarWithFocus()` | die Abfangung greift nie, der alte Fehler ist zurück | **grün** |
| p4 | Bedingung `… && pFokusLeiste->IsMDIChild()` ergänzt (immer falsch) | die Abfangung greift nie | **grün** |
| p5 | `return TRUE;` nach dem Verstecken entfernt | der Befehl läuft weiter | rot (301/302) |

Der Test (`TestE137.cpp:33-53`) prüft nur, ob Textstücke vorkommen und in
welcher Reihenfolge. Ob die Bedingung erfüllbar ist, für welche `nCode` sie
gilt und woher die Leiste kommt, prüft er nicht. Die Anzahl der Tests blieb
bei allen Proben 302.

**Schwere:** niedrig. Das ist eine Schwäche des Prüfwerkzeugs, Eudora selbst
ist nicht betroffen.

## <a id="k3"></a>K3 — Nach dem Verstecken bleibt der Schwerpunkt vermutlich in der unsichtbaren Leiste

Vermutung. `OnHide` versteckt die Leiste (`OTShim.cpp:2497`). Den
Schwerpunkt setzt dabei niemand um, weder `OnHide` noch die Behebung
(`mainfrm.cpp:3486-3492`). Nach meiner Kenntnis von Win32 verschiebt
`ShowWindow(SW_HIDE)` den Tastaturfokus eines Kindfensters nicht (nicht
gemessen). Dann liefert `GetWazooBarWithFocus` beim nächsten Strg-W wieder
die versteckte Leiste (`IsChild` prüft nicht, ob sie sichtbar ist). Der
Befehl wird erneut abgefangen und versteckt etwas, das schon versteckt ist.
Das Postfach `In` daneben lässt sich dann weder mit Strg-W noch über
*File → Close* schließen, bis der Anwender hineinklickt. Rechtsklick →
*Hide* hat dieselbe Eigenschaft (`WazooWnd.cpp:513`). Neu ist sie also
nicht, nur leichter zu erreichen.

**Möglicher Ausweg:** in der Bedingung zusätzlich `IsWindowVisible()`
verlangen und nach dem Verstecken den Schwerpunkt an das aktive MDI-Fenster
geben.

**Schwere:** niedrig (Vermutung, kein Datenverlust).

## <a id="k4"></a>K4 — PRUEFER-54 K1 nur verkleinert: der Zeitstempel wird vor den geprüften Werten neu

Die Nachbesserung zählt das Ergebnis nur, wenn die Eudora.ini nach dem
Schließbefehl einen neueren Zeitstempel trägt (`messen-e97.ps1:269-278`). Das
schließt den Absturz vor jedem Schreiben aus. Eudora schreibt die Datei beim
Beenden aber schon vor dem Flush in zwei Schritten (am Quelltext belegt):

* `CMainFrame::CloseDown` ruft `SaveOpenWindows(TRUE)` auf
  (`mainfrm.cpp:5793`). Das schreibt direkt mit `WritePrivateProfileString`
  (`mainfrm.cpp:2627`, `2738`).
* Danach kommt `SaveBarState("ToolBar")` (`mainfrm.cpp:5886`).

`IncludeHeaders` und `GuessParagraphs` kommen erst mit
`IniStringCleanUp` → `FlushINIFile` in `ExitInstance` auf die Platte
(`eudora.cpp:2127`, [PRUEFER-54](PRUEFER-54.md) Punkt 2). Stürzt Eudora zwischen
`CloseDown` und `ExitInstance` ab, ist der Zeitstempel schon neu, die beiden
Werte stehen aber nicht in der Datei. Das Skript meldet dann trotzdem
`ini=ok`. Gemessen ist dieser Absturz nicht. Er ist auch nicht beobachtet
worden.

**Dazu am Rande:** Der Schlaf von 1,1 s liegt nach dem Lesen von `$vorher`
(`messen-e97.ps1:269-271`). Wer in dieser Zeit schreibt, zählt mit. Sicherer
wäre es, die geprüften Werte in der Datei mit einem Wert vor dem Lauf zu
vergleichen.

**[PRUEFER-54](PRUEFER-54.md#pruefer-54) K2 ist behoben** (am Quelltext belegt). Findet `Dialoge` keinen
passenden Knopf, schickt es jetzt `IDCANCEL` (`messen-e97.ps1:149`). Beim
Beenden steht „Just quit“ im Muster (`:274`). Der Knopf heißt in beiden
Fassungen des Dialogs `Just &quit` (`EudoraRes.rc:2089`, `2106`). Das `&` wird
vor dem Vergleich entfernt (`messen-e97.ps1:139`), und die Knöpfe „Send
them, then quit“ treffen das verankerte Muster nicht. Der Verweis
`mainfrm.cpp:5396-5398` im Kommentar stimmte bei `b5d3bcf9`. Nach [E-137](../Intern/BEFUNDE.md#e-137) steht
die Stelle 36 Zeilen tiefer (`mainfrm.cpp:5432-5434`). Das ist nur ein
Hinweis und kein eigener Fund.

**Schwere:** niedrig. Das Prüfwerkzeug kann in einem engen,
unbeobachteten Fall fälschlich grün melden.

## `tools/pruefstand-lauf.ps1`

In Ordnung. `WriteAllText` mit `-join "`n"`, einem abschließenden LF und
`UTF8Encoding $false` (`pruefstand-lauf.ps1:388`) ergibt UTF-8 ohne BOM und nur
LF. Gemessen an `Intern/pruefstand-dauer.txt`: CRLF 0, nur-LF 5, Bytes über 127
0, kein BOM.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Release 7.2.1.x auf? |
|---|---|---|---|
| [K1](#k1) | Die Behebung von [E-137](../Intern/BEFUNDE.md#e-137) fängt Strg-W auch in der **schwebenden** Leiste ab, weil „kein MDI-Fenster“ in diesem Bau immer gilt. Dort lief vorher schon alles richtig. Jetzt kommt *Hide*, vermutlich mit demselben Bild. | niedrig | nein |
| [K2](#k2) | Der Regressionstest zu [E-137](../Intern/BEFUNDE.md#e-137) bleibt bei vier von fünf eingebauten Rückfällen grün, darunter zwei, die den alten Fehler zurückbringen (gemessen). | niedrig (Prüfwerkzeug) | nein |
| [K3](#k3) | Nach dem Verstecken bleibt der Tastaturfokus vermutlich in der unsichtbaren Leiste. Ein zweites Strg-W tut dann nichts, auch nicht für das Postfach daneben. | niedrig (Vermutung) | nein |
| [K4](#k4) | `messen-e97.ps1`: Der Zeitstempel der INI wird beim Beenden neu, bevor die geprüften Werte geschrieben sind. Ein Absturz dazwischen zählt weiter als `ini=ok`. [PRUEFER-54](PRUEFER-54.md#pruefer-54) K2 ist behoben. | niedrig (Prüfwerkzeug) | nein |
