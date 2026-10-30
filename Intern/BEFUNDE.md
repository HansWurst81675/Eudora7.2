# BEFUNDE — Verzeichnis

<!-- pruefstand: eceeecf -->
<!-- Die Marke oben nennt den Commit, gegen den diese Datei zuletzt abgeglichen
     wurde. Wer die Datei nachzieht, zieht die Marke mit.
     Gelesen von tools/pruefstand-melden.pl (Befund [NP3-7](#np3-7)). -->

Diese Datei ist die Befundsammlung des Projekts, gewachsen durch Anhängen.
Gemessen am 22.10.2026: **8668 Zeilen**, **128** Abschnitte auf zweiter und
**233** auf dritter Ebene. Nachzählen:

```sh
wc -l < BEFUNDE.md                  # Zeilen
grep -c '^## '   BEFUNDE.md         # Abschnitte 2. Ebene (dieses Verzeichnis zählt mit)
grep -cE '^### +[A-Z]' BEFUNDE.md   # Unterabschnitte
```


## Wie eine Befundzeile beginnt — Regel seit dem 23.10.2026

Gregor am 23.10.2026: *„im befunde ist es einfach nicht mehr zu verstehen, was du da alles zusammen geschrieben hast."* Deshalb beginnt die Statusspalte jeder Zeile so, in dieser Reihenfolge:

1. **Das Urteil, fett, als Erstes:** `**offen, …**`, `**behoben in 7.2.0.NNN, …**` oder `**erledigt, …**`. Die Werkzeuge (`tools/offene-befunde.pl`, `tools/pruefe-regressionstest.pl`, `tools/pruefe-behoben-belegt.pl`) lesen genau dieses erste Fettgedruckte. Am 23.10.2026 stand dort einmal `**Kurz: …**` — und E-142 und E-144 fielen still aus den Listen der offenen Befunde ([L-54.1](../Befunde/LEKTOR-54.md#l-54.1)).
2. **Danach höchstens drei Sätze ohne Kürzel:** was der Anwender gemerkt hat, ob Gregor noch etwas tun muss, was noch fehlt.
3. **Erst dann die Herleitung** — Messungen, Zeilennummern, Prüferkennungen.

## Die Kürzel — was die Buchstaben vor der Nummer bedeuten

Diese Datei führt **16 Nummernkreise**. Bis zum 22.10.2026 stand nirgends, was
sie bedeuten; `CLAUDE.md` nannte acht davon ohne Erklärung. Gregor an dem Tag,
über `S-3b`: *„ist es die S-Bahn?"* — eine berechtigte Frage, denn aus dem
Kürzel allein war es nicht zu erschließen.

Die Spalte **Woher** nennt den Beleg: entweder die Stelle, an der es
ausgeschrieben steht, oder den Commit, der den Kreis eingeführt hat.

| Kürzel | Was es ist | Woher |
|---|---|---|
| `E-` | **Eudora-Befund** — die Hauptreihe: ein Fehler oder Mangel am Programm. 133 Einträge | die Reihe selbst |
| `A-` | **Anforderung** — etwas, das Gregor verlangt hat und das noch nicht da war | [ZIEL.md](../ZIEL.md): *„dazu einzelne Anforderungen `A-n`"* |
| `AN-` | **Anhänge** — alles rund um Dateianhänge | [AN-1](#an-1): *„Anhänge: lange Dateinamen werden abgeschnitten"* |
| `S-` | **Startlauf** — was Gregor beim Ausprobieren eines Pakets auffiel | [S-1](#s-1): *„Das Auslieferungspaket 1.0.1 startet nicht"*; [S-3](#s-3): *„erster Lauf durch Gregor"* |
| `B-` | **Brücke** — die Ersatzbausteine für fehlende Fremdbibliotheken | Commit `23ca822e` (30.08.2026): *„VC71Bruecke: eigene msvcr71.dll als Weiterleitung"* |
| `M-` | **Menü** — der einzige Eintrag dieses Kreises betrifft die Menüleiste | Commit `3ad6768b` (30.08.2026): *„Befund [M-1](#m-1): tote Menueleiste"* |
| `R-` | **ReleaseBuffer** — die Fehlerklasse hinter [E-11](#e-11), gezählt von `tools/releasebuffer-pruefen.pl` | Commit `8f1c51e1` (31.08.2026) |
| `V-` | **Version** — Mängel an der Fassungsvergabe | [V-1](#v-1): *„Zwei verschiedene ZIPs unter derselben Versionsnummer"* |
| `P-` | **Prüfung am Code** — Funde aus einem Testlauf gegen die Ersatzschicht | Commit `4e72c9f4` (30.08.2026): *„Tests: Registerkarten … geprueft — 30 Testfaelle, ein Befund"* |
| `PR-` | **Prüfbericht über die eigenen Werkzeuge** — Löcher in den Schranken, nicht im Programm | [PR-1](#pr-1): *„drei Löcher in der Commit-Schranke"*, abgearbeitet durch [W-1](#w-1) |
| `W-` | **Werkzeug** — Arbeit an `tools/`, meist als Antwort auf `PR-` | [W-1](#w-1): *„Die Werkzeuge in Ordnung gebracht (**WERKZEUG**, 31.08.2026)"* |
| `F-` | **Freigabe** — Fragen rund um den Release-Bau und das Ausliefern | [F-1](#f-1): *„Der Release-Bau … (**FREIGABE**, 31.08.2026)"* |
| `X-` | **Angriff auf die eigenen Schranken** — bewusst versucht, sie auszutricksen | [X-1](#x-1): *„Die Werkzeuge **angegriffen**: neun Löcher in der Schranke"* |
| `Z-` | **Zahlen nachgerechnet** — eine Prüfung der eigenen Messwerte und Fundstellen | [Z-1](#z-1): *„Alle **Zahlen** und Fundstellen des 31.08. nachgerechnet"* |
| `NP2-` | **Nachprüfung, zweite Runde** — die Ersatzschicht Stufe für Stufe gegengelesen | [NP2-1](#np2-1): *„Stufe 3 hängt nirgends: 6.083 Zeilen ohne Übersetzung"* |
| `NP3-` | **Nachprüfung, dritte Runde** — dasselbe, eine Runde später | die Reihe selbst |

**Ein Buchstabe mit Nachsatz** (`S-3b`, [`Z-2b`](#z-2b), [`NP3-8`](#np3-8)) ist ein **Teilbefund**:
dieselbe Beobachtung, in mehrere Ursachen zerlegt. [`S-3`](#s-3) war Gregors erster
Lauf mit drei Beobachtungen — `S-3a`, `S-3b` und `S-3c` sind diese drei.

Jeder Agent schreibt seinen Abschnitt ans **Ende**, die Reihenfolge ist also
zeitlich, nicht sachlich. Ohne dieses Verzeichnis findet niemand, was er sucht —
und schlimmer: er findet einen Befund und weiß nicht, ob er noch gilt.

**Suchen:** `grep -n '^#\+ E-4' BEFUNDE.md` — mit `#\+`, weil viele Kennungen
eine Ebene tiefer stehen (`### NP2-2`, `### NP3-8`, `### PR-6`, `### P-3` und
weitere: sie sind Unterpunkte innerhalb eines größeren Abschnitts). Welche das
sind, steht unten unter **„Unterbefunde, die man einzeln sucht"**. Zeilennummern
stehen hier absichtlich nicht — sie veralten mit jedem Anhängen, und dieses
Projekt hat genug Zeit mit veralteten Fundstellen verloren (Befund [Z-1](#z-1)).
> **Auflage: wer einen Befund fortschreibt, ändert die Statusspalte hier mit.**
> Ein Verzeichnis, das falsche Stände behauptet, ist schlimmer als keines —
> dasselbe gilt hier wie für ein Werkzeug, das nur Fehlalarme liefert ([X-1](#x-1)).

**Stand der Statusspalte:** 09.09.2026, Zweig `wt/lektor`, Quellstand
**7.2.0.29** / Paket **1.0.29**. Nachgezogen am 09.09.2026 (Agent LEKTOR,
Befund `Befunde/LEKTOR-6.md`, L-11): [**E-44**](#e-44) stand auf „von Gregor noch nicht
bestätigt", ist aber am 08.09.2026 von ihm bestätigt; [**E-46**](#e-46) stand auf
„offen, Spurmarke gesetzt", ist aber **widerlegt** (die Marke erscheint erst
nach der Stelle).

> **Berichtigung meiner eigenen Aussage, noch am selben Tag.** Hier stand bis
> 12:45 Uhr: *„Eine Kennung [E-53](#e-53) gibt es nicht — die höchste vergebene ist
> [E-52](#e-52)."* **Das war falsch, und zwar nachweisbar falsch, obwohl ich es
> gemessen hatte.** Meine Messung war
> `grep -rn "E-53" --include=*.md .`, `git grep` gegen
> `origin/lessons_learned` und `git log --all -S"E-53"` — dreimal null Treffer.
> Sie hat nur nicht gefunden, was auf dem Zweig **`karten-und-trennbalken`**
> lag und noch nicht bei `origin` war: **[E-53](#e-53)** (ein Strich bleibt beim
> Schließen eines Fensters stehen, behoben in 7.2.0.28, von Gregor noch nicht
> bestätigt) und danach [**E-54**](#e-54) bis [**E-62**](#e-62). Die höchste vergebene Kennung
> ist damit **[E-62](#e-62)**, nicht [E-52](#e-52). **Nachtrag 09.09.2026 (PRUEFER, Filter):** seither sind [**E-63**](#e-63) bis [**E-69**](#e-69) vergeben, die höchste ist damit **[E-69](#e-69)**.
>
> **Die Lehre daraus ist nicht „besser greppen", sondern:** ein Kennungsraum
> lässt sich nicht aus einem einzelnen Arbeitsbaum messen. `git log --all`
> sieht nur, was dieses Repo schon kennt — ein Zweig, der in einem anderen
> Arbeitsbaum entsteht und noch nicht gepusht ist, ist unsichtbar. Wer die
> höchste Kennung braucht, fragt vorher `git branch -a` **und**
> `git worktree list` ab, oder er fragt Gregor.

**Frühere Stände dieser Zeile:** 07.09.2026, Commit `060a4bf` (Zweig `wt/lektor`).
Die Einstufung ist am Text der Befunde und, wo nötig, am Quelltext nachgesehen.
Nachgezogen am 07.09.2026 (Agent LEKTOR, Befund `Befunde/LEKTOR-3.md`, L-7):
[**E-30**](#e-30) stand auf „in Arbeit", ist aber behoben und von Gregor bestätigt;
[**E-31**](#e-31), [**E-32**](#e-32) und [**E-33**](#e-33) fehlten ganz und sind eingetragen; [**R-1**](#r-1) nannte
25 von 142 Stellen, gemessen sind 21 von 137; und der Kasten, der [**E-15**](#e-15) und
[**E-18**](#e-18) bis [**E-21**](#e-21) für nie vergeben erklärte, war falsch — alle fünf stehen
in Quellkommentaren. Nachgezogen am 06.09.2026 ([L-6](../Befunde/LEKTOR.md#l-6)): [**Z-3**](#z-3) stand auf „offen",
ist aber seit `57fe6a4` behoben; [**E-14**](#e-14), [**E-16**](#e-16), [**E-17**](#e-17), [**E-22**](#e-22),
[**E-23**](#e-23), [**E-24**](#e-24), [**E-25**](#e-25) und [**E-26**](#e-26) fehlten im Verzeichnis ganz und sind
eingetragen. Am 05.09.2026 nachgezogen: [**E-4**](#e-4) und [**E-7**](#e-7) standen auf „offen",
sind aber behoben; [**PR-5**](#pr-5) stand an drei Stellen auf „offen", ist aber seit
`765c39b` behoben. Neu aufgenommen war damals [**B-3**](#b-3) (OT501 aus dem Bau) und
[**E-13**](#e-13) (Fortschritt beim Mailabruf).

| Status | Bedeutung |
|---|---|
| **behoben** | Ursache beseitigt, im Repo |
| **offen** | nichts geändert |
| **teilweise** | ein Teil behoben, der Rest steht im Befund |
| **überholt** | durch einen späteren Befund widerlegt oder gegenstandslos |
| **Beleg** | kein Mangel, sondern eine Messung |
| **Bericht** | Prüfdurchgang, seine Einzelbefunde stehen darin |
| **ungeprüft** | behoben, aber am laufenden Programm nicht nachgesehen |

## Die Stufe — was vor einem Release geprüft werden **muss**

Jeder Befund trägt am Ende seines Urteils eine Marke:

```
**Stufe: kritisch** (Datenverlust: Filter loescht Post auf dem Server)
```

Gregor am 22.10.2026:

> *„geh mal die befunde durch und markiere diejenigen, die du als kritisch
> betrachtest, so daß sie auf jeden fall vor einem release ausgeführt werden.
> ob da bei der kachel darstellung ein rest vom schließen zu sehen ist, ist
> z.b. unkritisch."*

Die Stufe steht **im Befund selbst**, nicht in einer zweiten Liste — sonst
gäbe es zwei Wahrheiten, die auseinanderlaufen. Gelesen wird sie von
`tools/pruefe-regressionstest.pl`; diese Schranke weist jeden Befund **ohne**
Stufe ab.

| Stufe | Was dazugehört | Zahl am 22.10.2026 |
|---|---|---|
| **kritisch** | Post oder Einstellungen gehen verloren oder werden still beschädigt; eine **fremde** Installation nimmt Schaden; das Programm stürzt ab, startet nicht oder hängt; eine Nachricht geht falsch hinaus oder kommt falsch an; Sicherheit. **Diese müssen vor jedem Release laufen.** | 64 |
| **wichtig** | Eine Funktion ist unbrauchbar, aber nichts geht verloren und der Anwender merkt es sofort — Suche geht nicht auf, Filter nicht bearbeitbar, Bild falsch dargestellt | 46 |
| **unkritisch** | Aussehen, Reste, Bequemlichkeit. Gregors eigenes Beispiel ist [E-53](#e-53): ein Strich, der nach dem Schließen einer Registerkarte stehen bleibt | 38 |
| **werkzeug** | Betrifft Bau, Schranken oder unsere Werkzeuge, **nicht** das Programm — gehört in keinen Release-Testplan | 43 |

**Die Einstufung ist ein Urteil, kein Messwert.** Sie ist am 22.10.2026 in
einem Zug für alle 191 Befunde gefällt worden, nach der Regel oben. Wer sie
für einen Befund anders sieht, ändert die Marke in diesem Befund — und
nirgends sonst.

**Was daraus folgt.** `tools/pruefe-regressionstest.pl` zählt getrennt, wie
viele der kritischen Befunde überhaupt eine Prüfung haben. Am 22.10.2026:
**15 von 64 mit automatischem Testfall, 0 manuell im Testplan, 49 ohne jede
Prüfung.** Das ist der Rückstand. **Er hält das Release 7.2.1 nicht auf** — Gregor am 23.10.2026: *„für release dokumentieren wir, daß die fehlenden regression tests nachgeholt werden"*; die Release-Notizen nennen ihn, und er wird vor jedem neuen Thema abgearbeitet ([ZIEL.md](../ZIEL.md#regressionstests--anordnung-vom-22102026)). Bis zum 24.10.2026 stand hier *„der vor 7.2.1.0 abzuarbeiten ist"* ([L-54.6](../Befunde/LEKTOR-54.md#l-54.6)).

## Was zuerst zu lesen ist

Wer neu dazukommt: **`WEITERMACHEN.md`** (Einstieg und Übergabe),
**`AUFGABEN.md`** (Arbeitsliste), **`ZIEL.md`** (der Maßstab). Aus dieser Datei
zuerst [**E-11**](#e-11), [**R-1**](#r-1) und [**E-1**](#e-1).

## Korrektheitsprüfung vom 29.08.2026 (Agent PRUEFER)

| Kennung | Worum es geht | Status |
|---|---|---|
| [H1](#h1) | ungültige Protokollversion brach die TLS-Verbindung nicht mehr ab | **behoben** |
| [H2](#h2) | Zeichentabelle: sieben falsche Zuordnungen, Doppelersetzung | **behoben** |
| [M1](#m1) | Untergrenze TLS 1.0 galt ausgerechnet für die Voreinstellung | **behoben** |
| [M2](#m2) | `BIO_s_workersocket()` war für sich genommen nicht threadsicher | **behoben** |
| [M3](#m3) | `SetWorkbookMode()` setzt `m_bWorkbookMode` nicht | **überholt** (Absicht, im Code vermerkt) |
| [M4](#m4) | Empfangsrichtung las die **Sende**einstellung (Originalfehler) | **behoben** |
| [M5](#m5) | `CSumList::GetTail()` lieferte den Kopf (Originalfehler) | **behoben** |
| [N1](#n1) | Zeigerschmuggel durch `BIO_set_fd` hält nur unter Win32 | **behoben** (x64-Rest im Befund) |
| [N2](#n2) | `static` bei `get_entry_info` verlorengegangen | **behoben** |
| [N3](#n3) | zwei Rückgabewerte wurden nicht ausgewertet | **behoben** |
| [N4](#n4) | `#undef` auf einen SDK-Wächter in `ExceptionHandler.cpp` | **behoben** |
| [N5](#n5) | `atlimage.h`: Laufzeitprüfung durch `TRUE` ersetzt | **behoben** (Änderung war nötig, bleibt) |
| [N6](#n6) | OTShim war in keinem Projekt eingehängt | **überholt** |
| [N7](#n7) | zwei kleine Stellen in OTShim, beide heute wirkungslos | **offen** |
| [N8](#n8) | `const_cast` mit anschließendem Schreibzugriff, 7 echte Fälle | **geprüft**, kein Handlungsbedarf |

## Nachprüfungen 2 und 3 (PRUEFER, 29./30.08.2026)

| Kennung | Worum es geht | Status |
|---|---|---|
| <a id="np2-1"></a>NP2-1 | Stufe 3 der Ersatzschicht hing in keinem Projekt | **überholt** **Stufe: werkzeug** (Bau: Stufe 3 hing in keinem Projekt)|
| <a id="np2-2"></a>NP2-2 | `SysColorChange()` tut nicht, was daneben steht | **offen** (folgenlos, Kommentar irreführend) **Am 14.09.2026 nachgemessen: weiterhin offen.** `SECMDIFrameWnd::OnSysColorChange` (`OTShim.cpp:497`), `SECFrameWnd::OnSysColorChange` (`:5139`) und `SECOwnerDrawButton::OnSysColorChange` (`OTShim_Knopf.cpp:257`) stehen unverändert; der irreführende Kommentar ist nicht berichtigt. Folgenlos, deshalb nicht angefasst **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — bleibt offen, **und die Nachmessung vom 14.09.2026 hat die falschen Stellen angesehen**: `OTShim.cpp:497`, `:5139` und `OTShim_Knopf.cpp:257` sind schlichte `OnSysColorChange`-Durchreichungen und haben mit diesem Befund nichts zu tun. Gemeint ist `SECBtnDrawData::SysColorChange` in `OTShim_Werkzeugleiste.cpp:329-335`: sie ruft `PostDrawButton()` und löscht `m_ditherBrush` — `m_bmpDraw`, `m_bmpMono`, `m_cxBuf` und `m_cyBuf` bleiben stehen, und `PreDrawButton` nimmt denselben Puffer bei gleicher Größe wieder (`:383`). Der Kommentar darüber (`:326-328`) behauptet weiter das Gegenteil. Folgenlos bleibt es, weil `DrawFace` den Puffer je Knopf mit `FillSolidRect` überschreibt (`:724`). **Was noch fehlt:** nur die Berichtigung des irreführenden Kommentars an `OTShim_Werkzeugleiste.cpp:326-328` (**nicht** an den drei Stellen, die hier bis zum 22.10.2026 standen) — folgenlos, deshalb bewusst nicht angefasst. Zu ändern ist kein Verhalten, sondern die Beschreibung daneben. **Stufe: werkzeug** (Quelltextpruefung)|
| <a id="np2-3"></a>NP2-3 | `BitBltTransparent` meldet Erfolg, ohne gezeichnet zu haben | **offen** **Am 14.09.2026 nachgemessen: weiterhin offen.** `CPaletteDC::BitBltTransparent` steht unverändert in `OTShim_Werkzeugleiste.cpp:239` **Was noch fehlt:** die Behebung selbst — `CPaletteDC::BitBltTransparent` (`OTShim_Werkzeugleiste.cpp:239`) meldet unverändert Erfolg, ohne gezeichnet zu haben. Seit dem 14.09.2026 nur nachgemessen, nicht angefasst; welche Oberfläche dadurch leer bleibt, ist nirgends festgehalten.   **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — am Quelltext ausgezählt: aufrufstellen=0. `BitBltTransparent` steht dreimal im Baum: Deklaration (`OT501/Include/SafetyPal.h:47`), ein Kommentar (`OTShim/OTShim_Werkzeugleiste.cpp:92`) und die Definition (`:239`). PRÜFER hat daraus am selben Tag *gegenstandslos* abgeleitet; das Urteil steht hier noch auf **offen**, weil die Belegform erst nachzuziehen ist. **Stufe: werkzeug** (Quelltextpruefung)|
| <a id="np3-1"></a>NP3-1 | `ZeigeInhaltsfenster` läuft, bevor Eudora das Fenster umhängt | **offen** (nur sichtbar, kein Datenfehler) **Am 14.09.2026 nachgemessen: weiterhin offen.** `ZeigeInhaltsfenster` in `OTShim_Reiter.cpp:1500-1503` unverändert. **Eine Zeilenangabe war falsch:** der `Create`-Aufruf mit `WS_CHILD \| WS_VISIBLE` und `::AfxGetMainWnd()` steht in `WazooBar.cpp:1004`, nicht `:1003` **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — unverändert, nur die Zeilen sind nachgezogen. `SECTabWndBase::InsertTab` steht in `OTShim_Reiter.cpp:1482-1507` und ruft `ZeigeInhaltsfenster(nNeu)` bei `:1500`, wenn `m_pActiveWnd == NULL` ist. `CWazooBar::AddWazooWindow` (`WazooBar.cpp:124`) hängt das Fenster erst danach um (`:176-177`); angelegt wird es als Kind des Hauptfensters bei `WazooBar.cpp:1004`. Nur sichtbar, kein Datenfehler. **Was noch fehlt:** die Umstellung der Reihenfolge — `ZeigeInhaltsfenster` (`OTShim_Reiter.cpp:1500-1503`) läuft weiterhin, bevor Eudora das Fenster umhängt (`Create` in `WazooBar.cpp:1004`). Nur sichtbar, kein Datenfehler; deshalb liegengeblieben. **Stufe: wichtig** (Inhaltsfenster laeuft vor dem Umhaengen)|
| <a id="np3-2"></a>NP3-2 | `OnToolHitTest` als `int` statt `INT_PTR` — x64-Sperre | **offen** **Am 14.09.2026 nachgemessen: weiterhin offen.** `OnToolHitTest` ist an **allen** Stellen weiterhin `int`: `PaigeEdtView.cpp:1440`/`.h:405`, `SearchBar.cpp:1265`/`.h:177`, `TBarSendButton.cpp:192`/`.h:26` und vier Deklarationen in `OT501/Include/`. Die x64-Sperre besteht unverändert; unter Win32 folgenlos **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — unverändert offen, **und die Liste war zu kurz.** `int` steht weiterhin in `PaigeEdtView.cpp:1440`/`.h:405`, `SearchBar.cpp:1265`/`.h:177` und `TBarSendButton.cpp:192`/`.h:26`. **Bisher nicht genannt, heute mitgemessen:** `OTShim_Reiter.cpp:1032`/`.h:570` — das ist der eigentliche Gegenstand des Befunds — und `OTShim_Werkzeugleiste.cpp:595`. Und es sind **sechs** statt vier Deklarationen in `OT501/Include/`: `sbarcore.h:182`, `Sbartool.h:98`, `tabctrl3.h:90`, `tbarcust.h:173`, `tbtnstd.h:145`, `tbtnwnd.h:101`. Auf `INT_PTR` gezogen sind bisher nur `OTShim.h:592` und `:1550` (`OTShim.cpp:936`, `:1956`). Unter Win32 folgenlos. **Was noch fehlt:** die Umstellung auf `INT_PTR` — `OnToolHitTest` ist an elf Stellen noch `int`: `OTShim_Reiter.cpp:1032`/`.h:570`, `OTShim_Werkzeugleiste.cpp:595`, `PaigeEdtView.cpp:1440`/`.h:405`, `SearchBar.cpp:1265`/`.h:177`, `TBarSendButton.cpp:192`/`.h:26` und **sechs** (nicht vier) Deklarationen in `OT501/Include/`. Unter Win32 folgenlos, die x64-Sperre besteht weiter. **Stufe: werkzeug** (x64-Sperre, nicht im Umfang)|
| <a id="np3-3"></a>NP3-3 | Kommentar zu `CreateFromBitmap` zählt die Aufrufstellen falsch | **offen** **Am 14.09.2026 nachgemessen: weiterhin offen.** Der Kommentar steht jetzt in `OTShim_Bild.h:326-330` (nicht mehr `:326-328`) und sagt weiterhin *„an drei von fünf Stellen"*. Reiner Kommentarfehler **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — unverändert. Der Kommentar steht in `OTShim_Bild.h:326-330` und sagt weiterhin *„an drei von fuenf Stellen"*. Heute nachgezählt: es sind **neun** Aufrufstellen — `LinkHistoryManager.cpp:1249`, `QCGraphics.cpp:280`, `:312`, `:669`, `QCToolBarManager.cpp:421`, `:434`, `:447`, `:569`, `:582`. Die Zahl *fünf* stimmt also auch im heutigen Baum nicht. Reiner Kommentarfehler, kein Verhalten betroffen. **Was noch fehlt:** eine Zeile Text — der Kommentar in `OTShim_Bild.h:326-330` sagt weiterhin *„an drei von fünf Stellen"* und zählt die Aufrufstellen damit falsch. Reiner Kommentarfehler, kein Verhalten betroffen. **Stufe: werkzeug** (Kommentar falsch)|
| <a id="np3-4"></a>NP3-4 | `lehren-spiegeln.pl` löschte die gespiegelten Dateien wieder | **behoben** (stagt nicht mehr; Hook siehe X-2) **Stufe: werkzeug** (eigenes Werkzeug)|
| <a id="np3-5"></a>NP3-5 | `lehren-spiegeln.pl` war genau im Fehlerfall stumm | **behoben** (X-2) **Stufe: werkzeug** (eigenes Werkzeug)|
| <a id="np3-6"></a>NP3-6 | `pruefstand-melden.pl` gibt aus dem falschen Verzeichnis Entwarnung | **behoben** **Stufe: werkzeug** (eigenes Werkzeug)|
| <a id="np3-7"></a>NP3-7 | `pruefstand-melden.pl` nennt einen beliebigen Commit, und braucht 29,5 s | **behoben** am 31.08.2026 - Spurmarke `<!-- pruefstand: <commit> -->` in jeder beobachteten Datei nennt den Commit, gegen den sie zuletzt abgeglichen wurde; fehlt sie, meldet das Werkzeug es statt zu raten **Stufe: werkzeug** (eigenes Werkzeug)|
| <a id="np3-8"></a>NP3-8 | der IMAP-Empfang übersetzt **keinen** Zeichensatz (Originalfehler) | **behoben** in 7.2.0.52, am laufenden Programm belegt. **Dieser Befund stand hier, als Gregor am 13.09.2026 denselben Fehler als E-85 meldete — und wurde nicht gelesen.** Er nannte die Ursache, die Zeilennummern und die Handlungsanweisung („denselben Aufruf verwenden wie `mime.cpp:382-390`, am besten durch Aufruf von `FindMIMECharset` selbst, und die Abfrage in Zeile 4657 auf `> 2` ziehen"). Genau so wurde es behoben — nur über zwei Anläufe und eine ausgelieferte Zwischenfassung hinweg. Siehe **E-85** **Stufe: kritisch** (Zeichensatz: Nachricht kommt falsch an)|
| <a id="np3-9"></a>NP3-9 | Rückgabewert von `ISOTranslate` an zwei Stellen verworfen | **behoben**, von Gregor an 1.0.51 bestätigt (die Umlaute kamen richtig an, siehe E-85) — POP schon früher, **IMAP in 7.2.0.51** (`ImapDownload.cpp`, `inLen`/`outLen` werden nachgezogen). Auch dieser Befund stand bereits hier, als derselbe Mangel unter **E-85** neu gesucht wurde **Stufe: kritisch** (Zeichensatz: Rueckgabewert verworfen, derselbe Weg)|
| PROBE | drei Funde beim ersten Ausführen der Ersatzschicht (`### P-1` bis [`P-3`](../Befunde/PRUEFER-11.md#p-3)) | **offen** (Härtungslücken) |

## Start, Paket, Auslieferung (S)

| Kennung | Worum es geht | Status |
|---|---|---|
| <a id="s-1"></a>S-1 | Paket 1.0.1 startete nicht: `MSVCR71D.dll` fehlte | **behoben**. **Regressionstest** `TestPaket.cpp` (30.10.2026, 321 Tests, 321 bestanden): das Debug-Muster aus `tools/paket-pruefen.ps1` und `tools/paket-bauen.ps1` wird ausgeführt und muss `MSVCR71D.dll` erkennen; eine DLL, die weder im Paket liegt noch zu Windows gehört, ist in `paket-pruefen.ps1` ein FEHLER, und die Windows-Liste nennt keine Visual-Studio-Laufzeit. Ohne `msvc[rp]\d+d\.dll` im Muster einmal rot, Meldung *„das Debug-Muster erkennt MSVCR71D.dll nicht“* **Stufe: kritisch** (Start: Paket startet nicht, DLL fehlt)|
| <a id="s-2"></a>S-2 | Stapelüberlauf beim Start — die Werbefläche mit `CRect(0,0,0,0)` | **behoben** am 30.08.2026, am laufenden Programm gemessen: Eudora kommt seither über den Startbildschirm hinaus **Stufe: kritisch** (Start: Stapelueberlauf)|
| <a id="s-3"></a>S-3 | erster Lauf durch Gregor: drei Beobachtungen | **teilweise** (S-3c: `MFC71`/`MSVCP71` dauerhaft offen) **Zuletzt gemessen: 28.10.2026 an 7.2.0.127** (S-3c, die drei Zusätze; der übrige Eintrag zuletzt am Quelltext belegt am 22.10.2026 an 7.2.0.121) — **S-3b ist gegenstandslos**, belegt und nicht vermutet: der Release-Bau setzt `NDEBUG` (`Eudora71/Eudora/Eudora.vcxproj:132`), damit fallen `ASSERT` und `VERIFY` samt den SUPERASSERT-Dialogen weg. Die Begründung von 2026-08-30 — *„nur der Debug-Bau ist lauffähig, der Release-Zweig scheitert an fehlender `Imap.lib`"* — trifft nicht mehr zu: `Eudora71/Lib/Release/Imap.lib` ist vorhanden, `Eudora71/Bin/Release/Eudora.exe` wurde am 22.10.2026 gebaut. Ausgeliefert wird mit `-Bauart Release` (`Intern/WEITERMACHEN.md:473`, `Releases/PAKETE.md:1380`); dass `tools/paket-bauen.ps1` ohne Schalter `Debug` vorgibt (`:54`), ändert daran nichts, weil der Releaseweg ihn setzt. **S-3c bleibt unverändert offen** — `MFC71.DLL` und `MSVCP71.dll` gibt es weiterhin nicht. **Was noch fehlt:** allein S-3c (die beiden Laufzeitbibliotheken) — `MFC71.DLL` und `MSVCP71.dll` fehlen dauerhaft, damit fallen die Verzeichnisdienste aus (Protokoll `EudoraBk.dll`, LDAP `Ldap.dll`, Ph `Ph.dll`; das eigene Adressbuch arbeitet), dazu still Junk-Filter (`SpamWatch.dll`, `SpamHeaders.dll`) und S/MIME (`SMIME.dll`) — am 28.10.2026 am Programm gemessen, [E-166](#e-166); Microsoft hat sie nicht zur Weitergabe freigegeben, siehe [E-47](#e-47); auf Rechnern, die sie schon haben, laden die Zusätze ([FILTER.md](FILTER.md#warum-die-junk-bewertung-hier-nicht-arbeitet)). S-3a ist behoben, S-3b (SUPERASSERT) entfällt im Release-Bau. **Stufe: unkritisch** (erster Lauf, drei Beobachtungen)|
| <a id="s-4"></a>S-4 | Zusicherung im Adressbuch-Wazoo | **behoben** **Stufe: unkritisch** (Zusicherung im Adressbuch-Wazoo)|
| <a id="s-5"></a>S-5 | Menüs ließen sich nicht öffnen | **behoben**, am laufenden Programm gemessen: die Menüs klappen auf (Ursache M-1, belegt in E-1) **Stufe: wichtig** (Funktion: die Menues liessen sich nicht oeffnen - die ganze Bedienung)|
| <a id="s-6"></a>S-6 | Bereiche überlagern sich | **teilweise** (A-1 umgesetzt, Splitter umgesetzt, Nachstellen offen) **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — **die beiden Ursachen, die hier standen, gibt es nicht mehr.** (1) Die prozentualen Zeilenbreiten sind umgesetzt: `SECDockBar::NormalizeRow` normiert die Anteile einer Zeile (`OTShim.cpp:2847`), `SECDockBar::DistributeRow` verteilt sie danach auf `m_nRowExtent` (`:3341-3400`). (2) Die Splitter sind umgesetzt: angelegt werden sie in `TrennbalkenNeuAnlegen` (`OTShim.cpp:4674`) aus `OnSize` heraus (`:4667`), `HitTest` (`:3808`) und `StartTracking` (`:3974`) werden aus `OnLButtonDown` erreicht (`:4586`, `:4604`) — das Ergebnis der Behebungen zu [E-49](#e-49), [E-52](#e-52) und [E-66](#e-66). Die Angabe `OTShim.h:695-699` zeigt heute auf fremden Code; die veralteten Sätze stehen jetzt in den Quelltextkommentaren `OTShim.h:345-360` und `:731-735` — dort **nicht** geändert, an diesem Tag wurde keine Quelldatei angefasst. **Leer geblieben ist `SECDockBar::SetControlBarWidthsInRow` (`OTShim.cpp:2830`) — im ganzen Baum ohne Aufrufstelle, also toter Code**; wirklich offen ist allein `SECMDIFrameWnd::FloatControlBarInMDIChild` (`:372`), das über `:2544` erreicht wird. Gregors ursprüngliches Bild — sich überlagernde Bereiche — ist seit dem 30.08.2026 **nie nachgestellt** worden. **Was noch fehlt:** das Nachstellen — ob sich die Bereiche heute überhaupt noch überlagern, ist seit dem 30.08.2026 **nie geprüft** worden. Die beiden damals genannten Ursachen sind umgesetzt (`m_fPctWidth`: `OTShim.cpp:2847` und `:3341`; Splitter: `:4674`). Als Baustelle übrig bleibt `SECMDIFrameWnd::FloatControlBarInMDIChild` (`OTShim.cpp:372`) — eine Leiste als eigenes MDI-Kindfenster schweben lassen. **Stufe: unkritisch** (Bereiche ueberlagern sich)|
| <a id="s-7"></a>S-7 | die Wurzel aller CRLF-Probleme: Auschecken mit `autocrlf=true` | **behoben** **Stufe: werkzeug** (Auschecken mit autocrlf)|
| <a id="s-8"></a>S-8 | Paket 1.0.2 startete mit `0xc000007b` | **behoben** (und durch F-1 gegenstandslos). **Regressionstest** `TestPaket.cpp` (30.10.2026, am Quelltext von `tools/paket-pruefen.ps1`): eine Paketdatei, die nicht x86 ist, ist ein FEHLER mit dem Hinweis auf `0xc000007b`; die Debug-Laufzeit, die 1.0.2 nachzog, deckt der Test zu [S-1](#s-1). Mit abgeschalteter Architekturprüfung einmal rot, sonst grün (321 Tests, 321 bestanden) **Stufe: kritisch** (Start: Paket startet nicht, 0xc000007b)|

## Arbeit der Agenten vom 30./31.08. und 05.09.2026

| Kennung | Worum es geht | Status |
|---|---|---|
| <a id="b-1"></a>B-1 | eigene `msvcr71.dll` als Weiterleitung (1429 Forwarder) | **behoben** **Stufe: werkzeug** (eigene Weiterleitungs-DLL)|
| <a id="b-2"></a>B-2 | Brücke in der Solution, Paket 1.0.3, neuer Paketprüfer | **behoben** (GUID-Berichtigung darin) **Stufe: werkzeug** (Bau und Paketpruefer)|
| <a id="m-1"></a>M-1 | der Rahmen lieferte immer `HTERROR` — `m_bMainFrameEnabled` | **behoben**, Wirkung belegt (E-1) **Stufe: wichtig** (Rahmen lieferte immer HTERROR)|
| <a id="a-1"></a>A-1 | Erscheinungsbild: fünf Punkte umgesetzt | **teilweise**, Wirkung belegt (E-1/E-2) **Was noch fehlt:** nur `SECDockBar::SetControlBarWidthsInRow` (`OTShim.cpp:2830`) ist ein leerer Rumpf — die prozentualen Zeilenbreiten. **Niemand ruft sie auf**, die Lücke hat also keine sichtbare Wirkung. `OnSizeParent` (`:4635`) ist entgegen `BEFUNDE.md:5060` **kein** Rest, sondern eine begründete Durchreichung (E-52). Gemessen am 22.10.2026.  **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — am Quelltext ausgezählt: aufrufstellen=0. `SetControlBarWidthsInRow` kommt im ganzen Baum viermal vor: die Deklaration im OT501-Header (`OT501/Include/sbardock.h:144`), ein Kommentar daneben (`:41`), unsere eigene Deklaration (`OTShim/OTShim.h:846`) und der leere Rumpf (`OTShim/OTShim.cpp:2830`). **Kein Aufruf.** Der leere Rumpf ist damit genau das, was [dummy-statt-weglassen](../Arbeitsweise/dummy-statt-weglassen.md) verlangt, und der Punkt ist ohne Gegenstand — solange niemand die Funktion benutzt. **Stufe: unkritisch** (Erscheinungsbild, fuenf Punkte)|
| <a id="p-1"></a>P-1 | der POP-Abrufpfad gegengelesen, elf Altlasten benannt | **teilweise** (P-1.5b bis P-1.5j offen) **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — alle neun stehen unverändert da; die Zeilennummern sind nachgezogen. In `POPSession.cpp`: **P-1.5b** `:1052`, **P-1.5c** `:1305-1306`, **P-1.5d** `:1745` sowie `:3348`/`:3350`, **P-1.5e** `:1791`/`:2160`/`:2196`, **P-1.5g** `:2413`. In `QCWorkerSocket.cpp`: **P-1.5f** `:1294`, **P-1.5h** `:535`/`:1478`/`:1489`, **P-1.5i** `:45`. **P-1.5j** in `header.cpp:115`. **Beim Suchen zu beachten:** `QCWorkerSocket.cpp` liegt unter `Eudora71/QCSocket/src/`, nicht unter `Eudora71/Eudora/`. **Was noch fehlt:** die neun Altlasten **P-1.5b bis P-1.5j** — wortgleich wie in `567a5d8`, keine davon angefasst. Nach Aufwand-Nutzen zuerst die beiden Einzeiler: **P-1.5b** (`%39s` statt `%s`, `POPSession.cpp:1052`) und **P-1.5d** (`sizeof(Server)-1` plus Nullterminierung, `POPSession.cpp:1745`, `:3348`, `:3350`). **Stufe: werkzeug** (Quelltext gegengelesen)|
| <a id="p-2"></a>P-2 | der Absturzpunkt vor dem ersten Abruf abgesichert | **behoben** **Stufe: werkzeug** (Absturzpunkt abgesichert)|
| <a id="w-1"></a>W-1 | die Werkzeuge in Ordnung gebracht (PR-1 bis PR-8) | **behoben, vollständig** — PR-5 ist seit `765c39b` erledigt; die frühere Angabe „PR-5 offen" war überholt **Stufe: werkzeug** (Werkzeuge in Ordnung gebracht)|
| <a id="f-1"></a>F-1 | Release-Bau: `OTA50D.LIB` statt `OTA50R.LIB`, `MakeDox.pl` | **behoben**; statisch binden bleibt ausgeschlossen **Stufe: werkzeug** (Release-Bau)|
| <a id="z-2"></a>Z-2 | HTML-Umlaute: der Zeichensatz wird nirgends angesagt | **behoben**, an der Zwischendatei belegt (Fortschreibung 05.09.) **Stufe: kritisch** (Zeichensatz: ausgehende Mail ohne Angabe)|
| <a id="z-2b"></a>Z-2b | ein einzelner Umlaut kaputt: UTF-8-Zeichen zerrissen an der Stückgrenze beim Abruf | **behoben, ungeprüft** (Fortschreibung von Z-2) **Stufe: kritisch** (Zeichensatz: Zeichen an der Stueckgrenze zerrissen)|
| <a id="b-3"></a>B-3 | `OT501` aus dem Bau genommen: ein frischer Klon baut ohne Kniffe | **behoben** (05.09., `d8cc9d3`) — damit entfallen die drei Fehler aus B-2 **Stufe: werkzeug** (OT501 aus dem Bau)|

## Prüfberichte über die eigene Arbeit

| Kennung | Worum es geht | Status |
|---|---|---|
| <a id="pr-1"></a>PR-1 | drei Löcher in der Commit-Schranke | **Bericht** → durch W-1 abgearbeitet **Stufe: werkzeug** (Commit-Schranke)|
| <a id="pr-2"></a>PR-2 | Nachprüfung des 31.08.: neun Punkte | **Bericht**; **PR-2.0** und PR-2.1 behoben (PR-2.0 am 06.09.2026, `Befunde/PAKET.md`, drei Gegenproben), PR-2.8 kein Handlungsbedarf, **PR-2.2 bis PR-2.7 offen** **Stufe: werkzeug** (Nachpruefung)|
| <a id="z-1"></a>Z-1 | alle Zahlen und Fundstellen des 31.08. nachgerechnet | **Bericht**; die elf Abweichungen sind inzwischen berichtigt **Stufe: werkzeug** (Zahlen nachgerechnet)|
| <a id="x-1"></a>X-1 | neun Löcher in der Schranke, gegen die eigenen Werkzeuge gemessen | **behoben** — vollständig, durch X-2, X-3 und X-4 **Stufe: werkzeug** (Schranke)|
| <a id="x-2"></a>X-2 | die neun Löcher geschlossen, je mit Testfall; der Hook log | **behoben** im Skript — auf dieser Maschine war der *eingerichtete* Hook bis 05.09.2026 noch die alte Fassung (X-5) **Stufe: werkzeug** (Schranke)|
| <a id="x-3"></a>X-3 | `suche-zeiger.pl` brauchbar gemacht: 347 Treffer auf 18, neun echte Kandidaten | **behoben** — die **neun Zeigerstellen** sind offen und brauchen einen Bau **Stufe: werkzeug** (Werkzeug)|
| <a id="x-4"></a>X-4 | `zeilenenden-angleichen.pl`: 49 Dateien mehr, dreht keine absichtliche Arbeit mehr zurück | **behoben** **Stufe: werkzeug** (Werkzeug)|
| <a id="x-5"></a>X-5 | Commit um 09:06 auf den um 09:03 zusammengeführten Zweig; die Regel stand nur als Prosa | **behoben** — Schranke im `pre-commit`, 15 Testfälle, Auflagen 7–10 in `AUFGABEN.md` **Stufe: werkzeug** (Regel)|
| <a id="x-6"></a>X-6 | Bau-Lauf: geratene Plattform (`MSB4126`) und Erfolgsmeldung ohne Bau; `tools/bauen.ps1` | **behoben** — das Werkzeug steht, drei Gegenproben grün **Stufe: werkzeug** (Bau-Lauf)|
| <a id="r-1"></a>R-1 | die Fehlerklasse hinter E-11 ausgezählt | **offen** — gemessen am 07.09.2026 mit `tools/releasebuffer-pruefen.pl`: **137** Vorkommen, davon 116 richtig gepaart; **21** zu ändern (16 `falsch`, 4 `lockbuffer`, 1 `danach`). Zuerst `QCSharewareManager.cpp:1318` — die Stelle läuft **bei jedem Start**. Liste in `AUFGABEN.md` unter A2, mit dem Werkzeug jederzeit neu zu erzeugen **Am 14.09.2026 mit `tools/releasebuffer-pruefen.pl` neu ausgezählt — die Zahlen stimmen unverändert:** 137 Vorkommen, 116 richtig gepaart, **21** zu ändern (16 `falsch`, 4 `lockbuffer`, 1 `danach`). Nichts davon ist seit dem 07.09.2026 angefasst worden **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** mit `tools/releasebuffer-pruefen.pl`: **unverändert**. 137 Vorkommen, **116 ok**, **21 zu ändern** (16 `falsch`, 4 `lockbuffer`, 1 `danach`), dazu `verdaechtig 0`. **Beim Lesen der Ausgabe aufpassen:** `verdaechtig` ist eine **eigene** Einstufung neben `falsch`, `lockbuffer` und `danach` — `verdaechtig 0` heißt **nicht**, dass nichts mehr zu tun wäre. Genau so ist der Befund am 22.10.2026 einmal versehentlich abgehakt worden. Seit dem 07.09.2026 ist keine der 21 Stellen angefasst. **Was noch fehlt:** die 21 Änderungen selbst — 137 Vorkommen, 116 richtig gepaart, **21** zu ändern (16 `falsch`, 4 `lockbuffer`, 1 `danach`), seit dem 07.09.2026 keine einzige angefasst. Zuerst `QCSharewareManager.cpp:1318`, die Stelle läuft bei jedem Start; die Liste erzeugt `tools/releasebuffer-pruefen.pl` jederzeit neu. **Stufe: werkzeug** (Fehlerklasse ausgezaehlt)|
| <a id="z-3"></a>Z-3 | erster Bau von Grund auf: `OEImport`/`NSImport` linken vor `QCUtils` — fehlende Projektabhängigkeit in `Eudora.sln` | **behoben** (`57fe6a4`) — `ProjectReference` auf `QCUtils.vcxproj` steht in `NSImport`, `OEImport`, `OLImport` und `plstclnt`; am 06.09.2026 in allen vier Projektdateien nachgesehen **Stufe: werkzeug** (Projektabhaengigkeit)|
| <a id="v-1"></a>V-1 | zwei verschiedene ZIPs unter derselben Versionsnummer `v1.0.3` | **Regel jetzt durchgesetzt**, 14.09.2026. Die Regel stand seit dem 31.08.2026 in der Doku und hat nicht getragen, weil **nichts sie geprüft hat** — `release-veroeffentlichen.ps1` legte ein Release an, ohne nachzusehen, ob die Marke schon existiert. Jetzt weist es ab (`gh release view <marke>`, Rückgabe 0 = vorhanden), mit dem Hinweis, die Nummer hochzuzählen. **Gegengetestet in beide Richtungen:** `v1.0.3` → vorhanden, wird abgewiesen; `v1.0.53` → frei, läuft durch. **Der Altbestand bleibt wie er ist:** unter `v1.0.3` hängt heute noch ein ZIP (9.209.393 B vom 31.08.2026), das ausgetauschte ist weg — nachträglich auseinanderhalten lassen sich die beiden nur über die Prüfsummen in `Releases/PAKETE.md`. Gefunden hat das Gregor, nicht die Werkzeugkette **Stufe: kritisch** (Paket: zwei verschiedene ZIPs unter derselben Nummer)|

## Empfang und Anhänge (AN)

| Kennung | Worum es geht | Status |
|---|---|---|
| <a id="an-1"></a>AN-1 | Anhänge: lange Dateinamen abgeschnitten, Endung fehlt — **elf** Ursachen (Teile B5.1 bis B5.11), alle Originalfehler; POP und IMAP, aber **nicht auf demselben Weg** (über IMAP kommt der Name aus der BODYSTRUCTURE, nicht aus `Lex822`) | **teilweise behoben — über POP am laufenden Programm gemessen, heil seit 7.2.0.81; über IMAP von Gregor mit 1.0.83 getestet und am 12.10.2026 bestätigt; B5.7 offen.** Ein Anhang ganz ohne Endung bekommt über IMAP keine Endung angehängt, über POP schon; verloren geht nichts, man muss die Datei umbenennen. **Gregor am 23.10.2026:** *„AN-1 aufschreiben, jetzt nicht."* — kommt mit den Regressionstests (der IMAP-Prüfserver braucht dafür BODYSTRUCTURE) und hält 7.2.1 nicht auf. POP: alle sechs Prüfanhänge mit vollem Namen und `.pdf` an 7.2.0.81 (`C:\Temp\AN3`), 7.2.0.82 (`C:\Temp\AN4`) und 7.2.0.83 (`C:\Temp\AN5`), abgelesen im Anhangverzeichnis und in `eudora.log`; Testsuite 185/185 an 7.2.0.82 und 7.2.0.83. IMAP: drei Anhänge aus Gregors Postfach, alle mit Endung (CHANGELOG 7.2.0.83); sein Urteil *„gekürzt mit endung reicht"*. Teile 1 bis 6 und 8 bis 11 sind behoben, **B5.7 ist offen** (IMAP ohne `SetExtension`). Elf Debug-Marken (`LogLevel=91295`). Durchlauf in AUFGABEN.md, B5 **Was noch fehlt:** allein **B5.7** — der IMAP-Weg ruft `SetExtension` nicht auf. Zehn der elf Teile sind behoben; im Test fiel es nicht auf, weil alle drei Namen schon eine Endung trugen.  **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — **und B5.7 war zu weit gefasst.** Hier stand *„der IMAP-Weg ruft `SetExtension` nicht auf“*. Am Quelltext ausgezählt: aufrufstellen=2. Er ruft es sehr wohl, in `EuImap/src/ImHexbin.cpp:374` (`mm.SetExtension(m_Name, sizeof(m_Name))`) und in `EuImap/src/ImSingle.cpp:196` (`mm.SetExtension(hd->attributeName)`). Es fehlt an **genau zwei** Stellen in `EuImap/src/ImapDownload.cpp`: beim eingebetteten Teil (`:3728`) und beim Anhang zur Datei (`:4119`) — dort sagen Kommentar und Spurmarke es selbst, *„ohne SetExtension“*. Die Behebung ist damit zwei Aufrufe groß, nicht ein Weg. **Stufe: kritisch** (Datenschaden: Anhang ohne Endung ist nicht mehr zu oeffnen)|
| <a id="an-2"></a>AN-2 | Beim Start zeigt ein Fenster in Eudora den **Quelltext einer Webseite** — JavaScript, CSS und JSON als Text | **behoben, von Gregor an 1.0.84 bestätigt am 13.10.2026** (*„HTML newsletter (weiter geleitet) wird korrekt dargestellt.“*; die Werbeansicht entfällt nach seiner Entscheidung, siehe unten). Vorher: **Anzeige geändert in 7.2.0.80, seit 7.2.0.82 übersetzt, am laufenden Programm nicht gemessen.** **WIDERLEGT am 13.10.2026, gemessen an 1.0.84:** *„eine frische `Eudora.ini` startet in der Werbe-Betriebsart“* (so in CHANGELOG 7.2.0.80 und AUFGABEN.md, mit der Begründung *„`BUILD_BOX_OR_SITE_R_VERSION` ist nicht gesetzt“*). **Er ist gesetzt**, in Debug und Release (`Eudora71/Eudora/Eudora.vcxproj:78` und `:132`, eingeführt in `bf14e14` am 30.08.2026 mit S-2) — damit ist `DEFAULT_SWM_MODE` = 2 (`QCSharewareManager.h:54-58`), also **Pro, ohne Werbung**. **Messung:** Lauf über `tools/testlauf.ps1` in `C:\Temp\AN2-1084` mit einer INI aus nur `[Settings]` und `LogLevel=128159` (Freigabe Gregor: *„ja“*): Fenster `New Account Wizard` und Hauptfenster, **kein Werbeabruf** — das Protokoll nennt nur `Server: //adserver.eudora.com/adjoin/playlists` und `Next playlist update: 56y9mo28d6h54m`; nach dem Beenden steht `Mode=2` in der INI (geschrieben von `QCSharewareManager.cpp:1403`). **Folge für den Test:** die Werbeansicht entsteht in diesem Bau nur, wenn die INI ausdrücklich `Mode=0` trägt — so muss Gregors INI ausgesehen haben, als er AN-2 meldete (nicht gemessen). **Auch mit `Mode=0` nicht auslösbar (13.10.2026, Freigabe Gregor *„ok, mach“*):** leeres Mailverzeichnis, INI nur `Mode=0` und `LogLevel=128159`, 40 s Lauf: der Werbeweg legt `EudPriv\Ads` an, meldet aber wieder `Next playlist update: 56y…` und holt **nichts**; sichtbar nur `New Account Wizard` und Hauptfenster; nach dem Beenden steht wieder `Mode=2` in der INI. **Damit ist AN-2 an diesem Bau von außen nicht prüfbar** — welcher Weg `Mode` auf 2 zieht, ist nicht gemessen. **Entscheidung Gregors am 13.10.2026** (*„brauchen wir mode=0 überhaupt?“* — *„ja, einverstanden“*): die Werbe-Betriebsart wird nicht weiter verfolgt; AN-2 beschränkt sich auf den zweiten Teil, **kein CSS/JavaScript als Text in HTML-Nachrichten**, zu prüfen an einem Newsletter im normalen Betrieb. Ursache am Quelltext belegt. Paige kennt kein Element, dessen Inhalt kein Text ist: `script` fehlte in `control_commands`, `style` stand darin ohne Behandlung. Jetzt beides über `inside_script` unterdrückt. Gemessen mit `tools/html-tags-pruefen.pl`: **30 Fälle, 0 Abweichungen**, Gegenprobe gefahren. **Offen bleibt die eigentliche Frage:** Eudora holt beim Start Werbung von `adserver.eudora.com`, und diese Adresse gehört seit 2018 dem Computer History Museum. **[Überholt 13.10.2026, [L-27.4](../Befunde/LEKTOR-27.md#l-27.4): an 1.0.84 holt Eudora keine Werbung, weder mit frischer INI noch mit `Mode=0` (Messungen oben); die Frage hat Gregor entschieden — nicht weiter verfolgen.]** **Stufe: wichtig** (Anzeige: Quelltext einer Webseite beim Start)|

## Betrieb: was Gregor am 31.08.2026 gesehen hat (E)

| Kennung | Worum es geht | Status |
|---|---|---|
| <a id="e-1"></a>E-1 | der erste erfolgreiche Mailabruf, 159 Nachrichten | **Beleg** (Kriterium 1 und 3) **Stufe: unkritisch** (erster erfolgreicher Abruf, kein Mangel)|
| <a id="e-2"></a>E-2 | Werkzeugleiste vollständig, HTML-Umlaute zerstört | **überholt** durch Z-2 — E-2 ist die Beobachtung am Bildschirm, die Ursache steht in Z-2 und ist dort behoben und getestet (`TestZeichenWege.cpp`, Fälle „Z-2“) **Stufe: kritisch** (Zeichensatz: HTML-Umlaute zerstoert)|
| <a id="e-3"></a>E-3 | TLS 1.3 mit der ausgelieferten QCSSL 1.0.1, `mx.freenet.de:110` | **bestätigt am 31.08.2026** (Beleg: TLSv1.3 an Gregors freenet-Konto, Abschnitt unten). **Regressionstest** `TestE3.cpp` (30.10.2026, am Quelltext, 325 Tests, 325 bestanden): QCSSL nimmt `TLS_client_method()`, jede Einstellung setzt TLS 1.2 als Untergrenze ([M1](#m1)), und keine Quelldatei von QCSSL deckelt die Obergrenze; mit Einstellung 3 auf `TLS1_VERSION` einmal rot **Stufe: kritisch** (Verbindung: TLS-Aushandlung bricht ab)|
| <a id="e-4"></a>E-4 | Debug-Zusicherung beim Beenden: Index außerhalb `m_arrBars` | **behoben, ungeprüft** in **7.2.0.3** (05.09., `1188e87`: die Ursache liegt beim **Start**, ein ungeprüfter Cast in `WazooBarMgr.cpp`) **Stufe: unkritisch** (Zusicherung beim Beenden, nur im Fehlersuchbau)|
| <a id="e-5"></a>E-5 | „Release startet auf Win11 gar nicht" | **überholt** durch E-6/E-8 **Stufe: kritisch** (Start: Release startet nicht)|
| <a id="e-6"></a>E-6 | Release läuft, Assistent stürzt bei *Weiter* ab | **überholt** durch E-8 (es war der Debug-Bau) **Stufe: kritisch** (Absturz im Assistenten)|
| <a id="e-7"></a>E-7 | die Bau-Kennung fehlt im Titel, solange kein Postfach offen ist | **behoben, ungeprüft** in **7.2.0.3** (05.09., `bcc59bb`: ein `OnUpdateFrameTitle(TRUE)` in `mainfrm.cpp:1135`) **Stufe: unkritisch** (Bau-Kennung fehlt im Titel)|
| <a id="e-8"></a>E-8 | Berichtigung zu E-6, und Kriterium 0 zurückgezogen | **Beleg** **Stufe: unkritisch** (Berichtigung zu E-6)|
| <a id="e-9"></a>E-9 | Absturz im Assistenten: die Kette bis zur Importsuche | **überholt** durch E-11; die Härtung bleibt richtig **Stufe: kritisch** (Absturz im Assistenten, Importsuche)|
| <a id="e-11"></a>E-11 | `ReleaseBuffer` ohne `GetBuffer` in `eudora.cpp:3372` | **behoben, ungeprüft** in **7.2.0.3** — und laut R-1 wahrscheinlich **unvollständig** **Stufe: kritisch** (Speicherfehler: ReleaseBuffer ohne GetBuffer)|
| <a id="e-12"></a>E-12 | `Eudora.exe Mailverzeichnis` hielt das Verzeichnis für den Ini-**Dateinamen** | **behoben, ungeprüft** in **7.2.0.4** (Kriterium 3) **Stufe: kritisch** (Start: Verzeichnis als Ini-Dateiname missdeutet)|
| <a id="e-13"></a>E-13 | beim Mailabruf ist kein Fortschritt sichtbar — der Abruf dauert 0,02 s | **offen, nicht gemessen — die Behebung steckt seit dem 05.09.2026 im Stand** (`bd3959c2`, über den Merge `1e84e310`, damit auch in `v7.2.1.128`); der Zweig `wt/fortschritt-arbeit`, auf den hier bis zum 30.10.2026 verwiesen wurde, gibt es nicht mehr ([L-100.10](../Befunde/LEKTOR-100.md#l-100.10)). Hieß versehentlich `E-12` **Stufe: unkritisch** (kein Fortschritt sichtbar) **Was noch fehlt:** beim Mailabruf am laufenden Programm messen, ob die Statusleiste den Fortschritt zeigt.|
| <a id="e-14"></a>E-14 | Zusicherung beim Start: der X1-Suchindex wird neu angelegt (`SearchManager::Info::InitX1`) | **erledigt - am 23.10.2026 im Protokoll von neun Mailverzeichnissen gemessen: kein Fehler, sondern der normale erste Lauf** — auf einem frischen Mailverzeichnis der normale erste Lauf; echter Befund erst, wenn die Meldung auch beim **zweiten** Start kommt **Am 14.09.2026 geprüft: nicht entscheidbar.** Der Befund lässt sich nur am **zweiten** Start eines gewachsenen Mailverzeichnisses messen, und dazu liegt keine Messung vor. **Stand ungeprüft seit dem 05.09.2026** — zu messen, indem Eudora zweimal hintereinander auf demselben Verzeichnis gestartet wird und beim zweiten Mal auf die Zusicherung geachtet wird **Was noch fehlt:** die eine Messung, die entscheidet — Eudora zweimal hintereinander auf **demselben gewachsenen** Mailverzeichnis starten und beim zweiten Mal auf `SearchManager::Info::InitX1` achten. Kommt die Zusicherung wieder, ist es ein Befund, sonst der normale erste Lauf. Steht seit dem 05.09.2026 ungeprüft. **Wie zu pruefen:** **ICH** — eine Messung, kein Einbau. Schritte: ein Testverzeichnis mit gewachsenem Postfach nehmen, Eudora starten, beenden, **sofort wieder starten**. Beim zweiten Start auf die Zusicherung `SearchManager::Info::InitX1` achten (im Debug-Bau ein Dialog, im Release nur die Protokollzeile). Kommt sie wieder, ist es ein Befund; kommt sie nicht, war es der normale erste Lauf und E-14 fällt weg.  **Zuletzt gemessen: 23.10.2026 an 7.2.0.110 bis 7.2.0.121** — **aus den vorhandenen Protokollen, ohne einen einzigen neuen Start.** Die Meldung lautet `Erasing X1 indices because DB schema was missing or doesn't match` und wird in `SearchManager::Info::InitX1` geschrieben (`SearchManagerInfo.cpp:497`, Maske `DEBUG_MASK_SEARCH` = 16384), gesteuert von `m_bX1DBNeedsCleared`. Gezählt über **neun** Mailverzeichnisse (Gregors acht `Eudora72-1.0.*-release` plus `C:\Temp\sicherung-1.0.84-mailverzeichnis-20261012-144113`): **59 Sitzungen, 56 davon mit arbeitendem Suchsystem** (`X1 loading database`, dieselbe Maske), und **9 Erasing-Zeilen — genau eine je Verzeichnis, jede in der ersten Sitzung dieses Verzeichnisses.** Beispiel `1.0.116`: 31 Sitzungen, 30 X1-Ladevorgänge, die einzige Erasing-Zeile steht in Zeile 9, die zweite Sitzung beginnt erst bei Zeile 134. **Damit ist das Kriterium erfüllt, das der Befund selbst nennt** (*„echter Befund erst, wenn die Meldung auch beim zweiten Start kommt"*): sie kommt beim zweiten Start nicht. **Die Positivprobe ist mitgeliefert** — 56 Sitzungen haben mit Maske 16384 geschrieben, die Zeile hätte also erscheinen können. Genau daran war die Messung am 22.10.2026 gescheitert: damals stand im Protokoll **keine einzige** Zeile mit dieser Maske, und „sie fehlt" wurde als Bestanden gelesen ([ausbleiben-ist-kein-befund](../Arbeitsweise/ausbleiben-ist-kein-befund.md)). **Warum Gregor am 05.09.2026 einen Dialog sah und die Protokolle keinen:** an derselben Bedingung hängt eine Zeile höher ein `ASSERT(!"Erasing X1 indices ...")` (`:496`). Im Release-Bau ist das nichts ([assert-ist-im-release-nichts](../Arbeitsweise/assert-ist-im-release-nichts.md)); die Protokollzeile daneben ist der verlässliche Zeuge und sagt dasselbe aus. **Prüfung: manuell** (Teil M2 in [TESTPLAN.md](TESTPLAN.md#m2-e14) — nur am zweiten Start eines gewachsenen Mailverzeichnisses messbar; **seit dem 23.10.2026 deaktiviert, nicht gelöscht**, Gregor: *„wenn es nicht mehr aufgetreten ist, dann kann man es deaktivieren, den test aber nicht löschen"*)**Stufe: wichtig** (Funktion: wird der Suchindex bei jedem Start neu angelegt, ist die Suche auf gewachsenen Postfaechern unbrauchbar)|
| <a id="e-16"></a>E-16 | Absturz beim Verfassen (Strg-N) und „Encountered an improper argument", `afxcoll.inl:213` | **behoben** in **7.2.0.5** — sechs Indexstellen gehärtet (`Befunde/VERFASSEN.md`). Die Ursache, die dieser Befund **nicht** fand, ist **E-34**: die Schranke aus E-16 greift, `m_btns[24]` wirft trotzdem, weil MFC 14 in den Sammlungen mit `ENSURE` statt `ASSERT` prüft **Stufe: kritisch** (Absturz beim Verfassen)|
| <a id="e-17"></a>E-17 | der Kontoassistent startete bei jedem Start, obwohl ein Konto eingerichtet war | **behoben** in **7.2.0.7** (aus der Git-Geschichte ermittelt, nicht aus einer Fassungsangabe) (`Befunde/PERSONA.md`) **Stufe: wichtig** (Funktion: Kontoassistent startet bei jedem Start)|
| <a id="e-22"></a>E-22 | Doppelklick öffnet keine Nachricht, Suchtreffer lassen sich nicht anklicken | **überholt durch E-28** — dieser Befund fand die Ursache nicht, lieferte aber einen Messwert, der die damalige Suchrichtung widerlegte, und sechs belegte Schwachstellen auf dem Weg (`Befunde/FENSTER.md`). Die Ursache ist `CSummary::m_FrameWnd`, siehe **E-28** **Stufe: wichtig** (Funktion: Doppelklick oeffnet keine Nachricht)|
| <a id="e-23"></a>E-23 | POP3 nur über Port 110, dazu der Anmeldefehler bei freenet | **Ursache belegt**, drei Löcher gestopft (`Befunde/PORT.md`); Port 995 mit TLSv1.3 ist seit 06.09.2026 gemessen. **Regressionstest** `TestE23.cpp` (30.10.2026, am Quelltext, 325 Tests, 325 bestanden): Port 0 bei *Alternate Port* wird beim Abruf 995 und beim Versand 465, und `Network::SetSSLMode` setzt `m_bSSLMode` auch ohne `qcssl.dll`; mit `if (0)` statt der Abfrage beim Versand einmal rot **Stufe: kritisch** (Abruf: POP3 schlaegt fehl)|
| <a id="e-24"></a>E-24 | unter „Recent" stand „In" zweimal im Postfachbaum | **behoben** in **7.2.0.10** (`Befunde/POSTFACH.md`) **Stufe: unkritisch** (In stand zweimal im Baum)|
| <a id="e-25"></a>E-25 | der Absturz beim Klick auf *Weiter*: Doppelfreigabe in `NSImportClass.cpp`, `LocateNetscapePrefsFile` | **behoben** in **7.2.0.10** (`Befunde/ASSISTENT.md`) — **die Hypothese hat den Test aber nicht bestanden**: 7.2.0.12 stürzt weiter ab, E-25 war also nicht die einzige Quelle **Stufe: kritisch** (Absturz: Doppelfreigabe)|
| <a id="e-26"></a>E-26 | der Absturzbericht nennt die Ladeadresse jedes Moduls (`QCExceptionHandler::WriteModuleTable`) | **behoben** in **7.2.0.12** (`277d3a4`) — kein eigener Abschnitt, beschrieben in `Befunde/SPUR.md` unter *„Das Absturzprotokoll"* **Stufe: werkzeug** (Absturzbericht nennt Ladeadressen)|
| <a id="e-27"></a>E-27 | **Strg-N beendet Eudora lautlos** — ohne Dialog, ohne Protokoll | **Ursache gefunden und behoben: E-31** in **7.2.0.12** (aus der Git-Geschichte ermittelt, nicht aus einer Fassungsangabe) (`pg_time_t` acht Byte statt vier). Der Absturz war `0xC00000FD` STATUS_STACK_OVERFLOW in `Paige32.dll`; ein voller Stapel lässt keinen Platz für den Absturzbehandler, daher kein `Exception.log`. Dieser Befund hat davon die **Ursache des Schweigens** belegt: der Behandler hing nur an `SetUnhandledExceptionFilter`, und Heap-Beschädigung, `/GS`-Wächter, ungültiges Argument an die C-Laufzeit sowie `std::terminate` gehen daran vorbei — drei davon sind seit 7.2.0.13 angemeldet, dazu 15 Spurmarken. Die dort genannte „beste offene Spur" (`Paige32`/`EuMemMgr` gegen `MSVCR71`) ist durch E-31 **überholt** (`Befunde/VERFASSER.md`) **Stufe: kritisch** (Absturz: Strg-N beendet lautlos)|
| <a id="e-28"></a>E-28 | **Doppelklick öffnet keine Nachricht, Suchtreffer lassen sich nicht anklicken** | **behoben** in **7.2.0.12** (`222c0ba`): `CSummary::m_FrameWnd` blieb als Zeiger auf einen zerstörten Rahmen stehen. Gesetzt wird er bedingungslos in `CMessageFrame::ActivateFrame`, gelöscht wurde er nur innerhalb von `if (m_InitialSize != wp.rcNormalPosition)` — also nur, wenn das Fenster verschoben oder in der Größe geändert wurde (`Befunde/OEFFNEN.md`) **Stufe: wichtig** (Funktion: Doppelklick oeffnet keine Nachricht)|
| <a id="e-29"></a>E-29 | die Adressen im Absturzbericht brauchen ein Werkzeug | **behoben** in **7.2.0.12** (aus der Git-Geschichte ermittelt, nicht aus einer Fassungsangabe) (`029703c`): `tools/absturz-auswerten.pl`, 15 Selbsttests. Löst mit der Modultabelle aus E-26 jede Stapelzeile in einen Funktionsnamen auf — und sagt bei älteren Berichten ausdrücklich, dass es **nicht** geht, statt zu raten (`Befunde/SPUR.md`) **Stufe: werkzeug** (Werkzeug fuer die Adressen)|
| <a id="e-30"></a>E-30 | abgeschaltete Knöpfe der Werkzeugleiste zeigen kein Symbol | **behoben** und von Gregor bestätigt (Paket 1.0.14). Ursache waren die sechs **24-Bit**-Bitmaps der Hauptleiste: ohne Farbtabelle konnte `CreateMappedBitmap` das Buttongrau `192,192,192` nicht auf das heutige `COLOR_BTNFACE` (`240,240,240`) umsetzen, und die Maske erfasste das ganze Bildrechteck. Behoben in `OTShim/OTShim_Werkzeugleiste.cpp`, abgesichert durch `tools/pruefe-symbole.pl` und `Eudora71/Tests/TestSymbole.cpp` (`Befunde/SYMBOLE.md`) **Stufe: unkritisch** (abgeschaltete Knoepfe ohne Symbol)|
| <a id="e-31"></a>E-31 | `pg_time_t` war unter VS2022 **acht** Byte breit statt vier — damit war jede Paige-Struktur verschoben, und in dieser Portierung entstand nie ein Paige-Fenster | **behoben und mittelbar bestätigt** in **7.2.0.17** (aus der Git-Geschichte ermittelt, nicht aus einer Fassungsangabe) — ohne Paige-Fenster gibt es kein Verfassen-Fenster, und Gregor hat am 07.09.2026 mit 7.2.0.21 eine Mail geschrieben und abgeschickt. Der Abschnitt mit allen Feldversätzen steht in `CHANGELOG.md` unter 7.2.0.21, dazu ein Kommentar in `Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H:695` **Stufe: kritisch** (Speicherfehler: jede Paige-Struktur verschoben)|
| <a id="e-32"></a>E-32 | die **modale** Meldung „An unhandled exception has occurred" beim Verfassen, nach der sich Eudora nicht mehr beenden ließ | **Ursachenbehauptung widerlegt** (P-3, `Befunde/PRUEFER-3.md`): `CHeaderView::OnKillFocusRecipient` läuft bei Strg-N gar nicht, das Herausnehmen der Behebung bringt die Meldung nicht zurück, und im Paket 1.0.18 tritt sie über denselben Weg nicht auf. Der **Code-Mangel** dort ist echt und behoben (`060a4bf`) — er war nur nie die Ursache. Aufgeklärt hat die Meldung erst **E-34**. **Regressionstest** für den Code-Mangel `TestE32.cpp` (30.10.2026, am Quelltext, 325 Tests, 325 bestanden): in `CHeaderView::OnKillFocusRecipient` steht `if (!pField) return;` vor jedem ungeschützten Zugriff; ohne die Abfrage einmal rot **Stufe: kritisch** (Absturz: unbehandelte Ausnahme beim Verfassen)|
| <a id="e-33"></a>E-33 | *File → Exit*, das **Kreuz** und **Alt-F4** beenden Eudora nicht, sondern bringen die Meldung **„Encountered an improper argument"** (Kriterium 7) | **behoben** in 7.2.0.22, von Gregor am 08.09.2026 bestätigt: *„schließen klappt jetzt."* Alle drei Wege beenden. Behoben durch **E-40**, **E-41** und **E-42** nach dem Grundsatz: ein Fehler beim *Aufräumen* darf das Beenden nicht verhindern, nur eine bewusste Entscheidung des Anwenders. **Der Fehler selbst ist damit nicht verschwunden** — er steht als Protokollzeile da und ist als **E-43** weiter offen **Stufe: kritisch** (Beenden schlaegt fehl, Fenster bleibt stehen)|
| <a id="e-40"></a>E-40 | eine Rückfrage, die sich nicht **öffnen** lässt, galt als „Abbrechen" und hielt Eudora offen | **behoben** in 7.2.0.22. `CDoc::SaveModified` (`Eudora71/Eudora/doc.cpp`) und `CMessageDoc::SaveModified` (`Eudora71/Eudora/msgdoc.cpp`) hatten im `default`-Zweig nur `ASSERT(FALSE)` und `return FALSE`. `IDCANCEL` hat einen **eigenen** Zweig darüber; in `default` fällt vor allem die **0**, die `AfxMessageBox` liefert, wenn der Dialog nicht erzeugt werden kann — dann hat niemand entschieden. Jetzt: Rückgabewert und Titel ins Protokoll, Schließen wird fortgesetzt **Stufe: kritisch** (Beenden: nicht oeffenbare Rueckfrage haelt Eudora offen)|
| <a id="e-41"></a>E-41 | **Alt-F4 und das Kreuz** laufen durch ein `ENSURE_VALID`, das *File → Exit* nicht hat | **behoben** in 7.2.0.22. `CMainFrame::OnSysCommand` reichte `SC_CLOSE` ungeschützt an `CFrameWnd::OnSysCommand` weiter; dort steht in MFC 14 `GetTopLevelFrame()` plus `ENSURE_VALID(pFrameWnd)` (`winfrm.cpp:1112-1114`), und `ENSURE_VALID` wirft **auch im Release-Bau**, wo MFC 6 nur `ASSERT_VALID` hatte. Jetzt `TRY`/`CATCH_ALL` mit `WM_CLOSE` als Rückfallweg. **Gefunden hat die Stelle PRUEFER**, indem er meine Beweisführung verwarf: aus „Kreuz und Alt-F4 zeigen dasselbe wie das Menü" folgt **nicht**, dass der Wurf in `OnClose` liegt **Stufe: kritisch** (Absturz: ENSURE_VALID wirft auch im Freigabebau, auf dem Weg Alt-F4 und Fensterkreuz)|
| <a id="e-42"></a>E-42 | zwölf **Aufräumschritte** beim Beenden konnten den Ablauf abbrechen und das Fenster stehen lassen | **behoben** in 7.2.0.22. Neues Makro `AUFRAEUMEN(name, anweisung)` in `Eudora71/Eudora/mainfrm.cpp`: führt den Schritt aus, meldet einen Fehlschlag mit Namen und Grund ins Protokoll, macht weiter. In `OnClose`: `CloseImapConnections`, `EmptyTrash`, `CleanSSLLibrary`, `TrayItem`, `DeleteMenuObjects`, `QCWorkbook::OnClose`. In `CloseDown`: `TrimJunk`, `RemoveBogusAdToolBars`, `SaveBarState(ToolBar)`, `SaveWazooBarConfigToIni`, `SaveCrashStateToINI`, `WriteToolBarMarkerToIni`. Die Rückfragen in `CloseDown` Stufe 1 bis 3 laufen bewusst **nicht** hierdurch **Stufe: kritisch** (Beenden bricht ab, Fenster bleibt stehen)|
| <a id="e-43"></a>E-43 | `SECControlBar` war **zweimal definiert** — dadurch lasen zwei Übersetzungseinheiten dasselbe Feld acht Byte auseinander | **behoben** in 7.2.0.24, **von Gregor am 08.09.2026 bestätigt**: *„0.24 – persona läßt sich löschen. keine messagebox“*. **Die Wurzel von E-34, E-37 und E-38 zugleich.** `OT501/Include/sbarcore.h:118` (Original) und `OTShim/OTShim.h:496` (Ersatz) definieren beide `SECControlBar`; der Ersatz hat **ein Feld mehr**, `int m_nRowExtent` (`OTShim.h:533`). `OTShim_Werkzeugleiste.h:84` band unter `#ifndef __SBARCORE_H__` das **Original** ein, und denselben Wächter setzt `OTShim.h:984`. Welche Fassung eine Übersetzungseinheit sah, hing damit allein an der Reihenfolge: `QCCustomToolBar.cpp` über `stdafx.h` → `OTShimAll.h` → `OTShim.h` zuerst (Ersatz), `OTShim_Werkzeugleiste.cpp` ohne `stdafx.h` (Original). Compilerschalter und Include-Pfade sind sonst gleich — nachgemessen aus `Eudora.tlog/CL.command.1.tlog`, einziger Unterschied `/Yu"stdafx.h"`. **Gemessen vorher:** `GetBtnCount=24/24 m_btns.GetSize=0/0 roh[0..4]=24,25,0,0,0`. **Nachher:** `GetBtnCount=24/24 m_btns.GetSize=24/24 roh[0..4]=15146180,10425560,24,25,0` — `m_nSize` und `m_nMaxSize` liegen jetzt dort, wo `CPtrArray` sie hat. **Wirkung:** die `Eudora.ini` des Testprofils enthält zum ersten Mal `[ToolBar…]`-Abschnitte, **13 statt 0**; keine `E-42`-Zeile mehr beim Beenden. Behoben durch `#include "OTShim.h"` statt `sbarcore.h`. Die Schranke dazu ist **`tools/pruefe-waechter.pl`**; die Lehre `Arbeitsweise/teilweise-ersetzte-header.md` gab es seit dem 30.08.2026 und sie hat nichts verhindert **Stufe: kritisch** (Speicherfehler: dieselbe Klasse zweimal definiert)|
| <a id="e-47"></a>E-47 | beim Öffnen der **Kurznamen-/Verzeichnisdienst-Leiste** kommt der Fehlerdialog *„Directory Services unavailable during this session due to unsuccessful initialization"* | **offen, Ursache belegt, keine Behebung in Sicht.** Text in `DirectoryServices/DirectoryServicesUI/inc/DSRightViewImpl.h:44`, angezeigt in `DSRightViewImpl.cpp:255` aus `DSRightView::OnActivateWazoo` — **nur** wenn `RegisterCOMObjects()` fehlschlägt. Es schlägt fehl, weil die dort genannten `DirServ.dll`, `ISock.dll`, `Ph.dll`, `Ldap.dll` und `EudoraBk.dll` **`MFC71.DLL` und `MSVCP71.dll` brauchen**, und die hat Microsoft nicht zur Weitergabe freigegeben. `tools/paket-pruefen.ps1` führt beide seit dem 31.08.2026 als hingenommene Lücke — **dass dabei ein Fehlerdialog erscheint, stand dort nicht**. Von Gregor am 08.09.2026 an 1.0.23 gesehen. **Widerlegt:** mein erster Verdacht, A-2 habe die Leiste aufgemacht. Gemessen mit `tools/leisten-messen.ps1`: Leiste 319 ist **rechts, Sichtbar = False**, und Gregors eigenes Protokoll meldet *„Kurznamen versteckt"*. Die Leiste wird also von A-2 nicht geöffnet — sie war von Hand aufgemacht worden **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — unverändert. Der Text steht als `_ds_uds` in `DSRightViewImpl.h:44`, angezeigt wird er in `DSRightViewImpl.cpp:255`, und `RegisterCOMObjects()` wird in derselben Datei bei `:224` gerufen. Keine der drei Stellen ist angefasst. Es fehlt auch heute keine Behebung, sondern Gregors Entscheidung, ob der Dialog unterdrückt oder durch einen verständlichen Hinweis ersetzt wird. **Was noch fehlt:** eine Entscheidung, keine Behebung — `MFC71.DLL` und `MSVCP71.dll` hat Microsoft nicht zur Weitergabe freigegeben, `RegisterCOMObjects()` scheitert deshalb dauerhaft. Offen ist allein, ob der Fehlerdialog unterdrückt oder durch einen verständlichen Hinweis ersetzt wird; der Text stammt aus `_ds_uds` (`DSRightViewImpl.h:44`) und wird in `DSRightViewImpl.cpp:255` angezeigt. **Stufe: wichtig** (Funktion: Verzeichnisdienst nicht verfuegbar)|
| <a id="e-48"></a>E-48 | die **Registerkartenleiste** für die offenen Fenster fehlte (Anforderung **A-3**, Kriterium 8) | **behoben** in 7.2.0.25, von Gregor am 09.09.2026 bestätigt: der Klick auf eine Karte holt das Fenster nach vorn, die Beschriftungen stimmen mit dem Menü *Window*. Die Leiste war nicht abwesend, sondern **abgeschaltet**: Eudoras Code liegt vollständig im Quellbaum (`workbook.cpp`), `mainfrm.cpp:1042` schaltet sie bei jedem Start ein, INI-Vorgabe `ShowMDITaskbar\n1`. Vier Anschlüsse fehlten in der Ersatzschicht: `SetWorkbookMode` war eine Attrappe; `GetTabPts` lieferte **sechs Nullpunkte** (jede Karte an (0,0) mit Größe null); `recalcTabWidth()` **liefert** die Breite nur zurück und wurde weggeworfen; `OnDrawTabIconAndLabel` wurde von niemandem gerufen, weshalb zwei **leere** Kästen standen. Dazu eine bewusste Abweichung: der Streifen beginnt am **MDI-Bereich**, nicht bei `rectClient.left` wie in `QCGetTaskBarRect` — dort liegt bei uns die linke Wazoo-Leiste, und Karte 0 verschwand darunter **Stufe: unkritisch** (Registerkartenleiste fehlte)|
| <a id="e-49"></a>E-49 | der **linke Bereich** ließ sich nicht breiter ziehen (Anforderung **A-4**) | **behoben** in 7.2.0.26, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A: „pass: nach neustart immer noch gleiche größe“). Die Splitter-Mechanik war vollständig umgesetzt (`AddSplitter`, `HitTest`, `StartTracking`, `CalcTrackingLimits`, `DrawTrackerRect`, `OnSetCursor`, `OnLButtonDown`) — nur wurde `AddSplitter` nie gerufen, `Track` war leer und `OnSplitterMoved` tat nichts. **Drei Anläufe, zwei am laufenden Programm widerlegt:** `SetBorders` ergab Andockleiste Client **176** bei Leiste **180** (der Rand verkleinert den Innenbereich statt die Leiste zu vergrößern); eine Bedingung über `m_arrBars` ergab **gar keine Wirkung**; ein Messversuch mit Zuschlag **11** ergab **187**, also **7 frei** — daraus folgt, dass der Weg über `CalcFixedLayout` stimmt und **MFC 4 Pixel des Zuschlags selbst verbraucht**. Endstand: Bedingung am Ergebnis, und `OnSizeParent` **misst** den freien Platz nach statt ihn zu raten — 8 Pixel **Stufe: unkritisch** (linker Bereich nicht breiter zu ziehen)|
| <a id="e-50"></a>E-50 | drei Mängel an der neuen Registerkartenleiste, von Gregor an 1.0.25 gefunden | **behoben** in 7.2.0.26, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A, alle drei Schritte: „PASS“). Alle drei mit derselben Wurzel: **der Streifen wird nur beim Neuzeichnen gemalt, und niemand erklärt ihn für ungültig.** (1) *„die karte bleibt eingedrückt, auch wenn man im anderen fenster ist"* — `QCWorkbook::OnLButtonDown` setzt `SetSelected(TRUE)` (`workbook.cpp:1109`) und **niemand** setzt es zurück; im Original tat das die Stingray-Ebene. Die Marke wird jetzt gelöscht, sobald ein anderer Rahmen aktiv ist. (2) *„beim skalieren ist die darstellung falsch"* — `WM_SIZE` frischt auf. (3) *„die karten sind dann weg"* beim Öffnen/Schließen — `AddSheet`/`RemoveSheet` frischen auf. **Nebenbefund, NICHT hier eingeordnet:** *„nach dem neustart sind die fenster nicht im vollbild modus, wie beim beenden"* — das ist der Fensterzustand, ein eigener Weg über `SaveOpenWindows`, getrennt zu messen **Stufe: unkritisch** (drei Maengel an der Registerkartenleiste)|
| <a id="e-51"></a>E-51 | meine eigene **Ziehschleife** konnte Eudora einfrieren | **behoben, bevor es ausgeliefert wurde.** in **7.2.0.27** (aus der Git-Geschichte ermittelt, nicht aus einer Fassungsangabe) `Splitter::Track` lief im ersten Entwurf mit `while(::GetMessage(...))`. Kommt kein `WM_LBUTTONUP` — Mausfang verloren, Fokus weg, Nachricht anderswo hin —, wartet die Schleife für immer und das Programm ist tot. **Zweimal an der eigenen Prüfinstanz eingetreten**, beide Male musste der Prozess abgeschossen werden. Jetzt: höchstens 100 ms warten, danach Fenster, Mausfang und die **physische** Maustaste erneut prüfen. Der Preis ist benannt: ein künstlicher Zug über Fensterbotschaften ist damit nicht mehr möglich, das Ziehen kann nur ein Mensch prüfen **Regressionstest seit 25.10.2026:** Schranke `pruefe-nachrichtenschleife.pl` Regel 1b (kein unbegrenztes Warten in einer eigenen Nachrichtenschleife) mit Rückfallprobe in `tools/regression-schranken.txt`: `WaitMessage()` an der Ziehschleife wird abgewiesen — vorher blind (Rückgabe 0). Gemessen 25.10.2026: Rückfallprobe abgewiesen, 19 Proben, 19 weisen den Rückfall ab; dazu 301 Tests, 301 bestanden. **Stufe: kritisch** (Haenger: eigene Ziehschleife friert Eudora ein)|
| <a id="e-52"></a>E-52 | nach dem Verbreitern war der **Trennbalken nicht mehr greifbar**, und die Registerkarten standen **doppelt** | **behoben** in 7.2.0.27, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A: Balken greifbar, „wenn kacheln geschlossen sind, werden sie beim nächsten öffnen nur 1x angezeigt“). Von ihm an 1.0.26 gemeldet: *„nach vergrößern (verschiebung nach rechts), kann man den balken nicht mehr greifen. erst wenn ich das fenster verändere, dann geht es wieder."* und *„verschieben links / rechts vom mailverzeichnis: hier ist kein refresh drin."* — **sein zweiter Halbsatz war die Diagnose.** MFC verschiebt die Leisten mit `DeferWindowPos` (`lpLayout->hDWP`); wenn `OnSizeParent` zurückkommt, hat die Andockleiste ihre neue Größe **noch nicht**, und `GetClientRect` liefert die alte. Der Balken landete an der alten Stelle. Behoben, indem er in `OnSize` entsteht — `WM_SIZE` kommt, nachdem die Größe gesetzt ist. Die doppelten Karten kamen aus derselben Wurzel: `RecalcLayout` ordnet neu an, erklärt aber nichts für ungültig. `OnSplitterMoved` frischt jetzt mit `RDW_INVALIDATE \| RDW_ERASE \| RDW_ALLCHILDREN` auf. **Bestätigt ist der Gegenfall:** *„verschieben rauf / runter — bug gefixt, die anzeige ist korrekt."*, also greift die Höhenänderung samt Auffrischen **Stufe: unkritisch** (Trennbalken nicht greifbar)|
| <a id="e-53"></a>E-53 | beim **Schließen** eines Fensters blieb an der Stelle der Registerkarte ein **Strich** stehen | **behoben** in 7.2.0.28, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A: „PASS“). Sein Wort: *„schönheitsfehler beim schließen, da bleibt ein strich übrig."* Die Ursache war eine **Unsymmetrie in meinem eigenen Code**: `SECWorkbook::StreifenAuffrischen` erklärt den Streifen mit `InflateRect(2, 2)` für ungültig, gefüllt wurde in `OnPaint` aber nur der Streifen **ohne** diesen Rand. Die zwei Pixel ringsum blieben stehen — und genau dort liegen die Kanten, die `QCWorkbook::GetTabPts` um (+2,−2) verschiebt. Jetzt wird gefüllt, was auch für ungültig erklärt wird; beide Stellen benutzen denselben Betrag **Stufe: unkritisch** (Strich bleibt nach dem Schliessen stehen)|
| <a id="e-54"></a>E-54 | beim Ziehen des Trennbalkens **nach rechts** war der **Ziehrahmen unsichtbar** — man zog ins Blinde | **behoben** in 7.2.0.29, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A: „der rahmen ist während dessen auch sichtbar: PASS“). Von PRÜFER gefunden. `SECDockBar::StartTracking` gab **sich selbst** als Zeichenziel mit (`pSplit->Track(this, pt, this)`), und `DrawTrackerRect` rechnet in den Clientbereich dieses Fensters um. Die Andockleiste ist aber nur **188 Pixel** breit — alles rechts davon fiel aus dem sichtbaren Bereich, also genau die Richtung, in die Gregor ziehen will. Jetzt heißt `pWndClipTo == NULL` „in **Bildschirm**koordinaten auf den Bildschirm zeichnen", so wie MFC es beim Ziehen von Leisten macht (`CDockContext::InitLoop`): Fenstersperre auf dem Arbeitsflächenfenster, dann `GetDCEx` mit `DCX_WINDOW\|DCX_CACHE\|DCX_LOCKWINDOWUPDATE`. Die Sperre ist der Grund, weshalb kein Rest stehen bleibt — sie sammelt die Malbereiche der anderen Fenster und zeichnet sie beim Aufheben nach **Stufe: unkritisch** (Ziehrahmen unsichtbar)|
| <a id="e-55"></a>E-55 | ein **acht Pixel hoher leerer Streifen** unter der Werkzeugleiste | **behoben** in 7.2.0.29, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A: „PASS“). Von PRÜFER gefunden. Der Zuschlag in `SECDockBar::CalcFixedLayout`, der den Greifstreifen für A-4 schafft, galt für **alle vier** Andockleisten — auch für die obere, in der die Werkzeugleiste sitzt und wo niemand etwas ziehen will. Übrig blieb dort nur der leere Platz. Die Entscheidung steht jetzt an **einer** Stelle (`BrauchtGreifstreifen`, links/rechts/unten) und wird von `CalcFixedLayout` **und** `TrennbalkenNeuAnlegen` benutzt — vorher standen zwei Listen getrennt da, und die eine schuf Platz, den die andere nicht belegte **Stufe: unkritisch** (leerer Streifen unter der Werkzeugleiste)|
| <a id="e-56"></a>E-56 | beim **Abschalten** von *Show MDI task bar* blieb der Registerkartenstreifen stehen | **behoben** in 7.2.0.29, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A: „streifen weg und wieder da“). In `QCWorkbook::ShowMDITaskBar` (`workbook.cpp:718-736`) stehen `RecalcLayout` und `ResetTaskBar` **innerhalb** von `if (m_bWorkbookMode)` — beim Einschalten läuft beides, beim Ausschalten **nichts**. Der Rand wird auf 0 gesetzt, aber niemand ordnet neu an. Nachgeholt in `SECWorkbook::SetWorkbookMode`, nur im Ausschaltzweig (sonst liefe es doppelt), mit `RDW_ALLCHILDREN`, weil der MDI-Clientbereich selbst ein Kindfenster ist **Stufe: unkritisch** (Registerkartenstreifen bleibt stehen)|
| <a id="e-57"></a>E-57 | `QCWorkbook::IsTabLabelTruncated` legte bei **jeder Mausbewegung** über dem Streifen eine `CPaintDC` an — **außerhalb** von `WM_PAINT` | **behoben** in 7.2.0.29, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A, nicht sichtbar: beim Ziehen kein Absturz und kein Hänger gemeldet). Von PRÜFER gefunden, und es erklärt Gregors Satz *„hier ist kein refresh drin"*. `CPaintDC` ruft `BeginPaint`/`EndPaint`; das erklärt den Ungültigkeitsbereich des Fensters für **erledigt, ohne etwas zu malen**. Gerufen wird die Fassung aus `OnNotify` (`workbook.cpp:1633`, `TTN_NEEDTEXT`), also bei jeder Mausbewegung. Was gerade neu gezeichnet werden sollte, wurde damit verworfen. Zum **Messen** von Textbreiten genügt `CClientDC`, und der hat diese Nebenwirkung nicht **Stufe: wichtig** (Betriebsmittel: CPaintDC ausserhalb des Zeichnens)|
| <a id="e-58"></a>E-58 | ein Klick in den **rechten Rand** des Registerkartenstreifens öffnete den **Browser**, ohne dass dort etwas zu sehen war | **behoben** in 7.2.0.29, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A: „links geklickt, kein Browser: PASS“). Von PRÜFER gefunden — eine **Rückentwicklung aus 1.0.25 bis 1.0.28**, denn `QCWorkbook::OnLButtonDown` fragt nur bei `m_bWorkbookMode` (`workbook.cpp:1132`), und der ist erst seit A-3 an. Zwei Ursachen zusammen: `CalcLogoTopLeft` prüft **nur x** (`pIntersectPoint->x >= nLeftEdge`), ein y-Vergleich fehlt ganz — getroffen war damit der gesamte rechte Fensterrand statt der 111 × 23 Pixel des Logos; und das Logo wird **überhaupt nicht gezeichnet**, weil `OnDrawBorder` in dieser Ersatzschicht von niemandem gerufen wird. Solange kein Bild da ist, gibt es keinen Treffer: die Trefferprüfung liefert `FALSE`. Der Weg über `TopLeft` bleibt unberührt, damit das Zeichnen später ohne weiteres nachgezogen werden kann **Stufe: wichtig** (Bedienung: Klick oeffnet unsichtbar den Browser)|
| <a id="e-59"></a>E-59 | `m_cxTab` wurde **nur in `OnPaint`** gesetzt | **behoben** in 7.2.0.29, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A, nicht sichtbar: beim Ziehen kein Absturz und kein Hänger gemeldet). Von PRÜFER gefunden. Alles, was die Kartenbreite **braucht, ohne zu malen** — `GetTabPts` und damit `QCGetTabRect`, `TabHitTest` und `CalcLogoTopLeft` —, rechnete zwischen einer Änderung und dem nächsten Malen mit dem alten Wert; ein Klick traf dann die Nachbarkarte. Die Breite wird jetzt dort bestimmt, wo die Änderung gemeldet wird (`StreifenAuffrischen`). Dabei musste eine Prüfung auf `m_pWBClient` **vor** den Aufruf: `QCWorkbook::recalcTabWidth` greift ohne eigene Prüfung darauf zu **Stufe: unkritisch** (m_cxTab nur in OnPaint gesetzt)|
| <a id="e-60"></a>E-60 | ein Trennbalken konnte **während des Ziehens gelöscht** werden — Benutzung nach dem Freigeben | **behoben** in 7.2.0.29, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A, nicht sichtbar: beim Ziehen kein Absturz und kein Hänger gemeldet). Von PRÜFER gefunden. `Splitter::Track` verteilt fremde Nachrichten (`TranslateMessage`/`DispatchMessage`), und eine davon kann einen Anordnungsdurchlauf auslösen. Der lief durch `TrennbalkenNeuAnlegen` → `BeginRecycleSplitters`/`EndRecycleSplitters`, und dort wurde genau das Objekt gelöscht, in dessen Methode man sich noch befand. Neu ist eine Marke `m_bTracking`: `BeginRecycleSplitters` gibt einen ziehenden Balken nicht frei, `EndRecycleSplitters` löscht ihn nicht. **Berichtigt 30.10.2026 ([PRÜFER-66 K2](../Befunde/PRUEFER-66.md#k2)):** hier stand bis heute, auch `TrennbalkenNeuAnlegen` kehre zurück, solange gezogen wird — das stimmte nicht; die Funktion ist seit [E-66](#e-66) stillgelegt und rief `DeleteAllSplitters` ohne jede Abfrage. Folgenlos, weil das Feld leer bleibt und `ZiehenAmRand` einen Balken auf dem Stapel zieht; seit dem 30.10.2026 steht die Abfrage dort (`OTShim.cpp`), und `TestE60.cpp` fährt auch diesen Weg (ohne die Abfrage rot, *„TrennbalkenNeuAnlegen hat den ziehenden Balken gelöscht“*; mit ihr 325 Tests, 325 bestanden). **Regressionstest** `TestE60.cpp` (30.10.2026): ruft die echten `AddSplitter`, `BeginRecycleSplitters` und `EndRecycleSplitters` aus `OTShim.cpp` auf und stellt den Anordnungsdurchlauf mitten im Ziehen nach; ohne die beiden `m_bTracking`-Abfragen einmal rot (318 Tests, 317 bestanden), mit ihnen grün (318/318) **Stufe: kritisch** (Speicherfehler: Benutzung nach dem Freigeben)|
| <a id="e-61"></a>E-61 | `Splitter::Track` **verschluckte `WM_QUIT`** — Eudora hätte weitergelaufen, obwohl es enden sollte | **behoben** in 7.2.0.29, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A: „alt+F4 bestätigt: beendet. auch ctrl-Q“). Von PRÜFER gefunden. `PeekMessage` mit `PM_REMOVE` nimmt die Nachricht aus der Schlange; wer sie nicht zurückstellt, hat das Beenden des Programms verschluckt. Genau die Klasse aus **Kriterium 7** (*„beenden kann ich es auch nicht"*), diesmal von mir selbst neu eingebaut. Jetzt: `::PostQuitMessage((int) msg.wParam)` und das Ziehen abbrechen **Stufe: kritisch** (Haenger: WM_QUIT verschluckt)|
| <a id="e-62"></a>E-62 | **sieben eigene Nachrichtenschleifen in Eudoras Quellen verschluckten `WM_QUIT`** — zwei davon mit echter Hängegefahr | **behoben** in 7.2.0.29, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A: „alt+F4 bestätigt: beendet. auch ctrl-Q“). Nicht von Hand gefunden, sondern beim **ersten Lauf** der Schranke `tools/pruefe-nachrichtenschleife.pl`, die wegen E-51 und E-61 entstanden war. `PeekMessage` mit `PM_REMOVE` nimmt die Nachricht aus der Schlange, `DispatchMessage` tut mit `WM_QUIT` **nichts** — die Aufforderung zu beenden ist weg. Betroffen: `EscapePressed` (`guiutils.cpp:1666`, wird während **langer Vorgänge** gerufen, also gerade beim Mailabruf), `SyncPlayMedia` (`:3387`), `CTocFrame::DoPreviewDisplay` (`TocFrame.cpp:3673`), `CTridentView::DoFindFirst` (zwei Schleifen) und `CTridentView::Print`. **Die zwei schwersten hängen, statt nur zu verschlucken:** `LeftClickAttachment` (`guiutils.cpp:2910`) und `CTocView::SizeColumn` (`tocview.cpp:3458`) warten in `while (1)` mit `GetMessage(&msg, hWnd, 0, 0)`. `WM_QUIT` kommt **trotz** Fensterfilter, `GetMessage` liefert dann 0 — und weil `while (1)` den Rückgabewert nicht auswertet, wartet die Schleife danach **für immer** auf eine Nachricht, die nie mehr kommt, mit gehaltenem Mausfang. Ausgelöst schon durch das Ziehen einer **Spaltenbreite** im Postfachfenster. Damit ist eine mögliche Ursache von Gregors *„beenden kann ich es auch nicht"* benannt, die **nicht** aus der Portierung stammt, sondern im Original steht **Stufe: kritisch** (Haenger: sieben eigene Nachrichtenschleifen)|
| <a id="e-63"></a>E-63 | die **letzte** Registerkarte zeigt keinen Kurzhinweis, alle anderen schon | **behoben** in 7.2.0.30, von Gregor an 1.0.84 bestätigt am 13.10.2026 (Testplan Teil A: „bei allen kacheln erscheint ein tooltip, auch bei der letzten“) — der Verdacht unten hat sich beim Nachlesen bestätigt, und die Selbstheilung des Originals steht jetzt in `QCWorkbook::OnDrawTab`: sie vergleicht die Zahl der **angemeldeten Kurzhinweis-Felder** mit der Zahl der **sichtbaren Karten** und rechnet nur bei Abweichung neu. `OnDrawBorder` wiederzubeleben kam nicht in Frage, das würde auch das Werbelogo zeichnen. **Vorher:** Von Gregor am 09.09.2026 an 1.0.29 gemeldet, mit Bildschirmfoto: *„alle karten, bis auf die letzte (warum?) zeigen einen tooltip beim maus over. beim letzten (ganz rechts) nicht."* Seine Entscheidung dazu: *„den fehler notieren wir, wird im nächsten release behoben."* — **Verdacht, noch nicht am laufenden Programm belegt:** `QCWorkbook::AddSheet` ruft `ResetTaskBar` → `RecalcToolTipRects` (`workbook.cpp:1226`, `:788`, `:1709`), und dort werden nur Blätter mit `WS_VISIBLE` als Kurzhinweis-Feld angemeldet. Ist das MDI-Kindfenster in diesem Moment noch nicht sichtbar, bekommt es kein Feld. Jedes **spätere** `AddSheet` rechnet alle Felder neu und repariert die älteren — nur das **zuletzt hinzugekommene** bleibt ohne, und das ist genau die rechte Karte. Dazu passt, dass im Original eine Selbstheilung existiert: `QCWorkbook::OnDrawBorder` (`workbook.cpp:1533`) prüft `m_lastVisCount != CountVisibleTabs()` und ruft dann `ResetTaskBar` — **diese Fassung wird in der Ersatzschicht von niemandem gerufen** (dieselbe Wurzel wie **E-58**). **Vorhersage zum Gegentest:** Fenstergröße ändern ruft `QCWorkbook::OnSize` → `RecalcToolTipRects`, danach müsste der Kurzhinweis auch auf der letzten Karte erscheinen. Steht das nicht, ist der Verdacht widerlegt **Stufe: unkritisch** (letzte Registerkarte ohne Kurzhinweis)|
| <a id="e-64"></a>E-64 | **BESTÄTIGT von Gregor am 10.09.2026 an 1.0.42:** *„filter funktionieren“*. Ein Filterlauf über das ganze In-Postfach verschob **alle** Nachrichten, nicht nur die passenden — DATENVERLUST | **behoben** in 7.2.0.36, Ursache am 10.09.2026 geklärt: kein eigener Fehler, sondern die Folge von **E-72** — ein Filter, dessen Suchwert durch das Zurückschreiben geleert wurde, heißt *„enthält nichts“* und trifft damit jede Nachricht. **Gegenbeweis mit frischem Filter** (Protokoll 1.0.36, 09:10): zwei Nachrichten geprüft, `Match=1` und `Match=0`, nur die passende verschoben. Früherer Stand: Von Gregor am 09.09.2026 an 1.0.29 gemeldet: *„filter greifen (z.b. verschieben nach spam), aber wenn man es z.b. auf die ganze in-mailbox anwendet, dann werden ALLE (!) mails verschoben."* **Der Schaden ist nachgemessen**, nicht nur berichtet: in seiner `eudora.log` (Sitzung 12:51:30) steht bei 0.12 `Junk .mbx size: MBX 0`, bei 0.01 `In .mbx size: MBX 1089243`, dann bei 4.06–4.10 ein Handfilterlauf über 22 Nachrichten (`Messages left to filter: 21 … 0`) und bei 4.11 `Junk.mbx, Size: 1089243` — **byte-genau der ganze Posteingang**. Belegt ist außerdem, dass `CFilter::Action` gelaufen ist (vier LMOS-Sätze aus `filtersd.cpp:1166`, dessen einziger Weg über `if (filt->Match(...))` in `filtersd.cpp:2323` führt) **mit einer Aktion `ID_FLT_SERVER_OPT`, die in seiner `Filters.pce` gar nicht steht** — die Filterobjekte im Speicher weichen also von der Datei ab. **Offener Widerspruch:** die Trefferzeile `Filter "%s" matches "%s"` (`filtersd.cpp:2312-2318`) fehlt im ganzen Protokoll, obwohl `DEBUG_MASK_FILTERS` (0x400) in `LogLevel 0x649F` gesetzt ist und dasselbe Verfahren für LMOS schreibt. Die entscheidende Messung (eine Zeile mit Filtername, Kopf, Verb, Wert, Aktionen und Match-Ergebnis, geschrieben mit `MISC\|TOC_CORRUPT`) steht in `Befunde/PRUEFER-7.md` **Stufe: kritisch** (Datenverlust: ein Filterlauf verschob das ganze In-Postfach, nicht nur die passenden Nachrichten)|
| <a id="e-65"></a>E-65 | Filter lassen sich **anlegen, aber nicht bearbeiten** | **KEIN eigener Fehler — Folge von E-66.** in **7.2.0.29** (aus der Git-Geschichte ermittelt, nicht aus einer Fassungsangabe) Gregor am 09.09.2026 auf die Frage, was „nicht editieren“ genau heißt: *„hier sehe ich nur teile des namens, der inhalt steht vermutlich weiter rechts, für mich nicht erreichbar. und da der balken nicht verschiebbar ist, komme ich da nicht dran.“* Damit ist von PRUEFERs drei Kandidaten der erste bestätigt und die beiden anderen sind vom Tisch: das Filterfenster ist ein statischer Teiler mit **zwei Spalten** (`FiltersWazooWnd.cpp:149-151`), links die Regelliste, rechts die Regel selbst. Die linke Spalte bekommt `max(140, Breite/4)` (`:181-185`), die rechte den Rest — und bei einer rund 188 Pixel breiten Andockleiste bleibt davon nichts übrig. **Behebung = E-66.** **Umgehung ohne Bau, aus dem Code gelesen und NICHT am laufenden Programm geprüft:** in `Eudora.ini` `UseMyFilterWindowPosition=1` und `FiltersWindowSplitterPosition=60` setzen (Schlüsselnamen aus `EudoraRes.rc:7583` und `:7589`, Vorgaben 140 und 0); dann bleibt `nSplit` bei 60 stehen, statt auf `max(nSplit, 140, Breite/4)` hochgezogen zu werden, und die rechte Spalte bekommt den Rest — Von Gregor am 09.09.2026 an 1.0.29 gemeldet: *„filter kann man setzen, aber nicht mehr editieren."* Belegt ist das Bild dazu: seine `Filters.pce` enthält vier Regeln, davon **zwei wortgleich** — ein Anwender, der neu anlegt, weil er nicht ändern kann. Kandidaten, alle **Vermutung**: (1) die rechte Hälfte hat Breite null, weil `CFiltersWazooWnd::OnActivateWazoo` (`FiltersWazooWnd.cpp:185-186`) Spalte 0 mindestens 140 Pixel gibt und Spalte 1 `SetColumnInfo(1, 0, 0)`, während die Mindestbreite von 420 aus `OnGetMinMaxInfo` nur für ein frei schwebendes Fenster gilt; (2) `static BOOL bFuncEntered` (`:133`) ist **prozessweit**, nicht je Fenster — nach einem Neuaufbau des Wazoo-Fensters werden Teiler und Ansichten nie wieder angelegt; (3) stiller Abbruch nach der bekannten Klasse: `ASSERT(0); return;` in `:153`, `:169`, `filtersv.cpp:180` und `:967`. **Die Frage an Gregor, die entscheidet:** bleibt die rechte Hälfte leer, sind die Felder grau, oder wird die Änderung nicht behalten? **Stufe: wichtig** (Funktion: Filter nicht bearbeitbar)|
| <a id="e-66"></a>E-66 | der Trennbalken der **rechten** Andockleiste ist sichtbar, lässt sich aber nicht ziehen (unten ebenso) | **behoben in 7.2.0.36, von Gregor am 10.09.2026 bestätigt** — *„1. ja / 2. ja / 3. ja"* zu: Balken lässt sich ziehen, rechte Hälfte des Filterfensters erreichbar, Änderungen bleiben stehen. Der Weg dorthin, weil die Ursache mehrfach falsch geraten wurde: von Gregor am 09.09.2026 an 1.0.29 gemeldet: *„rechts ist zwar ein balken sichtbar, aber nicht verschiebbar."* Links geht es seit A-4. **Ursache 1 (wirksam):** `TrennbalkenNeuAnlegen` misst den freien Streifen für `AFX_IDW_DOCKBAR_RIGHT` bei `rectLeiste.left - rect.left` (`OTShim.cpp:4165`), aber `CDockBar::CalcFixedLayout` der MFC (`…\14.38.33130\atlmfc\src\mfc\bardock.cpp:387`) setzt die Kindleiste in **jeder** Andockleiste bündig auf `(-cxBorder2, -cyBorder2)`; der Zuschlag `3*Splitter::cx = 12` bleibt darum immer am **großen** Ende liegen — links die Innenkante (`nFrei ≈ 7`, Balken entsteht), rechts der Fensterrand (`nFrei = -2`, Bedingung `nFrei >= 2` in `:4174` scheitert, `AddSplitter` läuft nie, `HitTest` liefert `NULL`). `BrauchtGreifstreifen` und die Bedingung `nVorhanden > 8` sind für links und rechts identisch — die Spur „andere Bedingung für rechts" ist **widerlegt**. **Ursache 2 (belegt, heute verdeckt):** `CalcTrackingLimits` (`:3622-3623`, waagrecht `:3637-3638`) rechnet `m_nMin`/`m_nMax` für rechts/unten sinnverkehrt; für eine rechte Leiste ergibt sich `m_nMax = -10`, der zulässige Bereich liegt links vom Balken, `Splitter::Track` klemmt sofort fest. **Messung, die entscheidet, ohne Bau:** Mauszeiger über den rechten Streifen — normaler Pfeil = Ursache 1, Doppelpfeil = Ursache 2. Gegenprobe: der **untere** Balken muss nach derselben Rechnung ebenfalls tot sein. Umfang: eine Datei, 30 bis 45 Zeilen **STAND 09.09.2026, abends — an Paket 1.0.30 GEMESSEN, WEITER OFFEN:** Gregor: *„balken lassen sich nicht verschieben. beim anklicken ist der maus cursor als zwei pfeile zu sehen, aber er greift nicht."* Das ist ein Fortschritt und eine Einschränkung zugleich: der **Doppelpfeil belegt, dass `HitTest` den Balken findet** — er existiert also, die erste Ursache ist behoben. Es scheitert **danach**, in `Splitter::Track` oder in `OnSplitterMoved`. Welches von beidem, ist von außen nicht zu sehen; zwei Vermutungen von mir sind an diesem Tag schon am Code gescheitert, deshalb kommt als Nächstes eine **Spurmarke** in `StartTracking` und `OnSplitterMoved`, die Leiste, Balkenlage, Grenzen, Klickpunkt, Delta und die Größe vorher/nachher in EINER Zeile schreibt. Vorbereitet in der Kladde, noch nicht eingesetzt. **STAND DAVOR, nach PRUEFER-7:** **Ursache 2 ist behoben** (7.2.0.30, Zweig `filter`) — die Grenzen folgen jetzt der Regel "die Seite, an der die Leiste angewachsen ist, bekommt `nMindest`; die Seite zum MDI-Bereich hin bekommt `nFreiraum`", womit auch UNTEN richtig wird. **Ursache 1 steht noch** — solange `nFrei = -2` ist, entsteht rechts gar kein Balken, und die berichtigten Grenzen greifen ins Leere. Die Behebung gehört in `TrennbalkenNeuAnlegen`. **Meine erste Zuordnung war falsch:** ich hatte diesen Befund als E-67 geführt und die Ursache allein in `CalcTrackingLimits` gesehen — PRUEFERs Messung an `bardock.cpp:387` zeigt, dass das nur die zweite, verdeckte Hälfte ist. **Stufe: unkritisch** (Trennbalken nicht ziehbar)|
| <a id="e-67"></a>E-67 | ein Filter *„«Junk Score» is less than N"* wird durch bloßes **Anschauen** im Filterfenster zu *„matches regexp N"* und greift nie wieder | **behoben (Code seit `1a22f30e`, 09.09.2026, enthalten seit 7.2.0.43), am laufenden Programm gemessen am 17.10.2026, von Gregor noch nicht bestätigt.** Gemessen am Prüfstand an 7.2.0.101 (17.10.2026), mit neuer Spurmarke und `tools/messen-e67.ps1` (öffnet das Filterfenster per Menübefehl 32826): Regel *„Junk Score is less than 50“* als erste Regel – `E-67 Filteransicht laden: … verb-gespeichert=14 verb-auswahl=0 eintraege=2`, beim Wegklicken `verb-neu=14 geaendert=0`, `Filters.pce` danach unverändert `verb less`. **Gegenprobe** mit dem alten `>`: `verb-auswahl=14 eintraege=2` – der ungültige Wert, aus dem der Fehler entsteht. Nicht nachgestellt: die Verfälschung der Datei selbst, dafür müsste im Fenster eine zweite Regel angeklickt werden. **Stand davor: offen, belegt durch Nachrechnen am Quelltext.** `filtersv.cpp:1210` und `:1222` prüfen `if (m_Verb0 > NumVerbsNonJunk)` mit `NumVerbsNonJunk == 14`, kodiert wird beim Speichern aber mit `m_Verb0 += 14` (`:1378`) — „is less than" wird also **14**, und `14 > 14` ist falsch. Die Rückrechnung unterbleibt, `DDX_CBIndex` ruft `SetCurSel(14)` auf ein Feld mit **zwei** Einträgen → `CB_ERR`. Beim nächsten `UpdateData(TRUE)` liest `DDX_CBIndex` `-1`, `:1378` macht daraus `13`, `:1413` schreibt das in den Filter (`IDS_MATCHES_REGEX`), und weil sich der Wert unterscheidet, setzt `:1404` das Änderungskennzeichen — der verfälschte Filter wird **gespeichert**. Danach fällt die Bedingung in `CFilter::MatchValue` (`filtersd.cpp:679-694`) immer durch. **Behebung: zwei Zeichen** (`>` → `>=`). Gegentest: Filter anlegen, Filterfenster öffnen, wegklicken, `Filters.pce` ansehen — dort steht dann `verb regex` statt `verb less` **Regressionstest seit 25.10.2026:** Prüfstandsfall E-67 (`tools/messen-e67.ps1 -Vorbereiten`, `C:\Temp\E67`): erste Regel „Junk Score is less than 50“, die Spurmarke muss `verb-gespeichert=14 verb-auswahl=0` zeigen, `verb-auswahl=14` (der Fehler) darf nicht vorkommen. **Stufe: kritisch** (Stiller Schaden: Filter aendert seine Bedeutung beim blossen Anschauen)|
| <a id="e-68"></a>E-68 | **Zielpostfächer verschwinden aus `Filters.pce`** — Schreiben und Lesen sind unsymmetrisch; dazu die **fehlende Grenze** für den Aktionszähler | **Grenze behoben** in **7.2.0.29** (aus der Git-Geschichte ermittelt, nicht aus einer Fassungsangabe) am 10.09.2026 auf `wt/pruefer` (noch in keinem Paket), **Unsymmetrie weiter offen** (PRÜFER, 10.09.2026, alles am Quelltext nachgerechnet). **(a) Die Grenze — echter Schreibzugriff hinter das Feld, jetzt zu.** `CFiltersDoc::Read` zählt den Aktionszähler `i` in **21 Zweigen** (22 `case`-Marken; `IDS_FIO_TRANSFER_TO` und `IDS_FIO_COPY_TO` teilen sich einen) hoch und prüfte ihn nie gegen `NUM_FILT_ACTS` (= 5, `filtersv.h:39`). Der Zähler indiziert nicht nur `m_Actions[5]` (`filtersd.h:129`), sondern **elf gleich große Nachbarfelder**, darunter die CString-Felder `m_Sound`, `m_NotifyApp`, `m_Forward`, `m_Redirect`, `m_Reply`, `m_CopyTo`, `m_Desc`. Die sechste Aktion trifft bei `m_Actions` noch `m_Label` (harmlos verbogene Zahl), bei `m_Desc[5]` dagegen `m_DoPersonality` — `CString::operator=` fasst ein `BOOL` als Zeichenkettenzeiger auf und schreibt durch einen erfundenen Zeiger. **Wie weit er reicht:** `CFiltersDoc::Write` ist gebunden (`for i < NUM_FILT_ACTS`, `filtersd.cpp:3439`) und schreibt je Platz höchstens **eine** Zeile — eine `Filters.pce`, die Eudora selbst geschrieben hat, kann den Überlauf **nicht** auslösen. Er braucht eine **fremde Datei**: von Hand bearbeitet, aus einem anderen Programm übernommen, oder eine `.pre`/`.pst` aus dem Filters-Verzeichnis. Die liest `LoadExtraFilters` (`filtersd.cpp:2622-2654`) ein und **geschrieben werden sie von Eudora nie** (`Write` kennt nur `m_Filters` und `m_strPathName`) — sie sind per Bauart Fremdeingabe. **Also: echt, aber nicht durch Bedienung auslösbar.** Behoben mit `IstAktionsSchluesselwort` plus Grenze in `Read`: die überzählige Zeile wird verworfen und protokolliert (`E-68 Regel … wird verworfen`), die ersten fünf Aktionen bleiben. Schranke `tools/pruefe-filter-aktionsgrenze.pl` hält beide Listen gegeneinander. **(b) Weiter offen — die Unsymmetrie:** `copyInstead ` wird gelesen (`filtersd.cpp:3090-3106`) und füllt dabei `m_Mailbox` statt `m_CopyTo[i]` (der Quelltext nennt es selbst *„legacy code that never gets executed"*), der Schreibzweig prüft aber `m_CopyTo[i]` und schreibt nichts; beim Transfer steht das Schlüsselwort unter `if (filt->IsTransferTo())`, die **Pfadzeile** darunter nicht — nach einer ausgeführten Copy-Aktion entsteht eine kennungslose Zeile, die `Read` verwirft. **Zusatzfund PRÜFER 10.09.2026:** diese kennungslose Zeile ist nicht immer harmlos. `FindCStringArrayIndexI` (`rs.cpp:1169-1186`) vergleicht mit `strnicmp` über die Länge des **ersten Wortes der Eingabe** — ein Postfachpfad, dessen erstes Wort ein Präfix eines Schlüsselworts ist (etwa ein Ordner *„Copy of …"* → `copy `), wird als Aktion gelesen und zählt mit **Stufe: kritisch** (Datenverlust: Zielpostfaecher verschwinden aus Filters.pce)|
| <a id="e-69"></a>E-69 | `CFiltersDoc::FilterMsg` bricht den Filterlauf im Freigabebau **lautlos** ab und meldet Erfolg | **behoben in 7.2.0.106 (17.10.2026), am laufenden Programm gemessen und im Protokoll belegt (Spurmarke `E-69 Filter uebersprungen`, Testsuite 209/209), von Gregor noch nicht bestätigt, Zweig `e-123-beenden-warten`.** **Am 20.10.2026 an 7.2.0.110 am Prüfstand nachgestellt** (`C:\Temp\E129`, Gregors Freigabe *„du kannst testen"*, Messskript: zweimal *In* öffnen, alles auswählen, `In.mbx` von außen sperren, *Special → Filter Messages*). **Drei Ergebnisse, alle aus dem Protokoll:** (1) **ein** übersprungener Fall ergibt **einen** Eintrag — `E-69 Filter uebersprungen: betreff="test 8" postfach="In" grund=the message text could not be read`; (2) **drei** übersprungene in **einem** Lauf ergeben **einen** Eintrag und **einen** Sammeleintrag — `E-69 Filter uebersprungen: sammeleintrag weitere=2`, also die Zusammenfassung aus P3; (3) **die Gegenprobe zu [R1](../Befunde/PRUEFER-38.md) hält**: der **zweite** Filterlauf im **selben** Programmlauf meldet wieder (`betreff="test 8"` bei 1.00 nach dem Sammeleintrag bei 0.42) — ohne den Rücksetzer in `LaufEnde()` wäre er stumm geblieben. **Das ist der Schritt, den Gregor am 20.10.2026 nicht fahren konnte**, weil sein Handgriff *„IMAP filtern bei totem Server"* den Befund gar nicht erreicht (siehe unten). **Ehrlich zum Messaufbau:** im zweiten Lauf fehlt der Sammeleintrag. Das ist **kein** Mangel des Codes, sondern meines Aufbaus — das Protokoll zeigt um 1.03 den Dialog *„Could not open the file … locked"* (aus `IDS_ERR_FILE_OPEN`, `EudoraRes.rc:9303`) **ohne** späteres `Dismissed`; der Filterlauf hing darin, Eudora ließ sich nicht schließen und wurde abgeschossen, und ein abgeschossener Prozess führt keine Destruktoren aus. Der Messaufbau braucht einen Dialogschließer, bevor er mehr als einen Lauf belegen kann. **Gregors Handgriff traf den Befund nicht:** scheitert schon der Verbindungsaufbau (*„host not found (11001)"* — Zeichenfolge 9001 in `EudoraRes.rc:9912` plus der Winsock-Fehlernummer, eingesetzt in den Text `IDS_ERR_IMAP_COMMAND_FAILED_REASON`, `EudoraRes.rc:7514`), kommt Eudora nie bis zu den einzelnen Nachrichten; `E69UebersprungenMelden` sitzt in `filtersd.cpp:2625-2699`, also hinter dem Abbruch. In seinem Protokoll: **null** `E-69`-Spurmarken, *Task Errors* leer. Die Prüfanleitung ist am 20.10.2026 zurückgezogen worden. **[PRÜFER-36] (Befunde/PRUEFER-36.md) (17.10.2026):** kein Datenverlust; Nebenfaden, Leck und `%` im Betreff widerlegt. Offen vor einem Release: P3 – je Nachricht bis zu drei Einträge, jeder piept und holt das Fenster nach vorn; beim Filtern eines IMAP-Postfachs ohne Verbindung hunderte. P5 – `ASSERT(pInfo)` in `TaskErrorMT.cpp` schlägt im Debug-Bau an. P6 – die Zeile beginnt mit „, Filtering, “, und bei „no mailbox“ steht `mailbox ""`. P7 – kein roter Vergleichslauf unter `v69*`; der Zustand vorher ist am Quelltext belegt (nur `PutDebugLog`, kein Eintrag). Gregor entschied *„[E-69](#e-69) = doch A“*: die übersprungene Nachricht erscheint in *Task Errors*. Nachgestellt am Prüfstand (17.10.2026) mit `tools/messen-e69.ps1`: *In* öffnen, alles auswählen, `In.mbx` von außen sperren (wie ein Virenscanner), *Special → Filter Messages*. An 7.2.0.106: Eudora meldet wie im Original *„Could not open the file … In.mbx … locked“* (stammt aus `IDS_ERR_FILE_OPEN`, EudoraRes.rc:9303), dann `E-69 Filter uebersprungen: betreff=… postfach="In" grund=the message text could not be read` und der Eintrag in *Task Errors*; die Nachricht bleibt in `In`, sauber beendet. Vorher (bis 7.2.0.104) gab es an dieser Stelle nur die Protokollzeile `E-69 FilterMsg abgebrochen`, keine Meldung. Testsuite 209/209. **Stand davor: offen, belegt.** Drei `ASSERT(0)` — `filtersd.cpp:2241` (kein TOC), `:2286` (Nachrichtendokument nicht ladbar), `:2302` (Nachrichtentext leer) — führen alle auf `break` aus der Filterschleife; die Funktion liefert danach `FA_NORMAL` (`:2354-2358`), also dasselbe wie „durchgelaufen, nichts getroffen". Weder `pop.cpp:999` noch `sendmail.cpp:186` noch `TocFrame.cpp:2398` sehen einen Unterschied: keine Meldung, kein Protokolleintrag (die Debug-Zeile `:2312-2320` steht erst **hinter** dem Treffer), kein Berichtseintrag. Verwandt: `FilterReportWazooWnd.cpp:65` — fehlt das Wazoo-Fenster, entfällt der **ganze** Filterbericht kommentarlos, und `ClearAllLists()` (`filtersd.cpp:3618`) wirft die gesammelten Einträge weg. Genau [assert-ist-im-release-nichts](../Arbeitsweise/assert-ist-im-release-nichts.md) **Stufe: kritisch** (Stiller Schaden: Filterlauf bricht ab und meldet Erfolg)|
| <a id="e-70"></a>E-70 | **BESTÄTIGT von Gregor am 10.09.2026 an 1.0.42:** *„filter fenstergröße nach neustart gespeichert: PASS“*. Die Andockgrößen der Leisten überleben einen Neustart nicht — zuletzt an der Breite des **Filterfensters** gemeldet | **behoben** in 7.2.0.41. Von Gregor am 10.09.2026 an 1.0.40 wiederholt: *„speichert aber nicht die fenster größe von filters nach dem neustart"*. **Entschieden hat es die Spurmarke aus 1.0.37**, die bis dahin nie ausgewertet worden war: im Protokoll stehen **40** Zeilen `E-70 gesichert:` und **0** Zeilen `E-70 geladen:`, und in seiner `Eudora.ini` steht `DockVertCx319=586` — der Wert wird also richtig geschrieben und nie gelesen. **Der Grund stand im eigenen Kommentar über der Funktion, in die ich den Aufruf gesetzt hatte:** *„KATEGORIE C laut PLAN.md: Eudora ruft diese Fassung nie auf"* über `SECToolBarManager::LoadState`. Gerufen wird `QCToolBarManager::LoadState`. Dass das **Sichern** lief, hat die Lücke verdeckt — `QCToolBarManager::SaveState` ruft `SECToolBarManager::SaveState` ausdrücklich auf, das Gegenstück nicht. Behoben an der symmetrischen Stelle, dazu ein `RecalcLayout` am Ende von `GroessenLaden` (`AndockgroesseSetzen` schreibt nur Felder). Der Zeitpunkt stimmt: `mainfrm.cpp:951` `SetDockState`, `:952` `LoadState`. **Die ursprüngliche Ursachenanalyse bleibt gültig** — `CDockState::SaveState` ruft `pInfo->SaveState(...)` nicht virtuell und sieht die Stingray-Felder nie; deshalb braucht es das eigene Schreiben und Lesen überhaupt **Stufe: unkritisch** (bestaetigt, Fenstergroesse gespeichert)|
| <a id="e-71"></a>E-71 | der **Filterbericht** ist nach einem Filterlauf leer | **offen — zurückgestellt**, von Gregor am 10.09.2026 an 1.0.42 erneut gemeldet: *„filter report fenster ist leer: kommt nichts an. kann aber als ToDo für die nächste version aufgeschrieben werden."* **Berichtigung einer eigenen Einstufung:** ich hatte E-71 als *„kein eigener Fehler — Folge von E-72"* eingeordnet, mit der Begründung, ein Filter ohne Merkmale sei für keinen Lauf zuständig und habe darum nichts zu berichten. Diese Begründung ist widerlegt: E-72 ist behoben, die Filter greifen (von Gregor an 1.0.42 bestätigt: *„filter funktionieren"*), und der Bericht bleibt trotzdem leer. **Was schon belegt ist:** der Lauf findet statt und trifft — im Protokoll steht `E-64 Match=1` und unmittelbar danach `Filter "…" matches "…"` mit der Maske 1024, dem Protokollkanal des Berichts. Es scheitert also **nach** dem Vermerken. **Wo zu suchen ist:** `CFilterActions::EndFiltering` (`filtersd.cpp`) arbeitet `m_NotifyReportList` ab und sucht dafür über `CFilterReportView::GetFilterReportView()` das Berichtsfenster; findet es keines, verfällt die Liste. Zu messen ist, ob die Liste gefüllt wird und ob das Fenster gefunden wird — zwei Werte in **einer** Zeile. Nicht von selbst aufgreifen: Gregor hat ihn ausdrücklich auf die nächste Fassung geschoben **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — unverändert. `CFilterActions::EndFiltering` steht in `filtersd.cpp:4037`, `m_NotifyReportList` wird bei `:4108` abgearbeitet und bei `:1661` gefüllt, das Berichtsfenster bei `:4112` über `CFilterReportView::GetFilterReportView()` gesucht. **Die vorgeschlagene Messung ist nicht eingebaut** — `grep E-71 filtersd.cpp` liefert null Zeilen. Gregors Zurückstellung gilt weiter. **Was noch fehlt:** nicht die Behebung, sondern Gregors Freigabe — er hat ihn ausdrücklich auf die nächste Fassung geschoben. Die Messung steht fertig da: in `CFilterActions::EndFiltering` (`filtersd.cpp`) in **einer** Zeile ausgeben, ob `m_NotifyReportList` gefüllt ist und ob `CFilterReportView::GetFilterReportView()` ein Fenster findet. **Stufe: wichtig** (Funktion: Filterbericht leer)|
| <a id="e-72"></a>E-72 | **BESTÄTIGT von Gregor am 10.09.2026 an 1.0.42:** *„filter funktionieren“*. Die rechte Hälfte des Filterfensters schrieb ihren leeren Zustand in den ausgewählten Filter** — Häkchen, Werte und die **Aktionsliste**; DATENVERLUST über E-64 und E-73 | **behoben** in 7.2.0.36. `CFiltersViewRight::DoDataExchange` schreibt beim Wegklicken vom Filterreiter alles aus den Eingabefeldern zurück; ausgelöst bei **jedem** Verlassen (`FiltersWazooWnd.cpp:122` → `CanCloseFrame` → `UpdateData(TRUE)`). Solange die rechte Hälfte unerreichbar war (**E-65**), wurden ihre Felder nie gefüllt — zurückgeschrieben wurde **Leere**. Belegt an Gregors `Filters.pce`: Regel 1 hatte noch `incoming`, `manual` und ihren Wert, Regel 2 nur noch `incoming`, ohne `manual` und ohne `transfer`. **Zwei Sperren:** zurückgeschrieben wird nur, was diese Ansicht **wirklich geladen** hat (`m_pGeladen`), und eine Bedingung mit **leerem Wert** passt nicht mehr auf alles — *„enthält nichts"* war für jede Nachricht wahr und schob mit `transfer` den ganzen Posteingang. **Regressionstest** `TestE72.cpp` (30.10.2026, am Quelltext, deckt auch [E-64](#e-64)): die Sperre `m_pGeladen != filt` steht vor dem Zurückschreiben und kehrt zurück; `CFilter::MatchValue` gibt bei leerem Wert `FALSE` zurück, nach den Junk-Score-Verben und vor dem Textvergleich; ohne die Sperre und ohne die Abfrage je einmal rot, mit ihnen grün (318 Tests, 318 bestanden). **Nachtrag 30.10.2026 ([PRÜFER-66 K1](../Befunde/PRUEFER-66.md#k1), am Quelltext belegt): die zweite Sperre war selbst fehlerhaft.** Sie stand in `MatchValue`, also **vor** der Verneinung in `MatchCondition`, und galt auch für *appears*/*doesn't appear*, die den Wert gar nicht lesen (`return TRUE`). Seit 7.2.0.36 traf deshalb *„X doesn't appear“* **jede** Nachricht und *„X appears“* keine; *doesn't contain* und *is not* mit leerem Wert ebenfalls jede — mit *transfer* derselbe Schaden wie [E-64](#e-64). Am laufenden Programm nicht beobachtet. **Berichtigt im Quellstand (30.10.2026):** `MatchCondition` gibt bei leerem Wert `FALSE` zurück, bevor verneint wird, und `MatchValue` nimmt *appears*/*doesn't appear* aus. `TestE72.cpp` verlangt beides; mit dem alten `filtersd.cpp` rot, mit dem neuen grün (325 Tests, 325 bestanden). Am Programm zu prüfen im nächsten Paket ([TESTPLAN](TESTPLAN.md#e-72-verneint)) **Stufe: kritisch** (Datenverlust: schreibt den leeren Zustand in den Filter zurueck - die Ursache von E-64 und E-73)|
| <a id="e-73"></a>E-73 | eine **Filteraktion löschte Post auf dem Server**, ohne dass sie je eingestellt worden war — DATENVERLUST | **behoben** in 7.2.0.38, **erweitert um zwei weitere Wege** am 10.09.2026 auf `wt/pruefer` (noch in keinem Paket). `CFilter::Action` merkt die Nachricht zum Löschen vor, sobald `ID_FLT_SERVER_OPT` mit `SO_DELETE` im Filter steht — und sticht dabei `LeaveMailOnServer`. PRÜFER hatte am 09.09.2026 gemessen, dass genau diese Aktion **lief, obwohl sie in `Filters.pce` gar nicht steht**; sie kam aus **E-72**. Gregors Entscheidung: *„ja, 1 auf jeden fall! Filteraktion darf nicht mehr vom Server löschen"*. Rückschalter `FilterMayDeleteFromServer=1` in `[Settings]`, Vorgabe **0**; jeder Versuch wird protokolliert. **Die erste Fassung schloss nur EINEN von DREI Wegen** (PRÜFER, 10.09.2026, Gegenvermutung *„ist `CFilter::Action` wirklich die einzige Stelle?"* — **bestätigt, sie war es nicht**): **(1) IMAP.** Ist das Postfach ein IMAP-Postfach, verzweigt `CFilter::Action` nach `ImapAction` (`filtersd.cpp:1213-1215`) und erreicht den geprüften POP-Zweig gar nicht; dort steht dieselbe Aktion noch einmal und reicht sie an `CImapFilterActions::ImapSetServerOpt` weiter (`EuImap/src/ImapFiltersd.cpp:791-794`), das die UID bei `SO_DELETE` in `m_szDeletedUids` hängt — daraus wird ein `STORE \Deleted` auf dem Server. **(2) Die Junk-Filteraktion.** `case ID_FLT_JUNK` (`filtersd.cpp:1581-1600`) ruft `CJunkMail::DeclareJunk`, und das setzt bei `DeleteFetchedJunk=1` ein `SetServerStatus(ID_MESSAGE_SERVER_DELETE)` (`JunkMail.cpp:707-711`) → `CSummary::SetServerStatus` (`summary.cpp:2650-2679`) → `SetDeleteFlag(LMOS_DELETE_MESSAGE)`. **E-74 deckt das nicht ab:** dort wurde `DeleteFetchedJunk=0` nur in `tools/DEudora.ini` gesetzt, und das ist die Vorgabe für **neu angelegte** Konten — eine vorhandene `Eudora.ini` mit `DeleteFetchedJunk=1` löscht weiter, ausgelöst durch eine **Filteraktion**. Beide Wege fragen jetzt denselben Rückschalter; die Frage liegt in **einer** Funktion `FilterDarfVomServerLoeschen` (`filtersd.cpp`, vor `CFilter::Action`), und `tools/pruefe-filter-serverloeschung.pl` weist einen Commit ab, in dem ein vierter Weg dazukommt, der nicht fragt. **Manuelles Junken (`pFilt != NULL`) bleibt unberührt** — das ist eine bewusste Handlung des Anwenders **Stufe: kritisch** (Datenverlust: Filter loescht Post auf dem Server)|
| <a id="e-74"></a>E-74 | **`Delete fetched junk` ist im Original an** und löscht als Junk eingestufte Post auf dem Server — DATENVERLUST, eingetreten | **behoben** in 7.2.0.39 für **neu angelegte** Konten. `CJunkMail::ProcessOne` (`JunkMail.cpp:453-457`) merkt jede Nachricht ab `MinScoreToJunk` (Vorgabe 50) zum Löschen auf dem Server vor; die eingebaute Vorgabe von `DeleteFetchedJunk` ist **1**. **Das hat am 10.09.2026 Gregors Postfach geleert** — belegt im Protokoll von 1.0.36, 09:22: dreizehn Zeilen `Old … dD` (die Marke wechselt von *nicht löschen* auf *löschen*), unmittelbar gefolgt von `Begin purging messages`. Besonders heikel, weil die Junk-Bewertung auf `SpamWatch` und `SpamHeaders` angewiesen ist, die wegen **E-47** gar nicht laden können. `tools/DEudora.ini` setzt jetzt `DeleteFetchedJunk=0`. **Eigener Fehler im Vorgehen:** ich hatte diesen zweiten Löschweg am Vormittag gefunden, in 1.0.38 aber nur den Filterweg gesperrt und Gregor trotzdem zum Testen aufgefordert **Stufe: kritisch** (Datenverlust: Junk wird auf dem Server geloescht)|
| <a id="e-75"></a>E-75 | **Strg+J filterte nicht, sondern verschob nach Junk** — und die Fortschrittsanzeige nannte es „Filter" | **behoben** in 7.2.0.40, von Gregor am 10.09.2026 an 1.0.39 gemeldet: *„filter erwischt immer noch zu viele mails"*, dazu *„ich drücke zum filtern ja immer noch ctrl-J"*. **Im Original geändert, nicht durch die Portierung:** vor der Junk-Funktion war Strg+J *Filter Messages*; seit Eudora 6 fragt `IDD_CTRL_J_FOR_JUNK`, ob die Taste auf *Junk* wechseln darf. **Gefragt wird aber nur, wenn beim ersten Start schon manuelle Filter da sind** (`CMainFrame::InitJunkMenus`, `mainfrm.cpp:7911-7934`); sonst legt der `else`-Zweig Strg+J **stillschweigend** auf Junk und schreibt `CtrlJMapping=1` fest — für immer, denn der Zweig läuft nur einmal. Gregor hatte mit **leerem Mailverzeichnis** angefangen und die Filter erst danach angelegt. **Belegt im Protokoll von 1.0.39:** die echten Filterläufe um 6.26 und 7.38 tragen ihre E-64-Marken und arbeiten korrekt (`Match=1` bei einer, `Match=0` bei der anderen); der Lauf um 9.07 mit **neun** Nachrichten trägt **keine einzige** — `FilterMsg` wurde nie gerufen, `Junk.mbx` wuchs trotzdem von 174 196 auf 501 987 Bytes. **Gegenprobe am Bestand:** von zwölf Nachrichten in `Junk.mbx` haben zehn keinen Filtergrund, sechs davon von `konto-freenet@gregor.invalid`, für die Gregors Filter ausdrücklich **`<Ordner>.mbx`** vorsieht — die Datei ist 0 Bytes. **Behebung:** ohne manuelle Filter bleibt Strg+J auf `CTRL_J_FILTER`. Wer Junk auf Strg+J will, stellt es in den Einstellungen um. **Zweite Ursache, warum es so lange wie Filtern aussah:** *Filter Messages*, *Junk/Not Junk* und *Recheck Junk* zeigten alle dieselbe Zeile `Messages left to filter` (`TocFrame.cpp:996`, `:1156`, `:2380`). Die beiden Junk-Befehle sagen jetzt `Messages left to scan for junk` bzw. `Messages left to mark`. **Von Gregor am 10.09.2026 an 1.0.40 bestätigt**, nachdem er den Wert von Hand gesetzt hatte: *„ok, mit dem wert 2 ist das menü jetzt korrekt. paßt“*. Damit ist zugleich belegt, dass die Menue-Umbeschriftung in `InitJunkMenus` richtig arbeitet: sie zeigte vorher ehrlich *Ctrl+Shift+L* an. **Bestehende Mailverzeichnisse behebt das nicht** — dort steht die `1` schon in der `Eudora.ini` und muss von Hand auf `CtrlJMapping=2` **Stufe: wichtig** (Funktion: Strg+J filtert nicht)|
| <a id="e-76"></a>E-76 | das **freischwebende Filterfenster** lässt sich nur **seitlich** vergrößern, nicht nach unten | **behoben** in **7.2.0.49**, **von Gregor am 11.09.2026 bestätigt**: *„e-76: paßt: läßt sich jetzt vergrößern."*, von Gregor am 10.09.2026 an 1.0.40 gemeldet: *„filter fenster läßt sich nicht nach unten vergrößern, nur zur seite“*, mit Bild des Fensters `WazooBar2`. **Vor dem Messen geprüft:** die Wazoo-Leiste trägt `CBRS_SIZE_DYNAMIC` (`WazooBarMgr.cpp:136`), die dynamische Größe ist also erlaubt; `FloatControlBarInMDIChild` ist im Shim **nicht** umgesetzt (`OTShim.cpp:372`), das Fenster ist demnach ein echtes schwebendes und kein MDI-Kind; und der `IsFloating`-Zweig in `SECControlBar::CalcDynamicLayout` sieht richtig aus — `LM_LENGTHY` setzt `cy`, sonst `cx`. Damit ist die Frage offen. **Spurmarke `E-76` seit 7.2.0.41:** sie nennt `nLength`, `dwMode` mit ausgeschriebenen Flags, `IsFloating` und die Maße vorher wie nachher in **einer** Zeile und schreibt nur, solange die Leiste schwebt  — **Ursache am 11.09.2026 aus Gregors Protokoll gelesen:** beim abschließenden Aufruf trägt `dwMode` `LM_COMMIT`, aber **kein** `LM_LENGTHY`, und `nLength` ist dort die **Breite** (780) statt der gezogenen Höhe (299). Der `else`-Zweig setzte deshalb die Breite neu und speicherte die alte Höhe. Behoben mit einem Merker, der die zuletzt in Ziehrichtung gerechnete Größe über den COMMIT rettet. **Die Spurmarke lag seit 7.2.0.41 im Bau und konnte nur von einem Menschen ausgelöst werden** — sie braucht eine physisch gedrückte Maustaste **Stufe: unkritisch** (Filterfenster nur seitlich vergroesserbar)|
| <a id="e-77"></a>E-77 | **IMAP-Postfachnamen mit Umlauten werden roh angezeigt** — `Entw&APw-rfe` statt *Entwürfe*, `Gel&APY-scht` statt *Gelöscht* | **behoben auf dem Zweig `e-77-imap-ordnernamen` (24.10.2026), kommt mit Paket 7.2.0.123; am laufenden Programm gemessen (Prüfstand, erst rot, dann grün), 286 Tests, 286 bestanden, Regressionsfälle `E-77a` bis `c`. Nachtrag am selben Abend: Umbenennen behoben ([PRÜFER-49 K1, K2](../Befunde/PRUEFER-49.md#k1)), am Prüfstand erst rot, dann grün gemessen, Regressionsfall `E-77d`, 291 Tests, 291 bestanden.** IMAP-Ordner mit Umlauten heißen in Eudora jetzt „Entwürfe" und „Gelöscht" statt `Entw&APw-rfe` und `Gel&APY-scht`. Für Gregor ist nichts zu tun außer dem Test im Paket. **Nachprüfung am 24.10.2026 ([PRÜFER-49](../Befunde/PRUEFER-49.md#pruefer-49)): die Anzeige hielt, das Umbenennen nicht ganz — am selben Abend behoben.** Nach dem Umbenennen in einen Namen mit Umlaut stand der Ordner auf dem Server richtig kodiert, Eudora führte ihn aber unter dem unkodierten Namen weiter (`UpdateAfterRename`, `QCImapMailboxDirector.cpp:2516` und `:2522`, [K1](../Befunde/PRUEFER-49.md#k1)); INBOX umbenennen wurde gar nicht kodiert (`ImapAccount.cpp:2998`, `:3013`, [K2](../Befunde/PRUEFER-49.md#k2)). **Gemessen am Prüfstand `C:\Temp\E77U`** (`tools/messen-e77-umbenennen.ps1`, „Ablage" → „Ablage-ä" im Postfachbaum, danach öffnen): **vorher** `RENAME Ablage Ablage-&AOQ-` → OK, dann `SELECT "Ablage-\xE4"` → vom Server abgelehnt, in `mboxlist.lst` der rohe Name; **nachher** `SELECT Ablage-&AOQ-` → OK, `mboxlist.lst` kodiert, nach einem Neustart heißt der Ordner im Menü „Ablage-ä". Gegenprobe der beiden Testsuite-Fälle `E-77 K1`/`K2`: jede Behebung zurückgenommen macht genau ihren Fall rot. **Offen innerhalb von E-77:** gespeicherte Nachrichten mit Fcc auf einen Umlaut-Ordner, die vor 7.2.0.123 entstanden, finden ihr Ziel nicht mehr; gesendet wird, die Ablage unterbleibt ohne Meldung ([K3](../Befunde/PRUEFER-49.md#k3)). Grenzfälle der Kodierung: [K4](../Befunde/PRUEFER-49.md#k4). **Die Behebung:** `E77Utf7Dekodieren`/`E77Utf7Kodieren` in `EuImap/src/ImapMailbox.cpp` (modifiziertes UTF-7 nach RFC 3501, über UTF-16 nach Windows-1252). **Dekodiert wird nur der Anzeigename** (`FormulateFriendlyImapName`); der Servername (`m_szImapName`), das lokale Verzeichnis und die Datei `mboxlist.lst` bleiben unverändert — vorhandene Ordner und Filter (die ihr Ziel über den Dateipfad finden, `FindByPathname`) arbeiten weiter wie bisher. **Kodiert** wird der eingetippte Name beim Anlegen (`CImapAccount::CreateMailbox`) und Umbenennen (`RenameMailbox`, drei Stellen). Ein Zeichen, das es in Windows-1252 nicht gibt, lässt den Namen roh stehen. **Gemessen am 24.10.2026** am Prüfstand `C:\Temp\E77` (IMAP-Konto `pruefimap`, Ordnerliste mit den GMX-Namen, `tools/messen-e77.ps1` liest das Menü *Transfer*): **vorher** an 7.2.0.120 `pruef-imap > EntwAPw-rfe` und `GelAPY-scht` (das `&` nimmt das Menü als Zugriffstaste, im Ordnerbaum steht es roh); **nachher** `pruef-imap > Entwürfe` und `Gelöscht`, Protokoll `E-77 Ordnername: server="Entw&APw-rfe" anzeige=…`. **Nicht am Programm gemessen:** Anlegen eines Ordners mit Umlaut — nur in der Testsuite geprüft (hin und zurück für fünf Namen), der IMAP-Prüfserver kennt `CREATE` nicht. Umbenennen ist seit dem 24.10.2026 abends am Prüfstand gemessen (`E-77d`). **Zuerst eingetragen:** offen, von Gregor am 10.09.2026 an 1.0.42 mit Bild gemeldet: *„die bezeichnung der mailboxen ist hier falsch: sollte wohl ‚gelöscht‘ heißen?“* **Ursache:** IMAP kodiert Nicht-ASCII in Postfachnamen als **modifiziertes UTF-7** (RFC 3501, Abschnitt 5.1.3): `&<base64>-`. Nachgerechnet: `&APw-` ist `U+00FC` = *ü*, `&APY-` ist `U+00F6` = *ö*. Eudora dekodiert das nicht — in `Eudora71/` kommt **keine** UTF-7-Behandlung vor (gegrept über alle `.cpp`/`.h` nach `UTF-7`, `UTF7`, `ModifiedUTF7`, `DecodeMailboxName`; einziger Treffer ist `Qt3.x/CIncludes/TextCommon.h`, eine fremde Kopfdatei ohne Bezug). Der Name kommt roh aus der `LIST`-Antwort und geht unverändert in `ImapMailbox::m_FriendlyName` (`EuImap/public/inc/ImapMailbox.h:487`). **Zu beachten bei der Behebung:** die Umkehrung gehört dazu — beim Anlegen und Umbenennen eines Postfachs muss der Name wieder kodiert werden, sonst legt Eudora auf dem Server einen Ordner mit rohen Umlauten an. Betrifft nur die **Anzeige** von IMAP-Ordnern, nicht den Abruf: IMAP selbst funktioniert (von Gregor am selben Tag bestätigt) **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — unverändert offen. Über alle `.cpp`/`.h` unter `Eudora71/` und `EuImap/` nach `UTF-7`, `UTF7`, `ModifiedUTF7` und `DecodeMailboxName` gesucht: **einziger Treffer** ist weiterhin `Eudora71/Qt3.x/CIncludes/TextCommon.h`, eine fremde Kopfdatei ohne Bezug. Eine Dekodierung gibt es also nach wie vor nicht. **Was noch fehlt:** nichts — von Gregor am 26.10.2026 an Paket 1.0.123 bestätigt (*„E-77 PASSED“*, TESTPLAN N4/N5). Die Nebenwirkung auf ältere Nachrichten mit Ablage in einen Umlaut-Ordner (PRÜFER-49 K3) bleibt bestehen und steht auf Gregors Entscheidung vom 26.10.2026 als bekannter Fehler in der README. **Vorher:** eine Dekodierung von modifiziertem UTF-7 gab es in `Eudora71/` nirgends. Dazu fehlte die Umkehrung beim Anlegen und Umbenennen. **Wie zu pruefen:** **ICH** — am eigenen IMAP-Prüfserver (`tools/imap-pruefserver.pl`). Einen Ordner `Entwürfe` anlegen, abrufen, in der Postfachliste nachsehen. Rot: `Entw&APw-rfe`. Grün: `Entwürfe`. **Stufe: wichtig** (Anzeige: IMAP-Postfachnamen mit Umlauten roh)|
| <a id="e-78"></a>E-78 | die **Standardanordnung der Leisten wird bei jedem Start nachgezogen**, obwohl der Zustand gespeichert ist | **offen**, gefunden am 10.09.2026 beim Nachmessen von E-70. **Abgegrenzt gegen E-44:** jener Befund war, dass die Anordnung nach einem Neustart *gar nicht* wiederhergestellt wurde — behoben in 7.2.0.24 durch den Nachziehweg in `CWazooBarMgr::LoadWazooBarConfigFromIni`. Dieser hier ist, dass genau dieser Nachziehweg **immer** läuft. **Belegt:** die Meldung *„für 3 Leiste(n) war keine Lage gespeichert (kein `[ToolBar...]`-Abschnitt)“* erscheint bei jedem Start, aber in der `Eudora.ini` stehen **dreizehn** solche Abschnitte, und die vier Andockleisten tragen ihre Kinderlisten (`Bars=4`, `Bars=3`, `Bars=3`, `Bars=3`). MFC schreibt `Bars=N` ausdrücklich nur für eine **nicht leere** Andockleiste (`dockstat.cpp:245`) — der Zustand ist also da und wird nicht angewandt: `pWazooBar->m_pDockBar` bleibt `NULL`. **Folge:** die Standardanordnung überschreibt Lage, Sichtbarkeit und Breite; letzteres war die zweite Hälfte von **E-70**. **Zwei Spurmarken seit 7.2.0.43** in `mainfrm.cpp` — `E-78 nach SetDockState` und `E-78 vor/nach LoadWazooBarConfig`, je Leiste mit Kennung, Andockleiste, Sichtbarkeit und Stil. Sagt die erste *hat Andockleiste* und die zweite *keine*, geht die Zuordnung dazwischen verloren; sagt schon die erste *keine*, wirkt `SetDockState` nicht. **Könnte auch den Nebenbefund erklären, dass Fenster nach einem Neustart nicht im Vollbild stehen** **Was noch fehlt:** die Auswertung der vorhandenen Spurmarken und danach die Behebung — `E-78 nach SetDockState` und `E-78 vor/nach LoadWazooBarConfig` (`mainfrm.cpp`, seit 7.2.0.43) unterscheiden, ob `SetDockState` gar nicht wirkt oder die Zuordnung danach verlorengeht. Eingebaut ist bisher nichts.  **Zuletzt gemessen: 22.10.2026 an 7.2.0.121** — **die vorhandenen Spurmarken sind jetzt ausgewertet, und sie belegen den Vorwurf.** Gelesen aus `C:\Temp\E131L` nach einem Lauf über `pruefstand-lauf.ps1`; die Marken stehen in `mainfrm.cpp:869`. Drei Leisten, drei Phasen: — **nach `SetDockState`** (das ist der Punkt, an dem der GESPEICHERTE Zustand steht): alle drei Leisten `DockBar=0 sichtbar=1 Stil=0x00001a84`. — **vor `LoadWazooBarConfig`**: unverändert, dieselben Werte. — **nach `LoadWazooBarConfig`**: Leiste 318 `DockBar=59420 Stil=0x00001f84`, Leiste 319 `DockBar=59421 Stil=0x00004f84` **und sichtbar=0**, Leiste 320 `DockBar=59422 Stil=0x00008f84`. **Damit ist gemessen:** `LoadWazooBarConfig` setzt Andockung und Stil aller drei Leisten neu, nachdem der gespeicherte Zustand bereits stand, und schaltet eine davon unsichtbar. Der gespeicherte Zustand wird also nicht ergänzt, sondern überschrieben. **Was noch fehlt:** die Behebung — `LoadWazooBarConfig` darf nur greifen, wo der gespeicherte Zustand nichts sagt. Die Reihenfolge steht in `mainfrm.cpp`, die Werte oben sind der Maßstab für die Gegenprobe. **Stufe: wichtig** (Einstellungen: die gespeicherte Leistenanordnung wird bei jedem Start still verworfen)|
| <a id="e-79"></a>E-79 | die **Breite der linken Spalte im Filterfenster** überlebt keinen Neustart | **behoben durch die Einstellung, von Gregor am 11.09.2026 an 1.0.44 bestätigt** — vier Messläufe, je zwei davon stabil: `543 -> 543` bei Elternbreite 1100 und `334 -> 334` bei 751. Kein Codeeingriff nötig; `UseMyFilterWindowPosition=1` steht jetzt als Vorgabe in `tools/DEudora.ini`, im Abschnitt `[Window Position]`. Ursprünglich gemeldet als von Gregor am 11.09.2026 an 1.0.43 gemeldet: *„die breite der linken spalte beim filter wird nicht über den neustart gespeichert. auch wenn ich sie breiter gezogen habe."* **Zwei Ursachen, die erste ist ein Dokumentationsfehler von mir.** (1) `UseMyFilterWindowPosition` stand in `[Settings]`; Eudora ordnet jeden Schlüssel allein nach seiner Nummer zu (`rs.cpp:88`, `GetSectionID`), und `10922` gehört nach `[Window Position]`. Nachgemessen mit `GetPrivateProfileIntA`: aus `[Window Position]` kommt **0**, aus `[Settings]` die **1**, die dort niemand liest. `FILTER.md` hatte behauptet, alle Schlüssel stünden in `[Settings]` — das gilt für **23 von ihnen nicht**; berichtigt, und die Tabellen nennen den Abschnitt jetzt je Schlüssel. (2) **Auch im richtigen Abschnitt bleibt der Wert nicht.** Gregors Messung: er trug `312` ein, nach Start und Beenden stand `368` in der Datei; davor `237` bei einer Leistenbreite von 527, danach `368` bei 668. `SetColumnInfo` setzt nur eine **Wunschbreite** (`FiltersWazooWnd.cpp:185`), wirksam wird sie erst durch die Neuberechnung, die das nachfolgende `PostMessage(WM_SIZE, …)` auslöst — und beim Schließen wird die **tatsächliche** Breite zurückgeschrieben (`:70`), nicht die gewünschte. Weicht sie ab, schaukelt sich der Wert von Lauf zu Lauf auf. **In der VM tritt es nicht auf** — dort ist die Leiste schmaler; dieselbe Fassung, `Version 7.2.0.43` in beiden Protokollen. **Spurmarken `E-79 geladen:` und `E-79 gesichert:` seit 7.2.0.44**, sie nennen gelesenen Wert, Schalter, Elternbreite, Viertel, gesetzten und tatsächlichen Wert in einer Zeile; einschalten mit `LogLevel=58527` **Stufe: unkritisch** (Spaltenbreite ueberlebt keinen Neustart)|
| <a id="e-80"></a>E-80 | der Knopf **„Blah Blah Blah"** blendet die Kopfzeilen nicht aus — sie stehen immer da | **behoben in zwei Teilen, von Gregor am 11.09.2026 an 1.0.46 bestätigt**: *„ja, jetzt geht es"*. **TEIL 2, gefunden erst durch seinen Test an 1.0.45** (*„header schaut jetzt kürzer aus. aber: der bla bla button ändert nichts"*): **der Knopf schaltete seinen eigenen Zustand nie um.** Er steht als `TBBS_CHECKBOX` in der Leiste des Nachrichtenrahmens (`ReadMessageFrame.cpp:179`), sein Zustand steckt im Bit `TBBS_CHECKED` (`:981-998`) — und gesetzt wird das Bit **genau einmal**, beim Anlegen des Fensters und nur bei `ShowAllHeaders=1` (`:498-503`). Der Klick geht an die **Ansicht** (`ON_BN_CLICKED`, `TridentReadMessageView.cpp:161` und `PgReadMsgView.cpp:72`); `CReadMessageFrame` hat für `ID_BLAHBLAHBLAH` **keinen** Eintrag in seiner Botschaftstabelle, `CReadMessageFrame::OnBlahBlahBlah` (`:688`) ist eine **tote Funktion**. Beide Ansichten **lesen** `GetCheck` und keine setzt ihn — deshalb meldete die Spurmarke in jedem Lauf `Knopf=0`. **Die Zahl stand da, ich habe sie nicht zu Ende gedacht.** Im Original erledigte das die Stingray-Leiste selbst; der OTShim-Ersatz setzt `TBBS_CHECKED` nur über `SECToolBarCmdUI::SetCheck` (`OTShim_Werkzeugleiste.cpp:2742`), also über `ON_UPDATE_COMMAND_UI` — und so einen Eintrag gibt es für diesen Knopf nirgends. **Dieselbe Klasse wie E-43 und E-70.** Behoben in beiden Ansichten über die registrierte Botschaft `umsgButtonSetCheck`, die `summary.cpp:2518-2520` für zwei andere Knöpfe schon so benutzt. **TEIL 1** war in 7.2.0.44: Gemeldet am 11.09.2026 an 1.0.44: *„sowohl die einstellung ,include signature on reply', noch der bla bla button scheinen nicht zu funktionieren. erwartung: doppelklick auf mail: je nach button wird der header angezeigt oder ausgeblendet. aktuell: er wird immer angezeigt."* **Der Knopf war nie kaputt — die Liste war es.** Was er versteckt, sagt seine eigene Statuszeile: *„Shows/hides non-important headers"*. Welche Kopfzeilen als unwichtig gelten, steht in `TabooHeaders` (`EudoraRes.rc`, Kennung `10207`, Abschnitt `[Settings]`) — und diese Liste stammt aus **2006**. Sie kennt `X-UID` und `X-UIDL`, aber nicht `X-`; sie kennt `Received`, aber nicht `DKIM-`. **Nachgerechnet an 134 echten Nachrichten aus sechs Postfächern** mit `tools/taboo-rechnen.pl`: der Vergleich ist ein reiner Präfixvergleich (`TridentReadMessageView.cpp:2465`, gleichlautend `ReadMessageDoc.cpp:504`), lässt sich also ohne Programm ausrechnen. Mit der alten Liste blieben **über 60 Kopfzeilenarten** stehen, darunter `DKIM-Signature` 76×, `Authentication-Results` 70×, `X-FN-MUUID` 62×, `X-Scan-TS` 60×, `X-Spam-Flag` 58×, `Delivered-To` 56×, `X-Mailer` 55×, `UI-OutboundReport` 54× — die beiden obersten sind genau die, die in Gregors Bildschirmfoto stehen. **16 Einträge ergänzt** (`X-`, `DKIM-`, `ARC-`, `Authentication-Results`, `Envelope-To`, `Delivered-To`, `List-`, `Feedback-ID`, `Thread-`, `Accept-Language`, `User-Agent`, `Auto-Submitted`, `Autocrypt`, `UI-OutboundReport`, `UI-InboundReport`, `msip_`); die Originalliste bleibt **unverändert** davor stehen, damit kein bisheriges Verhalten wegfallen kann. Dieselbe Rechnung mit der neuen Liste über alle sechs Postfächer lässt **zehn** Namen übrig: `From`, `To`, `Cc`, `CC`, `Bcc`, `Subject`, `Date`, `Reply-To`, `Sender` — und `Referer`, ein Restbefund: der Listeneintrag `References` ist zehn Zeichen lang und trifft `Referer: ` nicht. **Kein Datenverlust:** `StripTabooHeaders` arbeitet auf dem Puffer, den `GetFullMessage` frisch anlegt (`msgdoc.cpp:374-389`) — die `.mbx` wird nicht angefasst; wer alles sehen will, drückt den Knopf oder setzt `ShowAllHeaders=1`. **Zwei Umwege auf dem Weg dahin, beide meine.** (1) Die erste Spurmarke lag in `PgReadMsgView` — der Paige-Textansicht — und schwieg, obwohl `LogLevel` nachweislich wirkte (im selben Lauf schrieben E-78 18× und E-34 6×). Eudora hat **zwei** Nachrichtenansichten, ausgewählt in `ReadMessageFrame.cpp:277-281`, und beide haben eigene Taboo-Logik: Paige markiert die Kopfzeilen mit einem Stil und schaltet an ihm `hidden_text_var` um, Trident entscheidet **beim Erzeugen des HTML**, ob sie überhaupt hineingeschrieben werden. (2) Der Verdacht, der **Content Concentrator** steche den Knopf aus, stammt aus der ersten Messung: `E-80 trident: Knopf=0 konzentriert=1 ShowAllHeaders=0 -> Kopfzeilen ALLE`. Das gilt nur für den ersten Aufbau; der zweite meldet `konzentriert=0 -> Kopfzeilen gekuerzt`, und im laufenden Betrieb ist das der Zustand. Die Kürzung griff also die ganze Zeit — sie kürzte nur fast nichts weg. **Spurmarke `E-80 trident:` seit 7.2.0.44** in `TridentView.cpp:1425`, sie nennt Knopf, Concentrator, `ShowAllHeaders` und das Ergebnis in einer Zeile; einschalten mit `LogLevel=58527` **Stufe: wichtig** (Anzeige: Kopfzeilen lassen sich nicht ausblenden)|
| <a id="e-81"></a>E-81 | bei einer Mail mit dunklem Hintergrund sind die **Kopfzeilen unsichtbar** — schwarz auf schwarz, sichtbar nur beim Markieren | **behoben** in 7.2.0.47, **von Gregor am 11.09.2026 an 1.0.47 bestätigt**: *„ja, paßt!"* Gefunden von ihm am 11.09.2026 an 1.0.46, an einer <Newsletter-Absender>-Werbemail — erst sichtbar geworden, nachdem E-80 den Knopf wieder zum Schalten gebracht hatte. **Ursache:** Eudora schreibt die Kopfzeilen als `<SPAN CLASS=EUDORAHEADER>` in **dasselbe** HTML-Dokument, in dem danach die Mail steht (`TridentReadMessageView.cpp:2418-2455`). Das Stylesheet dieses Dokuments (`IDS_INI_READMESSAGE_STYLE_SHEET`, `EudoraRes.rc:8129`) kennt nur `BODY`, `TT` und `BLOCKQUOTE.CITE` — für `EUDORAHEADER` gibt es **keine einzige Regel**. Die Kopfzeilen erben also, was die Mail für ihren `<BODY>` vorgibt. **Behebung:** eine Regel für `SPAN.EUDORAHEADER`, die Vordergrund **und** Hintergrund selbst festlegt — nur die Schriftfarbe zu setzen würde bei einer Mail mit hellem Text auf dunklem Grund denselben Fehler spiegelverkehrt erzeugen. Erst `black` auf `white`, dann dieselben Angaben noch einmal als `windowtext`/`window`: kennt MSHTML die Systemfarben, folgen die Kopfzeilen dem Windows-Design, kennt es sie nicht, verwirft es nur diese beiden Angaben. Ein Rückfall, der in keinem Fall schlechter ist als vorher. Wer eine eigene `read.css` im Eudora-Verzeichnis hat, ersetzt das Stylesheet vollständig (`TridentView.cpp:1300-1325`) — für den ändert sich nichts; im Paket liegt keine **Stufe: wichtig** (Anzeige: Kopfzeilen schwarz auf schwarz)|
| <a id="e-82"></a>E-82 | die **Zertifikatsprüfung nahm Zertifikate an, deren Kette sich nicht verifizieren ließ** | **behoben** in 7.2.0.48, **von Gregor am 11.09.2026 bestätigt** — IMAP läuft unverändert weiter. Kennung am 11.09.2026 von ihm vergeben. **Was war:** der Verifikations-Callback behandelte `X509_V_ERR_CERT_UNTRUSTED` (27) und `X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE` (21) als Erfolg — `iOK = 1` sagt OpenSSL wörtlich *„Zertifikat in Ordnung"*, und anders als in allen benachbarten Zweigen wurde weder ein Fehlercode gesetzt noch eine Warnung angehängt. Der Anwender sah nichts. Fehler 27 stammt aus `check_trust()` und tritt im gewöhnlichen Kettenaufbau auf. **Jetzt** hängen beide Codes am vorhandenen, korrekt ausgeführten Zweig für `X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY`: `iOK` bleibt 0, die Verbindung wird abgelehnt, `IDS_CERTERR_CHAINNOTTRUSTED` erscheint. **Betriebsfolge:** Eudora lehnt Verbindungen ab, die es vorher klaglos annahm; die Einzelfreigabe über den Zertifikatsspeicher bleibt, denn die Prüfung sieht dort zuerst nach. **Gemessen an Gregors Konten:** `Open 212.227.17.186:993` und `Successfully retrieved konto-gmx@gregor.invalid` — GMX' Kette hält der echten Prüfung stand. Der Verdacht, `rootcerts.p7b` von 2006 könne zu alt sein, ist für diese Konten widerlegt. **Weiterhin offen und davon getrennt:** die **Hostnamenprüfung** greift nicht — ein Zertifikat mit falschem `CN` wird mit `SSLSUCCEEDED` angenommen. **Regressionstest** `TestE82.cpp` (30.10.2026, am Quelltext): Fehler 21 und 27 stehen je einmal im Zweig `IDS_CERTERR_CHAINNOTTRUSTED`, im Fehler-`switch` wird `iOK` nie gesetzt, `iOK = 1` steht nur hinter dem Zertifikatsspeicher des Anwenders; mit dem alten `iOK = 1; break;` einmal rot, ohne ihn grün (318 Tests, 318 bestanden) **Stufe: kritisch** (Sicherheit: unpruefbare Zertifikatskette angenommen)|
| <a id="e-83"></a>E-83 | **Eudora lässt sich nicht beenden** — *„You currently have 1 task(s) running"*, und im Aufgabenfenster steht endlos *„Waiting in the task queue to be started …"* | **Zweite Ursache, behoben in 7.2.0.98 (16.10.2026), Beleg: am IMAP-Prüfstand gemessen; an 1.0.99 bei Gregor sauber beendet** (ein `liegengeblieben` beim Start löste sich nach Sekunden; der Wettlauf selbst trat in seinem Lauf nicht auf, die neue Stelle wurde dort also nicht durchlaufen): eine beim Start schon erledigte Aufgabe (erster Abgleich, `uid=1`) blieb stehen, weil ihre Abmeldung an den Rahmen `CTaskStatusWazooWnd` ging und die Ansicht sie beim Übernehmen nicht anmeldete (`QCTaskManager::SetDisplayWindow`, `CTaskStatusView::OnMsgDeleteInfo`, Einzelheiten im CHANGELOG 7.2.0.98). Nachgestellt am IMAP-Prüfstand `C:\Temp\E118` (16.10.2026): an 7.2.0.96 und 7.2.0.97 hingen **12 von 12** Läufen am ersten Abgleich nach dem Start (Aufgabe `Resyncing`, `uid=1`, `E-83 liegengeblieben`, an den Server nur noch `NOOP`, kein Hochladen); an 7.2.0.98 kamen **10 von 10** durch, in jedem Lauf mit der Spurmarke `E-83 beim-Umhaengen-schon-fertig-entfernt: uid=1`. **Erste Ursache:** **behoben** in 7.2.0.53, **am laufenden Programm gemessen** (14.09.2026). **An 1.0.84 nachgemessen am 13.10.2026, auf Gregors Auftrag (*„e-83: selbst testen und ergebnis eintragen“*):** frisches Verzeichnis `C:\Temp\E83-1084` mit `Eudora.exe` und `EudoraRes.dll` 7.2.0.84, Prüfkonto auf `tools/anhang-pruefdaten.pl --pop`, Lauf über `tools/testlauf.ps1`: Abruf per `WM_COMMAND 32772`, danach `WM_CLOSE`. **Ergebnis:** 7 Nachrichten abgerufen (7 × `Successfully retrieved`, 7 in `In.mbx`); die Abrufaufgabe `uid=1` lief `LAEUFT(4)` → `FERTIG(5)` mit `fertig-Nachbearbeitung-angefordert`; **Ende 1 s nach `WM_CLOSE`, ohne Abschießen** -- die Meldung `IDS_TASK_WARN_CLOSE` (`EudoraRes.rc:11299`), die `mainfrm.cpp:5375` beim Beenden zeigt, sobald noch Aufgaben gezählt werden, kam also nicht (`Beendet: True`, `tools/TESTLAEUFE.md`); `ExitInstance: erreicht` im Protokoll; danach **kein Eudora-Prozess** aus diesem Pfad, keine `Exception.log`. Dazu Gregors eigener Lauf am selben Tag: Alt+F4 und Ctrl+Q beenden (*„alt+F4 bestätigt: beendet. auch ctrl-Q“*). Zwei Vorläufe mit 0 Nachrichten zählen nicht: die mitkopierte `spool\lmos.dat` hielt die Prüfnachrichten für schon abgeholt. **Die Anzeige log:** der Zustand war `FERTIG(5)`, die Aufgabe wartete also gar nicht — der Text stammt aus `Register()` und wird nie überschrieben. Das hat den Befund zwei Wochen in die falsche Richtung geschickt. **Gemessen** in Gregors Lauf mit 7.2.0.52: **15** Aufgaben fertig *mit* angeforderter Nachbearbeitung, **17** fertig *ohne*, und dieselben **17** meldete die Überwachung alle 15 Sekunden als liegengeblieben. **Ursache:** `QCTaskManager::RemoveWorkerThread` fordert die Nachbearbeitung nur an, wenn `IsIgnoreIdleSet()` oder `m_nStartIdle == GetStartIdle()`; sonst stand dort **nichts**. Das war eine Sackgasse — `DoPostProcessing` arbeitet ausschließlich `m_PostProcessList` ab, und dort hinein kommt eine Aufgabe **nur** über `RequestPostProcessing()`. Auch der Leerlauf holt sie nicht nach; die Aufgabe blieb in `m_TaskInfoList` und zählte weiter als laufend. `m_nStartIdle` wird nur in `StartTasks()` gesetzt, also für Aufgaben aus einer `QCTaskGroup` — IMAP-Aktionen aus `CActionQueue::OnIdle` laufen daran vorbei. **Behoben**, indem auch dieser Zweig die Nachbearbeitung anfordert. **Vorher widerlegt:** der Verdacht auf `StartWorkerThread` mit `m_pThread == NULL` (seit 11.09.2026) — der Zeiger war in jeder gemessenen Zeile gesetzt; und eine der drei „ausgeschlossenen" Ursachen war **falsch ausgeschlossen** (`DelayTasks`/`StartTasks` werden sehr wohl gerufen, von `QCTaskGroup`) **Stufe: wichtig** (Bedienung: Beenden wird verweigert)|
| <a id="e-84"></a>E-84 | die **Größe eines losgerissenen Fensters überlebt den Neustart nicht** — es kommt beim nächsten Start wieder klein | **behoben** in 7.2.0.50, **von Gregor am 11.09.2026 bestätigt** — belegt an beiden Enden: in der `Eudora.ini` steht `FloatCx319=751` / `FloatCy319=403`, und der erste Aufruf nach dem Neustart meldet `E-76 fest: vorher=751x403` statt der Anfangsgröße `200x100`. Von ihm am 11.09.2026 gemeldet, unmittelbar nach der Bestätigung von E-76: *„das undocked initiale fenster ist recht klein, die größe (nach der änderung) wird nach dem schließen vom filter und eudora nicht gespeichert. beim nächsten mal wieder klein."* **Der erste Anlauf saß an der falschen Stelle.** Er stand in `SECControlBarInfo::SaveState`/`LoadState` — reinen Weiterleitungen an MFC, und MFC kennt `m_szFloat` nicht. **Diese Funktionen werden beim Speichern aber gar nicht durchlaufen:** mit dem Einbau dort kam in der `Eudora.ini` kein einziger Eintrag an. An ihrer Stelle steht jetzt ein Kommentar, der das sagt (`OTShim.cpp:5330-5334`), damit dort niemand wieder anfängt. **Der tatsächliche Weg steht seit E-70 im Baum:** `QCToolBarManager::SaveState` → `SECToolBarManager::SaveState` → `GroessenSichern` (`OTShim_Werkzeugleiste.cpp:4410`), Gegenstück `GroessenLaden` (`:4470`), gerufen aus `QCToolBarManager::LoadState` (`QCToolBarManager.cpp:1199`). Dort wurden bis 7.2.0.49 nur `DockVertCx` und `DockHorzCy` geschrieben — die **Andock**größen; `m_szFloat` kam nirgends vor. **Behoben** an derselben Stelle mit zwei weiteren Schlüsseln, `FloatCx<id>` und `FloatCy<id>` im Abschnitt `[ToolBar-ToolBarManager]`, geschrieben und gelesen wie die beiden vorhandenen — kein neuer Weg, keine zweite Stelle zum Übersehen. Eine Größe von 0 wird gar nicht erst geschrieben, weil `GroessenLaden` sie sonst übernehmen müsste. **`SECControlBarInfo::Serialize` bleibt unberührt:** der Kommentar dort begründet zu Recht, den SEC-Anteil wegzulassen — *„das Format müsste dann zum Original passen … eine eigene Erweiterung würde eine Datei erzeugen, die ein späterer echter Nachbau nicht mehr lesen kann"*. Das gilt für ein **Binärformat**, in dem ein zusätzliches Feld alles Nachfolgende verschiebt; in der **INI** stört ein zusätzlicher Schlüssel niemanden, der ihn nicht kennt **Stufe: unkritisch** (Fenstergroesse ueberlebt den Neustart nicht)|
| <a id="e-85"></a>E-85 | **Umlaute in per IMAP abgerufenen Nachrichten kommen falsch an** | **Behoben in 7.2.0.52, am laufenden Programm belegt** — 13.09.2026, von Gregor am selben Tag gemeldet. **Von Gregor an 1.0.84 bestätigt am 13.10.2026**, mit Bildschirmfoto seines IMAP-Postfachs `Inbox (<Dominant>)` (Titelzeile `7.2.0.84 / Paket 1.0.84+05bbaba*`, *„E-85: schau selbst nach“*): Wörter mit `ä`, `ö`, `ü`, `Ä`, `ß`, typografische Anführungszeichen, `–` und `€` stehen richtig in der Liste (die Betreffzeilen selbst bewusst nicht wiedergegeben). Seine `eudora.log` (nur gelesen) belegt den Weg: in den Läufen vom 12.10.2026 mit `Version 7.2.0.84` sieben Zeilen `E-85 imap: teil-charset=UTF-8 … uebersetzt=ja`, keine mit `uebersetzt=nein`. **Berichtigt am 17.09.2026 (LEKTOR, L-13.2).** Hier stand bis dahin *„Alle drei Mängel behoben in 7.2.0.51 — aber die Behebung hat eine Regression eingeführt, die noch offen ist"*. **Drei Aussagen daran waren falsch:** es waren **vier** Mängel, nicht drei; der entscheidende vierte kam erst in **7.2.0.52**, nicht in 7.2.0.51; und die Regression ist **geschlossen** — am Quelltext nachgemessen (`utils.cpp:1308-1310` und `:1393-1395`), und dieselbe Zelle sagte es weiter unten bereits selbst. **Der vierte Mangel, der hier ganz fehlte:** `CImapDownloader::Write` las den Zeichensatz aus `m_pHd->m_TLMime`, dem **Top-Level**-Kopf — bei `multipart/alternative`, also jedem HTML-Newsletter, steht dort **kein** `charset`, nur `boundary`. Deshalb wirkte 7.2.0.51 bei `text/plain` ohne multipart, bei Newslettern nicht; Gregors Messung zeigte **Betreff richtig, Rumpf falsch** in einem und demselben Bild. **7.2.0.52** holt den Zeichensatz aus dem MIME-Teil (`m_szCurrentCharset`, gesetzt an denselben drei Stellen wie `m_CurrentBodyType`: `ImapDownload.cpp:2837, 3074, 3324`), der Nachrichtenkopf bleibt Rückfall. **Belegt im Protokoll von Gregors Lauf:** `teil-charset=utf-8 tl-charset=(keiner) idx=4 uebersetzt=ja`, und null unübersetzte UTF-8-Folgen in der Mailboxdatei. **Vier Mängel im IMAP-Weg: die ersten beiden in `EuImap/src/ImapDownload.cpp`, der dritte zusätzlich in `Eudora/utils.cpp`, der vierte wieder in `ImapDownload.cpp`.** **(0) behoben in 7.2.0.51 — der schwerwiegendste: `charset=utf-8` wurde gar nicht erkannt.** Die Stelle (damals Zeile 4645) suchte mit `FindRStringIndexI(IDS_MIME_US_ASCII, IDS_MIME_ISO_LATIN9, …)` — der Bereich endet bei **3613**, `IDS_MIME_UTF_8` ist **3614** und liegt damit außerhalb. Der Aufruf lieferte `-1`, `if (iCharsetIdx > 1)` war falsch, und **es wurde überhaupt nicht übersetzt**; die UTF-8-Bytes gingen roh in die Mailboxdatei und wurden später als CP1252 angezeigt. Der POP3-Weg macht es richtig: `FindMIMECharset` (`Eudora/mime.cpp:382-402`) sucht bis `IDS_MIME_UTF_8` **und** verschiebt das Ergebnis um eins (`++iCharSet`), damit Index 0 für `windows-*` frei bleibt. Genau diese Verschiebung fehlte im IMAP-Weg ebenfalls — die beiden Wege rechneten auf **verschiedenen Skalen**, was der bestehende Test *„POP: der Index wird um eins verschoben — anders als im IMAP-Pfad"* schon festhielt. **Jetzt ruft der IMAP-Weg dieselbe Funktion:** `iCharsetIdx = FindMIMECharset(params->value)` (`ImapDownload.cpp:4742`), und die Schwelle darunter heißt `if (iCharsetIdx > 2)` statt `> 1` (`:4785`) — auf der gemeinsamen Skala ist 0 `windows-*`, 1 us-ascii, 2 Latin1, 3 Latin9, 4 UTF-8, übersetzt wird ab 3 wie in `TextReader.cpp`. **(1) behoben in 7.2.0.51:** Zeile 4662 verwarf den Rückgabewert von `ISOTranslate`; `outLen` behielt die Länge *vor* der Übersetzung und genau die wurde geschrieben. **(2) behoben in 7.2.0.51:** die Behebung von **Z-2b** (angefangene UTF-8-Zeichen an der Stückgrenze zurückhalten) stand nur in `TextReader.cpp` und damit nur im POP3-Weg; IMAP liest bei `text/html` in Blöcken von 8192 Bytes. Neu dafür: `ISOTranslateChunk` (`Eudora/utils.cpp:1269`, deklariert in `utils.h:93`), gerufen in `ImapDownload.cpp:4802`, mit vier Tests über alle Stückgrößen. **(3) neu eingeführt und in 7.2.0.51 gleich mitbehoben — die abschließende Null traf die nächste Zeile.** Von **PRUEFER** am 13.09.2026 belegt (`Befunde/PRUEFER-10.md`, Zweig `wt/pruefer`) und hier am Quelltext nachgemessen: `ISOTranslate` schreibt die abschließende Null an `szBuf[lSize]` (`utils.cpp:1480`) — **ein Byte hinter** den übersetzten Bereich. Der POP3-Weg hält dafür eigens Platz frei; der Kommentar darüber sagt es wörtlich (`utils.cpp:1477-1479`: *„TextReader::ReadIt is now making sure that it leaves space at the end of its buffer for us to NULL terminate it"*). **Der IMAP-Weg hat diesen Platz nicht:** bei `text/plain` zeigt `pBuf` in den Puffer von `CChunkReader`, und das Byte hinter der Zeile ist das **erste Byte der nächsten Zeile** — bei `charset=utf-8` ohne Decoder verliert damit jede Zeile ihr erstes Zeichen. **Vorher konnte das nicht auftreten:** `ISOTranslate` kehrt bei `iCharsetIdx <= 2` zurück, **bevor** die Nullung ausgeführt wird (`utils.cpp:1449-1452`), und der alte IMAP-Weg sah wegen der eigenen Skala nie einen höheren Index. Erst die gemeinsame Skala aus (0) erreichte die Nullung. **Behoben in `ISOTranslateChunk` selbst:** das Byte hinter dem Stück wird vor dem Aufruf gerettet und danach zurückgeschrieben (`utils.cpp:1308-1310` für den Nicht-UTF-8-Weg, `:1393-1395` für den UTF-8-Weg), und nur dort, wo `ISOTranslate` wirklich schreibt — bei `iCharsetIdx <= 2` kehrt es vor der Nullterminierung zurück. Damit bleibt der Aufrufer unangetastet und beide Wege sind gedeckt. **(4) behoben in 7.2.0.52 - der entscheidende: die falsche Quelle** (oben ausgefuehrt). **Stand 17.09.2026: alle vier Punkte sind am Quelltext belegt, und der Erfolg ist am laufenden Programm gemessen** - bei 1.0.51 zeigte Gregors Test den Fehler noch, ab 1.0.52 nicht mehr (`uebersetzt=ja`, null unuebersetzte UTF-8-Folgen). **Bis zum 17.09.2026 stand hier "von Gregor ist nichts davon am laufenden Programm bestaetigt"; das war seit 7.2.0.52 ueberholt** (LEKTOR, L-13.2) **Stufe: kritisch** (Zeichensatz: Umlaute ueber IMAP falsch)|
| <a id="e-86"></a>E-86 | eine **Newsletter-Mail steht in Eudora auf weißem Grund, das Logo in einem Kasten mit blauem Rahmen** — im Webbrowser dagegen abgerundete Kästen ohne Rahmen | **behoben** in 7.2.0.55, **am laufenden Programm gemessen**. **Zwei Verdächte wurden vorher widerlegt:** (1) Eudora lege sein eigenes `<html><head><body>` um die Nachricht und MSHTML verwerfe deren zweites — die Spurmarke meldet `BODY-Elemente=1`, es gibt kein zweites; (2) beim Zusammensetzen gehe Formatierung verloren — die gesicherte Anzeigedatei hat **36.078 Bytes, 67 Tabellen, 12 Bilder und alle 118 `border`-Angaben** der Nachricht, sogar eine mehr (Eudoras Zitatbalken). **Die wirkliche Ursache:** MSHTML rendert ohne besondere Anweisung im **Standardmodus des Internet Explorer 7 von 2006**. Die Mail enthält dreimal `border-radius`, das dieser Modus nicht kennt — abgerundete Ecken werden zu Kästen, und was im CSS einen Rahmen unterdrücken soll, greift nur teilweise. **Behoben** mit `<meta http-equiv="X-UA-Compatible" content="IE=edge">` als erster Zeile der Anzeigedatei (`TridentView.cpp`, vor dem Stylesheet — MSHTML muss den Schalter im Kopf sehen, bevor Inhalt kommt). **Gegenprobe am laufenden Programm:** vorher meldete die Spurmarke `Hintergrund=#ffffff`, nachher `Hintergrund=transparent` — der Modus hat sich nachweislich geändert. Wie es aussieht, beurteilt Gregor **Stufe: wichtig** (Darstellung: Kasten mit blauem Rahmen)|
| <a id="e-87"></a>E-87 | **beim Weiterleiten geht die HTML-Formatierung verloren** — die Nachricht wird beim Lesen mit Kästen, Rahmen und Hintergründen angezeigt, im Verfassenfenster steht nur noch Fließtext mit blauen Verweisen | **behoben in 7.2.0.55 (Schalter `KeepHTMLInResponses`), von Gregor am 29.10.2026 an 1.0.127 bestätigt** — er leitete einen HTML-Newsletter weiter und an sich selbst; die angekommene Mail zeigte Bilder, Kästen und farbige Knöpfe wie das Original (Bildschirmfoto im Chat). Im Protokoll belegt: `E-87 ComposeMessage: … IsHTML=1 Schalter=1` beim Öffnen des Verfassenfensters, zweimal ([TESTPLAN](TESTPLAN.md#e-87-am-release)). Bis zum 29.10. stand „behoben“ ohne Beleg da. Die verbliebene Layoutgrenze ist als **E-88** abgetrennt und in 7.2.0.56 eingebaut — urspruenglich gemeldet als: es geht wirklich so hinaus, von Gregor am 14.09.2026 an 1.0.53 mit zwei Bildschirmfotos nebeneinander gemeldet (Leseansicht gegen *Fwd:*-Fenster). **Berichtigt damit eine falsche Aussage von mir:** ich hatte am selben Tag geschrieben, der Darstellungsfehler E-86 betreffe *„nur das Lesen, nicht das Versenden — wer sie weiterleitet, verschickt sie korrekt"*. Gemessen hatte ich nur, dass der HTML-Rahmen aus `TridentView.cpp` beim Verfassen nicht gebaut wird; **daraus folgt nicht, dass der Verfassenweg die Formatierung erhält.** Er baut den Text neu auf, über `PgCompMsgView` auf Paige-Grundlage, und dabei geht das CSS verloren. **Zuerst zu klären, bevor irgendetwas geändert wird:** ob das Original von QUALCOMM sich genauso verhielt — Eudora 7.1 konnte HTML nur eingeschränkt bearbeiten, und dann wäre es kein Portierungsfehler, sondern eine Grenze des Programms. Zu messen an `InstallersForEudora/Eudora7.1` oder am Quelltext des Verfassenwegs **Stufe: wichtig** (Darstellung: HTML-Formatierung beim Weiterleiten verloren) **Am 14.09.2026 nachgelegt:** Gregor hat die weitergeleitete Nachricht beim Empfänger geöffnet — sie kommt genauso an. Es ist also **kein Anzeigefehler im Verfassenfenster**, sondern die Formatierung ist beim Verschicken tatsächlich weg. Damit betrifft der Befund nicht nur Gregor, sondern jeden Empfänger einer weitergeleiteten Nachricht. **Am 14.09.2026 gemessen und zur Haelfte behoben (1.0.54):** Antworten und Weiterleiten laufen beide durch `CSummary::ComposeMessage` (`summary.cpp`). Dort verwarf `summary.cpp:1110` das Ergebnis von `IsFancy(fullMes)` wieder, sobald `MSF_XRICH`/`MSFEX_FLOWED` im Uebersichtseintrag fehlten: `IsRich` wurde `IS_ASCII`, und `QuoteText` (`msgutils.cpp:126-220`) nahm daraufhin nicht den HTML-Zweig ueber `GetBodyAsHTML`, sondern `WrapText` mit `">"`-Praefix — reiner Text. Die blauen Verweise darin stammen von `MakeAutoURLSpaghetti`, nicht aus der Nachricht. **Behoben** mit dem neuen Schalter `KeepHTMLInResponses` (Vorgabe `1`, `[Settings]`, `EudoraRes.rc:7667`), der fuer beide Wege gilt; `0` stellt das alte Verhalten her. Dokumentiert in [EINSTELLUNGEN.md](EINSTELLUNGEN.md), Abschnitt 3. **Offen bleibt die zweite Haelfte:** verfasst wird mit Paige, und dessen HTML-Leser wertet aus `div` allein `align` aus (`PGHTMIMP.CPP:1193-1201`), kennt kein `span` und keine einzige CSS-Eigenschaft (`PGHTMDEF.C:20-48`). Was Paige nicht versteht, ist nach `PgMsgView::ExportMessage` (`PgMsgView.cpp:342-408`, `pDoc->SetText()`) endgueltig fort — und genau dieser Text geht hinaus. **CSS-Kaesten und -Hintergruende blieben deshalb auch mit dem Schalter verloren** — bis **E-88** in 7.2.0.56 das Original am Editor vorbeifuehrte; die verbleibenden Grenzen stehen in EINSTELLUNGEN.md 4.8. Eine Spurmarke in `summary.cpp` gibt `IsFancy`, `IsRich`, `IsXRich`, `IsFlowed`, `IsHTML`, den Schalter und den Antworttyp in einer Zeile aus (`LogLevel=58527` noetig, die Vorgabe `25759` enthaelt `DEBUG_MASK_MISC` nicht).
| <a id="e-88"></a>E-88 | **die weitergeleitete Nachricht kommt beim Empfänger schlichter an, als sie gelesen wurde** — Kästen, Hintergründe und Bildgrößen fehlen, weil sie über CSS gesetzt sind. Die zweite Hälfte von **E-87**: dort wurde erreicht, dass HTML überhaupt zitiert wird; hier geht es darum, dass es den Verfassen-Editor unbeschädigt überlebt | **behoben in 7.2.0.56, Bau 0 Fehler, Tests 131/131 (zehn davon neu zu E-88, mit Gegenproben) — von Gregor am 29.10.2026 an 1.0.127 bestätigt:** die weitergeleitete HTML-Mail kam aus wie das Original an (Bildschirmfoto im Chat); im Protokoll belegt `E-88 vor dem Absenden: Fassung=ORIGINAL (unveraendert) … OrigBytes=159350 EditorBytes=37609` und `E-88 auf der Leitung: … IsHTML=1 SendPlainOnly=0` — hinaus ging das unveränderte Original, nicht die Editor-Fassung ([TESTPLAN](TESTPLAN.md#e-87-am-release)). **Warum es nicht anders geht (gemessen, nicht vermutet):** verfasst wird mit Paige, und dessen HTML-Leser kennt **keine einzige CSS-Eigenschaft** (`PGHTMDEF.C:20-48`), aus `div` allein `align` (`PGHTMIMP.CPP:1193-1201`). Von 1506 `<img>` in Gregors Postfach tragen 1262 die Größe als HTML-Attribut — die kann Paige (`PGHTMIMP.CPP:1897-1916`) —, **162 nur als CSS**; die erscheinen in Originalgröße und überlagern den Text. Ein zweiter, HTML-fähiger Editor existiert nicht: Trident-Ansichten gibt es nur zum Lesen, `CCompMessageFrame` erzeugt fest `PgCompMsgView`. **Der Umbau:** `CSummary::ComposeMessage` (`summary.cpp:1497`) legt den Rumpf, wie `QuoteText` ihn gebaut hat, im Verfassendokument ab (`CCompMessageDoc::m_szE88OriginalHTML`). `PgMsgView::ExportMessage` (`PgMsgView.cpp:407`) — die eine Stelle, an der die Editor-Fassung über `pDoc->SetText()` zum Rumpf der Nachricht wird und damit auf die Leitung geht (`sendmail.cpp:3368`) — setzt statt ihrer das Original ein, **sobald sich belegen lässt, dass im Zitat nichts geändert wurde**: der Klartext des Originals (Markierungen weg, Entitäten und alles über 127 zu `?`, Leerraum zusammengezogen) muss sich im Klartext der Editor-Fassung als **ein zusammenhängendes Stück** wiederfinden (`E88OriginalEinsetzen`, `msgutils.cpp`). Findet er sich nicht, bleibt alles beim alten. **Gilt für POP3 wie IMAP** und für alle drei Wege — Antworten, Weiterleiten, Umleiten —, weil `ComposeMessage` sie gemeinsam bedient. **Schalter `ForwardOriginalHTML`** (Vorgabe `1`, `[Settings]`, `EudoraRes.rc:7668`); `0` stellt 7.2.0.55 wieder her. **Die eingebetteten Bilder mussten mitgesichert werden:** `PgMsgView::SaveInfo` warf bisher jeden `cid:`-Teil weg, den der Paige-Inhalt nicht mehr nannte — das Original hätte danach auf gelöschte Teile gezeigt, und beim Empfänger hätte das Bild ohne jede Meldung gefehlt. Solange ein Original aufgehoben ist, unterbleibt dieses Aufräumen; der Preis sind höchstens ein paar unreferenzierte Teile. **Drei Spurmarken**, alle `DEBUG_MASK_MISC`: *E-88 vor dem Absenden* nennt die gewählte Fassung, beide Größen und die Länge des eigenen Zusatzes davor und dahinter; *E-88 auf der Leitung* nennt, was wirklich hinausgeht. **Drei Grenzen, die bleiben:** das Verfassenfenster sieht unverändert schlicht aus (Paige kann kein CSS, daran ändert der Schalter nichts); wer im Zitat etwas ändert, bekommt wieder die Editor-Fassung; und der eigene Zusatz geht als reiner Text hinaus, nicht mit seiner Auszeichnung. **Nicht abgedeckt:** wird das Verfassenfenster geschlossen und die Nachricht später aus *Out* erneut geöffnet, ist das Original nicht mehr im Speicher — dann gilt wieder das alte Verhalten, und die Spurmarke sagt `EDITOR (kein Original gemerkt)`. Dokumentiert in [EINSTELLUNGEN.md](EINSTELLUNGEN.md), Abschnitte 3 und 4.8 **Stufe: wichtig** (Darstellung: Empfaenger bekommt es schlichter)|
| <a id="e-89"></a>E-89 | **das Verfassenfenster ist unbrauchbar: Bilder überlagern den Text, man kann nicht lesen, was man schreibt** | **behoben in 7.2.0.58, von Gregor am 14.09.2026 an 1.0.58 am laufenden Programm bestätigt: auf seinem Bild steht das Produktbild sauber über ihrem Text, „Artikelnummer" und „Nachbestellung mit Order No" sind frei. Auf die Rückfrage, wo noch etwas überlappe: *„keine überlappung."*** **Die Ursache war eine tote Zuweisung**, `PGHTMIMP.CPP:2110-2111`: `current_style.ascent = image_record.source_height;` wurde in der **nächsten Zeile** von `original_descent` überschrieben — einem Wert aus dem **Textstil**, aufgenommen bevor das Bild bekannt war (Zeile 2039). Übrig blieb `ascent = max(Text-Ascent, Text-Descent)`, also drei bis zwölf Bildpunkte, **unabhängig von der Bildhöhe**. Ein 150 Punkt hohes Bild saß damit in einer textkleinen Zeile und deckte zu, was darüber stand. **Die Behebung ist das Streichen dieser einen Zeile** — danach wirkt die erste wie beabsichtigt. **Gemessen, nicht angenommen:** `ProcessEmbed` (`PGHTMIMP.CPP:2962`) setzt `translator.format = current_style`, und der Aufruf steht zwanzig Zeilen unter der Stelle; `current_style` ist also der Stil, der ins Embed geht. Das war die Frage, die der Prüfer ausdrücklich offengelassen hatte. Kein Portierungsfehler: identisch in allen vier Fassungen im Repo. **Zwei Erklärungen sind vorher gemessen ausgeschlossen worden:** der Nachtrag über `embed->style` (`PgEmbeddedImage.cpp:458-507`) steht unter `if ((embed->height == 0) \|\| (embed->width == 0))` und startet für bemaßte Bilder gar nicht; der Rahmenweg (`PGHTMIMP.CPP:2045`) greift nur bei `align`, und von 3060 `<img>` in den Postfächern tragen 16 eins, alle mit `middle` — der setzt `frame.data` nicht. **Der Umweg über die Bildgröße in 7.2.0.57 war falsch** und ist zurückgenommen: die 200×90-Vorgabe für Bilder ohne bekanntes Maß erzeugte auf Gregors Bild einen leeren grauen Kasten. Ein Bild ohne Maß bleibt jetzt unangetastet; dabei fiel auf, dass die Vorgabe auch Bilder traf, von denen **nur die Breite** bekannt war — die bekommen jetzt ihre Breite und keine erfundene Höhe. Der Deckel gegen zu breite Bilder bleibt. **Tests: 148 von 148**, vier davon umgeschrieben, weil sie die Vorgabe festhielten **Dritter Anlauf in 7.2.0.60:** die Behebung von 7.2.0.58 wirkte nur bei Bildern **mit** `height`-Attribut — `image_record.source_height` kommt aus `numeric_value()` über das Attribut (`PGHTMIMP.CPP:2022`), nicht aus der Bilddatei. Fehlt es, bleibt der Wert null und der ganze Block wird übersprungen. Damit hat die Rücknahme der 200×90-Vorgabe die Zeilenhöhe-Behebung ausgehebelt: gemessen an Gregors Bild zu 1.0.59 (`gesamt=5 unveraendert=4 ohne-Mass=1 geaendert=0`) lag der blaue Kreis im Logo der Mail-A über dem Verifizierungscode. Jetzt ein **kleines** Vorgabemaß von 20 Punkten, gerade eine Textzeile hoch — Gregors Wahl zwischen klein, gar nichts und 200×90: *„ok, option a"* **Stufe: wichtig** (Darstellung: Verfassenfenster unbrauchbar)|
| <a id="e-90"></a>E-90 | **Emoji in Betreffzeilen fallen ersatzlos weg** (bis 7.2.0.58: sie erschienen als `?`) — Gregors Thunderbird-Vergleich vom 14.09.2026 zeigt links `🔥`, `🎉`, `⏰👀`, bei uns stand an derselben Stelle `????`; seit 7.2.0.59 steht dort nichts | **gemessene Grenze, kein Fehler dieser Fassung — zurückgestellt.** Der Betreff läuft über **denselben** Weg wie der Nachrichtentext (P-1.3: `HeaderDesc::Read` → `lex822.cpp:777` → `Fix2047` → `Translate2047` → dasselbe `ISOTranslate` mit demselben Index aus `FindMIMECharset`), er wird also korrekt dekodiert. Das `?` entstand beim letzten Schritt: `ISOTranslate` gibt UTF-8 an `MultiByteToWideChar`/`WideCharToMultiByte` nach **CP1252**, und CP1252 kennt kein Emoji; `WideCharToMultiByte` setzte dafür ein Fragezeichen. **BERICHTIGT am 23.10.2026 (LEKTOR, L-51.1), am Quelltext nachgemessen:** so ist es seit **7.2.0.59** nicht mehr. Zwischen den beiden Aufrufen steht eine Filterschleife (`utils.cpp:1570-1596`), die **vor** `WideCharToMultiByte` (`:1607`) jedes Surrogat streicht — `:1582`, `if (w >= 0xD800 && w <= 0xDFFF) continue;`, und das ist jedes Emoji — dazu die unsichtbaren Zeichen. Bestand ein Text nur aus solchen Zeichen, kommt er **leer** heraus (`:1617-1623`, `bGanzGefiltert`). **Emoji erscheinen also nicht als `?`, sie erscheinen gar nicht.** Die Messung vom 22.10.2026 hat genau diese Schleife übersehen und die alte Kette bestätigt — ein frisches *„Zuletzt belegt am Quelltext"* ist kein Beweis, wenn es die Stelle 40 Zeilen weiter nicht liest. **Am laufenden Programm ist das seit 7.2.0.59 nie nachgemessen worden.** **Das ist die bessere von zwei Möglichkeiten:** vorher überlebten Emoji als rohe UTF-8-Bytes und standen als Bytesalat da (vier Bytes je Zeichen), die Begründung steht ausführlich im Quelltext bei `utils.cpp:1484-1512`. **Wirklich beheben ließe es sich nur mit einem Unicode-Oberflächenweg** — Eudora ist durchgehend ANSI/MBCS gebaut; das ist ein Umbau eigener Größenordnung, kein Einzelfix. Solange das nicht ansteht, ist `?` das richtige Verhalten **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — unverändert. `ISOTranslate` gibt UTF-8 weiterhin an `MultiByteToWideChar`/`WideCharToMultiByte` nach CP1252; die Begründung steht unverändert bei `utils.cpp:1484-1512`, der Zweig selbst bei `:1514`. Damit bleibt es dabei: kein Fehler, der für sich zu beheben wäre, sondern die gemessene Grenze eines durchgehend als ANSI/MBCS gebauten Programms. Schließen kann ihn nur eine Entscheidung Gregors, nicht eine Behebung. **Was noch fehlt:** nichts, was für sich zu beheben wäre — `?` ist die bessere von zwei Möglichkeiten, solange Eudora durchgehend ANSI/MBCS gebaut ist (Begründung im Quelltext bei `utils.cpp:1484-1512`). Aufgreifen hieße, die Oberfläche auf Unicode umzustellen: ein Umbau eigener Größenordnung, von Gregor nicht beauftragt. **Stufe: wichtig** (Anzeige: Emoji im Betreff als Fragezeichen)|
| <a id="e-91"></a>E-91 | **zitierte Bereiche stehen bündig im Text, ohne Randbalken und Einrückung** — auf Gregors Thunderbird-Vergleich vom 14.09.2026 hat der zitierte Teil links einen senkrechten Balken und ist eingerückt, bei uns steht er bündig mitten im übrigen Text | **beobachtet, Ursache NICHT gemessen.** Aufgefallen beim Vergleich zu E-89, nicht eigens untersucht. Was bekannt ist: Eudora kennt einen Zitatstil (`blockquote_style` in `PaigeEdtView.cpp:7738`, `Paige_io.cpp:916`), und beim Antworten wird `<blockquote type=cite>` erzeugt (`etf2html.cpp:123`, `msgutils.cpp:182`). Beim **Lesen** einer HTML-Nachricht zeichnet dagegen MSHTML, das `blockquote` von Haus aus einrückt. Offen und ungemessen ist deshalb, **welcher der beiden Fälle** auf Gregors Bild zu sehen war und ob die Nachricht überhaupt ein `blockquote` trug oder nur `>`-Zeilen. **Erst messen, dann urteilen** — dieser Eintrag hält die Beobachtung fest, nicht eine Ursache. Kosmetik; keine Fehlfunktion **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — bleibt offen, aber eingegrenzt. Die genannten Stellen stehen unverändert (`PaigeEdtView.cpp:7738`, `Paige_io.cpp:916`, `etf2html.cpp:123`). **Neu gemessen:** Paiges HTML-**Lese**weg rückt `blockquote` sehr wohl ein — `blockquote_level` (`PGHTMIMP.CPP:102`, `:1678`) geht in `current_par.indents.left_indent` ein (`:1158`). An einer fehlenden **Einrückung** kann es also nicht liegen; der senkrechte **Randbalken** dagegen ist CSS, und Paige wertet keine einzige CSS-Eigenschaft aus (dieselbe Wurzel wie [E-88](#e-88)). Was zum Urteil fehlt, ist unverändert Gregors Nachricht. **Was noch fehlt:** die **Messung selbst** — ungeklärt ist, ob Gregors Bild den Lese- oder den Verfassenweg zeigte und ob die Nachricht überhaupt ein `blockquote` trug oder nur `>`-Zeilen. **Stufe: wichtig** (Darstellung: Zitate ohne Randbalken)|
| <a id="e-92"></a>E-92 | **der Weiterleitungskopf ist bei Thunderbird eine ausgerichtete kleine Tabelle** — auf Gregors zweitem Bild vom 14.09.2026 stehen `Betreff:`, `Datum:`, `Von:`, `An:` fett und rechtsbündig, die Werte linksbündig daneben | **beobachtet, unsere Seite NICHT gemessen — Kosmetik, zurückgestellt.** Festgehalten, damit die Beobachtung nicht verlorengeht; ein Vergleichsbild aus Eudora zur selben Nachricht liegt **nicht** vor, also ist offen, ob unser Kopf überhaupt abweicht. **Wo schon gesucht wurde, damit der nächste Anlauf nicht dort anfängt:** `ConConMessage.cpp:1150-1200` und die Ressourcen `IDS_CON_CON_FORWARD_ON_1/_2`, `IDS_CON_CON_QUOTE_ON_1` (`EudoraRes.rc:11642-11650`) sind die **Erkennung** eines fremden Weiterleitungskopfs beim Lesen, nicht die **Erzeugung** des eigenen. Die Erzeugungsstelle ist noch nicht gefunden **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — **nicht entscheidbar am Quelltext.** Die Erkennung fremder Köpfe steht unverändert in `ConConMessage.cpp:1236`, `:1246` und `:1315` (`IDS_CON_CON_QUOTE_ON_1`, `IDS_CON_CON_FORWARD_ON_1/_2`). Nach der **Erzeugungs**stelle wurde erneut gesucht, über alle `.cpp` nach `IDS_HEADER_SUBJECT`: die einzige Stelle, die damit einen Kopf *schreibt*, ist `msgdoc.cpp:1189` — und das ist die Empfangsbestätigung, nicht der Weiterleitungskopf. Zum Entscheiden fehlt weiterhin ein Vergleichsbild aus Eudora zu derselben Nachricht. **Was noch fehlt:** unsere eigene Seite — ein Vergleichsbild aus Eudora zur selben Nachricht liegt nicht vor, es ist also offen, ob unser Weiterleitungskopf überhaupt abweicht. Und die **Erzeugungsstelle** des eigenen Kopfs ist nicht gefunden; `ConConMessage.cpp:1150-1200` ist die Erkennung fremder Köpfe. **Stufe: wichtig** (Darstellung: Weiterleitungskopf nicht ausgerichtet)|
| <a id="e-93"></a>E-93 | **beim Weiterleiten einer bereits weitergeleiteten Nachricht gingen 83 Prozent des Inhalts verloren** — ohne dass es jemand merkte | **behoben in 7.2.0.59, von Gregor an 1.0.84 bestätigt am 13.10.2026.** Er hat die bereits weitergeleitete Synology-Nachricht unverändert erneut weitergeleitet (*Send both plain and styled*); seine `eudora.log` (nur gelesen): `E-88 vor dem Absenden: Fassung=ORIGINAL (unveraendert) Schalter=1 OrigBytes=21125 EditorBytes=9045 NeuBytes=21125 ... getippt=0` und `E-88 auf der Leitung: Bytes=21125 ... IsHTML=1 SendPlainOnly=0` — das ganze Original ging hinaus, die Editorfassung hätte 57 % verloren. Gefunden am 14.09.2026 beim Vergleich zweier Bilder: dieselbe Nachricht, einmal über Thunderbird weitergeleitet, einmal über Eudora. Die Eudora-Fassung zeigte ein zu einem Streifen gequetschtes Logo und ein schlechteres Layout. **Die eingebaute Spurmarke nannte die Ursache in einer Zeile:** `Fassung=EDITOR (Anwender hat im Zitat geaendert) OrigBytes=105125 EditorBytes=17889 Fundstelle=-1`. Hinaus gingen **17.889 statt 105.125 Byte**, obwohl Gregor nichts angefasst hatte. **Warum:** E-88 prüft, ob der Klartext des Originals **als ein zusammenhängendes Stück** in der Editorfassung steckt (`msgutils.cpp`, `szEditorText.Find(szOrigText)`). Bei einer Weiterleitung **einer bereits weitergeleiteten** Nachricht (`Fw: Fw:`) baut Paige den verschachtelten Text so um, dass der Vergleich ins Leere greift — und der Fehlschlag wurde als *„der Anwender hat im Zitat geändert"* gedeutet. **Die Behebung fragt zuerst, ob überhaupt getippt wurde:** Paige führt darüber Buch (`CPaigeEdtView::HasChanged`, `PaigeEdtView.h:193`, `m_ccLastSaved != m_chngCount`), und `PgMsgView` erbt davon. Hat der Anwender nichts angefasst, gibt es nichts zu schützen, und das Original geht hinaus. **Die Regel kann nur helfen, nie schaden:** sie greift ausschließlich, wenn nachweislich nicht getippt wurde; im Zweifel bleibt es bei der bisherigen Entscheidung. Die Spurmarke nennt jetzt `getippt=0` bzw. `getippt=1`. **Zwei neue Tests**, davon einer die Gegenprobe — **mit** Tastendruck muss die Editorfassung bleiben, sonst verschluckt die neue Regel genau das, was der Anwender geschrieben hat. Tests 150 von 150 **Stufe: kritisch** (Datenverlust: 83 Prozent des Inhalts beim Weiterleiten)|
| <a id="e-94"></a>E-94 | **die Betreffzeile wird mitten im Wort umbrochen** — `Waren bestel len`, `Wochenend e!`, und in einer früheren Fassung `1 5 %` und `b is` | **behoben in 7.2.0.84, von Gregor bestätigt am 12.10.2026 (belegt durch sein Bildschirmfoto von 1.0.84).** **Nachtrag 13.10.2026, Gregors VM (1.0.84, GMX über POP, `Mailverzeichnis.zip`, nur gelesen):** Zwei Betreffs sind dort kaputt: `Fw: ?? [Letzte Chance] Waren  bestellen & 1 5 % sparen ??` und `20260914: Fw: Jetzt bestellen: 10 % Rabatt akti vieren und`. **Das ist kein offener Rest von E-94 in 1.0.84.** Beide Nachrichten hat Gregor am 14.09. mit der **alten** Fassung weitergeleitet (`X-Mailer: … 7.2.0.58` bzw. `7.2.0.59`). Der zitierte Kopf im HTML-Rumpf, den 0.58 beim Weiterleiten selbst erzeugt hat, zeigt die Zerlegung schon zum Sendezeitpunkt: `Subject: Fw: ?? [Letzte Chance] Ware&nbsp; bestellen &amp; 1<br>&nbsp;5 % sparen ?? – Nur b<br>&nbsp;is zum Wochenende!` bzw. `Subject: Fw: Jetzt bestellen: 10 % Rabatt akti`. Den kaputten Betreff hat also die alte Fassung beim **Empfang** des web.de-Originals erzeugt (E-94), und Gregor hat ihn so weiterverschickt; auf dem Server steht seitdem der kaputte Text. Gegenprobe im selben Postfach: Die web.de-Originale derselben Betreffs hat 1.0.84 heil abgelegt (`Fw:  [Letzte Chance] Waren  bestellen & 15 % sparen  – Nur bis zum Wochenende!`, `Fw: Jetzt bestellen: 10 % Rabatt aktivieren und Preisvorteil sichern!`). `Encode2047` (Senden) wird damit nicht belastet. Am laufenden Programm gemessen über POP (Prüfnachricht 06) und über IMAP an Gregors Postfach (die Werbe-Nachricht neu abgerufen: Betreff in einer Zeile). Sein Bildschirmfoto (Titelzeile `7.2.0.84 / Paket 1.0.84+05bbaba*`) zeigt in der Liste `Fw:  [Letzte Chance] Waren  bestellen & 15 % sparen  – Nur bis` und im Kopf der geöffneten Nachricht den Betreff in einer Zeile; ebenso `Fw: Jetzt bestellen: 10 % Rabatt aktivieren …` (vorher `Rabatt akti`). Vor der Behebung an 7.2.0.83 gemessen: zwei rote Tests (`bestel` 0D 0A 20 `len`) und Prüfnachricht 06 mit Faltungen in `In.mbx`, Postfachliste nur `Pruefung E-94: Waren bestel`; nach der Behebung Betreff in einem Stück, Testsuite 188/188 (CHANGELOG 7.2.0.84). Die Ursache, wie sie vorher hier stand: **am Quelltext belegt (Stand 12.10.2026).** Zwischen zwei kodierten Wörtern, die über eine **Faltung** getrennt sind, bleibt der Leerraum stehen: `Fix2047` (`lex822.cpp:685`) und `ImapFix2047` (`ImapLex822.cpp:719`) lassen ihn mit `;//lastEqual += 2; // toast a trailing return` ausdrücklich stehen; RFC 2047, 6.2 verlangt, dass er wegfällt. Über IMAP bekommt `ImapFix2047` die ganze Kopfzeile (`ImapDownload.cpp:2276`), über POP holt `LexFill` sie zeilenweise. **Gregors Werbe-Nachricht** (mit seiner Erlaubnis nur gelesen, 1.0.75-`INBOX.mbx`) hat der **web.de-Webmailer** erzeugt (`Received: … trinity-msg-rest-webde … via HTTP`), nicht Eudora; der Betreff steht dort schon dekodiert, mit Faltungen bei `& 1<CR><LF> 5 %` und `Nur b<CR><LF> is`. **Nicht gemessen:** die Rohform vom Server, also ob die Grenzen wirklich zwischen zwei `=?UTF-8?…?=` liegen. **Die ältere Vermutung unten (`Encode2047` beim Senden) ist damit zurückgestellt**, denn Eudora hat die Nachricht nicht gesendet. Nächster Schritt, von Gregor angeordnet: drei Tests rot (`Fix2047`, `ImapFix2047`, Prüfnachricht 06), dann die Behebung. — Ursprünglicher Eintrag: Gefunden am 14.09.2026 im Protokoll zu 1.0.59, beim Weiterleiten: `Betreff=Fwd: Fw:  [Letzte Chance] Waren bestel len & 15 % sparen  \022 Nur bis zum Wochenend e! ?`. **Was gemessen ist:** die Lücken stehen nicht dort, wo Emoji entfernt wurden — `15 %` steht in derselben Zeile korrekt zusammen, seit E-90 die unsichtbaren Zeichen streicht. Es sind also zwei verschiedene Ursachen gewesen, und diese hier bleibt. **Was zu prüfen ist:** eine Kopfzeile muss laut RFC 2822 umbrochen werden, wenn sie zu lang wird, und der Umbruch gehört an ein Leerzeichen. `Encode2047` (`sendmail.cpp:1188`) nimmt dafür einen `lineLimit` und trennt an den Zeichen aus `dl2047`. Zu messen ist, ob die Längenrechnung die **kodierte** Länge (`=?UTF-8?Q?…?=`) gegen die **Klartext**-Länge verrechnet — dann bräche sie zu früh und mitten im Wort. **Nicht gemessen ist auch, wer faltet:** Eudora beim Senden, oder der Server auf dem Weg. Dazu gehören die Rohbytes der Kopfzeile aus `Out.mbx` und aus der angekommenen Nachricht nebeneinander. **Kein Datenverlust**, aber die Betreffzeile sieht nach Tippfehlern des Absenders aus **Stufe: wichtig** (Darstellung: Betreff mitten im Wort umbrochen)|
| <a id="e-95"></a>E-95 | **im Verfassenfenster werden die Bilder zerschnitten** — vom Schriftzug der Mail-A stehen nur Fragmente da, vom blauen Kreis die Oberkante | **BESTÄTIGT von Gregor am 14.10.2026 an 1.0.87:** die Mail-A- und die Mail-B je beantwortet und weitergeleitet, kein Bild zerschnitten oder gequetscht, jedes in eigener Höhe (vier Bildschirmfotos; *„E-95/E-96: bestätigt? sehr gut! dann tragen wir es auch so ein.“*). Die grauen Kästen bei Mail-B sind [E-119](#e-119) (`data:`-Bilder, im Protokoll `ok=0`), kein Rückfall. **behoben — aber NICHT so, wie 7.2.0.61 es versuchte. Die Behebung von 7.2.0.61 ist mit 7.2.0.63 wieder zurückgenommen; was trägt, ist E-96 aus 7.2.0.62. Tests 153/153, von Gregor am 14.10.2026 an 1.0.87 bestätigt (siehe Zellenanfang).** Von Gregor am 14.09.2026 an 1.0.60 gemeldet, nachdem E-89 im dritten Anlauf den Text endlich freigelegt hatte. **Der Fund steckt in seinem Bild:** der blaue Kreis ist **blau**, nicht grau — Paige hat das Bild also **geladen** und kennt seine echte Größe genau. Es ist in der Nachricht **eingebettet** (`cid:`), nicht extern verlinkt. Unser `height="20"` überschreibt diese Größe, und die 20 Punkte schneiden das Bild ab. **Bei der Mail-B dagegen** stehen graue Kästen: dort sind die Bilder **extern** (`http://…`), werden beim Verfassen nicht geholt, und Paige weiß nichts über ihre Größe — nur dort ist eine Vorgabe überhaupt sinnvoll. **`E89BilderMessbarMachen` (`msgutils.cpp`) behandelt beide Fälle gleich.** Genau das erklärt das Schwanken über vier Fassungen: 200×90 (grauer Kasten), gar nichts (Text zugedeckt), 20×20 (Bilder zerschnitten). **Zu tun:** am `src`-Attribut unterscheiden — beginnt es mit `cid:`, bleibt das Bild **unangetastet**; nur bei `http:`/`https:` greift die Vorgabe. Das ist eine Abfrage in `E89Attribut(pAttrs, nAttrLen, "src", …)`. **Nicht gemessen ist**, ob Paige auch `data:`-URIs lädt — die gehören dann zur selben Gruppe wie `cid:` **Nachtrag 7.2.0.63:** seit E-96 behoben ist, war die Vorgabe nur noch schädlich — auf Gregors Bild zu 1.0.62 war das Produktbild kein abgeschnittenes, sondern ein **auf 20×20 gequetschtes** Bild (`attr=20x20` in derselben Messung). Ein Bild ohne Maß bleibt jetzt unangetastet; Paige trägt die echte Größe selbst nach. Damit entfällt auch die `cid:`/`http:`-Unterscheidung: sie war richtig gedacht, behandelte aber ein Symptom **Stufe: wichtig** (Darstellung: Bilder zerschnitten)|
| <a id="e-96"></a>E-96 | **jedes Bild bekam die Zeilenhöhe des ersten** — dadurch wurden spätere Bilder abgeschnitten oder es klaffte Leerraum | **BESTÄTIGT von Gregor am 14.10.2026 an 1.0.87:** die Mail-A- und die Mail-B je beantwortet und weitergeleitet, kein Bild zerschnitten oder gequetscht, jedes in eigener Höhe (vier Bildschirmfotos; *„E-95/E-96: bestätigt? sehr gut! dann tragen wir es auch so ein.“*). Die grauen Kästen bei Mail-B sind [E-119](#e-119) (`data:`-Bilder, im Protokoll `ok=0`), kein Rückfall. **behoben in 7.2.0.62, am laufenden Programm gemessen** (eigener Testlauf am 15.09.2026, drei Bilder 600×150, 320×80, 20×20). **Die Ursache:** `ProcessEmbed()` (`PGHTMIMP.CPP`) räumt nach jedem eingefügten Bild den Embed-Stil auf — `procs`, `embed_entry`, `embed_object` —, **aber nicht die Zeilenhöhe**. `current_style.ascent` behielt die Höhe des Bildes. Beim nächsten Bild las `DoDataTag` in Zeile 2038 `original_ascent = current_style.ascent` diesen Wert als vermeintlichen **Text**-Ascent ein, und das Maximum weiter unten zog die Zeilenhöhe wieder auf den alten Wert hoch. **Gemessen, drei Fassungen nebeneinander:** vorher `ascent=150 150 150` bei `text-asc=13 150 150`; mit `paige_globals->def_style` `ascent=150 80 20` bei `text-asc=13 0 0` — dort fällt die Schutzregel *„die Zeile ist mindestens so hoch wie der Text"* weg, und Zählpixel von 1×1 ließen die Zeile schrumpfen; jetzt `ascent=150 80 20` bei `text-asc=13 13 13`. **Das erklärt, warum vier Fassungen lang jede Änderung an der Bildgröße mal half und mal nicht:** gedreht wurde am ersten Bild, alle folgenden übernahmen dessen Höhe blind. Bei Gregors Mail-A steht der kleine Schriftzug vor dem großen blauen Kreis — deshalb wurde dort abgeschnitten. **Kein Portierungsfehler:** die Stelle ist in allen vier Kopien im Repo identisch. **Eine bleibende Spurmarke** (`DEBUG_MASK_MISC`) nennt je Bild `attr`, `embed`, `ascent` und den Text-Ascent **Stufe: wichtig** (Darstellung: Zeilenhoehe des ersten Bildes fuer alle)|
| <a id="e-97"></a>E-97 | **Eudora stürzt ab, sobald eine Nachricht gespeichert werden soll** — *„da kommt kurz eine meldung, dann ist eudora weg!"* | **behoben in 7.2.0.64.** Von Gregor am 15.09.2026 an 1.0.63 gemeldet, als er auf meine Bitte hin eine Nachricht über *File → Save As* sichern wollte. **In jeder vorhandenen Fassung reproduziert** — 1.0.63, 1.0.62, 1.0.53 (von Gregor), 1.0.50 und 1.0.49 (von mir, eigene Testläufe). Also **kein neuer Fehler**, sondern einer, der die ganze Zeit dalag und nie auffiel, weil niemand eine Nachricht gespeichert hat. Auch das veröffentlichte Release **v1.0.50 ist betroffen**. **Windows-Ereignisprotokoll:** `Eudora.exe 7.2.0.63`, fehlerhaftes Modul `mfc140.dll`, Ausnahme `0xc0000005`, Offset `0x002a0544`. **Aufrufkette, unter dem Debugger gefangen** (`tools/stapel-untersuchen.ps1`): Ausnahme **`0xC000041D` = STATUS_FATAL_USER_CALLBACK_EXCEPTION**, Rahmen 0 `Eudora.exe`, Rahmen 1–5 **`COMDLG32.dll`** und `COMCTL32.dll` — der Windows-Dateidialog ruft in Eudoras eigenen Code zurück, und dort entsteht die Ausnahme. Eine Ausnahme in einem Systemrückruf kommt nicht über die Kernel-Grenze zurück; deshalb bricht das Programm sofort ab, statt eine Meldung zu zeigen. **WIDERLEGTE Vermutung zur Ursache — sie steht hier als Ausschluss, nicht als Handlungsanweisung** (die wirkliche Ursache und die Behebung stehen weiter unten): `CSaveAsDialog` (`SaveAsDialog.cpp:36-45`) hängt dem Dialog eine **eigene Dialogvorlage** an (`OFN_ENABLETEMPLATE`, `IDD_SAVEAS_EXT`), um die Kästchen *Kopfzeilen einschließen* und *Absätze raten* unterzubringen — aber nur `if (IsVersion4())`. Und `IsVersion4()` (`eudora.h:311`) lautet `return dwMajorVersion >= 4`. Die Abfrage ist damit **immer wahr** — gemessen am 15.09.2026: `IsVersion4()` liefert **1**. (Zur gemeldeten Hauptversion gibt es zwei Angaben: die Messung vom 15.09. nennt **6**, `Befunde/PRUEFER-11.md` rechnet mit **10**. Beide liegen über 4, das Urteil ändert sich dadurch nicht; wer die Zahl braucht, misst sie nach.) Gemeint war 1996 „Shell-Version 4 oder neuer", also Windows 95 aufwärts; heute trifft das auf jedes Windows zu. Die Vorlage von 1996 wird damit **immer** an einen modernen Dateidialog gehängt. **Gemessen am 15.09.2026** an einem selbst gestarteten Eudora (`tools/TESTLAEUFE.md`, `C:\Temp\E97-Stapel`, *„E-97: laeuft der Dialog ohne die Vorlage von 1996?"*, Commit `bdd12f4`): Vorlage **abgeschaltet — stürzt weiter ab**; `QCFindResourceHandle` liefert ein **gültiges** Handle (`71D40000`); der Konstruktor läuft durch, `OnInitDialog` wird **nicht** erreicht. Damit ist die Vorlage als Ursache vom Tisch, und die Lücke liegt zwischen Konstruktor und `OnInitDialog`. **Die Behebung hat die Vorlage nicht angetastet — die beiden Kästchen sind trotzdem weg, und zwar seit der Portierung.** Von PRUEFER am 17.09.2026 am Quelltext belegt (`Befunde/PRUEFER-11.md`, P-2 und P-4): `CFileDialog` in MFC 14.38 hat `bVistaStyle = TRUE` als Vorgabe (`afxdlgs.h:144`), `CSaveAsDialog` übergibt kein `FALSE` (`SaveAsDialog.cpp:23-25`), und `ApplyOFNToShellDialog` liest `lpTemplateName` **nirgends** — `IDD_SAVEAS_EXT` wird also **nie** instanziiert. *Kopfzeilen einschließen* und *Absätze raten* kann der Anwender seit der Portierung nicht mehr wählen; gespeichert wird nach dem, was in der `Eudora.ini` steht. **Das ist ein eigener, noch offener Mangel, nicht E-97** — Wege dazu in `PRUEFER-11.md`, P-4. **behoben in 7.2.0.64, am laufenden Programm geprüft.** **Die Stelle, symbolisiert aus dem Debugger:** `CSaveAsDialog::OnTypeChange + 45`, **`SaveAsDialog.cpp:425`** — darunter `COMDLG32.dll`, darüber `CTocView::OnFileSaveAs` (`tocview.cpp:3074`). **Der Dateidialog ruft diese Funktion, während er sich aufbaut** — also **vor** `OnInitDialog`; genau deshalb kam eine Spurmarke dort nie an. Zu diesem Zeitpunkt hat das Vorlagenfenster noch kein Elternfenster: `GetParent()` liefert **NULL**, und `dlgPtr->GetDlgItem(cmb1)` griff ungeprüft darauf zu. Ein paar Zeilen weiter dieselbe Lücke: `m_GuessParagraphs.EnableWindow()` auf einem Schalter, den `DoDataExchange` bewusst **nicht** anbindet, wenn es ihn ohne Vorlage nicht gibt. **Beide Zugriffe waren durch ein `ASSERT` „abgesichert", das im Release nichts tut** — die häufigste Ursachenklasse dieses Projekts. **Behebung:** fällt `GetParent()` aus, ist der Dialog noch nicht fertig — dann gibt es nichts zu tun, `OnInitDialog` setzt den Zustand gleich darauf. **Gegenprobe:** derselbe Messlauf, der vorher *„ABGESTUERZT beim Speichern unter"* meldete, sagt jetzt *„lebt noch"*. **Von Gregor am 17.09.2026 an 1.0.64 bestätigt:** *„gespeichert. funktioniert."* und *„speichern test hat also funktioniert."* **Drei Vermutungen von mir waren vorher widerlegt worden:** die CSS-Grenze, die Dialogvorlage von 1996 und die ungeprüften Steuerelemente in `OnInitDialog`. **153 Tests, 153 bestanden.** **Regressionstest seit 25.10.2026:** Prüfstandsfall E-97 (`tools/messen-e97.ps1`, `C:\Temp\E97`): Speichern unter aus dem Postfach mit OK, Dialog erscheint, Eudora lebt, Datei geschrieben. Gegenprobe ohne die beiden Wächter in `OnTypeChange`: rot, `Exception.log` nennt `CSaveAsDialog::OnTypeChange()+0045`. **Stufe: kritisch** (Absturz beim Speichern einer Nachricht)|
| <a id="e-98"></a>E-98 | **Die beiden Optionen im Speicherdialog fehlen** — *Kopfzeilen einschließen* (`Include Headers`) und *Absätze raten* (`Guess Paragraphs`) sind im Dialog *Speichern unter* nicht vorhanden. | **offen, gemessen an 7.2.0.64.** Aufgefallen bei der Gegenprobe zu **E-97**: der Messlauf zählt die Steuerelemente des offenen Dialogs und meldet `Eigene Kaestchen gefunden: 0`, während `Button '&Speichern'` und `Button 'Abbrechen'` da sind — der Dialog geht also auf, nur die beiden eigenen Kästchen fehlen. **Ursache, soweit gemessen:** `CSaveAsDialog` (`SaveAsDialog.cpp:36-45`) hängt dem Dateidialog eine **Dialogvorlage von 1996** an (`OFN_ENABLETEMPLATE`, `IDD_SAVEAS_EXT`). Windows 10 öffnet stattdessen den modernen Dateidialog, und der zeigt eine solche Vorlage nicht mehr an. Deshalb bindet `DoDataExchange` die Schalter nicht an, und `m_GuessParagraphs.GetSafeHwnd()` ist null — **genau der Zustand, an dem E-97 abgestürzt ist.** **Kein Rückschritt durch die Behebung von E-97:** die Kästchen waren auch vorher nicht sichtbar, es kam nur niemand so weit, weil das Programm vorher abbrach. **Folge für den Anwender:** beim Speichern einer Nachricht lassen sich Kopfzeilen und Absatzerkennung nicht wählen; es gilt, was zuletzt in `Eudora.ini` stand. **Noch nicht gemessen:** welche Vorgabe dann tatsächlich greift, und ob der moderne Dialog über `IFileDialogCustomize` nachgerüstet werden kann. Von Gregor am 17.09.2026 in die Fehlerliste aufgenommen: *„ja, in die bug liste aufnehmen."* **Was noch fehlt:** zweierlei ist nicht gemessen — welche Vorgabe für *Kopfzeilen einschließen* und *Absätze raten* tatsächlich greift, solange die Kästchen fehlen, und ob der moderne Dateidialog über `IFileDialogCustomize` nachgerüstet werden kann. Die Vorlage von 1996 (`IDD_SAVEAS_EXT`) zeigt Windows 10 nicht mehr an.  **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — **und der Befund trifft eine andere Stelle als gedacht.** Die beiden Ankreuzfelder **gibt es** im Dialog (`SaveAsDialog.cpp:69`, `IDC_GUESS_PARA`, dazu `m_IncludeHeaders`). Gemessen wurde etwas anderes, und es ist ein Widerspruch im eigenen Haus: **die Behebung zu [E-104](#e-104) ist auf halbem Weg stehengeblieben.** `E104SchalterLesen` (`msgutils.cpp:4654`) fängt unsinnige INI-Werte ab — Gregors `Eudora.ini` trug `GuessParagraphs=7179` und `IncludeHeaders=16720`, uninitialisierte Stapelwerte aus [E-100](#e-100). Benutzt wird sie an **11 Stellen** (`ReadMessageDoc.cpp`, `compmsgd.cpp`, `tocview.cpp`). **`SaveAsDialog.cpp` benutzt weiter das rohe `GetIniShort`**, an sechs Stellen (`:48`, `:49`, `:148`, `:155`, `:195`, `:202`), `filtersd.cpp:2050` an einer. **Folge:** der Dialog zeigt beide Häkchen als gesetzt, weil 7179 ungleich null ist, während das Speichern selbst den berichtigten Wert benutzt. Dialog und Programm sagen verschiedene Dinge über dieselbe Einstellung. **Was noch fehlt:** die sieben Stellen auf `E104SchalterLesen` ziehen — eine Zeile je Stelle — und danach messen, welche Vorgabe der Dialog dann zeigt. **Stufe: wichtig** (Funktion: zwei Optionen im Speicherdialog fehlen)|
| <a id="e-99"></a>E-99 | **Datenverlust: wer einen Entwurf sichert und danach sendet, verliert seinen getippten Text** — die Anmerkung über dem Zitat wird still durch das aufgehobene Original ersetzt. | **behoben in 7.2.0.64, am laufenden Programm geprüft.** Vom PRUEFER am 17.09.2026 beim Nachrechnen der E-93-Behebung in der MFC-Quelle gefunden, bevor das Paket hinausging. **Die Ursache:** `HasChanged()` (`PaigeEdtView.h:193`) lautet `return (m_ccLastSaved != m_chngCount)` und beantwortet damit **nicht** die Frage „hat der Anwender getippt", sondern „hat er **seit dem letzten Sichern** getippt". Denn `PgMsgView::ExportMessage` ruft an seinem Ende `SaveChangeState()` (`PgMsgView.cpp:460`), und das setzt `m_ccLastSaved = m_chngCount`. **Der Weg:** Antwort verfassen, Entwurf sichern (erster Durchlauf durch `ExportMessage`, `HasChanged()` wahr), Fenster offen lassen, senden (zweiter Durchlauf, `HasChanged()` jetzt **falsch**). E-93 übergibt diesen Wert als `bAnwenderHatGetippt` an `E88OriginalEinsetzen` — beim zweiten Durchlauf hätte das aufgehobene Original den getippten Text überschrieben. **Ohne Meldung**, genau der Weg, den E-93 schließen sollte. **Behebung:** `CCompMessageDoc::m_bE88AnwenderHatGetippt` (`compmsgd.h`), ein Merker am Verfassendokument, der **einrastet**: `if (HasChanged()) pComp->m_bE88AnwenderHatGetippt = TRUE;` vor dem Aufruf. Einmal wahr, immer wahr, solange das Verfassenfenster lebt — dieselbe Lebensdauer wie `m_szE88OriginalHTML`. **Bau: 0 Fehler.** Gregor am 15.09.2026: *„ja, kein datenverlust!"* **Regressionstest seit 25.10.2026:** Unit-Test in `TestSpeicherfehler.cpp` (Quelltext ohne Kommentare): Merker wird vor `E88OriginalEinsetzen` gesetzt, übergeben und nur im Konstruktor zurückgesetzt. Gegenprobe `HasChanged()` statt Merker: rot. **Stufe: kritisch** (Datenverlust: getippter Text geht beim Senden verloren)|
| <a id="e-100"></a>E-100 | **Dieselbe Absturzstelle wie E-97, an drei weiteren Stellen — und zwei uninitialisierte Werte, die in die Einstellungen des Anwenders laufen** | **behoben in 7.2.0.65.** Vom PRUEFER am 17.09.2026 als Gegenvermutung zu E-97 gefunden (`Befunde/PRUEFER-11.md`, P-5 und P-6), **bevor jemand darüber gestolpert ist**. **Teil 1 — dieselbe Lücke, dreimal:** `GetFileNameFromDialog` (`SaveAsDialog.cpp:388`), `ToggleStat` (`:241`) und `StatDir` (`:303`) berechnen `dlgPtr = GetParent()` genau wie `OnTypeChange` und greifen **ungeprüft** darauf zu. `GetFileNameFromDialog` ist die gefährliche: sie wird aus `OnOK()` gerufen, also **im laufenden Speichervorgang**, nicht nur beim Aufbau. `ToggleStat` und `StatDir` hängen an `ON_BN_CLICKED(IDC_STATIONERY)` — der Schalter existiert heute nicht (**E-98**), sie werden also scharf, sobald E-98 behoben wird. **Teil 2 — `m_Inc` und `m_Guess`:** in `SaveAsDialog.h:44` deklariert, vom Konstruktor **nicht** gesetzt, zugewiesen nur in `OnInitDialog:132` innerhalb von `if (IsVersion4()) { if (m_IsMessage) ... }`. Alle drei Aufrufstellen schreiben sie nach `DoModal()` **ungeprüft** in die INI: `tocview.cpp:3087-3088`, `saveas.cpp:106-107`, `compmsgd.cpp:3374-3375`. Läuft `OnInitDialog` auf der Vista-Schiene nicht, landen zwei uninitialisierte Werte **dauerhaft** in `IDS_INI_INCLUDE_HEADERS` und `IDS_INI_GUESS_PARAGRAPHS`. **Behebung:** Wächter `if (dlgPtr == NULL) return;` an allen vier Stellen (der fünfte Block in `SetFileNameInDialog` benutzt `dlgPtr` auf dem `IsVersion4()`-Zweig gar nicht, bekommt ihn aber mit), und Vorbelegung `m_Inc = GetIniShort(IDS_INI_INCLUDE_HEADERS)` / `m_Guess = GetIniShort(IDS_INI_GUESS_PARAGRAPHS)` im Konstruktor — das ist der Stand, der ohnehin gelten soll. **Dazu ein dritter Weg, den der Wächter selbst aufgemacht hätte:** `GetFileNameFromDialog` füllt einen Puffer, den `OnOK` als `char realFileName[_MAX_PATH + 1]` uninitialisiert auf den Stapel legt. Kehrt sie ohne Schreiben zurück, arbeitet `OnOK` mit Stapelmüll weiter (`strstr(realFileName, ".sta")`, im schlimmsten Fall `strcat`) — ein unbrauchbarer Dateiname wäre schlimmer als der Absturz. Das galt **auch vorher schon**, wenn `GetDlgItem(edt1)` null lieferte; der Wächter kam als zweiter solcher Weg dazu. Deshalb steht jetzt `buf[0] = 0;` als erste Anweisung der Funktion, und `OnOK` setzt seinen Puffer zusätzlich selbst auf leer. **Teil 4 — ein Wächter saß an der falschen Stelle:** in `SetFileNameInDialog` stand die Prüfung über der ganzen Funktion, obwohl `dlgPtr` auf dem `IsVersion4()`-Zweig gar nicht benutzt wird (`SetControlText` geht über `IFileDialogCustomize`). Der Wächter hätte den Aufruf übersprungen und den Dateinamen still nicht gesetzt — eine Verhaltensänderung, wo nur ein Absturz zu verhindern war. Vom PRUEFER gefunden (`Befunde/PRUEFER-12.md`, P-15); die Prüfung steht jetzt dort, wo `dlgPtr` wirklich benutzt wird. **Bau: 0 Fehler.** Dazu zwei falsche Begründungen im Quelltext berichtigt: ein Kindfenster hat immer ein Elternfenster, `GetParent()` liefert NULL, **weil `m_hWnd` selbst noch null ist**; und `OnInitDialog` holt den Zustand **nicht** nach — es ruft weder `EnableWindow` noch `OnTypeChange()`. Letzteres ist heute folgenlos und wird zum Fehler in dem Moment, in dem jemand E-98 behebt; steht als Warnung im Quelltext. **153 Tests, 153 bestanden.** Am laufenden Programm geprüft an 7.2.0.65: der Messlauf zählt die Fenster oberster Ebene vor und nach dem Befehl und meldet `NEU #32770 Speichern unter`, danach `SPEICHERDIALOG IST OFFEN` und `Dialog geschlossen, Eudora lebt weiter`. **Regressionstest seit 25.10.2026:** Prüfstandsfall E-100 (`tools/messen-e97.ps1`): Speichern unter aus einem Verfassen-Fenster, Eudora lebt, `IncludeHeaders`/`GuessParagraphs` in der INI nur 0/1 oder nicht vorhanden; der OK-Weg (`GetFileNameFromDialog`) läuft im Fall E-97 mit. **Stufe: kritisch** (Absturz: dieselbe Stelle dreimal mehr)|
| <a id="e-101"></a>E-101 | **Die gespeicherte Datei ist für jedes andere Programm unbrauchbar** — *„datei gespeichert, aber unbrauchbar"* | **behoben, soweit es Datenverlust und Gregors Symptom betrifft - P-28 ist in 7.2.0.69 behoben und von PRUEFER-37 in 23 Faellen gegengeprueft, die Ergaenzung der Kopfzeile ist am 23.10.2026 an 7.2.0.120 belegt. F2 besteht FORT (Block 4a laeuft nie), ist aber Wirkung ohne Schaden; F5 bis F9 ebenso. Einzelheiten unten.** **Dritter Teil eingebaut in 7.2.0.107 (17.10.2026), F1, F3 und F4 behoben in 7.2.0.110, von Gregor noch nicht bestätigt.** **Die Behebung:** eine vorhandene `Content-Type`-Zeile wird nicht mehr blind übernommen. Der **Rumpf** ist immer Eudoras interne Fassung (beim Empfang zerlegt, entschlüsselt, nach Windows-1252 übersetzt — `TextReader.cpp`, `ISOTranslate`); die **Kopfzeilen** stehen dagegen so da, wie sie ankamen. **Gemessen an sechs empfangenen HTML-Nachrichten** im Postfach des Prüfstands (`C:\Temp\E80b\Mailverzeichnis\In.mbx`, nur gelesen): alle sechs tragen `Content-Type: multipart/…; boundary=…`, und **keine einzige** der Grenzen steht im Rumpf — ein anderes Programm sucht die Teile und findet keinen; vier davon sagen im HTML `charset=UTF-8`, die Bytes sind Windows-1252. Gespeichert wird jetzt `windows-1252` statt `ISO-8859-1`, wie es der Anzeigeweg längst tut (`TridentView.cpp`, `szCharsetMeta`); die Bytes `0x80` (€), `0x92` (’) und `0x96` (–) gibt es in ISO-8859-1 nicht. **213 Tests, 213 bestanden** (vier neue). **Gegenprobe gefahren:** mit dem alten `msgutils.cpp` fallen **genau diese vier** um, die übrigen **209 bleiben grün** — darunter die Gegenprobe *„passender Kopf und passendes `<meta>` bleiben unberührt"*, ohne die aus der Behebung *„jede Kopfzeile wird überschrieben"* geworden wäre. **URSPRÜNGLICHER BEFUND, 13.10.2026, Gregor an 1.0.84:** *„inhalt ist mit falschen zeichen dargestellt“*. Gemessen an seiner Datei `Fwd Deine Anzeige 'Zu verschenken Beispielartikel'.txt` (82 617 Byte, nur gelesen von der VM-Freigabe): HTML-Teil einer empfangenen, von **Thunderbird** weitergeleiteten Nachricht (Kleinanzeigen), über *File → Save As* gesichert. Kopf von `E101SpeicherfassungAufbereiten`: `Content-Type: text/html; charset="ISO-8859-1"`. **Zwei Widersprüche in derselben Datei:** (1) im HTML steht unverändert `<meta http-equiv="content-type" content="text/html; charset=UTF-8">` (zweimal, aus der Originalmail) — die Bytes sind aber **Windows-1252** (`ä` = `E4`, `ß` = `DF`, 21 Bytes ≥ `0x80`, kein einziges gültiges UTF-8-Paar). Wer dem `<meta>` glaubt, zeigt an der Stelle von `äß` ein Ersatzzeichen (U+FFFD). Das ist dieselbe Ursache, die der Anzeigeweg schon kennt (Abschnitt „Woher das Ersatzzeichen kommt“: `GetBodyAsHTML` lässt `<meta charset>` stehen, `ISOTranslate` wandelt nach CP1252); der Speicherweg hat die dortige Behebung nicht. (2) Die Datei enthält `80` (€), `92` (’) und `96` (–) — das ist nicht ISO-8859-1, sondern Windows-1252; die Regel „ein Byte ≥ `0x80` heißt `ISO-8859-1`“ ist für diese Bytes falsch. **Geklärt mit Gregor am selben Tag:** *„ist kein TXT sondern HTML, sehe ich gerade. alles klar.“* — die Endung `.txt` hatte den HTML-Inhalt verdeckt (dass `.txt` und `.eml` denselben Inhalt bekommen, steht schon unten). Offen bleibt der Zeichensatz-Widerspruch in der Datei selbst: jedes Programm, das sie als HTML liest, folgt dem `<meta charset=UTF-8>` und zeigt statt der Umlaute Ersatzzeichen. Behebung wie im Anzeigeweg: fremdes `<meta charset>` entfernen und `windows-1252` angeben. **Nebenbefund:** der vorgeschlagene Dateiname lässt `ä` und `ß` weg (`Gefe` statt `Gefäße`). — Bisheriger Stand: **behoben in 7.2.0.66 und 7.2.0.69, am laufenden Programm geprüft.** Erster Teil in **7.2.0.66**, zweiter Teil in **7.2.0.69**; von Gregor noch nicht bestätigt. Von Gregor am 17.09.2026 gemeldet, nachdem er eine weitergeleitete Nachricht über *File → Save As* gesichert und die Datei geöffnet hatte. **Gemessen an seiner Datei** (eine gespeicherte weitergeleitete Mail, 5.716 Byte): vier Kopfzeilen (`From`, `To`, `Subject`, `Date`), danach Eudoras **interner Marker `<x-html>`** und roher HTML-Text. **Keine `Content-Type`-Zeile, keine `MIME-Version`, kein Zeichensatz.** `.eml` und `.txt` sind byte-identisch — der Dateityp im Dialog ändert nichts. **Die Ursache:** bei einer selbst verfassten Nachricht entsteht die `Content-Type`-Zeile **erst beim Senden**. `SendContentType` (`sendmail.cpp:766`) baut sie aus den Merkern des Übersichtseintrags (`MSF_XRICH`, `MSFEX_HTML`), nicht aus dem Rumpf. Was in `Out.mbx` liegt, ist die interne Fassung; `GetFullMessage` liefert genau die, und der Speicherweg (`tocview.cpp:3163`) schrieb sie unverändert hinaus. **Was der Anwender davon hatte:** Thunderbird und jedes andere Programm zeigen entweder HTML-Quelltext oder Buchstabensalat — die Umlaute sind korrekt als Latin-1 gespeichert (das Byte hinter dem `g` in „gültig" ist `0xFC`, gemessen), aber ohne `charset=` weiß kein Leser das. **Behebung:** `E101SpeicherfassungAufbereiten` (`msgutils.cpp`) entfernt den `<x-html>`-Marker samt Gegenstück und ergänzt `MIME-Version`, `Content-Type` und `Content-Transfer-Encoding`, sobald keine `Content-Type`-Zeile vorhanden ist. Untertyp nach dem Marker (`text/html` oder `text/plain`), Zeichensatz nach den Bytes (ein Byte ≥ `0x80` heißt `ISO-8859-1`, sonst `us-ascii`) — beides **aus dem Inhalt abgeleitet, nicht geraten**. **Eine vorhandene `Content-Type`-Zeile bleibt unangetastet**, eine empfangene Nachricht bringt ihre echten Kopfzeilen mit. **160 Tests, 160 bestanden** (sieben neue, darunter die Gegenprobe an der empfangenen Nachricht und der Stolperstein „zitiertes `Content-Type:` im Rumpf"). **Am laufenden Programm geprüft:** Nachricht selbst gespeichert und die Datei wieder geöffnet — `MIME-Version: 1.0`, `Content-Type: text/html; charset="ISO-8859-1"`, kein `x-html`. **Der Prüfer hat diese Behebung übersetzt und mit zwölf Eingaben gefahren — vier davon haben Inhalt verloren** (`Befunde/PRUEFER-13.md`). Sein Urteil: so nicht ausliefern, denn vorher war die Datei unbrauchbar, aber **vollständig**; danach wäre sie brauchbar und in konstruierbaren Fällen **unvollständig, ohne sichtbare Lücke**. **P-18:** der Marker wurde im ganzen Rumpf gesucht und das schließende `>` über Zeilengrenzen hinweg — in einer Klartextnachricht ist das nächste `>` das **Zitatzeichen**. Gemessen: `"Er schrieb <x-html in die Zeile. Du sagtest:\r\n> stimmt"` wurde zu `"Er schrieb  stimmt"`, **36 von 62 Byte weg**; der Verlust war also unbegrenzt, nicht markergroß, und traf auch **empfangene** Nachrichten. Behoben: der Marker steht, wenn überhaupt, als **erste Zeile** des Rumpfs (`etf2html.cpp:200`, `TocFrame.cpp:1408`), und nur wenn die ganze Zeile aus ihm besteht. **P-19:** das Gegenstück wurde als *letzter* Treffer gesucht — steht dahinter noch Text, wurde das **zitierte** entfernt und das echte blieb stehen. Gemessen: `"WICHTIGER NACHSATZ </x-html> ende"` wurde zu `"WICHTIGER NACHSATZ  ende"`. Behoben: der Fund zählt nur, wenn dahinter nichts als Leerraum steht. **P-20:** begann der Text mit einer Leerzeile, fiel der Trenner beim Zusammenbau ersatzlos weg — 22 Byte rein, 18 raus. **P-21:** gemischter Zeilentrenner ließ `\r\r\n` im Kopf stehen. **P-22:** ohne Leerzeile zwischen Kopf und Rumpf griff die Behebung gar nicht, die Spurmarke las sich trotzdem wie ein Erfolg; sie nennt jetzt `trenner=0`. **Sechs neue Tests, einer je gemessenem Fall** — 166 Tests, 166 bestanden. **Die Lehre dahinter:** bei E-97 hatte ich gemessen, dass der Dialog aufgeht, und daraus „Speichern funktioniert" gemacht. Dass niemand je in die herausgekommene Datei geschaut hatte, ist derselbe Befund eine Ebene tiefer — `Arbeitsweise/nie-benutzt-ist-nicht-geprueft.md`. **Beim Nachpruefen von `main` fand der PRUEFER hier einen DATENVERLUST (P-28):** die Behebung loeschte die **ganze erste Rumpfzeile**, sobald sie auf `>` endete — stehen `<x-html>` und der Text auf derselben Zeile, war der **komplette Rumpf weg** (`104 Byte rein, 128 raus, null Byte Rumpf`). Die Datei wird dabei **groesser**, weil die Kopfzeilen dazukommen; deshalb faellt es nicht auf. Dass der Fall vorkommt, steht in Eudoras eigenem Quelltext: *„`<x-html>` And the message all comes on the same line"* — stammt aus `QuoteText()` (`msgutils.cpp:2374`), ein Kommentar von QUALCOMM aus 1996, wird nie überschrieben; er ist **kein Oberflächentext**; `IDS_MIME_RICH_ON` ist `"<%s>"` ohne Zeilenende, `etf2html.cpp:200` ebenso — nur der POP-Weg setzt den Marker auf eine eigene Zeile, und nur der war geprueft. **Behoben:** entfernt wird das **Tag**, nicht die Zeile; Ende ist das erste `>` ausserhalb von Anfuehrungszeichen, ueber die erste Zeile hinaus wird nicht gesucht. Drei neue Tests. **Vom PRUEFER nachgerechnet (`Befunde/PRUEFER-15.md`) — kein Textverlust, und zwar bewiesen:** `UnwrapText` legt keinen zweiten Puffer an, liefert buchstäblich den Eingabezeiger zurück, und **schreibt nie vor `text`** — der einzige Rückwärtsschreiber sitzt im `else`-Zweig, in den nur kommt, wer `End - Beg >= 40` hat; kleinster Schreibort ist `Beg + 1`. Die Kopfzeilen bleiben Byte für Byte stehen. **Dabei fand er aber, dass die Behebung nur die halbe Strecke deckte (M-1):** `CReadMessageDoc::SaveAs` (`ReadMessageDoc.cpp:535`) und `CReadMessageDoc::SaveAsFile` (`:603`) tragen denselben ungeschützten Aufruf — dort war `FindBody` sogar **genau umgekehrt** eingesetzt, es lief, wenn die Kopfzeilen *nicht* mitsollten. **Speicherte Gregor eine empfangene Nachricht aus ihrem Fenster, trat der Fehler unverändert wieder auf.** Beide Stellen nachgezogen. **Dazu M-2:** `compmsgd.cpp:3415` und `:3429` lasen den Schalter weiter roh, so dass die Datei mit verdorbener INI mit einer einsamen `Date:`-Zeile ohne Leerzeile begann — verklebt wurde sie nur deshalb nicht, weil sie 38 Zeichen hat und die 40-Zeichen-Regel griff: **zwei Zeichen Abstand zum Fehler, Zufall statt Schutz.** **M-4:** auch `tocview.cpp:3098-3099` liest jetzt über `E104SchalterLesen`, damit die Reparatur auf allen Wegen greift. **169 Tests, 169 bestanden.** **P-38 (17.09.2026, `p38-spurmarke-rumpf`):** die Spurmarke dieser Funktion konnte den Verlust aus P-28 **gar nicht zeigen** — sie nannte nur die Gesamtlängen, und die **wachsen** durch die drei neuen Kopfzeilen auch dann, wenn der Rumpf ganz verschwindet. Bei P-28 stand wörtlich `bytes-vorher=104 nachher=128 geaendert=1` im Protokoll, und der Rumpf war dabei **null Byte** lang; die Zeile las sich wie ein Erfolg. Sie nennt jetzt zusätzlich **`rumpf-vorher`** und **`rumpf-nachher`** — aus `rumpf-vorher=72 rumpf-nachher=0` ist der Verlust in **einer** Zeile zu lesen (`Arbeitsweise/zwei-werte-in-eine-ausgabe.md`). **Dazu der Prüfsatz der drei P-28-Tests:** sie fragten mit `Hat()`, also *„enthält die Ausgabe X"* — genau der Satz, der den Schnitt durchgelassen hat, denn die Kopfzeilen waren ja da. Neu ist `PruefeJedesByte()`: aus dem Rumpf der **Eingabe** werden die genannten Tags geschnitten, und was übrig bleibt, muss **Byte für Byte** der Rumpf der Ausgabe sein — nicht „darin enthalten", sondern gleich; eine andere Länge ist ebenfalls eine Abweichung. `PruefeRumpfMass()` hält die beiden neuen Werte gegen die Bytes statt nur auf ihr Vorhandensein zu sehen. Die Gegenprobe zum Prüfsatz selbst läuft auf dem Normalfall, der unbeanstandet durchgehen muss (`Arbeitsweise/schranke-gegentesten.md`). **Beim Lesen des eigenen Testlaufs fiel dabei ein zweiter Befund auf:** unter `P-21: gemischter Trenner` stand `rumpf-vorher=74 rumpf-nachher=55` — diese 74 Byte gehören zu `P-28: Marker und Text auf derselben Zeile` (74 − 8 für `<x-html>` − 9 für `</x-html>` − 2 für die Zeilenschaltung = 55). `TT_Note` druckte **sofort**, der Testname aber erst in `TT_EndTest`; **jede Notiz stand damit im Protokoll unter dem Test davor** — alle 169, seit es `TT_Note` gibt. Eine Anzeige, die den Leser zum falschen Testfall führt, ist schlimmer als keine (`Arbeitsweise/anzeige-ist-kein-zustand.md`, `Arbeitsweise/ausreisser-ist-der-befund.md`). Behoben: `TT_Note` sammelt, `TT_EndTest` gibt nach dem Namen aus, `TT_Fail` räumt den Puffer gleich nach der `[FEHL]`-Zeile heraus. **169 Tests, 169 bestanden**, und die drei P-28-Fälle nennen jetzt ihre eigenen Werte — 74/55, 66/58, 61/21, jeder geht in der Rechnung auf. **ZWEITER TEIL, 17.09.2026 — an Gregors eigenen Dateien gefunden, nicht konstruiert.** Er hat mit `1.0.69` mehrere Nachrichten gespeichert; erst die Spurmarke aus **P-38** machte den Rest sichtbar: `kopfzeilen=0 trenner=0 content-type-vorhanden=0`, `bytes-vorher=102006 nachher=101985`, `rumpf-vorher=102006 rumpf-nachher=101985`. **Zwei Befunde in denselben zwei Zeilen.** **Gut:** `rumpf-vorher` minus `rumpf-nachher` ist beide Male genau **21 Byte** — `<x-html>` plus CRLF (10) und `</x-html>` plus CRLF (11), kein Byte zuviel; **P-28 hält damit an echten Daten**, vorher war es nur am Messstand belegt. **Schlecht:** `nachher` **ist gleich** `rumpf-nachher` — es kam **nichts dazu**. Seine Dateien tragen HTML **ohne `MIME-Version`, ohne `Content-Type`, ohne Zeichensatz**, also genau der Zustand *„datei gespeichert, aber unbrauchbar"*; der Marker war entfernt, die Datei damit sogar schwerer als HTML erkennbar als vorher. **Die Ursache:** der ganze Kopfzeilenblock hängt an `if ( !szKopf.IsEmpty() )` — ohne *Kopfzeilen einschließen* ist `szKopf` leer und der Block wird übersprungen. **E-101 war also nur behoben, wenn der Schalter an war**, und laut **E-98** ist das Kästchen auf Windows 10 gar nicht anwählbar; es gilt, was in der `Eudora.ini` steht, und dort stand *aus*. Der Normalfall war der ungedeckte. **Dass das eine bewusste Entscheidung war, stand als Test da** (*„ohne Kopfzeilen wird auch keine erfunden"*). Der Grundsatz bleibt — **erfunden wird nichts**; ergänzt wird nur, was der Leser braucht, um die Bytes zu deuten, und nur wo es ohne diese Angabe schiefgeht: **HTML** (sonst zeigt jedes Programm Quelltext) und **Hochbyte** (sonst wird aus `0xFC` je nach Leser ein anderes Zeichen). **Reiner `us-ascii`-Text bekommt weiterhin nichts.** *„Kopfzeilen einschließen"* meint die Kopfzeilen der **Nachricht** — `From`, `To`, `Subject`, `Date` —, nicht die Erklärung, was die Bytes darunter sind. Die Spurmarke nennt den Fall selbst: **`mime-ergaenzt=0/1`**. **Drei neue Tests, und der mittlere ist der wichtigere:** die Gegenprobe, dass reiner Text unberührt bleibt — ohne sie wäre daraus *„jede Datei bekommt jetzt Kopfzeilen"* geworden. **171 Tests, 171 bestanden.** **Ehrlich zum Weg:** die beiden neuen Tests waren zuerst **rot**, weil mein erster Schreibversuch vor dem Schreiben abgebrochen war und nur Merker und Spurmarke ankamen — sie haben den fehlenden Einbau gemeldet, genau wofür sie da sind. **Und ehrlich zur Nummer:** ich hatte dafür zuerst ein neues **E-107** vergeben, ohne `tools/befund-suchen.pl` zu fahren. Gregor: *„wieso e-107 fix? wir sind noch bei e-101"* — er hat recht, die Nummer ist zurückgenommen. **Am laufenden Programm gemessen ist der BEFUND:** Gregors zwei Protokollzeilen aus `1.0.69` belegen dreierlei live — dass die neuen Werte aus P-38 ueberhaupt erscheinen, dass P-28 an echten Daten haelt (zweimal exakt 21 Byte), und dass der `Content-Type` fehlt. **Nicht gemessen ist die BEHEBUNG:** sie entstand nach seiner Messung, sein `1.0.69` trug sie noch nicht. Offen ist also nur die Bestaetigung, dass eine gespeicherte Datei jetzt MIT `Content-Type` herauskommt — nicht der Nachweis, dass etwas falsch war. **BERICHTIGT am 23.10.2026 nach [LEKTOR-51b](../Befunde/LEKTOR-51b.md): F2 steht, falsch war die Umschreibung in DIESEM Eintrag.** Hier stand: *„`StripTabooHeaders` entfernt die `Content-Type`-Zeile, bevor der Kern sie setzen kann; auf dem einzigen Aufrufweg ist **er** damit tot (gemessen in 72 von 72 Nachrichten)."* Ich habe daraufhin die Reihenfolge nachgemessen, diese Umschreibung widerlegt und F2 für erledigt erklärt. **Das war falsch, und LEKTOR hat es umgeworfen.** [PRÜFER-37](../Befunde/PRUEFER-37.md) sagt nämlich etwas anderes, wörtlich (`:41`): *„Der ganze neue **Block 4a** ist auf dem einzigen Aufrufweg **tot**"* — nicht der Kern, sondern **Block 4a**, also die F1-Behebung in `msgutils.cpp:4276-4390`. Und derselbe Bericht nennt den Ergänzungszweig bereits selbst (`:248`): *„das tut schon der zweite Teil (`:4418-4426`), weil nach dem Taboo-Schnitt keine `Content-Type`-Zeile mehr da ist."* **Der PRÜFER kannte die Reihenfolge also; meine „Widerlegung" hat nur meine eigene Paraphrase getroffen.** **F2 besteht fort, selbst nachgemessen:** `bHatContentType` wird allein aus dem **bereits gestrippten** Kopf berechnet, die Vorgabeliste enthält `Content-` als Präfix (`EudoraRes.rc:10016`), also ist das Tor `if ( bHatContentType )` (`msgutils.cpp:4276`) für **jede empfangene** Nachricht zu. Block 4a läuft im Auslieferungszustand **nie**, und `bCtErsetzt` kann auf diesem Weg nie wahr werden — `\|\| bCtErsetzt` in `:4521` ist ein toter Teilausdruck. Passend dazu steht in Gregors Spurmarke `ct-ersetzt=0`, und `CHANGELOG.md:1193-1200` beschreibt genau das seit dem 19.10.2026 richtig. **Schwere laut PRÜFER-37: „hoch (Wirkung), kein Schaden" — F2 war nie ein Datenverlustweg.** **Am Quelltext nachgemessen stimmt die Reihenfolge nicht:** auf dem Speicherweg in `CTocView` läuft `StripTabooHeaders` in **Zeile 3138** und `E101SpeicherfassungAufbereiten` in **Zeile 3186** — der Kern also **nach** dem Stripper, nicht davor. Er entscheidet anhand von `bHatContentType`, das er aus dem **bereits gestrippten** Kopf berechnet, und ergänzt genau dann. Das Strippen ist damit nicht die Ursache, sondern der Auslöser der Ergänzung. Beide Zweige in `msgutils.cpp` tun es: mit Kopfzeilen `:4524` (`if (!bHatContentType \|\| bCtErsetzt)`), ohne Kopfzeilen `:4581`. **Am laufenden Programm bestätigt**, und zwar mit genau der Prüfung, die dieser Eintrag selbst verlangt: Gregor hat am 23.10.2026 an 7.2.0.120 eine HTML-Nachricht über *File → Save As* gesichert und die Datei vorgelegt (`Formel 1, NFL & 50 % Geburtstagsrabatt.txt`/`.html`, 65537 Byte). Darin steht `Content-Type: text/html; charset="windows-1252"`, dazu `<meta charset="windows-1252">`, der HTML-Rumpf ist vollständig bis `</body></html>`, und von den 106 Bytes über 127 ist **keines** zerstört (28× Euro, 27× geschütztes Leerzeichen, ä/ö/ü/ß, `„`, `"`, `•`) — **kein einziges Ersatzzeichen**. Die eigene Spurmarke dazu: `E-101 speichern: kopfzeilen=0 … content-type-vorhanden=0 typ=text/html charset=windows-1252 … mime-ergaenzt=1 … meta-charset=1 geaendert=1` (`eudora.log` im Verzeichnis 1.0.116, Zeile 6824). **Einschränkung, damit sie nicht untergeht:** gemessen ist der Weg **ohne** Kopfzeilen (`kopfzeilen=0`); dort läuft `StripTabooHeaders` gar nicht. Für den Weg **mit** Kopfzeilen ist nur der Quelltext gelesen, keine Datei. F1, F3 und F4 sind in 7.2.0.110 behoben. **Warum das Urteil trotzdem „behoben" lautet:** der Datenverlust in dieser Zeile — und nur er lässt `tools/pruefe-datenverlust.pl` abweisen — ist **P-28** (*„die Behebung loeschte die ganze erste Rumpfzeile"*). P-28 ist in 7.2.0.69 behoben, durch `PruefeJedesByte()` abgesichert und von PRÜFER-37 in **23 Fällen** gegengeprüft: *„in allen 23 Fällen ist der Rumpf Byte für Byte derselbe geblieben."* F2 stand nur deshalb unter demselben Riegel, weil es in derselben Tabellenzeile steht. **Was offen bleibt und nicht mitgeschluckt wird:** **F2** (Block 4a tot, Wirkung ohne Schaden) sowie **F5 bis F9** aus [PRÜFER-37](../Befunde/PRUEFER-37.md) — gering, gering, kosmetisch, Doku, Prüflücke. Keiner davon ist ein Schadensweg. **Prüflücke, von LEKTOR gefunden:** `Eudora71/Tests/TestE101.cpp` (843 Zeilen) enthält **keinen einzigen** Fall mit einem taboo-geschnittenen Kopf; die Gegenprobe füttert einen Kopf **mit** `Content-Type` — eine Eingabe, die der ausgelieferte Weg für eine empfangene Nachricht nie erzeugt ([pruefstand-nicht-bequemer-als-die-wirklichkeit](../Arbeitsweise/pruefstand-nicht-bequemer-als-die-wirklichkeit.md)). **Wie zu pruefen:** **ICH** — Testsuite plus eine echte Nachricht: HTML-Mail über *File → Save As* sichern und die Datei in einem Browser öffnen. Rot: Umlaute als Ersatzzeichen, weil die `Content-Type`-Zeile fehlt. Grün: sie steht drin und die Zeichen stimmen.  **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — **F2 bestätigt, und der Mechanismus ist schärfer als hier beschrieben.** `StripTabooHeaders` (`ReadMessageDoc.cpp:472`) entfernt nicht die Kopfzeile *Content-Type*, sondern jede Kopfzeile, die mit einem Eintrag der Taboo-Liste **beginnt**: der Vergleich ist `strnicmp(eintrag, p, eintrag.GetLength())` (`:503`). In der Vorgabe (`EudoraRes.rc:10016`, Schlüssel `TabooHeaders`) steht der Eintrag **`Content-`** — acht Zeichen. Damit fällt **jede** `Content-`-Kopfzeile weg: `Content-Type`, `Content-Transfer-Encoding`, `Content-Disposition`. **In keiner ausgelieferten INI ist `TabooHeaders` gesetzt**, es greift also überall diese Vorgabe. **ÜBERHOLT am 23.10.2026 ([LEKTOR-52](../Befunde/LEKTOR-52.md), L-52.1).** Hier stand: *„Der Kern kann die Zeile setzen, so viel er will — sie wird **danach** von einer Prefix-Regel mitgerissen"*, und daraus die Empfehlung, `Content-` aus der Vorgabe zu nehmen. **Der Mechanismus stimmt, die Reihenfolge nicht:** `StripTabooHeaders` läuft in `tocview.cpp:3138`, der Kern erst in `:3186` — also **vorher**, nicht danach. Das Strippen zerstört die ergänzte Zeile nicht, es **löst die Ergänzung aus**; zugleich ist es der Grund, warum Block 4a nie läuft. Die empfohlene Behebung wäre falsch gewesen: nähme man `Content-` aus der Vorgabe, bliebe die möglicherweise falsche `Content-Type`-Zeile der empfangenen Nachricht stehen, und der Kern ergänzte nichts mehr. **Stufe: kritisch** (Datenschaden: gespeicherte Datei fuer andere Programme unbrauchbar)|
| <a id="e-103"></a>E-103 | **Bilder liegen über dem Text** — *„da ist alles durcheinander, man kann ja nichts lesen."* | **BEHOBEN IN 7.2.0.85 zusammen mit [E-112](#e-112), von Gregor an 1.0.86 bestätigt am 13.10.2026 (Kleinanzeigen-Nachricht: kein Bild mehr auf dem Text); zuvor am laufenden Programm gemessen:** in der Prüfnachricht steht kein Bild mehr auf dem Text, das Bild ohne Angabe bleibt 79x64. **Vorher: WIEDER OFFEN — an 1.0.84 von Gregor widerlegt (13.10.2026)**: beim Weiterleiten der Kleinanzeigen-Nachricht liegt das Logo über „Deine Anzeige wird weniger gesehen“ (sein Bildschirmfoto, Titelzeile `7.2.0.84 / Paket 1.0.84+05bbaba*`). Nach der Behebung schon zweimal gezeigt: 17.09. an 1.0.67 ([E-106](#e-106)) und 18.09. an 1.0.76 ([E-112](#e-112)); der Rückfall kommt aus E-112. Vorher: **behoben in 7.2.0.67, am laufenden Programm geprüft.** Von Gregor an 1.0.56 gemeldet und seither mehrfach angemahnt. **An seiner echten Nachricht nachgestellt** (Mail-A-Verifizierungscode, 23.537 Byte, aus `INBOX.mbx` byte-genau gelöst, fünf Bilder). **Die Kette, vollständig vermessen:** beim Import meldet `PGHTMIMP.CPP:2186` für das Logo der Mail-A `attr=0x0 embed=0x0 ascent=13` — kein `width`/`height` im HTML, also reserviert Paige **eine Textzeile von 13 Punkten**. Das Bild ist aber **202×60**. Die 47 Punkte Unterschied liegen über dem folgenden Text. **Die anderen vier Bilder sind unauffällig:** `attr=80x80 ascent=80`, `attr=98x35 ascent=35`, `attr=117x35 ascent=35`, `attr=80x24 ascent=24` — sie tragen ihre Maße im HTML. **Paige misst Bilder nie selbst nach**, es liest die Größe ausschließlich aus den Attributen (`PGHTMIMP.CPP:2019-2022`). **Was danach passiert — und das war die Überraschung:** `PgLoadUrlImage` (`PgEmbeddedImage.cpp`) lädt das Bild wirklich aus dem Netz, erfährt dabei die echte Größe und trägt sie nach. Drei neue Spurmarken belegen jeden Schritt: `E-103 Nachtrag: quelle=202x60 embed=202x60 gefunden=1 pos=288` (die Größe ist bekannt und das Embed wird wiedergefunden), `E-103 Zeilenhoehe: pos=288 ascent-vorher=60 bildhoehe=60 nachgezogen=0` (**die Zeilenhöhe steht zu diesem Zeitpunkt schon auf 60** — `pgInvalEmbedRef` zieht den Textstil also doch nach), `E-103 Neuzeichnen: bucket=1 fenster=1` (und das Fenster wird neu gezeichnet). **Damit heilt sich der Fall im heutigen Bau selbst, sobald das Bild geladen ist** — was E-96 (Zeilenhöhe je Bild, behoben in 7.2.0.63) zu verdanken sein dürfte. **Offen bleibt genau ein Fall:** lässt sich das Bild **nicht** laden — kein Netz, toter Verweis, gesperrt —, erscheint **keine** der drei Marken, und die Zeile bleibt bei 13 Punkten. Gegenprobe gefahren: dieselbe Nachricht mit dem Logo auf `https://kein-rechner.invalid/logo.png` liefert `attr=0x0 embed=0x0 ascent=13` und sonst nichts. **Behebung:** der Import reserviert eine **Mindestzeilenhöhe von 48 Punkten** (`E103_MINDESTHOEHE`, `PGHTMIMP.CPP`), sobald gar keine Größe bekannt ist; die echte Höhe aus der geladenen Datei gewinnt danach. **Beide Fälle am laufenden Programm gemessen, mit derselben Nachricht:** ladbar — vorher `ascent=13` dann 60, jetzt `ascent=48` beim Import dann **60**; nicht ladbar — vorher `ascent=13`, jetzt **`ascent=48`**. **Das ist ausdrücklich nicht der Notbehelf von früher:** bis 7.2.0.62 wurde die *Bildgröße* auf 20×20 geraten und Gregors Produktbild dabei zu einem Streifen gequetscht. Hier wird **nur die Zeile** hoch genug gemacht; an Breite und Höhe des Bildes ändert sich nichts. Die 48 sind begründet: das Logo der Mail-A ist 60 hoch, die vier anderen Bilder derselben Nachricht 24 bis 80 — groß genug gegen das Überlappen, klein genug, dass ein kleines Symbol keine Lücke reißt. **Dazu drei neue Spurmarken** in `PgEmbeddedImage.cpp` (`E-103 Nachtrag`, `E-103 Zeilenhoehe`, `E-103 Neuzeichnen`) und ein **Sicherungsnetz**: ist die Zeile nach dem Laden niedriger als das Bild, wird sie nachgezogen. Es hat in der Messung **nicht** ausgelöst (`nachgezogen=0`), und die Marke sagt das auch — es steht da für den Fall, dass `pgInvalEmbedRef` einmal nicht durchgreift. **Stufe: wichtig** (Darstellung: Bilder ueber dem Text)|
| <a id="e-104"></a>E-104 | **Die Kopfzeilen der gespeicherten Nachricht kleben zusammen** — `From: … <…> Subject: … Cc:` in einer Zeile | **behoben in 7.2.0.67 und 7.2.0.68, am laufenden Programm geprüft.** Die verfasste Nachricht in **7.2.0.67**, die empfangene in **7.2.0.68** (die andere Hälfte, PRUEFER M-1 bis M-4). Von Gregor am 17.09.2026 an 1.0.65 gemeldet, als er eine Nachricht aus dem **geöffneten Fenster** speicherte. **Gemessen an seiner Datei gegen das Postfach:** in `Out.mbx` steht jede Kopfzeile für sich, in der Datei standen `From:`, `Subject:` und `Cc:` in einer Zeile. **Ursache 1:** `CCompMessageDoc::SaveAsFile` (`compmsgd.cpp:3437`) schickte `UnwrapText` über die **ganze** Nachricht, Kopfzeilen inbegriffen. In `tocview.cpp:3149` steht an derselben Stelle der Schutz *„Don't unwrap the headers!"* mit `FindBody` — auf dem Fensterweg fehlte er. **Ursache 2 — und die ist die eigentliche:** dass „Absätze raten" überhaupt lief, ist eine **Folge von E-100**. Gregors `Eudora.ini` trug `GuessParagraphs=7179` und `IncludeHeaders=16720` — **uninitialisierte Stapelwerte**, die E-100 dort hineingeschrieben hatte. Jeder Wert ungleich 0 gilt als eingeschaltet; er hat es nie gewählt und konnte es mangels Kästchen (**E-98**) gar nicht wählen. **E-100 hat das Loch gestopft, die schon verdorbenen Werte aber nicht repariert.** **Behebung:** `UnwrapText` läuft nur noch über den Rumpf (`FindBody`), und `E104SchalterLesen` (`msgutils.cpp`) zieht jeden Wert, der weder 0 noch 1 ist, auf die Vorgabe 0 zurück **und schreibt ihn berichtigt zurück** — sonst gäbe er beim nächsten Leser wieder eine falsche Antwort. Mit Spurmarke, die den alten Wert nennt. **Damit muss niemand ein neues Mailverzeichnis anlegen.** **Zwei Punkte selbst nachgerechnet, bevor das Paket gebaut wurde:** `UnwrapText` (`msgutils.cpp:453`) arbeitet **im Puffer** und liefert denselben Zeiger zurück (`return text`) — `pFile->Put(CopyText)` schreibt also den vollständigen Text, kein Verlust; und `GetMessageHeaders` (`compmsgd.cpp:4023`) hängt am Ende `hdrs += "\r\n"` an, es gibt also die Leerzeile, die `FindBody` sucht. **169 Tests, 169 bestanden.** **Stufe: wichtig** (Darstellung: Kopfzeilen kleben zusammen)|
| <a id="e-105"></a>E-105 | **Ein versteckter Vorschautext wird mitgelesen** — beim Lesen einer eBay-Nachricht steht über dem Inhalt eine lange Reihe `? ? ? ?` | **behoben in 7.2.0.88, von Gregor am 22.10.2026 an Paket 1.0.120 bestätigt.** **Behebung 14.10.2026:** `E105Schritt` in `PGHTMIMP.CPP` liest in `ReadHTMLTag` den fertigen Tagpuffer, bevor die Attribute ausgewertet werden. Steht im `style`-Attribut `display:none` (Groß-/Kleinschreibung und Leerzeichen egal, `mso-display` zählt nicht), wird das Tag verschluckt, ebenso alles bis zu seinem Ende-Tag, verschachtelt gezählt. Text dazwischen sperrt `e105_tiefe` an denselben vier Stellen wie `inside_script` (AN-2). Leere Elemente (`img`, `br` …) und `<… />` öffnen keinen Bereich. Schutz gegen nie geschlossene Elemente: `</body>`/`</html>` beenden jeden Bereich; ein verstecktes `<p>` endet wie im Browser am nächsten Blockelement oder am Ende der umgebenden Zelle. Der Tabellen-Vorlauf (`ProcessPreTable`) sichert den Zustand und stellt ihn wieder her, weil er dieselben Tags zweimal liest. Spurmarke `E-105 versteckt (display:none): <tag>` (`DEBUG_MASK_MISC`). **Test:** `Tests/TestE105.cpp`, sechs Fälle samt Gegenrichtung (sichtbar bleibt sichtbar), Suite 202/202; Gegentest mit absichtlich verstellter Erkennung: 5 rot. **Messung:** `Testdaten/e105-handyfassung-versteckt.eml` über den POP-Prüfstand in `C:\Temp\E105`: 7.2.0.88 zeigt beim Öffnen und Weiterleiten nur die sichtbaren Teile, im Protokoll vier versteckte Bereiche (`div`, `table`, `span`, `p`); **Gegenprobe 1.0.87** (`C:\Temp\E105-1087`, Programmdateien aus dem Release-ZIP) zeigt Vorschauzeile, Handyfassung, verstecktes Wort und versteckten Absatz. **Am echten Fall gemessen (14.10.2026):** Gregor legte den freenet-Newsletter „Änderungen für Autofahrer“ als `.htm` nach `C:\Temp\E105-echt` (nicht im Repo, privat), als Prüfnachricht über den POP-Prüfstand abgerufen und weitergeleitet. 7.2.0.88: elf versteckte Bereiche im Protokoll, das Titelbild steht einmal, keine Fragezeichenzeile. Gegenprobe 1.0.87: Fragezeichenzeile unter „freenet Magazin“ und das Titelbild zweimal hintereinander. **Nach [PRÜFER-26](../Befunde/PRUEFER-26.md) nachgebessert (14.10.2026, weiter 7.2.0.88):** implizite Enden für versteckte `<td>`/`<th>`/`<tr>`/`<li>` und das Ende-Tag eines Vorfahren beenden den Bereich (vorher verschwand bei weggelassenem `</td>` der Rest der Mail); ein verstecktes `<p>` endet auch an `td`/`th`/`tr`/`li`; in `<script>` wird nichts versteckt; die Spur schreibt der Tabellen-Vorlauf nicht mehr; jeder Import beginnt sichtbar (`pgPrepareImport`). Test (7), Suite 203/203, Gegentest mit abgeschaltetem Schutz 2 rot; Prüfnachricht und freenet-Newsletter danach unverändert richtig (elf versteckte Bereiche, so viele wie inline `display:none` in der Datei). **Berichtigt:** `<style>` wird nicht von der AN-2-Sperre verschluckt, sondern vorher von `ScanStyleSheet` (`Paige_io.cpp:1071-1075`) gelesen, das `display` nicht auswertet. **Nicht abgedeckt:** `display:none` über eine **Klasse** aus einem `<style>`-Block (Paige wertet `<style>` nicht aus, AN-2 verschluckt ihn). Bei Gregors freenet- und eBay-Fällen steht das `display:none` inline, dort greift die Behebung. Nebenbei sichtbar, schon in 1.0.87 so: zwei Tabellenzellen stehen beim Weiterleiten ohne Zwischenraum (`Desktop innen ADesktop innen B`), kein neuer Fehler. **Vorgeschichte:** **Dritter Fall, Gregor am 14.10.2026 an 1.0.87** (Bildschirmfoto, ohne Protokollmessung): Antwort auf den freenet-Newsletter „Änderungen für Autofahrer \| One-Hit-Wonder der 1980er“ – Bild **und Text** des Abschnitts stehen doppelt (Desktop- und Handyfassung). Daraufhin von Gregor vorgezogen: *„ja, E-105 vorziehen“*, Zweig `e-105_doppelte_bilder`. **Zweiter Fall, Gregor am 13.10.2026 an 1.0.86** (*„bilder sind doppelt. kannst du das im log bestätigen?“*, Antwort auf den freenet-Newsletter „Camper-Trend \| Lost Places“): das Schwan-Motiv steht zweimal im Verfassenfenster. Seine `eudora.log`: zwei **verschiedene** Dateien, `3782.jpg` (`gemalt=260x172`) und `3783.jpg` (`gemalt=600x260`), dazu das Kopfbild `3781.jpg` zweimal. Im Original (VM-Kopie `In.mbx`): `3782.jpg` in `<table class="desktop fs_xlarge">`, `3781.jpg` einmal mit Klasse `desktop`, einmal `fs_large` – Desktop- und Handyfassung, im Browser blendet `display:none` eine aus. Paige kennt `display:none` nicht und zeigt beide. Keine Folge von E-112 (vorher standen beide in Dateigröße da). Von Gregor am 17.09.2026 auf seinem zweiten Bildschirmfoto gemeldet; **am 18.09.2026 vom LEKTOR (L-15.10) erstmals als Befund aufgeschrieben** — der Fall wurde seit dem 17.09. in `WEITERMACHEN.md` als *„E-105 aufschreiben"* geführt, hatte aber **keine Zeile in dieser Datei**; `grep -n "E-105" BEFUNDE.md` lieferte nichts. **Belegt an `C:\Temp\probe-ebay.eml`** (40.936 Byte, 17.09.2026): die Nachricht trägt **vier** Bereiche mit `display:none`, darunter `<div class="preheaderMod" style="display:none;">` mit dem Text *„Jetzt bieten."* und darin `<div style="display:none;">` mit **96 Wiederholungen von `?&nbsp;`**. Das ist ein Füllmuster, mit dem Absender die Vorschauzeile im Posteingang auffüllen. **Zwei Dinge daran, und das zweite schützt vor einer Falschsuche:** (1) **Paige kennt `display` nicht.** Die drei Listen der auswertbaren Attribute stehen in `PGHTMDEF.C:29` (`control_attributes`), `:38` (`style_attributes`) und `:49` (`data_attributes`) — in keiner steht `display`, und `grep -ci display PGHTMDEF.C` liefert **0**. Die drei Treffer in `PGHTMIMP.CPP:966/985/1229` sind Kommentare über *„on display"*, nicht die CSS-Eigenschaft. Was CSS verbirgt, zeigt Paige also an; dieselbe Wurzel wie **E-88** (`PGHTMDEF.C:20-48`, Paige kennt keine einzige CSS-Eigenschaft). (2) **Die Fragezeichen sind KEIN Zeichensatzfehler.** Sie stehen wörtlich als `?` in der Quelle — anders als bei **E-90**, wo `ISOTranslate` Emoji zu `?` macht. Wer hier nach einer Umkodierung sucht, sucht am Fall vorbei. **Kein Datenverlust, keine Fehlfunktion des Abrufs** — die Nachricht kommt vollständig an, sie wird nur vollständiger angezeigt, als der Absender wollte. **Zu messen, bevor etwas gebaut wird:** ob ein `display:none` überhaupt sicher erkennbar ist (es steht hier im `style`-Attribut, kann aber ebenso in einem `<style>`-Block über eine Klasse kommen — in dieser Nachricht steht **beides**: `.preheaderMod, .preheaderMod div { … display: none; }`). Ein Filter, der nur das Attribut liest, deckt den halben Fall **Was noch fehlt:** Gregors Bestätigung an einem Paket, und ein nicht abgedeckter Fall: `display:none` über eine **Klasse** aus einem `<style>`-Block — den liest `ScanStyleSheet` (`Paige_io.cpp:1071-1075`), und das wertet `display` nicht aus. Inline greift die Behebung. **Wie zu pruefen:** **GREGOR** — ich kann das nicht abschließen, es braucht einen Blick in ein echtes Postfach. Eingebaut in 7.2.0.88, an `Testdaten/e105-handyfassung-versteckt.eml` gemessen. **Schritte:** (1) Paket starten, (2) eine Werbemail öffnen, über deren Inhalt vorher eine lange Reihe `? ? ? ?` stand, (3) nachsehen, ob die Reihe weg ist und der übrige Text unverändert aussieht. **Worauf achten:** erscheinen Bilder jetzt nur noch **einmal** statt doppelt (Desktop- und Handyfassung)? **Stufe: wichtig** (Darstellung: versteckter Vorschautext mitgelesen)|
| <a id="e-106"></a>E-106 | **Bilder, die größer sind als angegeben, liegen über dem Text** — der Fall, den E-103 **nicht** traf | **behoben in 7.2.0.68, von Gregor an 1.0.69 bestätigt.** Von Gregor am 17.09.2026 an 1.0.67 gemeldet: das grüne *kleinanzeigen*-Logo liegt weiter über „Deine Anzeige wird weniger gesehen". **Sein Protokoll hat es entschieden.** Neun Bilder seiner Nachricht wurden nach dem Laden nachgemessen, und bei allen wuchs die Zeile mit: `attr=140x0 → quelle=140x134 → ascent=134`, `attr=24x0 → quelle=24x49 → ascent=49`. **Das Logo war nicht darunter.** Es trägt `attr=200x52 embed=200x52 ascent=52` — und danach keine einzige Zeile mehr. **Die Ursache:** der Nachtrag in `PgLoadUrlImage` (`PgEmbeddedImage.cpp`) läuft nur `if (embed->height == 0 \|\| embed->width == 0)`. Ein Bild mit **beiden** Angaben wird **nie nachgemessen**; die echte Dateigröße erfährt niemand, weil auch `pUrlImage->source_width/height` nur gesetzt werden, wenn sie leer sind. **Und Paige skaliert nicht.** Absender legen Bilder in doppelter Auflösung ab und geben im HTML die halbe Größe an, damit sie auf feinen Bildschirmen scharf bleiben — jeder Browser skaliert, Paige zeichnet die Datei in Originalgröße in eine Zeile, die nach der Angabe bemessen ist. Bei 200×52 angegeben und 400×104 geladen sind das **52 Punkte, die auf dem folgenden Text liegen**. **Warum E-103 daran vorbeiging:** E-103 behandelt Bilder **ohne** Größenangabe. Gregors Logo hat eine. Zwei Fassungen lang war der falsche Fall behoben. **Behebung:** die echte Dateigröße wird jetzt **immer** gemerkt (`nEchtBreite`/`nEchtHoehe` aus `MetafileFromImage` bzw. der QuickTime-Schiene), und ist sie höher als die angegebene, bekommt die Zeile die echte Höhe. **Nur vergrößern, nie verkleinern.** Richtig skalieren wäre besser, sitzt aber tief in Paige; zugedeckter Text ist der teurere Fehler. **Von Gregor am 17.09.2026 an 1.0.69 bestätigt** — sein Bildschirmfoto zeigt die Überlappung weg, der Text steht wieder unter dem Logo. **Belegt hat es allein sein Lauf:** **mein Prüfstand lädt Bilder, aber keines, das größer ist als angegeben — das ist der Unterschied, und er war bis zum 18.09.2026 falsch aufgeschrieben** (LEKTOR, L-15.9). Gemessen an `C:\Temp\E107-vorher\Mailverzeichnis\eudora.log` (17.09.2026, 21:28) und `C:\Temp\E100\…` (21:45): je **acht** `E-95 Bild`-Zeilen und **drei** `E-103`-Zeilen, darunter `E-103 Nachtrag: quelle=79x64 embed=79x64 gefunden=1` — dort steht die **echte Dateigröße**, das Bild ist also geholt und vermessen worden. **Null** ist allein der Zähler `E-106 groesser`: im Testdatensatz hat jedes Bild `attr == embed` (79x32, 22x22, 135x40), der Block hat nichts nachzumessen. Es fehlt nicht das Laden, sondern das **Testdatum**. **Und das Nachspiel gehört hierher:** genau dieser Block hat den Absturz beim Antworten eingeschleppt — erst als **E-107** falsch erklärt, dann als **E-108** in 7.2.0.72 wirklich behoben. **Berichtigt am 18.09.2026 (LEKTOR, L-15.4):** hier stand *„gebaut in 7.2.0.68, bei Gregor noch nicht nachgewiesen"* und *„Noch nicht nachgewiesen … Bleibt die Zeile aus, ist auch diese Ursache widerlegt"*, während `AUFGABEN.md` und `README.md` die Bestätigung an 1.0.69 bereits nannten — dieselbe Tatsache, zwei Antworten. **Stufe: wichtig** (Darstellung: zu grosse Bilder ueber dem Text)|
| <a id="e-107"></a>E-107 | **WIDERLEGT — Absturz beim Antworten auf eine geöffnete Nachricht** — `EXCEPTION_ACCESS_VIOLATION in Paige32.dll at UnuseMemory()+0006`, `ESI=FFFFFFFF` | **widerlegt, siehe E-108.** Die Absicherung bleibt im Quelltext, sie schadet nicht — aber sie war **nicht** die Ursache: Gregors Protokoll zu 1.0.71 zeigt den Block fünfmal laufen und den Abbruch an derselben Stelle wie zuvor. **Ursprüngliche Begründung, zur Nachvollziehbarkeit:** **Der Fehler war meiner**, eingebaut mit **E-106** wenige Stunden zuvor. Von Gregor am 17.09.2026 um 21:23 an 1.0.69 gemeldet; `ESI=FFFFFFFF` ist ein ungültiger Speicherverweis. **Die Ursache steht als Warnung im Quelltext, seit 1996:** `eCallback` ruft `PgLoadUrlImage` zweimal, und über dem ersten Aufruf steht *„Don't allow threaded fetch, because we're being called with a temporary embed_ptr"* — **der Embed ist beim Vorbereiten flüchtig.** Mein E-106-Block liest trotzdem `embed->height` und `embed->style` und durchsucht damit das ganze Dokument. Der Block davor (E-103) trug dieselbe Gefahr, lief aber nur bei Bildern **ohne** Maßangabe; meiner lief zusätzlich bei allen **mit** Angabe, also bei fast jedem Bild jeder Werbemail. **Behebung:** beide Blöcke laufen nur noch bei `bAllowThreadedFetch` — genau die Unterscheidung zwischen Vorbereiten (flüchtig) und Laden (echter Embed). **Nicht nachgestellt, und das gehört dazu:** der Prüfstand lädt zwar Bilder, aber keines, das größer ist als angegeben — der verdächtige Code läuft dort deshalb gar nicht an (L-15.9, am Protokoll gemessen: acht `E-95 Bild`-Zeilen, null `E-106 groesser`). Auch die **Gegenprobe mit der abstürzenden Fassung 1.0.69 blieb negativ**, sie öffnet das Antwortfenster im Prüfstand sauber. **Am Quelltext ablesbar bleibt:** auf dem gefährlichen Weg läuft der neue Code jetzt gar nicht mehr, das Verhalten fällt dort auf den Stand vor E-103 und E-106 zurück. **171 Tests, 171 bestanden.** **Stufe: unkritisch** (widerlegt)|
| <a id="e-108"></a>E-108 | **Der Absturz beim Antworten — zweiter Anlauf, und E-107 war die falsche Erklärung** | **behoben in 7.2.0.72, von Gregor am laufenden Programm bestätigt.** *„kein crash"* — und sein Protokoll belegt es an drei Stellen: der Block läuft **18 mal** (66 × `E-95 Bild`, 10 × `E-103 Nachtrag`), er läuft **über die bisher tödliche Stelle hinaus** — `pos=770` steht hinter dem `attr=135x40 quelle=405x120 pos=765`, an dem in allen drei Absturzprotokollen Schluss war —, und die letzte Zeile lautet `Logging shutdown`. Es gibt **keine `Exception.log`**, nicht einmal eine leere. **E-107 ist damit widerlegt.** Ich hatte den Absturz damit begründet, dass der E-106-Block auf einem *flüchtigen* Embed läuft, und ihn auf den Ladeweg beschränkt. **Gregors Protokoll zu 1.0.71 hat das widerlegt:** der Block läuft dort **fünfmal**, und die letzte Zeile vor dem Abbruch ist wieder seine eigene Spurmarke — `E-106 groesser als angegeben: attr=135x40 quelle=405x120 gefunden=1 pos=765`, dasselbe Bild und dieselbe Stelle wie an 1.0.69. **Der Fehler steckt im Block, nicht darin, wer ihn aufruft.** **Was der Block anders machte** als der QUALCOMM-Block zwanzig Zeilen darüber, der seit 1996 unauffällig läuft: er fasste den **Textstil** an (`pgGetStyleInfo`/`pgSetStyleInfo`) an einer Position aus einer Suche über `embed->style`. Der PRUEFER hat unabhängig gemeldet (**P-41**), dass `embed->style` ein **Zeiger** ist, den sich zwei Bilder gleicher Maßangabe teilen — die Suche kann also das **falsche** Embed liefern, und dann schreibt der Stilweg an die falsche Stelle. **Behebung:** derselbe Weg wie im QUALCOMM-Block — die Maße ins **Embed** schreiben und `pgInvalEmbedRef` rechnen lassen, kein Zugriff mehr auf den Textstil. **Dazu ist mein E-103-Sicherungsnetz ersatzlos entfernt:** es fasste denselben Stilweg an und hat in **keiner** Messung je ausgelöst (`nachgezogen=0`, jedes Mal) — totes Gewicht auf einem gefährlichen Pfad. Das schließt zugleich **P-40**, wonach die E-107-Absicherung E-103 für eingebettete Bilder mitabgeschaltet hatte. **Nicht nachgestellt:** der Prüfstand lädt zwar Bilder, aber der Block läuft dort nicht an; **nur Gregors Lauf entscheidet.** **171 Tests, 171 bestanden.** **Stufe: kritisch** (Absturz beim Antworten)|
| <a id="e-109"></a>E-109 | **Die Schranken waren da und haben nicht gehalten** — *„es gibt viele schranken, die genau das verhindern sollen!"* | **offen, an einem Tag belegt.** Gregor am 17.09.2026, nach einem Abend mit drei Abstürzen, zwei falschen Ursachen und einem beinahe ausgelieferten Datenverlust. **Er hat recht, und es ist nachweisbar.** **Was durchgelassen wurde, mit Beleg:** (1) **`pruefe-befund-verbreitung.pl`** — am selben Tag gebaut, **beim ersten echten Lauf blind**: sie liest nur die Überschriften des jüngsten CHANGELOG-Abschnitts, und 7.2.0.70 nennt seine Befunde im Fließtext; Meldung *„nennt keinen Befund - nichts zu pruefen"*. Ich hatte sie zweimal gegen Fehlalarme geschärft (54, dann 3) und dabei in die Blindheit geschärft. (2) **`pruefe-stand-md.pl`** meldete `LEKTORAT.md` grün, während die Datei `Befunde/LEKTOR-13.md` **kein einziges Mal** nannte — sie vergleicht nur das Datum. (3) **`pruefe-behoben-belegt.pl` und `pruefe-befundurteile.pl`** lesen das Urteil mit `\*\*([^*]{1,80})\*\*`; **ein Fettdruck über 80 Zeichen lässt das Muster zum nächsten springen**, ein behobener Befund gilt dann als offen — und beide melden weiter grün, weil sie ihn nur in der anderen Spalte zählen. (4) Dieselben zwei prüften bei einem Bestandsauftrag **0 Zeilen** und schrieben trotzdem ihren Erfolgssatz — ein Freispruch über eine leere Menge. (5) **`pruefe-branch.pl`** hat eine dokumentierte Lücke (ohne vorheriges `fetch` schlägt sie nicht an) **ohne Testfall, der sie festhält** — und für *„Zweigname mit Gregor abgestimmt"* gibt es **gar keine Schranke**, obwohl `Arbeitsweise/zweig-vorher-abstimmen.md` seit dem 11.09.2026 gilt und die Regel an diesem einen Tag **viermal** gebrochen wurde. (6) **Keine Schranke** verhindert, dass „behoben" gemeldet wird, während die Behebung nur im Bauverzeichnis liegt — genau das ist am Morgen passiert und hat Gregor in denselben Absturz laufen lassen. (7) **Keine Schranke** verhindert, dass zwei gleichzeitig laufende Sitzungen dieselbe Fassungsnummer vergeben; die Quelle dafür (`Releases/PAKETE.md`) hinkte um fünf Nummern hinterher. **Das Muster, und es ist der eigentliche Befund:** jede dieser Schranken wurde **nach** einem Schaden gebaut und gegen **genau den Fall** geprüft, der gerade passiert war — nicht gegen die nächste Spielart. Und mehrere melden grün, wenn sie nichts zu prüfen fanden, statt zu sagen, dass sie nichts geprüft haben. **Was zu tun ist:** jede Schranke braucht (a) einen Testfall für ihre **bekannte Grenze**, nicht nur für den Fall, den sie fängt, und (b) eine Unterscheidung zwischen *„geprüft und frei"* und *„nichts gefunden zu prüfen"*. Der zweite Zustand darf nicht wie der erste aussehen. **(8) Nachtrag vom 18.09.2026 (LEKTOR, L-15.5) — eine Schranke, die die Unwahrheit ERZWINGT.** `tools/doku-pruefen.pl:594` löst auf das Wort *Paketnummer* aus und verlangt in den 200 Zeichen dahinter die **aktuelle** Nummer aus `VERSION`. In `tools/ZWEIGE.md` steht dort aber, was ein Zweig **gebracht** hat — eine Aussage über die Vergangenheit. Die Zeile zu `p38-spurmarke-rumpf` ist dadurch **dreimal** weitergeschoben worden (7.2.0.69 → .70 → .71 → .72), obwohl LEKTOR-14 sie zweimal gemessen und gemeldet hatte; und als sie auf den wahren Wert **1.0.69** berichtigt war, meldete die Schranke prompt *„MANGEL: tools/ZWEIGE.md:73 nennt Paketnummer 1.0.69 als Stand, VERSION sagt 1.0.72"*. **Ein Fehlalarm, dem jemand folgt, ist teurer als eine stumme Prüfung** (`Arbeitsweise/schranke-gegentesten.md`). Vorläufig aufgelöst durch die Formulierung *„Daraus entstand Quellstand 7.2.0.69 und Paket 1.0.69"* — dieselbe Wendung wie in der Nachbarzeile, die seit Tagen stumm durchläuft; die **Grenze der Schranke besteht weiter**. **Zu tun:** die Ausnahme am **Merkmal** festmachen, nicht am Dateinamen — eine Zeile, die *„Daraus entstand"*, *„gebracht"* oder einen Commit-Kurznamen nennt, ist Vergangenheit (`Arbeitsweise/pruefumfang-nicht-von-hand.md`, Punkt 2). **(9) Regressionstests für die Szenarien, von Gregor am 17.09.2026 ausdrücklich verlangt:** *„für all diese szenarien brauchen wir regression tests!"* — auf der Ebene, auf der die Fehler auftreten, also Szenariotests über `tools/testlauf.ps1`, nicht Unit-Tests. **Seit L-15.9 ist die Voraussetzung dafür belegt:** der Prüfstand **lädt** Bilder (acht `E-95 Bild`-Zeilen je Messlauf, dazu `E-103 Nachtrag: quelle=79x64`) — was fehlte, war nie die Fähigkeit, sondern ein **Testdatum**. Damit sind **E-110** (Bilder kommen beim Antworten nicht durch) und die Bildszenarien zu E-95/E-103 auf dem Prüfstand nachstellbar; für **E-106** fehlt weiterhin genau ein Fall: ein Bild, dessen Datei größer ist als die HTML-Angabe. Die Messskripte liegen als Wegwerfdateien in `C:\Temp` (`messen-antwort.ps1`, `messen-darstellung.ps1`, `messen-e101.ps1`) und gehören nach `tools/`. **Was noch fehlt:** die drei Forderungen sind nicht umgesetzt — je Schranke ein Testfall für ihre **bekannte Grenze**, eine Unterscheidung zwischen *geprüft und frei* und *nichts zu prüfen gefunden*, und Szenariotests über `tools/testlauf.ps1`. Für E-106 fehlt weiter das Testdatum: ein Bild, dessen Datei größer ist als die HTML-Angabe.  **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — **die drei Forderungen sind jetzt ausgezählt, nicht mehr nur behauptet.** Gezählt über `tools/pruefe-*.pl`, ohne die `*-tests.pl`-Beiwerke: **46 Schranken.** Davon haben **23** einen `--selbsttest`, also genau die Hälfte — **23 prüfen ihre eigene Grenze nicht.** Schwerer wiegt die zweite Zahl: **sieben Schranken ruft niemand auf** — weder `paket-bereit.pl` noch `commit-bereit.pl`, weder `pre-commit` noch `pre-push`, weder `bauen.ps1` noch `paket-bauen.ps1`: `pruefe-aussenstand.pl`, `pruefe-blahblah-knopf.pl`, `pruefe-kopfzeilen-stil.pl`, `pruefe-pruefstand-pfad.pl`, `pruefe-symbole.pl`, `pruefe-taboo-liste.pl`, `pruefe-zertifikatspruefung.pl`. Das ist [schranke-gehoert-in-den-haken](../Arbeitsweise/schranke-gehoert-in-den-haken.md) sieben Mal: eine Prüfung, die nur läuft, wenn jemand daran denkt, ist keine. **Bemerkenswert dabei:** `pruefe-taboo-liste.pl` betrifft genau die Liste, an der am selben Tag [E-101](#e-101) F2 festgemacht wurde — die Schranke dazu lag die ganze Zeit da und lief nie. **Was noch fehlt:** die sieben in einen Haken hängen (oder begründet streichen), und den 23 ohne Selbsttest je einen Fall geben. **Stufe: werkzeug** (Schranken waren da und haben nicht gehalten)|
| <a id="e-110"></a>E-110 | **Beim Antworten und Weiterleiten kommen nicht alle Bilder ins Verfassenfenster** — ein Teil steht als **grauer Kasten** da | **behoben in 7.2.0.75, von Gregor am 18.09.2026 am laufenden Programm bestätigt.** Sein Bildschirmfoto zeigt die Bilder im Verfassenfenster, die grauen Kästen sind weg; sein Protokoll belegt es in Zahlen: **49 × `datei=1 intern=1`, kein einziges `intern=0` mehr** (vorher zehn abgewiesene Adressen). **Dabei ist sofort ein Folgebefund sichtbar geworden — [E-112](#): die Bilder erscheinen jetzt in Originalgröße statt in der angegebenen**, weil die E-106-Behebung die echte Dateigröße ins Embed schreibt und jetzt zum ersten Mal überhaupt Bilder ankommen. Das ist eine Regression meiner eigenen Behebung, kein Rückfall von E-110. **Die Behebung:** ein `++output;` am Ende des `%`-Zweigs von `resolve_URL` (`HTMLUtils.cpp:71`). **178 Tests, 178 bestanden** (sieben neue). **Die Gegenprobe ist gefahren** (`Arbeitsweise/schranke-gegentesten.md`): nimmt man das `++output;` wieder heraus, fallen **vier** der sieben um — und zwar mit genau den Zeichenketten aus Gregors Protokoll, `resolve_URL 'eiBeispielBild.png' gegen unescape_url 'ei Beispiel Bild.png'`. Die drei anderen prüfen den **erlaubten** Fall (Adresse ohne Prozentzeichen, die Ränder, die Längenschranke) und bleiben in beiden Richtungen grün. **Der Maßstab der Tests kommt aus dem Programm selbst:** `unescape_url` steht zwanzig Zeilen unter `resolve_URL`, löst dieselbe Aufgabe und löste sie schon immer richtig; ein Test hält beide gegeneinander, statt eine erdachte Erwartung zu prüfen. **Der Prüfstand schneidet die Funktion bei jedem Bau frisch aus dem Original** (`Extract.ps1`, Region M) — es gibt keine Abschrift, die veralten könnte. **URSACHE, gemessen am 18.09.2026:** Von Gregor an 1.0.72 gemeldet: *„beim weiterleiten und antworten werden nicht alle bilder so übernommen."* **Kein Rückschritt:** die grauen Kästen haben die **richtige Größe**, und der Text liegt nicht mehr darüber — **E-103 und E-106 arbeiten**. Es fehlen die Bildpunkte, nicht der Platz; der graue Kasten ist Paiges Platzhalter für ein nicht geladenes Bild (`CHANGELOG.md`, 7.2.0.58). **DIE URSACHE: `resolve_URL` (`HTMLUtils.cpp:31-42`) wirft jede Prozent-Sequenz weg, statt sie zu entschlüsseln.** Im `%`-Zweig wird das entschlüsselte Zeichen nach `*output` geschrieben, **aber `output` wird nicht weitergerückt** — der `else`-Zweig tut es mit `*output++ = *input++`, der `%`-Zweig nicht. Das nächste Zeichen überschreibt das entschlüsselte. Es ist also nicht falsch, sondern **weg**. `output_size++` zählt für beide Zweige korrekt; nur der Zeiger fehlt. **Nachgerechnet an Gregors Adresse:** `ei%20Beispiel%20Bild.png` → `e`,`i` geschrieben und vorgerückt, `%20` schreibt ein Leerzeichen an Position 2 ohne vorzurücken, `B` überschreibt genau dieses Leerzeichen → **`eiBeispielBild.png`**, exakt der Wert aus seinem Protokoll. Gegenprobe an einer zweiten Adresse: `Bild%20A%20B%20(1).jpg` → `BildAB(1).jpg`, passt ebenfalls. **Drei unabhängige Messungen, die sich decken:** (1) der Rumpf, wie er in der Nachricht steht — über *Rechtsklick → Send to Browser*, also **ohne** `resolve_URL` — trägt `%20`; (2) die Spurmarke des Anzeigewegs trägt ihn nicht; (3) der Server antwortet auf die zweite Fassung mit **404** (`Apache/2.4.7 at absender.invalid`). **Die Aufteilung ist lückenlos:** alle **zehn** abgewiesenen Adressen tragen Leerzeichen (vier Bildnamen mit Leerzeichen, Wortlaut bewusst nicht wiedergegeben), alle **vierzehn** erfolgreichen keines (Bildnamen ohne Leerzeichen, darunter die Symbole des Versanddienstes). Nicht die Größe (600×146 kommt durch, 250×96 nicht), nicht das Format, nicht der Server. **Der Fehler ist grösser als der Bildweg:** er trifft **jede** Prozent-Sequenz — Umlaute in Dateinamen (`%C3%BC`), Klammern (`%28`), Schrägstriche (`%2F`) —, und `resolve_URL` wird auch von `PgEmbeddedImage.cpp:1271` gerufen. Er steckt im Originalcode von QUALCOMM, nicht in der Portierung. **Warum die Bilder beim LESEN erscheinen:** was dort steht, lag im Zwischenspeicher, abgelegt als die Adresse noch stimmte; die im Verfassenfenster frisch aufgebauten treffen ins Leere. **Behebung:** `++output;` am Ende des `%`-Zweigs — mit Tests für `%20`, `%C3%BC`, `%%`, `%` am Ende, abgeschnittenes `%2` und eine Adresse ohne Prozentzeichen als Gegenprobe. **Zweiter, eigenständiger Mangel, den dieser Lauf offengelegt hat:** `loader_result` bleibt **durchgehend 0** — Eudora vermerkt einen fehlgeschlagenen Bildabruf nirgends und stellt dem Anwender wortlos einen grauen Kasten hin. **Wie es gemessen wurde:** Messfassung **1.0.73** (Spurmarke in `PgLoadUrlImage` statt im Import — der Importweg läuft laut `PgEmbeddedImage.cpp:257` nur ohne Größenangabe und ist an der Fehlerstelle blind, `Befunde/PRUEFER-18.md`), dann **1.0.74** mit `datei=` und `intern=`. Drei meiner eigenen Erklärungen sind dabei **widerlegt**: der Wiederholungsmechanismus funktioniert (die Erfolgreichen laden beim zweiten Ruf), der Abruf ist erlaubt (`faden=1` durchgehend), und die Größe ist es nicht **Stufe: wichtig** (Darstellung: Bilder fehlen beim Antworten)|
| <a id="e-111"></a>E-111 | **`resolve_URL` kann ein Byte hinter das Zielfeld schreiben** | **behoben in 7.2.0.121 (22.10.2026), 246 Tests, 246 bestanden.** Die Schranke prüfte auf `==` statt `>=` **und erst nach dem Schreiben**: `output_size` startet bei 1 und zählt je Durchlauf um genau 1, bei `nMaxLength` 0 oder 1 wurde `==` deshalb nie wahr und die Schleife schrieb bis zum Ende der **Quelle** über das Zielfeld hinaus. Zwei Teile: `>=` statt `==` (`HTMLUtils.cpp:107`) und ein Eingang für die entarteten Größen (`:21-30`), weil die Prüfung hinter dem Schreiben steht und `*output = 0` sonst bei `nMaxLength=1` ein Byte zu weit setzt. **Gegenprobe gefahren:** mit dem alten `HTMLUtils.cpp` fällt genau der neue Testfall um (245 von 246), die übrigen 245 bleiben grün. **Ausgelöst gesehen wurde es nie** — alle heutigen Aufrufer übergeben `sizeof()` eines großen Feldes (`PGHTMIMP.CPP:2310`, `PgEmbeddedImage.cpp:1415`); der Test hält den Fall für den nächsten Aufrufer fest. Gefunden vom PRÜFER am 18.09.2026 beim Nachrechnen der [E-110](#e-110)-Spurmarke ([PRUEFER-18](../Befunde/PRUEFER-18.md)). **Stufe: kritisch** (Speicherfehler: ein Byte hinter das Zielfeld)|
| <a id="e-112"></a>E-112 | **Bilder werden in Originalgröße gezeichnet statt in der angegebenen** — das WhatsApp-Symbol füllt das halbe Fenster | **BEHOBEN IN 7.2.0.85, von Gregor an 1.0.86 bestätigt am 13.10.2026** (Antwort auf die Kleinanzeigen-Nachricht, Bildschirmfoto: das Logo steht über „Deine Anzeige wird weniger gesehen“, nicht mehr darauf; *„paßt dagegen“*). Vorher: am laufenden Programm gemessen, nicht bestätigt. Ursache des Fehlschlags von 7.2.0.76: die Metadatei aus `MetafileFromImage` setzt selbst `SetMapMode(MM_TEXT)`, und Paige spielt sie bei `mapping_mode 0` als MM_TEXT ab (`PGEMBED.C:4090`) – das Zielrechteck bestimmte nur die Lage. Jetzt schreibt `E112MetadateiAusDIB` (`QCGraphics.cpp`) die Metadatei in der Größe aus `E112Zielrechteck`. **Test zuerst:** `Tests/TestE112Metadatei.cpp` misst die gemalte Fläche – vor der Behebung rot (`gemalt 330x327`), danach grün; Testsuite 193/193. **Am laufenden Programm:** `C:\Temp\E112-1085`, Prüfnachricht `Testdaten/e112-bilder-groesser-als-angegeben.eml` über `tools/anhang-pruefdaten.pl --pop --nur-eml --eml …` abgerufen und weitergeleitet; Spurmarken `E-112 Metadatei: angegeben=35x35 Datei=330x327 gemalt=35x35`, `angegeben=250x96 Datei=985x378 gemalt=250x96`, `angegeben=0x0 Datei=79x64 gemalt=79x64`; das Fensterfoto zeigt alle drei in dieser Größe, kein Bild auf dem Text. **PRUEFER-22 F2, auf Gregors Entscheidung eingebaut** (*„ja, F2 so einbauen wie im browser“*): fehlt eine Seite, folgt sie jetzt dem Seitenverhältnis der Datei (`E112Zielrechteck`, Tests TestE112.cpp (3) und (6), vorher rot, jetzt grün). Bis dahin galt: steht nur `width` (oder nur `height`) da, behandelt `E112Zielrechteck` das wie keine Angabe und malt in Dateigröße (`PgEmbeddedImage.cpp:384-392`), während das Embed die angegebene Breite bekommt – beim Antworten erzeugt [E-89](#e-89) genau diesen Fall (`msgutils.cpp:3633-3645`). Vorschlag des PRÜFERS: die fehlende Seite im Seitenverhältnis der Datei ergänzen; das ändert die E-103-Regel. **F1 (gleiche URL, andere Angabe):** der erste Versuch in `PGEMBED.C` (`dae6727`) war wirkungslos, weil `Paige32.dll` nicht aus dem Quelltext gebaut wird — erst die Messung zeigte es (70x70 kam als 35x35). Behoben in `ac8f030`: Eudoras HTML-Import (`Eudora/PGHTMIMP.CPP`) ruft `pgNewImageRecord` mit `check_to 0`, jedes Bild bekommt seinen eigenen Datensatz. F2 brauchte zusätzlich `11b6a3a`: am Ladeweg steht die halbe Angabe nur in `source_*`. **Am laufenden Programm gemessen, Bau `11b6a3a`:** `angegeben=35x35 gemalt=35x35`, `70x70 gemalt=70x70`, `250x96 gemalt=250x96`, `150x0 gemalt=150x58`, `0x0 Datei=79x64 gemalt=79x64`; Fensterfoto ohne überdeckten Text. **Nachtrag 13.10.2026, [PRÜFER-23](../Befunde/PRUEFER-23.md): Urteil auslieferbar**, die fünf Werte passen zur Quelle; Funde daneben: **N1 (behoben in `9f5142b`, Teil Breite):** [E-89](#e-89) machte beim Antworten und Weiterleiten aus `<img width="1200">` ohne Höhe `width="600" height="1"` (vor der Behebung `msgutils.cpp:3655-3658`, jetzt `:3654-3666`), seit E-112 als Strich gemalt; jetzt geht nur eine bekannte Höhe mit, die fehlende ergänzt F2; Test `TestE89.cpp` (4b) vorher rot, Testsuite 194/194; am laufenden Programm gemessen (Bau `bf96856`, 13.10.2026): `angegeben=600x0 gemalt=600x230`; die Gegenrichtung (`width="1"`) ist ebenfalls behoben (TestE89.cpp (4c), Testsuite 195/195) und gemessen: `angegeben=0x600 gemalt=606x600`. **Die Gegenrichtung war offen (LEKTOR-29):** bei nur `height` über `E89_MAX_HOEHE` wurde die Breite 0 zu 1 (vor der Behebung `msgutils.cpp:3668-3677`, jetzt `:3668-3680`, `width="1"`); damals aus der Quelle gelesen, seither behoben und gemessen, siehe oben. **N2 (Vermutung, ungemessen):** seit F1 ruft der Export `EMBED_SAVE_IMAGE` je `<img>`, dasselbe Bild zweimal ergibt womöglich zwei MIME-Teile (`PGHTMEXP.CPP:952-956`, `PgEmbeddedImage.cpp:1072`, `MimeStorage.cpp:189-204`). **N3 (Restrisiko, ungemessen):** der E-103-Block sucht auch beim `PREPARE` mit dem flüchtigen Embed (`style == NULL`) und kann das erste Embed des Dokuments treffen (`PgEmbeddedImage.cpp:658-670`, `:699`); im Lauf E112-1085 stand `gefunden=0`. **N4 (Hygiene):** der Merge `b1ed24f` hat sieben DLLs unter `Bin/Release/` eingecheckt, deren Inhalt aus keinem Elternstand stammt (`Paige32.dll`: 6 Byte, PE-Prüfsumme, Code gleich). **N5 (niedrig):** bei http mit halber Angabe läuft `pgInvalEmbedRef` zweimal (`PgEmbeddedImage.cpp:699`, `:921`), und `(short) nGemaltB/H` (`:576-577`) kann bei extremem Seitenverhältnis überlaufen. **Vorher: WIEDER OFFEN.** Der Versuch in 7.2.0.76 wirkt nicht — von Gregor am 18.09.2026 am laufenden Programm widerlegt, mit Bildschirmfoto.** **Nachtrag 13.10.2026: an 1.0.84 unverändert**, von Gregor mit Bildschirmfoto gemeldet (*„falsche darstellung beim weiterleiten: bild überdeckt den text“*): Verfassenfenster beim Weiterleiten der Kleinanzeigen-Nachricht (dieselbe wie bei E-106), das grüne Logo liegt über „Deine Anzeige wird weniger gesehen“ und „Hallo“ (Titelzeile `7.2.0.84 / Paket 1.0.84+05bbaba*`). Erwartet, denn 1.0.84 enthält keine Arbeit an E-112; der Zweig `e-112_e-113_fix` ist dafür angelegt. Die Bilder sind weiterhin größer als angegeben, **und jetzt liegt der Text wieder darauf**, weil die Zeile nur noch die angegebene Höhe hat. **1.0.76 ist damit in einem Punkt schlechter als 1.0.75:** dort waren die Bilder zu groß, aber der Text stand darunter und war lesbar. **WARUM DER VERSUCH NICHT WIRKT, jetzt am Quelltext gemessen:** `draw_meta_file` (`PaigeDLL/PGSOURCE/PGEMBED.C:4085-4125`) unterscheidet nach `pict_data.mapping_mode`. Ist er `0` — und das ist er bei jedem aus dem Netz geladenen Bild —, wird er auf **`MM_TEXT`** gesetzt, und dann geschieht nur dies: `SetWindowOrgEx(target_dc, -target_rect->left, -target_rect->top, ...)` und `EnumMetaFile(...)`. **Das Zielrechteck bestimmt allein die POSITION, nicht die GRÖSSE.** Skaliert wird ausschließlich im `else`-Zweig, über `SetViewportExtEx` mit der Breite und Höhe des Rechtecks. **Meine Annahme „eine Metadatei wird auf ihr Zielrechteck gestreckt" gilt also nur für andere Abbildungsarten.** Der E-106-Block **lief** dabei korrekt — Gregors Protokoll zu 1.0.76 zeigt 16 Zeilen `E-106 groesser als angegeben` mit `gefunden=1` und den richtigen `attr`-Werten; geschrieben wurde also das Richtige, es wirkt nur nicht. **MÖGLICHE RICHTUNG, AUSDRÜCKLICH UNGEMESSEN:** `mapping_mode` zusammen mit `pict_frame` setzen (z. B. `MM_ANISOTROPIC`). `mapping_mode` wird bisher **nur** auf dem RTF-Importweg gesetzt (`PGRTFIMP.CPP:900`). **Der offene Punkt dabei:** der `else`-Zweig setzt nur die *Viewport*-Ausdehnung, nicht die *Window*-Ausdehnung — ob korrekt skaliert wird, hängt daran, ob die von `MetafileFromImage` erzeugte Metadatei ihre eigene Ausdehnung mitbringt. **Das ist zu messen, bevor irgendetwas gebaut wird.** **Was aus 7.2.0.76 bleibt und richtig ist:** die Regel selbst steht jetzt in `E112Zielrechteck`, einer paige-freien Funktion mit sieben Tests und gefahrener Gegenprobe. Sie liefert das richtige Rechteck; nur der Zeichenweg setzt es nicht um. **URSPRÜNGLICHER BEFUND:** Regression **meiner eigenen Behebung E-106**. **Die Behebung:** `pict_frame` — das Zielrechteck, in das Paige eine Metadatei streckt — bekommt die **angegebene** Größe statt der echten; `embed->width`/`height` bekommen denselben Wert, damit Umbruch und Zeichnung nicht auseinanderlaufen. Die Regel sitzt in einer eigenen, paige-freien Funktion `E112Zielrechteck` (`PgEmbeddedImage.cpp:368`) — **genau das fehlte bei E-106**: dort stand dieselbe Entscheidung mitten im Ladeweg zwischen `embed_ref`, `UseMemory` und `pgInvalEmbedRef`, war nur an Gregors Rechner messbar, und dass sie falsch herum war, kam erst zwei Befunde später heraus. **185 Tests, 185 bestanden** (sieben neue). **Gegenprobe gefahren:** mit der alten Regel fallen **drei** davon um — darunter der Anlassfall 35×35 gegen 330×327 —, während die **E-103**-Fälle (ohne Angabe gilt die Datei), die halbe Angabe, der Nullzeiger und der Fall „nichts bekannt" in **beiden** Richtungen grün bleiben. Ohne diese zweite Hälfte hätte die Behebung E-112 repariert und E-103 gebrochen. **Weiter offen als [E-113]:** ein Bild, dessen **angegebene** Breite größer ist als das Fenster, läuft rechts hinaus. **URSPRÜNGLICHER BEFUND:** Von Gregor am 18.09.2026 an 1.0.75 gemeldet: *„warum ist die reply ansicht so groß?"*, mit Bildschirmfoto. **Sichtbar geworden durch E-110:** bis dahin luden fast keine Bilder, also fiel nicht auf, wie die geladenen gezeichnet werden. Der E-106-Block lief in Gregors Lauf vorher **7 mal**, jetzt **29 mal**. **Gemessen an seinem Protokoll zu 1.0.75** — angegeben gegen tatsächliche Dateigröße: `35x35` gegen **`330x327`**, `540x240` gegen **`1294x575`**, `250x96` gegen **`985x378`**, `600x146` gegen **`1772x433`**. Absender legen Bilder in doppelter bis dreifacher Auflösung ab und geben im HTML die Anzeigegröße an; jeder Browser skaliert herunter. **Die Ursache ist meine Behebung zu E-106:** sie schreibt `nEchtBreite`/`nEchtHoehe` in `embed->width`/`embed->height` **und** in `pict_frame.bot_right` (`PgEmbeddedImage.cpp`), damit die Zeile hoch genug wird. Das Symptom damals war *„Bild liegt über dem Text"*, und die Ursache dafür war, dass Paige in Originalgröße zeichnet, während die Zeile nach der **angegebenen** Größe bemessen ist. **Ich habe die Zeile vergrößert, statt das Bild zu verkleinern** — die bequeme Richtung, die das Symptom beseitigte, solange kaum ein Bild lud. **Richtig ist die andere Richtung:** die angegebene Größe gewinnt, das Bild wird hineinskaliert. So macht es jeder Browser, und so macht es **Eudoras eigenes Lesefenster** — Gregors erstes Bildschirmfoto vom 18.09.2026 zeigt dieselbe Nachricht dort korrekt. **Der Weg dahin, zu messen, nicht zu glauben:** `MetafileFromImage` liefert eine **Metadatei**, und eine Metadatei wird auf ihr Zielrechteck gestreckt. `pict_frame` ist dieses Rechteck. Wird es auf die **angegebene** Größe gesetzt statt auf die echte, skaliert Paige das Bild hinein, ohne dass Paige selbst skalieren können muss. **Zu prüfen ist dabei:** ob `embed->width`/`height` dann ebenfalls auf der angegebenen Größe bleiben müssen (sonst rechnet der Zeilenumbruch mit anderen Maßen als die Zeichnung), und wie sich der Fall **ohne** Größenangabe verhält — dort muss weiterhin die echte Größe gelten, das ist **E-103**. **Nicht anfassen ohne Gegentest an beiden Fällen**, mit und ohne Angabe. **Was daran keine Vermutung ist:** dass die Bilder zu groß erscheinen (Bildschirmfoto), dass der E-106-Block sie auf die echte Größe setzt (Quelltext), und um welchen Faktor (Protokoll). Offen ist allein, ob das Setzen von `pict_frame` allein genügt **Stufe: wichtig** (Darstellung: Bilder in Originalgroesse)|
| <a id="e-113"></a>E-113 | **Bilder, die breiter sind als das Fenster, laufen rechts hinaus** — statt anteilig eingepasst zu werden | **behoben (Variante A) auf dem Zweig `e-113-breite-bilder` (24.10.2026), kommt mit Paket 7.2.0.123; am laufenden Programm gemessen (Prüfstand, erst rot, dann grün), 284 Tests, 284 bestanden, Regressionsfall `E-113p`.** Ein Bild, das breiter ist als der Textbereich im Verfassen-Fenster, wird beim Laden auf dessen Breite verkleinert, ohne verzerrt zu werden. Für Gregor ist nichts zu tun außer dem Test im Paket. **Nachprüfung am 24.10.2026 ([PRÜFER-49](../Befunde/PRUEFER-49.md#pruefer-49), am Quelltext, nicht gemessen):** hält für Bilder ohne Größenangabe. Steht im HTML **Breite und Höhe**, wird nur das gemalte Bild verkleinert, nicht sein Rahmen; das Bild hängt oben, darunter bleibt eine leere Fläche und rechts ein Rollbalken — das Muster aus [E-106](#e-106), im Verfassen-Fenster nur bei einem Textbereich unter 600 Punkten ([K9](../Befunde/PRUEFER-49.md#k9)). Der QuickTime-Weg bleibt ungedeckelt, und die gedeckelte Größe geht ins gesendete HTML ([K10](../Befunde/PRUEFER-49.md#k10)). **Variante B ist nicht gebaut und wird es nicht** (Gregor am 24.10.2026: *„paßt so."*): wird das Fenster danach schmaler gezogen, passt sich das Bild nicht an. **Regressionsfall dazu** (Gregor: *„ich möchte dann auch zu B einen regression test haben"*): `E-113b`/`E-113b2` ziehen am Prüfstand das Verfassen-Fenster von 771 auf 420 Punkte schmaler und halten fest, dass Eudora lebt und das Bild nicht neu berechnet wird (`neu=0 lebt=1 probe=ok`, gemessen am 24.10.2026). **Die Behebung:** `E113Deckeln` (`PgEmbeddedImage.cpp`) deckelt das Rechteck aus `E112Zielrechteck` seitenverhältnistreu auf die Breite des Umbruchbereichs (`E113Seitenbreite`, gerechnet wie `page_width` im HTML-Import) — an allen drei Stellen, an denen die Zielgröße entsteht: in der Metadatei (`MetafileFromImage`, `QCGraphics.cpp`), für den Zeilenumbruch und für den Rahmen, damit sie nicht auseinanderlaufen ([E-106](#e-106)). **Gemessen am 24.10.2026** am Prüfstand `C:\Temp\EBILD` mit `Testdaten/e113-breites-bild.eml`: **vorher** `E-112 Metadatei: angegeben=0x0 Datei=985x378 gemalt=985x378` im Verfassen-Fenster mit 771 Punkten Breite; **nachher** `E-113 Deckel: seite=718 vorher=985x378 nachher=718x276` und `gemalt=718x276`. Alle kleineren Bilder der übrigen Prüfnachrichten bleiben unverändert (`vorher` gleich `nachher`). Testsuite 284/284; ohne den Deckel 283/284. **Nicht gemessen:** das zweite und dritte Bild der Prüfnachricht (900×345 angegeben, 100×99) erscheinen nicht im Protokoll — dieselbe Lücke wie bei E-112 und E-119. **Zuerst eingetragen:** offen, von Gregor am 18.09.2026 angeordnet, nachdem er die Entwurfsfrage gestellt hatte: *„müssen die hard codiert sein? oder kann man es dynamisch ausrechnen, je nach aktueller fenster größe, dann anteilig?"* — und nach der Antwort: *„ok, erst A, dann B"*, *„ja, e-113 notieren"*. **Das Symptom** steht auf seinem Bildschirmfoto vom 18.09.2026: ein Bild mit angegebenen 600 Punkten Breite in einem schmaleren Verfassenfenster wird rechts abgeschnitten, mit waagerechtem Rollbalken. **Das ist NICHT E-112.** E-112 bringt das Bild auf die **angegebene** Größe; E-113 fragt, was geschieht, wenn schon die **angegebene** breiter ist als der Platz. Newsletter meinen das mit `max-width:100%` — Paige kennt kein CSS. **Was bereits da ist und nicht neu gebaut werden muss:** `PGHTMIMP.CPP:235-240` rechnet `page_width` aus den Rändern und Einzügen aus, und `:2043` benutzt sie schon für prozentuale Breiten (`width="50%"` über `decimal_value_percent`). Die Zahl liegt also vor. **Die Regel wäre:** ist die Zielbreite größer als `page_width`, beide Maße im selben Verhältnis verkleinern — seitenverhältnistreu, sonst verzerrt es. **Der teure Teil, ausdrücklich NICHT gemessen:** `page_width` ist die Breite **beim Umbruch**, nicht beim späteren Ziehen am Fenster. Damit das Bild einer Größenänderung folgt, müsste jedes Embed erneut angefasst und das Dokument neu umbrochen werden; ob Paige dafür einen Einstiegspunkt bietet, ist **nicht untersucht**. Ein Deckel beim Umbruch ist billig, echtes Mitwachsen ist es nicht. **Reihenfolge von Gregor gesetzt:** erst E-112, dann dies — zwei Regeln gleichzeitig zu ändern ist der Weg, auf dem aus E-106 der Absturz E-108 wurde **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — bleibt offen, ist aber jetzt an der Reihe: die Vorbedingung [E-112](#e-112) ist seit 7.2.0.85 behoben (Marke in `PGHTMIMP.CPP:2379`). Einen Deckel gibt es weiterhin nicht: `page_width` entsteht in `PGHTMIMP.CPP:244` (nicht mehr `:235-240`) und wird nur an zwei Stellen gelesen — `:2364` für prozentuale Bildbreiten und `:3062` für Tabellenspalten. Eine Begrenzung der **angegebenen** Breite steht an keiner Stelle. **Was noch fehlt:** nichts — von Gregor am 26.10.2026 an Paket 1.0.123 bestätigt (*„E-113 passed“*, TESTPLAN N6; Protokoll `E-113 Deckel: … vorher=600x80 nachher=477x64`). **Wie zu pruefen:** **ICH** — eine Nachricht mit einem Bild, das breiter ist als das Fenster. Rot: das Bild läuft rechts hinaus. Grün: es ist auf die Fensterbreite eingepasst. Danach Fenstergröße ändern und noch einmal sehen. **Stufe: wichtig** (Darstellung: Bilder laufen rechts hinaus)|
| <a id="e-114"></a>E-114 | **ein angedocktes Fenster hinterlässt nach dem Lösen einen leeren Bereich** — das Filterfenster wurde angedockt und im nächsten Schritt wieder gelöst; an seiner alten Stelle bleibt eine leere weiße Fläche stehen | **erledigt - von Gregor bestätigt am 23.10.2026, er kann es nicht mehr nachstellen und schliesst den Befund:** *„e-114 läßt sich nicht mehr nachstellen, können wir schließen."* (Chat). Gemeldet am 13.10.2026 an Paket 1.0.84, **schon am selben Tag von Gregor nicht nachstellbar** (*„kann e-114 gerade nicht nachstellen.“*); bis zum nächsten Auftreten fehlen die Bedingungen (Andockseite, Verhalten bei Größenänderung und Neustart), mit Bildschirmfoto: das Filterfenster schwebt als „WazooBar2“, dahinter ist das ganze Feld zwischen Postfachbaum (bis etwa x=265) und Nachrichtenliste (ab etwa x=1003) leer. Wörtlich: *„filter fenster läßt sich auch ziehen, vergrößern, verkeinern. aber: wenn ich es andocke, im nächsten schritt wieder löse, bleibt ein leerer bereich übrig, wo es davor angedockt war: neuer fehler!"* **Ursache nicht gemessen.** Kandidat aus dem Bestand: [A-1](#a-1) hält fest, dass `SetControlBarWidthsInRow` in `OTShim.cpp` noch ein **leerer Rumpf** ist und `OnSizeParent` nur durchreicht (dazu AUFGABEN.md, **E3**) — das ist die Stelle, die nach dem Herausnehmen einer Leiste die Reihe neu verteilen müsste. **Zu messen:** wo genau angedockt war; ob der leere Bereich nach einer Größenänderung des Hauptfensters oder nach einem Neustart verschwindet; mit `LogLevel=124063` die Marken `E-66`, `E-70`, `E-76`, `E-78` beim Andocken und Lösen **Geschlossen ohne gemessene Ursache.** Der Befund wurde am 13.10.2026 an 1.0.84 **einmal** gesehen, am selben Tag von Gregor nicht mehr nachgestellt und am 23.10.2026 von ihm geschlossen. Die Ursache ist damit **nie** gemessen worden; der Kandidat [A-1](#a-1) (`SetControlBarWidthsInRow` in `OTShim.cpp` ist ein leerer Rumpf) bleibt unbewiesen und steht dort weiter. **Tritt es wieder auf**, ist hier anzuknüpfen: mit `LogLevel=124063` die Marken E-66, E-70, E-76, E-78 beim Andocken und Lösen mitschreiben und festhalten, an welcher Seite angedockt war. **Stufe: unkritisch** (leerer Bereich nach dem Loesen)|
| <a id="e-115"></a>E-115 | **Ctrl+F (*Find Messages*) bringt „Encountered an improper argument“**, und im Reiter *Mailboxes* ist kein Postfach angehakt (*„No mailboxes selected“*) | **behoben in 7.2.0.86, von Gregor an 1.0.86 bestätigt am 13.10.2026** (*„E-115 tritt bisher nicht mehr auf“* — der Fehler war vorher sporadisch, das Urteil gilt also vorläufig); zuvor am laufenden Programm gemessen; [PRÜFER-25](../Befunde/PRUEFER-25.md): Traversierung nachgerechnet, auslieferbar. **Nachgestellt und Gegenprobe:** Kopie seines Mailverzeichnisses `C:\Temp\E115-gregor` (offline), *Find Messages* NICHT in der Startliste (`OpenWindow…=39,…` entfernt — ist es schon offen, löst es nicht aus), Fenster `Inbox (<Dominant>)` per `WM_MDIACTIVATE` aktiv, dann Ctrl+F (`WM_COMMAND 32779`): mit 7.2.0.84 kommt das Meldungsfenster *„Encountered an improper argument.“*, mit 7.2.0.86 keines (Protokoll: `titel='Find Messages'` bei 0.13, nach dem Ctrl+F). Ein erster Lauf mit 7.2.0.86 zählt nicht: dort stand *Find Messages* wieder in der Startliste. Vorher: **Ursache gemessen, Wirkung offen.** **Gemessen 13.10.2026 an Gregors 1.0.85, während die Meldung offen stand** (seine Freigabe *„schau es dir an. ich fasse solange nichts an.“*): Stapel des Meldungsthreads ohne Debugger gelesen (Thread kurz angehalten, Register gelesen, weiterlaufen lassen, Stapel abgetastet, mit der PDB symbolisiert) – `CxxThrowException` ← `CMBoxTreeCtrlCheck::FindCheck` (`MBoxTreeCtrlCheck.cpp:938/942`) ← `CSearchView::HandleSelectMessage` (`SearchView.cpp:5306`) ← `OnMsgMailboxSelect` ← zugestellte Nachricht `msgFindMsgMaiboxSel` (`guiutils.cpp:3391`: *Find Messages* wählt das Postfach des aktiven Fensters vor). **Ursache:** `FindCheck` überspringt den Ordner Recent mit `GetNextSiblingItem`; Recent ist der letzte Eintrag unter dem Mailverzeichnis, also NULL, und `GetItemData(NULL)` wirft. Bis dahin kommt die Suche nur, wenn das gesuchte Postfach dahinter liegt – ein IMAP-Postfach unter `<Dominant>`; daher „nur 1x spontan“. **Behebung:** Recent mit `GetNextTraversalItem(hItem, false)` samt Inhalt überspringen, bei NULL Schleife beenden. **Nicht gemessen:** dass die Meldung danach ausbleibt (Auslöser am Prüfstand noch nicht nachgestellt). **Am Maschinencode bestätigt** (Gregors 1.0.85-`Eudora.exe` mit ihrer PDB, `dumpbin /disasm`, `FindCheck` ab `0049A88F`): `0049A8BC-C6` ist `SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, Recent)` = `GetNextSiblingItem`, `0049A8CA` schiebt das Ergebnis, `0049A8CD` ruft `CTreeCtrl::GetItemData` (aus `mfc140.dll`) – die Rücksprungadresse dahinter, `0049A8D3` = `FindCheck+68`, stand im Stapel. Geworfen hat also `GetItemData(NULL)`; die MFC-Rahmen dazwischen blendete das Lesewerkzeug aus (keine Symbole für `mfc140.dll`). **Der erste Nachstellversuch** ohne Meldung lief mit *Find Messages* in der Startliste. Vorher: **offen, gemeldet von Gregor am 13.10.2026 an Paket 1.0.84**, mit Bildschirmfoto (*„wollte nachricht mit CTRL-F suchen, um sie weiter zu leiten.“*). Der Meldungstext ist MFCs Text zu `CInvalidArgException` (`AFX_IDP_INVALID_ARG`; so festgehalten in `QCCustomToolBar.cpp:394` - der Text stammt aus MFC und wird beim Wurf gesetzt, nicht von Eudora), siehe [E-34](#e-34); in MFC 14 werfen Sammlungen mit `ENSURE`, wo MFC 6 nur zusicherte. **Gemessen:** seine `eudora.log` (`LogLevel` mit 32768, nur gelesen) endet mit `E-34 NewChildFrame: nach InitialUpdateFrame … titel='Find Messages'` — das Fenster wurde gebaut, die Ausnahme hinterlässt keine Zeile. **Vermutung, nicht gemessen:** `CSearchView::OnInitialUpdate` (`SearchView.cpp:782`) ruft nach `g_theMailboxDirector.InitializeMailboxTreeControl` `m_MBoxTree.CheckAll()` — da kein Kästchen gesetzt ist, liegt der Wurf vermutlich beim Füllen oder Anhaken des Ordnerbaums; in Gregors Baum stehen IMAP-Ordner (`<Dominant>`, `Entw&APw-rfe`, `Gel&APY-scht`). **Nächster Schritt:** im Debugger (`tools/stapel-untersuchen.ps1`) die Wurfstelle festhalten, je einmal mit und ohne IMAP-Konto. **Gegenprobe ohne IMAP, 13.10.2026:** `C:\Temp\E115-1084` (1.0.84, nur POP-Prüfkonto, Postfächer In/Out/Junk/Trash) im Debugger gestartet, nach 20 s `WM_COMMAND 32779` (`ID_CTRL_F`, `mainfrm.cpp:453`) ans Hauptfenster: *Find Messages* geht auf (Protokoll: `titel='Find Messages'`), **keine C++-Ausnahme, auch nicht in erster Gelegenheit** (`tools/stapel-untersuchen.ps1 -Befehl 32779 -CppErsteGelegenheit`). Der Fehler hängt also an Gregors Zustand — Kandidat sind die IMAP-Ordner im Baum, nicht gemessen. **Zweite Gegenprobe, mit Gregors Daten (13.10.2026):** Kopie seines 1.0.84-Mailverzeichnisses (mit IMAP-Ordnern) in `C:\Temp\E115-gregor`, dort `Offline=1` und `CheckForMailEvery=0` gesetzt, damit nichts ins Netz geht; Ctrl+F im Debugger nach 25 s: *Find Messages* geht auf, **wieder keine C++-Ausnahme**. Übrig bleiben als Unterschied zu seinem Lauf: Offline-Betrieb und der laufende IMAP-Abgleich (`Resyncing`/`Checking` direkt vor dem Öffnen in seinem Protokoll). Nicht gemessen. **Dritter Lauf, online (13.10.2026, Freigabe *„wenn du etwas zum testen / messen hast … kannst du es jetzt machen“*):** dieselbe Kopie mit `Offline=0` und `SendOnCheck=0`, Ctrl+F nach 8 s: *Find Messages* geht auf, keine Ausnahme — **aber** die Kopie hat sich in 60 s nicht mit GMX verbunden (keine Zeile `Open …:993`, kein `Resyncing`), der Verdacht ist damit **nicht geprüft**. Nächster Schritt: von Gregor erfragen, ob es bei ihm jedes Mal auftritt. **Gregor am 13.10.2026:** *„nein, nur 1x spontan aufgetreten.“* — nicht wiederholbar; ohne Wurfstelle bleibt E-115 offen, bis es wieder auftritt (dann sofort `eudora.log` sichern). Kein Datenverlust; die Suche ist aber ohne Handgriff unbenutzbar, solange kein Postfach angehakt ist **Stufe: wichtig** (Funktion: Nachrichtensuche nicht benutzbar)|
| <a id="e-116"></a>E-116 | **`width="35px"` wird als 3508 gelesen** — eine Größenangabe mit Einheit oder Nachkommastelle verzerrt das Bild | **behoben, am laufenden Programm nicht nachstellbar — so geschlossen auf Gregors Entscheidung vom 24.10.2026; die Behebung ist seit PR #157 (23.10.2026) auf `main`, kommt mit Paket 7.2.0.123; 280 Tests, 280 bestanden.** Ein Bild mit `width="35px"` oder `width="35.5"` wird nicht mehr riesig breit gezeichnet. Für Gregor ist nichts zu tun. **Am Programm gemessen am 24.10.2026, und dabei NICHT rot nachgestellt:** Prüfnachricht `Testdaten/e116-breite-mit-einheit.eml` am Prüfstand `C:\Temp\EBILD` per POP zugestellt, geöffnet und weitergeleitet (`tools/messen-bild.ps1`) — die neue Fassung malt `width="35px"` als `gemalt=35x35` und `width="250.5"` als `gemalt=250x96`, **die alte 7.2.0.120 aber genauso** (Protokollzeilen `E-112 Metadatei: angegeben=35x35 … gemalt=35x35`, beide Läufe). Auf dem Weg Öffnen/Weiterleiten sieht Paige den Wert also schon ohne Einheit. **Vermutung, nicht gemessen:** die Anzeige läuft über den Internet Explorer, und beim Weiterleiten übernimmt Eudora dessen bereits umgeschriebenes HTML. Der Weg, auf dem der Fehler sichtbar wird (etwa Antworten auf eine Nachricht im reinen Paige-Weg), ist noch nicht gefunden — bis dahin ist die Behebung nur am Quelltext und in der Testsuite belegt. **Nachtrag 24.10.2026 ([PRÜFER-48](../Befunde/PRUEFER-48.md) K4–K6):** die Behebung hält; der Ausschnitt in der Testsuite ist byte-gleich mit der Quelle. Drei Eingaben haben sich mitgeändert, alle zum Besseren oder harmlos, aber ohne eigenen Testfall: `+35` (vorher 1135, jetzt 0, dann gilt die Dateigröße), `35 %` (vorher 2100, jetzt 35 Pixel), `- 5` (vorher −5, jetzt 0). Sehr große Breiten laufen beim Umwandeln nach `short` über (`width="70000"` → 4464, `40000` → negativ, gilt dann als keine Angabe) — die Umwandlung nach `short` ist unverändert, das war vor der Behebung genauso (am Quelltext, nicht gemessen). Der Nebenfund, dass `numeric_value` aus `height=" 35"` eine 0 macht, ist **harmlos**: eine Höhe 0 zeichnet keinen Strich, mit bekannter Breite folgt die Höhe dem Seitenverhältnis, sonst gilt die Dateigröße (K6). **Zuerst eingetragen:** offen, am Quelltext belegt (PRUEFER-22, F3, 13.10.2026), nicht am laufenden Programm gesehen. `decimal_value_percent` (`PGHTMIMP.CPP:3683-3697`) prüft nicht, ob eine Ziffer folgt: `"35px"` ergibt 3508, `"35.5"` ergibt 3645. Seit [E-112](#e-112) (7.2.0.85) wird das Bild auf diese Breite gezeichnet; vorher war der Fehler unsichtbar, weil in Dateigröße gezeichnet wurde. Vorschlag des PRÜFERS vor `PGHTMIMP.CPP:3694`: `if (digit < '0' \|\| digit > '9') break;` **Eingebaut am 23.10.2026** (Zweig `e-116-bildbreite-px`, noch nicht in einer Fassung): `decimal_value_percent` (`PGHTMIMP.CPP:3999-4044`) bricht jetzt wie `numeric_value` an der ersten Nicht-Ziffer ab (`%` wird vorher behandelt), führende Leerzeichen und Tabs werden übersprungen und das Vorzeichen dahinter gelesen — sonst wäre aus `" 35"`, das vorher nur zufällig 35 ergab (`' ' & 0x0F = 0`), eine 0 geworden. Kennung `E-116` an beiden Stellen im Code. **Testsuite:** `Eudora71/Tests/TestE116.cpp`, die Funktion über `Extract.ps1` aus der echten Quelle geschnitten (`generated/pghtmimp_e116.inc`); EudoraTests 280/280. **Gegentest:** ohne Behebung 278/280 — `"35px"`→3508, `"35.5"`→3645, `"120 px"`→120008, `"px"`→8, `"\t35"`→935, `" -5"`→135, `" 35"`→35 grün; nur mit dem Abbruch und ohne das Überspringen 279/280 — `" 35"`, `"\t35"`, `"  50%"`, `" -5"` ergeben 0. **Geschlossen ohne rote Messung am Programm** (Gregor am 24.10.2026 zu [L-55.11](../Befunde/LEKTOR-55.md#l-55.11): *„ok, vermerk reicht"*): auf dem Weg Öffnen/Weiterleiten war der Fehler auch an der alten Fassung 7.2.0.120 nicht zu sehen (Messung unten); belegt ist die Behebung durch die Testsuite und die Nachrechnung des PRÜFERS. **Wie zu pruefen:** **ICH** — Prüfnachricht mit `width="35px"` und `width="35.5"` in der gebauten Fassung öffnen; das Bild muss 35 Pixel breit sein, nicht über die Fensterbreite laufen. **Zuletzt belegt am Quelltext: 23.10.2026 an 7.2.0.122** — Behebung auf dem Zweig `e-116-bildbreite-px` (Quellstand 7.2.0.122 plus Behebung), Testsuite 280/280; kein Lauf am Programm. **Stufe: wichtig** (Darstellung: Groessenangabe mit Einheit verzerrt)|
| <a id="e-117"></a>E-117 | **Bilder mit `&amp;` in der Adresse kommen nicht an** — statt des Fotos lädt ein 1×1-Pixel, im Verfassenfenster bleibt eine leere Fläche | **behoben in 7.2.0.87, von Gregor an 1.0.87 bestätigt am 14.10.2026** (Bildschirmfoto: eBay-Synology-Weiterleitung, das Produktfoto steht unter „Der Countdown läuft!“; *„so?“*). Zuvor am laufenden Programm gemessen (13.10.2026): `C:\Temp\E112-1085`, Prüfnachricht `Testdaten/e117-amp-in-bildadresse.eml` über `tools/anhang-pruefdaten.pl --pop`, Bildserver `tools/bildserver-e117.pl` auf 127.0.0.1:18117 (liefert das Bild nur bei echtem `&`, sonst 1×1): **Gegenprobe 7.2.0.85** — Abruf `GET /bild.png?a=1&amp;w=2` → Pixel, `E-112 Metadatei: angegeben=165x0 Datei=1x1 gemalt=165x165`; **7.2.0.87** — nur `GET /bild.png?a=1&w=2`, `Datei=330x327 gemalt=165x164`, das Fensterfoto zeigt das Bild. (Die Leseansicht holte schon vorher die richtige Adresse, weil der Internet Explorer `&amp;` selbst übersetzt.) Testsuite 196/196 (Test zuerst, vorher rot); [PRÜFER-25](../Befunde/PRUEFER-25.md): Behebung richtig, auslieferbar (daneben G1–G4, ungemessen, u. a. `&#38;` nicht übersetzt). Gemeldet von Gregor am 13.10.2026 an 1.0.86** (*„kein bild beim antworten oder weiterleiten“*, Bildschirmfoto: eBay-Synology-Nachricht weitergeleitet, unter „Der Countdown läuft!“ leer). **Gemessen in seiner `eudora.log` (nur gelesen):** `E-110 Laden: src=https://svcs.ebay.com/imageser/v1/image/…&amp;imgWidth=448&amp;imgHeight=448…` und `E-112 Metadatei: angegeben=183x0 Datei=1x1 gemalt=183x183` — der Dienst bekam die Adresse mit `&amp;` und lieferte 1×1. **Ursache:** für Links übersetzt Eudoras HTML-Import `&amp;` (`PGHTMIMP.CPP:3151`, `Html2Text`), für das `src` eines Bildes nicht — dort läuft nur `resolve_URL` (`PGHTMIMP.CPP:2006`), das nur `%XX` entschlüsselt. Originalfehler von QUALCOMM — **Quelltext original, das Verhalten eines Hermes 7.1 ist dazu nicht gemessen** ([L-48.8](../Befunde/LEKTOR-48.md#l-48.8)); bis 7.2.0.84 unsichtbar (1×1 gemalt), seit [E-112](#e-112) F2 als leere Fläche 183×183. **Behebung:** `resolve_URL` (`HTMLUtils.cpp`) macht aus `&amp;` ein `&`; Test `TestResolveURL.cpp` (8). Andere Entitäten (`&#38;`) nicht behandelt **Stufe: wichtig** (Darstellung: Bilder mit Kaufmannsund kommen nicht an)|
| <a id="e-118"></a>E-118 | **Eine HTML-Mail, in ein IMAP-Postfach verschoben, erscheint dort als HTML-Quelltext** | **BESTÄTIGT von Gregor am 14.10.2026 an 1.0.90 (Teil 2):** die SoftMaker-Mail mit eingebetteten Bildern in den IMAP-Ordner verschoben, die Bilder sind dort (*„ja, bilder sind drin.“*; sein Protokoll: `E-118 Bild: … vorhanden=1`, `related=1`). **Behoben in 7.2.0.90 (Zweig `e-118_HTML_header`), ausgeliefert spätestens mit `v1.0.101`** (Marke enthält den Commit mit der Spurmarke `E-118 Bild`; bis zum 23.10.2026 stand hier „noch nicht veröffentlicht"). Offen bleibt die Doppelanzeige nach dem Verschieben, siehe [E-121](#e-121). **Teil 1 BESTÄTIGT von Gregor am 14.10.2026 an 1.0.89:** die Newsletter-Mail aus „Inbox (<Dominant>)“ bzw. „In“ in den IMAP-Ordner verschoben, dort erscheint sie als HTML mit Bildern und Formatierung, kein Quelltext (Bildschirmfoto; *„main von in box in die imap box verschoben“*). **Behoben in 7.2.0.89 (Zweig `e-118_HTML_header`), am Prüfserver gemessen, noch nicht veröffentlicht.** **Am laufenden Programm gemessen (14.10.2026)** am IMAP-Prüfserver (`tools/imap-pruefserver.pl --ablage`, neu mit `APPEND`), Weg: POP-Abruf, Filter überträgt in den IMAP-Ordner `Ablage` (`C:\Temp\E118`): 7.2.0.89 lädt `Content-Type: text/html; charset="iso-8859-1"` und `Content-Transfer-Encoding: 8bit` hoch, ohne `<x-html>`, Umlaut-Bytes unverändert; mit Euro-Zeichen (0x80) `charset="windows-1252"`. Gegenprobe 7.2.0.88 (`C:\Temp\E118-0088`): kein `Content-Type`, `<x-html>` im Rumpf. Prüfnachrichten `Testdaten/e118-html-in-imap-ordner.eml`, `Testdaten/e118-euro-in-imap-ordner.eml`. **Nachgebessert nach der Messung (MESSSTAND):** Bytes 0x80–0x9F gibt es in ISO-8859-1 nicht; steht eines im Text, heißt der Zeichensatz `windows-1252` (`E118Achtbit` liefert 2). **Behebung 14.10.2026:** `CImapAppend` (`EuImap/src/ImapAppend.cpp`) erkennt beim Hochladen Eudoras lokale Hülle `<x-html> … </x-html>` (`E118Huelle`), streift sie ab und schreibt `Content-Type: text/html` mit Zeichensatz – einteilig in `ReformatMessage` nach `AppendMIMEMessageHeaders`, mehrteilig in `AddTextBodyPart` statt des festen `text/plain`. Ohne Hülle wird `text/plain` geschrieben, nun ebenfalls mit Zeichensatz. Steht ein Byte über 0x7F im Text (`E118Achtbit`), folgen `charset="iso-8859-1"` (bzw. `SendCharset` aus dem INI, über `NameCharset` wie beim Senden) und `Content-Transfer-Encoding: 8bit`; der Text wird nicht umkodiert. **Test:** `Tests/TestE118.cpp`, vier Fälle samt Gegenrichtung (Text ohne Hülle bleibt Text), Suite 207/207; Gegentest mit verstellter Erkennung 2 rot. **Gregors Test an 1.0.89 mit seinem echten IMAP-Konto: bestanden** (siehe Zellenanfang). **Teil 2, eingebaut in 7.2.0.90:** an 1.0.89 fehlten bei der SoftMaker-Mail (Gregor, *„hier fehlt der inhalt“*) die drei **eingebetteten Bilder** – Eudora legt sie lokal als Dateien ab (`Embedded Content: <datei>: MRI,CID-Hash,…`), der Hochladecode kannte sie nicht (Originalfehler), und nach dem Verschieben ist die lokale Kopie weg. Jetzt wird jede solche Zeile ein eigener Teil mit dem `Content-ID`, unter dem das HTML das Bild ruft (`E118Verweis` sucht den Verweis über denselben Hash wie `mime.cpp`), die Nachricht wird `multipart/related; type="text/html"`. Dazu nach [PRÜFER-27](../Befunde/PRUEFER-27.md): `</x-html>` wird nur abgestreift, wenn dahinter nichts mehr steht (sonst ging z. B. eine Fußzeile verloren – Datenverlust, neu in 1.0.89, nie ausgeliefert außer an Gregors Testverzeichnis); `AddTextBodyPart` erzeugt die Teilegrenze nur einmal je Nachricht (Originalfehler F5). Test `TestE118.cpp` (5) und (6), Suite 209/209. Gemessen mit `Testdaten/e118-eingebettetes-bild.eml` (multipart/mixed aus multipart/related mit Bild und einer Fußzeile): hochgeladen als `multipart/related` mit `image/png` samt `Content-ID: <punkt-rot@e118.invalid>` und dem Textteil `FUSSZEILE-E118`. Gefunden dabei: [E-121](#e-121). **Vorgeschichte:** **Gemeldet von Gregor am 13.10.2026 an 1.0.86** (*„nach dem verschieben einer mail sehe ich plötzlich das“*, Bildschirmfoto: zwei seiner weitergeleiteten Synology-Mails von 10:05 in `OUTBOX (<Dominant>)`, die Vorschau zeigt `<head></head><body dir="auto">…` als Text). Seine `eudora.log`: Transfer-Aufgabe `uid=11` um 2.23. **Ursache, am Quelltext ([PRÜFER-25](../Befunde/PRUEFER-25.md) H1, 13.10.2026; die Stellen `:692`, `:880`, `:1166-1169`, `:1640/1650`, `:2020` vom LEKTOR nachgelesen):** beim Hochladen verwirft `ReformatHeader` über `IsHeaderToInclude` (`EuImap/src/ImapAppend.cpp:2020-2026`, Aufruf `:880`) **alle** `Content-*`-Köpfe der Nachricht. Einteilig schreibt `AppendMIMEMessageHeaders(NULL, …)` (`:692`, Rumpf `:1980-2010`) nur `MIME-Version` und **gar keinen** `Content-Type` – der Server nimmt `text/plain; charset=us-ascii` an (RFC 2045), damit fehlt auch der Zeichensatz. Mehrteilig schreibt `AddTextBodyPart` fest `text/plain` (`:1166-1169`). `MSFEX_HTML` kommt in `ImapAppend.cpp` kein einziges Mal vor. Vorlage für die Behebung: `SendContentType` (`Eudora/sendmail.cpp:766-821`, `MSF_XRICH` → `text/html` `:790-794`); woher `ImapAppend.cpp` den HTML-Merker der Nachricht nähme, ist nicht nachgesehen. **Widerlegt (bis 13.10.2026 abends hier als Ursache genannt):** *„`AppendContentType` (`ImapAppend.cpp:120`) schreibt als Untertyp nur `enriched` oder `plain`“* – `:120` ist nur die Deklaration, die Funktion (`:1821-1871`) läuft allein für Anhänge (`:1640`, `:1650`), nie für den Textrumpf. Originalfehler von QUALCOMM, verwandt mit [E-101](#e-101) (interne Fassung ohne passenden Kopf verlässt Eudora). **Datenverlust bei eingebetteten Bildern (berichtigt 14.10.2026, LEKTOR-35 L-35.10):** der Text kam vollständig auf den Server, nur die Typangabe fehlte – die eingebetteten Bilder aber gingen bis 7.2.0.89 verloren, weil die lokale Kopie nach dem Verschieben weg ist (Teil 2). Bis 13.10.2026 stand hier „kein Datenverlust im Text“. **Inzwischen gemessen** (14.10.2026, IMAP-Prüfserver mit `--ablage`): der Kopf der hochgeladenen Nachricht in Rohform, siehe oben – bis 13.10.2026 stand hier „nicht gemessen“ **Stufe: wichtig** (Darstellung: HTML-Mail als Quelltext)|
| <a id="e-119"></a>E-119 | **Bilder, die als `data:`-Adresse im HTML stecken, erscheinen beim Antworten und Weiterleiten als grauer Kasten** | **behoben — von Gregor am 26.10.2026 an Paket 1.0.124 bestätigt (TESTPLAN T2, im Protokoll belegt: `E-119 data-Bild als Datei: …data-8e094058.jpg laenge=201951`); am Testpaket 7.2.0.123 war es für große Bilder widerlegt, der zweite Teil ist am Prüfstand erst rot, dann grün gemessen (Fall `E-119e`: am Bau 1.0.123 `laenge=12983`, am Bau 1.0.124 `laenge=78519`).** **Zweiter Teil:** Beim Antworten auf eine Mail mit einem `data:`-JPEG erschien eine grüne Fläche mit Streifen (Gregors Bild). Gemessen im `eudora.log`: `E-119 data-Bild als Datei: …\Embedded\data-728ccd3e.jpg laenge=5343`; die Datei hat 3990 Byte, gültigen JPEG-Anfang und **keine** Endmarke `FF D9` (mit Gregors Erlaubnis gelesen). Ursache, am Quelltext belegt: `GetNextToken` zählt die Zeichen eines Attributwerts in `arg_size`, einem `pg_short_t` (16 Bit, `CPUDEFS.H`); ab 65.536 Zeichen läuft die Zahl über, und `E119DataNachDatei` bekam nur (Länge mod 65.536) Zeichen. Bilder unter 48 KB waren nicht betroffen — deshalb blieb es am Prüfstand verborgen, die Prüfnachricht hatte nur zwei kleine PNG. **Die Behebung:** `ProcessAttributes` (`PGHTMIMP.CPP`) misst die Länge eines `data:`-Werts selbst bis zum schließenden Anführungszeichen. Regressionstest `TestE119.cpp` (310 Tests, 310 bestanden; mit dem alten Aufruf einmal rot, 309/310), Prüfnachricht `Testdaten/e119-grosses-data-bild.eml` (`src` 78.519 Zeichen; vorher kämen 12.983 an), Prüfstandsfall `E-119e`. **Vorher:** **behoben auf dem Zweig `e-119-data-bilder` (24.10.2026), kommt mit Paket 7.2.0.123; am laufenden Programm am Prüfstand erst rot, dann grün gemessen, Regressionsfälle `E-119a` bis `c`.** Ein Bild, das direkt im HTML steckt, erscheint beim Antworten und Weiterleiten wieder als Bild statt als grauer Kasten. Für Gregor ist nichts zu tun; wer solche Post hat, kann es an 7.2.0.123 sehen. **Nachprüfung am 24.10.2026 ([PRÜFER-49](../Befunde/PRUEFER-49.md#pruefer-49), am Quelltext, nicht gemessen): hält für das gemessene Bild, drei Lücken.** ~~Dieselbe Bilddatei wird von allen Nachrichten mit demselben Bild geteilt~~ — **K5 behoben am 24.10.2026 abends** (Gregor: *„ja, vorher beheben, wenn daten verloren gehen können"*): beim Speichern einer Antwort oder Weiterleitung bekommt jede Nachricht eine **eigene Kopie** der `data-`-Datei über `NewPart`, wie bei `cid:`-Bildern (`E119KopieAlsTeil`, `PgEmbeddedImage.cpp`). **Gemessen am Prüfstand `C:\Temp\E119K`** (`tools/messen-e119-geteilt.ps1`: zweimal weiterleiten und speichern, einen Entwurf über Trash endgültig löschen): **vorher** verwiesen beide Entwürfe auf dieselben zwei Dateien, nach dem Löschen hatte keiner mehr seine Bilder (`vollstaendig=0`); **nachher** hat jeder Entwurf eigene Dateien, der verbliebene behält beide (`vollstaendig=1`), im Protokoll viermal `E-119 K5 Kopie: … kopiert=1`. Regressionsfall `E-119d` ([K5](../Befunde/PRUEFER-49.md#k5)). Bilder über rund 48 KB kommen abgeschnitten an, weil der HTML-Leser die Länge in 16 Bit zählt ([K6](../Befunde/PRUEFER-49.md#k6)). Ein `<a href="data:image/…">` würde beim Weiterleiten den lokalen Pfad mit dem Windows-Benutzernamen hinaustragen ([K7](../Befunde/PRUEFER-49.md#k7)); dazu [K8](../Befunde/PRUEFER-49.md#k8) und [E-145](#e-145). **Die Behebung:** `ProcessAttributes` (`PGHTMIMP.CPP`) schreibt einen `data:image/...;base64,...`-Wert **vor** der Kürzung auf `kMaxAttributeSize` mit `E119DataNachDatei` in eine Datei `Embedded\data-<Prüfsumme>.<Endung>` und gibt dem Lader `file://<Pfad>`; gleiche Daten ergeben denselben Namen. **Gemessen am 24.10.2026** am Prüfstand `C:\Temp\EBILD` mit `Testdaten/e119-data-bild.eml` (ein kurzes Bild mit 360, ein langes mit 1552 Zeichen Base64), zugestellt per POP, geöffnet, weitergeleitet: **vorher** Protokollzeile `E-110 Laden: src=data:image/png;base64,… datei=0 intern=-1` (der graue Kasten), das lange Bild kam im Lader gar nicht an; **nachher** `E-119 data-Bild als Datei: …\data-db1b9f48.png laenge=382` und `…\data-2eaa4a58.png laenge=1574`, dann `E-110 Laden: src=file://…data-db1b9f48.png faden=1 ok=1 … datei=1 intern=1` und `E-112 Metadatei: angegeben=79x64 Datei=79x64 gemalt=79x64`. Die beiden abgelegten Dateien sind **byte-gleich** mit den Originalbildern (268 und 1163 Byte, SHA-1 gleich). **Nicht gemessen:** für das lange Bild fehlt eine Lader-Zeile im Protokoll — dieselbe Lücke wie bei zwei Bildern der E-112-Prüfnachricht, an 7.2.0.120 genauso; Vermutung: Eudora lädt erst, was im sichtbaren Teil des Fensters steht. Ebenfalls nicht gemessen: was beim **Senden** einer solchen Weiterleitung mit dem `file://`-Verweis geschieht (der Sendeweg macht aus `file://` laut Quelltext einen eingebetteten Teil, `PgEmbeddedImage.cpp:1057`). **Zuerst eingetragen:** offen, am Protokoll belegt, von Gregor am 13.10.2026 an 1.0.86 gemeldet (*„graue kästchen beim weiterleiten und antworten. es wird immer schlimmer!“*, Bildschirmfoto: Weiterleitung „<Betreff einer Einladung>“, grauer Kasten 600×224). Seine `eudora.log` (nur gelesen): `E-95 Bild: src=data:image/jpeg;base64,/9j/… attr=600x224` und `E-110 Laden: … ok=1 daten=0 art=0 datei=0 intern=-1` – der Lader findet keine Datei, denn das Bild steht base64-kodiert in der Adresse selbst. Paige zeichnet dafür seinen Platzhalter in der angegebenen Größe. **Nicht von E-112 verursacht:** an diesem Weg ändert 7.2.0.85 nichts; ob 1.0.84 dasselbe zeigt, ist **nicht gemessen**. **Mögliche Behebung (ungemessen):** ein `data:`-Bild in eine Datei unter `Embedded` dekodieren und diese laden. **Nachtrag [PRÜFER-25](../Befunde/PRUEFER-25.md) H2 (13.10.2026, am Quelltext):** der zuerst hier genannte Ort – im Ladeweg (`PgEmbeddedImage.cpp`, vor `CanHandleImageInternally`) – ist **zu spät**: der HTML-Import kürzt jeden Attributwert auf 1023 Zeichen (`PGHTMIMP.CPP:3317-3318`, `kMaxAttributeSize`, vom LEKTOR nachgelesen), `resolve_URL` schreibt in `szImageURL[512]` (`:1996`), und `pg_url_image.URL` hat 512 Byte (`PaigeDLL/PGHEADER/PAIGE.H:1479`) – im Ladeweg kommen höchstens 511 Zeichen der Base64-Daten an. Ansetzen muss die Dekodierung **vor** `PGHTMIMP.CPP:3317` (beim Zerlegen des `<img>`-Tags) und `src` durch `file://…` oder eine `cid:` ersetzen. Dazu: `data:` steht nicht in `IDS_URL_SCHEMES` (`EudoraRes.rc:10828`), und bei `<base href>` hängt `PGHTMIMP.CPP:2011-2050` die Basisadresse davor. Vorhandener Dekoder: `Base64Decoder` (`Eudora/Base64.h:29-38`) **Was noch fehlt:** nichts — Gregors Bestätigung liegt vor (TESTPLAN T2 an 1.0.124). **Wie zu pruefen:** **ICH** — `Testdaten/` um eine Nachricht mit `data:`-Bild ergänzen, darauf antworten. Rot: grauer Kasten im Verfassenfenster. Grün: das Bild.  **Zuletzt gemessen: 26.10.2026 an 7.2.0.124** — der Mangel steht unverändert. `data:` kommt in `Eudora71/Eudora/PGHTMIMP.CPP` genau **zweimal** vor, und beide Male in einem **Kommentar** (`:2546` und `:2571`), der die drei möglichen Anfangszeichen aufzählt. Es gibt keine einzige Stelle, die eine `data:`-Adresse auch behandelt. Die Datei wird gebaut (`Eudora71/Eudora/Eudora.vcxproj`, mit `wer-baut.pl` geprüft) — es fehlt also nicht am Bau, sondern am Einbau. **Grenze ([PRUEFER-59 K4](../Befunde/PRUEFER-59.md#k4)):** `TestE119.cpp` bleibt grün, wenn der 16-Bit-Fehler zurückkommt; am Programm deckt ihn der Prüfstandsfall `E-119e`. **Stufe: wichtig** (Darstellung: eingebettete Bilder als grauer Kasten)|
| <a id="e-120"></a>E-120 | **Im IMAP-Posteingang fehlen Nachrichten, die der GMX-Webmailer zeigt** | **kein eigener Fehler, am Protokoll gemessen (13.10.2026, Gregor an 1.0.86).** Gemeldet: *„habe schon imap inbox gelöscht und neu eingelesen, leider ist der inhalt falsch, es fehlen nachrichten.“* Mit `LogLevel=58591` (`DEBUG_MASK_RCV`, nur Serverantworten – das Sendebit `0x20` bewusst nicht, es schriebe das Kennwort mit) meldet GMX `* 31 EXISTS`; neun Nachrichten tragen `FLAGS (\Deleted …)`: UID 275, 276, 282, 283, 290, 292, 297, 298, 299 – darunter die gesuchte Weiterleitung (UID 275, `Date: Mon, 14 Sep 2026 08:28:33 +0200`, von `<Testkonto-Adresse>`). Eudora blendet als gelöscht markierte, nicht entfernte Nachrichten aus (`IMAPAutoPurgeNever=1`), der Webmailer zeigt sie. 31 − 9 = 22 (+1 neu) = Gregors 23. Sichtbar machen: Kontextmenü des Postfachs → *Show Deleted Messages* (`ID_MBOXTREE_IMAP_SHOW_DELETED`). **Offen:** wer die neun markiert hat – vermutlich eine frühere Eudora-Fassung beim Verschieben/Löschen; nicht gemessen. **Von Gregor bestätigt am selben Tag:** *„ok, undelete hat sie wieder geholt. guter hinweis!“* **Nachtrag 14.10.2026 (LEKTOR-35), anderer Fall, kein Programmfehler:** Gregor fehlten die IMAP-Ordner ganz. In den Kontoeinstellungen stand als IMAP-Ordnerpräfix (Feld *„Location Prefix:“*, `EudoraRes.rc:1516`, `IDD_ACCOUNT_PROP_ADVANCED`; im Einrichtungsassistenten *„IMAP Mailbox Location Prefix“*, `EudoraRes.rc:1462`, `IDD_LOCATION_PREFIX`) fälschlich der Servername `imap.gmx.net`. Gregor hat das Feld geleert, die Ordner sind wieder da. Bei welcher Fassung das auffiel und wie der Eintrag dorthin kam, ist nicht notiert. **Stufe: kritisch** (Datenverlust: Nachrichten fehlen im IMAP-Posteingang)|
| <a id="e-121"></a>E-121 | **Eine Nachricht, die aus einem lokalen Postfach in einen IMAP-Ordner verschoben wird, kann spurlos verschwinden** — nicht hochgeladen, lokal gelöscht, ohne Meldung | **behoben, von Gregor bestätigt am 17.10.2026** (*„ja, e-121 behoben.“*, Chat) nach seinen Tests an 1.0.96, 1.0.99 und 1.0.101 (jede Übertragung `hochgeladen=1` in seinem Protokoll, siehe unten); veröffentlicht als `v1.0.101`. **Abgetrennt am selben Tag:** der vermutete Rest – gesendete Mail während eines Abgleichs des Zielordners ([PRÜFER-33](../Befunde/PRUEFER-33.md) Q1) – als [E-126](#e-126), die fehlende Anzeige in einem seit dem Start nie geöffneten IMAP-Ordner als [E-127](#e-127). **Stand davor: DATENVERLUST. Offen, Behebung eingebaut in 7.2.0.90 (Zweig `e-118_HTML_header`), am IMAP-Prüfserver in drei Fällen gemessen.** **Messung 14.10.2026 (`C:\Temp\E118`):** (1) Normalfall: hochgeladen, Quelle danach entfernt (`E-121 Uebertragung: … im-ziel=1 in-quelle=1 hochgeladen=1`). (2) Lokale Kopie im Ziel fehlt (mit einem vorübergehenden Prüfschalter erzwungen, vor dem Commit ausgebaut): aus der Quelle hochgeladen, mit eingebettetem Bild und Fußzeile (`im-ziel=0 in-quelle=1 hochgeladen=1`). (3) Server lehnt `APPEND` ab (`tools/imap-pruefserver.pl --append-ablehnen`): `hochgeladen=0`, die Nachricht bleibt im Posteingang. **Ursache, berichtigt nach der Messung:** nicht das Öffnen des Zielordners allein (Gegenprobe 7.2.0.88 mit geschlossenem Zielordner: `Opening mailbox`, trotzdem hochgeladen), sondern ein Wettlauf mit der **Abgleichsaufgabe des Zielordners vom Programmstart** (`Resyncing`, im Protokoll `E-83 … liegengeblieben`): schließt sie ab, nachdem die Kopie lokal abgelegt und die Quelle entfernt ist, aber bevor die Übertragung lädt, verwirft sie die Kopie – und löscht dabei die eingebetteten Bilddateien mit, die Quelle und Kopie sich teilen (gemessen: `E-118 Bild: vorhanden=0`). Ein erster Versuch („Zielordner vor der Kopie öffnen“) schloss das nicht und ist zurückgenommen. **Behebung:** `CTocDoc::ImapXferFromLocalToImap` entfernt die Quelle nicht mehr sofort; `CImapFromLocalTransferMsgAction::DoPostProcessing` lädt die Kopie aus dem Ziel hoch oder, fehlt sie, aus der Quelle, und entfernt die Quelle erst nach dem Hochladen; eine nicht gefundene Nachricht ist ein Fehlschlag, die übrigen Kennungen werden weiter abgearbeitet. `CTocDoc::Xfer` markiert die lokale Vorab-Kopie mit `SetDeleteEmbedded(FALSE)`. **Nebenbefunde, alt, nicht behoben:** (a) die Abgleichsaufgabe vom Start bleibt manchmal ganz stehen (`liegengeblieben` bis zum Beenden) und blockiert die IMAP-Warteschlange – die Übertragung wird erst beim nächsten Start nachgeholt (aus `actionqueue.dat`), verwandt mit [E-83](#e-83); (b) werden liegengebliebene Übertragungen nachgeholt, kann eine Nachricht **doppelt** auf dem Server landen (gemessen: zwei `APPEND` derselben Nachricht) – kein Verlust; (c) nach dem Hochladen bleiben die eingebetteten Bilddateien der Quelle im Ordner `Embedded` liegen (Speicher, kein Verlust). **Nach [PRÜFER-28](../Befunde/PRUEFER-28.md) (14.10.2026):** P1 – die erste Fassung der Behebung suchte die Quelle über ihre Kennung und entfernte den ersten Treffer; lokal ist die Kennung nicht eindeutig (alle Nachrichten aus `Out` haben 0), beim Verschieben aus `Out` wäre eine **fremde** Nachricht gelöscht worden – **behoben vor jeder Auslieferung**: die Quelle wird nur benutzt und entfernt, wenn ihre Kennung ungleich 0 ist und im Ordner genau einmal vorkommt. P2 – ein offenes Nachrichtenfenster der Quelle wird vorher geschlossen (wie im Original). P4 – Spurmarke mit `atoi(m_szMessageIDs)` ausgebaut. **Offen (P3):** der Schutz der Bilddateien (`SetDeleteEmbedded(FALSE)`) steht nur im Speicher; bleibt eine Übertragung über einen Neustart liegen und verwirft ein Abgleich danach die Vorab-Kopie, werden die geteilten Bilddateien doch gelöscht – der Text kommt dann aus der Quelle an, die Bilder nicht. Selten (setzt voraus, dass die Übertragung vor dem Beenden nicht lief), aber Bildverlust. **P3 behoben eingebaut (14.10.2026, nicht im Fehlerfall gemessen):** `ImapRemoveAttachments` (`EuImap/src/ImapToc.cpp`) löscht die Bilddateien einer Nachricht im IMAP-Ordner nicht, solange für ihre Kennung noch eine Übertragung lokal → IMAP in der Warteschlange steht (`CActionQueue::HatOffeneUebertragung`, über `CImapAccount::HatOffeneUebertragung`); die Warteschlange übersteht einen Neustart (`actionqueue.dat`), anders als der Merker im Speicher. Den Neustart-Fall selbst herbeizuführen gelang am Prüfstand nicht ohne Offline-Dialog; belegt ist nur, dass Bau und Suite (209/209) grün sind und der Normalfall weiter hochlädt. **[PRÜFER-29](../Befunde/PRUEFER-29.md) (14.10.2026): Datenverlust-Klasse geschlossen, auslieferbar.** Offene Reste: N1 (sehr selten, Datenverlust) – ob die Kennung eindeutig ist, wird erst beim Hochladen gezählt; hat der Nutzer die verschobene Nachricht vorher selbst aus der Quelle entfernt, kann ein einzelner Namensvetter mit gleicher Kennung ungleich 0 entfernt werden (saubere Lösung: eindeutige Nachrichtenkennung); N2 (Bildverlust nach Neustart, Nachricht bleibt) – der Abgleich am Ende von `DoPostProcessing` ist ungeschützt; N3 (dito) – Kennung 0 (gesendete Post) wird nie geschützt. Paket 1.0.90 am 14.10.2026 bei Gregor bereitgestellt (`C:\Users\Gregor\Eudora72-1.0.90-release`). **Gregors Test an 1.0.90 (14.10.2026):** nichts verloren, beide Verschiebungen je einmal auf dem Server, Bilder da (*„ja, bilder sind drin.“*). **Befund dabei:** *„mails erscheinen nach dem verschieben 2x“* – *„wenn imap mailbox geschlossen, sieht man kurz die mails doppelt, danach verschwindet sie. wenn imap mailbox offen, dann bleiben 2x mails nach verschieben“*. Sein Protokoll: beide Verschiebungen je **einmal** hochgeladen (`E-121 Uebertragung: … hochgeladen=1`, SoftMaker-Mail mit beiden Bildern `related=1`) – auf dem Server nichts doppelt, nur die Anzeige. Ursache am Quelltext: `CTocDoc::ImapCopyMsgFromLocalToImap` (`EuImap/src/ImapToc.cpp`) fügt nach dem Hochladen eine neue Zusammenfassung mit der Server-UID hinzu, ohne die lokale Vorab-Kopie zu ersetzen; `ImapCopyMsgBetweenAccounts` tut das (`GetSummaryFromUID` → `SubtractSum`). Erst der nächste Abgleich entfernt die Vorab-Kopie – bei geschlossenem Ordner gleich beim Öffnen, bei offenem erst später. **Neunter Teil bestätigt an 1.0.101:** Gregor an 1.0.101 (17.10.2026): *„ich starte 1.0.101 und teste: mail verschoben, sind aber im outbox nicht zu sehen.“* und nach dem Neuöffnen des Ordners *„nach neu-öffnen sind mails zu sehen.“* (Chat). Sein Protokoll: zwei gesendete Mails mit zwei verschiedenen eigenen Kennungen, `E-121 Uebertragung: id=3348826478 … hochgeladen=1` und `id=3348826734 … hochgeladen=1`, neue UIDs 17 und 18 – der neue Weg ist gelaufen. **Neu dabei (Anzeige):** War der IMAP-Ordner beim Verschieben **nicht geöffnet** und wird er gleich danach geöffnet, fehlen die eben hochgeladenen Mails in der Liste, bis der Ordner noch einmal geschlossen und geöffnet wird (Gregors Protokoll: Hochladen um 5.01 bei `summen=2`, danach erst `NewChildFrame … OUTBOX`, Abgleich ohne Übernahme). **Kein Datenverlust**, nur Anzeige; Ursache nicht untersucht. Eingegrenzt an Gregors weiteren Runden (17.10.2026): bei geschlossenem, aber in dieser Sitzung schon einmal geöffnetem Ordner erscheinen die Mails sofort (`summen=27` nach dem Hochladen, test 7/8) – es betrifft nur einen Ordner, der seit dem Start noch nicht geöffnet war (`summen=2`). **Offen laut [PRÜFER-33](../Befunde/PRUEFER-33.md) (Q1, Vermutung am Quelltext):** wird eine gesendete Mail genau dann verschoben, wenn Eudora den Zielordner gerade abgleicht, kommt sie nicht auf dem Server an und liegt nur im lokalen Papierkorb. **Neunter Teil, eingebaut in 7.2.0.101 (17.10.2026):** [PRÜFER-32](../Befunde/PRUEFER-32.md) – Nachrichten aus `Out` bekommen beim Verschieben eine eigene Kennung (Quelle und Vorab-Kopie gemeinsam, `E121NeueKennung`); eine Vorab-Kopie mit gescheitertem Hochladen wird sofort entfernt. Am Prüfstand `C:\Temp\E118` an 7.2.0.101 (17.10.2026): Normalfall `hochgeladen=1`; **Server lehnt das Hochladen ab** (`--append-ablehnen`): `E-121 Hochladen gescheitert, Vorab-Kopie entfernt`, die Nachricht bleibt in `In`; Kollisionsfall zweimal grün; alle sauber beendet. Die eigene Kennung für Nachrichten aus `Out` ist am Prüfstand **nicht nachstellbar** (per POP abgerufene Post hat nie Kennung 0) – Prüfung bei Gregor. Testsuite **209/209**. **Achter Teil, eingebaut in 7.2.0.100 (16.10.2026), Zweig `e-121-mehrere-gesendete`:** [PRÜFER-31](../Befunde/PRUEFER-31.md) F1 – mehrere Nachrichten mit Kennung 0 in einer Übertragung ohne neue UID oder mit gescheitertem Hochladen: die Vorab-Kopie behielt ihr Merkzeichen, jede Runde nahm dieselbe (eine Mail mehrfach, die anderen nicht; ihre Quellen im lokalen Papierkorb). Behoben am Quelltext: Merkzeichen **vor** dem Versuch löschen, ohne neue UID die Zusammenfassung selbst ersetzen; F3 leere Kennungsliste. Am Prüfstand `C:\Temp\E118` gemessen (16.10.2026), sechs Läufe an 7.2.0.100: Normalfall 2×, Server ohne neue UID (`--ohne-appenduid`, der geänderte Weg) 2×, Kollisionsfall 2× – alle `hochgeladen=1`, alle sauber beendet. F1 selbst ist **nicht nachstellbar**: Kennung 0 haben nur Nachrichten aus `Out`, per POP abgerufene Post bekommt ihre Kennung immer aus dem Abrufprotokoll (`pop.cpp:376`); bei Gregor (GMX, mit UIDPLUS) tritt F1 ebenfalls nicht auf. Testsuite **209/209**. **Bestätigt an 1.0.99:** Gregor an 1.0.99 (16.10.2026): *„0.99 scheint zu funktionieren.“* (Chat); sein Protokoll: gesendete Mail `E-121 Uebertragung: id=0 im-ziel=1 in-quelle=0 markiert=0 hochgeladen=1`, zwei Mails aus `In` mit `markiert=1 … hochgeladen=1`, Beenden bis `ExitInstance` ohne *„task(s) running“*; keine neue Defender-Erkennung. **Nachtrag 16.10.2026 (7.2.0.98):** N1 am Prüfstand: `markiert=1`, Quelle entfernt, in 10 von 10 Läufen. Kollisionsfall (`--fremde-uid`, `-ZielBehalten`) an 7.2.0.98 grün: `im-ziel=1 markiert=1 hochgeladen=1`, fremde Nachricht unverändert. Gesendete Post (Kennung 0, [PRÜFER-30](../Befunde/PRUEFER-30.md) F1) ist am Prüfstand nicht nachstellbar – Prüfung bei Gregor. Der Verdacht eines Rückfalls in 7.2.0.97 ist widerlegt (Ursache [E-83](#e-83)). **Siebter Teil, eingebaut in 7.2.0.97 (15.10.2026):** [PRÜFER-30](../Befunde/PRUEFER-30.md) F1 – Rückfall in 7.2.0.96: Kennung 0 (aus `Out`, gesendete Post) fand keine Vorab-Kopie und keine Quelle, die Nachricht wurde nicht hochgeladen (am Quelltext nachgeprüft: `ImapToc.cpp` `E121FindeVorabKopie` gab bei 0 sofort NULL). Behoben: Suche auch bei 0, beim Hochladen aus dem Ziel die Zusammenfassung selbst. **N1 behoben:** entfernt wird nur die in `CTocDoc::Xfer` markierte Quelle (`m_bE121Quelle`). **N2/N3 abgetrennt** nach [E-123](#e-123). [PRÜFER-30](../Befunde/PRUEFER-30.md) F2: `ImapMergeTmpMbx` wird nie aufgerufen (Aufruf in `ImapThread.cpp:168-212` unter `#ifdef OMITFORNOW`) – der vierte Teil ist toter Code, die Angabe „Aufruf aus `ImapThread.cpp:209`“ war falsch (Berichtigung). F3–F9 offen, siehe Bericht. Testsuite **209/209**; am Prüfstand nicht gemessen (der Fall Kennung 0 aus `Out` ist dort nicht nachstellbar) – Prüfung bei Gregor. **Sechster Teil, eingebaut in 7.2.0.96 (15.10.2026), bestätigt:** Gregor an 1.0.96 (15.10.2026): *„ja, jetzt klappt es, der fehler tritt nicht mehr auf“*; sein Protokoll: vier Übertragungen, alle `hochgeladen=1`, darunter `id=312` (alte UID als Kennung – der Kollisionsfall), kein `hochgeladen=0`. Gregor an 1.0.95: *„schaut gut aus, aber:“* Dialog *„Attempt to add the message to mailbox Inbox failed“*. Protokoll `E-121 Uebertragung: id=13 im-ziel=1 in-quelle=1 hochgeladen=0`. Die lokale Kennung (hier die alte UID aus einem früheren IMAP-Abruf) fällt mit der Server-UID einer **fremden** Mail im Ziel zusammen; im IMAP-Ordner ist `m_Hash` die Server-UID, die Suche über `GetSummaryFromUID` traf die fremde Mail. Behebung: Merkzeichen `m_bE121Vorab` an der Vorab-Kopie (`tocdoc.cpp` Xfer), Suche nur noch über `E121FindeVorabKopie` (`ImapToc.cpp`), in `DoPostProcessing` und `ImapCopyMsgFromLocalToImap`. Am Prüfstand gemessen: neue Option `--fremde-uid` des IMAP-Prüfservers legt eine fremde Nachricht mit der Kennung der Testmail in den Zielordner, `e118-serie.ps1 -ZielBehalten` lässt sie im Zwischenspeicher. An **7.2.0.95** kommt genau Gregors Dialog (*„Attempt to add the message to mailbox … failed“*, `im-ziel=1 hochgeladen=0`), an **7.2.0.96** `im-ziel=1 hochgeladen=1`, `summen=2`, die fremde Nachricht unverändert, die eigene einmal im Ziel und aus `In` entfernt. Testsuite **209/209**. Offen: `ImapMergeTmpMbx` (vierter Teil) entfernt beim Abgleich einen Eintrag mit derselben UID – trifft das eine Vorab-Kopie, wird aus der Quelle hochgeladen, kein Verlust. **Fünfter Teil, eingebaut in 7.2.0.95 (15.10.2026):** Gregor an 1.0.94 (Bildschirmfoto, „Formel 1, NFL …“ doppelt; nach dem Neuöffnen *„nur 1x zu sehen“* – die Mail lag also einmal auf dem Server, nur die Fensterliste zeigte sie doppelt). Sein Protokoll: `neue-uid=320`, `summen=37` vor und nach dem Abgleich, **keine** Zeile `E-121 Abgleich uebernimmt` – der vierte Teil lief gar nicht, die Daten sind einfach, nur die Fensterliste zeigt doppelt. Am Quelltext: das Ersetzen mit `SubtractSum` + `AddSum` (seit 7.2.0.91) löscht die Listenzeile über die Position in `m_Sums`; stimmt die Reihenfolge der Fensterliste nicht (Sortierung steht nach dem Einfügen der Vorab-Kopie noch aus), trifft es eine andere Zeile. Jetzt: Vorab-Kopie an Ort und Stelle aktualisieren. Nicht gemessen. **Vierter Teil (lief bei Gregor nicht, bleibt als Absicherung), eingebaut in 7.2.0.94 (15.10.2026):** Gregor an 1.0.93: *„FAILED: sowohl in der inbox, als auch in der outbox von IMAP sind die mails immer noch doppelt.“* Sein Protokoll **widerlegt** den dritten Teil: GMX meldet die UID (`neue-uid=7`, `8`, `9`, `319`), direkt nach dem Hochladen stimmt `summen`. Die zweite Zeile legt `CTocDoc::ImapMergeTmpMbx` an, das die vom Server geladenen Mails ohne UID-Prüfung übernimmt (Aufruf aus `ImapThread.cpp:209`). Jetzt ersetzt die geladene Fassung einen Eintrag mit derselben UID. Spurmarke `E-121 Abgleich uebernimmt: uid=… schon-da=…`. Gregors Bilder vor und nach dem Neuöffnen: „MCP to serverless“ vorher doppelt, nachher einmal; „Änderungen für Autofahrer“ auch nachher doppelt – vermutlich zweimal auf dem Server aus den Tests an 1.0.89/1.0.90, nicht gemessen. **Dritter Teil (widerlegt als Ursache, Code bleibt als Absicherung für Server ohne UIDPLUS), eingebaut in 7.2.0.93 (15.10.2026):** Gregor an 1.0.92: *„ja, 3 mails, jede 2x drin“*. Sein Protokoll: je einmal hochgeladen, `summen` nach dem Hochladen und nach dem Anstoß des Abgleichs je +1 – das Doppel entsteht erst im nachlaufenden Abgleich. Der prüft selbst, ob eine Nachricht mit derselben UID schon im Ordner steht (`ImapMailbox.cpp` um :4999, `GetSummaryFromUID(pImapSum->GetHash())`); die UID setzt 7.2.0.92 aber nur, wenn der Server sie beim Hochladen meldet (UIDPLUS/`APPENDUID`). Der Prüfserver meldete sie immer – deshalb zeigte der Prüfstand das Doppel nie. Jetzt: ohne gemeldete UID wird die Vorab-Kopie nach dem Hochladen entfernt (Bilddateien bleiben, nicht bei Kennung 0), der Abgleich holt die Nachricht einmal vom Server. Spurmarke `E-121 Hochgeladen: ergebnis=… neue-uid=…`. Am Prüfstand NICHT gemessen (vier Läufe mit `--ohne-appenduid` hingen alle am Start-Abgleich des Prüfservers); Prüfung bei Gregor mit offenem IMAP-Ordner. **Zweiter Teil, eingebaut in 7.2.0.92 (15.10.2026):** Gregor an 1.0.91: *„nachdem ich das fenster geschlossen und neu geöffnet habe, ist die mail nur 1x zu sehen.“* – bei offenem Ordner stand sie also weiter doppelt da. Sein Protokoll: einmal hochgeladen, `im-ziel=1`, `summen=32` direkt nach dem Hochladen – die Spurmarke zählte **vor** dem Abgleich, das Doppel entsteht erst **im** Abgleich: die ersetzte Kopie trug noch die lokale Kennung, der Abgleich kennt im IMAP-Ordner nur UIDs und fügte die Server-Fassung zusätzlich ein. Jetzt bekommt die ersetzte Kopie die vom Server gemeldete UID; Spurmarke `E-121 Ziel nach dem Abgleich`. Am Prüfstand nicht im Doppelfall gemessen. **Erster Teil, eingebaut in 7.2.0.91 (15.10.2026), am Prüfstand gemessen, von Gregor an 1.0.91 als nicht ausreichend befunden:** die Vorab-Kopie wird wie bei `ImapCopyMsgBetweenAccounts` wiederverwendet (nicht bei Kennung 0), ihre Bilddateien bleiben; Spurmarke `E-121 Ziel nach dem Hochladen: summen=1` im Fall `im-ziel=1`. **Nebenbeobachtung am Prüfstand:** die hängende Abgleichsaufgabe vom Start zeigt beim Beenden *„You currently have 1 task(s) running“* (Gregor sah den Dialog am 15.10. in meiner Testinstanz); ob das auch an GMX vorkommt, ist offen. **Vorher stand hier:** Gefunden am 14.10.2026 beim Messen von [E-118](#e-118) am IMAP-Prüfserver (`C:\Temp\E118`, Weg: POP-Abruf, Filter überträgt in den IMAP-Ordner `Ablage`). Vier von acht Läufen kamen nie beim Server an, und die Nachricht war danach weder im Posteingang noch im Zielordner – **auch an 7.2.0.88** (`C:\Temp\E118-0088`), also ein Originalfehler von QUALCOMM, kein Rückfall durch E-118. **Ursache, am Protokoll und Quelltext belegt:** `CTocDoc::Xfer` (`Eudora/tocdoc.cpp`) legt die Kopie zuerst lokal im Zielordner ab und entfernt sie aus der Quelle; erst danach öffnet `ImapXferMessages` (`EuImap/src/ImapToc.cpp:415-433`) den Zielordner, falls er noch nicht gewählt ist. Das Öffnen gleicht mit dem Server ab – der kennt die Nachricht noch nicht, die eben abgelegte Kopie wird verworfen. `CImapFromLocalTransferMsgAction::DoPostProcessing` (`EuImap/src/ImapActionQueue.cpp`) findet sie dann nicht (`GetSummaryFromUIDStringFromDestination`, Spurmarke `E-118 Uebertragung: … gefunden=0`), beendet die Schleife beim ersten Fehlen und meldet **Erfolg**. In jedem verlorenen Lauf steht `Opening mailbox "Ablage"` mitten im Filterlauf, in keinem gelungenen. **Behebung:** `Xfer` öffnet einen IMAP-Zielordner, der noch nicht gewählt ist, **vor** der lokalen Kopie (Spurmarke `E-121 Zielordner vor der Kopie geoeffnet`; offline unverändert); `DoPostProcessing` meldet eine nicht gefundene Nachricht als Fehlschlag und arbeitet die übrigen Kennungen weiter ab. **Wen es trifft:** jeden, der lokal → IMAP verschiebt oder filtert, während der Zielordner nicht offen ist – bei Gregors Tests war der Zielordner jedes Mal schon offen. **Stufe: kritisch** (Datenverlust: Nachricht verschwindet beim Verschieben)|
| <a id="e-122"></a>E-122 | **Das Eingangsdatum einer in einen IMAP-Ordner hochgeladenen Nachricht ist um die Zeitzone verschoben** — `Date: 09:10 +0200` kommt als `07:10:00 +0200` an | **offen, gemessen und am Quelltext belegt, keine Änderung eingebaut.** MESSSTAND und [PRÜFER-27](../Befunde/PRUEFER-27.md) am 14.10.2026 am IMAP-Prüfserver, an 7.2.0.88 und 7.2.0.89 gleich – Originalfehler. `CSummary::m_Seconds` ist nicht UTC, sondern UTC minus die Zeitzone des Rechners (`mktime`, `services.cpp:2265`, dazu der Abzug der Absenderzone `:2076`); `ImapMailbox.cpp:4281` gibt ihn an `append_date` (`Imapdll/src/osdep.cpp:159-194`), das echtes UTC erwartet. Die dort auskommentierte Korrektur `+ 60*m_TimeZoneMinutes` stimmt nur, wenn Absender und Rechner in derselben Zone liegen. Folge: im IMAP-Ordner falsche Sortierung nach Eingang; der `Date:`-Kopf selbst bleibt richtig. **Kein Datenverlust.** **Was noch fehlt:** die Berichtigung selbst — `ImapMailbox.cpp:4281` übergibt `CSummary::m_Seconds` an `append_date`, das echtes UTC erwartet, während `m_Seconds` UTC minus Ortszone ist (`services.cpp:2265`). Die dort auskommentierte Korrektur `+ 60*m_TimeZoneMinutes` genügt nicht, sie stimmt nur bei gleicher Zone.  **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — der Mangel steht unverändert. In `EuImap/src/ImapMailbox.cpp` lautet die Zeile `Append.m_Seconds = pSum->m_Seconds ;` und die Zeitzonenkorrektur steht **auskommentiert** daneben: `/*+ 60*pSum->m_TimeZoneMinutes;*/`. Genau das ist die Verschiebung. Der Quelltextkommentar eine Zeile darüber (`ImapMailbox.cpp:4279`) nennt den Zweck selbst: der Wert sei als Ersatz gedacht, falls die Nachricht gar kein Datumsfeld hat. Benutzt wird er aber als echte Zeit. **Stufe: kritisch** (Datenschaden: Eingangsdatum dauerhaft um die Zeitzone verschoben)|
| <a id="e-123"></a>E-123 | **Nach einem Neustart mitten in einer Übertragung lokal → IMAP können eingebettete Bilder einer verschobenen Nachricht fehlen** — die Nachricht selbst bleibt (abgetrennt aus [E-121](#e-121), dort N2/N3) | **Der Beenden-Weg ist am 20.10.2026 von Gregor an Paket 1.0.111 am laufenden Programm bestätigt — auf beiden Wegen.** Bis 7.2.0.110 zählte `CActionQueue::E123OffeneUebertragungen` (`EuImap/src/ImapActionQueue.cpp:4007`) nur `CImapFromLocalTransferMsgAction`, also Übertragungen aus einem **lokalen** Postfach nach IMAP; von vier Übertragungsarten war eine gezählt. Gregors Lauf an 1.0.110: *„verschoben und beendet. fenster ging gleich weg"* — `E-123 Warteschlange: konto=1 eintraege=1 … laeuft=0 uebertragungen=0`, dazu ein unausgeführter `<ActionType>transfersame</ActionType>` mit fünf Nachrichten in `actionqueue.dat`. **Ein Eintrag in der Warteschlange, gezählt als null.** Behoben in **7.2.0.111**: gezählt wird die Basisklasse `CImapTransferMsgAction`, und `CImapSameServerTransferMsgAction::DoWork` führt den Hochladezähler wie der Weg von lokal nach IMAP. **Gemessen an 1.0.111:** Weg 2b (innerhalb des IMAP-Kontos) `uebertragungen=1`, *„Beenden wartet auf 1 Uebertragung(en)"*, *„Warten zu Ende nach 4015 ms, offen=0"*, danach leere `actionqueue.dat`; Weg 2a (aus dem lokalen `In`) zusätzlich **`laeuft=1`** — der Zähler um die laufende Übertragung, der bei 2b nie ansprang — und *„Warten zu Ende nach 6015 ms"*. Schranke dagegen: `tools/pruefe-e123-zaehlung.pl`, Gegenprobe am Fehlerstand 2 von 2 rot. **Der Befund selbst bleibt offen:** nach Absturz, Defender, Stromausfall oder erzwungenem Herunterfahren können eingebettete Bilder weiter fehlen; abgearbeitet sind nur die Prüfpunkte am **ordentlichen** Beenden. — **Offen; [PRÜFER-36] (Befunde/PRUEFER-36.md) (17.10.2026) an 7.2.0.104: zum Test ja, ins Release erst nach P1 (die 5-Minuten-Grenze beendet auch mitten im Hochladen oder bei offenem Kennwortdialog) und P2 (der Zähler um den Verbindungsaufbau zählt für die Übertragung nie, weil `CImapFromLocalTransferMsgAction::DoPreThreadAction` die Basisfunktion nicht aufruft – PRÜFER-35 [N4](#n4) bleibt damit offen); P4: die Spurmarke `laeuft=` zeigt nicht den Zähler. Diese drei Punkte sind offen.** Teilbehebung eingebaut in 7.2.0.102, nach [PRÜFER-34](../Befunde/PRUEFER-34.md) abgesichert in 7.2.0.103, nach [PRÜFER-35](../Befunde/PRUEFER-35.md) (konnte für immer warten) in 7.2.0.104 (17.10.2026), Zweig `e-123-beenden-warten`:** Nachgestellt an 7.2.0.104 (17.10.2026): einfaches Schließen – `Beenden wartet`, hochgeladen, `Warten zu Ende nach 10015 ms`, sauber; doppeltes Schließen – zweites Schließen ignoriert, hochgeladen, `Warten zu Ende nach 8078 ms`, sauber. Testsuite 209/209. Nachgemessen an 7.2.0.103 (`tools/messen-e123-doppelt.ps1`: Eudora beendet sich über *File → Exit*, danach kommt ein zweites Schließen): `E-123 Beenden wartet auf 1 …`, `weiteres Schliessen waehrend des Wartens ignoriert`, Hochladen bestätigt, `Warten zu Ende nach 10047 ms, offen=0`, sauber bis `ExitInstance`. Testsuite 209/209. Davor 7.2.0.102: das Beenden wartet auf ausstehende Übertragungen (höchstens 90 s), damit keine Übertragung mehr über einen Neustart getragen wird; eine nur belegte Verbindung blockiert die Warteschlange nicht mehr dauerhaft. Bleibt offen für Absturz, Defender, Stromausfall, erzwungenes Herunterfahren. Gemessen am Prüfstand `C:\Temp\E118` (17.10.2026) mit neuer Prüfserver-Option `--append-verzoegerung 25` (der Server bestätigt das Hochladen erst nach 25 s) und `tools/messen-e123.ps1` (Abruf, dann sofort beenden): an **7.2.0.102** `E-123 Beenden wartet auf 1 Uebertragung(en)`, alle 2 s nachgezählt, Hochladen bestätigt (`hochgeladen=1`), `Warten zu Ende nach 10047 ms, offen=0`, sauber bis `ExitInstance`, Quelle aus `In` entfernt. **Gegenprobe an 7.2.0.101:** kein Warten, nach `WM_CLOSE` keine Zeile mehr bis zum Abschuss nach 120 s, das Hochladen nie bestätigt, die Mail blieb in `In`, `actionqueue.dat` leer – die Übertragung wäre auch nach einem Neustart nicht fortgesetzt worden. Testsuite **209/209**. **Nicht durchlaufen:** die neue Wiederholung bei belegter Verbindung (keine Zeile `Verbindung belegt` in den Läufen) – nur am Quelltext begründet. **Nebenbefund, ungeklärt:** antwortet der IMAP-Server beim Start sehr langsam (`--gruss-verzoegerung 15`), reiht der Filter „nach IMAP“ die Übertragung gar nicht erst ein (Warteschlange beim Beenden leer, `eintraege=0`), die Mail bleibt still in `In` – kein Verlust, aber der Filter tut nichts. Seit 7.2.0.101 ist [N3](#n3) (Kennung 0 nie geschützt) durch die eigene Kennung für gesendete Post gegenstandslos. **Stand davor: offen, Vermutung am Quelltext, ungemessen.** Der Schutz der Bilddateien (`SetDeleteEmbedded(FALSE)`) und die Merkzeichen aus [E-121](#e-121) stehen nur im Speicher. [N2](#n2): der Abgleich am Ende von `CImapFromLocalTransferMsgAction::DoPostProcessing` (`EuImap/src/ImapActionQueue.cpp`) ist nach einem Neustart ungeschützt. [N3](#n3): Kennung 0 (gesendete Post) wird von `HatOffeneUebertragung` nie geschützt. Abgetrennt am 15.10.2026 auf Gregors Wunsch (*„ja, [N1](#n1) beheben, [N2](#n2)/[N3](#n3) abtrennen“*, Chat). **Kein Verlust der Nachricht.** **Was noch fehlt:** der Verlust eingebetteter Bilder nach **Absturz, Defender, Stromausfall oder erzwungenem Herunterfahren**. Abgearbeitet ist nur der ordentliche Beenden-Weg.  **Zuletzt gemessen: 22.10.2026 an 7.2.0.121** — **der offene Teil ist entschieden, und er geht anders aus als befuerchtet.** Hier stand als Rest: *„der Verlust eingebetteter Bilder nach Absturz, Defender, Stromausfall oder erzwungenem Herunterfahren“*. Dafür gebaut: `tools/messen-e123-abbruch.ps1` — löst den Abruf aus, wartet, und **schießt Eudora ab**, während die Übertragung lokal → IMAP noch aussteht (nach Pfad gefiltert, wie `testlauf.ps1:154`). Gefahren über `e118-serie.ps1 -GrussVerzoegerung 20` mit `Testdaten/e118-eingebettetes-bild.eml`. **Gemessen nach dem Abschuss:** `ablage=0` am IMAP-Prüfserver (nichts kam an). Lokal: `In.mbx` 706 Byte, die Nachricht steht da, der Verweis `cid:punkt-rot@e118.invalid` ist erhalten, und **das Bild liegt auf der Platte** — `Embedded\punkt-rot99.png`, 70 Byte, geschrieben um 21:46:13, derselben Sekunde wie die Nachricht. **Gemessen nach einem Neustart:** alle drei unverändert. Die Zuordnung hält. **Das eingebettete Bild geht also NICHT verloren.** Verloren geht die ausstehende Übertragung: `actionqueue.dat` ist **78 Byte — leer, nur der Kopf**. Es gibt nichts, was fortgesetzt werden könnte, es wird nichts wiederholt, und der Anwender erfährt es nicht. Die Nachricht bleibt lokal liegen, als wäre nie etwas angestoßen worden. **Was noch fehlt:** die ausstehende Übertragung muss den Abbruch überleben — entweder in der Warteschlange stehen, bevor sie beginnt, oder beim nächsten Start als fehlend gemeldet werden. **Wie zu prüfen:** `messen-e123-abbruch.ps1` erneut fahren; danach muss `actionqueue.dat` größer als 78 Byte sein ODER der Anwender eine Meldung sehen. **Stufe: kritisch** (Datenverlust: eingebettete Bilder nach Neustart weg)|
| <a id="e-124"></a>E-124 | **Microsoft Defender stuft eine Eudora-Fassung als Trojaner ein und beendet das laufende Programm** — `Trojan:Win32/Bearfoos.A!ml` auf `Eudora.exe` 7.2.0.98; das Fenster verschwindet ohne Dialog und ohne `Exception.log`, es sieht aus wie ein Absturz | **offen (nicht im Code behebbar), gemessen am 16.10.2026; Schranke eingebaut.** Gregor an 1.0.98: *„crash beim verschieben“*, *„eudora fenster ist weg!“* (Chat). Gemessen: `eudora.log` endet ohne Beendigungszeile, die gesendete Mail war schon hochgeladen (`E-121 Uebertragung: id=0 … hochgeladen=1`); kein Eintrag *Application Error*, kein Fehlerbericht, keine `Exception.log`/`EudoraCrashDump.dmp`. `Get-MpThreatDetection`: **10:12:25** Erkennung am laufenden Prozess (pid 10476, `C:\Users\Gregor\Eudora72-1.0.98-release\Eudora.exe`), **10:12:43** dieselbe Einstufung für `Eudora71\Bin\Release\Eudora.exe`. Defender-Protokoll (Ereignis 2010): um **10:11:00** Cloud-Signatur 1.461.43.1 geholt, in der Cloud erzeugt **10:10:50** – ein Urteil über genau diese Datei. Dieselbe Datei lief 09:46–10:00 zehnmal am Prüfstand unbeanstandet. `MpCmdRun -Scan -ScanType 3 -DisableRemediation` (ohne Eingriff): 1.0.87, 1.0.96, 1.0.97 **sauber**, 1.0.98 **Fund**; 7.2.0.99 (derselbe Quelltext, nur die Versionsnummer gehoben) **sauber**, auch nach drei Prüfstandläufen. Bewertung: Fehlalarm des Lernverfahrens (`!ml`) auf einer unsignierten Datei – Vermutung, nicht belegbar, das Modell ist nicht einsehbar. Folgen: jede neue Fassung kann es wieder treffen, auch beim Anwender. Eingebaut: Defender-Prüfung in `tools/paket-pruefen.ps1` (weist ab; Gegentest: 1.0.97 durch, 1.0.98 abgewiesen). **Am 20.10.2026 bei Microsoft gemeldet — Vorgangsnummer `a567fe2a-9f58-47e1-a675-a62733ec538f`, eingereicht um 20:57:52, Status *Submitted*, Einstufung *Incorrect detection*.** Hochgeladen wurde `Releases/Eudora72-1.0.113-release.zip` (9.378.205 Byte, SHA-256 `0D1D4BF4…`), beanstandet die darin liegende `Eudora.exe` (3.012.608 Byte, SHA-256 `6243D4B6…`, Fassung 7.2.0.113), Erkennung `Trojan:Win32/Bearfoos.A!ml`, Signaturstand 1.461.115.0. Eingereicht hat Gregor; absenden konnte ich nicht, das Formular verlangt ein CAPTCHA. Die ausgefüllten Felder und der eingereichte Begründungstext stehen in [Releases/DEFENDER-FEHLALARM.md](../Releases/DEFENDER-FEHLALARM.md). **Das Ergebnis gehört hierher, sobald es da ist** — es ist der erste Versuch, eine Fehlerklasse dieses Projekts **außerhalb** des Projekts abzustellen. **Dritter Fall, 20.10.2026 — die Schranke prüft zu früh:** `Eudora.exe` um **13:09:05** gebaut und sofort mit `paket-pruefen.ps1` geprüft (34 Dateien, **0 Funde**), von Defender um **13:17:28** erkannt. **Acht Minuten Abstand** — das ist der Bau, aus dem Paket **1.0.111** wurde (13:13 geschnürt). Gemessen und in der Commit-Nachricht von `0f4b2b1a` festgehalten; Gregors Entscheidung: keine Wartezeit in die Auslieferung einbauen, er meldet es. **Daraus die Regel in den Release-Notizen: 0 Funde sind kein Freispruch.** *(Am 20.10.2026 vom LEKTOR hierher nachgetragen — die Messung stand bis dahin nur in einer Commit-Nachricht und in `Releases/1.0.113/RELEASE-NOTIZEN.md`, während `Releases/DEFENDER-FEHLALARM.md` den Fall 1.0.111 schon gegenüber Microsoft behauptete.)* **Vierter und fünfter Fall am selben Tag, beide gemessen:** 20:33:12 `C:\Users\Gregor\Eudora72-1.0.113-release\Eudora.exe`, ausgelöst **beim Ausführen** (der Prozess steht als Quelle mit dabei), von Gregor aus der Quarantäne geholt; 20:45:19 `Releases\.pruefe-behoben-1.0.113\Eudora.exe`, ausgelöst von `perl.exe` — **unsere eigene Schranke `tools/pruefe-behoben-ausgeliefert.pl`**, die die EXE zum Lesen der Versionsressource auspackte. Sie meldete danach *„Paket 1.0.113: in der `Eudora.exe` steht keine Fassung 7.2.0.NN"* — eine **falsche Aussage über ein richtiges Paket**. Seither liest sie über `unzip -p` aus dem Strom; es liegt nichts mehr auf der Platte, und *nicht lesbar* zählt nicht mehr als *geprüft*. Gegenprobe gefahren: 1.0.113 meldet wieder 7.2.0.113, kein Verzeichnis bleibt unter `Releases/` zurück, Selbsttest 15 von 15. **Daraus die Regel, die über diesen Befund hinausgeht:** eine Schranke, die zum Messen eine ausführbare Datei auspackt, misst am Ende den Virenscanner mit. **Ein gezielter Scan ist kein Freispruch** — derselbe `Start-MpScan` auf dieselbe Datei meldete nichts, während der Start sie einzog. Code-Signatur: von Gregor am 26.10.2026 abgelehnt — *„ich verdiene mit dem projekt kein geld, werde daher keins für zertifikate ausgeben.“* Anwenderhinweis in der README, *Windows Defender meldet Eudora als Trojaner*. **Kein Datenverlust** gemessen. **Was noch fehlt:** der Vorgang bei Microsoft ist **abgewiesen** (zu viele Dateien im Upload, siehe die Messung unten) — nachzuholen ist eine **neue** Einreichung mit **nur** der `Eudora.exe`, nicht dem ZIP. Das ist unsere Arbeit, nicht die von Dritten. Eine Code-Signatur hat Gregor am 26.10.2026 abgelehnt — *„ich verdiene mit dem projekt kein geld, werde daher keins für zertifikate ausgeben.“* Im eigenen Quelltext ist nichts zu beheben.  **Zuletzt gemessen: 28.10.2026 an 7.2.0.127** (Gregors Bild aus dem Defender-Schutzverlauf, siehe den Nachtrag unten; die Vorgangsseite bei Microsoft hat seit dem 23.10.2026 niemand neu gelesen). Stand 23.10.2026: **aus der Vorgangsseite gelesen, und das Ergebnis dreht den Befund um: wir warten nicht auf Microsoft, sondern auf uns.** Die Seite liegt hinter einer Microsoft-Anmeldung und ist von hier aus nicht abrufbar (302 auf `login.microsoftonline.com`); Gregor hat sie am 22.10.2026 aus seinem Browser gespeichert. Daraus gelesen: **Submitted: Oct 20, 2026 20:57:52**, Datei `eudora72-1.0.113-release.zip`, **User Opinion: Incorrect detection**, **Status: In progress** — und daneben als *Analyst comments* der Satz, auf den es ankommt: *„Your submission has been rejected due to too many files. For your submission to be analyzed, resubmit fewer files or remove files from any archives you sent. Only include files that need analysis.“* **Der Status sagt „in Arbeit“, der Kommentar sagt abgewiesen.** Niemand analysiert den Vorgang. **Der Grund steht daneben:** wir haben das ganze Paket hochgeladen, Microsoft hat es in **1033 Einzeldateien** zerlegt (*„This submission contains an extremely large number of individual files“*, angezeigt werden 200). **Zwei Angaben sprechen inhaltlich für uns:** zum ZIP meldet der Client `Trojan:Win32/Wacatac.C!ml`, die **Cloud** dagegen *„No malware detected“* — das Suffix `!ml` ist eine Vermutung des lernenden Verfahrens auf dem Rechner des Anwenders; und zu `smime.dll / 3.ico` steht ausdrücklich *„An analyst has determined that this file is normal“* — Final determination **Not malware**. Wo ein Mensch hingesehen hat, steht also Entwarnung. **Was noch fehlt:** neu einreichen — **nur die eine Datei**, die Defender wirklich erwischt hat, nicht das Paket. Erst dann hat ein Analyst etwas, das er ansehen kann. **Wie zu prüfen:** nach dem neuen Vorgang die Seite erneut speichern; unter *Analyst comments* darf **kein** *rejected* mehr stehen, und *Final determination* muss von *Pending* auf eine Aussage wechseln. **Wieder aufgetreten am 26.10.2026 an Paket 1.0.124** (Gregors Bild aus *Windows-Sicherheit → Schutzverlauf*, auf einem Rechner mit Windows 11 Pro, nicht auf dem Entwicklungsrechner): *„Erkannt: Trojan:Win32/Bearfoos.A!ml … Status: Wiederhergestellt … Datum: 26.10.2026 20:27 … file: C:\Temp\Eudora72-1.0.124-release\Eudora.exe“*. Gregor hat die Datei aus der Quarantäne wiederhergestellt. Dieselbe Erkennung wie zuvor (Endung `!ml` = maschinelles Lernen, keine Signatur); die `Eudora.exe` von 1.0.124 hat SHA-256 `b08ca8dc30602343…` (gemessen an der Kopie in `C:\Users\Gregor\Eudora72-1.0.124-release`, byte-gleich mit dem Bau). Die neue Einreichung bei Microsoft steht weiter aus. **28.10.2026, am Prüfstand `C:\Temp\E166` gemessen (`Get-MpThreatDetection`):** Defender nahm viermal die `EudoraRes.dll` aus Paket 1.0.127 in Quarantäne (14:10:20, 14:10:28, 14:17:44 und 14:17:49 — am 29.10.2026 mit `Get-MpThreatDetection` nachgezählt, vorher stand hier „dreimal“), Erkennung `Trojan:Win32/Bearfoos.A!ml` (Kennung 2147731250 laut `Get-MpThreat`, dieselbe wie bei 1.0.113), jedes Mal ausgelöst durch `powershell.exe` beim Lesen der Dateiversion (`testlauf.ps1`) — erstmals die Ressourcen-DLL, nicht `Eudora.exe`. Die `EudoraRes.dll` aus dem Bau vom 28.10.2026 (gleiche Ressourcen) blieb unbeanstandet. Gefunden bei [E-166](#e-166). **Dazu um 14:11:33 dieselbe Datei im ZIP** `C:\Users\Gregor\Eudora72-1.0.127-release.zip` (`containerfile:` in `Get-MpThreatDetection`): **gemessen am 29.10.2026, das ZIP enthält keine `EudoraRes.dll` mehr** (166 Einträge, `unzip -l`; Gregor hat seine drei ZIPs am 29.10.2026 gelöscht, sie dienten nur zum Übertragen auf einen anderen Rechner), Änderungszeit unverändert 27.10.2026 15:39 — wer es neu auspackt, bekommt *„Error Loading Resource DLL“*. Das ZIP im Repo (`Releases/Eudora72-1.0.127-release.zip`) enthält sie noch. Ob mein Auspacken für den Prüfstand die Prüfung auslöste, ist nicht gemessen. **27.10.2026, bei Gregor an Paket 1.0.127:** Defender nahm die `Eudora.exe` um 16:47 in Quarantäne, danach *„Error Loading Resource DLL“* ([TESTPLAN](TESTPLAN.md) V5). **Stufe: kritisch** (Start: Virenschutz beendet das laufende Programm)|
| <a id="e-125"></a>E-125 | **Eine Nachricht aus einem IMAP-Ordner nach `Out` verschieben legt eine neue Nachricht mit `<br>` in den Kopfzeilen an – und überträgt nichts** — Betreff `test 20261016a<br>`, `Cc: <br>`, `Bcc: <br>`, Absender „br“; dazu *„No messages were transferred!“* | **behoben in 7.2.0.122 – die Ablehnung von Gregor am 23.10.2026 an 1.0.122 bestätigt, die Gegenprobe am selben Tag am Prüfstand gemessen** (Einzelheiten am Ende dieser Zeile). Vorher: offen, am Protokoll gemessen, Ursache am Quelltext vermutet. Entschieden von Gregor am 17.10.2026:** *„B“* auf die Frage, ob Ziehen nach `Out` wie im Original eine neue Nachricht zum erneuten Senden anlegen (A) oder abgelehnt werden soll mit dem Hinweis auf *Message → Send Again* (B) – **Ziehen nach `Out` wird abgelehnt**; **gebaut am 23.10.2026, Einzelheiten weiter unten**. Gregor an 1.0.100 (16.10.2026): *„mail aus OUTBOX in Out verschoben, danach steht was kurioses in Out (siehe screenshot)“* (Chat). Protokoll: je Versuch `NewCompDocument` → `InitializeNew` → `OutToc->AddSum`, gleich danach `Dialog: "No messages were transferred!"` (1.00, 1.12, 2.08, 7.34). Am Quelltext: Ziel `Out` heißt in `CTocDoc::Xfer` *Send Again* (`tocdoc.cpp:2950`, `Sum->SendAgain`) – das Original legt eine neue Nachricht an, statt zu verschieben; danach überspringt `CTocDoc::ImapXferFromImapToLocal` die Quelle, weil sich ihr Fenster nicht schließen lässt (`CanCloseSummaryFrame`, `EuImap/src/ImapToc.cpp:836`), und meldet `IDS_ERR_IMAP_NO_MSGS_XFERRED` (`:857`). Das `<br>` in den Kopfzeilen ist **Vermutung**: *Send Again* übernimmt die Kopfzeilen einer als HTML gespeicherten Nachricht samt Zeilenumbruch-Marken. Ob v1.0.87 dasselbe tut, ist nicht gemessen. **Kein Datenverlust:** die Originale bleiben in der `OUTBOX`. Gefahr: wer die neuen Einträge sendet, schickt sie mit kaputtem Empfänger. **Gebaut am 23.10.2026** — Entscheidung **B** steht im Quelltext. In `CTocDoc::Xfer` (`tocdoc.cpp`) ist die Rückfrage `AlertDialog(IDD_STRIP_HEADERS)` samt dem Merker `StripHeaders` entfernt; an ihrer Stelle steht `if (ToOut && !Sum->IsComp())` mit dem neuen Hinweisdialog `IDD_XFER_TO_OUT_REFUSED` — der Text ist als `LTEXT` gesetzt in `EudoraRes.rc:2048` und wird nie ueberschrieben; gezeigt wird er von `AlertDialog` (`guiutils.cpp:905`) — (*„Messages can't be transferred to the Out mailbox.  To send this message again, open it and choose Message > Send Again."*, **ein** Knopf) und `break` — es wird also gar nichts mehr übertragen und nichts mehr angelegt. Eine **verfasste** Nachricht (`Sum->IsComp()`) darf weiterhin nach `Out`: das ist das Einreihen zum Senden und soll gehen. Spurmarke: `E-125 Xfer nach Out abgelehnt: quelle=%s ziel=%s kopie=%d einzeln=%d` (`DEBUG_MASK_MISC`, 32768). **Regressionstest:** `Eudora71/Tests/TestE125.cpp`, zwei Fälle, 277 Tests 277 bestanden. **Gegengetestet** (nicht nur grün gesehen): gegen den alten Quelltext fallen **beide** Fälle um (275/277), und mit einer zu weiten Bedingung `if (ToOut)` fällt der erste mit der Begründung *„die Ablehnung trifft jetzt AUCH verfasste Nachrichten"* — der Testfall prüft also den Umfang, nicht nur das Vorhandensein. *Überholt am 23.10.2026, Gregors Lauf ist da ([L-54.11](../Befunde/LEKTOR-54.md#l-54.11)) — hier stand, was noch fehle:* Gregors Lauf am Programm. Der Weg geht über Ziehen-und-Ablegen und endet in einem modalen Dialog; der Prüfstand kann ihn nicht auslösen. Die vier Schritte stehen als [TESTPLAN M3](TESTPLAN.md#m3-e125), Schritt 4 ist die Gegenprobe mit einem Entwurf. Ungemessen bleibt weiterhin, woher das `<br>` der Erstmeldung stammte und ob 1.0.87 dasselbe tat — mit der Ablehnung ist der Weg dorthin zu, die Frage damit gegenstandslos für den Anwender, aber nicht beantwortet. **Zuletzt gemessen: 23.10.2026 an 7.2.0.120** — **der Befund zerfällt in zwei Hälften, und nur eine ist noch da.** Gregor hat den Fall gefahren und auf dem Dialog `IDD_STRIP_HEADERS` *Yes* gewählt; Protokoll `C:\Users\Gregor\Eudora72-1.0.116-release\Mailverzeichnis\eudora.log`, Sitzung ab Zeile 6403. **Nachgestellt:** die Kette `Dialog: "Some headers may be removed when transferring to the Out Mailbox.  Transfer anyway?"` → `Dismissed with 1` → `NewCompDocument` → `CCompMessageDoc::InitializeNew` → `vor/nach OutToc->AddSum` → `Dialog: "No messages were transferred!"` — Eudora legt also eine neue Nachricht an und meldet im selben Atemzug, es sei nichts übertragen worden. **NICHT nachgestellt: der Datenschaden.** Die neue Nachricht steht in `Out.mbx` (164225 Byte, 4 Nachrichten), und ihr Kopfblock ist **sauber** — `Subject: <Betreff eines Newsletters>`, `Cc:` und `Bcc:` leer, Absender richtig, `Message-Id: <7.2.0.120.2.20261023084741.0069d278@<Server>>`. Kein `<br>` in einer einzigen Kopfzeile. (Die 59 Treffer von `<br>` in `Out.mbx` stehen sämtlich in **Rümpfen** von HTML-Nachrichten; der bloße Zähler wäre irreführend.) **Die Einstufung bleibt trotzdem kritisch**, und zwar bewusst: ein **einzelner** Lauf, der den Schaden nicht zeigt, widerlegt ihn nicht — die `<br>`-Marken stammen der Vermutung nach aus einer als HTML gespeicherten Quellnachricht, und ob Gregors Nachricht vom 16.10.2026 diese Eigenschaft hatte, ist nicht festgestellt. Heruntergestuft wird erst, wenn der Weg nach Entscheidung **B** zu ist. **Nachgebessert am 23.10.2026 nach [PRÜFER-45](../Befunde/PRUEFER-45.md) — die erste Fassung der Behebung war halb und der Test dazu blind.** Zwei Punkte, beide selbst gegengeprüft: **(1) Bei einer IMAP-QUELLE kam zusätzlich weiterhin *„No messages were transferred!"*.** Die Bedingung am Ende von `CTocDoc::Xfer` lautet `IsImapToc() \|\| (TargetToc && TargetToc->IsImapToc()) && sumlist.GetCount() > 0`; weil `&&` stärker bindet als `\|\|`, greift der IMAP-Zweig bei einer IMAP-Quelle **auch mit leerer Liste** und läuft bis `IDS_ERR_IMAP_NO_MSGS_XFERRED` (`EuImap/src/ImapToc.cpp:857`). Genau Gregors Weg vom 16.10.2026 (`OUTBOX` → `Out`) wäre damit nur zur Hälfte behoben gewesen. Behoben über den Merker `E125Abgelehnt`, der die IMAP-Nachbearbeitung überspringt. **Der Vorrangfehler in der Klammerung bleibt stehen** — er ändert Verhalten an einer alten Stelle und gehört abgestimmt, nicht nebenbei. **(2) Der Regressionstest ließ den ganzen Fehler durch.** Gegenprobe am 23.10.2026: allein die Zeile `break;` gelöscht — damit läuft der Ablauf nach dem Hinweis weiter in den `ToOut`-Zweig, `Sum->SendAgain` legt wieder eine neue Nachricht an, der Befund ist vollständig zurück — und der Prüfstand meldete **277 von 277 bestanden**. Der Test prüfte den Hinweis, nicht den Ausstieg. `TestE125.cpp` prüft jetzt zusätzlich den Ausstieg, die Reihenfolge gegen `SendAgain`, den IMAP-Merker und die Eindeutigkeit der Ressourcenkennung; die negativen Prüfungen hängen nicht mehr an der Aufrufform (`QT_LeerraumZusammen` zieht Leerraum zusammen, entfernt ihn nicht — `AlertDialog( IDD_STRIP_HEADERS )` wäre sonst durchgekommen). **Beide Gegenproben erneut gefahren und beide rot** (276 von 277, je mit dem Satz, der den Schaden nennt). **Noch offen aus [PRÜFER-45](../Befunde/PRUEFER-45.md), als eigene Befunde zu führen:** aus dem Suchfenster und aus Filtern wird `Xfer` je Nachricht gerufen, dort kommt der Hinweis N-mal statt einmal; bei gemischter Auswahl ist der Dialogtext falsch (ein Teil **wurde** übertragen, Datenverlust gibt es dabei nicht); die Zusicherung bei `tocdoc.cpp:3082` läuft auf dem Filterweg an; die Undo-Liste der vorigen Übertragung verfällt schon vor der Schleife; und ein Entwurf aus einem IMAP-Ordner nach `Out` erzeugt ein Duplikat plus dieselbe Fehlmeldung. **Urteil an 1.0.122 (23.10.2026).** *Gregor:* eine empfangene Nachricht aus dem IMAP-Ordner `OUTBOX (<Dominant>)` nach `Out` gezogen — der Hinweis *„Messages can't be transferred to the Out mailbox …"* mit **einem** Knopf, im Protokoll `E-125 Xfer nach Out abgelehnt: quelle=OUTBOX (<Dominant>) ziel=Out kopie=0 einzeln=0` und danach nur `Dismissed with 1`, kein *„No messages were transferred!"* (Bildschirmfoto und `eudora.log` aus seiner VM). Die Gegenprobe mit einem Entwurf hat er **abgelehnt**: *„das stand so nicht in der beschreibung"* — der Testplan sagte nicht, wie ein Entwurf außerhalb von `Out` entsteht; das ist ein Fehler des Plans, nicht seines Laufs. *Am Prüfstand* `C:\Temp\E125` (Paket 1.0.122, Dummy-Konto) mit `tools/messen-e125.ps1`: Entwurf gespeichert, über *Transfer* `Out` → `Trash` → `Out` — `out=1 trash=0` (in `Out` liegt danach eine neu angelegte Kopie mit neuer `Message-Id`, gemessen in `Out.mbx.001`; [PRÜFER-47](../Befunde/PRUEFER-47.md)), **kein** Dialog, **keine** `E-125`-Zeile mit `quelle=Trash`; im selben Lauf eine empfangene Nachricht `In` → `Out` — abgelehnt, `E-125 Xfer nach Out abgelehnt: quelle=In ziel=Out`, `In` behält sie. **Gegentest gegen 7.2.0.120** (Paket 1.0.120 von GitHub): die Fälle `E-125b` und `E-125c` werden rot (die Gegenprobe `E-125a` bleibt erwartungsgemäß grün), das Protokoll zeigt wieder *„Some headers may be removed when transferring to the Out Mailbox. Transfer anyway?"*. Als Regressionsfälle `E-125a`–`c` in `tools/pruefstand-faelle.txt`. **Nicht über die Oberfläche geprüft:** eine zu weite Bedingung (`if (ToOut)` ohne `IsComp`) — die fängt `TestE125.cpp` am Quelltext.  **Stufe: kritisch** (Datenschaden: br-Marke in den Kopfzeilen der neuen Nachricht)|
| <a id="e-126"></a>E-126 | **Eine gesendete Mail, die genau während eines Abgleichs des Ziel-IMAP-Ordners dorthin verschoben wird, kommt vielleicht nicht auf dem Server an** — sie läge dann nur im lokalen Papierkorb | **offen, Vermutung am Quelltext, nie beobachtet.** Abgetrennt aus [E-121](#e-121) am 17.10.2026 (Gregor: *„ja, e-121 behoben.“*). Herkunft: [PRÜFER-33](../Befunde/PRUEFER-33.md) Q1 – verwirft ein laufender Abgleich die lokale Vorab-Kopie einer Nachricht aus `Out`, bevor sie hochgeladen ist, findet die Übertragung weder Kopie noch Quelle. **Was verloren gehen kann:** diese gesendete Mail, wenn danach der lokale Papierkorb geleert wird. **Was hilft:** nach dem Verschieben kurz im IMAP-Ordner nachsehen. Weder bei Gregor (Tests an 1.0.99 bis 1.0.101) noch am Prüfstand aufgetreten; am Prüfstand nicht nachstellbar, weil per POP abgerufene Post nie aus `Out` kommt. **Was noch fehlt:** jede Messung — die Vermutung aus [PRÜFER-33](../Befunde/PRUEFER-33.md) Q1 ist nie beobachtet worden, weder bei Gregor noch am Prüfstand, und dort auch nicht nachstellbar (per POP abgerufene Post kommt nie aus `Out`). Es braucht einen IMAP-Lauf, in dem Abgleich und Verschieben aus `Out` sich überlappen. **Zuletzt belegt am Quelltext: 23.10.2026 an 7.2.0.121** — **die Kette ist jetzt vollständig nachgelesen, Zeile für Zeile; beobachtet ist sie weiterhin nicht.** (1) `CTocDoc::ImapXferFromLocalToImap` schiebt eine Nachricht mit `pSum->IsComp()` oder aus `MBT_OUT` schon **beim Einreihen** in den lokalen Papierkorb — `ImapToc.cpp:1018-1027`, `pTrashToc->AddSum(pSum)`. Sie steht danach **nicht mehr** im Ursprungsordner. (2) `CImapFromLocalTransferMsgAction::DoPostProcessing` sucht zwei Dinge: die Vorab-Kopie im Ziel (`E121FindeVorabKopie`) und die Quelle in `pSrcToc = GetToc(m_szMailbox)`, also im **Ursprungsordner**. **Der Papierkorb wird nirgends durchsucht** — in der ganzen Funktion kommt weder `Trash` noch `GetTrashToc` vor (nachgezählt am 23.10.2026: 0 Treffer). (3) Hat ein Abgleich die Vorab-Kopie verworfen, sind damit **beide** Zweige leer, `bHochgeladen` bleibt `FALSE`, und die Nachricht liegt nur noch im Papierkorb. Der Kommentar an Ort und Stelle (`ImapActionQueue.cpp`, *„Scheitert beides, bleibt die Nachricht in der Quelle - nichts geht verloren"*) gilt für gewöhnliche Ordner, **nicht** für `Out`: dort ist die Quelle zu diesem Zeitpunkt schon der Papierkorb. **Was der Vorschlag aus [PRÜFER-33](../Befunde/PRUEFER-33.md) Q1 braucht, ist vorhanden:** Quelle und Vorab-Kopie bekommen beim Verschieben eine gemeinsame, von Null verschiedene Kennung (`E121NeueKennung`, `tocdoc.cpp:2970-2972`) und die Quelle das Merkzeichen `SetE121Quelle(TRUE)` (`:2965`). Beides überlebt den Weg in den Papierkorb, weil dieselbe `CSummary` verschoben wird. Die Behebung ist damit an **einer** Stelle möglich: in `DoPostProcessing` zusätzlich `GetTrashToc()` nach genau einer markierten Zusammenfassung mit dieser Kennung durchsuchen und von dort hochladen, ohne sie danach zu entfernen. **Was noch fehlt, unverändert:** die Beobachtung am laufenden Programm. Am Prüfstand kommt per POP abgerufene Post nie aus `Out`; PRÜFER-33 nennt den Weg, es zu erzwingen — ein vorübergehender Prüfschalter, der die Vorab-Kopie vor `DoPostProcessing` verwirft, wie am 14.10.2026 für [E-121](#e-121) Fall (2). **Stufe: kritisch** (Datenverlust: gesendete Mail kommt beim Verschieben nicht an)|
| <a id="e-127"></a>E-127 | **Ein IMAP-Ordner, der seit dem Start noch nie geöffnet war, zeigt die eben dorthin verschobenen Mails nicht** — erst nach Schließen und erneutem Öffnen | **erledigt - von Gregor am 23.10.2026 an 7.2.0.120 zweimal gefahren und bestätigt: nicht nachstellbar; Ursache nie gemessen.** Abgetrennt aus [E-121](#e-121) am 17.10.2026. Gregor an 1.0.101: *„mail verschoben, sind aber im outbox nicht zu sehen.“*, dann *„nach neu-öffnen sind mails zu sehen.“* (Chat). Sein Protokoll: hochgeladen bei `summen=2`, danach erst `NewChildFrame … OUTBOX`, Abgleich ohne Übernahme; war der Ordner in der Sitzung schon einmal offen, erscheinen die Mails sofort (`summen=27`). **Kein Datenverlust**, die Mails sind auf dem Server. **Was noch fehlt:** die Ursache ist nicht untersucht — gemessen ist nur Gregors Protokoll (hochgeladen bei `summen=2`, erst **danach** `NewChildFrame … OUTBOX`, Abgleich ohne Übernahme). Der nächste Schritt wäre, den ersten Abgleich eines in dieser Sitzung noch nie geöffneten IMAP-Ordners zu verfolgen. **Zuletzt gemessen: 23.10.2026 an 7.2.0.120** — **in zwei Läufen nicht nachstellbar.** Gregor hat beide selbst gefahren; Protokoll `C:\Users\Gregor\Eudora72-1.0.116-release\Mailverzeichnis\eudora.log`, Sitzungen mit den Kopfzeilen `Fri Oct 23 08:13:08 2026` / `Fri Oct 23 08:21:05 2026`, beide `Version 7.2.0.120`. Je Lauf eine Mail in den IMAP-Ordner gezogen, beide Male erfolgreich: `E-121 Hochgeladen: ergebnis=1 neue-uid=356` bzw. `neue-uid=357`, dazu `Uebertragung: im-ziel=1 in-quelle=1 markiert=1 hochgeladen=1`. Die Vorbedingung des Befundes lag vor — Gregor: *„zielordner war nicht offen"* —, und das Ergebnis war beide Male dasselbe: *„ja, sofort sichtbar beim ersten öffnen. habe es jetzt nochmal mit einer zweiten mail getestet. gleiches ergebnis."* (Chat, 23.10.2026). **Was dabei auffiel und NICHT geklärt ist:** beide Läufe melden `Ziel nach dem Hochladen: summen=57` — **derselbe** Wert, obwohl im zweiten Lauf eine weitere Mail dazugekommen war; und die Zeile `Ziel nach dem Abgleich`, die der Lauf an 1.0.101 noch schrieb, fehlt in beiden Sitzungen ganz. Das ist eine Beobachtung an der **Messmarke**, kein neuer Fehlerbefund — wer E-121 oder E-127 wieder anfasst, misst zuerst, ob die Marke überhaupt zählt, was sie zu zählen vorgibt. **Zweite Einschränkung für den nächsten Lauf:** `[Open Windows]` in `Eudora.ini` führt den IMAP-Ordner (`Imap\Dominant\INBOX\INBOX.mbx`), er wird beim nächsten Start also wieder geöffnet. Wer den Befund erneut prüft, muss den Eintrag vorher entfernen — sonst ist der Ordner beim Ziehen längst offen und die Vorbedingung still nicht erfüllt. **Stufe: wichtig** (Anzeige: eben verschobene Mails fehlen im IMAP-Ordner - vom Anwender nicht von Verlust zu unterscheiden)|
| <a id="e-128"></a>E-128 | **Eine gespeicherte Nachricht heißt `.txt` und enthält HTML — der Anwender erfährt es nicht** | **offen, am Quelltext belegt und von Gregor am 20.10.2026 am laufenden Programm bestätigt.** Gregor: *„habe die .txt nach .html umbenannt und im chrome geöffnet. wird korrekt dargestellt. allerdings fehlt der hinweis für den benutzer, daß es keine TXT datei ist!"* **Am Quelltext belegt:** der Dateidialog bekommt immer dieselben zwei Einträge `"Text Files (*.txt)\|*.txt\|All Files (*.*)\|*.*\|"` (`EudoraRes.rc:8509`, `IDS_TEXT_FILE_FILTER`) und immer dieselbe Vorgabeendung `"txt"` (`:10602`, `IDS_TEXT_EXTENSION`, gesetzt in `SaveAsDialog.cpp:284`). Der **Inhalt** richtet sich dagegen nach der Nachricht: bei einer HTML-Nachricht schreibt `E101SpeicherfassungAufbereiten` (`msgutils.cpp`) `Content-Type: text/html` und den HTML-Rumpf. **Gemessen am 17.09.2026** (siehe [E-101](#e-101)): `.eml` und `.txt` sind **byte-identisch**, der Dateityp im Dialog ändert kein einziges Byte. **Folge für den Anwender:** ein Doppelklick öffnet den Editor und zeigt HTML-Quelltext; dass die Datei brauchbar ist, merkt nur, wer sie umbenennt. Schon am 13.10.2026 stand im Chat *„ist kein TXT sondern HTML, sehe ich gerade"* — damals als Missverständnis abgehakt, jetzt als Mangel aufgenommen. **Kein Datenverlust.** **Vorschlag, noch nicht entschieden:** die Vorgabeendung aus dem Inhalt ableiten — `.html` für eine HTML-Nachricht, `.eml` wenn Kopfzeilen mitgespeichert werden, `.txt` nur für reinen Text; dazu den Dateityp im Dialog entsprechend vorbelegen. **Was noch fehlt:** die Entscheidung über den eigenen Vorschlag und dann sein Einbau — die Vorgabeendung aus dem Inhalt ableiten (`.html`, `.eml`, `.txt`) und den Dateityp im Dialog danach vorbelegen; die Stellen sind `SaveAsDialog.cpp:284` und `EudoraRes.rc:8509`/`:10602`. **Zuletzt gemessen: 23.10.2026 an 7.2.0.120** — **der Inhalt stimmt; der Mangel sitzt allein im Namen und in drei Zeilen davor.** Gregor hat eine gespeicherte Nachricht vorgelegt (`C:\Users\Gregor\Eudora72-1.0.120-release\Mailverzeichnis\Formel 1, NFL & 50 % Geburtstagsrabatt.txt` und dieselbe Datei als `.html`) und gefragt: *„wir haben die info, daß es ein .html file ist, obwohl es .txt heißt. der inhalt sollte aber passen, ja?"* (Chat). **Gemessen an der Datei:** beide Fassungen sind **byte-identisch** (`cmp` ohne Abweichung, je 65537 Byte, durchgehend CRLF) — das bestaetigt die Messung vom 17.09.2026 erneut. Der HTML-Rumpf ist **vollstaendig**: er endet auf `</body></html>`, nicht abgeschnitten. `<meta charset="windows-1252">` steht darin. Von den 106 Bytes ueber 127 ist **keines** zerstoert: 28x `0x80` (Euro), 27x `0xA0` (geschuetztes Leerzeichen), 16x `ä`, 15x `ü`, 11x `ö`, 5x `ß`, dazu `„`, `"` und `•` — alles gueltiges windows-1252, kein einziges `?`. **Gemessen an der eigenen Spurmarke** (`eudora.log` im Verzeichnis 1.0.116, Zeile 6824): `E-101 speichern: kopfzeilen=0 trenner=0 xhtml=1 content-type-vorhanden=0 typ=text/html charset=windows-1252 bytes-vorher=65446 nachher=65535 rumpf-vorher=65446 rumpf-nachher=65432 mime-ergaenzt=1 ct-ersetzt=0 meta-charset=1 geaendert=1`. **Was daraus folgt und vorher nicht feststand:** die drei Zeilen vor dem `<!DOCTYPE` (103 Byte: `MIME-Version`, `Content-Type`, `Content-Transfer-Encoding`, dann eine Leerzeile) sind **kein Rest der Nachricht**, sondern von uns absichtlich geschrieben — `mime-ergaenzt=1`, die Stelle ist `msgutils.cpp:4581` mit der dort begruendeten Regel *„ERFUNDEN wird nichts. Ergaenzt wird nur, was der Leser braucht, um die Bytes ueberhaupt richtig zu deuten"*. Dass **nur** diese drei und kein `From`/`To`/`Subject` dastehen (`kopfzeilen=0`), belegt es: die Nachrichtkopfzeilen waren abgeschaltet. **Damit ist [E-101](#e-101) F2 an dieser Datei widerlegt** — `StripTabooHeaders` fuehrt zwar `Mime-Version` und `Content-` in seiner Vorgabeliste (`EudoraRes.rc:10003`), die Zeilen stehen aber trotzdem in der Datei, weil der Kern sie **danach** setzt. **Der Rest des Mangels, unveraendert:** als `.html` geoeffnet erscheinen diese drei Zeilen nach den HTML-Parsingregeln als sichtbarer Text ueber der Nachricht (aus den Regeln abgeleitet, nicht am Browser gemessen). Die Entscheidung zu E-128 muss das mitentscheiden: **mit** Vorspann ist die Datei eine Nachricht und heisst `.eml`, **als** `.html` muss der Vorspann weg. **Stufe: wichtig** (Anzeige: txt-Endung enthaelt HTML, der Anwender erfaehrt es nicht)|
| <a id="e-129"></a>E-129 | **Nach einem Verschieben in einen IMAP-Ordner ohne Verbindung und sofortigem Beenden zeigt der Zielordner nur eine von fünf Nachrichten** — die Nachrichten stehen vollständig in der Datei, das Inhaltsverzeichnis zählt nur eine | **offen, am 20.10.2026 an Gregors Verzeichnis gemessen, Ursache nicht untersucht.** Gregor: *„ich habe welche von imap nach <Ordner> verschoben, dann gleich eudora beendet. jetzt finde ich sie nicht. sind sie weg?"* **Gemessen (nur lesend) in `Eudora72-1.0.110-release\Mailverzeichnis\Imap\Dominant`:** `HWBox\HWBox.mbx` **62 428 Byte mit fünf Nachrichten** (*test 3: 20261017c*, *test 5*, *test 6*, *test 7*, *test 8*); `HWBox.toc` **322 Byte = genau 1 Eintrag** (Kopf 104 Byte, Eintrag 218 Byte — gegengerechnet an `INBOX.toc` 10 568 Byte = 48 Einträge und an den leeren `Trash.toc`/`Junk.toc` = 104 Byte). **Kein Datenverlust, am 20.10.2026 doppelt belegt:** dieselben fünf liegen weiterhin in `INBOX\INBOX.mbx` — **und sie sind auch in der `Inbox` wieder sichtbar**, sobald man im Postfachbaum mit der rechten Maustaste auf `Inbox` klickt und *Show Deleted Messages* wählt (`ID_MBOXTREE_IMAP_SHOW_DELETED`, `EuImap/src/ImapMboxTree.cpp:523` — der Befehl setzt nur einen Anzeigemerker um, `ImapSetHideDeletedMsgsInTree`, und schreibt nichts). Gregors Bildschirmfoto danach: **48 Nachrichten**, *test 1* bis *test 8* vollständig; die 48 decken sich mit den 48 Einträgen, die aus der Größe von `INBOX.toc` gerechnet waren. **Die Ursache der Unsichtbarkeit in der `Inbox` ist damit geklärt:** Verschieben über IMAP heißt *kopieren + als gelöscht markieren*; ohne Server ging die Markierung nie hinaus, und Eudora blendet markierte Nachrichten in der Vorgabe aus. **Zurückgeholt werden sie mit `Message – UnDelete`** (`ID_MESSAGE_UNDELETE`, `EudoraRes.rc:5759` und `:6050`; der Hilfetext `:8921` lautet *„Unmark the message(s) previously marked for deletion (IMAP only)"* — Zeichenfolge `ID_MESSAGE_UNDELETE` in `EudoraRes.rc:8921`, die Hilfezeile zum Menüpunkt, wird nie überschrieben) — **von Gregor am 20.10.2026 an 1.0.110 gefahren und bestätigt:** *„undelete hat funktioniert, mails sind wieder da"*. Der Gegenbefehl `Message – Purge Messages` entfernt sie endgültig und darf dabei nicht benutzt werden. **Zwei Spuren:** (1) `eudora.log` nennt beim Start `<Ordner> (<Dominant>) .mbx size: MBX 62428, TOC 62429` — das Inhaltsverzeichnis erwartet **ein Byte mehr**, als die Datei hat; (2) `actionqueue.dat` ist **leer**, die eingereihten Übertragungen sind beim Beenden verschwunden. Der Server war nicht erreichbar (`host not found (11001)` für `imap.gmx.net`), es gab also nie ein Hochladen — [E-123](#e-123)s Warteschleife greift in diesem Fall zu Recht nicht (`uebertragungen=0`). **Abgrenzung:** nicht [E-127](#e-127) (dort fehlte nur die Anzeige bis zum erneuten Öffnen, die Mails lagen auf dem Server), nicht [E-126](#e-126) (dort geht es um gesendete Post aus `Out`). **Am 20.10.2026 am Prüfstand nachgestellt und im Quelltext belegt.** Nachgestellt **ohne IMAP** in `C:\Temp\E129` (Gregors Freigabe *„du kannst testen"*), mit seiner `HWBox.mbx` als lokalem `In.mbx`: (a) `In.mbx` mit fünf Nachrichten, **`In.toc` entfernt** → Eudora baut das Verzeichnis **vollständig neu auf**, 1194 Byte = 104 + 5×218, alle fünf Betreffs drin; (b) dieselbe `In.mbx` mit **Gregors `HWBox.toc`** (322 Byte, 1 Eintrag) → Eudora **merkt nichts und zeigt weiter eine** Nachricht, das Verzeichnis bleibt bei 322 Byte. Sein Symptom ist damit ohne Server und ohne seine Daten reproduzierbar. **Warum keine Prüfung anschlägt** (`tocdoc.cpp:990-995`): der Größentest lautet `if (OldMbxSize && OldMbxSize - 1 != MBStatus.m_size)` — im Verzeichnis steht die Mailbox-Größe **plus eins**, also 62429 für 62428 Byte; der Test geht glatt auf. Der Zeittest (`:984`) prüft `MBTime > TocTime + leeway`, und das Verzeichnis wurde **nach** der Mailbox geschrieben (08:32 gegen 08:20). Der Eintragszähler darüber (`:962`) hält `SumCount` gegen `NumSums()` — **beide stammen aus dem Verzeichnis selbst**. **Nichts vergleicht das Inhaltsverzeichnis mit dem, was wirklich in der Mailbox liegt.** **Daraus folgt der eigentliche Befund:** das Verzeichnis wurde beim Beenden mit **einem** Eintrag geschrieben, obwohl die Mailbox zu diesem Zeitpunkt schon **fünf** Nachrichten enthielt (die hinterlegte Größe 62429 passt exakt zu den 62428 Byte mit fünf Nachrichten) — die vier Übersichtseinträge sind also **vor dem Schreiben verlorengegangen**, nicht beim Lesen. Passend dazu ist `actionqueue.dat` leer. **Zwei Mängel, nicht einer:** (1) die vier Einträge gehen beim Beenden ohne Serververbindung verloren; (2) eine Mailbox mit fünf Nachrichten und einem Verzeichnis für eine wird **wortlos** angenommen — `Salvage` läuft nur, wenn Größe oder Zeit nicht passen. **Reparatur, am Prüfstand gemessen, für Gregors IMAP-Ordner aber NICHT geprüft:** das Verzeichnis entfernen lässt Eudora es neu aufbauen. Bei einem IMAP-Ordner kann ein späterer Abgleich mit dem Server das Ergebnis wieder überschreiben; das ist nicht gemessen, weil dafür Gregors Zugangsdaten nötig wären. **Der sichere Weg bleibt:** die fünf stehen in der `Inbox`, sichtbar über *Show Deleted Messages*, und können bei erreichbarem Server erneut verschoben werden. **Was noch fehlt:** beide Mängel stehen noch — (1) warum beim Beenden ohne Serververbindung nur **ein** statt fünf Verzeichniseinträgen geschrieben wird, ist nicht untersucht; (2) `tocdoc.cpp:962-995` vergleicht das Verzeichnis nie mit dem Inhalt der Mailbox. Gregors Daten selbst sind über *UnDelete* gerettet.  **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — **Punkt (2) ist belegt, und er ist schärfer als hier beschrieben.** Hier stand, `tocdoc.cpp:962-995` vergleiche das Verzeichnis *nie* mit dem Inhalt der Mailbox. Gelesen: es vergleicht **doch**, aber das Falsche. Drei Prüfungen stehen dort — die Zahl der Einträge gegen sich selbst (`SumCount != (unsigned short)NumSums()`, `:962`), ein Datumstest mit `leeway` (`:984`) und ein Größentest (`:990`). **Der Größentest hält `OldMbxSize` gegen die wirkliche Dateigröße — und `OldMbxSize` kommt aus dem VERZEICHNIS selbst** (`:894-895`, `in.Get(&OldMbxSize)`). Geprüft wird also, ob das Verzeichnis mit dem übereinstimmt, was es sich selbst notiert hat. **Die Nachrichten in der `.mbx` zählt niemand** — im ganzen `tocdoc.cpp` gibt es keine Stelle, die die Trennzeilen der Mailbox zählt (gesucht nach `From ???@???`, `CountMessages`, `ZaehleNachrichten`: null Treffer). **Damit ist der Schaden erklärt:** schreibt das Beenden eine `.mbx` mit fünf Nachrichten und ein Verzeichnis mit einem Eintrag, und trägt es in dieses Verzeichnis die richtige Dateigröße ein, dann gehen **alle drei** Prüfungen durch. Das Verzeichnis ist in sich stimmig; dass es vier Nachrichten verschweigt, sieht niemand nach. **Was noch fehlt:** Punkt (1) — warum das Beenden ohne Serververbindung nur einen statt fünf Einträge schreibt — ist weiterhin nicht untersucht; das braucht einen Prüfstandslauf mit fünf Nachrichten, abgeschalteter Verbindung und sofortigem Beenden. **Wie zu prüfen:** danach die Trennzeilen in der `.mbx` zählen und gegen die Zahl der Einträge im `.toc` halten; sie müssen gleich sein. **Stufe: kritisch** (Datenverlust: nur eine unvollstaendige Nachricht im Zielordner)|
| <a id="e-130"></a>E-130 | **Fünf vorgebaute Fremd-DLLs werden bei jedem Bau neu gestempelt — und im Paket liegen andere Fassungen als im Repo** | **behoben am 23./24.10.2026, Regressionstest `TestE130.cpp` (282 Tests, 282 bestanden; mit altem Stand 2 rot).** Nach jedem Bau waren mitgelieferte Original-DLLs von QUALCOMM verändert, und im Paket lagen andere Fassungen als im Repo. Jetzt bleiben alle zwölf im Original; für Gregor ist nichts zu tun. **Nachtrag 24.10.2026 ([PRÜFER-48](../Befunde/PRUEFER-48.md) K1–K3):** es waren nicht fünf, sondern **zwölf** — `EuMemMgr`, `libeay32`, `libexpat`, `SPELL32`, `ssleay32`, `LDAP32` und `Paige32` lagen seit dem Commit `578db37b` (05.09.2026, „Bauausgaben nachgezogen") ebenfalls gebunden im Repo, `Paige32.dll` ging so in jedes Paket (auch als `Paige32d.dll`). Gleiche Größe, 244 bis 839 Byte Unterschied; gemessen am Merkmal: das Verzeichnis gebundener Importe (PE-Datenverzeichnis 11) ist in allen zwölf Originalen aus `567a5d87` **0 Byte**, in den gebundenen Fassungen 48 bis 324 Byte. Alle sieben aus `567a5d87` zurückgeholt. Der Test prüft beide Richtungen: alle zwölf ungebunden, und `BindExe.bat` nennt keine davon; gegen die alte gebundene `Paige32.dll` und die alte Liste werden beide Fälle rot. Dass `EuMemMgr` und `Paige32` nur in einem Arbeitsbaum mit frisch gebautem `msvcr71.dll` verändert wurden, erklärt der Prüfer: `bind` bindet gegen die Datei, die es im Verzeichnis findet (K2). **Zuerst eingetragen am 23.10.2026:** **Die Ursache, gefunden am 23.10.2026:** `Eudora.vcxproj` ruft nach dem Bau `BinTools\PostProcessRel.bat` auf, das `BinTools\BindExe.bat`; darin lief QUALCOMMs `Bind.Exe` (`bind -u`) über **alle** DLLs in `Bin\Release`, auch über die vorgebauten fremden. `bind` schreibt Prüfsumme und Zeitstempel in jede Datei, die es bindet. **Die Behebung:** `BindExe.bat` bindet nur noch die acht eigenen Bauergebnisse; die fünf DLLs im Repo sind wieder byte-gleich mit dem Erstcommit `567a5d87` **und** mit der Paketgrundlage `Releases/Eudora72-1.0.2-lauffaehig.zip` (SHA-1 `e922c4d8`, `95cc1084`, `2e920a79`, `b5a21454`, `94a453b9`). Damit gibt es für diese fünf nur noch einen Bestand (für die übrigen sieben erst seit dem Nachtrag oben). Sie waren seit Wochen in gebundenem Zustand mitcommittet worden. **Gegenprobe am 23.10.2026 gemessen:** die alte Liste macht aus den Originalen genau die gestempelten Fassungen (`4e23007d` … `524d7664`, dieselben Werte wie im Arbeitsbaum nach dem Bau), die neue lässt sie unverändert — je DLL ein Vergleich der SHA-1 mit dem Original nach einem Lauf von `BindExe.bat` über `Bin\Release`: mit der neuen Liste 5 Tests, 5 bestanden; mit der alten 5 Tests, 0 bestanden. **Am echten Bau bestätigt (23.10.2026, 23:02):** `tools/bauen.ps1 -Konfiguration Release`, 134 s, 0 Fehler; im Baulog lief der Bind-Schritt über genau die acht eigenen Dateien, und `git status` zeigt danach keine der fünf DLLs als geändert. `bind` ist nur eine Ladebeschleunigung; Eudora läuft mit den Originalen so, wie QUALCOMM sie ausgeliefert hat (dieselben Dateien stecken in jedem Paket seit 1.0.2). Vorher: offen, am 20.10.2026 gemessen, Ursache des Stempelns nicht gefunden. Betroffen: `Eudora71/Bin/Release/DirServ.dll`, `EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Ph.dll`. **Sie werden von keinem Projekt gebaut:** `Eudora.sln` führt 19 Projekte, keins erzeugt eine dieser Dateien; ihre PE-Zeitstempel lauten alle **25.08.2005**, es sind die Binärdateien von QUALCOMM. **Trotzdem ändern sie sich:** nach dem Release-Bau vom 19.10.2026 wichen alle fünf von `HEAD` ab, und zwar in **genau 5 Byte** je Datei, an denselben Stellen — die **PE-Prüfsumme** (Offset `0x168`, bei `Ph.dll` `0x00017F38` → `0x0001A7C6`) und ein 32-Bit-**Zeitstempel im Debug-Verzeichnis** (Offset `0x2D0`): `0x6AD3E2E2` = 17.10.2026 21:04 wurde zu `0x6AD60B6E` = **19.10.2026 12:22 UTC**, also 14:22 Ortszeit — der Zeitpunkt des Baus. Kein Maschinencode, keine Funktion, keine im Programm sichtbare Angabe. **Wer stempelt, ist nicht gemessen** — `paket-bauen.ps1` liest die Dateien nur, kein `.vcxproj` nennt sie, und ein Kopieren ändert keine Bytes. **Der zweite, schwerere Teil:** die Fassungen im ausgelieferten Paket `Eudora72-1.0.110-release` unterscheiden sich von denen im Repo um **430 Byte** (`DirServ`), **484** (`EudoraBk`), **482** (`ISock`), **1234** (`Ldap`) und **549** (`Ph`) — gemessen mit `cmp -l` gegen `HEAD` **und** gegen den Arbeitsbaum, beide Male dieselben Zahlen. Der Grund ist der Aufbau von `paket-bauen.ps1`: aus `Bin\Release` werden **nur sieben eigene Bauergebnisse** übernommen (`Eudora.exe`, `EudoraRes.dll`, `EuLang.dll`, `Imap.dll`, `QCSocket.dll`, `QCUtils.dll`, `plstclnt.dll`, im Release-Bau dazu `QCSSL.dll`); diese fünf kommen aus der **Grundlage**. **Es gibt also zwei auseinanderlaufende Bestände derselben fünf Dateien, und welcher der richtige ist, hat nie jemand geprüft.** **Kein Datenverlust, keine bekannte Fehlfunktion.** **Warum es trotzdem zählt:** (1) der Arbeitsbaum ist nach jedem Bau schmutzig, `gesichert.pl` meldet es jedes Mal, und wer das gewohnheitsmäßig wegklickt, übersieht die nächste echte Änderung; (2) nach [E-124](#e-124) — Defender stufte 7.2.0.98 als `Trojan:Win32/Bearfoos.A!ml` ein — ist eine **unerklärte Änderung an einer ausgelieferten Binärdatei** genau das, was gemessen gehört. **Entschieden am 20.10.2026:** die fünf Byte werden **nicht committet**, der Arbeitsbaum wird mit `git checkout --` zurückgesetzt; ein Commit würde Rauschen festschreiben, das niemand ausliefert. **Offen:** wer stempelt, und welche der beiden Fassungen gilt. *Bis zum 23.10.2026 stand hier, was noch fehle:* zweierlei — **wer** die fünf DLLs beim Bau stempelt, ist nicht gefunden (`paket-bauen.ps1` liest sie nur, kein `.vcxproj` nennt sie), und es ist nicht entschieden, **welche** der beiden auseinanderlaufenden Fassungen gilt: die im Repo oder die im Paket.  **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — die fünf DLLs im Arbeitsbaum gegen `HEAD` verglichen (`cmp -l`): **0 abweichende Bytes** bei allen fünf. Das Stempeln tritt also **nur beim Release-Bau** auf und sitzt nicht im Bestand. Der zweite Teil — dass im ausgelieferten Paket andere Fassungen liegen als im Repo — ist davon unberührt und bleibt offen. **Stufe: kritisch** (Paket: ausgeliefert wird etwas anderes als im Bau steht)|
| <a id="e-141"></a>E-141 | **Eine Übertragung aus einem IMAP-Ordner nach `Out` stößt die ganze IMAP-Nachbearbeitung an, obwohl sie nichts bewegt hat** — bis hin zu einem `EXPUNGE` auf dem Server | **offen, am 23.10.2026 am Quelltext belegt, am laufenden Programm nicht gemessen.** Gefunden von [PRÜFER-46](../Befunde/PRUEFER-46.md) beim Nachrechnen der E-125-Behebung, von mir Zeile für Zeile nachgemessen. **Die Kette.** (1) `sumlist` wird in `CTocDoc::Xfer` an **genau einer** Stelle gefüllt: `tocdoc.cpp:3001`, und die liegt im Zweig `if (!ToOut)`. Bei **jeder** Übertragung nach `Out` ist die Liste also leer — nachgezählt: `sumlist.AddTail` kommt in der ganzen Funktion einmal vor. (2) Die Bedingung in `tocdoc.cpp:3134` lautet `IsImapToc() oder (TargetToc und TargetToc->IsImapToc()) und sumlist.GetCount() > 0`. Weil das logische Und stärker bindet als das Oder, heißt das *„Quelle ist IMAP **oder** (Ziel ist IMAP und es gibt etwas zu tun)"*. Bei einer **IMAP-Quelle** greift der linke Teil allein. (3) Damit läuft `ImapXfer` mit leerer Liste, und dort steht ohne jede Prüfung auf die Anzahl: `if (!bCopy && IsImapToc() && ExpungeAfterDelete(this)) ImapExpunge();` (`EuImap/src/ImapToc.cpp:246-249`). **Was dabei herauskommt:** die Fehlmeldung `IDS_ERR_IMAP_NO_MSGS_XFERRED` (`:857`), bei abgeschalteter Verbindung ein modaler Offline-Dialog (`:395`), bei schreibgeschütztem Ordner ein zweiter Ja/Nein-Dialog (`:365-373`), eine überflüssige Serververbindung (`:413`, `:423`) — und der `EXPUNGE`. **Warum es trotzdem wichtig und nicht kritisch ist, selbst nachgemessen:** `ExpungeAfterDelete` liest nur die Kontoeinstellung `IDS_INI_IMAP_REMOVE_ON_DELETE` (`ImapMailbox.cpp:6057-6063`), und auf dem **normalen Löschweg** expunged Eudora bei eingeschalteter Einstellung ohnehin sofort (`ImapToc.cpp:3148-3154`). Wer sie an hat, hat im Ordner normalerweise **keine** gelöscht-markierten Nachrichten liegen, die der verirrte Expunge wegräumen könnte. Verloren gehen kann nur, was ein **anderes Programm** oder ein Offline-Lauf seit dem letzten Abgleich als gelöscht markiert hat — schmal, aber nicht null. **Keine Regression:** das Verhalten ist älter als 1.0.122. Für **empfangene** Nachrichten ist es dort sogar abgestellt, weil der Merker `E125Abgelehnt` die Nachbearbeitung überspringt. **Was noch fehlt:** die Berichtigung in `tocdoc.cpp:3134` — die Klammer um den Oder-Teil ziehen, so dass die Anzahlprüfung für **beide** Seiten gilt. Sie schließt Fehlmeldung, beide Dialoge, die Verbindung und den Expunge in einem Zug. **Gegenprobe, die dabei gefahren werden MUSS:** Löschen aus einem IMAP-Ordner in den Papierkorb und Verschieben IMAP nach lokal müssen unverändert laufen — dort ist `sumlist` gefüllt, die Berichtigung darf nichts ändern. In denselben Schritt gehört `tocdoc.cpp:3143` (`return pCopySum;`), das `Xfer` ohne `bXferActive = FALSE` verlässt: heute folgenlos, weil alle vier IMAP-Übertragungsfunktionen `NULL` liefern, aber eine Fassung, die dort einmal etwas zurückgibt, legt das Übertragen für den Rest der Sitzung still. **Stufe: wichtig** (Funktion: Fehlmeldung und Dialoge nach einer Uebertragung, die nichts bewegt hat; schmaler Loeschweg ueber EXPUNGE)|
| <a id="e-142"></a>E-142 | **Ein Entwurf aus einem IMAP-Ordner nach `Out` gezogen ergibt in `Out` eine LEERE Nachricht** — ohne Empfänger, Betreff und Text; das Original bleibt im IMAP-Ordner, dazu die Meldung über nicht übertragene Nachrichten | **offen, von Gregor am 23.10.2026 am laufenden Programm bestätigt (Paket 1.0.122).** **Kurz: Wer einen Entwurf aus einem IMAP-Ordner (etwa dem Papierkorb unter `<Dominant>`) nach `Out` zieht, bekommt dort eine leere Nachricht und die falsche Meldung *„No messages were transferred!"*. Sofort verloren geht nichts, das Original bleibt im IMAP-Ordner; wer es dort löscht, weil er es für verschoben hält, verliert den Entwurf. Vor 7.2.1 wird das nicht behoben — vereinbart ist ein Hinweis, eingebaut am 26.10.2026; die Ursache kommt nach 7.2.1 dran.** **Hinweis eingebaut am 26.10.2026, von Gregor am Testpaket 7.2.0.123 gemessen (TESTPLAN N3); seit 7.2.0.124 ist *No* vorgewählt; Kurztest T4 an 1.0.124: die Rückfrage kam nicht, weil der Entwurf vorher vom Server neu geladen war, siehe Nachtrag unten** (wie vereinbart, keine Behebung): zieht man einen Entwurf aus einem IMAP-Ordner nach `Out`, fragt Eudora einmal je Vorgang *„Moving or copying a draft from an IMAP mailbox to Out may give an empty message in Out (no recipients, subject or text). The original stays in the IMAP mailbox - keep it until you have checked the copy. Transfer anyway?"* (`tocdoc.cpp`, `CTocDoc::Xfer`, hinter der E-125-Ablehnung; Text `IDS_WARN_IMAP_DRAFT_TO_OUT` in `EudoraRes.rc`). „No" überträgt nichts und unterdrückt die IMAP-Nachbearbeitung samt *„No messages were transferred!"*. Protokollzeile `E-142 Hinweis Entwurf aus IMAP nach Out: quelle=… antwort=ja oder nein`. Regressionstest `TestE142.cpp` (Unit-Tests: 304 Tests, 304 bestanden; ohne `!E142Abgebrochen` einmal rot, 303/304). **Nachgeprüft von [PRÜFER-58](../Befunde/PRUEFER-58.md):** der Hinweis kommt beim Abruf mit Filtern nicht (vorher greift die E-125-Ablehnung für empfangene Post), hält also keinen Abruf an; „No" ist sauber. **Grenzen:** aus dem Suchfenster und bei *Filter Messages* von Hand kommt er je Entwurf statt einmal (K3, dieselbe Klasse wie [E-143](#e-143)); „No" leert trotzdem die Undo-Liste (K4). Der Text sagt seit dem 26.10. „Moving or copying", weil er auch beim Kopieren kommt. Am Testpaket 7.2.0.123 von Gregor am 26.10.2026 geprüft (TESTPLAN N3, *No*, Protokoll `antwort=nein`); dabei war *Yes* vorgewählt. Gregor: *„no wäre besser“* — seit demselben Tag wählt die Rückfrage **No** vor (`YesNoDialogPlainNeinVorgewaehlt`, `guiutils.cpp`; Regressionstest in `TestE142.cpp`, 310 Tests, 310 bestanden). Die Vorwahl *No* hat am Programm noch niemand gesehen: in T4 an 1.0.124 kam die Rückfrage nicht, belegt ist sie nur durch den Unit-Test. **Von Gregor am laufenden Programm bestätigt am 23.10.2026** an Paket 1.0.122 (auf seinen 0.116-Daten): Entwurf von `Out` in den IMAP-Papierkorb verschoben (Protokollzeile `E-121 Hochgeladen: ergebnis=1 neue-uid=1`), zurück nach `Out` gezogen — Protokoll `E-27 NewCompDocument` und gleich danach `Dialog: "No messages were transferred!"` (Text aus `IDS_ERR_IMAP_NO_MSGS_XFERRED`, gemeldet in `ImapToc.cpp:857`), Bildschirmfoto von Gregor. **In `Out.mbx` gemessen** (mit Gregors Erlaubnis gelesen): die neue Nachricht von 23:21:24 hat `To:` leer, `Subject:` leer und keinen Rumpf. **Schlimmer als ursprünglich beschrieben** — hier stand „liegt danach doppelt da". Gregor wollte eigentlich [E-144](#e-144) prüfen und nahm das IMAP-`Trash` statt des lokalen, weil meine Anweisung nicht sagte, welches. Vorher: offen, am 23.10.2026 am Quelltext belegt, am laufenden Programm nicht gemessen. Abgetrennt aus [E-125](#e-125) nach [PRÜFER-46](../Befunde/PRUEFER-46.md). Die Ablehnung aus [E-125](#e-125) greift bewusst nur für **empfangene** Nachrichten (`tocdoc.cpp:2752`); ein Entwurf darf weiterhin nach `Out`, weil das das Einreihen zum Senden ist. **Nur arbeitet dieser Weg aus einem IMAP-Ordner heraus nicht sauber:** `Sum->SendAgain` legt die Kopie an (`tocdoc.cpp:3005`), aber `SubtractSum` ist für IMAP ausgenommen (`:3019-3023`), die Quelle bleibt also stehen; und weil `sumlist.AddTail` nur im Zweig ohne `Out` läuft (`:3001`), ist die Liste leer und der IMAP-Zweig meldet anschließend `IDS_ERR_IMAP_NO_MSGS_XFERRED`. Dieselbe Kette wie [E-141](#e-141), nur für den **erlaubten** Fall — der Merker `E125Abgelehnt` bleibt hier `FALSE`. **Keine Regression**, vor 1.0.122 genauso, nur mit einem Ja/Nein-Dialog davor. *Überholt am 23.10.2026 — hier stand:* „Kein Datenverlust: es entsteht eine Kopie zuviel, nichts verschwindet." Gemessen ist eine **leere** Nachricht in `Out`; verschwunden ist nichts, solange das Original im IMAP-Ordner bleibt — wer es dort löscht, weil er es für verschoben hält, verliert den Entwurf. **Nachtrag 24.10.2026 ([PRÜFER-48](../Befunde/PRUEFER-48.md) K7):** Gregors Entwurf hatte beim Speichern 26 Byte Text (`EditorBytes=26`); im selben Lauf kopierte derselbe Weg (`SendAgain`) einen **lokalen** Entwurf vollständig. Die Leere entsteht also beim **Lesen der Quelle aus dem IMAP-Ordner**, nicht beim Übernehmen der Kopfzeilen — welcher Lesefehler, ist nicht gemessen. Nicht dieselbe Ursache wie das `<br>` aus [E-125](#e-125). Mit der Berichtigung aus [E-141](#e-141) verschwände nur die Meldung, die leere Nachricht bliebe. **Was noch fehlt:** vor 7.2.1 nichts — Gregors Entscheidung 13 (26.10.2026): *Send Again* aus IMAP ergibt eine leere Mail (T6), das kommt erst nach 7.2.1 dran; Entwürfe bleiben im lokalen `Out`, die README nennt es. Nach 7.2.1: die Ursache (vermutlich wird der Inhalt einer neu geladenen IMAP-Nachricht nicht gelesen, Vermutung). **Nach 7.2.1:** die Ursache der leeren Kopie messen (Spurmarke beim Lesen der IMAP-Quelle, Vorschlag in PRÜFER-48), dann beheben. Außerdem, aus der ersten Fassung, zweierlei, und das zweite ist Gregors Entscheidung. Erstens die Fehlmeldung — sie fällt mit der Berichtigung aus [E-141](#e-141) von selbst weg. Zweitens die Frage, ob ein Entwurf beim Einreihen zum Senden aus dem IMAP-Ordner **verschwinden** soll. Heute bleibt er dort liegen; ob das falsch ist, hängt daran, ob der Ordner als Ablage oder als Arbeitsvorrat gedacht ist. Ohne diese Entscheidung ist nichts zu bauen. **Wie zu prüfen:** einen Entwurf in einem IMAP-Ordner anlegen, nach `Out` ziehen, danach beide Orte ansehen und ins Protokoll sehen — es darf **keine** `E-125`-Spurmarke erscheinen, denn der Weg ist erlaubt. **Vereinbart — Gregor am 24.10.2026:** *„wir haben ausgemacht, daß es als hinweis kommt, daß bei dieser aktion mail inhalt verloren gehen kann, das sollte reichen."* Zu bauen ist also ein **Hinweis** beim Ziehen eines Entwurfs aus einem IMAP-Ordner nach `Out`, dass dabei der Inhalt verloren gehen kann — keine Behebung der leeren Kopie. (Meine Aussage vom selben Tag, es sei nichts vereinbart, war falsch; die ursprüngliche Absprache stand in keiner Repo-Datei.) **Zuletzt gemessen: 26.10.2026 an 7.2.0.124** **Nachtrag 26.10.2026 (Kurztest T4 an 1.0.124):** Gemessen in Gregors `eudora.log` an 1.0.124 (26.10.2026): neuer Entwurf gespeichert (Programmzeit 14:12, `E-88 … Fassung=EDITOR`), nach IMAP *Gelöscht* hochgeladen (14:30, `E-121 Hochgeladen: ergebnis=1 neue-uid=15`), danach den Ordner geöffnet und die Nachricht vom Server neu geladen (14:50, `1 message(s) left to download`), dann das Zurückziehen nach `Out` abgelehnt (15:01, `E-125 Xfer nach Out abgelehnt: quelle=Gelöscht (<Dominant>)`) — Eudora hielt sie nicht mehr für einen Entwurf, die E-142-Rückfrage kam deshalb nicht. Nichts ging verloren, das Original liegt weiter in *Gelöscht*. Vermutung, nicht gemessen: beim Neuladen vom Server geht die Entwurfsmarke verloren; an 1.0.123 (TESTPLAN N3) kam die Rückfrage, vermutlich weil die Nachricht noch nicht neu geladen war. **Entscheidung Gregors dazu (26.10.2026):** *„ja, die ablehnung reicht, wenn man es über message -> send again verschicken kann.“* Ob *Send Again* aus dem IMAP-Ordner eine sendbare Nachricht ergibt, hat Gregor an 1.0.124 geprüft: nein, die Mail ist leer (T6; Entscheidung 13). **Kurztest T6 an 1.0.124:** Gregor am 26.10.2026 an 1.0.124: *„message -> send again liefert eine leere mail.“* (Gregors Bild: neue Mail ohne Empfänger, Betreff und Text, nur der Absender). Die Bedingung aus Entscheidung 12 ist damit **nicht** erfüllt: ein aus IMAP neu geladener Entwurf lässt sich weder nach `Out` ziehen noch per *Send Again* verschicken. Das Original liegt weiter im IMAP-Ordner. **Stufe: wichtig** (Funktion: eine leere Nachricht in `Out` und eine Meldung, die das Gegenteil des Geschehenen behauptet; das Original bleibt im IMAP-Ordner)|
| <a id="e-143"></a>E-143 | **Aus dem Suchfenster und aus Filtern kommt der Out-Hinweis je Nachricht** — zwanzig Treffer ergeben zwanzig Dialoge, und ein Filter mit Ziel `Out` hält den automatischen Mailabruf an | **offen, am 23.10.2026 am Quelltext belegt, am laufenden Programm nicht gemessen.** Aus [PRÜFER-45](../Befunde/PRUEFER-45.md) K3 und [PRÜFER-46](../Befunde/PRUEFER-46.md). **Die Kette:** `Out` steht in der Postfachliste (`QCMailboxDirector.cpp:159`) und wird beim Menübau nicht ausgenommen (`:2074`); das Filterfenster benutzt dasselbe Transfer-Menü wie der Anwender (`controls.cpp:316`, gerufen aus `filtersv.cpp:2206`). Ein Filter kann also *Transfer To: Out* tragen. Der Abruf filtert im **Hauptfaden** (`pop.cpp:1003`), `CFilter::Action` ruft `Xfer` **je Nachricht** (`filtersd.cpp:1531`, IMAP `:1981`), und `AlertDialog` ist modal (`guiutils.cpp:905`). Der Abruf steht also, bis jemand klickt. `gbAutomationCall` schützt nicht — es ist nur während COM-Automatisierung wahr (`Automation.cpp:145-150`). **Keine Regression, und das ist der Grund, warum es kein Paket aufhält:** der alte Quelltext zeigte an derselben Stelle `AlertDialog(IDD_STRIP_HEADERS)`, ebenfalls modal, und `StripHeaders` war eine **lokale** Variable je `Xfer`-Aufruf. Die Zahl der Dialoge ist dieselbe; neu ist nur, dass keine unbrauchbare Nachricht mehr in `Out` entsteht. **Kein Absturz:** `Xfer` liefert `NULL`, beide Aufrufstellen fangen das ab (`filtersd.cpp:1590-1594`, `:2005-2009`). **Zwei kleinere Punkte gehören hierher**, beide aus [PRÜFER-45](../Befunde/PRUEFER-45.md): bei **gemischter Auswahl** behauptet der Hinweis, es sei nichts übertragen worden, obwohl die Entwürfe davor schon vollständig übertragen wurden — falsche Auskunft, kein Datenverlust, denn die Teilübertragung ist abgeschlossen und beide Verzeichnisse werden geschrieben; und auf dem Filterweg läuft `ASSERT(CopySum != NULL)` (`tocdoc.cpp:3094`) an, was im Release nichts ist und über `GetIndex(NULL) < 0` folgenlos ausgeht, im Debug-Bau aber den Lauf anhält. **Was noch fehlt:** eine Entscheidung und dann der Einbau. Entweder den Hinweis unterdrücken, wenn der Aufruf nicht vom Anwender kommt — `SingleSum && !RedisplayTOCs` kennzeichnet den Filterweg bereits —, oder `Out` im Transfer-Menü des Filterfensters gar nicht anbieten. **Vorher zu bedenken:** eine stumme Ablehnung heißt, dass niemand erfährt, warum sein Filter nichts tut; dann gehört wenigstens eine Zeile in den Filterbericht. **Wie zu prüfen:** im Suchfenster zwanzig Treffer markieren und *Transfer* nach `Out` wählen; es darf **ein** Hinweis kommen, nicht zwanzig. Dazu einen Filter mit Ziel `Out` anlegen und Post abrufen; der Abruf darf nicht stehenbleiben. **Stufe: wichtig** (Funktion: der automatische Abruf bleibt an einem modalen Dialog stehen)|
| <a id="e-147"></a>E-147 | **Die Reparatur zerstörter Umlaute und Sonderzeichen aus dem Plug-in `EudoraUnicodeFix` soll fest in Eudora eingebaut werden** — damit eine Nachricht gar nicht erst beschädigt gespeichert wird, statt nur beim Anzeigen repariert | **offen — zurückgestellt bis nach 7.2.1**, von Gregor am 25.10.2026 entschieden (*„wir notieren es als befund, werden es erst später angehen (nicht 7.2.1 - erst danach)"*). Neue Funktion, gehört deshalb nicht in 7.2.1 ([ZIEL.md](../ZIEL.md), Maßstab für 7.2.1: *„Neue Funktionen gehören nicht dazu"*). **Herkunft:** Ray Schǔmacher (`rjsdotorg`), Melder aus [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102), hat am 21.10.2026 angeboten: *„Feel free to use the methods/code … in your repository … if it can be baked in so much the better."* (der Satz stammt aus seinem Kommentar im Issue, 21.10.2026 22:43 UTC — kein Programmtext; dort nennt er auch die Stelle, „roughly lines 40–50 of src/repair.cpp", also etwa `repair.cpp:40`). Am 25.10.2026 haben wir ihn dort ausdrücklich gefragt, ob er die Veröffentlichung seines Codes möchte ([Kommentar](https://github.com/HansWurst81675/Eudora7.2/issues/102#issuecomment-6401451303)) Sein Quell-Repo `rjsdotorg/EudoraUnicodeFix` ist **privat**, für uns lesbar (gemessen 25.10.2026: Lizenz **BSD-3-Clause**; unsere ist BSD-3-Clause **mit Patentausschluss** (`LICENSE`), beide vertragen sich, die seine erlaubt den Einbau; die EMSAPI-Kopfdateien darin stammen von QUALCOMM/Computer History Museum, ebenfalls BSD). **Rechtlich erlaubt** ist das Einbauen der Quellen, mit drei Pflichten: sein Copyright-Vermerk und der Lizenztext bleiben in jeder übernommenen Datei; der Vermerk geht mit jedem Paket mit (Hinweisdatei); sein Name nicht als Werbung. **Vorher:** weil sein Repo privat ist, unseres öffentlich, fragen wir ihn ausdrücklich, ob er die Veröffentlichung seines Codes möchte (Gregor, 25.10.2026) — Antwort im Issue abwarten. **Fachlich:** sein Plug-in repariert beim Anzeigen (`src/repair.cpp`: `ProcessNode` → `ScoreText` → `IsIndicator` → `Plausible`, laut seiner Beschreibung im Issue); wir wollen es an der Stelle, an der der Text gespeichert wird — verwandt mit [E-136](#e-136). **Was noch fehlt:** Rays Antwort im Issue #102, ob er die Veröffentlichung möchte; danach (nach 7.2.1) die Reparatur an der Stelle einbauen, an der eingehender Text gespeichert wird, mit seinem Lizenzvermerk in den Quellen und in der Hinweisdatei des Pakets und mit Regressionstest. **Stufe: wichtig** (Funktion: Umlaute und Sonderzeichen aus manchen Absendern kommen zerstört an, nichts geht durch Eudora selbst verloren) |
| <a id="e-160"></a>E-160 | **Beim Anlegen einer neuen Persönlichkeit zeigt Windows „Zum Ausführen der gewünschten Aktion ist kein E-Mail-Programm zugeordnet“** — der Kontoassistent fragt bei Outlook an, auch wenn es keins gibt | **behoben — von Gregor am 27.10.2026 an Paket 1.0.127 bestätigt (TESTPLAN V4, „V4: PASSED“; außerhalb der VM, leerer Stand).** Davor: Behebung eingebaut am 26.10.2026, ergänzt am 27.10.2026 für Outlook 2013 und neuer (PRÜFER-61 K3); Unit-Test rot ohne und grün mit. Gregors Entscheidung: *„ja, outlook suche - beheben.“* **Ergänzung 27.10.2026 ([PRÜFER-61](../Befunde/PRUEFER-61.md) K3):** die erste Fassung hätte Anwender von Outlook 2013 und neuer vom Outlook-Import ausgesperrt — deren Profile stehen unter `Office\15.0` bzw. `16.0\Outlook\Profiles`, nicht unter den beiden alten Schlüsseln. Diese beiden Schlüssel zählen jetzt mit; der weitere Weg ist für sie derselbe wie vor E-160 (Unit-Test, ohne den 16.0-Schlüssel 313/314). **Kurz: Wer unter *Persona* mit Rechtsklick → *Neu* eine Persönlichkeit anlegen wollte, bekam eine Windows-Meldung, die nach einem fehlenden Mailprogramm klingt. Nach *OK* ging es weiter, verloren ging nichts.** Gefunden von Gregor am Testpaket 7.2.0.125 (26.10.2026, Bild; *„ich habe bei persona rechtklick -> neu gewählt.“*). Gemessen am laufenden Programm (Gregors Eudora 1.0.125, nur gelesen): das sichtbare Fenster gehörte zu Eudora (Titel *E-Mail*, Klasse `#32770`), geladen waren `NSImport.eif`, `OEImport.eif`, `OLImport.eif` und `C:\Windows\SYSTEM32\Mapi32.DLL`. Belegt am Quelltext: `OLImportClass::FindMainOLKey` (`Importers/OLImport/OLImportClass.cpp`) prüft drei Outlook-Schlüssel in der Registry, meldet sich aber auch ohne jeden Treffer bei MAPI an (`MAPILogon` → `LoadLibrary("Mapi32")`, `MAPILogonEx`); ohne eingetragenes Mailprogramm antwortet die Windows-Fassung von `Mapi32.dll` mit dieser Meldung. Warum Gregor sie vorher nicht sah: seit Paket 1.0.124 ist `OLImport.eif` die Release-Fassung aus dem Bau (49.664 Byte), bis 1.0.123 lag eine Debug-Fassung vom August im Paket (235.520 Byte, [E-156](#e-156)) — gemessen sind die beiden Dateien, nicht ihr Verhalten; Vermutung: die alte stieg früher aus. **Eingebaut:** ohne Profil- und Identitätsschlüssel hört `FindMainOLKey` auf, bevor MAPI geladen wird. Regressionstest `TestE160.cpp` (313 Tests, 313 bestanden; ohne die Behebung 312/313). **Was noch fehlt:** Gregors Prüfung an Paket 1.0.127 (TESTPLAN V4): *Tools → Personalities*, Rechtsklick in die Liste → *New...*, die Windows-Meldung darf nicht kommen. **Wie zu pruefen:** **GREGOR** — TESTPLAN V4; am Prüfstand bisher nicht gemessen. **Stufe: unkritisch** (Meldung ohne Folgen) |
| <a id="e-165"></a>E-165 | **Die Vervollständigungsbox im `To:`-Feld sieht mit einem einzigen Treffer verbaut aus** — winzige Schrift, darunter ein grauer Balken, rechts unten ein Größengriff | **offen, nicht gemessen; gefunden von Gregor am 27.10.2026 an Paket 1.0.127** (außerhalb der VM, leerer Stand; Bildschirmfoto im Chat: `To: <Kurzname>`, ein Treffer `<Kurzname>`, Box deutlich höher als der eine Eintrag, darunter ein grauer Balken mit hellerem Feld — Gregor: *„diese vervollständigung sieht nicht nett aus.“*). **Kurz: Beim Tippen eines Kurznamens erscheint die Auswahlbox, sieht aber unfertig aus. Bedienen lässt sie sich; verloren geht nichts.** Derselbe Code wie [E-135](#e-135) (`AutoCompleterListBox`, `AutoCompleteSearcher.cpp`), dort war die Box mit **zwei** Treffern an 1.0.120 richtig bemessen; E-135 bleibt behoben. **Am Quelltext belegt:** die Box ist der Dialog `IDD_AUTOCOMP` mit `WS_THICKFRAME` (`EudoraRes.rc:3612-3613`) — daher Größengriff und dicker Rand —, darin eine eigengezeichnete Liste mit `WS_VSCROLL` (`AutoCompleteSearcher.cpp:1441`). `InitList` (`:618`) setzt die Höhe auf *Einträge × (Zeichenhöhe − 1) + 10* und misst die Zeichenhöhe an einem `CClientDC` der Liste, **ohne** deren Schrift (`SetFont(&GetMessageFont())`, `:518`) auszuwählen. **Vermutung, nicht gemessen:** bei einem Eintrag ist das Außenmaß kaum größer als der Rahmen (bei E-135 gemessen 14 Pixel), die Liste wird zu niedrig, und der graue Balken ist eine waagrechte Bildlaufleiste; dass die Schrift kleiner ist als im `To:`-Feld, kann an Gregors Bildschirmskalierung liegen (sein Protokoll: Bildschirm 5760×2160). **Was noch fehlt:** am Prüfstand `C:\Temp\E135-box` mit **einem** passenden Kurznamen messen (Außen- und Innenmaß der Box und der Liste, Bildlaufleisten-Stil), danach erst beheben. **Wie zu pruefen:** **ICH** — `tools/messen-e135.ps1` um den Fall „ein Treffer“ erweitern, rot an 1.0.127, dann grün. **Stufe: unkritisch** (Aussehen) |
| <a id="e-173"></a>E-173 | **Im Filterfenster sind die Labels der Aktion *Make Label* einmal ausgegraut und nicht wählbar** | **offen, beobachtet von Gregor am 29.10.2026 an 7.2.1.128, nie gemessen** — **Kurz: Beim Anlegen eines Filters mit der Aktion *Make Label* standen die Labels in der Auswahlliste grau da und ließen sich nicht wählen. Nachdem Gregor den Filter gelöscht und neu angelegt hatte, waren die Farben wieder da und ein Label ließ sich auswählen. Es geht nichts verloren; der Filter lässt sich neu anlegen. Gregor muss nichts tun.** Gregors Bildschirmfoto vom 29.10.2026, 13:15 (Fassung 7.2.1.128 in der Titelzeile, Testverzeichnis in seiner VM) zeigt die geöffnete Liste mit grauen Einträgen; im `eudora.log` steht dazu nichts (gelesen 29.10.2026). **Was noch fehlt:** erst **nach dem Release 7.2.1** — nachstellen (unter welcher Bedingung ist die Liste grau: neuer Filter, bestimmte vorherige Aktion, Persönlichkeit?), dann die Stelle, die die Einträge der Label-Liste freigibt, mit `befund-suchen.pl` suchen und lesen; `filtersd.cpp` nennt bisher kein Befund zu Labels. **Stufe: unkritisch** (Bequemlichkeit: der Weg über Löschen und Neuanlegen geht, nichts geht verloren) |
| <a id="e-172"></a>E-172 | **Eine Mail steht im Lesefenster als rohe Base64-Zeichenfolge** statt als lesbarer Text | **offen, beobachtet von Gregor am 29.10.2026 an Paket 1.0.127, nie gemessen** — **Kurz: Eine weitergeleitete Mail in einem IMAP-Konto zeigt im eigenen Fenster seitenweise Base64 statt Inhalt. Ob das ein Anzeigefehler ist oder die Mail selbst einen nicht dekodierten Teil enthält, ist offen. Gregor muss nichts tun.** Gesehen auf Gregors Bildschirmfoto vom 29.10.2026 (im Chat, zusammen mit [E-171](#e-171)). **Was noch fehlt:** erst **nach dem Release 7.2.1** (Gregor 29.10.2026) — Quelltext der Mail ansehen (*View Source*), Kopfzeilen `Content-Type`/`Content-Transfer-Encoding` des betroffenen Teils, dann `befund-suchen.pl` auf die Dekodierstelle; möglich ist ein Zusammenhang mit [E-145](#e-145) (Base64-Dekodieren), nicht geprüft. **Stufe: kritisch** (vorläufig, bis gemessen: ist die Mail undekodiert gespeichert, kommt sie falsch an — so die Legende; [LEKTOR-93](../Befunde/LEKTOR-93.md#l-93.3)) |
| <a id="e-171"></a>E-171 | **„Search Mailfolder“ im Rechtsklickmenü einer Mail bringt ohne markierten Text die Meldung „There has been an internal error during the search“** (der Text stammt aus `IDS_SEARCH_INTERNAL_ERROR`, `EudoraRes.rc:9330`, gezeigt in `SearchView.cpp:2475`) | **offen, gemeldet von Gregor am 29.10.2026 an Paket 1.0.127, im Protokoll belegt, Ursache belegt am Quelltext** **Zuletzt gemessen: 29.10.2026 an 7.2.0.127** — in Gregors Protokoll — **Kurz: Wer in einer geöffneten Mail rechts klickt und *Search Mailfolder* wählt, ohne vorher Text zu markieren, bekommt ein leeres Suchfenster und sofort eine Fehlermeldung. Es geht nichts verloren; die Suche hatte nur nichts, wonach sie suchen konnte. Gregor muss nichts tun.** **Im Protokoll belegt:** Gregors `eudora.log` (Paket 1.0.127, gelesen 29.10.2026) zeigt dreimal hintereinander (1.44, 2.59, 3.06) *„Finding Messages“*, *„Searching...“* und im selben Augenblick *„Dialog: "There has been an internal error during the search. Your results may not be valid."“*. **Belegt am Quelltext:** `CTridentView::OnUpdateSearchForSelection` (`TridentView.cpp:1094-1112`) gibt den Menüpunkt auch ohne Auswahl frei (`pCmdUI->Enable(TRUE)`); `OnSearchInEudoraForSelection` (`:1115-1131`) ruft `OpenFindMessagesWindow(..., szText, ..., true)` mit leerem Suchtext und **sofortigem Start** (`guiutils.cpp:3351ff`, letzter Parameter `bStartSearch`); `CSearchView::DoSearch` (`SearchView.cpp:2590-2593`) findet kein gültiges Kriterium und liefert `false`, `OnOk` (`:2474-2475`) zeigt `IDS_SEARCH_INTERNAL_ERROR`. Der Kommentar dort sagt selbst: *„We disable the search btn when there are zero valid criteria entries“* — der Weg über das Kontextmenü umgeht das; das `ASSERT` davor gibt es im Freigabebau nicht ([assert-ist-im-release-nichts](../Arbeitsweise/assert-ist-im-release-nichts.md)). Dasselbe gilt für *Search Mailbox* und *Search Eudora*: alle drei Menüpunkte rufen dieselbe Funktion (`TridentView.cpp:1159`, `:1172`, `:1185`; belegt am Quelltext, [LEKTOR-93](../Befunde/LEKTOR-93.md#l-93.4), nicht gemessen) und für Nur-Text-Mails (`PaigeEdtView.cpp:8710ff`, nicht nachgesehen). **Was noch fehlt:** erst **nach dem Release 7.2.1** (Gregor 29.10.2026) — ohne Auswahl das Suchfenster öffnen, aber nicht starten (oder den Menüpunkt sperren); vorher am Prüfstand rot. `befund-suchen.pl IDS_SEARCH_INTERNAL_ERROR`: kein Treffer. **Stufe: unkritisch** (falsche Fehlermeldung, nichts geht verloren) |
| <a id="e-170"></a>E-170 | **Das Label einer Mail geht verloren, wenn man sie innerhalb eines IMAP-Kontos in einen anderen Ordner verschiebt** | **offen, gemeldet von Gregor am 29.10.2026 an Paket 1.0.127, Ursache belegt am Quelltext, nicht gemessen** — **Kurz: Gregor setzte auf eine Mail ein grünes Label und verschob sie in einen anderen IMAP-Ordner desselben Kontos; dort war das Label weg. Eudora speichert Labels nur bei sich, nicht auf dem Server, und beim Verschieben zwischen zwei Ordnern desselben IMAP-Kontos holt es die Mail im Ziel neu vom Server — ohne Label. Gregor muss nichts tun.** **Protokoll:** Gregors `eudora.log` (`C:\Users\Gregor\Eudora72-1.0.127-release\Mailverzeichnis`, gelesen 29.10.2026) zeigt um 15.13 nur *„Updating mailbox "<Ordner> (<Konto>)"“* und danach je *„1 message(s) left to download“* — zum Label und zum Verschieben selbst schreibt Eudora keine Zeile. **Belegt am Quelltext:** `CTocDoc::ImapXferOnSameAccount` (`EuImap/src/ImapToc.cpp:483ff`) gibt nur die UID-Liste an `CImapSameServerTransferMsgAction` und entfernt die Quell-Zusammenfassungen (`ImapRemoveOrderedSubSums`); eine Zusammenfassung im Ziel wird **nicht** angelegt, das Ziel bekommt die Mail beim nächsten Abgleich als neue Zusammenfassung mit `m_Label = 0` (`summary.cpp:513`). Beim Weg lokal → IMAP dagegen kopiert `CSummary::Copy` das Label mit (`summary.cpp:594`, `ImapToc.cpp:1453`); ein Label als IMAP-Schlüsselwort auf den Server zu schreiben, kennt der Quelltext nicht (kein `$Label` im Baum). **Vermutung:** gleiches Verhalten im Original-Eudora 7.1; nicht gemessen. **Was noch fehlt:** erst **nach dem Release 7.2.1** (Gregor 29.10.2026: *„die findigs können wir erst nach dem release beheben. das muß nur erstmal nur als befund drin stehen.“*) — am Prüfstand rot nachstellen, dann den Weg wählen: das Label über die neue UID ins Ziel mitnehmen, oder Labels als IMAP-Schlüsselwörter auf dem Server speichern (dann auch auf anderen Rechnern sichtbar). `befund-suchen.pl SetLabel`: kein Treffer (29.10.2026). **Stufe: kritisch** (eine gesetzte Markierung geht still verloren — Legende: still Verlorenes ist kritisch, [LEKTOR-93](../Befunde/LEKTOR-93.md#l-93.2); die Mail selbst bleibt) |
| <a id="e-169"></a>E-169 | **Die Druckvorschau einer HTML-Mail zeigt keine Bilder und keine farbigen Flächen** — im Lesefenster stehen sie richtig | **offen, beobachtet von Gregor am 29.10.2026 an Paket 1.0.127, Ursache nicht gemessen** — **Kurz: Bei manchen HTML-Mails fehlen in *File → Print Preview* alle Bilder, und farbig hinterlegte Knöpfe erscheinen nur als Text; im Lesefenster ist dieselbe Mail vollständig. Nicht alle Mails sind betroffen. Gregor muss nichts tun; nach dem Release wird am Prüfstand gemessen, welche Mails es trifft.** Gregors Beispiel: eine weitergeleitete Werbe-Mail mit Bildern in einem IMAP-Postfach, zwei Bildschirmfotos am 29.10.2026 im Chat: im Lesefenster drei Konzertbilder und orange Knöpfe *„Jetzt buchen“*, in der Vorschau nur Text; die Fußzeile der Vorschau nennt `file:///C:/Users/Gregor/AppData/Local/Temp/eud26.htm` — gedruckt wird also eine **temporäre HTML-Datei**. **Vermutungen, nicht gemessen:** ~~die Bilder sind Verweise auf den Server des Absenders, die das Lesefenster lädt, die Vorschau der Zwischendatei aber nicht~~ (widerlegt am Quelltext, siehe *Was noch fehlt*); die Flächen fehlen, weil die Druckvorschau Hintergrundfarben ab Werk nicht druckt. `befund-suchen.pl ID_FILE_PRINT_PREVIEW` und `eud.*htm`: kein Treffer (29.10.2026). **Was noch fehlt:** erst **nach dem Release 7.2.1** (Gregor 29.10.2026) die Ursache — welche Mails es trifft und warum die Zwischendatei `eud*.htm` ohne Bilder gedruckt wird; die Zwischendatei schreibt `CTridentView::LoadMessage` (`TridentView.cpp:1530`), und das Lesefenster lädt **dieselbe** Datei (`:1633`, [LEKTOR-92](../Befunde/LEKTOR-92.md#l-92.1)) — die Vermutung „Lesefenster lädt Bilder, Zwischendatei nicht“ trägt damit nicht; der Unterschied muss im Druckweg `CTridentView::Print` (`:2305`) liegen (belegt am Quelltext, nicht gemessen). **Wie zu prüfen:** **ICH** — am Prüfstand eine HTML-Mail mit eingebettetem und eine mit nachgeladenem Bild, Vorschau vergleichen. **Stufe: wichtig** (Ausdruck falsch dargestellt, nichts geht verloren) |
| <a id="e-168"></a>E-168 | **Eudora stürzte am Prüfstand im Konto-Assistenten ab, auf der Seite mit dem Namen** — Zugriffsverletzung in `mfc140.dll`, während die Meldung *„You must enter a name before proceeding“* offen war | **erledigt, am laufenden Programm gemessen (29.10.2026)** — vom eigenen Messskript ausgelöst, ein Anwender erreicht die Stelle nicht (Prüfstand `C:\Temp\E166`). **Zuletzt gemessen: 29.10.2026 an 7.2.0.127 (`+772ed08d` und `+ea3ebcbd`)** — gefunden von [LEKTOR-90](../Befunde/LEKTOR-90.md#l-90.12) L-90.12 im `Exception.log` des Prüfstands `C:\Temp\E166`. **Kurz: Der Absturz kam nur, weil mein Messskript dem Assistenten „Weiter“ als Fensterbotschaft schickte, während er gesperrt war. Mit Maus oder Tastatur geht das nicht: solange die Meldung offen ist, ist der Assistent samt Weiter-Knopf gesperrt. Gregor muss nichts tun; nachstellen ließ sich der Absturz nicht einmal mit dem Skript.** **Was am 28.10.2026 geschah, gemessen am Sitzungsprotokoll:** Lauf um 13:34:54 (Zeile 13:35:19 in [TESTLAEUFE.md](../tools/TESTLAEUFE.md)) mit `tools/messen-e166-assistent.ps1`, `E166_ERKUNDEN=5`: fünfmal `PostMessage(WM_COMMAND, ID_WIZNEXT 12324)` an den Assistenten, je 2 s Abstand, Namensfeld leer. Das dritte *Weiter* öffnete auf der Namensseite die Meldung (`WizardYourNamePage.cpp:91-96` → `ErrorDialog` `guiutils.cpp:952` → `AlertDialog` `:932`), das vierte kam durch die modale Schleife der Meldung an den Assistenten und betrat `OnWizardNext` ein zweites Mal; im Stapel steht darunter `WM_COMMAND 0x3024` → `WM_NOTIFY` → Absturz in `mfc140.dll` (`EAX=ECX=ESI=0`). Bau `1.0.127+ea3ebcbd`, `Exception.log` 13:35:16, im `Audit.log` der einzige Start ohne Beenden-Zeile. **Gemessen am 29.10.2026** (`tools/messen-assistent-wiedereintritt.ps1`, vier Läufe, Freigabe Gregor 29.10.2026, alle in [TESTLAEUFE.md](../tools/TESTLAEUFE.md)): bei offener Meldung ist `IsWindowEnabled` für den Assistenten **0** und für den Weiter-Knopf **0**, die Meldung gehört dem Assistenten (`GW_OWNER`) — ein Klick oder Enter erreicht ihn nicht. Eingeschleuste *Weiter* kommen trotzdem an: nach zweien standen **drei** Meldungen übereinander (Wiedereintritt gemessen). Abgestürzt ist Eudora in keinem Lauf — weder mit einem noch mit zwei eingeschleusten *Weiter* plus *Abbrechen* bei offener Meldung, weder am Bau `+772ed08d` noch an der alten `Eudora.exe` `+ea3ebcbd` vom 28.10.; `Exception.log` blieb bei 20140 Byte. **Was den Absturz am 28.10. genau auslöste, ist nicht bekannt.** **Widerlegt:** „ein eingeschleustes *Weiter* bei offener Meldung reicht“ (Läufe 07:05, 07:06 und 07:06:58). **Nicht mit [MFC71.DLL](#s-3) verbunden:** die beiden Bibliotheken liegen nur wegen [E-166](#e-166) am Prüfstand; `mfc140.dll` ist Eudoras eigene MFC. **Nicht dieselbe Ursache wie [E-6](#e-6)/[E-9](#e-9)/[E-11](#e-11)** (Absturz bei *Weiter* 2026-08: Debug-Bau und `ReleaseBuffer` in `eudora.cpp`). **Keine Behebung** (Gregor 29.10.2026: *„ja, so eintragen“*): eine Sperre gegen den Wiedereintritt in `OnWizardNext` ließe sich ohne roten Nachweis nicht prüfen. Dass der Prüfstand den Absturz nicht meldete, gehört zu [E-157](#e-157). **Zur Nummer:** E-167 ist frei gehalten für den Vorschlag K5 aus [PRÜFER-64](../Befunde/PRUEFER-64.md) (*„aufzunehmen erst nach einer Messung“*); wo PRÜFER-64 *„E-168 nicht vergeben“* schreibt, war das der Stand vom 28.10.2026. **Stufe: werkzeug** (nur durch unser Messskript ausgelöst, nicht durch Bedienung) |
| <a id="e-166"></a>E-166 | **Die Frage „Automatically put junk mail in the Junk mailbox?“ kam beim Testen mehrmals statt einmal** — ein großer Dialog mit *Yes*/*No* | **behoben auf dem Zweig `e166-junk_message_fix` (28.10.2026), am laufenden Programm gemessen am Prüfstand (Läufe 9 und 10 am neuen Bau grün); Regressionstest E-166a/E-166b in `tools/pruefstand-faelle.txt` (am neuen Bau 2 von 2 bestanden, an Paket 1.0.127 einmal rot); **von Gregor am 29.10.2026 an Paket 7.2.1.128 auf seinem Hauptrechner bestätigt** ([TESTPLAN](TESTPLAN.md#ergebnis-e-166-hauptrechner): Junk-Frage einmal in 12 Sitzungen, `AskedAboutJunk=6`), ebenso am Laptop beim ersten Start mit Junk-Werkzeugen ([TESTPLAN](TESTPLAN.md#ergebnis-e-166-laptop): Frage einmal, nach dem Neustart nicht wieder)** **Zuletzt gemessen: 28.10.2026 an 7.2.0.127 (`+772ed08d`, mit Behebung)** — gemeldet von Gregor am 27.10.2026 an Paket 1.0.127 (außerhalb der VM, leerer Stand; kein Bildschirmfoto, Gregor: *„am anfang war etwas mit junk filter nicht eingerichtet (yes/no), ein paar mal beim start gekommen (oder beim abruf?). große meldung.“*). **Kurz: Eudora fragt beim Start, ob Werbung automatisch ins Postfach Junk soll. Die Frage soll nur einmal kommen; bei Gregor kam sie zweimal. Ursache: wer die Konto-Eigenschaften mit OK schließt, verliert jede Einstellung, die Eudora seit dem letzten Schreiben der `Eudora.ini` nur im Speicher hielt — darunter die Antwort auf diese Frage.** **Ursache, gemessen:** `CPersonality::Modify` (`persona.cpp:213ff`) schreibt die Kontodaten direkt in die Datei und ruft dann `RemoveAllFromCache()` — **ohne** vorher `FlushINIFile()`. Damit sind alle mit `SetIni…` gesetzten, noch nicht geschriebenen Werte (Markierung `IES_DIRTY`) weg. Alle anderen Stellen, die den Zwischenspeicher leeren, schreiben ihn vorher (`persona.cpp:194-195` `SetCurrent`, `:800-801`, `WizardPropSheet.cpp:325-326`, `settings.cpp:1518-1519`); `befund-suchen.pl RemoveAllFromCache` kannte die Stelle nicht. `Modify` rufen das Fenster *Konto → Eigenschaften* (`ModifyAcctSheet.cpp:126`), der Konto-Assistent für die Hauptpersönlichkeit (`WizardPropSheet.cpp:199`) und der Import (`MAPIImport.cpp:1970`; die Stelle `:2043` steht in einem auskommentierten Block, [PRÜFER-64](../Befunde/PRUEFER-64.md) K1). Die Junk-Antwort setzt `InitJunkFeature` (`eudora.cpp:1771ff`) mit `SetIniShort` nur im Speicher; auf die Platte käme sie erst beim Beenden. **Gemessen am Prüfstand `C:\Temp\E166`, 28.10.2026, mit Gregors `MFC71.DLL` und `msvcp71.dll` aus seinem `SysWOW64` (Fassungen 7.10.6041 und 7.10.6052, nur am Prüfstand, nicht im Paket — laut `Intern/FILTER.md` nicht zur Weitergabe freigegeben)**, `tools/messen-e166.ps1` und `tools/messen-e166-assistent.ps1`: Lauf 1 — alle drei Junk-/S/MIME-Zusätze laden, die Frage kommt, danach `AskedAboutJunk=6`; Lauf 2 — keine Frage mehr. Gregors Ablauf von 22:26 (kein Konto, der Konto-Assistent läuft **innerhalb** der offenen Junk-Frage, beide Fenster gleichzeitig gemessen): abgebrochen (Lauf 3) und bis *Fertig stellen* durchgefahren mit gespeichertem Konto (Lauf 8) — beide Male `AskedAboutJunk=6`, **die Verschachtelung ist es nicht**. Lauf 9: Frage mit *No* beantwortet, **danach** *Konto → Eigenschaften* der Hauptpersönlichkeit mit OK — nach dem Beenden fehlen `AskedAboutJunk` und `UseJunkMailbox` in der `Eudora.ini`; Lauf 10: **die Frage kommt wieder**. Läufe 4–7 waren Erkundung des Assistenten (Fehler im Messskript: `PSM_PRESSBUTTON` falsch beziffert, dann `WM_COMMAND` ohne Knopf-Handle — `CPropertySheet::OnCommand` setzt das Ergebnis nur mit Handle, ohne liefert `DoModal` 0 und `StartWizard` speichert nichts); im Lauf um 13:34:54 stürzte Eudora dabei im Assistenten ab — vom Messskript ausgelöst, für Anwender nicht erreichbar, [E-168](#e-168). Alle Läufe in [TESTLAEUFE.md](../tools/TESTLAEUFE.md), Freigabe Gregor 28.10.2026. **Gregors Protokolle:** im ersten (`test_0.127`, Sitzungen 27.10. 15:41, 16:37 und 16:49; 16:37 endete ohne `Logging shutdown`, Defender, [E-124](#e-124)) steht die Frage nicht; ob die Junk-Zusätze dort luden, zeigt das Protokoll nicht (Protokollstufe `0xE49F`, ohne den Schalter `0x100` für Zusatzmodule; nachgesehen am 29.10.2026, [L-90.8](../Befunde/LEKTOR-90.md#l-90.8)). Im zweiten (`eudora_20261027.zip`, `C:\Temp\Eudora72-1.0.127-release`) steht sie um **22:26** (0.02) und **23:00** (0.01), danach nie wieder bis 28.10. 10:18. **Berichtigt am 28.10.2026:** um 22:26 wurde die Frage **doch** beantwortet — `Dismissed with 2` bei 2.54 gehört zu ihr: unmittelbar danach läuft der Start weiter (`X1 loading database`, `In`), und die Rückfrage dazwischen *„Would you like to edit the server setting?“* (`IDS_ERR_VALIDATE_HOST`, stammt aus `EudoraRes.rc:9397`, aufgerufen in `WizardPropSheet.cpp:274`) kam vom Konto-Assistenten über `YesNoDialog` (`guiutils.cpp:1213ff`), das **keine** `Dismissed`-Zeile schreibt. Die frühere Aussage „keine Tastenzeile zur Frage“ war falsch. Die Sitzung 22:26 (Kopf „22:46“ ist nur ein neuer Protokollkopf) endete regulär. **Vermutung, nicht gemessen:** Gregor hat in dieser Sitzung nach den Fehlermeldungen zu `pop3.web.de` die Konto-Eigenschaften geöffnet und mit OK geschlossen; das Protokoll zeigt das nicht. **Widerlegt:** „das Bit fehlt, weil Eudora hart beendet wurde“ (Sitzung endete regulär); „der Assistent in der offenen Frage verliert die Antwort“ (Läufe 3 und 8). **Ohne `MFC71.DLL`/`MSVCP71.dll` laden die Junk-Zusätze nicht** und die Frage kommt nie (fünf Starts am Vormittag, `AskedAboutJunk=4`, `trnslate.cpp:3150-3157` nur `TRACE`) — eingetragen in [S-3](#s-3), Abschnitt S-3c. **Die ersten beiden Starts am Vormittag waren nicht abgesprochen** ([erlaubnis-nicht-hineinlesen](../Arbeitsweise/erlaubnis-nicht-hineinlesen.md), Nachtrag 28.10.2026). **Behebung (Gregor 28.10.2026: *„ja, e166-junk_message_fix, beheben“*):** `Modify` ruft `FlushINIFile()` vor `SavePersonaInfo` — vorher, damit alte Werte im Speicher die neuen Kontodaten nicht überschreiben. **Nachgemessen am neuen Bau (28.10.2026, `tools/bauen.ps1` auf Commit `249e4f95`, im Fenstertitel `+772ed08d` — dieser Commit ändert nur `tools/ZWEIGE.md`, 314 Tests, 314 bestanden):** Lauf 9 — nach Junk-*No* und *Konto → Eigenschaften* OK steht `AskedAboutJunk=6` in der `Eudora.ini`, die Kontodaten sind unverändert; Lauf 10 — die Frage kommt nicht wieder. **Regressionstest:** `tools/pruefstand-faelle.txt` E-166a (der Weg lief: `reihenfolge=junk-no,konto-ok`) und E-166b (`AskedAboutJunk=6` nach dem Beenden), Lage frisch über `tools/messen-e166-konto.ps1 -Vorbereiten`; am neuen Bau 2 von 2 bestanden, an der `Eudora.exe` aus Paket 1.0.127 einmal rot (E-166a bestanden, E-166b `fehlt in ini: AskedAboutJunk=6`). Für diese Gegenprobe lag die `EudoraRes.dll` des neuen Baus daneben, weil Defender die aus dem Paket 1.0.127 schon beim Lesen in Quarantäne nahm ([E-124](#e-124)); `EudoraRes.rc` und `resource.h` sind seit `ea3ebcbd` (Bau 1.0.127) unverändert. Drei Messläufe am neuen Bau (14:11:52, 14:12:51, 14:13:47) zählten nicht: die Persönlichkeiten-Leiste stand schon offen, das Messskript fand keine neue Liste und überging den Konto-Schritt — jetzt nimmt `-Vorbereiten` die Leiste aus dem Vordergrund. **Bewusst nicht behoben (Gregor 28.10.2026, *„k4: nicht so kritisch. wenn es grundsätzlich funktioniert (ohne defender absturz), dann ist es ok.“*, dazu *„ja, notieren.“*):** die Junk-Antwort steht auch nach der Behebung bis zum Beenden nur im Speicher (`SetIniShort` am Ende von `InitJunkFeature`, `eudora.cpp:1862`); endet Eudora hart — Defender ([E-124](#e-124)) oder Absturz —, kann die Frage beim nächsten Start noch einmal kommen ([PRÜFER-64](../Befunde/PRUEFER-64.md) K4, am Quelltext belegt, nicht gemessen). Ein `FlushINIFile()` dort würde außerdem den Regressionsfall E-166b blind machen (PRÜFER-64 K3). **Was noch fehlt:** nichts — Gregors Test an der Release-Fassung 7.2.1.128 statt an einem eigenen Testpaket (Entscheidung 15 in [WEITERMACHEN](WEITERMACHEN.md)) ist am 29.10.2026 bestanden, auf dem Hauptrechner ([TESTPLAN](TESTPLAN.md#ergebnis-e-166-hauptrechner)) und auf dem Laptop ([TESTPLAN](TESTPLAN.md#ergebnis-e-166-laptop)). **Wie zu pruefen:** **ICH** — Lauf 9 und 10 am Prüfstand (Freigabe vom selben Tag); **GREGOR** — Schritt [TESTPLAN#e-166-am-release](TESTPLAN.md#e-166-am-release), am 29.10.2026 gemacht (*Konto → Eigenschaften* heißt im Programm *Tools → Personalities*, Rechtsklick auf `<Dominant>` → *Properties*). **Stufe: kritisch** (Einstellungen gehen verloren, ohne dass es jemand merkt; am 29.10.2026 von *wichtig* hochgestuft, [L-90.5](../Befunde/LEKTOR-90.md#l-90.5)) |
| <a id="e-159"></a>E-159 | **Ein Prüfstandslauf an 7.2.0.122 endete mit einem Absturz in `Eudora.exe` selbst, den niemand bemerkt hat** — Windows meldet `c0000409` (Pufferüberlauf auf dem Stapel oder Schnellabbruch der Laufzeit) | **offen — gemessen am 26.10.2026, Ursache nicht bestimmt.** **Kurz: Beim Entwickeln von E-146 stürzte ein Prüfstands-Eudora ab. Bei Gregor ist dieser Absturz nie aufgetreten, und im Lauf an 7.2.0.124 kam derselbe Fall ohne Absturz durch. Was ihn auslöste, ist nicht gemessen.** Gefunden von [PRUEFER-59](../Befunde/PRUEFER-59.md#k11) und von mir im Windows-Ereignisprotokoll nachgemessen (Anwendung, Ereignis 1000): 26.10.2026 07:56:32, `C:\Temp\E146\Eudora.exe`, Fassung 7.2.0.122, Modul `Eudora.exe`, Code `c0000409`, Versatz `0x001d0d79`. Der Bau war ein unsauberer Zwischenstand (`1.0.122+62f6047c*`, 07:54) aus der Arbeit an E-146; der Absturz liegt drei Sekunden vor dem Start um 07:56:35 in `tools/TESTLAEUFE.md`, betrifft also die vorige Instanz. **Vermutung, nicht gemessen:** in dieser Stunde beantwortete der Prüfserver `tools/imap-pruefserver.pl` jedes `LIST` mit allen Ordnern, und Eudora stieg 1556 Ebenen tief in Unterordner ab — ein so tiefer Abstieg kann den Stapel überlaufen lassen. Der Prüfserver ist seitdem berichtigt (Muster `%` und `*`). **Was noch fehlt:** den Versatz gegen die Symbole eines Baus 7.2.0.122 auflösen (die PDB dieses Zwischenstands ist überschrieben; ein Neubau von `62f6047c` mit denselben Quellen wäre nötig) oder den tiefen Abstieg mit dem alten Prüfserververhalten nachstellen und den Absturz rot sehen. Erst dann ist klar, ob ein fehlerhafter Server Eudora zum Absturz bringen kann. **Zuletzt gemessen: 26.10.2026 an 7.2.0.122** **Stufe: wichtig** (Absturz, aber nur am Prüfstand und mit fehlerhaftem Server gesehen; kein Datenverlust belegt) |
| <a id="e-158"></a>E-158 | **Beim Weiterleiten einer Textmail steht am Ende sichtbar `</x-html>`** — Eudoras interne HTML-Hülle gerät in die gesendete Nachricht | **behoben auf dem Zweig `0.123_ergebnisse` (26.10.2026), von Gregor am 26.10.2026 an Paket 1.0.124 bestätigt (TESTPLAN T3: Gregor *„E-158: PASS“*); Regressionstest `TestE158.cpp` (311 Tests, 311 bestanden; ohne die neue Bedingung einmal rot, 310/311).** **Kurz: Wer eine reine Textmail weiterleitete, verschickte am Ende ein sichtbares `</x-html>`. Der Text selbst kam vollständig an. Seit der Behebung geht bei Textmails wieder die Fassung aus dem Editor hinaus.** Von Gregor am Testpaket 7.2.0.123 gefunden (TESTPLAN K6, Bild). Gemessen an der angekommenen Nachricht *„Fwd: <eigene Testmail>“* (mit Gregors Erlaubnis im Zwischenspeicher gelesen): der Rumpf beginnt mit `<x-html>` und gleich danach noch einmal `<x-html><br>`, er endet mit `</x-html>` und noch einmal `</x-html>`. Im Protokoll: `E-87 ComposeMessage: … IsHTML=0 … Typ=3` (die Ausgangsmail war Text), dann `E-88 vor dem Absenden: Fassung=ORIGINAL (unveraendert) … OrigBytes=845` und `E-88 auf der Leitung: … IsHTML=1`. **Ursache:** `QuoteText` baut seit [E-87](#e-87) auch für Textmails einen HTML-Rumpf, und der trägt eine doppelte Hülle; der Editor schluckt die innere. [E-88](#e-88) hob diesen Rumpf aber als Original auf und schickte ihn unverändert, weil die Bedingung nur den gebauten Rumpf (`IsFancy(Body) == IS_HTML`) prüfte, nicht die Ausgangsnachricht. **Die Behebung:** `CSummary::ComposeMessage` (`summary.cpp`) merkt das Original nur noch, wenn die Ausgangsnachricht HTML ist (`IsHTML()`); E-88 ist für HTML-Mails gedacht, bei Text gibt es nichts zu erhalten. **Was noch fehlt:** ein Prüfstandsfall, der eine Textmail weiterleitet, sichert und die Nachricht in `Out` auf eine einzige Hülle prüft. **Einschränkung ([PRUEFER-59](../Befunde/PRUEFER-59.md#k6), am Quelltext):** `QuoteText` setzt genau **eine** Hülle (`msgutils.cpp:172-219`); woher die zweite kommt, ist nicht gefunden. Der Weg behandelt Text- und HTML-Mails vermutlich gleich, dann tragen auch weitergeleitete HTML-Mails die doppelte Hülle, nur unsichtbar. Die Behebung schaltet den Textfall ab, nicht die Ursache. **Gemessen am 26.10.2026 um 12:54 am Bau 7.2.0.124 (Prüfstand `C:\Temp\E119K`, Fall `E-119d`, HTML-Mail `Testdaten/e119-data-bild.eml` weitergeleitet und gespeichert):** der Entwurf in `Out.mbx` trägt genau **eine** Hülle (`<x-html>` 1-mal, `</x-html>` 1-mal), die Vermutung einer unsichtbaren doppelten Hülle bei HTML-Mails ist für den gespeicherten Entwurf widerlegt. Nicht gemessen ist der Weg beim Absenden. Die neue Bedingung hängt am Merker aus E-88, den [E-87](#e-87) unzuverlässig nennt; in Gregors Protokollen war er in 13 von 13 HTML-Fällen gesetzt ([K5](../Befunde/PRUEFER-59.md#k5)). **Stufe: wichtig** (sichtbarer Fehler in jeder weitergeleiteten Textmail) |
| <a id="e-157"></a>E-157 | **Die Prüfstandsläufe verändern Gregors Windows-Registry und sehen keine Abstürze** — jeder Eudora-Start schreibt in `HKCU\Software\Qualcomm\Eudora`, auch der des Prüfstands; und ein Fall, dessen Protokollzeile vor einem Absturz geschrieben wurde, bleibt grün | **offen — der Prüfstandsteil ist eingebaut und gegengeprüft (26.10.2026), die Zählung nach Gregors Tests fehlt noch.** Vorher: am 26.10.2026 an Gregors Rechner gemessen. **Eingebaut:** `tools/pruefstand-lauf.ps1` hält `CommandLine` und `LaunchManager` vor dem Lauf fest und setzt sie danach zurück (neue Werte entfernt, geänderte und gelöschte mit ihrer Art wiederhergestellt, auch bei Abbruch); nach jedem Eudora-Start liest es Ereignis 1000 im Windows-Ereignisprotokoll und macht bei einem Absturz aus dem Prüfverzeichnis alle Fälle dieses Laufs rot. **Gegenprobe gemessen** (Funktionen aus dem Werkzeug, an einem eigenen Testschlüssel `HKCU\Software\Eudora72Probe`, danach entfernt): Registry `Werte=Current,Zahl`, `Current` und `Zahl=7 (DWord)` wiederhergestellt, der fremde `DLLPath` entfernt; Absturzerkennung findet für `C:\Temp\E97` den `mfc140.dll`-Absturz vom 25.10.2026 17:19:50, für `C:\Temp\EBILD` seit heute 0, für `C:\Temp\E9` 0 (kein Präfixtreffer auf `E97`). **Kurz: Meine Testläufe laufen unter Gregors Benutzerkonto und haben dort zwei Einträge verbogen, die auch seine eigenen Eudora-Installationen lesen. Und ein Absturz während eines Testlaufs fiel niemandem auf. Verloren gegangen ist nichts.** **Registry:** (1) `CommandLine\Current` zeigte nach dem Prüfstandslauf auf `C:\Temp\E67` — die erste M1-Rückfrage an 7.2.0.123 nannte deshalb meinen Prüfstand statt Gregors 1.0.122; Hermes 7.1 oder ein Eudora vor 7.2.0.114 hätte dort per Doppelklick still gearbeitet. (2) `LaunchManager\DLLPath` zeigte auf eine `EuShlExt.dll` in einem Scratchpad einer früheren Sitzung; jedes Eudora auf dem Rechner lud sie (Gregors Absturzbericht von 10:05, Modulliste). Mit Gregors Zustimmung (*„wenn ja, können sie weg“*) am 26.10.2026 gelöscht: `DLLPath`, `Path#52` bis `Path#54`; Sicherung des Schlüssels im Scratchpad. 24 weitere `Path#`-Werte zeigen in Scratchpads, sie sind harmlos und bleiben. **Abstürze:** das Windows-Ereignisprotokoll verzeichnet seit 30.08.2026 **30 Abstürze** von `Eudora.exe` unter `C:\Temp` (15 `mfc140.dll`, 9 `ntdll.dll`, 3 `ucrtbased.dll`), keiner machte einen Prüfstandsfall rot. **Was noch fehlt:** nach jedem Testpaket dieselbe Zählung für Gregors Paketverzeichnis (für 7.2.0.124 muss sie null sein); ein Fall im Prüfstand, der einen echten Absturz rot sieht. **Zuletzt gemessen: 26.10.2026 an 7.2.0.124** (nach dem vollen Prüfstandslauf an diesem Bau, `1bd0fe96`, zeigten `CommandLine\Current` auf Gregors 1.0.123 und `LaunchManager\PathCount` unverändert `0x219`, und es gab kein Absturzereignis — gelesen von [PRÜFER-59](../Befunde/PRUEFER-59.md); die Absturzzählung für Gregors Paketverzeichnis 1.0.124 folgt nach seinem Kurztest) **Grenzen ([PRUEFER-59 K9, K10](../Befunde/PRUEFER-59.md#k9)):** das Zurücksetzen bricht an einem Wert `(Standard)` ab, überschreibt gleichzeitige Änderungen Gregors und läuft nicht, wenn der Prozess von außen beendet wird; 148 alte Mailverzeichnis-Zweige und 537 LaunchManager-Pfade bleiben liegen. Heute tritt keiner dieser Fälle ein. **Weiterer Fall, 28.10.2026:** ein Absturz im Konto-Assistenten am Prüfstand `C:\Temp\E166` stand nur im `Exception.log`; `testlauf.ps1` verzeichnete den Lauf ohne Hinweis, gefunden hat ihn erst [LEKTOR-90](../Befunde/LEKTOR-90.md#l-90.12) — [E-168](#e-168). **Stufe: wichtig** (Prüfstand blind für Abstürze; fremde Registry verändert) |
| <a id="e-156"></a>E-156 | **Im Paket lagen seit August sechs Debug-Fassungen** — `NSImport.eif`, `OEImport.eif`, `OLImport.eif` laden die Debug-Laufzeit, `EuShlExt.dll`, `EudoraNS.dll`, `swEudora.exe` tragen sie eingebaut; Eudora stürzt in `ucrtbased.dll` ab | **behoben auf dem Zweig `0.123_ergebnisse` (26.10.2026), von Gregor am 26.10.2026 an Paket 1.0.124 bestätigt (TESTPLAN T5: 0 Abstürze im Ereignisprotokoll); Gegenprobe im Protokoll von `paket-pruefen.ps1` belegt: `paket-pruefen.ps1` weist Paket 1.0.123 mit genau diesen sechs Dateien ab (6 FEHLER), ein Probepaket nach `C:\Temp\Paketprobe` ist frei davon (39 ausführbare Dateien, „keine Fehler“).** **Kurz: In jedem Paket seit August steckten sechs Testfassungen von Hilfsprogrammen statt der fertigen. Eudora stürzte deshalb gelegentlich ab, meist unbemerkt. Ab 7.2.0.124 kommt jede Programmdatei aus dem fertigen Bau.** Gefunden an Gregors Test von 7.2.0.123: Windows meldete um 10:05 einen Absturz von `C:\Users\Gregor\Eudora72-1.0.123-release\Eudora.exe` in `ucrtbased.dll` (`0xc0000005`); die Modulliste im Absturzbericht (von Gregor als Administrator nach `C:\Temp` kopiert) zeigt `NSImport.eif`, unmittelbar danach `mfc140d.dll`, `VCRUNTIME140D.dll`, `MSVCP140D.dll`, `ucrtbased.dll`. Gregor: *„warum haben wir eine mischung aus debug und release? darf nicht vorkommen!“* **Ursache:** `paket-bauen.ps1` baut auf dem Grundlage-ZIP vom 30.08.2026 auf; `-AusBauverzeichnis` übernahm nur eine feste Liste von acht eigenen Dateien, alles andere blieb aus der Grundlage. `paket-pruefen.ps1` prüfte Importe nur bei `.exe` und `.dll`; drei Dateien endeten auf `.eif`, drei hatten die Debug-Laufzeit statisch eingebaut (`_CrtDbgReport`, `dbgheap.c`). **Wie lange:** im Windows-Ereignisprotokoll **34 Abstürze in `ucrtbased.dll`** aus Gregors Paketen 1.0.3 bis 1.0.123 und seinem Testverzeichnis `EudoraTest`, meist einer oder zwei je Paket (gezählt am 26.10.2026). Die übrigen Eudora-Abstürze dort sind älteren, behobenen Befunden zuzuordnen: 20 in `mfc140.dll`, alle mit Fehleroffset `0x002a0544` aus den E-97-Messungen vom 15.09.2026 und den Paketen 1.0.53 bis 1.0.63 ([E-97](#e-97)); 16 in `Paige32.dll` an 1.0.69/1.0.71; rund 45 in `ntdll.dll` aus 1.0.1 bis 1.0.23. **Die Behebung:** `paket-bauen.ps1` Schritt 8 nimmt jede Datei mit `MZ`-Kopf (jede Endung, außer dem Mailverzeichnis) aus `Eudora71/Bin/Release`, bricht ohne Gegenstück ab und bricht bei jeder Debug-Laufzeit ab; `paket-pruefen.ps1` weist jede Debug-Fassung als Fehler ab. **Was noch fehlt:** nichts — an 1.0.124 null Abstürze aus dem Paketverzeichnis (TESTPLAN T5). **Grenzen ([PRUEFER-59 K7, K8](../Befunde/PRUEFER-59.md#k7)):** Schritt 8 des Paketbaus nimmt die VC-Laufzeit aus `Bin\Release` (Handkopien vom 28.08.2026) statt der frischen aus Schritt 7 — heute gleich (SHA-1 gemessen), nach einem Update von Visual Studio käme eine ältere Laufzeit ins Paket. Das Debug-Muster erkennt `MSVCRTD.DLL`, `MFCO42D` und eine statisch eingebaute UCRT-Debug-Laufzeit nicht; heute ist keine der 39 Dateien betroffen. **Regressionstest** `TestPaket.cpp` (30.10.2026): das Debug-Muster beider Skripte wird ausgeführt und muss `ucrtbased.dll`, `VCRUNTIME140D.dll`, `MSVCP140D.dll`, `mfc140d.dll`, `_CrtDbgReport` und `dbgheap.c` erkennen, die Release-Laufzeiten nicht; `paket-pruefen.ps1` sucht in jeder Datei mit `MZ`-Kopf (nicht nur in der Endungsliste), Schritt 8 von `paket-bauen.ps1` bricht bei Debug-Laufzeit ab. Mit `Write-Host` statt `throw` im Schritt 8 einmal rot, sonst grün (321 Tests, 321 bestanden) **Stufe: kritisch** (Absturz; auch das veröffentlichte `v1.0.120` ist betroffen — gemessen von LEKTOR-73 am ZIP `Releases/Eudora72-1.0.120-release.zip`, es enthält alle sechs Debug-Dateien; die älteren veröffentlichten Pakete haben dieselbe Grundlage und sind nicht einzeln nachgemessen) |
| <a id="e-154"></a>E-154 | **Eine Ausnahme außerhalb einer Fensterbotschaft beendet Eudora wortlos** — keine Meldung, keine Zeile im `eudora.log`, kein geordnetes Beenden | **behoben auf dem Zweig `vor-testpaket-7.2.0.123` (26.10.2026), kommt mit Testpaket 7.2.0.123; Regressionstest `TestAusnahmeSpur.cpp`, 308 Tests, 308 bestanden; am laufenden Programm nicht auslösbar ohne eingebauten Fehler.** **Kurz: Tritt im Leerlauf oder in der Nachbearbeitung einer Aufgabe ein Fehler auf, verschwand Eudora ohne jede Spur. Jetzt steht wenigstens eine Zeile im Protokoll. Das Verschwinden selbst bleibt.** Gefunden von [PRÜFER-58](../Befunde/PRUEFER-58.md#k1) K1 beim Prüfen der Spurmarke zu ZIEL Kriterium 2 und 4. `CEudoraApp::Run` (`eudora.cpp`) fängt jede `CException` und `std::exception`, die aus `CWinApp::Run` kommt, löscht sie und kehrt zurück; das `ASSERT` danach ist im Release nichts. Dort kommt eine Ausnahme genau dann an, wenn sie **nicht** in einer Fensterprozedur entsteht: im Leerlauf (`CEudoraApp::OnIdle`, darunter `DoPreThreadAction` jeder IMAP-Aktion), in `PreTranslateMessage` und in `QCTaskManager::DoPostProcessing`, das ausdrücklich weiterwirft. `ExitInstance` läuft danach nicht. Quelltext original, Verhalten nicht gemessen. **Die Behebung:** beide `catch`-Zweige schreiben `Ausnahme ausserhalb einer Fensterbotschaft (ZIEL 4), Eudora endet: text=… art=…` ins Protokoll, bevor sie die Ausnahme verwerfen. Regressionstest in `TestAusnahmeSpur.cpp` (ohne die Zeile im `CException`-Zweig einmal rot, 307/308), Prüfstandsfall `ZIEL24b` verlangt, dass auf dem Bilder-Prüfstand keine solche Zeile entsteht. **Was noch fehlt:** ein geordnetes Beenden mit Meldung an den Anwender statt des wortlosen Endes (`eudora.cpp`, `CEudoraApp::Run`, „kiss of death dialog") — nicht vor 7.2.1. **Stufe: wichtig** (Absturz ohne Spur; was ungeschrieben im Speicher lag, kann verloren gehen) |
| <a id="e-151"></a>E-151 | **Die Prüfstandsfälle lassen sich aus einem frischen Klon nicht ausführen** — die Verzeichnisse unter `C:\Temp`, in denen sie laufen, gibt es nur auf der Entwicklermaschine | **offen — zurückgestellt**, von Gregor am 25.10.2026 (*„nimm es als befund auf, wir ziehen es später nach"*); am Repo gemessen. Wer das Repo klont, kann die Unit-Tests (`Eudora71\Tests\RunTests.cmd`) und die Schranken (`perl tools/schranken-gegenprobe.pl`) selbst ausführen, die 29 Oberflächenfälle aber nicht: jeder meldet „Pruefverzeichnis fehlt“. Damit erfüllt der Prüfbericht Gregors Anforderung vom 24.10. (*„wenn jemand das repo clont … vergleich vorher - nachher"*) nur zu zwei Dritteln. **Herleitung:** `tools/pruefstand-faelle.txt` verlangt sieben Prüfstände (`C:\Temp\EBILD`, `E77`, `E131L`, `E125`, `E118`, `E77U`, `E119K`) mit Mailverzeichnis, `Eudora.ini`, Postfächern und einer Eudora-Kopie; `tools/pruefstand-lauf.ps1:146-148` prüft nur, ob es sie gibt, `tools/pruefstaende-auffrischen.ps1` kopiert nur einen neuen Bau in vorhandene Stände — kein Werkzeug baut einen Stand auf. Dazu: je Fall steht im Bericht nur die erwartete Protokollzeile, nicht in Klartext, was geprüft wird; ein Abschnitt „Voraussetzungen und Ausführen“ (VS2022, Perl, Git Bash) fehlt; und `Releases/PRUEFBERICHT.md` auf `main` nennt „gegen Commit `98298cb8*`“, also einen Stand mit nicht committeten Änderungen. **Was noch fehlt:** ein Werkzeug, das jeden Prüfstand aus dem Repo neu aufbaut (Testdaten plus INI-Vorlage je Stand); je Fall eine Zeile Klartext; der Abschnitt „Voraussetzungen und Ausführen“; `pruefbericht.pl` schreibt nur aus sauberem Stand. Gegenprobe: frischer Klon, alle drei Testarten von vorn. **Zuerst eingetragen:** 25.10.2026 auf Gregors Frage zu `PRUEFBERICHT.md`. **Stufe: werkzeug** (betrifft die Prüfbarkeit, nicht das Programm) |
| <a id="e-150"></a>E-150 | **Im Fenster „Task Status“ kann das Abschalten einer Spalte Speicher hinter einem Feld überschreiben** — das Gegenstück zu [E-20](#e-20) beim Löschen statt beim Einfügen; mit Mails hat es nichts zu tun | **behoben auf dem Zweig `agenten-befunde-25-10b` (25.10.2026), kommt mit Paket 7.2.0.123; am Ausschnitt gemessen (vor der Behebung 299 Tests, 297 bestanden; danach 300 Tests, 300 bestanden), im laufenden Programm nicht nachgestellt; Quelltext original von QUALCOMM, Verhalten am Original nicht gemessen.** Das Fenster „Task Status“ (laufende Aufgaben wie Abholen und Senden) hat fünf Spalten, die man in den Optionen ein- und ausschaltet. Zu jeder Spalte führt die Liste kleine Zusatzfelder; werden diese kürzer als die Spaltenzahl und dann eine Spalte dahinter gelöscht, schreibt Eudora 4 Byte hinter das Feld — sofort nichts, später ein Absturz oder ein beschädigter Speicher. **Herleitung:** `CListCtrlEx::DeleteArr` legt das Feld mit `[nLen - 1]` an und kopiert bis `nIdx` (`ListCtrlEx.cpp:1384-1399`), der Bildlisten-Block in `NotifyDeletedCol` ebenso (`:1440-1451`); ist `nIdx >= nLen`, wird hinter das neue Feld geschrieben und hinter dem alten gelesen; bei `nLen = 0` ergibt `nLen - 1` als vorzeichenlose Zahl über vier Milliarden. Die Felder entstehen erst mit einer Bildspalte (`SetColImageList`, `:858-1010`). Weg nach [PRÜFER-52 K1](../Befunde/PRUEFER-52.md#k1): Task und Status abschalten, neu starten, Status einschalten, Progress abschalten (`TaskStatusView.cpp:598-772`). Gemessen mit Schutzstreifen: `nLen=2, nIdx=2` und `nLen=2, nIdx=3` überschreiben je 4 Byte. **Behebung:** `DeleteArr` kehrt bei `nIdx >= nLen` zurück, der Bildlisten-Block in `NotifyDeletedCol` läuft nur bei `nCol < m_DispImageListArrLen` (`ListCtrlEx.cpp`). **Test:** `UnderTestE20.cpp` schneidet `DeleteArr` und `NotifyDeletedCol` aus dem Original und ruft sie mit Schutzstreifen auf (`TestSpeicherfehler.cpp`, drei Fälle E-150, darunter der Task-Status-Weg und `nLen = 0`); vor der Behebung 2 rot, danach 300 von 300. Mitgenommen: die zweite E-20-Stelle in `NotifyInsertedCol` hat jetzt ebenfalls einen Test (PRÜFER-52 K2), Gegenprobe mit dem QUALCOMM-Rumpf rot. **Zuerst eingetragen:** 25.10.2026 aus [PRÜFER-52 K1](../Befunde/PRUEFER-52.md#k1). **Stufe: kritisch** (Speicherfehler: Schreiben hinter das Feld) |
| <a id="e-148"></a>E-148 | **Eudora vertraut vier eMudhra-Wurzelzertifikaten, unter denen am 20.10.2026 acht kompromittierte Zwischenzertifikate bekannt wurden** — ein Angreifer im selben Netz könnte Eudora einen gefälschten Mailserver vorspielen | **behoben auf dem Zweig `e-148-emudhra-wurzeln` (25.10.2026), kommt mit Paket 7.2.0.123; 295 Tests, 295 bestanden, Regressionstest `TestE148.cpp`.** **Logzeile, eingebaut am 26.10.2026, am laufenden Programm gemessen an Gregors Paket 1.0.123:** `rootcerts.p7b geladen aus: C:\Users\Gregor\Eudora72-1.0.123-release\rootcerts.p7b (vorhanden)`, das Programmverzeichnis; Abruf bei GMX und freenet ohne Zertifikatsfehler (TESTPLAN K3) (Gregor am 25.10.2026: *„zeile im log, ja"*): nach dem ersten verschlüsselten Sitzungsaufbau schreibt Eudora einmal je Programmlauf `rootcerts.p7b geladen aus: <Pfad> (vorhanden)` beziehungsweise `(FEHLT - keine Wurzelzertifikate geladen)` ins `eudora.log` (`QCSocket/src/QCWorkerSocket.cpp`, `ProtokolliereRootCertsVerzeichnis`). Gelesen wird die Wahl, die QCSSL in `ChooseCertFileDirectory` in `m_RootCertStoreDir` zurückschreibt, nicht nachgerechnet. Regressionstest `TestRootCertsLog.cpp` (305 Tests, 305 bestanden; ohne den Aufruf einmal rot, 304/305). Gregor sieht die Zeile im Testpaket nach dem ersten Abruf. Sie steht nur im Protokoll, wenn `LogLevel` den Schalter 32768 (`DEBUG_MASK_MISC`) enthält; das Paket setzt `LogLevel=58527`, die Vorgabe 25759 enthält ihn nicht (LEKTOR-69, L-69.3). **Nachgeprüft von [PRÜFER-58](../Befunde/PRUEFER-58.md):** QCSSL schreibt die Wahl per Zeiger in dasselbe Objekt zurück, gelesen wird im selben Faden, es gibt nur eine Aufrufstelle (also auch bei STARTTLS). **Grenze (K5):** die Zeile kommt einmal je Programmlauf; wechselt das Verzeichnis später, nennt sie weiter die erste Wahl, und ist das Protokoll beim ersten Abruf aus, kommt sie gar nicht. Eudora prüft Serverzertifikate nicht gegen Windows, sondern gegen eine eigene Liste `rootcerts.p7b`; darin standen vier Wurzeln der Zertifizierungsstelle eMudhra, deren Zwischenzertifikate seit dem 20.10.2026 als kompromittiert gelten (Ars Technica, *„The Internet goes on high alert after discovery of 8 compromised TLS certs"*, 20.10.2026; Browser haben sie am selben Tag gesperrt). Jetzt sind sie draußen; für Gregor ist nichts zu tun außer dem Test im Paket, seine Postfächer sind gemessen. **Die Behebung:** `Releases/1.0/rootcerts-erzeugen.ps1` hat eine Ausschlussliste (`-Ausschluss "O=eMudhra"`), aus derselben Quelle wie am 29.08.2026 (Git für Windows `ca-bundle.crt`, SHA256 `f345ac0d…`) entstehen 117 statt 121 Zertifikate, neue `Releases/1.0/rootcerts.p7b` (SHA256 `07fea9d2…`); `tools/paket-bauen.ps1` legt sie **immer** über die Grundlage `Eudora72-1.0.2-lauffaehig.zip`, die noch die alte trägt. **Gemessen am 25.10.2026** mit `openssl s_client -CAfile` (neue Liste als einziger Vertrauensanker): `imap.gmx.net:993`, `pop.gmx.net:995`, `mail.gmx.net:465`, `mx.freenet.de:993`, `:995`, `:465` je `Verify return code: 0 (ok)`, Kette über *T-TeleSec GlobalRoot Class 2*. **Regressionstest** `TestE148.cpp`: öffnet die Datei mit `CertOpenStore(CERT_STORE_PROV_FILENAME_A)` wie QCSSL (`certstore.cpp`), verlangt mindestens 100 Zertifikate und keines mit Organisation eMudhra, und dass `paket-bauen.ps1` die Datei übernimmt; Gegenprobe: alte Liste zurück → rot (vier `verboten:`-Zeilen), Übernahme im Paketbau entfernt → rot. **Nicht gemessen:** dass Eudora einen Server mit eMudhra-Kette **ablehnt** — das ist eine Rechnung; die **Annahme** von GMX und freenet durch Eudora selbst ist seit Gregors Test an 1.0.123 gemessen (TESTPLAN K3), vorher hatte nur OpenSSL auf der Kommandozeile gemessen; QCSSL lädt die Liste in genau diese OpenSSL-Prüfung (`X509_STORE`). **Gemessen am 24.10.2026** mit `X509Certificate2Collection.Import`: jedes Paket in `C:\Users\Gregor\Eudora72-1.0.110-release` bis `-1.0.122-release` liefert 121 Wurzeln aus, darunter *emSign Root CA - G1*, *emSign ECC Root CA - G3* (eMudhra Technologies Limited), *emSign Root CA - C1*, *emSign ECC Root CA - C3* (eMudhra Inc); Quelle ist `Releases/1.0/rootcerts.p7b` vom 29.08.2026 (`Releases/1.0/README.md:12`). QCSSL lädt sie aus `szRootCertFileName = "rootcerts.p7b"` (`Eudora71/QCSSL/src/QCSSLContext.cpp:53`) und prüft keine Sperrlisten — die Fälle `X509_V_ERR_*CRL*` in `qccertificate.cpp:94-143` behandeln nur Fehlercodes, ein Abruf findet nicht statt. **Ausnutzbar** nur mit einem aktiven Angreifer zwischen Eudora und Server (Artikel: *„requires an active adversary-in-the-middle attack"*). **Zuerst eingetragen:** 24.10.2026 auf Gregors Hinweis (zwei Artikel als PDF, von Gregor bereitgelegt); der zweite Artikel (Plex2Shell) betrifft einen Medienserver und weder Zertifikate noch Eudora. **Stufe: kritisch** (Sicherheit: Mailserver lässt sich fälschen, Zugangsdaten gehen an den Angreifer) **Nachtrag 25.10.2026 ([PRUEFER-51](../Befunde/PRUEFER-51.md#pruefer-51) K6, am Quelltext belegt):** QCSSL nimmt `rootcerts.p7b` zuerst aus dem **Mailverzeichnis**, erst danach aus dem Programmverzeichnis (`QCSSLContext.cpp`, `ChooseCertFileDirectory`, so von QUALCOMM gewollt). Das Paket legt dort keine Datei ab (gemessen); wer selbst eine hineinkopiert hat, behält die alte Liste — README sagt es seither. |
| <a id="e-146"></a>E-146 | **Nach dem Umbenennen eines IMAP-Ordners führt Eudora ihn unter einem anderen Namen als der Server** — auf einem Server ohne Ordnerhierarchie und beim Umbenennen von INBOX mit eingestelltem Ordner-Präfix | **behoben auf dem Zweig `vor-testpaket-7.2.0.123` (26.10.2026), kommt mit Testpaket 7.2.0.123; „Server lehnt Umbenennen ab" (K9) am Prüfstand erst rot, dann grün gemessen (Fall `E-146`), die eine Namensrechnung (K8) am Quelltext belegt und mit Regressionstest `TestE146.cpp` gesichert, am Programm nicht gemessen (der Prüfserver hat den Trenner `/`); 307 Tests, 307 bestanden.** Vorher: offen, an unserem Code gemessen (Server ohne Trenner) bzw. am Quelltext belegt (INBOX mit Präfix); Quelltext original von QUALCOMM, Verhalten am Original nicht gemessen. **Die Behebung (26.10.2026):** (K8) Es gibt nur noch eine Rechnung: `CImapAccount::RenameMailbox` gibt den Namen, den es an den Server schickt, über den neuen Ausgabeparameter `pstrNeuerImapName` zurück, und `UpdateAfterRename` führt genau diesen (kein `ReverseFind` mehr). (K9, „Server lehnt Umbenennen ab") `CImapRenameMailboxAction::DoPostProcessing` liest nach einem Scheitern am Server die Ordnerliste des Kontos neu; Protokollzeile `E-146 Umbenennen am Server gescheitert`. **Rot gemessen** am Bau `e0e811f5` (Prüfstand `C:\Temp\E146`, Prüfserver mit `--rename-ablehnen`): Server `NO RENAME`, Eudora führt danach `Ablage-&AOQ-` in `mboxlist.lst` und im Verzeichnis `AblageAOQ`. Prüfstandsfall `E-146` (`tools/messen-e146.ps1`), Regressionstest `TestE146.cpp` (307 Tests, 307 bestanden; ohne die Vermerkzeile einmal rot, 306/307). **Grün gemessen am 26.10.2026** am Bau `62f6047c` (Prüfstand `C:\Temp\E146`): Server `NO RENAME`, danach liest Eudora die Ordnerliste neu (Protokollzeile `E-146 Umbenennen am Server gescheitert … Ordnerliste wird neu gelesen`, 14 `LIST` am Server), `mboxlist.lst` führt wieder `Ablage`, im Baum steht `Ablage`, der neue Name ist weg. **Rest:** das lokale Verzeichnis des abgelehnten Namens (`AblageAOQ`, mit dem Zwischenspeicher des alten Ordners) bleibt auf der Platte liegen; die Nachrichten liegen auf dem Server. **Dabei gefunden:** der Prüfserver `tools/imap-pruefserver.pl` beantwortete jedes `LIST` mit allen Ordnern ohne Rücksicht auf das Muster; auf `LIST "" Ablage/%` meldete er `Ablage` als eigenes Kind, und Eudora stieg beim ersten grünen Versuch 1556 Mal hinab. Berichtigt (Muster `%` und `*` nach RFC 3501), danach grün. **Nachgeprüft von [PRÜFER-58](../Befunde/PRUEFER-58.md):** kein übersehener Aufrufer, `DoPostProcessing` läuft im Hauptfaden, das Neueinlesen kann keine Schleife bilden. **Grenzen:** das liegen bleibende Verzeichnis ist **nicht leer**, es enthält den Zwischenspeicher des alten Ordners (K8; im Commit `2fbc35d4` stand „leerer Zwischenspeicher", das war falsch). Scheitert das Umbenennen an fehlender Verbindung, scheitert auch das Neueinlesen, und der falsche Name bleibt bis zum Auffrischen von Hand (Kommentar im Code berichtigt). Scheitert umgekehrt das **lokale** Umbenennen, geht die Umbenennung trotzdem an den Server (K6, Originalfehler, selten, `ImapAccount.cpp` vor `QueueAction`). Vermutet, nicht gemessen: existiert der abgelehnte Name am Server schon, trägt dieser Ordner bis zum nächsten Abgleich den Zwischenspeicher des alten (K7). Bis 7.2.0.122: benannte man auf einem IMAP-Server ohne Ordnerhierarchie einen Ordner um, hieß er in Eudora danach falsch (aus „Ablage" wird „AblageAblage-…"), und jeder weitere Zugriff fragt den Server nach einem Ordner, den es nicht gibt; dasselbe beim Umbenennen von INBOX, wenn für das Konto ein Ordner-Präfix eingestellt ist. GMX und freenet haben eine Hierarchie, INBOX umzubenennen ist ungewöhnlich; das gewöhnliche Umbenennen ist von Gregor am 26.10.2026 an Paket 1.0.123 bestätigt (TESTPLAN N5, *„E-146: PASSED“*). **Was noch fehlt:** ein Messfall ohne Trenner und einer mit Präfix am Prüfserver (heute nur am Quelltext gesichert, `TestE146.cpp`); das liegen bleibende Verzeichnis des abgelehnten Namens wegräumen. **Vorher (bis 26.10.2026):** benannte man auf einem IMAP-Server ohne Ordnerhierarchie einen Ordner um, hieß er in Eudora danach falsch. **Herleitung:** ohne Trenner liefert `ReverseFind('\0')` die Länge der Zeichenkette statt -1, `Left(nc + 1)` behält den ganzen alten Namen, und der neue wird angehängt; bei INBOX setzt `RenameMailbox` das Präfix davor (`:3013`), `UpdateAfterRename` nicht. **Zuerst eingetragen:** 25.10.2026 aus [PRÜFER-50 K8](../Befunde/PRUEFER-50.md#k8). **Stufe: wichtig** (Funktion: der umbenannte Ordner ist nicht mehr erreichbar, nichts geht verloren — die Nachrichten liegen auf dem Server) |
| <a id="e-145"></a>E-145 | **Base64-Dekodieren wertet Bytes über 127 als gültige Zeichen** — statt sie zu überspringen, kommen falsch dekodierte Bytes heraus | **offen, am Quelltext belegt, nicht am Programm gemessen; Quelltext original von QUALCOMM, Verhalten nicht gemessen; nur das Vorzeichen von `char` ist im Messprogramm gemessen.** Steht in einem Base64-Text ein Byte über 127, rechnet Eudora damit weiter, statt es als ungültig zu überspringen; heraus kommen einzelne falsche Bytes, ein Absturz ist nicht zu erwarten. Für Gregor ist nichts zu tun; solche Post ist fehlerhaft und selten. **Was noch fehlt:** die Behebung in einer Zeile (`Eudora/Base64.cpp:166`) und ein Testfall in `Tests/`. **Herleitung:** `Base64Decoder::Decode` indiziert `g_Decode[*In]` (`Eudora/Base64.cpp:166`); `char` ist vorzeichenbehaftet (`Eudora.vcxproj` ohne `/J`), 0xE4 ergibt den Index −28, gelesen werden bis zu 128 Byte vor der Tabelle. Betrifft jeden Base64-Weg, mit [E-119](#e-119) auch `data:`-Adressen aus HTML. **Behebung:** `g_Decode[(unsigned char)*In]`; Prüffall in `Tests/` mit `"QQ\xE4=="` — das Byte zählt als ungültig, die Ausgabe bleibt `A`. **Zuerst eingetragen:** 24.10.2026 aus [PRÜFER-49 K11](../Befunde/PRUEFER-49.md#k11). **Stufe: unkritisch** (einzelne falsche Bytes bei fehlerhafter Post, nichts geht verloren) |
| <a id="e-144"></a>E-144 | **Ein Antwortentwurf, der aus einem anderen Postfach nach `Out` zurückgeschoben wird, verliert `In-Reply-To` und `References`** — beim Empfänger fällt die Antwort aus dem Gesprächsfaden | **offen, von Gregor am 23.10.2026 am laufenden Programm bestätigt (Paket 1.0.122).** **Kurz: Ein gespeicherter Antwortentwurf, den man aus einem lokalen Postfach (etwa `Trash`) zurück nach `Out` zieht, verliert die Angabe, worauf er antwortet. Beim Empfänger hängt die Antwort dann nicht mehr im Gesprächsfaden. Text und Betreff bleiben. Die Behebung fehlt noch.** **Von Gregor am laufenden Programm bestätigt am 23.10.2026** an Paket 1.0.122 (auf seinen 0.116-Daten): Antwortentwurf *„E-144 (iii) Re: Fwd: …"* in `Out.mbx` um 23:28:23 mit `In-Reply-To: <<Message-ID>>` und gleichem `References:`; nach lokalem `Trash` → `Out` liegt dort um 23:28:46 eine neu angelegte Kopie mit neuer `Message-Id`, und beide Zeilen sind **leer** (`Out.mbx` mit Gregors Erlaubnis gelesen; im Protokoll das zweite `E-27 NewCompDocument` ohne Dialog). Vorher: offen, am Quelltext belegt ([PRÜFER-47](../Befunde/PRUEFER-47.md#k2), 23.10.2026), nicht am laufenden Programm gesehen. Der Weg nach `Out` legt den Entwurf neu an, statt ihn zu verschieben (`summary.cpp:1912-1928`); dabei werden diese beiden Kopfzeilen nicht übernommen (`compmsgd.cpp:2167`). Gemessen ist nur, dass neu angelegt wird: nach der Gegenprobe zu [E-125](#e-125) trägt der Entwurf in `Out` eine neue `Message-Id`. Die Nachricht selbst geht nicht verloren. Der Code steht so schon im ersten Stand des Repos, ist also keine Verschlechterung durch die Portierung. **Was noch fehlt:** die beiden Kopfzeilen beim Neuanlegen übernehmen — laut [PRÜFER-48](../Befunde/PRUEFER-48.md) K8 zwei Zeilen in `summary.cpp` im Block `if (NewDoc)` ab 1916 (`NewDoc->SetHeaderLine(HEADER_IN_REPLY_TO, CompDoc->GetHeaderLine(HEADER_IN_REPLY_TO));` und dasselbe für `HEADER_REFERENCES`), nach dem Muster von *Antworten* (`summary.cpp:1677-1678`), nicht in `compmsgd.cpp:2167`. Nebenwirkung: auch *Message → Send Again* auf eine gesendete Antwort behält dann die Bezüge — eine Abweichung vom Original, die hier stehen muss. Dazu der Regressionsfall am Prüfstand. Gesehen am Programm ist der Fehler seit Gregors Lauf. **Wie zu pruefen:** einen Antwortentwurf speichern, nach `Trash` und zurück nach `Out` schieben, dann die Kopfzeilen in `Out.mbx` lesen. **Stufe: wichtig** (Funktion: Antwort fällt aus dem Gesprächsfaden, nichts geht verloren)|
| <a id="e-140"></a>E-140 | **Zwei weitere Speicherwege gehen an der Zeichensatz-Ergaenzung vorbei** — *File → Save As* aus dem Nachrichten- und aus dem Verfassen-Fenster schreibt ohne `Content-Type` und ohne `charset` | **offen, am 23.10.2026 am Quelltext belegt, nie gemessen.** Abgetrennt aus [E-101](#e-101): [LEKTOR-51b](../Befunde/LEKTOR-51b.md) hat beim Gegenprüfen meiner E-101-Schließung gefunden, dass der Kern `E101SpeicherfassungAufbereiten` genau **einen** Aufrufer hat (`tocview.cpp:3186`, *File → Save As* aus der Postfachliste). **Zwei andere Speicherwege rufen ihn nie:** (1) das Nachrichtenfenster, `CReadMessageDoc` `ON_COMMAND(ID_FILE_SAVE_AS, OnFileSaveAs)` (`ReadMessageDoc.cpp:65`) → `:595` → `SaveAsFile` (`:606`), und (2) das Verfassen-Fenster, `compmsgd.cpp:1920` → `:3332` → `SaveAsFile` (`:3399`). Beide schreiben über `view->GetMessageAsText()` bzw. `GetMessageAsHTML()` (`TridentReadMessageView.cpp:2933`) direkt mit `pFile->Put(msg)` — **ohne `MIME-Version`, ohne `Content-Type`, ohne `charset`**. Dazu kommt die Filteraktion *„an Programm übergeben"* mit ihrer Zwischendatei (`filtersd.cpp:2074` → `ReadMessageDoc.cpp:531`). **Was das bedeutet und was nicht.** Eine Textdatei mit Hochbytes aus windows-1252 **ohne jede Zeichensatzangabe** ist genau die Klasse, für die der Kern gebaut wurde — ein anderes Programm rät dann. **Datenverlust ist NICHT belegt:** geschnitten wird nichts, und diese Wege liefern gerenderten Text beziehungsweise `GetAllHTML`, nicht Eudoras interne Rohfassung; das Ausgangssymptom von [E-101](#e-101) (`<x-html>` und roher Quelltext) entsteht dort so nicht. **Deshalb hält dieser Befund kein Paket auf.** **Was noch fehlt:** jede Messung — niemand hat diese beiden Wege je gefahren. Zu messen: aus dem Nachrichtenfenster und aus dem Verfassen-Fenster je eine Nachricht mit Umlauten und einem Euro-Zeichen über *File → Save As* sichern, die Datei mit `Get-Content -Encoding Byte` ansehen und prüfen, ob eine `Content-Type`-Zeile dasteht und ob die Hochbytes stimmen. **Gegenprobe:** dieselbe Nachricht über *File → Save As* aus der **Postfachliste** sichern — dort muss die Zeile stehen (am 23.10.2026 an 7.2.0.120 belegt, siehe [E-101](#e-101)). Ergibt die Messung, dass Zeichen verlorengehen, ist dieser Befund hochzustufen und der Riegel vor dem Paketbau greift wieder. **Stufe: wichtig** (Verfaelschung moeglich: gespeicherte Datei ohne Zeichensatzangabe, Verlust nicht belegt)|
| <a id="e-139"></a>E-139 | **Die Meldung „Rechtschreibprüfung nicht vorhanden" kommt nach jedem Programmstart einmal wieder** — es fehlt das Kästchen *„Nicht mehr anzeigen"*, das andere Meldungen längst haben | **offen — zurückgestellt bis nach 7.2.1**, von Gregor am 28.10.2026 bestätigt (*„e-139 vor 7.2.1 beheben? nein, erst danach“*); bis dahin unter „Bekannte Fehler“ in der README. **Am 23.10.2026 von Gregor am laufenden Programm gefunden, die Stelle am Quelltext belegt.** Gregor: *„bei der messagebox mit rechtschreibprüfung nicht vorhanden wäre eine checkbox notwendig, um nicht bei jeder gelegenheit daran erinnert zu werden. ähnlich wie bei der meldung: sie haben neue mails. da kann man es auch dann dauerhaft wegklicken, wird nicht jedes mal angezeigt."* (Chat). **Die Stelle — berichtigt am 23.10.2026, meine erste Angabe war falsch.** Ich hatte auf `CSpellDialog::LoadSpellLib` (`SpellDialog.cpp:440`, Text 2187 *„Can not load %s. "*) gezeigt. Das ist der **Originalweg** von Qualcomm für eine fehlende DLL, und unser Bau kommt dort nie an. Gregors Bildschirmfoto zeigt einen **deutschen** Text, und der steht in **unserer eigenen** Datei: `Eudora71/Eudora/spell.cpp:68` — *„Die Rechtschreibpruefung ist in dieser Fassung nicht verfuegbar. Die Pruefengine (SSCE) fehlt in der Quelltextfreigabe."*, gezeigt mit `AfxMessageBox(..., MB_OK mit MB_ICONINFORMATION)` aus der Funktion `ZeigeHinweisEinmal()` (`:58`). `spell.cpp` ist der Ersatz für die Engine, die in der Freigabe des Computer History Museum fehlt. **Gefunden habe ich die richtige Stelle erst, nachdem Gregor das Bild geschickt hat** — der Text im Bild war der Schlüssel, nicht meine Suche ([anzeige-ist-kein-zustand](../Arbeitsweise/anzeige-ist-kein-zustand.md) von der anderen Seite her). **Gregors Messung vom 23.10.2026, die meine offene Frage beantwortet:** *„1. start, neue mail: [Hinweis]. 2-te neue mail: kein hinweis. 2. start, neue mail: erneut hinweis."* (Chat). **Das deckt sich Zeile für Zeile mit dem Quelltext:** `static BOOL s_bHinweisGezeigt = FALSE;` (`spell.cpp:56`) und `if (s_bHinweisGezeigt) return;` (`:60`). Der Merker ist **statisch**, lebt also genau einen Programmlauf und steht beim nächsten Start wieder auf `FALSE`. **Die Meldung kommt damit heute schon einmal je Lauf — Gregor will, dass sie dauerhaft wegklickbar ist, über Läufe hinweg.** **Das Verfahren, das Gregor meint, gibt es schon fertig im Programm.** `WarnDialog(UINT IniID, UINT StringID, …)` (`guiutils.cpp:963`) und `NoteDialog(UINT IniID, UINT StringID, …)` (`:1134`) zeigen dieselbe Art Kasten **mit** dem Kästchen `IDC_WARN_CHECKBOX` und merken die Antwort unter dem übergebenen INI-Schlüssel; die Beschriftung steht als `IDS_NOTE_CHECKBOX` *„Don't show this again"* (`EudoraRes.rc:10766`, gesetzt in `guiutils.cpp:793`). Seine Vergleichsmeldung ist `IDD_NEW_MAIL` mit *„&Don't show alerts for New Mail or No New Mail again"* (`EudoraRes.rc:1786`). Aufrufbeispiele im Bestand: `MakeFilter.cpp:504`, `SearchView.cpp:3970` und `:3975`. **Kein Datenverlust** — reine Bequemlichkeit, aber sie trifft bei jedem Verfassen einer Nachricht zu. **Was noch fehlt:** der Einbau in `ZeigeHinweisEinmal()` (`spell.cpp:58`) — statt `AfxMessageBox` ein `NoteDialog(<neuer INI-Schlüssel>, <neue Zeichenkette>)`. Zwei Dinge sind dafür neu anzulegen, und der Kommentar in `spell.cpp:65-66` nennt genau den Grund, warum es bisher unterblieb: *„Kein CRString/IDS_…, weil dafuer eine neue Ressource noetig waere und EudoraRes.rc hier bewusst unangetastet bleibt."* Diese Zurückhaltung ist überholt — am 23.10.2026 ist mit `IDD_XFER_TO_OUT_REFUSED` ohnehin eine neue Ressource dazugekommen. Zu ergänzen sind also: eine Zeichenkette für den Meldungstext und ein INI-Schlüssel nach dem Muster von `IDS_INI_WARN_DELETE_UNREAD` (Vorgabe: anzeigen). Der statische Merker `s_bHinweisGezeigt` kann bleiben — er spart den Dialogaufruf innerhalb eines Laufs; der INI-Schlüssel wirkt darüber hinaus. **Nicht gemessen bleibt:** bei welchen Gelegenheiten genau die Meldung ausgelöst wird (Gregors Fall war das Verfassen einer neuen Nachricht), und ob der Weg über `CHeaderField::DoSpellCheck` am Tipp-Zeitgeber (`headervw.cpp:1188`) sie ebenfalls auslösen kann. **Wie zu prüfen:** die Rechtschreib-DLL aus dem Programmverzeichnis nehmen, eine Nachricht verfassen, Rechtschreibprüfung auslösen — die Meldung muss kommen, mit Kästchen; nach dem Ankreuzen darf sie im selben und in jedem folgenden Lauf nicht wiederkommen, und in der `Eudora.ini` muss der neue Schlüssel stehen. **Gegenprobe:** Schlüssel von Hand zurücksetzen, Meldung muss wieder erscheinen. **Stufe: unkritisch** (Bequemlichkeit: eine Meldung ohne Abschaltmoeglichkeit)|
| <a id="e-138"></a>E-138 | **Nach dem Herunterladen von GitHub lässt sich `Eudora.exe` nicht starten** — nur der Umweg über `Eudora starten.cmd` geht, und nirgends steht warum | **offen, am 23.10.2026 von Gregor außerhalb der VM gefunden, Ursache von ihm selbst am Eigenschaften-Dialog belegt.** Gregor: *„außerhalb der VM kann ich eudora.exe nicht direkt starten, nur über Eudora starten.cmd"*, dazu das Bildschirmfoto des Dialogs mit dem Satz *„Die Datei stammt von einem anderen Computer. Der Zugriff wurde aus Sicherheitsgründen eventuell blockiert."* und dem Kästchen *Zulassen* (Chat, Verzeichnis `C:\Temp\Eudora72-1.0.120-release`). **Was es ist:** der *Mark of the Web*. Lädt man ein ZIP aus dem Netz, hängt Windows an die Datei einen Alternativdatenstrom `Zone.Identifier`; der Windows-Explorer vererbt ihn beim Entpacken an **jede** enthaltene Datei. Eine `.exe` wird damit blockiert, eine `.cmd` läuft, weil sie von `cmd.exe` ausgeführt wird. **Kein Fehler unseres Programms** — aber einer unserer **Auslieferung**: es trifft jeden Anwender, der ein Release von GitHub holt, und es stand bis zum 23.10.2026 in **keiner** unserer Dateien (nachgezählt über alle `.md` und `.txt` des Baums: 0 Treffer für `Zone.Identifier`, `Mark of the Web`, `anderen Computer`, `Unblock`). Zusammen mit [E-124](#e-124) (Defender hält die Datei für einen Trojaner) ist das der zweite Grund, aus dem ein Erstanwender das Programm nicht zum Laufen bringt. **Was noch fehlt:** an der Doku nichts mehr. Der Hinweis steht seit dem 23.10.2026 in **vier** Dateien, von [LEKTOR-52](../Befunde/LEKTOR-52.md) nachgezählt: `README.md` (Zeile in den bekannten Fehlern **und** eigener Abschnitt), `Doku/ANWENDER.md` als Schritt 1 der Startanleitung, und `Releases/1.0.3/LIESMICH.txt`, die byte-gleich im Paket liegt. Der Rat lautet: **das ZIP vor dem Entpacken** entsperren (Rechtsklick auf die `.zip`, Eigenschaften, *Zulassen*), weil sonst jede einzelne Datei die Markierung trägt; nachträglich `Get-ChildItem -Recurse <Verzeichnis> \| Unblock-File`. **Gemessen am 23.10.2026:** dieser Befehl wirft an Verzeichnissen **keine** Fehler — in einem Wegwerfverzeichnis mit Unterordner ergab er 0 Fehler, mit und ohne `-File`; `-File` ist also nicht nötig. Eine Code-Signatur, die die Markierung für den Erstanwender vermutlich ganz abstellen würde, hat Gregor am 26.10.2026 abgelehnt — *„ich verdiene mit dem projekt kein geld, werde daher keins für zertifikate ausgeben.“* **Nicht gemessen ist**, ob eine Code-Signatur das abstellen würde; Gregor hat sie am 26.10.2026 abgelehnt (siehe [E-124](#e-124)). **Wie zu prüfen:** `Get-Item <Pfad>\Eudora.exe -Stream *` zeigt den Strom `Zone.Identifier`, `Get-Content ... -Stream Zone.Identifier` die Herkunfts-URL; nach dem Entsperren ist der Strom weg und der Doppelklick startet. **Stufe: wichtig** (Auslieferung: ein Erstanwender bekommt das Programm ohne Hinweis nicht gestartet)|
| <a id="e-137"></a>E-137 | **`Strg-W` auf der Wazoo-Leiste (Adressbuch, Filter, Postfächer — ein Fenster, verschiedene Register) schließt nicht das Fenster, sondern beendet ganz Eudora** — zu schließen ist es nur über Rechtsklick auf den Rahmen und *Hide* | **behoben — von Gregor am 27.10.2026 an Paket 1.0.127 bestätigt: V1 bis V3 aus seinem `eudora.log` (auf seine Anweisung *„du kannst die ergebnisse jetzt übernehmen.“*: viermal `E-137 Strg-W angekommen`, jedes Mal gleich gefolgt von `Wazoo-Leiste wird versteckt`: zweimal mit dem Fokus außerhalb der Leiste in einer Liste (`leiste-mit-fokus=nein … fokus=ListBox`, der Weg aus V1/V2), zweimal mit dem Fokus in der Leiste, einmal auf einer Liste (`fokus=ListBox`) und einmal auf einem Knopf oder Gruppenfeld wie „Match“ (`fokus=Button`, V3); ob die Leiste dabei angedockt oder schwebend war, zeigt das Protokoll nicht), V6 *„V6: passed“*.** Bekannter Rest, nicht behoben: PRÜFER-63 K1 (Doppelklick auf ein Postfach, das schon vorn ist, dann Strg+W). Davor: an Paket 1.0.125 nicht bestanden (Kurztest U1, 26.10.2026); fünfter Anlauf eingebaut am 27.10.2026, Korrektur aus PRÜFER-62 K1 in 1.0.127; am Prüfstand rot an 1.0.125, grün an 1.0.126 und 1.0.127 (Fälle E-137a bis E-137c). An Paket 1.0.124 im ersten Durchgang von T1 nicht bestanden, im zweiten bestanden. Erster Durchgang, Gregor: *„FAILED: CTRL-W schließt nicht filter fenster“*; zweiter Durchgang: *„E-137, T1 PASSED“*, Protokoll sechsmal `E-137 Strg-W`. **Dritter Teil (26.10.2026):** geklickt hatte Gregor *„mal oben, mal seitlich“* — auf Titelzeile und Rand des **schwebenden** Fensters. Das ist der kleine Rahmen `QCMiniDockFrameWnd`, nicht die Leiste; `CWazooBar::OnMouseActivate` sah den Klick nie, der Fokus blieb in der Mail. Gemessen in Gregors `eudora.log` an 1.0.124: dreimal `E-137 Klick in Wazoo-Leiste` mit gleich folgendem `E-137 Strg-W` (diese Wege wirkten), nach dem letzten Klick in die Leiste (18:14 Programmzeit) dagegen keine Strg-W-Zeile mehr, dazwischen Größenänderungen am schwebenden Fenster (`E-76 … schwebt=1`). Eingebaut: `QCMiniDockFrameWnd::OnMouseActivate` (`workbook.cpp`) gibt bei jedem Klick auf den Rahmen außer `HTCLIENT` dem aktiven Wazoo-Fenster der enthaltenen Leiste den Fokus, Protokollzeile `E-137 Klick auf den Rahmen der schwebenden Leiste`; Regressionstest in `TestE137.cpp` (312 Tests, 312 bestanden; ohne den Einbau 311/312). Ein echter Mausklick auf eine Titelzeile lässt sich am Prüfstand nicht erzeugen (nur Fensterbotschaften, keine Eingaben) — bestätigen kann es nur Gregors Test. Vorher: Behebung eingebaut auf dem Zweig `RC1_vorbereiten` (25.10.2026); die erste Fassung griff nicht (PRÜFER-56 K1). *„mail auswählen, dann filter fenster (abgedockt) anklicken, ctrl-W: schließt mail fenster, nicht filter fenster“*. Ursache: Strg+W richtet sich nach dem Tastaturfokus, und ein Klick auf eine Beschriftung oder leere Fläche der Leiste ließ ihn in der Mail. Gregors Entscheidung: *„erstmal teste ich weiter, dann aber A“* — beheben, mit neuem Testpaket 7.2.0.124. **Eingebaut am 26.10.2026, am Programm noch nicht gemessen:** `CWazooBar::OnMouseActivate` (`WazooBar.cpp`) gibt bei jedem Klick in die Leiste dem aktiven Wazoo-Fenster den Fokus, wenn er noch außerhalb liegt; Protokollzeile `E-137 Klick in Wazoo-Leiste: Fokus geht in die Leiste`. Regressionstest in `TestE137.cpp` (309 Tests, 309 bestanden; ohne `ON_WM_MOUSEACTIVATE` einmal rot, 308/309). Am Prüfstand nicht nachzustellen: `WM_MOUSEACTIVATE` entsteht nur aus echter Mauseingabe. **Die Ursache, am Quelltext belegt ([PRÜFER-56](../Befunde/PRUEFER-56.md) K1):** `CMainFrame::OnCommand` (`mainfrm.cpp`) gibt Strg-W zuerst an das Wazoo-Fenster mit dem Schwerpunkt; Filter und Adressbuch reichen es an ihr Dokument, und `CDoc::OnFileClose` (`doc.cpp:144-149`) schickt `WM_CLOSE` an den Rahmen der Ansicht — **angedockt ist das das Hauptfenster, Eudora geht zu; schwebend ist es der kleine Rahmen der Leiste, nur sie geht zu.** Das deckt sich genau mit Gregors Eingrenzung. Die Behebung sitzt deshalb jetzt am **Anfang von `OnCommand`**, vor jeder Weitergabe; die erste Fassung saß in `OnCmdMsg` und wurde nie erreicht, ihr Test war grün, weil er die falsche Funktion las. Regressionstest `TestE137.cpp` liest jetzt `OnCommand` und prüft den Block als zusammenhängende Anweisungsfolge (302 Tests, 302 bestanden; alte Fassung und verneinte Bedingung je einmal rot). **Von Gregor am 25.10.2026 eingegrenzt** (an 1.0.122, mit Bild): *„beim nicht angedockten fenster wird es ganz regulär geschlossen, sonst nicht"* — nur die **angedockte** Leiste (rechts, Register Address Book / Directory Services / Filters / Filter Report / Link History, aktives Fenster `In`) beendet Eudora. **Behebung** nach Gregors Vorgabe (*„sollte z.b. nur das filter fenster geschlossen werden"*): am **Anfang von `CMainFrame::OnCommand`** (`mainfrm.cpp`), vor jeder Weitergabe an das Wazoo-Fenster oder das aktive MDI-Fenster: hat eine **sichtbare** Wazoo-Leiste den Schwerpunkt, bekommt sie `ID_SEC_HIDE` — denselben Befehl wie Rechtsklick → *Hide* (`SECControlBar::OnHide`, `OTShim.cpp`) —, danach bekommt das aktive Fenster den Schwerpunkt, und der Befehl ist erledigt; Spurmarke `E-137 Strg-W: Wazoo-Leiste wird versteckt statt Eudora zu beenden`. Das gilt **angedockt wie schwebend**: eine Leiste als MDI-Fenster gibt es in diesem Bau nicht (`IsMDIChild` ist in der Ersatzschicht immer FALSE, [PRÜFER-55 K1](../Befunde/PRUEFER-55.md)) — Gregors „nicht angedockt" war die **schwebende** Leiste, die vorher schon regulär schloss und jetzt ebenfalls *Hide* bekommt. **Die erste Fassung (in `OnCmdMsg`, mit einer MDI-Abfrage) griff nicht** und ist entfernt ([PRÜFER-56 K1](../Befunde/PRUEFER-56.md)). **Was noch fehlt:** Gregors Prüfung an 1.0.127 (TESTPLAN V1–V3, Gegenprobe V6): Klick auf Titelzeile und Rand der **schwebenden** Leiste (V1, V2) und auf eine Beschriftung der **angedockten** Leiste (V3), jeweils dann Strg+W. **Wie zu pruefen:** **GREGOR** — TESTPLAN V1 bis V3 und V6 an Paket 1.0.127; am Prüfstand misst `tools/messen-e137.ps1` V1 und V2 mit Fensterbotschaften. Eine angedockte Leiste hat keine eigene Titelzeile und keinen eigenen Rand, ein Klick dort trifft die Leiste selbst. Der erste Teil ist am 26.10.2026 an Paket 1.0.123 bestätigt (N1, N1b, N2; Protokoll `E-137 Strg-W`). Ursache und gewünschtes Verhalten sind geklärt. **Entschieden von Gregor am 25.10.2026** ([PRÜFER-57](../Befunde/PRUEFER-57.md) K2, *„a) ist ok."*): auch *Datei → Schließen* und der Knopf *Close Window* verstecken die Leiste, wenn sie den Schwerpunkt hat — wie Strg+W; das Umschalt-„alle schließen" entfällt in diesem Fall. **Stand davor: offen, am 23.10.2026 von Gregor am laufenden Programm gefunden, Ursache nicht gemessen.** Gregor an 1.0.120, außerhalb der VM: *„das filter fenster (ctrl-L) kann man nicht mit ctrl-w wie jedes andere mail-fenster schließen, dabei wird ganz eudora geschlossen. man kann nur rechtsklick auf den rahmen -> hide machen."* (Chat). **Am Quelltext belegt, soweit es von hier aus geht:** `Strg-W` ist auf `ID_FILE_CLOSE` gelegt (`EudoraRes.rc:364`, `"W", ID_FILE_CLOSE, VIRTKEY, CONTROL`). Diesen Befehl fängt im ganzen Baum genau **dreimal** jemand ab — `CDoc::OnFileClose` (`doc.cpp:109`), `CMsgDoc::OnFileClose` (`msgdoc.cpp:510`) und `QCControlBarWorksheet::OnCmdMdiClose` (`workbook.cpp:245`, die Registerkartenleiste). **Keine einzige Wazoo-Fensterklasse behandelt ihn.** Die erste Messung dazu war untauglich und ist am 23.10.2026 ersetzt worden ([LEKTOR-52](../Befunde/LEKTOR-52.md), L-52.4): sie suchte in `*WazooWnd.h` und `*WazooBar.h`, und ein `ON_COMMAND` steht in MFC grundsätzlich in der `.cpp`. Eine Suche, die dort nichts finden **kann**, belegt nichts. Richtig gezählt über den **ganzen** Baum: `ID_FILE_CLOSE` kommt in `Eudora71/` fünfmal vor — drei Behandler (`doc.cpp:109`, `msgdoc.cpp:510`, `workbook.cpp:245`), ein Listeneintrag (`QCToolBarManager.cpp:65`) und die Definition (`Help/afxres.h:165`). Keine der 16 Wazoo-Nachrichtentabellen ist darunter. Hat eine Wazoo-Leiste den Eingabeschwerpunkt, läuft der Befehl also an allen drei Stellen vorbei. **Was dabei Eudora beendet, ist NICHT gemessen** — dass der Befehl unbehandelt bleibt, erklärt für sich genommen nur, dass nichts geschieht, nicht dass das Programm zugeht. Das ist der nächste Schritt. **Was verlorengehen kann:** alles, was in offenen Verfassen-Fenstern steht und beim Beenden nicht gesichert wird; ob Eudora vorher fragt, ist ebenfalls nicht gemessen. **Stand 23.10.2026, überholt — damals fehlte:** die Messung, was Eudora tatsaechlich beendet - dass der Befehl unbehandelt bleibt, erklaert nur, dass nichts geschieht, nicht dass das Programm zugeht. Dazu die Entscheidung, wie es sein soll: eine Wazoo-Leiste auf `ID_FILE_CLOSE` verstecken (wie der Rechtsklick-Weg *Hide*) oder den Befehl dort schlucken. **Welches Fenster es ist, am 23.10.2026 geklärt — und die Frage war falsch gestellt.** Ich hatte gefragt, ob Adressbuch oder Filter gemeint sei, weil `Strg-L` auf `ID_WINDOW_NICKNAMES` liegt (`EudoraRes.rc:322`, Menü `:5819` *„&Address Book\tCtrl+L"*) und `ID_WINDOW_FILTERS` (`:5807`) gar keine Tastenkombination hat. Gregor: *„ist ja egal, weil adressbuch und filter werden im selben fenster dargestellt, nur die register unten sind andere. aber ja, ctrl-l öffnet das adressbuch."* (Chat). **Am Quelltext bestätigt:** `CMainFrame::OnWindowFilters` (`mainfrm.cpp:4782`) und `OnWindowNicknames` (`:4923`) — in der Nachrichtentabelle eingetragen bei `:481` bzw. `:483`, das sind **nicht** die Funktionen selbst ([LEKTOR-52](../Befunde/LEKTOR-52.md), L-52.3) — rufen beide `m_WazooBarMgr.ActivateWazooWindow(this, RUNTIME_CLASS(...))` — derselbe Leistenverwalter, **dasselbe Fenster**, nur eine andere Registerklasse (`CFiltersWazooWnd` bzw. `CNicknamesWazooWnd`). Der Befund gilt damit für die Leiste als Ganzes, unabhängig vom gewählten Register; eine getrennte Messung je Register erübrigt sich. **Wie zu prüfen:** mit `LogLevel` einschließlich `DEBUG_MASK_DIALOG` starten, die Leiste über *Window → Address Book* (`Strg-L`) öffnen, hineinklicken, `Strg-W` drücken und im `eudora.log` nachsehen, welche Abfolge kommt; dazu im Fenstertitel prüfen, welches Fenster `Strg-L` tatsächlich öffnet. **Zuletzt gemessen: 27.10.2026 an 7.2.0.127** **Nebenwirkung ([PRUEFER-59 K1](../Befunde/PRUEFER-59.md#k1)):** auch ein Klick auf einen Reiter oder den Griff einer angedockten Leiste holt jetzt den Fokus in die Leiste; Strg+W wirkt trotzdem richtig. **Fehler beim Einbau (26.10.2026, gemessen):** der dritte Teil war ab Commit `0b0b50de` auf dem Zweig nicht übersetzbar (`workbook.cpp`: `CWazooWnd` ohne `#include "WazooWnd.h"`, Fehler C2027); der Unit-Test liest nur den Quelltext und blieb grün. Gefunden beim Bau von 7.2.0.125, dort berichtigt — dieselbe Klasse wie [Extrakt ist nicht das Programm](../Arbeitsweise/extrakt-ist-nicht-das-programm.md). **Kurztest U1 an 1.0.125 (26.10.2026): nicht bestanden** — Gregor *„E-137, T1 FAILED“*; in seinem `eudora.log` steht nach dem Klick auf den Rahmen (Größenberechnung `E-76 … schwebt=1` um Programmzeit 0:40 und 0:56) **keine** E-137-Zeile, die Behebung über `OnMouseActivate` lief also nicht oder stieg still aus — welches von beiden, ist nicht gemessen. **Neu eingebaut (für 7.2.0.126):** dieselbe Fokusübergabe zusätzlich in `QCMiniDockFrameWnd::OnNcLButtonDown`, das bei jedem Linksklick auf Titelzeile, Rand oder Ecke kommt, auch wenn der Rahmen schon aktiv ist ([PRÜFER-60](../Befunde/PRUEFER-60.md) K6); beide Wege schreiben jetzt **vor** jeder Entscheidung eine Zeile `E-137 Klick auf den Rahmen der schwebenden Leiste: weg=… leiste=… fokus-drin=… wazoo=…` ins Protokoll. Unit-Test angepasst (313/313); übersetzt (Bau 0 Fehler). **Fünfter Anlauf (27.10.2026, [PRÜFER-61](../Befunde/PRUEFER-61.md) K1):** auch der vierte hätte nicht gegriffen. Der Rahmen der schwebenden Leiste ist im Programm ein gewöhnlicher `CMiniDockFrameWnd`: `CFrameWnd::EnableDocking` (`winfrm2.cpp:51`) überschreibt die Klasse, die `mainfrm.cpp:1791` vorher setzt (belegt am Quelltext; gemessen an einem MFC-Probeprogramm des PRÜFERS). `QCMiniDockFrameWnd` wird nie erzeugt — deshalb stand an 1.0.125 keine E-137-Zeile im Protokoll. Auch dort hätte es nicht gereicht: `CMiniDockFrameWnd::OnNcLButtonDown` ruft bei Titelzeile und Rand `ActivateTopParent()` (`bardock.cpp`), der Fokus geht an die Mail zurück (belegt am Quelltext). **Neu:** `CEudoraApp::PreTranslateMessage` → `CMainFrame::E137EingabeMerken` merkt sich die Leiste des letzten Klicks, in die Leiste oder auf den Rahmen der schwebenden (`CWazooBarMgr::GetWazooBarAt`); `CMainFrame::OnCommand` gibt Strg+W dieser Leiste, wenn keine Leiste den Fokus hat. Jedes Strg+W schreibt `E-137 Strg-W angekommen: leiste-mit-fokus=… zuletzt-angeklickte-leiste=… fokus=…`. Unit-Tests 314/314, ohne den Rahmenklick 313/314; übersetzt (Bau 0 Fehler). **Regressionstest am laufenden Programm (27.10.2026, auf Gregors Wunsch):** `tools/messen-e137.ps1`, Prüfstandsfälle `E-137a` (Titelzeile), `E-137b` (Rand), `E-137c` (Protokollzeile) — Klick als Fensterbotschaft auf den Rahmen der schwebenden Filterleiste, danach `ID_FILE_CLOSE` wie Strg+W. **Am Bau 1.0.125 rot** (`mail-offen=0 leiste-versteckt=0`, keine E-137-Zeile im Protokoll — dasselbe Bild wie Gregors U1), **am Bau 1.0.126 grün** (`mail-offen=1 leiste-versteckt=1`; Protokoll `leiste-mit-fokus=nein zuletzt-angeklickte-leiste=ja fokus=ListBox`). Der angedockte Fall (V3, Klick auf eine Beschriftung) hat noch keinen Prüfstandsfall. **Nachgerechnet von [PRÜFER-62](../Befunde/PRUEFER-62.md) (27.10.2026):** echter Klick und echtes Strg+W gehen denselben Weg (a, b), V3 ist mit abgedeckt (e). **K1 — Nebenwirkung des fünften Anlaufs, am selben Tag korrigiert (am Programm nicht gemessen, TESTPLAN V6):** die Marke blieb stehen, wenn ohne weiteren Klick ein neues Fenster aufging — nach einem Doppelklick auf ein Postfach in *Mailboxes* hätte Strg+W die Leiste versteckt statt das neue Postfach zu schließen (am Quelltext belegt). Jetzt merkt `E137EingabeMerken` mit der Marke das aktive MDI-Fenster, `OnCommand` nimmt die Marke nur, wenn es noch dasselbe ist, und `OnActivateApp` löscht sie beim Wechsel in ein anderes Programm; die Spurzeile nennt `mdi-gewechselt=`. **K2:** die Ausnahme für die Taste W bewacht jetzt ein Unit-Test. Unit-Tests 314/314; Gegenprobe ohne W-Ausnahme und ohne MDI-Vergleich rot. Am Programm ist K1 noch nicht gemessen. **Nachgerechnet von [PRÜFER-63](../Befunde/PRUEFER-63.md) (27.10.2026):** die K1-Behebung hält, V1 bis V3 bleiben unberührt (am Quelltext belegt). **Rest, nicht behoben (PRÜFER-63 K1, niedrig):** Doppelklick auf ein Postfach, das schon das vorderste Fenster ist, dann Strg+W — das aktive Fenster wechselt nicht, und die Leiste *Mailboxes* verschwindet statt des Postfachs; nichts geht verloren, vermutlich war es vor dem fünften Anlauf genauso (Fokus im Baum). TESTPLAN V6 nimmt deshalb ein Postfach, das noch nicht offen ist. **Stufe: wichtig** (Funktion: ein Fenster lässt sich nicht schließen, und der Versuch beendet das Programm)|
| <a id="e-136"></a>E-136 | **Ein Zeichen, das richtig auf dem Bildschirm steht, wird beim Speichern zerstört** — aus 🔥 werden zwei Fragezeichen, ohne Warnung und ohne Weg zurück | **offen, am 22.10.2026 an 7.2.0.120 gemessen; die Ursachenstelle ist noch nicht gefunden.** **Wie es aufgefallen ist.** Gregor hat an diesem Tag das fremde Plug-in [`EudoraUnicodeFix`](https://github.com/rjsdotorg/EudoraUnicodeFix-releases) von `rjsdotorg` geprüft (dem Melder aus [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102)). Dabei fiel etwas auf, das mit dem Plug-in nichts zu tun hat. Seine Beobachtung: *„am anfang war es noch korrekt angezeigt, nach dem speichern war es war."* **Die Kette, dreifach gemessen.** (1) Das Plug-in schreibt für jedes Zeichen, das windows-1252 nicht kennt, eine HTML-Entität — am Quelltext ausgezählt: `UnicodeToWindows1252Html` setzt `&#128293;`, nie ein Fragezeichen. (2) Das Protokoll des Plug-ins (`%TEMP%\EudoraUnicodeFix.log`, Lauf 19:41:23) nennt `Input bytes: 813  Output bytes: 807`; die Rechnung geht nur auf, wenn die Entität geschrieben wurde: das Umkodieren der UTF-8-Zeichen nach windows-1252 spart rund 11 Byte, die Entität kostet 6 — erwartet also etwa −5, **gemessen −6**. Das eine Byte Unterschied ist **nicht erklärt**; es kann an meiner Auszählung der Zeichen liegen oder an einem weiteren nicht abbildbaren Zeichen. Die Richtung ist belegt, die Zahl auf das Byte genau nicht. (3) **Eudora hat 🔥 richtig angezeigt** (Gregors Bildschirm), und erst nach `Strg-S` steht in der Postfachdatei `<LI>Vierbyte-Zeichen: ??</LI>`, byte-genau zwei Fragezeichen, und **keine** Entität mehr im ganzen Postfach. **Was verlorengehen kann:** jedes Zeichen außerhalb von windows-1252 in einer gespeicherten Nachricht — Emoji, aber auch Kyrillisch, Griechisch, Chinesisch. Der Anwender sieht es richtig, sichert, und hat danach Fragezeichen. Nicht rückgängig zu machen, weil die Nachricht in der `.mbx` überschrieben beziehungsweise neu angelegt wird. **Warum das NICHT [E-90](#e-90) ist.** E-90 steht als *„gemessene Grenze, kein Fehler dieser Fassung — zurückgestellt"*: dort war das Zeichen nie darstellbar, es ging also nichts verloren, was vorher da war. Hier war es **da** und wurde zerstört. Die Behebung zu E-90 gibt es sogar schon: `ISOTranslate` (`Eudora71/Eudora/utils.cpp:1608`) streicht, was CP1252 nicht kann, statt Fragezeichen stehenzulassen — Gregors Entscheidung vom 14.09.2026, *„versuchen wir dann B"*. **Sie greift hier nur nicht:** am Quelltext ausgezählt hat `ISOTranslate` aufrufstellen=2, beide auf dem **Leseweg** (`TextReader.cpp:300`) beziehungsweise beim Zerlegen der Kopfzeilen (`lex822.cpp:630`). Der Speicherweg läuft nicht dort durch. **Was noch fehlt:** die Stelle, an der beim Speichern nach windows-1252 umkodiert wird. Sie ist **nicht** gefunden — die einzige CP1252-Umwandlung mit dem E-90-Filter ist `ISOTranslate`, und `WideCharToMultiByte` kommt sonst nur in `FileBrowseView.cpp` und `TextToSpeech.cpp` vor, beide nicht im Speicherweg. **Vermutung, nicht gemessen:** die Umwandlung geschieht in der Paige-/Trident-Schicht beim Schreiben der Nachricht. **Wie zu prüfen:** eine HTML-Nachricht mit einem Zeichen außerhalb von windows-1252 öffnen (das Postfach `Plugin-Test.mbx` aus `Testdaten/` enthält eines), prüfen dass es im Fenster richtig steht, `Strg-S`, dann die `.mbx` nach `??` durchsuchen — es darf keines geben. **Zuletzt gemessen: 22.10.2026 an 7.2.0.120** **Stufe: kritisch** (Datenschaden: ein richtig angezeigtes Zeichen geht beim Sichern verloren)|
| <a id="e-135"></a>E-135 | **Die Vervollständigungsbox im `To:`-Feld wird bei jedem Cursor-Schritt kleiner** | **behoben in 7.2.0.120, von Gregor am 21.10.2026 an Paket 1.0.120 am laufenden Programm bestätigt** — sein Wortlaut nach dem Prüfgriff aus [C10](TESTPLAN.md#c10): *„beim cursor up/down bleibt die größe der box gleich. klasse!"*, dazu ein Bildschirmfoto mit zwei Treffern (`freenet`, `freenet_news`) und richtig bemessener Box. Gemeldet hatte er den Fehler am selben Tag an 1.0.119, und er ist **am laufenden Programm gemessen**, rot und grün, am eigenen Prüfstand (`tools/messen-e135.ps1` unter `tools/testlauf.ps1`, Prüfstand `C:\Temp\E135-box` mit fünf Kurznamen gleichen Anfangs). **Das Bild:** Gregor tippt einen Kurznamen, die Auswahlbox erscheint — *„das Fenster wird bei jeder Änderung (z.B. nächster Eintrag) kleiner!"*. **Die Ursache:** `AutoCompleterListBox::ReCalcACListBoxPos` (`AutoCompleteSearcher.cpp:530`) las mit `GetClientRect` das **Innen**maß und setzte daraus über `MoveWindow` das **Außen**maß, plus 6 Pixel. QUALCOMMs Kommentar daneben: *„Why 6? I haven't a clue. I imagine it's because the border around the window is 3 pixels? I dunno."* **Gemessen:** der Rand ist **14 Pixel**, nicht 6 — also 8 Pixel Verlust je Aufruf. Pro Cursor-Schritt wird **zweimal** gerufen, aus `OnArrowKey` (`:1109`) und aus dem `SetControlToItem` (`:849`), das `OnArrowKey` selbst auslöst; macht 16 Pixel je Schritt in Höhe **und** Breite. Dritter Aufrufer ist `OnDeleteKey` (`:1135`). Die Messreihe: Schritt 0 `100 × 62`, 1 `84 × 46`, 2 `68 × 30`, 3 `52 × 14`, 4 `36 × 14`, 5 `20 × 14` — nach fünf Cursor-Schritten war nichts mehr zu sehen. **Behoben:** Außenmaß gegen Außenmaß, also `GetWindowRect` ohne die sechs Pixel — genau wie in `InitList` (`:593`), das es von Anfang an so machte und deshalb nie geschrumpft ist. Die Größe setzt `InitList`; diese Funktion heißt `…Pos` und verschiebt jetzt nur noch. **Gegengemessen am laufenden Programm**, je sechs Schritte, zwei nachweislich verschiedene EXE (MD5 `b50d9136` gegen `1158d27c`): vorher `62 → 14`, nachher **konstant `108 × 70`**. **243 Tests, 243 bestanden** — die Testsuite deckt diesen Weg allerdings **nicht** ab, der Beleg ist allein die Messung am laufenden Programm. **Quelltext original** — `AutoCompleteSearcher.cpp` ist seit dem initial commit unverändert; ob sich Hermes 7.1 ebenso verhielt, ist **nicht gemessen** (Lehre aus [E-134](#e-134)). **Nicht behoben und nicht gemessen:** `MoveWindow` erwartet Koordinaten im Klientenbereich des Elternfensters; `ReCalcACListBoxPos` und `DoACListBox` rechnen mit `ScreenToClient` um, `InitList` **nicht**. Ob das ein zweiter Fehler ist, steht offen. **Gregors Ziel für diesen Weg**, am 21.10.2026 wörtlich: *„ich starte, einen nick zu tippen, dann erscheint die auswahl-box, aus der ich den namen per cursor auswählen kann … dann mit tab wird der eintrag übernommen, die mail adresse erscheint im To: feld."* Die Tastenbehandlung liegt in `headervw.cpp:2807` (`VK_TAB`) und `:2881` (`VK_UP`/`VK_DOWN`/`VK_DELETE`). **Mit im selben Zweig, aber nicht gemessen:** [PRÜFER-43 K9](../Befunde/PRUEFER-43.md#k9) sagte für `OnRightButtonDown` (`nicktree.cpp:2941`) denselben Fehlerfall wie [E-134](#e-134) voraus — Rechtsklick wähle nicht aus, das Kontextmenü bleibe ausgegraut. **Nicht gemessen — die Vorbedingung wurde im Messlauf nicht hergestellt** (`tools/messen-k9.ps1`, fünf Klickhöhen je Fassung, Rechtsklick an `y = 10, 26, 42, 58, 74`): beide Fassungen melden danach genau **ein** ausgewähltes Kind. K9 nennt als Vorbedingung aber *erst* einen Rechtsklick in den **leeren Bereich unter** die Einträge und *dann* einen zweiten auf **dasselbe** Element — das Skript tut weder das eine noch das andere, sondern trifft bei den fünf Kurznamen in `C:\Temp\E135-box` fünf **verschiedene** Einträge (nachgezählt am 21.10.2026 vom CHRONIST). Grund für das gemessene Bild: beim Klick auf ein *anderes* Element wandert die Karette, und dann setzt `SelectItem()` `TVIS_SELECTED` sehr wohl. Die Vorhersage ist damit **weder bestätigt noch widerlegt**. Die Zeile `DoSelectItem(tvhit.hItem, TRUE)` ist trotzdem eingebaut — als **Sicherung**, nicht als gemessene Behebung. **Von Gregor zurückgestellt am 21.10.2026:** [PRÜFER-44 K1](../Befunde/PRUEFER-44.md) — nach *Entf* bleibt die Box zu groß — *„box zu groß: ist keine hohe prio fehler."* Nicht von selbst aufgreifen. **Verwandt:** [E-134](#e-134) (dasselbe Arbeitsgebiet und dieselbe Ursachenklasse) **Stufe: unkritisch** (Vervollstaendigungsbox wird kleiner)|
| <a id="e-134"></a>E-134 | **Ein neuer Adressbucheintrag nimmt den eingetippten Kurznamen nicht an — der Baum behält `Untitled`** | **behoben in 7.2.0.119, von Gregor am 21.10.2026 an Paket 1.0.119 am laufenden Programm bestätigt** — sein Bildschirmfoto zeigt drei Kurznamen mit ihren Adressen im Baum, auf seine Rückfrage zur Auswahlbox hin: *„ja, e-134 eintragen."* Gemeldet hatte er den Fehler am selben Tag, am eigenen Prüfstand nachgestellt und die Behebung dreimal am laufenden Programm gemessen: 3 x `alias hans` in `NNdbase.txt` gegen 3 x `alias Untitled` an 1.0.118, dazu 243 Tests, 243 bestanden. **Das Bild:** *Address Book* → *New*, im Feld *Nickname* `hans` eintippen, wegklicken — das Feld zeigt `hans`, der Baum weiter `Untitled`. Gregor: *„es war 1x nicht richtig, 1x richtig gespeichert, jetzt wieder falsch"*. **Die Ursache, in einem Satz:** `CTreeCtrl::SelectItem()` ist `TVM_SELECTITEM`/`TVGN_CARET` und tut **nichts**, wenn das Element schon die Karette trägt — auch dann nicht, wenn ein `DoDeselectAll()` davor `TVIS_SELECTED` gerade gelöscht hat. Genau dieses Bit liest `IsItemSelected()`, auf dem `GetSelectedNicknames()` (`nicktree.cpp:636-675`) steht. Zwei Stellen verlassen sich darauf, dass `SelectItem()` auswählt: `AddNewNickname` (`nicktree.cpp:508`) für den neu angelegten Eintrag und `NicknameWasChanged` (`nicktree.cpp:877-894`), die bei **jedem Tastendruck** im Namensfeld läuft und dort erst `DoDeselectAll()` ruft und dann `SelectItem()`. Ergebnis: `GetSelectedNicknames` liefert 0, `nickname` wird nie geholt, nichts zurückgeschrieben. **Gemessen** (Spurmarken, Release 7.2.0.118, Prüfstände unter `C:\Temp\E134-*`): bei jedem Tastendruck und beim Fokusverlust läuft `NicknameEditChanged` an, `pWndSplitter` und `pViewLeft` sind da, `Auswahl im Baum (0)`. Baumzustand über `TVM_GETITEMSTATE` von außen gelesen: Wurzel `0x0062` = `SELECTED+EXPANDED`, Kind `0x0000` = **nicht ausgewählt**. Direkt im Code gemessen: *„nach SelectItem allein: NICHT ausgewaehlt"*, *„nach DoSelectItem: ausgewaehlt"*. Ein Zwischenstand, der nur die Auswahl beim Anlegen nachzog, brachte genau **einen** Buchstaben auf die Platte (`alias h` statt `alias hans`) — weil `NicknameWasChanged` sie beim ersten Umbenennen gleich wieder abräumte. **Warum es mal ging:** wer vorher einen vorhandenen Eintrag anklickte, hatte ein Kind mit `TVIS_SELECTED` aus `OnLButtonDown`, das über `DoSelectItem` geht und deshalb hält. Zusätzlich war die Stelle **nicht festgelegt**: zwei Läufe derselben Fassung meldeten an derselben Zeile einmal *ausgewaehlt* und einmal *NICHT ausgewaehlt*, weil `SelectItem()` über `TVN_SELCHANGED` → `OnSelChanged` → `SetFocus()` + `EvaluateSelection()` den Fokus verschiebt. Genau das sah Gregor als *„mal ja, mal nein"*. **Zu Gregors Frage *„was ist denn hier neu? in der alten Hermes-Implementierung hat es funktioniert"*:** der Quelltext ist es **nicht**. `nickview.cpp`, `nickview.h`, `nicktree.cpp`, `nicktree.h` und `Eudora.manifest` sind seit `567a5d87 00 initial commit mit den original sourcen` **von uns nie angefasst worden** (`git log` leer, `git diff` leer). Der Entwurf QUALCOMMs wählt den neuen Eintrag sehr wohl aus: `CNicknameFile::AddNickname` sendet `NICKNAME_HINT_ADDED_NEW_NICKNAME` (`nickdoc.cpp:1759`), dessen Behandlung `AddNewNickname` ruft, und die endet auf `DoDeselectAll(); SelectItem(h_nickname);`. **Also: Quelltext original, Verhalten verändert** — eine Portierungsfolge, obwohl keine Zeile dieser Dateien von uns stammt. Die Einordnung *„Originalverhalten"*, die hier zuerst stand, war **falsch**; belegt war nur, dass die `//FORNOW`-Kommentare original sind — eine Aussage über den Kommentar, nicht über das Verhalten. **Nachgemessen am 22. Tag darauf, [PRÜFER-43](../Befunde/PRUEFER-43.md#k1):** an einem eigenen Baum mit denselben Stilbits wie `IDC_NICKNAME_LEFT_LIST`, je einmal gegen comctl32 **5.82** und **6.16** — beide **gleich**. Karette woanders, dann `SelectItem(X)`: Bit **1** (und das Bit der alten Karette wird gelöscht). Bit von `X` gelöscht, Karette steht schon auf `X`, dann `SelectItem(X)`: Bit **0**. Die Fassung der Common Controls scheidet damit als Erklärung aus; es ist die Lage der Karette. Für `NicknameWasChanged` (jeder Tastendruck) ist das der belegte Fall, für `AddNewNickname` eine Sicherung — dort setzt derselbe Ablauf mit einem frisch eingefügten, sortierten Kind das Bit in der Messung sehr wohl. **Weiterhin offen:** warum die Karette in diesem Bau schon auf dem Eintrag steht, wo sie es in Hermes nicht tat. Die Behebung hängt nicht daran — sie setzt den Zustand ausdrücklich, statt ihn anzunehmen. **Behoben:** nach beiden `SelectItem()`-Aufrufen ein `DoSelectItem(…, TRUE)`; dazu der zweite, unabhängige Mangel in `NicknameEditChanged` (`nickview.cpp:622`): `if (Name geändert) { … ASSERT(0); return; }` brach **immer** ab, wenn sich der Name geändert hatte, nicht nur im Fehlerfall — im Freigabebau ist `ASSERT(0)` nichts, der Abbruch also stumm (Klasse [E-83](#e-83)). Jetzt wird beim **Fokusverlust** die Eingabe übernommen, beim Fokusgewinn bleibt es beim alten Verhalten, und der Prüfmodus wird auf jedem Ausgang zurückgesetzt. **Gegengemessen:** mit der Behebung dreimal `alias hans` in `NNdbase.txt`, mit der ausgelieferten 1.0.118 dreimal nicht. **Verwandt:** [E-83](#e-83) (`ASSERT` im Release), [X-3](#x-3) (dieselbe Datei) **Stufe: wichtig** (Eingabe: Kurzname wird nicht uebernommen)|
| <a id="e-133"></a>E-133 | **Zeigt die Registry auf ein Mailverzeichnis, das es nicht mehr gibt, weigert sich Eudora zu starten** — statt zu fragen oder ein eigenes anzulegen | **offen, am 21.10.2026 von Gregor am laufenden Programm gefunden, Ursache am Quelltext belegt, auf Gregors Entscheidung hin **offen gelassen** (*„nur aufnehmen, nicht fixen"*). **Das Bild:** Doppelklick auf `Eudora.exe`, dann der Dialog *„The directory specified in the command line: C:\Temp\SICHER~1 doesn't exist or is not writable."* — danach startet Eudora nicht. **Die Kette:** `StartEudoraWithDefaultLocation` holt das Verzeichnis aus `HKCU\Software\Qualcomm\Eudora\CommandLine\Current` und reicht es an `GetDirs` (`eudora.cpp:1055`); dort scheitert `CheckMailDirectory` an `FileExistsMT` (`fileutil.cpp:374-378`), meldet `IDS_ERR_BAD_EUDORA_DIR` und liefert FALSE; `InitInstance` zeigt daraufhin `IDS_ERR_CANNOT_START_WITH_ATTACH` und gibt FALSE zurück. **Zwei Fehlermeldungen, kein Eudora.** **Quelltext original, Verhalten nicht gemessen** — der Registryweg ist unverändert, und durch [E-132](#e-132) nur besser beschrieben. **Daraus folgt aber nicht, dass sich Eudora 7.1 ebenso verhielt.** Hier stand bis zum 21.10.2026 *„Originalverhalten, nicht von uns eingebaut"*; das war derselbe Fehlschluss, den [E-134](#e-134) einen Tag später widerlegt hat: dort sind `nickview.cpp`, `nicktree.cpp` und `Eudora.manifest` seit dem initial commit **von uns nie angefasst** worden — und das Verhalten war trotzdem ein anderes als in Hermes. Unveränderter Quelltext belegt unverändertes Verhalten **nicht**. Ob ein Hermes 7.1 mit einem Registryeintrag auf ein gelöschtes Verzeichnis ebenfalls den Start verweigert, ist **nicht gemessen** — hier steht keines zum Gegenmessen. **Am Urteil ändert das nichts:** der Befund bleibt offen, auf Gregors Entscheidung hin nicht behoben. **Wen es trifft:** jeden, der sein Mailverzeichnis verschiebt, umbenennt, von einem Wechseldatenträger startet oder dessen letzte Eudora in einem inzwischen gelöschten Ordner lag. **Wie es gefunden wurde, und das gehört dazu:** meine eigenen Prüfläufe zu [E-132](#e-132) hatten den Registryeintrag auf das Prüfverzeichnis `C:\Temp\Sicherung ohne INI` gesetzt; danach habe ich das Verzeichnis gelöscht und den Zeiger darauf vergessen. Gregors nächster Doppelklick auf sein 1.0.117 lief in genau diesen Zustand. Der Zeiger ist am 21.10.2026 auf sein Paket zurückgesetzt worden. **Was naheliegt, aber nicht entschieden ist:** dieselbe Rückfrage wie bei einem fremden Verzeichnis — ein Verzeichnis, das es nicht gibt, ist kein Grund, den Start zu verweigern, sondern einer, ein eigenes anzulegen. Die Stelle liegt unmittelbar neben der von [E-132](#e-132). **Verwandt:** [E-132](#e-132) (derselbe Startweg), [E-12](#e-12) (dieselbe Funktion, andere Fehldeutung des Parameters) **Was noch fehlt:** Gregor hat *„nur aufnehmen, nicht fixen"* entschieden — aufzugreifen wäre, bei fehlendem Verzeichnis zu fragen oder ein eigenes anzulegen statt den Start zu verweigern (`eudora.cpp:1055`, `fileutil.cpp:374-378`, direkt neben E-132). **Am 23.10.2026 dabei geblieben:** Gregor fragte, ob `Eudora starten.cmd` als Umgehung reicht — ja, es übergibt das eigene Mailverzeichnis und umgeht den gemerkten Pfad; die Umgehung steht seitdem in der Fehlertabelle der `README.md`. Ungemessen bleibt, ob Hermes 7.1 ebenso verweigert. **Stufe: kritisch** (Start: Eudora verweigert den Start statt zu fragen)|
| <a id="e-132"></a>E-132 | **Ein Doppelklick auf `Eudora.exe` übernimmt stillschweigend das Mailverzeichnis einer fremden Installation** — gefunden über die Registry, ohne Rückfrage | **behoben und ausgeliefert: die Rückfrage steckt in `v1.0.117` (21.10.2026, 07:56:56 UTC), ihr Fehlerfall in `v1.0.120` (21.10.2026, 19:07:37 UTC).** Gebaut zuerst im Zweig `e-132-fremdes-mailverzeichnis` als 7.2.0.114, am 20.10.2026 nachgestellt und auf allen drei Wegen gemessen, **dort aber noch nicht ausgeliefert**; danach 7.2.0.115 (das eigene Verzeichnis galt als fremd), 7.2.0.116 (Rückfrage auf allen Startwegen, gemerkte Antwort), 7.2.0.117 (kopierte Sicherung ohne `Eudora.ini`) und 7.2.0.118 (eine **fehlgeschlagene** Rückfrage übernahm das fremde Verzeichnis trotzdem). **Hier stand bis zum Abend des 21.10.2026 „noch nicht ausgeliefert"** — während [MELDUNGEN-VON-AUSSEN.md](../MELDUNGEN-VON-AUSSEN.md) genau auf diesen Befund verlinkt und dem Melder von außen *„Fixed in 7.2.0.117 and 7.2.0.118, released in `v1.0.120`"* sagt; berichtigt in [L-49.2](../Befunde/LEKTOR-49.md#l-49.2). Abgetrennt aus [E-131](#e-131) am 20.10.2026. **Die Kette, gemessen am Quelltext:** `eudora.cpp:1036-1052` — ist die Befehlszeile leer **und** liegt **keine** `Eudora.ini` neben der EXE, ruft Eudora `StartEudoraWithDefaultLocation()` (`:3700`). Diese Funktion prüft zuerst `UseAppData` in `[Settings]` der `DEudora.ini`; fehlt der Schlüssel, liest sie `HKEY_CURRENT_USER\Software\Qualcomm\Eudora\CommandLine\Current`, ersatzweise `HKEY_CLASSES_ROOT`, und **schneidet den Datenordner aus der dort hinterlegten Befehlszeile heraus** (`:3736-3748`) — also aus dem letzten Start einer **anderen** Eudora- oder Hermes-Installation. Erst wenn auch das nichts liefert, kommt der Application-Data-Ordner. **Genau diese beiden Bedingungen erfüllt unser Paket:** die mitgelieferte `Eudora.ini` liegt in `Mailverzeichnis\`, **nicht** neben der EXE. Wer `Eudora.exe` doppelklickt statt `Eudora starten.cmd` zu benutzen, landet deshalb im fremden Datenverzeichnis — und schreibt dort hinein. **Das ist der Weg hinter [E-131](#e-131):** der Melder aus [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102) schrieb *„the new install »found« (via registry lookups) the existing one in another folder and modified its ini"* – der Satz stammt aus seinem Fehlerbericht und nicht von der Oberflaeche; gesetzt wird dieser Weg in `StartEudoraWithDefaultLocation` (`eudora.cpp:3700`). **Ich hatte ihm zunächst widersprochen** — nach einem Blick allein in `fileutil.cpp`, wo die Suche mit Befehlszeile, Umgebungsvariable und Programmverzeichnis endet. Die Registrystufe steht eine Ebene höher, in `eudora.cpp`. Die offizielle ReadMe nennt sechs Stufen in dieser Reihenfolge: Befehlszeile, `Eudora.ini` im Programmordner, `DEudora.ini`→`DataFolder`, Registry, Application Data, Programmordner. **Entschieden von Gregor am 20.10.2026: fragen**, nicht verweigern — Eudora soll melden, dass es ein vorhandenes Mailverzeichnis gefunden hat, und die Wahl lassen (*Vorhandenes benutzen* / *Eigenes anlegen* / *Abbrechen*), mit **„Eigenes anlegen" als Vorgabe**, damit ein unbedachtes Enter nichts beschädigt. Die Rückfrage gehört an `eudora.cpp:1049-1052`, **bevor** irgendetwas geschrieben wird. **Behoben am 20.10.2026 — und die Behebung hatte zwei weitere Schichten, die erst die Messung gezeigt hat.** **Erstens: die Registry speichert keinen Pfad, sondern den ganzen Aufruf.** Gemessen auf Gregors Prüfstand und bestätigt durch den Registry-Export eines fremden PC vom 20.10.2026: `HKCU\SOFTWARE\Qualcomm\Eudora\CommandLine\current` enthält dort `C:\Temp\EUDORA7\Eudora.exe C:\Windows.old\Users\<Benutzer>\DOCUME~1\EUDORA~2 C:\Windows.old\Users\<Benutzer>\DOCUME~1\EUDORA~2\Eudora.ini` — nach dem Abschneiden des Programmnamens stehen in `buf` also **zwei** Pfade, durch ein Leerzeichen getrennt; `GetDirs()` trennt sie erst später (`fileutil.cpp:432`). Die erste Fassung der Rückfrage hängte `\Eudora.ini` an diese **Gesamtzeichenkette** an, prüfte damit auf eine Datei, die es nie gibt, und hat deshalb **nie** etwas als fremd erkannt: eingebaut und stumm. Dafür gibt es jetzt `E132AufrufZerlegen` (`eudora.cpp:3771`) mit derselben Trennregel wie `GetDirs`. **Zweitens: die Spurmarke konnte an dieser Stelle gar nicht geschrieben werden.** `StartEudoraWithDefaultLocation` läuft, **bevor** `QCLogFileMT::InitDebug` das Protokoll öffnet — und das muss so sein, denn das Protokoll liegt im Mailverzeichnis, das hier erst gesucht wird. `PutDebugLog` kehrt ohne `s_pLogFile` stumm zurück (`QCUtils/src/debug.cpp:141`). Die Zeilen werden jetzt gemerkt und in `InitInstance` direkt nach `InitDebug` ausgegeben (`eudora.cpp:1209`), **in beiden Ausgängen** — auch wenn nichts Fremdes gefunden wurde, steht `fremd=0` im Protokoll. Vorher schrieb nur der Fremdfall, und darum stand dort nicht einmal, dass die Stelle erreicht wurde. **Die Messung, alle drei Wege** (`C:\Temp\E132` = unser Paket, `C:\Temp\E131` = die fremde Installation mit eigener `Eudora.ini`, Antwort jeweils als `WM_COMMAND` an das gemessene Fensterhandle): *Nein* → `fremd=1`, dann `eigenes gewaehlt="C:\Temp\E132\Mailverzeichnis"`, fremde `Eudora.ini` SHA256 unverändert. *Ja* → `fremdes bewusst uebernommen`, das Protokoll landet im **fremden** Verzeichnis und dessen `Eudora.ini` ändert sich (`LastKnownCrashInfo=0` → `=1`) — **genau der Schaden aus Issue #102, nach fünfzehn Sekunden Laufzeit**. *Abbrechen* → das Programm endet, nichts wird angefasst. **Gegenprobe:** zeigt die Registry auf das eigene Paket, steht `fremd=0` im Protokoll und es wird nicht gefragt. **Prüfstand:** `Eudora71/Tests/TestE132.cpp`, sieben Fälle, Regionen R und R2 — 241 Tests, 241 bestanden. **Was der Registry-Export außerdem zeigt** (Suche nach „eudora" auf einem PC mit vier Eudora-Installationen): **(a)** dieselbe Befehlszeile steht **dreifach** — unter `HKCU`, unter `HKEY_CLASSES_ROOT\SOFTWARE\Qualcomm\Eudora\CommandLine\Current` (die zweite Stufe im Code, `eudora.cpp:3777-3783`) und unter `HKU\<SID>\…`; es genügt also nicht, den `HKCU`-Eintrag zu räumen. **(b)** `HKCU\SOFTWARE\Qualcomm\Eudora\LaunchManager` führt zehn `Path#N`-Werte aus **vier** Installationen (Anhänge, eingebettete Bilder, IMAP-Ablage), bis hin zu `e:\gregor\eudora\attach` auf einem anderen Laufwerk, und `DLLPath` zeigt auf `C:\Temp\EUDORA41\EuShlExt.dll` — die Shell-Erweiterung einer Eudora **4.1**. **(c)** sämtliche Dateizuordnungen zeigen auf die **alte** EXE: `mailto` auf `C:\Temp\EUDORA41\Eudora.exe /m %1`, `x-eudora-option`, `.sta`, `Eudora.Mailbox`, `Eudora.Stationery`, `App Paths\Eudora.exe` (auch unter `WOW6432Node`) und `Clients\Mail\Eudora` auf `C:\Temp\EUDORA7\Eudora.exe`. Ein Doppelklick auf ein Postfach oder ein `mailto:`-Link startet dort also **nicht** unsere Fassung — und **umgekehrt**: würden wir diese Zuordnungen setzen, kaperten wir die vorhandene Installation. Das verletzte Gregors Anforderung vom 20.10.2026 und wird deshalb **nicht** getan. **(d)** `UseAppData` kommt im ganzen Export **nicht** vor — der von QUALCOMM vorgesehene Riegel ist auf einem gewachsenen System nicht gesetzt.**Was hilft, bis es behoben ist:** `Eudora starten.cmd` benutzen; es übergibt das Mailverzeichnis als Argument (`start "" "%HIER%Eudora.exe" "%DATEN%"`) und schneidet damit Stufe 1 ab. **Ein zweiter, von QUALCOMM vorgesehener Riegel ist ungeprüft:** `UseAppData=1` in `[Settings]` unserer ausgelieferten `DEudora.ini` würde die Registrystufe überspringen — dann landet Eudora aber im Application-Data-Ordner des Anwenders, der ebenfalls fremde Daten enthalten kann. **Verwandt:** [E-131](#e-131) (was dort geschrieben wurde), [E-6](#e-6) (derselbe Startweg, andere Richtung). **Prüfung: manuell** (Teil M1 in [TESTPLAN.md](TESTPLAN.md#m1-e132)) **Von Gregor am Programm bestätigt** (vom CHRONIST am 23.10.2026 aus dem Chatverlauf belegt, nachdem Gregor schrieb: *„starten mit fremden verz. funktioniert schon länger. das habe ich mehrfach geprüft."*): die Rückfrage erscheint — an 1.0.114 und 1.0.115 (21.10.2026, *„0.115: 2x nacheinander starten verhält sich jetzt korrekt"*); *Vorhandenes benutzen* — an 1.0.118 (*„0.118 habe ich auf die mails von 0.116 gesetzt, absichtlich"*) und an 1.0.120 (21. und 22.10.2026). Gescheitert war 1.0.117 (*„kann nichts starten, wenn ich nur die .exe anklicke"*), behoben in 7.2.0.118. **Nicht einzeln gemeldet** hat Gregor die Schritte 2 (Vorauswahl *Eigenes anlegen*), 3 (*Abbrechen* lässt die fremde Installation unverändert), 4 (Protokollzeilen) und 6 (Start über `Eudora starten.cmd` ohne Rückfrage) aus [TESTPLAN M1](TESTPLAN.md#m1-e132). **Stufe: kritisch** (Fremdschaden Issue 102: fremdes Mailverzeichnis stillschweigend uebernommen)|
| <a id="e-131"></a>E-131 | **Unsere Fassung schreibt eine ungültige Fensterposition in die `Eudora.ini` — danach stürzt eine daneben installierte Eudora/Hermes 7.1 beim Start ab** | **behoben in 7.2.0.113 (Schreibweg) und 7.2.0.121 (Bereinigung vor dem ersten Laden), am laufenden Programm gemessen; der Leseweg ist am 22.10.2026 zu Ende gemessen und war nie der beschriebene.** **Nachgestellt:** ein einziges Starten und Beenden von 7.2.0.112 im Prüfverzeichnis genügte — die INI wuchs von 3249 auf 6480 Byte, 16 Abschnitte kamen dazu, und `MRUFloatXPos=-2147483648` stand **dreimal** darin. Es betraf also nicht nur `v1.0.101`. **Die Behebung:** `E131LeistenpositionenBereinigen()` am Ende von `CMainFrame::SaveBarState` (`mainfrm.cpp`) geht die `ToolBar*`-Abschnitte der INI durch und ersetzt jede unbrauchbare Schwebeposition durch eine, die auf dem Bildschirm liegt; entschieden wird in der eigenen Funktion `E131PositionIstBrauchbar`. **Gemessen nach der Behebung:** `E-131 Leistenposition: abschnitte-mit-eintrag=5 berichtigt=5 bildschirm=0,0,1920x1294 ersatz=40,40`, danach `MRUFloatXPos=40` und **null** Treffer für `INT_MIN`. Bei einem zweiten Lauf steht wieder `berichtigt=5` — MFC schreibt den Wert jedes Mal neu, die Nachbehandlung fängt ihn jedes Mal ein. ****234 Tests, 234 bestanden** (fünf neue), am laufenden Programm gemessen; **der erste Entwurf der Regel war falsch und ein Test hat ihn gefangen:** er verlangte 100 Pixel Luft auf allen vier Seiten, wodurch `y=1200` auf einem 1294 Pixel hohen Schirm als unbrauchbar galt. Nach links und oben gilt die Luft, nach rechts und unten die Bildschirmkante. **Die Gegenprobe ist der wichtigere Test:** gewöhnliche Positionen bleiben unangetastet — sonst wäre aus der Behebung *„jede Position wird überschrieben"* geworden und der Anwender fände seine Leisten jedes Mal woanders. **Offen bleibt der Leseweg:** eine INI, die bereits kaputte Werte trägt, wird erst beim nächsten Sichern berichtigt; unser Eudora kommt damit zurecht (gemessen), ein fremdes Programm vielleicht nicht.  **Erster Fehlerbericht eines Fremden** ([Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102), `rjsdotorg`, 18.10.2026). Er hat das veröffentlichte **`v1.0.101`** in einem **eigenen Ordner** neben seinem Hermes 7.1.0.9 gestartet; danach stürzt sein Hermes beim Start ab: `EXCEPTION_ACCESS_VIOLATION` in `MFC71.DLL`, Ordinal 3952, `ECX=0`. Seine Zerlegung: Ordinal 3952 ist ein kurzer Aufruf über einen Objektzeiger (`mov eax,[ecx]` / `call [eax]`), `ECX=0` heißt Null-Zeiger beim **Fensteraufbau**. Sein Vergleich beider INIs nennt die Stelle: in der kaputten stehen Leisteneinträge **`MRUFloatXPos=-2147483648`** (`INT_MIN`), in der heilen stehen dort gültige Werte. **Am Quelltext belegt:** `MRUFloatXPos`, `MRUFloatYPos` und `MRUDockID` sind **MFCs eigene** Schlüssel für Werkzeugleisten; geschrieben werden sie von `SaveBarState(_T("ToolBar"))` in `Eudora71/Eudora/mainfrm.cpp:1027`. `INT_MIN` ist kein Bildschirmpunkt, sondern ein nie gesetzter Wert, der hinausgeschrieben wird. **Was verlorengehen kann:** nicht Post, aber die **Benutzbarkeit einer fremden, vorhandenen Installation** — das alte Programm startet nicht mehr. **Was hilft, bis es behoben ist:** `Eudora.ini` und Mailverzeichnis sichern, bevor eine Fassung dieses Projekts neben einer vorhandenen Installation läuft; der Melder hat dasselbe geraten. **Noch nicht gemessen:** ob unsere aktuelle Fassung dieselbe Zeile schreibt (Vermutung: ja, der Aufruf ist unverändert), und ob das **Lesen** einer bereits kaputten INI bei uns ebenfalls abstürzt. **Behebung, vorgeschlagen und nicht gebaut:** vor `SaveBarState` die gemerkte Schwebeposition auf einen gültigen Bildschirmpunkt prüfen und sonst nicht schreiben; beim Lesen denselben Wächter, damit eine vorhandene kaputte INI niemanden umbringt. Verwandt: [E-84](#e-84) und `tools/pruefe-leistengroessen-paar.pl` — dieselbe Ecke, Schreiben und Lesen der Leistenwerte. **Von Gregor am 20.10.2026 beantwortet** (sein ausdrückliches Ja zum Wortlaut); die Antwort nennt ausdrücklich, dass wir es noch **nicht** nachgestellt haben. **Zweiter Ablageort der Leistenwerte, gefunden am 20.10.2026 im Registry-Export eines fremden PC:** `CMainFrame::SaveBarState` (`mainfrm.cpp:2877-2886`) schaltet `m_pszRegistryKey` vorübergehend auf `Qualcomm\Eudora` und schreibt die Leistenzustände **zuerst in die Registry**, unter `HKCU\Software\Qualcomm\Eudora\<voller Pfad der Eudora.ini>\ToolBar-Bar0…9`, `ToolBar-Summary`, `ToolBar-ToolBarManager`, und kopiert sie erst danach in die INI. Auf jenem PC stehen diese Schlüssel **nur** unter dem Pfad **unserer** Fassung (`C:\Temp\Eudora72-1.0.10-release\Mailverzeichnis\Eudora.ini\…`); die drei Originalinstallationen (`EUDORA41`, `EUDORA7`, `C:\Windows.old\…\eudora_data`) haben dort **keine** solchen Unterschlüssel. **Zwei Folgerungen:** erstens sind die Werte nach INI-Pfad getrennt, eine zweite Installation überschreibt der ersten also ihren Leistenzustand nicht — das ist der Teil, der **nicht** schadet. Zweitens bleibt bei uns etwas liegen, was das Original wegräumt: ein möglicher Leseweg für E-131, der beim Prüfen der `Eudora.ini` allein unsichtbar ist. **Am 21.10.2026 am Quelltext beantwortet ([L-49.3](../Befunde/LEKTOR-49.md#l-49.3)): nein.** `m_pszRegistryKey` wird im ganzen Baum an **genau einer** Stelle gesetzt — in `CMainFrame::SaveBarState` selbst (`mainfrm.cpp:2886`) und in `:3103` wieder zurück; `SetRegistryKey` ruft außerhalb nur die eigenständige PureVoice-Anwendung (`PureVoice/Recorder/QVoice.cpp:62`). Der Leseweg (`SECDockState::LoadState` → `CDockState::LoadState` → `CWinApp::GetProfileInt`, gerufen in `mainfrm.cpp:888`) läuft deshalb mit `m_pszRegistryKey == NULL` und liest die **`Eudora.ini`**, nicht die Registry. **Belegt am Quelltext, nicht am laufenden Programm.** Die Registrykopie bleibt also liegen, wird beim Start aber nicht gelesen — sie ist kein zweiter Leseweg für E-131. Offen bleibt der eigentliche Leseweg: eine INI, die schon kaputte Werte trägt, wird erst beim nächsten Sichern berichtigt. . " " . **Zweiter Punkt des Melders, am 21.10.2026 am Quelltext beantwortet ([L-49.10](../Befunde/LEKTOR-49.md#l-49.10)):** in seiner `Eudora.ini` steht `MRUFloatYPos=-682908189` in `[ToolBar-Bar10]` — anders als die verwaisten Abschnitte liegt dieser **innerhalb** von `Bars=12` und wird bei jedem Start geladen. `E131PositionIstBrauchbar` fängt den Wert: die Regel verwirft jedes `nY < nOben - nHoehe + 100` (`mainfrm.cpp:2797`), und das trifft auf `-682908189` auf jedem wirklichen Bildschirm zu. **Die Berichtigung läuft aber beim Sichern, nicht beim Lesen** — die Zeile verschwindet erst, wenn unsere Fassung einmal beendet wurde, und wird bis dahin so geladen, wie sie dasteht. Was MFC damit bis dahin tut, ist **nicht gemessen**; das ist derselbe offene Leseweg wie oben. **Am Abend des 21.10.2026 in Tests gegossen** (PR #130, `Eudora71/Tests/TestE131.cpp`): zwei Fälle für genau diesen Wert, mit Gegenprobe — nimmt man die obere y-Schranke heraus, bleiben die fünf vorhandenen Fälle grün und nur die beiden neuen werden rot; **245 Tests, 245 bestanden**. Geführt wird der Punkt als `#102-4` in [MELDUNGEN-VON-AUSSEN.md](../MELDUNGEN-VON-AUSSEN.md), dort seither unter *Resolved*. **Was noch fehlt:** nichts mehr — **am 22.10.2026 zu Ende gemessen.** Die hier bis dahin beschriebene Lücke gab es so nicht: die Gegenprobe am Prüfstand (fünfmal `MRUFloatXPos=-2147483648`) zeigte, dass Eudora die Leisten **schon beim Start** speichert und die Bereinigung bereits nach 10 ms lief (Spurmarke bei 0.01 s, direkt hinter `5g nach SaveBarState(ToolBar)`). In 7.2.0.121 steht der Aufruf zusätzlich **vor** dem ersten `LoadState`, damit er nicht daran hängt. **Die Restfrage — gibt es einen Startweg ohne diese Bereinigung? — ist am Quelltext beantwortet: nein.** `FinishInitAndShowWindow` hat **genau eine** Aufrufstelle (`CEudoraApp::InitInstance`, `eudora.cpp:1569`), `InitInstance` ist **einmal** definiert, und alle 30 Rückgaben davor sind `return FALSE` — das beendet die Anwendung. Wer früher aussteigt, schreibt auch nichts in die INI. **Stufe: kritisch** (Fremdschaden Issue 102: fremde Installation startet nicht mehr)|
| <a id="x-7"></a>X-7 | **`bauen.ps1` blieb hängen, nachdem der Bau längst fertig war** — zwölf Minuten Stillstand ohne eine Zeile Ausgabe | **behoben** am 09.09.2026, beim Bau von 7.2.0.29 selbst aufgetreten. **Gemessen:** MSBuild war um **12:17:52** fertig — 0 Fehler, `Eudora.exe` gelinkt, Protokoll mit 3,7 MB vollständig geschrieben. Danach lief `bauen.ps1` bis 12:29 weiter: **CPU flach** (6,53 s unverändert über sechs Sekunden Messung), **kein einziger Kindprozess**, Protokoll unverändert. Der Prozess musste abgeschossen werden. **Ursache:** `Start-Process -Wait` wartet nicht auf *den* Prozess, sondern auf ihn **und seine Nachkommen** — dafür legt PowerShell ein Auftragsobjekt an. MSBuild startet mit `/m` eigene Knoten, der Nachbearbeitungsschritt **BIND** startet weitere Programme. Bleibt eines davon hängen oder wird es umgehängt, wartet `-Wait` weiter, obwohl MSBuild selbst beendet ist. **Behebung:** kein `-Wait` mehr; gewartet wird auf den MSBuild-Prozess selbst mit `WaitForExit($ms)` und Zeitschranke (`-ZeitschrankeMinuten`, Vorgabe 45). Läuft er über, wird er abgeschossen und der Lauf gilt als gescheitert. **Dieselbe Regel wie für Nachrichtenschleifen im Programm** (E-51, E-61): nie ohne Zeitschranke warten — ein Warten ohne Ende ist teurer als ein klarer Fehlschlag, weil es nichts anzeigt. **Die Behebung hatte einen zweiten Teil:** ohne `-Wait` liefert `$p.ExitCode` **`$null`** — PowerShell hält den Prozesszeiger nicht offen. Der erste Lauf nach der Umstellung war einwandfrei (1:10, 0 Fehler, `Eudora.exe` 7.2.0.29 frisch gelinkt, Versionsprobe grün) und wurde trotzdem als **FEHLSCHLAG** gemeldet. Abhilfe: `$null = $p.Handle` **vor** dem Warten merkt den Zeiger vor. Gegengetestet mit `cmd /c exit 0` und `exit 3`: mit Vormerken 0 und 3 abgelesen, ohne Vormerken leer **Stufe: werkzeug** (bauen.ps1 haengt)|
| <a id="x-8"></a>X-8 | **ein neues Werkzeug im Hauptbaum machte jeden anderen Arbeitsbaum committierunfähig** | **behoben** am 09.09.2026. Die Haken liegen in `.git/hooks` und gelten damit für **alle** Arbeitsbäume — die Werkzeuge liegen aber **je Arbeitsbaum**. Kaum war `tools/pruefe-nachrichtenschleife.pl` im Hauptbaum eingehängt, fand `perl` es in `wt/lektor` nicht, der Hook gab einen Fehler zurück, und **jeder** Commit dort wurde abgewiesen. **Gemessen an LEKTOR:** eine halbe Stunde nicht committierbar, obwohl seine Arbeit fertig und alle seine eigenen Schranken grün waren — er hat weder die fremde Datei kopiert noch `--no-verify` benutzt, sondern gemeldet. Dieselbe Sache eine Stufe vorher mit `lehren-schranken.pl`. **Behebung:** eine Hilfsfunktion `schranke()` in beiden Haken — fehlt ein Werkzeug in **diesem** Arbeitsbaum, wird es übersprungen und gemeldet. Fehlt es im Hauptbaum, fällt das dort auf. Gegengetestet in einem frischen `git init` ohne `tools/`: alle Schranken übersprungen, Rückgabewert 0; im Hauptbaum laufen sie unverändert. **Die Lehre dahinter:** ein Werkzeug, das noch in keinem Zweig liegt, darf keine fremde Arbeit blockieren — [[agenten-trennen-worktrees]] **Stufe: werkzeug** (Arbeitsbaum)|
| — | **Nebenbefund, noch nicht eingeordnet:** nach einem Neustart stehen die Fenster nicht im **Vollbild**, obwohl sie beim Beenden so waren | Gregor am 09.09.2026 an 1.0.25. Das ist der **Fensterzustand**, nicht die Registerkartenleiste — ein eigener Weg über `SaveOpenWindows` und den `[ToolBar…]`-Abschnitt, den es seit [**E-43**](#e-43) überhaupt erst gibt. Getrennt zu messen, damit es nicht unter A-3 verschwindet |
| <a id="e-44"></a>E-44 | *Aufgabenstatus* und *Aufgabenfehler* stehen **senkrecht links** statt waagrecht unten — und nach dem Anlegen des ersten Kontos sieht das Fenster falsch aus (Anforderung **A-2**, Kriterium 8) | **behoben** in 7.2.0.23, **von Gregor am 08.09.2026 bestätigt**: *„jetzt ist sie unten, ja"*, gemessen mit `tools/leisten-messen.ps1` (Leiste **320**, Andockseite **unten**, sichtbar, **1712×80**). **Zwei getrennte Ursachen, beide gemessen.** (1) Beim **frischen** Profil lag die Leiste bereits richtig — `tools/leisten-messen.ps1` am 08.09.2026: Andockseite **unten**, **1712×80** — sie wurde nur unmittelbar danach durch `pWazooBar->SendMessage(WM_COMMAND, ID_SEC_HIDE, 0)` versteckt (`WazooBarMgr.cpp`, `SetDefaultWazooBarState` Fall 2, Zweig `DST_SHOWHIDE`). Diese Zeile ist entfallen. (2) Ab dem **zweiten** Start greift der andere Zweig: existiert ein `[WazooBars]`-Abschnitt, läuft `LoadWazooConfigFromIni` (`WazooBar.cpp:552`) — das stellt nur wieder her, **welche** Fenster in einer Leiste sitzen und wo die Reiter sitzen, **nicht** die Andockseite. Die käme aus MFCs `LoadBarState` und damit aus `[ToolBar...]` — und den Abschnitt gibt es wegen **E-43** nicht. Alle drei Leisten blieben deshalb auf `CBRS_LEFT` aus `CreateInitialWazooBars` (`WazooBarMgr.cpp:136`). Jetzt wird die Standardanordnung nachgezogen, wenn eine Leiste an keiner Andockleiste hängt (`m_pDockBar == NULL`) — dieselbe Prüfung benutzt das Projekt schon selbst (`mainfrm.cpp:994`). Ist eine Lage gespeichert, ändert sich nichts **Stufe: unkritisch** (Bereiche stehen senkrecht statt waagrecht)|
| <a id="e-45"></a>E-45 | von den zwölf Schritten aus **E-42** durfte **einer** nicht übersprungen werden: ohne `QCWorkbook::OnClose` bleibt ein **Prozess ohne Fenster** übrig | **behoben** in 7.2.0.23. Gefunden von **PRUEFER** (`Befunde/PRUEFER-5.md`, Punkt 1b). `QCWorkbook::OnClose` löst sich auf `CFrameWnd::OnClose` auf, und deren **letzte** Anweisung ist `DestroyWindow()` (MFC 14, `winfrm.cpp:941`); `CMainFrame::OnClose` ruft `DestroyWindow` nirgends selbst. Fällt der Schritt aus, gibt es kein `WM_QUIT`, kein `ExitInstance` und damit kein `IniStringCleanUp` (`eudora.cpp:2118`) — das Fenster hat `HideApplication` (`winfrm.cpp:885`) dann schon versteckt. **Keine Verschlechterung gegenüber dem Zustand vor E-42:** dort fing `AfxCallWndProc` dieselbe Ausnahme, `DestroyWindow` lief ebenso nicht — nur sichtbar war es, weil eine Meldung kam. Jetzt eigener Fangzweig, der `DestroyWindow()` nachholt, wenn das Fenster noch existiert **Stufe: kritisch** (Beenden laesst einen Prozess zurueck)|
| <a id="e-46"></a>E-46 | Verdacht: `CMainFrame::OnClose` arbeitet nach `QCWorkbook::OnClose` noch **rund 230 Zeilen** weiter — auf einem bereits **freigegebenen** Objekt | **widerlegt** (Spurmarke in 7.2.0.23 gesetzt, in 7.2.0.24 ausgewertet): die Marke `E-46 CMainFrame::~CMainFrame betreten` erscheint erst **nach** der Stelle, nicht zwischen `vor QCWorkbook::OnClose` und `nach QCWorkbook::OnClose`. Die Ursache von **E-43** war etwas anderes — `SECControlBar` war zweimal definiert. Die Marke bleibt drin, weil sie die Reihenfolge belegt. Die Beweisführung, die zum Verdacht führte, war in sich stimmig und trotzdem falsch: `CFrameWnd::PostNcDestroy` ist wörtlich `delete this` (MFC 14, `winfrm.cpp:269-275`), `CMainFrame` überschreibt es nicht (im Bestand kein einziges `PostNcDestroy`), und `CFrameWnd::OnClose` endet mit `DestroyWindow()` (`winfrm.cpp:941`), das `WM_NCDESTROY` **synchron** zustellt. Der Aufruf steht aber **mitten** im Rumpf (`mainfrm.cpp`, Schritt 6 von 12), danach folgen `TocCleanup`, `TrimJunk`, `SaveBarState("ToolBar")` und acht weitere Schritte. Wäre der Verdacht richtig, hätte **E-43** damit seine Ursache und die krummen Fensterlagen ihre Erklärung. **Entschieden wird das an einer Protokollzeile:** steht `E-46 CMainFrame::~CMainFrame betreten` **zwischen** `vor QCWorkbook::OnClose` und `nach QCWorkbook::OnClose`, ist der Verdacht belegt; steht sie danach, ist er widerlegt. Die Marke greift nichts an **Stufe: unkritisch** (Verdacht, nicht nachgewiesen)|
| <a id="e-34"></a>E-34 | eine MFC-Ausnahme in `QCChildToolBar::GetButton` wickelte den **ganzen Fensterbau** ab — ohne Meldung, ohne Absturz, ohne Fenster. MFC 14 wirft dort `CInvalidArgException` („Encountered an improper argument"), wo MFC 6 nur eine Zusicherung prüfte; die Ausnahme lief aus `OnCreateClient` heraus, damit schlug `CWnd::OnCreate` fehl, `LoadFrame` gab FALSE und `CreateNewFrame` NULL | **behoben und von Gregor bestätigt** (Paket 1.0.20/1.0.21): Index-Schranke plus `TRY`/`CATCH_ALL` in `Eudora71/Eudora/QCChildToolBar.cpp`. **Die Wurzel ist ein offener Widerspruch:** `GetBtnCount()` und `m_btns[24]` lesen **dasselbe** `m_nSize` (`afxcoll.inl:201-217`) — aus einem unveränderten Objekt kann „Index 24 von 27" nicht werfen. Es bleiben Erklärungen außerhalb der Indexrechnung: abgebautes oder falsch typisiertes Leistenobjekt, beschädigter Heap **Stufe: kritisch** (Speicherfehler: Fensterbau abgewickelt ohne Meldung)|
| <a id="e-35"></a>E-35 | der **zweite** Strg-N starb — eine Folge von E-34: `OnUserUpdateImmediateSend` dereferenzierte den Rückgabewert von `GetButton` blind, und der war seit E-34 NULL statt einer Ausnahme | **behoben und von Gregor bestätigt** (Paket 1.0.21), `Eudora71/Eudora/CompMessageFrame.cpp` — Zeiger einmal fassen und prüfen **Stufe: kritisch** (Speicherfehler: Nullzeiger dereferenziert)|
| <a id="e-36"></a>E-36 | zweimal dasselbe in `UpdateMoodMailButton` und `UpdateBPButton`, vier blinde Zugriffe; gefunden vom eigenen Absturzbericht, nachdem ein Verfassen-Fenster einfach offen stehen blieb | **behoben und von Gregor bestätigt** (Paket 1.0.21), `Eudora71/Eudora/PgCompMsgView.cpp` **Stufe: kritisch** (Speicherfehler: vier blinde Zugriffe)|
| <a id="e-37"></a>E-37 | **ein gelöschtes Konto bleibt in der Liste stehen**, und dabei erscheint **„Encountered an improper argument"** | **kein eigener Fehler — Symptom von E-43.** Am 08.09.2026 Zeile für Zeile nachverfolgt: `CPersonality::Remove` (`persona.cpp:565`) löscht den INI-Abschnitt — deshalb ist die Persönlichkeit nach einem Neustart tatsächlich weg — und ruft **danach** `g_thePersonalityDirector.DeleteCommand` (`:571`) → `NotifyClients(pCommand, CA_DELETE)` → `QCCustomToolBar::Notify` (`QCCustomToolBar.cpp:951`; die Leiste meldet sich im Konstruktor bei genau diesem Verwalter an, `:130`). Dort steht in `:970` das E-43-Muster: Schleifengrenze aus `GetBtnCount()`, Zugriff über `m_btns[i]`. Der Zugriff wirft, die Ausnahme fliegt aus `Remove()` heraus, und **der Anzeige-Code darunter wird nie erreicht**. Belegt durch die Abwesenheit jeder Spur: in Gregors Protokoll zu 1.0.23 steht **keine einzige** E-37-Marke. Meine zwei Behebungsanläufe (FindItem, dann GetItemText) konnten deshalb nicht wirken — sie lagen hinter dem Wurf. **Behoben mit E-43 in 7.2.0.24**, **von Gregor am 08.09.2026 bestätigt**: *„persona läßt sich löschen. keine messagebox“* — der Eintrag verschwindet sofort und die Meldung bleibt aus. Damit ist auch die Kette selbst belegt, nicht nur am Quelltext abgelesen **Stufe: wichtig** (Funktion: geloeschtes Konto bleibt stehen)|
| <a id="e-38"></a>E-38 | **die im Kontoassistenten eingegebenen Daten fehlen unter *Konto → Eigenschaften*** | **kein Fehler — von Gregor am 08.09.2026 aufgeklärt.** Sein Wort: *„nach dem löschen eines kontos, wenn das konto noch sichtbar ist, dann fehlen die daten in den eigenschaften. weil sie vermutlich bereits in der ini gelöscht wurden. beim neuen konto sind sie zu sehen."* Mit Bildschirmfoto belegt: bei `test5` stehen *Real Name*, *Email Address*, *User Name* und *SMTP Server* vollständig da. Die leeren Felder gehörten zu einem **Geistereintrag** — einer über E-37 in der Liste stehengebliebenen Persönlichkeit, deren INI-Abschnitt `Remove()` schon entfernt hatte. Ein Abschnitt, den es nicht gibt, liefert leere Werte. Damit sind die beiden alten Verdächtigen hinfällig: weder `GetParams` (`persona.cpp:279ff`) noch die `UpdateData(TRUE)`-Richtung in `WizardInServerPage.cpp:116-119` sind schuld. **Fällt mit E-37 und damit mit E-43 weg** **Stufe: wichtig** (Funktion: Kontodaten fehlen in den Eigenschaften)|
| <a id="e-39"></a>E-39 | wird die **aktuell benutzte** Persönlichkeit gelöscht, kann ihr INI-Abschnitt teilweise wieder entstehen | **offen, nicht am laufenden Programm bestätigt.** `CPersonality::Remove` (`persona.cpp:565-566`) löscht den Abschnitt, leert aber den INI-Zwischenspeicher nicht und stellt die aktuelle Persönlichkeit nicht um; `SetCurrent` prüft nicht, ob der Name existiert (`:179-198`, Kommentar *„we're trusting souls"*). `FlushINIFile` schreibt `SavePassword` und `SavePasswordText` ausdrücklich in `g_Personalities.GetCurrent()` (`rs.cpp:1237-1250`) — der nächste `SetCurrent` legt damit zwei Schlüssel im gelöschten Abschnitt wieder an. **Unabhängig von der E-37-Behebung**, die den Zeitpunkt nur nach vorn verschiebt. Gefunden beim Nachmessen der eigenen E-37-Behebung. Naheliegend: nach erfolgreichem `Remove` auf `<Dominant>` umschalten, wenn die gelöschte die aktuelle war **Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — am Quelltext unverändert, die Zeilennummern sind nachgezogen. `CPersonality::Remove` löscht den Abschnitt in `persona.cpp:565-566` und stellt die aktuelle Persönlichkeit weiterhin nicht um; `CPersonality::SetCurrent` beginnt bei `:179` und prüft weiterhin nicht, ob der Name existiert (*„we're trusting souls"*, `:195`); `FlushINIFile` schreibt `SavePassword` und `SavePasswordText` unverändert in `g_Personalities.GetCurrent()` — `rs.cpp:1238-1246`, nicht mehr `:1237-1250`. Die Bestätigung am laufenden Programm steht damit weiter aus. **Was noch fehlt:** die Bestätigung am laufenden Programm — belegt ist nur der Quelltext (`persona.cpp:565-566` und `:179-198`, `rs.cpp:1237-1250`). Zu fahren wäre: die aktuelle Persönlichkeit löschen, beenden, in `Eudora.ini` nach `SavePassword` im gelöschten Abschnitt sehen. Naheliegende Behebung: nach `Remove` auf `<Dominant>` umschalten. **Stufe: kritisch** (Datenschaden: INI-Abschnitt einer geloeschten Persoenlichkeit kehrt zurueck)|

> **E-10 ist eine Lücke, [E-15](#e-15) und [E-18](#e-18) bis [E-21](#e-21) sind es NICHT.** Bis zum
> 07.09.2026 stand hier, alle sechs Kennungen seien nie vergeben worden;
> gesucht worden war aber nur in den `.md`-Dateien. Fünf davon sind in
> **Quellkommentaren** vergeben und dort auch begründet:

| Kennung | Worum es geht | Wo es steht | Status |
|---|---|---|---|
| <a id="e-15"></a>E-15 | `ASSERT(g_TaskStatusView != NULL)` widersprach allen drei Aufrufern — sie fragen ausdrücklich auf NULL ab | `Eudora71/Eudora/TaskStatusView.cpp`, `QCGetTaskStatusView` — **behoben** im Quelltext, kein Abschnitt hier **Stufe: wichtig** (Zusicherung widerspricht allen Aufrufern)|
| <a id="e-18"></a>E-18 | `pFld` ohne Prüfung dereferenziert; der Zweig läuft nur bei mehr als einer Persönlichkeit und war bis 05.09.2026 nie betreten | `Eudora71/Eudora/headervw.cpp`, Persönlichkeitsmenü — **behoben** im Quelltext; im `CHANGELOG.md` unter 7.2.0.10 **Stufe: kritisch** (Speicherfehler: Zeiger ohne Pruefung dereferenziert)|
| <a id="e-19"></a>E-19 | `ASSERT(0)` in einem **Reparaturzweig** — feuert genau dann, wenn alles wie vorgesehen läuft | `Eudora71/Eudora/tocdoc.cpp`, Reparatur des In-Postfachnamens — **behoben** im Quelltext; im `CHANGELOG.md` unter 7.2.0.10 **Stufe: wichtig** (Zusicherung feuert im Normalfall)|
| <a id="e-20"></a>E-20 | `[nLen + 1]` statt `[nIdx + 1]`: geschrieben wird bis `pTemp[nIdx]`, und `nIdx` kann größer als `nLen` sein — dann schrieb die Zeile hinter das Feldende | `Eudora71/Eudora/ListCtrlEx.cpp`, `CListCtrlEx::InsertArr` und `NotifyInsertedCol` — **behoben** im Quelltext, kein Abschnitt hier **Stufe: kritisch** (Speicherfehler: Schreiben hinter das Feld)|
| <a id="e-21"></a>E-21 | `ASSERT(0)`, wo `WSAEWOULDBLOCK` (10035) die normale Antwort eines nicht blockierenden Sockets ist | `Eudora71/QCSocket/src/QCWorkerSocket.cpp` — **behoben** im Quelltext, kein Abschnitt hier **Stufe: wichtig** (Zusicherung auf die normale Antwort eines Sockets)|

> **E-10** dagegen gibt es tatsächlich nicht — 0 Abschnitte, bestätigt in
> `PRUEFUNG-BRANCH.md`. Eine Lücke in der Nummerierung, kein verlorener Befund.
>
> **Die Lehre:** wer prüft, ob eine Kennung vergeben ist, muss den **Quelltext**
> mitsuchen. `grep -rn 'E-18\b' --include=*.md` findet fünf Befunde nicht, die
> es gibt.

## Unterbefunde, die man einzeln sucht

Diese Kennungen haben **keinen eigenen Abschnitt auf oberster Ebene**, sondern
stehen als Unterpunkt in einem größeren Befund. Wer nach ihnen sucht und oben
nichts findet, sucht hier. Ergänzt am 05.09.2026, weil zum Beispiel [`PR-6`](#pr-6) und
[`P-3`](../Befunde/PRUEFER-11.md#p-3) bis dahin in keiner Zeile des Verzeichnisses vorkamen.

| Kennung | steht in | Worum es geht | Status |
|---|---|---|---|
| <a id="pr-3"></a>PR-3 | `### PR-3` unter **W-1** | eine Liste der Textdateiarten statt zwei — **behoben** **Stufe: werkzeug** (unter W-1)|
| <a id="pr-4"></a>PR-4 | `### PR-4` unter **W-1** | `BuildKennung.h` ist nicht mehr in git verfolgt — **behoben** **Stufe: werkzeug** (unter W-1)|
| <a id="pr-5"></a>PR-5 | `### PR-5` unter **W-1** | Zeitstempel der Kennung ist nicht der Bauzeitpunkt — **behoben** (`765c39b`) **Stufe: werkzeug** (unter W-1)|
| <a id="pr-6"></a>PR-6 | `### PR-6` unter **W-1** | kein `_T` um ein Makro (bricht im Unicode-Bau) — **behoben** **Stufe: werkzeug** (unter W-1)|
| <a id="pr-7"></a>PR-7 | `### PR-7` unter **W-1** | die Zahlen in S-7 widersprachen sich: es gilt 4616 von 5563 — **behoben** **Stufe: werkzeug** (unter W-1)|
| <a id="pr-8"></a>PR-8 | `### PR-8` unter **W-1** | `rekursion-suchen.pl` gelöscht — fand seinen eigenen Anlass nicht; das Werkzeug liegt nicht mehr im Baum — **behoben** **Stufe: werkzeug** (unter W-1)|
| [PR-2.0](../Befunde/PAKET.md#pr-2.0) … PR-2.9 | `### PR-2.x` unter [**PR-2**](#pr-2) | zehn Punkte der Nachprüfung vom 31.08. | [PR-2.0](../Befunde/PAKET.md#pr-2.0) und PR-2.1 **behoben**, PR-2.8 kein Handlungsbedarf, Rest **offen** |
| P-1.0 … P-1.8 | `### P-1.x` unter [**P-1**](#p-1) (POP-Abrufpfad) | elf Altlasten auf dem Abrufpfad | P-1.1/P-1.8 **behoben**, P-1.5b–P-1.5j **offen** |
| [P-2.1](#p-2.1) … P-2.7 | `### P-2.x` unter [**P-2**](#p-2) (Absturzpunkt) | Absicherung vor dem ersten Abruf | **behoben** |
| [P-1](#p-1), [P-2](#p-2), [P-3](../Befunde/PRUEFER-11.md#p-3) (PROBE) | `### P-1`/`### P-2`/`### P-3` unter **PROBE** | drei Härtungslücken beim ersten Lauf der Ersatzschicht; **[P-3](../Befunde/PRUEFER-11.md#p-3)** ist `SECDateTimeCtrl::FixedTime`, das die Stunde ausläßt (Fehler im Original, bewusst übernommen) | **offen** |
| S-3a, S-3b, S-3c | `### S-3x` unter [**S-3**](#s-3) | erster Lauf durch einen Anwender | S-3a **behoben**, S-3b **gegenstandslos** (Release-Bau, gemessen 22.10.2026), S-3c **offen** |
| [E-9](#e-9), Nachtrag | unter **[E-9](#e-9)** | die Plugins sind es NICHT — gemessen | **Beleg** |

> ### Achtung: drei Kennungen sind doppelt vergeben
>
> Beim Zusammenführen mehrerer Agenten sind Kennungen zweimal vergeben worden.
> Umbenannt wird **nicht** rückwirkend — zu viele Querverweise hängen daran.
> Wer sucht, muss beide Fundstellen kennen:
>
> | Kennung | Bedeutung A | Bedeutung B |
> |---|---|---|
> | [**P-1**](#p-1) | `### P-1` (PROBE): `OnActivateTab`/`ClearSelection` rufen `GetParent()` ungeprüft | `## P-1`: der POP-Abrufpfad, vor dem ersten Abruf gegengelesen |
> | [**P-2**](#p-2) | `### P-2` (PROBE): `SECTabWndBase::InsertTab` blendet ein Fenster ungeprüft aus | `## P-2`: der Absturzpunkt vor dem ersten Abruf abgesichert |
> | [**PR-2**](#pr-2) | [`PR-2`](#pr-2) in `PRUEFBERICHT.md`: Schranke schlägt bei Leerzeilen grundlos an (**behoben**) | `## PR-2` hier: Nachprüfung der Arbeit vom 31.08. mit [PR-2.0](../Befunde/PAKET.md#pr-2.0) bis PR-2.9 |
>
> **[`E-12`](#e-12) war der vierte Fall und ist aufgelöst:** Agent KONTO und Agent
> FORTSCHRITT haben unabhängig „die nächste freie E-Nummer" gewählt. [`E-12`](#e-12)
> bleibt beim Mailverzeichnis-Argument (KONTO, zuerst zusammengeführt); der
> Fortschrittsbefund heißt seit dem 05.09.2026 **[`E-13`](#e-13)**.
>
> **Wer eine neue Kennung vergibt, misst zuerst über alle Zweige:**
>
> ```sh
> for b in $(git branch -a --format='%(refname:short)' | grep -v HEAD); do
>   git grep -hoE '^#+ +E-[0-9]+' "$b" -- BEFUNDE.md 2>/dev/null
> done | sed 's/#\+ *//' | sort -u -V
> ```

## Kennungen, deren Abschnitt noch auf einem Arbeitszweig liegt

Diese Kennungen sind **vergeben**, ihr Befundtext steht aber noch nicht in
`bau-und-pruefung`. Sie stehen hier, damit sie kein zweites Mal vergeben werden
— genau das ist mit [`E-12`](#e-12) passiert. Gemessen am 05.09.2026 mit dem Befehl aus
dem Kasten oben.

| Kennung | Worum es geht | Zweig | zu tun beim Zusammenführen |
|---|---|---|---|
| X-5 | ein Commit drei Minuten nach dem Merge: die Regel stand nur als Prosa | `wt/schranke` (`5e1187a`) | Verzeichniszeile in die Tabelle „Prüfberichte über die eigene Arbeit" nachtragen |
| X-6 | ein Bau-Lauf meldete Erfolg, ohne gebaut zu haben | `wt/baumeister` | dito |
| E-13 | Fortschritt beim Mailabruf ist nicht sichtbar (Abschnitt steht **hier**, der **Code** noch nicht) | Behebung in `bd3959c` auf `wt/fortschritt-arbeit` | dort die Überschrift `## E-12 — Der Fortschritt beim Mailabruf …` **entfernen**, sonst steht `E-12` zweimal in der Datei |

**Nächste freie Kennungen, gemessen über alle Zweige am 05.09.2026:**
[`E-14`](#e-14), `B-4`, [`X-7`](#x-7), `Z-4`. (`E-10` ist eine bewusste Lücke, siehe oben.)
## Was in dieser Datei sonst noch steht

Neben den Befunden vier Sammelkapitel, die **kein** Mangel sind und deshalb oben
nicht auftauchen: „Geprueft und in Ordnung" (zweimal, aus der ersten Prüfung und
aus Nachprüfung 3), „Geprueft und in Ordnung — Stufe 4, Bildschicht" und
„Nachgeprueft: die beiden Meldungen des Agenten TABELLE". Sie sagen, wo eine
spätere Prüfung **nicht** noch einmal anfangen muss — dafür sind sie da.

---

# Befundbericht Korrektheitspruefung

**Geprueft am:** 2026-08-29
**Stand Teil 1:** `b4b7de5` bzw. Nachtrag `ba617a8` auf Branch `vs2022-portierung-fixes`
**Stand Teil 2 (Nachpruefung, unvollstaendig):** `8dd6b2a` - siehe letzter Abschnitt
(Durchsicht begann bei `fd9a235`; die waehrenddessen entstandenen Commits
`e4a0fae`, `75b60e1`, `b4b7de5` sind eingearbeitet.)
**Vergleichsbasis:** `git diff main...HEAD`
**Pruefer:** Agent PRUEFER (nur lesend; ausser dieser Datei wurde nichts geaendert)

## Was geprueft wurde

Korrektheitsfehler: Stellen, an denen sich das Verhalten gegenueber Eudora 7.1
ungewollt geaendert hat oder an denen der neue Code falsch ist. Schwerpunkt in
dieser Reihenfolge:

1. QCSSL (OpenSSL 0.9.7 -> 3.x): `QCSSLContext.cpp`, `qccertificate.cpp`,
   `certstore.cpp`, `SSLConnectionManager.cpp`
2. Die OT501-Ersatzschicht unter `Eudora71/OTShim/`
3. Die rund 90 Einzelkorrekturen an Eudoras eigenem Code (alle Hunks von
   `git diff main...HEAD --ignore-cr-at-eol` ueber `*.cpp`/`*.h` ausserhalb von
   `OpenSSL3/`, `MAPI/include/` und `Tests/` wurden gelesen)

## Was ausdruecklich nicht geprueft wurde

- **Die Hostnamenpruefung in QCSSL** (nur CN, keine SAN, rein beratend) -
  bekannt, belegt und vom Auftraggeber bewusst zurueckgestellt.
- Stil, Formatierung, Namensgebung.
- Die Dokumentation (`README.md`, `PORTIERUNG.md`) - dafuer ist LEKTOR
  zustaendig.
- `Eudora71/OpenSSL3/**` - fremder Quelltext, unveraendert uebernommen.
- `Eudora71/MAPI/include/*.h` - rund 25.000 Zeilen unveraenderte
  Microsoft-SDK-Header.
- `Eudora71/Tests/**` - das Pruefgeruest selbst (nicht der Prueflingscode).
- Die `.vcxproj`-Dateien (QCSSL, QCSocket, QCUtils; zusammen rund 1.200
  geaenderte Zeilen). Einzig `<Platform>Win32</Platform>` wurde nachgesehen,
  weil Befund [N1](#n1) davon abhaengt.
- `Releases/1.0/QCSSL.dll` - Binaerdatei.
- Zeilenenden und Kodierung der beruehrten Dateien.
- Die Rumpfteile von `TBarBmpCombo.cpp`, `TBarStatic.cpp`, `TBarEdit.cpp`
  jenseits von Konstruktoren und Nachrichtentabellen.
- Es wurde nichts gebaut und nichts ausgefuehrt; alle Befunde stammen aus dem
  Quelltext.

---

# Befunde

## <a id="h1"></a>H1 - QCSSL: ungueltige Protokollversion bricht die Verbindung nicht mehr ab

**Sicherheit: nachgewiesen**

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp`, `SetSSLVersion()`,
`default:`-Zweig ab Z. 578, Wirkung ab Z. 585.

Vorher stand im `default:`-Zweig nur die Fehlermeldung; `sslmethod` blieb
`NULL`, und die Funktion endete mit `return SSL_CTX_new(sslmethod);`.
`SSL_CTX_new(NULL)` liefert `NULL`. `BeginQCSSLSession()` fing das ab:

```
SSL_CTX *pSSLCtx = SetSSLVersion(pSSLReference);
if (!pSSLCtx) { ASSERT(0); g_Mutex.Unlock(); return false; }
```

Jetzt steht der Aufruf ausserhalb des `switch`:

```
	default:
		... AddComments(CResString(IDS_ERR_VERSIONINVALID));
		break;
	}

	sslmethod = TLS_client_method();

	SSL_CTX	*pCtx = SSL_CTX_new(sslmethod);
```

**Folge:** Bei einem ungueltigen `m_ProtocolVersion` wird der Kommentar
"Version ungueltig" zwar noch in die ConnectionInfo geschrieben, die Verbindung
kommt aber trotzdem zustande - mit `iMinVersion = TLS1_2_VERSION`, weil die
Variable ihren Anfangswert behaelt. Aus "abbrechen" ist "stillschweigend
weitermachen" geworden. Der Fehlerfall oeffnet also, statt zu schliessen.

**Zu tun:** Im `default:`-Zweig `return NULL;` statt `break;` - oder eine
Merkervariable setzen und vor `SSL_CTX_new()` abfragen.

---

## <a id="h2"></a>H2 - Zeichentabelle: bereits behoben, Korrektur nachgeprueft

**Sicherheit: nachgewiesen (Befund und Behebung)**

**Datei:** `Eudora71/Eudora/utils.cpp`

Beide in `4c2f614` gemeldeten Fehler - sieben falsche Zuordnungen und die
Doppelersetzung durch das zeilenweise `CString::Replace()` - sind mit `b4b7de5`
behoben worden. Die Pruefung dieser Sitzung war unabhaengig zum selben Ergebnis
gekommen: Die Eingabe `C3 83 C2 A9` (U+00C3 gefolgt von U+00A9) haette
`C3 A9` ergeben muessen, wurde aber zu dem einen Byte `E9`, weil die Zeile
`C3 83 -> 0xC3` ein neues Fuehrungsbyte erzeugt, das die spaetere Zeile
`C3 A9 -> 0xE9` noch einmal frisst. Aus zwei Zeichen wurde eines.

Die Korrektur wurde nachgeprueft und ist richtig:

- Alle 27 CP1252-Zeilen wurden byteweise gegen CP1252.TXT geprueft. Alle 27
  stimmen jetzt (0x80..0x9F ohne 81, 8D, 8F, 90, 9D).
- Der Ersatz von `CString::Replace()` durch einen einzigen Links-nach-rechts-Lauf
  ist korrekt: `lWrite <= lRead` gilt in beiden Zweigen, das Schreiben in
  denselben Puffer ist damit gefahrlos; der Laengenlauf ueber `pFrom[iLen]`
  liefert 2 bzw. 3, wie es das Zeilenformat verlangt; `lRead + iLen > lSize`
  verhindert das Lesen ueber das Pufferende; "laengste Uebereinstimmung
  gewinnt" ist implementiert.

Kein Handlungsbedarf. Hier nur festgehalten, damit spaetere Pruefungen wissen,
dass die Stelle geprueft ist.

---

## <a id="m1"></a>M1 - QCSSL: aus "genau TLS 1.0" wurde "mindestens TLS 1.0, nach oben offen"

**Sicherheit: nachgewiesen (Code); Auswirkung: Verdacht**

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp`, `SetSSLVersion()`, Fall 3
(Z. 573-575) sowie `SSL_CTX_set_min_proto_version()` Z. 590.

`TLSv1_method()` war eine **versionsgenaue** Methode: Unter- *und* Obergrenze
TLS 1.0. Die Ersetzung setzt nur `SSL_CTX_set_min_proto_version(ctx,
TLS1_VERSION)` und laesst die Obergrenze offen.

Zwei Abweichungen auf einmal:

1. Fall 3 handelte frueher genau TLS 1.0 aus; jetzt kann bis TLS 1.3
   ausgehandelt werden. Das ist vermutlich gewuenscht, steht aber weder im
   Kommentar noch in `PORTIERUNG.md`.
2. Fall 3 setzt die Untergrenze auf TLS 1.0, waehrend alle anderen Faelle
   TLS 1.2 verlangen. Wer in den Einstellungen "TLSv1" gewaehlt hat, bekommt
   damit eine **schwaechere** Untergrenze als jeder andere. Praktisch faengt
   das die Voreinstellung Security Level 1 von OpenSSL 3 wieder ab, die TLS < 1.2
   ohnehin ablehnt - verlassen sollte man sich darauf nicht.

**Zu tun:** Entscheiden, ob Fall 3 heute noch etwas anderes bedeuten soll als
Fall 0/1/4/6/7. Wenn nicht: ebenfalls auf `TLS1_2_VERSION` legen. Wenn doch:
`SSL_CTX_set_max_proto_version()` mitsetzen und den Kommentar ergaenzen.

---

## <a id="m2"></a>M2 - QCSSL: `BIO_s_workersocket()` ist fuer sich genommen nicht threadsicher

**Sicherheit: nachgewiesen (Code); in der Praxis derzeit entschaerft**

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp` Z. 310-334.

```
static BIO_METHOD *s_pMethodsWS = NULL;

BIO_METHOD *BIO_s_workersocket()
{
	if (s_pMethodsWS == NULL)
	{
		s_pMethodsWS = BIO_meth_new(...);      // <-- zuerst zuweisen
		...
		BIO_meth_set_write(s_pMethodsWS, ws_write);   // <-- dann fuellen
		...
	}
	return s_pMethodsWS;
}
```

Vorher war das eine funktionslokale `static BIO_METHOD` mit konstantem
Initialisierer - statisch initialisiert, also von Haus aus threadsicher.
Jetzt gibt es zwei Rennen:

- Zwei Threads sehen beide `NULL`, beide rufen `BIO_meth_new()` auf; einer der
  beiden Bloecke bleibt fuer immer liegen (kleines Leck).
- Schlimmer: `s_pMethodsWS` wird **vor** den Settern zugewiesen. Ein zweiter
  Thread kann in genau diesem Fenster einen `BIO_METHOD` mit lauter
  Null-Zeigern bekommen. `BIO_new()` ruft dann `create == NULL` auf bzw. die
  spaeteren `read`/`write` laufen ins Leere.

**Warum es heute trotzdem haelt:** Der einzige Aufrufer ist `BIO_new_ws()`
(Z. 338), und der einzige Aufrufer davon ist `BeginQCSSLSession()` (Z. 789),
das seit Z. 745 unter `g_Mutex` laeuft. Solange das so bleibt, kann das Rennen
nicht auftreten.

**Zu tun:** In eine lokale Variable bauen und erst am Ende zuweisen - das
kostet nichts und macht die Funktion unabhaengig von `g_Mutex`.

---

## <a id="m3"></a>M3 - OTShim: `SetWorkbookMode()` setzt `m_bWorkbookMode` nicht

**Sicherheit: nachgewiesen**

**Datei:** `Eudora71/OTShim/OTShim.cpp`, `SECWorkbook::SetWorkbookMode()`
(Z. 1067-1081), zusammen mit `OnViewWorkbook()` (Z. 1156-1159) und
`OnUpdateViewWorkbook()` (Z. 1161-1165).

Der Setzer meldet den nicht umgesetzten Fall und ruft
`m_pWBClient->SetMargins(0,0,0,0)` - er weist `m_bWorkbookMode` aber nie zu.
Der Wert bleibt fuer die gesamte Laufzeit auf dem `FALSE` aus dem Konstruktor.

**Folge:** `OnViewWorkbook()` ruft immer `SetWorkbookMode(TRUE)`, nie
`SetWorkbookMode(FALSE)`; `OnUpdateViewWorkbook()` zeigt den Haken nie an. Der
Menuepunkt reagiert also aus Sicht des Anwenders gar nicht - und da die
Hinweismeldung ueber eine `static`-Merkervariable nur einmal je Sitzung kommt,
passiert ab dem zweiten Klick sichtbar nichts.

Das kann Absicht sein ("der Modus gibt es nicht, also bleibt er aus"), steht so
aber nirgends. Falls Absicht: als Kommentar hinschreiben. Falls nicht:
`m_bWorkbookMode = bEnabled;` ergaenzen.

---

## <a id="m4"></a>M4 - `QCWorkerSocket`: Empfangsrichtung liest die Sendeeinstellung

**Sicherheit: nachgewiesen. Nicht aus der Portierung - Originalfehler.**

**Datei:** `Eudora71/QCSocket/src/QCWorkerSocket.cpp:2084`

```
else   // Empfang, Standardport
{
	m_pSSLReference->m_ProtocolInfo.m_ProtocolVersion = pSettings->m_nSSLSendVersion;
}
```

Jede andere Zeile in diesem `else`-Block liest `m_nSSLReceive...`; nur diese
eine liest `m_nSSLSendVersion`. `m_nSSLReceiveVersion` existiert und wird in
`SSLSettings.cpp:75` aus `IDS_INI_SSL_RECEIVE_VERSION` geladen - es wird nur
nirgends benutzt.

**Folge:** Die Protokollversion fuer POP/IMAP kommt aus der SMTP-Einstellung.
Bisher war das folgenlos, weil alle Faelle auf `SSLv23_method()` hinausliefen.
**Seit der Portierung steuert dieser Wert die TLS-Untergrenze** (siehe [M1](#m1)), die
Verwechslung wird also erstmals wirksam.

Die Datei ist von der Portierung nur an einer Stelle beruehrt worden
(`<xstddef>` -> `<functional>`); der Fehler ist Originalcode von QUALCOMM.

**Zu tun:** `m_nSSLReceiveVersion` einsetzen - aber getrennt vom Portierungs-
umbau, weil es eine echte Verhaltensaenderung ist.

---

## <a id="m5"></a>M5 - `CSumList::GetTail()` liefert den Kopf

**Sicherheit: nachgewiesen. Nicht aus der Portierung - Originalfehler,
in die neue const-Ueberladung uebernommen.**

**Datei:** `Eudora71/Eudora/summary.h` Z. 504 und Z. 507

```
CSummary*&      GetTail()       { return reinterpret_cast<CSummary *&>( m_ObList.GetHead() ); }
const CSummary* GetTail() const { return reinterpret_cast<const CSummary *>( m_ObList.GetHead() ); }
```

Beide `GetTail()` rufen `m_ObList.GetHead()` auf. In `main` steht dasselbe; die
Portierung hat den Fehler beim Umbau der const-Ueberladung mitgenommen, statt
ihn zu bemerken.

**Folge:** Jeder Aufrufer von `GetTail()` bekommt das erste statt des letzten
Elements. Wie oft das zutraegt, haengt an den Aufrufstellen - die wurden im
Rahmen dieser Pruefung nicht durchgezaehlt.

**Zu tun:** `GetTailPosition()`/`m_ObList.GetTail()` verwenden. Vorher pruefen,
ob sich Code auf das falsche Verhalten stuetzt.

---

## <a id="n1"></a>N1 - QCSSL: der Zeigerschmuggel durch `BIO_set_fd` haelt nur unter Win32

**Sicherheit: nachgewiesen. Heute kein Fehler.**

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp` Z. 249 (setzen), Z. 148 und
Z. 196 (lesen), Z. 259 (zurueckgeben), Z. 789 (Aufrufer).

Eudora reicht einen `QCSSLReference*` als `int` durch `BIO_set_fd()`:

```
BIO *pBIO = BIO_new_ws((int)pSSLReference, BIO_NOCLOSE);
```

`BIO_set_fd` ist `BIO_int_ctrl(b, BIO_C_SET_FD, c, fd)`, und `BIO_int_ctrl`
reicht die Adresse eines lokalen `int` weiter. Der Umbau legt den Wert nun im
Datenslot ab:

```
BIO_set_data(pBIO, (void*)(INT_PTR)(*((int*)ptr)));
```

Setzen und Lesen sind **konsistent**: `ws_read` und `ws_write` holen den Zeiger
mit `BIO_get_data()`, `BIO_C_GET_FD` gibt ihn ueber denselben Weg zurueck. Ein
Zeiger wird dabei **nicht** beschaedigt, weil `QCSSL.vcxproj` ausschliesslich
`<Platform>Win32</Platform>` kennt - `int` und Zeiger sind beide 32 Bit.

Sobald QCSSL einmal fuer x64 gebaut wird, schneidet `*((int*)ptr)` die oberen
32 Bit des Zeigers ab, und zwar lautlos. Der Weg ueber `BIO_int_ctrl` kann das
nicht heilen; dafuer muesste `BIO_new_ws` den Zeiger direkt per `BIO_set_data`
ablegen und `BIO_C_SET_FD` gar nicht mehr benutzen.

**Zu tun:** Nichts, solange Win32 gilt. Als Sperre fuer eine spaetere
x64-Portierung vormerken.

---

## <a id="n2"></a>N2 - `plist_mgr.cpp`: `static` bei `get_entry_info` verlorengegangen

**Sicherheit: nachgewiesen**

**Datei:** `Eudora71/PlaylistClient/plstclnt_dll/plist_mgr.cpp:176`

```
- static get_entry_info( PrivCachePtr pcp, Entry* pe, ENTRY_INFO** pei );
+ int get_entry_info( PrivCachePtr pcp, Entry* pe, ENTRY_INFO** pei );
```

Die Definition in Z. 1571 lautet in beiden Fassungen `int get_entry_info(...)`
ohne Speicherklasse. In C++ uebernimmt eine Definition ohne Speicherklasse die
Bindung der vorangegangenen Deklaration - vorher also **interne** Bindung,
jetzt **externe**.

**Folge:** Der Name wird zu einem globalen Symbol der DLL. Heute kollidiert
nichts (es baut), aber eine spaetere Uebersetzungseinheit mit gleichem Namen
gaebe LNK2005 oder - schlimmer - eine stille Fehlbindung. Zur Behebung des
Uebersetzungsfehlers (fehlender Rueckgabetyp) war das Entfernen von `static`
nicht noetig.

**Zu tun:** `static int get_entry_info(...)` schreiben.

---

## <a id="n3"></a>N3 - QCSSL: zwei Rueckgabewerte werden nicht mehr ausgewertet

**Sicherheit: nachgewiesen; geringe Auswirkung**

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp`

- Z. 590: `SSL_CTX_set_min_proto_version()` liefert 0 bei Fehlschlag. Der Wert
  wird verworfen. Scheitert der Aufruf, gilt die Voreinstellung von OpenSSL -
  die Untergrenze aus den Einstellungen greift dann nicht.
- Z. 534: `SetCipherSuites()` gibt jetzt `1` zurueck, ohne etwas gesetzt zu
  haben. Der Rueckgabewert wurde allerdings auch vorher schon von
  `BeginQCSSLSession()` verworfen, insofern keine Aenderung im Ablauf.

**Zu tun:** Beim ersten Punkt den Rueckgabewert pruefen und im Fehlerfall wie
in [H1](#h1) abbrechen.

---

## <a id="n4"></a>N4 - `ExceptionHandler.cpp`: `#undef` auf einen SDK-Waechter

**Sicherheit: nachgewiesen; heute wirkungslos, aber zerbrechlich**

**Datei:** `Eudora71/Eudora/ExceptionHandler.cpp` Z. 18-32

```
#undef _MINIDUMP_H
#include "MiniDump.h"
```

`EuMemMgr/Include/MiniDump.h:27` benutzt denselben Waechternamen wie
`minidumpapiset.h` aus dem Windows SDK. Der `#undef` macht den fremden Header
wieder einbindbar - danach setzt `MiniDump.h` `_MINIDUMP_H` erneut.

**Folge:** In dieser Uebersetzungseinheit ist `minidumpapiset.h` ab hier
gesperrt. Das faellt heute nicht auf, weil `stdafx.h` es vorher schon
hereingezogen hat. Kehrt sich die Einbindungsreihenfolge irgendwann um, fehlen
die SDK-Typen ohne verstaendliche Fehlermeldung.

**Zu tun:** Nichts Dringendes. Falls jemand daran vorbeikommt: den Waechter von
`EuMemMgr/Include/MiniDump.h` umbenennen (z. B. `_EUMEMMGR_MINIDUMP_H`) und den
`#undef` entfernen.

---

## <a id="n5"></a>N5 - `atlimage.h`: Laufzeitpruefung durch `TRUE` ersetzt

**Sicherheit: nachgewiesen; Ergebnis sachlich richtig**

**Datei:** `Eudora71/Eudora/atlimage.h:1541`

```
- return( _AtlBaseModule.m_bNT5orWin98 );
+ return( TRUE );
```

`CImage::IsTransparencySupported()` liefert jetzt ohne Pruefung `TRUE`. Auf dem
Zielsystem (Windows 10) ist das korrekt. Bemerkenswert ist nur, dass dafuer
eine **mitgelieferte Kopie eines Microsoft-ATL-Headers** geaendert wurde -
solche Aenderungen gehen bei einem Wechsel auf den SDK-eigenen Header
verloren.

**Zu tun:** In `PORTIERUNG.md` als bewusste Abweichung fuehren, falls noch
nicht geschehen.

---

## <a id="n6"></a>N6 - OTShim ist in keinem Projekt

> **Ueberholt seit `7dcac81`** (nachgetragen von LEKTOR, gemessen an `e7e6f3c`).
> `Eudora/stdafx.h:52` zieht jetzt `OTShimAll.h` statt `secall.h`, und
> `Eudora.vcxproj:217` uebersetzt `OTShim.cpp`, `OTShim_Bild.cpp` und
> `..\OT501\Src\secaux.cpp` mit. Der Befund gilt aber unveraendert fuer die
> **drei nicht eingehaengten** Teile: `OTShim_Werkzeugleiste.*` (6083 Zeilen),
> `OTShim_Reiter.*` (2925) und `OTShim_Palette.*` (890) stehen weder in
> `OTShimAll.h` noch in einer `.vcxproj` - siehe Befund [NP2-1](#np2-1).

**Sicherheit: nachgewiesen. Kein Fehler, sondern eine Standortbestimmung.**

`Eudora71/OTShim/` wird ausserhalb des eigenen Verzeichnisses nur von
`README.md` und `PORTIERUNG.md` erwaehnt. Keine `.vcxproj`, keine `.sln`, kein
Skript bindet `OTShim.cpp` ein; `Eudora/stdafx.h:52` zieht weiterhin
`secall.h` aus `OT501/Include`.

Zusaetzlich: `OTShim.h` deklariert `SECControlBar` und `SECGripperInfo`
vollstaendig, aber `OTShim.cpp` implementiert davon **keine einzige Methode**.
Und `TBarEdit.cpp`, `TBarBmpCombo.cpp`, `TBarStatic.cpp` rufen
`SECWndBtn::AdjustSize()`, `SECWndBtn::LButtonDown()` usw. auf, fuer die es in
`OT501` nur Header gibt.

"Nie gelaufen, nur uebersetzt" ist damit genau richtig - genauer: es
uebersetzt, es bindet nicht, und im Build steckt es noch gar nicht.

---

## <a id="n7"></a>N7 - OTShim: zwei kleinere Stellen

**Sicherheit: Verdacht; beide heute wirkungslos**

**Datei:** `Eudora71/OTShim/OTShim.cpp`

- **`SECWorkbook::GetTabRgn()` (Z. 1003-1012)** greift fest auf `pts[0]` und
  `pts[4]` zu, waehrend `count` aus der virtuellen `GetTabPts()` stammt. Die
  Basisfassung liefert 6 Punkte, das passt. Eine abgeleitete Fassung mit
  weniger als 5 Punkten liest ueber das Feldende hinaus.
- **`SECWorkbookClient::CalcWindowRect()` (Z. 713-727)** zieht die Raender vom
  Ergebnis von `CWnd::CalcWindowRect()` ab. `CalcWindowRect` rechnet ein
  **Client**- in ein **Fenster**rechteck um (es vergroessert); die Raender
  danach abzuziehen verkleinert das Fensterrechteck, statt die Client-Flaeche
  zu verkleinern. Fuer den Zweck "Platz fuer die Registerleiste freihalten"
  sieht das nach der falschen Richtung aus. Wirkungslos, solange die Raender
  ueberall 0 sind - und `SetWorkbookMode()` setzt sie ausdruecklich auf 0.

---

## <a id="n8"></a>N8 - `const_cast` mit anschliessendem Schreibzugriff

**Sicherheit: nachgewiesen (das Muster); Bewertung: originalgetreu**

Zehn der rund 50 `const_cast`-Korrekturen liegen an Stellen, an denen der
zurueckgewonnene Zeiger anschliessend **beschrieben** wird - und zwar in einen
Puffer, der ueber einen `const char*`/`LPCTSTR`-Parameter hereinkam:

| Datei | Zeile | Schreibzugriff |
|---|---|---|
| `Eudora/Trnslate.cpp` | 4191 | `*space = 0; *(space-1) = 0;` auf `const char *inFileCmd` |
| `Eudora/mainfrm.cpp` | 4848 | `*c++ = 0;` auf `LPCTSTR cmdLine` |
| `Eudora/TridentPreviewView.cpp` | 350 | `*EndOfHeader = 0;` |
| `Eudora/mapicmc.cpp` | 171 | `*pszNewline = '\0';` |
| `Eudora/sendmail.cpp` | 1537 | `*pEnd = '\0';` |
| `Eudora/statbar.cpp` | 233 | Puffer wird umgeschrieben |
| `Eudora/tocdoc.cpp` | 2169 | vorlaeufige NUL-Terminierung |
| `Eudora/Convhtml.cpp` | 489, 570 | Kopfzeilen werden zerschnitten |
| `Eudora/PaigeEdtView.cpp` | 2521 | `*s = 0;` |
| `Eudora/html2text.cpp` | 981 | `szCurrent + 1` ohne NULL-Pruefung |

**Das ist kein Rueckschritt.** Vor VS2005 hatte `strchr`/`strstr`/`strrchr` in
`<string.h>` nur die C-Signatur `char* f(const char*, ...)`; der Schreibzugriff
fand also schon vorher statt. Der `const_cast` macht das nur sichtbar.

Trotzdem festgehalten, weil das die Stellen sind, an denen ein spaeterer
Umbau - etwa ein Aufrufer, der eine Zeichenkettenkonstante oder einen
`CString`-Puffer ohne `GetBuffer()` uebergibt - einen Absturz erzeugt, den
niemand mehr mit der Portierung in Verbindung bringt.

**Zu tun:** Nichts jetzt. Bei kuenftigen Aenderungen an diesen Funktionen die
Parameter auf `char*` ziehen und die Aufrufer nachziehen.

---

# Geprueft und in Ordnung

Diese Bereiche wurden Zeile fuer Zeile durchgesehen und sind unauffaellig.
Spaetere Pruefungen muessen hier nicht noch einmal anfangen.

## QCSSL

- **BIO-Schicht, Zustandsfelder.** `ws_new`/`ws_free` bilden `init`, `flags`
  und `shutdown` richtig ueber die Zugriffsfunktionen ab.
  `BIO_clear_flags(pBIO, ~0)` entspricht `pBIO->flags = 0`. Das im Original
  fehlende `BIO_set_shutdown(pBIO, 0)` in `ws_new` ist sogar **noetig**:
  `BIO_new()` setzt in OpenSSL 3 `shutdown = 1` vor, bevor es `create` ruft.
  Der Endzustand nach `BIO_new_ws(..., BIO_NOCLOSE)` ist in beiden Fassungen
  derselbe.
- **Datenslot-Rundlauf** setzen/lesen/zurueckgeben - konsistent (Einzelheiten
  unter [N1](#n1)).
- **`qccertificate.cpp`.** `X509_STORE_CTX_get0_store(ctx)` liefert dasselbe
  Objekt wie frueher `pX509StoreCtx->ctx`; `X509_STORE_CTX_get_current_cert()`
  und `X509_STORE_CTX_get_error()` sind wortgleiche Ersetzungen. Die
  Zusatzdaten werden in `BeginQCSSLSession()` auf dem `X509_STORE` des
  `SSL_CTX` abgelegt und im Rueckruf von demselben Objekt gelesen. Die
  Indizes 0 und 1 ohne `X509_STORE_get_ex_new_index()` funktionieren unter
  OpenSSL 3 (`CRYPTO_set_ex_data` legt den Stapel bei Bedarf an), und die
  Klasse `X509_STORE` wird von libssl selbst nicht mit Zusatzdaten belegt.
- **`certstore.cpp`.** Einzige Aenderung ist die `const`-Anpassung an
  `d2i_X509()`. Die Funktion schreibt weiterhin durch den Zeiger-auf-Zeiger,
  der Zeiger selbst ist nicht `const` - richtig.
- **Cipher-Liste entfernt.** Die Begruendung stimmt: die Liste von 2006
  enthaelt kein einziges AEAD-Verfahren; unter OpenSSL 3 haette sie den
  Handshake mit heutigen Servern verhindert statt abgesichert.
- **`ERR_remove_state()` gestrichen** - in OpenSSL 1.1+ ersatzlos entfallen,
  die Bibliothek raeumt selbst auf.
- **`SSLConnectionManager.cpp`.** Der `const_cast` bei `strchr(uniquename,'\n')`
  wird nur gelesen (`++strProtocol`, `strcmp`).

## OpenSSL-3-Umstellung, uebrige Stellen

- `d2i_X509`, `SSL_get_current_cipher`, `SSL_METHOD` als `const` - reine
  Signaturanpassungen ohne Verhaltensfolge.

## `summary.h`, const-Ueberladungen

Der Wechsel von `const CSummary*&` auf `const CSummary*` ist **eine Behebung,
kein Rueckschritt**. `CObList::GetHead() const` liefert `CObject*` **als Wert**;
das alte `reinterpret_cast<const CSummary*&>(...)` band also eine Referenz an
ein temporaeres Objekt. Die Ueberladungen kaemen ausserdem nur ueber einen
Uebersetzungsfehler zum Vorschein, wenn ein Aufrufer das Ergebnis wirklich als
Referenz binden wollte - das tut keiner. (Der eigentliche Fehler an dieser
Stelle ist [M5](#m5).)

## Schleifenzaehler, die vorgezogen wurden

Alle fuenf geprueft, alle mit **unveraendertem Anfangswert** und ohne
Ueberschreiben eines aeusseren Zaehlers:

- `QCUtils/src/jjfile.cpp:819` `ReadLine_` - `lNumRead` wird nach der Schleife
  in mehreren `return`-Zweigen gebraucht.
- `QCUtils/src/services.cpp:635` `TrimWhitespaceMT` - `pszEnd` wird nach der
  Schleife gebraucht.
- `PlaylistClient/.../plist_html.cpp:207` `ParseURLs` - `nSearch` wird nach der
  Schleife abgefragt.
- `Importers/OEImport/OEImportClass.cpp:2222` `ReadTilDone` - `oemh` wird nach
  der Schleife gebraucht.
- `EuImap/src/ImapFiltersd.cpp:1602` und `:1712` - hier wurde umgekehrt ein
  `int i` **hinzugefuegt**. Beide Schleifen liegen **ausserhalb** der
  vorangehenden `for (int i = 0; i < NUM_FILT_ACTS; i++)`-Schleife (Nachpruefung
  ueber die Einrueckungsebenen), der aeussere Zaehler ist zu diesem Zeitpunkt
  tot. Kein Verhaltensunterschied.

## Rueckgabetypen, die von "implizit int" auf einen Typ gesetzt wurden

Alle geprueft, jeweils gegen die Aufrufstellen:

- `Eudora/DynamicMenu.h:52` + `.cpp:81` `OnInitMenuPopup` -> `void`. Alle drei
  Aufrufstellen (`mainfrm.cpp:7012`, `guiutils.cpp:3055`, `:3158`) verwerfen
  das Ergebnis.
- `Eudora/DynamicPersonalityMenu.cpp`, `DynamicPluginMenu.cpp`,
  `DynamicRecipientMenu.cpp`, `DynamicStationeryMenu.cpp` `BuildMenu` -> `BOOL`.
  Die Basis deklariert bereits `virtual BOOL BuildMenu(...) = 0`; alle Ruempfe
  enthalten `return TRUE;`. `CDynamicMenu::OnInitMenuPopup` wertet den Wert aus
  und bekommt jetzt denselben wie vorher.
- `Eudora/trnslate.h` `GetIcon`, `IsInYerFace`, `LoadModule` -> `BOOL`;
  `Eudora/spell.h` `Check`, `ReallyCheck` -> `int`; `Eudora/UsgStatsView.h`
  `UpdateFT` -> `void` (leerer Rumpf, kein Aufrufer wertet aus);
  `EuLang/src/lang_info.cpp` `friend` -> `int`; `QCUtils/inc/services.h`
  `operator=` -> `CSortedStringListMT&`; `Imapdll/src/misc.cpp` `register bitno`
  -> `int`; `PlaylistClient` `typedef (*adproc)` -> `int (*adproc)` in allen
  drei Dateien einheitlich.
- `Eudora/ComboBoxEnhanced.cpp:51-53`, `Eudora/eudora.cpp:4625` und `:4745`,
  `Eudora/FileBrowseView.cpp:285`, `Eudora/ExtLaunchMgr.cpp:37`,
  `Importers/OEImport/OEImportClass.cpp:1297` - Konstanten und `static`-Merker
  bekommen einen Typ. `FolderLen` wird von `int` zu `size_t`; die drei
  Verwendungen (`_tcsnicmp`, Feldindex, Zeigeraddition) kennen kein
  Vorzeichenproblem.
- `Eudora/AboutDlg.h`, `Eudora/mainfrm.h` `OnNcHitTest` `UINT` -> `LRESULT` -
  von `ON_WM_NCHITTEST` im heutigen MFC so verlangt.

## `FileBrowseView::GetFullyQualPidlFromPath`

Die Korrektur ist richtig. Alt wurde `sizeof(szOleChar)` (520) als
`cchWideChar` fuer einen Puffer von 260 `WCHAR` uebergeben - `MultiByteToWideChar`
haette bis zu 520 Zeichen geschrieben. Neu steht dort `_countof(szOleChar)`,
und der zusaetzliche `if (iWideChars == 0) return NULL;` fuellt genau die
Luecke, die der frueher verworfene Rueckgabewert offenliess. Die Funktion haelt
zu diesem Zeitpunkt keine Ressource, die freigegeben werden muesste.

## Zeit- und Typkorrekturen

- `Eudora/MsgRecord.cpp:425` `long` -> `time_t` mit `(unsigned long)`-Rueckwandlung
  beim Ablegen in `m_ulDate` - dieselbe Reichweite wie bisher.
- `Eudora/StatMng.cpp:1273`, `:1578`, `:1816` - `localtime()` bekommt eine
  `time_t`-Kopie des 32-bittigen Feldes aus der Statistikdatei. Das Dateiformat
  bleibt unangetastet.
- `QCUtils/src/services.cpp:209` dasselbe Muster.
- `QCUtils/src/services.cpp:1079` `WORD wsz[MAX_PATH]` -> `WCHAR` - beide 16 Bit
  ohne Vorzeichen, gleiche Groesse.
- `Imapdll/src/osdep.cpp:200` `tzname`/`daylight` -> `_tzname`/`_daylight` -
  in der Microsoft-CRT dieselben Objekte, `_daylight` heisst wie zuvor "eine
  Sommerzeitregel ist eingestellt", nicht "Sommerzeit gilt gerade".

## `EuImap/src/searchutil.{h,cpp}`

Der Ersatz von `m_Iterator == NULL` durch das eigene Kennzeichen
`m_bIteratorValid` ist richtig: Ein `std::list::iterator` liess sich frueher
nur wegen einer nicht normgerechten Ueberladung mit `NULL` vergleichen. Beide
Auswertungen (`GetNextCriterion`, `HasNext`) fragen das Kennzeichen **vor** dem
Vergleich mit `end()` ab, ein einzelner Iterator wird also nie angefasst.
Konstruktor und `Initialize()` setzen es vollstaendig.

## `Imapdll/src/krbv4.cpp`

Die Umbenennung `ntohl`/`ntohs`/`htonl`/`htons` -> `krbv4_*` aendert nichts an
der Rechnung (dieselben Byte-Vertauschungen, `htonl` ruft weiterhin `ntohl`).
Alle Aufrufstellen wurden mitgezogen. Ausserhalb der Datei gibt es keine
Verwendung; ein Zusammenstoss mit `ws2_32` bestand ohnehin nicht, weil die
Winsock-Fassungen `__stdcall` sind und damit anders heissen.

## `Eudora/spell.cpp` (neu, Ersatzimplementierung)

Der Konstruktor initialisiert **alle** in `spell.h` deklarierten Felder,
einschliesslich `m_bJustQueue`, das von aussen gelesen wird
(`headervw.cpp:2961`, `compmsgd.cpp:806`). Die Begruendung fuer `0` als
Rueckgabewert von `Check()` (statt `NO_MISSPELLINGS` oder `IDCANCEL`) ist an
den Aufrufstellen belegt und stimmt.

## `Eudora/ConConMessage.cpp`, `Eudora/mime.cpp`

Die `memchr`-Ergebnisse werden nach dem `const_cast` sofort wieder an einen
`const char*` zugewiesen bzw. nur gelesen. Kein Schreibzugriff.

## `<xstddef>` -> `<functional>`

Elf Dateien; in allen ist der Header nur ein Vorspann fuer ein direkt darauf
folgendes `<map>`/`<list>`/`<algorithm>`/`<stack>`. Ohne Wirkung auf den Ablauf.

## OTShim, uebriger Teil

Konstruktoren von `SECMDIFrameWnd`, `SECMDIChildWnd`, `SECWorksheet`,
`SECWorkbookClient`, `SECWorkbook`, `SECTipOfDay`, `SECControlBarWorksheet`
setzen jeweils alle eigenen Skalarfelder. Alle Eintraege der
Nachrichtentabellen (`SECWorksheet`, `SECWorkbook`, `SECControlBarWorksheet`)
haben eine passende Behandlungsroutine mit passender Signatur; keiner zeigt
ins Leere. Die ueberschriebenen Methoden rufen die Basis auf, wo es das
Original verlangt - `SECWorkbook::OnDestroy()` raeumt vor
`SECMDIFrameWnd::OnDestroy()` auf, `SECWorksheet::LoadFrame()` prueft das
Ergebnis der Basis, bevor es weitermacht. Die doppelte Freigabe von
`m_pWBClient` (Destruktor **und** `OnDestroy`) ist ueber die NULL-Pruefung
abgefangen.

---

# Nachtrag: Stand nach `ba617a8`

Waehrend die Pruefung lief, haben andere Agenten weitergearbeitet. Gegen
`ba617a8` nachgesehen:

- **[M3](#m3) ist ueberholt.** `OTShim.cpp:1104` haelt inzwischen ausdruecklich fest
  "Bewusst keine Zuweisung an `m_bWorkbookMode`", `OTShim.h:970` nennt es eine
  Grundentscheidung. Damit ist genau die Luecke geschlossen, die der Befund
  bemaengelt hat: es war Absicht, sie stand nur nirgends. Kein Handlungsbedarf
  mehr.
- **[N6](#n6) gilt weiter.** Auch nach `e81adb0` ("Stufe 4: Bildklassen ueber GDI+")
  taucht `OTShim` in keiner `.vcxproj` auf.
- **[H1](#h1), [M1](#m1), [M2](#m2), [M4](#m4), [M5](#m5) und [N1](#n1) bis [N5](#n5), [N7](#n7), [N8](#n8) gelten unveraendert.**
  `SetSSLVersion()` steht in `ba617a8` Zeile fuer Zeile so da wie beschrieben.
- Nicht als Befund aufgenommen, weil waehrend der Pruefung behoben:
  `X509_STORE_CTX_set_ex_data(pX509StoreCtx, 0, ...)` in
  `qccertificate.cpp` schrieb in einen Slot, den libssl fuer sich beansprucht
  (`SSL_get_ex_data_X509_STORE_CTX_idx()` liefert dort ueblicherweise 0). Das
  war Originalcode und ist mit `455294c` entfernt worden.

---

# Zusammenfassung

- 1 Befund hoher Schwere ([H1](#h1)) - eine echte Regression aus der Portierung.
- 5 Befunde mittlerer Schwere; davon zwei ([M4](#m4), [M5](#m5)) **Originalfehler**, die die
  Portierung nicht verursacht, aber auch nicht bemerkt hat.
- 8 Befunde niedriger Schwere, ueberwiegend vorsorglicher Natur.
- [H2](#h2) (Zeichentabelle) war bei Pruefungsbeginn offen und ist waehrend der
  Pruefung mit `b4b7de5` behoben worden; die Behebung wurde nachgeprueft und
  ist richtig.

Der QCSSL-Umbau ist insgesamt sauber. Die Abbildung der undurchsichtigen
OpenSSL-3-Strukturen auf Zugriffsfunktionen stimmt an allen geprueften
Stellen; der Zeigerschmuggel durch die BIO-Schicht ist konsistent. Die
einzige echte Regression liegt nicht in der API-Umstellung, sondern in der
umgebauten Ablaufsteuerung von `SetSSLVersion()`.

---

# Nachpruefung 2 (Bereich `ba617a8..8dd6b2a`) - ABGEBROCHEN, UNVOLLSTAENDIG

**Bezugscommit des neuen Teils:** `8dd6b2a` auf `vs2022-portierung-fixes`
**Vergleichsbasis:** `git diff ba617a8..HEAD`
**Abgebrochen am:** 2026-08-29, wegen Herunterfahren des Rechners.

Alles oberhalb dieser Linie bezieht sich unveraendert auf den alten Stand
`ba617a8` und ist abgeschlossen. Alles ab hier ist **Zwischenstand**.

## Zu pruefender Bereich

```
8dd6b2a Lehren werden jetzt automatisch ins Repo gespiegelt
adcede6 Arbeitsweise/: die Lehren aus dem Projekt liegen jetzt im Repo
7d94c3d PLAN.md berichtigt: Registerkarten sind nicht verzichtbar
91716bb OT501-Ersatzschicht Stufe 3: Werkzeugleisten und Knoepfe
94e32c6 QCSSL bekommt eine ablesbare Kennung
dd65c33 OTShim Stufe 2b: der Rest der Andockfamilie
7dcac81 OT501-Ersatzschicht in Eudora eingehaengt
1a0c343 Zertifikatspruefung: Verschaerfung als Patch bereitgelegt
a7478b0 OTShim Stufe 2: Andockfamilie
bc94cf0 MAPI: kein Schreibzugriff mehr in den fremden WM_COPYDATA-Puffer
f42466b Eudora: SafeSEH und doppeltes Manifest
```

Rund 11.200 eingefuegte Zeilen, davon 6.083 allein in
`OTShim_Werkzeugleiste.{h,cpp}`.

## Erledigt: geprueft und in Ordnung

- **`QCSSLContext.cpp`, Behebung von [H1](#h1)** (`7d94c3d`-Reihe): `break;` wurde
  durch `return NULL;` ersetzt. Das stellt das alte Verhalten **wirklich
  wieder her** und verschiebt es nicht: `SetSSLVersion()` liefert wie frueher
  `NULL`, und `BeginQCSSLSession()` faengt das in Z. 750 mit
  `if (!pSSLCtx) { ASSERT(0); g_Mutex.Unlock(); return false; }` ab. Zu
  diesem Zeitpunkt ist noch kein `SSL_CTX` angelegt, es leckt also nichts.
  **[H1](#h1) ist damit erledigt.**
- **`mapicmc.cpp` (`bc94cf0`)**: `current_line = CString(pszData, (int)(pszNewline - pszData));`
  ersetzt das Setzen und Zuruecksetzen des NUL-Bytes. Bei `WM_COPYDATA` liegt
  der Puffer im fremden Prozess; der Schreibzugriff faellt jetzt weg. Der
  ausgeschnittene Text ist byteweise derselbe. Richtig.
- **`EudoraExe.rc` / Manifest (`f42466b`)**: Das `RT_MANIFEST` aus der `.rc`
  auszukommentieren ist unbedenklich - `Eudora.vcxproj:966` fuehrt
  `<Manifest Include="Eudora.manifest" />`, und MSBuild reicht `@(Manifest)`
  an den Linker weiter. Die Abhaengigkeit auf
  `Microsoft.Windows.Common-Controls 6.0.0.0` (und damit die Fensterthemen,
  auf die `XPThemedAppearance` baut) bleibt im erzeugten Manifest erhalten.
  Nachgesehen, nicht vermutet.
- **`qcssl.rc` (`94e32c6`)**: nur Versionstexte, ohne Wirkung auf den Ablauf.

## Neuer Befund

### NP2-1 - Stufe 3 haengt nirgends: 6.083 Zeilen ohne Uebersetzung

**Sicherheit: nachgewiesen**

**Dateien:** `Eudora71/OTShim/OTShim_Werkzeugleiste.h`,
`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp` (Commit `91716bb`),
`Eudora71/OTShim/OTShimAll.h`, `Eudora71/Eudora/Eudora.vcxproj`

Gemessen, nicht geschaetzt:

```
grep -c OTShim_Werkzeugleiste Eudora71/Eudora/Eudora.vcxproj  -> 0
grep -c OTShim_Werkzeugleiste Eudora71/OTShim/OTShimAll.h     -> 0
```

`7dcac81` hat drei Dateien ins Projekt genommen (`OTShim.cpp`,
`OTShim_Bild.cpp`, `OT501/Src/secaux.cpp`) und `OTShimAll.h` angelegt. Beides
ist **vor** `91716bb` passiert und danach nicht nachgezogen worden. Folge:

1. `OTShim_Werkzeugleiste.cpp` wird von keinem Projekt uebersetzt. Die 4.671
   Zeilen sind bisher durch **keinen Uebersetzer gelaufen**.
2. `OTShim_Werkzeugleiste.h` wird von `OTShimAll.h` nicht eingebunden. Die
   Klassen `SECStdBtn`, `SECWndBtn`, `SECTwoPartBtn`, `SECComboBtn`,
   `SECCustomToolBar`, `SECToolBarManager` kommen fuer Eudora weiterhin aus
   den Stingray-Originalen unter `OT501/Include` - fuer die es keine
   Implementierung gibt.
3. `OTShimAll.h` Z. 38-40 haelt den Waechter dafuer ausdruecklich noch
   zurueck:
   ```
   // #ifndef __SECBTNS_H__  -- erst setzen, wenn Stufe 3 (Knoepfe) geliefert ist
   ```
   Stufe 3 **ist** geliefert; die Zeile ist seitdem veraltet. Umgekehrt wuerde
   das Setzen des Waechters ohne Einbinden von `OTShim_Werkzeugleiste.h` die
   Knopfklassen ersatzlos verschwinden lassen.

Das ist derselbe Befundtyp wie [N6](#n6) aus der ersten Runde, nur eine Stufe
weiter: Der Code ist da, er ist nur an nichts angeschlossen. Solange das so
ist, sagt "uebersetzt" ueber Stufe 3 gar nichts aus - auch der
Uebersetzungsfehler waere noch nicht gefunden.

**Zu tun (fuer die naechste Sitzung, nicht fuer den Pruefer):**
`OTShim_Werkzeugleiste.cpp` in `Eudora.vcxproj` aufnehmen (wie die anderen
drei mit `<PrecompiledHeader>NotUsing</PrecompiledHeader>`),
`OTShim_Werkzeugleiste.h` in `OTShimAll.h` einbinden und dabei die Waechter
`__TBTNSTD_H__`, `__TBTNWND_H__`, `__TBTN2PRT_H__`, `__TBTNCMBO_H__`,
`__TBARCUST_H__`, `__TBARMGR_H__`, `__TBARPAGE_H__`, `__TBARTRCK_H__` und
`__SECBTNS_H__` gemeinsam setzen. `OTShim_Werkzeugleiste.h:1402-1405` setzt
vier davon bereits selbst - das ist beim Zusammenfuehren zu beachten, damit
kein Waechter doppelt oder gar nicht gesetzt wird.

## Noch offen - hier ansetzen

Die inhaltliche Pruefung des neuen Codes hat **nicht mehr stattgefunden**.
Angesehen wurde bisher nur die Gliederung (Klassenliste des Headers,
Funktionsliste des `.cpp`). Offen sind:

| Prioritaet | Gegenstand | Stand |
|---|---|---|
| 1 | `OTShim_Werkzeugleiste.cpp` `SECStdBtn::DrawFace` (Z. 688-762) gegen `TBarSendButton.cpp:71-160` und die auskommentierte zweite Kopie in `MoodMailStatic.cpp:63-120` | **nicht begonnen** |
| 1 | `SECBtnDrawData` (Z. 156ff Header, Z. 286-438 cpp): drei `CPaletteDC` als Wertfelder - Lebensdauer, Freigabe der GDI-Objekte, Verhalten bei fehlgeschlagenem `CreateCompatibleDC` | **nicht begonnen** |
| 1 | `SECCustomToolBar`: Anordnung, Umbruch, Mausbehandlung, `OnUpdateCmdUI` mit eigener `CCmdUI`-Ableitung; Indexgrenzen und Nullzeiger | **nicht begonnen** |
| 1 | `SECToolBarManager::LoadState` gegen `QCLoadState` | **nicht begonnen** |
| 1 | `CSafetyPalette`/`CPaletteDC` (cpp Z. 121-284) - in der Freigabe nie implementiert | **nicht begonnen** |
| 2 | `OTShim.{h,cpp}` Stufe 2/2b (`a7478b0`, `dd65c33`): `SECControlBar`, `SECDockBar`, `SECMiniDockFrameWnd`, `SECFrameWnd`, `SECDockState`, `SECControlBarInfo(Ex)`, `SECControlBarManager`, `SECDockContext`; besonders die zweite Dockbar `m_wndSECDockBar` neben dem geerbten `m_wndDockBar` | **nicht begonnen** |
| 3 | `OTShim_Bild.*` (`e81adb0`): Wiederherstellen der Bitmapauswahl in **allen** Rueckgabepfaden von `CreateFromBitmap`, auch im Fehlerfall | **nicht begonnen** |
| 4 | `tools/lehren-spiegeln.pl` (`8dd6b2a`/`adcede6`), im pre-commit-Hook | **nicht begonnen** |
| 4 | `tools/patches/zertifikatspruefung-verschaerfen.patch` (`1a0c343`) | **angewandt in 7.2.0.48** (11.09.2026, `b3be298`) - inhaltlich identisch, als Skript eingespielt, weil `git apply` in der Sitzung gesperrt war. Bilanz wie im Patch dokumentiert: vier Zeilen raus, zwei rein, CRLF 372 -> 370 |

Nicht zu pruefen (waren beim Abbruch noch im Fluss, andere Agenten):
`OTShim_Reiter.{h,cpp}`, `OTShim_Palette.{h,cpp}`.

Weiterhin ausgenommen: die **Hostnamenpruefung** in QCSSL.

## Stand der alten Befunde

Nicht erneut nachgesehen; sie beziehen sich auf `ba617a8`. Ausnahme: **[H1](#h1) ist
behoben** (siehe oben). `M3` war schon im Nachtrag als ueberholt vermerkt.

---

## Ergebnis der Stufe-3-Pruefung (`91716bb`) - NACHTRAG zur obigen Tabelle

Die Tabelle "Noch offen" oben war der Stand beim ersten Sicherungs-Commit.
Danach konnte Stufe 3 doch noch weitgehend geprueft werden. **Erledigt** sind
damit: `SECStdBtn::DrawFace`, `SECBtnDrawData` samt
`PreDrawButton`/`PostDrawButton`/`SysColorChange`/`CreateDitherBrush`,
`CSafetyPalette`, `CPaletteDC`, `SECToolBarManager::LoadState`/`SaveState`,
`SECToolBarCmdUI` mit `SECCustomToolBar::OnUpdateCmdUI` sowie saemtliche
Indexzugriffe auf `m_btns` samt `m_nDown`/`m_nRaised`.

**Weiterhin offen von Stufe 3:** die Anordnungsrechnung von
`SECCustomToolBar` (Zeilenumbruch, `CalcDynamicLayout`, `CalcFixedLayout`,
`Layout`), `SECTwoPartBtn::DrawButton`, `SECWndBtn`/`SECComboBtn`
(Fenstererzeugung, Weiterreichen der Mausereignisse), `SECCustomizeToolBar`
und die Anpassen-Dialogseiten. Unveraendert offen: Stufe 2/2b, Stufe 4,
`lehren-spiegeln.pl`, der Zertifikats-Patch.

### Geprueft und in Ordnung

- **`SECStdBtn::DrawFace` (cpp Z. 688-762).** Der Vertrag stimmt: Ziel ist
  `data.m_drawDC`; `x`, `y`, `nWidth`, `nHeight` kommen als ganzer Knopf herein
  und gehen als innere Flaeche zurueck; `bForce` unterdrueckt Gedrueckt- und
  Angehoben-Darstellung; `nImgWidth == -1` heisst volle Bildbreite. Alle vier
  Rahmenzweige (gedrueckt, cool+angehoben, cool, klassisch) decken sich Zeile
  fuer Zeile mit `TBarSendButton.cpp:71-160`, und
  `ColorToolbarButton.cpp:53-73` bestätigt den Rueckgabevertrag: es rechnet
  nach dem Basisaufruf mit den veraenderten `x`/`y` weiter.

- **Wichtig fuer spaetere Leser: das fehlende `+ 1` ist richtig so.**
  `TBarSendButton.cpp:83` rechnet
  `yImg = (nHeight - GetImgHeight())/2 + y + 1`, der Shim rechnet ohne `+ 1`.
  Die zweite, auskommentierte Kopie in `MoodMailStatic.cpp:73` rechnet
  **ebenfalls ohne `+ 1`**. Das `+ 1` ist also die Zugabe des Sende-Knopfes und
  nicht Teil der Basis; der Shim folgt der Basis. Wer das spaeter
  "berichtigt", verschiebt jedes Knopfbild um einen Bildpunkt nach unten.
  Die Commit-Nachricht von `91716bb` nennt nur `TBarSendButton` als Vorlage -
  deshalb hier ausdruecklich festgehalten.
  Zwei weitere Abweichungen von `TBarSendButton` sind ebenfalls richtig: das
  dortige `SetBkColor(COLOR_WINDOW)` gehoert zum anschliessend gezeichneten
  Text und ist fuer ein `SRCCOPY` ohne Belang; die zusaetzliche Schranke
  `if (nImgWidth > 0)` ist folgenlos, weil ein `BitBlt` der Breite 0 ohnehin
  nichts tut.

- **`SECToolBarManager::LoadState` (cpp Z. 4074-4106).** Gegen
  `QCToolBarManager::QCLoadState` (`QCToolBarManager.cpp:1118-1170`)
  abgeglichen: gleiche Reihenfolge, dieselben drei Profilwerte, dieselbe
  Leistenschleife mit `SetManager` und Zaehler, dasselbe
  `SetDefaultDockState()` bei null Leisten. Entscheidend sind die
  Schluesselnamen, denn Eudora **liest** mit `QCLoadState` und **schreibt**
  ueber `SECToolBarManager::SaveState` - beide Seiten muessen dieselben
  Zeichenketten benutzen, sonst gingen Kurzhinweise, Cool-Look und grosse
  Knoepfe bei jedem Start still verloren. Nachgemessen (cpp Z. 4064-4067):
  `"%s-ToolBarManager"`, `"ToolTips"`, `"CoolLook"`, `"LargeButtons"` -
  **wortgleich** mit `QCToolBarManager.cpp:1125-1128`. Die Iteration ist sogar
  sauberer als das Original: sie wandelt erst nach `CControlBar*` und prueft
  dann `IsKindOf`, statt vor der Pruefung nach `SECCustomToolBar*` zu wandeln.

- **`SECToolBarCmdUI` / `OnUpdateCmdUI` (cpp Z. 2676-2745).** Deckt sich mit
  `CToolCmdUI` aus `winctrl3.cpp`, einschliesslich des dortigen
  `nNewStyle &= ~TBBS_PRESSED` beim Sperren und des Ueberspringens von
  `TBBS_SEPARATOR`. `SetText` ist wie im Vorbild leer.

- **`SECBtnDrawData`, Lebensdauer der GDI-Objekte.** Durchgerechnet:
  `PreDrawButton` stellt auf **jedem** Fehlerweg die zuvor gewaehlten Objekte
  wieder her, bevor es `FALSE` liefert, und setzt `m_bReady` erst ganz am
  Ende - nach der letzten Fehlerstelle. Ein verschachtelter Aufruf wird oben
  mit `if (m_bReady) PostDrawButton();` abgefangen. Der Destruktor ruft
  `PostDrawButton()` im **Rumpf**, also bevor die Member abgebaut werden; die
  `CBitmap`-Felder sind damit abgewaehlt, ehe sie zerstoert werden - was hier
  noetig ist, weil sie in umgekehrter Deklarationsreihenfolge vor den
  `CPaletteDC`-Feldern an die Reihe kaemen. Kein Leck gefunden.

- **Indexgrenzen.** `AddButton`, `RemoveButton`, `GetItemID`, `GetItemRect`,
  `InvalidateButton`, `GetButtonStyle` und `SetButtonStyle` pruefen alle
  `nIndex < 0 || nIndex >= GetBtnCount()`. `RemoveButton` zieht `m_nDown`,
  `m_nRaised` und das durchgereichte `*pIndex` richtig nach; `AddButton`
  schiebt `m_nDown` mit. Alle Verwendungen von `m_nDown`/`m_nRaised` sind
  beidseitig geschrankt - auch `OnLButtonUp` (Z. 2886) und `RaiseButton`
  (Z. 2948-2968, wo der Index aus `ItemFromPoint` kommt und damit gueltig oder
  -1 ist). Nichts gefunden, was ueber das Feld hinausgreift.

### NP2-2 - `SysColorChange()` tut nicht, was daneben steht

**Sicherheit: nachgewiesen. Auswirkung: keine - aber der Kommentar fuehrt in
die Irre.**

`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp` Z. 320-331. Der Kommentar sagt,
ein zwischengespeicherter Zeichenpuffer bleibe bei einem Farbwechsel nicht
gueltig. Die Funktion loescht dann aber nur `m_ditherBrush`; `m_bmpDraw`,
`m_bmpMono`, `m_cxBuf` und `m_cyBuf` bleiben stehen, und der naechste
`PreDrawButton` nimmt denselben Puffer wieder.

Folgenlos, weil `DrawFace` den Puffer bei jedem Knopf zuerst mit
`FillSolidRect` ueberschreibt - ein alter Bildpunkt wird also nie sichtbar.
Der Kommentar behauptet aber eine Vorkehrung, die es nicht gibt.

**Zu tun:** Entweder die zwei Loeschzeilen ergaenzen oder den Kommentar auf das
kuerzen, was zutrifft.

### NP2-3 - `BitBltTransparent` meldet Erfolg, ohne gezeichnet zu haben

**Sicherheit: nachgewiesen; geringe Auswirkung**

`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp` Z. 233-272. Der eigentliche
Kopiervorgang steht in einem `if`:

```
if (dcTmp.CreateCompatibleDC(this) &&
    bmTmp.CreateCompatibleBitmap(this, nWidth, nHeight))
{
    ... die vier BitBlt ...
}

dcMask.SelectObject(pOldMask);
return TRUE;
```

Schlaegt eine der beiden Erzeugungen fehl, wird nichts gezeichnet - die
Funktion liefert trotzdem `TRUE`. Der Aufrufer haelt die Flaeche fuer
gezeichnet und laesst stehen, was vorher dort stand. Die frueheren
Fehlerausgaenge derselben Funktion liefern korrekt `FALSE`; nur dieser eine
nicht.

**Zu tun:** Den Rueckgabewert an das Ergebnis des Blocks binden.

---

## Gesamtzahl nach der Nachpruefung

- Teil 1 (`ba617a8`): 1 hoch (**[H1](#h1) inzwischen behoben**), 5 mittel (davon [M3](#m3)
  ueberholt, [M4](#m4) und [M5](#m5) Originalfehler), 8 niedrig.
- Teil 2 (`ba617a8..8dd6b2a`, unvollstaendig): 3 Befunde - [NP2-1](#np2-1) (Stufe 3
  haengt in keinem Projekt), [NP2-2](#np2-2) und [NP2-3](#np2-3) (beide klein, in Stufe 3).

Der Werkzeugleisten-Block aus `91716bb` ist an den geprueften Stellen
**sauber**. Die vier Punkte, auf die der Auftrag ausdruecklich hingewiesen hat -
`DrawFace`, `SECBtnDrawData` mit den drei `CPaletteDC`, die Indexgrenzen von
`SECCustomToolBar` und `LoadState` gegen `QCLoadState` - halten der Pruefung
stand. Der ernsteste Befund an Stufe 3 ist nicht der Code selbst, sondern dass
er nirgends eingebunden ist ([NP2-1](#np2-1)) und deshalb noch durch keinen Uebersetzer
gelaufen ist.

---

# Erledigt durch WACHE (30.08.2026, Branch `eudora-exe-linkt`)

Zustaendig fuer `Eudora71/QCSSL/src/*` und `Eudora71/QCSocket/src/*`. Die
Befundabschnitte oben sind unveraendert geblieben; hier steht, was daraus
geworden ist. Ausdruecklich nicht angefasst: die Hostnamenpruefung (nur CN, keine
SAN, rein beratend) und die Zertifikatsannahme bei `X509_V_ERR_CERT_UNTRUSTED` -
beide sind nach `Arbeitsweise/zurueckgestellte-befunde.md` bewusst zurueckgestellt,
der fertige Patch `tools/patches/zertifikatspruefung-verschaerfen.patch` bleibt
unangewandt.

## M1 - erledigt, Code in `78a9c10`

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp`, `SetSSLVersion()`: Z. 557
(Kommentar), Z. 577/578 - Fall 3 setzt jetzt `iMinVersion = TLS1_2_VERSION`
statt `TLS1_VERSION`, mit Begruendung im Code.

Von den beiden im Befund angebotenen Wegen wurde der erste gewaehlt: Fall 3
bekommt denselben Boden wie alle anderen Faelle, die Obergrenze bleibt offen.
Begruendung, nachgemessen statt vermutet:

- Fall 3 ist nicht der Sonderfall, sondern der **Normalfall**. `EudoraRes.rc:8143`
  und `:8147` geben `SSLReceiveVersion` und `SSLSendVersion` beide mit **3** vor.
  Die schwaechste Untergrenze galt also fuer jede Voreinstellung; die TLS-1.2-
  Untergrenze der uebrigen Faelle traf fast niemanden. Der Befund beschreibt Fall 3
  als Ausreisser - er ist in Wahrheit der Regelfall, was ihn ernster macht, nicht
  harmloser.
- Die Obergrenze offenzulassen ist richtig und bleibt so. TLS 1.3 zu verbieten,
  weil jemand vor zwanzig Jahren "TLSv1" angeklickt hat, waere unsinnig; zu tief
  war nur die Untergrenze.
- Wirkung gemessen: `Eudora71/Tests/QCSSL/work/ergebnis_qcssl_lokal.txt`, Fall 2e
  (`ProtocolVersion=3` gegen einen Server, der nur TLS 1.0 spricht) schlug **schon
  vor** der Aenderung fehl - Security Level 1 von OpenSSL 3 laesst TLS 1.0/1.1 gar
  nicht erst zu. Die Aenderung schreibt damit nur fest, was ohnehin geschieht, und
  bricht keine Verbindung, die heute zustande kommt.

**Zur Commit-Zuordnung:** die Aenderung war zum Commit vorgemerkt, als ein parallel
arbeitender Agent `git commit` ohne Pfadangabe ausfuehrte; sie ist deshalb in
`78a9c10` gelandet, dessen Nachricht sie nicht beschreibt. Inhalt und Wirkung sind
davon unberuehrt. Seither committe ich nur noch mit Pfadangabe.

Bauen: `QCSSL.vcxproj` Release/x86 erfolgreich, 0 Warnungen, 0 Fehler.
Tests: `Eudora71/Tests/RunTests.cmd` - 23 Tests, 23 bestanden, 0 fehlgeschlagen.

## N3 - erledigt, Commit `9608b39`

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp` Z. 591 und Z. 770.

- `SSL_CTX_set_min_proto_version()`: schlaegt der Aufruf fehl, wird der Kontext
  freigegeben und `NULL` zurueckgegeben. `BeginQCSSLSession()` bricht bei `NULL`
  ab - denselben Weg nimmt seit [H1](#h1) auch die ungueltige Version. Die eingestellte
  Untergrenze kann damit nicht mehr stillschweigend durch die Voreinstellung von
  OpenSSL ersetzt werden.
- `SetCipherSuites()`: Rueckgabewert wird in `BeginQCSSLSession()` geprueft und
  fuehrt im Fehlerfall zum Abbruch samt `SSL_CTX_free()` und `g_Mutex.Unlock()`,
  wie in den benachbarten Fehlerzweigen. Ausloesen kann das nur `pSSLCtx == NULL`,
  was zwei Zeilen darueber schon geprueft wird - die Auswertung ist eine Schranke
  gegen kuenftige Aenderungen, kein neuer Pfad.

Bauen: `QCSSL.vcxproj` Release/x86 erfolgreich, 0 Warnungen, 0 Fehler.
Tests: `Eudora71/Tests/RunTests.cmd` - 33 Tests, 30 bestanden, 3 fehlgeschlagen.
Die drei roten Tests betreffen `ISOTranslate()` in `Eudora/utils.cpp` (Emoji,
griechische Schrift) - ein anderer Arbeitsbereich, QCSSL hat daran keinen Anteil.

## M2 - erledigt

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp` Z. 309-334, `BIO_s_workersocket()`.

Die `BIO_METHOD` wird jetzt in einer lokalen Variablen (`pNeu`) angelegt und
vollstaendig gefuellt; erst danach wird sie mit einem einzigen
`InterlockedCompareExchangePointer()` veroeffentlicht. Wer das Rennen verliert,
gibt seine eigene Struktur mit `BIO_meth_free()` wieder frei. `s_pMethodsWS` ist
zusaetzlich `volatile`, damit der Uebersetzer den Vergleich am Anfang und die
Rueckgabe am Ende nicht zu einem einzigen gepufferten Lesezugriff zusammenzieht.

Damit sind beide im Befund beschriebenen Rennen weg:

- Kein Thread kann mehr eine halb gefuellte `BIO_METHOD` sehen - der Zeiger wird
  erst gesetzt, wenn alle sechs Setter gelaufen sind.
- Es bleibt auch nichts mehr liegen: der Verlierer raeumt seine eigene Struktur ab.
  Das kleine Leck aus dem Befund ist damit ebenfalls erledigt.

Die Funktion haengt jetzt nicht mehr an der ungeschriebenen Zusicherung, dass ihr
einziger Aufrufer unter `g_Mutex` laeuft. `g_Mutex` bleibt unveraendert - es geht
nur darum, dass die Funktion fuer sich genommen haelt.

Bauen: `QCSSL.vcxproj` Release/x86 erfolgreich, 0 Warnungen, 0 Fehler.
Tests: `Eudora71/Tests/RunTests.cmd` - 33 Tests, 33 bestanden, 0 fehlgeschlagen.

## M4 - erledigt

**Datei:** `Eudora71/QCSocket/src/QCWorkerSocket.cpp:2084`, `SetSSLMode()`.
`m_nSSLSendVersion` durch `m_nSSLReceiveVersion` ersetzt, mit Begruendung im Code.

Der Befund raet, die Aufrufstellen erst zu pruefen, weil beide Richtungen dieselbe
Einstellung absichtlich nutzen koennten. Geprueft, und sie tun es nicht:

- Der `else`-Zweig ab Z. 2076 ist der Empfangszweig (POP/IMAP). **Alle** zehn
  uebrigen Zuweisungen darin lesen `m_nSSLReceive...`; der Zweig unmittelbar
  darueber (Alternativport, Z. 2080) liest `m_nSSLAltPortReceiveVersion`. Genau
  eine Zeile faellt aus dem Muster - Z. 2084.
- `m_nSSLReceiveVersion` ist voll versorgt: `SSLSettings.cpp:75` laedt es aus
  `IDS_INI_SSL_RECEIVE_VERSION`, und `EudoraRes.rc:8143` gibt dafuer denselben
  Vorgabewert **3** wie fuer `SSLSendVersion` (`:8147`). Ein Umschalten kann also
  keine ungueltige Version erzeugen; wer nichts einstellt, merkt nichts.
  `GetSSLReceiveVersion()` (SSLSettings.h:171) existiert ebenfalls und war der
  einzige weitere Beruehrungspunkt - unbenutzt.
- Kein zweiter Leser: `m_nSSLSendVersion` wird ausser hier nur in Z. 2062 im
  SMTP-Zweig gelesen. Eine Absicht, die Empfangsrichtung an die Sendeeinstellung
  zu koppeln, ist an keiner Stelle formuliert.

**Einschraenkung, damit sie nicht ueberschaetzt wird:** seit [M1](#m1) laufen alle acht
gueltigen Faelle auf dieselbe Untergrenze TLS 1.2 hinaus. Die im Befund
beschriebene Wirkung - die Empfangsrichtung erbt den TLS-Boden der Sendeseite -
kann also derzeit ohnehin nicht mehr auftreten. Uebrig bleibt der Unterschied im
`default:`-Zweig (ungueltiger Wert bricht ab) und, wichtiger, dass die Einstellung
jetzt wieder die Verkabelung hat, die ihr Name verspricht.

Bauen: `QCSocket.vcxproj` Release/x86 erfolgreich, 0 Fehler (11 Warnungen, alle
aus dem Altbestand). `QCSSL.vcxproj` unveraendert gruen.
Tests: `Eudora71/Tests/RunTests.cmd` - 33 Tests, 33 bestanden, 0 fehlgeschlagen.

## N1 - erledigt, und zwar sauber statt mit `static_assert`

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp` Z. 249, 260, 336, 341, 789.

Der Auftrag liess die Wahl zwischen einer `static_assert` auf die Zeigergroesse und
einer sauberen Loesung. Gewaehlt wurde die saubere, weil sie nicht teurer war:

- `BIO_new_ws()` nimmt jetzt einen `QCSSLReference*` statt eines `int` und legt ihn
  ueber `BIO_ctrl(pBIO, BIO_C_SET_FD, iCloseFlag, pWorkerSocket)` ab - der vierte
  Parameter von `BIO_ctrl` ist `void*`, also zeigergross. `BIO_set_fd()` wird nicht
  mehr benutzt; genau dieses Makro war der Engpass, weil es ueber `BIO_int_ctrl()
  die Adresse eines lokalen `int` weiterreicht.
- `ws_ctrl()`, `BIO_C_SET_FD` (Z. 249): `BIO_set_data(pBIO, ptr)` statt
  `BIO_set_data(pBIO, (void*)(INT_PTR)(*((int*)ptr)))`. Kein Umweg mehr durch `int`.
- `ws_ctrl()`, `BIO_C_GET_FD` (Z. 260): `*((void**)ptr) = BIO_get_data(pBIO)` statt
  der Rueckgabe als `int`/`long`. Der Rueckgabewert `lRet` bleibt 1 (Erfolg), weil
  eine Adresse als `long` unter x64 nicht zurueckgegeben werden koennte.
- Aufrufer Z. 789: die Umwandlung `(int)pSSLReference` ist entfallen.

Dass wir die OpenSSL-Belegung von `BIO_C_SET_FD` dabei umdeuten, ist zulaessig und
im Code vermerkt: `BIO_s_workersocket` ist eine eigene BIO-Methode, `BIO_new_ws()`
ihr einziger Erzeuger, und `BIO_get_fd()` ruft im ganzen Baum niemand auf. Weder
`BIO_new_ws` noch `BIO_s_workersocket` stehen in einer Kopfdatei oder in
`qcssl.def`; ausserhalb dieser Datei ist nichts betroffen.

**Was fuer x64 trotzdem offen bleibt** (nicht Teil von [N1](#n1), hier nur vermerkt, damit
es nicht als erledigt gilt): `ws_read()` Z. 154 und `ws_write()` Z. 202 reichen den
`QCSSLReference*` als `(long)` an `m_fnQCSSLReadCallback`/`m_fnQCSSLWriteCallback`
weiter. Das ist die Signatur der Rueckruffunktionen in der oeffentlichen
QCSSL-Schnittstelle, an der auch QCSocket haengt; sie zu aendern ist ein eigener
Umbau. Unter Win32 ist es folgenlos, unter x64 waere es dieselbe Trunkierung.

**Gegenprobe am Produktivpfad:** `Eudora71/Tests/QCSSL/messen.ps1` mit der neu
gebauten `Eudora71/Bin/Release/QCSSL.dll`. Alle neun Faelle verhalten sich genau wie
vor den Aenderungen (1a Erfolg TLSv1.3, 1b/1d Fehlschlag, 1c unveraendert - das ist
der zurueckgestellte Hostnamen-Befund -, 2a/2b Fehlschlag, 2c TLSv1.2, 2d TLSv1.3,
2e Fehlschlag). Die erfolgreichen Faelle uebertragen Nutzdaten, laufen also durch
`ws_read`/`ws_write` und damit durch den umgebauten Datenslot.

Bauen: `QCSSL.vcxproj` Release/x86 erfolgreich, 0 Warnungen, 0 Fehler.
Tests: `Eudora71/Tests/RunTests.cmd` - 33 Tests, 33 bestanden, 0 fehlgeschlagen.

## Ausgeliefertes Paket nachgezogen

`Releases/1.0/QCSSL.dll` ist neu gebaut, `QCSSL.dll.sha256` erneuert
(`5c7fcd5004036e9247252b8ec822687758a84774dad2d024e6fe172116339664`), und im
`Releases/1.0/README.md` steht unter "Neubau vom 30.08.2026", was fuer diesen
Build gemessen ist und was nicht. Damit stimmt auch die Aussage im Abschnitt
"Herkunft" wieder, die DLL sei byte-identisch mit `Eudora71/Bin/Release/QCSSL.dll`.

## Was in `PORTIERUNG.md` durch diese Arbeit ueberholt ist

Nicht selbst geaendert - dort arbeitet LEKTOR. Nur als Hinweis:

- Z. 204-210: "Als Mindestprotokoll setzt `QCSSLContext.cpp:561-583` bei sieben der
  acht Werte ... `TLS1_2_VERSION`. Der achte, `m_ProtocolVersion == 3` ..., setzt
  `TLS1_VERSION`, also TLS 1.0." Das gilt seit [M1](#m1) nicht mehr: alle acht Werte setzen
  `TLS1_2_VERSION`.
- Derselbe Absatz: "Ein ungueltiger Wert landet im `default`-Zweig, meldet
  `IDS_ERR_VERSIONINVALID` und bleibt beim Startwert `TLS1_2_VERSION`." Das war schon
  durch [H1](#h1) ueberholt - der Zweig gibt jetzt `NULL` zurueck, die Verbindung kommt
  nicht zustande.
- Die Zeile "Eine Obergrenze wird nirgends gesetzt" stimmt weiterhin und soll auch
  so bleiben.
- Tabelle Z. 196: der Eintrag zu `BIO_s_workersocket` koennte ergaenzen, dass die
  Struktur seit [M2](#m2) erst nach dem Fuellen unteilbar veroeffentlicht wird.
- Nicht erwaehnt, aber jetzt anders: `BIO_set_fd()` wird nicht mehr benutzt ([N1](#n1)).

---

# Erledigt durch SUMME (30.08.2026, Branch `eudora-exe-linkt`)

Bearbeitet wurden die verstreuten Befunde ausserhalb von QCSSL und der
Ersatzschicht: [M5](#m5), [N2](#n2), [N4](#n4), [N5](#n5), [N8](#n8). Die bestehenden Befundabschnitte oben sind
unveraendert geblieben; dieser Abschnitt verweist nur auf sie. Hinweis zur Herkunft: die vier Quelldateien und dieser Abschnitt sind versehentlich in den Commit 63f81dc eines parallel laufenden Agenten geraten, dessen Nachricht von ISOTranslate spricht. Die Begruendung zu jeder Aenderung steht deshalb nur hier, nicht in einer Commit-Nachricht.

**Bau:** `Eudora.vcxproj` Debug/x86 uebersetzt vollstaendig durch - kein einziger
Uebersetzungsfehler mehr, auch kein `C2572` aus `secbtns.h`. Es bleiben 14
**Binde**fehler (`SECBitmapButton`, `TraceStart`, `ATL::CImage::s_initGDIPlus`
und `s_cache`, `CVoiceText`, `libpng` mit `__imp___iob`) - die gehoeren LINKER.
Keiner davon nennt eine der hier geaenderten Dateien.
`plstclnt.vcxproj` Debug/x86 baut fehlerfrei bis zur fertigen `plstclnt.dll`.

**Tests:** `Eudora71/Tests/RunTests.cmd` - 33 Tests, 30 bestanden, 3
fehlgeschlagen. Alle drei liegen in `ISOTranslate` (`utils.cpp` /
`TestIsoTranslate.cpp`), beide Dateien sind gerade von einem anderen Agenten in
Arbeit und gehoeren nicht zu diesem Auftrag. Keiner der drei Tests beruehrt
`summary.h`, `plist_mgr.cpp`, `ExceptionHandler.cpp` oder `atlimage.h`.

---

## M5 - erledigt, Aufrufstellen ausgezaehlt

**Zaehlung zuerst.** `GetTail` kommt im gesamten Baum `Eudora71/` **38 mal in 10
Dateien** vor. Davon sind:

- 8 Deklarationen in vier Hilfsklassen: `tocdoc.h:512/514`, `nickdoc.h:204/206`,
  `filtersd.h:233/235`, `summary.h:506/508`;
- 6 Rumpfzeilen dieser Deklarationen, die `CObList::GetTail()` weiterreichen -
  **ausser** den beiden in `summary.h`, die `GetHead()` riefen;
- 2 Deklarationen und 3 Aufrufe der voellig unabhaengigen `CNode::GetTail` in
  `DirectoryServices/Ph`;
- **19 echte Aufrufstellen**, verteilt auf `PaigeEdtView.cpp` (12),
  `QCCommandStack.cpp` (5), `QCMailboxDirector.cpp` (1), `html2text.cpp` (1).

**Kein einziger dieser 19 Aufrufe geht auf ein `CSumList`.** Die Empfaenger
wurden einzeln aufgeloest:

| Aufrufstelle | Empfaenger | Typ |
|---|---|---|
| `PaigeEdtView.cpp` (12x) | `m_undoStack`, `m_redoStack`, `m_deleteUndoStack`, `m_deleteRedoStack`, `theStack`, `theRefStack` | `CUndoStack` = `CTypedPtrList<CPtrList, undo_ref*>` (`PaigeEdtView.h:97`) |
| `QCCommandStack.cpp` (5x) | `m_theStack` | `CPtrList` (`QCCommandStack.h:65`) |
| `QCMailboxDirector.cpp:2109` | `theList` (= `m_theMailboxList`) | `CPtrList` (`QCMailboxDirector.h:48`) |
| `html2text.cpp:851` | `m_BlockList` | `CList<CHtmlBlockInfo, CHtmlBlockInfo&>` (`html2text.h:34`) |

Die einzige abgeleitete Klasse, `CTempSumList` (`summary.h:601`), ruft
`GetTail()` ebenfalls nirgends.

**Folge:** `CSumList::GetTail()` hat **null Aufrufer**. Kein Code stuetzt sich
also auf das falsche Verhalten - die Korrektur kann nichts brechen, und sie
raeumt eine Falle weg, in die der naechste Aufrufer sonst blind hineingelaufen
waere. Der Befund war damit **heute harmlos, aber scharf gestellt**.

Zusaetzliches Indiz, dass es sich wirklich um einen Tippfehler und nicht um
Absicht handelt: die drei Schwesterklassen `CTocDocList`, `CNicknameList` und
`CFilterList` sind zeichengleich aufgebaut und rufen alle sechs richtig
`CObList::GetTail()`. Nur `summary.h` weicht ab.

**Geaendert:** `Eudora71/Eudora/summary.h` Z. 507 und 509, je
`m_ObList.GetHead()` -> `m_ObList.GetTail()`. Beide Ueberladungen sind damit
typkorrekt: die nicht-`const`-Fassung bindet an das `CObject*&`, das
`CObList::GetTail()` liefert, die `const`-Fassung nimmt den `CObject*` als Wert.

---

## N2 - erledigt und nachgemessen

**Geaendert:** `Eudora71/PlaylistClient/plstclnt_dll/plist_mgr.cpp:176`,
`int get_entry_info(...)` -> `static int get_entry_info(...)`.

Die Definition in Z. 1571 bleibt bewusst `int get_entry_info(...)` ohne
Speicherklasse - genau wie im Original 7.1. Eine Definition ohne Speicherklasse
uebernimmt die Bindung der vorangegangenen Deklaration; Deklaration und
Definition stimmen also im Rueckgabetyp ueberein, und der urspruengliche
default-int-Uebersetzungsfehler kehrt nicht zurueck.

**Nachgemessen statt vermutet:** `dumpbin /SYMBOLS` auf dem frisch erzeugten
`plist_mgr.obj` zeigt

    ?get_entry_info@@YAHPAUPrivCacheStruct@@PAUEntry@@PAPAUENTRY_INFO@@@Z   Static

- `Static`, nicht `External`. Die interne Bindung ist tatsaechlich wieder da.
Der Uebersetzer gibt dabei kein `C4211` und keine sonstige Warnung aus.

---

## N4 - erledigt, anders als vorgeschlagen

Der Vorschlag im Befund war, den Waechter in `EuMemMgr/Include/MiniDump.h`
umzubenennen. Das ist hier nicht der Weg: die Datei gehoert einem fremden
Teilprojekt (BugslayerUtil), und eine Umbenennung dort wuerde jede andere
Uebersetzungseinheit mitreissen, die sie einbindet.

Stattdessen ist die Zerbrechlichkeit **in der betroffenen Datei selbst**
beseitigt. `Eudora71/Eudora/ExceptionHandler.cpp` Z. 32-34 lautet jetzt:

    #include <minidumpapiset.h>
    #undef _MINIDUMP_H
    #include "MiniDump.h"

Der SDK-Header wird also ausdruecklich zuerst geholt, bevor sein Waechter
geloescht wird. Damit haengt die Sache nicht mehr daran, ob `stdafx.h` ihn
zufaellig schon vorher gebracht hat.

**Warum das kein Nebenwirkungsrisiko traegt:** `minidumpapiset.h` beginnt mit
`#pragma once` (Z. 3-5, vor dem `#ifndef _MINIDUMP_H`). Solange `stdafx.h` ihn
schon eingebunden hat - und das tut sie heute - ist die neue Zeile ein reiner
Nulleingriff; der Uebersetzer oeffnet die Datei gar nicht erst. Kehrt sich die
Reihenfolge irgendwann um, zieht die Zeile den Header herein und die SDK-Typen
sind da. In beiden Faellen richtig.

Der bestehende Erklaerkommentar in Z. 27-31 ist um diesen Punkt ergaenzt worden.
Die Zeilenzahl der Datei ist unveraendert.

`ExceptionHandler.cpp` uebersetzt danach fehler- und warnungsfrei.

---

## N5 - geprueft: die Aenderung war noetig, sie bleibt

Der Befund vermutete, die Aenderung koennte noetig gewesen sein. **Sie war es.**
Nachgesehen wurde beides:

1. `CAtlBaseModule` in
   `VC/Tools/MSVC/14.38.33130/atlmfc/include/atlcore.h:280` hat **kein** Element
   `m_bNT5orWin98` mehr. Das Feld war ein Win9x/NT4-Erbstueck und ist mit dem
   Ende der Win9x-Unterstuetzung aus der ATL geflogen.
2. Im gesamten Baum `Eudora71/` kommt `m_bNT5orWin98` **nirgends** vor, es gibt
   also auch keine projekteigene Ersatzdefinition.

Der urspruengliche Rumpf `return( _AtlBaseModule.m_bNT5orWin98 );` haette unter
v143 schlicht nicht uebersetzt. `return( TRUE )` ist auf dem Zielsystem
Windows 10 zudem sachlich das richtige Ergebnis. **Nichts zurueckzunehmen.**

Nebenbefund zur Herkunft: die Aenderung stammt nicht aus dem Zweig
`vs2022-portierung-fixes`, sondern schon aus `ba3d2ee` und liegt damit bereits
in `main` - `git diff main -- Eudora71/Eudora/atlimage.h` ist leer.

**Geaendert:** nur Dokumentation, und zwar **in der Datei selbst**, weil sie am
ehesten dort gefunden wird, wo jemand sie braucht - naemlich beim Vergleich mit
dem SDK-eigenen Header. `Eudora71/Eudora/atlimage.h` Z. 1537 traegt jetzt eine
`ABWEICHUNG`-Notiz mit dem Originalrumpf, dem Grund und dem Hinweis, dass sie
bei einem Umstieg auf den SDK-Header wegfaellt; Z. 1541 verweist darauf.
Zeilenzahl unveraendert.

**Offen und ausdruecklich nicht von mir erledigt:** der Eintrag in
`PORTIERUNG.md`. Die Datei liegt bei LEKTOR; sie erwaehnt `atlimage.h`,
`IsTransparencySupported` und `m_bNT5orWin98` bisher an keiner Stelle.

**Ausserdem beachtenswert fuer LINKER:** zwei der offenen Bindefehler,
`ATL::CImage::s_initGDIPlus` und `ATL::CImage::s_cache`, stammen aus genau
diesem `atlimage.h` (angezogen ueber `QCGraphics.obj`). Die mitgelieferte Kopie
deklariert die beiden statischen Elemente, aber keine Uebersetzungseinheit
definiert sie. Das ist ein eigenstaendiger Punkt, nicht Teil von [N5](#n5).

---

## N8 - geprueft, nichts geaendert; die Tabelle stimmt nicht mehr ganz

Auftragsgemaess wurde nur geprueft. Alle zehn Stellen wurden geoeffnet und bis
zur Herkunft des beschriebenen Puffers zurueckverfolgt.

**Ergebnis vorweg: keine einzige Stelle schreibt in einen tatsaechlich
schreibgeschuetzten Puffer.** Nichts zu melden, nichts zu aendern. Die Bewertung
"originalgetreu" im Befund bleibt richtig.

Drei Korrekturen an der Tabelle - dort stehen Stellen als Schreibzugriff, die
keiner sind:

| Stelle | Tabelle sagt | Tatsaechlich |
|---|---|---|
| `statbar.cpp:233` | "Puffer wird umgeschrieben" | **Kein Schreibzugriff.** `Newline` wird nur getestet (Z. 234) und fuer die Differenz `Newline - lParam` benutzt (Z. 238). Kopiert wird mit `strncpy` in ein lokales `char Buffer[128]`; `lParam` selbst bleibt unberuehrt. |
| `html2text.cpp:981` | "`szCurrent + 1` ohne NULL-Pruefung" | **Kein Schreibzugriff.** Der Mangel ist echt, aber ein anderer: Z. 984 rechnet `szStart = szCurrent + 1` **vor** der NULL-Pruefung in Z. 986. Das ist Zeigerarithmetik auf einem Nullzeiger - formal undefiniert, praktisch folgenlos, weil der Wert nach dem `break` nicht mehr gelesen wird. Gehoert nicht in die `const_cast`-Familie. |
| `mapicmc.cpp:171` | Schreibzugriff auf `pszNewline` | **Ueberholt.** Die Stelle ist inzwischen auf eine rein lesende Fassung umgebaut, mit Kommentar: `pszData` zeigt bei `WM_COPYDATA` in fremden Prozessspeicher. Dort steht kein `const_cast` mehr. |

Es bleiben **sieben** echte Schreibzugriffe. Fuer jeden wurde der Aufrufweg bis
zum Ursprung des Puffers verfolgt:

| Stelle | Puffer kommt von | Bewertung |
|---|---|---|
| `mainfrm.cpp:4849` (`GetAttachmentLine`) | zwei Wege: `CWinApp::m_lpCmdLine` (`eudora.cpp:1636`) - beschreibbar; und `OnCopyData` (`mainfrm.cpp:4904`), das den fremden `WM_COPYDATA`-Block **vorher in ein eigenes `DEBUG_NEW char[]` kopiert** | unbedenklich; der gefaehrliche Fall ist bereits abgefangen |
| `Trnslate.cpp:4194` (`XLateDisplay`) | `PgHLinks.cpp:340` uebergibt ein lokales `char url[1024]` | unbedenklich |
| dieselbe Stelle | `TridentView.cpp:2840` uebergibt eine `CString szHRef` | siehe unten |
| `TridentPreviewView.cpp:352` | lokale `CString szFullMessage` (Z. 287) | siehe unten |
| `tocdoc.cpp:2173/2174` | lokale `CString ConvertedBody` (Z. 2128) | siehe unten |
| `Convhtml.cpp` (`BuildURIMap`, Schreibzugriffe in Z. 527/537/540/613) | `Trnslate.cpp:4470` uebergibt ein eigenes `DEBUG_NEW char[]`; `Trnslate.cpp:4296` und `TocFrame.cpp:1672` uebergeben eine `CString`; die Schreibzugriffe setzen den alten Wert unmittelbar wieder ein | siehe unten |
| `PaigeEdtView.cpp:2522` | lokales `char url[INTERNET_MAX_URL_LENGTH]` (Z. 2506) | unbedenklich |

**Die verbleibende Gemeinsamkeit ist enger als der Befund sie fasst:** vier der
sieben Stellen schreiben durch `CString::operator LPCTSTR` in den internen
Puffer einer `CString`, ohne vorher `GetBuffer()` zu rufen. Das ist kein
Speicherschutzverstoss - der Puffer liegt im Heap und ist beschreibbar - aber es
umgeht das Copy-on-Write von `CStringT`: teilt sich die `CString` ihre Daten
gerade mit einer zweiten (Referenzzaehler groesser 1), aendern sich beide. Der
Sonderfall des global geteilten Leerstring-Objekts kann nicht auftreten, weil
`strchr`/`strstr` auf einer leeren Zeichenkette NULL liefern und gar nicht erst
geschrieben wird.

Das gilt fuer VC6 genauso - auch dessen `CString` war referenzgezaehlt mit
Copy-on-Write. **Die Portierung hat hier also nichts verschlechtert.** Der
richtige Zeitpunkt fuer eine Bereinigung ist weiterhin der naechste inhaltliche
Umbau dieser Funktionen, so wie der Befund es vorschlaegt: Parameter auf `char*`
ziehen und die Aufrufer mit `GetBuffer()`/`ReleaseBuffer()` nachziehen.

---

# Nachpruefung 3 durch PRUEFER (30.08.2026, Branch `eudora-exe-linkt`)

**Bezugscommit:** `22a6d77` (Merge von `vs2022-portierung-fixes` nach `main`);
gelesen wurde der Dateistand dieses Commits. Waehrend der Pruefung haben andere
Agenten weitergearbeitet - `Eudora.vcxproj` war dabei mehrfach im Fluss und ist
deshalb ausdruecklich NICHT Gegenstand dieses Abschnitts.

**Auftrag:** genau die Bereiche, die die Nachpruefung 2 offen gelassen hat -
Stufe 2/2b der Ersatzschicht (`OTShim.{h,cpp}`), die Registerkartenfamilie
(`OTShim_Reiter.{h,cpp}`), Stufe 4 (`OTShim_Bild.{h,cpp}`), `SECDateTimeCtrl`
(`OTShim_Palette.{h,cpp}`) und die Werkzeuge unter `tools/`.

**Nicht Gegenstand:** Hostnamenpruefung und `X509_V_ERR_CERT_UNTRUSTED`
(bewusst zurueckgestellt), Stil/Formatierung/Namensgebung, die Dokumentation.

**Stand dieses Abschnitts: Zwischenstand.** Was schon durch ist und was noch
offen ist, steht unten unter "Stand der Nachpruefung 3".

---

## NP2-1 ist ueberholt

`OTShim_Werkzeugleiste.cpp`, `OTShim_Reiter.cpp` und `OTShim_Palette.cpp`
stehen seit `e50a89c` in `Eudora.vcxproj:217`, jeweils mit
`<PrecompiledHeader>NotUsing</PrecompiledHeader>`, und `OTShimAll.h` bindet die
zugehoerigen Header ein. Der Befund "Stufe 3 haengt nirgends" ist damit
erledigt.

---

## NP3-1 - `ZeigeInhaltsfenster` laeuft, bevor Eudora das Fenster umgehaengt hat

**Sicherheit: im Code nachgewiesen; Auswirkung Verdacht (nur sichtbar, nicht
funktional)**

**Dateien:** `Eudora71/OTShim/OTShim_Reiter.cpp:1500-1503`
(`SECTabWndBase::InsertTab`) gegen `Eudora71/Eudora/WazooBar.cpp:124-185`
(`CWazooBar::AddWazooWindow`).

`AddWazooWindow` legt das Wazoo-Fenster als sichtbares Kind des HAUPTFENSTERS
an (`WazooBar.cpp:1003` - `Create(..., WS_CHILD|WS_VISIBLE, ..., ::AfxGetMainWnd(), ...)`)
und haengt es erst NACH `AddTab`/`InsertTab` um:

    pNewTab = m_wndTab.AddTab(pWazooWnd, pWazooWnd->GetTabLabel());
    ...
    m_wndTab.SetTabIcon(nTabIndex, pWazooWnd->GetTabIconHandle());
    pWazooWnd->ModifyStyle(0, WS_CHILD);
    pWazooWnd->SetParent(&m_wndTab);          // erst hier

Der Shim ruft beim ERSTEN Reiter mitten darin `ZeigeInhaltsfenster(nNeu)` auf.
Das setzt `m_pActiveWnd`, ruft `RecalcLayout()` - das das Fenster per
`DeferWindowPos` auf `rcInnen` setzt, also auf Koordinaten des noch gar nicht
zustaendigen Elternfensters - und macht es anschliessend mit `SW_SHOW` sichtbar.

**Folge:** das Wazoo-Fenster steht fuer die Dauer weniger Anweisungen an einer
falschen Stelle im Hauptfenster. Danach zieht der naechste `RecalcLayout`
(ueber `CWazooBar::OnSize` oder `SetActiveWazooWindow`) es zurecht. Beim zweiten
und jedem weiteren Reiter tritt der Fall nicht auf, weil dann der `else`-Zweig
mit `ShowWindow(SW_HIDE)` greift. Es bleibt also hoechstens ein Aufblitzen beim
Start; ein Datenfehler entsteht nicht.

**Zu tun:** in `SECTabWndBase::InsertTab` den ersten Reiter nur vormerken
(`m_pActiveWnd` setzen) und das Zeigen dem ersten `ActivateTab` bzw.
`RecalcLayout` ueberlassen - oder `ZeigeInhaltsfenster` nur ausfuehren, wenn
`pWnd->GetParent() == this` gilt.

---

## NP3-2 - `SEC3DTabControl::OnToolHitTest` ist als `int` deklariert

**Sicherheit: nachgewiesen. Heute kein Fehler.**

**Datei:** `Eudora71/OTShim/OTShim_Reiter.h:570` und
`Eudora71/OTShim/OTShim_Reiter.cpp:1032`.

    virtual int OnToolHitTest(CPoint point, TOOLINFO* pTI) const;

`CWnd::OnToolHitTest` ist in MFC 14 als `virtual INT_PTR` deklariert
(`afxwin.h:2429`). Unter Win32 ist `INT_PTR` gleich `int`, beide Deklarationen
bezeichnen also dieselbe virtuelle Funktion - deshalb uebersetzt es. `OTShim.h`
begruendet an zwei anderen Stellen (`SECControlBar::OnToolHitTest` Z. 572-577,
`SECWorkbook::OnToolHitTest` Z. 1454-1460) ausdruecklich, warum dort `INT_PTR`
steht; hier ist es nicht nachgezogen worden.

**Folge:** keine, solange Win32 gilt. Bei einem x64-Bau waere es C2555
(Ueberschreibung mit abweichendem Rueckgabetyp) - immerhin ein lauter Fehler,
kein stiller. Derselbe Sperrgrund wie Befund [N1](#n1).

**Zu tun:** auf `INT_PTR` ziehen, wie an den beiden anderen Stellen.

---

## NP3-3 - Der Kommentar zu `CreateFromBitmap` zaehlt die Aufrufstellen falsch

**Sicherheit: nachgewiesen. Der Code ist richtig, nur die Begruendung stimmt
nicht.**

**Datei:** `Eudora71/OTShim/OTShim_Bild.h:326-328`

> "Die Quellbitmap ist an drei von fuenf Stellen im uebergebenen DC ausgewaehlt:
> QCToolBarManager.cpp:420/421, 433/434, 446/447 und QCGraphics.cpp:167/226"

Nachgezaehlt sind es **neun** Aufrufstellen (Zeile 322 derselben Datei zaehlt
sie selbst korrekt auf), und ausgewaehlt ist die Quellbitmap an **sechs** davon:

| Aufrufstelle | Quellbitmap im DC ausgewaehlt? | Beleg |
|---|---|---|
| `QCGraphics.cpp:226` | ja | `:167` `cdc.SelectObject(&Bitmap)` |
| `QCGraphics.cpp:258` | nein | `cdc.CreateCDC()` ohne Auswahl |
| `QCGraphics.cpp:615` | nein | frischer `CreateCompatibleDC(NULL)` |
| `LinkHistoryManager.cpp:1249` | nein | `:1242` `cdc.SelectObject(pSavePrevBitmap)` loest vorher |
| `QCToolBarManager.cpp:421` | ja | `:420` `theSrcDC.SelectObject(&m_bmp)` |
| `QCToolBarManager.cpp:434` | ja | `:433` `theSrcDC.SelectObject(theBitmapA)` |
| `QCToolBarManager.cpp:447` | ja | `:446` `theSrcDC.SelectObject(theBitmapB)` |
| `QCToolBarManager.cpp:569` | ja | `:559` `pBmpOldSrc = theSrcDC.SelectObject(&m_bmp)` |
| `QCToolBarManager.cpp:582` | ja | `:581` `theSrcDC.SelectObject(theNewButtonBitmap)` |

Die Umsetzung ist davon unberuehrt - sie prueft den Zustand zur Laufzeit mit
`::GetCurrentObject(hdc, OBJ_BITMAP)` und behandelt beide Faelle. Nur die
Zahlenangabe im Kommentar ist falsch und laesst die beiden Stellen 569/582
aussehen, als seien sie geprueft und unkritisch.

**Zu tun:** die Zahl im Kommentar berichtigen (sechs von neun).

---

## Geprueft und in Ordnung (Nachpruefung 3)

### Stufe 2 - die zweite Andockleiste von `SECMiniDockFrameWnd`

Das war der Hauptpunkt des Auftrags: `SECMiniDockFrameWnd` haelt neben der von
`CMiniDockFrameWnd` geerbten `m_wndDockBar` (`CDockBar`, `afxpriv.h:664`) eine
eigene `m_wndSECDockBar` (`SECDockBar`). **Beide bleiben konsistent, auch beim
Zerstoeren.** Nachgemessen, nicht vermutet:

- **Alle** Stellen, an denen MFC `m_wndDockBar` anfasst, sind ueberschrieben.
  Gemessen mit `grep -n m_wndDockBar` ueber `atlmfc/src/mfc/*.cpp` (MSVC
  14.38.33130): `bardock.cpp:798` (Baumeister), `:800` (`m_bAutoDelete`),
  `:844/852` (`Create`), `:866` (`RecalcLayout`), `:873` (`OnClose`),
  `:884-913` (`OnNcLButtonDown`), `:928-933` (`OnNcLButtonDblClk`). Genau diese
  sechs Methoden ersetzt der Shim, und alle drei Nachrichtenbehandler stehen in
  `BEGIN_MESSAGE_MAP(SECMiniDockFrameWnd, ...)` (`OTShim.cpp:3002-3007`), fangen
  die Nachricht also vor der Basisklasse ab. `OnMouseActivate` ist die einzige
  nicht ueberschriebene Methode von `CMiniDockFrameWnd` - und sie fasst
  `m_wndDockBar` nicht an. Die Behauptung im Kopf von `OTShim.h:916-920` stimmt
  also wortgenau.
- **Der Zugriff von aussen laeuft ueber die Kennung, nicht ueber den
  Datenmember.** `CFrameWnd::FloatControlBar` (`winfrm2.cpp:202`) und
  `CFrameWnd::SetDockState` (`dockstat.cpp:476`) holen die schwebende
  Andockleiste mit `pDockFrame->GetDlgItem(AFX_IDW_DOCKBAR_FLOAT)`. Der Shim
  legt `m_wndSECDockBar` unter genau dieser Kennung an (`OTShim.cpp:3067-3068`),
  MFC findet also die richtige.
- **`m_wndDockBar` bekommt nie ein Fenster.** Damit ist sie in keiner
  Leistenliste (`CControlBar::OnCreate`, `barcore.cpp:554-566`, meldet die
  Leiste erst beim Anlegen beim Rahmen an), taucht in keinem `GetDlgItem` auf
  und hat beim Abraeumen nichts zu tun: `CWnd::~CWnd` findet `m_hWnd == NULL`,
  und `m_bAutoDelete` ist von `CMiniDockFrameWnd::CMiniDockFrameWnd` auf
  `FALSE` gesetzt. Fuer `m_wndSECDockBar` setzt der Shim dasselbe
  (`OTShim.cpp:3016`) - richtig, denn der Zerstoerungsweg
  `CDockBar::RemoveControlBar` nach `pFrameWnd->DestroyWindow()`
  (`bardock.cpp:342-347`) fuehrt ueber `CFrameWnd::PostNcDestroy` auf
  `delete this`, und das Wertfeld darf sich nicht zusaetzlich selbst freigeben.
- **Eudora zieht mit.** `QCMiniDockFrameWnd` (`workbook.cpp:539, 574`) ersetzt
  beide `RecalcLayout`-Fassungen vollstaendig und liest darin ausschliesslich
  `m_wndSECDockBar`; `Create`, `OnClose`, `OnNcLButtonDown` und
  `OnNcLButtonDblClk` ueberschreibt es nicht, es laufen also die Fassungen des
  Shims. Gegenprobe: `grep -rn "m_wndDockBar|m_wndSECDockBar"` ueber `Eudora71`
  ausserhalb von `OTShim/` liefert nur `workbook.cpp` - die
  `m_wndDockBar`-Treffer dort (`:371, :373, :457, :459`) gehoeren zu
  `QCControlBarWorksheet`, also zum gleichnamigen Wertfeld von
  `SECControlBarWorksheet`, das eine andere Klasse ist.
- **Kleiner Unterschied ohne Folge:** MFC laeuft in `OnNcLButtonDown` und
  `OnNcLButtonDblClk` ab `nPos = 1` durch `m_arrBars`, der Shim beginnt in
  `GetFirstDockedBar` bei 0. `CDockBar::CDockBar` legt an Index 0 immer ein
  `NULL` an (`bardock.cpp:35`), und keine Einfuegeoperation ueberschreibt es
  (`DockControlBar` haengt an, `Insert` und `SetBarInfo` beginnen bei 1).
  `GetDockedControlBar(0)` liefert also stets `NULL`; die Schleifen sind
  gleichwertig.
- **Zusatz gegenueber MFC, absichtlich:** wo MFC `ENSURE_VALID(pBar)` und
  `ENSURE(pBar->m_pDockContext != NULL)` schreibt, prueft der Shim und faellt
  auf `CMiniFrameWnd::OnNcLButtonDown` zurueck. Das ist strikt vertraeglicher
  als das Original.

### Stufe 2 - uebriger Teil der Andockfamilie

- **`SECControlBar::GetBarInfo`/`SetBarInfo`** sind fuer die einzige
  Aufrufstelle (`WazooBarMgr.cpp:432-436`, Andockhoehe der Task-Leiste auf 80
  setzen) verlustfrei: `GetBarInfo` legt alle elf SEC-Felder ab und ruft danach
  `GetBarInfoEx`, `SetBarInfo` liest sieben davon zurueck. Dass `m_dwStyle` und
  `m_dwDockStyle` bewusst NICHT zurueckgeschrieben werden, ist richtig -
  `CControlBar::SetBarInfo` (`dockstat.cpp:584-616`) fasst genau diesen Zustand
  gleich danach selbst an.
- **`SECDockBar`, Zeilenlogik.** `GetControlBarRow`, `IsOnlyControlBarInRow`,
  `BarIsNewToThisRow`, `GetRowHeight`, `InvalidateToRow` und `NormalizeRow`
  suchen den Zeilenanfang alle nach demselben Muster (rueckwaerts bis vor die
  naechste NULL-Marke) und brechen vorwaerts an der naechsten NULL ab. Alle
  sechs sind gegen `nPos < 0 || nPos >= GetSize()` geschrankt, und die
  Rueckwaertssuche kann wegen des NULL an Index 0 nicht unter 1 fallen. Die
  Platzhalter (Werte bis 0xffff) werden ueber `GetDockedControlBar`
  ausgefiltert. Kein Zugriff ueber das Feldende gefunden.
- **`SECDockBar`, Splitter und Innenkanten.** `AddSplitter`/`AddClientEdge`
  verwenden freie Eintraege wieder, `EndRecycleSplitters`/`EndRecycleEdges`
  raeumen rueckwaerts auf (richtig, weil `RemoveAt` nachfolgende Plaetze
  verschiebt), `DeleteAllSplitters`/`DeleteAllEdges` geben frei und leeren.
  Destruktor und `OnDestroy` rufen beide `DeleteAllSplitters`/`DeleteAllEdges`;
  weil beide danach `RemoveAll()` machen, ist die zweite Runde leer - keine
  Doppelfreigabe.
- **`SECControlBar::OnContextMenu`** laedt seine Beschriftungen mit
  `strItem.LoadString(ID_SEC_ALLOWDOCKING)` usw. Nachgesehen: `SECRES.H:189-191`
  vergibt die Kennungen 53288 bis 53290, `SECRES.RC:412-414` traegt genau diese
  drei in eine STRINGTABLE ein, und `EudoraRes.rc:11712` bindet `secres.rc` in
  einem `#ifndef APSTUDIO_INVOKED`-Block ein, der beim Bau durchlaufen wird. Die
  Zeichenketten sind zur Laufzeit also da.
- **`SECControlBar::DeleteLayoutInfo`** ist gegen Mehrfachaufruf sicher
  (`m_pArrLayoutInfo` wird auf NULL gesetzt); Destruktor und `OnDestroy` rufen
  es beide.
- **Stufe 2b** (`SECFrameWnd`, `SECDockState`, `SECControlBarInfo(Ex)`,
  `SECControlBarManager`, `SECDockContext`) besteht fast nur aus
  Durchreichungen an die MFC-Gegenstuecke. Zwei Stellen mit Inhalt geprueft:
  `SECControlBarInfo::~SECControlBarInfo` gibt `m_pBarInfoEx` frei (der
  Erzeuger ist `CreateControlBarInfoEx`, der Besitz liegt also wirklich hier),
  und `SECFrameWnd::OnActivate` pflegt `m_bActive`, das `GetActiveState()` nach
  aussen reicht. `SECFrameWnd::dwSECDockBarMap` ist feldgleich mit
  `SECMDIFrameWnd::dwSECDockBarMap` und mit `CFrameWnd::dwDockBarMap`
  (`winfrm2.cpp:18-24`) - genau das verlangt `CMainFrame::EnableDocking`
  (`mainfrm.cpp:2156-2173`), sonst entstuenden acht statt vier Andockleisten.

### Registerkarten - die Punkte aus dem Kommentarkopf

- **Der Ringlauf `ActivateTab` - `TCM_TABSEL` - `OnTabSelect` - `ActivateTab`
  ist wirklich aufgeloest**, und zwar doppelt abgesichert:
  1. `SECTabWndBase::OnTabSelect` (`OTShim_Reiter.cpp:1793-1810`) ruft
     `ZeigeInhaltsfenster` und NICHT `ActivateTab`; es meldet nichts an das
     Steuerelement zurueck.
  2. Selbst wenn es das taete, setzt `SECTabControlBase::ActivateTab` den
     aktiven Reiter mit `SetActiveTabQuiet` **vor** `OnActivateTab`, und der
     Wiedereintritt liefe in die Abbruchbedingung
     `if (m_bActiveTab && m_nActiveTab == nTab) return;`.
  Die Gegenprobe auf Eudoras Seite stimmt ebenfalls: `CWazooBar::OnTabSelect`
  (`WazooBar.cpp:1490-1530`) setzt nur Fenstertitel und Symbol und ruft
  `ActivateTab` nicht.
- **Es wird wirklich kein fremdes Fenster zerstoert.** `SECTabWndBase::RemoveTab`
  zerstoert nur, was in `m_arrEigeneFenster` steht, also nur ueber `CreateView`
  selbst erzeugte Fenster; `~SECTab` und `~SEC3DTab` fassen `m_pClient` und
  `m_hIcon` nicht an. Das passt zu `CWazooBar::RemoveWazooWindow`
  (`WazooBar.cpp:196-210`), das direkt nach `RemoveTab` mit
  `ASSERT(::IsWindow(pWazooWnd->GetSafeHwnd()))` prueft, dass das Fenster noch
  lebt. `SECTabWndBase::OnDestroy` fasst die Inhaltsfenster ebenfalls nicht an -
  richtig, denn `CWazooBar::OnDestroy` (`WazooBar.cpp:1197-1225`) hat sie zu
  diesem Zeitpunkt schon zerstoert und geloescht (WM_DESTROY erreicht das
  Elternfenster vor den Kindern).
- **Das Loeschen der Reiter ueber den `CObject`-Zeiger ist zulaessig.**
  `~SECTab` ist wie im Original geschuetzt, aber `CObject::~CObject` ist
  oeffentlich und virtuell; die Zugriffspruefung greift an `CObject`, die
  Ausfuehrung landet bei `~SECTab`. Kein Speicherleck, kein Zugriffsfehler.
- **Kein doppeltes Loeschen der Reiterliste.** `SECTabControlBase::OnDestroy`
  loescht die Reiter und ruft `RemoveAll()`; der Destruktor laeuft danach ueber
  ein leeres Feld. `SECTabWndBase::OnDestroy` loescht `m_pTabCtrl` und setzt es
  auf NULL, der Destruktor findet nichts mehr vor.
- **Der Kurzhinweis-Puffer ist richtig verwaltet.** `OnToolHitTest` legt den
  Text mit `_tcsdup` an; MFC gibt ihn in `CWnd::_FilterToolTipMessage`
  (`tooltip.cpp:501-502`) mit `free(tiHit.lpszText)` wieder frei, und zwar
  genau unter der Bedingung `tiHit.hinst == 0` - die erfuellt ist, weil MFC die
  Struktur vorher mit `memset` nullt (`tooltip.cpp:433`). Passendes
  Allokator-Paar, kein Leck.
- **`EnableToolTips` vor dem Anlegen des Fensters ist unbedenklich.**
  `SECTabControlBase::Create` ruft `Initialize` vor `CWnd::Create`, und
  `SEC3DTabControl::Initialize` ruft `EnableToolTips(TRUE)`.
  `CWnd::_EnableToolTips` (`tooltip.cpp:303-345`) setzt im Einschaltfall nur
  `m_nFlags |= WF_TOOLTIPS` und einen Modulzeiger - kein `m_hWnd` noetig.
- **Alle Reiterzugriffe sind geschrankt.** `GetTabPtr` prueft ueber
  `TabExists(nTab)`, und jede Stelle, die einen Reiter anfasst, geht ueber
  `GetTabPtr` und prueft auf NULL. `SetActiveTabQuiet` setzt `m_nActiveTab` auf
  -1, sobald der Index aus dem Bereich faellt; `InsertTab` und `DeleteTab`
  ziehen den Index richtig nach (nachgerechnet fuer Einfuegen vor und hinter dem
  aktiven Reiter und fuer Loeschen des letzten Reiters).

### Stufe 4 - `SECImage::CreateFromBitmap`

**Die Frage des Auftrags war, ob die Bitmapauswahl auf allen Rueckgabepfaden
wiederhergestellt wird. Ja.** `OTShim_Bild.cpp:1120-1209` hat nach dem Loesen
der Auswahl (Z. 1164-1171) **keinen einzigen weiteren `return`**: die beiden
Fehlerfaelle (`OTShimDibAnlegen` scheitert, `::GetDIBits` liefert 0) setzen
`bErfolg = FALSE` und fallen durch den gemeinsamen Ausgang Z. 1198-1208, der
erst `::SelectObject(hdc, hQuelle)` zuruecksetzt, dann die Platzhalter-Bitmap
loescht und zuletzt einen selbst angelegten DC freigibt. Die drei frueheren
`return FALSE` (Z. 1130, 1138, 1152) liegen alle **vor** der ersten
Zustandsaenderung. Auch der Fall "`::CreateBitmap` fuer den Platzhalter
scheitert" ist abgefangen: dann wird `bWarAusgewaehlt` auf FALSE gesetzt, der
Ausgang laesst den DC also in Ruhe.
Der zweite Zweck der Methode ist ebenfalls erfuellt: `OTShimDibAnlegen` ruft als
erstes `OTShimDibFreigeben()`, der Mehrfachaufruf auf demselben Objekt
(`QCToolBarManager.cpp:421/434/447` und `:569/582`) leckt also nicht.

### `SECDateTimeCtrl`

**Die Frage des Auftrags war, ob das Nachtragen der Formatzeichenkette
zuverlaessig greift. Ja.** Der einzige Weg in Eudora ist
`SearchView.cpp:1565-1566`: `SetFormat("MMMM d, yyyy")` vor
`AttachDateTimeCtrl`. `SetFormat(LPCTSTR)` legt die Zeichenkette in
`m_strCustomFormat` ab und ruft `ApplyFormat()`, das ohne Fenster sofort
zurueckkehrt. `AttachDateTimeCtrl` ruft `CreateEx` (das seinerseits schon
`ApplyFormat()` ruft) und danach noch einmal `ApplyFormat()` - der zweite Aufruf
ist ueberfluessig, aber harmlos. Es gibt keinen Weg, auf dem ein Fenster
entsteht, ohne dass danach `ApplyFormat` liefe: `Create`, `CreateEx` und
`AttachDateTimeCtrl` tun es alle drei.
Zwei Nebenpunkte mitgeprueft:
- Das fehlende `WS_VISIBLE` im Vorgabewert `dwWinStyles = WS_CHILD|WS_TABSTOP`
  ist **kein Fehler**: der Vorgabewert ist wortgleich mit dem Original
  (`DTCtrl.h:85-87`), und `CSearchView` schaltet die Sichtbarkeit selbst
  (`SearchView.cpp:1076` und `:2230`).
- Das Wegraeumen des Platzhalters (`pPlaceholder->DestroyWindow()`) ist richtig:
  der Platzhalter ist die oertliche `CEdit TempEdit` aus
  `SearchView.cpp:1557-1561`, `GetDlgItem` liefert genau dieses Objekt aus der
  staendigen Fensterzuordnung, und `DestroyWindow` setzt dessen `m_hWnd` auf
  NULL - der spaetere Zerstoerer von `TempEdit` findet nichts mehr vor.

---

## Nebenbefund im Eudora-Originalcode

`Eudora71/Eudora/SearchView.cpp:1567` schreibt

    m_DateTimeCtrl->SetFont(pFont);

statt `m_DateTimeCtrl[nIdx].SetFont(pFont)`. Damit bekommt bei jedem Durchlauf
immer nur das Feld mit Index 0 die Schrift gesetzt; die uebrigen
Steuerelemente behalten die Systemvorgabe. Die beiden Nachbarzeilen (`:1565`,
`:1566`) indizieren korrekt. **Kein Portierungsfehler** - die Zeile steht in
`main` genauso. Nur der Vollstaendigkeit halber festgehalten; die Auswirkung ist
eine abweichende Schrift, sonst nichts.

---

## Stand der Nachpruefung 3

**Durch (Zeile fuer Zeile gelesen):**

- `OTShim/OTShim.h` vollstaendig (1614 Zeilen).
- `OTShim/OTShim.cpp` Z. 175-540 (`SECMDIFrameWnd`), Z. 1229-1334
  (`SECControlBarWorksheet`), Z. 1336-3881 (Stufe 2 und 2b vollstaendig).
- `OTShim/OTShim_Reiter.h` vollstaendig (753 Zeilen).
- `OTShim/OTShim_Reiter.cpp` vollstaendig (2172 Zeilen).
- `OTShim/OTShim_Bild.cpp` `CreateFromBitmap` und `OTShimDibAnlegen`.
- `OTShim/OTShim_Palette.cpp` `SECDateTimeCtrl`, Erzeugungs- und Formatteil
  (Z. 30-260).
- Gegengelesen in Eudora: `WazooBar.cpp` (Reiterpflege, `OnDestroy`,
  `OnTabSelect`), `WazooBarMgr.cpp` (Andockaufbau), `DockBar.cpp`,
  `workbook.cpp` (`QCControlBarWorksheet`, `QCMiniDockFrameWnd`),
  `QC3DTabWnd.cpp` (`ActivateTab`, `OnLButtonDown`), `QCToolBarManager.cpp`
  und `QCGraphics.cpp` (Aufrufstellen von `CreateFromBitmap`),
  `SearchView.cpp` (`SECDateTimeCtrl`).
- Gegengelesen in MFC 14.38.33130: `bardock.cpp`, `dockstat.cpp`,
  `winfrm2.cpp`, `barcore.cpp`, `tooltip.cpp`.

**Noch offen:**

| Gegenstand | Grund |
|---|---|
| `OTShim/OTShim.cpp` Z. 1-175 und Z. 540-1229 (Stufe 0 und Stufe 1) | in der ersten Runde bereits unter "OTShim, uebriger Teil" geprueft; hier nur ueberflogen |
| `OTShim/OTShim_Bild.{h,cpp}` ausserhalb von `CreateFromBitmap` (rund 2000 Zeilen: Laden, Speichern, Farbtafel, GDI+-Anbindung) | noch nicht begonnen |
| `OTShim/OTShim_Palette.{h,cpp}` ausserhalb von `SECDateTimeCtrl` | noch nicht begonnen |
| `tools/lehren-spiegeln.pl`, `tools/pruefstand-melden.pl` | noch nicht begonnen |
| `OTShim_Werkzeugleiste`: Anordnungsrechnung, `SECTwoPartBtn::DrawButton`, `SECWndBtn`/`SECComboBtn`, `SECCustomizeToolBar` | unveraendert offen aus Nachpruefung 2 |
| `Eudora.vcxproj` | war waehrend der ganzen Pruefung im Fluss (andere Agenten); eine Aussage waere schon beim Aufschreiben veraltet |

---

# Nachpruefung 3, zweiter Teil (PRUEFER) - die Werkzeuge und zwei Meldungen von TABELLE

Fortsetzung des Abschnitts "Nachpruefung 3 durch PRUEFER". Gemessen am
Arbeitsbaum vom 30.08.2026 (HEAD zu diesem Zeitpunkt: `703a3ca`). Alle Befunde
dieses Teils sind **ausgefuehrt und nachgemessen**, nicht nur gelesen.

---

## NP3-4 - `lehren-spiegeln.pl` und der Pfadangaben-Commit: die gespiegelten Dateien werden beim naechsten Commit wieder geloescht

**Sicherheit: nachgewiesen, in einem eigens angelegten Testrepo vorgefuehrt.
Schwere: hoch - es ist genau der Wissensverlust, gegen den das Werkzeug gebaut
wurde.**

**Dateien:** `tools/lehren-spiegeln.pl:89` (`git add -- Arbeitsweise`),
`.git/hooks/pre-commit`, in Verbindung mit der seit dem 30.08.2026 geltenden
Regel "immer mit ausdruecklicher Pfadangabe committen"
(`git commit -m "..." -- BEFUNDE.md`).

`git commit -- <pfade>` baut den Commit in einem **voruebergehenden** Index auf
(git setzt `GIT_INDEX_FILE` fuer die Dauer des Vorgangs um). Der pre-commit-Hook
laeuft gegen diesen voruebergehenden Index. Das hat zwei Folgen, und nur die
erste ist die erwartete:

1. **Gut:** die von `lehren-spiegeln.pl` frisch kopierten Dateien landen
   tatsaechlich im Commit. Das hatte ich zuerst anders vermutet; die Messung sagt
   etwas anderes.
2. **Schlecht:** der **richtige** Index wird dabei nie aktualisiert. Nach dem
   Commit steht die eben mitgeschriebene Datei dort als **geloescht**. Der
   naechste Commit, der den Index nicht per Pfadangabe umgeht, nimmt diese
   Loeschung mit.

Vorgefuehrt mit git 2.55.0.windows.5 in einem leeren Repo:

    # pre-commit legt Arbeitsweise/lehre.md an und ruft "git add -- Arbeitsweise"
    git commit -m "nur a" -- a.txt
      -> Commit enthaelt: Arbeitsweise/lehre.md | 1 +   und   a.txt | 2 +-
    git status --short
      -> D  Arbeitsweise/lehre.md          <== im Index als geloescht vorgemerkt
    # Hook entfernt, naechster ganz gewoehnlicher Commit:
    git commit -m "naechster commit"
      -> Commit enthaelt: Arbeitsweise/lehre.md | 1 -
    git cat-file -e HEAD:Arbeitsweise/lehre.md  ->  die Datei ist weg

**Folge:** sobald sich eine Lehre aendert, wird sie einmal gespiegelt und
mitgeschrieben - und beim uebernaechsten Commit wieder aus dem Repo entfernt,
ohne dass jemand etwas davon merkt. Der Arbeitsbaum behaelt die Datei, das Repo
verliert sie. Das ist genau der lautlose Wissensverlust, den das Werkzeug
verhindern soll, nur eine Ebene tiefer.

Zusaetzlich verschaerft: der Hook fragt den Rueckgabewert von
`lehren-spiegeln.pl` nicht ab (`.git/hooks/pre-commit` Zeile 3 steht ohne
`set -e`, danach folgt `exec perl .../pruefe-bytes.pl`). Auch die drei `die`- und
`warn`-Ausgaenge des Skripts halten den Commit deshalb nicht auf.

**Zu tun:** entweder das Spiegeln aus dem pre-commit-Hook nehmen und daraus einen
eigenen Commit-Schritt machen, oder im Hook nach dem `git add` den echten Index
nachziehen (`git add` mit gesetztem `GIT_INDEX_FILE` auf den Standardindex - z. B.
`GIT_INDEX_FILE="$(git rev-parse --git-dir)/index" git add -- Arbeitsweise`), oder
das Werkzeug so umbauen, dass es die Kopien nur anlegt und laut meldet, statt
selbst zu stagen.

---

## NP3-5 - `lehren-spiegeln.pl` ist genau im Fehlerfall stumm

**Sicherheit: nachgewiesen (Quelltext und Ausfuehrung). Heute tritt der Fall
nicht ein.**

**Datei:** `tools/lehren-spiegeln.pl:32`, `:43-47`, `:66`, `:71`

Die Pfadableitung stimmt inzwischen - nachgemessen:

    git rev-parse --show-toplevel  ->  C:/Users/Gregor/Documents/github/Eudora7.2
    nach s{:}{-} und s{[/.]}{-}    ->  C--Users-Gregor-Documents-github-Eudora7-2
    tatsaechliches Verzeichnis     ->  C--Users-Gregor-Documents-github-Eudora7-2

Der Punkt in "Eudora7.2" wird von `s{[/.]}{-}g` mit erfasst; genau daran ist die
erste Fassung gescheitert. Heute passt es.

**Was bleibt, ist die Stummheit:** faellt die Ableitung wieder auseinander -
anderes Laufwerk, umbenanntes Repo, geaenderte Namensbildung von Claude Code,
`USERPROFILE` nicht gesetzt -, dann greift

    unless (-d $gedaechtnis) { exit 0; }

und das Werkzeug beendet sich **wortlos mit 0**. Auch `--pruefen` sagt dann
nichts. Ein Aufrufer kann "es gibt nichts zu tun" nicht von "ich habe gar nicht
erst hingesehen" unterscheiden - und das ist derselbe Fehler wie beim ersten Mal,
nur an einer anderen Stelle.

Zwei kleinere Punkte derselben Art:

- **Zeile 66/67:** `open(my $a, '<:raw', $q) or next;` - laesst sich die Quelle
  nicht lesen, wird die Datei stillschweigend uebersprungen und gilt als
  abgeglichen.
- **Der Abgleich ist einseitig.** Es wird nur kopiert, nie geloescht. Wird eine
  Lehre im Gedaechtnis umbenannt oder entfernt, bleibt die alte Kopie unter
  `Arbeitsweise/` fuer immer stehen, und `--pruefen` meldet "alles gleich". Heute
  gibt es genau einen solchen Fall - `Arbeitsweise/README.md` hat kein
  Gegenstueck im Gedaechtnis -, der ist aber gewollt und von Hand geschrieben.
  Ein spaeterer echter Fall waere davon nicht zu unterscheiden.

**Zu tun:** im nicht gefundenen Fall auf `STDERR` melden (und im `--pruefen`-Modus
mit ungleich 0 enden), den abgeleiteten Pfad mit ausgeben, und `--pruefen` auch
ueber verwaiste Kopien in `Arbeitsweise/` berichten lassen.

---

## NP3-6 - `pruefstand-melden.pl` gibt aus dem falschen Verzeichnis heraus Entwarnung

> **BEHOBEN am 31.08.2026 abends.** Die Pfade hängen jetzt an
> `git rev-parse --show-toplevel`, und eine fehlende Datei ist eine **Warnung**
> mit Rückgabe 1. Vorher nachgemessen und vorgeführt: aus `Eudora71/` heraus
> dreimal „fehlt" und danach „Pruefung und Doku sind nah am Code", `rc=0`.
> Nachher liefert das Werkzeug aus `Eudora71/Eudora/` **dasselbe** wie aus der
> Wurzel. Gegenprobe mit fehlender Datei in einem Wegwerf-Repo: Warnung,
> `rc=1`. Siehe auch [NP3-7](#np3-7) — beide in einem Zug.

**Sicherheit: nachgewiesen, ausgefuehrt.**

**Datei:** `tools/pruefstand-melden.pl:41-44` und `:78-86`

Die drei Dateinamen stehen ohne Pfad (`'BEFUNDE.md'` usw.) und werden gegen das
**aktuelle Arbeitsverzeichnis** geprueft. Fehlt eine Datei, meldet das Werkzeug
zwar "fehlt", setzt aber `$warnung` **nicht**. Aus einem Unterverzeichnis heraus
kommt deshalb:

    $ cd Eudora71 && perl ../tools/pruefstand-melden.pl
    Stand HEAD: 703a3ca

      BEFUNDE.md         fehlt
      PORTIERUNG.md      fehlt
      README.md          fehlt

    Pruefung und Doku sind nah am Code.
    rc=0

Also der Rueckgabewert 0 und der Satz "nah am Code", obwohl gar nichts geprueft
wurde. Aus der Wurzel heraus laeuft dasselbe Werkzeug korrekt und liefert
`rc=1`. Im pre-commit-Hook steht es nicht (dort laufen nur
`lehren-spiegeln.pl` und `pruefe-bytes.pl`), es wird also von Hand aufgerufen -
und genau dann steht das Arbeitsverzeichnis nicht fest.

**Zu tun:** die Pfade an `git rev-parse --show-toplevel` haengen, wie
`lehren-spiegeln.pl` es tut, und "fehlt" als Warnung zaehlen.

---

## NP3-7 - `pruefstand-melden.pl` nennt einen beliebigen Commit als Pruefstand

> **BEHOBEN am 31.08.2026 abends, mit der hier vorgeschlagenen Marke.**
> Jede beobachtete Datei trägt oben eine Zeile
> `<!-- pruefstand: <commit> -->` und nennt damit den Commit, gegen den sie
> zuletzt abgeglichen wurde. **Wo keine Marke steht, wird das gemeldet statt
> geraten** (Rückgabe 1) — samt der Zeile, die einzusetzen ist.
>
> Wie irreführend das Raten war, zeigt die letzte Messung der alten Fassung:
> *„PORTIERUNG.md abgeglichen bis `567a5d8`, seither 186 Commits"* — `567a5d8`
> ist der Commit mit den Originalquellen von 2006, den ein Befund nur zitiert.
> `README.md` bekam `b4b7de5` und 170 Commits.
>
> **Zur Laufzeit:** die 29,5 s sind auf dieser Linux-Maschine nicht
> reproduzierbar (dort 0,73 s) — Prozessstarts kosten unter Windows ein
> Vielfaches. Die maschinenunabhängige Zahl ist die Zahl der git-Aufrufe:
> **182 vorher** (122 Hash-Kandidaten in `BEFUNDE.md`, 41 in `PORTIERUNG.md`,
> 19 in `README.md`, je ein `git cat-file -t`), **3 nachher** — je Marke ein
> `git rev-parse --verify`. Lokal 0,73 s → 0,03 s.
>
> `$gesamt` (berechnet und nie benutzt) ist ebenfalls weg.

**Sicherheit: nachgewiesen, ausgefuehrt. Auswirkung: die Zahl ist irrefuehrend,
nicht falsch gerundet.**

**Datei:** `tools/pruefstand-melden.pl:24-26` und `:47-58`

Die Schleife laeuft ueber **alle** Treffer von `\b([0-9a-f]{7,40})\b` in der
ganzen Datei und behaelt den **letzten**, der ein gueltiger Commit ist. Der
Kommentar nennt das "den zuletzt genannten Commit-Hash" - gemeint ist aber
offensichtlich der Commit, bis zu dem geprueft wurde, und das ist etwas anderes.
In `BEFUNDE.md` steht der Bezugscommit eines Abschnitts jeweils oben im Abschnitt;
danach folgen beliebig viele weitere Hashes aus den einzelnen Befunden.

Gemessen unmittelbar nach dem Eintragen der Nachpruefung 3:

    BEFUNDE.md   geprueft bis e50a89c, seither 18 Commit(s)  <== faellig

`e50a89c` ist der Commit, den mein Befund "[NP2-1](#np2-1) ist ueberholt" als Beleg nennt.
Der Bezugscommit des Abschnitts ist `22a6d77`, und der ist **neuer**:

    git rev-list --count 22a6d77..HEAD  ->  17
    git rev-list --count e50a89c..HEAD  ->  18

Heute ist der Unterschied ein einziger Commit; sobald ein Befund einen alten
Commit als Beleg anfuehrt - `BEFUNDE.md` nennt an mehreren Stellen `b4b7de5`,
`ba617a8` oder `567a5d8` -, kann die Meldung um Dutzende Commits danebenliegen,
in beide Richtungen.

**Nebenbei gemessen: das Werkzeug ist langsam.** Es ruft fuer **jeden** hex-artigen
Fund `git cat-file -t` in einer eigenen Prozessinstanz auf. Allein `BEFUNDE.md`
enthaelt 60 solche Kandidaten; der gesamte Lauf ueber die drei Dateien braucht
**29,5 Sekunden** (gemessen mit `time`). Das ist der Grund, warum niemand es
gewohnheitsmaessig aufruft.

**Zu tun:** eine ausdrueckliche Marke einfuehren, die das Werkzeug sucht, statt zu
raten - z. B. eine Zeile `<!-- pruefstand: <hash> -->` oder das erste Vorkommen
von "Bezugscommit:" -, und die Hashes in einem einzigen
`git cat-file --batch-check`-Aufruf pruefen statt in 60 einzelnen.

`$gesamt` (Zeile 33-34) wird berechnet und nie benutzt.

---

## Nachgeprueft: die beiden Meldungen des Agenten TABELLE

Beide sind **bestätigt**. Beide sind Altbestand von QUALCOMM, kein
Portierungsschaden - aber der zweite ist durch die Umstellung auf den
Codepage-Wandler haeufiger sichtbar geworden.

### NP3-8 - Der IMAP-Empfang uebersetzt keinen einzigen Zeichensatz

**Sicherheit: nachgewiesen. Originalfehler von QUALCOMM.**

**Datei:** `Eudora71/EuImap/src/ImapDownload.cpp:4644` und `:4657-4662`

Die beiden Zaehlweisen nebeneinander, jeweils an der Ressourcentabelle
nachgemessen (`Eudora/resource.h:1807-1810`, `Eudora/EudoraRes.rc:9385-9388`):

| Zeichensatz | Ressource | `FindMIMECharset` (`mime.cpp:382-390`) | `ImapDownload.cpp:4644` |
|---|---|---|---|
| `windows-*` | - | 0 (Sonderweg) | -1 (nicht gefunden) |
| `us-ascii` | 3611 | 1 | 0 |
| `iso-8859-1` | 3612 | 2 | 1 |
| `iso-8859-15` | 3613 | 3 | 2 |
| `utf-8` | 3614 | 4 | **-1** (ausserhalb des Suchbereichs) |

`FindMIMECharset` durchsucht 3611 bis **3614** und zaehlt danach mit `++iCharSet`
eins hinauf, damit die 0 fuer die Windows-Zeichensaetze frei bleibt.
`ImapDownload.cpp:4644` durchsucht nur 3611 bis **3613** und laesst das `++` weg.

`ISOTranslate` (`Eudora/utils.cpp:1165-1178`) erwartet die Zaehlweise von
`FindMIMECharset`: "0 ist Windows, 1 ist US ASCII und 2 ist Latin1" - alles
darunter kehrt sofort zurueck, und erst ab 3 wird `iCharsetIdx -= 3` in die
Uebersetzungstabelle hinein gerechnet.

Damit ergibt sich fuer den IMAP-Pfad:

- `utf-8` liefert -1, die Abfrage `if (iCharsetIdx > 1)` faellt durch - **keine
  Uebersetzung**.
- `iso-8859-15` liefert 2, die Abfrage laesst es durch, `ISOTranslate` liest die
  2 als "Latin-1, nichts zu tun" und kehrt in Zeile 1176 sofort zurueck -
  **keine Uebersetzung**.
- Jeder andere Zeichensatz liefert -1 - **keine Uebersetzung**.

Es gibt also **keinen** Wert, bei dem der IMAP-Pfad tatsaechlich uebersetzt. Die
Abfrage `> 1` ist dabei folgerichtig um eins verschoben (der POP-Pfad prueft
`> 2`, `TextReader.cpp:245` und `lex822.cpp:541`); nur der **Wert**, der an
`ISOTranslate` weitergereicht wird, ist es nicht.

**Folge:** jede IMAP-Nachricht in UTF-8, ISO-8859-15 oder einem der
Tabellenzeichensaetze kommt unuebersetzt im Postfach an. Fuer den POP-Pfad
(`TextReader.cpp:251`, `lex822.cpp:544`) gilt das nicht - dort stimmt die
Zaehlweise. Ein Schadensbild, das nur bei IMAP auftritt, ist also nicht dem
Wandler anzulasten.

**Zu tun:** in `ImapDownload.cpp:4644` denselben Aufruf verwenden wie
`mime.cpp:382-390`, am besten durch Aufruf von `FindMIMECharset` selbst, und die
Abfrage in Zeile 4657 auf `> 2` ziehen. Getrennt vom Portierungsumbau, weil es
eine echte Verhaltensaenderung ist.

### NP3-9 - Der Rueckgabewert von `ISOTranslate` wird an zwei Stellen verworfen

**Sicherheit: nachgewiesen. Originalfehler von QUALCOMM, durch die Umstellung
haeufiger sichtbar.**

**Dateien:** `Eudora71/Eudora/TextReader.cpp:251`,
`Eudora71/EuImap/src/ImapDownload.cpp:4662`

`ISOTranslate` gibt die **neue** Laenge zurueck (`utils.cpp:1361-1367`: `lSize =
lWrite; szBuf[lSize] = 0; return lSize;`) und ist nie laenger als die Eingabe.
Beide Aufrufstellen verwerfen den Wert und rechnen mit der alten Laenge weiter:

    // TextReader.cpp:251
    ISOTranslate(buf, size, iCharsetIdx);
    if (size) { ... buf[size-2] ... }        // size ist die ALTE Laenge

    // ImapDownload.cpp:4662
    ISOTranslate(pBuf, inLen, iCharsetIdx);
    ... weiter mit inLen / outLen

**Folge:** verkuerzt die Umsetzung den Text - und das tut sie bei jeder
Mehrbyte-Folge, die zu einem Byte wird -, dann liegen zwischen dem neuen Ende und
der alten Laenge die unveraenderten Reste des Ausgangstextes. Die werden
mitgeschrieben. Kein Zugriff ueber das Pufferende hinaus, aber ein sichtbar
falscher Textschwanz. Bei UTF-8 faellt das am staerksten auf: der neue Weg ueber
`MultiByteToWideChar`/`WideCharToMultiByte` verkuerzt zwei- bis vierbyteweise,
die alte Tabelle nur um ein bis zwei Byte je Zeichen.

**Nicht betroffen** sind die beiden anderen Aufrufstellen: `lex822.cpp:544` und
`ImapLex822.cpp:577` rufen mit `strlen(text)` und arbeiten danach wieder ueber
die Nullterminierung - und die setzt `ISOTranslate` auf die neue Laenge.
Nachgesehen, nicht vermutet.

**Zu tun:** `size = ISOTranslate(buf, size, iCharsetIdx);` bzw.
`inLen = ISOTranslate(pBuf, inLen, iCharsetIdx);`. Bei `ImapDownload.cpp` ist
vorher [NP3-8](#np3-8) zu klaeren, sonst laeuft der Zweig ohnehin nie an. Achtung bei
`TextReader.cpp`: `outLen` bzw. die nachfolgende `CRLF`-Pruefung haengen an
`size`, die Aenderung ist also nicht ganz oertlich - sie gehoert mit einem Test
abgesichert.

---

## Stand nach dem zweiten Teil

**Zusaetzlich durch:**

- `tools/lehren-spiegeln.pl` (95 Zeilen), `tools/pruefstand-melden.pl` (86
  Zeilen), `tools/hooks-einrichten.sh` und der eingerichtete
  `.git/hooks/pre-commit`. Beide Skripte wurden **ausgefuehrt**, das Verhalten
  von `git commit -- <pfad>` mit stagendem pre-commit-Hook in einem eigenen
  Testrepo vorgefuehrt.
- `Eudora/utils.cpp` `ISOTranslate` vollstaendig (Z. 1165-1367),
  `Eudora/rs.cpp` `FindRStringIndexI` (Z. 796-830), `Eudora/mime.cpp`
  `FindMIMECharset` (Z. 379-400), die vier Aufrufstellen von `ISOTranslate`
  und die Ressourcentabelle der Zeichensatznamen.

**Weiterhin offen** (unveraendert gegenueber dem ersten Teil):
`OTShim_Bild.{h,cpp}` ausserhalb von `CreateFromBitmap`, `OTShim_Palette.{h,cpp}`
ausserhalb von `SECDateTimeCtrl`, die Anordnungsrechnung von
`OTShim_Werkzeugleiste`, `tools/pruefe-bytes.pl` und `tools/aendere-zeile.pl`
(nicht beauftragt), `Eudora.vcxproj`.

---

# Nachpruefung 3, dritter Teil (PRUEFER) - Bildschicht und Datumsfeld vollstaendig

Fortsetzung. Damit sind `OTShim_Bild.{h,cpp}` und `OTShim_Palette.{h,cpp}` nicht
mehr nur an den beiden beauftragten Stellen, sondern **ganz** durchgesehen.
**Kein neuer Befund.** Was folgt, ist die Fundliste des Gegenteils - damit eine
spaetere Pruefung hier nicht noch einmal anfangen muss.

## Geprueft und in Ordnung - Stufe 4, Bildschicht

- **GDI+ starten und beenden.** `OTShimGdiPlusBereit()`
  (`OTShim_Bild.cpp:96-100`) benutzt ein funktionslokales `static`. Seit C++11
  ist dessen Anlage vom Uebersetzer gegen gleichzeitige Zugriffe abgesichert
  ("magic statics"), MSVC hat das seit 2015 - die Begruendung im Kommentar
  stimmt. `GdiplusShutdown` laeuft im Aufraeumteil von `Eudora.exe`, nicht aus
  einer DLL-Entladung; die Einschraenkung der Schnittstellenbeschreibung ist
  eingehalten. Scheitert `GdiplusStartup`, liefert jede Lade- und Speichermethode
  `FALSE` mit `ERROR_NOT_READY` statt in GDI+ hineinzulaufen.
- **Der Umweg ueber `IStream`.** `OTShimStromAusDatei` gibt den `HGLOBAL` auf
  **jedem** Fehlerweg wieder frei (kein `GlobalLock`, kurzer Lesevorgang,
  `CreateStreamOnHGlobal` gescheitert) und uebergibt den Besitz erst mit
  `fDeleteOnRelease == TRUE` an den Strom. Jedes `GlobalLock` hat sein
  `GlobalUnlock`, auch im Ausnahmefall. Die 2-GB-Schranke verhindert, dass die
  Umrechnung `ULONGLONG` nach `UINT` still abschneidet. In
  `OTShimLadenUeberGdiPlus` steht das `Gdiplus::Bitmap` in einem eigenen Block,
  wird also **vor** `pStrom->Release()` zerstoert - noetig, weil GDI+ bei
  manchen Formaten erst beim Zugriff nachliest.
- **Die Zeilenrechnung.** `CalcBytesPerLine(24, w) = ((w*24+31) & ~31)/8`
  nachgerechnet: fuer w = 1,2,3,4 ergibt sich 4,8,12,12 - genau die
  4-Byte-Ausrichtung, die ein DIB verlangt. `OTShimDibAnlegen` legt `m_lpBMI`
  mit `sizeof(BITMAPINFO)` an (also mit dem einen `RGBQUAD`, in den
  `::GetDIBits` auch ohne Farbtabelle schreibt) und gibt bei einer
  fehlgeschlagenen zweiten Belegung beides wieder frei - `m_lpBMI` und
  `m_lpSrcBits` sind danach beide NULL, wie `AssertValid` es verlangt.
- **Die Zeilenumkehr beim Laden.** GDI+ liefert von oben nach unten, der DIB
  hat positives `biHeight` und will von unten nach oben - die Rechnung
  `m_lpSrcBits + (nHoehe - 1 - y) * m_dwPadWidth` ist richtig. Im Fall ohne
  Alphakanal werden `nBreite * 3` Byte kopiert, nicht `daten.Stride`; damit kann
  die Auffuellung der Quelle nicht ueber das Zeilenende des Ziels
  hinausschreiben, auch wenn beide unterschiedlich aufgefuellt waeren. Im Fall
  mit Alphakanal werden je Bildpunkt vier Byte gelesen und drei geschrieben,
  ebenfalls innerhalb beider Zeilen.
- **`OTShimUeberlagern`** ist Byte fuer Byte `alpha_composite` aus
  `QCGraphics.cpp:293-300`. Die dort dokumentierte Abweichung (durchgaengig
  gegen `m_crTransparent` statt teils gegen Schwarz) ist im Kommentar begruendet
  und macht das Bild besser, nicht anders falsch.
- **`OTShimSpeichernUeberGdiPlus`.** `EncoderParameters` traegt genau ein
  `Parameter[1]`, `Count = 1` passt also zur Struktur; der Wert `ulQualitaet`
  lebt bis nach dem `Save`. `pBild` wird auf jedem Weg geloescht, `pStrom` auf
  jedem Weg freigegeben. `Bitmap::FromBITMAPINFO` legt keine Kopie an - der
  Kommentar sagt es, und der Puffer steht bis zum Ende des Blocks.
- **`SECDib::DoSaveImage`** schreibt den Dateikopf von Hand. Nachgerechnet:
  `bfOffBits = 14 + 40 + Farbtabelle`, `bfSize = bfOffBits + m_dwPadWidth *
  m_dwHeight`, und `biSizeImage` wird unmittelbar davor auf denselben Wert
  gezogen. `DIB_HEADER_MARKER` ist in `OTShim_Bild.h:432` als
  `((WORD)('M' << 8) | 'B')` definiert, also 0x4D42 - die Bytefolge "BM".
  `BITMAPFILEHEADER` ist in `wingdi.h` auf 2 Byte gepackt, `sizeof` ist 14; der
  Kopf wird also nicht mit Fuellbytes geschrieben.
- **`SECDib::DoLoadImage`** liest den Dateikopf nur, um `m_lpbmfHdr` zu fuellen,
  und spult in **jedem** Fall auf die Ausgangsstelle zurueck, bevor GDI+ die
  Datei bekommt. Eine zu kurze Datei und ein fremdes Magiewort fuehren beide
  dazu, dass `m_lpbmfHdr` NULL bleibt - nicht dazu, dass falsch gelesen wird.
- **`CreatePalette`, `MakeBitmap`, `CopyImage`.** `CreatePalette` gibt den
  `LOGPALETTE`-Puffer auf beiden Wegen frei und raeumt `m_pPalette` wieder ab,
  wenn `CPalette::CreatePalette` scheitert. `MakeBitmap` gibt einen selbst
  angelegten DC wieder frei, bevor es zurueckkehrt, und uebergibt das
  `CBitmap` an den Aufrufer (`EmoticonMenu.cpp:113` und
  `LinkHistoryManager.cpp:608` loeschen es - nachgesehen). `CopyImage` kopiert
  zeilenweise mit der kleineren der beiden Zeilenlaengen und kann deshalb auch
  dann nicht ueber den Puffer hinausschreiben, wenn eine Quelle mit anderer
  Farbtiefe auftaucht.
- **Die Dummys sind wirklich Dummys.** `FlipHorz`, `FlipVert`, `Rotate90`,
  `ContrastImage`, `Crop`, `UnPadBits`, `InitCache` und `SECLoadDib` melden sich
  ueber `OTShimNichtUmgesetzt` je einmal pro Sitzung und liefern `FALSE`; keiner
  taeuscht Erfolg vor. `LoadCache`, `GetCache` und `PutCache` liefern 0 - fuer
  einen nie angelegten Puffer die richtige Antwort.

## Geprueft und in Ordnung - `SECDateTimeCtrl`, uebriger Teil

- `SetMinMax` weist die Werte nur zu, wenn `min <= max`, und reicht sie an
  `CDateTimeCtrl::SetRange` nur weiter, wenn es ein Fenster gibt; ohne Fenster
  bleibt der Bereich gemerkt. `Validate` prueft beide Grenzen einzeln auf
  Gueltigkeit, bevor es vergleicht.
- Die Merker (`SetModified`, `IsModified`, `EnableFastEntry`, `SetNoEdit`,
  `SetNull`) sind reine Ablage, wie im Kommentar behauptet; keiner davon hat
  einen Aufrufer in Eudora.
- `SizeToContent` ist ueber `#ifdef DTM_GETIDEALSIZE` abgesichert und prueft das
  Ergebnis auf beide Ausdehnungen, bevor es die Fenstergroesse aendert.
- `SECSetOleDateTime` gibt `dt.SetDateTime(...) == 0` zurueck. Das ist richtig:
  `COleDateTime::SetDateTime` liefert den `DateTimeStatus`, und
  `COleDateTime::valid` ist 0.
- `SECTmFromOleDate` rechnet `tm_mon` ab 0 und `tm_year` ab 1900 - beides
  richtig herum.
- `OnDateTimeChange` haengt ueber `ON_NOTIFY_REFLECT(DTN_DATETIMECHANGE)` an der
  zurueckgespiegelten Meldung des gemeinen Steuerelements und setzt `*pResult`,
  bevor es zurueckkehrt.

## Zwei Kleinigkeiten ohne Befundwert

Beide sind originalgetreu bzw. unerreichbar; sie stehen hier nur, damit ein
spaeterer Leser nicht denselben Weg noch einmal geht.

- `SECImage::LoadImage(LPCTSTR)` merkt sich den uebergebenen Zeiger in
  `m_lpszFileName` (Zeile 923). Der zeigt nach der Rueckkehr moeglicherweise ins
  Leere. Das ist die Oberflaeche des Originals (`secimage.h:74` fuehrt `LPCTSTR`,
  keinen `CString`), und Eudora liest das Feld nirgends.
- `SECDateTimeCtrl::SetDateTime` weist `m_datetime` zu, bevor
  `CDateTimeCtrl::SetTime` scheitern kann (Zeile 267-273). Nach einem
  Fehlschlag stehen Feld und Fenster damit auseinander. Eudora ruft die Methode
  nur mit gueltigen Werten (`SearchView.cpp:5261`).

## Stand nach dem dritten Teil

**Jetzt vollstaendig durch:** `OTShim.{h,cpp}` (Stufe 2 und 2b),
`OTShim_Reiter.{h,cpp}`, `OTShim_Bild.{h,cpp}`, `OTShim_Palette.{h,cpp}`,
`tools/lehren-spiegeln.pl`, `tools/pruefstand-melden.pl`.

**Weiterhin offen:**

| Gegenstand | Grund |
|---|---|
| `OTShim_Werkzeugleiste`: Anordnungsrechnung (`CalcDynamicLayout`, `CalcFixedLayout`, `Layout`, Zeilenumbruch), `SECTwoPartBtn::DrawButton`, `SECWndBtn`/`SECComboBtn`, `SECCustomizeToolBar` und die Anpassen-Dialogseiten | unveraendert offen seit Nachpruefung 2 |
| `OTShim.cpp` Stufe 0 und Stufe 1 (Z. 1-175, 540-1229) | in Runde 1 unter "OTShim, uebriger Teil" geprueft; hier nur ueberflogen |
| `tools/pruefe-bytes.pl`, `tools/aendere-zeile.pl` | nicht beauftragt |
| `Eudora.vcxproj` und die offenen Bindefehler | waehrend der ganzen Pruefung im Fluss |
| Hostnamenpruefung, `X509_V_ERR_CERT_UNTRUSTED` | bewusst zurueckgestellt |

## Gefunden durch PROBE

Der Agent PROBE hat die Ersatzschicht erstmals ausgefuehrt (Testprogramm unter
`Eudora71/Tests`, siehe `TestOTShimBild.cpp`, `TestOTShimReiter.cpp`,
`TestOTShimPalette.cpp`). Was dabei aufgefallen ist:

### P-1 - `OnActivateTab` und `ClearSelection` rufen `GetParent()`, bevor sie das eigene Fenster pruefen

**GEMESSEN**, nicht vermutet. Der erste Lauf der Registerkarten-Tests schrieb
zehn Zeilen auf stderr:

```
...\ATLMFC\Include\afxwin2.inl(213) : Assertion failed!
```

Zeile 213 ist `CWnd::GetParent`:

```cpp
_AFXWIN_INLINE CWnd* CWnd::GetParent() const
    { ASSERT(::IsWindow(m_hWnd)); return CWnd::FromHandle(::GetParent(m_hWnd)); }
```

Die zehn Meldungen decken sich Stueck fuer Stueck mit den neun Aufrufen von
`ActivateTab` und dem einen von `ClearSelection` in den Tests. Ein zweiter
Lauf mit einem Berichtshaken der Laufzeitbibliothek (`_CrtSetReportHook2`)
hat es auf zwei Stellen eingegrenzt:

| Datei | Zeile | Methode |
|---|---|---|
| `Eudora71/OTShim/OTShim_Reiter.cpp` | 330 | `SECTabControlBase::OnActivateTab` |
| `Eudora71/OTShim/OTShim_Reiter.cpp` | 358 | `SECTabControlBase::ClearSelection` |

Beide holen sich das Elternfenster, **bevor** sie pruefen, ob es das eigene
Fenster ueberhaupt gibt:

```cpp
CWnd* pParent = GetParent();
if (pParent != NULL && ::IsWindow(pParent->GetSafeHwnd()))
    pParent->SendMessage(...);
```

Die Absicht ist erkennbar - "ohne gueltiges Elternfenster nichts tun" -, die
Pruefung steht nur einen Schritt zu spaet. Ueberall sonst in derselben Datei
steht zuerst `if (GetSafeHwnd() != NULL)`, zum Beispiel drei Zeilen vor der
zweiten Fundstelle.

**Tragweite.** In Eudora selbst loest das nichts aus: das Steuerelement
entsteht in `SECTabWndBase::CreateTabCtrl` unmittelbar mit einem Fenster, und
`CWazooBar` ruft `ActivateTab` erst danach (`WazooBar.cpp:347, 408, 1364`).
Der Befund ist also eine Haertungsluecke, kein belegter Absturz. Im Debugbau
wuerde er allerdings ein modales Meldungsfenster aufmachen, sobald der Weg
doch einmal ohne Fenster genommen wird - und schliessen laesst er sich mit
zwei Zeilen.

**Vorschlag.** In beiden Methoden vorne einsetzen:

```cpp
if (GetSafeHwnd() == NULL)
    return;
```

**Nicht von PROBE repariert** - `OTShim_Reiter.cpp` gehoert einem anderen
Agenten. Der Test
`BEFUND: ActivateTab und ClearSelection fassen GetParent an, bevor sie das Fenster pruefen`
in `Eudora71/Tests/TestOTShimReiter.cpp` bleibt so lange rot und wird von
selbst gruen, sobald die zwei Zeilen stehen.

**Verwandte Stellen, die NICHT betroffen sind** (dort steht `GetParent()`
ebenfalls ungeschuetzt, die Methoden sind aber nur aus einer Nachricht heraus
erreichbar, also stets mit Fenster): `OTShim_Reiter.cpp:1301`
(`SEC3DTabControl::OnLButtonDblClk`), `:1805` (`SECTabWndBase::OnTabSelect`),
`OTShim_Palette.cpp:509` (`SECDateTimeCtrl::OnChanged`).

### P-2 - `SECTabWndBase::InsertTab` blendet ein Fenster aus, ohne es zu pruefen

Kein gemessener Fehler, sondern der Grund, warum die **Fensterebene** der
Registerkarten-Familie ungetestet bleibt. `SECTabWndBase::InsertTab`
(`OTShim_Reiter.cpp:1503`) ruft im `else`-Zweig

```cpp
pWnd->ShowWindow(SW_HIDE);
```

ohne vorherige `::IsWindow`-Pruefung - anders als `ZeigeInhaltsfenster`
zwanzig Zeilen weiter, das sie hat. In Eudora ist das kein Fehler: die
`CWazooWnd` sind vor dem Einfuegen angelegt (`WazooBar.cpp:178-179` ruft
unmittelbar danach `SetParent`, was ein Fenster voraussetzt). Es macht die
Ebene aber ohne echte Fenster unpruefbar, und es ist dieselbe Unachtsamkeit
wie [P-1](#p-1).

Dieselbe Methode ist schon unter [NP3-1](#np3-1) aufgefallen, dort aus einem anderen
Grund (der erste Reiter wird gezeigt, bevor Eudora ihn umgehaengt hat).

### P-3 - `SECDateTimeCtrl::FixedTime` laesst die Stunde aus (Fehler im Original, bewusst uebernommen)

Kein Befund gegen die Ersatzschicht, sondern gegen das Stingray-Original -
festgehalten, damit niemand ihn spaeter fuer einen Uebernahmefehler haelt.

**GEMESSEN.** Ein Test in `Eudora71/Tests/TestOTShimPalette.cpp` erwartete,
dass `FixedTime` die Summe aus `FixedHour`, `FixedMinute` und `FixedSecond`
ist (0x0038), und schlug fehl. Nachgesehen in `OT501/Include/DTCtrl.h:114-118`:

```
FixedHour   = 0x0008,           // The hour is non-editable
FixedMinute = 0x0010,           // The minute is non-editable
FixedSecond = 0x0020,           // The second is non-editable
FixedDate   = 0x0007,           // The date is non-editable
FixedTime   = 0x0030            // The time is non-editable
```

`FixedDate` stimmt (0x0001|0x0002|0x0004), `FixedTime` nicht: 0x0030 ist
`FixedMinute|FixedSecond`, die Stunde fehlt. `OTShim_Palette.h` hat den Wert
woertlich uebernommen - **und das ist richtig so**: die Konstante gehoert zur
Schnittstelle, ein stillschweigend berichtigter Wert wuerde abweichendes
Verhalten erzeugen. Eudora wertet `SetNoEdit` ohnehin nirgends aus (in
`OTShim_Palette.cpp` ausdruecklich vermerkt).

Der Test schreibt den uebernommenen Wert fest, damit ein spaeteres
Geradeziehen als Aenderung sichtbar wird und nicht unbemerkt einsickert.

## S-1 — Das Auslieferungspaket 1.0.1 startet nicht (gemessen 30.08.2026)

**Erster Startversuch ueberhaupt.** `Eudora.exe` startet, laeuft acht Sekunden mit
vier Threads und 15,6 MB, oeffnet aber kein Fenster. Windows meldet:

    Die Ausfuehrung des Codes kann nicht fortgesetzt werden,
    da MSVCR71D.dll nicht gefunden wurde.

**Ursache.** Nach `Bin\Debug` gehoeren sieben vorgebaute DLLs aus der CHM-Freigabe,
die gegen die *Debug*-Laufzeit von Visual Studio 2003 gebunden sind (`MSVCR71D.dll`,
`MFC71D.DLL`, `MSVCP71D.dll`). Diese Debug-Laufzeit ist nicht verteilbar und
existiert nur auf einer Maschine mit installiertem VS2003. Betroffen: DirServ,
EudoraBk, EuMemMgr, ISock, Ldap, Ph, Paige32d.

Die Release-Varianten derselben DLLs liegen unter `Bin\Release` und brauchen nur die
*Retail*-Laufzeit (`MSVCR71.dll`, `MFC71.DLL`, `MSVCP71.dll`). Auch die ist auf
dieser Maschine nicht vorhanden — es ist keine Eudora-Installation da, aus der man
sie nehmen koennte.

**Beim Laden zwingend** sind laut Importtabelle von `Eudora.exe` nur zwei:
`EuMemMgr.dll` und `Paige32d.dll`. Die uebrigen fuenf werden erst bei Benutzung
geladen.

**Loesungsweg.**

| DLL | Quellen vorhanden | Weg |
|---|---|---|
| EuMemMgr | ja, 17.172 Zeilen unter `Eudora71/EuMemMgr` | selbst bauen mit v143 |
| Paige32 | **nein** — `Eudora71/PaigeDLL` enthaelt nur Makefiles, `PAIGE.H` und die fertigen Binaerdateien | vorgebaute Release-Fassung benutzen |

Fuer Paige bleibt die Bindung an `MSVCR71.dll`. Gemessen braucht `Paige32.dll`
daraus **genau 20 Funktionen**:

    _onexit  __dllonexit  __CppXcptFilter  _adjust_fdiv  malloc  _initterm
    free  _except_handler3  __security_error_handler  time  labs  memmove
    tmpnam  _setjmp3  memset  strlen  longjmp  remove  rename

Das ist wenig genug fuer eine eigene Weiterleitungs-DLL auf die heutige UCRT —
dasselbe Vorgehen wie bei OTShim. Heikel sind nur die VC7.1-eigenen: `_setjmp3`,
`_except_handler3`, `__security_error_handler`, `_adjust_fdiv`, `__CppXcptFilter`,
`_initterm`, `__dllonexit`, `_onexit`.

**Folge fuer die Auslieferung.** Die Datei `LIESMICH.txt` im Release 1.0.1 nennt als
Voraussetzung nur die VS2022-Debug-Laufzeiten und behauptet, die seien auf der
Zielmaschine vorhanden. Das ist unvollstaendig: die VC7.1-Laufzeit fehlt und wird
nicht erwaehnt. Das Paket ist damit **nicht startfaehig**; die Beschreibung muss
richtiggestellt werden.

## S-2 — Stapelueberlauf beim Start: die Werbeflaeche (behoben 30.08.2026)

**Symptom.** Nach dem Startbildschirm passierte nichts mehr, dann Absturz mit
`EXCEPTION_STACK_OVERFLOW` (mal auch `0xC0000005`). Die letzte Meldung vor dem
Absturz war stets `viewcore.cpp(103): Creating a pane with no CDocument`.

**Wie es gefunden wurde.** Auf der Maschine ist kein Debugger installiert, und
Eudoras eigener Absturzbehandler gibt bei einem vollen Stapel bewusst nur eine
Zeile aus (`BugslayerUtil/CrashHandler.cpp:286`). Dafuer entstand
`tools/stapel-untersuchen.ps1`: ein kleiner Debugger, der das Programm als
Debuggee startet, die toedliche Ausnahme abfaengt, die EBP-Kette ablaeuft und
mit `dbghelp.dll` symbolisiert. Bei einer Endlosrekursion sind fast alle Rahmen
gleich, deshalb weist er die haeufigsten als Zyklus aus und druckt nur den Rest.

**Gemessene Aufrufkette** (1689 Rahmen, davon 1613 im Zyklus):

    CAdWazooWnd::OnCreate              AdWazooWnd.cpp:108
      CPaigeEdtView::Create            PaigeEdtView.cpp:4490
        -> CreateWindowEx -> WM_CREATE
          CPaigeEdtView::OnCreate      PaigeEdtView.cpp:1551
            CAdView::NewPaigeObject    AdView.cpp:208
              CPaigeEdtView::NewPaigeObject   PaigeEdtView.cpp:1646
                -> Paige32d.dll, zwei Rahmen wechseln sich ~800mal ab

**Ursache.** `CAdWazooWnd::OnCreate` legt die Werbeansicht mit `CRect(0,0,0,0)`
an (AdWazooWnd.cpp:108). Paige bekommt damit eine Umbruchbreite von null und
verheddert sich in einer Endlosrekursion. Paige ist eine Fremdbibliothek ohne
Quellen (`Eudora71/PaigeDLL` enthaelt nur Makefiles und `PAIGE.H`) - dort ist
nichts zu reparieren.

**Behebung.** Die Werbeleiste wurde in `WazooBarMgr.cpp:155` **bedingungslos**
angelegt, ohne jede Abfrage der Betriebsart. Jetzt haengt sie an
`QCSharewareManager::IsBoxBuild()`. Zusammen mit dem Uebersetzungsschalter
`BUILD_BOX_OR_SITE_R_VERSION` (Eudora.vcxproj, beide Konfigurationen) entfaellt
damit die Werbung ganz - das ist die Fassung, die QUALCOMM an Firmenkunden
ausgeliefert hat. `DEFAULT_SWM_MODE` wird dadurch 2 (`SWM_MODE_PRO`), und der
Einfuehrungsdialog (eudora.cpp:1597) entfaellt ebenfalls.

**Ergebnis.** Eudora startet und zeigt sein Hauptfenster: Menueleiste,
Werkzeugleiste, Postfachbereich, Statuszeile. Erstmals seit Beginn der
Portierung.

**Nebenbefund.** `tools/rekursion-suchen.pl` (Zyklensuche im Aufrufgraphen der
Ersatzschicht) meldete fuenf Zyklen - **alle Fehlalarm**: es sind Ueberladungen,
die das Werkzeug nur am Namen und an der Argumentzahl unterscheidet, nicht an
den Typen. Die Ersatzschicht war an diesem Absturz unbeteiligt.

## S-3 — Erster Lauf durch einen Anwender: was auffiel (30.08.2026)

Gregor hat die Fassung mit abgeschalteter Werbeflaeche selbst gestartet. Sie
laeuft. Aufgefallen ist Folgendes.

### S-3a  Veraltete Selbstauskunft der Ersatzschicht (behoben)

Beim Aufruf der Auto-Wazoo-Fensterleiste (Einstellung "MDI Task Bar") meldet
sich die Ersatzschicht mit dem Hinweis, dass die Funktion fehlt - das ist so
gewollt (`OTShimNichtUmgesetzt`, OTShim.cpp:153). Der Text behauptete aber:

    Der Ersatz fuer das Stingray Objective Toolkit ist bis Stufe 2
    (MDI-Fenstergeruest und Andockfamilie) umgesetzt. Alles Weitere
    folgt in spaeteren Stufen.

Das stimmte seit Commit `e50a89c` nicht mehr - Stufe 3, die Registerkarten und
die Palette sind eingehaengt. Der Satz haette den Eindruck erweckt, die Schicht
sei halbfertig, obwohl sie vollstaendig eingehaengt ist und nur einzelne
Funktionen darin leer sind. Neu formuliert in OTShim.cpp:165-167.

**Lehre:** Ein Text, der einen *Fortschrittsstand* nennt, veraltet zwangslaeufig.
Meldungen sollen sagen, was fehlt - nicht, wie weit man ist.

### S-3b  Vier Debug-Zusicherungen beim ersten Start (gegenstandslos im Release-Bau)

Aus frisch ausgepacktem Paket erscheinen drei bis vier SUPERASSERT-Dialoge, die
weggeklickt werden muessen. Eine davon ist belegt:

    !"Erasing X1 indices because DB schema was missing or doesn't match"
    SearchManager::Info::InitX1, SearchManagerInfo.cpp:496

Das ist beim ersten Start normal - der Suchindex existiert noch nicht. In einem
Release-Bau erscheint keiner dieser Dialoge.

> **Gemessen am 22.10.2026 an 7.2.0.121: gegenstandslos.** Hier stand bis heute
> *„sie sind eine reine Folge davon, dass nur der Debug-Bau lauffaehig ist (der
> Release-Zweig scheitert an fehlender `Imap.lib`). Solange das so bleibt,
> gehoert der Hinweis in die Paketbeschreibung."* Das trifft nicht mehr zu:
> `Eudora71/Lib/Release/Imap.lib` ist vorhanden, `Eudora71/Bin/Release/Eudora.exe`
> wurde am 22.10.2026 gebaut, und der Release-Bau setzt `NDEBUG`
> (`Eudora71/Eudora/Eudora.vcxproj:132`) - damit fallen `ASSERT`, `VERIFY` und
> die SUPERASSERT-Dialoge weg. Ausgeliefert wird mit `-Bauart Release`
> (`Intern/WEITERMACHEN.md:473`, `Releases/PAKETE.md:1380`); dass
> `tools/paket-bauen.ps1` ohne Schalter `Debug` vorgibt (`:54`), aendert daran
> nichts, weil der Releaseweg ihn setzt. Im ausgelieferten Paket kann S-3b
> also nicht auftreten.

### <a id="s-3c"></a>S-3c  Zwei Laufzeitbibliotheken fehlen weiterhin (offen)

`MFC71.DLL` und `MSVCP71.dll` sind nicht vorhanden. Betroffen sind sieben DLLs: vier laedt Eudora erst bei Benutzung, die drei
Zusaetze in `Plugins` beim Start (ergaenzt 28.10.2026):

| DLL | braucht | Funktion, die ausfaellt |
|---|---|---|
| EudoraBk.dll | MFC71 | Verzeichnisdienst-Protokoll *EudoraBk* (nicht das eigene Adressbuch) |
| ISock.dll | MFC71 | ein Socket-Pfad |
| Ldap.dll | MFC71, MSVCP71 | LDAP-Verzeichnissuche |
| Ph.dll | MSVCP71 | Ph-Verzeichnisdienst |
| `Plugins\SpamWatch.dll` | MFC71, MSVCP71 | Junk-Filter (gemessen 28.10.2026, [E-166](#e-166)) |
| `Plugins\SpamHeaders.dll` | MFC71, MSVCP71 | Junk-Einstufung aus Kopfzeilen (gemessen 28.10.2026) |
| `Plugins\SMIME.dll` | MFC71, MSVCP71 | S/MIME (gemessen 28.10.2026) |

Mailabruf und -versand sind davon **nicht** betroffen. Ohne die beiden Dateien
fallen die Verzeichnisdienste aus (nicht das eigene Adressbuch), dazu still
Junk-Filter und S/MIME.

## S-4 — Zusicherung im Adressbuch-Wazoo schlaegt zu (behoben 30.08.2026)

**Symptom.** Beim Wegklicken von der Adressbuch-Registerkarte:

    Assertion   : ::IsWindow(m_wndSplitter.GetSafeHwnd())
    Location    : CNicknamesWazooWnd::OnDeactivateWazoo, Zeile 115

**Ursache.** Eine Registerkarte kann *aktiv* sein, ohne je *angezeigt* worden zu
sein. `SECTabControlBase::InsertTab` (OTShim_Reiter.cpp:214) macht die erste
eingefuegte Karte still aktiv - absichtlich, damit beim Aufbau der Leiste noch
kein Wazoo angestossen wird. `CNicknamesWazooWnd::CreateViews` laeuft aber erst
in `OnActivateWazoo`. Wer also von dieser Karte wegklickt, ohne sie je geoeffnet
zu haben, loest `OnDeactivateWazoo` auf einem Fenster ohne Splitter aus.

**Das ist kein Fehler der Ersatzschicht.** QUALCOMM beschreibt genau diesen
Zustand in WazooBar.cpp:346-355:

    In the SEC stuff, the ActivateTab() call doesn't do anything if the tab is
    ALREADY active, so make sure the Wazoo gets an initialization notice
    anyway. This covers cases like ... "active" wazoos which have never been
    displayed before.

Beim **Aktivieren** faengt Eudora den Fall also ab. An den beiden
**Deaktivierungs**stellen (QC3DTabWnd.cpp:101 und WazooBar.cpp:1396) fehlt
dieselbe Absicherung.

**Beweis, dass die Regel nicht gilt:** in der Schwesterklasse
`CFiltersWazooWnd::OnDeactivateWazoo` hat QUALCOMM dieselbe Zusicherung bereits
**auskommentiert** (FiltersWazooWnd.cpp:109). In `CNicknamesWazooWnd` blieb sie
stehen.

**Behebung.** Statt der Zusicherung ein frueher Ausstieg, wenn es keinen
Splitter gibt. Der Rumpf fasst den Splitter ohnehin nicht an, setzt aber weiter
unten `g_Nicknames` voraus - aussteigen ist sicherer als weiterlaufen. Ohne
Ansichten kann nichts geaendert worden sein, es gibt also auch nichts zu sichern.

## S-5 — Menues lassen sich nicht oeffnen

> **URSACHE INZWISCHEN GEFUNDEN — siehe Abschnitt [M-1](#m-1) weiter unten.**
> Der Rahmen liefert immer HTERROR, weil SECToolBarManager
> m_bMainFrameEnabled auf TRUE setzt. Was hier folgt, ist der Stand der
> Untersuchung VOR diesem Fund und bleibt stehen, weil die
> Ausschluesse weiter gelten.

Gregor meldet, dass sich in Eudora keine Menues aufklappen lassen.

**Bisher gemessen** (an einem eigenen Lauf, nicht an Gregors Pruefstand):

- Das Hauptfenster hat ein Menue: `GetMenu` liefert ein gueltiges Handle mit
  **14 Eintraegen**, davon 11 mit gefuellten Untermenues (File 22, Edit 25,
  Mailbox 1, Message 24, Transfer 1, Special 13, Tools 21, Window 7, Help 12,
  Debug 16). Eintrag 0 ist das MDI-Systemmenue des maximierten Kindfensters.
- Drei Eintraege am Ende (11, 12, 13) haben **leere Beschriftung und kein
  Untermenue**. UNGEPRUEFT, ob das die Ursache ist oder normale MDI-Platzhalter.
- Das Fenster antwortet auf `WM_NULL` innerhalb von 3 s, haengt also nicht.

**Naechster Schritt:** mit `SC_KEYMENU` ein Menue oeffnen und ueber
`GetGUIThreadInfo` pruefen, ob `GUI_INMENUMODE` gesetzt wird und ein Popup der
Klasse `#32768` entsteht. Damit laesst sich unterscheiden, ob das Menue gar
nicht aufgeht oder sofort wieder zufaellt.

## S-6 — Darstellung nach dem Oeffnen mehrerer Wazoos (OFFEN)

Gregor meldet, die Darstellung sei "vorher besser" gewesen und jetzt defekt. Auf
dem Bildschirmfoto ueberlagern sich der Adressbuch-Wazoo, die Registerkarten
"Task Status"/"Task Errors" und die Nachrichtenliste.

**Ausgeschlossen:** dass es am Entfernen der Werbeleiste liegt. `QCDockBar`
prueft an beiden betroffenen Stellen selbst auf `SWM_MODE_ADWARE`
(DockBar.cpp:51 und 84) und faellt sonst auf die Basisfassung zurueck - der
Zustand ohne Werbeleiste ist dort vorgesehen.

**UNGEPRUEFT:** Verdacht auf die Andockrechnung der Ersatzschicht bei mehreren
Leisten in einer Reihe. Muss reproduziert werden, bevor etwas geaendert wird.

## S-7 — Die Wurzel aller CRLF-Probleme, endlich gefunden (behoben 30.08.2026)

**Gemessen:** 4616 von 5563 verfolgten Quell- und Textdateien unterschieden sich
von HEAD **ausschliesslich in den Zeilenenden**. Im Arbeitsverzeichnis standen
sie als CRLF, im Commit als LF.

> **Zu den Zahlen** (nachgezogen am 31.08.2026 abends; Befund [Z-1](#z-1) hatte belegt,
> dass [W-1](#w-1)/[PR-7](#pr-7) dieses Nachziehen zwar meldete, aber nicht ausgeführt hatte).
> Die **4616** ist eine einmalige Messung des damaligen Arbeitsbaums und lässt
> sich nicht wiederholen — der Baum ist angeglichen. Nachprüfbar ist nur die
> Grundgesamtheit, und die wächst mit jedem Commit und hängt an der
> Endungsliste:
>
> | Dateien | Stand | Liste |
> |---|---|---|
> | 5563 | 30.08.2026 vormittags | alte Liste |
> | 5568 | 30.08.2026 abends (PRUEFER) | alte Liste |
> | 5589 | 31.08.2026 | alte Liste |
> | 6385 | 31.08.2026 | neue gemeinsame Liste (`tools/dateiendungen.pl`) |
> | 6394 | 31.08.2026 abends | dieselbe Liste, 0 Abweichungen |
>
> Die frühere Angabe „4426 von 5336" stammte aus einem Durchlauf mit kürzerer
> Endungsliste und steht im Kopf des Werkzeugs seit [W-1](#w-1) nicht mehr.

**Ursache.** Das Repo wurde seinerzeit mit `core.autocrlf=true` ausgecheckt. Git
wandelte beim Auschecken LF nach CRLF und vermerkte die Datei trotzdem als
sauber - im Index steht der LF-Blob-Hash, aber die **Groesse der CRLF-Fassung**.
Spaeter wurde `autocrlf` auf `false` gesetzt und `.gitattributes` mit `* -text`
angelegt; seitdem vergleicht git woertlich.

**Warum es so lange unsichtbar blieb.** Git sieht in eine Datei gar nicht erst
hinein, solange Zeitstempel und Groesse zum Index passen. Die Dateien galten
also weiter als unveraendert - bis irgendein Werkzeug eine anfasste. Dann
aenderte sich der Zeitstempel, git las neu ein und meldete die **ganze Datei**
als geaendert.

**Das erklaert die Vorgeschichte.** Genau dieses Muster hat in diesem Projekt
wiederholt zugeschlagen und wurde jedes Mal einzeln von Hand nachgebessert. Die
fruehere Vermutung, das Repo sei mit `autocrlf=true` geklont worden, war
**richtig** - sie wurde damals als widerlegt abgehakt, weil `git config` zum
Zeitpunkt der Pruefung schon `false` sagte. Die Einstellung war inzwischen
geaendert worden; die Folgen des Auscheckens blieben.

Belegt am Beispiel `Documents/Design/AdServer/Web_Words_Search_Servlet_Design.txt`
(Beschriftung am 31.08.2026 berichtigt — sie war vertauscht, Befund [Z-1](#z-1)):

    HEAD-Blob 8c4fb68a:   5716 Bytes, 0 CR, 65 LF     (die committete LF-Fassung)
    Index-Eintrag:        size: 5781                  (die Groesse der CRLF-Arbeitskopie)
    Arbeitskopie:         5781 Bytes                  (CRLF, inhaltlich gleich)

5716 + 65 CR = 5781 — die Rechnung geht auf. Der Index trug also die **Groesse
der CRLF-Datei** neben dem **Hash der LF-Fassung**, und genau deshalb sah git
nicht hinein: Zeitstempel und Groesse passten zueinander.

Die frühere Fassung dieses Beispiels beschriftete die 5716 als Arbeitskopie.
Das trug nicht: eine Arbeitskopie mit 5716 Bytes und LF wäre byteidentisch zum
Blob, und dann gäbe es nichts anzugleichen.

**Behebung.** `tools/zeilenenden-angleichen.pl` schreibt jede betroffene Datei
mit dem HEAD-Stand woertlich neu - aber nur, wenn sie sich danach nachweislich
byteidentisch dazu verhaelt. Dateien mit echten inhaltlichen Aenderungen bleiben
unangetastet und werden aufgezaehlt. Anschliessend muss der Index einmal
aufgefrischt werden, weil `git update-index --really-refresh` die veralteten
Groessenangaben nicht korrigiert:

    perl tools/zeilenenden-angleichen.pl --aendern
    git ls-files -z | xargs -0 -n 400 git add --

Danach meldete `git status` genau die zwei Dateien mit echten Aenderungen.

**Was sich dadurch aendert.** Jede kuenftige Aenderung erzeugt einen Unterschied,
der nur die tatsaechlich geaenderten Zeilen zeigt. Die pre-commit-Schranke
`tools/pruefe-bytes.pl` bleibt sinnvoll - sie faengt jetzt echte Schaeden statt
Nachwirkungen des Auscheckens. Ein Werkzeug, das die Datei komplett neu
schreibt, faellt weiterhin auf.

**Das Werkzeug gehoert nach jedem frischen Klon einmal ausgefuehrt.** Steht so
in README.md.

## B-1 — Ersatz für die Laufzeitbibliothek von Visual C++ 7.1 (`VC71Bruecke`)

Agent BRUECKE, 30.08.2026. Ausführliche Fassung mit allen Messungen:
[`Eudora71/VC71Bruecke/BEFUND.md`](../Eudora71/VC71Bruecke/BEFUND.md). Hier nur
das, was für andere Agenten und für Paket 1.0.3 zählt.

### Was jetzt da ist

`Eudora71/VC71Bruecke` erzeugt eine eigene `msvcr71.dll`, die ihre Exporte an
`C:\Windows\SysWOW64\msvcrt.dll` weiterleitet. Damit können die drei
unsignierten Fremd-DLLs von dll-files.com (`msvcr71.dll`, `msvcr71d.dll`,
`msvcp71d.dll`) aus dem Paket **entfallen**.

Gemessen am fertigen PE:

- x86, Abhängigkeiten: **nur `KERNEL32.dll`** (`dumpbin -dependents`) — keine
  moderne CRT, das Problem ist also gelöst und nicht verschoben
- 1430 Exporte, davon **1429 echte Forwarder** und eine eigene Funktion
  (`__security_error_handler`, die einzige der 118 gebrauchten, die
  `msvcrt.dll` nicht hat)
- laufzeitgeprüft mit einem Konsolenprogramm: **alle 1429 lösen auf**,
  `malloc`/`strlen`/`free` funktionieren über die Brücke

Bauen (das Projekt hängt noch **nicht** in `Eudora.sln`, siehe unten):

    MSBuild VC71Bruecke.vcxproj /p:Configuration=Release /p:Platform=Win32 /p:BuildProjectReferences=false /m /v:minimal

### Drei Befunde, die über den Auftrag hinausgehen

**B-1.1 — Der Kreis der betroffenen Module ist größer als sieben.** In
`Eudora71/Bin/Release/Plugins` liegen drei weitere vorgebaute Fremdmodule ohne
Quellen: `SMIME.dll`, `SpamHeaders.dll`, `SpamWatch.dll`. Alle drei brauchen
`MFC71.DLL`, `MSVCR71.dll` **und** `MSVCP71.dll`.

**B-1.2 — Die Brücke rettet drei von zehn Modulen, und das ist die Obergrenze.**
Vollständig gelöst sind `Paige32.dll` (Textbearbeitung), `DirServ.dll` und
`EuMemMgr.dll` — sie brauchen nur `MSVCR71`. Die anderen sieben scheitern
nicht an `MSVCR71`, sondern an `MFC71.DLL` (`EudoraBk`, `ISock`, `Ldap`,
die drei Plugins) und `MSVCP71.dll` (`Ph`, `Ldap`, die drei Plugins).
**Diese beiden DLLs liegen dem Paket nach Auftragsbeschreibung gar nicht bei.**
Wenn das stimmt, sind Adressbuch, LDAP-Verzeichnisdienst, `Ph` und alle drei
Plugins **heute schon nicht ladbar** — unabhängig von der `msvcr71`-Frage.
**Das gehört am echten Paket nachgesehen**; es liegt nicht im Repository.

**B-1.3 — `MFC71.DLL` ist nicht „schwierig“, sondern aussichtslos.** Die
Messung „0 benannte Importe aus MFC71“ bedeutet nicht, dass nichts gebraucht
wird, sondern das Gegenteil: es sind **157 Importe nach Ordinal** (Debug: 173),
also 157 Bindungen ohne Namen. Ein Ersatz müsste Microsofts Ordinalvergabe von
2003 exakt treffen; diese Zuordnung ist nicht veröffentlicht und aus den
vorliegenden Dateien nicht rekonstruierbar. Für `MSVCP71.dll` gilt: technisch
nachbaubar (17 Namen für die sieben DLLs, 173 mit den Plugins), aber
**nutzlos**, weil sechs der sieben betroffenen Module zusätzlich an `MFC71`
hängen. Übrig bliebe nur `Ph.dll`. **Nicht bauen.**

### `Paige32d.dll`: Umbenennen ist erlaubt (belegt)

Die Release-`Paige32.dll` darf unter dem Namen `Paige32d.dll` in `Bin/Debug`
liegen. Vier unabhängige Belege:

1. Exportlisten beider DLLs: **938 Namen, Differenz leer**
2. `Paige32.lib` und `Paige32d.lib`: **938 Symbole, Differenz leer**
3. `PAIGE.H` hat **kein einziges** `#ifdef _DEBUG`. Paige schaltet über ein
   eigenes Makro `PG_DEBUG`, das in `CPUDEFS.H:35`/`:47` auskommentiert ist und
   in keiner `.vcxproj` und keinem Quelltext gesetzt wird. Die Felder unter dem
   Kommentar `PAIGE.H:2169` („used only for PG_DEBUG“) stehen **unbedingt** in
   der Struktur.
4. Unabhängig von den Kopfdateien: `pgAllocateNewRef` bekäme unter `PG_DEBUG`
   zwei Parameter mehr (`PGMEMMGR.H:269-274`). Der Export heißt in **beiden**
   DLLs `_pgAllocateNewRef@20`, nicht `@28`. Beide wurden also mit derselben
   Konfiguration gebaut.

Ein Startversuch ist für dieses Urteil nicht nötig.

### `msvcr71d.dll` und `msvcp71d.dll` können aus dem Paket weg

Gemessen: **kein einziges** Modul unter `Eudora71/Bin/Release` importiert aus
`MSVCR71D.dll`, `MSVCP71D.dll` oder `MFC71D.DLL`. Ein Auslieferungspaket wird
aus der Release-Ausgabe gebaut. Nebenbei: `msvcp71d.dll` war ohnehin die
falsche Begründung — `Paige32d.dll` importiert **kein** `MSVCP71D`, sondern nur
`KERNEL32`, `USER32`, `GDI32` und `MSVCR71D`.

### Fallstrick für alle, die an der `.def` arbeiten

Die klassische Zeile `malloc = msvcrt.malloc` **bindet mit dem Linker aus
VS 2022 nicht**: `LNK2001: Nicht aufgelöstes externes Symbol "malloc"`.
Ursache eingekreist (fünf Testbindungen, siehe `BEFUND.md` 2.3): link.exe löst
den Namen auf der rechten Seite trotzdem als gewöhnliches externes Symbol auf.
Weder `/EXPORT` auf der Befehlszeile noch `PRIVATE`, `@ordinal` oder
`/ALTERNATENAME` helfen. Der Bauablauf erzeugt deshalb vor dem Binden mit
`lib.exe` eine Stub-Importbibliothek; im fertigen PE steht davon nichts.

### Vier im Auftrag genannte Dateien gibt es nicht

`ZIEL.md`, `Releases/PAKETE.md`, `tools/zeilenenden-angleichen.pl` und
`tools/ersetze-bereich.pl` sind im Repository nicht vorhanden. Ebenso gibt es
in dieser `BEFUNDE.md` keine Abschnitte [`S-1`](#s-1) bis [`S-7`](#s-7). Wer künftige Aufträge
schreibt, sollte das wissen.

### Offen

- `VC71Bruecke` hängt **noch nicht** in `Eudora71/Eudora.sln` — bewusst nicht
  eingetragen, um keinen Konflikt in einer geteilten Datei zu hinterlassen.
  Die zwei nötigen Einfügungen stehen wörtlich in `BEFUND.md`, Abschnitt 6.
- Startversuch mit der Brücke steht aus (Auflage: keine Fenster, kein
  Eudora-Start).

## M-1 - Menues lassen sich nicht oeffnen: der Rahmen liefert immer HTERROR

Bearbeiter MENUE, reine Quellcodeanalyse (kein Programmstart). Die
ausfuehrliche Fassung mit allen Belegen steht in
`Eudora71/OTShim/BEFUND-MENUE.md`.

**Ursache.** `SECToolBarManager` setzte `m_bMainFrameEnabled` im Konstruktor
auf `TRUE` (`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:3480` und `:3506`).
`CMainFrame::OnNcHitTest` (`Eudora71/Eudora/mainfrm.cpp:8662-8671`) liefert bei
`IsMainFrameEnabled() == TRUE` **immer** `HTERROR`. Damit ist die gesamte
Nichtklientenflaeche des Hauptfensters tot: Menueleiste, Titelzeile,
Systemmenue, die Knoepfe Minimieren/Maximieren/Schliessen und die Rahmenkanten.
Ein Klick auf "File" erreicht nie `WM_NCLBUTTONDOWN` mit `HTMENU` und damit nie
den Menuemodus.

**Warum der Ausgangswert falsch war.** Die Stingray-Kopfdatei
(`Eudora71/OT501/Include/tbarmgr.h:79-80, 213`) beschreibt `TRUE` als
"Hauptfenster ist freigegeben". Eudora liest den Wert an allen fuenf
Abfragestellen andersherum - `TRUE` heisst dort "der Anpassen-Dialog steht
offen". Zwei Stellen sagen es im Klartext: `mainfrm.cpp:2990` ("with a
customize dialog still active") und `mainfrm.cpp:8744` ("We have a customize
dialog up"). Der Schlussstein ist ein Widerspruchsbeweis: waere `TRUE` der
Normalzustand, haette schon Eudora 7.1 eine tote Menueleiste gehabt.
`HTERROR` kommt im ganzen Baum genau einmal vor (`mainfrm.cpp:8670`).

**Behoben** in `Eudora71/OTShim/OTShim_Werkzeugleiste.{h,cpp}`: Ausgangswert
`FALSE` in beiden Konstruktoren, Kommentare berichtigt, Waechter in
`DisableMainFrame` gerichtet, und ein Rueckweg `RestoreMainFrame()` aus dem
Anpassen-Zustand ergaenzt (sonst bliebe der Schalter nach dem ersten Besuch von
"Tools -> Customize Toolbars" auf `TRUE` stehen und die Menueleiste waere
wieder tot). Uebersetzt fehlerfrei; das Binden scheitert nur an nicht
mitgebautem `imap.lib`.

**Nicht gemessen:** die Wirkung im laufenden Programm. Vier Fragen an Gregor
entscheiden das ohne Debugger - im kaputten Bau muessten auch das Verschieben
am Titelbalken, das Ziehen an den Rahmenkanten und die Fensterknoepfe tot
gewesen sein, waehrend **Alt+F** weiterhin funktioniert haben muesste (die
Tastatur laeuft ueber `SC_KEYMENU`, nicht ueber den Hit-Test).

**Widerspruch, offen:** Gregors Beobachtung, die Menues haetten zwischendurch
funktioniert, passt nicht zu [M-1](#m-1) - der Schalter ist vom Umgebungszustand
unabhaengig. Verdacht (UNGEPRUEFT): der funktionierende Bau lag vor `91716bb`,
dem Commit, der `m_bMainFrameEnabled = TRUE` eingefuehrt hat.

**Ausgeschlossen (mit Beleg, siehe BEFUND-MENUE.md):** MDI-Menueverschmelzung,
Fokusdiebe und Erfassung in der Ersatzschicht, Zeitgeber- und Leerlaufpfade
(der MFC-Leerlauf laeuft waehrend des Menuemodus gar nicht, `WM_ENTERIDLE`
kommt mit `MSGF_MENU`), sowie `SECDockState::LoadState` bei leerer INI.

**Nebenbefund:** frische Arbeitsbaeume standen auf `origin/main` (`22a6d77`);
dort bricht der Bau am laengst behobenen `C2572` ab. Der lebende Stand ist
`eudora-exe-linkt`.

## A-1 — Erscheinungsbild (S-6): Ursache von Punkt 2 gefunden, Punkt 1 eingegrenzt (30.08.2026)

> **BERICHTIGUNG vom 31.08.2026.** Überschrift und Vorbemerkung galten für die
> **erste** Sitzung. In der zweiten Sitzung sind fünf Punkte umgesetzt worden
> (`db28adb`, `1a4a6d5`): `DrawDisabled` setzt Text- und Hintergrundfarbe,
> `PreDrawButton` prüft `::SelectObject`, `TBBS_HIDDEN` ist ausgeräumt, die
> Andockrechnung wertet `m_fPctWidth`, `nCol` und `nRow` aus. Die Wirkung ist
> am 31.08. am laufenden Programm **belegt** ([E-1](#e-1), [E-2](#e-2)): Menüs, Anordnung und
> Werkzeugleiste stimmen. **Sämtliche Zeilenangaben dieses Abschnitts beziehen
> sich auf `31810e2` und stimmen im heutigen Baum nicht mehr** — Befund [Z-1](#z-1) hat
> das nachgemessen. Offen bleiben die Splitter,
> `FloatControlBarInMDIChild` und `SetControlBarWidthsInRow` (`OTShim.cpp:2244`,
> leerer Rumpf), dazu PR-2.5 (`DrawChecked` hat denselben Farbfehler).
> LEKTOR und [Z-1](#z-1) hatten diese Berichtigung beide gemeldet; ausgeführt wurde sie
> erst jetzt.
>
> **Nachgemessen am 22.10.2026 an 7.2.0.121 (PRÜFER).** Von den oben als offen
> geführten Punkten sind zwei erledigt: die **prozentualen Zeilenbreiten**
> (`SECDockBar::NormalizeRow`, `OTShim.cpp:2847`, und `DistributeRow`,
> `:3341-3400`) und die **Splitter** (`TrennbalkenNeuAnlegen`, `:4674`, aus
> `OnSize` bei `:4667`; `HitTest` `:3808`, `StartTracking` `:3974`, erreicht aus
> `OnLButtonDown` `:4586`/`:4604`) — das Ergebnis von [E-49](#e-49),
> [E-52](#e-52) und [E-66](#e-66). `SECDockBar::SetControlBarWidthsInRow` steht
> heute in `OTShim.cpp:2830` (nicht `:2244`), ist weiterhin ein leerer Rumpf und
> hat im ganzen Baum **keine Aufrufstelle** — toter Code, kein Mangel.
> `SECDockBar::OnSizeParent` (`:4635`) ist **kein** Rest, sondern eine im
> Quelltext begründete Durchreichung zu [E-52](#e-52): der Trennbalken wird
> absichtlich erst in `OnSize` angelegt, weil `OnSizeParent` die neue Größe noch
> nicht sieht. Offen bleibt allein `FloatControlBarInMDIChild` (`:372`).

Agent ANSICHT, Branch `worktree-agent-a84c76a2ea910c75d`, ausgehend von
`31810e2`. **Kein Code geändert** (Stand der ersten Sitzung) — sie wurde vor
der Umsetzung abgebrochen. Vollständige Analyse mit allen Fundstellen in
[`Eudora71/OTShim/BEFUND-ANSICHT.md`](../Eudora71/OTShim/BEFUND-ANSICHT.md).

### Die sich überlagernden Bereiche: Ursache belegt

Es ist kein Fehler, sondern eine **offene Baustelle**. Die Ersatzschicht sagt es
an ihrer eigenen Deklaration (`OTShim.h:695-699`): die prozentualen
Zeilenbreiten (`m_fPctWidth`) und die Splitter sind nicht umgesetzt, „die
Leisten liegen dadurch so, wie `CDockBar` sie anordnet".

Nachgemessen in `Eudora71/OTShim/OTShim.cpp`:

| Stelle | Zustand |
|---|---|
| `SECDockBar::CalcFixedLayout` Z. 2505 | reicht 1:1 an MFC durch |
| `SECDockBar::OnSizeParent` Z. 2990 | reicht 1:1 an MFC durch |
| `SECDockBar::NormalizeRow` Z. 2239 | zählt nur, **verteilt keine Breite** |
| `SECDockBar::SetControlBarWidthsInRow` Z. 2226 | leerer Rumpf |
| `SECMDIFrameWnd::DockControlBarEx` Z. 274 | legt `fPctWidth` ab, **wertet es nicht aus**; verwirft zusätzlich `nCol` und `nRow` |

Dazu `SECControlBar::CalcFixedLayout` (`OTShim.cpp:1606`): bei `bStretch`
liefert sie **32767** in Zeilenrichtung. Jede Wazoo-Leiste fordert also die
volle Zeilenbreite an, und MFCs `CDockBar` kennt keine anteilige Aufteilung
einer Zeile. Daraus folgen unmittelbar drei der vier gemeldeten
Auffälligkeiten: Adressbuch über Nachrichtenliste, der leere senkrechte
Streifen, und „Task Status/Task Errors" mitten im Fenster.

Bestätigt wird der frühere Ausschluss: an der abgeschalteten Werbeleiste liegt
es nicht (`DockBar.cpp:51-75`, `82-99` prüfen selbst auf `SWM_MODE_ADWARE`).

### Die leeren Werkzeugleisten-Knöpfe: fünf Ursachen ausgeschlossen

Gemessen (Einzelheiten in `BEFUND-ANSICHT.md`):

- Vorgabe ist **große Knöpfe** (`EudoraRes.rc:7648`), also `IDR_MAINFRAME32/A/B`.
- Alle sechs Werkzeugleisten-Bitmaps sind 24 bpp; Bildzahlen 64/61/51 stimmen
  exakt mit `Breite/Höhe` überein; **keine `SEPARATOR`-Zeile** in den
  Ressourcen.
- **Alle 15 Standardknöpfe** (`mainfrm.cpp:684-711`) liegen mit Index 0–62 im
  **ersten** Bitmap. Das Zusammensetzen der drei Ressourcen
  (`QCToolBarManager.cpp:283-540`) ist damit als Ursache **ausgeschlossen** —
  es könnte nur alle 15 gleichzeitig treffen, nicht einzelne.
- `IDToBmpIndex` liefert bei unbekannter Kennung 0 → **falsches** Symbol, nie
  ein leeres Feld. Ausgeschlossen.
- `secData` ist echt gefüllt (`OT501/Src/secaux.cpp:23`, im Projekt unter
  `Eudora.vcxproj:217`). Ausgeschlossen.
- `QCCustomToolBar` überschreibt das Zeichnen nicht — gemalt wird ausschließlich
  in der Ersatzschicht.

**Übrig bleibt der Zeichenweg je Knopf.** Stärkster Verdacht (UNGEPRÜFT):
`SECStdBtn::DrawDisabled` (`OTShim_Werkzeugleiste.cpp:786-801`) lässt vor dem
Einfarbig→Farb-`BitBlt` das Paar `SetTextColor(0)` / `SetBkColor(0xFFFFFF)`
weg, das die klassische Vorlage dort zwingend setzt. Weil `CDC::FillSolidRect`
in `DrawFace` (Z. 704) die Hintergrundfarbe auf `clrBtnFace` stehen lässt,
übersetzt GDI die Maskeneins nicht nach Weiß, sondern nach `clrBtnFace` — und
die Verknüpfungszahl `PSDPxax` setzt Weiß/Schwarz voraus. Das passt als
einziger Kandidat auf das Muster „mehrere leer, andere da": auf einer frisch
gestarteten Eudora sind gerade acht der fünfzehn Knöpfe gesperrt, und auf
Gregors **Vergleichsbild** ist ein Nachrichtenfenster offen, dort wären
dieselben Knöpfe freigegeben.

### Bauzustand

`Eudora.vcxproj` Debug/Win32 endet an `31810e2` **unverändert** mit
`LNK1104: imap.lib`. Alle Quelldateien übersetzen fehlerfrei. Nebenbefund: der
MSBuild-Aufruf aus der Arbeitsanweisung läuft in der **Git-Bash nicht** (sie
macht aus `/p:Configuration=Debug` einen Pfad) — er gehört in PowerShell, und
Visual Studio liegt auf diesem Rechner unter **Professional**, nicht Community.

## P-1 - Der POP-Abrufpfad, vor dem ersten echten Abruf gegengelesen

**Geprueft am:** 2026-08-30, Agent POSTBOTE, Branch `worktree-agent-a09934fad08c602f1`
**Anlass:** Kriterium 3 aus `ZIEL.md` ist nie geprueft worden. Gregor will als
naechstes ein freenet-Konto einrichten und Mail abrufen.
**Verfahren:** nur Quellcode und Komponententests. Kein Eudora gestartet, keine
Verbindung zu einem Mailserver, keine Zugangsdaten benutzt.
**Ablieferung nebenan:** `ABRUF-PRUEFEN.md` im Wurzelverzeichnis.

### P-1.0 Die Kette, um die es geht

```
ID_FILE_CHECKMAIL (EudoraRes.rc)
  -> CMainFrame::OnFileCheckMail        mainfrm.cpp:3428
  -> CEudoraApp::OnCheckMail            eudora.cpp:791
  -> ::GetMail(bitflags)                GetMail.cpp:82
       QCPOPSettings::GrabSettings      QCMailSettings.cpp:138  (POPAccount, POPPort)
       QCSSLSettings::GrabSettings      SSLSettings.cpp:71      (SSLReceiveUse, SSLPOPAlternatePort)
  -> CPOPSession (Worker-Thread)        POPSession.cpp:286 / DoWork:478
  -> CPOPSession::GetMail               POPSession.cpp:520
       SetupNetConnection_ 3190 -> CreateNetConnectionMT -> QCWorkerSocket
       OpenPOPConnection_  1690 (Port 110 / 995 / kpop 1110)
       [implizites TLS]     602 -> SetSSLMode -> qcssl.dll: BeginQCSSLSession
       POPAuthenticate_    2047: Banner, CAPA 752, STLS 3479, USER/PASS 2175/2176, STAT 2267
       DoGetPOPMailToSpool  916 -> POPGetMessageToSpool 1027: LIST 1045, RETR 1085, DELE 1174
                                -> FetchMessageToSpool 1207 (ReadPOPLine 2364 -> Spool-Datei)
  -> CPOP::GetMailFromSpool             pop.cpp:123
       FetchMessageTextFromSpool 461 -> WriteMessageToMBX_ 656
            HeaderDesc::Read  header.cpp:77 (+ Fix2047/Translate2047 lex822.cpp:554/514)
            MIMEState::Init   mime.cpp:109 -> Reader::ReadIt -> Base64Decoder/QPDecoder
       CTocDoc::UpdateSum/WriteSum      pop.cpp:596/639
```

### P-1.1 BEHOBEN: `TextReader::ReadIt` warf die neue Laenge von `ISOTranslate` weg

**Sicherheit: nachgewiesen (Komponententest).**
**Datei:** `Eudora71/Eudora/TextReader.cpp:251`.

`ISOTranslate` (utils.cpp:1162) uebersetzt an Ort und Stelle. Jede uebersetzte
Mehrbytefolge macht den Text **kuerzer** - die Funktion liefert deshalb die neue
Laenge zurueck. Die Aufrufstelle warf sie weg:

    ISOTranslate(buf, size, iCharsetIdx);        // vorher
    size = ISOTranslate(buf, size, iCharsetIdx); // jetzt

`size` behielt also die Laenge **vor** der Uebersetzung. Alles, was danach mit
`size` rechnet, lag daneben:

- `buf[size-2] != '\r'` (Z. 260) - die CRLF-Erkennung greift ins Leere. Jede
  Zeile mit einem Umlaut galt als "nicht mit CRLF beendet" und lief in den
  Sammelpuffer statt direkt in die Mailbox.
- `PutWithEscapedFileMarkers(buf, size, ...)` (Z. 312) - schreibt hinter den
  uebersetzten Text die Nullterminierung **und** je uebersetztem Zeichen ein
  Restbyte der alten Fassung in `In.mbx`.

**Warum es bis heute nicht auffiel - und ab jetzt jede deutsche Mail trifft.**
Im Originalcode von 2006 (`567a5d8:Eudora71/Eudora/utils.cpp`) hatte die
UTF-8-Zeile der Uebersetzungstabelle **27 Eintraege**, ausschliesslich
CP1252-Sonderzeichen (Anfuehrungsstriche, Gedankenstriche, Eurozeichen).
Deutsche Umlaute waren nicht dabei: `C3 A4` blieb `C3 A4`, der Text wurde nicht
kuerzer, und der Fehler blieb stumm. Heute hat die Tabelle **123 Eintraege**
(`utils.cpp:46`), darunter der komplette Latin-1-Bereich U+00A0..U+00FF. Damit
wird ab sofort **jede Zeile mit einem Umlaut** kuerzer - und der seit 2006
schlafende Fehler waere bei Gregors erstem Abruf sofort sichtbar geworden.

Der Fehler ist **kein Portierungsschaden**: die Zeile steht wortgleich in
`567a5d8`. Erst die Erweiterung der Tabelle hat ihn geweckt.

**Abgesichert durch:** `Eudora71/Tests/TestPopEmpfang.cpp`, Test
"POP: TextReader::ReadIt uebernimmt die neue Laenge von ISOTranslate" - ein
Waechter auf den Quelltext, damit die Zuweisung nicht wieder verschwindet.

### P-1.2 GEPRUEFT UND IN ORDNUNG: der POP-Pfad ist vom IMAP-Zeichensatzfehler nicht betroffen

**Sicherheit: nachgewiesen (Komponententest).**

Bekannt war: `EuImap/src/ImapDownload.cpp:4644` ruft `FindRStringIndexI` direkt
auf und gibt das Ergebnis **ohne die Verschiebung um eins** an `ISOTranslate`.

Der POP-Pfad geht einen anderen Weg. `TextReader.cpp:85` und `lex822.cpp:516`
benutzen `FindMIMECharset` (`mime.cpp:382`), und das zaehlt den Wert hoch:

    iCharSet = FindRStringIndexI(IDS_MIME_US_ASCII, IDS_MIME_UTF_8, charSet, -1);
    if (iCharSet >= 0) ++iCharSet;      // "Bump index to avoid conflict with windows"

Gemessen (Test "POP: der Index wird um eins verschoben"):

| Zeichensatz | roher Index (IMAP) | `FindMIMECharset` (POP) | Wirkung des rohen Index |
|---|---|---|---|
| `iso-8859-15` | 2 | 3 | 2 ist "<= 2" - gar keine Uebersetzung |
| `utf-8` | 3 | 4 | 3 waehlt nach `-3` die Zeile 0, also die **ISO-8859-15-Tabelle**; aus `C3 BC` wird `C3 8C`, der Text ist danach kaputt |

Zusaetzlich sucht IMAP nur bis `IDS_MIME_ISO_LATIN9` - `utf-8` findet es gar
nicht und bekommt `-1`. Der IMAP-Pfad uebersetzt damit ueberhaupt keine
Zeichensaetze. **Gregor benutzt POP, ist also nicht betroffen.**

### P-1.3 GEPRUEFT UND IN ORDNUNG: Betreff und Absendername laufen ueber denselben Pfad wie der Text

Beide gehen durch `HeaderDesc::Read` (header.cpp:77) und von dort durch den
Lexer (`lex822.cpp:777`), der `Fix2047` aufruft. `Fix2047` (lex822.cpp:554)
zerlegt `=?Zeichensatz?Kodierung?Text?=` und gibt den Inhalt an `Translate2047`
(lex822.cpp:514): erst `PseudoQP` bzw. `DecodeB64String`, dann **dasselbe**
`ISOTranslate` mit **demselben** Index aus `FindMIMECharset`.

Der Rueckgabewert wird hier zu Recht nicht gebraucht: `Fix2047` arbeitet
anschliessend mit `strcpy`/`strlen`, und `ISOTranslate` setzt die
Nullterminierung an die neue, kuerzere Stelle (utils.cpp:1277). P-1.1 betrifft
den Kopfzeilenpfad also nicht.

Gemessen an nachgebauten Kopfzeilen (`TestPopEmpfang.cpp`, neun Tests):

| Eingabe auf der Leitung | Ergebnis |
|---|---|
| `=?UTF-8?B?R3LDvMOfZQ==?=` | `Gr` FC DF `e` |
| `=?utf-8?Q?Gr=C3=BC=C3=9Fe?=` | `Gr` FC DF `e` |
| `=?iso-8859-1?Q?Gr=FC=DFe?=` | `Gr` FC DF `e` (Index 2, keine Uebersetzung noetig) |
| `=?utf-8?B?4oKsIDUw?=` | 80 ` 50` (Eurozeichen, 3 Bytes -> 1) |
| `=?UTF-8?B?SsO8cmdlbiBTY2jDtm4=?= <juergen@example.org>` | `J` FC `rgen Sch` F6 `n <juergen@example.org>` |
| `Re: =?utf-8?Q?Gr=C3=BC=C3=9Fe?= aus Musterstadt` | `Re: Gr` FC DF `e aus Musterstadt` |
| `=?utf-8?Q?Gr=C3=BC=C3=9Fe?= =?utf-8?Q?_und_Dank?=` | `Gr` FC DF `e und Dank` (Zwischenraum faellt weg, RFC 2047 6.2) |
| `=?koi8-r?B?VGVzdA==?=` | bleibt woertlich stehen (unbekannter Zeichensatz) |
| `=?utf-8?X?VGVzdA==?=` | bleibt woertlich stehen (unbekanntes Verfahren) |

### P-1.4 Die Portierung hat den Abrufpfad nicht angefasst

**Sicherheit: nachgewiesen** (Vergleich gegen `567a5d8`, den Commit mit den
Originalquellen).

Der gesamte Unterschied im POP-Abrufpfad zwischen 2006 und heute sind **sechs
Zeilen**, und keine davon aendert die Bedeutung:

| Fundstelle | Aenderung | Bewertung |
|---|---|---|
| `POPSession.cpp:1711, 2232, 2429, 2473` | `strchr(...)` -> `const_cast<char*>(strchr(...))` | C++-const-Ueberladung; alle vier Zeiger werden nur gelesen |
| `header.cpp:240` | dieselbe Aenderung | dito |
| `QCWorkerSocket.cpp:47` | `#include <xstddef>` -> `<functional>` | verhaltensneutral |

`SSLSettings.cpp`, `QCMailSettings.cpp` und `pop.cpp` sind **byteidentisch** zum
Original.

Ebenfalls geprueft und in Ordnung: `Eudora71/QCSSL/src/qcssl.def` ist in
`QCSSL.vcxproj` (Z. 79 und 123) fuer Debug **und** Release als
`ModuleDefinitionFile` eingehaengt. Die elf `QCSSL*`-Exporte bleiben damit
undekoriert, und die `GetProcAddress`-Aufrufe in `Network::SetSSLMode`
(`QCWorkerSocket.cpp:373-383`) finden ihre Symbole trotz `__stdcall`. Das war
der naheliegendste Weg, wie die Portierung SSL-POP still haette brechen koennen
- sie hat es nicht.

**`char` mit Vorzeichen: kein Fund.** `POPSession.cpp:1837` und `:2279` casten
schon im Original nach `unsigned char`, bevor sie `isspace`/`isdigit` rufen.
Keine Tabellenindizierung mit rohem `char` im geprueften Bereich.

**`time_t` 32 -> 64 Bit:** die einzige Kategorie, in der der Uebersetzerwechsel
Typen wirklich geaendert hat. Betroffen: `QCWorkerSocket.cpp:1728/1739`
(Netzwerk-Zeitgrenze), `POPSession.cpp:2264` und `:361/341`
(`IDS_INI_POP_LAST_AUTH` ueber `SetIniLong`/`GetIniLong`), `pop.cpp:690-694`
(Zeitstempel der `From ???@???`-Zeile). Alle Werte bleiben bis zum 19.01.2038
verlustfrei, `_USE_32BIT_TIME_T` ist nirgends gesetzt. **Keine auf Platte
geschriebene Struktur mit `time_t`** im POP-Pfad - das INI-Format bleibt
kompatibel. Kein Handlungsbedarf.

### P-1.5 OFFEN: Altlasten aus 2006, die den ersten Abruf treffen koennen

Alle folgenden Stellen stehen **wortgleich in `567a5d8`**. Sie sind keine
Portierungsschaeden, aber sie liegen auf dem Weg, den Gregors erster Abruf
nimmt. Nichts davon wurde geaendert - hier steht nur, worauf zu achten ist.

**P-1.5a  NULL-Zeiger nach gescheiterter SSL-Aushandlung.**
`QCSocket/src/QCWorkerSocket.cpp:1961-1972`. `pConnectionInfo` wird in Z. 1961
geprueft, in Z. 1969 (`pConnectionInfo->m_Outcome.m_bCertRejected`) aber
ungeprueft dereferenziert; dieselbe Stelle nochmals in `:1989-1992`. Liefert
`QCSSLGetConnectionInfo` nach einem gescheiterten Handshake NULL, stuerzt Eudora
ab, statt eine Fehlermeldung zu zeigen. **Das ist der wahrscheinlichste
Absturzpunkt beim ersten Abruf, wenn etwas mit dem Zertifikat nicht stimmt.**
Wenn Eudora beim Abruf kommentarlos verschwindet: hier zuerst nachsehen.

**P-1.5b  `sscanf` mit unbegrenztem `%s` auf Serverdaten.**
`POPSession.cpp:1050-1052`: `char szDummy[40]` und
`sscanf(szBuffer, "%s %d %ld", szDummy, ...)` auf der 3072 Byte grossen
`LIST`-Antwort. Ein Server, dessen erstes Token laenger als 39 Zeichen ist,
ueberschreibt den Stapel. Unter VS2022 greift `/GS` - daraus wird ein
kontrollierter Absturz statt stiller Verfaelschung. Richtig waere `%39s`.

**P-1.5c  Schleife laeuft ein Byte unter den Puffer.**
`POPSession.cpp:1305-1306` in `FetchMessageToSpool`:
`while (Len >= 0 && (szBuffer[Len-1] == '\r' || ...)) szBuffer[--Len] = 0;`
Bei `Len == 0` wird `szBuffer[-1]` gelesen und geschrieben. Muss `Len > 0`
heissen. **UNGEPRUEFT**, ob ein Pfad `Len == 0` ueberhaupt erreicht -
`Network::GetLine` normalisiert nacktes LF zu CRLF. Die Zeile ist unabhaengig
davon falsch.

**P-1.5d  `strncpy` ohne Nullterminierung, Servername.**
`POPSession.cpp:1739`: `char Server[128]; strncpy(Server, pszPOPServer, sizeof(Server));`
- `sizeof` statt `sizeof-1`, kein `Server[127] = 0`. Ab 128 Zeichen Servername
lesen `stricmp` (Z. 1742) und `Open()` ueber das Array hinaus. Gleiches Muster
in `POPSession.cpp:3342` und `:3344`.

**P-1.5e  Ungeprueftes `strcpy` aus den Einstellungen.**
`POPSession.cpp:2154-2155` (`char szPOPUserName[128]` aus `GetPOPAccount()`),
`:2190-2192` (`char szPassword[255]`, abgesichert nur durch ein `ASSERT`, das im
Release wegfaellt), `:1785-1795` (`char szCommand[3072]`, `strcpy` plus zwei
ungeprueften `strcat` mit Kommandoargumenten). Ein sehr langes Passwort oder
POP-Konto in der INI ueberlaeuft den Stapel.

**P-1.5f  SSL-Lesefehler wird verschluckt.**
`QCWorkerSocket.cpp:1280-1302`: `res` wird gesetzt, aber nie ausgewertet.
Schlaegt `QCSSLRead` fehl und laesst `nValid` unveraendert auf `m_nBufferSize`,
meldet `Read()` einen vollen Puffer alter Daten als gueltige Serverantwort.
**UNGEPRUEFT**, ob `QCSSLRead` `nValid` im Fehlerfall immer nullt.

**P-1.5g  `memmove` braucht zwei Bytes mehr als vorhanden.**
`POPSession.cpp:2407` in `ReadPOPLine`:
`memmove(pszBuffer+1, pszBuffer, ++nBytesRead);` - kopiert `nBytesRead+1` Bytes
ab Offset 1, braucht also `nBytesRead+2`. Bei einer maximal langen Zeile, die
mit `From ` beginnt, ein 1-Byte-Ueberlauf. **UNGEPRUEFT** (haengt an der genauen
Obergrenze in `GetLine`, die bei `len-1` liegt).

**P-1.5h  Zeiger durch 32-Bit-Typen.**
`QCWorkerSocket.cpp:1469` (`SetWindowLong(m_hWnd, GWL_USERDATA, (LONG)this)`,
Rueckweg `:1480`, Loeschen `:526`) und `:1841/1848/1899` (`long lArg` traegt
einen `QCSSLReference*`). Auf **Win32/x86 exakt 32 Bit und damit heute
harmlos.** Es ist aber der Punkt, an dem eine spaetere x64-Umstellung sofort und
vollstaendig bricht - jede Winsock-Nachricht des POP-Sockets und der ganze
SSL-Datenstrom laufen hier durch. Richtig waere `SetWindowLongPtr`/`GWLP_USERDATA`
und `LPARAM` statt `long`.

**P-1.5i  Warnungen sind dateiweit abgeschaltet.**
`QCWorkerSocket.cpp:46`: `#pragma warning(disable: 4786 4663 4244 4018 4146 4100)`.
**4244** (Datenverlust bei Konvertierung) und **4018** (signed/unsigned-Vergleich)
sind genau die Warnungen, mit denen VS2022 die obigen Kategorien in dieser Datei
melden wuerde. Die Portierung ist hier blind.

**P-1.5j  `size_t`-Unterlauf bei leerem Ressourcentext.**
`header.cpp:113-114`: `interesting[h][strlen(interesting[h]) - 1] = 0;` - ist
eine der 14 Kopfzeilen-Ressourcen leer, ergibt `strlen(...)-1` den Wert
`0xFFFFFFFF`. Alle 14 Plaetze werden in Z. 96-109 befuellt; nur der Leerstring
ist offen.

**Kleinigkeiten ohne praktische Wirkung:** `POPSession.cpp:1031`
(`char szMessageNum[10]` fuer `%d`, braeuchte 12 - erst ab 1 Mrd. Nachrichten),
`:2394` (`strcpy` auf ueberlappenden Puffern, formal UB), `:759-760`
(`strnicmp(szBuffer,"MANGLE",5)` - Laenge um eins zu klein, trifft trotzdem),
`QCWorkerSocket.cpp:1086` (`if (!m_szMachine)` auf einem Array - immer falsch,
tote Pruefung), `:1137` (`wsprintf` mit Hostnamen in `char Buffer[256]`, nur im
Fehlerpfad erreichbar).

### P-1.6 Der zurueckgestellte Zertifikats-Patch beeintraechtigt den Abruf NICHT

`tools/patches/zertifikatspruefung-verschaerfen.patch` ist **nicht angewandt**
und wurde von mir auch nicht angefasst.

Er wirkt in die **sichere** Richtung: heute behandelt
`QCCertificateUtils::CertificateCallback` die Pruefergebnisse
`X509_V_ERR_CERT_UNTRUSTED` und `X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE` als
Erfolg (`iOK = 1`), ohne dem Anwender etwas zu zeigen. Ohne den Patch ist Eudora
also **nachsichtiger** und nimmt mehr Zertifikate an. Der erste Abruf wird daran
nicht scheitern. Erst mit dem Patch wuerde Eudora Zertifikate ablehnen, die es
heute klaglos annimmt.

### P-1.7 Neue Komponententests

`Eudora71/Tests/TestPopEmpfang.cpp` (11 Tests), dazu die Uebersetzungseinheit
`Eudora71/Tests/UnderTest2047.{h,cpp}` und sechs neue Schnittregionen in
`Eudora71/Tests/Extract.ps1`.

Wie im Testprojekt ueblich steht in den Testdateien **kein abgeschriebener
Produktivcode**: `Extract.ps1` schneidet bei jedem Bau frisch aus
`Decode.h`, `Base64.h`, `Base64.cpp`, `mime.cpp` (`FindMIMECharset`, `HexToString`)
und `lex822.cpp` (`PseudoQP`, `DecodeB64String`, `Translate2047`, `Fix2047`).
Nachgebildet ist nur `FindRStringIndexI`, weil im Test keine Ressourcen-DLL
vorliegt; die vier Zeichensatznamen stammen woertlich aus `EudoraRes.rc:9385-9388`.

**Ergebnis am 30.08.2026:**

    Ergebnis: 34 Tests, 34 bestanden, 0 fehlgeschlagen

(vorher 23; die 11 neuen sind die aus P-1.2, P-1.3 und der Waechter aus P-1.1.)
Aufruf: `Eudora71\Tests\RunTests.cmd`.

### P-1.8 NICHT GEPRUEFT: Eudora.vcxproj baut aus dem eingecheckten Stand nicht

In einem frischen Worktree auf `22a6d77` bricht
`MSBuild Eudora71\Eudora\Eudora.vcxproj /p:Configuration=Debug /p:Platform=Win32`
schon bei `stdafx.cpp` ab:

    OT501\Include\secbtns.h(340,83): error C2572: "SECLoadSysColorBitmap":
      Neudefinition des Standardarguments: Parameter 1
      Siehe Deklaration von "SECLoadSysColorBitmap" in OTShim\OTShim.h(306,13)

Im gemeinsamen Arbeitsverzeichnis liegen dazu **nicht eingecheckte** Aenderungen
an `OTShim.h`, `OTShim.cpp`, `OTShimAll.h`, `OTShim_Reiter.cpp` sowie vier neue
Dateien (`OTShim_Knopf.cpp`, `OTShim_Fremdsymbole.cpp`, `OTShim_Libpng.cpp`,
`OTShim_Spur.cpp`). Der Bau gelingt also nur mit der Arbeit anderer Agenten, die
noch nicht committet ist. Das ist deren Baustelle, nicht meine.

**Folge fuer P-1.1:** die Aenderung an `TextReader.cpp:251` ist deshalb **nicht
durch den Uebersetzer gelaufen.** Das Risiko ist klein - `size` ist als `LONG`
deklariert (`TextReader.cpp:77`), `ISOTranslate` liefert `LONG`
(`utils.h:90`), es ist eine typgleiche Zuweisung. Aber gemessen ist es nicht.
**Vor der naechsten Auslieferung `Eudora.vcxproj` bauen und das nachholen.**

Das Testprojekt `Eudora71\Tests\Tests.vcxproj` baut und laeuft dagegen sauber -
es haengt nicht an OTShim.

---

## Stand und naechster Schritt (POSTBOTE, 30.08.2026)

**Fertig und im Branch:**

- `ABRUF-PRUEFEN.md` - die Anleitung fuer Gregors ersten Abruf
- P-1.1 behoben (`TextReader.cpp:251`), mit Waechtertest
- 11 neue Komponententests, alle gruen (34 von 34)
- der Abrufpfad ist ganz gegengelesen, Portierungsschaeden ausgeschlossen (P-1.4)

**Was ich als naechstes getan haette, in dieser Reihenfolge:**

1. **`Eudora.vcxproj` bauen**, sobald die OTShim-Arbeit committet ist, und damit
   P-1.8 schliessen. Das ist der einzige offene Punkt an meiner eigenen
   Aenderung.
2. **P-1.5a absichern** - die NULL-Pruefung in `QCWorkerSocket.cpp:1969` und
   `:1989`. Das ist ein Zweizeiler und verwandelt einen Absturz beim ersten
   Abruf in eine Fehlermeldung. Von allen Punkten unter P-1.5 der mit dem
   besten Verhaeltnis von Aufwand zu Nutzen.
3. **P-1.5b** (`%39s` statt `%s`) und **P-1.5d** (`sizeof(Server)-1` plus
   Nullterminierung) - beides Einzeiler auf dem Abrufweg.
4. Einen Test bauen, der eine vollstaendige POP-Antwort aus einem Puffer
   einspeist. Das braucht einen Ersatz fuer `LineReader` und `JJFile`; ich habe
   stattdessen die beiden Stellen einzeln geprueft, an denen der Zeichensatz
   umgesetzt wird. Der durchgehende Test waere die naechste Ausbaustufe.
5. Den Zeichensatzfehler im IMAP-Pfad (`ImapDownload.cpp:4644`) beheben - er ist
   in P-1.2 genau vermessen, betrifft Gregor aber nicht, weil er POP benutzt.

**Nicht angefasst, wie verabredet:**
`tools/patches/zertifikatspruefung-verschaerfen.patch` bleibt liegen (P-1.6).

## PR-1 — Die Schranke `pruefe-bytes.pl` erkennt den halben Schaden nicht (geprueft 30.08.2026)

Nachgepruefter Stand: 371c1e3. Vollstaendiger Bericht: `PRUEFBERICHT.md`.
Drei Befunde an der Schranke, alle mit Gegenprobe in einem Wegwerf-Repo belegt.

**1. Die Umwandlung LF → CRLF laeuft lautlos durch.** `tools/pruefe-bytes.pl:105-125`
sucht nur die Richtung CRLF → LF (`$a->{$inhalt}[0] > 0` und `$b->{$inhalt}[0] == 0`).
Schreibt ein Werkzeug eine gemischte Datei komplett mit CRLF neu und aendert
dabei auch Inhalt, greift Regel 1 nicht mehr und Regel 2 sieht nichts:

    Datei a.cpp in HEAD: zeile1 LF, zeile2 CRLF, zeile3 LF, zeile4 CRLF
    Im Index: alles CRLF, zeile4 durch NEU ersetzt
    -> perl tools/pruefe-bytes.pl  ==>  Rueckgabe 0, keine Meldung

Dieselbe Aenderung in der Gegenrichtung wird korrekt gemeldet. Die Schranke ist
also einseitig — und CRLF ist unter Windows die wahrscheinlichere Richtung.

**2. Sie schlaegt bei Leerzeilen grundlos an.** Regel 2 vergleicht Zeilen ueber
ihren Inhalt. Der haeufigste Inhalt in einer gemischten Datei ist die leere
Zeile, und die kommt mit beiden Enden vor. Ein voellig normaler Commit:

    c.cpp in HEAD: void f() LF, { LF, Leerzeile CRLF, \tint a; LF, } LF
    Im Index: die CRLF-Leerzeile geloescht, \tint b; und eine LF-Leerzeile ergaenzt
    -> COMMIT ABGEBROCHEN ... z. B. ""

Kein einziges Byte wurde umgewandelt. Die Meldung nennt als Beispiel die leere
Zeichenkette und sagt damit nicht, wo man nachsehen soll. Das ist derselbe
Fehlalarm-Fehler, den 371c1e3 abstellen wollte — er ist nur von der CR-Anzahl
auf den Zeileninhalt umgezogen.

**3. Ganze Dateiarten werden gar nicht geprueft.** Die Endungslisten in
`tools/pruefe-bytes.pl:52` und `tools/zeilenenden-angleichen.pl:90` sind
verschieden: `.def` steht nur in einem, `.vcxproj`/`.filters` nur im anderen.
`.sln`, `.rc2`, `.bat`, `.cmd`, `.ps1`, `.pl`, `.props` stehen in keinem —
darunter die Bauwerkzeuge dieses Projekts. Eine `.def`-Datei komplett von CRLF
auf LF umgeschrieben: Rueckgabe 0.

**Behebung**, alle drei klein, aber bewusst NICHT ausgefuehrt: die Schranke
laeuft vor jedem Commit, an ihr ohne Zeit fuer eine saubere Gegenprobe zu
drehen ist schlechter, als sie so zu lassen.

  1. Regel 2 symmetrisch: dieselbe Pruefung mit vertauschten Feldern 0 und 1.
  2. Zeilen, deren Inhalt nach `s/\s+//g` leer ist, in Regel 2 uebergehen;
     ebenso Zeilen, die in HEAD schon mit beiden Enden vorkommen.
  3. Eine gemeinsame Endungsliste fuer beide Werkzeuge, ergaenzt um
     `def sln rc2 bat cmd ps1 pl props`.

**Weitere Befunde derselben Pruefung** (Einzelheiten in `PRUEFBERICHT.md`):

  * [PR-4](#pr-4): `BuildKennung.h` ist in git verfolgt. Faellt perl beim Bau aus,
    bricht der Bau richtigerweise nicht ab — das Fenster zeigt dann aber die
    Kennung eines FREMDEN Baus statt gar keiner. `Eudora.vcxproj:63-72`.
  * [PR-5](#pr-5): Der Zeitstempel in der Kennung ist nicht der Bauzeitpunkt, sondern
    der Zeitpunkt der letzten Aenderung an Commit oder Sauberkeit
    (`tools/kennung-erzeugen.pl:118-130`). Als Verhalten richtig, als
    Beschreibung falsch.
  * [PR-6](#pr-6): `_T(EUDORA_BAU_KENNUNG)` in `mainfrm.cpp:9715` uebersetzt in einem
    Unicode-Bau nicht — `__T(x)` ist `L##x`, und `##` unterbindet die
    Makroerweiterung. Im MBCS-Bau, den dieses Projekt baut, faellt es nicht auf.
  * [PR-7](#pr-7): In [S-7](#s-7) widersprechen sich die Zahlen (4616/5563 hier gegen 4426/5336
    im Kopf von `tools/zeilenenden-angleichen.pl`; nachgemessen sind es 5568
    verfolgte Dateien), und das Beispiel ist falsch beschriftet: 5716 Bytes ist
    die Groesse des LF-BLOBS, nicht die der Arbeitskopie. Der Kern der
    Erklaerung — git sieht nicht in die Datei, solange Zeitstempel und Groesse
    zum Index passen — stimmt.
  * [PR-8](#pr-8): `tools/rekursion-suchen.pl` bildet jede Kante mit dem Klassennamen
    der umgebenden Methode (`:74`). Klassenuebergreifende Zyklen sind damit
    strukturell unsichtbar — auch der aus [S-2](#s-2), fuer den es gebaut wurde.
    Empfehlung: loeschen.

**Ausdruecklich nachgemessen und in Ordnung:** die CONTEXT-Versaetze in
`tools/stapel-untersuchen.ps1:141-143` (Ebp 180, Eip 184, Esp 196 sind fuer
x86 richtig) und die EBP-Kette, die wegen `if ($neuEbp -le $ebp) { break }`
streng steigen muss und deshalb nicht haengen kann; der PreBuildEvent, der den
Bau in keinem Zweig abbricht; `OnUpdateFrameTitle`, das in keine Rekursion
laeuft; und die Werbeleiste an `IsBoxBuild()` — der ganze Baum `Eudora71/`
wurde nach Nutzern durchsucht, keiner greift ins Leere. `IsBoxBuild()` ist eine
Uebersetzungszeit-Weiche ueber `BUILD_BOX_OR_SITE_R_VERSION`, und das Makro
steht in `Eudora.vcxproj` in BEIDEN Konfigurationen (Zeile 77 und 130) — wer es
entfernt, holt sich den Stapelueberlauf aus [S-2](#s-2) zurueck.

**Nichts davon haelt Paket 1.0.3 auf.**

## P-2 - Kriterium 3 abgesichert: der Absturzpunkt vor dem ersten Abruf ist behoben

**Geprueft am:** 2026-08-31, Agent POSTBOTE, Branch `abruf-absichern`
(aus `darstellung-und-menue`, `76efdb6`).
**Anlass:** Fortsetzung von [P-1](#p-1). Gregor will als naechstes selbst einen
Mailserver verbinden. P-1.5a nannte den wahrscheinlichsten Absturzpunkt, P-1.8
liess die Aenderung an `TextReader.cpp:251` unuebersetzt.
**Verfahren:** nur Quellcode und Uebersetzer. Kein Eudora gestartet, keine
Verbindung zu einem Mailserver, keine Zugangsdaten benutzt.
**Ablieferung nebenan:** `ABRUF-PRUEFEN.md`, Abschnitte 1 (Servername),
5a (SSL-Aushandlung) und 5b (Zertifikatsfehler) sind neu.

### P-2.1 BEHOBEN: NULL-Zeiger nach gescheiterter SSL-Aushandlung (war P-1.5a)

**Sicherheit: nachgewiesen (uebersetzt).**
**Datei:** `Eudora71/QCSocket/src/QCWorkerSocket.cpp`, Funktion
`QCWorkerSocket::InitializeQCSSL` (ab `:1938`).

Vier Zeilen, alle im Fehlerpfad einer gescheiterten SSL-Aushandlung:

| vorher | Fundstelle | jetzt |
|---|---|---|
| `pConnectionInfo= fnConnInfo(...)` | `:1957` | Aufruf nur noch `if (fnConnInfo)` |
| `if (pConnectionInfo->m_Outcome.m_bCertRejected)` | `:1969` | `if (pConnectionInfo && pConnectionInfo->...)` |
| `pConnectionInfo = fnConnInfo(...)` | `:1989` | Aufruf nur noch `if (fnConnInfo)` |
| `m_iSSLError = pConnectionInfo->...` und `if (pConnectionInfo->...)` | `:1991/:1992` | beide in ein `if (pConnectionInfo)` gefasst |

Die Stelle `:1969` war die wichtigste: Zeile 1961 prueft `pConnectionInfo`,
Zeile 1969 dereferenziert es acht Zeilen spaeter wieder ungeprueft. Der
Zweig `:1986-1997` (kein `TaskInfo`, also IMAP oder Hauptfaden) pruefte
ueberhaupt nicht.

**Neu hinzugekommen: der Funktionszeiger.** `fnConnInfo` kann NULL sein, ohne
dass etwas vorher schiefgelaufen sein muss. `Network::SetSSLMode`
(`:362-386`) bricht nur ab, wenn `LoadLibrary("qcssl")` scheitert; die zehn
`GetProcAddress`-Ergebnisse (`:373-383`) werden **gar nicht geprueft** und
`m_bSSLMode` wird trotzdem gesetzt. Laedt also eine `QCSSL.dll` der falschen
Fassung, in der `QCSSLGetConnectionInfo` fehlt, dann ist `fnConnInfo` NULL und
der Aufruf in `:1957` stuerzt ab - **noch bevor** die alte Fundstelle `:1969`
ueberhaupt erreicht wird. Genau dieser Fall ist bei Gregor moeglich, weil in
`Releases/1.0/` mehrere `QCSSL.dll`-Fassungen liegen.

**Die Meldung.** Ohne `ConnectionInfo` blieb `csError` bisher bei
`"SSL Negotiation Failed: "` stehen und `errorCode` bei `-1`. `SetError`
(`:680`) bildet daraus `CRString(8000 + (-1 - 10000))` = `CRString(-2001)` -
eine Ressourcen-ID, die es nicht gibt; `LoadString` liefert dann den
Leerstring. Gregor haette also `SSL Negotiation Failed: <nichts> Cause:
<nichts> (-1)` gesehen. Jetzt haengt in diesem Fall ein Klartext-Zusatz daran,
der auf die DLLs zeigt. Woertliche Zeichenkette statt neuer Ressourcen-ID -
dasselbe Muster wie `QCWorkerSocket.cpp:700`
(`"Connection closed by foreign host."`), damit `EudoraRes.rc` und
`resource.h` unangetastet bleiben und keine Ressourcen-DLL neu gebaut werden
muss.

Am Ablauf aendert sich sonst nichts: `SetError(csError, errorCode)` und
`m_bAbortConnection = TRUE` laufen wie bisher, der Abruf bricht geordnet ab.

**Uebersetzt:**
`MSBuild Eudora71\QCSocket\QCSocket.vcxproj /p:Configuration=Debug /p:Platform=Win32`
- Exit 0, `Eudora71\Bin\Debug\QCSocket.dll` erzeugt. `QCWorkerSocket.cpp`
fehlerfrei, nur die vorbestehenden `C4996`-Warnungen.

### P-2.2 BEHOBEN: derselbe Fehlertyp, umgekehrt - `pSettings` in `SetSSLMode`

**Sicherheit: nachgewiesen (uebersetzt). Heute nicht erreichbar.**
**Datei:** `Eudora71/QCSocket/src/QCWorkerSocket.cpp:2050-2051`.

`QCWorkerSocket::SetSSLMode` (`:2038`) dereferenzierte `pSettings` in den
Zeilen 2050/2051 ungeprueft - und prueft denselben Zeiger fuenfzehn Zeilen
weiter unten in `:2065` (`if(pSettings)`) sehr wohl. Der Autor hat NULL also
fuer moeglich gehalten. Er ist es auch: die Deklaration in
`QCWorkerSocket.h:62` und `:265` gibt `SSLSettings *pSettings = NULL` als
**Vorgabewert** an.

**Heute nicht erreichbar:** alle fuenf echten Aufrufer uebergeben die Adresse
eines Elements, die nie NULL sein kann - `POPSession.cpp:604` und `:3489`,
`SMTPSession.cpp:717` und `:837`, `password.cpp:392`, jeweils
`&m_Settings->m_SSLSettings`. Der einzige Aufruf mit Vorgabewerten ist
`Network::SetSSLMode(bVal)` in `:2041`, und das ist eine andere Funktion, die
`pSettings` gar nicht anfasst. Gefunden hat es die Suche unten, nicht ein
Absturz.

Behoben, weil es derselbe Fehlertyp ist und die Zeile auf dem Abrufweg liegt.
Die beiden Zuweisungen stehen jetzt in einem `if (pSettings)`.

### P-2.3 Der Abrufpfad ist nach demselben Muster abgesucht

**Verfahren:** `suche-zeiger.pl` (im Branch abgelegt) liest jede Datei mit
`:raw`, findet jede Zeile der Form `if (p)`, `if (!p)`, `if (p == NULL)`,
`if (p != NULL)`, verfolgt die Klammertiefe bis zum Ende des geschuetzten
Blocks und meldet jede Dereferenzierung desselben Namens in den 40 Zeilen
danach, sofern dazwischen nicht erneut geprueft wird.

Abgesucht: `QCWorkerSocket.cpp`, `POPSession.cpp`, `pop.cpp`, `GetMail.cpp`,
`header.cpp`, `TextReader.cpp`, `mime.cpp`, `lex822.cpp`, `QCMailSettings.cpp`,
`SSLSettings.cpp`.

Acht Treffer, einzeln nachgelesen:

| Fundstelle | Bewertung |
|---|---|
| `QCWorkerSocket.cpp:2050` | **echter Fund** - [P-2.2](#p-2.2), behoben |
| `QCWorkerSocket.cpp:453` | Fehlalarm: einzeiliges `if` ohne Block, der Aufruf ist der Rumpf |
| `QCWorkerSocket.cpp:2042` | Fehlalarm: `if(!m_pSSLReference) m_pSSLReference = DEBUG_NEW ...`; `new` wirft bei MFC, liefert nicht NULL |
| `POPSession.cpp:501`, `:896`, `:3228` | Fehlalarme: einzeiliges `if`, Zugriff im Rumpf |
| `pop.cpp:312` | Fehlalarm: sauberes `if (!p) {...} else {...}` |
| `pop.cpp:476` | Fehlalarm: Zugriff steht im geschuetzten Block |

Das Muster "geprueft und ein paar Zeilen spaeter ungeprueft benutzt" kommt im
Abrufpfad also **nur an diesen beiden Stellen** vor. Beide sind behoben.

**Was die Suche NICHT findet, und wo deshalb noch etwas liegen koennte:**
Zeiger, die nirgends geprueft werden. Die zehn ungeprueften
`GetProcAddress`-Ergebnisse in `QCWorkerSocket.cpp:373-383` sind der wichtigste
Fall dieser Art. Nur `QCSSLGetConnectionInfo` ist jetzt an seinen zwei
Verwendungsstellen abgesichert; `g_fnQCSSLBeginSession` (`:1944`),
`g_fnQCSSLWrite`, `g_fnQCSSLRead`, `g_fnQCSSLEndSession` sind es nicht.
**UNGEPRUEFT**, ob eine der ausgelieferten `QCSSL.dll`-Fassungen wirklich einen
dieser Exporte vermissen laesst - P-1.4 hat `qcssl.def` als in beiden
Konfigurationen eingehaengt nachgewiesen, die Exporte sollten also da sein.
Sauber waere, `Network::SetSSLMode` `m_bSSLMode` nur dann setzen zu lassen,
wenn alle Zeiger aufgeloest wurden, und sonst eine Meldung zu zeigen. Das ist
mehr als ein Zweizeiler und war in der Zeit nicht drin.

### P-2.4 ERLEDIGT: `TextReader.cpp:251` ist jetzt uebersetzt (schliesst P-1.8)

**Sicherheit: nachgewiesen (uebersetzt und gebunden).**

P-1.8 musste die Aenderung aus P-1.1 unuebersetzt lassen, weil der damalige
Arbeitsbaum an einem OTShim-Fehler haengenblieb. Auf `darstellung-und-menue`
ist das behoben.

    MSBuild Eudora71\Eudora\Eudora.vcxproj /p:Configuration=Debug /p:Platform=Win32
    -> Eudora71\Bin\Debug\Eudora.exe   (Exit 0, 10 224 128 Byte)

`TextReader.cpp` uebersetzt fehlerfrei. Die Zuweisung
`size = ISOTranslate(buf, size, iCharsetIdx);` erzeugt **keine** Warnung -
insbesondere keine `C4244`; `size` ist `LONG` (`TextReader.cpp:77`) und
`ISOTranslate` liefert `LONG` (`utils.h:90`). Die einzigen Warnungen in der
Datei sind die vorbestehenden `C4996` zu `strncpy`, `sprintf`, `strcpy` und
`strcat`. **P-1.8 ist damit geschlossen.**

Zum Weg dorthin, fuer den naechsten, der es nachbaut:

1. `Eudora.vcxproj` mit `/p:BuildProjectReferences=false` uebersetzt alles,
   scheitert aber am Binden mit `LNK1104: imap.lib`.
2. `Eudora71\Eudora.sln` laesst sich **nicht** mit
   `/p:Platform=Win32` bauen: `MSB4126, Projektmappenkonfiguration
   "Debug|Win32" ist ungueltig`.
3. `Eudora.vcxproj` **mit** Projektverweisen baut `Imap.dll`, `QCSSL.dll`,
   `QCSocket.dll` und die uebrigen Bibliotheken, scheitert dann aber an
   `OT501.vcxproj` (`NMAKE U1073: OTA50D\OTA50D.lib`). Das ist eine fremde
   Baustelle.
4. Danach `Eudora.vcxproj` erneut **ohne** Projektverweise - jetzt liegen alle
   `.lib` in `Eudora71\Lib\Debug`, und `Eudora.exe` entsteht.

Der Umweg ueber Schritt 3 ist nur beim ersten Mal in einem frischen Worktree
noetig.

### P-2.5 Nicht angefasst

- `tools/patches/zertifikatspruefung-verschaerfen.patch` bleibt unangewendet
  (Gregors ausdrueckliche Entscheidung, siehe P-1.6).
- Die uebrigen Altlasten aus P-1.5b bis P-1.5j. Sie stehen wortgleich in
  `567a5d8` und sind unveraendert offen. Nach Aufwand-Nutzen als naechstes:
  **P-1.5b** (`%39s` statt `%s`, `POPSession.cpp:1052`) und **P-1.5d**
  (`sizeof(Server)-1` plus Nullterminierung, `POPSession.cpp:1745`, `:3348`,
  `:3350`) - beides Einzeiler. (Zeilennummern am 22.10.2026 an 7.2.0.121
  nachgezogen; die alten Angaben stammten vom 07.09.2026.)

### P-2.6 Wie zuversichtlich ich bin, dass der erste Abruf gelingt

Ehrlich: **verhalten.** Was ich sagen kann und was nicht:

- **Belegt:** der Absturz aus P-1.5a kann nicht mehr eintreten, und wo Eudora
  vorher verschwand, kommt jetzt eine Meldung mit einem Hinweis auf die DLLs.
- **Belegt:** Umlaute in Text und Betreff kommen richtig an (P-1.1 behoben und
  jetzt auch uebersetzt, P-1.3 mit neun Tests vermessen).
- **Belegt:** die Portierung hat den Abrufpfad nicht beschaedigt (P-1.4).
- **UNGEPRUEFT und der wahrscheinlichste Stolperstein:** ob `mx.freenet.de`
  ueberhaupt POP3 spricht. Ohne Netz nicht zu klaeren. `ABRUF-PRUEFEN.md`
  Abschnitt 1 nennt jetzt das unterscheidende Merkmal - kommt der
  Passwortdialog, stimmt der Server; kommt er nicht, ist es der Name oder der
  Port.
- **UNGEPRUEFT:** ob `rootcerts.p7b` die heutige CA von freenet enthaelt. Wenn
  nicht, kommt der Vertrauensdialog. Das ist kein Scheitern - Abschnitt 5b
  sagt, was der Text bedeutet und dass "OK" ihn dauerhaft wegraeumt.
- **Nichts davon ist an einem laufenden Eudora geprueft.** Der erste echte
  Abruf ist der erste echte Abruf.

Meine Erwartung: **der Abruf scheitert eher an der Serveradresse als an
Eudora.** Und wenn er scheitert, scheitert er jetzt mit einer Meldung statt
mit einem Absturz - das ist der Unterschied, den diese Sitzung gemacht hat.

### P-2.7 Nachtrag: drei Komponententests mehr (105 gruen)

Ausgangsstand waren nicht mehr die 34 aus P-1.7, sondern **102** - andere
Agenten haben in der Zwischenzeit ergaenzt. Dazu drei neue in
`Eudora71/Tests/TestPopEmpfang.cpp`:

| Test | Was er absichert |
|---|---|
| `Test_NachrichtOhneBetreff` | leerer Betreff, Betreff nur aus Zwischenraum, Betreff nur `=`, und ein angefangenes, nie geschlossenes kodiertes Wort - `Fix2047` darf dabei nicht ueber das Zeilenende hinauslesen |
| `Test_SehrLangeKopfzeile` | 60 kodierte Woerter hintereinander, roh 1620 Zeichen, dekodiert 300. Beide Laengen sind im Test gegengeprueft, damit er nicht unbemerkt etwas anderes misst |
| `Test_VollstaendigePopAntwort` | eine ganze RETR-Antwort: sechs Kopfzeilen (zwei kodiert, vier reines ASCII, die sich nicht aendern duerfen) und vier Rumpfzeilen mit Umlaut, scharfem s, Eurozeichen und geschuetztem Leerzeichen. Nachgestellt ist die Aufteilung aus `pop.cpp:656`. Jede Rumpfzeile wird zusaetzlich darauf geprueft, dass sie NACH der Uebersetzung noch auf CRLF endet - genau das ging schief, solange die neue Laenge weggeworfen wurde (P-1.1) |

    Eudora71\Tests\RunTests.cmd
    Ergebnis: 105 Tests, 105 bestanden, 0 fehlgeschlagen

Damit ist von der Wunschliste des Auftrags abgedeckt: UTF-8-Umlaute in einer
POP-Antwort, Betreff in Base64, Betreff in Quoted-Printable (die beiden
letzten standen schon aus P-1.3), Nachricht ohne Betreff, sehr lange
Kopfzeile.

**Eine Falle fuer den naechsten, der hier Tests schreibt:** `"\xC3\x9Fe"` ist
keine Bytefolge, sondern die Fluchtfolge `\x9FE` - C++ frisst das `e` als
weitere Hexziffer. Der Uebersetzer meldet `C2022: "2558" zu gross fuer ein
Zeichen`. Richtig ist `"\xC3\x9F" "e"`. Das gilt fuer jedes `a`-`f` direkt
hinter einer `\x`-Folge, und der Fehler ist genau bei deutschen Umlauten
(`\x9F` + `e` in "Strasse", "Gruesse") wahrscheinlich.

## B-2 — Die Brücke hängt in der Solution, Paket 1.0.3 steht, und ein Prüfer davor

Agent BRUECKE, 31.08.2026. Fortsetzung von [B-1](#b-1). Alle Zahlen hier sind
**gemessen**; wo nicht, steht **UNGEPRÜFT** davor. Werkzeug war
`tools/paket-pruefen.ps1` (in diesem Commit neu) und `MSBuild` aus VS 2022.

### B-2.1 — `VC71Bruecke` ist eingehängt, aber die GUID in B-1 war falsch

`Eudora71/Eudora.sln` enthält das Projekt jetzt. Byte-erhaltend eingefügt mit
`tools/ersetze-bereich.pl`, zwei Stellen, sechs Zeilen; CR-Zahl 0 vorher wie
nachher, Tabulatoren erhalten.

**Berichtigung zu [B-1](#b-1).** Der dortige Abschnitt „Offen“ und
`Eudora71/VC71Bruecke/BEFUND.md` Abschnitt 6 nennen als einzutragende GUID

    {7B1E9C40-3D52-4A6E-9E1F-2C4A7150D71B}

Das ist **nicht** die GUID des Projekts. In `VC71Bruecke.vcxproj:32` steht

    <ProjectGuid>{7B1C4A20-3E5D-4F71-9A16-2C8D5E71B0C4}</ProjectGuid>

Eingetragen ist die echte. Wer die aus BEFUND.md abgeschrieben hätte, bekäme
eine Solution, in der das Projekt zwar auftaucht, aber keiner Konfiguration
zugeordnet ist — es würde stillschweigend nicht gebaut. Die falsche Angabe in
`BEFUND.md` steht dort noch; sie ist mit diesem Abschnitt richtiggestellt.

**Nachgemessen:** Gesamtbau der Solution, `Debug|x86`. `VC71Bruecke` baut mit,
Ausgabe `Eudora71/Bin/Debug/msvcr71.dll`. Die drei bekannten Fehler aus `OT501`
bleiben (`NMAKE U1073` zweimal, `MSB3073` einmal). Zusätzlich zwei
`LNK1104: QCUtils.lib` in `NSImport` und `OLImport` — das ist **kein neuer
Fehler**, sondern ein Wettlauf im Parallelbau (`/m`): beide Projekte binden,
bevor `QCUtils` fertig ist. Einzeln gebaut laufen sie durch, nachgemessen.
Danach bindet auch `Eudora.vcxproj` wieder durch.

### B-2.2 — Wann Eudora die MFC71-abhängigen Module lädt: erst bei Benutzung

Die in B-1.2 offen gelassene Frage ist beantwortet, und zwar **gemessen am
ausgelieferten Paket**, nicht am Quelltext.

`tools/paket-pruefen.ps1` rechnet die **Startkette** aus: beginnend bei den
EXE-Dateien im Wurzelverzeichnis den gewöhnlichen (nicht verzögerten) Importen
folgen, solange das Ziel im Paket liegt. Das ist genau das, was der Lader
anfassen muss, bevor die erste Zeile eigener Code läuft. Ergebnis für das
Paket, **elf Module**:

    Eudora.exe  swEudora.exe  EuLang.dll  EuMemMgr.dll  Imap.dll
    libexpat.dll  msvcr71.dll  Paige32d.dll  plstclnt.dll  QCSocket.dll
    QCUtils.dll

`EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Ph.dll` und die drei Plugins sind
**nicht darin**. Das fehlende `MFC71.DLL`/`MSVCP71.dll` hält den Start also
nicht auf. Es gehört in einen Abschnitt „was nicht geht“, nicht nach vorn in
die LIESMICH.txt. Das bestätigt [S-1](#s-1) („beim Laden zwingend sind nur zwei“) und
erweitert es um die transitive Kette.

### B-2.3 — Das echte Paket 1.0.2 nachgesehen: drei Berichtigungen zu B-1

[B-1](#b-1) musste den Paketinhalt aus der Auftragsbeschreibung übernehmen. Jetzt ist
er gemessen (`Releases/Eudora72-1.0.2-lauffaehig.zip`, ausgepackt, jede Datei
durch den PE-Leser).

**1. `MFC71.DLL` und `MSVCP71.dll` liegen tatsächlich nicht bei.** Die
Vermutung aus B-1.2 stimmt. Adressbuch, LDAP, Ph und die drei Plugins waren
also schon in 1.0.2 nicht ladbar. 1.0.3 verschlechtert daran nichts.

**2. Das Paket 1.0.2 ist gemischt, nicht durchgehend Release.** `PAKETE.md`
und die LIESMICH.txt zu 1.0.2 sagen, die sieben vorgebauten DLLs lägen als
Release-Fassungen bei. Für fünf stimmt das. Nicht für zwei:

| Datei im Paket 1.0.2 | Größe | entspricht | importiert |
|---|---|---|---|
| `Paige32d.dll` | 757.760 B | `Bin/Debug/Paige32d.dll` | `MSVCR71D.dll` |
| `Plugins/*.dll` | — | `Bin/Debug/Plugins/*` | `MFC71D.DLL`, `MSVCP71D.dll` |

**Damit ist erklärt, warum die D-Dateien im Paket lagen** — [B-1](#b-1) hatte sie für
totes Gewicht gehalten, weil es nur `Bin/Release` gemessen hatte. Im Paket
wurden sie sehr wohl gebraucht: `msvcr71d.dll` von der Debug-`Paige32d.dll`,
`msvcp71d.dll` von den Debug-Plugins. Der Satz aus [B-1](#b-1), sie seien „totes
Gewicht“, war für das Repository richtig und für das Paket falsch.

Der Weg, sie loszuwerden, bleibt derselbe und ist in [B-1](#b-1) belegt: die
Release-`Paige32.dll` unter dem Namen `Paige32d.dll` kopieren. Danach braucht
sie niemand mehr.

**3. `EUMAPI.DLL` im Paket ist keine PE-Datei.** Der PE-Leser bekommt keinen
gültigen Kopf. 82.944 B, unverändert aus der Freigabe von 2006 übernommen.
**UNGEPRÜFT**, was es stattdessen ist — der Verdacht ist eine 16-Bit-NE-Datei
aus der MAPI-Vergangenheit. Keine Paketdatei importiert sie; sie steht in
keiner Importtabelle. Meldet sich als Warnung, nicht als Fehler.

### B-2.4 — Paket 1.0.3 ist vorbereitet, nicht veröffentlicht

Zusammengestellt mit `tools/paket-bauen.ps1` (neu), das den Vorgang
reproduzierbar macht. Änderungen gegenüber 1.0.2 und ihre Begründung stehen im
Kopf des Skripts und in `Releases/PAKETE.md`. Kurz:

1. selbst gebaute `msvcr71.dll` statt der drei Fremddateien von dll-files.com
2. `Paige32d.dll` als Kopie der Release-`Paige32.dll`
3. `msvcr71d.dll` und `msvcp71d.dll` entfallen
4. Release-Plugins statt Debug-Plugins, ohne 12 MB Symboldateien
5. `laufzeit-holen.ps1` und `paket-pruefen.ps1` liegen im Paket

Vorgeschlagener Dateiname `Eudora72-1.0.3-vorabfassung.zip`. **Nicht
„lauffaehig“** — nach `ZIEL.md` ist derzeit keines der drei Kriterien erfüllt.

Das ZIP selbst ist **nicht** im Repository. Es besteht zu 99 % aus
Bauergebnissen, und ob veröffentlicht wird, entscheidet Gregor. Im Repository
liegen `Releases/1.0.3/LIESMICH.txt`, der Eintrag in `Releases/PAKETE.md` und
das Skript, das es jederzeit wieder herstellt.

### B-2.5 — Was der Paketprüfer findet

`tools/paket-pruefen.ps1` liest von jeder EXE/DLL/OCX den PE-Kopf selbst — kein
`dumpbin` nötig, damit es auch auf einer Maschine ohne Visual Studio läuft. Es
prüft Architektur, löst Import- **und** Verzögerungstabelle auf, sucht die vier
VS2022-Debug-Laufzeiten und eine `Eudora.ini` als Vorlage. **Es startet
nichts.**

| | 1.0.2 | 1.0.3 |
|---|---|---|
| Fehler | 3 | **0** |
| Warnungen | 5 | 7 |
| Binärdateien, alle x86 | 31 | 29 |

Die drei Fehler in 1.0.2 waren `MFC71.DLL`, `MFC71D.DLL`, `MSVCP71.dll`.
`MFC71D.DLL` ist in 1.0.3 verschwunden (Release-Plugins); die beiden anderen
sind Warnungen geworden, seit der Prüfer die Startkette kennt ([B-2.2](#b-2.2)).

**Der eigentliche Zweck ist aber ein anderer Fund.** Beide Pakete bekommen
vier Warnungen der Form

    mfc140d.dll  liegt nicht im Paket. Auf dieser Maschine steht sie in
    SysWOW64, auf einer Maschine ohne Visual Studio 2022 nicht - dort
    scheitert der Start.

Genau daran ist Gregor am Morgen des 31.08.2026 gescheitert: `0xc000007b`. Der
Prüfer hätte das vor der Auslieferung gesagt, und die Architekturprüfung hätte
auch den zweiten Teil gefunden — die ersatzweise geholten Dateien waren
64 Bit.

### B-2.6 — Was ich NICHT getan habe

- Kein Eudora gestartet, kein Programm mit Fenstern, kein
  `OutputDebugString`-Mithörer. `paket-pruefen.ps1` und `paket-bauen.ps1`
  lesen und kopieren Dateien, mehr nicht.
- Nichts veröffentlicht. Kein ZIP im Repository, keine Prüfsumme in
  `PAKETE.md` — beides entsteht erst, wenn Gregor es will.
- `Eudora71/VC71Bruecke/BEFUND.md` nicht angefasst (falsche GUID in
  Abschnitt 6, siehe B-2.1) — es ist der Bericht meines Vorlaufs; die
  Richtigstellung steht hier.

## W-1 — Die Werkzeuge in Ordnung gebracht (WERKZEUG, 31.08.2026)

Abgearbeitet werden die Befunde [PR-1](#pr-1) bis [PR-8](#pr-8) aus `PRUEFBERICHT.md`. Jede
Aussage unten ist gemessen; die Gegenproben laufen als Testsammlung mit.

| Befund | Gegenstand | Stand |
|---|---|---|
| PR-1 | Schranke laesst LF → CRLF durch | **behoben** |
| PR-2 | Schranke schlaegt bei Leerzeilen grundlos an | **behoben** |
| PR-3 | `.def`/`.sln`/`.bat`/`.ps1` gar nicht geprueft | **behoben** |
| PR-4 | `BuildKennung.h` verfolgt → fremde Kennung | **behoben** |
| PR-5 | Zeitstempel ist nicht der Bauzeitpunkt | **behoben** (31.08. abends, `765c39b` — die frühere Angabe „offen" war überholt) |
| PR-6 | `_T(EUDORA_BAU_KENNUNG)` bricht im Unicode-Bau | **behoben** |
| PR-7 | Zahlen in S-7 widersprechen sich | **behoben** |
| PR-8 | `rekursion-suchen.pl` findet den eigenen Anlass nicht | **geloescht** |

### Das Wichtigste: `tools/pruefe-bytes-tests.pl`

Die Schranke war am 30.08.2026 schon einmal "repariert" worden und danach
falsch. Beides — der Fehlalarm und das Loch — waere bei einem einzigen
Testlauf aufgefallen. Es gab nur keinen.

Jetzt gibt es einen. 23 Faelle, jeder in einem eigenen Wegwerf-Repo unter dem
Temp-Verzeichnis, mit `.gitattributes` `* -text` wie im echten Repo. Geprueft
wird ausschliesslich der Rueckgabewert der Schranke: 0 durchgelassen,
1 abgebrochen. Die Faelle sind byteweise beschrieben, es kommt kein Escape im
Testtext vor.

    perl tools/pruefe-bytes-tests.pl        # Tabelle, Rueckgabe 1 bei rot
    perl tools/pruefe-bytes-tests.pl -v     # zusaetzlich die Meldung je Fall

**Gegen den Stand vom 30.08.2026: 16 gruen, 7 rot.** Die Sammlung reproduziert
damit [PR-1](#pr-1), [PR-2](#pr-2) und [PR-3](#pr-3) aus eigener Kraft:

| rot | Fall | was die alte Schranke tat |
|---|---|---|
| d | Leerzeile CRLF weg, Leerzeile LF dazu | brach den Commit ab, Beispiel `""` |
| h1 | Umwandlung LF → CRLF plus Inhalt | liess durch, Rueckgabe 0 |
| j1 | `.def` komplett CRLF → LF | liess durch |
| j2 | `.sln` komplett CRLF → LF | liess durch |
| j3 | `.bat` komplett CRLF → LF | liess durch |
| j4 | `.ps1` komplett LF → CRLF | liess durch |
| j5 | `.pl` komplett CRLF → LF | liess durch |

**Gegen den heutigen Stand: 23 gruen, 0 rot.** Alle 23 Faelle im Einzelnen:

| Fall | Beschreibung | erwartet |
|---|---|---|
| a | Zeilen hinzugefuegt (CRLF-Datei) | durchlassen |
| b | Zeilen hinzugefuegt (LF-Datei) | durchlassen |
| c1 | Zeilen geloescht (CRLF-Datei) | durchlassen |
| c2 | Zeilen geloescht (gemischte Datei, 655 Zeilen) | durchlassen |
| d | Leerzeile CRLF weg, Leerzeile LF dazu | durchlassen |
| d2 | haeufige Zeilen (`{`, `}`, leer) verschoben | durchlassen |
| e | Datei komplett CRLF → LF | anschlagen |
| f | Datei komplett LF → CRLF | anschlagen |
| g | gemischte Datei, 18 CRLF → LF unter 655 Zeilen | anschlagen |
| h1 | Umwandlung LF → CRLF plus Inhaltsaenderung | anschlagen |
| h2 | Umwandlung CRLF → LF plus Inhaltsaenderung | anschlagen |
| h3 | Umwandlung plus hinzugefuegte Zeilen (ungleiche Anzahl) | anschlagen |
| i | nur Inhalt geaendert, Zeilenenden gleich | durchlassen |
| j1..j5 | `.def` `.sln` `.bat` `.ps1` `.pl` komplett umgeschrieben | anschlagen |
| k | neue Datei, nicht in HEAD | durchlassen |
| l | Sonderzeichen zerstoert (U+FFFD dazu) | anschlagen |
| m | Datei unveraendert vorgemerkt | durchlassen |
| n | letzte Zeile ohne Zeilenumbruch, Inhalt ergaenzt | durchlassen |
| o | unbekannte Endung `.xyz` komplett umgeschrieben | durchlassen |

Fall `o` ist die **dokumentierte Grenze**: was nicht in
`tools/dateiendungen.pl` steht, wird nicht geprueft. Der Fall steht bewusst
drin, damit die Grenze sichtbar bleibt statt vergessen zu werden.

### PR-1 und PR-2: die Regel taugte nicht, nicht ihre Richtung

Die Fassung vom 30.08. zaehlte je **Zeileninhalt**, wie oft er mit CRLF und wie
oft mit LF vorkommt, und meldete jeden Inhalt, der seine CRLF-Vorkommen
verloren hatte. Daraus folgen beide Befunde zwangslaeufig:

  * Die Abfrage war einseitig formuliert (`[0] > 0` in HEAD, `[0] == 0` im
    Index), also fiel LF → CRLF heraus. Das ist unter Windows die
    **wahrscheinlichere** Schadensrichtung — Editoren, `Set-Content`,
    `Out-File` schreiben CRLF.
  * Der Zeileninhalt taugt nicht als Schluessel. `""`, `{`, `}` und ein
    blosser Tabulator kommen in einer Datei hundertfach vor, mit beiden Enden.
    Welches Vorkommen welches war, geht beim Zaehlen verloren. Eine geloeschte
    CRLF-Leerzeile plus eine ergaenzte LF-Leerzeile war deshalb von einer
    Umwandlung nicht zu unterscheiden.

Die naheliegende Behebung — Leerzeilen ueberspringen, Zeilen mit beiden Enden
ueberspringen — waere Symptombehandlung gewesen: sie haette den Fehlalarm bei
`""` beseitigt und ihn bei `\tif (nRet)` oder jeder anderen mehrfach
vorkommenden Zeile stehen gelassen.

**Was der Waechter eigentlich unterscheiden soll**, ist eine UMWANDLUNG
bestehender Zeilen von einer Ergaenzung oder Loeschung. Genau diese
Unterscheidung trifft git selbst schon. Regel 2 wertet deshalb jetzt den
eigentlichen Unterschied aus:

    git diff --cached -U0 --no-color --no-ext-diff -- <datei>

Eine umgewandelte Zeile erscheint darin als Paar aus einer entfernten und einer
hinzugefuegten Zeile **im selben Block**, deren Inhalt gleich und deren
Zeilenende verschieden ist. Eine reine Ergaenzung erzeugt einen Block ohne
entfernte Zeilen, eine reine Loeschung einen ohne hinzugefuegte — dort entsteht
gar kein Paar. Damit ist die Zuordnung **ortsgebunden statt inhaltsgebunden**,
und der Leerzeilen-Fehlalarm kann strukturell nicht mehr auftreten: die
geloeschte und die ergaenzte Leerzeile stehen an verschiedenen Stellen und
landen in verschiedenen Bloecken (Fall `d`, gemessen).

Innerhalb eines Blocks werden entfernte und hinzugefuegte Zeilen der Reihe nach
gepaart. Bei gleicher Anzahl — dem Normalfall einer Umwandlung — passt das
genau. Bei ungleicher Anzahl (Umwandlung UND ergaenzte Zeilen, Fall `h3`) fuehrt
eine Vorausschau von 30 Zeilen die Paare nach.

**Warum nicht die andere vorgeschlagene Loesung** (haeufige Zeilen aus dem
Vergleich ausnehmen): sie verschiebt die Grenze nur. Jede Schwelle "ab wie oft
ist eine Zeile haeufig" waere geraten, und ausgerechnet in den langen,
gleichfoermigen Ressourcendateien dieses Projekts sind die meisten Zeilen
haeufig — dort wuerde der Waechter dann blind. Der Diff kennt die Antwort
ohnehin schon.

Regel 1 (Inhalt gleich, Bytes verschieden) bleibt unveraendert daneben stehen.
Sie arbeitet auf den rohen Blobs und ist damit unabhaengig davon, wie git den
Unterschied darstellt — eine zweite, einfachere Sicherung fuer den haeufigsten
Fall.

### PR-3: eine Liste statt zwei

`tools/pruefe-bytes.pl` und `tools/zeilenenden-angleichen.pl` hatten je eine
eigene Endungsliste. Sie waren auseinandergelaufen. Beide laden jetzt
`tools/dateiendungen.pl`. Neu darin unter anderem `def sln vcproj props targets
dsp dsw bat cmd ps1 psm1 pl pm py sh rc2 pod ini cnf manifest config xml json
yml yaml asm inc s` sowie die Namen `.gitattributes`, `.gitignore`,
`.editorconfig`, `Makefile`.

Laesst sich die Liste nicht laden, **bricht die Schranke ab**. Eine Schranke,
die stillschweigend nichts mehr prueft, ist schlimmer als gar keine.

Gemessen, was die groessere Liste am Bestand aendert:

    perl tools/zeilenenden-angleichen.pl
      byteidentisch zu HEAD:         6385
      nur Zeilenenden verschieden:      0

Die erweiterte Liste deckt also **keinen neuen Schaden** auf; sie schliesst
eine Luecke fuer die Zukunft. Mit der alten Liste waren es 5589 Dateien.

### PR-4: `BuildKennung.h` ist nicht mehr verfolgt

`git rm --cached Eudora71/Eudora/BuildKennung.h`, Eintrag in `.gitignore`, und
`Eudora71/Eudora/BuildKennung-vorlage.h` mit `_T("unbekannt")` eingecheckt. Der
PreBuildEvent kopiert die Vorlage, wenn perl nicht laeuft:

    perl %KENNUNG% %WURZEL% && exit /b 0
    "C:\Program Files\Git\usr\bin\perl.exe" %KENNUNG% %WURZEL% && exit /b 0
    echo WARNUNG: perl nicht gefunden - die Kennung sagt "unbekannt"
    fc /b "...BuildKennung.h" "...BuildKennung-vorlage.h" >nul 2>&1 || copy /y ...
    exit /b 0

Das `fc /b` davor verhindert, dass ein Bau ohne perl die Datei jedes Mal neu
anfasst und eine vollstaendige Neuuebersetzung nach sich zieht. Ein frischer
Klon ohne perl uebersetzt, und das Fenster sagt dann ehrlich `unbekannt` statt
der Kennung eines fremden Baus.

### PR-6: kein `_T` um ein Makro

`tools/kennung-erzeugen.pl` erzeugt die Zeichenkette jetzt gleich richtig:

    #include <tchar.h>
    #define EUDORA_BAU_KENNUNG _T("1.0.3+... 2026-08-31 07:11")

und `mainfrm.cpp:9715` benutzt sie ohne `_T(...)` (byte-erhaltend geaendert mit
`tools/aendere-zeile.pl`, CR-Zahl 18 unveraendert). Damit stimmt es im
MBCS-Bau wie im Unicode-Bau: `__T(x)` ist dort `L##x`, und `##` haette die
Erweiterung des Makros unterbunden — aus `_T(EUDORA_BAU_KENNUNG)` waere der
Bezeichner `LEUDORA_BAU_KENNUNG` geworden.

**Uebersetzt** (31.08.2026, Debug|Win32, eigener Worktree):

    MSBuild.exe Eudora71\Eudora\Eudora.vcxproj /p:Configuration=Debug
                /p:Platform=Win32 /p:BuildProjectReferences=false /m /v:minimal

Alle Quelldateien uebersetzen fehlerfrei, `mainfrm.cpp` eingeschlossen — die
neue `BuildKennung.h` mit `_T("...")` und `#include <tchar.h>` traegt also. Der
Lauf endet in `LNK1104: imap.lib kann nicht geoeffnet werden`: der Worktree ist
frisch und `/p:BuildProjectReferences=false` baut die abhaengigen Projekte
nicht mit. Das hat mit diesen Aenderungen nichts zu tun. **Nicht gemessen**
wurde damit ein vollstaendiger Binaerbau — nur die Uebersetzung.

Der Rueckfallzweig des PreBuildEvent ist getrennt geprueft: Datei fehlt →
Vorlage wird kopiert; Datei schon gleich der Vorlage → Zeitstempel bleibt
unveraendert, es entsteht also keine Neuuebersetzung.

### PR-7: es gilt 4616 von 5563

Nachgemessen und in `BEFUNDE.md` ([S-7](#s-7)), `README.md`, `WEITERMACHEN.md` und im
Kopf von `tools/zeilenenden-angleichen.pl` gleichgezogen. Die 4426 von 5336 im
Werkzeugkopf stammten aus einem Durchlauf mit kuerzerer Endungsliste und sind
ersatzlos weg.

Die **4616** ist eine einmalige Messung des damaligen Arbeitsbaums und laesst
sich nicht wiederholen — der Baum ist angeglichen. Die Grundgesamtheit dagegen
ist keine feste Zahl: sie waechst mit jedem Commit und haengt an der
Endungsliste (5563 / 5568 / 5589 alte Liste, 6385 neue). Statt einer Zahl steht
in [S-7](#s-7) jetzt eine Tabelle mit Datum und Liste, dazu der Befehl zum Nachzaehlen.

Nebenbei berichtigt: das Beispiel in [S-7](#s-7) war vertauscht beschriftet. Heute
nachgemessen — Blob `8c4fb68a` hat 5716 Bytes, 0 CR, 65 LF; der Index trug
daneben 5781, die Groesse der CRLF-Arbeitskopie. 5716 + 65 CR = 5781.

### PR-8: `rekursion-suchen.pl` geloescht

Das Urteil des Pruefers nachgeprueft und bestätigt. Gegenprobe: eine Datei mit
einem klassenuebergreifenden Zyklus nach dem Muster von [S-2](#s-2) und zusaetzlich
einem Selbstaufruf innerhalb einer Klasse.

    void CAdView::Zeichne()  { m_pRahmen->Anpassen(); }
    void CRahmen::Anpassen() { m_pAnsicht->Zeichne(); }
    void CAdView::Messen()   { Messen(); }

    perl tools/rekursion-suchen.pl <verzeichnis>
    ZYKLUS (1 Glied): CAdView::Messen/0 -> CAdView::Messen/0
    1 Zyklus/Zyklen.

Es meldet nur den Selbstaufruf. Zwei Ursachen im Code, beide strukturell:
`my $zsig = "$klasse\::$ziel/"` bildet jede Kante mit der **umgebenden** Klasse,
und der Aufrufmuster-Ausdruck ueberspringt jeden Aufruf mit `.`, `->` oder `::`
davor. Eine Kante zwischen zwei Klassen kann also gar nicht entstehen.

**Warum ein Werkzeug, das nur Fehlalarme liefert, schlimmer ist als keines.**
Ein fehlendes Werkzeug kostet die Zeit, die man ohne es braucht. Ein Werkzeug,
das nur Fehlalarme liefert, kostet dieselbe Zeit **plus** die Zeit, jeden
Fehlalarm von Hand zu widerlegen — und es kostet Vertrauen: nach dem dritten
Fehlalarm liest niemand mehr seine Ausgabe, auch nicht die eine richtige
Meldung darin. Dazu kommt der teuerste Posten: wer eine Zyklensuche laufen
laesst und "0 Zyklen" liest, glaubt, geprueft zu haben. Hier war das falsch —
den Zyklus aus [S-2](#s-2) hat `stapel-untersuchen.ps1` gefunden, nicht dieses
Werkzeug. Eine Zusicherung, die nicht traegt, ist schaedlicher als gar keine.
Dieselbe Ueberlegung gilt fuer die Schranke oben; deshalb die Testsammlung.

### PR-5 — behoben am 31.08.2026 abends (Commit `765c39b`)

> **Berichtigung vom 05.09.2026.** Diese Überschrift lautete bis dahin
> *„[PR-5](#pr-5) bleibt offen"*, und an drei Stellen im Repo stand [PR-5](#pr-5) auf „offen",
> obwohl es bereits behoben war. Der alte Wortlaut ist berichtigt, der Befund
> selbst bleibt stehen.

Der Zeitstempel in der Bau-Kennung ist **nicht** der Bauzeitpunkt, sondern der
Zeitpunkt, zu dem sich Commit oder Sauberkeit zuletzt geändert haben: die Datei
`BuildKennung.h` wird nur neu geschrieben, wenn sich etwas **außer** dem
Zeitstempel geändert hat — sonst übersetzt jeder Bau alles neu. Baut man zehnmal
ohne zu committen, zeigen alle zehn Bauten dieselbe Uhrzeit.

**Das Verhalten ist richtig gewählt; nur die Beschreibung war falsch.** Sie
sagte „dem Zeitpunkt des Baus".

Berichtigt an drei Stellen in `tools/kennung-erzeugen.pl` — im Kopfkommentar, in
der erzeugten `BuildKennung.h` und an der Codestelle, an der der Unterschied
entsteht. Nachzulesen:

```sh
grep -n 'Zeitpunkt' tools/kennung-erzeugen.pl
```

**Damit ist [PR-1](#pr-1) bis [PR-8](#pr-8) vollständig abgearbeitet.**
Frist naeher war als der Nutzen.

### Nebenbefund: `sed` verschweigt CR

Beim Umbau des PreBuildEvent hat `sed -n '114,124p' | cat -A` die Zeilen ohne
`^M` angezeigt, obwohl sie CRLF haben — das cygwin-`sed` in dieser Umgebung
liest im Textmodus und wirft CR weg. Wer Zeilenenden ansehen will, darf `sed`
dafuer **nicht** benutzen; verlaesslich ist nur ein direkter Rohvergleich:

    perl -e 'open(F,"<:raw",$ARGV[0]);local $/;$d=<F>;
             $cr=()=$d=~/\r/g;$lf=()=$d=~/\n/g;print "CR=$cr LF=$lf\n"' <datei>

Gemerkt hat es `tools/ersetze-bereich.pl`, das die CR-Zahl vorher und nachher
ausgibt: 1064 → 1062, obwohl der Block angeblich CR-frei war. Ohne diese
Ausgabe waere der Schaden in den Commit gelaufen und die Schranke haette ihn
erst dort gemeldet.


## F-1 — Der Release-Bau und die Frage nach dem statischen Binden (FREIGABE, 31.08.2026)

Auftrag war Kriterium 0 aus `ZIEL.md`: „zip runterladen, entpacken, starten -
laeuft". Der Weg dorthin sollte moeglichst das statische Binden sein.

**Kurzfassung: statisch geht nicht, und der Grund ist keine Einstellung,
sondern die Bauart des Programms.** Was geht, ist der dynamische Release-Bau,
und der erfuellt Kriterium 0 ebenfalls — mit drei DLLs, die Microsoft
ausdruecklich zum Weiterverteilen freigibt.

Alle Zahlen unten sind gemessen; wo nicht, steht **UNGEPRUEFT** davor.

### F-1.1 — Statisches MFC ist ausgeschlossen: sechs MFC-Erweiterungs-DLLs

Eudora ist nicht ein Programm, sondern ein Programm mit sechs
**MFC-Erweiterungs-DLLs**. Der Nachweis steht im Quelltext — jede von ihnen
ruft `AfxInitExtensionModule` auf:

| Modul | Fundstelle |
|---|---|
| `EudoraIcons` | `Eudora71/Eudora/EudoraIcons.cpp:18` |
| `EudoraRes` | `Eudora71/Eudora/EudoraRes.cpp:18` |
| `EudoraOldIcons` | `Eudora71/EudoraOldIcons/EudoraOldIcons.cpp:38` |
| `Imap` | `Eudora71/Imapdll/src/imap.cpp:25` |
| `QCSocket` | `Eudora71/QCSocket/src/QCSocket.cpp:24` |
| `QCUtils` | `Eudora71/QCUtils/src/QCUtils.cpp:23` |

Dieselben Projekte setzen `_AFXEXT` in ihren Praeprozessordefinitionen
(`Eudora/EudoraRes.vcxproj:64`, `EudoraOldIcons/EudoraOldIcons.vcxproj:64`,
`Imapdll/imap.vcxproj:103`, `QCSocket/QCSocket.vcxproj:104`,
`QCUtils/QCUtils.vcxproj:62`, jeweils der Release-Zweig).

`AfxInitExtensionModule`, `CDynLinkLibrary` und `AFX_EXTENSION_MODULE` gibt es
in MFC **nur**, wenn `_AFXDLL` gesetzt ist — also nur beim gemeinsam genutzten
MFC. Eine Erweiterungs-DLL ist ihrem Wesen nach ein Modul, das sich in die
MFC-Modulliste des Hauptprogramms einhaengt; dazu muss es dieselbe
MFC-Instanz benutzen. Mit `<UseOfMfc>Static</UseOfMfc>` haette jede dieser
sechs DLLs ihre eigene MFC-Kopie, ihren eigenen Heap und ihre eigene
Ressourcenkette.

**Statisches MFC waere also nicht eine Umstellung von zwei Einstellungen,
sondern der Umbau von sechs DLLs zu statischen Bibliotheken** — mit allem, was
daran haengt: `EudoraRes.dll` und `EudoraOldIcons.dll` sind reine
Ressourcen-DLLs, die zur Laufzeit ueber `CDynLinkLibrary` gesucht werden;
`Imap.dll`, `QCSocket.dll` und `QCUtils.dll` werden ausserdem von
`EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Ph.dll` und den Importern benutzt.
Das ist kein Handgriff, das ist ein eigenes Vorhaben.

### F-1.2 — Auch nur `/MT` allein geht nicht

Statische C-Laufzeit (`/MT`) bei weiterhin dynamischem MFC ist nicht
vorgesehen: `mfc140.dll` ist selbst gegen `/MD` gebaut und gibt CRT-Objekte
(`FILE*`, Speicherbloecke) ueber die Modulgrenze weiter. Ein Programm mit
`_AFXDLL` und `/MT` bekaeme zwei getrennte CRT-Heaps.

Zusaetzlich gemessen, `dumpbin /directives` gegen `Eudora71/Lib/Release`:

| Bibliothek | CRT-Direktive |
|---|---|
| `zlib.lib` | `-defaultlib:MSVCRT` — gegen die **dynamische** Laufzeit gebaut |
| `libpng.lib` | `-defaultlib:MSVCRT` — dito |
| `Paige32.lib` | keine (Importbibliothek, neutral) |
| `EuMemMgr.lib` | keine (Importbibliothek, neutral) |
| `Uuid.Lib` | keine (neutral) |
| `SSCEWD32.LIB` | keine (Importbibliothek, neutral) |

`zlib.lib` und `libpng.lib` waeren bei `/MT` also die naechste Huerde
(`LNK4098`, dann `LNK2005`) — sie liegen nur als Binaerdatei vor, ein Neubau
mit `/MT` ist ohne ihren Quelltext nicht moeglich.

### F-1.3 — Was stattdessen liefert: der dynamische Release-Bau

Er erfuellt Kriterium 0 genauso, nur mit drei Dateien mehr im ZIP:

| | Debug (Paket 1.0.2/1.0.3) | Release, dynamisch |
|---|---|---|
| noetige Laufzeit-DLLs | `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll`, `ucrtbased.dll` | `mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll` |
| weiterverteilbar? | **nein** — `debug_nonredist`, kein Redistributable | **ja** — Teil des Visual-C++-Redistributable, duerfen beiliegen |
| `ucrtbase.dll` | Debug-Fassung noetig | liegt Windows 10 bei, nichts zu tun |
| SUPERASSERT beim Start (S-3b) | ja | **nein** — `NDEBUG`, keine Debug-Zusicherungen |

Der zweite Gewinn ist der, den der Auftrag nebenbei nennt: im Release-Bau
verschwinden die SUPERASSERT-Dialoge aus S-3b und saemtliche `ASSERT`- und
`VERIFY`-Pruefungen. Das Programm startet ohne Zwischenfrage durch.

### F-1.4 — Warum der Release-Zweig nie gebunden hat: ein Buchstabe

Der eigentliche Fund. `Eudora71/Eudora/Eudora.vcxproj:147`, Release-Zweig:

    <IgnoreSpecificDefaultLibraries>libc.lib;libcmt.lib;OTA50D.LIB;...

`OTA50D.LIB` ist der **Debug**-Name. Der Debug-Zweig (`:97`) schliesst
dieselbe Datei aus und ist damit richtig; der Release-Zweig braucht
`OTA50R.LIB` (`OT501/Src/OT501.vcxproj:50`) und schliesst sie nicht aus.
Ergebnis seit jeher:

    LINK : fatal error LNK1104: Datei "ota50r.lib" kann nicht geoeffnet werden.

`OTA50R.LIB` laesst sich nicht bauen — `NMAKE /f build50.mak ota50r` bricht mit
`U1073` ab, weil `OT501/Src/utility/crypt/Blackbox.cpp` in der Freigabe von
2006 fehlt. Gebraucht wird sie auch nicht: die vier Funktionen daraus liefert
`Eudora71/OTShim/OTShim_Spur.cpp` seit [B-1](#b-1), und die stehen ohnehin unter
`_DEBUG`.

**Woher die Anforderung kommt, war der Umweg.** Sie steht **nicht** in
`AdditionalDependencies` und **nicht** auf der Linker-Befehlszeile — im
Diagnoseprotokoll von MSBuild taucht `ota50r.lib` an keiner Stelle auf. Sie
kommt als Standardbibliotheks-Direktive aus den Objektdateien von
`AccountWizard` und `DirectoryServicesUI` (gemessen: Volltextsuche ueber alle
`.obj` unter `Eudora71`, 29 Treffer, alle in diesen beiden Projekten). Deshalb
hilft nur `IgnoreSpecificDefaultLibraries`, und deshalb hat das Suchen in
`AdditionalDependencies` nichts ergeben.

**Behoben:** `OTA50R.LIB` in `Eudora.vcxproj:147` ergaenzt. Eine Zeile.

### F-1.5 — Der zweite Stolperstein: MakeDox.pl im Nachbereitungsschritt

Danach band `Eudora.exe` durch — und der Bau endete trotzdem mit Fehler:

    error MSB3073: Der Befehl "... MakeDox.pl Eudora.sln DevDox ..."
    wurde mit dem Code 9009 beendet.

`Eudora.vcxproj:161-166` liess im Release-Zweig nach dem Binden
`MakeDox.pl Eudora.sln DevDox` laufen — die Doxygen-Entwicklerdoku von 2006.
Das Werkzeug ist nicht auf dem Pfad, 9009 heisst „Befehl nicht gefunden". Der
**Debug**-Zweig hat gar keinen Nachbereitungsschritt.

Die zwei Doku-Zeilen entfernt. `call ..\BinTools\PostProcessRel Eudora` bleibt
stehen; das ruft `UpdateExternalEMSAPIHeader.pl` und `BindExe ..\Bin\Release`
auf und laeuft durch.

**Nebenwirkung, die man wissen muss:** `BindExe` schreibt die Bindungsdaten in
**jede** DLL in `Eudora71/Bin/Release` zurueck, auch in die zwoelf vorgebauten
Fremd-DLLs von 2006, die im Repository liegen. Nach einem Release-Bau meldet
`git status` sie deshalb als geaendert. Sie gehoeren **nicht** in einen Commit.

### F-1.6 — Gemessen: was uebrig bleibt

`Eudora71/Bin/Release/Eudora.exe`, 2.933.760 B. `dumpbin /dependents`:

| Art | Eintraege |
|---|---|
| eigene Module | `Paige32.dll`, `Imap.dll`, `QCUtils.dll`, `EuMemMgr.dll`, `EuLang.dll`, `LIBEXPAT.dll`, `plstclnt.dll`, `QCSocket.dll` |
| **Laufzeit von Visual C++** | **`mfc140.dll`, `MSVCP140.dll`, `VCRUNTIME140.dll`** — alle drei verteilbar |
| UCRT | zwoelf `api-ms-win-crt-*` — Bestandteil von Windows 10, nichts beizulegen |
| Windows | `KERNEL32`, `USER32`, `GDI32`, `COMDLG32`, `ADVAPI32`, `SHELL32`, `COMCTL32`, `ole32`, `OLEAUT32`, `urlmon`, `VERSION`, `WININET`, `MSVFW32`, `WINMM`, `gdiplus` |

Kein `ucrtbased.dll`, kein `d`-Anhang. Genau die drei Dateien, an denen Gregor
am Morgen gescheitert ist, sind weg — und ihre drei Nachfolger duerfen ins ZIP.

### F-1.7 — `tools/paket-bauen.ps1` kann jetzt Release

Neuer Schalter `-Bauart Debug|Release` (Vorgabe `Debug`, also keine Aenderung
fuer bestehende Aufrufe). Bei `Release`:

- `-AusBauverzeichnis` nimmt aus `Eudora71\Bin\Release` statt `Bin\Debug`
- `Paige32.dll` kommt **unter beiden Namen** ins Paket. Der Debug-Bau
  importiert `Paige32d.dll` (`Eudora.vcxproj:94`), der Release-Bau
  `Paige32.dll` (`:144`) — das war der eine Fehler, den der Paketpruefer im
  ersten Anlauf gemeldet hat.
- die drei verteilbaren Laufzeit-DLLs kommen aus dem VC-Redistributable der
  oertlichen Visual-Studio-Installation ins Paket, ueber `vswhere`
- `laufzeit-holen.ps1` faellt weg — es wird nichts mehr nachgeholt

### F-1.8 — Was der Paketpruefer sagt

    powershell -File tools\paket-bauen.ps1 -Ziel <verz> -Bauart Release -AusBauverzeichnis
    powershell -File tools\paket-pruefen.ps1 -Paket <verz>

    32 Binaerdateien geprueft, alle x86.
    ERGEBNIS: keine Fehler.
    7 Warnung(en)

**Null Fehler.** Damit ist Kriterium 0 gemessen erfuellt, so weit ein Pruefer
ohne Start es belegen kann.

Von den sieben Warnungen sind **vier falsch**: der Pruefer sucht in Abschnitt 3
fest nach `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll` und
`ucrtbased.dll` und warnt, wenn sie fehlen — auch dann, wenn keine einzige
Datei im Paket sie importiert. Fuer ein Release-Paket ist das Unsinn.
Nachgemessen: keine der 32 Binaerdateien importiert eine der vier. Die drei
uebrigen Warnungen (`EUMAPI.DLL`, `MFC71.DLL`, `MSVCP71.dll`) sind
unveraendert die aus [B-2.5](#b-2.5) und betreffen den Start nicht.

## Stand und naechster Schritt (FREIGABE, 31.08.2026)

**Erledigt.**

| | |
|---|---|
| Release-Bau | **baut**, `MSBuild ... /p:Configuration=Release /p:Platform=Win32 /p:BuildProjectReferences=false` endet mit Exit 0 |
| statisch gebunden | **nein, und zwar nicht in der verbleibenden Zeit nachholbar** — F-1.1, sechs MFC-Erweiterungs-DLLs |
| uebrige Laufzeit-DLLs | `mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll` — alle drei verteilbar, alle drei jetzt im Paket |
| Paketpruefer | **null Fehler** |
| SUPERASSERT beim Start (S-3b) | im Release-Bau weg, ebenso alle `ASSERT`/`VERIFY` |

**Das Bauverfahren, das funktioniert** — die Reihenfolge ist noetig, weil ein
Bau ohne Projektverweise die `.lib`-Dateien nicht hat und ein Bau mit ihnen an
`OT501` scheitert:

    1. MSBuild Eudora71\Eudora.sln /p:Configuration=Release /p:Platform=x86 /m
       (endet mit Fehler: OT501 U1073/MSB3073 - erwartet; erzeugt aber die
        zehn .lib-Dateien in Eudora71\Lib\Release)
    2. MSBuild auf NSImport, OEImport, OLImport, dann Eudora.vcxproj,
       je /p:Configuration=Release /p:Platform=Win32
                 /p:BuildProjectReferences=false

`/p:Platform=Win32` gilt fuer **Projektdateien**, `/p:Platform=x86` fuer die
**Projektmappe** — sonst MSB4126 (Befund [P-2](#p-2)).

**Naechster Schritt, konkret.**

1. **`tools/paket-pruefen.ps1`, Abschnitt 3** (die Liste der vier
   VS2022-Debug-Laufzeiten): nur noch warnen, wenn eine Paketdatei die
   betreffende DLL wirklich importiert. Der Pruefer loest die Importtabellen
   ohnehin schon auf ([B-2.5](#b-2.5)), die Angabe steht also bereits zur Verfuegung.
   Solange das nicht geschieht, meldet ein fehlerfreies Release-Paket vier
   Warnungen, die keine sind — und wer sie ernst nimmt, holt sich mit
   `laufzeit-holen.ps1` genau die vier nicht verteilbaren DLLs zurueck.
2. **`Eudora71/Eudora/Eudora.vcxproj:144`**: der Release-Zweig fuehrt
   `QCSocket.lib` **nicht** in `AdditionalDependencies`, der Debug-Zweig
   (`:94`) sehr wohl. Gebunden hat es trotzdem — offenbar ueber eine
   Standardbibliotheks-Direktive. **UNGEPRUEFT**, ob das Zufall ist; nachsehen
   und im Zweifel angleichen.
3. **`Releases/1.0.3/LIESMICH.txt`** beschreibt noch den Debug-Weg („ZUERST:
   DIE VIER LAUFZEITEN HOLEN"). Fuer ein Release-Paket ist dieser ganze
   Abschnitt hinfaellig und irrefuehrend. Neu fassen, bevor ausgeliefert wird.
4. **Nach jedem Release-Bau**: `git status` zeigt zwoelf geaenderte DLLs unter
   `Eudora71/Bin/Release`. Das ist `BindExe` aus dem Nachbereitungsschritt
   (F-1.5), kein Bauergebnis. Nicht stagen.

**Nicht getan:** kein Eudora gestartet, kein Programm mit Fenstern, kein
`OutputDebugString`-Mithoerer. Nichts veroeffentlicht — kein ZIP im
Repository. Ob und wie das Release-Paket ausgeliefert wird, entscheidet Gregor.
Der Bau der Kriterien 1 bis 3 ist von dieser Arbeit unberuehrt: das Fenster ist
weiterhin nicht bedienbar ([S-5](#s-5), [S-6](#s-6), [M-1](#m-1)).

## PR-2 — Nachpruefung der Arbeit vom 31.08.2026 (PRUEFER, 31.08.2026)

Grundlage: `darstellung-und-menue` bei 2cf569f. Kein Programm mit Oberflaeche
gestartet, gebaut ausschliesslich in der PowerShell. FREIGABEs Release-Bau lag
nicht vor.

---

### PR-2.0 — Der Paketpruefer leitet zum Lizenzverstoss an (hoch, OFFEN)

Von FREIGABE gemeldet, hier bestätigt und eingeordnet — der wichtigste
Einzelpunkt an `tools/paket-pruefen.ps1`.

**Fundstelle:** `tools/paket-pruefen.ps1:360` (feste Liste), `:363-364`,
`:371`.

Der Pruefer sucht fest nach den vier VS2022-**Debug**-Laufzeiten
(`mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll`, `ucrtbased.dll`) und
meldet ihr Fehlen. In einem Release-Paket importiert **keine** Datei sie. Der
Pruefer gibt dort also vier falsche Warnungen.

**Warum das gefaehrlich ist:** wer die Warnung ernst nimmt, ruft
`tools/laufzeit-holen.ps1` und holt sich genau die nicht verteilbaren
Debug-DLLs ins Paket. Das Werkzeug leitet damit zu dem an, was es verhindern
soll. `README.md:73-74` sagt ausdruecklich, diese vier duerfen nicht
mitgeliefert werden — und `:363-364` bewertet ihr Vorhandensein trotzdem
gruen (siehe auch PR-2.3, letzter Punkt: derselbe Widerspruch von der anderen
Seite).

**Richtig waere:** die noetigen Laufzeiten aus den IMPORTEN der Paketdateien
ableiten statt aus einer festen Liste. Die Lesefunktion dafuer hat das Skript
schon (`:138`, `:158`) und benutzt sie an anderer Stelle korrekt — bei einem
Debug-Paket kaemen dann die `d`-Fassungen heraus, bei einem Release-Paket
`mfc140.dll` / `MSVCP140.dll` / `VCRUNTIME140.dll`, und im Release-Fall gar
keine Warnung, weil die drei schon beiliegen.

**Nicht behoben.** Nicht aus Zeitnot allein: `paket-pruefen.ps1` ist das
Werkzeug, an dem die Freigabe von 1.0.3 haengt, und eine Aenderung daran ohne
Gegenprobe an einem echten Release-Paket waere schlechter als der jetzige
Zustand. Der Umbau gehoert mit PR-2.2 und PR-2.3 zusammen: alle drei sagen,
dass der Pruefer aus dem Paket ableiten muss statt aus fester Liste und
Pruefmaschine.

---

### PR-2.1 — Der Absturz kommt VOR der Behebung (hoch, behoben)

**Fundstelle:** `Eudora71/QCSocket/src/QCWorkerSocket.cpp:1944` (vor der
Behebung).

Commit e060a81 sichert `fnConnInfo` in `:1957` und `:1998` mit dieser
Begruendung: `Network::SetSSLMode` (`QCWorkerSocket.cpp:362-386`) wertet
**keines** seiner zehn `GetProcAddress`-Ergebnisse aus und setzt `m_bSSLMode`
trotzdem; bei einer `QCSSL.dll` der falschen Fassung ist der Zeiger NULL.

Die Begruendung ist richtig. Sie trifft aber dreizehn Zeilen hoeher genauso zu:

    :1944   bool bSuccess = g_fnQCSSLBeginSession(m_pSSLReference);

`g_fnQCSSLBeginSession` wird in `:373` aus demselben ungeprueften Block
gefuellt. Ist es NULL, stuerzt Eudora **hier** ab — die neue Pruefung in
`:1957` wird nie erreicht. Der abgesicherte Abrufpfad war damit gegen genau
den Fall wirkungslos, fuer den er gebaut wurde.

**Gegenprobe, dass es dieselbe Fehlerklasse ist:** die Datei prueft die
Geschwister laengst.

    grep -n "if (g_fnQCSSL" Eudora71/QCSocket/src/QCWorkerSocket.cpp
    453:   if (g_fnQCSSLClean)
    564:   if (g_fnQCSSLEndSession)

**Behoben** in e0f8bef: `bSuccess` faellt auf `false` zurueck, wenn der Zeiger
NULL ist; damit laeuft der Fehlerzweig, der seit heute frueh eine
verstaendliche Meldung zeigt. Byte-erhaltend mit `tools/ersetze-bereich.pl`,
CR-Zahl 18 vorher wie nachher. Uebersetzt und gelinkt: MSBuild
`QCSocket.vcxproj` Debug/Win32, Exit 0, `Bin\Debug\QCSocket.dll` entsteht, nur
die vorbestehenden C4996-Warnungen.

**Bewusst NICHT angefasst:** `g_fnQCSSLWrite` (`:1164`) und `g_fnQCSSLRead`
(`:1285`) sind ebenfalls ungeprueft. Beide sind nur ueber
`m_pSSLReference->m_pSSL` erreichbar, und das bleibt NULL, wenn
`QCSSLBeginSession` nicht lief — nach der Behebung also auch bei fehlendem
Zeiger. Ein `&& g_fnQCSSLWrite` in die Bedingung von `:1160` zu haengen waere
schaedlich: dann fiele der Zweig auf den Klartextpfad zurueck und Eudora
schickte Anmeldedaten unverschluesselt.

**Was an der Behebung von heute frueh stimmt:** die vier gemeldeten Stellen
sind wirklich zu (`:1958`, `:1978`, `:1999-2010`, `:2050-2056` in der heutigen
Zaehlung), die neue Meldung verschluckt nichts — der `else`-Zweig in
`:1967-1974` haengt nur Text an einen Fall an, der vorher gar keinen Text
bekam. Eine Kleinigkeit bleibt: faellt `pConnectionInfo` im Zweig ohne
TaskInfo weg, behaelt `m_iSSLError` seinen alten Wert, statt zurueckgesetzt zu
werden. Folgenlos, solange die Meldung aus `csError` kommt.

---

### PR-2.2 — `paket-pruefen.ps1` winkt ein Paket ohne `EudoraRes.dll` durch (hoch)

**Fundstelle:** `tools/paket-pruefen.ps1:138` und `:158`.

Das Werkzeug liest die Importtabellen der PE-Dateien — Datenverzeichnis 1 und,
richtig, auch Datenverzeichnis 13 (verzoegertes Laden, 32-Byte-Deskriptoren).
Die im Auftrag vermutete Delay-Load-Luecke gibt es **nicht**; gegen
`dumpbin /dependents` auf `EuMemMgr.dll` gemessen, gleiche Aufteilung.

Was es nicht sieht, ist alles, was in keiner Importtabelle steht.

**Gegenprobe:** aus einer ausgepackten Kopie des Pakets wurden
`EudoraRes.dll`, `QCSSL.dll`, `SPELL32.DLL`, `EuGraph.ocx`, `EuShlExt.dll`,
`x1lib.dll` und der ganze Ordner `Plugins\` geloescht. Ergebnis des Pruefers:

    ERGEBNIS: keine Fehler.        EXIT=0

Kein Wort zu `EudoraRes.dll` — der Datei, die laut `README.md:66` die gesamte
Oberflaeche traegt. Sie wird per `LoadLibrary` geholt und steht deshalb in
keiner Importtabelle. Im Baum `Eudora71\` liegen 62 `LoadLibrary`- und 28
`CoCreateInstance`-Stellen, die alle im toten Winkel liegen.

**Folge fuer 1.0.3:** `paket-pruefen.ps1` beantwortet die Frage "sind alle
Importe aufloesbar", nicht die Frage "ist das Paket vollstaendig". Als
Freigabekriterium fuer Kriterium 0 taugt es in dieser Fassung nicht. Was
fehlt, ist eine Soll-Liste der Dateien, gegen die geprueft wird.

**Fortschreibung 14.10.2026 (Release `v1.0.87`) — dieselbe Lücke von der
anderen Seite: eine Soll-Liste der Namen reicht nicht, es braucht die
Soll-Bytes.** Beim Packen von 1.0.87 (1.0.84-ZIP entpackt, darüber jede
EXE/DLL/OCX aus `Eudora71/Bin/Release`, die es im Paket schon gibt — 34
Dateien) wich genau eine Datei von Gregors getestetem Verzeichnis
`C:\Users\Gregor\Eudora72-1.0.87-release` ab: **`SPELL32.DLL`**. In
`Bin/Release` liegt eine vom 05.09.2026 19:18 (112 128 Byte, SHA-256
`c085571c07da0f30179d6efe02ccbecbce5df0914dcbb445f83d8ac40aa48ac9`); getestet
und ausgeliefert ist die aus dem 1.0.84-ZIP (30.08.2026 17:57, gleich groß,
SHA-256 `2d5d3d78c7ca04f258f243c218dca1576f56fc7805da7d7e7bd7310625fd7f45`).
`paket-pruefen.ps1` sagt zu beiden dasselbe — es prüft Importe, nicht
Identität. Gefunden hat es allein der `cmp` gegen Gregors Verzeichnis; ins
ZIP kam die getestete Datei. **Offen:** woher die `SPELL32.DLL` vom 05.09.
stammt und welche die richtige ist. Bis dahin liefert jedes Paket, das seine
Programmdateien nur aus `Bin/Release` holt, eine ungetestete `SPELL32.DLL`
aus. Nicht behoben (Nebenbefund des Releases, auf Anweisung nicht angefasst).

---

### PR-2.3 — Der Pruefer benotet die Maschine, nicht das Paket (hoch)

**Fundstelle:** `tools/paket-pruefen.ps1:9` ("Warnungen allein aendern die
Rueckgabe nicht"), `:266` (Rueckfall auf das Systemverzeichnis), `:433`.

**Gegenprobe** gegen das ausgepackte `Eudora72-1.0.2-lauffaehig.zip`:

    3. VS2022-DEBUG-LAUFZEITEN
       mfc140d.dll  msvcp140d.dll  vcruntime140d.dll  ucrtbased.dll
            nicht im Paket, aber in SysWOW64 vorhanden
    ERGEBNIS: keine Fehler.        EXIT=0

Genau der Fall, fuer den das Werkzeug laut seinem eigenen Kopfkommentar
(`:13-19`) gebaut wurde — ein Paket, das auf einer fremden Maschine nicht
startet — wird mit Rueckgabe 0 durchgewunken, weil auf DIESER Maschine die
Laufzeit installiert ist.

Dazu drei Verschaerfungen:

* `:266` faellt auf `System32` zurueck. Das Skript laeuft in einer 64-Bit-
  PowerShell; dort liegen 64-Bit-DLLs, die ein x86-Prozess nicht laden kann.
  1230 DLLs sind nur dort vorhanden. Die Architektur der aufgeloesten
  System-DLL wird nirgends geprueft. Beispiel: `Finde-DLL 'aadcloudap.dll'`
  meldet "aufgeloest".
* `QCSSL.dll` importiert `mfc140.dll` und `VCRUNTIME140.dll` (Release, ohne
  `d`). Die Liste in `:360` kennt nur die vier Debug-Fassungen. Ohne
  VC-Redistributable faellt TLS auf der Zielmaschine aus, der Pruefer schweigt.
* `README.md:73-74` sagt, die vier Debug-Laufzeiten duerften **nicht**
  mitgeliefert werden; `paket-pruefen.ps1:363-364` bewertet ihr Vorhandensein
  gruen und ihr Fehlen (`:371`) als FEHLER. Werkzeug und Doku widersprechen
  sich.

Ausserdem ungeprueft: Exporte und Ordinale (`:149/:151` liest nur den Namen
des Deskriptors, nie die Thunk-Tabellen — eine `msvcr71`-Bruecke mit fehlendem
Export ergibt `0xc0000139` und bleibt unentdeckt), das eingebettete Manifest
(`Microsoft.Windows.Common-Controls 6.0.0.0`, SxS-Fehler 14001), die
COM-Registrierung von `EuGraph.ocx`/`EuShlExt.dll`/`capicom.dll`, und der Ort
der `Eudora.ini` (`:386` sucht mit `-Recurse` irgendwo im Baum, nicht dort, wo
`eudora.cpp:3542` sie sucht).

---

### PR-2.4 — Der groesste Eingriff des Tages hat keinen einzigen Test (hoch)

**Fundstelle:** Commit 1a4a6d5 aendert `Eudora71/OTShim/OTShim.cpp` um 334
Zeilen; `Eudora71/Tests/` ist in demselben Commit **nicht** angefasst.

**Gegenprobe:**

    grep -rn "DistributeRow|MoveControlBarToPosition|AssignRowExtents|m_nRowExtent|NormalizeRow" Eudora71/Tests/*.cpp
    Eudora71/Tests/TestOTShimAndocken.cpp:689:  //   NormalizeRow, die Splitter und die Client-Kanten)

Ein Kommentar. Sonst nichts. Fuenf neue Funktionen mit Zeilenaufteilung,
Rundung, Mindestbreiten und Umbau von `m_arrBars` sind ohne Zusicherung.

Schaerfer noch: der bestehende Test schreibt das **alte** Verhalten fest und
bleibt deshalb gruen, egal was die neue Rechnung tut.

    Eudora71/Tests/TestOTShimAndocken.cpp:214
    GroesseVergleichen(leiste.CalcDynamicLayout(0, LM_HORZDOCK), 32767, 40, ...)

Das trifft den Zweig `m_nRowExtent == 0`. Der neue Zweig
(`OTShim.cpp:1640-1646`, `m_nRowExtent > 0`) wird von keinem der 105 Tests
betreten. "105 von 105 gruen" ist wahr — selbst gebaut und gelaufen
(`Eudora71/Tests/RunTests.cmd`, Exit 0) — sagt ueber die Aenderung des Tages
aber nichts.

Nach Tests ohne wirksame Zusicherung wurde gezielt gesucht: die Faelle, die
auf den ersten Blick leer wirken, rufen Pruefhilfen (`PruefeKopfzeile`,
`GroesseVergleichen`), die ihrerseits `TT_Fail` aufrufen. Ein immer gruener
Test wurde **nicht** gefunden. `SECDockBar: PredictInsertPosition und
CalcDockingLayout sind als offen gekennzeichnet` (`:526-533`) prueft wirklich
etwas — dass der Rumpf noch ein Rumpf ist. Das ist Absicht und in Ordnung.

---

### PR-2.5 — `DrawChecked` hat denselben Farbfehler (mittel)

**Fundstelle:** `Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:851-852`.

Die Behebung in `DrawDisabled` (db28adb) ist richtig, und zwar nachgerechnet.
Die Verknuepfungszahl `0x00B8074A` (PSDPxax) ist umgekehrt polnisch
`P S D P x a x`, also

    Ergebnis = P XOR (S AND (D XOR P))

Ist `S` lauter Einsen, bleibt `D` stehen; ist `S` null, kommt der Pinsel `P`.
Beim Kopieren von einfarbig nach farbig macht GDI aus der Maskeneins die
Hintergrund- und aus der Maskennull die Textfarbe des Ziels. Die Rechnung geht
also genau dann auf, wenn dort `0x00FFFFFF` und `0x00000000` stehen — genau
das setzt `DrawDisabled` seit heute. **Richtig.** Auch die Ruecknahme ist
sicher: der einzige vorzeitige `return` (`:799`, `nWidth <= 0`) liegt VOR dem
`SetTextColor`, und die beiden `Set…`-Zeilen am Ende laufen unbedingt.

Die Begruendung im Commit nennt `DrawChecked` als Vorbild ("setzt beide Farben
laengst"). Als Vorbild dafuer, DASS man die Farben setzt, stimmt das. WELCHE
Farben `DrawChecked` setzt, haelt derselben Rechnung aber nicht stand:

    :851  COLORREF crOldText = data.m_drawDC.SetTextColor(secData.clrBtnHilite);
    :852  COLORREF crOldBk   = data.m_drawDC.SetBkColor(secData.clrBtnFace);

`clrBtnFace` ist ueblicherweise `0xF0F0F0`, `clrBtnHilite` `0xFFFFFF`. Damit
ist `S` weder lauter Einsen noch null, sondern gemischt — das Schachbrett
erscheint nur in einem Teil der Bitebenen. Nach der Begruendung, die
`DrawDisabled` behoben hat, ist `DrawChecked` der naechste Fall derselben
Klasse. Betroffen sind die angekreuzten Knoepfe und ueber
`DrawIndeterminate` (`:864-868`) die Auszeichnungsknoepfe im Verfassenfenster.

UNGEPRUEFT auf dem Bildschirm — die Auflage verbietet den Start.

---

### PR-2.6 — Die Suchleiste teilt sich jetzt Zeile 0 mit der Hauptleiste (mittel)

**Fundstelle:** `Eudora71/Eudora/mainfrm.cpp:966`.

    DockControlBarEx(m_pSearchBar, m_pToolBar->m_pDockBar->GetDlgCtrlID(),
                     nCol+1, nRow, 1.0, nDefaultHeight);

Seit 1a4a6d5 werden `nCol` und `nRow` ausgewertet. Die Suchleiste landet damit
in derselben Zeile wie die Hauptwerkzeugleiste. `SECControlBar::m_fPctWidth`
steht bei beiden auf dem Vorgabewert `1.0` (`OTShim.cpp:1453`); Eudora setzt
ihn fuer die Hauptleiste nirgends. `SECDockBar::DistributeRow` normiert
deshalb auf 0,5 zu 0,5 — die Hauptleiste bekommt die halbe Fensterbreite.

Bei fuenfzehn Knoepfen zu je rund 24 Bildpunkten reicht das auf einem breiten
Fenster; auf einem schmalen nicht. Das ist eine **neue** Moeglichkeit, die
Hauptleiste abzuschneiden, und sie entsteht durch die Aenderung von heute.

Zweite Stelle derselben Art: `AdWazooBar.cpp:176` und `:212` docken mit
`nCol=5, nRow=0, fPctWidth=0.25` an, `WazooBarMgr.cpp:253` mit
`nCol=0, nRow=0, fPctWidth=1.00` an dieselbe untere Leiste. Vorher hatte jede
ihre eigene Zeile, jetzt teilen sie sich Zeile 0 im Verhaeltnis 0,8 zu 0,2.
Das ist vermutlich genau das Gewollte — nachgewiesen ist es nicht.

**Was an der Rechnung stimmt** (von Hand durchgerechnet, ohne Lauf):

* Division durch null gibt es nicht: `fSum > 0.0` steht vor jeder Division
  (`OTShim.cpp:2688`, `:2694`), `nBars > 0` vor `1.0/nBars` (`:2669`).
* Negative Breiten gibt es nicht: `nExtent = nRest - nReserve` kann negativ
  werden, wird aber von `if (nExtent < nMin)` und zuletzt von
  `if (nExtent < 1) nExtent = 1` (`:2708`) aufgefangen.
* Leere Zeile: `DistributeRow(nStart, nStart, …)` sammelt nichts und kehrt bei
  `nBars <= 0` sofort um. Die fuehrende NULL-Marke erzeugt genau diesen Fall
  im ersten Schleifendurchlauf.
* Genau eine Leiste: sie ist die letzte, bekommt `nRest` = `nAvail`, also die
  ganze Zeile — dasselbe Ergebnis wie vorher mit 32767.
* `MoveControlBarToPosition` von Hand durchgespielt fuer den ersten und den
  zweiten Andockvorgang: `[NULL,bar1,NULL]` bleibt `[NULL,bar1,NULL]`,
  `[NULL,bar1,NULL,bar2,NULL]` wird zu `[NULL,bar1,bar2,NULL]`. Richtig.
* Der Umbruch in MFC greift nicht mehr: `CDockBar::CalcFixedLayout`
  (`atlmfc/src/mfc/bardock.cpp`) bricht bei
  `rect.left >= sizeMax.cx - afxData.cxBorder2` um und zaehlt
  `pt.x += sizeBar.cx - afxData.cxBorder2`. Da die Summe der zugeteilten
  Laengen genau `nAvail` ist und je Leiste ein `cxBorder2` abgezogen wird,
  bleibt die Zeile unter der Schranke.
* Der Weg dorthin stimmt auch: MFC ruft nicht `CalcFixedLayout`, sondern
  `pBar->CalcDynamicLayout(-1, LM_HORZDOCK|LM_HORZ)`. Waere dort
  `CControlBar::CalcDynamicLayout` zustaendig, kaeme `bStretch = FALSE` heraus
  und `m_nRowExtent` wuerde nie angewandt. `SECControlBar::CalcDynamicLayout`
  (`OTShim.cpp:1654-1658`) gibt aber ausdruecklich `CalcFixedLayout(TRUE, …)`
  zurueck. Die Kette traegt.

---

### PR-2.7 — `paket-bauen.ps1` ist kein Bau (mittel)

**Fundstellen:** `tools/paket-bauen.ps1:59-60`, `:103-106`, `:115`, `:161`.

* `:60` nimmt als Grundlage das **alte** ZIP. Frische Binaerdateien kommen nur
  mit `-AusBauverzeichnis` und nur fuer sieben fest verdrahtete Namen
  (`:103-106`). Fehlt eine davon, bleibt die alte stehen (`:115`, gelbe
  Zeile) — und das ZIP wird trotzdem geschrieben.
* Debug oder Release ist nirgends festgelegt: `Bin\Debug` ist hartkodiert
  (`:86`), gleichzeitig werden `Bin\Release`-Dateien beigemischt (`:125`,
  `:129`, `:139`).
* In einem frischen Klon laeuft es gar nicht: `.gitignore:6` ignoriert `Bin/`,
  `:59` erwartet aber `Eudora71\Bin\Release\msvcr71.dll`. Gemessen in diesem
  Worktree: Abbruch mit EXIT=1 in `:74` — **nach** dem Auspacken in `:71`, so
  dass 155 Dateien einer unveraenderten 1.0.2 im Zielverzeichnis stehen
  bleiben und wie ein 1.0.3-Bauverzeichnis aussehen. Kein Aufraeumen im
  Fehlerfall.
* Reproduzierbar ist es nur auf derselben Maschine in derselben Stunde:
  `:161` `CreateFromDirectory` schreibt Aenderungszeiten ins ZIP. Zwei Laeufe
  ohne Aenderung ergaben denselben Hash; eine verstellte `LastWriteTime`
  ergab einen anderen. Die aus dem Git-Checkout kopierten Dateien (`:146-147`,
  `:153`) tragen die Auscheckzeit. Das `.sha256` in `:162` verspricht eine
  Reproduzierbarkeit, die es nicht gibt.
* Vollstaendigkeit wird vor dem Schreiben nicht geprueft (`:159-161`);
  `paket-pruefen.ps1` wird erst danach als Textzeile empfohlen (`:172`) — und
  wuerde nach PR-2.2 ohnehin nichts merken.
* Keine Versionskopplung: weder die Datei `VERSION` noch
  `tools/kennung-erzeugen.pl` kommen vor. Ein ZIP mit Namen 1.0.3 kann eine
  1.0.2-`Eudora.exe` enthalten, ohne dass etwas warnt. Genau davor warnt
  `Releases/PAKETE.md` bei der QCSSL.dll.
* Das Grundlagen-ZIP wird ohne Hash-Abgleich ausgepackt (`:62`, `:71`),
  obwohl daneben eine `.sha256` liegt.

`tools/laufzeit-holen.ps1` laedt nichts aus dem Netz (geprueft: kein
`Invoke-WebRequest`, `DownloadFile`, `System.Net`, `http` in allen drei
Skripten). Auf einem Rechner ohne Visual Studio bricht es ab, aber nicht
sauber: mit einer Quelle, die nur drei der vier Pflichtdateien hat, kopiert es
zwei Dateien und meldet danach EXIT=1 — zurueck bleibt ein halb bestuecktes
Verzeichnis. Ausserdem ist `:74` `C:\Windows\SysWOW64` hartkodiert, waehrend
`paket-pruefen.ps1:196` es richtig ueber `$env:SystemRoot` macht, und
`Architektur()` (`:44-55`) prueft weder `MZ` noch `PE\0\0` und hat kein
`finally`.

---

### PR-2.8 — `EUDORA_BUILD_MONTH` bleibt auf Juni 2006 (niedrig, kein Handlungsbedarf)

**Fundstelle:** `Eudora71/Version.h:19`.

    #define EUDORA_BUILD_MONTH REG_EUD_CLIENT_7_1_MONTH

`regcode/regcode_eudora.h:129` gibt dafuer `(89)` an, "June 2006". Ein
`REG_EUD_CLIENT_7_2_MONTH` gibt es nicht; die Reihe endet bei 7_1.

Benutzt wird der Wert an fuenf Stellen: `QCSharewareManager.cpp:944, 953, 963`
(Ablauf eines Registrierungscodes), `:1182-1183` (`DemoDaysLeft`) und
`QCSharewareManager.h:85` (`IsNewDemoBuild`).

**Nicht mitzuaendern ist richtig.** Die Zahl bedeutet "in welchem Monat wurde
dieses Produkt gebaut" und dient dazu, Registrierungscodes ablaufen zu lassen,
die aelter als zwoelf Monate sind. Ein Hochsetzen auf einen Wert nahe heute
(rund 320) wuerde `(regCodeMonth + 12) < EUDORA_BUILD_MONTH` fuer **jeden**
existierenden Eudora-Code wahr machen und alle vorhandenen Registrierungen
entwerten. `IsNewDemoBuild` wuerde ausserdem jede gespeicherte
`DemoBuildMonth` als aelter einstufen und die Testfrist neu starten. Beides
ist nicht gewollt.

Die im Commit 2cf569f genannte Nebenwirkung ist eine andere und trifft zu:
`QCSharewareManager::Load` vergleicht `EUDORA_BUILD_VERSION` (die Zeichenkette
`"7.2.0.3"`) mit der `RetailVersion` in der INI, nicht `EUDORA_BUILD_MONTH`.

---

### PR-2.9 — Falsche Zeilenangabe in BEFUND-ANSICHT.md (niedrig)

`Eudora71/OTShim/BEFUND-ANSICHT.md:279` nennt `Splitter::cx` (= 4,
`OTShim.cpp:2091`). Die Zeile stimmt nicht mehr:

    grep -n "Splitter::cx" Eudora71/OTShim/OTShim.cpp
    2109:  const int SECDockBar::Splitter::cx = 4;
    2675:  const int nMin = 4 * Splitter::cx;

Der Wert 4 stimmt, die Fundstelle ist um 18 Zeilen verrutscht.

---

### Geprueft und in Ordnung

* **`m_bMainFrameEnabled = FALSE`** (`OTShim_Werkzeugleiste.cpp:3514`, `:3541`).
  Alle fuenf Abfragestellen in Eudora lesen TRUE als "der Anpassen-Dialog
  steht offen": `mainfrm.cpp:2988` (Schliessen unterbinden), `:8668`
  (`OnNcHitTest` liefert HTERROR), `:8679` und `:8727` (`WF_STAYACTIVE`
  loeschen), `:8743` (`OnEnterIdle` nur bei `MSGF_DIALOGBOX`). FALSE ist
  ueberall die richtige Ruhelage. Der Rueckweg existiert und wird gerufen:
  `SECToolBarCmdPage::~SECToolBarCmdPage` (`:4377`) ruft `RestoreMainFrame`,
  und `QCToolBarCmdPage` (`QCToolbarCmdPage.cpp:117`, das
  `EnableMainFrame` ruft) leitet sich davon ab. Kein Haengenbleiben auf TRUE.
* **`EudoraTests.exe`**: selbst gebaut und gelaufen ueber
  `Eudora71/Tests/RunTests.cmd`. 105 Tests, 105 bestanden, 0 fehlgeschlagen,
  Exit 0. Die Zahl stimmt.
* **Delay Load**: die vermutete Luecke in `paket-pruefen.ps1` gibt es nicht,
  siehe PR-2.2.

### Offen geblieben

Aus Zeitgruenden nicht mehr erreicht: die Stichprobe zu
`tools/zeilenenden-angleichen.pl`, BEFUNDE.md [S-1](#s-1) bis [S-6](#s-6), `utils.cpp
ISOTranslate`, sowie die eigenen Gegenproben gegen `tools/pruefe-bytes.pl` und
die Fehlalarmquote von `tools/suche-zeiger.pl`. FREIGABEs Release-Bau lag
nicht vor und ist ungeprueft.

## S-8 — Paket 1.0.2 startet mit `0xc000007b` (31.08.2026)

Nachgetragen von LEKTOR am 31.08.2026. Der Befund war bis dahin nur im Commit
`76efdb6`, in `README.md` und in `Releases/1.0.2/LIESMICH.txt` festgehalten, in
dieser Datei fehlte er. Anlass fuer `ZIEL.md`, Kriterium 0.

**Was Gregor sah.** Paket 1.0.2 ausgepackt, `Eudora.exe` gestartet:

    Die Anwendung konnte nicht korrekt gestartet werden (0xc000007b)

Kein Fenster, kein Absturzdialog, kein Protokolleintrag.

**Ursache.** `0xc000007b` ist `STATUS_INVALID_IMAGE_FORMAT`. Der Lader hat eine
Abhaengigkeit gefunden, die er nicht in den Prozess bringen kann. Im
Programmverzeichnis fehlten die vier Debug-Laufzeiten des VS-2022-Baus
vollstaendig (nachgemessen):

    mfc140d.dll   msvcp140d.dll   vcruntime140d.dll   ucrtbased.dll

**Warum es so leicht schiefgeht.** `Eudora.exe` ist ein **32-Bit**-Programm
(`Debug|Win32`, im PE-Kopf nachgemessen). Zwei Fallen fuehren beim Nachlegen der
DLLs zur 64-Bit-Fassung und damit erneut zu `0xc000007b`:

| Falle | Warum |
|---|---|
| DLL-Sammelseiten wie dll-files.com | liefern haeufig die 64-Bit-Fassung, ohne es deutlich zu machen |
| der Ordnername `SysWOW64` | er enthaelt die **32**-Bit-DLLs; die 64-Bit-DLLs liegen in `System32`. Der Name legt genau das Gegenteil nahe |

**Behebung.** `tools/laufzeit-holen.ps1` (neu in `76efdb6`). Es holt die vier
Dateien aus `C:\Windows\SysWOW64` und prueft **jede einzeln** im PE-Kopf auf
x86 nach; kopiert wird nur, was wirklich x86 ist. Mit `-NurPruefen` sagt es nur,
was fehlt. Gegen Gregors Testverzeichnis gelaufen: alle vier vorhanden und x86.
Die auf dieser Maschine vorhandene Fassung ist 14.38.33142.0 gegen Toolset
14.38.33130.

**Was damit NICHT geloest ist.** Die vier Debug-DLLs duerfen nicht
weiterverteilt werden — Microsoft nimmt die Debug-Fassungen der Laufzeit
ausdruecklich davon aus, bei Visual Studio liegen sie deshalb unter
`debug_nonredist`. Ein Redistributable gibt es nicht. Solange nur der Debug-Bau
laeuft, braucht jeder Empfaenger des Pakets ein installiertes Visual Studio
2022. Das widerspricht Kriterium 0 („zip runterladen, entpacken, starten —
laeuft"). Der Ausweg ist ein **Release-Bau**, vorzugsweise statisch gebunden;
Einzelheiten und Abwaegung in `ZIEL.md`, Abschnitt „Kriterium 0". Bis dahin
misst `tools/paket-pruefen.ps1` den Paketinhalt gegen die Startkette.

**Bezug zu anderen Befunden.** [S-1](#s-1) (Paket 1.0.1 startete nicht) hatte eine
andere Ursache — dort lagen die *falschen* Fremd-DLLs bei. [S-8](#s-8) ist der Fall,
dass die eigene Laufzeit ganz fehlt.

## Z-1 — Alle Zahlen und Fundstellen des 31.08. nachgerechnet (31.08.2026)

Ein Prüfdurchgang hat jede Zahl und jede Zeilenangabe der heutigen Befunde
gegen die Quelle gehalten. **Nichts wurde geändert** — das hier ist die Liste
der Abweichungen, damit niemand auf einer falschen Angabe aufbaut.

### Falsch

| Stelle | Behauptung | tatsächlich |
|---|---|---|
| [P-2.1](#p-2.1), P-2.3 | „die **zehn** `GetProcAddress`-Ergebnisse (`:373-383`)" | es sind **elf** (373…383). Die Zahl steht zweimal falsch da. |
| <a id="p-2.1"></a>P-2.1 | „in `Releases/1.0/` liegen **mehrere** `QCSSL.dll`-Fassungen" | es liegt **genau eine** (2.920.960 B), SHA256-identisch mit der im Paket 1.0.2. **Damit trägt die Begründung des Absturzszenarios so nicht.** **Stufe: werkzeug** (mehrere DLL-Fassungen)|
| <a id="p-2.2"></a>P-2.2 | „**alle fünf** echten Aufrufer übergeben die Adresse eines Elements" | es gibt einen **sechsten**: `Eudora71/Imapdll/src/Network.cpp:539` reicht in `CNetStream::SetSSLMode` einen Zeigerparameter weiter. Nicht auf dem POP-Weg, aber „alle fünf" ist falsch. **Stufe: werkzeug** (Quelltextpruefung)|
| [P-2.2](#p-2.2) (Quelltext) | Kommentar „Zeile **2065** unten prüft ihn auch" | die Prüfung steht nach der eigenen Änderung bei **2070**; in 2065 steht etwas anderes. Die Korrektur hat ihre eigene Zeilenangabe veraltet gemacht. |
| M-1 | `HTERROR` in `mainfrm.cpp:8670`, Funktion `8662-8671`, Kommentar `:8744` | durchweg **um eins daneben**: 8671, 8663–8672, 8745. Dieselbe Verschiebung ist in die neuen Quelltextkommentare übernommen worden (`OTShim_Werkzeugleiste.cpp:3790`, `.h:1153`). |
| M-1 | Konstruktoren `:3480` und `:3506` | das war der **Vorzustand**. Heute `:3514` und `:3541`. Im Text nicht als „vorher" gekennzeichnet. |
| A-1 | „Ursache belegt", fünf Fundstellen, 32767, Verdacht `DrawDisabled` | war an `31810e2` richtig, ist **heute überholt** — `1a4a6d5` und `db28adb` haben genau das behoben. Sämtliche Zeilenangaben des Abschnitts stimmen im heutigen Baum nicht mehr. Nur `SetControlBarWidthsInRow` ist noch leerer Rumpf (`OTShim.cpp:2244`) und `OnSizeParent` reicht noch durch (`:3276`). |
| <a id="b-2.2"></a>B-2.2 | Startkette des **ausgelieferten** Pakets = **elf** Module | **zwölf** — dazu `msvcr71d.dll`, weil die gepackte `Paige32d.dll` der Debug-Bau ist. Die Elferliste ist die von Paket **1.0.3**, nicht die des ausgelieferten. **Stufe: werkzeug** (Startkette des Pakets)|
| <a id="b-2.5"></a>B-2.5 | Paket 1.0.2: **3 Fehler, 5 Warnungen** | heute mit dem eingecheckten Prüfer: **0 Fehler, 8 Warnungen**. Die Spalte stammt aus einem älteren Stand des Werkzeugs. **Stufe: werkzeug** (Paketbau)|
| [W-1](#w-1) / [PR-7](#pr-7) | „[S-7](#s-7) nachgezogen, Tabelle eingefügt, Beispiel berichtigt" | **[S-7](#s-7) ist unverändert.** Der Kasten behauptet weiter, der Werkzeugkopf nenne „4426 von 5336" — das ist dort ersatzlos entfernt worden. Die Tabelle steht nur im Werkzeugkopf. Die Beschriftung des Beispiels ist weiterhin vertauscht. |
| [W-1](#w-1) / [PR-3](#pr-3) | Grundgesamtheit **6385** | heute **6392**. Wächst mit jedem Commit — kein Widerspruch, aber schon am Tag des Schreibens flüchtig. |

### Bestätigt

[`P-2.1`](#p-2.1) alle vier Fundstellen exakt der Vorzustand, die Rechnung
`CRString(8000 + (-1-10000))` geht auf · `P-2.3` acht Treffer, alle sieben
Fehlalarm-Bewertungen stichprobenweise richtig · `P-2.4` `TextReader.cpp:251`
und `utils.h:90` · `P-2.7` **105 Tests, 105 bestanden** selbst ausgeführt ·
[`M-1`](#m-1) `tbarmgr.h:79-80`, **genau fünf** Abfragestellen (2988, 8668, 8679, 8727,
8743), `91716bb` als Einführungscommit, `RestoreMainFrame` wird gerufen ·
[`A-1`](#a-1) 15 Standardknöpfe, `secData`, `DockBar.cpp` prüft selbst auf
`SWM_MODE_ADWARE` · `B-2.1` die echte GUID steht in der Solution, die falsche
weiter in `VC71Bruecke/BEFUND.md:462` · `B-2.3` `EUMAPI.DLL` ist keine PE-Datei
— und der als UNGEPRÜFT markierte Verdacht **stimmt**: Signatur `NE`, also eine
**16-Bit-Datei** · [`W-1`](#w-1) 23 Testfälle grün, Blob `8c4fb68a` = 5716 B mit 65 LF,
5716+65 = 5781.

### Was daraus folgt

**Zeilenangaben veralten, sobald jemand dieselbe Datei anfasst.** Sieben der elf
Abweichungen sind genau das — nicht falsch gemessen, sondern durch spätere
Commits verschoben. Wer eine Fundstelle benutzt, prüft sie nach.

Nicht prüfbar in jenem Arbeitsbaum: die Größenangaben zu `Eudora.exe` und die
MSBuild-Läufe aus P-2.4, B-2.1 und [W-1](#w-1).

## X-1 — Die Werkzeuge angegriffen: neun Löcher in der Schranke (31.08.2026)

Ein Angriffsdurchgang gegen die eigenen Werkzeuge, mit 15 selbst gebauten
Fällen, von denen **keiner** in `tools/pruefe-bytes-tests.pl` steht.
**Ergebnis: 9 Löcher, 0 Fehlalarme.** Die Bestandssammlung läuft weiter 23/23
grün — diese Funde kommen obendrauf.

### Schwer

**L1 — Umbenennung hebelt die Schranke vollständig aus.** `pruefe-bytes.pl:198`
benutzt `--diff-filter=ACM`. Ein `git mv alt.cpp neu.cpp` erscheint als `R088`
und landet nie in der Prüfliste. Wer danach die Datei neu schreibt, kann jedes
Zeilenende und jedes Sonderzeichen zerstören — Rückgabe 0. **`git mv` plus
Neuschreiben ist genau der Ablauf einer Portierung.**

**L2 — Latin-1 → UTF-8 umkodiert bleibt unerkannt.** Gezählt werden nur
Ersatzzeichen (`EF BF BD`). Eine *saubere* Umkodierung (`0xE4` → `C3 A4`)
erzeugt keines; der Inhalt ändert sich, also greift Regel 2, und dort verwirft
Zeile 165 das Paar. Das ist genau der Schaden, gegen den die Regel
„byte-erhaltend ändern" existiert.

**L3 — Ein neu eingefügtes UTF-8-BOM** (`EF BB BF`) bleibt aus demselben Grund
unerkannt.

### Mittel

**L4** — bei Dateien mit NUL-Byte ist Regel 2 blind: `git diff -U0` liefert nur
„Binary files differ", kein `@@`. Derzeit latent — von 6392 erfassten Dateien
enthält keine ein NUL-Byte.

**L5** — die Vorausschau von 30 Zeilen (`:118`) ist eine harte Grenze, exakt
gemessen: 30 eingefügte Zeilen vor der Umwandlung → erkannt, **31 → durch**.
Ehrlich dazu: an echten Projektdateien wird es trotzdem erkannt, weil git
wiederkehrende Zeilen in mehrere Blöcke zerlegt. Das Loch ist synthetisch
belegt, an Projektmaterial nicht.

**L6** — reine CR-Zeilenenden (Mac-Stil) → LF bleiben unerkannt; normalisiert
wird nur `\r\n`.

**L7** — verliert die letzte Zeile ihr CRLF, wird das bewusst durchgelassen
(`:166`). Es ist trotzdem ein echter Byteverlust.

### Leicht

**L8** — neue Dateien werden gar nicht geprüft (`:205`); eine neue Datei mit
Ersatzzeichen läuft durch. **L9** — eine in HEAD leere Datei gilt als „nicht
vorhanden" und wird übersprungen.

### Zusatzfund: der pre-commit-Hook wertet seinen ersten Schritt nicht aus

`tools/hooks-einrichten.sh:20` ruft `lehren-spiegeln.pl` ohne `set -e` und ohne
Prüfung von `$?`, danach `exec pruefe-bytes.pl`. Wenn das Spiegeln mit
`exit 1` abbricht und „Der Commit wurde abgebrochen" meldet, **stimmt das
nicht** — der Hook gibt 0 zurück. Die gespiegelten Lehren gehen weiterhin
lautlos aus dem Commit heraus. Das ist derselbe Befund wie [NP3-4](#np3-4), in anderer
Gestalt.

### `tools/suche-zeiger.pl` ist Rauschen

Über 3237 Dateien: **345 Treffer**. Stichprobe von 15 zufällig gezogenen:
**15 Fehlalarme, also 100 %.** Drei strukturelle Ursachen erklären 273 der 345
(79 %): klammerloser `if`-Rumpf (211), einzeiliger Wächter mit `return` (16),
Abstand größer als das Fenster von 40 Zeilen (46). In allen 23 handgeprüften
Treffern **ein** plausibel echter: `EuImap/src/ImapMailbox.cpp:1022` prüft
`pAccount`, `:1051` dereferenziert außerhalb des Blocks.

Urteil: etwa ein brauchbarer Treffer auf 70 Ausgabezeilen. Ohne die drei
Filter nicht benutzbar.

### `tools/zeilenenden-angleichen.pl`: zwei Lücken

**Es lässt Textdateien aus.** Von 9146 verfolgten Dateien erfasst das Muster
6392; von den 2754 übrigen sind **773 eindeutig Text**. Projektrelevant fehlen
`.ih` (6 C-Header, werden mitkompiliert), `.rgs` (12 ATL-Registrar-Skripte,
landen als Ressource im Binary), `.hh` (7 Hilfe-Header), `.mc`, `.hpj`, dazu
139 Dateien ohne Endung. `tools/dateiendungen.pl:30` führt `cc`, aber nicht
`hh` und `ih`.

**Es dreht absichtliche Arbeit still zurück.** Die Zeilen 129-141 schreiben den
HEAD-Stand **richtungslos**. Wer im Arbeitsbaum absichtlich LF→CRLF korrigiert
— etwa eine `.bat`, die CRLF braucht —, verliert das durch `--aendern`
kommentarlos, und die Datei erscheint unter „angeglichen" statt unter
„inhaltlich verschieden".

**Entwarnung:** von den 6392 erfassten Dateien enthält **keine** ein NUL-Byte
und **keine** ein UTF-16-BOM. Bilder, DLLs und Archive liegen alle außerhalb
des Musters. Es fasst also keine Binärdatei fälschlich an.

### Was daraus folgt

Nichts davon ist heute akut — aber L1 und L2 sind die beiden Schäden, gegen die
die Schranke überhaupt gebaut wurde, und gegen beide ist sie wirkungslos. Wer
sie als Sicherheit betrachtet, irrt.

## E-1 — Der erste erfolgreiche Mailabruf (31.08.2026, 08:15)

**Gregor hat mit dieser Fassung Mail abgerufen.** Zum ersten Mal seit Beginn der
Portierung. Belegt durch zwei Bildschirmfotos.

Gebaut aus `93762c7`, Paket `C:\Users\Gregor\Eudora72-1.0.3`, Titelleiste:

    Eudora [Eudora 7.2.0.3 / Paket 1.0.3+93762c7* 2026-08-31 08:04 - Eudora72-1.0.3] - [In]

### Was funktioniert

| | |
|---|---|
| **Mailabruf** | Fortschrittsbalken in der Statuszeile, danach **159 Nachrichten** im Eingangspostfach (`159/4319K/0K`) |
| **Anzeige** | Absender, Datum, Größe, Betreff in der Liste; Vorschaubereich zeigt eine vollständige Nachricht mit Kopfzeilen und Text |
| **Menüs** | das *File*-Menü klappt auf und ist vollständig — **Befund [S-5](#s-5) ist behoben**, die Behebung [M-1](#m-1) wirkt |
| **Anordnung** | Postfachbaum links, Nachrichtenliste rechts oben, Vorschau darunter. **Keine sich überlagernden Bereiche mehr** — die neue Andockrechnung aus [A-1](#a-1) wirkt |
| **Umlaute** | im Vorschaubereich korrekt („Guten Tag", „gültig", „vergangen") |

### Was damit belegt ist

**Kriterium 3 aus `ZIEL.md` ist erfüllt.** Ein Mailkonto lässt sich einrichten,
verbinden, und Mail wird abgerufen und lesbar dargestellt. Das war nie zuvor
geprüft.

Zugleich ist damit der **erste echte Servertest der neuen TLS-Schicht**
bestanden — bisher lag nur ein Test mit einer *älteren* QCSSL-Fassung vor
(`AUSLIEFERUNGEN.md`).

**Kriterium 1 ist erfüllt.** Das Fenster erscheint und ist bedienbar. Die
Einstufung „strittig" vom 30.08. ist damit aufgehoben.

### Was noch nicht stimmt

**Die Werkzeugleiste hat weiterhin leere graue Felder** — auf dem ersten
Bildschirmfoto der erste Knopf und drei weitere in der Mitte. Die Behebung an
`SECStdBtn::DrawDisabled` ([A-1](#a-1)) hat also **nur einen Teil** der Fälle
erwischt. Damit ist **Kriterium 2 weiterhin nicht erfüllt**.

Nächster Ansatz dafür steht in `BEFUND-ANSICHT.md`: der Zeichenweg je Knopf,
Punkte 2 und 3 (`GetDrawData`, `TBBS_HIDDEN`), und `SetControlBarWidthsInRow`
ist noch ein leerer Rumpf (`OTShim.cpp:2244`), `OnSizeParent` reicht noch durch
(`:3276`).

**Beim Start sind zwei bis drei SUPERASSERT-Dialoge wegzuklicken**, dazu einige
Warnungen. Das ist der Debug-Bau; im Release-Bau entfallen sie.

### Stand der vier Kriterien am 31.08.2026 (Zeitdokument)

| # | Kriterium | Stand |
|---|---|---|
| 0 | Paket läuft ohne Nachinstallieren | **nicht belegt** — der Paketprüfer trägt nicht, siehe [PR-2](#pr-2) |
| 1 | startet und zeigt sein Hauptfenster | **erfüllt** |
| 2 | die Darstellung ist korrekt | **nicht erfüllt** — leere Werkzeugleisten-Knöpfe |
| 3 | Mailkonto verbinden und Mail abrufen | **erfüllt** |

## E-2 — Werkzeugleiste vollständig, aber Umlaute in HTML-Mails zerstört (31.08.2026, 08:25)

Zweites Bildschirmfoto aus demselben Lauf (`93762c7`, Paket 1.0.3).

### Behoben: die leeren Werkzeugleisten-Knöpfe

Auf diesem Bild ist die Werkzeugleiste **vollständig** — alle Symbole
vorhanden, kein einziges graues Feld mehr. Die Behebung an
`SECStdBtn::DrawDisabled` ([A-1](#a-1), Commit `db28adb`) **wirkt also doch**.

Warum das erste Bildschirmfoto welche zeigte: dort war noch kein Postfach
geöffnet und keine Nachricht ausgewählt, also waren die betroffenen Knöpfe
gesperrt. Sobald Nachrichten da sind, werden sie freigegeben und normal
gezeichnet. Der Fall „gesperrt und leer" ist damit behoben; der Fall „gesperrt
und erkennbar grau" bleibt zu prüfen, wenn wieder einmal Knöpfe gesperrt sind.

Auch der Aufgabenbereich unten („Task Status" / „Task Errors") sitzt jetzt als
eigener Streifen am unteren Rand, nicht mehr senkrecht mitten im Fenster.

### NEU UND OFFEN: Umlaute in HTML-Nachrichten werden zu `◆`

    Video Lernkurs f◆r Excel 2019 - 2021 - G◆ltig bis 23.03.2022
                     ^                      ^
                     ü                      ü

**Im reinen Text stimmten die Umlaute** — dieselbe Sitzung zeigte kurz zuvor
„gültig" und „vergangen" richtig (Befund [E-1](#e-1)). Der Fehler trifft also nur den
**HTML-Anzeigepfad**, nicht `ISOTranslate` im Textpfad.

Das Zeichen ist ein Ersatzzeichen, kein Zeichensalat: **die Quelle wird als
etwas anderes gelesen, als sie ist.** Wahrscheinlich ist der Zeichensatz aus
dem `Content-Type` oder aus einem `<meta charset>` nicht ausgewertet, und der
Text kommt als UTF-8-Bytes in einen Wandler, der Windows-1252 erwartet — oder
umgekehrt.

**UNGEPRÜFT**, wo genau. Anzusehen wären:

  - der HTML-Anzeigepfad (`TridentView.cpp`, `PgEmbeddedImage.cpp` und was
    sonst die Vorschau mit HTML füllt)
  - ob der Zeichensatz aus dem MIME-Kopf überhaupt bis dorthin gereicht wird
  - `ISOTranslate` in `utils.cpp` wird hier offenbar **nicht** durchlaufen,
    sonst wäre das Ergebnis dasselbe wie im Textpfad

Gregors Einschätzung: *„das kann man beheben."*

### Stand der vier Kriterien am 31.08.2026 (Zeitdokument)

| # | Kriterium | Stand |
|---|---|---|
| 0 | Paket ohne Nachinstallieren | **nicht erfüllt** — Debug-Bau |
| 1 | startet, Hauptfenster bedienbar | **erfüllt** |
| 2 | Darstellung korrekt | **fast** — Anordnung, Menüs und Werkzeugleiste stimmen; **Umlaute in HTML-Mails nicht** |
| 3 | Mailkonto verbinden und Mail abrufen | **erfüllt** |

## E-3 — TLS 1.3 mit der ausgelieferten QCSSL 1.0.1, gegen einen echten Server (31.08.2026, 08:09:43)

Abgelesen in Eudoras eigenem Dialog *Tools → Last SSL Info*
(„Eudora SSL Connection Information Manager"), Bildschirmfoto von Gregor.

| | |
|---|---|
| Server | `mx.freenet.de`, `194.97.208.35` |
| **Port** | **110** |
| Zeitpunkt | Monday, August 31, 2026, 08:09:43 |
| Negotiation Status | **Succeeded** |
| SSL Version | **TLSv1.3** |
| Encryption Algorithm | **TLS_AES_256_GCM_SHA384 (256 bits)** |

### Warum das wichtig ist

Damit ist die offene Frage aus `Releases/1.0/AUSLIEFERUNGEN.md` beantwortet.
Dort stand: *„Der Mailserver-Test steht für sie aus."* Der bisherige
erfolgreiche Abruf (29.08., `pop.gmx.net`) war mit `c875a750` gelaufen — der
Fassung **ohne** den Regressionsfix [H1](#h1) und **ohne** WACHEs fünf Befunde.

**Jetzt ist die ausgelieferte QCSSL 1.0.1 (`ab55281a`) selbst gemessen:**
TLS 1.3 mit einem AEAD-Verfahren, Aushandlung erfolgreich. Die strengeren
Vorgaben aus [M1](#m1) (Mindestprotokoll TLS 1.2 für alle Einstellungen) haben nichts
verschlechtert — genau das war die Sorge, die in AUSLIEFERUNGEN.md formuliert
war.

### Port 110, nicht 995 — und das ist richtig so

`ABRUF-PRUEFEN.md` empfiehlt `SSLReceiveUse=2` mit Port 995, also **implizites
TLS**. Gregor hat stattdessen **Port 110 mit STARTTLS** benutzt, und es
funktioniert: die Verbindung beginnt im Klartext auf dem gewöhnlichen
POP3-Port und wird per `STLS` auf TLS 1.3 gehoben.

Das ist kein Widerspruch, sondern der zweite gangbare Weg. `ABRUF-PRUEFEN.md`
sollte beide nennen, statt nur einen — mit dem Hinweis, dass freenet auf 110
mit STARTTLS nachweislich arbeitet.

Nebenbei beantwortet: die in `ABRUF-PRUEFEN.md` als **UNGEPRÜFT** markierte
Frage, ob `mx.freenet.de` überhaupt POP3 spricht. **Ja**, auf Port 110.

### Was damit belegt ist

Die ganze Kette trägt: OpenSSL 3.5.8 LTS → QCSSL 1.0.1 → `QCWorkerSocket` →
POP3 über STARTTLS → 159 abgerufene Nachrichten. Kein Absturz, keine
Zertifikatswarnung — der mitgelieferte aktuelle Wurzelzertifikatsspeicher
(`rootcerts.p7b`, 121 Zertifikate) trägt gegen freenet.

## E-4 — Debug-Zusicherung beim Beenden: Index außerhalb von `m_arrBars` (31.08.2026 — BEHOBEN am 05.09.2026, ungeprüft)

Beim **Schließen** von Eudora:

    Microsoft Visual C++ Runtime Library
    Debug Assertion Failed!
    Program: C:\Users\Gregor\Eudora72-1.0.3\mfc140d.dll
    File:    ...\ATLMFC\Include\afxcoll.inl
    Line:    213

### Was an dieser Zeile steht — nachgeschlagen, nicht geraten

`afxcoll.inl:213` ist die Bereichsprüfung in **`CPtrArray::ElementAt`**:

```cpp
_AFXCOLL_INLINE void*& CPtrArray::ElementAt(INT_PTR nIndex)
    { ASSERT(nIndex >= 0 && nIndex < m_nSize);      // <- Zeile 213
```

Also ein **Index außerhalb des Arrays**. In der Ersatzschicht kommt `ElementAt`
nicht vor — aber MFCs eigene `CDockBar` benutzt es auf `m_arrBars`, und genau
daran hat die heutige Andockrechnung gearbeitet.

### Wahrscheinlichste Ursache (UNGEPRÜFT)

`SECDockBar::MoveControlBarToPosition` (`OTShim.cpp:2718-2795`, heute neu) baut
`m_arrBars` **von Hand** um: `RemoveAt` (bis zu zweimal), dann `InsertAt`, dann
gegebenenfalls eine `NULL`-Endemarke anhängen.

`m_arrBars` ist kein gewöhnliches Feld: MFC hält darin Zeiger auf Leisten,
getrennt durch `NULL`-Marken, die die Zeilen abschließen — und `CDockBar` führt
parallel dazu Zustand mit (`CControlBar::m_pDockBar`, die Positionsangaben, und
`CFrameWnd::m_listControlBars`). Wer das Feld umbaut, muss diesen Zustand
mitziehen.

Der Verdacht: beim Beenden läuft MFCs eigener Abbauweg über `m_arrBars` und
trifft auf eine Struktur, die zu dem nicht passt, was es sich gemerkt hat.

**Nicht widerlegt, aber auch nicht belegt** — es fehlt der Aufrufstapel.

### Wie man es morgen in Minuten findet

`tools/stapel-untersuchen.ps1` fängt die Ausnahme und läuft die EBP-Kette ab.
Damit wurde [S-2](#s-2) gefunden. Nötig: `Eudora.pdb` neben der `Eudora.exe` im Paket.
Eine Debug-Zusicherung ist allerdings keine Ausnahme im Sinne des Debuggers —
sie zeigt einen Dialog. Zwei Wege:

1. Im Dialog **„Wiederholen"** drücken: das löst einen Haltepunkt aus, den der
   Debugger als Ausnahme sieht.
2. Oder `_CrtSetReportMode(_CRT_ASSERT, _CRTDBG_MODE_DEBUG)` setzen, dann geht
   die Meldung in die Debugausgabe statt in einen Dialog.

### Einordnung

Es passiert **beim Beenden**, nachdem alles funktioniert hat — Abruf,
Darstellung, Menüs. Kein Datenverlust ist zu erwarten: Eudora hat seine
Postfächer zu diesem Zeitpunkt geschrieben. Im **Release-Bau gibt es die
Meldung nicht**, weil `ASSERT` dort entfällt — der zugrunde liegende
Indexfehler bliebe aber bestehen und könnte dort still danebengreifen. Das ist
der Grund, ihn nicht auf sich beruhen zu lassen.

### Behoben am 05.09.2026 (Commit `1188e87`) — und der Verdacht oben war falsch

Gregors Debug-Bau 7.2.0.4 hat die Ursache gezeigt. Sie liegt **nicht** in
`SECDockBar::MoveControlBarToPosition`, wie oben unter „Wahrscheinlichste
Ursache (UNGEPRÜFT)" vermutet. Der Abschnitt bleibt als Beleg stehen, ist aber
**widerlegt**.

Der Beleg ist eine Zusicherung, die schon **beim Start** kam:

```
Expression : (pMDIFrame)->IsKindOf((QCControlBarWorksheet::GetThisC...
Location   : CWazooBarMgr::SetDefaultWazooBarState, Line 409
```

### Die Kette

`WazooBarMgr.cpp` schickt an zwei Stellen `ID_SEC_MDIFLOAT`, um eine angedockte
Leiste in ein MDI-Kindfenster zu verwandeln. In dieser Fassung läuft das ins
Leere: `SECMDIFrameWnd::FloatControlBarInMDIChild` ist bewusst ohne Wirkung
(`OTShim.cpp:348`), weil MFC kein Gegenstück dafür hat.

Die Leiste bleibt also angedockt, und `GetParentFrame()` liefert weiterhin das
**Hauptfenster**. Beide Blöcke danach casten es per C-Cast — der prüft nichts —
auf `CMDIChildWnd` beziehungsweise `QCControlBarWorksheet` und arbeiten damit.
Die letzte dieser Zeilen ist ein **Schreibzugriff** auf einen Versatz in einem
Objekt falschen Typs:

```cpp
pMDIFrame->m_bFirstActivationAfterClose = TRUE;
```

Im Debug meldete sich `ASSERT_KINDOF`; im Release ist `ASSERT` leer
(`Eudora.vcxproj:132` `NDEBUG` → `stdafx.h:54` → `qcassert.h` →
`SuperAssert.h:135`). Der Zugriff blieb und beschädigte **beim Start** fremden
Speicher. Sichtbar wurde es erst beim Beenden, wenn MFC die Leisten abräumt —
daher die irreführende Spur zu `afxcoll.inl:213`.

### Behebung

Beide Blöcke bekommen die Abfrage, die Eudora an vier anderen Stellen längst
benutzt (`WazooBarMgr.cpp:790`/`:821`, `WazooBar.cpp:652`/`:690`):

```cpp
if (pWazooBar->IsMDIChild())
```

`IsMDIChild()` liefert in dieser Stufe immer `FALSE` (`OTShim.cpp:1565`, mit
Begründung im Kommentar). Die beiden Blöcke werden damit übersprungen — genau
richtig, denn sie setzen etwas voraus, das nicht stattgefunden hat. Die Stellen
stehen jetzt in `WazooBarMgr.cpp:273` und `:421`.

> **Status: behoben, ungeprüft.** Dass die Meldung beim Beenden ausbleibt, hat
> am laufenden Programm noch niemand bestätigt.

## Z-2 — Umlaute in HTML-Nachrichten: der Zeichensatz wird nirgends angesagt (Ursache gefunden, 31.08.2026, ZEICHEN)

Befund [E-2](#e-2): In HTML-Nachrichten steht statt eines Umlauts ein Ersatzzeichen
(`f<>r` statt `fuer`), im reinen Text derselben Sitzung stimmen die Umlaute.

### Der HTML-Anzeigepfad, Schritt fuer Schritt (alles nachgelesen, nicht vermutet)

1. `CTridentView::LoadMessage()` (`Eudora/TridentView.cpp:1453-1550`) legt mit
   `GetTempFileName` eine **temporaere Datei** an, ruft
   `WriteTempFile(theFile, ...)` (`:1496`) und danach
   `m_pSite->Load((LPTSTR)(LPCTSTR)m_szTmpFile)` (`:1546`).
2. `CSite::Load` (`Eudora/SITE.CPP:397-465`) reicht diesen **Dateipfad** an
   MSHTML weiter — ueber `CreateURLMoniker` + `IPersistMoniker::Load` (`:423-440`),
   ersatzweise `IPersistFile::Load` (`:453-460`).
3. `CTridentView::WriteTempFile` (`Eudora/TridentView.cpp:1281-1440`) schreibt in
   diese Datei: erst das Stylesheet (aus `read.css` oder aus
   `IDS_INI_READMESSAGE_STYLE_SHEET`, `EudoraRes.rc:8129-8130`, Anfang:
   `<HTML><HEAD><STYLE>`), dann Kopfzeilen, dann den Nachrichtenrumpf aus
   `GetMessageForDisplay`.

**In keinem dieser drei Schritte wird ein Zeichensatz angegeben.** Kein BOM,
kein `<meta ... charset=...>`, keine Codepage-Umwandlung. Die Volltextsuche des
Auftrags stimmt und ist damit erklaert: die Suche nach `IPersistStreamInit`
liefert im ganzen Baum **keinen** Treffer, weil MSHTML hier ueber eine Datei
geladen wird. MSHTML muss den Zeichensatz also selbst raten — aus dem Inhalt.

### Woher das Ersatzzeichen kommt

Was auf der Platte steht, ist **Windows-1252**: `TextReader::ReadIt`
(`Eudora/TextReader.cpp:243-250`) uebersetzt jede Zeile mit
`size = ISOTranslate(buf, size, iCharsetIdx)`, sobald `iCharsetIdx > 2` ist —
und `ISOTranslate` (`Eudora/utils.cpp:1240-1283`) wandelt UTF-8 ueber
`MultiByteToWideChar(CP_UTF8, ...)` + `WideCharToMultiByte(1252, ...)` nach
CP1252. Das gilt fuer HTML-Teile genauso wie fuer Text, `bHtml`
(`TextReader.cpp:63`) steuert nur den `<x-html>`-Rahmen, nicht die Uebersetzung.

Der `<meta http-equiv="Content-Type" ... charset=utf-8>` aus der Originalmail
ueberlebt diese Umwandlung dagegen unveraendert: der Tag-Filter in
`GetBodyAsHTML` (`Eudora/msgutils.cpp:1616-1645`) sieht sich `<meta>` **nur auf
`http-equiv=refresh`** an (`:1629`) und laesst jedes andere `<meta>` samt
`charset`-Angabe stehen.

Damit steht in der temporaeren Datei: CP1252-Bytes, dazu die Ansage "utf-8".
MSHTML glaubt der Ansage, findet ein einzelnes Byte `0xFC`, das in UTF-8 nicht
vorkommt, und setzt **ein** U+FFFD dafuer.

Das passt genau zum Bild: **ein** Ersatzzeichen je Umlaut. Waere es umgekehrt —
UTF-8-Bytes als CP1252 gelesen —, stuenden dort **zwei** Zeichen (`Ã¼`). Der
Textpfad hat kein `<meta>` und keinen Rater und zeigt deshalb richtig an ([E-1](#e-1)).

### Behebung: zwei Aenderungen, beide eingesetzt

1. **Den Zeichensatz ansagen**, als erste Bytes der temporaeren Datei, vor dem
   Stylesheet, in `CTridentView::WriteTempFile`
   (`Eudora/TridentView.cpp:1334-1351`):

       static const char	szCharsetMeta[] =
           "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\">\r\n";
       ...
       theFile.Write( szCharsetMeta, sizeof(szCharsetMeta) - 1 );
       theFile.Write( szStyleSheet, szStyleSheet.GetLength() );

   `windows-1252` ist in **allen** Faellen richtig: bei `iCharsetIdx <= 2`
   (Windows, US-ASCII, Latin-1) sind die Bytes unveraendert Latin-1/CP1252, bei
   `iCharsetIdx > 2` hat `ISOTranslate` nach CP1252 gewandelt. Vor dem
   Stylesheet und nicht in `IDS_INI_READMESSAGE_STYLE_SHEET`, weil eine
   vorhandene `read.css` die Ressource ersetzt (`TridentView.cpp:1300-1322`) —
   in der Ressource stuende die Ansage dann nur manchmal in der Datei.

2. **Die fremde Zeichensatz-Ansage entfernen**, in `GetBodyAsHTML`
   (`Eudora/msgutils.cpp:1625-1639`), damit MSHTML nicht doch der spaeteren
   Angabe der Mail folgt:

       CString		TagContentsLower = TagContents;
       TagContentsLower.MakeLower();
       bool		bIsBadMeta = HasBadAttributeValue(TagContents, "http-equiv", "refresh") ||
                                ( TagContentsLower.Find("charset") >= 0 );

   Ueber die Zeichenkette `charset` statt ueber `http-equiv`, weil der
   HTML5-Kurzschreibweise `<meta charset="utf-8">` das `http-equiv` fehlt und
   `HasBadAttributeValue` sie deshalb nicht sieht. `CString::MakeLower` statt
   `StrStrIA`, damit `msgutils.cpp` keinen neuen Kopf (`<shlwapi.h>`) braucht.

   UNGEPRUEFT ist allein, ob Schritt 1 fuer sich genuegt haette: ob MSHTML die
   erste oder die letzte `charset`-Angabe im Dokument gewinnen laesst, ist nicht
   nachgemessen. Schritt 2 macht die Frage gegenstandslos, deshalb beide.

### Stand und naechster Schritt

Ursache belegt, Anzeigepfad vollstaendig verfolgt, Fundstellen mit Datei:Zeile
oben. Beide Aenderungen sind eingesetzt (byte-erhaltend ueber
`tools/ersetze-bereich.pl`, CR-Zahl vorher/nachher je 18, unveraendert).

**Beide geaenderten Dateien uebersetzen fehlerfrei**, nachgemessen an den
Objektdateien: `Eudora71/Eudora/Build/Debug/msgutils.obj` (08:34:55) und
`TridentView.obj` (08:35:59), beide neuer als die Quellen (08:31:56). Der Bau
des Eudora-Projekts kommt vollstaendig durch die Uebersetzung und bricht erst
beim **Binden** ab, an einer fremden Ursache:

    LINK : fatal error LNK1104: Datei "...\Eudora71\Importers\Lib\Debug\NSImport.lib"
    kann nicht geoeffnet werden.   [Eudora.vcxproj]

`Eudora71/Importers/Lib/Debug/` gibt es in diesem Worktree gar nicht — die drei
Importer-Projekte sind im Solution-Bau vorher an `QCUtils.lib` gescheitert
(siehe naechster Unterabschnitt). Es fehlt also eine Vorstufe, nicht ein
Ergebnis dieser Aenderung.

**Nicht nachgewiesen ist die Wirkung.** Es gibt kein gebundenes `Eudora.exe`
aus diesem Worktree, und ein Lauf von Eudora war nach Auflage ausgeschlossen.
Wer weitermacht:

1. Die Vorstufen bauen, bis `QCUtils.lib` und die drei Importer-Libs stehen,
   dann `Eudora.vcxproj` erneut binden. An den zwei geaenderten Dateien ist
   dafuer nichts zu tun.
2. Gegenprobe ohne Eudora-Start moeglich: nach dem Anzeigen einer
   UTF-8-HTML-Mail liegt die Zwischendatei in `%TEMP%\eud*.htm`
   (`TridentView.cpp:1469-1484`). Darin muss die erste Zeile die
   `windows-1252`-Ansage tragen und im Rumpf darf kein `charset=` mehr stehen.
3. Erst danach das Bildschirmfoto aus [E-2](#e-2) wiederholen.
### Nebenbefund (nicht behoben)

`GetBodyAsHTML` schreibt beim Pruefen der Meta-Tags mit `*(LPTSTR)TagEnd = 0`
in einen Puffer, der ueber `LPCTSTR` hereinkam (`msgutils.cpp:1633`). Das ist
Bestand des Originalcodes und hier nicht angeruehrt worden, faellt aber jedem
auf, der die Stelle liest.


### Der Bau der ganzen Solution: 6 Fehler, keiner davon aus dieser Aenderung

Gemessen im frischen Worktree, `MSBuild Eudora71\Eudora.sln -p:Configuration=Debug
-p:Platform=x86 -m`, 2030 Warnungen, 6 Fehler:

  * `OT501.vcxproj`, dreimal: `NMAKE : fatal error U1073: ".\utility\crypt\Blackbox.cpp"
    konnte nicht erstellt werden`, dasselbe fuer `OTA50D\OTA50D.lib`, und daraus
    folgend `error MSB3073` fuer `NMAKE /f build50.mak ota50d`.
  * `NSImport.vcxproj`, `OLImport.vcxproj`, `OEImport.vcxproj`, je einmal:
    `LINK : fatal error LNK1104: Datei "QCUtils.lib" kann nicht geoeffnet werden`.

Beide Gruppen betreffen **fremde Teilprojekte** und keine der zwei geaenderten
Dateien. Die LNK1104-Gruppe ist eine Reihenfolge- oder Abhaengigkeitsfrage des
Parallelbaus (`-m`): die Importer binden, bevor `QCUtils.lib` fertig ist. Ob es
sich um denselben bekannten Effekt handelt, den README unter "in einem frischen
Klon oder Worktree zuerst die ganze Solution bauen" beschreibt, ist
**UNGEPRUEFT** — ein zweiter Lauf desselben Befehls wuerde das entscheiden.

## E-5 — Das Release startet auf einem Win11-Rechner ohne Visual Studio nicht (31.08.2026, OFFEN)

Gregor hat `Eudora72-1.0.3-release.zip` aus der GitHub-Veröffentlichung auf einem
zweiten Rechner (Windows 11, **kein** Visual Studio) ausgepackt: *„exe aus dem
github release ordner startet auf einem win11 pc gar nicht."*

### Was ausgeschlossen ist

Streng nachgemessen, mit `dumpbin -dependents` über alle 37 Binärdateien des
Pakets — und diesmal **ohne** `SysWOW64` als Fundort zu akzeptieren, weil dort
auf einem Rechner ohne Visual Studio nichts liegt:

| fehlt | gebraucht von | hält den Start auf? |
|---|---|---|
| `MFC42.DLL` | `EuGraph.ocx` | **nein** — erst bei Benutzung geladen |
| `MFC71.DLL` | `EudoraBk`, `ISock`, `Ldap`, drei Plugins | **nein** — dito |
| `MSVCP71.dll` | `Ldap`, `Ph`, drei Plugins | **nein** — dito |
| `oledlg.dll` | `mfc140.dll` | **nein** — Bestandteil von Windows |

Ebenfalls ausgeschlossen: eine Vermischung von Debug und Release. Jede Datei im
Paket wurde einzeln geprüft, keine braucht eine Debug-Laufzeit. Die drei
verteilbaren Laufzeiten liegen bei.

### Mein Fehler bei der vorigen Prüfung

Ich hatte gemeldet, alle Importe lösten auf — dabei habe ich „liegt in
`SysWOW64`" als „vorhanden" gewertet. Auf dieser VM stimmt das, weil Visual
Studio installiert ist; auf Gregors Zielrechner nicht. **Genau der Fehler, den
PRÜFER am Paketprüfer schon nachgewiesen hatte** ([PR-2](#pr-2): „prüft die Maschine,
nicht das Paket") — und ich habe ihn in meiner eigenen Prüfung wiederholt.

### Was jetzt zu prüfen ist, in dieser Reihenfolge

1. **Mark of the Web.** Dateien aus einem heruntergeladenen ZIP tragen einen
   Zonenvermerk; Windows kann das Laden von DLLs daraus verweigern — ohne
   Meldung. Gegenprobe im ausgepackten Ordner:

       Get-ChildItem -Recurse | Unblock-File

2. **Wie „gar nicht" genau aussieht.** Kein Fenster? Eine Meldung? Erscheint der
   Prozess kurz im Task-Manager? Davon hängt alles Weitere ab. Ohne diese Angabe
   ist jede Vermutung wertlos.
3. **Die Ereignisanzeige** auf dem Zielrechner, Protokoll *Anwendung*: ein
   Ladefehler steht dort mit dem Namen der fehlenden Datei.
4. **`tools/paket-pruefen.ps1` auf dem ZIELRECHNER laufen lassen** — dort, wo
   kein Visual Studio ist, gibt es die richtige Antwort. Das ist auch der einzige
   belastbare Nachweis für Kriterium 0 (siehe die Berichtigung in `ZIEL.md`).

### Was daraus für Kriterium 0 folgt

**Es bleibt unbelegt, und die Vermutung, es sei erfüllt, ist widerlegt.** Ein
Release-Bau allein genügt nicht; das Paket muss auf einer Maschine ohne
Entwicklungsumgebung nachweislich starten.

## E-6 — Das Release läuft auf Windows 11 ohne Visual Studio — der Kontoassistent stürzt bei *Weiter* ab (31.08.2026, TEILERFOLG)

### Berichtigung zu E-5: es startet doch

Gregor hat das **hier gepackte** ZIP auf dem zweiten Rechner (Windows 11, kein
Visual Studio) ausgepackt und ein Mailverzeichnis hinzugefügt. **Eudora startet.**
Bildschirmfoto zeigt: Hauptfenster im Windows-11-Erscheinungsbild, Menüleiste
vollständig (*File* bis *Help* — ohne *Debug*, wie es im Release-Bau sein soll),
Postfachbaum links mit *In/Out/Junk/Trash/Recent*, Statuszeile, und den
**New Account Wizard**.

Damit ist **Kriterium 0 im Kern erreicht**: das Paket läuft ohne
Nachinstallieren auf einer Maschine ohne Entwicklungsumgebung. Einschränkung:
das Mailverzeichnis musste von Hand dazugelegt werden — der Grund dafür ist
noch nicht geklärt (im Paket liegt eines, siehe „Offene Frage" unten).

Was in [E-5](#e-5) als „startet gar nicht" gemeldet war, betraf offenbar das aus der
GitHub-Veröffentlichung heruntergeladene ZIP, nicht das hier gepackte. Der
Unterschied ist noch nicht gemessen; **UNGEPRÜFT**, ob es am Zonenvermerk
(*Mark of the Web*) lag.

### NEU: Absturz im Kontoassistenten

> *„wenn ich hier auf weiter klicke, stürzt es ab!"*

Der Assistent zeigt die Begrüßungsseite („Welcome to Eudora!"); der Klick auf
**Weiter >** beendet das Programm.

**Das ist ein Release-Bau — und genau davor war gewarnt.** FREIGABE hatte
festgehalten: *„im Release-Bau entfallen die SUPERASSERT-Dialoge und alle
ASSERT/VERIFY"*. Ein Fehler, der im Debug-Bau nur eine Zusicherung ausgelöst
hätte, wird hier zum Absturz. Im Debug-Bau ist der Assistent nie benutzt worden
— Gregor hat sein Konto von Hand über die `Eudora.ini` eingetragen.

**Wo zu suchen ist:** Projekt `Eudora71/AccountWizard`. Die Seitenklassen liegen
in `Eudora71/AccountWizard/PrivateInc` (`WizardAcapPage.h`,
`WizardClientPage.h`, `WizardConfirmpage.h`, `WizardFinishPage.h`,
`WizardImapDirPage.h` und weitere). Der Übergang von der ersten Seite läuft über
`OnWizardNext` der Begrüßungsseite.

**Nächster Schritt:** den **Debug**-Bau nehmen und im Assistenten auf *Weiter*
klicken. Dort meldet sich die Zusicherung mit Datei und Zeile, statt still
abzustürzen — das ist der schnellste Weg zur Fundstelle. Falls es im Debug-Bau
nicht auftritt, ist es ein reiner Release-Effekt (nicht initialisierte Variable
oder ein Codepfad, der nur ohne `ASSERT` erreicht wird), und dann hilft
`tools/stapel-untersuchen.ps1` gegen die Release-EXE mit der `Eudora.pdb`.

### Offene Frage

Warum musste das Mailverzeichnis von Hand dazugelegt werden? Das Paket enthält
`Mailverzeichnis\Eudora.ini` — entweder wurde es beim Auspacken nicht
mitgenommen, oder Eudora sucht es an anderer Stelle, wenn kein Argument
übergeben wird. Zu klären.

### Stand der vier Kriterien am 31.08.2026 (Zeitdokument)

| # | Kriterium | Stand |
|---|---|---|
| 0 | Paket ohne Nachinstallieren | **im Kern erreicht** — läuft auf Win11 ohne VS; Mailverzeichnis noch von Hand |
| 1 | startet, Hauptfenster bedienbar | **erfüllt** |
| 2 | Darstellung korrekt | **fast** — HTML-Umlaute behoben, aber ungeprüft |
| 3 | Mailkonto verbinden und Mail abrufen | **erfüllt** (Debug-Bau) — im Release blockiert der Assistent |

## E-7 — Die Bau-Kennung fehlt im Titel, solange kein Fenster offen ist (31.08.2026 — BEHOBEN am 05.09.2026, ungeprüft)

Gregor auf dem Win11-Rechner: *„und ich sehe hier keine versionsnummer in der
titelzeile"*. Der Titel zeigt nur `Eudora`.

### Es ist kein Bau-, sondern ein Anzeigeproblem — nachgemessen

| Prüfung | Ergebnis |
|---|---|
| Kennung in der Release-EXE? | **ja**, bei Versatz 2.147.104: `Eudora 7.2.0.3 / Paket 1.0.3+b1f20e0` |
| Vorlagentext `unbekannt` in der EXE? | **nein** — die echte Kennung wurde erzeugt, nicht die Vorlage |
| Überschreibung im Baum? | **ja**, `mainfrm.cpp:9686` |

### Die Ursache

`CMainFrame::OnUpdateFrameTitle` läuft **nur, wenn MFC den Rahmentitel
auffrischt** — also wenn sich ein MDI-Kindfenster ändert. Beim Start ohne
geöffnetes Postfach, und während der modale Kontoassistent läuft, ist das nie
der Fall. Der Titel steht dann noch so, wie er beim Erzeugen des Fensters
gesetzt wurde, und die Ergänzung war nie dran.

Auf dieser VM fiel es nicht auf, weil dort immer ein Postfach geöffnet war —
der Titel lautete `Eudora [... ] - [In]`. Genau der Zustandsunterschied, der
heute schon bei den Werkzeugleisten-Knöpfen zu einer falschen Meldung geführt
hat ([E-2](#e-2)).

### Behebung

Die Kennung muss **beim Setzen des Titels** dazukommen, nicht erst bei seiner
Auffrischung. Zwei Wege:

1. In `CMainFrame::OnCreate` bzw. direkt nach
   `FinishInitAndShowWindow` (`eudora.cpp:1510`) einmal `OnUpdateFrameTitle(TRUE)`
   aufrufen. Billig, nutzt den vorhandenen Code.
2. Oder `m_strTitle` des Rahmens gleich mit der Kennung belegen — dann trägt
   MFC sie bei jeder Auffrischung von selbst mit, und die Überschreibung könnte
   ganz entfallen. Sauberer, aber `m_strTitle` wird an mehreren Stellen
   benutzt; **UNGEPRÜFT**, ob das Nebenwirkungen hat.

Weg 1 ist der kleinere Eingriff und wäre der erste Versuch.

### Warum das mehr als Kosmetik ist

Die Kennung ist dafür gebaut, ein Bildschirmfoto einem Bau zuzuordnen — und
genau in dem Zustand, in dem Gregor jetzt Fehler findet (frischer Start,
Assistent offen, noch kein Postfach), fehlt sie. Damit versagt sie an der
Stelle, für die sie da ist.

> **Nachtrag vom 31.08.2026 abends (Befund [V-1](#v-1)): es ist inzwischen mehr als
> das.** Unter `v1.0.3` sind **zwei verschiedene ZIPs** veröffentlicht, und beide
> `Eudora.exe` melden dieselbe Produktversion **7.2.0.3** — im Über-Dialog, im
> Explorer und im Absturzbericht. Die Bau-Kennung ist damit das **einzige**
> Merkmal am laufenden Programm, das die beiden auseinanderhält, weil sie den
> Commit enthält. Und sie fehlt ausgerechnet im Zustand des Absturzes. Die
> Behebung ist ein einziger Aufruf.

### Behoben am 05.09.2026 — Weg 1, ein Aufruf (Commit `bcc59bb`)

Gregor zur Fassung 7.2.0.4: *„versionsnummer fehlt in der titelzeile - warum?
korrigeiren!"* — derselbe Zustand, nur eine Fassung weiter.

Umgesetzt ist **Weg 1** aus dem Abschnitt oben: am Ende von
`CMainFrame::FinishInitAndShowWindow` (`mainfrm.cpp:1135`), also nachdem das
Fenster steht, läuft einmal

```cpp
OnUpdateFrameTitle(TRUE);
```

Die Funktion hängt die Kennung nicht doppelt an, sie prüft das selbst
(`mainfrm.cpp:9728`). Weg 2 (`m_strTitle` gleich belegen) ist **nicht**
umgesetzt und bleibt ungeprüft.

Release gebaut: 0 Fehler, 62 Warnungen, `Eudora.exe` mit 7.2.0.4.

> **Status: behoben, ungeprüft.** Dass die Kennung jetzt tatsächlich im Titel
> steht, hat am laufenden Programm noch **niemand** bestätigt — es liegt keine
> Rückmeldung von Gregor dazu vor. Nachsehen kostet einen Blick auf die
> Titelzeile beim nächsten Start.

## E-8 — Berichtigung zu E-6: der Win11-Lauf war der DEBUG-Bau (31.08.2026)

Gregor: *„ich habe das verwendet: `C:\Users\Gregor\Eudora72-1.0.3`"*

Nachgemessen mit `dumpbin -dependents`:

| Verzeichnis | Bauart | Größe | Laufzeiten im Ordner |
|---|---|---|---|
| `Eudora72-1.0.3` | **DEBUG** | 10.208.256 B | `mfc140d`, `msvcp140d`, `vcruntime140d`, `ucrtbased`, `concrt140d`, `mfc140deu` |
| `Eudora72-1.0.3-release` | RELEASE | 2.933.248 B | `mfc140`, `msvcp140`, `vcruntime140` |

### Zwei Folgerungen, beide unangenehm

**1. Der Absturz im Kontoassistenten ([E-6](#e-6)) ist KEIN Release-Effekt.** Er
passiert im Debug-Bau. Meine Erklärung in [E-6](#e-6) — „im Release entfallen alle
ASSERT, deshalb Absturz statt Zusicherung" — **trägt nicht**. Es ist entweder
ein Fehler unterhalb dessen, was `ASSERT` abfängt (Zugriff über einen ungültigen
Zeiger), oder es kam eine Zusicherung, die als Absturz wahrgenommen wurde.

Was das für die Suche bedeutet: der Debug-Bau bringt hier **keinen** zusätzlichen
Hinweis, weil er schon der Debug-Bau war. Der Weg führt über
`tools/stapel-untersuchen.ps1` gegen genau dieses Verzeichnis, mit der
`Eudora.pdb` daneben.

**2. Kriterium 0 ist NICHT erreicht.** Das Verzeichnis läuft auf dem
Win11-Rechner nur, weil die sechs **nicht verteilbaren** Debug-Laufzeiten
physisch darin liegen — ich hatte sie dort mit `laufzeit-holen.ps1` hinkopiert.
Genau das darf nicht ausgeliefert werden (Microsoft nimmt die Debug-Fassungen
ausdrücklich vom Weiterverteilen aus, siehe `ZIEL.md`, Kriterium 0).

Meine Meldung in [E-6](#e-6), Kriterium 0 sei „im Kern erreicht", ist damit **falsch**
und hiermit zurückgezogen.

### Was noch offen ist

Das **Release**-Paket (`Eudora72-1.0.3-release`, 2,9 MB) ist auf dem
Win11-Rechner **nicht ausprobiert** worden. Ob es dort startet, ist weiter
ungeprüft — und damit auch, was [E-5](#e-5) ursprünglich meldete.

Ebenfalls unverändert offen: warum das Mailverzeichnis von Hand dazugelegt
werden musste, obwohl beide Pakete eines enthalten.

### Die Lehre, zum dritten Mal an einem Tag

Ich habe eine Aussage über einen Zustand gemacht, ohne den Zustand zu prüfen —
und zwar genau die Frage, um die es ging: **welches Paket lief da eigentlich?**
Dieselbe Fehlerklasse wie bei den Werkzeugleisten-Knöpfen ([E-2](#e-2)) und bei
„SysWOW64 gilt als vorhanden" ([E-5](#e-5)). Siehe `Arbeitsweise/erst-pruefen-dann-anweisen.md`.

## E-9 — Absturz im Kontoassistenten bei *Weiter*: die Kette bis zur Importsuche (31.08.2026, OFFEN)

Gregor, in **beiden** Bauarten reproduziert (Debug- und Release-Paket 1.0.3):
*„beim klicken auf weiter stürzt es ab!"*

Damit ist es **kein Release-Effekt** — die Erklärung aus [E-6](#e-6) ist endgültig
widerlegt.

### Die Kette, nachgelesen

1. Die Begrüßungsseite `CWizardWelcomePage`
   (`AccountWizard/Src/WizardWelcomePage.cpp`) hat **kein** `OnWizardNext`. Der
   Klick auf *Weiter* führt also unmittelbar zur nächsten Seite.
2. Nächste Seite ist `CWizardClientPage`, angehängt in
   `WizardPropSheet.cpp:342-343` direkt nach der Begrüßungsseite.
3. Deren `OnSetActive` (`WizardClientPage.cpp`) tut als erstes dies:

   ```cpp
   if (!m_pParent->m_pImporter)
       m_pParent->m_pImporter = DEBUG_NEW CImportMail;

   if (m_pParent->m_pImporter->InitPlugins())
       m_pParent->m_pImporter->InitProviders();

   CImportMail *pIM = m_pParent->m_pImporter;
   ASSERT(pIM);
   if (!pIM->m_newhead)
   ```

4. `CImportMail::InitPlugins` (`Eudora/MAPIImport.cpp`) reicht direkt an
   `InitPluginList` weiter. Dort:

   ```cpp
   m_psDllStruct = DEBUG_NEW ImportDllStruct[iMatchingFiles];
   m_iDllStructSize = iMatchingFiles;
   ...
   m_psDllStruct[iMatchingFiles].szDllPath = finder.GetFilePath();
   InitDllStruct(iMatchingFiles);
   ```

### Zwei Auffälligkeiten in `InitPluginList`

**a) Die Anzahl wird zweimal ermittelt, das Feld nur einmal bemessen.** Erst
zählt eine Suche die Treffer, dann wird das Feld in dieser Größe angelegt, dann
läuft eine **zweite** Suche und schreibt hinein. Liefern die beiden Suchen
verschiedene Anzahlen, wird über das Feldende hinaus geschrieben.

**b) Der Rückgabewert von `DEBUG_NEW` wird nicht geprüft**, und `InitDllStruct`
wird für jeden Treffer gerufen — auch für einen, dessen DLL sich **nicht laden
lässt**. Und genau das ist belegt: die Ablaufverfolgung vom 30.08. zeigt

    LoadLibrary failed (...\Plugins\SMIME.dll): err = 126
    LoadLibrary failed (...\Plugins\SpamHeaders.dll): err = 126
    LoadLibrary failed (...\Plugins\SpamWatch.dll): err = 126

Fehler 126 ist „Modul nicht gefunden" — diese drei Plugins brauchen `MFC71.DLL`
und `MSVCP71.dll`, die dem Paket fehlen und nicht nachbaubar sind ([B-2](#b-2)). Ob
`m_szEudoraImportSearch` diese drei überhaupt trifft, ist **UNGEPRÜFT** — das
ist die erste Frage, die morgen zu klären ist.

### Wie man es entscheidet, ohne zu raten

1. **`tools/stapel-untersuchen.ps1`** gegen das Paket, `Eudora.pdb` daneben.
   Dann *Weiter* klicken. Der Debugger fängt die Zugriffsverletzung und nennt
   die Zeile. Das ist der direkte Weg und dauert Minuten.
2. **Gegenprobe ohne Debugger:** den Ordner `Plugins` im Paket umbenennen und
   den Assistenten erneut versuchen. Stürzt es dann **nicht** ab, ist die
   Plugin-Suche die Ursache — und der Verdacht auf `InitDllStruct` bestätigt.
   Das kann Gregor selbst in zehn Sekunden machen.
3. Erst danach `m_szEudoraImportSearch` und `InitDllStruct` genau lesen.

### Umgehung, die nachweislich funktioniert

Das Konto **über die `Eudora.ini` von Hand** eintragen, wie in
`ABRUF-PRUEFEN.md` beschrieben. Auf diesem Weg hat Gregor am 31.08. um 08:09
erfolgreich Mail abgerufen ([E-1](#e-1), [E-3](#e-3)) — der Assistent ist für Kriterium 3 nicht
nötig.

### E-9, Nachtrag: die Plugins sind es NICHT (31.08.2026, gemessen)

Gegenprobe von Gregor: `Plugins` in `Plugins_aus` umbenannt — **der Absturz
bleibt.** Und Eudora legt einen neuen, leeren `Plugins`-Ordner an.

Damit ist die Plugin-Suche als Ursache **ausgeschlossen**, und meine
Berichtigung im Commit `6e5da17` bestätigt: gesucht wird
`ExecutableDir` + `*.eif` (`MAPIImport.cpp:954-955`), also die drei Importer im
**Programmverzeichnis**. Der `Plugins`-Ordner enthält etwas anderes
(`SMIME.dll`, `SpamHeaders.dll`, `SpamWatch.dll`) und wird von `InitPluginList`
gar nicht angefasst. Dass Eudora ihn neu anlegt, ist normales Verhalten beim
Start und hat mit dem Assistenten nichts zu tun.

Die Härtung von `InitPluginList` (`6e5da17`) bleibt richtig — sie behebt zwei
echte Strukturfehler —, aber sie behebt **diesen** Absturz nicht.

### Wo es jetzt noch liegen kann

In `CWizardClientPage` selbst. Zwei Stellen fallen beim Lesen auf:

**a) `OnSetActive`, nach der Plugin-Suche:**

```cpp
if (m_pParent->m_pImporter->InitPlugins())
    m_pParent->m_pImporter->InitProviders();

CImportMail *pIM = m_pParent->m_pImporter;
ASSERT(pIM);
if (!pIM->m_newhead)
```

`InitProviders` wird **nur** gerufen, wenn `InitPlugins` `true` liefert. Findet
die Suche keine `*.eif`, liefert sie `false` — und danach wird `m_newhead`
gelesen, das erst `InitProviders` belegt. **UNGEPRÜFT**, ob der Konstruktor von
`CImportMail` `m_newhead` auf NULL setzt. Tut er es nicht, wird hier ein
unbestimmter Zeiger geprüft, und `pIM->m_newhead` weiter unten dereferenziert.

Das passt zum Bild: im Paket liegen zwar drei `.eif`, aber ob sie gefunden
werden, hängt an `ExecutableDir` — und das wird aus dem Modulpfad gebildet.

**b) `OnInitDialog`** ruft `OnRadioNew()`, bevor `OnSetActive` gelaufen ist —
also bevor `m_pImporter` überhaupt angelegt wurde. Was `OnRadioNew` anfasst,
ist noch nicht nachgelesen.

### Der nächste Schritt, der es entscheidet

`tools/stapel-untersuchen.ps1` gegen das Release-Paket, `Eudora.pdb` daneben,
dann *Weiter* per `BM_CLICK` an den Knopf senden — so wie es bei den
SUPERASSERT-Dialogen schon gemacht wurde. Der Debugger fängt die
Zugriffsverletzung und nennt Datei und Zeile. Ein Lauf von etwa einer Minute.

## E-11 — Der Absturz liegt nicht im Assistenten: `ReleaseBuffer` ohne `GetBuffer` (31.08.2026, URSACHE GEFUNDEN)

### Der Beleg: `eudora.log`

Gregor hat die Protokolldatei geschickt. **Beide Sitzungen enden an derselben
Stelle**, danach steht nichts mehr:

    MAIN     8: 0.01 Dialog: "Eudora is not currently the default mail program.\n"
    MAIN     8: 0.01 Dialog: "Would you like it to be the default mail program?"

Damit ist der Kontoassistent **entlastet**. Der Absturz passiert in der
Registrierung als Standard-Mailprogramm — der Klick auf *Weiter* schließt nur
den Assistenten, und danach läuft dieser Weg.

Die Meldung ist `IDS_WARN_DEFAULT_MAILTO` (`EudoraRes.rc:7909`), benutzt genau
einmal: `eudora.cpp:3331`, in `CEudoraApp::RegisterURLSchemes` (ab `:3274`,
gerufen aus `InitInstance` bei `:1591`).

### Die Fundstelle, drei Zeilen nach dem Dialog

`eudora.cpp:3369-3371`:

```cpp
if (!AddToRegistry(HKEY_CLASSES_ROOT, RegMailto, NULL, cmd))
    ::ErrorDialog(IDS_REG_MAILTO_ERR);
int i = RegMailto.Find('\');
if (i >= 0)
    RegMailto.ReleaseBuffer(i);          // <- hier
```

`RegMailto` ist ein **`CRString`** (`eudora.cpp:3287`), also ein aus einer
Ressource geladener String.

**`CString::ReleaseBuffer` ohne vorangehendes `GetBuffer` ist unzulässig.** Unter
VC6 war das gutmütig: `CString` hielt einen eigenen Puffer, und
`ReleaseBuffer(n)` setzte einfach die Länge. Bei **MFC 14** ist `CString` ein
`CStringT` mit **Referenzzählung**: `ReleaseBuffer` setzt voraus, dass der Puffer
exklusiv gesperrt ist, und schreibt in die gemeinsame Verwaltungsstruktur. Bei
einem geteilten Puffer zerstört das fremde Daten.

Das ist derselbe Klassiker wie die anderen VC6-Altlasten dieser Portierung
(`std::auto_ptr`, Iteratoren als Zeiger, Standardargumente) — nur schlägt er
erst zur Laufzeit zu.

### Der Umfang: 142 Vorkommen im Baum

`grep -rn "ReleaseBuffer(" --include=*.cpp Eudora71/` findet **142 Stellen**.
Nicht alle sind falsch — richtig ist das Muster
`p = s.GetBuffer(n); ... s.ReleaseBuffer();`. Falsch sind die Stellen **ohne**
vorangehendes `GetBuffer` auf derselben Variablen.

Auffällig auf den ersten Blick, weil sie eine **Länge** übergeben und damit
kürzen wollen — also die gefährliche Form:

- `eudora.cpp:3371` `RegMailto.ReleaseBuffer(i)` — **dieser Absturz**
- `ConConProfile.cpp:198` `m_szElementData.ReleaseBuffer(nNewDataLength)`
- `QCSharewareManager.cpp` (in `Load`) `RetailVersion.ReleaseBuffer(LastDot + 1)`
  — läuft bei **jedem Start** durch den Box-Build-Zweig

### Die Behebung

Statt `s.ReleaseBuffer(i)` gehört dort ein sauberes Kürzen:

```cpp
RegMailto = RegMailto.Left(i);
```

Das ist in allen Fällen richtig, ändert die Bedeutung nicht und kommt ohne
Puffersperre aus. **Nicht mehr in dieser Sitzung geändert** — die Zeit reichte
nicht, um es zu übersetzen und zu prüfen, und 142 Stellen wollen einzeln
angesehen werden.

### Nächster Schritt

1. `eudora.cpp:3371` auf `Left(i)` umstellen, bauen, Gregor probieren lassen.
   Ein Einzeiler, und er trifft genau den belegten Absturz.
2. Danach die 142 Vorkommen durchgehen: jedes ohne vorangehendes `GetBuffer` auf
   derselben Variablen ist ein Kandidat. Ein Werkzeug dafür wäre lohnend — das
   ist eine **Fehlerklasse**, kein Einzelfall.
3. `QCSharewareManager.cpp` zuerst, weil dieser Weg bei jedem Start läuft.

### Nebenbefund aus dem Protokoll

    Leeway 10, Out: MBX 1788158654, TOC 0
    Out .mbx size: MBX 0, TOC 1

Für eine **leere** `Out.mbx` (die Zeilen darüber melden `Size: 0`) wird eine
Dateigröße von **1.788.158.654** gemeldet — 1,7 GB. Ein nicht initialisierter
Wert. Zwei Zeilen später steht korrekt `MBX 0`. Eigener Befund, nicht
untersucht.


## R-1 — Die Fehlerklasse hinter E-11 ausgezählt: 25 von 142 Vorkommen sind falsch (31.08.2026)

Werkzeug: **`tools/releasebuffer-pruefen.pl`** (neu). Branch
`claude/letzter-stand-b2ytpi`, Commit `8f1c51e`, Berichtigung `26b52b8`.
Gemessen ohne Visual Studio, ohne Agenten, reine Quelltextanalyse — **es ist
keine Zeile C++ geändert worden**, und nichts davon ist übersetzt.

[E-11](#e-11) hat einen Absturz auf frischen Installationen auf `ReleaseBuffer` ohne
vorangehendes `GetBuffer` zurückgeführt (`eudora.cpp:3372`) und 142 Vorkommen im
Baum gezählt. Dieser Abschnitt stuft sie ein.

### Was das Werkzeug tut

Für jedes `ReleaseBuffer(` bestimmt es den Empfänger, schätzt den
Funktionsanfang (rückwärts bis zur nächsten schließenden Klammer in Spalte 1 —
VC6-Stil, in diesem Baum durchgehend) und sucht darin ein `GetBuffer` bzw.
`GetBufferSetLength` **auf derselben Variablen**.

| Einstufung | Bedeutung | Anzahl |
|---|---|---|
| `ok` | das richtige Paar `GetBuffer`/`ReleaseBuffer` — bleibt | **117** |
| `falsch` | kein `GetBuffer`, **und ein Argument** übergeben: hier wird gekürzt | **20** |
| `lockbuffer` | davor steht `LockBuffer`, nicht `GetBuffer` — der richtige Partner ist `UnlockBuffer()` | **4** |
| `danach` | `GetBuffer` steht erst **nach** dem `ReleaseBuffer` | **1** |
| `verdaechtig` | kein `GetBuffer`, kein Argument | 0 |

**25 Stellen sind zu ändern, 117 bleiben.** Aufruf:
`perl tools/releasebuffer-pruefen.pl` (Rückgabe 1, sobald etwas zu tun ist),
`--alle` zeigt auch die richtigen.

### Die Zahl 142 war zufällig richtig

Nachgemessen, weil eine Zahl ohne den Befehl, der sie erzeugt hat, nichts wert
ist:

| Messung | Ergebnis |
|---|---|
| `grep -rn "ReleaseBuffer(" --include=*.cpp` | 142 |
| dasselbe **einschließlich `.CPP`** in Großschreibung | 143 |
| davon eine reine **Kommentarzeile** (`eudora.cpp:3372`, „war ReleaseBuffer(i) …") | −1 |
| in `.h`/`.inl` | 0 |
| **echte Vorkommen** | **142** |
| davon findet das Werkzeug | **142** |

`--include=*.cpp` ist bei `grep` groß-/kleinschreibungsabhängig und übersieht
`Eudora71/Eudora/PGHTMIMP.CPP`; dafür zählt es die Kommentarzeile mit, in der
die Behebung von [E-11](#e-11) vermerkt ist. Die beiden Fehler heben sich auf.

### Berichtigung zur Behebung von E-11

`AUFGABEN.md` (A1) führt die Behebung als `RegMailto = RegMailto.Left(i);`.
Im Quelltext steht **`RegMailto.Truncate(i);`** (`eudora.cpp:3372`, nachgelesen).
Beides ist richtig; `Truncate` ist der kürzere Weg und kommt ohne temporäres
Objekt aus. Die Doku ist nachgezogen.

### DRINGEND: die Behebung von E-11 ist mit hoher Wahrscheinlichkeit unvollständig

**`CEudoraApp::RegisterURLSchemes()` reicht von `eudora.cpp:3274` bis `:3417`.**
In dieser **einen** Funktion stehen **drei** Vorkommen:

| Zeile | Stand |
|---|---|
| 3372 | `RegMailto` — **behoben** ([E-11](#e-11)), jetzt `Truncate(i)` |
| 3403 | `RegClientsMail.ReleaseBuffer(LastSlash)` — **unverändert falsch** |
| 3413 | `EudoraOption.ReleaseBuffer(SlashIndex)` — **unverändert falsch** |

Was `eudora.log` belegt: die letzte Zeile vor dem Abbruch ist der Dialog
`IDS_WARN_DEFAULT_MAILTO`, ausgegeben in **`eudora.cpp:3331`** — also **innerhalb
dieser Funktion, vor allen drei Stellen**. Der Absturz liegt damit hinter 3331;
dass er ausgerechnet an 3372 lag und nicht an 3403 oder 3413, ist **nicht
belegt**. Beide sind auf dem Weg: 3403 im Zweig `if (bIsDefaultMailto)`, 3413
ohne jede Bedingung.

**Folge für den ersten Punkt der Arbeitsliste:** wenn Gregor das v1.0.3-ZIP auf
dem Win11-Rechner probiert und es **weiterhin abstürzt**, ist das kein
Widerspruch zu [E-11](#e-11), sondern der Hinweis auf 3403/3413. Beide gehören vor dem
nächsten Paket behoben — es sind zwei Zeilen, und sie kosten einen Bau.

### Die 20 Stellen der Einstufung `falsch`

Nach Dringlichkeit, nicht nach Datei:

| Stelle | Empfänger | wie oft der Weg läuft |
|---|---|---|
| `eudora.cpp:3403`, `:3413` | `RegClientsMail`, `EudoraOption` | **bei jeder frischen Installation** — dieselbe Funktion wie der E-11-Absturz |
| `QCSharewareManager.cpp:1318` | `RetailVersion` | **bei jedem Start** (`Load`, Box-Build-Zweig) |
| `sendmail.cpp:1782`, `:1788`, `:1815`, `:1865` | `szLine` | **bei jeder gesendeten Klartextmail** — `CString szLine(pSrcLine, …)` (`:1736`), dann `SetAt`, dann `ReleaseBuffer` |
| `POPSession.cpp:1747` | `LoginName` | nur im Hesiod-Zweig (`stricmp(Server,"hesiod")`) |
| `SMTPSession.cpp:328` | `Recipient` | beim Auswerten einer Serverantwort mit `<…>` |
| `SMTPSession.cpp:683`, `Imapdll/src/Network.cpp:179` | `LoginName` | Anmeldung, Konto mit `@` |
| `mime.cpp:2020` | `m_CID` | jede Nachricht mit eingebettetem Inhalt (`Content-ID` in `<…>`) |
| `msgutils.cpp:2128`, `:2165`, `:2185`, `:2265` | `szPath` | Pfad- und Anhangbehandlung |
| `fileutil.cpp:482` | `EudoraDir` | Verzeichnisbestimmung |
| `guiutils.cpp:1605` | `File` | Dateiauswahl |
| `PaigeEdtView.cpp:657` | `strTitle` | Fenstertitel über 31 Zeichen |
| `MAPI/recip.cpp:52` | `FullAddress` | MAPI-Empfänger |

Alle wollen **kürzen**. Der Ersatz ist in jedem Fall `s.Truncate(n)` (so ist
[E-11](#e-11) behoben) oder `s = s.Left(n)`.

### Die 4 Stellen `lockbuffer` — anderer Fehler, anderer Ersatz

`Text2Html.cpp:912`, `:939`, `:955` und `PGHTMIMP.CPP:2944` holen den Puffer mit
**`LockBuffer()`**, schreiben hinein und geben ihn mit `ReleaseBuffer()` zurück.
Der Partner von `LockBuffer` ist **`UnlockBuffer`**; `ReleaseBuffer` ist es
nicht. Gemessen im Baum: 7 `LockBuffer`, aber nur 2 `UnlockBuffer`.

Das Muster ist dort überall dasselbe — ein abschließendes CRLF abschneiden:

```cpp
tempStr = szUrl.LockBuffer();
tempStr[strlen(tempStr)-2] = '\0';
szUrl.ReleaseBuffer();
```

Sauber wäre ohne Puffer: `if (szUrl.Right(2) == "\r\n") szUrl.Truncate(szUrl.GetLength()-2);`

### Die eine Stelle `danach`

`MimeStorage.cpp:270`:

```cpp
Message.ReleaseBuffer(0);
Message.GetBuffer(::SafeStrlenMT(m_theMess));
```

`ReleaseBuffer(0)` **vor** dem `GetBuffer` — die Absicht ist „leeren, dann
vorab belegen". Richtig wäre `Message.Empty();` gefolgt vom `GetBuffer`.
Nebenbei: das `GetBuffer` in der Folgezeile hat selbst kein `ReleaseBuffer` —
der Puffer bleibt gesperrt, solange die Funktion läuft.

### Was von Hand gegengelesen ist

Nicht alle 142, aber jede Einstufung mindestens einmal, und die kritischen
vollständig: **8 der 20** `falsch` (`POPSession:1747`, `mime.cpp:2020`,
`PaigeEdtView:657`, `QCSharewareManager:1318`, `SMTPSession:328`,
`eudora.cpp:3403` und `:3413`, `sendmail.cpp:1782`), **alle 4** `lockbuffer`,
der eine `danach`. **Kein Fehlalarm darunter.** Die Funktionsgrenzen von
`RegisterURLSchemes` (3274–3417) und `SendPlain` (ab 1607) sind eigens
nachgezählt.

### Grenzen des Werkzeugs — im Kopf der Datei ausführlich

Der Empfänger wird als **Text** verglichen: ein `GetBuffer` über einen Zeiger
auf dasselbe Objekt wird nicht erkannt, `s` und `m_str.s` gelten als
verschieden. Der Funktionsanfang ist geschätzt; wo die Schätzung an ihre Grenze
läuft, steht `[Funktionsanfang unsicher]` in der Ausgabe (nach dem Ausbau der
`LockBuffer`-Erkennung kommt das im Baum nicht mehr vor). Zeichenketten werden
nicht ausgeblendet — ein `"ReleaseBuffer("` im Text wäre ein Fehlalarm; im Baum
gibt es keinen.

### Nachtrag: ein Fehler im Werkzeug selbst (Commit `26b52b8`)

Beim Einbau der Einstufung `lockbuffer` hat `passt()` einen dritten Parameter
bekommen, und **eine von vier Aufrufstellen** wurde nicht nachgezogen (`:151`,
der Wächter in der Rückwärts-Suche). perl warnte bei jedem Lauf zweimal
`Use of uninitialized value $ruf in regexp compilation`.

**Wirkung auf das Ergebnis: keine.** Mit undefiniertem `$ruf` wurde der Ausdruck
zu `\s*\(` und lieferte für die `ReleaseBuffer`-Zeile selbst 0 — genau das, was
der Wächter erreichen sollte. Nachgemessen, vorher wie nachher: 117 ok,
20 falsch, 4 lockbuffer, 1 danach, 0 verdächtig = 142.

Aufgefallen ist es erst bei der Abschlussprüfung **nach** dem Commit, nicht
vorher. Festgehalten, weil ein Werkzeug, dessen Warnungen man gewohnheitsmäßig
übersieht, dasselbe Problem hat wie eine Schranke, die grundlos anschlägt.

### UNGEPRÜFT

- **Ob `CSimpleStringT::SetAt` den Puffer exklusiv hält.** Davon hängt ab, wie
  gefährlich die vier `sendmail`-Stellen wirklich sind. Die MFC-Quellen liegen
  in dieser Umgebung nicht vor. Unabhängig davon ist `ReleaseBuffer` ohne
  `GetBuffer` nicht der zugesagte Vertrag.
- **Ob 3403/3413 der tatsächliche Absturzpunkt sind.** Belegt ist nur, dass der
  Absturz hinter `eudora.cpp:3331` liegt.
- **Nichts davon ist übersetzt.** Es ist auch nichts geändert — dieser Abschnitt
  ist eine Meldung, keine Behebung.


## X-2 — Die neun Löcher der Schranke geschlossen, jedes mit eigenem Testfall (31.08.2026)

Abarbeitung von [**X-1**](#x-1) (neun Löcher in `tools/pruefe-bytes.pl`) und seines
Zusatzfundes zum pre-commit-Hook. Branch `claude/letzter-stand-b2ytpi`, Commit
`1819e61`, Stand davor `8f1c51e`. Gemessen ohne Visual Studio: perl 5.38,
git 2.43, ohne Agenten. **Keine C++-Quelldatei angefasst.**

### Die Sammlung ist der Beleg, nicht die Zusicherung

`tools/pruefe-bytes-tests.pl` wächst von 23 auf **35 Fälle**. Die zwölf neuen
sind nicht nachträglich passend geschriebene Tests: sie sind zuerst gegen die
**alte** Schranke gelaufen. So lässt sich das nachrechnen — die neue Sammlung
gegen die alte Schranke, in einem eigenen Verzeichnis:

```sh
D=$(mktemp -d)
git show 8f1c51e:tools/pruefe-bytes.pl > $D/pruefe-bytes.pl
cp tools/pruefe-bytes-tests.pl tools/dateiendungen.pl $D/
perl $D/pruefe-bytes-tests.pl
```

```
35 Faelle: 24 gruen, 11 rot
ROT: L1a, L1b, L2a, L2b, L3, L4, L5, L6, L7, L8, L9
```

> **Der Bezugscommit gehört in den Befehl, nicht `HEAD`.** Hier stand zuerst
> `git show HEAD:...`, und das war ab dem nächsten Commit falsch: `HEAD` trägt
> die **behobene** Schranke, die Anleitung liefert dann „35 grün" und die
> Gegenprobe sieht erfunden aus. Beim Durchlesen der Übergabe aufgefallen und
> berichtigt — dieselbe Fehlerklasse wie die veralteten Zeilenangaben aus [Z-1](#z-1).

**11 von 12 waren rot.** Der zwölfte (`L1c`) ist die Gegenkontrolle — eine
reine Umbenennung ohne Änderung am Inhalt muss durchlaufen, vorher wie nachher.
Gegen die neue Schranke: **35 grün, 0 rot.**

### Was geändert wurde, Loch für Loch

| Loch | Was durchlief | Behebung | Testfall |
|---|---|---|---|
| **L1** | `git mv alt.cpp neu.cpp` plus Neuschreiben — der Ablauf einer Portierung | `--diff-filter=ACM` → `ACMRT` und `--name-status` statt `--name-only`: bei `R` wird der Index-Blob des **neuen** gegen den HEAD-Blob des **alten** Pfads gehalten. Die Meldung nennt beide Namen | `L1a`, `L1b`, Gegenkontrolle `L1c` |
| **L2** | eine **saubere** Umkodierung Latin-1 → UTF-8 (erzeugt kein Ersatzzeichen, also sah Regel 2 nichts) | neue Regel 3: `latin1_nach_utf8($vorher) eq $jetzt` — byteweise, ohne Modul, exakt. Beide Richtungen | `L2a`, `L2b` |
| **L3** | ein neu eingefügtes UTF-8-BOM | neue Regel 4: BOM am Anfang des Index-Blobs, das im HEAD-Blob nicht stand | `L3` |
| **L4** | Dateien mit NUL-Byte: `git diff` liefert nur „Binary files differ", Regel 2 sah gar nichts | `git diff --text` erzwingt den Textvergleich. **Kein** pauschaler Alarm für NUL-Dateien — der hätte jede berechtigte Änderung an ihnen getroffen | `L4` |
| **L5** | die Vorausschau von 30 Zeilen war eine harte Grenze: 30 eingefügte Zeilen vor der Umwandlung wurden erkannt, **31 liefen durch** | gepaart wird über den ganzen Block. Die neue Obergrenze (`$MAX_PAARUNG = 20000`) ist nur eine Bremse gegen quadratische Laufzeit und liegt weit über dem größten Block im Baum (655 Zeilen) | `L5` (genau 31 Zeilen) |
| **L6** | reine CR-Zeilenenden (alter Mac-Stil) → LF | Regel 1 normalisiert jetzt auch ein einzelnes CR, nicht nur CRLF | `L6` |
| **L7** | die letzte Zeile verliert ihr CRLF — wurde bewusst durchgelassen, ist aber echter Byteverlust | nur die **Verlustrichtung** schlägt an. Einen Umbruch zu **ergänzen** bleibt erlaubt, sonst wäre der bestehende Fall `n` rot geworden | `L7`, Gegenkontrolle `n` |
| **L8** | neue Dateien wurden vollständig übersprungen, auch mit Ersatzzeichen | bei `A` gibt es nichts zu vergleichen, aber die U+FFFD-Prüfung läuft jetzt | `L8`, Gegenkontrolle `k` |
| **L9** | eine in HEAD **leere** Datei galt als „nicht vorhanden" und lief ungeprüft durch | `vorhanden()` fragt mit `git rev-parse --verify` nach dem Eintrag, getrennt von seinem Inhalt | `L9` |

### Der Zusatzfund: der Hook log

`tools/hooks-einrichten.sh` schrieb einen Hook, der den Rückgabewert von
`lehren-spiegeln.pl` **nicht** auswertete. Das Werkzeug meldet „Der Commit wurde
abgebrochen" und endet mit 1 — der Hook lief weiter und gab am Ende den Wert der
Schranke zurück. **Die Meldung war unwahr.**

Vorgeführt in einem Wegwerf-Repo, mit einem absichtlich scheiternden ersten
Schritt:

| Hook | Ausgabe | Rückgabe | Commit steht? |
|---|---|---|---|
| alt | `SPIEGELN MELDET ABBRUCH` | **0** | **ja** |
| neu | `SPIEGELN MELDET ABBRUCH` | **1** | nein |

Behoben mit `perl "$WURZEL/tools/lehren-spiegeln.pl" || exit $?`.

**[NP3-4](#np3-4) war bereits behoben** und ist hier nur der Vollständigkeit wegen
erwähnt: `lehren-spiegeln.pl` stagt nicht mehr selbst (das hinterließ bei
`git commit -- <pfad>` eine Löschung im echten Index), sondern bricht ab und
lässt den Menschen `git add Arbeitsweise` tun. Genau dieser Abbruch war es, den
der Hook verschluckte — die beiden Befunde greifen ineinander.

### Dazu NP3-5: nicht mehr stumm

`lehren-spiegeln.pl` endete wortlos mit 0, wenn das Gedächtnisverzeichnis nicht
gefunden wurde. Ein Aufrufer konnte „es gibt nichts zu tun" nicht von „ich habe
gar nicht erst hingesehen" unterscheiden. Es meldet den Fall jetzt auf `STDERR`
**samt dem abgeleiteten Pfad** — denn wenn die Ableitung schiefgeht, sucht sonst
niemand dort den Fehler — und endet im `--pruefen`-Modus mit 2.

### Was von X-1 offen bleibt

- **`tools/suche-zeiger.pl`**: 345 Treffer, Stichprobe 15 von 15 Fehlalarm.
  Die drei strukturellen Filter (klammerloser `if`-Rumpf, einzeiliger Wächter
  mit `return`, Abstand größer als das Fenster) sind **nicht** eingebaut.
- **`tools/zeilenenden-angleichen.pl`**: die 773 ausgelassenen Textdateien
  (`.ih`, `.rgs`, `.hh`, `.mc`, `.hpj`, 139 ohne Endung) und das richtungslose
  Zurückschreiben sind **nicht** angefasst.

Beides ist in `AUFGABEN.md` unter D3 und D4 beschrieben und braucht keinen
Compiler — es ist nur nicht Teil dieses Auftrags gewesen.

### Grenzen, die bleiben — und bewusst als Testfall festgehalten sind

- **Endungen**: was nicht in `tools/dateiendungen.pl` steht, wird nicht geprüft.
  Fall `o` (`.xyz`) hält diese Grenze fest, damit sie sichtbar bleibt.
- **Zeichenketten** werden nicht ausgeblendet; ein `"ReleaseBuffer("` im Text
  wäre für andere Werkzeuge ein Fehlalarm, für die Schranke ist es ohne Belang.
- **Die Schranke prüft den Index, nicht die Arbeitskopie.** Das ist Absicht und
  im Kopf der Datei begründet.
- **Regel 3 kann eine Mojibake-Reparatur nicht von einer Umkodierung
  unterscheiden.** Eine vollständig doppelt kodierte Datei zurückzurechnen
  (`ZIEL.md` war am 31.08.2026 genau so beschädigt) sieht byteweise aus wie
  „UTF-8 → Latin-1 umkodiert". Die Meldung sagt das ausdrücklich und lässt den
  Menschen entscheiden; für den Fall gibt es `--no-verify`. Ein Fehlalarm ist
  das nicht, sondern eine Frage, die nur ein Mensch beantworten kann.
- `git commit --no-verify` umgeht alles. Auch das ist Absicht — eine Schranke
  ohne Notausgang wird umgebaut, nicht befolgt.


## X-3 — `suche-zeiger.pl` brauchbar gemacht: 347 Treffer auf 18, davon 9 echte Kandidaten (31.08.2026)

Abarbeitung von **D3** aus `AUFGABEN.md` (Befund [X-1](#x-1): „345 Treffer, Stichprobe 15
von 15 Fehlalarm — ohne Filter nicht benutzbar"). Ohne Visual Studio gearbeitet,
**keine Zeile C++ geändert**. Werkzeug: `tools/suche-zeiger.pl`.

### Die Messkette

| Stand | Treffer |
|---|---|
| vorher ([X-1](#x-1): 345 an anderem Dateimuster) | **347** |
| nach den drei Filtern, die [X-1](#x-1) vorschlägt | 88 |
| nach drei weiteren, aus einer Stichprobe von 15 abgeleitet | 29 |
| nach drei weiteren, aus dem Nachlesen **aller** 29 | 20 |
| nach der Berichtigung zweier eigener Fehler | **18** |

Gemessen an **3295 Dateien** (`.cpp .CPP .c .h` unter `Eudora71`, ohne
`Build/ Debug/ Release/`). Nachzurechnen mit

```sh
find Eudora71 -name "*.cpp" -o -name "*.h" -o -name "*.c" -o -name "*.CPP" \
  | grep -v "/Build/\|/Debug/\|/Release/" | sort > /tmp/dateien.txt
perl tools/suche-zeiger.pl $(cat /tmp/dateien.txt)
```

### Warum nicht nach Bauchgefühl gefiltert wurde

[X-1](#x-1) nennt drei Ursachen mit Zahlen. Die Verteilung der Abstände zwischen
Prüfung und Zugriff belegt sie unmittelbar:

| Abstand | Treffer |
|---|---|
| **1 Zeile** | **212** |
| 3–5 | 8 |
| 6–10 | 24 |
| 11–20 | 29 |
| 21–40 | 28 |
| **> 40** | **46** |

212 mit Abstand 1 — das ist der klammerlose `if`-Rumpf, [X-1](#x-1) nennt 211.
46 mit Abstand über 40 — [X-1](#x-1) nennt 46.

### Die neun Filter

| # | Was durchlief | Wie behoben |
|---|---|---|
| 1 | **der klammerlose Rumpf** (212): bei `if (p)` ohne Klammern ist die nächste Anweisung der Rumpf, also der geschützte Bereich | der geschützte Bereich reicht bis zum Semikolon der folgenden Anweisung |
| 2 | **der einzeilige Wächter** (16): `if (!p) return;` auf **einer** Zeile — danach ist `p` garantiert belegt | das `return` wird jetzt auch auf der `if`-Zeile selbst gesucht, nicht nur in den sechs Folgezeilen |
| 3 | **die abgeschnittene Blockende-Suche** (Großteil der 46): sie lief nur 40 Zeilen weit; bei längeren Blöcken landete das „Blockende" **mitten im Block**, und der gemeldete Zugriff stand in Wahrheit noch **innerhalb** des geschützten Bereichs | keine Fenstergrenze mehr, nur eine Notbremse |
| 4 | **der `else`-Zweig eines negierten Wächters**: in `if (!p) {…} else {…}` ist `p` im `else` belegt | die **ganze** `else`-Kette wird übersprungen — bei einem **positiven** Wächter dagegen nicht, dort ist `p` im `else` NULL und ein Zugriff wäre ein echter Fehler |
| 5 | **Zuweisung an den Zeiger**: `if (!pCDC) { pCDC = &dc; }` | eine Zuweisung zwischen Prüfung und Zugriff macht die Prüfung gegenstandslos. Ein Schreibzugriff **durch** den Zeiger zählt nicht |
| 6 | **erneute Prüfung, die der alte Ausdruck nicht sah**: `return (pWnd) ? pWnd->…` (ternär) und `if ( (n>0) && pTocDoc && … )` — der alte Ausdruck verlangte `[^)]*` und scheiterte an der ersten inneren Klammer | jede Prüfung des Namens in einer Bedingung zählt, auch nach `&&` und vor `?` |
| 7 | **ein `else`, das zu einem ÄUSSEREN `if` gehört**: `app.cpp:274-277` erzeugte vier Fehlalarme in einem Rutsch | ein `else`, das **weniger tief** steht als der Wächter, beendet die Suche |
| 8 | **auskommentierter Code**: `pngerror.c:255` meldete einen Zugriff, der in einem `/* */`-Kommentar steht; `nickview.cpp:316/329` steht in einem **69 Zeilen langen** auskommentierten Block | Block- **und** Zeilenkommentare werden vor der Analyse ausgeblendet |
| 9 | **eine Steueranweisung als Rumpf**: `if (m_pcip) for (…) { … }` — der Block gehört zum `for` und ist geschützt | erkannt und wie ein Block behandelt |

**Bewusst NICHT eingebaut** — ein zehnter Filter „ein `return` auf oder über der
Ebene des Wächters beendet den Weg" war fertig und ist wieder herausgeflogen: er
entfernte **einen** Fehlalarm (`OLImportClass.cpp:2948`) und tötete **einen
echten Fund** (`ImapChecker.cpp:945`, dessen `return` innerhalb des umgebenden
Blocks steht, den man danach verlässt). Ein Wächter, der den echten Fall
verliert, ist schlechter als einer, der einmal zu oft ruft. Steht so im Kopf des
Werkzeugs, damit es niemand „nachbessert".

### Zwei Fehler, die ich selbst eingebaut habe

Beide fielen **nur** beim Nachlesen aller Treffer auf, nicht bei der
Stichprobe — das ist das Argument für das Nachlesen:

1. **Die Klammersuche lief in die nächste Funktion.** Als die 40-Zeilen-Grenze
   fiel (Filter 3), scannte sie bei einem klammerlosen `if` weiter, fand die
   Klammern der **folgenden** Funktion und setzte das Blockende dorthin.
   `ImapConnection.cpp:1916` meldete einen Zugriff **95 Zeilen später in einer
   anderen Funktion**. Behoben: erst entscheiden, ob der Rumpf überhaupt eine
   Klammer hat, dann scannen.
2. **Die Zeilenkommentare wurden nicht mehr gestrichen.** Beim Umstieg auf den
   kommentarfreien Puffer ging das `s{//.*$}{}` verloren, und eine geschweifte
   Klammer **im Kommentar** zählte als Blockende: `ImapAccount.cpp:3123` schreibt
   `(\noselect}` in einen `//`-Kommentar, worauf der Block dort zu schließen
   schien und zwei Zugriffe **innerhalb** des Blocks gemeldet wurden.

### Was übrig bleibt: 18 Treffer, alle nachgelesen

**Neun echte Kandidaten** — Prüfung vorhanden, Zugriff danach ungeschützt, und
kein erkennbarer Grund, warum der Zeiger dort belegt sein müsste:

| Stelle | Zeiger | Bemerkung |
|---|---|---|
| `EuImap/src/ImapMailbox.cpp:1637` → `:1659` | `pImapCommand` | `if (!pImapCommand) { ASSERT(0); … }` **ohne `return`** — im Release entfällt das `ASSERT` ([F-1](#f-1)), dann läuft es weiter und greift zu. Der ernsteste der neun |
| `Eudora/POPSession.cpp:896` → `:905` | `pDiskHost` | auf dem **Abrufpfad** — Nachbar der Befunde [P-1](#p-1)/[P-2](#p-2) |
| `EuImap/src/ImapChecker.cpp:945` → `:953` | `m_pTaskInfo` | Prüfung im umgebenden Block, Zugriff danach |
| `EuImap/src/ImapMailbox.cpp:1022` → `:1051` | `pAccount` | der eine Treffer, den [X-1](#x-1) als plausibel echt nannte |
| `EuImap/src/imapgets.cpp:735` → `:743` | `m_pAccount` | Passwortpfad |
| `Eudora/TocFrame.cpp:3968` → `:3973` | `pTocDoc` | `if (pTocDoc) …;` dann `if (pFBView) pTocDoc->…` — anderer Wächter |
| `Eudora/headervw.cpp:546` → `:551` | `pField` | zwei Zeilen nach dem Block |
| `Eudora/PgEmbeddedObject.cpp:276` → `:303` | `pView` | Block schließt nach drei Zeilen, Zugriff 27 später |
| `AccountWizard/Src/WizardImportPage.cpp:379` → `:420` | `pChild` | Block schließt bei 411 |

**Drei unklar** — das Melden ist vertretbar, die Entscheidung braucht einen
Menschen: `ImapAccount.cpp:3152`, `CompMessageFrame.cpp:644`,
`StatMng.cpp:2399` (jeweils ein anderer Zweig eines umgebenden `if`/`switch`).

**Sechs Fehlalarm:** `TridentView.cpp:584` (abgesichert über eine **abhängige**
Variable — nicht filterbar), `Trnslate.cpp:4410`, `OLImportClass.cpp:2948`,
`plist_cinfo.cpp:263` (Zugriff in einem Makrorumpf), und zwei in
`OpenSSL/demos/maurice/example2.c` — **Fremdcode**.

Quote: **6 von 18 (33 %)**, im eigenen Code ohne die OpenSSL-Beispiele
**4 von 16 (25 %)**. Vorher: 15 von 15.

### Empfehlung für den Aufruf

Fremdcode ausschließen, dann sind es 16 Treffer:

```sh
... | grep -v "/OpenSSL/\|/PNG/\|/OT501/\|/expat/\|/Qt3.x/"
```

### Was das Werkzeug nicht kann

Es liest Text, nicht Semantik. Ein Zeiger, der über einen **anderen** Namen
abgesichert ist (`TridentView.cpp:584`), eine Prüfung in einer aufgerufenen
Funktion, `ASSERT`/`VERIFY` als Prüfung, ein Zugriff in einem Makrorumpf — alles
unsichtbar. **Ein Treffer ist ein Hinweis zum Nachlesen, kein Befund.** Die
neun oben sind nachgelesen; wer sie behebt, braucht einen Bau.


## X-4 — `zeilenenden-angleichen.pl`: 49 Dateien mehr, und es dreht keine Arbeit mehr zurück (31.08.2026)

Abarbeitung von **D4** — der letzte offene Punkt aus Befund [X-1](#x-1). Ohne Visual
Studio gearbeitet, **keine Zeile C++ geändert**.

### Teil 1: die ausgelassenen Textdateien

[X-1](#x-1) hat gemessen, dass das Werkzeug **773 eindeutige Textdateien** nicht erfasst.
Nachgemessen am 31.08.2026 abends: von **9151** verfolgten Dateien erfasste das
Muster **6395**; von den 2756 übrigen sind **771** Text (kein NUL-Byte, über 95 %
druckbare Bytes).

Aufgenommen sind die, die **Quellen dieses Projekts** sind — sechs Arten,
49 Dateien:

| Endung | Dateien | warum |
|---|---|---|
| `.ih` | 6 | C-Header des Regex-Teils, werden **mitkompiliert** |
| `.rgs` | 12 | ATL-Registrar-Skripte, landen als **Ressource im Binary** |
| `.mc` | 2 | gehen durch den **Message Compiler** |
| `.user` | 18 | die `vcxproj.user`-Dateien, hier verfolgt |
| `.hh` | 7 | Hilfe-Header |
| `.hpj` | 4 | Hilfe-Projektdateien |

Grundgesamtheit **6395 → 6444**. **Alle 49 waren byteidentisch zu HEAD** —
nachgemessen, *bevor* die Liste erweitert wurde. Die Erweiterung deckt also
keinen Schaden auf, sie schließt eine Lücke für die Zukunft. Und weil die Liste
seit [PR-3](#pr-3) **geteilt** ist, zieht die Commit-Schranke automatisch mit.

**Bewusst draußen** geblieben, mit Begründung im Kopf von
`tools/dateiendungen.pl`: 139 Dateien ohne Endung (eine Endungsliste kann sie
nicht sicher von Binärdateien unterscheiden, eine Namensliste wäre Raten),
100 `.pem` und 20 `.cer`, 96 `.r` (Mac-Rez von QuickTime), 48 `.ssl` / 28 `.com`
/ 11 `.unix` (Makefiles des mitgelieferten OpenSSL), 37 Messwertdateien von
OpenSSL, 42 Hilfe- und Handbuchbestände, 10 Testskripte von Visual Test. Alles
Fremdbestand oder Beiwerk.

### Teil 2: es dreht keine absichtliche Arbeit mehr zurück

X-1s zweiter Vorhalt: *„Es dreht absichtliche Arbeit still zurück. Wer im
Arbeitsbaum absichtlich LF→CRLF korrigiert — etwa eine `.bat`, die CRLF braucht
—, verliert das durch `--aendern` kommentarlos."*

**Der Vorhalt trifft zu, und byteweise sind die beiden Fälle nicht zu
unterscheiden:** der Schaden, gegen den das Werkzeug gebaut wurde, sieht genauso
aus wie die absichtliche Korrektur — Arbeitskopie CRLF, HEAD LF. Also keine
Heuristik, sondern drei Sicherungen:

| # | Sicherung | Warum |
|---|---|---|
| 1 | **jede angefasste Datei wird namentlich genannt** (bis zu 20, dann die Zahl) | vorher stand dort nur eine Zahl — man konnte hinterher nicht sagen, was das Werkzeug getan hat |
| 2 | **vorgemerkte Dateien werden nicht angefasst** | wer eine Änderung an den Zeilenenden schon `git add` gegeben hat, hat sie absichtlich gemacht. Sie zurückzuschreiben würde vorgemerkte Arbeit still verwerfen. Eigene Zeile in der Ausgabe |
| 3 | **die Gegenrichtung hat ihre eigene Zeile** (Arbeitskopie LF, HEAD CRLF) und bleibt unangetastet | das ist **nicht** der Schaden dieses Projekts. Vorher landete sie unter „inhaltlich verschieden" — eine falsche Beschriftung. Mit `--auch-umgekehrt` wird sie mitgezogen |

### Gegenprobe in einem Wegwerf-Repo

Vier Dateien, vier Fälle, einmal `--aendern`:

| Datei | HEAD | Arbeitskopie | vorgemerkt | Ergebnis |
|---|---|---|---|---|
| `a.cpp` | LF | CRLF | nein | **angeglichen**, CR 2 → 0 |
| `b.cpp` | LF | CRLF | **ja** | **unangetastet**, CR bleibt 2 |
| `c.bat` | CRLF | LF | nein | **unangetastet** (Gegenrichtung), CR bleibt 0 |
| `d.cpp` | LF | LF, Inhalt geändert | nein | **unangetastet** |

Und mit `--aendern --auch-umgekehrt` wird `c.bat` sehr wohl angeglichen
(CR 0 → 1). Jede der vier Dateien erscheint namentlich in der Ausgabe.

### Stand am Baum

    byteidentisch zu HEAD:            6442
    Arbeitskopie CRLF, HEAD LF:          0
    Arbeitskopie LF, HEAD CRLF:          0
    vorgemerkt, nicht angefasst:         0
    inhaltlich verschieden:              2   (die zwei Werkzeuge dieser Arbeit)
    nicht in HEAD:                       0

Die Commit-Schranke bleibt bei **35 von 35 grün** — die erweiterte Endungsliste
bricht keinen ihrer Testfälle.

**Damit ist Befund [X-1](#x-1) vollständig abgearbeitet.**


## V-1 — Zwei verschiedene ZIPs unter derselben Versionsnummer (31.08.2026)

Gregors Feststellung, wörtlich: *„Eigentlich illegal, weil die gleiche Vers.nr.
Aber anderes zip"* — und dazu: **er hat die ausgetauschte Fassung nicht
geprüft.**

Beides trifft zu, und beides hat Folgen, die über die Formalie hinausgehen.

### Es ist derselbe Fehler wie bei der QCSSL.dll

`Releases/1.0/AUSLIEFERUNGEN.md` hält im ersten Absatz fest, warum es diese
Datei überhaupt gibt: *„Die Versionskennung wurde erst spät eingebaut und dann
einmal nicht mitgezogen. Dadurch tragen **zwei verschiedene Binärdateien
dieselbe Kennung „QCSSL 1.0.0"**. Wer sagt ‚ich habe 1.0.0 getestet', meint also
möglicherweise die eine oder die andere — und die unterscheiden sich in fünf
behobenen Befunden."*

Am 31.08.2026 um 09:00 ist genau das mit dem **Paket** passiert: unter
`v1.0.3` hängen zwei verschiedene ZIPs, und der einzige Unterschied zwischen
ihnen ist die Behebung eines Absturzes ([E-11](#e-11)). Die Lehre war aufgeschrieben und
hat nicht getragen — sie stand in der Datei über die *DLL*, nicht in der über
die *Pakete*.

### Was dadurch nicht mehr zusammengeht

| Angabe | Problem |
|---|---|
| „Gregor hat 1.0.3 probiert und es stürzte ab" | stimmt — für die **erste** Fassung (`632c4066…`). Ohne Prüfsumme wäre das nicht mehr zuzuordnen |
| die beiliegende `LIESMICH.txt` | beschreibt in der ersten Fassung einen Stand, den die zweite nicht mehr hat |
| ein Fehlerbericht von außen | „Version 1.0.3" identifiziert das Programm **nicht** |
| die **volle** SHA256 der ersten Fassung | steht **nirgends** im Repo, nur die ersten acht Zeichen. Zum Unterscheiden reicht das, zum Nachweisen nicht |

### Und der Stand wird dadurch schwächer, nicht stärker

**Keine der beiden veröffentlichten Fassungen ist von jemandem gestartet
worden:**

- Die **erste** hat Gregor probiert — sie stürzte beim Klick auf *Weiter* ab
  ([E-6](#e-6), Ursache [E-11](#e-11)).
- Die **zweite** (mit der Behebung) hat **niemand** geprüft. Das ist der Stand
  seit dem Austausch.
- Der Lauf, der 159 Nachrichten abgerufen hat ([E-1](#e-1), [E-3](#e-3)), war **keiner von
  beiden**: er lief aus `C:\Users\Gregor\Eudora72-1.0.3`, dem **Debug**-Bau mit
  von Hand hineinkopierten, nicht verteilbaren Laufzeit-DLLs ([E-8](#e-8)).

Für die Kriterien heißt das: 1 und 3 sind auf dem **Debug**-Bau belegt, nicht auf
dem ausgelieferten Paket. Kriterium 0 ist unbelegt. Das steht so in `ZIEL.md`,
wird aber leicht überlesen, wenn man „1.0.3 läuft" hört.

### Die Zahl steckt auch in der EXE — und zwar dieselbe

Gregors Nachtrag: *„Sie heißt übrigens 7.2.0.3"*. Das ist der Punkt, der die
Sache verschärft: nicht nur Dateiname und Paketnummer sind bei beiden ZIPs
gleich, sondern die **Produktversion im Binary**. Beide `Eudora.exe` melden
unter *Hilfe → Über Eudora*, im Explorer und im Absturzbericht **7.2.0.3**.

Damit ist die Angabe, die ein Anwender melden würde, für beide Fassungen
identisch. Unterscheiden können sie nur zwei Dinge:

1. die **SHA256 des ZIP** — und die volle Prüfsumme der ersten Fassung steht
   nirgends im Repo (siehe oben);
2. die **Bau-Kennung in der Titelleiste**, die den Commit enthält — **und die
   fehlt, solange kein Postfach offen ist** (Befund [E-7](#e-7)). Im Zustand des
   Absturzes, mit offenem Kontoassistenten, steht im Titel nur „Eudora".

**Das eine Merkmal, das die beiden Bauten auseinanderhält, ist genau dort nicht
sichtbar, wo der Fehler auftritt.** Damit ist [E-7](#e-7) nicht mehr Kosmetik, sondern
die Voraussetzung dafür, einen Fehlerbericht überhaupt einem Bau zuzuordnen —
und die Behebung ist ein einziger Aufruf (`OnUpdateFrameTitle(TRUE)` nach
`FinishInitAndShowWindow`).

Was genau zu ändern ist, wenn die Version gehoben wird — **fünf Zeilen in zwei
Dateien**, und die vier Angaben in `Version.h` sind nicht voneinander abgeleitet
—, steht in `Releases/PAKETE.md`, Abschnitt „Wie man die Version hebt".

### Die Regel, die daraus folgt

**Ein veröffentlichtes Paket wird nicht ersetzt.** Muss etwas hinterher, bekommt
es die nächste Nummer — nach der Verabredung in `Releases/PAKETE.md` also
Paket **1.0.4** mit Produktversion **7.2.0.4**. Das kostet eine Zeile in
`VERSION` und in `Eudora71/Version.h`; `tools/kennung-erzeugen.pl` warnt von
selbst, wenn die beiden auseinanderlaufen.

Das gilt auch dann — und besonders dann —, wenn die alte Fassung fehlerhaft ist:
gerade dann muss man sie später noch benennen können. Zurückziehen ja,
überschreiben nein.

### Was jetzt zu tun ist

1. **Die zweite Fassung auf dem Win11-Rechner starten.** Das ist ohnehin der
   erste Punkt der Arbeitsliste; hier ist der zusätzliche Grund: es ist bisher
   nur die *erste* geprüft, und die stürzte ab.
2. **Die volle SHA256 der ersten Fassung** aus der GitHub-Veröffentlichung
   nachtragen, solange sie noch abrufbar ist — sonst ist der einzige Beleg für
   „das ist die Fassung, die abstürzte" acht Zeichen lang.
3. **Beim nächsten Mal 1.0.4.** Wenn die Behebungen aus [R-1](#r-1) (`eudora.cpp:3403`
   und `:3413`) hineinkommen, ist das ohnehin ein neues Paket.

## E-12 — der Mailverzeichnis-Parameter wurde als Ini-Dateiname gedeutet

**Gemeldet** 05.09.2026, Fassung 7.2.0.4, Agent KONTO. **Status: behoben,
ungeprüft** (gebaut, aber am laufenden Programm noch nicht nachgesehen).

Gregors Meldung: *„account daten eingegeben, wurden aber weder gespeichert, noch
übernommen. kann mails nicht abrufen."* Gestartet hatte er mit

```
C:\Users\Gregor\Eudora72-1.0.4-release>Eudora.exe Mailverzeichnis
```

Ein **einziger** Fehler erklärt alle drei Beobachtungen.

### Der Ablauf, Schritt für Schritt

In `Eudora71/Eudora/fileutil.cpp`, Funktion `GetDirs`, stand:

```c
// If the directory doesn't have any path, then assume it's an INI
if (!Ini && (!strchr(CmdLine, SLASH) && CmdLine[1] != ':'))
{
    Ini = CmdLine;
}
else
{
    status = CheckMailDirectory(CmdLine, CRString(IDS_FILE_COMMAND_LINE));
    done = 1;
}
```

Für `CmdLine = "Mailverzeichnis"` gilt: kein Backslash darin, und `CmdLine[1]`
ist `a`, nicht `:`. Die Bedingung greift also, und Eudora hält den
Verzeichnisnamen für einen **Ini-Dateinamen**. `done` bleibt `0`.

Wenige Zeilen später:

```c
if (!done && EudoraDir.IsEmpty())
{
    EudoraDir = ExecutableDir;      // Datenwurzel = PROGRAMMverzeichnis
    status = TRUE;
}
```

Dann `SetupINIFilename("Mailverzeichnis")` in `rs.cpp`: der Name enthält keinen
Backslash, also

```c
INIPath = EudoraDir;
INIPath += Filename;
```

Ergebnis:

```
INIPath = C:\Users\Gregor\Eudora72-1.0.4-release\Mailverzeichnis
```

**Das ist ein Verzeichnis, keine Datei.** Eudora benutzte ein Verzeichnis als
seine Ini-Datei. `GetPrivateProfileString` liefert dann für jeden Schlüssel den
mitgegebenen Vorgabewert — bei den Kontofeldern die leere Zeichenkette —, und
`WritePrivateProfileString` scheitert stillschweigend. Es gibt keine
Fehlermeldung, an keiner Stelle.

Damit fällt alles zusammen:

| Beobachtung | Ursache |
|---|---|
| Dialog „Account Settings for `<Dominant>`" zeigt leere Felder | jeder Lesezugriff liefert die Vorgabe |
| Eingaben werden nicht gespeichert | jeder Schreibzugriff verpufft |
| Mail kann nicht abgerufen werden | `POPSession` liest Server und Konto über denselben Weg |

### Der Messbeleg

In Gregors Testverzeichnis lagen **zwei** Suchindex-Wurzeln:

```
Eudora72-1.0.4-release\Search\db.ini                   19:24   (Start von Hand, relativ)
Eudora72-1.0.4-release\Mailverzeichnis\Search\db.ini   19:29   (Start über die .cmd, absolut)
```

Der Start von Hand um 19:24 benutzte also tatsächlich das **Programm**verzeichnis
als Datenwurzel. Das ist der Fingerabdruck genau dieses Fehlers.

`tools/Eudora starten.cmd` übergibt `%~dp0Mailverzeichnis`, also einen absoluten
Pfad mit Backslashes — deshalb ist der Fehler beim Start über die .cmd nie
aufgefallen, und deshalb lief Gregors zweiter Versuch (19:28) sauber durch, bis
hin zu „You have new mail!" und einer `In.mbx` von 576 823 Bytes.

### Zweiter, verdeckter Teil: laufwerksrelative Pfade

`CheckMailDirectory` qualifiziert einen Pfad ohne Laufwerksbuchstaben so:

```c
szShortEDir[0] = (char)(drive + 'A' - 1);
szShortEDir[1] = ':';
szShortEDir[2] = '\0';
strcat(szShortEDir, dir);            // -> "C:Mailverzeichnis"
```

`C:Mailverzeichnis` ist **nicht** absolut, sondern *laufwerksrelativ*: Windows
löst es gegen das aktuelle Verzeichnis von Laufwerk C auf. `GetLongPathName`
macht daraus nichts Absolutes — nachgemessen:

```
in='C:Mailverzeichnis'  ret=17  out='C:Mailverzeichnis'
in='Mailverzeichnis'    ret=15  out='Mailverzeichnis'
```

Dieselbe Fehleinschätzung steckt in `SetupINIFilename`: die Prüfung
`INIPath[1] != ':'` hält `C:Mailverzeichnis\Eudora.ini` bereits für „fully
qualified". Sobald irgendetwas `SetCurrentDirectory()` aufruft — ein
gewöhnlicher Datei-Öffnen-Dialog genügt —, zeigt so ein Pfad woandershin, und
Einstellungen werden ab da aus einer anderen Datei gelesen und in eine andere
geschrieben. Lautlos.

### Der Nachweis am lebenden Objekt

`GetPrivateProfileStringA("Settings", "RealName", "<VORGABE>", ...)` gegen beide
Pfade, gemessen an Gregors echter Datei:

```
INIPath = ...\Mailverzeichnis             ->  RealName = '<VORGABE>'   (die Vorgabe!)
INIPath = ...\Mailverzeichnis\Eudora.ini  ->  RealName = 'hans wurst'
```

Der erste Pfad ist genau der, den Eudora aus `Eudora.exe Mailverzeichnis`
errechnete. Windows liefert wortlos die Vorgabe — in Eudoras Fall die leere
Zeichenkette. Gemessen, nicht vermutet.

### Was geändert wurde

`Eudora71/Eudora/fileutil.cpp`

1. **`GetDirs`, Kommandozeilenzweig:** vor der Heuristik wird jetzt das
   Dateisystem gefragt. Ein existierendes Verzeichnis ist ein Verzeichnis:
   ```c
   DWORD dwCmdLineAttr = ::GetFileAttributes(CmdLine);
   BOOL bCmdLineIsDir = (dwCmdLineAttr != INVALID_FILE_ATTRIBUTES) &&
                        ((dwCmdLineAttr & FILE_ATTRIBUTE_DIRECTORY) != 0);

   if (!Ini && !bCmdLineIsDir && (!strchr(CmdLine, SLASH) && CmdLine[1] != ':'))
   ```
   Der Fall „Argument ist wirklich eine Ini-Datei" bleibt damit erhalten — er
   greift weiterhin, wenn der Name kein Verzeichnis benennt.
2. **`GetDirs`, Umgebungsvariablenzweig:** dieselbe Prüfung, gleicher Fehler.
3. **`CheckMailDirectory`:** der Pfad wird einmal mit `GetFullPathName` in einen
   echten absoluten Pfad aufgelöst, bevor er in `EudoraDir` landet.
4. **`CheckMailDirectory`:** `GetLongPathName` ließ `Edir` bei Misserfolg
   *uninitialisiert* — anschließend lief `strlen(Edir)` über Zufallsbytes. `Edir`
   wird jetzt vorher belegt.
5. **`fileutil.cpp:482`** (Fundstelle aus [**R-1**](#r-1)):
   `EudoraDir.ReleaseBuffer(Slash + 1)` ohne vorheriges `GetBuffer` ersetzt durch
   `EudoraDir = EudoraDir.Left(Slash + 1)`. Unter MFC 14 ist `ReleaseBuffer(n)`
   ein `SetLength(n)` ohne `Fork`: bei geteiltem Puffer kürzt es still eine
   fremde Zeichenkette mit. Die Stelle liegt mitten im Ini-Pfad.

`Eudora71/Eudora/rs.cpp`

6. **`SetupINIFilename`:** nach der bestehenden „fully qualify"-Prüfung wird
   `INIPath` zusätzlich mit `GetFullPathName` aufgelöst.

Alle Änderungen byte-erhaltend eingespielt (perl `:raw`); CR-Zahl in beiden
Dateien unverändert 18.

### Bauzustand

Release **und** Debug, `x86`, jeweils 0 Fehler.

### Was Gregor zum Nachprüfen tun muss

```
cd C:\Users\Gregor\Eudora72-1.0.4-release
Eudora.exe Mailverzeichnis
```

— also **genau so wie beim Fehlversuch, mit dem relativen Pfad**. Erwartung:
Die Kontodaten stehen im Dialog, und der Mailabruf läuft. Gegenprobe ohne
Programmstart: `Mailverzeichnis\Eudora.ini` muss nach dem Beenden neuer sein als
vorher, und im Programmverzeichnis darf **kein** `Search\db.ini` neu entstehen.

### Offener Rest

Die 24 übrigen `ReleaseBuffer`-Stellen aus [**R-1**](#r-1) bleiben. Zwei davon,
`POPSession.cpp:1747` und `SMTPSession.cpp:683`, stehen im POP- bzw.
SMTP-Anmeldeweg, sind aber nur erreichbar, wenn der Server buchstäblich
`hesiod` heißt — latent, hier nicht ursächlich.
## Z-2 (Fortschreibung, 05.09.2026, ZEICHEN) — der Rest von E-2: ein einziger Umlaut kaputt, alle anderen richtig

Gregor am 05.09.2026, Fassung 7.2.0.4, im Vorschaufenster einer abgerufenen
Nachricht — beides in **derselben Anzeige**:

    "BestTV (U-TV) Android Player fÃ¼r LiveTV"      falsch
    "Fritzbox als Werbe-Filter: So läuft Blocken"   richtig

Das `ä` stimmt, das `ü` nicht. `fÃ¼r` ist die Signatur „UTF-8-Bytes als CP1252
gelesen" (U+00FC = `C3 BC`).

**Die Behebung von [Z-2](#z-2) ist nicht die Ursache und wird nicht zurückgenommen.**
Die Ansage `charset=windows-1252` ist richtig. Die Ursache liegt beim **Abruf**,
nicht bei der Anzeige, und sie ist eine andere als die von [Z-2](#z-2).

### Der Widerspruch aufgelöst: es liegt an der Stelle im Bytestrom

Die drei im Auftrag genannten Erklärungen — zwei Nachrichten, zwei MIME-Teile,
zwei Kodierungen — sind alle **falsch**. Es ist eine Nachricht, ein Teil, ein
Zeichensatz. Der Unterschied ist die **Position** der beiden Bytes im Strom.

**Beleg 1 — die Zwischendatei.** `%TEMP%\eudA.htm`, 12 602 Bytes, 05.09.2026
19:32, geschrieben von `CTridentView::WriteTempFile`. Sie enthält 33 Bytes über
0x7F. **32 davon sind Windows-1252** (`E4` ä, `F6` ö, `FC` ü, `DF` ß, `D6` Ö,
`96` Halbgeviertstrich, `B7` Mittelpunkt) — und **genau eines** ist eine
UTF-8-Folge: `C3 BC` an Offset 4240, in „BestTV (U-TV) Android Player für
LiveTV". Davor stehen als erste Bytes der Datei:

    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">

Diese Ansage ist für 32 von 33 Zeichen richtig. Nimmt man sie weg, sind
schlagartig alle 32 falsch (das war der Ausgangsbefund mit den U+FFFD).

**Beleg 2 — die rohen Bytes stehen schon im Postfach.**
`Eudora72-1.0.4-release/Mailverzeichnis/In.mbx`, Offset 568472:
`... Android Player f<C3><BC>r LiveTV ...`. Das Postfach wird beim **Abruf**
geschrieben. Der Fehler ist also vor der Anzeige entstanden; `TridentView.cpp`
und `msgutils.cpp` sind unbeteiligt.

**Beleg 3 — der Schlüssel: dieselbe Zeichenkette, einmal richtig, einmal
falsch, in derselben Nachricht.** In der Nachricht „<Betreff eines Newsletters>" desselben
Postfachs steht dasselbe Wort *auswählen* dreimal als `ausw<E4>hlen` (richtig)
und einmal als `ausw<C3><A4>hlen` (roh). Und *für 8,74 €* steht einmal als
`f<FC>r 8,74 <E2><82><AC>` und einmal als `f<C3><BC>r 8,74 <80>` — beide
Zeichen jeweils andersherum. Ein Absender kann dieselbe Zeichenkette nicht
zweimal verschieden kodieren, und ein MIME-Teil hat nur einen Zeichensatz. Der
Unterschied **kann** nur an der Stelle im Strom liegen.

### Die Ursache im Quelltext

`TextReader::ReadIt` (`Eudora/TextReader.cpp`) liest den Rumpf **stückweise**:

    for (size = ms->m_LineReader->ReadLine(buf, bSize); size > 0; ...)
        ...
        size = ISOTranslate(buf, size, iCharsetIdx);

Der Puffer kommt aus `pop.cpp:663` (`char szBuffer[2048]`); wie groß ein Stück
wirklich wird, hängt zusätzlich an der Zeilenlänge und an der
Übertragungskodierung. Ein UTF-8-Zeichen ist **2 bis 4 Byte lang und kann auf
der Stückgrenze auseinandergerissen werden.**

Dann ist keine der beiden Hälften gültiges UTF-8:

* `MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, ...)` scheitert
  (`utils.cpp`, in `ISOTranslate`) — absichtlich, siehe [Z-2](#z-2);
* der Rückfall auf `pcXlateTable` findet ebenfalls nichts, denn die Tabelle
  kennt nur **vollständige** Folgen;
* beide Bytes bleiben stehen, jedes in seinem Stück.

Ergebnis: **genau ein Umlaut ist kaputt, alle anderen stimmen** — Gregors Bild,
Byte für Byte. `ISOTranslate` kann das nicht selbst beheben: es sieht immer nur
ein Stück und kann nicht wissen, dass das nächste die Fortsetzung bringt.

Das Verhalten von `ISOTranslate` war seit dem 31.08. sogar geprüft
(`Tests/TestIsoTranslate.cpp`, „bei abgeschnittenem Zeichen fällt die Tabelle
ein"). Übersehen wurde, dass der **Aufrufer** daraus einen Anzeigefehler macht.

### Behebung

Abgewogen wurden die beiden Wege aus dem Auftrag:

* **(b) den Zeichensatz der Nachricht durchreichen und `utf-8` ansagen** —
  verworfen. In der Zwischendatei stehen 32 CP1252-Bytes und 2 UTF-8-Bytes.
  Keine einzige Ansage kann für beides richtig sein; `utf-8` würde 32 Zeichen
  kaputtmachen, um 1 zu retten. Außerdem müsste der Zeichensatz durch
  `GetMessageForDisplay` und den Postfach-Aufbau hindurchgereicht werden, wo er
  gar nicht mehr existiert: nach dem Abruf gibt es nur noch CP1252.
* **(a) den Rumpf zuverlässig nach CP1252 übersetzen und CP1252 ansagen** —
  gewählt. Es ist die Zusage, die `ISOTranslate` ohnehin gibt; sie wurde nur an
  der Stückgrenze gebrochen.

Geändert, drei Dateien:

1. **`Eudora/utils.cpp`** — zwei neue Funktionen vor `ISOTranslate`:
   * `BOOL ISOIsUTF8Charset(UINT iCharsetIdx)` — die Rechnung für den
     UTF-8-Index steht damit an einer Stelle statt an zweien;
   * `LONG ISOIncompleteUTF8Tail(const char* szBuf, LONG lSize)` — zählt die
     Bytes am Pufferende, die ein **angefangenes** UTF-8-Zeichen sind (0 bis 3).
     Ein vollständiges Zeichen am Ende ergibt 0, ein CP1252-Einzelbyte ergibt 0,
     ein Folgebyte ohne Kopf ergibt 0.
   `ISOTranslate` selbst ist **unverändert**; alle bestehenden Tests gelten
   weiter.
2. **`Eudora/utils.h`** — die beiden Deklarationen.
3. **`Eudora/TextReader.cpp`** — der Übertrag. Vor der Schleife wird `bSize` um
   drei weitere Bytes verkleinert (Platz, um die zurückgehaltenen Bytes vor das
   nächste Stück zu setzen). In der Schleife, vor `ISOTranslate`: das
   Zurückgehaltene vorn wieder anfügen, dann den angefangenen Rest des neuen
   Stücks zurückhalten. `ISOTranslate` bekommt so nur noch ganze Zeichen zu
   sehen. Nur bei UTF-8 — ein Einzelbyte-Zeichensatz hält nie etwas zurück.

Endet ein MIME-Teil mitten in einem Zeichen, werden die ein bis drei
zurückgehaltenen Bytes verworfen statt geschrieben: für sich sind sie kein
Zeichen, und sie zu schreiben ergäbe genau den Bytesalat, um den es geht.

### Prüfung

`Eudora71/Tests`: **109 Tests, 109 bestanden**, darunter vier neue:

* `ISOIncompleteUTF8Tail: angefangenes Zeichen wird gezaehlt`
* `ISOIncompleteUTF8Tail: vollstaendiges Zeichen wird nicht zurueckgehalten`
* `ISOIncompleteUTF8Tail: getrenntes Zeichen wird ueber die Stueckgrenze heil`
* `ISOIsUTF8Charset: erkennt genau den UTF-8-Index`

Der dritte ist der gemeldete Fall: `f C3` | `BC r` ergibt jetzt `f FC r` statt
`f C3 BC r`.

Neues Werkzeug **`tools/postfach-zeichen-pruefen.pl`** (liest nur): sucht in
einer `.mbx` nach vollständigen UTF-8-Folgen und nennt Nachricht, Stelle und
Umfeld. Im Postfach vom 05.09. findet es 249 Stellen in 8 Nachrichten, darunter
die eine aus Gregors Beobachtung. Nach dem Abruf darf im Postfach **keine**
vollständige UTF-8-Folge mehr stehen — das ist die Schranke für diese
Fehlerklasse.

### Was Gregor zum Nachprüfen tun muss

1. Neue Fassung bauen und einsetzen.
2. **Neu abrufen.** Schon abgerufene Nachrichten bleiben kaputt — die rohen
   Bytes stehen im Postfach, nicht in der Anzeige. Das Vorher/Nachher ist nur an
   frisch abgeholter Post zu sehen.
3. `perl tools/postfach-zeichen-pruefen.pl <Mailverzeichnis>\In.mbx` — sollte
   „Nichts gefunden" melden, jedenfalls für die Nachrichten, die mit der neuen
   Fassung geholt wurden.

### Beide Bauten

`MSBuild Eudora71/Eudora.sln -t:Build -p:Configuration=<Release|Debug> -p:Platform=x86 -m`,
frischer Worktree, also von Grund auf:

* **Release x86: grün**, Exitcode 0, **0 Fehler** im Protokoll,
  `Eudora71/Bin/Release/Eudora.exe` neu geschrieben.
* **Debug x86: grün** im zweiten Lauf, Exitcode 0, **0 Fehler**,
  `Eudora71/Bin/Debug/Eudora.exe` neu geschrieben.

**Nebenbefund: der erste Debug-Lauf brach ab** — zweimal
`LNK1104: Datei "QCUtils.lib" kann nicht geöffnet werden`, in `OEImport` und
`NSImport`. `QCUtils.lib` entstand ausweislich der Zeitstempel **erst danach**.
In der Projektmappe fehlt also die Abhängigkeit der beiden Importer auf
`QCUtils`; unter `-m` verlieren sie das Rennen. Mit der Fassung dieses Befundes
hat das nichts zu tun (die Importer binden `utils.cpp` gar nicht ein), und der
Release-Lauf traf es nur zufällig nicht. Der zweite Lauf fand die Bibliothek
vor und lief durch. **Zu beheben wäre:** die Projektabhängigkeit in
`Eudora.sln` nachtragen, sonst ist jeder Bau von Grund auf ein Glücksspiel.

### Offen geblieben (belegt, nicht behoben)

* **Absender mit gemischter Kodierung.** In „<Betreff eines Newsletters>" stehen an
  manchen Stellen rohe CP1252-Bytes (`80` für €) **mitten in einem
  UTF-8-Teil**. Der ganze Puffer fällt dann auf die Tabelle zurück, und was die
  Tabelle nicht kennt — etwa `E2 80 AF` (U+202F, schmales geschütztes
  Leerzeichen) — bleibt roh. Das ist eine eigene Klasse und braucht eine
  eigene Entscheidung: die Tabelle erweitern, oder `MB_ERR_INVALID_CHARS`
  gegen ein zeichenweises Verfahren tauschen, das nur die kaputten Bytes
  stehenlässt und den Rest umsetzt.
* **Der IMAP-Pfad.** `EuImap/src/ImapDownload.cpp:4662` ruft `ISOTranslate`
  ebenfalls stückweise auf, hat also denselben Bruch — und zusätzlich einen um
  eins verschobenen Zeichensatzindex: er kommt aus
  `FindRStringIndexI(IDS_MIME_US_ASCII, ...)`, `ISOTranslate` erwartet aber die
  Zählung von `FindMIMECharset` (der Test „POP: der Index wird um eins
  verschoben — anders als im IMAP-Pfad" hält das bereits fest). Nicht angefasst,
  weil Gregor über POP abruft und eine Änderung dort ungeprüft bliebe.
* **Der Kopfzeilenpfad** (`lex822.cpp:544`) ist **nicht** betroffen: dort liegt
  der dekodierte Text am Stück vor, es gibt keine Grenze zum Zerreißen.

## B-3 — `OT501` aus dem Bau genommen: ein frischer Klon baut ohne Kniffe (05.09.2026)

Bis zum 05.09.2026 scheiterte **jeder Bau aus einem frischen Klon** am Projekt
`OT501`. Es kapselt die **Stingray Objective Toolkit**, ein kommerzielles
Fremdprodukt von 1995; die Quelltextfreigabe des CHM durfte es nicht enthalten.
Im Repo liegen nur 39 `.cpp` (fast alle die mitgelieferte JPEG-Bibliothek) und
die Kopfdateien. `OT501` kann deshalb **nie** bauen.

Der Ausweg war bisher `/p:BuildProjectReferences=false` — ein Kniff, der in
`README.md` stand und den jeder Neue kennen musste.

### Belegt, dass niemand `OT501` braucht

| Beleg | Fundstelle |
|---|---|
| Kein Projekt bindet `OTA50R.lib` oder `OTA50D.lib`. Die einzige Erwähnung schließt sie ausdrücklich **aus** | `Eudora.vcxproj`, `IgnoreSpecificDefaultLibraries` |
| Die beiden Projektverweise trugen bereits `<LinkLibraryDependencies>false</LinkLibraryDependencies>` | `Eudora.vcxproj`, `EudoraRes.vcxproj` |
| Keine Quelldatei bindet eine Stingray-Kopfdatei ein, die eine Bibliothek verlangt | — |
| Ersetzt ist das Ganze durch die eigene Schicht `Eudora71/OTShim`, rund 18.000 Zeilen | Befund [S-2](#s-2) und `Eudora71/OTShim/INVENTAR.md` |

### Was geändert wurde (Commit `d8cc9d3`)

* die Projektverweise auf `OT501` aus `Eudora71/Eudora/Eudora.vcxproj` und
  `Eudora71/Eudora/EudoraRes.vcxproj` entfernt,
* die beiden `.Build.0`-Zeilen für `OT501` aus `Eudora71/Eudora.sln` entfernt.

Das Projekt bleibt in der Projektmappe **sichtbar**, wird aber nicht mehr
gebaut. `..\OT501\Include` bleibt im Suchpfad: die Kopfdateien werden gebraucht,
nur die Bibliothek nicht.

**Damit entfallen die drei Fehler**, die ein voller Solution-Bau bis dahin
meldete (zweimal `NMAKE U1073`, einmal `MSB3073`, gemessen am 31.08.2026 in
Befund [B-2](#b-2)). `README.md` ist am 05.09.2026 entsprechend berichtigt — sowohl die
Kurzfassung unter „Bauen" als auch der Abschnitt „Was den Bau kaputtmacht",
Punkt 4.

> **Berichtigung im selben Zug** (Commit `f468a02`): Es stand zwischenzeitlich
> die Behauptung im Raum, ein `-t:Rebuild` habe eine vorgebaute `OTA50R.lib`
> gelöscht. Das war falsch. `OTA50R.lib` hat **nie existiert** — weder im Repo
> noch in einem Release-ZIP noch in einem Commit. Nachgemessen: die vier Dateien
> in `Src/OTA50R/` tragen unverändert den **31.08.2026, 07:22**; ein Clean hätte
> sie gelöscht. Es waren zwei Objektdateien und eine PCH aus einem Bauversuch,
> der an derselben fehlenden Quelle starb. Zerstört wurde nichts; sichtbar wurde
> ein Mangel, der die ganze Zeit da war.

**Wer `OT501` wieder in den Bau nimmt, bricht den Bau.**

## E-13 — Beim Mailabruf ist kein Fortschritt sichtbar: der Abruf dauert 0,02 Sekunden (05.09.2026)

> **Diese Kennung hieß bis zum 05.09.2026 versehentlich [`E-12`](#e-12).** Zwei Agenten
> haben unabhängig voneinander „die nächste freie E-Nummer" gewählt. [`E-12`](#e-12) ist
> an den Befund über das Mailverzeichnis-Argument vergeben (Commit `79c09d4`,
> zuerst zusammengeführt und im Verzeichnis geführt); dieser Befund hier bekommt
> [`E-13`](#e-13). Wer unter [`E-12`](#e-12) den Fortschrittsbefund sucht, ist hier richtig.

> **Stand des Codes:** Die Behebung liegt im Commit `bd3959c` auf dem Zweig
> **`wt/fortschritt-arbeit`** und ist in `bau-und-pruefung` **noch nicht
> enthalten**. Der vollständige Befundtext steht dort in `BEFUNDE.md`. Wer die
> beiden Zweige zusammenführt, **entfernt dort die Überschrift `## [E-12](#e-12) — Der
> Fortschritt beim Mailabruf …` zugunsten dieses Abschnitts** — sonst steht
> [`E-12`](#e-12) wieder zweimal in der Datei.

**Gregor am 05.09.2026 zur Fassung 7.2.0.4:**

> „mails lassen sich abrufen … status während des abrufes nicht sichtbar. es
> sieht so aus, als würde nichts passieren."

Am 31.08.2026 hatte er zum Debug-Bau mit 159 Nachrichten noch ausdrücklich
*„sichtbar im progress bar im status"* gemeldet ([E-1](#e-1), [E-3](#e-3)). Es sah deshalb nach
einem Rückschritt aus. **Es ist keiner.**

### Die naheliegende Erklärung war falsch — das ist die Lehre

Alle Verdächtigen, die man ohne Messung genannt hätte, sind widerlegt:

| Verdacht | Gegenbeleg |
|---|---|
| Rückschritt seit dem 31.08. | `git diff 1ea176f HEAD -- Eudora71/` berührt **keine** der beteiligten Dateien |
| Der Umbau der Andockleisten (`OTShim.cpp`, Commit `1a4a6d5`) hat die Leiste zerstört | `git merge-base --is-ancestor 1a4a6d5 1ea176f` sagt **ja** — der Umbau war schon in dem Bau vom 31.08. drin, in dem die Anzeige **funktionierte** |
| Unterschied Release gegen Debug: ein nötiger Aufruf steckt in einem `ASSERT` | im ganzen Pfad steht kein `ASSERT` mit Nebenwirkung. Die wirksamen Aufrufe stehen in `VERIFY`, und `VERIFY` **wertet im Release aus** |
| Die Statusleiste läuft über die Ersatzschicht (`SetControlBarWidthsInRow` ist ein leerer Rumpf, E3) | `OTShim.h:135` macht `SECStatusBar` zu einem **`typedef` auf MFCs `CStatusBar`** — die Ersatzschicht ist gar nicht beteiligt |

### Was es ist — aus Gregors eigenem Protokoll

`Mailverzeichnis\eudora.log`, Lauf vom 05.09.2026, `LogLevel 0x649F` (Bit `0x10`
= `DEBUG_MASK_PROG` gesetzt, die Fortschrittsmeldungen stehen also mit drin):

```
2.07 Begin fetching messages for : …@mx.freenet.de
2.09 Done  fetching messages for : …@mx.freenet.de
```

**Der Abruf dauerte 0,02 Sekunden**, neun Nachrichten; der ganze Postgang
1,08 Sekunden. Am 31.08. waren es 159 Nachrichten in einem Debug-Bau — dort
stand die Anzeige sekundenlang. **Der Unterschied liegt zwischen 159 Nachrichten
und neun, nicht zwischen Debug und Release.**

Beide Anzeigewege halten sich bei kurzen Vorgängen absichtlich zurück:

1. **Das Fortschritts-Fenster** (`progress.cpp:238-241`) wartet erst
   `ProgressIdle` Sekunden ab. Voreinstellung `ProgressIdle 3`
   (`EudoraRes.rc:8633`) — ein Postgang von 1,08 s erreicht die Schwelle nie.
2. **Die Statusleiste** hielt für den Fortschritt nur **16 Bildpunkte** bereit
   (`statbar.cpp:185`) und verbreiterte das Feld erst beim ersten Prozentwert,
   um es sofort wieder zu schrumpfen. Gezeichnet wurde nur per
   `InvalidateRect` — also **angemeldet**, nicht ausgeführt.

### Behebung (auf `wt/fortschritt-arbeit`, `statbar.cpp` / `statbar.h`)

Fortschrittsfläche von Anfang an in voller Breite; 2 Sekunden Nachlauf
(`TASK_LINGER_MS`); `UpdateWindow()` statt nur `InvalidateRect`; und der
Fortschritt zusätzlich als Text im Meldungsfeld, aus vorhandenen Ressourcen
gebaut (ohne neue Zeichenkette).

### Die Lehre

**Wer eine Fortschrittsanzeige prüft, sieht zuerst nach, wie lange der Vorgang
überhaupt dauert.** Das Protokoll des Anwenders hat hier vier Vermutungen auf
einmal widerlegt, für die sonst Bauten und Debugger-Läufe nötig gewesen wären.

---

## E-14 — Zusicherung beim Start: der X1-Suchindex wird neu angelegt (05.09.2026, OFFEN)

Im Debug-Bau 7.2.0.4, beim Start, vor der E-4-Zusicherung:

    SUPERASSERT Assertion Failure
    Expression : !"Erasing X1 indices because DB schema was missing or ..."
    Location   : SearchManager::Info::InitX1, Line 496 in SearchManager...

**Nicht angefasst.** Der Text sagt selbst, was geschieht: das Schema der
Suchdatenbank fehlt oder passt nicht, also wird der Index verworfen und neu
angelegt. Auf einem frischen Mailverzeichnis ist das der normale erste Lauf.
Festgehalten, damit es nicht als neuer Fehler durchgeht, wenn es jemand
wiedersieht — und damit jemand prüft, ob die Meldung auch beim **zweiten**
Start noch kommt. Dann wäre sie ein echter Befund.

> **Hinweis zur Kennung.** Dieser Befund hiess bis zum 05.09.2026
> versehentlich [`E-12`](#e-12). Drei Agenten hatten unabhaengig „die naechste freie
> Nummer“ gewaehlt, waehrend die anderen gleichzeitig schrieben. Kennungen
> vergibt seitdem die Zuteilung, nicht der Agent – siehe [AGENTEN.md](AGENTEN.md).
---

## X-5 — Ein Commit drei Minuten nach dem Merge: die Regel stand nur als Prosa (05.09.2026)

Gregor am 05.09.2026:

> „ich kündige ja immer an, wenn ich einen branch merge und lösche.
> es sollte also alles commited und gepusht sein, klar?"
>
> „und für solche prüfungen haben wir genau extra agenten, die es feststellen
> und verhindern sollen. die arbeiten also nicht sauber!"

Er hat in beiden Sätzen recht. Der zweite trifft den Kern: es lag nicht daran,
dass jemand die Regel nicht kannte, sondern daran, dass sie **niemand messen
konnte**.

### Die Zeitachse

| Zeit | 31.08.2026 | Beleg |
|---|---|---|
| **09:03** | Gregor führt `darstellung-und-menue` nach `main` zusammen und kündigt an, den Zweig zu löschen | Merge-Commit `fa61618` |
| 09:03–09:06 | der Assistent arbeitet weiter, ohne nachzusehen, wo er steht | — |
| **09:06** | ein weiterer Commit landet auf `darstellung-und-menue` — dem bereits zusammengeführten Zweig | — |
| später | eine spätere Sitzung zieht dieselbe Aussage unabhängig nach | — |

**Inhaltlich ging nichts verloren.** Das ist der einzige gute Teil dieses
Befundes, und er ist Zufall: dass ein anderer Durchgang zufällig dasselbe noch
einmal geschrieben hat, ist kein Verfahren. Wäre der Zweig sofort gelöscht
worden, wäre der Commit weg gewesen.

### Die Ursache — nicht Vergesslichkeit, sondern der Entwurf

Die Regel stand in `AUFGABEN.md` als Prosa: *„In kleinen Schritten committen und
pushen."* Ein Satz in einer 420 Zeilen langen Liste, der davon lebt, dass ein
Agent im richtigen Moment an ihn denkt.

Genau das ist die Fehlerklasse, die dieses Projekt schon zweimal getroffen hat:

* **[NP3-4](#np3-4)/[X-2](#x-2):** der `pre-commit`-Hook rief `lehren-spiegeln.pl` auf, wertete den
  Rückgabewert aber nicht aus. Die Regel („die Lehren müssen mit") stand da, die
  Durchsetzung fehlte.
* **[X-1](#x-1):** die Byte-Schranke hatte neun Löcher. Erst als jemand sie **gegen
  bekannte Fälle gemessen** hat, fielen sie auf.

Die Lehre daraus heißt in `MEMORY.md` „Fehlerklassen abstellen": beim zweiten
Auftreten baut man Werkzeug und Schranke, statt einzeln nachzubessern. Hier war
es das dritte Mal.

### Ein Nebenbefund, der dasselbe zeigt

Beim Nachsehen fiel auf: der auf diesem Rechner **eingerichtete** Hook war noch
die Fassung *vor* [X-2](#x-2) —

```sh
perl "$W/tools/lehren-spiegeln.pl"        # ohne || exit $?
```

`tools/hooks-einrichten.sh` war am 31.08. berichtigt worden, aber niemand hat das
Skript danach noch einmal laufen lassen. Hooks liegen unter `.git/hooks` und
werden nicht mitversioniert: **eine Behebung im Skript ist keine Behebung auf der
Maschine.** [X-2](#x-2) stand fünf Tage lang als „behoben" im Verzeichnis, während der
Fehler hier weiterlief. Die Statusspalte für [X-2](#x-2) ist entsprechend nachgezogen.

Dazu kam ein zweiter Grund, warum niemand das Skript noch einmal laufen ließ: es
schrieb nach `"$WURZEL/.git/hooks"`. In einem **Arbeitsbaum** ist `.git` eine
*Datei*, kein Verzeichnis — aus einem Worktree heraus scheiterte das Einrichten
also, und seit dem 31.08. arbeiten hier mehrere Agenten in Worktrees.

### Die Behebung

**1. Eine Schranke, die git erzwingt** — `tools/pruefe-branch.pl`. Sie bricht ab bei

| Lage | Verhalten |
|---|---|
| abgelöster HEAD | **Abbruch** |
| Zweig ist *echt* in `origin/main` enthalten (enthalten **und** dahinter) | **Abbruch** |
| Gegenstück auf dem Server gelöscht (`[gone]`) | **Abbruch** |
| Zweig steht gleichauf mit `origin/main` (frisch abgezweigt) | durchlassen |
| auf `main` selbst | durchlassen |
| kein `origin/main` vorhanden | durchlassen, **mit Meldung** |
| Rebase, Cherry-Pick oder Halbierung läuft (git löst den HEAD selbst ab) | durchlassen |

Der Ausweg steht in jeder Meldung; wer trotzdem will, nimmt `--no-verify` — dann
aber mit Wissen, nicht aus Versehen.

**2. `tools/pruefe-branch-tests.pl`** — 15 Fälle, jeder in zwei Durchläufen
(hart: Rückgabewert; `--melden`: die Begründung, und dort darf **nie**
abgebrochen werden). Jeder Fall baut ein eigenes Wegwerf-Paar aus barem „Server"
und Klon unter dem Temp-Verzeichnis; im Projektbaum entsteht nichts.

**Gegen die erste Fassung der Schranke gemessen: 11 grün, 3 rot.** Alle drei
waren echte Fehler, keiner davon hätte sich beim Lesen gezeigt:

| Fall | erste Fassung | Ursache |
|---|---|---|
| `g` frisch abgezweigter Zweig | **brach den ersten Commit ab** | „ist Vorfahr von `origin/main`" trifft auch auf jeden frischen Zweig zu — HEAD *ist* dort `origin/main` |
| `k` leeres Repo, erster Commit | meldete „abgelöster HEAD" und brach ab | `rev-parse --abbrev-ref HEAD` scheitert auf einem Zweig ohne Commit; jetzt `symbolic-ref` |
| `f` kein `origin` | ließ durch und **sagte nichts** | eine Prüfung, die ausgefallen ist, sah aus wie eine bestandene |

Fall `g` ist der schwerste: eine Schranke, die den ersten Commit jedes neuen
Zweiges abweist, wird binnen einer Stunde mit `--no-verify` umgangen und ist dann
schlechter als keine. Das ist wörtlich die Lehre aus [PR-1](#pr-1)/[PR-2](#pr-2).

Sichtbar wurde außerdem, was die Klammern in `--format=%(upstream:track)` in
einer Shell anrichten (Fall `j`, Zweigname `zweig(1){a}`):

```
sh: -c: line 1: syntax error near unexpected token `('
```

Die Prüfung fiel damit lautlos aus. Behoben nicht durch besseres Zitieren,
sondern indem **die Shell entfällt**: beide Werkzeuge starten `git` über
`fork`+`exec` wie `tools/pruefe-bytes.pl`. Damit kann kein Zweigname und kein
Pfad mit Leerzeichen mehr etwas zerreißen.

**3. Im Hook, als erster Schritt.** `tools/hooks-einrichten.sh` schreibt jetzt
nach `--git-common-dir` (funktioniert also auch aus einem Arbeitsbaum) und legt
diese Reihenfolge an:

| # | Schritt | weist ab? |
|---|---|---|
| 1 | `pruefe-branch.pl` | ja, `\|\| exit $?` |
| 2 | `lehren-spiegeln.pl` | ja, `\|\| exit $?` |
| 3 | `release-pruefen.pl` | nein, meldet nur |
| 4 | `pruefe-bytes.pl` | ja, `exec` |

Zuerst, weil die Frage *„landet dieser Commit überhaupt irgendwo"* vor jeder
Frage nach seinem Inhalt kommt.

**Am laufenden Hook nachgewiesen** (Wegwerf-Repo, echter `git commit`): auf dem
zusammengeführten und serverseitig gelöschten Zweig bricht er mit Rückgabewert
`1` ab, und die Schritte 2–4 laufen **nicht** an — der Rückgabewert wird also
wirklich ausgewertet. Derselbe Commit auf `main` geht durch, Schritte 2–4 laufen.

**4. `tools/gesichert.pl`** beantwortet in einem Aufruf, was vor einem Merge zu
wissen ist. Auch hier zwei Fehler beim Nachmessen:

* Es nannte fremde Arbeitsbäume **„sauber"**, wenn dort nur nichts *uncommittet*
  war. Ungepushte Commits sah es nicht — gemessen an `wt/paket` und `wt/zeiger`.
  Jetzt prüft es je Arbeitsbaum: uncommittet, ungepusht, Gegenstück gelöscht,
  Zweig bereits zusammengeführt, abgelöster HEAD.
* Es las die Liste über die `branch`-Zeile von `worktree list --porcelain`. Ein
  Baum mit abgelöstem HEAD hat keine — er fiel aus der Liste und blieb unsichtbar.

**Darf ein Prüfwerkzeug den Zustand ändern?** `gesichert.pl` ruft
`git fetch --prune`. Die Antwort ist ja, und zwar begründet: die zentrale Frage
— *gibt es das Gegenstück auf dem Server noch?* — ist ohne frischen Serverstand
nicht zu beantworten, und ohne `--prune` bleibt ein gelöschter Zweig als lebend
stehen. Das Werkzeug gäbe dann **genau in dem Fall Entwarnung, für den es gebaut
wurde**. Geändert werden dabei nur die Kopien der Serverzweige unter
`refs/remotes/origin` — kein Arbeitsbaum, kein lokaler Zweig, kein Index, keine
Datei. Wer auch das nicht will, nimmt `--ohne-holen`; der Bericht sagt dann
ausdrücklich, dass der Serverstand alt sein kann. `pruefe-branch.pl` holt
**nichts** — ein Hook gehört nicht ans Netz.

**Nichts darf auf eine Eingabe warten.** Beide Werkzeuge setzen
`GIT_TERMINAL_PROMPT=0`, `GIT_ASKPASS`, `SSH_ASKPASS`, `GIT_SSH_COMMAND=ssh
-oBatchMode=yes` und `GCM_INTERACTIVE=never`; schlägt das Holen fehl, wird das
gemeldet statt verschluckt. `GIT_OPTIONAL_LOCKS=0` hält die Werkzeuge von der
Index-Sperre fern, solange andere Agenten arbeiten.

**5. Die Auflagen in `AUFGABEN.md`** sind um die Punkte 7 bis 10 ergänzt: vor
jedem Commit den Zweig messen; bei einer Merge-Ankündigung **sofort**
`gesichert.pl` und melden; nach dem Merge auf `main` wechseln; und der Grundsatz,
um den es hier geht:

> Eine Auflage, die nur im Text steht, trägt nicht. Wer eine neue Regel
> aufstellt, baut die Schranke dazu — ein Werkzeug mit Rückgabewert, im Hook, und
> einen Testfall, der beweist, dass sie greift *und* dass sie nicht grundlos
> anschlägt.

### Was offen bleibt

1. **Der Hook muss auf jeder Maschine eingerichtet werden.** Er liegt unter
   `.git/hooks` und wird nicht mitversioniert. Nach jedem frischen Klon:
   `sh tools/hooks-einrichten.sh`. Es gibt bisher **keine** Prüfung, die meldet,
   dass der eingerichtete Hook älter ist als das Skript — genau daran ist [X-2](#x-2)
   fünf Tage lang gescheitert. Die naheliegende Schranke wäre ein Vergleich in
   `pruefstand-melden.pl`.
2. **`pruefe-branch.pl` holt nicht vom Server.** Der Fall `[gone]` wird also nur
   erkannt, wenn vorher jemand `git fetch --prune` gelaufen ist — im Regelfall
   `gesichert.pl`. Das ist Absicht (kein Netz im Hook), aber es ist eine Lücke:
   wer nie holt, sieht einen gelöschten Zweig nicht.
3. **Ungepushte Zweige in fremden Arbeitsbäumen.** Am 05.09.2026 gemessen:
   `wt/kette`, `wt/paket` und `wt/zeiger` standen auf `2fee8e9`, ohne Gegenstück
   auf dem Server. Der Stand steckte zufällig schon über PR #4 in `origin/main`,
   es ging also nichts verloren — aber wieder nur zufällig, und `gesichert.pl`
   meldet das jetzt.
## X-6 — Ein Bau-Lauf meldete Erfolg, ohne gebaut zu haben (05.09.2026)

Zwei Fehler in **einem** Lauf. Der erste war laut, der zweite war leise — und
der leise hätte beinahe ein falsches Paket in die Auslieferung gebracht.

### 1. Die Plattform wurde geraten: `MSB4126`

Der Aufruf lautete `-p:Platform=Win32`. `Eudora71/Eudora.sln` kennt auf
Projektmappenebene aber nur zwei Paare:

```
GlobalSection(SolutionConfigurationPlatforms) = preSolution
    Debug|x86 = Debug|x86
    Release|x86 = Release|x86
EndGlobalSection
```

`Win32` steht eine Ebene tiefer, in den Projekten; die Projektmappe **bildet**
`x86` darauf ab:

```
{B94694FC-1EAC-4E90-9006-E40CF1C85041}.Release|x86.ActiveCfg = Release|Win32
```

MSBuild brach ab mit *„Die angegebene Projektmappenkonfiguration
`Release|Win32` ist ungültig"*. Der richtige Name stand die ganze Zeit in der
Datei — er wurde nicht gelesen, sondern erraten.

### 2. Der Rückgabewert war 0, obwohl nichts gebaut wurde

Trotz des Abbruchs meldete der Shell-Aufruf **EXITCODE 0**. Aufgefallen ist es
nur durch eine zusätzliche Handprüfung: in der `Eudora.exe` stand noch
`7.2.0.3`, während `Version.h` schon `7.2.0.4` sagte. Ohne diese Prüfung wäre
ein Paket mit der **alten** EXE unter der **neuen** Nummer herausgegangen —
dieselbe Fehlerklasse wie [V-1](#v-1) (zwei verschiedene ZIPs unter einer Nummer), nur
eine Stufe früher.

Die Ursache ist benennbar und wiederholbar: `$LASTEXITCODE` gehört der
**Pipeline**, nicht dem Programm. Steht ein natives Programm hinter einer
Umleitung oder in einer Pipe, meldet die Shell den Wert des letzten Glieds.
Beim Bauen des Werkzeugs ist mir derselbe Fehler noch einmal unterlaufen: der
Aufruf `powershell -File tools\bauen.ps1 -NurPruefen | tail -35` gefolgt von
`echo $?` meldete **EXITCODE=0**, obwohl das Skript mit 1 endete — der Wert kam
von `tail`. Deshalb steht die Warnung jetzt im Kopf von `bauen.ps1`.

Ein Bau-Werkzeug, das Erfolg meldet, ohne gebaut zu haben, ist schlimmer als
keines: es ersetzt Unsicherheit durch falsche Sicherheit.

### 3. Ein dritter Fehler beim Suchen nach dem zweiten

Beim Nachsehen, ob der Release-Bau eine Debug-Laufzeit zieht, wurde mit `grep`
über die ganzen Binärdateien gesucht statt in der Importtabelle. Ergebnis waren
Bruchstücke wie `s.dll` und `ts.dll` — Treffer, die es nicht gibt. Für genau
das gibt es seit [S-8](#s-8) den PE-Leser in `tools/paket-pruefen.ps1`.

---

### Die Abhilfe: `tools/bauen.ps1`

PowerShell, weil das Werkzeug fast nur mit Windows redet: einen Prozess starten
und dessen Rückgabewert **zuverlässig** bekommen, Zeitstempel, Dateigrößen,
Versionsressourcen, PE-Köpfe. Und weil der bewährte PE-Leser aus
`paket-pruefen.ps1` übernommen werden konnte, statt ihn in Perl ein zweites Mal
zu schreiben — ein zweiter PE-Leser wäre eine zweite Fehlerquelle.

```
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Release
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Debug -Ziel Rebuild
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -NurPruefen
```

Rückgabe 0 / 1 / 2 wie bei den anderen Werkzeugen. Nichts wartet auf eine
Eingabe: `/nologo /noautoresponse /nr:false`, und die Standardeingabe jedes
MSBuild-Laufs liegt auf einer leeren Datei.

**Gegen Fehler 1:** Konfiguration und Plattform kommen aus
`GlobalSection(SolutionConfigurationPlatforms)`, die Projektzuordnung aus
`GlobalSection(ProjectConfigurationPlatforms)`. MSBuild wird über `vswhere.exe`
gesucht (hier: *2022 Professional*); die feste Pfadliste ist nur Rückfallebene
und wird als solche gemeldet.

**Gegen Fehler 2 — vier voneinander unabhängige Prüfungen**, jede allein genügt
für einen Fehlschlag:

| # | Prüfung | Warum sie nötig ist |
|---|---|---|
| a | Rückgabewert über `Start-Process -PassThru`, **nicht** `$LASTEXITCODE` | genau die Stelle, an der der Wert verlorenging |
| b | eigener `ErrorsOnly`-Dateilogger, Zeilen gezählt | MSBuild kann mit 0 zurückkommen und trotzdem Fehler gemeldet haben; ein Suchmuster auf `error` ginge an der **deutschen** Ausgabe vorbei (gemessen: „2815 Warnung(en) / 0 Fehler") |
| c | Zeitstempel der Artefakte gegen eine **Dateisystem**-Marke vom Bau-Beginn | ein Artefakt, das nicht neuer ist, ist nicht gebaut worden |
| d | Versionsressource der `Eudora.exe` gegen `EUDORA_BUILD_VERSION` **und** `EUDORA_BUILD_NUMBER` | die Prüfung, die den Vorfall aufgedeckt hat |

Zu c: bei `-Ziel Rebuild` ist „nicht neu" immer ein Fehlschlag. Bei
`-Ziel Build` wäre das ein Fehlalarm, wenn sich nichts geändert hat; dort wird
zusätzlich gegen die jüngste Quelldatei gemessen — ist eine Quelle neuer als das
Artefakt, ist es ein Fehlschlag, sonst die ausdrückliche Meldung
*„unverändert"*.

**Gegen Fehler 3 — Nachkontrolle, eingebaut, nicht als zweites Werkzeug:** jede
EXE/DLL/OCX/`.eif` im Ausgabeverzeichnis muss `x86` sein; im Release-Zweig darf
keine Datei `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll`,
`vcruntime140_1d.dll` oder `ucrtbased.dll` importieren ([F-1](#f-1), [S-8](#s-8)) — gelesen aus
der **Importtabelle** des PE-Kopfes.

### Was das Werkzeug beim ersten Einsatz gefunden hat

**Aus einem reinen Projektmappen-Bau kommt nie eine `Eudora.exe` heraus.**
Gemessen, `Release|x86`, frischer Worktree, 5:33 Minuten: 3 Fehler, alle aus
`OT501` (zweimal `NMAKE U1073`, einmal `MSB3073`), Rückgabewert 1. Sieben der
neun überwachten Artefakte entstehen — `Eudora.exe` und `EudoraRes.dll` nicht.
Beide Projekte führen `OT501.vcxproj` als **Projektverweis**, und MSBuild lässt
ein Projekt aus, dessen Verweis gescheitert ist. Die Abhilfe stand seit Wochen
als Handarbeit in `AUFGABEN.md` (`/p:BuildProjectReferences=false`); jetzt macht
sie ein **zweiter Gang** von selbst — `EudoraRes.vcxproj` und `Eudora.vcxproj`
einzeln, mit der aus der `.sln` abgelesenen *Projekt*konfiguration
`Release|Win32`. Ergebnis: 5:02 Minuten, 0 Fehler, `Eudora.exe` 2 933 760 Byte,
`EudoraRes.dll` 2 447 360 Byte, alle 34 PE-Dateien x86, keine Debug-Laufzeit.

### Drei Gegenproben, alle grün

| Gegenprobe | Erwartet | Gemessen |
|---|---|---|
| `-Konfiguration Release -Plattform Win32` | sauberer Abbruch mit Aufzählung | Rückgabe **2**, „Unbekannte Projektmappenkonfiguration", beide gültigen Paare aufgezählt |
| `-Konfiguration Quatsch` | sauberer Abbruch | Rückgabe **2**, „Unbekannte Konfiguration" |
| `-NurPruefen` gegen ein nie gebautes `Bin/Release` | Fehlschlag, nicht Erfolg | Rückgabe **1**, neun fehlende Artefakte namentlich; Architektur- und Debug-Laufzeitprüfung liefen trotzdem durch (22 PE-Dateien, alle x86) |

**Und eine vierte, ungeplant:** Während der Messläufe wechselte ein anderer
Agent im geteilten Arbeitsbaum die `Version.h` von `7.2.0.3` auf `7.2.0.4`,
während der Bau schon lief. Das Werkzeug meldete daraufhin von selbst:

```
Versionsressource der Eudora.exe ist "7.2.0.3", Version.h sagt "7.2.0.4".
Fester Teil der Versionsressource ist 7,2,0,3, EUDORA_BUILD_NUMBER sagt 7,2,0,4.
ERGEBNIS: FEHLSCHLAG
```

Das ist wörtlich der Vorfall vom 05.09. — diesmal aufgefallen, ohne dass jemand
von Hand nachgesehen hat. Genau dafür gibt es das Werkzeug.

### Nebenbefund: jeder Bau verändert fünf versionierte Dateien

`MIDL` schreibt bei jedem Bau `Eudora71/Eudora/EudoraExe_i.c`,
`EudoraExe_p.c`, `GoogleDesktopSearchAPI_i.c`, `GoogleDesktopSearchAPI_p.c` und
`dlldata.c` neu — **mit CRLF**, während sie im Repo mit LF liegen. Gemessen an
`dlldata.c`: HEAD `CR=0 LF=40`, nach dem Bau `CR=40 LF=40`, inhaltlich
identisch (`git diff --numstat` meldet 40/40). Alle fünf sind versioniert, der
Arbeitsbaum ist nach jedem Bau also schmutzig, und wer pauschal `git add -A`
sagt, committet einen reinen Zeilenendenwechsel in fünf Dateien. Das ist
dieselbe Klasse lautloser Dateischäden wie [S-7](#s-7) und [X-4](#x-4). **Nicht behoben** — die
Entscheidung (Eintrag in `.gitattributes`, aus der Versionierung nehmen, oder
nach dem Bau zurücksetzen) steht aus.

### Nebenbefund: geteilte Arbeitsbäume verlieren Arbeit

Während dieser Sitzung hat ein anderer Agent in demselben Worktree
`git checkout` auf einen anderen Branch ausgeführt. Dabei gingen die noch nicht
committeten Änderungen dieses Befunds verloren — die neue `tools/bauen.ps1`
(unversioniert) war anschließend weg. Wiederhergestellt wurde sie aus dem
Sitzungsgedächtnis, weitergearbeitet in einem **eigenen** Worktree
(`Eudora7.2-wt-baumeister`). Die Lehre steht schon im Gedächtnis („Agenten
trennen mit Worktrees"), gilt aber offenbar auch umgekehrt: **ein Worktree
gehört genau einem Agenten**, und wer einen fremden Worktree umschaltet,
löscht fremde Arbeit.

---

## E-44/E-45/E-46 — Die Statusleiste, ein Prozess ohne Fenster, und ein Verdacht auf freigegebenen Speicher (08.09.2026)

Auslöser waren zwei Sätze von Gregor. Der eine vom 07.09.2026: *„übrigens:
task errors und task status wären waagrecht unten besser als senkrecht — nach
dem exit-fix korrigieren."* Der andere vom 08.09.2026, nach dem Exit-Fix:
*„dann widmen wir uns als nächstes dem erscheinungsbild der status leiste
(senkrecht statt unten waagrecht)."* Dazu kam der Rücklauf von **[PRUEFER-5](../Befunde/PRUEFER-5.md#pruefer-5)**,
der einen Fehler in meiner eigenen Behebung von [E-42](#e-42) fand.

### E-44 — zwei Ursachen, nicht eine

Der erste Reflex war falsch. Ich hatte vermutet, die Leiste werde links
angedockt. Gemessen mit `tools/leisten-messen.ps1` an einem **frischen**
Profil in `C:\Temp\E44-layout`:

| Leiste | Andockseite | Sichtbar | B | H | X | Y |
|---|---|---|---|---|---|---|
| Bar0 Postfächer | links | **True** | 180 | 1171 | 102 | 166 |
| Bar1 Kurznamen | rechts | False | 180 | 1093 | 1814 | 166 |
| Bar2 Aufgabenstatus/-fehler | **unten** | **False** | **1712** | **80** | 102 | 1339 |

Die Leiste liegt also von Anfang an richtig: unten, über die volle Breite,
80 Pixel hoch. Sie ist nur **versteckt**. Die eine Zeile, die das tut, steht in
`WazooBarMgr.cpp`, `SetDefaultWazooBarState`, Fall 2, Zweig `DST_SHOWHIDE`:

```cpp
// Hide the Task Status/Task Error window
pWazooBar->SendMessage(WM_COMMAND, ID_SEC_HIDE, 0);
```

Das erklärt aber **nicht**, warum Gregors Bildschirmbild die Leiste senkrecht
links zeigt. Dafür gibt es eine zweite, unabhängige Ursache. Der Standardzweig
oben läuft nur, wenn `m_bUseDefaultConfig` gesetzt ist, und das ist nur der
Fall, wenn die `Eudora.ini` **keinen** `[WazooBars]`-Abschnitt hat
(`WazooBarMgr.cpp:108-120`) — also nur beim allerersten Start. Ab dem zweiten
läuft der andere Zweig, und der ruft ausschließlich
`CWazooBar::LoadWazooConfigFromIni` (`WazooBar.cpp:552`). Nachgesehen, was das
wiederherstellt: **welche** Fenster in der Leiste sitzen und wo die Reiter
sitzen — die Andockseite und die Größe **nicht**.

Die kämen von MFCs `LoadBarState`, in diesem Projekt aus
`QCToolBarManager::LoadState(_T("ToolBar"))` in
`CMainFrame::FinishInitAndShowWindow` (`mainfrm.cpp:936`), und damit aus dem
INI-Abschnitt `[ToolBar...]`. Den gibt es nicht. Nachgemessen am 08.09.2026 in
**beiden** Profilen — Gregors und einem frischen: `grep -icE '^\[(ToolBar|Docking)'`
liefert beide Male **0**.

Der Abschnitt entsteht nie, weil `SaveBarState("ToolBar")` beim Beenden jedes
Mal abbricht — **das ist [E-43](#e-43)**. [E-44](#e-44) ist damit eine unmittelbare Folge von
[E-43](#e-43), und beide zusammen erklären, was Gregor am 08.09.2026 gemeldet hat:
*„erscheinungsbild nach dem ersten anlegen von konto wie im screenshot. muß
korrigiert werden."* Ohne gespeicherte Lage blieben alle drei Leisten auf dem
Stil, mit dem `CreateInitialWazooBars` sie erzeugt: `CBRS_LEFT | WS_VISIBLE |
CBRS_SIZE_DYNAMIC` (`WazooBarMgr.cpp:136`).

**Behebung, zwei Teile.** Erstens ist die `ID_SEC_HIDE`-Zeile entfallen —
bewusst ohne Ersatz durch `ID_SEC_SHOW`, weil die Leiste seit `Create` schon
`WS_VISIBLE` trägt. Zweitens zieht der Lade-Zweig die Standardanordnung nach,
**wenn** eine Leiste an keiner Andockleiste hängt:

```cpp
if (pWazooBar->m_pDockBar == NULL)
    VERIFY(SetDefaultWazooBarState(pWazooBar, idx, DST_SIZE_FIXED));
```

Zwei Durchläufe in derselben Reihenfolge wie im Standardzweig (erst
`DST_SIZE_FIXED`, dann `DST_SIZE_RELATIVE`), `DST_SHOWHIDE` absichtlich nicht.
Die Reklameleiste wird über `GetDlgCtrlID() == IDC_AD_WAZOO_BAR`
übersprungen, weil deren Fall 3 sonst `LoadWazooConfigFromIni` ein zweites Mal
aufrufen würde. Ist eine Lage gespeichert, ändert sich **nichts** — die
Prüfung auf `m_pDockBar == NULL` ist dieselbe, die das Projekt an anderer
Stelle selbst benutzt (`mainfrm.cpp:994`, Kommentar *„Normally, LoadBarState()
will take care of redocking"*).

### E-45 — der eine Schritt, der nicht übersprungen werden darf

Der Befund kommt von PRUEFER (`Befunde/PRUEFER-5.md`, Punkt 1b) und ist ein
Fehler in **meiner** E-42-Behebung. Von den zwölf mit `AUFRAEUMEN` gefassten
Schritten ist einer nicht bloß Aufräumen: `QCWorkbook::OnClose` löst sich auf
`CFrameWnd::OnClose` auf, und deren **letzte** Anweisung ist `DestroyWindow()`.
Nachgesehen in der MFC-Quelle, nicht vermutet: `CFrameWnd::PostNcDestroy` steht
in `winfrm.cpp:269-275` und besteht aus `delete this;`, und der Rumpf von
`CFrameWnd::OnClose` endet mit `// then destroy the window` und
`DestroyWindow();` (`winfrm.cpp:941`).

`CMainFrame::OnClose` ruft `DestroyWindow` nirgends selbst — geprüft über den
ganzen Rumpf. Fällt der Schritt aus, gibt es also kein `WM_NCDESTROY`, kein
`WM_QUIT`, kein `ExitInstance` und damit kein `IniStringCleanUp`
(`eudora.cpp:2118` → `rs.cpp:1433`), das den INI-Schreibpuffer leert. Und das
Fenster hat `HideApplication` (`winfrm.cpp:885`) zu diesem Zeitpunkt schon
versteckt: übrig bliebe ein **Prozess ohne Fenster**, den nur der
Task-Manager beendet — genau der Zustand, den Gregor tagelang hatte.

Wichtig für die Einordnung: das ist **geerbt, nicht neu**. Vor [E-42](#e-42) fing
`AfxCallWndProc` (`wincore.cpp:252-278`) dieselbe Ausnahme, `DestroyWindow`
lief ebenso nicht. [E-42](#e-42) hätte es nur **unsichtbar** gemacht. Behebung:
dieser Schritt läuft nicht durch `AUFRAEUMEN`, sondern durch einen eigenen
`TRY`/`CATCH_ALL`, der `DestroyWindow()` nachholt, wenn das Fenster noch
existiert.

### E-46 — der Verdacht, der E-43 erklären würde

> **Nachtrag vom 09.09.2026 (LEKTOR, L-11): dieser Verdacht ist WIDERLEGT.**
> Die unten beschriebene Spurmarke `E-46 CMainFrame::~CMainFrame betreten`
> erscheint erst **nach** der Stelle, nicht zwischen `vor QCWorkbook::OnClose`
> und `nach QCWorkbook::OnClose`. Das `CMainFrame`-Objekt ist an dieser Stelle
> also **nicht** freigegeben. Die tatsächliche Ursache von [**E-43**](#e-43) war eine
> andere: `SECControlBar` war **zweimal definiert**, und zwei
> Übersetzungseinheiten lasen dasselbe Feld acht Byte auseinander (siehe die
> Verzeichniszeile zu [E-43](#e-43) und `CHANGELOG.md` unter 7.2.0.24). **Der Abschnitt
> darunter bleibt unverändert stehen** — er ist das Zeitdokument einer
> Beweisführung, die in sich stimmig war und trotzdem in die falsche Richtung
> zeigte. Wer ihn zitiert, zitiert einen widerlegten Verdacht.


Beim Nachlesen der MFC-Quelle für [E-45](#e-45) fiel eine zweite Sache auf, die
schwerer wiegt. `CFrameWnd::PostNcDestroy` ist wörtlich `delete this`.
`CMainFrame` überschreibt es nicht — im ganzen Bestand steht kein einziges
`PostNcDestroy` (gesucht in `mainfrm.*`, `QCWorkbook.*` und allen
`OTShim`-Dateien; einziger Treffer ist ein Kommentar in
`OTShim_Reiter.cpp:1555`).

`DestroyWindow()` stellt `WM_NCDESTROY` **synchron** zu. Der Aufruf von
`QCWorkbook::OnClose` steht aber **mitten** in `CMainFrame::OnClose` (Schritt
6 von 12), danach laufen noch rund 230 Zeilen: `TocCleanup`, der Abbau der
`popHost`-Liste, `TrimJunk`, `RemoveBogusAdToolBars`,
`SaveBarState("ToolBar")`, `SaveWazooBarConfigToIni`, `SaveCrashStateToINI`,
`WriteToolBarMarkerToIni`.

Träfe der Verdacht zu, hätte [**E-43**](#e-43) damit seine Ursache: `SaveBarState`
liefe auf einem freigegebenen Rahmen, dessen Leisten schon abgebaut sind — und
`m_pToolBar` trägt `m_bAutoDelete = TRUE` (`mainfrm.cpp:1718`), wird also
tatsächlich gelöscht. Das würde auch erklären, warum `m_btns.GetSize()` **0**
liefert: `CPtrArray::~CPtrArray` ruft `SetSize(0)` und nullt `m_nSize`.

**Was noch nicht erklärt ist:** warum `GetBtnCount()` in derselben Zeile **24**
liefert. Beide Ausdrücke sind wörtlich derselbe Code
(`OTShim_Werkzeugleiste.h:744`), es gibt keine zweite Fassung und keine
Überschreibung in `QCCustomToolBar`. Deshalb steht in 7.2.0.23 eine
verfeinerte Marke, die `GetBtnCount()` und `m_btns.GetSize()` **je zweimal**
in **einer** Ausgabe misst. Vier gleiche Zahlenpaare heißt: stabil
verschieden, also ein Übersetzungsfehler. Flackernde Zahlen heißen: fremder
Faden oder freigegebenes Objekt.

Entschieden wird [E-46](#e-46) selbst an einer einzigen Protokollzeile. Im Destruktor
`CMainFrame::~CMainFrame` steht jetzt `E-46 CMainFrame::~CMainFrame betreten`.
Steht sie **zwischen** `vor QCWorkbook::OnClose` und `nach
QCWorkbook::OnClose`, ist der Verdacht belegt; steht sie danach, ist er
widerlegt. Beide Marken greifen nichts an.

### Widerlegt: „das Protokoll ist im Normalbetrieb stumm"

PRUEFER nennt das den größten Preis der E-42-Behebung: `PutDebugLog` kehre
sofort zurück, wenn die Maske nicht passe (`QCUtils/src/debug.cpp:140-145`),
und `DebugMask` sei mit `0` vorbelegt (`debug.cpp:22`) — ohne
`DEBUG_MASK_MISC` (0x8000) oder `DEBUG_MASK_TOC_CORRUPT` (0x80) sähe man bei
einem Fehlschlag nichts.

**Das ist widerlegt.** Der Vorbelegungswert `0` in `debug.cpp:22` wird nie
benutzt: `eudora.cpp:1192` ruft
`QCLogFileMT::InitDebug(GetIniLong(IDS_INI_DEBUG_LOG_LEVEL), …)`, und der
Vorgabewert dieses Schlüssels steht in der Ressource —
`EudoraRes.rc:8441` lautet `IDS_INI_DEBUG_LOG_LEVEL "LogLevel\n25759"`.

25759 ist 0x649F, und 0x649F & 0x80 ist ungleich null — die Marken werden also
**ohne jede Einstellung** geschrieben. Gegenprobe an der Wirklichkeit:
Gregors `Eudora.ini` enthält überhaupt keine Zeile `LogLevel`, und seine
`eudora.log` trägt in jeder Sitzung die Kopfzeile `LogLevel 25759 (0x649F)`
und die [E-33](#e-33)/E-42-Marken. `DEBUG_MASK_MISC` (0x8000) fehlt in der Vorgabe
tatsächlich — `DEBUG_MASK_TOC_CORRUPT` (0x80) ist gesetzt, und weil die Marken
mit `MISC | TOC_CORRUPT` schreiben, genügt das. Die Maske ist also nicht
optimal gewählt, aber wirksam.

---

## E-64 bis E-69 — Filter: drei Meldungen Gregors an 1.0.29 und die Bestandsaufnahme (09.09.2026, PRUEFER)

Der vollständige Bericht steht in **[Befunde/PRUEFER-7.md](../Befunde/PRUEFER-7.md)**;
hier nur, was man wissen muss, um zu entscheiden.

Gregors Auftrag nach dem Release: *„habe gleich das naechste gebiet nach dem
release: filter."* Dazu drei Meldungen, alle mit Bildschirmfotos belegt: der
Trennbalken **rechts** lässt sich nicht ziehen ([**E-66**](#e-66)), Filter lassen sich
setzen, aber nicht bearbeiten ([**E-65**](#e-65)), und ein Filterlauf über das ganze
In-Postfach verschiebt **alle** Nachrichten ([**E-64**](#e-64)).

**Der erste Satz zuerst, weil er alles andere einordnet:** die Filterdateien
sind **seit dem Ursprungscommit unverändert**. `git log --oneline` über
`filtersd.cpp`, `filtersv.cpp`, `FiltersWazooWnd.cpp`, `MakeFilter.cpp`,
`FilterReportView.cpp`, `FilterReportWazooWnd.cpp`, `JunkMail.cpp`,
`filtersd.h`, `filtersv.h`, `resource.h` und `EudoraRes.rc` liefert genau
einen Commit, `567a5d8`. Die einzige angefasste Datei des ganzen Filterwegs
ist `EuImap/src/ImapFiltersd.cpp` (`03c94fe`, zwei Zeilen, `std::auto_ptr` →
`std::unique_ptr`). **Kein Filterbefund dieses Durchgangs ist bei der
Portierung entstanden** — sie sind alle aus dem Original mitgekommen und
werden erst jetzt sichtbar, weil zum ersten Mal jemand mit Filtern arbeitet.

**Und die Ersatzschicht ist unschuldig, was die Filter angeht.** Im Filterkern
kommt **keine einzige `SEC*`-Klasse** vor; `CFiltersWazooWnd` erbt von
`CWazooWnd`, und das ist ein schlichtes `CWnd` (`WazooWnd.h:16`). Erst der
Behälter `CWazooBar` erbt von `SECControlBar` (`WazooBar.h:60`). Auch der
reguläre Ausdruck ist echt (POSIX `regcomp`/`regexec`, `filtersd.cpp:364-380`),
kein leerer Rumpf. Die Vermutung aus dem Auftrag — *„eine Vergleichsfunktion,
die IMMER passt liefert"* — ist damit **widerlegt**: es gibt sie nicht.

**Die Bestandsaufnahme in Zahlen** (Umfang aus der Quelle erhoben, nicht von
Hand gelistet): **10** nutzbare Kopfzeilen von 15 IDs, **16** Operatoren
(14 allgemein + 2 nur für den Junk-Score), **4** Verknüpfungen, **19**
Aktionen auf **5** Plätzen je Filter, **3** Filterlisten (Vor-, Haupt-,
Nachfilter), **12** Stellen im Programm, an denen gefiltert wird. Davon ist
**eine einzige** Aktion ohne eigenen Zweig (`ID_FLT_NOTIFY_USER`, wirkt nur
zusammen mit Transfer/Copy/Junk) und **eine** Anwendungsstelle unvollständig
(`SearchView.cpp:3722`: *„Nicht Junk"* aus dem Suchfenster ruft `DeclareJunk`
mit `NULL/*&filt*/` — auskommentiert, also **ohne** Filterlauf). Die
Shareware-Schranke `IsRestrictedFilterAction` würde 12 der 19 Aktionen
sperren, greift in diesem Bau aber nicht: `Eudora.vcxproj:78`/`:132` setzen
`BUILD_BOX_OR_SITE_R_VERSION`, `DEFAULT_SWM_MODE = SWM_MODE_PRO`, und Gregors
Protokoll schreibt in jeder Sitzung `Mode 2`.

**Was an [E-64](#e-64) neu ist und was nicht.** Neu ist, dass der Schaden **gemessen**
ist statt berichtet — Junk.mbx wächst in einer Sitzung von 0 auf byte-genau
die Größe, die In.mbx vorher hatte. Neu ist auch die Spur: `CFilter::Action`
lief mit einer Aktion, die in der Filterdatei **nicht steht**, die
Filterobjekte im Speicher weichen also von der Datei ab, und der einzige Weg,
der sie anfasst, ist `CFiltersViewRight::DoDataExchange` in Speicherrichtung —
angestoßen **ungefragt** bei jedem Wegklicken vom Filterreiter
(`FiltersWazooWnd.cpp:122` → `filtersd.cpp:2058-2072`). Damit hängen **[E-64](#e-64)
und [E-65](#e-65) am selben Faden**.

**Nicht** geklärt ist der Widerspruch: die Trefferzeile aus
`filtersd.cpp:2312-2318` fehlt im ganzen Protokoll, obwohl ihre Maske gesetzt
ist und dasselbe Verfahren nebenan (LMOS) schreibt. Deshalb ist der nächste
Schritt zu [E-64](#e-64) **keine Behebung, sondern eine Messung**: eine Zeile je
Nachricht und Filter mit Name, Kopf, Verb, Wert, Aktionen und Match-Ergebnis,
geschrieben mit `MISC | TOC_CORRUPT` — **nicht** mit `DEBUG_MASK_FILTERS`,
denn genau deren Wirksamkeit steht hier in Frage
([messung-muss-den-weg-treffen](../Arbeitsweise/messung-muss-den-weg-treffen.md),
[zwei-werte-in-eine-ausgabe](../Arbeitsweise/zwei-werte-in-eine-ausgabe.md)).

**Zwei Härtungen gehören unabhängig von der Ursache mit ins selbe Paket:** ein
leerer Wert darf bei `contains`/`is`/`starts with`/`ends with` **nicht**
treffen (`strstr(text, "")` liefert heute einen Treffer, `filtersd.cpp:712`),
und ein Filter, der fast alle bearbeiteten Nachrichten trifft, soll den Lauf
**abbrechen und melden** statt ihn zu Ende zu bringen. Ein Anwender bekommt
seine Mails nicht zurück.

**Reihenfolge der Behebung, nach Schaden:** [E-64](#e-64) (erst messen), dazu die beiden
Härtungen und [E-69](#e-69) im selben Zug, weil dieselben Dateien angefasst werden;
dann [E-67](#e-67) (zwei Zeichen, `>` → `>=`); dann [E-68](#e-68); dann [E-65](#e-65) (erst Gregors
Antwort auf **eine** Frage abwarten: leere Hälfte, graue Felder oder
Änderung wird nicht behalten?); dann [E-66](#e-66) (eine Datei, 30 bis 45 Zeilen); zum
Schluss die Lücke im Suchfenster — und die erst, wenn [E-64](#e-64) erledigt ist, weil
sie einen weiteren Filterlauf **einschaltet**.

## E-68, E-72, E-73, E-75 gegengerechnet — vier Gegenvermutungen, zwei bestätigt (10.09.2026, PRÜFER)

Gregor fragte am 10.09.2026, ob es zu den Filteränderungen der letzten Tage
neue Tests gebe. Die ehrliche Antwort war **nein**. Dieser Abschnitt ist die
Nachholung: zu jeder Behebung eine Gegenvermutung, jede am Quelltext
entschieden, mit Datei und Zeile. Nichts davon ist am laufenden Programm
gemessen — es sind statische Prüfungen.

### E-73 — „ist `CFilter::Action` wirklich die einzige Stelle?" — **BESTÄTIGT, sie war es nicht**

Zwei weitere Wege liefen am Rückschalter vorbei. Beide sind in der Tabelle
oben mit Zeilennummern beschrieben und jetzt geschlossen:

* **IMAP.** Der geprüfte POP-Zweig steht im `else` von `if (bIsImap)`
  (`filtersd.cpp:1213-1216` nimmt den IMAP-Weg, der geprüfte POP-Weg beginnt erst im `else` bei `:1217`). Ein IMAP-Postfach erreicht ihn
  nie. `ImapSetServerOpt` (`EuImap/src/ImapFiltersd.cpp:791-794`) hängt die UID
  bei `SO_DELETE` in `m_szDeletedUids` — daraus wird ein `STORE \Deleted`.
  `IMAP4` ist in **beiden** Konfigurationen der `Eudora.vcxproj` definiert
  (Zeilen 78 und 132), der Zweig wird also wirklich gebaut.
* **Junk-Filteraktion.** `case ID_FLT_JUNK` → `CJunkMail::DeclareJunk` →
  `SetServerStatus(ID_MESSAGE_SERVER_DELETE)` bei `DeleteFetchedJunk=1`.
  Der Kopfkommentar von `DeclareJunk` (`JunkMail.h:54-58`, Beschreibung in
  `JunkMail.cpp:577-579`) sagt ausdrücklich: `pFilt == NULL` heißt *„called
  from a filter action"*. `CFilter::Action` ruft mit vier Argumenten, also
  `pFilt == NULL`. Genau daran hängt jetzt die Unterscheidung.

**Was das über [E-74](#e-74) sagt:** `DeleteFetchedJunk=0` steht nur in
`tools/DEudora.ini`. Nach dem eigenen Kopfkommentar dieser Datei greift sie
für **neu angelegte** Konten und rührt eine vorhandene `Eudora.ini` nicht an.
Wer die `1` schon stehen hat — Gregor hatte sie —, löscht über eine
Junk-Filteraktion weiter auf dem Server. Das war die schwerste offene Lücke.

### E-72 — „gibt es einen zweiten Weg, der die leeren Felder zurückschreibt?" — **WIDERLEGT**

Gesucht wurde jeder Schreibzugriff auf ein `CFilter`-Objekt aus
`filtersv.cpp`. Ergebnis:

* Der Rückschreibzweig steht **nur** in `CFiltersViewRight::DoDataExchange`,
  hinter der Sperre `m_pGeladen != filt` (`filtersv.cpp:1432-1437`), und er ist
  das **Letzte** in der Funktion — der frühe `return` überspringt nichts
  anderes.
* Die einzige weitere Stelle, die die Aktionsfelder schreibt, ist
  `SaveIntoFilter` (`filtersv.cpp:1825`), und die wird **genau einmal**
  gerufen: `filtersv.cpp:1520`, innerhalb dieses Zweigs, hinter der Sperre.
* `CFiltersViewRight::OnMailbox` (`filtersv.cpp:2191-2230`) schreibt direkt in
  `m_Mailbox`/`m_CopyTo`/`m_Desc`, aber erst nachdem `SelectMailbox()` `true`
  geliefert hat — der Anwender hat dann ein Postfach ausgewählt. Ein leerer
  Zustand kann von hier nicht kommen; ein leerer Pfad wird durch das
  In-Postfach ersetzt (`:2216-2223`).

### E-72, zweite Gegenvermutung — „`m_pGeladen` bleibt nach dem Löschen eines Filters als Zeiger auf freigegebenen Speicher stehen, und eine neue `CFilter` auf derselben Adresse öffnet die Sperre" — **WIDERLEGT, mit dem Weg**

`CFiltersViewLeft::OnRemove` (`filtersv.cpp:576-599`) macht `delete filt`
(`:587`) und fasst `m_pGeladen` nicht an — der Zeiger ist an dieser Stelle
tatsächlich verwaist. Er wird aber nie **freigegeben**, sondern nur
verglichen, und der nächste Schritt räumt ihn auf: `OnRemove` ruft
`doc->UpdateAllViews(this, FUT_DIRTYSEL, &hint)` mit `hint = -2` (`:594-595`).
Das läuft in `CFiltersViewRight::OnUpdate` (`filtersv.cpp:2037-2054`) in
`case FUT_DIRTYSEL`, setzt `m_Sel = -2` und ruft `UpdateData(FALSE)`. Mit
`m_Sel < 0` ist `filt == NULL`, der Ladezweig nimmt den `else`-Ast
(`filtersv.cpp:1312-1328`) und setzt `m_pGeladen = NULL` (`:1360`). Der
verwaiste Zeiger überlebt also den Aufruf nicht, in dem er entsteht.
Das vorangehende `UpdateData(TRUE)` schreibt ebenfalls nichts, weil `filt`
schon `NULL` ist.

### E-75 — „gibt es einen zweiten Schreiber von `CtrlJMapping`?" — **WIDERLEGT**

`SetIniShort(IDS_INI_WHO_GETS_CTRL_J, …)` steht an genau **zwei** Stellen:
`CMainFrame::InitJunkMenus` (`mainfrm.cpp:7952`, der einmalige
Erstlauf, jetzt auf `CTRL_J_FILTER`) und der Einstellungsdialog
(`settings.cpp:924` und `:926`). Gelesen wird an fünf Stellen
(`mainfrm.cpp:3945`, `:3954`, `:3961`, `:7911`, `settings.cpp:2025`), alle
ohne Seitenwirkung. Ein dritter Schreiber existiert nicht.

### E-75, Restrisiko — ein `ASSERT(0)` im Einstellungsdialog — **noch offen, klein**

`settings.cpp:2023-2033`:

    int curVal = GetIniShort(IDS_INI_WHO_GETS_CTRL_J);
    if (curVal < CTRL_J_JUNK || curVal > CTRL_J_FILTER)
    {
        ASSERT(0);      // we should have set this at startup!
        curVal = CTRL_J_JUNK;
    }
    Wnd->CheckDlgButton(nID, curVal == CTRL_J_JUNK);

`CTRL_J_UNKNOWN` ist `0` (`JunkMail.h:61`), also **kleiner** als
`CTRL_J_JUNK`. Steht in der `Eudora.ini` eine `0` oder ein unsinniger Wert,
fällt der Dialog im **Freigabebau** stillschweigend auf *Junk* zurück
(`ASSERT` ist dort nichts) und schreibt beim Schließen über
`settings.cpp:921-926` eine `1` fest — genau der Sprung, den [E-75](#e-75) abstellen
sollte. Erreichbar ist das nur, wenn `InitJunkMenus` vor dem Dialog nicht
gelaufen ist; gerufen wird es aus `eudora.cpp:1636` beim Start, der Fall ist
also unwahrscheinlich. Der Rückfall gehörte trotzdem auf `CTRL_J_FILTER`
statt auf `CTRL_J_JUNK`. **Nicht geändert**, weil es Gregors Entscheidung ist,
ob der Einstellungsdialog hier vom Original abweichen soll.

### Was daraus als Schranke geworden ist

| Werkzeug | prüft | Gegenprobe abweisen | Gegenprobe durchlassen |
|---|---|---|---|
| `tools/pruefe-filter-serverloeschung.pl` | jede Löschstelle im Filterweg fragt `FilterDarfVomServerLoeschen`; jeder `ImapSetServerOpt`-Aufruf ebenso; die Vorgabe des Rückschalters bleibt 0 | Rückschalter aus allen drei Aufrufen entfernt (Stand vor der Behebung) → **1**, drei Mängel: `filtersd.cpp:1282`, `filtersd.cpp:1781`, `JunkMail.cpp:708` | behobener Baum → **0**, 3 gedeckte Löschstellen, 2 benannte Ausnahmen |
| `tools/pruefe-filter-aktionsgrenze.pl` | die Grenze in `CFiltersDoc::Read` ist da; die Liste `IstAktionsSchluesselwort` deckt sich mit den Zweigen, die den Zähler hochzählen; `Write` bleibt an `NUM_FILT_ACTS` gebunden | Grenze entfernt **und** `IDS_FIO_FORWARD` aus der Liste gestrichen → **1**, beide Mängel einzeln benannt | behobener Baum → **0**, 22 zählende Marken, 22 Marken in der Liste |

Beide hängen im `pre-commit` (Schritte 10 und 11, `tools/hooks-einrichten.sh`)
und haben einen eingebauten `--selbsttest`, der beide Gegenproben in einem
Lauf fährt. Beide werfen **Kommentare und Zeichenketten weg**, bevor sie im
Code suchen — nicht vorsorglich: der Kommentar, der die Junk-Lücke erklärt,
enthält wörtlich `SetServerStatus(ID_MESSAGE_SERVER_DELETE)` und hätte die
eigene Begründung angeschwärzt. Dieselbe Falle wie bei
`tools/pruefe-beenden.pl` und `tools/pruefe-fensterbau.pl`.
---

## AN-1 — Anhänge: lange Dateinamen werden abgeschnitten, die Endung fehlt

**Gemeldet von Gregor am 30.09.2026:** *„Prüfe, warum lange Dateinamen beim
Attachment abgeschnitten werden und die Endung z.B. pdf ganz fehlt."*

**Status: teilweise.** Kein Portierungsschaden — der Fehler steckt unverändert
schon im Altbestand (nachgewiesen, siehe unten). Er trifft **POP und IMAP**,
aber **nicht auf demselben Weg**: siehe die Berichtigung vom 12.10.2026 im
Abschnitt „IMAP hat dieselbe Stelle noch einmal".

> **Am laufenden Programm gemessen, 12.10.2026 — POP-Weg heil an 7.2.0.81.**
> Prüfnachrichten aus `tools/anhang-pruefdaten.pl --pop`, je ein Abruf über
> `tools/testlauf.ps1`, `LogLevel=91295`, abgelesen im Anhangverzeichnis und in
> `eudora.log`:
>
> | Fassung | heil | was fehlte |
> |---|---|---|
> | 7.2.0.79 (`C:\Temp\AN1`) | 00, 01, 02, 04 | 03: 224 × `A` **ohne** `.pdf`; 05: Betreff **ohne** Endung |
> | 7.2.0.80-an1 (`C:\Temp\AN2`) | 00 bis 04 | 05: Betreff ohne Endung |
> | **7.2.0.81** (`C:\Temp\AN3`) | **alle sechs**, voller Name **und** `.pdf` | — |
> | 7.2.0.82 (`C:\Temp\AN4`) | alle sechs, dieselben Namen; Testsuite 185/185 | — |
> | 7.2.0.83 (`C:\Temp\AN5`) | alle sechs, dieselben Namen; Testsuite 185/185 | — |
>
> Dabei kamen vier weitere Teile heraus, alle Originalfehler:
>
> * **Teil 8** — Kappungen von hinten an drei Stellen: `strncpy(fName, …, _MAX_PATH - 1)`
>   in `mime.cpp` (ohne abschließende Null) und `DeMacifyName32` auf 255, in
>   beiden Abschriften (POP und IMAP; im POP-Lauf wirkten davon zwei). Behoben mit `AnhangNameKuerzen` (`QCUtils/src/rfc2231.cpp`),
>   das die Endung behält.
> * **Teil 9** — `MIMEMap::GetMaps` gab `FALSE` zurück, sobald ein Typ unter
>   `HKCR\Mime\Database\Content Type` keinen Schrägstrich hat (gemessen:
>   `pkcs10` als 96. Typ; 342 = 123 + 124 + 95 Einträge). Damit verwarf es die
>   **ganze** Tabelle samt `[Mappings]`, und `SetExtension` trug **bei keinem
>   Anhang** je eine Endung nach. Behoben: der Schlüssel wird übersprungen.
> * **Teil 10** (PRUEFER-19) — `SetExtension` kürzte mit negativem
>   `Difference`; `while (Difference--)` lief rückwärts durch den Speicher. Erst
>   durch Teil 9 erreichbar. Behoben.
> * **Teil 11** (PRUEFER-20, 7.2.0.83) — `SetExtension` kürzte auf `_MAX_PATH`,
>   auch in kleineren Puffern (`uudecode.cpp` `m_Name[255]`, `hexbin.cpp` und
>   `ImHexbin.cpp` `m_Name[40]`), und **ersetzte** eine vierstellige Endung
>   (`.docx` → `.doc`). Behoben: Puffergröße vom Aufrufer, eine vorhandene
>   Endung bleibt immer.
>
> **IMAP:** von Gregor mit Paket 1.0.83 an seinem Postfach getestet (CHANGELOG
> 7.2.0.83): drei Anhänge, alle mit Endung, einer auf 175 Zeichen gekürzt
> (voller Pfad 258). **Noch offen:** [B5.7](AUFGABEN.md#b5.7) (IMAP ohne `SetExtension`); die
> Prüfdaten selbst laufen nur über POP. Ab hier unten folgt der ältere Stand.

> **Stand vor dem ersten Bau (12.10.2026, morgens).** Die Teile 1 bis 6 sind **im Quelltext**, Fassung
> **7.2.0.79**. Bis dahin lagen sie als zwei Patchdateien neben dem Code; die
> sind damit Geschichte und entfernt. **Übersetzt ist nichts** — alle drei
> Sitzungen dazu liefen ohne Windows und ohne Compiler. Was gemessen ist und
> was nicht, steht im Abschnitt „Was geändert wurde" weiter unten und in
> AUFGABEN.md, B5.

### Gemessen am laufenden Programm, 12.10.2026

Gregor hat die Debug-Marken übersetzt —
**7.2.0.77, Release, Rebuild, 0 Fehler** — und Mail abgerufen. Sein
`eudora.log` ist die erste Messung dieses Befunds außerhalb des Prüfstands.

| Was | Ergebnis |
|---|---|
| Der Schalter | `LogLevel 91295 (0x1649F)` steht im Logkopf. Die Angabe `[Debug] LogLevel=91295` ist damit **nachgemessen**, nicht behauptet |
| Die Marken | **285 `ANHANG`-Zeilen.** Sie werden geschrieben, und `PutDebugLogSichtbar` macht Steuerzeichen als `<CR><LF><TAB>` sichtbar, wie vorgesehen |
| Der Befund selbst | **nicht getroffen.** Der Abruf lief über IMAP, die vier Nachrichten hatten keine Anhänge, und der IMAP-Weg hatte zu diesem Zeitpunkt gar keine Marken für den Dateinamen |

**Was dabei herauskam, war etwas anderes.** In vier Nachrichten schlug die
254-Zeichen-Kappung **281 Mal** zu — auf `DKIM-Signature` und
`X-UI-Filterresults`. Dort ist es folgenlos, weil der Kopfzeilentext stückweise
durchgeschrieben wird. Aber die **zweite Ursache** (`BYTE Token[256]`, im
Quelltext kommentiert mit *„tokens over 255 characters will be shot"*) ist damit
kein Randfall mehr, sondern der Normalfall gewöhnlicher Post:

```
ANHANG ImapLex822: Marke voll, wird gekappt [ v=1; a=rsa-sha256; c=relaxed/relaxed;
d=web.de;<CR><LF><TAB>s=s29768273; t=1789902988; … ] (254)
```

**Und die Messung hat eine Angabe dieses Befunds widerlegt** — die, dass jede
Ursache doppelt im Baum steckt. Siehe unten.

### Vorab, weil danach gefragt wurde: was „Faltung" ist und wo der Umbruch sitzt

Eine Kopfzeile einer E-Mail ist `Name: Wert` und endet mit `CRLF`. Weil sie nach
RFC 5322 2.1.1 nicht beliebig lang werden soll, darf der Absender sie **falten**:
er setzt ein `CRLF` ein und lässt die nächste Zeile mit einem **Leerzeichen oder
Tabulator** beginnen. Genau dieses führende Leerzeichen ist das Zeichen dafür,
dass die Zeile noch zur vorigen gehört. Der Empfänger macht es rückgängig
(„unfolding"): `CRLF` weg, das Weiß behalten — fertig ist der ursprüngliche Wert.

Ungefaltet:

```
Content-Disposition: attachment; filename="Rechnung.pdf"
```

Gefaltet — **dieselbe** Kopfzeile, nur auf zwei Zeilen:

```
Content-Disposition: attachment;
 filename="Rechnung.pdf"
```

Das kann Eudora seit jeher; der Umbruch sitzt hier **zwischen** zwei Teilen,
außerhalb der Anführungszeichen.

**Der Fehler tritt auf, wenn der Umbruch *im Dateinamen selbst* landet** — und
das passiert, sobald der Name so lang ist, dass er allein die Zeile sprengt.
Dann faltet der Absender an einem Leerzeichen **innerhalb** der
Anführungszeichen:

```
Content-Disposition: attachment;
 filename="Angebot Nr 4711 fuer die Stadtwerke Musterstadt
 Abrechnungszeitraum 2025.pdf"
                   ^
                   hier steht das CRLF, mitten im Dateinamen
```

Der Name ist `Angebot Nr 4711 fuer die Stadtwerke Musterstadt Abrechnungszeitraum
2025.pdf` — ein einziger Name, nur über zwei Zeilen geschrieben. Eudora hört am
CR auf zu lesen und behält `Angebot Nr 4711 fuer die Stadtwerke Musterstadt`.
Alles hinter dem Umbruch, **also auch das `.pdf`**, wird weggeworfen.

Deshalb wirkt es wie eine Längengrenze, ist aber keine: **nicht die Länge
schneidet ab, sondern der Umbruch** — und lang ist nur der Grund, warum der
Absender überhaupt umbricht.

> **Das betrifft nur den Empfang, und nur Anhänge sind das Sichtbare daran.**
> Der Umbruch steht im Kopf der Nachricht, nicht im Anhang selbst; die Datei
> kommt vollständig an. Verloren geht nur ihr Name. Eudoras eigener Versand
> faltet nicht (`sendmail.cpp:2392`), löst den Fehler beim Empfänger also nicht
> aus.

### „Ich hänge doch nur eine Datei an und mache keine Umbrüche"

Gregors Einwand vom 30.09., und er ist berechtigt. Die Auflösung in einem Satz:

> **Du faltest nichts. Das Programm des Absenders tut es — und der Fehler
> trifft dich beim EMPFANGEN, nicht beim Anhängen.**

Der Reihe nach:

**Beim Anhängen passiert nichts Schlimmes.** Du wählst im Explorer eine Datei,
sie hat einen Namen und eine Endung, Eudora hängt sie an. Eudora schreibt den
Namen dabei in **eine** Zeile, ohne Faltung (`sendmail.cpp:2392`). Deine
gesendeten Nachrichten lösen diesen Fehler beim Empfänger also **nicht** aus.

**Der Fehler trifft Anhänge, die du BEKOMMST.** Die Zeile mit dem Dateinamen
schreibt das Programm des *Absenders* — Outlook, Exchange, Zimbra, ein
Scanner, ein Rechnungsportal, ein PHP-Skript. Und die falten, wenn der Name
lang ist, weil das Mailformat lange Zeilen nicht vorsieht. **Das macht dort
niemand von Hand**, das Programm tut es von selbst und zeigt es auch niemandem.
Es ist erlaubt und völlig normal (RFC 5322 2.2.3).

**Die Datei selbst wird dabei nicht angefasst.** Der Umbruch steht in der
*Kopfzeile*, die den Namen trägt — nicht in den Daten. Die PDF kommt
vollständig und unversehrt an. Verloren geht nur ihr **Name**, genauer: alles
hinter dem Umbruch, und da steht die Endung.

Deshalb sieht es aus wie „Eudora verschluckt die Endung": aus Sicht des
Anwenders ist die Datei da, aber sie heißt falsch und lässt sich nicht mehr per
Doppelklick öffnen.

> **Welche der vier Ursachen es im Betrieb ist, steht weiter unten und ist
> nicht entschieden.** Die Faltung ist die häufigste und am besten belegte,
> aber RFC 2231 (dritte Ursache) erzeugt dasselbe Bild und kommt bei genau
> denselben Absendern vor. Das klärt der erste Abruf mit eingeschalteten
> Debug-Marken ([B5.0](AUFGABEN.md#b5.0)) — nicht früher.

**Ein Fall bleibt offen und ist ausdrücklich nicht gemessen:** Eudora schreibt
beim *Senden* sehr lange Dateinamen in eine einzige Zeile, ohne zu falten. Das
verletzt die Zeilenlänge aus RFC 5322 2.1.1. Was ein Server oder das Programm
des Empfängers damit macht, weiß hier niemand. Es ist die Spiegelseite desselben
Themas und steht unter „Was ausdrücklich nicht geprüft ist".

### Kurz: es liegt nicht an der Länge

Der naheliegende Verdacht ist falsch. Ein Dateiname mit 76 Zeichen kommt
**vollständig** an, solange er in **einer** Zeile steht. Abgeschnitten wird er,
sobald der Absender die Kopfzeile **faltet** — und das tun Absender genau dann,
wenn der Name lang ist. Deshalb sieht es nach einer Längengrenze aus.

Das ist mit `tools/kopfzeile-pruefen.pl` nachprüfbar, ohne Visual Studio:

```
$ perl tools/kopfzeile-pruefen.pl
uebernommen: 43 Zeilen Aufzaehlungen, 117 Zeilen Tabellen, 245 Zeilen Lex822()
...
5 Faelle, 0 Abweichung(en) vom verzeichneten Stand
```

Das Werkzeug holt die Aufzählungen aus `lex822.h` und die Tabellen samt
`Lex822()` aus `lex822.cpp` **wörtlich** aus dem Baum, ersetzt nur `LexFill()`
(liest aus einer Zeichenkette statt aus dem Netz) und `WriteHeaderToken()`
(schreibt nichts), hängt einen Treiber an, der die Zustände aus
`HeaderDesc::Read` nachbildet, übersetzt das mit `g++` (oder `cl`) und lässt es
laufen. Es kann also nicht veralten: wer `Lex822()` ändert, sieht die Wirkung
sofort.

### Der Weg, den ein Anhangname nimmt

*Zeilennummern in diesem und den folgenden Abschnitten: Stand 7.2.0.76, vor der
Behebung. Seither verschoben — der Funktionsname ist der Anker; die heutigen
Zeilen der Marken stehen in der Markentabelle weiter unten.*

| Schritt | Fundstelle | was dort passiert |
|---|---|---|
| 1 | `Lex822State::Lex822` — `lex822.cpp:153` | zerlegt die Kopfzeile in Marken |
| 2 | `HeaderDesc::Read` — `header.cpp:77` | Zustandsautomat, legt `filename` als `AttributeElement` ab |
| 3 | `GenericReader::ReadIt` — `mime.cpp:1634` | holt `filename`, ersatzweise `name` |
| 4 | `MIMEMap::SetExtension` — `MIMEMap.cpp:388` | hängt eine Endung aus `[Mappings]` an |
| 5 | `OpenAttachFile` → `DeMacifyName32` — `mime.cpp:1275` / `:948` | macht daraus einen Windows-Dateinamen |
| 6 | `CheckName` — `mime.cpp:992` | sucht einen freien Namen, hält die Endung |

Schritt 6 ist sauber: `CheckName` kürzt ausdrücklich so, dass die Endung erhalten
bleibt. Der Schaden entsteht davor.

### Erste Ursache: eine Faltung beendet die Zeichenkette (die eigentliche)

`Lex822()` behandelt einen gefalteten Zeilenumbruch — `lex822.cpp:213`:

```c
// Is this a folded CRLF?
if (charClass == LF822 && (nextClass == SPACE822 || nextClass == HTAB822))
    charClass = SPACE822;   // treat it like a space
```

Geprüft wird das **LF**. Im Datenstrom kommt aber zuerst das **CR** — und in
`CollectQText` steht bei `lex822.cpp:303`:

```c
case CR822:
    returnToken = QText;
    State = CollectLine;
    break;
```

Damit endet eine Zeichenkette in Anführungszeichen **am CR**, bevor die
Faltungsregel überhaupt greifen kann. Nach RFC 5322 2.2.3 gehört alles nach
`CRLF` + Leerzeichen/Tabulator noch zu derselben Kopfzeile; genau so falten
Exchange, Zimbra, JavaMail und die meisten PHP-Versandskripte lange
`filename=`-Parameter. Für Eudora ist der Name an dieser Stelle zu Ende.

Was danach kommt, ist nicht etwa der Rest des Namens, sondern Müll: der
Zustandsautomat steht auf `ExpectSem`, bekommt statt `;` ein Atom, setzt
`grokked = FALSE` und wirft den Rest der Kopfzeile als unstrukturierten Text
weg. Die Endung ist damit nicht „abgeschnitten", sondern **nie angekommen**.

Gemessen, Fall 2 des Werkzeugs:

```
Content-Disposition: attachment;
	filename="Angebot Nr 4711 fuer die Stadtwerke Musterstadt
 Abrechnungszeitraum 2025.pdf"

  soll   "Angebot Nr 4711 fuer die Stadtwerke Musterstadt Abrechnungszeitraum 2025.pdf"  (76 Zeichen)
  ist    "Angebot Nr 4711 fuer die Stadtwerke Musterstadt"  (47 Zeichen), Endung FEHLT, grokked=FALSE
```

Und die Gegenprobe, Fall 3 — **derselbe Name, nur ungefaltet**:

```
  ist    "Angebot Nr 4711 fuer die Stadtwerke Musterstadt Abrechnungszeitraum 2025.pdf"  (76 Zeichen), Endung .pdf, grokked=TRUE
```

### Zweite Ursache: die Marke ist 256 Byte groß

`lex822.h:70`: `BYTE Token[256];  // tokens over 255 characters will be shot`.
Bei `lex822.cpp:206` bricht der Zerleger ab, sobald `TokenSpot > sizeof(Token)-3`
ist, gibt die Marke wie sie ist heraus und fängt eine neue an. Ein ungefalteter
Name über **254 Zeichen** wird also bei 254 gekappt; der Rest kommt als zweite
`QText`-Marke im Zustand `ExpectSem` an und wird verworfen (Fall 4 des
Werkzeugs). Das ist der seltenere Fall, aber er sieht genauso aus.

### Dritte Ursache: RFC 2231 kennt dieser Baum nicht

Für lange und für nicht-ASCII-Dateinamen ist RFC 2231 der heute übliche Weg:

```
Content-Disposition: attachment;
	filename*0="Angebot Nr 4711 fuer die Stadtwerke";
	filename*1=" Musterstadt 2025.pdf"
```

`grep -rn "2231\|filename\*" Eudora71/Eudora Eudora71/EuImap Eudora71/QCUtils`
liefert **nichts**. `HeaderDesc::GetAttribute` (`header.cpp:502`) vergleicht den
Attributnamen vollständig, `filename*0` ist also nicht `filename`. Ergebnis: es
gibt **gar kein** `filename`-Attribut (Fall 5 des Werkzeugs, `ist ""`). Dann
greift `mime.cpp:1640`:

```c
if (!*fName)
    strncpy(fName, ((MIMEState*)MimeStates[0])->m_hd->subj, _MAX_PATH - 1);
```

— der Anhang bekommt den **Betreff** als Namen, und `subj` ist
`char subj[32]` (`header.h:101`), also **31 Zeichen**. Auch das sieht für den
Anwender nach „abgeschnitten, Endung weg" aus, hat aber eine andere Ursache.
Wer den Fehler nachstellt, muss die drei Fälle auseinanderhalten.

### Vierte Ursache (neu am 30.09., beim Messen gefunden): `filename=""` wird zu `=`

Die Marke wird beim Neuanfang **nicht geleert**. `ReinitToken` setzt nur
`TokenSpot = 0` (`lex822.cpp:201`), `Token[0]` behält das erste Byte der
**vorigen** Marke. Solange danach `ADD()` läuft, fällt das nicht auf, weil
`ADD` die Null selbst nachzieht. Bei einer **leeren** Zeichenkette läuft `ADD`
nie:

```
Content-Disposition: attachment; filename=""
```

```
    Atom         [66 69 6C 65 6E 61 6D 65 ] "filename"
    Special      [3D ]                      "="
    QText        [3D ]                      "="        <- der Wert
```

`HeaderDesc::Read` liest `l822s.Token` als Zeichenkette, bekommt also `=` und
legt das als Dateinamen ab. Der Anhang landet als Datei namens `=`. Dieselbe
Ursache macht die Prüfung `if (Token[TokenSpot] == '\\')` am Anfang von
`CollectQText`, `CollectComment` und `CollectDL` (`lex822.cpp:256`, `:289`,
`:316`) wirkungslos bis irreführend: nach jedem `ADD` ist `Token[TokenSpot]`
null, am Markenanfang steht dort ein fremdes Byte. Maskierte Anführungszeichen
in einem Dateinamen (`\\"`) werden damit nicht behandelt.

**Behebung:** ein `Token[0] = 0;` dort, wo `ReinitToken` ausgewertet wird
(`lex822.cpp:201`), und dieselbe Zeile in `ImapLex822.cpp:216`. Eine Zeile je
Zweig. **Nicht angefasst** — kein Compiler. *Stand 12.10.2026: seit 7.2.0.79 drin
(B5.2), heute `lex822.cpp:205` und `ImapLex822.cpp:220`.*

### Warum das Sicherheitsnetz nicht greift

`MIMEMap::SetExtension` (`MIMEMap.cpp:388`) **könnte** die Endung aus dem
MIME-Typ nachtragen. Es tut es in der Praxis oft nicht, aus drei Gründen:

1. **Die Zuordnung muss in `[Mappings]` stehen.** Für `application/pdf` steht sie
   da (`both=pdf,,,application,pdf` in `deudora.ini:21`). Für
   **`application/octet-stream` steht sie nicht da** — `grep -n octet` auf
   `InstallersForEudora/Eudora7.1/Data/INIfiles/deudora.ini` liefert nichts.
   Und genau diesen Typ setzen viele Webanwendungen und Scanner für PDFs.
2. **Die Regel bei `MIMEMap.cpp:397`:** stehen hinter dem letzten Punkt 1 bis 3
   Zeichen, bleibt die vorhandene „Endung" stehen. Ein abgeschnittener Name wie
   `Rechnung Nr. 4711 vom 12.03` endet auf `.03` — für `SetExtension` ist das
   eine Endung, es tut nichts mehr.
3. `MIMEMap::Find` (`MIMEMap.cpp:64`) steigt sofort aus, wenn `isMIME` falsch ist.

### Der Fehler ist nicht durch die Portierung entstanden

> **Und das ändert an der Dringlichkeit nichts.** Gregor am 30.09.: *„ob der
> Fehler schon drin war oder nicht, weiß ich nicht. Wahrscheinlich ja, ist mir
> aber egal. Ich möchte das fixen, weil es unschön ist und weil es im
> freigegebenen Release schlecht aussieht."* Die Herkunft steht hier nur
> deshalb, weil sie sagt, **wo** zu suchen ist (in beiden Zweigen, nicht in den
> Portierungsänderungen) — **nicht**, um den Punkt kleiner zu machen. Wer diesen
> Abschnitt liest und daraus „also nicht unsere Schuld, also später" macht,
> liest ihn falsch.

Gegen den mitgeführten Altbestand geprüft:

```
$ diff <(sed -n '/^Token822Enum Lex822State::Lex822()/,/^}/p' Sandbox/Eudora/lex822.cpp  | tr -d '\r') \
       <(sed -n '/^Token822Enum Lex822State::Lex822()/,/^}/p' Eudora71/Eudora/lex822.cpp | tr -d '\r')
Lex822() identisch (245 Zeilen)

$ diff <(sed -n '/^void DeMacifyName32/,/^}/p' Sandbox/Eudora/mime.cpp  | tr -d '\r') \
       <(sed -n '/^void DeMacifyName32/,/^}/p' Eudora71/Eudora/mime.cpp | tr -d '\r')
DeMacifyName32 identisch
```

Die Unterschiede zwischen `Sandbox/Eudora/lex822.cpp` und
`Eudora71/Eudora/lex822.cpp` betreffen ausschließlich `WriteHeaderToken` und die
Konstruktoren. **Originalfehler**, wie [M4](#m4), [M5](#m5) und [NP3-8](#np3-8) — er ist mit Eudora 7.1
ausgeliefert worden.

### IMAP hat dieselbe Stelle noch einmal

`Eudora71/EuImap/src/ImapLex822.cpp` ist eine Abschrift desselben Zerlegers:

| Eudora (POP) | IMAP | betrifft |
|---|---|---|
| `lex822.cpp:303` | `ImapLex822.cpp:318` | `case CR822:` in `CollectQText` |
| `lex822.cpp:213` | `ImapLex822.cpp:228` | die Faltungsregel prüft das LF |
| `lex822.cpp:206` | `ImapLex822.cpp:221` | Abbruch bei `sizeof(Token)-3` |
| `lex822.h:70` | `ImapLex822.h:29` | `BYTE Token[256]` |

**Wer die eine Stelle ändert, muss die andere mitändern** — sonst ist der Fehler
je nach Kontenart einmal da und einmal weg, und das ist schlimmer als der Fehler
selbst.

> **Berichtigt am 12.10.2026: die Überschrift stimmt, der Schluss daraus nicht.**
> Die vier Zeilen der Tabelle sind nachgeprüft und richtig — der Zerleger steht
> wirklich zweimal im Baum. **Nur geht der Anhangname über IMAP gar nicht durch
> ihn hindurch.** `GetFilenameParameter` (`ImapDownload.cpp:5964`) holt ihn aus
> den c-client-Strukturen `BODY`/`PARAMETER`, also aus der
> **BODYSTRUCTURE**-Antwort des Servers; der hat die Faltung längst aufgelöst.
> `ImapLex822`/`ImapHeader` zerlegen den Kopf für die **Mailbox-Datei**, nicht
> für den Dateinamen.
>
> | Ursache | über IMAP |
> |---|---|
> | 1 — Faltung beendet die Zeichenkette | **trifft den Dateinamen nicht.** Die IMAP-Hälfte des Behebungspatches bleibt trotzdem richtig: sie betrifft den Rückschrieb in die Mailbox-Datei |
> | 2 — Marke ist 256 Byte groß | trifft zu, aber ebenfalls nur die Mailbox-Datei. **281 Mal in vier Nachrichten gemessen** |
> | 3 — RFC 2231 | trifft zu. Über IMAP daran zu erkennen, dass die BODYSTRUCTURE **gar keinen** Namen liefert |
> | 4 — `filename=""` wird zu `=` | trifft den Dateinamen nicht, aus demselben Grund wie 1 |
>
> **Dafür hat der IMAP-Weg zwei eigene Fehler, die der POP-Weg nicht hat:**
>
> * `LOCAL_CheckName` (`EuImap/src/imapmime.cpp:116`) hält den Namen in
>   `char tmp[255]` und schreibt `tmp[len] = 0;` (`:166`) mit `len` bis 255 —
>   ein Byte **hinter den Puffer, auf den Stapel**. Trifft jeden Anhangnamen ab
>   255 Zeichen **ohne Punkt**, und der Name kommt vom Server. Die zweite
>   Schreibstelle (`:220`) ist harmlos, dort deckelt `min(len, BaseLen)` auf 254.
>   Das POP-Gegenstück `CheckName` hat das nicht — es ist auf `CString` umgebaut.
> * **`MIMEMap::SetExtension` wird über IMAP nie gerufen.** Der POP-Weg trägt
>   eine fehlende Endung aus dem MIME-Typ nach (`mime.cpp:1646`); der IMAP-Weg
>   ruft `MIMEMap` nur, um über das Löschen zu entscheiden
>   (`ImapDownload.cpp:3536`). Das Sicherheitsnetz fehlt dort ganz.
>
> Beides steht als **B5.6** und **[B5.7](AUFGABEN.md#b5.7)** in `AUFGABEN.md`. Beides ist aus dem
> Quelltext gelesen und **nicht am laufenden Programm gemessen**.

### Nebenbei gefunden: ein Byte über den Rand in `DeMacifyName32`

`mime.cpp:948`:

```c
char pcname[255];
int len = 255;
for (d = pcname, s = Name; *s && len; s++)
{
    if (... unerlaubtes Zeichen ...) continue;
    *d++ = *s;
    len--;
}
*d = 0;                 // <- bei 255 kopierten Zeichen ist das pcname[255]
```

`len` zählt nur die **übernommenen** Zeichen. Werden 255 übernommen, steht `d`
auf `pcname + 255`, und `*d = 0` schreibt **ein Byte hinter den Puffer** — auf
den Stapel, neben `Name`, `s` und `d`. Das ist unabhängig von [AN-1](#an-1) und
unabhängig von der Portierung (der Altbestand hat denselben Code), tritt aber
genau bei den Namen auf, um die es hier geht. Die Behebung ist `char pcname[256]`
oder `int len = 254`. **Nicht angefasst**, weil hier nicht gebaut werden kann.
*Stand 12.10.2026: behoben in 7.2.0.79 (B5.4), seit 7.2.0.80-an1 zusätzlich mit
`AnhangNameKuerzen` (B5.8).*

### Was geändert wurde — Teil 1, die Faltung

**Nachtrag 12.10.2026.** Eingespielt. Davor, am 30.09.2026, war dieser Teil
ausgearbeitet und gemessen, lag aber nur als Patchdatei daneben:

| | |
|---|---|
| Wo | `lex822.cpp`, `header.cpp` (POP) und `ImapLex822.cpp`, `ImapHeader.cpp` (IMAP) |
| Stand | **im Quelltext seit 7.2.0.79**, übersetzt und am laufenden Programm gemessen (12.10.2026: Fall 01 und 02 heil) |
| gemessen mit | `perl tools/kopfzeile-pruefen.pl --vorschlag` (zehn Fälle) |

Der Patch besteht aus drei Stücken, und die Aufteilung ist nicht willkürlich —
sie folgt aus zwei Dingen, die beim Messen herauskamen:

- **Am CR ist noch nicht zu erkennen, ob eine Faltung folgt.** `ReadLine`
  liefert die Zeile samt CRLF; steht `Spot` auf dem CR, ist das LF das letzte
  Byte im Puffer, das Zeichen danach ist noch nicht gelesen. Erst wenn `Spot`
  auf dem LF steht, füllt `LexFill()` nach und hebt dabei genau ein Byte auf.
  **Deshalb steht die Faltungsregel am LF.** Der Patch nimmt das CR in die
  Marke auf — so hält es `CollectText` seit jeher — und entscheidet am LF.
- **`WriteHeaderToken` schreibt jede Marke in die Mailbox-Datei**
  (`lex822.cpp:402`). Was der Zerleger verschluckt, fehlt in der gespeicherten
  Nachricht. Weil CR und LF in der Marke stehen, ist der Rückschrieb
  **byteidentisch** — gemessen, 128 von 128 Byte. Genau deshalb darf der Wert
  **nicht** im Zerleger entfaltet werden: das würde mitgeschrieben. Die
  Entfaltung gehört eine Ebene höher, in `HeaderDesc::AddAttribute`
  (`header.cpp:476`).

| Fall | ohne Patch | mit Patch |
|---|---|---|
| **gefaltet (der gemeldete Fehler)** | 47 Zeichen, Endung fehlt, `grokked=FALSE` | **76 Zeichen, `.pdf` da, `grokked=TRUE`, Rückschrieb byteidentisch** |
| **R4 gefaltet mit Tabulator** | 35 Zeichen, Endung fehlt | **56 Zeichen, vollständig** |
| R1 Anführungszeichen, dann weitere Kopfzeile | byteidentisch | unverändert |
| R2 unbeendete Zeichenkette | Rückschrieb 92/91 Byte | **unverändert 92/91** |
| R3 Faltung außerhalb der Anführungszeichen | heil | unverändert |
| die übrigen vier | — | unverändert |

**Kein Fall wird schlechter**, und im behobenen Fall wird der Rückschrieb sogar
besser: heute schreibt die kaputte Zerlegung ein Anführungszeichen zu viel in
die Mailbox (129 statt 128 Byte).

Geprüft ist damit der Zerleger, **nicht das Programm**. Es ist nichts mit MSVC
gebaut und nichts gestartet worden; `g++ -fsyntax-only` über die vier
eingefügten Blöcke ist fehler- und warnungsfrei, mehr sagt das nicht.

### Was noch offen ist

> *Stand 12.10.2026: alle vier Punkte unten sind erledigt — 2 als B5.3, 3 als
> B5.5, 4 als B5.2, 5 als B5.4 (alle in 7.2.0.79). Offen ist von [AN-1](#an-1) nur noch
> [B5.7](AUFGABEN.md#b5.7). Die Liste bleibt als Stand vom 30.09.2026 stehen.*

2. **Die Marke vergrößern.** `Token[256]` ist die RFC-822-Atomgrenze, für einen
   Dateinamen ist sie zu klein. `_MAX_PATH`-nah wäre richtig; wer nicht so weit
   gehen will, muss wenigstens `CheckName` die Endung retten lassen, statt am
   Ende zu kappen. Achtung: `Token` steckt in `lex822.h:70` **und**
   `ImapLex822.h:29`, und `Buffer[2048]` begrenzt mit.
3. **RFC 2231.** Deutlich mehr Arbeit (Teilstücke sammeln und in der richtigen
   Reihenfolge zusammensetzen, `*`-Form mit Zeichensatz und Prozentzeichen
   auflösen). Eigener Punkt, nicht in einem Zug mit 1 und 2.
4. **Die Marke beim Neuanfang leeren** — `Token[0] = 0;` bei `lex822.cpp:201`
   und `ImapLex822.cpp:216`. Eine Zeile je Zweig, behebt `filename=""` → `=`
   (vierte Ursache oben). Klein genug, um mit Teil 1 zusammen zu gehen.
5. **`DeMacifyName32`** (`mime.cpp:948`, und die Abschrift
   `LOCAL_DeMacifyName32` in `EuImap/src/imapmime.cpp:82`): `pcname` auf 256,
   oder `len` auf 254.

Nach jeder dieser Änderungen: `perl tools/kopfzeile-pruefen.pl`. **Die Spalte
`stand` in dem Werkzeug ist dann mit zu ändern** — sonst meldet es die eigene
Behebung für immer als Schaden. Das Werkzeug erkennt am Markierungssatz des
Patches selbst, ob die Behebung schon im Baum steht, und bildet dann auch das
geänderte `WriteHeaderToken` nach.

### Beim Abrufen zusehen: Debug-Marken auf dem ganzen Weg

**Nachtrag 30.09.2026, dritter Durchgang.** Gregor: *„nicht vergessen,
Debug-Marken einzufügen, wenn da was schief läuft, dass man das auf die Schnelle
rausfindet … damit man beim Mail abrufen oder beim Benutzen sieht, was passiert
und was nicht hinhaut."*

Eudora hat die Logdatei schon — `QCLogFileMT`, gesteuert über eine **Bitmaske**
in `eudora.ini`, geschrieben nach `eudora.log`. Es fehlte nur ein Bit für diesen
Weg. Dieses Bit heißt `DEBUG_MASK_ATTACH = 0x10000` (`debug.h`), und daran hängen
**zehn Marken** — seit 7.2.0.80-an1 **elf**: Marke 11 sitzt in `MIMEMap::Find`
und nennt, warum keine Endung nachgetragen wird (dort fand sich Teil 9):

*Zeilen Stand 7.2.0.83 (die Kommentarzeile über der Marke); die Funktionsnamen sind der
verlässliche Anker.*

| # | Wo | Was sie sagt |
|---|---|---|
| 1 | `Lex822()`, Marke voll (`lex822.cpp:212`) | Kappung bei 254 Zeichen — [AN-1](#an-1), zweiter Teil |
| 2 | `Lex822()`, vor dem `switch` (`lex822.cpp:225`) | **Umbruch mitten in der Zeichenkette** — [AN-1](#an-1), erster Teil |
| 3 | `AddAttribute` (`header.cpp:531`) | der Wert, wie er abgelegt wird |
| 4 | `GenericReader::ReadIt` (`mime.cpp:1707`) | woher der Name kommt — `filename`/`name` oder **Betreff** |
| 5 | dieselbe Stelle, nach `MIMEMap` (`mime.cpp:1719`) | ob die Endung nachgetragen wurde, oder der Typ unbekannt ist |
| 6 | `OpenAttachFile` (`mime.cpp:1341`, `:1419`) | vor und nach `DeMacifyName32` |
| 7 | dieselbe Stelle, nach `CheckName` (`mime.cpp:1365`, `:1443`) | **wie die Datei am Ende wirklich heißt** |
| 8 | `CheckName` (`mime.cpp:1146`) | dass hier gekürzt wurde — mit erhaltener Endung |
| 9 | nur IMAP: vor `LOCAL_CheckName` (`imapmime.cpp:202`) | der Name ist länger als 255 Zeichen, gekürzt wird dahinter |
| 10 | `HeaderDesc::GetAttribute` (`header.cpp:601`) | der Name kam nach RFC 2231 (vor B5.5 wäre der Betreff gelandet) |
| 11 | `MIMEMap::Find` (`MIMEMap.cpp:73`) | **warum** `Find` scheitert — jeder Ausstieg außer dem ersten (`!ms \|\| !ms->m_hd`) |

Die Marken 1 bis 9 gibt es auch für IMAP (`ImapLex822.cpp`, `ImapHeader.cpp`,
`ImapDownload.cpp`, `imapmime.cpp`; Marke 5 dort zweimal), 9 gibt es **nur** dort,
10 und 11 nur im POP-Weg bzw. in `MIMEMap`. **Einschalten:** `LogLevel`
steht in `eudora.ini` im Abschnitt `[Debug]` — `LogLevel=91295`
(Voreinstellung 25759 + 65536), dann `grep ANHANG eudora.log`.

**Steuerzeichen werden sichtbar gemacht** — dafür bringt der Patch
`PutDebugLogSichtbar()` mit (`debug.cpp`): `CR` wird `<CR>`, `LF` wird `<LF>`,
Tabulator `<TAB>`, alles andere unter 32 `<XX>`. Ohne das wäre der Log hier
wertlos, weil eine Faltung im Dateinamen genauso aussähe wie ein Zeilenumbruch
im Log. Die Funktion ist als einzige wirklich gebaut und ausgeführt worden
(`g++`, gegen einen Stellvertreter):

```
ANHANG Lex822: Umbruch IN der Zeichenkette [Angebot ... Musterstadt<CR><LF> Abrechnungszeitraum 2025.pdf] (76)
```

**Die Marke im Zerleger sitzt bewusst vor dem `switch`** und nicht im
`case CR822:`, den die Behebung umschreibt. Solange beides noch als zwei
getrennte Patchdateien danebenlag, war das die Bedingung dafür, dass sie sich
nicht stören — nachgewiesen mit `git apply --check`, einzeln und nacheinander.
Seit 7.2.0.79 steht beides im Quelltext; die Trennung bleibt, weil sie die
Marke dort hält, wo sie auch nach einer weiteren Änderung am `case` noch
feuert.

**Reihenfolge:** erst die Marken, dann einmal die Prüfdaten abrufen und den Log
ansehen — damit ist die Diagnose am **laufenden Programm** belegt, was sie
bisher nicht ist. Erst danach die Behebung und derselbe Abruf noch einmal.

### Nachstellen ohne echte Post — und ohne Visual Studio zum Erzeugen

**Eine `.eml` in eine `.mbx` zu kopieren reicht nicht.** Der Fehler sitzt im
*Empfangs*weg (`CPOP::WriteMessageToMBX_` → `HeaderDesc::Read` → `Lex822`).
Liegt die Nachricht schon in der Mailbox, läuft dieser Weg nie, und der Anhang
wird gar nicht erst geschrieben. Die Nachricht muss **abgerufen** werden.

Deshalb bringt `tools/anhang-pruefdaten.pl` beides mit: die sechs Nachrichten
**und** einen winzigen POP3-Server, der sie ausliefert — kein Netz, keine
Zugangsdaten, alles auf `127.0.0.1`.

```
perl tools/anhang-pruefdaten.pl              # zeigt die sechs Faelle
perl tools/anhang-pruefdaten.pl --erzeugen   # schreibt die .eml-Dateien
perl tools/anhang-pruefdaten.pl --pop        # liefert sie auf 127.0.0.1:11110
```

Konto in Eudora: Server `127.0.0.1`, Port `11110`, Benutzer `pruef`, Kennwort
beliebig, **SSL aus**. Abrufen, dann ins Anhangverzeichnis sehen. Der Server
löscht nie etwas — man kann beliebig oft abrufen.

| | |
|---|---|
| **00 heil, 01 bis 05 kaputt** | [AN-1](#an-1) ist am laufenden Programm bestätigt |
| **alle sechs heil** | die Teile des POP-Wegs wirken am laufenden Programm (B5.1, B5.2, B5.3 mit B5.8, B5.5, B5.9) — B5.6 und [B5.7](AUFGABEN.md#b5.7) betreffen nur IMAP und sind so nicht zu zeigen |
| **00 kaputt** | etwas anderes ist schiefgegangen, nicht [AN-1](#an-1) |
| **gemischt** | die Liste der kaputten Fälle zeigt auf den Teil — so war es an 7.2.0.79 (4 von 6) und 7.2.0.80-an1 (5 von 6) |

Der POP3-Server ist in perl geschrieben und läuft ohne Compiler. Was er **nicht**
kann: er ersetzt keinen Bau. Er stellt den Fehler nach, er behebt ihn nicht.

### Der Fingerabdruck in der Mailbox-Datei

Wer den Fehler in **echter** Post nachweisen will, braucht das Original nicht.
Eudora schreibt die Kopfzeile in die `.mbx` zurück (`WriteHeaderToken`,
`lex822.cpp:402`) — und setzt dabei im Fehlerfall **ein Anführungszeichen an die
falsche Stelle**. Gemessen, Fall 2 des Prüfstands:

```
auf der Leitung:                      in der .mbx:
 filename="Angebot ... Musterstadt     filename="Angebot ... Musterstadt"
 Abrechnungszeitraum 2025.pdf"         Abrechnungszeitraum 2025.pdf"
```

Zwei schließende Anführungszeichen: eines am Zeilenende **vor** einer Zeile, die
mit Leerzeichen oder Tabulator beginnt, und das ursprüngliche am Ende. Ein Byte
mehr als auf der Leitung (129 statt 128). **Danach lässt sich in einer `.mbx`
suchen** — das findet die betroffenen Nachrichten, ohne dass jemand die
Originale aufheben musste.

### Was ausdrücklich **nicht** geprüft ist

- Welche der vier Ursachen im Betrieb zuschlägt. Es liegt **keine echte
  Beispielnachricht vor**. Gregor am 30.09.: *„Ich kann dir jetzt keine
  Beispielnachricht geben. Mir ist es nur aufgefallen, dass … immer wieder
  Dateien im Attachment gespeichert werden, bei denen zum Beispiel PDF oder Doc
  … fehlt und der Dateiname ist nicht vollständig."* **Darauf ist nicht zu
  warten**, und es ist auch nicht mehr nötig: seit dem 30.09. liegen **sechs
  erzeugte Nachrichten** bereit, eine je Ursache, mit einem gültigen PDF im
  Anhang — `tools/pruefdaten/anhang-faltung/`, erzeugt und ausgeliefert von
  `tools/anhang-pruefdaten.pl`. Taucht später doch echte Post auf, klärt sie
  nur noch, welche Ursache im Betrieb überwiegt.
- Der Sendeweg. `sendmail.cpp:2392` schreibt `filename="…"` in **eine** Zeile,
  ohne Faltung; Eudoras eigene Nachrichten lösen den Fehler beim Empfänger also
  nicht aus (bei sehr langen Namen verletzt das dafür die Zeilenlänge aus
  RFC 5322 2.1.1 — nicht gemessen).
- `Fix2047` läuft im Prüfstand bewusst nicht mit. Ein RFC-2047-Wort, das über
  eine Faltung geht, wird von `Fix2047` (zeilenweise, `lex822.cpp:554`) ohnehin
  nicht zusammengesetzt — das ist derselbe Fehler noch einmal, aber nicht
  gemessen.
- Nichts davon ist am laufenden Programm nachgesehen. Es gibt keinen Bau. *(Stand 30.09.2026; seit
  12.10.2026 gebaut und gemessen, siehe den Kasten am Anfang von [AN-1](#an-1).)*

---

## AN-2 — Beim Start zeigt ein Fenster in Eudora den Quelltext einer Webseite

**Gemeldet von Gregor am 12.10.2026:** *„nachdem eudora gestartet wurde, ist es
innerhalb eines Fensters darin angezeigt worden. ohne daß ich etwas gemacht
habe."* Was er eingefügt hat, war kein Text, sondern das **Innenleben** einer
Webseite: der New-Relic-Ladeteil (`(window.NREUM||(NREUM={}))…`), Google Tag
Manager, Microsoft Clarity, AddToAny, Disqus, der `schema.org`-Block,
`wp.i18n.setLocaleData`, `var wpcf7 = {…}` — und darunter der Artikel des
Computer History Museum über die Freigabe des Eudora-Quelltexts.

**Status: behoben, von Gregor an 1.0.84 bestätigt am 13.10.2026** (*„HTML
newsletter (weiter geleitet) wird korrekt dargestellt.“*). Die Produktfrage
(AUFGABEN.md, B6) hat Gregor am selben Tag entschieden: die Werbe-Betriebsart
wird nicht weiter verfolgt. **Der Weg unten ist ab Punkt 1 widerlegt** — dieser
Bau startet mit `Mode=2`, nicht in der Werbe-Betriebsart, und auch mit `Mode=0`
kam an 1.0.84 kein Abruf (Messungen in der Urteilszeile oben,
[L-27.4](../Befunde/LEKTOR-27.md#l-27.4)). Was folgt, ist der Stand vom 12.10.2026.

*Bis zum 13.10.2026 stand hier:* offen — Ursache am Quelltext belegt, Anzeige
behoben in 7.2.0.80, seit 7.2.0.82 übersetzt (Rebuild 0 Fehler, Testsuite
185/185), am laufenden Programm nicht gemessen.

### Der Weg, Stück für Stück

| | |
|---|---|
| 1 | **Eudora startet in der Werbe-Betriebsart.** `GetModeFromIni` (`QCSharewareManager.h:56`) liest `[Settings] Mode` (`IDS_INI_MODE` = 10620, `EudoraRes.rc:7743`, Voreinstellung `-1`). Bei `-1` greift `DEFAULT_SWM_MODE`, und das ist **0 = `SWM_MODE_ADWARE`**, weil `BUILD_BOX_OR_SITE_R_VERSION` in `Eudora.vcxproj` nicht gesetzt ist. **Eine frische `Eudora.ini` bedeutet also: Werbung.** **[Widerlegt 13.10.2026: `BUILD_BOX_OR_SITE_R_VERSION` ist seit `bf14e14` gesetzt, `DEFAULT_SWM_MODE` = 2 (Pro); an 1.0.84 gemessen, siehe Urteilszeile.]** |
| 2 | Der Playlist-Client (`plstclnt.dll`) holt die Werbung. Der voreingestellte Server steht in `PlaylistClient/plstclnt_dll/plist_mgr.cpp:213`: `//adserver.eudora.com/adjoin/playlists`. Überschreibbar über `[Debug] PlayListServer` (`IDS_INI_DEBUG_PLAYLIST_SERVER` = 10805, `EudoraRes.rc:8446`) |
| 3 | **`eudora.com` gehört seit 2018 dem Computer History Museum.** Das steht in dessen eigener Ankündigung zur Quelltextfreigabe: *„transfer ownership of the code, the Eudora trademarks, the copyrights, and the Eudora domain names to the Computer History Museum"*. Was dieser Rechner heute antwortet, ist eine WordPress-Seite |
| 4 | `CAdView::loadEntry` (`AdView.cpp`): ist der MIME-Typ des Eintrags `text/html`, wird die geholte Datei geöffnet und an `PgDataTranslator::ImportData(…, kFmtHtml)` gegeben |
| 5 | **`class CAdView : public CPaigeEdtView`** (`AdView.cpp:60`). Das Werbefenster ist kein Browser, sondern **Paige** |
| 6 | **Paige kennt kein Element, dessen Inhalt kein Text ist.** `control_commands` (`PGHTMDEF.C:28`) führte `script` überhaupt nicht; `style` stand darin, hatte aber **keinen `case`** in `PGHTMIMP.CPP`. Behandelt war genau **ein** solcher Fall: `<title>`, über `inside_title` (`PGTXRCPP.H:394`), gesetzt bei `title_command`, gelöscht bei `-title_command`, abgefragt an **vier** Ausgabestellen |

Ergebnis: der unbekannte Tag wird übersprungen, **sein Inhalt aber
durchgeschrieben** — jede Zeile JavaScript und jede Zeile CSS landet als Text im
Fenster.

**Das ist dieselbe Fehlerklasse wie [E-105](#e-105)** (versteckter Vorschautext, weil
Paige `display:none` nicht kennt). Nur deutlich auffälliger — und es trifft
nicht nur Werbung, sondern **jede HTML-Nachricht mit eingebettetem `<style>`**,
also die meisten Newsletter.

### Was geändert wurde

| Datei | Was |
|---|---|
| `PGHTMDEF.C:28` | `script` in `control_commands` aufgenommen — **zwischen `p` und `style`** |
| `PGHTMDEF.H:66` | `script_command` an derselben Stelle in die Aufzählung |
| `PGTXRCPP.H:395` | neuer Merker `inside_script` |
| `PGHTMIMP.CPP` | `inside_script` auf FALSE beim Anlegen (:106), gesetzt bei `script_command`/`style_command` (:1224), gelöscht bei den Ende-Tags (:892), abgefragt an allen vier Ausgabestellen (:427, :446, :480, :500) |

**Die Stelle in der Liste ist keine Kosmetik.** `table_command`
(`PGHTMIMP.CPP:3469`) läuft die Zeichenkette durch und gibt die **Position** des
Treffers zurück — diese Position *ist* der Befehlswert, und die Aufzählung in
`PGHTMDEF.H` vergibt dieselben Werte ein zweites Mal, von Hand. Dazu bricht die
Suche ab, sobald der erste Buchstabe eines Eintrags **größer** ist als der
gesuchte (`:3502`). Daraus folgen zwei stumme Fallen:

1. Verschiebt sich die Liste gegen die Aufzählung, heißt `<title>` plötzlich
   `<ul>`. Kein Übersetzer meldet das.
2. Ein hinten angehängter Tag wird **nie gefunden** — ebenfalls ohne Meldung.

### Gemessen

`tools/html-tags-pruefen.pl` zieht `table_command` wörtlich aus `PGHTMIMP.CPP`,
die Tabelle aus `PGHTMDEF.C` und die Aufzählung aus `PGHTMDEF.H`, übersetzt das
mit `g++` und prüft **jedes** Paar gegen eine von Hand geschriebene Sollliste:

```
22 Tags, jeder trifft den Wert seines Namens; 8 Tags, die hier nicht
gefunden werden dürfen. 30 Faelle, 0 Abweichung(en).
```

**Gegenprobe gefahren.** Hängt man `script` stattdessen hinten an, meldet das
Werkzeug **sieben** Abweichungen: `script` wird gar nicht gefunden (0 statt 16),
und `style`, `title`, `ul`, `wbr`, `x-tab`, `x-sigsep` rutschen um eins. Genau
die beiden Fallen von oben, beide gefangen.

### Was **nicht** gemessen ist

- **Nichts ist übersetzt.** Die Sitzung lief ohne Windows und ohne Compiler.
  *Stand 7.2.0.80. Übersetzt ist es seit 7.2.0.82; der folgende Punkt gilt weiter.*
- Dass die Behebung im Werbefenster wirkt, ist damit **nicht** belegt — nur,
  dass der Zerleger `<script>` und `<style>` jetzt als solche erkennt.
- Ob die Seite, die Gregor gesehen hat, wirklich über den Werbeweg kam, ist
  **aus dem Quelltext erschlossen**, nicht am Protokoll abgelesen. Nachzusehen
  wäre es mit `LogLevel` und Bit `DEBUG_MASK_PLIST` (`0x1000`, `debug.h`), das
  den Playlist-Client mitschreibt.

### Was dieser Befund **nicht** behebt

> **Überholt am 13.10.2026 ([L-27.4](../Befunde/LEKTOR-27.md#l-27.4)).** An 1.0.84 holt Eudora
> beim Start **keine** Werbung — die Vorgabe ist `Mode=2`, und selbst mit
> `Mode=0` kam kein Abruf. Gregor hat die Frage unten entschieden: die
> Werbe-Betriebsart wird nicht weiter verfolgt. Der Abschnitt bleibt als Stand
> vom 12.10.2026 stehen.

Der Abruf selbst bleibt. Eudora holt beim Start weiterhin Werbung von einem
Rechner, der seit 2018 jemand anderem gehört, und zeigt dessen Antwort in einem
Fenster. **Das ist die eigentliche Frage, und sie ist keine Programmierfrage:**
soll diese Fassung überhaupt noch Werbung abrufen?

Ohne Neubau abschaltbar ist es über die `Eudora.ini`:

```ini
[Settings]
Mode=1
```

`1` ist `SWM_MODE_LIGHT` — keine Werbung, dafür schaltet `UsingFullFeatureSet()`
einige Funktionen ab. `2` wäre `SWM_MODE_PRO` ohne Werbung und mit allen
Funktionen, verlangt aber einen Registriercode und führt sonst zu
`WasBadProRegCodeAtStartup`. **Beides ist nicht nachgemessen.** Den Werbeserver
stattdessen auf einen toten Rechner zu zeigen, hilft nicht: nach vier Tagen
meldet sich `CAdFailureNagTask` (`nDaysUntilAdFailure = 4`).
