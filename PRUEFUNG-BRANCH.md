# Prüfung des Branches `claude/letzter-stand-b2ytpi`

Geprüft am **05.09.2026** auf der Windows-VM mit Visual Studio 2022 — also
genau dort, wo die geprüfte Sitzung **nicht** war. Sie lief auf einem
Linux-Rechner ohne MSBuild, MSVC und PowerShell und konnte deshalb einen Teil
ihrer eigenen Aussagen nicht nachmessen.

**Auftrag:** feststellen, ob die Befunde des Branches stimmen. **Nicht**
beheben — das geschieht nach dem Zusammenführen auf einem neuen Branch.

| | |
|---|---|
| Geprüfter Stand | `2fee8e9` |
| Vergleichsstand | `main` = `2107a85` |
| Verhältnis | reines Vorspulen, 16 Commits, kein Konflikt |
| Geändert | nur Dokumentation und Werkzeuge — **keine Zeile C++** |

---

## Kurzfassung

| Befund | Behauptung | Urteil |
|---|---|---|
| **D3a** (neun Zeigerstellen) | 9 echte Kandidaten | **trägt nicht** — nur 4 halten stand |
| **PR-2** (`paket-pruefen.ps1`) | prüft die Maschine statt das Paket | **trägt**, und schwerer als behauptet |
| **V-1** (zwei ZIPs, eine Nummer) | zwei ZIPs unter 1.0.3 | **trägt**, es sind **drei** |
| **S-8/E-8** (Paket 1.0.2) | Debug-Bau, nicht verteilbare DLLs | **trägt** — das ist Gregors Fehlschlag |
| **X-2** (Schranke, 35 Fälle) | 35 von 35 grün | **trägt** — nachgemessen |
| **NP3-6/7** (`pruefstand-melden.pl`) | rc=0, drei Marken | **trägt** — nachgemessen |
| **X-4** („0 Abweichungen") | 0 Abweichungen in allen Richtungen | **trägt hier NICHT** — 801 Dateien weichen ab |
| Verzeichnis in `BEFUNDE.md` | Status je Befund gepflegt | **drei Fehler** gefunden |

---

## 1. Was ich selbst gemessen habe

### 1.1 „0 Abweichungen in allen Richtungen" gilt auf Windows nicht — 801 Dateien

`WEITERMACHEN.md` nennt als nachprüfbar:

```
perl tools/zeilenenden-angleichen.pl    # 0 Abweichungen in allen Richtungen
```

**Gemessen auf dieser Maschine:**

```
byteidentisch zu HEAD:             5643
Arbeitskopie CRLF, HEAD LF:         801     <-- nicht 0
Arbeitskopie LF, HEAD CRLF:           0
inhaltlich verschieden:               0
```

Die Aussage stimmt auf einem frischen Linux-Klon und **nur dort**. Sie steht
ohne diese Einschränkung da, und das ist gefährlich, weil sie genau die
Fehlerklasse für erledigt erklärt, die dieses Projekt zweimal Tage gekostet hat
(**S-7**).

**Belegt am Einzelfall `BuildTools/SetupBuild.bat`:**

| | |
|---|---|
| Arbeitskopie | 39 Bytes, 2 CR |
| Index **und** HEAD | 37 Bytes, 0 CR, Blob `8ea7a115` |
| `git status` | **meldet nichts** |
| `git diff --quiet` | rc=0, also „keine Änderung" |
| `git check-attr` | `text: unset` — git wandelt nachweislich **nicht** um |

Es ist also keine Umwandlung durch git, sondern der Zwischenspeicher für
Dateizustände: git hat die Datei seit dem Auschecken nicht wieder gelesen.

**Die Folge, vorgeführt:**

```
touch BuildTools/SetupBuild.bat     # nur der Zeitstempel, kein Byte
git status                          # -> M BuildTools/SetupBuild.bat
git diff --numstat                  # -> 2  2   die GANZE Datei
```

Wer eine dieser 801 Dateien anfasst, bekommt sie vollständig als Änderung in
den Commit. Die Commit-Schranke `pruefe-bytes.pl` arbeitet auf
`git diff --cached` und sieht sie vorher **nicht**.

Betroffen sind `.bat`, `.inc`, `.hpj`, `.xml`, `.ini`, überwiegend in
`Documents/VisualTestScripts`, `Documents/Manuals` und `BuildTools`. Die vom
Branch neu aufgenommenen Endungen (`hh hpj ih mc rgs user`) sind **nicht** die
Ursache — nur 2 der 801 sind `.hpj`. Der Zustand war vorher da und ist bisher
niemandem aufgefallen, weil niemand diese Dateien anfasst.

Behebbar mit `perl tools/zeilenenden-angleichen.pl --aendern`. **Nicht getan** —
Auftrag war Prüfen.

### 1.2 Das Verzeichnis in `BEFUNDE.md` widerspricht sich

Der Branch führt ein Verzeichnis ein (Zeilen 44–160) und stellt die Auflage
auf: *„wer einen Befund fortschreibt, ändert die Statusspalte hier mit."*
Diese Auflage ist im selben Branch dreimal verletzt.

**a) PR-5 steht auf „offen", ist aber behoben.**

| Stelle | Aussage |
|---|---|
| `BEFUNDE.md:105` | `W-1 … **behoben** (PR-5 offen)` |
| `BEFUNDE.md:3811` | `PR-5 … offen (nur Beschreibung)` |
| `BEFUNDE.md:4040` | Überschrift `### PR-5 bleibt offen` |
| `WEITERMACHEN.md:71` | „an drei Stellen berichtigt. Damit ist **PR-1 bis PR-8 vollständig**" |
| `WEITERMACHEN.md:521` | „~~PR-5~~ — **erledigt** am 31.08.2026 abends" |

Der Commit `765c39b` („PR-5 und die LIESMICH des ausgelieferten Pakets") hat
`BEFUNDE.md` nur um **eine** Zeile geändert. Die drei Statusangaben blieben
stehen. Wer das Verzeichnis liest — und dafür ist es da — bekommt den falschen
Stand.

**b) `P-3` hat einen Abschnitt (`BEFUNDE.md:2437`), steht aber in keinem
Verzeichniseintrag.** Gemessen: 55 Abschnitte im Text, 64 Kennungen im
Verzeichnis, `P-3` fehlt.

**c) `PR-3` bis `PR-8` sind nur gesammelt über die Zeile `W-1` erfasst.** Wer
nach `PR-6` sucht, findet im Verzeichnis nichts. Kleiner Mangel, aber er
untergräbt den Zweck.

### 1.3 Was sich sauber reproduzieren ließ

```
perl tools/pruefe-bytes-tests.pl   ->  35 Faelle: 35 gruen, 0 rot        BESTAETIGT
perl tools/pruefstand-melden.pl    ->  rc=0, drei Marken, HEAD 2fee8e9   BESTAETIGT
```

`E-10` gibt es tatsächlich nicht — 0 Abschnitte, der einzige Treffer im ganzen
Repo ist der Satz, der das feststellt. **BESTÄTIGT.**

---

## 2. Was die Agenten gemessen haben

Die vollständigen Einzelberichte liegen unter [Pruefung/](Pruefung/).

### 2.1 KETTE — Befund R-1, die 142 `ReleaseBuffer`-Stellen

Bericht: [Pruefung/PRUEFUNG-KETTE.md](Pruefung/PRUEFUNG-KETTE.md)

**Die Einstufung selbst trägt.** Der Werkzeuglauf reproduziert R-1 auf die
Zahl: 142 Vorkommen, 20 falsch / 4 lockbuffer / 1 danach / 117 ok. Für alle 20
beanstandeten gibt es in der ganzen Datei kein `GetBuffer` — **keine einzige
Falschmeldung.** Eine Stelle wurde **übersehen**: `QCMailboxDirector.cpp:1316`.
Aus 25 werden 26.

**Aber die Schlussfolgerung zu E-11 trägt nicht.**

Der Branch schreibt, die E-11-Behebung sei „wahrscheinlich unvollständig", weil
in derselben Funktion zwei weitere Vorkommen stehen. Funktionsgrenzen
(3274–3417) und Zeilen (:3403, :3413) stimmen auf die Zeile. Die Erreichbarkeit
stimmt auch und ist sogar untertrieben — `:3413` läuft unbedingt.

**Nur: keine der drei Zeilen kann abstürzen.** Nachgerechnet an den
Zeichenketten aus `EudoraRes.rc`:

| Stelle | Zeichenkette | Länge | übergebener Index |
|---|---|---|---|
| `:3372` (E-11) | `mailto\shell\open\command` | 25 | **6** |
| `:3403` | `Software\Clients\Mail\Eudora` | 28 | **21** |
| `:3413` | `x-eudora-option\shell\open\command` | 34 | **15** |

In den MFC-Quellen von VS2022 (`atlsimpstr.h`) ist `ReleaseBuffer(n)` nichts
als `SetLength(n)` ohne `Fork`. Schaden entsteht in genau zwei Fällen:
`n > nAllocLength` (dann wirft es) oder ein **geteilter** Puffer (dann kürzt es
stillschweigend eine fremde Zeichenkette mit). Hier trifft weder das eine noch
das andere zu — alle drei Indizes liegen deutlich unter der Länge, und
`RegMailto`, `RegClientsMail` und `EudoraOption` sind frisch gebaute
`CRString` mit `nRefs == 1`.

> **Damit ist die Ursache von Gregors Absturz wieder offen.** E-11 hat einen
> echten Mangel behoben — aber VERMUTLICH nicht den wirksamen. Wer das nächste
> Paket baut, sollte nicht damit rechnen, dass der Absturz weg ist. Die
> Gegenhypothese „`pMainFrame` ist NULL" wurde geprüft und widerlegt.

**R-1 priorisiert außerdem falsch.** Als dringend geführt sind die vier
`sendmail`-Stellen — die sind harmlos (eigener Puffer, Argument innerhalb der
Länge). Wirklich schädlich sind zwei, die R-1 weiter unten führt:

| Stelle | Warum es weh tut |
|---|---|
| `SMTPSession.cpp:683` | `GetPOPAccount()` liefert `CString&` — gekürzt wird die **gespeicherte Kontoeinstellung**, keine Kopie |
| `PaigeEdtView.cpp:657` | `CDocument::GetTitle()` liefert `const CString&` — gekürzt wird der **echte Dokumenttitel** |

**Grenzen des Werkzeugs**, an einer Probedatei gemessen: ein `//` in einem
Zeichenketten-Literal verschluckt ein Vorkommen **stillschweigend**; `#if 0`,
Literale und `#define` erzeugen Fehlalarme; ein `GetBuffer` in einem nicht
durchlaufenen Zweig gilt als Paar; die Argumente von `GetBuffer` und
`ReleaseBuffer` werden **nie** verglichen. Nebenbefund: R-1s LockBuffer-Zählung
ist falsch (7/2 statt 6/1 — `grep` traf `UnlockBuffer` als Teilstring), und
`qctree.cpp:269` ist ein `LockBuffer` ganz ohne Partner, das in R-1 fehlt.

### 2.2 ZEIGER — Befund D3a, die neun Zeigerstellen

Bericht: [Pruefung/PRUEFUNG-ZEIGER.md](Pruefung/PRUEFUNG-ZEIGER.md)

**Trägt nicht. Von neun halten vier.**

| Nr | Stelle | Urteil |
|---|---|---|
| 1 | `ImapMailbox.cpp:1637` — „der ernsteste der neun" | **kein Befund** — Zeile 1652 hat `return E_FAIL;` |
| 2 | `POPSession.cpp:896` | **kein Befund** — Zeile 834 `if(!pDiskHost) return FALSE;` |
| 3 | `ImapChecker.cpp:945` | kein Zusatzrisiko — `:936` greift schon ungeprüft zu |
| 5 | `imapgets.cpp:735` | **kein Befund** — liegt in `#if 0` (705–796) |
| 7 | `headervw.cpp:546` | Wächter kann nicht auslösen |
| 8 | `PgEmbeddedObject.cpp:276` | **kein Befund** — `pDoc != 0` impliziert `pView != 0` |
| 4, 6, 9 | `ImapMailbox.cpp:1022`, `TocFrame.cpp:3968`, `WizardImportPage.cpp:379` | **echt** |

Die gefährlichste ist **Nummer 9**, `WizardImportPage.cpp:420` — und sie steht
in D3a ganz **unten**. Die Schwesterfunktion `SetupControls():265` behandelt
denselben Wert ausdrücklich als NULL-Fall.

Die tragende Annahme von Stelle 1 — *ASSERT ist im Release leer* — **stimmt**,
belegt über `Eudora.vcxproj:132` → `stdafx.h:54` → `qcassert.h` →
`SuperAssert.h:135`. Sie trägt nur nichts, weil das `return` da ist.

**Neu gefunden, stärker als fünf der gemeldeten neun:**
`settings.cpp:2939-2944` → `:2953-2955` — drei Prüfungen, vierzehn Zeilen
später dreimal derselbe Zugriff ungeschützt, und `GetDlgItem` **kann** NULL
liefern. Das Werkzeug hatte es durch seinen Namensfilter (Zeile 117)
stummgeschaltet: ohne den Filter 40 statt 18 Treffer.

### 2.3 PAKET — Kriterium 0, das ausgelieferte Paket

Bericht: [Pruefung/PRUEFUNG-PAKET.md](Pruefung/PRUEFUNG-PAKET.md)

**Gregors Fehlschlag ist erklärt, und die Erklärung ist nicht die erwartete.**

Das Paket, an dem er auf dem Laptop gescheitert ist, war **1.0.2**, und das ist
ein **reiner Debug-Bau**: `Eudora.exe` importiert nachweislich `mfc140d.dll`,
`msvcp140d.dll`, `vcruntime140d.dll`, `ucrtbased.dll`. Diese vier sind **nicht
weiterverteilbar** und liegen nur auf Rechnern mit VS2022. Ohne sie
`0xc000007b`. **S-8/E-8 ist damit belegt.**

**Paket 1.0.3 ist dagegen bereits in Ordnung.** Gemessen: reines Release, null
Debug-Importe, null PDBs, alle 36 PE-Dateien x86, `mfc140`/`msvcp140`/
`vcruntime140` (14.38.33142.0) liegen bei, die Startkette aus 14 Modulen löst
vollständig auf. `ucrtbase` und die `api-ms-win-crt-*` bringt Windows 10 mit.
**Es ist nichts einzusammeln.**

Was in 1.0.3 fehlt, ist **nicht startrelevant**: `MFC71.DLL` und `MSVCP71.dll`
(VS.NET 2003, von Microsoft nie als Redistributable veröffentlicht). Sie kosten
Adressbuch, LDAP, Ph, S/MIME und SpamWatch — nicht den Start.

Zwei Fallstricke, die nur die Importmessung aufdeckt: `Paige32d.dll` ist trotz
des „d" ein **Release**-Bau, und `msvcr71.dll` (35 KB) ist nicht Microsofts
Datei, sondern die eigene VC71-Brücke auf `msvcrt.dll` — Gegenprobe: alle 118
benötigten Symbole vorhanden, Fehlmenge 0.

**E-6 ist gelöst.** `Mailverzeichnis\Eudora.ini` **ist** im Paket, schon in
1.0.2. Die Hürde ist der Startpfad: Eudora braucht das Verzeichnis als
Argument, und im Paket liegt **keine `.bat`, `.cmd` oder `.lnk`**. Beim
Doppelklick sucht es die INI im Programmverzeichnis und findet keine.

**PR-2 trägt, und Teil 1 wiegt schwerer als behauptet.** `Finde-DLL`
(`:260-272`) akzeptiert `SysWOW64`/`System32` kommentarlos; Prüfung 3 (`:360`)
sichert nur die vier *Debug*-Laufzeiten ab. Gegenprobe: aus einer Kopie
`mfc140`/`msvcp140`/`vcruntime140` gelöscht → *„ERGEBNIS: keine Fehler,
EXITCODE=0"*. **Das Werkzeug winkt genau den 1.0.2-Fehler durch.** Auf einer
Maschine ohne VS2022 werden aus den vier Falschwarnungen vier **Fehler** mit
Exit 1 — dann verwirft es das korrekte Paket.

**V-1 trägt und ist stärker: es sind drei ZIPs**, nicht zwei. Blobs
`c06b2e6c` / `7ead246e` / `69e19f41`, Prüfsummen `632c4066` / `89f9fe0b` /
`d4719047`, identische Dateilisten, dieselbe Versionsnummer, die
Prüfsummendatei jedes Mal überschrieben.

---

## 3. Zusammenführung

Der Branch wurde am 05.09.2026 von Gregor nach `main` zusammengeführt und
gelöscht. Vorher geprüft: reines Vorspulen, **null** übersetzte Dateien
geändert, Bauzustand danach unverändert. Die falschen Befunde sind Text, kein
Code — sie richten keinen Schaden an, solange sie berichtigt werden.

## 4. Was zuerst zu tun ist

1. **Die Ursache des Absturzes bei *Weiter* ist wieder offen.** E-11 hat einen
   echten Mangel behoben, aber vermutlich nicht den wirksamen.
2. **Die 801 CRLF-Dateien angleichen**, bevor jemand eine davon anfasst.
3. **`paket-pruefen.ps1`** auf Release-Laufzeiten umstellen und den
   SysWOW64-Freibrief entfernen — es gibt derzeit Entwarnung für genau den
   Fehler, an dem Gregor gescheitert ist.
4. **Einen Starter ins Paket legen** (`.cmd` mit dem Mailverzeichnis als
   Argument) — das ist E-6.
5. **Paket 1.0.2 zurückziehen**; 1.0.3 auf dem VS-freien Laptop erproben,
   Prüfsumme `d4719047…` mitgeben.
6. **Statusspalten berichtigen**: PR-5, `P-3`, `PR-3` bis `PR-8`.
7. Erst dann die 26 `ReleaseBuffer`-Stellen — beginnend mit
   `SMTPSession.cpp:683` und `PaigeEdtView.cpp:657`, **nicht** mit `sendmail`.

