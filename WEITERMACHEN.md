# Hier weitermachen

> ## Stand 31.08.2026, abends — Übergabe an die nächste Sitzung
>
> **Arbeitsstand ist der Branch `claude/letzter-stand-b2ytpi`**, drei Commits
> vor `origin/main`, alles gepusht. `main` ist unberührt. Wer weitermacht,
> arbeitet auf diesem Branch weiter oder führt ihn zusammen.
>
> **Diese Sitzung lief ohne Visual Studio** — auf einem Linux-Rechner mit perl,
> git und python, ohne MSBuild, MSVC und PowerShell. Deshalb ist **keine Zeile
> C++ geändert** worden und **nichts gebaut**. Geändert wurden Dokumentation und
> Werkzeuge; beides ist hier nachprüfbar und wurde nachgeprüft.
>
> ### Das Wichtigste für den nächsten Lauf auf dem Win11-Rechner
>
> **Die Behebung von E-11 ist wahrscheinlich unvollständig.**
> `CEudoraApp::RegisterURLSchemes()` reicht von `eudora.cpp:3274` bis `:3417`,
> und in dieser **einen** Funktion stehen **drei** Vorkommen von
> `ReleaseBuffer` ohne `GetBuffer`:
>
> | Zeile | Stand |
> |---|---|
> | 3372 | behoben (E-11), jetzt `Truncate(i)` |
> | **3403** | `RegClientsMail.ReleaseBuffer(LastSlash)` — **unverändert** |
> | **3413** | `EudoraOption.ReleaseBuffer(SlashIndex)` — **unverändert** |
>
> `eudora.log` belegt nur, dass der Absturz **hinter `:3331`** liegt — nicht,
> dass er an `:3372` lag. **Stürzt das ZIP weiterhin beim Klick auf *Weiter*
> ab, sind das die nächsten Verdächtigen**, und es sind zwei Zeilen. Am besten
> vor dem nächsten Paket beheben, dann kostet es keinen zweiten Lauf.
> Vollständig in Befund **R-1**.
>
> ### Was diese Sitzung geliefert hat
>
> | Commit | Was |
> |---|---|
> | `3d19aca` | Doku zusammengezogen. `ZIEL.md` war im Commit davor in 40 Zeilen doppelt UTF-8-kodiert — berichtigt. Die Kriterientabelle stand an fünf Stellen in drei Fassungen; `ZIEL.md` ist jetzt die Quelle, die übrigen verweisen. Drei Dateien widersprachen sich in sich selbst. Vier Stellen behaupteten noch, der Release-Zweig scheitere an `Imap.lib`. Dritter Lektorats-Durchgang in `LEKTORAT.md`, **alle 45 Markdown-Dateien gelesen**. |
> | `8f1c51e` | `tools/releasebuffer-pruefen.pl` — stuft die 142 `ReleaseBuffer`-Vorkommen ein: **117 richtig, 25 zu ändern**. Befund **R-1** mit allen Fundstellen, nach Häufigkeit des Wegs geordnet. |
> | `1819e61` | Die **neun Löcher** der Commit-Schranke aus X-1 geschlossen, jedes mit eigenem Testfall (23 → 35 Fälle). Dazu der pre-commit-Hook, der den Abbruch des Spiegelns verschluckte. Befund **X-2**. |
>
> ### Auflage für den nächsten frischen Klon
>
> **`sh tools/hooks-einrichten.sh` einmal laufen lassen** — der Hook liegt unter
> `.git/hooks` und wird von git nicht mitversioniert. Ein alter Hook aus einem
> früheren Klon verschluckt den Abbruch des Spiegelns weiterhin (X-2).
>
> ---
>
> ## Stand 31.08.2026, 09:00 — der Vormittag
>
> **Die Arbeitsliste steht in [AUFGABEN.md](AUFGABEN.md)** — was zu tun ist,
> in welcher Reihenfolge, mit Fundstelle je Punkt und den Auflagen für
> Agenten. Diese Datei hier erklärt den Weg dorthin.
>
> **Eudora ruft Mail ab.** 159 Nachrichten von `mx.freenet.de`, TLS 1.3,
> `TLS_AES_256_GCM_SHA384` (Befunde E-1 und E-3). Menüs, Anordnung und
> Werkzeugleiste stimmen. Von den vier Kriterien in [ZIEL.md](ZIEL.md) sind
> **zwei erfüllt**, eines fast, eines nicht nachgewiesen.
>
> **Der wichtigste offene Punkt** ist behoben, aber ungeprüft: auf einer
> frischen Installation stürzte Eudora ab, sobald man *Weiter* im
> Kontoassistenten klickte. Ursache war nicht der Assistent, sondern
> `ReleaseBuffer` ohne `GetBuffer` in `eudora.cpp:3372` — eine VC6-Altlast,
> die bei MFC 14 den referenzgezählten `CStringT` zerstört. Gefunden über
> Gregors `eudora.log`, behoben mit `Truncate`. **Befund E-11.**
>
> Auf der VM fiel das nie auf, weil der Zweig nur bei einer
> **jungfräulichen** Installation betreten wird.

Der Absatz oben war die Übergabe vom **31.08.2026, vormittags**; damals war der
Arbeitsstand der Branch `darstellung-und-menue`. Er ist inzwischen über
Pull Request #3 in `main` gelandet; der heutige Arbeitsstand steht im Kasten
ganz oben.

**Die damals bekannte Lücke ist geschlossen:** der Agent FREIGABE (Release-Bau)
lief noch, als diese Datei geschrieben wurde. Sein Ergebnis steht jetzt in
`BEFUNDE.md` als Befund **F-1** — der Release-Zweig scheiterte an `OTA50D.LIB`
statt `OTA50R.LIB` in `Eudora.vcxproj:147` und an `MakeDox.pl` im
Nachbereitungsschritt; er bindet, und statisch binden ist ausgeschlossen (sechs
MFC-Erweiterungs-DLLs).

Diese Datei ist der Einstieg für die nächste Sitzung. Die Zahlen der Abschnitte
vom 30. und 31.08. vormittags sind an `371c1e3` bzw. `a807b93` gemessen. An
diesem Baum arbeiten mehrere Agenten in eigenen Worktrees; wer eine Zahl
weiterverwendet, misst nach und nennt seinen eigenen Bezugscommit.

---

## Das Wichtigste zuerst

**Der Stand der Kriterien steht in [ZIEL.md](ZIEL.md).** Dort und nur dort —
hier stand bis zum 31.08.2026 abends eine zweite Tabelle, die dem Kasten am
Anfang dieser Datei widersprach (sie war der Stand vom Vormittag und sagte
„KEIN Kriterium erfüllt", während oben zwei erfüllte standen). Wer den Stand
wissen will, liest `ZIEL.md`; wer ihn ändert, ändert ihn dort.

Kurz: **zwei von vier Kriterien belegt** (Start und Bedienbarkeit E-1,
Mailabruf E-1/E-3), Kriterium 2 fast (HTML-Umlaute an der Ursache behoben,
Z-2, ungeprüft), Kriterium 0 offen — das Release-Paket ist auf keinem Rechner
ohne Visual Studio gestartet worden (E-8).

Der Dateiname `Eudora72-1.0.2-lauffaehig.zip` behauptet mehr, als die Fassung
kann. Er bleibt stehen, weil das Paket unter diesem Namen samt Prüfsumme
veröffentlicht ist; künftige Pakete heißen nach ihrem tatsächlichen Stand.
Paket 1.0.3 ist vorbereitet und **nicht veröffentlicht** — vorgeschlagener
Name `Eudora72-1.0.3-vorabfassung.zip`, siehe [Releases/PAKETE.md](Releases/PAKETE.md).

---

## Was am 30.08. passiert ist

### Behoben

**S-1 — Paket 1.0.1 startete nicht.** Drei Ursachen: die sieben vorgebauten
Fremd-DLLs von 2006 lagen als *Debug*-Fassungen bei (nicht verteilbare
VS2003-Debug-Laufzeit); es fehlte eine `Eudora.ini` (Abbruch in
`eudora.cpp:3542`); und die Werbefläche stürzte ab.

**S-2 — der Absturz war die Werbefläche.** `CAdWazooWnd::OnCreate`
([AdWazooWnd.cpp:108](Eudora71/Eudora/AdWazooWnd.cpp:108)) legt die Werbeansicht
mit `CRect(0,0,0,0)` an; die Textmaschine Paige bekommt eine Umbruchbreite von
null und dreht sich in einer Endlosrekursion fest. Gemessen: 1689 Stapelrahmen,
davon 1613 im Zyklus. Die Werbeleiste wurde in
[WazooBarMgr.cpp:155](Eudora71/Eudora/WazooBarMgr.cpp:155) **bedingungslos**
angelegt; sie hängt jetzt an `QCSharewareManager::IsBoxBuild()`, dazu der
Übersetzungsschalter `BUILD_BOX_OR_SITE_R_VERSION`. Damit entfallen Werbung,
Registrierung und Einführungsdialog.

**S-4 — Zusicherung im Adressbuch-Wazoo.** Eine Registerkarte kann *aktiv* sein,
ohne je *angezeigt* worden zu sein. QUALCOMM beschreibt genau das in
`WazooBar.cpp:346` und fängt es beim Aktivieren ab, an den beiden
Deaktivierungsstellen aber nicht. In der Schwesterklasse `CFiltersWazooWnd` ist
dieselbe Zusicherung bereits auskommentiert (`FiltersWazooWnd.cpp:109`).

**S-7 — die Wurzel aller CRLF-Probleme.** Gemessen am 30.08.2026: 4616 von 5563 verfolgten Dateien lagen
im Arbeitsverzeichnis als CRLF vor, während im Commit LF steht — Folge eines
Auscheckens mit `core.autocrlf=true`. Git sah nicht hinein, solange niemand die
Datei anfasste; danach sprang die *ganze* Datei als geändert heraus. Das ist
einmalig bereinigt.

> **Nach jedem frischen Klon, alle vier Schritte:**
> ```bash
> git config core.autocrlf false
> sh tools/hooks-einrichten.sh
> perl tools/zeilenenden-angleichen.pl --aendern
> git ls-files -z | xargs -0 -n 400 git add --
> ```
> Keiner davon ist wahlfrei. Ohne den Hook treten zwei Fehlerklassen lautlos
> wieder auf.

Dazu die Berichtigung: die frühere Vermutung „mit `autocrlf=true` geklont" war
**richtig** und wurde damals zu Unrecht als widerlegt abgehakt — `git config`
sagte zum Prüfzeitpunkt schon `false`, die Einstellung war inzwischen geändert
worden, die Folgen des Auscheckens blieben.

## Was am 31.08. dazugekommen ist

### Behoben

**S-8 — Paket 1.0.2 startete gar nicht: `0xc000007b`.** Die vier
VS2022-Debug-Laufzeiten (`mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll`,
`ucrtbased.dll`) fehlten im Programmverzeichnis. `Eudora.exe` ist **x86**; zwei
Fallen führen beim Nachlegen zur falschen Bitness: DLL-Sammelseiten liefern
häufig x64, und der 32-Bit-Systemordner heißt ausgerechnet `SysWOW64`. Werkzeug
dagegen: `tools/laufzeit-holen.ps1`, prüft jede Datei einzeln auf x86 nach.
**Nicht gelöst:** diese vier DLLs dürfen nicht weiterverteilt werden — daraus
ist Kriterium 0 entstanden.

**M-1 — die Menüs. Ursache belegt und behoben.** `SECToolBarManager` setzte
`m_bMainFrameEnabled` im Konstruktor auf `TRUE`
([OTShim_Werkzeugleiste.cpp:3480](Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:3480)
und `:3506`). `CMainFrame::OnNcHitTest`
([mainfrm.cpp:8662](Eudora71/Eudora/mainfrm.cpp:8662)) liefert bei
`IsMainFrameEnabled() == TRUE` **immer `HTERROR`** — damit war die *gesamte*
Nichtklientenfläche tot: Menüleiste, Titelzeile, Fensterknöpfe, Rahmenkanten.
Die Stingray-Kopfdatei (`tbarmgr.h:79-80`) beschreibt `TRUE` als „Hauptfenster
freigegeben" und hat den Autor der Ersatzschicht in die Irre geführt; Eudora
liest den Wert an allen fünf Stellen andersherum. Belege in
[BEFUND-MENUE.md](Eudora71/OTShim/BEFUND-MENUE.md).

> **UNGEPRÜFT am laufenden Programm.** Offener Widerspruch: M-1 ist vom
> INI-Zustand unabhängig, Gregor sagt aber, die Menüs hätten *zwischendurch*
> funktioniert. Verdacht (UNGEPRÜFT): der funktionierende Bau lag vor
> `91716bb`, dem Commit, der `= TRUE` eingeführt hat. Die vier Fragen, die das
> ohne Debugger entscheiden, stehen in `BEFUND-MENUE.md`, Abschnitt 3.

**A-1 — das Erscheinungsbild. Fünf Punkte umgesetzt.** Die leeren
Werkzeugleisten-Knöpfe: `SECStdBtn::DrawDisabled` ließ vor dem `BitBlt` die
Hintergrundfarbe auf `clrBtnFace` und die Textfarbe unverändert stehen — das
Muster wurde damit unsichtbar. Auf einer frisch gestarteten Eudora sind acht
der fünfzehn Knöpfe gesperrt, was zu „mehrere leer, andere da" passt. Die
Andockrechnung war **doppelt verriegelt**: `SECDockBar` reichte
`OnSizeParent`/`CalcFixedLayout` unverändert an MFC durch (jede Wazoo-Leiste
bekam 32767 als Wunschbreite), *und* `DockControlBarEx` verwarf zusätzlich
`nCol` und `nRow`. Beides ist behoben, `m_fPctWidth` wird jetzt ausgewertet.
Offen bleiben die Splitter und `FloatControlBarInMDIChild`.

> **UNGEPRÜFT am laufenden Programm.** Woran Gregor auf einem Bildschirmfoto
> sähe, dass es geklappt hat, steht in
> [BEFUND-ANSICHT.md](Eudora71/OTShim/BEFUND-ANSICHT.md), letzter Abschnitt.

**P-2 — der Abrufpfad ist abgesichert.** Vier Nullzeiger im Abrufpfad behoben,
darunter der **Funktionszeiger `fnConnInfo`**: schlug das Laden fehl, war die
Fehlermeldung leer. Gefunden mit `tools/suche-zeiger.pl`. Drei neue Tests, 105
grün (vorher 102). Kriterium 3 ist damit *vorbereitet*, nicht erfüllt.

**B-2 — die Brücke hängt in der Solution.** `VC71Bruecke` ist in
`Eudora71/Eudora.sln` eingetragen, mit der **echten** GUID — die in B-1 und in
`VC71Bruecke/BEFUND.md` Abschnitt 6 genannte war falsch, das Projekt wäre
stillschweigend nicht gebaut worden. Paket 1.0.3 ist vorbereitet und
**nicht veröffentlicht**. Neu: `tools/paket-pruefen.ps1`, `tools/paket-bauen.ps1`.
**Berichtigung:** Paket 1.0.2 ist **gemischt** (Release-Fremdmodule,
Debug-`Eudora.exe`), nicht durchgehend Release — die frühere Angabe war falsch.

**W-1 — die Werkzeuge in Ordnung gebracht.** PR-1 bis PR-4 und PR-6 bis PR-8
behoben. Die Schranke `tools/pruefe-bytes.pl` hat jetzt eine Testsammlung
(`tools/pruefe-bytes-tests.pl`, inzwischen 35 Fälle, alle grün);
`tools/rekursion-suchen.pl` ist gelöscht. Es gilt: **4616 von 5563** vom
30.08.2026; die Grundgesamtheit wächst und lag am 31.08. bei 5589. Offen bleibt
PR-5, die Beschreibung des Zeitstempels.

**Produktversion 7.2.0.3** statt 7.1.0.9, sichtbar im Splash und unter
*Hilfe → Über Eudora*. Es gibt **drei getrennte Zählungen** — Produkt
`7.2.0.x`, Paket `1.0.x`, QCSSL `1.0.x`. Tabelle in
[Releases/PAKETE.md](Releases/PAKETE.md).

**ZIEL.md hat ein Kriterium 0 bekommen:** das Paket muss ohne Nachinstallieren
laufen. „zip runterladen, entpacken, starten - läuft."

### Offen

**Kriterium 0** ist der offene Punkt. Der Release-Bau ist seit Befund F-1 da
(es war `OTA50D.LIB` statt `OTA50R.LIB` in `Eudora.vcxproj:147`, dazu
`MakeDox.pl` im Nachbereitungsschritt), aber **niemand hat das Release-Paket
auf einem Rechner ohne Visual Studio gestartet** — der Win11-Lauf war der
Debug-Bau mit beigelegten, nicht verteilbaren DLLs (E-8). Statisch binden ist
ausgeschlossen (F-1.1).

**Kriterium 3 ist erledigt** (E-1, E-3): 159 Nachrichten von `mx.freenet.de`,
Port 110 mit STARTTLS, `TLSv1.3`. Damit ist auch die in `ABRUF-PRUEFEN.md` als
UNGEPRÜFT markierte Frage beantwortet — ja, `mx.freenet.de` spricht POP3.

**Kriterium 2** hängt an den HTML-Umlauten: Ursache belegt und behoben (Z-2 —
der Zeichensatz wurde der temporären Datei nirgends angesagt), Wirkung
ungeprüft.

Der vollständige Prüfbericht vom 30.08. abends steht in
[PRUEFBERICHT.md](PRUEFBERICHT.md); was davon behoben ist, sagt Befund W-1.

## Werkzeuge

Die vollständige Liste steht in [README.md](README.md), Abschnitt „Werkzeuge".
Neu am 31.08.2026:

| Werkzeug | wozu |
|---|---|
| `tools/laufzeit-holen.ps1` | holt die vier Debug-Laufzeiten aus `SysWOW64` und prüft jede einzeln auf x86 nach. Befund S-8. |
| `tools/paket-pruefen.ps1` | prüft ein ausgepacktes Paket, **bevor** es jemand startet. **Taugt nicht als Freigabekriterium** — es prüft die Maschine statt das Paket und warnt bei einem Release-Paket viermal falsch (PR-2.0 bis PR-2.3). |
| `tools/paket-bauen.ps1` | stellt ein Paket aus dem Quellbaum zusammen. Veröffentlicht nichts. Braucht `-AusBauverzeichnis`, wenn ein frischer Bau übernommen werden soll. |
| `tools/suche-zeiger.pl` | findet Zeiger, die geprüft und danach außerhalb des Blocks dereferenziert werden. Damit wurde P-2 gefunden — aber **345 Treffer, Stichprobe 15 von 15 Fehlalarm** (X-1). Ohne die drei Filter aus D3 nicht benutzbar. |
| `tools/pruefe-bytes-tests.pl` | Testfälle für die Schranke. **Wer `pruefe-bytes.pl` anfasst, lässt sie laufen.** |
| `tools/releasebuffer-pruefen.pl` | stuft die 142 `ReleaseBuffer`-Vorkommen ein — die Fehlerklasse hinter E-11. 25 sind zu ändern, Einzelheiten in Befund R-1. |
| `tools/dateiendungen.pl` | gemeinsame Liste der Dateiarten, die als Text gelten. |

`tools/rekursion-suchen.pl` ist am 31.08.2026 gelöscht worden — Befund W-1: es
bildete jede Kante mit der umgebenden Klasse und konnte klassenübergreifende
Zyklen strukturell nicht finden, auch den aus S-2 nicht, für den es gebaut war.

`tools/pruefe-bytes.pl` wurde zweimal berichtigt: die erste Fassung verglich die
bloße CR-Anzahl und schlug schon beim *Hinzufügen* von Zeilen an, die zweite
verglich Zeileninhalte und schlug bei Leerzeilen grundlos an. Seit dem
31.08.2026 wertet Regel 2 den eigentlichen Unterschied aus
(`git diff --cached -U0`) und paart entfernte mit hinzugefügten Zeilen innerhalb
eines Blocks — Umwandlungen fallen in beide Richtungen auf, Ergänzungen und
Löschungen laufen durch. **Die alte CR-Anzahl-Regel steht in mehreren älteren
Texten noch; wer sie liest, glaubt das Falsche.**

---

## Bau-Kennung in der Titelleiste

Der Fenstertitel trägt jetzt Paketversion, Commit und Herkunftsverzeichnis:

```
Eudora - [In]   [1.0.3+371c1e3 - Eudora72-1.0.3]
```

Ein **Sternchen** hinter dem Commit heißt: beim Bau lagen ungesicherte
Änderungen vor, der Bau ist nicht reproduzierbar. Die Version steht in der
Datei `VERSION`.

Anlass: Gregor konnte eine Beobachtung („die Menüs funktionierten
zwischendurch") keinem Bau zuordnen — die EXE trug keine Kennung. Derselbe
Fehler war zwei Tage zuvor schon bei der `QCSSL.dll` passiert.

---

## Wie man Eudora startet

**Zuerst die Debug-Laufzeiten dazulegen** — ohne sie bricht der Start mit
`0xc000007b` ab, noch bevor ein Fenster erscheint (Befund S-8):

```powershell
powershell -ExecutionPolicy Bypass -File tools\laufzeit-holen.ps1 -Ziel "C:\Pfad\zu\Eudora"
```

Dann:

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Das Mailverzeichnis **muss eine `Eudora.ini` enthalten**, sonst bricht Eudora in
`eudora.cpp:3542` ab. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`.

Beim ersten Start erscheinen drei bis vier Dialoge „SUPERASSERT Assertion
Failure" — auf *Ignore Once* klicken. Das sind Debug-Zusicherungen, keine
Fehler; sie erscheinen nur im **Debug**-Bau. Im Release-Bau (seit F-1
lauffähig) entfallen sie samt allen `ASSERT`/`VERIFY`.

**Wichtig:** Gregor testet auf derselben Windows-Sitzung. Kein Programm mit
Fenstern ohne Absprache starten — auch nicht durch Agenten. Beim Aufräumen von
Prozessen **immer nach Pfad filtern**, sonst schießt man seine laufende Sitzung
mit ab.

---

## Konto einrichten ohne Menü

Solange nicht am laufenden Programm bestätigt ist, dass die Menüs mit der
Behebung aus M-1 wieder aufgehen, geht es nur über die `Eudora.ini` im
Mailverzeichnis, Abschnitt `[Settings]`:

```ini
POPAccount=benutzername@pop.anbieter.de
LoginName=benutzername
RealName=Name
ReturnAddress=adresse@anbieter.de
SMTPServer=smtp.anbieter.de
SmtpAuthAllowed=1
SSLReceiveUse=2
SSLPOPAlternatePort=995
SSLSendUse=2
SSLSMTPAlternatePort=465
```

`SSLReceiveUse`/`SSLSendUse` sind der Index der Auswahlliste aus
[settings.cpp:1978](Eudora71/Eudora/settings.cpp:1978): 0 nie, 1 falls verfügbar
(STARTTLS), 2 erforderlich mit eigenem Port, 3 erforderlich (STARTTLS).

Das Passwort landet als `SavePasswordText` **Base64-kodiert, nicht
verschlüsselt** in derselben Datei ([password.cpp:544](Eudora71/Eudora/password.cpp:544)).

---

## Was die Agenten bearbeitet haben

Alle haben in eigenen Worktrees gearbeitet. Die Ergebnisse vom 30.08. abends
und vom 31.08. früh sind **zusammengeführt** und stehen im Baum; ihre
Abschnitte stehen am Ende von `BEFUNDE.md`.

| Agent | Auftrag | Ablage | Stand |
|---|---|---|---|
| BRÜCKE | eigene `msvcr71.dll` als Weiterleitung auf `msvcrt.dll` | `Eudora71/VC71Bruecke/BEFUND.md`, `BEFUNDE.md` `## B-1`, `## B-2` | zusammengeführt; Projekt hängt in der Solution, Paket 1.0.3 vorbereitet |
| MENUE | Befund S-5, warum sich Menüs nicht öffnen lassen | `Eudora71/OTShim/BEFUND-MENUE.md`, `BEFUNDE.md` `## M-1` | zusammengeführt; Ursache behoben, am Programm nicht nachgesehen |
| ANSICHT | Befund S-6, das Erscheinungsbild | `Eudora71/OTShim/BEFUND-ANSICHT.md`, `BEFUNDE.md` `## A-1` | zusammengeführt; fünf Punkte umgesetzt, am Programm nicht nachgesehen |
| POSTBOTE | Kriterium 3 vorbereiten | `ABRUF-PRUEFEN.md`, `BEFUNDE.md` `## P-1`, `## P-2` | zusammengeführt; vier Nullzeiger behoben, Tests 105 grün |
| WERKZEUG | Befunde PR-1 bis PR-8 abarbeiten | `BEFUNDE.md` `## W-1` | zusammengeführt; PR-5 bleibt offen |
| PRÜFER | Richtigkeit der Werkzeuge, Codeänderungen und Zahlen | `PRUEFBERICHT.md` `## PR-1` | abgeschlossen (30.08. abends) |
| LEKTOR | Aktualität aller MD-Dateien | `LEKTORAT.md` | zweiter Durchgang 31.08. |
| FREIGABE | Release-Bau | — | **lief beim Schreiben dieser Datei noch.** Sein Ergebnis fehlt hier zwangsläufig; zuerst seinen Branch und seinen Abschnitt in `BEFUNDE.md` ansehen |

**Zuerst diese Dateien lesen** — dort steht, wie weit jeder gekommen ist und was
der nächste Schritt wäre.

---

## Was ohne Visual Studio geht — und was nicht

Diese Frage kam am 31.08.2026 abends auf, als eine Sitzung ohne VM lief.
Nachgemessen in einer Linux-Umgebung mit perl 5.38, git 2.43, python 3.11:

**Geht vollständig, mit Nachweis:**

| Arbeit | warum sie hier abschließbar ist |
|---|---|
| Die Werkzeuge unter `tools/` | perl und git reichen. `tools/pruefe-bytes-tests.pl` läuft (35 Fälle) und beweist jede Änderung an der Schranke — rot vorher, grün nachher. |
| Quelltextanalyse über den ganzen Baum | `tools/releasebuffer-pruefen.pl` ist so entstanden. Fundstellen, Einstufungen, Funktionsgrenzen: alles Text. |
| Der Paketprüfer (`paket-pruefen.ps1`, PR-2.0) | im Klon liegen **101 PE-Dateien**, darunter `Bin/Release`. Ein Import-Leser lässt sich also gegen echte x86-Binärdateien entwickeln und messen. Nur die `.ps1` selbst läuft ohne PowerShell nicht. |
| Doku und Nachrechnen | grep-Arbeit. Befund Z-1 hat gezeigt, dass 11 von rund 40 geprüften Angaben falsch waren — das ist keine Fleißarbeit. |

**Braucht zwingend Windows mit Visual Studio 2022:**

jeder Bau, jeder Start, jedes Bildschirmfoto, die 105 Komponententests
(MFC/MBCS über MSBuild), `stapel-untersuchen.ps1` (32-Bit-PowerShell) und
`laufzeit-holen.ps1` — und damit der erste Punkt der Arbeitsliste.

**Die Grenze, die dabei einzuhalten ist:** eine C++-Änderung, die hier
entsteht, ist **ungeprüft**, weil sie nicht übersetzt. In genau dieser Lücke hat
sich das Projekt am 31.08. dreimal geirrt (E-2, E-5, E-8). Deshalb: C++ nur mit
ausdrücklichem UNGEPRÜFT-Vermerk in Commit und Befund — und die Werkzeug- und
Doku-Arbeit zuerst, weil sie hier vollständig nachweisbar ist.

## Nächste Schritte, nach Wichtigkeit

**Die vollständige Arbeitsliste steht in [AUFGABEN.md](AUFGABEN.md)**; hier nur
die Reihenfolge.

1. **Das v1.0.3-Release auf dem zweiten PC auspacken und starten**, im
   Assistenten auf *Weiter* klicken. Ein Lauf beantwortet fünf offene Punkte:
   E-11 (Absturz behoben?), Kriterium 0, die HTML-Umlaute (Z-2), die fehlende
   Bau-Kennung im Titel (E-7) und den Index-Fehler beim Beenden (E-4). Achtung
   auf die Prüfsumme: das ZIP ist am 31.08. um 09:00 ausgetauscht worden, nur
   `d4719047…` enthält die E-11-Behebung.
2. **`paket-pruefen.ps1` brauchbar machen** (PR-2.0 bis PR-2.3) — die nötigen
   Laufzeiten aus den **Importen** der Paketdateien ableiten statt aus einer
   festen Liste, und „vorhanden" nur gelten lassen, wenn die Datei im Paket
   liegt. Solange das offen ist, ist Kriterium 0 nicht nachweisbar.
3. **`ReleaseBuffer` ohne `GetBuffer` beheben** — die Fehlerklasse hinter E-11
   ist **ausgezählt** (Befund R-1): von 142 Vorkommen sind 117 richtig und **25
   zu ändern**, `perl tools/releasebuffer-pruefen.pl` nennt sie einzeln. Zuerst
   `eudora.cpp:3403` und `:3413` (dieselbe Funktion wie der E-11-Absturz), dann
   `QCSharewareManager.cpp:1318` (jeder Start), dann die vier in `sendmail.cpp`
   (jede gesendete Klartextmail). Das Ändern selbst braucht einen Bau.
4. **Erscheinungsbild, zweite Runde.** Nach dem Bildschirmfoto: die Splitter
   (`SECDockBar::AddSplitter` wird nie gerufen) und
   `SECMDIFrameWnd::FloatControlBarInMDIChild`. Reihenfolge und Ansatz in
   `BEFUND-ANSICHT.md`.
5. **Paket 1.0.3 veröffentlichen** — vorbereitet, aber bewusst NICHT
   veröffentlicht. Vorgeschlagener Name `Eudora72-1.0.3-vorabfassung.zip`.
   Einzelheiten und Bauweg in [Releases/PAKETE.md](Releases/PAKETE.md).
6. **PR-5** — der Zeitstempel in der Bau-Kennung ist der Zeitpunkt der letzten
   Commit- oder Sauberkeitsänderung, nicht der Bauzeitpunkt. Das Verhalten ist
   richtig, nur die Beschreibung stimmt nicht. Ein Wort im Kommentar.

---

## Zurückgestellt — nicht von selbst aufgreifen

`tools/patches/zertifikatspruefung-verschaerfen.patch` (Hostnamensprüfung und
Umgang mit `X509_V_ERR_CERT_UNTRUSTED` in QCSSL) ist vorbereitet, aber **nicht
angewendet**. Gregor hat entschieden, das später anzugehen. Nicht ohne sein
Wort anwenden.

---

## Fallen im Arbeitsverzeichnis

- **Quelldateien sind Latin-1 mit gemischten Zeilenenden.** Nur byte-erhaltend
  ändern: `tools/aendere-zeile.pl`, `tools/ersetze-bereich.pl`. Niemals `sed`
  ohne `-b`, nicht das Edit-Werkzeug auf bestehende Quellen.
- **`grep -c $'\r'` misst Zeilenenden NICHT zuverlässig** — es zählt in Git Bash
  schlicht alle Zeilen. Immer mit Perl und `:raw` messen.
- **Einzelprojekt-Bauten brauchen `/p:BuildProjectReferences=false`**, sonst
  scheitern sie am Projekt `OT501`.
- **`$(SolutionDir)` zeigt beim Einzelprojekt-Bau auf das Projektverzeichnis**,
  nicht auf die Solution. `$(ProjectDir)..\..` benutzen.
- **`perl` ist im MSBuild-Pfad nicht vorhanden.** Es liegt unter
  `C:\Program Files\Git\usr\bin\perl.exe`.
- **`&` muss in `.vcxproj` als `&amp;` geschrieben werden** — sonst lädt MSBuild
  die Projektdatei nicht mehr.
- **Es kann systemweit nur einen OutputDebugString-Mithörer geben**
  (`DBWIN_BUFFER`). Zwei gleichzeitig, und beide bekommen nichts.
- **Include-Wächter sind alles-oder-nichts.** Wer nur einen Teil eines
  Stingray-Headers ersetzt, darf den Wächter nicht setzen. Steht ausführlich in
  `Eudora71/OTShim/PLAN.md`.
