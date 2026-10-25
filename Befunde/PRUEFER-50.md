# <a id="pruefer-50"></a>PRUEFER-50 — E-77 Umbenennen und die neuen Regressionstests gegen die Quelle nachgerechnet, 24.10.2026

**Auftrag.** `git log bcbce2fb..origin/main -- Eudora71 tools` (Stand
`c297097f`): die Behebung von [PRUEFER-49 K1/K2](PRUEFER-49.md#k1) zu
[E-77](../Intern/BEFUNDE.md#e-77) (Umbenennen), die neuen Regressionstests
(Block 1 bis 2c: `TestE77.cpp`, `TestStartfehler.cpp`,
`TestSpeicherfehler.cpp`, `tools/regression-schranken.txt`) und die Werkzeuge
dazu (`imap-pruefserver.pl`, `messen-e77-umbenennen.ps1`, `messen-bild.ps1`,
`pruefe-regressionstest.pl`).

**Ergebnis vorweg.**

* **[E-77](../Intern/BEFUNDE.md#e-77) Umbenennen hält für den normalen
  Fall.** Wird ein IMAP-Ordner auf einem Server mit Trennzeichen (`/` oder
  `.`) umbenannt, führt Eudora ihn jetzt unter genau dem Namen, den auch der
  Server bekommt. Dasselbe gilt für die Unterordner und für `mboxlist.lst`.
  Offline wartet die Umbenennung kodiert in der Warteschlange, auch das
  passt. **Zwei seltene Wege laufen weiter auseinander**, beide von
  QUALCOMM und nicht von [E-77](../Intern/BEFUNDE.md#e-77): ein Server ohne
  Trennzeichen (gemessen: aus `Ablage` wird in Eudora `AblageAblage-&AOQ-`)
  und INBOX bei einem Konto mit Ordnerpräfix ([K8](#k8), neu
  **[E-146](../Intern/BEFUNDE.md#e-146)**). Lehnt der Server die Umbenennung
  ab oder bricht die Verbindung ab, bleibt der Ordner in Eudora umbenannt und
  auf dem Server nicht ([K9](#k9)).
* **Die Testsuite ist grün: 293 Tests, 293 bestanden** (gemessen). **Aber
  fünf der neuen Regressionsprüfungen bleiben grün, wenn man den Fehler auf
  einem anderen Weg zurückholt als dem, der in der Commit-Nachricht gefahren
  wurde.** Gemessen mit vorübergehenden Rückfällen im Quelltext:
  * [E-20](../Intern/BEFUNDE.md#e-20): der ursprüngliche Überlauf in
    `InsertArr`, nur ohne Leerzeichen vor der Klammer geschrieben, ergibt 293
    von 293 ([K1](#k1)).
  * [E-35](../Intern/BEFUNDE.md#e-35): der Originalcode von QUALCOMM, nur auf
    zwei Zeilen umbrochen, kommt durch die Schranke ([K2](#k2)).
  * [E-62](../Intern/BEFUNDE.md#e-62): `PostQuitMessage` entfernt, Eudora
    verschluckt das Beenden wieder, die Schranke meldet grün ([K3](#k3)).
  * [E-25](../Intern/BEFUNDE.md#e-25): die Doppelfreigabe mit anderer
    Schreibweise ([K5](#k5)).
  * [E-18](../Intern/BEFUNDE.md#e-18): die Prüfung bleibt stehen, tut aber
    nichts ([K6](#k6)).

  Geprüft wird bei diesen Fällen, ob die Behebung **so geschrieben** dasteht,
  nicht, ob der Fehler weg ist.
* **`pruefe-regressionstest.pl` zählt eine Kennung schon dann als getestet,
  wenn sie in einem Kommentar einer Testdatei steht.** Gemessen: 7
  Kennungen, darunter der kritische [E-108](../Intern/BEFUNDE.md#e-108)
  (Absturz beim Antworten), für den es keinen Test gibt ([K4](#k4)). Die
  Angabe „39 von 67 kritischen gedeckt" ist damit zu hoch.
* **Zwei Messskripte können grün melden, ohne gemessen zu haben.**
  `messen-e77-umbenennen.ps1` verlangt nicht, dass der Ordner nach dem
  Umbenennen am Server überhaupt geöffnet wurde ([K10](#k10)). Der Fall
  `E-113b2` ist auch grün, wenn das Fenster gar nicht schmaler wurde
  ([K11](#k11)).

**Hält ein Fund das Paket 7.2.0.123 auf?** **Nein.** Kein Fund ist ein
Programmfehler, der vorher nicht da war. [K8](#k8) und [K9](#k9) stammen von
QUALCOMM. Die anderen Funde betreffen Prüfungen und Werkzeuge, nicht das
Programm. Sie gehören aber vor **7.2.1.0**, für das Gregor angeordnet hat,
dass alle Regressionstests laufen und bestehen: ein Test, der den Fehler
nicht sieht, besteht dort auch.

**Neue E-Kennung: [E-146](../Intern/BEFUNDE.md#e-146)** ([K8](#k8),
Umbenennen bildet den Namen in Eudora anders als für den Server, wenn der
Server kein Trennzeichen hat oder INBOX mit Präfix umbenannt wird;
Originalfehler von QUALCOMM). **[E-147](../Intern/BEFUNDE.md#e-147) bleibt frei.** Eingetragen in
`Intern/BEFUNDE.md` ist nichts. Vorher gelaufen: `perl
tools/befund-suchen.pl` zu `UpdateAfterRename`, `RenameMailbox`,
`ReverseFind`, `InsertArr`, `LocateNetscapePrefsFile`,
`OnUserUpdateImmediateSend`, `EscapePressed`, `hat_test`; zu
`UpdateAfterRename` und `RenameMailbox` gibt es nur
[E-77](../Intern/BEFUNDE.md#e-77) und [PRUEFER-49](PRUEFER-49.md#k1), nicht
den Trenner-NIL-Fall.

Gekennzeichnet ist jede Aussage: **gemessen** (Testlauf, Rückfallprobe,
Messprogramm), **am Quelltext belegt** (Datei:Zeile, Stand `c297097f`),
**Vermutung**.

---

## 1. E-77 Umbenennen

### 1a. Stimmen geführter Name und Servername überein?

**Am Quelltext belegt.** Den Servernamen bildet
`CImapAccount::RenameMailbox` (`ImapAccount.cpp:2950-3084`), den in Eudora
geführten Namen `QCMailboxDirector::UpdateAfterRename`
(`QCImapMailboxDirector.cpp:2475-2570`). Beide nehmen jetzt
`E77ImapNameFuerServer(neu)`. Im Einzelnen:

| Fall | Server (`RenameMailbox`) | Eudora (`UpdateAfterRename`) | gleich? |
|---|---|---|---|
| Unterordner, Trenner gesetzt | alter Name bis einschließlich letztem Trenner + kodiert (`:3036-3044`) | dasselbe (`:2511-2523`), derselbe Trenner `pImapCommand->GetDelimiter()` | **ja** |
| oberste Ebene, Trenner gesetzt | kodiert (`:3037`) | kodiert (`:2516`) | **ja** |
| Server ohne Trenner (`GetDelimiter() == 0`) | kodiert (`:3026`) | `ReverseFind('\0')` findet das Stringende, also alter Name + kodiert | **nein** ([K8](#k8)) |
| INBOX, Konto ohne Präfix | kodiert (`:2998`) | kodiert (INBOX hat keinen Trenner) | **ja** |
| INBOX, Konto mit Präfix | Präfix + Trenner + kodiert (`:3013`) | kodiert, **ohne** Präfix | **nein** ([K8](#k8)) |

Den Fall „Server ohne Trenner" habe ich **gemessen**: ein Messprogramm mit
`CStringA` aus der ATL von VS2022 (dieselben `ChTraitsCRT<char>` wie Eudoras
`CString`) liefert für `"Ablage".ReverseFind('\0')` den Wert **6**, also die
Länge. Der neue Name wird `AblageAblage-&AOQ-`. Das war vor
[E-77](../Intern/BEFUNDE.md#e-77) schon so, auch für reine ASCII-Namen.

### 1b. Unterordner und `mboxlist.lst`

**Am Quelltext belegt.** `UpdateChildrenAfterRename`
(`QCImapMailboxDirector.cpp:2963-3049`) setzt für jedes Kind den neuen
Namen des Elternordners (jetzt kodiert) plus den alten Grundnamen des Kindes.
Der Grundname kam schon vorher vom Server, ist also kodiert. Das passt zu
`RENAME` nach RFC 3501, der die Unterordner mitnimmt.
`WriteImapDescMapFile` (`:2564`, Format `:726-739`) schreibt
`GetImapName()` als erstes Feld. Die Datei bekommt damit denselben Namen wie
der Server. Beim nächsten Start dekodiert `FormulateFriendlyImapName`
(`ImapMailbox.cpp:7148`) den Anzeigenamen wieder. Der Anzeigename aus
`SetName(pNewName)` (`:2506`) und der nach einem Neustart stimmen also
überein, solange der getippte Name sich kodieren und zurückdekodieren lässt.
Das gilt für jedes Byte aus Windows-1252 (in [PRUEFER-49 3a](PRUEFER-49.md)
mit 255 von 255 gemessen).

### 1c. Offline und Warteschlange

**Am Quelltext belegt.** `RenameMailbox` benennt **zuerst** das lokale
Verzeichnis um (`ImapAccount.cpp:3064`) und stellt dann
`CImapRenameMailboxAction` mit altem und neuem Servernamen in die
Warteschlange (`:3070-3078`). Offline bleibt die Aktion dort stehen und wird
mit dem **kodierten** neuen Namen in `actionqueue.dat` geschrieben
(`ImapActionQueue.cpp:2750-2767`). Der Name ist reines ASCII, beim Lesen
kommt er unverändert zurück (`:437`). Wieder online schickt `DoWork` den
`RENAME` (`:2834`). Danach sucht `RenameMailboxOnServer` den Ordner unter dem
neuen Namen (`ImapAccount.cpp:3162`, `ImapFindByImapName`). **Das klappt
erst seit K1:** vorher führte Eudora den rohen Namen, die Suche ging ins
Leere, und die Ordnereigenschaften wurden nicht nachgeladen.

**Was nicht passt, schon im Original:** Scheitert der `RENAME` am Server
(`NO`, `BAD`) oder kommt keine Verbindung zustande, setzt `DoWork` den
Zustand auf „gescheitert" (`ImapActionQueue.cpp:2840`), und die Aktion ist
weg. Lokal ist der Ordner aber schon umbenannt, und Eudora führt den neuen
Namen. Ab dann fragt Eudora den Server nach einem Ordner, den es dort nicht
gibt ([K9](#k9)). Rückgängig gemacht wird nichts, gemeldet wird nur die
Serverantwort (`ShowError`, `ImapAccount.cpp:3088`).

### 1d. Ein Name, den `E77ImapNameFuerServer` nicht kodieren kann

**Am Quelltext belegt.** `E77Utf7Kodieren` scheitert, wenn ein Lauf von
mehr als 256 Zeichen außerhalb von ASCII vorkommt oder die Ausgabe nicht in
1024 Byte passt (`ImapMailbox.cpp:7072-7129`). Die Hülle gibt dann den
**rohen** Eingang zurück (`:7143-7145`). Server und Eudora bekommen denselben
rohen Namen, sie laufen also nicht auseinander. Ein Server, der sich an die
RFC hält, lehnt den Namen aber ab. Dann gilt [K9](#k9): Eudora ist umbenannt,
der Server nicht. Praktisch kaum erreichbar (über 256 Umlaute am Stück).
Besser wäre, die Umbenennung vorher abzulehnen ([PRUEFER-49 K4](PRUEFER-49.md#k4)).

### 1e. Stand des Eintrags

Der Eintrag zu [E-77](../Intern/BEFUNDE.md#e-77) sagt noch „Umbenennen
(`RenameMailbox`, **drei** Stellen)". Es sind fünf in `RenameMailbox` und
zwei in `UpdateAfterRename`. [PRUEFER-49 K3](PRUEFER-49.md#k3) (Fcc auf alte
rohe Ordnernamen) und [K4](PRUEFER-49.md#k4) stehen im Eintrag richtig als
offen.

---

## 2. Die neuen Regressionstests

**Testsuite selbst gefahren: 293 Tests, 293 bestanden** (MSBuild Debug
Win32, `RunTests.cmd` im Arbeitsbaum `Eudora7.2-wt-pruefer`, Rückgabe 0).
`tools/schranken-gegenprobe.pl`: **14 Fälle, 14 weisen den Rückfall ab**
(gemessen).

**Wie ich gegengeprüft habe.** Die Quelltextfälle lesen den Quelltext **zur
Laufzeit** (`Quelltext.h`). Ein Rückfall braucht also keinen Neubau: Datei
mit Perl byte-genau ändern, `EudoraTests.exe` fahren, Datei zurückschreiben,
SHA-1 vergleichen. Danach war `git status` jedes Mal leer. Zuerst die
Rückfälle aus den Commit-Nachrichten, **gemessen rot**, wie behauptet:
`E-77 K1` (`+= pNewName;`), `E-77 K2` (`prefix + szNewImapName;`), [`E-20`](../Intern/BEFUNDE.md#e-20)
(`unsigned int [nLen + 1]` mit Leerzeichen). Dann andere Rückfälle:

| Probe | Rückfall | Fehler zurück? | Ergebnis |
|---|---|---|---|
| E20-Feld | `DEBUG_NEW unsigned int[nLen + 1]` (ohne Leerzeichen vor `[`) | **ja**, der Überlauf aus [E-20](../Intern/BEFUNDE.md#e-20), sogar schlimmer: die Vorbelegung schreibt `nNeu` Werte | **293/293 grün** ([K1](#k1)) |
| E20-nBis | `nBis = nIdx` statt `min(nIdx, nLen)` | ja, das Lesen hinter `pArr` (Teil von [E-20](../Intern/BEFUNDE.md#e-20) laut Kommentar `ListCtrlEx.cpp:1355`) | **293/293 grün** ([K1](#k1)) |
| E25-anders | `DeleteCharListTree( &FileList ); FileList = new CCharArrList;` vor die Leerung | **ja**, die Doppelfreigabe aus [E-25](../Intern/BEFUNDE.md#e-25) | **293/293 grün** ([K5](#k5)) |
| E18-leer | `if (pFld == NULL) ;` statt `return;` | **ja** | **293/293 grün** ([K6](#k6)) |
| E18-falschrot | `if (!pFld)` statt `if (pFld == NULL)` | nein, gleichwertig | **rot** ([K6](#k6)) |
| E77-Huelle | `E77ImapNameFuerServer` gibt immer den Eingang zurück | **ja**, K1 und K2 zugleich | **293/293 grün** ([K7](#k7)) |
| E77-falschrot | `LPCSTR pAnzeige = pNewName; SetName(pAnzeige);` | nein, gleichwertig | **rot** ([K7](#k7)) |
| S2-Makro | `DEFAULT_SWM_MODE=0;` in die Debug-Definitionen von `Eudora.vcxproj` | ja, `IsBoxBuild()` wird falsch, die Werbeleiste kommt | **293/293 grün** ([K13](#k13)) |

Und für die Schranken im pre-commit (Schranke direkt gefahren):

| Probe | Rückfall | Fehler zurück? | Ergebnis |
|---|---|---|---|
| [E-35](../Intern/BEFUNDE.md#e-35) B | Originalcode von QUALCOMM, Aufruf und `->` auf zwei Zeilen | **ja** | `pruefe-fensterbau.pl` **0** ([K2](#k2)) |
| [E-35](../Intern/BEFUNDE.md#e-35) C | `if (pSendeKnopf \|\| m_bBPWarning \|\| !m_bBPWarning)` | ja | **0** ([K2](#k2)) |
| [E-35](../Intern/BEFUNDE.md#e-35) D | erst `pSendeKnopf->IsBPWarning()` lesen, dann `if (pSendeKnopf && …)` | **ja** | **0** ([K2](#k2)) |
| [E-62](../Intern/BEFUNDE.md#e-62) | `::PostQuitMessage` in `EscapePressed` (`guiutils.cpp:1680`) entfernt, `if (msg.message == WM_QUIT) return FALSE;` bleibt | **ja**, genau der Fehler aus [E-62](../Intern/BEFUNDE.md#e-62) | `pruefe-nachrichtenschleife.pl` **0** ([K3](#k3)) |

### 2a. `TestE77.cpp` — `RunE77QuelltextTests`

**Misst eine Zeichenkette, nicht den Fehler.** Geprüft wird, dass in
`UpdateAfterRename` zweimal `E77ImapNameFuerServer(pNewName)` steht und in
`RenameMailbox` fünfmal `E77ImapNameFuerServer(szNewImapName)`
(`TestE77.cpp:80-103`). Nicht geprüft wird:

* dass die Hülle kodiert. Sie wird von keinem Test aufgerufen, denn
  `Extract.ps1` schneidet nur `E77Base64Wert` bis `E77Utf7Kodieren`
  (`Extract.ps1:255-258`), die Hüllen stehen dahinter
  (`ImapMailbox.cpp:7132-7146`). Gemessen: Hülle kaputt, 293/293 grün.
* dass beide Funktionen **denselben** Namen bilden. Genau das war K1. Die
  zwei Fälle aus [K8](#k8) sind heute ungleich, und der Test mit dem Titel
  „gefuehrter Name gleich Servername" ist grün.

Fälschlich rot wird er bei jeder harmlosen Zuweisung `= pNewName;` im
Rumpf (gemessen). Rot ist sichtbar, das ist der kleinere Mangel.

Am Verhalten misst [E-77](../Intern/BEFUNDE.md#e-77) der Prüfstandsfall
`E-77d`. Der deckt die Hülle mit ab (siehe [K10](#k10) zu seinen Lücken).

### 2b. `TestStartfehler.cpp` — S-2

**Am Quelltext nachgerechnet, die drei Füße stimmen.** `WazooBarMgr.cpp:164`
legt `CAdWazooBar` nur bei `!IsBoxBuild()` an. `IsBoxBuild()` gibt bei
`DEFAULT_SWM_MODE == 2` wahr zurück (`QCSharewareManager.cpp:1203-1210`).
`QCSharewareManager.h:54-60` setzt 2 bei `BUILD_BOX_OR_SITE_R_VERSION`. Das
Makro steht in beiden Übersetzer-Abschnitten von `Eudora.vcxproj` (`:78`,
`:132`). Die auskommentierte Zwangsumstellung in
`QCSharewareManager.cpp:50-57` ist wirklich auskommentiert. `CAdWazooWnd`
wird nur in `AdWazooBar.cpp:96` erzeugt; der INI-Lader in `WazooBar.cpp`
kennt die Klasse nicht. Es gibt keinen anderen Weg zur Werbeleiste.

**Lücke** ([K13](#k13)): Die Kopfdatei setzt den Wert nur `#ifndef
DEFAULT_SWM_MODE`. Eine Definition davor, etwa in der Projektdatei, schaltet
die Fassung für Firmenkunden ab, und der Test bleibt grün (gemessen).
Unwahrscheinlich, aber mit einem Zusatz zu prüfen: kein `DEFAULT_SWM_MODE`
in `<PreprocessorDefinitions>`.

### 2c. `TestSpeicherfehler.cpp` — E-18, E-20, E-25, E-31/E-27

* **[E-20](../Intern/BEFUNDE.md#e-20)** (`:22-39`): siehe Tabelle, zwei Rückfälle grün ([K1](#k1)). Die
  Negativprüfung hängt an der Schreibweise `unsigned int [nLen + 1]`.
  `QT_LeerraumZusammen` fasst Leerraum zusammen, fügt aber keinen ein.
  `InsertArr` braucht weder Fenster noch `this`
  (`ListCtrlEx.cpp:1348-1382`). Sie lässt sich wie `E77Utf7Kodieren`
  schneiden und **aufrufen**: `nIdx = 5`, `nLen = 2`, danach
  `_CrtCheckMemory()`. Das misst den Fehler, nicht die Schreibweise.
* **[E-18](../Intern/BEFUNDE.md#e-18)** (`:44-58`): misst die Reihenfolge der drei Zeichenketten, nicht,
  ob die Prüfung wirkt ([K6](#k6)). Die Stellen sind in `headervw.cpp` je
  einmal vorhanden (`:251-255`). Die Reihenfolge trifft also die richtige
  Funktion.
* **[E-31](../Intern/BEFUNDE.md#e-31)** (`:63-78`): misst `typedef long pg_time_t;` (`CPUDEFS.H:703`).
  Die Mac-Fassung `typedef unsigned long pg_time_t;` (`:540`) enthält die
  Zeichenkette nicht, es gibt also keinen falschen Treffer. Gemessen ist
  das, worauf es ankommt, aber nicht: Die Wirkung von
  [E-31](../Intern/BEFUNDE.md#e-31) sind Feldversätze gegen `Paige32.dll`
  (`def_style.procs` bei 524). Ein `static_assert` auf diese Versätze nach
  `#include` der Paige-Köpfe würde jede Ursache treffen, auch eine andere
  als `time_t`. **Vorschlag, kein Fund.**
* **[E-27](../Intern/BEFUNDE.md#e-27) über [E-31](../Intern/BEFUNDE.md#e-31)**: laut Eintrag ist [E-31](../Intern/BEFUNDE.md#e-31) die Ursache von [E-27](../Intern/BEFUNDE.md#e-27). Der Fall
  nennt [E-27](../Intern/BEFUNDE.md#e-27) im Titel. Das ist ehrlich und reicht nach Gregors Regel
  („doppelte tests machen keinen sinn").
* **[E-25](../Intern/BEFUNDE.md#e-25)** (`:87-114`): der erste Lauf war rot auf dem richtigen Stand, das
  führende Leerzeichen behebt es. Am Quelltext nachgesehen: ` FileList =`
  kommt in `LocateNetscapePrefsFile` nur noch in Kommentaren vor
  (`NSImportClass.cpp:849-851`), die `QT_LiesNurCode` entfernt. **Der Test
  kann deshalb auf diesem Stand nicht fälschlich rot werden.** Aber er ist
  grün bei einer Doppelfreigabe in anderer Schreibweise ([K5](#k5)).
  Nebenbei, **am Quelltext belegt, Original**: `strcpy(strName, …)` in
  `char strName[_MAX_PATH]` (`:842`, `:883`) mit Einträgen bis
  `_MAX_PATH + _MAX_FNAME + _MAX_EXT` (`:516`). Bei einem Registrierungswert
  über 250 Zeichen läuft das über. Praktisch ohne Bedeutung, denn Netscape
  4 legt solche Pfade nicht an. Kein Fund.

### 2d. `tools/regression-schranken.txt` — E-35 und Block 1

Gemessen 14 von 14 Rückfällen abgewiesen. Aber eine Schranke, die einen
Rückfall abweist, ist noch kein Regressionstest für den **Fehler**:

* **GetButton-Regel** (`pruefe-fensterbau.pl:140-192`, zählt für
  [E-16](../Intern/BEFUNDE.md#e-16), [E-34](../Intern/BEFUNDE.md#e-34),
  [E-35](../Intern/BEFUNDE.md#e-35), [E-36](../Intern/BEFUNDE.md#e-36)):
  Sie arbeitet zeilenweise. Den Variablennamen sucht sie nur in den zwei
  Zeilen davor (`:155-160`). Findet sie keinen, wird der Aufruf **ohne
  Meldung übersprungen** (`:171`). Eine direkte Dereferenzierung erkennt
  sie nur, wenn `->` auf **derselben** Zeile steht (`:165`). Als Prüfung
  zählt jede Bedingung mit dem Namen und `||` darin, und eine Prüfung
  **nach** dem Zugriff zählt auch (`:177-180`). Drei Rückfälle gemessen
  grün ([K2](#k2)).
* **WM_QUIT-Regel** (`pruefe-nachrichtenschleife.pl:113`, `:137`): verlangt
  nur, dass `WM_QUIT` im Rumpf vorkommt, nicht, dass es zurückgestellt wird.
  Gemessen grün ohne `PostQuitMessage` ([K3](#k3)). Das betrifft auch
  [E-61](../Intern/BEFUNDE.md#e-61) (`OTShim.cpp`), dieselbe Regel.
* **`schranken-gegenprobe.pl`** zählt jede Rückgabe ungleich 0 als Abweisung
  (`:94`), auch 2 („Aufruffehler") oder einen Perl-Abbruch. Es läuft in
  keinem Haken (`grep` über `tools/hooks-einrichten.sh`, `paket-bereit.pl`:
  kein Aufruf). `pruefe-regressionstest.pl` zählt eine Zeile aus
  `regression-schranken.txt` als Test, sobald die Schranke im Haken steht
  (`:103`), **ohne** dass die Rückfallprobe heute noch rot wird. Wird eine
  Schranke später entschärft oder trifft die Rückfallzeile nicht mehr
  (`Treffer 0`), zählt die Kennung weiter als gedeckt ([K12](#k12)).

---

## 3. Die Werkzeuge

### 3a. `tools/pruefe-regressionstest.pl`

**Kommentare zählen als Test, gemessen.** `hat_test` (`:109-113`) sucht die
Kennung im **Rohtext** aller `Eudora71/Tests/*.cpp` (`:60-64`), Kommentare
eingeschlossen. Für `pruefstand-faelle.txt` hat das Werkzeug genau das
ausdrücklich vermieden (`:66-75`: „[E-14](../Intern/BEFUNDE.md#e-14) und [E-132](../Intern/BEFUNDE.md#e-132) stehen dort als
Begründung, warum sie NICHT automatisiert sind"), für die Testdateien
nicht. Gemessen mit einem Zählprogramm (Kommentare weg, Zeichenketten
bleiben, denn Testnamen stehen in Zeichenketten): **7 Kennungen stehen nur in
Kommentaren**, [P-2](../Intern/BEFUNDE.md#p-2), [E-66](../Intern/BEFUNDE.md#e-66),
[E-90](../Intern/BEFUNDE.md#e-90), [E-98](../Intern/BEFUNDE.md#e-98),
[E-106](../Intern/BEFUNDE.md#e-106), [E-107](../Intern/BEFUNDE.md#e-107) und
**[E-108](../Intern/BEFUNDE.md#e-108) (kritisch)**. [E-108](../Intern/BEFUNDE.md#e-108) steht in
`TestE112.cpp:144` als Vorgeschichte („dort ist … schon zweimal etwas
abgestürzt ([E-107](../Intern/BEFUNDE.md#e-107), [E-108](../Intern/BEFUNDE.md#e-108))"). Der Test darunter prüft, dass
`E112Zielrechteck` einen Nullzeiger übersteht. Mit dem Absturz beim Antworten
hat er nichts zu tun. `pruefe-regressionstest.pl` führt [E-108](../Intern/BEFUNDE.md#e-108) trotzdem nicht
unter „OHNE jede Prüfung" (gemessen, Lauf mit `--hinweis`) ([K4](#k4)).

**Die Regel „überholt durch" (`:186-206`).** Nachgerechnet: [E-9](../Intern/BEFUNDE.md#e-9) → [E-11](../Intern/BEFUNDE.md#e-11) zählt
über `TestStartWege.cpp:97` und `:153`, dort wird [E-11](../Intern/BEFUNDE.md#e-11) wirklich geprüft.
[E-5](../Intern/BEFUNDE.md#e-5) → [E-6](../Intern/BEFUNDE.md#e-6)/[E-8](../Intern/BEFUNDE.md#e-8) und [E-6](../Intern/BEFUNDE.md#e-6) → [E-8](../Intern/BEFUNDE.md#e-8) bleiben offen, richtig. Zwei Schwächen
([K13](#k13)): Es genügt **eine** der genannten Ursachen (`:197`, `grep`
statt „alle"). Und `hat_test` der Ursache erbt den Kommentarfehler oben. Der
Eintrag zu [E-9](../Intern/BEFUNDE.md#e-9) sagt außerdem „die Härtung bleibt richtig". Diese Härtung hat
dann keinen Test, und die Regel fragt danach nicht.

### 3b. `tools/imap-pruefserver.pl`

**Am Quelltext belegt.** Geprüft werden Namen nur bei `SELECT`, `EXAMINE`,
`STATUS` und `RENAME` (`:284-314`). Rohe 8-Bit-Bytes werden bei diesen und
bei `CREATE` abgewiesen. **Jeder andere Befehl mit Postfachnamen** wird
ungeprüft angenommen: `APPEND` (`:333`), und `CREATE`, `DELETE`, `COPY`,
`UID COPY`, `SUBSCRIBE` landen im allgemeinen Zweig „unbekannter Befehl, mit
OK beantwortet" (`:449-451`). Würde Eudora nach dem Umbenennen beim
**Übertragen** in den Ordner einen falschen Namen schicken, bekäme es `OK`
([K10](#k10)).

Weiter: `liste_fuer` (`:207`) erkennt die Ablage am Namen `Ablage`. Nach
dem Umbenennen liefert der Ordner `Ablage-&AOQ-` die Nachrichten des
**Posteingangs**. `RENAME INBOX` ersetzt INBOX in der Liste (`:304`). Nach
RFC 3501 6.3.5 bleibt INBOX bestehen und wird geleert. Für `E-77d` spielt
beides keine Rolle, für einen künftigen Fall schon.

### 3c. `tools/messen-e77-umbenennen.ps1`

**Kann grün melden, ohne den nächsten Zugriff gemessen zu haben, am
Quelltext belegt.** Das Ergebnis ist `rename=… liste=… unbekannt=…`
(`:266`). `unbekannt` zählt `!!`-Zeilen im Serverprotokoll (`:252`). Kommt
nach dem Öffnen gar kein `SELECT` (Befehl nicht angekommen, Konto offline,
Fenster aus dem Zwischenspeicher), bleibt `unbekannt=0`. Der Fall `E-77d`
ist dann grün. Die Zeile `SELECT Ablage-&AOQ- -> OK`, die die Commit-Nachricht
als Beleg nennt, wird nur ausgegeben, nicht verlangt. **K1 selbst** fängt
der Fall trotzdem, denn `liste=` liest `mboxlist.lst`, und die hatte vor der
Behebung den rohen Namen. Was fehlt, ist die Positivprobe für Schritt 4
([K10](#k10)).

Richtig gemacht: Die Pfadschranke steht vor jeder Wirkung (`:44`), der
Prüfserver bekommt eine Zeitschranke (90 s), und `liste=` liest das **erste
Feld** von `mboxlist.lst`. Das ist laut `WriteImapDescMapFile`
(`QCImapMailboxDirector.cpp:728`) der Servername, nicht das Verzeichnis.
Für einen Namen, dessen Kodierung ein `,` enthält (modifiziertes UTF-7
nimmt `,` statt `/`), wäre `Split(',')[0]` falsch, denn die Datei verdoppelt
Kommas (`:726`). Für `Ablage-&AOQ-` trifft das nicht zu.

### 3d. `tools/messen-bild.ps1`, Schritt E113B

**Kann grün melden, ohne das Fenster schmaler gemacht zu haben, am Quelltext
belegt.** Die Zeile nennt `breite {0} -> {1}` (`:252`). Der Fall `E-113b2`
verlangt aber nur `neu=0 lebt=1 probe=ok`. Scheitert `WM_MDIRESTORE` oder
`SetWindowPos` (etwa bei einem anders verankerten Fenster), steht
`breite 771 -> 771`, und der Fall ist grün ([K11](#k11)). Dazu sucht er nur
nach einer Zeile `E-112 Metadatei: angegeben=0x0 Datei=985x378`. Würde
Variante B gebaut und schriebe eine andere Zeile, bliebe er ebenfalls grün.
Er soll ja gerade melden, wenn sich das Verhalten ändert. Die Positivprobe
`probe=ok` ist richtig: `pruefstand-lauf.ps1:157` löscht `eudora.log` vor
jedem Lauf, eine Zeile vom Vorlauf zählt also nicht.

---

## Funde

### <a id="k1"></a>K1 — E-20: Der Regressionstest ist grün mit dem ursprünglichen Überlauf

**Gemessen.** `DEBUG_NEW unsigned int[nLen + 1]` (ohne Leerzeichen vor
`[`) in `InsertArr`: 293 von 293 grün. Die Negativprüfung
`TestSpeicherfehler.cpp:33` hängt an der Schreibweise, die Positivprüfung
`:31` an der Zeile `nNeu = …`, die dann noch dasteht, aber nicht mehr
benutzt wird. Ebenso grün: `nBis = nIdx` (Lesen hinter `pArr`). Der Fehler
ist ein Schreiben hinter das Feldende, kritisch eingestuft.

**Behebung:** `InsertArr` schneiden und aufrufen (Abschnitt 2c). Die Funktion
ist rein. **Wichtig (Prüfstand).**

### <a id="k2"></a>K2 — E-35/E-34/E-16/E-36: Die GetButton-Schranke lässt das QUALCOMM-Original durch, wenn es umbrochen ist

**Gemessen** (Abschnitt 2d): drei Rückfälle in
`OnUserUpdateImmediateSend` (`CompMessageFrame.cpp:1728-1736`), jedes Mal
`pruefe-fensterbau.pl` Rückgabe 0. Darunter der Originalcode von 7.1 mit
`->` auf der Folgezeile. Der zweite Strg-N stürbe wieder, und vier kritische
Befunde gelten weiter als gedeckt.

**Behebung:** nicht zeilenweise, sondern je Anweisung prüfen (bis `;`
zusammenziehen, wie `QT_LeerraumZusammen`); einen Aufruf ohne erkannten
Namen **melden** statt überspringen; eine Prüfung zählt nur, wenn sie **vor**
dem ersten `name->` steht. Gegenprobe: die drei Rückfälle aus Abschnitt 2d
in `regression-schranken.txt` aufnehmen. **Wichtig (Prüfstand).**

### <a id="k3"></a>K3 — E-62/E-61: Die Schranke für Nachrichtenschleifen sieht nur das Wort WM_QUIT

**Gemessen.** `::PostQuitMessage((int) msg.wParam);` in `EscapePressed`
(`guiutils.cpp:1680`) entfernt: `pruefe-nachrichtenschleife.pl` Rückgabe 0.
Die Schleife nimmt `WM_QUIT` heraus und gibt sie nicht zurück. Das ist
wörtlich der Fehler aus [E-62](../Intern/BEFUNDE.md#e-62) („die Aufforderung
zu beenden war damit weg").

**Behebung:** im Block nach `msg.message == WM_QUIT` ein `PostQuitMessage`
verlangen (oder ein `return`/`break` mit Rückgabe des Abbruchs an einen
Aufrufer, der es zurückstellt). Rückfallprobe dazu in
`regression-schranken.txt`. **Wichtig (Prüfstand).**

### <a id="k4"></a>K4 — pruefe-regressionstest.pl zählt Kommentare als Test; E-108 (kritisch) steht als gedeckt da

**Gemessen** (Abschnitt 3a): 7 Kennungen sind nur durch Kommentare in
`Eudora71/Tests/*.cpp` „gedeckt", darunter [E-108](../Intern/BEFUNDE.md#e-108)
(Absturz beim Antworten, kritisch). Die Zahl „mit Testfall im Prüfstand 39
von 67" ist mindestens um eins zu hoch, „OHNE jede Prüfung 26" um eins zu
niedrig.

**Behebung:** in `hat_test` den Testtext ohne Kommentare durchsuchen, wie
`QT_LiesNurCode` es für den Quelltext tut. Gegenprobe: [E-108](../Intern/BEFUNDE.md#e-108) muss danach in
der Liste „OHNE jede Prüfung" erscheinen, [E-27](../Intern/BEFUNDE.md#e-27) (steht im Testnamen) darf
nicht verschwinden. **Wichtig (Prüfstand)**, weil die Zahl die Grundlage
für 7.2.1.0 ist.

### <a id="k5"></a>K5 — E-25: grün bei einer Doppelfreigabe in anderer Schreibweise

**Gemessen.** `DeleteCharListTree( &FileList ); FileList = new
CCharArrList;` vor die Leerung gesetzt: 293/293 grün. Beide
Negativprüfungen (`TestSpeicherfehler.cpp:96`, `:102`) hängen an Leerzeichen
und an `DEBUG_NEW`. Ein Aufruf am Verhalten ist hier schwer (Registrierung,
Netscape). Eine robustere Quelltextprüfung: im Rumpf nach dem letzten
`FileList->` keine Zuweisung `FileList =` und kein `&FileList)`, ohne
Leerraum gesucht. **Mittel (Prüfstand).**

### <a id="k6"></a>K6 — E-18: Reihenfolge statt Wirkung

**Gemessen.** `if (pFld == NULL) ;` ist grün, `if (!pFld)` ist rot. Der Test
misst, dass drei Zeichenketten in einer Reihenfolge stehen. Besser: nach
`if (pFld == NULL)` oder `if (!pFld)` muss ein `return` folgen. **Gering.**

### <a id="k7"></a>K7 — E-77: Der Testsuite-Fall prüft Aufrufnamen, nicht Gleichheit

**Gemessen** (Abschnitt 2a): Ist die Hülle `E77ImapNameFuerServer` kaputt,
bleibt alles grün (293/293). Eine harmlose Zuweisung `= pNewName;` macht ihn
rot. Die Gleichheit von Server- und Eudora-Namen, die der Titel verspricht,
prüft er nicht, und sie ist in zwei Fällen verletzt ([K8](#k8)). Der Eintrag
zu [E-77](../Intern/BEFUNDE.md#e-77) nennt noch „drei Stellen".

**Behebung:** die beiden Hüllen in den Schnitt von `Extract.ps1` aufnehmen und
mit einem Namen aufrufen. Der Gleichheitsfall bleibt Sache des Prüfstands.
**Mittel.**

### <a id="k8"></a>K8 — E-146 (neu): Umbenennen bildet in Eudora einen anderen Namen als für den Server, ohne Trenner und bei INBOX mit Präfix

**Gemessen** (Trenner NIL: `ReverseFind('\0')` liefert die Länge, aus
`Ablage` wird `AblageAblage-&AOQ-`), **am Quelltext belegt** (INBOX mit
Präfix: Server `Präfix/Neu`, `ImapAccount.cpp:3013`; Eudora `Neu`,
`QCImapMailboxDirector.cpp:2516`). Danach fragt Eudora den Server nach einem
Ordner, den es nicht gibt, wie bei [PRUEFER-49 K1](PRUEFER-49.md#k1).
**Originalfehler von QUALCOMM**, unabhängig von Umlauten. Selten: IMAP-Server
ohne Hierarchie und das Umbenennen von INBOX sind beide ungewöhnlich.

**Behebung (ungemessen):** `UpdateAfterRename` den Namen nicht selbst bilden
lassen, sondern den von `RenameMailbox` übernehmen. Der steht dort als
`strNewFullImapName` fertig und kann als Ausgabeparameter zurückgegeben
werden. Damit gibt es nur noch **eine** Rechnung. **Gering.**

### <a id="k9"></a>K9 — Umbenennen ohne Erfolg am Server: Eudora bleibt umbenannt

**Am Quelltext belegt, Originalfehler.** Das lokale Verzeichnis wird vor dem
`RENAME` umbenannt (`ImapAccount.cpp:3064`), die Aktion wird bei `NO`/`BAD`
oder fehlender Verbindung verworfen (`ImapActionQueue.cpp:2840`, `:3804`).
Es gibt keinen Rückweg. Erreichbar auch über einen Namen, den
`E77ImapNameFuerServer` nicht kodieren kann (Abschnitt 1d). Nicht durch
[E-77](../Intern/BEFUNDE.md#e-77) entstanden. **Gering.**

### <a id="k10"></a>K10 — E-77d: kein Nachweis, dass der Ordner danach geöffnet wurde; der Prüfserver prüft nur vier Befehle

**Am Quelltext belegt** (Abschnitte 3b, 3c). Ergänzung: `sel=` mit der Zahl
der `SELECT`/`EXAMINE` auf den neuen Namen in die Ergebniszeile aufnehmen
und `sel=1` verlangen. Im Prüfserver die Namensprüfung auf `APPEND`, `COPY`,
`UID COPY`, `DELETE` und `CREATE` ausdehnen. **Gering.**

### <a id="k11"></a>K11 — E-113b2: grün, auch wenn das Fenster nicht schmaler wurde

**Am Quelltext belegt** (Abschnitt 3d). Ergänzung: in der Ergebniszeile
`schmaler=ja` ausgeben, wenn die Breite danach unter 500 Punkten liegt, und es
im Fall verlangen. **Mittel**, weil der Fall ausdrücklich als
Regressionstest für eine Vereinbarung mit Gregor dasteht.

### <a id="k12"></a>K12 — Schranken zählen als Test, ohne dass die Rückfallprobe heute läuft

**Am Quelltext belegt** (Abschnitt 2d). `schranken-gegenprobe.pl` in
`paket-bereit.pl` aufnehmen, Rückgabe 2 nicht als Abweisung zählen, und die
Meldung der Schranke beim Rückfall ausgeben (heute nach `devnull`), damit
man sieht, **warum** sie abweist. **Mittel.**

### <a id="k13"></a>K13 — Kleinere Lücken: S-2 über die Projektdatei, „überholt" mit einer Ursache

**Gemessen** ([S-2](../Intern/BEFUNDE.md#s-2): `DEFAULT_SWM_MODE=0` in der Projektdatei, 293/293 grün)
und **am Quelltext belegt** (überholt: `grep` statt „alle Ursachen",
`pruefe-regressionstest.pl:197`). **Gering / Hinweis.**

---

## Gegenvermutungen

| Gegenvermutung | Ergebnis |
|---|---|
| Server- und Eudora-Name laufen nach K1 noch auseinander | **im Normalfall widerlegt** (Abschnitt 1a), **bestätigt** für Trenner NIL (gemessen) und INBOX mit Präfix ([K8](#k8)) |
| Unterordner behalten einen rohen Vorsatz | **widerlegt**: sie erben den kodierten Namen des Elternordners (`QCImapMailboxDirector.cpp:3020`) |
| `mboxlist.lst` schreibt den Anzeigenamen | **widerlegt**: erstes Feld ist `GetImapName()` (`QCImapMailboxDirector.cpp:728`) |
| Offline geht der Name roh in die Warteschlange | **widerlegt**: kodiert, reines ASCII (`ImapActionQueue.cpp:2764`) |
| Der neue Fall [E-25](../Intern/BEFUNDE.md#e-25) ist auf dem richtigen Stand fälschlich rot | **widerlegt**: ` FileList =` steht nur noch im Kommentar |
| Die Rückfälle aus den Commit-Nachrichten werden rot | **bestätigt, gemessen** ([E-77](../Intern/BEFUNDE.md#e-77) K1, K2, [E-20](../Intern/BEFUNDE.md#e-20)) |
| Ein anderer Rückfall wird auch rot | **widerlegt** für [E-20](../Intern/BEFUNDE.md#e-20), [E-25](../Intern/BEFUNDE.md#e-25), [E-18](../Intern/BEFUNDE.md#e-18), [E-35](../Intern/BEFUNDE.md#e-35), [E-62](../Intern/BEFUNDE.md#e-62), die Hülle zu [E-77](../Intern/BEFUNDE.md#e-77) und [S-2](../Intern/BEFUNDE.md#s-2) (gemessen) |
| `schranken-gegenprobe` meldet 14/14 | **bestätigt, gemessen** |
| `hat_test` sieht nur echte Tests | **widerlegt, gemessen**: 7 Kennungen nur in Kommentaren, darunter [E-108](../Intern/BEFUNDE.md#e-108) |
| `E-113b2` kann eine Zeile vom Vorlauf lesen | **widerlegt**: `eudora.log` wird vor jedem Lauf gelöscht (`pruefstand-lauf.ps1:157`) |
| `E-77d` liest das falsche Feld von `mboxlist.lst` | **widerlegt**: das erste Feld ist der Servername |
| Die S-2-Zwangsumstellung in `QCSharewareManager.cpp` macht Fuß 3 überflüssig | **widerlegt**: sie ist auskommentiert (`:50-57`) |
| Die Werbeleiste kann über die INI entstehen | **widerlegt**: `WazooBar.cpp` kennt `CAdWazooWnd` nicht |

## Was gelaufen ist

* `Eudora71/Tests/RunTests.cmd` im Arbeitsbaum `Eudora7.2-wt-pruefer`:
  **293 Tests, 293 bestanden**, Rückgabe 0.
* `perl tools/schranken-gegenprobe.pl`: 14 von 14.
* `perl tools/pruefe-regressionstest.pl --hinweis`: 39 von 67 kritischen
  gedeckt, 26 ohne Prüfung.
* 11 Rückfallproben gegen `EudoraTests.exe` und 4 gegen die Schranken, je
  Probe die Datei mit Perl `:raw` geändert, gefahren, zurückgeschrieben,
  SHA-1 bzw. `cmp` gegen die Kopie geprüft. `git status` danach leer.
* Messprogramm `ReverseFind('\0')` mit `cl` (VS2022, Win32, ATL `CStringA`).
* Zählprogramm „Kennung nur im Kommentar" über `Eudora71/Tests/*.cpp`.
* Die Skripte im Scratch-Verzeichnis, nichts davon liegt im Repo.
* Kein Eudora gebaut oder gestartet, kein Fenster, nichts unter `C:\Temp`
  angefasst.
* **Hinweis zum Haken:** Mein erster Commit dieses Berichts wurde um 23:28
  von `pruefe-startwege.pl` abgewiesen: drei Eudora-Starts heute in
  `C:\Temp\E119K` (23:22:12, 23:23:31, 23:25:42) ohne Zeile in
  `tools/TESTLAEUFE.md`. Die Starts sind nicht von mir. Die Schranke prüft
  alle Prüfstände unter `C:\Temp` gegen die `TESTLAEUFE.md` des eigenen
  Arbeitsbaums. Ein fremder Start sperrt damit die Commits aller anderen
  Arbeitsbäume, bis seine Zeile über `main` dort ankommt. Wer hat in
  `E119K` gestartet, und mit welcher Freigabe? Auch der zweite Versuch um
  23:37 wurde abgewiesen. Gesichert ist der Bericht deshalb erst nach
  Mitternacht, als die Schranke nur noch den neuen Tag prüfte. Umgangen
  habe ich sie nicht (kein `--no-verify`). Die Starts vom 24.10. stehen
  weiter in keiner `TESTLAEUFE.md`.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | [E-20](../Intern/BEFUNDE.md#e-20): Der Test ist grün, wenn der ursprüngliche Überlauf ohne Leerzeichen zurückkommt | wichtig (Prüfstand) | nein |
| [K2](#k2) | [E-35](../Intern/BEFUNDE.md#e-35) u. a.: Die GetButton-Schranke lässt das umbrochene QUALCOMM-Original und zwei weitere Rückfälle durch | wichtig (Prüfstand) | nein |
| [K3](#k3) | [E-62](../Intern/BEFUNDE.md#e-62)/[E-61](../Intern/BEFUNDE.md#e-61): Schranke grün, obwohl `WM_QUIT` wieder verschluckt wird | wichtig (Prüfstand) | nein |
| [K4](#k4) | `pruefe-regressionstest.pl` zählt Kommentare als Test; [E-108](../Intern/BEFUNDE.md#e-108) (kritisch) gilt als gedeckt | wichtig (Prüfstand) | nein; vor 7.2.1.0 beheben |
| [K5](#k5) | [E-25](../Intern/BEFUNDE.md#e-25): grün bei einer Doppelfreigabe in anderer Schreibweise | mittel | nein |
| [K7](#k7) | [E-77](../Intern/BEFUNDE.md#e-77): Testfall prüft Aufrufnamen, nicht die Gleichheit; Hülle ungetestet | mittel | nein |
| [K11](#k11) | `E-113b2` grün, auch wenn das Fenster nicht schmaler wurde | mittel | nein |
| [K12](#k12) | Schranken zählen als Test ohne laufende Rückfallprobe; Rückgabe 2 zählt als Abweisung | mittel | nein |
| [K6](#k6) | [E-18](../Intern/BEFUNDE.md#e-18): Reihenfolge statt Wirkung | gering | nein |
| [K8](#k8) | **[E-146](../Intern/BEFUNDE.md#e-146) (neu)**: Umbenennen ohne Trenner oder INBOX mit Präfix führt anderen Namen als der Server (Original) | gering | nein |
| [K9](#k9) | Umbenennen scheitert am Server, Eudora bleibt umbenannt (Original) | gering | nein |
| [K10](#k10) | `E-77d` verlangt keinen `SELECT`; Prüfserver prüft Namen nur bei vier Befehlen | gering | nein |
| [K13](#k13) | [S-2](../Intern/BEFUNDE.md#s-2) über die Projektdatei; „überholt" genügt eine Ursache | gering / Hinweis | nein |

**Vergeben: [E-146](../Intern/BEFUNDE.md#e-146). Frei: [E-147](../Intern/BEFUNDE.md#e-147).** Eingetragen in
`Intern/BEFUNDE.md` ist nichts.
