# Hier weitermachen

Übergabe vom **30.08.2026, abends**. Arbeitsbranch `eudora-exe-linkt`.

Diese Datei ist der Einstieg für die nächste Sitzung. Alle Zahlen sind an
`371c1e3` gemessen. An diesem Baum arbeiten mehrere Agenten in eigenen
Worktrees; wer eine Zahl weiterverwendet, misst nach und nennt seinen eigenen
Bezugscommit.

---

## Das Wichtigste zuerst

**Eudora startet und laeuft bis in die Fenstererzeugung, ohne abzustuerzen.**
Zum ersten Mal seit Beginn der Portierung. Das Fenster ist aber NICHT
bedienbar - Menues tot (S-5), Bereiche ueberlagert, Knoepfe leer (S-6). Ein
Meilenstein, kein erfuelltes Kriterium; siehe ZIEL.md. Veröffentlicht als `v1.0.2`.

**Aber es ist noch nicht „lauffähig".** Gregor hat am 30.08. festgelegt, was das
heißt — siehe [ZIEL.md](ZIEL.md). Drei Kriterien:

| # | Kriterium | Stand |
|---|---|---|
| 1 | startet und zeigt sein Hauptfenster | **strittig** — das Fenster erscheint, ist aber nicht bedienbar |
| 2 | die Darstellung ist korrekt | **nicht erfüllt** |
| 3 | Mailkonto verbinden und Mail abrufen | **nicht geprüft** |

Der Dateiname `Eudora72-1.0.2-lauffaehig.zip` behauptet mehr, als die Fassung
kann. Das ist zu korrigieren.

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

### Offen

**S-5 — Menüs lassen sich nicht öffnen. URSACHE GEFUNDEN (M-1), Behebung
ungeprüft.**

`SECToolBarManager` setzte `m_bMainFrameEnabled` im Konstruktor auf `TRUE`
([OTShim_Werkzeugleiste.cpp:3480](Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:3480)
und `:3506`). `CMainFrame::OnNcHitTest`
([mainfrm.cpp:8662](Eudora71/Eudora/mainfrm.cpp:8662)) liefert bei
`IsMainFrameEnabled() == TRUE` **immer `HTERROR`** — damit ist die *gesamte*
Nichtklientenfläche tot: Menüleiste, Titelzeile, Fensterknöpfe, Rahmenkanten.
Ein Klick auf „File" erreicht nie `WM_NCLBUTTONDOWN`/`HTMENU`.

Die Stingray-Kopfdatei (`tbarmgr.h:79-80`) beschreibt `TRUE` als „Hauptfenster
freigegeben" und hat den Autor der Ersatzschicht in die Irre geführt. Eudora
liest den Wert an allen fünf Abfragestellen andersherum: `TRUE` heißt dort
„Anpassen-Dialog steht offen" (`mainfrm.cpp:2990` und `:8744`).

> ### Vier Fragen an Gregor, die das ohne Debugger entscheiden
>
> Waren im kaputten Bau **auch** diese drei tot?
>
> 1. das Verschieben am **Titelbalken**
> 2. das Ziehen an den **Rahmenkanten**
> 3. die **Fensterknöpfe** (Minimieren/Maximieren/Schließen)
> 4. und ging **`Alt+F`** trotzdem? *(die Tastatur läuft über `SC_KEYMENU`,
>    nicht über den Hit-Test — sie müsste funktioniert haben)*
>
> Passt das Bild, ist M-1 bestätigt. Ging der Titelbalken normal, ist M-1 zwar
> ein echter Fehler, aber **nicht** die Ursache von S-5.

Offener Widerspruch: M-1 ist vom INI-Zustand unabhängig, Gregor sagt aber, die
Menüs hätten *zwischendurch* funktioniert. Verdacht (UNGEPRÜFT): der
funktionierende Bau lag vor `91716bb`, dem Commit, der `= TRUE` eingeführt hat.

Ausgeschlossen, mit Belegen in
[BEFUND-MENUE.md](Eudora71/OTShim/BEFUND-MENUE.md): `SECDockState::LoadState`
bei leerer INI (regulärer Erstlauf-Weg), MDI-Menüverschmelzung, Fokusdiebe,
Zeitgeber- und Leerlaufpfade, kein `SetMenu` in der Anwendung.

**S-6 — die Darstellung ist fehlerhaft. Ursache von Punkt 2 belegt (A-1).**

Die Ersatzschicht setzt die prozentualen Zeilenbreiten `m_fPctWidth` und die
Splitter der Andockleiste **gar nicht um** und reicht `SECDockBar::OnSizeParent`
und `CalcFixedLayout` unverändert an MFC durch. `SECControlBar::CalcFixedLayout`
gibt dabei jeder Wazoo-Leiste **32767** als Wunschbreite. `DockControlBarEx`
verwirft zusätzlich `nCol` und `nRow`. Das erklärt die überlagernden Bereiche
und den Registerkartenstreifen mitten im Fenster.

Bei den **leeren Werkzeugleisten-Knöpfen** sind fünf Ursachen ausgemessen und
ausgeschlossen; alle 15 Standardknöpfe liegen im ersten Bitmap, die Bildzahlen
64/61/51 stimmen. Übrig bleibt der Zeichenweg je Knopf. Stärkster Verdacht
(UNGEPRÜFT): das fehlende `SetTextColor(0)`/`SetBkColor(0xFFFFFF)` in
`SECStdBtn::DrawDisabled`
([OTShim_Werkzeugleiste.cpp:786](Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:786)).
Das passt als einziges auf „mehrere leer, andere da" — auf einer frisch
gestarteten Eudora sind acht der fünfzehn Knöpfe gesperrt.

Fünf konkrete Folgeschritte in
[BEFUND-ANSICHT.md](Eudora71/OTShim/BEFUND-ANSICHT.md).

**Kriterium 3 — Mail abrufen. Wahrscheinlichster Absturzpunkt bekannt (P-1).**

`QCWorkerSocket.cpp:1969` dereferenziert `pConnectionInfo` **ungeprüft**,
nachdem Zeile 1961 es gerade geprüft hat. Scheitert die SSL-Aushandlung und
`QCSSLGetConnectionInfo` liefert `NULL`, stürzt Eudora ab, statt eine Meldung zu
zeigen. Ein Zweizeiler — das wäre der erste Handgriff.

Der POP-Pfad selbst ist gegengelesen und von der Portierung unbeschädigt;
Betreff, Absendername und Text laufen über denselben, korrekt indizierten
Zeichensatzpfad. Der bekannte IMAP-Fehler trifft POP **nicht**. Anleitung zum
Ausprobieren: [ABRUF-PRUEFEN.md](ABRUF-PRUEFEN.md). Dort als UNGEPRÜFT
markiert: ob `mx.freenet.de` überhaupt der POP3-Server ist.

**PR-1 — drei Fehler in der Arbeit vom 30.08. selbst.**

PRÜFER hat sie mit Gegenproben belegt:

1. `tools/pruefe-bytes.pl` lässt **LF→CRLF lautlos durch** — Regel 2 sucht nur
   die Gegenrichtung. Unter Windows ist CRLF die wahrscheinlichere
   Schadensrichtung; der Wächter deckt also den unwahrscheinlicheren Fall ab.
2. Dieselbe Schranke **schlägt bei Leerzeilen grundlos an**: eine CRLF-Leerzeile
   gelöscht, eine LF-Leerzeile ergänzt — kein Byte umgewandelt, trotzdem
   Abbruch. Derselbe Fehlalarm-Fehler wie zuvor, nur von der CR-Anzahl auf den
   Zeileninhalt umgezogen.
3. `BuildKennung.h` ist in git **verfolgt**. Fällt perl beim Bau aus, zeigt das
   Fenster die Kennung eines *fremden* Baus statt gar keiner — genau der Fehler,
   den die Kennung verhindern sollte.

Weiter: `.def`/`.sln`/`.bat`/`.ps1` prüft die Schranke gar nicht;
`_T(EUDORA_BAU_KENNUNG)` ([mainfrm.cpp:9715](Eudora71/Eudora/mainfrm.cpp:9715))
übersetzt in einem Unicode-Bau nicht; die Zahlen in S-7 widersprechen sich
(4616/5563 gegen 4426/5336 im Werkzeugkopf, nachgemessen 5568). PRÜFERs Urteil
zu `tools/rekursion-suchen.pl`: **löschen** — es bildet jede Kante mit der
umgebenden Klasse und kann klassenübergreifende Zyklen strukturell nicht finden,
auch den aus S-2 nicht.

Vollständig in [PRUEFBERICHT.md](PRUEFBERICHT.md).

> **Stand 31.08.2026 (WERKZEUG, Befund W-1).** Behoben sind PR-1, PR-2, PR-3
> (Schranke, neu mit `tools/pruefe-bytes-tests.pl` — 23 Fälle, alle grün),
> PR-7 (Zahlen: es gilt 4616 von 5563 vom 30.08.2026; die Grundgesamtheit
> wächst und ist am 31.08. bei 5589), PR-8 (`rekursion-suchen.pl` gelöscht)
> sowie PR-4 und PR-6. Offen bleibt PR-5, die Beschreibung des Zeitstempels.

**B-1 — die VC7.1-Laufzeiten.** Die eigene `msvcr71.dll` steht: 1430 Exporte,
davon 1429 echte Weiterleitungen auf die von Windows mitgelieferte
`msvcrt.dll`, einzige Abhängigkeit `KERNEL32.dll`. Damit können die drei
unsignierten Dateien von dll-files.com aus dem Paket. Ebenfalls belegt: die
Release-`Paige32.dll` darf als `Paige32d.dll` dienen, also sind `msvcr71d.dll`
und `msvcp71d.dll` totes Gewicht. **`MFC71.DLL` ist aussichtslos** — sie wird
über **157 Ordinale** importiert.

UNFERTIG: `VC71Bruecke` hängt noch nicht in `Eudora71/Eudora.sln`. Die zwei
nötigen Einfügungen stehen wörtlich in
[Eudora71/VC71Bruecke/BEFUND.md](Eudora71/VC71Bruecke/BEFUND.md), Abschnitt 6.

## Neue Werkzeuge

| Werkzeug | wozu |
|---|---|
| `tools/zeilenenden-angleichen.pl` | Arbeitskopie byteidentisch zum Commit machen. Siehe S-7. Nach jedem Klon einmal. |
| `tools/stapel-untersuchen.ps1` | Kleiner Debugger: startet ein Programm als Debuggee, fängt die tödliche Ausnahme, läuft die EBP-Kette ab, symbolisiert mit `dbghelp`. **Muss in der 32-Bit-PowerShell laufen.** Braucht die `.pdb` neben der `.exe`. Damit wurde S-2 gefunden. |
| `tools/kennung-erzeugen.pl` | Erzeugt `BuildKennung.h` vor jedem Bau. Läuft als PreBuildEvent. |
| `tools/pruefe-bytes-tests.pl` | Testsammlung für die Schranke, 23 Fälle. **Wer `pruefe-bytes.pl` anfasst, lässt sie laufen.** |
| `tools/dateiendungen.pl` | gemeinsame Liste der Dateiarten, die als Text gelten. |

`tools/rekursion-suchen.pl` ist am 31.08.2026 gelöscht worden — Befund W-1.

`tools/pruefe-bytes.pl` wurde berichtigt: es verglich die bloße CR-Anzahl und
schlug damit schon beim *Hinzufügen* von Zeilen an. Der Nachfolger verglich
Zeileninhalte und schlug bei Leerzeilen grundlos an. Seit dem 31.08.2026 wertet
Regel 2 den eigentlichen Unterschied aus (`git diff --cached -U0`) und paart
entfernte mit hinzugefügten Zeilen innerhalb eines Blocks — Umwandlungen fallen
in beide Richtungen auf, Ergänzungen und Löschungen laufen durch.

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

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Das Mailverzeichnis **muss eine `Eudora.ini` enthalten**, sonst bricht Eudora in
`eudora.cpp:3542` ab. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`.

Beim ersten Start erscheinen drei bis vier Dialoge „SUPERASSERT Assertion
Failure" — auf *Ignore Once* klicken. Das sind Debug-Zusicherungen, keine
Fehler; sie erscheinen nur, weil bisher nur der Debug-Bau läuft (der
Release-Zweig scheitert an einer fehlenden `Imap.lib`).

**Wichtig:** Gregor testet auf derselben Windows-Sitzung. Kein Programm mit
Fenstern ohne Absprache starten — auch nicht durch Agenten. Beim Aufräumen von
Prozessen **immer nach Pfad filtern**, sonst schießt man seine laufende Sitzung
mit ab.

---

## Konto einrichten ohne Menü

Solange S-5 offen ist, geht es nur über die `Eudora.ini` im Mailverzeichnis,
Abschnitt `[Settings]`:

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

## Was die Agenten am 30.08. abends bearbeitet haben

Alle fünf haben in eigenen Worktrees gearbeitet und beim Abschalten gesichert.
Ihre Branches heißen `worktree-agent-*`; ihre Ergebnisse stehen in eigenen
Dateien und in eigenen Abschnitten am Ende von `BEFUNDE.md`.

| Agent | Auftrag | Ablage |
|---|---|---|
| BRÜCKE | eigene `msvcr71.dll` als Weiterleitung auf die von Windows mitgelieferte `msvcrt.dll`, damit die drei Fremd-DLLs von dll-files.com aus dem Paket verschwinden | `Eudora71/VC71Bruecke/BEFUND.md`, Abschnitt `## B-1` |
| MENUE | Befund S-5, warum sich Menüs nicht öffnen lassen | `Eudora71/OTShim/BEFUND-MENUE.md`, Abschnitt `## M-1` |
| ANSICHT | Befund S-6, das Erscheinungsbild | `Eudora71/OTShim/BEFUND-ANSICHT.md`, Abschnitt `## A-1` |
| POSTBOTE | Kriterium 3 vorbereiten: Abrufpfad gegenlesen, Prüfanleitung schreiben | `ABRUF-PRUEFEN.md`, Abschnitt `## P-1` |
| LEKTOR | Aktualität aller MD-Dateien | `LEKTORAT.md`, Abschnitt `## L-1` |
| PRÜFER | Richtigkeit der heutigen Werkzeuge, Codeänderungen und Zahlen | `PRUEFBERICHT.md`, Abschnitt `## PR-1` |

**Zuerst diese Dateien lesen** — dort steht, wie weit jeder gekommen ist und was
der nächste Schritt wäre.

---

## Nächste Schritte, nach Wichtigkeit

1. **Das Erscheinungsbild (S-6).** Gregors ausdrücklicher Vorrang. Vergleich ist
   sein Bildschirmfoto der Originalfassung; die Merkmale stehen in
   [ZIEL.md](ZIEL.md).
2. **Die Menüs (S-5).** Sperrbefund — ohne Menüs ist Eudora nicht einzurichten.
   Der Hinweis „hat zwischendurch funktioniert" ist die heißeste Spur.
3. **Mail abrufen (Kriterium 3).** Nie getestet. Zugleich der erste echte Test
   der neuen TLS-Schicht: die ausgelieferte QCSSL 1.0.1 ist nie gegen einen
   echten Server gelaufen, nur eine ältere Fassung war es.
4. **Paket 1.0.3** — erst danach, und mit einem Namen, der nicht mehr behauptet,
   als die Fassung kann.
5. **Release-Bau.** Scheitert an einer fehlenden `Imap.lib` im Release-Zweig.
   Ein Release-Bau hätte keine SUPERASSERT-Dialoge.

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
