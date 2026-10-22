# PRÜFER-22 — E-112 nachgerechnet (`a36c47f`, 7.2.0.85)

Lauf am 13.10.2026, nur lesend. Nichts gebaut, nichts geändert, kein Programm gestartet.
Stand: Zweig `wt/pruefer` auf `a36c47f`.

**Urteil: kann ausgeliefert werden** für den gemeldeten Fall (vollständige Angabe
`width`/`height`, Bild als Teil der Nachricht, eigenes `src` je Bild). Der Kern ist
richtig: Paige malt die Metadatei im MM_TEXT-Zweig 1:1, also muss die Größe in
der Metadatei stehen, und das tut sie jetzt.

Zwei Dinge sollte Gregor vor dem Test wissen:

* **F1 (mittel, neu durch die Behebung):** Zwei `<img>` mit **derselben URL** und
  **verschiedener Angabe** teilen sich EINE Metadatei. Sie hat jetzt die Größe
  des Bildes, das zuerst geladen wurde, und das andere wird in dieser Größe gemalt.
  Vorher wurden beide in Dateigröße gemalt, also gleich falsch. Vorschlag mit
  einer Bedingung siehe unten.
* **F2 (mittel, nicht neu, [E-112](../Intern/BEFUNDE.md#e-112) dort nicht behoben):** Bei **nur `width`** (häufig:
  `width="600" style="height:auto"`, und [E-89](../Intern/BEFUNDE.md#e-89) erzeugt beim Verfassen genau das)
  wird weiterhin in Dateigröße gemalt, während die Zeile die angegebene Breite hat.

---

## Frage 1 — Was steht an der Aufrufstelle in `embed->width/height`?

**Vollständige Angabe → die HTML-Angabe. Sonst 0 → Dateigröße. Belegt.**

Weg der Zahl:

1. `PGHTMIMP.CPP:2059-2062`: `source_width = decimal_value_percent(width, page_width)`,
   `source_height = numeric_value(height)`.
2. `PGHTMIMP.CPP:2075` `pgNewImageRecord` → bei einem neuen Eintrag
   `PGEMBED.C:1855-1871` `EMBED_PREPARE_IMAGE` mit einem **genullten**
   `temp_embed` (`pgFillBlock(&temp_embed, …, 0)`, Z. 1867).
3. `PGHTMIMP.CPP:2088` `pgNewEmbedRef` → `PGEMBED.C:3439-3440` Rechteck aus
   `source_width/height`, `PGEMBED.C:3507-3511` `embed->width/height` daraus
   (nur, wenn das Rechteck nicht leer ist).
4. Laden: `EMBED_LOAD_IMAGE` mit dem **echten** Embed (`PGEMBED.C:1517, 1964, 1997, 2529`)
   → `PgEmbeddedImage.cpp:280` → `:519`.

Die Wege einzeln:

| Weg | `embed->width/height` bei `:519` | Ergebnis |
|---|---|---|
| Vollständige Angabe, `EMBED_LOAD_IMAGE` | Angabe (Schritt 3) | Metadatei in Angabe ✔ |
| Vollständige Angabe, `EMBED_PREPARE_IMAGE` | läuft nicht (`PgEmbeddedImage.cpp:265`) | — |
| Keine/halbe Angabe, `EMBED_PREPARE_IMAGE` | 0/0 (genullter `temp_embed`) | Dateigröße, wie die Regel |
| Keine Angabe, `EMBED_LOAD_IMAGE` (http, beim Vorbereiten nicht holbar) | 0/0 | Dateigröße ✔ |
| erneuter Ladeversuch nach `:590` oder `:882` | bereits gesetzt, Datei bzw. Angabe | dieselbe Regel liefert denselben Wert ✔ |
| Antworten/Weiterleiten | Angabe, aber vorher durch `E89BilderMessbarMachen` umgeschrieben (`msgutils.cpp:3654-3745`: gedeckelt, im Verhältnis, Einheiten entfernt) | ✔ |
| Lesefenster/Vorschau | Angabe **roh** aus dem HTML ([E-89](../Intern/BEFUNDE.md#e-89) wirkt nur beim Verfassen, `msgutils.cpp:3171-3173`) | siehe F3 |
| Werbeansicht `kAd` | `AdView.cpp:53` schreibt `<img src alt>` **ohne** Maße → 0/0 | Dateigröße, unverändert. `kAd` ändert nur die Transparenzfarbe (`:514-516`) |
| Emoticons, `PgInsertImageFromFile` | `PgNewUrlImageRef(…, 0, 0, …)` (`:166, :186`) → 0/0 | Dateigröße, unverändert |

**Ausnahme 1: gleiche URL → F1.** **Ausnahme 2: halbe Angabe → F2.**

## Frage 2 — Weitere Aufrufer von `MetafileFromImage`

**Keine.** Es gibt genau einen Aufruf, `PgEmbeddedImage.cpp:519`, gesucht über
`Eudora71/**`. `OTShim_Bild.h:69` nennt die Funktion nur im Kommentar.

Mit der Vorgabe (0,0) fällt `E112Zielrechteck` in den zweiten Zweig
(`PgEmbeddedImage.cpp:384-392`) und liefert die Dateigröße. Zusätzlich fängt
`E112MetadateiAusDIB` ein Ziel ≤ 0 selbst ab (`QCGraphics.cpp:137-141`). Damit
verhält sich ein Aufruf mit Vorgabe 0 wie der alte Code.

Einzige Verhaltensänderung: Bei `m_dwWidth/Height == 0` gibt die neue Funktion NULL
zurück (`QCGraphics.cpp:135`), `MetafileFromImage` liefert dann `false`
(`:179-183`) und QuickTime wird versucht. Vorher gab es eine leere Metadatei mit
`true`. Das ist harmlos.

## Frage 3 — Zweite Ladewege, Druck, Senden

* **QuickTime** (`PgEmbeddedImage.cpp:560-581`, `qtwrapper.cpp:442-445`):
  Gemalt wird weiterhin in `GraphicsImportGetNaturalBounds`, also in Dateigröße.
  Der Weg ist nur erreichbar, wenn der interne Lader scheitert (GIF läuft intern
  über `QCImage`: `QCGraphics.cpp:78-86, 784-785`, `UseOSLoadImage` ist 1,
  `EudoraRes.rc:7182`) **und** QuickTime für Windows installiert ist
  (`qtwrapper.cpp:136-137`). Danach setzt der Block `:773-893` `pict_frame` auf
  die Angabe, und das Bild deckt den Text zu wie vorher. Niedrig. **Ungemessen**
  ist, ob bei Gregor QuickTime installiert ist.
* **Neuladen/Größenänderung:** Geladen wird nur bei `!image_data`
  (`PgEmbeddedImage.cpp:266, 278`). Die Metadatei wird also einmal geschrieben und
  bleibt. Prozentbreiten werden beim Import gegen `page_width` gerechnet
  (`PGHTMIMP.CPP:236-239, 2060`) und gehen bei einer Fenstergrößenänderung nicht
  mit. Embed und Metadatei bleiben aber gleich groß. Das ist nicht neu.
* **Druck** (`PRINT_MODE_BIT`): Gedruckt wird in einen MM_TEXT-DC
  (`PaigeEdtView.cpp:978, 1180`). Der MM_TEXT-Zweig von `draw_meta_file`
  (`PGEMBED.C:4093-4101`) wendet weder `pg->port.scale` noch die Druckauflösung
  an, das tut nur der andere Zweig (`:4109-4113`). Bilder kommen damit in
  Druckerpunkten heraus, bei 600 dpi ein 35-Punkte-Symbol mit etwa 1,5 mm. Vorher
  waren es 330 Druckerpunkte. Der Fehler bestand schon vorher, die Behebung
  verkleinert das Druckbild um den Faktor Angabe/Datei. **Ungemessen**, ob Paige
  die Zeile im Druck hochskaliert.
* **Senden:** Seit [E-88](../Intern/BEFUNDE.md#e-88) geht das aufgehobene Original hinaus
  (`msgutils.cpp:3111-3114`). In der Editorfassung kopiert `make_it_schmookie`
  einen vorhandenen cid-Teil Byte für Byte (`PgEmbeddedImage.cpp:1297-1330`), es
  geht also die **Originaldatei** hinaus. Nur wenn **kein Teil** existiert
  (http-Bild, eingefügtes Bild), rendert `make_new_part` ein JPEG aus der
  **Metadatei** in `source_width × source_height` (`:1166`, `:1525-1527`).
  Vorher war das bei einer Angabe kleiner als die Datei ein **Ausschnitt oben
  links**, jetzt ist es das ganze Bild in der Angabegröße. Das ist eine
  Verbesserung, mit dem Verlust der höheren Auflösung. Dasselbe gilt für das
  Kopieren über die Zwischenablage (`:1090`, CF_BITMAP). **Ungemessen**, ob ein
  solcher Fall am E-88-Weg vorbeikommt.
* **Speichern als HTML** (`PGHTMEXP.CPP:965-968`): Geschrieben wird
  `embed_ptr->width/height`, also die Angabe. Das ist richtig.

## Frage 4 — HALFTONE in einer WMF

* **Aufgezeichnet:** `SetStretchBltMode` auf einem Metadatei-DC erzeugt
  `META_SETSTRETCHBLTMODE`. `StretchDIBits` erzeugt `META_STRETCHDIB` mit der
  **ganzen** Quell-DIB und dem Zielrechteck. Die Metadatei trägt also weiter alle
  Bildpunkte, der Speicherbedarf ist derselbe wie vorher.
* **Wirksam beim Abspielen:** `metafile_enum_proc` (`PGEMBED.C:4128-4150`)
  verwirft nur die Abbildungs-Datensätze (WINDOWORG/EXT, VIEWPORT*, SETMAPMODE).
  `META_SETSTRETCHBLTMODE` läuft über `default` → `PlayMetaFileRecord` (`:4145`)
  und gilt damit für das folgende `META_STRETCHDIB`. `SaveDC`/`RestoreDC`
  (`:4088, :4125`) setzen den Modus danach zurück, im Paige-DC bleibt nichts
  hängen. In `bitmap_from_url_image` (`PgEmbeddedImage.cpp:1539`, `PlayMetaFile`)
  gilt der Modus ebenfalls.
* **`SetBrushOrgEx` fehlt:** Die Ursprungsangabe betrifft nur die Ausrichtung des
  Halbton-Rasters auf Palettengeräten (8 Bit). Bei `SRCCOPY` ist kein Pinsel
  beteiligt, und auf Echtfarb-Bildschirmen wird gemittelt. Einen WMF-Datensatz für
  den Pinselursprung gibt es meines Wissens nicht; in der Metadatei wäre er also
  ohnehin nicht unterzubringen. **Ein Schaden ist nicht zu erwarten.** Auf
  256-Farben-Anzeigen ist das ungemessen.
* **Kosten:** Bei jedem Neuzeichnen wird die volle DIB per HALFTONE neu
  verkleinert, bei Gregors Banner 1294×575 → 540×240. **Ungemessen**,
  voraussichtlich unauffällig.

## Frage 5 — Ressourcen

**Kein Leck.**
* `LoadImage` löscht bei einem Ladefehler selbst (`QCGraphics.cpp:101-105`).
* `MetafileFromImage`: `delete pImage` steht auf dem Fehlerweg (`:181`) und auf
  dem Erfolgsweg (`:191`). Ohne `pImage` wird nichts angelegt.
* `E112MetadateiAusDIB`: Scheitert `CreateMetaFile`, wird NULL zurückgegeben.
  Sonst läuft `CloseMetaFile` immer (`:155`).
* Der Rückgabewert von `StretchDIBits` wird nicht geprüft. Scheitert der Aufruf,
  entsteht eine leere Metadatei, wie vorher.
* Gegenüber dem alten Code entfällt der `CMetaFileDC`, der schon vor dem Laden
  angelegt wurde.
* Wem `HMETAFILE` gehört (Paige, `EMBED_DESTROY`), ist unverändert.

## Frage 6 — Gegenvermutungen: zu klein, verzerrt, falsche Größe

### F1 (mittel, neu): gleiche URL, verschiedene Angaben → eine gemeinsame Metadatei

`pgNewImageRecord` sucht einen vorhandenen Eintrag **nur über die URL**
(`PGEMBED.C:1828-1846`, `pgEqualStruct(image_record.URL, image->URL, …)`;
`check_to = -1` aus `PGHTMIMP.CPP:2075` heißt: alle Stile). Das zweite `<img>` mit
demselben `src` bekommt denselben `pg_url_image`. Geladen wird nur bei
`!image_data` (`PGEMBED.C:1516, 1963, 2528`), also **einmal**, mit dem Embed, das
zuerst zum Laden kommt. Die Metadatei hat dann dessen Angabe. Das andere Embed
hat seine eigene Zeilengröße, gemalt wird aber in MM_TEXT 1:1 in der fremden
Größe.

Typische Fälle:
* `spacer.gif` in Tabellen-Rundbriefen, mit vielen verschiedenen Maßen.
* dasselbe Logo groß und klein.

Wird zuerst ein großer Platzhalter geladen, werden alle kleinen als große Fläche
gemalt. Transparente Punkte werden in `COLOR_WINDOW` deckend gefüllt
(`PgEmbeddedImage.cpp:514-516`). Ob QCImage/QCPng das wirklich deckend tun, ist
**ungemessen**. Ist es so, deckt die Fläche Text zu, der rechts und darunter
steht.

Vorher wurden alle in Dateigröße gemalt, ein 1×1-Platzhalter also harmlos.
**Ungemessen:** Wie oft das in Gregors Post vorkommt. In `Testdaten/` gibt es
keinen solchen Fall. Ebenfalls ungemessen ist, ob `t_formats` von `import_pg` den
Stil des ersten Bildes schon trägt, wenn das zweite importiert wird (danach
richtet sich, ob die Suche trifft).

**Vorschlag** (`PaigeDLL/PGSOURCE/PGEMBED.C:1840`, verlangt einen Neubau von
Paige32.dll):

```c
            if (pgEqualStruct(image_record.URL, image->URL, sizeof(image_record.URL))
             && ( !(image->source_width && image->source_height)
               || (image_record.source_width == image->source_width
                && image_record.source_height == image->source_height) )) {
```

Ein Bild ohne vollständige Angabe teilt weiterhin. Ein Bild mit Angabe teilt nur
mit einem Eintrag gleicher Größe. Was es kostet: eine Ladung und eine Metadatei je
abweichender Größe. Dazu gehört ein Prüfstand-Fall: zwei Bilder mit gleichem
`src`, 35×35 und 70×70, beide gemalten Flächen messen.

### F2 (mittel, nicht neu): nur `width` → in Dateigröße gemalt, Zeile in Angabebreite

`E112Zielrechteck` behandelt eine halbe Angabe wie keine
(`PgEmbeddedImage.cpp:384-392`), die Metadatei bekommt also die Dateigröße. Das
Embed bekommt aber die **angegebene Breite**:
* Ist die Datei lokal (cid), setzt `EMBED_PREPARE_IMAGE` nur `source_height` nach
  (`:549-552`, `source_width` bleibt die Angabe). `pgNewEmbedRef` baut daraus
  Angabebreite × Dateihöhe (`PGEMBED.C:3439-3440, 3510-3511`).
* Bei http setzt `:584-594` `embed->width = source_width`, also die Angabe.

Bei `width="600"` und einer Datei von 1200×400 ist die Zeile 600 breit, gemalt
wird 1200×400. Das ist das E-112-Symptom, nur in der Breite. [E-89](../Intern/BEFUNDE.md#e-89) erzeugt diesen
Fall beim Antworten absichtlich (`msgutils.cpp:3633-3645`, `:3739-3742`: nur
`width`, „keine erfundene Höhe").

Der Test `TestE112Metadatei.cpp` („nur die Breite angegeben") prüft nur
gemalt == Regel und sieht daher das Embed nicht.

**Vorschlag** (Gregors Entscheidung, weil die E-103-Regel sich ändert): Bei nur
`width` das Seitenverhältnis wahren, wie es jeder Browser tut. In
`E112Zielrechteck` (`PgEmbeddedImage.cpp:384`) vor dem Dateizweig:

```cpp
	else if ( nAttrBreite > 0 && nEchtBreite > 0 && nEchtHoehe > 0 )
	{
		*pnRahmenBreite = nAttrBreite;
		*pnRahmenHoehe  = (nEchtHoehe * nAttrBreite + nEchtBreite / 2) / nEchtBreite;
		if ( *pnRahmenHoehe < 1 ) *pnRahmenHoehe = 1;
	}
	else if ( nAttrHoehe > 0 && nEchtBreite > 0 && nEchtHoehe > 0 )
	{
		*pnRahmenHoehe  = nAttrHoehe;
		*pnRahmenBreite = (nEchtBreite * nAttrHoehe + nEchtHoehe / 2) / nEchtHoehe;
		if ( *pnRahmenBreite < 1 ) *pnRahmenBreite = 1;
	}
```

Dazu muss die Aufrufstelle die Angabe aus `pUrlImage->source_width/height`
nehmen statt aus `embed->width/height`, denn beim Vorbereiten ist der Embed
genullt (`PGEMBED.C:1867`). Nach dem Laden ist `source_*` auf das Ergebnis zu
setzen (`PgEmbeddedImage.cpp:549-552`), damit `pgNewEmbedRef` bzw. `:584-594`
dieselbe Größe eintragen. Die Fälle `TestE112.cpp:75, 78` ändern dann ihr Soll.

### F3 (niedrig bis mittel, nicht neu, jetzt sichtbar als Verzerrung): `width="35px"` wird 3508

`decimal_value_percent` (`PGHTMIMP.CPP:3683-3697`) prüft nicht, ob eine Ziffer
kommt: `digit &= 0x000F` auf jedes Zeichen.
* `"35px"` → 3, 35, 350 (`'p'`=0x70), **3508** (`'x'`=0x78).
* `"35.5"` → 364, **3645**.

`numeric_value` (Höhe) bricht dagegen richtig ab und liest 35. Im
**Lesefenster** ([E-89](../Intern/BEFUNDE.md#e-89) normalisiert nur beim Verfassen) wird die Metadatei jetzt auf
3508×35 gestreckt. Vorher war die Zeile 3508 breit und das Bild in Dateigröße.
Beides ist falsch, neu ist das sichtbar verzerrte Band. **Ungemessen**, wie oft
`px` im Attribut vorkommt; in `Testdaten/` kein Fall. `befund-suchen.pl
decimal_value_percent` meldet keinen bestehenden Befund.

**Vorschlag** (`Eudora71/Eudora/PGHTMIMP.CPP:3694`, vor `digit &= 0x000F;`):

```cpp
      if (digit < '0' || digit > '9')
         break;
```

Damit kommen `"35px"` → 35 und `"35.5"` → 35 heraus, und `'%'` wird weiterhin
vorher ausgewertet.

### Weitere Fälle, in Ordnung

* **Angabe größer als die Datei** (z. B. 200×100 aus 50×25): Die Metadatei wird
  hochskaliert. Der Block `:773` läuft nicht (`nEchtHoehe > embed->height` ist
  falsch), `pict_frame` steht aber schon vom Import auf der Angabe
  (`PGEMBED.C:3439-3453`). Embed und Bild stimmen überein ✔, wie im Browser.
* **Prozentbreite mit Höhe** (`width="100%" height="50"`): `page_width × 50`,
  verzerrt, genau wie im Browser angegeben ✔. `height="50%"` wird von
  `numeric_value` als 50 gelesen. Das bestand schon vorher und wird bei [E-89](../Intern/BEFUNDE.md#e-89)
  verworfen (`msgutils.cpp:3538-3542`).
* **Überlauf auf short** (`width="40000"`): Der Wert wird negativ, und die Regel
  nimmt die Datei ✔.
* **1×1-Zählpixel mit 1×1:** unverändert ✔.

## Nebenbefunde

* **N1 (Kommentar falsch):** `PgEmbeddedImage.cpp:358-361` („eine Metadatei wird
  auf ihr Zielrechteck gestreckt - pict_frame ist dieses Rechteck") und
  `:862-864` („pict_frame ist das ZIELRECHTECK der Metadatei - sie wird
  hineingestreckt") sind durch `PGEMBED.C:4093-4101` widerlegt. Genau das stellt
  der neue Kommentar in `QCGraphics.cpp:115-118` fest. Beide alten Stellen sollten
  im selben Zug berichtigt werden: „pict_frame bestimmt nur die Lage; die Größe
  steht in der Metadatei (QCGraphics.cpp, E112MetadateiAusDIB)".
* **N2 (Begründung halb richtig):** `QCGraphics.cpp:119-121` sagt, die Metadatei
  setze mit `SetMapMode(MM_TEXT)` jede Skalierung zurück. Im MM_TEXT-Zweig wird
  `META_SETMAPMODE` verworfen (`PGEMBED.C:4141`). Nur im anderen Zweig
  (`PlayMetaFile`, `:4122`) würde er abgespielt. Die Schlussfolgerung bleibt
  richtig. Der andere Zweig wäre übrigens der Weg, auf dem `pict_frame` wirklich
  skaliert (Viewport-Ausdehnung = Zielrechteck, `:4119`), und er würde F1 von
  selbst lösen. Dazu bräuchte es aber `mapping_mode` je Embed und eine Metadatei
  mit `MM_ANISOTROPIC` + `SetWindowExt`. **Ungemessen**, nur als Richtung.
* **N3 (Prüfstand):** Der Test spielt mit `PlayMetaFile` in einen MM_TEXT-DC, Paige
  mit `EnumMetaFile` + Filter + `SetWindowOrgEx`. Für die drei Datensätze dieser
  Metadatei (SETMAPMODE, SETSTRETCHBLTMODE, STRETCHDIB) kommt dasselbe heraus.
  Nicht abgedeckt sind die Aufrufstelle (`embed->width` vs. genullter
  `temp_embed`), F1 und F2.

## Ergebnis

| Nr | Schwere | Ort | Art |
|---|---|---|---|
| F1 | mittel | `PGEMBED.C:1828-1846` | neu durch die Behebung; gleiche URL → fremde Größe |
| F2 | mittel | `PgEmbeddedImage.cpp:384-392, 549-552, 584-594` | nicht neu; nur `width` → E-112-Symptom bleibt |
| F3 | niedrig–mittel | `PGHTMIMP.CPP:3683-3697` | nicht neu; `px`/Dezimalzahl → Breite ×100, jetzt verzerrt |
| — | niedrig | `qtwrapper.cpp:442-445` | QuickTime malt Dateigröße (selten erreichbar) |
| — | niedrig | `PGEMBED.C:4093-4101` | Druck ohne Skalierung (nicht neu, ungemessen) |
| N1–N3 | Doku/Test | siehe oben | |

**In Ordnung:** Kernweg vollständige Angabe; einziger Aufrufer; Vorgabe 0 =
altes Verhalten; Vorbereiten mit genulltem Embed liefert Dateigröße; Werbeansicht
und Emoticons unverändert; HALFTONE aufgezeichnet und wirksam, durch
`RestoreDC` eingefasst; kein Leck; Senden schickt das Original ([E-88](../Intern/BEFUNDE.md#e-88) bzw.
Byte-Kopie des cid-Teils); Zwischenablage und `make_new_part` liefern jetzt das
ganze Bild statt eines Ausschnitts.

**Empfehlung:** Ausliefern ist vertretbar. F1 mit der einen Bedingung in
derselben Fassung beheben, weil es der einzige neue Fehlermodus ist. F2 Gregor zur
Entscheidung vorlegen. F3 bei Gelegenheit.
