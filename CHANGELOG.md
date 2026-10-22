# Was sich geändert hat

Neueste Fassung zuerst. Jede Nummer gehört genau einem Bau: **Quellstand
`7.2.0.x`** steht in `Eudora71/Version.h`, **Paketnummer `1.0.x`** in `VERSION`.
Die Bau-Kennung im Fenstertitel nennt beide plus den Commit.

> **Wer hier neu einsteigt:** [ZIEL.md](ZIEL.md) sagt, woran „fertig" gemessen
> wird, [README.md](README.md) wie man baut und startet, [BEFUNDE.md](Intern/BEFUNDE.md)
> was im Einzelnen gefunden wurde. Der Abschnitt **Wo man weitermachen kann**
> ganz unten nennt die offenen Enden mit Fundstelle.

## Noch offen

> **Diese Tabelle wird erzeugt.** `tools/offene-befunde.pl` setzt sie aus den
> Urteilen in [Intern/BEFUNDE.md](Intern/BEFUNDE.md) und weist im `pre-commit`
> ab, wenn sie nicht stimmt. Von Hand eintragen lohnt nicht.
>
> Bis zum 22.10.2026 stand hier eine handgepflegte Liste. Sie nannte **fünf
> Befunde als offen, die in ihrer eigenen Statusspalte „Behoben" sagten**
> ([E-112](Intern/BEFUNDE.md#e-112), [E-115](Intern/BEFUNDE.md#e-115), [E-117](Intern/BEFUNDE.md#e-117), [E-118](Intern/BEFUNDE.md#e-118), [E-68](Intern/BEFUNDE.md#e-68)), und **zehn offene fehlten ganz**. Eine
> Liste, die beides kann, ist schlimmer als keine.

Die Spalte **was noch fehlt** sagt, was zu tun bleibt — nicht, was schon
erledigt ist. Die Messung und die Begründung stehen bei jedem Befund in
[Intern/BEFUNDE.md](Intern/BEFUNDE.md); was *behoben* wurde, steht weiter
unten in diesem Dokument unter der jeweiligen Fassung.

<!-- offene-befunde: Anfang -->

| Kennung | worum es geht | zuletzt gemessen | was noch fehlt |
|---|---|---|---|
| **[E-133](Intern/BEFUNDE.md#e-133)** | Zeigt die Registry auf ein Mailverzeichnis, das es nicht mehr gibt, weigert sich Eudora zu… | **nie gemessen** | Gregor hat *„nur aufnehmen, nicht fixen"* entschieden — aufzugreifen wäre, bei fehlendem Verzeichnis zu fragen oder ein eigenes anzulegen statt d… |
| **[E-130](Intern/BEFUNDE.md#e-130)** | Fünf vorgebaute Fremd-DLLs werden bei jedem Bau neu gestempelt — und im Paket liegen an… | **nie gemessen** | zweierlei — **wer** die fünf DLLs beim Bau stempelt, ist nicht gefunden (`paket-bauen.ps1` liest sie nur, kein `.vcxproj` nennt sie), und es ist ni… |
| **[E-129](Intern/BEFUNDE.md#e-129)** | Nach einem Verschieben in einen IMAP-Ordner ohne Verbindung und sofortigem Beenden zeigt d… | **nie gemessen** | beide Mängel stehen noch — (1) warum beim Beenden ohne Serververbindung nur **ein** statt fünf Verzeichniseinträgen geschrieben wird, ist nicht u… |
| **[E-128](Intern/BEFUNDE.md#e-128)** | Eine gespeicherte Nachricht heißt .txt und enthält HTML — der Anwender erfährt es nic… | **nie gemessen** | die Entscheidung über den eigenen Vorschlag und dann sein Einbau — die Vorgabeendung aus dem Inhalt ableiten (`.html`, `.eml`, `.txt`) und den Date… |
| **[E-127](Intern/BEFUNDE.md#e-127)** | Ein IMAP-Ordner, der seit dem Start noch nie geöffnet war, zeigt die eben dorthin verscho… | **nie gemessen** | die Ursache ist nicht untersucht — gemessen ist nur Gregors Protokoll (hochgeladen bei `summen=2`, erst **danach** `NewChildFrame … OUTBOX`, Abgle… |
| **[E-126](Intern/BEFUNDE.md#e-126)** | Eine gesendete Mail, die genau während eines Abgleichs des Ziel-IMAP-Ordners dorthin vers… | **nie gemessen** | jede Messung — die Vermutung aus [PRÜFER-33](Befunde/PRUEFER-33.md) Q1 ist nie beobachtet worden, weder bei Gregor noch am Prüfstand, und dort … |
| **[E-125](Intern/BEFUNDE.md#e-125)** | Eine Nachricht aus einem IMAP-Ordner nach Out verschieben legt eine neue Nachricht mit <br… | **nie gemessen** | Gregors Entscheidung **B** ist noch nicht gebaut — Ziehen nach `Out` soll abgelehnt werden mit Hinweis auf *Message → Send Again*; die Stelle ist … |
| **[E-124](Intern/BEFUNDE.md#e-124)** | Microsoft Defender stuft eine Eudora-Fassung als Trojaner ein und beendet das laufende Pro… | **nie gemessen** | zwei Dinge von außen — die Antwort von Microsoft auf Vorgang `a567fe2a-9f58-47e1-a675-a62733ec538f` (Stand *Submitted*) gehört hierher, und über … |
| **[E-123](Intern/BEFUNDE.md#e-123)** | Nach einem Neustart mitten in einer Übertragung lokal → IMAP können eingebettete Bilde… | **nie gemessen** | der Verlust eingebetteter Bilder nach **Absturz, Defender, Stromausfall oder erzwungenem Herunterfahren**. Abgearbeitet ist nur der ordentliche Beende… |
| **[E-122](Intern/BEFUNDE.md#e-122)** | Das Eingangsdatum einer in einen IMAP-Ordner hochgeladenen Nachricht ist um die Zeitzone v… | **nie gemessen** | die Berichtigung selbst — `ImapMailbox.cpp:4281` übergibt `CSummary::m_Seconds` an `append_date`, das echtes UTC erwartet, während `m_Seconds` UTC… |
| **[E-119](Intern/BEFUNDE.md#e-119)** | Bilder, die als data:-Adresse im HTML stecken, erscheinen beim Antworten und Weiterleiten … | **nie gemessen** | der Einbau — die Base64-Daten müssen **vor** `PGHTMIMP.CPP:3317` (beim Zerlegen des `<img>`-Tags) in eine Datei unter `Embedded` dekodiert und `src… |
| **[E-116](Intern/BEFUNDE.md#e-116)** | width="35px" wird als 3508 gelesen — eine Größenangabe mit Einheit oder Nachkommastell… | **nie gemessen** | Einbau und Messung — der Vorschlag des PRÜFERS vor `PGHTMIMP.CPP:3694` (auf eine folgende Ziffer prüfen und sonst abbrechen) ist nicht eingebaut, … |
| **[E-114](Intern/BEFUNDE.md#e-114)** | ein angedocktes Fenster hinterlässt nach dem Lösen einen leeren Bereich — das Filterfe… | **nie gemessen** | die Bedingungen — Gregor konnte es am selben Tag nicht nachstellen. Zu messen: wo genau angedockt war, ob der leere Bereich nach Größenänderung d… |
| **[E-113](Intern/BEFUNDE.md#e-113)** | Bilder, die breiter sind als das Fenster, laufen rechts hinaus — statt anteilig eingepas… | 22.10.2026 an 7.2.0.121 | alles — von Gregor angeordnet; die Vorbedingung [E-112](Intern/BEFUNDE.md#e-112) ist seit 7.2.0.85 behoben, der Befund ist damit an der Reihe. Billig wäre ein Deckel beim Umb… |
| **[E-109](Intern/BEFUNDE.md#e-109)** | Die Schranken waren da und haben nicht gehalten — *„es gibt viele schranken, die genau… | **nie gemessen** | die drei Forderungen sind nicht umgesetzt — je Schranke ein Testfall für ihre **bekannte Grenze**, eine Unterscheidung zwischen *geprüft und frei*… |
| **[E-101](Intern/BEFUNDE.md#e-101)** | Die gespeicherte Datei ist für jedes andere Programm unbrauchbar — *„datei gespeicher… | **nie gemessen** | allein **F2** — `StripTabooHeaders` entfernt die `Content-Type`-Zeile, bevor der Kern sie setzen kann; auf dem einzigen Aufrufweg ist er damit tot (… |
| **[E-98](Intern/BEFUNDE.md#e-98)** | Die beiden Optionen im Speicherdialog fehlen — *Kopfzeilen einschließen* (Include Heade… | **nie gemessen** | zweierlei ist nicht gemessen — welche Vorgabe für *Kopfzeilen einschließen* und *Absätze raten* tatsächlich greift, solange die Kästchen fehlen… |
| **[E-92](Intern/BEFUNDE.md#e-92)** | der Weiterleitungskopf ist bei Thunderbird eine ausgerichtete kleine Tabelle — auf Grego… | 22.10.2026 an 7.2.0.121 | unsere eigene Seite — ein Vergleichsbild aus Eudora zur selben Nachricht liegt nicht vor, es ist also offen, ob unser Weiterleitungskopf überhaupt … |
| **[E-91](Intern/BEFUNDE.md#e-91)** | zitierte Bereiche stehen bündig im Text, ohne Randbalken und Einrückung — auf Gregors … | 22.10.2026 an 7.2.0.121 | die **Messung selbst** — ungeklärt ist, ob Gregors Bild den Lese- oder den Verfassenweg zeigte und ob die Nachricht überhaupt ein `blockquote` tru… |
| **[E-90](Intern/BEFUNDE.md#e-90)** | Emoji in Betreffzeilen erscheinen als ? — Gregors Thunderbird-Vergleich vom 14.09.2026 z… | 22.10.2026 an 7.2.0.121 | nichts, was für sich zu beheben wäre — `?` ist die bessere von zwei Möglichkeiten, solange Eudora durchgehend ANSI/MBCS gebaut ist (Begründung i… |
| **[E-78](Intern/BEFUNDE.md#e-78)** | die Standardanordnung der Leisten wird bei jedem Start nachgezogen, obwohl der Zustand ges… | **nie gemessen** | die Auswertung der vorhandenen Spurmarken und danach die Behebung — `E-78 nach SetDockState` und `E-78 vor/nach LoadWazooBarConfig` (`mainfrm.cpp`, … |
| **[E-77](Intern/BEFUNDE.md#e-77)** | IMAP-Postfachnamen mit Umlauten werden roh angezeigt — Entw&APw-rfe statt *Entwürfe*, G… | 22.10.2026 an 7.2.0.121 | die Behebung — eine Dekodierung von modifiziertem UTF-7 gibt es in `Eudora71/` nirgends; der rohe Name geht aus der `LIST`-Antwort in `ImapMailbox::… |
| **[E-71](Intern/BEFUNDE.md#e-71)** | der Filterbericht ist nach einem Filterlauf leer | 22.10.2026 an 7.2.0.121 | nicht die Behebung, sondern Gregors Freigabe — er hat ihn ausdrücklich auf die nächste Fassung geschoben. Die Messung steht fertig da: in `CFilter… |
| **[E-47](Intern/BEFUNDE.md#e-47)** | beim Öffnen der Kurznamen-/Verzeichnisdienst-Leiste kommt der Fehlerdialog *„Directory … | 22.10.2026 an 7.2.0.121 | eine Entscheidung, keine Behebung — `MFC71.DLL` und `MSVCP71.dll` hat Microsoft nie als Redistributable veröffentlicht, `RegisterCOMObjects()` sche… |
| **[E-39](Intern/BEFUNDE.md#e-39)** | wird die aktuell benutzte Persönlichkeit gelöscht, kann ihr INI-Abschnitt teilweise wied… | 22.10.2026 an 7.2.0.121 | die Bestätigung am laufenden Programm — belegt ist nur der Quelltext (`persona.cpp:565-566` und `:179-198`, `rs.cpp:1237-1250`). Zu fahren wäre: d… |
| **[E-14](Intern/BEFUNDE.md#e-14)** | Zusicherung beim Start: der X1-Suchindex wird neu angelegt (SearchManager::Info::InitX1) | **nie gemessen** | die eine Messung, die entscheidet — Eudora zweimal hintereinander auf **demselben gewachsenen** Mailverzeichnis starten und beim zweiten Mal auf `Se… |
| **[S-6](Intern/BEFUNDE.md#s-6)** | Bereiche überlagern sich | 22.10.2026 an 7.2.0.121 | das Nachstellen — ob sich die Bereiche heute überhaupt noch überlagern, ist seit dem 30.08.2026 **nie geprüft** worden. Die beiden damals genannt… |
| **[NP2-3](Intern/BEFUNDE.md#np2-3)** | BitBltTransparent meldet Erfolg, ohne gezeichnet zu haben | **nie gemessen** | die Behebung selbst — `CPaletteDC::BitBltTransparent` (`OTShim_Werkzeugleiste.cpp:239`) meldet unverändert Erfolg, ohne gezeichnet zu haben. Seit d… |
| **[NP3-3](Intern/BEFUNDE.md#np3-3)** | Kommentar zu CreateFromBitmap zählt die Aufrufstellen falsch | 22.10.2026 an 7.2.0.121 | eine Zeile Text — der Kommentar in `OTShim_Bild.h:326-330` sagt weiterhin *„an drei von fünf Stellen"* und zählt die Aufrufstellen damit falsch.… |
| **[S-3](Intern/BEFUNDE.md#s-3)** | erster Lauf durch Gregor: drei Beobachtungen | 22.10.2026 an 7.2.0.121 | allein S-3c (die beiden Laufzeitbibliotheken) — `MFC71.DLL` und `MSVCP71.dll` fehlen dauerhaft, damit fallen Adressbuch (`EudoraBk.dll`), LDAP (`Lda… |
| **[NP2-2](Intern/BEFUNDE.md#np2-2)** | SysColorChange() tut nicht, was daneben steht | 22.10.2026 an 7.2.0.121 | nur die Berichtigung des irreführenden Kommentars an `OTShim_Werkzeugleiste.cpp:326-328` (**nicht** an den drei Stellen, die hier bis zum 22.10.2026 … |
| **[NP3-2](Intern/BEFUNDE.md#np3-2)** | OnToolHitTest als int statt INT_PTR — x64-Sperre | 22.10.2026 an 7.2.0.121 | die Umstellung auf `INT_PTR` — `OnToolHitTest` ist an elf Stellen noch `int`: `OTShim_Reiter.cpp:1032`/`.h:570`, `OTShim_Werkzeugleiste.cpp:595`, `P… |
| **[A-1](Intern/BEFUNDE.md#a-1)** | Erscheinungsbild: fünf Punkte umgesetzt | **nie gemessen** | nur `SECDockBar::SetControlBarWidthsInRow` (`OTShim.cpp:2830`) ist ein leerer Rumpf — die prozentualen Zeilenbreiten. **Niemand ruft sie auf**, die … |
| **[AN-1](Intern/BEFUNDE.md#an-1)** | Anhänge: lange Dateinamen abgeschnitten, Endung fehlt — elf Ursachen (Teile B5.1 bis B5… | **nie gemessen** | allein **B5.7** — der IMAP-Weg ruft `SetExtension` nicht auf. Zehn der elf Teile sind behoben; im Test fiel es nicht auf, weil alle drei Namen schon… |
| **[NP3-1](Intern/BEFUNDE.md#np3-1)** | ZeigeInhaltsfenster läuft, bevor Eudora das Fenster umhängt | 22.10.2026 an 7.2.0.121 | die Umstellung der Reihenfolge — `ZeigeInhaltsfenster` (`OTShim_Reiter.cpp:1500-1503`) läuft weiterhin, bevor Eudora das Fenster umhängt (`Create`… |
| **[P-1](Intern/BEFUNDE.md#p-1)** | der POP-Abrufpfad gegengelesen, elf Altlasten benannt | 22.10.2026 an 7.2.0.121 | die neun Altlasten **P-1.5b bis P-1.5j** — wortgleich wie in `567a5d8`, keine davon angefasst. Nach Aufwand-Nutzen zuerst die beiden Einzeiler: **P-… |
| **[R-1](Intern/BEFUNDE.md#r-1)** | die Fehlerklasse hinter [E-11](Intern/BEFUNDE.md#e-11) ausgezählt | 22.10.2026 an 7.2.0.121 | die 21 Änderungen selbst — 137 Vorkommen, 116 richtig gepaart, **21** zu ändern (16 `falsch`, 4 `lockbuffer`, 1 `danach`), seit dem 07.09.2026 kei… |

<!-- offene-befunde: Ende -->

## Erreicht

| | |
|---|---|
| **Kriterien 0, 1 und 3** aus [ZIEL.md](ZIEL.md) | erfüllt: Bau aus frischem Klon, Start ohne Nachinstallieren auf einem Rechner ohne Visual Studio, Mailabruf über POP3/TLS 1.3 auf Port 995 |
| **Kriterium 2** (Darstellung) | *fast* — offen ist die Meldung „Encountered an improper argument" beim **Anzeigen** mancher Nachrichten. **Neu zu messen** seit 7.2.0.24: sie stammt aus derselben Quelle wie [E-34](Intern/BEFUNDE.md#e-34)/[E-43](Intern/BEFUNDE.md#e-43) |
| **Kriterium 4** (keine Abstürze) | *fast* — Strg-N stürzt nicht mehr ab (fünfmal nachgemessen), das Beenden läuft sauber (Kriterium 7), und die Fehlerklasse hinter [E-34](Intern/BEFUNDE.md#e-34)/[E-37](Intern/BEFUNDE.md#e-37)/[E-43](Intern/BEFUNDE.md#e-43) ist seit 7.2.0.24 an der Wurzel weg |
| **Kriterien 5 und 6** (Mail schreiben, senden, weiterleiten) | **erfüllt** — von Gregor am 07.09.2026 bestätigt: *„mail können jetzt abgeschickt werden."* und *„weiterleitung funktioniert übrigens."*, mit Bildschirmfoto |
| **Kriterium 8** (Fensterliste) | **erfüllt** — von Gregor am 09.09.2026 bestätigt: das Menü *Window* listet sie auf, und die Registerkartenleiste am unteren Rand ist da; der Klick auf eine Karte holt das Fenster nach vorn, die Beschriftungen stimmen mit dem Menü (**A-3** / [**E-48**](Intern/BEFUNDE.md#e-48)) |
| **Kriterium 7** (Beenden) | **erfüllt** — von Gregor am 08.09.2026 an Paket 1.0.22 bestätigt: *„schließen klappt jetzt."* Alle drei Wege beenden: *File → Exit*, Alt-F4 und das Kreuz ([E-40](Intern/BEFUNDE.md#e-40), [E-41](Intern/BEFUNDE.md#e-41), [E-42](Intern/BEFUNDE.md#e-42), ergänzt um [E-45](Intern/BEFUNDE.md#e-45)) |
| [**A-1**](Intern/BEFUNDE.md#a-1) (Vorgaben für ein neu angelegtes Konto) | **erfüllt** — *„default werte beim neuen persona konto für 'leave message on server' greifen."* |
| **A-2** (*Task Status* und *Task Errors* waagrecht unten) | **erfüllt** — *„leiste unten paßt."* |
| **A-3** (offene Fenster als Registerkarten direkt auswählen) | **erfüllt** — von Gregor am 09.09.2026 bestätigt ([**E-48**](Intern/BEFUNDE.md#e-48), umgesetzt in 7.2.0.25). Damit ist Kriterium 8 ganz erfüllt |
| **A-4** (den linken Bereich breiter ziehen) | **erfüllt — von Gregor an 1.0.84 bestätigt am 13.10.2026** (Testplan Teil A: *„nach neustart immer noch gleiche größe“*; mit ihm [E-50](Intern/BEFUNDE.md#e-50) und [E-52](Intern/BEFUNDE.md#e-52) bis [E-63](Intern/BEFUNDE.md#e-63), die Urteile mit Zitat in BEFUNDE.md). Gebaut als [**E-49**](Intern/BEFUNDE.md#e-49) in 7.2.0.26, in 7.2.0.27 durch [**E-52**](Intern/BEFUNDE.md#e-52) und in 7.2.0.29 durch [**E-54**](Intern/BEFUNDE.md#e-54) (der Ziehrahmen war nach rechts unsichtbar) und [**E-55**](Intern/BEFUNDE.md#e-55) (acht Pixel leerer Streifen unter der Werkzeugleiste) nachgebessert. Bis zum 13.10.2026 war nur die Höhenänderung des unteren Bereichs bestätigt (09.09.2026: *„verschieben rauf / runter — bug gefixt, die anzeige ist korrekt."*) |

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

## 7.2.0.121 — `resolve_URL` schreibt nicht mehr über das Zielfeld hinaus ([E-111](Intern/BEFUNDE.md#e-111))

**Behoben, 246 Tests, 246 bestanden, mit Gegenprobe.** Nicht geschnürt.

Die Längenschranke in `resolve_URL` (`HTMLUtils.cpp`) verglich mit `==` statt
`>=` — **und sie prüft erst nach dem Schreiben.** `output_size` startet bei 1
und zählt je Durchlauf um genau 1 hoch; bei `nMaxLength` 0 oder 1 wurde `==`
deshalb **nie** wahr, und die Schleife schrieb bis zum Ende der **Quelle**
über das Zielfeld hinaus.

Zwei Teile:

* `>=` statt `==` (`HTMLUtils.cpp:107`) — für jedes `nMaxLength >= 2` ändert
  das am Verhalten nichts.
* ein Eingang für die entarteten Größen (`:21-30`), weil die Prüfung hinter
  dem Schreiben steht und das abschließende `*output = 0` sonst bei
  `nMaxLength=1` ein Byte zu weit setzt.

**Gegenprobe gefahren:** mit dem alten `HTMLUtils.cpp` fällt genau der neue
Testfall um — **245 von 246**, die übrigen 245 bleiben grün.

**Ausgelöst gesehen wurde es nie.** Alle heutigen Aufrufer übergeben `sizeof()`
eines großen Feldes (`PGHTMIMP.CPP:2310`, `PgEmbeddedImage.cpp:1415`). Der Test
hält den Fall für den nächsten Aufrufer fest. Gefunden hat ihn der PRÜFER am
18.09.2026 beim Nachrechnen der [E-110](Intern/BEFUNDE.md#e-110)-Spurmarke
([PRUEFER-18](Befunde/PRUEFER-18.md)).

## 7.2.0.120 — die Auswahlbox schrumpft nicht mehr bei jedem Cursor-Schritt ([E-135](Intern/BEFUNDE.md#e-135))

> **Veröffentlicht als [`v1.0.120`](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.120)**
> am 21.10.2026 um **19:07:37 UTC**, Marke `30feeae2`, auf GitHub *Latest*.
> Das Release trägt **drei** Quellstände — 7.2.0.118, 7.2.0.119 und
> 7.2.0.120 —, weil die beiden mittleren gebaut, aber nie eigens
> veröffentlicht wurden. Freigabe von Gregor: *„ich habe ja schon alles
> getestet."* Anhang `Eudora72-1.0.120-release.zip`, 9 381 870 Byte,
> SHA-256 `26fde414…a6a1`. Notizen:
> [Releases/1.0.120/RELEASE-NOTIZEN.md](Releases/1.0.120/RELEASE-NOTIZEN.md).
> *(Nachgetragen am 21.10.2026 abends — dieser Abschnitt sagte bis dahin
> nichts über das Release, während der Abschnitt 7.2.0.117 es tut;
> [L-49.15](Befunde/LEKTOR-49.md#l-49.15).)*

Gregor am 21.10.2026 an 1.0.119, während er sein Ziel für diesen Weg
beschrieb: *„das Fenster wird bei jeder Änderung (z.B. nächster Eintrag)
kleiner!"*

### Innenmaß gelesen, Außenmaß gesetzt

`AutoCompleterListBox::ReCalcACListBoxPos` (`AutoCompleteSearcher.cpp:530`)
holte sich mit `GetClientRect` die **Innen**maße der Liste und setzte daraus
mit `MoveWindow` die **Außen**maße — plus sechs Pixel. Der Kommentar des
ursprünglichen Verfassers steht daneben:

> *„Why 6? I haven't a clue. I imagine it's because the border around the
> window is 3 pixels? I dunno."*

**Gemessen ist der Rand 14 Pixel.** Also verlor das Fenster bei jedem Aufruf
acht Pixel, und der nächste Aufruf las den schon geschrumpften Innenraum.
Gerufen wird zweimal je Cursor-Schritt — aus `OnArrowKey` und aus dem
`SetControlToItem`, das `OnArrowKey` selbst auslöst:

| Schritt | 0 | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|---|
| Fenster | 100 × 62 | 84 × 46 | 68 × 30 | 52 × 14 | 36 × 14 | 20 × 14 |

Nach fünf Schritten war von der Liste nichts mehr übrig.

**Jetzt** wird Außenmaß gegen Außenmaß gerechnet — genau wie in `InitList`,
das es von Anfang an so machte und deshalb nie geschrumpft ist. Die Größe
setzt `InitList`; diese Funktion heißt `…Pos` und verschiebt nur noch.

### Gemessen

Am laufenden Programm, über `tools/testlauf.ps1` mit dem neuen
`tools/messen-e135.ps1`, Prüfstand mit fünf Kurznamen gleichen Anfangs, je
sechs Cursor-Schritte, zwei nachweislich verschiedene EXE (MD5 `b50d9136`
gegen `1158d27c`):

| | vorher | nachher |
|---|---|---|
| Schritt 0 | 100 × 62 | 108 × **70** |
| Schritt 3 | 52 × 14 | 108 × **70** |
| Schritt 5 | 20 × 14 | 108 × **70** |

**243 Tests, 243 bestanden.** Die Suite deckt diesen Weg nicht ab.

### Eine Vorhersage, die sich nicht bestätigt hat

[PRÜFER-43 K9](Befunde/PRUEFER-43.md#k9) sagte für `OnRightButtonDown`
(`nicktree.cpp:2941`) denselben Fehlerfall voraus wie bei
[E-134](Intern/BEFUNDE.md#e-134): der Rechtsklick wähle nicht aus, das Kontextmenü
bleibe ausgegraut. **Am laufenden Programm nicht nachstellbar** — fünf
Klickhöhen je Fassung (`tools/messen-k9.ps1`), beide melden danach genau
**ein** ausgewähltes Kind. Beim Klick auf ein *anderes* Element wandert die
Karette, und dann setzt `SelectItem()` `TVIS_SELECTED` sehr wohl. Die Zeile
ist trotzdem eingebaut — als **Sicherung**, nicht als gemessene Behebung, und
genau so steht es im Befund.

## 7.2.0.119 — der Kurzname eines neuen Adressbucheintrags kommt an ([E-134](Intern/BEFUNDE.md#e-134))

Gregor am 21.10.2026, mit Bildschirmfoto: *„adressbuch übernimmt nichts."* Im
Formular steht `hans`, im Baum weiter `Untitled`. Und dazu: *„es war 1x nicht
richtig, 1x richtig gespeichert, jetzt wieder falsch."*

### Eine Zeile, die auswählt, ohne auszuwählen

`CTreeCtrl::SelectItem()` ist `TVM_SELECTITEM`/`TVGN_CARET`, und diese
Botschaft tut **nichts**, wenn das Element schon die Karette trägt — auch dann
nicht, wenn ein `DoDeselectAll()` davor `TVIS_SELECTED` gerade gelöscht hat.
Genau dieses Bit liest `IsItemSelected()`, und darauf steht
`GetSelectedNicknames()`. Zwei Stellen verlassen sich auf die Annahme,
`SelectItem()` wähle aus:

* `AddNewNickname` (`nicktree.cpp:508`) — der frisch angelegte Eintrag.
* `NicknameWasChanged` (`nicktree.cpp:881`) — **läuft bei jedem Tastendruck**
  im Namensfeld, die Karette steht dort also längst auf dem Eintrag, und die
  Funktion ruft erst `DoDeselectAll()` und dann das wirkungslose
  `SelectItem()`.

Also liefert `GetSelectedNicknames()` null Einträge, `nickname` wird nie
geholt, und das Eingetippte wird verworfen. Ein Zwischenstand, der nur die
erste Stelle behob, brachte genau **einen** Buchstaben auf die Platte —
`alias h` statt `alias hans` — weil die zweite die Auswahl beim ersten
Umbenennen gleich wieder abräumte.

**Gemessen** (21.10.2026, eigener Baum mit denselben Stilbits wie
`IDC_NICKNAME_LEFT_LIST`, je einmal gegen comctl32 **5.82** und **6.16** —
beide verhalten sich **gleich**):

| Lage | `TVIS_SELECTED` danach |
| --- | --- |
| Karette steht woanders, dann `SelectItem(X)` | **1** (und das Bit der alten Karette wird gelöscht) |
| Bit von `X` gelöscht, Karette steht schon auf `X`, dann `SelectItem(X)` | **0** |

Die Fassung der Common Controls ist es also **nicht**; es ist die Lage der
Karette. Für `NicknameWasChanged` ist das der belegte Fall. Für
`AddNewNickname` ist es eine **Sicherung**: dort steht die Karette in aller
Regel noch nicht auf dem neuen Eintrag, und derselbe Ablauf mit einem frisch
eingefügten, sortierten Kind setzt das Bit in der Messung sehr wohl.

**Warum es manchmal doch ging:** wer vorher einen vorhandenen Eintrag anklickt,
bekommt seine Auswahl über `OnLButtonDown` → `DoSelectItem`, und die hält.

**Jetzt** steht hinter beiden `SelectItem()` ein `DoSelectItem(…, TRUE)` — der
Zustand wird gesetzt, statt angenommen.

### Der Quelltext ist original. Das Verhalten nicht.

`nickview.cpp`, `nickview.h`, `nicktree.cpp`, `nicktree.h` und
`Eudora.manifest` sind seit dem initial commit **von uns nie angefasst**
worden; `git log` und `git diff` dagegen sind leer. QUALCOMMs Entwurf wählt den
neuen Eintrag sehr wohl aus — und es deckt sich mit Gregors Hinweis, dass es in
Hermes funktioniert hat. **Was dabei offen bleibt:** die Messung oben zeigt,
dass `SelectItem()` sich in comctl32 5.82 und 6.16 **gleich** verhält. Die
Fassung der Common Controls scheidet damit als Erklärung aus. Offen ist, warum
die Karette in diesem Bau schon auf dem Eintrag steht, wo sie es früher nicht
tat. Die Behebung hängt nicht daran — sie setzt den Zustand ausdrücklich,
statt ihn anzunehmen.

### Und ein stummes `return`

In `NicknameEditChanged` (`nickview.cpp:622`) stand

```c
if (strEditText != nickname->GetName())
{
    if (!CNickname::IsValidNickName(strEditText)) { MessageBeep(0); ASSERT(0); }
    return;
}
```

Das `return` griff **immer**, sobald sich der Name geändert hatte — nicht nur
im Fehlerfall. Im Freigabebau ist `ASSERT(0)` nichts, der Abbruch also stumm;
dieselbe Klasse wie [E-83](Intern/BEFUNDE.md#e-83). Dass es trotzdem meistens ging,
lag allein daran, dass jeder Tastendruck den Namen schon mitgeführt hatte.
Jetzt wird beim **Fokusverlust** die Eingabe übernommen, beim Fokusgewinn
bleibt es beim alten Verhalten (dort kann das Feld noch den Text des vorher
gewählten Eintrags tragen), und der Prüfmodus wird auf jedem Ausgang
zurückgesetzt.

### Gemessen

Am laufenden Programm, je drei Läufe mit frischem Prüfstand, Prüfgröße ist der
Inhalt von `Mailverzeichnis\NNdbase.txt` nach *New* → `hans` eintippen →
Fokus weg → beenden:

| Fassung | Ergebnis |
|---|---|
| ausgeliefert **1.0.118** | 3 × `alias Untitled` |
| **diese Fassung** | 3 × `alias hans` |

Dazu im Code abgelesen: *„nach SelectItem allein: NICHT ausgewaehlt"*,
*„nach DoSelectItem: ausgewaehlt"*, und `Auswahl im Baum` von `(0)` auf `(1)`.

**243 Tests, 243 bestanden** — die Suite deckt diesen Weg allerdings **nicht**
ab; der Beleg ist die Messung am laufenden Programm.

## 7.2.0.118 — eine fehlgeschlagene Rückfrage übernahm das fremde Verzeichnis ([E-132](Intern/BEFUNDE.md#e-132))

Vier Behebungen aus [PRÜFER-42](Befunde/PRUEFER-42.md), von ihm selbst
eingebaut. Sein Urteil zu [v1.0.117](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.117)
war *„JA, geht so raus"* — diese vier hängen nicht daran, aber zwei davon
gehören nicht länger offen gelassen.

### Null ist keine Antwort

`::MessageBox` gibt **0** zurück, wenn das Fenster nicht erzeugt werden kann —
kein Speicher, keine Fensterstation, ein Dienstkontext. Null ist weder
`IDCANCEL` noch `IDNO`. Die Abfrage lautete `if (nWahl == IDNO) … else …`,
also fiel die Null in den **Ja**-Zweig: Eudora übernahm das fremde
Verzeichnis und schrieb ins Protokoll *„fremdes bewusst uebernommen"*.
**Bewusst war daran nichts.** Jetzt heißt es `if (nWahl != IDYES)` — alles,
was nicht ausdrücklich *Ja* ist, wird wie *Nein* behandelt.

### Ein gemerktes „Ja" sperrte unsichtbar ein

Auf die Frage *„kann ein gemerktes Ja jemanden dauerhaft einsperren, ohne dass
er merkt warum?"* lautete die Antwort: **ja**. Ab dem zweiten Start kam kein
Dialog mehr, ohne das Protokoll-Bit stand keine Zeile da, und der Über-Dialog
erwähnte den Merker nicht. Der Dialogtext nennt zwar die Lösung — aber er wird
genau einmal gezeigt, nämlich in dem Augenblick, in dem der Anwender *Ja*
sagt.

**Jetzt steht die gemerkte Antwort in *Mail folder from:***, zusammen mit der
Zeile aus der `DEudora.ini`, die sie löscht. Für den Melder aus
[Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102) ist das
der heikle Punkt — er ist genau der Mensch, der den fremden Ordner schon hat.

### Zwei kleinere

- Ab etwa 243 Zeichen Programmpfad schnitt `_tcsncpy` das **schließende**
  Anführungszeichen ab. Halb geklammert ist schlechter als gar nicht
  geklammert — der Startfehler aus 7.2.0.116 wäre zurückgewesen. Jetzt wird
  auf die Kurzform ausgewichen, wenn die Klammerung nicht in den Puffer passt.
- Zwei Grenzfälle in `TestE132.cpp` nachgetragen: Kandidat **ohne**,
  Programmverzeichnis **mit** abschließendem Rückstrich — genau die Form, für
  die die Grenzprüfung geschrieben wurde, und sie stand in keinem Test.

**243 Tests, 243 bestanden.** Gegenprobe von PRÜFER gefahren: die neue Prüfung
umgedreht → `[FEHL]`, 242 von 243; zurück → 243 von 243.

## 7.2.0.117 — eine kopierte Sicherung wird nicht mehr stillschweigend übernommen ([E-132](Intern/BEFUNDE.md#e-132))

Zwei Funde aus [PRÜFER-41](Befunde/PRUEFER-41.md), beide an Stellen, die erst
gestern und heute entstanden sind.

### Von Gregor freigegeben

**Am 21.10.2026 zur Veröffentlichung freigegeben:** *„ja, release 1.0.117 auf
github"*.

Seine Begründung, warum er diese Fassung nicht noch einmal eigens testet:
*„wenn es identisch zu 0.116 ist, muß ich ja nichts testen, das hast du
bereits gemacht."* **Das stimmte in dem Augenblick nicht** — zu dem Zeitpunkt
war nur gebaut und die Testsammlung gefahren. Die beiden Behebungen sind
**danach** am laufenden Programm gemessen worden, rot und grün, an einem
fremden Verzeichnis ohne `Eudora.ini`; erst damit trägt sein Satz.

**Bestätigt hat er 1.0.116** (*„2x nacheinander starten verhält sich jetzt
korrekt"*), und 1.0.117 unterscheidet sich davon nur durch die beiden oben
beschriebenen Behebungen.

**Nachgerechnet vor der Veröffentlichung:** [PRÜFER-42](Befunde/PRUEFER-42.md)
— acht Funde, keiner hält das Paket auf, Urteil *„JA — v1.0.117 geht so
raus"*. [LEKTOR-46](Befunde/LEKTOR-46.md) — sieben Funde in den Papieren, alle
berichtigt, Urteil *„JA"*. Der schwerste war meiner: die Prüfsumme des
ausgelieferten ZIPs stand in den Release-Notizen eines **anderen** Pakets.

### Gefragt wurde nur, wenn im fremden Verzeichnis eine `Eudora.ini` lag

Das ist zu eng. Sagt der Anwender *Ja*, legt Eudora in diesem Verzeichnis
`Attach\`, `Embedded\`, Postfächer, `eudora.log` und beim Beenden eine frische
`Eudora.ini` an. **Ein fremdes Datenverzeichnis ohne INI wurde deshalb
ungefragt in Besitz genommen** — eine kopierte Sicherung zum Beispiel, oder
eine Installation, deren INI woanders liegt.

Gregors Anforderung vom 20.10.2026 lautet: *„in beiden fällen sollte die alte
version von eudora weiterhin funktionieren und keinen schaden bekommen!"* Eine
Sicherung ist eine vorhandene Installation.

**Jetzt genügt irgendeine Spur einer Einrichtung** — `Eudora.ini`, `In.mbx`,
`Attach\` oder `Embedded\`.

Dazu ein zweiter Punkt derselben Stelle: geprüft wurde die Existenz von
`szIni`, entschieden und benutzt wird `szVerzeichnis`. Die Registry nennt
beide Pfade **unabhängig** voneinander; lag die INI in einem anderen Ordner,
beantwortete die Prüfung eine Frage über ein Verzeichnis, über das gar nicht
entschieden wurde. Nachgesehen wird jetzt dort, wo auch entschieden wird.

### *„Mail folder from"* im Über-Dialog log auf vier Wegen

Die Zeile ist seit 7.2.0.114 da und genau für den Fall gedacht, in dem jemand
einen Fehler meldet. **Eine Angabe, die dann falsch ist, ist schlimmer als
keine** — man glaubt ihr.

| Weg | was dastand | was stimmte |
|---|---|---|
| `UseAppData=1` in der `DEudora.ini` | *„nichts in Registry oder DEudora.ini"* | genau dieser Schlüssel hat den Weg erzwungen |
| Application Data nicht erreichbar | *„Application Data"* | das Programmverzeichnis |
| **`Eudora.ini` neben der EXE** — der häufigste Fall überhaupt | *„(unbekannt)"* | das Programmverzeichnis |
| ein gescheiterter Versuch davor | die Herkunft des **vorigen** Versuchs | keine |

Alle vier berichtigt. Die Entscheidungsfunktion selbst bleibt unverändert und
damit frei von Windows-Aufrufen — nur der Aufrufer sieht genauer hin, damit
der Prüfstand sie weiter fahren kann.

**243 Tests, 243 bestanden.**

### Wie diese Fassung zu ihrer Nummer kam

**Berichtigt am 21.10.2026 ([LEKTOR-46](Befunde/LEKTOR-46.md#l-46.2)).** Hier
stand ein Abschnitt *„Zwei Bauten unter demselben Namen"* mit dem Schluss
*„Also 1.0.116"* und einer Tabelle aus einem ersten und einem zweiten Bau
**unter derselben Nummer**. Er ist gegenstandslos: diese Fassung heißt
**1.0.117**, so steht sie in `VERSION` und in `Eudora71/Version.h`
(`7.2.0.117`), und der Abschnitt stand unter der Überschrift *7.2.0.117* und
widersprach ihr im selben Atemzug.

**Was wirklich geschehen ist.** Ich hatte 1.0.117 vorgeschlagen, weil 1.0.116
schon bei Gregor lag und die beiden Behebungen nicht enthielt. Er sagte
zweimal 1.0.116 — und meinte damit das **GitHub-Release**, nicht ein weiteres
Paket. Ich hatte den Bau bis dahin schon auf 1.0.116 zurückgedreht. Seine
Entscheidung danach: *„sonst müssen wir tatsächlich die versionsnummer
hochzählen"* und *„release 1.0.117 auf github"*.

**Es gibt also zwei Pakete nebeneinander, mit zwei Nummern**, und das ist der
Zustand, den [version-eindeutig-machen](Arbeitsweise/version-eindeutig-machen.md)
verlangt:

| Paket | `Eudora.exe` | Inhalt | wo es liegt |
|---|---|---|---|
| **1.0.116**, 21.10.2026 vormittags | SHA-256 `1454F544…C665E2E6` | Rückfrage auf allen Startwegen, Merker | bei Gregor, von ihm getestet; **nicht veröffentlicht** |
| **1.0.117**, 21.10.2026 mittags | ZIP-SHA-256 `335751a9…7eeb1a1` | **zusätzlich**: kopierte Sicherung ohne INI, und *„Mail folder from"* | bei Gregor; **die Fassung, die am 21.10.2026 um 07:56:56 UTC als `v1.0.117` veröffentlicht wurde** |

## 7.2.0.116 — E-132: die Rückfrage greift jetzt auf allen Startwegen, und Eudora merkt sich die Antwort

Diese Fassung enthält, was in 1.0.115 noch fehlte: die beiden Funde aus
[PRÜFER-41](Befunde/PRUEFER-41.md) und das Merken der Antwort.

### Die Rückfrage gab es nur auf einem von drei Startwegen (PRÜFER-41 K1)

`StartEudoraWithDefaultLocation` wird an drei Stellen gerufen. `ExecutableDir`
wird im ganzen Programm aber nur an **einer** Stelle gesetzt — in `GetDirs`
(`fileutil.cpp:436`) —, und die lief bei zwei der drei Aufrufe noch gar nicht.
Dann ist `ExecutableDir` leer, `E132IstFremdesVerzeichnis` steigt mit *nicht
fremd* aus, und im Protokoll steht

```
E-132 Startverzeichnis: … eigenes="" fremd=0
```

— eine Zeile, die wie eine **Entwarnung** aussieht und keine ist. Betroffen
waren `mailto:`-Verweise, Postfachdateien (`.mbx`), Briefpapier (`.sta`), jeder
per Ziehen übergebene Anhang — und, weil `GetCommandType` alles nicht Erkannte
als Anhang behandelt (`fileutil.cpp:585`), auch jeder Start mit einem
Mailverzeichnis, das es noch nicht gibt. **Jetzt wird `ExecutableDir` notfalls
aus `GetModuleFileName` gefüllt.**

### Mit einem Leerzeichen im Programmpfad startete Eudora nach *Nein* gar nicht mehr (PRÜFER-41 K2)

Und *Nein* ist die **Vorgabe**. Der Zweig legte einen ungeklammerten langen
Pfad in `buf`; `GetDirs` liest `buf` als Befehlszeile und trennt am ersten
Leerzeichen (`fileutil.cpp:445`). Aus `C:\Program Files\Eudora72\Mailverzeichnis`
wurde das Verzeichnis `C:\Program`, `CheckMailDirectory` scheiterte, und
`InitInstance` stieg mit einer zweiten Fehlermeldung aus: **zwei Meldungen,
kein Eudora.** QUALCOMM war dem anderswo mit `GetShortPathName` ausgewichen —
unser Zweig war der erste, der dort einen langen Pfad hineinlegte. **Jetzt
wird geklammert**; eine vollständig geklammerte Zeichenkette nimmt `GetDirs`
als **einen** Pfad.

### Eudora merkt sich die Antwort

Auf Gregors Ansage vom 21.10.2026 (*„ja, merken"*), nachdem er gemessen hatte:
zweimal 1.0.115 hintereinander fragt nicht — aber wer dazwischen eine andere
Fassung startet, bekommt die Frage bei jedem Wechsel.

Der Merker steht in der **`DEudora.ini` neben der EXE**, nicht in der
`Eudora.ini`: an dieser Stelle im Start ist das Mailverzeichnis noch gar nicht
bekannt. Zwei Schlüssel, damit *Ja* und *Nein* unterscheidbar bleiben:

```ini
[Settings]
E132Abgelehnt=C:\Pfad\zum\fremden\Mailverzeichnis
E132Angenommen=C:\Pfad\zum\fremden\Mailverzeichnis
```

*Abbrechen* wird **nicht** gemerkt — wer abbricht, hat sich nicht entschieden.
Gibt es keine `DEudora.ini`, wird nichts gemerkt und jedes Mal gefragt; das ist
der sichere Ausgang, nicht der bequeme. **Wie man den Merker wieder loswird,
steht im Dialog selbst** — sonst wäre er eine Falle: wer einmal *Ja* gesagt
hat, würde nie wieder gefragt und wüsste nicht, warum.

### Dazu

*Copy info* im Über-Dialog meldete **„Copied" auch dann, wenn nichts in der
Zwischenablage stand** — `EmptyClipboard()` war da schon gelaufen, der
vorherige Inhalt des Anwenders also weg. Meldet jetzt *„Copy failed"*
(PRÜFER-41 K7).

**243 Tests, 243 bestanden.**

### Gemessen, an einem Prüfstand, der nicht bequemer ist als die Wirklichkeit

`C:\Temp\Eudora Pruefstand 116` — Kurzform `C:\Temp\EUDORA~1`, **mit
Leerzeichen im Pfad**, Aufbau wie in unseren Paketen (`Eudora.ini` in
`Mailverzeichnis\`, nicht neben der EXE):

```
E-132 Startverzeichnis: gefunden="C:\Temp\E131\Mailverzeichnis" … fremd=1
E-132 Startverzeichnis: gemerkte Antwort Nein fuer "C:\Temp\E131\Mailverzeichnis"
E-132 Startverzeichnis: eigenes gewaehlt="…\Mailverzeichnis"
```

Nach *Nein* läuft Eudora **weiter** (K2), der Pfad steht ausgeschrieben da,
der zweite Start fragt nicht mehr, und die fremde `Eudora.ini` bleibt
SHA-256-gleich.

**Ein Zwischenergebnis war kein Beweis.** Mein erster zweiter Lauf meldete
*keine Rückfrage* — im Protokoll stand aber **keine einzige** E-132-Zeile.
Beim ersten Lauf war das Datenverzeichnis das Programmverzeichnis geworden,
danach lag eine `Eudora.ini` neben der EXE, und dann wird der ganze
Registry-Weg übersprungen. Erst nach dem Umbau auf den Paketaufbau war es eine
Messung.

## 7.2.0.115 — E-132: Eudora hielt sein eigenes Mailverzeichnis für fremd

**Gefunden von Gregor am 21.10.2026, zwei Minuten nach dem ersten Start von
1.0.114** — und zweimal gemeldet, erst als Schönheitsfehler, dann als
Fehlverhalten:

> *„können wir den pfad komplett angeben?"* — im Fenster stand
> `C:\Users\Gregor\EUDORA~1.113\MAILVE~1`.
>
> *„eudora 0.114 2x gestartet, jedes mal werde ich nach dem verzeichnis
> gefragt, obwohl schon einmal ein eigenes für 0.114 angelegt wurde. ist es
> so gewünscht?"*

**Nein, war es nicht.** Eudora schreibt in
`HKCU\Software\Qualcomm\Eudora\CommandLine\Current` die **8.3-Kurzform**
(`GetShortPathName`), vergleicht sie in [E-132](Intern/BEFUNDE.md#e-132) aber mit
`ExecutableDir`, und das kommt aus `GetModuleFileName` und ist **lang**:

```
Kandidat (aus der Registry): C:\Users\Gregor\EUDORA~1.114\MAILVE~1
Eigenes  (ExecutableDir)   : C:\Users\Gregor\Eudora72-1.0.114-release\
-> Praefixvergleich schlaegt fehl -> fremd=1
```

Die beiden stimmen nie überein. Also fragte Eudora bei **jedem** Doppelklick
nach seinem eigenen, gerade selbst angelegten Verzeichnis — und eine Meldung,
die immer kommt, liest nach drei Tagen niemand mehr. Betroffen ist jeder
Installationspfad, der lang genug für einen 8.3-Alias ist, also praktisch
jeder.

**Behoben:** `E132LangerPfad` löst **beide** Seiten mit `GetLongPathName` auf,
bevor verglichen wird — im **Aufrufer**, damit `E132IstFremdesVerzeichnis`
ohne Win32 bleibt und der Prüfstand sie weiter fahren kann. Scheitert die
Auflösung (das Verzeichnis gibt es nicht mehr), bleibt der Kurzname stehen;
er ist immer noch besser als ein leerer Pfad. Der Dialog zeigt damit auch den
**ganzen** Pfad, nicht `EUDORA~1.113` — das war Gregors erste Frage.

**Beim Aufräumen gleich mitgefunden, der umgekehrte Falschalarm:**
`C:\Eudora2` fängt mit `C:\Eudora` an. Der Präfixvergleich hielt das zweite
für ein Unterverzeichnis des ersten und hätte bei einem echten
Nachbarverzeichnis **keine** Rückfrage gestellt — genau dem Fall, vor dem sie
schützen soll. Jetzt muss hinter dem Präfix auch wirklich die Grenze sein
(`\`, `/` oder Ende), und ein abschließender Rückstrich zählt nicht zum Namen.

**243 Tests, 243 bestanden** (zwei neue Fälle).

### Warum der Prüfstand das nicht gefunden hat

Mein Prüfpaket lag in `C:\Temp\E132`. Dieser Pfad ist **zu kurz für einen
8.3-Alias** — Windows legt dort gar keine Kurzform an, und deshalb stimmten
Registry und `ExecutableDir` zufällig überein. Alle drei Messungen am
laufenden Programm (*Nein*, *Ja*, *Abbrechen*) liefen durch, die Gegenprobe
meldete korrekt `fremd=0`, und der Fehler war trotzdem da. **Ein Prüfstand,
der es sich bequem macht, misst den Fehler weg.** Der Testfall hält beides
fest: mit aufgelösten Pfaden das richtige Ergebnis, mit der Kurzform das
falsche.

## 7.2.0.114 — E-132: Eudora fragt, bevor es das Mailverzeichnis einer fremden Installation übernimmt

**Der zweite Teil des Fehlerberichts von außen.** Der Melder aus
[Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102) schrieb,
die neue Installation habe *über Registry-Abfragen* die vorhandene in einem
anderen Ordner gefunden und deren INI verändert. [E-131](Intern/BEFUNDE.md#e-131) war
die Folge; **[E-132](Intern/BEFUNDE.md#e-132)** ist der Weg dorthin.

**Der Weg.** Ist die Befehlszeile leer **und** liegt keine `Eudora.ini` neben
der EXE — beides trifft auf unser Paket zu, denn unsere INI liegt in
`Mailverzeichnis\` —, dann liest Eudora
`HKEY_CURRENT_USER\Software\Qualcomm\Eudora\CommandLine\Current` und benutzt
den Datenordner, mit dem zuletzt eine **andere** Eudora gestartet wurde. Wer
`Eudora.exe` doppelklickt statt `Eudora starten.cmd` zu benutzen, landet
deshalb im fremden Verzeichnis und schreibt hinein.

**Behoben:** vor der Übernahme kommt eine Rückfrage mit drei Wegen — *Ja*
(fremdes Verzeichnis trotzdem benutzen), *Nein* (eigenes neben dem Programm
anlegen), *Abbrechen*. **Vorgabe ist „Nein"**, damit ein unbedachtes Enter
nichts beschädigt. Entschieden wird in `E132IstFremdesVerzeichnis` — ohne
Fenster und ohne Registry, damit der Prüfstand sie fahren kann.

**Zwei Schichten lagen darunter, und beide hat erst die Messung gezeigt.**

1. **Die Registry speichert keinen Pfad, sondern den ganzen Aufruf.** Nach dem
   Abschneiden des Programmnamens stehen in `buf` **zwei** Pfade, durch ein
   Leerzeichen getrennt; `GetDirs()` trennt sie erst später
   (`fileutil.cpp:432`). Die erste Fassung hängte `\Eudora.ini` an diese
   **Gesamtzeichenkette** an — eine Datei, die es nie gibt. Die Rückfrage war
   eingebaut und kam **nie**. Dafür gibt es jetzt `E132AufrufZerlegen` mit
   derselben Trennregel wie `GetDirs`.
2. **Die Spurmarke konnte an dieser Stelle gar nicht geschrieben werden.**
   `StartEudoraWithDefaultLocation` läuft, **bevor** `QCLogFileMT::InitDebug`
   das Protokoll öffnet — und das muss so sein, denn das Protokoll liegt im
   Mailverzeichnis, das dort erst gesucht wird. `PutDebugLog` kehrt ohne
   `s_pLogFile` stumm zurück (`QCUtils/src/debug.cpp:141`). Die Zeilen werden
   jetzt gemerkt und in `InitInstance` direkt nach `InitDebug` ausgegeben —
   **in beiden Ausgängen**, auch wenn nichts Fremdes gefunden wurde.

**Gemessen am 20.10.2026**, Paket in `C:\Temp\E132` gegen die fremde
Installation in `C:\Temp\E131`; die Antwort kam jeweils als `WM_COMMAND` an ein
gemessenes Fensterhandle, nicht als Tastendruck:

```
Nein       E-132 Startverzeichnis: ... fremd=1
           E-132 Startverzeichnis: eigenes gewaehlt="C:\Temp\E132\Mailverzeichnis"
           fremde Eudora.ini SHA256 unveraendert

Ja         E-132 Startverzeichnis: fremdes bewusst uebernommen
           Protokoll landet im FREMDEN Verzeichnis
           dessen Eudora.ini aendert sich (LastKnownCrashInfo=0 -> =1)

Abbrechen  Programm endet, nichts angefasst

Gegenprobe zeigt die Registry auf das eigene Paket: fremd=0, keine Frage
```

Der Fall *Ja* ist **genau der Schaden aus Issue #102** — nach fünfzehn
Sekunden Laufzeit. Die Rückfrage ist das einzige, was dazwischensteht.

**241 Tests, 241 bestanden** (sieben zu [E-132](Intern/BEFUNDE.md#e-132), davon zwei neu: die zerlegte
Registryzeile und der gemeldete Fall von Ende zu Ende).

**Was Gregors Registry-Export eines fremden PC zeigt** (Suche nach „eudora"
auf einem Rechner mit vier Eudora-Installationen): dieselbe Startbefehlszeile
steht **dreifach** — unter `HKCU`, unter `HKEY_CLASSES_ROOT` (die zweite Stufe
im Code) und unter `HKU\<SID>`; `LaunchManager` führt zehn `Path#N`-Werte aus
vier Installationen; sämtliche Dateizuordnungen (`mailto`, `.sta`,
`Eudora.Mailbox`, `App Paths`) zeigen auf die **alte** EXE; `UseAppData` kommt
nicht vor. Einzelheiten in [E-132](Intern/BEFUNDE.md#e-132).

**Nicht getan, bewusst:** wir setzen die Dateizuordnungen **nicht** auf unsere
EXE. Das würde die vorhandene Installation kapern und Gregors Anforderung vom
20.10.2026 verletzen — eine vorhandene Installation nimmt keinen Schaden.

### Der Über-Dialog nennt jetzt die Pfade, nach denen man bei einem Fehler fragt

Auf Gregors Wunsch vom 20.10.2026: *„wir sollten noch das ini verzeichnis hier
nennen. und auch weitere, die für debug zwecke relevant sind"* und *„diese
sollte man kopieren können, um sie z.B. in ein Ticket oder Issue
einzutragen"*.

*Help → About Eudora* zeigt unter *Data* und *Application* vier neue Zeilen:

| Zeile | was sie beantwortet |
|---|---|
| **INI** | **welche** `Eudora.ini` gelesen wird — in unseren Paketen liegt sie in `Mailverzeichnis\`, nicht neben der EXE |
| **Default INI** | die `DEudora.ini` mit `DataFolder` und `UseAppData` |
| **Log** | wohin das Protokoll geht, **und ob es überhaupt etwas enthält** (`LogLevel`, mit dem Hinweis *„keine E-nn-Marken"*, wenn 32768 fehlt) |
| **Mail folder from** | **woher** das Mailverzeichnis stammt: Befehlszeile, Umgebungsvariable, `DEudora.ini`, Registry oder Application Data |

Die letzte Zeile ist die Lehre dieses Tages: Eudora **wusste** die Herkunft
längst — `CheckMailDirectory` bekommt sie als zweiten Parameter —, benutzte sie
aber nur im Fehlerfall und warf sie danach weg. Jetzt wird sie aufgehoben
(`MailDirHerkunft`), und `StartEudoraWithDefaultLocation` trägt die Wahrheit
nach, wo `GetDirs` sonst „command line" schriebe.

Der Knopf **Copy info** legt den ganzen Block als Text auf die Zwischenablage,
fertig zum Einfügen in ein Issue. Genommen wird, was im Dialog **steht** — der
Block kann also nichts behaupten, was der Anwender nicht selbst sieht. Im
Startbild ist der Knopf ausgeblendet. Beschrieben in
[README.md](Doku/ANWENDER.md#was-in-einen-fehlerbericht-gehört--help--about-eudora).

**Offen bleibt** der Leseweg von [E-131](Intern/BEFUNDE.md#e-131), und neu
aufgeschrieben: `SaveBarState` legt die Leistenzustände **zuerst** in der
Registry ab (`HKCU\Software\Qualcomm\Eudora\<INI-Pfad>\ToolBar-*`). Auf jenem
PC liegen diese Schlüssel nur unter **unserem** Pfad, nicht unter denen der
drei Originalinstallationen. Ob `LoadBarState` sie vor der INI liest, ist noch
nicht gemessen.

## 7.2.0.113 — E-131: keine ungültige Fensterposition mehr in der `Eudora.ini`

**Der erste Fehlerbericht von außen, und er saß.** Ein Anwender meldete am
18.10.2026 ([Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102)),
dass seine daneben installierte Hermes 7.1.0.9 nach dem Lauf unserer Fassung
`v1.0.101` nicht mehr startet — `EXCEPTION_ACCESS_VIOLATION` in `MFC71.DLL`,
Ordinal 3952, `ECX=0`. Sein Vergleich beider INIs nannte die Stelle:
`MRUFloatXPos=-2147483648`, also `INT_MIN` statt eines Bildschirmpunkts.

**Nachgestellt am 20.10.2026** in `C:\Temp\E131`: ein **einziges** Starten und
Beenden von 7.2.0.112 genügt. Die INI wuchs von 3249 auf 6480 Byte, 16
Abschnitte kamen dazu, und der Wert stand **dreimal** darin. Es betraf also
nicht nur die eine veröffentlichte Fassung.

**Behoben:** `E131LeistenpositionenBereinigen()` am Ende von
`CMainFrame::SaveBarState` geht die `ToolBar*`-Abschnitte durch und ersetzt
jede unbrauchbare Schwebeposition durch eine, die auf dem Bildschirm liegt.
Entschieden wird in der eigenen, prüfbaren Funktion
`E131PositionIstBrauchbar`. Nach der Behebung:

```
E-131 Leistenposition: abschnitte-mit-eintrag=5 berichtigt=5 bildschirm=0,0,1920x1294 ersatz=40,40
MRUFloatXPos=40        INT_MIN: 0 Treffer
```

**234 Tests, 234 bestanden** (fünf neue). **Der erste Entwurf der Regel war
falsch, und ein Test hat ihn gefangen:** er verlangte 100 Pixel Luft auf allen
vier Seiten, wodurch `y=1200` auf einem 1294 Pixel hohen Schirm als unbrauchbar
galt. Nach links und oben gilt die Luft, nach rechts und unten die
Bildschirmkante. **Die Gegenprobe ist der wichtigere Test:** gewöhnliche
Positionen bleiben unangetastet — sonst wäre aus der Behebung *„jede Position
wird überschrieben"* geworden.

**Offen bleibt der Leseweg:** eine INI, die bereits kaputte Werte trägt, wird
erst beim nächsten Sichern berichtigt.

**Und offen bleibt die Ursache.** [PRÜFER-40](Befunde/PRUEFER-40.md#k1) K1 hat
am 20.10.2026 nachgerechnet: `-2147483648` ist `CW_USEDEFAULT`, ein Wert, den
MFC in `CDockContext::CDockContext` selbst setzt und an seinem einzigen
Leseort wieder abfängt. **Belegt ist, dass wir ihn schreiben — nicht, dass er
den gemeldeten Absturz verursacht hat.** Dieselbe Korrektur steht seit dem
20.10.2026 im [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102).


### Von Gregor bestätigt

**Von Gregor am 20.10.2026 zur Veröffentlichung freigegeben**, mit Begründung:
*„jetzt schon releasen, wie soll er ja an die gefixte version kommen?"* — der
Melder aus [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102) kann
die Behebung nur prüfen, wenn sie veröffentlicht ist.

**Ehrlich dazu, was gemessen ist und was nicht.** Gemessen am Prüfstand: mit
7.2.0.112 schreibt ein einziges Starten und Beenden `MRUFloatXPos=-2147483648`
dreimal in die INI, mit 7.2.0.113 steht dort `MRUFloatXPos=40` und **null**
Treffer für `INT_MIN`; zwei Läufe hintereinander, 234 Tests grün. **Nicht
gemessen:** ob die daneben installierte Hermes 7.1 danach wieder startet — dazu
fehlt uns Hermes. Der Melder ist in #102 ausdrücklich darum gebeten worden.
Ebenfalls unverändert gilt: der Inhalt von 7.2.0.112 ist von Gregor auf beiden
Wegen am laufenden Programm bestätigt (2a mit `laeuft=1` und 6015 ms, 2b mit
`uebertragungen=1` und 4015 ms).

### Dazu: [E-124](Intern/BEFUNDE.md#e-124) fortgeschrieben — die Defender-Schranke prüft zu früh

Gemessen am 20.10.2026: `Eudora.exe` um **13:09:05** gebaut und sofort geprüft
(34 Dateien, 0 Funde), von Defender um **13:17:28** als
`Trojan:Win32/Bearfoos.A!ml` erkannt. **Acht Minuten Abstand**, dasselbe Muster
wie am 16.10. bei 1.0.98. Gregors Entscheidung: keine Wartezeit in die
Auslieferung einbauen, er meldet es. Der Satz in den Release-Notizen sagt
jetzt, dass 0 Funde **kein Freispruch** sind.

## 7.2.0.112 — E-123: der Zähler aus `SameServer::DoWork` ist wieder heraus (PRÜFER-39, N1)

**Neu aufgenommen und weiter OFFEN: [E-131](Intern/BEFUNDE.md#e-131)** — in dieser Fassung ausdruecklich NICHT angefasst.
der **erste Fehlerbericht von außen**
([Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102),
18.10.2026). Nach dem Lauf unserer Fassung `v1.0.101` startet eine daneben
installierte Hermes 7.1.0.9 nicht mehr; in der gemeinsam benutzten `Eudora.ini`
steht `MRUFloatXPos=-2147483648`. Geschrieben wird das von
`SaveBarState(_T("ToolBar"))` (`mainfrm.cpp:1027`) — MFCs eigene Leistenschlüssel
mit einem Wert, der nie gesetzt wurde. **Von uns noch nicht nachgestellt.** Die
Release-Notizen zu 1.0.112 tragen deshalb eine Warnung ganz oben.

**[PRÜFER-39](Befunde/PRUEFER-39.md) hat 7.2.0.111 abgelehnt**, und zu Recht. Der
dritte meiner drei Eingriffe — ein `CE123HochladenZaehler` am Anfang von
`CImapSameServerTransferMsgAction::DoWork` — konnte Eudora **unbeendbar**
machen.

**Nachgemessen:** `DoWork` läuft im **Nebenfaden** (`QCTaskManager.cpp:1095`,
gestartet in `:549` mit `AfxBeginThread`) und blockiert dort unbegrenzt auf dem
Netz; `CImapAction::RequestThreadStop()` ist ein **leerer Rumpf**
(`ImapActionQueue.cpp:709`), niemand bricht den Faden ab. Solange der Zähler
stünde, wäre `bLaeuft` wahr, die Wache in `mainfrm.cpp:2005` nähme jedes Mal den
Zweig `bNotfall && (bLaeuft || bDialogOffen)`, gäbe das Beenden auf und setzte
`m_bE123Gewartet` zurück — der nächste Versuch wartete wieder, **endlos**.
Heraus käme man nur über den Offline-Modus oder den Task-Manager.

**Für Gregors Fehler trug der Zähler ohnehin nichts bei:** sein Protokoll sagte
`eintraege=1` bei `uebertragungen=0` — die Aufgabe stand noch in `m_array` und
war **nie gestartet**. Gezählt wird sie von der Schleife in
`E123OffeneUebertragungen`, und die prüft seit 7.2.0.111 die Basisklasse.

**An seinen beiden Messungen ändert das Entfernen nichts, und das ist belegt:**
bei Weg 2b blieb `laeuft` durchgehend `0`, bei Weg 2a kam `laeuft=1` aus
`m_bE123UebertragungLaeuft` (`:3768`) — also aus dem **zweiten** Eingriff, nicht
aus dem entfernten dritten.

**Dazu N3, und der wog mehr, als der Bericht sagt:** die neue Schranke stand nur
in der unversionierten `.git/hooks/pre-commit` dieser Maschine. Beim Nachsehen
fehlte dort auch **`pruefe-datum.pl` von gestern**. Beide stehen jetzt in
`tools/hooks-einrichten.sh`; ein frischer Klon bekommt sie.

**229 Tests, 229 bestanden.** Offen aus PRÜFER-39: N2 (der Zähler fehlt an den
drei `DoPostProcessing`), N4 (die Schranke lässt sechs von sieben Umgehungen
durch), N5 (ihre Bereichserkennung).

### Von Gregor bestätigt

**Von Gregor am 20.10.2026 bestätigt.** Der Inhalt dieser Fassung ist derselbe
wie in 7.2.0.111, das er auf **beiden** Wegen am laufenden Programm gemessen hat
— Weg 2a mit `laeuft=1` und 6015 ms Wartezeit, Weg 2b mit `uebertragungen=1` und
4015 ms; beide Male beendete sich Eudora danach sauber und die Warteschlange war
leer. 7.2.0.112 unterscheidet sich davon **nur** durch die Rücknahme des
Zählers aus `SameServer::DoWork`, und dass der in keinem seiner beiden Läufe
gewirkt hat, steht in seinen eigenen Protokollen (`laeuft=0` bei 2b, `laeuft=1`
aus `:3768` bei 2a). Seine Freigabe zur Veröffentlichung: *„wie auch immer:
release eine neue version, alles in release notes und changelog, auch der neue
befund“* und *„ja, mach das!“*

## 7.2.0.111 — die Wache beim Beenden sieht jetzt jede Übertragung (E-123)

**Gregor am 20.10.2026 an Paket 1.0.110:** *„verschoben und beendet. fenster
ging gleich weg"*. Sein Protokoll:

```
E-123 Warteschlange: konto=1 eintraege=1 zustand=0 nur-belegt=0 laeuft=0 uebertragungen=0
```

**Ein Eintrag in der Warteschlange, gezählt als null.** In `actionqueue.dat`
stand er: `<ActionType>transfersame</ActionType>`, `INBOX` → `HW_Box`, fünf
Nachrichten.

**Die Ursache** (`ImapActionQueue.cpp:4007` und `:3768`): gezählt wurde
`CImapFromLocalTransferMsgAction` — nur der Weg aus einem **lokalen** Postfach
nach IMAP. Gregor hat **innerhalb** desselben IMAP-Kontos verschoben, das ist
`CImapSameServerTransferMsgAction`. Von vier Übertragungsarten war eine
gezählt und drei waren blind.

**Behoben:** gezählt wird die Basisklasse `CImapTransferMsgAction` — jede
Übertragungsaufgabe muss noch mit dem Server reden, gleich aus welcher
Richtung. Dazu zählt `CImapSameServerTransferMsgAction::DoWork` jetzt wie der
Weg von lokal nach IMAP, solange sie kopiert und löscht.

**Kein Datenverlust:** die Aufgabe wird beim Beenden nach `actionqueue.dat`
geschrieben und beim nächsten Start ausgeführt. Gregors fünf Nachrichten sind
angekommen.

**Das ist dieselbe Klasse wie [P2](#p2) aus PRÜFER-36** — dort stand der
Hochladezähler in einer Funktion, die die gemeinte Unterklasse gar nicht ruft.
Zweites Auftreten, also eine Schranke: `tools/pruefe-e123-zaehlung.pl` hält die
drei E-123-Stellen darauf fest, die **Basisklasse** zu prüfen. Gegenprobe am
echten Fehlerstand **2 von 2 rot**, nach der Behebung grün; `--selbsttest` 2
Fälle, 0 Fehler.

**Von Gregor am 20.10.2026 an Paket 1.0.111 am laufenden Programm bestätigt
(Weg 2b).** Sein Protokoll:

```
E-123 Warteschlange: konto=1 eintraege=1 zustand=0 nur-belegt=0 laeuft=0 uebertragungen=1
E-123 Beenden wartet auf 1 Uebertragung(en) in IMAP-Ordner
E-123 Warteschlange: konto=1 eintraege=0 zustand=0 nur-belegt=0 laeuft=0 uebertragungen=0
E-123 Beenden: Warten zu Ende nach 4015 ms, offen=0
```

**`uebertragungen=1`, wo an 1.0.110 noch `0` stand** — bei demselben Handgriff.
Eudora hat **4015 ms gewartet**, die Übertragung zu Ende gebracht und sich dann
sauber beendet; `actionqueue.dat` war danach **leer**, die Aufgabe also
ausgeführt und nicht auf die nächste Sitzung verschoben.

**Weg 2a, ebenfalls von Gregor am 20.10.2026 an 1.0.111 bestätigt** — Post aus
dem lokalen `In` in einen IMAP-Ordner, dann sofort *Ctrl+Q*:

```
E-123 Warteschlange: konto=1 eintraege=1 zustand=0 nur-belegt=0 laeuft=0 uebertragungen=1
E-123 Beenden wartet auf 1 Uebertragung(en) in IMAP-Ordner
E-123 Warteschlange: konto=1 eintraege=0 zustand=1 nur-belegt=0 laeuft=1 uebertragungen=1
E-123 Warteschlange: konto=1 eintraege=0 zustand=0 nur-belegt=0 laeuft=0 uebertragungen=0
E-123 Beenden: Warten zu Ende nach 6015 ms, offen=0
```

**Hier steht `laeuft=1`** — bei 2b blieb der Wert auf `0`, weil das Hochladen zu
kurz war. Damit ist auch der **zweite** Teil gemessen: der Zähler um die
laufende Übertragung, nicht nur die Warteschlange. Eudora wartete **6015 ms**
und beendete sich dann sauber.

### Prüfanleitung

**2a:** mehrere Nachrichten aus `In` in einen IMAP-Ordner verschieben, sofort
*File → Exit*. **2b:** dasselbe aus `Inbox (<Dominant>)` in einen anderen
IMAP-Ordner. Beide Male darf das Fenster nicht verschwinden, solange die
Übertragung läuft.

## 7.2.0.110 — die Behebung zu E-69 greift jetzt wirklich (PRÜFER-38, R1–R4)

7.2.0.109 war übersetzt, aber nie geschnürt. **PRÜFER-38 fand darin zwei
Löcher, die beide meine eigene Behebung aufgerissen hatte.**

### <a id="r1"></a>R1 — E-69 wäre nach dem ersten Filterlauf stumm gewesen

`CE69Sammlung::LaufEnde()` setzte nichts zurück. Nach dem ersten geklammerten
Lauf blieb `bErstGemeldet` auf `true`, und **jeder spätere Fall außerhalb einer
Klammer bekam gar keinen Eintrag mehr** — kein Eintrag, kein Sammeleintrag,
nichts, bis Eudora neu startet. Genau das Symptom, gegen das [E-69](Intern/BEFUNDE.md#e-69) angelegt
wurde.

**Neun grüne Tests haben es nicht gesehen**, auch nicht der mit dem Namen
*„ohne Klammer bleibt es beim alten Verhalten"*: jeder Testblock legt ein
**frisches** Objekt an, in Eudora ist es eine **globale** Variable. Ein Test,
der seinen Zustand nicht teilt, kann einen Zustandsfehler nicht sehen. Zwei
neue Tests teilen ihn jetzt.

### <a id="r2"></a>R2 — die Klammer fehlte am Anlassfall

`CTocFrame::OnFilterMessages` kehrt für IMAP-Postfächer **32 Zeilen vor** der
Klammer um und landet über `DoManualFiltering` in
`CImapFilterActions::DoFiltering`. Gregors Fall — ein IMAP-Postfach filtern,
während der Server nicht erreichbar ist — lief also an der Zusammenfassung
vorbei. Jetzt geklammert, ebenso das POP-Abholen und *Message → Junk* über
eine Auswahl.

### <a id="r3"></a>R3 — eine Sammlung je Faden

`g_E69Sammlung` war global ohne Sperre und wird auch aus einem Nebenfaden
angefasst (`CImapMailbox::DoFetchNewMessages`). `__declspec(thread)` gibt
jedem Faden seine eigene.

### <a id="r4"></a>R4 — der zweite Versuch wartet wieder

Ohne `m_bE123Gewartet = FALSE` im Aufgeben-Zweig hätte das **zweite**
*File → Exit* `CloseDown` verschachtelt im laufenden Hochladen gerufen —
derselbe unsichtbare Hänger wie [P1](#p1), nur nicht mehr von selbst.

### Entwarnt

PRÜFER-38 hat die beiden Fragen geprüft, die schwerer gewesen wären als alles
Behobene: **Eudora bleibt beendbar** (`m_bE123Gewartet` trägt den zweiten
Versuch), und die beiden Hochladezähler liegen **nacheinander**, nicht
ineinander — der Zähler kann nicht stehenbleiben.

**229 Tests, 229 bestanden.**

### Prüfanleitung

1. Ein **IMAP**-Postfach filtern, während der Server nicht erreichbar ist.
   Zwei Einträge in *Task Errors*, kein Dauerpiepen.
2. **Direkt danach** eine einzelne unlesbare Nachricht filtern. Kommt **kein**
   Eintrag, ist [R1](#r1) nicht behoben.
3. Mehrere Nachrichten in einen IMAP-Ordner verschieben, sofort *File → Exit*.
4. Eine HTML-Nachricht mit Umlauten und `€` über *File → Save As* sichern und
   in Thunderbird oder im Browser öffnen — die Zeichen müssen stimmen. Mit
   **Anhang**: der muss in der Datei noch Anhang sein, nicht Textblock.

### Nachtrag am 19.10.2026: F1, F3 und F4 sind ebenfalls drin

Gregor: *„f1 und f3/f4 erst beheben, dann 0.111 releasen"* und *„ich teste
alles in 0.111, nicht zwei verschiedene"*. Da 7.2.0.110 bis dahin **nie
übersetzt** worden war, ist alles in **1.0.110** gelandet — eine vierte nie
geschnürte Nummer entsteht nicht.

**Die Regression aus [PRÜFER-37](Befunde/PRUEFER-37.md) ist damit weg.**

**F3/F4 — `windows-1252` galt für jeden Weg.** Der Code hielt **jede**
abweichende Zeichensatzangabe für falsch. Für Kodierungen, die Eudora beim
Empfang **nicht** übersetzt, ist die vorgefundene Angabe aber die **einzige
richtige**: `FindMIMECharset` (`mime.cpp:383`) liefert für `windows-*` den
Wert 0 und für Unbekanntes −1, `TextReader.cpp:271` übersetzt erst ab 3.
`windows-1251`, `koi8-r`, `iso-8859-2` und `gb2312` liegen **unübersetzt** im
Postfach. Aus `charset=windows-1251` wurde `windows-1252` — aus lesbarem
Russisch `Àáâ`. **F4** ist dieselbe Sache im `<meta>` und wog schwerer, weil
der Zweig auf dem **Vorgabeweg** läuft, also auch ohne *Kopfzeilen
einschließen*.

**F1 — eine `multipart`-Kopfzeile wird nur ersetzt, wenn die angekündigte
Grenze wirklich fehlt.** Vorher hing das allein am Text der Kopfzeile. Bei
einer echten mehrteiligen Nachricht mit PDF-Anhang wurde daraus `text/plain`,
und jeder Leser zeigt danach Grenzen, Teilköpfe und Base64 als Text — der
Anhang ist aus der Datei nicht mehr zu holen.

**Beim Testen kam ein zweiter Weg heraus**, den PRÜFER-37 so nicht nennt: eine
`multipart`-Zeile trägt **kein** `charset`, `szCs` ist leer, und *„leer ist
nicht iso-8859-1"* machte den Zeichensatz-Zweig wahr — die Ersetzung lief
trotz F1. Jetzt bleibt die Kopfzeile **ganz** unangetastet, wenn der Rumpf
wirklich mehrteilig ist.

**229 Tests, 229 bestanden** (fünf neue). Die wichtigste davon ist die
**Gegenprobe**: ein falsches `UTF-8` über CP1252-Bytes wird weiterhin
berichtigt. Ohne sie wäre aus der Behebung *„fasse nie etwas an"* geworden,
und [E-101](Intern/BEFUNDE.md#e-101) wäre zurück.

**Zwei meiner Tests waren zuerst falsch, nicht der Code** — sie prüften den
Inhalt der Ausgabedatei, obwohl die Funktion bei *„nichts zu tun"* gar nichts
hineinschreibt. Die Spurmarke sagte `ct-ersetzt=0 geaendert=0`, also das
Richtige.


## 7.2.0.109 — aus 500 Pieptönen werden 25 (E-69, P3)

`E69UebersprungenMelden` legte bei **jedem** Abbruch einen eigenen Eintrag in
*Task Errors* an. Jeder Eintrag piept (`MessageBeep`) und holt das Fenster
nach vorn (`TaskErrorBringToFront`, Vorgabe **1**). Beim Filtern eines
IMAP-Postfachs mit 500 nur angerissenen Nachrichten und nicht erreichbarem
Server: **500 Einträge, 500 Pieptöne, 500 Fenstersprünge** — und nichts davon
lässt sich wegklicken.

Gregor hatte etwas anderes vermutet: *„ich dachte, es wäre eine große meldung
in der dialogbox, ähnlich wie die meldung, daß man neue mails hat"*. Gemessen
gibt es die nicht — der modale Dialog erscheint nur bei `ShowMeTheErrors=1`
und immer nur **einer gleichzeitig**. Was stört, ist das Laute.

### A — an der Quelle zusammenfassen

Der **erste** übersprungene Fall eines Laufs bekommt einen eigenen Eintrag;
alles Weitere wird gezählt und am Ende zu **einem** zusammengefasst. Die
Klammer ist `CE69Filterlauf`, ein Objekt auf dem Stapel — damit der Abbau auch
läuft, wenn die Schleife über `EscapePressed()` verlassen wird. Aufrufstellen
**ohne** Klammer verhalten sich wie bisher; das ist eigens getestet.

### B — den Schwall abfangen

Piepen und Nach-vorn-Holen höchstens **einmal je zwei Sekunden**, unabhängig
von der Quelle. Der **Eintrag entsteht weiterhin in jedem Fall** — gedämpft
wird nur das Laute. Damit hilft es auch der nächsten Fehlerquelle.

### Beide Regeln sind prüfbar

`struct CE69Sammlung` und `bool E69LautErlaubt()` — keine Task Errors, kein
Fenster, kein `CSummary`. `Extract.ps1` schneidet beide bei jedem Bau frisch
aus dem Produktivcode (Region O und P). Das ist die Lehre aus **[E-106](Intern/BEFUNDE.md#e-106)**: dort
stand dieselbe Art Regel mitten im Ladeweg und war nur an Gregors Rechner
messbar.

**222 Tests, 222 bestanden** (neun neue). Gegenprobe gefahren — mit dem alten
Verhalten fallen drei um:

```
mit Behebung:  500 Fehler in 50 s, Fenster 2 s ->  25 mal laut
ohne:          500 Fehler in 50 s, Fenster 2 s -> 500 mal laut
```

Mitgeprüft: die Fenstergrenze genau getroffen (1999 ms still, 2000 ms laut)
und der **Überlauf von `GetTickCount`** nach 49,7 Tagen.

### Prüfanleitung

Ein IMAP-Postfach filtern, während der Server nicht erreichbar ist
(*Special → Filter Messages*). Es darf nicht mehr ununterbrochen piepen, und
*Task Errors* darf sich nicht bei jeder Nachricht nach vorn drängen. In der
Liste stehen **zwei** Einträge: der erste Fall und ein Sammeleintrag.

### In dieser Fassung noch nicht behoben

**F1** und **F3/F4** aus [PRÜFER-37](Befunde/PRUEFER-37.md) zu **[E-101](Intern/BEFUNDE.md#e-101)**.
**F4 ist eine Regression gegenüber 1.0.106:** eine Nachricht mit einem
Zeichensatz, den Eudora nicht übersetzt (`windows-1251`, `koi8-r`,
`iso-8859-2`), bekommt beim Speichern eine falsche `<meta>`-Angabe.
*Nachtrag 19.10.2026: alle drei sind in **7.2.0.110** behoben, Abschnitt dort.*

## 7.2.0.108 — Beenden beschädigt keine laufende Übertragung mehr (E-123: P1, P2)

Zwei Funde aus [PRÜFER-36](Befunde/PRUEFER-36.md), beide an **[E-123](Intern/BEFUNDE.md#e-123)**.

### <a id="p1"></a>P1 — die Notbremse übergeht die Sperren nicht mehr

`mainfrm.cpp` beendete nach fünf Minuten **in jedem Fall**:

```cpp
BOOL bNotfall = (dwVergangen > 300000);
if (bNotfall || (!bLaeuft && !bDialogOffen && (…)))
```

`bNotfall` übergeht `bLaeuft` **und** `bDialogOffen`. Lag ein Hochladen auf dem
Stapel, lief `CloseDown` **verschachtelt darin** — das Fenster verschwand, der
Prozess hing unsichtbar weiter. Stand ein modaler Dialog offen, liefen
`CloseDown` und `DestroyWindow` darunter, und dessen `DoModal` kehrte in
abgebauten Code zurück.

**Der Denkfehler lag in der Alternative.** Die Notbremse gab es, damit Eudora
nie für immer offen bleibt — als wäre *„ewig offen"* das einzige andere Ende.
Das Gegenteil von *„mit Gewalt schließen"* ist aber nicht *„ewig warten"*,
sondern: **das Beenden aufgeben**, das Fenster stehen lassen und es sagen.

### <a id="p2"></a>P2 — der Zähler zählt dort, wo das Hochladen beginnt

Er stand in `CImapAction::DoPreThreadAction` hinter einem `dynamic_cast` auf
`CImapFromLocalTransferMsgAction` — und ausgerechnet diese Klasse ruft die
Basisfunktion **nicht** auf; das steht als QUALCOMM-Kommentar zwanzig Zeilen
vor ihrem Rumpf. Für alle anderen Unterklassen ist der Cast `NULL`.

**Beim Einbauen gefunden:** in `DoPostProcessing` steht bereits ein zweiter
Zähler — der **eigentliche Transfer war gedeckt**. Ungedeckt war genau das
Fenster aus N4: der **Verbindungsaufbau** mit `OpenMailbox`, Anmeldung und
`SELECT`.

### Prüfanleitung

Mehrere Nachrichten in einen IMAP-Ordner verschieben und sofort *File → Exit*.
Das Fenster darf **nicht** verschwinden, solange die Übertragung läuft. Nach
fünf Minuten muss in der Statuszeile stehen:

```
Quit cancelled: messages are still being transferred to the IMAP server.
Quit cancelled: a dialog is still open. Close it, then quit again.
```

Im Protokoll steht dazu eine Zeile mit `laeuft=`, `dialog=` und `offen=`.

### Noch nicht im Release

**P3** aus PRÜFER-36 ist offen: **[E-69](Intern/BEFUNDE.md#e-69)**, Meldungsflut in *Task Errors*.

## 7.2.0.107 — die gespeicherte Datei bekommt die Kopfzeile, die zum Rumpf passt (E-101, dritter Teil)

Bis hierher liess der Speicherweg eine vorhandene `Content-Type`-Zeile
unangetastet — mit der Begründung, eine empfangene Nachricht bringe ihre echten
Kopfzeilen mit. **Das stimmt nicht:**

| | |
|---|---|
| **Rumpf** | immer Eudoras interne Fassung — beim Empfang zerlegt, entschlüsselt, nach Windows-1252 übersetzt (`TextReader.cpp`, `ISOTranslate`) |
| **Kopfzeilen** | stehen so da, wie sie ankamen |

**Gemessen an sechs empfangenen HTML-Nachrichten** im Postfach des Prüfstands:
alle sechs tragen `Content-Type: multipart/…; boundary=…`, und **keine einzige**
der Grenzen steht im Rumpf. Ein anderes Programm sucht die Teile und findet
keinen. Vier davon sagen im HTML `charset=UTF-8`, die Bytes sind aber
Windows-1252.

Dazu der Zeichensatz: `0x80` (€), `0x92` (’) und `0x96` (–) gibt es in
ISO-8859-1 nicht. Gespeichert wird jetzt `windows-1252`, wie es der Anzeigeweg
schon tut (`TridentView.cpp`, `szCharsetMeta`).

**213 Tests, 213 bestanden** (vier neue). Gegenprobe gefahren: mit dem alten
`msgutils.cpp` fallen **genau diese vier** um, die übrigen 209 bleiben grün.

### Prüfanleitung

Eine empfangene HTML-Nachricht über *File → Save As* sichern und die Datei in
einem anderen Programm öffnen. Umlaute, `€`, `’` und `–` müssen richtig
erscheinen.

**Nachtrag nach [PRÜFER-37](Befunde/PRUEFER-37.md) (19.10.2026):** der zweite
Teil dieser Anleitung — *„die `Content-Type`-Zeile muss zum Inhalt passen"* —
lässt sich auf dem einzigen Aufrufweg **nicht** prüfen. `StripTabooHeaders`
entfernt die `Content-Type`-Zeile vorher, gemessen in **72 von 72**
Nachrichten (F2); im Protokoll steht dann `ct-ersetzt=0`, und das ist
**erwartet**, kein Mangel. Offen bleiben F1 (ein echter mehrteiliger Rumpf
würde trotzdem ersetzt) sowie **F3/F4, eine Regression gegenüber 1.0.106** bei
`windows-1251`, `koi8-r` und `iso-8859-2`. **Nicht testen:** eine Nachricht
mit Anhang speichern, bei der die `Content-Type`-Zeile erhalten geblieben ist
— das ist F1, und die Datei wird dabei unbrauchbar.

### Noch nicht im Release

**[P1](#p1)–P3 aus [PRÜFER-36](Befunde/PRUEFER-36.md)** sind offen: [P1](#p1)/[P2](#p2) zu
**[E-123](Intern/BEFUNDE.md#e-123)** (Beenden wartet), P3 zu **[E-69](Intern/BEFUNDE.md#e-69)** (Meldungsflut in *Task Errors*).

## 7.2.0.106 — Filter meldet eine übersprungene Nachricht in Task Errors (E-69) — **nicht veröffentlicht, Zweig `e-123-beenden-warten`**

**[E-69](Intern/BEFUNDE.md#e-69)** (Gregor am 17.10.2026: *„[E-69](Intern/BEFUNDE.md#e-69) = doch A“*): `CFiltersDoc::FilterMsg` übersprang eine Nachricht, deren Text es nicht lesen konnte, lautlos – sie wurde nicht gefiltert, und niemand erfuhr warum. Jetzt legt `E69UebersprungenMelden` (`filtersd.cpp`) an allen fünf Stellen einen Eintrag in *Task Errors* an: *„The message "…" in mailbox "…" could not be read and was not filtered (…). It is still in that mailbox; nothing was lost.“* (stammt aus `E69UebersprungenMelden`, filtersd.cpp:2383). Dazu (`CTaskErrorMT::SetzeKontext`) Spalten *Filtering*/*Filters*. Nebenbei: das Nachladen der Kopfzeilen für IMAP prüfte nur `!hResult`, `DownloadFullHeaders` liefert bei manchen Fehlern aber einen negativen HRESULT – dann wurde mit leeren Kopfzeilen weitergefiltert; jetzt `!hResult || FAILED(hResult)`. Nachgestellt am Prüfstand (17.10.2026) mit `tools/messen-e69.ps1`: *In* öffnen, alles auswählen, `In.mbx` von außen sperren (wie ein Virenscanner), *Special → Filter Messages*. An 7.2.0.106: Eudora meldet wie im Original *„Could not open the file … In.mbx … locked“* (stammt aus `IDS_ERR_FILE_OPEN`, EudoraRes.rc:9303), dann `E-69 Filter uebersprungen: betreff=… postfach="In" grund=the message text could not be read` und der Eintrag in *Task Errors*; die Nachricht bleibt in `In`, sauber beendet. Vorher (bis 7.2.0.104) gab es an dieser Stelle nur die Protokollzeile `E-69 FilterMsg abgebrochen`, keine Meldung. Testsuite 209/209. 7.2.0.105 war ein Zwischenbau mit dem Grundtext *„message text is empty“*, nie ausgeliefert.

## 7.2.0.105 — Zwischenbau zu E-69 — **nie ausgeliefert, Zweig `e-123-beenden-warten`**

Derselbe Stand wie 7.2.0.106, nur mit dem Grundtext *„message text is empty“* in der Meldung zu [E-69](Intern/BEFUNDE.md#e-69) (aus der eigenen Meldung, `filtersd.cpp`); am Prüfstand einmal gefahren, dann der Text berichtigt und als 7.2.0.106 neu gebaut.

## 7.2.0.104 — Beenden-Warten kann nicht mehr für immer hängen (E-123) — **nicht veröffentlicht, Zweig `e-123-beenden-warten`**

**[PRÜFER-35](Befunde/PRUEFER-35.md)** fand an 7.2.0.103: „wird gerade hochgeladen“ hing am Zustand der Warteschlange, der über die Abmeldung im Fenster *Task Status* zurückgesetzt wird – die Kette, die bei [E-83](Intern/BEFUNDE.md#e-83) mehrfach gerissen ist; riss sie, wartete Eudora **für immer**. Ebenso galt jedes schwebende Fenster als „Dialog offen“. Jetzt: ein eigener Zähler direkt um Verbindungsaufbau und Hochladen einer Übertragung (`CE123HochladenZaehler` in `CImapAction::DoPreThreadAction` und `CImapFromLocalTransferMsgAction::DoPostProcessing`), der beim Verlassen immer zurückzählt; „Dialog offen“ heißt Hauptfenster gesperrt (`IsWindowEnabled`); die Offline-Prüfung kommt nach der Hochlade-Prüfung; nach 5 Minuten wird in jedem Fall beendet; ein abgebrochenes Herunterfahren setzt das Warten zurück. Nachgestellt an 7.2.0.104 (17.10.2026): einfaches Schließen – `Beenden wartet`, hochgeladen, `Warten zu Ende nach 10015 ms`, sauber; doppeltes Schließen – zweites Schließen ignoriert, hochgeladen, `Warten zu Ende nach 8078 ms`, sauber. Testsuite 209/209.

## 7.2.0.103 — Beenden-Warten abgesichert nach PRÜFER-34 (E-123) — **nicht veröffentlicht, Zweig `e-123-beenden-warten`**

**[PRÜFER-34](Befunde/PRUEFER-34.md)** fand an 7.2.0.102: ein zweites Schließen während des Wartens oder das Ende der 90 s mitten in einem Hochladen führte in einen Hänger (das Hochladen läuft im Hauptfaden und stellt nebenbei Botschaften zu); während des Wartens war nichts zu sehen; im Offline-Modus wurde 90 s vergeblich gewartet; nach *Abbrechen* beim Beenden schloss Eudora kurz darauf von selbst; gezählt wurde jede laufende IMAP-Aufgabe, auch ein Abgleich. Jetzt: ein weiteres Schließen während des Wartens wird ignoriert; solange ein Hochladen läuft oder ein Dialog offen steht, wird nie beendet; die Statuszeile zeigt *„Waiting for messages to finish transferring to the IMAP server before quitting…“*; im Offline-Modus wird nicht gewartet; *Abbrechen* setzt das Warten zurück; gezählt werden nur Übertragungen lokal → IMAP. Nachgemessen an 7.2.0.103 (`tools/messen-e123-doppelt.ps1`: Eudora beendet sich über *File → Exit*, danach kommt ein zweites Schließen): `E-123 Beenden wartet auf 1 …`, `weiteres Schliessen waehrend des Wartens ignoriert`, Hochladen bestätigt, `Warten zu Ende nach 10047 ms, offen=0`, sauber bis `ExitInstance`. Testsuite 209/209.

## 7.2.0.102 — Beim Beenden auf IMAP-Übertragungen warten; belegte Verbindung blockiert die Warteschlange nicht mehr (E-123) — **nicht veröffentlicht, Zweig `e-123-beenden-warten`**

**[E-123](Intern/BEFUNDE.md#e-123)** (Gregor am 17.10.2026: *„sollen wir das beenden so lange hinaus zögern, bis der vorgang abgeschlossen ist“*): Bisher wurden beim Beenden ausstehende Übertragungen lokal → IMAP nur in `actionqueue.dat` gespeichert und nach dem Neustart fortgesetzt; eine bereits laufende Übertragung hielt nur die Rückfrage *„1 task(s) running“* auf. Jetzt wartet `CMainFrame::OnClose`, solange `CImapAccountMgr::E123OffeneUebertragungen` etwas zählt (wartende Übertragungen und eine laufende), Prüfung alle 2 s über einen Zeitgeber, höchstens 90 s, dann wird wirklich beendet. Nicht beim Herunterfahren von Windows und nicht bei einem Konto, das offline oder blockiert ist. Dazu: meldete eine Übertragung die Verbindung nur als **belegt**, blieb die IMAP-Warteschlange bisher blockiert, bis jemand zwischen online und offline umschaltete – die Übertragung lief in dieser Sitzung nie mehr (`CActionQueue::OnIdle`, `ImapActionQueue.cpp`). Jetzt neuer Versuch nach 3 s. Gemessen am Prüfstand `C:\Temp\E118` (17.10.2026) mit neuer Prüfserver-Option `--append-verzoegerung 25` (der Server bestätigt das Hochladen erst nach 25 s) und `tools/messen-e123.ps1` (Abruf, dann sofort beenden): an **7.2.0.102** `E-123 Beenden wartet auf 1 Uebertragung(en)`, alle 2 s nachgezählt, Hochladen bestätigt (`hochgeladen=1`), `Warten zu Ende nach 10047 ms, offen=0`, sauber bis `ExitInstance`, Quelle aus `In` entfernt. **Gegenprobe an 7.2.0.101:** kein Warten, nach `WM_CLOSE` keine Zeile mehr bis zum Abschuss nach 120 s, das Hochladen nie bestätigt, die Mail blieb in `In`, `actionqueue.dat` leer – die Übertragung wäre auch nach einem Neustart nicht fortgesetzt worden. Testsuite **209/209**. **Nicht durchlaufen:** die neue Wiederholung bei belegter Verbindung (keine Zeile `Verbindung belegt` in den Läufen) – nur am Quelltext begründet. **Nebenbefund, ungeklärt:** antwortet der IMAP-Server beim Start sehr langsam (`--gruss-verzoegerung 15`), reiht der Filter „nach IMAP“ die Übertragung gar nicht erst ein (Warteschlange beim Beenden leer, `eintraege=0`), die Mail bleibt still in `In` – kein Verlust, aber der Filter tut nichts.

## 7.2.0.101 — Gesendete Post bekommt beim Verschieben nach IMAP eine eigene Kennung; Filterfehler gemessen (E-121, E-67) — **veröffentlicht als `v1.0.101` am 17.10.2026** (enthält 7.2.0.88 bis 7.2.0.101)

**Von Gregor bestätigt an 1.0.101 (17.10.2026):** Gregor an 1.0.101 (17.10.2026): *„ich starte 1.0.101 und teste: mail verschoben, sind aber im outbox nicht zu sehen.“* und nach dem Neuöffnen des Ordners *„nach neu-öffnen sind mails zu sehen.“* (Chat). Sein Protokoll: zwei gesendete Mails mit zwei verschiedenen eigenen Kennungen, `E-121 Uebertragung: id=3348826478 … hochgeladen=1` und `id=3348826734 … hochgeladen=1`, neue UIDs 17 und 18 – der neue Weg ist gelaufen. **Dabei aufgefallen:** War der IMAP-Ordner beim Verschieben **nicht geöffnet** und wird er gleich danach geöffnet, fehlen die eben hochgeladenen Mails in der Liste, bis der Ordner noch einmal geschlossen und geöffnet wird (Gregors Protokoll: Hochladen um 5.01 bei `summen=2`, danach erst `NewChildFrame … OUTBOX`, Abgleich ohne Übernahme). **Kein Datenverlust**, nur Anzeige; Ursache nicht untersucht.

**[E-121](Intern/BEFUNDE.md#e-121), [PRÜFER-32](Befunde/PRUEFER-32.md):** Alle Nachrichten aus `Out` tragen die Kennung 0, und über sie fanden sich Quelle und Vorab-Kopie wieder. Kam eine Übertragung nicht zustande (Server nicht erreichbar, offline, Esc), blieb die markierte Vorab-Kopie liegen, und die **nächste** gesendete Mail griff diese fremde Kopie – die eigene lag dann nur noch im lokalen Papierkorb (Rückfall seit 7.2.0.96). Jetzt bekommen Quelle und Vorab-Kopie in `CTocDoc::Xfer` eine eigene, gemeinsame Kennung (`E121NeueKennung`, `EuImap/src/ImapToc.cpp`), die weder in der Quelle noch im Ziel vorkommt. Außerdem wird eine Vorab-Kopie, deren Hochladen scheitert, sofort entfernt (`ImapCopyMsgFromLocalToImap`, Spurmarke `E-121 Hochladen gescheitert, Vorab-Kopie entfernt`) – liegengeblieben konnte ein Abgleich sie für eine fremde Server-Nachricht halten. Am Prüfstand `C:\Temp\E118` an 7.2.0.101 (17.10.2026): Normalfall `hochgeladen=1`; **Server lehnt das Hochladen ab** (`--append-ablehnen`): `E-121 Hochladen gescheitert, Vorab-Kopie entfernt`, die Nachricht bleibt in `In`; Kollisionsfall zweimal grün; alle sauber beendet. Die eigene Kennung für Nachrichten aus `Out` ist am Prüfstand **nicht nachstellbar** (per POP abgerufene Post hat nie Kennung 0) – Prüfung bei Gregor. Testsuite **209/209**.

**[E-67](Intern/BEFUNDE.md#e-67):** die Korrektur (`>` → `>=` in `filtersv.cpp`) steht seit 7.2.0.43 im Code; jetzt mit Spurmarken `E-67 Filteransicht laden/speichern` gemessen. Gemessen am Prüfstand an 7.2.0.101 (17.10.2026), mit neuer Spurmarke und `tools/messen-e67.ps1` (öffnet das Filterfenster per Menübefehl 32826): Regel *„Junk Score is less than 50“* als erste Regel – `E-67 Filteransicht laden: … verb-gespeichert=14 verb-auswahl=0 eintraege=2`, beim Wegklicken `verb-neu=14 geaendert=0`, `Filters.pce` danach unverändert `verb less`. **Gegenprobe** mit dem alten `>`: `verb-auswahl=14 eintraege=2` – der ungültige Wert, aus dem der Fehler entsteht. Nicht nachgestellt: die Verfälschung der Datei selbst, dafür müsste im Fenster eine zweite Regel angeklickt werden.

## 7.2.0.100 — Mehrere gesendete Mails auf einmal nach IMAP; zwei Absicherungen aus der Nachprüfung (E-121, E-83) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-121-mehrere-gesendete`**

**[PRÜFER-31](Befunde/PRUEFER-31.md) F1, [E-121](Intern/BEFUNDE.md#e-121):** Wurden mehrere Nachrichten mit Kennung 0 (gesendete Post) in **einer** Übertragung in einen IMAP-Ordner verschoben und meldete der Server keine neue UID oder scheiterte das Hochladen, behielt die Vorab-Kopie ihr Merkzeichen – jede weitere Runde nahm dieselbe Kopie wieder: die erste Mail mehrfach auf dem Server, die anderen gar nicht, und deren Quellen lagen schon im lokalen Papierkorb (Weg zum Datenverlust, Originalfehler). Jetzt verliert die Vorab-Kopie ihr Merkzeichen **vor** dem Versuch (`CTocDoc::ImapCopyMsgFromLocalToImap`); im Fall ohne neue UID wird beim Hochladen aus dem Ziel die Zusammenfassung selbst ersetzt. **F3:** eine leere Kennungsliste beendet `DoPostProcessing`, statt mit Kennung 0 eine fremde Vorab-Kopie zu greifen. **F4, [E-83](Intern/BEFUNDE.md#e-83):** `QCTaskManager::SetDisplayWindow` gibt `m_ObjGuard` frei, bevor es Aufgaben entfernt (Verklemmungsgefahr mit `Register`). Am Prüfstand `C:\Temp\E118` gemessen (16.10.2026), sechs Läufe an 7.2.0.100: Normalfall 2×, Server ohne neue UID (`--ohne-appenduid`, der geänderte Weg) 2×, Kollisionsfall 2× – alle `hochgeladen=1`, alle sauber beendet. F1 selbst ist **nicht nachstellbar**: Kennung 0 haben nur Nachrichten aus `Out`, per POP abgerufene Post bekommt ihre Kennung immer aus dem Abrufprotokoll (`pop.cpp:376`); bei Gregor (GMX, mit UIDPLUS) tritt F1 ebenfalls nicht auf. Testsuite **209/209**.

## 7.2.0.99 — Neubau von 7.2.0.98: Defender hatte die Datei als Trojaner eingestuft (E-124) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**[E-124](Intern/BEFUNDE.md#e-124):** Gregors laufendes 1.0.98 verschwand beim Verschieben einer gesendeten Mail ohne Dialog – kein Absturz: Microsoft Defender hatte `Eudora.exe` 7.2.0.98 um 10:12:25 als `Trojan:Win32/Bearfoos.A!ml` eingestuft und den Prozess beendet, mit einer um 10:10:50 in der Cloud für genau diese Datei erzeugten Signatur. 1.0.87, 1.0.96, 1.0.97 sauber. Der Quelltext ist **unverändert**, nur die Versionsnummer gehoben; die neue Datei ist sauber, auch nach drei Prüfstandläufen (alle hochgeladen). **Neu:** `tools/paket-pruefen.ps1` prüft jede EXE/DLL/OCX mit Defender (`MpCmdRun -DisableRemediation`) und weist bei einem Fund ab – Gegentest: 1.0.97 durch, 1.0.98 abgewiesen. Anwenderhinweis in der README (*Windows Defender meldet Eudora als Trojaner*). Gregors Protokoll an 1.0.98 belegt nebenbei, dass [PRÜFER-30](Befunde/PRUEFER-30.md) F1 beseitigt ist: `E-121 Uebertragung: id=0 im-ziel=1 … hochgeladen=1`. Testsuite **209/209**. **Von Gregor am 16.10.2026 an 1.0.99 bestätigt** (*„0.99 scheint zu funktionieren.“*): gesendete Mail `E-121 Uebertragung: id=0 im-ziel=1 in-quelle=0 markiert=0 hochgeladen=1`, zwei Mails aus `In` mit `markiert=1 … hochgeladen=1`, Beenden bis `ExitInstance` ohne *„task(s) running“*, keine neue Defender-Erkennung ([E-121](Intern/BEFUNDE.md#e-121), [E-83](Intern/BEFUNDE.md#e-83)). Prüfschritte: `Releases/1.0.99/TESTEN.txt`; 1.0.97 und 1.0.98 sind dadurch ersetzt und nicht zu testen.

## 7.2.0.98 — Erledigte Startaufgabe blieb stehen und belegte den IMAP-Ordner (E-83, zweite Ursache) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**[E-83](Intern/BEFUNDE.md#e-83), zweite Ursache:** Zuerst ist der Rahmen `CTaskStatusWazooWnd` als Anzeige der Aufgaben angemeldet; beim ersten *„Alive“* baut er die Ansicht `CTaskStatusView`, die sich in `QCTaskManager::SetDisplayWindow` anmeldet und die Aufgaben übernimmt. Eine Aufgabe, die in diesem Moment **schon fertig** ist, meldet sich bei der Ansicht nicht an (`NotifyAlive` prüft `IsAlive`), und ihre Abmeldung ging an den Rahmen, der sie nicht kennt. Aus der Liste entfernt wird eine Aufgabe aber nur über diese Abmeldung (`CTaskStatusView::OnMsgDeleteInfo`) – sie blieb für immer stehen (`E-83 liegengeblieben`), belegte ihr Postfach, jede weitere IMAP-Aufgabe darauf wartete (*„Waiting to update mailbox“*), und beim Beenden kam *„You currently have 1 task(s) running“*. Behoben: `SetDisplayWindow` entfernt beim Übernehmen schon fertige Aufgaben; `OnMsgDeleteInfo` entfernt auch eine Aufgabe, die die Ansicht nicht kennt; eine Aufgabe ohne Anzeigefenster wird beim ersten Fenster nachgetragen. Spurmarken `E-83 Ansicht-angemeldet`, `Ansicht-aufgenommen`, `beim-Umhaengen-schon-fertig-entfernt`, `Ansicht-kannte-Aufgabe-nicht`, `ohne-Anzeige`. Nachgestellt am IMAP-Prüfstand `C:\Temp\E118` (16.10.2026): an 7.2.0.96 und 7.2.0.97 hingen **12 von 12** Läufen am ersten Abgleich nach dem Start (Aufgabe `Resyncing`, `uid=1`, `E-83 liegengeblieben`, an den Server nur noch `NOOP`, kein Hochladen); an 7.2.0.98 kamen **10 von 10** durch, in jedem Lauf mit der Spurmarke `E-83 beim-Umhaengen-schon-fertig-entfernt: uid=1`. Kollisionsfall (`--fremde-uid`, `-ZielBehalten`) an 7.2.0.98 grün: `im-ziel=1 markiert=1 hochgeladen=1`, fremde Nachricht unverändert. Gesendete Post (Kennung 0, [PRÜFER-30](Befunde/PRUEFER-30.md) F1) ist am Prüfstand nicht nachstellbar – Prüfung bei Gregor. Testsuite **209/209**. Der Verdacht vom 15.10. gegen 7.2.0.97 ist damit widerlegt.

## 7.2.0.97 — Verschieben nach IMAP: gesendete Post wieder hochgeladen, nur die markierte Quelle entfernt (E-121) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**[E-121](Intern/BEFUNDE.md#e-121), [PRÜFER-30](Befunde/PRUEFER-30.md) F1 – Rückfall in 7.2.0.96:** `E121FindeVorabKopie` lieferte bei Kennung 0 sofort nichts; Nachrichten aus `Out` und gesendete Post in lokalen Ordnern (Kennung 0) wurden beim Verschieben in einen IMAP-Ordner **nicht mehr hochgeladen**, ohne Meldung (Gregors Test an 1.0.96 enthielt keinen solchen Fall). Am Quelltext nachgeprüft. Jetzt findet die Suche die markierte Vorab-Kopie auch bei Kennung 0 (eine Server-UID ist nie 0); `ImapCopyMsgFromLocalToImap` nimmt beim Hochladen aus dem Ziel die Zusammenfassung selbst, aus der Quelle wird nur bei Kennung ungleich 0 gesucht. **N1:** nach dem Hochladen wird nur die beim Verschieben markierte Quelle entfernt (`CSummary::m_bE121Quelle`, gesetzt in `CTocDoc::Xfer`); ein Namensvetter mit derselben Kennung bleibt stehen, ohne Merkzeichen (nach einem Neustart) bleibt die Quelle stehen – doppelt statt weg. Spurmarke `E-121 Uebertragung` nennt jetzt `markiert=`. N2 und N3 abgetrennt nach [E-123](Intern/BEFUNDE.md#e-123). Testsuite **209/209**; am Prüfstand nicht gemessen (der Fall Kennung 0 aus `Out` ist dort nicht nachstellbar) – Prüfung bei Gregor.

## 7.2.0.96 — Verschieben nach IMAP: fremde Mail mit gleicher UID nicht mehr für die eigene gehalten (E-121) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**[E-121](Intern/BEFUNDE.md#e-121), Gregors Test an 1.0.95:** Doppelanzeige weg, aber *„Attempt to add the message to mailbox Inbox failed“*. Sein Protokoll: `id=13 im-ziel=1 hochgeladen=0`. Die Mail kam früher aus einem IMAP-Ordner und trägt lokal noch deren UID 13 als Kennung; im Ziel `Inbox` steht eine **fremde** Mail mit Server-UID 13. Die Suche nach der Vorab-Kopie lief nur über die Kennung und fand die fremde – das Hochladen scheiterte (kein Verlust, die Mail blieb in `In`); im Erfolgsfall wäre die fremde Zusammenfassung umgeschrieben worden. Jetzt trägt die Vorab-Kopie aus `CTocDoc::Xfer` ein Merkzeichen (`CSummary::m_bE121Vorab`, nur im Speicher), und `E121FindeVorabKopie` nimmt ausschließlich so markierte Einträge (`DoPostProcessing`, `ImapCopyMsgFromLocalToImap`). Nach einem Neustart fehlt das Merkzeichen: dann wird aus der Quelle hochgeladen. Am Prüfstand gemessen: neue Option `--fremde-uid` des IMAP-Prüfservers legt eine fremde Nachricht mit der Kennung der Testmail in den Zielordner, `e118-serie.ps1 -ZielBehalten` lässt sie im Zwischenspeicher. An **7.2.0.95** kommt genau Gregors Dialog (*„Attempt to add the message to mailbox … failed“*, `im-ziel=1 hochgeladen=0`), an **7.2.0.96** `im-ziel=1 hochgeladen=1`, `summen=2`, die fremde Nachricht unverändert, die eigene einmal im Ziel und aus `In` entfernt. Testsuite **209/209**. **Bestätigt** von Gregor an 1.0.96 (15.10.2026), kein Fehlerdialog beim Verschieben; sein Protokoll: vier Übertragungen, alle `hochgeladen=1`, darunter `id=312` (alte UID als Kennung – der Kollisionsfall), kein `hochgeladen=0`.

## 7.2.0.95 — Doppelanzeige: Vorab-Kopie an Ort und Stelle aktualisieren (E-121) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**[E-121](Intern/BEFUNDE.md#e-121), Gregors Test an 1.0.94:** weiter doppelt in der Liste. Sein Protokoll: einmal hochgeladen (`neue-uid=320`), `summen=37` vor **und** nach dem Abgleich, die Spurmarke `E-121 Abgleich uebernimmt` aus 7.2.0.94 fehlt ganz – der Abgleich legt keine zweite Zeile an, die **Daten** sind einfach, nur die **Liste im Fenster** zeigt eine Zeile doppelt. Ursache (am Quelltext, nicht gemessen): 7.2.0.91 ersetzte die Vorab-Kopie mit `SubtractSum` + `AddSum`; `SubtractSum` löscht die Listenzeile über die Position in `m_Sums` (`tocdoc.cpp`), ist die Liste anders sortiert, trifft es eine andere Zeile, und `AddSum` fügt eine neue hinzu. Jetzt wird die Vorab-Kopie an Ort und Stelle aktualisiert (Lage, Länge, UID), ohne Herausnehmen. Testsuite **209/209**; am Prüfstand nicht gemessen.

## 7.2.0.94 — Doppelanzeige: der Abgleich ersetzt statt zu verdoppeln (E-121) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**[E-121](Intern/BEFUNDE.md#e-121), Gregors Test an 1.0.93: FAILED** – weiter doppelt in `Inbox` und `OUTBOX`, bis der Ordner neu geöffnet wird. Sein Protokoll **widerlegt** die UIDPLUS-Vermutung aus 7.2.0.93: GMX meldet die UID (`E-121 Hochgeladen: … neue-uid=7`, `8`, `9`, `319`), und direkt nach dem Hochladen steht jede Mail einmal da. Die zweite Zeile legt der nachlaufende Abgleich an: `CTocDoc::ImapMergeTmpMbx` (`EuImap/src/ImapToc.cpp`) übernimmt die vom Server geladenen Mails **ohne** zu prüfen, ob dieselbe UID schon im Ordner steht (die Prüfung in `ImapMailbox.cpp` um :4999 sitzt in einem anderen Weg). Jetzt ersetzt die vom Server geladene Fassung einen solchen Eintrag (Vorschau gelöst, offenes Fenster geschlossen, Bilddateien bleiben). Spurmarke `E-121 Abgleich uebernimmt: uid=… schon-da=…`. Am Prüfstand nicht gemessen; Testsuite **209/209**.

## 7.2.0.93 — Doppelanzeige bei Servern ohne UIDPLUS (E-121) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**[E-121](Intern/BEFUNDE.md#e-121), Gregors Test an 1.0.92:** drei Mails, jede doppelt bei offenem IMAP-Ordner; sein Protokoll: je einmal hochgeladen, nach dem Anstoß des Abgleichs je **ein** neuer Eintrag. Ursache: der Abgleich prüft schon selbst, ob eine Nachricht mit derselben UID im Ordner steht (`ImapMailbox.cpp` um :4999). Die UID kennt Eudora nach dem Hochladen aber nur, wenn der Server sie meldet (UIDPLUS, `APPENDUID`); der Prüfserver meldet sie, Gregors Server (GMX) vermutlich nicht. Ohne UID blieb die Vorab-Kopie mit lokaler Kennung stehen, der Abgleich holte die Server-Fassung dazu. Jetzt wird die Vorab-Kopie in diesem Fall nach dem Hochladen entfernt (Bilddateien bleiben, nicht bei Kennung 0). Spurmarke `E-121 Hochgeladen: … neue-uid=…`; Prüfserver neu mit `--ohne-appenduid`. Am Prüfstand NICHT gemessen (vier Läufe mit `--ohne-appenduid` hingen alle am Start-Abgleich des Prüfservers); Prüfung bei Gregor mit offenem IMAP-Ordner. Testsuite **209/209**.

## 7.2.0.92 — Doppelanzeige nach dem Verschieben, zweiter Teil (E-121) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**[E-121](Intern/BEFUNDE.md#e-121), Gregors Test an 1.0.91:** die Mail stand nach dem Verschieben weiter doppelt da, bis der Ordner neu geöffnet wurde. 7.2.0.91 ersetzte die Vorab-Kopie, ließ ihr aber die lokale Kennung; der anschließende Abgleich erkannte sie nicht als die Nachricht vom Server (im IMAP-Ordner ist die Kennung die UID) und fügte diese zusätzlich ein. Jetzt bekommt die ersetzte Kopie die vom Server gemeldete UID (`ImapCopyMsgFromLocalToImap`). Neue Spurmarke `E-121 Ziel nach dem Abgleich: summen=…`. **Am Prüfstand nicht im Doppelfall gemessen** (vier von fünf Läufen hingen am Start-Abgleich des Prüfservers, der eine gültige hatte die Vorab-Kopie schon verloren); Testsuite **209/209**. Prüfung bei Gregor mit offenem IMAP-Ordner.

## 7.2.0.91 — keine Doppelanzeige nach dem Verschieben in einen IMAP-Ordner (E-121) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**[E-121](Intern/BEFUNDE.md#e-121), Gregors Test an 1.0.90:** *„mails erscheinen nach dem verschieben 2x“* – bei offenem IMAP-Ordner blieb die Mail doppelt stehen, bis zum nächsten Abgleich; auf dem Server lag sie nur einmal. `CTocDoc::ImapCopyMsgFromLocalToImap` legte nach dem Hochladen eine zweite Zusammenfassung an, statt die lokale Vorab-Kopie zu ersetzen. Jetzt wie in `ImapCopyMsgBetweenAccounts`: die Vorab-Kopie mit derselben Kennung wird wiederverwendet (nicht bei Kennung 0), ihre Bilddateien bleiben. **Am Prüfstand gemessen (15.10.2026, `tools/e118-serie.ps1`):** im Fall `im-ziel=1` (Vorab-Kopie noch da) neue Spurmarke `E-121 Ziel nach dem Hochladen: summen=1`; Gegenprobe ist Gregors Beobachtung an 1.0.90 (der Fall trat am Prüfstand mit 7.2.0.90 in fünf Läufen nicht auf). Testsuite **209/209**.

## 7.2.0.90 — eingebettete Bilder beim Hochladen, kein Verlust beim Verschieben in IMAP (E-118 Teil 2, E-121) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**[E-118](Intern/BEFUNDE.md#e-118) Teil 2:** an 1.0.89 fehlten bei Gregors SoftMaker-Mail nach dem Verschieben in den IMAP-Ordner die eingebetteten Bilder – der Hochladecode kannte die Zeilen `Embedded Content:` nicht (Originalfehler). Jetzt wird jedes Bild ein eigener Teil mit dem `Content-ID`, unter dem das HTML es ruft, die Nachricht wird `multipart/related`. Nach PRÜFER-27: Text hinter `</x-html>` bleibt erhalten, die Teilegrenze entsteht nur einmal. Test `TestE118.cpp` (5), (6), Testsuite **209/209**.

**[E-121](Intern/BEFUNDE.md#e-121) (Datenverlust, Originalfehler):** gefunden beim Messen von [E-118](Intern/BEFUNDE.md#e-118) – eine Nachricht, die aus einem lokalen Postfach in einen IMAP-Ordner verschoben wird, konnte verschwinden, wenn die Abgleichsaufgabe des Zielordners vom Start die lokale Kopie verwarf, bevor sie hochgeladen war; gelöscht wurden dabei auch die eingebetteten Bilddateien. Jetzt bleibt die Nachricht in der Quelle, bis der Server sie angenommen hat; fehlt die Kopie im Ziel, wird aus der Quelle hochgeladen. **Am IMAP-Prüfserver gemessen (14.10.2026):** Normalfall, fehlende Kopie (mit Prüfschalter erzwungen) und abgelehntes `APPEND` (`--append-ablehnen`): nie verloren. Neu im Prüfserver: `--append-ablehnen`, `--gruss-verzoegerung`.

## 7.2.0.89 — HTML-Mail im IMAP-Ordner behält ihren Typ (E-118) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, Zweig `e-118_HTML_header`**

**Von Gregor am 14.10.2026 an 1.0.89 bestätigt** (waipu.tv-Mail in den IMAP-Ordner verschoben, erscheint als HTML; *„main von in box in die imap box verschoben“*).

**[E-118](Intern/BEFUNDE.md#e-118):** Eudora legt eine empfangene HTML-Mail lokal als `<x-html> … </x-html>` ab. Beim Hochladen in einen IMAP-Ordner (`EuImap/src/ImapAppend.cpp`) wurden alle `Content-*`-Köpfe verworfen und für den Text keiner (einteilig) bzw. fest `text/plain` (mehrteilig) geschrieben; der Server zeigte den HTML-Quelltext samt Hülle. Jetzt erkennt `E118Huelle` die Hülle, streift sie ab und schreibt `Content-Type: text/html` mit Zeichensatz; ohne Hülle `text/plain` mit Zeichensatz; bei Bytes über 0x7F `Content-Transfer-Encoding: 8bit`. Test zuerst: `Tests/TestE118.cpp`, Testsuite **207/207**, Gegentest mit verstellter Erkennung 2 rot. **Am laufenden Programm gemessen (14.10.2026)** am IMAP-Prüfserver (`tools/imap-pruefserver.pl --ablage`, neu mit `APPEND`), Weg: POP-Abruf, Filter überträgt in den IMAP-Ordner `Ablage` (`C:\Temp\E118`): 7.2.0.89 lädt `Content-Type: text/html; charset="iso-8859-1"` und `Content-Transfer-Encoding: 8bit` hoch, ohne `<x-html>`, Umlaut-Bytes unverändert; mit Euro-Zeichen (0x80) `charset="windows-1252"`. Gegenprobe 7.2.0.88 (`C:\Temp\E118-0088`): kein `Content-Type`, `<x-html>` im Rumpf. Prüfnachrichten `Testdaten/e118-html-in-imap-ordner.eml`, `Testdaten/e118-euro-in-imap-ordner.eml`. **Nachgebessert nach der Messung (MESSSTAND):** Bytes 0x80–0x9F gibt es in ISO-8859-1 nicht; steht eines im Text, heißt der Zeichensatz `windows-1252` (`E118Achtbit` liefert 2). 

## 7.2.0.88 — versteckte Abschnitte bleiben versteckt (E-105) — **nicht einzeln veröffentlicht, enthalten in `v1.0.101`, gemergt mit PR #97**

**[E-105](Intern/BEFUNDE.md#e-105):** Newsletter schicken Desktop- und Handyfassung in einer Mail und verstecken eine davon inline mit `style="display:none"`. Paige kennt `display` nicht, also standen Bilder und Absätze doppelt da (Gregor am 13. und 14.10.2026, freenet-Newsletter). Jetzt verschluckt `E105Schritt` (`PGHTMIMP.CPP`, aufgerufen in `ReadHTMLTag`) ein solches Element samt Inhalt bis zu seinem Ende-Tag. Leere Elemente öffnen keinen Bereich, `</body>` beendet jeden, ein verstecktes `<p>` endet am nächsten Block. Test zuerst: `Tests/TestE105.cpp`, Testsuite **202/202**, Gegentest mit verstellter Erkennung 5 rot. **Am laufenden Programm gemessen (14.10.2026)**, `C:\Temp\E105`, Prüfnachricht `Testdaten/e105-handyfassung-versteckt.eml`: Öffnen und Weiterleiten zeigen nur die sichtbaren Teile; Gegenprobe 1.0.87 zeigt Vorschauzeile, Handyfassung und versteckte Wörter. Nicht abgedeckt: `display:none` über eine Klasse aus einem `<style>`-Block.

## 7.2.0.87 — Bilder mit `&amp;` in der Adresse (E-117) — **veröffentlicht als `v1.0.87`**

**Veröffentlicht am 14.10.2026 um 05:46:20 UTC** als `v1.0.87`, auf GitHub als *Latest*; Marke auf `41c6752` (Merge von PR #96), ZIP `Eudora72-1.0.87-release.zip` mit 9 060 108 Byte, SHA-256 `a4f1c28ddfa22dbd1c16bd71705157134fca431dbc161d1554f78da42864904c` — von GitHub heruntergeladen und nachgerechnet; die 34 EXE-, DLL- und OCX-Dateien darin sind byteidentisch mit dem Verzeichnis, das Gregor getestet hat, das Mailverzeichnis im ZIP enthält nur die Vorgabe-`Eudora.ini`. Die Fassung enthält auch 7.2.0.85 ([E-112](Intern/BEFUNDE.md#e-112) mit [E-103](Intern/BEFUNDE.md#e-103)) und 7.2.0.86 ([E-115](Intern/BEFUNDE.md#e-115)), alle von Gregor bestätigt. Freigabe: *„ja, wir releasen ein 0.87 in github“*. Release auf GitHub (https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.87). **Nebenbefund:** `Eudora71/Bin/Release/SPELL32.DLL` (05.09.2026) ist nicht die ausgelieferte Datei; im ZIP steckt die aus 1.0.84, mit der Gregor getestet hat ([PR-2](Intern/BEFUNDE.md#pr-2), Abschnitt PR-2.2).

**[E-117](Intern/BEFUNDE.md#e-117):** `resolve_URL` (`HTMLUtils.cpp`) übersetzt `&amp;` im `src` eines Bildes zu `&`. Gregors eBay-Nachricht lud statt des Fotos ein 1×1-Pixel, weil der Bilddienst `&amp;imgWidth=448` bekam (seine `eudora.log` an 1.0.86). Test zuerst: `TestResolveURL.cpp` (8) vorher rot, Testsuite **196/196**. **am laufenden Programm gemessen (13.10.2026)**, `C:\Temp\E112-1085`, Prüfnachricht `Testdaten/e117-amp-in-bildadresse.eml` über `tools/anhang-pruefdaten.pl --pop`, Bildserver `tools/bildserver-e117.pl` auf 127.0.0.1:18117 (liefert das Bild nur bei echtem `&`, sonst 1×1): **Gegenprobe 7.2.0.85** — Abruf `GET /bild.png?a=1&amp;w=2` → Pixel, `E-112 Metadatei: angegeben=165x0 Datei=1x1 gemalt=165x165`; **7.2.0.87** — nur `GET /bild.png?a=1&w=2`, `Datei=330x327 gemalt=165x164`, das Fensterfoto zeigt das Bild. (Die Leseansicht holte schon vorher die richtige Adresse, weil der Internet Explorer `&amp;` selbst übersetzt.)

## 7.2.0.86 — Ctrl+F wirft nicht mehr, wenn ein IMAP-Postfach aktiv ist (E-115) — **nicht einzeln veröffentlicht, enthalten in `v1.0.87`**

**[E-115](Intern/BEFUNDE.md#e-115):** Ursache an Gregors laufendem 1.0.85 gemessen, während die Meldung offen stand: Stapel des Meldungsthreads ohne Debugger gelesen — `CMBoxTreeCtrlCheck::FindCheck` (`MBoxTreeCtrlCheck.cpp:938`) übersprang den Ordner Recent mit `GetNextSiblingItem`; Recent ist der letzte Eintrag, also NULL, und `GetItemData(NULL)` warf *„Encountered an improper argument“* (der Text stammt aus MFC). Erreicht wird das nur, wenn *Find Messages* ein Postfach hinter Recent vorwählt — ein IMAP-Postfach. Jetzt: Recent samt Inhalt überspringen (`GetNextTraversalItem(hItem, false)`), bei NULL Ende. **Am laufenden Programm gemessen** (Kopie seines Mailverzeichnisses `C:\Temp\E115-gregor`, Ctrl+F bei aktivem IMAP-Postfach): mit 7.2.0.84 kommt die Meldung, mit 7.2.0.86 keine. **Von Gregor am 13.10.2026 an 1.0.86 bestätigt** (*„[E-115](Intern/BEFUNDE.md#e-115) tritt bisher nicht mehr auf“*; vorläufig, der Fehler war sporadisch). *(Bis zum 13.10.2026 abends stand hier „Nicht gemessen: dass die Meldung danach ausbleibt“ — [LEKTOR-31](Befunde/LEKTOR-31.md#l-31.2).)*

## 7.2.0.85 — Bilder in der angegebenen Größe gezeichnet (E-112) — **nicht einzeln veröffentlicht, enthalten in `v1.0.87`**

**Von Gregor am 13.10.2026 am Testverzeichnis 1.0.86 bestätigt** (enthält diesen Stand): [E-112](Intern/BEFUNDE.md#e-112) (*„paßt dagegen“*, Bildschirmfoto der Kleinanzeigen-Nachricht: das Logo steht über dem Text, nicht mehr darauf) und damit [E-103](Intern/BEFUNDE.md#e-103).

**[E-112](Intern/BEFUNDE.md#e-112):** Paige spielt die Metadatei eines Bildes als `MM_TEXT` ab, und die Metadatei setzt beim Abspielen selbst `MM_TEXT` (`QCGraphics.cpp`, `MetafileFromImage`). Das Zielrechteck aus 7.2.0.76 bestimmte deshalb nur die **Lage**; gezeichnet wurde in Dateigröße, und der Text lag darauf. Jetzt schreibt `E112MetadateiAusDIB` die Metadatei gleich in der Größe aus `E112Zielrechteck` (angegeben gewinnt, ohne Angabe gilt die Datei – [E-103](Intern/BEFUNDE.md#e-103)). Spurmarke im Ladeweg: `E-112 Metadatei: angegeben=… Datei=… gemalt=…` (`LogLevel` mit 32768).

**Test zuerst:** `Tests/TestE112Metadatei.cpp` spielt die Metadatei in einen Speicher-DC und misst die gemalte Fläche. Vor der Behebung rot (35×35 angegeben, **330×327 gemalt**), danach grün; der Fall ohne Angabe in beiden Richtungen grün. **Testsuite 193/193.**

**Am laufenden Programm gemessen am 13.10.2026, an `a36c47f`** (`C:\Temp\E112-1085`, Titelzeile `1.0.85+a36c47f*`): Prüfnachricht `Testdaten/e112-bilder-groesser-als-angegeben.eml` über `tools/anhang-pruefdaten.pl --pop --nur-eml --eml …` abgerufen und weitergeleitet. Spurmarken `angegeben=35x35 Datei=330x327 gemalt=35x35`, `angegeben=250x96 Datei=985x378 gemalt=250x96`, `angegeben=0x0 Datei=79x64 gemalt=79x64`; das Fensterfoto zeigt alle drei in dieser Größe und kein Bild auf dem Text. Damit liegt auch [E-103](Intern/BEFUNDE.md#e-103) wieder richtig (an 1.0.84 von Gregor widerlegt).

**Danach eingebaut, nach PRÜFER-22** ([Befunde/PRUEFER-22.md](Befunde/PRUEFER-22.md), Urteil zu `a36c47f`: auslieferbar):

* **F1**: ein zweites `<img>` mit derselben Quelle bekam die Größe des ersten, weil Paige Bilder mit gleicher URL teilt. Der erste Versuch (`dae6727`, an `pgNewImageRecord` in `PGEMBED.C`) war **wirkungslos**: `Paige32.dll` wird nicht aus dem Quelltext gebaut (nur `Paige32.vcproj`, nicht in `Eudora.sln`); am laufenden Programm kam dasselbe Logo als 70×70 weiter als 35×35. In `ac8f030` zurückgenommen; F1 sitzt jetzt im Eudora-HTML-Import (`PGHTMIMP.CPP`, `pgNewImageRecord` mit `check_to` 0 — jedes `<img>` bekommt seinen eigenen Datensatz), gemessen am Bau `11b6a3a`, siehe unten. Die Prüfnachricht trägt dafür dasselbe Bild noch einmal als 70×70.
* **F2** (`c294594`), auf Gregors Entscheidung (*„ja, F2 so einbauen wie im browser“*): steht nur `width` oder nur `height` da, folgt die fehlende Seite dem Seitenverhältnis der Datei (`E112Zielrechteck`); bis dahin galt die halbe Angabe als keine. Am Ladeweg wirksam erst mit `11b6a3a` (die halbe Angabe steht dort nur in `source_*`). Tests `TestE112.cpp` (3) und (6) vorher rot, jetzt grün; **Testsuite 193/193**. Prüfnachricht: Banner nur mit `width="150"`, erwartet 150×58.

**F1 und F2 am laufenden Programm gemessen, Bau `11b6a3a` (13.10.2026, `C:\Temp\E112-1085`, dieselbe Prüfnachricht):** `angegeben=35x35 gemalt=35x35`, dasselbe Bild `70x70 gemalt=70x70` (F1), `250x96 gemalt=250x96`, nur `width=150` → `150x0 gemalt=150x58` (F2), ohne Angabe `Datei=79x64 gemalt=79x64` ([E-103](Intern/BEFUNDE.md#e-103)); das Fensterfoto zeigt alle fünf in dieser Größe, kein Text verdeckt. Vorher stand hier, F1 und F2 seien nicht als wirksam gemessen – das galt für die Bauten `dae6727` und `c294594`.

**Danach, nach PRÜFER-23** ([Befunde/PRUEFER-23.md](Befunde/PRUEFER-23.md), Urteil zu F1/F2: auslieferbar): **N1** (`9f5142b`): beim Antworten und Weiterleiten machte der [E-89](Intern/BEFUNDE.md#e-89)-Deckel aus `<img width="1200">` ohne Höhe `width="600" height="1"`, seit [E-112](Intern/BEFUNDE.md#e-112) als Strich gemalt. Jetzt geht nur eine bekannte Höhe mit, die fehlende ergänzt F2. Test `TestE89.cpp` (4b) vorher rot, jetzt grün; **Testsuite 194/194**. **Überarbeitet und gemessen:** am laufenden Programm gemessen (Bau `bf96856`, 13.10.2026): `angegeben=600x0 gemalt=600x230`; die Gegenrichtung (`width="1"`) ist ebenfalls behoben (TestE89.cpp (4c), Testsuite 195/195) und gemessen: `angegeben=0x600 gemalt=606x600`. **Offen:** N2 bis N5, siehe [E-112](Intern/BEFUNDE.md#e-112).

## 7.2.0.84 — Betreff nicht mehr mitten im Wort umbrochen (E-94) — **veröffentlicht als `v1.0.84`**

**Veröffentlicht am 12.10.2026 um 12:59:15 UTC** als `v1.0.84`, auf GitHub damals
*Latest* (abgelöst durch `v1.0.87`); Marke auf `eb54752`, ZIP `Eudora72-1.0.84-release.zip` mit 9 361 952 Byte,
SHA-256 `4b25a26ff55d5759153228b2bf17e3091a4fdc5cd59a2a5e083f32bd18731741` — von
GitHub heruntergeladen und nachgerechnet; die 34 EXE-, DLL- und OCX-Dateien darin
sind byteidentisch mit dem Paket, das Gregor getestet hat. Freigabe: *„dann ein
github release“*, *„ja, beides jetzt“*.

**Gemessen am 12.10.2026** (Rebuild auf `05bbaba`, 0 Fehler, `bauen-Release.log.fehler`
ohne Fehlerzeile; **Testsuite 188/188**; Abruf der sieben Prüfnachrichten über
`tools/anhang-pruefdaten.pl --pop` in `C:\Temp\E94-nachher`):

| | 7.2.0.83 (`C:\Temp\E94-vorher`) | 7.2.0.84 (`C:\Temp\E94-nachher`) |
|---|---|---|
| Fall 06, `Subject:` in `In.mbx` | vier Zeilen, gefaltet bei `bestel` / `len und 1` / `5 Prozent …` / `e!` | **eine Zeile**: `Pruefung E-94: Toner bestellen und 15 Prozent sparen bis zum Wochenende!` |
| Fall 06, Postfachliste (`In.toc`) | `Pruefung E-94: Toner bestel` | `Pruefung E-94: Toner bestellen und 15 Prozent sparen bis zum Wo` (die übliche Feldlänge) |
| Fälle 00–05, Anhänge | alle mit vollem Namen und `.pdf` | **unverändert** heil; Fall 03 hat 216 Zeichen (vorher 217), weil `C:\Temp\E94-nachher\…` einen Buchstaben länger ist als `E94-vorher`; mit Pfad je 259 |

Keine `Exception.log`. **PRUEFER-21:** *kann ausgeliefert werden*; sein niedriger
Befund (einzelnes CR, wenn die Kappung bei `LEX822_TOKEN_MAX` genau auf das CR
fällt) ist in `05bbaba` behoben.

**Über IMAP an Gregors Postfach gemessen, 12.10.2026:** Gregor hat mit Paket
1.0.84 neu abgerufen; ausgewertet von mir, mit seiner Erlaubnis nur gelesen
(`Imap\Dominant\INBOX\INBOX.mbx`, nur die `Subject:`-Zeilen). Darunter ist
**die Toner-Nachricht selbst** (web.de-Webmailer). Ihr Betreff steht jetzt in
**einer** Zeile: `Fw:  [Letzte Chance] Toner  bestellen & 15 % sparen … Nur bis
zum Wochenende! ?` — in seiner 1.0.75-`INBOX.mbx` war dieselbe Nachricht bei
`& 1|5` und `Nur b|is` gefaltet. Von zwei abgerufenen Nachrichten ist keine mehr
gefaltet. Das doppelte Leerzeichen in `Toner  bestellen` stand schon in 1.0.75 so
da (Absender); das Emoji davor erscheint weiter als Fragezeichen bzw. Ersatzzeichen — das ist [**E-90**](Intern/BEFUNDE.md#e-90),
nicht [E-94](Intern/BEFUNDE.md#e-94).

**Von Gregor bestätigt am 12.10.2026**, belegt durch sein Bildschirmfoto von 1.0.84 (Titelzeile `7.2.0.84 / Paket 1.0.84+05bbaba*`): in der Liste `Fw:  [Letzte Chance] Toner  bestellen & 15 % sparen  – Nur bis` (bis zum Spaltenende), im Kopf der geöffneten Nachricht der Betreff in einer Zeile; ebenso `Fw: Jetzt bestellen: 10 % Rabatt aktivieren und Preisvorteil si…`, das vorher als `Rabatt akti` endete. **Beobachtung, nicht [E-94](Intern/BEFUNDE.md#e-94):** der Gedankenstrich vor `Nur bis` steht in der Liste, im Nachrichtenkopf fehlt er (zwei Leerzeichen) — Zeichenumsetzung, verwandt mit [E-90](Intern/BEFUNDE.md#e-90), nicht untersucht.

**Gregors Fall:** *„Toner bestel len & 1 5 % sparen … Nur b is zum Wochenende!"*
— der web.de-Webmailer zerlegt einen langen Betreff in mehrere kodierte Wörter
(`=?UTF-8?Q?…?=`) und faltet dazwischen, die Grenzen mitten im Wort. Das darf er.
RFC 2047, 6.2: der Leerraum zwischen zwei benachbarten kodierten Wörtern wird
ignoriert — **auch eine Faltung**. Eudora ließ sie stehen
(`;//lastEqual += 2; // toast a trailing return`), und beim Anzeigen wurde sie zum
Leerzeichen.

**Gemessen, bevor geändert wurde:**

| | Ergebnis vor der Behebung |
|---|---|
| Testsuite, neu: `Test_GefalteteKodierteWoerter` (POP) und `…Imap` | **rot**: ist `bestel` 0D 0A 20 `len`, soll `bestellen` |
| Prüfnachricht 06 (`tools/anhang-pruefdaten.pl --pop`), 7.2.0.83, `C:\Temp\E94-vorher` | `In.mbx`: `Subject: Pruefung E-94: Toner bestel` / ` len und 1` / ` 5 Prozent …` — **Postfachliste nur `Pruefung E-94: Toner bestel`**, weil `summary.cpp` nur die erste Zeile einer gefalteten Kopfzeile liest |

**Behoben an zwei Stellen, je in POP und IMAP:**

1. **`Fix2047` / `ImapFix2047`:** zwischen zwei kodierten Wörtern fällt jetzt
   auch eine Faltung weg. Ein CRLF **ohne** folgenden Leerraum (Ende der
   Kopfzeile) bleibt wie bisher. Damit sind die Felder geheilt, die
   `ImapDownload.cpp:2276` aus der ganzen Kopfzeile liest.
2. **`Lex822` / `ImapLex822`:** beide Zerleger holen die Kopfzeile **zeilenweise**
   (`LexFill`), `Fix2047` sieht also nie beide Wörter zugleich. `LexFill` hält an
   der **rohen** Zeile fest, ob sie mit einem kodierten Wort endet und die nächste
   mit Leerraum und `=?` beginnt; die Faltungsregel verschluckt dann CR, LF und
   genau diesen Leerraum — nur im unstrukturierten Text (`CollectText`: Betreff,
   Kommentare). Die Mailbox bekommt den Betreff in einem Stück, und damit auch die
   Postfachliste.

**Gegenprobe:** eine Faltung vor **Klartext** bleibt Leerraum (eigener Test).
**Testsuite 188/188**, `tools/kopfzeile-pruefen.pl` **10 Fälle, 0 Abweichungen**
(die Anhangnamen bleiben heil). *(Stand vor dem Bau; gebaut und gemessen siehe
oben.)*

## 7.2.0.83 — `SetExtension` schreibt nicht mehr über kleine Puffer und ersetzt keine Endung (AN-1, elfter Teil) — **gebaut und gemessen**

**Gebaut und gemessen am 12.10.2026:** Rebuild, Rückgabewert 0,
`bauen-Release.log.fehler` ohne eine Fehlerzeile; **Testsuite 185 von 185**;
Abruf der sechs Prüfnachrichten in `C:\Temp\AN5`: **alle sechs mit vollem Namen
und `.pdf`**, dieselben Namen wie unter 7.2.0.81 und 7.2.0.82, kein „kennt den
Typ NICHT", keine `Exception.log`.

**Von Gregor bestätigt, 12.10.2026.** Er hat Paket 1.0.83 selbst über IMAP
getestet (Auswertung unten) und danach geschrieben: *„gekürzt mit endung
reicht, mach PR für an1-endungen"*. PR #84 hat er um 10:51 UTC gemergt und
dann angewiesen: *„erstelle ein release auf github"*. **Veröffentlicht als
`v1.0.83`** am 12.10.2026 um 11:18:20 UTC, auf GitHub damals als *Latest* (abgelöst durch `v1.0.84`); Marke auf
`ec9f11d`, ZIP `Eudora72-1.0.83-release.zip` mit 9 361 416 Byte, SHA-256
`7cef4852645d053ca6e4fde3855e9294e3cbb22698e30687eed176be3c88f3eb` — von GitHub
heruntergeladen und nachgerechnet. Die 34 EXE-, DLL- und OCX-Dateien darin sind
byteidentisch mit dem Paket, das Gregor getestet hat.

**Von Gregor über IMAP getestet, 12.10.2026, Paket 1.0.83** (sein `eudora.log`,
vier Sitzungen ab 12:25, `LogLevel=91295`; ausgewertet von mir, nur gelesen):

| vom Server (BODYSTRUCTURE) | gespeichert als |
|---|---|
| `5G-SA-NSA-Analyse_asn1Viewer_20260910.docx` (42) | unverändert, Inhalt `PK` |
| `5G-SA-NSA-Analyse_asn1Viewer_20260910.pdf` (41) | unverändert, Inhalt `%PDF` |
| `x_Releases_SIC-25.1.4-ZITiS_…_Archiv_20260918_Sina.tar.zip` (229) | auf 175 gekürzt **mit `.zip`**, voller Pfad 258 — die Windows-Grenze von 260; Inhalt `PK`, 351 502 Byte |

Der IMAP-Weg verliert also keine Endung. Was bei einem sehr langen Namen
wegfällt, ist das Ende des **Stamms** (hier `…_DBAutoUpdate-…Sina.tar`), weil
der volle Pfad sonst über 260 Zeichen ginge — vollständig ginge das nur mit
Langpfaden (`\\?\`). Unter dem gekürzten Namen liegt die Datei inzwischen nicht mehr; im Verzeichnis stehen zwei gleich große Kopien (351 502 Byte, 12:32) unter anderen Namen — vermutlich von Gregor umbenannt, nicht nachgefragt. **Nebenbefund, nicht aus 1.0.83:** zwei PDFs im selben
Anhangverzeichnis von 08:44/08:45 (vor 1.0.83, laut Log 7.2.0.77), je
1 204 Byte, beginnen **nicht** mit `%PDF` — Ursache nicht untersucht.

**Anlass: PRUEFER-20**, die Nachrechnung von 7.2.0.81. Seit Teil 9 läuft
`MIMEMap::SetExtension` zum ersten Mal überhaupt — und damit auch an Stellen,
deren Puffer kleiner sind als `_MAX_PATH`, auf das es kürzte:

| Aufrufer | Puffer | was passiert wäre |
|---|---|---|
| `Eudora/uudecode.cpp:88` | `m_Name[255]` | uuencodierter Teil mit Namen ab 251 Zeichen: bis zu 5 Byte über den Stapel |
| `Eudora/hexbin.cpp:312`, `EuImap/src/ImHexbin.cpp:374` | `m_Name[40]` | BinHex-Name mit 35 bis 38 Zeichen: 1 bis 4 Byte in den Dekodierzustand |

**Behoben:** `SetExtension(Filename, nPuffer)` kürzt auf den Puffer des
Aufrufers; die drei Aufrufer geben `sizeof` mit, alle anderen haben
`_MAX_PATH + 1` und nehmen die Vorgabe.

**Zweitens, eine Regel, die Gregors Ziel widersprach:** QUALCOMM **ersetzte**
eine vierstellige Endung durch die aus der Zuordnung — `.docx` wurde `.doc`,
`.jpeg` wurde `.jpg`, und aus *Rechnung vom 12.03.2025* wurde
*Rechnung vom 12.03.pdf*. Gelebt hat das bis 7.2.0.80 nie. Jetzt wird **nie
ersetzt**: eine vorhandene Endung (1 bis 5 Zeichen, mindestens ein Buchstabe,
kein Leerzeichen) bleibt, sonst wird angehängt.

**Gemessen außerhalb von Eudora** (der Rumpf wörtlich aus `MIMEMap.cpp`, mit
`cl` übersetzt): zehn Fälle, darunter alle drei Puffergrößen — kein Byte hinter
dem Puffer beschrieben, `.docx`/`.jpeg` bleiben, *…12.03.2025* wird
*…12.03.2025.pdf*.

**Noch offen aus PRUEFER-20:** `hexbin.cpp:276` und `ImHexbin.cpp:333` schreiben
den BinHex-Namen **ohne jede Grenze** in `m_Name[40]` — das war schon vorher
erreichbar und ist hier nicht behoben. Beim **Versand** kommt der Content-Type
jetzt aus der Zuordnung; weil nur drei Zeichen verglichen werden, geht `.docx`
als `application/msword` hinaus — **nicht gemessen**.

## 7.2.0.82 — AN-1 und AN-2 zusammengeführt — **gebaut und gemessen**

Gregor hat am 12.10.2026 um 09:40 UTC PR #83 ([**AN-2**](Intern/BEFUNDE.md#an-2), Zweig
`fix_startup_page`, Quellstand 7.2.0.80) nach `main` gemergt, während auf
`an1-endungen` schon 7.2.0.80-an1 und 7.2.0.81 gebaut und gemessen waren. Dieser
Stand führt beide zusammen und nimmt die nächste freie Nummer. [AN-2](Intern/BEFUNDE.md#an-2) wird damit
zum ersten Mal übersetzt.

**Gebaut und gemessen am 12.10.2026:** `bauen.ps1 -Ziel Rebuild`, Rückgabewert 0,
`bauen-Release.log.fehler` ohne eine Fehlerzeile. **Testsuite 185 von 185
bestanden** (`Eudora71/Tests/RunTests.cmd`). Abruf der sechs Prüfnachrichten in
`C:\Temp\AN4`: **alle sechs mit vollem Namen und `.pdf`**, dieselben Namen wie
unter 7.2.0.81, kein „kennt den Typ NICHT", keine `Exception.log`.
**[AN-2](Intern/BEFUNDE.md#an-2) ist am laufenden Programm nicht gemessen** — der Werbefensterfall lässt
sich mit dem Prüfstand nicht auslösen.

## 7.2.0.81 — Endungen aus dem MIME-Typ wirken wieder (AN-1, neunter und zehnter Teil) — **gebaut und gemessen: alle sechs heil**

**Gemessen am 12.10.2026** (Rebuild, 0 Fehler, `C:\Temp\AN3`, ein Abruf über
`tools/anhang-pruefdaten.pl --pop`):

| Fall | gespeichert |
|---|---|
| 00 | `Rechnung.pdf` |
| 01 | `Angebot Nr 4711 fuer die Stadtwerke Musterstadt Abrechnungszeitraum 2025.pdf` (76) |
| 02 | `Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf` (56) |
| 03 | `<220×A>.pdf` (224 — der volle Pfad bleibt unter 260; die Endung bleibt) |
| 04 | `Angebot Nr 4711 fuer die Stadtwerke Musterstadt 20251.pdf` (57 — gleicher Name wie 02, Eudora hängt `1` an) |
| 05 | `Pruefung AN-1 leerer Dateiname.pdf` (34 — Betreff, **jetzt mit Endung** aus `MIMEMap`) |

Alle sechs Dateien beginnen mit `%PDF-`, keine `Exception.log`. Im Log steht bei
jedem Anhang `ANHANG Name: nach MIMEMap::SetExtension`, kein „kennt den Typ NICHT"
mehr.

**7.2.0.80-an1 gebaut und gemessen am 12.10.2026** (Rebuild 0 Fehler, `C:\Temp\AN2`,
ein Abruf): **Fall 03 heil** — `<220×A>.pdf`, 224 Zeichen mit Endung. Marke 2
meldet keine Faltung mehr. **Fall 05 weiter ohne Endung.** ANHANG-Marke 11 nannte
den Grund bei **jedem** Anhang: `GetMaps scheitert … (342)`.

**Neunter Teil, gemessen:** 342 = 123 Zuordnungen aus `Eudora.ini` + 124 aus
`DEudora.ini` + **95** aus der Registry. Der 96. Typ mit Endung unter
`HKCR\Mime\Database\Content Type` heißt **`pkcs10`** — **ohne Schrägstrich**
(auf diesem Rechner zwölf solche, alle aus der Zertifikatsfamilie). Daran stieg
`GetMaps` mit `return (FALSE)` aus und verwarf die **ganze** Tabelle samt
`[Mappings]`. Weil jeder Anhang ein neues `MIMEMap` anlegt, scheiterte `Find`
bei **jedem** Anhang, und `SetExtension` trug über POP **nie** eine Endung nach —
auch in echter Post, nicht nur im Prüffall. Behoben: solch ein Schlüssel wird
übersprungen.

**Zehnter Teil (PRUEFER):** `SetExtension` hatte beim Kürzen das falsche
Vorzeichen — `Difference` negativ, `while (Difference--)` lief bis zum
int-Überlauf rückwärts durch den Speicher. Verdeckt nur, weil `Find` nie gelang;
mit Teil 9 wäre es bei einem Namen ab 255 Zeichen ein Absturz geworden. Behoben:
der Stamm wird vor der neuen Endung gekürzt.

## Messfassung 7.2.0.80-an1 — Anhangnamen: lange Namen behalten die Endung (AN-1, achter Teil) — **gebaut und gemessen, Nummer doppelt vergeben**

> Diese Fassung trug in `Version.h` **7.2.0.80** — dieselbe Nummer wie [AN-2](Intern/BEFUNDE.md#an-2) auf
> `main` (PR #83, Abschnitt weiter unten). Beide entstanden am 12.10.2026 auf
> getrennten Zweigen. Diese hier gab es nur als Prüfbau in `C:\Temp\AN2`; sie ist
> nie ausgeliefert worden. Zur Unterscheidung heißt sie hier `7.2.0.80-an1`.

**7.2.0.79 ist am 12.10.2026 zum ersten Mal übersetzt und am laufenden Programm
gemessen worden:** `bauen.ps1 -Ziel Rebuild`, Rückgabewert 0,
`bauen-Release.log.fehler` leer (0 Zeilen). Prüfverzeichnis `C:\Temp\AN1`,
`LogLevel=91295` in `[Debug]`, die sechs Prüfnachrichten über
`perl tools/anhang-pruefdaten.pl --pop` abgerufen.

| Fall | gespeichert unter 7.2.0.79 | Urteil |
|---|---|---|
| 00 Gutfall | `Rechnung.pdf` | heil |
| 01 gefaltet, Leerzeichen | `Angebot Nr 4711 fuer die Stadtwerke Musterstadt Abrechnungszeitraum 2025.pdf` (76) | **B5.1 wirkt** |
| 02 gefaltet, Tabulator | `Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf` (56) | **B5.1 wirkt** |
| 03 304 Zeichen | 224 × `A`, **ohne `.pdf`** | **kaputt** |
| 04 RFC 2231 | `Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf` (56) | **B5.5 wirkt** |
| 05 `filename=""` | `Pruefung AN-1 leerer Dateiname` — **ohne Endung** | kein `=` mehr (B5.2), aber keine Endung |

**Fall 03, Ursache aus dem Log:** die Kopfzeile lieferte alle 304 Zeichen
(B5.3 wirkt). Dann kappten zwei Stellen **von hinten**: `strncpy` auf 259 in
`mime.cpp` (dazu ohne abschließende Null) und `DeMacifyName32` auf 255. Danach
kürzte `CheckName` den Pfad auf 224 — **mit** Endung, aber die war da schon weg.

**Behoben in 7.2.0.80-an1:** `AnhangNameKuerzen` (`QCUtils/src/rfc2231.cpp`) kürzt
und behält die Endung; `mime.cpp` und beide `DeMacifyName32` (POP und IMAP)
benutzen es. Ein leeres `filename=""` verdeckt ein vorhandenes `name=` nicht mehr.

**Fall 05 und alle anderen:** Marke 5 meldete bei **allen sechs** „MIMEMap kennt
den Typ NICHT" — auch für `application/pdf`, das in `[Mappings]` steht. Die
Ursache ist **nicht** geklärt; **ANHANG-Marke 11** in `MIMEMap::Find` nennt jetzt
jeden Ausstieg. *Stand 12.10.2026: geklärt in 7.2.0.81 (Registry-Typ `pkcs10`,
neunter Teil). Marke 11 nennt jeden Ausstieg außer dem ersten,
`if (!ms || !ms->m_hd)` — der bleibt stumm.*

**Marke 2 berichtigt** (beide Zerleger): sie fragte nach dem CR und meldete seit
B5.1 jede heil durchgekommene Faltung als Abbruch. Sie fragt jetzt nach dem LF.
## 7.2.0.80 — JavaScript und CSS verschwinden aus der Anzeige (AN-2), **nicht übersetzt**

> **Hier ist nichts gebaut und nichts gestartet.**
>
> *Stand 12.10.2026: übersetzt erst als Teil von 7.2.0.82 (Rebuild 0 Fehler,
> Testsuite 185/185); am laufenden Programm **nicht gemessen** — der
> Werbefensterfall lässt sich mit dem Prüfstand nicht auslösen.*
>
> **Stand 13.10.2026 ([L-27.4](Befunde/LEKTOR-27.md#l-27.4)): von Gregor an 1.0.84 bestätigt** —
> *„HTML newsletter (weiter geleitet) wird korrekt dargestellt.“* Der Werbeweg
> unten ist an diesem Bau **nicht** auslösbar: Punkt 1 ist widerlegt (Vorgabe
> `Mode=2`), und auch mit `Mode=0` kam an 1.0.84 kein Abruf. Gregor hat
> entschieden, die Werbe-Betriebsart nicht weiter zu verfolgen
> ([AN-2](Intern/BEFUNDE.md#an-2)).

Gregor am 12.10.2026: *„nachdem eudora gestartet wurde, ist es innerhalb eines
Fensters darin angezeigt worden. ohne daß ich etwas gemacht habe."* Eingefügt
hatte er kein Text, sondern das Innenleben einer Webseite — New Relic, Google
Tag Manager, Microsoft Clarity, Disqus, `schema.org`, `var wpcf7 = {…}`.

**Der Weg dahin, ganz aus dem Quelltext:**

1. Eine frische `Eudora.ini` hat kein `[Settings] Mode`, also greift
   `DEFAULT_SWM_MODE` — und das ist **0 = Werbe-Betriebsart**
   (`QCSharewareManager.h`, `BUILD_BOX_OR_SITE_R_VERSION` ist nicht gesetzt). **[widerlegt 13.10.2026: der Schalter ist seit `bf14e14` gesetzt, Vorgabe ist 2 = Pro; siehe [AN-2](Intern/BEFUNDE.md#an-2)]**
2. Der Playlist-Client holt Werbung von `//adserver.eudora.com/adjoin/playlists`
   (`plist_mgr.cpp:213`). **Diese Adresse gehört seit 2018 dem Computer History
   Museum** — nachzulesen in dessen eigener Ankündigung zur Quelltextfreigabe.
3. `CAdView::loadEntry` gibt eine `text/html`-Antwort an Paige, denn
   `class CAdView : public CPaigeEdtView` — das Werbefenster ist kein Browser.
4. **Paige kannte kein Element, dessen Inhalt kein Text ist.** `script` fehlte in
   `control_commands` (`PGHTMDEF.C`), `style` stand darin **ohne Behandlung**.
   Behandelt war genau einer: `<title>`, über `inside_title`.

**Geändert:** neuer Merker `inside_script` nach genau diesem Muster — gesetzt bei
`<script>` und `<style>`, abgefragt an allen vier Ausgabestellen. Vier Dateien.

**Gemessen:** neu `tools/html-tags-pruefen.pl` — **30 Fälle, 0 Abweichungen**.
Das Werkzeug zieht `table_command`, die Tag-Tabelle und die Aufzählung wörtlich
aus dem Baum und prüft jedes Paar gegen eine von Hand geschriebene Sollliste.
**Gegenprobe gefahren:** hängt man `script` hinten an die Tabelle statt an die
richtige Stelle, meldet es **sieben** Abweichungen.

> **Warum dafür ein eigenes Werkzeug nötig war.** `table_command`
> (`PGHTMIMP.CPP:3469`) gibt die **Position** eines Tags in der Zeichenkette
> zurück, und diese Position *ist* der Befehlswert — den die Aufzählung in
> `PGHTMDEF.H` ein zweites Mal von Hand vergibt. Dazu bricht die Suche ab,
> sobald der erste Buchstabe eines Eintrags größer ist als der gesuchte
> (`:3502`). Verschiebt sich eines gegen das andere, heißt `<title>` plötzlich
> `<ul>`; ein hinten angehängter Tag wird nie gefunden. **Beides meldet kein
> Übersetzer.**

**Nicht behoben, und das ist die eigentliche Frage:** Eudora holt beim Start
weiterhin Werbung von einem Rechner, der jemand anderem gehört. Ob das so
bleiben soll, ist eine Entscheidung über das Produkt — die drei Wege stehen in
[AUFGABEN.md](Intern/AUFGABEN.md), **B6**. **[Überholt 13.10.2026: an 1.0.84 holt
Eudora keine Werbung — weder mit frischer INI noch mit `Mode=0`; Gregor hat
die Frage entschieden, die Werbe-Betriebsart wird nicht weiter verfolgt.]**

---

## 7.2.0.79 — Anhangnamen: sechs von sieben Ursachen geändert (AN-1), **nicht übersetzt**

> **Hier ist nichts gebaut und nichts gestartet.** Die Sitzung lief ohne Windows
> und ohne Compiler. Was gemessen ist, steht in der Tabelle; alles andere ist
> aus dem Quelltext begründet und wartet auf einen Bau.
>
> *Stand 12.10.2026: 7.2.0.79 ist am selben Tag übersetzt und gemessen worden —
> 4 von 6 Prüffällen heil, siehe Messfassung 7.2.0.80-an1. Aus den sieben Teilen
> wurden elf (B5.8 bis B5.11 in 7.2.0.80-an1, 7.2.0.81 und 7.2.0.83).*

Gregors Ziel vom 12.10.2026: *„anhänge werden korrekt gespeichert - mit
erweiterung, komplette dateiname"*. Bis zu dieser Fassung lag die Arbeit zu
[**AN-1**](Intern/BEFUNDE.md#an-1) als zwei Patchdateien **neben** dem Code. Jetzt steht sie drin, und die
beiden Dateien sind entfernt.

| Teil | Was | Gemessen |
|---|---|---|
| **B5.1** | **Eine Faltung beendet die Zeichenkette nicht mehr.** `CollectQText` nimmt das CR in die Marke, wenn ein LF folgt, und entscheidet erst am LF; `WriteHeaderToken` setzt es hinter das schließende Anführungszeichen; `AddAttribute` löst `CRLF`+Weiß zu einem Leerzeichen auf | ja — `kopfzeile-pruefen.pl`: 76 Zeichen **mit** `.pdf` statt 47 ohne, Rückschrieb byteidentisch |
| **B5.2** | **`Token[0] = 0;` beim Neuanfang.** `filename=""` wurde zum Wert `=`, weil die leere Marke noch das erste Byte der vorigen trug | ja — `""` statt `"="` |
| **B5.3** | **Marke von 256 auf 1024.** Ein Name nach `_MAX_PATH` (260) passte nicht in `BYTE Token[256]` und verlor bei 254 Zeichen seine Endung. Die Zahl heißt jetzt `LEX822_TOKEN_MAX` und steht **einmal** — beide Zerleger und beide `AddAttribute` holen sie von dort | ja — 304 Zeichen **mit** `.pdf` statt 254 ohne |
| **B5.4** | **Zwei Puffer über den Rand.** `DeMacifyName32` schrieb ein Byte hinter `pcname[255]`. **Neu gefunden:** `DeMacifyName` (8+3) schrieb bis zu **drei** Byte über — `pcname[15]`, und 8 + Punkt + 8 + Null sind 18; der zweite Zähler stand auf 8 statt 3 | nein — aus dem Quelltext gerechnet |
| **B5.5** | **RFC 2231.** `filename*0*=UTF-8''…` kannte der Baum nicht. Dann gab es **gar kein** `filename`, und `mime.cpp` nahm den **Betreff** aus `subj[32]` — 31 Zeichen ohne Endung. Neu: `QCUtils/src/rfc2231.cpp`, benutzt von POP **und** IMAP, inklusive UTF-8 nach ANSI | ja — `rfc2231-pruefen.pl`: **20 von 20** Fällen |
| **B5.6** | **`LOCAL_CheckName`: `char tmp[255]`**, beschrieben mit bis zu 256 Byte. Trifft jeden Anhangnamen ab 255 Zeichen **ohne Punkt**, und der Name kommt vom Server. Nur IMAP — das POP-Gegenstück ist auf `CString` umgebaut | nein — aus dem Quelltext gerechnet |
| **[B5.7](Intern/AUFGABEN.md#b5.7)** | **Über IMAP gibt es kein `MIMEMap::SetExtension`** — das Sicherheitsnetz für eine fehlende Endung fehlt dort ganz | **offen.** Es hängt an einer Bindefrage, nicht an der Logik: siehe AUFGABEN.md, [B5.7](Intern/AUFGABEN.md#b5.7) |

**Zehn Debug-Marken** auf dem Weg des Namens (*seit 7.2.0.80-an1 elf, mit Marke 11 in
`MIMEMap::Find`*), Bit `DEBUG_MASK_ATTACH = 0x10000`,
einzuschalten mit `LogLevel=91295` in der Gruppe **`[Debug]`** der `eudora.ini`.
Alles, was sie schreiben, beginnt mit `ANHANG`. Die POP-Marken 1 bis 8 und die
IMAP-Marken 1 bis 3 sind **am laufenden Programm gemessen** — Gregors
`eudora.log` zu 7.2.0.77 enthält 285 solche Zeilen, und der Schalter steht dort
als `LogLevel 91295 (0x1649F)` im Logkopf.

**Zwei Angaben von [AN-1](Intern/BEFUNDE.md#an-1) sind dabei widerlegt worden**, beide aus demselben Log:

1. Es stand dort, jede Ursache stecke **doppelt** im Baum. Für den Anhangnamen
   stimmt das nicht — über IMAP kommt er aus der **BODYSTRUCTURE**-Antwort des
   Servers (`GetFilenameParameter`), nicht aus `Lex822`. Die Faltung hat der
   Server da längst aufgelöst.
2. Der IMAP-Weg hatte **keine einzige** Marke für den Dateinamen: die Marken 4
   bis 8 lagen in `Eudora/mime.cpp`, also im POP-Weg.

**Nebenbefund, gemessen:** die 254-Zeichen-Kappung schlug in **vier** Nachrichten
**281 Mal** zu — auf `DKIM-Signature` und `X-UI-Filterresults`. Dort folgenlos,
aber B5.3 war damit kein Randfall, sondern der Normalfall gewöhnlicher Post.

**Werkzeuge:** neu `tools/rfc2231-pruefen.pl` (20 Fälle). `tools/kopfzeile-pruefen.pl`
reparierte zwei eigene Lücken: es übersetzte nicht mehr, sobald die Debug-Marken
im Baum standen, und es hielt die Markengröße mit einer **eigenen** 256 fest,
statt sie aus `lex822.h` zu holen — damit hätte es B5.3 nie gesehen.

---

## 7.2.0.78 — Gregors Bau von `main`, **ohne jede Änderung an den Anhängen**

**Keine Fassung dieses Zweigs.** Gregor hat am 12.10.2026 `main` gebaut und die
Nummer dabei lokal gehoben; auf `main` stand und steht dieser Stand nicht
(`Version.h` sprang dort von 76 auf 79).

Er fragte: *„was habe ich jetzt in der version 078 gebaut?"* Die Antwort war
**nichts, was die Anhänge betrifft**. Der damals gemergte PR #81 hat keine
einzige Datei unter `Eudora71/` angefasst — nur `AUFGABEN.md`, `BEFUNDE.md`,
`tools/ZWEIGE.md`, `tools/kopfzeile-pruefen.pl` und die beiden Patchdateien.
Die Behebung lag als Patch **neben** dem Code. Genau das ist mit 7.2.0.79
abgestellt.

Festgehalten, weil eine Nummer ohne Abschnitt eine Blackbox ist — auch dann,
wenn sie nur auf einem Rechner existiert.

---

## 7.2.0.77 — Gregors Messbau mit den Debug-Marken (AN-1)

**Keine Fassung dieses Zweigs**, sondern ein Bau von `main` **plus**
`git apply` der damaligen Markendatei, am 12.10.2026 um 08:37, Release,
Rebuild, 0 Fehler. Die Bau-Kennung trug deshalb ein `*`: ungesicherte
Änderungen im Baum, der Bau also absichtlich nicht reproduzierbar.

**Das war die erste Messung von [AN-1](Intern/BEFUNDE.md#an-1) außerhalb des Prüfstands**, und sie hat
drei Dinge belegt:

| | |
|---|---|
| Der Schalter | `LogLevel 91295 (0x1649F)` steht im Logkopf. Die Angabe `[Debug] LogLevel=91295` ist damit nachgemessen |
| Die Marken | **285 `ANHANG`-Zeilen**; `PutDebugLogSichtbar` macht Steuerzeichen als `<CR><LF><TAB>` sichtbar, wie vorgesehen |
| Der Befund selbst | **nicht getroffen** — der Abruf lief über IMAP, die vier Nachrichten hatten keine Anhänge, und der IMAP-Weg hatte damals keine Marke für den Dateinamen |

Herausgekommen ist stattdessen ein Nebenbefund: die 254-Zeichen-Kappung schlug
in vier Nachrichten **281 Mal** zu. Und zwei Angaben von [AN-1](Intern/BEFUNDE.md#an-1) waren widerlegt —
beide stehen berichtigt in [BEFUNDE.md](Intern/BEFUNDE.md).

---

## 7.2.0.76 — Versuch zu E-112: wirkt NICHT

> **Berichtigt am 18.09.2026, noch am selben Tag.** Dieser Abschnitt hat
> *„[E-112](Intern/BEFUNDE.md#e-112) behoben"* behauptet. **Der Versuch wirkt nicht** — von Gregor am
> laufenden Programm widerlegt, mit Bildschirmfoto: die Bilder sind weiterhin
> zu groß, **und der Text liegt jetzt wieder darauf**, weil die Zeile nur noch
> die angegebene Höhe hat. **1.0.76 ist damit in einem Punkt schlechter als
> 1.0.75.**
>
> **Warum, am Quelltext gemessen:** `draw_meta_file`
> (`PaigeDLL/PGSOURCE/PGEMBED.C:4085-4125`) skaliert nur, wenn
> `pict_data.mapping_mode` **nicht** `MM_TEXT` ist. Bei jedem aus dem Netz
> geladenen Bild ist er `0` und wird auf `MM_TEXT` gesetzt — dann bestimmt das
> Zielrechteck allein die **Position**, nicht die **Größe**. Meine Annahme
> *„eine Metadatei wird auf ihr Zielrechteck gestreckt"* gilt nur für andere
> Abbildungsarten.
>
> **Was bleibt und richtig ist:** `E112Zielrechteck` liefert das richtige
> Rechteck — sieben Tests, Gegenprobe gefahren. Nur der Zeichenweg setzt es
> nicht um. **[E-112](Intern/BEFUNDE.md#e-112) steht wieder unter *Noch offen*.**


`pict_frame` — das Zielrechteck, in das Paige eine Metadatei streckt — bekam
bis dahin die **echte Dateigröße**. Das WhatsApp-Symbol wurde deshalb mit
330×327 gezeichnet, obwohl es als 35×35 ausgezeichnet ist.

Das war eine Regression der **[E-106](Intern/BEFUNDE.md#e-106)**-Behebung: sie vergrößerte die **Zeile**,
statt das **Bild** zu verkleinern. Solange [**E-110**](Intern/BEFUNDE.md#e-110) offen war, lud kaum ein
Bild und es fiel nicht auf.

**Die Regel steht jetzt in einer eigenen Funktion `E112Zielrechteck`**, die ohne
Paige, ohne Fenster und ohne ein einziges Bild prüfbar ist — genau das fehlte
bei [E-106](Intern/BEFUNDE.md#e-106), wo dieselbe Entscheidung mitten im Ladeweg stand und nur an Gregors
Rechner messbar war:

| Fall | was gilt |
|---|---|
| vollständige Angabe im HTML | **die Angabe** — das Bild wird hineingestreckt |
| keine oder halbe Angabe | **die Datei** — das ist [**E-103**](Intern/BEFUNDE.md#e-103) |
| nichts bekannt | nichts wird geändert |

**185 Tests, 185 bestanden** (sieben neue). Die Gegenprobe ist gefahren: mit der
alten Regel fallen **drei** davon um, während die E-103-Fälle, die halbe Angabe
und die Ränder in **beiden** Richtungen grün bleiben.

### Prüfanleitung

Dieselbe Nachricht öffnen und **antworten**. Die Bilder müssen so groß sein wie
im Lesefenster — kein Symbol, das das halbe Fenster füllt, und kein Text, der
von einem Bild zugedeckt wird.

### Was das nicht behebt

[**E-113**](Intern/BEFUNDE.md#e-113) — ein Bild, dessen **angegebene** Breite größer ist als das Fenster,
läuft weiterhin rechts hinaus. Das ist die Regel, die Newsletter mit
`max-width:100%` meinen; Paige kennt kein CSS. Auf Gregors Anordnung *„erst A,
dann B"* bewusst nicht mitbehoben.

## 7.2.0.75 — Bilder mit Leerzeichen im Namen kommen wieder an (E-110 **behoben**)

`resolve_URL` (`HTMLUtils.cpp`) warf **jede** Prozent-Sequenz weg, statt sie zu
entschlüsseln: im `%`-Zweig wurde das entschlüsselte Zeichen nach `*output`
geschrieben, der Zeiger aber nicht weitergerückt — das nächste Zeichen
überschrieb es. Das Zeichen war nicht falsch, sondern **weg**.

Aus `en%20aktuellen%20Verlust.png` wurde `enaktuellenVerlust.png`, der Server
antwortete mit **404**, Eudora legte die Fehlerseite ab, erkannte sie
richtigerweise nicht als Bild und zeichnete einen grauen Kasten. **Zehn von
zwanzig Bildern** in Gregors Nachricht.

Die Behebung ist ein `++output;`. Betroffen war jede Sequenz, also auch
Umlaute in Dateinamen (`%C3%BC`), Klammern (`%28`) und Schrägstriche (`%2F`) —
der Fehler steckt im Originalcode von QUALCOMM. Zwanzig Zeilen darunter steht
`unescape_url`, das dasselbe tut und es seit jeher richtig tut.

**178 Tests, 178 bestanden** (sieben neue). Die Gegenprobe ist gefahren: ohne
die Behebung fallen **vier** der sieben um, mit genau den Zeichenketten aus dem
Protokoll; die drei anderen prüfen den *erlaubten* Fall und bleiben in beiden
Richtungen grün. Der Maßstab kommt aus dem Programm selbst — ein Test hält
`resolve_URL` gegen `unescape_url`.

### Von Gregor bestätigt — und was dabei sofort sichtbar wurde

**Am 18.09.2026 an 1.0.75 am laufenden Programm bestätigt:** die grauen Kästen
sind weg. Sein Protokoll belegt es in Zahlen — **49 × `datei=1 intern=1`, kein
einziges `intern=0` mehr** (vorher zehn abgewiesene Adressen).

**Im selben Lauf ist [E-112](Intern/BEFUNDE.md#e-112) sichtbar geworden:** die Bilder erscheinen jetzt in
**Originalgröße** statt in der angegebenen — das WhatsApp-Symbol ist als
`35x35` ausgezeichnet und die Datei hat `330x327`. Das ist **kein Rückfall von
[E-110](Intern/BEFUNDE.md#e-110)**, sondern eine Regression der **[E-106](Intern/BEFUNDE.md#e-106)**-Behebung: sie schreibt die echte
Dateigröße ins Embed, damit die Zeile hoch genug wird, und bis jetzt luden
schlicht zu wenige Bilder, als dass es aufgefallen wäre. Siehe *Noch offen*,
[**E-112**](Intern/BEFUNDE.md#e-112).

### Prüfanleitung

Dieselbe Nachricht öffnen und **antworten**. Die grauen Kästen müssen weg sein.
Im Protokoll steht bei diesen Bildern dann `datei=1 intern=1` und ein `daten=`
ungleich 0.

### Was das *nicht* behebt

`loader_result` bleibt weiterhin `0`: schlägt ein Bildabruf aus einem anderen
Grund fehl, meldet Eudora es nirgends und stellt wortlos einen grauen Kasten
hin. In [**E-110**](Intern/BEFUNDE.md#e-110) vermerkt. Dazu [**E-111**](Intern/BEFUNDE.md#e-111) — `resolve_URL` kann bei einer
Adresse von genau 512 Zeichen ein Byte hinter das Zielfeld schreiben.

## 7.2.0.74 — `datei=` und `intern=` trennen die letzte Alternative (E-110, **Messfassung**)

**Behebt nichts.** 1.0.74 ist wie 1.0.73 eine Messfassung; veröffentlicht ist
weiterhin `v1.0.72`.

**Was 1.0.73 an Gregors Lauf gemessen hat.** Zehn Bilder, 31 Rufe. **Fünf**
werden geladen (`daten` gesetzt, `art=9`, jeweils beim **zweiten** Ruf),
**fünf** geben auf (`ok=0 daten=0`, nach zwei bis fünf Versuchen). Die fünf
Aufgebenden sind nachweislich die grauen Kästen: der Kasten unmittelbar über
*„Sven von Storch"* ist `SvSunterschriftbeschnitten.jpg` (250×96), der nach
*„Jetzt hier spenden"* ist `SpendenbannerFW2019neu.jpeg` (540×240).

**Drei meiner Erklärungen sind damit widerlegt:**

* Der Wiederholungsmechanismus **funktioniert** — die Erfolgreichen bekommen
  ihre Daten beim zweiten Ruf. Das von QUALCOMM versprochene *„später"* tritt
  also sehr wohl ein.
* `faden=1` durchgehend: der Abruf ist **erlaubt**, nicht gesperrt.
* `fehler=0` durchgehend: `loader_result` wird **nirgends** gesetzt — Eudora
  vermerkt das Scheitern nicht einmal.

Die Größe allein erklärt es nicht: ein Bild mit 600×146 kommt durch, eines mit
250×96 nicht.

**Was 1.0.73 nicht trennen konnte.** `ok=0` zusammen mit `daten=0` hat im
Quelltext **zwei** mögliche Ursachen: entweder liefert `fetch_url_schmookie`
den Wert `-1` und der Abruf kommt gar nicht zustande, oder die Datei **ist
da** und weder `MetafileFromImage` noch QuickTime können sie umwandeln. Im
ersten Fall liegt der Fehler im Abrufweg, im zweiten im Bilddecoder — und das
Bild läge längst auf der Platte. Zwei ganz verschiedene Behebungen.

**Neu in der Zeile:** `datei=` und `intern=`.

### Die Ursache von E-110 ist gemessen — `resolve_URL` wirft Prozent-Sequenzen weg

Die Messfassungen 1.0.73 und 1.0.74 haben den Fehler eingegrenzt und am
18.09.2026 endgültig bestimmt. **Die Behebung ist noch nicht drin** — dies ist
der Befundstand, nicht der Behebungsstand.

`resolve_URL` (`HTMLUtils.cpp:31-42`) schreibt im `%`-Zweig das entschlüsselte
Zeichen nach `*output`, **rückt `output` aber nicht weiter**; der `else`-Zweig
tut es mit `*output++ = *input++`. Das nächste Zeichen überschreibt das
entschlüsselte — es ist nicht falsch, sondern **weg**.

Nachgerechnet: `en%20aktuellen%20Verlust.png` wird zu
`enaktuellenVerlust.png`, `SVS%20NL%20FW%20(1).jpg` zu `SVSNLFW(1).jpg`.
Beides steht genau so in Gregors Protokoll, der Server antwortet darauf mit
**404**, Eudora legt die Fehlerseite ab (`datei=1`), erkennt sie richtigerweise
nicht als Bild (`intern=0`) und zeichnet einen grauen Kasten.

Die Aufteilung ist lückenlos: alle **zehn** abgewiesenen Adressen tragen
Leerzeichen, alle **vierzehn** erfolgreichen keines. Nicht die Größe — ein Bild
mit 600×146 kommt durch, eines mit 250×96 nicht.

**Der Fehler ist größer als der Bildweg** und trifft jede Prozent-Sequenz, also
auch Umlaute in Dateinamen (`%C3%BC`) und Klammern (`%28`). Er steckt im
Originalcode von QUALCOMM.

Dazu ein zweiter, eigenständiger Mangel aus demselben Lauf: `loader_result`
bleibt **durchgehend 0** — ein fehlgeschlagener Bildabruf wird nirgends
vermerkt.

Neu aufgenommen: [**E-111**](Intern/BEFUNDE.md#e-111) (`resolve_URL` kann bei einer Adresse von genau
512 Zeichen ein Byte hinter das Zielfeld schreiben; Schranke prüft `>` statt
`>=`).

### Prüfanleitung

Auf dieselbe Nachricht antworten, Eudora beenden, `eudora.log` sichern. Zu
lesen ist:

| Zeile | Bedeutung |
|---|---|
| `datei=0` | die Bilddatei ist nie angekommen → der Fehler sitzt im **Abrufweg** |
| `datei=1 intern=0` | geholt, aber nicht als Bild **erkannt** |
| `datei=1 intern=1 daten=0` | erkannt und trotzdem nicht **umgewandelt** |
| `datei=-1` | der Block wurde nie betreten (keine Adresse) |

## 7.2.0.73 — die Spurmarke sagt jetzt, ob hinter einem Bild Daten liegen (E-110, **Messfassung**)

> **Das ist kein Release und behebt nichts.** Gregor bekommt diese Fassung, um
> [**E-110**](Intern/BEFUNDE.md#e-110) überhaupt messbar zu machen. Veröffentlicht bleibt **`v1.0.72`**.
>
> **Zu prüfen:** auf dieselbe Nachricht antworten, in der Bilder grau bleiben,
> `LogLevel=58527` drin lassen, danach die `eudora.log` sichern. Entschieden
> wird an einem Wert: **`daten=0` bei einem Bild, das im Lesefenster sichtbar
> ist**, heißt — Eudora **holt es auf dem Antwortweg nicht**. **`daten` gesetzt
> und trotzdem grau** heißt — es **holt es und zeichnet es nicht**. Zwei
> verschiedene Ursachen, zwei verschiedene Behebungen.

**Warum diese Fassung nötig wurde.** Gregors Protokoll vom 18.09.2026 zu 1.0.72
hat die Frage zu [E-110](Intern/BEFUNDE.md#e-110) **nicht beantworten können**, obwohl es 128 Zeilen
`E-95 Bild` enthält. Der Grund steht in der Spurmarke selbst: ausgegeben wurden
zweimal **Maße** — `source_width/height` aus dem HTML gegen
`mess_ptr->width/height` aus dem Embed (`PGHTMIMP.CPP:2258-2259`) — und **nie
der Datenbestand**. Nachgezählt wurde immerhin dies: 76 der 128 Zeilen tragen
gleiche Maße, **52 haben `embed=0x0`** bei bekannter Breite. Dass der Platz
stimmt und die Bildpunkte fehlen, ist damit belegt; **welches** Bild betroffen
ist und **warum**, nicht.

**Dazu kam eine falsche Spur, die einen halben Vormittag gekostet hätte.** Im
Protokoll war **jede** der 128 Adressen exakt 32 Zeichen lang — das sieht
zwingend nach einem abgeschnittenen URL-Feld und damit nach der Ursache aus.
Es war die Spurmarke: sie kürzte **zweimal**, in der Kopierschleife
(`PGHTMIMP.CPP:2250`, `for (i = 0; i < 32 …)`) und noch einmal im Format
(`:2255`, `%.32s`).

**Was die Zeile jetzt zusätzlich nennt:**

- **`daten=`** aus `image_data` — den Metadatei-Griff setzt `PgLoadUrlImage`,
  sobald die Datei wirklich da ist. Bleibt er `0`, hat Paige nichts zu zeichnen.
  Das ist der Wert, der Datenbestand von Platzhalter trennt, und er steht in
  **derselben** Zeile wie die Maße.
- **`art=`** aus `type_and_flags`.
- **die ungekürzte Adresse.** Ist sie zu lang, fällt die **Mitte** weg, nicht
  das Ende — bei [**E-106**](Intern/BEFUNDE.md#e-106) hing alles am Dateinamen (`_3x` heißt dreifache
  Auflösung), und genau der stand vorher nie da.

**Kein Quelltext außerhalb der Spurmarke angefasst.** [E-110](Intern/BEFUNDE.md#e-110) ist damit nicht
behoben, sondern erst messbar.

## 7.2.0.72 — der Absturz, zweiter Anlauf: der Stilweg fliegt raus (E-108)

> **Zu prüfen:** dieselbe Nachricht öffnen und **antworten**. `LogLevel=58527`
> bleibt in der `Eudora.ini`. Wenn es wieder kracht, endet `eudora.log` erneut
> an einer [`E-106`](Intern/BEFUNDE.md#e-106)-Zeile — dann sag mir die letzte Zeile, sie entscheidet.

**[E-107](Intern/BEFUNDE.md#e-107) war die falsche Erklärung.** Ich hatte den Absturz damit begründet, dass
mein E-106-Block auf einem *flüchtigen* Embed läuft, und ihn auf den Ladeweg
beschränkt. **Gregors Protokoll zu 1.0.71 hat das widerlegt:** der Block läuft
dort fünfmal, und die letzte Zeile vor dem Abbruch ist wieder seine eigene
Spurmarke —

```
E-106 groesser als angegeben: attr=135x40 quelle=405x120 gefunden=1 pos=765
```

— dasselbe Bild, dieselbe Stelle wie an 1.0.69. Der Fehler steckt **im Block**,
nicht darin, wer ihn aufruft.

**Was der Block anders machte als der, der seit 1996 funktioniert:** er fasste
den **Textstil** direkt an (`pgGetStyleInfo` / `pgSetStyleInfo`) an einer
Position, die aus einer Suche über `embed->style` stammt. Der Prüfer hat dazu
unabhängig gemeldet ([P-41](Befunde/PRUEFER-14.md#p-41)), dass `embed->style` ein **Zeiger** ist, den sich
zwei Bilder gleicher Maßangabe teilen — die Suche kann also das **falsche**
Embed liefern, und dann schreibt der Stilweg an die falsche Stelle.

**Behebung:** derselbe Weg wie im QUALCOMM-Block zwanzig Zeilen darüber — die
Maße ins **Embed** schreiben und `pgInvalEmbedRef` die Zeile neu rechnen lassen.
Kein Zugriff mehr auf den Textstil.

**Und mein E-103-Sicherungsnetz ist ersatzlos entfernt.** Es fasste denselben
Stilweg an und hat in **keiner** Messung je ausgelöst — `nachgezogen=0`, jedes
Mal. Totes Gewicht auf einem gefährlichen Pfad.

**Bestätigt.** Gregor am 17.09.2026 an 1.0.72: *„kein crash"*. Sein Protokoll
belegt es dreifach — der Block läuft **18 mal** statt gar nicht, er läuft **über
die bisher tödliche Stelle hinaus** (`pos=770` hinter dem `pos=765`, an dem in
allen drei Absturzprotokollen Schluss war), und die letzte Zeile lautet
`Logging shutdown`. Keine `Exception.log`, nicht einmal eine leere.

**Nachstellen konnte ich es trotzdem nicht:** mein Prüfstand lädt zwar Bilder,
aber der Block läuft dort nicht an. **Nur Gregors Lauf entscheidet.**

## 7.2.0.71 — Absturz beim Antworten auf eine geöffnete Nachricht (E-107)

> **Zu prüfen:** eine Nachricht mit Bildern öffnen und **antworten**. Eudora
> darf nicht abstürzen. Genau das ist mit 1.0.69 passiert.

**Der Fehler war meiner, eingebaut mit [E-106](Intern/BEFUNDE.md#e-106) in derselben Nacht.**

Gregor am 17.09.2026 um 21:23 mit 1.0.69:

```
EXCEPTION_ACCESS_VIOLATION in Paige32.dll
  at UnuseMemory()+0006      ESI=FFFFFFFF
```

`ESI=FFFFFFFF` ist ein ungültiger Speicherverweis.

**Die Ursache steht als Warnung im Quelltext, seit 1996:**

```c
case EMBED_PREPARE_IMAGE:
    // Don't allow threaded fetch, because we're being called
    // with a temporary embed_ptr
    PgLoadUrlImage( pg, image, embed_ptr, false )
```

Der Embed ist dort **flüchtig**. Mein E-106-Block liest trotzdem `embed->height`
und `embed->style` und durchsucht damit das ganze Dokument. Der Block davor
([E-103](Intern/BEFUNDE.md#e-103)) hatte dieselbe Gefahr, lief aber nur bei Bildern **ohne** Maßangabe —
selten. Meiner lief zusätzlich bei allen **mit** Angabe, also bei fast jedem
Bild jeder Werbemail.

**Behebung:** beide Blöcke laufen nur noch, wenn `bAllowThreadedFetch` wahr ist
— das ist genau die Unterscheidung zwischen *Vorbereiten* (flüchtig) und
*Laden* (echter Embed).

**Was nicht bewiesen ist, und das gehört hierher:** ich konnte den Absturz
**nicht nachstellen**. Mein Prüfstand lädt zwar Bilder, aber keines, das
größer ist als angegeben; der verdächtige Code läuft dort deshalb gar nicht
an. Auch die **Gegenprobe mit der abstürzenden
Fassung 1.0.69 blieb negativ**: sie öffnet das Antwortfenster bei mir sauber.

Belegbar ist nur dies, und es ist am Quelltext ablesbar: **auf dem gefährlichen
Weg läuft mein Code jetzt gar nicht mehr.** Das Verhalten fällt dort auf den
Stand vor [E-103](Intern/BEFUNDE.md#e-103) und [E-106](Intern/BEFUNDE.md#e-106) zurück. Schlimmer kann es dadurch nicht werden.

## 7.2.0.70 — ein vollständiger Stand zum Testen, und die Paketliste wieder geradegezogen

> **Nicht mehr zu prüfen, und 1.0.70 nicht mehr zu benutzen** (Nachtrag LEKTOR,
> 18.09.2026, [L-15.8](Befunde/LEKTOR-15.md#l-15.8)): diese Fassung war die erste, die [E-101](Intern/BEFUNDE.md#e-101) (seit 13.10.2026 wieder offen) in beiden Teilen,
> [E-103](Intern/BEFUNDE.md#e-103), [E-104](Intern/BEFUNDE.md#e-104) und [E-106](Intern/BEFUNDE.md#e-106) zusammen trug — sie trägt aber auch den **Absturz beim
> Antworten** ([E-107](Intern/BEFUNDE.md#e-107)/[E-108](Intern/BEFUNDE.md#e-108)), der erst in **7.2.0.72** behoben ist, und sie ist
> nie zu Gregor gelangt. Der Messpunkt unten ist durch **seinen Lauf an 1.0.69**
> erledigt: **[E-106](Intern/BEFUNDE.md#e-106) ist bestätigt**, die Überlappung ist weg. Wer heute prüft,
> nimmt das Release **`v1.0.72`**.
>
> **Der Messpunkt, wie er damals lautete** (`LogLevel=58527` steht schon in
> der `Eudora.ini`): die Kleinanzeigen-Nachricht weiterleiten, warten bis die
> Bilder sichtbar sind, Eudora beenden. Im `eudora.log` muss stehen:
> `E-106 groesser als angegeben: attr=200x52 quelle=…x… gefunden=1`.
> **Bleibt die Zeile aus, ist auch diese Ursache widerlegt.**

**Kein neuer Code.** Diese Fassung bündelt, was schon in `main` steht — und
räumt zwei Dinge auf, die der Grund für ein Durcheinander waren.

### Warum es zwei Fassungsnummern 1.0.68 gab

Am 17.09.2026 liefen **zwei Sitzungen gleichzeitig**. Beide haben die
Fassungsnummer hochgezogen, beide nahmen die **68** — die eine für [E-106](Intern/BEFUNDE.md#e-106), die
andere für den zweiten Teil von [E-101](Intern/BEFUNDE.md#e-101). Die zweite hat es bemerkt und ist auf
**1.0.69** ausgewichen.

**Die Ursache lag in der Buchführung:** `Releases/PAKETE.md` kannte nur
**1.0.64** und **1.0.65**. Wer die nächste Nummer daraus ableitet, greift
zwangsläufig daneben. Die Liste führt jetzt auch **1.0.66 bis 1.0.70**.

### Was in welchem Paket steckt

Die Pakete dieses Abends nebeneinander — **erst 1.0.72 ist vollständig**:

| Paket | Fassung | enthält | es fehlt |
|---|---|---|---|
| 1.0.67 | 7.2.0.67 | [E-101](Intern/BEFUNDE.md#e-101) (erster Teil), [E-103](Intern/BEFUNDE.md#e-103) | [E-104](Intern/BEFUNDE.md#e-104), [E-106](Intern/BEFUNDE.md#e-106), [E-101](Intern/BEFUNDE.md#e-101) zweiter Teil |
| 1.0.68 | 7.2.0.68 | dazu [E-104](Intern/BEFUNDE.md#e-104), [**E-106**](Intern/BEFUNDE.md#e-106) | [E-101](Intern/BEFUNDE.md#e-101) zweiter Teil |
| 1.0.69 | 7.2.0.69 | [**E-106**](Intern/BEFUNDE.md#e-106) (aus 1.0.68), dazu die P-38-Spurmarke | [E-101](Intern/BEFUNDE.md#e-101) **zweiter Teil** |
| 1.0.70 | 7.2.0.70 | [E-101](Intern/BEFUNDE.md#e-101) zweiter Teil, [P-38](Befunde/PRUEFER-14.md#p-38) — **alles bis hierher** | **trägt den Absturz [E-108](Intern/BEFUNDE.md#e-108)**; nie zu Gregor gelangt |
| 1.0.71 | 7.2.0.71 | dasselbe, [E-107](Intern/BEFUNDE.md#e-107) als falsche Erklärung | **stürzt beim Antworten ab**, nie veröffentlicht |
| **1.0.72** | 7.2.0.72 | **alles, einschließlich [E-108](Intern/BEFUNDE.md#e-108)** | — — **das ist das Release `v1.0.72`**, von Gregor bestätigt |

> **Berichtigt am 18.09.2026 (LEKTOR, [L-15.7](Befunde/LEKTOR-15.md#l-15.7)).** Hier stand *„1.0.69 | 7.2.0.69
> | [E-101](Intern/BEFUNDE.md#e-101) **zweiter Teil**, [P-38](Befunde/PRUEFER-14.md#p-38) | [**E-106**](Intern/BEFUNDE.md#e-106)"* und *„**1.0.70** | 7.2.0.70 |
> **alles** | —"*. Die Zeile zu 1.0.69 war **vertauscht** und **zweifach**
> widerlegt: der E-106-Merge `0334a6c` (20:16:00) ist Vorfahr des Standes
> `acc8ad7`, aus dem die `Eudora.exe` von 1.0.69 um 20:24:54 entstand, während
> der zweite Teil von [E-101](Intern/BEFUNDE.md#e-101) (`e27ccf1`) erst um 20:58:43 kam — und Gregor hat
> den **E-106-Absturz an 1.0.69 erlebt**, was ohne [E-106](Intern/BEFUNDE.md#e-106) nicht möglich wäre.
> **[LEKTOR-14](Befunde/LEKTOR-14.md#lektor-14) hat beides am 17.09.2026 gemessen; die Zeile stand danach
> unverändert weiter.** Dazu hieß 1.0.70 *„alles"*, obwohl es den Absturz aus
> [E-107](Intern/BEFUNDE.md#e-107)/[E-108](Intern/BEFUNDE.md#e-108) trägt und bei Gregor nie angekommen ist.

Das erklärt auch, warum die Spurmarke `E-101 speichern:` in 1.0.69 fehlte: der
Protokollkanal war **nicht** abgeschaltet — `LogLevel=58527` ist `0xE49F` und
enthält `0x8000` sehr wohl. Die Behebung war dort schlicht noch nicht drin.

## 7.2.0.69 — die Spurmarke misst den Rumpf, und sie findet gleich etwas (E-101, P-38)

> **Zu prüfen:** eine Nachricht über *File → Save As* sichern und die Datei
> in einem anderen Programm öffnen. **Was zu sehen sein muss:**
> `MIME-Version: 1.0`, `Content-Type: text/html; charset="ISO-8859-1"`,
> **kein** `<x-html>` — und zwar **auch dann, wenn *Kopfzeilen
> einschließen* aus ist.** Genau das ging vorher schief. Im `eudora.log`
> steht die Zeile `E-101 speichern:` mit `rumpf-vorher=`, `rumpf-nachher=`
> und `mime-ergaenzt=`; sie erscheint jetzt ohne besondere Einstellung.

**Die Kurzfassung: eine Messung wurde scharf gemacht, und sie hat sofort
einen Datenverlust an Brauchbarkeit gefunden, den niemand gesehen hatte.**

### 1. Die Spurmarke konnte einen verschwundenen Rumpf nicht zeigen (P-38)

Sie nannte nur die Gesamtlängen. Die **wachsen** durch die drei neuen
Kopfzeilen auch dann, wenn der Rumpf ganz verschwindet:

```
bytes-vorher=104 nachher=128 geaendert=1     ← und NULL Byte Rumpf
```

Jetzt stehen `rumpf-vorher` und `rumpf-nachher` daneben.

### 2. Sie stand auf einem Kanal, der in der Vorgabe AUS ist

Gregor speicherte mehrere Nachrichten — im Protokoll stand **keine
einzige** `E-101 speichern:`-Zeile. Nicht, weil nichts geschah:

```
LogLevel 25759 (0x649F)        DEBUG_MASK_MISC = 0x8000 → nicht enthalten
```

Die Zeile war seit `7.2.0.66` da und ist **nie geschrieben worden**. Damit
war auch die Behebung von [E-101](Intern/BEFUNDE.md#e-101) selbst nie über ihre eigene Spur belegt.
Jetzt `DEBUG_MASK_DIALOG` (`0x08`) — in der Vorgabe **an**, und inhaltlich
richtig, denn der Weg läuft über den Speichern-Dialog. Dasselbe stand hier
schon einmal an: `filtersd.cpp:1147` zu [**E-73**](Intern/BEFUNDE.md#e-73), wörtlich *„eine
Sicherheitsmeldung darf nicht abschaltbar sein"*.

### 3. Und dann zeigte sie den zweiten Teil von E-101

An Gregors eigenen Speichervorgängen, nicht an einem Testfall:

```
kopfzeilen=0 trenner=0 content-type-vorhanden=0
bytes-vorher=102006 nachher=101985 rumpf-vorher=102006 rumpf-nachher=101985
```

**`rumpf-vorher` minus `rumpf-nachher` = 21 Byte** — `<x-html>` plus CRLF
und `</x-html>` plus CRLF. Kein Byte zuviel: **[P-28](Befunde/PRUEFER-14.md#p-28) hält an echten Daten.**

Aber: **`nachher` ist gleich `rumpf-nachher`.** Es kam **nichts** dazu.
Seine Dateien trugen HTML ohne `MIME-Version`, ohne `Content-Type`, ohne
Zeichensatz — *„datei gespeichert, aber unbrauchbar"*, unverändert. Der
ganze Kopfzeilenblock hängt an `if ( !szKopf.IsEmpty() )`; ohne
*Kopfzeilen einschließen* ist er leer. **[E-101](Intern/BEFUNDE.md#e-101)** *(wieder offen seit 13.10.2026, aus anderem Grund: Zeichensatz)* **war nur behoben, wenn der
Schalter an war** — und laut [**E-98**](Intern/BEFUNDE.md#e-98) ist das Kästchen auf Windows 10 gar
nicht anwählbar.

**Behoben, aber eng:** erfunden wird weiterhin nichts. Ergänzt wird nur,
was der Leser braucht, um die Bytes zu deuten — bei **HTML** und bei
**Hochbytes**. Reiner `us-ascii`-Text bleibt unberührt. *„Kopfzeilen
einschließen"* meint `From`, `To`, `Subject`, `Date`, nicht die Erklärung,
was die Bytes darunter sind.

### 4. Der Prüfsatz der Tests ließ genau diesen Schnitt durch

Sie fragten `Hat()` — *„enthält die Ausgabe X"*. Neu ist der byteweise
Vergleich. **Die Gegenprobe dazu, auf Gregors *„kommt mir suspekt vor"*:**
ein einziges Byte am Rumpfende weggenommen —

```
[FEHL] E-101 P-28: Marker und Text auf derselben Zeile - Rumpf bleibt
         DATENVERLUST: der Rumpf soll 55 Byte haben, hat aber 54
 Ergebnis: 169 Tests, 163 bestanden, 6 fehlgeschlagen
```

**In allen vier Fällen hat das alte `Hat()` nichts gemerkt.** Danach
zurückgebaut.

### 5. Jede Notiz stand im Protokoll unter dem falschen Test

`TT_Note` druckte sofort, der Testname erst in `TT_EndTest` — **alle 169
Tests** betroffen, seit es die Funktion gibt. Behoben.

**Gemessen:** Bau 0 Fehler. **171 Tests, 171 bestanden.**

**Am laufenden Programm gemessen ist der Befund.** Gregors zwei
Protokollzeilen aus `1.0.69` belegen dreierlei live: dass die neuen Werte
aus [P-38](Befunde/PRUEFER-14.md#p-38) überhaupt erscheinen, dass **[P-28](Befunde/PRUEFER-14.md#p-28) an echten Daten hält** (zweimal
exakt 21 Byte) und dass der `Content-Type` fehlt.

**Nicht gemessen ist die Behebung dazu** — sie entstand *nach* seiner
Messung, sein `1.0.69` trug sie noch nicht. Offen ist also nur die
Bestätigung, dass eine gespeicherte Datei jetzt **mit** `Content-Type`
herauskommt, nicht der Nachweis, dass etwas falsch war. Deshalb steht sie
oben unter *Zu prüfen*.

## 7.2.0.68 — Bilder, die größer sind als angegeben (E-106)

> **Zu prüfen:** `LogLevel=58527` in der `Eudora.ini` lassen, die
> Kleinanzeigen-Nachricht weiterleiten, warten bis die Bilder da sind. Im
> `eudora.log` muss stehen:
> `E-106 groesser als angegeben: attr=200x52 quelle=…x… gefunden=1`.
> **Bleibt die Zeile aus, ist auch diese Ursache widerlegt** — dann bitte das
> Protokoll schicken, statt weiterzusuchen.

Gregor am 17.09.2026 an 1.0.67: das grüne *kleinanzeigen*-Logo liegt weiter
über „Deine Anzeige wird weniger gesehen".

**Sein Protokoll hat es entschieden.** Neun Bilder seiner Nachricht wurden nach
dem Laden nachgemessen, und bei allen wuchs die Zeile mit:

```
attr=140x0  →  quelle=140x134  →  ascent=134
attr=24x0   →  quelle=24x49    →  ascent=49
```

**Das Logo war nicht darunter.** Es trägt `attr=200x52 embed=200x52 ascent=52`
— und danach keine einzige Zeile mehr.

**Die Ursache.** Der Nachtrag läuft nur, wenn im HTML **keine** Größe stand.
Ein Bild mit beiden Angaben wird **nie nachgemessen**. Und Paige skaliert
nicht: Absender legen Bilder in doppelter Auflösung ab und geben im HTML die
halbe Größe an, damit sie auf feinen Bildschirmen scharf bleiben. Jeder Browser
skaliert — Paige zeichnet die Datei in Originalgröße in eine Zeile, die nach
der Angabe bemessen ist. Bei 200×52 angegeben und 400×104 geladen sind das
**52 Punkte, die auf dem folgenden Text liegen**.

**Warum [E-103](Intern/BEFUNDE.md#e-103) daran vorbeiging:** [E-103](Intern/BEFUNDE.md#e-103) behandelt Bilder **ohne**
Größenangabe. Gregors Logo hat eine. Zwei Fassungen lang war der falsche Fall
behoben — das ist der ehrliche Teil dieser Zeile.

**Behebung:** die echte Dateigröße wird jetzt **immer** gemerkt, und ist sie
höher als die angegebene, bekommt die Zeile die echte Höhe. Nur vergrößern, nie
verkleinern. Richtig skalieren wäre besser, sitzt aber tief in Paige;
zugedeckter Text ist der teurere Fehler.

**Nicht nachgewiesen, und das gehört dazu:** mein Prüfstand lädt zwar Bilder
— acht `E-95 Bild`-Zeilen und `E-103 Nachtrag: quelle=79x64`, also geholt und
vermessen —, aber keines davon ist größer als angegeben; `E-106 groesser`
bleibt bei null. Die Behebung ist
dort nicht messbar. **Nur sein Lauf kann sie belegen.**

> **Berichtigt am 18.09.2026 (LEKTOR, [L-15.9](Befunde/LEKTOR-15.md#l-15.9)).** Hier stand *„mein Prüfstand
> lädt die Bilder nicht — null Ladespuren"*. Am Protokoll gemessen
> (`C:\Temp\E107-vorher\…\eudora.log`, 17.09.2026 21:28) sind es **acht**
> Ladespuren; null ist allein der Zähler `E-106 groesser`. Zwei verschiedene
> Zähler waren verwechselt, und die falsche Diagnose zeigte drei Fassungen
> lang in die falsche Richtung.

## 7.2.0.67 — Bilder liegen nicht mehr über dem Text (E-103)

> **Zu prüfen:** die Doctolib-Nachricht (oder eine andere mit Logo)
> **weiterleiten** und ins Verfassenfenster sehen. Liegt noch etwas über dem
> Text? Falls ja: `eudora.log` schicken — die Antwort steht dann darin.

Gregor an 1.0.56: *„da ist alles durcheinander, man kann ja nichts lesen."*
Seither mehrfach angemahnt, nie gemessen. Jetzt an seiner **echten** Nachricht
nachgestellt — 23.537 Byte, byte-genau aus dem Postfach gelöst, fünf Bilder.

**Der Mechanismus, Schritt für Schritt belegt.** Beim Import kennt Paige nur,
was im HTML steht:

```
attr=0x0     embed=0x0     ascent=13     ← das Doctolib-Logo
attr=80x80   embed=80x80   ascent=80
attr=98x35   embed=98x35   ascent=35
attr=117x35  embed=117x35  ascent=35
attr=80x24   embed=80x24   ascent=24
```

Vier Bilder tragen ihre Maße im HTML und bekommen die richtige Zeilenhöhe. Das
Logo trägt keine — **Paige misst Bilder nie selbst nach** — und bekommt eine
Textzeile von 13 Punkten, während das Bild 60 hoch ist. Das sind die 47 Punkte
über dem Text.

**Und dann kommt die Überraschung.** Drei neue Spurmarken verfolgen, was nach
dem Import passiert:

```
E-103 Nachtrag:    quelle=202x60 embed=202x60 gefunden=1 pos=288
E-103 Zeilenhoehe: pos=288 ascent-vorher=60 bildhoehe=60 nachgezogen=0
E-103 Neuzeichnen: bucket=1 fenster=1
```

Eudora **lädt das Bild wirklich**, erfährt die echte Größe 202×60, trägt sie
nach — und die Zeilenhöhe steht zu diesem Zeitpunkt **schon auf 60**. Das
Fenster wird auch neu gezeichnet. **Im heutigen Bau heilt sich der Fall selbst,
sobald das Bild geladen ist.** Vermutlich seit [E-96](Intern/BEFUNDE.md#e-96) (7.2.0.63).

**Der Fall, in dem das nicht reicht:** lässt sich das Bild **nicht** laden —
kein Netz, toter Verweis, gesperrt —, erscheint keine der drei Marken, und die
Zeile blieb bei 13 Punkten. Gegenprobe gefahren, mit dem Logo auf einen
Rechner, den es nicht gibt: `attr=0x0 embed=0x0 ascent=13`, sonst nichts.

### Was behoben wurde

**Der Import reserviert jetzt eine Mindestzeilenhöhe**, sobald gar keine Größe
bekannt ist — 48 Punkte (`E103_MINDESTHOEHE` in `PGHTMIMP.CPP`). Sobald die
echte Höhe aus der heruntergeladenen Datei kommt, gewinnt die.

Gemessen, beide Fälle, mit derselben Nachricht:

| | vorher | jetzt |
|---|---|---|
| Bild **ladbar** | `ascent=13`, später 60 | `ascent=48` beim Import, dann **60** |
| Bild **nicht ladbar** | `ascent=13` | `ascent=48` |

**Das ist nicht der Notbehelf von früher.** Bis 7.2.0.62 wurde die
*Bildgröße* auf 20×20 geraten — das hat Gregors Tonerkartusche zu einem
Streifen gequetscht und wurde deshalb entfernt. Hier wird **nur die Zeile**
hoch genug gemacht; an Breite und Höhe des Bildes ändert sich nichts, es kann
sich nichts verzerren.

Die 48 sind begründet, nicht geraten: groß genug, dass die üblichen Kopfbilder
einer Werbemail nicht mehr in den Text ragen — das Doctolib-Logo ist 60 hoch,
die vier anderen Bilder derselben Nachricht 24 bis 80 — und klein genug, dass
eine Zeile mit einem kleinen Symbol keine auffällige Lücke reißt.

### Datenverlust in `main` geschlossen (Prüfer P-28)

Beim Nachprüfen von `main` gefunden — **nicht** durch einen Testlauf, sondern
weil der Prüfer die Funktion aus dem Quelltext geschnitten, übersetzt und mit
16 Eingaben gefahren hat.

`E101SpeicherfassungAufbereiten` löschte die **ganze erste Rumpfzeile**, sobald
sie auf `>` endete. Stehen `<x-html>` und der Nachrichtentext auf derselben
Zeile, war damit der **komplette Rumpf weg**:

```
<x-html><html><body>Der ganze Text…</body></html></x-html>
  104 Byte rein, 128 raus  —  und null Byte Rumpf
```

Die Datei wird dabei **größer**, weil die Kopfzeilen dazukommen. Deshalb fällt
so etwas niemandem auf.

**Dass der Fall vorkommt, steht in Eudoras eigenem Quelltext:**
`msgutils.cpp:2374` sagt wörtlich *„`<x-html>` And the message all comes on the
same line"*, `IDS_MIME_RICH_ON` ist `"<%s>"` ohne Zeilenende, und
`etf2html.cpp:200` schreibt den Marker ebenso. Nur der POP-Weg setzt ihn auf
eine eigene Zeile — und der war der einzige, der geprüft worden war.

**Behebung:** entfernt wird jetzt das **Tag**, nicht die Zeile. Das Ende ist
das erste `>` außerhalb von Anführungszeichen, und über die erste Zeile hinaus
wird nicht gesucht. Folgt Text auf derselben Zeile, bleibt er vollständig
stehen. **Drei neue Tests**, einer je gemessenem Verlustfall.

### Die Spurmarke zu den Bildern zeigte Binärmüll (Prüfer P-11)

Das `src=`-Feld der E-95-Marke las einen Paige-`memory_ref` — ein **Handle** —
als Zeichenkette. Im Protokoll standen zwölf Zeilen der Form
`src=\110\001\032\001…`. Ausgerechnet die Spalte, die sagen sollte, ob ein Bild
als `cid:`, `data:` oder `http:` kommt — und genau diese Frage stand bei [E-95](Intern/BEFUNDE.md#e-95)
vier Fassungen lang offen.

Jetzt: `src=https://www.doctolib.fr/email_la…`

### Die Kopfzeilen der gespeicherten Nachricht kleben nicht mehr zusammen (E-104)

> **Zu prüfen:** eine Nachricht aus dem **geöffneten Fenster** speichern (nicht
> aus der Postfachliste) und die Datei aufmachen. `From:`, `Subject:` und `Cc:`
> müssen **jede in einer eigenen Zeile** stehen.

Gregor speicherte mit 1.0.65 eine Nachricht aus dem geöffneten Fenster. In der
Datei stand:

```
From: "konto-gmx@gregor.invalid" <konto-gmx@gregor.invalid> Subject: Re: Fwd: Deine
Anzeige 'Zu verschenken: kleine Gefäße' Cc:
```

Drei Kopfzeilen in einer. Im Postfach steht jede für sich — beide Fassungen
nebeneinandergelegt und gemessen.

**Ursache 1:** `CCompMessageDoc::SaveAsFile` schickte `UnwrapText` über die
**ganze** Nachricht. In `tocview.cpp` steht an derselben Stelle der Schutz
*„Don't unwrap the headers!"* — auf dem Fensterweg fehlte er.

**Ursache 2, und die ist die eigentliche:** dass „Absätze raten" überhaupt lief,
ist eine **Folge von [E-100](Intern/BEFUNDE.md#e-100)**. Gregors `Eudora.ini` trug `GuessParagraphs=7179`
und `IncludeHeaders=16720` — uninitialisierte Stapelwerte, die [E-100](Intern/BEFUNDE.md#e-100) dort
hineingeschrieben hatte. Jeder Wert ungleich 0 gilt als eingeschaltet. Er hat
es nie gewählt und konnte es mangels Kästchen ([**E-98**](Intern/BEFUNDE.md#e-98)) gar nicht wählen.

**[E-100](Intern/BEFUNDE.md#e-100) hat das Loch gestopft, die schon verdorbenen Werte aber nicht
repariert.** Das tut jetzt `E104SchalterLesen`: was weder 0 noch 1 ist, geht auf
die Vorgabe 0 zurück **und wird berichtigt zurückgeschrieben**. **Damit muss
niemand ein neues Mailverzeichnis anlegen.**

**Und die Behebung deckte zunächst nur die halbe Strecke.** Der Prüfer hat sie
nachgerechnet und dabei gefunden, dass `CReadMessageDoc::SaveAs` und
`CReadMessageDoc::SaveAsFile` denselben ungeschützten Aufruf tragen — dort war
`FindBody` sogar **genau umgekehrt** eingesetzt: es lief, wenn die Kopfzeilen
*nicht* mitsollten. **Wer eine empfangene Nachricht aus ihrem Fenster
speicherte, bekam den Fehler unverändert.** Beide Stellen sind nachgezogen.

Dazu lasen zwei weitere Stellen den Schalter noch roh, so dass die Datei mit
verdorbener INI mit einer einsamen `Date:`-Zeile ohne Leerzeile begann.
Verklebt wurde sie nur deshalb nicht, weil sie 38 Zeichen hat und die
40-Zeichen-Regel von `UnwrapText` griff — **zwei Zeichen Abstand zum Fehler,
Zufall statt Schutz.**

Zwei Punkte wurden vor dem Paketbau eigens nachgerechnet: `UnwrapText` arbeitet
**im Puffer** und liefert denselben Zeiger zurück — es geht kein Text verloren;
und `GetMessageHeaders` hängt am Ende eine Leerzeile an, `FindBody` findet die
Grenze also.

### Was dazugekommen ist

**Drei neue Spurmarken** in `PgEmbeddedImage.cpp`, die den Weg nach dem Import
sichtbar machen — ohne sie war nicht zu entscheiden, ob die Größe nie ankommt
oder nur zu spät:

* `E-103 Nachtrag: quelle=… embed=… gefunden=… pos=… style=…`
* `E-103 Zeilenhoehe: pos=… ascent-vorher=… bildhoehe=… nachgezogen=…`
* `E-103 Neuzeichnen: bucket=… fenster=…`

**Ein Sicherungsnetz** an derselben Stelle: ist die Zeile nach dem Laden
niedriger als das Bild, wird sie nachgezogen. Es hat in der Messung **nicht**
ausgelöst (`nachgezogen=0`), und die Marke sagt das auch — es steht da für den
Fall, dass `pgInvalEmbedRef` einmal nicht durchgreift.

**Die E-89-Spurmarke** nennt jetzt zusätzlich den Anfang des Rumpfes, die
Zeilenenden und die Zahl der als Text versteckten Bilder
(`crlf=… nur-lf=… esc-img=… anfang=[…]`). Ohne diese drei Zahlen wäre die
Ursachensuche an dieser Stelle steckengeblieben.

## 7.2.0.66 — die gespeicherte Datei ist jetzt brauchbar (E-101)

> **Zu prüfen:** Nachricht markieren, **File → Save As**, Datei speichern —
> und die Datei dann **in Thunderbird oder einem Editor öffnen**. Kopfzeilen
> müssen da sein, Umlaute müssen stimmen, und `<x-html>` darf nicht auftauchen.

Gregor am 17.09.2026, nachdem er eine weitergeleitete Nachricht gesichert
hatte: *„datei gespeichert, aber unbrauchbar"*.

**Gemessen an seiner Datei** (5.716 Byte): vier Kopfzeilen, danach Eudoras
**interner Marker `<x-html>`** und roher HTML-Text. Keine `Content-Type`-Zeile,
keine `MIME-Version`, kein Zeichensatz. `.eml` und `.txt` byte-identisch.

**Warum.** Bei einer selbst verfassten Nachricht entsteht die
`Content-Type`-Zeile **erst beim Senden** — `SendContentType`
(`sendmail.cpp:766`) baut sie aus den Merkern des Übersichtseintrags, nicht aus
dem Rumpf. Was in `Out.mbx` liegt, ist die interne Fassung, und der
Speicherweg schrieb sie unverändert hinaus. Die Umlaute waren korrekt als
Latin-1 gespeichert (`0xFC`, gemessen) — aber ohne `charset=` weiß kein Leser
das, und Thunderbird zeigt Buchstabensalat oder HTML-Quelltext.

**Behebung.** Der Speicherweg entfernt den internen Marker und ergänzt
`MIME-Version`, `Content-Type` und `Content-Transfer-Encoding`, wenn keine
`Content-Type`-Zeile da ist. Untertyp nach dem Marker, Zeichensatz nach den
Bytes — **aus dem Inhalt abgeleitet, nicht geraten**. Eine empfangene
Nachricht bringt ihre echten Kopfzeilen mit; die bleiben unangetastet.

**Am laufenden Programm geprüft:** selbst gespeichert, Datei wieder geöffnet —
`MIME-Version: 1.0`, `Content-Type: text/html; charset="ISO-8859-1"`, kein
`x-html`, Umlaute unverändert.

### Was der Prüfer an dieser Behebung gefunden hat

Er hat die Funktion übersetzt und mit zwölf Eingaben gefahren, Ein- und
Ausgabe byteweise verglichen. **Vier Fälle haben Inhalt verloren.** Sein
Urteil: so nicht ausliefern — vorher war die Datei unbrauchbar, aber
**vollständig**; danach wäre sie brauchbar und in konstruierbaren Fällen
**unvollständig, ohne sichtbare Lücke**.

Der schlimmste Fall: der Marker wurde im ganzen Rumpf gesucht und das
schließende `>` über Zeilengrenzen hinweg. In einer Klartextnachricht ist das
nächste `>` das **Zitatzeichen** —
`"Er schrieb <x-html in die Zeile. Du sagtest:\r\n> stimmt"` wurde zu
`"Er schrieb  stimmt"`, **36 von 62 Byte weg**. Der Verlust war also nicht
markergroß, sondern unbegrenzt, und traf auch **empfangene** Nachrichten.

Alles behoben: der Marker zählt nur als **erste Zeile** des Rumpfs und nur,
wenn die ganze Zeile aus ihm besteht; das Gegenstück nur, wenn dahinter nichts
als Leerraum steht; die führende Leerzeile bleibt; der gemischte Zeilentrenner
lässt kein `\r` mehr stehen; und fehlt die Leerzeile zwischen Kopf und Rumpf,
sagt die Spurmarke das mit `trenner=0`, statt sich wie ein Erfolg zu lesen.

**Sechs neue Tests, einer je gemessenem Fall** — damit kein späterer Umbau sie
wieder aufmacht.

**169 Tests, 169 bestanden** — dreizehn neue, darunter die Gegenprobe an einer
empfangenen Nachricht und der Stolperstein „zitiertes `Content-Type:` im
Rumpf einer Weiterleitung".

**Was daraus zu lernen war:** bei [E-97](Intern/BEFUNDE.md#e-97) hatte ich gemessen, dass der Dialog
aufgeht, und daraus „Speichern funktioniert" gemacht. Dass nie jemand in die
herausgekommene Datei geschaut hatte, ist derselbe Befund eine Ebene tiefer.

## 7.2.0.65 — dieselbe Absturzstelle an drei weiteren Stellen geschlossen (E-100)

> **Zu prüfen:** *File → Save As* muss weiter gehen wie in 1.0.64. Diese
> Fassung schließt Wege, über die noch niemand gestolpert ist — es soll sich
> nichts ändern, außer dass es so bleibt.

Vom Prüfer am **17.09.2026** als Gegenvermutung zu [E-97](Intern/BEFUNDE.md#e-97) gefunden, **bevor
jemand darüber gestolpert ist**.

**Teil 1 — dieselbe Lücke, dreimal.** `GetFileNameFromDialog`, `ToggleStat` und
`StatDir` in `SaveAsDialog.cpp` berechnen `dlgPtr = GetParent()` genau wie
`OnTypeChange` und greifen **ungeprüft** darauf zu. `GetFileNameFromDialog` ist
die gefährliche: sie wird aus `OnOK()` gerufen, also **im laufenden
Speichervorgang**, nicht nur beim Aufbau des Dialogs.

**Teil 2 — zwei Werte, die in deine Einstellungen laufen.** `m_Inc` und
`m_Guess` werden vom Konstruktor nicht gesetzt, aber von allen drei
Aufrufstellen nach `DoModal()` ungeprüft in die INI geschrieben. Läuft
`OnInitDialog` nicht, landen zwei uninitialisierte Werte **dauerhaft** in
`IDS_INI_INCLUDE_HEADERS` und `IDS_INI_GUESS_PARAGRAPHS`. Jetzt werden sie im
Konstruktor mit dem bisherigen Stand aus der INI vorbelegt.

**Teil 3 — ein dritter Weg, den der Wächter selbst aufgemacht hätte.**
`GetFileNameFromDialog` füllt einen Puffer, den `OnOK` als
`char realFileName[_MAX_PATH + 1]` **uninitialisiert** auf den Stapel legt.
Kehrt sie ohne Schreiben zurück, arbeitet `OnOK` mit Stapelmüll weiter —
`strstr(realFileName, ".sta")`, im schlimmsten Fall `strcat`. Ein unbrauchbarer
Dateiname wäre schlimmer als der Absturz, den der Wächter verhindert. Das galt
**auch vorher schon**, wenn `GetDlgItem(edt1)` null lieferte. Jetzt steht
`buf[0] = 0;` als erste Anweisung der Funktion.

**Teil 4 — ein Wächter saß an der falschen Stelle.** In `SetFileNameInDialog`
stand die Prüfung über der ganzen Funktion. Auf dem heute einzig gelaufenen
Zweig wird `dlgPtr` dort aber **gar nicht benutzt**: `SetControlText` geht über
`IFileDialogCustomize`, nicht über das Elternfenster. Der Wächter hätte den
Aufruf übersprungen und damit den Dateinamen still nicht gesetzt — eine
Verhaltensänderung, wo nur ein Absturz verhindert werden sollte. Die Prüfung
steht jetzt dort, wo `dlgPtr` wirklich benutzt wird. Dazu setzt `OnOK` seinen
Puffer selbst auf leer, bevor er ihn weitergibt.

Dazu zwei falsche Begründungen im Quelltext berichtigt — und eine Warnung für
den, der einmal [**E-98**](Intern/BEFUNDE.md#e-98) behebt: `OnInitDialog` ruft weder `EnableWindow` noch
`OnTypeChange()`, das muss dann nachgezogen werden.

## 7.2.0.64 — Speichern stürzt nicht mehr ab (E-97)

> **Zu prüfen:** eine Nachricht auswählen, **File → Save As**. Der Dateidialog
> muss aufgehen, und Eudora muss danach noch da sein.

**Gebaut am 17.09.2026.** **Als Paket geschnürt und auf GitHub veröffentlicht
als `v1.0.64`** (17.09.2026, 10:23 Uhr UTC). `Eudora72-1.0.64-release.zip`
liegt **nicht** im Repo — `Releases/Eudora72-*-release.zip` ist von
`.gitignore` erfasst; es hängt an der Veröffentlichung. Prüfsumme und
Netzadresse stehen in [Releases/PAKETE.md](Releases/PAKETE.md), Abschnitt
1.0.64. *(Berichtigt am 11.10.2026: hier stand „liegt daneben", und das war in
jedem frischen Klon falsch.)*

> **Berichtigt am 17.09.2026 (LEKTOR, [L-13.4](Befunde/LEKTOR-13.md#l-13.4)).** Hier stand *„Ein Paket ist zu
> dieser Fassung noch nicht geschnürt — das letzte liegt als
> `Releases/Eudora72-1.0.63-release`"*. Beide Hälften waren überholt: das
> Paket zu 7.2.0.64 existiert und ist herausgegangen, und das letzte
> Verzeichnis unter `Releases/` ist `Eudora72-1.0.65-release`.

**Der Fehler war in jeder Fassung dieses Projekts** — 1.0.49 bis 1.0.63
gemessen, auch im veröffentlichten Release `v1.0.50`. Aufgefallen ist er erst,
als Gregor eine Nachricht speichern sollte, um sie mir zu geben.

**Die Stelle, aus dem Debugger symbolisiert:**

```
0   Eudora.exe   CSaveAsDialog::OnTypeChange + 45   SaveAsDialog.cpp:425
1   COMDLG32.dll
25  Eudora.exe   CTocView::OnFileSaveAs + 429       tocview.cpp:3074
```

`OnTypeChange` ist der Rückruf, mit dem der Dateidialog meldet, dass der
Dateityp gesetzt wurde. **Er kommt, während der Dialog sich aufbaut** — vor
`OnInitDialog`. Zu diesem Zeitpunkt hat das Vorlagenfenster noch kein
Elternfenster:

```c
dlgPtr = GetParent();                         // liefert NULL
CWnd *filtCombo = dlgPtr->GetDlgItem(cmb1);   // Zugriffsverletzung
```

Ein paar Zeilen weiter dieselbe Lücke: `m_GuessParagraphs.EnableWindow()` auf
einem Schalter, den `DoDataExchange` bewusst **nicht** anbindet, wenn es ihn
ohne Dialogvorlage nicht gibt.

**Beide Zugriffe waren durch ein `ASSERT` „abgesichert", das im Release nichts
tut.** Das ist die häufigste Ursachenklasse dieses ganzen Projekts, und hier
hat sie eine Grundfunktion seit der ersten Fassung unbrauchbar gemacht.

**Warum es so lange dauerte:** Die Ausnahme ist `0xC000041D`
(STATUS_FATAL_USER_CALLBACK_EXCEPTION) — eine Ausnahme in einem Systemrückruf
kommt nicht über die Kernel-Grenze zurück, deshalb bricht das Programm sofort
ab, statt eine Meldung zu zeigen. Drei Vermutungen waren vorher zu widerlegen:
die CSS-Grenze, die Dialogvorlage von 1996 und die ungeprüften Steuerelemente
in `OnInitDialog`. Erst die symbolisierte Aufrufkette hat es entschieden.

**Gegenprobe:** derselbe Messlauf, der vorher *„ABGESTUERZT beim Speichern
unter"* meldete, sagt jetzt *„lebt noch"*.

**Tests: 153 von 153.**

### E-99: Datenverlust beim Senden eines gesicherten Entwurfs — geschlossen, bevor das Paket hinausging

> **Zu prüfen:** Antwort verfassen, **Entwurf sichern**, Fenster offen lassen,
> danach **senden**. Der getippte Text muss in der gesendeten Nachricht stehen.

Gefunden beim Nachrechnen der E-93-Behebung. `HasChanged()`
(`PaigeEdtView.h:193`) beantwortet **nicht** die Frage „hat der Anwender
getippt", sondern „hat er **seit dem letzten Sichern** getippt" — denn
`PgMsgView::ExportMessage` ruft an seinem Ende `SaveChangeState()`
(`PgMsgView.cpp:460`).

Folge: Wer einen Entwurf sichert und ihn **danach** sendet, läuft ein zweites
Mal durch `ExportMessage` — diesmal mit `HasChanged() == FALSE`. Das für [E-88](Intern/BEFUNDE.md#e-88)
aufgehobene Original hätte dann seinen Text überschrieben. **Still, ohne
Meldung** — genau der Weg, den [E-93](Intern/BEFUNDE.md#e-93) schließen sollte.

**Behebung:** ein Merker am Verfassendokument
(`CCompMessageDoc::m_bE88AnwenderHatGetippt`), der **einrastet**: einmal
getippt, immer getippt. Er lebt so lange wie das Verfassenfenster, genau wie
das aufgehobene Original.

### Nebenbefund E-98: die beiden Optionen im Speicherdialog fehlen

Die Gegenprobe zu [E-97](Intern/BEFUNDE.md#e-97) zählt die Steuerelemente des offenen Dialogs und meldet
`Eigene Kaestchen gefunden: 0`. *Kopfzeilen einschließen* und *Absätze raten*
sind nicht da — Windows 10 öffnet den modernen Dateidialog, und der zeigt die
Dialogvorlage von 1996 (`OFN_ENABLETEMPLATE`, `IDD_SAVEAS_EXT`) nicht mehr an.

**Kein Rückschritt durch diese Fassung:** die Kästchen fehlten auch vorher, es
kam nur niemand so weit, weil Eudora vorher abbrach. Steht als [**E-98**](Intern/BEFUNDE.md#e-98) offen
in [BEFUNDE.md](Intern/BEFUNDE.md).

## 7.2.0.63 — der Notbehelf ist weg, die Bilder behalten ihre Größe (E-95/E-96)

> **Zu prüfen:** Doctolib- und FairToner-Nachricht weiterleiten **und**
> beantworten. Die Bilder müssen in ihrer **wirklichen** Größe dastehen und der
> Text **frei** bleiben.

**Seit [E-96](Intern/BEFUNDE.md#e-96) behoben ist, war die Vorgabe nur noch schädlich.** Bis 7.2.0.62 bekam
ein Bild ohne Größenangabe 20×20 Punkte — ein Notbehelf gegen [E-96](Intern/BEFUNDE.md#e-96): solange die
Zeilenhöhe die des *ersten* Bildes behielt, blieb sie bei fehlendem
`height`-Attribut textklein, und der Text wurde zugedeckt.

**Gemessen an Gregors Nachrichten mit 1.0.62** steht die Zeilenhöhe jetzt je
Bild richtig:

```
attr=600x1   ascent=13     (1 Pixel hohe Trennlinie - Zeile bleibt textbreit)
attr=175x35  ascent=35
attr=200x50  ascent=50
attr=80x80   ascent=80
```

In derselben Messung stand aber auch `attr=20x20` — und genau das war auf
seinem Bild die Tonerkartusche: **kein abgeschnittenes Bild, sondern eines, das
wir auf 20×20 gequetscht hatten.**

Paige kennt die wirkliche Größe, sobald es die Datei geladen hat; die Spalte
`embed=` der Spurmarke belegt es. Ohne unser Zutun trägt es sie selbst ein.
Deshalb bleibt ein Bild ohne Maß jetzt **unangetastet** — auch dann, wenn nur
die Höhe fehlt: eine geratene Höhe bei `width="600"` würde es zu einem Streifen
verzerren.

**Damit entfällt auch die Unterscheidung zwischen eingebetteten und externen
Bildern** aus 7.2.0.61. Sie war richtig gedacht, aber sie behandelte ein
Symptom: beide Fälle bleiben jetzt gleichermaßen unangetastet. Der Zähler
`eingebettet=` in der Spurmarke bleibt als Information stehen.

**Vier Fassungen lang wurde an dieser Zahl gedreht** — 200×90, gar nichts,
20×20, `cid:` gegen `http:`. Keine davon war die Ursache. Die lag in
`ProcessEmbed`, und seit sie behoben ist, braucht es an dieser Stelle gar nichts
mehr.

**Tests: 153 von 153**, drei davon umgeschrieben — sie prüfen jetzt, dass
**nichts** geschieht.

## 7.2.0.62 — jedes Bild bekam die Zeilenhöhe des ersten (E-96)

> **Zu prüfen:** die Doctolib-Nachricht weiterleiten. Die Bilder müssen
> **vollständig** dastehen und der Text **frei** bleiben. Falls nicht: im
> Protokoll steht bei `LogLevel=58527` je Bild eine Zeile
> `E-95 Bild: attr=… embed=… ascent=… text-asc=…` — die sagt, wo es klemmt.

**Die Ursache, am laufenden Programm gemessen.** `ProcessEmbed()` räumt nach
jedem eingefügten Bild den Embed-Stil auf — `procs`, `embed_entry`,
`embed_object` —, **aber nicht die Zeilenhöhe**. `current_style.ascent` behielt
die Höhe des Bildes. Beim nächsten Bild las `DoDataTag` diesen Wert als
vermeintlichen **Text**-Ascent ein, und das Maximum zog die Zeilenhöhe wieder
auf den alten Wert hoch.

Drei Fassungen an derselben Testnachricht (Bilder 600×150, 320×80, 20×20):

```
der Fehler:              ascent=150  150  150     text-asc=13  150  150
mit def_style:           ascent=150   80   20     text-asc=13    0    0
jetzt:                   ascent=150   80   20     text-asc=13   13   13
```

Die mittlere Fassung war der erste Entwurf. Sie stellt zwar die Bildhöhen
richtig, setzt den Text-Ascent aber auf null — damit fällt die Schutzregel
*„die Zeile ist mindestens so hoch wie der Text"* weg, und ein Zählpixel von
1×1 ließe die Zeile auf einen Punkt schrumpfen. Solche Pixel stehen in
Newslettern zu Dutzenden. Deshalb wird jetzt der echte Text-Ascent gemerkt,
solange noch kein Bild eingefügt wurde.

**Das erklärt, warum vier Fassungen lang jede Änderung an der Bildgröße mal
half und mal nicht:** gedreht wurde am ersten Bild, alle folgenden übernahmen
dessen Höhe blind. Bei der Doctolib-Nachricht steht der kleine Schriftzug vor
dem großen blauen Kreis — deshalb wurde dort abgeschnitten.

**Kein Portierungsfehler:** die Stelle ist in allen vier Kopien im Repo
identisch, also seit 2006 so.

**Wie es gefunden wurde.** Zum ersten Mal an einem selbst gestarteten Eudora
statt an Bildschirmfotos: eine Testnachricht mit drei Bildern bekannter Größe,
Weiterleiten über Fensterbotschaften ausgelöst, und eine Spurmarke, die je Bild
vier Werte in **einer** Zeile nennt. Die erste Messung schrieb nichts — das
Testverzeichnis trug noch die alte `Eudora.exe`. Dieselbe Klasse, gegen die es
hier eine eigene Regel gibt: *das Paket gegen den Bau messen.*

**Tests: 153 von 153.**

## 7.2.0.61 — eingebettete und externe Bilder werden endlich unterschieden (E-95)

> **Noch nicht bestätigt.** Zu prüfen: die Doctolib-Nachricht weiterleiten. Die
> Bilder müssen **vollständig** dastehen und der Text **frei** bleiben — beides
> zugleich, zum ersten Mal.

**Der Fund steckte in Gregors Bild zu 1.0.60:** der blaue Doctolib-Kreis war
**blau**, nicht grau. Paige hatte das Bild also **geladen** und kannte seine
echte Größe genau — es ist in der Nachricht **eingebettet** (`cid:`). Unser
`height="20"` überschrieb diese Größe und schnitt das Bild ab.

Bei der FairToner-Nachricht dagegen standen graue Kästen: dort sind die Bilder
**extern** (`http://…`), werden beim Verfassen nicht geholt, und Paige weiß
nichts über ihre Größe. **Nur dort hilft eine Vorgabe.**

`E89BilderMessbarMachen` hat beide Fälle gleich behandelt. Das erklärt das
Schwanken über vier Fassungen:

| Fassung | Vorgabe | Ergebnis |
|---|---|---|
| 7.2.0.57 | 200×90 | großer grauer Kasten im Text |
| 7.2.0.58/59 | keine | Text wird zugedeckt |
| 7.2.0.60 | 20×20 | Bilder zerschnitten |
| **7.2.0.61** | **nur bei externen** | Text frei **und** Bilder ganz |

Es war nie eine Frage der richtigen Zahl — es waren zwei Fälle, die wie einer
behandelt wurden.

**Drei Fälle, drei Tests:**

| | |
|---|---|
| eingebettet **ohne** Größe | unangetastet — Paige kennt sie |
| eingebettet **mit** Größe | wird umgeschrieben — die Größe ist die Absicht des Absenders |
| extern ohne Größe | Vorgabe 20 Punkte, sonst bleibt die Zeile textklein |

Der mittlere Fall war ein Denkfehler im ersten Entwurf: der übersprang **alle**
`cid:`-Bilder, auch die mit CSS-Größe, wo Paige sonst die Originalgröße der
Datei nimmt statt der gewünschten. **Zwei bestehende Tests haben es sofort
gemeldet**, bevor eine Fassung daraus wurde.

Die Spurmarke nennt jetzt `eingebettet=N`.

**Tests: 153 von 153**, drei davon neu.

## 7.2.0.60 — ein kleines Vorgabemaß für Bilder ohne Höhe (E-89, dritter Anlauf)

> **Noch nicht bestätigt.** Zu prüfen: die Doctolib-Nachricht weiterleiten. Der
> blaue Kreis darf den Verifizierungscode nicht mehr zudecken.

**Warum es einen dritten Anlauf braucht — wir haben uns selbst im Weg
gestanden.** Die Zeilenhöhe hängt an `image_record.source_height`, und der Wert
kommt aus dem **`height`-Attribut** der Nachricht (`PGHTMIMP.CPP:2022`), nicht
aus der Bilddatei. Fehlt das Attribut, ist er null, der ganze Block wird
übersprungen, und die Zeile bleibt textklein. Genau dann deckt das Bild den Text
zu.

Die 200×90-Vorgabe, die in 7.2.0.58 **entfernt** wurde, war das, was diesen Wert
bisher gesetzt hat. Gemessen an Gregors Bild zu 1.0.59, Doctolib-Nachricht:

```
E-89 Bilder im Editor: gesamt=5 unveraendert=4 ohne-Mass=1 geaendert=0
```

Ein Bild ohne Maß — und der blaue Kreis lag über dem Code.

**Jetzt ein kleines Maß**, gerade so hoch wie eine Textzeile (20 Punkte). Die
Zeile wird so hoch, dass nichts zugedeckt wird, und der Platzhalter fällt kaum
auf. Den grauen Kasten selbst gibt es ohnehin: Paige zeichnet ihn für jedes
Bild, das es nicht geladen hat — auf Gregors Bildern stehen welche in **echten**
Bildmaßen. Die Frage war nur, wie groß er ist.

Drei Anläufe an einem Tag: 200×90 (zu groß), gar nichts (Text wird zugedeckt),
20×20. Gregors Entscheidung: *„ok, option a"*.

**Von Gregor an 1.0.60 gemessen — der Text ist frei, aber die Bilder werden
zerschnitten ([E-95](Intern/BEFUNDE.md#e-95)).** Auf seinem Bild ist der blaue Doctolib-Kreis **blau**,
nicht grau: Paige hat das Bild geladen und kennt seine echte Größe. Es ist
**eingebettet** (`cid:`), und unser `height="20"` schneidet es ab. Bei externen
Bildern (`http:`) ist die Vorgabe dagegen richtig — dort weiß Paige nichts. Die
Unterscheidung fehlt und kommt in 7.2.0.61.

**Tests: 150 von 150.**

**Neu aufgeschrieben, nicht behoben:** die Betreffzeile wird mitten im Wort
umbrochen (`Toner bestel len`, `Wochenend e!`). Das sind **nicht** die Stellen, an
denen Emoji entfernt wurden — `15 %` steht korrekt zusammen — die Messung dazu steht bei [**E-90**](Intern/BEFUNDE.md#e-90) (**offen**, als Grenze eingestuft und zurückgestellt, nicht behoben). Ursache
noch ungemessen, siehe [BEFUNDE.md](Intern/BEFUNDE.md) unter [E-94](Intern/BEFUNDE.md#e-94).

## 7.2.0.59 — kein Inhaltsverlust mehr beim Weiterleiten (E-93), und die Fragezeichen sind weg (E-90)

> **Noch nicht bestätigt.** Die Prüfanleitung steht unten.

### E-93: beim Weiterleiten gingen 83 Prozent des Inhalts verloren

Gefunden am 14.09.2026 beim Vergleich zweier Bilder: dieselbe Nachricht, einmal
über Thunderbird weitergeleitet, einmal über Eudora. Die Eudora-Fassung zeigte
ein zu einem Streifen gequetschtes Logo. **Die eingebaute Spurmarke nannte die
Ursache in einer Zeile:**

```
Fassung=EDITOR (Anwender hat im Zitat geaendert)
OrigBytes=105125  EditorBytes=17889  Fundstelle=-1
```

Hinaus gingen **17.889 statt 105.125 Byte**, obwohl niemand etwas angefasst
hatte. [E-88](Intern/BEFUNDE.md#e-88) prüft, ob der Klartext des Originals als ein zusammenhängendes
Stück in der Editorfassung steckt. Bei einer Weiterleitung **einer bereits
weitergeleiteten** Nachricht (`Fw: Fw:`) baut Paige den verschachtelten Text so
um, dass der Vergleich ins Leere greift — und der Fehlschlag wurde als „der
Anwender hat im Zitat geändert" gedeutet.

**Jetzt wird zuerst gefragt, ob überhaupt getippt wurde.** Paige führt darüber
Buch (`CPaigeEdtView::HasChanged`). Hat der Anwender nichts angefasst, gibt es
nichts zu schützen, und das Original geht hinaus. Die Regel greift
ausschließlich in diesem Fall; im Zweifel bleibt alles beim Alten.

### E-90: nicht darstellbare Zeichen fallen weg statt zu Fragezeichen zu werden

Ein Emoji ergab **zwei** Fragezeichen, weil es außerhalb der Grundebene liegt
und Windows jede Hälfte des Surrogatpaars einzeln ersetzt. Unsichtbare Zeichen
(Zero-Width-Space und Verwandte, in Newslettern zu Dutzenden zwischen den
Buchstaben) wurden ebenfalls zu Fragezeichen. Beides fällt jetzt ersatzlos weg.
Kyrillisch, Griechisch und Polnisch bleiben unangetastet.

## Zum Prüfen

| | |
|---|---|
| **1. Der Inhaltsverlust** | Die verschachtelte Weiterleitung (`Fw: Fw:`) noch einmal weiterleiten, **ohne etwas dazuzuschreiben**. Die angekommene Nachricht muss so vollständig aussehen wie die Thunderbird-Fassung |
| **2. Die Gegenprobe** | Dasselbe noch einmal, aber **etwas dazuschreiben**. Der eigene Text muss ankommen |
| **3. Im Protokoll** | `LogLevel=58527`. Bei 1 muss `Fassung=ORIGINAL` und `getippt=0` stehen, bei 2 `Fassung=EDITOR` und `getippt=1` |
| **4. Die Fragezeichen** | Eine Nachricht mit Emoji ansehen. Statt `?? ?? ??` steht dort jetzt nichts |

**Tests: 150 von 150**, zwei davon neu — der zweite ist die Gegenprobe, ohne
die die neue Regel den eigenen Text verschlucken könnte.

## 7.2.0.58 — die Bildhöhe zählt wieder für die Zeilenhöhe (E-89)

> **Von Gregor am 14.09.2026 an 1.0.58 bestätigt.** Auf seinem Bild steht die
> Tonerkartusche sauber über ihrem Text, „Artikelnummer" und „Nachbestellung
> mit Order No" sind frei und lesbar. Auf die Rückfrage, wo noch etwas
> überlappe: *„keine überlappung."*

**Die Ursache war eine einzige tote Zeile.** In `PGHTMIMP.CPP:2110-2111` stand:

```c
current_style.ascent = image_record.source_height;   // Bildhöhe gesetzt
current_style.ascent = (short)original_descent;      // … sofort überschrieben
```

`original_descent` stammt aus dem **Textstil**, aufgenommen bevor das Bild
überhaupt bekannt war. Übrig blieb `ascent = max(Text-Ascent, Text-Descent)` —
drei bis zwölf Bildpunkte, **unabhängig davon, wie hoch das Bild ist**. Ein
150 Punkt hohes Bild saß in einer textkleinen Zeile und deckte zu, was darüber
stand. Die zweite Zeile ist gestrichen; damit wirkt die erste wie beabsichtigt.

**Dass diese Stelle zählt, ist gemessen:** `ProcessEmbed` (`:2962`) setzt
`translator.format = current_style`, und der Aufruf steht zwanzig Zeilen
darunter.

**Der Umweg aus 7.2.0.57 ist zurückgenommen.** Die Vorgabe 200×90 für Bilder
ohne bekanntes Maß erschien auf Gregors Bild als leerer grauer Kasten: Platz,
der weggenommen wird, ohne dass etwas zu sehen ist. Ein Bild ohne Maß bleibt
jetzt unangetastet — Paige kennt die wirkliche Größe, sobald es die Datei
geladen hat. Dabei fiel ein zweiter Fehler auf: die Vorgabe traf auch Bilder,
von denen **nur die Breite** bekannt war; die bekommen jetzt ihre Breite und
keine erfundene Höhe. Der Deckel gegen zu breite Bilder bleibt.

**Wie 7.2.0.57 sich widerlegt hat:** die eingebaute Spurmarke nannte in
Gregors Lauf `gesamt=25 unveraendert=22 aus-CSS=0 gedeckelt=0` — kein einziges
Bild hatte seine Größe im CSS, keines war zu breit, geändert wurden 48 Bytes
von 62.057. Die Bilder überlappten, **obwohl ihre Größe stimmte**. Damit war
die Größe als Ursache ausgeschlossen und die Suche auf die **Position**
gelenkt.

**Tests: 148 von 148.** Vier davon umgeschrieben, weil sie die Vorgabe
festhielten; sie prüfen jetzt das Gegenteil.

## 7.2.0.57 — der Versuch, die Bilder im Verfassenfenster zu bändigen (E-89, **wirkt nicht**)

> **Von Gregor am 14.09.2026 an 1.0.57 gemessen und abgelehnt:** *„findest du,
> es ist leserlich? ich nicht!"* Auf seinem Bild liegt die Tonerkartusche über
> „Artikelnummer" und „Nachbestellung mit Order-No", darunter steht ein leerer
> grauer Kasten. **Die Spurmarke aus seinem Lauf widerlegt die angenommene
> Ursache:** `gesamt=25 unveraendert=22 aus-CSS=0 Vorgabe=3 gedeckelt=0` — kein
> einziges Bild hatte seine Größe im CSS, keines war zu breit, geändert wurden
> 48 Bytes von 62.057. Die Bilder überlappen, **obwohl ihre Größe stimmt**.
> Damit ist die fehlende Bildgröße als Ursache ausgeschlossen; gesucht wird ab
> jetzt bei der **Position**, nicht der Ausdehnung. Der Stand bleibt im
> Programm, weil er nichts verschlechtert außer der 200x90-Vorgabe — die
> erzeugt den grauen Kasten und wird zurückgenommen. Einzelheiten in
> [BEFUNDE.md](Intern/BEFUNDE.md) unter [E-89](Intern/BEFUNDE.md#e-89).

**Was Gregor damit tun kann:** einen Newsletter weiterleiten und dabei
**lesen, was er schreibt**. Bisher lagen Logo und Kacheln in Originalgröße
über der Überschrift und über den Absätzen — *„1 und da ist alles
durcheinander, man kann ja nichts lesen."* (14.09.2026, an 1.0.56). **Von
ihm noch nicht bestätigt.**

**Der Maßstab ist Thunderbird — aber nur seine Schwelle, nicht sein
Aussehen.** Gregor hat sein Thunderbird-Verfassenfenster mit derselben
Nachricht gezeigt: auch dort ist es nicht schön, rote Hilfslinien um jede
Tabellenzelle. Aber jedes Bild sitzt in seiner Zelle, und der Text daneben
ist vollständig lesbar. Thunderbird rechnet mit Gecko, also mit einer
echten HTML-Maschine; Paige übersetzt HTML in ein eigenes Format und kennt
keine einzige CSS-Eigenschaft (`PGHTMDEF.C:20-48`). **Das Bild links ist
nicht erreichbar. Die Lesbarkeit ist es.**

### Warum das Verfassenfenster überhaupt geändert werden darf

Seit [**E-88**](Intern/BEFUNDE.md#e-88) (7.2.0.56) geht beim Senden das aufgehobene Original hinaus,
nicht die Editorfassung. Das Verfassenfenster ist damit nur noch
Arbeitsfläche: es muss dem Original nicht gleichen, es muss lesbar sein.
Ohne [E-88](Intern/BEFUNDE.md#e-88) wäre dieselbe Änderung ein Eingriff in die versandte Nachricht
gewesen.

### Zwei Ursachen, beide gemessen

**(1) Keine auswertbare Größe.** Paiges HTML-Leser holt die Bildgröße
**ausschließlich** aus den Attributen `width` und `height`
(`PGHTMIMP.CPP:2019-2022`). Steht sie nur im CSS — `style="width:16px"` —,
bleiben `source_width` und `source_height` auf `0`. Nachgetragen werden sie
erst beim **Laden** des Bildes, aus der Datei, also in **Originalgröße**
(`PgEmbeddedImage.cpp:424-427`) — da war der Absatz längst umbrochen. Der
Nachtrag sucht seine Stelle dann über `embed->style == embed_ptr->style`
(`PgEmbeddedImage.cpp:458-507`) und bleibt beim **ersten** Bild gleichen
Stils stehen; bei mehreren Bildern trifft er die falsche. Genau das ist das
Übereinanderliegen.

**(2) Auswertbar, aber zu breit.** Ein zweites Thunderbird-Bild
(freenet/audibene-Rundbrief) zeigt dasselbe Kopflogo im schmalen
Verfassenfenster schmal und in der breiteren Leseansicht breiter —
proportional auf die verfügbare Spaltenbreite gerechnet. Ein `<img>` mit
`width="1200"` sprengt die Zeile auch dann, wenn Paige die Zahl lesen kann.

**Gemessen an Gregors gesicherten Postfächern** (alle `.mbx` unter
`C:\Users\Gregor\Eudora72-Postfaecher-gesichert`): **2884** `<img>`, davon
**2601** mit Attribut, **122** nur mit CSS-Größe, **161** ganz ohne
Größenangabe.

### Was jetzt passiert

`E89BilderMessbarMachen` (`msgutils.cpp`) schreibt die Fassung um, die in
den Editor geht:

* aus `style="width:16px"` wird zusätzlich `width="16"`; das `style` bleibt
  stehen, Paige sieht ohnehin darüber hinweg
* aus `style="width:100%"` wird `width="100%"` — `decimal_value_percent`
  rechnet Prozent gegen die Seitenbreite (`PGHTMIMP.CPP:2020`). Für die
  **Höhe** geht das nicht: dort liest `numeric_value` nur die Zahl, aus
  `50%` würden 50 Bildpunkte. Also lieber die Vorgabe
* wo gar nichts steht, greift **200x90**. Hier ist nichts zu rechnen —
  weder Originalgröße noch Seitenverhältnis sind bekannt, und nachgeladen
  wird beim Verfassen nichts
* **kein Bild wird breiter oder höher als 600 Bildpunkte**; das jeweils
  andere Maß geht im selben Verhältnis mit, damit nichts verzerrt

Ein Bild, das `width` und `height` bereits als Attribut trägt und unter dem
Deckel bleibt, wird **Zeichen für Zeichen** nicht angefasst — das sind die
meisten. `src` bleibt in jedem Fall unberührt, damit eingebettete
`cid:`-Teile weiter gefunden werden.

**Gemessen statt vermutet, dass die echte Fensterbreite nicht zu haben
ist:** der Aufruf in `CSummary::ComposeMessage` geht mit
`kDontDisplayOrQueue` hinein (`summary.h:142`), und beide Zweige, die ein
Fenster erzeugen könnten, hängen an dieser Bedingung
(`summary.cpp:1818-1837`). Zur Umschreibzeit gibt es kein
Verfassenfenster, und ein gespeichertes Maß auch nicht. Deshalb ein fester
Deckel.

### Warum nicht der Platzhalter

Das Bild durch `[Bild]` zu ersetzen wäre radikaler und sicherer lesbar —
und würde **[E-88](Intern/BEFUNDE.md#e-88) zerstören**. `E88OriginalEinsetzen` verlangt, dass der
Klartext des Originals in der Editorfassung als **ein** zusammenhängendes
Stück steckt. `E88NurText` wirft Markierungen weg, ein zusätzliches
`width=` ist für den Vergleich also unsichtbar; ein eingefügtes `[Bild]`
mitten im Zitat zerreißt ihn, und das Original ginge nie wieder hinaus. Ein
Test fährt genau diese Gegenprobe, damit die Begründung nicht nur behauptet
ist.

### Wie sichergestellt ist, dass das Original unberührt bleibt

Die beiden Fassungen trennen sich an **einer** Stelle in `summary.cpp`:
`ComposeMessage` bekommt `EditorBody`, gemerkt wird `Body`. Beides hängt an
derselben Bedingung `bE88Merken` — ist `ForwardOriginalHTML` auf `0`, geht
die Editorfassung selbst hinaus, und dann unterbleibt auch die Umschrift.
Jeder Testaufruf misst zusätzlich nach, dass der Eingangstext danach Byte
für Byte derselbe ist.

### Zum Prüfen

`LogLevel=58527` in die `Eudora.ini` (die Vorgabe `25759` enthält
`DEBUG_MASK_MISC` nicht), dann einen Newsletter mit Bildern weiterleiten.
Im Verfassenfenster: **nichts liegt übereinander, jeder Satz ist lesbar.**
Im Protokoll steht eine Zeile

```
E-89 Bilder im Editor: gesamt=… unveraendert=… aus-CSS=… Vorgabe=… gedeckelt=… geaendert=… Bytes vorher=… nachher=…
```

und unmittelbar danach beim Absenden die beiden E-88-Zeilen, die weiterhin
`Fassung=ORIGINAL` sagen müssen. Sagen sie das nicht mehr, hat [E-89](Intern/BEFUNDE.md#e-89) dem
Befund [E-88](Intern/BEFUNDE.md#e-88) etwas weggenommen — dann ist es ein Fehler, kein Fortschritt.

**Grenzen, die bleiben:** Kästen, Rahmen und Hintergründe erscheinen im
Verfassenfenster weiterhin nicht; die Tabellenaufteilung wird nicht
nachgebaut; und wo keine Größe bekannt ist, ist 200x90 geraten und kann
verzerren. Beim Empfänger ändert sich davon nichts.

**Gebaut:** 0 Fehler. **Tests:** 148 von 148 bestanden — 131 alte, 17 neue
zu [E-89](Intern/BEFUNDE.md#e-89), davon sieben Gegenproben.

## 7.2.0.56 — die weitergeleitete Nachricht kommt an, wie sie gelesen wurde (E-88)

**Was Gregor damit tun kann:** einen Newsletter weiterleiten oder
beantworten und darauf zählen, dass der Empfänger ihn mit Kästen,
Hintergründen, richtigen Bildgrößen und Emoji sieht — also so, wie Gregor
ihn beim Lesen vor sich hatte. **Von ihm noch nicht bestätigt.**

Das ist die zweite Hälfte von [**E-87**](Intern/BEFUNDE.md#e-87). Dort wurde erreicht, dass HTML
überhaupt zitiert wird; hier geht es darum, dass es den Verfassen-Editor
unbeschädigt überlebt. Seine Entscheidung zur Umsetzung: *„ich nehme deine
empfehlung."*

### Warum es keinen anderen Weg gab

Verfasst wird mit **Paige**. Dessen HTML-Leser kennt **keine einzige
CSS-Eigenschaft** (`PGHTMDEF.C:20-48`), aus `div` wertet er allein `align`
aus (`PGHTMIMP.CPP:1193-1201`). Von **1506** `<img>` in Gregors Postfach
tragen **1262** ihre Größe als HTML-Attribut — die kann Paige
(`PGHTMIMP.CPP:1897-1916`) —, **162 nur als CSS**; die erschienen in
Originalgröße und überlagerten den Text. Ein zweiter, HTML-fähiger Editor
steht nicht zur Verfügung: Trident-Ansichten gibt es nur zum Lesen,
`CCompMessageFrame` erzeugt fest `PgCompMsgView`.

Den Editor HTML beibringen war also ausgeschlossen. Bleibt: den Editor
umgehen.

### Was jetzt passiert

`CSummary::ComposeMessage` legt den Rumpf, wie `QuoteText` ihn gebaut hat,
im Verfassendokument ab (`summary.cpp:1497`). `PgMsgView::ExportMessage`
(`PgMsgView.cpp:407`) — die eine Stelle, an der die Editor-Fassung über
`pDoc->SetText()` zum Rumpf der Nachricht wird und damit auf die Leitung
geht (`sendmail.cpp:3368`) — setzt statt ihrer das Original ein, **sobald
sich belegen lässt, dass im Zitat nichts geändert wurde.**

Der Beleg ist ein zustandsloser Vergleich: der Klartext des Originals
(Markierungen weg, Entitäten und alles über 127 zu `?`, Leerraum
zusammengezogen) muss sich im Klartext der Editor-Fassung als **ein
zusammenhängendes Stück** wiederfinden. Was davor und dahinter steht, ist
Gregors eigener Text und wird wieder angesetzt. Findet sich das Original
nicht — weil im Zitat etwas geändert wurde —, bleibt es bei der
Editor-Fassung.

**Warum gerade dieses Verfahren:** es braucht keinen gemerkten Vorzustand,
keinen Änderungszähler und keine Annahme darüber, wo der Anwender tippt.
Paiges eigener Zähler (`PaigeEdtView.h:192-193`) taugte nicht, weil jedes
Zwischenspeichern ihn zurücksetzt (`compmsgd.cpp:1815`). Die Annahme „der
Zusatz steht immer vorn" taugte nicht, weil eine angehängte Signatur
dahinter steht. Und eine von Hand gebaute MIME-Nachricht mit zwei Teilen
hätte an `sendmail.cpp` vorbei eine zweite Erzeugung aufgemacht — zu viel
Fläche für einen Fehler, den vor dem Absenden niemand sieht.

### Die beiden Sicherungen

Sie sind Bedingung, nicht Zugabe — das Verfassenfenster zeigt ja etwas
anderes als das, was hinausgeht.

* **Drei Spurmarken**, alle `DEBUG_MASK_MISC` (`LogLevel=58527`).
  `E-88 vor dem Absenden` nennt die gewählte Fassung und den Grund, beide
  Größen, die Länge des eigenen Zusatzes davor und dahinter und den
  Antworttyp. `E-88 auf der Leitung` nennt, was **wirklich** hinausgeht.
  `E-88 eingebettete Teile` meldet, wenn das Aufräumen der eingebetteten
  Bilder übersprungen wurde — dazu der Abschnitt darunter.
* **Der Schalter `ForwardOriginalHTML`** (Vorgabe `1`, `[Settings]`,
  `EudoraRes.rc:7668`). Mit `0` gilt wieder das Verhalten von 7.2.0.55.
  Dokumentiert in [EINSTELLUNGEN.md](Intern/EINSTELLUNGEN.md), Abschnitt 3.

### Die Bilder mussten mitgesichert werden

`PgMsgView::SaveInfo` warf bisher jeden eingebetteten Teil weg, dessen
`cid:`-Kennung im Paige-Inhalt nicht mehr vorkam. Das ist richtig, solange
die Paige-Fassung die Nachricht ist — setzt `ExportMessage` gleich darauf
das Original ein, zeigt dieses auf bereits gelöschte Teile, und beim
Empfänger fehlte das Bild **ohne jede Meldung**. Solange ein Original
aufgehoben ist, unterbleibt das Aufräumen; der Preis sind höchstens ein
paar unreferenzierte Teile in der Nachricht — derselbe Zustand, in dem sie
vor dieser Schleife ohnehin war.

### Was das NICHT behebt

* **Das Verfassenfenster bleibt schlicht.** Paige kann weiterhin kein CSS,
  und daran ändert der Umbau nichts — er ändert nur, was hinausgeht.
* **Wer im zitierten Teil etwas ändert, bekommt wieder die alte Fassung.**
  Das ist Absicht: sonst ginge die Änderung verloren.
* **Der eigene Zusatz geht als reiner Text hinaus**, nicht mit seiner
  Auszeichnung.
* **Nach dem Schließen des Verfassenfensters ist das Original fort.** Wird
  die Nachricht später aus *Out* erneut geöffnet, gilt wieder das alte
  Verhalten; die Spurmarke sagt dann `EDITOR (kein Original gemerkt)`.

**Testlauf: 131 Tests, 131 bestanden, 0 fehlgeschlagen** — zehn davon neu
zu [E-88](Intern/BEFUNDE.md#e-88) (`TestE88.cpp`), darunter fünf **Gegenproben**: im Zitat geändert,
mitten im Zitat gelöscht, Schalter auf `0`, kein Original gemerkt, reiner
Textrumpf. Der geprüfte Code wird von `Extract.ps1` bei jedem Bau frisch
aus `msgutils.cpp` geschnitten, nicht abgeschrieben.

### Zum Prüfen

1. Eudora beenden, `eudora.log` löschen, `LogLevel=58527` in `[Debug]`.
2. Starten, den Newsletter aus [**E-86**](Intern/BEFUNDE.md#e-86) weiterleiten — einmal ohne
   Kommentar, einmal mit einem Satz darüber. Beide an die eigene Adresse.
3. Im Protokoll nach [`E-88`](Intern/BEFUNDE.md#e-88) suchen. Erwartet: `Fassung=ORIGINAL
   (unveraendert)` beim ersten, `Fassung=ORIGINAL (mit Zusatz)` beim
   zweiten, und `E-88 auf der Leitung` mit `IsFancy=2` (HTML).
4. Die angekommenen Nachrichten neben das Original halten.

Steht dort `Fassung=EDITOR`, sagt der Klammerzusatz den Grund.

---

## 7.2.0.55 — HTML bleibt erhalten, beim Lesen wie beim Weiterleiten (E-86, E-87)

**Was Gregor damit tun kann:** eine HTML-Nachricht weiterleiten oder
beantworten, ohne dass Fettung, Kursiv, Verweise, Schriftfarben und
Tabellenhintergründe verlorengehen. **Von ihm noch nicht bestätigt.**

Sein Befund: die weitergeleitete Nachricht kam beim Empfänger als Fließtext
mit blauen Verweisen an — *„kommt auch so an"*. Seine Entscheidung zur
Umsetzung: *„neue INI-Einstellung machen, die für beides gilt. und HTML immer
behält. und es aber dokumentieren."*

### Ein Weg, nicht zwei

Antworten und Weiterleiten laufen beide durch `CSummary::ComposeMessage`
(`summary.cpp`, ab Zeile 899) — `ID_MESSAGE_FORWARD` und `ID_MESSAGE_REPLY`
sind zwei `case` derselben Funktion. Ein Schalter an einer Stelle genügt.

Die Stelle, die ich zuerst genannt hatte (`TocFrame.cpp:1684`), war **nicht**
der normale Weg, sondern der Sonderfall *Antwort auf mehrere ausgewählte
Nachrichten*.

### Die Ursache

`summary.cpp:1110` verwarf das Ergebnis der eigenen Messung:

```c
IsRich = IsFancy(fullMes);
if (!IsFlowed() && !IsXRich() && IsRich != IS_FLOWED)
    IsRich = IS_ASCII;
```

`IsFancy` hatte den Rumpf bereits **als HTML erkannt** — herabgestuft wurde
trotzdem, sobald die Flags `MSF_XRICH`/`MSFEX_FLOWED` im Übersichtseintrag
fehlten. `IS_ASCII` bedeutet für `QuoteText`, dass nicht der HTML-Zweig über
`GetBodyAsHTML` genommen wird, sondern `WrapText` mit `">"`-Präfix. Die blauen
Verweise im Ergebnis stammten von `MakeAutoURLSpaghetti`, nicht aus der
Nachricht.

### Der Schalter

| Schlüssel | Abschnitt | Vorgabe | wirkt |
|---|---|---|---|
| `KeepHTMLInResponses` | `[Settings]` | **1** | die Messung am Rumpf zählt mehr als die Flags |

`0` stellt das alte Verhalten her. Dokumentiert in
[EINSTELLUNGEN.md](Intern/EINSTELLUNGEN.md) — **und nur dort**: bis zum 14.09.2026
standen dieselben Schlüssel in zwei Tabellen, im README und in
`EINSTELLUNGEN.md`, zwölf davon in beiden. Gregors Entscheidung: *„nur in
einstellungen, nicht in readme"*. Das README verweist jetzt.

### Was der Schalter NICHT behebt

Verfasst wird mit **Paige**, und dessen HTML-Leser kennt **kein `span` und
keine einzige CSS-Eigenschaft** (`PGHTMDEF.C:20-48` — weder
`background-color` noch `border`, `padding`, `margin`); aus `div` wertet er
allein `align` aus. Was Paige nicht versteht, ist nach `ExportMessage`
endgültig fort — **und genau dieser Text geht hinaus.**

Es überleben also: **Fettung, Kursiv, Verweise, Schriftfarben,
`<table bgcolor>`.** Es überleben **nicht**: CSS-Kästen und -Hintergründe
eines modernen Newsletters. Das ist keine Stelle, die HTML wegwirft, sondern
ein Editor, der es nicht halten kann — dafür reicht kein Schalter. Als Grenze
dokumentiert in `EINSTELLUNGEN.md`.

**Seit 7.2.0.56 erledigt:** der Original-HTML-Block wird am Paige-Editor
vorbeigeführt und beim Senden wieder eingesetzt ([**E-88**](Intern/BEFUNDE.md#e-88), Abschnitt
darüber). CSS-Kästen und -Hintergründe kommen damit beim Empfänger an —
im Verfassenfenster sind sie weiterhin nicht zu sehen.

### Und die Anzeige: HTML-Nachrichten sehen aus wie im Browser (E-86)

**Was Gregor damit tun kann:** einen HTML-Newsletter öffnen und ihn so sehen,
wie ihn ein Browser zeigt — abgerundete Kästen statt eckiger, keine blauen
Rahmen um verlinkte Bilder. **Von ihm noch nicht bestätigt.**

**Zwei Verdächte wurden vorher widerlegt, beide am laufenden Programm.** Der
erste war meiner: Eudora lege sein eigenes `<html><head><body>` um die
Nachricht, MSHTML verwerfe deren zweites, und damit fielen Hintergrund und
Rahmenangaben weg. Der zweite: beim Zusammensetzen gehe etwas verloren.

Gemessen mit einer Spurmarke, die die fertige Anzeigedatei sichert:

```
E-86 fixup: FixupSource laeuft  BODY-Elemente=1  Hintergrund=#ffffff
```

**`BODY-Elemente=1`** — es gibt kein zweites `<body>`. Und die gesicherte
Datei hat **36.078 Bytes, 67 Tabellen, 12 Bilder und alle 118
`border`-Angaben** der Nachricht, sogar eine mehr als das Original (Eudoras
Zitatbalken). Beim Zusammensetzen geht **nichts** verloren.

**Die Ursache war der Rendermodus.** MSHTML läuft ohne besondere Anweisung im
Standardmodus des **Internet Explorer 7 von 2006**. Die Mail enthält dreimal
`border-radius`, das dieser Modus nicht kennt — abgerundete Ecken werden zu
Kästen, und was im CSS einen Rahmen unterdrücken soll, greift nur teilweise.

Behoben mit einer Zeile, als erste im Kopf der Anzeigedatei:

```html
<meta http-equiv="X-UA-Compatible" content="IE=edge">
```

**Gegenprobe am laufenden Programm:** dieselbe Spurmarke meldet jetzt
`Hintergrund=transparent` statt `#ffffff`. Der Modus hat nachweislich
gewechselt.

**Nebenbei gelernt:** Der erste Messlauf war ungültig. Das Werkzeug öffnete die
erstbeste Nachricht — die weitergeleitete aus dem Out-Postfach, die durch [E-87](Intern/BEFUNDE.md#e-87)
ohnehin formatierungslos ist (Anzeigedatei 4774 B, `<body>` ohne Attribute).
Erst als in der `Eudora.ini` nur noch ein Postfach als offenes Fenster stand,
wurde die richtige getroffen.


**Testlauf: 121 Tests, 121 bestanden, 0 fehlgeschlagen.**

## 7.2.0.54 — zwei Spurmarken, die E-86 entscheiden

**Was Gregor damit tun kann:** die Newsletter-Mail öffnen und danach zwei
Dinge liefern, die den Befund entscheiden — die Datei `E86-Anzeige.htm` im
Eudora-Verzeichnis und die Zeile `E-86 fixup:` im Protokoll. **Behoben ist
[E-86](Intern/BEFUNDE.md#e-86) damit nicht.**

**Der erste Verdacht ist widerlegt, und zwar gemessen.** Er lautete: Eudora
legt sein eigenes `<html><head><body>` um die Nachricht, MSHTML verwirft
deren zweites `<head>`/`<body>`, und damit fallen Hintergrundfarbe,
`img{border:0}` und die Bildgrößen weg.

Nachgemessen wurde mit einer **echten** Nachricht aus Gregors Postfach: der
Weg des Programms wurde nachgebaut, beide Fassungen in MSHTML geladen und der
**berechnete** Stil aus dem DOM gelesen. Für alle fünf geprüften Nachrichten:

```
MAIL-ALLEIN     body-Hintergrund=#000000  img-in-a-Rahmen=0px
EUDORA-FASSUNG  body-Hintergrund=#000000  img-in-a-Rahmen=0px  Stylesheets=3
```

`Stylesheets=3` heißt: Eudoras Stylesheet **und** die beiden der Mail —
MSHTML verwirft nichts. Das Abbild zeigt schwarzen Grund und rahmenlose
Bilder.

Dazu passt, dass das Original den Fall längst kennt: **`CTridentView::FixupSource`**
(`TridentView.cpp:1912`) existiert ausdrücklich für das zweite `<body>`-Tag
und kopiert dessen Attribute auf das erste.

**Deshalb wurde nichts geändert.** Ein Symptom zu überdecken, dessen Ursache
nicht belegt ist, hätte den Befund nur unsichtbar gemacht.

Stattdessen zwei Spurmarken, beide nur bei eingeschaltetem Protokoll:

1. `LoadMessage` legt die fertige Anzeigedatei als **`E86-Anzeige.htm`** im
   Eudora-Verzeichnis ab. Bisher löschte der nächste Aufbau sie — sie war
   nicht zu greifen.
2. `FixupSource` meldet in **einer** Zeile, ob es läuft, wie viele
   `BODY`-Elemente MSHTML angelegt hat und welchen Hintergrund es berechnet.

**Auch das ist gemessen:** angezeigt wird über MSHTML, nicht über Paige —
`UsingTrident()` hängt an `UseBidentAlways`, Vorgabe 1, und Gregors
`Eudora.ini` setzt den Schlüssel nicht. Die zweite Ansicht scheidet als
Erklärung aus.

**Testlauf: 121 Tests, 121 bestanden, 0 fehlgeschlagen.**

## 7.2.0.53 — Eudora lässt sich wieder beenden (E-83)

**Was Gregor damit tun kann:** Eudora beenden, ohne dass *„You currently have
1 task(s) running"* im Weg steht. **Von ihm noch nicht bestätigt.**

Sein Befund: *„immer noch die gleiche meldung, kann deshalb eudora nicht
beenden."* — und diesmal war die Spurmarke drin, die es entscheiden konnte.

**Die Anzeige log.** Im Fenster stand *„Waiting in the task queue to be started
…"*, im Protokoll stand:

```
E-83 liegengeblieben: uid=35 zustand=FERTIG(5) m_pThread=gesetzt
                      aktiv=1/10 titel="Resyncing"
```

Der Zustand ist **FERTIG**. Die Aufgabe wartete nie auf ihren Start — der Text
stammt aus `Register()` und wird nie überschrieben. Zwei Wochen lang hat dieser
Satz die Suche in die falsche Richtung geschickt.

**Die Zählung zeigt das Leck:**

| | |
|---|---|
| fertig, Nachbearbeitung angefordert | 15 |
| fertig, **ohne** Nachbearbeitung | **17** |
| liegengeblieben, alle 15 s gemeldet | 17 |

`QCTaskManager::RemoveWorkerThread` fordert die Nachbearbeitung nur an, wenn
`IsIgnoreIdleSet()` oder `m_nStartIdle == GetStartIdle()` — sonst stand dort
**nichts**. Das war eine Sackgasse: `DoPostProcessing` arbeitet ausschließlich
`m_PostProcessList` ab, und dort hinein kommt eine Aufgabe **nur** über
`RequestPostProcessing()`. Auch der Leerlauf holt sie nicht nach. Sie blieb in
`m_TaskInfoList` stehen und zählte weiter als laufend.

`m_nStartIdle` wird nur in `StartTasks()` gesetzt, also für Aufgaben aus einer
`QCTaskGroup`. IMAP-Aktionen aus `CActionQueue::OnIdle` laufen daran vorbei und
setzen auch `IsIgnoreIdle` nicht — deshalb traf es gerade IMAP.

**Zwei Vermutungen sind dabei widerlegt worden**, beide aus `BEFUNDE.md`: der
Verdacht auf `StartWorkerThread` mit `m_pThread == NULL` (der Zeiger war in
jeder gemessenen Zeile gesetzt), und eine der drei „ausgeschlossenen" Ursachen
war **falsch ausgeschlossen** — `DelayTasks`/`StartTasks` werden sehr wohl
gerufen, von `QCTaskGroup` an drei Stellen.

Dass die Ursache jetzt dasteht statt einer weiteren Vermutung, liegt an einer
Spurmarke, die Zustand, Faden, Zähler und Obergrenze in **einer** Zeile nennt.
Zwei getrennte Zeilen hätten die Ausrede „zu anderer Zeit" offengelassen.

## 7.2.0.52 — der Zeichensatz stand nie im Nachrichtenkopf (E-85, zweiter Anlauf)

**Was Gregor damit tun kann:** Mail über IMAP abrufen und die Umlaute lesen —
auch in HTML-Newslettern, also in der Sorte Nachricht, bei der es vorher nie
funktionierte. **Von ihm noch nicht bestätigt.**

**7.2.0.51 hat den Fehler nicht behoben, und sein Test hat das gezeigt.** Seine
Meldung: *„das ist auf jeden fall eine frische mail, ist aber falsch
dargestellt!"* — dazu das Bild, auf dem der **Betreff richtig** und der **Rumpf
falsch** war. Diese Kombination war der Schlüssel.

### Die Ursache

`CImapDownloader::Write` holte den Zeichensatz aus `m_pHd->m_TLMime`. **TL heißt
Top Level.** Das Feld wird genau **einmal** gefüllt — beim Holen des
Nachrichtenkopfs in `UIDFetchHeaderFull` — und beim Durchlauf durch die
MIME-Teile nie wieder gelesen.

Bei `multipart/alternative`, und das ist jeder HTML-Newsletter, steht im
Top-Level-Header **kein `charset`**, sondern nur `boundary`. Der Zeichensatz
steht im **einzelnen Teil**; dessen Struktur trägt ihn auch
(`PARAMETER *parameter`, `Imapdll/public/inc/exports.h:147`) — nur hat ihn dort
nie jemand ausgelesen.

Damit hat die Behebung in 7.2.0.51 den **Suchbereich** repariert
(`FindMIMECharset` statt einer Suche, die vor `IDS_MIME_UTF_8` endet) und
durchsuchte weiterhin die **falsche Quelle**. Bei einer einteiligen
`text/plain`-Nachricht steht der Zeichensatz tatsächlich im Nachrichtenkopf —
dort war der Weg immer richtig, und **deshalb ist es nie aufgefallen**.

Zwei Gegenproben, beide am Quelltext: in ganz `EuImap` gibt es **keine zweite
Stelle**, die den Zeichensatz eines Teils liest; und die einzige weitere
Verwendung von `charset` ist `Translate2047` im **Kopfzeilen**weg — genau
deshalb war der Betreff richtig.

### Die Behebung

Neues Feld `m_szCurrentCharset`, gesetzt an denselben drei Stellen, an denen
schon `m_CurrentBodyType` und `m_szCurrentBodySubtype` gesetzt werden, gefüllt
aus `body->parameter`. Der Zeichensatz des Teils hat Vorrang, der
Nachrichtenkopf bleibt Rückfall.

**Dazu die Spurmarke, die von Anfang an hätte dastehen müssen.** Sie nennt
**beide** Quellen in **einer** Zeile:

```
E-85 imap: teil-charset=… tl-charset=… idx=… uebersetzt=… typ=…/… zeilenweise=…
```

Einmal je Nachrichtenteil, nicht je Block. Ohne sie ließ sich nicht
unterscheiden, ob der Übersetzungsweg nicht greift oder ob nur eine alte
Nachricht angezeigt wird — und genau diese Unterscheidung hat einen ganzen
Testdurchgang gekostet.

### E-83: eine Vermutung widerlegt, eine neue Spur

Der Verdacht, der seit dem 11.09.2026 in `BEFUNDE.md` stand — `StartWorkerThread`
tue bei `m_pThread == NULL` stumm nichts — **hält nicht**. `m_pThread` wird an
genau einer Stelle geschrieben und nirgends wieder auf NULL gesetzt.

Außerdem war eine der drei „ausgeschlossenen" Ursachen **falsch
ausgeschlossen**: die Doku behauptete, `DelayTasks`/`StartTasks` rufe niemand
auf — tatsächlich ruft `QCTaskGroup` beide, und die wird an drei Stellen
benutzt.

Der neue, stärkste Kandidat: `RemoveWorkerThread` fordert die Nachbearbeitung
nur unter zwei Bedingungen an, und IMAP-Aktionen aus `CActionQueue::OnIdle`
laufen daran vorbei. Bleibt eine Aufgabe liegen, wird der Destruktor von
`CImapAction` nie erreicht, der `ActionDone()` ruft — **die Aktionswarteschlange
bleibt für immer in Bearbeitung und keine weitere IMAP-Aktion läuft**. Das wäre
zugleich die Erklärung dafür, dass nichts Neues abgerufen wird. Noch **nicht**
am laufenden Programm gemessen, deshalb nicht behoben — aber die Spurmarke
dafür ist drin und meldet alle 15 Sekunden jede liegengebliebene Aufgabe.

### Zum Prüfen

**Eine schon abgerufene Nachricht bleibt kaputt.** Die Übersetzung passiert beim
**Abruf** und landet in der Mailboxdatei; die Anzeige liest nur, was dort steht.
Es muss also eine **neue** Nachricht sein.

**Emoji werden zu `?`, und das ist richtig** — die Mailboxdatei speichert
CP1252, darin gibt es kein Emoji. Umlaute, Anführungszeichen, Gedankenstrich und
Eurozeichen müssen dagegen stimmen.

**Testlauf: 121 Tests, 121 bestanden, 0 fehlgeschlagen.**

## 7.2.0.51 — Umlaute in per IMAP abgerufenen Nachrichten (E-85)

**Was Gregor damit tun kann:** Mail über IMAP abrufen und die Umlaute lesen,
statt Zeichensalat zu sehen: in *für* steht das `ü` als UTF-8 `C3 BC`, und
wer diese zwei Bytes als CP1252 liest, bekommt zwei Zeichen statt einem.
**Von Gregor noch nicht bestätigt.**

Sein Hinweis war der Schlüssel: *„das hatten wir ja bereits gefixt, soweit ich
mich erinnern kann?"* — [**Z-2b**](Intern/BEFUNDE.md#z-2b) war am 05.09.2026 genau dieser Fehler, behoben
in `utils.cpp`, `utils.h` und `TextReader.cpp`. `TextReader` wird von acht
Dateien benutzt, und **keine davon gehört zum IMAP-Weg**.

Gefunden wurden **drei** Mängel, alle in `EuImap/src/ImapDownload.cpp`:

**Der schwerwiegendste: `charset=utf-8` wurde gar nicht erkannt.** Zeile 4645
suchte den Zeichensatz mit

```c
FindRStringIndexI(IDS_MIME_US_ASCII, IDS_MIME_ISO_LATIN9, params->value, -1)
```

Der Bereich endet bei `IDS_MIME_ISO_LATIN9` = **3613**; `IDS_MIME_UTF_8` ist
**3614** und liegt damit **dahinter**. Der Aufruf lieferte `-1`, die Bedingung
darunter war falsch, und es wurde **überhaupt nicht übersetzt** — die
UTF-8-Bytes gingen roh in die Mailboxdatei und wurden später als CP1252
angezeigt. Der POP3-Weg macht es seit jeher richtig (`mime.cpp:382`,
`FindMIMECharset`): er sucht bis `IDS_MIME_UTF_8` **und** verschiebt das
Ergebnis um eins, damit Index 0 für `windows-*` frei bleibt. Genau diese
Verschiebung fehlte ebenfalls — beide Wege rechneten auf **verschiedenen
Skalen**, während `ISOTranslate` nur eine davon kennt. Jetzt benutzt IMAP
dieselbe Funktion.

**Der zweite: der Rückgabewert von `ISOTranslate` wurde verworfen.** Die
Funktion liefert die Länge **nach** der Übersetzung; UTF-8 wird auf dem Weg
nach CP1252 kürzer. `outLen` behielt die alte Länge bis zum `m_mbxFile.Put()`,
also wurden die überzähligen Altbytes mitgeschrieben.

**Der dritte: der Übertrag über die Stückgrenze fehlte.** Die Behebung von
[Z-2b](Intern/BEFUNDE.md#z-2b) hält angefangene UTF-8-Zeichen am Ende eines Lesestücks zurück — nur im
POP3-Weg. IMAP liest bei `text/plain` zeilenweise, bei **`text/html` aber in
Blöcken von 8192 Bytes**, und hielt nichts zurück. Neu dafür ist
`ISOTranslateChunk` in `utils.cpp`. Der POP3-Weg schiebt den Übertrag *vor*
das Stück; das geht hier nicht, weil der Zeiger aus
`CChunkReader::GetNextChunk` in fremden Speicher zeigt. Deshalb umgekehrt: das
Zeichen wird **hinter** seine eigenen, verbrauchten Bytes geschrieben.

**Vier Tests** in `TestIsoTranslate.cpp`, jeder über **alle** Stückgrößen von 1
bis über die Textlänge hinaus. Einer davon hat einen Fehler in meinem eigenen
Entwurf gefunden: ein Zeichen, dessen Übersetzung **länger** ist als die
verbrauchten Bytes, wurde verworfen. Das trifft Zeichen außerhalb der BMP —
U+1F600 ist in UTF-16 ein Surrogatpaar und wird zu **zwei** Fragezeichen. Jetzt
wird gekürzt statt verworfen.

**Nebenbefund: die Testsuite ließ sich seit dem 10.09.2026 nicht mehr bauen.**
`OTShim.cpp` ruft seit der Spurmarke zu [E-76](Intern/BEFUNDE.md#e-76) `PutDebugLog`, das in QCUtils
liegt und nicht zum Testprojekt gehört — Linkerfehler, zwei Tage lang
unbemerkt. Damit sind auch **PRÜFERs Schranken vom 13.09.2026 nie gelaufen**.
Eine Attrappe in `OTShimProbe.cpp` schließt das.

**Testlauf: 120 Tests, 118 bestanden, 2 fehlgeschlagen.** Beide roten sind
**vorbestehend** und nicht von dieser Änderung: `SECImage: FlipHorz meldet
sich` zählt `DoMessageBox`, während `OTShimNichtUmgesetzt` seit [**E-33**](Intern/BEFUNDE.md#e-33) nur
noch `OutputDebugString` benutzt — ein veralteter Test; und
`SECControlBar::CalcDynamicLayout`, PRÜFERs E-76-Schranke, die nie laufen
konnte. Beide sind offen.

## 7.2.0.50 — losgerissene Fenster behalten ihre Größe (E-84)

**Was Gregor damit tun kann:** ein losgerissenes Fenster einmal auf die
gewünschte Größe ziehen und es beim nächsten Start so wiederfinden. **Von ihm
am 11.09.2026 bestätigt** — belegt an beiden Enden: in seiner `Eudora.ini`
stehen `FloatCx319=751` und `FloatCy319=403`, und der erste Aufruf nach dem
Neustart meldet `E-76 fest: vorher=751x403` statt der Anfangsgröße `200x100`.

Gemeldet am 11.09.2026, unmittelbar nach der Bestätigung von [E-76](Intern/BEFUNDE.md#e-76): *„das
undocked initiale fenster ist recht klein, die größe (nach der änderung) wird
nach dem schließen vom filter und eudora nicht gespeichert. beim nächsten mal
wieder klein."*

### Die Größe kam nie in die INI

`SECControlBar::GetBarInfo` überträgt `m_szFloat` brav in die Info
(`OTShim.cpp:2304`), `SetBarInfo` holt es zurück (`:2362`). Dazwischen liegt
das Speichern — und dort ging es verloren:

```c
BOOL SECControlBarInfo::SaveState(LPCTSTR lpszProfileName, int nIndex)
{
    return CControlBarInfo::SaveState(lpszProfileName, nIndex);
}
```

Eine reine Weiterleitung an MFC, und **MFC kennt `m_szFloat` nicht**. Die
Stingray-Felder wurden in die Info geschrieben und beim nächsten Start nie
gelesen.

### Warum das so gebaut war — und warum es hier trotzdem geändert wird

Der Kommentar in `SECControlBarInfo::Serialize` begründet, den SEC-Anteil
wegzulassen: *„das Format müsste dann zum Original passen … eine eigene
Erweiterung würde eine Datei erzeugen, die ein späterer echter Nachbau nicht
mehr lesen kann."*

**Das Argument gilt — für `Serialize`.** Die Funktion schreibt ein
**Binärformat**, in dem ein zusätzliches Feld alles Nachfolgende verschiebt.
`SaveState` und `LoadState` schreiben dagegen in die **INI**: ein zusätzlicher
Schlüssel stört niemanden, der ihn nicht kennt, und fehlt er, gilt der
bisherige Wert. `Serialize` bleibt deshalb unberührt.

**Der erste Anlauf saß an der falschen Stelle.** Er stand in
`SECControlBarInfo::SaveState` — und in der `Eudora.ini` kam kein einziger
Eintrag an. Die Funktion wird beim Speichern gar nicht durchlaufen. Der
tatsächliche Weg steht seit [**E-70**](Intern/BEFUNDE.md#e-70) im Baum: `QCToolBarManager::SaveState` →
`SECToolBarManager::SaveState` → `GroessenSichern`, und dort wurden bis jetzt
nur `DockVertCx` und `DockHorzCy` geschrieben — die **Andock**größen. Die
schwebende Größe kam nirgends vor.

Die Behebung hängt sich an denselben Mechanismus: zwei weitere Schlüssel,
`FloatCx<id>` und `FloatCy<id>`, geschrieben und gelesen wie die beiden
vorhandenen. Kein neuer Weg, keine zweite Stelle, die jemand übersehen kann.
Eine Größe von `0` wird gar nicht erst geschrieben — sie wäre schlimmer als
kein Eintrag, weil `GroessenLaden` sie übernehmen müsste.

Die beiden Schlüssel stehen im Abschnitt `[ToolBar-ToolBarManager]`; Vorgabe,
Fundstelle und die Regel dazu in [EINSTELLUNGEN.md](Intern/EINSTELLUNGEN.md).

## 7.2.0.49 — das schwebende Filterfenster lässt sich nach unten ziehen (E-76)

**Was Gregor damit tun kann:** ein freischwebendes Filterfenster nicht nur
seitlich, sondern auch nach unten größer ziehen. **Von ihm am 11.09.2026
bestätigt:** *„e-76: paßt: läßt sich jetzt vergrößern."*

Gemeldet am 10.09.2026 an 1.0.40 und am 11.09.2026 als **noch vorhanden**
wiederholt: *„e-76: nein, immer noch bug."* Dazu der Satz, der die Sache
gelöst hat: *„könnte gerade
was im log stehen, falls trace eingeschaltet."*

### Die Spurmarke hat nach sieben Fassungen geliefert

Sie lag seit 7.2.0.41 im Bau und schrieb nur, solange die Leiste schwebt —
auslösen ließ sie sich nicht, weil dafür eine **physisch gedrückte Maustaste**
nötig ist. Gregor hat gezogen, und damit stand alles im Protokoll:

```
dynamisch: nLength=105 dwMode=0x0022 LENGTHY HORZ -> ergebnis=780x105
dynamisch: nLength=172 dwMode=0x0022 LENGTHY HORZ -> ergebnis=780x172
dynamisch: nLength=234 dwMode=0x0022 LENGTHY HORZ -> ergebnis=780x234
dynamisch: nLength=299 dwMode=0x0022 LENGTHY HORZ -> ergebnis=780x299
dynamisch: nLength=780 dwMode=0x0042 COMMIT  HORZ -> ergebnis=780x100
```

Das Ziehen rechnet richtig: 105, 172, 234, 299. Der **letzte** Aufruf, der das
Ergebnis übernehmen soll, trägt `dwMode=0x0042` — `LM_COMMIT | LM_HORZ`, aber
**kein `LM_LENGTHY`**. Damit läuft er in den `else`-Zweig:

```c
if (dwMode & LM_LENGTHY) size.cy = max(nLength, 20);
else                     size.cx = max(nLength, 20);
```

und setzt die **Breite** auf 780 — denn das ist, was `nLength` beim COMMIT
trägt. Die Höhe bleibt der alte Wert. Danach speichert
`if (dwMode & LM_COMMIT) m_szFloat = size;` genau diese Rückfall-Größe. Die
gezogenen 299 sind weg. Beim Verkleinern spiegelbildlich dasselbe: 99, 94,
70, 47 werden korrekt gerechnet, der COMMIT macht daraus wieder 100.

### Die Behebung

Ein Merker hält die zuletzt in Ziehrichtung gerechnete Größe fest; beim
COMMIT wird er genommen, statt aus einem `nLength` zu rechnen, das dort etwas
anderes bedeutet. Wurde nie gezogen, steht der Merker auf `(0,0)` und es
bleibt beim Bisherigen.

**Nicht gemacht:** beim COMMIT die Höhe aus `nLength` lesen und `LM_HORZ` als
Richtungsangabe deuten — das baut denselben Fehler nur anders herum ein.

**Beim Bauen gefangen:** mein erstes Skript hat den Merker auch in
`SECControlBarInfo` initialisiert, einer Klasse, die ihn gar nicht hat. Zwei
`C2065`, sofort gemeldet. Genau dafür baut man, bevor man ausliefert.

### Außerdem: 16 fehlende Behebungsfassungen nachgetragen

Gregor: *„die tabelle sollte auch enthalten, in welchem build welcher befund
behoben wurde."* Gemessen: 38 der behobenen Befunde nannten ihre Fassung, 16
nicht. Nachgetragen aus der Git-Geschichte — und dort, wo der gefundene
Commit den Befund möglicherweise nur **anlegte** statt ihn zu beheben, steht
das ausdrücklich dabei. Eine geratene Zahl, die sicher aussieht, ist
schlimmer als eine, die ihre Herkunft nennt.

## 7.2.0.48 — die Zertifikatsprüfung nimmt nicht mehr alles an (E-82)

**Was Gregor damit tun kann:** darauf vertrauen, dass eine TLS-Verbindung
abgelehnt wird, deren Zertifikatskette Eudora nicht verifizieren konnte.
**Von ihm am 11.09.2026 bestätigt** — IMAP läuft damit unverändert weiter.

Bisher behandelte der Verifikations-Callback zwei OpenSSL-Prüffehler als
Erfolg:

```c
case X509_V_ERR_CERT_UNTRUSTED:                  /* 27 */
case X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE: /* 21 */
    iOK = 1;
    break;
```

`iOK` ist der Rückgabewert des Callbacks. `iOK = 1` sagt OpenSSL ausdrücklich
**„Zertifikat in Ordnung"** — der Fehler wurde also nicht übergangen, sondern
ins Gegenteil verkehrt. Anders als in allen benachbarten Zweigen wurde weder
ein Fehlercode gesetzt noch eine Warnung angehängt; der Anwender bekam nichts
zu sehen. Fehler 27 stammt aus `check_trust()` und tritt im gewöhnlichen
Kettenaufbau auf, nicht nur in Randfällen.

Jetzt hängen beide Codes am bereits vorhandenen, korrekt ausgeführten Zweig
für `X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY`. `iOK` bleibt 0, die
Verbindung wird abgelehnt, und der Anwender sieht
`IDS_CERTERR_CHAINNOTTRUSTED`.

**Der Ausweg bleibt:** der `switch` wird nur erreicht, wenn das Zertifikat
nicht schon im vom Anwender bestätigten Speicher liegt. Die Einzelfreigabe
geht weiter, weg fällt die pauschale Annahme.

**Gemessen an Gregors Konten:** `Open 212.227.17.186:993` und
`Successfully retrieved konto-gmx@gregor.invalid` — GMX' Kette hält der echten
Prüfung stand. Die pauschale Annahme war also nicht nötig, um seine Konten zu
erreichen. Der Verdacht, Eudoras `rootcerts.p7b` von 2006 könnte zu alt sein,
ist damit für diese beiden Konten widerlegt.

### Eine DLL, die im Paket fehlte

Beim Bereitstellen fiel auf: der Bau erzeugte eine frische `QCSSL.dll`, im
fertigen Paket lag aber die alte aus der Grundlage. Der Patch ändert genau
diese eine DLL — Gregor hätte die unveränderte Prüfung getestet und nichts
bemerkt. Aufgefallen ist es nur am **Zeitstempel**; `paket-pruefen.ps1` kennt
die Datei nicht.

Die Begründung im Bauskript stimmte, aber nur für den **Debug**-Bau: dort ist
die DLL 4.645.376 B gegen 2.920.960 B in der Grundlage, also eine andere
Bauart. Im **Release**-Bau sind es 2.921.472 B — dieselbe Bauart. `QCSSL.dll`
kommt deshalb ab jetzt bei `-Bauart Release` mit.

## 7.2.0.47 — Kopfzeilen bleiben lesbar, auch auf schwarzem Grund (E-81)

**Was Gregor damit tun kann:** die Kopfzeilen auch bei Werbemails lesen, die
sich einen dunklen Hintergrund setzen.

Gemeldet am 11.09.2026 an 1.0.46: *„schönheitsfehler: schwarzer text auf dem
schwarzen hintergrund ist nicht sichtbar. nur beim markieren erscheint er."*

Eudora schreibt die Kopfzeilen als `<SPAN CLASS=EUDORAHEADER>` in **dasselbe**
HTML-Dokument, in dem danach die Mail steht. Das Stylesheet dieses Dokuments
kennt `BODY`, `TT` und `BLOCKQUOTE.CITE` — für `EUDORAHEADER` gibt es **keine
einzige Regel**. Die Kopfzeilen erben deshalb, was die Mail für ihren `<BODY>`
vorgibt.

Jetzt gibt es eine Regel, die Vordergrund **und** Hintergrund festlegt. Beides
muss sein: nur die Schriftfarbe zu setzen würde bei einer Mail mit hellem Text
auf dunklem Grund denselben Fehler spiegelverkehrt erzeugen.

Wer eine eigene `read.css` im Eudora-Verzeichnis hat, ersetzt das Stylesheet
vollständig — für den ändert sich nichts.

## 7.2.0.46 — der „Blah Blah Blah"-Knopf schaltet wieder (E-80, Teil 2)

**Was Gregor damit tun kann:** die technischen Kopfzeilen ein- und ausblenden,
statt sie nur dauerhaft gekürzt zu sehen. **Von ihm bestätigt:** *„ja, jetzt
geht es"*.

Gemeldet am 11.09.2026 an 1.0.45: *„header schaut jetzt kürzer aus. aber: der
bla bla button ändert nichts."* Teil 1 stimmte also — nur umschalten ließ sich
nichts.

**Der Knopf schaltete seinen eigenen Zustand nie um.** Die Kette:

| Schritt | Stelle | was dort passiert |
|---|---|---|
| 1 | `ReadMessageFrame.cpp:179` | der Knopf steht als `TBBS_CHECKBOX` in der Leiste |
| 2 | `:981-998` | `GetCheck` liest das Bit `TBBS_CHECKED` |
| 3 | `:949-977` | `OnButtonSetCheck` setzt es — läuft **genau einmal**, beim Anlegen des Fensters |
| 4 | `TridentReadMessageView.cpp:161` | der Klick geht an die **Ansicht**, nicht an den Rahmen |
| 5 | `ReadMessageFrame.cpp:688` | `CReadMessageFrame::OnBlahBlahBlah` steht in keiner Botschaftstabelle — **tote Funktion** |

Beide Ansichten **lesen** den Zustand, keine setzt ihn. Deshalb meldete die
Spurmarke in jedem einzelnen Lauf `Knopf=0` — die Zahl stand da, und ich habe
sie nicht zu Ende gedacht.

**Woher die Lücke kommt:** im Original schaltete die Stingray-Leiste einen
Checkbox-Knopf beim Klick selbst um. Der OTShim-Ersatz setzt `TBBS_CHECKED` nur
über `ON_UPDATE_COMMAND_UI`, und so einen Eintrag gibt es für diesen Knopf
nirgends. Dieselbe Klasse wie [**E-43**](Intern/BEFUNDE.md#e-43) und [**E-70**](Intern/BEFUNDE.md#e-70): Verhalten, das beim Ersatz
des Toolkits weggefallen ist und erst auffällt, wenn jemand den Knopf drückt.

Behoben in **beiden** Ansichten über die registrierte Botschaft
`umsgButtonSetCheck` — der Weg, den `summary.cpp:2518-2520` für zwei andere
Knöpfe schon benutzt.

## 7.2.0.45 — der Knopf „Blah Blah Blah" versteckt wieder etwas (E-80, Teil 1)

Gemeldet am 11.09.2026: *„der bla bla button scheint nicht zu funktionieren.
erwartung: doppelklick auf mail: je nach button wird der header angezeigt
oder ausgeblendet. aktuell: er wird immer angezeigt."*

**Der Knopf war nie kaputt — die Liste war es.** Was er versteckt, sagt seine
eigene Statuszeile: *„Shows/hides non-important headers"*. Welche Kopfzeilen
als unwichtig gelten, steht in `TabooHeaders` — und diese Liste stammt aus
2006. Sie kennt `X-UID` und `X-UIDL`, aber nicht `X-`; sie kennt `Received`,
aber nicht `DKIM-`.

Nachgerechnet an **134 echten Nachrichten aus sechs Postfächern**
(`tools/taboo-rechnen.pl`; der Vergleich ist ein reiner Präfixvergleich und
lässt sich deshalb ohne Programm ausrechnen). Mit der alten Liste blieben
**über 60 Kopfzeilenarten** stehen:

| Kopfzeile | kam vor | Kopfzeile | kam vor |
|---|---|---|---|
| `DKIM-Signature` | 76× | `Delivered-To` | 56× |
| `Authentication-Results` | 70× | `X-Mailer` | 55× |
| `X-FN-MUUID` | 62× | `UI-OutboundReport` | 54× |
| `X-Scan-TS` | 60× | `X-Provags-ID` | 54× |
| `X-Spam-Flag` | 58× | `X-UI-Sender-Class` | 54× |

Die beiden obersten sind genau die aus Gregors Bildschirmfoto.

**16 Einträge ergänzt**, die Originalliste bleibt unverändert davor stehen —
damit kann kein bisheriges Verhalten wegfallen. Dieselbe Rechnung mit der
neuen Liste lässt **zehn** Namen übrig: `From`, `To`, `Cc`, `CC`, `Bcc`,
`Subject`, `Date`, `Reply-To`, `Sender` — und `Referer`. Das letzte ist ein
Restbefund: der Listeneintrag `References` ist zehn Zeichen lang und trifft
`Referer: ` deshalb nicht. Ein Einzeiler in der `.rc` würde ihn schließen.

**Am laufenden Programm belegt**, nicht nur gerechnet: Trident baut die
Anzeige als temporäre `eud*.htm` auf. Aus einem Messlauf am 11.09.2026
abgegriffen, stehen darin noch vier Kopfzeilen — `Date`, `To`, `From`,
`Subject` — und keine einzige technische.

**Kein Datenverlust:** die Kürzung arbeitet auf dem Puffer, den
`GetFullMessage` frisch anlegt (`msgdoc.cpp:374-389`). Die `.mbx` wird nicht
angefasst. Wer alles sehen will, drückt den Knopf oder setzt
`ShowAllHeaders=1`.

**Zwei Umwege dahin, beide meine.** Die erste Spurmarke lag in
`PgReadMsgView` — der Paige-Textansicht — und schwieg, obwohl `LogLevel`
nachweislich wirkte. Eudora hat **zwei** Nachrichtenansichten
(`ReadMessageFrame.cpp:277-281`), und beide haben eigene Taboo-Logik. Danach
sah es so aus, als steche der Content Concentrator den Knopf aus
(`konzentriert=1 -> Kopfzeilen ALLE`); das gilt aber nur für den ersten
Aufbau. Im laufenden Betrieb meldet die Marke `konzentriert=0 -> gekuerzt`.
Die Kürzung griff die ganze Zeit — sie kürzte nur fast nichts weg.

## 7.2.0.44 — Messfassung für die Spaltenbreite im Filterfenster

**Was Gregor damit tun kann:** die Ursache dafür messen, dass die linke
Spalte im Filterfenster nach einem Neustart anders breit ist — ohne dass
etwas geraten wird.

Gemeldet am 11.09.2026 an 1.0.43: *„die breite der linken spalte beim filter
wird nicht über den neustart gespeichert. auch wenn ich sie breiter gezogen
habe."*

### Zwei Ursachen, die erste davon meine

**Der Schalter stand im falschen Abschnitt.** Eudora ordnet jeden INI-Schlüssel
**automatisch** einem Abschnitt zu, allein nach seiner internen Nummer
(`rs.cpp:88`):

| Nummernbereich | Abschnitt |
|---|---|
| 10900 … 11100 | `[Window Position]` |
| alles andere | `[Settings]` |

`UseMyFilterWindowPosition` hat die Nummer **10922**. Gregor hatte ihn nach
`[Settings]` geschrieben — weil `FILTER.md` behauptete, dort gehörten *alle*
Schlüssel hin. Nachgemessen mit derselben Windows-Funktion, die Eudora
benutzt:

```
[Window Position]  UseMyFilterWindowPosition = 0    ← das liest Eudora
[Settings]         UseMyFilterWindowPosition = 1    ← das steht da
```

Ein Eintrag im falschen Abschnitt wird **stillschweigend ignoriert**. Für
**23 der 38** dokumentierten Schlüssel war die Angabe falsch;
[FILTER.md](Intern/FILTER.md) nennt den Abschnitt jetzt in jeder Tabellenzeile, und
die Zuordnung wird aus `resource.h` und `EudoraRes.rc` gelesen statt von Hand
gepflegt.

**Und auch im richtigen Abschnitt bleibt der Wert nicht.** Gregors Messung:

| | 08:08 | 08:18 |
|---|---|---|
| eingetragen | — | **312** |
| danach in der Datei | 237 | **368** |
| Breite der Filterleiste | 527 | 668 |

`SetColumnInfo` setzt nur eine **Wunschbreite** (`FiltersWazooWnd.cpp:185`);
wirksam wird sie erst durch die Neuberechnung, die das nachfolgende
`PostMessage(WM_SIZE, …)` auslöst. Beim Schließen schreibt Eudora die
**tatsächliche** Breite zurück (`:70`), nicht die gewünschte — weicht sie ab,
schaukelt sich der Wert von Lauf zu Lauf auf.

**In der VM tritt es nicht auf**, weil die Leiste dort schmaler ist. Es ist
dieselbe Fassung: in beiden Protokollen steht `Version 7.2.0.43`.

### Was diese Fassung dazu beiträgt

Zwei Spurmarken, die die ganze Kette in je einer Zeile nennen:

```
E-79 geladen:   INI=312 Schalter=1 Elternbreite=668 Viertel=167
                -> gesetzt=312, danach ist=368 min=0
E-79 gesichert: ist=368 min=0 -> INI=368
```

Damit ist in einem einzigen Start-und-Beenden zu sehen, an welcher Stelle der
Wert sich ändert. Sie hängen wie alle anderen an `DEBUG_MASK_MISC` und
schweigen in der Vorgabe — einschalten mit `LogLevel=58527`, siehe
[README.md](README.md), Abschnitt *Mehr ins Protokoll schreiben lassen*.

**Behoben ist damit noch nichts.** Erst die Messung, dann der Eingriff — an
dieser Stelle sind in den vergangenen Tagen schon mehrere Vermutungen
gescheitert.

## 7.2.0.43 — Filter löschen auch über IMAP nichts mehr auf dem Server

**Was Gregor damit tun kann, was vorher gefährlich war:** über IMAP abrufen
und filtern, ohne dass Post auf dem Server verschwindet. Dazu: das Protokoll
gezielt aufdrehen, ohne dass jemand den Code ändert.

### Zwei Löschwege, die E-73 offengelassen hatte

[E-73](Intern/BEFUNDE.md#e-73) galt seit 7.2.0.38 als behoben — eine Filteraktion sollte nichts mehr
auf dem Server löschen. PRÜFER hat die Behebung gegen den Quelltext
nachgerechnet und **zwei Wege gefunden, die daran vorbeiliefen**:

| Weg | warum er vorbeilief |
|---|---|
| **IMAP** | Bei einem IMAP-Postfach verzweigt `CFilter::Action` nach `ImapAction` (`filtersd.cpp:1213-1216`) und erreicht den geprüften POP-Zweig nie. Von dort geht es über `ImapSetServerOpt` (`EuImap/src/ImapFiltersd.cpp:791-794`) in ein `STORE \Deleted`. `IMAP4` ist in **beiden** Konfigurationen gebaut |
| **Junk-Filteraktion** | `ID_FLT_JUNK` (`filtersd.cpp:1581-1600`) → `CJunkMail::DeclareJunk` → bei `DeleteFetchedJunk=1` ein `SetServerStatus(…SERVER_DELETE)` (`JunkMail.cpp:707-711`) |

**Der zweite ist besonders heikel**, weil [**E-74**](Intern/BEFUNDE.md#e-74) ihn nicht abdeckte: dort
war `DeleteFetchedJunk=0` nur in `tools/DEudora.ini` gesetzt worden, und das
gilt ausschließlich für **neu angelegte** Konten. Wer die `1` schon in seiner
`Eudora.ini` stehen hatte, löschte weiter — ausgelöst durch eine
Filteraktion.

Beide fragen jetzt dieselbe Funktion `FilterDarfVomServerLoeschen`. Manuelles
Junken bleibt unverändert. Die Schranke
`tools/pruefe-filter-serverloeschung.pl` hält das fest und hat beim ersten
Lauf genau diese zwei Lücken gefunden — in einer Behebung, die als fertig
galt.

### E-68: der Überlauf beim Lesen von `Filters.pce`, halb behoben

`NUM_FILT_ACTS` ist 5, `CFiltersDoc::Read` zählte den Aktionszähler aber in
**21 Zweigen** hoch, ohne je gegen diese Grenze zu prüfen. Nachgerechnet ist
der Schaden größer als beschrieben: derselbe Zähler indiziert **elf weitere
Felder**, darunter `CString`-Felder. `m_Desc[5]` trifft `m_DoPersonality`,
und `CString::operator=` fasst das als Zeichenkettenzeiger auf — kein
Zahlenschaden, sondern Speicherzerstörung.

Auslösen lässt sich das **nicht durch Bedienung**: `CFiltersDoc::Write` ist
gebunden und schreibt nie mehr als fünf. Es braucht eine fremde
`Filters.pce` — von Hand bearbeitet, aus einem anderen Programm übernommen,
oder eine `.pre`/`.pst`-Datei, die Eudora liest und nie schreibt.

Die Grenze ist eingebaut; überzählige Zeilen werden verworfen und
protokolliert. Die zweite Hälfte von [E-68](Intern/BEFUNDE.md#e-68) — `copyInstead` wird anders
geschrieben als gelesen — bleibt **offen**.

### Das Protokoll lässt sich jetzt aufdrehen, ohne den Code anzufassen

Gregors Hinweis: *„in der ini ein debuglevel setzen, dann kommt mehr oder
weniger ins log raus. damit kann man im bedarfsfall mehr logs zu debug
zwecken rausschreiben, ohne den code zu ändern."*

Das gibt es in Eudora seit jeher — `LogLevel` in der `Eudora.ini` — und diese
Portierung hat es bis heute umgangen. Die Spurmarken riefen `PutDebugLog` mit
`DEBUG_MASK_MISC | DEBUG_MASK_TOC_CORRUPT`. Das **ODER** machte die
Abschaltbarkeit zunichte: `MISC` ist in der Vorgabe aus, `TOC_CORRUPT` an,
also schrieb jede Marke immer.

**146 Stellen in 16 Dateien** hängen jetzt an `MISC` allein:

```ini
LogLevel=25759   ; Vorgabe — die Spurmarken schweigen
LogLevel=58527   ; 25759 + 32768 — sie schreiben
```

Damit dürfen die Marken im Code bleiben. Die vollständige Tabelle aller
sechzehn Schalter steht in [README.md](README.md), Abschnitt *Mehr ins
Protokoll schreiben lassen*.

### Neu: E-77, und was die Filterdoku jetzt sagt

[**E-77**](Intern/BEFUNDE.md#e-77) — IMAP-Postfachnamen mit Umlauten werden roh angezeigt:
`Entw&APw-rfe` statt *Entwürfe*. Das ist modifiziertes UTF-7 (RFC 3501,
5.1.3), und Eudora dekodiert es nicht; in `Eudora71/` kommt keine
UTF-7-Behandlung vor. Offen.

**[FILTER.md](Intern/FILTER.md)** ist neu — 666 Zeilen zu Filtern und Junk, mit
allen 38 INI-Schlüsseln samt eingebauter Vorgabe und Fundstelle. Gregors
Frage nach den Junk-Werten ist dort beantwortet: die **100** ist
`ManualJunkScore`, die Punktzahl beim Junken von Hand; die automatische
Schwelle ist `MinScoreToJunk` mit Vorgabe **50**. Praktisch bleibt jede
Nachricht bei 0, weil die Bewertung von `SpamWatch` und `SpamHeaders` kommt
und beide wegen [**E-47**](Intern/BEFUNDE.md#e-47) nicht laden.

### Was aus dem Protokoll bestätigt wurde

Von Gregor an 1.0.42 gemessen: *„filter fenstergröße nach neustart
gespeichert: PASS"* ([**E-70**](Intern/BEFUNDE.md#e-70)), *„filter funktionieren"* ([**E-64**](Intern/BEFUNDE.md#e-64), [**E-72**](Intern/BEFUNDE.md#e-72),
[**E-75**](Intern/BEFUNDE.md#e-75)), *„imap: funktioniert"* — `imap.gmx.net:993`, TLSv1.3,
`TLS_AES_256_GCM_SHA384`. **Kriterium 3** in [ZIEL.md](ZIEL.md) nennt jetzt
beides, POP3 und IMAP.

[**E-71**](Intern/BEFUNDE.md#e-71) ist dagegen **neu eingestuft**: der Filterbericht bleibt leer, auch
nachdem die Filter greifen. Die frühere Einordnung *„kein eigener Fehler,
Folge von [E-72](Intern/BEFUNDE.md#e-72)"* ist damit widerlegt. Auf Gregors Wunsch zurückgestellt.

## 7.2.0.42 — Die Breite der Seitenleisten überlebt einen Neustart wirklich

**Was Gregor damit tun kann, was in 1.0.41 noch nicht ging:** eine Leiste
breiter ziehen und sie beim nächsten Start genauso breit wiederfinden.

1.0.41 hatte den halben Weg gebracht: das Laden lief, aber die Breite kam
beim Anwender nicht an. Gregors Urteil dazu: *„0.41 speichert nicht die
fenstergröße korrekt, nach dem neustart immer noch falsch!"*

### Was die Messung am laufenden Programm zeigte

Mit Gregors Freigabe (*„du kannst ja jetzt lokal ausführen, ich greife nicht
rein"*) ließ sich das zum ersten Mal selbst durchspielen: `DockVertCx319=437`
in die `Eudora.ini` geschrieben, gestartet, die Leiste am Fenster
ausgemessen.

| | |
|---|---|
| `Eudora.ini` vorher | `DockVertCx319=437` |
| Protokoll beim Start | `E-70 geladen: Leiste=319 cx=437 -> jetzt cx=437` |
| unmittelbar danach | `E-44 WazooBars: für 3 Leiste(n) war keine Lage gespeichert — die Standardanordnung wurde nachgezogen` |
| **Fenster gemessen** | **Leiste 319: 180 Pixel breit** |
| Protokoll beim Beenden | `E-70 gesichert: Leiste=319 cx=180` |
| `Eudora.ini` danach | `DockVertCx319=180` |

Der geladene Wert kommt an und wird eine Zeile später überschrieben.
`CWazooBarMgr::LoadWazooBarConfigFromIni` läuft **nach** dem Laden und dockt
jede Leiste, für die keine Lage wiederhergestellt werden konnte, mit einer
**fest verdrahteten Breite von 180** an (`WazooBarMgr.cpp:409`, `:418`,
`:493`).

**Das war ohne die Freigabe nicht zu finden.** Die Spurmarke allein sagte
*„geladen: cx=437"* und hätte wie ein Erfolg ausgesehen. Erst die Messung am
Fenster daneben zeigte die 180.

### Behoben

Die Größen werden nach dem Anordnen **noch einmal** geladen — an der Stelle,
an der die Anordnung nachweislich fertig ist. Das wirkt unabhängig davon, ob
der Nachziehweg lief.

**Nachgemessen, an einer sichtbaren Leiste:** mit `DockVertCx318=512` in der
`Eudora.ini` startet die linke Leiste jetzt **512 Pixel breit** statt 180.

### Was dabei offen bleibt

Dass der Nachziehweg überhaupt läuft, gehört zu [**E-44**](Intern/BEFUNDE.md#e-44):
`SetDockState` stellt die Andockung nicht wieder her — `m_pDockBar` bleibt
`NULL` —, obwohl dreizehn `[ToolBar-*]`-Abschnitte in der `Eudora.ini`
stehen. Das ist hier **nicht** angetastet: es wäre ein zweiter Eingriff in
einen Bereich, der gerade funktioniert, und der Zusammenhang gehört erst
gemessen.

Eine **versteckte** Leiste behält im Fenster ihre Erzeugungsgröße, weil sie
gar nicht angeordnet wird. Ihr gespeicherter Wert bleibt trotzdem erhalten —
im Protokoll steht `gesichert: Leiste=319 cx=512`. Sobald sie sichtbar wird,
gilt die gespeicherte Breite.

## 7.2.0.41 — Die Breite des Filterfensters überlebt einen Neustart

**Was Gregor damit tun kann, was vorher nicht ging:** das Filterfenster
breiter ziehen und es beim nächsten Start genauso wiederfinden.

Gemeldet am 10.09.2026 an 1.0.40: *„speichert aber nicht die fenster größe
von filters nach dem neustart"* — dieselbe Sache, die er schon an 1.0.34
angesprochen hatte.

### Die Spurmarke aus 1.0.37 hat es entschieden

Seit 7.2.0.37 schrieben `E-70 gesichert:` und `E-70 geladen:` bei jedem
Sichern und Laden eine Zeile ins Protokoll. Ausgewertet worden waren sie nie.
Gregors Protokoll von 1.0.40 sagt:

```
E-70 gesichert:  40 Zeilen
E-70 geladen:     0 Zeilen
```

Und in seiner `Eudora.ini` steht `DockVertCx319=586` — genau die Breite, die
er eingestellt hatte. **Der Wert wird richtig geschrieben und nie gelesen.**

Zwei Zahlen in einer Ausgabe, und die Frage war beantwortet. Ohne die zweite
hätte man weiter über das Schreiben nachgedacht.

### Der Grund stand im eigenen Kommentar

```cpp
// KATEGORIE C laut PLAN.md: Eudora ruft diese Fassung nie auf.
void SECToolBarManager::LoadState(LPCTSTR lpszProfileName)
```

Genau dort war der Aufruf von `GroessenLaden` eingebaut. Gerufen wird
stattdessen `QCToolBarManager::LoadState`.

Dass das **Sichern** funktionierte, hat die Lücke verdeckt:
`QCToolBarManager::SaveState` ruft `SECToolBarManager::SaveState`
ausdrücklich auf — das Gegenstück `LoadState` tut das nicht. Eine Asymmetrie,
die man nur sieht, wenn man beide Seiten nebeneinanderlegt.

**Behoben** an der symmetrischen Stelle: `QCToolBarManager::LoadState` ruft
jetzt `GroessenLaden`. Der Zeitpunkt stimmt — `mainfrm.cpp` ruft erst
`SetDockState` (Zeile 951), dann `LoadState` (952); die Größen werden also
nach dem MFC-Zustand gesetzt und nicht wieder überschrieben.

Dazu ein `RecalcLayout` am Ende von `GroessenLaden`: `AndockgroesseSetzen`
schreibt nur Felder. Ohne Neuberechnung wirkt der geladene Wert erst beim
nächsten Umbau des Rahmens — beim Anwender also gar nicht, weil er dann
schon die Vorgabe gesehen hat.

### Nebenbei bestätigt: der Filterlauf arbeitet richtig

Gregor hatte drei Nachrichten markiert und gefiltert, ohne dass sich etwas
bewegte. Das Protokoll zeigt, dass jede Nachricht gegen **alle drei** Filter
geprüft wurde:

```
E-64 FilterMsg: Liste=1 Filter=3 verlangt WhenToApply=4 vorhandene Masken=[5,5,5]
E-64 Match=0 Filter="From:angebot@waipu.invalid" … Betreff="Hans, unsere TV-Empfehlungen der Woche"
```

`Match=0` war korrekt: die Nachricht kommt von `neues@waipu.invalid`, der
Filter sucht `angebot@waipu.invalid`. Gregors eigenes Urteil dazu:
*„fehlalarm: die mail adresse war im filter eine andere"*. Damit ist [**E-64**](Intern/BEFUNDE.md#e-64)
an einem Fall mit drei Filtern und mehreren Nachrichten bestätigt.

### Und noch eines bestätigt: die Menübeschriftung stimmt

Nach dem Wechsel auf 1.0.40 stand unter *Special* „Filter Messages
Ctrl+Shift+L" statt „Ctrl+J". Das war **kein Fehler**, sondern die richtige
Auskunft über einen falschen Zustand: das mitgebrachte Mailverzeichnis trug
noch `CtrlJMapping=1`. Nach dem Umstellen auf `2` — *„ok, mit dem wert 2 ist
das menü jetzt korrekt. paßt"*. `CMainFrame::InitJunkMenus` beschriftet das
Menü also zuverlässig um.

## 7.2.0.40 — Strg+J filtert wieder, statt in den Junk-Ordner zu schieben

**Was Gregor damit tun kann, was vorher nicht ging:** mit Strg+J filtern, so
wie er es seit jeher tut, ohne dass die ausgewählten Nachrichten stattdessen
im Junk-Ordner landen.

Gemeldet am 10.09.2026 an 1.0.39: *„filter erwischt immer noch zu viele
mails"* — und der entscheidende Satz kam kurz darauf: *„ich drücke zum
filtern ja immer noch ctrl-J"*.

### Der Filter war nicht schuld

Das Protokoll von 1.0.39 zeigt zwei völlig verschiedene Läufe unter derselben
Fortschrittsanzeige:

```
6.26  E-64 FilterMsg: Liste=1 Filter=1 verlangt WhenToApply=4 … Masken=[5]
7.38  E-64 Match=1 Filter="From:newsletter@freenet.invalid" … "Coole Comics | …"
7.38  E-64 Match=0 Filter="From:newsletter@freenet.invalid" … "Fwd: Neue Anmeldung …"
```

Das ist der echte Filterlauf, und er arbeitet **richtig**: eine Nachricht
trifft, eine nicht, nur die treffende wird verschoben.

```
9.07  Messages left to filter: 9
9.07  … acht weitere Zeilen, keine einzige E-64-Marke …
9.08  Messages left to filter: 0
```

Hier wurde `CFiltersDoc::FilterMsg` **überhaupt nicht aufgerufen**. `Junk.mbx`
wuchs trotzdem von 174 196 auf 501 987 Bytes.

**Gegenprobe am Bestand:** von zwölf Nachrichten in `Junk.mbx` haben zehn
keinen Filtergrund. Sechs davon kommen von `konto-freenet@gregor.invalid`
— für die sieht Gregors zweiter Filter ausdrücklich `HW_Bxo.mbx` als Ziel
vor. Diese Datei ist 0 Bytes groß.

### E-75 — Strg+J war auf „Junk" umgelegt worden

Vor der Junk-Funktion war Strg+J in Eudora *Filter Messages*. Seit Eudora 6
möchte das Programm die Taste für *Junk* haben und fragt vorher — der Dialog
dafür steht bis heute in den Ressourcen (`IDD_CTRL_J_FOR_JUNK`):

> *The Ctrl-J key combination is currently associated with the „Filter
> Messages" menu item. Would you like to switch it to be associated with the
> „Junk" menu item?*

**Gefragt wird aber nur, wenn beim ersten Start schon manuelle Filter da
sind.** Andernfalls greift in `CMainFrame::InitJunkMenus`
(`mainfrm.cpp:7911-7934`) der `else`-Zweig und legt Strg+J **stillschweigend**
auf Junk — festgeschrieben als `CtrlJMapping=1` in der `Eudora.ini`. Der
Zweig läuft nur ein einziges Mal; später angelegte Filter ändern nichts mehr
daran.

Gregor hatte mit einem **leeren Mailverzeichnis** angefangen. Beim ersten
Start gab es keine Filter, also wurde umgelegt, ohne zu fragen. Die Filter
kamen danach.

**Behebung:** sind beim ersten Start keine manuellen Filter vorhanden, bleibt
Strg+J auf `CTRL_J_FILTER` — so, wie es vor der Junk-Funktion war und wie das
Menü `IDR_MAINFRAME` es unverändert beschriftet. Wer Junk auf Strg+J will,
stellt es in den Einstellungen um; `InitJunkMenus` beschriftet das Menü dann
entsprechend um.

### Warum es so lange wie ein Filterlauf aussah

Drei verschiedene Befehle zeigten dieselbe Zeile `Messages left to filter`:

| Befehl | Fundstelle | zeigt jetzt |
|---|---|---|
| *Filter Messages* | `TocFrame.cpp:2380` | `Messages left to filter` (unverändert) |
| *Junk* / *Not Junk* | `TocFrame.cpp:1156` | `Messages left to mark` |
| *Recheck Junk* | `TocFrame.cpp:996` | `Messages left to scan for junk` |

Die Zeichenkette `IDS_JUNK_MESSAGES_LEFT` gab es bereits, sie wurde nur beim
Abruf benutzt; für das Markieren ist `IDS_JUNK_MESSAGES_MARK` neu.

### Für ein bestehendes Mailverzeichnis

Diese Änderung wirkt nur dort, wo `CtrlJMapping` noch nicht festgeschrieben
ist. Steht die `1` schon in der `Eudora.ini`, hilft nur der Handgriff bei
geschlossenem Eudora:

```
CtrlJMapping=2
```

## 7.2.0.39 — Kein Filter und kein Junk-Fang löscht mehr auf dem Server

**Was Gregor damit tun kann, was vorher gefährlich war:** filtern und Mail
abrufen, ohne dass Post auf dem Server verschwindet.

Am 10.09.2026 war sein freenet-Postfach leer. Seine eigene Vermutung — *„evtl.
war leave on server nicht aktiviert"* — war naheliegend und **falsch**: in
seiner `Eudora.ini` steht für **beide** Konten `LeaveMailOnServer=1`.

### Eudora kennt drei Wege, Post auf dem Server zu löschen

Sie sind voneinander unabhängig, und zwei davon sind im Original **an**:

| Weg | eingebaute Vorgabe | wer ihn auslöst |
|---|---|---|
| kein `Leave mail on server` | **löschen** (`LeaveMailOnServer\n0`) | POP3 nach dem Abholen |
| `Delete fetched junk` | **an** (`DeleteFetchedJunk\n1`) | die Junk-Einstufung ab `MinScoreToJunk` (50) |
| Filteraktion **„Server Options"** mit *Delete* | — | eine Filterregel; sticht im Original sogar `Leave mail on server` |

### E-73 — die Filteraktion, die niemand eingestellt hatte

`CFilter::Action` (`filtersd.cpp:1156-1178`) merkt die Nachricht auf dem
Server zum Löschen vor, sobald die Aktion `ID_FLT_SERVER_OPT` mit `SO_DELETE`
im Filter steht. **PRÜFER hatte am 09.09.2026 gemessen, dass genau diese
Aktion lief, obwohl sie in Gregors `Filters.pce` gar nicht steht.** Damals
sah das nach einer Randnotiz aus; es war der Kern.

Sie kam aus [**E-72**](Intern/BEFUNDE.md#e-72): die unerreichbare rechte Hälfte des Filterfensters
schrieb beim Wegklicken ihren uninitialisierten Zustand in den ausgewählten
Filter — Häkchen, Werte **und die Aktionsliste**. Zusammen mit dem dabei
geleerten Suchwert (*„enthält nichts"* trifft jede Nachricht) wurde damit der
ganze Posteingang verschoben **und zum Löschen auf dem Server vorgemerkt**.

**Behebung, Gregors Entscheidung wörtlich:** *„ja, 1 auf jeden fall!
Filteraktion darf nicht mehr vom Server löschen"*. Eine Filteraktion löscht
jetzt nichts mehr auf dem Server. Der Versuch wird **protokolliert**, auch
wenn er abgelehnt wird:

```
E-73 Filter "…" wollte die Nachricht "…" auf dem Server loeschen - VERWEIGERT
```

Damit sieht man, ob eine Regel die Aktion noch trägt, ohne dass sie Schaden
anrichtet. Rückschalter: `FilterMayDeleteFromServer=1` in `[Settings]`,
Vorgabe **0**.

### E-74 — `Delete fetched junk` ist im Original an

Der zweite Weg, unabhängig von Filtern: `CJunkMail::ProcessOne`
(`JunkMail.cpp:453-457`) merkt jede als Junk eingestufte Nachricht zum
Löschen auf dem Server vor. Die eingebaute Vorgabe ist **1**.

Das ist hier besonders heikel, weil die Junk-Bewertung auf die Zusatzmodule
*SpamWatch* und *SpamHeaders* angewiesen ist — und die sind in dieser
Portierung **gar nicht ladbar**, weil ihnen `MFC71.DLL` und `MSVCP71.dll`
fehlen ([**E-47**](Intern/BEFUNDE.md#e-47)). Einer Einstufung, der man nicht trauen kann, darf man
keine Löschentscheidung überlassen.

`tools/DEudora.ini` setzt deshalb `DeleteFetchedJunk=0` für **neu angelegte**
Konten. Bestehende Konten ändert das nicht — dort steht der Wert in der
`Eudora.ini` des Mailverzeichnisses.

### Beide Abweichungen sind dokumentiert

Neu in der README: **Einstellungen, die es nur hier gibt** — eine Tabelle mit
Schlüssel, Wert hier, Wert im Original und Begründung, dazu die drei
Löschwege im Zusammenhang. Gregor: *„sowas gehört dann in die doku oder in
readme"*.

### Was an 1.0.39 zu prüfen ist

Gregor testet mit einem **leeren Mailverzeichnis** — damit greifen die
Vorgaben aus `DEudora.ini`.

1. Neue Persönlichkeit anlegen: steht **Leave mail on server** an?
2. *Tools → Options → Junk Mail*: steht **Delete fetched junk** aus?
3. Mail abrufen, filtern — bleibt auf dem Server alles liegen?
4. Steht eine [`E-73`](Intern/BEFUNDE.md#e-73)-Zeile im Protokoll? Dann trägt eine Regel die
   Serveroption noch; schaden kann sie nicht mehr.

## 7.2.0.35 — Die Breite wird gesetzt, nicht der ganze Zustand wiederhergestellt

Gregor an 1.0.34: *„der rechte balken läßt sich aber nicht beliebig weit nach
links schieben. er wird dann auf eine bestimmte breite vom linken fenster (wo
die filter namen stehen) zurückgesetzt."*

**Der Griff sitzt also richtig** — [E-66](Intern/BEFUNDE.md#e-66) ist an der Stelle erledigt, an der er
bis 1.0.33 gar nicht zu fassen war. Was bleibt, ist das **Anwenden**.

### Warum das Protokoll zu 1.0.34 nichts sagen konnte

Ein Fehler von mir, und er gehört benannt: **alle Spurmarken saßen im
stillgelegten Weg** über die Andockleiste. Der neue Weg über `ZiehenAmRand`
war unbeobachtet. Die Zeilen, die im Protokoll standen, stammten aus dem
**mitkopierten** `Mailverzeichnis` der Vorfassung — sie sahen aus wie eine
Messung und waren eine Erinnerung.

### Was geändert ist

Das Anwenden lief über `GetBarInfo` → Feld ändern → `SetBarInfo`. Und
`SECControlBar::SetBarInfo` ruft am Ende `CControlBar::SetBarInfo` — **MFCs
vollständige Zustandswiederherstellung**: Sichtbarkeit, Andockzustand und
Lage werden aus der Aufzeichnung neu gesetzt. Für das Laden einer
gespeicherten Anordnung ist das richtig. Für das Ändern **einer Zahl**
während des Betriebs ist es zu viel: alles andere in der Aufzeichnung ist der
Stand von **vor** dem Zug.

Jetzt wird nur noch die eine Zahl gesetzt, unmittelbar an der Leiste
(`AndockgroesseHolen` / `AndockgroesseSetzen`). Dass es dafür zwei eigene
Fassungen braucht, liegt daran, dass `m_szDockVert` und `m_szDockHorz` zu
`CControlBar` gehören und von außen nicht erreichbar sind.

**Das ist ein Verdacht, keine Gewissheit** — deshalb misst dieselbe Fassung
gleich mit.

### Die Marke am neuen Weg

`E-66 Anwenden:` schreibt bei jedem Zug eine Zeile: Andockleiste, Stelle der
Leiste, Delta, die Grenzen `Min`/`Max`, die Andockgröße **vorher → nachher**
und die Fensterbreite, die dabei herausgekommen ist.

Damit ist beim nächsten Mal unterscheidbar, ob

* die Grenzen den Zug abschneiden (`Delta` kleiner als gezogen),
* die Zahl gesetzt wird, aber nicht wirkt (`Andock 188 → 400`, Fenster
  trotzdem 188),
* oder etwas sie danach wieder zurücksetzt (Fenster erst breit, beim
  nächsten Anordnungsdurchlauf wieder 188).

### Was an 1.0.35 zu prüfen ist

Rechte Leiste weit nach links ziehen — so weit, dass sie zurückspringt. Dann
die `eudora.log`. **Wichtig:** wenn Du das `Mailverzeichnis` aus einer
Vorfassung mitkopierst, lösche vorher die `eudora.log` darin, sonst stehen
alte Zeilen darin, die wie eine frische Messung aussehen.

## 7.2.0.34 — Der Trennbalken sitzt jetzt in der Leiste, nicht in der Andockleiste

**Was Gregor damit tun kann, was seit A-4 nie ging:** die **rechte** Leiste
mit der Maus breiter ziehen — und damit das **Filterfenster** benutzen, dessen
rechte Hälfte bisher außerhalb der 188 Pixel lag. Die linke und die untere
Leiste gehen auf demselben Weg.

Das ist **keine Nachbesserung mehr, sondern ein anderer Ort** für denselben
Zweck. Der Grund steht in den Messungen.

### Was die drei Messfassungen ergeben haben

| Fassung | Marke | Ergebnis |
|---|---|---|
| 1.0.31 | `E-66 Zug:` | **0 Zeilen** — die Ziehschleife wird nie betreten, obwohl beide Balken entstehen |
| 1.0.32 | `E-66 Bewegung`, `E-66 Klick` | **je 0 Zeilen** — die Andockleiste bekommt weder Mausbewegung noch Klick |
| 1.0.33 | `E-66 Zeiger:` | Empfänger **`CWazooBar`**, **`CFiltersViewLeft`**, **`QC3DTabWnd`** — **nie** die Andockleiste |

Dazu die Lage, die alles erklärt:

```
E-66 Streifen: Leiste=59421 Client=0..188 Bar=-2..178 nFrei=8 nSchub=10 Balken=0..8
```

Die Leiste liegt bei **−2..178**, der freie Platz also bei **178..188** — der
Trennbalken lag bei **0..8**, mitten **unter** der Leiste. Der Doppelpfeil
erschien trotzdem, weil `WM_SETCURSOR` zum Elternfenster **aufsteigt**;
Maustasten tun das nicht.

### Warum der bisherige Ort grundsätzlich falsch war

`CDockBar::CalcFixedLayout` ordnet die Leisten **immer am Anfang** an:

```cpp
CPoint pt(-afxData.cxBorder2, -afxData.cyBorder2);   // bardock.cpp:387
```

Links landet der Zuschlag dadurch an der Innenkante — deshalb sah es dort
zeitweise nach Erfolg aus. Rechts landet er am **Fensterrand**, und dort
sucht ihn niemand. Mein Gegenmittel, die Leisten ans Ende zu rücken, hält
nicht: MFC ordnet bei jedem Durchlauf neu an, `nSchub` war in **jeder** Zeile
wieder 10.

### Der neue Ort

Der Greifstreifen liegt in **`SECControlBar::CalcInsideRect`**, also in der
Leiste selbst. Dort ist er von keinem Kindfenster verdeckt — `CWazooBar::OnSize`
legt sein Registerfenster nach `GetInsideRect` (`WazooBar.cpp:1244-1249`),
also genau nach dieser Fassung. Was dort abgezogen wird, gehört der Leiste,
und die Mausnachrichten kommen bei ihr an.

Er sitzt automatisch an der richtigen Kante: bei einer links angedockten
Leiste rechts, bei einer rechts angedockten links, bei einer unten
angedockten oben — jeweils zum Nachrichtenbereich hin, dort, wo ein Anwender
ihn sucht. Oben bleibt ausgenommen ([**E-55**](Intern/BEFUNDE.md#e-55)).

**Was bleibt, ist die Ziehschleife.** `SECDockBar::ZiehenAmRand` benutzt
weiterhin `Splitter::Track` und `OnSplitterMoved` — dort stecken die teuer
erkauften Sicherungen: höchstens 100 ms warten und die physische Maustaste
prüfen ([**E-51**](Intern/BEFUNDE.md#e-51)), auf den Bildschirm zeichnen ([**E-54**](Intern/BEFUNDE.md#e-54)), `WM_QUIT`
zurückstellen ([**E-61**](Intern/BEFUNDE.md#e-61)). Zwei Ziehschleifen wären eine zu viel. Der Splitter
ist dabei ein **Stapelobjekt** und lebt genau so lange wie der Zug — damit
kann [**E-60**](Intern/BEFUNDE.md#e-60) an dieser Stelle nicht auftreten.

**Entfallen:** der Zuschlag in `SECDockBar::CalcFixedLayout` (er hätte jetzt
einen leeren Streifen am Fensterrand hinterlassen) und 197 Zeilen
`TrennbalkenNeuAnlegen`. Die Fassung bleibt mit leerem Rumpf stehen, weil sie
an `ON_WM_SIZE` hängt.

### Was an 1.0.34 zu prüfen ist

1. **Rechte Leiste breiter ziehen** — Zeiger an die linke Kante der rechten
   Leiste, dort wird er zum Doppelpfeil, ziehen.
2. Dann **Filterfenster** öffnen: ist die rechte Hälfte erreichbar, lässt
   sich eine Regel bearbeiten? Das ist [**E-65**](Intern/BEFUNDE.md#e-65), und es sollte damit von
   selbst erledigt sein.
3. **Linke Leiste**, gleicher Handgriff an ihrer rechten Kante.
4. **Untere Leiste**, an ihrer Oberkante — auch kleiner ziehen, nicht nur
   größer.
5. Überlebt die Breite einen **Neustart**?
6. **Friert nichts ein?** Falls doch, sofort sagen.

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
wirklich passiert. Einmal ziehen, `eudora.log` schicken — danach ist [**E-66**](Intern/BEFUNDE.md#e-66)
entschieden, statt weiter geraten zu werden.

**Dazu behoben: die dritte Ursache von [E-66](Intern/BEFUNDE.md#e-66).**

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
Vermutungen am Code gescheitert — zwei zu [E-64](Intern/BEFUNDE.md#e-64) (eine Attrappe, die immer
`TRUE` liefert; ein `default`-Zweig in `MatchValue`) und zwei zu [E-66](Intern/BEFUNDE.md#e-66)
(`BrauchtGreifstreifen` lasse rechts nicht zu; es liege allein an
`CalcTrackingLimits`). Was sich lesen lässt, wird gelesen; was nicht, soll
das Programm selbst sagen.

**Die Marken gehören wieder heraus, sobald [E-66](Intern/BEFUNDE.md#e-66) steht** — ebenso die Marke
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

## Nach 1.0.29 — es wird an 7.2.0.30 gearbeitet

Im Repo liegen **Änderungen, die in keinem Paket stecken**: die zweite Ursache
von [**E-66**](Intern/BEFUNDE.md#e-66) (Trennbalken rechts) und [**E-63**](Intern/BEFUNDE.md#e-63) (Kurzhinweis der letzten Karte),
beide gebaut und
fehlerfrei übersetzt, aber **nicht ausgeliefert**. Dazu die Arbeit an den
**Filtern**, Gregors nächstem Gebiet.

`Eudora71/Version.h` und `VERSION` stehen deshalb schon auf **7.2.0.30 /
1.0.30**, obwohl es dieses Paket noch nicht gibt. Der Grund steht im
Abschnitt 7.2.0.30: der Bau vom 09.09.2026 trug **7.2.0.29** — dieselbe Nummer
wie das veröffentlichte Paket, aber anderen Code. Wer daraus ein Paket
geschnürt hätte, hätte zwei verschiedene Bauten unter derselben Kennung
ausgeliefert (Befund [**V-1**](Intern/BEFUNDE.md#v-1), Gregors Regel dazu: *„version muß eindeutig
sein"*). Die Nummern gehen also **vor** dem Paket hoch, nicht mit ihm.

> **In `Version.h` stehen drei Makros, nicht eines.** `EUDORA_VERSION4`,
> `EUDORA_BUILD_VERSION` **und** `EUDORA_BUILD_NUMBER` — das letzte im
> Komma-Format, heute `7,2,0,29`. Beim Sprung auf 7.2.0.23 hat meine Ersetzung es
> übersehen, und `tools/doku-pruefen.pl` hat den Commit abgewiesen. Benutzt
> wird es im ganzen Bestand nirgends (0 Treffer außerhalb von `Version.h`),
> es gehört aber trotzdem mit hochgesetzt.

> **Berichtigt am 09.09.2026 (LEKTOR, L-11).** Hier stand bis dahin eine
> Aufzählung von fünf Punkten, die als *„noch nicht gepackt"* geführt wurden —
> darunter *„[E-37](Intern/BEFUNDE.md#e-37): nur die ANZEIGE behoben"* und *„32 Spurmarken für [E-33](Intern/BEFUNDE.md#e-33)"*.
> **Beides ist überholt und widersprach schon der Überschrift dieses
> Abschnitts.** [E-37](Intern/BEFUNDE.md#e-37) ist kein eigener Fehler, sondern ein Symptom von [**E-43**](Intern/BEFUNDE.md#e-43),
> mit ihm in 7.2.0.24 behoben und von Gregor bestätigt; die Spurmarken zu [E-33](Intern/BEFUNDE.md#e-33)
> liegen seit 1.0.22 in jedem Paket. `tools/DEudora.ini`, `tools/bauen.ps1` und
> die Prüfungen 8 bis 11 in `tools/doku-pruefen.pl` sind ebenfalls längst
> ausgeliefert. Seit 1.0.29 ist **nichts** an **Behebungen** dazugekommen,
> was nicht in seinem Paket steckt — die Werkzeuge der letzten Bauten stehen
> in den Abschnitten zu
> 7.2.0.24 (`tools/testlauf.ps1`, `tools/pruefe-waechter.pl`) und 7.2.0.25.

> **Hier stand bis zum 07.09.2026 ein Abschnitt „Nach 7.2.0.18".** Er nannte
> `VERSION` mit 1.0.18, während die Datei drei Fassungen weiter war, und führte
> [**E-32**](Intern/BEFUNDE.md#e-32) als Behebung der modalen Meldung. Beides war falsch: die
> E-32-Ursachenbehauptung hat PRUEFER dreifach gemessen und **verworfen**
> (siehe 7.2.0.20). Gefunden hat den Widerspruch LEKTOR als **[W-3](Befunde/LEKTOR-4.md#w-3)** und **[W-5](Befunde/LEKTOR-4.md#w-5)**
> (`Befunde/LEKTOR-4.md`), nachdem Gregor gesagt hatte: *„wäre vor dem mergen
> wichtig, daß keine lügen im main stehen!"*

---



## 7.2.0.30 — Trennbalken rechts, Kurzhinweis der letzten Karte (in Arbeit)

**Noch nicht gebaut, nicht gepackt, nicht ausgeliefert.** Dieser Abschnitt
wächst, während an den Filtern gearbeitet wird — Gregors nächstes Gebiet.

**Was Gregor damit tun können wird, was in 1.0.29 nicht ging:** den
Trennbalken **rechts** ziehen ([**E-66**](Intern/BEFUNDE.md#e-66), siehe die Einschränkung unten), und der
Kurzhinweis erscheint auch
auf der **letzten** Registerkarte ([**E-63**](Intern/BEFUNDE.md#e-63)).

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
wie [E-58](Intern/BEFUNDE.md#e-58)**, der Browser-Klick ins Leere.

`OnDrawBorder` wiederzubeleben kam nicht in Frage — das würde auch das
Werbelogo zeichnen. Die Selbstheilung steht deshalb jetzt beim Zeichnen der
Karten und vergleicht die Zahl der **angemeldeten Felder** mit der Zahl der
**sichtbaren Karten**. Das ist die Messung selbst und nicht ihr Ergebnis:
stimmen die Zahlen, passiert nichts; stimmen sie nicht, wird einmal neu
gerechnet, danach stimmen sie.

### Warum die Nummer schon hochgesetzt ist

Der Bau vom 09.09.2026, 13:0x trug **7.2.0.29** — dieselbe Nummer wie das
veröffentlichte Paket, aber anderen Code. Das ist **Befund [V-1](Intern/BEFUNDE.md#v-1)** in Reinform
(*„version muß eindeutig sein"*): wer daraus ein Paket geschnürt hätte, hätte
zwei verschiedene Bauten unter derselben Kennung ausgeliefert. Die Nummern
stehen deshalb **sofort** auf 7.2.0.30 / 1.0.30, lange vor dem nächsten Paket.

## 7.2.0.29 — Acht Befunde des Prüfers und sieben aus der neuen Schranke

**Was Gregor damit tun kann, was vorher nicht ging:** den Trennbalken ziehen
und dabei **sehen**, wohin ([E-54](Intern/BEFUNDE.md#e-54)); den Registerkartenstreifen in den
Einstellungen wieder **abschalten** ([E-56](Intern/BEFUNDE.md#e-56)); rechts im Streifen klicken, ohne
dass sich ein **Browser** öffnet ([E-58](Intern/BEFUNDE.md#e-58)). Dazu drei Fehler, die noch nicht
aufgefallen sind, aber Schaden anrichten konnten ([E-57](Intern/BEFUNDE.md#e-57), [E-60](Intern/BEFUNDE.md#e-60), [E-61](Intern/BEFUNDE.md#e-61)), und der
leere Streifen unter der Werkzeugleiste ist weg ([E-55](Intern/BEFUNDE.md#e-55)).

**Von Gregor am 09.09.2026 an Paket 1.0.29 bestätigt** — die sechs Prüfpunkte
unten hat er einzeln durchgegangen: *„1-6, ok."* Dazu ungefragt: *„rechtklick
zeigt ja einen liste der offenen fenster: sehr gut."*

**Ein Restfehler steht, bewusst zurückgestellt ([E-63](Intern/BEFUNDE.md#e-63)):** *„alle karten, bis
auf die letzte (warum?) zeigen einen tooltip beim maus over. beim letzten
(ganz rechts) nicht."* Seine Entscheidung: *„bau mir mit dem bug ein 0.29
release auf github. den fehler notieren wir, wird im nächsten release
behoben."* Der Verdacht dazu steht in [BEFUNDE.md](Intern/BEFUNDE.md) unter **[E-63](Intern/BEFUNDE.md#e-63)**,
samt der Messung, die ihn widerlegen würde.

Acht davon kommen aus **PRÜFERs sechstem Durchgang** über die A-3/A-4-Arbeit,
sieben weitere aus dem ersten Lauf der Schranke, die daraus entstanden ist
([**E-62**](Intern/BEFUNDE.md#e-62), unten).
Sie wurden bewusst in **einem** Bau zusammengefasst: ein Bau kostet rund zwölf
Minuten, weil `OTShim.h` über `stdafx.h` im vorkompilierten Kopf liegt und
jede Änderung daran alle 364 Quellen neu übersetzt (siehe *Warum das Bauen so
lange dauert* unten).

### Was Gregor sieht

| Befund | Vorher | Jetzt |
|---|---|---|
| [**E-54**](Intern/BEFUNDE.md#e-54) | der Ziehrahmen war beim Ziehen **nach rechts unsichtbar** — man zog ins Blinde | er wird auf dem **Bildschirm** gezeichnet, wie MFC es beim Ziehen von Leisten macht, und ist über die ganze Strecke zu sehen |
| [**E-55**](Intern/BEFUNDE.md#e-55) | ein **acht Pixel hoher leerer Streifen** unter der Werkzeugleiste | weg — der Greifstreifen entsteht nur noch links, rechts und unten |
| [**E-56**](Intern/BEFUNDE.md#e-56) | *Show MDI task bar* **abschalten** ließ den Kartenstreifen stehen | er verschwindet |
| [**E-58**](Intern/BEFUNDE.md#e-58) | ein Klick in den **rechten Rand** des Streifens öffnete den **Browser**, ohne dass dort etwas zu sehen war | kein Treffer, solange das Logo nicht gezeichnet wird |

### Was er nicht sieht, was aber wichtiger ist

| Befund | Was passieren konnte |
|---|---|
| [**E-57**](Intern/BEFUNDE.md#e-57) | `IsTabLabelTruncated` legte bei **jeder Mausbewegung** über dem Streifen eine `CPaintDC` an — außerhalb von `WM_PAINT`. `BeginPaint` erklärt den Ungültigkeitsbereich für erledigt, **ohne zu malen**: was gerade neu gezeichnet werden sollte, wurde verworfen. Das ist Gregors Satz *„hier ist kein refresh drin"*, und er galt weiter, obwohl [E-52](Intern/BEFUNDE.md#e-52) behoben war |
| [**E-60**](Intern/BEFUNDE.md#e-60) | ein Trennbalken konnte **während des Ziehens gelöscht** werden. `Track` verteilt fremde Nachrichten, eine davon löst einen Anordnungsdurchlauf aus — und der lief durch `EndRecycleSplitters`, das genau das Objekt löschte, in dessen Methode man noch stand. Neu ist die Marke `m_bTracking`, die Freigabe **und** Löschen fernhält |
| [**E-61**](Intern/BEFUNDE.md#e-61) | `Track` **verschluckte `WM_QUIT`**. `PeekMessage` mit `PM_REMOVE` nimmt die Nachricht aus der Schlange; wer sie nicht zurückstellt, hat das Beenden des Programms verschluckt — **genau die Fehlerklasse aus Kriterium 7**, diesmal von mir selbst neu eingebaut. Jetzt wird sie mit `::PostQuitMessage` zurückgestellt und das Ziehen abgebrochen |
| [**E-59**](Intern/BEFUNDE.md#e-59) | `m_cxTab` wurde nur in `OnPaint` gesetzt. Alles, was die Kartenbreite braucht, **ohne zu malen** — `TabHitTest`, `QCGetTabRect`, `CalcLogoTopLeft` —, rechnete zwischen einer Änderung und dem nächsten Malen mit dem alten Wert, und ein Klick traf die Nachbarkarte |

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

Aus [E-51](Intern/BEFUNDE.md#e-51) und [E-61](Intern/BEFUNDE.md#e-61) ist `tools/pruefe-nachrichtenschleife.pl` entstanden: eine
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
   Strecke über **zu sehen** ([E-54](Intern/BEFUNDE.md#e-54))? Wird der linke Bereich breiter?
2. Nach links ziehen — wird er wieder schmaler? **Friert nichts ein?**
3. **Unter der Werkzeugleiste** — ist dort ein leerer Streifen ([E-55](Intern/BEFUNDE.md#e-55))? Sollte
   weg sein.
4. *Tools → Options → Interface*, **Show MDI task bar abschalten** — ist der
   Kartenstreifen weg ([E-56](Intern/BEFUNDE.md#e-56))? Wieder einschalten — ist er wieder da?
5. **Rechts im Kartenstreifen klicken**, hinter der letzten Karte — öffnet
   sich ein **Browser** ([E-58](Intern/BEFUNDE.md#e-58))? Sollte nicht.
6. Maus über eine Karte mit langem Titel halten — kommt der Kurzhinweis, und
   bleibt die Anzeige daneben **richtig** ([E-57](Intern/BEFUNDE.md#e-57))?
7. *File → Exit* während nichts gezogen wird — beendet es sauber ([E-61](Intern/BEFUNDE.md#e-61) darf
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
sein Befund [E-53](Intern/BEFUNDE.md#e-53) kam danach, und die Fassung war released und fehlerhaft
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
Registerkartenleiste, die er selbst gefunden hat ([**E-50**](Intern/BEFUNDE.md#e-50)).

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
der `Eudora.ini` gibt es seit der Behebung von [**E-43**](Intern/BEFUNDE.md#e-43) überhaupt erst.

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
| [**E-43**](Intern/BEFUNDE.md#e-43) | `SaveCustomInfo` warf bei **jedem** Beenden → der Leistenzustand wurde **nie** gespeichert. Jetzt: **13** `[ToolBar…]`-Abschnitte in der `Eudora.ini` statt **0**, und keine [`E-42`](Intern/BEFUNDE.md#e-42)-Zeile mehr |
| [**E-37**](Intern/BEFUNDE.md#e-37) | `CPersonality::Remove` löscht den INI-Abschnitt und ruft dann `DeleteCommand` → `NotifyClients(CA_DELETE)` → `QCCustomToolBar::Notify` (`:951`), wo in `:970` dasselbe Muster steht. Der Wurf fliegt aus `Remove()` heraus, der Anzeige-Code darunter wird nie erreicht. Belegt durch die Abwesenheit jeder Spur: **keine einzige E-37-Marke** in Gregors Protokoll |
| [**E-38**](Intern/BEFUNDE.md#e-38) | war **gar kein Fehler**. Gregor am 08.09.2026: *„nach dem löschen eines kontos, wenn das konto noch sichtbar ist, dann fehlen die daten in den eigenschaften … beim neuen konto sind sie zu sehen."* Die leeren Felder gehörten zu einem Geistereintrag, den [E-37](Intern/BEFUNDE.md#e-37) in der Liste stehen ließ |
| [**E-34**](Intern/BEFUNDE.md#e-34) | dasselbe Muster an einer dritten Stelle (`QCChildToolBar::GetButton`) — die dortige Umgehung bleibt, die Wurzel ist jetzt weg |

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

1. **Ein Konto löschen** ([E-37](Intern/BEFUNDE.md#e-37)): verschwindet der Eintrag links **sofort**,
   ohne Neustart? Kommt noch „Encountered an improper argument"?
2. **Fenster verschieben, beenden, neu starten** ([E-43](Intern/BEFUNDE.md#e-43)): steht die
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
([**E-43**](Intern/BEFUNDE.md#e-43)). Nachgemessen: weder Gregors `Eudora.ini` noch die eines frischen
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
noch rund 230 Zeilen. Wäre der Verdacht richtig, hätte [**E-43**](Intern/BEFUNDE.md#e-43) damit seine
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
[**E-6**](Intern/BEFUNDE.md#e-6)). Die Titelzeile muss
`Eudora 7.2.0.23 / Paket 1.0.23` nennen.

1. **Die untere Leiste** — *Task Status* und *Task Errors* liegen waagrecht am
   unteren Fensterrand, über die ganze Breite. **Von Gregor am 08.09.2026
   bestätigt:** *„leiste unten paßt."* Rechts darf **keine** Kurznamen-Spalte
   dauerhaft offenstehen.
2. **[E-37](Intern/BEFUNDE.md#e-37), gelöschtes Konto** (steckt seit 1.0.22 drin, noch unbestätigt):
   eine Persönlichkeit anlegen und wieder löschen. Verschwindet der Eintrag
   links **sofort**, ohne Neustart? Kommt noch „Encountered an improper
   argument"?
3. **[E-38](Intern/BEFUNDE.md#e-38), Assistentendaten** — jetzt erstmals messbar, weil der Blocker [E-33](Intern/BEFUNDE.md#e-33)
   weg ist: Konto über den Assistenten anlegen, Eudora **normal** beenden, neu
   starten, *Konto → Eigenschaften* ansehen. Stehen Name, Mailadresse und
   Server da?
4. **Das Beenden** über alle drei Wege: *File → Exit*, **Alt-F4**, das
   **Kreuz**.
5. [**E-43**](Intern/BEFUNDE.md#e-43) braucht nur einen normalen Beendigungsvorgang. Danach steht in
   `Mailverzeichnis\eudora.log` eine Zeile `[E-43](Intern/BEFUNDE.md#e-43) SaveCustomInfo: … Versatz=…
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
'leave message on server' greifen."* — **Anforderung [A-1](Intern/BEFUNDE.md#a-1)** ist damit am
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

**Das Beenden läuft nur, weil [E-42](Intern/BEFUNDE.md#e-42) den Fehler abfängt.** Er ist nicht
verschwunden, er steht jetzt als Protokollzeile da:

    [E-33](Intern/BEFUNDE.md#e-33) SaveCustomInfo: Abschnitt=ToolBar-BarID59392  this=06283F80  GetBtnCount=24  m_btns.GetSize=0
    [E-33](Intern/BEFUNDE.md#e-33) SaveCustomInfo: der FELDZUGRIFF m_btns[0] wirft (GetSize=0)
    [E-42](Intern/BEFUNDE.md#e-42) Beenden: Schritt 'SaveBarState(ToolBar)' hat eine Ausnahme ausgeloest - Das Beenden wird fortgesetzt.

**Damit ist der Widerspruch aufgelöst, der seit [E-34](Intern/BEFUNDE.md#e-34) offen stand.**
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
ersten Start eine leere Einrichtung an (Befund [**E-6**](Intern/BEFUNDE.md#e-6)).

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
[**E-6**](Intern/BEFUNDE.md#e-6)).

| Prüfen | erwartet | wenn nicht |
|---|---|---|
| **Strg-N** | ein Verfassen-Fenster, das man benutzen kann | [E-31](Intern/BEFUNDE.md#e-31)/[E-34](Intern/BEFUNDE.md#e-34)/[E-35](Intern/BEFUNDE.md#e-35)/[E-36](Intern/BEFUNDE.md#e-36) greifen nicht |
| **Mail abschicken** | landet in *Out*, kommt beim Empfänger an | Kriterium 5 wieder offen |
| **Weiterleiten** (Strg-Umschalt-F) | Verfassen-Fenster mit dem Text darin | Kriterium 6 wieder offen |
| **Doppelklick** auf eine Nachricht | öffnet sie | [E-28](Intern/BEFUNDE.md#e-28) greift nicht |
| **Suchtreffer anklicken** | öffnet die Nachricht | dito |
| **Werkzeugleiste** im Suchfenster | abgeschaltete Knöpfe zeigen ihr Symbol | [E-30](Intern/BEFUNDE.md#e-30) greift nicht |
| ***File → Exit*** | beendet sauber | **bekannt: tut es nicht** (Kriterium 7) |
| **Menü *Window*** | listet die offenen Fenster | E-34-Kette greift nicht |

Nach einem Absturz **zwei Dateien** im Mailverzeichnis ansehen:

- **`eudora.log`** — die letzte Zeile mit [`E-27`](Intern/BEFUNDE.md#e-27) nennt die letzte Station, die
  noch erreicht wurde. 15 Spurmarken liegen auf dem Weg. Sie schreiben **nur**,
  wenn in `Eudora.ini` unter `[Debug]` `LogLevel=32896` steht —
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

Die Abfrage `nIndex != -1` darüber schützt nicht: **seit [E-34](Intern/BEFUNDE.md#e-34) gibt `GetButton`
auch bei gültigem Index NULL zurück.** Aus einer Ausnahme wurde ein NULL, und
diese Stelle rechnete nicht damit. Beim ersten Strg-N kommt sie nicht dran, beim
zweiten schon.

Gefunden hat es **`tools/pruefe-fensterbau.pl`**, die Schranke, die zu diesem
Zweck entstand.

### E-36 — dasselbe zweimal in `PgCompMsgView`, gefunden vom eigenen Absturzbericht

Aufgelöst mit `tools/absturz-auswerten.pl` — der Werkzeugkette aus [E-26](Intern/BEFUNDE.md#e-26) und
[E-29](Intern/BEFUNDE.md#e-29), die genau dafür gebaut wurde:

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
| [E-33](Intern/BEFUNDE.md#e-33) | keine modale Meldung in `Eudora71/OTShim/*.cpp` |
| [E-34](Intern/BEFUNDE.md#e-34) | `GetButton` hat Indexschranke **und** Ausnahmefang |
| [E-34](Intern/BEFUNDE.md#e-34) | jeder `GetButton`-Aufruf prüft sein Ergebnis auf NULL |

Die Gegenproben haben **zwei Fehler in der Schranke selbst** gefunden. Der
schlimmere: `OTShim.cpp:99` trägt im *Zeilen*kommentar den Text
`dlg.Create in Eudora/*.cpp` — das `/*` darin öffnete beim Entfernen der
Blockkommentare einen Scheinkommentar und fraß 1600 Zeichen. **Die Gegenprobe zu
[E-33](Intern/BEFUNDE.md#e-33) blieb dadurch grün, obwohl die modale Meldung wieder eingebaut war.** Eine
Schranke, die eine Regression verschweigt, ist schlimmer als keine. Jetzt werden
Zeilenkommentare zuerst entfernt.

### Neues Kriterium 8

Von Gregor am 07.09.2026 gesetzt: *„die offenen fenster (nibox, outbox, neue
mail, ...) sollten irgendwie sichtbar und auswählbar sein. entweder über window
menü oder über reiter in der statuszeile oder ähnlich."*

Der Bezug ist unmittelbar: die modale Meldung, die mit [E-33](Intern/BEFUNDE.md#e-33) abgeschaltet wurde,
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
Schranke aus [E-16](Intern/BEFUNDE.md#e-16) greift also, und `m_btns[24]` wirft trotzdem. MFC 14 prüft in
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
- ***File → Exit*** bringt weiter eine Meldung ([E-33](Intern/BEFUNDE.md#e-33) der Zählung in ZIEL.md)

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

**[E-31](Intern/BEFUNDE.md#e-31) — `pg_time_t` war acht Byte breit statt vier.** Eine Zeile im
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

> **Nachtrag 07.09.2026: [E-32](Intern/BEFUNDE.md#e-32) ist behoben.** Der unten festgehaltene Verdacht
> traf den Ort, aber nicht die Ursache. Es war nicht
> `AutoCompleterListBox::KillACListBox` selbst, sondern der **ungeprüfte
> Zeiger auf dem Weg dorthin**: `CHeaderView::OnKillFocusRecipient` in
> `Eudora71/Eudora/headervw.cpp` dereferenzierte `pField`, obwohl die Abfrage
> drei Zeilen darüber ausdrücklich mit NULL rechnet. `GetDlgItem` liefert NULL,
> solange das Kopfzeilenfeld nicht existiert — und `OnKillFocusTo` läuft
> während `LoadFrame`, also bevor die Felder da sind. Dieselbe Fehlerklasse wie
> [E-18](Intern/BEFUNDE.md#e-18) und [E-22](Intern/BEFUNDE.md#e-22). **Von Gregor nicht nachgemessen.**

- **[E-32](Intern/BEFUNDE.md#e-32) — die Meldung „An unhandled exception has occurred" beim Verfassen.**
  Das ist der letzte Schritt bis Kriterium 5. **Gemessen am 06.09.2026 nach der
  Behebung von [E-31](Intern/BEFUNDE.md#e-31):** die Spur läuft jetzt **vollständig** durch —
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
  ausgelöst — das war irreführend, es ist [E-32](Intern/BEFUNDE.md#e-32)
- **Der eigentliche Schlussstein wäre ein Neubau von `Paige32.dll` mit VS2022** —
  Quellen (`PGSOURCE`, 37 `.C`-Dateien) und `PAIGE32/Paige32.vcproj` liegen
  vor. Dann kann keine Kopfdatei mehr von der Binärdatei abweichen

### Neue Werkzeuge

`tools/strg-n-pruefen.ps1` startet Eudora, klickt Meldungen weg, schickt Strg-N
und sagt, ob das Fenster aufgeht — ohne dass jemand danebensitzt.
`tools/befehl-schicken.ps1` schickt einen beliebigen Menübefehl. Beide beenden
nur Eudora-Prozesse aus dem angegebenen Testverzeichnis.

## 7.2.0.17 / Paket 1.0.17 — 06.09.2026 · nicht ausgeliefert

Reine Messfassung. Zweck war, [E-27](Intern/BEFUNDE.md#e-27) einzukreisen. **Das ist gelungen, die
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
Fehlerklasse wie Befund [S-2](Intern/BEFUNDE.md#s-2) vom 30.08.2026, wo Paige an einer Fläche der Größe
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

- **[E-30](Intern/BEFUNDE.md#e-30) — Symbole der Werkzeugleiste.** Gesperrte Knöpfe zeigten eine leere
  graue Fläche. Ursache: die sechs Bitmaps der Hauptleiste sind **24 Bit** und
  haben damit keine Farbtabelle, die `CreateMappedBitmap` umsetzen könnte. Das
  Buttongrau `192,192,192` blieb stehen, während `COLOR_BTNFACE` heute
  `240,240,240` ist; die Maske erfasste dadurch das ganze Bildrechteck. Die
  8-Bit-Bitmaps der Nachrichtenfenster waren nie betroffen — das erklärt, warum
  nicht *alle* Symbole fehlten. Unter VC6 war die Systemfarbe selbst
  `192,192,192`, deshalb fiel es nie auf. Behoben in
  `OTShim/OTShim_Werkzeugleiste.cpp`, dazu `tools/pruefe-symbole.pl` und
  `Eudora71/Tests/TestSymbole.cpp`
- **[E-28](Intern/BEFUNDE.md#e-28) — Doppelklick und Suchtreffer öffneten nichts.**
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

Gebaut und geprüft, aber nie ausgeliefert — [E-30](Intern/BEFUNDE.md#e-30) kam dazwischen. Die Nummer
bleibt verbrannt, damit keine zwei Bauten dieselbe tragen.

- **[E-26](Intern/BEFUNDE.md#e-26) — der Absturzbericht nennt die Ladeadresse jedes Moduls.** Ohne sie war
  keine Zeile des Aufrufstapels einem Funktionsnamen zuzuordnen: Windows lädt
  `Eudora.exe` verschoben (ASLR), und `Exception.log` schrieb die tatsächliche
  Basis nicht mit. Ein Versuch, gegen die vorgesehene `0x00400000` zu rechnen,
  lieferte prompt einen Namen aus dem Ressourcenbereich
- **[E-29](Intern/BEFUNDE.md#e-29) — `tools/absturz-auswerten.pl`**, 15 Selbsttests. Macht aus
  `Exception.log` Funktionsnamen und sagt bei älteren Berichten ausdrücklich,
  dass es **nicht** geht, statt zu raten
- **[E-27](Intern/BEFUNDE.md#e-27), erster Teil** — die drei stillen Fehlerklassen werden protokolliert:
  `_set_invalid_parameter_handler`, `_set_purecall_handler`, `set_terminate`.
  Der Absturzbehandler hing nur an `SetUnhandledExceptionFilter`, und vier Wege
  gehen daran vorbei
- `Eudora.vcxproj` erzeugt bei jedem Bau `Eudora71/Bin/Release/Eudora.map`

## 7.2.0.10 / Paket 1.0.10 — 05.09.2026

Die Fassung, mit der **Kriterium 0** belegt wurde: von Gregor am 06.09.2026 auf
einem Rechner ohne Visual Studio ausgepackt und gestartet.

- [**E-23**](Intern/BEFUNDE.md#e-23) — POP3 fiel nicht mehr still auf Port 110 zurück; TLS-Fehler werden
  gemeldet statt verschluckt. Damit lief erstmals Port 995 mit TLS 1.3
- [**E-24**](Intern/BEFUNDE.md#e-24) — „In" stand zweimal unter *Recent*
- [**E-22**](Intern/BEFUNDE.md#e-22) — ungeprüfte Zeiger im Aufbau des Nachrichtenfensters
- **[E-18](Intern/BEFUNDE.md#e-18), [E-19](Intern/BEFUNDE.md#e-19)** — zwei Fehler, die erst mit einer zweiten Persönlichkeit
  auftreten

## 7.2.0.3 / Paket 1.0.3 — 31.08.2026

Erster Release-Bau, der Mail abruft: 159 Nachrichten über POP3 Port 110 mit
STARTTLS.

## Paket 1.0.2 — 30.08.2026

Eudora startet und zeigt sein Hauptfenster — erstmals seit Beginn der
Portierung. Möglich wurde das durch [**S-2**](Intern/BEFUNDE.md#s-2): die Werbefläche wurde mit
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
10:02. Behoben sind [E-31](Intern/BEFUNDE.md#e-31), [E-34](Intern/BEFUNDE.md#e-34), [E-35](Intern/BEFUNDE.md#e-35) und [E-36](Intern/BEFUNDE.md#e-36).

**So misst man es nach**, ohne dass jemand danebensitzt:

```
powershell -ExecutionPolicy Bypass -File tools\strg-n-pruefen.ps1 -Verzeichnis <Paket>
```

Das Werkzeug startet Eudora, klickt Meldungen weg, schickt Strg-N und sagt, ob
das Fenster aufgeht. Für das Protokoll braucht es `LogLevel=32896` unter
`[Debug]` in der `Eudora.ini` — `PutDebugLog` prüft die Maske und kehrt
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
war [E-31](Intern/BEFUNDE.md#e-31). `Eudora71/PaigeDLL` enthält **doch** Quellen: `PGSOURCE` mit 37
`.C`-Dateien, dazu `PAIGE32/Paige32.vcproj` und die alten Makefiles. Bis zum
06.09.2026 stand an dieser Stelle das Gegenteil, und das hat die Suche nach
[E-31](Intern/BEFUNDE.md#e-31) unnötig lange aufgehalten. Der Rekursionszyklus ist dort nachzulesen
(`PGDEFSTL.C:1640`).

**Noch nicht versucht:** Page Heap (`gflags /p /enable Eudora.exe /full`, als
Administrator).

### 2. Erledigt: Kriterium 7 — Eudora beendet sich sauber

**Von Gregor am 08.09.2026 an Paket 1.0.22 bestätigt:** *„schließen klappt
jetzt."* Alle drei Wege beenden — *File → Exit*, **Alt-F4** und das **Kreuz**.
Behoben durch [**E-40**](Intern/BEFUNDE.md#e-40), [**E-41**](Intern/BEFUNDE.md#e-41) und [**E-42**](Intern/BEFUNDE.md#e-42), ergänzt um [**E-45**](Intern/BEFUNDE.md#e-45). Der Weg
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
in der Ersatzschicht `OTShim` ([**E-48**](Intern/BEFUNDE.md#e-48), umgesetzt in 7.2.0.25). Drei Mängel,
die Gregor dabei gemeldet hat, sind als [**E-50**](Intern/BEFUNDE.md#e-50) in 7.2.0.26 behoben und
**noch nicht** von ihm beurteilt.

### 4. Die Meldung „Encountered an improper argument"

MFCs Text für `CInvalidArgException`, kommt also aus MFC, nicht aus Eudora.
Zwei Quellen sind bekannt und behoben: `QCChildToolBar::GetButton` mit Index
minus eins ([**E-16**](Intern/BEFUNDE.md#e-16)) und dieselbe Funktion mit einem Index innerhalb der
gemeldeten Anzahl ([**E-34**](Intern/BEFUNDE.md#e-34), abgefangen).

**Die Ursache dahinter ist seit 7.2.0.24 gefunden und behoben: [E-43](Intern/BEFUNDE.md#e-43).**
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
