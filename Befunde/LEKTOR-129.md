# <a id="lektor-129"></a>LEKTOR-129 — Kurzlauf nach der Veröffentlichung von v7.2.1.131, Zweig release_7_2_1_131_doku nach 1f4b54de (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-128](LEKTOR-128.md#lektor-128).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102j`, abgezweigt von `origin/release_7_2_1_131_doku`, Stand `1f4b54de` (*„PAKETE: 'heute ist v7.2.1.131 Latest'“*).
Umfang nach Auftrag: **Kurzlauf**, keine Vollrunde — nur der Diff `7564f54e..1f4b54de` (zwei Commits, 7 Dateien, 14 Zeilen hinzu, 13 weg; `git diff --stat`, gemessen) gegen den Stand auf GitHub, dazu die Stand-Köpfe der geänderten Dateien und die Absätze, in denen die geänderten Zeilen stehen.

## Kurz

Was auf GitHub liegt, stimmt mit dem Repo überein (gemessen): `v7.2.1.131` ist *Latest*, die Marke steht auf dem Merge `7564f54e` von #204, das ZIP hat dieselbe Größe und SHA-256 wie in PAKETE eingetragen, der Release-Text ist zeichengleich mit `Releases/7.2.1.131/RELEASE-NOTIZEN.md`. **Die Nachträge sind aber nur halb gezogen:** Überschriften und Stand-Köpfe sagen „veröffentlicht“, die Sätze direkt daneben noch „nicht veröffentlicht“, „veröffentlicht wird nach seinem Ja“ und „zuletzt veröffentlicht 7.2.1.128“. `tools/pruefe-release-buchfuehrung.pl` meldet trotzdem grün. Drei Funde, keiner am Programm.

## GitHub gegen das Repo

| Prüfung | Ergebnis (gemessen) |
|---|---|
| `gh release view v7.2.1.131` | `isDraft: false`, `isPrerelease: false`, `publishedAt: 2026-11-02T13:51:08Z`, `targetCommitish: 7564f54e…`; `gh release list` zeigt es als *Latest* |
| Marke | `git ls-remote origin refs/tags/v7.2.1.131` → `7564f54e…` = Merge von #204, wie `Releases/PAKETE.md:184` *„Marke auf dem Merge `7564f54e` von #204“* |
| Anhang | `Eudora72-7.2.1.131-release.zip`, 9133848 Byte, `digest: sha256:ec3c8b26…7d44d7800` — gleich `Releases/PAKETE.md:189` *„9.133.848 Byte, SHA-256 `ec3c8b26…7d44d7800`“* |
| Release-Text | Text von GitHub (`body`) gegen `Releases/7.2.1.131/RELEASE-NOTIZEN.md` (ohne CR): `diff` leer. Der Entwurfskopf aus [L-128.3](LEKTOR-128.md#l-128.3) ist nicht mitgegangen |
| Verweis im Text | *README unter „Bekannte Fehler“* → `origin/main:README.md:149` *„### Bekannte Fehler“* vorhanden |
| `tools/RELEASES.md:50` | *„2026-11-02 14:51:08 \| v7.2.1.131 \| …“* — Ortszeit, = 13:51:08 UTC; dieselbe Schreibweise wie die Zeile davor (`22:17:31` für 21:17:31 UTC bei `v7.2.1.128`) |
| `CHANGELOG.md:113`, `Releases/PAKETE.md:182` | Überschriften auf „Release“ — der Rest aus [L-128.6](LEKTOR-128.md#l-128.6) ist damit erledigt |
| `README.md:104`, `Doku/FUNKTIONEN.md:18`, `:193` | nennen 7.2.1.131 als veröffentlicht bzw. als Bezug; richtig |

## Funde

### <a id="l-129.1"></a>L-129.1 — „Zuletzt veröffentlicht: 7.2.1.128“ steht weiter in drei Stand-Köpfen, und die Schranke dafür ist grün

**Gewicht: mittel.** Wer die Köpfe liest, bekommt zwei Antworten auf „was ist das neueste Release?“. (gemessen)

- `Intern/WEITERMACHEN.md:3` beginnt *„**Release [`v7.2.1.131`](…) veröffentlicht** (#204, Latest …)“* und endet im selben Absatz mit *„Zuletzt veröffentlicht: **`v7.2.1.128`** (29.10.2026, nach Gregors Test …)“* (fortgesetzt in `:4-5`).
- `Releases/PAKETE.md:6` nennt jetzt *„7.2.1.131 (Release vom 02.11.2026 …; veröffentlicht als `v7.2.1.131`)“* und gleich danach *„veröffentlicht zuletzt 7.2.1.128 — … veröffentlicht als `v7.2.1.128` … (Marke auf `c8b0893f`, auf GitHub *Latest*)“*.
- `ZIEL.md:216` (nicht im Diff) *„Quellstand **7.2.1.131** (`VERSION` gleich; Testpaket, geschnürt am 02.11.2026, nicht veröffentlicht …). Veröffentlicht zuletzt **7.2.1.128**“*.
- `perl tools/pruefe-release-buchfuehrung.pl`: *„Jedes fuehrende Dokument kennt v7.2.1.131, und keiner der 5 geprueften Absaetze gibt eine aeltere Fassung als aktuellen Stand aus.“* Das Werkzeug sieht, dass das neue Tag genannt ist; dass derselbe Absatz ein älteres als „zuletzt veröffentlicht“ führt, sieht es nicht.

**Vorschlag:** Die drei Sätze auf *„zuletzt veröffentlicht `v7.2.1.131` (02.11.2026), davor `v7.2.1.128`“*; *Latest* bei 7.2.1.128 in PAKETE:6 auf „damals *Latest*“. Das Werkzeug weist einen Absatz ab, in dem nach „zuletzt veröffentlicht“ (oder „Veröffentlicht zuletzt“) eine andere Marke als das neueste Tag folgt — gegengetestet an diesem Stand (rot) und am berichtigten (grün).

### <a id="l-129.2"></a>L-129.2 — Unter der neuen Überschrift „Release“ steht noch „nicht veröffentlicht“ und „veröffentlicht wird nach seinem Ja“

**Gewicht: mittel.** Der Diff hat jeweils die Überschrift bzw. den ersten Satz geändert, den Rest desselben Absatzes nicht. (gemessen)

- `CHANGELOG.md:113` *„## 7.2.1.131 — Release (`v7.2.1.131`, veröffentlicht am 02.11.2026)“*, darunter `:115` *„**Geschnürt am 02.11.2026, bereitgestellt in …, nicht veröffentlicht**“* und *„als Release 7.2.1.131 veröffentlicht wird nach seinem Ja, danach 7.2.2.“*
- `Releases/PAKETE.md:184` beginnt *„veröffentlicht am 02.11.2026 als [`v7.2.1.131`] … nach Gregors Ja“* und endet *„Release-Kandidat — veröffentlicht wird nur mit Gregors Ja.“*
- `Releases/PAKETE.md:189` (Zeile *ZIP*) *„nicht im Repo (`.gitignore`), nicht auf GitHub“* — es liegt dort (siehe Tabelle oben).

**Vorschlag:** Die drei Halbsätze streichen bzw. auf den neuen Stand setzen; in PAKETE:189 *„auf GitHub als Anhang von `v7.2.1.131`, SHA-256 dort gleich“*.

### <a id="l-129.3"></a>L-129.3 — Kleinkram: drei Stellen außerhalb des Diffs nennen 7.2.1.131 weiter Testpaket oder Kandidat

**Gewicht: Kleinkram.** (gemessen)

- `Intern/TESTPLAN.md:1` *„Quellstand 7.2.1.131 (Testpaket, …) … zuletzt getestet am 02.11.2026 der Release-Kandidat 7.2.1.131“*.
- `Intern/AUFGABEN.md:8` *„Release-Kandidat 7.2.1.131 geschnürt … Laufend: Zweig `paket_7_2_1_131`, wird als `release_7_2_1_131` eingereicht“* — die Datei ist laut `:3` nur noch zum Nachschlagen; der Satz ist trotzdem als „laufend“ formuliert.
- `Doku/FUNKTIONEN.md:908` *Notify Application* [E-177](../Intern/BEFUNDE.md#e-177) (Zeichensatzangabe der Zwischendatei) *„im Quellstand berichtigt“* — seit dem Release *„berichtigt in 7.2.1.131“*, wie `:193` es für [E-143](../Intern/BEFUNDE.md#e-143) schon sagt; der Stand-Kopf `:18` verspricht *„Was sich gegenüber älteren Fassungen geändert hat, steht an der Zeile dabei.“*

**Vorschlag:** Mit [L-129.1](#l-129.1) und [L-129.2](#l-129.2) in einem Zug.

## Offene Reste aus LEKTOR-128 (nur aufgezählt)

| Fund | Stand (gemessen) |
|---|---|
| [L-128.6](LEKTOR-128.md#l-128.6) Überschriften „Testpaket“, `FUNKTIONEN.md` auf 7.2.1.130 | **erledigt** in diesem Diff (`CHANGELOG.md:113`, `Releases/PAKETE.md:182`, `Doku/FUNKTIONEN.md:18`, `:193`); Rest siehe [L-129.3](#l-129.3) |
| [L-128.2](LEKTOR-128.md#l-128.2) Schranke gegen „PR folgt“ in Stand-Köpfen (Zweig steht schon in `main`) | offen: `grep -l 'PR folgt' tools/*.pl` kein Treffer |
| [L-128.3](LEKTOR-128.md#l-128.3) Schranke gegen einen Entwurfskopf in der Notizdatei | offen: `tools/release-veroeffentlichen.ps1` prüft nur den CHANGELOG-Abschnitt (`:128` *„if ($text -match 'noch nicht best')“*), nicht die Datei hinter `--notes-file` |
| [L-128.8](LEKTOR-128.md#l-128.8) Berichtszahl in der README | `README.md:98` *„(208 LEKTOR- und PRÜFER-Berichte)“*, gezählt 210, mit diesem 211 |
| [L-126.1](LEKTOR-126.md#l-126.1) freiwilliger Schritt | unverändert `Intern/TESTPLAN.md:409` *„deren Uhrzeit du kennst (Spalte“* |
| [L-126.5](LEKTOR-126.md#l-126.5) Starts ohne Titelzeile in `tools/TESTLAEUFE.md` | nicht nachgesehen (außerhalb des Kurzlaufs) |

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): Paketnummer *„7.2.1.131“*, 52 Dateien, *„Kein Widerspruch gefunden.“*; „Zur Kenntnis“ unter anderem `Doku/FAQ.md` (7.2.1.130), `Doku/ANWENDER.md` und `Intern/PORTIERUNG.md` (7.2.1.128) — `Doku/FUNKTIONEN.md` steht nicht mehr darunter. [L-129.1](#l-129.1) bis [L-129.3](#l-129.3) sieht es nicht.

`perl tools/pruefe-release-buchfuehrung.pl` (gemessen): *„Neuestes Tag v7.2.1.131 … Geprueft 5 Datei(en), 5 Standaussage(n)“*, grün — trotz [L-129.1](#l-129.1).

`perl tools/offene-befunde.pl` (gemessen): *„51 offene Befunde, in beiden Listen gleich.“*

`pruefe-regressionstest.pl` und `ziel-stand.pl` nicht gelaufen: der Diff ändert weder Befunde noch ZIEL.md (Kurzlauf).

Persönliche Angaben: im Diff `7564f54e..1f4b54de` und in den beiden Commit-Nachrichten keine (gelesen, gemessen).

## Was nur Gregor entscheiden kann

Nichts Neues. Das Release ist veröffentlicht; die drei Funde sind Doku-Nachträge, die beim Hauptagenten liegen.
