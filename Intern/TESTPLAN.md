# Testplan für Gregor — Quellstand 7.2.0.121 / `VERSION` 1.0.121, Stand 22.10.2026

> **Es gibt kein Paket 1.0.121.** Der Quellstand ist auf 7.2.0.121 gehoben
> ([E-111](BEFUNDE.md#e-111), nur übersetzt), geschnürt und bei dir liegt
> **1.0.120**. Alles unten ist an 1.0.120 zu prüfen, solange nichts anderes
> dasteht.

## Was jetzt zu testen ist

**Zwei Schritte offen, einer nur noch als Gegenprobe.** [C10](#c10) ist neu in
1.0.120 und offen; [C9](#c9) hast du an 1.0.119 schon bestätigt und steht nur
noch als Gegenprobe da. [C8](#c8)
steht seit 1.0.117 und ist von dir noch nicht gefahren. Alles andere in diesem
Plan ist Nachschlagewerk.

### <a id="c10"></a>Die Auswahlbox im `To:`-Feld — bleibt sie gleich groß?

**Worum es geht.** Du hast es am 21.10.2026 an 1.0.119 gemeldet, während du dein
Ziel für diesen Weg beschrieben hast: *„das Fenster wird bei jeder Änderung
(z.B. nächster Eintrag) kleiner!"* Die Box verlor bei jedem Cursor-Schritt
16 Pixel in Höhe und Breite und war nach fünf Schritten nicht mehr zu sehen
(gemessen: `100 × 62`, `84 × 46`, `68 × 30`, `52 × 14`, `36 × 14`, `20 × 14`).
Behoben in 7.2.0.120, siehe [E-135](BEFUNDE.md#e-135).

**Vorbereitung** — die Box erscheint nur, wenn mehrere Kurznamen **mit
demselben Anfang** im Adressbuch stehen. Über *Tools → Address Book* und
**New** drei Stück anlegen, zum Beispiel `hans`, `hanna`, `hannes` (oder in
`NNdbase.txt` nachsehen, ob du schon welche hast).

**Was zu tun ist** — eine Minute, kein Netz nötig:

1. Eine neue Nachricht öffnen (*Message → New Message*).
2. Im Feld *To:* die ersten zwei Buchstaben tippen, also `ha`. Die Auswahlbox
   klappt auf.
3. Mit **Cursor runter** fünfmal durch die Liste gehen, Schritt für Schritt.

**Was passieren soll.** Die Box behält bei jedem Schritt **dieselbe Größe** —
gemessen konstant `108 × 70` Bildpunkte über sechs Schritte. Sie darf nicht
schrumpfen, und nach fünf Schritten muss noch alles lesbar sein.

**Dein eigentliches Ziel, bitte mitprüfen** — du hast es so beschrieben:
*„dann mit tab wird der eintrag übernommen, die mail adresse erscheint im To:
feld."* Also: den gewünschten Namen ansteuern, **Tab** drücken, und im Feld
*To:* muss die Mailadresse stehen.

**Was ich NICHT gemessen habe:** ob sich ein Hermes 7.1 ebenso verhielt — der
Quelltext dieser Datei ist seit dem ersten Commit unverändert, aber das belegt
nichts über das Verhalten. Und: `InitList` rechnet die Position ohne
`ScreenToClient` um, die beiden anderen Stellen mit. Ob das ein zweiter Fehler
ist, steht offen. Wenn die Box an der **falschen Stelle** steht statt unter dem
Feld, bitte melden — das wäre dieser zweite Fall.

### <a id="c9"></a>Das Adressbuch — kommt ein neuer Kurzname an?

**Worum es geht.** Du hast es am 21.10.2026 gemeldet: *„adressbuch übernimmt
nichts."* Im Formular stand `hans`, im Baum weiter `Untitled`. Und dazu
*„es war 1x nicht richtig, 1x richtig gespeichert, jetzt wieder falsch."*
Behoben in 7.2.0.119, siehe [E-134](BEFUNDE.md#e-134).

**Was zu tun ist** — eine Minute:

1. *Tools → Address Book* öffnen.
2. Auf **New** klicken. Im Baum erscheint ein Eintrag `Untitled`, **und er ist
   jetzt ausgewählt** (vorher war das Adressbuch selbst ausgewählt).
3. Oben im Feld *Nickname* den Text ersetzen durch `hans`.
4. Irgendwo anders hinklicken, damit das Feld den Fokus verliert.

**Was passieren soll.** Der Baum zeigt **`hans`**, nicht mehr `Untitled`.

**Und die Gegenprobe, die den Fehler erst sichtbar gemacht hat:** Eudora
beenden, dann in deinem Mailverzeichnis die Datei `NNdbase.txt` öffnen. Dort
muss `alias hans` stehen. An 1.0.118 stand dort dreimal `alias Untitled`.

**Bitte auch das probieren**, denn hier habe ich nur den einen Weg gemessen:
einen **vorhandenen** Eintrag anklicken und umbenennen — das ging vorher schon
und darf nicht kaputtgegangen sein. Und einen Namen eingeben, den es **schon
gibt**: dann soll die bekannte Meldung kommen und der alte Name stehenbleiben.

**Was ich NICHT gemessen habe:** ob `Untitled` auch dann angenommen wird, wenn
du den Namen über *Einfügen* aus der Zwischenablage setzt statt ihn zu tippen.
Der Weg geht durch dieselbe Stelle, aber gemessen ist er nicht.

### <a id="c8"></a>Der Starttest — nimmt sich Eudora ein fremdes Mailverzeichnis?

**Worum es geht.** Startest du `Eudora.exe` **direkt** (Doppelklick) statt über
`Eudora starten.cmd`, sucht Eudora sich das Mailverzeichnis selbst — und findet
über die Registry das Verzeichnis, mit dem **zuletzt irgendeine** Eudora
gestartet wurde. Bisher nahm es das wortlos und schrieb hinein. Genau das hat
der Melder aus [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102)
erlebt; danach startete seine Hermes 7.1 nicht mehr
([E-131](BEFUNDE.md#e-131)). Ab 1.0.114 **fragt** Eudora vorher — seit **1.0.115** nur noch dann, wenn das Verzeichnis wirklich fremd ist (in 1.0.114 kam die Frage bei **jedem** Start, auch über das eigene Verzeichnis; Gregor hat das am 21.10.2026 gemeldet), seit **1.0.116** auf **allen** Startwegen und mit gemerkter Antwort, und seit **1.0.117** auch dann, wenn im fremden Ordner **keine** `Eudora.ini` liegt — der Fall einer kopierten Sicherung.

**Vorbereitung.** Testverzeichnis `C:\Users\Gregor\Eudora72-1.0.117-release`, am 21.10.2026 bereitgestellt. *(Bis zum 21.10.2026 stand hier `Eudora72-1.0.115-release` mit dem Zusatz „das Paket ist noch nicht geschnürt" — 1.0.115, 1.0.116 und 1.0.117 liegen alle drei bei dir, [LEKTOR-46](../Befunde/LEKTOR-46.md#l-46.5).)*
Dein bisheriges `Eudora72-1.0.113-release` **stehen lassen** — es ist in diesem
Test die „fremde Installation". Notier dir vorher Datum und Uhrzeit von
`Eudora72-1.0.113-release\Mailverzeichnis\Eudora.ini`; daran siehst du am Ende,
ob etwas hineingeschrieben wurde.

**Schritt 1 — ein Mal mit 1.0.113 starten und beenden.** Ganz normal über
`Eudora starten.cmd`. Damit zeigt die Registry auf dessen Mailverzeichnis;
nur so ist es nachher das „fremde".

**Schritt 2 — in 1.0.117 die `Eudora.exe` doppelklicken.** **Nicht**
`Eudora starten.cmd`.

*So ist es richtig:* es kommt ein Fenster **Eudora 7.2** mit der Meldung
*„Eudora found an existing mail folder that belongs to another installation"*
und dem Pfad deines 1.0.113-Verzeichnisses, dazu drei Schaltflächen:

| Taste | was passiert |
|---|---|
| **Yes** | das fremde Verzeichnis wird benutzt — **und beschrieben** |
| **No** | Eudora legt sich ein eigenes `Mailverzeichnis` neben dem Programm an (**Vorgabe**, so dass ein unbedachtes Enter nichts beschädigt) |
| **Cancel** | Eudora beendet sich, ohne irgendetwas anzufassen |

**Bitte „No" drücken.**

*Danach prüfen:* Eudora läuft mit einem leeren eigenen Postfach, und
`Eudora72-1.0.113-release\Mailverzeichnis\Eudora.ini` hat **noch denselben
Zeitstempel wie vorher**.

*Wenn gar kein Fenster kommt und Eudora einfach startet, bitte melden* — dann
greift die Rückfrage nicht. In dem Fall hilft die Zeile aus dem Protokoll:

```
grep "E-132" "C:\Users\Gregor\Eudora72-1.0.117-release\Mailverzeichnis\eudora.log"
```

Dort muss `E-132 Startverzeichnis: … fremd=1` stehen. Steht da `fremd=0`,
hat Eudora das Verzeichnis als sein eigenes angesehen — auch das bitte melden,
mit der ganzen Zeile.

*Voraussetzung:* keine. Geht offline, dauert zwei Minuten.

**Was dieser Test NICHT prüft:** ob eine daneben installierte **Hermes 7.1**
danach wieder startet. Dafür fehlt uns Hermes; der Melder aus Issue #102 ist
ausdrücklich darum gebeten worden.

**Bei uns schon gemessen** (20.10.2026, Prüfstand, nicht bei dir): *No* →
eigenes Verzeichnis, fremde `Eudora.ini` unverändert. *Yes* → fremdes
Verzeichnis, dessen `Eudora.ini` ändert sich nach fünfzehn Sekunden. *Cancel* →
Programm endet, nichts angefasst.

### <a id="c7"></a>C7 · Paket 1.0.112 — was am 20.10.2026 schon bestätigt wurde

Testverzeichnis `C:\Users\Gregor\Eudora72-1.0.112-release`, starten mit
`Eudora starten.cmd`. Das Mailverzeichnis im Paket ist **leer** — deine
Postfächer liegen in `C:\Users\Gregor\Eudora72-Postfaecher-gesichert` und
müssen bei **geschlossenem** Eudora hineinkopiert werden.
Unter *Help → About Eudora* muss **7.2.0.112** stehen.

**Schritt 1 — eine Nachricht als Datei speichern.** **Erledigt:** am 20.10.2026 an 1.0.110 von dir bestätigt (*„habe die .txt nach .html umbenannt und im chrome geöffnet. wird korrekt dargestellt."*).
Eine empfangene HTML-Nachricht mit Umlauten und `€` über *File → Save As*
sichern, die Datei danach in Thunderbird oder im Browser öffnen.
*So ist es richtig:* die Zeichen stimmen. Hat die Nachricht einen **Anhang**,
ist der in der gespeicherten Datei noch ein Anhang.
*Wenn stattdessen ein Block aus `--grenze`, Kopfzeilen und wirrem Text
dasteht, bitte melden:* dann ist der Anhang aus der Datei nicht mehr zu holen.
*Voraussetzung:* keine. Geht offline.

**Wichtig zur Endung.** Eudora bietet im Dialog nur `.txt` an und hängt `.txt`
an, **auch wenn der Inhalt HTML ist** — der Dateityp ändert kein einziges Byte
(gemessen, siehe [E-101](BEFUNDE.md#e-101): `.eml` und `.txt` sind
byte-identisch). Zum Prüfen die Datei also in `.html` umbenennen und im Browser
öffnen, oder in `.eml` umbenennen und in Thunderbird. Dass der Anwender darauf
keinen Hinweis bekommt, ist als [E-128](BEFUNDE.md#e-128) aufgenommen —
**kein neuer Fehler, nicht noch einmal melden.**

**Schritt 2 — Beenden, während noch etwas hochgeladen wird.** **Erledigt:** am 20.10.2026 an **1.0.111** auf beiden Wegen von dir bestätigt (2a: 6015 ms, 2b: 4015 ms, Warteschlange danach leer).
**Voraussetzung: der IMAP-Server muss erreichbar sein.** Ist er es nicht,
entsteht aus dem Verschieben nie ein Hochladen, und Eudora schließt sofort —
das ist **richtig so** und kein Fehler (*offline kein Warten*, seit
7.2.0.103). Am 20.10.2026 hat ein Testlauf gegen einen nicht auflösbaren
`imap.gmx.net` genau das gezeigt; im Protokoll stand `uebertragungen=0`.

**Zweimal durchführen — die Herkunft der Nachrichten macht den Unterschied:**

**2a — aus einem lokalen Postfach.** Mehrere Nachrichten aus `In` in einen
IMAP-Ordner verschieben und **sofort** *File → Exit*.

**2b — innerhalb des IMAP-Kontos.** Mehrere Nachrichten aus `Inbox
(<Dominant>)` in einen anderen IMAP-Ordner verschieben und **sofort**
*File → Exit*. Dieser Weg lief bis 7.2.0.110 an der Wache **vorbei**: gezählt
wurden nur Übertragungen aus einem **lokalen** Postfach. Gregors Lauf vom
20.10.2026 zeigte `eintraege=1` bei `uebertragungen=0` — ein Eintrag in der
Warteschlange, gezählt als null. Behoben in 7.2.0.113.

*So ist es richtig (beide Male):* das Fenster verschwindet **nicht**, solange die
Übertragung läuft. Dauert es länger als fünf Minuten, steht
*„Quit cancelled: …"* in der Statuszeile und Eudora bleibt offen.
Danach **noch einmal** *File → Exit*: es wartet wieder.
*Wenn das Fenster verschwindet, der Prozess aber weiterläuft, bitte melden.*
*Was sonst passieren kann:* eine halb übertragene Nachricht verliert ihre
eingebetteten Bilder.

### Nicht von Gregor zu testen: die Meldungsflut beim Filtern

[E-69](BEFUNDE.md#e-69) stand bis zum 20.10.2026 als Schritt 1 in diesem Plan,
mit der Anweisung *„ein IMAP-Postfach filtern, während der Server nicht
erreichbar ist"*. **Die Anweisung ist falsch.** Scheitert schon der
Verbindungsaufbau, zeigt Eudora **einen** Dialog (*„The IMAP command has
failed … host not found (11001)"*) und kommt nie bis zu den einzelnen
Nachrichten — [E-69](BEFUNDE.md#e-69) greift aber erst dort. Gemessen am
20.10.2026 an Gregors Lauf: **null** [`E-69`](BEFUNDE.md#e-69)-Spurmarken im Protokoll, *Task
Errors* leer. Er hat zweimal richtig gemessen und zweimal nichts gefunden,
weil der Handgriff nicht zum Befund passte.

Der nachgestellte Weg ist ein anderer: `In` öffnen, alles auswählen, `In.mbx`
von außen sperren (wie ein Virenscanner) und *Special → Filter Messages* —
`tools/messen-e69.ps1`, so am 17.10.2026 an 7.2.0.106 gemessen.
**Das stelle ich am Prüfstand selbst nach, bevor es wieder in diese Liste
kommt** ([erst-nachstellen-dann-ausliefern](../Arbeitsweise/erst-nachstellen-dann-ausliefern.md)).
Dasselbe gilt für die Gegenprobe zu [R1](../Befunde/PRUEFER-38.md), die ohne
einen ersten Filterlauf gar nichts aussagt.
### Was bekannt ist — bitte nicht als neuen Fehler melden

* Nach einem **Absturz**, einem Eingriff von **Defender**, einem Stromausfall
  oder einem erzwungenen Herunterfahren können eingebettete Bilder einer
  verschobenen Nachricht weiter fehlen. Schritt 2 prüft nur das **ordentliche**
  Beenden.
* Bilder, die als `data:`-Adresse in der Mail stecken, erscheinen als **grauer
  Kasten**.
* Bilder, die **breiter sind als das Fenster**, werden nicht verkleinert.
* Eine Größenangabe mit Einheit (`width="35px"`) wird nicht ausgewertet.
* Beim **Weiterleiten eines Newsletters** können Bilder doppelt erscheinen.

* Eine gespeicherte Nachricht heißt **`.txt` und enthält HTML** — ohne Hinweis
  ([E-128](BEFUNDE.md#e-128), 20.10.2026).
* Wird ohne Serververbindung in einen IMAP-Ordner verschoben und gleich
  beendet, zeigt der **Zielordner nur eine von fünf** Nachrichten; die anderen
  stehen vollständig in der Datei, und in der `Inbox` erscheinen sie wieder
  über *Rechtsklick → Show Deleted Messages*
  ([E-129](BEFUNDE.md#e-129), 20.10.2026). **Kein Datenverlust.**
### Wie dein Urteil zählt

Mit der **Paketnummer** — der des Pakets, das du wirklich gestartet hast:
*„Starttest an `<Paketnummer>` in Ordnung"* oder *„Starttest an
`<Paketnummer>` gescheitert, es kam keine Rückfrage"*. Ohne die Nummer
ist das Urteil wertlos — einmal stand „behoben“ einen Tag lang da, während
das ausgelieferte Paket den Fehler noch hatte.

Eigene Tests dieser Fassung: **243 Tests, 243 bestanden.**

---

## Buchführung — was wann an welchem Paket bestätigt wurde

**Stand 21.10.2026, nachmittags. [C9](#c9) ist durch: Gregor hat 1.0.119 getestet und [E-134](BEFUNDE.md#e-134) bestätigt** (*„ja, e-134 eintragen"*) — sein Bildschirmfoto zeigt `hans`, `markus` und `freenet` mit Adressen im Baum. **[C10](#c10) ist ebenfalls durch: Gregor hat 1.0.120 getestet und [E-135](BEFUNDE.md#e-135) bestätigt** (*„beim cursor up/down bleibt die größe der box gleich. klasse!"*) — die Vervollständigungsbox im `To:`-Feld behält ihre Größe. **Offen zu testen bleibt [C8](#c8)** (der Starttest). Das Paket 1.0.119 liegt seit dem 21.10.2026 um 13:07 in `C:\Users\Gregor\Eudora72-1.0.119-release`; diese Zeile unverändert. Geschnürt und bei Gregor stehen 1.0.115 bis 1.0.118 (1.0.116 ist von ihm getestet, 1.0.117 und 1.0.118 nicht); 1.0.114 war bei ihm und ist an seinem eigenen Fund gescheitert. Veröffentlicht ist 1.0.120 als `v1.0.120` (21.10.2026, 19:07:37 UTC) — es trägt 1.0.118, 1.0.119 und 1.0.120; davor 1.0.117 als `v1.0.117` (07:56:56 UTC); an 1.0.117 selbst hat Gregor nichts am laufenden Programm gemessen, davor an 1.0.113 ebenfalls nichts. Davor Paket 1.0.112** (veröffentlicht als `v1.0.112`; an **1.0.110** bestätigt: eine gespeicherte Nachricht wird in Chrome richtig dargestellt — an **1.0.111** bestätigt: der Beenden-Weg auf beiden Wegen, 6015 ms aus dem lokalen Postfach und 4015 ms innerhalb des IMAP-Kontos — an **1.0.112** selbst ist **nichts am laufenden Programm gemessen**, es nimmt nur den Hochladezähler aus [PRÜFER-39](../Befunde/PRUEFER-39.md) N1 zurück). Davor: (Teil A, C1, C2, [E-83](BEFUNDE.md#e-83), [E-85](BEFUNDE.md#e-85), [E-93](BEFUNDE.md#e-93) erledigt; [E-101](BEFUNDE.md#e-101) durchgefallen; [E-95](BEFUNDE.md#e-95)/[E-96](BEFUNDE.md#e-96) am 14.10. an 1.0.87 bestätigt; [C4](#c4) erledigt: [E-112](BEFUNDE.md#e-112), [E-103](BEFUNDE.md#e-103), [E-115](BEFUNDE.md#e-115) an 1.0.86, [E-117](BEFUNDE.md#e-117) an 1.0.87 bestätigt); 1.0.85 bis 1.0.87 liegen bei Gregor, 1.0.87 ist als `v1.0.87` veröffentlicht; getestet wurde an 1.0.84, 1.0.86 und 1.0.87; **Paket 1.0.111 ([E-69](BEFUNDE.md#e-69) Meldungsflut und die Prüfpunkte am Beenden-Weg zu [E-123](BEFUNDE.md#e-123); Prüfschritte in [C6](#c6); dazu [E-101](BEFUNDE.md#e-101) dritter Teil — F1, F3 und F4 aus [PRÜFER-37](../Befunde/PRUEFER-37.md) behoben, die Regression gegenüber 1.0.106 ist weg) — 1.0.107, 1.0.108 und 1.0.109 wurden übersetzt, aber NIE GESCHNÜRT, ihr Inhalt steckt in 1.0.110;** davor **Paket 1.0.106 ([E-69](BEFUNDE.md#e-69) und [E-123](BEFUNDE.md#e-123)) bei Gregor, nicht getestet;** davor Paket 1.0.104 ([E-123](BEFUNDE.md#e-123) Beenden wartet), **ersetzt durch 1.0.106, nie getestet;** davor **Paket 1.0.101 (gesendete Post nach IMAP, von Gregor bestätigt, veröffentlicht als `v1.0.101`);** davor **Paket 1.0.100 ([PRÜFER-31](../Befunde/PRUEFER-31.md) F1: zwei gesendete Mails auf einmal nach IMAP) von Gregor am 16.10.2026 getestet (eine gesendete und zwei Mails aus `In` hochgeladen, sauber beendet; zwei gesendete auf einmal nicht geprüft), kein Release wegen [PRÜFER-32](../Befunde/PRUEFER-32.md);** davor **Paket 1.0.99 (Neubau von 1.0.98, [E-124](BEFUNDE.md#e-124); [E-121](BEFUNDE.md#e-121) gesendete Post wieder hochgeladen und nur noch die verschobene Nachricht entfernt, [E-83](BEFUNDE.md#e-83) zweite Ursache) von Gregor am 16.10.2026 bestätigt; 1.0.97 und 1.0.98 nicht testen;** Paket 1.0.96 ([E-121](BEFUNDE.md#e-121) Kollision Kennung/Server-UID, an 1.0.95 gefunden) an 1.0.96 bestätigt; [E-118](BEFUNDE.md#e-118) Teil 1 an 1.0.89, Teil 2 an 1.0.90 bestätigt; offen: [C5](#c5) zum Testverzeichnis 1.0.89 ([E-105](BEFUNDE.md#e-105))**

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
[L-27.4](../Befunde/LEKTOR-27.md#l-27.4)). Geprüft wird nur noch der Newsletter.

| | muss sein |
|---|---|
| — | **entfällt** (Gregor 13.10.2026): das Werbefenster kommt in diesem Bau nicht mehr, siehe [AN-2](BEFUNDE.md#an-2) |
| ✅ | dasselbe bei einem HTML-Newsletter: **kein** CSS im Nachrichtentext |

*(Der Werbeweg ist an diesem Bau nicht auslösbar; die frühere Zeile zu
`LogLevel=128159` und `grep "PLIST\|E-7"` entfällt mit ihm.)*

### C3 · Die sechs, die auf dein Urteil warteten — alle beurteilt

**Stand 13.10.2026:** [E-85](BEFUNDE.md#e-85) und [E-93](BEFUNDE.md#e-93) bestätigt, [E-83](BEFUNDE.md#e-83) nachgemessen,
[E-101](BEFUNDE.md#e-101) durchgefallen (wieder offen). **[E-95](BEFUNDE.md#e-95) und [E-96](BEFUNDE.md#e-96) am 14.10.2026 an 1.0.87 bestätigt.**

**Berichtigt am 12.10.2026 (LEKTOR, [L-18.5](../Befunde/LEKTOR-26.md#l-18.5)):** hier standen *fünf*. `BEFUNDE.md` führt
**fünfzehn** Behebungen als „von Gregor noch nicht bestätigt" — vierzehn davon
in Teil A, und eine, die in keinem Teil dieses Plans vorkam: [**E-101**](BEFUNDE.md#e-101), die
unbrauchbare gespeicherte Datei. Ausgerechnet die aus der Datenverlustklasse.

| | Befund | Handgriff |
|---|---|---|
| ❌ | [**E-101**](BEFUNDE.md#e-101) | eine **weitergeleitete** Nachricht über *File → Save As* sichern und die `.eml` in einem anderen Programm öffnen — sie muss lesbar sein (`Content-Type`, `MIME-Version`, kein `<x-html>`) |
| ✅ | [**E-85**](BEFUNDE.md#e-85) | eine Nachricht mit Umlauten **über IMAP** abrufen — Umlaute richtig? |
| ✅ | [**E-83**](BEFUNDE.md#e-83) | Eudora normal beenden — es endet wirklich, kein Prozess bleibt |
| ✅ | [**E-93**](BEFUNDE.md#e-93) | eine **bereits weitergeleitete** Nachricht noch einmal weiterleiten — Inhalt vollständig? |
| ✅ | [**E-95**](BEFUNDE.md#e-95) | die **Doctolib**- und die **FairToner**-Nachricht je beantworten und weiterleiten — kein Bild abgeschnitten oder gequetscht, Text frei ([L-33.4](../Befunde/LEKTOR-33.md#l-33.4)) — **bestätigt 14.10.2026 an 1.0.87** |
| ✅ | [**E-96**](BEFUNDE.md#e-96) | dasselbe mit mehreren Bildern hintereinander — **bestätigt 14.10.2026 an 1.0.87** |

**[E-97](BEFUNDE.md#e-97) und [E-99](BEFUNDE.md#e-99) gehören nicht hierher** — die hast du am 17.09.2026 schon
bestätigt (*„gespeichert. funktioniert."* / *„ja, kein datenverlust!"*).

### <a id="c4"></a>C4 · Die Pakete 1.0.85 bis 1.0.87 — alle bestätigt

**Stand 14.10.2026 ([LEKTOR-32](../Befunde/LEKTOR-32.md#lektor-32)).** 1.0.85, 1.0.86 und 1.0.87 liegen als
Testverzeichnis bei dir; alle vier Befunde sind bestätigt, [E-117](BEFUNDE.md#e-117) am 14.10.2026 an 1.0.87.
1.0.87 ist am 14.10.2026 als `v1.0.87` veröffentlicht.

| | Befund | Paket | Handgriff |
|---|---|---|---|
| ✅ | [**E-112**](BEFUNDE.md#e-112) | 1.0.86 | die Kleinanzeigen-Nachricht weiterleiten — das Logo steht **über** „Deine Anzeige wird weniger gesehen“, nicht darauf, und in der angegebenen Größe (*„paßt dagegen“*) |
| ✅ | [**E-103**](BEFUNDE.md#e-103) | 1.0.86 | dieselbe Prüfung — kein Bild auf dem Text |
| ✅ | [**E-115**](BEFUNDE.md#e-115) | 1.0.86 | ein IMAP-Postfach öffnen, dann Ctrl+F — keine Meldung „Encountered an improper argument“ (*„tritt bisher nicht mehr auf“*; vorläufig, der Fehler war sporadisch) |
| ✅ | [**E-117**](BEFUNDE.md#e-117) | 1.0.87 | die eBay-Nachricht (Synology, „Der Countdown läuft!“) weiterleiten oder beantworten — unter der Überschrift steht das **Foto**, keine leere Fläche (bestätigt 14.10.2026, Bildschirmfoto, *„so?“*). Mit `LogLevel=58527` (wie bei dir eingestellt) nennt die Spurmarke `E-110 Laden: src=…` die Adresse mit `&`, nicht mit `&amp;` |

### <a id="c5"></a>C5 · Paket 1.0.89 — E-118 und E-105

**Stand 14.10.2026 ([LEKTOR-34](../Befunde/LEKTOR-34.md#lektor-34)).** Testverzeichnis
`C:\Users\Gregor\Eudora72-1.0.89-release`, die Anleitung liegt dort als `TESTEN.txt`.
1.0.88 wurde nicht ausgeliefert (*„nein, 0.88 teste ich nicht zusätzlich, deine tests
sollten reichen“*); [E-105](BEFUNDE.md#e-105) wird deshalb an 1.0.89 geprüft.
**Vorher:** das Mailverzeichnis aus 1.0.87 hineinkopieren, Eudora dabei geschlossen —
das Mailverzeichnis im Paket ist leer.

| | Befund | Paket | Handgriff |
|---|---|---|---|
| ✅ | [**E-118**](BEFUNDE.md#e-118) | 1.0.89 | eine HTML-Mail (etwa einen Newsletter) aus „In“ in einen IMAP-Ordner verschieben, den Ordner öffnen, die Mail anklicken — sie erscheint normal (Bilder, Formatierung, Umlaute richtig), **kein** `<head>… <body …>` als Text. Mails, die schon **vor** 1.0.89 verschoben wurden, bleiben auf dem Server falsch und erscheinen auch in 1.0.89 als Quelltext — **bestätigt 14.10.2026 an 1.0.89** (waipu.tv-Mail). **Nicht bestanden** bei der SoftMaker-Mail: die eingebetteten Bilder fehlten (*„hier fehlt der inhalt“*) – das ist [E-118](BEFUNDE.md#e-118) Teil 2, zu prüfen an 1.0.90 |
| ☑ | [**E-105**](BEFUNDE.md#e-105) | 1.0.120 | einen freenet-Newsletter beantworten oder weiterleiten — jedes Bild und jeder Absatz genau einmal, keine Zeile `? ? ? ?` über dem Inhalt |

Bekannt und nicht behoben, also kein neuer Fehler: [E-119](BEFUNDE.md#e-119) (`data:`-Bilder als
grauer Kasten), [E-113](BEFUNDE.md#e-113) (Bilder breiter als das Fenster), [E-116](BEFUNDE.md#e-116)
(`width="35px"` mit Einheit).

---

### <a id="c6"></a>C6 · Paket 1.0.110 — E-69, der Beenden-Weg und eine bekannte Regression

**Stand 20.10.2026 ([LEKTOR-44](../Befunde/LEKTOR-44.md#lektor-44)).** Quellstand
**7.2.0.114**, Zweig `e-132-fremdes-mailverzeichnis`, **241 Tests / 241
bestanden** — **noch nicht als Paket geschnürt.** Veröffentlicht ist
**1.0.113** (`v1.0.113`, 20.10.2026, 13:01:36 UTC); davor am selben Tag
`v1.0.112`. Bis zum 20.10.2026 stand hier *„Quellstand 7.2.0.110, Zweig
`e-69-meldungsflut`, 229 Tests"* — vier Fassungen alt, und die Zeile darüber
sagte trotzdem *Stand 20.10.2026*.

**1.0.107, 1.0.108 und 1.0.109 gibt es nicht als Paket** — sie wurden
übersetzt und wieder verworfen; ihr Inhalt steckt vollständig in 1.0.110. Du
hast am 19.10.2026 alle alten Testverzeichnisse gelöscht (*„alles weg!"*) —
**1.0.110 ist das erste Paket, das du danach bekommst.** Wenn dir jemand
1.0.107, 1.0.108 oder 1.0.109 zum Testen nennt, ist das falsch.

| | Schritt | wird geprüft |
|---|---|---|
| ☐ | **Schritt 1** — Nachricht als Datei speichern | [E-101](BEFUNDE.md#e-101), dritter Teil ([F1](../Befunde/PRUEFER-37.md), F3, F4) |
| ☐ | **Schritt 2** — beenden während einer Übertragung (**Server muss erreichbar sein**) | [E-123](BEFUNDE.md#e-123), der Beenden-Weg und [R4](../Befunde/PRUEFER-38.md) |
| — | ~~filtern bei totem Server~~ — **zurückgezogen am 20.10.2026**, der Handgriff trifft [E-69](BEFUNDE.md#e-69) nicht | steht oben unter *Nicht von Gregor zu testen* |

**Was jeder Schritt im Einzelnen verlangt und woran man sieht, dass er
geglückt ist, steht ganz oben in diesem Dokument** — dort im Klartext, ohne
Befundnummern. Hier stehen nur die Haken und die Zuordnung zu den Befunden.
**[E-123](BEFUNDE.md#e-123) selbst bleibt offen.** Was hier geprüft wird, sind
die Prüfpunkte am Beenden-Weg. Nach einem Absturz, einem Eingriff von Defender,
einem Stromausfall oder einem erzwungenen Herunterfahren können eingebettete
Bilder weiter fehlen.

**Die Regression aus [PRÜFER-37](../Befunde/PRUEFER-37.md) ist behoben** (Nachtrag
19.10.2026, auf Gregors Wort *„f1 und f3/f4 erst beheben, dann 0.111 releasen"*):
F1, F3 und F4 stecken ebenfalls in 1.0.110. Eine Nachricht in `windows-1251`,
`koi8-r` oder `iso-8859-2` behält beim Speichern ihre richtige Angabe, und eine
echte mehrteilige Nachricht wird nicht mehr zu `text/plain` gemacht. Der
Handgriff dazu steht oben in der Tabelle.

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
