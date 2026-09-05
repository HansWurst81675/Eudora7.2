# Hier weitermachen

**Stand 06.09.2026.** Arbeitsstand ist der Zweig `fehler-nach-1010`; `main` ist
gesperrt und wird nur von Gregor per Merge bewegt. Quellfassung **7.2.0.11 /
Paket 1.0.11**, zuletzt gepackt und gestartet **7.2.0.10 / Paket 1.0.10**.

Diese Datei ist der Einstieg. **Die Arbeitsliste steht in
[AUFGABEN.md](AUFGABEN.md)**, der Maßstab in [ZIEL.md](ZIEL.md), die Belege in
[BEFUNDE.md](BEFUNDE.md) und unter `Befunde/`.

## Wo das Projekt steht

**Eudora baut, startet, ist bedienbar und ruft Mail ab.** Von Gregor selbst
bestätigt:

- **Bau aus frischem Klon in der IDE grün:** 18 erfolgreich, 0 Fehler,
  1 übersprungen, 2:37 min.
- **POP3 über Port 995 mit TLSv1.3**, *Tools → Last SSL Info*:
  `Negotiation Status: Succeeded`. Die frühere Einschränkung „nur über Port 110"
  ist damit überholt.
- Fenster, Menüs, Werkzeugleiste, Bau-Kennung im Titel, Fortschritt beim Abruf,
  Umlaute in HTML-Mail.

**Was ihn jetzt aufhält** — vier Fehler in der Bedienung, an dreien arbeiten
Agenten: Strg-N stürzt ab, Doppelklick öffnet keine Nachricht, Suchtreffer sind
nicht anklickbar, und es kommt die Meldung „Encountered an improper argument".

**Kriterium 0 hat sich nicht bewegt** und ist das einzige, das noch nie gemessen
wurde: das ZIP auf einem Rechner **ohne** Visual Studio auspacken und starten.

## Zuletzt dazugekommen

| Befund | Was |
|---|---|
| **E-25** | Absturz nach *Weiter* im Kontoassistenten: **Doppelfreigabe in `NSImport`**. Belegt durch die Windows-Fehlerberichte — `0xC0000374` (`STATUS_HEAP_CORRUPTION`), Fehlermodul `ntdll.dll`, letztes geladenes Modul `NSImport.eif`. Behoben, **ungeprüft**. Einzelheiten in `Befunde/ASSISTENT.md` |
| **E-24** | „In" stand zweimal unter *Recent*: `s_RecentMailboxList` hält per Entwurf nur Zeiger, der Ersatzeintrag legte einen Zeiger auf eine **temporäre** `CString` ab (`QCMailboxDirector.cpp:2560`). Behoben, **ungeprüft**; `:1316` mitbehoben |
| **X-5** | Schranke gegen Commits auf einen toten Zweig: `tools/pruefe-branch.pl`, im `pre-commit`-Hook als **erster** Schritt, 15 Testfälle |
| **X-6** | `tools/bauen.ps1` — bauen, ohne belogen zu werden. Anlass: ein Lauf meldete EXITCODE 0, ohne gebaut zu haben |

> ### E-11 ist zurückgenommen
>
> **E-11 (`ReleaseBuffer` ohne `GetBuffer` in `eudora.cpp:3372`) war nie die
> Ursache des Absturzes im Kontoassistenten.** Die Ursache ist **E-25**. Wer in
> einer älteren Datei liest, der Assistenten-Absturz hänge an E-11, liest einen
> überholten Stand — die Stellen sind in [Befunde/LEKTOR.md](Befunde/LEKTOR.md)
> aufgeführt.
>
> **Die Fehlerklasse R-1 bleibt bestehen.** `ReleaseBuffer` ohne `GetBuffer` ist
> bei MFC 14 wirklich unzulässig, und 24 Stellen sind noch zu ändern
> (`AUFGABEN.md`, A2). Sie ist nur nicht *dieser* Absturz.

## Die Lehre, die sich zweimal wiederholt hat

Die naheliegende Erklärung war dreimal falsch, und dreimal hat eine **Messung**
sie widerlegt, nicht ein besseres Argument:

- **E-4**: der Verdacht lag beim Beenden, weil die Meldung dort kam. Die Ursache
  lag beim **Start**, in einem ungeprüften C-Cast.
- **E-13**: „der Andockumbau hat die Leiste zerstört" — in Wahrheit dauerte der
  Abruf 0,02 s, und beide Fortschrittsanzeigen blenden sich unter
  `ProgressIdle` = 3 s gar nicht erst ein. Gregors eigenes `eudora.log` hat vier
  Verdächtige auf einmal entlastet.
- **E-25**: „hier fehlt eine NULL-Prüfung" — der Fehlercode `0xC0000374` sagt
  Heap-Beschädigung, also eine Doppelfreigabe, und entlastet damit jede
  NULL-Prüfung.

**Ein Anwenderprotokoll oder ein Windows-Fehlerbericht ist billiger als vier
Bauten.**

## Der nächste Schritt

Steht in [AUFGABEN.md](AUFGABEN.md) ganz oben:

1. Die **vier Bedienfehler** — Strg-N, Doppelklick, Suchtreffer, „improper
   argument".
2. Produktversion hochzählen, mit `tools/bauen.ps1` bauen, mit
   `tools/paket-bauen.ps1` packen, **nicht** veröffentlichen.
3. Einmal durchsehen — ein Lauf beantwortet E-25, E-24, E-4 und E-12 auf einmal.
4. Das ZIP auf einem Rechner **ohne** Visual Studio starten: Kriterium 0.

## Nach einem frischen Klon: vier Schritte

```bash
git config core.autocrlf false
sh tools/hooks-einrichten.sh
perl tools/zeilenenden-angleichen.pl --aendern
git ls-files -z | xargs -0 -n 400 git add --
```

Keiner davon ist wahlfrei. Ohne den Hook treten drei Fehlerklassen lautlos
wieder auf; er liegt unter `.git/hooks` und wird von git nicht mitversioniert.
Ein alter Hook aus einem früheren Klon verschluckt den Abbruch weiterhin.

## Nachprüfbar, alles ohne Compiler

```sh
perl tools/pruefe-bytes-tests.pl        # 35 Faelle
perl tools/pruefe-branch-tests.pl       # 15 Faelle, je zwei Durchlaeufe
perl tools/releasebuffer-pruefen.pl     # 06.09.2026: 116 ok / 19 falsch / 4 lockbuffer / 1 danach
perl tools/zeilenenden-angleichen.pl    # misst nur; --aendern greift ein
perl tools/pruefstand-melden.pl         # drei Marken
```

**Achtung bei `zeilenenden-angleichen.pl`:** „0 Abweichungen" gilt **nur** in
einem frischen Klon mit `core.autocrlf=false`. In einer gewachsenen Arbeitskopie
liegen Hunderte Dateien als CRLF vor, während in HEAD LF steht — git meldet
nichts, solange niemand sie anfasst. Das ist eine Eigenschaft der
**Arbeitskopie**, nicht des Repos (Befunde S-7, X-4).

## Wie man Eudora startet

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Das Mailverzeichnis **muss eine `Eudora.ini` enthalten**, sonst bricht Eudora in
`eudora.cpp:3542` ab. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`.

Der **Release**-Bau braucht nur die drei verteilbaren Laufzeit-DLLs, die im
Paket liegen. Für den **Debug**-Bau müssen vorher vier nicht verteilbare DLLs
dazugelegt werden (`tools/laufzeit-holen.ps1`) — Einzelheiten in
[README.md](README.md), Abschnitt „Nur für den Debug-Bau".

**Wichtig:** Gregor testet auf derselben Windows-Sitzung. Kein Programm mit
Fenstern ohne Absprache starten — auch nicht durch Agenten. Beim Aufräumen von
Prozessen **immer nach Pfad filtern**, sonst schießt man seine laufende Sitzung
mit ab.

## Konto einrichten ohne Menü

Über die `Eudora.ini` im Mailverzeichnis, Abschnitt `[Settings]`:

```ini
POPAccount=benutzername@pop.anbieter.de
LoginName=benutzername
RealName=Name
ReturnAddress=adresse@anbieter.de
SMTPServer=smtp.anbieter.de
SmtpAuthAllowed=1
SSLReceiveUse=2
SSLPOPAlternatePort=995
SSLSendUse=2
SSLSMTPAlternatePort=465
```

`SSLReceiveUse`/`SSLSendUse` sind der Index der Auswahlliste aus
[settings.cpp:1978](Eudora71/Eudora/settings.cpp:1978): 0 nie, 1 falls verfügbar
(STARTTLS), 2 erforderlich mit eigenem Port, 3 erforderlich (STARTTLS). Der Weg
mit Port 995 und `SSLReceiveUse=2` ist am 06.09.2026 im Betrieb belegt.

Das Passwort landet als `SavePasswordText` **Base64-kodiert, nicht
verschlüsselt** in derselben Datei ([password.cpp:544](Eudora71/Eudora/password.cpp:544)).

## Was ohne Visual Studio geht — und was nicht

**Geht vollständig, mit Nachweis:**

| Arbeit | warum sie ohne Compiler abschließbar ist |
|---|---|
| Die Werkzeuge unter `tools/` | perl und git reichen. `tools/pruefe-bytes-tests.pl` und `tools/pruefe-branch-tests.pl` beweisen jede Änderung an einer Schranke — rot vorher, grün nachher |
| Quelltextanalyse über den ganzen Baum | `releasebuffer-pruefen.pl` und `suche-zeiger.pl` sind so entstanden. Fundstellen, Einstufungen, Funktionsgrenzen: alles Text |
| Der Paketprüfer (`paket-pruefen.ps1`, PR-2.0) | im Klon liegen **101 PE-Dateien**. Ein Import-Leser lässt sich gegen echte x86-Binärdateien entwickeln; nur die `.ps1` selbst läuft ohne PowerShell nicht |
| Doku und Nachrechnen | grep-Arbeit. Befund Z-1 hat gezeigt, dass 11 von rund 40 geprüften Angaben falsch waren |

**Braucht zwingend Windows mit Visual Studio 2022:** jeder Bau, jeder Start,
jedes Bildschirmfoto, die Komponententests (MFC/MBCS über MSBuild),
`stapel-untersuchen.ps1` (32-Bit-PowerShell) und `laufzeit-holen.ps1`.

**Die Grenze, die dabei einzuhalten ist:** eine C++-Änderung, die ohne Compiler
entsteht, ist **ungeprüft**, weil sie nicht übersetzt. In genau dieser Lücke hat
sich das Projekt am 31.08. dreimal geirrt (E-2, E-5, E-8). Deshalb: C++ nur mit
ausdrücklichem UNGEPRÜFT-Vermerk in Commit und Befund.

## Fallen im Arbeitsverzeichnis

- **Quelldateien sind Latin-1 mit gemischten Zeilenenden.** Nur byte-erhaltend
  ändern: `tools/aendere-zeile.pl`, `tools/ersetze-bereich.pl`. Niemals `sed`
  ohne `-b`, nicht das Edit-Werkzeug auf bestehende Quellen.
- **Die `.md` sind UTF-8 mit LF.** Auch hier nicht das Edit-Werkzeug: es hat am
  05.09.2026 die README an 238 Stellen doppelt kodiert. Nach jedem Schreibzugriff
  messen — CR-Zahl gegen HEAD und keine Folge `C3 83` / `C3 A2` / `EF BF BD`.
  `perl tools/pruefe-bytes.pl` prüft beides selbst (Regel 5).
- **`grep -c $'\r'` misst Zeilenenden NICHT zuverlässig** — es zählt in Git Bash
  schlicht alle Zeilen. Immer mit Perl und `:raw` messen.
- **Bauen nur in der PowerShell**, und über `tools/bauen.ps1`. Die Git-Bash macht
  aus `/p:Configuration=Debug` einen Pfad. `/p:BuildProjectReferences=false`
  wird seit dem 05.09.2026 **nicht mehr gebraucht** (B-3).
- **`$(SolutionDir)` zeigt beim Einzelprojekt-Bau auf das Projektverzeichnis**,
  nicht auf die Solution. `$(ProjectDir)..\..` benutzen.
- **`perl` ist im MSBuild-Pfad nicht vorhanden.** Es liegt unter
  `C:\Program Files\Git\usr\bin\perl.exe`.
- **`&` muss in `.vcxproj` als `&amp;` geschrieben werden** — sonst lädt MSBuild
  die Projektdatei nicht mehr.
- **Es kann systemweit nur einen OutputDebugString-Mithörer geben**
  (`DBWIN_BUFFER`). Zwei gleichzeitig, und beide bekommen nichts.
- **Include-Wächter sind alles-oder-nichts.** Wer nur einen Teil eines
  Stingray-Headers ersetzt, darf den Wächter nicht setzen. Ausführlich in
  `Eudora71/OTShim/PLAN.md`.
- **Ein Arbeitsbaum je Agent.** Ein geteilter Index beschädigt fremde Commits;
  sonst nur mit Pfadangabe stagen, nie `git add -A`.

## Zurückgestellt — nicht von selbst aufgreifen

`tools/patches/zertifikatspruefung-verschaerfen.patch` (Hostnamensprüfung und
Umgang mit `X509_V_ERR_CERT_UNTRUSTED` in QCSSL) ist vorbereitet, aber **nicht
angewendet**. Gregor hat entschieden, das später anzugehen. Nicht ohne sein
Wort anwenden.

## Wo die Vorgeschichte steht

Diese Datei sagt, was jetzt gilt. Der Weg dorthin — der Stapelüberlauf beim
Start (S-2), die toten Menüs (M-1), das Erscheinungsbild (A-1), die
VC-7.1-Brücke (B-1/B-2), der Release-Bau (F-1), die Werkzeugrunden (X-1 bis
X-6) — steht in [BEFUNDE.md](BEFUNDE.md), in `Befunde/*.md` und in den
Prüfberichten (`PRUEFBERICHT.md`, `PRUEFUNG-BAU.md`, `PRUEFUNG-CODE.md`,
`PRUEFUNG-BRANCH.md`, `Pruefung/*.md`). Welche Stellen dort noch einen
überholten Stand behaupten, steht in [Befunde/LEKTOR.md](Befunde/LEKTOR.md).
