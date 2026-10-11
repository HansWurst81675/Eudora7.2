# Vorarbeit zu E-30: die Symbole sind da, der Grauzustand fehlt

**Stand 06.09.2026.** Diese Datei sammelt, was ich gemessen habe, bevor der
Agent SYMBOLE seinen Befund abgibt. Sie ersetzt ihn nicht.

## Gregors Beobachtung, und warum sie entscheidend ist

> „kurios nur, daß im anderen screenshot die icons zu sehen sind, dann aber
> nicht mehr."

Zwei Bildschirmfotos derselben Sitzung, Fassung 7.2.0.10:

| Bild | aktives Fenster | Werkzeugleiste |
|---|---|---|
| 1 | Postfach „In" | **alle** Symbole vollständig sichtbar |
| 2 | *Find Messages* | mehrere Knöpfe sind **leere graue Flächen** |

Es sind dieselben Knöpfe in derselben Leiste. Wären die Bitmaps kaputt, fehlten
sie in **beiden** Bildern. Sie fehlen genau dann, wenn der Knopf im aktuellen
Zusammenhang **abgeschaltet** ist.

**Damit ist ausgeschlossen:** fehlende Ressourcen, falsche Kennungen, zu kleine
Bilderliste, nicht geladene Bitmaps. Alles das war die naheliegende
Vermutung — Gregors Beobachtung widerlegt sie ohne einen einzigen Debugger-Lauf.

**Übrig bleibt:** die Darstellung des **abgeschalteten** Zustands.

## Was ich dazu im Quelltext gemessen habe

1. **Es gibt nirgends eine Bilderliste für den Grauzustand.** Weder
   `SetDisabledImageList` noch `TB_SETDISABLEDIMAGELIST` kommen im ganzen
   Projekt vor. Ohne sie muss comctl32 die graue Fassung selbst aus dem
   farbigen Bild erzeugen.

2. **Die Bilderliste wird mit `ILC_COLORDDB` angelegt**
   (`QCImageList.cpp:156`): geräteabhängige Farbtiefe, auf einem heutigen
   Bildschirm also 32 Bit. Unter Windows 95/98, wofür der Code geschrieben
   wurde, waren das 8 oder 16 Bit. **Das ist der Verdacht:** die automatische
   Graufassung von comctl32 arbeitet über die Maske; bei 32 Bit pro Bildpunkt
   verhält sie sich anders als bei 8. Zu prüfen, nicht zu glauben.

3. `CoolButton.cpp` behandelt `ODS_DISABLED` an zehn Stellen ausdrücklich —
   diese Klasse zeichnet also selbst. Sie ist aber nicht die Hauptleiste.

## Folge für Gregors Vorschlag mit dem Verbotsschild

> „besser als icons ausgrauen ist, ein ,not-implemented' icon einzusetzen.
> oder eins mit verkehrszeichen ,durchfahrt verboten' oder ähnlich."

Der Vorschlag bleibt richtig, betrifft aber eine **andere und kleinere** Menge
als zunächst gedacht. Es sind zwei verschiedene graue Knöpfe:

| Art | richtige Darstellung |
|---|---|
| **gerade nicht anwendbar** (Antworten im Suchfenster) | ausgegraut — die Funktion gibt es, nur hier nicht |
| **gar nicht implementiert** | **Verbotsschild** — sonst wartet man vergeblich darauf, dass der Knopf irgendwann angeht |

### Auszählung der Werkzeugleisten (gemessen)

```
IDR_MAINFRAME16/32     je 64 Knöpfe      IDR_READMESS      30
IDR_MAINFRAME16A/32A   je 61 Knöpfe      IDR_COMPMESS      37
IDR_MAINFRAME16B/32B   je 51 Knöpfe      IDC_PEANUT_TOOLBAR 11
```

**260 verschiedene Kennungen.** Davon **95 ohne Eintrag in einer
Nachrichtentabelle**, davon **48 Platzhalter** (`ID_BUTTON8025` …
`ID_BUTTON8072`) der anpassbaren Leiste. Bleiben **47 Kandidaten**, darunter
`ID_MOOD_MAIL`, `ID_TRANSLATOR`, `ID_TOW_TRUCK`, `ID_SPECIAL_PLUGIN`,
`ID_WILDCARD`, `ID_TEXT_AS_DOCUMENT`.

> **Diese 47 sind ein Sieb, keine Antwort.** MFC behandelt Befehle auch über
> `ON_COMMAND_RANGE` (elf solche Bereiche im Projekt, darunter
> `QC_FIRST_COMMAND_ID … QC_LAST_COMMAND_ID` für die dynamischen
> Postfachbefehle) und bringt für `ID_WINDOW_CASCADE`, `ID_WINDOW_TILE_*` und
> `ID_WINDOW_ARRANGE` eigene Behandler in `CMDIFrameWnd` mit. Stichprobe:
> `ID_MAILBOX_IN` steht in der Liste, hat aber sehr wohl einen Behandler
> (`mainfrm.cpp:632`) — die Auszählung hat ihn übersehen, weil sie nur nach
> `ON_COMMAND(` sucht und dort ein Leerzeichen steht.

**Vor dem Verbotsschild muss also der Filter stehen**, sonst bekommen
funktionierende Knöpfe ein Verbotsschild — das wäre schlimmer als der heutige
Zustand.
