# Startumgebung für den ersten Start von Eudora.exe

Vorarbeit vom 30.08.2026, Branch `eudora-exe-linkt`, gemessen an `a139f9b`.
Gegengelesen und in sechs Punkten berichtigt am **06.09.2026** (Agent LEKTOR,
`Befunde/LEKTOR-2.md`, L-6).

> **Überholt in den Voraussagen, weiter gültig in der Sache.** Diese Datei entstand,
> als `Eudora.exe` noch nicht linkte. Inzwischen linkt sie (`a807b93`), **Eudora
> startet**, ist bedienbar und ruft Mail über TLS ab (zuletzt 06.09.2026,
> 7.2.0.12, Port 995). Was hier als „ungeprüft" steht, ist teils
> beantwortet — die Antworten stehen in `BEFUNDE.md` unter S-1 bis S-3 und in
> `Releases/PAKETE.md`. Die Liste der Laufzeitdateien selbst gilt unverändert.
>
> Wesentlich hinzugekommen: die sieben vorgebauten Fremd-DLLs von 2006 brauchen die
> **VC7.1-Laufzeit**, und der Debug-Bau braucht die **VS2022-Debug-Laufzeiten**.
> Beides ist in der Checkliste unten eingearbeitet. Am 31.08.2026 scheiterte ein
> Startversuch an genau dieser Luecke mit `0xc000007b`.

Diese Datei sammelt, was beim ersten Startversuch danebenliegen muss — damit die
Suche danach nicht erst dann anfängt.

## Was zur Laufzeit gebraucht wird

Gemessen aus `Eudora.vcxproj` (`AdditionalDependencies`) und durch Nachsehen, ob
die jeweilige `.lib` eine DLL nennt (Import-Bibliothek) oder nicht (statisch):

| Bibliothek | Art | DLL nötig? | in `Bin/Debug`? |
|---|---|---|---|
| `Paige32d.lib` | Import | `Paige32d.dll` | **ja** |
| `SSCEWD32.LIB` | Import | `SSCEWD32.dll` | **nein — siehe unten** |
| `libpng.lib` | statisch | — | — |
| `zlib.lib` | statisch | — | — |
| `spchwrap.lib` | statisch | — | — |
| `qtmlclient.lib` | statisch | — | — |
| `libexpat.lib` | Import | `libexpat.dll` | ja |

Bemerkenswert: **QuickTime und das Speech-SDK sind statisch gebunden.** Es braucht
zur Laufzeit weder `qtmlClient.dll` noch eine Sprach-DLL, obwohl beide im Baum
liegen (`Qt3.x/Libraries/qtmlClient.dll`).

## Der Fall SSCEWD32

`SSCEWD32.LIB` ist eine Import-Bibliothek und nennt `SSCEWD32.dll`. Diese DLL liegt
**nirgends** — weder in `Eudora71/Bin/`, noch im Original-Installer unter
`InstallersForEudora/Eudora7.1/Data/win32/`, noch sonst im Baum.

Das ist vermutlich **kein Problem**, und zwar aus folgendem Grund: die
Rechtschreibprüfung ist stillgelegt. `spell.cpp` fehlt in der CHM-Freigabe und wurde
durch einen Platzhalter ersetzt; `ssce.h` ist ebenfalls ein Platzhalter. Damit ruft
**keine einzige Stelle** eine SSCE-Funktion auf, und der Linker verwirft den Import
mitsamt der DLL-Abhängigkeit.

**Ungeprüft** — nachweisbar erst, wenn `Eudora.exe` existiert:

```bash
dumpbin /dependents Eudora71\Bin\Debug\Eudora.exe
```

Taucht `SSCEWD32.dll` dort auf, muss sie beschafft werden (Sentry Spelling Checker
Engine von Wintertree Software), oder die Referenz muss aus dem Projekt heraus.

## Was gegenüber dem Original-Installer fehlt

Der Installer bringt 25 DLLs mit, `Bin/Debug` hat davon fünf nicht:

| Datei | Bedeutung |
|---|---|
| `EudoraRes.dll` | **Ressourcen-DLL.** Wird vom Projekt `EudoraRes` gebaut. Ohne sie startet Eudora nicht — sie enthält Dialoge, Zeichenketten und Symbole. |
| `paige32.dll` | Release-Variante der Textsatz-Engine; für den Debug-Bau nicht nötig (`Paige32d.dll` ist da). |
| `capicom.dll` | Microsoft-Kryptobibliothek, für S/MIME. |
| `dbghelp.dll` | Absturzberichte; liefert Windows selbst mit. |
| `EudUnInst.dll` | Deinstallation; für den Start unerheblich. |

**Der wichtige Posten ist `EudoraRes.dll`.** Sie ist kein Beiwerk, sondern trägt
die Oberfläche. Sie entsteht beim ganz gewöhnlichen Projektmappen-Bau in
`Eudora71/Bin/<Konfiguration>`.

> **Berichtigung (06.09.2026).** Hier stand, `EudoraRes` hänge *„über einen
> Projektverweis an OT501 und wird beim Solution-Bau übersprungen"*.
> Nachgesehen: `EudoraRes.vcxproj` hat **keinen** `ProjectReference` auf
> `OT501`, nur den Include-Pfad `..\OT501\Include`; seit Befund **B-3** wird
> `OT501` selbst gar nicht mehr gebaut.

## Checkliste für den ersten Startversuch

**Diese Liste gilt für einen selbst gebauten Baum, nicht für ein
Auslieferungspaket.** Ein Release-Paket aus `tools/paket-bauen.ps1` bringt
alles mit, was es braucht; wer daran nach Punkt 1 arbeitet, holt sich
Laufzeit-DLLs ins Paket, die **nicht weitergegeben werden dürfen**.

1. **Nur für den Debug-Bau: die vier Debug-Laufzeiten von Visual Studio 2022
   dazulegen.** Ohne sie scheitert der Start mit `0xc000007b`:

   ```powershell
   powershell -ExecutionPolicy Bypass -File tools\laufzeit-holen.ps1 -Ziel "<Verzeichnis>"
   ```

   Das Werkzeug holt `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll` und
   `ucrtbased.dll` aus `C:\Windows\SysWOW64` — dem **32-Bit**-Ordner, trotz des
   Namens — und prüft jede einzeln auf ihre Architektur nach.

   **Der Release-Bau braucht davon nichts.** Er bringt `mfc140.dll`,
   `msvcp140.dll` und `vcruntime140.dll` selbst mit; die drei gehören zum
   Visual-C++-Redistributable und dürfen beiliegen (Befund F-1). Die vier
   Debug-Laufzeiten dürfen das **nicht** — sie kommen nur mit einer
   Visual-Studio-Installation.

   > `0xc000007b` heißt `STATUS_INVALID_IMAGE_FORMAT` und bedeutet fast immer
   > Bitness-Konflikt. `Eudora.exe` ist x86. **Keine Laufzeit-DLLs von
   > Sammelseiten holen** — die liefern häufig die 64-Bit-Fassung, ohne es
   > deutlich zu machen. Am 31.08.2026 genau so passiert.

2. **Die VC7.1-Laufzeit für die sieben vorgebauten Fremd-DLLs von 2006.**
   Zwingend beim Laden sind laut Importtabelle nur `EuMemMgr.dll` und
   `Paige32d.dll`, beide brauchen `MSVCR71.dll`. Dafür gibt es inzwischen einen
   eigenen Nachbau unter `Eudora71/VC71Bruecke` — 1429 Weiterleitungen auf die
   von Windows mitgelieferte `msvcrt.dll`, siehe Befund B-1.

   `MFC71.DLL` und `MSVCP71.dll` fehlen weiterhin und sind nicht nachbaubar
   (`MFC71` wird über 157 Ordinale importiert). Dadurch fallen **Adressbuch,
   LDAP und Ph** aus. Mailabruf und -versand sind davon nicht betroffen.

3. **Eine `Eudora.ini` ins Mailverzeichnis.** Vorlage:
   `InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`.

   > **Berichtigung (06.09.2026).** Hier stand: *„Ohne sie bricht Eudora in
   > `eudora.cpp:3542` ab (`VERIFY(GetShortPathName(INIPath,…))`)."* Das stimmt
   > nicht. An `eudora.cpp:3542` steht `CEudoraApp::RegisterMailbox`. Das
   > gemeinte `VERIFY` sitzt in `CEudoraApp::RegisterCommandLine` und wirkt
   > **nur im Debug-Bau** — dort als SUPERASSERT-Dialog, nicht als Abbruch.
   > `GetDirs`/`CheckMailDirectory` prüfen nur, ob das Verzeichnis existiert;
   > eine fehlende INI hält Eudora nicht auf, es läuft dann mit den Vorgaben
   > für jede Einstellung. Sinnvoll ist die Datei trotzdem.

4. **Mit einem frischen, leeren Mailverzeichnis starten**, nicht mit dem
   produktiven:

   ```bash
   Eudora.exe "<Pfad zum leeren Mailverzeichnis>"
   ```

   Das ist kein Formalismus: der Auftraggeber liest mit Eudora täglich Mail. Ein
   Startversuch mit einer selbst gebauten Fassung gehört in eine Kopie.

5. **Nur im Debug-Bau: die drei bis vier SUPERASSERT-Dialoge wegklicken**
   (*Ignore Once*). Das sind Debug-Zusicherungen, keine Fehler — eine meldet
   nur, dass der Suchindex neu angelegt wird (Befund E-14). Im Release-Bau
   entfallen sie samt allen `ASSERT`/`VERIFY`.

6. **Den Fenstertitel ablesen.** Er trägt die Bau-Kennung. Sie wird vor jedem
   Bau von `tools/kennung-erzeugen.pl` erzeugt und hat heute die Form
   `Eudora <Produktversion> / Paket <Paketnummer>+<Commit><Marke> <Zeitpunkt>`,
   angehängt an das Herkunftsverzeichnis der EXE:

   ```
   Eudora - [In]   [Eudora 7.2.0.12 / Paket 1.0.12+9512108 2026-09-06 12:34 - Eudora72-1.0.12]
   ```

   Ein Sternchen hinter dem Commit heißt: beim Bau lagen ungesicherte
   Änderungen vor, der Bau ist nicht reproduzierbar. Bei einem Bildschirmfoto
   immer den Titel mit aufnehmen — sonst lässt sich eine Beobachtung keinem Bau
   zuordnen.

   > Der Kommentar in `mainfrm.cpp` bei `CMainFrame::OnUpdateFrameTitle` zeigt
   > noch die **alte**, kürzere Form `[1.0.3+31810e2 - Eudora72-1.0.3]`
   > (Befund M-9). Der Code ist richtig, nur sein Beispiel ist alt.

Wenn ein Paket geprüft werden soll, bevor es jemand auspackt, gibt es dafür
`tools/paket-pruefen.ps1`. Es rechnet die Startkette aus den PE-Importtabellen
aus und zählt einen Treffer in `SysWOW64`/`System32` ausdrücklich **nicht** als
vorhanden (PR-2.0 behoben am 06.09.2026, `Befunde/PAKET.md`). **Es ersetzt
keinen Startversuch auf einem fremden Rechner** — es sagt, ob der Lader alles
findet, nicht ob Eudora läuft.

## Was hier bewusst nicht steht

Diese Datei sagt, welche Dateien danebenliegen müssen, damit der Ladevorgang
nicht schon am Import scheitert. Sie sagt **nicht**, ob Eudora fehlerfrei läuft.

Dass Eudora **startet**, bedienbar ist und Mail über TLS abruft, ist seit dem
31.08.2026 belegt und am 06.09.2026 mit 7.2.0.12 wieder gemessen; der Stand
steht in [README.md](README.md) und [BEFUNDE.md](BEFUNDE.md). Offen sind
weiterhin Strg-N, Doppelklick auf eine Nachricht, die Suchtreffer und das
Beenden.

> **Berichtigung (06.09.2026).** Hier stand: *„Ob Eudora **startet**, sagt diese
> Datei nicht … Alles danach — Registry, `eudora.ini`, Mailverzeichnis, die
> Frage, ob die Ersatzschicht zur Laufzeit trägt — ist offen."* Das widersprach
> schon dem eigenen Kasten am Anfang der Datei.
