# Hier weitermachen

Übergabe vom 30.08.2026. Arbeitsbranch `eudora-exe-linkt`; der frühere Branch
`vs2022-portierung-fixes` ist mit `22a6d77` nach `main` gemergt und wird nicht mehr
weitergeführt.

Diese Datei ist der Einstieg für die nächste Sitzung. Sie sagt, wo genau die Arbeit
steht, was als Nächstes dran ist und welche Fallen im Arbeitsverzeichnis liegen.

**Alle Zahlen hier sind an `a807b93` gemessen.** An diesem Baum arbeiten mehrere
Agenten gleichzeitig; der Stand bewegt sich. Wer eine Zahl weiterverwendet, misst
nach und nennt seinen eigenen Bezugscommit.

## Zuerst: Umgebung herrichten

Nach einem frischen Klon fehlen die Schutzmechanismen — git versioniert Hooks nicht:

```bash
git config core.autocrlf false
sh tools/hooks-einrichten.sh
perl tools/zeilenenden-angleichen.pl --aendern
git ls-files -z | xargs -0 -n 400 git add --
```

Alle vier sind nicht optional. Ohne den Hook treten zwei Fehlerklassen lautlos
wieder auf, die uns mehrfach Zeit gekostet haben. Und ein Klon mit
`core.autocrlf=true` hinterlässt Dateien, die git für sauber hält, obwohl sie im
Arbeitsverzeichnis als CRLF und im Commit als LF stehen — gemessen 4616 von 5563.
Das ist Befund **S-7**, die Wurzel aller CRLF-Probleme dieses Projekts.

**Ausserdem fehlen nach einem frischen Klon zwei Bibliotheken, ohne die `QCSSL`
nicht linkt.** `Eudora71/OpenSSL3/lib/libcrypto.lib` und `libssl.lib` sind von
`.gitignore:7` (`Lib/`) erfasst und liegen deshalb **nicht** im Repo — gemessen:
`git ls-files Eudora71/OpenSSL3/lib` liefert null Treffer. In einem frischen Klon
endet `QCSSL` mit `LNK1104: libssl.lib`. Sie müssen nach
`Eudora71/OpenSSL3/BAUEN.md` neu erzeugt oder von Hand hineinkopiert werden.

## Wo wir stehen

Das Ziel dieser Etappe war ein **linkendes `Eudora.exe`**. Der Blocker war die
fehlende Fremdbibliothek `OTA50D.LIB` (Stingray Objective Toolkit) — sie ist durch
eine eigene Ersatzschicht unter `Eudora71/OTShim/` ersetzt.

> **Das Ziel dieser Etappe ist erreicht.** Seit `a807b93` bindet `Eudora.exe`
> vollständig — **0 Übersetzungsfehler, 0 ungelöste Externe** —, und die leere
> Attrappe `OTA50D.LIB` wird dafür **nicht mehr gebraucht**. Selbst nachgemessen
> an `a807b93` in einem frisch ausgecheckten Baum, aus dem die Attrappe entfernt
> war: `Eudora.exe`, 10 203 136 Byte.

Die Ersatzschicht ist vollständig eingehängt (`e50a89c`), `Eudora` übersetzt seit
`78a9c10` fehlerfrei, und mit `a807b93` ist auch das Binden durch.

Stand an `a807b93` (`wc -l`; Einhängung geprüft gegen `OTShimAll.h` und die
`ClCompile`-Einträge in `Eudora.vcxproj:217`):

| Stufe | Inhalt | Dateien | Zeilen | eingehängt? |
|---|---|---|---|---|
| 0–2, 2b | Workbook, MDI, Statusleiste, Andockfamilie | `OTShim.h/.cpp` | 5494 | ja |
| 3 | Werkzeugleisten und Knöpfe | `OTShim_Werkzeugleiste.h/.cpp` | 6083 | ja |
| 4 | Bilder über GDI+ | `OTShim_Bild.h/.cpp` | 2358 | ja |
| Registerkarten | `SEC3DTabControl` und Verwandte | `OTShim_Reiter.h/.cpp` | 2925 | ja |
| `SECDateTimeCtrl`, Palette | Datumsfeld der Suche, `CSafetyPalette` | `OTShim_Palette.h/.cpp` | 890 | ja |
| — | Sammelkopfdatei | `OTShimAll.h` | 78 | — |

Zusammen **17828 Zeilen** in 11 Dateien. Dazu ist `OT501/Src/secaux.cpp` direkt in
`Eudora.vcxproj` aufgenommen — `secData` brauchte keinen Nachbau.

### Gemessener Bauzustand an `a807b93`

| Messung | Ergebnis |
|---|---|
| `Eudora.vcxproj` einzeln (`-p:BuildProjectReferences=false`) | **0 Fehler**; `Eudora.exe` 10 203 136 Byte — **ohne** Attrappe |
| Solution-Bau `Debug\|x86` | **3 Fehler, alle aus `OT501`** (zweimal `NMAKE U1073`, einmal `MSB3073`) |
| fertige Projekte | **16 von 18** |
| Testlauf `Eudora71/Tests/RunTests.cmd` | **33 Tests, 33 bestanden, 0 fehlgeschlagen** (an `04e93c3`) |

`Eudora` wird im Solution-Bau jetzt mitgebaut und **fertig**. Nicht fertig werden
nur noch zwei: `OT501` (Quellen nicht freigegeben, bricht ab) und **`EudoraRes`**,
das über seinen Projektverweis (`EudoraRes.vcxproj:351`) an `OT501` hängt und gar
nicht erst versucht wird — es taucht im Bauprotokoll überhaupt nicht auf. Deshalb
fehlt `EudoraRes.dll` in `Bin/Debug`; sie wird zur Laufzeit nachgeladen, siehe
[STARTUMGEBUNG.md](STARTUMGEBUNG.md).

Die vier Projekte `AccountWizard`, `DirectoryServicesUI`, `EuImap` und
`SearchEngine`, die zwischenzeitlich gebrochen waren, bauen wieder — ihre `.lib`
liegen nach dem Lauf in `Lib/Debug`.

### Der Weg von 1088 auf 0

| Bezug | ungelöste Externe |
|---|---|
| früher, nicht reproduzierbar | 1088 (651 verschiedene) |
| früher, nicht reproduzierbar | rund 299 |
| `78a9c10` | 8 |
| `4ba2dd3` | 3 |
| `e61f243` | 1 |
| **`a807b93` (selbst nachgemessen)** | **0** |

Die beiden obersten Zahlen stammen aus einem Zustand vor dem vollständigen
Einhängen. Sie sind an heutigen Commits **nicht reproduzierbar** und nur als
Größenordnung zu lesen.

Das letzte Symbol war `__imp___iob` aus der vorgebauten `libpng.lib` (libpng 1.2.7,
aus der Zeit vor der UCRT) — **kein Stingray**. Gelöst ist es in
`OTShim_Libpng.cpp`, das `_imp___iob` mit `(char*)stderr - 2*32` definiert, weil
libpng ausschliesslich `_iob[2]` anfasst und die damalige CRT 32 Byte je Element
hatte. **Sauber wäre erst ein Neubau von libpng** aus `Eudora71/PNG/libpng` mit
v143; der Behelf ist im Kopf der Datei begründet.

## Der nächste Schritt, konkret

Binden **und** Starten sind durch: Eudora zeigt sein Hauptfenster (30.08.2026,
Paket 1.0.2, Befund S-2). Maßstab für alles Weitere ist jetzt [ZIEL.md](ZIEL.md) —
drei Kriterien, erfüllt ist bisher nur das erste.

1. **Kriterium 2 — Darstellung.** Menüs lassen sich nicht öffnen (Befund S-5,
   Agent MENUE), und mehrere Wazoos überlagern sich (S-6, Agent ANSICHT).
2. **Kriterium 3 — Mailabruf.** Noch nie mit dem selbst gebauten `Eudora.exe`
   durchgeführt. Nachweis: Protokollversion aus *Tools → Last SSL Info* und eine
   lesbar dargestellte empfangene Nachricht.
3. **VC7.1-Laufzeiten sauber lösen** (Agent BRUECKE). `MFC71.DLL` und
   `MSVCP71.dll` fehlen weiterhin (S-3c); die beiliegende `msvcr71.dll` stammt von
   dll-files.com und ist unsigniert (S-1). Eine eigene Weiterleitungs-DLL auf die
   von Windows mitgelieferte `msvcrt.dll` käme ohne Fremdbinärdatei aus — Paige
   braucht daraus 20 Funktionen, 19 davon exportiert `msvcrt.dll`.
4. **`EudoraRes.dll` beschaffen.** Sie fehlt in `Bin/Debug` und ihr Projekt hängt
   über `EudoraRes.vcxproj:351` an `OT501`. Derselbe Handgriff wie bei `Eudora`
   (`LinkLibraryDependencies` auf `false`, `_SECNOMSG`) ist der naheliegende Weg —
   **nicht geprüft**.
5. **`libpng` sauber nachziehen.** Der Behelf in `OTShim_Libpng.cpp` hält, solange
   libpng nur `_iob[2]` anfasst und die Elementgrösse 32 Byte bleibt. Ein Neubau
   aus `Eudora71/PNG/libpng` mit v143 macht die Annahme überflüssig.
6. **`Release|x86` prüfen.** Bisher ist nur `QCSSL` im Release-Zweig gebaut; der
   Release-Zweig scheitert an einer fehlenden `Imap.lib`. Solange nur der Debug-Bau
   läuft, muss jeder Anwender drei bis vier SUPERASSERT-Dialoge wegklicken (S-3b).

## Eine Falle, die schon einmal in die Irre geführt hat

> **Den Wächter `__SECBTNS_H__` in `OTShimAll.h` NICHT einkommentieren.**

Frühere Fassungen dieser Datei nannten das als Lösungsschritt. **Das ist
nachgemessen falsch.** `secbtns.h` liefert ausser `SECLoadSysColorBitmap` auch
`SECBitmapButton`, und das ersetzt Stufe 3 nicht — wer den Wächter setzt, nimmt die
Klasse mit weg.

Selbst nachgemessen an `22a6d77`, `Eudora.vcxproj` einzeln:

| Wächter | Fehler |
|---|---|
| auskommentiert (wie im Repo) | **1** (`secbtns.h(340,83): C2572`) |
| eingekommentiert | **102** (`C3646`, `C4430`, `C2065`, `C2653`, `C3861`) |

Gelöst ist der `C2572` stattdessen in `OTShim.h:307`: die dortige inline-Fassung
von `SECLoadSysColorBitmap` führt **kein Standardargument** mehr, `secbtns.h:340`
trägt es nach (`78a9c10`). Die Begründung steht auch in `OTShimAll.h` an der
auskommentierten Stelle — sie soll dort auskommentiert bleiben.

## Fallen im Arbeitsverzeichnis

**1. Die Attrappe `OTA50D.LIB` wird nicht mehr gebraucht — und darf nicht wieder
auftauchen.**
Während der Arbeit an der Ersatzschicht lag unter `Eudora71/Lib/Debug/OTA50D.LIB`
eine leere Platzhalter-Bibliothek, damit der Linker über `LNK1104` hinweggeht und
verrät, welche Symbole wirklich fehlen. Seit `a807b93` ist sie **überflüssig**: zwei
Änderungen in `Eudora.vcxproj` lösen die Bindung an sie — `_SECNOMSG` in den
Präprozessordefinitionen (`SECVER.H:210-211` hängt das
`pragma comment(lib, ...)` daran) und `LinkLibraryDependencies` auf `false` beim
Projektverweis auf `OT501` (Zeile 1015).

Nachgemessen an `a807b93` in einem Baum **ohne** die Attrappe: `Eudora.exe` bindet
mit 0 Fehlern. Wer sie wieder anlegt, linkt gegen eine leere Bibliothek, ohne dass
es auffällt — also nicht tun.

**2. Die Quellen haben von Haus aus gemischte Zeilenenden — pro Datei verschieden.**

Das ist der **Originalzustand der Eudora-Quellen**, keine Umschreibung durch git:
manche Dateien rein LF (`stdafx.h`), manche rein CRLF (`OTShim.h`), die meisten
gemischt (`mainfrm.cpp`: 18 CR auf über 8000 Zeilen).

Seit `1f42745` liegt eine `.gitattributes` mit `* -text` im Repo. Damit ist **git
für die Zukunft als Fehlerquelle ausgeschlossen**: beim Auschecken wie beim
Einchecken bleiben die Bytes, wie sie sind, unabhängig davon, wie `core.autocrlf`
auf dem jeweiligen Rechner steht.

**Der Schaden aus der Vergangenheit war damit aber nicht beseitigt** — dieser Baum
war seinerzeit mit `core.autocrlf=true` ausgecheckt worden, und 4616 Dateien lagen
weiter als CRLF im Arbeitsverzeichnis, während im Commit LF stand. Die frühere
Vermutung „mit `autocrlf=true` geklont" war **richtig**; sie wurde damals zu
Unrecht als widerlegt abgehakt, weil `git config` zum Zeitpunkt der Prüfung schon
`false` sagte. Behoben durch `tools/zeilenenden-angleichen.pl` (Befund S-7, siehe
oben unter „Umgebung herrichten"). Ein vorsorgliches `git checkout HEAD -- <datei>` ist damit
gegenstandslos — und wer es doch tut, verwirft womöglich die Arbeit eines parallel
laufenden Agenten.

Was bleibt, ist die Vorsicht beim **Schreiben** (Punkt 3).

**Zum Nachmessen der CR-Anzahl** taugt `grep -c $'\r'` in Git Bash **nicht** — das
Muster kommt dort leer an und zählt schlicht alle Zeilen. Zuverlässig ist:

```bash
tr -cd '\r' < <datei> | wc -c
```

Damit gemessen: die Markdown-Dateien im Wurzelverzeichnis sowie `PLAN.md`,
`INVENTAR.md`, `BAUEN.md` und `Arbeitsweise/README.md` haben **0 CR** — dort ist
normales Editieren unbedenklich.

**3. Änderungen an Eudora-Quellen nur byte-erhaltend.**
Die Quellen sind Latin-1 mit gemischten Zeilenenden. Das Edit-Werkzeug und `sed` mit
handgebauten `\r\n` zerstören beides. Stattdessen:

```bash
perl tools/aendere-zeile.pl <datei> <zeilennummer> <alt> <neu>
```

Der pre-commit-Hook fängt Verstöße ab — aber erst nach der Arbeit.

**4. Fünf MIDL-Ausgaben verrauschen dauerhaft `git status`.**
`EudoraExe_i.c`, `EudoraExe_p.c`, `GoogleDesktopSearchAPI_i.c`, `_p.c`, `dlldata.c`
werden bei jedem Bau neu geschrieben, liegen aber zwischen den Quellen. Nicht
committen, nicht wundern.

**5. Der git-Index ist zwischen allen Agenten geteilt.**
Ein `git add` stagt auch die halbfertigen Dateien der anderen, und deren Commit
nimmt sie dann mit. Deshalb **immer mit ausdrücklicher Pfadangabe committen**, ohne
vorheriges `git add`:

```bash
git commit -m "..." -- <pfad1> <pfad2>
```

Bei `cannot lock ref 'HEAD'`: kurz warten und erneut versuchen.

**6. Beim parallelen Bauen `IntDir` überschreiben, `OutDir` nicht.**
Zwei gleichzeitig laufende `cl.exe` schreiben sonst in dieselbe
`Build\Debug\vc143.pdb` und der Bau bricht mit 148× `C1041` ab. `OutDir` dagegen
**nicht** überschreiben — die Projektverweise lösen ihre Importbibliotheken über
`$(OutDir)` auf, und der Link endet dann mit `LNK1104: AccountWizard.lib`. Beides
von LINKER gemessen, siehe `Eudora71/OTShim/PLAN.md`.

**7. Ein frisch ausgecheckter Baum baut anders als ein gewachsener.**
Im leeren Baum liefen `NSImport`, `OEImport` und `OLImport` in
`LNK1104: QCUtils.lib` — die Solution deklariert die Abhängigkeit nicht, bei `-m`
ist es ein Wettlauf. Ein zweiter Lauf im selben Verzeichnis behebt es. Wer Zahlen
vergleicht, muss denselben Zustand vergleichen.

## Was noch offen ist

| Thema | Wo es steht |
|---|---|
| Die 8 ungelösten Symbole, Weg zum Linken | `Eudora71/OTShim/PLAN.md`, Abschnitt „Der Weg zum Linken" |
| Laufzeitumgebung für den ersten Start, fehlende `EudoraRes.dll` | `STARTUMGEBUNG.md` |
| Prüfbefunde | `BEFUNDE.md` |
| Altbefunde | `BEFUNDE-ALTBESTAND.md` |
| Verschärfung der Zertifikatsprüfung — liegt bereit, **nicht angewandt** | `tools/patches/zertifikatspruefung-verschaerfen.patch` |
| Hostnamenprüfung greift nicht — bewusst zurückgestellt | `Arbeitsweise/zurueckgestellte-befunde.md` |
| `OpenSSL3/lib` liegt nicht im Repo (siehe oben) | `Eudora71/OpenSSL3/BAUEN.md` |
| Zeichensatz: Emoji und nichtlateinische Schriften | `PORTIERUNG.md` |

## Wie gearbeitet wird

Die Regeln stehen in [Arbeitsweise/](Arbeitsweise/README.md) — entstanden aus
konkreten Fehlgriffen, jede mit belegtem Anlass. Die vier wichtigsten:

- **Nie stillstehen.** Lange Läufe in den Hintergrund und währenddessen weiterarbeiten.
  Der teuerste Einzelfehler des Projekts war 1 Stunde 46 Minuten Leerlauf.
- **Prüfen statt vermuten.** Zahlen nur nennen, wenn gemessen. Bei einer früheren
  Prüfung waren acht Zahlen in der Doku falsch, weil sie geschätzt und als Tatsache
  geschrieben wurden.
- **Gemeinsame Dateien gegen die ganze Solution messen.** Eine Änderung an
  `stdafx.h` hat vier Projekte gebrochen, weil nur das eigene Projekt gebaut wurde.
  Siehe `Arbeitsweise/gemeinsame-dateien-gegen-alles-messen.md`.
- **Wissen gehört in Dateien.** Was nur im Gespräch steht, ist beim nächsten
  Abschalten weg.

Prüfung und Dokumentation gehören **ans Ende einer Arbeitswelle**, nicht parallel
dazu — sonst prüfen sie ein bewegliches Ziel. Wie weit sie zurückliegen:

```bash
perl tools/pruefstand-melden.pl
```
