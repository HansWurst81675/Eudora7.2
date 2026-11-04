# <a id="pruefer-94"></a>PRUEFER-94

Lauf nach [PRUEFER-93](PRUEFER-93.md#pruefer-93). Zweig wt/pruefer-20261104, abgezweigt von `origin/e188_loeschschranke`. Geprüft wird `git log f6693b4b..HEAD -- Eudora71 tools Releases/1.0`. Im Mittelpunkt stehen die vier Behebungen von [E-188](../Intern/BEFUNDE.md#e-188): `aceeffad`, `ce4cda82`, `a9c5d6aa`, `044477d2` und `5e091c97`. Dazu kommen `Tests/TestE188.cpp`, der Umbau von `tools/messen-e188.ps1` (`ed60ee09`) und der Fall `E-188d`. Eudora habe ich weder gebaut noch gestartet. Ich habe kein Fenster geöffnet und keinen Prüfstand angefasst. Die Testsuite habe ich in meinem Baum gebaut und gefahren.

## Ergebnis vorweg

Die vier Behebungen tun, was der Befund sagt. Ich habe sie gegen die Quelle nachgerechnet. Die Löschschranke löscht in der Quelle nur noch, was im Ziel angekommen ist. Ein verweigerter einfacher Rumpf gilt nicht mehr als geladen. Die Vorab-Kopie wird über ihr Merkzeichen gefunden. Die Kopie im Ziel trägt die neue Nummer. Eine Mail, die im Ziel angekommen ist, wird nicht fälschlich als „nicht angekommen“ gezählt, außer in einem einzigen Fall. In diesem Fall liegt sie auf beiden Servern, verloren geht nichts (K7). Die Testsuite läuft in meinem Baum mit **409/409**.

Drei Dinge sind wichtig:

- **Bei mehrteiligen Mails bleibt der Verlustweg offen (K1, am Quelltext belegt).** Dazu gehört jede HTML-Mail (`multipart/alternative`). Verweigert der Server den Rumpf oder reißt die Verbindung, behält `DownloadSingleMessage` das `S_OK` des Kopfabrufs. Die Mail gilt dann als ganz geladen, und die Löschschranke greift nicht. Beim Verschieben in ein anderes Konto wird nur der Kopf hochgeladen, und die Quelle wird gelöscht. Dasselbe gilt für Anhänge, die sich nicht laden lassen. Der Befund nennt mehrteilige Mails „bewusst nicht erfasst“. Das klingt nach einem Randfall, aber es ist die häufigste Form von Mail.
- **Der Regressionstest sieht zwei der Änderungen nicht (K5, gemessen).** Ich habe die Zeile `bAngekommen = false;` im Weg nach lokal entfernt. Sie ist der Kern der Behebung für `E-188f`. Danach ist die Suite trotzdem 409/409 grün. Dasselbe gilt für das Zurücksetzen von `pCopySum` je Mail. Der Test findet dort die Deklaration `*pCopySum = NULL;` statt der neuen Zeile. Positivprobe: Mit `m_szMessageIDs` statt `strAngekommen` wird der Test rot.
- **Nach lokal kann eine nur als Kopf kopierte Mail weiterhin auf dem Server gelöscht werden (K2, am Quelltext belegt, Weg nicht gemessen).** Das passiert, wenn die Quelle zwischen dem Verschieben und dem Abarbeiten der Warteschlange ganz geladen wurde. Dann nimmt der Zweig „schon geladen, Xfer hat alles getan“ an, dass die Mail da ist. Lokal liegt aber nur die Kopf-Kopie. Dieser Fehler stammt aus dem Original. Seit `a9c5d6aa` lässt er sich mit einer Zeile schließen.

**Kein Fund ist eine Verschlechterung gegenüber 7.2.2.132.** Nur K4 ist eine kleine Verschlechterung: nach einem Neustart mit gespeicherter Warteschlange entsteht nach lokal ein Eintrag ohne Text. **Kein Fund hält das nächste Paket auf.** Kritische Befunde sind nach Gregors Entscheidung vom 23.10. kein Release-Blocker. Allerdings dürfen README und Release-Notizen [E-188](../Intern/BEFUNDE.md#e-188) nicht pauschal als „behoben“ führen, solange K1 offen ist. K5 kostet etwa zehn Zeilen und gehört vor den Merge. Neue Kennungen habe ich nicht vergeben. `befund-suchen.pl` findet zu jedem Ort [E-188](../Intern/BEFUNDE.md#e-188) oder [E-184](../Intern/BEFUNDE.md#e-184), dort wird fortgeschrieben. E-222 und E-223 bleiben frei.

## 1. Löschschranke (`aceeffad`)

*(folgt)*

## 2. Verweigerter Rumpf (`ce4cda82`)

*(folgt)*

## 3. Vorab-Kopie über das Merkzeichen (`a9c5d6aa`)

*(folgt)*

## 4. Neue Nummer und eigene Merkzeichen (`044477d2`, `5e091c97`)

*(folgt)*

## 5. Regressionstest, Messskript, Fall `E-188d`

*(folgt)*

## Funde

*(folgt)*
