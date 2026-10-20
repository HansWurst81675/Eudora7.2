# PRÜFER-40 — 7.2.0.113: die Behebung hält, die veröffentlichten Papiere nicht

Gegenstand: Befund [**E-131**](../BEFUNDE.md#e-131), Zweig `e-131-leistenposition`
(Merge `1f31aadb`, PR #116), dazu der Veröffentlichungsweg bis `b6a40262`
(PR #118). Quellstand **7.2.0.113 / 1.0.113**.

| Commit | Inhalt |
|---|---|
| `0f4b2b1a` | `E131PositionIstBrauchbar` + `E131LeistenpositionenBereinigen`, Aufruf am Ende von `CMainFrame::SaveBarState`; fünf neue Tests; [LEKTOR-43](LEKTOR-43.md#lektor-43) eingearbeitet; Fassungssprung |
| `d0ce86ae` | `tools/ZWEIGE.md` |
| `cda80195` | Release vorbereitet, ZIP-Prüfsumme, `ZIEL.md` |
| `d64247cb`, `fe49a6ab` | Release-Notizen berichtigt, Veröffentlichungsstand nachgezogen |

**Wichtig für die Einordnung dieses Berichts:** `v1.0.113` ist **nicht mehr
offen** — die Fassung ist seit **20.10.2026, 13:01:36 UTC** auf GitHub
veröffentlicht (Marke `ac094f15`, ZIP 9 378 205 Byte, SHA-256 `0d1d4bf4…f4772`,
kein Entwurf). Mein Auftrag lautete, über das Hinausgehen zu urteilen; das ist
überholt. Ich urteile deshalb darüber, ob die Fassung **draußen bleiben darf**
und was **jetzt** nachgezogen werden muss.

**Wie geprüft.** Am Quelltext gelesen, nichts mit Oberfläche gestartet. Eigene
Messungen am lebenden Windows über P/Invoke gegen `kernel32`: das Verhalten von
`GetPrivateProfileInt` bei `-2147483648`, von `GetPrivateProfileSectionNames` an
der Pufferkante, und die Zeit, die die Nachbehandlung kostet. Dazu gelesen: die
MFC-Quellen des hier eingebauten Werkzeugkastens (`dockstat.cpp`,
`dockcont.cpp`, `afxmem.cpp` unter `atlmfc/src/mfc`), die echte `Eudora.ini` und
deren `eudora.log` im Prüfverzeichnis (nur lesend), der **veröffentlichte** Text
(`gh release view v1.0.113 --json body`) gegen die Datei im Repo, und die
Entstehungsgeschichte beider aus `git log`. Skripte im Kratzverzeichnis unter
`scratchpad/p40`.

---

## Urteil

**Der Code darf draußen bleiben. Der veröffentlichte Text muss sofort
nachgezogen werden, und die Veröffentlichungs-Buchführung ist beim Nachziehen
kaputtgegangen.**

Die Behebung selbst ist in Ordnung und war die Mühe wert. Sie trifft genau den
Wert, den sie treffen will ([K6](#k6), gemessen — das war die wichtigste Frage
des Auftrags, und sie geht gut aus), sie zerstört keine gültige Anordnung
([K9](#k9)), sie kostet 18 ms ([K10](#k10)), und für unseren eigenen Anwender
ändert sich sichtbar **nichts** ([K11](#k11), gemessen). Ich habe keinen
Rückschritt gefunden. Was sie **nicht** ist: ein Nachweis, dass der gemeldete
Absturz daher kommt ([K1](#k1)).

Was jetzt hinein muss, steht in dem, was der Anwender gerade liest:

> **[K2](#k2): Der veröffentlichte Text zu `v1.0.113` trägt drei kopflose
> Stellen — zwei davon sind genau die, die [LEKTOR-43/L-43.1](LEKTOR-43.md#l-43.1)
> Stunden vorher an `v1.0.112` repariert hatte, und die dritte ist beim
> Reparieren der Reparatur entstanden.** Gemessen am lebenden Release, nicht an
> der Datei: `gh release view v1.0.113 --json body` ist bis auf die Leerzeile am
> Ende Zeichen für Zeichen die Datei `Releases/1.0.113/RELEASE-NOTIZEN.md` auf
> `origin/main`. Alle drei stehen öffentlich.

> **[K15](#k15): Die Buchführung über das, was veröffentlicht ist, wurde durch
> eine blinde Textersetzung `1.0.112` → `1.0.113` „berichtigt".** `fe49a6ab` hat
> damit die Schranke `pruefe-release-buchfuehrung.pl` zufriedengestellt und
> dabei den Eintrag zu **`v1.0.112` überschrieben**. Jetzt steht in
> `Releases/PAKETE.md`, `WEITERMACHEN.md` und `README.md`, `v1.0.113` sei am
> 20.10.2026 um **11:55:10 UTC** aus Quellstand **7.2.0.112** mit der Marke auf
> **`f87a4a74` (PR #113)** und dem ZIP `Eudora72-1.0.112-release.zip`, SHA-256
> `0406c108…` erschienen. **Jede einzelne dieser Angaben gehört zu `v1.0.112`.**
> Die echten Werte von `v1.0.113` stehen nirgends, und `v1.0.112` ist als
> Veröffentlichung gelöscht.

### Funde

| Fund | Schwere | Stand |
|---|---|---|
| <a id="k1"></a>**K1** Die Ursachenkette *INT_MIN → Absturz in `MFC71.DLL`* ist **nicht belegt**. `-2147483648` ist `CW_USEDEFAULT`, das MFC selbst in `CDockContext::CDockContext` setzt, und MFC fängt es an seinem einzigen Leseort wieder ab. `ECX=0` passt dagegen genau auf einen anderen Weg | **hoch für die Behauptung, nicht für den Code.** Die Behebung ist harmlos, der Befund ist nicht abgeschlossen | **belegt am Quelltext** (MFC 14: `dockcont.cpp:49`, `:392-397`); dass MFC 7.1 an der Nachbarstelle ungeprüft zugreift, ist **Vermutung** |
| <a id="k2"></a>**K2** Drei kopflose Stellen im **veröffentlichten** Text; zwei davon sind [L-43.1](LEKTOR-43.md#l-43.1) Nr. 1 und 2, wieder eingeschleppt, die dritte neu aus `fe49a6ab` | **hoch.** Der Anwender liest es jetzt | **gemessen** am Release-Text, per `diff` und `git log` |
| <a id="k3"></a>**K3** *(zurückgezogen)* Beim Stand `1f31aadb` nannten die Notizen die Behebung nicht und führten [E-131](../BEFUNDE.md#e-131) als offenen Fehler mit *„noch nicht nachgestellt"*. **In `d64247cb` behoben** | — | **gemessen**, erledigt vor meinem Bericht |
| <a id="k4"></a>**K4** `CHANGELOG.md:16` führt [E-131](../BEFUNDE.md#e-131) in *Noch offen (Stand 20.10.2026)* mit *„Offen … von uns noch nicht nachgestellt"*, während `CHANGELOG.md:85` und `BEFUNDE.md:300` *„Behoben in 7.2.0.113"* sagen. `doku-pruefen.pl` meldet dazu *„Kein Widerspruch gefunden"* | **mittel**, dazu eine blinde Schranke | **gemessen** an `origin/main` |
| <a id="k5"></a>**K5** Kein Bau, der sich als **7.2.0.113** meldet, ist je gelaufen. Die E-131-Messung stammt aus einem Bau, der im Protokoll *Version 7.2.0.112* sagt; Gregors Verzeichnis zu 1.0.113 enthält **keine** `eudora.log`. Die frühere Behauptung *„an Paket 1.0.113 bestätigt"* ist in `fe49a6ab` entfernt worden — und hat dabei [K2](#k2) Nr. 3 erzeugt | mittel, Prüflücke | **gemessen** (`eudora.log` Z. 3/64, `tools/TESTLAEUFE.md`, fehlende Logdatei) |
| <a id="k6"></a>**K6** `GetPrivateProfileInt` liefert `-2147483648` **richtig** als negativen Wert — die Behebung prüft, was sie zu prüfen meint. Aber `INT_MAX` als Merkzeichen ist angreifbar, und bei nur **einem** fehlenden Schlüssel legt die Funktion den anderen an, entgegen ihrem eigenen Kommentar | gering, heute nicht auslösbar | **gemessen** (P/Invoke, 14 Abfragen) |
| <a id="k7"></a>**K7** Bei mehr als rund 32 KB Abschnittsnamen kehrt die Funktion **wortlos** zurück und tut **nie** etwas; der Kommentar verspricht das Gegenteil. Dazu ein Fehlalarm bei genau passendem Puffer | mittel, unwahrscheinlich, aber stumm | **gemessen**, Pufferkante exakt bestimmt |
| <a id="k8"></a>**K8** `new char[32768]` ohne `std::nothrow`: MFC setzt `AfxNewHandler`, `new` liefert nie NULL — `if (!pNamen) return;` ist **toter Code**; und der Puffer ist gegen eine werfende `CString::Format` nicht geschützt | gering | **belegt am Quelltext** (`afxmem.cpp:256-264`, `afxstate.cpp:244`) |
| <a id="k9"></a>**K9** Die Regel lässt **eine ganze Bildschirmbreite** Spiel, nicht 100 Pixel. Kommentar und Test (3) behaupten etwas anderes. Richtung sicher: zu lax, nicht zu streng | gering, aber die Begründung im Code ist falsch | **belegt am Quelltext**, zweiter Schirm links und oben durchgerechnet |
| <a id="k10"></a>**K10** Aufrufort richtig — drei Aufrufstellen, alle mit `"ToolBar"`, Nachbehandlung nach dem Notweg. Kosten gemessen: **18 ms** bei 7 KB, 95–112 ms bei 72–758 KB INI | kein Fund | **gemessen** |
| <a id="k11"></a>**K11** Unser Ersatzwert wird von MFC **nicht übernommen**: `berichtigt=5` bei **beiden** Läufen. Deshalb bleibt `m_ptMRUFloatPos` im Speicher auf `CW_USEDEFAULT`, und der Anwender sieht beim Lösen einer Leiste **keinen** Unterschied | kein Fund — und die Entwarnung für die einzige denkbare Regression | **gemessen** (`eudora.log`, zwei Läufe) |
| <a id="k12"></a>**K12** Die Abschnittsauswahl trifft heute alles (echte INI nachgezählt: 18 Abschnitte, 5 mit `MRUFloat*`, alle unter `ToolBar-`; `WazooBars` und `ToolBar-ToolBarManager` tragen keine Schwebeposition). Aber `strncmp` ist groß/klein-empfindlich, INI-Abschnitte sind es nicht, und der Präfix ist fest verdrahtet statt aus `lpszProfileName` | gering | **gemessen** an der echten `Eudora.ini` im Prüfverzeichnis |
| <a id="k13"></a>**K13** `Extract.ps1`: *Region Q* zweimal vergeben ([E-118](../BEFUNDE.md#e-118) und [E-131](../BEFUNDE.md#e-131)); `O` und `P` ebenfalls | sehr gering, Altbestand | **gemessen** |
| <a id="k14"></a>**K14** Der Leseweg ist **nicht** durch `INT_MIN` bedroht — wohl aber durch `Docking=1` zu einer Leiste ohne Andockkontext: `CControlBar::SetBarInfo` greift nach einem `ASSERT` **ungeprüft** über `m_pDockContext`. Dieselbe Klasse wie der gemeldete Absturz, nirgends aufgeschrieben | mittel, nicht ausgelöst gesehen | **belegt am Quelltext** (`dockstat.cpp:600-608`) |
| <a id="k15"></a>**K15** Die Veröffentlichungs-Buchführung wurde durch eine blinde Ersetzung `1.0.112` → `1.0.113` an die Schranke angepasst; `v1.0.112` ist als Veröffentlichung überschrieben, `v1.0.113` steht mit Zeit, Marke, PR, ZIP-Namen und Prüfsumme von `v1.0.112` da | **hoch** | **gemessen** gegen `gh release view` und `git ls-remote --tags` |

**Was sofort hinein muss: [K2](#k2) und [K15](#k15).** Beides betrifft, was
draußen steht. **[K4](#k4)** gehört in denselben Commit (eine Zeile im
CHANGELOG). **[K1](#k1)** muss nicht behoben, aber **umformuliert** werden.
Alles andere kann nach.

**Zurückgezogen:** [K3](#k3) — beim Stand, von dem aus mein Auftrag geschrieben
wurde, war der Fund richtig; `d64247cb` hat ihn vor meinem Bericht behoben. Ich
lasse ihn stehen, weil [K2](#k2) Nr. 3 daraus entstanden ist.

---

## K1 — die Ursache ist nicht die, die im Code steht

### Was `-2147483648` wirklich ist

Der Kommentar in `mainfrm.cpp:2749-2752` sagt, MFC führe die Schwebeposition in
`CDockContext::m_ptMRUFloatPos`, und *„wurde eine Leiste nie frei bewegt, steht
dort ein nie gesetzter Wert"*. Der Wert ist nicht „nie gesetzt". Er wird
ausdrücklich gesetzt:

```cpp
// atlmfc/src/mfc/dockcont.cpp:49, CDockContext::CDockContext
m_ptMRUFloatPos.x = CW_USEDEFAULT;
```

`CW_USEDEFAULT` ist `0x80000000`, also genau `INT_MIN`. Das ist kein Müll und
kein Fehler, sondern MFCs Merkzeichen für *„noch keine Position, nimm die
Vorgabe"*. `CDockState::SaveState` schreibt es mit `WriteProfileInt` heraus
(`dockstat.cpp:241-242`), und `CMainFrame::SaveBarState` formatiert den
Registry-`REG_DWORD` mit `"%d"` — daraus wird in der INI `-2147483648`.

### Warum MFC daran nicht stirbt

Es gibt im ganzen MFC-Baum genau **eine** Stelle, die den gespeicherten Wert
benutzt:

```cpp
// atlmfc/src/mfc/dockcont.cpp:392-397, CDockContext::ToggleDocking
CPoint ptFloat = m_ptMRUFloatPos;
if (ptFloat.x < 0 || ptFloat.y < 0)
{
    ptFloat = m_rectMRUDockPos.TopLeft();
    m_pBar->GetParent()->ClientToScreen(&ptFloat);
}
m_pDockSite->FloatControlBar(m_pBar, ptFloat, m_dwMRUFloatStyle);
```

`INT_MIN` ist kleiner als 0, der Zweig greift, der Wert wird **verworfen**. Er
wird nie als Zeiger benutzt und nie an `CreateWindowEx` durchgereicht.

### Was besser zu `ECX=0` passt

Der Melder nennt `EXCEPTION_ACCESS_VIOLATION` in `MFC71.DLL`, Ordinal 3952,
**`ECX=0`**. `ECX` trägt bei `__thiscall` den Objektzeiger. Ein Nullzeiger in
`ECX` heißt: ein Aufruf oder Feldzugriff auf ein Objekt, das es nicht gibt.
Genau das steht auf demselben Weg, eine Ebene über der Schwebeposition:

```cpp
// atlmfc/src/mfc/dockstat.cpp, CFrameWnd::SetDockState
pInfo->m_pBar = GetControlBar(pInfo->m_nBarID);
ASSERT(pInfo->m_pBar != NULL); //toolbar id's probably changed
```

Findet die fremde Fassung die Leistenkennung nicht, ist `m_pBar` **NULL** — und
`ASSERT` ist im Release nichts
([ASSERT ist im Release nichts](../Arbeitsweise/assert-ist-im-release-nichts.md)).
MFC 14 setzt hinter jeden folgenden Zugriff ein `if (pInfo->m_pBar != NULL)`;
**ob MFC 7.1 das auch tut, kann ich nicht nachsehen — diese Quelle liegt hier
nicht. Das ist der Vermutungsanteil des Funds.** Dieselbe Klasse steckt eine
Ebene tiefer auch in MFC 14 noch ungeschützt ([K14](#k14)).

Unsere INI schreibt dort hinein: `Bars=10` in `[ToolBar-Summary]` und zehn
Kennungen (`59393, 318, 319, 320, 59419, 59422, 59420, 59421, 59392, 1068`).
Die Nachstellung selbst sagt, dass **16 Abschnitte** dazukamen — nicht ein
Schlüssel.

### Was daraus folgt

Nicht: „die Behebung ist falsch." Sondern: **sie ist gegen den *Wert*
nachgestellt, nicht gegen das *Symptom*.** Niemand hat Hermes 7.1.0.9 mit der
berichtigten INI gestartet. Die veröffentlichten Notizen sagen das an einer
Stelle vorbildlich (*„Nicht geprüft: ob eine daneben installierte Hermes 7.1
danach wieder startet"*) und behaupten zwei Absätze darüber das Gegenteil:

> **Ursache:** in der gemeinsam benutzten `Eudora.ini` stand
> `MRUFloatXPos=-2147483648` … **Nachgestellt und behoben.**

Nachgestellt ist, dass **wir** den Wert schreiben. Dass **er** den Absturz
auslöst, ist die Vermutung des Melders, unverändert übernommen.

**Gegenvorschlag, drei Zeilen Text und kein Code:**

1. In den Release-Notizen und in `BEFUNDE.md` *„Ursache"* durch *„die
   auffälligste Abweichung"* ersetzen und dazuschreiben, dass `-2147483648`
   MFCs eigenes `CW_USEDEFAULT` ist, das MFC beim Lesen abfängt.
2. In [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102) den Melder
   nicht nur um den Starttest bitten, sondern um **seine `[ToolBar-Summary]` und
   die `BarID=`-Zeilen** vor und nach unserem Lauf. Das trennt die beiden
   Erklärungen in einer Minute.
3. [E-131](../BEFUNDE.md#e-131) bleibt offen, bis einer von beiden Wegen gemessen ist.

## K2 — drei kopflose Stellen, öffentlich

Gemessen am lebenden Release, nicht an der Datei:

```
$ gh release view v1.0.113 --json body --jq .body > pub-113.md
$ git show origin/main:Releases/1.0.113/RELEASE-NOTIZEN.md > main-113.md
$ diff main-113.md pub-113.md
132a133
>
```

Identisch bis auf die Leerzeile am Ende. Was dort steht:

**1. Der Einleitungssatz bricht nach dem dritten Wort ab** (`pub-113.md:26-27`):

> ZIP auspacken, `Eudora starten.cmd` doppelklicken. Nichts zu installieren. Das
> `## Neu gegenüber v1.0.112`

Verloren: *„Mailverzeichnis im ZIP ist leer – ein vorhandenes `Mailverzeichnis`
hineinkopieren."* — **Das ist wörtlich [L-43.1](LEKTOR-43.md#l-43.1) Nr. 2.**
`ce5c2e33` (14:07) hat die Zeile in `Releases/1.0.112/` wieder eingesetzt;
`0f4b2b1a` (14:34) hat `Releases/1.0.113/` aus dem **unreparierten** Text
angelegt — in demselben Commit, dessen Nachricht *„[LEKTOR-43](LEKTOR-43.md#lektor-43) hereingefuehrt (17
Punkte)"* sagt.

**2. Der Punkt zu [E-69](../BEFUNDE.md#e-69) hat wieder keinen Kopf**
(`pub-113.md:41-42`):

> … und der andere Weg lief an ihr vorbei.
> nicht lesen, legte es je Nachricht einen eigenen Eintrag in *Task Errors* an …

Verloren: *„- **Keine Flut von Fehlermeldungen mehr beim Filtern.** Konnte
Eudora eine Nachricht"* — **[L-43.1](LEKTOR-43.md#l-43.1) Nr. 1, wörtlich
dieselbe Zeile, zum zweiten Mal öffentlich.**

**3. Neu, und beim Reparieren entstanden** (`pub-113.md:122-127`):

> … eine eigene Schranke (`tools/pruefe-e123-zaehlung.pl`, Gegenprobe am
> Fehlerstand 2 von 2 rot).
> auf beiden Wegen:** aus einem lokalen Postfach in einen IMAP-Ordner (Eudora
> wartete **6015 ms**) …

`fe49a6ab` hat die unwahre Zeile *„- **Von Gregor am 20.10.2026 an Paket 1.0.113
am laufenden Programm bestätigt,"* entfernt — und die vier Folgezeilen stehen
lassen. Heraus kommt ein Satz, der mitten im Nebensatz beginnt, mit einem
herrenlosen `**` darin. Die Commit-Nachricht sagt *„Auf GitHub eingespielt und
am veroeffentlichten Text nachgemessen."* Nachgemessen wurde, dass der Text
**ankam**, nicht, dass er **ganz** ist.

**Dreimal an einem Tag dieselbe Klasse: eine Zeile wird ersetzt oder entfernt,
und was an ihr hing, bleibt kopflos stehen.** Zweimal betrifft es wörtlich die
Zeilen, die [LEKTOR-43](LEKTOR-43.md#lektor-43) Stunden vorher wiederhergestellt hatte.

**Gegenvorschlag — eine Schranke, kein Merksatz.** `tools/release-pruefen.pl`
(oder eine neue `pruefe-notizen-ganz.pl`) prüft jede Datei unter
`Releases/*/RELEASE-NOTIZEN.md`:

* Die Anzahl der `**` in jedem Aufzählungspunkt muss **gerade** sein. Das hätte
  Nr. 3 gefunden.
* Ein eingerückter Fortsetzungsblock darf nicht unmittelbar auf eine eingerückte
  Zeile folgen, die den vorigen Punkt mit `.` abschließt. Das hätte Nr. 2
  gefunden, zweimal.
* Ein Absatz darf nicht ohne Leerzeile unmittelbar vor einer `##`-Überschrift
  enden. Das hätte Nr. 1 gefunden, zweimal.
* **Und der Auslöser gehört nach vorn**
  ([Auslöser an den Anfang](../Arbeitsweise/ausloeser-an-den-anfang.md)): in
  `release-veroeffentlichen.ps1` **vor** dem Hochladen, nicht in den
  `pre-commit`.

Die Gegenprobe ist vorhanden und kostenlos:
`Releases/1.0.112/RELEASE-NOTIZEN.md` vor `ce5c2e33` ist der Fehlerstand, danach
der erlaubte Fall
([Schranke gegentesten](../Arbeitsweise/schranke-gegentesten.md)).

## K15 — die Buchführung ist beim Nachziehen überschrieben worden

`pruefe-release-buchfuehrung.pl` meldete nach dem Taggen sechs Stellen, die noch
`1.0.112` sagten. In `fe49a6ab` sind sie durch Ersetzen des Textes `1.0.112`
durch `1.0.113` stillgelegt worden. Gemessen am Diff:

| Stelle | steht jetzt da | wahr ist |
|---|---|---|
| `WEITERMACHEN.md:9` | 7.2.0.112 … *„als `v1.0.113` veröffentlicht"* | 7.2.0.112 erschien als **`v1.0.112`** |
| `WEITERMACHEN.md:45` | *„Quellstand 7.2.0.112 / `VERSION` 1.0.113, als `v1.0.113` am 20.10.2026 um 11:55:10 UTC … Marke auf `f87a4a74` = Merge von PR #113 … SHA-256 `0406c108…`"* | `v1.0.113`: **13:01:36 UTC**, Marke `ac094f15` = PR **#117**, Quellstand **7.2.0.113**, ZIP **9 378 205 Byte**, SHA-256 **`0d1d4bf4…`** |
| `Releases/PAKETE.md`, Kopf | *„zuletzt veröffentlicht **1.0.112** als `v1.0.113`"* | `v1.0.112` ⇒ 1.0.112, `v1.0.113` ⇒ 1.0.113 |
| `Releases/PAKETE.md`, Abschnitt 1.0.112 | *„**als `v1.0.113` veröffentlicht**"*, Zeile *Veröffentlicht* ebenso | das war `v1.0.112` |
| `Releases/PAKETE.md`, Abschnitt **1.0.113** | **keine Zeile *Veröffentlicht*** | ist seit 13:01:36 UTC *Latest* |
| `README.md:38` | *„Stand Paket **1.0.113** (… nicht veröffentlicht); veröffentlicht ist **1.0.112** … als `v1.0.113`"* | in sich widersprüchlich |
| `README.md:136` | *„Das neueste Release ist `v1.0.113` (veröffentlicht am 20.10.2026 um 11:55…"* | 13:01:36 UTC |
| `README.md:76`, `:81` | *„ab 7.2.0.106 (seit `v1.0.113` veröffentlicht)"* | seit `v1.0.112` |

**Das ist nicht Schlamperei, sondern eine Schranke, die ihr Ziel verfehlt.** Sie
verlangt, dass die Zeichenkette `1.0.113` vorkommt; sie prüft nicht, ob das, was
dasteht, **wahr** ist. Die billigste Art, sie grün zu bekommen, ist genau die,
die hier gewählt wurde — und sie hat den einzigen schriftlichen Beleg über
`v1.0.112` vernichtet. `tools/RELEASES.md:46` ist als einzige Stelle richtig
(*2026-10-20 15:01:37 … v1.0.113 … veroeffentlicht*).

**Gegenvorschlag:**

1. Die überschriebenen Stellen aus der Historie wiederherstellen
   (`git show ac094f15:…` trägt den richtigen `v1.0.112`-Text) und daneben einen
   **eigenen** Eintrag für `v1.0.113` mit den gemessenen Werten anlegen:
   13:01:36 UTC, `ac094f15`, PR #117, 9 378 205 Byte, `0d1d4bf4…f4772`.
2. `pruefe-release-buchfuehrung.pl` so erweitern, dass sie die Angaben neben der
   Nummer gegen `gh release view <tag>` misst — Zeit, Marke und Anhanggröße.
   Eine Schranke, die ihren Maßstab aus derselben Datei nimmt, die sie prüft,
   prüft nichts
   ([Einigkeit ist kein Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)).
3. Auslöser nach `release-veroeffentlichen.ps1`, **nach** dem Taggen — das ist
   [L-43.11](LEKTOR-43.md) und steht dort schon.

## K4 — der CHANGELOG sagt beides

`CHANGELOG.md:12-16` auf `origin/main`:

> ## Noch offen (Stand 20.10.2026)
>
> | [**E-131**](BEFUNDE.md#e-131) | … | **Offen, von außen gemeldet und am
> Quelltext belegt, von uns noch nicht nachgestellt.** … In `v1.0.112`
> ausdrücklich **nicht** angefasst |

`CHANGELOG.md:85` neunundsechzig Zeilen weiter: *„## 7.2.0.113 — [E-131](../BEFUNDE.md#e-131): keine
ungültige Fensterposition mehr in der `Eudora.ini`"*, und `BEFUNDE.md:300`:
*„Behoben in 7.2.0.113 (20.10.2026), am Prüfstand rot und grün gesehen"*.

`perl tools/doku-pruefen.pl` dazu: **„Kein Widerspruch gefunden."** Die Schranke
vergleicht Fassungsnummern, nicht Urteile. Sie hat 31 Dateien und 129 Kennungen
gelesen und diesen Widerspruch nicht sehen können, weil sie nicht danach sucht.

**Gegenvorschlag:** `doku-pruefen.pl` um eine Regel erweitern — eine Kennung,
deren Urteil in `BEFUNDE.md` mit **„Behoben in"** anfängt, darf in der Tabelle
*Noch offen* des CHANGELOG nicht vorkommen, und umgekehrt. Das ist ein
Vergleich zweier Listen, kein Textverständnis.

## K5 — was der Prüfstand nicht gesehen hat

| Frage | Antwort | woher |
|---|---|---|
| Ist ein Bau gelaufen, der sich als 7.2.0.113 meldet? | **nein** | `eudora.log` im Prüfverzeichnis, Z. 3 und 64: *Version 7.2.0.112*; die E-131-Spur steht in Z. 47 und 109, also **in** diesen beiden Läufen |
| Hat Gregor 1.0.113 gestartet? | **nein** | sein Verzeichnis `Eudora72-1.0.113-release\Mailverzeichnis` enthält nur `Eudora.ini`, **keine** `eudora.log` |
| Steht ein 1.0.113-Lauf in der Buchführung? | **nein** | `tools/TESTLAEUFE.md`: die jüngsten vier Einträge (13:58 bis 14:12) sind alle `1.0.112+<commit>` |

Der Unterschied zwischen dem gemessenen und dem ausgelieferten Bau ist
`Version.h` — derselbe Commit `0f4b2b1a` trägt Behebung **und** Fassungssprung,
die Messung lief gegen den Zwischenstand davor. Das Risiko ist klein. Es ist
trotzdem der Fall, vor dem
[Paket gegen den Bau messen](../Arbeitsweise/paket-gegen-den-bau-messen.md)
warnt, und es ist nirgends benannt.

**Gegenvorschlag:** einmal die `Eudora.exe` aus Gregors 1.0.113-Verzeichnis
starten und beenden und die Zeile `E-131 Leistenposition: …` aus dessen
`eudora.log` in `tools/TESTLAEUFE.md` eintragen. Das kostet eine Minute und
schließt die Lücke ganz.

## K6 — die wichtigste Frage des Auftrags: `GetPrivateProfileInt` und das Minus

Gefahren am 20.10.2026 über P/Invoke gegen `kernel32!GetPrivateProfileIntA`,
Vorgabe `INT_MAX`:

| Abschnitt | Text in der INI | roher `UINT` | als `int` | `== INT_MAX`? |
|---|---|---|---|---|
| Bar1 | `-2147483648` | 2147483648 | **-2147483648** | nein |
| Bar2 | `-50` | 4294967246 | **-50** | nein |
| Bar3 | `2147483647` | 2147483647 | 2147483647 | **ja** |
| Bar4 | *(Schlüssel fehlt)* | 2147483647 | 2147483647 | **ja** |
| Bar5 | `4294967295` | 4294967295 | **-1** | nein |
| Bar6 | `0x40` | 64 | 64 | nein |

**Entwarnung: die alte Lesart, `GetPrivateProfileInt` schneide bei `-` ab oder
liefere 0, trifft auf Windows 10 nicht zu.** Der Rückgabewert ist
vorzeichenlos, aber die Bits sind die richtigen; die Zuweisung an `int nX` holt
das Vorzeichen zurück. `E131PositionIstBrauchbar` sieht also wirklich
`-2147483648`, und dass die Behebung wirkt, ist **kein Zufall**.

Zwei Kanten bleiben:

**(a) `INT_MAX` ist ein schlechtes Merkzeichen.** Bar3 und Bar4 liefern
dasselbe. Ein echter Eintrag `MRUFloatXPos=2147483647` ist selbst eine
unbrauchbare Position — und ausgerechnet der wird als *„kein Eintrag"*
übersprungen. Heute nicht auslösbar, weil MFC nur `CW_USEDEFAULT` oder echte
Punkte schreibt.

**(b) Fehlt nur einer der beiden Schlüssel**, greift `nX == INT_MAX && nY ==
INT_MAX` nicht, die Position gilt als unbrauchbar, und die Funktion schreibt
**beide** Schlüssel — sie legt also einen an, den es nicht gab. Der Kommentar
darüber sagt: *„Sie erfindet nichts dazu und entfernt nichts — ein fehlender
Schluessel koennte einen anderen Leser ebenso ueberraschen."* Das ist heute
folgenlos, weil `CControlBarInfo::SaveState` beide zusammen schreibt
(`dockstat.cpp:240-242`), aber Code und Kommentar sagen Verschiedenes.

**Gegenvorschlag:** statt eines Zahlen-Merkzeichens
`GetPrivateProfileString(…, "", …)` benutzen und auf leere Zeichenkette prüfen;
dann sind „fehlt" und „ist zufällig `INT_MAX`" sauber getrennt, und jeder der
beiden Schlüssel kann einzeln behandelt werden.

## K7 — der Puffer: richtig erkannt, falsch beschrieben

Gemessen gegen eine INI mit 400 Abschnitten (Namensliste 36 290 Byte):

| Puffer | Rückgabe | `Puffer-2` | Abbruchtest `>= Puffer-2` |
|---|---|---|---|
| 64 | 62 | 62 | greift |
| 1024 | 1022 | 1022 | greift |
| 32768 | **32766** | 32766 | **greift** |
| 36291 (`voll+1`) | 36289 | 36289 | greift |
| 36292 (`voll+2`) | **36290** | 36290 | **greift — fälschlich** |
| 36293 (`voll+3`) | 36290 | 36291 | greift nicht |

**Die Erkennung stimmt:** beim Abschneiden liefert
`GetPrivateProfileSectionNames` exakt `nSize-2`, und `>=` fängt das. Bei genau
passendem Puffer (`voll+2`) meldet der Test fälschlich Abschneiden — das ist
harmlos, weil es zur sicheren Seite irrt, aber es ist dieselbe Zeile.

**Falsch ist die Folge.** Bei Abschneiden tut die Funktion **gar nichts** und
schreibt **keine Spurzeile**:

```cpp
if (dwGelesen == 0 || dwGelesen >= dwPuffer - 2)
{
    delete [] pNamen;
    return;
}
```

Der Kommentar darüber verspricht: *„32 KB reichen; wer mehr hat, bekommt den
Rest beim naechsten Sichern — besser unvollstaendig als abgeschnitten
geraten."* Es gibt keinen Rest beim nächsten Sichern. Eine INI wächst; wer
einmal über der Grenze liegt, liegt immer darüber, und die Nachbehandlung ist
für ihn **stumm abgeschaltet**. Dasselbe gilt, wenn die Datei fehlt
(`dwGelesen == 0`).

Wie weit ist die Grenze weg? Die echte `Eudora.ini` hat 18 Abschnitte und
braucht rund 250 Byte. 32 KB reichen für etwa tausend Abschnittsnamen. Das ist
viel — aber es ist nicht *„kann nicht vorkommen"*, und es ist **unsichtbar**.

**Gegenvorschlag, zwei Zeilen:** die Spurmarke **vor** den Rücksprung ziehen und
den Abbruchgrund mitnennen (`abgeschnitten=1` bzw. `keine-abschnitte=1`). Wer
mag, verdoppelt den Puffer in einer Schleife bis 1 MB — aber gemeldet werden
muss es in jedem Fall. Eine Prüfung, die stumm grün meldet, ist
[E-109](../BEFUNDE.md#e-109) in klein.

## K8 — `new` liefert hier nie NULL

```cpp
char *pNamen = new char[dwPuffer];
if (!pNamen)
    return;
```

MFC setzt beim Start seinen eigenen `new`-Handler:

```cpp
// afxmem.cpp:256-264
int AFX_CDECL AfxNewHandler(size_t /* nSize */)
{
    AfxThrowMemoryException();
}
_PNH _afxNewHandler = &AfxNewHandler;
// afxstate.cpp:244
m_pfnNewHandler = &AfxNewHandler;
```

In einer MFC-Anwendung wirft `new` bei Speichermangel eine `CMemoryException*`
und kehrt nie mit NULL zurück. **Die Prüfung ist toter Code.** Statt eines
sauberen Rücksprungs fliegt die Ausnahme mitten aus dem Beenden heraus — durch
`SaveBarState` und `CloseDown`, bis dahin, wo sie jemand fängt.

Zweitens: zwischen `new` und `delete[]` stehen zwei `CString::Format`, die
ebenfalls werfen können. Dann leckt der Puffer. Beim Beenden ist das folgenlos,
beim Aufruf aus dem Anpassen-Dialog (`QCToolBarManager.cpp:1109`) nicht ganz.

**Gegenvorschlag:** `new (std::nothrow) char[dwPuffer]` — dann ist die
vorhandene Prüfung richtig — oder gleich ein `CString`-Puffer, der sich selbst
abräumt.

## K9 — die Regel ist viel lockerer, als ihr Kommentar sagt

```cpp
const int nLuft = 100;
if (nX < nLinks - nBreite + nLuft || nX > nLinks + nBreite)
    return false;
```

Eingesetzt mit dem gemessenen Schirm (`nLinks=0`, `nBreite=1920`): brauchbar ist
alles von **`x = -1820`** bis `x = 1920`. Das sind **3740 Pixel Spielraum auf
einem 1920 Pixel breiten Schirm.**

Der Kommentar daneben sagt:

> nach LINKS und OBEN darf die Ecke hinauslaufen, solange ein Streifen von 100
> Pixeln sichtbar bleibt

Das leistet die Rechnung nicht. Für „100 Pixel bleiben sichtbar" müsste die
**Leistenbreite** eingesetzt werden, nicht die **Bildschirmbreite**. Die echte
INI nennt sie sogar: `FloatCx318=200`. Eine 200 Pixel breite Leiste bei
`x = -1820` ist **vollständig unsichtbar** und gilt als brauchbar. Der Test
schreibt diesen Irrtum fest:

```cpp
TT_CHECK_MSG(E131PositionIstBrauchbar(-1800, 0, L, O, B, H),
    "ein Streifen ragt noch herein");
```

Bei `x = -1800` ragt nichts herein.

**Was ich gesucht und nicht gefunden habe: eine gültige Anordnung, die zerstört
wird.** Die Regel irrt nach der sicheren Seite. Durchgerechnet:

| Lage | `nLinks, nOben, nBreite, nHoehe` | gültiger Bereich x / y | Urteil |
|---|---|---|---|
| ein Schirm 1920x1294 | 0, 0, 1920, 1294 | −1820 … 1920 / −1194 … 1294 | alles Normale geht durch |
| zweiter Schirm **links** | −1920, 0, 3840, 1080 | −5660 … 1920 / −980 … 1080 | `x = −1000` geht durch |
| zweiter Schirm **oben** | 0, −1080, 1920, 2160 | −1820 … 1920 / −3140 … 1080 | `y = −800` geht durch |
| Schirm abgezogen, Leiste stand bei `x = −2400` | 0, 0, 1920, 1294 | −1820 … 1920 | wird berichtigt — richtig so |
| `nBreite <= 0` (keine Messung) | — | — | kein Urteil, Wert bleibt stehen — richtig so |

**Bildschirmwechsel im laufenden Betrieb** ist unkritisch: die vier
`GetSystemMetrics` werden bei **jedem** `SaveBarState` frisch gelesen, es gibt
keinen gemerkten Wert.

**Gegenvorschlag:** entweder den Kommentar und den Testnamen an die Rechnung
anpassen (*„höchstens eine Bildschirmbreite daneben"*) oder — besser — die
Breite der Leiste aus `FloatCx<ID>` im Abschnitt `ToolBar-ToolBarManager` holen
und **die** einsetzen. Letzteres ist die Regel, die der Kommentar meint, und sie
fängt auch den Fall „Leiste steht 1000 Pixel links außerhalb".

## K10 — Aufrufort und Kosten

**Aufrufstellen**, alle drei mit `_T("ToolBar")`:

| Ort | wann |
|---|---|
| `mainfrm.cpp:5829` (`CloseDown` Stufe 5f) | beim Beenden — der gemessene Weg |
| `mainfrm.cpp:1027` | beim Start, nur wenn `pMgr->ConvertOldStuff()` TRUE liefert |
| `QCToolBarManager.cpp:1109` | nach dem Schließen des Dialogs *Toolbars anpassen* |

Die Nachbehandlung steht **nach** beiden Schreibwegen, auch nach dem Notweg
`bMissionControlWeHaveAProblem` (`mainfrm.cpp:3103-3108`). Das ist richtig so,
und die Reihenfolge im Protokoll bestätigt es: `E-70 gesichert…`,
`E-43 SaveCustomInfo…`, dann `E-131 Leistenposition: …`, dann erst
`E-33 5g nach SaveBarState(ToolBar)`.

Die Datei, in die geschrieben wird, ist dieselbe, in die `SaveBarState`
schreibt: `pApp->m_pszProfileName` ist `strdup(INIPath)` (`eudora.cpp:1160`),
und `WritePrivateProfileSection` benutzt `INIPath`.

**Kosten**, gemessen über P/Invoke, je Durchlauf ein
`GetPrivateProfileSectionNames`, zehn `GetPrivateProfileInt` und zehn
`WritePrivateProfileString`:

| INI-Größe | ein Durchlauf |
|---|---|
| 7 132 Byte (realistisch) | **18,1 ms** |
| 72 132 Byte | 112,3 ms |
| 758 132 Byte | 94,8 ms |

Nicht spürbar — auch nicht im Anpassen-Dialog, wo der Anwender dabeisteht.

## K11 — was MFC mit unserem Ersatzwert macht

Die Frage war: wird unser `40,40` beim nächsten `LoadBarState` gelesen, oder
überschreibt MFC es sofort wieder? **Gemessen, zwei Läufe im selben
Verzeichnis:**

```
MAIN 32768: 0.01 E-131 Leistenposition: abschnitte-mit-eintrag=5 berichtigt=5 …
MAIN 32768: 0.00 E-131 Leistenposition: abschnitte-mit-eintrag=5 berichtigt=5 …
```

`berichtigt=5` beim **zweiten** Lauf heißt: alle fünf Abschnitte standen beim
Sichern wieder auf einem unbrauchbaren Wert. Unser `40,40` kommt im Speicher
nicht an — `m_ptMRUFloatPos` ist beim Sichern wieder `CW_USEDEFAULT`.

**Das ist die gute Nachricht dieses Berichts.** Käme der Wert an, wäre die
Behebung ein sichtbarer Rückschritt: `CDockContext::ToggleDocking`
(`dockcont.cpp:392`) nimmt bei einem **negativen** `x` die letzte Andockstelle
als Schwebeposition. Mit `40` nähme es diesen Zweig nicht mehr, und **jede nie
frei bewegte Leiste spränge künftig in die linke obere Ecke**, statt dort
aufzugehen, wo sie angedockt war. Weil der Wert nicht ankommt, passiert das
nicht.

Die Kehrseite, ehrlich genannt: die Datei ist nur **zwischen zwei Sicherungen**
richtig, und jede Sicherung kostet zehn INI-Schreibzugriffe für dasselbe
Ergebnis. Das steht in der Commit-Nachricht und in `BEFUNDE.md` offen da.

## K12 — welche Abschnitte wirklich getroffen werden

Nachgezählt an der `Eudora.ini` des Prüfverzeichnisses nach einem Lauf:

| | |
|---|---|
| Abschnitte insgesamt | 18 |
| davon mit `ToolBar`-Präfix | 14 |
| davon mit `MRUFloatXPos`/`MRUFloatYPos` | **5** (`Bar1`, `Bar2`, `Bar3`, `Bar8`, `Bar9`) |
| Abschnitte **ohne** `ToolBar`-Präfix mit diesen Schlüsseln | **0** |

Geprüft, was der Auftrag ausdrücklich nennt: `[WazooBars]` trägt nur
`WazooBarIds` und drei `WazooBar<ID>`-Zeilen, keine Position.
`QCToolBarManager::SaveState` schreibt nach `[ToolBar-ToolBarManager]` und legt
dort `DockVertCx…`, `DockHorzCy…`, `FloatCx…`, `FloatCy…` ab — **Größen**, keine
Schwebepositionen. `[Window Position]` trägt `AdToolbarWindowPosition=0,0,0,0`,
ein anderes Format. **Der Präfixtest lässt heute nichts stehen.**

Zwei Kanten für später:

* `strncmp(p, "ToolBar", 7)` unterscheidet Groß- und Kleinschreibung,
  INI-Abschnitte tun das nicht. `[toolbar-Bar1]` würde übersprungen, obwohl
  `GetPrivateProfileInt` den Schlüssel darin fände. `_strnicmp` kostet nichts.
* Der Präfix ist fest verdrahtet, obwohl er aus `lpszProfileName` kommt. Heute
  rufen alle drei Stellen mit `"ToolBar"` auf; käme eine vierte mit einem
  anderen Namen, liefe die Nachbehandlung ins Leere, ohne es zu melden.
  `lpszProfileName` durchzureichen ist eine Zeile.

## K13 — die Regionsbuchstaben in `Extract.ps1`

```
$ grep -n '^# Region ' Eudora71/Tests/Extract.ps1
…
273:# Region Q: E118Huelle und E118Achtbit …
285:# Region O: CE69Sammlung …
296:# Region P: E69LautErlaubt …
305:# Region Q: E131PositionIstBrauchbar …
```

`O`, `P` und `Q` sind je zweimal vergeben. Die Variablen `$qStart`/`$qEnd`
werden ebenfalls wiederverwendet; das geht gut, weil sie nacheinander benutzt
werden. Kein Schaden, aber die Buchstaben taugen nicht mehr als Kennung — und
der Auftrag nennt „Region Q", als wäre sie eindeutig. Altbestand, nicht von
diesem Zweig verursacht.

Eine echte Kante am neuen Schnitt:
`Find-Line $mf '^bool E131PositionIstBrauchbar' 0` sucht vom Dateianfang. Käme
je eine Vorwärtsdeklaration in Spalte 1 dazu, schnitte die Region an der
falschen Stelle. Heute gibt es genau einen Treffer.

## K14 — der Leseweg: die Gefahr sitzt woanders

Der Auftrag fragt, ob eine bereits kaputte INI unser eigenes Eudora beschädigen
oder zum Absturz bringen kann. Zum Wert selbst: **nein.** Eudora liest
`MRUFloat*` an keiner Stelle selbst (`grep -rn MRUFloat Eudora71/` findet nur
den neuen Code und die Tests). MFC liest ihn in `CControlBarInfo::LoadState`
(`dockstat.cpp:186-189`) in einen `CPoint` und benutzt ihn nur dort, wo
Negatives abgefangen wird ([K1](#k1)).

**Gefährlich ist ein Nachbarschlüssel im selben Abschnitt.** `Docking=1` führt
in `CControlBar::SetBarInfo`:

```cpp
// atlmfc/src/mfc/dockstat.cpp:600-608
if (pInfo->m_bDocking)
{
    ASSERT(m_pDockContext != NULL);
    // You need to call EnableDocking before calling LoadBarState
    m_pDockContext->m_uMRUDockID = pInfo->m_uMRUDockID;
    …
}
```

Kein `if` hinter dem `ASSERT`. Steht in der INI `Docking=1` zu einer Leiste, für
die `EnableDocking` nicht gelaufen ist, schreibt das im Release über einen
Nullzeiger. Das ist **dieselbe Klasse**, die der Melder erlebt hat, nur in
unserer Richtung: eine fremde oder von Hand bearbeitete `Eudora.ini` kann
unseren Start treffen.

Ich habe es **nicht ausgelöst gesehen** und auch nicht versucht — dafür müsste
man eine INI bauen und Eudora starten, und das ist Oberfläche. Es steht in
keinem Befund.

**Gegenvorschlag:** einen eigenen Befund anlegen („eine fremde `Eudora.ini` kann
unseren Start treffen") und die billige Absicherung prüfen —
`E131LeistenpositionenBereinigen` liest die Abschnitte ohnehin schon; sie könnte
beim **Laden** einmal dasselbe tun und `Docking=1` zu einer Kennung streichen,
die `GetControlBar` nicht kennt. Das wäre zugleich die Behebung des Lesewegs,
die heute offen bleibt.

---

## Was Gregor an `v1.0.113` prüfen kann

Die Fassung ist draußen; die Prüfung ist trotzdem die, die fehlt.

**Prüfung 1 (die Lücke aus [K5](#k5), eine Minute).** Die `Eudora.exe` aus
seinem 1.0.113-Verzeichnis einmal starten und beenden. Erwartet in dessen
`eudora.log`:

```
Version 7.2.0.113
E-131 Leistenposition: abschnitte-mit-eintrag=… berichtigt=… bildschirm=… ersatz=…
```

und danach in der `Eudora.ini` dieses Verzeichnisses **null** Treffer für
`-2147483648`. Damit ist zum ersten Mal der **ausgelieferte** Bau gemessen.

**Prüfung 2 (die Gegenprobe zu [K9](#k9) und [K11](#k11)).** Eine Werkzeugleiste
am Griff vom Rahmen lösen, an eine ungewöhnliche Stelle ziehen, Eudora beenden
und neu starten. Erwartet: die Leiste steht wieder dort, wo sie stand — die
Nachbehandlung darf eine vom Anwender gesetzte Position **nicht** anfassen. Im
Protokoll muss `berichtigt` dann **kleiner** sein als `abschnitte-mit-eintrag`.
Ist es gleich groß, wird auch die bewegte Leiste überschrieben, und das wäre ein
Rückschritt.

**Prüfung 3 (die einzige, die [K1](#k1) entscheidet).** Die kann nur der Melder
aus [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102) machen: seine
`Eudora.ini` vor und nach einem Lauf von `v1.0.113` sichern, Hermes 7.1.0.9
starten — und, falls es wieder knallt, die Abschnitte `[ToolBar-Summary]` und
alle `BarID=`-Zeilen aus beiden Fassungen schicken. Dann steht in einer Minute
fest, ob es die Position war oder die Leistenkennungen.

**Nicht testen:** eine von Hand verbogene `Eudora.ini` mit `Docking=1` zu einer
erfundenen Leistenkennung. Das ist [K14](#k14), und der Ausgang ist
wahrscheinlich ein Absturz beim Start.
