# <a id="pruefer-63"></a>PRUEFER-63 — Kurzprüfung der Behebung von PRUEFER-62 K1 und K2 (E-137), 27.10.2026

**Auftrag.** Kurzprüfung, Umfang nur Commit `9c88d1c2`. Er behebt
[PRUEFER-62 K1](PRUEFER-62.md#k1) (Strg+W versteckt eine Leiste, aus der
gerade ein Fenster geöffnet wurde) und [K2](PRUEFER-62.md#k2) (Ausnahme für
die Taste W ohne Test). Geändert sind `mainfrm.cpp`, `mainfrm.h` und
`TestE137.cpp`. Die vier Fragen stellte der Auftraggeber.

Eudora wurde weder gebaut noch gestartet, kein Prüfstand lief. Die
Testsuite habe ich **nicht** erneut gefahren. Die Zahlen 314/314 und die
Gegenprobe 313/314 stammen aus der Commit-Nachricht und sind von mir nicht
wiederholt. Die MFC-Stellen stammen aus der Quelle auf diesem Rechner
(`VC/Tools/MSVC/14.38.33130/atlmfc/src/mfc`).

**Ergebnis vorweg.**

* **Die Behebung hält für Gregors Fall aus [PRUEFER-62](PRUEFER-62.md#pruefer-62).** Wer in *Mailboxes*
  ein Postfach doppelklickt, das noch nicht offen ist, bekommt ein neues
  aktives Fenster. Strg+W schließt danach das Postfach, die Leiste bleibt.
  Dasselbe gilt für ein offenes Postfach, das erst nach vorn geholt wird.
  Das ist am Quelltext belegt, am Programm misst es erst Gregors V6.
* **Gregors Fälle V1 bis V3 bleiben unberührt.** Ein Klick auf Titelzeile,
  Rand oder Beschriftung einer Leiste wechselt das aktive Postfach- oder
  Mailfenster nicht. Die Marke gilt also weiter (am Quelltext belegt).
* **Es bleibt ein Restfall, aber er ist nicht neu** ([K1](#k1)). Wer das
  Postfach doppelklickt, das **schon** vorn ist, ändert nichts am aktiven
  Fenster. Dann versteckt Strg+W die Leiste *Mailboxes*. Vermutlich liegt
  der Fokus in diesem Fall ohnehin noch im Baum der Leiste. Dann hätte
  Strg+W die Leiste auch vor dem fünften Anlauf versteckt. Es geht nichts
  verloren.
* **Wechsel in den schwebenden Rahmen löscht die Marke nicht**. Windows
  meldet einen Wechsel des Programms nur zwischen Threads, und der Rahmen
  gehört zum selben Thread (Windows-Verhalten, nicht gemessen).
* **V6 misst K1 richtig, wenn `Trash` vorher nicht das vorderste Fenster
  ist** ([K3](#k3)). Diese Vorbedingung steht nicht im Testplan.
* **Entwertet ein Fund Gregors Kurztest an 1.0.127? Nein.** Kein Fund
  hält das Paket auf.

## Frage (1) — Hält die Behebung von K1?

**Für den gemeldeten Fall ja** (am Quelltext belegt).

* Der Doppelklick ruft `CMboxTreeCtrl::OnLButtonDblClk`, das
  `Execute(CA_OPEN)` ausführt (`mboxtree.cpp:1371-1416`). Das endet in
  `CTocDoc::Display` (`tocdoc.cpp:3525-3554`).
* **Postfach noch nicht offen.** `NewChildFrame` legt ein neues
  MDI-Fenster an. MFC aktiviert es beim Anlegen (`winmdi.cpp:559`) oder in
  `ActivateFrame` (`winmdi.cpp:715`). Zum Zeitpunkt von Strg+W liefert
  `MDIGetActive()` also das neue Fenster. Es ist nicht das Fenster, das beim
  ersten Klick des Doppelklicks gemerkt wurde (`mainfrm.cpp:3433-3434`).
  `bMdiGewechselt` wird wahr, und die Marke verfällt
  (`mainfrm.cpp:3501-3504`).
* **Postfach offen, aber nicht vorn.** `Display` ruft
  `Frame->MDIActivate()`. Das aktive Fenster wechselt, die Marke verfällt
  wie oben.
* **Postfach offen und minimiert.** `Display` ruft nur `MDIRestore()`.
  **Vermutung:** Windows aktiviert das Fenster beim Wiederherstellen. Wenn
  nicht, bleibt der Fokus im Baum, und Strg+W versteckt die Leiste über die
  Fokusprüfung, unabhängig von der Marke.
* **Postfach schon vorn.** Siehe [K1](#k1).
* **`MDIGetActive` ist im Port nicht überschrieben.** Ich fand keine eigene
  Fassung in `Eudora71`. MFC fragt den MDI-Client mit `WM_MDIGETACTIVE` und
  liefert `NULL`, solange es keinen Client gibt (`winmdi.cpp:309-333`). Ein
  Aufruf vor dem Anlegen des Clients ist also harmlos.
* **Andere Wege, die in [PRUEFER-62](PRUEFER-62.md#pruefer-62) „nein“ hatten**, etwa das Kontextmenü
  *Open* oder eine neue Nachricht aus *Stationery*, öffnen ebenfalls ein
  neues MDI-Fenster. Damit sind sie auf dieselbe Weise gedeckt. Für den
  Ausflug in ein anderes Programm sorgt jetzt `OnActivateApp`
  (`mainfrm.cpp:1636-1645`). Offen bleiben Mausrad und mittlere Taste. Sie
  ändern weder das aktive Fenster noch das Programm, sind also ohne Belang.

## Frage (2) — Bricht die Behebung V1 bis V3?

**Nein** (am Quelltext belegt).

`MDIGetActive` liefert das aktive Kindfenster des MDI-Clients. Welches
Fenster der obersten Ebene aktiv ist oder wo der Fokus liegt, spielt dafür
keine Rolle. Das aktive Kindfenster wechselt in MFC nur an diesen Stellen:

* beim Anlegen eines Kindfensters (`winmdi.cpp:559`),
* in `CMDIChildWnd::ActivateFrame` (`:715`),
* bei einem Mausklick **in** ein Kindfenster
  (`CMDIChildWnd::OnMouseActivate`, `:704-716`),
* beim Verstecken des letzten Kindfensters (`:796`, `:804`).

Eudora selbst ruft `MDIActivate` in `WazooBarMgr.cpp:977` nur für Leisten,
die als MDI-Kind laufen. `IsMDIChild` liefert im Port immer `FALSE`
([PRUEFER-62](PRUEFER-62.md#pruefer-62), Frage d).

Bei V1 und V2 läuft dagegen `CMiniDockFrameWnd::OnNcLButtonDown` mit
`ActivateTopParent`, und der kleine Rahmen bzw. das Hauptfenster wird aktiv.
Das sind Fenster der obersten Ebene, kein Kindfenster des MDI-Clients. Das
aktive Mailfenster bleibt dasselbe, also gilt die Marke. V3 (angedockt,
Klick auf eine Beschriftung) aktiviert gar nichts. Auch Ziehen und Andocken
des Rahmens berühren das aktive Kindfenster nicht.

Der erste Klick in die Mail setzt die Marke nicht, denn er trifft keine
Leiste. Dabei wird allerdings `m_hE137MdiBeiKlick` neu gesetzt
(`mainfrm.cpp:3433-3434`, für jeden Klick). Der zweite Klick auf den Rahmen
setzt beide Werte dann gemeinsam neu. Für V1 bis V3 ist das gleichgültig,
für die Spurzeile nicht ([K2](#k2)).

## Frage (3) — Ruft Windows `OnActivateApp(FALSE)`, wenn der Fokus an den eigenen schwebenden Rahmen geht?

**Nein** (Windows-Verhalten laut Doku, nicht gemessen). `WM_ACTIVATEAPP`
geht an alle Fenster der obersten Ebene, wenn die Aktivierung zu einem
Fenster eines **anderen Threads** wechselt. Das zeigt schon der Parameter
`dwThreadID`. Der schwebende Rahmen wird im Oberflächen-Thread von Eudora
angelegt, dasselbe gilt für die IE-Kontrolle der Mail. Ein Klick auf den
Rahmen ist also kein Programmwechsel, und die Marke bleibt.

Kommt Eudora durch einen Klick auf den Rahmen aus dem Hintergrund nach
vorn, geht die Aktivierung `WM_ACTIVATEAPP(TRUE)` dem Klick voraus. Gelöscht
wird nur bei `FALSE`. Die anschließend gesetzte Marke gilt also (Vermutung
zur Reihenfolge, Windows-Verhalten).

Sollte ein Fenster eines anderen Eudora-Threads aktiv werden, etwa eine
Meldung aus einem Hintergrund-Thread, verfällt die Marke. Das ist richtig,
denn der Anwender hat dann woanders gearbeitet.

## Frage (4) — Misst V6 den Fund richtig?

**Ja, mit einer fehlenden Vorbedingung** ([K3](#k3)). An 1.0.126 hätte V6
die *Mailboxes*-Leiste versteckt, an 1.0.127 schließt es das Postfach. Der
Schritt unterscheidet also die beiden Fassungen, sofern `Trash` vorher
**nicht** das vorderste Fenster ist.

## <a id="k1"></a>K1 — Doppelklick auf das Postfach, das schon vorn ist

**Was passiert** (Logik am Quelltext belegt, Fokuslage Vermutung). Gregor
hat `In` offen und vorn und doppelklickt in *Mailboxes* auf `In`.
`CTocDoc::Display` ruft `MDIActivate()` auf das Fenster, das schon aktiv
ist. Das aktive Kindfenster ändert sich nicht, `bMdiGewechselt` bleibt
falsch, und die Marke gilt. Drückt er Strg+W, verschwindet die Leiste
*Mailboxes*, und `In` bleibt offen.

**Warum das nicht neu ist** (Vermutung). Windows verschiebt den Fokus
vermutlich nicht, wenn ein schon aktives Kindfenster erneut aktiviert wird.
Dann liegt der Fokus noch im Baum der Leiste. `GetWazooBarWithFocus`
findet *Mailboxes*, und die Leiste wird versteckt, mit oder ohne Marke.
So war es auch vor dem fünften Anlauf. Verschiebt Windows den Fokus doch
ins Postfach, ist es ein kleiner Restfall des alten K1. Gregor erkennt ihn
im Protokoll an `zuletzt-angeklickte-leiste=ja … fokus=SysTreeView32`
(Fokus im Baum) bzw. einer anderen Fensterklasse (Fokus im Postfach).

Den Restfall hatte [PRUEFER-62](PRUEFER-62.md#pruefer-62) schon im Vorschlag genannt.

**Schwere: niedrig.** Nichts geht verloren. **Hält das Paket auf: nein.**

## <a id="k2"></a>K2 — Die Spurzeile sagt nicht, ob eine Marke verworfen wurde

**Was ist** (am Quelltext belegt). `m_hE137MdiBeiKlick` wird bei **jedem**
Klick gesetzt, auch außerhalb der Leisten (`mainfrm.cpp:3433-3434`). Eine
Taste löscht nur die Marke, nicht diesen Wert (`:3441`). `bMdiGewechselt`
wird bei jedem Strg+W berechnet, auch wenn es gar keine Marke gab
(`:3501-3502`). Ein Beispiel: Gregor klickt in eine Mail, wechselt mit
Strg+F6 und drückt Strg+W. Dann steht im Protokoll `mdi-gewechselt=ja`,
obwohl keine Leiste im Spiel war. Umgekehrt steht nach einem verworfenen
Klick `zuletzt-angeklickte-leiste=nein`, denn `pGeklickt` wird vor der
Ausgabe auf `NULL` gesetzt (`:3503-3504`). Aus der Zeile allein lässt sich
also nicht lesen, ob eine Marke da war und verworfen wurde.

**Vorschlag.** Vor dem Verwerfen merken, ob `pGeklickt` gesetzt war, und
`mdi-gewechselt` nur dann ausgeben, oder als `marke=verworfen`.

**Schwere: sehr niedrig** (nur Protokoll). **Hält das Paket auf: nein.**

## <a id="k3"></a>K3 — V6 nennt die Vorbedingung nicht

`Intern/TESTPLAN.md` Zeile 29 sagt: „dort ein lokales Postfach (etwa
`Trash`) doppelklicken“. Ist `Trash` vorher schon offen und vorn, trifft
der Schritt [K1](#k1), und die Leiste verschwindet. Gregor würde dann einen
Fehlschlag melden, der mit der Behebung nichts zu tun hat. Ist `Trash`
offen, aber nicht vorn, misst der Schritt richtig.

**Vorschlag.** In V6 ergänzen: „`Trash` vorher schließen (oder ein anderes
Postfach vorn haben)“. Als Spur ergänzen: im `eudora.log` steht
`mdi-gewechselt=ja` und **keine** Zeile `Wazoo-Leiste wird versteckt`.

**Schwere: niedrig.** **Hält das Paket auf: nein.** Den Kurztest an
1.0.127 entwertet das nicht. Geht V6 schief, muss nur geklärt werden, ob
`Trash` vorn war. Die Spalte `fokus=` und `mdi-gewechselt=` zeigen es.

## Neue Kennungen

Keine. [E-165](../Intern/BEFUNDE.md#e-165) und E-166 sind nicht vergeben.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Doppelklick auf das Postfach, das schon vorn ist, dann Strg+W: die Leiste *Mailboxes* verschwindet statt des Postfachs. Vermutlich wie vor dem fünften Anlauf, weil der Fokus im Baum bleibt. Nichts geht verloren. | niedrig | nein |
| [K2](#k2) | Die Spurzeile meldet `mdi-gewechselt=ja` auch ohne Marke und `zuletzt-angeklickte-leiste=nein` nach dem Verwerfen. Ob eine Marke verworfen wurde, steht nicht darin. | sehr niedrig | nein |
| [K3](#k3) | V6 nennt nicht, dass `Trash` vorher nicht vorn sein darf. Sonst schlägt der Schritt aus einem anderen Grund fehl. | niedrig | nein |
| — | Fragen 2 und 3: V1 bis V3 bleiben gedeckt, der eigene schwebende Rahmen löst kein `OnActivateApp(FALSE)` aus. | keine | nein |
