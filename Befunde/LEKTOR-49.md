# <a id="lektor-49"></a>LEKTOR-49 — fünf führende Dokumente kannten `v1.0.120` nicht, und das Adressbuch „fällt aus", seit es funktioniert

Durchgang am 21.10.2026 abends im Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig
`wt/lektor-20261021c`, Ausgang `e14bcb3f`. Geprüft wurden die Papiere **gegen
den Bestand**, nicht gegen den Diff. Geändert habe ich nur `.md`-Dateien;
kein Quelltext unter `Eudora71/`, kein Bau.

## Maßstab von außen

Nichts davon aus einem Dokument des Projekts ([Einigkeit ist kein
Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)):

| Quelle | Wert |
|---|---|
| `Eudora71/Version.h:13-14` | **`7.2.0.120`** |
| `VERSION` | **`1.0.120`** |
| `gh release list --limit 8` | **`v1.0.120`**, *Latest*, `2026-10-21T19:07:37Z`; davor `v1.0.117` `07:56:56Z`, `v1.0.113`, `v1.0.112`, `v1.0.101` |
| `gh release view v1.0.120 --json assets` | Marke `30feeae2`, Anhang `Eudora72-1.0.120-release.zip`, **9 381 870 Byte**, SHA-256 `26fde414…a6a1` |
| `gh release view v1.0.117 --json assets` | Marke `f546b004`, Anhang 9 382 044 Byte, SHA-256 `335751a9…eb1a1` |
| `ls Releases/*.zip` (Hauptarbeitsbaum) | jüngstes **`Eudora72-1.0.120-release.zip`**, 9 381 870 Byte |
| `git for-each-ref refs/tags` | höchste Marke `v1.0.120` |
| MFC 14.38, `atlmfc/src/mfc/dockstat.cpp:327-367` | `CDockState::LoadState` und `SaveState` im Quelltext gelesen |
| Uhr | 21.10.2026 |

**Das Entscheidende in einer Zeile:** zwischen [LEKTOR-48](LEKTOR-48.md) von
heute nachmittag und jetzt ist **1.0.120 geschnürt und als `v1.0.120`
veröffentlicht worden** — und fünf führende Dokumente sagten weiterhin
*„nicht veröffentlicht"* oder *„`v1.0.117` ist der veröffentlichte Stand"*,
während **beide** dafür gebauten Schranken grün meldeten.

**Werkzeuge vorher:** `doku-pruefen.pl` *kein Widerspruch* (9 Hinweise zur
Kenntnis), `pruefe-release-buchfuehrung.pl` **Rückgabewert 0** — *„Jedes
führende Dokument kennt v1.0.120"*. **Keine Schranke hat einen der Funde
[L-49.1](#l-49.1) bis [L-49.7](#l-49.7) gesehen.**

---

## Die Buchführung stand auf dem Stand von heute früh

### <a id="l-49.1"></a>L-49.1 — fünf Dokumente nannten `v1.0.117` oder „nicht veröffentlicht" (hoch)

| Datei:Zeile | Behauptung | Tatsächlich |
|---|---|---|
| `ZIEL.md:52` | *„veröffentlicht ist 7.2.0.117 / Paket 1.0.117 als `v1.0.117`"* und *„Quellstand ist jetzt 7.2.0.120 … **nicht veröffentlicht**"* | `v1.0.120` ist seit 19:07:37 UTC *Latest* |
| `PORTIERUNG.md:44` | 7.2.0.120 *„am 21.10.2026 geschnürt, **nicht veröffentlicht**"* | veröffentlicht |
| `WEITERMACHEN.md:9` | 1.0.120 *„**Übersetzt, noch nicht geschnürt**"*, mit der Messung *„unter `Releases/` endet die Reihe der ZIPs bei 1.0.119"* | `Eudora72-1.0.120-release.zip` liegt dort, 9 381 870 Byte |
| `WEITERMACHEN.md:140-144` | *„**`v1.0.117` ist der veröffentlichte Stand**"*, *„1.0.120 ist übersetzt und noch nicht geschnürt"* und als **Handlungsanweisung** *„1. Paket 1.0.120 schnüren"* | geschnürt (14:14) **und** veröffentlicht (19:07:37 UTC) |
| `Releases/PAKETE.md:6` | *„zuletzt veröffentlicht **1.0.117** als `v1.0.117`"* | zuletzt `v1.0.120` |

**Warum das die teuerste Sorte ist:** `WEITERMACHEN.md` ist die Datei, aus
der die nächste Sitzung ihren ersten Handgriff nimmt. Punkt 1 ihrer Liste
verlangte Arbeit, die seit fünf Stunden getan ist — derselbe Fehler wie
[L-48.2](LEKTOR-48.md#l-48.2), nur einen Tagesabschnitt später, und **zum
vierten Mal an diesem Tag** (vorher [L-46.1](LEKTOR-46.md#l-46.1) und
[L-47.2](LEKTOR-47.md#l-47.2)). Dazu widersprach sich `WEITERMACHEN.md`
**in sich**: Zeile 46 (*„Zuletzt gebaut und veröffentlicht"*) nannte
`v1.0.120` richtig, Zeile 9 und Zeile 140 nicht.

**Alle fünf berichtigt.**

### <a id="l-49.2"></a>L-49.2 — `BEFUNDE.md` E-132 sagte „noch nicht ausgeliefert", während die öffentliche Seite „released in v1.0.120" sagt (hoch)

[E-132](../BEFUNDE.md#e-132) trug als Urteil *„behoben im Zweig
`e-132-fremdes-mailverzeichnis` … **noch nicht ausgeliefert**"*.

Dasselbe Thema steht in [MELDUNGEN-VON-AUSSEN.md](../MELDUNGEN-VON-AUSSEN.md),
Zeile `#102-1`, als *„**Fixed** in 7.2.0.117 and 7.2.0.118, released in
`v1.0.120`"* — **und diese Zeile verlinkt genau auf [E-132](../BEFUNDE.md#e-132)**. Wer dem Link
folgt, liest das Gegenteil. Die Datei wird Fremden per Link gezeigt; der
Melder aus Issue #102 hat den Link im geschlossenen Issue stehen.

Richtig ist die englische Fassung: 7.2.0.117 steckt in `v1.0.117`, 7.2.0.118
in `v1.0.120`. **[E-132](../BEFUNDE.md#e-132) berichtigt**, mit der Kette 7.2.0.114 → .115 → .116 →
.117 → .118 und dem ausdrücklichen Vermerk, was in welchem Release steckt.

### <a id="l-49.3"></a>L-49.3 — eine offene Frage in E-131 war am Quelltext zu beantworten und stand einen Tag offen (mittel)

[E-131](../BEFUNDE.md#e-131) endete mit *„**Noch nicht gemessen:** ob
`LoadBarState` diese Registryschlüssel vor der INI liest — das ist der
nächste Handgriff am offenen Leseweg."*

**Am Quelltext belegt, 21.10.2026 — nein.** `m_pszRegistryKey` wird im
ganzen Baum an **genau einer** Stelle gesetzt: in `CMainFrame::SaveBarState`
selbst (`Eudora71/Eudora/mainfrm.cpp:2886`), zurückgesetzt in `:3103`.
Außerhalb ruft nur die eigenständige PureVoice-Anwendung `SetRegistryKey`
(`Eudora71/PureVoice/Recorder/QVoice.cpp:62`). Der Leseweg —
`SECDockState::LoadState` (`Eudora71/OTShim/OTShim.cpp:5378`, reicht an
`CDockState::LoadState` durch), gerufen in `mainfrm.cpp:888` — läuft deshalb
mit `m_pszRegistryKey == NULL` und liest über `CWinApp::GetProfileInt` die
`Eudora.ini`, **nicht** die Registry.

Gemessen mit `grep -rn "SetRegistryKey\|m_pszRegistryKey" Eudora71/`: drei
Treffer, alle oben genannt. **Belegt am Quelltext, nicht am laufenden
Programm** ([Ursache nur gemessen
behaupten](../Arbeitsweise/ursache-nur-gemessen-behaupten.md)). In [E-131](../BEFUNDE.md#e-131)
nachgetragen; der eigentliche Leseweg bleibt offen.

---

## Eine Falschaussage über das eigene Programm

### <a id="l-49.4"></a>L-49.4 — „Adressbuch … fällt aus" steht in `README.md`, seit zwei Adressbuchfehler behoben und bestätigt sind (hoch)

Von Gregor gefunden, von mir nachgemessen. `README.md:113` (Tabelle *Was
fehlt*) und `README.md:147` (Aufzählung) sagten:

> **Adressbuch, LDAP, Ph und S/MIME fallen aus.**

**Das ist falsch, und zwar an der sichtbarsten Stelle des Projekts.**
Nachgemessen:

1. Das **lokale Adressbuch** ist gebaut. `nickdoc.cpp`, `nicktree.cpp`,
   `nickpage.cpp` und `NicknamesWazooWnd.cpp` stehen in
   `Eudora71/Eudora/Eudora.vcxproj` (Zeilen 380-384), werden also in
   `Eudora.exe` übersetzt und brauchen kein `MFC71.DLL`.
2. [E-47](../BEFUNDE.md#e-47) selbst beschreibt **nur den
   Verzeichnisdienst**: der Dialog *„Directory Services unavailable"* kommt
   aus `DSRightViewImpl.h:44`, weil `DirServ.dll`, `ISock.dll`, `Ph.dll`,
   `Ldap.dll` und `EudoraBk.dll` `MFC71.DLL` brauchen. Vom Adressbuch steht
   dort kein Wort.
3. `EudoraBk.dll` klingt nach Adressbuch, ist aber der Protokollanbieter
   *„EudoraBk Protocol"* des Verzeichnisdienstes
   (`DirectoryServices/DirectoryServicesUI/inc/RegisterComponentImpl.h:67`).
   **Das ist die Verwechslung, aus der die Falschaussage stammt.**
4. **Gegenbeleg aus dem eigenen Bestand:** in 1.0.119 und 1.0.120 sind zwei
   Adressbuchfehler behoben und von Gregor am laufenden Programm bestätigt —
   [E-134](../BEFUNDE.md#e-134) (Kurzname eines neuen Eintrags) und
   [E-135](../BEFUNDE.md#e-135) (Vervollständigungsbox). Ein Adressbuch, das
   „ausfällt", hat keine zwei bestätigten Behebungen in derselben Woche.

**`README.md` berichtigt**, beide Stellen, mit dem ausdrücklichen Satz, dass
das eigene Adressbuch **nicht** gemeint ist — damit niemand denselben Schluss
zieht wie Gregor.

**Dieselbe Verwechslung steht an weiteren Stellen**, gemessen mit
`grep -rn "Adressbuch, LDAP"`:

| Datei | geht nach außen? |
|---|---|
| `Releases/1.0.101/`, `1.0.110/`, `1.0.112/`, `1.0.113/`, `1.0.114/`, `1.0.117/RELEASE-NOTIZEN.md` | **ja** — *„Adressbuch, LDAP und S/MIME fehlen weiterhin."* stand in **sechs** ausgelieferten Release-Notizen |
| `AUFGABEN.md:304`, `AUFGABEN.md:955`, `WEITERMACHEN.md:300` | intern |
| `PORTIERUNG.md:612`, `PORTIERUNG.md:737` | intern |
| `Pruefung/PRUEFUNG-PAKET.md:142` und `:386`, `PRUEFUNG-BRANCH.md:250` | intern |
| `BEFUNDE.md:3063` und `:3970` ([B-1](../BEFUNDE.md#b-1)), `Befunde/PAKET.md:150` | historisch, Beweisführung von damals |

**In diesem Durchgang berichtigt ist `README.md`** — die Datei, die der
Auftrag mir zuweist und die jeder Fremde zuerst liest. Die neu angelegten
Notizen zu 1.0.120 ([L-49.6](#l-49.6)) führen die falsche Zeile
**ausdrücklich nicht** fort und sagen warum. **Die übrigen zehn Stellen sind
nicht berichtigt**: bei den sechs Release-Notizen vergangener Fassungen wäre
es eine nachträgliche Änderung dessen, was ausgeliefert wurde, und dafür
braucht es Gregors Entscheidung. Die vier internen Stellen in `AUFGABEN.md`,
`WEITERMACHEN.md`, `PORTIERUNG.md` und `Pruefung/` gehören in den nächsten
Durchgang und stehen hier, damit sie nicht wieder verlorengehen.

---

## Die Papiere zum Release selbst

### <a id="l-49.5"></a>L-49.5 — `Releases/PAKETE.md`: die beiden veröffentlichten Fassungen des Tages hatten keine Zeile *Veröffentlicht* (mittel)

`Releases/PAKETE.md` führt je Paket eine Tabelle. Die Abschnitte **1.0.112**
und **1.0.113** nennen ihr Release — der eine in der Überschrift, der andere
in einer Zeile *Veröffentlicht*. Die Abschnitte **1.0.117** und **1.0.120**,
beide veröffentlicht, trugen **gar nichts davon**. In `PAKETE.md` stand also,
dass die Pakete geschnürt wurden, aber nicht, dass sie draußen sind.

Das zählt, weil der Kopf derselben Datei sagt: *„wer die nächste
Fassungsnummer aus dieser Liste ableitet, greift daneben"* — und weil am
11.10.2026 schon einmal **drei von 14** Veröffentlichungen hier ganz fehlten.

**Beide Zeilen nachgetragen**, mit Uhrzeit, Marke, Anhanggröße und der am
Anhang gemessenen SHA-256.

### <a id="l-49.6"></a>L-49.6 — zu `v1.0.120` gab es keine Release-Notizen im Arbeitsbaum (mittel, **zweiter Fall am selben Tag**)

`Releases/1.0.101/`, `1.0.110/`, `1.0.112/`, `1.0.113/`, `1.0.114/` und
`1.0.117/` tragen `RELEASE-NOTIZEN.md`. Ein Verzeichnis `Releases/1.0.120/`
gab es nicht — obwohl `v1.0.120` das veröffentlichte Release ist.

Genau das hat [L-46.2](LEKTOR-46.md#l-46.2) heute früh für `v1.0.117`
gemeldet und dort von Hand nachgeholt. **Zwölf Stunden später derselbe
Mangel.** Das ist keine Nachlässigkeit, sondern eine fehlende Schranke:
`release-veroeffentlichen.ps1` legt die Notizen nicht an und prüft nicht, ob
es welche gibt.

**Angelegt:** `Releases/1.0.120/RELEASE-NOTIZEN.md`, mit dem Rumpf des
veröffentlichten Releases **wörtlich** (`gh release view v1.0.120 --json
body`), damit nichts nachträglich geschönt ist.

### <a id="l-49.7"></a>L-49.7 — `tools/RELEASES.md`: die Zeile zu `v1.0.120` stand hinter dem Zitatblock und war keine Tabelle (mittel, **dritter Fall**)

`tools/release-veroeffentlichen.ps1` hängt die neue Zeile ans **Dateiende**.
Am Dateiende steht aber seit dem 17.09.2026 ein Zitatblock. Die Zeile zu
`v1.0.120` stand deshalb als **einzelne Strichzeile ohne Kopf** unter dem
Zitat — Markdown macht daraus keine Tabelle, sondern eine Textzeile mit
Strichen darin. Im Register der Veröffentlichungen fehlte das jüngste
Release also optisch ganz.

Dasselbe ist bei `v1.0.113` am 20.10.2026 passiert und steht als
[L-43.8](LEKTOR-43.md#l-43.8) und [L-43.12](LEKTOR-43.md#l-43.12)
aufgeschrieben, samt Ursache. **Die Ursache ist nach wie vor nicht behoben** —
das ist der dritte Fall.

**Zeile in die Tabelle gehoben** und um das ergänzt, was die Nachbarzeilen
führen: UTC-Zeit, Marke, Anhanggröße, SHA-256 und die drei enthaltenen
Fassungen. Nebenbefund: die Spalte *Zeit* trägt **Ortszeit** (`21:07:37`),
die Spalte *Ergebnis* die **UTC-Zeit** — das steht nirgends und ist nur aus
dem Vergleich zweier Zeilen zu erkennen.

---

## Die Seite nach außen

### <a id="l-49.8"></a>L-49.8 — `MELDUNGEN-VON-AUSSEN.md` sagte von sich selbst, sie sei auf Deutsch (mittel)

Der Kopf der englischen Datei schloss mit:

> … Those live in `BEFUNDE.md`, which every row links to. This file is the
> table of contents, not the case file. **It is in German**, as is the rest
> of the project documentation.

*„It"* liest sich als *„this file"* — und steht in einer Datei, die
durchgehend englisch ist und Fremden per Link gezeigt wird. Gemeint war
`BEFUNDE.md`. **Berichtigt**, und zugleich die Zusage entschärft, dass
*jede* Zeile auf einen Befund verlinke ([L-49.10](#l-49.10)).

### <a id="l-49.9"></a>L-49.9 — „both load paths read only up to `Bars`" — der zweite Ladeweg liest `Bars` überhaupt nicht (mittel)

Die Zeile `#102-3` begründete *„will not be fixed"* mit: *„both load paths
read only up to `Bars`, so the orphans are inert."* **Das Urteil stimmt, die
Begründung nicht.** Nachgelesen:

| Ladeweg | was er liest |
|---|---|
| `SECDockState::LoadState` → `CDockState::LoadState` (`mainfrm.cpp:888`) | liest `Bars` aus `[ToolBar-Summary]` und dann `Bar0`…`Bar(Bars-1)` — MFC 14.38, `dockstat.cpp:333-351`. **Trifft zu.** |
| `QCToolBarManager::LoadState` (`mainfrm.cpp:989`) | liest `[ToolBar-ToolBarManager]` und je **lebender** Leiste einen Abschnitt `[ToolBar-BarID<Steuerkennung>]` (`QCToolBarManager.cpp:1119-1210`). **`Bars` kommt darin nicht vor, `[ToolBar-BarN]` auch nicht.** |

Die verwaisten Abschnitte sind also wirklich unwirksam — aber weil der zweite
Lader sie gar nicht kennt, nicht weil er bei `Bars` aufhört. **Berichtigt**,
mit beiden Fundstellen. Die dritte geprüfte Behauptung stimmt wörtlich:
`CDockState::SaveState` schreibt `Bars=nIndex`, und `nIndex` zählt genau die
Abschnitte, die soeben geschrieben wurden (`dockstat.cpp:354-367`).

### <a id="l-49.10"></a>L-49.10 — der einzige offene Punkt gegenüber einem Fremden stand in keinem Befund und in keiner Arbeitsliste (hoch)

`MELDUNGEN-VON-AUSSEN.md` versprach im Kopf, die Messungen stünden in
`BEFUNDE.md`, *„which every row links to"*. Die Zeile `#102-4`
(`MRUFloatYPos=-682908189` in `[ToolBar-Bar10]`, Stufe **medium**, Status
*„not yet measured"*) verlinkt zwar auf [E-131](../BEFUNDE.md#e-131), **aber
dort stand der Fall nicht.** Gemessen: die Zeichenkette `682908189` kommt in
`BEFUNDE.md` **null** Mal vor, in `AUFGABEN.md` und `WEITERMACHEN.md`
ebenfalls nicht.

**Damit stand die einzige offene Zusage an einen Melder von außen in keiner
Arbeitsliste des Projekts** — sie existierte nur in der englischen Tabelle,
die wir ihm gezeigt haben.

Zwei Dinge getan:

1. **Der Fall ist in [E-131](../BEFUNDE.md#e-131) fortgeschrieben** — nicht als neuer Befund:
   `perl tools/befund-suchen.pl E131PositionIstBrauchbar` meldet [E-131](../BEFUNDE.md#e-131) als
   denselben Ort.
2. **Die offene Frage ist am Quelltext beantwortet:**
   `E131PositionIstBrauchbar` (`mainfrm.cpp:2773`) **fängt** den Wert. Die
   Regel verwirft jedes `nY < nOben - nHoehe + 100` (`:2797`); für
   `-682908189` ist das auf jedem wirklichen Bildschirm erfüllt. **Aber die
   Berichtigung läuft in `CMainFrame::SaveBarState`, also beim Schreiben** —
   die kaputte Zeile verschwindet erst, wenn unsere Fassung einmal beendet
   wurde, und wird bis dahin so geladen, wie sie dasteht. Das ist derselbe
   offene Leseweg, der in [E-131](../BEFUNDE.md#e-131) schon steht. In `MELDUNGEN-VON-AUSSEN.md`
   und in [E-131](../BEFUNDE.md#e-131) nachgetragen.

### <a id="l-49.11"></a>L-49.11 — „Bar10 ist die Suchleiste" ist im Repo nicht nachmessbar (niedrig, keine Änderung)

`MELDUNGEN-VON-AUSSEN.md` und `Releases/ISSUE-102-ABSCHLUSS.md` sagen dem
Melder, `[ToolBar-Bar10]` sei die Suchleiste (`IDC_SEARCH_BAR`, ID 1068).
`IDC_SEARCH_BAR` **ist** 1068 (`Eudora71/Eudora/resource.h:626`), und
`[ToolBar-BarN]` trägt den Schlüssel `BarID` (`dockstat.cpp:144`) — die
Aussage ist also prüfbar, **aber nur an seiner angehängten `Eudora.ini`, und
die liegt nicht im Repo.** Die Messung ist nirgends festgehalten; niemand
kann sie nachvollziehen. Nicht geändert, weil ich sie weder belegen noch
widerlegen kann — aufgeschrieben, damit sie beim nächsten Mal mit der
gemessenen Zeile (`BarID=1068`) belegt wird.

---

## Verweise

### <a id="l-49.12"></a>L-49.12 — ein Abschnitt, auf den drei Dateien verweisen, ist seit dem 14.09.2026 weg (mittel)

`README.md:680`, `EINSTELLUNGEN.md:49-50` und `FILTER.md:559-561` verwiesen
auf den README-Abschnitt ***Wo ein Schlüssel stehen muss***. `README.md:680`
tat es als **Link** (`#wo-ein-schlüssel-stehen-muss`), die beiden anderen als
Fließtext.

**Den Abschnitt gibt es nicht mehr.** Gemessen mit
`git log -S "### Wo ein Schlüssel stehen muss" -- README.md`: angelegt in
`a660b1bb`, **entfernt in `beecdb55` am 14.09.2026**. Der Link zeigt seit
**37 Tagen** ins Leere, und zwei weitere Dateien schicken den Leser an
dieselbe Stelle. Der Inhalt steht inzwischen in `EINSTELLUNGEN.md`, Regel
1.1 (die vier Nummernbereiche) und 1.2 (die vier Suchstufen).

**Alle drei berichtigt** und auf `EINSTELLUNGEN.md` umgehängt, mit dem
Vermerk, wann und wohin der Abschnitt verschwunden ist.

### <a id="l-49.13"></a>L-49.13 — der Verweisprüfer meldet mehr, als kaputt ist (zur Kenntnis)

Ein eigener Lauf über alle 163 `.md` (relative Ziele plus Anker) meldete 28
Fundstellen. Nachgesehen sind es:

* **eine echte**, dreifach: [L-49.12](#l-49.12);
* **eine kosmetische** in einem wörtlichen Zitat — `Befunde/PRUEFER-40.md:309`
  zitiert eine Zeile aus `CHANGELOG.md` samt ihrem Link
  `](BEFUNDE.md#e-131)`, der aus `Befunde/` heraus ins Leere zeigt. **Nicht
  geändert**: das Zitat soll wörtlich bleiben;
* **der Rest Fehlalarm.** Die Treffer in `Befunde/LEKTOR-27.md`,
  `LEKTOR-35.md`, `LEKTOR-44.md` und `tools/WERKZEUGE.md` stehen in
  Code-Auszeichnung und werden gar nicht als Link dargestellt; die
  Ankertreffer in `CHANGELOG.md` und `FILTER.md` kamen daher, dass mein
  Prüfmuster Gedankenstrich und Anführungszeichen als Wortzeichen behandelte.

**Die Verweise der Form `blob/main/<pfad>` sind alle heil** — gemessen mit
`git ls-tree origin/main`: `MELDUNGEN-VON-AUSSEN.md`,
`Releases/ISSUE-102-ABSCHLUSS.md`, `Releases/ISSUE-102-PLUGIN-NACHFRAGE.md`,
`BEFUNDE.md` und `TESTPLAN.md` stehen auf `main`. Der heute um 404 gelaufene
Link ist seit dem Merge von PR #128 gültig.

### <a id="l-49.14"></a>L-49.14 — `PORTIERUNG.md` sagte „nicht geschnürt", `PAKETE.md` „geschnürt" (niedrig)

`PORTIERUNG.md` führte 1.0.114 als *„nicht geschnürt und nicht
veröffentlicht"*. `Releases/PAKETE.md:216` nennt denselben Stand *„geschnürt
am 21.10.2026 … an Gregors Lauf gescheitert"*, `WEITERMACHEN.md` sagt
dasselbe, und das ZIP `Eudora72-1.0.114-release.zip` (9 380 859 Byte) liegt
im Hauptarbeitsbaum. **`PORTIERUNG.md` berichtigt.** Im selben Zug stand dort
1.0.119 falsch als eigenes Release — es hat keines, sein Stand steckt in
`v1.0.120`.

### <a id="l-49.15"></a>L-49.15 — `CHANGELOG.md` sagte nicht, dass 7.2.0.118 bis .120 draußen sind (mittel)

Der Abschnitt **7.2.0.117** trägt eine eigene Überschrift *Von Gregor
freigegeben* mit seinem Wortlaut und dem Datum. Die Abschnitte **7.2.0.118**,
**7.2.0.119** und **7.2.0.120** sagten **nichts** über eine
Veröffentlichung — obwohl alle drei in `v1.0.120` stecken. Wer den
`CHANGELOG` von oben liest, erfährt also, was sich geändert hat, aber nicht,
dass es draußen ist.

Dazu stand in der Fassungstabelle des Abschnitts 7.2.0.117 weiterhin
*„die Fassung, die veröffentlicht **wird**"* — Gegenwart, seit zwölf Stunden
überholt.

**Beides berichtigt:** ein Kasten über dem Abschnitt 7.2.0.120 mit Marke,
Uhrzeit, Anhanggröße, SHA-256, den drei enthaltenen Fassungen, Gregors
Freigabe und dem Verweis auf die neuen Notizen; die Tabellenzeile in die
Vergangenheit gesetzt.

---

## Prüfumfang — ehrlich gezählt

`git ls-files '*.md' | grep -v '^Arbeitsweise/'` ergab beim Start **163**
Dateien (jetzt 165, meine beiden neuen mitgezählt).

**Mechanisch über alle 163 gelaufen**, jede Datei einzeln angefasst:

* eigener Verweisprüfer — jeder relative Link und jeder Anker gegen
  `git ls-files` und die Überschriften der Zieldatei ([L-49.13](#l-49.13));
* Sweep auf Standaussagen: jede Datei, die *„veröffentlicht ist"*,
  *„neuestes Release"*, *„aktueller Stand"* oder *„Stand 7.2.0…"* sagt und
  dabei `1.0.120` **nicht** nennt — 39 Treffer, davon 35 in dauerhaft
  datierten Berichten unter `Befunde/`, vier nachgesehen
  (`CHANGELOG.md` → [L-49.15](#l-49.15), `Pruefung/PRUEFUNG-PAKET.md`,
  `tools/WERKZEUGE.md`, `Releases/ISSUE-102-ANTWORT.md` — die drei
  letzten in Ordnung);
* Sweep auf die Adressbuch-Verwechslung ([L-49.4](#l-49.4));
* die Schranken des Projekts: `doku-pruefen.pl` (39 Dateien),
  `pruefe-release-buchfuehrung.pl` (5), `befunde-verlinken.pl` (alle MDs in
  Wurzel, `tools/` und `Befunde/`), `pruefe-ini-abschnitte.pl`.

**Inhaltlich gelesen und beurteilt habe ich 23 Dateien** — nicht 163, und
das steht hier so, weil *„alle"* sonst eine Behauptung wäre
([Prüfumfang nicht von
Hand](../Arbeitsweise/pruefumfang-nicht-von-hand.md)):
`README.md`, `ZIEL.md`, `PORTIERUNG.md`, `WEITERMACHEN.md`, `AUFGABEN.md`,
`BEFUNDE.md` (die Abschnitte [E-47](../BEFUNDE.md#e-47), [E-131](../BEFUNDE.md#e-131), [E-132](../BEFUNDE.md#e-132), [E-133](../BEFUNDE.md#e-133)), `CHANGELOG.md`,
`TESTPLAN.md`, `EINSTELLUNGEN.md`, `FILTER.md`, `LEKTORAT.md`,
`MELDUNGEN-VON-AUSSEN.md`, `Releases/PAKETE.md`,
`Releases/ISSUE-102-ABSCHLUSS.md`, `Releases/ISSUE-102-ANTWORT.md`,
`Releases/1.0.114/RELEASE-NOTIZEN.md`, `Releases/1.0.117/RELEASE-NOTIZEN.md`,
`tools/RELEASES.md`, `tools/WERKZEUGE.md`, `Pruefung/PRUEFUNG-PAKET.md`,
`PRUEFUNG-BRANCH.md`, `Befunde/LEKTOR-48.md`, `Befunde/PRUEFER-40.md`.

**Nicht gelesen** sind vor allem die rund 100 Berichte unter `Befunde/` —
Fahrtenbücher, die für ihren Tag gelten und deren veraltete Standangaben
richtig sind. Sie sind mechanisch, nicht inhaltlich geprüft.

---

## Was ich selbst falsch gemacht habe

Beim Berichtigen von `BEFUNDE.md` habe ich den Ersatztext mit `local $/;`
eingelesen und danach `chomp` gerufen — bei undefiniertem `$/` tut `chomp`
**nichts**. Der Zeilenumbruch blieb im Ersatztext stehen und hat zwei
Tabellenzeilen zerrissen. Beim Reparaturversuch lief ein `print` in einem
`END`-Block, während `perl -i` die Ausgabe schon zurückgegeben hatte:
**`BEFUNDE.md` war danach 0 Byte.** Wiederhergestellt mit
`git checkout -- BEFUNDE.md`, Änderungen sauber neu gesetzt, Zeilenzahl gegen
`HEAD` geprüft (8668 gegen 8668) und die beiden Tabellenzeilen auf ihr
Abschlusszeichen `|` nachgesehen. Kein Verlust — aber genau der Fall aus
[Verwerfen nur mit
Zähler](../Arbeitsweise/verwerfen-nur-mit-zaehler.md), und der Grund, warum
nach **jedem** Schreibzugriff gemessen wird.

---

## Urteil

**Ja, die Papiere tragen** — nach diesen Berichtigungen. Zwei Dinge gehören
aber vor den nächsten Durchgang:

1. **Die Schranke aus [L-44.11](LEKTOR-44.md#l-44.11) fehlt zum sechsten
   Mal.** `pruefe-release-buchfuehrung.pl` prüft fünf Dateien
   (`README.md`, `AUFGABEN.md`, `WEITERMACHEN.md`, `Releases/PAKETE.md`,
   `tools/RELEASES.md`) und hat trotzdem **keinen** der fünf Fälle aus
   [L-49.1](#l-49.1) gesehen: `ZIEL.md` und `PORTIERUNG.md` stehen gar nicht
   in ihrer Liste, und die Sätze in `WEITERMACHEN.md:140` und
   `Releases/PAKETE.md:6` sind an ihr vorbeigelaufen. **Eine Schranke, die
   grün meldet, während fünf Dokumente dieselbe veraltete Nummer nennen, ist
   schlimmer als keine.**
2. **Die zehn verbliebenen Stellen zum „Adressbuch"** aus
   [L-49.4](#l-49.4) — davon sechs in bereits ausgelieferten
   Release-Notizen. Das ist Gregors Entscheidung, keine Lektoratsfrage.
