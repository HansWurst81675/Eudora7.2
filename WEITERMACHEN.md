# Hier weitermachen

Übergabe vom 30.08.2026. Arbeitsbranch `eudora-exe-linkt`; der frühere Branch
`vs2022-portierung-fixes` ist mit `22a6d77` nach `main` gemergt und wird nicht mehr
weitergeführt.

Diese Datei ist der Einstieg für die nächste Sitzung. Sie sagt, wo genau die Arbeit
steht, was als Nächstes dran ist und welche Fallen im Arbeitsverzeichnis liegen.

**Alle Zahlen hier sind an `e875979` gemessen.** An diesem Baum arbeiten mehrere
Agenten gleichzeitig; der Stand bewegt sich. Wer eine Zahl weiterverwendet, misst
nach und nennt seinen eigenen Bezugscommit.

## Zuerst: Umgebung herrichten

Nach einem frischen Klon fehlen die Schutzmechanismen — git versioniert Hooks nicht:

```bash
sh tools/hooks-einrichten.sh
```

```bash
git config core.autocrlf false
```

Beides ist nicht optional. Ohne den Hook treten zwei Fehlerklassen lautlos wieder
auf, die uns mehrfach Zeit gekostet haben.

**Ausserdem fehlen nach einem frischen Klon zwei Bibliotheken, ohne die `QCSSL`
nicht linkt.** `Eudora71/OpenSSL3/lib/libcrypto.lib` und `libssl.lib` sind von
`.gitignore:7` (`Lib/`) erfasst und liegen deshalb **nicht** im Repo — gemessen:
`git ls-files Eudora71/OpenSSL3/lib` liefert null Treffer. In einem frischen Klon
endet `QCSSL` mit `LNK1104: libssl.lib`. Sie müssen nach
`Eudora71/OpenSSL3/BAUEN.md` neu erzeugt oder von Hand hineinkopiert werden.

## Wo wir stehen

Das Ziel dieser Etappe ist ein **linkendes `Eudora.exe`**. Der Blocker ist die
fehlende Fremdbibliothek `OTA50D.LIB` (Stingray Objective Toolkit) — sie wird durch
eine eigene Ersatzschicht unter `Eudora71/OTShim/` ersetzt.

**Die Ersatzschicht ist vollständig eingehängt** (`e50a89c`), und **`Eudora`
übersetzt seit `78a9c10` fehlerfrei.** Erreicht wird jetzt der Linker.

Stand an `e875979` (`wc -l`; Einhängung geprüft gegen `OTShimAll.h` und die
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

### Gemessener Bauzustand an `e875979`

| Messung | Ergebnis |
|---|---|
| Solution-Bau `Debug\|x86` | **3 Fehler, alle aus `OT501`** (zweimal `NMAKE U1073`, einmal `MSB3073`) |
| fertige Projekte | **15 von 18** |
| `Eudora.vcxproj` einzeln (`-p:BuildProjectReferences=false`) | übersetzt **vollständig**; `LNK1120: 8 nicht aufgelöste Externe` |

Die vier Projekte `AccountWizard`, `DirectoryServicesUI`, `EuImap` und
`SearchEngine`, die zwischenzeitlich gebrochen waren, bauen wieder — ihre `.lib`
liegen nach dem Lauf in `Lib/Debug`. Nicht fertig werden `OT501` (Quellen nicht
freigegeben) sowie `Eudora` und `EudoraRes`, die über einen Projektverweis an
`OT501` hängen und im Solution-Bau gar nicht erst versucht werden.

### Die 8 verbliebenen Symbole

Gemessen am Link von `Eudora.exe` gegen die leere Attrappe `OTA50D.LIB`:

| Symbol | Herkunft |
|---|---|
| `SECBitmapButton::SECBitmapButton()` | Stingray, `secbtns.h:189` |
| `SECBitmapButton::~SECBitmapButton()` | Stingray, `secbtns.h:233` |
| `ATL::CImage::s_initGDIPlus` | nicht Stingray (ATL) |
| `ATL::CImage::s_cache` | nicht Stingray (ATL) |
| `CVoiceText::Init(...)` | nicht Stingray (SpeechSDK) |
| `CVoiceText::Speak(...)` | nicht Stingray (SpeechSDK) |
| `TraceStart(...)` | nicht Stingray |
| `__imp___iob` | nicht Stingray — aus der vorgefertigten `libpng.lib` |

Nur zwei davon sind überhaupt Stingray. Die Zahl bewegt sich noch: LINKER mass 8
an `78a9c10`, SUMME 14 an einem anderen Stand; die 8 oben sind an `e875979`
nachgemessen.

Die früheren Symbolzahlen **1088 (651 verschiedene)** und **rund 299** stammen aus
einem Zustand vor dem vollständigen Einhängen. Sie sind an heutigen Commits **nicht
reproduzierbar** und nur als Größenordnung zu lesen.

## Der nächste Schritt, konkret

Die acht Symbole oben abräumen. Zwei Gruppen:

1. **`SECBitmapButton`** — die einzige echte Stingray-Lücke. `secbtns.h` deklariert
   die Klasse, Stufe 3 ersetzt sie nicht. Gebraucht wird sie in `mainfrm`,
   `nickpage`, `nicksht` und `PaymentAndRegistrationDlg`.
2. **Der Rest ist kein Stingray** und hat mit der Ersatzschicht nichts zu tun:
   `ATL::CImage` braucht die statischen Member aus `atlimage.h`, `CVoiceText` das
   SpeechSDK, `__imp___iob` stammt aus der vorgefertigten VC6-`libpng.lib`.

Danach ist `Eudora.exe` gebunden. Was beim **ersten Start** danebenliegen muss —
insbesondere die fehlende `EudoraRes.dll` —, steht in
[STARTUMGEBUNG.md](STARTUMGEBUNG.md).

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

**1. `Eudora71/Lib/Debug/OTA50D.LIB` ist eine leere Attrappe.**
Sie sorgt dafür, dass der Linker über `LNK1104` hinweggeht und verrät, welche
Symbole tatsächlich fehlen. Sie ist absichtlich **nicht eingecheckt** und nach einem
frischen Klon nicht vorhanden. Neu erzeugen:

```bash
echo "// leer" > leer.cpp && cl /nologo /c leer.cpp && lib /nologo /OUT:Eudora71\Lib\Debug\OTA50D.LIB leer.obj
```

Sobald die Ersatzschicht vollständig ist, muss sie **weg** — sonst linkt Eudora
gegen eine leere Bibliothek und niemand merkt es.

**2. Die Quellen haben von Haus aus gemischte Zeilenenden — pro Datei verschieden.**

Das ist der **Originalzustand der Eudora-Quellen**, keine Umschreibung durch git:
manche Dateien rein LF (`stdafx.h`), manche rein CRLF (`OTShim.h`), die meisten
gemischt (`mainfrm.cpp`: 18 CR auf über 8000 Zeilen).

Seit `1f42745` liegt eine `.gitattributes` mit `* -text` im Repo. Damit ist **git
als Fehlerquelle ausgeschlossen**: beim Auschecken wie beim Einchecken bleiben die
Bytes, wie sie sind, unabhängig davon, wie `core.autocrlf` auf dem jeweiligen
Rechner steht. Ein vorsorgliches `git checkout HEAD -- <datei>` ist damit
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
