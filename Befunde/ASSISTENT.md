# ASSISTENT — Befunde zum Kontoassistenten

## E-25 — Der Absturz beim Klick auf *Weiter*: doppelte Freigabe in `NSImport.eif`

**Agent:** ASSISTENT · **Zweig:** `wt/assistent-2` · **Datum:** 05.09.2026 ·
**Fassung:** 7.2.0.10 · **Status:** Ursache belegt, behoben

Gregor am 05.09.2026, zu seinem **selbst gebauten** Stand
(`C:\Users\Gregor\Documents\github\selbst_bauen\Eudora7.2`, Bau grün,
18 Projekte): *„crash nach weiter (selbst compiliert)"*.

Das ist derselbe Absturz wie **E-9** vom 31.08.2026. Er ist nie behoben worden —
**E-11** hat ihn nur falsch erklärt (siehe unten).

### Der Beleg: der Fehlerbericht von Windows

Nicht vermutet, sondern gemessen. Das Ereignisprotokoll *Anwendung* und die
zugehörigen `Report.wer` unter
`C:\ProgramData\Microsoft\Windows\WER\ReportArchive` enthalten für den
05.09.2026 **zwei** Abstürze von Gregors eigenem Bau, elf Sekunden auseinander,
mit **identischer Kennung**:

| | |
|---|---|
| Anwendung | `...\selbst_bauen\Eudora7.2\Eudora71\Bin\Release\Eudora.exe`, 7.2.0.10 |
| Zeit | 05.09.2026 22:43:06 und 22:43:17 |
| Ausnahmecode | **`0xC0000374`** = `STATUS_HEAP_CORRUPTION` |
| Fehlermodul | `ntdll.dll` (`PCH_33_FROM_ntdll+0x0007379C`) |
| letztes geladenes Modul | **`NSImport.eif`**, danach nur noch `propsys.dll` |

Zwei Dinge stehen damit fest:

1. **Es ist keine Zugriffsverletzung auf einen Nullzeiger.** `0xC0000374` meldet
   der Heap-Verwalter selbst, wenn eine Freigabe auf einen bereits freigegebenen
   oder überschriebenen Block trifft. Damit sind alle bisherigen Verdächtigen
   der Form „hier fehlt eine NULL-Prüfung" **entlastet** — auch
   `WizardImportPage.cpp:379 → :420`.
2. **Der Absturz liegt in der Importer-Suche, und zwar im ersten `.eif`.** Im
   Programmverzeichnis liegen drei: `NSImport.eif`, `OEImport.eif`,
   `OLImport.eif`. Geladen ist **nur der erste**. Der Prozess ist also gestorben,
   bevor `InitDllStruct(1)` das zweite laden konnte.

### Die Kette, Zeile für Zeile

1. `CMainFrame::OnSpecialNewAccount` (`mainfrm.cpp:4286`) erzeugt
   `CWizardPropSheet dlg("", NULL, 0, true)`.
2. Die Begrüßungsseite `CWizardWelcomePage` hat **kein** `OnWizardNext`. Der
   Klick auf *Weiter* geht unmittelbar auf die nächste Seite,
   `CWizardClientPage` (`WizardPropSheet.cpp:343-344`).
3. `CWizardClientPage::OnSetActive` (`WizardClientPage.cpp:125-129`) legt als
   erstes `CImportMail` an und ruft `InitPlugins()`.
4. `CImportMail::InitPluginList` (`MAPIImport.cpp`) sucht `ExecutableDir` +
   `*.eif` und ruft für jeden Treffer `InitDllStruct`.
5. `InitDllStruct` ruft `::LoadLibrary("...\NSImport.eif")`.
6. Dessen `DllMain` (`Importers/NSImport/NSImport.cpp:16-23`) ruft bei
   `DLL_PROCESS_ATTACH` **`nsImport.LoadNSProvider()`** → `LoadNSAccounts()` →
   `LocateNetscapePrefsFile()`.

### Die Fundstelle

`Eudora71/Importers/NSImport/NSImportClass.cpp`, am Ende von
`LocateNetscapePrefsFile` (vor der Änderung Zeile **838-843**):

```cpp
BOOL NSImportClass::LocateNetscapePrefsFile(CCharArrList *FileList)   // :496
{
    ...
    DeleteCharListTree(&FileList);          // <- gibt den Knoten des AUFRUFERS frei
    FileList = NULL;
    FileList = DEBUG_NEW CCharArrList;      // <- neuer Knoten, nur oertlich bekannt
    FileList->lpszItem = NULL;
    FileList->pNext = NULL;
    ...
    return bRet;                            // <- der neue Knoten geht verloren
}
```

`FileList` ist ein Zeiger **nach Wert**. `DeleteCharListTree` (`:1048`) gibt den
Knoten frei und setzt nur die **örtliche** Kopie auf `NULL`. Der Aufrufer merkt
davon nichts:

```cpp
bool NSImportClass::LoadNSAccounts()                                   // :184
{
    CCharArrList * csPrefsFileList = DEBUG_NEW CCharArrList;           // :196
    csPrefsFileList->lpszItem = NULL;
    csPrefsFileList->pNext = NULL;

    LocateNetscapePrefsFile(csPrefsFileList);      // :200  <- Knoten freigegeben
    CCharArrList *pWalker  = csPrefsFileList;      // :201  <- haengender Zeiger
    ...
    while (pWalker) { ... pWalker = pWalker->pNext; }   // Lesen nach Freigabe
    ...
    DeleteCharListTree(&csPrefsFileList);          // :241  <- ZWEITE Freigabe
}
```

Also: **`delete` auf einen bereits freigegebenen Block.** Unter Windows 10 meldet
der Heap das sofort und beendet den Prozess mit `0xC0000374` — genau das, was der
Fehlerbericht zeigt.

**Das läuft immer.** Die Zeile `DeleteCharListTree(&FileList)` steht **außerhalb**
des `if (bDoItOnce == FALSE)`-Blocks und außerhalb jedes Netscape-Zweigs. Ob
Netscape oder Mozilla installiert ist, spielt keine Rolle. Auf jeder Maschine,
bei jedem Klick auf *Weiter*, beim ersten geladenen Importer.

Erschwerend: das alles läuft in **`DllMain`** unter der Ladesperre — deshalb
taucht im Modulverzeichnis direkt hinter `NSImport.eif` noch `propsys.dll` auf
(nachgeladen über `SHGetSpecialFolderLocation`).

### Warum es früher „ging"

Unter Windows 2000/XP war die doppelte Freigabe eines kleinen Blocks im alten
Heap meistens folgenlos — der Block blieb lesbar, die Freiliste wurde still
beschädigt. Der Heap von Windows 10 (LFH) prüft beim Freigeben und bricht sofort
ab. Das ist die klassische Signatur einer Portierung: der Fehler war 2006 schon
da und ist erst jetzt tödlich.

### Die Behebung

Der Kopfknoten des Aufrufers wird nicht mehr freigegeben, sondern **geleert und
weiterbenutzt**:

```cpp
    if (!FileList)
        return bRet;

    DeleteCharListTree(&(FileList->pNext));
    delete [] FileList->lpszItem;
    FileList->lpszItem = NULL;
    FileList->pNext = NULL;
```

`AddCharListTail` füllt danach genau wie vorher zuerst den Kopfknoten und hängt
den Rest an. Der Aufrufer gibt seinen Knoten wie bisher **einmal** frei.

### Zweiter Mangel auf demselben Weg, mitbehoben

`LoadNSAccounts` hatte `char tempbuffer[128]` und `char strName[_MAX_PATH]`,
gefüllt aus `szPrefsFileName`, das als `TCHAR[_MAX_PATH + _MAX_FNAME + _MAX_EXT]`
(**772 Byte**) deklariert ist und den vollen Pfad zur `prefs.js` trägt. Ein Pfad
über 127 Zeichen — bei `%APPDATA%\Mozilla\Users50\<Profil>\xxxxxxxx.slt\prefs.js`
schnell erreicht — schrieb über das Feldende hinaus. Beide Felder haben jetzt die
Größe der Quelle.

Dieser Mangel ist bei Gregor vermutlich **nicht** ausgelöst worden (kein
Netscape-Profil), aber er sitzt zwei Zeilen hinter dem behobenen Absturz und wäre
der nächste gewesen.

### Was NICHT die Ursache war — drei ausgeschlossene Verdächtige

| Verdacht | Warum ausgeschlossen |
|---|---|
| `AnyPersonalityHasAccount` (E-17, `eudora.cpp:849`) | entscheidet **nur**, ob der Assistent überhaupt gestartet wird (`:1661-1666`). Sie liest, schreibt nicht, und keine Seite des Assistenten fragt sie ab. Der Assistent baut nirgends auf „leere Konfiguration": `AddPages` verzweigt allein an `bDominant`, und `bDominant` kommt aus dem Aufruf, nicht aus der `Eudora.ini`. |
| `WizardImportPage.cpp:379 → :420` (Liste des Agenten ZEIGER) | echter Mangel — `pChild` wird bei `:420` ohne Prüfung dereferenziert, obwohl `SetupControls():265` denselben Wert ausdrücklich als NULL behandelt. Aber: das wäre eine Nullzeiger-Dereferenzierung (`0xC0000005`), gemessen wurde `0xC0000374`; und `CopySettings` läuft erst, wenn der Benutzer *Importieren* gewählt und auf der **Importseite** *Weiter* gedrückt hat. Ein anderer Fehler also - **in dieser Sitzung trotzdem mitbehoben**, siehe unten. |
| Ein Index über die Persönlichkeiten | Der Assistent fragt vor dem Anlegen des Kontos keine Persönlichkeitsliste ab. `UpdateWazoo()` und `g_Personalities.Add` laufen erst **nach** *Fertigstellen*. |

### Dritter Mangel, mitbehoben: der Zeiger vom falschen Typ auf der Importseite

`WizardImportPage.cpp` hat zwei Fehler auf derselben Stelle, beide vom Agenten
ZEIGER aufgezeigt und beim Nachlesen bestätigt:

1. `InitTree` legt **zwei Arten** von Baumknoten an: Wurzeln tragen einen
   `CImportProvider*` (`SetItemData(htiRoot, DWORD(pProvider))`), Blätter einen
   `CImportChild*`. `CTreeCtrlCheck::GetFirstCheckedItem` (`TreeCtrlCheck.cpp:614`)
   läuft über **beide** — es beginnt bei `GetRootItem()`. Und weil der Baum mit
   `SetContainerFlag()` läuft, gilt eine Wurzel als angekreuzt, sobald ihre Kinder
   es sind. Bei einem Anbieter mit genau **einem** Kind liefert
   `GetFirstCheckedItem` also die Wurzel, und der zurückgegebene Zeiger wird auf
   `CImportChild*` gecastet — ein Zeiger vom falschen Typ.
2. `CopySettings` dereferenzierte `pChild` danach bedingungslos (früher Zeile
   420), obwohl die Schwesterfunktion `SetupControls` denselben Wert zwei
   Funktionen weiter oben ausdrücklich als NULL-Fall behandelt.

Beide Stellen sind jetzt abgesichert: Wurzelknoten werden übersprungen
(`while (hItem && m_ImportTree.ItemHasChildren(hItem)) hItem = ...GetNextCheckedItem(hItem);`),
und `CopySettings` bricht bei `pChild == NULL` mit `false` ab — der Assistent
bleibt dann auf der Importseite stehen, statt abzustürzen.

**Ungeprüft am laufenden Programm**: die Importseite ist bis heute nie erreicht
worden, weil der Absturz oben davor lag.

### Berichtigung: warum E-11 die falsche Erklärung war

**E-11 gilt in `BEFUNDE.md` als „behoben" und als „URSACHE GEFUNDEN". Beides ist
falsch.**

E-11 stützte sich auf ein einziges Indiz: `eudora.log` bricht nach

    Dialog: "Eudora is not currently the default mail program..."

ab. Daraus wurde geschlossen, der Absturz liege in
`CEudoraApp::RegisterURLSchemes`, drei Zeilen hinter diesem Dialog, bei
`RegMailto.ReleaseBuffer(i)` ohne vorangehendes `GetBuffer`.

Der Schluss trägt nicht, aus drei unabhängigen Gründen:

1. **Der Schluss ist ein Fehlschluss.** `RegisterURLSchemes()` wird in
   `InitInstance` bei `eudora.cpp:1630` gerufen — der Assistent wird erst bei
   `:1665` per `PostMessage` angestoßen und läuft danach in der
   Nachrichtenschleife. Der Dialog kommt also **vor** dem Assistenten. Dass das
   Protokoll dort endet, heißt nur: **der Assistent protokolliert nichts.** Das
   ist kein Hinweis auf den Ort des Absturzes.
2. **Der Agent KETTE hat die Stelle rechnerisch widerlegt.** Alle drei Indizes in
   `RegisterURLSchemes` liegen weit unter der Länge der jeweiligen Zeichenkette
   (`mailto\shell\open\command`: 25 Zeichen, gekürzt auf 6;
   `Software\Clients\Mail\Eudora`: 28 auf 21;
   `x-eudora-option\shell\open\command`: 34 auf 15), und alle drei sind frisch
   gebaute `CRString` mit `nRefs == 1`. Keine der Zeilen kann abstürzen.
3. **Gregors Messung vom 05.09.2026 entscheidet es.** Die E-11-Behebung
   (`Truncate`) ist in seinem Bau enthalten, und der Absturz ist unverändert da —
   mit einer Kennung (`0xC0000374`), die eine `CString`-Pufferverwaltung gar nicht
   erzeugen kann.

**E-11 ist damit zurückzunehmen: der Absturz beim Klick auf *Weiter* lag nie in
`RegisterURLSchemes`.** Was bleibt, ist R-1: `ReleaseBuffer` ohne `GetBuffer` ist
eine echte Fehlerklasse mit 25 belegten Stellen, und sie gehört abgestellt. Sie
ist nur **nicht dieser Absturz**.

### Die beiden anderen Importer haben den Mangel nicht

Nachgesehen, nicht vermutet: `OEImportClass.cpp` und `OLImportClass.cpp`
geben nirgends einen **Parameter** frei, der als Zeiger nach Wert ankommt —
alle `Delete*Tree(&...)`-Aufrufe dort stehen auf Mitgliedern oder auf
`pEntry->...`. `OLImport` ruft in `DllMain` ohnehin nur `LoadModuleHandle`;
`LoadOLProvider` läuft erst beim Export `LoadProvider`. Es ist also nicht zu
erwarten, dass der Absturz nach dieser Behebung nur eine `.eif` weiterwandert.
Belegen lässt sich das erst, wenn Gregor den Assistenten durchläuft — vor
dieser Behebung ist `OEImport.eif` **nie geladen worden**.

### Zu Gregors Bau: die Paketnummer weicht ab

Sein Titel meldet `Paket 7.2.0.10+bb3102a`, der Stand im Repo `Paket 1.0.10`.
Zwei getrennte Abweichungen:

- Die Datei `VERSION` trägt im Repo `1.0.10`; in seinem Klon steht dort
  offenbar `7.2.0.10`, also die **Produktfassung** aus `Eudora71/Version.h`
  statt der Paketnummer. Die beiden Nummern sind verschiedene Dinge
  (`tools/kennung-erzeugen.pl`, Zeile 103 und 115).
- `bb3102a` ist in diesem Repo **kein gültiges Objekt** (`git cat-file -t`
  schlägt fehl, `git log --all` findet nichts). Sein Bau stammt also von einem
  Stand, der hier nie angekommen ist.

Für diesen Befund ist das folgenlos: `NSImportClass.cpp` ist seit `7f83ed6`
unverändert, die Fundstelle stand in jedem Bau seit Beginn der Portierung
gleich da. Für die Nachvollziehbarkeit ist es trotzdem zu bereinigen.

### Nebenbefund: der eigene Stapelfänger stürzt selbst ab

Um 22:46:31 desselben Abends starb Gregors Bau ein drittes Mal, diesmal mit
`0xC0000005` im Modul **`dbghelp.dll`, Fassung 6.4.7.1**, geladen aus
`Eudora71\Bin\Release`. Das ist die alte `dbghelp.dll`, die im Ausgabeverzeichnis
liegt und die aktuelle Fassung aus `System32` verdeckt. Solange sie dort liegt,
kann Eudoras eigener Absturzbericht keinen brauchbaren Stapel erzeugen — er
stürzt vorher ab und verdeckt den wahren Fehler. Eigener Befund, in dieser
Sitzung nicht angefasst.

### Was Gregor zum Nachprüfen tut

1. Frisch bauen (Release genügt).
2. `Eudora.ini` so lassen, dass der Assistent kommt (`ReturnAddress=` und
   `POPAccount=` leer, keine benannte Persönlichkeit mit Konto), oder
   *Special → New Account* aufrufen.
3. Auf der Seite *Welcome to Eudora!* auf **Weiter** klicken.

Erwartet: die Seite *Account Settings* erscheint. Erwartet **nicht**: ein
Absturz.

Sollte es weiter abstürzen, entscheidet es in einem Zug — `Get-WinEvent` auf das
Protokoll *Anwendung*, Quelle *Application Error*:

```powershell
Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='Application Error'} |
  Where-Object { $_.Message -like '*Eudora.exe*' } | Select-Object -First 3 TimeCreated, Message
```

Steht dort wieder `0xC0000374`, ist es eine weitere Doppelfreigabe; steht dort
`0xC0000005`, ist es ein anderer Fehler. Das **letzte geladene Modul** in der
zugehörigen `Report.wer` unter
`C:\ProgramData\Microsoft\Windows\WER\ReportArchive` sagt in beiden Fällen, wo
man anfängt zu suchen. Dieser Weg ist schneller und verlässlicher als
`tools\stapel-untersuchen.ps1`, solange die alte `dbghelp.dll` im
Ausgabeverzeichnis liegt.
