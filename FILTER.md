# Post automatisch einsortieren — Filter und Junk

Diese Datei beschreibt die Filter von Eudora aus Sicht dessen, der sie
benutzt: wie eine Regel entsteht, wann sie läuft, was sie tun kann, wo sie
gespeichert wird — und was es mit den Junk-Werten auf sich hat.

**Jede Angabe hier ist am Quelltext nachgesehen**, mit Datei und
Zeilennummer. Wo etwas nicht belegbar war, steht das ausdrücklich dabei.
Die Zeilennummern beziehen sich auf den Stand dieses Zweigs; die Dateien
liegen unter `Eudora71/Eudora/`.

Verwandte Dokumente: [README.md](README.md) — dort der Abschnitt
*Einstellungen, die es nur hier gibt* mit den Abweichungen dieser
Portierung; [BEFUNDE.md](BEFUNDE.md) — die vollständigen Befunde;
[CHANGELOG.md](CHANGELOG.md) — was wann behoben wurde.

---

## Bevor Sie anfangen

> **Sichern Sie `Filters.pce`.** Die Datei liegt im Mailverzeichnis. Eudora
> schreibt sie beim Verlassen des Filterfensters neu und legt keine
> Sicherung an. Mehrere der unten genannten Befunde haben genau diese Datei
> beschädigt.

> **Ein Filterlauf kann Post auf dem Server löschen.** In dieser Portierung
> ist der Weg gesperrt (**E-73**), aber nur, solange
> `FilterMayDeleteFromServer` auf `0` steht — im Abschnitt `[Settings]` der
> **`Eudora.ini` in Ihrem Mailverzeichnis**. Steht der Schlüssel dort gar
> nicht, gilt `0`, und die Sperre greift. Siehe
> [Die Aktion „Server Options"](#die-aktion-server-options).

---

## Einen Filter anlegen

Es gibt zwei Wege. Beide schreiben in dieselbe Liste.

### Über das Filterfenster

*Tools → Filters* (`EudoraRes.rc:5789`). Das Fenster ist zweigeteilt: links
die Liste der Regeln mit den Schaltflächen **Up**, **Down**, **New** und
**Remove** (`EudoraRes.rc:2282-2293`), rechts die ausgewählte Regel
(`EudoraRes.rc:542-587`).

*New* legt eine leere Regel an. Sie bekommt ihren Namen nicht von Ihnen,
sondern aus der ersten Bedingung — `CFilter::SetName` setzt ihn beim
Übernehmen zusammen, weshalb eine Regel in der Liste zum Beispiel
`From:mailings@sicher.gmx.net` heißt.

Rechts stellen Sie ein:

| Feld | Bedeutung |
|---|---|
| **Incoming**, **Outgoing**, **Manual** | wann die Regel überhaupt befragt wird (`EudoraRes.rc:546-551`) |
| **Header** + **Verb** + **Value** | die erste Bedingung |
| **Conjunction** | wie die zweite Bedingung mit der ersten verknüpft wird |
| **Header** + **Verb** + **Value** | die zweite Bedingung |
| fünf Auswahlfelder unter *Action* | die Aktionen, siehe unten |

**Mehr als zwei Bedingungen und mehr als fünf Aktionen gibt es nicht.** Das
Filterobjekt trägt genau zwei Bedingungen (`filtersd.h:124-126`,
`m_Header[2]`, `m_Verb[2]`, `m_Value[2]`) und genau fünf Aktionsplätze
(`filtersd.h:129`, `NUM_FILT_ACTS` = 5 in `filtersv.h:39`). Wer mehr braucht,
teilt die Sache auf mehrere Regeln auf und arbeitet mit *Skip Rest*.

### Über „Make Filter"

*Special → Make Filter* (`EudoraRes.rc:5769`), auch im Kontextmenü einer
Nachricht (`EudoraRes.rc:5881`). Eudora nimmt die markierte Nachricht
(oder mehrere) und baut daraus einen Vorschlag: Bedingung wahlweise auf
**From**, **Any Recipient** oder **Subject**, Aktion wahlweise *Transfer to
New Mailbox*, *Transfer to Existing Mailbox* oder *Delete Message (Transfer
to Trash)* (`EudoraRes.rc:1326-1364`).

*Create Filter* legt die Regel sofort an. *Add Details* legt sie an und
öffnet dazu das Filterfenster.

Findet Eudora in der Auswahl nichts Gemeinsames, kommt:

> *Sorry, Eudora can't detect any common elements to make a filter with. Try
> adjusting your selection, or use the filters window.* (`EudoraRes.rc:7036`)

### Wann das Ergebnis auf der Platte landet

Es gibt **keine Schaltfläche „Speichern"**. Jede Änderung setzt zunächst nur
eine Merkmarke im Speicher (`filtersv.cpp:524`, `:572`, `:598`, `:620`,
`:1299`, `:1490`, `:2223`, `:2425`, `:2752`, `:2805`).

Geschrieben wird, wenn Sie den Reiter *Filters* verlassen oder Eudora
beenden: `CFiltersWazooWnd::OnDeactivateWazoo` ruft
`CFiltersDoc::CanCloseFrame` (`FiltersWazooWnd.cpp:122`), und die Funktion
stellt die Frage *„Save changes to …?"* mit **Ja / Nein**
(`filtersd.cpp:2170-2195`).

* **Ja** schreibt `Filters.pce`.
* **Nein** wirft die Liste im Speicher weg und liest die Datei neu ein
  (`filtersd.cpp:2185-2189`) — Ihre Änderungen sind dann verloren.
* Beim automatischen Herunterfahren (`gbAutomatedShutdown`) wird **ohne
  Frage gespeichert** (`filtersd.cpp:2196-2199`).

---

## Wann ein Filter läuft

Drei Zeitpunkte, unabhängig voneinander ankreuzbar
(`filtersd.h:61-63`, `WTA_INCOMING`, `WTA_OUTGOING`, `WTA_MANUAL`):

| Häkchen | läuft | Fundstelle |
|---|---|---|
| **Incoming** | nach dem Abholen, über die neu eingetroffenen Nachrichten | `pop.cpp:999` |
| **Outgoing** | beim Senden, über die versendete Nachricht | `sendmail.cpp:186` |
| **Manual** | wenn Sie den Lauf selbst anstoßen | `TocFrame.cpp:2403`, `msgdoc.cpp:792` |

Der Eingangslauf findet nur statt, wenn `FilterIncomingMail` gesetzt ist —
eingebaute Vorgabe **1** (`EudoraRes.rc:8131`, geprüft in `pop.cpp:157`).

**Ein Filter, der für den anstehenden Lauf nicht angekreuzt ist, wird gar
nicht erst betrachtet** (`filtersd.cpp:2351`). Wer *Manual* vergisst,
wundert sich, dass der Filterlauf von Hand nichts tut.

### Den Lauf selbst anstoßen

*Special → Filter Messages* (`EudoraRes.rc:5768`) filtert die **markierten**
Nachrichten des vorderen Postfachs, von unten nach oben
(`TocFrame.cpp:2396-2408`). Im geöffneten Nachrichtenfenster filtert derselbe
Befehl diese eine Nachricht (`msgdoc.cpp:792`).

Während des Laufs zeigt Eudora `Messages left to filter: N`
(`EudoraRes.rc:9652`). **Esc bricht ab** (`TocFrame.cpp:2399`).

### Das Tastenkürzel ist nicht fest

Im Menü steht `Ctrl+J` (`EudoraRes.rc:5768`) — aber die Taste ist
umschaltbar. `CMainFrame::OnCtrlJ` fragt den Wert `CtrlJMapping`
(`mainfrm.cpp:3942-3948`):

| `CtrlJMapping` | Strg+J | Strg+Umschalt+J | Strg+Umschalt+L |
|---|---|---|---|
| `1` (*Junk*) | *Junk* | *Not Junk* | *Filter Messages* |
| `2` (*Filter*) | *Filter Messages* | — | — |

Eingebaute Vorgabe ist `0` — „noch nicht entschieden"
(`EudoraRes.rc:8734`, `CTRL_J_UNKNOWN` in `JunkMail.h:61`). Den echten Wert
setzt Eudora **beim ersten Start selbst**, in
`CMainFrame::InitJunkMenus` (`mainfrm.cpp:7911-7952`): sind schon manuelle
Filter da, fragt es nach (`IDD_CTRL_J_FOR_JUNK`, `EudoraRes.rc:4717-4726`);
sind keine da, entscheidet es stillschweigend. **Diese Portierung entscheidet
in diesem Fall für *Filter Messages*, das Original für *Junk*** (Befund
**E-75**, `mainfrm.cpp:7937-7949`).

Welche Belegung gerade gilt, sehen Sie im Menü: `InitJunkMenus` schreibt das
Kürzel neben *Filter Messages* und neben *Junk*
(`mainfrm.cpp:7976-7994`).

In einem **bestehenden** Mailverzeichnis wirkt die Änderung nicht — dort
steht der Wert schon in der `Eudora.ini`. Bei geschlossenem Eudora von Hand:

```ini
[Settings]
CtrlJMapping=2
```

---

## Bedingungen

### Wonach gesucht werden kann

Das Auswahlfeld *Header* ist frei beschreibbar (`CBS_DROPDOWN`,
`EudoraRes.rc:553`) — Sie können also jede beliebige Kopfzeile eintragen,
etwa `List-Id:`. Vorgeschlagen werden
(`EudoraRes.rc:9271-9276`, `:9660-9663`):

`To:` · `From:` · `Subject:` · `Cc:` · `Reply-To:` ·
`«Any Header»` · `«Body»` · `«Any Recipient»` · `«Personality»` ·
`«Junk Score»`

### Die Vergleiche

Sechzehn Stück (`EudoraRes.rc:9664-9683`, Bereich `IDS_CONTAINS` …
`IDS_MORE_THAN` in `resource.h:511-526`):

`contains` · `doesn't contain` · `is` · `is not` · `starts with` ·
`ends with` · `appears` · `doesn't appear` · `intersects nickname` ·
`doesn't intersect nickname` · `intersects address book` ·
`doesn't intersect address book` · `matches regexp (case insensitive)` ·
`matches regexp` · `is less than` · `is greater than`

Die beiden letzten sind **nur für «Junk Score» gedacht** — `VERB_LAST_NON_JUNK`
endet bei `matches regexp` (`filtersd.h:30`), und ausgewertet werden sie nur,
wenn die Kopfzeile `«Junk Score»` ist (`filtersd.cpp:678-692`).

Verglichen wird **ohne Rücksicht auf Groß- und Kleinschreibung**; nur die
beiden Regexp-Vergleiche bekommen den Text unverändert
(`filtersd.cpp:719-729`).

### Die Verknüpfung der beiden Bedingungen

`ignore` · `and` · `or` · `unless` (`EudoraRes.rc:9688-9691`, geladen in `filtersv.cpp:1066`).
`ignore` bedeutet: die zweite Bedingung zählt nicht.

---

## Aktionen

Fünf Plätze je Regel. Die Auswahl steht in `EudoraRes.rc:6063-6093`, die
Kennungen in `resource.h:4251-4271`.

| Aktion | was sie tut | Fundstelle |
|---|---|---|
| **None** | nichts | `filtersd.cpp:1122` |
| **Make Status** | setzt den Nachrichtenzustand (gelesen, ungelesen, …) | `filtersd.cpp:1397-1409` |
| **Make Priority** | hebt, senkt oder setzt die Dringlichkeit | `filtersd.cpp:1124-1132` |
| **Make Label** | vergibt eine der Farbmarken | `filtersd.cpp:1151-1155` |
| **Make Personality** | ordnet die Nachricht einer Persönlichkeit zu | `filtersd.cpp:1283-1290` |
| **Make Subject** | ersetzt den Betreff; ein `&` im Text steht für den alten Betreff | `filtersd.cpp:1314-1331` |
| **Play Sound** | spielt eine Klangdatei, einmal je Lauf | `filtersd.cpp:1255-1259` |
| **Speak** | liest *Who* und/oder *Subject* vor | `filtersd.cpp:1261-1281`, Wahltexte `EudoraRes.rc:10592-10593` |
| **Open** | öffnet *Mailbox* oder *Message* | `filtersd.cpp:1292-1297`, Wahltexte `EudoraRes.rc:10582-10583` |
| **Print** | druckt die Nachricht | `filtersd.cpp:1293`, gedruckt in `filtersd.cpp:3798` |
| **Notify User** | *As Normal* (wie unter *Getting Attention* eingestellt) oder *In Report* | `filtersd.cpp:1584-1588`, Wahltexte `EudoraRes.rc:10584-10585` |
| **Notify Application** | startet ein Programm; Platzhalter im Befehl füllt `SetupCommandLine` | `filtersd.cpp:1135-1149` |
| **Forward To** | leitet weiter | `filtersd.cpp:1333-1379` |
| **Redirect To** | leitet um | `filtersd.cpp:1334` |
| **Reply with** | antwortet mit einer Briefvorlage | `filtersd.cpp:1335` |
| **Server Options** | *Fetch* und/oder *Delete* auf dem Server vormerken | `filtersd.cpp:1157-1253`, siehe unten |
| **Copy To** | legt eine Kopie in ein Postfach | `filtersd.cpp:1425-1535` |
| **Transfer To** | verschiebt in ein Postfach | `filtersd.cpp:1426` |
| **Junk** | behandelt die Nachricht wie von Hand gejunkt und verschiebt sie nach *Junk* | `filtersd.cpp:1537-1558` |
| **Skip Rest** | bricht die weitere Filterung dieser Nachricht ab | `filtersd.cpp:1422-1424` |

### Die Aktion „Server Options"

*Delete* merkt die Nachricht auf dem Server zum Löschen vor. Im Original
sticht das sogar die Einstellung *Leave mail on server*.

**In dieser Portierung tut die Aktion nichts mehr auf dem Server**, solange
`FilterMayDeleteFromServer` nicht ausdrücklich auf `1` gesetzt ist
(`filtersd.cpp:1216-1240`). Der Schlüssel steht im Abschnitt `[Settings]`
der **`Eudora.ini` in Ihrem Mailverzeichnis** — also dort, wo auch Ihre
Konten stehen, nicht in der `DEudora.ini` neben der `Eudora.exe`:

```ini
[Settings]
FilterMayDeleteFromServer=0
```

Fehlt der Schlüssel, gilt `0`. Eudora muss beim Ändern geschlossen sein,
sonst überschreibt es die Datei beim Beenden. Alle übrigen Schlüssel stehen
in [Die Einstellungen in der `Eudora.ini`](#die-einstellungen-in-der-eudoraini).

Der Versuch wird abgelehnt und protokolliert:

```
E-73 Filter "<Name>" wollte die Nachricht "<Betreff>" auf dem Server
loeschen - VERWEIGERT
```

Grund ist Befund **E-73**: die Aktion war am 10.09.2026 durch einen Fehler in
ein Filterobjekt geraten, ohne je eingestellt worden zu sein, und hat ein
ganzes Postfach auf dem Server geleert. *Fetch* ist unberührt — es vernichtet
nichts.

---

## Die Reihenfolge

### Drei Läufe je Nachricht

`CFilterActions::FilterOne` (`filtersd.cpp:3632-3651`) fragt **drei**
Filterlisten nacheinander:

1. **Vorlauf** — Dateien `*.pre`
2. **Hauptlauf** — `Filters.pce`, Ihre eigenen Regeln
3. **Nachlauf** — Dateien `*.pst`

Vor- und Nachlauf lädt Eudora aus dem Verzeichnis
`<Mailverzeichnis>\Filters\` (`filtersd.cpp:2566-2583`, Verzeichnisname
`EudoraRes.rc:10611`, Endungen `:10612-10613`). Diese Dateien sind für
Zusatzmodule gedacht; das Filterfenster zeigt sie nicht an und **schreibt sie
nie** — `CFiltersDoc::Write` schreibt ausschließlich die Hauptliste
(`filtersd.cpp:3267`).

Ein **Skip Rest** in einer der drei Listen beendet nicht nur die eigene
Liste, sondern auch die folgenden (`filtersd.cpp:3644-3650`).

### Innerhalb einer Liste

Von oben nach unten (`filtersd.cpp:2345-2351`). Die
Schaltflächen *Up* und *Down* verschieben eine Regel in dieser Reihenfolge.

### Innerhalb einer Regel

**Nicht** in der Reihenfolge, in der die fünf Aktionen dastehen. Eudora geht
die fünf Plätze viermal durch (`filtersd.cpp:1113`, `:1305`, `:1385`,
`:1413`):

1. Priority, Label, Notify Application, Server Options, Play Sound, Speak,
   Personality, Open, Print
2. Make Subject, Forward, Redirect, Reply
3. Make Status — ausdrücklich **nach** dem Antworten und Weiterleiten, weil
   diese den Zustand ändern (`filtersd.cpp:1385-1388`)
4. Skip Rest, Copy To, Transfer To, Junk

Das Verschieben kommt also immer zuletzt — sinnvoll, weil die Nachricht
danach in einem anderen Postfach liegt.

---

## Der Filterbericht

*Tools → Filter Report* (`EudoraRes.rc:5790`).

> **Der Filterbericht bleibt in dieser Fassung leer — Befund E-71, offen.**
> Am 10.09.2026 an Paket 1.0.42 gemessen, nachdem die Filter nachweislich
> griffen: *„filter report fenster ist leer: kommt nichts an."* Der Rest
> dieses Abschnitts beschreibt, was **vorgesehen** ist, nicht, was Sie
> beobachten werden.
>
> Belegt ist, dass der Lauf trifft: im Protokoll steht `E-64 Match=1` und
> unmittelbar danach die Zeile `Filter "…" matches "…"` auf Protokollkanal
> 1024 — dem Kanal des Berichts. Es scheitert also **nach** dem Vermerken,
> vermutlich in `CFilterActions::EndFiltering`, wo `m_NotifyReportList`
> abgearbeitet und über `CFilterReportView::GetFilterReportView()` das
> Fenster gesucht wird; findet es keines, verfällt die Liste.
>
> Auf Gregors Wunsch zurückgestellt: *„kann aber als ToDo für die nächste
> version aufgeschrieben werden."*

**Vorgesehen ist:** der Bericht bekommt einen Eintrag, wenn eine Regel eine
Nachricht **verschoben** hat und entweder

* die Regel selbst *Notify User → In Report* eingestellt hat, oder
* die Einstellung `FilterReport` gesetzt ist — *Options → Getting Attention →
  Generate filter report* (`EudoraRes.rc:1922`, eingebaute Vorgabe **0**,
  `EudoraRes.rc:10287`).

Belegt in `filtersd.cpp:1584-1588`. Das Fenster öffnet sich von selbst,
sobald etwas darin steht (`filtersd.cpp:3769-3771`).

**Was der Bericht nicht zeigt:** Regeln, die nur eine Marke gesetzt, nur
gedruckt oder nur weitergeleitet haben. Die Bedingung `bDidMoveAction`
verlangt ein Verschieben oder Kopieren (`filtersd.cpp:1584`).

**Berichtigung einer früheren Einstufung.** Hier stand, ein leerer Bericht
sei *„kein eigener Fehler, sondern Folge von E-72"* — ein Filter ohne
Merkmale sei für keinen Lauf zuständig und habe darum nichts zu berichten.
Diese Begründung ist widerlegt: E-72 ist behoben, die Filter greifen (von
Gregor an 1.0.42 bestätigt), und der Bericht bleibt trotzdem leer. **E-71 ist
ein eigener, offener Befund.**

---

## Wo die Filter gespeichert sind

`Filters.pce` im Mailverzeichnis (`filtersd.cpp:2101`, Dateiname
`EudoraRes.rc:9705`). Geschrieben wird zuerst `Filters.tmp` im
Temp-Verzeichnis, dann umbenannt (`filtersd.cpp:3259`, `:3464`).

Es ist eine reine Textdatei, eine Angabe je Zeile. Aufbau
(`CFiltersDoc::Write`, `filtersd.cpp:3207-3466`, gelesen in `:2709-…`):

```
3
rule From:newsletter@beispiel.de
transfer Newsletter.mbx
stop 
incoming
manual
header From:
verb contains
value newsletter@beispiel.de
conjunction ignore
header 
verb contains
value 
```

* **Erste Zeile der Datei:** die Formatnummer, zurzeit `3`
  (`filtersd.h:305`, geschrieben in `filtersd.cpp:3263`). Eine ältere Nummer
  löst beim Laden die Rückfrage *Filter Update* aus
  (`filtersd.cpp:3161`, `EudoraRes.rc:2457-2470`).
* **`rule <Name>`** eröffnet eine Regel (`EudoraRes.rc:9699`).
* Danach folgen die **Aktionen**, in der Reihenfolge der fünf Plätze:
  `transfer ` · `copyInstead ` · `junk ` · `stop ` · `label <n>` ·
  `priority ` · `status ` · `subject ` · `sound ` · `speak ` · `open ` ·
  `print ` · `notifyUser ` · `notifyApp ` · `forward ` · `redirect ` ·
  `reply ` · `serverOpt ` · `personality ` · `none`
  (`EudoraRes.rc:10542-10577`). `stop` ist *Skip Rest*. Die Schlüsselwörter
  tragen in den Ressourcen ein **abschließendes Leerzeichen** und stehen so
  auch in der Datei.
* Dann die **Zeitpunkte**: `incoming`, `outgoing`, `manual` — nur die
  angekreuzten stehen da (`filtersd.cpp:3416-3418`).
* Dann **zweimal** je ein Block `header` / `verb` / `value`, dazwischen
  `conjunction` (`filtersd.cpp:3421-3461`). Der zweite Block steht auch
  dann da, wenn er leer ist.
* Die Sonderköpfe stehen in der Datei mit Guillemets, etwa `«Any Header»`
  (`EudoraRes.rc:9739-9743`).

Es gibt **keine Leerzeile zwischen zwei Regeln** — die nächste Regel beginnt
unmittelbar mit `rule `.

Die Datei enthält **keine Sicherung**. Wer daran von Hand arbeitet, tut es
bei geschlossenem Eudora und mit einer Kopie daneben.

---

## Junk: die Werte, die Schwelle, und was hier davon übrig ist

### Wie die Punktzahl entsteht

Jede Nachricht trägt eine **Junk-Punktzahl**. Sie wird als ein Byte in der
Nachrichtenübersicht gehalten (`summary.h:386`, `unsigned char`); die
Oberfläche arbeitet mit **0 bis 100** — der Schieberegler ist mit `0`, `50`
und `100` beschriftet (`EudoraRes.rc:4217-4219`), und die Eingabe für die
Handvergabe wird auf 0…100 geklemmt (`settings.cpp:1256-1268`). Eine
`SetRange`-Anweisung für den Regler steht nicht im Quelltext; es bleibt beim
Windows-Standardbereich 0…100.

Vergeben wird die Punktzahl **nicht von Eudora selbst**, sondern von
Zusatzmodulen. Beim Eintreffen einer Nachricht ruft `pop.cpp:397`
`CallJunkTranslators` mit `EMSFJUNK_SCORE_ON_ARRIVAL`; die Funktion geht die
Liste der geladenen Junk-Module durch und übernimmt die **höchste** der
zurückgegebenen Bewertungen (`Trnslate.cpp:5046-5048`, zurückgeschrieben in
`:5067`). **Ist kein Modul geladen, bleibt die Punktzahl 0** — die Funktion
kehrt sofort zurück (`Trnslate.cpp:4952-4957`), und im Freigabebau ohne jede
Meldung, weil das dortige `ASSERT(0)` nichts tut.

### Die Schwelle

`MinScoreToJunk`, eingebaute Vorgabe **50** (`EudoraRes.rc:8375`).
Einzustellen unter *Tools → Options → Junk Mail* am Schieberegler
*„Consider mail junk if score is at least"* (`EudoraRes.rc:4213-4220`,
`settings.cpp:2238-2247`).

Erreicht oder überschreitet eine Nachricht diese Zahl, geschieht beim Abruf
(`CJunkMail::ProcessOne`, `JunkMail.cpp:441-467`):

1. Sie wird auf dem Server zum Löschen vorgemerkt, **wenn**
   `DeleteFetchedJunk` gesetzt ist (`JunkMail.cpp:453-457`).
2. Ihr Datum wird auf den Eingangszeitpunkt gesetzt, wenn `IgnoreJunkDate`
   gesetzt ist (`JunkMail.cpp:460-466`).
3. Sie wandert aus *In* in das Postfach *Junk* (`JunkMail.cpp:468`).

Dieser ganze Durchgang findet nur statt, wenn `UseJunkMailbox` gesetzt ist —
eingebaute Vorgabe **0**, also aus (`EudoraRes.rc:7739`, geprüft in
`pop.cpp:152-155`). Wer den Schieberegler unter 25 stellt, bekommt eine
Warnung (`EudoraRes.rc:4484-4492`).

**Der Junk-Durchgang läuft vor dem Filterlauf** (`pop.cpp:152-158`). Was nach
*Junk* verschoben wurde, sehen Ihre Filter nicht mehr.

### Was die 100 ist

**Die 100 ist die Punktzahl, die Eudora vergibt, wenn *Sie* eine Nachricht
von Hand als Junk markieren.** Der Schlüssel heißt `ManualJunkScore`,
eingebaute Vorgabe **100** (`EudoraRes.rc:8380`); benutzt in
`CJunkMail::DeclareJunk` (`JunkMail.cpp:681-684`) und in der Filteraktion
*Junk* (`filtersd.cpp:1821-1825`). Das Gegenstück heißt
`ManualNotJunkScore`, eingebaute Vorgabe **0** (`EudoraRes.rc:8381`,
benutzt in `JunkMail.cpp:716`).

Einzustellen sind beide unter *Tools → Options → Junk Mail Extras*, Feld
*„Junking a message assigns it a score of"* (`EudoraRes.rc:4255-4257`).
Werte außerhalb 0…100 werden beim Übernehmen zurechtgestutzt
(`settings.cpp:1256-1268`). Eine `0` bedeutet dabei nicht „Punktzahl 0",
sondern **„Punktzahl unverändert lassen"** (`JunkMail.cpp:682`,
`filtersd.cpp:1822`).

Von Hand markieren Sie über *Message → Junk* beziehungsweise *Not Junk*
(`EudoraRes.rc:5756-5757`). Neu bewerten lassen können Sie über
*Recalculate Junk Score* im Kontextmenü (`EudoraRes.rc:5893`,
`JunkMail.cpp:502`).

### Warum die Junk-Bewertung hier nicht arbeitet

Die beiden mitgelieferten Module **`SpamWatch.dll`** und
**`SpamHeaders.dll`** (in `Eudora71/Bin/Release/Plugins/`) brauchen
`MFC71.DLL`, `MSVCP71.dll` und `MSVCR71.dll` — nachgemessen an den
Importtabellen der beiden Dateien. Diese drei Bibliotheken von 2003 hat
Microsoft nie zur Weitergabe freigegeben; sie liegen nicht im Paket. Das ist
Befund **E-47**.

`LoadLibrary` schlägt in diesem Fall fehl, und `Trnslate.cpp:3150-3157`
überspringt das Modul **ohne sichtbare Meldung** — die einzige Ausgabe ist
ein `TRACE`, das es im Freigabebau nicht gibt.

**Praktisch heißt das:**

* Jede eingehende Nachricht behält die Punktzahl **0**.
* `MinScoreToJunk` greift damit bei keinem Wert ab 1 — und bei **0** greift
  er bei **jeder** Nachricht, weil verglichen wird „Punktzahl ≥ Schwelle"
  (`JunkMail.cpp:441`). Eine 0 ist also kein Aus, sondern das Gegenteil.
* Das Postfach *Junk* füllt sich nur noch durch das, was Sie selbst
  markieren (Punktzahl dann 100) oder was eine Filteraktion *Junk* dorthin
  schiebt.
* Eine Filterbedingung `«Junk Score» is greater than N` ist für jedes
  N ≥ 0 falsch, solange die Nachricht nicht von Hand gejunkt wurde.
* Umgekehrt trifft `«Junk Score» is less than N` für jedes N ≥ 1 **jede**
  Nachricht. Wer so eine Regel mit *Transfer To* verbindet, verschiebt sein
  ganzes Postfach.

Aus demselben Grund steht `DeleteFetchedJunk` in dieser Portierung auf **0**,
abweichend von der eingebauten Vorgabe **1** (Befund **E-74**,
`tools/DEudora.ini`). Einer Einstufung, die auf einem nicht geladenen Modul
beruht, darf man keine Post zum Löschen anvertrauen.

> **Achtung bei der Regel `«Junk Score» is less than N`.** Sie wird durch
> bloßes Anschauen im Filterfenster unbrauchbar und verwandelt sich in
> `matches regexp N` (Befund **E-67**, offen).

---

## Die Einstellungen in der `Eudora.ini`

Alle Schlüssel stehen im Abschnitt `[Settings]` der `Eudora.ini` **im
Mailverzeichnis**. Die Spalte *eingebaute Vorgabe* ist der Wert, den Eudora
ohne Eintrag benutzt; er steht in `Eudora71/Eudora/EudoraRes.rc` im Format
`IDS_INI_XXX "SchlüsselName\nVorgabe"`.

Wo diese Portierung abweicht, steht das dabei — die Begründungen stehen in
[README.md](README.md), Abschnitt *Einstellungen, die es nur hier gibt*.

### Filter

| Schlüssel | Vorgabe | Fundstelle | was er tut |
|---|---|---|---|
| `FilterIncomingMail` | `1` | `EudoraRes.rc:8131` | Eingangsfilter überhaupt laufen lassen |
| `FilterReport` | `0` | `EudoraRes.rc:10287` | Filterbericht führen (*Getting Attention*) |
| `FilterMayDeleteFromServer` | `0` | `filtersd.cpp:1219` | **gibt es nur hier.** Erlaubt der Aktion *Server Options → Delete*, auf dem Server zu löschen |
| `FilterTransferName` | `0` | `EudoraRes.rc:10004` | wie das Zielpostfach auf der Schaltfläche steht: `0` Name, `1` Ordnerpfad, `2` Dateipfad (`controls.cpp:337-352`) |
| `WarnBadFilterDir` | `1` | `EudoraRes.rc:7839` | warnen, wenn *Make Filter* ein Postfach außerhalb des Mailverzeichnisses anlegen soll (`MakeFilter.cpp:504`) |
| `FilterFromFolder` | *leer* | `EudoraRes.rc:7840` | zuletzt benutzter Ordner für *Make Filter* nach **From** (`MakeFilter.cpp:278`) |
| `FilterRecipFolder` | *leer* | `EudoraRes.rc:7841` | dasselbe für **Any Recipient** |
| `FilterSubjectFolder` | *leer* | `EudoraRes.rc:7842` | dasselbe für **Subject** |
| `FiltersWindowPosition` | `1,2,580,480` | `EudoraRes.rc:7570` | Lage des freischwebenden Filterfensters |
| `FiltersWindowSplitterPosition` | `140` | `EudoraRes.rc:7583` | Lage des Trennbalkens im Filterfenster |
| `UseMyFilterWindowPosition` | `0` | `EudoraRes.rc:7589` | die gespeicherte Lage benutzen |
| `FilterReportWindowPosition` | `10,10,500,300` | `EudoraRes.rc:7572` | Lage des Berichtsfensters |
| `ImapFilterIncoming` | `1` | `EudoraRes.rc:8182` | Eingangsfilter für IMAP-Konten (in dieser Portierung ungetestet) |
| `ImapFiltersWindowPosition` | `1,2,580,480` | `EudoraRes.rc:7587` | Lage des IMAP-Filterfensters |
| `CtrlJMapping` | `0` | `EudoraRes.rc:8734` | Belegung von Strg+J: `0` unentschieden, `1` *Junk*, `2` *Filter Messages* (`JunkMail.h:61-63`) |

### Junk

| Schlüssel | Vorgabe | Fundstelle | was er tut |
|---|---|---|---|
| `MinScoreToJunk` | `50` | `EudoraRes.rc:8375` | ab dieser Punktzahl gilt eine Nachricht als Junk (`JunkMail.cpp:441`) |
| `ManualJunkScore` | `100` | `EudoraRes.rc:8380` | Punktzahl beim Markieren von Hand; `0` heißt „unverändert lassen" (`JunkMail.cpp:681-684`) |
| `ManualNotJunkScore` | `0` | `EudoraRes.rc:8381` | Punktzahl bei *Not Junk* (`JunkMail.cpp:716`) |
| `UseJunkMailbox` | `0` | `EudoraRes.rc:7739` | Junk beim Abruf automatisch nach *Junk* verschieben (`pop.cpp:152-155`) |
| `DeleteFetchedJunk` | `1` | `EudoraRes.rc:7693` | **hier auf `0`.** Als Junk Eingestuftes zusätzlich auf dem Server löschen (`JunkMail.cpp:453-457`) |
| `DeletePartiallyFetchedJunk` | `0` | `EudoraRes.rc:7694` | dasselbe für nur teilweise abgeholte Nachrichten |
| `AddressBookIsWhitelist` | `0` | `EudoraRes.rc:7695` | Absender aus dem Adressbuch sind nie Junk (`JunkMail.cpp:428-437`) |
| `NonJunkToAddressBook` | `1` | `EudoraRes.rc:7696` | Absender von *Not Junk* ins Adressbuch aufnehmen |
| `NonJunkAddressBook` | *leer* | `EudoraRes.rc:7697` | in welches Adressbuch |
| `JunkNeverUnread` | `0` | `EudoraRes.rc:8374` | *Junk* nie als ungelesen anzeigen |
| `IgnoreJunkDate` | `1` | `EudoraRes.rc:8383` | Datum der Junk-Nachricht auf den Eingangszeitpunkt setzen |
| `AgeJunkOff` | `1` | `EudoraRes.rc:8376` | alte Junk-Nachrichten selbsttätig entfernen |
| `AgeJunkOffDays` | `30` | `EudoraRes.rc:8377` | ab welchem Alter in Tagen (`tocdoc.cpp:4508`) |
| `MinAgeOffScore` | `0` | `EudoraRes.rc:8379` | nur Junk ab dieser Punktzahl entfernen |
| `WarnBeforeAging` | `1` | `EudoraRes.rc:8378` | vorher fragen |
| `DaysBetweenJunkAgeOff` | `1` | `EudoraRes.rc:7691` | wie oft aufgeräumt wird |
| `LastAgeOff` | `0` | `EudoraRes.rc:7692` | wann zuletzt aufgeräumt wurde (schreibt Eudora selbst) |
| `JunkTrimMbox` | `Trash` | `EudoraRes.rc:8382` | wohin das Entfernte wandert |
| `AlwaysEnableJunkMenus` | `0` | `EudoraRes.rc:8373` | *Junk* / *Not Junk* auch dort anbieten, wo sie sonst grau sind (`msgdoc.cpp:848`, `:872`) |
| `MailboxShowJunk` | `0` | `EudoraRes.rc:8778` | Spalte mit der Junk-Punktzahl in jedem Postfach zeigen (`tocview.cpp:714`) |
| `AskedAboutJunk` | `0` | `EudoraRes.rc:7740` | ob die Einstiegsfrage schon gestellt wurde |
| `JunkMailboxName` | `Junk` | `EudoraRes.rc:7698` | Name des Junk-Postfachs bei IMAP |
| `ImapScoreJunk` | `1` | `EudoraRes.rc:8095` | Junk-Bewertung auf IMAP-Konten |

Die Seiten *Junk Mail* und *Junk Mail Extras* unter *Tools → Options*
(`EudoraRes.rc:4208-4268`) erscheinen nur im vollen Funktionsumfang
(`settings.cpp:390-399`). Dieser Bau ist mit `BUILD_BOX_OR_SITE_R_VERSION`
übersetzt (`Eudora71/Eudora/Eudora.vcxproj:132`), womit der Standardmodus
*Paid* ist (`QCSharewareManager.h:54-59`) — die Seiten sind also da.

---

## Was überrascht

Verhalten, das im Quelltext eindeutig belegt ist und trotzdem niemand
erwartet.

### Bei IMAP fragt ein Filterlauf nach dem Kennwort

Wer ein **IMAP**-Postfach markiert und *Filter Messages* auslöst, wird nach
dem Kennwort gefragt — auch dann, wenn er nur lokal sortieren will.

**Das ist kein Fehler dieser Portierung**, sondern Verhalten des Originals,
und der Autor hat es selbst als unfertig gekennzeichnet
(`EuImap/src/ImapMailbox.cpp:5388`):

> *„In the case of manual filtering forcing us to always be online might
> sometimes be overly harsh. For example, if all filters do things like
> labelling that need no connection then we shouldn't force the user online.
> This is a first pass … We'll deal with this properly then."*

**Der sachliche Grund:** bei IMAP liegt die Nachricht auf dem Server. Ein
Filter, der sie verschiebt, muss dort ein `UID COPY` und ein
`UID STORE +FLAGS (\Deleted)` schicken — **Verschieben ist bei IMAP immer
auch Löschen.** Ohne Verbindung geht das nicht. Ein Filter, der nur ein
Etikett setzt oder einen Ton abspielt, bräuchte sie dagegen nicht; genau
darauf zielt der Kommentar.

Unterschieden wird das nicht: `CImapMailbox::FilterMessages` ruft
`GetConnectionState(bDontAllowOffline)` — der Parameter heißt wörtlich
*offline nicht erlauben* — und danach `OpenMailbox(TRUE)`.

**Der Schalter `IMAPAllowOffline` hilft hier nicht.** Er steht in der
`Eudora.ini` mit eingebauter Vorgabe `1` (`EudoraRes.rc:7191`) und erlaubt
IMAP-Aktionen im Offline-Betrieb — beim Filtern wird er übergangen, weil der
Aufruf ausdrücklich `bDontAllowOffline` mitgibt.

**Was hilft:** die Verbindung einmal aufbauen und das Kennwort speichern
lassen, oder bei POP filtern. Ein Filterlauf über ein **POP**-Postfach
arbeitet rein lokal und fragt nichts.

**Ein leeres Suchfeld trifft alles.** *„enthält nichts"* ist für jede
Nachricht wahr. Verbunden mit *Transfer To* verschiebt so eine Regel das
ganze Postfach. Diese Portierung fängt es an zwei Stellen ab: ein leerer
Wert trifft nie (`filtersd.cpp:711-713`), und das Filterfenster schreibt nur
noch den Filter zurück, den es auch wirklich geladen hat
(`filtersv.cpp:1430-1435`) — vorher schrieb es beim Wegklicken den leeren
Zustand seiner unerreichbaren rechten Hälfte in die Regel (**E-72**). Im
Original war das der Weg zu Befund **E-64**.

**Die fünf Aktionen laufen nicht in der Reihenfolge, in der sie dastehen.**
Siehe [Innerhalb einer Regel](#innerhalb-einer-regel). *Make Status* läuft
immer nach *Reply*, *Transfer To* immer zuletzt.

**Ein `&` in „Make Subject" ist ein Platzhalter.** Der Text `Wichtig: &`
macht aus `Rechnung` den Betreff `Wichtig: Rechnung`
(`filtersd.cpp:1318-1329`). Wer ein echtes kaufmännisches Und im Betreff
haben will, hat kein Mittel dafür — der Quelltext kennt keine
Fluchtsequenz.

**„Skip Rest" bricht auch die anderen beiden Listen ab.** Nicht nur die
eigene (`filtersd.cpp:3644-3650`).

**Der Filterbericht kennt nur Verschiebungen.** Eine Regel, die nur eine
Farbmarke setzt oder nur weiterleitet, taucht dort nie auf
(`filtersd.cpp:1584`).

**Junk läuft vor den Filtern.** Was in *Junk* landet, wird nicht mehr
gefiltert (`pop.cpp:152-158`). Genau so steht es auch im Einstiegsdialog des
Originals: *„Your filters are not run on it"* (`EudoraRes.rc:3755`).

**Ein fehlgeschlagenes Zusatzmodul meldet sich nicht.** `LoadLibrary`
scheitert, Eudora macht mit dem nächsten weiter (`Trnslate.cpp:3150-3157`).
Sie merken es nur daran, dass alle Punktzahlen 0 bleiben.

**`ManualJunkScore = 0` heißt nicht „Punktzahl 0".** Es heißt „Punktzahl
nicht anfassen" (`JunkMail.cpp:681-684`). Wer wirklich 0 will, benutzt
*Not Junk*.

**Der Filter läuft von unten nach oben durch die Auswahl.** Beim manuellen
Lauf geht Eudora vom höchsten Listenplatz abwärts, damit Verschiebungen die
Indizes der noch nicht behandelten Nachrichten nicht verschieben
(`TocFrame.cpp:2392-2396`).

---

## Was hier zurzeit noch nicht stimmt

Die folgenden Befunde betreffen die Filter und sind **offen**. Der
vollständige Stand steht in [BEFUNDE.md](BEFUNDE.md).

| Befund | was passiert |
|---|---|
| **E-67** | eine Regel `«Junk Score» is less than N` wird durch bloßes Anschauen im Filterfenster zu `matches regexp N` |
| **E-68**, halb | Zielpostfächer können beim Schreiben von `Filters.pce` verlorengehen (`copyInstead` wird anders geschrieben als gelesen). **Die andere Hälfte ist behoben:** `CFiltersDoc::Read` las ab der sechsten Aktion je Regel über den Puffer hinaus — und traf dabei nicht nur Zahlen, sondern `CString`-Felder, was Speicher zerstört. Seit 10.09.2026 gibt es eine Grenze; überzählige Zeilen werden verworfen und protokolliert |
| **E-69** | `CFiltersDoc::FilterMsg` kann den Lauf im Freigabebau lautlos abbrechen und trotzdem Erfolg melden |
| **E-71** | **der Filterbericht bleibt leer** — von Gregor am 10.09.2026 an 1.0.42 gemessen, nachdem die Filter nachweislich griffen. Auf seinen Wunsch zurückgestellt. Siehe [Der Filterbericht](#der-filterbericht) |
| **E-76** | das freischwebende Filterfenster lässt sich nicht nach unten vergrößern |
| **E-47** | `SpamWatch` und `SpamHeaders` laden nicht — siehe oben. **Praktische Folge für die Filter:** jede eingehende Nachricht behält die Junk-Punktzahl 0, eine Regel auf *Junk Score* trifft also nie |

Behoben, aber gut zu wissen, weil sie erklären, warum ältere `Filters.pce`
beschädigt sein können: **E-64**, **E-72**, **E-73**, **E-74**, **E-75**.

---

## Was nicht belegt werden konnte

* Der Wertebereich des Junk-Schiebereglers steht **nicht** im Quelltext.
  `settings.cpp:2238-2247` setzt nur Teilstriche bei 25, 50 und 75 und die
  Position; ein `SetRange` fehlt. Die Angabe „0 bis 100" stützt sich auf die
  Beschriftungen im Dialog (`EudoraRes.rc:4217-4219`) und auf die
  Begrenzung der Handeingabe (`settings.cpp:1256-1268`), nicht auf eine
  Bereichsangabe im Code.
* Das genaue Verfahren, nach dem `SpamWatch` und `SpamHeaders` ihre Punkte
  vergeben, steht in den Modulen selbst und liegt nicht als Quelltext vor.
  Nachweisbar ist nur, wie Eudora ihre Antwort verarbeitet
  (`Trnslate.cpp:4942-5010`).
* Ob und wie sich Vor- und Nachlauffilter (`*.pre`, `*.pst`) ohne
  Zusatzmodul sinnvoll von Hand anlegen lassen, ist nicht geprüft. Belegt ist
  nur, dass Eudora sie liest (`filtersd.cpp:2566-2583`) und nie schreibt.
* Die IMAP-Filterung ist im Quelltext vorhanden (`CFilter::ImapAction`,
  `filtersd.cpp:1679`), in dieser Portierung aber nicht getestet.
