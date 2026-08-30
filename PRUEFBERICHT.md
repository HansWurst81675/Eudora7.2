# PRUEFBERICHT — unabhaengige Nachpruefung des Standes 371c1e3

Geprueft von PRUEFER am 30.08.2026, Branch `pruefung-a8fcd110`, abgezweigt von
`eudora-exe-linkt` (371c1e3 "Bau-Kennung in der Titelleiste, Schranke von
Fehlalarmen befreit").

Kein Programm mit Oberflaeche gestartet. Alle Aussagen unten sind gemessen,
sofern nicht ausdruecklich "UNGEPRUEFT" davorsteht. Die Pruefung wurde nach
etwa einem Drittel abgebrochen, weil die Maschine abgeschaltet wurde — der
Abschnitt "Stand und naechster Schritt" sagt, wo es weitergeht.

---

## Zusammenfassung

| Nr.  | Gegenstand | Schwere | Zustand |
|------|-----------|---------|---------|
| PR-1 | `pruefe-bytes.pl` laesst LF→CRLF durch | **hoch** | belegt |
| PR-2 | `pruefe-bytes.pl` schlaegt bei Leerzeilen grundlos an | **hoch** | belegt |
| PR-3 | `pruefe-bytes.pl` prueft `.def`/`.sln`/`.bat` gar nicht | mittel | belegt |
| PR-4 | Bau ohne perl zeigt eine FREMDE Kennung an | mittel | belegt |
| PR-5 | Zeitstempel der Kennung ist nicht der Bauzeitpunkt | mittel | belegt |
| PR-6 | `_T(EUDORA_BAU_KENNUNG)` bricht in einem Unicode-Bau | mittel | belegt |
| PR-7 | S-7: Zahlen und Beispiel widersprechen sich | mittel | belegt |
| PR-8 | `rekursion-suchen.pl` kann S-2 gar nicht finden | niedrig | belegt |
| —    | `stapel-untersuchen.ps1`: Versaetze und Schleife | — | **stimmt** |
| —    | Werbeleiste an `IsBoxBuild()`: keine Stelle greift ins Leere | — | **stimmt** |
| —    | `OnUpdateFrameTitle`: keine Rekursion | — | **stimmt** |
| —    | PreBuildEvent bricht den Bau nicht ab | — | **stimmt** |

Nichts davon haelt Paket 1.0.3 auf. Die schweren Befunde betreffen die
Schranke, nicht die ausgelieferte Software — sie machen aber die Zusicherung
"lautlose Dateischaeden werden erkannt" unzutreffend.

---

## PR-1 — `pruefe-bytes.pl` laesst die Umwandlung LF → CRLF durch (hoch)

**Fundstelle:** `tools/pruefe-bytes.pl:105-125` (Regel 2).

Regel 2 sucht ausschliesslich nach der Richtung CRLF → LF:

    next unless $a->{$inhalt}[0] > 0;                 # Feld 0 = CRLF-Vorkommen in HEAD
    next unless $b->{$inhalt}[0] == 0;                # im Index kein CRLF mehr

Die Gegenrichtung — ein Werkzeug schreibt eine gemischte Datei komplett mit
CRLF neu — wird nirgends geprueft. Sobald der Commit zusaetzlich Inhalt
aendert (Regel 1 greift dann nicht mehr), laeuft der Schaden lautlos durch.

**Gegenprobe (belegt).** Eigenes Wegwerf-Repo, `.gitattributes` mit `* -text`,
Datei `a.cpp` mit gemischten Enden (`zeile1` LF, `zeile2` CRLF, `zeile3` LF,
`zeile4` CRLF). Dann alles auf CRLF umgeschrieben und `zeile4` durch `NEU`
ersetzt:

    --- Gegenprobe A: LF->CRLF plus Inhaltsaenderung ---
    Rueckgabe: 0

Die unveraenderten Zeilen `zeile1` und `zeile3` haben ihr Zeilenende verloren,
die Schranke schweigt. Zur Kontrolle dieselbe Aenderung in der anderen
Richtung:

    --- Gegenprobe B: CRLF->LF plus Inhaltsaenderung ---
    COMMIT ABGEBROCHEN - ... z. B. "zeile2"
    Rueckgabe: 1

Die Schranke ist also einseitig. Das ist in diesem Projekt die
wahrscheinlichere Richtung, denn Windows-Werkzeuge (Editoren, `Set-Content`,
`Out-File`) schreiben CRLF, nicht LF.

**Behebung (klein).** Regel 2 symmetrisch aufziehen: dieselbe Pruefung noch
einmal mit vertauschten Feldern 0 und 1 und der Meldung "(LF -> CRLF)".
Nicht ausgefuehrt — siehe PR-2, beide gehoeren in einen Zug.

## PR-2 — `pruefe-bytes.pl` schlaegt bei Leerzeilen grundlos an (hoch)

**Fundstelle:** `tools/pruefe-bytes.pl:110-118`.

Regel 2 vergleicht Zeilen ueber ihren INHALT. In einer Datei mit gemischten
Enden ist der haeufigste Inhalt die leere Zeile — und die kommt mit beiden
Enden vor. Loescht ein normaler Commit die einzige CRLF-Leerzeile und fuegt an
anderer Stelle eine LF-Leerzeile ein, sieht die Regel genau ihr Schadensmuster:
Inhalt `""` hatte CRLF, hat jetzt keins mehr, ist als LF weiter da.

**Gegenprobe (belegt).** `c.cpp` in HEAD: `void f()` LF, `{` LF, Leerzeile
CRLF, `\tint a;` LF, `}` LF. Im Index: die CRLF-Leerzeile entfernt, dafuer
`\tint b;` und eine LF-Leerzeile ergaenzt. Kein einziges Byte wurde
umgewandelt:

    --- Gegenprobe D: CRLF-Leerzeile geloescht, LF-Leerzeile ergaenzt ---
    COMMIT ABGEBROCHEN - lautloser Schaden erkannt:
      * c.cpp: unveraenderte Zeilen haben ihr Zeilenende gewechselt (CRLF -> LF), z. B. ""
    Rueckgabe: 1

Die Meldung nennt als Beispiel die leere Zeichenkette und gibt damit keinen
Hinweis, wo man nachsehen soll. Das ist derselbe Fehler, den der Commit
371c1e3 abstellen wollte ("Ein Waechter, der grundlos Alarm gibt, wird umgangen
und ist damit wertlos") — er ist nur von der CR-Anzahl auf den Zeileninhalt
umgezogen.

**Behebung (klein).** Zeilen, deren Inhalt nach `s/\s+//g` leer ist, in Regel 2
uebergehen; sie tragen keine Information. Zusaetzlich Zeilen, die in HEAD mit
BEIDEN Enden vorkommen. Nicht ausgefuehrt.

## PR-3 — Ganze Dateiarten werden nicht geprueft (mittel)

**Fundstelle:** `tools/pruefe-bytes.pl:52` gegen
`tools/zeilenenden-angleichen.pl:90`.

Die beiden Werkzeuge sind sich ueber die Dateiarten nicht einig:

    pruefe-bytes:          cpp h c hpp inl rc idl mak txt md vcxproj filters
    zeilenenden-angleichen: c cpp h hpp inl rc idl def mak txt md

`.def` steht nur in einem der beiden, `.vcxproj`/`.filters` nur im anderen.
Nicht geprueft werden ausserdem `.sln`, `.rc2`, `.bat`, `.cmd`, `.ps1`, `.pl`,
`.props` — darunter die Bauwerkzeuge dieses Projekts selbst.

**Gegenprobe (belegt).** `b.def` (`LIBRARY X` / `EXPORTS` / `  Foo`, alles
CRLF) komplett auf LF umgeschrieben und vorgemerkt:

    --- Gegenprobe C: .def komplett auf LF umgeschrieben ---
    Rueckgabe: 0

Regel 1 haette diesen Schaden erkannt; die Datei kommt nur wegen der Endung
gar nicht erst zur Pruefung.

**Behebung (klein).** Eine gemeinsame Endungsliste in beiden Werkzeugen,
ergaenzt um `def sln rc2 bat cmd ps1 pl props`. Nicht ausgefuehrt.

## PR-4 — Ein Bau ohne perl zeigt eine FREMDE Kennung (mittel)

**Fundstellen:** `Eudora71/Eudora/Eudora.vcxproj:63-72` (PreBuildEvent),
`Eudora71/Eudora/BuildKennung.h` (in git verfolgt, gemessen mit `git ls-files`).

Der PreBuildEvent bricht den Bau richtigerweise nicht ab — das ist geprueft und
stimmt: `perl ... && exit /b 0`, danach der Git-Pfad, danach `echo WARNUNG` und
`exit /b 0`. Fehlt perl, ist der Rueckgabewert trotzdem 0.

Der Haken liegt daneben: `BuildKennung.h` ist eine VERFOLGTE Datei. Faellt perl
aus, bleibt die zuletzt committete Fassung stehen, und das Fenster zeigt eine
Kennung, die zu einem ganz anderen Bau gehoert — samt Commit und Zeitstempel.
Genau das, was die Kennung verhindern sollte ("zwei verschiedene Binaerdateien
mit derselben Kennung"), passiert dann wieder, nur unauffaelliger: die
Warnung steht in der Bauausgabe, das Fenster luegt.

**Behebung (klein).** Entweder `BuildKennung.h` aus der Verfolgung nehmen und
eine `BuildKennung-vorlage.h` mit `"unbekannt"` einchecken, die der
PreBuildEvent bei fehlendem perl kopiert; oder der `echo`-Zweig schreibt die
Datei selbst mit `EUDORA_BAU_KENNUNG "ohne-perl-gebaut"`. Nicht ausgefuehrt —
beruehrt die Projektdatei, das gehoert abgestimmt.

## PR-5 — Der Zeitstempel in der Kennung ist nicht der Bauzeitpunkt (mittel)

**Fundstelle:** `tools/kennung-erzeugen.pl:118-130`.

Der Kopfkommentar sagt, die Kennung enthalte "dem Zeitpunkt des Baus". Das
Werkzeug schreibt die Datei aber nur neu, wenn sich der Inhalt OHNE den
Zeitstempel geaendert hat:

    (my $alt_ohne_zeit = $alt) =~ s/\d{4}-\d{2}-\d{2} \d{2}:\d{2}//;
    ...
    if ($alt_ohne_zeit eq $neu_ohne_zeit) { ... exit 0; }

Solange Version, Commit und Sternchen gleich bleiben, bleibt also der ALTE
Zeitstempel stehen. Baut man zehnmal hintereinander ohne zu committen, zeigen
alle zehn Bauten dieselbe Uhrzeit — die des ersten. Das ist als Verhalten
richtig gewaehlt (sonst uebersetzt jeder Bau alles neu), aber die Beschreibung
und die Erwartung "wann wurde das gebaut" stimmen nicht.

Der Stabilitaetstest faellt dafuer gut aus: die Kennung springt NICHT zwischen
zwei Bauten hin und her. `BuildKennung.h` ist aus der Schmutzpruefung
herausgefiltert (`!/BuildKennung\.h$/`), das verhindert genau das Pendeln, das
der Kommentar beschreibt. Frischer Klon ohne git: `$commit` wird `ohne-git`.
Ohne `VERSION`: `unbekannt`. Beides faengt das Werkzeug ab.

**Behebung (klein).** Ein Wort im Kommentar und in `BEFUNDE.md`: "Zeitpunkt,
zu dem sich Commit oder Sauberkeit zuletzt geaendert haben". Nicht ausgefuehrt.

## PR-6 — `_T(EUDORA_BAU_KENNUNG)` uebersetzt in einem Unicode-Bau nicht (mittel)

**Fundstelle:** `Eudora71/Eudora/mainfrm.cpp:9715`.

    strZusatz.Format(_T("   [%s - %s]"), _T(EUDORA_BAU_KENNUNG), (LPCTSTR) strHerkunft);

`_T(x)` ist `__T(x)`, und `__T(x)` ist im Unicode-Bau `L##x`. Der `##`-Operator
unterbindet die Makroerweiterung seines Operanden: aus `_T(EUDORA_BAU_KENNUNG)`
wird der Bezeichner `LEUDORA_BAU_KENNUNG`, nicht die Zeichenkette. Im
MBCS-Bau — und den baut dieses Projekt — ist `_T(x)` gleich `x`, deshalb faellt
es heute nicht auf.

Richtig waere `EUDORA_BAU_KENNUNG` ohne `_T(...)` und die Zeichenkette in
`BuildKennung.h` gleich als `_T("...")` zu erzeugen, oder schlicht
`CString(EUDORA_BAU_KENNUNG)`.

**Schwere:** heute keine Auswirkung, aber eine Falle fuer jeden, der die
Zeichensatz-Einstellung anfasst. Da die Portierung genau darauf zulaeuft,
gehoert es notiert.

## PR-7 — S-7: die Zahlen und das Beispiel widersprechen sich (mittel)

**Fundstellen:** `BEFUNDE.md:2502` gegen
`tools/zeilenenden-angleichen.pl:12-14`, und `BEFUNDE.md:2526-2529`.

1. **Zwei verschiedene Messungen fuer dasselbe.**

       BEFUNDE.md:2502   4616 von 5563 verfolgten Quell- und Textdateien
       Werkzeugkopf:11   4426 von 5336 verfolgten Quelldateien

   Beide Zahlen sind mit "Am 30.08.2026 gemessen" ueberschrieben, beide meinen
   denselben Vorgang. Nachgemessen mit derselben Endungsliste, die das Werkzeug
   benutzt: `git ls-files | grep -Ei '\.(c|cpp|h|hpp|inl|rc|idl|def|mak|txt|md)$'`
   ergibt **5568** verfolgte Dateien. Das Werkzeug selbst zaehlt im Stand
   371c1e3 dieselbe Menge:

       perl tools/zeilenenden-angleichen.pl
         byteidentisch zu HEAD:         5568
         nur Zeilenenden verschieden:      0
         inhaltlich verschieden:           0
         nicht in HEAD:                    0

   Die Grundgesamtheit ist also 5568, nicht 5336 und nicht 5563. Die 5563 in
   `BEFUNDE.md` liegt nahe genug, um durch fuenf seither hinzugekommene Dateien
   erklaerbar zu sein; die 5336 im Werkzeugkopf ist um 232 Dateien daneben und
   damit falsch. Dass beide Zahlenpaare unter demselben Datum und derselben
   Beschreibung stehen, ist der eigentliche Mangel: eine der beiden ist ein
   Zwischenstand, der nicht nachgezogen wurde.

   Nebenbefund aus derselben Messung: nach dem Angleichen ist der Baum
   tatsaechlich vollstaendig byteidentisch zu HEAD (0 abweichende Dateien). Die
   Behebung von S-7 hat also gewirkt.

2. **Das Beispiel belegt das Gegenteil der Behauptung.** Oben steht: "Im
   Arbeitsverzeichnis standen sie als CRLF, im Commit als LF". Das Beispiel
   sagt:

       Index-Eintrag:  Blob 8c4fb68a...   size: 5781      (Groesse der CRLF-Fassung)
       Arbeitskopie:   Blob 8c4fb68a...   5716 Bytes      (LF, inhaltlich gleich)

   Hier ist die Arbeitskopie die LF-Fassung — umgekehrt. Und 5716 ist die
   Groesse des BLOBS, nicht die der Arbeitskopie; haette die Arbeitskopie
   wirklich 5716 Bytes mit LF, waere sie byteidentisch zum Blob und es gaebe
   nichts anzugleichen. Der Satz "Gleicher Blob-Hash, verschiedene Groesse"
   traegt deshalb nicht.

   Der stimmige Hergang ist: Index-Groesse 5781 = CRLF-Fassung = Arbeitskopie,
   Blob 5716 = LF. Die Erklaerung ueber den stat-Zwischenspeicher ist damit im
   KERN richtig (git sieht nicht hinein, solange Zeitstempel und Groesse
   passen), aber das Beispiel ist falsch beschriftet und die Richtungsangabe im
   ersten Satz widerspricht ihm.

3. **Ein Satz stimmt nicht.** "`git diff` meldete nichts, `git status` meldete
   'geaendert'." Beide lesen denselben Zwischenspeicher und denselben Index;
   sobald git die Datei einmal neu eingelesen hat, melden BEIDE die Aenderung.
   UNGEPRUEFT, unter welchen Umstaenden die beobachtete Abweichung zustande
   kam — sie ist so, wie sie dasteht, nicht nachvollziehbar.

**Behebung.** Nachmessen und die Zahlen berichtigen, das Beispiel richtig
beschriften. Nicht ausgefuehrt, weil dazu der Zustand VOR dem Angleichen
gebraucht wird und der im Arbeitsverzeichnis nicht mehr vorliegt.

## PR-8 — `rekursion-suchen.pl` kann den Fall, fuer den es gebaut wurde, nicht finden (niedrig)

**Fundstelle:** `tools/rekursion-suchen.pl:74` und `:78`.

Jede Kante wird mit dem Klassennamen der UMGEBENDEN Methode gebildet:

    my $zsig = "$klasse\::$ziel/" . argumente(...);

`$klasse` ist immer die Klasse, in deren Rumpf der Aufruf steht. Damit bleibt
jede Kante innerhalb EINER Klasse; klassenuebergreifende Zyklen sind
strukturell unsichtbar. Der Anlass — Befund S-2, ein Wechselspiel zwischen zwei
Paige-Rahmen und `CAdView` — ist genau so ein Zyklus. Das Werkzeug haette ihn
nicht finden koennen, gefunden hat ihn `stapel-untersuchen.ps1`.

Dazu kommt die im Kopf selbst eingeraeumte Ueberladungs-Unschaerfe (nur Name
und grobe Argumentzahl), die die gemeldeten Fehlalarme erzeugt hat.

**Klare Antwort auf die gestellte Frage:** in dieser Form nicht nuetzlich. Zwei
Moeglichkeiten — entweder loeschen, oder den Kopfkommentar ehrlich machen
("findet nur Selbstaufrufe innerhalb einer Klasse; klassenuebergreifende
Zyklen findet es nicht") und die Wirkung nicht ueberschaetzen. Ich empfehle
loeschen: ein Werkzeug, das nur Fehlalarme liefert und den einen echten Fall
nicht sehen kann, kostet mehr Zeit als es spart.

---

## Was nachgemessen wurde und STIMMT

### `tools/stapel-untersuchen.ps1` — Versaetze richtig, Schleife haengt nicht

**CONTEXT-Versaetze (x86).** `ContextFlags` 0, `Dr0..Dr7` 4..24,
`FLOATING_SAVE_AREA` ab 28 mit 112 Bytes (7 DWORD + `RegisterArea[80]` +
`Cr0NpxState`) endet bei 140; danach `SegGs` 140, `SegFs` 144, `SegEs` 148,
`SegDs` 152, `Edi` 156, `Esi` 160, `Ebx` 164, `Edx` 168, `Ecx` 172, `Eax` 176,
**`Ebp` 180**, **`Eip` 184**, `SegCs` 188, `EFlags` 192, **`Esp` 196**,
`SegSs` 200. Das Skript benutzt in `tools/stapel-untersuchen.ps1:141-143`
genau diese drei Werte. **Richtig belegt.**

**Die 40000-Rahmen-Schleife kann nicht haengen**
(`tools/stapel-untersuchen.ps1:172-181`). Vier unabhaengige Abbrueche: die
Zaehlergrenze, `$ebp -gt 4096`, ein fehlgeschlagenes `ReadProcessMemory`, eine
Ruecksprungadresse 0 — und vor allem `if ($neuEbp -le $ebp) { break }`. Die
EBP-Kette muss also streng steigen; damit ist jede Schleife ausgeschlossen, und
die Zahl der Speicherlesevorgaenge ist durch 40000 hart gedeckelt.

**Ein Randfall bleibt:** `[IntPtr][int]$ebp` in Zeile 174 wandelt eine
`uint32`-Adresse ueber `int`. Bei einer Stapeladresse oberhalb `0x7FFFFFFF`
(nur mit `/LARGEADDRESSAWARE` und 4GT moeglich) wirft die Wandlung. Fuer
Eudora UNGEPRUEFT, aber praktisch unerheblich.

### Werbeleiste an `IsBoxBuild()` — kein Aufrufer greift ins Leere

Geprueft wurde der GANZE Baum `Eudora71/` nach `CAdWazooBar`, `AdWazooBar`,
`IDC_AD_WAZOO_BAR`, `IsBoxBuild`:

| Fundstelle | Verhalten ohne Werbeleiste |
|---|---|
| `DockBar.cpp:53-71,98,156-196,230` | durchweg `DYNAMIC_DOWNCAST` mit `if`-Absicherung, `pAdWazooBar` bleibt `NULL` |
| `AdView.cpp:148`, `AdWazooWnd.cpp:144` | nur aus den Ad-Klassen selbst erreichbar; die entstehen nicht mehr |
| `WazooBarMgr.cpp:492` | `ASSERT(ID == IDC_WAZOOBAR_BASE+idx \|\| ID == IDC_AD_WAZOO_BAR)` — die Werbeleiste wird ZULETZT angehaengt (`WazooBarMgr.cpp:164-170`), die Indexfolge der uebrigen verschiebt sich also nicht. Haelt. |
| `WazooBarMgr.cpp:742` | `if (nBarId == IDC_AD_WAZOO_BAR) continue;` — laeuft schlicht nie |
| `eudora.cpp:1597` | derselbe `IsBoxBuild()`-Zweig, schon vorher da |

**Wichtig zum Verstaendnis:** `QCSharewareManager::IsBoxBuild()`
(`QCSharewareManager.cpp:1203-1211`) ist eine reine UEBERSETZUNGSZEIT-Weiche
(`#if DEFAULT_SWM_MODE == 2`). `DEFAULT_SWM_MODE` wird ueber
`BUILD_BOX_OR_SITE_R_VERSION` gesetzt (`QCSharewareManager.h:54-60`), und das
Makro steht in `Eudora.vcxproj:77` (Debug|Win32) UND `:130` (Release|Win32).
Die Werbeleiste entfaellt also in beiden ausgelieferten Konfigurationen — die
Behebung von S-2 greift. Wer das Makro entfernt, holt sich den Stapelueberlauf
zurueck; das gehoert in `BEFUNDE.md` zu S-2 dazu.

**UNGEPRUEFT geblieben:** eine `Eudora.ini` aus einem AELTEREN Bau kann in
`WazooBarIds` noch die Kennung der Werbeleiste tragen. Ob `LoadBarState` damit
sauber umgeht, wurde nicht gemessen.

### `mainfrm.cpp:9686` `OnUpdateFrameTitle` — keine Rekursion

`SetWindowText` schickt `WM_SETTEXT`; `OnUpdateFrameTitle` haengt nicht an
`WM_SETTEXT`, sondern wird von `CFrameWnd` bei Fenster-/Dokumentwechsel
gerufen. Es gibt keinen Rueckweg. Zusaetzlich verhindert
`if (strTitel.Find(strZusatz) < 0)` das mehrfache Anhaengen.

`GetModuleFileName`-Fehlschlag ist abgefangen: `szPfad[0]` wird vorher genullt,
`ReverseFind` liefert dann −1, `strHerkunft` wird `"?"` — und weil `"?"` nicht
leer ist, versucht es die statische Variable auch nicht bei jedem Aufruf neu.

Lange Titel: `CString` hat keine feste Grenze, `SetWindowText` auch nicht. Der
Titel waechst um hoechstens rund 40 Zeichen. Kein Befund.

Ein Schoenheitsfehler bleibt: `SetWindowText` bei JEDEM Fensterwechsel setzt
den Titel doppelt (einmal die Basisklasse, einmal hier) — ein zusaetzliches
Neuzeichnen der Titelleiste.

### `Eudora.vcxproj` PreBuildEvent bricht den Bau nicht ab

`Eudora71/Eudora/Eudora.vcxproj:63-72` und `:115-124` (beide Konfigurationen):

    perl %KENNUNG% %WURZEL% && exit /b 0
    "C:\Program Files\Git\usr\bin\perl.exe" %KENNUNG% %WURZEL% && exit /b 0
    echo WARNUNG: perl nicht gefunden - BuildKennung.h bleibt unveraendert
    exit /b 0

Fehlt perl (`errorlevel` 9009) oder bricht das Skript mit `die` ab, greift das
`&&` nicht, und der naechste Versuch laeuft. Am Ende steht immer `exit /b 0`.
**Verhaelt sich wie zugesagt.** Die Folge davon ist allerdings PR-4.

### `tools/kennung-erzeugen.pl` — Kennung ist stabil

Sie pendelt NICHT zwischen zwei Bauten: `BuildKennung.h` ist per
`!/BuildKennung\.h$/` aus der Schmutzpruefung ausgenommen
(`tools/kennung-erzeugen.pl:70-73`), und die Datei wird nur neu geschrieben,
wenn sich etwas ausser dem Zeitstempel aendert. Frischer Klon ohne git →
`ohne-git`; ohne `VERSION` → `unbekannt`; ohne perl → siehe PR-4.

---

## Stand und naechster Schritt

Abgebrochen nach etwa einem Drittel der Pruefliste. **Erledigt:**
`pruefe-bytes.pl` (drei belegte Befunde), `kennung-erzeugen.pl`,
`rekursion-suchen.pl`, `stapel-untersuchen.ps1`, alle vier Codeaenderungen von
heute, S-7.

**Offen — hier geht es weiter, in dieser Reihenfolge:**

1. **`tools/zeilenenden-angleichen.pl` unabhaengig nachpruefen.** Die
   Stichprobe von 50 Dateien (Inhalt ohne Zeilenenden gegen HEAD) wurde
   ANGESTOSSEN, aber nicht mehr zu Ende gelesen. Das Werkzeug ist beim Lesen
   des Codes unauffaellig: es schreibt woertlich den HEAD-Blob und liest
   danach zurueck (`tools/zeilenenden-angleichen.pl:112-118`), Inhalt kann es
   also gar nicht veraendern. Das ersetzt die Messung nicht.
2. **BEFUNDE.md S-1 bis S-6.** Nur S-7 wurde geprueft. Jede Zahl und jede
   Fundstelle in S-1..S-6 ist noch offen.
3. **`Eudora71/Tests`, 91 Testfaelle.** Weder gebaut noch gelaufen. Ob die
   Sammlung ueberhaupt noch uebersetzt, ist unbekannt.
4. **`utils.cpp ISOTranslate`, Grenzfaelle der Zeichensatzwandlung.** Nicht
   angesehen. Dazu gehoeren die in Punkt 3 gewuenschten neuen Testfaelle.
5. **Die drei kleinen Behebungen aus PR-1 bis PR-3** in `pruefe-bytes.pl`. Sie
   sind klein und beschrieben, aber nicht ausgefuehrt — die Schranke laeuft
   vor jedem Commit, an ihr ohne Zeit fuer eine Gegenprobe zu drehen waere
   schlechter als sie so zu lassen.

Alle Gegenproben liegen als Wegwerf-Repos unter
`%TEMP%\claude\...\scratchpad\gp`, `gp2`, `gp3` und sind aus den oben
abgedruckten Befehlen in einer Minute neu erzeugt.
