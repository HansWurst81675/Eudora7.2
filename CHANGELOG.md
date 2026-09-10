# Was sich geändert hat

Neueste Fassung zuerst. Jede Nummer gehört genau einem Bau: **Quellstand
`7.2.0.x`** steht in `Eudora71/Version.h`, **Paketnummer `1.0.x`** in `VERSION`.
Die Bau-Kennung im Fenstertitel nennt beide plus den Commit.

> **Wer hier neu einsteigt:** [ZIEL.md](ZIEL.md) sagt, woran „fertig" gemessen
> wird, [README.md](README.md) wie man baut und startet, [BEFUNDE.md](BEFUNDE.md)
> was im Einzelnen gefunden wurde. Der Abschnitt **Wo man weitermachen kann**
> ganz unten nennt die offenen Enden mit Fundstelle.

## Noch offen (Stand 09.09.2026)

| Kennung | | |
|---|---|---|
| **E-47** | beim Öffnen der **Kurznamen-/Verzeichnisdienst-Leiste** kommt *„Directory Services unavailable during this session…"* | Ursache belegt: `RegisterCOMObjects()` scheitert, weil `MFC71.DLL` und `MSVCP71.dll` fehlen — von Microsoft nie als Redistributable veröffentlicht. Betrifft Adressbuch, LDAP, Ph und S/MIME, **nicht** den Start. Keine Behebung in Sicht |
| — | **Nach einem Neustart stehen die Fenster nicht im Vollbild**, obwohl sie beim Beenden so waren | Nebenbefund **ohne Nummer**, von Gregor am 09.09.2026 an 1.0.25 gemeldet. Gehört **nicht** zur Registerkartenleiste (E-48/E-50), sondern zum Fensterzustand über `SaveOpenWindows`. Getrennt zu messen, noch nicht angefasst |
| — | **Gebaut, aber von Gregor nicht beurteilt:** **E-49** (linken Bereich breiter **ziehen**, Anforderung **A-4**) und **E-52** (Balken bleibt danach greifbar, Karten nicht doppelt) | Bestätigt ist bei E-52 nur der **Gegenfall**: *„verschieben rauf / runter — bug gefixt, die anzeige ist korrekt."* Das **seitliche** Ziehen kann ich grundsätzlich nicht selbst messen — dazu braucht es eine physisch gedrückte Maustaste |
| — | **E-39**: wird die **aktuell benutzte** Persönlichkeit gelöscht, kann ihr INI-Abschnitt teilweise wiederentstehen | `Remove` stellt die aktuelle Persönlichkeit nicht um, und `FlushINIFile` schreibt `SavePassword`/`SavePasswordText` in `GetCurrent()` (`rs.cpp:1237-1250`). Nicht am laufenden Programm bestätigt |
| — | Meldung „Encountered an improper argument" beim **Anzeigen** mancher Nachrichten | dieselbe Quelle wie E-34, andere Aufrufstelle. **Neu zu messen**, seit E-43 behoben ist — gut möglich, dass sie mit verschwindet |

## Erreicht

| | |
|---|---|
| **Kriterien 0, 1 und 3** aus [ZIEL.md](ZIEL.md) | erfüllt: Bau aus frischem Klon, Start ohne Nachinstallieren auf einem Rechner ohne Visual Studio, Mailabruf über POP3/TLS 1.3 auf Port 995 |
| **Kriterium 2** (Darstellung) | *fast* — offen ist die Meldung „Encountered an improper argument" beim **Anzeigen** mancher Nachrichten. **Neu zu messen** seit 7.2.0.24: sie stammt aus derselben Quelle wie E-34/E-43 |
| **Kriterium 4** (keine Abstürze) | *fast* — Strg-N stürzt nicht mehr ab (fünfmal nachgemessen), das Beenden läuft sauber (Kriterium 7), und die Fehlerklasse hinter E-34/E-37/E-43 ist seit 7.2.0.24 an der Wurzel weg |
| **Kriterien 5 und 6** (Mail schreiben, senden, weiterleiten) | **erfüllt** — von Gregor am 07.09.2026 bestätigt: *„mail können jetzt abgeschickt werden."* und *„weiterleitung funktioniert übrigens."*, mit Bildschirmfoto |
| **Kriterium 8** (Fensterliste) | **erfüllt** — von Gregor am 09.09.2026 bestätigt: das Menü *Window* listet sie auf, und die Registerkartenleiste am unteren Rand ist da; der Klick auf eine Karte holt das Fenster nach vorn, die Beschriftungen stimmen mit dem Menü (**A-3** / **E-48**) |
| **Kriterium 7** (Beenden) | **erfüllt** — von Gregor am 08.09.2026 an Paket 1.0.22 bestätigt: *„schließen klappt jetzt."* Alle drei Wege beenden: *File → Exit*, Alt-F4 und das Kreuz (E-40, E-41, E-42, ergänzt um E-45) |
| **A-1** (Vorgaben für ein neu angelegtes Konto) | **erfüllt** — *„default werte beim neuen persona konto für 'leave message on server' greifen."* |
| **A-2** (*Task Status* und *Task Errors* waagrecht unten) | **erfüllt** — *„leiste unten paßt."* |
| **A-3** (offene Fenster als Registerkarten direkt auswählen) | **erfüllt** — von Gregor am 09.09.2026 bestätigt (**E-48**, umgesetzt in 7.2.0.25). Damit ist Kriterium 8 ganz erfüllt |
| **A-4** (den linken Bereich breiter ziehen) | **gebaut, nicht bestätigt** — **E-49** in 7.2.0.26, in 7.2.0.27 durch **E-52** und in 7.2.0.29 durch **E-54** (der Ziehrahmen war nach rechts unsichtbar) und **E-55** (acht Pixel leerer Streifen unter der Werkzeugleiste) nachgebessert. Bestätigt ist nur die Höhenänderung des unteren Bereichs: *„verschieben rauf / runter — bug gefixt, die anzeige ist korrekt."* |

> **07.09.2026, Gregor zu Paket 1.0.21:** *„mail können jetzt abgeschickt
> werden."* und *„weiterleitung funktioniert übrigens."* Damit ist der Kreis
> zum ersten Mal geschlossen — schreiben, senden, Antwort empfangen.
>
> **Sein Einwand steht daneben und gilt:** *„beenden geht nicht."* Und: *„kann
> man die untere zeile (status) immer anzeigen lassen?"*
>
> Sein Maßstab von Paket 1.0.18 bleibt der Maßstab für alles Weitere: *„es
> crasht nicht, aber es passiert auch nichts. beenden kann ich es auch nicht.
> nichts statt crash ist auch keine verbesserung!"* — kein Absturz ist kein
> Fortschritt, solange der Anwender nichts damit tun kann.

---

## Nach 1.0.29 — es wird an 7.2.0.30 gearbeitet

Im Repo liegen **Änderungen, die in keinem Paket stecken**: die zweite Ursache
von **E-66** (Trennbalken rechts) und **E-63** (Kurzhinweis der letzten Karte),
beide gebaut und
fehlerfrei übersetzt, aber **nicht ausgeliefert**. Dazu die Arbeit an den
**Filtern**, Gregors nächstem Gebiet.

`Eudora71/Version.h` und `VERSION` stehen deshalb schon auf **7.2.0.30 /
1.0.30**, obwohl es dieses Paket noch nicht gibt. Der Grund steht im
Abschnitt 7.2.0.30: der Bau vom 09.09.2026 trug **7.2.0.29** — dieselbe Nummer
wie das veröffentlichte Paket, aber anderen Code. Wer daraus ein Paket
geschnürt hätte, hätte zwei verschiedene Bauten unter derselben Kennung
ausgeliefert (Befund **V-1**, Gregors Regel dazu: *„version muß eindeutig
sein"*). Die Nummern gehen also **vor** dem Paket hoch, nicht mit ihm.

> **In `Version.h` stehen drei Makros, nicht eines.** `EUDORA_VERSION4`,
> `EUDORA_BUILD_VERSION` **und** `EUDORA_BUILD_NUMBER` — das letzte im
> Komma-Format, heute `7,2,0,29`. Beim Sprung auf 7.2.0.23 hat meine Ersetzung es
> übersehen, und `tools/doku-pruefen.pl` hat den Commit abgewiesen. Benutzt
> wird es im ganzen Bestand nirgends (0 Treffer außerhalb von `Version.h`),
> es gehört aber trotzdem mit hochgesetzt.

> **Berichtigt am 09.09.2026 (LEKTOR, L-11).** Hier stand bis dahin eine
> Aufzählung von fünf Punkten, die als *„noch nicht gepackt"* geführt wurden —
> darunter *„E-37: nur die ANZEIGE behoben"* und *„32 Spurmarken für E-33"*.
> **Beides ist überholt und widersprach schon der Überschrift dieses
> Abschnitts.** E-37 ist kein eigener Fehler, sondern ein Symptom von **E-43**,
> mit ihm in 7.2.0.24 behoben und von Gregor bestätigt; die Spurmarken zu E-33
> liegen seit 1.0.22 in jedem Paket. `tools/DEudora.ini`, `tools/bauen.ps1` und
> die Prüfungen 8 bis 11 in `tools/doku-pruefen.pl` sind ebenfalls längst
> ausgeliefert. Seit 1.0.29 ist **nichts** an **Behebungen** dazugekommen,
> was nicht in seinem Paket steckt — die Werkzeuge der letzten Bauten stehen
> in den Abschnitten zu
> 7.2.0.24 (`tools/testlauf.ps1`, `tools/pruefe-waechter.pl`) und 7.2.0.25.

> **Hier stand bis zum 07.09.2026 ein Abschnitt „Nach 7.2.0.18".** Er nannte
> `VERSION` mit 1.0.18, während die Datei drei Fassungen weiter war, und führte
> **E-32** als Behebung der modalen Meldung. Beides war falsch: die
> E-32-Ursachenbehauptung hat PRUEFER dreifach gemessen und **verworfen**
> (siehe 7.2.0.20). Gefunden hat den Widerspruch LEKTOR als **W-3** und **W-5**
> (`Befunde/LEKTOR-4.md`), nachdem Gregor gesagt hatte: *„wäre vor dem mergen
> wichtig, daß keine lügen im main stehen!"*

---



## 7.2.0.33 — Messfassung III: wem gehört der Streifen?

**Das Protokoll von 1.0.32 hat den Fall entschieden** — jedenfalls zur
Hälfte. Gregor ist über beide Balken gefahren und hat geklickt:

| Marke | Anzahl |
|---|---|
| `E-66 Streifen:` | 26 |
| `E-66 Bewegung UEBER dem Streifen:` | **0** |
| `E-66 Klick:` | **0** |

**Weder Mausbewegungen noch Klicks erreichen die Andockleiste.** `WM_SETCURSOR`
steigt vom Kindfenster zum Elternfenster auf, `WM_MOUSEMOVE` tut das
**nicht** — also steht der Zeiger über einem **Kind** der Andockleiste, nicht
über ihr selbst. Der Streifen, den die Rechnung für frei hält, ist von der
Leiste **verdeckt**. Der Doppelpfeil ist nur der aufsteigende
Zeigersetz-Aufruf.

Damit sind zwei der drei möglichen Ursachen vom Tisch: es liegt weder an der
Trefferprüfung noch an der Maustaste allein.

**Was noch fehlt, um es zu beheben:** *wo* der Zeiger steht und *wem* dieser
Punkt gehört. Bisher wurde nur die **Breite** der Leiste gemessen, nie ihre
**Lage** — und ohne die ist nicht zu entscheiden, ob der freie Streifen vor
oder hinter ihr liegt.

Zwei Erweiterungen:

| Marke | neu darin |
|---|---|
| `E-66 Streifen:` | `Bar=links..rechts`, die **Lage** der Leiste, und `Balken=…`, wohin der Trennbalken gelegt wird |
| `E-66 Zeiger:` | Punkt, Balkenlage, **Empfänger** der Nachricht mit Klassennamen, und der Trefferkennwert von Windows — höchstens eine Zeile je Sekunde |

Steht im Empfänger etwas anderes als *die Andockleiste selbst*, ist der Fall
vollständig entschieden, und der Klassenname sagt zugleich, wo die Behandlung
hingehört.

### Was an 1.0.33 zu prüfen ist

Wie bei 1.0.32: über beide Balken fahren, je einmal klicken und ziehen, dann
die `eudora.log`. Nichts weiter.

## 7.2.0.32 — Messfassung II: kommt der Klick überhaupt an?

**Was das Protokoll von 1.0.31 ergeben hat** — und warum diese Fassung nötig
ist. 13 Zeilen `E-66 Streifen:`, **keine einzige** `E-66 Zug:`. Die
Ziehschleife wird also nie betreten. Die Geometrie stimmt dagegen:

| Andockleiste | Clientbereich | `nPos` | `nFrei` | `nSchub` |
|---|---|---|---|---|
| links (59420) | 0,0..188,703 | 1 | **8** | 0 |
| rechts (59421) | 0,0..188,703 | 1 | **8** | 10 |

Beide Balken entstehen, acht Pixel breit, an der richtigen Kante. Es
scheitert am **Klick**, nicht an der Rechnung — und `ON_WM_LBUTTONDOWN` steht
in der Nachrichtentabelle.

**Der Verdacht, der zu allen Beobachtungen passt:** `WM_SETCURSOR` steigt vom
Kindfenster zum Elternfenster **auf**, Maustasten tun das **nicht**. Die
Andockleiste bekäme dann den Zeiger zu setzen — daher der Doppelpfeil, den
Gregor sieht — während der Klick bei einem Kindfenster landet, das den
Streifen verdeckt.

**Die Messung, die das entscheidet:** Mausbewegungen steigen ebenfalls
**nicht** auf. Zwei neue Marken:

| Marke | wann | was sie beweist |
|---|---|---|
| `E-66 Bewegung UEBER dem Streifen:` | Maus über dem Streifen | erscheint sie, gehört der Andockleiste dieser Pixel wirklich |
| `E-66 Klick:` | jeder Klick in die Andockleiste | kommt der Klick an, und trifft er? Mit Punkt und Treffer ja/nein |

Drei Ausgänge, drei verschiedene Ursachen:

* **Beide Marken bleiben aus** → ein Kindfenster verdeckt den Streifen. Der
  Zeiger stimmt nur, weil `WM_SETCURSOR` aufsteigt.
* **Bewegung ja, Klick nein** → die Maustaste geht woanders hin, obwohl die
  Bewegung ankommt.
* **Klick ja, `Treffer=NEIN`** → die Trefferprüfung rechnet beim Klick anders
  als beim Zeigersetzen.

### Was an 1.0.32 zu prüfen ist

Nur eines: **mit dem Zeiger über den linken und den rechten Trennbalken
fahren und jeweils einmal klicken und ziehen.** Danach die `eudora.log`.
Mehr nicht — diese Fassung soll messen, nicht gefallen.

## 7.2.0.31 — Messfassung: warum der Trennbalken nicht greift

**Was Gregor damit tun kann:** dieselbe Fassung wie 1.0.30, plus **drei
Spurmarken**, die beim Ziehen des Trennbalkens ins Protokoll schreiben, was
wirklich passiert. Einmal ziehen, `eudora.log` schicken — danach ist **E-66**
entschieden, statt weiter geraten zu werden.

**Dazu behoben: die dritte Ursache von E-66.**

### E-66, dritte Ursache — meine eigene Messung zerstörte ihr Ergebnis

Gregor an 1.0.30: *„balken lassen sich nicht verschieben. beim anklicken ist
der maus cursor als zwei pfeile zu sehen, aber er greift nicht."* Und:
*„in der 0.30 version ist das filter fenster noch nicht skalierbar bzw. der
fenster rand nicht verschiebbar."*

Der Doppelpfeil war der entscheidende Hinweis: `HitTest` **findet** den
Balken, er existiert also. Beim Einsetzen der Spurmarke kam der Grund durch
Lesen heraus — und es ist die Behebung vom Vortag selbst:

Der freie Streifen wurde als **Abstand** zwischen Leistenkante und
Andockleistenkante gemessen. Für rechts und unten wird die Leiste
unmittelbar danach **genau dorthin gerückt** — also ist der Abstand beim
nächsten Anordnungsdurchlauf null, die Bedingung `nFrei >= 2` scheitert, und
der Balken wird **nicht mehr angelegt**. Eine Messung, die ihr eigenes
Ergebnis zerstört.

Dass der Doppelpfeil trotzdem erscheint, passt genau dazu: der Balken
entsteht im ersten Durchlauf und verschwindet im nächsten — je nachdem, wann
man hinsieht, ist er da oder nicht.

Getrennt wird das jetzt in **zwei Größen mit verschiedener Bedeutung**:

| | woraus | Verhalten nach dem Rücken |
|---|---|---|
| `nFrei` — wie **breit** der Streifen ist | Differenz der **Größen** | unverändert, die Größen ändern sich beim Rücken nicht |
| `nSchub` — wie **weit** noch zu rücken ist | Differenz der **Lagen** | wird von selbst null, es passiert nichts mehr |

Damit hält sich die Sache selbst an, statt zwischen zwei Zuständen zu
pendeln.

### Die drei Spurmarken

Jede schreibt **eine** Zeile, alle mit `MISC | TOC_CORRUPT` — also ohne dass
etwas eingestellt werden muss:

| Marke | wann | beantwortet |
|---|---|---|
| `E-66 Streifen:` | bei jedem Anordnungsdurchlauf | entsteht überhaupt ein Balken? Mit Andockleiste, Clientbereich, `nFrei`, `nSchub` |
| `E-66 Zug:` | bei jedem Ziehversuch | liefert die Ziehschleife etwas? Mit Balkenlage, Grenzen, Klickpunkt, Delta |
| `E-66 Anwenden ABGEBROCHEN:` | wenn das Anwenden scheitert | **welcher** der drei möglichen Gründe — Leiste nicht gefunden, falsche Klasse (mit echtem Klassennamen), oder Größe unverändert |

Drei Fehlerfälle, die von außen alle gleich aussehen — *„der Balken greift
nicht"* —, sind damit unterscheidbar.

**Warum Marken und nicht die nächste Vermutung:** am 09.09.2026 sind **vier**
Vermutungen am Code gescheitert — zwei zu E-64 (eine Attrappe, die immer
`TRUE` liefert; ein `default`-Zweig in `MatchValue`) und zwei zu E-66
(`BrauchtGreifstreifen` lasse rechts nicht zu; es liege allein an
`CalcTrackingLimits`). Was sich lesen lässt, wird gelesen; was nicht, soll
das Programm selbst sagen.

**Die Marken gehören wieder heraus, sobald E-66 steht** — ebenso die Marke
`E-64 Match=` aus 7.2.0.30, die je Nachricht **und** Filter eine Zeile
schreibt.

### Was an 1.0.31 zu prüfen ist

1. **Trennbalken rechts** greifen und ziehen — mehrfach, auch nach einer
   Größenänderung des Hauptfensters.
2. **Trennbalken links** desselbe — er ging in 1.0.29; falls er jetzt nicht
   mehr geht, hat eine der drei Behebungen ihn beschädigt, und das steht in
   der Marke `E-66 Streifen:`.
3. Danach die **`eudora.log`** schicken, ganz gleich ob es geht oder nicht.
   Geht es, steht dort warum; geht es nicht, steht dort auch warum.

## 7.2.0.30 — Trennbalken rechts, Kurzhinweis der letzten Karte (in Arbeit)

**Noch nicht gebaut, nicht gepackt, nicht ausgeliefert.** Dieser Abschnitt
wächst, während an den Filtern gearbeitet wird — Gregors nächstes Gebiet.

**Was Gregor damit tun können wird, was in 1.0.29 nicht ging:** den
Trennbalken **rechts** ziehen (**E-66**, siehe die Einschränkung unten), und der
Kurzhinweis erscheint auch
auf der **letzten** Registerkarte (**E-63**).

### E-66 — rechts spiegelverkehrt gerechnet (zweite von zwei Ursachen)

Gregor an 1.0.29: *„rechts ist zwar ein balken sichtbar, aber nicht
verschiebbar"*.

`SECDockBar::CalcTrackingLimits` rechnete für **beide** senkrechten
Andockleisten dieselben Grenzen:

```
min = Rahmen links  + nMindest
max = Rahmen rechts - nFreiraum
```

Für **links** stimmt das. Für **rechts** ist es spiegelverkehrt, und zwar so,
dass gar nichts mehr geht: der Balken sitzt dort an der **linken** Kante der
Andockleiste. In deren Koordinaten ist `rectRahmen.left` stark negativ und
`rectRahmen.right` liegt bei etwa **188** — damit wird `max = 188 − 200 =
−12`, also **kleiner als der Ort des Balkens**. Eine Notbremse zieht `max` auf
`min + nMindest` hoch, und zwischen zwei Grenzen, die 16 Pixel
auseinanderliegen und beide weit links vom Balken stehen, lässt sich nichts
ziehen. Der Balken nimmt den Mausfang und bewegt sich nicht.

Die Regel, die für alle vier Seiten stimmt und jetzt dasteht:

| Leiste | angewachsen an | zum MDI-Bereich hin |
|---|---|---|
| **links** | `min = links + nMindest` | `max = rechts − nFreiraum` |
| **rechts** | `max = rechts − nMindest` | `min = links + nFreiraum` |
| **oben** | `min = oben + nMindest` | `max = unten − nFreiraum` |
| **unten** | `max = unten − nMindest` | `min = oben + nFreiraum` |

**Nebenbei mitgefunden: unten war ebenso falsch, nur unauffällig.** Die alte
Rechnung war nach oben zu großzügig (der MDI-Bereich ließ sich auf 16 Pixel
zusammenschieben) und nach unten zu streng (die Leiste ließ sich nicht unter
200 Pixel Höhe verkleinern). Gregor hatte am 09.09.2026 nur die eine Richtung
geprüft — *„verschieben rauf / runter — bug gefixt"* —, deshalb hat es
niemand gemerkt. Genau der Fall aus der Lehre *Gegenprobe umdrehen*: geprüft
wurde, ob der gewünschte Zustand eintritt, nicht ob der unerwünschte
durchkommt.

> **Das behebt nur die HÄLFTE, und das gehört gesagt.** PRÜFER hat am
> 09.09.2026 die **erste** Ursache nachgewiesen, und sie sitzt woanders:
> `TrennbalkenNeuAnlegen` misst den freien Streifen für die rechte
> Andockleiste bei `rectLeiste.left - rect.left`, aber
> `CDockBar::CalcFixedLayout` der MFC (`bardock.cpp:387`) setzt die Kindleiste
> in **jeder** Andockleiste bündig auf `(-cxBorder2, -cyBorder2)`. Der
> Zuschlag von zwölf Pixeln bleibt darum immer am **großen** Ende liegen:
> links an der Innenkante (`nFrei ≈ 7`, der Balken entsteht), rechts am
> **Fensterrand** (`nFrei = −2`, die Bedingung `nFrei >= 2` scheitert,
> `AddSplitter` läuft nie, `HitTest` liefert `NULL`).
>
> Solange das so ist, entsteht rechts **gar kein** Balken, und die hier
> berichtigten Grenzen greifen ins Leere. Meine erste Zuordnung — es liege
> allein an den Grenzen — war unvollständig: sie stimmt, sie reicht nur nicht.
> Auch **widerlegt** ist meine Spur „`BrauchtGreifstreifen` lässt rechts nicht
> zu": die Bedingung ist für links und rechts identisch.

### E-63 — die letzte Karte bekam nie ein Kurzhinweis-Feld

Gregor an 1.0.29: *„alle karten, bis auf die letzte (warum?) zeigen einen
tooltip beim maus over."*

`RecalcToolTipRects` (`workbook.cpp:1709`) meldet nur Blätter mit `WS_VISIBLE`
als Feld an. Gerufen wird es unter anderem aus `AddSheet` über `ResetTaskBar`
— und dort ist das eben angelegte MDI-Kindfenster **noch nicht sichtbar**. Es
bekommt kein Feld. Jedes **spätere** `AddSheet` rechnet alle Felder neu und
repariert die älteren; nur die zuletzt hinzugekommene Karte bleibt ohne, und
das ist die rechte.

Im Original gibt es dagegen eine Selbstheilung, und sie steht in
`QCWorkbook::OnDrawBorder` (`workbook.cpp:1533`) — *„This is as good a place
as any to figure out if somebody has done something behind our backs"*.
`OnDrawBorder` wird in dieser Portierung **von niemandem gerufen**; im
Original tat das `SECWorkbook::OnPaint` der Stingray-Ebene. **Dieselbe Wurzel
wie E-58**, der Browser-Klick ins Leere.

`OnDrawBorder` wiederzubeleben kam nicht in Frage — das würde auch das
Werbelogo zeichnen. Die Selbstheilung steht deshalb jetzt beim Zeichnen der
Karten und vergleicht die Zahl der **angemeldeten Felder** mit der Zahl der
**sichtbaren Karten**. Das ist die Messung selbst und nicht ihr Ergebnis:
stimmen die Zahlen, passiert nichts; stimmen sie nicht, wird einmal neu
gerechnet, danach stimmen sie.

### Warum die Nummer schon hochgesetzt ist

Der Bau vom 09.09.2026, 13:0x trug **7.2.0.29** — dieselbe Nummer wie das
veröffentlichte Paket, aber anderen Code. Das ist **Befund V-1** in Reinform
(*„version muß eindeutig sein"*): wer daraus ein Paket geschnürt hätte, hätte
zwei verschiedene Bauten unter derselben Kennung ausgeliefert. Die Nummern
stehen deshalb **sofort** auf 7.2.0.30 / 1.0.30, lange vor dem nächsten Paket.

## 7.2.0.29 — Acht Befunde des Prüfers und sieben aus der neuen Schranke

**Was Gregor damit tun kann, was vorher nicht ging:** den Trennbalken ziehen
und dabei **sehen**, wohin (E-54); den Registerkartenstreifen in den
Einstellungen wieder **abschalten** (E-56); rechts im Streifen klicken, ohne
dass sich ein **Browser** öffnet (E-58). Dazu drei Fehler, die noch nicht
aufgefallen sind, aber Schaden anrichten konnten (E-57, E-60, E-61), und der
leere Streifen unter der Werkzeugleiste ist weg (E-55).

**Von Gregor am 09.09.2026 an Paket 1.0.29 bestätigt** — die sechs Prüfpunkte
unten hat er einzeln durchgegangen: *„1-6, ok."* Dazu ungefragt: *„rechtklick
zeigt ja einen liste der offenen fenster: sehr gut."*

**Ein Restfehler steht, bewusst zurückgestellt (E-63):** *„alle karten, bis
auf die letzte (warum?) zeigen einen tooltip beim maus over. beim letzten
(ganz rechts) nicht."* Seine Entscheidung: *„bau mir mit dem bug ein 0.29
release auf github. den fehler notieren wir, wird im nächsten release
behoben."* Der Verdacht dazu steht in [BEFUNDE.md](BEFUNDE.md) unter **E-63**,
samt der Messung, die ihn widerlegen würde.

Acht davon kommen aus **PRÜFERs sechstem Durchgang** über die A-3/A-4-Arbeit,
sieben weitere aus dem ersten Lauf der Schranke, die daraus entstanden ist
(**E-62**, unten).
Sie wurden bewusst in **einem** Bau zusammengefasst: ein Bau kostet rund zwölf
Minuten, weil `OTShim.h` über `stdafx.h` im vorkompilierten Kopf liegt und
jede Änderung daran alle 364 Quellen neu übersetzt (siehe *Warum das Bauen so
lange dauert* unten).

### Was Gregor sieht

| Befund | Vorher | Jetzt |
|---|---|---|
| **E-54** | der Ziehrahmen war beim Ziehen **nach rechts unsichtbar** — man zog ins Blinde | er wird auf dem **Bildschirm** gezeichnet, wie MFC es beim Ziehen von Leisten macht, und ist über die ganze Strecke zu sehen |
| **E-55** | ein **acht Pixel hoher leerer Streifen** unter der Werkzeugleiste | weg — der Greifstreifen entsteht nur noch links, rechts und unten |
| **E-56** | *Show MDI task bar* **abschalten** ließ den Kartenstreifen stehen | er verschwindet |
| **E-58** | ein Klick in den **rechten Rand** des Streifens öffnete den **Browser**, ohne dass dort etwas zu sehen war | kein Treffer, solange das Logo nicht gezeichnet wird |

### Was er nicht sieht, was aber wichtiger ist

| Befund | Was passieren konnte |
|---|---|
| **E-57** | `IsTabLabelTruncated` legte bei **jeder Mausbewegung** über dem Streifen eine `CPaintDC` an — außerhalb von `WM_PAINT`. `BeginPaint` erklärt den Ungültigkeitsbereich für erledigt, **ohne zu malen**: was gerade neu gezeichnet werden sollte, wurde verworfen. Das ist Gregors Satz *„hier ist kein refresh drin"*, und er galt weiter, obwohl E-52 behoben war |
| **E-60** | ein Trennbalken konnte **während des Ziehens gelöscht** werden. `Track` verteilt fremde Nachrichten, eine davon löst einen Anordnungsdurchlauf aus — und der lief durch `EndRecycleSplitters`, das genau das Objekt löschte, in dessen Methode man noch stand. Neu ist die Marke `m_bTracking`, die Freigabe **und** Löschen fernhält |
| **E-61** | `Track` **verschluckte `WM_QUIT`**. `PeekMessage` mit `PM_REMOVE` nimmt die Nachricht aus der Schlange; wer sie nicht zurückstellt, hat das Beenden des Programms verschluckt — **genau die Fehlerklasse aus Kriterium 7**, diesmal von mir selbst neu eingebaut. Jetzt wird sie mit `::PostQuitMessage` zurückgestellt und das Ziehen abgebrochen |
| **E-59** | `m_cxTab` wurde nur in `OnPaint` gesetzt. Alles, was die Kartenbreite braucht, **ohne zu malen** — `TabHitTest`, `QCGetTabRect`, `CalcLogoTopLeft` —, rechnete zwischen einer Änderung und dem nächsten Malen mit dem alten Wert, und ein Klick traf die Nachbarkarte |

### E-58 war eine Rückentwicklung, die ich selbst eingebaut habe

`CalcLogoTopLeft` prüft die Trefferlage **nur über x**:

```cpp
if (nLeftEdge > 0 && (!pIntersectPoint || pIntersectPoint->x >= nLeftEdge))
```

Ein y-Vergleich fehlt ganz. Getroffen war damit der **gesamte rechte
Fensterrand**, nicht die 111 × 23 Pixel des Logos. Und das Logo wird
überhaupt nicht gezeichnet, weil `OnDrawBorder` in dieser Ersatzschicht von
niemandem gerufen wird — im Original tat das `SECWorkbook::OnPaint`.

Das war jahrelang harmlos, weil `QCWorkbook::OnLButtonDown` die Frage **nur
bei `m_bWorkbookMode`** stellt (`workbook.cpp:1132`) — und der Schalter ist
erst seit **A-3** an. Also eine Rückentwicklung aus 1.0.25 bis 1.0.28, die
niemand gemeldet hat, weil ein Browserfenster nach einem Klick ins Leere nicht
wie ein Programmfehler aussieht.

Die Trefferprüfung liefert jetzt `FALSE`, solange nichts gezeichnet wird. Der
Weg über `TopLeft` bleibt unberührt: wer `OnDrawBorder` wieder ruft, bekommt
die Stelle nach wie vor — dann, und erst dann, gehört dort eine vollständige
Prüfung gegen das Rechteck hin, samt y.

### E-62 — die neue Schranke fand beim ersten Lauf sieben weitere Stellen

Aus E-51 und E-61 ist `tools/pruefe-nachrichtenschleife.pl` entstanden: eine
eigene Nachrichtenschleife muss `WM_QUIT` zurückstellen und darf nicht ohne
Zeitschranke warten. Beim **ersten Lauf über den ganzen Baum** hat sie
**sieben weitere Stellen** gemeldet — alle in **Eudoras eigenem Code**, keine
aus der Portierung.

| Stelle | Was passierte |
|---|---|
| `EscapePressed` (`guiutils.cpp:1666`) | wird während **langer Vorgänge** gerufen, also gerade beim Mailabruf — und nahm dabei `WM_QUIT` heraus, ohne sie zurückzustellen |
| `LeftClickAttachment` (`guiutils.cpp:2910`) | **hängt**, siehe unten |
| `SyncPlayMedia` (`guiutils.cpp:3387`) | verschluckte das Beenden, während ein Anhang abgespielt wird |
| `CTocView::SizeColumn` (`tocview.cpp:3458`) | **hängt**, siehe unten |
| `CTocFrame::DoPreviewDisplay` (`TocFrame.cpp:3673`) | verschluckte das Beenden beim Warten auf die Vorschau |
| `CTridentView::DoFindFirst`, zwei Schleifen | dasselbe beim Suchen |
| `CTridentView::Print` | dasselbe beim Drucken, dazu bliebe `SetRedraw(FALSE)` stehen |

**Zwei davon hängen, statt nur zu verschlucken.** `LeftClickAttachment` und
`CTocView::SizeColumn` warten so:

```cpp
while (1)
{
    MSG msg;
    GetMessage(&msg, m_hWnd, 0, 0);   // Rueckgabewert wird nicht ausgewertet
    ...
}
```

`WM_QUIT` kommt **trotz** Fensterfilter — so ist `GetMessage` dokumentiert.
Der Rückgabewert wird dann 0, aber `while (1)` fragt ihn nicht, und die
Nachricht ist verbraucht. Die Schleife wartet danach **für immer** auf eine
Nachricht, die nie mehr kommt, und hält dabei den Mausfang. Bei `SizeColumn`
genügt dafür das Ziehen einer **Spaltenbreite** im Postfachfenster.

Damit ist eine mögliche Ursache von Gregors *„beenden kann ich es auch nicht"*
benannt, die **nicht** aus der Portierung stammt, sondern im Original steht —
und die man von Hand kaum findet, weil sie nur in einem bestimmten Moment
zuschlägt.

### Warum das Bauen so lange dauert

Gregor am 09.09.2026: *„schau nach, warum das bauen so lange dauert"*. Die
Antwort ist eine Include-Kette:

`Eudora71/Eudora/stdafx.h:52` → `OTShimAll.h` → `OTShim.h`

Damit liegt die **Ersatzschicht im vorkompilierten Kopf** aller 364 Quellen
des Eudora-Projekts. Jede Änderung an `OTShim.h` macht ihn ungültig, und alle
364 werden neu übersetzt — gemessen 357 von 371 Objektdateien. Es genügt
sogar ein `git switch`, das nur den Zeitstempel der Datei anfasst.

| Abschnitt | Dauer |
|---|---|
| Neuübersetzen nach einer Änderung an `OTShim.h` | ~7 min |
| zweiter Durchlauf für `EudoraRes` und `Eudora` mit `/p:BuildProjectReferences=false` (nötig, weil `OT501` als Projektverweis scheitert) | ~5 min |
| Paket schnüren und prüfen | ~3 min |

Deshalb wurden diese acht Befunde in **einem** Bau zusammengefasst statt
einzeln geliefert.

### Was an 1.0.29 zu prüfen ist

Auspacken und **`Eudora starten.cmd`** doppelklicken. Titelzeile:
`Eudora 7.2.0.29 / Paket 1.0.29`.

1. **Trennbalken links, nach rechts ziehen** — ist der Ziehrahmen die ganze
   Strecke über **zu sehen** (E-54)? Wird der linke Bereich breiter?
2. Nach links ziehen — wird er wieder schmaler? **Friert nichts ein?**
3. **Unter der Werkzeugleiste** — ist dort ein leerer Streifen (E-55)? Sollte
   weg sein.
4. *Tools → Options → Interface*, **Show MDI task bar abschalten** — ist der
   Kartenstreifen weg (E-56)? Wieder einschalten — ist er wieder da?
5. **Rechts im Kartenstreifen klicken**, hinter der letzten Karte — öffnet
   sich ein **Browser** (E-58)? Sollte nicht.
6. Maus über eine Karte mit langem Titel halten — kommt der Kurzhinweis, und
   bleibt die Anzeige daneben **richtig** (E-57)?
7. *File → Exit* während nichts gezogen wird — beendet es sauber (E-61 darf
   Kriterium 7 nicht beschädigt haben)?

## 7.2.0.28 — Beim Schließen bleibt kein Strich stehen

**Was Gregor damit tun kann, was in 1.0.27 nicht ging:** ein Fenster schließen,
ohne dass an der Stelle der verschwundenen Registerkarte eine Linie
zurückbleibt.

**Von Gregor noch nicht bestätigt.**

### E-53 — eine Unsymmetrie in meinem eigenen Code

> *„schönheitsfehler beim schließen, da bleibt ein strich übrig."*

`StreifenAuffrischen` erklärt den Registerkartenstreifen mit
`InflateRect(2, 2)` für ungültig — gefüllt wurde in `OnPaint` aber nur der
Streifen **ohne** diesen Rand. Die zwei Pixel ringsum blieben also stehen, und
genau dort liegen die Kanten, die `QCWorkbook::GetTabPts` um (+2,−2)
verschiebt. Jetzt wird gefüllt, was auch für ungültig erklärt wird; beide
Stellen benutzen denselben Betrag.

### Zwei Schranken gegen Fehler in meiner Arbeitsweise

Diese Fassung bringt keinen weiteren Programmcode, aber zwei Werkzeuge, die
zwei Fehler von mir künftig verhindern:

**`tools/release-veroeffentlichen.ps1`** — der einzige erlaubte Weg zu einem
Release. Ich hatte v1.0.27 veröffentlicht, **bevor** Gregor es geprüft hatte;
sein Befund E-53 kam danach, und die Fassung war released und fehlerhaft
zugleich. Seine Anweisung: *„erst teste ich hier lokal, wenn ich es für gut
befunden habe, kannst du ein github release bauen."* Das Werkzeug verlangt
seine Freigabe im Klartext und eine Bestätigung im CHANGELOG-Abschnitt der
Fassung; steht dort „noch nicht bestätigt", weist es ab.

**`tools/bauen.ps1` weist ungesicherte Quelldateien ab.** Während ein Bau
lief, hat Gregor gemergt und danach `git checkout main --force` gefahren —
drei Änderungen von mir waren weg, darunter die E-53-Behebung selbst.
Rekonstruierbar nur, weil die Vorlagen zufällig noch im Kladdenordner lagen.
Der Auslöser ist immer derselbe: ein Bau dauert Minuten, in denen ich nichts
tue und er weiterarbeitet. Wegwerfbauten gehen weiter mit `-Ungesichert`.

### Was an 1.0.28 zu prüfen ist

Auspacken, **`Eudora starten.cmd`**. Titel: `Eudora 7.2.0.28 / Paket 1.0.28`.

1. Mehrere Fenster öffnen, dann eines **schließen** — bleibt ein Strich?
2. Und weiter offen aus 1.0.27: bleibt der Trennbalken nach dem Verbreitern
   greifbar, stehen die Karten einfach statt doppelt, überlebt die Breite
   einen Neustart, und **friert nirgends etwas ein**?

## 7.2.0.27 — Der Trennbalken bleibt greifbar, die Karten stehen nicht doppelt

**Was Gregor damit tun kann, was in 1.0.26 nicht ging:** den linken Bereich
verbreitern und **gleich weiterziehen** — der Balken bleibt an der Kante
greifbar, ohne dass man erst das Fenster verändern muss. Und die
Registerkarten stehen danach nicht mehr doppelt.

**Das seitliche Ziehen hat Gregor noch nicht beurteilt.** Bestätigt ist der
Gegenfall, die Höhe: *„verschieben rauf / runter — bug gefixt, die anzeige ist
korrekt."*

### Seine Meldung war die Diagnose

> *„verschieben links / rechts vom mailverzeichnis: hier ist kein refresh
> drin. nach vergrößern (verschiebung nach rechts), kann man den balken nicht
> mehr greifen. erst wenn ich das fenster verändere, dann geht es wieder."*

Der letzte Halbsatz nennt die Ursache: MFC verschiebt die Leisten mit
`DeferWindowPos` (`lpLayout->hDWP`). Wenn `OnSizeParent` zurückkommt, hat die
Andockleiste ihre neue Größe **noch nicht** — `GetClientRect` liefert dort die
**alte**. Der Balken landete an der alten Stelle, und erst der nächste
Anordnungsdurchlauf zog es gerade. Das war „das Fenster verändern".

Behoben, indem der Balken in **`OnSize`** entsteht statt in `OnSizeParent`:
`WM_SIZE` kommt, nachdem das Fenster seine Größe hat.

Die doppelten Karten in seinem Bildschirmfoto — *„In"* und *„markus bakus,
10:02"* je zweimal — kamen aus derselben Wurzel: `RecalcLayout` ordnet neu an,
erklärt aber nichts für ungültig, was an der alten Stelle stand.
`OnSplitterMoved` frischt jetzt mit
`RDW_INVALIDATE | RDW_ERASE | RDW_ALLCHILDREN` auf.

**Bestätigt ist der Gegenfall**, und er stützt die Deutung: *„verschieben rauf
/ runter — bug gefixt, die anzeige ist korrekt."* Bei der Höhe greift dasselbe
Auffrischen schon seit 1.0.26.

### Was an 1.0.27 zu prüfen ist

Auspacken, **`Eudora starten.cmd`**. Titel: `Eudora 7.2.0.27 / Paket 1.0.27`.

1. Linken Bereich nach rechts ziehen — und **gleich noch einmal** ziehen,
   ohne etwas anderes anzufassen. Bleibt der Balken greifbar?
2. Stehen die Registerkarten danach **einfach** da, nicht doppelt?
3. Beenden und neu starten — ist die Breite noch da?
4. Und weiter der wichtigste Punkt: **friert irgendwo etwas ein?**

## 7.2.0.26 — Der linke Bereich lässt sich breiter ziehen, und die Karten frischen auf

**Was Gregor damit tun kann, was vorher nicht ging:** den Trennbalken zwischen
Postfachbereich und Nachrichtenliste mit der Maus nach rechts ziehen und so
links mehr sehen (Anforderung **A-4**). Dazu drei Nachbesserungen an der
Registerkartenleiste, die er selbst gefunden hat (**E-50**).

**Beides von Gregor noch nicht bestätigt.** Beim Ziehen kann ich es
grundsätzlich nicht selbst messen — dazu braucht es eine **physisch**
gedrückte Maustaste; siehe unten, warum das so sein muss.

### A-4 — drei Anläufe, zwei davon am laufenden Programm widerlegt

Die Splitter-Mechanik lag vollständig in der Ersatzschicht — `AddSplitter`,
`HitTest`, `StartTracking`, `CalcTrackingLimits`, `DrawTrackerRect`, dazu
`OnSetCursor` und `OnLButtonDown`. Nur wurde `AddSplitter` nie aufgerufen,
`Track` war leer und `OnSplitterMoved` tat nichts. Und ein Balken braucht
Platz **im Clientbereich der Andockleiste** — liegt er unter dem Kindfenster,
gehen die Mausereignisse dorthin.

| Anlauf | Messung | Urteil |
|---|---|---|
| 1. über `SetBorders` | Andockleiste Client **176**, Leiste 318 **180** | verworfen: der Rand verkleinert den Innenbereich und vergrößert die Andockleiste **nicht**; die Leiste ragte über |
| 2. Zuschlag in `CalcFixedLayout`, abhängig von einer eigenen Prüfung über `m_arrBars` | Andockleiste blieb **180** | verworfen: keine Wirkung — die Bedingung griff nicht |
| Messversuch: Zuschlag **11**, bedingungslos | Andockleiste **187**, freier Streifen **7** | belegt: der Weg stimmt, und **MFC verbraucht 4 Pixel des Zuschlags selbst** |
| 3. Bedingung am Ergebnis, Balken nach dem **nachgemessenen** Platz | Andockleiste **188**, freier Streifen **8** | steht |

Aus dem Messversuch folgt die eigentliche Lehre: eine feste Pixelzahl wäre
hier immer geraten gewesen. `OnSizeParent` misst deshalb den Unterschied
zwischen Andockleiste und Leiste darin und legt den Balken genau dorthin.
Bleiben weniger als zwei Pixel, gibt es lieber **keinen** Balken als einen,
den niemand trifft.

`OnSplitterMoved` ändert die Andockgröße über `GetBarInfo`/`SetBarInfo` —
genau die Felder, die `SECControlBar::CalcFixedLayout` auswertet. Damit
überlebt die neue Breite einen Neustart, denn den `[ToolBar…]`-Abschnitt in
der `Eudora.ini` gibt es seit der Behebung von **E-43** überhaupt erst.

### Die Ziehschleife hätte Eudora einfrieren können

Der erste Entwurf von `Splitter::Track` lief mit `while(::GetMessage(...))`.
Zweimal hat das die Prüfinstanz zum **Hängen** gebracht: kommt kein
`WM_LBUTTONUP` — weil der Mausfang verlorengeht, das Fenster den Fokus
verliert oder die Nachricht auf anderem Weg verschwindet —, wartet die
Schleife für immer, und das Programm ist tot. Genau die Fehlerklasse, die
Gregor tagelang gekostet hat (*„beenden kann ich es auch nicht"*).

Jetzt: höchstens 100 ms warten, danach Fenster, Mausfang und die **physische**
Maustaste erneut prüfen. Ist sie los, ist das Ziehen vorbei, ganz gleich
welche Nachricht kam. Der Preis ist ehrlich zu nennen: ein künstlicher Zug
über Fensterbotschaften lässt sich damit nicht mehr fahren, das Ziehen kann
nur ein Mensch prüfen. Eine Schleife, die sich bequem testen lässt, aber das
Programm einfrieren kann, wäre der schlechtere Tausch.

### E-50 — drei Nachbesserungen an der Registerkartenleiste

Alle drei von Gregor am 09.09.2026 an 1.0.25 gefunden, alle mit derselben
Wurzel: **der Streifen wird nur beim Neuzeichnen gemalt, und niemand erklärt
ihn für ungültig, wenn sich etwas ändert.**

| Beobachtung | Ursache | Behebung |
|---|---|---|
| *„der button bzw. die karte bleibt eingedrückt, auch wenn man im anderen fenster ist"* | `QCWorkbook::OnLButtonDown` setzt `SetSelected(TRUE)` (`workbook.cpp:1109`) — und **niemand** setzt es je zurück; im Original tat das die Stingray-Ebene | die Marke wird gelöscht, sobald ein anderer Rahmen aktiv ist. Sie bedeutet laut eigenem Feldkommentar nur *„Karte gewählt, Rahmen noch nicht aktiv"* |
| *„beim skalieren (kleiner machen) ist die darstellung falsch"* | die Kartenbreite hängt an der Fensterbreite (`recalcTabWidth` teilt die Fläche auf) | `WM_SIZE` frischt den Streifen auf |
| *„die karten sind dann weg"* beim Öffnen/Schließen | dieselbe Sache: die Breite ändert sich mit der Kartenzahl | `AddSheet`/`RemoveSheet` frischen auf |

### Was an 1.0.26 zu prüfen ist

Auspacken und **`Eudora starten.cmd`** doppelklicken. Titelzeile:
`Eudora 7.2.0.26 / Paket 1.0.26`.

**A-4, der Trennbalken:**

1. Maus auf die Kante zwischen Postfachbereich und Nachrichtenliste — wird
   der Zeiger zum **Größenzeiger** (Doppelpfeil)?
2. Nach **rechts ziehen** — wird der linke Bereich breiter? Über 180 Pixel
   hinaus?
3. Nach links ziehen — wird er wieder schmaler?
4. Eudora beenden und neu starten — ist die Breite noch da?
5. **Und das Wichtigste: friert dabei nichts ein.** Falls doch, sofort sagen —
   dann fliegt A-4 wieder heraus.

**A-3, die Registerkarten:**

6. Bleibt die Karte des **aktiven** Fensters eingedrückt und lösen sich die
   anderen?
7. Fenster kleiner ziehen — bleiben die Karten richtig?
8. Fenster öffnen und schließen — bleiben die Karten sichtbar?

## 7.2.0.25 — Die offenen Fenster stehen als Registerkarten unten

**Was Gregor damit tun kann, was vorher nicht ging:** unten am Fenster steht
für jedes offene Fenster eine Registerkarte, wie die Reiter in einem Browser —
statt nur der Liste im Menü *Window*. Das ist Anforderung **A-3** und der
fehlende Teil von **Kriterium 8**.

**Von Gregor noch nicht bestätigt.** Gemessen und fotografiert habe ich es
(zwei offene Fenster → zwei beschriftete Karten, `In` und
`No Recipient, No S…`, die aktive hervorgehoben). Was ich von außen kaum
messen kann, ist der **Klick**: holt eine Karte ihr Fenster nach vorn?

### Die Leiste war nicht weg — sie war abgeschaltet

Das Hauptfenster heißt nicht zufällig `QCWorkbook`: Stingrays *Workbook* ist
genau so eine Reiterleiste. Eudoras Code dafür liegt vollständig im
Quellbaum — Zeichnen, Geometrie, Treffertest, Kurzhinweise, Kontextmenü, der
Ein-/Ausschalter in den Einstellungen und der INI-Schlüssel `ShowMDITaskbar`
mit der Vorgabe **1**. `mainfrm.cpp:1042` schaltet die Leiste bei **jedem**
Start ein. Nur nahm die Ersatzschicht den Schalter nicht an.

### Vier Ursachen, jede einzeln gemessen

| | war | ist |
|---|---|---|
| `SECWorkbook::SetWorkbookMode` | Attrappe: meldete „nicht umgesetzt" und setzte `m_bWorkbookMode` **absichtlich nicht** | setzt den Betrieb und reserviert den Streifen |
| `SECWorkbook::GetTabPts` | lieferte **sechs Nullpunkte** — Eudora zeichnete jede Karte an Punkt (0,0) mit Größe null | echte Kartenform aus sechs Punkten; gezählt werden nur **sichtbare** Blätter |
| `recalcTabWidth()` | **liefert** die Breite nur zurück und setzt `m_cxTab` nicht; ich hatte den Rückgabewert weggeworfen | `m_cxTab = recalcTabWidth()` |
| Streifenlage | begann bei `rectClient.left` = 0 — dort liegt die **linke Leiste** (Client-x 6…186). Karte 0 verschwand darunter, sichtbar war nur der Rand von Karte 1 bei x 182…262 | beginnt und endet am **MDI-Bereich** |
| Beschriftung | `OnDrawTab` zeichnet nur den **Rahmen** | `OnDrawTabIconAndLabel` wird mitgerufen — virtuell, von Eudora überschrieben, von niemandem aufgerufen |

Die dritte Zeile ist die lehrreichste: die Streifenlage stammt aus Eudoras
eigener Rechnung (`QCGetTaskBarRect`, `workbook.cpp:930`), die dort ebenfalls
`rectClient.left` nimmt. Im Original hat das gepasst; bei uns reicht die
linke Wazoo-Leiste bis ganz nach unten. Das ist eine **bewusste Abweichung
vom Original**, und sie steht als solche im Quelltext.

### Am Werkzeug

`tools/leisten-messen.ps1` misst jetzt auch den Streifen — Unterkante des
MDI-Bereichs gegen den Rahmen — zählt die offenen MDI-Fenster und kann mit
`-Abbild` ein Bild des Fensters speichern. Das Bild entsteht über
**`PrintWindow`**, nachdem der erste Versuch mit einem Bildschirmabzug ein
fremdes Dialogfenster mitfotografiert hatte und die Messung damit wertlos
war, ohne dass es auffiel.

### Was an 1.0.25 zu prüfen ist

Auspacken und **`Eudora starten.cmd`** doppelklicken. Titelzeile:
`Eudora 7.2.0.25 / Paket 1.0.25`.

1. Steht unten je offenem Fenster eine **Registerkarte**?
2. **Holt ein Klick auf eine Karte ihr Fenster nach vorn?** — der wichtigste
   Punkt.
3. Ändert sich der Streifen beim Öffnen und Schließen eines Fensters?
4. Sind die Beschriftungen dieselben wie im Menü *Window*?
5. Schaltet *Show MDI task bar* in den Einstellungen die Leiste aus und wieder
   ein, und überlebt das einen Neustart?

## 7.2.0.24 — Eine Ursache, vier Befunde: das Konto-Löschen geht wieder

**Was Gregor damit tun kann, was vorher nicht ging:** ein Konto löschen, ohne
dass „Encountered an improper argument" erscheint und der Eintrag links stehen
bleibt. Und die Fenstergrößen und Leistenlagen überleben jetzt einen Neustart —
sie wurden bisher **nie** gespeichert.

**Von Gregor am 08.09.2026 bestätigt:** *„0.24 – persona läßt sich löschen. keine messagebox“*. Damit
ist die ganze Kette belegt – nicht nur am Quelltext abgelesen, sondern am
laufenden Programm.

### Die eine Ursache: `SECControlBar` war zweimal definiert

Zwei Definitionen derselben Klasse, und der Ersatz hat ein Feld mehr:

| | |
|---|---|
| `OT501/Include/sbarcore.h:118` | Original-`SECControlBar` |
| `OTShim/OTShim.h:496` | Ersatz-`SECControlBar`, **ein Feld mehr**: `int m_nRowExtent` (`:533`) |
| `OTShim/OTShim.h:984` | setzt `__SBARCORE_H__` |
| `OTShim_Werkzeugleiste.h:84` | band unter `#ifndef __SBARCORE_H__` das **Original** ein |

Welche Fassung eine Übersetzungseinheit zu sehen bekam, hing damit allein an
der Einbindereihenfolge: `QCCustomToolBar.cpp` sieht über `stdafx.h` →
`OTShimAll.h` → `OTShim.h` den **Ersatz**, `OTShim_Werkzeugleiste.cpp` bindet
nur den eigenen Header ein und sah das **Original**. Compilerschalter und
Include-Pfade sind sonst gleich — nachgemessen aus dem echten Compileraufruf
in `Eudora.tlog/CL.command.1.tlog`, einziger Unterschied `/Yu"stdafx.h"`.

Folge: das Knopffeld `m_btns` lag in beiden Übersetzungseinheiten **acht Byte
auseinander**. Der Binder nimmt eine Fassung, der übrige Code liest daneben.

**Gemessen, vorher:**
```
Versatz=488  GetBtnCount=24/24  m_btns.GetSize=0/0  roh[0..4]=24,25,0,0,0
```
**Nachher:**
```
Versatz=488  GetBtnCount=24/24  m_btns.GetSize=24/24  roh[0..4]=15146180,10425560,24,25,0
```
`24` und `25` sind Anzahl und Kapazität des Knopffeldes; sie liegen jetzt dort,
wo `CPtrArray` sie hat, statt acht Byte davor.

Behoben, indem `OTShim_Werkzeugleiste.h` die **Ersatzschicht** einbindet
(`#include "OTShim.h"`) statt des Originals.

### Was alles daran hing

| Befund | Wie er zusammenhängt |
|---|---|
| **E-43** | `SaveCustomInfo` warf bei **jedem** Beenden → der Leistenzustand wurde **nie** gespeichert. Jetzt: **13** `[ToolBar…]`-Abschnitte in der `Eudora.ini` statt **0**, und keine `E-42`-Zeile mehr |
| **E-37** | `CPersonality::Remove` löscht den INI-Abschnitt und ruft dann `DeleteCommand` → `NotifyClients(CA_DELETE)` → `QCCustomToolBar::Notify` (`:951`), wo in `:970` dasselbe Muster steht. Der Wurf fliegt aus `Remove()` heraus, der Anzeige-Code darunter wird nie erreicht. Belegt durch die Abwesenheit jeder Spur: **keine einzige E-37-Marke** in Gregors Protokoll |
| **E-38** | war **gar kein Fehler**. Gregor am 08.09.2026: *„nach dem löschen eines kontos, wenn das konto noch sichtbar ist, dann fehlen die daten in den eigenschaften … beim neuen konto sind sie zu sehen."* Die leeren Felder gehörten zu einem Geistereintrag, den E-37 in der Liste stehen ließ |
| **E-34** | dasselbe Muster an einer dritten Stelle (`QCChildToolBar::GetButton`) — die dortige Umgehung bleibt, die Wurzel ist jetzt weg |

### Die Schranke dazu

`tools/pruefe-waechter.pl`: bindet ein Header der Ersatzschicht ein
OT501-Original ein, dessen Wächter **irgendeine** Ersatzdatei setzt, muss
sichergestellt sein, dass der Wächter dann immer schon steht. Sie fand genau
einen Verstoß — den echten — und ließ den legitimen Fall durch
(`OTShim.h:1052`, Wächter steht ab `:985`).

Die zugehörige Lehre `Arbeitsweise/teilweise-ersetzte-header.md` gibt es seit
dem **30.08.2026**. Sie hat neun Tage lang nichts verhindert. Das ist der
Grund, warum aus Lehren jetzt Schranken werden.

### Neu: `tools/testlauf.ps1`

Nachdem ich am 08.09.2026 **viermal unangekündigt** eine Eudora-Instanz
gestartet hatte — Gregor: *„hast du was gestartet?"*, *„absprache?"* — ist das
Starten zum Messen an ein Werkzeug gebunden, das erzwingt: eine **Freigabe** im
Klartext, Verzeichnis nur unter `C:\Temp`, **gleiche Dateiversion** von
`Eudora.exe` und `EudoraRes.dll`, Beenden per Fensterbotschaft an ein
**gemessenes** Handle, Aufräumen immer nach Pfad gefiltert, und jeder Lauf mit
Freigabetext in `tools/TESTLAEUFE.md`.

Die Versionsprüfung stammt aus einem eigenen Fehler desselben Tages: ich hatte
nur die `Eudora.exe` ins Testverzeichnis kopiert, nicht die `EudoraRes.dll`.
Eudora brachte darauf *„Eudora has loaded a Resource DLL that does not match
this version of Eudora"* auf Gregors Bildschirm, und meine Messung war wertlos,
ohne dass ich es merkte.

### Was an 1.0.24 zu prüfen ist

Auspacken und **`Eudora starten.cmd`** doppelklicken; von Hand wäre es
`Eudora.exe "<Pfad>\Mailverzeichnis"`. Die Titelzeile muss
`Eudora 7.2.0.24 / Paket 1.0.24` nennen.

1. **Ein Konto löschen** (E-37): verschwindet der Eintrag links **sofort**,
   ohne Neustart? Kommt noch „Encountered an improper argument"?
2. **Fenster verschieben, beenden, neu starten** (E-43): steht die
   Werkzeugleiste wieder da, wo sie war? In der `Eudora.ini` müssen jetzt
   `[ToolBar…]`-Abschnitte stehen.
3. **Beenden** über alle drei Wege: *File → Exit*, Alt-F4, das Kreuz.
4. **Eine Nachricht anzeigen**, bei der bisher „Encountered an improper
   argument" kam — gut möglich, dass sie mit weg ist.

## 7.2.0.23 — Die Statusleiste liegt unten, und ein Prozess ohne Fenster kann nicht mehr entstehen

**Was Gregor damit tun kann, was vorher nicht ging:** *Task Status* und *Task
Errors* liegen jetzt **waagrecht am unteren Fensterrand**, über die ganze
Breite, und bleiben dort — statt als schmale senkrechte Spalte links neben dem
Postfach zu stehen. Von Gregor am 08.09.2026 an der Prüfinstanz bestätigt:
*„jetzt ist sie unten, ja"*. Damit ist Anforderung **A-2** aus
[ZIEL.md](ZIEL.md) umgesetzt.

### A-2/E-44 — zwei Ursachen, nicht eine

Der erste Verdacht war falsch: die Leiste wird **nicht** links angedockt. An
einem frischen Profil gemessen (`tools/leisten-messen.ps1`, neu in diesem
Stand) lag sie von Anfang an richtig — **unten, 1712×80** — und wurde nur
unmittelbar danach durch `ID_SEC_HIDE` wieder **versteckt**
(`WazooBarMgr.cpp`, `SetDefaultWazooBarState`, Fall 2). Diese Zeile ist weg.

Das erklärte aber nicht Gregors Bildschirmbild. Dafür gab es eine zweite,
unabhängige Ursache: der Standardzweig läuft **nur beim allerersten Start**.
Ab dem zweiten greift `LoadWazooConfigFromIni` — und das stellt nur wieder
her, *welche* Fenster in einer Leiste sitzen, **nicht die Andockseite**. Die
käme aus MFCs `LoadBarState` und damit aus dem INI-Abschnitt `[ToolBar...]`,
den es nicht gibt, weil `SaveBarState` beim Beenden jedes Mal abbricht
(**E-43**). Nachgemessen: weder Gregors `Eudora.ini` noch die eines frischen
Profils enthält einen solchen Abschnitt — **null Treffer** in beiden. Alle drei
Leisten blieben deshalb auf `CBRS_LEFT` aus `CreateInitialWazooBars` stehen.

Jetzt zieht der Lade-Zweig die Standardanordnung nach, **wenn** eine Leiste an
keiner Andockleiste hängt (`m_pDockBar == NULL`) — dieselbe Prüfung, die das
Projekt an anderer Stelle selbst benutzt. Ist eine Lage gespeichert, ändert
sich nichts. Ergebnis: Postfächer links sichtbar, Kurznamen versteckt,
Aufgabenstatus waagrecht unten sichtbar.

> **Nachgebessert nach Gregors Bildschirmfoto:** im ersten Anlauf blieb die
> **Kurznamen-Leiste** als 180 Pixel breite Spalte rechts dauerhaft offen. Die
> Sichtbarkeit einer Wazoo-Leiste wird nirgends gespeichert (nachgesehen in
> `SaveWazooConfigToIni`) — was ohne Zutun sichtbar bleibt, ist also keine
> Entscheidung des Anwenders, sondern nur das `WS_VISIBLE` aus `Create`.
> Deshalb läuft die Sichtbarkeitsstufe jetzt mit.

### E-45 — der eine Aufräumschritt, der nicht übersprungen werden darf

Gefunden von **PRUEFER** ([Befunde/PRUEFER-5.md](Befunde/PRUEFER-5.md)) als
Fehler in **meiner** E-42-Behebung. Von den zwölf mit `AUFRAEUMEN` gefassten
Schritten ist einer nicht bloß Aufräumen: `QCWorkbook::OnClose` löst sich auf
`CFrameWnd::OnClose` auf, und deren **letzte** Anweisung ist `DestroyWindow()`
(MFC 14, `winfrm.cpp:941`); `CMainFrame::OnClose` ruft es nirgends selbst.
Fiele der Schritt aus, gäbe es kein `WM_QUIT`, kein `ExitInstance` und kein
`IniStringCleanUp` — und das Fenster ist von `HideApplication` schon
versteckt: übrig bliebe ein **Prozess ohne Fenster**, genau der Zustand, den
Gregor tagelang hatte. Dieser Schritt hat jetzt einen eigenen Fangzweig, der
`DestroyWindow()` nachholt.

### E-46 — ein Verdacht aufgestellt und in derselben Sitzung widerlegt

`CFrameWnd::PostNcDestroy` ist wörtlich `delete this`, `CMainFrame`
überschreibt es nicht, und `DestroyWindow()` stellt `WM_NCDESTROY` synchron
zu — der Aufruf steht aber **mitten** in `CMainFrame::OnClose`, danach laufen
noch rund 230 Zeilen. Wäre der Verdacht richtig, hätte **E-43** damit seine
Ursache gehabt. Entschieden an einer Marke im Destruktor: sie erscheint im
Protokoll **nach** `nach QCWorkbook::OnClose`, nicht dazwischen. **Widerlegt.**
Die Marke bleibt drin, weil sie die Reihenfolge dauerhaft belegt.

### E-43 — der Widerspruch ist jetzt eingegrenzt statt bloß benannt

Die verfeinerte Marke misst `GetBtnCount()` und `m_btns.GetSize()` **je
zweimal in einer Ausgabe**. Gemessen: `GetBtnCount=24/24
m_btns.GetSize=0/0`, gleiches `this`, gleiche Adresse. Damit sind ein Wettlauf
und ein freigegebenes Objekt **beide ausgeschlossen** — es bleibt, dass der
übersetzte Code an zwei Adressen liest, obwohl beide Ausdrücke wörtlich
derselbe Code sind (`OTShim_Werkzeugleiste.h:744`). Eine dritte Marke gibt
jetzt Versatz und Rohwörter des Feldes aus.

**Widerlegt, ebenfalls in dieser Sitzung:** PRUEFERs Befund, das Protokoll sei
im Normalbetrieb stumm. `DebugMask` ist zwar mit `0` vorbelegt, wird aber
sofort aus der INI gesetzt, und der Vorgabewert steht in der Ressource
(`EudoraRes.rc:8441`: `LogLevel\n25759`). 25759 ist 0x649F und enthält 0x80 —
die Marken werden **ohne jede Einstellung** geschrieben. Gegenprobe: Gregors
`Eudora.ini` hat keine Zeile `LogLevel`, und seine `eudora.log` enthält alle
Marken.

### Was an 1.0.23 zu prüfen ist

Paket: 9 340 228 Byte, SHA256
`3f58a93c85c8fbf9f206ccc319a4798bb40236f3b60821a3de6df17710139045`.
**Das ZIP liegt nicht mehr im Repo** — am 09.09.2026 entfernt, wie die der
übrigen überholten Fassungen, damit das Repo nicht weiter wächst. Neu zu bauen
aus dem Commit dieses Abschnitts mit
`tools/paket-bauen.ps1 -AusBauverzeichnis -Bauart Release`; die Prüfsumme
oben ist der Nachweis. Die Marke [v1.0.23](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.23)
bleibt bestehen.
Auspacken und **`Eudora starten.cmd`** doppelklicken. Wer lieber selbst
aufruft, nimmt `Eudora.exe "<Pfad>\Mailverzeichnis"` — das ist genau, was der
Starter tut, und von Gregor am 08.09.2026 nachgemessen. Was **nicht** geht, ist
`Eudora.exe` **ohne** Parameter beim ersten Start: dann sucht Eudora die Ini im
Programmverzeichnis, findet keine und legt eine leere Einrichtung an (Befund
**E-6**). Die Titelzeile muss
`Eudora 7.2.0.23 / Paket 1.0.23` nennen.

1. **Die untere Leiste** — *Task Status* und *Task Errors* liegen waagrecht am
   unteren Fensterrand, über die ganze Breite. **Von Gregor am 08.09.2026
   bestätigt:** *„leiste unten paßt."* Rechts darf **keine** Kurznamen-Spalte
   dauerhaft offenstehen.
2. **E-37, gelöschtes Konto** (steckt seit 1.0.22 drin, noch unbestätigt):
   eine Persönlichkeit anlegen und wieder löschen. Verschwindet der Eintrag
   links **sofort**, ohne Neustart? Kommt noch „Encountered an improper
   argument"?
3. **E-38, Assistentendaten** — jetzt erstmals messbar, weil der Blocker E-33
   weg ist: Konto über den Assistenten anlegen, Eudora **normal** beenden, neu
   starten, *Konto → Eigenschaften* ansehen. Stehen Name, Mailadresse und
   Server da?
4. **Das Beenden** über alle drei Wege: *File → Exit*, **Alt-F4**, das
   **Kreuz**.
5. **E-43** braucht nur einen normalen Beendigungsvorgang. Danach steht in
   `Mailverzeichnis\eudora.log` eine Zeile `E-43 SaveCustomInfo: … Versatz=…
   roh[0..4]=…` — die entscheidet, warum der Leistenzustand nie gespeichert
   wird.

### Neu im Werkzeugkasten

- `tools/leisten-messen.ps1` — misst Andockseite, Sichtbarkeit, Größe und Lage
  jeder Wazoo-Leiste eines laufenden Eudora und schreibt das Urteil zu A-2
  ausdrücklich hin. Der `-Pfadfilter` ist Absicht: auf Gregors Rechner läuft
  sein eigenes Eudora, gemessen werden soll die Prüfinstanz. Das Skript
  schickt keine Nachricht und beendet nichts.

## 7.2.0.22 / Paket 1.0.22 — 08.09.2026 · das Beenden funktioniert

**Gregors Urteil: *„schließen klappt jetzt."*** Alle drei Wege beenden Eudora —
*File → Exit*, **Alt-F4** und das **Kreuz** oben rechts. Damit ist
**Kriterium 7** aus [ZIEL.md](ZIEL.md) erfüllt, das letzte offene der zweiten
Stufe.

Ebenfalls von ihm bestätigt: *„default werte beim neuen persona konto für
'leave message on server' greifen."* — **Anforderung A-1** ist damit am
laufenden Programm belegt, nicht mehr nur am Codeweg.

Paket: 9 339 516 Byte, SHA256 `7ddab1a0f0fdf1c4458a7aa2ab00d2f1fbb15561ab576657c73006fcfa95586c`.
**Das ZIP liegt nicht mehr im Repo** — Gregor am 08.09.2026: *„0.22 brauche ich
nicht, wenn es ein 0.23 gibt"*. Anders als bei den übrigen entfernten Paketen
gibt es für 1.0.22 **keine Marke**; wer es wiederhaben will, baut es aus Commit
`d003d46` neu (`tools/paket-bauen.ps1 -AusBauverzeichnis -Bauart Release`) und
prüft die Prüfsumme oben nach.

### Der Grundsatz hinter der Behebung

**Ein Fehler beim Aufräumen darf das Beenden nicht verhindern.** Nur eine
bewusste Entscheidung des Anwenders — „Abbrechen" in einer Rückfrage — darf
das. Vorher reichte eine geworfene Ausnahme oder ein Dialog, der sich nicht
öffnen ließ: `AfxCallWndProc` fängt den Wurf, `CWinApp::ProcessWndProcException`
(`appcore.cpp:1009-1039`) zeigt „Encountered an improper argument" und liefert
**0** — damit gilt `WM_CLOSE` als beantwortet, und das Fenster bleibt stehen.

### E-40 — eine Rückfrage, die sich nicht stellen lässt, galt als „Abbrechen"

`CDoc::SaveModified` (`Eudora71/Eudora/doc.cpp`) und `CMessageDoc::SaveModified`
(`Eudora71/Eudora/msgdoc.cpp`) hatten im `default`-Zweig nur `ASSERT(FALSE)` und
`return FALSE`. **`IDCANCEL` hat einen eigenen Zweig darüber** — in `default`
fällt vor allem die **0**, die `AfxMessageBox` liefert, wenn der Dialog gar
nicht erzeugt werden kann. Dann hat niemand etwas entschieden, und Eudora bleibt
offen, ohne dass der Anwender erfährt warum. Jetzt gehen Rückgabewert und Titel
ins Protokoll, und das Schließen wird **fortgesetzt**.

### E-41 — Alt-F4 und das Kreuz laufen durch ein `ENSURE_VALID`, das das Menü nicht hat

`CMainFrame::OnSysCommand` reichte `SC_CLOSE` ungeschützt an
`CFrameWnd::OnSysCommand` weiter. Dort steht in MFC 14 `GetTopLevelFrame()`
plus `ENSURE_VALID(pFrameWnd)` (`winfrm.cpp:1112-1114`) — und `ENSURE_VALID`
wirft **auch im Release-Bau**, wo MFC 6 nur `ASSERT_VALID` hatte. Jetzt läuft
`SC_CLOSE` in `TRY`/`CATCH_ALL`; scheitert die Systembehandlung, geht der Grund
ins Protokoll und `WM_CLOSE` wird nachgeschickt — der Weg, den auch
*File → Exit* nimmt.

> **Diese Stelle hat PRUEFER gefunden, indem er meine Beweisführung verwarf.**
> Ich hatte geschlossen: weil Kreuz und Alt-F4 dasselbe Symptom zeigen wie
> *File → Exit*, liegt der Wurf in `OnClose`. Das trägt nicht — beide teilen
> **zusätzlich** diesen Weg. Es folgt nur, dass der `WM_COMMAND`-Behandler
> ausgeschlossen ist.

### E-42 — zwölf Aufräumschritte konnten das Beenden abbrechen

Neues Makro `AUFRAEUMEN(name, anweisung)` in `Eudora71/Eudora/mainfrm.cpp`:
führt einen Schritt aus, meldet einen Fehlschlag mit Namen und Grund ins
Protokoll und macht weiter. Abgesichert sind

| in | Schritte |
|---|---|
| `OnClose` | `CloseImapConnections`, `EmptyTrash`, `CleanSSLLibrary`, `TrayItem`, `DeleteMenuObjects`, `QCWorkbook::OnClose` |
| `CloseDown` | `TrimJunk`, `RemoveBogusAdToolBars`, `SaveBarState(ToolBar)`, `SaveWazooBarConfigToIni`, `SaveCrashStateToINI`, `WriteToolBarMarkerToIni` |

Die Rückfragen in `CloseDown` Stufe 1 bis 3 laufen bewusst **nicht** hierdurch:
wer „Abbrechen" drückt, will nicht beenden.

### E-43 — der Fehler dahinter besteht weiter

**Das Beenden läuft nur, weil E-42 den Fehler abfängt.** Er ist nicht
verschwunden, er steht jetzt als Protokollzeile da:

    E-33 SaveCustomInfo: Abschnitt=ToolBar-BarID59392  this=06283F80  GetBtnCount=24  m_btns.GetSize=0
    E-33 SaveCustomInfo: der FELDZUGRIFF m_btns[0] wirft (GetSize=0)
    E-42 Beenden: Schritt 'SaveBarState(ToolBar)' hat eine Ausnahme ausgeloest - Das Beenden wird fortgesetzt.

**Damit ist der Widerspruch aufgelöst, der seit E-34 offen stand.**
`GetBtnCount()` ist in `OTShim_Werkzeugleiste.h:744` nichts anderes als
`m_btns.GetSize()`. Dass beide **in einem einzigen `Format`-Aufruf**
verschiedene Werte liefern — 24 und 0 —, heißt: das Feld ändert sich
**zwischen zwei Lesevorgängen**. Das ist kein Indexfehler, sondern ein Wettlauf
oder ein bereits abgebautes Leistenobjekt.

**Folge für den Anwender:** der Werkzeugleisten-Zustand wird **nie** gespeichert;
über mehrere Starts entstehen dadurch krumme Fensterlayouts.

Meine ODR-Vermutung dazu ist **widerlegt**: `class SECCustomToolBar` steht zwar
in `OT501/Include/tbarcust.h:73` **und** in `OTShim_Werkzeugleiste.h:693`, aber
`stdafx.h:52` zieht `OTShimAll.h` zuerst, und die Ersatzschicht setzt
`__TBARCUST_H__` — damit ist `tbarcust.h` in **jeder** Übersetzungseinheit
wirkungslos.

### E-37 — der erste Anlauf war eine Regression

**Nicht behoben.** Gregor am 08.09.2026: *„die meldung kommt, wenn ich eine
persona gelöscht habe"* und *„sie verschwindet links nicht, bis ich eudora
geschlossen habe"*. Mein `PopulateView()`-Aufruf hat geworfen, die Ausnahme lief
aus dem Befehlsbehandler heraus, und der Anwender sah „Encountered an improper
argument". Ein zweiter Anlauf sucht den Eintrag über den angezeigten Text und
ruft `PopulateView()` nicht mehr — **von Gregor noch nicht bestätigt**.

### Was an 1.0.22 zu prüfen ist

Auspacken und **`Eudora starten.cmd`** doppelklicken; von Hand wäre es
`Eudora.exe "<Pfad>\Mailverzeichnis"`. `Eudora.exe` **ohne** Parameter legt beim
ersten Start eine leere Einrichtung an (Befund **E-6**).

| Prüfen | erwartet |
|---|---|
| ***File → Exit*** | beendet |
| **Alt-F4** | beendet |
| **Kreuz** oben rechts | beendet |
| **Neues Konto anlegen** | trägt *Leave mail on server* und *Required, Alternate Port* |
| **Konto löschen** | verschwindet **sofort** aus der Liste, **ohne** Meldung |

## 7.2.0.21 / Paket 1.0.21 — 07.09.2026 · fünf Verfassen-Fenster, kein Absturz

Selbst nachgemessen, bevor es ausgeliefert wurde:

```
Strg-N #1: 2 Fenster   #2: 3   #3: 4   #4: 5   #5: 6
danach 20 Sekunden offen stehen gelassen: Eudora lebt, kein Exception.log
Titel: ... - [No Recipient, No Subject]
```

Drei Fehler lagen hintereinander. Der erste verhinderte das Fenster, der zweite
tötete den zweiten Versuch, der dritte schlug zu, wenn man das Fenster einfach
stehen ließ.


### Von Gregor bestätigt: Mail schreiben, senden, empfangen

Am 07.09.2026 mit dieser Fassung: *„mail können jetzt abgeschickt werden."*
Sein Bildschirmfoto zeigt den vollen Kreis — im Postfach *Out* die gesendete
Nachricht „test von freenet nach GMX" um 10:01, im Postfach *In* die Antwort
darauf um 10:02: „Re: test von freenet nach GMX — ja, ist da." Mit Zitat der
eigenen Zeile.

**Damit sind Kriterium 5 und 6 aus [ZIEL.md](ZIEL.md) erfüllt.** Von den neun
Kriterien sind fünf belegt, drei fast oder halb, und **eines nicht: das
Beenden**.

Ebenfalls nachgesehen: das Menü *Window* listet die offenen Fenster auf („1 In",
„2 Out"). Kriterium 8 ist damit zur Hälfte erfüllt; was fehlt, ist die
Registerkartenleiste am unteren Fensterrand, die die Ersatzschicht nicht
nachbildet.

**Offen bleibt:** *„beenden geht nicht"* (Kriterium 7) und Gregors Frage
*„kann man die untere zeile (status) immer anzeigen lassen?"*

### Was an 1.0.22 zu prüfen ist

Paket (SHA256 `7ddab1a0f0fdf1c4458a7aa2ab00d2f1fbb15561ab576657c73006fcfa95586c`)
liegt **nicht mehr im Repo** und hat keine Marke — neu zu bauen aus `d003d46`.
Wer heute prueft, nimmt 1.0.23; die Anleitung dazu steht weiter oben.
Auspacken und **`Eudora starten.cmd`** doppelklicken. Wer lieber selbst
aufruft, nimmt `Eudora.exe "<Pfad>\Mailverzeichnis"` — das ist genau, was der
Starter tut, und von Gregor am 08.09.2026 nachgemessen. Was **nicht** geht, ist
`Eudora.exe` **ohne** Parameter beim ersten Start: dann sucht Eudora die Ini im
Programmverzeichnis, findet keine und legt eine leere Einrichtung an (Befund
**E-6**).

| Prüfen | erwartet | wenn nicht |
|---|---|---|
| **Strg-N** | ein Verfassen-Fenster, das man benutzen kann | E-31/E-34/E-35/E-36 greifen nicht |
| **Mail abschicken** | landet in *Out*, kommt beim Empfänger an | Kriterium 5 wieder offen |
| **Weiterleiten** (Strg-Umschalt-F) | Verfassen-Fenster mit dem Text darin | Kriterium 6 wieder offen |
| **Doppelklick** auf eine Nachricht | öffnet sie | E-28 greift nicht |
| **Suchtreffer anklicken** | öffnet die Nachricht | dito |
| **Werkzeugleiste** im Suchfenster | abgeschaltete Knöpfe zeigen ihr Symbol | E-30 greift nicht |
| ***File → Exit*** | beendet sauber | **bekannt: tut es nicht** (Kriterium 7) |
| **Menü *Window*** | listet die offenen Fenster | E-34-Kette greift nicht |

Nach einem Absturz **zwei Dateien** im Mailverzeichnis ansehen:

- **`eudora.log`** — die letzte Zeile mit `E-27` nennt die letzte Station, die
  noch erreicht wurde. 15 Spurmarken liegen auf dem Weg. Sie schreiben **nur**,
  wenn in `Eudora.ini` unter `[Settings]` `LogLevel=32896` steht —
  `PutDebugLog` prüft die Maske und kehrt sonst sofort zurück
  (`QCUtils/src/debug.cpp:140`).
- **`Exception.log`** — enthält seit 7.2.0.13 die Modultabelle. Damit:

```bash
perl tools/absturz-auswerten.pl
```

Das Werkzeug findet Bericht und Karte selbst und macht aus jeder Zeile des
Aufrufstapels einen Funktionsnamen. **Bleibt `Exception.log` leer**, war es
Heap-Beschädigung — dann hilft nur Page Heap (siehe `Befunde/SPUR.md`, Abschnitt 8).

### E-34 — eine MFC-Ausnahme wickelte den ganzen Fensterbau ab

Siehe 7.2.0.20. `QCChildToolBar::GetButton` fängt sie jetzt und gibt NULL
zurück.

### E-35 — der zweite Strg-N, und er war eine Folge von E-34

`CCompMessageFrame::OnUserUpdateImmediateSend` dereferenzierte das Ergebnis von
`GetButton` **zweimal blind**:

```cpp
if(((TBarSendButton*)pToolBar->GetButton(nIndex))->IsBPWarning() != m_bBPWarning)
     ((TBarSendButton*)pToolBar->GetButton(nIndex))->SetBPWarning(m_bBPWarning);
```

Die Abfrage `nIndex != -1` darüber schützt nicht: **seit E-34 gibt `GetButton`
auch bei gültigem Index NULL zurück.** Aus einer Ausnahme wurde ein NULL, und
diese Stelle rechnete nicht damit. Beim ersten Strg-N kommt sie nicht dran, beim
zweiten schon.

Gefunden hat es **`tools/pruefe-fensterbau.pl`**, die Schranke, die zu diesem
Zweck entstand.

### E-36 — dasselbe zweimal in `PgCompMsgView`, gefunden vom eigenen Absturzbericht

Aufgelöst mit `tools/absturz-auswerten.pl` — der Werkzeugkette aus E-26 und
E-29, die genau dafür gebaut wurde:

```
#01  CMoodMailStatic::GetScore
#02  PgCompMsgView::UpdateMoodMailButton + 0x51
#03  PgCompMsgView::OnTimer + 0xD3
```

Ein Zeitgeber im offenen Verfassen-Fenster lief in einen Nullzeiger. Für
`ID_MOOD_MAIL` gibt es überdies **keinen Befehlsbehandler** — der Knopf liegt
gar nicht auf der Leiste, `CommandToIndex` liefert einen Index, den `GetButton`
mit NULL beantwortet.

**Die eigentliche Lehre steckt in der Schranke, nicht im Fehler:**
`pruefe-fensterbau.pl` hatte eine **feste Dateiliste** — `CompMessageFrame`,
`ReadMessageFrame`, `PgDocumentFrame`. `PgCompMsgView.cpp` fehlte darin, und
genau dort lagen die vier blinden Zugriffe. Eine Schranke mit handgepflegter
Liste hat immer genau die Lücke, die man nicht bedacht hat. Sie prüft jetzt alle
`Eudora71/Eudora/*.cpp`: **10 Aufrufstellen statt 8**, Gegenprobe mit der
Fassung von vor der Behebung rot.

### Neu: `tools/pruefe-fensterbau.pl`

Drei Schranken, drei Gegenproben, alle drei rot, echter Baum grün:

| | |
|---|---|
| E-33 | keine modale Meldung in `Eudora71/OTShim/*.cpp` |
| E-34 | `GetButton` hat Indexschranke **und** Ausnahmefang |
| E-34 | jeder `GetButton`-Aufruf prüft sein Ergebnis auf NULL |

Die Gegenproben haben **zwei Fehler in der Schranke selbst** gefunden. Der
schlimmere: `OTShim.cpp:99` trägt im *Zeilen*kommentar den Text
`dlg.Create in Eudora/*.cpp` — das `/*` darin öffnete beim Entfernen der
Blockkommentare einen Scheinkommentar und fraß 1600 Zeichen. **Die Gegenprobe zu
E-33 blieb dadurch grün, obwohl die modale Meldung wieder eingebaut war.** Eine
Schranke, die eine Regression verschweigt, ist schlimmer als keine. Jetzt werden
Zeilenkommentare zuerst entfernt.

### Neues Kriterium 8

Von Gregor am 07.09.2026 gesetzt: *„die offenen fenster (nibox, outbox, neue
mail, ...) sollten irgendwie sichtbar und auswählbar sein. entweder über window
menü oder über reiter in der statuszeile oder ähnlich."*

Der Bezug ist unmittelbar: die modale Meldung, die mit E-33 abgeschaltet wurde,
sagte wörtlich *„Die Leiste am unteren Fensterrand, die alle offenen Fenster als
Registerkarten zeigt … Sie brauchen sie nicht: alle offenen Fenster stehen im
Menü Window."* Die Ersatzschicht bildet diese Leiste nicht nach. Dass das Menü
*Window* die Fenster tatsächlich auflistet, hat Gregor am 07.09.2026
nachgesehen („1 In", „2 Out") — damit ist Kriterium 8 zur Hälfte erfüllt, und
der erste Schritt ist die **Leiste**, nicht das Menü.

## 7.2.0.20 / Paket 1.0.20 — 07.09.2026 · das Verfassen-Fenster erscheint

**Gregor hat es selbst gesehen:** *„ich habe kurz eine neue mail gesehen."* Zum
ersten Mal in dieser Portierung entsteht nach Strg-N ein Verfassen-Fenster mit
Titel.

### E-34 — eine MFC-Ausnahme im Fensterbau, ohne Meldung und ohne Absturz

Gemessen am 07.09.2026 mit einer Marke **je Anweisung** in
`CCompMessageFrame::OnCreateClient`: die letzte Marke, die noch feuerte, war
`nach CommandToIndex(ID_EDIT_INSERT)`, die nächste nicht mehr. In
`QCChildToolBar::GetButton` entstand eine MFC-Ausnahme. Sie wickelte
`OnCreateClient` ab, MFC ließ `CWnd::OnCreate` fehlschlagen, `LoadFrame` gab
FALSE, `CMultiDocTemplate::CreateNewFrame` gab **NULL** — kein Fenster, keine
Meldung, kein Absturz. Genau Gregors *„es passiert nichts"*.

Der Grund steht jetzt im Protokoll, und es ist **wörtlich** die Meldung, die
Gregor seit Tagen sieht:

```
E-34 QCChildToolBar::GetButton: Ausnahme bei Index 24 von 27
     - NULL zurueckgegeben. Grund: Encountered an improper argument.
```

Der Index liegt **innerhalb** der von `GetBtnCount()` gemeldeten Zahl — die
Schranke aus E-16 greift also, und `m_btns[24]` wirft trotzdem. MFC 14 prüft in
den Sammlungen mit `ENSURE` statt `ASSERT`, und **`ENSURE` wirft auch im
Release-Bau**. `GetBtnCount()` und das tatsächlich indizierte Feld laufen
auseinander; warum, ist noch offen.

`GetButton` fängt die Ausnahme jetzt, protokolliert Index, Größe und Grund und
gibt NULL zurück. Alle sechs Aufrufstellen prüfen den Rückgabewert bereits auf
NULL — ein NULL ist verkraftbar, eine Ausnahme mitten im Fensterbau nicht.

**Nachgemessen:**

```
nach InitialUpdateFrame:  sichtbar=1, 1552x1214, titel='No Recipient, No Subject'
Haupttitel:               ... - [No Recipient, No Subject]
```

### Was noch nicht geht

- **Der zweite Strg-N stürzt ab.** Selbst gemessen: `#1` liefert zwei
  MDI-Fenster mit Titel, `#2` beendet Eudora. Ein Fenster reicht nicht
- Ob man in dem Fenster **schreiben und abschicken** kann, ist nicht geprüft
- ***File → Exit*** bringt weiter eine Meldung (E-33 der Zählung in ZIEL.md)

### E-32 — meine Ursachenbehauptung ist widerlegt

Der Prüfer hat sie dreifach gemessen und **verworfen**:
`CHeaderView::OnKillFocusRecipient` läuft bei Strg-N überhaupt nicht (eine
Messspur darin liefert null Zeilen, während die E-27-Marken derselben Sitzung
alle durchlaufen); das Herausnehmen der Behebung bringt die Meldung nicht
zurück; und im ausgelieferten Paket 1.0.18 tritt sie über denselben Testweg auch
nicht auf. Der Code-Mangel dort ist echt — `pField` wird dereferenziert, obwohl
drei Zeilen darüber auf NULL geprüft wird —, aber er war **nie gegen das Symptom
geprüft**. Am Quelltext scheitert die Begründung zusätzlich: `EN_KILLFOCUS` kann
nur ankommen, wenn das Feld existiert, dann liefert `GetDlgItem` nie NULL.

Gefährlicher ist dort etwas anderes, das er gefunden hat: vor `SubclassDlgItem`
(`headervw.cpp:2590`) liefert `GetDlgItem` ein **temporäres `CWnd`**, und der
Zugriff auf `pField->m_ACListBox` liest hinter dessen Ende.

### E-31 — viel stärker bestätigt als behauptet

Der Prüfer hat eine bessere Messquelle gefunden als der Befund selbst hatte:
`Eudora71/Bin/Release/Paige32.pdb` gehört zur ausgelieferten DLL von 2005
(CodeView-GUID und Alter stimmen, PE-Zeitstempel 14.10.2005). Damit ist der
Feldaufbau der DLL **messbar statt vermutbar**.

Es waren nicht vier verschobene Felder, sondern **755 von 1922** und zehn zu
große Strukturen (`paige_rec` +24, `pg_translator` +44). Nach der Behebung:
**0 von 1922.** Und die offene Nebenbehauptung ist jetzt belegt: `time_t` war
tatsächlich der einzige Typ — 91 von 92 gemeinsamen Strukturen sind feldweise
identisch, die zwei Ausnahmen kommen in keiner der 56 Kopfdateien vor.

## 7.2.0.18 / Paket 1.0.18 — 06.09.2026 · die Ursache gefunden

**E-31 — `pg_time_t` war acht Byte breit statt vier.** Eine Zeile im
Windows-Zweig von `Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H` (`grep -n pg_time_t`):

```c
typedef time_t   pg_time_t;      /* vorher */
typedef long     pg_time_t;      /* nachher */
```

`time_t` war unter VC6/VC7.1 **vier** Byte breit, unter VS2022 ist es **acht**.
`Paige32.dll` stammt von 2005 und rechnet mit vier. `pg_time_t` steckt in
`style_info` und fünfmal in `pg_doc_info` — und damit in `pg_globals` und in
`paige_rec`. **Jede** Struktur, die Eudora an Paige reichte, war verschoben.

Gemessen mit einem 32-Bit-Programm, das die ausgelieferte DLL lädt,
`pgMemStartup`/`pgInit` auf einen genullten Puffer ruft und darin die Adressen
der exportierten Standardprozeduren sucht:

| Feld in `pg_globals` | die DLL sagt | VS2022 rechnete | nachher |
|---|---|---|---|
| `def_style.procs.init` | 524 | **536** | 524 |
| `def_par.procs.line_proc` | 1300 | **1316** | 1300 |
| `def_hooks` | 1360 | **1376** | 1360 |
| `sizeof(style_info)` | 292 | **304** | 292 |

Alle 30 Zeiger in `def_hooks` und alle 17 in `def_style.procs` lösen sich danach
lückenlos auf. Kein `/Zp`, kein `#pragma pack` im Spiel — `time_t` ist der
einzige Typ in `PGHEADER`, dessen Breite sich geändert hat.

**Damit erklärt sich, warum die sieben Vermutungen aus 7.2.0.17 nichts
brachten:** `PgGlobals::InitFonts` schrieb mit `memcpy(&def_style, &styleInfo,
304)` zwölf Byte über die Struktur hinaus — bei jedem Start. Und
`pPg->user_refcon = (long)pSB` landete 20 Byte neben dem echten Feld. Beides
passiert, **bevor** der verdächtigte `pgNewNamedStyle` überhaupt gerufen wird.

**Zwei Annahmen der Vorarbeit waren falsch.** Es *gibt* Paige-Quellen:
`Eudora71/PaigeDLL/PGSOURCE`, **37** `.C`-Dateien (nachgezählt am 07.09.2026 —
`git ls-files Eudora71/PaigeDLL/PGSOURCE` liefert 38 Einträge, davon einer
`.SBT`). Der Rekursionszyklus ist dort nachzulesen — `pgInstallFont` →
`pgStyleSuperImpose` → `target_style->procs.init(...)` (`PGDEFSTL.C:1640`).

### Die Probe

| | vorher | nachher |
|---|---|---|
| Strg-N | `ABGESTUERZT, Code 0xC0000005`, letzte Marke `NPO: vor CreateHTMLStyles` | `OnMessageNewMessage: fertig`, **Fenster steht**, Eudora läuft weiter |
| Vollständiges `CPaigeEdtView::OnCreate` im Protokoll | **kein einziges** | ja |
| *Weiterleiten* | beendet Eudora | beendet Eudora nicht mehr |

**In dieser Portierung entstand bis dahin nie ein Paige-Fenster.**

### Was danach noch offen war

> **Nachtrag 07.09.2026: E-32 ist behoben.** Der unten festgehaltene Verdacht
> traf den Ort, aber nicht die Ursache. Es war nicht
> `AutoCompleterListBox::KillACListBox` selbst, sondern der **ungeprüfte
> Zeiger auf dem Weg dorthin**: `CHeaderView::OnKillFocusRecipient` in
> `Eudora71/Eudora/headervw.cpp` dereferenzierte `pField`, obwohl die Abfrage
> drei Zeilen darüber ausdrücklich mit NULL rechnet. `GetDlgItem` liefert NULL,
> solange das Kopfzeilenfeld nicht existiert — und `OnKillFocusTo` läuft
> während `LoadFrame`, also bevor die Felder da sind. Dieselbe Fehlerklasse wie
> E-18 und E-22. **Von Gregor nicht nachgemessen.**

- **E-32 — die Meldung „An unhandled exception has occurred" beim Verfassen.**
  Das ist der letzte Schritt bis Kriterium 5. **Gemessen am 06.09.2026 nach der
  Behebung von E-31:** die Spur läuft jetzt **vollständig** durch —
  `OnCreateClient: vor GetSubMenu 11` → **`OnMessageNewMessage: fertig`**. Der
  Fensterbau ist also fertig; die Ausnahme kommt **danach**, beim Anzeigen.

  Der Verdacht am 06.09.2026: `AutoCompleterListBox::KillACListBox`
  (`AutoCompleteSearcher.cpp:548`), gerufen aus `CHeaderView::OnKillFocusTo`.
  Der Agent sah dort unter dem Debugger `0xC000041D`
  (STATUS_FATAL_USER_CALLBACK_EXCEPTION — eine Ausnahme innerhalb einer
  Fensterprozedur) und hielt es für fokusabhängig und selten. **Das stimmte
  nicht:** Gregor bekam die Meldung bei jedem Versuch, und sie war modal —
  deshalb ließ sich Eudora danach auch nicht mehr beenden.

- Unter dem Debugger trat dieselbe Ausnahme als scheinbar zweiter,
  **fokusabhängiger** Fehler zutage: `0xC000041D` in
  `AutoCompleterListBox::KillACListBox+5` (`AutoCompleteSearcher.cpp:551`),
  gerufen aus `CHeaderView::OnKillFocusTo`. In vier Läufen ohne Debugger nicht
  ausgelöst — das war irreführend, es ist E-32
- **Der eigentliche Schlussstein wäre ein Neubau von `Paige32.dll` mit VS2022** —
  Quellen (`PGSOURCE`, 37 `.C`-Dateien) und `PAIGE32/Paige32.vcproj` liegen
  vor. Dann kann keine Kopfdatei mehr von der Binärdatei abweichen

### Neue Werkzeuge

`tools/strg-n-pruefen.ps1` startet Eudora, klickt Meldungen weg, schickt Strg-N
und sagt, ob das Fenster aufgeht — ohne dass jemand danebensitzt.
`tools/befehl-schicken.ps1` schickt einen beliebigen Menübefehl. Beide beenden
nur Eudora-Prozesse aus dem angegebenen Testverzeichnis.

## 7.2.0.17 / Paket 1.0.17 — 06.09.2026 · nicht ausgeliefert

Reine Messfassung. Zweck war, E-27 einzukreisen. **Das ist gelungen, die
Behebung nicht.**

### Der Absturz ist gemessen, nicht mehr vermutet

Eudora unter `tools/stapel-untersuchen.ps1` gestartet, Strg-N per `WM_COMMAND`
geschickt:

```
AUSNAHME 0xC00000FD   (STATUS_STACK_OVERFLOW)
EIP  Paige32.dll  pgInstallFont

Zyklus aus der Stapelabtastung:
    527 x  Eudora.exe   PgSharedAccess::pgGlobals
    526 x  Paige32.dll  pgInstallFont + 77
    525 x  pgDeleteTextProc / pgCopyTextProc / pgDeleteStyleProc /
           pgAlterStyleProc / pgSaveStyleProc / pgBytesToUnicode
Weg hinein:  pgLocateStyleSheet -> pgStyleSuperImpose -> pgInstallFont
```

Eine **Endlosrekursion rund 525 Windungen tief**, in der Fremdbibliothek
`Paige32.dll` (Binärdatei von 2005, keine Quellen im Repo). Jede Windung
schiebt eine Kopie von Eudoras Paige-Globals auf den Stapel.

Damit ist auch erklärt, **warum nie ein `Exception.log` entstand**: ein voller
Stapel lässt keinen Platz mehr, den Absturzbehandler auszuführen. Dieselbe
Fehlerklasse wie Befund S-2 vom 30.08.2026, wo Paige an einer Fläche der Größe
null in dieselbe Falle lief.

### Sieben Vermutungen, alle durch Versuch widerlegt

Jede einzeln gebaut, gestartet, gemessen — **keine** hat den Absturz beseitigt:

| Vermutung | Messung |
|---|---|
| Umgestülptes Client-Rechteck | gemessen `Rect=8,2,2,598`, Breite **minus 6**; begradigt, stürzt weiter ab |
| Zu kleine Anfangsgröße der Ansicht | mit `CSize(400,600)` gesundes `8,2,375,598`, stürzt weiter ab |
| `parInfo`/`parMask` nicht vorbelegt | genullt, stürzt weiter ab |
| Reihenfolge der beiden `CreateView` | getauscht, stürzt weiter ab |
| Veralteter `styleInfo.font_index` | auf 0 gesetzt, stürzt weiter ab |
| **`pgNewNamedStyle` selbst** | **ganz übersprungen, stürzt weiter ab** |
| Eine bestimmte Einstellung | frische `Eudora.ini` aus dem Paket, stürzt weiter ab |

Der vorletzte Punkt wiegt am schwersten: es liegt **nicht an diesem einen
Aufruf**, sondern am Anlegen benannter Stile überhaupt — `CreateHTMLStyles` tut
über `make_style` dasselbe und stirbt genauso.

### Eine Annahme, die sich als falsch erwies

Die HTML-Nachricht im Vorschaufenster wird von **Internet Explorer** gezeichnet
(Fensterklasse `Internet Explorer_Hidden`), nicht von Paige. Dass sie korrekt
erscheint, beweist also **nicht**, dass Paige funktioniert. Möglich ist, dass in
dieser Portierung noch nie ein Paige-Fenster erfolgreich entstanden ist — das
ist die nächste zu klärende Frage.

### Behalten, weil unabhängig davon richtig

- `PaigeEdtView.cpp`: umgestülptes Rechteck wird begradigt, `parInfo` und
  `parMask` werden vorbelegt. Die Datei hält sich an zwei anderen Stellen selbst
  an diese Regel — nur hier fehlte es
- `tools/stapel-untersuchen.ps1`: `[IntPtr][int]` lief bei Stapeladressen über
  `0x7FFFFFFF` über und brach die Auswertung ab. Neu dazu eine
  **Stapelabtastung**, weil die EBP-Kette bei Paige nichts taugt — die DLL ist
  ohne Rahmenzeiger übersetzt und lieferte genau zwei Rahmen
- `tools/bauen.ps1`: die Artefaktprüfung verglich jede Datei mit der jüngsten
  Quelle im **ganzen** Baum und meldete `EuLang.dll` und `msvcr71.dll` deshalb
  fälschlich als veraltet. Jetzt projektbezogen

## 7.2.0.16 / Paket 1.0.16 — 06.09.2026 · zurückgezogen

**Fror beim Start ein.** Eigenes Versehen: das Einsetzmuster für die Spurmarken
traf `UnuseMemory( m_paigeRef );`, und diese Zeile kommt **17-mal** in
`PaigeEdtView.cpp` vor, auch in den Zeichenroutinen. Jede Bildwiederholung
schrieb ins Protokoll.

> **Lehre:** Ein Einsetzmuster mit mehr Treffern als erwartet wird gezählt,
> bevor es angewandt wird. 29 statt 12 hätte auffallen müssen.

## 7.2.0.15 / Paket 1.0.15 — 06.09.2026

Messfassung mit feineren Spurmarken um beide `CreateView` im Verfassen-Fenster.
Ergebnis: `CHeaderView` läuft sauber durch, der Absturz liegt im Anlegen der
Paige-Ansicht.

**Wichtig für eigene Messungen:** Die Spurmarken schreiben nur, wenn in
`Mailverzeichnis\Eudora.ini` unter `[Settings]` steht:

```
LogLevel=32896
```

`PutDebugLog` prüft diese Maske und kehrt sonst sofort zurück
(`QCUtils/src/debug.cpp:140`). 32896 = `DEBUG_MASK_MISC` (0x8000) +
`DEBUG_MASK_TOC_CORRUPT` (0x80).

## 7.2.0.14 / Paket 1.0.14 — 06.09.2026

Erste Fassung, in der Gregor mehrere Behebungen bestätigt hat.

- **E-30 — Symbole der Werkzeugleiste.** Gesperrte Knöpfe zeigten eine leere
  graue Fläche. Ursache: die sechs Bitmaps der Hauptleiste sind **24 Bit** und
  haben damit keine Farbtabelle, die `CreateMappedBitmap` umsetzen könnte. Das
  Buttongrau `192,192,192` blieb stehen, während `COLOR_BTNFACE` heute
  `240,240,240` ist; die Maske erfasste dadurch das ganze Bildrechteck. Die
  8-Bit-Bitmaps der Nachrichtenfenster waren nie betroffen — das erklärt, warum
  nicht *alle* Symbole fehlten. Unter VC6 war die Systemfarbe selbst
  `192,192,192`, deshalb fiel es nie auf. Behoben in
  `OTShim/OTShim_Werkzeugleiste.cpp`, dazu `tools/pruefe-symbole.pl` und
  `Eudora71/Tests/TestSymbole.cpp`
- **E-28 — Doppelklick und Suchtreffer öffneten nichts.**
  `CSummary::m_FrameWnd` blieb als Zeiger auf einen zerstörten Rahmen stehen:
  `CMessageFrame::ActivateFrame` setzt ihn bedingungslos, `OnDestroy` löschte
  ihn nur **innerhalb** von `if (m_InitialSize != wp.rcNormalPosition)` — also
  nur, wenn das Fenster verschoben oder in der Größe geändert wurde
- **`dbghelp.dll` von 2005 entfernt.** Sie lag seit dem ersten Commit in
  `Eudora71/Bin/Release` und verdeckte die aktuelle aus `SysWOW64`. Am
  05.09.2026 stürzte der Absturzbehandler **in ihr** ab — genau dann, wenn er
  gebraucht wird. Wiederherstellbar aus `567a5d8`
- `paket-bauen.ps1` legt `Eudora starten.cmd` jetzt selbst ins Paket. Im ersten
  Anlauf fehlte sie; `paket-pruefen.ps1` hat es gemeldet

## 7.2.0.13 / Paket 1.0.13 — 06.09.2026 · übersprungen

Gebaut und geprüft, aber nie ausgeliefert — E-30 kam dazwischen. Die Nummer
bleibt verbrannt, damit keine zwei Bauten dieselbe tragen.

- **E-26 — der Absturzbericht nennt die Ladeadresse jedes Moduls.** Ohne sie war
  keine Zeile des Aufrufstapels einem Funktionsnamen zuzuordnen: Windows lädt
  `Eudora.exe` verschoben (ASLR), und `Exception.log` schrieb die tatsächliche
  Basis nicht mit. Ein Versuch, gegen die vorgesehene `0x00400000` zu rechnen,
  lieferte prompt einen Namen aus dem Ressourcenbereich
- **E-29 — `tools/absturz-auswerten.pl`**, 15 Selbsttests. Macht aus
  `Exception.log` Funktionsnamen und sagt bei älteren Berichten ausdrücklich,
  dass es **nicht** geht, statt zu raten
- **E-27, erster Teil** — die drei stillen Fehlerklassen werden protokolliert:
  `_set_invalid_parameter_handler`, `_set_purecall_handler`, `set_terminate`.
  Der Absturzbehandler hing nur an `SetUnhandledExceptionFilter`, und vier Wege
  gehen daran vorbei
- `Eudora.vcxproj` erzeugt bei jedem Bau `Eudora71/Bin/Release/Eudora.map`

## 7.2.0.10 / Paket 1.0.10 — 05.09.2026

Die Fassung, mit der **Kriterium 0** belegt wurde: von Gregor am 06.09.2026 auf
einem Rechner ohne Visual Studio ausgepackt und gestartet.

- **E-23** — POP3 fiel nicht mehr still auf Port 110 zurück; TLS-Fehler werden
  gemeldet statt verschluckt. Damit lief erstmals Port 995 mit TLS 1.3
- **E-24** — „In" stand zweimal unter *Recent*
- **E-22** — ungeprüfte Zeiger im Aufbau des Nachrichtenfensters
- **E-18, E-19** — zwei Fehler, die erst mit einer zweiten Persönlichkeit
  auftreten

## 7.2.0.3 / Paket 1.0.3 — 31.08.2026

Erster Release-Bau, der Mail abruft: 159 Nachrichten über POP3 Port 110 mit
STARTTLS.

## Paket 1.0.2 — 30.08.2026

Eudora startet und zeigt sein Hauptfenster — erstmals seit Beginn der
Portierung. Möglich wurde das durch **S-2**: die Werbefläche wurde mit
`CRect(0,0,0,0)` angelegt, Paige bekam eine Umbruchbreite von null und
verhedderte sich in einer Endlosrekursion.

## Paket 1.0.1 — 30.08.2026

Erstes Paket überhaupt. Die Dateinamen `…-lauffaehig.zip` von 1.0.1 und 1.0.2
behaupten mehr, als die Fassungen konnten; sie bleiben stehen, weil die Pakete
unter diesen Namen samt Prüfsumme veröffentlicht sind.

---

## Wo man weitermachen kann

Die offenen Enden mit Fundstelle — für jemanden, der das Repo frisch klont.
**Stand 09.09.2026.**

### 1. Erledigt: das Verfassen-Fenster ist da

**Kriterium 5 und 6 sind erfüllt** — von Gregor am 07.09.2026 bestätigt:
*„mail können jetzt abgeschickt werden."* und *„weiterleitung funktioniert
übrigens."* Sein Bildschirmfoto zeigt *Out* 10:01 und die Antwort in *In*
10:02. Behoben sind E-31, E-34, E-35 und E-36.

**So misst man es nach**, ohne dass jemand danebensitzt:

```
powershell -ExecutionPolicy Bypass -File tools\strg-n-pruefen.ps1 -Verzeichnis <Paket>
```

Das Werkzeug startet Eudora, klickt Meldungen weg, schickt Strg-N und sagt, ob
das Fenster aufgeht. Für das Protokoll braucht es `LogLevel=32896` unter
`[Settings]` in der `Eudora.ini` — `PutDebugLog` prüft die Maske und kehrt
sonst sofort zurück (`QCUtils/src/debug.cpp:140`).

**Unter dem Debugger**, 32-Bit-PowerShell:

```
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File tools\stapel-untersuchen.ps1 -Exe <Paket>\Eudora.exe -Argumente "<Mailverzeichnis>"
```

Eudora lässt sich dabei von außen steuern, ohne dass jemand klicken muss:
Meldungsfenster mit `WM_COMMAND`/`IDOK` schließen, dann `WM_COMMAND` mit
`ID_MESSAGE_NEWMESSAGE` (32797) an die Fensterklasse `EudoraMainWindow`.

**Der Schlussstein wäre ein Neubau von `Paige32.dll` mit VS2022** — dann kann
keine Kopfdatei mehr von der Binärdatei abweichen, und genau diese Abweichung
war E-31. `Eudora71/PaigeDLL` enthält **doch** Quellen: `PGSOURCE` mit 37
`.C`-Dateien, dazu `PAIGE32/Paige32.vcproj` und die alten Makefiles. Bis zum
06.09.2026 stand an dieser Stelle das Gegenteil, und das hat die Suche nach
E-31 unnötig lange aufgehalten. Der Rekursionszyklus ist dort nachzulesen
(`PGDEFSTL.C:1640`).

**Noch nicht versucht:** Page Heap (`gflags /p /enable Eudora.exe /full`, als
Administrator).

### 2. Erledigt: Kriterium 7 — Eudora beendet sich sauber

**Von Gregor am 08.09.2026 an Paket 1.0.22 bestätigt:** *„schließen klappt
jetzt."* Alle drei Wege beenden — *File → Exit*, **Alt-F4** und das **Kreuz**.
Behoben durch **E-40**, **E-41** und **E-42**, ergänzt um **E-45**. Der Weg
dorthin steht in [Befunde/BEENDEN.md](Befunde/BEENDEN.md), das Review in
[Befunde/PRUEFER-5.md](Befunde/PRUEFER-5.md), die Schranke ist
`tools/pruefe-beenden.pl` (elf eingefasste Aufräumschritte; der zwölfte,
`QCWorkbook::OnClose`, darf ausdrücklich **nicht** durch `AUFRAEUMEN` laufen).
**Nicht wieder von vorn aufrollen.**

### 3. Erledigt: Kriterium 8 — die offenen Fenster als Registerkarten

**Von Gregor am 09.09.2026 an Paket 1.0.25 bestätigt:** der Klick auf eine
Karte holt das Fenster nach vorn, die Beschriftungen stimmen mit dem Menü
*Window*. Die Leiste war nicht abwesend, sondern **abgeschaltet** — Eudoras
Code liegt vollständig in `workbook.cpp`, der Einschalter in `mainfrm.cpp`, die
INI-Vorgabe `ShowMDITaskbar\n1` in `EudoraRes.rc`. Es fehlten vier Anschlüsse
in der Ersatzschicht `OTShim` (**E-48**, umgesetzt in 7.2.0.25). Drei Mängel,
die Gregor dabei gemeldet hat, sind als **E-50** in 7.2.0.26 behoben und
**noch nicht** von ihm beurteilt.

### 4. Die Meldung „Encountered an improper argument"

MFCs Text für `CInvalidArgException`, kommt also aus MFC, nicht aus Eudora.
Zwei Quellen sind bekannt und behoben: `QCChildToolBar::GetButton` mit Index
minus eins (**E-16**) und dieselbe Funktion mit einem Index innerhalb der
gemeldeten Anzahl (**E-34**, abgefangen).

**Die Ursache dahinter ist seit 7.2.0.24 gefunden und behoben: E-43.**
`SECControlBar` war **zweimal definiert** — `OT501/Include/sbarcore.h`
(Original) und `OTShim/OTShim.h` (Ersatz, mit einem Feld mehr) —, und deshalb
lasen zwei Übersetzungseinheiten dasselbe Feld acht Byte auseinander. Genau
das war die Antwort auf die Frage, warum `GetBtnCount()` und `m_btns.GetSize()`
verschiedene Werte melden, obwohl das eine wörtlich das andere zurückgibt.
Gemessen vorher `GetBtnCount=24/24 m_btns.GetSize=0/0`, nachher `24/24` gegen
`24/24`.

**Was bleibt:** die Meldung beim **Anzeigen** mancher Nachrichten ist damit
**neu zu messen** — gut möglich, dass sie mit verschwunden ist. Reproduzierbar
war sie über *Find Messages* mit einem Treffer. **Erst messen, dann suchen.**
Sie ist der einzige Grund, warum Kriterium 2 und Kriterium 4 nicht *erfüllt*
heißen.

### 5. Die Altlast, die niemand bauen kann

- **`EuMemMgr.dll`** ist gar kein Projekt der Projektmappe — eine vorgebaute
  Binärdatei von 2005 (Version 7.0.0.9). Ausgerechnet sie löst den Aufrufstapel
  im Absturzbericht auf. Sie holt `malloc`/`free` aus `MSVCR71`, hat damit eine
  **eigene Halde** neben der UCRT von `Eudora.exe`, und Speicher, der über diese
  Grenze gereicht wird, ergibt `0xC0000374`. Für `Paige32.dll` gilt dasselbe —
  dort liegen aber Quellen vor (siehe 1.)

### 6. Was beim Mitarbeiten hilft

- `AGENTEN.md` — wie parallele Arbeit koordiniert wird, aus fünf gemessenen
  Kollisionen
- `Arbeitsweise/` — die Lehren aus diesem Projekt, eine Datei je Lehre
- `tools/pruefe-bytes.pl` — die Quellen sind Latin-1 mit gemischten
  Zeilenenden; ein Werkzeug, das das zerstört, fällt erst Wochen später auf
- `tools/paket-pruefen.ps1` — prüft ein Paket über die PE-Importtabellen gegen
  Kriterium 0 und wertet einen Treffer in `SysWOW64` ausdrücklich **nicht** als
  erfüllt
- `tools/bauen.ps1` — baut und meldet Erfolg nur, wenn vier unabhängige
  Prüfungen zustimmen. MSBuild kann 0 zurückgeben und trotzdem nichts gebaut
  haben
