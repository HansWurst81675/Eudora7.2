# Testplan für Gregor — Stand 14.10.2026 (Teil A, C1, C2, E-83, E-85, E-93 erledigt; E-101 durchgefallen; E-95/E-96 offen; C4 erledigt: E-112, E-103, E-115 an 1.0.86, E-117 an 1.0.87 bestätigt); 1.0.85 bis 1.0.87 liegen bei Gregor, 1.0.87 ist als `v1.0.87` veröffentlicht; getestet wurde an 1.0.84, 1.0.86 und 1.0.87

Was hier steht, ist aus dem Baum gemessen, nicht erinnert: die Maskenbits aus
`QCUtils/public/inc/debug.h`, die vorhandenen Spurmarken aus den Quelltexten
(`git ls-files … | grep '"E-nn'`), die Urteilszeilen aus `BEFUNDE.md`.

**Wichtig vorweg:** für **[E-49](BEFUNDE.md#e-49) bis [E-63](BEFUNDE.md#e-63)** gibt es **keine** Spurmarken im
Protokoll. Nachgezählt: Marken existieren zu [E-27](BEFUNDE.md#e-27), [E-33](BEFUNDE.md#e-33), [E-34](BEFUNDE.md#e-34), [E-35](BEFUNDE.md#e-35), [E-37](BEFUNDE.md#e-37),
[E-40](BEFUNDE.md#e-40) bis [E-46](BEFUNDE.md#e-46), [E-64](BEFUNDE.md#e-64), [E-66](BEFUNDE.md#e-66), [E-68](BEFUNDE.md#e-68) bis [E-70](BEFUNDE.md#e-70), [E-72](BEFUNDE.md#e-72), [E-73](BEFUNDE.md#e-73), [E-76](BEFUNDE.md#e-76), [E-78](BEFUNDE.md#e-78) bis [E-80](BEFUNDE.md#e-80),
[E-83](BEFUNDE.md#e-83), [E-86](BEFUNDE.md#e-86) bis [E-89](BEFUNDE.md#e-89), [E-95](BEFUNDE.md#e-95), [E-97](BEFUNDE.md#e-97), [E-101](BEFUNDE.md#e-101), [E-103](BEFUNDE.md#e-103), [E-104](BEFUNDE.md#e-104), [E-106](BEFUNDE.md#e-106), [E-110](BEFUNDE.md#e-110) — **zu
keinem der vierzehn**. Teil A ist also reine Augenprüfung. Das Protokoll hilft
nur bei Teil B und C.

---

## 0. Vorbereitung

In die `Eudora.ini` deines Testverzeichnisses, Gruppe **`[Debug]`** —
**nicht** `[Settings]`. Eudora ordnet jeden Schlüssel allein nach seiner
Nummer zu (`rs.cpp:89`, `GetSectionID`); `LogLevel` ist 10802 und liegt damit
zwischen 10800 und 10900.

```ini
[Debug]
LogLevel=124063
```

| Wert | was dazukommt |
|---|---|
| `25759` | die Vorgabe |
| `58527` | **+ 32768** = `DEBUG_MASK_MISC` — **alle `E-nn`-Marken** |
| `124063` | **+ 65536** = `DEBUG_MASK_ATTACH` — die **`ANHANG`**-Marken ([AN-1](BEFUNDE.md#an-1)) |
| `128159` | **+ 4096** = `DEBUG_MASK_PLIST` — der Werbeweg; seit dem 13.10.2026 **nicht mehr nötig** (siehe C2) |

Geschrieben wird nach **`eudora.log`** im Eudora-Verzeichnis. Die Einstellung
wirkt beim **nächsten Start**.

**Welche Eingabeaufforderung.** Alle `grep`-Zeilen unten setzen **Git Bash**
voraus. In `cmd` heißt es `findstr`, in der PowerShell `Select-String`:

| Git Bash | cmd | PowerShell |
|---|---|---|
| `grep ANHANG eudora.log` | `findstr ANHANG eudora.log` | `Select-String ANHANG eudora.log` |
| `grep "E-78\|E-70" eudora.log` | `findstr "E-78 E-70" eudora.log` | `Select-String "E-78\|E-70" eudora.log` |
| `ls attach` | `dir attach` | `Get-ChildItem attach` |

`perl` gibt es nur dort, wo es im Pfad steht — in `cmd` meist nicht, in Git
Bash schon.

**Vorher wegsichern:** `copy eudora.log eudora.log.vorher` — dann ist später
klar, welche Zeilen aus diesem Durchgang stammen.

---

## Teil A — Die vierzehn aus 7.2.0.26 bis 7.2.0.30 (Augenprüfung)

**Alle vierzehn sind seit dem 13.10.2026 von Gregor an 1.0.84 bestätigt** —
die Urteile mit Zitat stehen in `BEFUNDE.md`. Bis dahin standen sie dort als
„von Gregor noch nicht bestätigt"; der Plan bleibt als Anleitung für einen
späteren Rückfalltest stehen.
Acht davon siehst du sofort, sechs merkst du nur, wenn etwas hängt.

### Sichtbar — hier entscheidet dein Auge

| | Befund | Handgriff | richtig ist |
|---|---|---|---|
| ✅ | [**E-49**](BEFUNDE.md#e-49) (A-4) | Maus auf die Kante zwischen linkem Bereich und Nachrichtenliste | Zeiger wird zum **Größenzeiger** |
| ✅ | [**E-49**](BEFUNDE.md#e-49) | nach rechts ziehen | linker Bereich wird **breiter**, Nachrichtenbereich gibt nach |
| ✅ | [**E-49**](BEFUNDE.md#e-49) | weiter als 180 Pixel ziehen | geht — das war deine eigentliche Bitte |
| ✅ | [**E-49**](BEFUNDE.md#e-49) | Eudora beenden und neu starten | die Breite ist **noch da** (landet im `[ToolBar…]`-Abschnitt der `Eudora.ini`) |
| ✅ | [**E-52**](BEFUNDE.md#e-52) | nach dem Verbreitern noch einmal am Balken ziehen | Balken ist **weiter greifbar**, Karten stehen **nicht doppelt** |
| ✅ | [**E-54**](BEFUNDE.md#e-54) | beim Ziehen **nach rechts** hinsehen | der **Ziehrahmen ist sichtbar** — man zieht nicht ins Blinde |
| ✅ | [**E-55**](BEFUNDE.md#e-55) | unter die Werkzeugleiste sehen | **kein** acht Pixel hoher leerer Streifen |
| ✅ | [**E-50**](BEFUNDE.md#e-50) (1) | ein Fenster öffnen, in ein anderes wechseln | die Karte des **verlassenen** Fensters ist **nicht mehr eingedrückt** |
| ✅ | [**E-50**](BEFUNDE.md#e-50) (2) | Hauptfenster in der Größe ziehen | der Kartenstreifen wird **richtig** gezeichnet |
| ✅ | [**E-50**](BEFUNDE.md#e-50) (3) | Fenster öffnen und schließen | die Karten sind **nicht weg** |
| ✅ | [**E-53**](BEFUNDE.md#e-53) | ein Fenster schließen | an der Stelle der Karte bleibt **kein Strich** stehen |
| ✅ | [**E-58**](BEFUNDE.md#e-58) | in den **rechten Rand** des Kartenstreifens klicken, wo nichts steht | es öffnet sich **kein Browser** |
| ✅ | [**E-63**](BEFUNDE.md#e-63) | mit der Maus über die **letzte** Registerkarte fahren | ein **Kurzhinweis** erscheint, wie bei den anderen |
| ✅ | [**E-56**](BEFUNDE.md#e-56) | *Show MDI task bar* **abschalten** | der Kartenstreifen **verschwindet** |

### Nicht sichtbar — nur „ist etwas passiert?"

Diese sechs sind PRÜFER-Funde im selben Code. Du kannst sie nicht gezielt
auslösen; sie gelten als durchgelaufen, wenn beim Obigen **nichts** abstürzt
und **nichts** hängenbleibt.

| | Befund | was es war |
|---|---|---|
| ✅ | [**E-57**](BEFUNDE.md#e-57) | `IsTabLabelTruncated` legte bei **jeder Mausbewegung** eine `CPaintDC` an |
| ✅ | [**E-59**](BEFUNDE.md#e-59) | `m_cxTab` wurde **nur in `OnPaint`** gesetzt |
| ✅ | [**E-60**](BEFUNDE.md#e-60) | ein Trennbalken konnte **während des Ziehens gelöscht** werden |
| ✅ | [**E-61**](BEFUNDE.md#e-61) | `Splitter::Track` **verschluckte `WM_QUIT`** |
| ✅ | [**E-62**](BEFUNDE.md#e-62) | **sieben** Nachrichtenschleifen verschluckten `WM_QUIT`, zwei mit Hängegefahr |

**Die Probe auf [E-61](BEFUNDE.md#e-61)/[E-62](BEFUNDE.md#e-62):** nach dem Ziehen **Alt+F4** drücken. Eudora muss
sich beenden. Bleibt es stehen, ist einer der beiden wieder da.

---

## Teil B — Was das Protokoll beisteuern kann

Zu den vierzehn selbst: **nichts**. Aber im selben Bereich liegen Marken, die
den Rahmen belegen:

```
grep "E-78\|E-70\|E-66\|E-76\|E-44\|E-43" eudora.log
```

| Marke | sagt |
|---|---|
| [`E-78`](BEFUNDE.md#e-78) | je Leiste Kennung, Andockseite, Sichtbarkeit und Stil — **vor und nach** `SetDockState` |
| [`E-70`](BEFUNDE.md#e-70) | `gesichert:` und `geladen:` je Leiste mit `cx`/`cy` **vorher und nachher**. Damit ist nachweisbar, ob deine gezogene Breite wirklich in die INI geht und zurückkommt |
| [`E-44`](BEFUNDE.md#e-44) | *„für N Leiste(n) war keine Lage gespeichert"* — erscheint, wenn der `[ToolBar…]`-Abschnitt fehlt |
| [`E-43`](BEFUNDE.md#e-43) | `SaveCustomInfo` mit dem INI-Abschnitt, in den geschrieben wird |
| [`E-66`](BEFUNDE.md#e-66) | Ziehen am Greifrand: Zeigerwechsel, Streifenlage, Bewegung, `Anwenden` mit Maßen |
| [`E-76`](BEFUNDE.md#e-76) | Größenänderung einer schwebenden Leiste mit Maßen vorher/nachher |

**Zahlen statt Augenmaß** für die Breite aus Schritt 3:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools\leisten-messen.ps1 -Pfadfilter 'C:\Users\Gregor\Eudora72-1.0.84-release'
```

Einmal **vor** dem Ziehen, einmal **danach**. Der `-Pfadfilter` ist Pflicht,
sonst misst das Werkzeug auch dein echtes Eudora.

---

## Teil C — Die frischen Behebungen

### C1 · AN-1 — Anhangnamen (`LogLevel=124063`)

```
perl tools\anhang-pruefdaten.pl --pop
```

Konto in `[Settings]`: `POPAccount=pruef@127.0.0.1`, `LoginName=pruef`,
`POPPort=11110`, `SSLReceiveUse=0`, Kennwort beliebig. Abrufen, dann:

```
grep ANHANG eudora.log
dir attach
```

| | muss sein |
|---|---|
| ✅ | **alle sechs** Dateien mit **vollem Namen und `.pdf`** |
| ✅ | im Log je Nachricht eine Zeile `ANHANG Datei: WIRD GESCHRIEBEN ALS` |

**Schon an 7.2.0.84 gemessen, 12.10.2026:** Fälle 00–05 in `C:\Temp\E94-nachher` unverändert heil, alle sechs mit vollem Namen und `.pdf` (CHANGELOG 7.2.0.84). Für dich nur eine Gegenprobe, kein offener Punkt.

### C2 · AN-2 — kein JavaScript mehr in der Anzeige

**Erledigt am 13.10.2026:** von Gregor an 1.0.84 bestätigt. Bis dahin stand
hier, eine **frische** `Eudora.ini` bringe das Werbefenster zurück — das ist
**widerlegt**: dieser Bau startet mit `Mode=2` (Pro, ohne Werbung), und auch
mit `Mode=0` kam an 1.0.84 kein Abruf ([AN-2](BEFUNDE.md#an-2),
[L-27.4](Befunde/LEKTOR-27.md#l-27.4)). Geprüft wird nur noch der Newsletter.

| | muss sein |
|---|---|
| — | **entfällt** (Gregor 13.10.2026): das Werbefenster kommt in diesem Bau nicht mehr, siehe [AN-2](BEFUNDE.md#an-2) |
| ✅ | dasselbe bei einem HTML-Newsletter: **kein** CSS im Nachrichtentext |

*(Der Werbeweg ist an diesem Bau nicht auslösbar; die frühere Zeile zu
`LogLevel=128159` und `grep "PLIST\|E-7"` entfällt mit ihm.)*

### C3 · Die sechs, die auf dein Urteil warteten — offen sind noch zwei

**Stand 13.10.2026:** [E-85](BEFUNDE.md#e-85) und [E-93](BEFUNDE.md#e-93) bestätigt, [E-83](BEFUNDE.md#e-83) nachgemessen,
[E-101](BEFUNDE.md#e-101) durchgefallen (wieder offen). **Offen sind [E-95](BEFUNDE.md#e-95) und [E-96](BEFUNDE.md#e-96).**

**Berichtigt am 12.10.2026 (LEKTOR, [L-18.5](Befunde/LEKTOR-26.md#l-18.5)):** hier standen *fünf*. `BEFUNDE.md` führt
**fünfzehn** Behebungen als „von Gregor noch nicht bestätigt" — vierzehn davon
in Teil A, und eine, die in keinem Teil dieses Plans vorkam: [**E-101**](BEFUNDE.md#e-101), die
unbrauchbare gespeicherte Datei. Ausgerechnet die aus der Datenverlustklasse.

| | Befund | Handgriff |
|---|---|---|
| ❌ | [**E-101**](BEFUNDE.md#e-101) | eine **weitergeleitete** Nachricht über *File → Save As* sichern und die `.eml` in einem anderen Programm öffnen — sie muss lesbar sein (`Content-Type`, `MIME-Version`, kein `<x-html>`) |
| ✅ | [**E-85**](BEFUNDE.md#e-85) | eine Nachricht mit Umlauten **über IMAP** abrufen — Umlaute richtig? |
| ✅ | [**E-83**](BEFUNDE.md#e-83) | Eudora normal beenden — es endet wirklich, kein Prozess bleibt |
| ✅ | [**E-93**](BEFUNDE.md#e-93) | eine **bereits weitergeleitete** Nachricht noch einmal weiterleiten — Inhalt vollständig? |
| ☐ | [**E-95**](BEFUNDE.md#e-95) | die **Doctolib**- und die **FairToner**-Nachricht je beantworten und weiterleiten — kein Bild abgeschnitten oder gequetscht, Text frei ([L-33.4](Befunde/LEKTOR-33.md#l-33.4)) |
| ☐ | [**E-96**](BEFUNDE.md#e-96) | dasselbe mit mehreren Bildern hintereinander |

**[E-97](BEFUNDE.md#e-97) und [E-99](BEFUNDE.md#e-99) gehören nicht hierher** — die hast du am 17.09.2026 schon
bestätigt (*„gespeichert. funktioniert."* / *„ja, kein datenverlust!"*).

### <a id="c4"></a>C4 · Die Pakete 1.0.85 bis 1.0.87 — alle bestätigt

**Stand 14.10.2026 ([LEKTOR-32](Befunde/LEKTOR-32.md#lektor-32)).** 1.0.85, 1.0.86 und 1.0.87 liegen als
Testverzeichnis bei dir; alle vier Befunde sind bestätigt, [E-117](BEFUNDE.md#e-117) am 14.10.2026 an 1.0.87.
1.0.87 ist am 14.10.2026 als `v1.0.87` veröffentlicht.

| | Befund | Paket | Handgriff |
|---|---|---|---|
| ✅ | [**E-112**](BEFUNDE.md#e-112) | 1.0.86 | die Kleinanzeigen-Nachricht weiterleiten — das Logo steht **über** „Deine Anzeige wird weniger gesehen“, nicht darauf, und in der angegebenen Größe (*„paßt dagegen“*) |
| ✅ | [**E-103**](BEFUNDE.md#e-103) | 1.0.86 | dieselbe Prüfung — kein Bild auf dem Text |
| ✅ | [**E-115**](BEFUNDE.md#e-115) | 1.0.86 | ein IMAP-Postfach öffnen, dann Ctrl+F — keine Meldung „Encountered an improper argument“ (*„tritt bisher nicht mehr auf“*; vorläufig, der Fehler war sporadisch) |
| ✅ | [**E-117**](BEFUNDE.md#e-117) | 1.0.87 | die eBay-Nachricht (Synology, „Der Countdown läuft!“) weiterleiten oder beantworten — unter der Überschrift steht das **Foto**, keine leere Fläche (bestätigt 14.10.2026, Bildschirmfoto, *„so?“*). Mit `LogLevel=58527` (wie bei dir eingestellt) nennt die Spurmarke `E-110 Laden: src=…` die Adresse mit `&`, nicht mit `&amp;` |

---

## Teil D — Wie dein Urteil ins Repo kommt

Ein Urteil zählt nur mit **Paketnummer**. Ohne sie ist es wertlos — das ist
die Lehre aus [**E-85**](BEFUNDE.md#e-85): dort stand „behoben" einen Tag lang da, während das
damals ausgelieferte Paket den Fehler noch hatte. Welches das war, steht in
`BEFUNDE.md` unter [E-85](BEFUNDE.md#e-85); hier steht die Nummer bewusst nicht, damit dieser
Satz nicht eines Tages als Standangabe gelesen wird.

Es genügt eine Zeile je Befund, etwa:

```
1.0.84: E-49 ja (auch ueber 180 und nach Neustart), E-50 ja, E-52 nein -
        Balken wieder weg nach dem zweiten Ziehen
```

Daraus trage ich die Urteilszeilen in `BEFUNDE.md` nach und ziehe die
Überschriften in `AUFGABEN.md`, `WEITERMACHEN.md` und `CHANGELOG.md` mit.

**Ein „nein" ist genauso wertvoll wie ein „ja"** — es ist der einzige Weg,
wie ein Rückfall überhaupt auffällt.
