# <a id="pruefer-64"></a>PRUEFER-64 — Prüfung der Behebung von E-166 (Junk-Frage kommt wieder), 28.10.2026

**Auftrag.** Alles, was seit `2a8f564` unter `Eudora71`, `tools` und
`Releases/1.0` dazukam (`git log 2a8f564..HEAD`): die Commits `978a852a`,
`eeaa4606`, `249e4f95`, `772ed08d` und `473f570f`. Einzige Änderung am
Quelltext ist [E-166](../Intern/BEFUNDE.md#e-166) in
`Eudora71/Eudora/persona.cpp`: `CPersonality::Modify` ruft jetzt
`FlushINIFile()` vor `SavePersonaInfo`. Dazu kamen die Messskripte
`tools/messen-e166.ps1`, `tools/messen-e166-assistent.ps1`,
`tools/messen-e166-konto.ps1`, die Fälle E-166a/E-166b in
`tools/pruefstand-faelle.txt` und eine neue Datumsprüfung in
`tools/testlauf.ps1`.

Eudora wurde weder gebaut noch gestartet, kein Prüfstand lief, kein
Messskript wurde ausgeführt. Gefahren habe ich nur die Testsuite in meinem
Arbeitsbaum (`wt/pruefer-20261028`, Stand `473f570f`):
**314 Tests, 314 bestanden** (gemessen). Kein Test berührt [E-166](../Intern/BEFUNDE.md#e-166). Die Zahl
sagt also nur, dass nichts anderes kaputtging. Die MFC-Stellen stammen aus
der Quelle auf diesem Rechner (`VC/Tools/MSVC/14.38.33130/atlmfc/src/mfc`).

**Ergebnis vorweg.**

* **Die Behebung ist richtig, und die Reihenfolge stimmt.** Erst wird der
  Zwischenspeicher geschrieben, dann die Kontodaten. Andersherum würde ein
  alter Wert aus dem Speicher die gerade eingegebenen Kontodaten
  überschreiben, denn beide benutzen dieselben Schlüssel in `[Settings]`
  (am Quelltext belegt, siehe [Frage 1](#frage-1--stimmt-die-reihenfolge)).
* **Der Flush schreibt nichts, was Eudora nicht ohnehin geschrieben hätte.**
  Ohne den Aufruf in `Modify` landen dieselben Werte beim regulären Beenden
  in der Datei. Die Behebung verhindert nur, dass sie vorher weggeworfen
  werden. Das gilt auch für Persönlichkeiten, Import und Abbruch (am
  Quelltext belegt).
* **Nebenwirkung, erwünscht:** Auch ein gespeichertes Passwort, das Eudora
  nach dem Abruf nur im Speicher hielt, ging bisher mit OK in
  *Konto → Eigenschaften* verloren. Das ist jetzt ebenfalls behoben
  (am Quelltext belegt; ob es je vorkam, ist nicht gemessen).
* **Dieselbe Fehlerklasse gibt es an keiner weiteren Stelle.** Alle vier
  Aufrufe von `RemoveAllFromCache` schreiben jetzt vorher (am Quelltext
  belegt).
* **Die Junk-Antwort kann trotzdem noch verloren gehen**, und zwar wenn
  Eudora nicht regulär endet, etwa durch Defender
  ([E-124](../Intern/BEFUNDE.md#e-124)) oder einen Absturz ([K4](#k4)). Das
  ist ein zweiter Weg zum selben Fehlerbild. Er ist nicht gemessen und hält
  das Paket nicht auf.
* **Der Regressionstest misst heute den richtigen Weg**, hat aber zwei
  Schwächen. Die Marke `konto-ok` wird gesetzt, ohne zu prüfen, ob das
  Fenster zuging ([K2](#k2)). Und der Test wird blind, sobald jemand
  [K4](#k4) behebt ([K3](#k3)).
* **Hält ein Fund das nächste Paket auf? Nein.** Es gibt keinen kritischen
  Fund. Gregors Test aus dem Eintrag zu [E-166](../Intern/BEFUNDE.md#e-166) bleibt gültig.

## Frage 1 — Stimmt die Reihenfolge?

**Ja** (am Quelltext belegt).

* `FlushINIFile` (`rs.cpp:1189-1266`) schreibt jeden Eintrag mit
  `IES_DIRTY`. Gewöhnliche Einträge landen in dem Abschnitt, den
  `GetSectionID` aus der Kennung ableitet (`rs.cpp:89-98`): `[Settings]`,
  `[Debug]` oder Fensterpositionen, **nie** in einer Persönlichkeit
  (`rs.cpp:1255-1259`). Nur das Passwort (`IDS_INI_SAVE_PASSWORD`,
  `IDS_INI_SAVE_PASSWORD_TEXT`) geht an die gerade aktuelle Persönlichkeit
  (`rs.cpp:1239-1253`).
* `SavePersonaInfo` (`persona.cpp:931-1076`) schreibt direkt mit
  `WritePrivateProfileString`. Für die Hauptpersönlichkeit ist der
  Abschnitt `Settings` (`persona.cpp:937-938`).
* **Beide benutzen dieselben Schlüssel.** `IDS_INI_PERSONA_POP_ACCOUNT`
  (10497) und `IDS_INI_POP_ACCOUNT` (10001) heißen beide `POPAccount`,
  ebenso `RealName`, `SMTPServer` und `LoginName` (`EudoraRes.rc:10044-10046`,
  `:10809`, `:10815-10816`, `:7833`, `:10463`). `SavePersonaInfo` benutzt
  außerdem gewöhnliche Kennungen wie `IDS_INI_LEAVE_ON_SERVER_DAYS`,
  `IDS_INI_USES_IMAP` und `IDS_INI_AUTH_APOP` direkt (`persona.cpp:974-1047`).
* **Folge für die Reihenfolge.** Steht etwa `POPAccount` schmutzig im
  Speicher, und der Flush käme **nach** `SavePersonaInfo`, dann würde der
  alte Wert die neue Eingabe in `[Settings]` überschreiben. So wie es jetzt
  steht, schreibt der Flush zuerst, und `SavePersonaInfo` gewinnt.
* **Kein Fenster dazwischen.** `SavePersonaInfo` ruft kein `SetIni…`. Nach
  dem Flush kann also bis `RemoveAllFromCache` (`persona.cpp:228`) kein
  neuer schmutziger Wert entstehen.
* **Fehlschlag von `SavePersonaInfo`.** Dann kehrt `Modify` ohne
  `RemoveAllFromCache` zurück (`persona.cpp:225-226`), und der Speicher
  zeigt teils alte Werte. Das war schon vorher so. Der Flush ändert daran
  nichts; er hat in diesem Fall nur seine Werte schon geschrieben.

## Frage 2 — `Modify` für eine andere als die aktuelle Persönlichkeit

**Kein neues Verhalten** (am Quelltext belegt).

Der Speicher gehört immer zur **aktuellen** Persönlichkeit
(`GetIniString` liest zuerst deren Abschnitt, `rs.cpp:330-340`). Wird
`Modify` für eine andere Persönlichkeit P gerufen, während Q aktuell ist,
dann:

* gehen schmutzige Passwortwerte an Q. Das ist richtig, denn sie stammen
  von Q.
* gehen alle anderen schmutzigen Werte nach `[Settings]`. Das tut
  `SetCurrent` (`persona.cpp:194`) genauso, ebenso das Beenden
  (`eudora.cpp:2189` → `rs.cpp:1435`). Dass Werte einer Nebenpersönlichkeit
  so in `[Settings]` landen können, ist eine Eigenheit des Originals, die
  der Flush nicht neu schafft. **Vermutung:** im Fenster
  *Konto → Eigenschaften* ist Q praktisch immer die Hauptpersönlichkeit,
  denn `CPersonaStateMgr` stellt nach jedem Wechsel zurück.
* schreibt `SavePersonaInfo` in den Abschnitt von P. Dorthin schreibt der
  Flush nie. Es gibt also keinen Konflikt.

## Frage 3 — Die Aufrufer von `Modify`

**Keiner wird durch den Flush beschädigt** (am Quelltext belegt).

| Aufrufer | Was passiert | Urteil |
|---|---|---|
| `ModifyAcctSheet.cpp:126` | nur nach `DoModal() == IDOK` | Bei Abbruch wird `Modify` nicht gerufen, es ändert sich nichts. |
| `WizardPropSheet.cpp:199` (Assistent, Hauptpersönlichkeit) | nur auf dem Fertig-Zweig | Der Abbruchzweig (`:225-243`) ruft `Modify` nicht. `ClearIniEntries` (`:313-327`) schreibt selbst und war schon vorher so. Mit ACAP setzt `acapdlg.cpp:990-1030` viele Werte nur im Speicher. Bisher warf `Modify` sie weg, jetzt bleiben sie. Der Kommentar in `WizardPropSheet.cpp:227-240` geht davon aus, dass sie gespeichert werden. ACAP-Server gibt es nicht mehr. |
| `MAPIImport.cpp:1970` (Import, Hauptpersönlichkeit) | Flush mitten im Import | Geschrieben wird nur, was beim Beenden ohnehin geschrieben würde. |
| `MAPIImport.cpp:2043` | — | **Toter Code.** Die Zeile steht im Kommentarblock `MAPIImport.cpp:2026-2060` (`/*CPersonalityTree*` … `}*/`). Siehe [K1](#k1). |

**Zum Abbruch im Fenster *Konto → Eigenschaften*.** `CModifyAcctSheet`
fängt `IDOK` mit `ON_BN_CLICKED(IDOK, OnOK)` ab (`ModifyAcctSheet.cpp:29`).
MFC leitet ein `WM_COMMAND` ohne Knopf-Handle als `CN_COMMAND` weiter
(`wincore.cpp:2759-2776`), und `CN_COMMAND` ist wie `BN_CLICKED` gleich 0.
`OnOK` läuft also auch ohne Handle und endet mit `EndDialog(IDOK)`
(`ModifyAcctSheet.cpp:177`). Die Falle aus den Läufen 4 bis 7 betrifft nur
den Assistenten. Er hat keine eigene `IDOK`-Behandlung, deshalb gilt dort
`CPropertySheet::OnCommand` (`dlgprop.cpp:1523`).

**Allgemein gilt:** Jeder Wert, den der neue Flush schreibt, wäre auch beim
regulären Beenden geschrieben worden. Vor der Behebung ging er verloren.
Der Flush schreibt ihn jetzt **früher**, schreibt aber nichts **anderes**.
Die einzige Ausnahme ist das Passwort. Es geht an die Persönlichkeit, die
beim Flush aktuell ist, und das ist die richtige.

## Frage 4 — Dieselbe Fehlerklasse an anderer Stelle?

**Weitere Stellen, die schmutzige Werte wegwerfen, gibt es nicht**
(am Quelltext belegt, Suche über ganz `Eudora71` ohne `Tests`).

* `RemoveAllFromCache` wird viermal gerufen: `persona.cpp:195`, `:228`,
  `:801` und `WizardPropSheet.cpp:326`. Jedes Mal steht `FlushINIFile`
  davor.
* `RemoveIniFromCache` (ein einzelner Eintrag) wird nur in
  `compmsgd.cpp:279` für `IDS_INI_DEFAULT_TRANSLATOR` gerufen. Diesen Wert
  setzt im ganzen Quelltext niemand mit `SetIni…`. Es kann also nie ein
  schmutziger Wert verloren gehen.
* `ForgetPasswords` (`persona.cpp:840-873`) hat den Flush
  auskommentiert. Die Persönlichkeiten wechseln dort aber über
  `SetCurrent`, und das schreibt. Der letzte Wert bleibt bis zum nächsten
  Flush im Speicher. Bisher konnte `Modify` ihn wegwerfen, jetzt nicht mehr.
* `CPersonality::Add` (`persona.cpp:235-276`) schreibt nur den Abschnitt
  der **neuen** Persönlichkeit. Der Speicher gehört zur aktuellen und wird
  nicht berührt. Damit ist `Add` nicht betroffen.

**Die umgekehrte Richtung gibt es:** eine Stelle schreibt direkt in die
Datei, an einem schmutzigen Eintrag vorbei, und der Eintrag überschreibt
sie später. Siehe [K5](#k5).

## Frage 5 — Messen E-166a und E-166b den Weg?

**Heute ja, mit zwei Schwächen** (am Quelltext belegt; die Skripte habe
ich nur gelesen).

* **Kein Vakuum-Grün bei fehlender `MFC71.DLL`/`msvcp71.dll`.**
  `messen-e166-konto.ps1 -Vorbereiten` bricht mit Rückgabe 1 ab
  (`:34-39`). `pruefstand-lauf.ps1:270-277` zählt beide Fälle dann als
  `[FEHL]`. Die Fälle sind also rot und nicht grün. Ohne die Zusätze kommt
  die Junk-Frage ohnehin nicht. Dann steht `AskedAboutJunk=4` in der INI
  (Bit `boxAsked`, `eudora.cpp:1782`), und E-166b sucht `=6`.
* **Die Junk-Frage wird an einem Merkmal erkannt**, am Titel und am
  Prozess aus dem Pfad (`messen-e166-assistent.ps1:53-70`). Die
  Persönlichkeiten-Liste wird an der neuen `SysListView32` erkannt oder
  ersatzweise am Eintrag `<Dominant>` (`:152-177`). `CPersonalityView` ist
  ein `CListView`, das Fenster ist also die Ansicht selbst, und
  `msgPersViewEditDom` = `WM_APP+11` = `0x800B` stimmt
  (`EudoraMsgs.h:44`, `PersonalityView.cpp:849-861`).
* **Ein fremder Dialog zählt nicht als Erfolg.** Jeder `#32770`, der nicht
  die Junk-Frage ist, gilt als „Assistent“ und wird abgebrochen (`:68-69`,
  `:133-139`). Dann beginnt `reihenfolge=` mit `assistent-abgebrochen`, und
  E-166a ist rot, weil `reihenfolge=junk-no,konto-ok` als Teilstring fehlt.
* **Erste Gegenvermutung, widerlegt:** „`-Vorbereiten` kürzt die Zeile
  `WazooBar318` bei jedem Lauf weiter.“ Die Zeile hat die Form
  `Lage,Klasse,…,Klasse[,aktiver Reiter]` (`WazooBar.cpp:786-850`). Das
  Muster `,\d+$` nimmt nur die Reiternummer. Danach endet die Zeile auf
  einen Klassennamen, und ein zweiter Lauf ändert nichts mehr.
* Schwächen: [K2](#k2), [K3](#k3) und [K6](#k6).

## <a id="k1"></a>K1 — Der Eintrag zu E-166 nennt einen toten Aufrufer und alte Zeilen

Der Eintrag zu [E-166](../Intern/BEFUNDE.md#e-166) nennt `MAPIImport.cpp:2043` als Aufrufer von
`Modify`. Die Zeile steht aber in einem Kommentarblock
(`MAPIImport.cpp:2026-2060`). Außerdem nennt er `persona.cpp:793-794` als
Stelle mit Flush. Seit der Behebung sind das `:800-801`, die sieben neuen
Zeilen haben alles darunter verschoben. In der Liste fehlt
`compmsgd.cpp:279` (`RemoveIniFromCache`). Die Stelle ist harmlos, siehe
[Frage 4](#frage-4--dieselbe-fehlerklasse-an-anderer-stelle), gehört aber
zur Vollständigkeit dazu.

**Vorschlag.** Im Eintrag `:2043` als „auskommentiert“ kennzeichnen und
`:793-794` auf `:800-801` berichtigen.

**Schwere: sehr niedrig** (nur Doku). **Hält das Paket auf: nein.**

## <a id="k2"></a>K2 — `konto-ok` wird gemeldet, ohne zu prüfen, ob das Fenster zuging

`messen-e166-assistent.ps1:184-190` schickt OK an das Fenster
*Konto-Eigenschaften*, fragt danach `IsWindow` ab und **gibt das Ergebnis
nur aus**. `konto-ok` wird in jedem Fall angehängt. E-166a prüft nur diese
Marke.

**Was dann passiert.** Bleibt das Fenster offen, etwa weil eine Rückfrage
erscheint (`ModifyAcctSheet.cpp:168-175`), endet der Lauf vermutlich mit
Abschuss statt regulärem Beenden. Dann fehlt `AskedAboutJunk`, und E-166b
ist rot. Das ist unbequem, aber ehrlich (Vermutung). **Vakuum-grün** wird
es, wenn das Fenster zugeht, ohne dass `Modify` läuft, also als Abbruch.
Dann schreibt das Beenden `AskedAboutJunk=6`, und beide Fälle sind grün,
mit und ohne Behebung. Heute ist dieser Weg nicht zu sehen, weil `OnOK`
auch ohne Knopf-Handle läuft ([Frage 3](#frage-3--die-aufrufer-von-modify)).
Er bleibt aber offen.

**Vorschlag.** `konto-ok` nur anhängen, wenn
`-not [E166A]::IsWindow($blatt[0])`. Besser noch: in `Modify` eine
Spurzeile ins Protokoll schreiben, etwa
`E-166 Modify: Zwischenspeicher geschrieben`, und E-166a im Log danach
suchen lassen. Dann belegt der Fall, dass `Modify` wirklich lief.

**Schwere: niedrig.** **Hält das Paket auf: nein.**

## <a id="k3"></a>K3 — Der Test hängt daran, dass vor dem OK nichts anderes schreibt

E-166b ist nur rot ohne Behebung, wenn zwischen der Junk-Antwort und dem
OK in *Konto → Eigenschaften* **kein anderer** `FlushINIFile` läuft. Heute
ist das so, gemessen am roten Lauf mit Paket 1.0.127. Beim Start gibt es
aber schon Flushes an anderen Stellen (`eudora.cpp:1671`,
`mainfrm.cpp:1450`, `mainfrm.cpp:2452`). Rückt einer davon hinter die
Junk-Frage, oder kommt ein neuer dazu, wird E-166b auch ohne die
Behebung grün. Am sichersten passiert genau das, wenn jemand [K4](#k4) so
behebt, wie dort vorgeschlagen.

Das ist der Fall aus
[schranke-teilt-nicht-die-annahme](../Arbeitsweise/schranke-teilt-nicht-die-annahme.md):
Der Test nimmt an, dass die Junk-Antwort beim OK noch ungeschrieben ist.

**Vorschlag.** Zusammen mit K4 umbauen. Entweder misst der Test einen Wert,
der garantiert nur im Speicher steht (etwa die Fensterposition eines
Postfachs, das kurz vor dem OK bewegt wurde). Oder er stützt sich auf die
Spurzeile aus [K2](#k2). Die Gegenprobe ohne Behebung ist nach dem Umbau
einmal neu zu fahren
([gegenprobe-einmal-beim-bau](../Arbeitsweise/gegenprobe-einmal-beim-bau.md)).

**Schwere: niedrig** (heute). **Wird mittel, sobald K4 behoben ist.**
**Hält das Paket auf: nein.**

## <a id="k4"></a>K4 — Die Junk-Antwort steht bis zum Beenden nur im Speicher

`InitJunkFeature` setzt die Antwort mit `SetIniShort`
(`eudora.cpp:1862`) und schreibt sie nicht. In die Datei kommt sie erst
beim regulären Beenden (`eudora.cpp:2189` → `rs.cpp:1435`) oder beim
nächsten Flush aus anderem Anlass. Endet Eudora vorher ohne Beenden, etwa
durch Defender ([E-124](../Intern/BEFUNDE.md#e-124), in Gregors erstem
Protokoll um 16:37 schon einmal geschehen), durch einen Absturz oder den
Task-Manager, dann kommt die Frage beim nächsten Start wieder. Das ist
dasselbe Fehlerbild wie in [E-166](../Intern/BEFUNDE.md#e-166) mit einer anderen Ursache.

Der Eintrag zu [E-166](../Intern/BEFUNDE.md#e-166) widerlegt diese Ursache **für Gregors Sitzung von
22:26**, denn die endete regulär. Den Weg selbst schließt er nicht aus.
`messen-e166.ps1` hat dafür den Schalter `E166_HART=1`. Laut
`TESTLAEUFE.md` und dem Eintrag zu [E-166](../Intern/BEFUNDE.md#e-166) wurde er mit den Zusätzen nie
gefahren (nicht gemessen).

Eudora macht es an anderer Stelle schon richtig: `IDS_INI_SEEN_INTRO`
wird sofort geschrieben (`eudora.cpp:1670-1671`), ebenso
`IDS_INI_OPEN_WINDOWS_FAILED` (`mainfrm.cpp:2451-2452`).

**Vorschlag.** `FlushINIFile()` direkt nach `eudora.cpp:1862`. Vorher
[K3](#k3) bedenken. Als Fortschreibung von [E-166](../Intern/BEFUNDE.md#e-166) eintragen (Ort
`InitJunkFeature`, den [E-166](../Intern/BEFUNDE.md#e-166) schon nennt), nicht als neuen Befund.

**Schwere: niedrig** (die Frage kommt noch einmal, Einstellungen gehen
nicht verloren). **Hält das Paket auf: nein.**

## <a id="k5"></a>K5 — `PurgeIniSetting` schreibt am Zwischenspeicher vorbei

`PurgeIniSetting` (`rs.cpp:1472-1498`) löscht einen Schlüssel direkt in der
Datei. Den Eintrag im Speicher lässt es stehen. Ist er schmutzig, schreibt
der nächste Flush den alten Wert zurück, und das Löschen ist umsonst. Bis
zum Neustart liefert `GetIni…` außerdem weiter den alten Wert.

Beispiel (Vermutung, nicht gemessen): Gregor blendet in einer Sitzung die
Werkzeugleiste aus (`mainfrm.cpp:7320`, `SetIniShort(IDS_INI_SHOW_TOOLBAR)`).
Danach wählt er *Werkzeugleisten zurücksetzen*. `OnResetTools` löscht den
Schlüssel (`mainfrm.cpp:5160`) und beendet Eudora (`:5174`). Das Beenden
schreibt den schmutzigen Wert zurück, und die Leiste bleibt ausgeblendet.

Das ist die umgekehrte Richtung von [E-166](../Intern/BEFUNDE.md#e-166) und stammt aus dem Original
(Quelltext seit `567a5d87` unverändert). `befund-suchen.pl PurgeIniSetting`
meldet keinen bestehenden Befund.

**Vorschlag.** In `PurgeIniSetting` zuerst `RemoveIniFromCache(nID)`
rufen, wie es `RemoveIniKey` tut (`rs.cpp:218-238`). Vor einer Behebung
einmal am Prüfstand nachstellen.

**Kennung:** Vorschlag **E-167**, aufzunehmen erst nach einer Messung.
**Schwere: sehr niedrig** (Aussehen der Leisten). **Hält das Paket auf:
nein.**

## <a id="k6"></a>K6 — Kleinigkeiten in den Messskripten und in `testlauf.ps1`

* **`messen-e166-konto.ps1:48`** schreibt die INI mit
  `Set-Content -Encoding ascii` zurück. `Get-Content` liest unter
  PowerShell 5.1 nach der ANSI-Codepage. Umlaute in der INI des
  Prüfstands, etwa in `RealName` oder einem Pfad, würden zu `?`
  (PowerShell-Verhalten, nicht gemessen; die INI in `C:\Temp\E166` habe
  ich nicht gelesen). Ein Umlaut im Kontonamen würde dadurch beim ersten
  Lauf zerstört. Besser: `-Encoding Default`, oder byte-genau über
  `[IO.File]::ReadAllBytes`.
* **`messen-e166-konto.ps1:42`** prüft `^ReturnAddress=.+` in der ganzen
  Datei, nicht nur in `[Settings]`. Ein Konto in einer Nebenpersönlichkeit
  würde den Test bestehen lassen, und dann käme der Assistent. Folge: der
  Fall ist rot, nicht grün. Harmlos.
* **`messen-e166-assistent.ps1:64-72`** wartet im Konto-Fall die vollen
  30 s auf einen Assistenten, der nie kommt. Der Lauf kostet nur Zeit,
  falsch wird er dadurch nicht.
* **`testlauf.ps1:107-113`** weist jedes Datum in der Freigabe ab, das
  nicht genau `dd.MM.yyyy` von heute ist. Ein heutiges Datum ohne
  führende Null (am Monatsersten etwa Tag „1.“ statt „01.“) würde
  abgewiesen. Ebenso ein Satz wie *„wie am 27.10. besprochen,
  28.10.2026: ja“*, sobald das alte Datum mit Jahr dasteht. Das ist
  sicher, weil es eher zu viel abweist, kann aber eine echte Freigabe
  zurückweisen. Dann ist neu zu fragen.

**Schwere: sehr niedrig.** **Hält das Paket auf: nein.**

## Neue Kennungen

E-167 als Vorschlag für [K5](#k5), aufzunehmen erst nach einer Messung.
[E-168](../Intern/BEFUNDE.md#e-168) nicht vergeben. K4 schreibt [E-166](../Intern/BEFUNDE.md#e-166) fort. In `Intern/BEFUNDE.md` habe
ich nichts eingetragen.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| — | Fragen 1 bis 4: Die Behebung ist richtig. Der Flush vor `SavePersonaInfo` lässt die neuen Kontodaten gewinnen und schreibt nur, was das Beenden auch geschrieben hätte. Nebenbei rettet er gespeicherte Passwörter. Eine weitere Stelle, die Einstellungen wegwirft, gibt es nicht. | keine | nein |
| [K1](#k1) | Der Eintrag zu [E-166](../Intern/BEFUNDE.md#e-166) nennt `MAPIImport.cpp:2043`, das auskommentiert ist, und alte Zeilennummern. | sehr niedrig | nein |
| [K2](#k2) | Der Regressionstest meldet `konto-ok`, auch wenn das Fenster *Konto-Eigenschaften* offen blieb. Ginge es als Abbruch zu, wäre der Test grün, ohne etwas gemessen zu haben. | niedrig | nein |
| [K3](#k3) | Der Regressionstest ist nur rot ohne Behebung, solange vor dem OK niemand sonst die INI schreibt. Wer K4 behebt, macht ihn blind. | niedrig, nach K4 mittel | nein |
| [K4](#k4) | Endet Eudora nach der Junk-Antwort nicht regulär (Defender, Absturz), kommt die Frage beim nächsten Start wieder. Ein zweiter Weg zum Fehlerbild von [E-166](../Intern/BEFUNDE.md#e-166). Nicht gemessen. | niedrig | nein |
| [K5](#k5) | „Zurücksetzen“ einer Einstellung kann wirkungslos bleiben, wenn sie in derselben Sitzung geändert wurde. Stammt aus dem Original. Vermutung. Vorschlag E-167. | sehr niedrig | nein |
| [K6](#k6) | Prüfstand-Skript schreibt die INI als ASCII (Umlaute würden `?`). Die neue Datumsprüfung weist auch ein Datum ohne führende Null ab. | sehr niedrig | nein |
