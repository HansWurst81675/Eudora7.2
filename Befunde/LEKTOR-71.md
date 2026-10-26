# <a id="lektor-71"></a>LEKTOR-71 — Teil 0 der Prüfanleitung und die Berichtigungen aus LEKTOR-70, Zweig `vor-testpaket-7.2.0.123` bis `71006e5a`, 26.10.2026

**Auftrag.** Kurzer Lauf vor dem PR an Gregor: Stand der sechzehn Funde aus
[LEKTOR-70](LEKTOR-70.md#lektor-70) (eingearbeitet in `3cbc3426`); alles, was
seit `e3578897` geändert wurde (gemessen: `git log --stat e3578897..HEAD` —
`3cbc3426` Einarbeitung, `efc42028` Paket geschnürt, `71006e5a` Eintrag in
`tools/AGENTEN-LAUFEN.md`); jeder Schritt von *Teil 0* in `Intern/TESTPLAN.md`
gegen `eudora.cpp`. Maßstab ist Gregors Regel vom 26.10.2026: jede Information
steht an **einer** Stelle, andere Dateien verlinken. Ein Widerspruch heißt hier
**falsch**.

**Ergebnis vorweg.** **10 Funde** (3 falsch, 2 unvollständig, 1 veraltet,
4 Hinweise). Von den sechzehn Funden aus [LEKTOR-70](LEKTOR-70.md#lektor-70) sind elf erledigt und fünf
teilweise. **Die E-132-Rückfrage kommt in Teil 0 A wirklich** — die Kette ist
unten Schritt für Schritt am Quelltext belegt. Für das Testpaket zählen vor
allem zwei Funde:

1. **Teil 0 B überschreibt das Protokoll von M1.** Kopiert Gregor den Inhalt
   seines Mailverzeichnisses aus 1.0.122 „überschreibend“ hinein, ersetzt dessen
   `eudora.log` (gemessen: 51.314 Byte, vom 25.10.2026) das Protokoll, in das
   M1 Schritt 4 eben die beiden Zeilen `E-132 Startverzeichnis:` geschrieben
   hat. Damit ist der Nachweis zu M1 weg ([L-71.1](#l-71.1)).
2. **Der Kopf des Testplans sagt „Starten immer mit `Eudora starten.cmd`“, und
   zwölf Zeilen tiefer verlangt Teil 0 A, `Eudora.exe` doppelzuklicken.**
   Folgt Gregor dem Kopf, kommt keine Rückfrage ([L-71.2](#l-71.2)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Mechanisch

Gemessen am 26.10.2026 im Arbeitsbaum `Eudora7.2-wt-lektor` auf `71006e5a`
(nach `git fetch` und `git merge --ff-only origin/vor-testpaket-7.2.0.123`).
Zitiert, nicht als Urteil übernommen; keiner der Funde unten wird von diesen
Werkzeugen gemeldet.

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | *„Kein Widerspruch gefunden.“*; 16 Hinweise *„nennt weder den Quellstand 7.2.0.123 noch die Paketnummer 1.0.123“*, alles Archiv- und Nachschlagedateien wie in [LEKTOR-70](LEKTOR-70.md#lektor-70). **Nicht gemeldet:** [L-71.4](#l-71.4) |
| `perl tools/ziel-stand.pl` | *„ziel-stand: 23 von 23 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* |

## Funde aus LEKTOR-70

| Fund | worum es ging | Stand heute | Beleg |
|---|---|---|---|
| [L-70.1](LEKTOR-70.md#l-70.1) | „Was bekannt ist“ im Testplan nannte drei behobene Fehler | **erledigt** | `TESTPLAN.md:317-321`: der Abschnitt verweist nur noch auf die [README unter „Bekannte Fehler“](../README.md#bekannte-fehler) |
| [L-70.2](LEKTOR-70.md#l-70.2) | `WEITERMACHEN.md` nannte zwei Quellstände | **teilweise**: Zeile 9 ist berichtigt, Zeile 10 passt jetzt nicht mehr dazu ([L-71.4](#l-71.4)) | `WEITERMACHEN.md:9` *„**7.2.0.123** … Davor 7.2.0.122“* |
| [L-70.3](LEKTOR-70.md#l-70.3) | Einleitung zu *Bekannte Fehler* gegen die E-141-Zeile | **erledigt** | `README.md:145` *„Die zweite Spalte sagt, was dabei verlorengehen oder verfälscht werden kann“*; `:177` auf *Entwurf* und *Yes* eingegrenzt |
| [L-70.4](LEKTOR-70.md#l-70.4) | [E-142](../Intern/BEFUNDE.md#e-142): „Behoben wird das nicht“ gegen „dann beheben“ | **teilweise**: nur *Was noch fehlt* geändert, die Kurzfassung nicht ([L-71.5](#l-71.5)) | `BEFUNDE.md:378` |
| [L-70.5](LEKTOR-70.md#l-70.5) | Titel von [E-139](../Intern/BEFUNDE.md#e-139) | **erledigt**, auch in den erzeugten Tabellen | `BEFUNDE.md:389`, `CHANGELOG.md:35`, `WEITERMACHEN.md` (erzeugter Block) *„nach jedem Programmstart einmal“* |
| [L-70.6](LEKTOR-70.md#l-70.6) | `ZIEL.md` oben „alle erfüllt“, unten „zwei fast“ | **teilweise**: `:203-207` nennt jetzt nur noch die Meldung und sagt, [E-77](../Intern/BEFUNDE.md#e-77) sei behoben; der erzeugte Block `:44`, `:50` zählt „behoben, von Gregor noch nicht bestätigt“ ([E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119)) weiter als erfüllt. Das ist die Werkzeugfrage aus [L-61.1](LEKTOR-61.md#l-61.1) und wird hier nicht neu gezählt | `ZIEL.md:203-207` |
| [L-70.7](LEKTOR-70.md#l-70.7) | woher Gregors Daten kommen, `rootcerts.p7b` | **erledigt** (Teil 0 B, Protokollzeile nennt das Programmverzeichnis); dabei neu entstanden ist [L-71.1](#l-71.1) | `TESTPLAN.md:42-47`, `:111` |
| [L-70.8](LEKTOR-70.md#l-70.8) | M1 ohne Vorbereitung und in der falschen Reihenfolge | **erledigt** (Teil 0 A; Änderungsdatum statt SHA256); neu: [L-71.2](#l-71.2), [L-71.3](#l-71.3) | `TESTPLAN.md:25-40`, `:82` |
| [L-70.9](LEKTOR-70.md#l-70.9) | N1/N2 ohne *File → Close*, Spurmarken nicht im Protokoll | **erledigt** (N1b, Protokollzeile). Den Knopf *Close Window* aus Gregors Entscheidung prüft keine Zeile; er läuft über denselben `ID_FILE_CLOSE` (Vermutung) | `TESTPLAN.md:70`, `:111`; `mainfrm.cpp:3432-3445` |
| [L-70.10](LEKTOR-70.md#l-70.10) | N3 ohne Ordnernamen, ohne Warnung vor *Yes* | **erledigt** | `TESTPLAN.md:72` *„**IMAP** `Gelöscht` (der Papierkorb unter deinem GMX-Konto, nicht das lokale `Trash`)“*, *„**Nicht Yes**“* |
| [L-70.11](LEKTOR-70.md#l-70.11) | N5 ohne Blick auf den Server | **erledigt** | `TESTPLAN.md:74` *„im GMX-Webmailer nachsehen“* |
| [L-70.12](LEKTOR-70.md#l-70.12) | drei Stand-Zeilen von vorgestern | **teilweise**: `README.md:99` und `ZIEL.md:170` berichtigt; `WEITERMACHEN.md:142` und `:3` nicht ([L-71.6](#l-71.6)) | |
| [L-70.13](LEKTOR-70.md#l-70.13) | „Neu im Testpaket“ in der README unvollständig | **erledigt**: nur noch ein Verweis auf den CHANGELOG; Rest siehe [L-71.10](#l-71.10) | `README.md:136-138` |
| [L-70.14](LEKTOR-70.md#l-70.14) | Inhalt von 7.2.0.123 an fünf Stellen | **erledigt** für README und `PAKETE.md` (beide verweisen) | `README.md:137`, `Releases/PAKETE.md:173` |
| [L-70.15](LEKTOR-70.md#l-70.15) | [E-146](../Intern/BEFUNDE.md#e-146) trägt den alten Fehler im Präsens | **teilweise**: jetzt im Präteritum, aber weiterhin zweimal ([L-71.9](#l-71.9)) | `BEFUNDE.md:385` |
| [L-70.16](LEKTOR-70.md#l-70.16) | Prüfbericht verweist auf die Buchführung, Bau nicht sauber | **erledigt**: Verweis auf die Ergebnistabelle, Bericht aus sauberem Baum `3cbc3426`; zwischen dem geprüften Bau `82372232` und `efc42028` hat sich unter `Eudora71/` nichts geändert (gemessen: `git diff --stat 82372232..efc42028 -- Eudora71` leer), und `PAKETE.md` meldet `Eudora.exe` byte-gleich mit dem Bau | `PRUEFBERICHT.md:5`, `:457-459`; `PAKETE.md:168` |

---

## Die Frage aus dem Auftrag: kommt die E-132-Rückfrage in Teil 0 A?

**Ja**, wenn Gregor die Schritte so fährt, wie sie dastehen (belegt). Die Kette:

1. **Wer schreibt `HKCU\Software\Qualcomm\Eudora\CommandLine\Current`?**
   `CEudoraApp::RegisterCommandLine` (`eudora.cpp:3720-3756`), und zwar bei
   **jedem** gewöhnlichen Start, nicht beim Beenden: `InitInstance` ruft sie im
   `default`-Zweig ohne Automation nach `GetDirs` (`:1067`). Sie schreibt die
   **eigene** Befehlszeile in Kurzform: *„`sprintf(val, "%s %s %s", app, eDir,
   (const char *)iniPath)`“* (`:3742`). A.1 (1.0.122 mit seinem
   `Eudora starten.cmd`) setzt also `Current` auf 1.0.122 — egal, was vorher
   gestartet wurde.
2. **A.3, Doppelklick auf `Eudora.exe` im 1.0.123:** die Befehlszeile ist leer,
   neben der EXE liegt keine `Eudora.ini` (das Paket legt sie nach
   `Mailverzeichnis`, `tools/Eudora starten.cmd`, Kopfkommentar), also
   `StartEudoraWithDefaultLocation` (`:1051-1057`).
3. Dort liest Eudora `Current` (`:4044-4072`), zerlegt die Zeile
   (`E132AufrufZerlegen`, `:4149`), bringt beide Seiten in die Langform
   (`:4154-4160`) und findet in 1.0.122 eine `Eudora.ini` (`bIniDa`, `:4192`).
   `E132IstFremdesVerzeichnis` (`:3835-3880`) meldet *fremd*, weil
   `…\Eudora72-1.0.122-release\Mailverzeichnis` nicht unter
   `…\Eudora72-1.0.123-release\` liegt.
4. **Ein gemerkter Merker würde die Rückfrage verschlucken** (`:4237-4251`,
   aus der `DEudora.ini` neben der EXE). Das Paket legt dort
   `tools/DEudora.ini` hin (`tools/paket-bauen.ps1:604`); die enthält weder
   `E132Abgelehnt` noch `E132Angenommen` noch `UseAppData` (gemessen: `grep`
   ohne Treffer). `paket-pruefen.ps1` startet Eudora nicht, es liest nur die
   Abhängigkeiten. Die `DEudora.ini` im Testverzeichnis selbst habe ich nicht
   gelesen (Gregors Verzeichnis, nur `eudora.log` ist abgesprochen).
5. **Schritt 3 (Cancel)** kehrt mit `FALSE` zurück (`:4304-4308`), bevor
   `RegisterCommandLine` läuft, und merkt nichts (Kommentar `:4286-4288`
   *„Nur ‚Abbrechen‘ wird nicht gemerkt“*). `Current` zeigt danach weiter auf
   1.0.122 — **Schritt 4 fragt also wieder**, sofern Gregor erneut
   `Eudora.exe` doppelklickt.
6. **Protokoll:** die Zeilen aus Schritt 4 schreibt Eudora mit
   `DEBUG_MASK_MISC` = `0x8000` (`QCUtils/public/inc/debug.h:36`); die
   Vorgabe-`Eudora.ini` im Paket trägt `LogLevel=58527` = `0xE49F`
   (`paket-bauen.ps1:628`), der Schalter ist enthalten. Sie landen in
   `eudora.log` **im Mailverzeichnis** (`InitDebug(…, EudoraDir, …)`,
   `eudora.cpp:1196-1200`, ausgegeben in `:1213`) — siehe [L-71.1](#l-71.1).

Nebenbei gemessen (gelesen: Gregors `eudora.log` in 1.0.122, abgesprochen):
die Zeile *„LogLevel 58527 (0xE49F)“* steht dort. Bringt Teil 0 B seine
`Eudora.ini` mit, bleibt der Schalter 32768 also an — die Vermutung aus
[L-70.7](LEKTOR-70.md#l-70.7) ist damit gemessen.

---

## <a id="l-71.1"></a>L-71.1 — unvollständig: Teil 0 B überschreibt das Protokoll, in dem M1 Schritt 4 seinen Nachweis hinterlassen hat

* `Intern/TESTPLAN.md:42-45` (belegt): *„Der Inhalt von
  `C:\Users\Gregor\Eudora72-1.0.122-release\Mailverzeichnis` in
  `C:\Users\Gregor\Eudora72-1.0.123-release\Mailverzeichnis` kopieren
  (überschreiben).“* Die einzige Ausnahme ist `rootcerts.p7b`.
* M1 Schritt 4, `TESTPLAN.md:633` (belegt): *„Im Protokoll stehen `[E-132](../Intern/BEFUNDE.md#e-132)
  Startverzeichnis: … fremd=1` und danach `[E-132](../Intern/BEFUNDE.md#e-132) Startverzeichnis: eigenes
  gewaehlt="…"`“.* Diese Zeilen schreibt Eudora in das `eudora.log` des
  **neuen** Mailverzeichnisses (belegt, `eudora.cpp:1196-1200`).
* Gemessen: `C:\Users\Gregor\Eudora72-1.0.122-release\Mailverzeichnis\eudora.log`
  gibt es (51.314 Byte, 25.10.2026 19:32), und A.1 schreibt kurz vorher noch
  hinein. Im neuen Mailverzeichnis gibt es noch keins (gemessen, vor Gregors
  Test).

Nach B steht im neuen Verzeichnis das Protokoll von 1.0.122. Der Hauptagent
liest danach `eudora.log` (`TESTPLAN.md:19-21`) und findet zu M1 entweder
nichts oder die Zeilen eines **früheren** 1.0.122-Starts. Gregors Protokoll
von 1.0.122 enthält selbst eine Zeile `E-132 Startverzeichnis: gefunden=…`
(gemessen) — wer nur nach dem Text sucht, sieht einen Nachweis, der keiner ist.
Die Ergebniszeile *Protokoll* (`:111`) nennt die E-132-Zeilen auch nicht.

**Was zu tun wäre:** in B *„`eudora.log` nicht mitkopieren“* (wie
`rootcerts.p7b`); in die Zeile *Protokoll* `E-132 Startverzeichnis: … fremd=1`
und `eigenes gewaehlt=` aus M1 aufnehmen.

## <a id="l-71.2"></a>L-71.2 — falsch: der Kopf sagt „Starten immer mit `Eudora starten.cmd`“, Teil 0 A sagt „`Eudora.exe` doppelklicken“

* `Intern/TESTPLAN.md:10` (belegt): *„**Starten immer mit `Eudora starten.cmd`**
  im neuen Verzeichnis.“*
* `:35-36` (belegt): *„Im neuen Verzeichnis
  `C:\Users\Gregor\Eudora72-1.0.123-release` die **`Eudora.exe`
  doppelklicken**“*; ebenso M1 Schritt 1 (`:630`) *„nicht `Eudora starten.cmd`,
  denn das übergibt das Verzeichnis und schneidet den Weg ab“*.

Der Kopf steht über Teil 0 und ist das Erste, was Gregor liest. Startet er in
A.3 mit `Eudora starten.cmd`, kommt keine Rückfrage, und er meldet M1 als
durchgefallen. **Was zu tun wäre:** *„Ab Teil 0 C immer mit `Eudora
starten.cmd`“* — oder den Satz nach Teil 0 schieben, wo C ihn schon sagt
(eine Stelle).

## <a id="l-71.3"></a>L-71.3 — unvollständig: nach M1 Schritt 4 erscheint der Kontoassistent, Teil 0 A.4 sagt es nicht

* `TESTPLAN.md:39-40` (belegt): *„Nach Schritt 4 läuft Eudora mit einem
  eigenen, leeren Mailverzeichnis. Mit *File → Exit* beenden.“*
* `eudora.cpp:1677-1685` (belegt): *„Put up New Account Wizard only if no
  account is set up at all“* — ohne Absenderadresse in irgendeiner
  Persönlichkeit schickt Eudora `ID_SPECIAL_NEWACCOUNT`. Das leere
  Mailverzeichnis des Pakets hat kein Konto (`PAKETE.md:166` *„leer bis auf
  `Eudora.ini` mit `LogLevel=58527`“*; dass darin kein Konto steht:
  Vermutung).
* Der Prüfstand kennt das: `tools/messen-k9.ps1:45` *„Kontenassistenten
  wegraeumen, er haelt sonst die Botschaften auf“*, ebenso
  `tools/messen-e77-umbenennen.ps1:171` (belegt).

Gregor bekommt nach *No* einen Assistenten vor das Hauptfenster, von dem die
Anleitung nichts sagt. Ob davor noch der Einführungsdialog
(`IDD_INTRODUCTION`, `eudora.cpp:1652-1671`) kommt, hängt an `SeenIntro` in der
Vorgabe-`Eudora.ini` — nicht gemessen. **Was zu tun wäre:** in A.4 *„Es
erscheint der Kontoassistent: mit *Abbrechen* schließen, dann *File → Exit*.“*

## <a id="l-71.4"></a>L-71.4 — falsch: `WEITERMACHEN.md` nennt 7.2.0.122 und 7.2.0.121 als „davor“

* `Intern/WEITERMACHEN.md:9`, Zeile *Quellstand* (belegt, geändert in
  `3cbc3426`): *„**7.2.0.123** … Davor 7.2.0.122, Zweig
  `e-14-gemessen-und-rollen` — [E-125](../Intern/BEFUNDE.md#e-125) … davor in 7.2.0.121 [E-111](../Intern/BEFUNDE.md#e-111)“*.
* `:10`, Zeile *Quellstand davor* (belegt, unverändert): *„7.2.0.121 ([E-111](../Intern/BEFUNDE.md#e-111),
  nie einzeln geschnürt)“*.

Dieselbe Tabelle nennt für denselben Vorgänger zwei Stände, und 7.2.0.121
erscheint zweimal. Das ist der Rest von [L-70.2](LEKTOR-70.md#l-70.2), dessen
Vorschlag war: *„der Rest der Zeile … gehört in die Zeile *Quellstand
davor*“*. **Was zu tun wäre:** in Zeile 9 nur 7.2.0.123 lassen; Zeile 10 mit
*„7.2.0.122 ([E-125](../Intern/BEFUNDE.md#e-125), als Paket 1.0.122 von Gregor am 23.10.2026 geprüft);
davor 7.2.0.121 …“* beginnen.

## <a id="l-71.5"></a>L-71.5 — falsch: E-142 sagt weiter „Behoben wird das nicht“ und am Ende „Nach 7.2.1: … dann beheben“

* `Intern/BEFUNDE.md:378`, Kurzfassung (belegt, unverändert): *„Behoben wird
  das nicht — vereinbart ist ein Hinweis, eingebaut am 26.10.2026.“*
* Dieselbe Zeile, *Was noch fehlt* (belegt, geändert in `3cbc3426`): *„vor
  7.2.1 nichts — vereinbart ist der Hinweis, und der ist eingebaut. **Nach
  7.2.1:** die Ursache der leeren Kopie messen …, dann beheben.“*

Die Commit-Nachricht von `3cbc3426` führt [L-70.4](LEKTOR-70.md#l-70.4) als
berichtigt. Berichtigt wurde aber nur eine der beiden Hälften, und [LEKTOR-70](LEKTOR-70.md#lektor-70)
hatte ausdrücklich *„Eins von beiden“* verlangt — gemeint war: die beiden
Sätze aufeinander abstimmen. Die Kurzfassung ist die Stelle, die Gregor liest
(Lehre *Befund in Klartext*). **Was zu tun wäre:** *„Behoben wird das vor
7.2.1 nicht“*.

## <a id="l-71.6"></a>L-71.6 — veraltet: `WEITERMACHEN.md` kündigt das Schnüren noch als nächsten Schritt an

* `Intern/WEITERMACHEN.md:142` (belegt): *„Als Nächstes: Fassung 7.2.0.123 /
  1.0.123 setzen, bauen, Prüfstand und Prüfbericht, Testpaket schnüren,
  Prüfanleitung in `TESTPLAN.md` (je Kriterium), PR an Gregor.“* — bis auf den
  PR erledigt (gemessen: `efc42028` *„Paket 1.0.123 geschnuert“*,
  `Releases/PAKETE.md:161` *„Geschnürt am 26.10.2026 um 09:18“*).
* `:12`, Zeile *Paketnummer* (belegt): *„**1.0.123** … Testpaket für Gregors
  Test vor dem Release 7.2.1 … Das Paket davor wurde am 23.10.2026 geschnürt
  und liegt bei Gregor“* — dass 1.0.123 selbst geschnürt ist und bei ihm
  liegt, steht nur in `PAKETE.md`.
* `:3` (belegt): *„**Stand 25.10.2026.**“*

Rest von [L-70.12](LEKTOR-70.md#l-70.12). **Was zu tun wäre:** `:142` auf
*„Paket geschnürt (siehe PAKETE.md); offen: PR an Gregor, sein Test, dann
Release 7.2.1.<n>“*; in `:12` ein Verweis auf `PAKETE.md` statt einer eigenen
Angabe.

## <a id="l-71.7"></a>L-71.7 — Hinweis: Teil 0 A begründet die Reihenfolge mit „Windows“ und strenger, als der Code verlangt; M1 Schritt 4 sagt nicht, wie neu gestartet wird

* `TESTPLAN.md:25-28` (belegt): *„Wird das neue Paket vorher über `Eudora
  starten.cmd` gestartet, merkt sich Windows das neue Verzeichnis, und die
  Rückfrage aus M1 kommt zu Recht nicht mehr.“*
* Das merkt sich **Eudora**, nicht Windows (`RegisterCommandLine`,
  `eudora.cpp:3720-3756`), und A.1 überschreibt es ohnehin wieder (siehe oben,
  Punkt 1). Was die Rückfrage tatsächlich dauerhaft abstellt, ist eine
  gemerkte Antwort in der `DEudora.ini` des Pakets (`:4237-4251`), und die
  entsteht nur durch *Yes* oder *No* im Dialog selbst.
* M1 Schritt 4 (`:633`) sagt nur *„Neu starten, **No** wählen“*. Nach *Cancel*
  zeigt `Current` weiter auf 1.0.122, also fragt Eudora wieder — aber nur bei
  einem erneuten **Doppelklick auf `Eudora.exe`**, nicht mit `Eudora
  starten.cmd` (das übergibt das Verzeichnis, `:1049-1058` überspringt dann
  die Suche).

Die Anleitung führt trotzdem zum richtigen Ergebnis, weil A.1 vor A.3 steht.
**Was zu tun wäre:** *„merkt sich Eudora in der Registry“*; in M1 Schritt 4
*„wieder `Eudora.exe` doppelklicken, **No** wählen“*.

## <a id="l-71.8"></a>L-71.8 — Hinweis: M1 nennt veraltete Zeilennummern

* `TESTPLAN.md:635` (belegt): *„Eudora schreibt `E132Abgelehnt=<Verzeichnis>`
  in die `DEudora.ini` neben dem Programm (`eudora.cpp:4241`), und jeder
  weitere Start liest sie … (`:4191`, …)“*.
* Gemessen (`grep -n`): geschrieben wird in `eudora.cpp:4292-4293`, gelesen in
  `:4242-4243`. Die Zeilen 4191 und 4241 sind leer.

**Was zu tun wäre:** Funktionsnamen statt Zeilen (*„`StartEudoraWithDefaultLocation`,
`WritePrivateProfileString(… "E132Abgelehnt" …)`“*), die verschieben sich nicht.

## <a id="l-71.9"></a>L-71.9 — Hinweis: E-146 beschreibt den alten Fehler weiter zweimal, und „Für Gregor ist nichts zu tun“ steht neben N5

* `Intern/BEFUNDE.md:385` (belegt): *„Bis 7.2.0.122: benannte man auf einem
  IMAP-Server ohne Ordnerhierarchie einen Ordner um, hieß er in Eudora danach
  falsch … Für Gregor ist nichts zu tun — GMX und freenet haben eine
  Hierarchie“* und weiter hinten *„**Vorher (bis 26.10.2026):** benannte man
  auf einem IMAP-Server ohne Ordnerhierarchie einen Ordner um, hieß er in
  Eudora danach falsch.“*
* `TESTPLAN.md:74`, N5 (belegt): Gregor prüft genau das Umbenennen unter
  [E-77](../Intern/BEFUNDE.md#e-77)/[E-146](../Intern/BEFUNDE.md#e-146).

Der Satz meint, dass der **alte** Fehler Gregor nicht trifft; gelesen neben N5
klingt er wie „nicht zu testen“. Rest von [L-70.15](LEKTOR-70.md#l-70.15).
**Was zu tun wäre:** den ersten Satz samt *„Für Gregor ist nichts zu tun …“*
streichen; der *Vorher*-Satz genügt.

## <a id="l-71.10"></a>L-71.10 — Hinweis: die README sagt „steht an einer Stelle“ und führt danach eine eigene Auswahl

* `README.md:136-138` (belegt): *„**Neu im Testpaket 7.2.0.123** … steht an
  einer Stelle, im [CHANGELOG unter 7.2.0.123](CHANGELOG.md) — darunter
  [E-137](../Intern/BEFUNDE.md#e-137), [E-146](../Intern/BEFUNDE.md#e-146), [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119), [E-148](../Intern/BEFUNDE.md#e-148), [E-150](../Intern/BEFUNDE.md#e-150), [E-130](../Intern/BEFUNDE.md#e-130),
  [E-154](../Intern/BEFUNDE.md#e-154).“*
* Der CHANGELOG-Abschnitt nennt dazu den Hinweis zu [E-142](../Intern/BEFUNDE.md#e-142), [E-116](../Intern/BEFUNDE.md#e-116), die Logzeile
  zu `rootcerts.p7b` und die Spurmarke zu *„improper argument“*
  ([L-70.13](LEKTOR-70.md#l-70.13)).

Kein Widerspruch, *darunter* sagt „Auswahl“. Aber es ist eine zweite Liste,
die beim nächsten Punkt nicht mitwächst — nach Gregors Regel genau das, was
wegfallen soll. Der Link zielt auf `CHANGELOG.md` ohne Anker.
**Was zu tun wäre:** die Aufzählung streichen, den Link auf den Abschnitt
setzen.

---

## Geprüft, kein Fund

* **Teil 0 A.1–A.3** gegen den Code: siehe oben; die Rückfrage kommt.
* **A.2/A.3, Änderungsdatum statt SHA256:** *Cancel* und *No* schreiben nichts
  in die fremde `Eudora.ini` (`:4304-4308`; bei *No* wird `buf` auf das eigene
  Verzeichnis gesetzt (`:4322` ff.), bevor `GetDirs` läuft (`:4435`)). Ein unverändertes
  Änderungsdatum ist dafür ein gültiges Merkmal.
* **Teil 0 B, `rootcerts.p7b`:** `SSLSettings.cpp:87` setzt die Kandidaten
  *Mailverzeichnis, dann Programmverzeichnis*; `ProtokolliereRootCertsVerzeichnis`
  (`QCWorkerSocket.cpp:1977-1993`) schreibt den vollen Pfad der Datei mit
  *„(vorhanden)“*. Die erwartete Zeile in `TESTPLAN.md:111` passt im Wortlaut.
  Dass `ExecutableDir` dort in Langform steht, ist Vermutung (`GetModuleFileName`,
  `fileutil.cpp:435-441`, gestartet über `%~dp0`).
* **N1b gegen `mainfrm.cpp:3432-3445`:** *File → Close* ist `ID_FILE_CLOSE`
  wie Strg+W und schreibt dieselbe Spurmarke `E-137 Strg-W: …`; die
  Protokollzeile *„`E-137 Strg-W` aus N1/N1b/N2“* stimmt. Die
  E-142-Spurmarke `tocdoc.cpp:2791` passt zu *„`E-142 Hinweis … antwort=nein`“*.
* **`Releases/PAKETE.md` Abschnitt 1.0.123** gegen `efc42028`: Uhrzeit, ZIP-Größe
  und Prüfsumme stehen wortgleich in der Commit-Nachricht; *„leer bis auf
  `Eudora.ini` mit `LogLevel=58527`“* passt zu `paket-bauen.ps1:620-630`.
* **`ZIEL.md` „Neun Kriterien“** (`:203-207`) gegen 2a (`:195`) und Kriterium 4
  (`:197`): beide nennen nur noch die Meldung als offen; kein Widerspruch.
* **README-Stand** (`:99`) gegen `VERSION`, `Version.h`, `PAKETE.md`: 7.2.0.123 /
  1.0.123, veröffentlicht `v1.0.120`, stimmt.
* **[E-139](../Intern/BEFUNDE.md#e-139)** (`BEFUNDE.md:389`): Titel und Messung im Text sagen jetzt dasselbe.

## Nicht geprüft

* Die `DEudora.ini` und die Vorgabe-`Eudora.ini` in Gregors Testverzeichnis
  1.0.123 (ob ein Konto oder `SeenIntro` darin steht) — dort ist nur
  `eudora.log` zu lesen abgesprochen. Dass die `DEudora.ini` keinen Merker
  trägt, ist am Paketbau belegt, nicht an der Datei gemessen.
* Ob Gregors 1.0.122-Mailverzeichnis eine eigene `rootcerts.p7b` hat (Teil 0 B
  behandelt beide Fälle).
* Der CHANGELOG-Abschnitt 7.2.0.123 (seit [LEKTOR-70](LEKTOR-70.md#lektor-70) unverändert).

## Was nur Gregor entscheiden kann

Nichts. Alle Funde sind Berichtigungen an Text und Anleitung, die der
Hauptagent ohne Entscheidung vornehmen kann.
