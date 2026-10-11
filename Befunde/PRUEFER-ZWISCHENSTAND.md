# Zwischenstand E-89 — die Ursache der Überlappung, gemessen

**Stand 14.09.2026, unfertig, nichts davon ist behoben.** Geschrieben unter
Zeitdruck vor dem Herunterfahren. Alle Angaben sind am Quelltext oder an
Gregors Postfächern **gemessen**; wo etwas Vermutung ist, steht es dabei.

## 1. Die erste Fassung (7.2.0.57) hat den Fehler nicht getroffen

Gregors Lauf, aus seiner eigenen Spurmarke:

```
E-89 Bilder im Editor: gesamt=25 unveraendert=22 aus-CSS=0 Vorgabe=3
     gedeckelt=0 geaendert=1 Bytes vorher=62057 nachher=62105
```

**`aus-CSS=0`** — in dieser Nachricht (FairToner.de, *„Jetzt bestellen: 10 %
Rabatt …"*) hatte **kein einziges** Bild seine Größe im CSS. **`gedeckelt=0`** —
keines war zu breit. **22 von 25** trugen bereits brauchbare Attribute. Die
Umschrift hat 48 Bytes von 62057 geändert, und die Bilder überlappen trotzdem.

**Damit ist die Annahme widerlegt, die 7.2.0.57 zugrunde lag:** die fehlende
Größenangabe ist hier nicht die Ursache. Die Kette *CSS-Größe → `source_width=0`
→ `PgEmbeddedImage.cpp` trägt nach dem Umbruch nach* erklärt diesen Fall nicht.

## 2. Zwei naheliegende Erklärungen — beide gemessen ausgeschlossen

**(a) Der Nachtrag über `embed->style == embed_ptr->style`
(`PgEmbeddedImage.cpp:458-507`) ist es nicht.** Er läuft nur unter
`if ((embed->height == 0) || (embed->width == 0))`. Die Maße des Embeds werden
aber **schon beim Einlesen** gesetzt: `initialize_embed_data`
(`PaigeDLL/PGSOURCE/PGEMBED.C`) nimmt für `embed_url_image`
`rect.bot_right = (source_width, source_height)` und setzt daraus
`embed_ptr->width` und `embed_ptr->height`. Für die 22 Bilder mit Attributen
sind beide also **nicht 0** — der fehlerhafte Suchlauf läuft für sie gar nicht
erst an. (Er bleibt trotzdem falsch: er trifft beim ersten Embed gleichen Stils
zu. Das ist ein eigener Mangel, aber nicht dieser hier.)

**(b) Der Rahmenweg („exclusion-wrap") ist es auch nicht.**
`PGHTMIMP.CPP:2045` baut nur dann einen `pg_frame` mit fester Lage, wenn das
`<img>` ein `align`-Attribut trägt und **nicht** in einer Tabelle steht.
Gemessen über alle `.mbx` in `C:\Users\Gregor\Eudora72-Postfaecher-gesichert`
und `C:\Users\Gregor\Mailverzeichnis`: **3060 `<img>`, davon 16 mit
`align`-Attribut — alle mit dem Wert `middle`.** `middle` läuft in
`TranslateAlignment` auf `justify_middle` und setzt `frame.data` gerade
**nicht**; es wird kein Rahmen eingefügt.

## 3. Der eigentliche Verdacht, mit Fundstelle: die Zeilenhöhe wächst nicht mit

`PGHTMIMP.CPP:2107-2116`, im `image_command`-Zweig:

```
pgInitEmbedStyleInfo(import_pg_rec, 0, embed, 0, image_callback, 0, &current_style, …);

if (image_record.source_height) {

   current_style.ascent = image_record.source_height;
   current_style.ascent = (short)original_descent;

   if (original_ascent > current_style.ascent)
      current_style.ascent = (short)original_ascent;
}
```

Die erste Zuweisung wird von der zweiten **sofort überschrieben** — ein toter
Speicherzugriff. `original_ascent` und `original_descent` sind weiter oben aus
dem **Textstil** genommen worden, bevor das Bild bekannt war. Übrig bleibt
also: `ascent = max(Text-Ascent, Text-Descent)`. **Die Höhe des Bildes geht in
die Zeilenhöhe nicht ein.**

Dass sie es müsste, steht eine Schicht tiefer: `pgInitEmbedStyleInfo` ruft
`EMBED_VMEASURE` (`PGEMBED.C:1782`), und dort wird der Stil auf das Embed
gesetzt (`PGEMBED.C:1666-1681`):

```
object_ascent  = embed_ptr->height - embed_ptr->descent + embed_ptr->top_extra;
style->ascent += (short)(object_ascent - style->ascent);
…
if (style->ascent < embed_ptr->height)
    style->ascent = (short)embed_ptr->height;
```

**Der HTML-Leser wirft genau diesen Wert wieder weg.** Ein 150 Bildpunkte hohes
Bild sitzt dann in einer Zeile, die nur so hoch ist wie der Text — und deckt
die Zeilen darüber zu. Das ist genau das Bild, das Gregor geschickt hat:
Tonerkartusche über *„Artikelnummer"* und *„Nachbestellung mit Order-No"*.

**Kein Portierungsfehler.** Die Stelle ist in allen vier Fassungen im Repo
Zeichen für Zeichen gleich: `Eudora71/Eudora/PGHTMIMP.CPP:2109`,
`Eudora71/PaigeDLL/PGTXR/PGHTMIMP.CPP:1511`, und beide `Sandbox/`-Gegenstücke.
Sie stammt also aus dem Original.

**Noch nicht gemessen, und deshalb noch kein Urteil:** ob `current_style` an
dieser Stelle wirklich der Stil ist, der für das Embed in den Text geht, oder
ob `ProcessEmbed()` einen anderen benutzt. **Das ist der nächste Schritt** —
und er gehört gemessen, nicht geraten: eine Spurmarke, die je Bild
`source_height`, `embed->height`, `style->ascent` **vor** und **nach** der
Überschreibung und die Zeilenhöhe in **einer** Zeile nennt.

## 4. Ein Rückschritt aus 7.2.0.57, der vermutlich weg muss

`Vorgabe=3` in Gregors Lauf heißt: drei Bilder ohne jede Größenangabe haben
200x90 bekommen. Auf seinem Bild steht ein **graues Rechteck**, wo vorher
nichts war — mit großer Wahrscheinlichkeit eine dieser drei Vorgaben.
**Vermutung, nicht gemessen.** Zu prüfen und, wenn sie sich bestätigt, zu
verwerfen: ein Bild ohne bekannte Größe gar nicht anzufassen ist besser, als
ihm einen leeren Kasten zu geben.

## 5. Was unverändert gilt

Die Trennung der Fassungen in `summary.cpp` (`EditorBody` gegen `Body`) ist
davon nicht berührt: das aufgehobene Original aus **E-88** bleibt unangetastet,
gleich wie E-89 weitergeht.
