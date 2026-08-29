# Hier weitermachen

Übergabe vom 29.08.2026, Branch `vs2022-portierung-fixes`.

Diese Datei ist der Einstieg für die nächste Sitzung. Sie sagt, wo genau die Arbeit
steht, was als Nächstes dran ist und welche Fallen im Arbeitsverzeichnis liegen.

## Zuerst: Umgebung herrichten

Nach einem frischen Klon fehlen die Schutzmechanismen — git versioniert Hooks nicht:

```bash
sh tools/hooks-einrichten.sh
```

```bash
git config core.autocrlf false
```

Beides ist nicht optional. Ohne den Hook treten zwei Fehlerklassen lautlos wieder
auf, die uns diese Sitzung mehrfach Zeit gekostet haben.

## Wo wir stehen

Das Ziel dieser Etappe ist ein **linkendes `Eudora.exe`**. Der Blocker ist die
fehlende Fremdbibliothek `OTA50D.LIB` (Stingray Objective Toolkit) — sie wird durch
eine eigene Ersatzschicht unter `Eudora71/OTShim/` ersetzt.

Stand gemessen an `e7e6f3c`, 29.08.2026 (`wc -l`, und Einhängung geprüft gegen
`OTShimAll.h` und die `ClCompile`-Einträge in `Eudora.vcxproj:217`):

| Stufe | Inhalt | Dateien | Zeilen | eingehängt? |
|---|---|---|---|---|
| 0–2, 2b | Workbook, MDI, Statusleiste, Andockfamilie | `OTShim.h/.cpp` | 5494 | **ja** |
| 3 | Werkzeugleisten und Knöpfe | `OTShim_Werkzeugleiste.h/.cpp` | 6083 | **nein** |
| 4 | Bilder über GDI+ | `OTShim_Bild.h/.cpp` | 2358 | **ja** |
| Registerkarten | `SEC3DTabControl` und Verwandte | `OTShim_Reiter.h/.cpp` | 2925 | **nein** |
| `SECDateTimeCtrl` | Datumsfeld der Suche | `OTShim_Palette.h/.cpp` | 890 | **nein** |
| — | Sammelkopfdatei | `OTShimAll.h` | 45 | — |

Zusammen **17795 Zeilen** in 11 Dateien. Registerkarten und `SECDateTimeCtrl` sind
also entgegen der früheren Fassung dieser Tabelle **geschrieben** (`0826be1` für
`SECDateTimeCtrl`); offen ist bei allen dreien nur noch das Einhängen.

**Der Linker wird zurzeit gar nicht erreicht.** `Eudora` einzeln gebaut endet mit
`secbtns.h(340,83): error C2572` — Neudefinition des Standardarguments von
`SECLoadSysColorBitmap`, weil der Wächter `__SECBTNS_H__` in `OTShimAll.h` noch
auskommentiert ist und `secall.h` das Stingray-Original daneben zieht. Genau das
löst sich mit Schritt 1 unten auf.

Frühere Messungen am Linker, **an `e7e6f3c` nicht reproduzierbar** und nur als
Größenordnung zu lesen:

| Zustand | ungelöste Symbole |
|---|---|
| ohne Ersatzschicht | 1088 (651 verschiedene) |
| nach Stufe 0–2 und 4 | rund 299 |
| nach Stufe 3 | rund 141 erwartet, **nie gemessen** |

## Der nächste Schritt, konkret

**Stufe 3 einhängen** — das behebt zugleich den `C2572`, an dem `Eudora` gerade
scheitert. Zu tun:

1. In `Eudora71/OTShim/OTShimAll.h` nach `#include "OTShim.h"` und **vor**
   `#include "OTShim_Bild.h"` die Zeile ergänzen:
   `#include "OTShim_Werkzeugleiste.h"`
   Reihenfolge ist wichtig: Stufe 3 baut auf `SECControlBar` und
   `SECControlBarManager` aus Stufe 2 auf.
2. In derselben Datei den Wächter `__SECBTNS_H__` **einkommentieren** — er steht
   dort schon vorbereitet mit dem Hinweis „erst setzen, wenn Stufe 3 geliefert
   ist". Solange er fehlt, zieht `secall.h` das Original `secbtns.h` daneben, und
   genau daraus entsteht der `C2572`.
3. `Eudora71/OTShim/OTShim_Werkzeugleiste.cpp` in `Eudora.vcxproj` aufnehmen, ohne
   vorkompilierten Header — wie die anderen Shim-Dateien in Zeile 217.
4. Bauen und die Symbolzahl messen.
5. Danach dasselbe für `OTShim_Reiter.*` und `OTShim_Palette.*`; beide sind
   geschrieben, aber ebenfalls nirgends eingebunden.

**Getrennt davon zu beheben: vier Projekte übersetzen nicht mehr.** `7dcac81` hat
in `Eudora71/Eudora/stdafx.h:52` `secall.h` durch `OTShimAll.h` ersetzt, aber
`..\OTShim` steht nur in `Eudora.vcxproj:66` auf dem Include-Pfad. `AccountWizard`,
`DirectoryServicesUI`, `EuImap` und `SearchEngine` binden dieselbe `stdafx.h` ein
und brechen jetzt mit `C1083: OTShimAll.h` ab. Ein voller Solution-Bau meldet
deshalb 7 Fehler statt 3, und es werden 11 von 18 Projekten fertig statt 15.
Vermutliche Behebung: `..\OTShim` in die `AdditionalIncludeDirectories` dieser vier
Projekte aufnehmen — **nicht nachgeprüft**.

**Achtung bei Schritt 1:** `aendere-zeile.pl` kann keine Zeilen *einfügen*, es
bricht ab, sobald sich die CR-Anzahl ändert. `OTShimAll.h` ist eine eigene Datei mit
reinem LF — dort ist ein normales Neuschreiben unbedenklich. Bei den originalen
Eudora-Quellen ist es das nicht.

## Fallen im Arbeitsverzeichnis

**1. `Eudora71/Lib/Debug/OTA50D.LIB` ist eine leere Attrappe.**
Ich habe sie erzeugt, damit der Linker über `LNK1104` hinweggeht und verrät, welche
Symbole tatsächlich fehlen. Sie ist absichtlich **nicht eingecheckt** und nach einem
frischen Klon nicht vorhanden. Neu erzeugen:

```bash
echo "// leer" > leer.cpp && cl /nologo /c leer.cpp && lib /nologo /OUT:Eudora71\Lib\Debug\OTA50D.LIB leer.obj
```

Ohne sie bricht der Link mit `LNK1104` ab, mit ihr läuft er bis zu den ungelösten
Symbolen. Sobald die Ersatzschicht vollständig ist, muss sie **weg** — sonst linkt
Eudora gegen eine leere Bibliothek und niemand merkt es.

**2. Die Quellen haben von Haus aus gemischte Zeilenenden — pro Datei verschieden.**

Hier stand bis `e7e6f3c` „Der Arbeitsbaum liegt in CRLF, HEAD in LF, das Repo wurde
mit `autocrlf=true` geklont", mit der Anweisung, vor jeder Änderung
`git checkout HEAD -- <datei>` zu rufen. **Das ist nachgemessen falsch** und die
Anweisung damit gegenstandslos:

```
git config core.autocrlf   ->  false
.gitattributes             ->  existiert nicht
```

| Datei | CR im Arbeitsbaum | CR in HEAD |
|---|---|---|
| `Eudora71/Eudora/stdafx.h` | 0 | 0 |
| `Eudora71/Eudora/mainfrm.cpp` | 18 | 18 |
| `Eudora71/Eudora/workbook.cpp` | 18 | 18 |
| `Eudora71/Eudora/utils.cpp` | 118 | 118 |
| `Eudora71/OTShim/OTShim.h` | 1613 | 1613 |
| alle acht Doku-Dateien | 0 | 0 |

Arbeitsbaum und HEAD stimmen also überall überein; es findet keine Umschreibung
beim Auschecken statt. Was tatsächlich vorliegt, ist der **Originalzustand der
Eudora-Quellen**: jede Datei für sich, manche rein LF (`stdafx.h`), manche rein CRLF
(`OTShim.h`), die meisten gemischt (`mainfrm.cpp`: 18 CR auf über 8000 Zeilen).

Die Vorsichtsmaßnahme, die daraus wirklich folgt, steht unter Punkt 3: nicht
vorsorglich auschecken, sondern **byte-erhaltend ändern und die CR-Anzahl danach
gegen HEAD messen**. Ein `git checkout HEAD -- <datei>` vor der Arbeit schadet zwar
nicht, nützt aber auch nichts — und wer es für nötig hält, verwirft womöglich die
Arbeit eines parallel laufenden Agenten.

Für die Markdown-Dateien im Wurzelverzeichnis gilt die Warnung ohnehin nicht: sie
sind durchgehend reines LF, dort ist normales Editieren unbedenklich.

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

## Was noch offen ist

| Thema | Wo es steht |
|---|---|
| Registerkarten und `SECDateTimeCtrl` | `Eudora71/OTShim/PLAN.md`, Abschnitt „Berichtigungen" |
| Prüfbefunde, 1 hoch / 5 mittel / 8 niedrig | `BEFUNDE.md` |
| Vier Altbefunde, drei behoben | `BEFUNDE-ALTBESTAND.md` |
| Verschärfung der Zertifikatsprüfung — liegt bereit, **nicht angewandt** | `tools/patches/zertifikatspruefung-verschaerfen.patch` |
| Hostnamenprüfung greift nicht — bewusst zurückgestellt | `Arbeitsweise/zurueckgestellte-befunde.md` |
| Zeichensatz: Emoji und nichtlateinische Schriften | `PORTIERUNG.md` |

## Wie gearbeitet wird

Die Regeln stehen in [Arbeitsweise/](Arbeitsweise/README.md) — entstanden aus
konkreten Fehlgriffen dieser und der vorigen Sitzung, jede mit belegtem Anlass.
Die drei wichtigsten:

- **Nie stillstehen.** Lange Läufe in den Hintergrund und währenddessen weiterarbeiten.
  Der teuerste Einzelfehler des Projekts war 1 Stunde 46 Minuten Leerlauf.
- **Prüfen statt vermuten.** Zahlen nur nennen, wenn gemessen. Acht Zahlen in der
  Doku waren falsch, weil sie geschätzt und als Tatsache geschrieben wurden.
- **Wissen gehört in Dateien.** Was nur im Gespräch steht, ist beim nächsten
  Abschalten weg.

Prüfung und Dokumentation gehören **ans Ende einer Arbeitswelle**, nicht parallel
dazu — sonst prüfen sie ein bewegliches Ziel. Wie weit sie zurückliegen:

```bash
perl tools/pruefstand-melden.pl
```

## Agenten dieser Sitzung

Zehn Agenten, alle mit deutschem Namen und einer Zieldatei im Repo:

| Name | Auftrag | Ergebnis |
|---|---|---|
| LEISTE | Andockfamilie, Stufe 2 und 2b | `OTShim.h/.cpp`, Plankorrekturen |
| KNOPF | Werkzeugleisten und Knöpfe, Stufe 3 | `OTShim_Werkzeugleiste.*`, 6083 Zeilen |
| BILD | Bilder über GDI+, Stufe 4 | `OTShim_Bild.*` |
| REITER | Registerkarten | `OTShim_Reiter.*`, 2925 Zeilen - geschrieben, nicht eingehaengt |
| PALETTE | `SECDateTimeCtrl` | `OTShim_Palette.*`, 890 Zeilen (`0826be1`) - geschrieben, nicht eingehaengt |
| TABELLE | Zeichentabelle | sieben Fehlzuordnungen behoben, 23/23 Tests |
| WURZEL | Wurzelzertifikate | `Releases/1.0/rootcerts.p7b`, 121 Zertifikate |
| WACHE | Altbefunde | drei behoben, einer als Patch bereitgelegt |
| AUFRAEUMER | Build-Artefakte | 107 Dateien aus dem Index |
| PRUEFER | Korrektheitsprüfung | `BEFUNDE.md` |
| LEKTOR | Doku auf Belegbarkeit | acht falsche Zahlen berichtigt |
| LEHRE | Auswertung des Gesprächsverlaufs | `Arbeitsweise/` |
