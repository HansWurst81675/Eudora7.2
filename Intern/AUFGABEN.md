# Aufgaben für die nächste Sitzung

**Stand 22.10.2026**, Quellstand **7.2.0.121** / `VERSION` **1.0.121** — nicht geschnürt: [E-111](BEFUNDE.md#e-111), `resolve_URL` schreibt nicht mehr über das Zielfeld hinaus; die Längenschranke verglich mit `==` statt `>=` **und prüft erst nach dem Schreiben**, bei `nMaxLength` 0 oder 1 lief die Schleife bis zum Quellende durch. 246 Tests, 246 bestanden; Gegenprobe am alten Stand 245 von 246. Davor **7.2.0.120** / **1.0.120**, veröffentlicht als `v1.0.120` — die Auswahlbox im `To:`-Feld schrumpft nicht mehr bei jedem Cursor-Schritt ([E-135](BEFUNDE.md#e-135)). **Die vollständige Fassungsgeschichte steht in [CHANGELOG.md](../CHANGELOG.md)**, was zur Fassung 7.2.1.0 noch fehlt oben in [ZIEL.md](../ZIEL.md).
(`grep EUDORA_BUILD_VERSION Eudora71/Version.h`, `cat VERSION`). Der Einstieg
ist [WEITERMACHEN.md](WEITERMACHEN.md), die Fassungsgeschichte mit allen
Messungen [CHANGELOG.md](../CHANGELOG.md), der Maßstab [ZIEL.md](../ZIEL.md). `main`
ist gesperrt; jeder Agent arbeitet in seinem eigenen Zweig
([AGENTEN.md](AGENTEN.md)).

## Die Hauptarbeit bis 13.10.2026: vierzehn gebaute Behebungen — jetzt von Gregor bestätigt

> **Stand 13.10.2026 ([L-27.3](../Befunde/LEKTOR-27.md#l-27.3)).** Gregor hat an Paket 1.0.84 den
> [Testplan](TESTPLAN.md) Teil A durchgeprüft: alle vierzehn ([E-49](BEFUNDE.md#e-49), [E-50](BEFUNDE.md#e-50),
> [E-52](BEFUNDE.md#e-52) bis [E-63](BEFUNDE.md#e-63)) sind **bestätigt**, damit auch **A-4**. Ebenso bestätigt:
> [E-85](BEFUNDE.md#e-85), [E-93](BEFUNDE.md#e-93) und [AN-2](BEFUNDE.md#an-2); [E-83](BEFUNDE.md#e-83) auf seinen Auftrag an 1.0.84 nachgemessen.
> **Durchgefallen:** [E-101](BEFUNDE.md#e-101) (wieder offen), [E-112](BEFUNDE.md#e-112) an 1.0.84 unverändert, [E-103](BEFUNDE.md#e-103) an 1.0.84 widerlegt
> (beide seither in 7.2.0.85 behoben, veröffentlicht mit `v1.0.87`, von Gregor an 1.0.86 bestätigt);
> **neu:** [E-114](BEFUNDE.md#e-114) und [E-115](BEFUNDE.md#e-115). Was unten als *wartet* steht, ist der
> Stand davor; die Urteile mit Zitat stehen in [BEFUNDE.md](BEFUNDE.md).

**Alle neun Kriterien aus [ZIEL.md](../ZIEL.md) sind entweder erfüllt oder haben
eine gebaute Behebung.** Sieben sind belegt (0, 1, 3, 5, 6, 7, 8), zwei sind
fast erfüllt (2, 4). Beiden gemeinsam fehlt die Meldung „Encountered an
improper argument" beim **Anzeigen** mancher Nachrichten; **Kriterium 2 fehlt
darüber hinaus** [**E-86**](BEFUNDE.md#e-86) (HTML-Nachrichten falsch dargestellt) und [**E-77**](BEFUNDE.md#e-77)
(IMAP-Postfachnamen roh) — beides steht in `ZIEL.md` in der eigenen Zeile
**2a**. Bis zum 14.09.2026 stand hier „beiden fehlt **dasselbe**", und das
stimmte seit der Aufteilung von Kriterium 2 nicht mehr.

**Dazu warteten sechs frische Behebungen auf sein Urteil** *(Stand vor dem 13.10.2026 — [E-85](BEFUNDE.md#e-85) und [E-93](BEFUNDE.md#e-93) sind seither von Gregor an 1.0.84 bestätigt, [E-83](BEFUNDE.md#e-83) nachgemessen; offen bleiben [E-95](BEFUNDE.md#e-95)/[E-96](BEFUNDE.md#e-96))*: [**E-85**](BEFUNDE.md#e-85) (Umlaute
über IMAP, 7.2.0.52, am laufenden Programm belegt), [**E-83**](BEFUNDE.md#e-83) (Eudora liess
sich nicht beenden, 7.2.0.53, am laufenden Programm gemessen), [**E-93**](BEFUNDE.md#e-93)
(Inhaltsverlust beim Weiterleiten einer bereits weitergeleiteten Nachricht,
7.2.0.59), [**E-95**](BEFUNDE.md#e-95)/[**E-96**](BEFUNDE.md#e-96) (Bildgrößen im Verfassenfenster, 7.2.0.62
und 7.2.0.63, an einem selbst gestarteten Eudora gemessen) sowie [**E-97**](BEFUNDE.md#e-97)
(*File → Save As* beendete Eudora sofort, 7.2.0.64, am laufenden Programm
gemessen — der Fehler steckte in **jeder** Fassung seit 1.0.49 und steckt
auch im veröffentlichten `v1.0.50`; **von Gregor am 17.09.2026 an 1.0.64
bestätigt**: *„speichern test hat also funktioniert."*).

**Aus der Arbeit am Speichern sind drei weitere Befunde entstanden:**
[**E-99**](BEFUNDE.md#e-99) (Datenverlust beim Senden eines gesicherten Entwurfs, 7.2.0.64, vom
Gregor bestätigt: *„ja, kein datenverlust!"*), [**E-100**](BEFUNDE.md#e-100) (dieselbe
Nullzeiger-Stelle wie [E-97](BEFUNDE.md#e-97) an drei weiteren Stellen, dazu `m_Inc`/`m_Guess`
uninitialisiert in die INI, 7.2.0.65, am laufenden Programm geprüft) und
[**E-101**](BEFUNDE.md#e-101) (die gespeicherte Datei war ohne `Content-Type`-Zeile und mit
Eudoras internem Marker `<x-html>` für jedes andere Programm unbrauchbar,
**7.2.0.66** (erster Teil) und **7.2.0.69** (zweiter Teil — ohne *Kopfzeilen
einschließen* fehlte der `Content-Type` ganz), am laufenden Programm geprüft,
**171 Tests** — **seit 13.10.2026 wieder offen**: Gregors an 1.0.84 gespeicherte
HTML-Datei sagt im `<meta>` UTF-8 und enthält Windows-1252), [**E-103**](BEFUNDE.md#e-103) (Bilder ohne
Größenangabe lagen über dem Text. **Das Fehlerbild** hat Gregor am 17.09.2026
an 1.0.64 belegt — auf seinem Bild liegt das *kleinanzeigen*-Logo über dem
Text. **Gemessen und behoben** wurde an seiner Doctolib-Nachricht: der Import
reserviert jetzt eine Mindestzeilenhöhe, die echte Höhe aus der geladenen Datei
gewinnt danach. **Von Gregor am laufenden Programm noch nicht bestätigt**,
7.2.0.67) und [**E-104**](BEFUNDE.md#e-104) (die Kopfzeilen der
gespeicherten Nachricht klebten zusammen, weil `UnwrapText` über die ganze
Nachricht lief und weil verdorbene INI-Werte aus [**E-100**](BEFUNDE.md#e-100) „Absätze raten"
eingeschaltet hatten, 7.2.0.67 für die verfasste und 7.2.0.68 für die
empfangene Nachricht). [**E-106**](BEFUNDE.md#e-106) (7.2.0.68) ist **von Gregor am 17.09.2026 an
1.0.69 bestätigt**: die Überlappung ist weg, der Text steht wieder unter dem
Bild. [**E-108**](BEFUNDE.md#e-108) (7.2.0.72) entfernt den Stilweg, der beim Antworten zum Absturz
geführt hat — [**E-107**](BEFUNDE.md#e-107) war die falsche Erklärung und ist durch Gregors
Protokoll widerlegt. Ursprünglich: Bilder, die größer sind als im HTML
angegeben, liegen
über dem Text — sein Protokoll vom 17.09.2026 zeigt, dass Bilder **ohne**
Größenangabe nachgemessen werden und die Zeile mitwächst, Bilder **mit**
Angabe aber nie. **Offen bleibt
[E-98](BEFUNDE.md#e-98):** die beiden Optionen *Kopfzeilen einschließen* und *Absätze raten*
fehlen im Speicherdialog, weil Windows 10 die Dialogvorlage von 1996 nicht
mehr anzeigt.

**Am 18.09.2026 behoben: [E-110](BEFUNDE.md#e-110)** — [E-112](BEFUNDE.md#e-112) galt damals mit, der Versuch wirkte aber nicht
(siehe unten; bis zum 13.10.2026 stand er hier in der Überschrift, [LEKTOR-28](../Befunde/LEKTOR-28.md#lektor-28)). Beim **Antworten und Weiterleiten**
kamen nicht alle Bilder ins Verfassenfenster, ein Teil stand als grauer Kasten
da. **Ursache:** `resolve_URL` (`HTMLUtils.cpp`) warf jede Prozent-Sequenz weg,
statt sie zu entschlüsseln — aus `en%20aktuellen%20Verlust.png` wurde
`enaktuellenVerlust.png`, der Server antwortete **404**, Eudora legte die
Fehlerseite ab und zeichnete einen grauen Kasten. Zehn von zwanzig Bildern.
**Behoben in 7.2.0.75** mit einem `++output;`, **von Gregor bestätigt** (49 ×
`datei=1 intern=1`, kein `intern=0` mehr).

**Dabei wurde [E-112](BEFUNDE.md#e-112) sichtbar:** die Bilder erschienen danach in **Originalgröße**
statt in der angegebenen — das WhatsApp-Symbol ist als `35x35` ausgezeichnet und
die Datei hat `330x327`. Das war eine Regression der **[E-106](BEFUNDE.md#e-106)**-Behebung, die die
Zeile vergrößerte statt das Bild zu verkleinern. **Der Versuch in 7.2.0.76
wirkt nicht** — von Gregor am 18.09.2026 widerlegt und am 13.10.2026 an 1.0.84
unverändert gesehen; [E-112](BEFUNDE.md#e-112) war damit **wieder offen**. *(Bis zum 13.10.2026 stand
hier „Behoben in 7.2.0.76, noch nicht von Gregor bestätigt“ —
[L-27.3](../Befunde/LEKTOR-27.md#l-27.3).)* **Seit 7.2.0.85 behoben, ausgeliefert mit `v1.0.87`:** die Metadatei
wird in der angegebenen Größe geschrieben (`E112MetadateiAusDIB`), am laufenden Programm
an `a36c47f` gemessen (alle drei Bilder der Prüfnachricht richtig, [E-103](BEFUNDE.md#e-103) mit);
PRÜFER-22 F1 und F2 sind danach eingebaut und am Bau `11b6a3a` gemessen (70x70 und
150x58); PRÜFER-23 N1 (beim Antworten `height="1"`) ist behoben (`9f5142b`), am laufenden
Programm gemessen, die Gegenrichtung behoben und gemessen; N2 bis N5 sind offen; **von Gregor
am 13.10.2026 an 1.0.86 bestätigt** (*„paßt dagegen“*). Neu daraus: [E-116](BEFUNDE.md#e-116) (`width="35px"` wird als 3508 gelesen).
Einzelheiten in [CHANGELOG.md](../CHANGELOG.md), Abschnitt 7.2.0.85.

**Weiter offen: [E-113](BEFUNDE.md#e-113)** — ein Bild, dessen **angegebene** Breite größer ist als
das Fenster, läuft rechts hinaus (`max-width:100%` kennt Paige nicht). Auf
Gregors Anordnung *„erst A, dann B"* getrennt gehalten. Einzelheiten in
[BEFUNDE.md](BEFUNDE.md), Prüfanleitungen in [CHANGELOG.md](../CHANGELOG.md),
Abschnitte 7.2.0.75 und 7.2.0.76.

**Stand 17.09.2026, seit dem 12.10.2026 überholt** — veröffentlicht ist jetzt
`v1.0.83`, siehe unten. **Gebaut, geschnürt und veröffentlicht war damals
7.2.0.72 / 1.0.72** (gemessen an `Eudora71/Version.h`, `VERSION` und
`gh release list`). **Es war der erste Stand, der alles enthielt und zugleich
draußen war**: [E-93](BEFUNDE.md#e-93), [E-96](BEFUNDE.md#e-96), [E-97](BEFUNDE.md#e-97), [E-99](BEFUNDE.md#e-99), [E-100](BEFUNDE.md#e-100), [E-101](BEFUNDE.md#e-101) in beiden Teilen, [E-103](BEFUNDE.md#e-103),
[E-104](BEFUNDE.md#e-104), [E-106](BEFUNDE.md#e-106) und [E-108](BEFUNDE.md#e-108). **Bei Gregor lagen damals 1.0.65, 1.0.67, 1.0.68,
1.0.69, 1.0.71 und 1.0.72** — **1.0.70 nie**. Am 12.10.2026 liegen dort die
Verzeichnisse 1.0.72 bis 1.0.76 und 1.0.83 sowie die ZIPs 1.0.44, 1.0.53 und
1.0.57 (gemessen mit `ls C:\Users\Gregor\Eudora72-*`).

> **Berichtigt am 18.09.2026 (LEKTOR, [L-15.3](../Befunde/LEKTOR-15.md#l-15.3)).** Hier stand *„Gebaut und
> geschnürt ist **7.2.0.70 / 1.0.70** … **Es ist das erste Paket, das alles
> enthält** … Bei Gregor liegen 1.0.65 sowie **1.0.67 bis 1.0.72**"*. Drei
> Fehler in fünf Zeilen: der Stand ist 7.2.0.72 (`Version.h`, `VERSION`,
> und die Zeile 3 **derselben Datei** sagt es bereits), 1.0.72 ist der
> vollständige Stand, und 1.0.70 liegt bei Gregor **nicht** — gemessen mit
> `ls C:\Users\Gregor\Eudora72-*`.

**Veröffentlicht war `v1.0.112`** (abgelöst, draußen ist seit dem 21.10.2026 `v1.0.120`) — am 20.10.2026 um 11:55:10 UTC auf GitHub veröffentlicht (*Latest*), Marke auf `f87a4a74` = Merge von PR #113, ZIP-SHA-256 `0406c1084640a766c2bd4d9eed5681974f5d2f0280f707de545c72ced28765fd`. **Davor `v1.0.101`** — am 17.10.2026 um 19:12:08 UTC (seinerzeit auf GitHub bereitgestellt, inzwischen abgelöst; Marke auf `eec4e4e5` = Merge von PR #99, ZIP 9 066 464 Byte, SHA-256 `79a40bc00e2ca4d929e23f4ad5d043a8cbdab27ce9a7ab66eb58a77764e8694a`, nachgerechnet an der von GitHub zurückgeladenen Datei; die 34 EXE/DLL/OCX byteidentisch mit Gregors getestetem `Eudora72-1.0.101-release`; Defender: 0 Funde). **Davor `v1.0.87`** — am 14.10.2026 um 05:46 Uhr UTC auf GitHub
herausgegangen (bis 17.10.2026 das neueste), Marke auf `41c6752` (Merge von PR #96), mit
[E-112](BEFUNDE.md#e-112), [E-103](BEFUNDE.md#e-103), [E-115](BEFUNDE.md#e-115) und [E-117](BEFUNDE.md#e-117);
Gregor hat sie vorher an 1.0.86 und 1.0.87 geprüft. Davor **`v1.0.84`** — am 12.10.2026
um 12:59 Uhr UTC, Marke auf `eb54752`, mit [E-94](BEFUNDE.md#e-94);
Gregor hat sie vorher an seinem Postfach geprüft (Bildschirmfoto). Davor
**`v1.0.83`** — am 12.10.2026 um 11:18 Uhr UTC, Marke auf `ec9f11d`; Gregor hat
die Fassung vorher über IMAP an seinem Postfach geprüft (*„gekürzt mit endung
reicht“*). Davor **`v1.0.72`** — am 17.09.2026 um 20:07 Uhr UTC, auf dem
Merge-Commit `8da72c8`; Gregor hat sie vorher am laufenden Programm geprüft
(*„kein crash“*).
**1.0.65 bis 1.0.71 sind nicht freigegeben** — 1.0.71 stürzt ab und ist
ausdrücklich nicht zu benutzen.

> **Berichtigt am 17.09.2026 (LEKTOR, [L-13.1](../Befunde/LEKTOR-13.md#l-13.1)).** Hier stand *„veröffentlicht
> ist weiterhin nur `v1.0.50`"*. Gemessen mit `gh release list` und
> `git ls-remote --tags origin`: `v1.0.64` existiert. Dieselbe Unwahrheit
> stand in `WEITERMACHEN.md`, `Releases/PAKETE.md`, `README.md` und
> `tools/RELEASES.md` — fünf Dokumente, ein Irrtum.
>
> **Nachgemessen am 17.09.2026 (LEKTOR, [L-14.2](../Befunde/LEKTOR-14.md#l-14.2)):** In `WEITERMACHEN.md` stand
> die Unwahrheit danach **weiter** (Zeile 24, *„Auf GitHub veröffentlicht ist
> weiterhin `v1.0.50`; 1.0.51 bis 1.0.68 sind nicht freigegeben"*), und
> **`PORTIERUNG.md` trug sie auch** — dort war sie in keinem der beiden
> Vermerke genannt. Es waren also **sechs** Dokumente, und zwei blieben
> stehen. Beide sind jetzt berichtigt.

| # | | Stand |
|---|---|---|
| 4 | **Keine Abstürze** | *fast* — Strg-N fünfmal ohne Absturz gemessen, das Beenden ist erledigt (Kriterium 7), und mit [**E-43**](BEFUNDE.md#e-43) sind [**E-37**](BEFUNDE.md#e-37) und [**E-38**](BEFUNDE.md#e-38) weggefallen. Offen: die Meldung beim Anzeigen mancher Nachrichten |
| 5 | **Eine neue Mail schreiben und abschicken** | **erfüllt** — Gregor am 07.09.2026: *„mail können jetzt abgeschickt werden."* |
| 6 | **Eine Mail weiterleiten** | **erfüllt** — Gregor am 07.09.2026: *„weiterleitung funktioniert übrigens."* |
| 7 | ***File → Exit*** beendet Eudora sauber | **erfüllt** — Gregor am 08.09.2026: *„schließen klappt jetzt."* Alle drei Wege: Menü, Alt-F4, Kreuz |
| 8 | Offene Fenster sichtbar und auswählbar | **erfüllt** — Gregor am 09.09.2026: der Klick auf eine Registerkarte holt das Fenster nach vorn, die Beschriftungen stimmen mit dem Menü *Window* (**A-3** / [**E-48**](BEFUNDE.md#e-48)) |

**Was sich am 09.09.2026 geändert hat.** Gregor hat **A-3** bestätigt und damit
Kriterium 8 geschlossen, und er hat die Höhenänderung des unteren Bereichs
bestätigt (*„verschieben rauf / runter — bug gefixt, die anzeige ist
korrekt."*). Am 08.09.2026 hatte er [**E-43**](BEFUNDE.md#e-43) bestätigt (*„persona läßt sich
löschen. keine messagebox"*) — und damit fielen [**E-37**](BEFUNDE.md#e-37) und [**E-38**](BEFUNDE.md#e-38) mit weg,
weil beide Symptome derselben Ursache waren. **[E-37](BEFUNDE.md#e-37), [E-38](BEFUNDE.md#e-38) und [E-43](BEFUNDE.md#e-43) stehen
deshalb nicht mehr in dieser Datei als Aufgabe.**

### 1. Gebaut und von Gregor an 1.0.84 bestätigt (13.10.2026) — vierzehn Befunde

> **Erledigt am 13.10.2026.** Alle vierzehn der Tabelle unten sind von Gregor an
> Paket 1.0.84 bestätigt (Testplan Teil A, Urteile mit Zitat in
> [BEFUNDE.md](BEFUNDE.md)). Der Text darunter ist der Stand davor.

**Nachgemessen am 13.09.2026** über alle Urteilszeilen in
[BEFUNDE.md](BEFUNDE.md): **vierzehn** behobene Befunde stehen dort als *von
Gregor nicht bestätigt*, alle aus 7.2.0.26 bis 7.2.0.30 und alle rund um
Registerkartenleiste und Trennbalken.

> **Zum Durchtesten gibt es [TESTPLAN.md](TESTPLAN.md)** — dieselben vierzehn
> als Hakenliste mit Handgriff und Sollzustand, dazu die Schalter für das
> Protokoll und die frischen Behebungen. **Für [E-49](BEFUNDE.md#e-49) bis [E-63](BEFUNDE.md#e-63) gibt es keine
> Spurmarken**; nachgezählt über alle `E-nn`-Protokolltexte im Quelltext. Das
> ist Augenprüfung, und sie braucht deshalb eine Anleitung.

| Befund | Was kaputt war | Fassung | merkst du das? |
|---|---|---|---|
| [**E-49**](BEFUNDE.md#e-49) (Anforderung **A-4**) | der **linke Bereich** ließ sich nicht breiter ziehen | 7.2.0.26 | ja |
| [**E-50**](BEFUNDE.md#e-50) | **drei Mängel an der Registerkartenleiste**, von Gregor an 1.0.25 gemeldet — siehe darunter | 7.2.0.26 | ja |
| [**E-52**](BEFUNDE.md#e-52) | nach dem Verbreitern war der **Trennbalken nicht mehr greifbar**, und die Karten standen **doppelt** | 7.2.0.27 | ja |
| [**E-53**](BEFUNDE.md#e-53) | beim **Schließen** eines Fensters blieb an der Stelle der Karte ein **Strich** stehen | 7.2.0.28 | ja |
| [**E-54**](BEFUNDE.md#e-54) | beim Ziehen **nach rechts** war der **Ziehrahmen unsichtbar** — man zog ins Blinde | 7.2.0.29 | ja |
| [**E-55**](BEFUNDE.md#e-55) | ein **acht Pixel hoher leerer Streifen** unter der Werkzeugleiste | 7.2.0.29 | ja |
| [**E-58**](BEFUNDE.md#e-58) | ein Klick in den **rechten Rand** des Kartenstreifens öffnete den **Browser**, ohne dass dort etwas zu sehen war | 7.2.0.29 | ja |
| [**E-63**](BEFUNDE.md#e-63) | die **letzte** Registerkarte zeigt keinen Kurzhinweis, alle anderen schon | 7.2.0.30 | ja |
| [**E-56**](BEFUNDE.md#e-56) | beim **Abschalten** von *Show MDI task bar* blieb der Kartenstreifen stehen | 7.2.0.29 | eher nicht |
| [**E-57**](BEFUNDE.md#e-57) | `QCWorkbook::IsTabLabelTruncated` legte bei **jeder Mausbewegung** eine `CPaintDC` an — außerhalb von `WM_PAINT` | 7.2.0.29 | nein |
| [**E-59**](BEFUNDE.md#e-59) | `m_cxTab` wurde **nur in `OnPaint`** gesetzt | 7.2.0.29 | nein |
| [**E-60**](BEFUNDE.md#e-60) | ein Trennbalken konnte **während des Ziehens gelöscht** werden — Benutzung nach dem Freigeben | 7.2.0.29 | nein, bis es kracht |
| [**E-61**](BEFUNDE.md#e-61) | `Splitter::Track` **verschluckte `WM_QUIT`** — Eudora wäre weitergelaufen, obwohl es enden sollte | 7.2.0.29 | nein, bis es hängt |
| [**E-62**](BEFUNDE.md#e-62) | **sieben eigene Nachrichtenschleifen** verschluckten `WM_QUIT`, zwei davon mit echter Hängegefahr | 7.2.0.29 | nein, bis es hängt |

**Die drei Mängel von [E-50](BEFUNDE.md#e-50)**, in Gregors eigenen Worten von damals — alle drei
mit **einer** Wurzel: der Streifen wird nur beim Neuzeichnen gemalt, und
niemand erklärt ihn für ungültig.

1. *„die karte bleibt eingedrückt, auch wenn man im anderen fenster ist"* —
   `QCWorkbook::OnLButtonDown` setzte `SetSelected(TRUE)` (`workbook.cpp:1109`),
   und **niemand** setzte es zurück; im Original tat das die Stingray-Ebene.
2. *„beim skalieren ist die darstellung falsch"* — `WM_SIZE` frischt jetzt auf.
3. *„die karten sind dann weg"* beim Öffnen und Schließen — `AddSheet` und
   `RemoveSheet` frischen jetzt auf.

**Nicht dazugezählt:** *„nach dem neustart sind die fenster nicht im
vollbildmodus, wie beim beenden"* — das ist der Fensterzustand, ein eigener
Weg über `SaveOpenWindows`, getrennt zu messen.

**Warum hier bis zum 12.10.2026 nur die Nummern standen.** Die Tabelle nannte
Kennung, Fassung und ein Stichwort — **nicht, was der Fehler war**. Wer sie
benutzen wollte, musste jede Nummer in `BEFUNDE.md` nachschlagen, und das sind
8500 Zeilen. Gregor am 12.10.2026: *„in den aufgaben sehe ich nicht mal, was
z.b. e-50 für ein fehler ist."* Die Beschreibungen stammen aus den
Urteilszeilen von `BEFUNDE.md`, Wort für Wort übernommen.

**[E-51](BEFUNDE.md#e-51) steht nicht in dieser Liste**, weil es behoben wurde, bevor es
ausgeliefert war. Prüfbar wäre es ohnehin nicht, nicht von Gregor und nicht von
mir: es geht darum, ob beim Ziehen etwas einfriert, und die Ziehschleife läuft
nur mit einer **physisch gedrückten Maustaste**
(`Arbeitsweise/keine-tastendruecke-verschicken.md`). Es bleibt beim
Nebenbei-Beobachten: friert etwas ein, ist es ein Befund.

> **Warum das hier so lange falsch stand.** Am 11.09.2026 wurde der Stand-Kopf
> dieser Datei von 09.09. auf 11.09. gesetzt, ohne den Inhalt gegen
> `BEFUNDE.md` zu halten — damit war sie nachher *falscher* als vorher: das
> alte Datum hatte wenigstens gewarnt. `tools/pruefe-stand-md.pl` prüft das
> Datum, nicht den Widerspruch dahinter. Gefunden hat es Gregor.
>
> **Am 13.09.2026 dasselbe noch einmal, andersherum.** Der Abschnitt erklärte
> danach [**E-49**](BEFUNDE.md#e-49), [**E-50**](BEFUNDE.md#e-50) und [**E-52**](BEFUNDE.md#e-52) für *bestätigt* — `BEFUNDE.md` führt
> alle drei ausdrücklich als *von Gregor noch nicht bestätigt*. Die Berichtigung
> vom 11.09. hat den Widerspruch nicht aufgelöst, sondern umgedreht.
> `tools/pruefe-befundurteile.pl` fängt genau diese Klasse — es prüft aber nur
> sieben Anwenderdokumente, und **`AUFGABEN.md` ist nicht darunter**, obwohl
> der Kommentar im Werkzeug selbst diese Datei als Anlass nennt (`:42`).

### 2. Die Meldung „Encountered an improper argument" beim Anzeigen

**Das ist der letzte bekannte Fehler, den ein Anwender merkt** — und der
einzige Grund, warum Kriterium 2 und Kriterium 4 nicht *erfüllt* heißen.

MFCs Text für `CInvalidArgException`, **dieselbe Fehlerklasse wie [E-34](BEFUNDE.md#e-34) und
[E-43](BEFUNDE.md#e-43)**, andere Aufrufstelle. **Neu zu messen, seit [E-43](BEFUNDE.md#e-43) an der Wurzel behoben
ist** — gut möglich, dass sie mit verschwunden ist. Erst messen, dann suchen.

**Vor jedem Suchen:** `ASSERT(0)` und `VERIFY(` sind im Release-Bau nichts
(`Arbeitsweise/assert-ist-im-release-nichts.md`). Das ist die häufigste
Ursachenklasse dieses Projekts — [E-40](BEFUNDE.md#e-40) (`ASSERT(FALSE)` im `default`-Zweig),
[E-37](BEFUNDE.md#e-37) (`ASSERT(nIndex != -1)`), [E-38](BEFUNDE.md#e-38) (`VERIFY` um `Add`).

### 3. Der Nebenbefund ohne Nummer: die Fenster stehen nicht im Vollbild

Gregor am 09.09.2026 an 1.0.25: *„nach dem neustart sind die fenster nicht im
vollbild modus, wie beim beenden"*. **Noch nicht angefasst, keine Kennung
vergeben** — Kennungen vergibt Gregor, nicht ein Agent
([AGENTEN.md](AGENTEN.md), Abschnitt 4).

Das gehört **nicht** zur Registerkartenleiste, sondern zum Fensterzustand:
`CMainFrame::SaveOpenWindows` schreibt ihn beim Beenden, gelesen wird er beim
Start. Sinnvoller erster Handgriff **ohne Bau**: nach einem normalen Beenden
in der `Eudora.ini` des Mailverzeichnisses nachsehen, ob der Maximiert-Zustand
dort steht. Steht er nicht drin, ist es die Schreibseite; steht er drin, die
Leseseite.

> **Zusammenhang mit [E-43](BEFUNDE.md#e-43), aber nicht dasselbe.** Bis 7.2.0.24 entstand
> überhaupt kein `[ToolBar…]`-Abschnitt in der `Eudora.ini`; seither entstehen
> **13**. Ob der Fensterzustand denselben Weg nimmt, ist **nicht** gemessen.

### 4. E-39 — der INI-Abschnitt der gelöschten Persönlichkeit entsteht wieder

**Offen, nicht am laufenden Programm bestätigt.** Wird die **aktuell benutzte**
Persönlichkeit gelöscht, kann ihr Abschnitt teilweise wieder entstehen:
`CPersonality::Remove` (`persona.cpp:565-566`) löscht ihn, leert aber den
INI-Zwischenspeicher nicht und stellt die aktuelle Persönlichkeit nicht um;
`SetCurrent` prüft nicht, ob der Name existiert (`:179-198`, Kommentar *„we're
trusting souls"*). `FlushINIFile` schreibt `SavePassword` und
`SavePasswordText` ausdrücklich in `g_Personalities.GetCurrent()`
(`rs.cpp:1237-1250`) — der nächste `SetCurrent` legt damit zwei Schlüssel im
gelöschten Abschnitt wieder an.

**Unabhängig von [E-43](BEFUNDE.md#e-43)**, das den Zeitpunkt nur nach vorn verschiebt.
Naheliegend: nach erfolgreichem `Remove` auf `<Dominant>` umschalten, wenn die
gelöschte die aktuelle war.

### 5. E-47 — der Fehlerdialog des Verzeichnisdienstes

**Offen, Ursache belegt, keine Behebung in Sicht.** Beim Öffnen der
Kurznamen-/Verzeichnisdienst-Leiste kommt *„Directory Services unavailable
during this session due to unsuccessful initialization"*. Von Gregor am
08.09.2026 an 1.0.23 gesehen.

Der Text steht in `DirectoryServices/DirectoryServicesUI/inc/DSRightViewImpl.h`,
angezeigt in `DSRightViewImpl.cpp` aus `DSRightView::OnActivateWazoo` — **nur**
wenn `RegisterCOMObjects()` fehlschlägt. Es schlägt fehl, weil `DirServ.dll`,
`ISock.dll`, `Ph.dll`, `Ldap.dll` und `EudoraBk.dll` **`MFC71.DLL` und
`MSVCP71.dll`** brauchen, und die hat Microsoft nie als Redistributable
veröffentlicht. Betrifft die Verzeichnisdienste (LDAP, Ph, `EudoraBk`) und S/MIME — **nicht** den Start und **nicht** das eigene Adressbuch, das in `Eudora.exe` übersetzt ist.

`tools/paket-pruefen.ps1` führt beide DLLs seit dem 31.08.2026 als hingenommene
Lücke; **dass dabei ein Fehlerdialog erscheint, stand dort nicht.**
**Widerlegt:** der erste Verdacht, A-2 habe die Leiste aufgemacht — gemessen
mit `tools/leisten-messen.ps1` war Leiste 319 **rechts und unsichtbar**.

### Was schon nachgemessen ist — nicht wiederholen

**Kriterium 8 ist geschlossen (A-3 / [E-48](BEFUNDE.md#e-48)).** Die Registerkartenleiste war
nicht abwesend, sondern **abgeschaltet**: Eudoras Code liegt vollständig im
Quellbaum (`workbook.cpp`), der Einschalter steht in `mainfrm.cpp`, die
INI-Vorgabe `ShowMDITaskbar\n1` in `EudoraRes.rc`. Vier Anschlüsse fehlten in
der Ersatzschicht — `SetWorkbookMode` war eine Attrappe, `GetTabPts` lieferte
sechs Nullpunkte, der Rückgabewert von `recalcTabWidth()` wurde weggeworfen,
und `OnDrawTabIconAndLabel` rief niemand. **Nicht wieder von vorn suchen.**

**A-4 / [E-49](BEFUNDE.md#e-49): drei Anläufe, zwei am laufenden Programm widerlegt.**
`SetBorders` verkleinert den Innenbereich statt die Leiste zu vergrößern
(Andockleiste Client **176** bei Leiste **180**); eine Bedingung über
`m_arrBars` hatte **gar keine Wirkung**; ein Messversuch mit Zuschlag **11**
ergab **187**, also 7 Pixel frei — daraus folgt, dass der Weg über
`CalcFixedLayout` stimmt und **MFC 4 Pixel des Zuschlags selbst verbraucht**.
Endstand **188**, 8 Pixel frei. **Diese drei nicht noch einmal durchprobieren.**

**Das Beenden ist entschieden** (Kriterium 7, von Gregor bestätigt): [**E-40**](BEFUNDE.md#e-40)
(eine Rückfrage, die sich nicht öffnen lässt, galt als „Abbrechen" —
`SaveModified` in `doc.cpp` und `msgdoc.cpp` hatten im `default`-Zweig nur
`ASSERT(FALSE)`), [**E-41**](BEFUNDE.md#e-41) (Alt-F4 und das Kreuz laufen durch das
`ENSURE_VALID` in `CFrameWnd::OnSysCommand`, das *File → Exit* nicht hat —
gefunden von PRUEFER, indem er meine Beweisführung verwarf), [**E-42**](BEFUNDE.md#e-42) (zwölf
Aufräumschritte konnten den Ablauf abbrechen; neues Makro `AUFRAEUMEN` in
`mainfrm.cpp`) und [**E-45**](BEFUNDE.md#e-45) (einer dieser zwölf, `QCWorkbook::OnClose`, darf
**nicht** übersprungen werden — sonst bleibt ein Prozess ohne Fenster übrig).
Der vermessene Weg steht in [Befunde/BEENDEN.md](../Befunde/BEENDEN.md), das
Review in [Befunde/PRUEFER-5.md](../Befunde/PRUEFER-5.md).
`tools/pruefe-beenden.pl` hält den Zustand und meldet ihn in Zahlen — **elf
eingefasste Aufräumschritte**. Der zwölfte, `QCWorkbook::OnClose`, darf
ausdrücklich **nicht** durch `AUFRAEUMEN` laufen, und genau das prüft das
Werkzeug umgekehrt mit.

**[E-43](BEFUNDE.md#e-43) ist behoben, und mit ihm drei weitere Befunde.** `SECControlBar` war
**zweimal definiert** — `OT501/Include/sbarcore.h` (Original) und
`OTShim/OTShim.h` (Ersatz), und der Ersatz hat ein Feld mehr. Zwei
Übersetzungseinheiten lasen dasselbe Feld acht Byte auseinander. Gemessen
vorher `GetBtnCount=24/24 m_btns.GetSize=0/0`, nachher
`GetBtnCount=24/24 m_btns.GetSize=24/24`; die `Eudora.ini` enthält seither
**13** `[ToolBar…]`-Abschnitte statt **0**. Die Schranke dazu ist
`tools/pruefe-waechter.pl`. **Damit fielen die Fehlerklasse hinter [E-34](BEFUNDE.md#e-34), [E-37](BEFUNDE.md#e-37)
und [E-38](BEFUNDE.md#e-38) weg** — die zwei Behebungsanläufe an der Kontoliste (`FindItem`, dann
`GetItemText`) lagen hinter dem Wurf und konnten nie wirken.

**Die Wurzel der Abstürze ist gefunden und behoben: [E-31](BEFUNDE.md#e-31).** Strg-N und
*Weiterleiten* beendeten Eudora mit `0xC00000FD` STATUS_STACK_OVERFLOW in
`Paige32.dll` (`pgInstallFont`, 525 Windungen tief). Ursache war `pg_time_t` in
`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`: acht Byte breit unter VS2022, vier in
der DLL von 2005 — damit war jede Paige-Struktur verschoben. Darauf folgten
drei Fehler derselben Art, alle behoben und gemessen: [**E-34**](BEFUNDE.md#e-34) (eine
MFC-Ausnahme in `QCChildToolBar::GetButton` wickelte den ganzen Fensterbau ab,
ohne Meldung und ohne Absturz), [**E-35**](BEFUNDE.md#e-35) und [**E-36**](BEFUNDE.md#e-36) (blinde Zeigerzugriffe an
den Aufrufstellen, die [E-34](BEFUNDE.md#e-34) erst sichtbar machte).

**Widerlegt und nicht wieder aufzugreifen:**

- [**E-46**](BEFUNDE.md#e-46) — der Verdacht, `CMainFrame::OnClose` arbeite nach
  `QCWorkbook::OnClose` auf einem **freigegebenen** Objekt weiter. Die
  Spurmarke `E-46 CMainFrame::~CMainFrame betreten` erscheint erst **nach**
  der Stelle. Die Marke bleibt drin, weil sie die Reihenfolge belegt.
- [**E-32**](BEFUNDE.md#e-32) — meine Ursachenbehauptung zur modalen Meldung.
  `CHeaderView::OnKillFocusRecipient` war es nicht; PRUEFER hat es dreifach
  gemessen. Steht im [CHANGELOG.md](../CHANGELOG.md) unter 7.2.0.20.
- **Ein ODR-Bruch durch zwei `SECCustomToolBar`-Definitionen** — `stdafx.h`
  zieht `OTShimAll.h` zuerst und setzt `__TBARCUST_H__`; stünde `tbarcust.h`
  je zuerst, bräche der Bau mit dem `#error` in `OTShim_Werkzeugleiste.h` ab.
  Der echte ODR-Bruch lag bei `SECControlBar` ([E-43](BEFUNDE.md#e-43)), nicht hier.
- **Sieben weitere Vermutungen**, jede gebaut und gemessen — die Liste mit
  Messwerten steht im [CHANGELOG.md](../CHANGELOG.md) unter 7.2.0.21.
- **Beim Beenden:** `CFileBrowseView::OnAppExit` (ausgeschlossen — alle drei
  Wege gehen durch `CMainFrame::OnClose`) und die Vermutung, eine modale
  Meldung der Ersatzschicht verdecke das Beenden (die modalen `AfxMessageBox`
  in `OTShim` sind durch `OutputDebugString` ersetzt,
  `tools/pruefe-fensterbau.pl` hält das).

Alles Übrige in dieser Datei ist **nebenbei**, nicht statt dessen.

## Erledigt seit 1.0.10

**Von Gregor bestätigt:** **Kriterium 0** (Paket startet ohne Visual Studio),
**Kriterium 5** und **6** (Mail schreiben, abschicken, weiterleiten),
**Kriterium 7** (sauberes Beenden — [**E-40**](BEFUNDE.md#e-40), [**E-41**](BEFUNDE.md#e-41), [**E-42**](BEFUNDE.md#e-42), ergänzt um
[**E-45**](BEFUNDE.md#e-45)), **Kriterium 8** (offene Fenster als Registerkarten — **A-3** /
[**E-48**](BEFUNDE.md#e-48)), **Anforderung [A-1](BEFUNDE.md#a-1)** (Vorgaben für ein neu angelegtes Konto),
**Anforderung A-2** / [**E-44**](BEFUNDE.md#e-44) (*Task Status* und *Task Errors* waagrecht
unten), [**E-43**](BEFUNDE.md#e-43) samt [**E-37**](BEFUNDE.md#e-37) und [**E-38**](BEFUNDE.md#e-38) (Persönlichkeit löschen, ohne
Meldung), [**E-30**](BEFUNDE.md#e-30) (Symbole gesperrter Knöpfe) und [**E-28**](BEFUNDE.md#e-28) (Doppelklick und
Suchtreffer öffnen die Nachricht). Dazu die **Höhenänderung** des unteren
Bereichs (*„verschieben rauf / runter — bug gefixt"*).

Dazu [**E-26**](BEFUNDE.md#e-26) (Ladeadressen im Absturzbericht), [**E-29**](BEFUNDE.md#e-29)
(`tools/absturz-auswerten.pl`) und die entfernte `dbghelp.dll` von 2005.
**[E-31](BEFUNDE.md#e-31) ist von Gregor mittelbar bestätigt** — ohne Paige-Fenster gibt es
kein Verfassen-Fenster, und er hat am 07.09.2026 mit 7.2.0.21 eine Mail
geschrieben und abgeschickt. Zu [**E-32**](BEFUNDE.md#e-32) und [**E-46**](BEFUNDE.md#e-46) siehe oben: beide
widerlegt. Einzelheiten in [CHANGELOG.md](../CHANGELOG.md).

## Was sonst noch offen ist

| Punkt | wo | braucht |
|---|---|---|
| [**E-101**](BEFUNDE.md#e-101) — gespeicherte HTML-Datei sagt UTF-8, enthält Windows-1252 (**wieder offen** seit 13.10.2026) | `BEFUNDE.md` | Bau, dann Gregors Gegenprobe |
| [**E-114**](BEFUNDE.md#e-114) — ein gelöstes angedocktes Fenster hinterlässt einen leeren Bereich (neu, 13.10.2026) | `BEFUNDE.md` | Messen, dann Bau |
| [**E-116**](BEFUNDE.md#e-116) — `width="35px"` wird als 3508 gelesen (neu, 13.10.2026, PRÜFER-22 F3; am Quelltext belegt, sichtbar erst ab 7.2.0.85) | `BEFUNDE.md` | Test zuerst, dann Bau (Vorschlag des PRÜFERS vor `PGHTMIMP.CPP:3694`) |
| [**E-118**](BEFUNDE.md#e-118) — HTML-Mail, in ein IMAP-Postfach verschoben, erscheint als Quelltext (neu, 13.10.2026, an 1.0.86; am Quelltext belegt) | `BEFUNDE.md` | Test zuerst, dann Bau (`ImapAppend.cpp:692`/`:1980` einteilig ohne `Content-Type`, `:1166` mehrteilig fest `text/plain`; Vorlage `SendContentType`, [PRÜFER-25](../Befunde/PRUEFER-25.md) H1) — **Stand 14.10.2026:** eingebaut in 7.2.0.89, von Gregor an 1.0.89 bestätigt; Teil 2 (eingebettete Bilder) eingebaut in 7.2.0.90, von Gregor am 14.10.2026 an 1.0.90 bestätigt (Nachtrag 15.10.2026, [L-36.3](../Befunde/LEKTOR-36.md#l-36.3)) |
| [**E-119**](BEFUNDE.md#e-119) — `data:`-Bilder beim Antworten und Weiterleiten als grauer Kasten (neu, 13.10.2026, an 1.0.86; am Protokoll belegt) | `BEFUNDE.md` | Messen, ob 1.0.84 dasselbe zeigt; dann Bau im HTML-Import vor `PGHTMIMP.CPP:3317` (der Ladeweg ist zu spät, Attribute werden auf 1023 Zeichen gekürzt — [PRÜFER-25](../Befunde/PRUEFER-25.md) H2) |
| [**E-105**](BEFUNDE.md#e-105) — `display:none` wird nicht ausgewertet: Vorschautext und, zweiter Fall an 1.0.86, doppelte Bilder | `BEFUNDE.md` | ~~Entscheidung, ob Paige `display:none` lernen soll~~ — eingebaut in 7.2.0.88 (Zweig `e-105_doppelte_bilder`, gemergt mit PR #97; nur inline `style`, nicht über Klassen aus `<style>`), an der Prüfnachricht und an Gregors freenet-Newsletter gemessen; offen bis zu seinem Test an 1.0.89 (1.0.88 wurde nicht ausgeliefert, siehe [TESTPLAN.md](TESTPLAN.md#c5)) |
| Meldung **„Encountered an improper argument"** beim **Anzeigen** mancher Nachrichten | oben, 2. | Start, dann Bau |
| **Die Fenster stehen nach dem Neustart nicht im Vollbild** — Nebenbefund ohne Kennung | oben, 3. | Start, `Eudora.ini` lesen |
| [**E-39**](BEFUNDE.md#e-39) — der INI-Abschnitt der gelöschten Persönlichkeit entsteht wieder | oben, 4. | Bau + Start |
| [**E-47**](BEFUNDE.md#e-47) — Fehlerdialog des Verzeichnisdienstes, `MFC71.DLL` und `MSVCP71.dll` fehlen | oben, 5. | keine Behebung in Sicht |
| [**E-14**](BEFUNDE.md#e-14) — Zusicherung beim Start, der X1-Suchindex wird neu angelegt | `BEFUNDE.md` | echter Befund erst, wenn die Meldung auch beim **zweiten** Start kommt |
| [**E-13**](BEFUNDE.md#e-13) — kein Fortschritt beim Mailabruf; die Behebung liegt auf `wt/fortschritt-arbeit`, nicht in diesem Zweig | `BEFUNDE.md` | Merge-Entscheidung |
| **`ReleaseBuffer` ohne `GetBuffer`** — Fehlerklasse [R-1](BEFUNDE.md#r-1), **16** Stellen bleiben (gemessen 07.09.2026) | [A2](#a2), [R-1](BEFUNDE.md#r-1) | Bau |
| **Neun Zeigerstellen** aus [X-3](BEFUNDE.md#x-3) | D3a | Bau |
| **`EuMemMgr.dll` ist kein Projekt der Projektmappe** — vorgebaut, 2005, Version 7.0.0.9. Ausgerechnet sie löst den Aufrufstapel im Absturzbericht auf | — | — |
| **Hostnamenprüfung greift nicht** (sicherheitsrelevant) | `PORTIERUNG.md` | **zurückgestellt**, siehe unten |

---

## A — Die Fehlerklasse `ReleaseBuffer` ohne `GetBuffer`

### <a id="a2"></a>A2 · 21 Stellen sind zu ändern — ausgezählt

`ReleaseBuffer` ohne vorangehendes `GetBuffer` ist bei MFC 14 unzulässig:
`CStringT` zählt Referenzen. Eine VC6-Altlast, die sich erst zur Laufzeit meldet,
und zwar nur auf bestimmten Wegen. Das ist eine **Fehlerklasse**, kein Einzelfall.

Gemessen am 07.09.2026 mit `perl tools/releasebuffer-pruefen.pl` (Rückgabe 1,
sobald etwas zu tun ist; `--alle` zeigt auch die richtigen):

| Einstufung | Bedeutung | Anzahl |
|---|---|---|
| `ok` | richtiges Paar `GetBuffer`/`ReleaseBuffer` — **bleibt** | 116 |
| `falsch` | kein `GetBuffer`, Länge übergeben (kürzt) | **16** |
| `lockbuffer` | davor `LockBuffer` — der Partner ist `UnlockBuffer()` | **4** |
| `danach` | `GetBuffer` erst danach (`MimeStorage.cpp:270`) | **1** |

**Zu tun, in dieser Reihenfolge — nach Häufigkeit des Wegs, nicht nach Datei:**

1. `QCSharewareManager.cpp:1318` (`RetailVersion`) — **bei jedem Start**.
2. `sendmail.cpp:1782`, `:1788`, `:1815`, `:1865` (`szLine`) — **bei jeder
   gesendeten Klartextmail**. `CString szLine(pSrcLine, …)` bei `:1736`, dann
   `SetAt`, dann `ReleaseBuffer`.
3. `eudora.cpp:3466` (`RegClientsMail`) und `:3476` (`EudoraOption`) — beide in
   `CEudoraApp::RegisterURLSchemes()`, dem Weg jeder **frischen** Installation.
4. `mime.cpp:2020` (`m_CID`) — jede Nachricht mit `Content-ID` in `<…>`.
5. Die übrigen acht: `msgutils.cpp:2128/2165/2185/2265`, `SMTPSession.cpp:328`,
   `Imapdll/src/Network.cpp:179`, `guiutils.cpp:1605`, `MAPI/recip.cpp:52`.
6. Die vier `LockBuffer`-Stellen (`Text2Html.cpp:912/939/955`,
   `PGHTMIMP.CPP:2944`) — dort ist der Ersatz **nicht** `Truncate`, sondern
   entweder `UnlockBuffer()` oder der Verzicht auf den Puffer.
7. `MimeStorage.cpp:270` — `Message.Empty()` statt `ReleaseBuffer(0)`.

**Ersatz beim Kürzen: `s.Truncate(n)`** oder `s = s.Left(n)`.

Erledigt und darum nicht mehr in der Messung: `eudora.cpp:3372` ([E-11](BEFUNDE.md#e-11)),
`fileutil.cpp:482` ([E-12](BEFUNDE.md#e-12)), `QCMailboxDirector.cpp:1316` ([E-24](BEFUNDE.md#e-24)) — alle seit
31.08.2026 — sowie die drei Hesiod- und Drucktitel-Stellen
`POPSession.cpp:1747` und `SMTPSession.cpp:683` (beide `LoginName`, [R-1](BEFUNDE.md#r-1)) und
`PaigeEdtView.cpp:657` (`strTitle`, [E-27](BEFUNDE.md#e-27)); dort steht heute `Left(n)` mit einem
Befundkommentar daneben. `ConConProfile.cpp:198` stand früher in dieser Liste
und gehört nicht hinein — dort steht ein `GetBuffer` auf derselben Variablen
davor.

**Zeilenangaben veralten.** Vor dem Ändern die Liste neu erzeugen, nicht diese
abschreiben.

---

## B — Was Gregor sieht

### <a id="b1"></a>B1 · Die Bedienfehler, die Gregor merkt

**Neun sind behoben und von Gregor bestätigt** (Stand 11.09.2026, seither sind [**E-79**](BEFUNDE.md#e-79), [**E-80**](BEFUNDE.md#e-80) und [**E-81**](BEFUNDE.md#e-81) dazugekommen und ebenfalls bestätigt): Doppelklick
und Suchtreffer öffnen die Nachricht ([**E-28**](BEFUNDE.md#e-28)), gesperrte Knöpfe zeigen ihr
Symbol ([**E-30**](BEFUNDE.md#e-30)), eine Mail lässt sich schreiben und abschicken (Kriterium 5)
und weiterleiten (Kriterium 6), Eudora **beendet sich** über alle drei Wege
(Kriterium 7), die Vorgaben für ein neu angelegtes Konto greifen ([**A-1**](BEFUNDE.md#a-1)),
*Task Status* und *Task Errors* liegen waagrecht unten (**A-2**/[**E-44**](BEFUNDE.md#e-44)), eine
**Persönlichkeit lässt sich löschen** — ohne Meldung, und der Eintrag
verschwindet sofort ([**E-43**](BEFUNDE.md#e-43), mit ihm [**E-37**](BEFUNDE.md#e-37) und [**E-38**](BEFUNDE.md#e-38)) —, die offenen
Fenster stehen als **Registerkarten** unten und ein Klick holt sie nach vorn
(**A-3**/[**E-48**](BEFUNDE.md#e-48), Kriterium 8), und die **Höhe** des unteren Bereichs lässt
sich verschieben.

Was bleibt: die **vier gebauten, nicht beurteilten** Behebungen ([**E-49**](BEFUNDE.md#e-49),
[**E-50**](BEFUNDE.md#e-50), [**E-51**](BEFUNDE.md#e-51), [**E-52**](BEFUNDE.md#e-52) — oben unter *Die Hauptarbeit*, 1.), die Meldung
„Encountered an improper argument" beim **Anzeigen** mancher Nachrichten, der
**Nebenbefund ohne Kennung** (Fenster nicht im Vollbild nach dem Neustart) und
der Fehlerdialog des Verzeichnisdienstes ([**E-47**](BEFUNDE.md#e-47)). Das ist der erste Schritt,
nicht ein Punkt unter vielen.

### <a id="b2"></a>B2 · Gesperrte Werkzeugleisten-Knöpfe — **erledigt**

**[E-30](BEFUNDE.md#e-30) ist behoben und von Gregor bestätigt** (Paket 1.0.14). Ursache waren die
sechs **24-Bit**-Bitmaps der Hauptleiste: ohne Farbtabelle konnte
`CreateMappedBitmap` das Buttongrau `192,192,192` nicht auf das heutige
`COLOR_BTNFACE` (`240,240,240`) umsetzen, und die Maske erfasste das ganze
Bildrechteck. Behoben in `OTShim/OTShim_Werkzeugleiste.cpp`, abgesichert durch
`tools/pruefe-symbole.pl` und `Eudora71/Tests/TestSymbole.cpp`.

### <a id="b3"></a>B3 · Die Umlaut-Gegenprobe ohne Start

Nach einem **neuen** Abruf (schon geholte Nachrichten bleiben kaputt, die rohen
Bytes stehen im Postfach):

```sh
perl tools/postfach-zeichen-pruefen.pl <Mailverzeichnis>\In.mbx
```

Es darf keine vollständige UTF-8-Folge mehr melden ([Z-2b](BEFUNDE.md#z-2b)).

### <a id="b5"></a>B5 · Anhänge: Dateiname abgeschnitten, Endung weg (**AN-1**) — **über POP heil seit 7.2.0.81, über IMAP von Gregor mit 1.0.83 getestet; B5.7 offen** (7.2.0.79: 4 von 6, 7.2.0.80-an1: 5 von 6, 7.2.0.81 bis 7.2.0.83: alle sechs)

> **Am laufenden Programm gemessen, 12.10.2026** (7.2.0.79, Rebuild 0 Fehler,
> `C:\Temp\AN1`, Prüfnachrichten über `--pop`): **00, 01, 02, 04 heil** —
> B5.1, B5.2 und B5.5 wirken. **03** kam als 224 × `A` **ohne `.pdf`**: die
> Kopfzeile hatte alle 304 Zeichen, dann kappten `strncpy` (259) und
> `DeMacifyName32` (255) **von hinten** — das ist **B5.8**, behoben in 7.2.0.80-an1
> mit `AnhangNameKuerzen`. **05** (`filename=""`) bekam den Betreff **ohne
> Endung**, weil `MIMEMap::Find` bei **allen sechs** scheiterte, sogar für
> `application/pdf` — **B5.9, gemessen an 7.2.0.80-an1:** `GetMaps` verwarf die
> ganze Tabelle am Registry-Typ `pkcs10` (ohne `/`); behoben in 7.2.0.81, dazu
> **B5.10**, der Vorzeichenfehler in `SetExtension` (vom PRUEFER gefunden).
> **7.2.0.81, 7.2.0.82 und 7.2.0.83: alle sechs heil** (`C:\Temp\AN3`, `AN4`,
> `AN5`; Testsuite 185/185 an 7.2.0.82 und 7.2.0.83). **B5.11** kam mit 7.2.0.83
> dazu (Pufferschutz in `SetExtension`, keine Endung wird mehr ersetzt).
> **Über IMAP** hat Gregor Paket 1.0.83 an seinem Postfach getestet: drei
> Anhänge, alle mit Endung; sein Urteil *„gekürzt mit endung reicht"*.
> Einzelheiten in [CHANGELOG.md](../CHANGELOG.md), Abschnitte Messfassung
> 7.2.0.80-an1, 7.2.0.81 und 7.2.0.83.

Gregors Meldung vom 30.09.2026. Untersucht, gemessen, aufgeschrieben — und am
12.10.2026 **in den Quelltext eingespielt**. Die beiden Patchdateien, die hier
seit dem 30.09. nur danebenlagen, sind damit Geschichte und entfernt.

> ~~**Es ist nichts mit MSVC gebaut.**~~ *Erledigt am 12.10.2026: gebaut und
> gemessen sind seither 7.2.0.79, 7.2.0.80-an1, 7.2.0.81, 7.2.0.82 und 7.2.0.83,
> jeweils Rebuild mit 0 Fehlern (`tools/TESTLAEUFE.md`).* Bis dahin liefen alle
> drei Sitzungen dazu ohne Windows und ohne Compiler.

**Es liegt nicht an der Länge.** Ein Name mit 76 Zeichen kommt vollständig an,
solange er in *einer* Zeile steht. Elf getrennte Ursachen (B5.1 bis B5.11)
erzeugen dasselbe Bild, alle sind Originalfehler aus Eudora 7.1.

> **Berichtigt am 12.10.2026, aus Gregors `eudora.log` zu 7.2.0.77.** Hier stand
> bis dahin, alle Ursachen steckten **doppelt** im Baum — POP in
> `lex822.*`/`header.cpp`, IMAP in `EuImap/src/ImapLex822.*`/`ImapHeader.cpp` —
> und wer nur einen Zweig ändere, baue sich einen Fehler, der von der Kontenart
> abhängt. **Für den Anhangnamen stimmt das nicht.** Über IMAP kommt er aus der
> **BODYSTRUCTURE**-Antwort des Servers: `GetFilenameParameter`
> (`ImapDownload.cpp`) liest ihn aus den c-client-Strukturen `BODY`/`PARAMETER`,
> nicht aus `Lex822`. Eine Faltung hat der Server da längst aufgelöst,
> **B5.1 kann über IMAP also gar nicht zuschlagen**.
>
> `ImapLex822`/`ImapHeader` zerlegen den Kopf sehr wohl — aber für die
> Mailbox-Datei. Die IMAP-Hälfte von B5.1 bis B5.3 gehört dorthin und bleibt
> nötig; sie betrifft nur nicht den Dateinamen. Umgekehrt hat der IMAP-Weg
> **eigene** Fehler, die der POP-Weg nicht hat: B5.6 und [B5.7](#b5.7).

#### Stand der elf Teile

| Schritt | Was | Stand |
|---|---|---|
| **[B5.0](#b5.0)** | **Debug-Marken**, elf Stellen auf dem Weg des Namens, Bitmaske `DEBUG_MASK_ATTACH` | **im Quelltext.** POP-Marken 1–8 und IMAP 1–3 sind am laufenden Programm gemessen (12.10.2026, 7.2.0.77, 285 `ANHANG`-Zeilen); POP-Marken 10 und 11 am 12.10.2026 an 7.2.0.80-an1 und 7.2.0.81 gemessen; IMAP 4–9 übersetzt, aber **nicht gemessen** (kein IMAP-Abruf) |
| **B5.1** | **Faltung überleben.** Eine Faltung (`CRLF` + Leerzeichen/Tabulator) beendete die Zeichenkette in Anführungszeichen — die Faltungsregel prüft das LF, im Strom kommt aber das CR zuerst | **behoben**, geändert in POP und IMAP; für den Dateinamen wirkt es nur über POP (siehe unten). Gemessen mit `tools/kopfzeile-pruefen.pl --vorschlag` und am laufenden Programm (Fall 01, 02 heil seit 7.2.0.79) |
| **B5.2** | **Marke beim Neuanfang leeren** — `Token[0] = 0;`. Sonst wurde `filename=""` zum Wert `=`, weil die leere Marke das erste Byte der **vorigen** trug | **behoben**, POP und IMAP |
| **B5.3** | **Marke vergrößern.** `BYTE Token[256]` kappte ab 254 Zeichen; ein Dateiname nach `_MAX_PATH` (260) passte nicht hinein | **behoben**: `LEX822_TOKEN_MAX` = 1024 in `lex822.h`, benutzt von beiden Zerlegern **und** von `szWert` in beiden `AddAttribute` — die Zahl steht nur noch an einer Stelle. Die Kopfzeile kommt seit 7.2.0.79 ganz an (304 Zeichen gemessen); **im Dateinamen wirksam erst mit B5.8** |
| **B5.4** | **`DeMacifyName32`** schrieb bei 255 übernommenen Zeichen ein Byte hinter `pcname[255]` | **behoben**, beide Abschriften. **Dabei neu gefunden:** `DeMacifyName` (die 8+3-Fassung) schrieb bis zu **drei** Byte über — `pcname[15]`, und 8 + Punkt + 8 + Null sind 18. Der zweite Zähler stand auf 8 statt 3 |
| **B5.5** | **RFC 2231** (`filename*0*=UTF-8''…`) kannte der Baum nicht. Dann gab es **gar kein** `filename`, und `mime.cpp` nahm den **Betreff** — `subj[32]`, also 31 Zeichen ohne Endung | **behoben**: neu `QCUtils/src/rfc2231.cpp`, benutzt von POP (`HeaderDesc::GetAttribute`) **und** IMAP (`GetFilenameParameter`). **20 von 20 Prüffällen grün**, gemessen mit `tools/rfc2231-pruefen.pl` |
| **B5.6** | **`LOCAL_CheckName`: `char tmp[255]`.** `tmp[len] = 0;` mit `len` bis 255 schrieb auf den Stapel — bei jedem Anhangnamen ab 255 Zeichen **ohne Punkt**, und der Name kommt vom Server | **behoben** (`_MAX_PATH + 1`), nur IMAP. Das POP-Gegenstück ist auf `CString` umgebaut und hatte es nicht |
| **[B5.7](#b5.7)** | **Über IMAP gibt es kein `MIMEMap::SetExtension`.** Der POP-Weg trägt eine fehlende Endung aus dem MIME-Typ nach; der IMAP-Weg ruft `MIMEMap` nur, um über das Löschen zu entscheiden | **offen.** Siehe unten — es ist eine Binde-, keine Logikfrage. In Gregors IMAP-Test mit 1.0.83 fiel es nicht auf: alle drei Namen trugen schon eine Endung |
| **B5.8** | **Kappung von hinten.** `strncpy(fName, …, _MAX_PATH - 1)` in `mime.cpp` (259, ohne abschließende Null) und `DeMacifyName32` (255, beide Abschriften) schnitten das Ende ab — mit der Endung | **behoben in 7.2.0.80-an1** mit `AnhangNameKuerzen` (`QCUtils/src/rfc2231.cpp`), das die Endung behält. Am laufenden Programm gemessen: Fall 03 kommt als `<220×A>.pdf` (224) |
| **B5.9** | **`MIMEMap::GetMaps` verwarf die ganze Tabelle**, sobald ein Registry-Typ unter `HKCR\Mime\Database\Content Type` keinen Schrägstrich hat (`pkcs10`). Damit trug `SetExtension` **nie** eine Endung nach, auch in echter Post | **behoben in 7.2.0.81**: solch ein Schlüssel wird übersprungen. Am laufenden Programm gemessen: Fall 05 bekommt `.pdf`, sechsmal „nach MIMEMap::SetExtension“, keinmal „kennt den Typ NICHT“ |
| **B5.10** | **Vorzeichenfehler in `SetExtension`** (PRUEFER-19): beim Kürzen war `Difference` negativ, `while (Difference--)` lief rückwärts durch den Speicher. Erst durch B5.9 erreichbar | **behoben in 7.2.0.81**. Mit den Prüfdaten nicht auslösbar, aus dem Quelltext begründet |
| **B5.11** | **`SetExtension` kürzte auf `_MAX_PATH`, auch in kleineren Puffern** (`uudecode.cpp` `m_Name[255]`, `hexbin.cpp`/`ImHexbin.cpp` `m_Name[40]`, PRUEFER-20), und **ersetzte** vierstellige Endungen (`.docx` → `.doc`) | **behoben in 7.2.0.83**: Puffergröße vom Aufrufer, eine vorhandene Endung bleibt. Außerhalb von Eudora mit `cl` an zehn Fällen gemessen; am laufenden Programm alle sechs Prüffälle heil (`C:\Temp\AN5`). Offen aus PRUEFER-20: `hexbin.cpp:276`/`ImHexbin.cpp:333` schreiben den BinHex-Namen ohne Grenze |

**Wer B5.2 oder B5.3 nur in einem der beiden Zweige ändert, baut sich einen
Fehler, der von der Kontenart abhängt.** Für den Anhangnamen gilt das nicht,
siehe die Berichtigung oben: B5.1 wirkt nur auf dem POP-Weg, B5.6 und [B5.7](#b5.7) nur
auf dem IMAP-Weg.

#### <a id="b5.7"></a>B5.7 — warum es offen bleibt

`MIMEMap` braucht dafür eine Fassung von `Find`, die Typ und Untertyp direkt
nimmt statt eines `MIMEState`, den es über IMAP nicht gibt. Die Suche selbst
wäre ein Dreizeiler — herausgezogen aus `Find(MIMEState*)`, damit keine zweite
Abschrift entsteht.

**Woran es hängt:** `MIMEMap.cpp` wird nur im Eudora-Projekt übersetzt, und
`EuImap` ruft die Methoden trotzdem auf (`ImHexbin.cpp`, `ImSingle.cpp`,
`ImapDownload.cpp`). Wie diese Bindung zustande kommt, ist aus den Projektdateien
nicht zu sehen — `EXPORT` ist im Eudora-Zweig als **leer** definiert
(`MAPI/include/MAPI.h:35`), eine `.def` mit Klassennamen gibt es nicht, und
`EuImap.vcxproj` nennt als Verweis nur `Imapdll`. Eine **neue** Methode könnte
deshalb beim Binden fehlen — und das sähe genau aus wie die drei
Übersetzungsfehler, die am 12.10.2026 ungeklärt blieben. *(Nachtrag 12.10.2026:
die folgenden fünf Rebuilds, 7.2.0.79 bis 7.2.0.83, liefen mit 0 Fehlern; was
die drei Fehler waren, ist nirgends aufgeschrieben und nicht nachgemessen. Die
Bindefrage für eine neue `MIMEMap`-Methode ist damit weiter offen.)*

Das klärt ein Blick auf den Linkerlauf an Gregors Rechner in einer Minute.
Vorher wird hier nicht geraten.

#### Was gemessen ist

```
perl tools/kopfzeile-pruefen.pl             # 10 Faelle, Zerleger aus lex822.cpp
perl tools/kopfzeile-pruefen.pl --lang      # dazu jede einzelne Marke
perl tools/rfc2231-pruefen.pl               # 20 Faelle, Zerleger aus rfc2231.cpp
```

Beide Werkzeuge holen den Quelltext bei **jedem** Lauf wörtlich aus dem Baum —
per Textanker, nicht per Zeilennummer — und übersetzen ihn mit `g++` (oder
`cl`). Gemessen wird der ausgelieferte Code, keine Abschrift. Fehlt ein Anker,
brechen sie ab, statt stumm durchzulaufen.

**Mit den Werkzeugen nicht messbar:** `RFC2231ZeichensatzUmsetzen` ruft
`MultiByteToWideChar` und ist mit `g++` nicht prüfbar. *Stand 12.10.2026: am
laufenden Programm ist der Weg seither gemessen — mit MSVC gebaut und gestartet
(7.2.0.79 bis 7.2.0.83, `tools/TESTLAEUFE.md`); Fall 04 (RFC 2231) kommt
heil an.* Bis dahin stand hier: „nichts davon ist mit MSVC gebaut, nichts ist
gestartet“.

#### Der nächste Schritt an einem Windows-Rechner

> *Stand 12.10.2026: Schritte 1 bis 4 sind erledigt, an 7.2.0.79 bis 7.2.0.83.
> **Offen ist Schritt 5** — in `TestPopEmpfang.cpp` steht noch kein Fall zu
> [AN-1](BEFUNDE.md#an-1) — und [B5.7](#b5.7).*

1. **Bauen**, mit `-Ziel Rebuild`: `QCUtils/public/inc/debug.h` und
   `rfc2231.h` sind öffentliche DLL-Header, und `QCUtils` hat mit
   `src/rfc2231.cpp` eine neue Übersetzungseinheit bekommen.
2. `LogLevel=91295` in die Gruppe **`[Debug]`** der `eudora.ini` — nicht nach
   `[Settings]`. `rs.cpp:89` ordnet jeden Schlüssel allein nach seiner Nummer zu.
3. `perl tools/anhang-pruefdaten.pl --pop`, Konto eintragen, abrufen.
4. `grep ANHANG eudora.log` und ins Anhangverzeichnis sehen.
5. Einen Testfall in `Eudora71/Tests/TestPopEmpfang.cpp` nachziehen — dort liegt
   das Gerüst für den Empfangspfad schon.

> **Die Spalte `stand` in `tools/kopfzeile-pruefen.pl` ist noch nicht
> nachgezogen.** Sie hält den **kaputten** Stand von vor der Behebung fest; mit
> dem behobenen Zerleger meldet das Werkzeug deshalb Abweichungen. Das ist
> gewollt, solange niemand bestätigt hat, dass die Behebung am laufenden
> Programm wirkt — wer die Spalte vorher nachzieht, löscht den Vergleichspunkt.
>
> *Stand 12.10.2026: die Bedingung ist erfüllt — B5.1 und B5.2 sind am
> laufenden Programm gemessen (Fall 01, 02, 05), und Gregor hat [AN-1](BEFUNDE.md#an-1) nach seinem
> Test mit 1.0.83 bestätigt. Die Spalte ist trotzdem noch nicht nachgezogen.*

#### <a id="b5.0"></a>B5.0 · Die Debug-Marken — beim Abrufen zusehen

Gregor: *„nicht vergessen, Debug-Marken einzufügen, wenn da was schief läuft,
dass man das auf die Schnelle rausfindet … damit man beim Mail abrufen oder beim
Benutzen sieht, was passiert und was nicht hinhaut."*

**Einschalten** (kein Neubau nötig, nur ein Neustart): in `eudora.ini` gehört
`LogLevel` in die Gruppe `[Debug]` — `LogLevel=91295`, das ist die
Voreinstellung 25759 **plus 65536** (`DEBUG_MASK_ATTACH = 0x10000`). Geschrieben
wird nach `eudora.log` im Eudora-Verzeichnis. Auslesen:

```
grep ANHANG eudora.log
```

Elf Marken auf dem Weg des Namens: wo der Zerleger abbricht, was `AddAttribute`
ablegt, ob ein Name erst nach RFC 2231 zusammengesetzt werden musste, woher er
kommt (`filename` / `name` / **Betreff**), ob `MIMEMap` die Endung nachträgt,
was `DeMacifyName32` daraus macht, und **wie die Datei am Ende wirklich heißt**.
Steuerzeichen werden sichtbar gemacht — eine Faltung erscheint im Log als
`<CR><LF>` und ist nicht mit einem echten Zeilenumbruch zu verwechseln.

#### Prüfdaten liegen bereit — sechs Nachrichten, ein POP3-Server

Gregor hat angeboten, auf dem Windows-Rechner Beispiele herauszusuchen oder
Testdaten zu erzeugen. **Das ist erledigt**, es braucht keine echte Post mehr:

```
perl tools/anhang-pruefdaten.pl              # zeigt die sechs Faelle
perl tools/anhang-pruefdaten.pl --erzeugen   # schreibt die .eml-Dateien
perl tools/anhang-pruefdaten.pl --pop        # liefert sie auf 127.0.0.1:11110
```

Sechs Nachrichten mit einem gültigen einseitigen PDF im Anhang, eine je Ursache,
in `tools/pruefdaten/anhang-faltung/`. **Eine `.eml` in eine `.mbx` zu kopieren
reicht nicht** — der Fehler sitzt im Empfangsweg, die Nachricht muss wirklich
abgerufen werden. Dafür der mitgelieferte POP3-Server: kein Netz, keine
Zugangsdaten, alles auf `127.0.0.1`.

Konto in Eudora, in der Gruppe `[Settings]` der `eudora.ini`:
`POPAccount=pruef@127.0.0.1`, `LoginName=pruef`, `POPPort=11110`,
`SSLReceiveUse=0`, Kennwort beliebig. Alle vier liegen unter 10800 und gehören
damit nach `GetSectionID` (`rs.cpp:89`) in `[Settings]`. **`POPPort` muss
wirklich dastehen** — fehlt er, landet Eudora laut Befund [**E-23**](BEFUNDE.md#e-23) stillschweigend
auf 110.

| | |
|---|---|
| **alle sechs heil** | die Teile des POP-Wegs wirken am laufenden Programm (B5.1, B5.2, B5.3 mit B5.8, B5.5, B5.9) — B5.6 und [B5.7](#b5.7) betreffen nur IMAP und lassen sich so nicht zeigen. **So ist es seit 7.2.0.81** |
| **00 heil, 01 bis 05 kaputt** | die Behebung ist nicht im Bau gelandet |
| **00 kaputt** | etwas anderes ist schiefgegangen, nicht [AN-1](BEFUNDE.md#an-1) |
| **gemischt** | die Liste der kaputten Fälle zeigt auf den Teil — so war es an 7.2.0.79 (4 von 6) und 7.2.0.80-an1 (5 von 6) |

Der Server löscht nie etwas — beliebig oft abrufbar. Einzelheiten:
`tools/pruefdaten/LIESMICH.md`.

**In echter Post erkannte man es am doppelten Anführungszeichen** in der
`.mbx`-Datei: eines am Zeilenende vor einer Zeile, die mit Leerzeichen oder
Tabulator beginnt, und das ursprüngliche am Ende. Eudora setzte es im Fehlerfall
dorthin. Siehe BEFUNDE.md [AN-1](BEFUNDE.md#an-1), „Der Fingerabdruck in der Mailbox-Datei".

#### Warum das behoben wurde — und worauf **nicht** zu warten war

Gregors Begründung vom 30.09., wörtlich: *„Ich möchte das fixen, weil es unschön
ist und weil es im freigegebenen Release schlecht aussieht."* Dass es sich um
einen Originalfehler aus Eudora 7.1 handelt, ist ihm ausdrücklich **egal** —
die Herkunft steht in [AN-1](BEFUNDE.md#an-1) nur, weil sie sagt, wo zu suchen ist.

Sein Ziel vom 12.10.2026: *„anhänge werden korrekt gespeichert - mit erweiterung,
komplette dateiname"*.

**Eine Beispielnachricht gibt es nicht und wird es nicht geben.** Gregor hat den
Fehler im Betrieb gesehen — *„immer wieder Dateien im Attachment …, bei denen
zum Beispiel PDF oder Doc … fehlt und der Dateiname ist nicht vollständig"* —,
kann aber keine Nachricht liefern. **Darauf war nicht zu warten.** Alle zehn
behobenen Teile sind aus dem Quelltext heraus begründet; seit dem 12.10.2026
sind sie mit MSVC gebaut und über POP am laufenden Programm gemessen, über IMAP
von Gregor an seinem Postfach getestet (B5.4, B5.6, B5.10 und B5.11 lassen sich mit den
Prüfdaten nicht auslösen).

Vollständige Herleitung mit allen Messungen: **BEFUNDE.md, [AN-1](BEFUNDE.md#an-1)**.
### <a id="b6"></a>B6 · Beim Start zeigt ein Fenster den Quelltext einer Webseite (**AN-2**) — **geändert in 7.2.0.80, übersetzt in 7.2.0.82, von Gregor an 1.0.84 bestätigt (13.10.2026); die Werbe-Betriebsart wird nach seiner Entscheidung nicht weiter verfolgt**

Gregors Meldung vom 12.10.2026, wörtlich: *„nachdem eudora gestartet wurde, ist
es innerhalb eines Fensters darin angezeigt worden. ohne daß ich etwas gemacht
habe."*

Vollständige Herleitung in **BEFUNDE.md, [AN-2](BEFUNDE.md#an-2)**. Kurz:

| | |
|---|---|
| **Was** | Eudora startet mit einer frischen `Eudora.ini` in der **Werbe-Betriebsart** (`[Settings] Mode` fehlt → `DEFAULT_SWM_MODE` = 0) **[widerlegt 13.10.2026: der Schalter ist seit `bf14e14` gesetzt, Vorgabe ist 2 = Pro; siehe [AN-2](BEFUNDE.md#an-2)]**, holt Werbung von `//adserver.eudora.com/adjoin/playlists` — und diese Adresse gehört seit 2018 dem Computer History Museum. Die Antwort ist eine Webseite |
| **Warum sie als Text erscheint** | Das Werbefenster ist `class CAdView : public CPaigeEdtView` — kein Browser, sondern Paige. Und Paige kannte kein Element, dessen Inhalt kein Text ist: `script` fehlte in `control_commands`, `style` stand darin ohne Behandlung |
| **Geändert** | neuer Merker `inside_script`, nach dem Muster des vorhandenen `inside_title`. Vier Dateien, 29 Zeilen |
| **Gemessen** | `perl tools/html-tags-pruefen.pl` — 30 Fälle, 0 Abweichungen, Gegenprobe gefahren |
| **Nicht gemessen** | übersetzt ist es seit 7.2.0.82 (Rebuild 0 Fehler, Testsuite 185/185, ebenso in 7.2.0.83). Dass es im Werbefenster wirkt, ist nicht belegt — der Prüfstand löst den Fall nicht aus |
| **Bestätigt, 13.10.2026** | von Gregor an 1.0.84 im normalen Betrieb: *„HTML newsletter (weiter geleitet) wird korrekt dargestellt.“* Das Werbefenster ist an diesem Bau **nicht auslösbar** — mit frischer INI nicht (Vorgabe `Mode=2`) und auch mit `Mode=0` nicht (`C:\Temp\AN2-1084`, kein Abruf) |

#### Was offen bleibt — und zwar als Frage an Gregor

> **Beantwortet am 13.10.2026 ([L-27.4](../Befunde/LEKTOR-27.md#l-27.4)).** Gregor auf die Frage
> *„brauchen wir mode=0 überhaupt?“*: *„ja, einverstanden“* — die
> Werbe-Betriebsart wird **nicht weiter verfolgt**. Dazu ist die Annahme unten
> überholt: dieser Bau startet nicht in der Werbe-Betriebsart, `DEFAULT_SWM_MODE`
> ist bereits **2** (`BUILD_BOX_OR_SITE_R_VERSION` gesetzt seit `bf14e14`), und
> auch mit `Mode=0` holte 1.0.84 nichts. Weg 3 ist damit schon der Zustand des
> Baus. Die drei Wege bleiben als Stand vom 12.10.2026 stehen.

**Soll diese Fassung überhaupt noch Werbung abrufen?** Das ist keine
Programmierfrage. Der Abruf ist Absicht aus dem Jahr 2000; heute holt er eine
beliebige Seite von einem fremden Rechner und zeigt sie an. Drei Wege:

1. **Nichts tun.** Die Behebung reicht, damit es nicht mehr nach Chaos aussieht
   — die Seite steht dann lesbar im Fenster.
2. **Über die `Eudora.ini` abschalten**, ohne Neubau: `[Settings] Mode=1`
   (`SWM_MODE_LIGHT`, keine Werbung, dafür schaltet `UsingFullFeatureSet()`
   Funktionen ab) oder `Mode=2` (`SWM_MODE_PRO`, alle Funktionen, verlangt aber
   einen Registriercode). **Beides nicht nachgemessen.**
3. **Im Quelltext abschalten** — `DEFAULT_SWM_MODE` auf 2, oder den Abruf
   überhaupt nicht mehr starten. Das ist eine Entscheidung über das Produkt,
   nicht über einen Fehler, und gehört deshalb Gregor.

**Den Werbeserver auf einen toten Rechner zu zeigen, ist kein Weg:** nach vier
Tagen meldet sich `CAdFailureNagTask` (`nDaysUntilAdFailure = 4`).

#### Was beim Nachsehen aufgefallen ist und nicht behoben wurde

**Der Werbeweg schreibt in den Log, wenn man ihn lässt** — Bit
`DEBUG_MASK_PLIST` (`0x1000`, `debug.h`). Damit wäre am Protokoll ablesbar, ob
die Seite wirklich über diesen Weg kam; bisher ist das aus dem Quelltext
erschlossen. Wer es messen will: `LogLevel` um 4096 erhöhen.

**`<style>` trifft nicht nur Werbung.** Jede HTML-Nachricht mit eingebettetem
`<style>`-Block — also die meisten Newsletter — hat ihr CSS bisher als Text
angezeigt. Dass das nie als eigener Befund auftauchte, heißt nicht, dass es
nicht passierte; es sah aus wie wirrer Text am Anfang der Nachricht. Verwandt
mit [**E-105**](BEFUNDE.md#e-105) (versteckter Vorschautext, weil Paige `display:none` nicht kennt).

---

### <a id="b7"></a>B7 · Betreff mitten im Wort umbrochen (**E-94**) — **behoben in 7.2.0.84, über POP und IMAP am laufenden Programm gemessen, von Gregor bestätigt**

Gregors Fall: *„Toner bestel len & 1 5 % sparen … Nur b is zum Wochenende!"*.
Auf seine Anordnung *„zu diesem fall brauchen wir einen weiteren test"* und
**„Jetzt, vor [E-112](BEFUNDE.md#e-112)"** gilt: erst die Tests rot, dann die Behebung.

| Schritt | Stand |
|---|---|
| Tests `Fix2047` und `ImapFix2047` mit gefalteten kodierten Wörtern (`Eudora71/Tests/TestPopEmpfang.cpp`, `UnderTestImap2047.cpp`) | **rot** an 7.2.0.83 (`bestel` 0D 0A 20 `len`), **grün** nach der Behebung — 188/188 |
| Prüfnachricht **06** im POP-Prüfstand (`tools/anhang-pruefdaten.pl --pop`) | an 7.2.0.83 gemessen: Faltungen in `In.mbx`, Postfachliste nur `Pruefung E-94: Toner bestel` |
| Behebung `Fix2047`/`ImapFix2047` und beide Zerleger (`LexFill`, Faltungsregel) | im Quelltext, 7.2.0.84 |
| Bau, Prüfnachrichten 00–06 am laufenden Programm, PRÜFER | **erledigt**: 06 heil, 00–05 unverändert, PRUEFER-21 „kann ausgeliefert werden" |
| Gregors Test an 1.0.84 über IMAP | **bestätigt** am 12.10.2026, Bildschirmfoto: Toner-Betreff und „Rabatt aktivieren“ in einem Stück |

Einzelheiten: [CHANGELOG.md](../CHANGELOG.md), Abschnitt 7.2.0.84; BEFUNDE.md, [E-94](BEFUNDE.md#e-94).

## C — Das Auslieferungspaket

### <a id="c1"></a>C1 · `paket-pruefen.ps1` — **behoben am 06.09.2026** (PR-2.0)

Zwei belegte Mängel, beide beseitigt:

1. **Es prüfte die Maschine, nicht das Paket.** Gegenprobe damals:
   `EudoraRes.dll`, `QCSSL.dll`, `SPELL32.DLL`, `EuGraph.ocx` und `Plugins\` aus
   einer Kopie gelöscht → *„keine Fehler, EXIT=0"*.
2. **Bei einem Release-Paket erzeugte es vier Falschwarnungen** (feste
   Debug-Laufzeitliste). Wer ihnen folgte, holte mit `laufzeit-holen.ps1` die
   **nicht verteilbaren** DLLs ins Paket — es leitete zum Lizenzverstoß an.

**Behoben in Commit `dfc8b40`:** die nötigen Laufzeiten werden aus den
**PE-Import- und Verzögerungstabellen** der Paketdateien abgeleitet statt aus
einer Liste (`tools/paket-pruefen.ps1:437`); ein Treffer in
`SysWOW64`/`System32` gilt ausdrücklich **nicht** als vorhanden (`:546`); beim
Debug-Paket weist es den Weg über `laufzeit-holen.ps1` selbst ab (`:577`). Drei
Gegenproben in `Befunde/PAKET.md:106-127`.

**Was weiter gilt:** das Werkzeug ersetzt keinen Startversuch auf einem fremden
Rechner. Es sagt, ob der Lader alles findet, was er vor dem ersten Befehl
braucht — nicht, ob Eudora läuft. **Kriterium 0** ist ohnehin am lebenden Objekt
belegt (siehe [C2](#c2)).

### <a id="c2"></a>C2 · Kriterium 0 auf einem Rechner ohne Visual Studio nachweisen — **erledigt**

**Erbracht am 06.09.2026** von Gregor selbst: `Eudora72-1.0.10-release.zip` auf
einem Rechner **ohne Visual Studio** ausgepackt und gestartet — *„test
bestanden: eudora läuft ohne VS2022 installiert."* Am 31.08. lief dort noch das
**Debug**-Paket mit beigelegten, nicht verteilbaren DLLs ([**E-8**](BEFUNDE.md#e-8)); das zählte
nicht, und deshalb stand diese Aufgabe hier.

### <a id="c3"></a>C3 · Warum musste das Mailverzeichnis von Hand dazugelegt werden?

Beide Pakete enthalten `Mailverzeichnis\Eudora.ini`. Ungeklärt ([**E-6**](BEFUNDE.md#e-6)).

---

## D — Werkzeuge und Quelltextanalyse

### D3a · Die neun Zeigerstellen aus X-3 beheben — **braucht einen Bau**

Prüfung vorhanden, Zugriff danach ungeschützt, kein erkennbarer Grund, warum der
Zeiger dort belegt sein müsste. **Neu gemessen am 07.09.2026** mit
`perl tools/suche-zeiger.pl <datei> …`; der Funktionsname steht dabei, weil die
Zeilennummern verrutschen (bei `headervw.cpp` allein um 34, seit [E-32](BEFUNDE.md#e-32)).

| # | Zeiger | Funktion | Prüfung → Zugriff |
|---|---|---|---|
| 1 | `pDiskHost` | `CPOPSession::DoReconcileUIDLInfo_` (`Eudora/POPSession.cpp`) | :896 → :905 — auf dem **Abrufpfad**, deshalb zuerst |
| 2 | `m_pTaskInfo` | `CImapChecker::DownloadNewMessagesToTmpTocMT` (`EuImap/src/ImapChecker.cpp`) | :945 → :953 |
| 3 | `m_pAccount` | `CImapLogin::Login` (`EuImap/src/imapgets.cpp`) | :735 → :743 |
| 4 | `pTocDoc` | `CTocFrame::OnClose` (`Eudora/TocFrame.cpp`) | :3968 → :3973 |
| 5 | `pField` | `CHeaderView::OnInitialUpdate` (`Eudora/headervw.cpp`) | :580 → :585 |
| 6 | `pAccount` | `CImapMailbox::OpenOnDisplay` (`EuImap/src/ImapMailbox.cpp`) | :1022 → :1051 |
| 7 | `pView` | `PgBindToObject` (`Eudora/PgEmbeddedObject.cpp`) | :276 → :303 |
| 8 | `pChild` | `CWizardImportPage::CopySettings` (`AccountWizard/Src/WizardImportPage.cpp`) | :403 → :444 |
| 9 | `pImapCommand` | `EuImap/src/ImapAccount.cpp` | :3152 → :3202 |

Die Behebung ist jeweils dieselbe Form: die Prüfung mitziehen (`if (p && …)`)
oder früh aussteigen.

> **Berichtigung (07.09.2026).** Als Nummer 1 und *„der ernsteste der neun"*
> stand hier: *„`EuImap/src/ImapMailbox.cpp:1637` → `:1659` (`pImapCommand`) —
> der Block des Wächters ist `if (!pImapCommand) { ASSERT(0); … }` **ohne
> `return`**. Im Release entfällt das `ASSERT`, dann läuft es weiter und greift
> auf den Nullzeiger zu."* **Das ist falsch.** Nachgesehen in
> `CImapMailbox::CheckMail`: der Block endet mit `return E_FAIL;`, nach dem
> Wächter ist der Zeiger also belegt.
>
> Es ist ein **Fehlalarm von `suche-zeiger.pl`**: bei einem **negativen**
> Wächter (`if (!p)`) sucht das Werkzeug das `return` nur in den nächsten sechs
> Zeilen, hier steht es fünfzehn Zeilen weiter. Das ist eine vierte
> Fehlerklasse neben den drei, die [X-1](BEFUNDE.md#x-1) schon abgestellt hat, und sie gehört ins
> **Werkzeug**, nicht in diese Liste.
>
> Ebenfalls hier gestanden: drei *„unklare"* Treffer, `ImapAccount.cpp:3152`,
> `CompMessageFrame.cpp:644` und `StatMng.cpp:2399`. Am 07.09.2026 nachgemessen
> melden `CompMessageFrame.cpp` und `StatMng.cpp` **nichts** mehr;
> `ImapAccount.cpp:3152` ist ein gewöhnlicher positiver Wächter und steht jetzt
> als Nummer 9 in der Liste.

**Nummer 8 ist nicht der Assistenten-Absturz** — der ist [E-25](BEFUNDE.md#e-25), siehe oben. Die
Stelle bleibt trotzdem zu härten.

---

## E — Die Ersatzschicht

### <a id="e1"></a>E1 · `FloatControlBarInMDIChild` ist ein leerer Rumpf (Erscheinungsbild-Befund **A-1**)

> **Achtung, die Kennung [`A-1`](BEFUNDE.md#a-1) ist zweimal vergeben** (Befund [L-9.8](../Befunde/LEKTOR-5.md#l-9.8), offen —
> Kennungen vergibt Gregor, nicht ein Agent). Gemeint ist hier der
> **Agentenbefund vom 30.08.2026 zum Erscheinungsbild** (fünf Punkte aus [S-6](BEFUNDE.md#s-6)),
> **nicht** die Anforderung [**A-1**](BEFUNDE.md#a-1) in [ZIEL.md](../ZIEL.md) (Vorgaben für ein neu
> angelegtes Konto). Wer „[A-1](BEFUNDE.md#a-1)" liest, prüft zuerst, welche der beiden gemeint
> ist.

`CWazooBarMgr::CreateNewWazooBar` (`WazooBarMgr.cpp`, heute Zeile 254) und
`CWazooBarMgr::SetDefaultWazooBarState` (heute Zeile 424) docken die Leiste an
und schicken danach `ID_SEC_MDIFLOAT`. Der Befehl läuft ins Leere:
`SECMDIFrameWnd::FloatControlBarInMDIChild` ist bewusst ohne Wirkung, weil MFC
kein Gegenstück dafür hat. Die Leiste bleibt angedockt, und `GetParentFrame()`
liefert weiterhin **das Hauptfenster** statt eines `QCControlBarWorksheet`. Im
Debug greift `ASSERT_KINDOF`, **im Release liefe `MoveWindow` auf das
Hauptfenster** — beide Stellen sind deshalb seit Befund [**E-4**](BEFUNDE.md#e-4) ausdrücklich
abgesichert; der Kommentar dazu steht im Quelltext daneben.
Der größte verbliebene Rest im Erscheinungsbild, dazu die Splitter
(`SECDockBar::AddSplitter` wird nie gerufen).

> **Berichtigung (07.09.2026).** Hier stand `WazooBarMgr.cpp:377-400` als
> Fundstelle. Dieser Bereich ist **vollständig auskommentiert** — jede Zeile
> beginnt mit `//FORNOW`. Die lebenden Stellen sind die beiden oben genannten.

### <a id="e2"></a>E2 · Der größte Eingriff an `OTShim.cpp` hat keinen Test (**PR-2**)

`1a4a6d5` ändert `OTShim.cpp` um **334 Zeilen**; `Eudora71/Tests/` blieb
unangetastet. `TestOTShimAndocken.cpp:214` prüft sogar noch das **alte**
Verhalten (`CalcDynamicLayout(0, LM_HORZDOCK) == 32767`).

### <a id="e3"></a>E3 · `SetControlBarWidthsInRow` ist noch leer

`SECDockBar::SetControlBarWidthsInRow` in `Eudora71/OTShim/OTShim.cpp` (heute
Zeile 2245) hat einen leeren Rumpf, und `SECDockBar::OnSizeParent` (heute
Zeile 3360) reicht noch an `CDockBar::OnSizeParent` durch.

---

## F — Offene Kleinigkeiten

- **`Out.mbx`-Größe 1.788.158.654 für eine leere Datei** — nicht initialisierter
  Wert im Protokoll, zwei Zeilen später steht korrekt 0.
- **`EUMAPI.DLL` ist eine 16-Bit-Datei** von 1995 (Signatur `NE`, belegt in
  [Z-1](BEFUNDE.md#z-1)). Niemand importiert sie. Kann vermutlich aus dem Paket.
- **`MFC71.DLL` und `MSVCP71.dll`** sind nicht nachbaubar (157 Ordinale, [B-1](BEFUNDE.md#b-1)).
  Die Verzeichnisdienste (LDAP, Ph, `EudoraBk`) fallen dauerhaft aus, solange die Fremd-DLLs von 2006
  benutzt werden.
- **Toter Include-Pfad** `..\OpenSSL\inc32` in `QCSocket.vcxproj:60` und das
  `OpenSSL`-Projekt in der Solution: gegen `libeay32.lib`/`ssleay32.lib` linkt
  kein Projekt mehr. Beides kann weg.
- **`Releases/PAKETE.md` hinkt hinterher** — einen eigenen Abschnitt haben
  1.0.23, 1.0.22, 1.0.21, 1.0.18, 1.0.3, 1.0.2 und 1.0.1; **1.0.4 bis 1.0.17
  sowie 1.0.19 und 1.0.20 fehlen** (Mangel **[M-4](../Befunde/PRUEFER-15.md#m-4)**, weiter offen). In der
  Tabelle *Wo die Pakete liegen* stehen 1.0.4, 1.0.10, 1.0.14, 1.0.15 und
  1.0.19 mit Prüfsumme; 1.0.20 fehlt auch dort. Wer das nächste Paket schnürt,
  trägt seinen Abschnitt gleich mit ein — für 1.0.22 und 1.0.23 ist das am
  08.09.2026 nachgeholt worden.
  Weitere überholte Stellen in anderen `.md` stehen in
  [Befunde/LEKTOR.md](../Befunde/LEKTOR.md),
  [Befunde/LEKTOR-3.md](../Befunde/LEKTOR-3.md),
  [Befunde/LEKTOR-4.md](../Befunde/LEKTOR-4.md),
  [Befunde/LEKTOR-5.md](../Befunde/LEKTOR-5.md) und
  [Befunde/LEKTOR-6.md](../Befunde/LEKTOR-6.md).

---

## Zurückgestellt — nicht von selbst aufgreifen

Von `tools/patches/zertifikatspruefung-verschaerfen.patch` ist der Teil zu
`X509_V_ERR_CERT_UNTRUSTED` **erledigt** — er ist als Befund [**E-82**](BEFUNDE.md#e-82) in
7.2.0.48 eingespielt und von Gregor am 11.09.2026 bestätigt
(`Eudora71/QCSSL/src/qccertificate.cpp:82-90`).

**Zurückgestellt bleibt die Hostnamensprüfung:** Eudora vergleicht nur den
`CN`, nicht die `subjectAltName`-Einträge, und sendet kein SNI. Gregor hat
entschieden, das später anzugehen. **Nicht ohne sein Wort anwenden.**

---

## Auflagen für Agenten

1. **Kein Programm mit Fenstern starten** ohne Absprache. Gregor testet auf
   derselben Windows-Sitzung. Beim Aufräumen von Prozessen **immer nach Pfad
   filtern** — sonst schießt man seine laufende Sitzung mit ab.
2. **Erst prüfen, dann anweisen.** Keine Handlungsanweisung ohne den Weg selbst
   gegangen zu sein. Ein Bauverzeichnis ist kein Startverzeichnis.
3. **Byte-erhaltend ändern:** `tools/aendere-zeile.pl`, `tools/ersetze-bereich.pl`.
   **Niemals `sed`** — das cygwin-`sed` wirft CR weg ([X-1](BEFUNDE.md#x-1)). Zum Messen `perl`
   mit `:raw`.
4. **Bauen mit `tools/bauen.ps1`**, in der PowerShell, nicht in der Git-Bash.
   Kein MSBuild-Aufruf von Hand mehr: am 05.09.2026 hat einer Erfolg gemeldet,
   ohne gebaut zu haben ([X-6](BEFUNDE.md#x-6)). Die Plattform heißt auf Projektmappenebene
   **`x86`**, nicht `Win32`. Visual Studio liegt unter **Professional**.
   **Die ganze Projektmappe bauen** — die `.lib` entstehen erst dabei.
   `/p:BuildProjectReferences=false` ist seit dem 05.09.2026 **nicht mehr nötig
   und nicht mehr erwünscht** ([B-3](BEFUNDE.md#b-3)).
5. **Zeilenangaben veralten**, sobald jemand dieselbe Datei anfasst ([Z-1](BEFUNDE.md#z-1): sieben
   von elf Abweichungen waren genau das). Wer eine Fundstelle benutzt, prüft sie
   nach.
6. **In kleinen Schritten committen und pushen.** Was nicht gepusht ist, ist bei
   einem Abschalten verloren.
7. **Vor jedem Commit: auf welchem Zweig stehe ich, und lebt der noch?** Nicht
   aus dem Gedächtnis, sondern gemessen: `perl tools/pruefe-branch.pl --melden`.
   Der `pre-commit`-Hook prüft es als **ersten** Schritt und bricht ab. Wer den
   Hook nicht eingerichtet hat (`sh tools/hooks-einrichten.sh`), arbeitet ohne
   diese Schranke — sie liegt unter `.git/hooks` und wird nicht mitversioniert.
   Anlass war [**X-5**](BEFUNDE.md#x-5): am 31.08.2026 lag drei Minuten nach einem Merge ein
   weiterer Commit auf genau dem zusammengeführten Zweig.
8. **Kündigt Gregor einen Merge an, läuft SOFORT `perl tools/gesichert.pl`** —
   vor jeder anderen Handlung, und das Ergebnis wird gemeldet. Rückgabewert `0`
   heißt gesichert, `1` nennt, was fehlt. Die Ansage ist der Auslöser, nicht der
   Nachweis: „es sollte alles committet und gepusht sein" ist eine Erwartung,
   kein Messwert.
9. **Nie direkt auf `main`.** Jede Änderung über einen eigenen Zweig; Gregor
   merged. Nach einem Merge durch ihn wird gewechselt, nicht auf dem alten Zweig
   weitergearbeitet:
   `git checkout main && git pull && git switch -c <neuer-name>`.
10. **Eine Auflage, die nur im Text steht, trägt nicht.** Das war der
    Entwurfsfehler hinter [X-5](BEFUNDE.md#x-5). Wer eine neue Regel aufstellt, **baut die
    Schranke dazu** — ein Werkzeug mit Rückgabewert, eingehängt im Hook, und
    einen Testfall in einer Sammlung, der beweist, dass sie greift *und* dass sie
    nicht grundlos anschlägt. Beides gehört in denselben Commit wie die Regel.
11. **Die Doku gehört in denselben Commit wie die Änderung.** Gregor am
    07.09.2026: *„ich hasse es, wenn in den dokus falsche oder veraltete infos
    und werte stehen. das muss immer parallel gleich erledigt werden, klar?"*
    Wer einen Befund behebt, zieht `BEFUNDE.md`, `CHANGELOG.md` und, wenn der
    Stand sich ändert, `ZIEL.md` mit. Die Schranke dazu ist
    `perl tools/doku-pruefen.pl`; sie läuft im `pre-commit`-Hook, sobald eine
    `.md`, `VERSION` oder `Eudora71/Version.h` mit im Commit ist (Befund L-7).
12. **Zahlen und Fundstellen werden gemessen, nicht abgeschrieben.** Jede Zahl
    in der Doku braucht den Befehl, mit dem man sie nachzählt, daneben. Eine
    Zahl, die niemand pflegt, ist schlimmer als keine (Lehre [L-6.10](../Befunde/LEKTOR-2.md#l-6.10)). Wo eine
    Zeilennummer unvermeidlich ist, gehört der **Funktionsname** dazu.
