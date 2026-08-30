# Hier weitermachen

Übergabe vom **30.08.2026, abends**. Arbeitsbranch `eudora-exe-linkt`.

Diese Datei ist der Einstieg für die nächste Sitzung. Alle Zahlen sind an
`371c1e3` gemessen. An diesem Baum arbeiten mehrere Agenten in eigenen
Worktrees; wer eine Zahl weiterverwendet, misst nach und nennt seinen eigenen
Bezugscommit.

---

## Das Wichtigste zuerst

**Eudora startet und zeigt sein Hauptfenster.** Zum ersten Mal seit Beginn der
Portierung. Veröffentlicht als `v1.0.2`.

**Aber es ist noch nicht „lauffähig".** Gregor hat am 30.08. festgelegt, was das
heißt — siehe [ZIEL.md](ZIEL.md). Drei Kriterien:

| # | Kriterium | Stand |
|---|---|---|
| 1 | startet und zeigt sein Hauptfenster | **erfüllt** |
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

**S-7 — die Wurzel aller CRLF-Probleme.** 4616 von 5563 verfolgten Dateien lagen
im Arbeitsverzeichnis als CRLF vor, während im Commit LF steht — Folge eines
Auscheckens mit `core.autocrlf=true`. Git sah nicht hinein, solange niemand die
Datei anfasste; danach sprang die *ganze* Datei als geändert heraus. Das ist
einmalig bereinigt.

> **Nach jedem frischen Klon einmal ausführen:**
> ```bash
> perl tools/zeilenenden-angleichen.pl --aendern && git ls-files -z | xargs -0 -n 400 git add --
> ```

Dazu die Berichtigung: die frühere Vermutung „mit `autocrlf=true` geklont" war
**richtig** und wurde damals zu Unrecht als widerlegt abgehakt — `git config`
sagte zum Prüfzeitpunkt schon `false`, die Einstellung war inzwischen geändert
worden, die Folgen des Auscheckens blieben.

### Offen

**S-5 — Menüs lassen sich nicht öffnen.** Gregor: „nichts, kleine reaktion" —
der Menütitel leuchtet auf, klappt aber nicht auf. **Wichtig: sie haben
zwischendurch funktioniert.** Es ist also zustandsabhängig, kein
grundsätzlicher Defekt. Verdacht: der frische Zustand ohne gespeicherten
Leistenzustand in der `Eudora.ini`
([mainfrm.cpp:819](Eudora71/Eudora/mainfrm.cpp:819),
`SECDockState::LoadState`).

Ausgeschlossen (gemessen): kein `SetMenu` in der Anwendung; der Werbecode im
Leerlauf läuft nicht (`GetSharewareMode()` ist `SWM_MODE_PRO`);
`CWazooBar::OnTimer` läuft nur beim Ziehen-und-Ablegen; das Menü selbst ist
vollständig (14 Einträge, alle Untermenüs gefüllt); das Fenster hängt nicht.

**S-6 — die Darstellung ist fehlerhaft.** Gregors wichtigster Punkt. Leere
Werkzeugleisten-Knöpfe, sich überlagernde Bereiche, ein Registerkartenstreifen
mitten im Fenster, die fehlende Fensterleiste unten. Ausgeschlossen: dass es am
Entfernen der Werbeleiste liegt — `QCDockBar` prüft an beiden betroffenen
Stellen selbst auf `SWM_MODE_ADWARE`.

---

## Neue Werkzeuge

| Werkzeug | wozu |
|---|---|
| `tools/zeilenenden-angleichen.pl` | Arbeitskopie byteidentisch zum Commit machen. Siehe S-7. Nach jedem Klon einmal. |
| `tools/stapel-untersuchen.ps1` | Kleiner Debugger: startet ein Programm als Debuggee, fängt die tödliche Ausnahme, läuft die EBP-Kette ab, symbolisiert mit `dbghelp`. **Muss in der 32-Bit-PowerShell laufen.** Braucht die `.pdb` neben der `.exe`. Damit wurde S-2 gefunden. |
| `tools/kennung-erzeugen.pl` | Erzeugt `BuildKennung.h` vor jedem Bau. Läuft als PreBuildEvent. |
| `tools/rekursion-suchen.pl` | Zyklensuche im Aufrufgraphen. **Grenze:** unterscheidet Überladungen nur am Namen und an der Argumentzahl, nicht an den Typen — lieferte hier ausschließlich Fehlalarme. |

`tools/pruefe-bytes.pl` wurde berichtigt: es verglich die bloße CR-Anzahl und
schlug damit schon beim *Hinzufügen* von Zeilen an. Jetzt zwei Regeln — Inhalt
gleich bei verschiedenen Bytes, und: hat eine inhaltlich unveränderte Zeile ihr
Zeilenende gewechselt?

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
