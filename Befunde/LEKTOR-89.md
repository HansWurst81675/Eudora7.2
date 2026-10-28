# <a id="lektor-89"></a>LEKTOR-89 — Prüfung vor dem Merge von PR #180 (`0.127_test_ergebnisse`): E-166 Junk-Frage, S-3c erweitert, Freigabe-Schranke in `testlauf.ps1`, Stand-Köpfe 28.10.2026

**Auftrag.** Lauf über `2a8f5649..978a852a` (fünf Commits seit [LEKTOR-88](LEKTOR-88.md#lektor-88))
und Bestand der 61 `.md` ohne `Arbeitsweise/` und `Befunde/`. Neu seit dem
letzten Bericht: [E-166](../Intern/BEFUNDE.md#e-166) (die Frage *„Automatically put junk mail
in the Junk mailbox?“* kam bei Gregor mehrmals; am Prüfstand nicht
nachstellbar, weil die Junk-Zusätze ohne `MFC71.DLL`/`MSVCP71.dll` nicht
laden), Abschnitt S-3c unter [S-3](../Intern/BEFUNDE.md#s-3) um drei Zusätze erweitert,
`tools/testlauf.ps1` weist Freigaben mit fremdem Datum ab,
`tools/messen-e166.ps1`, Stand-Köpfe auf 28.10.2026 in WEITERMACHEN,
AUFGABEN, TESTPLAN, PAKETE, DEFENDER-FEHLALARM. Besonders: (1) sind die
Stand-Köpfe wahr? (2) sind [E-166](../Intern/BEFUNDE.md#e-166) und S-3c in sich und mit README/ZIEL
stimmig? Gemessen im Arbeitsbaum `Eudora7.2-wt-lektor` auf
`wt/lektor-20261028` (= `978a852a`).

**Ergebnis vorweg.** **10 Funde: 3 falsch, 3 veraltet, 2 ungenau, 2
Hinweise.** Die Stand-Köpfe sind in dem, was sie über die Fassung sagen,
**wahr** (Quellstand seit 27.10.2026 unverändert, gemessen). Nicht stimmig
ist S-3c: der erweiterte Abschnitt sagt weiter, ohne die beiden Bibliotheken
falle **„vor allem das Adressbuch“** aus — README, ANWENDER, AUFGABEN,
PORTIERUNG und WEITERMACHEN sagen ausdrücklich das Gegenteil
([L-89.1](#l-89.1)). [E-166](../Intern/BEFUNDE.md#e-166) widerspricht sich selbst: der erste Absatz sagt,
der Dialog schreibe keine Protokollzeile, der spätere findet genau diese
Zeile — und deshalb ist Gregors **erstes** Protokoll nie danach durchsucht
worden ([L-89.2](#l-89.2)). `Intern/FILTER.md` sagt, auch `MSVCR71.dll`
liege nicht im Paket; das Paket bringt sie mit ([L-89.9](#l-89.9)). Keiner
der Funde hält den Merge inhaltlich auf; [L-89.1](#l-89.1),
[L-89.2](#l-89.2) und [L-89.6](#l-89.6) sind vor dem Merge empfohlen, weil
sie in Dateien stehen, die mit diesem PR geändert wurden.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**. Nichts berichtigt — der Auftrag
erlaubt diesmal nur diesen Bericht und `Intern/LEKTORAT.md`.

---

## Funde aus LEKTOR-88

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-88.1](LEKTOR-88.md#l-88.1) | ZIEL nannte [E-160](../Intern/BEFUNDE.md#e-160) (Windows-Meldung beim Anlegen einer Persönlichkeit) ungemessen | **erledigt** | `ZIEL.md:74` *„(\*\*behoben\*\*, kommt mit 7.2.0.127 …“* (belegt) |
| [L-88.2](LEKTOR-88.md#l-88.2) | ZIEL führte [E-137](../Intern/BEFUNDE.md#e-137) (Strg+W in einer Leiste) ohne Gregors Ergebnis | **erledigt** | `ZIEL.md:75` (belegt) |
| [L-88.3](LEKTOR-88.md#l-88.3) | CHANGELOG 7.2.0.127 „noch nicht getestet“ | **erledigt** | gemessen: `grep -n 'noch nicht getestet\|Gregors Test steht noch aus' CHANGELOG.md` — kein Treffer |
| [L-88.4](LEKTOR-88.md#l-88.4) | Entscheidung 2 „an 1.0.127 zu prüfen“ | **erledigt** | `Intern/WEITERMACHEN.md:121` *„von Gregor am 27.10.2026 an 1.0.127 bestä[tigt]“* (belegt) |
| [L-88.5](LEKTOR-88.md#l-88.5) | „hier weiter“ auf gemergtem Zweig | **erledigt**, inzwischen wieder veraltet | `Intern/WEITERMACHEN.md:135`; der Block nennt Erledigtes als nächsten Schritt → [L-89.6](#l-89.6) |
| [L-88.6](LEKTOR-88.md#l-88.6) | fünf Stand-Angaben ohne Gregors Ergebnis | **erledigt** | `README.md:101`, `Intern/AUFGABEN.md:3`, `Releases/PAKETE.md:161`, `Intern/TESTPLAN.md:3-4` tragen *„V1 bis V6 bestanden“* (belegt) |
| [L-88.7](LEKTOR-88.md#l-88.7) | ANWENDER: Dialog nach *Ja* „leer“ | **erledigt** | `Doku/ANWENDER.md:140` *„Dialog ohne Adresse — Kurzname und Name sind aus dem Absender vorbelegt“* (belegt) |
| [L-88.8](LEKTOR-88.md#l-88.8) | [E-137](../Intern/BEFUNDE.md#e-137) „viermal“, TESTPLAN zwei | **erledigt** | `Intern/TESTPLAN.md:49` *„genau vier Zeilen `E-137 Strg-W angekommen`“* (belegt) |
| [L-88.9](LEKTOR-88.md#l-88.9) | [E-124](../Intern/BEFUNDE.md#e-124) (Defender-Fehlalarm) kennt den Fall an 1.0.127 nicht | **offen** | `Intern/BEFUNDE.md:370` *„\*\*Zuletzt gemessen: 26.10.2026 an 7.2.0.124\*\*“*; gemessen: kein `1.0.127` in der Zeile. Dazu neu [L-89.8](#l-89.8) |
| [L-88.10](LEKTOR-88.md#l-88.10) | PRÜFER-63 verweist bei „nicht vergeben“ auf [E-165](../Intern/BEFUNDE.md#e-165) | **offen, verschärft** | `Befunde/PRUEFER-63.md:186` *„Keine. [E-165](../Intern/BEFUNDE.md#e-165) und [E-166](../Intern/BEFUNDE.md#e-166) sind nicht vergeben.“* — Commit `2a8f5649` hat auch [E-166](../Intern/BEFUNDE.md#e-166) verlinkt; beide Verweise zeigen jetzt auf vergebene Befunde |

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | rc=0, *„Kein Widerspruch gefunden.“*; 47 Dateien; zur Kenntnis 15 Dateien ohne 7.2.0.127 (alle geschichtlich oder Hintergrund) |
| `perl tools/offene-befunde.pl` | rc=0, *„42 offene Befunde, in beiden Listen gleich.“* (41 aus [LEKTOR-88](LEKTOR-88.md#lektor-88) + [E-166](../Intern/BEFUNDE.md#e-166)); 5 aktuell, 26 veraltet, 11 nie gemessen |
| `perl tools/pruefe-regressionstest.pl` | rc=0, *„Kein neues "behoben" ohne Regressionstest.“*; 22 kritische ohne jede Prüfung |
| `perl tools/ziel-stand.pl` | rc=0, *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* |
| `perl tools/pruefe-befundurteile.pl` | rc=0, *„Kein Dokument erklaert einen offenen Befund fuer erledigt“* |

Alle fünf grün. Keines der Werkzeuge liest die **Sachaussagen** in S-3c
oder vergleicht Befundtext mit Anwenderdoku — [L-89.1](#l-89.1) und
[L-89.9](#l-89.9) liegen außerhalb ihrer Reichweite.

## Stand-Köpfe vom 28.10.2026 (Frage 1)

* **Quellstand unverändert** — gemessen: `git log -- Eudora71` jüngster
  Commit `ea3ebcbd 2026-10-27 14:11` *„Fassung 7.2.0.127 / Paket 1.0.127
  gesetzt“*. Die Zusätze *„(Quellstand seit 27.10.2026 unverändert)“*
  (`Intern/AUFGABEN.md:3`) und *„(Inhalt seit 27.10.2026 unverändert)“*
  (`Intern/TESTPLAN.md:1`) sind **wahr**; der TESTPLAN-Diff in `978a852a`
  ändert nur die Kopfzeile (gemessen).
* `Releases/PAKETE.md:6` *„Stand 28.10.2026 (Nummern bis 1.0.127
  verzeichnet, geschnürt ist bis 1.0.127“* — wahr, kein neues Paket.
* `Intern/WEITERMACHEN.md:3` *„Stand 28.10.2026.“* — wahr; der „hier
  weiter“-Block darunter siehe [L-89.6](#l-89.6).
* `Releases/DEFENDER-FEHLALARM.md:3` *„seit dem 23.10.2026 nichts Neues“* —
  für den Vorgang bei Microsoft vermutlich richtig, für den Fehlalarm selbst
  nicht → [L-89.8](#l-89.8).
* Neu am 28.10. ist [E-166](../Intern/BEFUNDE.md#e-166); keiner der fünf Köpfe nennt es,
  AUFGABEN, PAKETE und TESTPLAN auch im Text nicht (gemessen: `grep -c
  [E-166](../Intern/BEFUNDE.md#e-166)` je 0). Für PAKETE und TESTPLAN richtig; siehe [L-89.10](#l-89.10).

---

## <a id="l-89.1"></a>L-89.1 — falsch: S-3c sagt, ohne `MFC71.DLL` falle „vor allem das Adressbuch“ aus

**Was passiert:** wer S-3c liest, glaubt, das eigene Adressbuch funktioniere
in dieser Fassung nicht. Fünf andere Dateien sagen ausdrücklich, es arbeite —
und der Abschnitt wurde gerade erst überarbeitet, ohne dass das auffiel.

* **Belegt**, `Intern/BEFUNDE.md:2971` (Tabelle in S-3c): *„| EudoraBk.dll
  | MFC71 | Adressbuch |“*; `:2979-2980` *„Ohne die beiden Dateien faellt
  vor allem das Adressbuch aus, dazu still Junk-Filter und S/MIME.“* — die
  zweite Hälfte ist am 28.10. ergänzt (`978a852a`), die erste blieb.
* **Belegt**, ebenso die Kopfzeile `Intern/BEFUNDE.md:212` ([S-3](../Intern/BEFUNDE.md#s-3)): *„damit
  fallen Adressbuch (`EudoraBk.dll`), LDAP (`Ldap.dll`) und Ph (`Ph.dll`)
  aus“* — und von dort in die erzeugten Listen `CHANGELOG.md:61` und
  `Intern/WEITERMACHEN.md:394`; dazu `Intern/STARTUMGEBUNG.md:120`
  *„Dadurch fallen \*\*Adressbuch, LDAP und Ph\*\* aus.“*
* **Belegt**, das Gegenteil: `README.md:165` *„\*\*Das eigene Adressbuch ist
  davon nicht betroffen\*\* und arbeitet“*; `Doku/ANWENDER.md:22-30`
  *„\*\*Nicht gemeint ist das eigene Adressbuch\*\* … `EudoraBk.dll` klingt
  nach Adressbuch, ist aber der Protokollanbieter \*„EudoraBk Protocol"\* des
  Verzeichnisdienstes“*; `Intern/AUFGABEN.md:294`, `Intern/PORTIERUNG.md:737`,
  `Intern/WEITERMACHEN.md:324` je *„nicht das eigene Adressbuch“*.

**Was zu tun wäre:** in S-3c Zeile `EudoraBk.dll` auf
„Verzeichnisdienst-Protokoll *EudoraBk*“ und den Schlusssatz auf
„Verzeichnisdienste, Junk-Filter und S/MIME“; dasselbe im „Was noch fehlt“
von [S-3](../Intern/BEFUNDE.md#s-3) (`:212`, erzeugt die beiden Listen) und `STARTUMGEBUNG.md:120`.
**Vor dem Merge empfohlen** — S-3c ist in diesem PR geändert.

## <a id="l-89.2"></a>L-89.2 — falsch: E-166 sagt, der Dialog schreibe keine Protokollzeile — und findet sie später selbst

**Was passiert:** derselbe Eintrag sagt erst, im Protokoll sei die Junk-Frage
nicht zu sehen, und zählt sie dann im zweiten Protokoll. Weil der erste Satz
stehen blieb, ist Gregors **erstes** Protokoll (Sitzung 16:37, Ordner
`test_0.127`) nie nach der Zeile durchsucht worden — gerade dort, wo die
Frage nach Gregors Wort *„ein paar mal beim start“* kam.

* **Belegt**, `Intern/BEFUNDE.md:383` ([E-166](../Intern/BEFUNDE.md#e-166)): *„Ob der Dialog genau danach
  wiederkam, zeigt das Protokoll nicht (der Dialog schreibt keine Zeile).“*
  — und im selben Feld: *„der Dialog steht als Zeile `Dialog: "At least one
  junk mail identification tool is installed, and ready to filter junk."` in
  der Sitzung 22:26 … und \*\*wieder\*\* in der Sitzung 23:00“*.
* **Belegt am Quelltext**: `AlertDialog` (`guiutils.cpp:918-936`) zeigt
  `CAlertDialog`, der seinen Text mit `PutDebugLog(DEBUG_MASK_DIALOG, …)`
  schreibt (`guiutils.cpp:173`), und danach die **gewählte Taste**
  (`:931-933`, `IDS_DEBUG_DISMISSED_ALERT`); `DEBUG_MASK_DIALOG = 0x08`
  (`QCUtils/public/inc/debug.h:17`). Der Dialogtext ist der aus
  `EudoraRes.rc:3771` (`IDD_USE_JUNK_MAILBOX`).

**Was zu tun wäre:** den Satz streichen; im ersten Protokoll die Zeilen
`Dialog: "At least one junk…"` und die folgende Tastenzeile zählen — das
beantwortet *„mehrmals“* für den 27.10. nachmittags und zeigt, ob Gregor
*Yes* oder *No* gewählt hat. Gehört unter „Was noch fehlt“, braucht keinen
Prüfstand. **Vor dem Merge empfohlen.**

## <a id="l-89.3"></a>L-89.3 — veraltet: E-166 trägt zwei widerlegte Sätze und eine verrutschte Klammer

**Was passiert:** wer [E-166](../Intern/BEFUNDE.md#e-166) von oben liest, findet zweimal eine Aussage, die
erst fünf Sätze später zurückgenommen wird; die Herkunftsangabe von Gregors
Meldung hängt am Datum der Prüfstandsmessung.

* **Belegt**, `Intern/BEFUNDE.md:383`: *„in der Sitzung 22:26 (sie endet
  \*\*ohne\*\* `Logging shutdown`)“* und *„Damit passt die Vermutung oben nur
  halb: nach dem harten Ende kam die Frage nicht sofort wieder“* — beide
  überholt durch *„\*\*Berichtigt am selben Abend:\*\* … \*\*sie endete
  regulär\*\* (`Logging shutdown` 14.23)“* im selben Feld.
* **Belegt**, ebenda: *„\*\*Zuletzt gemessen: 28.10.2026 an 7.2.0.127\*\*
  (außerhalb der VM, leerer Stand; kein Bildschirmfoto, Gregor: …)“* — die
  Klammer beschreibt Gregors Meldung vom 27.10., nicht die Messung am
  Prüfstand `C:\Temp\E166`.
* Ungenau, nebenbei: *„`trnslate.cpp:3145-3152`, nur `TRACE`“* — das
  `TRACE` steht in `Trnslate.cpp:3156` (gemessen mit `sed -n`); der Bereich
  endet vor ihm. `Intern/FILTER.md:498` nennt `:3150-3157`, das trifft.

**Was zu tun wäre:** die beiden Sätze durch die berichtigte Fassung
ersetzen (Messung in einen Satz, Widerlegung in einen), Klammer hinter
*„gemeldet von Gregor am 27.10.2026“* stellen. Hindert den Merge nicht.

## <a id="l-89.4"></a>L-89.4 — veraltet: S-3 im Kopf ohne die Messung vom 28.10., S-3c nennt die Zusätze „bei Benutzung“ geladen

**Was passiert:** die Kopfzeile von [S-3](../Intern/BEFUNDE.md#s-3), aus der die erzeugten Listen
gespeist werden, kennt weder Junk-Filter noch S/MIME und gilt als
„veraltet“ gemessen, obwohl S-3c am 28.10. gemessen wurde. Zwei Verweise
auf S-3c landen beim Kopf von [S-3](../Intern/BEFUNDE.md#s-3), obwohl S-3c seit diesem PR einen eigenen
Anker hat.

* **Belegt**, `Intern/BEFUNDE.md:212`: *„\*\*Zuletzt belegt am Quelltext:
  22.10.2026 an 7.2.0.121\*\*“*, *„Was noch fehlt: allein S-3c … damit
  fallen Adressbuch …, LDAP … und Ph … aus“*; erzeugt
  `Intern/WEITERMACHEN.md:394` *„22.10.2026 an 7.2.0.121 (Quelltext) —
  \*\*veraltet\*\*“*.
* **Belegt**, `Intern/BEFUNDE.md:2966-2967` *„Betroffen sind sieben DLLs
  (drei davon Zusaetze in `Plugins` …), die Eudora erst bei Benutzung
  laedt“* — die drei Zusätze lädt Eudora beim **Start**
  (`Trnslate.cpp:3150` `LoadLibrary` in der Suchschleife; [E-166](../Intern/BEFUNDE.md#e-166) selbst:
  *„`Plugin: Checking path C:\Temp\E166\Plugins.`“* im Startprotokoll).
* **Belegt**, Verweise: `tools/WERKZEUGE.md:142`
  *„([S-3c](../Intern/BEFUNDE.md#s-3), Abschnitt S-3c)“*,
  `Intern/WEITERMACHEN.md:135` *„[S-3](BEFUNDE.md#s-3) Abschnitt S-3c
  erweitert“* — Anker `id="s-3c"` steht seit `978a852a` in
  `Intern/BEFUNDE.md:2964`.
* Dazu: [E-166](../Intern/BEFUNDE.md#e-166) nennt den Fund *„zugleich eine Erweiterung von [S-3c]“*; dass
  die drei Zusätze `MFC71.DLL` und `MSVCP71.dll` brauchen, steht seit [B-1](../Intern/BEFUNDE.md#b-1) in
  `Intern/BEFUNDE.md:3168-3174` und in `Pruefung/PRUEFUNG-PAKET.md:125-126`
  (belegt). Neu am 28.10. ist die Messung am Programm, nicht die Abhängigkeit.

**Was zu tun wäre:** S-3-Kopf (Messdatum, Was noch fehlt), „bei Benutzung“
auf die vier Verzeichnisdienst-DLLs beschränken, Verweise auf `#s-3c`. Hindert
den Merge nicht.

## <a id="l-89.5"></a>L-89.5 — ungenau: TESTLAEUFE führt den ersten nicht abgesprochenen Start ohne Vermerk

**Was passiert:** im Protokoll aller Eudora-Starts sieht der erste Start vom
28.10. aus wie ein freigegebener; nur der zweite trägt *„nicht
abgesprochen“* — [E-166](../Intern/BEFUNDE.md#e-166) und der Nachtrag in `Arbeitsweise/` nennen beide.

* **Belegt**, `tools/TESTLAEUFE.md:546` (10:53:24): Freigabe *„Gregor am
  27.10.2026 fuer den 28.10.2026: 'ja, auch fuer [E-166](../Intern/BEFUNDE.md#e-166)'“*, kein Vermerk;
  `:547` (10:53:56) derselbe Text *„— \*\*nicht abgesprochen\*\*, siehe
  Arbeitsweise/erlaubnis-nicht-hineinlesen.md Nachtrag 28.10.2026“*.
* **Belegt**, `Intern/BEFUNDE.md:383` *„\*\*Beide Starts waren nicht
  abgesprochen\*\*“*; `Arbeitsweise/erlaubnis-nicht-hineinlesen.md`
  (Nachtrag 28.10.2026) *„Am 28.10. um 10:53 und 10:54 habe ich
  `C:\Temp\E166` gestartet“*.
* Unklar dazu: `tools/WERKZEUGE.md:142` *„Am 28.10.2026 fünfmal gelaufen“*
  (`messen-e166.ps1`) — `:547` sagt, dieser Lauf *„wurde abgebrochen, bevor
  `testlauf.ps1` ihn eintrug“*, und Gregor schloss das Fenster selbst. Ob
  das Messskript dabei lief, sagt keine der beiden Zeilen.

**Was zu tun wäre:** Vermerk auch an `:546`. Hindert den Merge nicht.

## <a id="l-89.6"></a>L-89.6 — veraltet: „hier weiter“ nennt CHRONIST und PR als nächsten Schritt und eine Ankündigung als Freigabe

**Was passiert:** der Einstieg für die nächste Sitzung schickt zum CHRONIST,
der gelaufen ist, und zu einem PR, der steht; der Block vom 28.10. davor hat
keinen eigenen nächsten Schritt. Und er sagt weiter *„Gregor gab den
Prüfstand für den 28.10. frei“* — genau die Lesart, die der Nachtrag vom
28.10. als Fehler beschreibt.

* **Belegt**, `Intern/WEITERMACHEN.md:135`: *„\*\*Stand 28.10.2026 — hier
  weiter:\*\* [[E-166](../Intern/BEFUNDE.md#e-166)] am Prüfstand gemessen … LEKTOR vor dem Merge von PR
  #180 fällig. \*\*Stand 27.10.2026 abends:\*\* … Neu: [E-165] (…; Gregor gab
  den Prüfstand für den 28.10. frei). \*\*Als Nächstes:\*\* CHRONIST; [E-165](../Intern/BEFUNDE.md#e-165)
  am Prüfstand messen; PR `0.127_test_ergebnisse` → `main`“*.
* **Gemessen**: CHRONIST ist gelaufen (`14de951a` *„CHRONIST 27.10.2026
  gespiegelt und ausgetragen“*, im Zweig); PR #180 steht (`gh pr view 180`:
  `"state":"OPEN"`, `headRefName` `0.127_test_ergebnisse`). [E-165](../Intern/BEFUNDE.md#e-165) ist
  weiter *„offen, nicht gemessen“* (`Intern/BEFUNDE.md`, Zeile
  `id="e-165"`).
* **Belegt**, Maßstab: `Arbeitsweise/erlaubnis-nicht-hineinlesen.md`
  (Nachtrag 28.10.2026) *„Eine Zusage für morgen ist ein Plan, den Gregor am
  Morgen noch bestätigt oder nicht.“* — Quelle der Angabe ist
  `Arbeitsweise/stand-27-10-2026.md:20` *„„[E-165](../Intern/BEFUNDE.md#e-165): ja für den start“ — „für
  morgen““*.

**Was zu tun wäre:** im 28.10.-Block ein eigenes *„Als Nächstes“*
(Merge von PR #180 durch Gregor; [E-165](../Intern/BEFUNDE.md#e-165) messen nach Gregors Ja vom selben
Tag; [E-166](../Intern/BEFUNDE.md#e-166) erst nach Klärung der beiden DLLs, siehe unten); im 27.10.-Teil
*„frei“* durch *„kündigte für den 28.10. an“* ersetzen. **Vor dem Merge
empfohlen** — die Datei ist der Einstieg.

## <a id="l-89.7"></a>L-89.7 — Hinweis: die Beschreibung von PR #180 kennt E-166 nicht und sagt, der CHRONIST laufe

**Was passiert:** Gregor liest vor dem Merge die PR-Beschreibung. Darin
fehlt alles vom 28.10., und eine Zeile ist überholt.

* **Gemessen** (`gh pr view 180 --json body`): kein *„[E-166](../Intern/BEFUNDE.md#e-166)“*, kein
  `testlauf.ps1`, kein `messen-e166.ps1`; *„CHRONIST läuft gerade; seine
  Lehren kommen mit dem nächsten PR.“* — sie sind mit `14de951a` in diesem
  PR. Außerdem *„[E-165](../Intern/BEFUNDE.md#e-165) … (offen, nicht gemessen; Prüfstand freigegeben für
  den nächsten Tag)“* — wie [L-89.6](#l-89.6).

Keine `.md`-Datei, daher Hinweis. **Was zu tun wäre:** Beschreibung um den
28.10. ergänzen, bevor Gregor merged.

## <a id="l-89.8"></a>L-89.8 — ungenau: DEFENDER-FEHLALARM sagt „seit dem 23.10.2026 nichts Neues“

**Was passiert:** am 26.10. (1.0.124) und am 27.10. (1.0.127) hat Defender
die `Eudora.exe` bei Gregor erneut in Quarantäne genommen; die Seite zum
Fehlalarm sagt in ihrem frisch datierten Kopf, seit dem 23.10. sei nichts
geschehen.

* **Belegt**, `Releases/DEFENDER-FEHLALARM.md:3` *„\*\*Stand 28.10.2026\*\*
  (seit dem 23.10.2026 nichts Neues; am 25., 26., 27. und 28.10.2026 nicht
  erneut abgefragt)“*.
* **Belegt**, `Intern/BEFUNDE.md:370` ([E-124](../Intern/BEFUNDE.md#e-124)) *„Zuletzt gemessen:
  26.10.2026 an 7.2.0.124 (Gregors Bild aus dem Defender-Schutzverlauf …)“*;
  `Intern/TESTPLAN.md:51` (V5) *„Microsoft Defender nahm die `Eudora.exe`
  um 16:47 in Quarantäne“* (27.10.2026, 1.0.127).
* **Vermutung**: gemeint ist der Vorgang bei Microsoft (*„abgewiesen“*),
  nicht der Alarm. Dann fehlt das Wort.

**Was zu tun wäre:** *„am Vorgang seit dem 23.10.2026 nichts Neues; der
Alarm selbst kam am 26.10. (1.0.124) und 27.10. (1.0.127) wieder, siehe
[E-124](../Intern/BEFUNDE.md#e-124)“* — zusammen mit [L-88.9](LEKTOR-88.md#l-88.9). Hindert den Merge
nicht.

## <a id="l-89.9"></a>L-89.9 — falsch: FILTER.md sagt, auch `MSVCR71.dll` liege nicht im Paket

**Was passiert:** wer wissen will, warum die Junk-Bewertung nicht arbeitet,
liest, alle drei Laufzeitbibliotheken fehlten. Eine davon bringt das Paket
als eigenen Nachbau mit — genau der Unterschied, den [E-166](../Intern/BEFUNDE.md#e-166) jetzt
gemessen hat.

* **Belegt**, `Intern/FILTER.md:491-495`: *„`SpamWatch.dll` und
  `SpamHeaders.dll` … brauchen `MFC71.DLL`, `MSVCP71.dll` und `MSVCR71.dll`
  … Diese drei Bibliotheken von 2003 hat Microsoft nie zur Weitergabe
  freigegeben; sie liegen nicht im Paket.“*
* **Belegt**, Gegenstück: `tools/paket-bauen.ps1:15` *„1. msvcr71.dll <-
  Eudora71\Bin\Release\msvcr71.dll (VC71Bruecke)“*; `Intern/BEFUNDE.md:223`
  ([B-1](../Intern/BEFUNDE.md#b-1)) *„eigene `msvcr71.dll` als Weiterleitung“*;
  `Intern/BEFUNDE.md:383` ([E-166](../Intern/BEFUNDE.md#e-166)) *„das Paket bringt nur `msvcr71.dll`
  mit“*.

Bestand, nicht in diesem PR geändert (letzter Commit an der Datei
`c28cde84`, 22.10.2026, gemessen). **Was zu tun wäre:** *„`MFC71.DLL` und
`MSVCP71.dll` liegen nicht im Paket; `MSVCR71.dll` ersetzt der eigene
Nachbau ([[B-1](../Intern/BEFUNDE.md#b-1)])“*. Ebenso SMIME.dll nennen. Hindert den Merge nicht.

## <a id="l-89.10"></a>L-89.10 — Hinweis: README und ANWENDER-Grenzen nennen den Junk-Filter nicht

**Was passiert:** S-3c sagt jetzt, ohne die beiden Bibliotheken falle *„still
Junk-Filter und S/MIME“* aus. Die Anwenderseiten nennen S/MIME, den
Junk-Filter nur über einen Umweg.

* **Belegt**, `README.md:165` *„\*\*Verzeichnisdienste\*\* (LDAP, Ph,
  EudoraBk) und S/MIME fehlen“*; `Doku/ANWENDER.md:18` *„LDAP, Ph, S/MIME
  und die Suche über den Verzeichnisdienst fallen aus“* — kein Junk.
* **Belegt**, der Umweg: `Doku/ANWENDER.md:124-127` verweist auf
  `Intern/FILTER.md`, *„warum diese Punktzahl hier bei jeder eingehenden
  Nachricht \*\*0\*\* bleibt“*.
* Folge für [E-166](../Intern/BEFUNDE.md#e-166) (**belegt am Quelltext**, `eudora.cpp:1791-1794`): ohne
  geladenen Junk-Zusatz kommt die Frage nie. Auf einem Rechner ohne
  `MFC71.DLL` sieht ein Anwender [E-166](../Intern/BEFUNDE.md#e-166) also gar nicht — nur wer die
  Bibliothek von anderswo hat, wie Gregor.

**Was zu tun wäre:** in `README.md:165` und `ANWENDER.md:18` „Junk-Filter“
ergänzen. Form der Doku, Sache des Hauptagenten. Hindert den Merge nicht.

---

## Geprüft ohne Fund

* **[E-166](../Intern/BEFUNDE.md#e-166), Quelltextangaben** (belegt): `IDD_USE_JUNK_MAILBOX` in
  `EudoraRes.rc:3763`, Titel wie im Befund; `InitJunkFeature` ab
  `eudora.cpp:1771`, `AlertDialog` `:1794` unter `!pJunkList->IsEmpty() &&
  (askedBits&introAsked)==0` mit `introAsked = 1<<1`; `boxAsked = 1<<2` —
  *„`AskedAboutJunk=4` … gesetzt ist nur Bit 2 („Junk-Postfach angelegt“)“*
  stimmt; `SetIniShort` am Ende `:1862`; zweiter Weg
  `QCSharewareManager.cpp:387` setzt Bit 1 ebenfalls (`:397`).
  `LogLevel=58783` = 58527 + `0x100` (gerechnet).
* **[E-166](../Intern/BEFUNDE.md#e-166), Einstufung und Liste**: *„\*\*Stufe: unkritisch\*\* (Rückfrage
  ohne Folgen)“*, *„Wie zu pruefen: \*\*ICH\*\* — am Prüfstand, Freigabe
  nötig“*; in `CHANGELOG.md:27` und `Intern/WEITERMACHEN.md:360` mit
  Messdatum 28.10.2026 (gemessen). Nicht in ZIEL — richtig, unkritisch.
* **ZIEL**: nennt weder [E-166](../Intern/BEFUNDE.md#e-166) noch [S-3](../Intern/BEFUNDE.md#s-3); 27 von 27 unberührt.
* **`tools/testlauf.ps1`-Schranke** gegen den Nachtrag: der Code weist jedes
  Datum ≠ heute ab (`$fremdeDaten`); was er nicht fängt, steht im Nachtrag
  offen (*„einen Satz von gestern, bei dem ich das alte Datum einfach
  weglasse“*).
* **Zweige**: *„alle `wt/`-Zweige … gelöscht“* (`WEITERMACHEN.md:135`) —
  gemessen: `git ls-remote origin 'refs/heads/wt/*'` zeigt nur
  `wt/lektor-20261028`, der danach für diesen Lauf angelegt wurde.

## Nicht geprüft

* Gregors beide Protokolle (`test_0.127`, `eudora_20261027.zip`) — nicht in
  meiner Reichweite; daher die Zählung in [L-89.2](#l-89.2) offen.
* Der Prüfstand `C:\Temp\E166` (Auftrag: keine Prüfstände).
* Bestand ohne Bezug zu Junk, Laufzeitbibliotheken und Stand-Köpfen: die
  übrigen Aussagen der 61 Dateien sind seit [LEKTOR-88](LEKTOR-88.md#lektor-88) unverändert
  (`git log --stat 2a8f564..HEAD`, gemessen) und dort geprüft.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **`MFC71.DLL` und `MSVCP71.dll` für den Prüfstand** — [E-166](../Intern/BEFUNDE.md#e-166) lässt sich
  nur nachstellen, wenn die beiden Bibliotheken neben einer Prüfstands-Eudora
  liegen (`Intern/BEFUNDE.md:383`, „Was noch fehlt“). Microsoft hat sie
  nicht zur Weitergabe freigegeben, und woher sie auf deinem Rechner kommen,
  weiß niemand. Ob sie von dort (oder anderswoher) in die VM kopiert werden
  dürfen — oder ob [E-166](../Intern/BEFUNDE.md#e-166) ohne Nachstellen bleibt —, ist deine Entscheidung.
* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)) — unverändert die letzte offene Frage
  vor dem Release.
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)) —
  neu dazu: dein Rechner außerhalb der VM hat die VC-7.1-Laufzeit
  (`SpamWatch.dll` hat dort geladen, sonst wäre die Junk-Frage nicht
  gekommen — belegt am Quelltext, `eudora.cpp:1791-1794`). Er ist damit
  **kein** Rechner „ohne Nachinstallation“; dein Test an 1.0.127 beantwortet
  die Frage nicht.
