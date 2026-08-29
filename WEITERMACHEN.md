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

| Stufe | Inhalt | Stand |
|---|---|---|
| 0–2, 2b | Workbook, MDI, Statusleiste, Andockfamilie | **fertig**, eingehängt |
| 3 | Werkzeugleisten, Knöpfe, dazu `CSafetyPalette`/`CPaletteDC` | **fertig**, noch **nicht** eingehängt |
| 4 | Bilder über GDI+ | **fertig**, eingehängt |
| Registerkarten | `SEC3DTabControl` und Verwandte | offen — Agent REITER war dran |
| `SECDateTimeCtrl` | Datumsfeld der Suche | offen — Agent PALETTE war dran |

Gemessener Fortschritt am Linker:

| Zustand | ungelöste Symbole |
|---|---|
| ohne Ersatzschicht | 1088 (651 verschiedene) |
| nach Stufe 0–2 und 4 | ~299 |
| nach Stufe 3 | ~141 erwartet, **noch nicht gemessen** |

## Der nächste Schritt, konkret

**Stufe 3 einhängen.** Sie ist gebaut und geprüft, aber `OTShimAll.h` bindet sie
noch nicht ein. Zu tun:

1. In `Eudora71/OTShim/OTShimAll.h` nach `#include "OTShim.h"` und **vor**
   `#include "OTShim_Bild.h"` die Zeile ergänzen:
   `#include "OTShim_Werkzeugleiste.h"`
   Reihenfolge ist wichtig: Stufe 3 baut auf `SECControlBar` und
   `SECControlBarManager` aus Stufe 2 auf.
2. `Eudora71/OTShim/OTShim_Werkzeugleiste.cpp` in `Eudora.vcxproj` aufnehmen, ohne
   vorkompilierten Header — wie die anderen Shim-Dateien in Zeile 217.
3. Bauen und die Symbolzahl messen.

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

**2. Der Arbeitsbaum liegt in CRLF, HEAD in LF.**
Das Repo wurde mit `autocrlf=true` geklont. Jede Datei, die man anfasst und stagt,
meldet deshalb „Zeilenenden verändert" — auch bei sauberer Arbeit. Deshalb **vor
jeder Änderung an einer bestehenden Datei**:

```bash
git checkout HEAD -- <datei>
```

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
| REITER | Registerkarten | offen |
| PALETTE | `SECDateTimeCtrl` | offen |
| TABELLE | Zeichentabelle | sieben Fehlzuordnungen behoben, 23/23 Tests |
| WURZEL | Wurzelzertifikate | `Releases/1.0/rootcerts.p7b`, 121 Zertifikate |
| WACHE | Altbefunde | drei behoben, einer als Patch bereitgelegt |
| AUFRAEUMER | Build-Artefakte | 107 Dateien aus dem Index, 34,7 MB |
| PRUEFER | Korrektheitsprüfung | `BEFUNDE.md` |
| LEKTOR | Doku auf Belegbarkeit | acht falsche Zahlen berichtigt |
| LEHRE | Auswertung des Gesprächsverlaufs | `Arbeitsweise/` |
