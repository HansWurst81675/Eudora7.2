# PRÜFER-23 — E-112 F1/F2 nachgerechnet (`ac8f030`, `c294594`, `11b6a3a`)

Lauf am 13.10.2026, nur lesend. Nichts gebaut, nichts geändert, kein Programm gestartet.
Stand: Zweig `wt/pruefer`, gemergt mit `origin/e-112-skalierung` (`edefd51`).
Gelesen: Quelle, Bauprotokoll `Eudora71/Bin/bauen-Release.log` (Hauptarbeitsbaum,
11:48), Protokoll des Messlaufs `C:\Temp\E112-1085\Mailverzeichnis\eudora.log`
(11:49).

**Urteil: auslieferbar.** F1 und F2 sind richtig umgesetzt, und die fünf
gemessenen Werte passen Zeile für Zeile zur Quelle. Was ich gefunden habe, liegt
**neben** den beiden Änderungen:

* **N1 (mittel, nicht neu, seit 7.2.0.85 sichtbar):** Beim Antworten und
  Weiterleiten macht [E-89](../Intern/BEFUNDE.md#e-89) aus `<img width="1200">` (ohne
  `height`) die vollständige Angabe `width="600" height="1"`. Seit [E-112](../Intern/BEFUNDE.md#e-112) wird
  die Metadatei in genau dieser Größe geschrieben, also erscheint das Bild als
  Strich, 600 × 1 Punkt. F2 kommt dort gar nicht zum Zug.
  `msgutils.cpp:3655-3658` und `:3663-3669`.
* **N2 (niedrig, Vermutung, ungemessen):** Seit F1 hat jedes `<img>` einen
  eigenen Datensatz. Kommt dasselbe Bild zweimal vor, legt Eudora beim
  Speichern bzw. Senden der Editorfassung womöglich auch zwei MIME-Teile an.
* N3 bis N5: niedrig, siehe unten.

---

## 1. F1 — `check_to 0` in `pgNewImageRecord`

### Semantik: „nicht teilen“ — belegt

`PGEMBED.C:1825-1826`:

```c
   if (check_to >= 0)
      num_styles = check_to;
```

Mit `0` wird `num_styles = 0`, und die Suchschleife `:1828` läuft keinen
einzigen Durchgang. `result` bleibt `MEM_NULL`, also legt `:1858-1872` einen neuen
Datensatz an (`used_ctr = 0`, `EMBED_PREPARE_IMAGE` mit genulltem `temp_embed`),
und `:1876-1878` zählt ihn auf 1. Mit `-1` (vorher) bleibt `num_styles` die
Größe von `t_formats`, und gesucht wird über **alle** Stile, verglichen wird
allein die URL (`:1840`). Der Kommentar in `PGHTMIMP.CPP:2075-2083` stimmt
(Zeilenangabe `PGEMBED.C:1840` richtig).

Dass der Fehler vorher **im Teilen** lag, belegt auch `PGHTMIMP.CPP:2085`:
`GetMemoryRecord(image_ref, 0, &image_record)` liest den geteilten Datensatz in
die lokale Kopie zurück, und `source_width/height` des ersten Bildes ersetzen
die eigene Angabe. Daher kam 70×70 als 35×35.

### Freigabe — jeder Datensatz genau einmal, belegt

* Anlegen: `used_ctr` 0 → 1 (`PGEMBED.C:1862`, `:1877`).
* Freigeben: `standard_embed_dispose` (`PGEMBED.C:3058-3076`) zählt herunter.
  Bei 0 werden die Metadatei (`DeleteMetaFile`, `:3098-3101`) und der
  Datensatz (`DisposeMemory`, `:3072`) freigegeben. Ein nicht geteilter
  Datensatz hat genau einen Verweis und wird genau einmal freigegeben. Eine
  doppelte Freigabe sehe ich nicht: der Zähler stimmt in beiden Fällen, ob
  geteilt oder nicht.
* Paige-eigenes Format (Zwischenablage, `PGNATIVE.CPP:80`/`:225`):
  `find_url_ref` (`PGEMBED.C:3682-3703`) vergleicht den `memory_ref`, nicht die
  URL. Eigene Datensätze werden also getrennt gespeichert, und beim Lesen zählt
  `:1406-1420` je Verweis hoch. Das passt.
* Der zweite Aufrufer, `PgNewUrlImageRef` (`PgEmbeddedImage.cpp:1436`), steht
  unverändert auf `-1` (Einfügen beim Verfassen, Emoticons). Der Kommentar in
  `PGHTMIMP.CPP` behauptet nichts anderes.

### Was Nicht-Teilen kostet

* **Speicher und Laden:** je `<img>` eine Metadatei und ein eigener Ladevorgang
  statt einer je URL (`PgLoadUrlImage` → `MetafileFromImage` → `LoadImage`).
  Bei Werbepost mit zwanzigmal derselben `spacer.gif` ist das zwanzigmal
  Dekodieren. Das ist gewollt, denn jede Angabe braucht ihre eigene Metadatei.
  Der Aufwand ist nicht gemessen.
* **`EMBED_PREPARE_IMAGE` läuft jetzt je `<img>`**, vorher einmal je URL
  (`PGEMBED.C:1871`). Für Bilder ohne vollständige Angabe lädt das schon beim
  Import (`PgEmbeddedImage.cpp:265-271`), sobald die Datei auflösbar ist
  (`file://`, `cid:` in einer geöffneten Nachricht). Gemessen: im Lauf
  E112-1085 laufen Banner (`150x0`) und Bild ohne Angabe genau so
  (`faden=0`, Protokollzeilen 222-229), die vollständig bemaßten erst beim
  Zeichnen (`faden=1`, Zeilen 232-245). Zu den Folgen siehe N3.

### Wer sich auf das Teilen verlässt

* `pgInvalEmbedRef`, Löschen eines Bildes, `cid:`-Teile beim Lesen,
  Werbeansicht: **keine Abhängigkeit gefunden.** Der Ladezustand
  (`image_data`, `loader_result`) gehört zum Datensatz, und das Zeichnen fragt
  je Datensatz (`PGEMBED.C:2521-2532`).
* **Speichern/Senden: möglicherweise doch, siehe N2.**

### „Paige32.dll wird nicht gebaut“ — belegt

* `Eudora71/Eudora.sln`: kein Eintrag mit „paige“ (grep, 0 Treffer).
* `bauen-Release.log`: 19 Projekte, keines davon Paige. `PGEMBED.C` bzw.
  `PGEMBED.obj` kommen 0-mal vor, `PGHTMIMP.obj` einmal.
* Verlinkt wird gegen das mitgelieferte `Lib/Release/Paige32.lib`
  (`Eudora.vcproj:114`).
* `PGEMBED.C` ist vollständig zurückgenommen: `git diff dae6727^ HEAD --
  PGEMBED.C` ist leer.
* Siehe aber N4: die eingecheckte `Paige32.dll` hat sich in `b1ed24f` trotzdem
  geändert, allerdings nicht im Code.

---

## 2. F2 — Angabe aus `source_*`, Zielrechteck zurück nach `source_*`

### Trägt `source_*` vor dem Laden die HTML-Angabe?

| Weg | `source_*` vor `MetafileFromImage` | Beleg |
|---|---|---|
| Lesen, HTML-Import | Attribute `width`/`height` | `PGHTMIMP.CPP:2059-2062` |
| Antworten/Weiterleiten ([E-89](../Intern/BEFUNDE.md#e-89)) | Attribute des **umgeschriebenen** HTML, gleicher Import | `summary.cpp:1531` → `msgutils.cpp:3739-3742` → `PGHTMIMP.CPP:2059` — **aber siehe N1** |
| Zweitladen desselben Datensatzes | das Zielrechteck des ersten Ladens | `PgEmbeddedImage.cpp:574-578` |
| `PgNewUrlImageRef` (Verfassen, Emoticon) | `0,0` von allen drei Aufrufern | `PgEmbeddedImage.cpp:166`, `:186`, `:245`, `:1417-1418` |
| Bild aus Zwischenablage-Bitmap | Bitmapgröße, `image_data` schon gesetzt → kein Laden | `:1630-1631`, `:278` |
| Paige-Strom (Einfügen) | der gespeicherte Wert, also das Zielrechteck | `PGEMBED.C:3889-3890` |
| Threaded Fetch (http) | unverändert, bis die Datei da ist; überschrieben wird nur im Erfolgszweig | `:574-578` liegt in `if (MetafileFromImage…)` |
| QuickTime-Zweig | nicht angefasst, liest weiter `source_*` als Vorgabe | `:596-608` |
| Fehlerpfad (`MetafileFromImage` false) | unverändert | `:544` |
| keine Datei | ganzer Block übersprungen | `:525` (`if ( *filePath )`) |

**Zweitladen ist unschädlich, nachgerechnet:** Nach dem ersten Laden ist
`source_*` immer eine **vollständige** Angabe (Zielrechteck, beide Seiten > 0,
`:574`), und `E112Zielrechteck` gibt eine vollständige Angabe unverändert
zurück (`:381-386`). Ein zweiter Lauf liefert also dasselbe Rechteck und dieselbe
Metadatei. Das gilt auch für einen gespeicherten und wieder gelesenen
Paige-Strom (`PGEMBED.C:3845-3846` → `:3889-3890`): aus dem Zielrechteck wird
dasselbe Zielrechteck. Für Bilder **ohne** Angabe hat QUALCOMM `source_*` schon
immer mit der Dateigröße überschrieben (`:581-584`). F2 dehnt diese Bedeutung,
„`source_*` = Anzeigegröße nach dem Laden“, auf die halbe Angabe aus, eine neue
Klasse ist es nicht.

**Entwurf/Antwort als HTML:** Der Export schreibt `embed->width/height`, nicht
`source_*` (`PGHTMEXP.CPP:963-968`). Eine halbe Angabe kommt danach als
vollständige zurück (`width="150" height="58"`), wie im Browser. Das ist
folgerichtig.

### Zusammenspiel mit dem E-103- und dem E-106-Block — stimmt

* Halbe Angabe, Laden beim Zeichnen (http, ungemessen): `embed` ist nach dem
  Import 0×0, weil das Rechteck leer ist (`PGEMBED.C:3439-3440`, `:3507-3511`).
  Der E-103-Block (`PgEmbeddedImage.cpp:616-626`) setzt `embed` und
  `pict_frame` auf `source_*` = 150×58. Danach läuft der E-106-Block (`:805`),
  weil 378 > 58: `E112Zielrechteck(150, 58, …)` (`:906`) gibt 150×58 zurück,
  also dieselben Werte, und `pgInvalEmbedRef` läuft ein zweites Mal (N5).
* Halbe Angabe, Laden schon beim Import (`cid:`, gemessen): Laden bei
  `PREPARE`. `source_*` wird zu 150×58, `PGHTMIMP.CPP:2085` liest das zurück
  (`E-95 Bild: attr=150x58 embed=150x58 ascent=58`, Protokollzeile 229), und
  `pgNewEmbedRef` bekommt ein volles Rechteck. Beim Zeichnen ist `image_data`
  gesetzt, es wird nicht noch einmal geladen (`PgEmbeddedImage.cpp:278`).
* Vollständige Angabe: `embed` hat sie schon vom Import, der E-103-Block läuft
  nicht, der E-106-Block setzt dieselben Werte noch einmal.
* Datei kleiner als die halbe Angabe (`width=600` bei 300×86): `embed` wird
  600×172, der E-106-Block läuft nicht (86 < 172). Es wird vergrößert, wie im
  Browser.
* `MetafileFromImage` (`QCGraphics.cpp:173-180`) rechnet mit **derselben**
  Funktion und denselben Eingaben (`nAngabeB/H`, Dateigröße). Metadatei,
  Spurmarke und `source_*` können also nicht auseinanderlaufen, und
  `mfi.width/height` bleibt die Dateigröße (`:190-191`).

---

## 3. Die Messung gegen die Quelle

Protokoll `C:\Temp\E112-1085\Mailverzeichnis\eudora.log`, Zeilen 219-245:

| angegeben | Datei | erwartet laut Quelle | gemessen | |
|---|---|---|---|---|
| 35×35 | 330×327 | 35×35 (`:381-386`) | `gemalt=35x35` (232) | passt |
| 70×70, gleiche `cid:gross` | 330×327 | 70×70, eigener Datensatz | `gemalt=70x70` (243) | passt, F1 wirkt |
| 250×96 | 985×378 | 250×96 | `gemalt=250x96` (240) | passt |
| 150×0, gleiche `cid:banner` | 985×378 | (150·378 + 492) / 985 = 57192 / 985 = **58** | `gemalt=150x58` (226), `embed=150x58 ascent=58` (229) | passt, F2 wirkt |
| 0×0 | 79×64 | 79×64 (`:405-411`) | `gemalt=79x64` (222) | passt |

Die Reihenfolge der Ladewege passt ebenfalls zur Quelle: halbe und fehlende
Angabe beim Import (`faden=0`), vollständige beim Zeichnen (`faden=1`).

---

## Funde

### <a id="n1"></a>N1 (mittel, nicht neu, seit 7.2.0.85 sichtbar): E-89 erzeugt bei breitem Bild ohne Höhe `height="1"`

`msgutils.cpp:3633-3645`: Breite bekannt, Höhe nicht. Die Ausführung läuft
weiter (das hat [P-36](PRUEFER-14.md) schon angemerkt). In den Deckel,
`:3654-3661`:

```c
		if (!bProzB && nBreite > E89_MAX_BREITE)
		{
			nHoehe = (int) (((double) nHoehe * E89_MAX_BREITE) / (double) nBreite);
			if (nHoehe < 1)
				nHoehe = 1;
```

Mit `nHoehe == 0` ergibt die Rechnung 0, und daraus wird **1**. `:3741` schreibt
dann `height="1"`, weil 1 > 0. Aus `<img width="1200">` wird
`width="600" height="1"`, eine **vollständige** Angabe. Seit [E-112](../Intern/BEFUNDE.md#e-112) malt
`E112MetadateiAusDIB` genau 600×1 (`QCGraphics.cpp:154-156`): das Bild wird zum
Strich. Gegenrichtung `:3663-3669`: bei nur `height="900"` wird aus der
Breite 0 die Breite 1, also `width="1" height="600"`.

Betroffen ist das Verfassenfenster beim Antworten und Weiterleiten
(`summary.cpp:1531`). Nach [E-88](../Intern/BEFUNDE.md#e-88) geht beim Senden das
Original hinaus, der Empfänger sieht es also vermutlich nicht. Gregor sieht es
aber im Editor. Vor 7.2.0.85 wurde das Bild in Dateigröße gemalt und blieb
lesbar. **F2 ist für genau diesen Fall gebaut**, die halbe Angabe, und kommt
nicht zum Zug, weil [E-89](../Intern/BEFUNDE.md#e-89) sie vorher zu einer falschen vollständigen macht.

**Ungemessen:** Kein Test deckt das ab. `TestE89.cpp` hat nur 1200×600 (`:131-143`).
Das Ergebnis ist aus der Quelle gerechnet und nicht am Prüfstand gefahren.

**Vorschlag:** Im Deckel nur die bekannte Seite anfassen. Ist `nHoehe <= 0`, wird
nur `nBreite` auf `E89_MAX_BREITE` gesetzt und die Höhe bleibt 0. Den Rest
erledigt F2, im richtigen Verhältnis. Ebenso für die Breite. Test zuerst:
`<img src="x.png" width="1200">` → erwartet `width="600"` und **kein**
`height`. Gegenprobe mit 1200×600 → 600×300, wie bisher.

### <a id="n2"></a>N2 (niedrig, Vermutung, ungemessen): F1 kann beim Speichern doppelte MIME-Teile erzeugen

`PGHTMEXP.CPP:952-956` ruft `EMBED_SAVE_IMAGE` **je Embed** für `file:`-URLs
und für alle URLs ohne bekanntes Schema. `cid:` steht nicht in
`IDS_URL_SCHEMES` (`EudoraRes.rc:10828`: `file:ftp:http:https:mailto:news:nntp:rtsp:tel:telnet:x-eudora-option:`),
also wird es auch für `cid:` gerufen. `PgSaveUrlImage` schreibt die neue CID **in
den Datensatz** zurück (`PgEmbeddedImage.cpp:1091-1092`).

* **Vorher (geteilt):** Nach dem ersten Embed trug der gemeinsame Datensatz
  schon die neue CID, und das zweite Embed sah keine `file:`-URL mehr
  (`make_it_schmookie` statt `make_new_part_from_file`).
* **Jetzt (getrennt):** Jedes `<img src="file://…">` ruft
  `make_new_part_from_file` (`:1072` → `AddPart`, `MimeStorage.cpp:189-204`, ohne
  Prüfung auf denselben Pfad). Dasselbe Bild zweimal ergibt zwei Teile. Bei
  `cid:` kopiert `make_it_schmookie` je Datensatz (`:1311-1389`). Ob der
  geteilte Fall vorher wirklich nur **einen** Teil übrig ließ, hängt an
  `IsRealCID` der neuen CID und an der Aufräumlogik in `PgMsgView::SaveInfo`.
  Das habe ich nicht verfolgt.

Dazu kommt, dass nach [E-88](../Intern/BEFUNDE.md#e-88) beim Senden womöglich gar nicht die Editorfassung
hinausgeht. **Messvorschlag:** die Prüfnachricht
`Testdaten/e112-bilder-groesser-als-angegeben.eml` (zweimal `cid:gross`, zweimal
`cid:banner`) weiterleiten, als Entwurf speichern bzw. in die Warteschlange
legen, dann die `Content-ID`-Teile im Ausgang und die Dateien in `Embedded\`
zählen. Gegenprobe ist derselbe Lauf an 7.2.0.85.

### <a id="n3"></a>N3 (niedrig, Restrisiko, durch F1 häufiger): der E-103-Block läuft auch beim `PREPARE` mit dem flüchtigen Embed

Der Block `PgEmbeddedImage.cpp:616-700` hat **keine** Schranke
`bAllowThreadedFetch`, anders als der E-106-Block (`:805`, [E-107](../Intern/BEFUNDE.md#e-107)). Beim
`PREPARE` ist `embed` der genullte `temp_embed` (`PGEMBED.C:1867`), also
`embed->style == NULL`. Die Suche `:658-670` vergleicht `embed->style ==
embed_ptr->style`, und ein ruhendes Embed hat `style == NULL`
(`PGEMBED.C:1183`, `:2287`, `:2394`). Ist schon ein Embed im Dokument, trifft
die Suche womöglich das **erste**, und `pgInvalEmbedRef` (`:699`, `PGEMBED.C:914-934`)
setzt dessen Zeilenhöhe auf die Höhe des neuen Bildes.

**Gemessen, entlastend:** Im Lauf E112-1085 steht beide Male `gefunden=0 pos=0
style=0` (Protokollzeilen 223, 227), obwohl schon drei Embeds importiert waren
(219-221). Vermutlich ist `t_length` während des Imports noch 0. Das habe ich
nicht nachgeprüft. Der Fehler ist nicht neu (QUALCOMM-Code, schon bei [E-107](../Intern/BEFUNDE.md#e-107)
angemerkt). F1 vervielfacht nur die `PREPARE`-Läufe: einer je `<img>` statt
einer je URL. **Vorschlag, billig:** `bAllowThreadedFetch &&` auch vor den
Suchlauf in `:658` setzen. Das `embed`-Setzen davor darf bleiben, weil es nur
den flüchtigen Embed trifft.

### <a id="n4"></a>N4 (niedrig, Hygiene): Der Merge `b1ed24f` checkt sieben geänderte DLLs ein

`git show --stat b1ed24f`: `Bin/Release/{DirServ,EuMemMgr,EudoraBk,ISock,Ldap,Paige32,Ph}.dll`.
Diese Änderung stammt aus **keinem** der beiden Eltern: alle drei Stände von
`Paige32.dll` vor dem Merge sind `50c6549`, danach `bd66a1b`. Bei
`Paige32.dll` gemessen: 6 Byte verschieden, nämlich die PE-Prüfsumme
(`0x158-0x15B`) und 3 Byte bei `0x2D9-0x2DB` hinter der Abschnittstabelle.
Der Zeitstempel ist unverändert der 14.10.2005, der Code ist gleich. Das
bestätigt nebenbei, dass Paige nicht neu übersetzt wird. Es verstößt aber gegen
„nur Quelldateien stagen“, und der Merge auf `main` trägt es mit. Die anderen
sechs DLLs habe ich nicht verglichen.

### <a id="n5"></a>N5 (niedrig): Doppelte Arbeit und theoretischer Überlauf

* http mit halber Angabe: Der E-103- und der E-106-Block laufen beide und rufen
  zweimal `pgInvalEmbedRef` mit denselben Werten (`:699`, `:921`). Das ist
  harmlos, aber zweimal die Suche über alle Embeds. Ungemessen, denn die
  Prüfnachricht nutzt nur `cid:`.
* `(short) nGemaltB/H` (`:576-577`): Bei extremem Seitenverhältnis kann die
  ergänzte Seite 32767 übersteigen (z. B. `width=3000` bei 100×2000 → 60000)
  und negativ werden. Das ist nur theoretisch.

---

## Ergebnis

| Frage | Antwort |
|---|---|
| `check_to 0` = nicht teilen? | **ja**, `PGEMBED.C:1825-1826` |
| Freigabe korrekt, keine doppelte? | **ja**, `PGEMBED.C:3058-3076`, `used_ctr` 1 → 0 |
| Abhängigkeiten vom Teilen | Ladezustand, Löschen, Werbeansicht: keine. Speichern/Senden: möglich (N2, ungemessen) |
| Paige32.dll nicht gebaut | **belegt** (Projektmappe, Bauprotokoll, Byte-Vergleich N4) |
| `source_*` trägt vor dem Laden die Angabe | ja, auf allen Wegen. Beim Antworten aber die von [E-89](../Intern/BEFUNDE.md#e-89) **verfälschte** (N1) |
| Überschreiben von `source_*` schädlich? | nein, nachgerechnet idempotent, auch über Paige-Strom und Export |
| [E-103](../Intern/BEFUNDE.md#e-103)/[E-106](../Intern/BEFUNDE.md#e-106)/`E112Zielrechteck` zusammen | stimmt; doppelte Invalidierung bei http (N5) |
| Messung passt zur Quelle | **ja**, alle fünf Werte, auch die Rundung 57,56 → 58 |
